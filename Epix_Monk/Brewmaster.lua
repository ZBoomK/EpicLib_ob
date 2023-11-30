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
				if (Enum <= 135) then
					if (Enum <= 67) then
						if (Enum <= 33) then
							if (Enum <= 16) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
										elseif (Enum == 2) then
											local A = Inst[2];
											local T = Stk[A];
											for Idx = A + 1, Top do
												Insert(T, Stk[Idx]);
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 6) then
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
										Stk[Inst[2]] = {};
									end
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 10) then
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
									end
								elseif (Enum <= 13) then
									if (Enum == 12) then
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
										local Edx;
										local Results, Limit;
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
										if (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 14) then
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
								elseif (Enum == 15) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 24) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum == 17) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 19) then
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
								elseif (Enum <= 22) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 23) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 28) then
								if (Enum <= 26) then
									if (Enum > 25) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 27) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 30) then
								if (Enum == 29) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 31) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							elseif (Enum > 32) then
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
							end
						elseif (Enum <= 50) then
							if (Enum <= 41) then
								if (Enum <= 37) then
									if (Enum <= 35) then
										if (Enum == 34) then
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
									elseif (Enum == 36) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 39) then
									if (Enum == 38) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum == 40) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 45) then
								if (Enum <= 43) then
									if (Enum > 42) then
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								elseif (Enum == 44) then
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
							elseif (Enum <= 47) then
								if (Enum == 46) then
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
							elseif (Enum <= 48) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 49) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 58) then
							if (Enum <= 54) then
								if (Enum <= 52) then
									if (Enum > 51) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 53) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 56) then
								if (Enum == 55) then
									do
										return Stk[Inst[2]]();
									end
								else
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 57) then
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
						elseif (Enum <= 62) then
							if (Enum <= 60) then
								if (Enum > 59) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 61) then
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
								Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 65) then
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
						elseif (Enum == 66) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 101) then
						if (Enum <= 84) then
							if (Enum <= 75) then
								if (Enum <= 71) then
									if (Enum <= 69) then
										if (Enum > 68) then
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
										else
											Stk[Inst[2]] = Stk[Inst[3]];
										end
									elseif (Enum > 70) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 73) then
									if (Enum == 72) then
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
								elseif (Enum > 74) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 79) then
								if (Enum <= 77) then
									if (Enum > 76) then
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
								elseif (Enum > 78) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 81) then
								if (Enum > 80) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 82) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 83) then
								if (Inst[2] < Inst[4]) then
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
						elseif (Enum <= 92) then
							if (Enum <= 88) then
								if (Enum <= 86) then
									if (Enum > 85) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 87) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 90) then
								if (Enum == 89) then
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum > 91) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 94) then
								if (Enum > 93) then
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
							elseif (Enum > 95) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] <= Stk[Inst[4]]) then
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
						elseif (Enum <= 98) then
							if (Enum == 97) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 99) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 100) then
							local B;
							local A;
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
					elseif (Enum <= 118) then
						if (Enum <= 109) then
							if (Enum <= 105) then
								if (Enum <= 103) then
									if (Enum == 102) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 104) then
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
							elseif (Enum <= 107) then
								if (Enum > 106) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 108) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 113) then
							if (Enum <= 111) then
								if (Enum == 110) then
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
							elseif (Enum > 112) then
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
						elseif (Enum <= 115) then
							if (Enum > 114) then
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
								local T;
								local Edx;
								local Results, Limit;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 116) then
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
							if (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 117) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 126) then
						if (Enum <= 122) then
							if (Enum <= 120) then
								if (Enum > 119) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 121) then
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							elseif (Inst[2] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 124) then
							if (Enum == 123) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
						elseif (Enum == 125) then
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
					elseif (Enum <= 130) then
						if (Enum <= 128) then
							if (Enum == 127) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum > 129) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						end
					elseif (Enum <= 132) then
						if (Enum > 131) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						end
					elseif (Enum <= 133) then
						Stk[Inst[2]] = #Stk[Inst[3]];
					elseif (Enum == 134) then
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
					elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
						Stk[Inst[2]] = Env;
					else
						Stk[Inst[2]] = Env[Inst[3]];
					end
				elseif (Enum <= 203) then
					if (Enum <= 169) then
						if (Enum <= 152) then
							if (Enum <= 143) then
								if (Enum <= 139) then
									if (Enum <= 137) then
										if (Enum > 136) then
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
									elseif (Enum == 138) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 141) then
									if (Enum == 140) then
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
									elseif (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 142) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								if (Enum <= 145) then
									if (Enum == 144) then
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
										Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									end
								elseif (Enum == 146) then
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
							elseif (Enum <= 149) then
								if (Enum == 148) then
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
								end
							elseif (Enum <= 150) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 151) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 160) then
							if (Enum <= 156) then
								if (Enum <= 154) then
									if (Enum > 153) then
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
								elseif (Enum > 155) then
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 158) then
								if (Enum > 157) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 159) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 164) then
							if (Enum <= 162) then
								if (Enum > 161) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Stk[Inst[4]]];
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
						elseif (Enum <= 166) then
							if (Enum > 165) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 167) then
							Env[Inst[3]] = Stk[Inst[2]];
						elseif (Enum > 168) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 186) then
						if (Enum <= 177) then
							if (Enum <= 173) then
								if (Enum <= 171) then
									if (Enum > 170) then
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
								elseif (Enum == 172) then
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
							elseif (Enum <= 175) then
								if (Enum > 174) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum == 176) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 181) then
							if (Enum <= 179) then
								if (Enum == 178) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum > 180) then
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
								Stk[Inst[2]] = #Stk[Inst[3]];
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
						elseif (Enum <= 184) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 185) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
					elseif (Enum <= 194) then
						if (Enum <= 190) then
							if (Enum <= 188) then
								if (Enum == 187) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 192) then
							if (Enum > 191) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum > 193) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 198) then
						if (Enum <= 196) then
							if (Enum > 195) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum > 197) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 200) then
						if (Enum > 199) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 201) then
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
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					elseif (Enum == 202) then
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
				elseif (Enum <= 237) then
					if (Enum <= 220) then
						if (Enum <= 211) then
							if (Enum <= 207) then
								if (Enum <= 205) then
									if (Enum == 204) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum > 206) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 209) then
								if (Enum == 208) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 210) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 215) then
							if (Enum <= 213) then
								if (Enum > 212) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum > 214) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 217) then
							if (Enum == 216) then
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
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 218) then
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
						elseif (Enum > 219) then
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
					elseif (Enum <= 228) then
						if (Enum <= 224) then
							if (Enum <= 222) then
								if (Enum == 221) then
									local B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 223) then
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
						elseif (Enum <= 226) then
							if (Enum == 225) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum == 227) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 232) then
						if (Enum <= 230) then
							if (Enum > 229) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum > 231) then
							local A = Inst[2];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 234) then
						if (Enum > 233) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Inst[2] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
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
					elseif (Enum == 236) then
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
				elseif (Enum <= 254) then
					if (Enum <= 245) then
						if (Enum <= 241) then
							if (Enum <= 239) then
								if (Enum > 238) then
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
							elseif (Enum > 240) then
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
							if (Enum > 242) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum == 244) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 249) then
						if (Enum <= 247) then
							if (Enum == 246) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum > 248) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						else
							local A = Inst[2];
							Stk[A] = Stk[A]();
						end
					elseif (Enum <= 251) then
						if (Enum == 250) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 253) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Stk[Inst[2]] <= Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 263) then
					if (Enum <= 258) then
						if (Enum <= 256) then
							if (Enum > 255) then
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
						elseif (Enum == 257) then
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
					elseif (Enum <= 260) then
						if (Enum == 259) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 261) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 262) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 267) then
					if (Enum <= 265) then
						if (Enum > 264) then
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
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum > 266) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 269) then
					if (Enum > 268) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 270) then
					do
						return Stk[Inst[2]];
					end
				elseif (Enum == 271) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503183O00F4D3D23DD996C810DAFCF937E3ACCA1FC2D7DE37A8B7D21F03083O007EB1A3BB4586DBA703183O00C0AD5E28F019EAB35C0FED26E0AA5A31DC20E0AF193CDA3503063O005485DD3750AF002E3O0012B33O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100043A3O000A0001001287000300063O0020B2000400030007001287000500083O0020B2000500050009001287000600083O0020B200060006000A0006E300073O000100062O00443O00064O00448O00443O00044O00443O00014O00443O00024O00443O00053O0020B200080003000B0020B200090003000C2O0006000A5O001287000B000D3O0006E3000C0001000100022O00443O000A4O00443O000B4O0044000D00073O00129B000E000E3O00129B000F000F4O00E8000D000F00020006E3000E0002000100032O00443O00074O00443O00094O00443O00084O00B9000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O000A00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00C000076O00AC000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004410003000500012O00C0000300054O0044000400024O0003010300044O00D600036O002E3O00017O000C3O00028O00026O00F03F025O005C9740026O00B340025O00049640025O0052B140025O006EA640025O009C9E40025O00189440025O00E0A440025O00F08640025O0010794001363O00129B000200014O00AE000300043O00269C000200070001000100043A3O0007000100129B000300014O00AE000400043O00129B000200023O0026110002000B0001000200043A3O000B0001002E2O010400020001000300043A3O0002000100129B000500013O00269C0005000C0001000100043A3O000C0001002611000300120001000100043A3O00120001002EE9000500180001000600043A3O0028000100129B000600013O002E54000800210001000700043A3O0021000100269C000600210001000100043A3O002100012O00C000076O0032000400073O00067D000400200001000100043A3O002000012O00C0000700014O004400086O007A00096O00E600076O00D600075O00129B000600023O002E2O010900130001000A00043A3O0013000100269C000600130001000200043A3O0013000100129B000300023O00043A3O0028000100043A3O001300010026110003002C0001000200043A3O002C0001002E2O010B000B0001000C00043A3O000B00012O0044000600044O007A00076O00E600066O00D600065O00043A3O000B000100043A3O000C000100043A3O000B000100043A3O0035000100043A3O000200012O002E3O00017O00553O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F958B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C030A3O009643C5B4336320C4B75A03083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O001CD525843A03043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903073O0047657454696D65030D3O00556E69744865616C74684D617803043O00E5212E8B03073O009CA84E40E0D479030A3O0025FCA0D90AEFB6DA02FC03043O00AE678EC503043O007B27513303073O009836483F58453E030A3O00F6D6EB4BD9C5FD48D1D603043O003CB4A48E03043O0075510B2203073O0072383E6549478D030A3O009AFBDED3B5E8C8D0BDFB03043O00A4D889BB03113O00F3EA36B7B2F60AC0D624A8BCF20EF0E92903073O006BB28651D2C69E03023O00494403073O001C0483D4BF2D0003053O00CA586EE2A603073O00E0008FFAC5CD1C03053O00AAA36FE29703083O003426B72A5738271403073O00497150D2582E5703073O00A223C01FE88F3F03053O0087E14CAD7203043O0037E2B6BB03073O00C77A8DD8D0CCDD03103O005265676973746572466F724576656E7403243O0004A78B6532AD2E2009A5866936B7222000A7966D28A12B3111AD90623BAB39310BA39A6803083O007045E4DF2C64E87103143O00476574496E76656E746F72794974656D4C696E6B03063O00C41306CAB36E03073O00E6B47F67B3D61C026O003040034O0003123O004973457175692O7065644974656D5479706503083O00B812500BCC40EE8803073O0080EC653F26842103183O009D5498B9169F479CB106844894A51D99479AA812835F9CA403053O0053CD18D9E003063O0053657441504C025O00C07040004D013O0027000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000400134O00145O00122O001500203O00122O001600216O0014001600024O0014000F00142O003C00155O00122O001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400154O00155O00122O001600263O00122O001700276O0015001700024O0015000F00154O00165O00122O001700283O00122O001800296O0016001800024O0015001500162O00A500165O00122O0017002A3O00122O0018002B6O0016001800024O0015001500160012DC0016002C3O00122O0017002D6O00188O00198O001A8O001B8O001C00374O003C00385O00122O0039002E3O00122O003A002F6O0038003A00024O0038000C00384O00395O00122O003A00303O00122O003B00316O0039003B00024O0038003800394O00395O00122O003A00323O00122O003B00336O0039003B00024O0039000E00394O003A5O00122O003B00343O00122O003C00356O003A003C00024O00390039003A2O00A5003A5O00122O003B00363O00122O003C00376O003A003C00024O003A0011003A2O00A5003B5O00122O003C00383O00122O003D00396O003B003D00024O003A003A003B2O0006003B00014O00A5003C5O00122O003D003A3O00122O003E003B6O003C003E00024O003C0039003C002008013C003C003C2O0018003C000200022O00A5003D5O00122O003E003D3O00122O003F003E6O003D003F00024O003D0039003D002008013D003D003C2O00F4003D003E4O0002003B3O00012O00AE003C003F4O003C00405O00122O0041003F3O00122O004200406O0040004200024O0040000F00404O00415O00122O004200413O00122O004300426O0041004300024O0040004000414O00415O00122O004200433O00122O004300446O0041004300024O0041000F00414O00425O00122O004300453O00122O004400466O0042004400024O0041004100420006E300423O000100032O00443O00404O00C08O00443O00133O0020080143000400470006E300450001000100012O00443O00424O003D00465O00122O004700483O00122O004800496O004600486O00433O000100122O0043004A6O00445O00122O0045004B3O00122O0046004C6O00440046000200122O0045004D6O00430045000200062O004300C90001000100043A3O00C9000100129B0043004E3O0012870044004F4O00C900455O00122O004600503O00122O004700516O004500476O00443O000200202O0045000400470006E300470002000100032O00443O00434O00C08O00443O00444O00B500485O00122O004900523O00122O004A00536O0048004A6O00453O00010006E300450003000100042O00443O00404O00443O003B4O00443O00074O00443O00383O0006E300460004000100032O00443O00074O00443O00384O00C07O0006E300470005000100052O00443O00384O00C08O00443O00124O00443O00084O00443O00363O0006E300480006000100182O00443O00384O00C08O00443O00344O00443O00074O00443O00354O00443O00124O00443O00394O00443O001F4O00443O00204O00443O003A4O00443O001C4O00443O001E4O00443O001D4O00443O002C4O00443O002D4O00443O002E4O00443O002F4O00443O002B4O00C03O00014O00443O00174O00C03O00024O00443O00464O00443O00294O00443O002A3O0006E3004900070001001D2O00443O00374O00C08O00443O002D4O00443O002B4O00443O002C4O00443O00364O00443O00344O00443O00354O00443O00224O00443O00234O00443O00244O00443O00284O00443O00294O00443O002A4O00443O001C4O00443O001D4O00443O001E4O00443O00214O00443O001F4O00443O00204O00443O00304O00443O002E4O00443O002F4O00443O00274O00443O00254O00443O00264O00443O00314O00443O00324O00443O00333O0006E3004A0008000100232O00443O00194O00C08O00443O001A4O00443O00494O00443O00184O00443O001B4O00443O003C4O00443O00074O00443O003D4O00443O003E4O00443O003F4O00443O00084O00443O00214O00443O00384O00443O00404O00443O00124O00443O00474O00C03O00014O00C03O00024O00443O000A4O00443O003A4O00443O00484O00443O00234O00443O00364O00443O00324O00443O00374O00443O00394O00443O00454O00443O00044O00443O00314O00443O00334O00443O00244O00443O00094O00443O00304O00443O00283O0006E3004B0009000100032O00443O00424O00443O000F4O00C07O0020AA004C000F005400122O004D00556O004E004A6O004F004B6O004C004F00016O00013O000A3O00053O0003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD709018030A3O004D657267655461626C6503183O0044697370652O6C61626C65506F69736F6E446562752O667303193O0044697370652O6C61626C6544697365617365446562752O6673000E4O001F9O00000100013O00122O000200013O00122O000300026O0001000300024O000200023O00202O0002000200034O00035O00202O0003000300044O00045O00202O0004000400054O0002000400026O000100026O00019O003O00034O00C08O00C33O000100012O002E3O00017O000C3O00028O00026O00F03F03143O00476574496E76656E746F72794974656D4C696E6B03063O00BCA5105DB3F903073O00AFCCC97124D68B026O003040034O0003123O004973457175692O7065644974656D5479706503083O0073DB3A912C46C23103053O006427AC55BC025O00EEA040025O00C4AA4000293O00129B3O00014O00AE000100023O00269C3O00200001000200043A3O00200001000E2C000100040001000100043A3O0004000100129B000200013O00269C000200070001000100043A3O00070001001287000300034O0093000400013O00122O000500043O00122O000600056O00040006000200122O000500066O00030005000200062O000300130001000100043A3O0013000100129B000300074O00BF00035O0012F2000300086O000400013O00122O000500093O00122O0006000A6O000400066O00033O00024O000300023O00044O0028000100043A3O0007000100043A3O0028000100043A3O0004000100043A3O002800010026113O00240001000100043A3O00240001002E2O010C00020001000B00043A3O0002000100129B000100014O00AE000200023O00129B3O00023O00043A3O000200012O002E3O00017O00113O00028O00025O00E08740025O00AAA940026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B657403063O0042752O66557003103O00426F6E65647573744272657742752O66030E3O00576561706F6E734F664F72646572030B3O00426C2O6F646C7573745570026O004440025O0086A340025O00A08540025O0045B34003103O0048616E646C65546F705472696E6B6574025O00A4A840025O00A8A140004B3O00129B3O00013O002E54000200250001000300043A3O0025000100269C3O00250001000400043A3O002500012O00C000015O0020C20001000100064O000200016O000300023O00202O0003000300074O000500033O00202O0005000500084O00030005000200062O000300190001000100043A3O001900012O00C0000300023O0020310003000300074O000500033O00202O0005000500094O00030005000200062O000300190001000100043A3O001900012O00C0000300023O00200801030003000A2O001800030002000200129B0004000B4O00AE000500054O00E80001000500020012A7000100053O002EE9000C002D0001000C00043A3O004A0001001287000100053O0006550001004A00013O00043A3O004A0001001287000100054O000E2O0100023O00043A3O004A00010026113O00290001000100043A3O00290001002E2O010E00010001000D00043A3O000100012O00C000015O0020C200010001000F4O000200016O000300023O00202O0003000300074O000500033O00202O0005000500084O00030005000200062O0003003D0001000100043A3O003D00012O00C0000300023O0020310003000300074O000500033O00202O0005000500094O00030005000200062O0003003D0001000100043A3O003D00012O00C0000300023O00200801030003000A2O001800030002000200129B0004000B4O0057000500056O00010005000200122O000100053O00122O000100053O00062O000100460001000100043A3O00460001002E2O011000480001001100043A3O00480001001287000100054O000E2O0100023O00129B3O00043O00043A3O000100012O002E3O00017O003D3O00028O00025O009AA440025O009AA840026O00F03F027O0040025O0030AF40025O00CEA240025O00ACA640025O00FBB240025O003C9A40025O0007B140025O00E49D40025O003EB240030B3O005374612O67657246752O6C025O003CA640025O00788B40025O00ECB140026O000840025O00B07540025O0022A040025O007C9440025O0012A54003063O0042752O665570030C3O004C696768745374612O676572025O003AA540025O00A6AD40030C3O00CACCCA35F2F6D93CE1C2C82F03043O005D86A5AD030F3O004D6F6465726174655374612O676572030F3O0093FDC5C728CFA67B8DE6C0C53DCBA003083O001EDE92A1A25AAED2030C3O0048656176795374612O676572030C3O00CD4B711CFC7D640BE249751803043O006A852E10025O00E49040025O00707840025O00405E40025O00DCAA40025O00C05140025O00749E40030A3O00446562752O66496E666F03063O00482F7AF24E5303063O00203840139C3A025O009EB040025O00F8A840025O00ECA340025O0030A340025O0050B040025O00F89140025O00F8AA40025O004C9D40025O00A4A140025O00549240025O00804440030D3O006ADDF75F5CEB8954CFC7445FE503073O00E03AA885363A9203113O00436861726765734672616374696F6E616C02CD5OCCFC3F03083O00446562752O665570026O004C40025O0010A94000FF3O00129B3O00014O00AE000100053O000E790001000600013O00043A3O00060001002E54000300090001000200043A3O0009000100129B000100014O00AE000200023O00129B3O00043O0026113O000D0001000500043A3O000D0001002E54000600F70001000700043A3O00F700012O00AE000500053O002611000100120001000100043A3O00120001002E54000900150001000800043A3O0015000100129B000200014O00AE000300033O00129B000100043O00269C000100190001000400043A3O001900012O00AE000400053O00129B000100053O00269C0001000E0001000500043A3O000E0001002E54000A00370001000B00043A3O0037000100269C000200370001000100043A3O0037000100129B000600013O00269C000600240001000400043A3O0024000100129B000200043O00043A3O00370001002E54000C00200001000D00043A3O0020000100269C000600200001000100043A3O002000012O00C000075O00200801070007000E2O00180007000200020006DD0003002E0001000700043A3O002E000100129B000300013O00269C000300350001000100043A3O00350001002E54000F00330001001000043A3O0033000100043A3O003500012O007B00076O000E010700023O00129B000600043O00043A3O00200001002EE9001100700001001100043A3O00A7000100269C000200A70001000500043A3O00A7000100129B000600014O00AE000700073O00269C0006003D0001000100043A3O003D000100129B000700013O00269C000700440001000400043A3O0044000100129B000200123O00043A3O00A70001002611000700480001000100043A3O00480001002EE9001300FAFF2O001400043A3O0040000100129B000800013O0026110008004D0001000100043A3O004D0001002E540016009D0001001500043A3O009D00012O00C000095O0020310009000900174O000B00013O00202O000B000B00184O0009000B000200062O000900560001000100043A3O00560001002E54001A005D0001001900043A3O005D00012O00C0000900014O0030000A00023O00122O000B001B3O00122O000C001C6O000A000C00024O00050009000A00044O007800012O00C000095O0020BB0009000900174O000B00013O00202O000B000B001D4O0009000B000200062O0009006B00013O00043A3O006B00012O00C0000900014O0030000A00023O00122O000B001E3O00122O000C001F6O000A000C00024O00050009000A00044O007800012O00C000095O0020BB0009000900174O000B00013O00202O000B000B00204O0009000B000200062O0009007800013O00043A3O007800012O00C0000900014O00A5000A00023O00122O000B00213O00122O000C00226O000A000C00024O00050009000A00067D0005007C0001000100043A3O007C0001002E540023009C0001002400043A3O009C000100129B000900014O00AE000A000B3O002611000900820001000400043A3O00820001002E54002600960001002500043A3O00960001002E54002700820001002800043A3O0082000100269C000A00820001000100043A3O008200012O00C0000C5O0020D7000C000C00294O000E00056O000F8O001000016O000C001000024O000B000C6O000C00023O00122O000D002A3O00122O000E002B6O000C000E00024O000C000B000C00202O0004000C000500044O009C000100043A3O0082000100043A3O009C0001000E2C0001007E0001000900043A3O007E000100129B000A00014O00AE000B000B3O00129B000900043O00043A3O007E000100129B000800043O002EE9002C00ACFF2O002C00043A3O0049000100269C000800490001000400043A3O0049000100129B000700043O00043A3O0040000100043A3O0049000100043A3O0040000100043A3O00A7000100043A3O003D0001000E2C000400C20001000200043A3O00C2000100129B000600013O002E2O012E00B00001002D00043A3O00B00001000E2C000400B00001000600043A3O00B0000100129B000200053O00043A3O00C20001002E54002F00AA0001003000043A3O00AA000100269C000600AA0001000100043A3O00AA000100129B000700013O00269C000700B90001000400043A3O00B9000100129B000600043O00043A3O00AA0001000E79000100BD0001000700043A3O00BD0001002EE9003100FAFF2O003200043A3O00B5000100129B000400014O00AE000500053O00129B000700043O00043A3O00B5000100043A3O00AA0001002E540033001B0001003400043A3O001B000100269C0002001B0001001200043A3O001B000100129B000600013O00269C000600C70001000100043A3O00C7000100129B000700013O00269C000700CA0001000100043A3O00CA0001002E54003600EF0001003500043A3O00EF00012O00C0000800014O0060000900023O00122O000A00373O00122O000B00386O0009000B00024O00080008000900202O0008000800394O000800020002000E2O003A00EF0001000800043A3O00EF00012O00C000085O00203100080008003B4O000A00013O00202O000A000A00204O0008000A000200062O000800ED0001000100043A3O00ED00012O00C000085O00203100080008003B4O000A00013O00202O000A000A001D4O0008000A000200062O000800ED0001000100043A3O00ED00012O00C000085O0020BB00080008003B4O000A00013O00202O000A000A00184O0008000A000200062O000800EF00013O00043A3O00EF00012O007B000800014O000E010800024O007B00086O000E010800023O00043A3O00CA000100043A3O00C7000100043A3O001B000100043A3O00FE000100043A3O000E000100043A3O00FE00010026113O00FB0001000400043A3O00FB0001002E2O013D00020001003C00043A3O000200012O00AE000300043O00129B3O00053O00043A3O000200012O002E3O00017O003E3O00028O00026O00F03F025O00D9B040025O005AAA40027O0040025O008DB140025O0062A140025O0040A840025O0028A84003083O00095D30EBD315F52A03073O0086423857B8BE7403073O0049735265616479025O00B8AB40025O0034A84003083O004B6567536D61736803093O004973496E52616E6765026O00444003153O0037340E840AE62026347119A91CE82E383E301DFB4103083O00555C5169DB798B412O033O0076796803083O006B39362B9D15E6E703043O00F98405FD03073O00AFBBEB7195D9BC025O0068A940025O00707F40025O007DB240025O0024A04003053O001FA3805FEB03073O00185CCFE12C8319026O002040026O003E40025O00BAAB40025O00A08C4003053O00436C61736803113O0048DFB95F133D5BC1BD4F147049D2AC0C4303063O001D2BB3D82C7B03083O009ED1296EA8CB335803043O002CDDB940030A3O00436F76656E616E744944026O00084003083O004368694275727374030E3O004973496E4D656C2O6552616E676503153O0002EF41607114F55B4B3311F54D5C7C0CE5494B335703053O00136187283F025O001AA140025O00A06E40025O00B49540025O00AAAE40025O0049B040025O0012A84003073O008D543A0C2E27AB03063O0051CE3C535B4F03073O004368695761766503153O004DA3D94D38C25BA10EBBC2772CCC40A64FBF90237F03083O00C42ECBB0124FA32D030F3O008A376D162DF5E892237A1B13F2E1BC03073O008FD8421E7E449B030F3O0052757368696E674A61646557696E64031D3O00B8DD1EC3CCADD0DEA0C909CEFAB4DEEFAE881DD9C0A0D8ECA8C9198B9103083O0081CAA86DABA5C3B7025O00D07540025O00F08B4000DD3O00129B3O00014O00AE000100023O00269C3O00070001000100043A3O0007000100129B000100014O00AE000200023O00129B3O00023O002E54000400020001000300043A3O0002000100269C3O00020001000200043A3O0002000100269C0001000B0001000100043A3O000B000100129B000200013O000E79000500120001000200043A3O00120001002EE9000600210001000700043A3O00310001002E2O010900DC0001000800043A3O00DC00012O00C000036O0097000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300DC00013O00043A3O00DC0001002E54000E00DC0001000D00043A3O00DC00012O00C0000300024O006F00045O00202O00040004000F4O000500033O00202O00050005001000122O000700116O0005000700024O000500056O00030005000200062O000300DC00013O00043A3O00DC00012O00C0000300013O00120C000400123O00122O000500136O000300056O00035O00044O00DC000100269C000200870001000100043A3O008700012O00C0000300044O009E000400013O00122O000500143O00122O000600156O00040006000200062O000300430001000400043A3O004300012O00C0000300044O009E000400013O00122O000500163O00122O000600176O00040006000200062O000300430001000400043A3O00430001002EE9001800270001001900043A3O00680001002E54001B00680001001A00043A3O006800012O00C000036O0097000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006800013O00043A3O006800012O00C0000300033O00200801030003001000129B0005001E4O00E800030005000200067D000300680001000100043A3O006800012O00C0000300033O00200801030003001000129B0005001F4O00E80003000500020006550003006800013O00043A3O00680001002E2O012100680001002000043A3O006800012O00C0000300024O00C000045O0020B20004000400222O00180003000200020006550003006800013O00043A3O006800012O00C0000300013O00129B000400233O00129B000500244O0003010300054O00D600036O00C000036O0097000400013O00122O000500253O00122O000600266O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003008600013O00043A3O00860001001287000300273O002611000300860001002800043A3O008600012O00C0000300024O006E00045O00202O0004000400294O000500033O00202O00050005002A00122O0007001E6O0005000700024O000500056O000600016O00030006000200062O0003008600013O00043A3O008600012O00C0000300013O00129B0004002B3O00129B0005002C4O0003010300054O00D600035O00129B000200023O0026110002008B0001000200043A3O008B0001002E2O012D000E0001002E00043A3O000E000100129B000300013O002611000300900001000100043A3O00900001002E54003000D20001002F00043A3O00D2000100129B000400013O002E2O013200CB0001003100043A3O00CB000100269C000400CB0001000100043A3O00CB00012O00C000056O0097000600013O00122O000700333O00122O000800346O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500B000013O00043A3O00B000012O00C0000500024O006E00065O00202O0006000600354O000700033O00202O00070007002A00122O0009001E6O0007000900024O000700076O000800016O00050008000200062O000500B000013O00043A3O00B000012O00C0000500013O00129B000600363O00129B000700374O0003010500074O00D600056O00C000056O0097000600013O00122O000700383O00122O000800396O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500CA00013O00043A3O00CA00012O00C0000500024O006F00065O00202O00060006003A4O000700033O00202O00070007002A00122O0009001E6O0007000900024O000700076O00050007000200062O000500CA00013O00043A3O00CA00012O00C0000500013O00129B0006003B3O00129B0007003C4O0003010500074O00D600055O00129B000400023O002E2O013D00910001003E00043A3O0091000100269C000400910001000200043A3O0091000100129B000300023O00043A3O00D2000100043A3O0091000100269C0003008C0001000200043A3O008C000100129B000200053O00043A3O000E000100043A3O008C000100043A3O000E000100043A3O00DC000100043A3O000B000100043A3O00DC000100043A3O000200012O002E3O00017O00643O00028O00025O00D88640025O0044A740026O000840030C3O0074B3C7BD45A9C49651BDC8B803043O00DB30DAA1030A3O0049734361737461626C6503103O004865616C746850657263656E74616765025O00E08B40025O0068AE40030C3O0044692O667573654D61676963030D3O00C0787A4FCE5CE5A45C7D4ED24C03073O008084111C29BB2F030B3O00293707364909211235530403053O003D6152665A03073O0049735265616479030B3O004865616C746873746F6E65025O0072B140025O00208C4003173O00A42BAA47D35F0D1DA320AE0BC352180CA23DA25DC2174D03083O0069CC4ECB2BA7377E026O00F03F026O00104003193O0097AF250C1617CF58ABAD63361605CB58ABAD632E1C10CE5EAB03083O0031C5CA437E7364A703173O00055ED93B8545563E55D8018557523E55D8198F4257385503073O003E573BBF49E036025O0048A040025O0090A64003173O0052656672657368696E674865616C696E67506F74696F6E03253O00F507FCDBE211F2C0E905BAC1E203F6C0E905BAD9E816F3C6E942FECCE107F4DAEE14FF89B303043O00A987629A025O00F07D40025O001C9D40027O0040030E3O009C5BA454B352AF49B4539452BF4303043O0020DA34D603083O0042752O66446F776E030E3O0044616D70656E4861726D42752O66030E3O00466F7274696679696E6742726577025O00F8A240025O008CAF40030F3O00681823BCF8B65C534010718AE3B55203083O003A2E7751C891D025030D3O000389312OA0B3310E8039B4A0AF03073O00564BEC50CCC9DD025O007CA640025O00A2A640030D3O004865616C696E67456C69786972025O004AA340025O00B8AC4003133O005A447689F78575015289F7937B5337A7EC8E6503063O00EB122117E59E025O00206D40025O00707E40025O0052A340025O00206940025O0018B040025O00A0604003093O007E36A45341732FA65B03053O002D3B4ED436026O005440025O0010A840025O00089F4003093O00457870656C4861726D030A3O00354E938E8A6E85F1025B03083O00907036E3EBE64ECD030A3O00972902ECD5559B291DF103063O003BD3486F9CB003123O00466F7274696679696E674272657742752O66025O00804140030A3O0044616D70656E4861726D025O007C9640025O00A4AB40030B3O006A86EE3D4B89A3054F95EE03043O004D2EE783025O00307A40026O001C40025O0008A640030D3O00DEB65C406FCBF4B25C676EDAEA03063O00BF9DD330251C03113O00426C61636B6F7574436F6D626F42752O6603133O00496E636F6D696E6744616D61676554616B656E025O003C9F4003063O00CF13F5053FCD03053O005ABF7F947C029A5O99B93F03153O005374612O6765724C6173745469636B44616D61676503093O0042752O66537461636B03123O00456C7573697665427261776C657242752O66030D3O0043656C65737469616C42726577030E3O005B8222126B93271674C70C057D9003043O007718E74E030D3O00B238B743DA59188C2A8758D95703073O0071E24DC52ABC20025O000AB140025O008EAB40030D3O00507572696679696E6742726577030E3O000A03E6BC3C0FFDBB3D56D6A73F0103043O00D55A769400B0012O00129B3O00014O00AE000100013O002E2O010200020001000300043A3O00020001000E2C0001000200013O00043A3O0002000100129B000100013O00269C000100540001000400043A3O0054000100129B000200013O00269C0002004F0001000100043A3O004F00012O00C000036O0097000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003001F00013O00043A3O001F00012O00C0000300023O0006550003001F00013O00043A3O001F00012O00C0000300033O0020080103000300082O00180003000200022O00C0000400043O00065A000300030001000400043A3O00210001002E54000A002C0001000900043A3O002C00012O00C0000300054O00C000045O0020B200040004000B2O00180003000200020006550003002C00013O00043A3O002C00012O00C0000300013O00129B0004000C3O00129B0005000D4O0003010300054O00D600036O00C0000300064O0097000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003004E00013O00043A3O004E00012O00C0000300073O0006550003004E00013O00043A3O004E00012O00C0000300033O0020080103000300082O00180003000200022O00C0000400083O0006A10003004E0001000400043A3O004E00012O00C0000300054O0009000400093O00202O0004000400114O000500066O000700016O00030007000200062O000300490001000100043A3O00490001002EE9001200070001001300043A3O004E00012O00C0000300013O00129B000400143O00129B000500154O0003010300054O00D600035O00129B000200163O000E2C0016000A0001000200043A3O000A000100129B000100173O00043A3O0054000100043A3O000A000100269C000100800001001700043A3O008000012O00C00002000A3O000655000200AF2O013O00043A3O00AF2O012O00C0000200033O0020080102000200082O00180002000200022O00C00003000B3O0006A1000200AF2O01000300043A3O00AF2O012O00C00002000C4O00CF000300013O00122O000400183O00122O000500196O00030005000200062O000200AF2O01000300043A3O00AF2O012O00C0000200064O000D010300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200104O00020002000200062O000200720001000100043A3O00720001002E2O011D00AF2O01001C00043A3O00AF2O012O00C0000200054O00A6000300093O00202O00030003001E4O000400056O000600016O00020006000200062O000200AF2O013O00043A3O00AF2O012O00C0000200013O00120C0003001F3O00122O000400206O000200046O00025O00044O00AF2O01002E54002100DC0001002200043A3O00DC000100269C000100DC0001002300043A3O00DC000100129B000200014O00AE000300033O00269C000200860001000100043A3O0086000100129B000300013O00269C000300D50001000100043A3O00D500012O00C000046O0097000500013O00122O000600243O00122O000700256O0005000700024O00040004000500202O0004000400074O00040002000200062O000400B200013O00043A3O00B200012O00C00004000D3O000655000400B200013O00043A3O00B200012O00C0000400033O0020BB0004000400264O00065O00202O0006000600274O00040006000200062O000400B200013O00043A3O00B200012O00C0000400033O0020080104000400082O00180004000200022O00C00005000E3O0006A1000400B20001000500043A3O00B200012O00C0000400054O00C000055O0020B20005000500282O001800040002000200067D000400AD0001000100043A3O00AD0001002E2O012A00B20001002900043A3O00B200012O00C0000400013O00129B0005002B3O00129B0006002C4O0003010400064O00D600046O00C000046O0097000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400C500013O00043A3O00C500012O00C00004000F3O000655000400C500013O00043A3O00C500012O00C0000400033O0020080104000400082O00180004000200022O00C0000500103O00065A000400030001000500043A3O00C70001002E54003000D40001002F00043A3O00D400012O00C0000400054O00C000055O0020B20005000500312O001800040002000200067D000400CF0001000100043A3O00CF0001002E54003300D40001003200043A3O00D400012O00C0000400013O00129B000500343O00129B000600354O0003010400064O00D600045O00129B000300163O00269C000300890001001600043A3O0089000100129B000100043O00043A3O00DC000100043A3O0089000100043A3O00DC000100043A3O0086000100269C000100322O01001600043A3O00322O0100129B000200014O00AE000300033O002E54003600E00001003700043A3O00E0000100269C000200E00001000100043A3O00E0000100129B000300013O002E2O013900EB0001003800043A3O00EB000100269C000300EB0001001600043A3O00EB000100129B000100233O00043A3O00322O0100269C000300E50001000100043A3O00E50001002E2O013B000B2O01003A00043A3O000B2O012O00C000046O0097000500013O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500202O0004000400074O00040002000200062O0004000B2O013O00043A3O000B2O012O00C0000400033O0020080104000400082O00180004000200020026FE0004000B2O01003E00043A3O000B2O01002E2O0140000B2O01003F00043A3O000B2O012O00C0000400054O00C000055O0020B20005000500412O00180004000200020006550004000B2O013O00043A3O000B2O012O00C0000400013O00129B000500423O00129B000600434O0003010400064O00D600046O00C000046O0097000500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002E2O013O00043A3O002E2O012O00C0000400033O0020BB0004000400264O00065O00202O0006000600464O00040006000200062O0004002E2O013O00043A3O002E2O012O00C0000400033O0020080104000400082O00180004000200020026FE0004002E2O01004700043A3O002E2O012O00C0000400054O00C000055O0020B20005000500482O001800040002000200067D000400292O01000100043A3O00292O01002E54004A002E2O01004900043A3O002E2O012O00C0000400013O00129B0005004B3O00129B0006004C4O0003010400064O00D600045O00129B000300163O00043A3O00E5000100043A3O00322O0100043A3O00E0000100269C000100070001000100043A3O0007000100129B000200013O002611000200392O01001600043A3O00392O01002E54004D003B2O01004E00043A3O003B2O0100129B000100163O00043A3O0007000100269C000200352O01000100043A3O00352O01002EE9004F00490001004F00043A3O00862O012O00C000036O0097000400013O00122O000500503O00122O000600516O0004000600024O00030003000400202O0003000300074O00030002000200062O000300862O013O00043A3O00862O012O00C0000300113O000655000300862O013O00043A3O00862O012O00C0000300033O0020BB0003000300264O00055O00202O0005000500524O00030005000200062O000300862O013O00043A3O00862O012O00C0000300033O00205200030003005300122O000500546O0003000500024O000400126O000500136O000600013O00122O000700553O00122O000800566O000600086O00053O000200202O0005000500574O000600033O00202O00060006005800122O000800176O000600086O00043O00024O000500146O000600136O000700013O00122O000800553O00122O000900566O000700096O00063O000200202O0006000600574O000700033O00202O00070007005800122O000900176O000700096O00053O00024O00040004000500062O000400862O01000300043A3O00862O012O00C0000300033O0020DE0003000300594O00055O00202O00050005005A4O00030005000200262O000300862O01002300043A3O00862O012O00C0000300054O00C000045O0020B200040004005B2O0018000300020002000655000300862O013O00043A3O00862O012O00C0000300013O00129B0004005C3O00129B0005005D4O0003010300054O00D600036O00C000036O0097000400013O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009D2O013O00043A3O009D2O012O00C0000300154O00F80003000100020006550003009D2O013O00043A3O009D2O012O00C0000300163O0006550003009D2O013O00043A3O009D2O012O00C0000300033O0020080103000300082O00180003000200022O00C0000400173O00065A000300030001000400043A3O009F2O01002E2O016000AA2O01006100043A3O00AA2O012O00C0000300054O00C000045O0020B20004000400622O0018000300020002000655000300AA2O013O00043A3O00AA2O012O00C0000300013O00129B000400633O00129B000500644O0003010300054O00D600035O00129B000200163O00043A3O00352O0100043A3O0007000100043A3O00AF2O0100043A3O000200012O002E3O00017O009C3O00028O00025O006AA440025O00F0A440026O00F03F026O002240025O00289740025O00C0B040030C3O004570696353652O74696E677303083O00E584EB5DD6D886EC03053O00BFB6E19F29030A3O001E012D718186D03E072603073O00A24B724835EBE7026O00144003083O00FEE209EF13C3E00E03053O007AAD877D9B03103O00A2CE12AD3637D18DCF079B2D34DFACF103073O00A8E4A160D95F51026O00184003083O006E7367087AA54A4E03073O002D3D16137C13CB03103O00F40108D6077CBCD20604F40E52ABC40503073O00D9A1726D95621003083O0021252C68B57A153303063O00147240581CDC03113O000412D792F7C2A93807CBBDF6D79F2304C503073O00DD5161B2D498B0026O002040025O003CA340025O004AB14003083O006B1233525119205503043O0026387747030A3O00D0E359C52D63E0EE5FD303063O0036938F38B645034O00025O00A6B24003083O000B0319F931080AFE03043O008D58666D030F3O008640CF54133B53D4A056E7711D345603083O00A1D333AA107A5D3503083O00C8ABA63CF2A0B53B03043O00489BCED2030E3O006273520826557F790F344F797C3E03053O0053261A346E027O0040025O00B08140026O008E4003083O000D3AEDE53731FEE203043O00915E5F99030B3O00D9C407C54BBBDFD812D35D03063O00D79DAD74B52E03083O0006B19FE6D33BB39803053O00BA55D4EB92030F3O00EA8018FA35EB79C4871AF73AFA5DC603073O0038A2E1769E598E025O00BCA640025O00289E4003083O006F00D4BB2BD65B1603063O00B83C65A0CF4203113O00198372B83D8755B2328D6EAC3E9079BD3D03043O00DC51E21C026O000840026O001040026O003340025O00407C40025O00588C40025O00A0A84003083O0085B0F2C4BFBBE1C303043O00B0D6D586030E3O00C1BEB3F6A4575AFF82AEF6BA534E03073O003994CDD6B4C83603083O0021F821207F1CFA2603053O0016729D555403103O00F1D816F448E4A1C2D21ACA5AD4BAC1DC03073O00C8A4AB73A43D9603083O008DF117518AB0F31003053O00E3DE946325030F3O000347402OFF2A5B5CF1DB215745DEC903053O0099532O3296025O0092A340025O0076B14003083O00F8723040F43DCFD803073O00A8AB1744349D5303103O00C162F085202C8BFD7FF29D2A398EFB7F03073O00E7941195CD454D03083O00B3A2D3EF5EF187B403063O009FE0C7A79B3703113O00DFF63DDEFEFD3BE2F8E735DDF9DD3DDFF203043O00B297935C03083O00BFF858261B427D9F03073O001AEC9D2C52722C030F3O00022BD4572320D26B253ADC542406E503043O003B4A4EB5025O00FEAC40025O00BCAF40025O00407A40025O00802O40025O004CAB4003083O00F24726C20CCF452103053O0065A12252B6030D3O00CC044AEEDEEEA62BEA185FF8C803083O004E886D399EBB82E2025O00CC9340025O0088B24003083O0016D42O4EBA2BD64903053O00D345B12O3A030E3O0082F67CDDECCABBF171E6FDC4B9E003063O00ABD78519958903083O00D2CD26EEE63EFB5103083O002281A8529A8F509C030D3O00ADB732075C469A91BD3D0E607E03073O00E9E5D2536B282E025O00F8A240025O0084AD4003083O0028E89245E4333E0803073O00597B8DE6318D5D03113O00D669E6001F4EFA7FF127154DC662F70B1503063O002A9311966C70026O001C4003083O00E8D43A482659DCC203063O0037BBB14E3C4F03103O0018DD5AC343CE8C24C058CE4AC69824DC03073O00E04DAE3F8B26AF03083O00B7444C3A8D4F5F3D03043O004EE42138030F3O00E67BB30F8CC079970F8CD677A02BB503053O00E5AE1ED263025O0004A740025O00F09840025O0051B140025O006EA84003083O008A26BF60B6B142A703083O00D4D943CB142ODF2503123O009383BCD7A89FBDC2AEB9A0C0BF9EA0DDB68903043O00B2DAEDC8025O00CCB040025O005AA54003083O0020D096EFE3C914C603063O00A773B5E29B8A03113O00CB2CF3596963D3F236D0556F79F5F637E903073O00A68242873C1B1103083O00774FDA61394A4DDD03053O0050242AAE1503163O00671E237F5C02226A5A3F397657273F735A153B735D0403043O001A2E705703083O003CA3396BEEE608B503063O00886FC64D1F8703093O00371AA278B4F10DA80D03083O00C96269C736DD847703083O008A0997350B3BABAA03073O00CCD96CE3416255031B3O006DD6F8E823CE69CBFCF129F457C4F0F71FD45FD72OE019D35FC4F003063O00A03EA395854C03083O00E5A5193BCAD8A71E03053O00A3B6C06D4F03113O0016290EC5F1213514E2E72O3135D3F4332303053O0095544660A0000C022O00129B3O00014O00AE000100023O002E2O010200090001000300043A3O00090001000E2C0001000900013O00043A3O0009000100129B000100014O00AE000200023O00129B3O00043O00269C3O00020001000400043A3O0002000100269C0001000B0001000100043A3O000B000100129B000200013O002611000200120001000500043A3O00120001002E2O0107001F0001000600043A3O001F0001001287000300084O00A5000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300042O00A5000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300042O00BF00035O00043A3O000B020100269C000200510001000D00043A3O0051000100129B000300013O00269C000300350001000400043A3O00350001001287000400084O000B010500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O000500013O00122O000600103O00122O000700116O0005000700024O00040004000500062O000400320001000100043A3O0032000100129B000400014O00BF000400023O00129B000200123O00043A3O00510001000E2C000100220001000300043A3O00220001001287000400084O00DB000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000400033O00122O000400086O000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O0004000400054O000400043O00122O000300043O00044O00220001002611000200550001001B00043A3O00550001002E54001D008A0001001C00043A3O008A000100129B000300013O00269C000300690001000400043A3O00690001001287000400084O000B010500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O00040004000500062O000400660001000100043A3O0066000100129B000400224O00BF000400053O00129B000200053O00043A3O008A0001002EE9002300EDFF2O002300043A3O0056000100269C000300560001000100043A3O00560001001287000400084O00BC000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000500013O00122O000600263O00122O000700276O0005000700024O0004000400054O000400063O00122O000400086O000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500062O000400870001000100043A3O0087000100129B000400014O00BF000400073O00129B000300043O00043A3O0056000100269C000200BD0001002C00043A3O00BD000100129B000300013O002E2O012D00AA0001002E00043A3O00AA000100269C000300AA0001000100043A3O00AA0001001287000400084O001A000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000500013O00122O000600313O00122O000700326O0005000700024O0004000400054O000400083O00122O000400086O000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O000500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000400093O00122O000300043O002611000300AE0001000400043A3O00AE0001002E2O0137008D0001003800043A3O008D0001001287000400084O00A5000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400052O00A5000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400052O00BF0004000A3O00129B0002003D3O00043A3O00BD000100043A3O008D0001002611000200C10001003E00043A3O00C10001002E54004000F30001003F00043A3O00F3000100129B000300013O000E79000100C60001000300043A3O00C60001002E54004200DF0001004100043A3O00DF0001001287000400084O001A000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O0004000400054O0004000B3O00122O000400086O000500013O00122O000600473O00122O000700486O0005000700024O0004000400054O000500013O00122O000600493O00122O0007004A6O0005000700024O0004000400054O0004000C3O00122O000300043O00269C000300C20001000400043A3O00C20001001287000400084O000B010500013O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500062O000400EF0001000100043A3O00EF000100129B000400014O00BF0004000D3O00129B0002000D3O00043A3O00F3000100043A3O00C20001002611000200F70001000100043A3O00F70001002E540050002A2O01004F00043A3O002A2O0100129B000300013O00269C000300162O01000100043A3O00162O01001287000400084O00BC000500013O00122O000600513O00122O000700526O0005000700024O0004000400054O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O0004000E3O00122O000400086O000500013O00122O000600553O00122O000700566O0005000700024O0004000400054O000500013O00122O000600573O00122O000700586O0005000700024O00040004000500062O000400142O01000100043A3O00142O0100129B000400224O00BF0004000F3O00129B000300043O00269C000300F80001000400043A3O00F80001001287000400084O000B010500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O000500013O00122O0006005B3O00122O0007005C6O0005000700024O00040004000500062O000400262O01000100043A3O00262O0100129B000400014O00BF000400103O00129B000200043O00043A3O002A2O0100043A3O00F800010026110002002E2O01000400043A3O002E2O01002E54005E006A2O01005D00043A3O006A2O0100129B000300014O00AE000400043O002EE9005F3O0001005F00043A3O00302O0100269C000300302O01000100043A3O00302O0100129B000400013O002611000400392O01000400043A3O00392O01002E2O016100472O01006000043A3O00472O01001287000500084O00A5000600013O00122O000700623O00122O000800636O0006000800024O0005000500062O00A5000600013O00122O000700643O00122O000800656O0006000800024O0005000500062O00BF000500113O00129B0002002C3O00043A3O006A2O010026110004004B2O01000100043A3O004B2O01002EE9006600ECFF2O006700043A3O00352O01001287000500084O00BC000600013O00122O000700683O00122O000800696O0006000800024O0005000500064O000600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000500123O00122O000500086O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000600013O00122O0007006E3O00122O0008006F6O0006000800024O00050005000600062O000500652O01000100043A3O00652O0100129B000500014O00BF000500133O00129B000400043O00043A3O00352O0100043A3O006A2O0100043A3O00302O0100269C000200A12O01001200043A3O00A12O0100129B000300013O002E54007000822O01007100043A3O00822O0100269C000300822O01000400043A3O00822O01001287000400084O000B010500013O00122O000600723O00122O000700736O0005000700024O0004000400054O000500013O00122O000600743O00122O000700756O0005000700024O00040004000500062O0004007F2O01000100043A3O007F2O0100129B000400224O00BF000400143O00129B000200763O00043A3O00A12O0100269C0003006D2O01000100043A3O006D2O01001287000400084O00BC000500013O00122O000600773O00122O000700786O0005000700024O0004000400054O000500013O00122O000600793O00122O0007007A6O0005000700024O0004000400054O000400153O00122O000400086O000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400054O000500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500062O0004009E2O01000100043A3O009E2O0100129B000400014O00BF000400163O00129B000300043O00043A3O006D2O01000E79003D00A52O01000200043A3O00A52O01002E2O017F00D92O01008000043A3O00D92O0100129B000300013O002E54008200BB2O01008100043A3O00BB2O0100269C000300BB2O01000400043A3O00BB2O01001287000400084O000B010500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000500013O00122O000600853O00122O000700866O0005000700024O00040004000500062O000400B82O01000100043A3O00B82O0100129B000400014O00BF000400173O00129B0002003E3O00043A3O00D92O01002E2O018800A62O01008700043A3O00A62O0100269C000300A62O01000100043A3O00A62O01001287000400084O00DB000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400054O000500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400054O000400183O00122O000400086O000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400054O000500013O00122O0006008F3O00122O000700906O0005000700024O0004000400054O000400193O00122O000300043O00044O00A62O0100269C0002000E0001007600043A3O000E0001001287000300084O00BC000400013O00122O000500913O00122O000600926O0004000600024O0003000300044O000400013O00122O000500933O00122O000600946O0004000600024O0003000300044O0003001A3O00122O000300086O000400013O00122O000500953O00122O000600966O0004000600024O0003000300044O000400013O00122O000500973O00122O000600986O0004000600024O00030003000400062O000300F52O01000100043A3O00F52O0100129B000300224O00BF0003001B3O0012E0000300086O000400013O00122O000500993O00122O0006009A6O0004000600024O0003000300044O000400013O00122O0005009B3O00122O0006009C6O0004000600024O00030003000400062O000300040201000100043A3O0004020100129B000300224O00BF0003001C3O00129B0002001B3O00043A3O000E000100043A3O000B020100043A3O000B000100043A3O000B020100043A3O000200012O002E3O00017O00FB012O00028O00025O00DDB240026O00F03F025O004C9A40025O0076B240030C3O004570696353652O74696E677303073O00347C0578470B9903073O00EA6013621F2B6E2O033O0007105703073O00EB667F32A7CC1203073O0064AEF224482B4303063O004E30C19543242O033O00331A9303053O0021507EE078027O0040025O00E3B240025O00AAAC40025O0046A640025O000C9D4003073O00B83343E55F079F03063O0062EC5C2482332O033O00AB160F03083O0050C4796CDA25C8D5025O0010AE40025O0026A24003073O00D8A704C350E9BB03053O003C8CC863A403063O0083FD1736A78B03053O00C2E794644603163O00476574456E656D696573496E4D656C2O6552616E6765026O001440026O002040025O0028A640025O00507D40025O0060A040025O00E08040026O000840025O00DEA840025O00AAA440025O003CA940025O0060AD40030D3O00456E656D696573436F756E7435025O00E8AD40030C3O00497354616E6B696E67416F4503093O00497354616E6B696E67025O00508140030D3O004973446561644F7247686F7374025O0006A440025O00806540030F3O00412O66656374696E67436F6D62617403053O006249D5ACEE03063O00A8262CA1C39603073O0049735265616479025O0062AE40025O002O6040030C3O0053686F756C6452657475726E03093O00466F637573556E6974025O00C07E40025O00E2B140030D3O00546172676574497356616C6964025O0010B040025O00609C40025O00ADB140025O001C9340030A3O00502O6F6C456E65726779030B3O001E8C1F4A69FF208602413003063O00BA4EE3702649025O00089140025O00DBB240025O00E06D40025O00049540025O00FCAC40025O0034AD40025O00FCAD40025O001AA040026O00184003073O002AA5344408BB3803043O001369CD5D030A3O0049734361737461626C6503073O0043686957617665030E3O004973496E4D656C2O6552616E676503103O00AA00D7BE28A81EDBC132A801D0C169FB03053O005FC968BEE103113O009CDBC8C0A1C2CFC98CD92OC0AAE0C8CDA403043O00AECFABA103153O005368616F68616F734D69676874457175692O70656403083O00C6FB0AC0F5D6FEF603063O00B78D9E6D9398030F3O00432O6F6C646F776E52656D61696E732O033O0047434403063O00456E65726779030B3O00456E65726779526567656E03083O00070CE13F2108F50403043O006C4C698603113O00D8D5B8EFC0E2CBB6C2DCEACBB4CAC7E8CE03053O00AE8BA5D181030B3O004578656375746554696D65025O0040504003083O0090A3EBD5C00A627D03083O0018C3D382A1A66310030B3O004973417661696C61626C6503173O004368612O72656450612O73696F6E73457175692O706564025O00908540025O0050924003113O005370692O6E696E674372616E654B69636B025O00E09840025O004EA440031B3O005513E0225D1F4804D62F41174806D6275A154D43E42D5A180655BD03063O00762663894C33025O00ECAB40025O002DB140030F3O00CF33161A002EFA0C04160C17F4280103063O00409D4665726903083O0042752O66446F776E030F3O0052757368696E674A61646557696E6403193O0052BDB4EB194EAF98E91144AD98F4194EACE7EE1149A6E7B64403053O007020C8C783026O001C40025O007EA840025O00C89440026O001040030C3O002E4D36A03746E32A1F4337AB03083O006E7A2243C35F2985030C3O00546F7563686F664465617468025O0078AE40025O0072AC4003163O0061BE4E49DE4ABE5D75D270B04F429678B052449620E303053O00B615D13B2A030C3O009545C01C35B69851E31433BB03063O00DED737A57D41030F3O004368612O72656450612O73696F6E73025O00F09A40030C3O004272656174684F664669726503093O004973496E52616E6765026O00284003163O002E2OC31BE6C9D2452AEEC013E0C4AD472DD8C85AA69303083O002A4CB1A67A92A18D025O00707C40025O00089440030C3O00879800CF6D7E8A8C23C76B7303063O0016C5EA65AE1903113O00426C61636B6F7574436F6D626F42752O66030D3O00426C2O6F646C757374446F776E030B3O00426C2O6F646C7573745570030F3O0042752O665265667265736861626C6503153O004272656174684F6646697265446F74446562752O66025O00FEB140025O000CB34003163O002F26A0DD62A7E8892B0BA3D564AA978B2C3DAB9C23F703083O00E64D54C5BC16CFB7025O00889640025O00A0A44003083O00615D8FD147599BEA03043O00822A38E8026O006140025O00A8AC4003083O004B6567536D617368030E3O0049735370652O6C496E52616E676503113O00E1B023DC5332EBA62CA34D3EE3BB64B71603063O005F8AD544832003093O001E21A646641A29AD4E03053O00164A48C123030D3O000E75E55B2776F14C0F76E95A2303043O00384C198403083O0075C4AC15C25FD2A303053O00AF3EA1CB4603083O0017D8C420383DCECB03053O00555CBDA37303093O00546967657250616C6D03123O003DA5373D3B93203925A1703528A53E787FFA03043O005849CC50025O00E09B40025O00ADB24003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O00E9B140025O00C4A94003093O00496E74652O72757074030F3O00537065617248616E64537472696B65026O00444003183O00537065617248616E64537472696B654D6F7573656F766572026O009A40025O00889A40025O00C6AA40025O0042A640025O0040AC40025O004DB140025O0028AF40025O00805040025O00F08A40025O0024B24003113O00496E74652O72757074576974685374756E03083O004C656753772O6570025O00149340030F3O0048616E646C65412O666C696374656403053O004465746F78030E3O004465746F784D6F7573656F766572025O00804640025O00DC9340030D3O001D57DFB5F478393357CEB1F46903073O006D5C25BCD49A1D026O003F40030D3O00417263616E65546F2O72656E7403163O0005FDA7C23F5F3BFBABD1235F0AFBE4CE30530AAFF29B03063O003A648FC4A351025O004AAE40025O00E8974003063O00D5F9740387C803063O00BC2O961961E603043O00F8864B0A03063O008DBAE93F626C03053O00D2E62DA52D03053O0045918A4CD6026O003E40025O00BEB240025O009C934003053O00436C617368025O00DAA340025O0058A640030E3O0073C3889AB75673C0848BBE02309703063O007610AF2OE9DF03083O00A88C3C99FB996E9F03073O001DEBE455DB8EEB030C3O001BD5BFD17E40226129DBB7CD03083O00325DB4DABD172E4703083O00436869427572737403113O00DDAC527346C95ACDB01B4145D5469EF02O03073O0028BEC43B2C24BC025O00ACA640025O005AAC40025O00B07A40025O0018AB4003093O009A79EDFA899E60F0EC03053O00EDD8158295025O005EB040025O00E8A54003093O00426C2O6F644675727903113O0080422O50B4F658975C461FBDC8578C0E0903073O003EE22E2O3FD0A9025O004CA040030A3O00C71C47901A1F2457EB1E03083O003E857935E37F6D4F030A3O004265727365726B696E6703113O00121120E6D3BCA9191A35B5DBAFAB1E546A03073O00C270745295B6CE030E3O0015A14B10D4F1242CAC4B15C5EC1A03073O006E59C82C78A082030E3O004C69676874734A7564676D656E7403173O00A7CA4C4E57590447BEC74C4B46442F0DA6C24248031B6B03083O002DCBA32B26232A5B025O0034B040025O005AA540025O00DCA740025O0014994003163O00EDB2C8D07CFF6A06D7B3C0E97AF6581CEDB3C4C966F403083O006EBEC7A5BD13913D025O00509040025O00BC974003063O00EAE776F18ED503063O00A7BA8B1788EB031C3O0053752O6D6F6E57686974655469676572537461747565506C61796572031B3O0009A0850015BBB71A12BC9C0825A1810A1FA7B71E0EB49C181FF5DC03043O006D7AD5E8025O00AC9A40025O0068B04003063O00CDE2B023E1E503043O00508E97C2031C3O0053752O6D6F6E57686974655469676572537461747565437572736F72031B3O0010D37A410CC8485B0BCF63493CD27E4B06D4485F17C7635906862303043O002C63A617025O0020824003073O0058FD282426B17203063O00C41C9749565303123O004973457175692O706564416E645265616479025O00C88240025O00388F4003073O00446A61722O756E03283O00F7092802974D1649E30A251C834A2779F53C3D1887671D7AF7063B2F8454197BF64324118B56582203083O001693634970E23878025O0004AF40025O00805840026O006A40025O00589F40025O0094AE40025O003AA840025O0036A740025O0032A040025O00F88440025O00D2A940025O00C05740025O004EA540030E3O0061AA3D0E1CEDE079A9130C17E6E103073O009336CF5C7E7383030E3O00576561706F6E734F664F72646572025O0034A740025O00D0AF4003183O001A2O346D02701E0E3A7B32711F35306F4D730C383B3D5F2C03063O001E6D51551D6D025O0052AE40025O0070894003163O000D18BAEE3AF5F92D03B6E03EC4DF2134A0E032FBF83C03073O00B74476CC81519003183O00426F2O7346696C7465726564466967687452656D61696E7303013O003E026O00394003163O00496E766F6B654E69757A616F546865426C61636B4F78025O0044B340025O0004B34003223O0007A366EB008731A379F11183019264EC0EBD0CA171E700BD01B530E90A8B00ED21BC03063O00E26ECD10846B025O00A6AC40025O00C2B240030C3O00DFCCF5DA49E4C5C4DC40FFCB03053O00218BA380B903103O004865616C746850657263656E74616765026O002E40025O00B09340025O00D08A4003163O00435711DD5F670BD8685C01DF435044D356510A9E050803043O00BE373864030C3O00DD7E5AB332CBEFEB5346B32103073O009C9F1134D656BE030A3O00446562752O66446F776E030C3O00426F6E65647573744272657703063O009EE3BCA5ABFD03043O00DCCE8FDD03123O00426F6E656475737442726577506C61796572025O008EAE40025O005CB24003103O0084722312DCD9C192422F05DDDB92D42B03073O00B2E61D4D77B8AC03123O00D0B00F166EB8C0B00E1E65B8D6AB180878EA03063O009895DE6A7B17025O0070A740025O0062B04003063O0045786973747303093O0043616E412O7461636B025O00588440025O005AB14003123O00426F6E656475737442726577437572736F7203103O00DF29F846B1C835E27CB7CF23E103E78B03053O00D5BD46962303063O006C40661B404703043O00682F351403103O00A1438F19B81AB058BE1EAE0AB40CD34A03063O006FC32CE17CDC030C3O00FB490E75A2B9D547147AA4A503063O00CBB8266013CB025O00606840025O00309C40025O00989540025O0050A14003103O003B7C7744CA2C606D7ECC2B766E019C6F03053O00AE59131921025O005AA640025O0036A340025O00BC9D40025O006AAF40030B3O001448F41F75FA2440F01B6003063O00AE5629937013030B3O004261676F66547269636B73025O00BCA140025O0022B04003153O0059018A342A092EBF49098E00364F1CAA520ECD5A7303083O00CB3B60ED6B456F71025O0042A440025O00ECAE4003093O00F48CCE2685A55BDD8103073O0034B2E5BC43E7C9025O0060924003093O0046697265626C2O6F6403113O0027484201F5502C2E451009F6552D61100203073O004341213064973C030D3O00FEE9ADDDE0CBF5AFD4D0DEEBA203053O0093BF87CEB8030D3O00416E6365737472616C43612O6C025O00ECA740025O00689C4003163O008526A5C4CB47A0852499C2D95FBEC425A7C8D613E3D003073O00D2E448C6A1B833025O000AAD40025O009AA84003113O0048616E646C65496E636F72706F7265616C03093O00506172616C7973697303123O00506172616C797369734D6F7573656F766572026O00344003053O00A4F996792803083O0076E09CE2165088D603173O0044697370652O6C61626C65467269656E646C79556E6974025O00F6A840025O0024AD40030A3O004465746F78466F637573030A3O0046EB4D8F5AAE54814BE003043O00E0228E39025O00DAA540025O0018AF4003093O0018595BBDD19B23205D03073O00424C303CD8A3CB030F3O0088936AFB56C02390877DF668C72ABE03073O0044DAE619933FAE03063O0042752O66557003123O00B9235449A4923A5240BBED275245B8ED7E2O03053O00D6CD4A332C025O00609E40025O0080A240030C3O00D840E3FF7CF559F6D77EF94703053O00179A2C829C025O00B49A40025O0098B040030C3O00426C61636B6F75744B69636B03153O0013AAACAD3D1C04B292A53F101AE6A0AF3F1D51F2F903063O007371C6CDCE56030D3O00B65EED538A50CD4F8A7CF7598F03043O003AE4379E025O0004A940030D3O00526973696E6753756E4B69636B025O009CAE4003173O00A680C32732AA0AA79CDE1137A436BFC9DD2F35A375E0DF03073O0055D4E9B04E5CCD025O00608840025O00E2A840025O00D6AF40026O005040030C3O00A7C9B181B6808BDF2OA6BC8303063O00E4E2B1C1EDD9025O0034A140025O00B0854003063O0004BC22FF31A203043O008654D043025O00F4AC4003123O004578706C6F64696E674B6567506C6179657203103O0016B496501CA88F5214938D5914ECD50503043O003C73CCE603123O00C234EE7DFE7ADE7EE33FF930C42FF963E82803043O0010875A8B025O0094A640025O0072A44003123O004578706C6F64696E674B6567437572736F7203103O00516C163F4150715A7339384B5338072D03073O0018341466532E3403063O00E73A333700D603053O006FA44F4144025O0036AA40025O0021B140025O00F6A740025O0026A14003103O00C3C193D221EECFD784E125EFC199D08703063O008AA6B9E3BE4E030C3O00E87BCB315B3114CA60CC385C03073O0079AB14A5573243030C3O004578706C6F64696E674B656703103O00C320A93AB606CF36BE09B207C178EA6F03063O0062A658D956D9025O00A2A740025O00FAA540025O00D8A240025O00407640030B3O000D1E534DFCA8130D00575903073O006B4F72322E97E7030D3O0009B3A7208C20BECE3E84A72C9D03083O00A059C6D549EA59D703113O00436861726765734672616374696F6E616C026O00E03F030B3O00426C61636B4F784272657703153O004A7DB5FDCE777EACC1C75A74A3BEC84978BABE971003053O00A52811D49E030B3O00C7D509302DCAC12A2123F203053O004685B9685303083O002F404319C405564C03053O00A96425244A03083O002B82A5630D86B15803043O003060E7C2030A3O00432O6F6C646F776E5570025O002CA040025O004C924003153O00CA560F2E12E7A09BF7581C280E98A282C1544E7E4903083O00E3A83A6E4D79B8CF03083O005039B873BCDA62AD03083O00C51B5CDF20D1BB11025O000CB040025O00BCAE4003113O00085A2OC41052C2E80B1FCEFA0A5183A85703043O009B633FA3025O0056AB40025O00DEAA40025O00608B40025O00CEA940030F3O00CB01D5F485AFF71FF810C3CB85AFF403083O00559974A69CECC190025O00D4A640025O00D4AB4003193O00B6F55EBBED0EA3DF47B2E0059BF744BDE040A9E144BDA457F603063O0060C4802DD38403113O00069D7251DCA6BADF169F7A51D784BDDB3E03083O00B855ED1B3FB2CFD4031B3O001B49005106500758375A1B5E065C3654015A021F05580051480C5F03043O003F683969025O0076A440025O00A8944003083O00288FAD661E95B75003043O00246BE7C4025O0025B040025O00C8A24003113O005EBDABB85FA0B09449F5AF8654BBE2D10D03043O00E73DD5C2025O00649640025O00FCA44000DA092O00129B3O00014O00AE000100023O002EE9000200D00901000200043A3O00D2090100269C3O00D20901000300043A3O00D2090100269C000100060001000100043A3O0006000100129B000200013O000E2C000100490001000200043A3O0049000100129B000300014O00AE000400043O00269C0003000D0001000100043A3O000D000100129B000400013O002E2O0104002D0001000500043A3O002D000100269C0004002D0001000300043A3O002D0001001287000500064O001A000600013O00122O000700073O00122O000800086O0006000800024O0005000500064O000600013O00122O000700093O00122O0008000A6O0006000800024O0005000500064O00055O00122O000500066O000600013O00122O0007000B3O00122O0008000C6O0006000800024O0005000500064O000600013O00122O0007000D3O00122O0008000E6O0006000800024O0005000500064O000500023O00122O0004000F3O002E2O011100330001001000043A3O0033000100269C000400330001000F00043A3O0033000100129B000200033O00043A3O00490001002E54001300100001001200043A3O0010000100269C000400100001000100043A3O001000012O00C0000500034O001300050001000100122O000500066O000600013O00122O000700143O00122O000800156O0006000800024O0005000500064O000600013O00122O000700163O00122O000800176O0006000800024O0005000500064O000500043O00122O000400033O00044O0010000100043A3O0049000100043A3O000D0001000E2C0003007A0001000200043A3O007A000100129B000300013O002E54001900620001001800043A3O0062000100269C000300620001000100043A3O00620001001287000400064O00A5000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400052O00A5000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400052O0064000400056O000400073O00202O00040004001E00122O0006001F6O0004000600024O000400063O00122O000300033O00269C000300660001000F00043A3O0066000100129B0002000F3O00043A3O007A000100269C0003004C0001000300043A3O004C000100129B000400013O00269C0004006D0001000300043A3O006D000100129B0003000F3O00043A3O004C000100269C000400690001000100043A3O006900012O00C0000500073O0020B600050005001E00122O000700206O0005000700024O000500086O000500086O000500056O000500093O00122O000400033O00044O0069000100043A3O004C0001002E54002200C10001002100043A3O00C10001000E2C000F00C10001000200043A3O00C1000100129B000300013O000E79000F00830001000300043A3O00830001002E2O012300850001002400043A3O0085000100129B000200253O00043A3O00C10001002611000300890001000100043A3O00890001002E54002600A80001002700043A3O00A8000100129B000400013O002E2O012800900001002900043A3O0090000100269C000400900001000300043A3O0090000100129B000300033O00043A3O00A8000100269C0004008A0001000100043A3O008A00012O00C0000500084O0085000500053O000EAF0001009A0001000500043A3O009A00012O00C0000500084O0085000500053O00067D0005009B0001000100043A3O009B000100129B000500034O00BF000500094O00C0000500064O0085000500053O000EAF000100A40001000500043A3O00A400012O00C0000500064O0085000500053O00067D000500A50001000100043A3O00A5000100129B000500033O0012A70005002A3O00129B000400033O00043A3O008A0001002EE9002B00D7FF2O002B00043A3O007F000100269C0003007F0001000300043A3O007F00012O00C0000400073O00200801040004002C00129B000600204O00E800040006000200067D000400B60001000100043A3O00B600012O00C0000400073O00200801040004002D2O00C00006000B4O00E80004000600022O00BF0004000A3O002EE9002E00080001002E00043A3O00BF00012O00C0000400073O00200801040004002F2O0018000400020002000655000400BF00013O00043A3O00BF00012O002E3O00013O00129B0003000F3O00043A3O007F0001002611000200C50001002500043A3O00C50001002EE900300046FF2O003100043A3O000900012O00C0000300073O0020080103000300322O0018000300020002000655000300F400013O00043A3O00F400012O00C00003000C3O000655000300F400013O00043A3O00F400012O00C00003000D4O0097000400013O00122O000500333O00122O000600346O0004000600024O00030003000400202O0003000300354O00030002000200062O000300F400013O00043A3O00F400012O00C0000300053O000655000300F400013O00043A3O00F4000100129B000300014O00AE000400043O000E2C000100DC0001000300043A3O00DC000100129B000400013O002E2O013700DF0001003600043A3O00DF000100269C000400DF0001000100043A3O00DF00012O00C00005000E3O0020980005000500394O000600016O000700096O00050009000200122O000500383O00122O000500383O00062O000500EE0001000100043A3O00EE0001002EE9003A00080001003B00043A3O00F40001001287000500384O000E010500023O00043A3O00F4000100043A3O00DF000100043A3O00F4000100043A3O00DC00012O00C00003000E3O0020B200030003003C2O00F800030001000200067D000300FB0001000100043A3O00FB0001002E54003D00D90901003E00043A3O00D9090100129B000300014O00AE000400043O000E2C000100FD0001000300043A3O00FD000100129B000400013O002E2O014000102O01003F00043A3O00102O01000E2C000300102O01000400043A3O00102O012O00C00005000F4O00C00006000D3O0020B20006000600412O0018000500020002000655000500D909013O00043A3O00D909012O00C0000500013O00120C000600423O00122O000700436O000500076O00055O00044O00D90901002E2O01442O002O01004500043A4O002O0100269C00042O002O01000100043A4O002O0100129B000500013O00269C000500192O01000300043A3O00192O0100129B000400033O00043A4O002O010026110005001D2O01000100043A3O001D2O01002E54004700152O01004600043A3O00152O012O00C0000600073O0020080106000600322O001800060002000200067D000600312O01000100043A3O00312O012O00C0000600043O000655000600312O013O00043A3O00312O0100129B000600014O00AE000700073O00269C000600272O01000100043A3O00272O012O00C0000800104O00F80008000100022O0044000700083O000655000700312O013O00043A3O00312O012O000E010700023O00043A3O00312O0100043A3O00272O012O00C0000600073O0020080106000600322O001800060002000200067D000600392O01000100043A3O00392O012O00C0000600043O000655000600C809013O00043A3O00C8090100129B000600014O00AE000700083O0026110006003F2O01000300043A3O003F2O01002E2O014900BD0901004800043A3O00BD0901002611000700432O01000100043A3O00432O01002E54004A003F2O01004B00043A3O003F2O0100129B000800013O00269C000800210201004C00043A3O002102012O00C00009000D4O0097000A00013O00122O000B004D3O00122O000C004E6O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O000900602O013O00043A3O00602O012O00C00009000F4O006F000A000D3O00202O000A000A00504O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O000900602O013O00043A3O00602O012O00C0000900013O00129B000A00523O00129B000B00534O00030109000B4O00D600096O00C00009000D4O0097000A00013O00122O000B00543O00122O000C00556O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O000900E92O013O00043A3O00E92O01001287000900563O00067D000900E92O01000100043A3O00E92O012O00C0000900093O000E8D002500E92O01000900043A3O00E92O012O00C00009000D4O00CD000A00013O00122O000B00573O00122O000C00586O000A000C00024O00090009000A00202O0009000900594O0009000200024O000A00073O00202O000A000A005A4O000A0002000200062O000A00E92O01000900043A3O00E92O012O00C0000900114O00E1000A00073O00202O000A000A005B4O000A000200024O000B00073O00202O000B000B005C4O000B000200024O000C00116O000D000D6O000E00013O00122O000F005D3O00122O0010005E6O000E001000024O000D000D000E00202O000D000D00594O000D000200024O000E000D6O000F00013O00122O0010005F3O00122O001100606O000F001100024O000E000E000F00202O000E000E00614O000E000F6O000C3O00024O000D00126O000E000D6O000F00013O00122O0010005D3O00122O0011005E6O000F001100024O000E000E000F00202O000E000E00594O000E000200024O000F000D6O001000013O00122O0011005F3O00122O001200606O0010001200024O000F000F001000202O000F000F00614O000F00106O000D3O00024O000C000C000D4O000B000B000C4O0009000B00024O000A00126O000B00073O00202O000B000B005B4O000B000200024O000C00073O00202O000C000C005C4O000C000200024O000D00116O000E000D6O000F00013O00122O0010005D3O00122O0011005E6O000F001100024O000E000E000F00202O000E000E00594O000E000200024O000F000D6O001000013O00122O0011005F3O00122O001200606O0010001200024O000F000F001000202O000F000F00614O000F00106O000D3O00024O000E00126O000F000D6O001000013O00122O0011005D3O00122O0012005E6O0010001200024O000F000F001000202O000F000F00594O000F000200024O0010000D4O00A5001100013O00122O0012005F3O00122O001300606O0011001300024O0010001000110020740010001000614O001000116O000E3O00024O000D000D000E4O000C000C000D4O000A000C00024O00090009000A000E2O006200E92O01000900043A3O00E92O012O00C00009000D4O0097000A00013O00122O000B00633O00122O000C00646O000A000C00024O00090009000A00202O0009000900654O00090002000200062O000900EB2O013O00043A3O00EB2O01001287000900663O000655000900EB2O013O00043A3O00EB2O01002E54006800FD2O01006700043A3O00FD2O012O00C00009000F4O0004000A000D3O00202O000A000A00694O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O000900F82O01000100043A3O00F82O01002E54006B00FD2O01006A00043A3O00FD2O012O00C0000900013O00129B000A006C3O00129B000B006D4O00030109000B4O00D600095O002E2O016E00200201006F00043A3O002002012O00C00009000D4O0097000A00013O00122O000B00703O00122O000C00716O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O0009002002013O00043A3O002002012O00C0000900073O0020BB0009000900724O000B000D3O00202O000B000B00734O0009000B000200062O0009002002013O00043A3O002002012O00C00009000F4O006F000A000D3O00202O000A000A00734O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O0009002002013O00043A3O002002012O00C0000900013O00129B000A00743O00129B000B00754O00030109000B4O00D600095O00129B000800763O002E54007800A90201007700043A3O00A9020100269C000800A90201007900043A3O00A9020100129B000900013O00269C0009006E0201000100043A3O006E02012O00C0000A000D4O0097000B00013O00122O000C007A3O00122O000D007B6O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A004702013O00043A3O004702012O00C0000A00023O000655000A004702013O00043A3O004702012O00C0000A000F4O0004000B000D3O00202O000B000B007C4O000C000B3O00202O000C000C005100122O000E001F6O000C000E00024O000C000C6O000A000C000200062O000A00420201000100043A3O00420201002E2O017D00470201007E00043A3O004702012O00C0000A00013O00129B000B007F3O00129B000C00804O0003010A000C4O00D6000A6O00C0000A000D4O0097000B00013O00122O000C00813O00122O000D00826O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A006D02013O00043A3O006D0201001287000A00663O000655000A006D02013O00043A3O006D02012O00C0000A00073O0020BB000A000A00724O000C000D3O00202O000C000C00834O000A000C000200062O000A006D02013O00043A3O006D0201002EE9008400120001008400043A3O006D02012O00C0000A000F4O006F000B000D3O00202O000B000B00854O000C000B3O00202O000C000C008600122O000E00876O000C000E00024O000C000C6O000A000C000200062O000A006D02013O00043A3O006D02012O00C0000A00013O00129B000B00883O00129B000C00894O0003010A000C4O00D6000A5O00129B000900033O002E2O018A00260201008B00043A3O0026020100269C000900260201000300043A3O002602012O00C0000A000D4O0097000B00013O00122O000C008C3O00122O000D008D6O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A00A602013O00043A3O00A602012O00C0000A00073O0020BB000A000A00724O000C000D3O00202O000C000C008E4O000A000C000200062O000A00A602013O00043A3O00A602012O00C0000A00073O002008010A000A008F2O0018000A0002000200067D000A00940201000100043A3O009402012O00C0000A00073O002008010A000A00902O0018000A00020002000655000A00A602013O00043A3O00A602012O00C0000A000B3O0020BB000A000A00914O000C000D3O00202O000C000C00924O000A000C000200062O000A00A602013O00043A3O00A60201002E54009300A60201009400043A3O00A602012O00C0000A000F4O006F000B000D3O00202O000B000B00854O000C000B3O00202O000C000C005100122O000E00206O000C000E00024O000C000C6O000A000C000200062O000A00A602013O00043A3O00A602012O00C0000A00013O00129B000B00953O00129B000C00964O0003010A000C4O00D6000A5O00129B0008001F3O00043A3O00A9020100043A3O00260201002611000800AD0201002000043A3O00AD0201002E54009800480301009700043A3O004803012O00C00009000D4O0097000A00013O00122O000B00993O00122O000C009A6O000A000C00024O00090009000A00202O0009000900354O00090002000200062O000900CA02013O00043A3O00CA0201002E54009B00CA0201009C00043A3O00CA02012O00C00009000F4O0049000A000D3O00202O000A000A009D4O000B000B3O00202O000B000B009E4O000D000D3O00202O000D000D009D4O000B000D00024O000B000B6O0009000B000200062O000900CA02013O00043A3O00CA02012O00C0000900013O00129B000A009F3O00129B000B00A04O00030109000B4O00D600096O00C00009000D4O0097000A00013O00122O000B00A13O00122O000C00A26O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O000900C809013O00043A3O00C809012O00C00009000D4O000D010A00013O00122O000B00A33O00122O000C00A46O000A000C00024O00090009000A00202O0009000900654O00090002000200062O000900C80901000100043A3O00C809012O00C00009000D4O00CD000A00013O00122O000B00A53O00122O000C00A66O000A000C00024O00090009000A00202O0009000900594O0009000200024O000A00073O00202O000A000A005A4O000A0002000200062O000A00C80901000900043A3O00C809012O00C0000900114O0061000A00073O00202O000A000A005B4O000A000200024O000B00073O00202O000B000B005C4O000B000200024O000C00116O000D000D6O000E00013O00122O000F00A73O00122O001000A86O000E001000024O000D000D000E00202O000D000D00594O000D000200024O000E00073O00202O000E000E005A4O000E000F6O000C3O00024O000D00126O000E000D6O000F00013O00122O001000A73O00122O001100A86O000F001100024O000E000E000F00202O000E000E00594O000E000200024O000F00073O00202O000F000F005A4O000F00106O000D3O00024O000C000C000D4O000B000B000C4O0009000B00024O000A00126O000B00073O00202O000B000B005B4O000B000200024O000C00073O00202O000C000C005C4O000C000200024O000D00116O000E000D6O000F00013O00122O001000A73O00122O001100A86O000F001100024O000E000E000F00202O000E000E00594O000E000200024O000F00073O00202O000F000F005A4O000F00106O000D3O00024O000E00126O000F000D6O001000013O00122O001100A73O00122O001200A86O0010001200024O000F000F001000202O000F000F00594O000F000200024O001000073O00202O00100010005A4O001000116O000E3O00024O000D000D000E4O000C000C000D4O000A000C00024O00090009000A000E2O006200C80901000900043A3O00C809012O00C00009000F4O0049000A000D3O00202O000A000A00A94O000B000B3O00202O000B000B009E4O000D000D3O00202O000D000D00A94O000B000D00024O000B000B6O0009000B000200062O000900C809013O00043A3O00C809012O00C0000900013O00120C000A00AA3O00122O000B00AB6O0009000B6O00095O00044O00C809010026110008004C0301000100043A3O004C0301002E5400AD00F3030100AC00043A3O00F3030100129B000900013O00269C000900CE0301000100043A3O00CE03012O00C0000A00073O002008010A000A00AE2O0018000A0002000200067D000A00B50301000100043A3O00B503012O00C0000A00073O002008010A000A00AF2O0018000A0002000200067D000A00B50301000100043A3O00B5030100129B000A00014O00AE000B000C3O00269C000A00600301000100043A3O0060030100129B000B00014O00AE000C000C3O00129B000A00033O002E5400B1005B030100B000043A3O005B030100269C000A005B0301000300043A3O005B030100269C000B00770301000F00043A3O007703012O00C0000D000E3O0020EC000D000D00B24O000E000D3O00202O000E000E00B300122O000F00B46O001000016O001100136O001200143O00202O0012001200B54O000D001200024O000C000D3O00062O000C00750301000100043A3O00750301002E5400B700B5030100B600043A3O00B503012O000E010C00023O00043A3O00B50301002611000B007B0301000100043A3O007B0301002E5400B80093030100B900043A3O0093030100129B000D00013O002E2O01BA008C030100BB00043A3O008C0301000E2C0001008C0301000D00043A3O008C03012O00C0000E000E3O00201E000E000E00B24O000F000D3O00202O000F000F00B300122O001000206O001100016O000E001100024O000C000E3O00062O000C008B03013O00043A3O008B03012O000E010C00023O00129B000D00033O002E2O01BD007C030100BC00043A3O007C030100269C000D007C0301000300043A3O007C030100129B000B00033O00043A3O0093030100043A3O007C030100269C000B00640301000300043A3O0064030100129B000D00013O00269C000D009A0301000300043A3O009A030100129B000B000F3O00043A3O00640301002611000D009E0301000100043A3O009E0301002E5400BF0096030100BE00043A3O0096030100129B000E00013O000E2C000300A30301000E00043A3O00A3030100129B000D00033O00043A3O0096030100269C000E009F0301000100043A3O009F03012O00C0000F000E3O002073000F000F00C04O0010000D3O00202O0010001000C100122O001100206O000F001100024O000C000F3O00062O000C00AF03013O00043A3O00AF03012O000E010C00023O00129B000E00033O00043A3O009F030100043A3O0096030100043A3O0064030100043A3O00B5030100043A3O005B03012O00C0000A000A3O000655000A00CD03013O00043A3O00CD030100129B000A00014O00AE000B000C3O00269C000A00C70301000300043A3O00C7030100269C000B00BC0301000100043A3O00BC03012O00C0000D00154O00F8000D000100022O0044000C000D3O000655000C00CD03013O00043A3O00CD03012O000E010C00023O00043A3O00CD030100043A3O00BC030100043A3O00CD030100269C000A00BA0301000100043A3O00BA030100129B000B00014O00AE000C000C3O00129B000A00033O00043A3O00BA030100129B000900033O00269C0009004D0301000300043A3O004D03012O00C0000A00163O000655000A00F003013O00043A3O00F0030100129B000A00014O00AE000B000B3O00269C000A00D50301000100043A3O00D5030100129B000B00013O002EE900C23O000100C200043A3O00D80301000E2C000100D80301000B00043A3O00D803012O00C0000C000E3O002040000C000C00C34O000D000D3O00202O000D000D00C44O000E00143O00202O000E000E00C500122O000F00B46O000C000F000200122O000C00383O00122O000C00383O00062O000C00EA0301000100043A3O00EA0301002E5400C700F0030100C600043A3O00F00301001287000C00384O000E010C00023O00043A3O00F0030100043A3O00D8030100043A3O00F0030100043A3O00D5030100129B000800033O00043A3O00F3030100043A3O004D030100269C0008007C0401002500043A3O007C040100129B000900013O00269C0009001C0401000300043A3O001C04012O00C0000A000D4O0097000B00013O00122O000C00C83O00122O000D00C96O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A001A04013O00043A3O001A04012O00C0000A00023O000655000A001A04013O00043A3O001A04012O00C0000A00073O002008010A000A005B2O0018000A000200020026EF000A001A040100CA00043A3O001A04012O00C0000A000F4O006F000B000D3O00202O000B000B00CB4O000C000B3O00202O000C000C005100122O000E00206O000C000E00024O000C000C6O000A000C000200062O000A001A04013O00043A3O001A04012O00C0000A00013O00129B000B00CC3O00129B000C00CD4O0003010A000C4O00D6000A5O00129B000800793O00043A3O007C0401000E2C000100F60301000900043A3O00F60301002E5400CF0053040100CE00043A3O005304012O00C0000A00174O009E000B00013O00122O000C00D03O00122O000D00D16O000B000D000200062O000A002E0401000B00043A3O002E04012O00C0000A00174O00CF000B00013O00122O000C00D23O00122O000D00D36O000B000D000200062O000A00530401000B00043A3O005304012O00C0000A000D4O0097000B00013O00122O000C00D43O00122O000D00D56O000B000D00024O000A000A000B00202O000A000A00354O000A0002000200062O000A004404013O00043A3O004404012O00C0000A000B3O002008010A000A008600129B000C00204O00E8000A000C000200067D000A00440401000100043A3O004404012O00C0000A000B3O002008010A000A008600129B000C00D64O00E8000A000C000200067D000A00460401000100043A3O00460401002EE900D7000F000100D800043A3O005304012O00C0000A000F4O00C0000B000D3O0020B2000B000B00D92O0018000A0002000200067D000A004E0401000100043A3O004E0401002E5400DB0053040100DA00043A3O005304012O00C0000A00013O00129B000B00DC3O00129B000C00DD4O0003010A000C4O00D6000A6O00C0000A000D4O0097000B00013O00122O000C00DE3O00122O000D00DF6O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A007A04013O00043A3O007A04012O00C0000A000D4O00FD000B00013O00122O000C00E03O00122O000D00E16O000B000D00024O000A000A000B00202O000A000A00594O000A00020002000E2O000F007A0401000A00043A3O007A04012O00C0000A00093O000E8D000F007A0401000A00043A3O007A04012O00C0000A000F4O006F000B000D3O00202O000B000B00E24O000C000B3O00202O000C000C005100122O000E00206O000C000E00024O000C000C6O000A000C000200062O000A007A04013O00043A3O007A04012O00C0000A00013O00129B000B00E33O00129B000C00E44O0003010A000C4O00D6000A5O00129B000900033O00043A3O00F60301000E2C0003006C0701000800043A3O006C070100129B000900013O002611000900830401000300043A3O00830401002E5400E60019070100E500043A3O00190701002E5400E70017070100E800043A3O001707012O00C0000A00023O000655000A001707013O00043A3O0017070100129B000A00014O00AE000B000B3O00269C000A008A0401000100043A3O008A040100129B000B00013O00269C000B00D80401000300043A3O00D804012O00C0000C000D4O0097000D00013O00122O000E00E93O00122O000F00EA6O000D000F00024O000C000C000D00202O000C000C004F4O000C0002000200062O000C00A604013O00043A3O00A60401002E2O01EC00A6040100EB00043A3O00A604012O00C0000C000F4O00C0000D000D3O0020B2000D000D00ED2O0018000C00020002000655000C00A604013O00043A3O00A604012O00C0000C00013O00129B000D00EE3O00129B000E00EF4O0003010C000E4O00D6000C5O002EE900F00017000100F000043A3O00BD04012O00C0000C000D4O0097000D00013O00122O000E00F13O00122O000F00F26O000D000F00024O000C000C000D00202O000C000C004F4O000C0002000200062O000C00BD04013O00043A3O00BD04012O00C0000C000F4O00C0000D000D3O0020B2000D000D00F32O0018000C00020002000655000C00BD04013O00043A3O00BD04012O00C0000C00013O00129B000D00F43O00129B000E00F54O0003010C000E4O00D6000C6O00C0000C000D4O0097000D00013O00122O000E00F63O00122O000F00F76O000D000F00024O000C000C000D00202O000C000C004F4O000C0002000200062O000C00D704013O00043A3O00D704012O00C0000C000F4O006F000D000D3O00202O000D000D00F84O000E000B3O00202O000E000E008600122O001000B46O000E001000024O000E000E6O000C000E000200062O000C00D704013O00043A3O00D704012O00C0000C00013O00129B000D00F93O00129B000E00FA4O0003010C000E4O00D6000C5O00129B000B000F3O00269C000B008A0501000100043A3O008A050100129B000C00013O002E5400FC004B050100FB00043A3O004B050100269C000C004B0501000100043A3O004B0501002E2O01FE0020050100FD00043A3O002005012O00C0000D000D4O0097000E00013O00122O000F00FF3O00122O00102O00015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D002005013O00043A3O0020050100129B000D002O012O00129B000E0002012O000682000D00080501000E00043A3O000805012O00C0000D00184O00CF000E00013O00122O000F0003012O00122O00100004015O000E0010000200062O000D00080501000E00043A3O000805012O00C0000D000F4O0045000E00143O00122O000F0005015O000E000E000F4O000F000B3O00202O000F000F005100122O001100206O000F001100024O000F000F6O000D000F000200062O000D002005013O00043A3O002005012O00C0000D00013O00120C000E0006012O00122O000F0007015O000D000F6O000D5O00044O0020050100129B000D0008012O00129B000E0009012O0006A1000D00140501000E00043A3O001405012O00C0000D00184O009E000E00013O00122O000F000A012O00122O0010000B015O000E0010000200062O000D00140501000E00043A3O0014050100043A3O002005012O00C0000D000F4O0094000E00143O00122O000F000C015O000E000E000F4O000D0002000200062O000D002005013O00043A3O002005012O00C0000D00013O00129B000E000D012O00129B000F000E013O0003010D000F4O00D6000D5O00129B000D000F012O00129B000E000F012O000622000D004A0501000E00043A3O004A05012O00C0000D00023O000655000D004A05013O00043A3O004A05012O00C0000D00193O000655000D004A05013O00043A3O004A05012O00C0000D001A4O008F000E00013O00122O000F0010012O00122O00100011015O000E001000024O000D000D000E00122O000F0012015O000D000D000F4O000D0002000200062O000D004A05013O00043A3O004A050100129B000D0013012O00129B000E0014012O0006A1000D004A0501000E00043A3O004A05012O00C0000D000F4O0045000E00143O00122O000F0015015O000E000E000F4O000F000B3O00202O000F000F005100122O001100206O000F001100024O000F000F6O000D000F000200062O000D004A05013O00043A3O004A05012O00C0000D00013O00129B000E0016012O00129B000F0017013O0003010D000F4O00D6000D5O00129B000C00033O00129B000D00033O000622000C00DB0401000D00043A3O00DB04012O00C0000D00023O000655000D008705013O00043A3O0087050100129B000D00014O00AE000E000F3O00129B00100018012O00129B00110018012O0006220010006F0501001100043A3O006F050100129B001000013O000622000D006F0501001000043A3O006F050100129B001000013O00129B001100013O000659001000620501001100043A3O0062050100129B00110019012O00129B0012001A012O000622001100650501001200043A3O0065050100129B000E00014O00AE000F000F3O00129B001000033O00129B0011001B012O00129B0012001C012O0006A10011005B0501001200043A3O005B050100129B001100033O0006220010005B0501001100043A3O005B050100129B000D00033O00043A3O006F050100043A3O005B050100129B001000033O000659000D00760501001000043A3O0076050100129B0010001D012O00129B0011001E012O0006A1001000530501001100043A3O0053050100129B001000013O000622000E00760501001000043A3O007605012O00C00010001B4O00F80010000100022O0044000F00103O00067D000F00820501000100043A3O0082050100129B0010001F012O00129B00110020012O0006A1001000870501001100043A3O008705012O000E010F00023O00043A3O0087050100043A3O0076050100043A3O0087050100043A3O0053050100129B000B00033O00043A3O008A050100043A3O00DB040100129B000C00253O000622000C00110601000B00043A3O0011060100129B000C00013O00129B000D0021012O00129B000E0022012O000682000E00B50501000D00043A3O00B5050100129B000D00033O000622000C00B50501000D00043A3O00B5050100129B000D0023012O00129B000E0023012O000622000D00B30501000E00043A3O00B305012O00C0000D000D4O0097000E00013O00122O000F0024012O00122O00100025015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D00B305013O00043A3O00B305012O00C0000D000F4O000B000E000D3O00122O000F0026015O000E000E000F4O000D0002000200062O000D00AE0501000100043A3O00AE050100129B000D0027012O00129B000E0028012O0006A1000E00B30501000D00043A3O00B305012O00C0000D00013O00129B000E0029012O00129B000F002A013O0003010D000F4O00D6000D5O00129B000B00793O00043A3O0011060100129B000D00013O000622000C008E0501000D00043A3O008E050100129B000D002B012O00129B000E002C012O000682000E00E60501000D00043A3O00E605012O00C0000D000D4O0097000E00013O00122O000F002D012O00122O0010002E015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D00E605013O00043A3O00E605012O00C0000D001C3O001238000E002F015O000D000D000E00122O000E0030012O00122O000F0031015O000D000F000200062O000D00E605013O00043A3O00E605012O00C0000D001D3O000655000D00E605013O00043A3O00E605012O00C0000D000F4O00AD000E000D3O00122O000F0032015O000E000E000F4O000F000B3O00202O000F000F008600122O001100B46O000F001100024O000F000F6O000D000F000200062O000D00E10501000100043A3O00E1050100129B000D0033012O00129B000E0034012O000682000D00E60501000E00043A3O00E605012O00C0000D00013O00129B000E0035012O00129B000F0036013O0003010D000F4O00D6000D5O00129B000D0037012O00129B000E0038012O0006A1000D000F0601000E00043A3O000F06012O00C0000D000D4O0097000E00013O00122O000F0039012O00122O0010003A015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D000F06013O00043A3O000F06012O00C0000D000B3O0012C6000F003B015O000D000D000F4O000D0002000200122O000E003C012O00062O000D000F0601000E00043A3O000F060100129B000D003D012O00129B000E003E012O0006A1000E000F0601000D00043A3O000F06012O00C0000D000F4O006F000E000D3O00202O000E000E007C4O000F000B3O00202O000F000F005100122O0011001F6O000F001100024O000F000F6O000D000F000200062O000D000F06013O00043A3O000F06012O00C0000D00013O00129B000E003F012O00129B000F0040013O0003010D000F4O00D6000D5O00129B000C00033O00043A3O008E050100129B000C00793O000622000B00A70601000C00043A3O00A706012O00C0000C000D4O0097000D00013O00122O000E0041012O00122O000F0042015O000D000F00024O000C000C000D00202O000C000C004F4O000C0002000200062O000C001707013O00043A3O001707012O00C0000C000B3O00126A000E0043015O000C000C000E4O000E000D3O00122O000F0044015O000E000E000F4O000C000E000200062O000C001707013O00043A3O001707012O00C0000C001E4O00CF000D00013O00122O000E0045012O00122O000F0046015O000D000F000200062O000C00440601000D00043A3O004406012O00C0000C000F4O00AD000D00143O00122O000E0047015O000D000D000E4O000E000B3O00202O000E000E005100122O001000206O000E001000024O000E000E6O000C000E000200062O000C003E0601000100043A3O003E060100129B000C0048012O00129B000D0049012O000622000C00170701000D00043A3O001707012O00C0000C00013O00120C000D004A012O00122O000E004B015O000C000E6O000C5O00044O001707012O00C0000C001E4O00CF000D00013O00122O000E004C012O00122O000F004D015O000D000F000200062O000C00760601000D00043A3O0076060100129B000C004E012O00129B000D004F012O000682000C00170701000D00043A3O001707012O00C0000C00133O00129B000E0050013O00A2000C000C000E2O0018000C00020002000655000C001707013O00043A3O001707012O00C0000C00073O001236000E0051015O000C000C000E4O000E00136O000C000E000200062O000C001707013O00043A3O001707012O00C0000C00133O00126A000E0043015O000C000C000E4O000E000D3O00122O000F0044015O000E000E000F4O000C000E000200062O000C001707013O00043A3O0017070100129B000C0052012O00129B000D0053012O000682000C00170701000D00043A3O001707012O00C0000C000F4O0094000D00143O00122O000E0054015O000D000D000E4O000C0002000200062O000C001707013O00043A3O001707012O00C0000C00013O00120C000D0055012O00122O000E0056015O000C000E6O000C5O00044O001707012O00C0000C001E4O00CF000D00013O00122O000E0057012O00122O000F0058015O000D000F000200062O000C008A0601000D00043A3O008A06012O00C0000C000F4O0094000D00143O00122O000E0054015O000D000D000E4O000C0002000200062O000C001707013O00043A3O001707012O00C0000C00013O00120C000D0059012O00122O000E005A015O000C000E6O000C5O00044O001707012O00C0000C001E4O00CF000D00013O00122O000E005B012O00122O000F005C015O000D000F000200062O000C00170701000D00043A3O0017070100129B000C005D012O00129B000D005E012O0006A1000D00960601000C00043A3O0096060100043A3O001707012O00C0000C000F4O000B000D000D3O00122O000E0044015O000D000D000E4O000C0002000200062O000C00A10601000100043A3O00A1060100129B000C005F012O00129B000D0060012O000682000D00170701000C00043A3O001707012O00C0000C00013O00120C000D0061012O00122O000E0062015O000C000E6O000C5O00044O0017070100129B000C000F3O000622000C008D0401000B00043A3O008D040100129B000C00013O00129B000D00033O000659000C00B20601000D00043A3O00B2060100129B000D0063012O00129B000E0064012O000622000D00D70601000E00043A3O00D7060100129B000D0065012O00129B000E0066012O000682000D00D50601000E00043A3O00D506012O00C0000D000D4O0097000E00013O00122O000F0067012O00122O00100068015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D00D506013O00043A3O00D506012O00C0000D000F4O00AD000E000D3O00122O000F0069015O000E000E000F4O000F000B3O00202O000F000F008600122O001100B46O000F001100024O000F000F6O000D000F000200062O000D00D00601000100043A3O00D0060100129B000D006A012O00129B000E006B012O0006A1000E00D50601000D00043A3O00D506012O00C0000D00013O00129B000E006C012O00129B000F006D013O0003010D000F4O00D6000D5O00129B000B00253O00043A3O008D040100129B000D006E012O00129B000E006F012O0006A1000D00AB0601000E00043A3O00AB060100129B000D00013O000622000C00AB0601000D00043A3O00AB06012O00C0000D000D4O0097000E00013O00122O000F0070012O00122O00100071015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D00F806013O00043A3O00F8060100129B000D0072012O00129B000E0072012O000622000D00F80601000E00043A3O00F806012O00C0000D000F4O0094000E000D3O00122O000F0073015O000E000E000F4O000D0002000200062O000D00F806013O00043A3O00F806012O00C0000D00013O00129B000E0074012O00129B000F0075013O0003010D000F4O00D6000D6O00C0000D000D4O0097000E00013O00122O000F0076012O00122O00100077015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D001207013O00043A3O001207012O00C0000D000F4O000B000E000D3O00122O000F0078015O000E000E000F4O000D0002000200062O000D000D0701000100043A3O000D070100129B000D0079012O00129B000E007A012O000622000D00120701000E00043A3O001207012O00C0000D00013O00129B000E007B012O00129B000F007C013O0003010D000F4O00D6000D5O00129B000C00033O00043A3O00AB060100043A3O008D040100043A3O0017070100043A3O008A040100129B0008000F3O00043A3O006C070100129B000A00013O0006220009007F0401000A00043A3O007F04012O00C0000A001F3O00067D000A00230701000100043A3O0023070100129B000A007D012O00129B000B007E012O000682000A00410701000B00043A3O0041070100129B000A00014O00AE000B000B3O00129B000C00013O000622000A00250701000C00043A3O0025070100129B000B00013O00129B000C00013O000622000B00290701000C00043A3O002907012O00C0000C000E3O00121B000D007F015O000C000C000D4O000D000D3O00122O000E0080015O000D000D000E4O000E00143O00122O000F0081015O000E000E000F00122O000F0082015O000C000F000200122O000C00383O00122O000C00383O00062O000C004107013O00043A3O00410701001287000C00384O000E010C00023O00043A3O0041070100043A3O0029070100043A3O0041070100043A3O002507012O00C0000A00203O000655000A006A07013O00043A3O006A07012O00C0000A000C3O000655000A006A07013O00043A3O006A07012O00C0000A00053O000655000A006A07013O00043A3O006A07012O00C0000A000D4O0097000B00013O00122O000C0083012O00122O000D0084015O000B000D00024O000A000A000B00202O000A000A00354O000A0002000200062O000A006A07013O00043A3O006A07012O00C0000A000E3O00129B000B0085013O0032000A000A000B2O00F8000A00010002000655000A006A07013O00043A3O006A070100129B000A0086012O00129B000B0087012O000682000A006A0701000B00043A3O006A07012O00C0000A000F4O0094000B00143O00122O000C0088015O000B000B000C4O000A0002000200062O000A006A07013O00043A3O006A07012O00C0000A00013O00129B000B0089012O00129B000C008A013O0003010A000C4O00D6000A5O00129B000900033O00043A3O007F040100129B0009008B012O00129B000A008C012O0006A1000900F80701000A00043A3O00F8070100129B000900763O000622000800F80701000900043A3O00F8070100129B000900013O00129B000A00013O000622000900CF0701000A00043A3O00CF07012O00C0000A000D4O0097000B00013O00122O000C008D012O00122O000D008E015O000B000D00024O000A000A000B00202O000A000A00354O000A0002000200062O000A00AB07013O00043A3O00AB07012O00C0000A000D4O0097000B00013O00122O000C008F012O00122O000D0090015O000B000D00024O000A000A000B00202O000A000A00654O000A0002000200062O000A00AB07013O00043A3O00AB07012O00C0000A00073O0012B0000C0091015O000A000A000C4O000C000D3O00202O000C000C008E4O000A000C000200062O000A00AB07013O00043A3O00AB07012O00C0000A00073O0012B0000C0091015O000A000A000C4O000C000D3O00202O000C000C00734O000A000C000200062O000A00AB07013O00043A3O00AB07012O00C0000A000F4O006F000B000D3O00202O000B000B00A94O000C000B3O00202O000C000C005100122O000E001F6O000C000E00024O000C000C6O000A000C000200062O000A00AB07013O00043A3O00AB07012O00C0000A00013O00129B000B0092012O00129B000C0093013O0003010A000C4O00D6000A5O00129B000A0094012O00129B000B0095012O0006A1000A00CE0701000B00043A3O00CE07012O00C0000A000D4O0097000B00013O00122O000C0096012O00122O000D0097015O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A00CE07013O00043A3O00CE070100129B000A0098012O00129B000B0099012O000682000A00CE0701000B00043A3O00CE07012O00C0000A000F4O0045000B000D3O00122O000C009A015O000B000B000C4O000C000B3O00202O000C000C005100122O000E001F6O000C000E00024O000C000C6O000A000C000200062O000A00CE07013O00043A3O00CE07012O00C0000A00013O00129B000B009B012O00129B000C009C013O0003010A000C4O00D6000A5O00129B000900033O00129B000A00033O000622000900740701000A00043A3O007407012O00C0000A000D4O000D010B00013O00122O000C009D012O00122O000D009E015O000B000D00024O000A000A000B00202O000A000A004F4O000A0002000200062O000A00E00701000100043A3O00E0070100129B000A0018012O00129B000B009F012O000622000A00F50701000B00043A3O00F507012O00C0000A000F4O00AD000B000D3O00122O000C00A0015O000B000B000C4O000C000B3O00202O000C000C005100122O000E001F6O000C000E00024O000C000C6O000A000C000200062O000A00F00701000100043A3O00F0070100129B000A00A1012O00129B000B006F3O0006A1000B00F50701000A00043A3O00F507012O00C0000A00013O00129B000B00A2012O00129B000C00A3013O0003010A000C4O00D6000A5O00129B000800203O00043A3O00F8070100043A3O0074070100129B0009000F3O000659000800FF0701000900043A3O00FF070100129B000900A4012O00129B000A00A5012O0006220009004B0901000A00043A3O004B090100129B000900014O00AE000A000A3O00129B000B00013O000622000900010801000B00043A3O0001080100129B000A00013O00129B000B00033O000659000A000C0801000B00043A3O000C080100129B000B009F012O00129B000C00A6012O0006A1000C00920801000B00043A3O0092080100129B000B00A7012O00129B000C00A7012O000622000B00900801000C00043A3O009008012O00C0000B000D4O0097000C00013O00122O000D00A8012O00122O000E00A9015O000C000E00024O000B000B000C00202O000B000B004F4O000B0002000200062O000B009008013O00043A3O0090080100129B000B00AA012O00129B000C00AB012O0006A1000C003B0801000B00043A3O003B08012O00C0000B00214O00CF000C00013O00122O000D00AC012O00122O000E00AD015O000C000E000200062O000B003B0801000C00043A3O003B080100129B000B00AE012O00129B000C007D3O0006A1000B00900801000C00043A3O009008012O00C0000B000F4O0045000C00143O00122O000D00AF015O000C000C000D4O000D000B3O00202O000D000D005100122O000F00206O000D000F00024O000D000D6O000B000D000200062O000B009008013O00043A3O009008012O00C0000B00013O00120C000C00B0012O00122O000D00B1015O000B000D6O000B5O00044O009008012O00C0000B00214O00CF000C00013O00122O000D00B2012O00122O000E00B3015O000C000E000200062O000B00600801000C00043A3O0060080100129B000B00B4012O00129B000C00B5012O000682000C00900801000B00043A3O009008012O00C0000B00133O00129B000D0050013O00A2000B000B000D2O0018000B00020002000655000B009008013O00043A3O009008012O00C0000B00073O001236000D0051015O000B000B000D4O000D00136O000B000D000200062O000B009008013O00043A3O009008012O00C0000B000F4O0094000C00143O00122O000D00B6015O000C000C000D4O000B0002000200062O000B009008013O00043A3O009008012O00C0000B00013O00120C000C00B7012O00122O000D00B8015O000B000D6O000B5O00044O009008012O00C0000B00214O009E000C00013O00122O000D00B9012O00122O000E00BA015O000C000E000200062O000B006B0801000C00043A3O006B080100129B000B00BB012O00129B000C00BC012O000682000C007C0801000B00043A3O007C08012O00C0000B000F4O000B000C00143O00122O000D00B6015O000C000C000D4O000B0002000200062O000B00760801000100043A3O0076080100129B000B00BD012O00129B000C00BE012O0006A1000B00900801000C00043A3O009008012O00C0000B00013O00120C000C00BF012O00122O000D00C0015O000B000D6O000B5O00044O009008012O00C0000B00214O009E000C00013O00122O000D00C1012O00122O000E00C2015O000C000E000200062O000B00840801000C00043A3O0084080100043A3O009008012O00C0000B000F4O0094000C000D3O00122O000D00C3015O000C000C000D4O000B0002000200062O000B009008013O00043A3O009008012O00C0000B00013O00129B000C00C4012O00129B000D00C5013O0003010B000D4O00D6000B5O00129B000800253O00043A3O004B090100129B000B00013O000622000A00050801000B00043A3O000508012O00C0000B00023O000655000B002409013O00043A3O002409012O00C0000B00223O000655000B002409013O00043A3O0024090100129B000B00014O00AE000C000C3O00129B000D00C6012O00129B000E00C7012O0006A1000E009D0801000D00043A3O009D080100129B000D00013O000622000B009D0801000D00043A3O009D080100129B000C00013O00129B000D00013O000622000C00A50801000D00043A3O00A5080100129B000D00C8012O00129B000E00C9012O0006A1000E00CE0801000D00043A3O00CE08012O00C0000D000D4O0097000E00013O00122O000F00CA012O00122O001000CB015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D00CE08013O00043A3O00CE08012O00C0000D000D4O00A5000E00013O00122O000F00CC012O00122O001000CD015O000E001000024O000D000D000E001270000F00CE015O000D000D000F4O000D0002000200122O000E00CF012O00062O000D00CE0801000E00043A3O00CE08012O00C0000D000F4O0094000E000D3O00122O000F00D0015O000E000E000F4O000D0002000200062O000D00CE08013O00043A3O00CE08012O00C0000D00013O00129B000E00D1012O00129B000F00D2013O0003010D000F4O00D6000D6O00C0000D000D4O0097000E00013O00122O000F00D3012O00122O001000D4015O000E001000024O000D000D000E00202O000D000D004F4O000D0002000200062O000D002409013O00043A3O002409012O00C0000D00114O0077000E00073O00202O000E000E005B4O000E000200024O000F00073O00202O000F000F005C4O000F000200024O0010000D6O001100013O00122O001200D5012O00122O001300D6015O0011001300024O00100010001100202O0010001000594O0010000200024O000F000F00104O000D000F00024O000E00126O000F00073O00202O000F000F005B4O000F000200024O001000073O00202O00100010005C4O0010000200024O0011000D6O001200013O00122O001300D5012O00122O001400D6015O0012001400024O00110011001200202O0011001100594O0011000200024O0010001000114O000E001000024O000D000D000E00122O000E00B43O00062O000D00240901000E00043A3O002409012O00C0000D00073O0020BB000D000D00724O000F000D3O00202O000F000F008E4O000D000F000200062O000D002409013O00043A3O002409012O00C0000D000D4O008F000E00013O00122O000F00D7012O00122O001000D8015O000E001000024O000D000D000E00122O000F00D9015O000D000D000F4O000D0002000200062O000D002409013O00043A3O0024090100129B000D00DA012O00129B000E00DB012O000682000E00240901000D00043A3O002409012O00C0000D000F4O0094000E000D3O00122O000F00D0015O000E000E000F4O000D0002000200062O000D002409013O00043A3O002409012O00C0000D00013O00120C000E00DC012O00122O000F00DD015O000D000F6O000D5O00044O0024090100043A3O00A5080100043A3O0024090100043A3O009D08012O00C0000B000D4O0097000C00013O00122O000D00DE012O00122O000E00DF015O000C000E00024O000B000B000C00202O000B000B004F4O000B0002000200062O000B003209013O00043A3O003209012O00C0000B00093O00129B000C000F3O00065A000C00050001000B00043A3O0036090100129B000B00E0012O00129B000C00E1012O000682000B00470901000C00043A3O004709012O00C0000B000F4O0049000C000D3O00202O000C000C009D4O000D000B3O00202O000D000D009E4O000F000D3O00202O000F000F009D4O000D000F00024O000D000D6O000B000D000200062O000B004709013O00043A3O004709012O00C0000B00013O00129B000C00E2012O00129B000D00E3013O0003010B000D4O00D6000B5O00129B000A00033O00043A3O0005080100043A3O004B090100043A3O0001080100129B000900E4012O00129B000A00E5012O0006A1000A00442O01000900043A3O00442O0100129B0009001F3O000622000900442O01000800043A3O00442O0100129B000900E6012O00129B000A00E7012O000682000900740901000A00043A3O007409012O00C00009000D4O0097000A00013O00122O000B00E8012O00122O000C00E9015O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O0009007409013O00043A3O0074090100129B000900EA012O00129B000A00EB012O0006A1000900740901000A00043A3O007409012O00C00009000F4O006F000A000D3O00202O000A000A00734O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O0009007409013O00043A3O007409012O00C0000900013O00129B000A00EC012O00129B000B00ED013O00030109000B4O00D600096O00C00009000D4O0097000A00013O00122O000B00EE012O00122O000C00EF015O000A000C00024O00090009000A00202O0009000900354O00090002000200062O0009009609013O00043A3O009609012O00C0000900073O0012B0000B0091015O00090009000B4O000B000D3O00202O000B000B00834O0009000B000200062O0009009609013O00043A3O009609012O00C00009000F4O006F000A000D3O00202O000A000A00694O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O0009009609013O00043A3O009609012O00C0000900013O00129B000A00F0012O00129B000B00F1013O00030109000B4O00D600095O00129B000900F2012O00129B000A00F3012O0006A1000A00B80901000900043A3O00B809012O00C00009000D4O0097000A00013O00122O000B00F4012O00122O000C00F5015O000A000C00024O00090009000A00202O00090009004F4O00090002000200062O000900B809013O00043A3O00B8090100129B000900F6012O00129B000A00F7012O0006A1000A00B80901000900043A3O00B809012O00C00009000F4O006F000A000D3O00202O000A000A00E24O000B000B3O00202O000B000B005100122O000D00206O000B000D00024O000B000B6O0009000B000200062O000900B809013O00043A3O00B809012O00C0000900013O00129B000A00F8012O00129B000B00F9013O00030109000B4O00D600095O00129B0008004C3O00043A3O00442O0100043A3O00C8090100043A3O003F2O0100043A3O00C8090100129B000900013O000659000600C40901000900043A3O00C4090100129B000900FA012O00129B000A00FB012O0006220009003B2O01000A00043A3O003B2O0100129B000700014O00AE000800083O00129B000600033O00043A3O003B2O0100129B000500033O00043A3O00152O0100043A4O002O0100043A3O00D9090100043A3O00FD000100043A3O00D9090100043A3O0009000100043A3O00D9090100043A3O0006000100043A3O00D9090100129B000300013O0006223O00020001000300043A3O0002000100129B000100014O00AE000200023O00129B3O00033O00043A3O000200012O002E3O00017O00113O00028O00025O001BB040025O0069B140025O0008AF40025O00A0694003053O005072696E7403263O00DE45F8425E7BEF43F8471357F359F6154175E856E92O5C74BC55E415766AF554BD775C75F17C03063O001A9C379D3533026O00F03F025O006CAD40025O00608F40025O00E09B40025O0010A140030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03243O00AECA13CEB5519FCC13CBF87D83D61D9980109A984789F602C28846999A49CCFA19D6B57B03063O0030ECB876B9D8002F3O00129B3O00014O00AE000100013O00269C3O00020001000100043A3O0002000100129B000100013O000E79000100090001000100043A3O00090001002EE9000200180001000300043A3O001F000100129B000200013O0026110002000E0001000100043A3O000E0001002E2O010400180001000500043A3O001800012O00C000036O00CC0003000100014O000300013O00202O0003000300064O000400023O00122O000500073O00122O000600086O000400066O00033O000100122O000200093O0026110002001C0001000900043A3O001C0001002E54000A000A0001000B00043A3O000A000100129B000100093O00043A3O001F000100043A3O000A0001002E54000C00050001000D00043A3O0005000100269C000100050001000900043A3O000500010012870002000E3O00208C00020002000F4O000300023O00122O000400103O00122O000500116O000300056O00023O000100044O002E000100043A3O0005000100043A3O002E000100043A3O000200012O002E3O00017O00", GetFEnv(), ...);

