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
				if (Enum <= 160) then
					if (Enum <= 79) then
						if (Enum <= 39) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
												Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
											else
												local A;
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
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
											end
										elseif (Enum <= 2) then
											local B;
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
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 3) then
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
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
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
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									elseif (Enum <= 6) then
										if (Enum > 5) then
											local Edx;
											local Results;
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
											Stk[Inst[2]] = Stk[Inst[3]];
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
										else
											local A;
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
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum <= 7) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									elseif (Enum == 8) then
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									else
										local Step;
										local Index;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
											local Step;
											local Index;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 12) then
										local A;
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
										Stk[Inst[2]] = Inst[3];
									elseif (Enum > 13) then
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
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
									if (Enum > 15) then
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
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									else
										local K;
										local Edx;
										local Results, Limit;
										local B;
										local A;
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
										A = Inst[2];
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
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
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
								elseif (Enum <= 17) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 18) then
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
								else
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum == 20) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										else
											local Edx;
											local Results, Limit;
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
									elseif (Enum <= 22) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Enum > 23) then
										local B;
										local T;
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
								elseif (Enum <= 26) then
									if (Enum == 25) then
										local Edx;
										local Results;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
										Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
										Edx = 0;
										for Idx = A, Inst[4] do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
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
										local A = Inst[2];
										Stk[A] = Stk[A]();
									end
								elseif (Enum <= 27) then
									local Edx;
									local Results, Limit;
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
								elseif (Enum > 28) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
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
									else
										do
											return;
										end
									end
								elseif (Enum <= 32) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Enum > 33) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 36) then
								if (Enum > 35) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 37) then
								local Edx;
								local Results, Limit;
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
							elseif (Enum == 38) then
								local Edx;
								local Results, Limit;
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
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
										if (Enum == 40) then
											if (Inst[2] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
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
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 42) then
										local B;
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
										Stk[Inst[2]] = not Stk[Inst[3]];
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
									elseif (Enum == 43) then
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
										B = Stk[Inst[4]];
										if not B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									else
										local A;
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 46) then
									if (Enum > 45) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 47) then
									local K;
									local Edx;
									local Results, Limit;
									local B;
									local A;
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
									A = Inst[2];
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
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
								elseif (Enum == 48) then
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum > 50) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 52) then
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum == 53) then
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
								end
							elseif (Enum <= 56) then
								if (Enum > 55) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
								end
							elseif (Enum <= 57) then
								local B;
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 58) then
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
							end
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum > 60) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
									else
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 62) then
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
								elseif (Enum == 63) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									if (Stk[Inst[2]] ~= Inst[4]) then
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
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 66) then
								if (Enum == 65) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								else
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
								end
							elseif (Enum <= 67) then
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
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 68) then
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
								A = Inst[2];
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
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum == 70) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 72) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 73) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 76) then
							if (Enum > 75) then
								if (Stk[Inst[2]] == Inst[4]) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 77) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 78) then
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
						end
					elseif (Enum <= 119) then
						if (Enum <= 99) then
							if (Enum <= 89) then
								if (Enum <= 84) then
									if (Enum <= 81) then
										if (Enum > 80) then
											Stk[Inst[2]] = Inst[3] ~= 0;
										elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 82) then
										local B;
										local T;
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
									elseif (Enum == 83) then
										local A;
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 86) then
									if (Enum > 85) then
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
										B = Stk[Inst[4]];
										if not B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									else
										local B;
										local T;
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
								elseif (Enum <= 87) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum == 88) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 94) then
								if (Enum <= 91) then
									if (Enum > 90) then
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
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 92) then
									local A = Inst[2];
									local Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum == 93) then
									local B;
									local T;
									local A;
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
								else
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum <= 96) then
								if (Enum > 95) then
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local K;
									local Edx;
									local Results, Limit;
									local B;
									local A;
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
									A = Inst[2];
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
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
							elseif (Enum <= 97) then
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
							elseif (Enum == 98) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 109) then
							if (Enum <= 104) then
								if (Enum <= 101) then
									if (Enum > 100) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum <= 102) then
									local B;
									local T;
									local A;
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
								elseif (Enum == 103) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Top do
										Insert(T, Stk[Idx]);
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 106) then
								if (Enum == 105) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 107) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum == 108) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									if (Mvm[1] == 94) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 114) then
							if (Enum <= 111) then
								if (Enum == 110) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 112) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 113) then
								do
									return Stk[Inst[2]];
								end
							else
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 116) then
							if (Enum == 115) then
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local Edx;
								local Results;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
								Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
							end
						elseif (Enum <= 117) then
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
							A = Inst[2];
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
						elseif (Enum == 118) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 139) then
						if (Enum <= 129) then
							if (Enum <= 124) then
								if (Enum <= 121) then
									if (Enum > 120) then
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
										VIP = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum <= 122) then
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
								elseif (Enum == 123) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
								else
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 126) then
								if (Enum == 125) then
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 127) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							elseif (Enum == 128) then
								local B;
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								local K;
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
								A = Inst[2];
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 134) then
							if (Enum <= 131) then
								if (Enum == 130) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local K;
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
									A = Inst[2];
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 132) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 133) then
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 136) then
							if (Enum == 135) then
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 137) then
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
						elseif (Enum > 138) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						else
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 149) then
						if (Enum <= 144) then
							if (Enum <= 141) then
								if (Enum == 140) then
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 142) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 143) then
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 146) then
							if (Enum > 145) then
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
								Stk[Inst[2]] = Inst[3];
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
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 147) then
							local B;
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
							Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum > 148) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						else
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 154) then
						if (Enum <= 151) then
							if (Enum > 150) then
								local Edx;
								local Results, Limit;
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
								local T;
								local Edx;
								local Results, Limit;
								local A;
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
						elseif (Enum <= 152) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 153) then
							local A;
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local T;
							local Edx;
							local Results, Limit;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
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
							T = Stk[A];
							for Idx = A + 1, Top do
								Insert(T, Stk[Idx]);
							end
						end
					elseif (Enum <= 157) then
						if (Enum <= 155) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum > 156) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 158) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					elseif (Enum == 159) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					else
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					end
				elseif (Enum <= 241) then
					if (Enum <= 200) then
						if (Enum <= 180) then
							if (Enum <= 170) then
								if (Enum <= 165) then
									if (Enum <= 162) then
										if (Enum > 161) then
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
									elseif (Enum <= 163) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 164) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
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
								elseif (Enum <= 167) then
									if (Enum == 166) then
										local T;
										local Edx;
										local Results, Limit;
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
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
										T = Stk[A];
										for Idx = A + 1, Top do
											Insert(T, Stk[Idx]);
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum <= 168) then
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								elseif (Enum == 169) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]];
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
								end
							elseif (Enum <= 175) then
								if (Enum <= 172) then
									if (Enum == 171) then
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
										A = Inst[2];
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
										local T;
										local A;
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
								elseif (Enum <= 173) then
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
								elseif (Enum == 174) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 177) then
								if (Enum == 176) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 178) then
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum > 179) then
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
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 190) then
							if (Enum <= 185) then
								if (Enum <= 182) then
									if (Enum > 181) then
										local A;
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
										Stk[Inst[2]] = Inst[3];
									elseif (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 183) then
									local Edx;
									local Results, Limit;
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
								elseif (Enum == 184) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 187) then
								if (Enum == 186) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 188) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 189) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local A;
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 195) then
							if (Enum <= 192) then
								if (Enum > 191) then
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									A = Inst[2];
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
								end
							elseif (Enum <= 193) then
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum > 194) then
								local A;
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 197) then
							if (Enum == 196) then
								local B;
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								local T;
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
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							end
						elseif (Enum <= 198) then
							local A;
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
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 199) then
							local Edx;
							local Results, Limit;
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 220) then
						if (Enum <= 210) then
							if (Enum <= 205) then
								if (Enum <= 202) then
									if (Enum > 201) then
										local A;
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									else
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
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
									end
								elseif (Enum <= 203) then
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
								elseif (Enum > 204) then
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
									A = Inst[2];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 207) then
								if (Enum == 206) then
									local Edx;
									local Results, Limit;
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 208) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 209) then
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
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
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum == 211) then
									local K;
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
									B = Inst[3];
									K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 213) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum > 214) then
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 217) then
							if (Enum > 216) then
								local Edx;
								local Results, Limit;
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
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 218) then
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
						elseif (Enum == 219) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 230) then
						if (Enum <= 225) then
							if (Enum <= 222) then
								if (Enum == 221) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
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
								elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum <= 223) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							elseif (Enum > 224) then
								local Step;
								local Index;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 227) then
							if (Enum > 226) then
								local K;
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
								A = Inst[2];
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 228) then
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
							B = Stk[Inst[4]];
							if not B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						elseif (Enum > 229) then
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
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						if (Enum <= 232) then
							if (Enum > 231) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local Step;
								local Index;
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
						elseif (Enum <= 233) then
							local T;
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						elseif (Enum > 234) then
							local A;
							Stk[Inst[2]][Inst[3]] = Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							do
								return Unpack(Stk, A, Top);
							end
						end
					elseif (Enum <= 238) then
						if (Enum <= 236) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						elseif (Enum == 237) then
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
							end
						else
							local B = Inst[3];
							local K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
						end
					elseif (Enum <= 239) then
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					elseif (Enum == 240) then
						local K;
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
						B = Inst[3];
						K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						Stk[Inst[2]] = Stk[Inst[3]];
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
					end
				elseif (Enum <= 281) then
					if (Enum <= 261) then
						if (Enum <= 251) then
							if (Enum <= 246) then
								if (Enum <= 243) then
									if (Enum == 242) then
										Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
									elseif (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 244) then
									Stk[Inst[2]] = {};
								elseif (Enum > 245) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
								else
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
								if (Enum == 247) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 249) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							elseif (Enum == 250) then
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
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 256) then
							if (Enum <= 253) then
								if (Enum == 252) then
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
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local Step;
									local Index;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 254) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 255) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum <= 258) then
							if (Enum == 257) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
							end
						elseif (Enum <= 259) then
							local B;
							local T;
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
						elseif (Enum > 260) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
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
					elseif (Enum <= 271) then
						if (Enum <= 266) then
							if (Enum <= 263) then
								if (Enum == 262) then
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								else
									local K;
									local B;
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									B = Inst[3];
									K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 264) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 265) then
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
							else
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum <= 268) then
							if (Enum > 267) then
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 269) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 270) then
							local A = Inst[2];
							local Cls = {};
							for Idx = 1, #Lupvals do
								local List = Lupvals[Idx];
								for Idz = 0, #List do
									local Upv = List[Idz];
									local NStk = Upv[1];
									local DIP = Upv[2];
									if ((NStk == Stk) and (DIP >= A)) then
										Cls[DIP] = NStk[DIP];
										Upv[1] = Cls;
									end
								end
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 276) then
						if (Enum <= 273) then
							if (Enum > 272) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
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
							end
						elseif (Enum <= 274) then
							local K;
							local Edx;
							local Results, Limit;
							local B;
							local A;
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
							A = Inst[2];
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
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							A = Inst[2];
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
						elseif (Enum == 275) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
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
					elseif (Enum <= 278) then
						if (Enum > 277) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 279) then
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
					elseif (Enum > 280) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
					else
						local A;
						Stk[Inst[2]][Inst[3]] = Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 301) then
					if (Enum <= 291) then
						if (Enum <= 286) then
							if (Enum <= 283) then
								if (Enum == 282) then
									local B;
									local T;
									local A;
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 284) then
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum > 285) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							else
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
								Stk[Inst[2]] = #Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 288) then
							if (Enum == 287) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							else
								Stk[Inst[2]][Inst[3]] = Inst[4];
							end
						elseif (Enum <= 289) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
						elseif (Enum == 290) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local Step;
							local Index;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
					elseif (Enum <= 296) then
						if (Enum <= 293) then
							if (Enum == 292) then
								local B = Stk[Inst[4]];
								if not B then
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
						elseif (Enum <= 294) then
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
							VIP = Inst[3];
						elseif (Enum == 295) then
							local K;
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
							A = Inst[2];
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
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							do
								return Stk[A](Unpack(Stk, A + 1, Top));
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
					elseif (Enum <= 298) then
						if (Enum == 297) then
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
						else
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 299) then
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
					elseif (Enum == 300) then
						local Edx;
						local Results, Limit;
						local A;
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
						A = Inst[2];
						Results, Limit = _R(Stk[A](Stk[A + 1]));
						Top = (Limit + A) - 1;
						Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					else
						Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
					end
				elseif (Enum <= 311) then
					if (Enum <= 306) then
						if (Enum <= 303) then
							if (Enum == 302) then
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								local A;
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 304) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
						elseif (Enum > 305) then
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
					elseif (Enum <= 308) then
						if (Enum == 307) then
							local A;
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
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 309) then
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
						Stk[Inst[2]] = Inst[3];
					elseif (Enum == 310) then
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
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 316) then
					if (Enum <= 313) then
						if (Enum > 312) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						else
							local A;
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						end
					elseif (Enum <= 314) then
						Stk[Inst[2]] = Inst[3];
					elseif (Enum > 315) then
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
						Stk[Inst[2]] = not Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
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
					end
				elseif (Enum <= 319) then
					if (Enum <= 317) then
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
					elseif (Enum > 318) then
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
				elseif (Enum <= 320) then
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
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 321) then
					local A;
					Stk[Inst[2]] = Stk[Inst[3]];
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
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
				else
					local A;
					Stk[Inst[2]] = {};
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
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
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!55012O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634C696203093O0045706963436163686503053O005574696C7303043O00556E697403063O00506C6179657203053O00466F63757303063O0054617267657403093O004D6F7573654F76657203043O00426F2O7303093O004E616D65706C61746503053O00506172747903043O005261696403053O005370652O6C03043O004974656D03053O00706169727303063O00666F726D617403073O00436F2O6D6F6E7303083O0045766572796F6E6503123O0043752O72656E74456E636F756E7465724944028O002O033O006E756D03043O00622O6F6C030D3O00546172676574497356616C696403113O0054617267657449734D6F7573656F766572030E3O004865616C61626C654E706349447303183O00546172676574497356616C69644865616C61626C654E706303103O00556E697449734379636C6556616C6964030A3O0043616E446F54556E6974030E3O004973497454696D65546F52616D70030F3O0047657443617374696E67456E656D7903163O00456E656D69657357697468446562752O66436F756E7403163O00476574556E697473546172676574467269656E646C79024O0080F8084103113O0048616E646C65496E636F72706F7265616C024O0028FF0841030F3O0048616E646C65412O666C6963746564024O0008F50841030D3O0048616E646C654368726F6D696503103O0048616E646C65546F705472696E6B6574030F3O0048616E646C65445053506F74696F6E030E3O00506F74696F6E53656C656374656403133O0048616E646C65426F2O746F6D5472696E6B6574027O004003113O00496E74652O72757074576974685374756E03173O00496E74652O72757074576974685374756E437572736F7203153O00496E74652O7275707457686974656C697374494473024O0030381841024O00A0B41741024O00FCBB1741024O00B4081741024O0080351841024O000CAC1741024O0028900941024O0060630941024O0028690941024O00183E0841024O0078490841024O00484C0A41024O0070610841024O00F0420841024O0064C41641024O000CF41741024O0078841741024O0090A70241024O0040230341024O00F84D1841024O0070210341024O00A0BD0241025O00491841024O0004491841024O004C291841024O00A42C1841024O0068491841024O00B0A71741024O00C8EC1641024O00C8971741024O00400A1741024O00B0D21641024O00B4751741024O00A08F1741024O004CA51741024O0058A81741024O00A07C1741024O004CCA1641024O0054FE1641025O00790741024O00042E1041024O000C2E1041024O008C031141024O00C4061141024O00E83D1041024O00DC9C1041024O00D0351941024O0064331041024O003C341041024O0078D80F41024O00A86B0F41024O00302D1141024O00C0770F41024O002OA00F41024O00E0AB0841024O00D8AA0841024O0088A10741024O00E08B1641024O00548B1641024O000C8C1641024O002C901641024O007C921641024O00DC8B1641024O00700A1741024O00306E1641024O003C6E1641024O002C561741024O009CBF1641024O0040DC1641024O0014801741024O0028581741024O00F0141741024O008C221841024O00FCB71641024O00E8BC1641024O0084721741024O00A06A1741024O00F4391841024O00D8131941024O00A086F540024O00A087F540024O00306EF540024O00106DF540024O00B013F540024O0074D41641024O0010D41641024O000CD91641024O008CDC1641024O00B8261841024O00C8DE1641024O00ACDE1641024O0030801741024O00A0081741024O0010081741024O00E8081741024O00ACF51641024O0068251941024O0068601941024O002C5B1941024O00345B1941025O00681941024O00946C1841024O00E8331941024O00247B1941024O00682B1941024O0024291941024O00CC3B194103103O005374756E57686974656C697374494473024O00A8AA0941024O0034C01641024O00FCBF1641024O00C4981641024O0078971741024O0070771741024O003C6D1741024O00E8961741024O007CA81741024O00F4511741025O00881741024O0018AD1741024O0080F90941024O0050510841024O0060FDFB40024O002C491841024O00AC491841024O0010351041024O0080321041024O0048A01041024O00E0760F41024O0058760F41024O00A8AC0741024O0030670641024O0058A80741024O0058050741024O00D06E0841024O003C8C1641024O0028901641024O00E48C1641024O00380A1741024O00F06D1641024O00846E1641024O003C801741024O00081F1741024O008CB21641024O00B0251941024O00983E1941024O00FC971941024O00BCDF1841026O00F03F03093O00496E74652O72757074030F3O00496E74652O72757074437572736F72030E3O004C6173745461726765745377617003093O00436173744379636C65030F3O005461726765744E657874456E656D79030C3O00436173745461726765744966030B3O004D69746967617465494473024O002OBC1741024O0020920741024O0020A40741024O0028491741024O00CC2B1841024O0040491841024O007014FA40024O009015FA40024O00B0CA1741024O0044041741024O00487F1741024O00B87A1741024O00D05D1741024O0028290B41024O0054351941024O00BC3C1941024O00380A1941030E3O0053686F756C644D6974696761746503173O0044697370652O6C61626C654D6167696342752O66494473024O0018F41741024O001C4D1841024O00BC921741024O00643F1041024O0094141741024O007C21194103103O00556E69744861734D6167696342752O6603183O0044697370652O6C61626C65456E7261676542752O66494473024O0068DC1741024O0088411841024O0088380741024O00C82B1841024O00E42D1041024O00843F1041024O00206E0F41024O00587B0F41024O00F8A70841024O0038921641024O006C591741024O002O8C1741024O005C30194103113O00556E6974486173456E7261676542752O66026O00084003173O0044697370652O6C61626C654375727365446562752O6673024O005C491841024O00C83E194103123O00556E69744861734375727365446562752O6603173O0044697370652O6C61626C654D61676963446562752O6673024O00A4EC1741024O00704D0941024O0068630941024O0028BF1641024O0004F71741024O00D8481841024O003007FC40024O0080291841024O00D4971741024O00A48F1741024O00ECFF1641024O0010E8F940024O0060930941024O00284C0A41024O0064401041024O00A07B0F41024O0050430F41024O00F4081741024O002CD21641024O000C471741024O00D4151941024O002064F540024O0010DF1641024O00FC6E1741024O00AC8E1741024O007CA41741024O00305B1941024O00AC3D1941024O00A4741841024O000C841841024O0044D91841024O0018741941024O00EC25194103123O00556E69744861734D61676963446562752O6603193O0044697370652O6C61626C6544697365617365446562752O6673024O0098880F41024O0078770F41024O0068921641024O0044771641024O0044301841024O0020101741024O00605D174103143O00556E697448617344697365617365446562752O6603183O0044697370652O6C61626C65506F69736F6E446562752O6673025O0024FE4003133O00556E6974486173506F69736F6E446562752O6603153O00556E6974486173446562752O6646726F6D4C697374030A3O004973536F6C6F4D6F6465030D3O00467269656E646C79556E69747303173O0044697370652O6C61626C65467269656E646C79556E697403123O0044697370652O6C61626C65446562752O667303183O0044697370652O6C61626C65467269656E646C79556E697473030D3O00556E697447726F7570526F6C6503123O004D696E64436F6E74726F2O6C5370652O6C7303103O0049734D696E64436F6E74726F2O6C656403093O004E616D6564556E697403123O004C6F77657374467269656E646C79556E697403213O004C6F77657374467269656E646C79556E69745265667265736861626C6542752O6603273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403253O00467269656E646C794E616D6564556E697473576974685265667265736861626C6542752O66031A3O00467269656E646C79556E6974735769746842752O66436F756E74031F3O00467269656E646C79556E69747357697468446562752O6646726F6D4C697374032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74031D3O00467269656E646C79556E697473576974686F757442752O66436F756E7403323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E7403163O0044656164467269656E646C79556E697473436F756E74030D3O004C617374466F6375735377617003123O00466F637573537065636966696564556E6974031B3O00466F637573556E697457697468446562752O6646726F6D4C697374030C3O00476574466F637573556E697403093O00466F637573556E6974031B3O00476574466F637573556E69745265667265736861626C6542752O6603183O00466F637573556E69745265667265736861626C6542752O66031B3O00497354616E6B42656C6F774865616C746850657263656E74616765031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503103O0047726F757042752O664D692O73696E67030C3O0047657450752O6C54696D6572030D3O00476574427265616B54696D6572030B3O0050756C736554696D65727303083O0047657454696D657203063O0054696D657273030A3O00496E697454696D65727300E6032O001215012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100049C3O000A00010012DE000300063O0020650004000300070012DE000500083O0020650005000500090012DE000600083O00206500060006000A00066D00073O000100062O005E3O00064O005E8O005E3O00044O005E3O00014O005E3O00024O005E3O00054O00130008000A3O00122O000A000B3O00122O000B000C3O00202O000C000A000D00202O000D000A000E00202O000E000D000F00202O000F000D001000202O0010000D001100202O0011000D001200202O0012000D00130020650013000D001400200B0114000D001500202O0015000D001600202O0016000A001700202O0017000A001800122O001800193O00122O001900013O00202O00190019001A00122O001A00083O00202O001A001A000A4O001B5O001089000A001B001B2O00F4001B5O002065001C000A001B001089001C001C001B003020011B001D001E000237001C00013O001089001B001F001C000237001C00023O001089001B0020001C00066D001C0003000100022O005E3O00104O005E3O000E3O001089001B0021001C00066D001C0004000100022O005E3O00114O005E3O00103O001089001B0022001C00123A011C001E3O00264C001C003D0001001E00049C3O003D00012O00F4001D5O001089001B0023001D00066D001D0005000100042O005E3O00104O005E3O000E4O005E3O000C4O005E3O001B3O001089001B0024001D00049C3O0049000100049C3O003D0001000237001C00063O001089001B0025001C000237001C00073O001089001B0026001C00066D001C0008000100032O005E3O00184O005E3O000A4O005E3O001B3O001089001B0027001C00066D001C0009000100022O005E3O00184O005E3O00133O001089001B0028001C00066D001C000A000100032O005E3O00184O005E3O00134O005E3O000E3O001089001B0029001C00066D001C000B000100022O005E3O001B4O005E3O00073O001089001B002A001C00123A011C001E4O009E001D001D3O00264C001C00610001001E00049C3O0061000100123A011D002B3O00066D001E000C000100052O005E3O00104O005E3O001D4O005E3O000A4O005E3O00074O005E3O00113O001089001B002C001E00049C3O006D000100049C3O006100012O000E011C5O00123A011C001E4O009E001D001D3O00264C001C00700001001E00049C3O0070000100123A011D002D3O00066D001E000D000100052O005E3O00114O005E3O001D4O005E3O000A4O005E3O00074O005E3O00103O001089001B002E001E00049C3O007C000100049C3O007000012O000E011C5O00123A011C001E4O009E001D001D3O00264C001C007F0001001E00049C3O007F000100123A011D002F3O00066D001E000E000100052O005E3O00114O005E3O001D4O005E3O000A4O005E3O00074O005E3O00103O001089001B0030001E00049C3O008B000100049C3O007F00012O000E011C5O00066D001C000F000100062O005E3O00104O005E3O000E4O005E3O00074O005E3O000A4O005E3O000F4O005E3O00113O001089001B0031001C00123A011C001E3O00264C001C00950001001E00049C3O0095000100066D001D0010000100042O005E3O00074O005E3O001B4O005E3O000E4O005E3O000A3O001089001B0032001D00066D001D0011000100022O005E3O00074O005E3O00173O001089001B0033001D00049C3O00A3000100049C3O0095000100066D001C0012000100062O005E3O00104O005E3O000E4O005E3O00074O005E3O000A4O005E3O000F4O005E3O00113O001089001B0034001C00123A011C001E3O00264C001C00BD0001003500049C3O00BD000100066D001D0013000100052O005E3O00104O005E3O00074O005E3O000C4O005E3O001B4O005E3O000A3O001089001B0036001D00066D001D0014000100052O005E3O00104O005E3O00074O005E3O000C4O005E3O001B4O005E3O000A3O001089001B0037001D00049C3O009C2O0100264C001C008A2O01001E00049C3O008A2O012O00F4001D00263O00129F001E00393O00122O001F003A3O00122O0020003B3O00122O0021003C3O00122O0022003D3O00122O0023003E3O00122O0024003F3O00122O002500403O00122O002600413O00122O002700423O00129F002800433O00122O002900443O00122O002A00453O00122O002B00463O00122O002C00473O00122O002D00483O00122O002E00493O00122O002F004A3O00122O0030004B3O00122O0031004C3O00129F0032004D3O00122O0033004E3O00122O0034004F3O00122O003500503O00122O003600513O00122O003700523O00122O003800533O00122O003900543O00122O003A00553O00122O003B00563O00129F003C00573O00122O003D00583O00122O003E00593O00122O003F005A3O00122O0040005B3O00122O0041005C3O00122O0042005D3O00122O0043005E3O00122O0044005F3O00122O004500603O00129F004600613O00122O004700623O00122O004800633O00122O004900643O00122O004A00653O00122O004B00663O00122O004C00673O00122O004D00683O00122O004E00693O00122O004F006A4O00EC001D0032000100123A011E006B3O00129F001F006C3O00122O0020006D3O00122O0021006E3O00122O0022006F3O00122O002300703O00122O002400713O00122O002500723O00122O002600733O00122O002700743O00122O002800753O00129F002900763O00122O002A00773O00122O002B00783O00122O002C00793O00122O002D007A3O00122O002E007B3O00122O002F007C3O00122O0030007D3O00122O0031007E3O00122O0032007F3O00129F003300803O00122O003400813O00122O003500823O00122O003600833O00122O003700843O00122O003800853O00122O003900863O00122O003A00873O00122O003B00883O00122O003C00893O00129F003D008A3O00122O003E008B3O00122O003F008C3O00122O0040008D3O00122O0041008E3O00122O0042008F3O00122O004300903O00122O004400913O00122O004500923O00122O004600933O00123A014700943O00123A014800953O00123A014900963O0012C5004A00973O00122O004B00983O00122O004C00993O00122O004D009A3O00122O004E009B3O00122O004F009C6O001D004F000200123A011E009D3O0012C5001F009E3O00122O0020009F3O00122O002100A03O00122O002200A13O00122O002300A23O00122O002400A36O001D00240003001089001B0038001D2O008E001D00233O00122O001E00A53O00122O001F00433O00122O0020004C3O00122O0021003A3O00122O002200513O00122O002300503O00122O002400533O00122O0025004E3O00122O002600443O00129F002700393O00122O002800A63O00122O002900A73O00122O002A00A83O00122O002B00A93O00122O002C00AA3O00122O002D00AB3O00122O002E00AC3O00122O002F00AD3O00122O003000AE3O00129F003100543O00122O003200563O00122O003300AF3O00122O003400B03O00122O003500B13O00122O003600B23O00122O003700B33O00122O003800B43O00122O003900B53O00122O003A00B63O00129F003B00B73O00122O003C00613O00122O003D00623O00122O003E00643O00122O003F00653O00122O004000663O00122O004100673O00122O0042006B3O00122O004300B83O00122O0044006C3O00129F0045006D3O00122O004600B93O00122O004700BA3O00122O004800BB3O00122O004900BC3O00122O004A006F3O00122O004B00703O00122O004C00BD3O00122O004D00BE3O00122O004E00BF3O00123A014F00714O00EC001D0032000100123A011E00723O00129F001F00733O00122O002000C03O00122O002100743O00122O002200C13O00122O002300753O00122O002400763O00122O002500C23O00122O002600C33O00122O002700783O00122O002800C43O00129F002900C53O00122O002A007C3O00122O002B007E3O00122O002C00C63O00122O002D00C73O00122O002E00C83O00122O002F00823O00122O003000843O00122O003100873O00122O003200883O00129F003300893O00122O0034008A3O00122O0035008D3O00122O0036008E3O00122O0037008F3O00122O003800903O00122O003900913O00122O003A00983O00122O003B00943O00122O003C00953O0012E9003D00963O00122O003E00C93O00122O003F00CA3O00122O004000CB3O00122O004100CC6O001D00410002001089001B00A4001D00123A011C00CD3O000EA100CD00AC0001001C00049C3O00AC000100066D001D0015000100052O005E3O00104O005E3O00074O005E3O000C4O005E3O001B4O005E3O000A3O001089001B00CE001D00066D001D0016000100052O005E3O00104O005E3O00074O005E3O000C4O005E3O001B4O005E3O000A3O001089001B00CF001D00123A011C00353O00049C3O00AC0001003020011B00D0001E00066D001C0017000100052O005E3O00074O005E3O00104O005E3O000A4O005E3O00184O005E3O001B3O001089001B00D1001C00066D001C0018000100052O005E3O00074O005E3O000E4O005E3O00104O005E3O001B4O005E3O000A3O001089001B00D2001C00066D001C0019000100072O005E3O00074O005E3O00184O005E3O000C4O005E3O00104O005E3O000A4O005E3O001B4O005E3O000E3O001089001B00D3001C00123A011C001E3O000EA1001E00B52O01001C00049C3O00B52O012O00F4001D00113O00129F001E00D53O00122O001F00D63O00122O002000D73O00122O002100D83O00122O002200D93O00122O002300DA3O00122O002400DB3O00122O002500DC3O00122O002600DD3O00122O002700DE3O001252002800DF3O00122O002900E03O00122O002A00E13O00122O002B00E23O00122O002C00E33O00122O002D00E43O00122O002E00E56O001D00110001001089001B00D4001D00066D001D001A000100032O005E3O000C4O005E3O001B4O005E3O00103O001089001B00E6001D00049C3O00D22O0100049C3O00B52O0100123A011C001E3O00264C001C00FD2O0100CD00049C3O00FD2O012O00F4001D000A4O0030011E00163O00122O001F00E86O001E000200024O001F00163O00122O002000E96O001F000200024O002000163O00122O002100EA6O0020000200024O002100163O001205002200626O0021000200024O002200163O00122O002300EB6O0022000200024O002300163O00122O002400726O0023000200024O002400163O00122O002500764O00330124000200024O002500163O00122O002600EC6O0025000200024O002600163O00122O002700ED6O0026000200024O002700163O00122O002800916O0027000200022O005E002800163O00123A012900974O0013012800294O0067001D3O0001001089001B00E7001D00066D001D001B000100012O005E3O001B3O001089001B00EE001D00049C3O0037020100264C001C00D32O01001E00049C3O00D32O012O00F4001D000F4O0030011E00163O00122O001F00F06O001E000200024O001F00163O00122O002000F16O001F000200024O002000163O00122O002100F26O0020000200024O002100163O001205002200F36O0021000200024O002200163O00122O002300F46O0022000200024O002300163O00122O002400F56O0023000200024O002400163O00122O002500F64O00330124000200024O002500163O00122O002600BA6O0025000200024O002600163O00122O002700F76O0026000200024O002700163O00122O002800F86O0027000200022O0030012800163O00122O002900F96O0028000200024O002900163O00122O002A00FA6O0029000200024O002A00163O00122O002B00FB6O002A000200024O002B00163O00123A012C00C84O0020002B000200022O009A002C00163O00122O002D00956O002C000200024O002D00163O00122O002E00FC6O002D002E6O001D3O0001001089001B00EF001D00066D001D001C000100012O005E3O001B3O001089001B00FD001D00123A011C00CD3O00049C3O00D32O0100123A011C001E3O00264C001C004E020100FE00049C3O004E02012O00F4001D00034O0030011E00163O00122O001F2O00015O001E000200024O001F00163O00122O002000AD6O001F000200024O002000163O00122O002100736O0020000200024O002100163O00123A0122002O013O0013012100224O0067001D3O0001001089001B00FF001D00123A011D0002012O00066D001E001D000100012O005E3O001B4O00AF001B001D001E00049C4O00030100123A011D001E3O000650001C00C90201001D00049C3O00C9020100123A011D0003013O0041011E00196O001F00163O00122O0020003A6O001F000200024O002000163O00122O00210004015O0020000200024O002100163O00122O00220005015O0021000200024O002200163O00122O00230006015O0022000200024O002300163O00122O00240007015O0023000200024O002400163O00122O00250008015O0024000200024O002500163O00122O00260009015O0025000200024O002600163O00122O0027000A015O0026000200024O002700163O00122O0028000B015O0027000200024O002800163O00122O0029000C015O0028000200024O002900163O00122O002A00576O0029000200024O002A00163O00122O002B000D015O002A000200024O002B00163O00122O002C00E06O002B000200024O002C00163O00122O002D000E015O002C000200024O002D00163O00122O002E000F015O002D000200024O002E00163O00122O002F0010015O002E000200024O002F00163O00122O00300011015O002F000200024O003000163O00122O00310012015O0030000200024O003100163O00122O00320013015O0031000200024O003200163O00122O00330014015O0032000200024O003300163O00122O00340015015O0033000200024O003400163O00122O00350016015O0034000200024O003500163O00122O00360017015O0035000200024O003600163O00122O00370018015O0036000200024O003700163O00122O00380019015O0037000200024O003800163O00122O0039001A015O0038000200024O003900163O001205003A001B015O0039000200024O003A00163O00122O003B001C015O003A000200024O003B00163O00122O003C001D015O003B000200024O003C00163O00122O003D001E013O0033013C000200024O003D00163O00122O003E009C6O003D000200024O003E00163O00122O003F001F015O003E000200024O003F00163O00122O00400020015O003F000200022O0030014000163O00122O00410021015O0040000200024O004100163O00122O00420022015O0041000200024O004200163O00122O00430023015O0042000200024O004300163O00123A01440024013O0013014300444O0067001E3O00012O00AF001B001D001E00123A011D0025012O00066D001E001E000100012O005E3O001B4O00AF001B001D001E00123A011C00CD3O00123A011D00CD3O000650001C00F00201001D00049C3O00F0020100123A011D0026013O00CA001E00086O001F00163O00122O002000646O001F000200024O002000163O00122O00210027015O0020000200024O002100163O00122O00220028015O0021000200022O0030012200163O00122O00230029015O0022000200024O002300163O00122O0024002A015O0023000200024O002400163O00122O002500C66O0024000200024O002500163O00123A0126002B013O00200025000200022O009A002600163O00122O0027002C015O0026000200024O002700163O00122O0028002D015O002700286O001E3O00012O00AF001B001D001E00123A011D002E012O00066D001E001F000100012O005E3O001B4O00AF001B001D001E00123A011C00353O00123A011D00353O000650001D00380201001C00049C3O0038020100123A011D002F013O00A6001E8O001F00163O00122O00200030015O001F00206O001E3O00012O00AF001B001D001E00123A011D0031012O00066D001E0020000100012O005E3O001B4O00AF001B001D001E00123A011C00FE3O00049C3O0038020100123A011C0032012O000237001D00214O00AF001B001C001D00123A011C0033012O00066D001D0022000100012O005E3O000E4O00AF001B001C001D00123A011C001E4O009E001D001E3O00123A011F00CD3O000650001C00190301001F00049C3O0019030100123A011F0034012O00066D00200023000100092O005E3O001D4O005E3O001B4O005E3O000E4O005E3O001E4O005E3O001A4O005E3O00194O005E3O00074O005E3O00144O005E3O00154O00AF001B001F002000049C3O0022030100123A011F001E3O000650001C00090301001F00049C3O000903012O00F4001F6O00D1001D001F6O001F8O001E001F3O00122O001C00CD3O00044O000903012O000E011C5O00123A011C001E3O00123A011D00CD3O000650001C002D0301001D00049C3O002D030100123A011D0035012O00066D001E0024000100022O005E3O001B4O005E3O00074O00AF001B001D001E00049C3O003A030100123A011D001E3O000650001C00240301001D00049C3O0024030100123A011D0036013O00F4001E6O00AF001B001D001E00123A011D0037012O00066D001E0025000100022O005E3O001B4O005E3O001A4O00AF001B001D001E00123A011C00CD3O00049C3O0024030100123A011C0038012O000237001D00264O00AF001B001C001D00123A011C001E3O00123A011D001E3O000650001C003E0301001D00049C3O003E030100123A011D0039013O00F4001E6O00AF001B001D001E00123A011D003A012O00066D001E0027000100012O005E3O001B4O00AF001B001D001E00049C3O004A030100049C3O003E030100123A011C003B012O00066D001D0028000100012O005E3O001B4O00AF001B001C001D00123A011C003C012O00066D001D0029000100012O005E3O001B4O00AF001B001C001D00123A011C003D012O00066D001D002A000100012O005E3O001B4O00AF001B001C001D00123A011C003E012O00066D001D002B000100012O005E3O001B4O00AF001B001C001D00123A011C003F012O00066D001D002C000100022O005E3O00184O005E3O001B4O00AF001B001C001D00123A011C0040012O00066D001D002D000100022O005E3O001B4O005E3O00074O00AF001B001C001D00123A011C0041012O00066D001D002E000100012O005E3O001B4O00AF001B001C001D00123A011C0042012O00066D001D002F000100022O005E3O001B4O005E3O00074O00AF001B001C001D00123A011C0043012O00066D001D0030000100022O005E3O001B4O005E3O00074O00AF001B001C001D00123A011C0044012O00066D001D0031000100022O005E3O001B4O005E3O00074O00AF001B001C001D00123A011C0045012O00066D001D0032000100012O005E3O001B4O0011011B001C001D00122O001C0046012O00122O001D001E6O001B001C001D00122O001C0047012O00066D001D0033000100052O005E3O000F4O005E3O00074O005E3O000C4O005E3O001B4O005E3O000A4O00AF001B001C001D00123A011C0048012O00066D001D0034000100052O005E3O001B4O005E3O000F4O005E3O00074O005E3O000C4O005E3O000A4O00AF001B001C001D00123A011C0049012O00066D001D0035000100032O005E3O001B4O005E3O000E4O005E3O00104O00AF001B001C001D00123A011C004A012O00066D001D0036000100052O005E3O001B4O005E3O000F4O005E3O00074O005E3O000C4O005E3O000A4O00AF001B001C001D00123A011C004B012O00066D001D0037000100032O005E3O001B4O005E3O000E4O005E3O00104O00AF001B001C001D00123A011C004C012O00066D001D0038000100052O005E3O001B4O005E3O000F4O005E3O00074O005E3O000C4O005E3O000A4O00AF001B001C001D00123A011C004D012O00066D001D0039000100022O005E3O001B4O005E3O00074O00AF001B001C001D00123A011C004E012O00066D001D003A000100022O005E3O001B4O005E3O000E4O00AF001B001C001D00123A011C004F012O00066D001D003B000100042O005E3O00074O005E3O000D4O005E3O00184O005E3O000A4O00AF001B001C001D00123A011C001E3O00123A011D00353O000650001C00CA0301001D00049C3O00CA030100123A011D0050012O00066D001E003C000100022O005E3O001B4O005E3O00074O00AF001B001D001E00123A011D0051012O00066D001E003D000100022O005E3O001B4O005E3O00074O00AF001B001D001E00049C3O00E5030100123A011D00CD3O000650001C00D70301001D00049C3O00D7030100123A011D0052012O00066D001E003E000100022O005E3O00074O005E3O001B4O00AF001B001D001E00123A011D0053012O00066D001E003F000100012O005E3O001B4O00AF001B001D001E00123A011C00353O00123A011D001E3O000650001C00BC0301001D00049C3O00BC030100123A011D0054013O00F4001E6O00AF001B001D001E00123A011D0055012O00066D001E0040000100032O005E3O00074O005E3O001B4O005E3O001A4O00AF001B001D001E00123A011C00CD3O00049C3O00BC03012O001F3O00013O00413O00023O00026O00F03F026O00704002264O007A00025O00122O000300016O00045O00122O000500013O00042O0003002100012O003901076O0017010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004370103000500012O0039010300054O005E000400024O008B000300044O00EA00036O001F3O00017O00023O00026O00F03F028O0001083O0006F73O000500013O00049C3O0005000100123A2O0100014O0071000100023O00049C3O0007000100123A2O0100024O0071000100024O001F3O00017O00013O00028O0001063O00264C3O00030001000100049C3O000300012O004E00016O0051000100014O0071000100024O001F3O00017O00033O0003063O0045786973747303093O0043616E412O7461636B030D3O004973446561644F7247686F737400114O0039016O0020885O00012O00203O000200020006F73O000F00013O00049C3O000F00012O0039012O00013O0020885O00022O003901026O006B3O000200020006F73O000F00013O00049C3O000F00012O0039016O0020885O00032O00203O000200022O007F8O00713O00024O001F3O00017O00023O0003063O0045786973747303043O0047554944001C4O0039016O0006F73O001A00013O00049C3O001A00012O0039012O00013O0006F73O001A00013O00049C3O001A00012O0039016O0020885O00012O00203O000200020006F73O001A00013O00049C3O001A00012O0039012O00013O0020885O00012O00203O000200020006F73O001A00013O00049C3O001A00012O0039016O0020BF5O00026O000200024O000100013O00202O0001000100024O00010002000200064O00190001000100049C3O001900012O004E8O00513O00014O00713O00024O001F3O00017O00053O0003063O0045786973747303093O0043616E412O7461636B030E3O0056616C75654973496E412O726179030E3O004865616C61626C654E706349447303053O004E5043494400184O0039016O0020885O00012O00203O000200020006F73O001600013O00049C3O001600012O0039012O00013O0020885O00022O003901026O006B3O000200020006903O00140001000100049C3O001400012O0039012O00023O00201E5O00034O000100033O00202O0001000100044O00025O00202O0002000200054O000200039O00000200049C3O001600012O004E8O00513O00014O00713O00024O001F3O00017O00043O0003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C697374656403113O0046696C746572656454696D65546F44696503013O003E03143O00208800033O00012O0020000300020002000690000300100001000100049C3O0010000100208800033O00022O0020000300020002000690000300100001000100049C3O001000010006F70001001100013O00049C3O0011000100208800033O00030012C3000500046O000600016O000700026O00030007000200044O001200012O004E00036O0051000300014O0071000300024O001F3O00017O00023O0003063O004865616C746803073O00497344752O6D79020B3O00208800023O00012O0020000200020002000634000100050001000200049C3O0008000100208800023O00022O002000020002000200049C3O000900012O004E00026O0051000200014O0071000200024O001F3O00017O00043O00028O00026O00F03F030A3O00436F6D62617454696D6503123O0043752O72656E74456E636F756E746572494403223O00123A010300014O009E000400043O00264C000300130001000200049C3O001300012O003901056O005E000600014O002E01050002000700049C3O000F00010006300009000F0001000400049C3O000F00012O0008000A000900020006300004000F0001000A00049C3O000F00012O0051000A00014O0071000A00023O00063F010500080001000200049C3O000800012O005100056O0071000500023O00264C000300020001000100049C3O000200012O0039010500013O0020E00005000500034O0005000100024O000400056O000500023O00202O00050005000400064O001F0001000500049C3O001F00012O005100056O0071000500023O00123A010300023O00049C3O000200012O001F3O00017O00033O00028O0003063O0045786973747303093O00497343617374696E6701173O00123A2O0100013O00264C000100010001000100049C3O000100012O003901026O0039010300014O002E01020002000400049C3O001100010020880007000600022O00200007000200020006F70007001100013O00049C3O001100010020880007000600032O005E00096O006B0007000900020006F70007001100013O00049C3O001100012O0071000600023O00063F010200070001000200049C3O000700012O009E000200024O0071000200023O00049C3O000100012O001F3O00017O00063O00028O0003063O0045786973747303083O00446562752O665570030E3O0049735370652O6C496E52616E676503093O0043616E412O7461636B026O00F03F02273O00123A010200014O009E000300033O00264C000200220001000100049C3O0022000100123A010300014O003901046O0039010500014O002E01040002000600049C3O001F00010020880009000800022O00200009000200020006F70009001F00013O00049C3O001F00010020880009000800032O005E000B6O006B0009000B00020006F70009001F00013O00049C3O001F00010020880009000800042O005E000B6O006B0009000B00020006F70009001F00013O00049C3O001F00012O0039010900023O0020880009000900052O005E000B00084O006B0009000B00020006F70009001F00013O00049C3O001F00010020F90009000300060020F900030009000100063F010400090001000200049C3O0009000100123A010200063O00264C000200020001000600049C3O000200012O0071000300023O00049C3O000200012O001F3O00017O00073O00028O00030D3O00467269656E646C79556E697473026O00F03F030A3O00556E69744973556E697403023O00494403063O00D9E60FFC1FD903053O007AAD877D9B01233O00123A2O0100014O009E000200023O00264C0001001D0001000100049C3O001D00012O003901035O0020E70003000300024O0003000100024O000200033O00122O000300036O000400023O00122O000500033O00042O0003001C00012O00EF000700020006001207010800043O00202O0009000700054O00090002000200202O000A3O00054O000A000200024O000B00013O00122O000C00063O00122O000D00076O000B000D00024O000A000A000B4O0008000A000200062O0008001B00013O00049C3O001B00012O0071000700023O0004370103000C000100123A2O0100033O00264C000100020001000300049C3O000200012O009E000300034O0071000300023O00049C3O000200012O001F3O00017O000C3O00028O00026O00444003063O0045786973747303053O004E50434944030E3O0049735370652O6C496E52616E676503073O004973526561647903053O005072652O7303123O00ACC00EBD333488ADCF03B62D21C796C401B503073O00A8E4A160D95F51026O00F03F031C3O00F3D0205823529BF8205F2045CBDE3C592E5B9BFC21493C52D4C72B4E03063O0037BBB14E3C4F04603O00123A010400013O00264C000400300001000100049C3O00300001000690000200060001000100049C3O0006000100123A010200024O003901055O0006F70005002F00013O00049C3O002F00012O003901055O0020880005000500032O00200005000200020006F70005002F00013O00049C3O002F00012O003901055O0020880005000500042O00200005000200022O0039010600013O0006500005002F0001000600049C3O002F00012O003901055O0020880005000500052O005E00076O006B0005000700020006F70005002F00013O00049C3O002F000100208800053O00062O00200005000200020006F70005002F00013O00049C3O002F00012O0039010500023O0020930005000500074O00068O00075O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005002F00013O00049C3O002F00012O0039010500033O00123A010600083O00123A010700094O008B000500074O00EA00055O00123A0104000A3O000EA1000A00010001000400049C3O000100010006F70001005F00013O00049C3O005F00012O0039010500043O0006F70005005F00013O00049C3O005F00012O0039010500043O0020880005000500032O00200005000200020006F70005005F00013O00049C3O005F00012O0039010500043O0020880005000500042O00200005000200022O0039010600013O0006500005005F0001000600049C3O005F00012O0039010500043O0020880005000500052O005E00076O006B0005000700020006F70005005F00013O00049C3O005F000100208800053O00062O00200005000200020006F70005005F00013O00049C3O005F00012O0039010500023O0020930005000500074O000600016O000700043O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005005F00013O00049C3O005F00012O0039010500033O00120B0006000B3O00122O0007000C6O000500076O00055O00044O005F000100049C3O000100012O001F3O00017O000C3O00028O00026O00F03F03063O0045786973747303053O004E50434944030E3O0049735370652O6C496E52616E676503073O004973526561647903053O005072652O73031A3O0005CF51EF4ACAC00CC859E74FCC9428CA1FC649DA9328C149EE5403073O00E04DAE3F8B26AF026O00444003103O00AC40562A8844180F8247542787555D2A03043O004EE4213804603O00123A010400013O000EA10002002F0001000400049C3O002F00010006F70001005F00013O00049C3O005F00012O003901055O0006F70005005F00013O00049C3O005F00012O003901055O0020880005000500032O00200005000200020006F70005005F00013O00049C3O005F00012O003901055O0020880005000500042O00200005000200022O0039010600013O0006500005005F0001000600049C3O005F00012O003901055O0020880005000500052O005E00076O006B0005000700020006F70005005F00013O00049C3O005F000100208800053O00062O00200005000200020006F70005005F00013O00049C3O005F00012O0039010500023O0020930005000500074O000600016O00075O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005005F00013O00049C3O005F00012O0039010500033O00120B000600083O00122O000700096O000500076O00055O00044O005F000100264C000400010001000100049C3O00010001000690000200340001000100049C3O0034000100123A0102000A4O0039010500043O0006F70005005D00013O00049C3O005D00012O0039010500043O0020880005000500032O00200005000200020006F70005005D00013O00049C3O005D00012O0039010500043O0020880005000500042O00200005000200022O0039010600013O0006500005005D0001000600049C3O005D00012O0039010500043O0020880005000500052O005E00076O006B0005000700020006F70005005D00013O00049C3O005D000100208800053O00062O00200005000200020006F70005005D00013O00049C3O005D00012O0039010500023O0020930005000500074O00068O000700043O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005005D00013O00049C3O005D00012O0039010500033O00123A0106000B3O00123A0107000C4O008B000500074O00EA00055O00123A010400023O00049C3O000100012O001F3O00017O000C3O00028O00026O00F03F03063O0045786973747303053O004E50434944030E3O0049735370652O6C496E52616E676503073O004973526561647903053O005072652O7303183O00E67FBC0789CB3E910B97C173BB06C5E371A71080C168B71103053O00E5AE1ED263026O004440030E3O0033EC8855E1387938E5945EE0343C03073O00597B8DE6318D5D04603O00123A010400013O00264C0004002F0001000200049C3O002F00010006F70001005F00013O00049C3O005F00012O003901055O0006F70005005F00013O00049C3O005F00012O003901055O0020880005000500032O00200005000200020006F70005005F00013O00049C3O005F00012O003901055O0020880005000500042O00200005000200022O0039010600013O0006500005005F0001000600049C3O005F00012O003901055O0020880005000500052O005E00076O006B0005000700020006F70005005F00013O00049C3O005F000100208800053O00062O00200005000200020006F70005005F00013O00049C3O005F00012O0039010500023O0020930005000500074O000600016O00075O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005005F00013O00049C3O005F00012O0039010500033O00120B000600083O00122O000700096O000500076O00055O00044O005F000100264C000400010001000100049C3O00010001000690000200340001000100049C3O0034000100123A0102000A4O0039010500043O0006F70005005D00013O00049C3O005D00012O0039010500043O0020880005000500032O00200005000200020006F70005005D00013O00049C3O005D00012O0039010500043O0020880005000500042O00200005000200022O0039010600013O0006500005005D0001000600049C3O005D00012O0039010500043O0020880005000500052O005E00076O006B0005000700020006F70005005D00013O00049C3O005D000100208800053O00062O00200005000200020006F70005005D00013O00049C3O005D00012O0039010500023O0020930005000500074O00068O000700043O00202O0007000700054O00098O0007000900024O000700076O000800036O00050008000200062O0005005D00013O00049C3O005D00012O0039010500033O00123A0106000B3O00123A0107000C4O008B000500074O00EA00055O00123A010400023O00049C3O000100012O001F3O00017O00423O00028O00026O00444003063O00457869737473030F3O0047657455736561626C654974656D73026O002A40027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00DD74FA2O184BE164E52F0243E703063O002A9311966C7003103O0021A3216BEFE91DB33E52E6FB1BA33F6603063O00886FC64D1F8703143O002C0CAB42B5E505BC113FA244AEE503A00E00B34F03083O00C96269C736DD8477026O00084003103O008D039315103CA2B20997150327ABBC1803073O00CCD96CE341625503053O007BCDF0E83503063O00A03EA395854C03103O00E2AF1D1BD1DFAE062AD7F5B51F3CCCC403053O00A3B6C06D4F03123O00112805CDEC74130EC4F0266623D5E727291203053O0095544660A003133O000C091DD92A0F03E63D122EE2360204F931092O03043O008D58666D03093O00446F6E277420557365026O00F03F030C3O00875CDA4408345BCAB647E24003083O00A1D333AA107A5D3503163O00C8BEBD21F7BD9D2ED5ABBE3CF3AFA03DE89BA129FCAB03043O00489BCED2030C3O006875404E16576F5D1E23437E03053O0053261A346E030E3O0076122B52501635534B3F26554C1203043O0026387747026O001040030C3O005072652O735472696E6B657403123O00DBEE56D22953B3DB57C66562E1E656DD204203063O0036938F38B64503053O00F795BF61EF03053O00BFB6E19F2903063O001B1E294C8E9503073O00A24B724835EBE703103O004865616C746850657263656E7461676503083O00AA2E4DE75D06802503063O0062EC5C24823303053O00811709B75C03083O0050C4796CDA25C8D503063O002366106C441C03073O00EA6013621F2B6E030E3O00311646CFEC5184091356C8BB7C9803073O00EB667F32A7CC1203123O0075AFF02E5D6E65AFF126566E73B4E7304B3C03063O004E30C195432403093O0043616E412O7461636B030D3O004973446561644F7247686F73742O033O0004119003053O0021507EE078026O003540024O000C501741024O001050174103083O00556E697442752O6603063O00FCA402DD59FE03053O003C8CC863A4024O0014501741024O0008501741044D012O00123A010400013O00264C000400010001000100049C3O00010001000690000200060001000100049C3O0006000100123A010200024O003901055O0006F70005004C2O013O00049C3O004C2O012O003901055O0020880005000500032O00200005000200020006F70005004C2O013O00049C3O004C2O012O0039010500013O0020360005000500044O00075O00122O000800056O00050008000200062O0005004C2O013O00049C3O004C2O0100123A010500014O009E0006000E3O00264C000500380001000600049C3O003800010012DE000F00073O0020B2000F000F00084O001000023O00122O001100093O00122O0012000A6O0010001200024O000F000F001000062O000C00230001000F00049C3O002300012O0051000C5O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011000B3O00122O0012000C6O0010001200024O000F000F001000062O000D002D0001000F00049C3O002D00012O0051000D5O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011000D3O00122O0012000E6O0010001200024O000F000F001000062O000E00370001000F00049C3O003700012O0051000E5O00123A0105000F3O00264C000500610001000100049C3O006100010012DE000F00073O0020B2000F000F00084O001000023O00122O001100103O00122O001200116O0010001200024O000F000F001000062O000600480001000F00049C3O004800012O0039010F00023O00123A011000123O00123A011100134O006B000F001100022O005E0006000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100143O00122O001200156O0010001200024O000F000F001000062O000700560001000F00049C3O005600012O0039010F00023O00123A011000163O00123A011100174O006B000F001100022O005E0007000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100183O00122O001200196O0010001200024O000F000F001000062O000800600001000F00049C3O0060000100123A0108001A3O00123A0105001B3O00264C000500860001001B00049C3O008600010012DE000F00073O0020B2000F000F00084O001000023O00122O0011001C3O00122O0012001D6O0010001200024O000F000F001000062O0009006D0001000F00049C3O006D000100123A010900013O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011001E3O00122O0012001F6O0010001200024O000F000F001000062O000A007B0001000F00049C3O007B00012O0039010F00023O00123A011000203O00123A011100214O006B000F001100022O005E000A000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100223O00122O001200236O0010001200024O000F000F001000062O000B00850001000F00049C3O008500012O0051000B5O00123A010500063O00264C000500960001002400049C3O009600012O0039010F00033O002098000F000F002500122O001000056O001100066O001200076O000F0012000200062O000F004C2O013O00049C3O004C2O012O0039010F00023O00120B001000263O00122O001100276O000F00116O000F5O00044O004C2O0100264C000500170001000F00049C3O0017000100264C0008009D0001001A00049C3O009D00012O0051000F6O0071000F00023O00049C3O00E500012O0039010F00023O00123A011000283O00123A011100294O006B000F00110002000650000800DB0001000F00049C3O00DB00012O0039010F00023O00123A0110002A3O00123A0111002B4O006B000F00110002000650000600B10001000F00049C3O00B100012O0039010F00013O002088000F000F002C2O0020000F00020002000622000900E50001000F00049C3O00E500012O0051000F6O0071000F00023O00049C3O00E500012O0039010F00023O00123A0110002D3O00123A0111002E4O006B000F00110002000650000600BF0001000F00049C3O00BF00012O0039010F00043O002088000F000F002C2O0020000F00020002000622000900E50001000F00049C3O00E500012O0051000F6O0071000F00023O00049C3O00E500012O0039010F00023O00123A0110002F3O00123A011100304O006B000F00110002000650000600CD0001000F00049C3O00CD00012O0039010F5O002088000F000F002C2O0020000F00020002000622000900E50001000F00049C3O00E500012O0051000F6O0071000F00023O00049C3O00E500012O0039010F00023O00123A011000313O00123A011100324O006B000F00110002000650000600E50001000F00049C3O00E500012O0039010F5O002088000F000F002C2O0020000F00020002000622000900E50001000F00049C3O00E500012O0051000F6O0071000F00023O00049C3O00E500012O0039010F00023O00123A011000333O00123A011100344O006B000F00110002000650000800E50001000F00049C3O00E50001000690000100E50001000100049C3O00E500012O0051000F6O0071000F00024O0039010F00023O00123A011000353O00123A011100364O006B000F001100020006500007003O01000F00049C3O003O012O0039010F00053O0006F7000F00FF00013O00049C3O00FF00012O0039010F00053O002088000F000F00032O0020000F000200020006F7000F00FF00013O00049C3O00FF00012O0039010F00013O002088000F000F00372O0039011100054O006B000F001100020006F7000F00FF00013O00049C3O00FF00012O0039010F00053O002088000F000F00382O0020000F000200022O007F000F000F3O000690000F003O01000100049C3O003O012O0051000F6O0071000F00024O0039010F00023O00123A011000393O00123A0111003A4O006B000F00110002000650000A00482O01000F00049C3O00482O0100123A010F00014O009E001000103O000EA1000100092O01000F00049C3O00092O012O005100105O00123A0111001B3O00123A0112003B3O00123A0113001B3O00045B001100462O0100123A011500014O009E001600193O00264C0015001F2O01001B00049C3O001F2O0100264C001900192O01003C00049C3O00192O010006F7000B00192O013O00049C3O00192O012O0051001000013O00264C0019001E2O01003D00049C3O001E2O010006F7000D001E2O013O00049C3O001E2O012O0051001000013O00123A011500063O000EA1000100382O01001500049C3O00382O010012DE001A003E4O0074001B00023O00122O001C003F3O00122O001D00406O001B001D00024O001C00146O001A001C00234O001900236O001700226O001700216O001700206O0018001F6O0017001E6O0017001D6O0017001C6O0017001B6O0016001A3O00262O001900372O01004100049C3O00372O010006F7000E00372O013O00049C3O00372O012O0051001000013O00123A0115001B3O00264C001500122O01000600049C3O00122O0100264C0019003F2O01004200049C3O003F2O010006F7000C003F2O013O00049C3O003F2O012O0051001000013O000690001000452O01000100049C3O00452O012O0051001A6O0071001A00023O00049C3O00452O0100049C3O00122O01000437011100102O0100049C3O00482O0100049C3O00092O0100123A010500243O00049C3O0017000100049C3O004C2O0100049C3O000100012O001F3O00017O00163O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00A3C43716AD93FD0B288C86F90103053O00C2E7946446030E3O00627CF293F9DC4F43CF96E5C9414903063O00A8262CA1C396026O00F03F027O0040030E3O00506F74696F6E53656C656374656403073O004973526561647903133O00A2F08D7934E4A30594B7A1793FE4B21997F29103083O0076E09CE2165088D6030B3O00426C2O6F646C7573745570030D3O004570696353652O74696E67734D025O00407F4003093O0061E1568C46E14E8E5103043O00E0228E3903093O00FCABCAD277FD481DCA03083O006EBEC7A5BD13913D030B3O00F5E537CB84C8D6EF78FF8503063O00A7BA8B1788EB016F3O00123A2O0100014O009E000200043O00264C000100130001000100049C3O001300010012DE000500023O0020350105000500034O00065O00122O000700043O00122O000800056O0006000800024O00020005000600122O000500023O00202O0005000500034O00065O00122O000700063O00122O000800076O0006000800024O00030005000600122O000100083O00264C000100170001000900049C3O001700012O005100056O0071000500023O00264C000100020001000800049C3O000200012O0039010500013O00206500050005000A2O001A0005000100022O005E000400053O0006F70004006C00013O00049C3O006C000100208800050004000B2O00200005000200020006F70005006C00013O00049C3O006C00012O003901055O00123A0106000C3O00123A0107000D4O006B000500070002000650000300390001000500049C3O003900012O0039010500023O00208800050005000E2O00200005000200020006F70005006C00013O00049C3O006C00010006F73O006C00013O00049C3O006C000100123A010500013O000EA1000100310001000500049C3O003100012O0039010600033O0030200106000F00102O0051000600014O0071000600023O00049C3O0031000100049C3O006C00012O003901055O00123A010600113O00123A010700124O006B0005000700020006500003004A0001000500049C3O004A00010006F73O006C00013O00049C3O006C000100123A010500013O000EA1000100420001000500049C3O004200012O0039010600033O0030200106000F00102O0051000600014O0071000600023O00049C3O0042000100049C3O006C00012O003901055O00123A010600133O00123A010700144O006B0005000700020006500003005E0001000500049C3O005E00012O0039010500023O00208800050005000E2O00200005000200020006F70005006C00013O00049C3O006C000100123A010500013O00264C000500560001000100049C3O005600012O0039010600033O0030200106000F00102O0051000600014O0071000600023O00049C3O0056000100049C3O006C00012O003901055O00123A010600153O00123A010700164O006B0005000700020006500003006C0001000500049C3O006C000100123A010500013O00264C000500650001000100049C3O006500012O0039010600033O0030200106000F00102O0051000600014O0071000600023O00049C3O0065000100123A2O0100093O00049C3O000200012O001F3O00017O002A3O00028O00026O00F03F024O00186D0741024O00106D0741024O00086D0741024O00B85C0741024O00B05C0741024O00A85C0741027O0040024O00E85C0741024O00E05C0741024O00D85C0741024O00285C0741024O00205C0741024O00185C0741026O000840026O00104003173O003CB98D080EBC860A5A80841913B889191FF5B8020DB09A03043O006D7AD5E803063O0069706169727303083O004973557361626C65030E3O00C8FBA735FAFEAC37AEC7AD27EBE503043O00508E97C2030E3O0036CA63450EC7634943F6785B06D403043O002C63A61703053O004CF83E332103063O00C41C9749565303133O00C00B261389511671B327200381541765E6112C03083O001693634970E23878030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O009C45D1C582AC7CEDFBA3B978E703053O00EDD8158295024O00506D0741024O00486D0741024O00406D0741024O00405C0741024O00385C0741024O00305C0741024O00485D0741024O00405D0741024O00385D074100BE3O00123A012O00014O009E000100083O000EA10002001100013O00049C3O001100012O00F4000900033O00123A010A00033O00123A010B00043O00123A010C00054O00EC0009000300012O005E000300094O005D000900033O00122O000A00063O00122O000B00073O00122O000C00086O0009000300012O005E000400093O00123A012O00093O00264C3O00200001000900049C3O002000012O00F4000900033O00123A010A000A3O00123A010B000B3O00123A010C000C4O00EC0009000300012O005E000500094O005D000900033O00122O000A000D3O00122O000B000E3O00122O000C000F6O0009000300012O005E000600093O00123A012O00103O00264C3O009D0001001100049C3O009D00012O003901095O00123A010A00123O00123A010B00134O006B0009000B00020006500001003A0001000900049C3O003A00010012DE000900144O005E000A00024O002E01090002000B00049C3O003700012O0039010E00014O00A9000F000D6O000E0002000200202O000E000E00154O000E0002000200062O000E003700013O00049C3O003700012O0039010E00014O005E000F000D4O008B000E000F4O00EA000E5O00063F0109002C0001000200049C3O002C000100049C3O00BD00012O003901095O00123A010A00163O00123A010B00174O006B0009000B0002000650000100520001000900049C3O005200010012DE000900144O005E000A00034O002E01090002000B00049C3O004F00012O0039010E00014O00A9000F000D6O000E0002000200202O000E000E00154O000E0002000200062O000E004F00013O00049C3O004F00012O0039010E00014O005E000F000D4O008B000E000F4O00EA000E5O00063F010900440001000200049C3O0044000100049C3O00BD00012O003901095O00123A010A00183O00123A010B00194O006B0009000B00020006500001006A0001000900049C3O006A00010012DE000900144O005E000A00044O002E01090002000B00049C3O006700012O0039010E00014O00A9000F000D6O000E0002000200202O000E000E00154O000E0002000200062O000E006700013O00049C3O006700012O0039010E00014O005E000F000D4O008B000E000F4O00EA000E5O00063F0109005C0001000200049C3O005C000100049C3O00BD00012O003901095O00123A010A001A3O00123A010B001B4O006B0009000B0002000650000100820001000900049C3O008200010012DE000900144O005E000A00054O002E01090002000B00049C3O007F00012O0039010E00014O00A9000F000D6O000E0002000200202O000E000E00154O000E0002000200062O000E007F00013O00049C3O007F00012O0039010E00014O005E000F000D4O008B000E000F4O00EA000E5O00063F010900740001000200049C3O0074000100049C3O00BD00012O003901095O00123A010A001C3O00123A010B001D4O006B0009000B00020006500001009A0001000900049C3O009A00010012DE000900144O005E000A00084O002E01090002000B00049C3O009700012O0039010E00014O00A9000F000D6O000E0002000200202O000E000E00154O000E0002000200062O000E009700013O00049C3O009700012O0039010E00014O005E000F000D4O008B000E000F4O00EA000E5O00063F0109008C0001000200049C3O008C000100049C3O00BD00012O009E000900094O0071000900023O00049C3O00BD000100264C3O00AD0001000100049C3O00AD00010012DE0009001E3O00201800090009001F4O000A5O00122O000B00203O00122O000C00216O000A000C00024O00010009000A4O000900033O00122O000A00223O00122O000B00233O00122O000C00246O0009000300012O005E000200093O00123A012O00023O000EA10010000200013O00049C3O000200012O00F4000900033O00123A010A00253O00123A010B00263O00123A010C00274O00EC0009000300012O005E000700094O005D000900033O00122O000A00283O00122O000B00293O00122O000C002A6O0009000300012O005E000800093O00123A012O00113O00049C3O000200012O001F3O00017O00413O00028O00026O00444003063O00457869737473030F3O0047657455736561626C654974656D73026O002C40026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E677303163O00B15E5056BCDA7184605A53A4C15F905B4C6AA3C8598703073O003EE22E2O3FD0A9030C3O00CB1641C33A1C3A57F509508703083O003E857935E37F6D4F030E3O003E113EE1DEAFB005071AF4C5BAA703073O00C270745295B6CE030D3O0017AD400CC8E31C2CBB6F0AC9F603073O006E59C82C78A08203103O0085C647522O4B2958B8EE4A55574F295403083O002DCBA32B26232A5B027O0040026O000840030C3O005072652O735472696E6B657403153O00FA84D2278BAC14F08AC83788A414E697D52D8CAC4003073O0034B2E5BC43E7C903133O00034E4410F8511733485E0FF2481720535701E303073O004341213064973C03053O00FAE9ABD5EA03053O0093BF87CEB803133O00A627B2D5D75E869621A8CADD472O913AB5CECA03073O00D2E448C6A1B83303123O001347F61D6A8E0347F715618E155CE1037CDC03063O00AE562993701303163O00790F991F2A0225B9520E860E312C1EA55F0999022A0103083O00CB3B60ED6B456F7103093O00446F6E277420557365030F3O000619B8F53EFDE3361FA2EA34E4FF1403073O00B74476CC81519003143O0020A87CF003831CB863D20E901DAC64ED078B1AB403063O00E26ECD10846B03053O00CAD7A0F17103053O00218BA380B903063O00675405C7524A03043O00BE37386403103O004865616C746850657263656E7461676503083O0070BD351B1DE7FF4F03073O009336CF5C7E738303053O00283F30701403063O001E6D51551D6D03063O00DC6446A539CC03073O009C9F1134D656BE030E3O0099E6A9B4EECCB2B3A2EBB2ABA0FC03043O00DCCE8FDD03123O00A373281AC18CE78879280598EFC7946E220503073O00B2E61D4D77B8AC03093O0043616E412O7461636B030D3O004973446561644F7247686F737403063O00D7B11E0F78F503063O009895DE6A7B17026O003540024O000C501741024O0010501741024O000850174103083O00556E697442752O6603063O00CD2AF75AB0CF03053O00D5BD469623024O0014501741044A012O00123A010400013O00264C000400010001000100049C3O00010001000690000200060001000100049C3O0006000100123A010200024O003901055O0006F7000500492O013O00049C3O00492O012O003901055O0020880005000500032O00200005000200020006F7000500492O013O00049C3O00492O012O0039010500013O0020360005000500044O00075O00122O000800056O00050008000200062O000500492O013O00049C3O00492O0100123A010500014O009E0006000E3O00264C000500460001000600049C3O004600010012DE000F00073O0020B2000F000F00084O001000023O00122O001100093O00122O0012000A6O0010001200024O000F000F001000062O000A00270001000F00049C3O002700012O0039010F00023O00123A0110000B3O00123A0111000C4O006B000F001100022O005E000A000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011000D3O00122O0012000E6O0010001200024O000F000F001000062O000B00310001000F00049C3O003100012O0051000B5O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011000F3O00122O001200106O0010001200024O000F000F001000062O000C003B0001000F00049C3O003B00012O0051000C5O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100113O00122O001200126O0010001200024O000F000F001000062O000D00450001000F00049C3O004500012O0051000D5O00123A010500133O00264C000500560001001400049C3O005600012O0039010F00033O002098000F000F001500122O001000056O001100066O001200076O000F0012000200062O000F00492O013O00049C3O00492O012O0039010F00023O00120B001000163O00122O001100176O000F00116O000F5O00044O00492O0100264C000500890001000100049C3O008900010012DE000F00073O0020B2000F000F00084O001000023O00122O001100183O00122O001200196O0010001200024O000F000F001000062O000600660001000F00049C3O006600012O0039010F00023O00123A0110001A3O00123A0111001B4O006B000F001100022O005E0006000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O0011001C3O00122O0012001D6O0010001200024O000F000F001000062O000700740001000F00049C3O007400012O0039010F00023O00123A0110001E3O00123A0111001F4O006B000F001100022O005E0007000F3O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100203O00122O001200216O0010001200024O000F000F001000062O0008007E0001000F00049C3O007E000100123A010800223O0012DE000F00073O0020B2000F000F00084O001000023O00122O001100233O00122O001200246O0010001200024O000F000F001000062O000900880001000F00049C3O0088000100123A010900013O00123A010500063O00264C000500170001001300049C3O001700010012DE000F00073O0020B2000F000F00084O001000023O00122O001100253O00122O001200266O0010001200024O000F000F001000062O000E00950001000F00049C3O009500012O0051000E5O00264C0008009A0001002200049C3O009A00012O0051000F6O0071000F00023O00049C3O00E200012O0039010F00023O00123A011000273O00123A011100284O006B000F00110002000650000800D80001000F00049C3O00D800012O0039010F00023O00123A011000293O00123A0111002A4O006B000F00110002000650000600AE0001000F00049C3O00AE00012O0039010F00013O002088000F000F002B2O0020000F00020002000622000900E20001000F00049C3O00E200012O0051000F6O0071000F00023O00049C3O00E200012O0039010F00023O00123A0110002C3O00123A0111002D4O006B000F00110002000650000600BC0001000F00049C3O00BC00012O0039010F00043O002088000F000F002B2O0020000F00020002000622000900E20001000F00049C3O00E200012O0051000F6O0071000F00023O00049C3O00E200012O0039010F00023O00123A0110002E3O00123A0111002F4O006B000F00110002000650000600CA0001000F00049C3O00CA00012O0039010F5O002088000F000F002B2O0020000F00020002000622000900E20001000F00049C3O00E200012O0051000F6O0071000F00023O00049C3O00E200012O0039010F00023O00123A011000303O00123A011100314O006B000F00110002000650000600E20001000F00049C3O00E200012O0039010F5O002088000F000F002B2O0020000F00020002000622000900E20001000F00049C3O00E200012O0051000F6O0071000F00023O00049C3O00E200012O0039010F00023O00123A011000323O00123A011100334O006B000F00110002000650000800E20001000F00049C3O00E20001000690000100E20001000100049C3O00E200012O0051000F6O0071000F00024O0039010F00023O00123A011000343O00123A011100354O006B000F00110002000650000700FE0001000F00049C3O00FE00012O0039010F00053O0006F7000F00FC00013O00049C3O00FC00012O0039010F00053O002088000F000F00032O0020000F000200020006F7000F00FC00013O00049C3O00FC00012O0039010F00013O002088000F000F00362O0039011100054O006B000F001100020006F7000F00FC00013O00049C3O00FC00012O0039010F00053O002088000F000F00372O0020000F000200022O007F000F000F3O000690000F00FE0001000100049C3O00FE00012O0051000F6O0071000F00024O0039010F00023O00123A011000383O00123A011100394O006B000F00110002000650000A00452O01000F00049C3O00452O0100123A010F00014O009E001000103O00264C000F00062O01000100049C3O00062O012O005100105O00123A011100063O00123A0112003A3O00123A011300063O00045B001100432O0100123A011500014O009E001600193O00264C0015001C2O01000600049C3O001C2O0100264C001900162O01003B00049C3O00162O010006F7000B00162O013O00049C3O00162O012O0051001000013O00264C0019001B2O01003C00049C3O001B2O010006F7000D001B2O013O00049C3O001B2O012O0051001000013O00123A011500133O00264C001500282O01001300049C3O00282O0100264C001900232O01003D00049C3O00232O010006F7000C00232O013O00049C3O00232O012O0051001000013O000690001000422O01000100049C3O00422O012O0051001A6O0071001A00023O00049C3O00422O0100264C0015000F2O01000100049C3O000F2O010012DE001A003E4O0074001B00023O00122O001C003F3O00122O001D00406O001B001D00024O001C00146O001A001C00234O001900236O001700226O001700216O001700206O0018001F6O0017001E6O0017001D6O0017001C6O0017001B6O0016001A3O00262O001900402O01004100049C3O00402O010006F7000E00402O013O00049C3O00402O012O0051001000013O00123A011500063O00049C3O000F2O010004370111000D2O0100049C3O00452O0100049C3O00062O0100123A010500143O00049C3O0017000100049C3O00492O0100049C3O000100012O001F3O00017O001A3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E677303113O00665B600D5D4761185B627D1C4766601D4103043O00682F3514030E3O004361737450657263656E7461676503123O008A429519AE1DB65C9528B41DA65F8913B00B03063O006FC32CE17CDC030C3O0049734368612O6E656C696E6703163O00F14814762OB9CD56145CA5A7C171087ABFAED44F136703063O00CBB8266013CB030E3O0056616C75654973496E412O72617903103O005374756E57686974656C697374494473030B3O00436173745370652O6C4944030E3O004368612O6E656C5370652O6C494403163O00107D6D44DC2B666955E1377F6076C630677C4DC72A6703053O00AE59131921030C3O0043616E42655374752O6E6564030A3O0049734361737461626C6503053O005072652O73030E3O0049735370652O6C496E52616E676503053O000C13415AB703073O006B4F72322E97E703043O004E616D6503163O0079EE9C279E3CA5D22CB6A169BD30A3C87995A13C847003083O00A059C6D549EA59D704683O00123A010400013O00264C000400010001000100049C3O00010001000690000300060001000100049C3O000600012O003901035O0012DE000500023O0020400105000500034O000600013O00122O000700043O00122O000800056O0006000800024O00050005000600062O0005006700013O00049C3O006700010020880005000300062O00D500050002000200122O000600023O00202O0006000600034O000700013O00122O000800073O00122O000900086O0007000900024O00060006000700062O0006001B0001000100049C3O001B000100123A010600013O000634000600050001000500049C3O002100010020880005000300092O00200005000200020006F70005006700013O00049C3O006700010012DE000500023O0020400105000500034O000600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600062O0005003C00013O00049C3O003C00012O0039010500023O00200401050005000C4O000600033O00202O00060006000D00202O00070003000E4O000700086O00053O000200062O000500490001000100049C3O004900012O0039010500023O00200401050005000C4O000600033O00202O00060006000D00202O00070003000F4O000700086O00053O000200062O000500490001000100049C3O004900010012DE000500023O0020350005000500034O000600013O00122O000700103O00122O000800116O0006000800024O00050005000600062O000500670001000100049C3O006700010020880005000300122O00200005000200020006F70005006700013O00049C3O0067000100208800053O00132O00200005000200020006F70005006700013O00049C3O006700012O0039010500043O0020BA0005000500144O00065O00202O0007000300154O00098O0007000900024O000700076O000800086O000900026O00050009000200062O0005006700013O00049C3O006700012O0039010500013O001245000600163O00122O000700176O00050007000200202O00063O00184O0006000200024O000700013O00122O000800193O00122O0009001A6O0007000900024O0005000500074O000500023O00044O0067000100049C3O000100012O001F3O00017O001A3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E677303113O00617FA0FBD75A64A4EAF24165BCCDD15D7F03053O00A52811D49E030E3O004361737450657263656E7461676503123O00CCD71C3634F7CC182712EDCB0D202EEAD50C03053O004685B96853030C3O0049734368612O6E656C696E6703163O002D4B502FDB1650543EE60A495D1DC10D514126C0175103053O00A96425244A030E3O0056616C75654973496E412O72617903103O005374756E57686974656C697374494473030B3O00436173745370652O6C4944030E3O004368612O6E656C5370652O6C494403163O002989B6551295B74014A8AC5C19B0AA591482AE59139303043O003060E7C2030C3O0043616E42655374752O6E6564030A3O0049734361737461626C6503053O005072652O73030E3O0049735370652O6C496E52616E676503053O00EB5B1D395903083O00E3A83A6E4D79B8CF03043O004E616D6503163O003B74964EA5DE63B76E2CAB0086D265AD3B0FAB55BF9203083O00C51B5CDF20D1BB1105683O00123A010500013O00264C000500010001000100049C3O00010001000690000400060001000100049C3O000600012O003901045O0012DE000600023O0020400106000600034O000700013O00122O000800043O00122O000900056O0007000900024O00060006000700062O0006006700013O00049C3O006700010020880006000400062O00D500060002000200122O000700023O00202O0007000700034O000800013O00122O000900073O00122O000A00086O0008000A00024O00070007000800062O0007001B0001000100049C3O001B000100123A010700013O000634000700050001000600049C3O002100010020880006000400092O00200006000200020006F70006006700013O00049C3O006700010012DE000600023O0020400106000600034O000700013O00122O0008000A3O00122O0009000B6O0007000900024O00060006000700062O0006003C00013O00049C3O003C00012O0039010600023O00200401060006000C4O000700033O00202O00070007000D00202O00080004000E4O000800096O00063O000200062O000600490001000100049C3O004900012O0039010600023O00200401060006000C4O000700033O00202O00070007000D00202O00080004000F4O000800096O00063O000200062O000600490001000100049C3O004900010012DE000600023O0020350006000600034O000700013O00122O000800103O00122O000900116O0007000900024O00060006000700062O000600670001000100049C3O006700010020880006000400122O00200006000200020006F70006006700013O00049C3O0067000100208800063O00132O00200006000200020006F70006006700013O00049C3O006700012O0039010600043O0020BA0006000600144O000700013O00202O0008000400154O000A8O0008000A00024O000800086O000900096O000A00036O0006000A000200062O0006006700013O00049C3O006700012O0039010600013O001245000700163O00122O000800176O00060008000200202O00073O00184O0007000200024O000800013O00122O000900193O00122O000A001A6O0008000A00024O0006000600084O000600023O00044O0067000100049C3O000100012O001F3O00017O001A3O00028O00030F3O004973496E74652O7275707469626C65030E3O004361737450657263656E74616765030C3O004570696353652O74696E677303083O0053652O74696E677303123O002A51D7FE114DD6EB176BCBE9064CCBF40F5B03043O009B633FA3030C3O0049734368612O6E656C696E6703163O00ABDFB588AB9697C1B5A2B7889BE6A984AD818ED8B29903063O00E4E2B1C1EDD9030E3O0056616C75654973496E412O72617903153O00496E74652O7275707457686974656C697374494473030B3O00436173745370652O6C4944030E3O004368612O6E656C5370652O6C4944030A3O0049734361737461626C6503053O005072652O73030E3O0049735370652O6C496E52616E676503053O0017B130F27403043O008654D04303043O004E616D65030C3O0053E4AF5207A9944E06BC921503043O003C73CCE603053O00C43BF864A703043O0010875A8B030C3O00143C2F3D5A516A466116270703073O0018341466532E3405713O00123A010500013O000EA1000100010001000500049C3O00010001000690000300060001000100049C3O000600012O003901035O0020880006000300022O00200006000200020006F70006007000013O00049C3O007000010020880006000300032O00D500060002000200122O000700043O00202O0007000700054O000800013O00122O000900063O00122O000A00076O0008000A00024O00070007000800062O000700160001000100049C3O0016000100123A010700013O000634000700050001000600049C3O001C00010020880006000300082O00200006000200020006F70006007000013O00049C3O007000010012DE000600043O0020400106000600054O000700013O00122O000800093O00122O0009000A6O0007000900024O00060006000700062O0006003700013O00049C3O003700012O0039010600023O00200401060006000B4O000700033O00202O00070007000C00202O00080003000D4O000800096O00063O000200062O000600370001000100049C3O003700012O0039010600023O0020C700060006000B4O000700033O00202O00070007000C00202O00080003000E4O000800096O00063O000200062O0006007000013O00049C3O0070000100208800063O000F2O00200006000200020006F70006007000013O00049C3O007000010006F70004005600013O00049C3O005600012O0039010600043O0020BA0006000600104O000700043O00202O0008000300114O000A8O0008000A00024O000800086O000900096O000A00026O0006000A000200062O0006007000013O00049C3O007000012O0039010600013O001245000700123O00122O000800136O00060008000200202O00073O00144O0007000200024O000800013O00122O000900153O00122O000A00166O0008000A00024O0006000600084O000600023O00044O007000012O0039010600043O0020BA0006000600104O00075O00202O0008000300114O000A8O0008000A00024O000800086O000900096O000A00026O0006000A000200062O0006007000013O00049C3O007000012O0039010600013O001245000700173O00122O000800186O00060008000200202O00073O00144O0007000200024O000800013O00122O000900193O00122O000A001A6O0008000A00024O0006000600084O000600023O00044O0070000100049C3O000100012O001F3O00017O00163O00028O00030F3O004973496E74652O7275707469626C65030E3O004361737450657263656E74616765030C3O004570696353652O74696E677303083O0053652O74696E677303123O00ED2135211DD63A31303BCC3D243707CB232503053O006FA44F4144030C3O0049734368612O6E656C696E6703163O00EFD797DB3CF8D3C997F120E6DFEE8BD73AEFCAD090CA03063O008AA6B9E3BE4E030E3O0056616C75654973496E412O72617903153O00496E74652O7275707457686974656C697374494473030B3O00436173745370652O6C4944030E3O004368612O6E656C5370652O6C4944030A3O0049734361737461626C6503053O005072652O73030E3O0049735370652O6C496E52616E676503053O00E875D6231203073O0079AB14A557324303043O004E616D65030C3O0086709038AD07D42AAC26AD4B03063O0062A658D956D905563O00123A010500013O000EA1000100010001000500049C3O00010001000690000400060001000100049C3O000600012O003901045O0020880006000400022O00200006000200020006F70006005500013O00049C3O005500010020880006000400032O00D500060002000200122O000700043O00202O0007000700054O000800013O00122O000900063O00122O000A00076O0008000A00024O00070007000800062O000700160001000100049C3O0016000100123A010700013O000634000700050001000600049C3O001C00010020880006000400082O00200006000200020006F70006005500013O00049C3O005500010012DE000600043O0020400106000600054O000700013O00122O000800093O00122O0009000A6O0007000900024O00060006000700062O0006003700013O00049C3O003700012O0039010600023O00200401060006000B4O000700033O00202O00070007000C00202O00080004000D4O000800096O00063O000200062O000600370001000100049C3O003700012O0039010600023O0020C700060006000B4O000700033O00202O00070007000C00202O00080004000E4O000800096O00063O000200062O0006005500013O00049C3O0055000100208800063O000F2O00200006000200020006F70006005500013O00049C3O005500012O0039010600043O0020BA0006000600104O000700013O00202O0008000400114O000A8O0008000A00024O000800086O000900096O000A00036O0006000A000200062O0006005500013O00049C3O005500012O0039010600013O001245000700123O00122O000800136O00060008000200202O00073O00144O0007000200024O000800013O00122O000900153O00122O000A00166O0008000A00024O0006000600084O000600023O00044O0055000100049C3O000100012O001F3O00017O00153O00028O00030C3O004570696353652O74696E677303073O00546F2O676C657303053O00F5EF7A0D8303063O00BC2O961961E603083O0053652O74696E6773030A3O00D9905C0E09C9DF855E1B03063O008DBAE93F626C025O00407F40026O00F03F030F3O00412O66656374696E67436F6D62617403073O00497344752O6D7903053O005072652O7303043O004755494403133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C697374656403073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40030D3O004570696353652O74696E67734D026O00594008773O00123A010800014O009E0009000A3O00264C000800190001000100049C3O001900010012DE000B00023O0020B2000B000B00034O000C5O00122O000D00043O00122O000E00056O000C000E00024O000B000B000C00062O0009000E0001000B00049C3O000E00012O005100095O0012DE000B00023O0020B2000B000B00064O000C5O00122O000D00073O00122O000E00086O000C000E00024O000B000B000C00062O000A00180001000B00049C3O0018000100123A010A00093O00123A0108000A3O00264C000800020001000A00049C3O000200012O005E000B00024O0039010C00014O0020000B000200020006F7000B003200013O00049C3O003200012O0039010B00013O002088000B000B000B2O0020000B00020002000690000B002A0001000100049C3O002A00012O0039010B00013O002088000B000B000C2O0020000B000200020006F7000B003200013O00049C3O003200012O0039010B00023O002010010B000B000D4O000C8O000D00036O000E00076O000F00046O000B000F6O000B5O0006F70009007600013O00049C3O0076000100123A010B00014O009E000C000C3O00264C000B00360001000100049C3O003600012O0039010D00013O002006000D000D000E4O000D000200024O000C000D6O000D00036O000E00016O000D0002000F00044O0070000100208800120011000E2O0020001200020002000660001200700001000C00049C3O0070000100208800120011000B2O00200012000200020006900012004C0001000100049C3O004C000100208800120011000C2O00200012000200020006F70012007000013O00049C3O0070000100208800120011000F2O0020001200020002000690001200700001000100049C3O007000010020880012001100102O0020001200020002000690001200700001000100049C3O007000012O005E001200024O005E001300114O00200012000200020006F70012007000013O00049C3O007000010012DE001200114O003A0012000100024O001300043O00202O0013001300124O00120012001300202O00120012001300062O000A00700001001200049C3O0070000100123A011200013O00264C0012006B0001000100049C3O006B00012O0039011300043O001210001400116O00140001000200102O0013001200144O001300023O00302O00130014001500122O0012000A3O00264C001200620001000A00049C3O006200012O0051001300014O0071001300023O00049C3O0062000100063F010D00400001000200049C3O0040000100049C3O0076000100049C3O0036000100049C3O0076000100049C3O000200012O001F3O00017O00113O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C657303053O00F2F32FBA2003053O0045918A4CD6030F3O00412O66656374696E67436F6D62617403063O0045786973747303103O004865616C746850657263656E7461676503073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40025O00407F40030D3O004570696353652O74696E67734D026O00594003173O0043D88899AF1F7EC8C99DB0567ECA919DFF2271DD8E8CAB03063O007610AF2OE9DF00403O00123A012O00014O009E000100013O00264C3O00060001000200049C3O000600012O005100026O0071000200023O000EA10001000200013O00049C3O000200010012DE000200033O0020B20002000200044O00035O00122O000400053O00122O000500066O0003000500024O00020002000300062O000100120001000200049C3O001200012O005100015O0006F70001003D00013O00049C3O003D00012O0039010200013O0020880002000200072O00200002000200020006F70002003D00013O00049C3O003D00012O0039010200023O0020880002000200082O00200002000200020006F70002002300013O00049C3O002300012O0039010200023O0020880002000200092O00200002000200020026B50002003D0001000100049C3O003D00010012DE0002000A4O00270002000100024O000300033O00202O00030003000B4O00020002000300202O00020002000C000E2O000D003D0001000200049C3O003D000100123A010200013O00264C000200350001000100049C3O003500012O0039010300033O0012100004000A6O00040001000200102O0003000B00044O000300043O00302O0003000E000F00122O000200023O000EA10002002C0001000200049C3O002C00012O003901035O00120B000400103O00122O000500116O000300056O00035O00044O002C000100123A012O00023O00049C3O000200012O001F3O00017O00183O00028O00030C3O004570696353652O74696E677303073O00546F2O676C657303053O00889D36B7EB03073O001DEBE455DB8EEB03083O0053652O74696E6773030A3O003ECDB9D1726A225E3CCD03083O00325DB4DABD172E47025O00407F40026O00F03F027O004003133O004973466163696E67426C61636B6C697374656403163O004973557365724379636C65426C61636B6C6973746564030F3O00412O66656374696E67436F6D62617403073O00497344752O6D79030B3O00436F6D706172655468697303043O004755494403043O004361737403073O0047657454696D65030E3O004C61737454617267657453776170025O00408F40030D3O004570696353652O74696E67734D026O00594003083O0049734D6F76696E670AA03O00123A010A00014O009E000B000D3O00264C000A00190001000100049C3O001900010012DE000E00023O0020B2000E000E00034O000F5O00122O001000043O00122O001100056O000F001100024O000E000E000F00062O000B000E0001000E00049C3O000E00012O0051000B5O0012DE000E00023O0020B2000E000E00064O000F5O00122O001000073O00122O001100086O000F001100024O000E000E000F00062O000C00180001000E00049C3O0018000100123A010C00093O00123A010A000A3O00264C000A00870001000B00049C3O008700010006F7000B007C00013O00049C3O007C000100123A010E00014O009E000F00103O00264C000E004D0001000100049C3O004D00012O009E001100114O009B001000106O000F00116O001100016O001200016O00110002001300044O004A000100208800160015000C2O00200016000200020006900016004A0001000100049C3O004A000100208800160015000D2O00200016000200020006900016004A0001000100049C3O004A000100208800160015000E2O0020001600020002000690001600380001000100049C3O0038000100208800160015000F2O00200016000200020006F70016004A00013O00049C3O004A00010006F70010004400013O00049C3O004400012O0039011600023O0020F50016001600104O001700026O001800036O001900156O0018000200024O001900106O00160019000200062O0016004A00013O00049C3O004A00012O005E001600154O006E001700036O001800156O0017000200024O001000176O000F00163O00063F011100280001000200049C3O0028000100123A010E000A3O000EA1000A001F0001000E00049C3O001F00010006F7000F007C00013O00049C3O007C00010020880011000F00112O00440011000200024O001200033O00202O0012001200114O00120002000200062O001100630001001200049C3O006300010006F7000D006300013O00049C3O006300012O0039011100043O0020100111001100124O00128O001300066O001400076O001500056O001100156O00115O00049C3O007C00010012DE001100134O003A0011000100024O001200053O00202O0012001200144O00110011001200202O00110011001500062O000C007C0001001100049C3O007C000100123A011100013O00264C001100700001000A00049C3O007000012O0051001200014O0071001200023O00264C0011006C0001000100049C3O006C00012O0039011200053O001210001300136O00130001000200102O0012001400134O001200043O00302O00120016001700122O0011000A3O00049C3O006C000100049C3O007C000100049C3O001F00010006F7000D009F00013O00049C3O009F00012O0039010E00043O002010010E000E00124O000F8O001000066O001100076O001200056O000E00126O000E5O00049C3O009F000100264C000A00020001000A00049C3O000200010006F70004009300013O00049C3O0093000100061C010D00940001000400049C3O009400012O005E000E00044O0039010F00034O0020000E000200022O005E000D000E3O00049C3O009400012O004E000D6O0051000D00013O0006F70009009D00013O00049C3O009D00012O0039010E00063O002088000E000E00182O0020000E000200020006F7000E009D00013O00049C3O009D00012O0051000E6O0071000E00023O00123A010A000B3O00049C3O000200012O001F3O00017O00043O00030E3O0056616C75654973496E412O726179030B3O004D69746967617465494473030B3O00436173745370652O6C4944030E3O004368612O6E656C5370652O6C494400144O0039016O00201E5O00014O000100013O00202O0001000100024O000200023O00202O0002000200034O000200039O0000020006903O00120001000100049C3O001200012O0039016O00201E5O00014O000100013O00202O0001000100024O000200023O00202O0002000200044O000200039O0000022O00713O00024O001F3O00017O00043O00028O00026O00F03F03173O0044697370652O6C61626C654D6167696342752O6649447303063O0042752O66557001183O00123A2O0100013O000EA1000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00043O00028O00026O00F03F03183O0044697370652O6C61626C65456E7261676542752O6649447303063O0042752O66557001183O00123A2O0100013O00264C000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00043O00028O00026O00F03F03173O0044697370652O6C61626C654375727365446562752O667303083O00446562752O66557001183O00123A2O0100013O00264C000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00043O00028O00026O00F03F03173O0044697370652O6C61626C654D61676963446562752O667303083O00446562752O66557001183O00123A2O0100013O00264C000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00043O00028O00026O00F03F03193O0044697370652O6C61626C6544697365617365446562752O667303083O00446562752O66557001183O00123A2O0100013O00264C000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00043O00028O00026O00F03F03183O0044697370652O6C61626C65506F69736F6E446562752O667303083O00446562752O66557001183O00123A2O0100013O000EA1000100010001000100049C3O0001000100123A010200024O002301035O00202O0003000300034O000300033O00122O000400023O00042O00020014000100208800063O00042O007C00085O00202O0008000800034O0008000800054O000900016O00060009000200062O0006001300013O00049C3O001300012O0051000600014O0071000600023O0004370102000900012O005100026O0071000200023O00049C3O000100012O001F3O00017O00033O00028O00026O00F03F03083O00446562752O66557002143O00123A010200013O00264C000200010001000100049C3O0001000100123A010300024O00FF000400013O00123A010500023O00045B00030010000100208800073O00032O00EF0009000100062O0051000A00014O006B0007000A00020006F70007000F00013O00049C3O000F00012O0051000700014O0071000700023O0004370103000700012O005100036O0071000300023O00049C3O000100012O001F3O00017O00023O0003083O004973496E5261696403093O004973496E5061727479000E4O0039016O0020885O00012O00203O000200020006903O000A0001000100049C3O000A00012O0039016O0020885O00022O00203O000200022O007F7O00049C3O000C00012O004E8O00513O00014O00713O00024O001F3O00017O000C3O00028O00026O003E40026O00F03F027O0040030A3O004973536F6C6F4D6F646503093O004973496E506172747903083O004973496E52616964026O00104003073O00CEA549585D994C03073O0028BEC43B2C24BC03063O002E44D5B0BF7903073O006D5C25BCD49A1D02753O00123A010200014O009E000300033O00264C0002000A0001000100049C3O000A00012O00F400046O00F600045O000624010300090001000100049C3O0009000100123A010300023O00123A010200033O00264C0002002C0001000400049C3O002C00012O0039010400013O0020650004000400052O001A0004000100020006F70004001600013O00049C3O001600012O00F4000400014O0039010500024O00EC0004000100012O0071000400023O00049C3O002A00012O0039010400023O0020880004000400062O00200004000200020006F70004002300013O00049C3O002300012O0039010400023O0020880004000400072O0020000400020002000690000400230001000100049C3O002300012O003901046O0071000400023O00049C3O002A00012O0039010400023O0020880004000400072O00200004000200020006F70004002A00013O00049C3O002A00012O0039010400034O0071000400024O00F400046O0071000400023O00264C000200020001000300049C3O000200012O003901046O00FF000400043O00264C000400560001000100049C3O0056000100123A010400013O000EA1000100330001000400049C3O003300010006F73O003800013O00049C3O0038000100049C3O003C00012O0039010500044O003901066O0039010700024O009100050007000100123A010500033O00123A010600083O00123A010700033O00045B00050054000100123A010900014O009E000A000A3O00264C000900420001000100049C3O004200012O0039010B00054O0085000C00063O00122O000D00093O00122O000E000A6O000C000E00024O000D00086O000B000D00024O000A000B6O000B00046O000C8O000D00076O000D000D000A4O000B000D000100044O0053000100049C3O0042000100043701050040000100049C3O0056000100049C3O003300012O0039010400034O00FF000400043O00264C000400720001000100049C3O0072000100123A010400034O005E000500033O00123A010600033O00045B00040072000100123A010800014O009E000900093O000EA1000100600001000800049C3O006000012O0039010A00054O0085000B00063O00122O000C000B3O00122O000D000C6O000B000D00024O000C00076O000A000C00024O0009000A6O000A00046O000B00036O000C00086O000C000C00094O000A000C000100044O0071000100049C3O006000010004370104005E000100123A010200043O00049C3O000200012O001F3O00017O00063O00028O0003183O0044697370652O6C61626C65467269656E646C79556E697473026O00F03F030D3O00556E697447726F7570526F6C6503043O0030CE8AE803063O003A648FC4A351012A3O00123A2O0100014O009E000200033O00264C0001000B0001000100049C3O000B00012O003901045O00201D0104000400024O00058O0004000200024O000200046O000300023O00122O000100033O000EA1000300020001000100049C3O00020001000EF3000100290001000300049C3O0029000100123A010400013O000EA1000100100001000400049C3O0010000100123A010500034O005E000600033O00123A010700033O00045B0005002400012O00EF0009000200082O00E5000A5O00202O000A000A00044O000B00096O000A000200024O000A000A6O000B00013O00122O000C00053O00122O000D00066O000B000D000200062O000A00230001000B00049C3O002300012O0071000900023O0004370105001600010020650005000200032O0071000500023O00049C3O0010000100049C3O0029000100049C3O000200012O001F3O00017O00053O00028O00030D3O00467269656E646C79556E697473026O00F03F03123O0044697370652O6C61626C65446562752O667303083O00446562752O66557001303O00123A2O0100014O009E000200033O00264C0001000C0001000100049C3O000C00012O003901045O0020E20004000400024O00058O0004000200024O000200046O00048O000300043O00122O000100033O00264C000100020001000300049C3O0002000100123A010400034O00FF000500023O00123A010600033O00045B0004002D000100123A010800014O009E000900093O00264C000800140001000100049C3O001400012O00EF0009000200070012D2000A00036O000B5O00202O000B000B00044O000B000B3O00122O000C00033O00042O000A002A0001002088000E000900052O007C00105O00202O0010001000044O00100010000D4O001100016O000E0011000200062O000E002900013O00049C3O002900012O0039010E00014O005E000F00034O005E001000094O0091000E00100001000437010A001D000100049C3O002C000100049C3O001400010004370104001200012O0071000300023O00049C3O000200012O001F3O00017O00033O0003093O00497341506C6179657203163O00556E697447726F7570526F6C6573412O7369676E656403023O004944010A3O00208800013O00012O00200001000200020006F70001000900013O00049C3O000900010012DE000100023O00208800023O00032O0013010200034O001F2O016O00EA00016O001F3O00017O00063O00028O0003063O00457869737473030D3O004973446561644F7247686F7374026O00F03F03123O004D696E64436F6E74726F2O6C5370652O6C7303083O00446562752O66557001223O00123A2O0100013O00264C000100010001000100049C3O000100010006F73O001E00013O00049C3O001E000100208800023O00022O00200002000200020006F70002001E00013O00049C3O001E000100208800023O00032O00200002000200020006900002001E0001000100049C3O001E000100123A010200044O002301035O00202O0003000300054O000300033O00122O000400043O00042O0002001E000100208800063O00062O007C00085O00202O0008000800054O0008000800054O000900016O00060009000200062O0006001D00013O00049C3O001D00012O0051000600014O0071000600023O0004370102001300012O005100026O0071000200023O00049C3O000100012O001F3O00017O00093O00028O00026O004440026O00F03F030D3O00467269656E646C79556E69747303063O00457869737473030D3O004973446561644F7247686F737403103O0049734D696E64436F6E74726F2O6C656403043O004E616D65027O004003323O00123A010300014O009E000400053O00264C000300090001000100049C3O000900010006903O00070001000100049C3O0007000100123A012O00024O009E000400043O00123A010300033O00264C0003002D0001000300049C3O002D00012O003901065O0020C00006000600044O00078O000800026O0006000800024O000500063O00122O000600036O000700053O00122O000800033O00042O0006002C00012O00EF000A000500090006F7000A002B00013O00049C3O002B0001002088000B000A00052O0020000B000200020006F7000B002B00013O00049C3O002B0001002088000B000A00062O0020000B00020002000690000B002B0001000100049C3O002B00012O0039010B5O002065000B000B00072O005E000C000A4O0020000B00020002000690000B002B0001000100049C3O002B0001002088000B000A00082O0020000B00020002000650000B002B0001000100049C3O002B00012O005E0004000A3O00043701060015000100123A010300093O00264C000300020001000900049C3O000200012O0071000400023O00049C3O000200012O001F3O00017O000B3O00028O00026O004440026O00F03F027O0040030D3O00467269656E646C79556E69747300030D3O00556E697447726F7570526F6C6503063O00457869737473030D3O004973446561644F7247686F737403103O0049734D696E64436F6E74726F2O6C656403103O004865616C746850657263656E74616765033E3O00123A010300014O009E000400053O00264C000300090001000100049C3O000900010006903O00070001000100049C3O0007000100123A012O00024O009E000400043O00123A010300033O00264C0003000C0001000400049C3O000C00012O0071000400023O00264C000300020001000300049C3O000200012O003901065O0020C00006000600054O00078O000800026O0006000800024O000500063O00122O000600036O000700053O00122O000800033O00042O0006003B00012O00EF000A0005000900263C2O0100210001000600049C3O002100012O0039010B5O002065000B000B00072O005E000C000A4O0020000B00020002000650000B003A0001000100049C3O003A00010006F7000A003A00013O00049C3O003A0001002088000B000A00082O0020000B000200020006F7000B003A00013O00049C3O003A0001002088000B000A00092O0020000B00020002000690000B003A0001000100049C3O003A00012O0039010B5O002065000B000B000A2O005E000C000A4O0020000B00020002000690000B003A0001000100049C3O003A00010006F70004003900013O00049C3O00390001002088000B000A000B2O0020000B00020002002088000C0004000B2O0020000C00020002000622000B003A0001000C00049C3O003A00012O005E0004000A3O00043701060018000100123A010300043O00049C3O000200012O001F3O00017O000D3O00028O00026O004440026O00F03F027O0040030D3O00467269656E646C79556E69747300030D3O00556E697447726F7570526F6C6503083O0042752O66446F776E030B3O0042752O6652656D61696E7303063O00457869737473030D3O004973446561644F7247686F737403103O0049734D696E64436F6E74726F2O6C656403103O004865616C746850657263656E7461676506483O00123A010600014O009E000700083O000EA1000100090001000600049C3O00090001000690000200070001000100049C3O0007000100123A010200024O009E000700073O00123A010600033O00264C0006000C0001000400049C3O000C00012O0071000700023O00264C000600020001000300049C3O000200012O003901095O0020C00009000900054O000A8O000B00056O0009000B00024O000800093O00122O000900036O000A00083O00122O000B00033O00042O0009004500012O00EF000D0008000C00263C010300210001000600049C3O002100012O0039010E5O002065000E000E00072O005E000F000D4O0020000E00020002000650000E00440001000300049C3O004400010006F7000D004400013O00049C3O00440001002088000E000D00082O005E00106O006B000E00100002000690000E002D0001000100049C3O002D0001002088000E000D00092O005E00106O006B000E00100002000622000E00440001000100049C3O00440001002088000E000D000A2O0020000E000200020006F7000E004400013O00049C3O00440001002088000E000D000B2O0020000E00020002000690000E00440001000100049C3O004400012O0039010E5O002065000E000E000C2O005E000F000D4O0020000E00020002000690000E00440001000100049C3O004400010006F70007004300013O00049C3O00430001002088000E000D000D2O0020000E00020002002088000F0007000D2O0020000F00020002000622000E00440001000F00049C3O004400012O005E0007000D3O00043701090018000100123A010600043O00049C3O000200012O001F3O00017O00083O00028O00027O0040026O00F03F030D3O00467269656E646C79556E69747303063O00457869737473030D3O004973446561644F7247686F737403103O004865616C746850657263656E74616765026O004440032B3O00123A010300014O009E000400053O00264C000300050001000200049C3O000500012O0071000400023O00264C000300220001000300049C3O002200012O003901065O0020C00006000600044O00078O000800016O0006000800024O000500063O00122O000600036O000700053O00122O000800033O00042O0006002100012O00EF000A00050009002088000B000A00052O0020000B000200020006F7000B002000013O00049C3O00200001002088000B000A00062O0020000B00020002000690000B00200001000100049C3O00200001002088000B000A00072O0020000B00020002000630000B002000013O00049C3O002000010020F9000B000400030020F90004000B000100043701060011000100123A010300023O00264C000300020001000100049C3O00020001000690000200270001000100049C3O0027000100123A010200083O00123A010400013O00123A010300033O00049C3O000200012O001F3O00017O00073O00028O00027O004003093O004E616D6564556E697403083O0042752O66446F776E030B3O0042752O6652656D61696E73026O00F03F026O00444003423O00123A010400014O009E000500073O00264C000400300001000200049C3O003000012O003901086O005E000900054O002E01080002000A00049C3O002D000100123A010D00014O009E000E000E3O00264C000D000A0001000100049C3O000A00012O0039010F00013O0020CB000F000F00034O001000026O0011000C6O000F001100024O000E000F3O00062O000E002D00013O00049C3O002D0001002088000F000E00042O005E00116O006B000F00110002000690000F001E0001000100049C3O001E0001002088000F000E00052O005E00116O006B000F00110002000622000F002D0001000100049C3O002D000100123A010F00013O00264C000F001F0001000100049C3O001F00012O0039011000013O0020040010001000034O001100026O0012000C6O0010001200024O00060007001000202O00100007000600202O00070010000100044O002D000100049C3O001F000100049C3O002D000100049C3O000A000100063F010800080001000200049C3O000800012O0071000600023O00264C000400360001000600049C3O003600012O00F400086O005E000600083O00123A010700063O00123A010400023O00264C000400020001000100049C3O000200012O00F400086O00ED00096O006700083O00012O005E000500083O0006900002003F0001000100049C3O003F000100123A010200073O00123A010400063O00049C3O000200012O001F3O00017O000C3O00028O00026O00F03F03063O00457869737473030D3O004973446561644F7247686F7374030D3O00556E697447726F7570526F6C6503043O002E630D8803083O006E7A2243C35F298503043O004190756103053O00B615D13B2A03063O0042752O665570030F3O0042752O665265667265736861626C65030D3O00467269656E646C79556E69747304423O00123A010400014O009E000500063O00264C000400360001000200049C3O0036000100123A010700024O00FF000800063O00123A010900023O00045B0007003500012O00EF000B0006000A002088000C000B00032O0020000C000200020006F7000C003400013O00049C3O00340001002088000C000B00042O0020000C00020002000690000C00340001000100049C3O003400010006F70001001D00013O00049C3O001D00012O0039010C5O002012000C000C00054O000D000B6O000C000200024O000D00013O00122O000E00063O00122O000F00076O000D000F000200062O000C00340001000D00049C3O003400010006F70002002900013O00049C3O002900012O0039010C5O0020A3000C000C00054O000D000B6O000C000200024O000D00013O00122O000E00083O00122O000F00096O000D000F000200062O000C00340001000D00049C3O00340001002088000C000B000A2O005E000E6O006B000C000E00020006F7000C003400013O00049C3O00340001002088000C000B000B2O005E000E6O006B000C000E0002000690000C00340001000100049C3O003400010020F90005000500020004370107000800012O0071000500023O00264C000400020001000100049C3O0002000100123A010500014O00B300075O00202O00070007000C4O00088O000900036O0007000900024O000600073O00122O000400023O00044O000200012O001F3O00017O00083O00028O00026O004440026O00F03F030D3O00467269656E646C79556E697473027O004003063O00457869737473030D3O004973446561644F7247686F737403153O00556E6974486173446562752O6646726F6D4C69737403373O00123A010300014O009E000400063O00264C0003000A0001000100049C3O000A00012O00F400076O005E000400073O000690000100090001000100049C3O0009000100123A2O0100023O00123A010300033O000EA1000300140001000300049C3O001400012O003901075O00203C0007000700044O00088O000900026O0007000900024O000500073O00122O000600033O00122O000300053O00264C000300020001000500049C3O0002000100123A010700034O00FF000800053O00123A010900033O00045B0007003400012O00EF000B0005000A002088000C000B00062O0020000C000200020006F7000C003300013O00049C3O00330001002088000C000B00072O0020000C00020002000690000C00330001000100049C3O003300012O0039010C5O0020C2000C000C00084O000D000B6O000E8O000C000E000200062O000C003300013O00049C3O0033000100123A010C00013O000EA10001002B0001000C00049C3O002B00012O00EF000D0005000A2O00AF00040006000D0020F9000D000600030020F90006000D000100049C3O0033000100049C3O002B00010004370107001A00012O0071000400023O00049C3O000200012O001F3O00017O000D3O00028O00030D3O00467269656E646C79556E697473026O00F03F03063O0045786973747303103O004865616C746850657263656E74616765030D3O004973446561644F7247686F7374030D3O00556E697447726F7570526F6C6503043O008376EB3603063O00DED737A57D4103043O0018F0E83103083O002A4CB1A67A92A18D03063O0042752O665570030F3O0042752O665265667265736861626C6505463O00123A010500014O009E000600073O00264C0005000C0001000100049C3O000C000100123A010600014O004300085O00202O0008000800024O00098O000A00046O0008000A00024O000700083O00122O000500033O00264C000500020001000300049C3O0002000100123A010800034O00FF000900073O00123A010A00033O00045B0008004300012O00EF000C0007000B002088000D000C00042O0020000D000200020006F7000D004200013O00049C3O00420001002088000D000C00052O0020000D00020002000630000D00420001000100049C3O00420001002088000D000C00062O0020000D00020002000690000D00420001000100049C3O004200010006F70002002B00013O00049C3O002B00012O0039010D5O002012000D000D00074O000E000C6O000D000200024O000E00013O00122O000F00083O00122O001000096O000E0010000200062O000D00420001000E00049C3O004200010006F70003003700013O00049C3O003700012O0039010D5O0020A3000D000D00074O000E000C6O000D000200024O000E00013O00122O000F000A3O00122O0010000B6O000E0010000200062O000D00420001000E00049C3O00420001002088000D000C000C2O005E000F6O006B000D000F00020006F7000D004200013O00049C3O00420001002088000D000C000D2O005E000F6O006B000D000F0002000690000D00420001000100049C3O004200010020F90006000600030004370108001200012O0071000600023O00049C3O000200012O001F3O00017O000C3O00028O00026O00F03F03063O00457869737473030D3O004973446561644F7247686F7374030D3O00556E697447726F7570526F6C6503043O0091AB2BE503063O0016C5EA65AE1903043O0019158BF703083O00E64D54C5BC16CFB703063O0042752O665570030F3O0042752O665265667265736861626C65030D3O00467269656E646C79556E69747304423O00123A010400014O009E000500063O00264C000400360001000200049C3O0036000100123A010700024O00FF000800053O00123A010900023O00045B0007003500012O00EF000B0005000A002088000C000B00032O0020000C000200020006F7000C003400013O00049C3O00340001002088000C000B00042O0020000C00020002000690000C00340001000100049C3O003400010006F70001001D00013O00049C3O001D00012O0039010C5O002012000C000C00054O000D000B6O000C000200024O000D00013O00122O000E00063O00122O000F00076O000D000F000200062O000C00340001000D00049C3O003400010006F70002002900013O00049C3O002900012O0039010C5O0020A3000C000C00054O000D000B6O000C000200024O000D00013O00122O000E00083O00122O000F00096O000D000F000200062O000C00340001000D00049C3O00340001002088000C000B000A2O005E000E6O006B000C000E00020006F7000C003400013O00049C3O00340001002088000C000B000B2O005E000E6O006B000C000E0002000690000C00340001000100049C3O0034000100203E0006000600020004370107000800012O0071000600023O000EA1000100020001000400049C3O000200012O003901075O00204000070007000C4O00088O000900036O0007000900024O000500076O000600053O00122O000400023O00044O000200012O001F3O00017O000D3O00028O00026O00F03F03063O0045786973747303103O004865616C746850657263656E74616765030D3O004973446561644F7247686F7374030D3O00556E697447726F7570526F6C6503043O00CD35E8D703083O00559974A69CECC19003043O0090C1639803063O0060C4802DD38403063O0042752O665570030F3O0042752O665265667265736861626C65030D3O00467269656E646C79556E69747305463O00123A010500014O009E000600073O000EA10002003A0001000500049C3O003A000100123A010800024O00FF000900063O00123A010A00023O00045B0008003900012O00EF000C0006000B002088000D000C00032O0020000D000200020006F7000D003800013O00049C3O00380001002088000D000C00042O0020000D00020002000630000D00380001000100049C3O00380001002088000D000C00052O0020000D00020002000690000D00380001000100049C3O003800010006F70002002100013O00049C3O002100012O0039010D5O002012000D000D00064O000E000C6O000D000200024O000E00013O00122O000F00073O00122O001000086O000E0010000200062O000D00380001000E00049C3O003800010006F70003002D00013O00049C3O002D00012O0039010D5O0020A3000D000D00064O000E000C6O000D000200024O000E00013O00122O000F00093O00122O0010000A6O000E0010000200062O000D00380001000E00049C3O00380001002088000D000C000B2O005E000F6O006B000D000F00020006F7000D003800013O00049C3O00380001002088000D000C000C2O005E000F6O006B000D000F0002000690000D00380001000100049C3O0038000100203E0007000700020004370108000800012O0071000700023O00264C000500020001000100049C3O000200012O003901085O00204000080008000D4O00098O000A00046O0008000A00024O000600086O000700063O00122O000500023O00044O000200012O001F3O00017O00043O00028O00026O00F03F030D3O004973446561644F7247686F7374030D3O00467269656E646C79556E697473001A3O00123A012O00014O009E000100023O00264C3O00100001000200049C3O0010000100123A010300024O00FF000400023O00123A010500023O00045B0003000F00012O00EF0007000200060020880008000700032O00200008000200020006F70008000E00013O00049C3O000E00010020F90001000100020004370103000800012O0071000100023O00264C3O00020001000100049C3O0002000100123A2O0100014O001C00035O00202O0003000300044O0003000100024O000200033O00124O00023O00044O000200012O001F3O00017O00293O00028O00025O00407F40026O004440026O00F03F0003063O0045786973747303043O004755494403053O001382784AC103083O00B855ED1B3FB2CFD4030E3O00552O70657243617365466972737403023O00494403073O0047657454696D65030D3O004C617374466F63757353776170025O00408F4003063O00185508460D4B03043O003F683969030B3O0052657475726E466F637573026O00494003183O00288FA54A0C8EAA434BA1AB471E94E45004C7B4480A9EA15603043O00246BE7C403063O0069B4B08058A103043O00E73DD5C2026O004E4003183O002AA53C7D0EA43374498B32701CBE7D6706ED29721BAA386703043O001369CD5D03063O00737472696E6703043O0066696E6403053O009909CC952603053O005FC968BEE103083O00746F6E756D6265722O033O00737562026O00184003173O008CC32OC0A8C2CFC9EFEDCECDBAD881DAA08BD1CFBDDFD803043O00AECFABA103043O00DFFF04F703063O00B78D9E6D9398026O00144003163O000F01E7022B00E80B6C2FE90F391AA6182349F40D250D03043O006C4C6986030E3O00C8CDB0EFC9E2CBB6A1E8E4C6A4F203053O00AE8BA5D18102C43O00123A010200014O009E000300033O00264C000200090001000100049C3O0009000100123A010300023O000690000100080001000100049C3O0008000100123A2O0100033O00123A010200043O00264C000200020001000400049C3O0002000100263C012O00B90001000500049C3O00B900012O003901045O00263C0104001C0001000500049C3O001C00012O003901045O0020880004000400062O00200004000200020006F70004001C00013O00049C3O001C000100208800043O00072O000E0004000200024O00055O00202O0005000500074O00050002000200062O000400B90001000500049C3O00B9000100123A010400014O009E000500053O00264C0004001E0001000100049C3O001E00012O0039010600013O0012D3000700083O00122O000800096O0006000800024O000700023O00202O00070007000A00202O00083O000B4O000800096O00073O00024O00050006000700122O0006000C6O0006000100024O000700033O00202O00070007000D4O00060006000700202O00060006000E00062O000300C30001000600049C3O00C3000100123A010600013O00264C000600AE0001000100049C3O00AE00012O0039010700033O0012D40008000C6O00080001000200102O0007000D000800202O00073O000B4O0007000200024O000800013O00122O0009000F3O00122O000A00106O0008000A000200062O0007004D0001000800049C3O004D000100123A010700013O000EA1000100420001000700049C3O004200012O0039010800043O0030490008001100124O000800013O00122O000900133O00122O000A00146O0008000A6O00085O00044O0042000100049C3O00AD000100208800073O000B2O00B80007000200024O000800013O00122O000900153O00122O000A00166O0008000A000200062O000700610001000800049C3O0061000100123A010700013O00264C000700560001000100049C3O005600012O0039010800043O0030490008001100174O000800013O00122O000900183O00122O000A00196O0008000A6O00085O00044O0056000100049C3O00AD00010012DE0007001A3O0020D900070007001B00202O00083O000B4O0008000200024O000900013O00122O000A001C3O00122O000B001D6O0009000B6O00073O000200062O0007008A00013O00049C3O008A000100123A010700013O000EA10001006D0001000700049C3O006D00012O0039010800043O002O120109001E3O00122O000A001A3O00202O000A000A001F00202O000B3O000B4O000B0002000200122O000C00206O000A000C6O00093O000200102O00090012000900102O0008001100094O000800013O00122O000900213O00122O000A00226O0008000A000200122O0009001E3O00122O000A001A3O00202O000A000A001F00202O000B3O000B4O000B0002000200122O000C00206O000A000C6O00093O00024O0008000800094O000800023O00044O006D000100049C3O00AD00010012DE0007001A3O0020D900070007001B00202O00083O000B4O0008000200024O000900013O00122O000A00233O00122O000B00246O0009000B6O00073O000200062O000700AD00013O00049C3O00AD000100123A010700013O00264C000700960001000100049C3O009600012O0039010800043O0012E30009001A3O00202O00090009001F00202O000A3O000B4O000A0002000200122O000B00256O0009000B000200102O0008001100094O000800013O00122O000900263O00122O000A00276O0008000A000200122O0009001A3O00202O00090009001F00202O000A3O000B4O000A0002000200122O000B00256O0009000B00024O0008000800094O000800023O00044O0096000100123A010600043O00264C000600330001000400049C3O003300012O0039010700013O00120B000800283O00122O000900296O000700096O00075O00044O0033000100049C3O00C3000100049C3O001E000100049C3O00C3000100123A010400013O000EA1000100BA0001000400049C3O00BA00012O0039010500043O0030200105001100012O005100056O0071000500023O00049C3O00BA000100049C3O00C3000100049C3O000200012O001F3O00017O002B3O00028O00025O00407F40026O004440026O00F03F031F3O00467269656E646C79556E69747357697468446562752O6646726F6D4C697374027O00400003063O0045786973747303043O004755494403053O0085BCE1D4D503083O0018C3D382A1A66310030E3O00552O70657243617365466972737403023O00494403073O0047657454696D65030D3O004C617374466F63757353776170025O00408F40030E3O00650BE822541F4804A90A5C15531003063O00762663894C3303063O00ED2A040B0C3203063O00409D46657269030B3O0052657475726E466F637573026O00494003183O0063A0A6ED1749A6A0A3364FABB2F05054A7E7F31C41B1A2F103053O007020C8C78303063O0018514EBFC6BF03073O00424C303CD8A3CB026O004E4003183O00998E78FD58C72ABDC65FFC5CDB37FA9276B34BCF36BD836D03073O0044DAE619933FAE03063O00737472696E6703043O0066696E6403053O009D2B4158AF03053O00D6CD4A332C03083O00746F6E756D6265722O033O00737562026O00184003173O00D944E3F270F342E5BC51F54FF7EF37EE43A2EC76E858FB03053O00179A2C829C03043O0023A7A4AA03063O007371C6CDCE56026O00144003163O00A75FFF54835EF05DC471F1599144BE4E8B17EC5B8D5303043O003AE4379E03D73O00123A010300014O009E000400053O00264C000300090001000100049C3O0009000100123A010400023O000690000100080001000100049C3O0008000100123A2O0100033O00123A010300043O00264C0003001C0001000400049C3O001C00012O009E000500054O00F100065O00202O0006000600054O00078O000800016O000900026O00060009000200062O0006001B00013O00049C3O001B00012O003901065O0020230006000600054O00078O000800016O000900026O00060009000200202O00050006000400123A010300063O00264C000300020001000600049C3O0002000100263C010500CC0001000700049C3O00CC00012O0039010600013O00263C0106002F0001000700049C3O002F00012O0039010600013O0020880006000600082O00200006000200020006F70006002F00013O00049C3O002F00010020880006000500092O000E0006000200024O000700013O00202O0007000700094O00070002000200062O000600CC0001000700049C3O00CC000100123A010600014O009E000700073O00264C000600310001000100049C3O003100012O0039010800023O0012D30009000A3O00122O000A000B6O0008000A00024O000900033O00202O00090009000C00202O000A0005000D4O000A000B6O00093O00024O00070008000900122O0008000E6O0008000100024O00095O00202O00090009000F4O00080008000900202O00080008001000062O000400D60001000800049C3O00D6000100123A010800013O00264C0008004D0001000400049C3O004D00012O0039010900023O00123A010A00113O00123A010B00124O008B0009000B4O00EA00095O000EA1000100460001000800049C3O004600012O003901095O0012D4000A000E6O000A0001000200102O0009000F000A00202O00090005000D4O0009000200024O000A00023O00122O000B00133O00122O000C00146O000A000C000200062O000900670001000A00049C3O0067000100123A010900013O00264C0009005C0001000100049C3O005C00012O0039010A00043O003049000A001500164O000A00023O00122O000B00173O00122O000C00186O000A000C6O000A5O00044O005C000100049C3O00C7000100208800090005000D2O00B80009000200024O000A00023O00122O000B00193O00122O000C001A6O000A000C000200062O0009007B0001000A00049C3O007B000100123A010900013O00264C000900700001000100049C3O007000012O0039010A00043O003049000A0015001B4O000A00023O00122O000B001C3O00122O000C001D6O000A000C6O000A5O00044O0070000100049C3O00C700010012DE0009001E3O0020D900090009001F00202O000A0005000D4O000A000200024O000B00023O00122O000C00203O00122O000D00216O000B000D6O00093O000200062O000900A400013O00049C3O00A4000100123A010900013O00264C000900870001000100049C3O008700012O0039010A00043O002O12010B00223O00122O000C001E3O00202O000C000C002300202O000D0005000D4O000D0002000200122O000E00246O000C000E6O000B3O000200102O000B0016000B00102O000A0015000B4O000A00023O00122O000B00253O00122O000C00266O000A000C000200122O000B00223O00122O000C001E3O00202O000C000C002300202O000D0005000D4O000D0002000200122O000E00246O000C000E6O000B3O00024O000A000A000B4O000A00023O00044O0087000100049C3O00C700010012DE0009001E3O0020D900090009001F00202O000A0005000D4O000A000200024O000B00023O00122O000C00273O00122O000D00286O000B000D6O00093O000200062O000900C700013O00049C3O00C7000100123A010900013O00264C000900B00001000100049C3O00B000012O0039010A00043O0012E3000B001E3O00202O000B000B002300202O000C0005000D4O000C0002000200122O000D00296O000B000D000200102O000A0015000B4O000A00023O00122O000B002A3O00122O000C002B6O000A000C000200122O000B001E3O00202O000B000B002300202O000C0005000D4O000C0002000200122O000D00296O000B000D00024O000A000A000B4O000A00023O00044O00B0000100123A010800043O00049C3O0046000100049C3O00D6000100049C3O0031000100049C3O00D6000100123A010600013O00264C000600CD0001000100049C3O00CD00012O0039010700043O0030200107001500012O005100076O0071000700023O00049C3O00CD000100049C3O00D6000100049C3O000200012O001F3O00017O00083O00028O00027O004003123O004C6F77657374467269656E646C79556E6974026O00F03F030A3O004973536F6C6F4D6F646503173O0044697370652O6C61626C65467269656E646C79556E6974026O00444003183O00546172676574497356616C69644865616C61626C654E706304383O00123A010400014O009E000500053O00264C0004000F0001000200049C3O000F00012O003901065O0020F80006000600034O000700016O000800026O000900036O0006000900024O000500063O00062O0005003700013O00049C3O003700012O0071000500023O00049C3O0037000100264C000400290001000400049C3O002900012O003901065O0020650006000600052O001A0006000100020006F70006001800013O00049C3O001800012O0039010600014O0071000600023O0006F73O002800013O00049C3O0028000100123A010600014O009E000700073O000EA10001001C0001000600049C3O001C00012O003901085O0020840008000800064O000900036O0008000200024O000700083O00062O0007002800013O00049C3O002800012O0071000700023O00049C3O0028000100049C3O001C000100123A010400023O00264C000400020001000100049C3O000200010006900001002E0001000100049C3O002E000100123A2O0100074O003901065O0020650006000600082O001A0006000100020006F70006003500013O00049C3O003500012O0039010600024O0071000600023O00123A010400043O00049C3O000200012O001F3O00017O002A3O00028O00025O00407F40026O004440026O00F03F030C3O00476574466F637573556E69740003063O0045786973747303043O004755494403053O009286D33B2F03073O0055D4E9B04E5CCD030E3O00552O70657243617365466972737403023O00494403073O0047657454696D65030D3O004C617374466F63757353776170025O00408F4003063O005A5489FB4F4A03043O00822A38E8030B3O0052657475726E466F637573026O00494003183O00C9BD25ED4736E4B264C54F3CFFA664F74F7FFAB925FA452D03063O005F8AD544832003063O001E29B344733E03053O00164A48C123026O004E4003183O000F71E5562B70EA5F6C5FEB5B396AA44C2339F0593E7EE14C03043O00384C198403063O00737472696E6703043O0066696E6403053O006EC0B932D603053O00AF3EA1CB4603083O00746F6E756D6265722O033O00737562026O00184003173O001FD5C21D3235D3C4531333DED6007528D28303342EC9DA03053O00555CBDA37303043O001BAD393C03043O005849CC50026O00144003163O000D8B11482ED32084506026D93B905052269A3C82194203063O00BA4EE3702649030E3O00DF5FFC5B5473F250BD735C79E94403063O001A9C379D353305CC3O00123A010500014O009E000600073O00264C000500090001000100049C3O0009000100123A010600023O000690000200080001000100049C3O0008000100123A010200033O00123A010500043O00264C000500020001000400049C3O000200012O003901085O00203F0008000800054O00098O000A00026O000B00036O000C00046O0008000C00024O000700083O00262O000700C10001000600049C3O00C100012O0039010800013O00263C010800240001000600049C3O002400012O0039010800013O0020880008000800072O00200008000200020006F70008002400013O00049C3O002400010020880008000700082O000E0008000200024O000900013O00202O0009000900084O00090002000200062O000800C10001000900049C3O00C1000100123A010800014O009E000900093O00264C000800260001000100049C3O002600012O0039010A00023O0012D3000B00093O00122O000C000A6O000A000C00024O000B00033O00202O000B000B000B00202O000C0007000C4O000C000D6O000B3O00024O0009000A000B00122O000A000D6O000A000100024O000B5O00202O000B000B000E4O000A000A000B00202O000A000A000F00062O000600CB0001000A00049C3O00CB000100123A010A00013O00264C000A00B60001000100049C3O00B600012O0039010B5O0012D4000C000D6O000C0001000200102O000B000E000C00202O000B0007000C4O000B000200024O000C00023O00122O000D00103O00122O000E00116O000C000E000200062O000B00550001000C00049C3O0055000100123A010B00013O00264C000B004A0001000100049C3O004A00012O0039010C00043O003049000C001200134O000C00023O00122O000D00143O00122O000E00156O000C000E6O000C5O00044O004A000100049C3O00B50001002088000B0007000C2O00B8000B000200024O000C00023O00122O000D00163O00122O000E00176O000C000E000200062O000B00690001000C00049C3O0069000100123A010B00013O000EA10001005E0001000B00049C3O005E00012O0039010C00043O003049000C001200184O000C00023O00122O000D00193O00122O000E001A6O000C000E6O000C5O00044O005E000100049C3O00B500010012DE000B001B3O0020D9000B000B001C00202O000C0007000C4O000C000200024O000D00023O00122O000E001D3O00122O000F001E6O000D000F6O000B3O000200062O000B009200013O00049C3O0092000100123A010B00013O00264C000B00750001000100049C3O007500012O0039010C00043O002O12010D001F3O00122O000E001B3O00202O000E000E002000202O000F0007000C4O000F0002000200122O001000216O000E00106O000D3O000200102O000D0013000D00102O000C0012000D4O000C00023O00122O000D00223O00122O000E00236O000C000E000200122O000D001F3O00122O000E001B3O00202O000E000E002000202O000F0007000C4O000F0002000200122O001000216O000E00106O000D3O00024O000C000C000D4O000C00023O00044O0075000100049C3O00B500010012DE000B001B3O0020D9000B000B001C00202O000C0007000C4O000C000200024O000D00023O00122O000E00243O00122O000F00256O000D000F6O000B3O000200062O000B00B500013O00049C3O00B5000100123A010B00013O00264C000B009E0001000100049C3O009E00012O0039010C00043O0012E3000D001B3O00202O000D000D002000202O000E0007000C4O000E0002000200122O000F00266O000D000F000200102O000C0012000D4O000C00023O00122O000D00273O00122O000E00286O000C000E000200122O000D001B3O00202O000D000D002000202O000E0007000C4O000E0002000200122O000F00266O000D000F00024O000C000C000D4O000C00023O00044O009E000100123A010A00043O00264C000A003B0001000400049C3O003B00012O0039010B00023O00120B000C00293O00122O000D002A6O000B000D6O000B5O00044O003B000100049C3O00CB000100049C3O0026000100049C3O00CB000100123A010800013O00264C000800C20001000100049C3O00C200012O0039010900043O0030200109001200012O005100096O0071000900023O00049C3O00C2000100049C3O00CB000100049C3O000200012O001F3O00017O00073O00028O00026O00F03F030A3O004973536F6C6F4D6F646503213O004C6F77657374467269656E646C79556E69745265667265736861626C6542752O66027O0040026O00444003183O00546172676574497356616C69644865616C61626C654E7063062B3O00123A010600014O009E000700073O00264C000600160001000200049C3O001600012O003901085O0020650008000800032O001A0008000100020006F70008000B00013O00049C3O000B00012O0039010800014O0071000800024O003901085O0020CF0008000800044O00098O000A00016O000B00026O000C00036O000D00046O000E00056O0008000E00024O000700083O00122O000600053O00264C000600230001000100049C3O002300010006900002001B0001000100049C3O001B000100123A010200064O003901085O0020650008000800072O001A0008000100020006F70008002200013O00049C3O002200012O0039010800024O0071000800023O00123A010600023O00264C000600020001000500049C3O000200010006F70007002A00013O00049C3O002A00012O0071000700023O00049C3O002A000100049C3O000200012O001F3O00017O002A3O00028O00026O00F03F031B3O00476574466F637573556E69745265667265736861626C6542752O660003063O0045786973747303043O004755494403053O00AAD715CCAB03063O0030ECB876B9D8030E3O00552O70657243617365466972737403023O00494403073O0047657454696D65030D3O004C617374466F63757353776170025O00408F4003063O00F5B15629CA2603063O005485DD3750AF030B3O0052657475726E466F637573026O00494003183O009EEF25A8C055B3E06480C85FA8F464B2C81CADEB25BFC24E03063O003CDD8744C6A703063O00DABCEA8447CD03063O00B98EDD98E322026O004E4003183O007BCD56F4443AF95F8571F54026E418D158BA5732E55FC04303073O009738A5379A235303063O00737472696E6703043O0066696E6403053O00904217FAB903043O008EC0236503083O00746F6E756D6265722O033O00737562026O00184003173O00F57D28ADE085A211965326A0F29FEC02D93539A2F598B503083O0076B61549C387ECCC03043O003A3D134403073O009D685C7A20646D026O00144003163O0080AECEC43A2E83ACE380C0C92834CDBFACE6DDCB342303083O00CBC3C6AFAA5D47ED030E3O000D433FDB5618F2290B18DA5204EF03073O009C4E2B5EB53171025O00407F40026O00444006CE3O00123A010600014O009E000700083O00264C000600C50001000200049C3O00C500012O003901095O0020630009000900034O000A8O000B00016O000C00026O000D00036O000E00046O000F00056O0009000F00024O000800093O00262O000800BC0001000400049C3O00BC00012O0039010900013O00263C0109001F0001000400049C3O001F00012O0039010900013O0020880009000900052O00200009000200020006F70009001F00013O00049C3O001F00010020880009000800062O000E0009000200024O000A00013O00202O000A000A00064O000A0002000200062O000900BC0001000A00049C3O00BC000100123A010900014O009E000A000A3O00264C000900210001000100049C3O002100012O0039010B00023O0012D3000C00073O00122O000D00086O000B000D00024O000C00033O00202O000C000C000900202O000D0008000A4O000D000E6O000C3O00024O000A000B000C00122O000B000B6O000B000100024O000C5O00202O000C000C000C4O000B000B000C00202O000B000B000D00062O000700CD0001000B00049C3O00CD000100123A010B00013O00264C000B00B10001000100049C3O00B100012O0039010C5O0012D4000D000B6O000D0001000200102O000C000C000D00202O000C0008000A4O000C000200024O000D00023O00122O000E000E3O00122O000F000F6O000D000F000200062O000C00500001000D00049C3O0050000100123A010C00013O00264C000C00450001000100049C3O004500012O0039010D00043O003049000D001000114O000D00023O00122O000E00123O00122O000F00136O000D000F6O000D5O00044O0045000100049C3O00B00001002088000C0008000A2O00B8000C000200024O000D00023O00122O000E00143O00122O000F00156O000D000F000200062O000C00640001000D00049C3O0064000100123A010C00013O00264C000C00590001000100049C3O005900012O0039010D00043O003049000D001000164O000D00023O00122O000E00173O00122O000F00186O000D000F6O000D5O00044O0059000100049C3O00B000010012DE000C00193O0020D9000C000C001A00202O000D0008000A4O000D000200024O000E00023O00122O000F001B3O00122O0010001C6O000E00106O000C3O000200062O000C008D00013O00049C3O008D000100123A010C00013O000EA1000100700001000C00049C3O007000012O0039010D00043O002O12010E001D3O00122O000F00193O00202O000F000F001E00202O00100008000A4O00100002000200122O0011001F6O000F00116O000E3O000200102O000E0011000E00102O000D0010000E4O000D00023O00122O000E00203O00122O000F00216O000D000F000200122O000E001D3O00122O000F00193O00202O000F000F001E00202O00100008000A4O00100002000200122O0011001F6O000F00116O000E3O00024O000D000D000E4O000D00023O00044O0070000100049C3O00B000010012DE000C00193O0020D9000C000C001A00202O000D0008000A4O000D000200024O000E00023O00122O000F00223O00122O001000236O000E00106O000C3O000200062O000C00B000013O00049C3O00B0000100123A010C00013O00264C000C00990001000100049C3O009900012O0039010D00043O0012E3000E00193O00202O000E000E001E00202O000F0008000A4O000F0002000200122O001000246O000E0010000200102O000D0010000E4O000D00023O00122O000E00253O00122O000F00266O000D000F000200122O000E00193O00202O000E000E001E00202O000F0008000A4O000F0002000200122O001000246O000E001000024O000D000D000E4O000D00023O00044O0099000100123A010B00023O00264C000B00360001000200049C3O003600012O0039010C00023O00120B000D00273O00122O000E00286O000C000E6O000C5O00044O0036000100049C3O00CD000100049C3O0021000100049C3O00CD000100123A010900013O000EA1000100BD0001000900049C3O00BD00012O0039010A00043O003020010A001000012O0051000A6O0071000A00023O00049C3O00BD000100049C3O00CD000100264C000600020001000100049C3O0002000100123A010700293O000690000200CB0001000100049C3O00CB000100123A0102002A3O00123A010600023O00049C3O000200012O001F3O00017O00063O00028O0003123O004C6F77657374467269656E646C79556E6974026O00444003043O0046C9EA8803073O00191288A4C36B2303103O004865616C746850657263656E74616765021D3O00123A010200014O009E000300033O00264C000200020001000100049C3O000200012O003901045O00209200040004000200122O000500036O000600013O00122O000700043O00122O000800056O0006000800024O000700016O0004000700024O000300043O00062O0003001800013O00049C3O001800010020880004000300062O002000040002000200060D0104001500013O00049C3O001500012O004E00046O0051000400014O0071000400023O00049C3O001C00012O005100046O0071000400023O00049C3O001C000100049C3O000200012O001F3O00017O00043O00030A3O004973536F6C6F4D6F646503093O004973496E506172747903083O004973496E5261696403273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7402284O003901025O0020650002000200012O001A0002000100020006900002000F0001000100049C3O000F00012O0039010200013O0020880002000200022O00200002000200020006F70002001900013O00049C3O001900012O0039010200013O0020880002000200032O0020000200020002000690000200190001000100049C3O001900012O003901025O0020650002000200042O005E00036O0020000200020002000634000100020001000200049C3O001600012O004E00026O0051000200014O0071000200023O00049C3O002700012O0039010200013O0020880002000200032O00200002000200020006F70002002700013O00049C3O002700012O003901025O0020650002000200042O005E00036O0020000200020002000634000100020001000200049C3O002500012O004E00026O0051000200014O0071000200024O001F3O00017O00253O00028O00026O004440024O00904C1741024O00B44C1741024O00C84C1741024O00D04C1741024O00D44C1741024O00D84C1741024O00DC4C1741024O00E04C1741024O00E44C1741024O00E84C1741024O00F04C1741024O00F44C1741024O00F84C1741026O00F03F027O0040030A3O00556E6974496E5261696403063O00F821A85677AE03083O00D8884DC92F12DCA103043O0052616964030B3O00556E6974496E506172747903063O003DE02AC30DCE03073O00E24D8C4BBA68BC03053O00506172747903043O004E616D6503163O009BC2D52C5CB0C0D77F40BF8EC4374AF9ECC23041A3CB03053O002FD9AEB05F03063O00457869737473030E3O0049735370652O6C496E52616E676503063O0042752O66557003053O005370652O6C03083O0042752O66446F776E026O000840030C3O009ADC6216BE513815B0D2631603083O0046D8BD1662D23418026O00594001833O00123A2O0100014O009E000200043O00264C000100160001000100049C3O0016000100123A010200024O001A0105000D3O00122O000600033O00122O000700043O00122O000800053O00122O000900063O00122O000A00073O00122O000B00083O00122O000C00093O00122O000D000A3O00122O000E000B3O00122O000F000C3O00122O0010000D3O00122O0011000E3O00122O0012000F6O0005000D00012O005E000300053O00123A2O0100103O00264C000100700001001100049C3O007000010012DE000500124O000A01065O00122O000700133O00122O000800146O000600086O00053O000200062O0005002300013O00049C3O002300012O0039010500013O00206500040005001500049C3O003000010012DE000500164O000A01065O00122O000700173O00122O000800186O000600086O00053O000200062O0005002E00013O00049C3O002E00012O0039010500013O00206500040005001900049C3O003000012O005100056O0071000500024O0039010500024O005E000600044O002E01050002000700049C3O006D0001002088000A3O001A2O00B8000A000200024O000B5O00122O000C001B3O00122O000D001C6O000B000D000200062O000A005C0001000B00049C3O005C0001002088000A0009001D2O0020000A000200020006F7000A006D00013O00049C3O006D0001002088000A0009001E2O005E000C6O006B000A000C00020006F7000A006D00013O00049C3O006D000100123A010A00013O000EA1000100460001000A00049C3O004600012O0039010B00024O005E000C00034O002E010B0002000D00049C3O0056000100208800100009001F2O0025001200033O00202O0012001200204O0013000F6O001200136O00103O000200062O0010005600013O00049C3O005600012O005100106O0071001000023O00063F010B004C0001000200049C3O004C00012O0051000B00014O0071000B00023O00049C3O0046000100049C3O006D0001002088000A0009001D2O0020000A000200020006F7000A006D00013O00049C3O006D0001002088000A0009001E2O005E000C6O006B000A000C00020006F7000A006D00013O00049C3O006D0001002088000A000900212O005E000C6O0051000D00014O006B000A000D00020006F7000A006D00013O00049C3O006D00012O0051000A00014O0071000A00023O00063F010500340001000200049C3O0034000100123A2O0100223O00264C0001007D0001001000049C3O007D000100208800053O001A2O00B80005000200024O00065O00122O000700233O00122O000800246O00060008000200062O0005007B0001000600049C3O007B000100123A010200254O009E000400043O00123A2O0100113O000EA1002200020001000100049C3O000200012O005100056O0071000500023O00049C3O000200012O001F3O00017O00033O0003083O0047657454696D657203043O00EACAAF8B03053O00B3BABFC3E700094O0028016O00206O00014O000100013O00122O000200023O00122O000300036O000100039O009O008O00017O00033O0003083O0047657454696D657203053O00DB2D1DE5F203043O0084995F7800094O0028016O00206O00014O000100013O00122O000200023O00122O000300036O000100039O009O008O00017O000B3O00030D3O004973412O644F6E4C6F6164656403083O0095902360D4D5B2B403073O00C0D1D26E4D97BA03073O00C20A25DEF6C3F303063O00A4806342899F028O0003063O0054696D657273026O00F03F0003043O0074696D6503073O0047657454696D6500293O0012683O00016O00015O00122O000200023O00122O000300036O000100039O00000200064O000900013O00049C3O0009000100049C3O002800010012DE3O00014O000A2O015O00122O000200043O00122O000300056O000100039O00000200064O002800013O00049C3O0028000100123A012O00064O00232O0100013O00202O0001000100074O000100013O00122O000200083O00044O002800012O0039010400013O0020650004000400072O00EF00040004000300263C010400270001000900049C3O002700012O0039010400013O0020220104000400074O00040004000300202O00040004000A00122O0005000B6O00050001000200062O000400270001000500049C3O002700012O0039010400013O0020650004000400070020F2000400030009000437012O001700012O001F3O00017O00073O00028O0003063O0054696D657273026O00F03F0003023O00696403043O0074696D6503073O0047657454696D65012C3O00123A2O0100013O00264C000100010001000100049C3O0001000100123A010200014O002301035O00202O0003000300024O000300033O00122O000400033O00042O0002002800012O003901065O0020650006000600022O00EF00060006000500263C010600270001000400049C3O002700012O003901065O0020650006000600022O00EF0006000600050020650006000600050006500006002700013O00049C3O0027000100123A010600014O009E000700073O00264C000600160001000100049C3O001600012O003901085O0020940008000800024O00080008000500202O00080008000600122O000900076O0009000100024O00070008000900262O000700240001000100049C3O002400012O009E000800084O0071000800023O00049C3O002700012O0071000700023O00049C3O0027000100049C3O001600010004370102000900012O009E000200024O0071000200023O00049C3O000100012O001F3O00017O00163O00030D3O004973412O644F6E4C6F6164656403083O0024ABC4F32386FBBB03043O00DE60E98903073O009BBAA02881F4E303073O0090D9D3C77FE893028O00027O0040030D3O00426967576967734C6F61646572030F3O0052656769737465724D652O7361676503103O00DA26391FDC42117BCB3B3F3AC167035603083O0024984F5E48B52562030F3O00F5D14008DEDF5400E4CC482FF5D95503043O005FB7B827026O000840026O00104003173O009736E0115D87118A10E916589505BC31C32F478100B93A03073O0062D55F874634E003103O00DCAACE405DF9B0F64440F1B3EB7646ED03053O00349EC3A91703153O0058B535438F3268B455B2107B95265F8269BD30788303083O00EB1ADC5214E6551B026O00F03F005B3O0012683O00016O00015O00122O000200023O00122O000300036O000100039O00000200064O000900013O00049C3O0009000100049C3O005A00010012DE3O00014O000A2O015O00122O000200043O00122O000300056O000100039O00000200064O005A00013O00049C3O005A000100123A012O00064O009E000100043O00264C3O00280001000700049C3O002800010012DE000500083O0020FB0005000500094O000600046O00075O00122O0008000A3O00122O0009000B6O0007000900024O000800016O00050008000100122O000500083O00202O0005000500094O000600046O00075O00122O0008000C3O00122O0009000D6O0007000900024O000800026O00050008000100124O000E3O00264C3O00340001000F00049C3O003400010012DE000500083O0020FC0005000500094O000600046O00075O00122O000800103O00122O000900116O0007000900024O000800036O00050008000100044O005A000100264C3O00490001000E00049C3O004900010012DE000500083O0020FB0005000500094O000600046O00075O00122O000800123O00122O000900136O0007000900024O000800036O00050008000100122O000500083O00202O0005000500094O000600046O00075O00122O000800143O00122O000900156O0007000900024O000800036O00050008000100124O000F3O00264C3O00500001001600049C3O0050000100066D00033O000100012O0039012O00014O00F400056O005E000400053O00123A012O00073O00264C3O00130001000600049C3O0013000100066D00010001000100032O0039017O0039012O00014O0039012O00023O00066D00020002000100012O0039012O00013O00123A012O00163O00049C3O001300012O001F3O00013O00033O00043O00028O0003063O0054696D657273026O00F03F2O000B3O0012D2000100016O00025O00202O0002000200024O000200023O00122O000300033O00042O0001000A00012O003901055O0020650005000500020020F20005000400040004372O01000600012O001F3O00017O000F3O00029O00024O00705D004103053O00AAB3ECC37F03053O0014E8C189A2024O008827004103043O0012CAC9AA03083O001142BFA5C687EC77026O00F03F03063O0054696D65727303023O00696403043O0074696D6503073O0047657454696D65027O0040026O00084000543O00123A2O0100014O009E000200063O00264C0001001F0001000100049C3O001F00012O00DF0007000D4O00420005000C6O0004000B6O0002000A6O000300096O000200086O000200073O00262O0003001E0001000200049C3O001E000100264C000500150001000300049C3O001500012O003901075O001226010800043O00122O000900056O0007000900024O000300073O00044O001E000100264C0005001D0001000600049C3O001D00012O003901075O001226010800073O00122O000900086O0007000900024O000300073O00044O001E00012O001F3O00013O00123A2O0100093O00264C000100420001000900049C3O0042000100123A010700014O0023010800013O00202O00080008000A4O000800083O00122O000900093O00042O0007003F00012O0039010B00013O002065000B000B000A2O00EF000B000B000A00263C010B003E0001000200049C3O003E00012O0039010B00013O002065000B000B000A2O00EF000B000B000A002065000B000B000B000650000B003E0001000300049C3O003E000100123A010B00013O00264C000B00330001000100049C3O003300012O0039010C00013O0020AE000C000C000A4O000C000C000A00122O000D000D6O000D000100024O000D000D000400102O000C000C000D6O00013O00044O003300010004370107002700012O00F400076O005E000600073O00123A2O01000E3O000EA1000E004A0001000100049C3O004A00010010890006000B00030012320007000D6O0007000100024O00070007000400102O0006000C000700122O0001000F3O000EA1000F00020001000100049C3O000200012O0039010700024O006F000800013O00202O00080008000A4O000900066O00070009000100044O0053000100049C3O000200012O001F3O00017O00053O00028O0003063O0054696D657273026O00F03F0003023O00696400253O00123A2O0100014O009E000200033O000EA1000100020001000100049C3O000200012O00DF000400074O0031000300066O000200056O000200043O00122O000400016O00055O00202O0005000500024O000500053O00122O000600033O00042O0004002200012O003901085O0020650008000800022O00EF00080008000700263C010800210001000400049C3O002100012O003901085O0020650008000800022O00EF000800080007002065000800080005000650000800210001000300049C3O0021000100123A010800013O000EA10001001A0001000800049C3O001A00012O003901095O0020650009000900020020F20009000700042O001F3O00013O00049C3O001A00010004370104000E000100049C3O0024000100049C3O000200012O001F3O00017O00", GetFEnv(), ...);
