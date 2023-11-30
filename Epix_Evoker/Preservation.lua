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
				if (Enum <= 127) then
					if (Enum <= 63) then
						if (Enum <= 31) then
							if (Enum <= 15) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
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
										elseif (Enum > 2) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
									elseif (Enum > 6) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 10) then
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
								elseif (Enum <= 13) then
									if (Enum > 12) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 14) then
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
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum == 16) then
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
									elseif (Enum > 18) then
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
									elseif (Stk[Inst[2]] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 21) then
									if (Enum > 20) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum > 24) then
										if (Inst[2] <= Inst[4]) then
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
								elseif (Enum == 26) then
									if (Inst[2] < Inst[4]) then
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
							elseif (Enum <= 29) then
								if (Enum == 28) then
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
										if (Mvm[1] == 246) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 30) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 47) then
							if (Enum <= 39) then
								if (Enum <= 35) then
									if (Enum <= 33) then
										if (Enum > 32) then
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
									elseif (Enum == 34) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 37) then
									if (Enum == 36) then
										Stk[Inst[2]] = Upvalues[Inst[3]];
									else
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Inst[3]));
										end
									end
								elseif (Enum > 38) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 43) then
								if (Enum <= 41) then
									if (Enum == 40) then
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
									else
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum > 42) then
									local B;
									local A;
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
							elseif (Enum <= 45) then
								if (Enum > 44) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								end
							elseif (Enum == 46) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 55) then
							if (Enum <= 51) then
								if (Enum <= 49) then
									if (Enum == 48) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 50) then
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
							elseif (Enum <= 53) then
								if (Enum == 52) then
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
							elseif (Enum == 54) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 59) then
							if (Enum <= 57) then
								if (Enum > 56) then
									if (Inst[2] == Inst[4]) then
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
							elseif (Enum == 58) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 61) then
							if (Enum > 60) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
						elseif (Enum == 62) then
							local A = Inst[2];
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
					elseif (Enum <= 95) then
						if (Enum <= 79) then
							if (Enum <= 71) then
								if (Enum <= 67) then
									if (Enum <= 65) then
										if (Enum > 64) then
											Env[Inst[3]] = Stk[Inst[2]];
										else
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum == 66) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 69) then
									if (Enum == 68) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 70) then
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 75) then
								if (Enum <= 73) then
									if (Enum > 72) then
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
								elseif (Enum == 74) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 77) then
								if (Enum > 76) then
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
								if (Stk[Inst[2]] < Inst[4]) then
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
						elseif (Enum <= 87) then
							if (Enum <= 83) then
								if (Enum <= 81) then
									if (Enum == 80) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 82) then
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
							elseif (Enum <= 85) then
								if (Enum > 84) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum == 86) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 91) then
							if (Enum <= 89) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 90) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 93) then
							if (Enum > 92) then
								VIP = Inst[3];
							else
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							end
						elseif (Enum > 94) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 111) then
						if (Enum <= 103) then
							if (Enum <= 99) then
								if (Enum <= 97) then
									if (Enum == 96) then
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
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
								elseif (Enum == 98) then
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
								elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum <= 101) then
								if (Enum == 100) then
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
							elseif (Enum > 102) then
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
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 107) then
							if (Enum <= 105) then
								if (Enum > 104) then
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
							elseif (Enum > 106) then
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
						elseif (Enum <= 109) then
							if (Enum > 108) then
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
						elseif (Enum == 110) then
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
					elseif (Enum <= 119) then
						if (Enum <= 115) then
							if (Enum <= 113) then
								if (Enum > 112) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 114) then
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
							if (Enum > 116) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum == 118) then
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
						end
					elseif (Enum <= 123) then
						if (Enum <= 121) then
							if (Enum > 120) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
						elseif (Enum > 122) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 125) then
						if (Enum > 124) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 126) then
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
					elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 191) then
					if (Enum <= 159) then
						if (Enum <= 143) then
							if (Enum <= 135) then
								if (Enum <= 131) then
									if (Enum <= 129) then
										if (Enum == 128) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum == 130) then
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
								elseif (Enum <= 133) then
									if (Enum > 132) then
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
								elseif (Enum > 134) then
									do
										return Stk[Inst[2]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 139) then
								if (Enum <= 137) then
									if (Enum == 136) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 138) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 141) then
								if (Enum > 140) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 142) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 151) then
							if (Enum <= 147) then
								if (Enum <= 145) then
									if (Enum > 144) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 146) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 149) then
								if (Enum == 148) then
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
							elseif (Enum == 150) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 155) then
							if (Enum <= 153) then
								if (Enum == 152) then
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
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum == 154) then
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
						elseif (Enum <= 157) then
							if (Enum > 156) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 158) then
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
							do
								return Stk[Inst[2]]();
							end
						end
					elseif (Enum <= 175) then
						if (Enum <= 167) then
							if (Enum <= 163) then
								if (Enum <= 161) then
									if (Enum == 160) then
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
								elseif (Enum > 162) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 165) then
								if (Enum > 164) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 171) then
							if (Enum <= 169) then
								if (Enum == 168) then
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
							elseif (Enum == 170) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 173) then
							if (Enum == 172) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 174) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 183) then
						if (Enum <= 179) then
							if (Enum <= 177) then
								if (Enum == 176) then
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
							elseif (Enum == 178) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 181) then
							if (Enum == 180) then
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
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum > 182) then
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
					elseif (Enum <= 187) then
						if (Enum <= 185) then
							if (Enum == 184) then
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
						elseif (Enum == 186) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 189) then
						if (Enum == 188) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 190) then
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
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 223) then
					if (Enum <= 207) then
						if (Enum <= 199) then
							if (Enum <= 195) then
								if (Enum <= 193) then
									if (Enum == 192) then
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
								elseif (Enum > 194) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
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
							elseif (Enum <= 197) then
								if (Enum > 196) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 198) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 203) then
							if (Enum <= 201) then
								if (Enum == 200) then
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
							elseif (Enum > 202) then
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
								if (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 205) then
							if (Enum == 204) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 206) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 215) then
						if (Enum <= 211) then
							if (Enum <= 209) then
								if (Enum > 208) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum > 210) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 213) then
							if (Enum > 212) then
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
						elseif (Enum > 214) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
					elseif (Enum <= 219) then
						if (Enum <= 217) then
							if (Enum > 216) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum == 218) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 221) then
						if (Enum > 220) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 222) then
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
						if (Stk[Inst[2]] < Inst[4]) then
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
				elseif (Enum <= 239) then
					if (Enum <= 231) then
						if (Enum <= 227) then
							if (Enum <= 225) then
								if (Enum > 224) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 226) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 229) then
							if (Enum == 228) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 230) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 235) then
						if (Enum <= 233) then
							if (Enum == 232) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 234) then
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
					elseif (Enum <= 237) then
						if (Enum > 236) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 238) then
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
						if (Inst[2] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Top));
					end
				elseif (Enum <= 247) then
					if (Enum <= 243) then
						if (Enum <= 241) then
							if (Enum == 240) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum > 242) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
						end
					elseif (Enum <= 245) then
						if (Enum > 244) then
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
							VIP = Inst[3];
						end
					elseif (Enum > 246) then
						if (Stk[Inst[2]] <= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						Stk[Inst[2]] = Stk[Inst[3]];
					end
				elseif (Enum <= 251) then
					if (Enum <= 249) then
						if (Enum > 248) then
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
							local B = Inst[3];
							local K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
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
					end
				elseif (Enum <= 253) then
					if (Enum == 252) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 254) then
					Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
				elseif (Enum == 255) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD99ED111DAC6C91AD6A9C20DD4D1CD24F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O000B5B37CD6E34EA21403BC76E21EE2B583BC74710E82744309B5D04FD03073O009C4E2B5EB53171002C3O0012653O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100045D3O000A0001001263000300063O002064000400030007001263000500083O002064000500050009001263000600083O00206400060006000A00061C00073O000100062O00F63O00064O00F68O00F63O00044O00F63O00014O00F63O00024O00F63O00053O00206400080003000B00206400090003000C2O0097000A5O001263000B000D3O00061C000C0001000100022O00F63O000A4O00F63O000B4O00F6000D00073O001252000E000E3O001252000F000F4O002E000D000F000200061C000E0002000100012O00F63O00074O0076000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O000400025O00122O000300016O00045O00122O000500013O00042O0003002100012O002400076O0013000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O000100040B0003000500012O0024000300054O00F6000400024O0025000300044O003800036O00733O00017O00133O00028O00026O00F03F025O00C88040025O00608F40025O0052A240025O00088140025O00C49940025O00606E40025O008CAE40025O00F2A840025O00549F40025O0050B240025O00DCB140025O007C9840025O0078A940025O0062AD40025O00688340025O0093B240025O00FCAA4001563O001252000200014O00B3000300053O0026C8000200070001000100045D3O00070001001252000300014O00B3000400043O001252000200023O00269A0002000B0001000200045D3O000B0001002E39000300F9FF2O000400045D3O000200012O00B3000500053O0026C8000300110001000100045D3O00110001001252000400014O00B3000500053O001252000300023O00269A000300150001000200045D3O00150001002E1A0005000C0001000600045D3O000C0001001252000600014O00B3000700073O0026C8000600170001000100045D3O00170001001252000700013O002E1A0008001A0001000700045D3O001A00010026C80007001A0001000100045D3O001A00010026C8000400440001000100045D3O00440001001252000800013O00269A000800250001000200045D3O00250001002E19000900270001000A00045D3O00270001001252000400023O00045D3O00440001002E39000B00FAFF2O000B00045D3O002100010026C8000800210001000100045D3O00210001001252000900013O002E1A000D003C0001000C00045D3O003C00010026C80009003C0001000100045D3O003C00012O0024000A6O00AF0005000A3O002E1A000E003B0001000F00045D3O003B00010006E50005003B0001000100045D3O003B00012O0024000A00014O00F6000B6O0037000C6O002C000A6O0038000A5O001252000900023O00269A000900400001000200045D3O00400001002E39001000EEFF2O001100045D3O002C0001001252000800023O00045D3O0021000100045D3O002C000100045D3O00210001002E1A001300150001001200045D3O001500010026C8000400150001000200045D3O001500012O00F6000800054O003700096O002C00086O003800085O00045D3O0015000100045D3O001A000100045D3O0015000100045D3O0017000100045D3O0015000100045D3O0055000100045D3O000C000100045D3O0055000100045D3O000200012O00733O00017O00503O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A62030B3O0021BB9823E90DB5873ED70503053O00B962DAEB57030D3O00E83D34F2FFA4C52O33E7CAAFCF03063O00CAAB5C4786BE030D3O000AC03F9C1AD42B8F2CD2388D2D03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03053O0021CF5D607103083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D92O033O00C63B2D03073O009CA84E40E0D47903073O0024E1A8C308E0B603043O00AE678EC503083O00733E5A2A3C51F65303073O009836483F58453E03043O00D6CBE15003043O003CB4A48E03063O00737472696E6703063O005E51172426F903073O0072383E6549478D031B3O00476574556E6974456D706F77657253746167654475726174696F6E028O00026O00F03F03063O009DFFD4CFBDFB03043O00A4D889BB030C3O00E2F434A1A3EC1DD3F238BDA803073O006BB28651D2C69E03063O001D188DCDAF2A03053O00CA586EE2A6030C3O00F31D87E4CFD11983E3C3CC0103053O00AAA36FE29703063O003426BD334B2503073O00497150D2582E57030C3O00B13EC801E2933ACC06EE8E2203053O0087E14CAD72030C3O0047657445717569706D656E74026O002A40026O002C40024O0080B3C54003103O005265676973746572466F724576656E7403183O002AC1992O898F983FDC8D999C908234D98793849C893DC89C03073O00C77A8DD8D0CCDD03143O009DF131C95DC492EF35D75DD892F83ED15ADA88F903063O0096CDBD70901803063O0053657441504C025O00F0964000E3013O00B0000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0014000F00142O002400155O0012D0001600223O00122O001700236O0015001700024O0015000F00154O00165O00122O001700243O00122O001800256O0016001800024O0016000F00164O00175O00122O001800263O00122O001900276O0017001900024O0016001600174O00175O00122O001800283O00122O001900296O0017001900024O0017000F00174O00185O00122O0019002A3O00122O001A002B6O0018001A00024O0017001700184O00185O00122O0019002C3O00122O001A002D6O0018001A00024O0017001700184O00185O00122O0019002E3O00122O001A002F6O0018001A00024O0018000F00184O00195O00122O001A00303O00122O001B00316O0019001B00024O0018001800194O00195O00122O001A00323O00122O001B00336O0019001B00024O00180018001900122O001900346O001A5O00122O001B00353O00122O001C00366O001A001C00024O00190019001A00122O001A00373O00122O001B00383O00122O001C00393O00122O001D00393O00122O001E00396O001F8O00208O00218O00228O002300576O00585O00122O0059003A3O00122O005A003B6O0058005A00024O0058000D00584O00595O00122O005A003C3O00122O005B003D6O0059005B00024O0058005800594O00595O00122O005A003E3O00122O005B003F6O0059005B00024O0059000E00594O005A5O00122O005B00403O00122O005C00416O005A005C00024O00590059005A2O0024005A5O001267005B00423O00122O005C00436O005A005C00024O005A0015005A4O005B5O00122O005C00443O00122O005D00456O005B005D00024O005A005A005B4O005B5O00202O005C000800464O005C0002000200202O005D005C004700062O005D00B600013O00045D3O00B600012O00F6005D000E3O002064005E005C00472O003E005D000200020006E5005D00B90001000100045D3O00B900012O00F6005D000E3O001252005E00384O003E005D00020002002064005E005C0048000669005E00C100013O00045D3O00C100012O00F6005E000E3O002064005F005C00482O003E005E000200020006E5005E00C40001000100045D3O00C400012O00F6005E000E3O001252005F00384O003E005E000200022O00B3005F00613O00122B006200493O00122O006300496O006400643O00122O006500383O00122O006600383O00122O006700383O00122O006800383O00202O00690004004A00061C006B3O000100052O00F63O005E4O00F63O005C4O00F63O000E4O00F63O00084O00F63O005D4O00A9006C5O00122O006D004B3O00122O006E004C6O006C006E6O00693O000100201700690004004A00061C006B0001000100022O00F63O00624O00F63O00634O00A9006C5O00122O006D004D3O00122O006E004E6O006C006E6O00693O000100061C00690002000100052O00F63O00584O00248O00F63O00144O00F63O00094O00F63O00643O00061C006A0003000100102O00F63O00244O00F63O00084O00F63O00264O00F63O00254O00248O00F63O00594O00F63O00144O00F63O005A4O00F63O00584O00F63O00524O00F63O00514O00F63O00104O00F63O00314O00F63O00324O00F63O002A4O00F63O002B3O00061C006B0004000100082O00F63O00584O00248O00F63O00164O00F63O000A4O00F63O00144O00F63O005A4O00F63O00504O00F63O00093O00061C006C0005000100052O00F63O00084O00F63O00164O00F63O00584O00F63O000B4O00F63O005A3O00061C006D0006000100032O00F63O00164O00F63O005B4O00F63O00213O00061C006E00070001000A2O00F63O00584O00248O00F63O00144O00F63O00094O00F63O00084O00F63O00644O00F63O00614O00F63O00654O00F63O001C4O00F63O005A3O00061C006F00080001001F2O00F63O00584O00248O00F63O00334O00F63O00164O00F63O00344O00F63O00354O00F63O00144O00F63O000A4O00F63O006D4O00F63O00554O00F63O00564O00F63O00574O00F63O005A4O00F63O00084O00F63O00364O00F63O00374O00F63O00384O00F63O001D4O00F63O00394O00F63O003A4O00F63O003B4O00F63O001E4O00F63O003C4O00F63O003D4O00F63O003E4O00F63O003F4O00F63O00404O00F63O00614O00F63O00654O00F63O001C4O00F63O00093O00061C007000090001001B2O00F63O00584O00248O00F63O00364O00F63O00164O00F63O00374O00F63O00384O00F63O00144O00F63O005A4O00F63O00684O00F63O00664O00F63O001D4O00F63O00394O00F63O003A4O00F63O003B4O00F63O00674O00F63O001E4O00F63O00414O00F63O000A4O00F63O00424O00F63O00104O00F63O00464O00F63O00084O00F63O00474O00F63O00644O00F63O00434O00F63O00444O00F63O00453O00061C0071000A000100112O00F63O00584O00248O00F63O00464O00F63O000A4O00F63O00474O00F63O00144O00F63O005A4O00F63O00644O00F63O004B4O00F63O00164O00F63O004C4O00F63O004D4O00F63O004E4O00F63O004F4O00F63O00484O00F63O00494O00F63O004A3O00061C0072000B000100032O00F63O00714O00F63O000A4O00F63O00703O00061C0073000C000100092O00F63O00294O00F63O00284O00F63O006B4O00F63O006A4O00F63O00724O00F63O006F4O00F63O00164O00F63O006E4O00F63O006C3O00061C0074000D0001000B2O00F63O00294O00F63O00284O00F63O006B4O00F63O001F4O00F63O00724O00F63O00584O00248O00F63O00084O00F63O00164O00F63O00144O00F63O00693O00061C0075000E000100332O00F63O00434O00248O00F63O00444O00F63O00454O00F63O00414O00F63O00424O00F63O00404O00F63O003C4O00F63O003D4O00F63O003E4O00F63O003F4O00F63O00284O00F63O00294O00F63O002A4O00F63O002B4O00F63O002C4O00F63O004D4O00F63O004E4O00F63O004F4O00F63O004B4O00F63O004C4O00F63O00234O00F63O00244O00F63O00274O00F63O00254O00F63O00264O00F63O00374O00F63O00384O00F63O003B4O00F63O00394O00F63O003A4O00F63O00504O00F63O00514O00F63O00524O00F63O00534O00F63O00544O00F63O00484O00F63O00494O00F63O00464O00F63O00474O00F63O004A4O00F63O00314O00F63O002F4O00F63O00304O00F63O002D4O00F63O002E4O00F63O00364O00F63O00344O00F63O00354O00F63O00324O00F63O00333O00061C0076000F000100042O00F63O00574O00248O00F63O00554O00F63O00563O00061C00770010000100202O00F63O00084O00F63O001B4O00F63O00224O00248O00F63O002D4O00F63O00164O00F63O00584O00F63O005A4O00F63O00284O00F63O002C4O00F63O00214O00F63O001F4O00F63O00204O00F63O00614O00F63O00604O00F63O005F4O00F63O00094O00F63O001D4O00F63O00044O00F63O00624O00F63O00634O00F63O001C4O00F63O00754O00F63O00764O00F63O00684O00F63O00534O00F63O00544O00F63O00144O00F63O00644O00F63O001E4O00F63O00734O00F63O00743O00061C00780011000100042O00F63O00164O00248O00F63O00064O00F63O000F3O0020000179000F004F00122O007A00506O007B00776O007C00786O0079007C00016O00013O00123O00093O00028O00026O00F03F026O002C40030C3O0047657445717569706D656E74026O002A40025O00D3B240025O001C9940025O00C2B140025O00A09D4000433O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O0026C8000100160001000200045D3O001600012O0024000200013O0020640002000200030006690002001100013O00045D3O001100012O0024000200024O0024000300013O0020640003000300032O003E0002000200020006E5000200140001000100045D3O001400012O0024000200023O001252000300014O003E0002000200022O00F200025O00045D3O004200010026C8000100050001000100045D3O00050001001252000200013O0026C8000200380001000100045D3O00380001001252000300013O0026C8000300310001000100045D3O003100012O0024000400033O0020850004000400044O0004000200024O000400016O000400013O00202O00040004000500062O0004002C00013O00045D3O002C00012O0024000400024O0024000500013O0020640005000500052O003E0004000200020006E50004002F0001000100045D3O002F00012O0024000400023O001252000500014O003E0004000200022O00F2000400043O001252000300023O002E190007001C0001000600045D3O001C00010026C80003001C0001000200045D3O001C0001001252000200023O00045D3O0038000100045D3O001C0001002E19000900190001000800045D3O001900010026C8000200190001000200045D3O00190001001252000100023O00045D3O0005000100045D3O0019000100045D3O0005000100045D3O0042000100045D3O000200012O00733O00017O00043O00028O00025O00B4AB40025O00288D40024O0080B3C54000123O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O002E1A000300050001000200045D3O000500010026C8000100050001000100045D3O00050001001252000200044O00F200025O001252000200044O00F2000200013O00045D3O0011000100045D3O0005000100045D3O0011000100045D3O000200012O00733O00017O00123O00028O00030B3O00098DA9450A8F371C2489BA03083O007045E4DF2C64E871030A3O0049734361737461626C65030B3O004C6976696E67466C616D6503093O004973496E52616E6765026O003940025O0022AF40025O00B0A84003163O00D81611DAB87BB9D21306DEB33C96C61A04DCBB7E87C003073O00E6B47F67B3D61C025O000C9F40030B3O00AD1F4A54E172F49E0C544303073O0080EC653F268421030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E676503163O00ADB30456B3D4DCB8BB184FB3ABDFBEAC124BBBE9CEB803073O00AFCCC97124D68B00463O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O0026C8000100050001000100045D3O000500012O002400026O0096000300013O00122O000400023O00122O000500036O0003000500024O00020002000300202O0002000200044O00020002000200062O0002002400013O00045D3O002400012O0024000200024O00FA00035O00202O0003000300054O000400033O00202O00040004000600122O000600076O0004000600024O000400046O000500046O00020005000200062O0002001F0001000100045D3O001F0001002E19000800240001000900045D3O002400012O0024000200013O0012520003000A3O0012520004000B4O0025000200044O003800025O002E39000C00210001000C00045D3O004500012O002400026O0096000300013O00122O0004000D3O00122O0005000E6O0003000500024O00020002000300202O0002000200044O00020002000200062O0002004500013O00045D3O004500012O0024000200024O002A00035O00202O00030003000F4O000400033O00202O0004000400104O00065O00202O00060006000F4O0004000600024O000400046O00020004000200062O0002004500013O00045D3O004500012O0024000200013O00122F000300113O00122O000400126O000200046O00025O00044O0045000100045D3O0005000100045D3O0045000100045D3O000200012O00733O00017O00213O00028O00026O00F03F03103O004865616C746850657263656E74616765025O00108F40025O00BCB14003193O00D74B7618E05D7803EB493022E04F7C03EB49303AEA5A7905EB03043O006A852E1003173O006A2575EE5F5350297DFB7245592C7AF25D7057347AF35403063O00203840139C3A03073O004973526561647903173O0052656672657368696E674865616C696E67506F74696F6E03253O0048CDE3445FE18853C6E21652F78156C1EB511AE28F4EC1EA581AF6855CCDEB4553E4851A9C03073O00E03AA885363A92030D3O006B5345F8628F890C7B5A4AE77003083O006B39362B9D15E6E7030A3O0049734361737461626C65030D3O0052656E6577696E67426C617A6503173O00E98E1FF0AED5C1DCA91DF4A3D98FDF8E17F0B7CFC6CD8E03073O00AFBBEB7195D9BC025O0035B340025O00407440025O0020B340030E3O0068CE26D5004ECD3BEF0746C030CF03053O006427AC55BC03083O0042752O66446F776E030E3O004F6273696469616E5363616C6573031A3O00A27AAA8937A479B7BF20AE79B58520ED7CBC8636A36BB09636BE03053O0053CD18D9E0030B3O00CEC0CC31F2CDDE29E9CBC803043O005D86A5AD030B3O004865616C746873746F6E6503173O00B6F7C0CE2EC6A16AB1FCC4823ECBB47BB0E1C8D43F8EE103083O001EDE92A1A25AAED200A83O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O000E55000200500001000100045D3O005000012O002400025O0006690002003000013O00045D3O003000012O0024000200013O0020170002000200032O003E0002000200022O0024000300023O00060A000200300001000300045D3O00300001002E19000400300001000500045D3O003000012O0024000200034O00D6000300043O00122O000400063O00122O000500076O00030005000200062O000200300001000300045D3O003000012O0024000200054O0096000300043O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002003000013O00045D3O003000012O0024000200064O0056000300073O00202O00030003000B4O000400056O000600016O00020006000200062O0002003000013O00045D3O003000012O0024000200043O0012520003000C3O0012520004000D4O0025000200044O003800026O0024000200084O0096000300043O00122O0004000E3O00122O0005000F6O0003000500024O00020002000300202O0002000200104O00020002000200062O000200A700013O00045D3O00A700012O0024000200013O0020170002000200032O003E0002000200022O0024000300093O00067F000200A70001000300045D3O00A700012O00240002000A3O000669000200A700013O00045D3O00A700012O00240002000B4O00B7000300083O00202O0003000300114O000400056O00020005000200062O000200A700013O00045D3O00A700012O0024000200043O00122F000300123O00122O000400136O000200046O00025O00044O00A700010026C8000100050001000100045D3O00050001001252000200013O002E39001400060001001400045D3O005900010026C8000200590001000200045D3O00590001001252000100023O00045D3O0005000100269A0002005D0001000100045D3O005D0001002E1A001600530001001500045D3O005300012O0024000300084O0096000400043O00122O000500173O00122O000600186O0004000600024O00030003000400202O0003000300104O00030002000200062O0003008200013O00045D3O008200012O00240003000C3O0006690003008200013O00045D3O008200012O0024000300013O0020FC0003000300194O000500083O00202O00050005001A4O00030005000200062O0003008200013O00045D3O008200012O0024000300013O0020170003000300032O003E0003000200022O00240004000D3O00067F000300820001000400045D3O008200012O0024000300064O0024000400083O00206400040004001A2O003E0003000200020006690003008200013O00045D3O008200012O0024000300043O0012520004001B3O0012520005001C4O0025000300054O003800036O0024000300054O0096000400043O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300A200013O00045D3O00A200012O00240003000E3O000669000300A200013O00045D3O00A200012O0024000300013O0020170003000300032O003E0003000200022O00240004000F3O00060A000300A20001000400045D3O00A200012O0024000300064O0056000400073O00202O00040004001F4O000500066O000700016O00030007000200062O000300A200013O00045D3O00A200012O0024000300043O001252000400203O001252000500214O0025000300054O003800035O001252000200023O00045D3O0053000100045D3O0005000100045D3O00A7000100045D3O000200012O00733O00017O00263O00028O00025O00208840025O003EB240026O00F03F025O00C8A840025O0024A44003103O009ED83558B8CB2956B4D7276AB1D82D4903043O002CDDB94003073O004973526561647903123O00556E69744861734375727365446562752O6603143O00556E697448617344697365617365446562752O6603153O00436175746572697A696E67466C616D65466F637573025O00888640025O00108A4003183O0002E65D4B7613EE52567D06D84E53720CE2085B7A12F74D5303053O00136187283F030E3O00814C23292A22BD553D3C1D3EAF4E03063O0051CE3C535B4F03113O00556E6974486173456E7261676542752O66025O00809440025O00BCA440030E3O004F2O7072652O73696E67526F617203163O0061BBC0602AD05EAD40AC904020C25FE44AA2C3622ACF03083O00C42ECBB0124FA32D025O001AA940025O0034994003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E6974025O0094AD40025O0064B04003073O0019B79159ED7E7D03073O00185CCFE12C831903123O00556E69744861734D61676963446562752O66030C3O00457870756E6765466F637573030E3O004ECBA859157A4E93BC45086D4EDF03063O001D2BB3D82C7B00973O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O002E1A0002004F0001000300045D3O004F00010026C80001004F0001000400045D3O004F0001002E190006002E0001000500045D3O002E00012O002400026O0096000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002002E00013O00045D3O002E00012O0024000200023O00206400020002000A2O0024000300034O003E0002000200020006E5000200210001000100045D3O002100012O0024000200023O00206400020002000B2O0024000300034O003E0002000200020006690002002E00013O00045D3O002E00012O0024000200044O0024000300053O00206400030003000C2O003E0002000200020006E5000200290001000100045D3O00290001002E39000D00070001000E00045D3O002E00012O0024000200013O0012520003000F3O001252000400104O0025000200044O003800026O002400026O0096000300013O00122O000400113O00122O000500126O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009600013O00045D3O009600012O0024000200063O0006690002009600013O00045D3O009600012O0024000200023O0020640002000200132O0024000300074O003E0002000200020006690002009600013O00045D3O00960001002E1A001400960001001500045D3O009600012O0024000200044O002400035O0020640003000300162O003E0002000200020006690002009600013O00045D3O009600012O0024000200013O00122F000300173O00122O000400186O000200046O00025O00044O00960001000E55000100050001000100045D3O00050001001252000200013O002E19001A008E0001001900045D3O008E00010026C80002008E0001000100045D3O008E00012O0024000300033O0006690003006B00013O00045D3O006B00012O0024000300033O00201700030003001B2O003E0003000200020006690003006B00013O00045D3O006B00012O0024000300033O00201700030003001C0012520005001D4O002E0003000500020006690003006B00013O00045D3O006B00012O0024000300023O00206400030003001E2O00A80003000100020006690003006B00013O00045D3O006B0001002E1A0020006C0001001F00045D3O006C00012O00733O00014O002400036O0096000400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300094O00030002000200062O0003008D00013O00045D3O008D00012O0024000300023O0020640003000300232O0024000400034O003E0003000200020006E5000300820001000100045D3O008200012O0024000300023O00206400030003000B2O0024000400034O003E0003000200020006690003008D00013O00045D3O008D00012O0024000300044O0024000400053O0020640004000400242O003E0003000200020006690003008D00013O00045D3O008D00012O0024000300013O001252000400253O001252000500264O0025000300054O003800035O001252000200043O0026C8000200520001000400045D3O00520001001252000100043O00045D3O0005000100045D3O0052000100045D3O0005000100045D3O0096000100045D3O000200012O00733O00017O001F3O0003093O00497343617374696E67030C3O0049734368612O6E656C696E67028O00026O00F03F025O007AB04003113O00496E74652O72757074576974685374756E03093O005461696C5377697065026O002040025O00B49740025O00A4AF40027O0040025O0026B14003093O00496E74652O7275707403053O005175652O6C026O002440030E3O005175652O6C4D6F7573656F766572025O00FC9D40025O00107240025O00D49240025O00788740025O0002A440025O00D49A40025O00EC9A40025O0020AC40025O008EA940025O00849940025O003EA840025O0072A640025O0026AC40025O00A88640025O0036A640007D4O00247O0020175O00012O003E3O000200020006E53O007C0001000100045D3O007C00012O00247O0020175O00022O003E3O000200020006E53O007C0001000100045D3O007C00010012523O00034O00B3000100023O0026C83O006A0001000400045D3O006A00010026C80001002D0001000400045D3O002D0001001252000300034O00B3000400043O002E3900053O0001000500045D3O001200010026C8000300120001000300045D3O00120001001252000400033O0026C8000400240001000300045D3O002400012O0024000500013O0020EC0005000500064O000600023O00202O00060006000700122O000700086O0005000700024O000200053O00062O0002002300013O00045D3O002300012O0087000200023O001252000400043O002E1A000900170001000A00045D3O001700010026C8000400170001000400045D3O001700010012520001000B3O00045D3O002D000100045D3O0017000100045D3O002D000100045D3O00120001002E39000C00150001000C00045D3O004200010026C8000100420001000B00045D3O004200012O0024000300013O0020EE00030003000D4O000400023O00202O00040004000E00122O0005000F6O000600016O000700036O000800043O00202O0008000800104O0003000800024O000200033O002E2O0012007C0001001100045D3O007C00010006690002007C00013O00045D3O007C00012O0087000200023O00045D3O007C000100269A000100460001000300045D3O00460001002E1A0013000E0001001400045D3O000E0001001252000300034O00B3000400043O000E020003004C0001000300045D3O004C0001002E19001500480001001600045D3O00480001001252000400033O002E190017005F0001001800045D3O005F00010026C80004005F0001000300045D3O005F00012O0024000500013O0020B400050005000D4O000600023O00202O00060006000E00122O0007000F6O000800016O0005000800024O000200053O002E2O001A005E0001001900045D3O005E00010006690002005E00013O00045D3O005E00012O0087000200023O001252000400043O002E19001C004D0001001B00045D3O004D00010026C80004004D0001000400045D3O004D0001001252000100043O00045D3O000E000100045D3O004D000100045D3O000E000100045D3O0048000100045D3O000E000100045D3O007C000100269A3O006E0001000300045D3O006E0001002E39001D00A0FF2O001E00045D3O000C0001001252000300033O0026C8000300730001000400045D3O007300010012523O00043O00045D3O000C0001002E39001F00FCFF2O001F00045D3O006F00010026C80003006F0001000300045D3O006F0001001252000100034O00B3000200023O001252000300043O00045D3O006F000100045D3O000C00012O00733O00017O00103O00028O00026O00F03F025O00C06540025O00A6A340025O003BB140025O00909F40030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574026O004440025O000C9540025O006DB14003133O0048616E646C65426F2O746F6D5472696E6B6574025O00F4B040025O0070A640025O00C08140025O003EA140004C3O0012523O00014O00B3000100023O0026C83O00430001000200045D3O004300010026C8000100040001000100045D3O00040001001252000200013O00269A0002000B0001000100045D3O000B0001002E190004002B0001000300045D3O002B0001001252000300014O00B3000400043O002E190006000D0001000500045D3O000D00010026C80003000D0001000100045D3O000D0001001252000400013O0026C8000400240001000100045D3O002400012O002400055O0020150005000500084O000600016O000700023O00122O000800096O000900096O00050009000200122O000500073O002E2O000A00070001000A00045D3O00230001001263000500073O0006690005002300013O00045D3O00230001001263000500074O0087000500023O001252000400023O000E55000200120001000400045D3O00120001001252000200023O00045D3O002B000100045D3O0012000100045D3O002B000100045D3O000D0001002E39000B00DCFF2O000B00045D3O000700010026C8000200070001000200045D3O000700012O002400035O0020BF00030003000C4O000400016O000500023O00122O000600096O000700076O00030007000200122O000300073O00122O000300073O00062O0003003C0001000100045D3O003C0001002E39000D00110001000E00045D3O004B0001001263000300074O0087000300023O00045D3O004B000100045D3O0007000100045D3O004B000100045D3O0004000100045D3O004B0001002E19000F00020001001000045D3O000200010026C83O00020001000100045D3O00020001001252000100014O00B3000200023O0012523O00023O00045D3O000200012O00733O00017O00443O00028O00025O009AAD40025O00F88A40026O00F03F025O00C06D40025O0085B340027O0040030B3O001B0CE1A73F25E0A7331DF103043O00D55A7694030A3O0049734361737461626C65025O00BDB040025O00B6AD40030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E676503133O005A34A14448643DA02O44502BF4524C562FB35303053O002D3B4ED436025O00E0A440025O002EB340030C3O00D9BA434C72CBF8B4424468DA03063O00BF9DD330251C03073O004973526561647903063O0042752O66557003103O00452O73656E6365427572737442752O66025O0018A740025O0001B140030C3O00446973696E7465677261746503133O00DB16E71534CB1AF30E3BCB1AB4183BD21EF31903053O005ABF7F947C025O009CAB40025O0062A040030B3O00548E381E7680081B798A2B03043O007718E74E025O006EA940025O00B08040030B3O004C6976696E67466C616D6503133O008E24B343D2472E8421A447D900158320A44DD903073O0071E24DC52ABC20025O009EB040025O006CB140025O0035B240025O0035B140025O00DFB140025O005C9E40030B3O00942B68172AFCC9B423731B03073O008FD8421E7E449B03113O004C656170696E67466C616D657342752O6603223O00A6C11BC2CBA4E8E7A6C900CEFAAFD2E0BAC103CCFAA5DBE0A7CD1E8BC1A2DAE0ADCD03083O0081CAA86DABA5C3B7030A3O00045125DDFC06E3234C3F03073O0086423857B8BE74025O00607440025O00C49140025O00109440026O00A840025O00C4AA40025O0088AF40025O0017B140025O00B0AE40026O001040026O001840026O000840025O008AA440025O007AA740030F3O00466972654272656174684D6163726F03093O004973496E52616E6765026O003E4003133O003A381BBE26E933303D2501FB1DEA2C343B344903083O00555C5169DB798B410032012O0012523O00014O00B3000100023O00269A3O00060001000100045D3O00060001002E19000200090001000300045D3O00090001001252000100014O00B3000200023O0012523O00043O0026C83O00020001000400045D3O00020001002E1A0005000B0001000600045D3O000B00010026C80001000B0001000100045D3O000B0001001252000200013O0026C8000200300001000700045D3O003000012O002400036O0096000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300312O013O00045D3O00312O01002E1A000C00312O01000B00045D3O00312O012O0024000300024O002A00045O00202O00040004000D4O000500033O00202O00050005000E4O00075O00202O00070007000D4O0005000700024O000500056O00030005000200062O000300312O013O00045D3O00312O012O0024000300013O00122F0004000F3O00122O000500106O000300056O00035O00044O00312O01002E1A0011008A0001001200045D3O008A0001000E550004008A0001000200045D3O008A0001001252000300013O0026C8000300390001000400045D3O00390001001252000200073O00045D3O008A00010026C8000300350001000100045D3O00350001001252000400013O000E55000100840001000400045D3O008400012O002400056O0096000600013O00122O000700133O00122O000800146O0006000800024O00050005000600202O0005000500154O00050002000200062O0005004F00013O00045D3O004F00012O0024000500043O0020610005000500164O00075O00202O0007000700174O00050007000200062O000500510001000100045D3O00510001002E1A001900630001001800045D3O006300012O0024000500024O00B900065O00202O00060006001A4O000700033O00202O00070007000E4O00095O00202O00090009001A4O0007000900024O000700076O000800056O00050008000200062O0005006300013O00045D3O006300012O0024000500013O0012520006001B3O0012520007001C4O0025000500074O003800055O002E1A001E00830001001D00045D3O008300012O002400056O0096000600013O00122O0007001F3O00122O000800206O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005008300013O00045D3O00830001002E19002200830001002100045D3O008300012O0024000500024O00B900065O00202O0006000600234O000700033O00202O00070007000E4O00095O00202O0009000900234O0007000900024O000700076O000800056O00050008000200062O0005008300013O00045D3O008300012O0024000500013O001252000600243O001252000700254O0025000500074O003800055O001252000400043O0026C80004003C0001000400045D3O003C0001001252000300043O00045D3O0035000100045D3O003C000100045D3O00350001002E1A002600100001002700045D3O001000010026C8000200100001000100045D3O00100001001252000300013O00269A000300930001000100045D3O00930001002E19002800272O01002900045D3O00272O01002E19002B00B80001002A00045D3O00B800012O002400046O0096000500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400B800013O00045D3O00B800012O0024000400043O0020FC0004000400164O00065O00202O00060006002E4O00040006000200062O000400B800013O00045D3O00B800012O0024000400024O00B900055O00202O0005000500234O000600033O00202O00060006000E4O00085O00202O0008000800234O0006000800024O000600066O000700056O00040007000200062O000400B800013O00045D3O00B800012O0024000400013O0012520005002F3O001252000600304O0025000400064O003800046O002400046O0096000500013O00122O000600313O00122O000700326O0005000700024O00040004000500202O0004000400154O00040002000200062O000400262O013O00045D3O00262O01001252000400014O00B3000500063O00269A000400C80001000400045D3O00C80001002E1A003400202O01003300045D3O00202O01002E3900353O0001003500045D3O00C800010026C8000500C80001000100045D3O00C80001001252000600013O00269A000600D10001000100045D3O00D10001002E19003700042O01003600045D3O00042O01001252000700014O00B3000800083O000E55000100D30001000700045D3O00D30001001252000800013O00269A000800DA0001000100045D3O00DA0001002E1A003900FD0001003800045D3O00FD0001001252000900013O0026C8000900F60001000100045D3O00F600012O0024000A00063O0026F7000A00E30001000700045D3O00E30001001252000A00044O00F2000A00073O00045D3O00F30001002E39003A00080001003A00045D3O00EB00012O0024000A00063O0026F7000A00EB0001003B00045D3O00EB0001001252000A00074O00F2000A00073O00045D3O00F300012O0024000A00063O0026F7000A00F10001003C00045D3O00F10001001252000A003D4O00F2000A00073O00045D3O00F30001001252000A003B4O00F2000A00074O0024000A00074O00F2000A00083O001252000900043O000E02000400FA0001000900045D3O00FA0001002E19003F00DB0001003E00045D3O00DB0001001252000800043O00045D3O00FD000100045D3O00DB00010026C8000800D60001000400045D3O00D60001001252000600043O00045D3O00042O0100045D3O00D6000100045D3O00042O0100045D3O00D300010026C8000600CD0001000400045D3O00CD00012O0024000700024O0092000800093O00202O0008000800404O000900033O00202O00090009004100122O000B00426O0009000B00024O000900096O000A00016O000B000B6O000C00016O0007000C000200062O000700262O013O00045D3O00262O012O0024000700013O0012BD000800433O00122O000900446O0007000900024O000800076O0007000700084O000700023O00044O00262O0100045D3O00CD000100045D3O00262O0100045D3O00C8000100045D3O00262O010026C8000400C40001000100045D3O00C40001001252000500014O00B3000600063O001252000400043O00045D3O00C40001001252000300043O000E550004008F0001000300045D3O008F0001001252000200043O00045D3O0010000100045D3O008F000100045D3O0010000100045D3O00312O0100045D3O000B000100045D3O00312O0100045D3O000200012O00733O00017O00733O00028O00026O00F03F025O0078A440025O00607A40025O00A09D40025O00049D40025O00E89640025O00C07E4003063O00234282988F3D03083O00907036E3EBE64ECD03073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503063O00537461736973030F3O00A03C0EEFD948F32B00F3DC5FBC3F0103063O003BD3486F9CB0027O0040025O00208B40025O001AAE4003063O0045786973747303093O004973496E52616E6765026O003E40025O005C9C40025O006DB240025O00AEAC40026O006B40025O00C07140030B3O002520033B50273E0F3D551503053O003D6152665A030A3O0049734361737461626C6503093O008D3AEB68D2450D06BE03083O0069CC4ECB2BA7377E03113O00447265616D466C69676874437572736F7203153O0081B8261F1E3BE15DACAD2B0A5307C85EA9AE2C091D03083O0031C5CA437E7364A7025O0072A940025O003EA140030B3O001349DA288D70523E5CD73D03073O003E573BBF49E036030C3O00C40DF4CFEE10F7C8F30BF5C703043O00A987629A030B3O00447265616D466C6967687403153O00EF652155F00CEEC77E235CE973CBC4782850F224C603073O00A8AB1744349D53025O004EA040025O00206140025O00A6AE40025O009BB24003103O007D93E23E4794D1284F84F7245886F72803043O004D2EE78303063O0042752O665570030A3O0053746173697342752O66030B3O0042752O6652656D61696E73026O000840025O00409B4003103O0053746173697352656163746976617465031A3O00A940B753B3478952BF55B554B342B754BF14B54FB558B24FAD5A03043O0020DA34D6026O006F40025O00F89140030C3O007A1E219CF9B576594F1B34BB03083O003A2E7751C891D025030B3O000F9E35ADA49F242E8D24A403073O00564BEC50CCC9DD025O0034AF40025O00607240025O00A49940025O00A8854003173O005469705468655363616C6573447265616D42726561746803153O0076537284F3B470537284EA833242788AF28F7D567903063O00EB122117E59E025O00A7B140025O0076A140025O00E08B40025O00F49240030B3O0063AAC8A959AEC3B75FB5CC03043O00DB30DAA103173O005469705468655363616C6573537069726974626C2O6F6D03153O00F761755BD25BDFE67D7346D60FE3EB7E704DD458EE03073O008084111C29BB2F025O00E2A940025O002FB24003063O00C674E2A42B2903073O00E7941195CD454D03063O00526577696E64025O00E8AE40025O0022A540030F3O0092A2D0F259FBC0A4C8F45BFB8FB0C903063O009FE0C7A79B37025O009C9E40025O00BAA740030C3O00C3FA31D7D3FA30D3E3FA33DC03043O00B297935C03103O004865616C746850657263656E7461676503113O0054696D6544696C6174696F6E466F63757303163O0098F441372D487380FC583B1D423A8FF2433E16436D8203073O001AEC9D2C52722C030A3O000C27C75E083CD05A3E2603043O003B4A4EB5025O00649340025O004AA140025O0029B340025O006EB340025O00CAAB40025O00107740026O001040025O000AAC40025O0056A740025O001AB140025O004AA640026O001840025O00C09A40025O0024AC40030F3O00466972654272656174684D6163726F03103O0023D8485F8C27C35F5BA72D91595EA06503053O00D345B12O3A0014022O0012523O00014O00B3000100023O0026C83O00070001000100045D3O00070001001252000100014O00B3000200023O0012523O00023O00269A3O000B0001000200045D3O000B0001002E19000300020001000400045D3O00020001002E1A0006005D0001000500045D3O005D00010026C80001005D0001000100045D3O005D0001001252000300013O002E19000800370001000700045D3O003700010026C8000300370001000200045D3O003700010006690002001700013O00045D3O001700012O0087000200024O002400046O0096000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003600013O00045D3O003600012O0024000400023O0006690004003600013O00045D3O003600012O0024000400033O00202100040004000C4O000500046O000600056O00040006000200062O0004003600013O00045D3O003600012O0024000400064O002400055O00206400050005000D2O003E0004000200020006690004003600013O00045D3O003600012O0024000400013O0012520005000E3O0012520006000F4O0025000400064O003800045O001252000300103O0026C8000300560001000100045D3O00560001001252000400013O002E1A001100510001001200045D3O005100010026C8000400510001000100045D3O005100012O0024000500073O0006690005004C00013O00045D3O004C00012O0024000500073O0020170005000500132O003E0005000200020006690005004C00013O00045D3O004C00012O0024000500073O002017000500050014001252000700154O002E0005000700020006E50005004D0001000100045D3O004D00012O00733O00014O0024000500084O00A80005000100022O00F6000200053O001252000400023O000E550002003A0001000400045D3O003A0001001252000300023O00045D3O0056000100045D3O003A000100269A0003005A0001001000045D3O005A0001002E1A001700100001001600045D3O00100001001252000100023O00045D3O005D000100045D3O00100001002E390018000B2O01001800045D3O00682O010026C8000100682O01000200045D3O00682O01001252000300013O002E19001900AF0001001A00045D3O00AF0001000E55000200AF0001000300045D3O00AF00012O002400046O0096000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004001D4O00040002000200062O0004008900013O00045D3O008900012O0024000400094O00D6000500013O00122O0006001E3O00122O0007001F6O00050007000200062O000400890001000500045D3O008900012O0024000400033O00202100040004000C4O0005000A6O0006000B6O00040006000200062O0004008900013O00045D3O008900012O0024000400064O00240005000C3O0020640005000500202O003E0004000200020006690004008900013O00045D3O008900012O0024000400013O001252000500213O001252000600224O0025000400064O003800045O002E1A002400AE0001002300045D3O00AE00012O002400046O0096000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400AE00013O00045D3O00AE00012O0024000400094O00D6000500013O00122O000600273O00122O000700286O00050007000200062O000400AE0001000500045D3O00AE00012O0024000400033O00202100040004000C4O0005000A6O0006000B6O00040006000200062O000400AE00013O00045D3O00AE00012O0024000400064O002400055O0020640005000500292O003E000400020002000669000400AE00013O00045D3O00AE00012O0024000400013O0012520005002A3O0012520006002B4O0025000400064O003800045O001252000300103O0026C8000300632O01000100045D3O00632O01001252000400013O00269A000400B60001000200045D3O00B60001002E1A002C00B80001002D00045D3O00B80001001252000300023O00045D3O00632O0100269A000400BC0001000100045D3O00BC0001002E19002F00B20001002E00045D3O00B200012O002400056O0096000600013O00122O000700303O00122O000800316O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500EB00013O00045D3O00EB00012O0024000500023O000669000500EB00013O00045D3O00EB00012O0024000500033O00207A00050005000C4O000600046O000700056O00050007000200062O000500DE0001000100045D3O00DE00012O00240005000D3O0020FC0005000500324O00075O00202O0007000700334O00050007000200062O000500EB00013O00045D3O00EB00012O00240005000D3O00201D0005000500344O00075O00202O0007000700334O00050007000200262O000500EB0001003500045D3O00EB0001002E390036000D0001003600045D3O00EB00012O0024000500064O002400065O0020640006000600372O003E000500020002000669000500EB00013O00045D3O00EB00012O0024000500013O001252000600383O001252000700394O0025000500074O003800055O002E19003A00612O01003B00045D3O00612O012O002400056O0096000600013O00122O0007003C3O00122O0008003D6O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500612O013O00045D3O00612O012O002400056O0096000600013O00122O0007003E3O00122O0008003F6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500332O013O00045D3O00332O012O00240005000E3O000669000500332O013O00045D3O00332O012O0024000500033O00202100050005000C4O0006000F6O000700106O00050007000200062O000500332O013O00045D3O00332O01001252000500014O00B3000600073O002E190041002A2O01004000045D3O002A2O01000E550002002A2O01000500045D3O002A2O010026C8000600112O01000100045D3O00112O01001252000700013O002E1A004300142O01004200045D3O00142O010026C8000700142O01000100045D3O00142O01001252000800024O006C000800116O000800066O0009000C3O00202O0009000900444O00080002000200062O000800612O013O00045D3O00612O012O0024000800013O00122F000900453O00122O000A00466O0008000A6O00085O00044O00612O0100045D3O00142O0100045D3O00612O0100045D3O00112O0100045D3O00612O0100269A0005002E2O01000100045D3O002E2O01002E1A0047000D2O01004800045D3O000D2O01001252000600014O00B3000700073O001252000500023O00045D3O000D2O0100045D3O00612O01002E1A004900612O01004A00045D3O00612O012O002400056O0096000600013O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500612O013O00045D3O00612O012O0024000500123O000669000500612O013O00045D3O00612O012O0024000500033O00202100050005000C4O000600136O000700146O00050007000200062O000500612O013O00045D3O00612O01001252000500014O00B3000600063O0026C80005004B2O01000100045D3O004B2O01001252000600013O0026C80006004E2O01000100045D3O004E2O01001252000700354O006C000700156O000700066O0008000C3O00202O00080008004D4O00070002000200062O000700612O013O00045D3O00612O012O0024000700013O00122F0008004E3O00122O0009004F6O000700096O00075O00044O00612O0100045D3O004E2O0100045D3O00612O0100045D3O004B2O01001252000400023O00045D3O00B200010026C8000300620001001000045D3O00620001001252000100103O00045D3O00682O0100045D3O00620001000E550010000B0001000100045D3O000B0001002E190050008D2O01005100045D3O008D2O012O002400036O0096000400013O00122O000500523O00122O000600536O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003008D2O013O00045D3O008D2O012O0024000300163O0006690003008D2O013O00045D3O008D2O012O0024000300033O00202100030003000C4O000400176O000500186O00030005000200062O0003008D2O013O00045D3O008D2O012O0024000300064O002400045O0020640004000400542O003E0003000200020006E5000300882O01000100045D3O00882O01002E1A0055008D2O01005600045D3O008D2O012O0024000300013O001252000400573O001252000500584O0025000300054O003800035O002E1A005900AD2O01005A00045D3O00AD2O012O002400036O0096000400013O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300AD2O013O00045D3O00AD2O012O0024000300193O000669000300AD2O013O00045D3O00AD2O012O0024000300073O00201700030003005D2O003E0003000200022O00240004001A3O00060A000300AD2O01000400045D3O00AD2O012O0024000300064O00240004000C3O00206400040004005E2O003E000300020002000669000300AD2O013O00045D3O00AD2O012O0024000300013O0012520004005F3O001252000500604O0025000300054O003800036O002400036O0096000400013O00122O000500613O00122O000600626O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003001302013O00045D3O00130201001252000300014O00B3000400053O00269A000300BD2O01000100045D3O00BD2O01002E1A006400C02O01006300045D3O00C02O01001252000400014O00B3000500053O001252000300023O0026C8000300B92O01000200045D3O00B92O010026C8000400C22O01000100045D3O00C22O01001252000500013O002E1A006500F02O01006600045D3O00F02O010026C8000500F02O01000100045D3O00F02O01001252000600013O002E39006700060001006700045D3O00D02O010026C8000600D02O01000200045D3O00D02O01001252000500023O00045D3O00F02O01000E55000100CA2O01000600045D3O00CA2O01002E39006800080001006800045D3O00DA2O012O00240007001B3O0026F7000700DA2O01001000045D3O00DA2O01001252000700024O00F20007001C3O00045D3O00EC2O012O00240007001B3O002612000700DF2O01006900045D3O00DF2O01002E1A006A00E22O01006B00045D3O00E22O01001252000700104O00F20007001C3O00045D3O00EC2O01002E1A006D00EA2O01006C00045D3O00EA2O012O00240007001B3O0026F7000700EA2O01006E00045D3O00EA2O01001252000700354O00F20007001C3O00045D3O00EC2O01001252000700694O00F20007001C4O00240007001C4O00F20007001D3O001252000600023O00045D3O00CA2O0100269A000500F42O01000200045D3O00F42O01002E1A007000C52O01006F00045D3O00C52O012O0024000600064O00920007000C3O00202O0007000700714O0008001E3O00202O00080008001400122O000A00156O0008000A00024O000800086O000900016O000A000A6O000B00016O0006000B000200062O0006001302013O00045D3O001302012O0024000600013O0012BD000700723O00122O000800736O0006000800024O0007001C6O0006000600074O000600023O00044O0013020100045D3O00C52O0100045D3O0013020100045D3O00C22O0100045D3O0013020100045D3O00B92O0100045D3O0013020100045D3O000B000100045D3O0013020100045D3O000200012O00733O00017O00613O00028O00025O00BBB140025O005AA540027O0040030B3O00C630E25D7653D4E723F35403073O00A68242873C1B1103073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O004EA440025O00188040026O00F03F03103O00447265616D4272656174684D6163726F025O0054AD40025O0050894003183O004058CB743D7B48DC703150428E743F4175C670314843C07203053O0050242AAE15025O00849940025O00E49E40025O00B0B140025O0046AC40030B3O007D003E6847043576411F3A03043O001A2E7057025O00806540025O0058A040025O0090A040026O000840025O00BCA240025O00607640025O00A6A240025O001DB24003103O00537069726974626C2O6F6D466F63757303183O00AA33A266B6AB7AB6B52CA479FFBE4AB1862BAE75B3B64BB303083O00D4D943CB142ODF25025O00C49340025O00AEA540025O004EB140025O00804940025O003C9D40025O00389F40025O0046A040025O00E4AE40025O00049D40025O00804D4003083O001B29FCE32730F7F403043O00915E5F99030E3O00CBC806D14FB9E9E819D75CB6FEC803063O00D79DAD74B52E03103O004865616C746850657263656E7461676503133O0056657264616E74456D6272616365466F637573025O00409340025O00CAA740031B3O0023B199F6DB3BA0B4F7D737A68AF1DF75B584F7E53DB18AFED33BB303053O00BA55D4EB9203083O00EC8E02BE0DEF56C903073O0038A2E1769E598E030E3O006A00D2AB23D64820CDAD30D95F0003063O00B83C65A0CF42030D3O00556E697447726F7570526F6C6503043O0005A3529703043O00DC51E21C031B3O0005D090FFEBC907EA87F6E8D512D687BBEBC816EA8AFEEBCB1ADB8503063O00A773B5E29B8A026O005A40025O00B6B140025O002EA740030B3O009684BEDBB48A8EDEBB80AD03043O00B2DAEDC8030A3O0049734361737461626C6503063O0042752O66557003113O004C656170696E67466C616D657342752O6603103O004C6976696E67466C616D65466F637573030E3O0049735370652O6C496E52616E6765030B3O004C6976696E67466C616D65025O00F2AA40025O0080A24003273O00BABCF0D9B8B2D9D6BAB4EBD589B9E3D1A6BCE8D789B3EAD1BBB0F590B7BAE3EFBEB0E7DCBFBBE103043O00B0D6D586025O007DB240025O00B8AB40025O00549F40025O004FB240030E3O0092E87CE7E8C7B3C7752OFAD8B8E803063O00ABD785199589025O009C9B40025O00A08C40025O000AAC40025O00C4AC4003133O00456D6572616C64426C6F2O736F6D466F637573031B3O00E4C537E8EE3CF87DE3C43DE9FC3FF102E0C737C5E735FD4EE8C63503083O002281A8529A8F509C030B3O00B5BE32124D5CC9AABC3F1203073O00E9E5D2536B282E030E3O00F74720D204CF5617DB07D34331D303053O0065A12252B603143O0056657264616E74456D6272616365506C61796572031B3O00FE084BFADAEC9611ED005BECDAE1876EE9025CC1D3E78322E1035E03083O004E886D399EBB82E2009A012O0012523O00014O00B3000100013O002E19000300020001000200045D3O000200010026C83O00020001000100045D3O00020001001252000100013O0026C8000100980001000400045D3O00980001001252000200013O0026C8000200930001000100045D3O00930001001252000300013O0026C80003008C0001000100045D3O008C00012O002400046O0096000500013O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400074O00040002000200062O0004005000013O00045D3O005000012O0024000400023O0006690004005000013O00045D3O005000012O0024000400033O0020210004000400084O000500046O000600056O00040006000200062O0004005000013O00045D3O00500001001252000400014O00B3000500053O00269A000400290001000100045D3O00290001002E19000900250001000A00045D3O00250001001252000500013O0026C80005003C0001000B00045D3O003C00012O0024000600064O0077000700073O00202O00070007000C4O000800086O000900016O00060009000200062O000600360001000100045D3O00360001002E1A000D00500001000E00045D3O005000012O0024000600013O00122F0007000F3O00122O000800106O000600086O00065O00044O00500001002E190011002A0001001200045D3O002A00010026C80005002A0001000100045D3O002A0001002E19001400480001001300045D3O004800012O0024000600083O0026F7000600480001000400045D3O004800010012520006000B4O00F2000600093O00045D3O004A0001001252000600044O00F2000600094O0024000600094O00F20006000A3O0012520005000B3O00045D3O002A000100045D3O0050000100045D3O002500012O002400046O0096000500013O00122O000600153O00122O000700166O0005000700024O00040004000500202O0004000400074O00040002000200062O0004008B00013O00045D3O008B00012O00240004000B3O0006690004008B00013O00045D3O008B00012O0024000400033O0020210004000400084O0005000C6O0006000D6O00040006000200062O0004008B00013O00045D3O008B0001001252000400013O00269A000400690001000100045D3O00690001002E19001800760001001700045D3O00760001002E39001900080001001900045D3O007100012O0024000500083O000E4B000400710001000500045D3O007100010012520005001A4O00F20005000E3O00045D3O007300010012520005000B4O00F20005000E3O0012520005001A4O00F20005000F3O0012520004000B3O00269A0004007A0001000B00045D3O007A0001002E39001B00EDFF2O001C00045D3O00650001002E1A001D008B0001001E00045D3O008B00012O0024000500064O0056000600073O00202O00060006001F4O000700076O000800016O00050008000200062O0005008B00013O00045D3O008B00012O0024000500013O00122F000600203O00122O000700216O000500076O00055O00044O008B000100045D3O006500010012520003000B3O002E1A0022000D0001002300045D3O000D00010026C80003000D0001000B00045D3O000D00010012520002000B3O00045D3O0093000100045D3O000D00010026C80002000A0001000B00045D3O000A00010012520001001A3O00045D3O0098000100045D3O000A000100269A0001009C0001000B00045D3O009C0001002E1A0024000E2O01002500045D3O000E2O01001252000200014O00B3000300033O002E190026009E0001002700045D3O009E00010026C80002009E0001000100045D3O009E0001001252000300013O00269A000300A70001000100045D3O00A70001002E19002900052O01002800045D3O00052O01001252000400013O002E1A002B2O002O01002A00045D4O002O010026C800042O002O01000100045D4O002O012O0024000500104O00D4000600013O00122O0007002C3O00122O0008002D6O00060008000200062O000500B40001000600045D3O00B4000100045D3O00D200012O002400056O0096000600013O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O0005000500074O00050002000200062O000500D200013O00045D3O00D200012O0024000500113O0020170005000500302O003E0005000200022O0024000600123O00067F000500D20001000600045D3O00D200012O0024000500134O0042000600073O00202O0006000600314O000700076O00050007000200062O000500CD0001000100045D3O00CD0001002E39003200070001003300045D3O00D200012O0024000500013O001252000600343O001252000700354O0025000500074O003800056O0024000500104O00D6000600013O00122O000700363O00122O000800376O00060008000200062O000500FF0001000600045D3O00FF00012O002400056O0096000600013O00122O000700383O00122O000800396O0006000800024O00050005000600202O0005000500074O00050002000200062O000500FF00013O00045D3O00FF00012O0024000500113O0020170005000500302O003E0005000200022O0024000600123O00067F000500FF0001000600045D3O00FF00012O0024000500033O00200F00050005003A4O000600116O0005000200024O000600013O00122O0007003B3O00122O0008003C6O00060008000200062O000500FF0001000600045D3O00FF00012O0024000500134O00B7000600073O00202O0006000600314O000700076O00050007000200062O000500FF00013O00045D3O00FF00012O0024000500013O0012520006003D3O0012520007003E4O0025000500074O003800055O0012520004000B3O0026C8000400A80001000B00045D3O00A800010012520003000B3O00045D3O00052O0100045D3O00A80001002E39003F009EFF2O003F00045D3O00A300010026C8000300A30001000B00045D3O00A30001001252000100043O00045D3O000E2O0100045D3O00A3000100045D3O000E2O0100045D3O009E0001002E1A004100412O01004000045D3O00412O010026C8000100412O01001A00045D3O00412O012O002400026O0096000300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200444O00020002000200062O000200992O013O00045D3O00992O012O0024000200143O000669000200992O013O00045D3O00992O012O0024000200153O0020FC0002000200454O00045O00202O0004000400464O00020004000200062O000200992O013O00045D3O00992O012O0024000200113O0020170002000200302O003E0002000200022O0024000300163O00060A000200992O01000300045D3O00992O012O0024000200064O0062000300073O00202O0003000300474O000400113O00202O0004000400484O00065O00202O0006000600494O0004000600024O000400046O000500176O00020005000200062O0002003B2O01000100045D3O003B2O01002E19004A00992O01004B00045D3O00992O012O0024000200013O00122F0003004C3O00122O0004004D6O000200046O00025O00044O00992O01002E19004F00070001004E00045D3O000700010026C8000100070001000100045D3O00070001001252000200013O0026C80002004A2O01000B00045D3O004A2O010012520001000B3O00045D3O0007000100269A0002004E2O01000100045D3O004E2O01002E1A005100462O01005000045D3O00462O012O002400036O0096000400013O00122O000500523O00122O000600536O0004000600024O00030003000400202O0003000300444O00030002000200062O000300622O013O00045D3O00622O012O0024000300183O000669000300622O013O00045D3O00622O012O0024000300033O00207A0003000300084O000400196O0005001A6O00030005000200062O000300642O01000100045D3O00642O01002E19005400712O01005500045D3O00712O01002E1A005600712O01005700045D3O00712O012O0024000300064O0024000400073O0020640004000400582O003E000300020002000669000300712O013O00045D3O00712O012O0024000300013O001252000400593O0012520005005A4O0025000300054O003800036O0024000300104O00D6000400013O00122O0005005B3O00122O0006005C6O00040006000200062O000300942O01000400045D3O00942O012O002400036O0096000400013O00122O0005005D3O00122O0006005E6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300942O013O00045D3O00942O012O0024000300153O0020170003000300302O003E0003000200022O0024000400123O00067F000300942O01000400045D3O00942O012O0024000300134O00B7000400073O00202O00040004005F4O000500056O00030005000200062O000300942O013O00045D3O00942O012O0024000300013O001252000400603O001252000500614O0025000300054O003800035O0012520002000B3O00045D3O00462O0100045D3O0007000100045D3O00992O0100045D3O000200012O00733O00017O003D3O00028O00025O00C05240025O00E07A40027O0040030B3O00A8C816B03136EE88C00DBC03073O00A8E4A160D95F5103073O004973526561647903103O004865616C746850657263656E74616765025O003DB040025O0026A94003103O004C6976696E67466C616D65466F637573030E3O0049735370652O6C496E52616E6765030B3O004C6976696E67466C616D6503173O00D7D838552150E4D7225D22529BC23A632752DADD27522803063O0037BBB14E3C4F025O007C9C40025O00BCA540026O00F03F025O00D4AA40025O00909B40030F3O00F51700E50D62B8CD3303FA0F71B5D803073O00D9A1726D956210031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030F3O0054656D706F72616C416E6F6D616C7903093O004973496E52616E6765026O003E40031B3O000625356CB366132C077DB27B1F213465FC67061F3079BD781B2E3F03063O00147240581CDC025O0090AF40025O00709C4003043O001402DABB03073O00DD5161B2D498B003063O0042752O66557003043O004563686F025O0060B040025O00C2A34003093O004563686F466F637573030F3O00C8E415F45ADEF322F31FCCEB14F51D03053O007AAD877D9B025O00489840025O002AA240025O00509140025O00ADB14003093O00C6A8A0D1BA4550FBA303073O003994CDD6B4C836030D3O00556E697447726F7570526F6C6503043O0026DC1B1F03053O0016729D5554031A3O00467269656E646C79556E6974735769746842752O66436F756E7403093O00526576657273696F6E030E3O00526576657273696F6E466F63757303193O00D6CE05C14FE5A1CBC52CD05CF8A384D807FB55F3A9C8C21DC303073O00C8A4AB73A43D9603093O008CF1154091ADFD0C4B03053O00E3DE94632503043O0007737CDD03053O0099532O3296025O000FB140025O0008AA4003193O004F73651961B84452784C0872A5461D6567237BAE4C517F7D1B03073O002D3D16137C13CB0003012O0012523O00014O00B3000100013O00269A3O00060001000100045D3O00060001002E19000300020001000200045D3O00020001001252000100013O0026C8000100310001000400045D3O003100012O002400026O0096000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001C00013O00045D3O001C00012O0024000200023O0006690002001C00013O00045D3O001C00012O0024000200033O0020170002000200082O003E0002000200022O0024000300043O000699000200030001000300045D3O001E0001002E19000900022O01000A00045D3O00022O012O0024000200054O00B9000300063O00202O00030003000B4O000400033O00202O00040004000C4O00065O00202O00060006000D4O0004000600024O000400046O000500076O00020005000200062O000200022O013O00045D3O00022O012O0024000200013O00122F0003000E3O00122O0004000F6O000200046O00025O00044O00022O01002E1A0010008E0001001100045D3O008E0001000E550012008E0001000100045D3O008E0001001252000200013O0026C80002003A0001001200045D3O003A0001001252000100043O00045D3O008E0001000E55000100360001000200045D3O00360001002E19001400630001001300045D3O006300012O002400036O0096000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O0003000300074O00030002000200062O0003006300013O00045D3O006300012O0024000300083O0006690003006300013O00045D3O006300012O0024000300093O0020210003000300174O0004000A6O0005000B6O00030005000200062O0003006300013O00045D3O006300012O0024000300054O007200045O00202O0004000400184O000500033O00202O00050005001900122O0007001A6O0005000700024O000500056O000600076O00030006000200062O0003006300013O00045D3O006300012O0024000300013O0012520004001B3O0012520005001C4O0025000300054O003800035O002E1A001E008C0001001D00045D3O008C00012O002400036O0096000400013O00122O0005001F3O00122O000600206O0004000600024O00030003000400202O0003000300074O00030002000200062O0003008C00013O00045D3O008C00012O00240003000C3O0006690003008C00013O00045D3O008C00012O0024000300033O0020610003000300214O00055O00202O0005000500224O00030005000200062O0003008C0001000100045D3O008C00012O0024000300033O0020170003000300082O003E0003000200022O00240004000D3O00060A0003008C0001000400045D3O008C0001002E190024008C0001002300045D3O008C00012O0024000300054O0024000400063O0020640004000400252O003E0003000200020006690003008C00013O00045D3O008C00012O0024000300013O001252000400263O001252000500274O0025000300054O003800035O001252000200123O00045D3O00360001002E1A002800070001002900045D3O00070001000E55000100070001000100045D3O00070001001252000200013O002E1A002A00FA0001002B00045D3O00FA0001000E55000100FA0001000200045D3O00FA00012O002400036O0096000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300C600013O00045D3O00C600012O00240003000E3O000669000300C600013O00045D3O00C600012O0024000300093O00200F00030003002E4O000400036O0003000200024O000400013O00122O0005002F3O00122O000600306O00040006000200062O000300C60001000400045D3O00C600012O0024000300093O0020DF0003000300314O00045O00202O0004000400324O00030002000200262O000300C60001001200045D3O00C600012O0024000300033O0020170003000300082O003E0003000200022O00240004000F3O00060A000300C60001000400045D3O00C600012O0024000300054O0024000400063O0020640004000400332O003E000300020002000669000300C600013O00045D3O00C600012O0024000300013O001252000400343O001252000500354O0025000300054O003800036O002400036O0096000400013O00122O000500363O00122O000600376O0004000600024O00030003000400202O0003000300074O00030002000200062O000300EC00013O00045D3O00EC00012O00240003000E3O000669000300EC00013O00045D3O00EC00012O0024000300093O0020EB00030003002E4O000400036O0003000200024O000400013O00122O000500383O00122O000600396O00040006000200062O000300EC0001000400045D3O00EC00012O0024000300093O0020F50003000300314O00045O00202O0004000400324O000500016O00068O00030006000200262O000300EC0001001200045D3O00EC00012O0024000300033O0020170003000300082O003E0003000200022O0024000400103O000699000300030001000400045D3O00EE0001002E19003A00F90001003B00045D3O00F900012O0024000300054O0024000400063O0020640004000400332O003E000300020002000669000300F900013O00045D3O00F900012O0024000300013O0012520004003C3O0012520005003D4O0025000300054O003800035O001252000200123O0026C8000200930001001200045D3O00930001001252000100123O00045D3O0007000100045D3O0093000100045D3O0007000100045D3O00022O0100045D3O000200012O00733O00017O00193O00028O00026O00F03F025O00A0A640025O0021B240027O0040025O00908B40026O003540025O008AA240025O00B5B240025O00BC9C40025O00C09140025O00CCAA40025O00608740025O00E0A140025O00D88B40025O0079B14003063O0045786973747303093O004973496E52616E6765026O003E40025O00FEA740025O00AEA440025O00C88340025O00A09940025O0068AD40025O00C8A24000653O0012523O00014O00B3000100023O00269A3O00060001000200045D3O00060001002E1A0004005C0001000300045D3O005C00010026C8000100250001000200045D3O00250001001252000300013O0026C80003000D0001000200045D3O000D0001001252000100053O00045D3O00250001002E1A000700090001000600045D3O000900010026C8000300090001000100045D3O00090001001252000400013O002E190008001D0001000900045D3O001D00010026C80004001D0001000100045D3O001D00010006690002001900013O00045D3O001900012O0087000200024O002400056O00A80005000100022O00F6000200053O001252000400023O00269A000400210001000200045D3O00210001002E1A000A00120001000B00045D3O00120001001252000300023O00045D3O0009000100045D3O0012000100045D3O00090001002E39000C002D0001000C00045D3O00520001000E55000100520001000100045D3O00520001001252000300013O0026C80003002E0001000200045D3O002E0001001252000100023O00045D3O00520001002E19000D002A0001000E00045D3O002A00010026C80003002A0001000100045D3O002A0001001252000400013O0026C8000400370001000200045D3O00370001001252000300023O00045D3O002A0001002E1A000F00330001001000045D3O003300010026C8000400330001000100045D3O003300012O0024000500013O0006690005004B00013O00045D3O004B00012O0024000500013O0020170005000500112O003E0005000200020006690005004B00013O00045D3O004B00012O0024000500013O002017000500050012001252000700134O002E0005000700020006690005004B00013O00045D3O004B0001002E190014004C0001001500045D3O004C00012O00733O00014O0024000500024O00A80005000100022O00F6000200053O001252000400023O00045D3O0033000100045D3O002A00010026C8000100060001000500045D3O000600010006E5000200580001000100045D3O00580001002E1A001700640001001600045D3O006400012O0087000200023O00045D3O0064000100045D3O0006000100045D3O00640001002E1A001900020001001800045D3O000200010026C83O00020001000100045D3O00020001001252000100014O00B3000200023O0012523O00023O00045D3O000200012O00733O00017O002A3O00028O00025O00C6AD40025O003EB040026O00F03F025O00388740025O00804740025O001EAC40025O008C9040025O006C9540025O0096A340025O002EAC40025O00D0A340025O00989140025O00B6AC40026O000840025O0020AA40025O003EAC40025O00A8B240025O00406A40026O001040025O006AA440025O0080A540025O00BEB140025O008EA040027O0040025O003C9040025O00207540025O0023B040025O0002B240025O0021B040026O008540030D3O00546172676574497356616C6964025O00D88F40025O0014AB40025O00207240025O00B88A40025O00F9B140025O005EB140025O00188F40025O0066A040025O00088E40025O004CAF4000C43O0012523O00014O00B3000100023O00269A3O00060001000100045D3O00060001002E19000300090001000200045D3O00090001001252000100014O00B3000200023O0012523O00043O0026C83O00020001000400045D3O00020001002E1A000600480001000500045D3O004800010026C8000100480001000100045D3O00480001001252000300013O002E19000800430001000700045D3O004300010026C8000300430001000100045D3O00430001002E190009003F0001000A00045D3O003F00012O002400045O0006E50004001C0001000100045D3O001C00012O0024000400013O0006690004003F00013O00045D3O003F0001001252000400014O00B3000500073O00269A000400220001000100045D3O00220001002E39000B00050001000C00045D3O00250001001252000500014O00B3000600063O001252000400043O0026C80004001E0001000400045D3O001E00012O00B3000700073O0026C8000500350001000400045D3O003500010026C80006002A0001000100045D3O002A00012O0024000800024O00A80008000100022O00F6000700083O0006690007003F00013O00045D3O003F00012O0087000700023O00045D3O003F000100045D3O002A000100045D3O003F0001002E1A000D00280001000E00045D3O002800010026C8000500280001000100045D3O00280001001252000600014O00B3000700073O001252000500043O00045D3O0028000100045D3O003F000100045D3O001E00012O0024000400034O00A80004000100022O00F6000200043O001252000300043O000E55000400100001000300045D3O00100001001252000100043O00045D3O0048000100045D3O001000010026C8000100650001000F00045D3O00650001001252000300013O00269A0003004F0001000100045D3O004F0001002E19001100600001001000045D3O00600001001252000400013O0026C8000400590001000100045D3O005900010006690002005500013O00045D3O005500012O0087000200024O0024000500044O00A80005000100022O00F6000200053O001252000400043O00269A0004005D0001000400045D3O005D0001002E19001200500001001300045D3O00500001001252000300043O00045D3O0060000100045D3O005000010026C80003004B0001000400045D3O004B0001001252000100143O00045D3O0065000100045D3O004B000100269A000100690001000400045D3O00690001002E1A0016007E0001001500045D3O007E0001001252000300013O002E1A001800700001001700045D3O007000010026C8000300700001000400045D3O00700001001252000100193O00045D3O007E000100269A000300740001000100045D3O00740001002E39001A00F8FF2O001B00045D3O006A00010006E5000200780001000100045D3O00780001002E1A001D00790001001C00045D3O007900012O0087000200024O0024000400054O00A80004000100022O00F6000200043O001252000300043O00045D3O006A0001002E19001F00AF0001001E00045D3O00AF0001000E55001400AF0001000100045D3O00AF00010006690002008500013O00045D3O008500012O0087000200024O0024000300063O0020640003000300202O00A8000300010002000669000300C300013O00045D3O00C30001001252000300014O00B3000400053O002E1A002100A60001002200045D3O00A600010026C8000300A60001000400045D3O00A60001002E19002300900001002400045D3O009000010026C8000400900001000100045D3O00900001001252000500013O002E1A002600950001002500045D3O009500010026C8000500950001000100045D3O009500012O0024000600074O00A80006000100022O00F6000200063O0006E5000200A00001000100045D3O00A00001002E19002800C30001002700045D3O00C300012O0087000200023O00045D3O00C3000100045D3O0095000100045D3O00C3000100045D3O0090000100045D3O00C30001002E1A0029008C0001002A00045D3O008C00010026C80003008C0001000100045D3O008C0001001252000400014O00B3000500053O001252000300043O00045D3O008C000100045D3O00C300010026C80001000B0001001900045D3O000B0001001252000300013O0026C8000300BB0001000100045D3O00BB0001000669000200B700013O00045D3O00B700012O0087000200024O0024000400084O00A80004000100022O00F6000200043O001252000300043O0026C8000300B20001000400045D3O00B200010012520001000F3O00045D3O000B000100045D3O00B2000100045D3O000B000100045D3O00C3000100045D3O000200012O00733O00017O00213O00028O00025O000CA540025O00F6B240025O004EB040025O002AAD40026O00F03F025O0084A440025O00408440025O00EC9840025O003CA040025O008C9940025O00688440025O0034AD4003163O00557365426C652O73696E676F6674686542726F6E7A6503133O000FC25AF855C68E2AC159FF4ECAA23FC151F14303073O00E04DAE3F8B26AF030A3O0049734361737461626C6503083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E67025O00F6AE40025O0086B24003133O00426C652O73696E676F6674686542726F6E7A6503203O00864D5D3D97485629BB4E5E1190495D11865357209E44183E96445B218943593A03043O004EE42138030D3O00546172676574497356616C6964025O00D0AF40025O0057B240025O0058A140025O0092A640025O0032B340025O002FB140025O0098AC40008A3O0012523O00013O002E1A000200010001000300045D3O000100010026C83O00010001000100045D3O000100012O002400015O0006E50001000B0001000100045D3O000B00012O0024000100013O0006690001002200013O00045D3O00220001001252000100014O00B3000200033O00269A000100110001000100045D3O00110001002E19000400140001000500045D3O00140001001252000200014O00B3000300033O001252000100063O0026C80001000D0001000600045D3O000D00010026C8000200160001000100045D3O001600012O0024000400024O00A80004000100022O00F6000300043O0006690003002200013O00045D3O002200012O0087000300023O00045D3O0022000100045D3O0016000100045D3O0022000100045D3O000D00012O0024000100033O0006E5000100270001000100045D3O00270001002E19000700890001000800045D3O00890001001252000100014O00B3000200033O002E190009007F0001000A00045D3O007F0001000E550006007F0001000100045D3O007F00010026C8000200380001000100045D3O003800012O0024000400044O00A80004000100022O00F6000300043O002E1A000C00370001000B00045D3O003700010006690003003700013O00045D3O003700012O0087000300023O001252000200063O002E39000D00F5FF2O000D00045D3O002D00010026C80002002D0001000600045D3O002D00010012630004000E3O0006690004005800013O00045D3O005800012O0024000400054O0096000500063O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004005800013O00045D3O005800012O0024000400073O00209C0004000400124O000600053O00202O0006000600134O000700016O00040007000200062O0004005A0001000100045D3O005A00012O0024000400083O0020050004000400144O000500053O00202O0005000500134O00040002000200062O0004005A0001000100045D3O005A0001002E1A001600650001001500045D3O006500012O0024000400094O0024000500053O0020640005000500172O003E0004000200020006690004006500013O00045D3O006500012O0024000400063O001252000500183O001252000600194O0025000400064O003800046O0024000400083O00206400040004001A2O00A80004000100020006E50004006C0001000100045D3O006C0001002E1A001C00890001001B00045D3O00890001001252000400014O00B3000500053O00269A000400720001000100045D3O00720001002E1A001E006E0001001D00045D3O006E00012O00240006000A4O00A80006000100022O00F6000500063O0006E5000500790001000100045D3O00790001002E1A001F00890001002000045D3O008900012O0087000500023O00045D3O0089000100045D3O006E000100045D3O0089000100045D3O002D000100045D3O00890001002E39002100AAFF2O002100045D3O002900010026C8000100290001000100045D3O00290001001252000200014O00B3000300033O001252000100063O00045D3O0029000100045D3O0089000100045D3O000100012O00733O00017O0003012O00028O00025O00C6A640025O00806840026O001840025O001EB240025O007CAE40026O00F03F025O00309140025O00309440030C3O004570696353652O74696E677303083O007B74A0EACC4676A703053O00A52811D49E03113O00D0CA0D162BE0CB093F22C7D5072035EAD403053O004685B9685303083O003740503EC00A425703053O00A96425244A03103O00258AA742018BA6720C88B1430F2O8A6003043O003060E7C2025O00188140025O006EAB40027O004003083O00FB5F1A3910D6A89003083O00E3A83A6E4D79B8CF03133O005E31BA52B0D775877733AC53BED656B77429AF03083O00C51B5CDF20D1BB11026O001C40025O00A07340025O00A8A040025O00208D4003083O00EB431467A2A5DF5503063O00CBB8266013CB03133O000F766B45CF37675C4CCC2B727A44FB2A727E4403053O00AE59131921034O0003083O001C17465AFE890C3C03073O006B4F72322E97E703103O000FA3A72D8B37A3E534A4A728893C9FF003083O00A059C6D549EA59D7026O001440025O00F6A640025O000EB14003083O007C50601C465B731B03043O00682F3514030E3O0097458C199806AF4D9515B3018B7C03063O006FC32CE17CDC025O0002AF40025O0092AC4003083O00645D10CA5E5603CD03043O00BE37386403093O0063BC392C16F4FA58AB03073O009336CF5C7E738303083O003E34216904700A2203063O001E6D51551D6D03083O00CD7443BF38DAD4CF03073O009C9F1134D656BE025O008C9540025O00D8964003083O009DEAA9A8A7E1BAAF03043O00DCCE8FDD030B3O00B4783A1ED6C8F59472380703073O00B2E61D4D77B8AC03083O00C6BB1E0F7EF6F2AD03063O009895DE6A7B17030F3O00E835F377BCD023D24AB9DC32FF4CBB03053O00D5BD469623025O00FEB140025O002OAE4003083O008056DE64133352D203083O00A1D333AA107A5D35030D3O00DFA7A138FEA2962DF9BBB42EE803043O00489BCED203083O00757F401A3A487D4703053O0053261A346E030B3O007C1E34565D1B05535E113403043O002638774703083O00C0EA4CC22C58F4FC03063O0036938F38B645030E3O00E392FA61DAD78DEB41CCC28EF14C03053O00BFB6E19F2903083O0018173C418289C53803073O00A24B724835EBE7030D3O00A43945EE470A9F284BEC562ABC03063O0062EC5C24823303083O00971C18AE4CA6B22303083O0050C4796CDA25C8D5030F3O0028720C7B470BAB06750E76481A8F0403073O00EA6013621F2B6E026O002040025O00A89840025O00A08F4003083O00B88121AFE7857A9803073O001DEBE455DB8EEB03143O0009D1B7CD785C265E1CDAB5D076423E752FDBAFCD03083O00325DB4DABD172E4703083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC03073O000956D991F9750203073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A35103063O003F412BAC177903083O006E7A2243C35F2985026O00224003083O00C5F36D158FD2F1E503063O00BC2O961961E603123O00EF9A5A3609E0CA864D0300CCD486520300F403063O008DBAE93F626C03083O00C2EF38A22CFFED3F03053O0045918A4CD603113O0044CA8499B00471C3A887B01B71C390A18F03063O007610AF2OE9DF03083O00FD7BA6178CC079A103053O00E5AE1ED263030A3O002EFE8363EC3E301AE19503073O00597B8DE6318D5D03083O00C074E2181944F46203063O002A9311966C7003103O003AB52857E2E903AF2378D7E71BAF227103063O00886FC64D1F8703083O00072314D4FC3A211303053O0095544660A003163O000D1508CF34031EFE31080AC23E3205E81A1402E3222O03043O008D58666D03083O00310CB342B4EA10BA03083O00C96269C736DD847703113O009109822D0B3BAB890397280D3B82B8018603073O00CCD96CE341625503083O006DC6E1F125CE59D003063O00A03EA395854C030F3O00FEA50C23CAD8A73D20D7DFAF0307F303053O00A3B6C06D4F026O001040025O00BEA240025O0074AA4003083O0098C65F524A443C5E03083O002DCBA32B26232A5B030D3O00F697D9228A8B46D784C82BAF9903073O0034B2E5BC43E7C903083O00122O4410FE52243203073O004341213064973C03103O00FBF5ABD9FEFDF5ABD9E7D7C0BCD7E6CF03053O0093BF87CEB8025O0028AB40025O005DB24003083O003DA864F0028C09BE03063O00E26ECD10846B03103O00D8D3E9CB48FFC1ECD64EE6E4F2D654FB03053O00218BA380B9025O0016B140025O0022AD4003083O00B72DB2D5D15DB59703073O00D2E448C6A1B833030E3O00035AF62363C72440E7127FC1394403063O00AE562993701303083O006805991F2C0116B803083O00CB3B60ED6B456F71030D3O001706A5F338E4D52819A3EC19C003073O00B74476CC815190025O004AB340025O00B4944003083O0046B44F5EDF7BB64803053O00B615D13B2A03113O008244C03231AEA552D60E282OB065CA1C3303063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03103O00909900FC7C78A09D0CC07E54A98B1FCB03063O0016C5EA65AE1903083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB7030F3O00CB11C8F99BA8FE32DB18C7E62O89C003083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD38403084O009E7E77DDB9B1CA03083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F68396903093O002388B24119B3AD490E03043O00246BE7C4025O00E4A640025O002EB040025O00388240025O00A0604003083O00D43FFF64EE34EC6303043O0010875A8B030C3O00616703014B427D46670F3C4003073O0018341466532E3403083O00F72A353006CA283203053O006FA44F4144030B3O00F4DC95DB3CF9CFD68DF61E03063O008AA6B9E3BE4E026O007B4003083O00305AD7EF0A51C4E803043O009B633FA3030E3O00B7C2A4A1B0928BDFA6ABB5858FD403063O00E4E2B1C1EDD903083O0007B537F23DBE24F503043O008654D043030D3O003FA590551DABA05012A183742303043O003C73CCE603083O00F871D1235B2D1ED803073O0079AB14A5573243030F3O00F43DAF33AB11CF37B702B80CCD108903063O0062A658D956D9025O00C09640025O0080B040025O00889A40025O00A0A24003083O00EDA2D1C97AFF5A1D03083O006EBEC7A5BD13913D03113O00EFF872C789D4D3EF7EE985F4D9EA7BED9803063O00A7BA8B1788EB026O00084003083O00B4F11032AB89F31703053O00C2E794644603163O006F42D5A6E4DA535CD58CF8C45F7BC9AAE2CD4A45D2B703063O00A8262CA1C39603083O00B3F9966239E6B10503083O0076E09CE2165088D603123O006BE04D8550FC4C9056DA519247FD518F4EEA03043O00E0228E3903083O00351A46D3A57C8C1503073O00EB667F32A7CC1203113O0078A0FB27482B79AFF62C563E5FB3F0224803063O004E30C195432403083O00031B940C483E199303053O0021507EE07803113O00C5A617C14EFEBD13D06BE5BC0BF748F9A603053O003C8CC863A4025O002EA540025O00C8AD4003083O00231126E1DFA0A52O03073O00C270745295B6CE030E3O000CBB493CD2E70F348A5E1DC1F60603073O006E59C82C78A082025O00508740025O0046A24003083O00C0063D048B561F6503083O001693634970E2387803083O008B61E3E684AB5DD203053O00EDD815829503083O00B13O4BB9C7599103073O003EE22E2O3FD0A9030B3O00D60D5490161E084CEA0C4503083O003E857935E37F6D4F025O0074A740025O00F08B40025O00809540025O0020904003083O0029B09C1913BB8F1E03043O006D7AD5E803103O00C1F5B139EAFEA33EDDF4A33CEBE48A0003043O00508E97C203083O0030C363580AC8705F03043O002C63A61703093O0049E42C0527A56FFE3A03063O00C41C97495653025O00F6A24000B3032O0012523O00014O00B3000100013O002E19000300020001000200045D3O00020001000E550001000200013O00045D3O00020001001252000100013O00269A0001000B0001000400045D3O000B0001002E1A000500770001000600045D3O00770001001252000200013O000E55000700360001000200045D3O00360001001252000300013O00269A000300130001000100045D3O00130001002E190009002F0001000800045D3O002F00010012630004000A4O00DA000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O00045O00122O0004000A6O000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O00040004000500062O0004002D0001000100045D3O002D0001001252000400014O00F2000400023O001252000300073O00269A000300330001000700045D3O00330001002E1A0014000F0001001300045D3O000F0001001252000200153O00045D3O0036000100045D3O000F00010026C8000200490001001500045D3O004900010012630003000A4O00C6000400013O00122O000500163O00122O000600176O0004000600024O0003000300044O000400013O00122O000500183O00122O000600196O0004000600024O00030003000400062O000300460001000100045D3O00460001001252000300014O00F2000300033O0012520001001A3O00045D3O0077000100269A0002004D0001000100045D3O004D0001002E1A001C000C0001001B00045D3O000C0001001252000300013O002E39001D00230001001D00045D3O007100010026C8000300710001000100045D3O007100010012630004000A4O00C6000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O00040004000500062O000400600001000100045D3O00600001001252000400224O00F2000400043O0012F90004000A6O000500013O00122O000600233O00122O000700246O0005000700024O0004000400054O000500013O00122O000600253O00122O000700266O0005000700024O00040004000500062O0004006F0001000100045D3O006F0001001252000400014O00F2000400053O001252000300073O000E550007004E0001000300045D3O004E0001001252000200073O00045D3O000C000100045D3O004E000100045D3O000C000100269A0001007B0001002700045D3O007B0001002E390028005F0001002900045D3O00D80001001252000200013O0026C80002008F0001001500045D3O008F00010012630003000A4O00C6000400013O00122O0005002A3O00122O0006002B6O0004000600024O0003000300044O000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400062O0003008C0001000100045D3O008C0001001252000300014O00F2000300063O001252000100043O00045D3O00D8000100269A000200930001000100045D3O00930001002E19002E00AF0001002F00045D3O00AF00010012630003000A4O00DA000400013O00122O000500303O00122O000600316O0004000600024O0003000300044O000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000300073O00122O0003000A6O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000400013O00122O000500363O00122O000600376O0004000600024O00030003000400062O000300AD0001000100045D3O00AD0001001252000300014O00F2000300083O001252000200073O00269A000200B30001000700045D3O00B30001002E39003800CBFF2O003900045D3O007C0001001252000300013O0026C8000300B80001000700045D3O00B80001001252000200153O00045D3O007C00010026C8000300B40001000100045D3O00B400010012630004000A4O00C6000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500013O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500062O000400C80001000100045D3O00C80001001252000400014O00F2000400093O00127E0004000A6O000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O0004000A3O00122O000300073O00045D3O00B4000100045D3O007C00010026C80001003E2O01000700045D3O003E2O01001252000200014O00B3000300033O00269A000200E00001000100045D3O00E00001002E19004200DC0001004300045D3O00DC0001001252000300013O0026C8000300022O01000100045D3O00022O010012630004000A4O00C6000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O00040004000500062O000400F10001000100045D3O00F10001001252000400014O00F20004000B3O0012F90004000A6O000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O000500013O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500062O00042O002O01000100045D4O002O01001252000400014O00F20004000C3O001252000300073O0026C8000300282O01000700045D3O00282O01001252000400013O0026C8000400092O01000700045D3O00092O01001252000300153O00045D3O00282O010026C8000400052O01000100045D3O00052O010012630005000A4O00DA000600013O00122O0007004C3O00122O0008004D6O0006000800024O0005000500064O000600013O00122O0007004E3O00122O0008004F6O0006000800024O0005000500064O0005000D3O00122O0005000A6O000600013O00122O000700503O00122O000800516O0006000800024O0005000500064O000600013O00122O000700523O00122O000800536O0006000800024O00050005000600062O000500252O01000100045D3O00252O01001252000500014O00F20005000E3O001252000400073O00045D3O00052O010026C8000300E10001001500045D3O00E100010012630004000A4O00C6000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O000500013O00122O000600563O00122O000700576O0005000700024O00040004000500062O000400382O01000100045D3O00382O01001252000400014O00F20004000F3O001252000100153O00045D3O003E2O0100045D3O00E1000100045D3O003E2O0100045D3O00DC000100269A000100422O01005800045D3O00422O01002E19005900932O01005A00045D3O00932O01001252000200013O000E55000700612O01000200045D3O00612O010012630003000A4O00C6000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000400013O00122O0005005D3O00122O0006005E6O0004000600024O00030003000400062O000300532O01000100045D3O00532O01001252000300014O00F2000300103O00127E0003000A6O000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300044O000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O000300113O00122O000200153O0026C8000200742O01001500045D3O00742O010012630003000A4O00C6000400013O00122O000500633O00122O000600646O0004000600024O0003000300044O000400013O00122O000500653O00122O000600666O0004000600024O00030003000400062O000300712O01000100045D3O00712O01001252000300014O00F2000300123O001252000100673O00045D3O00932O01000E55000100432O01000200045D3O00432O010012630003000A4O00DA000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000300133O00122O0003000A6O000400013O00122O0005006C3O00122O0006006D6O0004000600024O0003000300044O000400013O00122O0005006E3O00122O0006006F6O0004000600024O00030003000400062O000300902O01000100045D3O00902O01001252000300014O00F2000300143O001252000200073O00045D3O00432O010026C8000100E32O01000100045D3O00E32O01001252000200013O0026C8000200B12O01000100045D3O00B12O010012630003000A4O0058000400013O00122O000500703O00122O000600716O0004000600024O0003000300044O000400013O00122O000500723O00122O000600736O0004000600024O0003000300044O000300153O00122O0003000A6O000400013O00122O000500743O00122O000600756O0004000600024O0003000300044O000400013O00122O000500763O00122O000600776O0004000600024O0003000300044O000300163O00122O000200073O0026C8000200C12O01001500045D3O00C12O010012630003000A4O0006000400013O00122O000500783O00122O000600796O0004000600024O0003000300044O000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000300173O00122O000100073O00044O00E32O010026C8000200962O01000700045D3O00962O010012630003000A4O00C6000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000400013O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400062O000300D12O01000100045D3O00D12O01001252000300014O00F2000300183O0012F90003000A6O000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000400013O00122O000500823O00122O000600836O0004000600024O00030003000400062O000300E02O01000100045D3O00E02O01001252000300014O00F2000300193O001252000200153O00045D3O00962O010026C8000100470201008400045D3O00470201001252000200013O00269A000200EA2O01000100045D3O00EA2O01002E1A008600090201008500045D3O000902010012630003000A4O00C6000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000400013O00122O000500893O00122O0006008A6O0004000600024O00030003000400062O000300F82O01000100045D3O00F82O01001252000300014O00F20003001A3O0012F90003000A6O000400013O00122O0005008B3O00122O0006008C6O0004000600024O0003000300044O000400013O00122O0005008D3O00122O0006008E6O0004000600024O00030003000400062O000300070201000100045D3O00070201001252000300014O00F20003001B3O001252000200073O00269A0002000D0201001500045D3O000D0201002E1A0090001E0201008F00045D3O001E02010012630003000A4O00C6000400013O00122O000500913O00122O000600926O0004000600024O0003000300044O000400013O00122O000500933O00122O000600946O0004000600024O00030003000400062O0003001B0201000100045D3O001B0201001252000300014O00F20003001C3O001252000100273O00045D3O00470201000E02000700220201000200045D3O00220201002E19009500E62O01009600045D3O00E62O01001252000300013O0026C8000300270201000700045D3O00270201001252000200153O00045D3O00E62O010026C8000300230201000100045D3O002302010012630004000A4O00DA000500013O00122O000600973O00122O000700986O0005000700024O0004000400054O000500013O00122O000600993O00122O0007009A6O0005000700024O0004000400054O0004001D3O00122O0004000A6O000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O000500013O00122O0006009D3O00122O0007009E6O0005000700024O00040004000500062O000400430201000100045D3O00430201001252000400014O00F20004001E3O001252000300073O00045D3O0023020100045D3O00E62O0100269A0001004B0201006700045D3O004B0201002E19009F008E020100A000045D3O008E02010012630002000A4O00E8000300013O00122O000400A13O00122O000500A26O0003000500024O0002000200034O000300013O00122O000400A33O00122O000500A46O0003000500024O0002000200034O0002001F3O00122O0002000A6O000300013O00122O000400A53O00122O000500A66O0003000500024O0002000200034O000300013O00122O000400A73O00122O000500A86O0003000500024O0002000200034O000200203O00122O0002000A6O000300013O00122O000400A93O00122O000500AA6O0003000500024O0002000200034O000300013O00122O000400AB3O00122O000500AC6O0003000500024O00020002000300062O000200710201000100045D3O00710201001252000200014O00F2000200213O0012FD0002000A6O000300013O00122O000400AD3O00122O000500AE6O0003000500024O0002000200034O000300013O00122O000400AF3O00122O000500B06O0003000500024O0002000200034O000200223O00122O0002000A6O000300013O00122O000400B13O00122O000500B26O0003000500024O0002000200034O000300013O00122O000400B33O00122O000500B46O0003000500024O00020002000300062O0002008C0201000100045D3O008C0201001252000200014O00F2000200233O00045D3O00B2030100269A000100920201001A00045D3O00920201002E1A00B600E7020100B500045D3O00E70201001252000200013O002E1900B800B3020100B700045D3O00B30201000E55000700B30201000200045D3O00B302010012630003000A4O00DA000400013O00122O000500B93O00122O000600BA6O0004000600024O0003000300044O000400013O00122O000500BB3O00122O000600BC6O0004000600024O0003000300044O000300243O00122O0003000A6O000400013O00122O000500BD3O00122O000600BE6O0004000600024O0003000300044O000400013O00122O000500BF3O00122O000600C06O0004000600024O00030003000400062O000300B10201000100045D3O00B10201001252000300014O00F2000300253O001252000200153O002E3900C10020000100C100045D3O00D302010026C8000200D30201000100045D3O00D302010012630003000A4O00DA000400013O00122O000500C23O00122O000600C36O0004000600024O0003000300044O000400013O00122O000500C43O00122O000600C56O0004000600024O0003000300044O000300263O00122O0003000A6O000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000400013O00122O000500C83O00122O000600C96O0004000600024O00030003000400062O000300D10201000100045D3O00D10201001252000300014O00F2000300273O001252000200073O0026C8000200930201001500045D3O009302010012630003000A4O00C6000400013O00122O000500CA3O00122O000600CB6O0004000600024O0003000300044O000400013O00122O000500CC3O00122O000600CD6O0004000600024O00030003000400062O000300E30201000100045D3O00E30201001252000300014O00F2000300283O001252000100583O00045D3O00E7020100045D3O00930201002E1900CE0047030100CF00045D3O00470301000E55001500470301000100045D3O00470301001252000200014O00B3000300033O00269A000200F10201000100045D3O00F10201002E1900D100ED020100D000045D3O00ED0201001252000300013O0026C8000300020301001500045D3O000203010012630004000A4O0006000500013O00122O000600D23O00122O000700D36O0005000700024O0004000400054O000500013O00122O000600D43O00122O000700D56O0005000700024O0004000400054O000400293O00122O000100D63O00044O004703010026C8000300230301000700045D3O002303010012630004000A4O00C6000500013O00122O000600D73O00122O000700D86O0005000700024O0004000400054O000500013O00122O000600D93O00122O000700DA6O0005000700024O00040004000500062O000400120301000100045D3O00120301001252000400014O00F20004002A3O0012F90004000A6O000500013O00122O000600DB3O00122O000700DC6O0005000700024O0004000400054O000500013O00122O000600DD3O00122O000700DE6O0005000700024O00040004000500062O000400210301000100045D3O00210301001252000400014O00F20004002B3O001252000300153O0026C8000300F20201000100045D3O00F202010012630004000A4O00C6000500013O00122O000600DF3O00122O000700E06O0005000700024O0004000400054O000500013O00122O000600E13O00122O000700E26O0005000700024O00040004000500062O000400330301000100045D3O00330301001252000400014O00F20004002C3O0012F90004000A6O000500013O00122O000600E33O00122O000700E46O0005000700024O0004000400054O000500013O00122O000600E53O00122O000700E66O0005000700024O00040004000500062O000400420301000100045D3O00420301001252000400014O00F20004002D3O001252000300073O00045D3O00F2020100045D3O0047030100045D3O00ED0201002E1A00E70007000100E800045D3O000700010026C800010007000100D600045D3O00070001001252000200013O0026C80002005C0301001500045D3O005C03010012630003000A4O0006000400013O00122O000500E93O00122O000600EA6O0004000600024O0003000300044O000400013O00122O000500EB3O00122O000600EC6O0004000600024O0003000300044O0003002E3O00122O000100843O00044O0007000100269A000200600301000700045D3O00600301002E1900EE007F030100ED00045D3O007F03010012630003000A4O00C6000400013O00122O000500EF3O00122O000600F06O0004000600024O0003000300044O000400013O00122O000500F13O00122O000600F26O0004000600024O00030003000400062O0003006E0301000100045D3O006E0301001252000300014O00F20003002F3O0012F90003000A6O000400013O00122O000500F33O00122O000600F46O0004000600024O0003000300044O000400013O00122O000500F53O00122O000600F66O0004000600024O00030003000400062O0003007D0301000100045D3O007D0301001252000300014O00F2000300303O001252000200153O002E1900F8004C030100F700045D3O004C03010026C80002004C0301000100045D3O004C0301001252000300013O00269A000300880301000100045D3O00880301002E1900F900A4030100FA00045D3O00A403010012630004000A4O00C6000500013O00122O000600FB3O00122O000700FC6O0005000700024O0004000400054O000500013O00122O000600FD3O00122O000700FE6O0005000700024O00040004000500062O000400960301000100045D3O00960301001252000400014O00F2000400313O00127E0004000A6O000500013O00122O000600FF3O00122O00072O00015O0005000700024O0004000400054O000500013O00122O0006002O012O00122O00070002015O0005000700024O0004000400054O000400323O00122O000300073O00125200040003012O00125200050003012O0006E7000400840301000500045D3O00840301001252000400073O0006E7000300840301000400045D3O00840301001252000200073O00045D3O004C030100045D3O0084030100045D3O004C030100045D3O0007000100045D3O00B2030100045D3O000200012O00733O00017O00123O00028O00025O0046AB40025O0082AA40026O00F03F030C3O004570696353652O74696E677303083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803103O00081BE30D212FEA052B01F22B3E06F31C03043O006C4C698603083O006EB0B69354BBA59403043O00E73DD5C203103O002DBF3872048B317A0EA529461AAC3A7603043O001369CD5D034O0003083O009A0DCA9536A70FCD03053O005FC968BEE1030D3O008BD9C4CFA2EDCDC7A8C3D5E69F03043O00AECFABA1003E3O0012523O00014O00B3000100013O0026C83O00020001000100045D3O00020001001252000100013O002E1A000300190001000200045D3O001900010026C8000100190001000400045D3O00190001001263000200054O00C6000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O00020002000300062O000200170001000100045D3O00170001001252000200014O00F200025O00045D3O003D00010026C8000100050001000100045D3O00050001001263000200054O00C6000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D6O0003000500024O00020002000300062O000200290001000100045D3O002900010012520002000E4O00F2000200023O0012F9000200056O000300013O00122O0004000F3O00122O000500106O0003000500024O0002000200034O000300013O00122O000400113O00122O000500126O0003000500024O00020002000300062O000200380001000100045D3O00380001001252000200014O00F2000200033O001252000100043O00045D3O0005000100045D3O003D000100045D3O000200012O00733O00017O00BE3O00028O00026O00F03F025O005AAE40025O00D8B040027O0040025O002OA040025O00689B40025O00E8B140025O0090A94003083O0049734D6F76696E6703073O0047657454696D65026O000840025O004C9040025O00CCAB40030C3O004570696353652O74696E677303073O008E897EF453CB3703073O0044DAE619933FAE03063O00A923405CB3A103053O00D6CD4A332C03093O0049734D6F756E746564025O00C05140025O00D2A540025O00888140025O00788C40030C3O0053686F756C6452657475726E03113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572026O003E40025O00288540025O002FB040026O001040025O0046B140025O00E8A140030F3O00412O66656374696E67436F6D626174025O0074AA40025O00F8A340025O0044B340025O00308C4003073O00DF54F2E979FD4903053O00179A2C829C03073O004973526561647903093O00466F637573556E6974026O003440025O00707F40025O00449640030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O0007B340025O00A6A340025O00D0A14003073O0074A7A0E41C45BB03053O007020C8C7832O033O002F544F03073O00424C303CD8A3CB03073O00DFCAB6E6C2EED603053O00AE8BA5D1812O033O00ACBCE103083O0018C3D382A1A6631003073O00720CEE2B5F135503063O00762663894C332O033O00FC290003063O00409D46657269025O0080A740026O001440025O00707240025O00388840026O001840025O00DCB240025O0096A74003113O00476574456E656D696573496E52616E6765026O00394003173O00476574456E656D696573496E53706C61736852616E6765026O002040025O001AA240025O00CCA040025O0098A840025O00188740025O00E0B140025O003AB240030C3O0049734368612O6E656C696E67030B3O00447265616D427265617468025O0006AE40025O00ACA74003093O00436173745374617274025O00B4A340025O00C09840030F3O00456D706F7765724361737454696D65025O005AA940030D3O000969ED5B1F7CF04C2577E34B1F03043O00384C1984030B3O007AD3AE27C27CD3AE27DB5603053O00AF3EA1CB4603083O000ED8D7062732F4E703053O00555CBDA37303143O001AB83F2839A53E3F6988223D28A1122A2CAD243003043O005849CC50026O001C40030D3O00546172676574497356616C6964025O006AB140025O0014A74003103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E73025O0040A040025O00307D40030A3O0046697265427265617468026O004D40025O00508340025O00D88B40025O008EAC40025O00BFB040025O004CAC40026O004140025O0012A440025O0078A640025O00AC9440030D3O009199D92D0FA821A080DE292F9E03073O0055D4E9B04E5CCD030A3O006C519AE7684A8DE35E5003043O00822A38E803083O00D8B030F65231C39103063O005F8AD544832003143O00193CAE53662326A60350233AA40354382DA0577E03053O00164A48C123025O00B89F40030D3O004973446561644F7247686F7374025O00E09F40025O0050854003273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E74025O00405540025O00D07040025O009CA240025O00208A40025O0024B04003053O0039A9BBAB2403063O007371C6CDCE5603083O0042752O66446F776E03053O00486F766572025O005AA740025O009C9040030C3O008C58E85F9617F35B8D59BE0803043O003AE4379E030B3O0042752O6652656D61696E7303093O00486F76657242752O66025O00CCA240025O002AA940025O00DEAB40025O006BB140030B3O00537069726974626C2O6F6D025O00109D40025O0022A040030D3O000B9319451ADF3A9719482EC91D03063O00BA4EE3702649030B3O00CF47F4475A6EFE5BF25A5E03063O001A9C379D353303083O00BEDD02CCAA5EA5FC03063O0030ECB876B9D803143O00D6A95820DF3DEBBA1703DF3DF7B44332C33BEAB003063O005485DD3750AF03063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O0096A040025O001EB340025O0046AC4003163O0044656164467269656E646C79556E697473436F756E74025O00A8A040025O000EAA40030A3O004D612O7352657475726E030B3O00B0E637B5F84EB8F331B4C903063O003CDD8744C6A703063O0052657475726E03093O004973496E52616E676503063O00FCB8EC9650D703063O00B98EDD98E322025O007DB140025O0022AC40025O002CAB40025O00688240025O00109B40025O00406040025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA400069032O0012523O00014O00B3000100023O00269A3O00060001000200045D3O00060001002E1A000400620301000300045D3O006203010026C8000100060001000100045D3O00060001001252000200013O00269A0002000D0001000500045D3O000D0001002E1A000600420001000700045D3O00420001001252000300014O00B3000400043O0026C80003000F0001000100045D3O000F0001001252000400013O00269A000400160001000200045D3O00160001002E19000800200001000900045D3O002000012O002400055O00201700050005000A2O003E0005000200020006E50005001E0001000100045D3O001E00010012630005000B4O00A80005000100022O00F2000500013O0012520002000C3O00045D3O00420001002E19000D00120001000E00045D3O001200010026C8000400120001000100045D3O00120001001252000500013O0026C80005003A0001000100045D3O003A00010012630006000F4O00A7000700033O00122O000800103O00122O000900116O0007000900024O0006000600074O000700033O00122O000800123O00122O000900136O0007000900024O0006000600074O000600026O00065O00202O0006000600144O00060002000200062O0006003900013O00045D3O003900012O00733O00013O001252000500023O0026C8000500250001000200045D3O00250001001252000400023O00045D3O0012000100045D3O0025000100045D3O0012000100045D3O0042000100045D3O000F0001002E39001500780001001500045D3O00BA00010026C8000200BA0001000C00045D3O00BA0001001252000300014O00B3000400043O002E3900163O0001001600045D3O004800010026C8000300480001000100045D3O00480001001252000400013O0026C80004006C0001000200045D3O006C00012O0024000500043O0006E5000500540001000100045D3O00540001002E1A0018006A0001001700045D3O006A0001001252000500013O0026C8000500550001000100045D3O005500012O0024000600053O0020D500060006001A4O000700063O00202O00070007001B4O000800073O00202O00080008001C00122O0009001D6O000A00016O0006000A000200122O000600193O00122O000600193O00062O000600660001000100045D3O00660001002E19001F006A0001001E00045D3O006A0001001263000600194O0087000600023O00045D3O006A000100045D3O00550001001252000200203O00045D3O00BA0001002E1A0022004D0001002100045D3O004D00010026C80004004D0001000100045D3O004D00012O002400055O0020170005000500232O003E0005000200020006E5000500780001000100045D3O007800012O0024000500083O0006690005009C00013O00045D3O009C0001001252000500014O00B3000600073O00269A0005007E0001000200045D3O007E0001002E19002400840001002500045D3O008400010006E5000700820001000100045D3O00820001002E1A0026009C0001002700045D3O009C00012O0087000700023O00045D3O009C00010026C80005007A0001000100045D3O007A00012O0024000800083O0006B8000600920001000800045D3O009200012O0024000800064O0093000900033O00122O000A00283O00122O000B00296O0009000B00024O00080008000900202O00080008002A4O0008000200024O000600084O0024000800053O00205700080008002B4O000900066O000A00073O00122O000B001D3O00122O000C002C6O0008000C00024O000700083O00122O000500023O00044O007A00012O0024000500093O000669000500B600013O00045D3O00B60001001252000500013O00269A000500A40001000100045D3O00A40001002E19002E00A00001002D00045D3O00A000012O0024000600053O0020CA00060006002F4O000700063O00202O0007000700304O000800073O00202O00080008003100122O000900326O00060009000200122O000600193O002E2O003300090001003300045D3O00B60001001263000600193O000669000600B600013O00045D3O00B60001001263000600194O0087000600023O00045D3O00B6000100045D3O00A00001001252000400023O00045D3O004D000100045D3O00BA000100045D3O004800010026C8000200EB0001000200045D3O00EB0001001252000300013O002E1A003500CF0001003400045D3O00CF00010026C8000300CF0001000200045D3O00CF00010012630004000F4O0006000500033O00122O000600363O00122O000700376O0005000700024O0004000400054O000500033O00122O000600383O00122O000700396O0005000700024O0004000400054O0004000A3O00122O000200053O00044O00EB00010026C8000300BD0001000100045D3O00BD00010012630004000F4O0058000500033O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500033O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O0004000B3O00122O0004000F6O000500033O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O000500033O00122O000600403O00122O000700416O0005000700024O0004000400054O0004000C3O00122O000300023O00045D3O00BD0001002E39004200240001004200045D3O000F2O010026C80002000F2O01004300045D3O000F2O01001252000300013O002E1A004400FF0001004500045D3O00FF0001000E55000200FF0001000300045D3O00FF00012O00240004000C3O000669000400FB00013O00045D3O00FB00012O00240004000E4O0029000400044O00F20004000D3O00045D3O00FD0001001252000400024O00F20004000D3O001252000200463O00045D3O000F2O0100269A000300032O01000100045D3O00032O01002E19004700F00001004800045D3O00F000012O002400045O0020E400040004004900122O0006004A6O0004000600024O0004000F6O000400103O00202O00040004004B00122O0006004C6O0004000600024O0004000E3O00122O000300023O00044O00F00001002E19004E00060201004D00045D3O00060201000E55004600060201000200045D3O00060201001252000300014O00B3000400043O00269A000300192O01000100045D3O00192O01002E39004F00FEFF2O005000045D3O00152O01001252000400013O002E1A005100712O01005200045D3O00712O010026C8000400712O01000200045D3O00712O012O002400055O0020FC0005000500534O000700063O00202O0007000700544O00050007000200062O0005006F2O013O00045D3O006F2O01001252000500014O00B3000600073O0026C80005002C2O01000100045D3O002C2O01001252000600014O00B3000700073O001252000500023O00269A000500302O01000200045D3O00302O01002E39005500F9FF2O005600045D3O00272O010026C8000600302O01000100045D3O00302O010012630008000B4O00280008000100024O00095O00202O0009000900574O0009000200024O000700080009002E2O005900412O01005800045D3O00412O012O002400085O00201700080008005A2O0024000A00114O002E0008000A000200067F000700412O01000800045D3O00412O0100045D3O006F2O01001252000800014O00B3000900093O002E39005B3O0001005B00045D3O00432O01000E55000100432O01000800045D3O00432O01001252000900013O0026C8000900482O01000100045D3O00482O01001252000A00013O0026C8000A004B2O01000100045D3O004B2O01001252000B00013O0026C8000B004E2O01000100045D3O004E2O012O0024000C00124O0036000D00033O00122O000E005C3O00122O000F005D6O000D000F00024O000E00066O000F00033O00122O0010005E3O00122O0011005F6O000F001100024O000E000E000F4O000F00033O00122O001000603O00122O001100616O000F001100024O000E000E000F4O000C000D000E4O000C00033O00122O000D00623O00122O000E00636O000C000E6O000C5O00044O004E2O0100045D3O004B2O0100045D3O00482O0100045D3O006F2O0100045D3O00432O0100045D3O006F2O0100045D3O00302O0100045D3O006F2O0100045D3O00272O01001252000200643O00045D3O000602010026C80004001A2O01000100045D3O001A2O012O0024000500053O0020640005000500652O00A80005000100020006E50005007D2O01000100045D3O007D2O012O002400055O0020170005000500232O003E000500020002000669000500AA2O013O00045D3O00AA2O01001252000500014O00B3000600073O00269A000500832O01000200045D3O00832O01002E19006600A22O01006700045D3O00A22O010026C8000600832O01000100045D3O00832O01001252000700013O0026C8000700912O01000100045D3O00912O012O0024000800123O00201B0008000800684O000900096O000A00016O0008000A00024O000800136O000800136O000800143O00122O000700023O0026C8000700862O01000200045D3O00862O012O0024000800143O00269A000800972O01006900045D3O00972O0100045D3O00AA2O012O0024000800123O0020E900080008006A4O0009000F6O000A8O0008000A00024O000800143O00044O00AA2O0100045D3O00862O0100045D3O00AA2O0100045D3O00832O0100045D3O00AA2O0100269A000500A62O01000100045D3O00A62O01002E19006B007F2O01006C00045D3O007F2O01001252000600014O00B3000700073O001252000500023O00045D3O007F2O012O002400055O0020FC0005000500534O000700063O00202O00070007006D4O00050007000200062O0005002O02013O00045D3O002O0201001252000500014O00B3000600073O002E1A006E00C42O01006F00045D3O00C42O010026C8000500C42O01000100045D3O00C42O01001252000800013O000E02000100BC2O01000800045D3O00BC2O01002E1A007100BF2O01007000045D3O00BF2O01001252000600014O00B3000700073O001252000800023O0026C8000800B82O01000200045D3O00B82O01001252000500023O00045D3O00C42O0100045D3O00B82O010026C8000500B32O01000200045D3O00B32O01000E02000100CA2O01000600045D3O00CA2O01002E1A007200C62O01007300045D3O00C62O010012630008000B4O00470008000100024O00095O00202O0009000900574O0009000200024O000700080009002E2O0074002O0201007500045D3O002O02012O002400085O00201700080008005A2O0024000A00154O002E0008000A000200060A0008002O0201000700045D3O002O0201001252000800014O00B3000900093O0026C8000800DA2O01000100045D3O00DA2O01001252000900013O00269A000900E12O01000100045D3O00E12O01002E39007600FEFF2O007700045D3O00DD2O01001252000A00013O0026C8000A00E22O01000100045D3O00E22O012O0024000B00124O0036000C00033O00122O000D00783O00122O000E00796O000C000E00024O000D00066O000E00033O00122O000F007A3O00122O0010007B6O000E001000024O000D000D000E4O000E00033O00122O000F007C3O00122O0010007D6O000E001000024O000D000D000E4O000B000C000D4O000B00033O00122O000C007E3O00122O000D007F6O000B000D6O000B5O00044O00E22O0100045D3O00DD2O0100045D3O002O020100045D3O00DA2O0100045D3O002O020100045D3O00C62O0100045D3O002O020100045D3O00B32O01001252000400023O00045D3O001A2O0100045D3O0006020100045D3O00152O010026C80002002B0201000100045D3O002B0201001252000300014O00B3000400043O0026C80003000A0201000100045D3O000A0201001252000400013O002E390080000C0001008000045D3O001902010026C8000400190201000200045D3O001902012O002400055O0020170005000500812O003E0005000200020006690005001702013O00045D3O001702012O00733O00013O001252000200023O00045D3O002B02010026C80004000D0201000100045D3O000D0201001252000500013O000E55000100230201000500045D3O002302012O0024000600164O006B0006000100012O0024000600174O006B000600010001001252000500023O0026C80005001C0201000200045D3O001C0201001252000400023O00045D3O000D020100045D3O001C020100045D3O000D020100045D3O002B020100045D3O000A0201000E550020008C0201000200045D3O008C0201001252000300014O00B3000400043O00269A000300330201000100045D3O00330201002E39008200FEFF2O008300045D3O002F0201001252000400013O0026C80004003D0201000200045D3O003D02012O0024000500053O00205E00050005008400122O000600856O0005000200024O000500183O00122O000200433O00044O008C020100269A000400410201000100045D3O00410201002E1A008700340201008600045D3O00340201001252000500013O002E1A008800820201008900045D3O00820201000E55000100820201000500045D3O008202012O0024000600193O0006690006007702013O00045D3O007702012O00240006000B3O0006E5000600510201000100045D3O005102012O002400065O0020170006000600232O003E0006000200020006690006007702013O00045D3O007702010012630006000B4O00940006000100024O000700016O0006000600074O0007001A3O00062O000600590201000700045D3O0059020100045D3O007702012O0024000600064O0096000700033O00122O0008008A3O00122O0009008B6O0007000900024O00060006000700202O00060006002A4O00060002000200062O0006007702013O00045D3O007702012O002400065O0020FC00060006008C4O000800063O00202O00080008008D4O00060008000200062O0006007702013O00045D3O00770201002E19008F00770201008E00045D3O007702012O00240006001B4O0024000700063O00206400070007008D2O003E0006000200020006690006007702013O00045D3O007702012O0024000600033O001252000700903O001252000800914O0025000600084O003800066O002400065O0020160006000600924O000800063O00202O0008000800934O00060008000200262O0006007F0201000500045D3O007F02012O007900066O00B5000600014O00F20006001C3O001252000500023O002E19009400420201009500045D3O004202010026C8000500420201000200045D3O00420201001252000400023O00045D3O0034020100045D3O0042020100045D3O0034020100045D3O008C020100045D3O002F0201000E55006400090001000200045D3O00090001002E1A009600CE0201009700045D3O00CE02012O002400035O0020FC0003000300534O000500063O00202O0005000500984O00030005000200062O000300CE02013O00045D3O00CE0201001252000300014O00B3000400053O0026C8000300C80201000200045D3O00C802010026C80004009B0201000100045D3O009B02010012630006000B4O003D0006000100024O00075O00202O0007000700574O0007000200024O0005000600074O00065O00202O00060006005A4O0008001D6O00060008000200062O000600CE0201000500045D3O00CE0201001252000600013O00269A000600AE0201000100045D3O00AE0201002E19009A00AA0201009900045D3O00AA02012O0024000700124O0036000800033O00122O0009009B3O00122O000A009C6O0008000A00024O000900066O000A00033O00122O000B009D3O00122O000C009E6O000A000C00024O00090009000A4O000A00033O00122O000B009F3O00122O000C00A06O000A000C00024O00090009000A4O0007000800094O000700033O00122O000800A13O00122O000900A26O000700096O00075O00044O00AA020100045D3O00CE020100045D3O009B020100045D3O00CE02010026C8000300990201000100045D3O00990201001252000400014O00B3000500053O001252000300023O00045D3O009902012O0024000300103O000669000300E602013O00045D3O00E602012O0024000300103O0020170003000300A32O003E000300020002000669000300E602013O00045D3O00E602012O0024000300103O0020170003000300A42O003E000300020002000669000300E602013O00045D3O00E602012O0024000300103O0020170003000300812O003E000300020002000669000300E602013O00045D3O00E602012O002400035O0020170003000300A52O0024000500104O002E000300050002000669000300E802013O00045D3O00E80201002E1900A70027030100A600045D3O00270301001252000300014O00B3000400053O0026C80003001F0301000200045D3O001F0301002E3900A83O000100A800045D3O00EC02010026C8000400EC0201000100045D3O00EC02012O0024000600053O0020C20006000600A94O0006000100024O000500066O00065O00202O0006000600234O00060002000200062O000600270301000100045D3O00270301002E1A00AA000B030100AB00045D3O000B0301000E4B0002000B0301000500045D3O000B03012O00240006001B4O0056000700063O00202O0007000700AC4O000800086O000900016O00060009000200062O0006002703013O00045D3O002703012O0024000600033O00122F000700AD3O00122O000800AE6O000600086O00065O00044O002703012O00240006001B4O00D2000700063O00202O0007000700AF4O000800103O00202O0008000800B000122O000A001D6O0008000A00024O000800086O000900016O00060009000200062O0006002703013O00045D3O002703012O0024000600033O00122F000700B13O00122O000800B26O000600086O00065O00044O0027030100045D3O00EC020100045D3O0027030100269A000300230301000100045D3O00230301002E1900B300EA020100B400045D3O00EA0201001252000400014O00B3000500053O001252000300023O00045D3O00EA02012O002400035O0020170003000300532O003E0003000200020006690003002E03013O00045D3O002E0301002E3900B5003C000100B600045D3O00680301002E1900B8004D030100B700045D3O004D03012O002400035O0020170003000300232O003E0003000200020006690003004D03013O00045D3O004D0301001252000300014O00B3000400053O00269A0003003B0301000200045D3O003B0301002E1A00BA0046030100B900045D3O004603010026C80004003B0301000100045D3O003B03012O00240006001E4O00A80006000100022O00F6000500063O0006690005006803013O00045D3O006803012O0087000500023O00045D3O0068030100045D3O003B030100045D3O006803010026C8000300370301000100045D3O00370301001252000400014O00B3000500053O001252000300023O00045D3O0037030100045D3O00680301001252000300014O00B3000400043O002E1900BB004F030100BC00045D3O004F03010026C80003004F0301000100045D3O004F03012O00240005001F4O00A80005000100022O00F6000400053O002E1900BD0068030100BE00045D3O006803010006690004006803013O00045D3O006803012O0087000400023O00045D3O0068030100045D3O004F030100045D3O0068030100045D3O0009000100045D3O0068030100045D3O0006000100045D3O006803010026C83O00020001000100045D3O00020001001252000100014O00B3000200023O0012523O00023O00045D3O000200012O00733O00017O00233O00028O00025O0084AB40025O00C4A040027O004003123O0087AFDCDA382B81AAA1AACAEE382598ADA5B503083O00CBC3C6AFAA5D47ED030A3O004D657267655461626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O6673026O00F03F025O0046AB40025O0074A940025O0061B140025O0078AC40025O00206340025O007C9D4003053O005072696E7403213O0068D752E94621E159D15EF54D73D24ECA5CFF5173F5418572EA4A30B77ACA58F76803073O009738A5379A2353030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03263O00905100FDA55113EFB44A0A2OE06613E1AB4617AEB60354BEEE114BBEF00327F7E0610AE1AD6803043O008EC02365025O00949B40026O008440026O006940025O00B6AF4003123O00F27C3AB3E280A017D4792C87E28EB910D06603083O0076B61549C387ECCC03173O0044697370652O6C61626C654D61676963446562752O667303123O002C3509502O01F1093E16452008FF1D3A1C5303073O009D685C7A20646D03193O0044697370652O6C61626C6544697365617365446562752O6673025O0014A940025O00E09540007B3O0012523O00014O00B3000100013O00269A3O00060001000100045D3O00060001002E1A000200020001000300045D3O00020001001252000100013O0026C8000100170001000400045D3O001700012O002400026O00F4000300013O00122O000400053O00122O000500066O0003000500024O000400023O00202O0004000400074O00055O00202O0005000500084O00065O00202O0006000600094O0004000600024O00020003000400044O007A00010026C8000100440001000100045D3O00440001001252000200014O00B3000300033O0026C80002001B0001000100045D3O001B0001001252000300013O000E02000A00220001000300045D3O00220001002E19000B00240001000C00045D3O002400010012520001000A3O00045D3O0044000100269A000300280001000100045D3O00280001002E1A000D001E0001000E00045D3O001E0001001252000400013O00269A0004002D0001000100045D3O002D0001002E190010003C0001000F00045D3O003C00012O0024000500033O00208B0005000500114O000600013O00122O000700123O00122O000800136O000600086O00053O000100122O000500143O00202O0005000500154O000600013O00122O000700163O00122O000800176O000600086O00053O000100122O0004000A3O0026C8000400290001000A00045D3O002900010012520003000A3O00045D3O001E000100045D3O0029000100045D3O001E000100045D3O0044000100045D3O001B0001000E55000A00070001000100045D3O00070001001252000200013O002E1A001900700001001800045D3O007000010026C8000200700001000100045D3O00700001001252000300013O002E1A001A006B0001001B00045D3O006B00010026C80003006B0001000100045D3O006B00012O002400046O0046000500013O00122O0006001C3O00122O0007001D6O0005000700024O000600023O00202O0006000600074O00075O00202O0007000700084O00085O00202O00080008001E4O0006000800024O0004000500064O00048O000500013O00122O0006001F3O00122O000700206O0005000700024O000600023O00202O0006000600074O00075O00202O0007000700084O00085O00202O0008000800214O0006000800024O00040005000600122O0003000A3O0026C80003004C0001000A00045D3O004C00010012520002000A3O00045D3O0070000100045D3O004C000100269A000200740001000A00045D3O00740001002E19002200470001002300045D3O00470001001252000100043O00045D3O0007000100045D3O0047000100045D3O0007000100045D3O007A000100045D3O000200012O00733O00017O00", GetFEnv(), ...);

