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
											if (Enum > 0) then
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
												Upvalues[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
											end
										elseif (Enum <= 2) then
											local A = Inst[2];
											local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
											Top = (Limit + A) - 1;
											local Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
										elseif (Enum > 3) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 6) then
										if (Enum > 5) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											local B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
										end
									elseif (Enum <= 7) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
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
									elseif (Enum > 8) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
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
									elseif (Enum <= 12) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 13) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 16) then
									if (Enum == 15) then
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
								elseif (Enum <= 17) then
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
								elseif (Enum > 18) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum > 20) then
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
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									elseif (Enum <= 22) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 23) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 26) then
									if (Enum == 25) then
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
								elseif (Enum <= 27) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 28) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
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
										if Stk[Inst[2]] then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 33) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 36) then
								if (Enum > 35) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
										if (Enum > 40) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 42) then
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
									elseif (Enum > 43) then
										Stk[Inst[2]] = Upvalues[Inst[3]];
									else
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									end
								elseif (Enum <= 46) then
									if (Enum == 45) then
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
										local A = Inst[2];
										Stk[A](Stk[A + 1]);
									end
								elseif (Enum <= 47) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 48) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum > 50) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 52) then
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
								elseif (Enum == 53) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 56) then
								if (Enum > 55) then
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
							elseif (Enum <= 57) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 58) then
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							end
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum > 60) then
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
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
											if (Mvm[1] == 294) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
									end
								elseif (Enum <= 62) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 63) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 66) then
								if (Enum == 65) then
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
							elseif (Enum <= 67) then
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
							elseif (Enum == 68) then
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
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum > 70) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
							elseif (Enum <= 72) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							elseif (Enum > 73) then
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
						elseif (Enum <= 76) then
							if (Enum > 75) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							else
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							end
						elseif (Enum <= 77) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 78) then
							local A;
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
							Stk[Inst[2]] = Inst[3];
						else
							local A = Inst[2];
							do
								return Unpack(Stk, A, A + Inst[3]);
							end
						end
					elseif (Enum <= 119) then
						if (Enum <= 99) then
							if (Enum <= 89) then
								if (Enum <= 84) then
									if (Enum <= 81) then
										if (Enum == 80) then
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
									elseif (Enum <= 82) then
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
									elseif (Enum == 83) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 86) then
									if (Enum == 85) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 87) then
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 88) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 94) then
								if (Enum <= 91) then
									if (Enum == 90) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 92) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 93) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 96) then
								if (Enum > 95) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 97) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 98) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 104) then
								if (Enum <= 101) then
									if (Enum == 100) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
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
									local B;
									local A;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = #Stk[Inst[3]];
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
							elseif (Enum <= 106) then
								if (Enum == 105) then
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
							elseif (Enum <= 107) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							if (Enum <= 111) then
								if (Enum > 110) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 112) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 113) then
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 116) then
							if (Enum > 115) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 117) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 118) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = {};
						end
					elseif (Enum <= 139) then
						if (Enum <= 129) then
							if (Enum <= 124) then
								if (Enum <= 121) then
									if (Enum == 120) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									else
										local A = Inst[2];
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Stk[Inst[4]]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 123) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum <= 126) then
								if (Enum == 125) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 127) then
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
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 128) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 134) then
							if (Enum <= 131) then
								if (Enum == 130) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 132) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 133) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 136) then
							if (Enum > 135) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 137) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 138) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 149) then
						if (Enum <= 144) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 142) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 143) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
								if (Inst[2] < Inst[4]) then
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
							elseif (Stk[Inst[2]] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 147) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 148) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 154) then
						if (Enum <= 151) then
							if (Enum > 150) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 152) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum > 153) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 157) then
						if (Enum <= 155) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 156) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 158) then
						do
							return Stk[Inst[2]]();
						end
					elseif (Enum > 159) then
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 240) then
					if (Enum <= 200) then
						if (Enum <= 180) then
							if (Enum <= 170) then
								if (Enum <= 165) then
									if (Enum <= 162) then
										if (Enum == 161) then
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
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
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
									elseif (Enum == 164) then
										if (Stk[Inst[2]] == Inst[4]) then
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
								elseif (Enum <= 167) then
									if (Enum > 166) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 168) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								elseif (Enum == 169) then
									local A = Inst[2];
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
							elseif (Enum <= 175) then
								if (Enum <= 172) then
									if (Enum == 171) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 173) then
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
								elseif (Enum > 174) then
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
							elseif (Enum <= 178) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 179) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
						elseif (Enum <= 190) then
							if (Enum <= 185) then
								if (Enum <= 182) then
									if (Enum > 181) then
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
									elseif not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 183) then
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
								elseif (Enum == 184) then
									if (Inst[2] == Inst[4]) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 187) then
								if (Enum == 186) then
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
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 188) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 195) then
							if (Enum <= 192) then
								if (Enum > 191) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 193) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum == 194) then
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
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 197) then
							if (Enum == 196) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 199) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Enum <= 210) then
							if (Enum <= 205) then
								if (Enum <= 202) then
									if (Enum > 201) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
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
								elseif (Enum <= 203) then
									Stk[Inst[2]]();
								elseif (Enum > 204) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 207) then
								if (Enum > 206) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 208) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 209) then
								if (Inst[2] ~= Stk[Inst[4]]) then
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
						elseif (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum == 211) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 213) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 214) then
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
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							end
						elseif (Enum <= 217) then
							if (Enum > 216) then
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
						elseif (Enum <= 218) then
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
						elseif (Enum > 219) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 230) then
						if (Enum <= 225) then
							if (Enum <= 222) then
								if (Enum > 221) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 223) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 224) then
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
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 227) then
							if (Enum > 226) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 228) then
							do
								return Stk[Inst[2]];
							end
						elseif (Enum == 229) then
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
					elseif (Enum <= 235) then
						if (Enum <= 232) then
							if (Enum > 231) then
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 233) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 234) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						if (Enum == 236) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 238) then
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
						if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					elseif (Enum == 239) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 280) then
					if (Enum <= 260) then
						if (Enum <= 250) then
							if (Enum <= 245) then
								if (Enum <= 242) then
									if (Enum > 241) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum <= 243) then
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
								elseif (Enum == 244) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 247) then
								if (Enum == 246) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 248) then
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum == 249) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 255) then
							if (Enum <= 252) then
								if (Enum == 251) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 253) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 254) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 257) then
							if (Enum > 256) then
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
							end
						elseif (Enum <= 258) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
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
							Stk[Inst[2]] = Inst[3] ~= 0;
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum == 259) then
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
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 270) then
						if (Enum <= 265) then
							if (Enum <= 262) then
								if (Enum == 261) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 263) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 264) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 267) then
							if (Enum > 266) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 268) then
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 269) then
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
					elseif (Enum <= 275) then
						if (Enum <= 272) then
							if (Enum == 271) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
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
					elseif (Enum <= 277) then
						if (Enum == 276) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 278) then
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
						VIP = Inst[3];
					elseif (Enum > 279) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 300) then
					if (Enum <= 290) then
						if (Enum <= 285) then
							if (Enum <= 282) then
								if (Enum == 281) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 283) then
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
							elseif (Enum > 284) then
								Stk[Inst[2]] = #Stk[Inst[3]];
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 287) then
							if (Enum > 286) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 288) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						elseif (Enum > 289) then
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
					elseif (Enum <= 295) then
						if (Enum <= 292) then
							if (Enum == 291) then
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
						elseif (Enum == 294) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 297) then
						if (Enum > 296) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 298) then
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
					elseif (Enum > 299) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					end
				elseif (Enum <= 310) then
					if (Enum <= 305) then
						if (Enum <= 302) then
							if (Enum > 301) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 303) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 304) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 307) then
						if (Enum == 306) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 308) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 309) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						if (Stk[Inst[2]] ~= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 315) then
					if (Enum <= 312) then
						if (Enum > 311) then
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
					elseif (Enum <= 313) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 314) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 318) then
					if (Enum <= 316) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 317) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 319) then
					if (Stk[Inst[2]] > Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = VIP + Inst[3];
					end
				elseif (Enum == 320) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503143O00F4D3D23DD996C619D4FCFA37E5BAC91B9FCFCE2403083O007EB1A3BB4586DBA703143O007F5CBCF6EE015B4BB0D1F03E594DBBEB9F204F4D03063O004C3A2CD58EB1002E3O0012D23O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004C23O000A0001001260000300063O00206C000400030007001260000500083O00206C000500050009001260000600083O00206C00060006000A00063C00073O000100062O0026012O00064O0026017O0026012O00044O0026012O00014O0026012O00024O0026012O00053O00206C00080003000B00206C00090003000C2O0077000A5O001260000B000D3O00063C000C0001000100022O0026012O000A4O0026012O000B4O0026010D00073O001299000E000E3O001299000F000F4O0069000D000F000200063C000E0002000100032O0026012O00074O0026012O00094O0026012O00084O0052000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O007D00025O00122O000300016O00045O00122O000500013O00042O0003002100012O002C00076O0028000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O002C000C00034O00DD000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0002000C6O0047000A3O000200202B000A000A00022O00040109000A4O002001073O00010004A30003000500012O002C000300054O0026010400024O00E5000300044O001C01036O00093O00017O000D3O00028O00026O00F03F025O00A89440025O0028B140025O00FAA040025O00A88F40025O00DAB040025O00408040025O00049A40025O0060AF40025O00089140025O0044A940025O00B4A040014E3O001299000200014O00F1000300043O0026A400020039000100020004C23O00390001001299000500014O00F1000600063O0026A400050006000100010004C23O00060001001299000600013O0026570006000D000100010004C23O000D0001002E1200040009000100030004C23O000900010026A40003002D000100010004C23O002D0001001299000700013O0026A400070014000100020004C23O00140001001299000300023O0004C23O002D000100265700070018000100010004C23O00180001002E1200050010000100060004C23O00100001001299000800013O000EA20002001D000100080004C23O001D0001001299000700023O0004C23O001000010026A400080019000100010004C23O001900012O002C00096O004A000400093O00068E0004002500013O0004C23O00250001002E120007002A000100080004C23O002A00012O002C000900014O0026010A6O0086000B6O00D700096O001C01095O001299000800023O0004C23O001900010004C23O00100001000EA200020004000100030004C23O000400012O0026010700044O008600086O00D700076O001C01075O0004C23O000400010004C23O000900010004C23O000400010004C23O000600010004C23O000400010004C23O004D0001002E12000900020001000A0004C23O000200010026A400020002000100010004C23O00020001001299000500013O000ED100020042000100050004C23O00420001002ECD000C00440001000B0004C23O00440001001299000200023O0004C23O00020001002EB8000D00FAFF2O000D0004C23O003E00010026A40005003E000100010004C23O003E0001001299000300014O00F1000400043O001299000500023O0004C23O003E00010004C23O000200012O00093O00017O004E3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00CF47A24AF003043O00269C37C703043O008169792503083O0023C81D1C4873149A03043O003ABEC2CB03073O005479DFB1BFED4C03053O008B44CCB32903083O00A1DB36A9C05A305003053O00644303374603043O004529226003043O009ECAD90E03063O004BDCA3B76A6203073O0021B5863AD60CA903053O00B962DAEB5703083O00EE2A22F4C7A5C53903063O00CAAB5C4786BE2O033O0027D42103043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E179303043O00B4E625C703083O00A7D6894AAB78CE53030C3O004765744974656D436F756E7403043O00A6F1355803063O00C7EB90523D9803063O002604BA2A091303043O004B6776D903043O00EA55771103063O007EA7341074D903063O00E93C2381BA1C03073O009CA84E40E0D47903043O002AEFA2CB03043O00AE678EC503063O00773A5C392B5B03073O009836483F58453E03073O00F7CBE351DBCAFD03043O003CB4A48E03083O007D48003B3EE21C5D03073O0072383E6549478D03103O005265676973746572466F724576656E7403243O00E22CB6DEFCE630B2DBEBFA2AB0C8F9F32AA1DEEBEF26B8D6FEEA20ACC8E9EB2EACD0EFE703053O00AAA36FE297030B3O003022B13940320B1D31A12C03073O00497150D2582E5703103O005265676973746572496E466C69676874030D3O00A03ECE13E9840ECC00F5802BC803053O0087E14CAD72026O00084003073O0048617354696572026O003D40026O001040030D3O003BFFBBB1A2B88F1BFFB5BFA2A403073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65025O006AD840025O006A0841024O0040770B41024O0080B3C54003143O0015A89E7521BA2E2200A39A623BAD3F3107A89A6803083O007045E4DF2C64E87103183O00E43326EA934EB9F12E32FA8651A3FA2B38F09E5DA8F33A2303073O00E6B47F67B3D61C03063O0053657441504C026O004F40006E023O0024000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400046O00055O00122O000600053O0012B7000700066O0005000700024O0005000400054O00065O00122O000700073O00122O000800086O0006000800024O0006000400064O00075O00122O000800093O0012B70009000A6O0007000900024O0007000500074O00085O00122O0009000B3O00122O000A000C6O0008000A00024O0008000500084O00095O00122O000A000D3O001299000B000E4O00690009000B00022O004A0009000400092O0097000A5O00122O000B000F3O00122O000C00106O000A000C00024O000A0004000A00122O000B00046O000C5O00122O000D00113O00122O000E00126O000C000E00022O00D6000C000B000C4O000D5O00122O000E00133O00122O000F00146O000D000F00024O000D000B000D4O000E5O00122O000F00153O00122O001000166O000E001000022O00D6000E000B000E4O000F5O00122O001000173O00122O001100186O000F001100024O000F000B000F4O00105O00122O001100193O00122O0012001A6O0010001200022O00D60010000B00104O00115O00122O0012001B3O00122O0013001C6O0011001300024O0010001000114O00115O00122O0012001D3O00122O0013001E6O0011001300022O004A0010001000112O002C00115O0012990012001F3O001299001300204O00690011001300022O004A0011000B00112O002C00125O001299001300213O0012EE001400226O0012001400024O0011001100124O00125O00122O001300233O00122O001400246O0012001400024O00110011001200122O001200256O001300136O00148O00158O00168O00178O00188O001900546O00555O00122O005600263O00122O005700276O0055005700024O0055000900554O00565O00122O005700283O00122O005800296O0056005800024O0055005500564O00565O00122O0057002A3O00122O0058002B6O0056005800024O0056000A00564O00575O00122O0058002C3O00122O0059002D6O0057005900024O0056005600574O00575O00122O0058002E3O00122O0059002F6O0057005900024O0057000E00574O00585O00122O005900303O00122O005A00316O0058005A00024O0057005700584O00588O00595O00122O005A00323O00122O005B00336O0059005B00024O0059000B00594O005A5O00122O005B00343O00122O005C00356O005A005C00024O00590059005A00063C005A3O000100032O0026012O00554O002C8O0026012O00593O002005005B0004003600063C005D0001000100012O0026012O005A4O0002015E5O00122O005F00373O00122O006000386O005E00606O005B3O00014O005B5O00122O005C00393O00122O005D003A6O005B005D00024O005B0055005B00202O005B005B003B4O005B000200014O005B5O00122O005C003C3O00122O005D003D6O005B005D00024O005B0055005B00202O005B005B003B4O005B000200014O005B005E3O00122O005F003E6O00608O00618O00628O006300016O00645O00202O00650007003F00122O006700403O00122O006800416O0065006800024O006600016O006700106O00685O00122O006900423O00122O006A00436O0068006A00024O00680055006800202O0068006800444O0068000200024O006800686O00670002000200102O0067004500674O006800106O006900656O00680002000200102O0068004600684O0066006800024O006700026O006800106O00695O00122O006A00423O00122O006B00436O0069006B00024O00690055006900202O0069006900444O0069000200024O006900696O00680002000200102O0068004500684O006900106O006A00656O00690002000200102O0069004600694O0067006900024O00660066006700102O00660047006600122O0067003E3O00122O006800483O00122O006900486O006A006A3O00202O006B0004003600063C006D00020001000B2O0026012O00604O0026012O00634O0026012O00694O0026012O00664O002C3O00014O0026012O00104O0026012O00554O002C8O0026012O00654O002C3O00024O0026012O00684O0083006E5O00122O006F00493O00122O0070004A6O006E00706O006B3O000100202O006B0004003600063C006D0003000100022O0026012O00654O0026012O00074O0024016E5O00122O006F004B3O00122O0070004C6O006E00706O006B3O000100063C006B00040001001A2O0026012O00554O002C8O0026012O00374O0026012O00074O0026012O003D4O0026012O000D4O0026012O00334O0026012O003A4O0026012O00344O0026012O003B4O0026012O00354O0026012O003C4O0026012O004B4O0026012O004D4O0026012O004F4O0026012O00564O0026012O00574O0026012O00324O0026012O00394O0026012O00364O0026012O00594O0026012O003E4O0026012O00314O0026012O00384O0026012O004C4O0026012O004E3O00063C006C0005000100062O0026012O00554O002C8O0026012O00184O0026012O00594O0026012O000D4O0026012O00573O00063C006D0006000100042O0026012O00134O0026012O00594O0026012O00584O0026012O00163O00063C006E00070001000B2O0026012O00554O002C8O0026012O00524O0026012O00374O0026012O000D4O0026012O00194O0026012O00084O0026012O00214O0026012O00294O0026012O002E4O0026012O00173O00063C006F00080001000C2O0026012O005C4O0026012O005F4O0026012O005D4O0026012O00554O002C8O0026012O00074O0026012O006A4O0026012O00614O0026012O00084O0026012O00624O0026012O00634O0026012O00643O00063C007000090001001D2O0026012O00554O002C8O0026012O002B4O0026012O00304O0026012O00174O0026012O00464O0026012O00694O0026012O00074O0026012O000D4O0026012O00084O0026012O00604O0026012O00284O0026012O00164O0026012O002D4O0026012O001E4O0026012O00194O0026012O00244O0026012O006A4O0026012O00234O0026012O00274O0026012O002C4O0026012O001A4O0026012O00574O0026012O00294O0026012O002E4O0026012O002A4O0026012O002F4O0026012O00634O0026012O00663O00063C0071000A000100182O0026012O00554O002C8O0026012O001E4O0026012O00634O0026012O00074O0026012O006A4O0026012O000D4O0026012O00084O0026012O002A4O0026012O002F4O0026012O00174O0026012O00464O0026012O00694O0026012O00234O0026012O00644O0026012O00274O0026012O002C4O0026012O00164O0026012O00194O0026012O001A4O0026012O002B4O0026012O00304O0026012O00664O0026012O00573O00063C0072000B000100192O0026012O00554O002C8O0026012O002A4O0026012O002F4O0026012O00174O0026012O00464O0026012O00694O0026012O000D4O0026012O00084O0026012O00294O0026012O002E4O0026012O00074O0026012O00534O0026012O00574O0026012O002B4O0026012O00304O0026012O00234O0026012O00274O0026012O002C4O0026012O00164O0026012O001A4O0026012O005C4O0026012O005D4O0026012O00244O0026012O00193O00063C0073000C000100112O0026012O00554O002C8O0026012O001E4O0026012O00074O0026012O00084O0026012O000D4O0026012O00194O0026012O001A4O0026012O006A4O0026012O00244O0026012O00574O0026012O00564O0026012O00294O0026012O002E4O0026012O00174O0026012O00604O0026012O00233O00063C0074000D000100102O0026012O00084O0026012O00554O0026012O00604O002C8O0026012O001E4O0026012O00074O0026012O000D4O0026012O001B4O0026012O001A4O0026012O005C4O0026012O005D4O0026012O00294O0026012O002E4O0026012O00174O0026012O00464O0026012O00693O00063C0075000E000100172O0026012O00554O002C8O0026012O001A4O0026012O00074O0026012O00604O0026012O00694O0026012O000D4O0026012O00084O0026012O001E4O0026012O00654O0026012O00634O0026012O00194O0026012O00294O0026012O002E4O0026012O00174O0026012O00464O0026012O00284O0026012O00164O0026012O002D4O0026012O00674O0026012O00234O0026012O00244O0026012O00573O00063C0076000F000100132O0026012O00554O002C8O0026012O00294O0026012O002E4O0026012O00174O0026012O00464O0026012O00694O0026012O00074O0026012O000D4O0026012O00084O0026012O001A4O0026012O00284O0026012O00164O0026012O002D4O0026012O00234O0026012O005C4O0026012O005D4O0026012O001B4O0026012O001E3O00063C00770010000100242O0026012O00164O0026012O00654O0026012O00084O0026012O00554O0026012O005C4O0026012O005F4O0026012O005D4O0026012O00734O0026012O00764O0026012O00754O002C8O0026012O006A4O0026012O00704O0026012O00614O0026012O00724O0026012O00624O0026012O00714O0026012O00744O0026012O001F4O0026012O00074O0026012O00694O0026012O00564O0026012O000D4O0026012O00224O0026012O00574O0026012O00644O002C3O00014O0026012O00104O002C3O00024O0026012O002B4O0026012O00304O0026012O00174O0026012O00464O0026012O001A4O0026012O00214O0026012O00633O00063C007800110001002C2O0026012O00364O002C8O0026012O00374O0026012O00384O0026012O00394O0026012O003A4O0026012O003B4O0026012O00194O0026012O001A4O0026012O001B4O0026012O001C4O0026012O001D4O0026012O001E4O0026012O00284O0026012O00294O0026012O00254O0026012O00264O0026012O00204O0026012O00274O0026012O002C4O0026012O002D4O0026012O002E4O0026012O002F4O0026012O002A4O0026012O002B4O0026012O00244O0026012O00534O0026012O001F4O0026012O00214O0026012O00224O0026012O00234O0026012O003E4O0026012O00504O0026012O003C4O0026012O003D4O0026012O00514O0026012O00524O0026012O00544O0026012O00344O0026012O00354O0026012O00324O0026012O00334O0026012O00304O0026012O00313O00063C00790012000100122O0026012O00424O002C8O0026012O00494O0026012O004A4O0026012O004C4O0026012O004B4O0026012O004F4O0026012O00414O0026012O004E4O0026012O004D4O0026012O00404O0026012O003F4O0026012O00484O0026012O00474O0026012O00464O0026012O00434O0026012O00444O0026012O00453O00063C007A00130001002C2O0026012O006A4O0026012O00074O0026012O00414O0026012O00544O0026012O00134O0026012O00594O0026012O00554O0026012O00574O002C8O0026012O001D4O0026012O000D4O0026012O001C4O0026012O001F4O0026012O006B4O0026012O00404O0026012O006C4O0026012O00144O0026012O006E4O0026012O00424O0026012O00504O0026012O00184O0026012O003F4O0026012O00084O0026012O00464O0026012O00694O0026012O00484O0026012O00164O0026012O00494O0026012O006D4O0026012O006F4O0026012O00774O0026012O00514O0026012O00474O0026012O004A4O0026012O005C4O0026012O005D4O0026012O005B4O0026012O00174O0026012O00154O0026012O00784O0026012O00794O0026012O005E4O0026012O00684O0026012O00043O00063C007B0014000100032O0026012O005A4O0026012O000B4O002C7O002023017C000B004D00122O007D004E6O007E007A6O007F007B6O007C007F00016O00013O00153O00073O00030B3O008AECD6CBAEECF8D1AAFADE03043O00A4D889BB030B3O004973417661696C61626C6503123O00F6EF22A2A3F207D3E43DB782FB09C7E037A103073O006BB28651D2C69E03173O001C0791D6AF340283C4A63D2D97D4B93D2A87C4BF3E089103053O00CA586EE2A600174O002C8O0006000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001600013O0004C23O001600012O002C3O00024O0049000100013O00122O000200043O00122O000300056O0001000300024O000200026O000300013O00122O000400063O00122O000500076O0003000500024O0002000200032O00483O000100022O00093O00019O003O00034O002C8O00CB3O000100012O00093O00017O00143O00028O00026O00F03F025O0026A140025O00A2A340025O00A6A740025O00BAB040027O0040024O0080B3C540025O0006AA40025O00509D40030D3O008CCF13F176F385DC02FD77F8B403063O0096CDBD709018030B3O004973417661696C61626C65025O006AD840025O006A0841024O0040770B41025O00BCA740025O00D4A940025O00C09440025O00188240006C3O0012993O00014O00F1000100023O0026A43O0063000100020004C23O006300010026A400010004000100010004C23O00040001001299000200013O0026A400020020000100010004C23O00200001001299000300014O00F1000400043O0026570003000F000100010004C23O000F0001002ECD0004000B000100030004C23O000B0001001299000400013O002ECD00050019000100060004C23O001900010026A400040019000100010004C23O001900012O00CC00056O007B00056O00CC000500014O007B000500013O001299000400023O0026A400040010000100020004C23O00100001001299000200023O0004C23O002000010004C23O001000010004C23O002000010004C23O000B00010026A400020025000100070004C23O00250001001299000300084O007B000300023O0004C23O006B00010026A400020007000100020004C23O00070001001299000300013O0026570003002C000100010004C23O002C0001002E12000900580001000A0004C23O005800012O002C000400044O00D5000500056O000600066O000700073O00122O0008000B3O00122O0009000C6O0007000900024O00060006000700202O00060006000D4O0006000200024O000600066O00050002000200102O0005000E00054O000600056O000700086O000700076O00060002000200102O0006000F00064O0004000600024O000500096O000600056O000700066O000800073O00122O0009000B3O00122O000A000C6O0008000A00024O00070007000800202O00070007000D4O0007000200024O000700076O00060002000200102O0006000E00064O000700056O000800086O000800086O00070002000200102O0007000F00074O0005000700024O00040004000500102O0004001000044O000400033O00122O000400086O0004000A3O00122O000300023O002ECD00110028000100120004C23O002800010026A400030028000100020004C23O00280001001299000200073O0004C23O000700010004C23O002800010004C23O000700010004C23O006B00010004C23O000400010004C23O006B0001000ED10001006700013O0004C23O00670001002ECD00130002000100140004C23O00020001001299000100014O00F1000200023O0012993O00023O0004C23O000200012O00093O00017O00033O0003073O0048617354696572026O003D40026O00104000084O002C3O00013O0020195O000100122O000200023O00122O000300038O000300029O002O007B8O00093O00017O00673O00028O00025O00406E40025O00249C40026O00F03F025O003CA540025O0088B240027O0040025O00088240025O005EA340025O00689F40025O0082AD40025O0068A440025O00488A40030B3O00745F59EF7A94AE0658514E03083O006B39362B9D15E6E7030A3O0049734361737461626C6503103O004865616C746850657263656E74616765025O000CA140025O00E09940030B3O004D692O726F72496D616765025O00588540025O00B0A04003183O00D68203E7B6CEF0D28610F2BC9CCBDE8D14FBAAD5D9DECB4503073O00AFBBEB7195D9BC03133O001BBD844DF77C6A15A19745F0707A35A38858FA03073O00185CCFE12C831903073O004973526561647903133O0047726561746572496E7669736962696C69747903203O004CC1BD4D0F7859ECB1420D7458DABA4517745FCAF8481E7B4EDDAB450D780B8603063O001D2BB3D82C7B025O001CB240025O0072A440026O000840025O007FB240026O00384003083O00CFC6C81FEACACE3603043O005D86A5AD025O00F88440025O00A8A34003083O00496365426C6F636B03153O00B7F1C4FD38C2BD7DB5B2C5C73CCBBC6DB7E4C4826903083O001EDE92A1A25AAED2025O00F88340030D3O00CC4D7529EA42743EE4427504F103043O006A852E10030B3O004973417661696C61626C65030E3O00712376DF554C5C0171F556494C3903063O00203840139C3A030E3O00496365436F6C644162696C69747903143O0053CBE06959FD8C5E88E1535CF78E49C1F3531AA103073O00E03AA885363A92026O001040025O0069B340025O008AA440025O00C08040025O00BEB04003193O008A27780C21E8E7B12C795E0CFEEEB42B701964CBE0AC2B711003073O008FD8421E7E449B03173O0098CD0BD9C0B0DFE8A4CF25CEC4AFDEEFADF802DFCCACD903083O0081CAA86DABA5C3B703173O0052656672657368696E674865616C696E67506F74696F6E03233O00305D31CADB07EE2B563098D611E72E5139DF9E04E9365138D69E10E3245D39CBD702E303073O0086423857B8BE74031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O0018230CBA14FC203937341BA831EE2039353F0E8B16FF283A3203083O00555C5169DB798B41025O008AAB40026O00704003253O00F9A1554471C8FCBF5B406ECCBDBB554470D6F3B4105573CBF4BC5E0578DAFBB65E5675C9F803063O00BF9DD330251C025O00DEA54003103O00BC175655E940F485067D47F653E9891703073O0080EC653F26842103083O0042752O66446F776E03103O00507269736D6174696342612O72696572025O00588240025O0096AB4003173O00A5AA147BB4EADDBEA01456F6EFCAAAAC1F57BFFDCAECF803073O00AFCCC97124D68B030B3O006ACD26CF2646DE27D5015503053O006427AC55BC031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00F88040025O00F0B240030B3O004D612O7342612O7269657203183O00A079AA930CAF79AB923AA86AF98436AB7DB7933ABB7DF9D203053O0053CD18D9E0026O006540025O00BCA34003093O009CD53449AFED2941B803043O002CDDB940025O00F07540025O0004A84003093O00416C74657254696D6503164O00EB5C5A613EF341527641E34D59760FF441497641B103053O00136187283F030B3O00865932373B39BD483C352A03063O0051CE3C535B4F025O007EAB40025O00F0A940030B3O004865616C746873746F6E6503153O0046AED17E3BCB5EB041A5D5322BC64BA140B8D9642A03083O00C42ECBB0124FA32D00CA012O0012993O00014O00F1000100023O0026573O0006000100010004C23O00060001002ECD00030009000100020004C23O00090001001299000100014O00F1000200023O0012993O00043O0026A43O0002000100040004C23O00020001002E120005000B000100060004C23O000B00010026A40001000B000100010004C23O000B0001001299000200013O0026A40002006B000100070004C23O006B0001001299000300013O002E1200080064000100090004C23O00640001000EA200010064000100030004C23O00640001001299000400013O0026570004001C000100040004C23O001C0001002E12000B001E0001000A0004C23O001E0001001299000300043O0004C23O00640001002ECD000D00180001000C0004C23O001800010026A400040018000100010004C23O001800012O002C00056O0006000600013O00122O0007000E3O00122O0008000F6O0006000800024O00050005000600202O0005000500104O00050002000200062O0005003500013O0004C23O003500012O002C000500023O00068E0005003500013O0004C23O003500012O002C000500033O0020050005000500112O00A90005000200022O002C000600043O00063F01050003000100060004C23O00370001002ECD00120044000100130004C23O004400012O002C000500054O002C00065O00206C0006000600142O00A90005000200020006B50005003F000100010004C23O003F0001002EB800150007000100160004C23O004400012O002C000500013O001299000600173O001299000700184O00E5000500074O001C01056O002C00056O0006000600013O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005006200013O0004C23O006200012O002C000500063O00068E0005006200013O0004C23O006200012O002C000500033O0020050005000500112O00A90005000200022O002C000600073O0006D900050062000100060004C23O006200012O002C000500054O002C00065O00206C00060006001C2O00A900050002000200068E0005006200013O0004C23O006200012O002C000500013O0012990006001D3O0012990007001E4O00E5000500074O001C01055O001299000400043O0004C23O0018000100265700030068000100040004C23O00680001002E12001F0013000100200004C23O00130001001299000200213O0004C23O006B00010004C23O001300010026A4000200C8000100040004C23O00C80001001299000300014O00F1000400043O0026A40003006F000100010004C23O006F0001001299000400013O0026A400040076000100040004C23O00760001001299000200073O0004C23O00C800010026570004007A000100010004C23O007A0001002EB8002200FAFF2O00230004C23O007200012O002C00056O0006000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O0005000500104O00050002000200062O0005009A00013O0004C23O009A00012O002C000500083O00068E0005009A00013O0004C23O009A00012O002C000500033O0020050005000500112O00A90005000200022O002C000600093O0006D90005009A000100060004C23O009A0001002ECD0026009A000100270004C23O009A00012O002C000500054O002C00065O00206C0006000600282O00A900050002000200068E0005009A00013O0004C23O009A00012O002C000500013O001299000600293O0012990007002A4O00E5000500074O001C01055O002EB8002B002A0001002B0004C23O00C400012O002C00056O0006000600013O00122O0007002C3O00122O0008002D6O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500C400013O0004C23O00C400012O002C00056O0006000600013O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O0005000500104O00050002000200062O000500C400013O0004C23O00C400012O002C0005000A3O00068E000500C400013O0004C23O00C400012O002C000500033O0020050005000500112O00A90005000200022O002C0006000B3O0006D9000500C4000100060004C23O00C400012O002C000500054O002C00065O00206C0006000600312O00A900050002000200068E000500C400013O0004C23O00C400012O002C000500013O001299000600323O001299000700334O00E5000500074O001C01055O001299000400043O0004C23O007200010004C23O00C800010004C23O006F0001002657000200CC000100340004C23O00CC0001002ECD0035001B2O0100360004C23O001B2O012O002C0003000C3O00068E000300C92O013O0004C23O00C92O012O002C000300033O0020050003000300112O00A90003000200022O002C0004000D3O0006D9000300C92O0100040004C23O00C92O01001299000300014O00F1000400043O000EA2000100D7000100030004C23O00D70001001299000400013O002657000400DE000100010004C23O00DE0001002E12003800DA000100370004C23O00DA00012O002C0005000E4O0058000600013O00122O000700393O00122O0008003A6O00060008000200062O000500E6000100060004C23O00E600010004C23O00FB00012O002C0005000F4O0006000600013O00122O0007003B3O00122O0008003C6O0006000800024O00050005000600202O00050005001B4O00050002000200062O000500FB00013O0004C23O00FB00012O002C000500054O002C000600103O00206C00060006003D2O00A900050002000200068E000500FB00013O0004C23O00FB00012O002C000500013O0012990006003E3O0012990007003F4O00E5000500074O001C01056O002C0005000E3O002657000500FF000100400004C23O00FF00010004C23O00C92O012O002C0005000F4O0006000600013O00122O000700413O00122O000800426O0006000800024O00050005000600202O00050005001B4O00050002000200062O000500C92O013O0004C23O00C92O01002ECD004400C92O0100430004C23O00C92O012O002C000500054O002C000600103O00206C00060006003D2O00A900050002000200068E000500C92O013O0004C23O00C92O012O002C000500013O00128D000600453O00122O000700466O000500076O00055O00044O00C92O010004C23O00DA00010004C23O00C92O010004C23O00D700010004C23O00C92O010026A4000200772O0100010004C23O00772O01001299000300013O002EB800470006000100470004C23O00242O010026A4000300242O0100040004C23O00242O01001299000200043O0004C23O00772O010026A40003001E2O0100010004C23O001E2O012O002C00046O0006000500013O00122O000600483O00122O000700496O0005000700024O00040004000500202O0004000400104O00040002000200062O000400402O013O0004C23O00402O012O002C000400113O00068E000400402O013O0004C23O00402O012O002C000400033O00207C00040004004A4O00065O00202O00060006004B4O00040006000200062O000400402O013O0004C23O00402O012O002C000400033O0020050004000400112O00A90004000200022O002C000500123O00063F01040003000100050004C23O00422O01002ECD004D004D2O01004C0004C23O004D2O012O002C000400054O002C00055O00206C00050005004B2O00A900040002000200068E0004004D2O013O0004C23O004D2O012O002C000400013O0012990005004E3O0012990006004F4O00E5000400064O001C01046O002C00046O0006000500013O00122O000600503O00122O000700516O0005000700024O00040004000500202O0004000400104O00040002000200062O000400682O013O0004C23O00682O012O002C000400133O00068E000400682O013O0004C23O00682O012O002C000400033O00207C00040004004A4O00065O00202O00060006004B4O00040006000200062O000400682O013O0004C23O00682O012O002C000400143O00202O0104000400524O000500153O00122O000600076O00040006000200062O0004006A2O0100010004C23O006A2O01002EB80053000D000100540004C23O00752O012O002C000400054O002C00055O00206C0005000500552O00A900040002000200068E000400752O013O0004C23O00752O012O002C000400013O001299000500563O001299000600574O00E5000400064O001C01045O001299000300043O0004C23O001E2O010026A400020010000100210004C23O00100001001299000300013O002ECD005800BF2O0100590004C23O00BF2O010026A4000300BF2O0100010004C23O00BF2O012O002C00046O0006000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004009E2O013O0004C23O009E2O012O002C000400163O00068E0004009E2O013O0004C23O009E2O012O002C000400033O0020050004000400112O00A90004000200022O002C000500173O0006D90004009E2O0100050004C23O009E2O01002E12005C009E2O01005D0004C23O009E2O012O002C000400054O002C00055O00206C00050005005E2O00A900040002000200068E0004009E2O013O0004C23O009E2O012O002C000400013O0012990005005F3O001299000600604O00E5000400064O001C01046O002C0004000F4O0006000500013O00122O000600613O00122O000700626O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400B12O013O0004C23O00B12O012O002C000400183O00068E000400B12O013O0004C23O00B12O012O002C000400033O0020050004000400112O00A90004000200022O002C000500193O00063F01040003000100050004C23O00B32O01002E12006300BE2O0100640004C23O00BE2O012O002C000400054O002C000500103O00206C0005000500652O00A900040002000200068E000400BE2O013O0004C23O00BE2O012O002C000400013O001299000500663O001299000600674O00E5000400064O001C01045O001299000300043O0026A40003007A2O0100040004C23O007A2O01001299000200343O0004C23O001000010004C23O007A2O010004C23O001000010004C23O00C92O010004C23O000B00010004C23O00C92O010004C23O000200012O00093O00017O000A3O00025O00789840025O00BAA340030B3O00ED1AF9132CDA3CE10E29DA03053O005ABF7F947C03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00344003103O0052656D6F76654375727365466F63757303133O006A8223186E8211146D953D123883270468822203043O007718E74E00213O002ECD00010020000100020004C23O002000012O002C8O0006000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002000013O0004C23O002000012O002C3O00023O00068E3O002000013O0004C23O002000012O002C3O00033O00206C5O0006001299000100074O00A93O0002000200068E3O002000013O0004C23O002000012O002C3O00044O002C000100053O00206C0001000100082O00A93O0002000200068E3O002000013O0004C23O002000012O002C3O00013O001299000100093O0012990002000A4O00E53O00024O001C017O00093O00017O00153O00028O00025O0016A140025O00789340026O00F03F025O0030AE40025O00C07C40025O00F09940025O00149040025O00C0AA40025O0040564003133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00508940025O0095B140026O002A40025O00E06B4003103O0048616E646C65546F705472696E6B6574025O001CA440025O0094A740025O00807340025O00A0724000523O0012993O00014O00F1000100023O0026573O0006000100010004C23O00060001002ECD00020009000100030004C23O00090001001299000100014O00F1000200023O0012993O00043O0026573O000D000100040004C23O000D0001002EB8000500F7FF2O00060004C23O0002000100265700010011000100010004C23O00110001002ECD0007000D000100080004C23O000D0001001299000200013O00265700020016000100040004C23O00160001002ECD000900260001000A0004C23O002600012O002C000300013O00203300030003000B4O000400026O000500033O00122O0006000C6O000700076O0003000700024O00035O002E2O000D00510001000E0004C23O005100012O002C00035O00068E0003005100013O0004C23O005100012O002C00036O00E4000300023O0004C23O005100010026A400020012000100010004C23O00120001001299000300013O000EA200010047000100030004C23O00470001001299000400013O000ED100010030000100040004C23O00300001002E12001000400001000F0004C23O004000012O002C000500013O00200F0005000500114O000600026O000700033O00122O0008000C6O000900096O0005000900024O00058O00055O00062O0005003D000100010004C23O003D0001002EB800120004000100130004C23O003F00012O002C00056O00E4000500023O001299000400043O000ED100040044000100040004C23O00440001002ECD0014002C000100150004C23O002C0001001299000300043O0004C23O004700010004C23O002C00010026A400030029000100040004C23O00290001001299000200043O0004C23O001200010004C23O002900010004C23O001200010004C23O005100010004C23O000D00010004C23O005100010004C23O000200012O00093O00017O00363O00028O00026O00F03F025O00A06940025O004FB040025O005C9C40025O00F49940030B3O00AF24B758D352388F2CA24F03073O0071E24DC52ABC20030A3O0049734361737461626C65025O00E07240025O00F6A540025O00809D40025O00D88240030B3O004D692O726F72496D61676503183O00371FE6A73504CBBC3717F3B07A06E6B03919F9B73B02B4E703043O00D55A7694030B3O007A3CB757435E0CB8575E4F03053O002D3B4ED43603073O0049735265616479030B3O00235F938389209EE41F448E03083O00907036E3EBE64ECD030B3O004973417661696C61626C65025O00BBB240030B3O00417263616E65426C617374030E3O0049735370652O6C496E52616E676503183O00B23A0CFDDE5E8C2A03FDC34FF3381DF9D354BE2A0EE8900F03063O003BD3486F9CB0025O00A9B240025O0019B340025O0024AA40025O0030964003093O006B91EC2E4F93EA224003043O004D2EE783030B3O00895DA648B55A8554B546BB03043O0020DA34D6025O00E4A240025O008EA14003093O0045766F636174696F6E03153O004B013EABF0A44C55405721BAF4B34A574C1625E8A703083O003A2E7751C891D02503093O000A9E33ADA7B819398E03073O00564BEC50CCC9DD03093O00417263616E654F726203093O004973496E52616E6765026O00444003163O0073537484F08E4D4E6587BE9B6044748AF389735537DD03063O00EB122117E59E027O0040025O00BEAA40025O00E6A740030B3O0071A8C2BA5EBFE3B751A9D503043O00DB30DAA103183O00E5637F48D54ADFE62O7D5ACF0FF0F6747F46D64DE1F0312403073O008084111C29BB2F00F43O0012993O00014O00F1000100023O0026A43O00ED000100020004C23O00ED0001000EA200010004000100010004C23O00040001001299000200013O0026570002000B000100010004C23O000B0001002ECD0004006F000100030004C23O006F0001001299000300014O00F1000400043O0026A40003000D000100010004C23O000D0001001299000400013O0026A400040066000100010004C23O00660001001299000500013O000ED100020017000100050004C23O00170001002EB800050004000100060004C23O00190001001299000400023O0004C23O006600010026A400050013000100010004C23O001300012O002C00066O0006000700013O00122O000800073O00122O000900086O0007000900024O00060006000700202O0006000600094O00060002000200062O0006002B00013O0004C23O002B00012O002C000600023O00068E0006002B00013O0004C23O002B00012O002C000600033O0006B50006002D000100010004C23O002D0001002ECD000B003A0001000A0004C23O003A0001002E12000D003A0001000C0004C23O003A00012O002C000600044O002C00075O00206C00070007000E2O00A900060002000200068E0006003A00013O0004C23O003A00012O002C000600013O0012990007000F3O001299000800104O00E5000600084O001C01066O002C00066O0006000700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600134O00060002000200062O0006006400013O0004C23O006400012O002C000600053O00068E0006006400013O0004C23O006400012O002C00066O00A7000700013O00122O000800143O00122O000900156O0007000900024O00060006000700202O0006000600164O00060002000200062O00060064000100010004C23O00640001002EB800170013000100170004C23O006400012O002C000600044O00DA00075O00202O0007000700184O000800063O00202O0008000800194O000A5O00202O000A000A00184O0008000A00024O000800086O00060008000200062O0006006400013O0004C23O006400012O002C000600013O0012990007001A3O0012990008001B4O00E5000600084O001C01065O001299000500023O0004C23O001300010026570004006A000100020004C23O006A0001002ECD001D00100001001C0004C23O00100001001299000200023O0004C23O006F00010004C23O001000010004C23O006F00010004C23O000D0001000EA2000200C6000100020004C23O00C60001001299000300013O00265700030076000100010004C23O00760001002ECD001E00C10001001F0004C23O00C100012O002C00046O0006000500013O00122O000600203O00122O000700216O0005000700024O00040004000500202O0004000400134O00040002000200062O0004009A00013O0004C23O009A00012O002C000400073O00068E0004009A00013O0004C23O009A00012O002C00046O0006000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O0004000400164O00040002000200062O0004009A00013O0004C23O009A0001002E120025009A000100240004C23O009A00012O002C000400044O002C00055O00206C0005000500262O00A900040002000200068E0004009A00013O0004C23O009A00012O002C000400013O001299000500273O001299000600284O00E5000400064O001C01046O002C00046O0006000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400C000013O0004C23O00C000012O002C000400083O00068E000400C000013O0004C23O00C000012O002C000400093O00068E000400AD00013O0004C23O00AD00012O002C0004000A3O0006B5000400B0000100010004C23O00B000012O002C000400093O0006B5000400C0000100010004C23O00C000012O002C000400044O001400055O00202O00050005002B4O000600063O00202O00060006002C00122O0008002D6O0006000800024O000600066O00040006000200062O000400C000013O0004C23O00C000012O002C000400013O0012990005002E3O0012990006002F4O00E5000400064O001C01045O001299000300023O0026A400030072000100020004C23O00720001001299000200303O0004C23O00C600010004C23O00720001002E1200320007000100310004C23O00070001000EA200300007000100020004C23O000700012O002C00036O0006000400013O00122O000500333O00122O000600346O0004000600024O00030003000400202O0003000300134O00030002000200062O000300F300013O0004C23O00F300012O002C000300053O00068E000300F300013O0004C23O00F300012O002C000300044O00DA00045O00202O0004000400184O000500063O00202O0005000500194O00075O00202O0007000700184O0005000700024O000500056O00030005000200062O000300F300013O0004C23O00F300012O002C000300013O00128D000400353O00122O000500366O000300056O00035O00044O00F300010004C23O000700010004C23O00F300010004C23O000400010004C23O00F300010026A43O0002000100010004C23O00020001001299000100014O00F1000200023O0012993O00023O0004C23O000200012O00093O00017O003B3O00028O00025O0092A440025O00489140026O00F03F025O0030AF40025O00A0AA40025O00AAAB40025O008EA040025O00D07E40025O00F6AC4003093O002O20053B53041D143803053O003D6152665A03073O0043686172676573030D3O00417263616E6543686172676573026O000840030C3O009E2FAF42C6590A3ABC2FB94003083O0069CC4ECB2BA7377E030A3O00432O6F6C646F776E5570030E3O0091A5361D1B0BC145ADAF0E1F140D03083O0031C5CA437E7364A7030F3O00432O6F6C646F776E52656D61696E73027O0040025O00CDB140025O0058A740030A3O00446562752O66446F776E03193O0052616469616E74537061726B56756C6E65726162696C697479030D3O00446562752O6652656D61696E7303123O0052616469616E74537061726B446562752O66026O001C40030C3O00055ADB2081584A044BDE3B8B03073O003E573BBF49E036030C3O00432O6F6C646F776E446F776E030C3O00D503FEC0E60CEEFAF703E8C203043O00A987629A030E3O00FF783157F53CCEDF7F2179FC34C103073O00A8AB1744349D53030B3O00D563F6AC2B28B4E163F2A803073O00E7941195CD454D026O001440030B3O00A1B5C4FA59FAB3B2D5FC5203063O009FE0C7A79B37026O004440025O0012A640025O0076A840025O00ECAC40025O00709340030C3O00C5F238DBF6FD28E1E7F22ED903043O00B297935C025O00749040025O00709F4003083O00446562752O66557003143O00546F7563686F667468654D616769446562752O66025O0065B140025O0063B340030B3O00ADEF4F331C495880FC5F2603073O001AEC9D2C52722C03083O004361737454696D65025O0080AE40025O00D1B24000FA3O0012993O00014O00F1000100023O002E12000300F1000100020004C23O00F100010026A43O00F1000100040004C23O00F100010026570001000A000100010004C23O000A0001002ECD00050006000100060004C23O00060001001299000200013O0026A4000200CC000100010004C23O00CC0001001299000300014O00F1000400043O00265700030013000100010004C23O00130001002ECD0007000F000100080004C23O000F0001001299000400013O000ED100040018000100040004C23O00180001002ECD000A001A000100090004C23O001A0001001299000200043O0004C23O00CC00010026A400040014000100010004C23O001400012O002C00056O002C000600013O00063F01060005000100050004C23O002400012O002C000500024O002C000600013O0006D90006004C000100050004C23O004C00012O002C000500034O00D0000600043O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O000500020002000E9D00010033000100050004C23O003300012O002C000500053O00200500050005000E2O00A9000500020002000EE0000F004C000100050004C23O004C00012O002C000500034O0006000600043O00122O000700103O00122O000800116O0006000800024O00050005000600202O0005000500124O00050002000200062O0005004C00013O0004C23O004C00012O002C000500034O00D0000600043O00122O000700133O00122O000800146O0006000800024O00050005000600202O0005000500154O0005000200022O002C000600063O00200E0106000600160006D90005004C000100060004C23O004C00012O00CC000500014O007B000500073O0004C23O006B0001002E120018006B000100170004C23O006B00012O002C000500073O00068E0005006B00013O0004C23O006B00012O002C000500083O00207C0005000500194O000700033O00202O00070007001A4O00050007000200062O0005006B00013O0004C23O006B00012O002C000500083O002O2000050005001B4O000700033O00202O00070007001C4O00050007000200262O0005006B0001001D0004C23O006B00012O002C000500034O0006000600043O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O0005000500204O00050002000200062O0005006B00013O0004C23O006B00012O00CC00056O007B000500074O002C000500053O00200500050005000E2O00A9000500020002000E1C000F00A4000100050004C23O00A400012O002C00056O002C000600013O00068700050078000100060004C23O007800012O002C000500024O002C000600013O0006AF000500A4000100060004C23O00A400012O002C000500034O0006000600043O00122O000700213O00122O000800226O0006000800024O00050005000600202O0005000500124O00050002000200062O000500A400013O0004C23O00A400012O002C000500034O00D0000600043O00122O000700233O00122O000800246O0006000800024O00050005000600202O0005000500154O0005000200022O002C000600063O00200E01060006001D0006D9000500A4000100060004C23O00A400012O002C000500034O00D0000600043O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500154O0005000200022O002C000600063O00200E01060006002700063F0105000D000100060004C23O00A600012O002C000500034O00D0000600043O00122O000700283O00122O000800296O0006000800024O00050005000600202O0005000500154O000500020002000E9D002A00A6000100050004C23O00A60001002EB8002B00050001002C0004C23O00A900012O00CC000500014O007B000500093O0004C23O00C80001002ECD002E00C80001002D0004C23O00C800012O002C000500093O00068E000500C800013O0004C23O00C800012O002C000500083O00207C0005000500194O000700033O00202O00070007001A4O00050007000200062O000500C800013O0004C23O00C800012O002C000500083O002O2000050005001B4O000700033O00202O00070007001C4O00050007000200262O000500C80001001D0004C23O00C800012O002C000500034O0006000600043O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O0005000500204O00050002000200062O000500C800013O0004C23O00C800012O00CC00056O007B000500093O001299000400043O0004C23O001400010004C23O00CC00010004C23O000F0001002E120031000B000100320004C23O000B00010026A40002000B000100040004C23O000B00012O002C000300083O00207C0003000300334O000500033O00202O0005000500344O00030005000200062O000300DA00013O0004C23O00DA00012O002C0003000A3O0006B5000300DC000100010004C23O00DC0001002E12003600DE000100350004C23O00DE00012O00CC00036O007B0003000A4O002C000300034O00D0000400043O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300394O0003000200022O002C000400063O000687000300EA000100040004C23O00EA00012O003D00036O00CC000300014O007B0003000B3O0004C23O00F900010004C23O000B00010004C23O00F900010004C23O000600010004C23O00F90001000ED1000100F500013O0004C23O00F50001002EB8003A000FFF2O003B0004C23O00020001001299000100014O00F1000200023O0012993O00043O0004C23O000200012O00093O00017O00EC3O00028O00026O00F03F025O00DC9540025O00349840025O0048AE40030E3O001E21C0582221D34F222BF85A2D2703043O003B4A4EB503073O004973526561647903083O005072657647434450030D3O00417263616E6542612O72616765030E3O00546F7563686F667468654D616769030E3O0049735370652O6C496E52616E676503223O0031DE4F59BB1ADE5C65A72DD46557B222D81A59BC2ADD5E55A42BEE4A52B236D41A0803053O00D345B12O3A030C3O0085E47DFCE8C5A3D669F4FBC003063O00ABD785199589030A3O00432O6F6C646F776E5570025O00E49140025O00B0A140030B3O00C0DA31FBE135CF57F3CF3703083O002281A8529A8F509C030F3O00432O6F6C646F776E52656D61696E73026O002440025O00A2AB40025O00E5B140025O0035B040025O00E07F40030D3O00B6BA3A0D5C47872O823C1C4D5C03073O00E9E5D2536B282E03083O0042752O66446F776E030F3O00417263616E65537572676542752O66030C3O00F34336DF04CF5601C604D34903053O0065A12252B6030B3O004973417661696C61626C65030D3O005368696674696E67506F77657203093O004973496E52616E6765026O004440026O009740025O0048AB40031F3O00FB0550F8CFEB8C29D71D56E9DEF0C22DE70255FAD4F58C11F80558EDDEA2D603083O004E886D399EBB82E2026O001840025O00406040025O00B49D40030E3O00F793FC48D1D3ACF65ACCDF8DFA5A03053O00BFB6E19F2903133O004E6574686572507265636973696F6E42752O6603063O0042752O66557003103O00436C65617263617374696E6742752O66030A3O00446562752O66446F776E03193O0052616469616E74537061726B56756C6E65726162696C697479030B3O00446562752O66537461636B026O001040030B3O00417263616E65426C617374030E3O00417263616E654D692O73696C657303213O002A002B548582FD261B3B46828BC738522B5A848BC62405266A9B8FC338176806DF03073O00A24B724835EBE7030B3O00AD2E47E35D07AE3045F14703063O0062EC5C248233025O0004A440025O006AAD40031E3O00A50B0FBB4BAD8A32A8181FAE05ABBA3FA81D03AD4B97A538A50A09FA16FE03083O0050C4796CDA25C8D5026O001440025O002C9A40025O00507340025O00B2A640025O00308E40025O0094A140025O00889840030B3O00790524475612054A59043303043O002638774703123O0050726573656E63656F664D696E6442752O66031E3O00F2FD5BD72B53CCED54D73642B3EC57D92952FCF856E9355EF2FC5D96760403063O0036938F38B645025O0046A540030B3O0019140EEC36032FE139151903043O008D58666D03083O00446562752O665570025O00AEA040025O002O7040025O00909F40031E3O00B241C97114386AC3BF52D9645A3E5ACEBF57C567140245C9B240CF30486503083O00A1D333AA107A5D35030E3O00CBBCB73BFEA0B12DF4A89F21F5AA03043O00489BCED2030A3O0049734361737461626C65030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O66030E3O0050726573656E63656F664D696E64025O00606540025O003C904003223O005668511D36487951313C404559073D423A57013C4A7E5B193D796A5C0F20433A075E03053O0053261A346E025O0054A340025O0078A140026O00A340025O00489240025O00B49040025O0098B240030D3O0035E89259E82F0D1EE09654FE2903073O00597B8DE6318D5D030D3O00DD74E2041558C774FB1C1559E703063O002A9311966C7003113O0054696D6553696E63654C61737443617374026O003E40030A3O002EB42E7EE9ED2AA5257003063O00886FC64D1F87025O00B9B240025O00A4A940030D3O004E657468657254656D7065737403203O002O0CB35EB8F628BD0704B753AEF057AA0D06AB52B2F319961201A645B8A445FB03083O00C96269C736DD8477030B3O00981E80200C309FAC1E842403073O00CCD96CE3416255025O003EB340025O00B88040030B3O00417263616E655375726765031E3O005FD1F6E422C561D0E0F72BC51EC0FAEA20C451D4FBDA3CC85FD0F0A57E9403063O00A03EA395854C030D3O00F7B20E2ECDD3820C3DD1D7A70803053O00A3B6C06D4F030C3O0052616469616E74537061726B025O00A49B40025O00A7B240025O0074B24003203O00353403C1FB311902C1E7262707C5B537290FCCF13B310EFFE53C2713C5B5667003053O0095544660A0025O002CA540025O00D08040030C3O0049734368612O6E656C696E67030A3O0047434452656D61696E73030E3O004D616E6150657263656E7461676503133O00417263616E65417274692O6C65727942752O66025O00908D40025O00DFB240030B3O0053746F7043617374696E67032B3O00E330E45D7574F9EF2BF44F727DC3F162EE526F74D4F037F7483B72C9ED2EE3536C7FF9F22AE64F7E3197B203073O00A68242873C1B11027O0040025O0088854003093O001F2DFAF0303AD6E33C03043O00915E5F99030C3O00CFCC10DC4FB9E9FE04D45CBC03063O00D79DAD74B52E030D3O00417263616E654368617267657303103O00417263616E65436861726765734D6178025O00108B40025O0090A640025O0064AE4003093O00417263616E654F7262031B3O0034A688F3D4308B84E0D875B784FDD631BB9CFCE525BC8AE1DF75E203053O00BA55D4EB92030B3O00E39315FF37EB7ACE8005EA03073O0038A2E1769E598E030C3O006E04C4A623D64836D0AE30D303063O00B83C65A0CF4203093O0010907FBD3F8753AE3303043O00DC51E21C025O00C88040025O0060A740031D3O0012C781FAE4C22CD78EFAF9D353D68DF4E6C31CC28CC4FACF12C687BBB203063O00A773B5E29B8A026O000840025O00ACAF40025O00806040025O009C9840025O0046A240025O0076A340025O009C9F40030C3O00B6405C27854F4C1D94404A2503043O004EE42138031F3O00DC7FB60A84C06A8D1095CF6CB94386C171BE078AD9708D138DCF6DB743D79E03053O00E5AE1ED263025O00A2AC40025O0026AE40030E3O001240512OF7367F5BE5EA3A5E57E503053O0099532O3296030D3O007C64701D7DAE655C647E137DB203073O002D3D16137C13CB03093O0042752O66537461636B03113O00417263616E654861726D6F6E7942752O66026O002E40030B3O00426C2O6F646C7573745570030C3O00F31309FC037EADF2020CE70903073O00D9A1726D956210030B3O0033323B7DB27121352A7BB903063O00147240581CDC03213O003013D1B5F6D5823C08C1A7F1DCB82241D1BBF7DCB93E16DC8BE8D8BC220492E5AE03073O00DD5161B2D498B0030E3O00ECF51EFA14C8CA14E809C4EB18E803053O007AAD877D9B030C3O00B6C004B03E3FDCB7D101AB3403073O00A8E4A160D95F51030F3O00F5D43A542A45EBC32B5F2644D2DE2003063O0037BBB14E3C4F030B3O0042752O6652656D61696E7303073O0048617354696572025O00D8AD40025O00EAA94003213O002CDC5CEA48CABF20C74CF84FC3853E8E5CE449C38422D951D456C7813ECB1FBA1E03073O00E04DAE3F8B26AF025O00D07B40025O0034A840025O00708940025O00A4A840025O001EAB40025O00CCB140030E3O006558CD743E4167C766234D46CB6603053O0050242AAE15030C3O007C1133734F1E23495E11257103043O001A2E7057026O003F4003213O00B831A875B1BA7AB9B030B87DB3BA56F4BA2CA478BBB052BA8633A375ACBA05E5E903083O00D4D943CB142ODF25030B3O009B9FABD3B4888ADEBB9EBC03043O00B2DAEDC8030B3O0097A7E5D1B8B0D5C5A4B2E303043O00B0D6D58603043O004D616E61030F3O00536970686F6E53746F726D42752O66026O003140025O00E6A840025O00A1B240031E3O00F5BFB5D5A65366F6A1B7C7BC165AFBA2BAD0A74157CBBDBED5BB5319A5FF03073O003994CDD6B4C836030E3O0033EF36357817D03C27651BF1302703053O0016729D5554030C3O00F6CA17CD5CF8BCF7DB12D65603073O00C8A4AB73A43D96025O00FCAB40025O00789C40025O00709B40025O00EC964003213O00BFE600448DBBCB0E4C90ADFD0F4090FEF70C4A8FBAFB144BBCAEFC025686FEA55703053O00E3DE946325002E052O0012993O00013O0026A43O00A6000100010004C23O00A60001001299000100013O0026A40001005F000100010004C23O005F0001001299000200013O0026570002000B000100020004C23O000B0001002ECD0004000D000100030004C23O000D0001001299000100023O0004C23O005F00010026A400020007000100010004C23O00070001002EB800050035000100050004C23O004400012O002C00036O0006000400013O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O00030002000200062O0003004400013O0004C23O004400012O002C000300023O00068E0003004400013O0004C23O004400012O002C000300033O00068E0003002400013O0004C23O002400012O002C000300043O0006B500030027000100010004C23O002700012O002C000300033O0006B500030044000100010004C23O004400012O002C000300054O002C000400063O0006AF00030044000100040004C23O004400012O002C000300073O00200E00030003000900122O000500026O00065O00202O00060006000A4O00030006000200062O0003004400013O0004C23O004400012O002C000300084O00DA00045O00202O00040004000B4O000500093O00202O00050005000C4O00075O00202O00070007000B4O0005000700024O000500056O00030005000200062O0003004400013O0004C23O004400012O002C000300013O0012990004000D3O0012990005000E4O00E5000300054O001C01036O002C00036O00A7000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O00030050000100010004C23O00500001002ECD0013005D000100120004C23O005D00012O002C00036O00D0000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300164O0003000200020026800003005B000100170004C23O005B00012O003D00036O00CC000300014O007B0003000A3O001299000200023O0004C23O0007000100265700010063000100020004C23O00630001002ECD00190004000100180004C23O00040001002E12001B00A30001001A0004C23O00A300012O002C00026O0006000300013O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300202O0002000200084O00020002000200062O000200A300013O0004C23O00A300012O002C0002000B3O00068E000200A300013O0004C23O00A300012O002C0002000C3O00068E0002007800013O0004C23O007800012O002C0002000D3O0006B50002007B000100010004C23O007B00012O002C0002000D3O0006B5000200A3000100010004C23O00A300012O002C000200054O002C000300063O0006AF000200A3000100030004C23O00A300012O002C000200073O00207C00020002001E4O00045O00202O00040004001F4O00020004000200062O000200A300013O0004C23O00A300012O002C00026O00A7000300013O00122O000400203O00122O000500216O0003000500024O00020002000300202O0002000200224O00020002000200062O000200A3000100010004C23O00A300012O002C000200084O001F01035O00202O0003000300234O000400093O00202O00040004002400122O000600256O0004000600024O000400046O000500016O00020005000200062O0002009E000100010004C23O009E0001002E12002700A3000100260004C23O00A300012O002C000200013O001299000300283O001299000400294O00E5000200044O001C01025O0012993O00023O0004C23O00A600010004C23O000400010026573O00AA0001002A0004C23O00AA0001002E12002C000D2O01002B0004C23O000D2O012O002C00016O0006000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200202O0001000100084O00010002000200062O000100EC00013O0004C23O00EC00012O002C0001000E3O00068E000100EC00013O0004C23O00EC00012O002C000100073O00207C00010001001E4O00035O00202O00030003002F4O00010003000200062O000100EC00013O0004C23O00EC00012O002C000100073O00207C0001000100304O00035O00202O0003000300314O00010003000200062O000100EC00013O0004C23O00EC00012O002C000100093O00209A0001000100324O00035O00202O0003000300334O00010003000200062O000100DB000100010004C23O00DB00012O002C000100093O0020820001000100344O00035O00202O0003000300334O00010003000200262O000100EC000100350004C23O00EC00012O002C000100073O00200E00010001000900122O000300026O00045O00202O0004000400364O00010004000200062O000100EC00013O0004C23O00EC00012O002C000100084O00DA00025O00202O0002000200374O000300093O00202O00030003000C4O00055O00202O0005000500374O0003000500024O000300036O00010003000200062O000100EC00013O0004C23O00EC00012O002C000100013O001299000200383O001299000300394O00E5000100034O001C2O016O002C00016O0006000200013O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200202O0001000100084O00010002000200062O0001002D05013O0004C23O002D05012O002C0001000F3O00068E0001002D05013O0004C23O002D05012O002C000100084O004300025O00202O0002000200364O000300093O00202O00030003000C4O00055O00202O0005000500364O0003000500024O000300036O00010003000200062O000100072O0100010004C23O00072O01002E12003D002D0501003C0004C23O002D05012O002C000100013O00128D0002003E3O00122O0003003F6O000100036O00015O00044O002D05010026573O00112O0100400004C23O00112O01002ECD004100A52O0100420004C23O00A52O01001299000100014O00F1000200023O000EA2000100132O0100010004C23O00132O01001299000200013O002E12004400432O0100430004C23O00432O010026A4000200432O0100020004C23O00432O01002ECD004600412O0100450004C23O00412O012O002C00036O0006000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300084O00030002000200062O000300412O013O0004C23O00412O012O002C0003000F3O00068E000300412O013O0004C23O00412O012O002C000300073O00207C0003000300304O00055O00202O0005000500494O00030005000200062O000300412O013O0004C23O00412O012O002C000300084O00DA00045O00202O0004000400364O000500093O00202O00050005000C4O00075O00202O0007000700364O0005000700024O000500056O00030005000200062O000300412O013O0004C23O00412O012O002C000300013O0012990004004A3O0012990005004B4O00E5000300054O001C01035O0012993O002A3O0004C23O00A52O01002EB8004C00D3FF2O004C0004C23O00162O010026A4000200162O0100010004C23O00162O01001299000300013O0026A40003004C2O0100020004C23O004C2O01001299000200023O0004C23O00162O010026A4000300482O0100010004C23O00482O012O002C00046O0006000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O0004000400084O00040002000200062O000400692O013O0004C23O00692O012O002C0004000F3O00068E000400692O013O0004C23O00692O012O002C000400093O00207C00040004004F4O00065O00202O0006000600334O00040006000200062O000400692O013O0004C23O00692O012O002C000400093O00205D0004000400344O00065O00202O0006000600334O00040006000200262O0004006B2O0100350004C23O006B2O01002E120050007E2O0100510004C23O007E2O01002EB800520013000100520004C23O007E2O012O002C000400084O00DA00055O00202O0005000500364O000600093O00202O00060006000C4O00085O00202O0008000800364O0006000800024O000600066O00040006000200062O0004007E2O013O0004C23O007E2O012O002C000400013O001299000500533O001299000600544O00E5000400064O001C01046O002C00046O0006000500013O00122O000600553O00122O000700566O0005000700024O00040004000500202O0004000400574O00040002000200062O000400A02O013O0004C23O00A02O012O002C000400103O00068E000400A02O013O0004C23O00A02O012O002C000400093O0020F60004000400584O00065O00202O0006000600594O0004000600024O000500113O00062O000400A02O0100050004C23O00A02O012O002C000400084O002C00055O00206C00050005005A2O00A90004000200020006B50004009B2O0100010004C23O009B2O01002ECD005C00A02O01005B0004C23O00A02O012O002C000400013O0012990005005D3O0012990006005E4O00E5000400064O001C01045O001299000300023O0004C23O00482O010004C23O00162O010004C23O00A52O010004C23O00132O010026573O00A92O0100350004C23O00A92O01002E12005F005F020100600004C23O005F0201001299000100014O00F1000200023O0026A4000100AB2O0100010004C23O00AB2O01001299000200013O002657000200B22O0100010004C23O00B22O01002ECD0061001E020100620004C23O001E0201001299000300013O0026A4000300B72O0100020004C23O00B72O01001299000200023O0004C23O001E0201002ECD006300B32O0100640004C23O00B32O010026A4000300B32O0100010004C23O00B32O012O002C00046O0006000500013O00122O000600653O00122O000700666O0005000700024O00040004000500202O0004000400084O00040002000200062O000400EF2O013O0004C23O00EF2O012O002C000400123O00068E000400EF2O013O0004C23O00EF2O012O002C00046O002F010500013O00122O000600673O00122O000700686O0005000700024O00040004000500202O0004000400694O000400020002000E2O006A00EF2O0100040004C23O00EF2O012O002C00046O0006000500013O00122O0006006B3O00122O0007006C6O0005000700024O00040004000500202O0004000400224O00040002000200062O000400EF2O013O0004C23O00EF2O01002ECD006E00EF2O01006D0004C23O00EF2O012O002C000400084O00DA00055O00202O00050005006F4O000600093O00202O00060006000C4O00085O00202O00080008006F4O0006000800024O000600066O00040006000200062O000400EF2O013O0004C23O00EF2O012O002C000400013O001299000500703O001299000600714O00E5000400064O001C01046O002C00046O0006000500013O00122O000600723O00122O000700736O0005000700024O00040004000500202O0004000400084O00040002000200062O0004001C02013O0004C23O001C02012O002C000400133O00068E0004001C02013O0004C23O001C02012O002C000400143O00068E0004002O02013O0004C23O002O02012O002C0004000C3O0006B500040005020100010004C23O000502012O002C000400143O0006B50004001C020100010004C23O001C02012O002C000400054O002C000500063O0006AF0004001C020100050004C23O001C0201002ECD0075001C020100740004C23O001C02012O002C000400084O00DA00055O00202O0005000500764O000600093O00202O00060006000C4O00085O00202O0008000800764O0006000800024O000600066O00040006000200062O0004001C02013O0004C23O001C02012O002C000400013O001299000500773O001299000600784O00E5000400064O001C01045O001299000300023O0004C23O00B32O010026A4000200AE2O0100020004C23O00AE2O012O002C00036O0006000400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003004502013O0004C23O004502012O002C000300153O00068E0003004502013O0004C23O004502012O002C000300073O00206E00030003000900122O000500026O00065O00202O0006000600764O00030006000200062O00030047020100010004C23O004702012O002C000300073O00206E00030003000900122O000500026O00065O00202O00060006006F4O00030006000200062O00030047020100010004C23O004702012O002C000300073O00206E00030003000900122O000500026O00065O00202O00060006007B4O00030006000200062O00030047020100010004C23O00470201002EB8007C00150001007D0004C23O005A0201002EB8007E00130001007E0004C23O005A02012O002C000300084O00DA00045O00202O00040004000A4O000500093O00202O00050005000C4O00075O00202O00070007000A4O0005000700024O000500056O00030005000200062O0003005A02013O0004C23O005A02012O002C000300013O0012990004007F3O001299000500804O00E5000300054O001C01035O0012993O00403O0004C23O005F02010004C23O00AE2O010004C23O005F02010004C23O00AB2O010026A43O0028030100020004C23O00280301001299000100014O00F1000200023O0026A400010063020100010004C23O00630201001299000200013O002ECD0082009E020100810004C23O009E0201000EA20002009E020100020004C23O009E02012O002C000300073O00207C0003000300834O00055O00202O0005000500374O00030005000200062O0003008902013O0004C23O008902012O002C000300073O0020050003000300842O00A90003000200020026A400030089020100010004C23O008902012O002C000300073O0020050003000300852O00A9000300020002000E1C006A0089020100030004C23O008902012O002C000300073O00207C0003000300304O00055O00202O00050005002F4O00030005000200062O0003008902013O0004C23O008902012O002C000300073O00209A00030003001E4O00055O00202O0005000500864O00030005000200062O0003008B020100010004C23O008B0201002E120088009C020100870004C23O009C02012O002C000300084O00DA000400163O00202O0004000400894O000500093O00202O00050005000C4O00075O00202O0007000700374O0005000700024O000500056O00030005000200062O0003009C02013O0004C23O009C02012O002C000300013O0012990004008A3O0012990005008B4O00E5000300054O001C01035O0012993O008C3O0004C23O00280301002EB8008D00C8FF2O008D0004C23O006602010026A400020066020100010004C23O006602012O002C00036O0006000400013O00122O0005008E3O00122O0006008F6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300CE02013O0004C23O00CE02012O002C000300173O00068E000300CE02013O0004C23O00CE02012O002C000300183O00068E000300B502013O0004C23O00B502012O002C000300043O0006B5000300B8020100010004C23O00B802012O002C000300183O0006B5000300CE020100010004C23O00CE02012O002C000300054O002C000400063O0006AF000300CE020100040004C23O00CE02012O002C00036O0006000400013O00122O000500903O00122O000600916O0004000600024O00030003000400202O0003000300114O00030002000200062O000300CE02013O0004C23O00CE02012O002C000300073O0020AA0003000300924O0003000200024O000400073O00202O0004000400934O00040002000200062O000300D0020100040004C23O00D00201002EB800940014000100950004C23O00E20201002EB800960012000100960004C23O00E202012O002C000300084O001400045O00202O0004000400974O000500093O00202O00050005002400122O000700256O0005000700024O000500056O00030005000200062O000300E202013O0004C23O00E202012O002C000300013O001299000400983O001299000500994O00E5000300054O001C01036O002C00036O0006000400013O00122O0005009A3O00122O0006009B6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003002403013O0004C23O002403012O002C0003000F3O00068E0003002403013O0004C23O002403012O002C00036O0006000400013O00122O0005009C3O00122O0006009D6O0004000600024O00030003000400202O0003000300114O00030002000200062O0003002403013O0004C23O002403012O002C000300073O0020050003000300922O00A9000300020002002680000300110301008C0004C23O001103012O002C000300073O00207F0003000300924O0003000200024O000400073O00202O0004000400934O00040002000200062O00030024030100040004C23O002403012O002C00036O00D0000400013O00122O0005009E3O00122O0006009F6O0004000600024O00030003000400202O0003000300164O0003000200022O002C000400113O0006D900040024030100030004C23O002403012O002C000300084O004300045O00202O0004000400364O000500093O00202O00050005000C4O00075O00202O0007000700364O0005000700024O000500056O00030005000200062O0003001F030100010004C23O001F0301002ECD00A10024030100A00004C23O002403012O002C000300013O001299000400A23O001299000500A34O00E5000300054O001C01035O001299000200023O0004C23O006602010004C23O002803010004C23O006302010026573O002C030100A40004C23O002C0301002ECD00A5001A040100A60004C23O001A0401001299000100014O00F1000200023O0026A40001002E030100010004C23O002E0301001299000200013O002E1200A70065030100A80004C23O00650301000EA200020065030100020004C23O00650301002ECD00AA0063030100A90004C23O006303012O002C00036O0006000400013O00122O000500AB3O00122O000600AC6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003006303013O0004C23O006303012O002C000300193O00068E0003006303013O0004C23O006303012O002C0003001A3O00068E0003004A03013O0004C23O004A03012O002C000300043O0006B50003004D030100010004C23O004D03012O002C0003001A3O0006B500030063030100010004C23O006303012O002C000300054O002C000400063O0006AF00030063030100040004C23O006303012O002C000300084O00A000045O00202O00040004007B4O000500093O00202O00050005000C4O00075O00202O00070007007B4O0005000700024O000500056O000600016O00030006000200062O0003006303013O0004C23O006303012O002C000300013O001299000400AD3O001299000500AE4O00E5000300054O001C01035O0012993O00353O0004C23O001A040100265700020069030100010004C23O00690301002ECD00B00031030100AF0004C23O00310301001299000300013O0026A400030010040100010004C23O001004012O002C00046O0006000500013O00122O000600B13O00122O000700B26O0005000700024O00040004000500202O0004000400084O00040002000200062O000400BE03013O0004C23O00BE03012O002C0004000E3O00068E000400BE03013O0004C23O00BE03012O002C00046O0006000500013O00122O000600B33O00122O000700B46O0005000700024O00040004000500202O0004000400224O00040002000200062O000400BE03013O0004C23O00BE03012O002C000400073O002O200004000400B54O00065O00202O0006000600B64O00040006000200262O000400BE030100B70004C23O00BE03012O002C0004001B3O00068E0004009203013O0004C23O009203012O002C000400073O0020050004000400B82O00A90004000200020006B5000400A3030100010004C23O00A303012O002C000400073O00207C0004000400304O00065O00202O0006000600314O00040006000200062O000400BE03013O0004C23O00BE03012O002C00046O008C000500013O00122O000600B93O00122O000700BA6O0005000700024O00040004000500202O0004000400164O00040002000200262O000400BE030100400004C23O00BE03012O002C00046O008C000500013O00122O000600BB3O00122O000700BC6O0005000700024O00040004000500202O0004000400164O00040002000200262O000400BE0301006A0004C23O00BE03012O002C000400084O00DA00055O00202O0005000500374O000600093O00202O00060006000C4O00085O00202O0008000800374O0006000800024O000600066O00040006000200062O000400BE03013O0004C23O00BE03012O002C000400013O001299000500BD3O001299000600BE4O00E5000400064O001C01046O002C00046O0006000500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O0004000400084O00040002000200062O000400FC03013O0004C23O00FC03012O002C0004000E3O00068E000400FC03013O0004C23O00FC03012O002C00046O0006000500013O00122O000600C13O00122O000700C26O0005000700024O00040004000500202O0004000400114O00040002000200062O000400FC03013O0004C23O00FC03012O002C000400073O00207C0004000400304O00065O00202O0006000600314O00040006000200062O000400FC03013O0004C23O00FC03012O002C00046O0006000500013O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O0004000400224O00040002000200062O000400FC03013O0004C23O00FC03012O002C000400073O00209A00040004001E4O00065O00202O00060006002F4O00040006000200062O000400F5030100010004C23O00F503012O002C000400073O0020B90004000400C54O00065O00202O00060006002F4O0004000600024O000500113O00062O000400FC030100050004C23O00FC03012O002C000400073O0020420004000400C600122O0006006A3O00122O000700356O00040007000200062O000400FE030100010004C23O00FE0301002E1200C7000F040100C80004C23O000F04012O002C000400084O00DA00055O00202O0005000500374O000600093O00202O00060006000C4O00085O00202O0008000800374O0006000800024O000600066O00040006000200062O0004000F04013O0004C23O000F04012O002C000400013O001299000500C93O001299000600CA4O00E5000400064O001C01045O001299000300023O00265700030014040100020004C23O00140401002ECD00CC006A030100CB0004C23O006A0301001299000200023O0004C23O003103010004C23O006A03010004C23O003103010004C23O001A04010004C23O002E03010026573O001E0401008C0004C23O001E0401002EB800CD00E5FB2O00CE0004C23O00010001001299000100014O00F1000200023O0026A400010020040100010004C23O00200401001299000200013O00265700020027040100010004C23O00270401002E1200D000C5040100CF0004C23O00C504012O002C00036O0006000400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400202O0003000300084O00030002000200062O0003007E04013O0004C23O007E04012O002C0003000E3O00068E0003007E04013O0004C23O007E04012O002C0003001B3O00068E0003007E04013O0004C23O007E04012O002C000300073O0020050003000300B82O00A900030002000200068E0003007E04013O0004C23O007E04012O002C000300073O00207C0003000300304O00055O00202O0005000500314O00030005000200062O0003007E04013O0004C23O007E04012O002C00036O008C000400013O00122O000500D33O00122O000600D46O0004000600024O00030003000400202O0003000300164O00030002000200262O0003007E040100400004C23O007E04012O002C000300073O00207C00030003001E4O00055O00202O00050005002F4O00030005000200062O0003007E04013O0004C23O007E04012O002C000300073O00209A00030003001E4O00055O00202O0005000500864O00030005000200062O00030064040100010004C23O006404012O002C000300073O00200F0103000300C54O00055O00202O0005000500864O0003000500024O000400113O00202O00040004002A00062O0003007E040100040004C23O007E04012O002C000300073O0020620003000300C600122O000500D53O00122O000600356O00030006000200062O0003007E04013O0004C23O007E0401002EB8007E00130001007E0004C23O007E04012O002C000300084O00DA00045O00202O0004000400374O000500093O00202O00050005000C4O00075O00202O0007000700374O0005000700024O000500056O00030005000200062O0003007E04013O0004C23O007E04012O002C000300013O001299000400D63O001299000500D74O00E5000300054O001C01036O002C00036O0006000400013O00122O000500D83O00122O000600D96O0004000600024O00030003000400202O0003000300084O00030002000200062O000300B104013O0004C23O00B104012O002C0003000F3O00068E000300B104013O0004C23O00B104012O002C0003001B3O00068E000300B104013O0004C23O00B104012O002C00036O0006000400013O00122O000500DA3O00122O000600DB6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300B104013O0004C23O00B104012O002C000300073O0020050003000300B82O00A900030002000200068E000300B104013O0004C23O00B104012O002C000300073O0020050003000300DC2O00A90003000200022O002C0004001C3O0006D9000400B1040100030004C23O00B104012O002C000300073O00205E0003000300C54O00055O00202O0005000500DD4O000300050002000E2O00DE00B1040100030004C23O00B104012O002C000300073O0020620003000300C600122O0005006A3O00122O000600356O00030006000200062O000300B304013O0004C23O00B30401002EB800DF0013000100E00004C23O00C404012O002C000300084O00DA00045O00202O0004000400364O000500093O00202O00050005000C4O00075O00202O0007000700364O0005000700024O000500056O00030005000200062O000300C404013O0004C23O00C404012O002C000300013O001299000400E13O001299000500E24O00E5000300054O001C01035O001299000200023O0026A400020023040100020004C23O002304012O002C00036O0006000400013O00122O000500E33O00122O000600E46O0004000600024O00030003000400202O0003000300084O00030002000200062O0003001205013O0004C23O001205012O002C0003000E3O00068E0003001205013O0004C23O001205012O002C0003001B3O00068E0003001205013O0004C23O001205012O002C000300073O0020050003000300B82O00A900030002000200068E0003001205013O0004C23O001205012O002C000300073O00207C0003000300304O00055O00202O0005000500314O00030005000200062O0003001205013O0004C23O001205012O002C000300073O0020550003000300B54O00055O00202O0005000500314O000300050002000E2O008C0012050100030004C23O001205012O002C00036O008C000400013O00122O000500E53O00122O000600E66O0004000600024O00030003000400202O0003000300164O00030002000200262O00030012050100400004C23O001205012O002C000300073O00207C00030003001E4O00055O00202O00050005002F4O00030005000200062O0003001205013O0004C23O001205012O002C000300073O00209A00030003001E4O00055O00202O0005000500864O00030005000200062O0003000B050100010004C23O000B05012O002C000300073O00200F0103000300C54O00055O00202O0005000500864O0003000500024O000400113O00202O00040004002A00062O00030012050100040004C23O001205012O002C000300073O0020620003000300C600122O0005006A3O00122O000600356O00030006000200062O0003001405013O0004C23O00140501002ECD00E70027050100E80004C23O00270501002ECD00EA0027050100E90004C23O002705012O002C000300084O00DA00045O00202O0004000400374O000500093O00202O00050005000C4O00075O00202O0007000700374O0005000700024O000500056O00030005000200062O0003002705013O0004C23O002705012O002C000300013O001299000400EB3O001299000500EC4O00E5000300054O001C01035O0012993O00A43O0004C23O000100010004C23O002304010004C23O000100010004C23O002004010004C23O000100012O00093O00017O00CB3O00028O00025O0010A240025O0070AD40026O00F03F025O00E8B140025O0091B040025O00DC9A40025O00049C40025O0060A240025O0030B240025O0032A140025O00B4B240025O00A08340030E3O00FBF974E985C2F7E264FB82CBDFF803063O00A7BA8B1788EB030A3O0049734361737461626C65030B3O00426C2O6F646C757374557003063O0042752O66557003103O00436C65617263617374696E6742752O6603093O0042752O66537461636B027O0040030C3O0028B48C041BBB9C3E0AB49A0603043O006D7AD5E8030F3O00432O6F6C646F776E52656D61696E73026O00144003083O0042752O66446F776E03133O004E6574686572507265636973696F6E42752O66030B3O0042752O6652656D61696E7303133O00417263616E65417274692O6C65727942752O66026O001840030E3O00417263616E654D692O73696C6573030E3O0049735370652O6C496E52616E6765031E3O00EFE5A131E0F29D3DE7E4B139E2F2B170FDE7A322E5C8B238EFE4A770BFA703043O00508E97C2030E3O0022D4744D0DC35A4510D57E4006D503043O002C63A61703073O0049735265616479030D3O005DE52A373DA154F62O3B3CAA6503063O00C41C97495653030B3O004973417661696C61626C6503113O00417263616E654861726D6F6E7942752O66026O002E40030C3O00C1022D1983560C45E3023B1B03083O001693634970E23878030B3O009967E1F483BD46F7E78ABD03053O00EDD8158295026O003E40025O00C07440025O0044A840031E3O00832O5C5EBECC618F472O4CB9C55B910E4C4FB1DB55BD5E575EA3CC1ED31C03073O003EE22E2O3FD0A9030C3O00D718518A1E033B6DF518478803083O003E857935E37F6D4F030C3O0052616469616E74537061726B025O00909A40025O00489440031C3O00021536FCD7A0B62F0722F4C4A5E2030433E7DD91B2181521F096FFF603073O00C270745295B6CE030D3O0017AD5810C5F03A3CA55C1DD3F603073O006E59C82C78A082030D3O0085C65F4E46580F48A6D34E555703083O002DCBA32B26232A5B03113O0054696D6553696E63654C6173744361737403083O005072657647434450026O001040030B3O00F397DF2289AC67C797DB2603073O0034B2E5BC43E7C9030D3O000F2O440CF24E17244C4001E44803073O004341213064973C030B3O004578656375746554696D65025O0044A040030D3O004E657468657254656D70657374031D3O00D1E2BAD0F6CDD8BADDFECFE2BDCCB3CCF7AFCAF8E0F7A6D9E0DAA7FF8E03053O0093BF87CEB8025O0020A840025O0094A140025O00F5B240025O00C08C40025O00749040025O0075B240030B3O00A53AA5C0D65681913AA1C403073O00D2E448C6A1B833030D3O00184CE71876DC024CFE0076DD2203063O00AE5629937013025O00F6A140025O00C08A40030B3O00417263616E655375726765031B3O005A128E0A2B0A2EB84E128A0E651C01AA490BB21B2D0E02AE1B51D503083O00CB3B60ED6B456F71030B3O000504AFE03F2OF52817BFF503073O00B74476CC815190030B3O002FBF73E505872CA171F71F03063O00E26ECD10846B03083O004361737454696D652O033O00474344030B3O00CAD1E3D84FEEE1ECD852FF03053O00218BA380B9030D3O00446562752O6652656D61696E7303193O0052616469616E74537061726B56756C6E65726162696C69747903113O00764A07DF595D26D12O5A05CC535501D04303043O00BE37386403103O004865616C746850657263656E74616765025O00804140030D3O0078AA282O16F1C753A22C1B00F703073O009336CF5C7E7383030D3O0023342175086C3934386D086D1903063O001E6D51551D6D03093O00497343617374696E67030B3O004361737452656D61696E73026O00E03F030B3O00417263616E65426C617374025O00B09540026O005B40031B3O00FE6357B738DBC3FD7D55A5229E2OEF7046BD09CEF4FE6251F6648E03073O009C9F1134D656BE025O004DB040025O008CA340030D3O008FFDBEBDA0EA9FBDBCFDBCBBAB03043O00DCCE8FDD030B3O00446562752O66537461636B025O00988A40025O004CA540030D3O00417263616E6542612O72616765031D3O00876F2E16D6C9ED847C3F05D9CBD7C66E3D16CAC7ED96752C04DD8C80D403073O00B2E61D4D77B8AC030E3O00C1B11F187FF7F3AA021E5AF9F2B703063O009895DE6A7B17030D3O00FC34F542BBD804F751A7DC21F303053O00D5BD46962303083O00496E466C69676874030D3O006E477709415056095D47750F4A03043O00682F3514030A3O0054726176656C54696D65030D3O00825E821DB20A814D930EBD08A603063O006FC32CE17CDC029A5O99C93F030A3O0047434452656D61696E73030E3O00546F7563686F667468654D616769025O0010AB40025O00206D4003203O00CC491570A394D7403F67A3AEE74B0174A2EBCB560161A094C84E0160AEEB8A1203063O00CBB8266013CB025O00A07840025O00806F40026O000840025O00CEAC40025O00488740025O0048A740025O00ECA340030E3O00CDBA00C552E9850AD74FE5A406D703053O003C8CC863A4030C3O00B5F5002FA389E03736A395FF03053O00C2E794644603073O0048617354696572026O003F40031D3O00475EC2A2F8CD7941C8B0E5C14A49D2E3E5D8475ECA9CE6C0475FC4E3A203063O00A8262CA1C396030B3O00A1EE81773EED941A81EF9603083O0076E09CE2165088D6030B3O0063FC5A814CEB6A9550E95C03043O00E0228E39030A3O00432O6F6C646F776E557003043O004D616E61030F3O00536970686F6E53746F726D42752O66025O00608A40025O00B2AA40031A3O00DFB5C6DC7DF4620CD2A6D6C933E24D0FCCACFACD7BF04E0B9EF103083O006EBEC7A5BD13913D025O00A88340025O0092AD40025O004EA540025O00AEA240030D3O002E7616774E1CBE057E127A581A03073O00EA6013621F2B6E030D3O00281A46CFA960BF031242C2BF6603073O00EB667F32A7CC12025O00804640030A3O00446562752O66446F776E03133O004E657468657254656D70657374446562752O66031C3O005EA4E12B413C6FB5F02E542B432OB530542F42AACA334C2F43A4B57103063O004E30C1954324030C3O0049734368612O6E656C696E67025O001EAF40025O009C9440025O00BC9840025O00ACAA40030B3O0053746F7043617374696E6703273O00310C83194F35218D115223178C1D5270178E0C44220C950855700D9019533B21901040231BC04C03053O0021507EE078026O006C40025O00DAA840030B3O0018617A40C03C517540DD2D03053O00AE59131921031B3O002E00514FF982342D1E535DE3C7183F134045C897032E01570EA5D103073O006B4F72322E97E7025O005EAD40025O006C9440030D3O0018B4B628843C95C12B2OB42E8F03083O00A059C6D549EA59D7025O00409440025O00C09B40031D3O004963B7FFCB4D4EB6FFD75A70B3FB855B61B5ECCE7761BCFFD64D31E6A603053O00A52811D49E0030042O0012993O00014O00F1000100023O0026573O0006000100010004C23O00060001002E1200030009000100020004C23O00090001001299000100014O00F1000200023O0012993O00043O0026573O000D000100040004C23O000D0001002E1200050002000100060004C23O0002000100265700010011000100010004C23O00110001002ECD0008000D000100070004C23O000D0001001299000200013O0026A40002005D2O0100040004C23O005D2O01001299000300014O00F1000400043O0026A400030016000100010004C23O00160001001299000400013O0026A4000400CC000100010004C23O00CC0001001299000500013O00265700050020000100040004C23O00200001002EB8000900040001000A0004C23O00220001001299000400043O0004C23O00CC000100265700050026000100010004C23O00260001002E12000C001C0001000B0004C23O001C0001002EB8000D00500001000D0004C23O007600012O002C00066O0006000700013O00122O0008000E3O00122O0009000F6O0007000900024O00060006000700202O0006000600104O00060002000200062O0006007600013O0004C23O007600012O002C000600023O00068E0006007600013O0004C23O007600012O002C000600033O00068E0006007600013O0004C23O007600012O002C000600043O0020050006000600112O00A900060002000200068E0006007600013O0004C23O007600012O002C000600043O00207C0006000600124O00085O00202O0008000800134O00060008000200062O0006007600013O0004C23O007600012O002C000600043O0020550006000600144O00085O00202O0008000800134O000600080002000E2O00150076000100060004C23O007600012O002C00066O008C000700013O00122O000800163O00122O000900176O0007000900024O00060006000700202O0006000600184O00060002000200262O00060076000100190004C23O007600012O002C000600043O00207C00060006001A4O00085O00202O00080008001B4O00060008000200062O0006007600013O0004C23O007600012O002C000600043O00200F01060006001C4O00085O00202O00080008001D4O0006000800024O000700053O00202O00070007001E00062O00060076000100070004C23O007600012O002C000600064O00DA00075O00202O00070007001F4O000800073O00202O0008000800204O000A5O00202O000A000A001F4O0008000A00024O000800086O00060008000200062O0006007600013O0004C23O007600012O002C000600013O001299000700213O001299000800224O00E5000600084O001C01066O002C00066O0006000700013O00122O000800233O00122O000900246O0007000900024O00060006000700202O0006000600254O00060002000200062O000600CA00013O0004C23O00CA00012O002C000600023O00068E000600CA00013O0004C23O00CA00012O002C00066O0006000700013O00122O000800263O00122O000900276O0007000900024O00060006000700202O0006000600284O00060002000200062O000600CA00013O0004C23O00CA00012O002C000600043O002O200006000600144O00085O00202O0008000800294O00060008000200262O000600CA0001002A0004C23O00CA00012O002C000600033O00068E0006009C00013O0004C23O009C00012O002C000600043O0020050006000600112O00A90006000200020006B5000600AD000100010004C23O00AD00012O002C000600043O00207C0006000600124O00085O00202O0008000800134O00060008000200062O000600CA00013O0004C23O00CA00012O002C00066O008C000700013O00122O0008002B3O00122O0009002C6O0007000900024O00060006000700202O0006000600184O00060002000200262O000600CA000100190004C23O00CA00012O002C00066O008C000700013O00122O0008002D3O00122O0009002E6O0007000900024O00060006000700202O0006000600184O00060002000200262O000600CA0001002F0004C23O00CA0001002E12003000CA000100310004C23O00CA00012O002C000600064O00DA00075O00202O00070007001F4O000800073O00202O0008000800204O000A5O00202O000A000A001F4O0008000A00024O000800086O00060008000200062O000600CA00013O0004C23O00CA00012O002C000600013O001299000700323O001299000800334O00E5000600084O001C01065O001299000500043O0004C23O001C0001000EA2000400562O0100040004C23O00562O01001299000500013O0026A4000500D3000100040004C23O00D30001001299000400153O0004C23O00562O01000EA2000100CF000100050004C23O00CF00012O002C00066O0006000700013O00122O000800343O00122O000900356O0007000900024O00060006000700202O0006000600254O00060002000200062O000600022O013O0004C23O00022O012O002C000600083O00068E000600022O013O0004C23O00022O012O002C000600093O00068E000600E800013O0004C23O00E800012O002C0006000A3O0006B5000600EB000100010004C23O00EB00012O002C000600093O0006B5000600022O0100010004C23O00022O012O002C0006000B4O002C0007000C3O0006AF000600022O0100070004C23O00022O012O002C000600064O004300075O00202O0007000700364O000800073O00202O0008000800204O000A5O00202O000A000A00364O0008000A00024O000800086O00060008000200062O000600FD000100010004C23O00FD0001002ECD003700022O0100380004C23O00022O012O002C000600013O001299000700393O0012990008003A4O00E5000600084O001C01066O002C00066O0006000700013O00122O0008003B3O00122O0009003C6O0007000900024O00060006000700202O0006000600254O00060002000200062O000600542O013O0004C23O00542O012O002C0006000D3O00068E000600542O013O0004C23O00542O012O002C0006000E3O0006B5000600542O0100010004C23O00542O012O002C00066O002F010700013O00122O0008003D3O00122O0009003E6O0007000900024O00060006000700202O00060006003F4O000600020002000E2O002A00542O0100060004C23O00542O012O002C0006000E3O0006B5000600392O0100010004C23O00392O012O002C000600043O00200E00060006004000122O000800416O00095O00202O0009000900364O00060009000200062O000600392O013O0004C23O00392O012O002C00066O00D0000700013O00122O000800423O00122O000900436O0007000900024O00060006000700202O0006000600184O0006000200022O002C00076O00D0000800013O00122O000900443O00122O000A00456O0008000A00024O00070007000800202O0007000700464O00070002000200063F01060009000100070004C23O00412O012O002C000600043O00200E00060006004000122O000800196O00095O00202O0009000900364O00060009000200062O000600542O013O0004C23O00542O01002EB800470013000100470004C23O00542O012O002C000600064O00DA00075O00202O0007000700484O000800073O00202O0008000800204O000A5O00202O000A000A00484O0008000A00024O000800086O00060008000200062O000600542O013O0004C23O00542O012O002C000600013O001299000700493O0012990008004A4O00E5000600084O001C01065O001299000500043O0004C23O00CF00010026A400040019000100150004C23O00190001001299000200153O0004C23O005D2O010004C23O001900010004C23O005D2O010004C23O00160001002E12004C00CA0201004B0004C23O00CA02010026A4000200CA020100150004C23O00CA0201001299000300014O00F1000400043O002657000300672O0100010004C23O00672O01002ECD004D00632O01004E0004C23O00632O01001299000400013O002ECD004F003E020100500004C23O003E02010026A40004003E020100010004C23O003E02012O002C00056O0006000600013O00122O000700513O00122O000800526O0006000800024O00050005000600202O0005000500254O00050002000200062O000500AB2O013O0004C23O00AB2O012O002C0005000F3O00068E000500AB2O013O0004C23O00AB2O012O002C000500103O00068E0005007F2O013O0004C23O007F2O012O002C000500113O0006B5000500822O0100010004C23O00822O012O002C000500103O0006B5000500AB2O0100010004C23O00AB2O012O002C0005000B4O002C0006000C3O0006AF000500AB2O0100060004C23O00AB2O012O002C00056O00A7000600013O00122O000700533O00122O000800546O0006000800024O00050005000600202O0005000500284O00050002000200062O000500A32O0100010004C23O00A32O012O002C000500043O00200E00050005004000122O000700416O00085O00202O0008000800364O00050008000200062O0005009B2O013O0004C23O009B2O012O002C0005000E3O00068E000500AD2O013O0004C23O00AD2O012O002C000500043O00206E00050005004000122O000700196O00085O00202O0008000800364O00050008000200062O000500AD2O0100010004C23O00AD2O012O002C000500043O00206E00050005004000122O000700046O00085O00202O0008000800484O00050008000200062O000500AD2O0100010004C23O00AD2O01002ECD005500BE2O0100560004C23O00BE2O012O002C000500064O00DA00065O00202O0006000600574O000700073O00202O0007000700204O00095O00202O0009000900574O0007000900024O000700076O00050007000200062O000500BE2O013O0004C23O00BE2O012O002C000500013O001299000600583O001299000700594O00E5000500074O001C01056O002C00056O0006000600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500254O00050002000200062O0005003D02013O0004C23O003D02012O002C000500123O00068E0005003D02013O0004C23O003D02012O002C00056O00D0000600013O00122O0007005C3O00122O0008005D6O0006000800024O00050005000600202O00050005005E4O0005000200022O002C000600043O00200500060006005F2O00A90006000200020006D90006003D020100050004C23O003D02012O002C00056O0021000600013O00122O000700603O00122O000800616O0006000800024O00050005000600202O0005000500464O0005000200024O000600073O00202O0006000600624O00085O00202O0008000800634O00060008000200062O0005003D020100060004C23O003D02012O002C00056O0006000600013O00122O000700643O00122O000800656O0006000800024O00050005000600202O0005000500284O00050002000200062O000500F62O013O0004C23O00F62O012O002C000500073O0020050005000500662O00A9000500020002000EE00067003D020100050004C23O003D02012O002C00056O0006000600013O00122O000700683O00122O000800696O0006000800024O00050005000600202O0005000500284O00050002000200062O0005000802013O0004C23O000802012O002C000500043O00206E00050005004000122O0007001E6O00085O00202O0008000800364O00050008000200062O0005001A020100010004C23O001A02012O002C00056O00A7000600013O00122O0007006A3O00122O0008006B6O0006000800024O00050005000600202O0005000500284O00050002000200062O0005003D020100010004C23O003D02012O002C000500043O00200E00050005004000122O000700196O00085O00202O0008000800364O00050008000200062O0005003D02013O0004C23O003D02012O002C000500043O00207C00050005006C4O00075O00202O0007000700574O00050007000200062O0005002A02013O0004C23O002A02012O002C000500043O00200500050005006D2O00A90005000200020026350005002A0201006E0004C23O002A02012O002C0005000E4O0071000500053O0006B50005003D020100010004C23O003D02012O002C000500064O004300065O00202O00060006006F4O000700073O00202O0007000700204O00095O00202O00090009006F4O0007000900024O000700076O00050007000200062O00050038020100010004C23O00380201002EB800700007000100710004C23O003D02012O002C000500013O001299000600723O001299000700734O00E5000500074O001C01055O001299000400043O002ECD007500C1020100740004C23O00C102010026A4000400C1020100040004C23O00C102012O002C00056O0006000600013O00122O000700763O00122O000800776O0006000800024O00050005000600202O0005000500254O00050002000200062O0005005602013O0004C23O005602012O002C000500133O00068E0005005602013O0004C23O005602012O002C000500073O0020C30005000500784O00075O00202O0007000700634O00050007000200262O00050058020100410004C23O00580201002E12007A0069020100790004C23O006902012O002C000500064O00DA00065O00202O00060006007B4O000700073O00202O0007000700204O00095O00202O00090009007B4O0007000900024O000700076O00050007000200062O0005006902013O0004C23O006902012O002C000500013O0012990006007C3O0012990007007D4O00E5000500074O001C01056O002C00056O0006000600013O00122O0007007E3O00122O0008007F6O0006000800024O00050005000600202O0005000500254O00050002000200062O000500C002013O0004C23O00C002012O002C000500143O00068E000500C002013O0004C23O00C002012O002C000500153O00068E0005007C02013O0004C23O007C02012O002C0005000A3O0006B50005007F020100010004C23O007F02012O002C000500153O0006B5000500C0020100010004C23O00C002012O002C0005000B4O002C0006000C3O0006AF000500C0020100060004C23O00C002012O002C000500043O00200E00050005004000122O000700046O00085O00202O00080008007B4O00050008000200062O000500C002013O0004C23O00C002012O002C00056O0006000600013O00122O000700803O00122O000800816O0006000800024O00050005000600202O0005000500824O00050002000200062O000500A802013O0004C23O00A802012O002C00056O00D0000600013O00122O000700833O00122O000800846O0006000800024O00050005000600202O0005000500854O0005000200022O002C00066O00D0000700013O00122O000800863O00122O000900876O0007000900024O00060006000700202O00060006003F4O0006000200022O00A8000500050006002692000500AD020100880004C23O00AD02012O002C000500043O0020050005000500892O00A900050002000200263A000500C0020100880004C23O00C002012O002C000500064O004300065O00202O00060006008A4O000700073O00202O0007000700204O00095O00202O00090009008A4O0007000900024O000700076O00050007000200062O000500BB020100010004C23O00BB0201002ECD008B00C00201008C0004C23O00C002012O002C000500013O0012990006008D3O0012990007008E4O00E5000500074O001C01055O001299000400153O000ED1001500C5020100040004C23O00C50201002ECD008F00682O0100900004C23O00682O01001299000200913O0004C23O00CA02010004C23O00682O010004C23O00CA02010004C23O00632O01002657000200CE020100010004C23O00CE0201002EB8009200192O0100930004C23O00E50301001299000300013O000ED1000400D3020100030004C23O00D30201002E1200940070030100950004C23O00700301001299000400013O000EA2000400D8020100040004C23O00D80201001299000300153O0004C23O007003010026A4000400D4020100010004C23O00D402012O002C00056O0006000600013O00122O000700963O00122O000800976O0006000800024O00050005000600202O0005000500104O00050002000200062O0005002F03013O0004C23O002F03012O002C000500023O00068E0005002F03013O0004C23O002F03012O002C000500033O00068E0005002F03013O0004C23O002F03012O002C000500043O0020050005000500112O00A900050002000200068E0005002F03013O0004C23O002F03012O002C000500043O00207C0005000500124O00075O00202O0007000700134O00050007000200062O0005002F03013O0004C23O002F03012O002C00056O008C000600013O00122O000700983O00122O000800996O0006000800024O00050005000600202O0005000500184O00050002000200262O0005002F030100190004C23O002F03012O002C000500043O00207C00050005001A4O00075O00202O00070007001B4O00050007000200062O0005002F03013O0004C23O002F03012O002C000500043O00209A00050005001A4O00075O00202O00070007001D4O00050007000200062O00050017030100010004C23O001703012O002C000500043O00200F01050005001C4O00075O00202O00070007001D4O0005000700024O000600053O00202O00060006001E00062O0005002F030100060004C23O002F03012O002C000500043O00206200050005009A00122O0007009B3O00122O000800416O00050008000200062O0005002F03013O0004C23O002F03012O002C000500064O00DA00065O00202O00060006001F4O000700073O00202O0007000700204O00095O00202O00090009001F4O0007000900024O000700076O00050007000200062O0005002F03013O0004C23O002F03012O002C000500013O0012990006009C3O0012990007009D4O00E5000500074O001C01056O002C00056O0006000600013O00122O0007009E3O00122O0008009F6O0006000800024O00050005000600202O0005000500254O00050002000200062O0005006E03013O0004C23O006E03012O002C000500123O00068E0005006E03013O0004C23O006E03012O002C000500033O00068E0005006E03013O0004C23O006E03012O002C00056O0006000600013O00122O000700A03O00122O000800A16O0006000800024O00050005000600202O0005000500A24O00050002000200062O0005006E03013O0004C23O006E03012O002C000500043O0020050005000500112O00A900050002000200068E0005006E03013O0004C23O006E03012O002C000500043O0020050005000500A32O00A90005000200022O002C000600163O0006D90006006E030100050004C23O006E03012O002C000500043O00205E00050005001C4O00075O00202O0007000700A44O000500070002000E2O002A006E030100050004C23O006E0301002E1200A5006E030100A60004C23O006E03012O002C000500064O00DA00065O00202O00060006006F4O000700073O00202O0007000700204O00095O00202O00090009006F4O0007000900024O000700076O00050007000200062O0005006E03013O0004C23O006E03012O002C000500013O001299000600A73O001299000700A84O00E5000500074O001C01055O001299000400043O0004C23O00D40201002E1200A90076030100AA0004C23O00760301000EA200150076030100030004C23O00760301001299000200043O0004C23O00E50301002E1200AC00CF020100AB0004C23O00CF02010026A4000300CF020100010004C23O00CF02012O002C00046O0006000500013O00122O000600AD3O00122O000700AE6O0005000700024O00040004000500202O0004000400254O00040002000200062O000400B103013O0004C23O00B103012O002C0004000D3O00068E000400B103013O0004C23O00B103012O002C00046O002F010500013O00122O000600AF3O00122O000700B06O0005000700024O00040004000500202O00040004003F4O000400020002000E2O00B100B1030100040004C23O00B103012O002C000400073O00207C0004000400B24O00065O00202O0006000600B34O00040006000200062O000400B103013O0004C23O00B103012O002C000400033O00068E000400B103013O0004C23O00B103012O002C000400043O0020050004000400112O00A900040002000200068E000400B103013O0004C23O00B103012O002C000400064O00DA00055O00202O0005000500484O000600073O00202O0006000600204O00085O00202O0008000800484O0006000800024O000600066O00040006000200062O000400B103013O0004C23O00B103012O002C000400013O001299000500B43O001299000600B54O00E5000400064O001C01046O002C000400033O00068E000400CE03013O0004C23O00CE03012O002C000400043O00207C0004000400B64O00065O00202O00060006001F4O00040006000200062O000400CE03013O0004C23O00CE03012O002C000400043O0020050004000400892O00A90004000200020026A4000400CE030100010004C23O00CE03012O002C000400043O00207C0004000400124O00065O00202O00060006001B4O00040006000200062O000400CE03013O0004C23O00CE03012O002C000400043O00209A00040004001A4O00065O00202O00060006001D4O00040006000200062O000400D0030100010004C23O00D00301002EB800B70015000100B80004C23O00E30301002ECD00B900E3030100BA0004C23O00E303012O002C000400064O00DA000500173O00202O0005000500BB4O000600073O00202O0006000600204O00085O00202O00080008001F4O0006000800024O000600066O00040006000200062O000400E303013O0004C23O00E303012O002C000400013O001299000500BC3O001299000600BD4O00E5000400064O001C01045O001299000300043O0004C23O00CF02010026A400020012000100910004C23O00120001002E1200BE0007040100BF0004C23O000704012O002C00036O0006000400013O00122O000500C03O00122O000600C16O0004000600024O00030003000400202O0003000300254O00030002000200062O0003000704013O0004C23O000704012O002C000300123O00068E0003000704013O0004C23O000704012O002C000300064O00DA00045O00202O00040004006F4O000500073O00202O0005000500204O00075O00202O00070007006F4O0005000700024O000500056O00030005000200062O0003000704013O0004C23O000704012O002C000300013O001299000400C23O001299000500C34O00E5000300054O001C01035O002ECD00C5002F040100C40004C23O002F04012O002C00036O0006000400013O00122O000500C63O00122O000600C76O0004000600024O00030003000400202O0003000300254O00030002000200062O0003002F04013O0004C23O002F04012O002C000300133O00068E0003002F04013O0004C23O002F04012O002C000300064O004300045O00202O00040004007B4O000500073O00202O0005000500204O00075O00202O00070007007B4O0005000700024O000500056O00030005000200062O00030024040100010004C23O00240401002E1200C9002F040100C80004C23O002F04012O002C000300013O00128D000400CA3O00122O000500CB6O000300056O00035O00044O002F04010004C23O001200010004C23O002F04010004C23O000D00010004C23O002F04010004C23O000200012O00093O00017O008B3O00028O00026O00F03F025O00409340025O0072A940027O0040030C3O00FA5B0A2418D6BBB0D85B1C2603083O00E3A83A6E4D79B8CF03073O0049735265616479025O000C9140025O00FAA240030C3O0052616469616E74537061726B030E3O0049735370652O6C496E52616E6765031F3O00693DBB49B0D5659A682CBE52BA9B70AA7E03AC50B0C97A9A6B34BE53B49B2503083O00C51B5CDF20D1BB11025O00389740025O00B8AE4003093O00224DC0FA0D5AECE90103043O009B633FA303093O00A3C3A28CB781ADC3A303063O00E4E2B1C1EDD903113O0054696D6553696E63654C61737443617374026O002E40030D3O00417263616E6543686172676573026O00084003093O00417263616E654F726203093O004973496E52616E6765026O004440031C3O0035A220E73AB51CE926B263E73BB51CF524B131ED0BA02BE727B563B003043O008654D043025O00208440025O00A08440025O00309240025O009C9040025O00CEB140025O00F07F4003063O0042752O66557003123O0050726573656E63656F664D696E6442752O6603083O005072657647434450030B3O00417263616E65426C617374030F3O00432O6F6C646F776E52656D61696E73030B3O00417263616E655375726765025O00C05240025O003CA840026O005F4003093O0043616E63656C504F4D03293O00E6D8063023E999182123F6DC063023DAD60E0C2BECD70C7327EADC372036E4CB030C36EDD81B3666B403053O004685B96853030E3O00304A5129C10B435022CC2944432303053O00A96425244A030D3O00417263616E6542612O72616765030E3O00546F7563686F667468654D61676903233O001488B75308B8AD563F93AA553F8AA35709C7A35F05B8B1400195A96F108FA34305C7F003043O003060E7C2025O0060A140025O00207F40025O00B88440025O00FEA640030D3O003DA9925416BEB2591EBC834F0703043O003C73CCE6030D3O00C93FFF78E228DF75EA2AEE63F303043O0010875A8B030A3O007566053240515D577C0903073O0018341466532E34030B3O004973417661696C61626C65030D3O004E657468657254656D7065737403203O00CA2A352C0AD610352102D42A32304FC520241B1CD42E332F30D42720370A847703053O006FA44F4144030B3O00E7CB80DF20EFF5CC91D92B03063O008AA6B9E3BE4E025O005CA040025O0008A240031F3O00CA66C6365C2O26D861D730576318C471FA2442220BC04BD53F53301C8B259503073O0079AB14A5573243025O00249240025O00288240030D3O00E72ABA37B707E439AB24B805C303063O0062A658D956D9030B3O00D7E47A0088D9C5E36B068303063O00BC2O961961E6030B3O00446562752O66537461636B03193O0052616469616E74537061726B56756C6E65726162696C697479026O001040030A3O00F59B5D200DFFC888580703063O008DBAE93F626C03213O00F0F82FB72BF4D52EB737E3EB2BB365F0E5298936E1EB3EBD1AE1E22DA520B1BB7E03053O0045918A4CD6030D3O0051DD8A88B11352CE2O9BBE117503063O007610AF2OE9DF030B3O00AA9636BAE08E4E9E9632BE03073O001DEBE455DB8EEB030B3O001CC6B9DC794B14472FD3BF03083O00325DB4DABD172E47030A3O00F1B6596E45CE5ADFA35E03073O0028BEC43B2C24BC025O00EAAF40025O00C4954003213O003D57DFB5F478323E44CEA6FB7A087C44D3B1C56E1D3D57D78BEA750C2F409CE5AE03073O006D5C25BCD49A1D025O00E5B140025O00E6AC40025O00B08840025O00BAAF40030D3O0025FDA7C23F5F26EEB6D1305D0103063O003A648FC4A351026O00144003103O00417263616E65436861726765734D6178030A3O00355021813E5BF70F1D4703083O006E7A2243C35F298503213O0074A3584BD8708E594BC467B05C4F9674BE5E75C565B04941E965B95A59D335E00D03053O00B615D13B2A030E3O008745C00E24B0B452CA1B0CB7B95303063O00DED737A57D41030A3O0049734361737461626C65030E3O0050726573656E63656F664D696E64025O00308540025O00B0714003233O003C2OC309F7CFEE4F13DEC025FFC8E34E6CD0C91FCDD2FD4B3EDAF90AFAC0FE4F6C809E03083O002A4CB1A67A92A18D030B3O00849806CF7773878604DD6D03063O0016C5EA65AE19030A3O000226A7FE77BDC5872A3103083O00E64D54C5BC16CFB703083O00446562752O665570030A3O00D606C4DE8DB3E234FE1103083O00559974A69CECC190031F3O00A5F24EB2EA059BE241B2F714E4E142B6DB13B4E15FB8DB10ACE15EB6A452F403063O0060C4802DD384030D3O00149F785EDCAA96D9279F7A58D703083O00B855ED1B3FB2CFD4030F3O00417263616E65537572676542752O6603083O0042752O66446F776E030A3O00274B0B7D094B1B5E0F5C03043O003F683969025O0024B340025O00E2A24003213O000A95A74505829B460A95B6450C82E44504829B571B86B64F3497AC451882E4165903043O00246BE7C4025O00609740025O008BB2400008032O0012993O00014O00F1000100023O0026573O0006000100020004C23O00060001002E12000400FF020100030004C23O00FF02010026A400010006000100010004C23O00060001001299000200013O0026A4000200F5000100010004C23O00F50001001299000300014O00F1000400043O0026A40003000D000100010004C23O000D0001001299000400013O0026A400040014000100050004C23O00140001001299000200023O0004C23O00F500010026A400040088000100020004C23O00880001001299000500013O0026A400050083000100010004C23O008300012O002C00066O0006000700013O00122O000800063O00122O000900076O0007000900024O00060006000700202O0006000600084O00060002000200062O0006004700013O0004C23O004700012O002C000600023O00068E0006004700013O0004C23O004700012O002C000600033O00068E0006002C00013O0004C23O002C00012O002C000600043O0006B50006002F000100010004C23O002F00012O002C000600033O0006B500060047000100010004C23O004700012O002C000600054O002C000700063O0006AF00060047000100070004C23O00470001002ECD000900470001000A0004C23O004700012O002C000600074O00A000075O00202O00070007000B4O000800083O00202O00080008000C4O000A5O00202O000A000A000B4O0008000A00024O000800086O000900016O00060009000200062O0006004700013O0004C23O004700012O002C000600013O0012990007000D3O0012990008000E4O00E5000600084O001C01065O002ECD000F0082000100100004C23O008200012O002C00066O0006000700013O00122O000800113O00122O000900126O0007000900024O00060006000700202O0006000600084O00060002000200062O0006008200013O0004C23O008200012O002C000600093O00068E0006008200013O0004C23O008200012O002C0006000A3O00068E0006005C00013O0004C23O005C00012O002C000600043O0006B50006005F000100010004C23O005F00012O002C0006000A3O0006B500060082000100010004C23O008200012O002C000600054O002C000700063O0006AF00060082000100070004C23O008200012O002C00066O002F010700013O00122O000800133O00122O000900146O0007000900024O00060006000700202O0006000600154O000600020002000E2O00160082000100060004C23O008200012O002C0006000B3O0020050006000600172O00A900060002000200263500060082000100180004C23O008200012O002C000600074O001400075O00202O0007000700194O000800083O00202O00080008001A00122O000A001B6O0008000A00024O000800086O00060008000200062O0006008200013O0004C23O008200012O002C000600013O0012990007001C3O0012990008001D4O00E5000600084O001C01065O001299000500023O0026A400050017000100020004C23O00170001001299000400053O0004C23O008800010004C23O00170001002ECD001E00100001001F0004C23O001000010026A400040010000100010004C23O00100001001299000500013O00265700050091000100020004C23O00910001002ECD00200093000100210004C23O00930001001299000400023O0004C23O00100001002E120023008D000100220004C23O008D00010026A40005008D000100010004C23O008D00012O002C0006000B3O00207C0006000600244O00085O00202O0008000800254O00060008000200062O000600B000013O0004C23O00B000012O002C0006000C3O00068E000600B000013O0004C23O00B000012O002C0006000B3O00200E00060006002600122O000800026O00095O00202O0009000900274O00060009000200062O000600B000013O0004C23O00B000012O002C0006000B3O0020290006000600284O00085O00202O0008000800294O000600080002000E2O002A00B2000100060004C23O00B20001002ECD002B00BD0001002C0004C23O00BD00012O002C000600074O002C0007000D3O00206C00070007002D2O00A900060002000200068E000600BD00013O0004C23O00BD00012O002C000600013O0012990007002E3O0012990008002F4O00E5000600084O001C01066O002C00066O0006000700013O00122O000800303O00122O000900316O0007000900024O00060006000700202O0006000600084O00060002000200062O000600F000013O0004C23O00F000012O002C0006000E3O00068E000600F000013O0004C23O00F000012O002C0006000F3O00068E000600D000013O0004C23O00D000012O002C000600043O0006B5000600D3000100010004C23O00D300012O002C0006000F3O0006B5000600F0000100010004C23O00F000012O002C000600054O002C000700063O0006AF000600F0000100070004C23O00F000012O002C0006000B3O00200E00060006002600122O000800026O00095O00202O0009000900324O00060009000200062O000600F000013O0004C23O00F000012O002C000600074O00DA00075O00202O0007000700334O000800083O00202O00080008000C4O000A5O00202O000A000A00334O0008000A00024O000800086O00060008000200062O000600F000013O0004C23O00F000012O002C000600013O001299000700343O001299000800354O00E5000600084O001C01065O001299000500023O0004C23O008D00010004C23O001000010004C23O00F500010004C23O000D00010026A4000200FD2O0100020004C23O00FD2O01001299000300014O00F1000400043O0026A4000300F9000100010004C23O00F90001001299000400013O002ECD0037006A2O0100360004C23O006A2O01000EA20001006A2O0100040004C23O006A2O01001299000500013O0026A4000500052O0100020004C23O00052O01001299000400023O0004C23O006A2O010026A40005003O0100010004C23O003O01002E120038003B2O0100390004C23O003B2O012O002C00066O0006000700013O00122O0008003A3O00122O0009003B6O0007000900024O00060006000700202O0006000600084O00060002000200062O0006003B2O013O0004C23O003B2O012O002C000600103O00068E0006003B2O013O0004C23O003B2O012O002C00066O002F010700013O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O0006000600154O000600020002000E2O0016003B2O0100060004C23O003B2O012O002C00066O0006000700013O00122O0008003E3O00122O0009003F6O0007000900024O00060006000700202O0006000600404O00060002000200062O0006003B2O013O0004C23O003B2O012O002C000600074O00DA00075O00202O0007000700414O000800083O00202O00080008000C4O000A5O00202O000A000A00414O0008000A00024O000800086O00060008000200062O0006003B2O013O0004C23O003B2O012O002C000600013O001299000700423O001299000800434O00E5000600084O001C01066O002C00066O0006000700013O00122O000800443O00122O000900456O0007000900024O00060006000700202O0006000600084O00060002000200062O000600552O013O0004C23O00552O012O002C000600113O00068E000600552O013O0004C23O00552O012O002C000600123O00068E0006004E2O013O0004C23O004E2O012O002C000600133O0006B5000600512O0100010004C23O00512O012O002C000600123O0006B5000600552O0100010004C23O00552O012O002C000600054O002C000700063O000687000600572O0100070004C23O00572O01002ECD004700682O0100460004C23O00682O012O002C000600074O00DA00075O00202O0007000700294O000800083O00202O00080008000C4O000A5O00202O000A000A00294O0008000A00024O000800086O00060008000200062O000600682O013O0004C23O00682O012O002C000600013O001299000700483O001299000800494O00E5000600084O001C01065O001299000500023O0004C23O003O01000EA2000200F42O0100040004C23O00F42O01002E12004B00A72O01004A0004C23O00A72O012O002C00056O0006000600013O00122O0007004C3O00122O0008004D6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500A72O013O0004C23O00A72O012O002C000500143O00068E000500A72O013O0004C23O00A72O012O002C00056O008C000600013O00122O0007004E3O00122O0008004F6O0006000800024O00050005000600202O0005000500284O00050002000200262O000500A72O01002A0004C23O00A72O012O002C000500083O0020820005000500504O00075O00202O0007000700514O00050007000200262O000500A72O0100520004C23O00A72O012O002C00056O00A7000600013O00122O000700533O00122O000800546O0006000800024O00050005000600202O0005000500404O00050002000200062O000500A72O0100010004C23O00A72O012O002C000500074O00DA00065O00202O0006000600324O000700083O00202O00070007000C4O00095O00202O0009000900324O0007000900024O000700076O00050007000200062O000500A72O013O0004C23O00A72O012O002C000500013O001299000600553O001299000700564O00E5000500074O001C01056O002C00056O0006000600013O00122O000700573O00122O000800586O0006000800024O00050005000600202O0005000500084O00050002000200062O000500E02O013O0004C23O00E02O012O002C000500143O00068E000500E02O013O0004C23O00E02O012O002C000500083O0020820005000500504O00075O00202O0007000700514O00050007000200262O000500C52O0100050004C23O00C52O012O002C00056O00D0000600013O00122O000700593O00122O0008005A6O0006000800024O00050005000600202O0005000500284O000500020002000E9D002A00E22O0100050004C23O00E22O012O002C000500083O0020820005000500504O00075O00202O0007000700514O00050007000200262O000500E02O0100020004C23O00E02O012O002C00056O008C000600013O00122O0007005B3O00122O0008005C6O0006000800024O00050005000600202O0005000500284O00050002000200262O000500E02O01002A0004C23O00E02O012O002C00056O0006000600013O00122O0007005D3O00122O0008005E6O0006000800024O00050005000600202O0005000500404O00050002000200062O000500E22O013O0004C23O00E22O01002ECD005F00F32O0100600004C23O00F32O012O002C000500074O00DA00065O00202O0006000600324O000700083O00202O00070007000C4O00095O00202O0009000900324O0007000900024O000700076O00050007000200062O000500F32O013O0004C23O00F32O012O002C000500013O001299000600613O001299000700624O00E5000500074O001C01055O001299000400053O002657000400F82O0100050004C23O00F82O01002E12006300FC000100640004C23O00FC0001001299000200053O0004C23O00FD2O010004C23O00FC00010004C23O00FD2O010004C23O00F90001000EA200050009000100020004C23O00090001002E1200650053020100660004C23O005302012O002C00036O0006000400013O00122O000500673O00122O000600686O0004000600024O00030003000400202O0003000300084O00030002000200062O0003005302013O0004C23O005302012O002C000300143O00068E0003005302013O0004C23O005302012O002C000300083O0020C30003000300504O00055O00202O0005000500514O00030005000200262O00030030020100020004C23O003002012O002C000300083O0020C30003000300504O00055O00202O0005000500514O00030005000200262O00030030020100050004C23O003002012O002C000300083O0020820003000300504O00055O00202O0005000500514O00030005000200262O00030029020100180004C23O002902012O002C000300153O000E9D00690030020100030004C23O003002012O002C000300163O000E9D00690030020100030004C23O003002012O002C000300083O0020820003000300504O00055O00202O0005000500514O00030005000200262O00030053020100520004C23O005302012O002C0003000B3O0020A10003000300174O0003000200024O0004000B3O00202O00040004006A4O00040002000200062O00030053020100040004C23O005302012O002C00036O0006000400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O0003000300404O00030002000200062O0003005302013O0004C23O005302012O002C000300074O00DA00045O00202O0004000400324O000500083O00202O00050005000C4O00075O00202O0007000700324O0005000700024O000500056O00030005000200062O0003005302013O0004C23O005302012O002C000300013O0012990004006D3O0012990005006E4O00E5000300054O001C01036O002C00036O0006000400013O00122O0005006F3O00122O000600706O0004000600024O00030003000400202O0003000300714O00030002000200062O0003006D02013O0004C23O006D02012O002C000300173O00068E0003006D02013O0004C23O006D02012O002C000300074O002C00045O00206C0004000400722O00A90003000200020006B500030068020100010004C23O00680201002E120073006D020100740004C23O006D02012O002C000300013O001299000400753O001299000500764O00E5000300054O001C01036O002C00036O0006000400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O0003000300084O00030002000200062O000300B402013O0004C23O00B402012O002C000300183O00068E000300B402013O0004C23O00B402012O002C000300083O0020C30003000300504O00055O00202O0005000500514O00030005000200262O00030088020100050004C23O008802012O002C000300083O0020820003000300504O00055O00202O0005000500514O00030005000200262O00030092020100180004C23O009202012O002C00036O0006000400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O0003000300404O00030002000200062O000300A302013O0004C23O00A302012O002C000300083O00207C00030003007B4O00055O00202O0005000500514O00030005000200062O000300B402013O0004C23O00B402012O002C00036O0006000400013O00122O0005007C3O00122O0006007D6O0004000600024O00030003000400202O0003000300404O00030002000200062O000300B402013O0004C23O00B402012O002C000300074O00DA00045O00202O0004000400274O000500083O00202O00050005000C4O00075O00202O0007000700274O0005000700024O000500056O00030005000200062O000300B402013O0004C23O00B402012O002C000300013O0012990004007E3O0012990005007F4O00E5000300054O001C01036O002C00036O0006000400013O00122O000500803O00122O000600816O0004000600024O00030003000400202O0003000300084O00030002000200062O0003000703013O0004C23O000703012O002C000300143O00068E0003000703013O0004C23O000703012O002C000300083O0020820003000300504O00055O00202O0005000500514O00030005000200262O000300CF020100520004C23O00CF02012O002C0003000B3O00209A0003000300244O00055O00202O0005000500824O00030005000200062O000300E7020100010004C23O00E702012O002C000300083O0020820003000300504O00055O00202O0005000500514O00030005000200262O00030007030100180004C23O000703012O002C0003000B3O00207C0003000300834O00055O00202O0005000500824O00030005000200062O0003000703013O0004C23O000703012O002C00036O00A7000400013O00122O000500843O00122O000600856O0004000600024O00030003000400202O0003000300404O00030002000200062O00030007030100010004C23O000703012O002C000300074O004300045O00202O0004000400324O000500083O00202O00050005000C4O00075O00202O0007000700324O0005000700024O000500056O00030005000200062O000300F5020100010004C23O00F50201002E1200860007030100870004C23O000703012O002C000300013O00128D000400883O00122O000500896O000300056O00035O00044O000703010004C23O000900010004C23O000703010004C23O000600010004C23O00070301002E12008A00020001008B0004C23O00020001000EA20001000200013O0004C23O00020001001299000100014O00F1000200023O0012993O00023O0004C23O000200012O00093O00017O00943O00028O00026O000840025O001EA740025O0050A040025O00BAA640025O005C9E40030E3O00CBA727E24E3AC7BC37F04933EFA603063O005F8AD5448320030A3O0049734361737461626C6503063O0042752O66557003103O00436C65617263617374696E6742752O66030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O66030E3O000B3AA242782F05A850652324A45003053O00164A48C12303083O004361737454696D65030E3O001C6BE14B2977E75D237FC951227D03043O00384C1984030B3O004973417661696C61626C65030E3O00417263616E654D692O73696C6573030E3O0049735370652O6C496E52616E6765031E3O005FD3A827C15BFEA62FDC4DC8A723DC1ED5A433CC56FEBB2ECE4DC4EB779703053O00AF3EA1CB46030B3O001DCFC0123B39FFCF12262803053O00555CBDA37303073O0049735265616479030B3O00417263616E65426C617374031B3O0028BE333927A90F3A25AD232C69B83F2D2AA40F2821AD233D69FE6003043O005849CC50025O00D07440030D3O000F91134727DF0C82025428DD2B03063O00BA4EE3702649030D3O00417263616E6542612O72616765025O00B2A140025O00A09040031D3O00FD45FE545D7FC355FC47417BFB52BD415C6FFF5FC2455B7BEF52BD070103063O001A9C379D3533026O00F03F025O00BAAC40025O0038B040025O008C9340025O002CA440030D3O006711EA2D5D136402FB3E52114303063O00762663894C3303113O00417263616E654861726D6F6E7942752O6603113O00DC3406130725DF2908100832F92B001C1D03063O00409D4665726903103O004865616C746850657263656E74616765025O00804140031D3O0041BAA4E21E4597A5E20252A9A0E65054A7B2E0187FB8AFE20345E8F6B303053O007020C8C783027O0040025O00F6A840025O0063B140030E3O00DDEC08E0FDD9EEFB02F5D5DEE3FA03063O00B78D9E6D9398025O000DB240026O002A40030E3O0050726573656E63656F664D696E64031E3O003C1BE31F2907E5091306E0332100E8086C1DE9192F01D91C2408F5096C5F03043O006C4C6986030B3O00CAD7B2E0C0EEE7BDE0DDFF03053O00AE8BA5D18103123O0050726573656E63656F664D696E6442752O66030D3O00417263616E654368617267657303103O00417263616E65436861726765734D6178025O006CA640026O009940025O0087B040025O00889240031A3O00A2A1E1C0C8064F7AAFB2F1D586177F6DA0BBDDD1CE02637DE3EB03083O0018C3D382A1A66310025O00BEAD40025O00188340025O0030A840025O0049B240025O00149A40025O00649840030B3O00959BD32F32A817B888C33A03073O0055D4E9B04E5CCD03133O004E6574686572507265636973696F6E42752O66031B3O004B4A8BE3445DB7E046599BF60A4C87F74950B7F242599BE70A09DC03043O00822A38E8025O0020AF40025O0046A240025O00D49540025O00D8AF40025O007CA540025O00A2A840030C3O0049734368612O6E656C696E67030A3O0047434452656D61696E73030E3O004D616E6150657263656E74616765026O003E40030E3O00185F49BBCBA42438585995C2AC2B03073O00424C303CD8A3CB030F3O00432O6F6C646F776E52656D61696E73025O0080514003083O0042752O66446F776E03133O00417263616E65417274692O6C65727942752O66030B3O0053746F7043617374696E6703283O00BB947AF251CB1BB78F6AE056C221A9C670FD4BCB36A89369E71FDA2BAF8571CC4FC625A98339A20D03073O0044DAE619933FAE030E3O008C38504DB8A8075A5FA5A426565F03053O00D6CD4A332C03093O0042752O66537461636B030E3O00D943ECF662E849CFFD79FB6BE7F103053O00179A2C829C03073O003CA7A3AF11161C03063O007371C6CDCE56030A3O00432O6F6C646F776E5570025O00406D40025O00A07C40025O00DEB140025O00888440031E3O008545FD5B8A52C1578D44ED538852ED1A9058EB598C68EE528544FB1AD50503043O003AE4379E025O001EA940025O00D49140025O00D09840025O0008AD4003093O00881ADD8031AC27CC8303053O005FC968BEE1030A3O005370652O6C486173746502F2D24D621058E53F030F3O00417263616E65537572676542752O6603093O00417263616E654F726203093O004973496E52616E6765026O004440025O00207940025O00BAA34003183O00AED9C2CFA1CEFEC1BDC981DAA0DEC2C690DBC9CFBCCE819A03043O00AECFABA1025O003AB240025O00349140026O002240025O0062A840025O00FAA040030D3O0073B0B68F58A7968250A5A7944903043O00E73DD5C203113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O6603083O00446562752O665570026O001040025O0066AB40025O00D0A740030D3O004E657468657254656D70657374031C3O0007A8297B0CBF02670CA02D761AB97D6706B83E7B36BD35721AA87D2103043O001369CD5D009B022O0012993O00014O00F1000100013O000EA20001000200013O0004C23O00020001001299000100013O00265700010009000100020004C23O00090001002EB800030083000100040004C23O008A0001002E1200060049000100050004C23O004900012O002C00026O0006000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002004900013O0004C23O004900012O002C000200023O00068E0002004900013O0004C23O004900012O002C000200033O00207C00020002000A4O00045O00202O00040004000B4O00020004000200062O0002004900013O0004C23O004900012O002C000200043O0020BF00020002000C4O00045O00202O00040004000D4O0002000400024O00036O00D0000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300104O00030002000200068700030038000100020004C23O003800012O002C00026O00A7000300013O00122O000400113O00122O000500126O0003000500024O00020002000300202O0002000200134O00020002000200062O00020049000100010004C23O004900012O002C000200054O00DA00035O00202O0003000300144O000400043O00202O0004000400154O00065O00202O0006000600144O0004000600024O000400046O00020004000200062O0002004900013O0004C23O004900012O002C000200013O001299000300163O001299000400174O00E5000200044O001C01026O002C00026O0006000300013O00122O000400183O00122O000500196O0003000500024O00020002000300202O00020002001A4O00020002000200062O0002006700013O0004C23O006700012O002C000200063O00068E0002006700013O0004C23O006700012O002C000200054O00DA00035O00202O00030003001B4O000400043O00202O0004000400154O00065O00202O00060006001B4O0004000600024O000400046O00020004000200062O0002006700013O0004C23O006700012O002C000200013O0012990003001C3O0012990004001D4O00E5000200044O001C01025O002EB8001E00330201001E0004C23O009A02012O002C00026O0006000300013O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O00020002001A4O00020002000200062O0002009A02013O0004C23O009A02012O002C000200073O00068E0002009A02013O0004C23O009A02012O002C000200054O004300035O00202O0003000300214O000400043O00202O0004000400154O00065O00202O0006000600214O0004000600024O000400046O00020004000200062O00020084000100010004C23O00840001002E120022009A020100230004C23O009A02012O002C000200013O00128D000300243O00122O000400256O000200046O00025O00044O009A02010026A4000100302O0100260004C23O00302O01001299000200014O00F1000300033O002E120027008E000100280004C23O008E00010026A40002008E000100010004C23O008E0001001299000300013O002ECD002900D50001002A0004C23O00D500010026A4000300D5000100260004C23O00D500012O002C00046O0006000500013O00122O0006002B3O00122O0007002C6O0005000700024O00040004000500202O00040004001A4O00040002000200062O000400D300013O0004C23O00D300012O002C000400073O00068E000400D300013O0004C23O00D300012O002C000400033O00209A00040004000A4O00065O00202O00060006002D4O00040006000200062O000400BA000100010004C23O00BA00012O002C00046O0006000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400D300013O0004C23O00D300012O002C000400043O0020050004000400302O00A9000400020002002635000400D3000100310004C23O00D300012O002C000400043O0020F600040004000C4O00065O00202O00060006000D4O0004000600024O000500083O00062O000400D3000100050004C23O00D300012O002C000400054O00DA00055O00202O0005000500214O000600043O00202O0006000600154O00085O00202O0008000800214O0006000800024O000600066O00040006000200062O000400D300013O0004C23O00D300012O002C000400013O001299000500323O001299000600334O00E5000400064O001C01045O001299000100343O0004C23O00302O01000ED1000100D9000100030004C23O00D90001002ECD00360093000100350004C23O009300012O002C00046O0006000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400094O00040002000200062O000400EE00013O0004C23O00EE00012O002C000400093O00068E000400EE00013O0004C23O00EE00012O002C000400043O00204C00040004000C4O00065O00202O00060006000D4O0004000600024O000500083O00062O00040003000100050004C23O00F00001002EB80039000D0001003A0004C23O00FB00012O002C000400054O002C00055O00206C00050005003B2O00A900040002000200068E000400FB00013O0004C23O00FB00012O002C000400013O0012990005003C3O0012990006003D4O00E5000400064O001C01046O002C00046O0006000500013O00122O0006003E3O00122O0007003F6O0005000700024O00040004000500202O00040004001A4O00040002000200062O000400172O013O0004C23O00172O012O002C000400063O00068E000400172O013O0004C23O00172O012O002C000400033O00207C00040004000A4O00065O00202O0006000600404O00040006000200062O000400172O013O0004C23O00172O012O002C000400033O0020740004000400414O0004000200024O000500033O00202O0005000500424O00050002000200062O000400192O0100050004C23O00192O01002EB800430015000100440004C23O002C2O012O002C000400054O004300055O00202O00050005001B4O000600043O00202O0006000600154O00085O00202O00080008001B4O0006000800024O000600066O00040006000200062O000400272O0100010004C23O00272O01002ECD0045002C2O0100460004C23O002C2O012O002C000400013O001299000500473O001299000600484O00E5000400064O001C01045O001299000300263O0004C23O009300010004C23O00302O010004C23O008E0001002657000100342O0100340004C23O00342O01002ECD004900F22O01004A0004C23O00F22O01001299000200013O002ECD004B00622O01004C0004C23O00622O010026A4000200622O0100260004C23O00622O01002ECD004E00602O01004D0004C23O00602O012O002C00036O0006000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003001A4O00030002000200062O000300602O013O0004C23O00602O012O002C000300063O00068E000300602O013O0004C23O00602O012O002C000300033O00207C00030003000A4O00055O00202O0005000500514O00030005000200062O000300602O013O0004C23O00602O012O002C000300054O00DA00045O00202O00040004001B4O000500043O00202O0005000500154O00075O00202O00070007001B4O0005000700024O000500056O00030005000200062O000300602O013O0004C23O00602O012O002C000300013O001299000400523O001299000500534O00E5000300054O001C01035O001299000100023O0004C23O00F22O01000ED1000100662O0100020004C23O00662O01002ECD005400352O0100550004C23O00352O01001299000300013O002ECD005600EA2O0100570004C23O00EA2O010026A4000300EA2O0100010004C23O00EA2O01002ECD005800AC2O0100590004C23O00AC2O012O002C000400033O00207C00040004005A4O00065O00202O0006000600144O00040006000200062O000400AC2O013O0004C23O00AC2O012O002C000400033O00200500040004005B2O00A90004000200020026A4000400AC2O0100010004C23O00AC2O012O002C000400033O00207C00040004000A4O00065O00202O0006000600514O00040006000200062O000400AC2O013O0004C23O00AC2O012O002C000400033O00200500040004005C2O00A9000400020002000E1C005D008F2O0100040004C23O008F2O012O002C00046O00D0000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500202O0004000400604O000400020002000E9D005D00942O0100040004C23O00942O012O002C000400033O00200500040004005C2O00A9000400020002000E1C006100AC2O0100040004C23O00AC2O012O002C000400033O00207C0004000400624O00065O00202O0006000600634O00040006000200062O000400AC2O013O0004C23O00AC2O012O002C000400054O00DA0005000A3O00202O0005000500644O000600043O00202O0006000600154O00085O00202O0008000800144O0006000800024O000600066O00040006000200062O000400AC2O013O0004C23O00AC2O012O002C000400013O001299000500653O001299000600664O00E5000400064O001C01046O002C00046O0006000500013O00122O000600673O00122O000700686O0005000700024O00040004000500202O0004000400094O00040002000200062O000400D42O013O0004C23O00D42O012O002C000400023O00068E000400D42O013O0004C23O00D42O012O002C000400033O00205E0004000400694O00065O00202O00060006000B4O000400060002000E2O002600D42O0100040004C23O00D42O012O002C00046O0006000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400D42O013O0004C23O00D42O012O002C0004000B4O00A7000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004006E4O00040002000200062O000400D62O0100010004C23O00D62O01002EB8006F0015000100700004C23O00E92O01002E12007200E92O0100710004C23O00E92O012O002C000400054O00DA00055O00202O0005000500144O000600043O00202O0006000600154O00085O00202O0008000800144O0006000800024O000600066O00040006000200062O000400E92O013O0004C23O00E92O012O002C000400013O001299000500733O001299000600744O00E5000400064O001C01045O001299000300263O002657000300EE2O0100260004C23O00EE2O01002ECD007500672O0100760004C23O00672O01001299000200263O0004C23O00352O010004C23O00672O010004C23O00352O010026A400010005000100010004C23O00050001001299000200013O002657000200F92O0100260004C23O00F92O01002EB800770042000100780004C23O003902012O002C00036O0006000400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O00030003001A4O00030002000200062O0003003702013O0004C23O003702012O002C0003000C3O00068E0003003702013O0004C23O003702012O002C0003000D3O00068E0003000C02013O0004C23O000C02012O002C0003000E3O0006B50003000F020100010004C23O000F02012O002C0003000D3O0006B500030037020100010004C23O003702012O002C000300033O0020050003000300412O00A900030002000200263500030037020100340004C23O003702012O002C000300033O00200500030003005C2O00A9000300020002002635000300370201005D0004C23O003702012O002C000300033O00200500030003007B2O00A9000300020002002635000300370201007C0004C23O003702012O002C000300033O00207C0003000300624O00055O00202O00050005007D4O00030005000200062O0003003702013O0004C23O003702012O002C000300054O002A00045O00202O00040004007E4O000500043O00202O00050005007F00122O000700806O0005000700024O000500056O00030005000200062O00030032020100010004C23O00320201002ECD00820037020100810004C23O003702012O002C000300013O001299000400833O001299000500844O00E5000300054O001C01035O001299000100263O0004C23O000500010026570002003D020100010004C23O003D0201002E12008500F52O0100860004C23O00F52O01001299000300013O000EA200260042020100030004C23O00420201001299000200263O0004C23O00F52O010026A40003003E020100010004C23O003E02012O002C000400043O00202900040004000C4O00065O00202O00060006000D4O000400060002000E2O0087004D020100040004C23O004D0201002E1200880050020100890004C23O005002012O002C0004000F4O0071000400044O007B0004000F4O002C00046O0006000500013O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O00040004001A4O00040002000200062O0004009402013O0004C23O009402012O002C000400103O00068E0004009402013O0004C23O009402012O002C000400043O00209A00040004008C4O00065O00202O00060006008D4O00040006000200062O0004006B020100010004C23O006B02012O002C000400043O00209A00040004008E4O00065O00202O00060006008D4O00040006000200062O00040094020100010004C23O009402012O002C000400033O0020050004000400412O00A90004000200020026A4000400940201008F0004C23O009402012O002C000400033O00200500040004005C2O00A9000400020002002635000400940201005D0004C23O009402012O002C000400033O00200500040004007B2O00A9000400020002002635000400940201007C0004C23O009402012O002C000400033O00207C0004000400624O00065O00202O00060006007D4O00040006000200062O0004009402013O0004C23O00940201002ECD00910094020100900004C23O009402012O002C000400054O00DA00055O00202O0005000500924O000600043O00202O0006000600154O00085O00202O0008000800924O0006000800024O000600066O00040006000200062O0004009402013O0004C23O009402012O002C000400013O001299000500933O001299000600944O00E5000400064O001C01045O001299000300263O0004C23O003E02010004C23O00F52O010004C23O000500010004C23O009A02010004C23O000200012O00093O00017O00373O00028O00025O00E49E40025O0026A340025O0022A240025O00107940030D3O00446562752O6652656D61696E7303143O00546F7563686F667468654D616769446562752O66026O002240025O005AAD40025O0096A240030E3O00ADCA15D8B655A1D105CAB15C89CB03063O0030ECB876B9D8030A3O0049734361737461626C6503063O0042752O66557003133O00417263616E65417274692O6C65727942752O6603103O00436C65617263617374696E6742752O66030E3O00417263616E654D692O73696C6573030E3O0049735370652O6C496E52616E6765025O00408B40025O006C9A4003213O00E4AF5431C131DAB05E23DC3DE9B84470CE3BE082433FDA37ED824738CE27E0FD0503063O005485DD3750AF026O00F03F025O0016AB40025O0028A340027O0040030F3O00F7672AA2E92O890EC67926B0EE83A203083O0076B61549C387ECCC03073O0049735265616479030F3O00417263616E654578706C6F73696F6E03093O004973496E52616E6765026O003E4003223O00092E19410A08C20D240A4C0B1EF407325A410B08C21C330F430C32ED003D0945445503073O009D685C7A20646D025O00C07040025O0044B340030D3O009CF527A7C9599FE636B4C65BB803063O003CDD8744C6A7026O001040030D3O00417263616E6543686172676573026O00084003103O00417263616E65436861726765734D6178025O00A49740025O00C89D40025O0058A840025O00F3B240030D3O00417263616E6542612O7261676503203O00EFAFFB824CDCD1BFF99150D8E92OB8824DDCD1A9F796412OD1ADF08251DCAEE903063O00B98EDD98E32203093O0079D754FB4D36D84AC703073O009738A5379A235303093O00417263616E654F7262026O004440031C3O00A15106EFAE463AE1B24145EFAF463AFAAF5606E69F530DEFB34645B803043O008EC0236500FB3O0012993O00014O00F1000100013O0026573O0006000100010004C23O00060001002E1200030002000100020004C23O00020001001299000100013O0026570001000B000100010004C23O000B0001002E120004005E000100050004C23O005E0001001299000200014O00F1000300033O0026A40002000D000100010004C23O000D0001001299000300013O0026A400030057000100010004C23O00570001001299000400013O0026A400040050000100010004C23O005000012O002C00055O0020290005000500064O000700013O00202O0007000700074O000500070002000E2O0008001E000100050004C23O001E0001002ECD000900210001000A0004C23O002100012O002C000500024O0071000500054O007B000500024O002C000500014O0006000600033O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005004F00013O0004C23O004F00012O002C000500043O00068E0005004F00013O0004C23O004F00012O002C000500053O00207C00050005000E4O000700013O00202O00070007000F4O00050007000200062O0005004F00013O0004C23O004F00012O002C000500053O00207C00050005000E4O000700013O00202O0007000700104O00050007000200062O0005004F00013O0004C23O004F00012O002C000500064O0043000600013O00202O0006000600114O00075O00202O0007000700124O000900013O00202O0009000900114O0007000900024O000700076O00050007000200062O0005004A000100010004C23O004A0001002ECD0014004F000100130004C23O004F00012O002C000500033O001299000600153O001299000700164O00E5000500074O001C01055O001299000400173O00265700040054000100170004C23O00540001002ECD00180013000100190004C23O00130001001299000300173O0004C23O005700010004C23O001300010026A400030010000100170004C23O00100001001299000100173O0004C23O005E00010004C23O001000010004C23O005E00010004C23O000D00010026A40001007E0001001A0004C23O007E00012O002C000200014O0006000300033O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O00020002001D4O00020002000200062O000200FA00013O0004C23O00FA00012O002C000200073O00068E000200FA00013O0004C23O00FA00012O002C000200064O0014000300013O00202O00030003001E4O00045O00202O00040004001F00122O000600206O0004000600024O000400046O00020004000200062O000200FA00013O0004C23O00FA00012O002C000200033O00128D000300213O00122O000400226O000200046O00025O00044O00FA0001000EA200170007000100010004C23O00070001001299000200013O0026A4000200F2000100010004C23O00F20001001299000300013O00265700030088000100010004C23O00880001002ECD002400ED000100230004C23O00ED00012O002C000400014O0006000500033O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400A800013O0004C23O00A800012O002C000400083O00068E000400A800013O0004C23O00A800012O002C000400093O0026920004009B000100270004C23O009B00012O002C0004000A3O00263A000400A0000100270004C23O00A000012O002C000400053O0020050004000400282O00A9000400020002002657000400AA000100290004C23O00AA00012O002C000400053O0020740004000400284O0004000200024O000500053O00202O00050005002A4O00050002000200062O000400AA000100050004C23O00AA0001002E12002C00BD0001002B0004C23O00BD0001002E12002D00BD0001002E0004C23O00BD00012O002C000400064O00DA000500013O00202O00050005002F4O00065O00202O0006000600124O000800013O00202O00080008002F4O0006000800024O000600066O00040006000200062O000400BD00013O0004C23O00BD00012O002C000400033O001299000500303O001299000600314O00E5000400064O001C01046O002C000400014O0006000500033O00122O000600323O00122O000700336O0005000700024O00040004000500202O00040004001D4O00040002000200062O000400EC00013O0004C23O00EC00012O002C0004000B3O00068E000400EC00013O0004C23O00EC00012O002C0004000C3O00068E000400D000013O0004C23O00D000012O002C0004000D3O0006B5000400D3000100010004C23O00D300012O002C0004000C3O0006B5000400EC000100010004C23O00EC00012O002C0004000E4O002C0005000F3O0006AF000400EC000100050004C23O00EC00012O002C000400053O0020050004000400282O00A9000400020002002635000400EC0001001A0004C23O00EC00012O002C000400064O0014000500013O00202O0005000500344O00065O00202O00060006001F00122O000800356O0006000800024O000600066O00040006000200062O000400EC00013O0004C23O00EC00012O002C000400033O001299000500363O001299000600374O00E5000400064O001C01045O001299000300173O0026A400030084000100170004C23O00840001001299000200173O0004C23O00F200010004C23O00840001000EA200170081000100020004C23O008100010012990001001A3O0004C23O000700010004C23O008100010004C23O000700010004C23O00FA00010004C23O000200012O00093O00017O00CD3O00028O00025O0096B140025O005EAC40026O000840025O00405F40025O0052AE40027O0040026O001040026O00F03F025O0033B240025O00F89040030D3O0013F18B3C475F10E29A2F485D3703063O003A5283E85D2903073O0049735265616479030D3O00417263616E654368617267657303103O00417263616E65436861726765734D6178030E3O004D616E6150657263656E74616765026O004E40030E3O00B758C51655308543D810703E845E03063O005FE337B0753D030F3O00432O6F6C646F776E52656D61696E73026O00244003093O003D682C48AA0C772C4503053O00CB781E432B026O004440026O003440030D3O00417263616E6542612O72616765030E3O0049735370652O6C496E52616E6765031A3O00F0374EEED7F41A4FEECBE3244AEA99E32A59EECDF82A43AF8BA703053O00B991452D8F030E3O00AB0D1AA7D28F3210B5CF83131CB503053O00BCEA7F79C6030A3O0049734361737461626C6503063O0042752O66557003103O00436C65617263617374696E6742752O6603083O0042752O66446F776E03133O004E6574686572507265636973696F6E42752O66025O00C06040025O00E2A240030E3O00417263616E654D692O73696C6573031B3O003920108236372C8E3121008A343700C32A3D07822C3B1C8D78614303043O00E3585273025O007CAA40025O00EC9C40025O0014AD40025O001AA440030E3O00F2AB2C06DDBC020EC0AA260BD6AA03043O0067B3D94F03113O00436F6E63656E74726174696F6E42752O66025O0079B140025O00EAA940025O00209140025O00D89B40031B3O004BA51FD44F899C47BE0FC64880A659F70EDA558DB743B8129513DE03073O00C32AD77CB521EC030B3O002C4B343F2BFD2F55362D3103063O00986D39575E45025O0072A240025O00B89840030B3O00417263616E65426C61737403183O00F8C509A2B0D76BAAF5D619B7FEC05BBCF8C303ACB09206FC03083O00C899B76AC3DEB234025O004CA740025O0085B040025O006AA040025O00D6AA4003093O0082B4CCCB3322A2B9A103083O00CBC3C6AFAA5D47ED030D3O00426C2O6F646C757374446F776E025O00805140030E3O001A442BD6591EFA3A433BF85016F503073O009C4E2B5EB53171026O003E4003093O00417263616E654F726203093O004973496E52616E676503153O0073FAC7A2052O467DFAC6E3194C6D73FCCDAC05032B03073O00191288A4C36B23030B3O00C93FAA4E7CB9F2ADFA2AAC03083O00D8884DC92F12DCA1030E3O0019E33ED900D38439E42EF709DB8B03073O00E24D8C4BBA68BC025O0019B140025O00709440025O007FB040025O00A6A040030D3O008AC6D9395BB0C0D70F40AECBC203053O002FD9AEB05F03093O009DCB7901B3407129B603083O0046D8BD1662D23418030B3O004973417661696C61626C6503093O00FFC9AC84D2CED6AC8903053O00B3BABFC3E7026O002840030B3O00D82D1BE5F73A2BF1EB381D03043O0084995F78030B3O0090A00D2CF9DF93A4A0092803073O00C0D1D26E4D97BA030E3O00D40C37EAF7CBE6172AECD2C5E70A03063O00A4806342899F030E3O003486FCBD0886EFAA088CC4BF078003043O00DE60E989026O002E40030D3O005368696674696E67506F77657203193O00AABBAE199CFAFEBE8CB7109FF6E2F9A1A80B89E7F9B6BDE74B03073O0090D9D3C77FE893030D3O00CB27372EC14C0C43C820292DC703083O0024984F5E48B52562030F3O00417263616E65537572676542752O66030B3O00F6CA443ED9DD742AC5DF4203043O005FB7B827025O00804640025O00B8AC40025O00C8A14003193O00A637EE2040890CB200F729438510F52DE83255940BBA31A77003073O0062D55F874634E0030B3O00620DB9A60C766113BBB41603063O0013237FDAC762025O00B89240025O0077B24003183O001DE909E312FE35E010FA19F65CE905F61DEF03ED12BB59B003043O00827C9B6A030D3O00F4D9F5AEADF35EBEC7D9F7A8A603083O00DFB5AB96CFC3961C025O0020AA40025O0066B240031A3O004D28E0AF074905E1AF1B5E3BE4AB495E35F7AF1D4535EDEE5A1803053O00692C5A83CE025O0099B240030E3O00C7162238420257EF17323040026903073O001A866441592C6703093O0042752O66537461636B025O00907D40025O00FDB040031B3O00F0F13322AAF4DC3D2AB7E2EA3C26B7B1F13F37A5E5EA3F2DE4A0B703053O00C491835043025O0022AC40025O000EA740030D3O0030B512001DFA2AB50B181DFB0A03063O00887ED066687803113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O6603103O0054656D706F72616C5761727042752O66030D3O004B82C745BB5B33564885D946BD03083O003118EAAE23CF325D025O0040A040025O0014B040030D3O004E657468657254656D70657374031A3O0002F7E980741ECDE98D7C1CF7EE9C311EFDE9896505FDF3C8205A03053O00116C929DE8030D3O006AD117EC21AD69C206FF2EAF4E03063O00C82BA3748D4F026O00494003093O009A203280B1E0EAB03803073O0083DF565DE3D094025O00688940025O00606A40031A3O00E257B5B713B0DC47B7A40FB4E440F6A412A1E251BFB913F5B21D03063O00D583252OD67D025O00508F40030D3O00073926BEEF230924ADF3272C2003053O0081464B45DF030B3O00426C2O6F646C7573745570030E3O0072C4E6EA74E040DFFBEC51EE41C203063O008F26AB93891C026O001440031A3O00D190BAF20DE6EBD283ABE102E4D12O90B6E702F7DDDF8CF9A15303073O00B4B0E2D9936383025O00B49740025O00B2AF40025O00ACAB40025O006FB240030E3O00CEB1CC6451F0A0CC7852D3AAC77303053O00349EC3A91703103O004865616C746850657263656E74616765025O0080414003113O005BAE31758830598477BE336682387E856E03083O00EB1ADC5214E6551B030E3O0050726573656E63656F664D696E64025O0063B240025O00B0AB40031B3O0098B3ECD17186A2ECFD7B8E9EE4CB7A8CE1FBCD6089B5E0CD7AC8F903053O0014E8C189A2030B3O0003CDC6A7E989357D23CCD103083O001142BFA5C687EC77030B3O003BA6A316DEE6E3DC0EA3B703083O00B16FCFCE739F888C030B3O0042752O6652656D61696E73026O00184003183O00049B1315DA4A6007851107C00F4D0A9D1100DD405145D84003073O003F65E97074B42F030B3O00E229EE13F633E137EC01EC03063O0056A35B8D729803123O0050726573656E63656F664D696E6442752O6603113O00721977723456297B7E385219707E3F5D1F03053O005A336B141303183O008CE286EE3388CF87E33C9EE4C5FD3299F191E63283B0D4BD03053O005DED90E58F030C3O0049734368612O6E656C696E67030A3O0047434452656D61696E73030E3O0021F9E51A034913E2F81C264712FF03063O0026759690796B03133O00417263616E65417274692O6C65727942752O66030B3O0053746F7043617374696E6703253O002CA9ED3B23BED13724A8FD3321BEFD7A24B5FA2O3FA9FB2A39FBFC3539BAFA3322B5AE687D03043O005A4DDB8E009E042O0012993O00014O00F1000100013O0026573O0006000100010004C23O00060001002EB8000200FEFF2O00030004C23O00020001001299000100013O0026A40001000B2O0100040004C23O000B2O01001299000200014O00F1000300033O0026570002000F000100010004C23O000F0001002E120006000B000100050004C23O000B0001001299000300013O0026A400030014000100070004C23O00140001001299000100083O0004C23O000B2O0100265700030018000100090004C23O00180001002EB8000A007C0001000B0004C23O009200012O002C00046O0006000500013O00122O0006000C3O00122O0007000D6O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004005D00013O0004C23O005D00012O002C000400023O00068E0004005D00013O0004C23O005D00012O002C000400033O0020A100040004000F4O0004000200024O000500033O00202O0005000500104O00050002000200062O0004005D000100050004C23O005D00012O002C000400033O0020050004000400112O00A90004000200020026350004005D000100120004C23O005D00012O002C000400043O00068E0004005D00013O0004C23O005D00012O002C00046O0046000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400154O000400020002000E2O0016005D000100040004C23O005D00012O002C00046O0046000500013O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400154O000400020002000E2O0019005D000100040004C23O005D00012O002C000400053O000E1C001A005D000100040004C23O005D00012O002C000400064O00DA00055O00202O00050005001B4O000600073O00202O00060006001C4O00085O00202O00080008001B4O0006000800024O000600066O00040006000200062O0004005D00013O0004C23O005D00012O002C000400013O0012990005001D3O0012990006001E4O00E5000400064O001C01046O002C00046O0006000500013O00122O0006001F3O00122O000700206O0005000700024O00040004000500202O0004000400214O00040002000200062O0004007E00013O0004C23O007E00012O002C000400083O00068E0004007E00013O0004C23O007E00012O002C000400033O00207C0004000400224O00065O00202O0006000600234O00040006000200062O0004007E00013O0004C23O007E00012O002C000400033O00207C0004000400244O00065O00202O0006000600254O00040006000200062O0004007E00013O0004C23O007E00012O002C000400093O00068E0004008000013O0004C23O008000012O002C0004000A3O00068E0004008000013O0004C23O00800001002E1200270091000100260004C23O009100012O002C000400064O00DA00055O00202O0005000500284O000600073O00202O00060006001C4O00085O00202O0008000800284O0006000800024O000600066O00040006000200062O0004009100013O0004C23O009100012O002C000400013O001299000500293O0012990006002A4O00E5000400064O001C01045O001299000300073O00265700030096000100010004C23O00960001002ECD002B00100001002C0004C23O00100001001299000400013O000EA20009009B000100040004C23O009B0001001299000300093O0004C23O00100001002E12002E00970001002D0004C23O009700010026A400040097000100010004C23O009700012O002C00056O0006000600013O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O0005000500214O00050002000200062O000500C200013O0004C23O00C200012O002C000500083O00068E000500C200013O0004C23O00C200012O002C000500033O00207C0005000500224O00075O00202O0007000700234O00050007000200062O000500C200013O0004C23O00C200012O002C000500033O00207C0005000500224O00075O00202O0007000700314O00050007000200062O000500C200013O0004C23O00C200012O002C000500033O00207400050005000F4O0005000200024O000600033O00202O0006000600104O00060002000200062O000500C4000100060004C23O00C40001002E12003200D7000100330004C23O00D70001002E12003400D7000100350004C23O00D700012O002C000500064O00DA00065O00202O0006000600284O000700073O00202O00070007001C4O00095O00202O0009000900284O0007000900024O000700076O00050007000200062O000500D700013O0004C23O00D700012O002C000500013O001299000600363O001299000700374O00E5000500074O001C01056O002C00056O0006000600013O00122O000700383O00122O000800396O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500062O013O0004C23O00062O012O002C0005000B3O00068E000500062O013O0004C23O00062O012O002C000500033O0020A100050005000F4O0005000200024O000600033O00202O0006000600104O00060002000200062O000500062O0100060004C23O00062O012O002C000500033O00207C0005000500224O00075O00202O0007000700254O00050007000200062O000500062O013O0004C23O00062O01002ECD003B00062O01003A0004C23O00062O012O002C000500064O00DA00065O00202O00060006003C4O000700073O00202O00070007001C4O00095O00202O00090009003C4O0007000900024O000700076O00050007000200062O000500062O013O0004C23O00062O012O002C000500013O0012990006003D3O0012990007003E4O00E5000500074O001C01055O001299000400093O0004C23O009700010004C23O001000010004C23O000B2O010004C23O000B00010026570001000F2O0100010004C23O000F2O01002E12004000390201003F0004C23O00390201001299000200013O002EB800410006000100410004C23O00162O010026A4000200162O0100070004C23O00162O01001299000100093O0004C23O00390201002EB800420064000100420004C23O007A2O010026A40002007A2O0100010004C23O007A2O012O002C00036O0006000400013O00122O000500433O00122O000600446O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300602O013O0004C23O00602O012O002C0003000C3O00068E000300602O013O0004C23O00602O012O002C0003000D3O00068E0003002D2O013O0004C23O002D2O012O002C0003000E3O0006B5000300302O0100010004C23O00302O012O002C0003000D3O0006B5000300602O0100010004C23O00602O012O002C0003000F4O002C000400053O0006AF000300602O0100040004C23O00602O012O002C000300033O00200500030003000F2O00A9000300020002002635000300602O0100040004C23O00602O012O002C000300033O0020050003000300452O00A90003000200020006B5000300502O0100010004C23O00502O012O002C000300033O0020050003000300112O00A9000300020002000E9D004600502O0100030004C23O00502O012O002C000300093O00068E000300602O013O0004C23O00602O012O002C00036O0046000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300154O000300020002000E2O004900602O0100030004C23O00602O012O002C000300064O001400045O00202O00040004004A4O000500073O00202O00050005004B00122O000700196O0005000700024O000500056O00030005000200062O000300602O013O0004C23O00602O012O002C000300013O0012990004004C3O0012990005004D4O00E5000300054O001C01036O002C00036O0046000400013O00122O0005004E3O00122O0006004F6O0004000600024O00030003000400202O0003000300154O000300020002000E2O004900742O0100030004C23O00742O012O002C00036O00D0000400013O00122O000500503O00122O000600516O0004000600024O00030003000400202O0003000300154O000300020002000E9D001600772O0100030004C23O00772O012O00CC00035O0004C23O00782O012O003D00036O00CC000300014O007B000300043O001299000200093O0026A4000200102O0100090004C23O00102O01001299000300013O0026A4000300812O0100090004C23O00812O01001299000200073O0004C23O00102O01002ECD0053007D2O0100520004C23O007D2O010026A40003007D2O0100010004C23O007D2O01002ECD005500F32O0100540004C23O00F32O012O002C00046O0006000500013O00122O000600563O00122O000700576O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400F32O013O0004C23O00F32O012O002C000400103O00068E000400F32O013O0004C23O00F32O012O002C000400113O00068E0004009A2O013O0004C23O009A2O012O002C000400123O0006B50004009D2O0100010004C23O009D2O012O002C000400123O0006B5000400F32O0100010004C23O00F32O012O002C0004000F4O002C000500053O0006AF000400F32O0100050004C23O00F32O012O002C000400093O00068E000400F32O013O0004C23O00F32O012O002C00046O0006000500013O00122O000600583O00122O000700596O0005000700024O00040004000500202O00040004005A4O00040002000200062O000400B82O013O0004C23O00B82O012O002C00046O0046000500013O00122O0006005B3O00122O0007005C6O0005000700024O00040004000500202O0004000400154O000400020002000E2O005D00F32O0100040004C23O00F32O012O002C00046O0006000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500202O00040004005A4O00040002000200062O000400CC2O013O0004C23O00CC2O012O002C00046O0046000500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O0004000400154O000400020002000E2O005D00F32O0100040004C23O00F32O012O002C00046O0006000500013O00122O000600623O00122O000700636O0005000700024O00040004000500202O00040004005A4O00040002000200062O000400E02O013O0004C23O00E02O012O002C00046O0046000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O0004000400154O000400020002000E2O005D00F32O0100040004C23O00F32O012O002C000400053O000E1C006600F32O0100040004C23O00F32O012O002C000400064O001400055O00202O0005000500674O000600073O00202O00060006004B00122O000800196O0006000800024O000600066O00040006000200062O000400F32O013O0004C23O00F32O012O002C000400013O001299000500683O001299000600694O00E5000400064O001C01046O002C00046O0006000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004003602013O0004C23O003602012O002C000400103O00068E0004003602013O0004C23O003602012O002C000400113O00068E0004000602013O0004C23O000602012O002C000400123O0006B500040009020100010004C23O000902012O002C000400123O0006B500040036020100010004C23O003602012O002C0004000F4O002C000500053O0006AF00040036020100050004C23O003602012O002C000400093O0006B500040036020100010004C23O003602012O002C000400033O00207C0004000400244O00065O00202O00060006006C4O00040006000200062O0004003602013O0004C23O003602012O002C00046O0046000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500202O0004000400154O000400020002000E2O006F0036020100040004C23O003602012O002C000400053O000E1C00660036020100040004C23O00360201002ECD00710036020100700004C23O003602012O002C000400064O001400055O00202O0005000500674O000600073O00202O00060006004B00122O000800196O0006000800024O000600066O00040006000200062O0004003602013O0004C23O003602012O002C000400013O001299000500723O001299000600734O00E5000400064O001C01045O001299000300093O0004C23O007D2O010004C23O00102O010026A40001007C020100080004C23O007C02012O002C00026O0006000300013O00122O000400743O00122O000500756O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002005B02013O0004C23O005B02012O002C0002000B3O00068E0002005B02013O0004C23O005B0201002ECD0076005B020100770004C23O005B02012O002C000200064O00DA00035O00202O00030003003C4O000400073O00202O00040004001C4O00065O00202O00060006003C4O0004000600024O000400046O00020004000200062O0002005B02013O0004C23O005B02012O002C000200013O001299000300783O001299000400794O00E5000200044O001C01026O002C00026O0006000300013O00122O0004007A3O00122O0005007B6O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002009D04013O0004C23O009D04012O002C000200023O00068E0002009D04013O0004C23O009D0401002ECD007C009D0401007D0004C23O009D04012O002C000200064O00DA00035O00202O00030003001B4O000400073O00202O00040004001C4O00065O00202O00060006001B4O0004000600024O000400046O00020004000200062O0002009D04013O0004C23O009D04012O002C000200013O00128D0003007E3O00122O0004007F6O000200046O00025O00044O009D0401002EB80080001A2O0100800004C23O009603010026A400010096030100070004C23O00960301001299000200014O00F1000300033O0026A400020082020100010004C23O00820201001299000300013O0026A400030010030100010004C23O00100301001299000400013O0026A40004008C020100090004C23O008C0201001299000300093O0004C23O00100301000EA200010088020100040004C23O008802012O002C00056O0006000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O0005000500214O00050002000200062O000500BD02013O0004C23O00BD02012O002C000500083O00068E000500BD02013O0004C23O00BD02012O002C000500033O00207C0005000500224O00075O00202O0007000700234O00050007000200062O000500BD02013O0004C23O00BD02012O002C000500033O0020080005000500834O00075O00202O0007000700234O0005000700024O000600133O00062O000500BD020100060004C23O00BD02012O002C000500064O004300065O00202O0006000600284O000700073O00202O00070007001C4O00095O00202O0009000900284O0007000900024O000700076O00050007000200062O000500B8020100010004C23O00B80201002ECD008500BD020100840004C23O00BD02012O002C000500013O001299000600863O001299000700874O00E5000500074O001C01055O002ECD0089000E030100880004C23O000E03012O002C00056O0006000600013O00122O0007008A3O00122O0008008B6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005000E03013O0004C23O000E03012O002C000500143O00068E0005000E03013O0004C23O000E03012O002C000500073O00207C00050005008C4O00075O00202O00070007008D4O00050007000200062O0005000E03013O0004C23O000E03012O002C000500033O0020A100050005000F4O0005000200024O000600033O00202O0006000600104O00060002000200062O0005000E030100060004C23O000E03012O002C000500033O00209A0005000500224O00075O00202O00070007008E4O00050007000200062O000500F1020100010004C23O00F102012O002C000500033O0020050005000500112O00A9000500020002002680000500F1020100160004C23O00F102012O002C00056O00A7000600013O00122O0007008F3O00122O000800906O0006000800024O00050005000600202O00050005005A4O00050002000200062O0005000E030100010004C23O000E03012O002C000500033O00207C0005000500244O00075O00202O00070007006C4O00050007000200062O0005000E03013O0004C23O000E03012O002C000500053O000EE0005D000E030100050004C23O000E0301002E120091000E030100920004C23O000E03012O002C000500064O00DA00065O00202O0006000600934O000700073O00202O00070007001C4O00095O00202O0009000900934O0007000900024O000700076O00050007000200062O0005000E03013O0004C23O000E03012O002C000500013O001299000600943O001299000700954O00E5000500074O001C01055O001299000400093O0004C23O008802010026A400030014030100070004C23O00140301001299000100043O0004C23O00960301000EA200090085020100030004C23O008502012O002C00046O0006000500013O00122O000600963O00122O000700976O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004005003013O0004C23O005003012O002C000400023O00068E0004005003013O0004C23O005003012O002C000400033O0020A100040004000F4O0004000200024O000500033O00202O0005000500104O00050002000200062O00040050030100050004C23O005003012O002C000400033O0020050004000400112O00A900040002000200263500040050030100980004C23O005003012O002C00046O00A7000500013O00122O000600993O00122O0007009A6O0005000700024O00040004000500202O00040004005A4O00040002000200062O00040050030100010004C23O005003012O002C000400053O000E1C001A0050030100040004C23O005003012O002C000400064O004300055O00202O00050005001B4O000600073O00202O00060006001C4O00085O00202O00080008001B4O0006000800024O000600066O00040006000200062O0004004B030100010004C23O004B0301002E12009B00500301009C0004C23O005003012O002C000400013O0012990005009D3O0012990006009E4O00E5000400064O001C01045O002EB8009F00420001009F0004C23O009203012O002C00046O0006000500013O00122O000600A03O00122O000700A16O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004009203013O0004C23O009203012O002C000400023O00068E0004009203013O0004C23O009203012O002C000400033O0020A100040004000F4O0004000200024O000500033O00202O0005000500104O00050002000200062O00040092030100050004C23O009203012O002C000400033O0020050004000400112O00A900040002000200263500040092030100460004C23O009203012O002C000400043O00068E0004009203013O0004C23O009203012O002C000400033O0020050004000400A22O00A900040002000200068E0004009203013O0004C23O009203012O002C00046O0046000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O0004000400154O000400020002000E2O00A50092030100040004C23O009203012O002C000400053O000E1C001A0092030100040004C23O009203012O002C000400064O00DA00055O00202O00050005001B4O000600073O00202O00060006001C4O00085O00202O00080008001B4O0006000800024O000600066O00040006000200062O0004009203013O0004C23O009203012O002C000400013O001299000500A63O001299000600A74O00E5000400064O001C01045O001299000300073O0004C23O008502010004C23O009603010004C23O008202010026A400010007000100090004C23O00070001001299000200014O00F1000300033O0026570002009E030100010004C23O009E0301002ECD00A9009A030100A80004C23O009A0301001299000300013O0026A400030010040100010004C23O00100401001299000400013O002ECD00AA00A8030100AB0004C23O00A803010026A4000400A8030100090004C23O00A80301001299000300093O0004C23O001004010026A4000400A2030100010004C23O00A203012O002C00056O0006000600013O00122O000700AC3O00122O000800AD6O0006000800024O00050005000600202O0005000500214O00050002000200062O000500D803013O0004C23O00D803012O002C000500153O00068E000500D803013O0004C23O00D803012O002C000500033O00200500050005000F2O00A9000500020002002635000500D8030100040004C23O00D803012O002C000500073O0020050005000500AE2O00A9000500020002002635000500D8030100AF0004C23O00D803012O002C00056O0006000600013O00122O000700B03O00122O000800B16O0006000800024O00050005000600202O00050005005A4O00050002000200062O000500D803013O0004C23O00D803012O002C000500064O002C00065O00206C0006000600B22O00A90005000200020006B5000500D3030100010004C23O00D30301002E1200B300D8030100B40004C23O00D803012O002C000500013O001299000600B53O001299000700B64O00E5000500074O001C01056O002C00056O0006000600013O00122O000700B73O00122O000800B86O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005000E04013O0004C23O000E04012O002C0005000B3O00068E0005000E04013O0004C23O000E04012O002C00056O0006000600013O00122O000700B93O00122O000800BA6O0006000800024O00050005000600202O00050005005A4O00050002000200062O0005000E04013O0004C23O000E04012O002C000500033O00207C0005000500224O00075O00202O00070007006C4O00050007000200062O0005000E04013O0004C23O000E04012O002C000500033O0020AC0005000500BB4O00075O00202O00070007006C4O00050007000200262O0005000E040100BC0004C23O000E04012O002C000500064O00DA00065O00202O00060006003C4O000700073O00202O00070007001C4O00095O00202O00090009003C4O0007000900024O000700076O00050007000200062O0005000E04013O0004C23O000E04012O002C000500013O001299000600BD3O001299000700BE4O00E5000500074O001C01055O001299000400093O0004C23O00A203010026A400030093040100090004C23O00930401001299000400013O0026A400040017040100090004C23O00170401001299000300073O0004C23O009304010026A400040013040100010004C23O001304012O002C00056O0006000600013O00122O000700BF3O00122O000800C06O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005005204013O0004C23O005204012O002C0005000B3O00068E0005005204013O0004C23O005204012O002C000500033O00207C0005000500224O00075O00202O0007000700C14O00050007000200062O0005005204013O0004C23O005204012O002C000500073O0020050005000500AE2O00A900050002000200263500050052040100AF0004C23O005204012O002C00056O0006000600013O00122O000700C23O00122O000800C36O0006000800024O00050005000600202O00050005005A4O00050002000200062O0005005204013O0004C23O005204012O002C000500033O00200500050005000F2O00A900050002000200263500050052040100040004C23O005204012O002C000500064O00DA00065O00202O00060006003C4O000700073O00202O00070007001C4O00095O00202O00090009003C4O0007000900024O000700076O00050007000200062O0005005204013O0004C23O005204012O002C000500013O001299000600C43O001299000700C54O00E5000500074O001C01056O002C000500033O00207C0005000500C64O00075O00202O0007000700284O00050007000200062O0005009104013O0004C23O009104012O002C000500033O0020050005000500C72O00A90005000200020026A400050091040100010004C23O009104012O002C000500033O00207C0005000500224O00075O00202O0007000700254O00050007000200062O0005009104013O0004C23O009104012O002C000500033O0020050005000500112O00A9000500020002000E1C00490074040100050004C23O007404012O002C00056O00D0000600013O00122O000700C83O00122O000800C96O0006000800024O00050005000600202O0005000500154O000500020002000E9D00490079040100050004C23O007904012O002C000500033O0020050005000500112O00A9000500020002000E1C00460091040100050004C23O009104012O002C000500033O00207C0005000500244O00075O00202O0007000700CA4O00050007000200062O0005009104013O0004C23O009104012O002C000500064O00DA000600163O00202O0006000600CB4O000700073O00202O00070007001C4O00095O00202O0009000900284O0007000900024O000700076O00050007000200062O0005009104013O0004C23O009104012O002C000500013O001299000600CC3O001299000700CD4O00E5000500074O001C01055O001299000400093O0004C23O001304010026A40003009F030100070004C23O009F0301001299000100073O0004C23O000700010004C23O009F03010004C23O000700010004C23O009A03010004C23O000700010004C23O009D04010004C23O000200012O00093O00017O00793O00028O00025O008EA040025O00FAAE40027O0040025O0072B340025O0050A440025O00809C40025O00709940025O0060AB40025O00B6B040026O00F03F026O000840025O00FDB040025O0010B24003093O000F1CF8F7200BD4E42C03043O00964E6E9B03073O0049735265616479030D3O00417263616E6543686172676573030E3O00B1CA32E2AC11B9548DC00AE0A31703083O0020E5A54781C47EDF030F3O00432O6F6C646F776E52656D61696E73026O003240025O00849240025O00207F4003093O00417263616E654F726203093O004973496E52616E6765026O004440031A3O00C29BC7808FD0FC86D683C1D4CC8CFB938EC1C29DCD8E8F9592D903063O00B5A3E9A42OE1030D3O0071993D765E8E1C7642993F705503043O001730EB5E03103O00417263616E65436861726765734D6178030E3O004D616E6150657263656E74616765026O002440030D3O00417263616E6542612O72616765030E3O0049735370652O6C496E52616E6765025O005BB340025O00BC9340031E3O007DC8DB5C5936ED7EDBCA4F5634D73CDBD7586821DD68DBCC54583D922D8803073O00B21CBAB83D3753026O007D40025O00C2A840025O0084B040025O0028A040030D3O00CCE8BBBF1C37F1E782B61F3BED03063O005E9F80D2D96803093O0075EF09BC5E6BF0755E03083O001A309966DF3F1F99030B3O004973417661696C61626C6503093O002756E2F00354E4FC0C03043O009362208D026O002840030B3O003951E0CB0853780D51E4CF03073O002B782383AA6636030B3O00751484B7ABB5B7411480B303073O00E43466E7D6C5D0030E3O002AEF60C9E2841FC216E558CBED8203083O00B67E8015AA8AEB79030E3O00BFD520E58E1C361283DF18E7811A03083O0066EBBA5586E6735003083O0042752O66446F776E030F3O00417263616E65537572676542752O66030A3O0074043F4D75D126781E3C03073O0042376C5E3F12B403093O00359F8636295C3B9F8703063O003974EDE5574703093O008BA3EEE679EB68B8B303073O0027CAD18D87178E03073O004368617267657303093O00DE210A0B3CFDD0210B03063O00989F53696A52025O00A89140025O0064B340030D3O005368696674696E67506F776572031D3O0092CE58F4DD558FC16EE2C64B84D411F3C659BED45EE6C84888C95FB29B03063O003CE1A63192A9030D3O00011B3B2204152O1B223A04143B03063O00674F7E4F4A6103113O00446562752O665265667265736861626C6503133O004E657468657254656D70657374446562752O66026O001840030A3O00956DD1515F08A87ED47603063O007ADA1FB3133E025O00B08340025O00C4A740030D3O004E657468657254656D70657374031D3O00BDD3D9C9CCB37AA7D3C0D1CCB251F3D7C2C4F6B34AA7D7D9C8C6AF05E703073O0025D3B6ADA1A9C1025O0024A340025O0096B240030F3O00E5DF443DFC0BD0DCDD4B33E107FACA03073O0095A4AD275C926E025O006CA340025O0023B340025O00E9B140025O00A09D40030F3O00417263616E654578706C6F73696F6E026O003E4003203O00F235131E141ECC22080F1614E02E1F115A1AFC222F0D150FF2331910145BA27303063O007B9347707F7A025O00F89340025O00288440030E3O00D6284ED8267E94FE295ED0247EAA03073O00D9975A2DB9481B030A3O0049734361737461626C6503063O0042752O66557003133O00417263616E65417274692O6C65727942752O6603103O00436C65617263617374696E6742752O66030E3O00F773F2115ECC7AF31A53EE7DE01B03053O0036A31C8772030B3O0042752O6652656D61696E73025O00F6A840025O00804B40030E3O00417263616E654D692O73696C6573031E3O0029C95E83407A17D654915D7624DE4EC24F702DE44F8D5A7E3CD2528C0E2903063O001F48BB3DE22E030D3O00E21440D3497B06C21451D3407B03073O0044A36623B2271E026O001040031D3O00BF62D9C60DB0BC13BF62C8C604B0C310B175E5D50CA18205B77FD4875B03083O0071DE10BAA763D5E3002F022O0012993O00014O00F1000100013O000ED10001000600013O0004C23O00060001002ECD00030002000100020004C23O00020001001299000100013O0026570001000B000100040004C23O000B0001002ECD00050092000100060004C23O00920001001299000200014O00F1000300033O00265700020011000100010004C23O00110001002EB8000700FEFF2O00080004C23O000D0001001299000300013O002ECD000900180001000A0004C23O001800010026A4000300180001000B0004C23O001800010012990001000C3O0004C23O009200010026A400030012000100010004C23O00120001001299000400013O002E12000D00880001000E0004C23O008800010026A400040088000100010004C23O008800012O002C00056O0006000600013O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O00050002000200062O0005004800013O0004C23O004800012O002C000500023O00068E0005004800013O0004C23O004800012O002C000500033O00068E0005003200013O0004C23O003200012O002C000500043O0006B500050035000100010004C23O003500012O002C000500033O0006B500050048000100010004C23O004800012O002C000500054O002C000600063O0006AF00050048000100060004C23O004800012O002C000500073O0020050005000500122O00A90005000200020026A400050048000100010004C23O004800012O002C00056O00D0000600013O00122O000700133O00122O000800146O0006000800024O00050005000600202O0005000500154O000500020002000E9D0016004A000100050004C23O004A0001002E120017005A000100180004C23O005A00012O002C000500084O001400065O00202O0006000600194O000700093O00202O00070007001A00122O0009001B6O0007000900024O000700076O00050007000200062O0005005A00013O0004C23O005A00012O002C000500013O0012990006001C3O0012990007001D4O00E5000500074O001C01056O002C00056O0006000600013O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O0005000500114O00050002000200062O0005008700013O0004C23O008700012O002C0005000A3O00068E0005008700013O0004C23O008700012O002C000500073O0020740005000500124O0005000200024O000600073O00202O0006000600204O00060002000200062O00050074000100060004C23O007400012O002C000500073O0020050005000500212O00A900050002000200263500050087000100220004C23O008700012O002C000500084O004300065O00202O0006000600234O000700093O00202O0007000700244O00095O00202O0009000900234O0007000900024O000700076O00050007000200062O00050082000100010004C23O00820001002E1200250087000100260004C23O008700012O002C000500013O001299000600273O001299000700284O00E5000500074O001C01055O0012990004000B3O000ED1000B008C000100040004C23O008C0001002EB800290091FF2O002A0004C23O001B00010012990003000B3O0004C23O001200010004C23O001B00010004C23O001200010004C23O009200010004C23O000D00010026A4000100872O0100010004C23O00872O01001299000200013O002EB8002B00060001002B0004C23O009B00010026A40002009B0001000B0004C23O009B00010012990001000B3O0004C23O00872O01002EB8002C00FAFF2O002C0004C23O009500010026A400020095000100010004C23O00950001001299000300013O0026A4000300812O0100010004C23O00812O012O002C00046O0006000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400272O013O0004C23O00272O012O002C0004000B3O00068E000400272O013O0004C23O00272O012O002C0004000C3O00068E000400B500013O0004C23O00B500012O002C0004000D3O0006B5000400B8000100010004C23O00B800012O002C0004000D3O0006B5000400272O0100010004C23O00272O012O002C000400054O002C000500063O0006AF000400272O0100050004C23O00272O012O002C00046O0006000500013O00122O0006002F3O00122O000700306O0005000700024O00040004000500202O0004000400314O00040002000200062O000400D000013O0004C23O00D000012O002C00046O0046000500013O00122O000600323O00122O000700336O0005000700024O00040004000500202O0004000400154O000400020002000E2O003400272O0100040004C23O00272O012O002C00046O0006000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O0004000400314O00040002000200062O000400E400013O0004C23O00E400012O002C00046O0046000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400154O000400020002000E2O003400272O0100040004C23O00272O012O002C00046O0006000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O0004000400314O00040002000200062O000400F800013O0004C23O00F800012O002C00046O0046000500013O00122O0006003B3O00122O0007003C6O0005000700024O00040004000500202O0004000400154O000400020002000E2O003400272O0100040004C23O00272O012O002C000400073O00207C00040004003D4O00065O00202O00060006003E4O00040006000200062O000400272O013O0004C23O00272O012O002C00046O00A7000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500202O0004000400314O00040002000200062O000400132O0100010004C23O00132O012O002C00046O00D0000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O0004000400154O000400020002000E9D003400292O0100040004C23O00292O012O002C00046O00D0000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400454O000400020002002657000400292O0100010004C23O00292O012O002C00046O00D0000500013O00122O000600463O00122O000700476O0005000700024O00040004000500202O0004000400154O000400020002000E9D003400292O0100040004C23O00292O01002EB800480013000100490004C23O003A2O012O002C000400084O002D00055O00202O00050005004A4O000600093O00202O00060006001A00122O0008001B6O0006000800024O000600066O000700016O00040007000200062O0004003A2O013O0004C23O003A2O012O002C000400013O0012990005004B3O0012990006004C4O00E5000400064O001C01046O002C00046O0006000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400802O013O0004C23O00802O012O002C0004000E3O00068E000400802O013O0004C23O00802O012O002C000400093O00207C00040004004F4O00065O00202O0006000600504O00040006000200062O000400802O013O0004C23O00802O012O002C000400073O0020A10004000400124O0004000200024O000500073O00202O0005000500204O00050002000200062O000400802O0100050004C23O00802O012O002C000400073O00207C00040004003D4O00065O00202O00060006003E4O00040006000200062O000400802O013O0004C23O00802O012O002C0004000F3O000E9D0051006D2O0100040004C23O006D2O012O002C000400103O000E9D0051006D2O0100040004C23O006D2O012O002C00046O00A7000500013O00122O000600523O00122O000700536O0005000700024O00040004000500202O0004000400314O00040002000200062O000400802O0100010004C23O00802O01002ECD005400802O0100550004C23O00802O012O002C000400084O00DA00055O00202O0005000500564O000600093O00202O0006000600244O00085O00202O0008000800564O0006000800024O000600066O00040006000200062O000400802O013O0004C23O00802O012O002C000400013O001299000500573O001299000600584O00E5000400064O001C01045O0012990003000B3O000EA2000B00A0000100030004C23O00A000010012990002000B3O0004C23O009500010004C23O00A000010004C23O009500010026570001008B2O01000C0004C23O008B2O01002EB8005900240001005A0004C23O00AD2O012O002C00026O0006000300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200982O013O0004C23O00982O012O002C000200113O0006B50002009A2O0100010004C23O009A2O01002E12005E002E0201005D0004C23O002E0201002E120060002E0201005F0004C23O002E02012O002C000200084O001400035O00202O0003000300614O000400093O00202O00040004001A00122O000600626O0004000600024O000400046O00020004000200062O0002002E02013O0004C23O002E02012O002C000200013O00128D000300633O00122O000400646O000200046O00025O00044O002E0201000EA2000B0007000100010004C23O00070001001299000200013O002ECD006600B62O0100650004C23O00B62O010026A4000200B62O01000B0004C23O00B62O01001299000100043O0004C23O00070001002EB8002500FAFF2O00250004C23O00B02O010026A4000200B02O0100010004C23O00B02O012O002C00036O0006000400013O00122O000500673O00122O000600686O0004000600024O00030003000400202O0003000300694O00030002000200062O000300E62O013O0004C23O00E62O012O002C000300123O00068E000300E62O013O0004C23O00E62O012O002C000300073O00207C00030003006A4O00055O00202O00050005006B4O00030005000200062O000300E62O013O0004C23O00E62O012O002C000300073O00207C00030003006A4O00055O00202O00050005006C4O00030005000200062O000300E62O013O0004C23O00E62O012O002C00036O0008010400013O00122O0005006D3O00122O0006006E6O0004000600024O00030003000400202O0003000300154O0003000200024O000400073O00202O00040004006F4O00065O00202O00060006006B4O00040006000200202O00040004000400202O00040004000C00062O000400E82O0100030004C23O00E82O01002ECD007000F92O0100710004C23O00F92O012O002C000300084O00DA00045O00202O0004000400724O000500093O00202O0005000500244O00075O00202O0007000700724O0005000700024O000500056O00030005000200062O000300F92O013O0004C23O00F92O012O002C000300013O001299000400733O001299000500744O00E5000300054O001C01036O002C00036O0006000400013O00122O000500753O00122O000600766O0004000600024O00030003000400202O0003000300114O00030002000200062O0003002902013O0004C23O002902012O002C0003000A3O00068E0003002902013O0004C23O002902012O002C0003000F3O00269200030013020100770004C23O001302012O002C000300103O00269200030013020100770004C23O001302012O002C000300073O00207C00030003006A4O00055O00202O00050005006C4O00030005000200062O0003002902013O0004C23O002902012O002C000300073O0020050003000300122O00A90003000200020026A4000300290201000C0004C23O002902012O002C000300084O00DA00045O00202O0004000400234O000500093O00202O0005000500244O00075O00202O0007000700234O0005000700024O000500056O00030005000200062O0003002902013O0004C23O002902012O002C000300013O001299000400783O001299000500794O00E5000300054O001C01035O0012990002000B3O0004C23O00B02O010004C23O000700010004C23O002E02010004C23O000200012O00093O00017O00B83O00028O00026O00F03F026O000840025O002AA94003083O00446562752O66557003143O00546F7563686F667468654D616769446562752O66025O008CA240025O00E8A640025O00B6B040025O00249940025O00CAB240025O0082AA40025O00D4B040025O007C9140025O00E88240025O000EA640025O0062B040027O0040030B3O000FEE8917CF2BCF9F04C62B03053O00A14E9CEA76030F3O00432O6F6C646F776E52656D61696E73026O003E40030C3O0095B6CDD5A6B9DDEFB7B6DBD703043O00BCC7D7A9030A3O00432O6F6C646F776E557003123O0052616469616E74537061726B446562752O6603193O0052616469616E74537061726B56756C6E65726162696C697479030E3O00C8064A78E0F30F4B73EDD108587203053O00889C693F1B025O00309640025O00888340025O008EA940025O0023B040030C3O00298D7D3D1A826D070B8D6B3F03043O00547BEC19030B3O004973417661696C61626C65025O0026AA40025O0014AC40025O00208440025O00F49840025O00C49640025O00BEA040030C3O00C28AAE1EADBBE4B8BA162OBE03063O00D590EBCA77CC025O00D49540025O004C9640025O00F4A340025O0004AD40025O00C09640025O00608C40025O0046A840025O00907340025O0006B040025O00449040025O00B09240025O00B88E40025O001AA240025O00BC9940025O002O9040025O00188140025O00209E40025O006DB340025O0061B240025O00B88F40030E3O00F5A9E9CD6CA5D38BE6C97890D3AB03063O00D7B6C687A719030A3O0049734361737461626C65030A3O00446562752O66446F776E03083O0042752O66446F776E030F3O00417263616E65537572676542752O66030B3O00AC5BE949834CD95D9F4EEF03043O0028ED298A030B3O00E6662OF944C247EFEA4DC203053O002AA7149A9803073O0067FFAC4356244703063O00412A9EC2221103063O00457869737473030E3O00436F6E6A7572654D616E6147656D03183O0019285C0638FF1ED117265C0D12EA1EE35A2A530523AD48B603083O008E7A47326C4D8D7B03073O0038A3F1191C10AF03053O005B75C29F7803073O0049735265616479030E3O00391C2D1B34F52D141A0E1722F43603073O00447A7D5E78559103093O0042752O66537461636B03103O00436C65617263617374696E6742752O6603063O0042752O66557003073O004D616E6147656D025O0088AA40025O00A8804003103O001A1DC15FF7DEBF1A5CC25FC1D7FA434C03073O00DA777CAF3EA8B9025O0066A440025O00A0874003073O0088F146C582F54503043O00A4C59028030E3O00A0F1B988DCB28AFEADBBD2A186E203063O00D6E390CAEBBD03083O005072657647434450030B3O00417263616E655375726765026O006440025O00BC904003103O00E0A4897A2FB45631ADA886721EF3076E03083O005C8DC5E71B70D333030B3O00C7ED89A2DFE3CC9FB1D6E303053O00B1869FEAC3030D3O0093EE2BA8CCAFDF3AADD9B8F82B03053O00A9DD8B5FC0030A3O00FF997C3E2C23FB88773003063O0046BEEB1F5F42030B3O0042752O6652656D61696E7303073O0048617354696572026O00104003123O00417263616E654F7665726C6F616442752O6603093O009FF415E5E4AEEB15E803053O0085DA827A86025O00804640030E3O0008F0F6C7D4AC3E28F7E6E9DDA43103073O00585C9F83A4BCC3030E3O00B421AA48DFE4DB9426BA66D6ECD403073O00BDE04EDF2BB78B026O003440025O00C1B140025O00406D40025O00D4A540025O00088D40025O004C9540026O007840025O00ABB040025O00C9B240025O0018AB40025O0018AF40025O00808E40025O0046B340030E3O00F8C297724EC3CB967943E1CC857803053O0026ACADE211030D3O00417263616E6542612O72616765025O0078AB40025O00606840030E3O00546F7563686F667468654D616769030E3O0049735370652O6C496E52616E676503193O00591E39EC452E23E9720524EA721C2DE8445121EE441F6CBC1D03043O008F2D714C030C3O0049734368612O6E656C696E6703093O0045766F636174696F6E030E3O004D616E6150657263656E74616765025O00C05740030B3O008BB10C34B7B62F28B7AA1103043O005C2OD87C026O002440030B3O007A20AF41F35E01B952FA5E03053O009D3B52CC20025O00E88740025O00AC9D40030B3O0053746F7043617374696E67030E3O00417263616E654D692O73696C6573031F3O003B3FEDF9ECE6ECB03B2AEAF5E7AAD6A7373DE2EEE0E5DDF1353FEAF4A9B98103083O00D1585E839A898AB3025O00808540025O0024AD40025O00D6AE40025O00889740030D3O0009B3C77D102613233AB3C57B1B03083O004248C1A41C7E4351025O00709E40025O00E2A54003163O00E63EAB592873D82EA94A3477E029E855277FE96CFB0C03063O0016874CC83846025O00A4AF40025O00609F4003093O00A826F7275CF5843FF603063O0081ED5098443D030E3O0065A711F014185E45A001DE1D105103073O003831C864937C77030E3O00F831AAF3C431B9E4C43B92F1CB3703043O0090AC5EDF026O002E4003113O002119AD44251BAB482A4FAF462D01E2147203043O0027446FC2025O00D2AF40025O00F08040025O00307840025O0060A840000D042O0012993O00014O00F1000100023O0026A43O00FA030100020004C23O00FA03010026A40001006B000100030004C23O006B0001002EB800040046000100040004C23O004C00012O002C00035O00068E0003004C00013O0004C23O004C00012O002C000300013O00068E0003004C00013O0004C23O004C00012O002C000300023O00207C0003000300054O000500033O00202O0005000500064O00030005000200062O0003004C00013O0004C23O004C00012O002C000300044O002C000400053O0006870003001D000100040004C23O001D00012O002C000300064O002C000400053O0006AF0003004C000100040004C23O004C0001001299000300014O00F1000400063O002ECD00070026000100080004C23O002600010026A400030026000100010004C23O00260001001299000400014O00F1000500053O001299000300023O0026570003002A000100020004C23O002A0001002E120009001F0001000A0004C23O001F00012O00F1000600063O0026A400040038000100020004C23O003800010026A40005002D000100010004C23O002D00012O002C000700074O00980007000100022O0026010600073O00068E0006004C00013O0004C23O004C00012O00E4000600023O0004C23O004C00010004C23O002D00010004C23O004C00010026A40004002B000100010004C23O002B0001001299000700013O002EB8000B00070001000B0004C23O004200010026A400070042000100010004C23O00420001001299000500014O00F1000600063O001299000700023O00265700070046000100020004C23O00460001002ECD000D003B0001000C0004C23O003B0001001299000400023O0004C23O002B00010004C23O003B00010004C23O002B00010004C23O004C00010004C23O001F0001002ECD000F00620001000E0004C23O006200012O002C000300044O002C000400053O00063F01040005000100030004C23O005600012O002C000300064O002C000400053O0006D900040062000100030004C23O00620001001299000300014O00F1000400043O0026A400030058000100010004C23O005800012O002C000500084O00980005000100022O0026010400053O00068E0004006200013O0004C23O006200012O00E4000400023O0004C23O006200010004C23O005800012O002C000300094O00980003000100022O0026010200033O002E120010000C040100110004C23O000C040100068E0002000C04013O0004C23O000C04012O00E4000200023O0004C23O000C0401000EA2001200822O0100010004C23O00822O01001299000300014O00F1000400043O0026A40003006F000100010004C23O006F0001001299000400013O0026A4000400052O0100010004C23O00052O012O002C000500013O0006B5000500D5000100010004C23O00D500012O002C000500034O00460006000A3O00122O000700133O00122O000800146O0006000800024O00050005000600202O0005000500154O000500020002000E2O001600D5000100050004C23O00D500012O002C000500034O00A70006000A3O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500194O00050002000200062O00050099000100010004C23O009900012O002C000500023O00209A0005000500054O000700033O00202O00070007001A4O00050007000200062O00050099000100010004C23O009900012O002C000500023O00207C0005000500054O000700033O00202O00070007001B4O00050007000200062O000500D500013O0004C23O00D500012O002C000500034O00D00006000A3O00122O0007001C3O00122O0008001D6O0006000800024O00050005000600202O0005000500154O0005000200022O002C0006000B3O00200E01060006000300063F01050008000100060004C23O00AC00012O002C000500023O00207C0005000500054O000700033O00202O0007000700064O00050007000200062O000500D500013O0004C23O00D500012O002C000500044O002C000600053O000687000500B4000100060004C23O00B400012O002C000500064O002C000600053O0006AF000500D5000100060004C23O00D50001001299000500014O00F1000600073O0026A4000500C5000100020004C23O00C50001002ECD001F00B80001001E0004C23O00B800010026A4000600B8000100010004C23O00B800012O002C0008000C4O00980008000100022O0026010700083O00068E000700D500013O0004C23O00D500012O00E4000700023O0004C23O00D500010004C23O00B800010004C23O00D500010026A4000500B6000100010004C23O00B60001001299000800013O002ECD002000CF000100210004C23O00CF00010026A4000800CF000100010004C23O00CF0001001299000600014O00F1000700073O001299000800023O0026A4000800C8000100020004C23O00C80001001299000500023O0004C23O00B600010004C23O00C800010004C23O00B600012O002C00055O00068E000500042O013O0004C23O00042O012O002C000500034O00060006000A3O00122O000700223O00122O000800236O0006000800024O00050005000600202O0005000500244O00050002000200062O000500042O013O0004C23O00042O012O002C0005000D3O00068E000500042O013O0004C23O00042O01001299000500014O00F1000600073O002E12002500F6000100260004C23O00F600010026A4000500F6000100020004C23O00F60001000EA2000100EB000100060004C23O00EB00012O002C0008000E4O00980008000100022O0026010700083O00068E000700042O013O0004C23O00042O012O00E4000700023O0004C23O00042O010004C23O00EB00010004C23O00042O010026A4000500E7000100010004C23O00E70001001299000800013O0026A4000800FE000100010004C23O00FE0001001299000600014O00F1000700073O001299000800023O0026A4000800F9000100020004C23O00F90001001299000500023O0004C23O00E700010004C23O00F900010004C23O00E70001001299000400023O0026A4000400792O0100020004C23O00792O01001299000500013O002ECD0027000E2O0100280004C23O000E2O01000EA20002000E2O0100050004C23O000E2O01001299000400123O0004C23O00792O01002ECD002900082O01002A0004C23O00082O010026A4000500082O0100010004C23O00082O012O002C00065O00068E000600252O013O0004C23O00252O012O002C000600013O00068E000600252O013O0004C23O00252O012O002C000600034O00060007000A3O00122O0008002B3O00122O0009002C6O0007000900024O00060006000700202O0006000600244O00060002000200062O000600252O013O0004C23O00252O012O002C0006000F3O0006B5000600272O0100010004C23O00272O01002EB8002D001F0001002E0004C23O00442O01001299000600014O00F1000700083O002ECD002F003C2O0100300004C23O003C2O010026A40006003C2O0100020004C23O003C2O01002E120032002D2O0100310004C23O002D2O010026A40007002D2O0100010004C23O002D2O012O002C000900104O00980009000100022O0026010800093O0006B5000800382O0100010004C23O00382O01002ECD003300442O0100340004C23O00442O012O00E4000800023O0004C23O00442O010004C23O002D2O010004C23O00442O01002ECD000F00292O0100350004C23O00292O010026A4000600292O0100010004C23O00292O01001299000700014O00F1000800083O001299000600023O0004C23O00292O01002ECD003600772O0100370004C23O00772O012O002C00065O00068E000600772O013O0004C23O00772O012O002C000600023O00207C0006000600054O000800033O00202O0008000800064O00060008000200062O000600772O013O0004C23O00772O012O002C000600044O002C000700053O00063F01070005000100060004C23O00582O012O002C000600064O002C000700053O0006D9000700772O0100060004C23O00772O01001299000600014O00F1000700083O0026A4000600672O0100020004C23O00672O010026A40007005C2O0100010004C23O005C2O012O002C000900114O00980009000100022O0026010800093O00068E000800772O013O0004C23O00772O012O00E4000800023O0004C23O00772O010004C23O005C2O010004C23O00772O010026A40006005A2O0100010004C23O005A2O01001299000900013O002EB800380006000100380004C23O00702O01000EA2000200702O0100090004C23O00702O01001299000600023O0004C23O005A2O010026A40009006A2O0100010004C23O006A2O01001299000700014O00F1000800083O001299000900023O0004C23O006A2O010004C23O005A2O01001299000500023O0004C23O00082O010026570004007D2O0100120004C23O007D2O01002EB8003900F7FE2O003A0004C23O00720001001299000100033O0004C23O00822O010004C23O007200010004C23O00822O010004C23O006F0001002E12003C00F00201003B0004C23O00F002010026A4000100F0020100020004C23O00F00201001299000300013O0026A40003000D020100010004C23O000D0201001299000400013O002ECD003D00902O01003E0004C23O00902O010026A4000400902O0100020004C23O00902O01001299000300023O0004C23O000D02010026A40004008A2O0100010004C23O008A2O01002E12004000D92O01003F0004C23O00D92O012O002C000500034O00060006000A3O00122O000700413O00122O000800426O0006000800024O00050005000600202O0005000500434O00050002000200062O000500D92O013O0004C23O00D92O012O002C000500123O00068E000500D92O013O0004C23O00D92O012O002C000500023O00207C0005000500444O000700033O00202O0007000700064O00050007000200062O000500D92O013O0004C23O00D92O012O002C000500133O00207C0005000500454O000700033O00202O0007000700464O00050007000200062O000500D92O013O0004C23O00D92O012O002C000500034O008C0006000A3O00122O000700473O00122O000800486O0006000800024O00050005000600202O0005000500154O00050002000200262O000500D92O0100160004C23O00D92O012O002C000500034O00D00006000A3O00122O000700493O00122O0008004A6O0006000800024O00050005000600202O0005000500154O0005000200022O002C000600143O0006AF000500D92O0100060004C23O00D92O012O002C000500154O00A70006000A3O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O00050005004D4O00050002000200062O000500D92O0100010004C23O00D92O012O002C000500164O002C000600033O00206C00060006004E2O00A900050002000200068E000500D92O013O0004C23O00D92O012O002C0005000A3O0012990006004F3O001299000700504O00E5000500074O001C01056O002C000500154O00060006000A3O00122O000700513O00122O000800526O0006000800024O00050005000600202O0005000500534O00050002000200062O0005000B02013O0004C23O000B02012O002C000500173O00068E0005000B02013O0004C23O000B02012O002C000500034O00060006000A3O00122O000700543O00122O000800556O0006000800024O00050005000600202O0005000500244O00050002000200062O0005000B02013O0004C23O000B02012O002C000500133O002O200005000500564O000700033O00202O0007000700574O00050007000200262O0005000B020100120004C23O000B02012O002C000500133O00207C0005000500584O000700033O00202O0007000700464O00050007000200062O0005000B02013O0004C23O000B02012O002C000500164O002C000600183O00206C0006000600592O00A90005000200020006B500050006020100010004C23O00060201002ECD005A000B0201005B0004C23O000B02012O002C0005000A3O0012990006005C3O0012990007005D4O00E5000500074O001C01055O001299000400023O0004C23O008A2O01002E12005F00EB0201005E0004C23O00EB02010026A4000300EB020100020004C23O00EB02012O002C000400154O00060005000A3O00122O000600603O00122O000700616O0005000700024O00040004000500202O0004000400534O00040002000200062O0004004B02013O0004C23O004B02012O002C000400173O00068E0004004B02013O0004C23O004B02012O002C000400034O00A70005000A3O00122O000600623O00122O000700636O0005000700024O00040004000500202O0004000400244O00040002000200062O0004004B020100010004C23O004B02012O002C000400133O00200E00040004006400122O000600026O000700033O00202O0007000700654O00040007000200062O0004004B02013O0004C23O004B02012O002C000400193O00068E0004003E02013O0004C23O003E02012O002C000400193O00068E0004004B02013O0004C23O004B02012O002C000400133O00200E00040004006400122O000600126O000700033O00202O0007000700654O00040007000200062O0004004B02013O0004C23O004B0201002ECD0066004B020100670004C23O004B02012O002C000400164O002C000500183O00206C0005000500592O00A900040002000200068E0004004B02013O0004C23O004B02012O002C0004000A3O001299000500683O001299000600694O00E5000400064O001C01046O002C000400013O0006B5000400EA020100010004C23O00EA02012O002C000400034O00D00005000A3O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O0004000400154O0004000200022O00C80005000B6O0006001A3O00122O000700026O0008001B6O000900034O0006000A000A3O00122O000B006C3O00122O000C006D6O000A000C00024O00090009000A00202O0009000900244O00090002000200062O0009006C02013O0004C23O006C02012O002C000900034O00D0000A000A3O00122O000B006E3O00122O000C006F6O000A000C00024O00090009000A00202O0009000900244O0009000200022O0004010800094O003400063O00024O0007001C3O00122O000800026O0009001B6O000A00034O0006000B000A3O00122O000C006C3O00122O000D006D6O000B000D00024O000A000A000B00202O000A000A00244O000A0002000200062O000A008302013O0004C23O008302012O002C000A00034O00D0000B000A3O00122O000C006E3O00122O000D006F6O000B000D00024O000A000A000B00202O000A000A00244O000A000200022O00040109000A4O004700073O00022O002B0106000600072O001E00050005000600063F0104001F000100050004C23O00A702012O002C000400133O0020950004000400704O000600033O00202O0006000600464O0004000600024O0005001B6O000600133O00206200060006007100122O000800163O00122O000900126O00060009000200062O0006009C02013O0004C23O009C02012O002C000600133O00201900060006007100122O000800163O00122O000900726O0006000900024O000600064O00A900050002000200108F000500030005000687000500A7020100040004C23O00A702012O002C000400133O00207C0004000400584O000600033O00202O0006000600734O00040006000200062O000400EA02013O0004C23O00EA02012O002C000400034O00460005000A3O00122O000600743O00122O000700756O0005000700024O00040004000500202O0004000400154O000400020002000E2O007600EA020100040004C23O00EA02012O002C000400034O001A0105000A3O00122O000600773O00122O000700786O0005000700024O00040004000500202O0004000400154O0004000200024O0005000B3O00202O00050005007200062O000400C7020100050004C23O00C702012O002C000400034O00460005000A3O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O0004000400154O000400020002000E2O007B00EA020100040004C23O00EA02012O002C000400044O002C000500053O000687000400CF020100050004C23O00CF02012O002C000400064O002C000500053O0006AF000400EA020100050004C23O00EA0201001299000400014O00F1000500063O002ECD007D00E20201007C0004C23O00E202010026A4000400E2020100020004C23O00E20201002657000500D9020100010004C23O00D90201002ECD007E00D50201007F0004C23O00D502012O002C0007000C4O00980007000100022O0026010600073O00068E000600EA02013O0004C23O00EA02012O00E4000600023O0004C23O00EA02010004C23O00D502010004C23O00EA0201002657000400E6020100010004C23O00E60201002ECD008000D1020100810004C23O00D10201001299000500014O00F1000600063O001299000400023O0004C23O00D10201001299000300123O0026A4000300872O0100120004C23O00872O01001299000100123O0004C23O00F002010004C23O00872O01000ED1000100F4020100010004C23O00F40201002EB800820012FD2O00830004C23O00040001001299000300013O002E1200840078030100850004C23O007803010026A400030078030100010004C23O00780301001299000400013O002E1200860071030100870004C23O007103010026A400040071030100010004C23O007103012O002C000500034O00060006000A3O00122O000700883O00122O000800896O0006000800024O00050005000600202O0005000500534O00050002000200062O0005003303013O0004C23O003303012O002C0005001D3O00068E0005003303013O0004C23O003303012O002C0005001E3O00068E0005001103013O0004C23O001103012O002C0005001F3O0006B500050014030100010004C23O001403012O002C0005001E3O0006B500050033030100010004C23O003303012O002C000500204O002C000600143O0006AF00050033030100060004C23O003303012O002C000500133O00200E00050005006400122O000700026O000800033O00202O00080008008A4O00050008000200062O0005003303013O0004C23O00330301002E12008C00330301008B0004C23O003303012O002C000500164O00DA000600033O00202O00060006008D4O000700023O00202O00070007008E4O000900033O00202O00090009008D4O0007000900024O000700076O00050007000200062O0005003303013O0004C23O003303012O002C0005000A3O0012990006008F3O001299000700904O00E5000500074O001C01056O002C000500133O00207C0005000500914O000700033O00202O0007000700924O00050007000200062O0005005D03013O0004C23O005D03012O002C000500133O0020050005000500932O00A9000500020002000EE000940049030100050004C23O004903012O002C000500034O00060006000A3O00122O000700953O00122O000800966O0006000800024O00050005000600202O0005000500244O00050002000200062O0005005F03013O0004C23O005F03012O002C000500133O0020150005000500934O0005000200024O000600143O00202O00060006007200062O0006005D030100050004C23O005D03012O002C000500143O000E1C0097005F030100050004C23O005F03012O002C000500034O008C0006000A3O00122O000700983O00122O000800996O0006000800024O00050005000600202O0005000500154O00050002000200262O0005005F030100020004C23O005F0301002ECD009B00700301009A0004C23O007003012O002C000500164O00DA000600183O00202O00060006009C4O000700023O00202O00070007008E4O000900033O00202O00090009009D4O0007000900024O000700076O00050007000200062O0005007003013O0004C23O007003012O002C0005000A3O0012990006009E3O0012990007009F4O00E5000500074O001C01055O001299000400023O000ED100020075030100040004C23O00750301002EB800A00087FF2O00A10004C23O00FA0201001299000300023O0004C23O007803010004C23O00FA02010026A40003007C030100120004C23O007C0301001299000100023O0004C23O00040001002ECD00A300F5020100A20004C23O00F50201000EA2000200F5020100030004C23O00F50201001299000400013O0026A4000400F2030100010004C23O00F203012O002C000500034O00060006000A3O00122O000700A43O00122O000800A56O0006000800024O00050005000600202O0005000500534O00050002000200062O0005009303013O0004C23O009303012O002C000500213O00068E0005009303013O0004C23O009303012O002C000500143O00268000050095030100120004C23O00950301002ECD00A700A6030100A60004C23O00A603012O002C000500164O00DA000600033O00202O00060006008A4O000700023O00202O00070007008E4O000900033O00202O00090009008A4O0007000900024O000700076O00050007000200062O000500A603013O0004C23O00A603012O002C0005000A3O001299000600A83O001299000700A94O00E5000500074O001C01055O002ECD00AB00F1030100AA0004C23O00F103012O002C000500034O00060006000A3O00122O000700AC3O00122O000800AD6O0006000800024O00050005000600202O0005000500434O00050002000200062O000500F103013O0004C23O00F103012O002C000500223O00068E000500F103013O0004C23O00F103012O002C000500233O0006B5000500F1030100010004C23O00F103012O002C000500133O00207C0005000500454O000700033O00202O0007000700464O00050007000200062O000500F103013O0004C23O00F103012O002C000500023O00207C0005000500444O000700033O00202O0007000700064O00050007000200062O000500F103013O0004C23O00F103012O002C000500133O0020050005000500932O00A9000500020002002635000500D5030100970004C23O00D503012O002C000500034O00D00006000A3O00122O000700AE3O00122O000800AF6O0006000800024O00050005000600202O0005000500154O000500020002002680000500DF0301007B0004C23O00DF03012O002C000500034O008C0006000A3O00122O000700B03O00122O000800B16O0006000800024O00050005000600202O0005000500154O00050002000200262O000500F1030100B20004C23O00F103012O002C000500133O0020150005000500934O0005000200024O000600143O00202O00060006007200062O000500F1030100060004C23O00F103012O002C000500164O002C000600033O00206C0006000600922O00A900050002000200068E000500F103013O0004C23O00F103012O002C0005000A3O001299000600B33O001299000700B44O00E5000500074O001C01055O001299000400023O0026A400040081030100020004C23O00810301001299000300123O0004C23O00F502010004C23O008103010004C23O00F502010004C23O000400010004C23O000C04010026A43O0002000100010004C23O00020001001299000300013O000ED100020001040100030004C23O00010401002E1200B50003040100B60004C23O000304010012993O00023O0004C23O00020001002ECD00B700FD030100B80004C23O00FD03010026A4000300FD030100010004C23O00FD0301001299000100014O00F1000200023O001299000300023O0004C23O00FD03010004C23O000200012O00093O00017O00F93O00028O00025O00A08540025O00A4A040026O001440025O00807A40025O0088A940026O000840026O001840025O00AC9140025O009EAC40030C3O004570696353652O74696E677303083O00F5FCED422D7EC1EA03063O0010A62O993644030E3O00C7A0C56B3532EAF0B2D2543D24EB03073O0099B2D3A026544103083O00B10E4E3F8B055D3803043O004BE26B3A030E3O004DCD145718D0DF57CC387710C5C803073O00AD38BE711A71A2026O00F03F025O000AB340025O0010834003083O00F8DB3911FEC5D93E03053O0097ABBE4D65030B3O00C423ECACEA4902C82AD09903073O006BA54F98C9981D03083O00644BFCDF5D71505D03063O001F372E88AB3403123O00C13AD5E7DC29C8FDD20ADDE6C321D9E6F91803043O0094B148BC027O0040025O001CAC40025O0062A94003083O0095B343C7AFB850C003043O00B3C6D63703153O00F71E2O7751D6E2257C604CC0F90E7B7A4CC7E9244203063O00B3906C12162503083O00F5A60F9DC6C8A40803053O00AFA6C37BE9030A3O00E6C1586BFCE0C15661C003053O00908FA23D29025O00E5B140025O0028A640025O00188E40025O00C0714003083O00101DCA3E212D4A3003073O002D4378BE4A4843030E3O003531E884EB8BEFE72500E1A4EA9C03083O008940428DC599E88E03083O0030D536B2810DD73103053O00E863B042C603103O00F9322D27698EF822E9032914698CFE2903083O004C8C4148661BED99025O0032B140025O00B8AB4003083O0079DF02C6DE0FB95903073O00DE2ABA76B2B76103123O0048FF41AB4FEF458458C95C9A51E3578352E203043O00EA3D8C2403083O0012D8AE66062FDAA903053O006F41BDDA1203113O0056581E14195FAE4D4E3D340655A32O4A0903073O00CF232B7B556B3C025O00088940025O0086AC4003083O0043AFB4FE707EADB303053O001910CAC08A03123O00E8D8A8C3BBF7FCC5A8CBA7E0F8C7A1E7AAE003063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B103113O00980B1F6C9F2O1B438835135E9E1116489E03043O002DED787A025O0078AD40025O00F08D40025O00A4AB40025O009CAC40025O0052AE40025O00508140025O00A0694003083O00862BA0698DBB29A703053O00E4D54ED41D03103O00925FB336E38E4AA20CE5807CB912EE9503053O008BE72CD66503083O002OEA124A19BF360503083O0076B98F663E70D151030C3O0049632CC7B7161D36595F3BE403083O00583C104986C5757C025O0002A540025O00AAA04003083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C6030F3O009E3DB0033417E19F2BA7332B07E38703073O008FEB4ED5405B6203083O00BE4D90FD79B88A5B03063O00D6ED28E48910030C3O0090F0EAFB0FA796F72OD815A303063O00C6E5838FB963025O001AA540025O0056AF40025O00907D40025O00E6A64003083O006289BC675882AF6003043O001331ECC803103O00EB24F393F6BBF938F8A4C6A8FB36E2BF03063O00DA9E5796D78403083O00C81BCDF63F2CCAE803073O00AD9B7EB9825642030E3O00F0B5BFE69AEFE4A8BFF49DFEE2A303063O008C85C6DAA7E8025O00E49440025O0078A440025O00DC9840025O00C3B140025O00804B40025O0028A340025O0090874003083O00D6E8520EF2EBEA5503053O009B858D267A03113O002438AF40417A963038AB447876B12D098803073O00C5454ACC212F1F03083O00C34A4E93F9415D9403043O00E7902F3A03133O00A1D0D3730C34C13E82D7CD702O0AC62DBAFBFE03083O0059D2B8BA15785DAF025O00249B40025O004EB24003083O00825668C17034B64003063O005AD1331CB51903133O00D16954EFB1D55445EC88D96F5FC3B6DE7274CA03053O00DFB01B378E03083O0017BEDAA12DB5C9A603043O00D544DBAE03163O0019E127EE2BCB2B4C1BE131EC1DCC2B7726E92DEE09E103083O001F6B8043874AA55F026O004E40025O00ECA84003083O0063EFECDC485EEDEB03053O0021308A98A8030F3O0067053563C0337B173E45F22773043B03063O005712765031A103083O007F1BCEB4B94219C903053O00D02C7EBAC003113O00E209A1F21BE9CA46D81C90CE11D1C849FE03083O002E977AC4A6749CA9026O001040025O0068AB40025O00F08240025O0030A440025O0074B34003083O002AED56A43317EF5103053O005A798822D003113O00D21D502ED50B461BC90D5031C1235C10C303043O007EA76E3503083O000E153AECD5313A2O03063O005F5D704E98BC03093O00C2F48B16E1B2E2EED803073O00B2A195E57584DE03083O00E4EDB638DEE6A53F03043O004CB788C203113O006FF5E01B5F411E6FF4E0155141155DE3E803073O00741A868558302F03083O002DC4B4F0B47C19D203063O00127EA1C084DD030C3O004A3BAB2140502BAF105F502603053O00363F48CE64025O00EC9040025O00B8B040025O00C08E40025O00F09740025O00049D40025O00AAA44003083O00FB5C516EEC75CF4A03063O001BA839251A85030A3O0038B97985D623AB5BADDA03053O00B74DCA1CC803083O0024369D1C1E3D8E1B03043O00687753E903103O00E0EB220C46E1F0223077F0F5372750E103053O002395984742025O001AB240025O0018804003083O00CB0DD149CBF60FD603053O00A29868A53D030D3O00C02EA16E52E4DF3DBB7862CDFD03063O0085AD4FD21D1003083O00BE79F93F8472EA3803043O004BED1C8D03133O00C94CC9823F1EEBEDEF4BC9B0232FE6F3DB5AD803083O0081BC3FACD14F7B87025O001C9140025O00FCA740026O001C4003083O00D3D609447B8934F303073O005380B37D3012E703093O0054B4F6FE4812599FC303063O007E3DD793BD2703083O004BFA095171F11A5603043O0025189F7D030D3O00D7AF6750D5B45C4FDBA1706AEA03043O0022BAC615025O00ACAF40025O00A89E4003083O0073E1F2D949EAE1DE03043O00AD20848603153O005B080DDBA73CC8792O1AFF9938D9462F09E3AB3FD903073O00AD2E7B688FCE5103083O008718369E4C8D06A703073O0061D47D42EA25E303153O0087EAA4271198CABB34198FC1B3331198E68620128603053O007EEA83D655025O00B88240025O00D0954003083O00B7D05D4E468AD25A03053O002FE4B5293A031B3O00B3EFDC09063D10B0F9FA2E11231A91F5CD33223619AAF5DA2F063403073O007FC69CB95B6350025O00C6A340025O0054AF40025O00DAB240025O00DCAA40025O0046AE40025O000C984003083O003F38AD3048023AAA03053O00216C5DD944030B3O00CE58A484D84E83A1D448AA03043O00CDBB2BC103083O00CD7711CBF77C02CC03043O00BF9E1265030A3O002OD0829EACC0E088BBAB03053O00CFA5A3E7D703083O00C92B20504E37B02703083O00549A4E54242759D703133O00E8F2536817F4F25B5911F4E2745917EFE8534A03053O00659D81363803083O002EAC9EBF2A771ABA03063O00197DC9EACB4303163O006CE71D240622126DF10A2A1A311A6AFD1A0A182E076003073O0073199478637447025O0030AC40025O002FB34003083O00EBEDE85948BFDFFB03063O00D1B8889C2D2103183O0013C7600BB028CE4100BD2AC972018F0EDC7D25B109C1562C03053O00D867A8156803083O004BA857B071A344B703043O00C418CD23030C3O003B98E627229FE6141A82EE2O03043O00664EEB83004E032O0012993O00014O00F1000100013O0026573O0006000100010004C23O00060001002E1200030002000100020004C23O00020001001299000100013O0026570001000B000100040004C23O000B0001002ECD00060082000100050004C23O00820001001299000200014O00F1000300033O0026A40002000D000100010004C23O000D0001001299000300013O0026A400030014000100070004C23O00140001001299000100083O0004C23O00820001002ECD000900310001000A0004C23O003100010026A400030031000100010004C23O003100010012600004000B4O00FE000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O000500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O00045O00122O0004000B6O000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000400023O00122O000300143O00265700030035000100140004C23O00350001002ECD00150054000100160004C23O005400010012600004000B4O00D4000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500062O00040043000100010004C23O00430001001299000400014O007B000400033O0012300104000B6O000500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500062O00040052000100010004C23O00520001001299000400014O007B000400043O0012990003001F3O002ECD00210010000100200004C23O00100001000EA2001F0010000100030004C23O00100001001299000400013O0026A40004005D000100140004C23O005D0001001299000300073O0004C23O001000010026A400040059000100010004C23O005900010012600005000B4O00D4000600013O00122O000700223O00122O000800236O0006000800024O0005000500064O000600013O00122O000700243O00122O000800256O0006000800024O00050005000600062O0005006D000100010004C23O006D0001001299000500014O007B000500053O0012300105000B6O000600013O00122O000700263O00122O000800276O0006000800024O0005000500064O000600013O00122O000700283O00122O000800296O0006000800024O00050005000600062O0005007C000100010004C23O007C0001001299000500014O007B000500063O001299000400143O0004C23O005900010004C23O001000010004C23O008200010004C23O000D00010026A4000100FD000100010004C23O00FD0001001299000200013O0026A400020089000100070004C23O00890001001299000100143O0004C23O00FD00010026570002008D000100010004C23O008D0001002ECD002A00B00001002B0004C23O00B00001001299000300013O00265700030092000100140004C23O00920001002EB8002C00040001002D0004C23O00940001001299000200143O0004C23O00B00001000EA20001008E000100030004C23O008E00010012600004000B4O00FE000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000400073O00122O0004000B6O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000400083O00122O000300143O0004C23O008E00010026A4000200D5000100140004C23O00D50001001299000300013O000EA2001400B7000100030004C23O00B700010012990002001F3O0004C23O00D50001002657000300BB000100010004C23O00BB0001002EB8003600FAFF2O00370004C23O00B300010012600004000B4O00FE000500013O00122O000600383O00122O000700396O0005000700024O0004000400054O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000400093O00122O0004000B6O000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O0004000A3O00122O000300143O0004C23O00B30001002657000200D90001001F0004C23O00D90001002EB8004000AEFF2O00410004C23O00850001001299000300013O000EA2000100F5000100030004C23O00F500010012600004000B4O00FE000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O0004000B3O00122O0004000B6O000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O0004000C3O00122O000300143O002ECD004B00DA0001004A0004C23O00DA00010026A4000300DA000100140004C23O00DA0001001299000200073O0004C23O008500010004C23O00DA00010004C23O008500010026A4000100822O01001F0004C23O00822O01001299000200014O00F1000300033O002E12004C003O01004D0004C23O003O010026A40002003O0100010004C23O003O01001299000300013O0026570003000A2O01001F0004C23O000A2O01002ECD004E002D2O01004F0004C23O002D2O01001299000400013O002EB80050001D000100500004C23O00282O010026A4000400282O0100010004C23O00282O010012600005000B4O00FE000600013O00122O000700513O00122O000800526O0006000800024O0005000500064O000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O0005000D3O00122O0005000B6O000600013O00122O000700553O00122O000800566O0006000800024O0005000500064O000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O0005000E3O00122O000400143O000EA20014000B2O0100040004C23O000B2O01001299000300073O0004C23O002D2O010004C23O000B2O01000EA2000100542O0100030004C23O00542O01001299000400013O002E12005A004D2O0100590004C23O004D2O010026A40004004D2O0100010004C23O004D2O010012600005000B4O00FE000600013O00122O0007005B3O00122O0008005C6O0006000800024O0005000500064O000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O0005000F3O00122O0005000B6O000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000500103O00122O000400143O002E12006300302O0100640004C23O00302O010026A4000400302O0100140004C23O00302O01001299000300143O0004C23O00542O010004C23O00302O010026A4000300792O0100140004C23O00792O01001299000400013O002ECD006500742O0100660004C23O00742O010026A4000400742O0100010004C23O00742O010012600005000B4O00FE000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O000600013O00122O000700693O00122O0008006A6O0006000800024O0005000500064O000500113O00122O0005000B6O000600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000600013O00122O0007006D3O00122O0008006E6O0006000800024O0005000500064O000500123O00122O000400143O000EA2001400572O0100040004C23O00572O010012990003001F3O0004C23O00792O010004C23O00572O010026570003007D2O0100070004C23O007D2O01002ECD007000062O01006F0004C23O00062O01001299000100073O0004C23O00822O010004C23O00062O010004C23O00822O010004C23O003O01000ED1000700862O0100010004C23O00862O01002EB800710069000100720004C23O00ED2O01001299000200013O002EB800730029000100730004C23O00B02O01000EA2001400B02O0100020004C23O00B02O01001299000300013O002657000300902O0100010004C23O00902O01002ECD007400A92O0100750004C23O00A92O010012600004000B4O00FE000500013O00122O000600763O00122O000700776O0005000700024O0004000400054O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000400133O00122O0004000B6O000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000500013O00122O0006007C3O00122O0007007D6O0005000700024O0004000400054O000400143O00122O000300143O002657000300AD2O0100140004C23O00AD2O01002ECD007F008C2O01007E0004C23O008C2O010012990002001F3O0004C23O00B02O010004C23O008C2O010026A4000200CB2O01001F0004C23O00CB2O010012600003000B4O00FE000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000400013O00122O000500823O00122O000600836O0004000600024O0003000300044O000300153O00122O0003000B6O000400013O00122O000500843O00122O000600856O0004000600024O0003000300044O000400013O00122O000500863O00122O000600876O0004000600024O0003000300044O000300163O00122O000200073O002657000200CF2O0100010004C23O00CF2O01002ECD008900E82O0100880004C23O00E82O010012600003000B4O00FE000400013O00122O0005008A3O00122O0006008B6O0004000600024O0003000300044O000400013O00122O0005008C3O00122O0006008D6O0004000600024O0003000300044O000300173O00122O0003000B6O000400013O00122O0005008E3O00122O0006008F6O0004000600024O0003000300044O000400013O00122O000500903O00122O000600916O0004000600024O0003000300044O000300183O00122O000200143O0026A4000200872O0100070004C23O00872O01001299000100923O0004C23O00ED2O010004C23O00872O01002ECD00940060020100930004C23O006002010026A400010060020100140004C23O00600201001299000200013O0026A4000200170201001F0004C23O00170201001299000300013O002E1200950012020100960004C23O001202010026A400030012020100010004C23O001202010012600004000B4O00FE000500013O00122O000600973O00122O000700986O0005000700024O0004000400054O000500013O00122O000600993O00122O0007009A6O0005000700024O0004000400054O000400193O00122O0004000B6O000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O000500013O00122O0006009D3O00122O0007009E6O0005000700024O0004000400054O0004001A3O00122O000300143O0026A4000300F52O0100140004C23O00F52O01001299000200073O0004C23O001702010004C23O00F52O010026A40002001B020100070004C23O001B02010012990001001F3O0004C23O00600201000EA200010036020100020004C23O003602010012600003000B4O00FE000400013O00122O0005009F3O00122O000600A06O0004000600024O0003000300044O000400013O00122O000500A13O00122O000600A26O0004000600024O0003000300044O0003001B3O00122O0003000B6O000400013O00122O000500A33O00122O000600A46O0004000600024O0003000300044O000400013O00122O000500A53O00122O000600A66O0004000600024O0003000300044O0003001C3O00122O000200143O0026570002003A020100140004C23O003A0201002E1200A800F22O0100A70004C23O00F22O01001299000300013O002ECD00A90041020100AA0004C23O004102010026A400030041020100140004C23O004102010012990002001F3O0004C23O00F22O0100265700030045020100010004C23O00450201002E1200AC003B020100AB0004C23O003B02010012600004000B4O00FE000500013O00122O000600AD3O00122O000700AE6O0005000700024O0004000400054O000500013O00122O000600AF3O00122O000700B06O0005000700024O0004000400054O0004001D3O00122O0004000B6O000500013O00122O000600B13O00122O000700B26O0005000700024O0004000400054O000500013O00122O000600B33O00122O000700B46O0005000700024O0004000400054O0004001E3O00122O000300143O0004C23O003B02010004C23O00F22O010026A4000100C8020100080004C23O00C80201001299000200013O00265700020067020100140004C23O00670201002ECD00B50083020100B60004C23O008302010012600003000B4O00D4000400013O00122O000500B73O00122O000600B86O0004000600024O0003000300044O000400013O00122O000500B93O00122O000600BA6O0004000600024O00030003000400062O00030075020100010004C23O00750201001299000300014O007B0003001F3O0012260003000B6O000400013O00122O000500BB3O00122O000600BC6O0004000600024O0003000300044O000400013O00122O000500BD3O00122O000600BE6O0004000600022O004A0003000300042O007B000300203O0012990002001F3O002ECD00BF0089020100C00004C23O008902010026A400020089020100070004C23O00890201001299000100C13O0004C23O00C80201000EA2000100AA020100020004C23O00AA02010012600003000B4O00D4000400013O00122O000500C23O00122O000600C36O0004000600024O0003000300044O000400013O00122O000500C43O00122O000600C56O0004000600024O00030003000400062O00030099020100010004C23O00990201001299000300014O007B000300213O0012300103000B6O000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000400013O00122O000500C83O00122O000600C96O0004000600024O00030003000400062O000300A8020100010004C23O00A80201001299000300014O007B000300223O001299000200143O002657000200AE0201001F0004C23O00AE0201002EB800CA00B7FF2O00CB0004C23O006302010012600003000B4O00FE000400013O00122O000500CC3O00122O000600CD6O0004000600024O0003000300044O000400013O00122O000500CE3O00122O000600CF6O0004000600024O0003000300044O000300233O00122O0003000B6O000400013O00122O000500D03O00122O000600D16O0004000600024O0003000300044O000400013O00122O000500D23O00122O000600D36O0004000600024O0003000300044O000300243O00122O000200073O0004C23O00630201002ECD00D400D9020100D50004C23O00D90201000EA200C100D9020100010004C23O00D902010012600002000B4O0085000300013O00122O000400D63O00122O000500D76O0003000500024O0002000200034O000300013O00122O000400D83O00122O000500D96O0003000500024O0002000200034O000200253O00044O004D0301002E1200DA0007000100DB0004C23O000700010026A400010007000100920004C23O00070001001299000200013O002657000200E2020100070004C23O00E20201002E1200DC00E4020100DD0004C23O00E40201001299000100043O0004C23O000700010026A4000200090301001F0004C23O00090301001299000300013O0026A4000300EB020100140004C23O00EB0201001299000200073O0004C23O00090301002ECD00DF00E7020100DE0004C23O00E702010026A4000300E7020100010004C23O00E702010012600004000B4O00FE000500013O00122O000600E03O00122O000700E16O0005000700024O0004000400054O000500013O00122O000600E23O00122O000700E36O0005000700024O0004000400054O000400263O00122O0004000B6O000500013O00122O000600E43O00122O000700E56O0005000700024O0004000400054O000500013O00122O000600E63O00122O000700E76O0005000700024O0004000400054O000400273O00122O000300143O0004C23O00E702010026A400020024030100140004C23O002403010012600003000B4O00FE000400013O00122O000500E83O00122O000600E96O0004000600024O0003000300044O000400013O00122O000500EA3O00122O000600EB6O0004000600024O0003000300044O000300283O00122O0003000B6O000400013O00122O000500EC3O00122O000600ED6O0004000600024O0003000300044O000400013O00122O000500EE3O00122O000600EF6O0004000600024O0003000300044O000300293O00122O0002001F3O000ED100010028030100020004C23O00280301002ECD00F100DE020100F00004C23O00DE0201001299000300013O0026A40003002D030100140004C23O002D0301001299000200143O0004C23O00DE02010026A400030029030100010004C23O002903010012600004000B4O00FE000500013O00122O000600F23O00122O000700F36O0005000700024O0004000400054O000500013O00122O000600F43O00122O000700F56O0005000700024O0004000400054O0004002A3O00122O0004000B6O000500013O00122O000600F63O00122O000700F76O0005000700024O0004000400054O000500013O00122O000600F83O00122O000700F96O0005000700024O0004000400054O0004002B3O00122O000300143O0004C23O002903010004C23O00DE02010004C23O000700010004C23O004D03010004C23O000200012O00093O00017O00703O00028O00026O00F03F025O0020AB40025O00C05540025O002C9F40025O00B89840025O001CA840025O00805440026O001040030C3O004570696353652O74696E677303083O0037AEA6285107DA1703073O00BD64CBD25C386903113O000750F32C2354D4262C5EEF382043F8292303043O00484F319D027O0040025O0009B240025O008C9240025O005CB140025O00608C40025O00BC944003083O0077F2F6DA0BE343E403063O008D249782AE62030E3O009068CB038F7FD61EB373D605A75E03043O006DE41AA203083O006DE0E96CE9E859F603063O00863E859D1880030D3O0015A419D02EBDC530AC0ED10C9503073O00B667C57AB94FD1025O002CA340025O00F0944003083O00C082F5630946F49403063O002893E7811760030E3O0060EB896DBEADD061F09F51B4A2D903073O00BC1598EC25DBCC03083O0073EC231849E7301F03043O006C20895703103O00BFFB058E2AF84750A4EF30A93BF0445703083O0039CA8860C64F992B026O000840025O003EB240025O00E49F40025O00FC9840025O007AB340025O00DCAB40025O00E3B04003083O0038DFCC3C4DA2711803073O00166BBAB84824CC03113O00CFB8254207E9BA14411AEEB22A600FEAB803053O006E87DD442E034O0003083O00D03318FFC7BD3CF003073O005B83566C8BAED3030F3O00F32AB61351FE0ABE1151F228AC125903053O003D9B4BD877025O00808C40025O00B2A040025O0095B240025O0057B040025O0042A840025O00ECA54003083O009826BEB384A9FFB803073O0098CB43CAC7EDC7030D3O00F246A1030B7D6AF2F54DA5272F03083O00869A23C06F7F151903083O008B231D1E29DCBF3503063O00B2D846696A40030F3O00372E7BFAC0DBD3B0303F73F9C7FDE403083O00E05F4B1A96A9B5B4025O0008B340025O00F8A040025O00EAA140025O002EAB40025O00609440025O0016A54003083O0083440FC3C0FFE8EC03083O009FD0217BB7A9918F030D3O00D6532B26F7561C33F04F3E30E103043O0056923A5803083O006BDAFED4A7E731E903083O009A38BF8AA0CE8956030B3O00A250E6977936A3D9805FE603083O00ACE63995E71C5AE103083O0031AF92C621D505B903063O00BB62CAE6B248030B3O0034F2A1045828EFAF355E3203053O002A4181C45003083O00314F49CE1E0905FD03083O008E622A3DBA776762030A3O002DAC073A39BC0B0934AC03043O006858DF62025O00E88740025O0018894003083O00C61FD8E4AE053ECD03083O00BE957AAC90C76B5903113O00340C2OF6EA2O00FCFFF73C16D2F6FB310E03053O009E5265919E03083O0043FB16024D7EF91103053O0024109E627603113O00E918D7FE4AFA32F5D421CAEF50DB33F0CE03083O0085A076A39B388847025O00D88840025O00589C4003083O00C5A765E6BF11B2E503073O00D596C21192D67F03163O0032A7B0D154B6B7260F86AAD85F93AA3F0FACA8DD55B003083O00567BC9C4B426C4C203083O00C4EDCDBBFEE6DEBC03043O00CF9788B903123O00818D3C87666A64B8971C8A667D62A08C248603073O0011C8E348E21418025O00C2AB40025O004C9340007F012O0012993O00014O00F1000100023O0026573O0006000100020004C23O00060001002E12000300762O0100040004C23O00762O010026570001000A000100010004C23O000A0001002ECD00050006000100060004C23O00060001001299000200013O002ECD0008001C000100070004C23O001C00010026A40002001C000100090004C23O001C00010012600003000A4O0085000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O00035O00044O007E2O01002657000200200001000F0004C23O00200001002E1200100070000100110004C23O00700001001299000300014O00F1000400043O0026A400030022000100010004C23O00220001001299000400013O002EB800120027000100120004C23O004C00010026A40004004C000100010004C23O004C0001001299000500013O0026A40005002E000100020004C23O002E0001001299000400023O0004C23O004C000100265700050032000100010004C23O00320001002ECD0014002A000100130004C23O002A00010012600006000A4O00FE000700013O00122O000800153O00122O000900166O0007000900024O0006000600074O000700013O00122O000800173O00122O000900186O0007000900024O0006000600074O000600023O00122O0006000A6O000700013O00122O000800193O00122O0009001A6O0007000900024O0006000600074O000700013O00122O0008001B3O00122O0009001C6O0007000900024O0006000600074O000600033O00122O000500023O0004C23O002A0001002E12001E00690001001D0004C23O006900010026A400040069000100020004C23O006900010012600005000A4O00FE000600013O00122O0007001F3O00122O000800206O0006000800024O0005000500064O000600013O00122O000700213O00122O000800226O0006000800024O0005000500064O000500043O00122O0005000A6O000600013O00122O000700233O00122O000800246O0006000800024O0005000500064O000600013O00122O000700253O00122O000800266O0006000800024O0005000500064O000500053O00122O0004000F3O0026A4000400250001000F0004C23O00250001001299000200273O0004C23O007000010004C23O002500010004C23O007000010004C23O0022000100265700020074000100270004C23O00740001002E12002800D3000100290004C23O00D30001001299000300013O002E12002A007B0001002B0004C23O007B00010026A40003007B0001000F0004C23O007B0001001299000200093O0004C23O00D30001002E12002C00A30001002D0004C23O00A300010026A4000300A3000100020004C23O00A30001001299000400013O0026A40004009E000100010004C23O009E00010012600005000A4O00D4000600013O00122O0007002E3O00122O0008002F6O0006000800024O0005000500064O000600013O00122O000700303O00122O000800316O0006000800024O00050005000600062O00050090000100010004C23O00900001001299000500324O007B000500063O0012260005000A6O000600013O00122O000700333O00122O000800346O0006000800024O0005000500064O000600013O00122O000700353O00122O000800366O0006000800022O004A0005000500062O007B000500073O001299000400023O000EA200020080000100040004C23O008000010012990003000F3O0004C23O00A300010004C23O00800001002E1200370075000100380004C23O007500010026A400030075000100010004C23O00750001001299000400013O002657000400AC000100020004C23O00AC0001002ECD003900AE0001003A0004C23O00AE0001001299000300023O0004C23O00750001002657000400B2000100010004C23O00B20001002ECD003B00A80001003C0004C23O00A800010012600005000A4O00D4000600013O00122O0007003D3O00122O0008003E6O0006000800024O0005000500064O000600013O00122O0007003F3O00122O000800406O0006000800024O00050005000600062O000500C0000100010004C23O00C00001001299000500014O007B000500083O0012300105000A6O000600013O00122O000700413O00122O000800426O0006000800024O0005000500064O000600013O00122O000700433O00122O000800446O0006000800024O00050005000600062O000500CF000100010004C23O00CF0001001299000500014O007B000500093O001299000400023O0004C23O00A800010004C23O007500010026A40002001D2O0100020004C23O001D2O01001299000300014O00F1000400043O000ED1000100DB000100030004C23O00DB0001002E12004500D7000100460004C23O00D70001001299000400013O002E12004700E2000100480004C23O00E20001000EA2000F00E2000100040004C23O00E200010012990002000F3O0004C23O001D2O01000ED1000100E6000100040004C23O00E60001002ECD004A00FF000100490004C23O00FF00010012600005000A4O00FE000600013O00122O0007004B3O00122O0008004C6O0006000800024O0005000500064O000600013O00122O0007004D3O00122O0008004E6O0006000800024O0005000500064O0005000A3O00122O0005000A6O000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O000600013O00122O000700513O00122O000800526O0006000800024O0005000500064O0005000B3O00122O000400023O0026A4000400DC000100020004C23O00DC00010012600005000A4O00FE000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O000600013O00122O000700553O00122O000800566O0006000800024O0005000500064O0005000C3O00122O0005000A6O000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O0005000D3O00122O0004000F3O0004C23O00DC00010004C23O001D2O010004C23O00D700010026A40002000B000100010004C23O000B0001001299000300013O002657000300242O01000F0004C23O00242O01002ECD005C00262O01005B0004C23O00262O01001299000200023O0004C23O000B00010026A40003004C2O0100010004C23O004C2O01001299000400013O0026A40004002D2O0100020004C23O002D2O01001299000300023O0004C23O004C2O01000EA2000100292O0100040004C23O00292O010012600005000A4O00D4000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O000600013O00122O0007005F3O00122O000800606O0006000800024O00050005000600062O0005003D2O0100010004C23O003D2O01001299000500014O007B0005000E3O0012AB0005000A6O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O0005000F3O00122O000400023O00044O00292O010026A4000300202O0100020004C23O00202O01001299000400013O002657000400532O0100010004C23O00532O01002E120066006C2O0100650004C23O006C2O010012600005000A4O00FE000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O000600013O00122O000700693O00122O0008006A6O0006000800024O0005000500064O000500103O00122O0005000A6O000600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000600013O00122O0007006D3O00122O0008006E6O0006000800024O0005000500064O000500113O00122O000400023O0026A40004004F2O0100020004C23O004F2O010012990003000F3O0004C23O00202O010004C23O004F2O010004C23O00202O010004C23O000B00010004C23O007E2O010004C23O000600010004C23O007E2O010026573O007A2O0100010004C23O007A2O01002E12006F0002000100700004C23O00020001001299000100014O00F1000200023O0012993O00023O0004C23O000200012O00093O00017O001E012O00028O00025O00DAAB40025O00405140026O001040025O00A8A040025O00A088402O033O00474344025O00EC9B40025O00909240026O00F03F025O00509840025O00AAA840025O00F2AD40025O00F49340030F3O0048616E646C65412O666C6963746564030B3O0052656D6F7665437572736503143O0052656D6F766543757273654D6F7573656F766572026O003E40025O00088740025O00C05840026O007E40025O00E09940025O00849040025O00649440030F3O00412O66656374696E67436F6D626174025O0018A040025O00D6A640025O0035B240025O00407940025O001CAE40025O003CB140026O004540025O009EA040030F3O00A435DA363E8662AD9122D53B35805F03083O00C3E547B95750E32B030A3O0049734361737461626C6503083O0042752O66446F776E030F3O00417263616E65496E74652O6C65637403103O0047726F757042752O664D692O73696E67031B3O00E1EE0351E1E5C3095EFBE5F00C55ECF4BC0742E0F5EC3F52FAE6FA03053O008F809C6030030E3O0099C3F31319BDF7F11F1EB4D8F10003053O0077D8B1907203073O004973526561647903123O00417263616E6546616D696C69617242752O66030E3O00417263616E6546616D696C696172031B3O00C83BFA43C72CC644C824F04EC028EB02D93BFC41C624FB43DD69AB03043O0022A94999025O0091B240025O00C89640030E3O0089E30581BFFE0EA6ABE20AACAFE103043O00EBCA8C6B030E3O00436F6E6A7572654D616E6147656D031C3O000F7B3AA2FC35F2FA01753AA9D620F2C84C6426ADEA28FAC70D6074FC03083O00A56C1454C8894797026O001440030D3O00546172676574497356616C6964027O0040025O00089840025O00C2A340025O00F8A940025O0026B340025O00607E40025O0034934003053O00466F637573025O007AA240025O00208740025O001CA640025O00B09040025O00B4AE40025O00F08E40025O00E08040025O0046B240025O00CAA540025O00888140025O00E0A840025O0062A640025O008C9B40025O00CAA640025O0055B040025O00349240025O007CAC40025O0028A240025O00189440025O001AAE4003113O0048616E646C65496E636F72706F7265616C03093O00506F6C796D6F72706803123O00506F6C796D6F7270684D6F7573654F766572025O0082AD40025O0056AF40026O000840025O00A7B040025O00FAA740030A3O0049A42E8476A73F8D7BB803043O00E81AD44B030B3O004973417661696C61626C65030A3O00045977E4FB245D77E9FB03053O00975729128803093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66025O00FEAA40025O00E88D40025O0021B240030A3O005370652O6C737465616C030E3O0049735370652O6C496E52616E676503113O0048BFCFDCF248BBCFD1F21BABCBDDFF5CAA03053O009E3BCFAAB0025O00088940025O00207A40025O00BEA040025O007AA840025O0008AA40025O00249D40025O00C4B240025O00808340025O00288640025O00C8AF40025O00608440026O008440025O00249940025O000FB340025O0088AD40025O00709D40025O005FB140025O00F6AF40025O00F8A540025O0029B140030F3O0048616E646C65445053506F74696F6E030B3O006E4C3048824A6D265B8B4A03053O00EC2F3E5329025O0086AB40025O00149B40025O00805A4003083O00CEA02D3E9D83E8B903063O00E29AC9405BCA030C3O00F54C100845AEC0452A1958AC03063O00DCA1297D782A03123O00426C2O6F646C757374457868617573745570030B3O009D63A30FB274931BAE76A503043O006EDC11C0030A3O00432O6F6C646F776E5570026O00444003063O0042752O665570030F3O00417263616E65537572676542752O66030B3O00556B371BE532C2B2667E3103083O00C71419547A8B5791030F3O00432O6F6C646F776E52656D61696E73026O001840026O00204003083O0054696D655761727003093O004973496E52616E6765025O007CA340025O00A06C4003103O005300D0AB24FD461BCDEE16EB4E079DFA03063O008A2769BDCE7B03083O005072657647434450030B3O00417263616E655375726765030D3O0055DA2453B79F9775D80457A88703073O00E514B44736C4EB030D3O00416E6365737472616C43612O6C025O00FAAA40026O00374003163O002870C22OE6BE922872FEE0F4A68C6973C0EAFBEAD17D03073O00E0491EA18395CA025O00E8A540025O006DB140025O00405640025O00307A4003093O00D5F125D309DED8E5E403073O00AD979D4ABC6D98025O0031B040025O00B49340025O0008814003093O00426C2O6F644675727903123O00260437D2D86BD3E6361178D0DD5DDBB3755803083O0093446858BDBC34B503093O003C8199D5182O84DF1E03043O00B07AE8EB025O0006AD40026O00284003093O0046697265626C2O6F6403113O00867C284AEC8C7A354BAE8D743341AED12703053O008EE0155A2F025O00FC9F40026O008840025O00909D40025O00189C40025O00C88740025O00ECA640025O00CC9A40025O007BB240030E3O00330E8E25E7EAE5EA1B008428FDED03083O009F7F67E94D9399AF030A3O00446562752O66446F776E03143O00546F7563686F667468654D616769446562752O66025O002EA840025O00AAA240025O0082B240025O00F0A940030E3O004C69676874734A7564676D656E7403163O000BF9E3A254D838FAF1AE47C602FEF0EA4DCA0EFEA4FC03063O00AB679084CA20030A3O00322AFB1F153DE2051E2803043O006C704F8903103O0054656D706F72616C5761727042752O66030B3O00426C2O6F646C757374557003083O00446562752O665570030A3O004265727365726B696E6703113O003DC7663BA813E23C31C53425AC08E7756703083O00555FA21448CD6189025O008EAB40025O001C9C40030C3O004570696353652O74696E677303073O00EBAE75B80FBB4503083O0029BFC112DF63DE3603063O00AF2FD43AAFA703053O00CACB46A74A030D3O004973446561644F7247686F7374025O00B07040025O0060A440025O0032A740025O00AC934003173O00476574456E656D696573496E53706C61736852616E6765025O00C8A440025O00A1B040025O0012A340025O00A4934003073O000DE941A8373CF503053O005B598626CF03073O0049E7C63F10D43403073O0047248EA85673B0025O009CB04003073O00F25248D5CA585C03043O00B2A63D2F2O033O00FA45ED03063O005E9B2A881AAA03073O00B03021B2883A3503043O00D5E45F462O033O0029BFD103053O00174ADBA2E4025O006EA840025O00C2A940025O00F4AB40025O00AAB040025O00889C4003073O00BCBF36BB84B52203043O00DCE8D0512O033O00FAB1E603073O00C195DE85504C3A025O00789B40025O0046A940025O00B08840025O00C09D4003113O00476574456E656D696573496E52616E6765025O00D89E40025O00EEA940025O008AA840025O00F09A402O033O006D6178031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O009AB040025O00F0AB40025O00588D40025O0013B340025O005C9440024O0080B3C540030C3O00466967687452656D61696E73025O004CAE40025O00D1B240025O00E49640025O0022B140025O00108740025O00E08F40030B3O001E04D13C672922C921622903053O00114C61BC5303093O00466F637573556E6974026O003440025O00A89940025O00AC9B40025O00D2A340025O00DCA940025O00AAB140025O006EB040025O00309A4003103O00426F2O73466967687452656D61696E7300C5052O0012993O00014O00F1000100013O0026573O0006000100010004C23O00060001002EB8000200FEFF2O00030004C23O00020001001299000100013O0026570001000B000100040004C23O000B0001002E12000500E6000100060004C23O00E60001001299000200014O00F1000300033O0026A40002000D000100010004C23O000D0001001299000300013O0026A400030047000100010004C23O004700012O002C000400013O0020410004000400074O0004000200024O00048O000400023O00062O0004004600013O0004C23O00460001002ECD00090046000100080004C23O004600012O002C000400033O00068E0004004600013O0004C23O00460001001299000400014O00F1000500063O0026A400040025000100010004C23O00250001001299000500014O00F1000600063O0012990004000A3O002ECD000B00200001000C0004C23O002000010026A4000400200001000A0004C23O00200001002E12000E00290001000D0004C23O002900010026A400050029000100010004C23O00290001001299000600013O0026A40006002E000100010004C23O002E00012O002C000700053O00209000070007000F4O000800063O00202O0008000800104O000900073O00202O00090009001100122O000A00126O0007000A00024O000700043O002E2O00140046000100130004C23O004600012O002C000700043O00068E0007004600013O0004C23O004600012O002C000700044O00E4000700023O0004C23O004600010004C23O002E00010004C23O004600010004C23O002900010004C23O004600010004C23O002000010012990003000A3O0026570003004B0001000A0004C23O004B0001002ECD00160010000100150004C23O00100001002ECD001700E1000100180004C23O00E100012O002C000400013O0020050004000400192O00A90004000200020006B5000400E1000100010004C23O00E10001001299000400014O00F1000500063O002ECD001A005B0001001B0004C23O005B00010026A40004005B000100010004C23O005B0001001299000500014O00F1000600063O0012990004000A3O0026570004005F0001000A0004C23O005F0001002ECD001C00540001001D0004C23O005400010026A40005005F000100010004C23O005F0001001299000600013O0026A4000600BF000100010004C23O00BF0001001299000700013O00265700070069000100010004C23O00690001002ECD001F00BA0001001E0004C23O00BA0001001299000800013O0026570008006E000100010004C23O006E0001002EB800200049000100210004C23O00B500012O002C000900064O0006000A00083O00122O000B00223O00122O000C00236O000A000C00024O00090009000A00202O0009000900244O00090002000200062O0009009500013O0004C23O009500012O002C000900093O00068E0009009500013O0004C23O009500012O002C000900013O0020070009000900254O000B00063O00202O000B000B00264O000C00016O0009000C000200062O0009008A000100010004C23O008A00012O002C000900053O0020030109000900274O000A00063O00202O000A000A00264O00090002000200062O0009009500013O0004C23O009500012O002C0009000A4O002C000A00063O00206C000A000A00262O00A900090002000200068E0009009500013O0004C23O009500012O002C000900083O001299000A00283O001299000B00294O00E50009000B4O001C01096O002C000900064O0006000A00083O00122O000B002A3O00122O000C002B6O000A000C00024O00090009000A00202O00090009002C4O00090002000200062O000900B400013O0004C23O00B400012O002C0009000B3O00068E000900B400013O0004C23O00B400012O002C000900013O00207C0009000900254O000B00063O00202O000B000B002D4O0009000B000200062O000900B400013O0004C23O00B400012O002C0009000A4O002C000A00063O00206C000A000A002E2O00A900090002000200068E000900B400013O0004C23O00B400012O002C000900083O001299000A002F3O001299000B00304O00E50009000B4O001C01095O0012990008000A3O0026A40008006A0001000A0004C23O006A00010012990007000A3O0004C23O00BA00010004C23O006A00010026A4000700650001000A0004C23O006500010012990006000A3O0004C23O00BF00010004C23O006500010026A4000600620001000A0004C23O00620001002ECD003200E1000100310004C23O00E100012O002C000700064O0006000800083O00122O000900333O00122O000A00346O0008000A00024O00070007000800202O0007000700244O00070002000200062O000700E100013O0004C23O00E100012O002C0007000C3O00068E000700E100013O0004C23O00E100012O002C0007000A4O002C000800063O00206C0008000800352O00A900070002000200068E000700E100013O0004C23O00E100012O002C000700083O00128D000800363O00122O000900376O000700096O00075O00044O00E100010004C23O006200010004C23O00E100010004C23O005F00010004C23O00E100010004C23O00540001001299000100383O0004C23O00E600010004C23O001000010004C23O00E600010004C23O000D00010026A400010009040100380004C23O000904012O002C000200053O00206C0002000200392O009800020001000200068E000200C405013O0004C23O00C40501001299000200014O00F1000300033O000EA2000100EF000100020004C23O00EF0001001299000300013O000EA2000A000D2O0100030004C23O000D2O01001299000400013O0026A4000400082O0100010004C23O00082O01001299000500013O0026A4000500FC0001000A0004C23O00FC00010012990004000A3O0004C23O00082O010026A4000500F8000100010004C23O00F800012O002C0006000D4O00980006000100022O007B000600044O002C000600043O00068E000600062O013O0004C23O00062O012O002C000600044O00E4000600023O0012990005000A3O0004C23O00F800010026A4000400F50001000A0004C23O00F500010012990003003A3O0004C23O000D2O010004C23O00F500010026A40003005A2O0100010004C23O005A2O01001299000400013O002657000400142O01000A0004C23O00142O01002EB8003B00040001003C0004C23O00162O010012990003000A3O0004C23O005A2O010026570004001A2O0100010004C23O001A2O01002EB8003D00F8FF2O003E0004C23O00102O01001299000500013O0026A40005001F2O01000A0004C23O001F2O010012990004000A3O0004C23O00102O01002E12003F001B2O0100400004C23O001B2O010026A40005001B2O0100010004C23O001B2O01001260000600413O00068E0006003E2O013O0004C23O003E2O012O002C0006000E3O00068E0006003E2O013O0004C23O003E2O01001299000600014O00F1000700073O0026570006002F2O0100010004C23O002F2O01002E120042002B2O0100430004C23O002B2O01001299000700013O000EA2000100302O0100070004C23O00302O012O002C0008000F4O00980008000100022O007B000800044O002C000800043O00068E0008003E2O013O0004C23O003E2O012O002C000800044O00E4000800023O0004C23O003E2O010004C23O00302O010004C23O003E2O010004C23O002B2O012O002C000600013O0020050006000600192O00A90006000200020006B5000600462O0100010004C23O00462O012O002C000600103O0006B5000600482O0100010004C23O00482O01002ECD004400572O0100450004C23O00572O01001299000600013O0026A4000600492O0100010004C23O00492O012O002C000700114O00980007000100022O007B000700043O002EB800460009000100460004C23O00572O012O002C000700043O00068E000700572O013O0004C23O00572O012O002C000700044O00E4000700023O0004C23O00572O010004C23O00492O010012990005000A3O0004C23O001B2O010004C23O00102O010026570003005E2O01003A0004C23O005E2O01002EB800470060000100480004C23O00BC2O01001299000400013O002E12004A00B52O0100490004C23O00B52O010026A4000400B52O0100010004C23O00B52O01002ECD004B00952O01004C0004C23O00952O012O002C000500023O00068E000500952O013O0004C23O00952O012O002C000500033O00068E000500952O013O0004C23O00952O01001299000500014O00F1000600073O002657000500712O01000A0004C23O00712O01002ECD004D008D2O01004E0004C23O008D2O010026A4000600712O0100010004C23O00712O01001299000700013O002ECD004F00742O0100500004C23O00742O01000EA2000100742O0100070004C23O00742O012O002C000800053O00207600080008000F4O000900063O00202O0009000900104O000A00073O00202O000A000A001100122O000B00126O0008000B00024O000800046O000800043O00062O000800862O0100010004C23O00862O01002ECD005200952O0100510004C23O00952O012O002C000800044O00E4000800023O0004C23O00952O010004C23O00742O010004C23O00952O010004C23O00712O010004C23O00952O01002EB8005300E0FF2O00530004C23O006D2O010026A40005006D2O0100010004C23O006D2O01001299000600014O00F1000700073O0012990005000A3O0004C23O006D2O012O002C000500123O00068E000500B42O013O0004C23O00B42O01001299000500014O00F1000600063O0026570005009E2O0100010004C23O009E2O01002E120055009A2O0100540004C23O009A2O01001299000600013O0026A40006009F2O0100010004C23O009F2O012O002C000700053O00202O0007000700564O000800063O00202O0008000800574O000900073O00202O00090009005800122O000A00126O000B00016O0007000B00024O000700046O000700043O00068E000700B42O013O0004C23O00B42O012O002C000700044O00E4000700023O0004C23O00B42O010004C23O009F2O010004C23O00B42O010004C23O009A2O010012990004000A3O002E120059005F2O01005A0004C23O005F2O01000EA2000A005F2O0100040004C23O005F2O010012990003005B3O0004C23O00BC2O010004C23O005F2O01002657000300C02O01005B0004C23O00C02O01002E12005C00F20001005D0004C23O00F200012O002C000400064O0006000500083O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500202O0004000400604O00040002000200062O000400ED2O013O0004C23O00ED2O012O002C000400133O00068E000400ED2O013O0004C23O00ED2O012O002C000400064O0006000500083O00122O000600613O00122O000700626O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400ED2O013O0004C23O00ED2O012O002C000400143O00068E000400ED2O013O0004C23O00ED2O012O002C000400153O00068E000400ED2O013O0004C23O00ED2O012O002C000400013O0020050004000400632O00A90004000200020006B5000400ED2O0100010004C23O00ED2O012O002C000400013O0020050004000400642O00A90004000200020006B5000400ED2O0100010004C23O00ED2O012O002C000400053O00206C0004000400652O002C000500164O00A90004000200020006B5000400EF2O0100010004C23O00EF2O01002E120066002O020100670004C23O002O0201002EB800680013000100680004C23O002O02012O002C0004000A4O00DA000500063O00202O0005000500694O000600163O00202O00060006006A4O000800063O00202O0008000800694O0006000800024O000600066O00040006000200062O0004002O02013O0004C23O002O02012O002C000400083O0012990005006B3O0012990006006C4O00E5000400064O001C01046O002C000400013O0020050004000400632O00A90004000200020006B5000400C4050100010004C23O00C405012O002C000400013O0020050004000400642O00A90004000200020006B5000400C4050100010004C23O00C405012O002C000400013O0020050004000400192O00A900040002000200068E000400C405013O0004C23O00C405012O002C000400053O00206C0004000400392O009800040001000200068E000400C405013O0004C23O00C40501001299000400014O00F1000500053O000ED1003A001C020100040004C23O001C0201002ECD006D00550201006E0004C23O005502012O002C000600174O002C000700183O0006D900070021020100060004C23O002102010004C23O005102012O002C000600193O00068E0006005102013O0004C23O005102012O002C0006001A3O00068E0006002A02013O0004C23O002A02012O002C0006001B3O0006B50006002D020100010004C23O002D02012O002C0006001B3O0006B500060051020100010004C23O00510201001299000600014O00F1000700083O002E12006F0036020100700004C23O003602010026A400060036020100010004C23O00360201001299000700014O00F1000800083O0012990006000A3O002E120072002F020100710004C23O002F0201000EA2000A002F020100060004C23O002F0201002ECD0074003A020100730004C23O003A02010026A40007003A020100010004C23O003A0201001299000800013O00265700080043020100010004C23O00430201002ECD0076003F020100750004C23O003F02012O002C0009001C4O00980009000100022O007B000900044O002C000900043O00068E0009005102013O0004C23O005102012O002C000900044O00E4000900023O0004C23O005102010004C23O003F02010004C23O005102010004C23O003A02010004C23O005102010004C23O002F02012O002C0006001D4O00980006000100022O007B000600043O0012990004005B3O0026A40004005F020100040004C23O005F02012O002C000600043O0006B50006005C020100010004C23O005C0201002E12007700C4050100780004C23O00C405012O002C000600044O00E4000600023O0004C23O00C405010026A4000400780201005B0004C23O00780201001299000600013O00265700060066020100010004C23O00660201002EB80079000D0001007A0004C23O007102012O002C000700043O0006B50007006B020100010004C23O006B0201002E12007B006D0201007C0004C23O006D02012O002C000700044O00E4000700024O002C0007001E4O00980007000100022O007B000700043O0012990006000A3O002ECD007E00620201007D0004C23O006202010026A4000600620201000A0004C23O00620201001299000400043O0004C23O007802010004C23O00620201002ECD007F008F020100800004C23O008F02010026A40004008F020100010004C23O008F02012O002C000600053O0020880006000600814O000700066O000800083O00122O000900823O00122O000A00836O0008000A00024O00070007000800202O00070007002C4O0007000200024O000700076O0006000200024O000500063O00062O0005008D020100010004C23O008D0201002E120084008E020100510004C23O008E02012O00E4000500023O0012990004000A3O0026A4000400180201000A0004C23O00180201001299000600013O002E1200860098020100850004C23O009802010026A4000600980201000A0004C23O009802010012990004003A3O0004C23O001802010026A400060092020100010004C23O009202012O002C0007001F3O00068E000700E902013O0004C23O00E902012O002C000700064O0006000800083O00122O000900873O00122O000A00886O0008000A00024O00070007000800202O00070007002C4O00070002000200062O000700E902013O0004C23O00E902012O002C000700064O0006000800083O00122O000900893O00122O000A008A6O0008000A00024O00070007000800202O0007000700604O00070002000200062O000700E902013O0004C23O00E902012O002C000700013O00200500070007008B2O00A900070002000200068E000700E902013O0004C23O00E902012O002C000700064O00A7000800083O00122O0009008C3O00122O000A008D6O0008000A00024O00070007000800202O00070007008E4O00070002000200062O000700D7020100010004C23O00D702012O002C000700183O002692000700D70201008F0004C23O00D702012O002C000700013O00207C0007000700904O000900063O00202O0009000900914O00070009000200062O000700E902013O0004C23O00E902012O002C000700184O002C000800064O00D0000900083O00122O000A00923O00122O000B00936O0009000B00024O00080008000900202O0008000800944O00080002000200200B01080008009500200B0108000800960006D9000700E9020100080004C23O00E902012O002C0007000A4O002A000800063O00202O0008000800974O000900163O00202O00090009009800122O000B008F6O0009000B00024O000900096O00070009000200062O000700E4020100010004C23O00E40201002EB8009900070001009A0004C23O00E902012O002C000700083O0012990008009B3O0012990009009C4O00E5000700094O001C01076O002C000700203O00068E0007000104013O0004C23O000104012O002C000700213O00068E000700F202013O0004C23O00F202012O002C0007001A3O0006B5000700F5020100010004C23O00F502012O002C000700213O0006B500070001040100010004C23O000104012O002C000700174O002C000800183O0006AF00070001040100080004C23O00010401001299000700014O00F1000800093O0026A400072O00030100010004C24O000301001299000800014O00F1000900093O0012990007000A3O0026A4000700FB0201000A0004C23O00FB02010026A400080002030100010004C23O00020301001299000900013O0026A4000900710301000A0004C23O007103012O002C000A00013O00200E000A000A009D00122O000C000A6O000D00063O00202O000D000D009E4O000A000D000200062O000A000104013O0004C23O00010401001299000A00014O00F1000B000B3O0026A4000A0011030100010004C23O00110301001299000B00013O0026A4000B002E0301000A0004C23O002E03012O002C000C00064O0006000D00083O00122O000E009F3O00122O000F00A06O000D000F00024O000C000C000D00202O000C000C00244O000C0002000200062O000C000104013O0004C23O000104012O002C000C000A4O002C000D00063O00206C000D000D00A12O00A9000C000200020006B5000C0028030100010004C23O00280301002E1200A20001040100A30004C23O000104012O002C000C00083O00128D000D00A43O00122O000E00A56O000C000E6O000C5O00044O000104010026A4000B0014030100010004C23O00140301001299000C00013O002657000C00350301000A0004C23O00350301002E1200A70037030100A60004C23O00370301001299000B000A3O0004C23O00140301002657000C003B030100010004C23O003B0301002EB800A800F8FF2O00A90004C23O003103012O002C000D00064O00A7000E00083O00122O000F00AA3O00122O001000AB6O000E001000024O000D000D000E00202O000D000D00244O000D0002000200062O000D0047030100010004C23O00470301002ECD00AC0054030100AD0004C23O00540301002EB800AE000D000100AE0004C23O005403012O002C000D000A4O002C000E00063O00206C000E000E00AF2O00A9000D0002000200068E000D005403013O0004C23O005403012O002C000D00083O001299000E00B03O001299000F00B14O00E5000D000F4O001C010D6O002C000D00064O0006000E00083O00122O000F00B23O00122O001000B36O000E001000024O000D000D000E00202O000D000D00244O000D0002000200062O000D006B03013O0004C23O006B0301002E1200B5006B030100B40004C23O006B03012O002C000D000A4O002C000E00063O00206C000E000E00B62O00A9000D0002000200068E000D006B03013O0004C23O006B03012O002C000D00083O001299000E00B73O001299000F00B84O00E5000D000F4O001C010D5O001299000C000A3O0004C23O003103010004C23O001403010004C23O000104010004C23O001103010004C23O00010401002E1200BA0005030100B90004C23O000503010026A400090005030100010004C23O00050301001299000A00014O00F1000B000B3O002ECD00BC0077030100BB0004C23O007703010026A4000A0077030100010004C23O00770301001299000B00013O0026A4000B00800301000A0004C23O008003010012990009000A3O0004C23O00050301002ECD00BD007C030100BE0004C23O007C03010026A4000B007C030100010004C23O007C0301001299000C00013O002ECD00BF008B030100C00004C23O008B03010026A4000C008B0301000A0004C23O008B0301001299000B000A3O0004C23O007C03010026A4000C0085030100010004C23O008503012O002C000D00064O0006000E00083O00122O000F00C13O00122O001000C26O000E001000024O000D000D000E00202O000D000D00244O000D0002000200062O000D00AB03013O0004C23O00AB03012O002C000D00013O00207C000D000D00254O000F00063O00202O000F000F00914O000D000F000200062O000D00AB03013O0004C23O00AB03012O002C000D00163O00207C000D000D00C34O000F00063O00202O000F000F00C44O000D000F000200062O000D00AB03013O0004C23O00AB03012O002C000D00223O000EDF003A00AD0301000D0004C23O00AD03012O002C000D00233O000EDF003A00AD0301000D0004C23O00AD0301002ECD00C500C0030100C60004C23O00C00301002ECD00C800C0030100C70004C23O00C003012O002C000D000A4O00DA000E00063O00202O000E000E00C94O000F00163O00202O000F000F006A4O001100063O00202O0011001100C94O000F001100024O000F000F6O000D000F000200062O000D00C003013O0004C23O00C003012O002C000D00083O001299000E00CA3O001299000F00CB4O00E5000D000F4O001C010D6O002C000D00064O0006000E00083O00122O000F00CC3O00122O001000CD6O000E001000024O000D000D000E00202O000D000D00244O000D0002000200062O000D00F703013O0004C23O00F703012O002C000D00013O00200E000D000D009D00122O000F000A6O001000063O00202O00100010009E4O000D0010000200062O000D00DE03013O0004C23O00DE03012O002C000D00013O00207C000D000D00904O000F00063O00202O000F000F00CE4O000D000F000200062O000D00EC03013O0004C23O00EC03012O002C000D00013O002005000D000D00CF2O00A9000D0002000200068E000D00EC03013O0004C23O00EC03012O002C000D00013O00207C000D000D00904O000F00063O00202O000F000F00914O000D000F000200062O000D00F703013O0004C23O00F703012O002C000D00163O00207C000D000D00D04O000F00063O00202O000F000F00C44O000D000F000200062O000D00F703013O0004C23O00F703012O002C000D000A4O002C000E00063O00206C000E000E00D12O00A9000D0002000200068E000D00F703013O0004C23O00F703012O002C000D00083O001299000E00D23O001299000F00D34O00E5000D000F4O001C010D5O001299000C000A3O0004C23O008503010004C23O007C03010004C23O000503010004C23O007703010004C23O000503010004C23O000104010004C23O000203010004C23O000104010004C23O00FB02010012990006000A3O0004C23O009202010004C23O001802010004C23O00C405010004C23O00F200010004C23O00C405010004C23O00EF00010004C23O00C405010026A4000100390401003A0004C23O00390401001299000200013O0026A40002002D040100010004C23O002D0401001299000300013O002ECD00D50026040100D40004C23O002604010026A400030026040100010004C23O00260401001260000400D64O006B000500083O00122O000600D73O00122O000700D86O0005000700024O0004000400054O000500083O00122O000600D93O00122O000700DA6O0005000700024O0004000400052O007B000400144O002C000400013O0020050004000400DB2O00A900040002000200068E0004002504013O0004C23O002504012O00093O00013O0012990003000A3O0026570003002A0401000A0004C23O002A0401002E1200DD000F040100DC0004C23O000F04010012990002000A3O0004C23O002D04010004C23O000F0401002657000200310401000A0004C23O00310401002E1200DE000C040100DF0004C23O000C04012O002C000300163O0020910003000300E000122O000500386O0003000500024O000300243O00122O0001005B3O00044O003904010004C23O000C0401002ECD00E10074040100E20004C23O007404010026A4000100740401000A0004C23O00740401001299000200014O00F1000300033O00265700020043040100010004C23O00430401002E1200E3003F040100E40004C23O003F0401001299000300013O000EA2000A0054040100030004C23O00540401001260000400D64O006B000500083O00122O000600E53O00122O000700E66O0005000700024O0004000400054O000500083O00122O000600E73O00122O000700E86O0005000700024O0004000400052O007B000400253O0012990001003A3O0004C23O00740401002ECD00E90044040100730004C23O004404010026A400030044040100010004C23O00440401001260000400D64O00FE000500083O00122O000600EA3O00122O000700EB6O0005000700024O0004000400054O000500083O00122O000600EC3O00122O000700ED6O0005000700024O0004000400054O000400263O00122O000400D66O000500083O00122O000600EE3O00122O000700EF6O0005000700024O0004000400054O000500083O00122O000600F03O00122O000700F16O0005000700024O0004000400054O0004001A3O00122O0003000A3O0004C23O004404010004C23O007404010004C23O003F0401002EB800F20029000100F20004C23O009D04010026A40001009D040100010004C23O009D0401001299000200013O0026A40002008C040100010004C23O008C0401001299000300013O002ECD00F30085040100F40004C23O008504010026A400030085040100010004C23O008504012O002C000400274O00CB0004000100012O002C000400284O00CB0004000100010012990003000A3O002ECD00F6007C040100F50004C23O007C04010026A40003007C0401000A0004C23O007C04010012990002000A3O0004C23O008C04010004C23O007C04010026A4000200790401000A0004C23O00790401001260000300D64O006B000400083O00122O000500F73O00122O000600F86O0004000600024O0003000300044O000400083O00122O000500F93O00122O000600FA6O0004000600024O0003000300042O007B000300103O0012990001000A3O0004C23O009D04010004C23O00790401002657000100A10401005B0004C23O00A10401002ECD00FC0007000100FB0004C23O00070001001299000200014O00F1000300033O002EB800FD3O000100FD0004C23O00A304010026A4000200A3040100010004C23O00A30401001299000300013O002EB800FE0051000100FE0004C23O00F904010026A4000300F9040100010004C23O00F90401001299000400013O0026A4000400EF040100010004C23O00EF04012O002C000500013O00200C0105000500FF00122O0007008F6O0005000700024O000500293O00122O0005002O012O000E3O0001D9040100050004C23O00D904012O002C000500263O00068E000500D904013O0004C23O00D90401001299000500014O00F1000600063O001299000700013O00060B000500C3040100070004C23O00C3040100129900070002012O00129900080003012O000644000700BC040100080004C23O00BC0401001299000600013O001299000700013O000644000600C4040100070004C23O00C4040100126000070004013O0067000800163O00122O000A0005015O00080008000A00122O000A00386O0008000A00024O000900296O000900096O0007000900024O000700226O000700296O000700076O000700233O00044O00EE04010004C23O00C404010004C23O00EE04010004C23O00BC04010004C23O00EE0401001299000500014O00F1000600063O00129900070006012O00129900080007012O0006AF000800DB040100070004C23O00DB0401001299000700013O000644000700DB040100050004C23O00DB0401001299000600013O001299000700013O000644000600E3040100070004C23O00E304010012990007000A4O007B000700223O0012990007000A4O007B000700233O0004C23O00EE04010004C23O00E304010004C23O00EE04010004C23O00DB04010012990004000A3O0012990005000A3O00060B000400F6040100050004C23O00F6040100129900050008012O00129900060009012O0006D9000600AD040100050004C23O00AD04010012990003000A3O0004C23O00F904010004C23O00AD04010012990004000A3O000644000300A8040100040004C23O00A804012O002C000400053O00206C0004000400392O00980004000100020006B500040006050100010004C23O000605012O002C000400013O0020050004000400192O00A900040002000200068E000400BC05013O0004C23O00BC0501001299000400014O00F1000500053O001299000600013O00064400040008050100060004C23O00080501001299000500013O0012990006000A012O0012990007000A012O00064400060022050100070004C23O002205010012990006000A3O00064400050022050100060004C23O002205012O002C0006002A4O007B000600184O002C000600183O0012990007000B012O00060B0006001A050100070004C23O001A05010004C23O00BC05012O002C0006002B3O0012ED0007000C015O0006000600074O000700296O00088O0006000800024O000600183O00044O00BC0501001299000600013O0006440005000C050100060004C23O000C0501001299000600014O00F1000700073O001299000800013O00064400060027050100080004C23O00270501001299000700013O0012990008000D012O0012990009000D012O000644000800B1050100090004C23O00B10501001299000800013O000644000700B1050100080004C23O00B105012O002C000800013O0020050008000800192O00A90008000200020006B50008003E050100010004C23O003E05012O002C0008000E3O0006B50008003E050100010004C23O003E05010012990008000E012O0012990009000F012O000644000800A9050100090004C23O00A90501001299000800014O00F10009000B3O001299000C00013O000644000800460501000C0004C23O00460501001299000900014O00F1000A000A3O0012990008000A3O001299000C000A3O000644000800400501000C0004C23O004005012O00F1000B000B3O001299000C00013O000644000C0050050100090004C23O00500501001299000A00014O00F1000B000B3O0012990009000A3O001299000C000A3O0006440009004A0501000C0004C23O004A0501001299000C00013O00060B000A005A0501000C0004C23O005A0501001299000C0010012O001299000D0011012O0006D9000C00930501000D0004C23O00930501001299000C00013O001299000D00013O00060B000C00620501000D0004C23O00620501001299000D000E3O001299000E0012012O0006D9000D00890501000E0004C23O00890501001299000D00013O001299000E00013O000644000D007F0501000E0004C23O007F05012O002C000E000E3O000618000B00740501000E0004C23O007405012O002C000E00064O00CF000F00083O00122O00100013012O00122O00110014015O000F001100024O000E000E000F00202O000E000E002C4O000E0002000200062O000B00740501000E0004C23O007405012O002C000B00144O002C000E00053O0012F8000F0015015O000E000E000F4O000F000B6O001000073O00122O00110016015O001200123O00122O00130016015O000E001300024O000E00043O00122O000D000A3O001299000E000A3O00060B000D00860501000E0004C23O00860501001299000E0017012O001299000F0018012O0006D9000F00630501000E0004C23O00630501001299000C000A3O0004C23O008905010004C23O00630501001299000D0019012O001299000E0019012O000644000D005B0501000E0004C23O005B0501001299000D000A3O000644000C005B0501000D0004C23O005B0501001299000A000A3O0004C23O009305010004C23O005B0501001299000C000A3O00060B000A009A0501000C0004C23O009A0501001299000C001A012O001299000D001B012O000644000C00530501000D0004C23O00530501001299000C001C012O001299000D001D012O0006D9000D00A90501000C0004C23O00A905012O002C000C00043O00068E000C00A905013O0004C23O00A905012O002C000C00044O00E4000C00023O0004C23O00A905010004C23O005305010004C23O00A905010004C23O004A05010004C23O00A905010004C23O004005012O002C0008002B3O00124F0009001E015O0008000800094O000900096O000A00016O0008000A00024O0008002A3O00122O0007000A3O0012990008000A3O0006440007002B050100080004C23O002B05010012990005000A3O0004C23O000C05010004C23O002B05010004C23O000C05010004C23O002705010004C23O000C05010004C23O00BC05010004C23O00080501001299000100043O0004C23O000700010004C23O00A804010004C23O000700010004C23O00A304010004C23O000700010004C23O00C405010004C23O000200012O00093O00017O00063O00028O00026O00B340025O0010934003053O005072696E7403333O00D0F7F251FFE0B17DF0E2F410E3EAE551E5ECFE5EB1E7E810D4F5F853BFA5C245E1F5FE42E5E0F510F3FCB148DAE4FF55E5EABF03043O003091859100173O0012993O00014O00F1000100013O0026A43O0002000100010004C23O00020001001299000100013O000ED100010009000100010004C23O00090001002E1200020005000100030004C23O000500012O002C00026O00160102000100014O000200013O00202O0002000200044O000300023O00122O000400053O00122O000500066O000300056O00023O000100044O001600010004C23O000500010004C23O001600010004C23O000200012O00093O00017O00", GetFEnv(), ...);

