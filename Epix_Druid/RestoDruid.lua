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
				if (Enum <= 147) then
					if (Enum <= 73) then
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
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
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
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
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
										elseif (Enum > 2) then
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 7) then
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
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
										end
									elseif (Enum > 11) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 14) then
									if (Enum > 13) then
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] == Inst[4]) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum > 18) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 20) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 23) then
									if (Enum > 22) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 24) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								elseif (Enum > 25) then
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
								elseif (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum > 27) then
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
								elseif (Enum <= 29) then
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 30) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
							elseif (Enum <= 33) then
								if (Enum > 32) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 34) then
								if (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 35) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							end
						elseif (Enum <= 54) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum == 37) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum > 39) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 42) then
									if (Enum > 41) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum <= 43) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
								elseif (Enum == 44) then
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
							elseif (Enum <= 49) then
								if (Enum <= 47) then
									if (Enum == 46) then
										if (Inst[2] == Stk[Inst[4]]) then
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
								elseif (Enum > 48) then
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
								end
							elseif (Enum <= 51) then
								if (Enum == 50) then
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
							elseif (Enum <= 52) then
								do
									return Stk[Inst[2]]();
								end
							elseif (Enum == 53) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 63) then
							if (Enum <= 58) then
								if (Enum <= 56) then
									if (Enum == 55) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 57) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 60) then
								if (Enum > 59) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 61) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 62) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 68) then
							if (Enum <= 65) then
								if (Enum == 64) then
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
							elseif (Enum <= 66) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 67) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 70) then
							if (Enum == 69) then
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
						elseif (Enum <= 71) then
							Stk[Inst[2]] = Stk[Inst[3]];
						elseif (Enum > 72) then
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
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
					elseif (Enum <= 110) then
						if (Enum <= 91) then
							if (Enum <= 82) then
								if (Enum <= 77) then
									if (Enum <= 75) then
										if (Enum == 74) then
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
									elseif (Enum == 76) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 79) then
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
										if (Inst[2] < Stk[Inst[4]]) then
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
								elseif (Enum <= 80) then
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
								elseif (Enum > 81) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 86) then
								if (Enum <= 84) then
									if (Enum == 83) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum > 85) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 88) then
								if (Enum > 87) then
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
							elseif (Enum <= 89) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 90) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum <= 95) then
								if (Enum <= 93) then
									if (Enum == 92) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 94) then
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
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 97) then
								if (Enum > 96) then
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
							elseif (Enum <= 98) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum == 99) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								do
									return;
								end
							end
						elseif (Enum <= 105) then
							if (Enum <= 102) then
								if (Enum == 101) then
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
							elseif (Enum <= 103) then
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 104) then
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
						elseif (Enum <= 107) then
							if (Enum == 106) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 108) then
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
						elseif (Enum > 109) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 128) then
						if (Enum <= 119) then
							if (Enum <= 114) then
								if (Enum <= 112) then
									if (Enum > 111) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 113) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 118) then
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
						elseif (Enum <= 123) then
							if (Enum <= 121) then
								if (Enum > 120) then
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
								elseif (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 122) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 125) then
							if (Enum == 124) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							else
								local B;
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
						elseif (Enum == 127) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 137) then
						if (Enum <= 132) then
							if (Enum <= 130) then
								if (Enum == 129) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 131) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 134) then
							if (Enum == 133) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 135) then
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
						elseif (Enum > 136) then
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
						elseif (Inst[2] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 142) then
						if (Enum <= 139) then
							if (Enum > 138) then
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
						elseif (Enum <= 140) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 141) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
						end
					elseif (Enum <= 144) then
						if (Enum > 143) then
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
							VIP = Inst[3];
						end
					elseif (Enum <= 145) then
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Top));
					elseif (Enum > 146) then
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
					else
						do
							return Stk[Inst[2]];
						end
					end
				elseif (Enum <= 221) then
					if (Enum <= 184) then
						if (Enum <= 165) then
							if (Enum <= 156) then
								if (Enum <= 151) then
									if (Enum <= 149) then
										if (Enum > 148) then
											Stk[Inst[2]] = Inst[3];
										else
											Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										end
									elseif (Enum > 150) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 153) then
									if (Enum == 152) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Inst[2] < Inst[4]) then
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
								elseif (Enum <= 154) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 155) then
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
							elseif (Enum <= 160) then
								if (Enum <= 158) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 162) then
								if (Enum == 161) then
									if (Inst[2] > Stk[Inst[4]]) then
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
							elseif (Enum <= 163) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 164) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 174) then
							if (Enum <= 169) then
								if (Enum <= 167) then
									if (Enum > 166) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 168) then
									Stk[Inst[2]]();
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
							elseif (Enum <= 171) then
								if (Enum == 170) then
									local B = Stk[Inst[4]];
									if B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
							elseif (Enum <= 172) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 173) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 179) then
							if (Enum <= 176) then
								if (Enum == 175) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 178) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum > 180) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 182) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 183) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 202) then
						if (Enum <= 193) then
							if (Enum <= 188) then
								if (Enum <= 186) then
									if (Enum == 185) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 187) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 190) then
								if (Enum == 189) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 191) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 197) then
							if (Enum <= 195) then
								if (Enum > 194) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 196) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 199) then
							if (Enum == 198) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
									if (Mvm[1] == 71) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 200) then
							local Edx;
							local Results, Limit;
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
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						elseif (Enum == 201) then
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
					elseif (Enum <= 211) then
						if (Enum <= 206) then
							if (Enum <= 204) then
								if (Enum > 203) then
									local A;
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
							elseif (Enum == 205) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 208) then
							if (Enum > 207) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 209) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 216) then
						if (Enum <= 213) then
							if (Enum == 212) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] ~= 0;
							end
						elseif (Enum <= 214) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 215) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 218) then
						if (Enum > 217) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 220) then
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
				elseif (Enum <= 258) then
					if (Enum <= 239) then
						if (Enum <= 230) then
							if (Enum <= 225) then
								if (Enum <= 223) then
									if (Enum > 222) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 224) then
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
							elseif (Enum <= 227) then
								if (Enum == 226) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 228) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 229) then
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
						elseif (Enum <= 234) then
							if (Enum <= 232) then
								if (Enum == 231) then
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
							elseif (Enum > 233) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 236) then
							if (Enum > 235) then
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
								if (Inst[2] < Inst[4]) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 238) then
							Env[Inst[3]] = Stk[Inst[2]];
						elseif (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 248) then
						if (Enum <= 243) then
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
							elseif (Enum == 242) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
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
						elseif (Enum <= 245) then
							if (Enum > 244) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 246) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Env[Inst[3]] = Stk[Inst[2]];
						elseif (Enum > 247) then
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
					elseif (Enum <= 253) then
						if (Enum <= 250) then
							if (Enum > 249) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 251) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 252) then
							Stk[Inst[2]] = #Stk[Inst[3]];
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
						if (Enum > 254) then
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
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 256) then
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
					elseif (Enum == 257) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 277) then
					if (Enum <= 267) then
						if (Enum <= 262) then
							if (Enum <= 260) then
								if (Enum > 259) then
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
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum > 261) then
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 264) then
							if (Enum > 263) then
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
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 265) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum <= 272) then
						if (Enum <= 269) then
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
						elseif (Enum <= 270) then
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
					elseif (Enum <= 274) then
						if (Enum == 273) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 275) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 276) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 286) then
					if (Enum <= 281) then
						if (Enum <= 279) then
							if (Enum == 278) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
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
						elseif (Enum == 280) then
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
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
					elseif (Enum <= 283) then
						if (Enum > 282) then
							Stk[Inst[2]] = not Stk[Inst[3]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 284) then
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
					elseif (Enum == 285) then
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
				elseif (Enum <= 291) then
					if (Enum <= 288) then
						if (Enum == 287) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 289) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 290) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 293) then
					if (Enum == 292) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 294) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
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
				elseif (Enum > 295) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503193O00F4D3D23DD99FD50BD8C7E417E3A8D311F5D1CE2CE2F5CB0BD003083O007EB1A3BB4586DBA703193O000532E4BDC6AC2OFC2926D297FC9BFAE60430F8ACFDC6E2FC2103083O008940428DC599E88E002E3O0012E83O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004C93O000A000100121E000300063O00202700040003000700121E000500083O00202700050005000900121E000600083O00202700060006000A0006C700073O000100062O00473O00064O00478O00473O00044O00473O00014O00473O00024O00473O00053O00202700080003000B00202700090003000C2O004A000A5O00121E000B000D3O0006C7000C0001000100022O00473O000A4O00473O000B4O0047000D00073O001295000E000E3O001295000F000F4O0005000D000F00020006C7000E0002000100032O00473O00074O00473O00094O00473O00084O00FF000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00E500025O00122O000300016O00045O00122O000500013O00042O0003002100012O003D00076O001C010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O000100040E0103000500012O003D000300054O0047000400024O0063000300044O001601036O00C33O00017O00043O00028O00025O0076A140025O00A7B140026O00F03F01183O001295000200014O00F2000300033O000E2E00010010000100020004C93O001000012O003D00046O00C5000300043O002E880002000F000100030004C93O000F000100066A0003000F000100010004C93O000F00012O003D000400014O004700056O001801066O002400046O001601045O001295000200043O000E2E00040002000100020004C93O000200012O0047000400034O001801056O002400046O001601045O0004C93O000200012O00C33O00017O00503O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03093O0034B0C4CC8803221CAD03073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A3050030A3O0064570C3140711020454E03043O004529226003043O0095D7D20703063O004BDCA3B76A6203043O0021BB982303053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D47903073O0024E1A8C308E0B603043O00AE678EC503083O00733E5A2A3C51F65303073O009836483F58453E03053O00F0D6FB55D003043O003CB4A48E030B3O006A5B163D28FF134C570A2703073O0072383E6549478D03053O009CFBCECDBC03043O00A4D889BB030B3O00E0E322A6A9EC0AC6EF3EBC03073O006BB28651D2C69E03053O002O1C97CFAE03053O00CA586EE2A6030B3O00F10A91E3C5D10E96FEC5CD03053O00AAA36FE297028O00024O0080B3C540030C3O0047657445717569706D656E74026O002A40026O002C4003103O005265676973746572466F724576656E7403183O00211C93016B0516340187117E1A0C3F048D1B66160736159603073O00497150D2582E5703143O00B100EC2BC2B313FF37C0A402F237C9A00EE137C303053O0087E14CAD7203243O008D8A256D80CEF09C85307D93D9F09F9934679FCAE3859330709FC4E1938A396598CCEA8803073O00AFCCC97124D68B03043O0075CD3ED903053O006427AC55BC03133O005265676973746572504D756C7469706C696572030A3O0052616B65446562752O6603063O0053657441504C025O00405A400035023O0065000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F00122O001000046O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011001000114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012001000124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013001000134O00145O00122O001500203O00122O001600216O0014001600024O0014001000142O003D00155O0012D8001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400154O00155O00122O001600263O00122O001700276O0015001700024O0015001000154O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B6O0016001800024O00150015001600122O0016002C6O00175O00122O0018002D3O00122O0019002E6O0017001900024O0016001600174O00178O00188O00198O001A8O001B8O001C8O001D8O001E8O001F005B6O005C5O00122O005D002F3O00122O005E00306O005C005E00024O005C0010005C4O005D5O00122O005E00313O00122O005F00326O005D005F00024O005C005C005D4O005D5O00122O005E00333O00122O005F00346O005D005F00024O005D000D005D4O005E5O00122O005F00353O00122O006000366O005E006000024O005D005D005E4O005E5O00122O005F00373O00122O006000386O005E006000024O005E000F005E4O005F5O00122O006000393O00122O0061003A6O005F006100024O005E005E005F4O005F8O00605O00122O0061003B3O00122O0062003C6O0060006200024O0060001300604O00615O00122O0062003D3O00122O0063003E6O0061006300024O0060006000610012950061003F4O0096006200633O00122O006400403O00122O006500406O00668O00678O00688O00698O006A8O006B8O006C5O00202O006D000800414O006D0002000200202O006E006D004200062O006E00B600013O0004C93O00B600012O0047006E000F3O002027006F006D00422O00BB006E0002000200066A006E00B9000100010004C93O00B900012O0047006E000F3O001295006F003F4O00BB006E00020002002027006F006D004300061D006F00C100013O0004C93O00C100012O0047006F000F3O0020270070006D00432O00BB006F0002000200066A006F00C4000100010004C93O00C400012O0047006F000F3O0012950070003F4O00BB006F0002000200206E0070000400440006C700723O000100052O00473O006D4O00473O00084O00473O006E4O00473O000F4O00473O006F4O005F00735O00122O007400453O00122O007500466O007300756O00703O000100202O0070000400440006C700720001000100022O00473O00644O00473O00654O001F01735O00122O007400473O00122O007500486O007300756O00703O00010006C700700002000100042O00473O005D4O003D8O00473O005C4O00473O00063O00206E0071000400440006C700730003000100012O00473O00704O001F01745O00122O007500493O00122O0076004A6O007400766O00713O00010006C700710004000100012O00473O00084O008300725O00122O0073004B3O00122O0074004C6O0072007400024O0072005D007200202O00720072004D00202O0074005D004E4O007500716O0072007500010006C7007200050001000A2O00473O006A4O00473O00664O00473O005D4O003D8O00473O00084O00473O00694O00473O006B4O00473O00684O00473O00674O00473O006C3O0006C700730006000100022O00473O005D4O00473O00653O0006C700740007000100042O00473O005D4O00473O00654O00473O00634O00473O00083O0006C700750008000100012O00473O005D3O0006C700760009000100052O00473O005D4O00473O00084O003D3O00014O003D3O00024O00473O00633O0006C70077000A000100022O00473O005D4O00473O00083O0006C70078000B000100012O00473O005D3O0006C70079000C000100042O003D3O00014O00473O005C4O00473O005D4O003D3O00023O0006C7007A000D000100022O00473O005C4O00473O005D3O0006C7007B000E000100012O00473O005D3O0006C7007C000F000100052O00473O005C4O00473O005F4O00473O00194O00473O00084O00473O005D3O0006C7007D0010000100122O00473O005D4O003D8O00473O00084O00473O000A4O00473O00124O00473O00194O00473O00634O00473O001D4O00473O00784O00473O00764O00473O00774O00473O007C4O00473O002D4O00473O005C4O00473O00624O00473O00734O00473O00604O00473O00743O0006C7007E0011000100122O00473O005D4O003D8O00473O00634O00473O00684O00473O001D4O00473O00124O00473O000A4O00473O005C4O00473O00624O00473O00754O00473O00604O00473O00084O00473O00694O00473O006A4O00473O006C4O00473O00194O00473O00734O00473O002D3O0006C7007F00120001000C2O00473O005D4O003D8O00473O00084O00473O000A4O00473O00124O003D3O00014O003D3O00024O00473O005C4O00473O00634O00473O007D4O00473O00724O00473O007E3O0006C700800013000100062O00473O000B4O00473O005C4O00473O005D4O003D8O00473O00124O00473O00603O0006C7008100140001000F2O00473O005E4O003D8O00473O00264O00473O00084O00473O00274O00473O00124O00473O00604O00473O00204O00473O00224O00473O00214O00473O00584O00473O00594O00473O005D4O00473O005A4O00473O005B3O0006C700820015000100092O00473O005D4O003D8O00473O007B4O00473O000B4O00473O00124O00473O00604O00473O00084O00473O007A4O00473O000C3O0006C700830016000100332O00473O000B4O00473O001E4O00473O00084O00473O00194O00473O005D4O003D8O00473O005C4O00473O004D4O00473O004E4O00473O00124O00473O00504O00473O00514O00473O00314O00473O00324O00473O00334O00473O00604O00473O00794O00473O003A4O00473O003B4O00473O002F4O00473O00554O00473O00564O00473O00574O00473O00444O00473O00454O00473O007A4O00473O000C4O00473O00484O00473O00494O00473O00464O00473O00474O00473O00374O00473O00384O00473O00344O00473O00354O00473O00424O00473O00434O00473O003E4O00473O003F4O00473O00144O00473O00404O00473O00414O00473O003C4O00473O003D4O00473O007C4O00473O002E4O00473O004A4O00473O007B4O00473O004B4O00473O00534O00473O00543O0006C7008400170001000E2O00473O00284O00473O005C4O00473O005D4O00473O00604O00473O00254O00473O00244O00473O001A4O00473O00804O00473O00814O00473O001C4O00473O007F4O00473O001B4O00473O00824O00473O00833O0006C700850018000100132O00473O00284O00473O005C4O00473O005D4O00473O00604O00473O00294O00473O00254O00473O00244O00473O001A4O00473O00804O00473O00174O00473O001E4O00473O00834O00473O00234O003D8O00473O00084O00473O00124O00473O000A4O00473O001C4O00473O007F3O0006C700860019000100202O00473O00394O003D8O00473O003A4O00473O003B4O00473O003C4O00473O00374O00473O00384O00473O00214O00473O00224O00473O00234O00473O00244O00473O001F4O00473O00204O00473O00254O00473O00264O00473O00274O00473O00284O00473O00294O00473O002A4O00473O002F4O00473O00304O00473O002B4O00473O002C4O00473O002D4O00473O002E4O00473O003D4O00473O00334O00473O00344O00473O00314O00473O00324O00473O00354O00473O00363O0006C70087001A0001001F2O00473O00474O003D8O00473O00484O00473O00494O00473O003E4O00473O003F4O00473O00404O00473O004F4O00473O004D4O00473O004E4O00473O00534O00473O00544O00473O00554O00473O00414O00473O00424O00473O00434O00473O00464O00473O00444O00473O00454O00473O00594O00473O005A4O00473O005B4O00473O00504O00473O00514O00473O00524O00473O004A4O00473O004B4O00473O004C4O00473O00584O00473O00564O00473O00573O0006C70088001B0001001D2O00473O00184O00473O00624O00473O000A4O00473O00634O00473O005C4O00473O00084O00473O00654O00473O00044O00473O00644O00473O00174O00473O005D4O003D8O00473O00124O00473O00244O00473O001A4O00473O003D4O00473O003C4O00473O001E4O00473O00614O00473O00824O00473O00834O00473O00844O00473O00854O00473O00194O00473O001B4O00473O001C4O00473O001D4O00473O00864O00473O00873O0006C70089001C000100032O00473O00104O003D8O00473O00703O00201A008A0010004F00122O008B00506O008C00886O008D00896O008A008D00016O00013O001D3O00093O00028O00025O00E08B40025O00F49240030C3O0047657445717569706D656E74026O002A40026O00F03F025O00E2A940025O002FB240026O002C40002D3O0012953O00013O002E8800020018000100030004C93O001800010026EF3O0018000100010004C93O001800012O003D000100013O0020120001000100044O0001000200024O00018O00015O00202O00010001000500062O0001001300013O0004C93O001300012O003D000100034O003D00025O0020270002000200052O00BB00010002000200066A00010016000100010004C93O001600012O003D000100033O001295000200014O00BB0001000200022O002B000100023O0012953O00063O002E6700070001000100080004C93O000100010026EF3O0001000100060004C93O000100012O003D00015O00202700010001000900061D0001002600013O0004C93O002600012O003D000100034O003D00025O0020270002000200092O00BB00010002000200066A00010029000100010004C93O002900012O003D000100033O001295000200014O00BB0001000200022O002B000100043O0004C93O002C00010004C93O000100012O00C33O00017O00023O00028O00024O0080B3C54000103O0012953O00014O00F2000100013O0026EF3O0002000100010004C93O00020001001295000100013O0026EF00010005000100010004C93O00050001001295000200024O002B00025O001295000200024O002B000200013O0004C93O000F00010004C93O000500010004C93O000F00010004C93O000200012O00C33O00017O00113O0003133O0033E0A8A2A3ABA21EC3B9A4B9AFA209CEADA2A903073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65028O0003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD709018030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303123O00018DAC5C01841D112788BA68018A0416239703083O007045E4DF2C64E87103123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O667303123O00F01614C3B3708AD51D0BD6927984C11901C003073O00E6B47F67B3D61C03173O00A80C4C56E14DEC8D075343C940E785067B43E654E68A1603073O0080EC653F26842100374O003D8O004C000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O002A00013O0004C93O002A00010012953O00043O0026EF3O000B000100040004C93O000B00012O003D000100024O00F9000200013O00122O000300053O00122O000400066O0002000400024O000300033O00202O0003000300074O000400023O00202O0004000400084O000500023O00202O0005000500092O00050003000500022O00CC0001000200034O000100026O000200013O00122O0003000A3O00122O0004000B6O0002000400024O000300033O00202O0003000300074O000400023O00202O00040004000C2O003D000500023O00202700050005000D2O00050003000500022O00032O01000200030004C93O003600010004C93O000B00010004C93O003600012O003D3O00024O003B000100013O00122O0002000E3O00122O0003000F6O0001000300024O000200026O000300013O00122O000400103O00122O000500116O0003000500024O0002000200036O000100022O00C33O00019O003O00034O003D8O00A93O000100012O00C33O00017O00033O0003093O00537465616C74685570029A5O99F93F026O00F03F000D4O003D7O002004014O00014O000200016O000300018O0003000200064O000A00013O0004C93O000A00010012953O00023O00066A3O000B000100010004C93O000B00010012953O00034O00923O00024O00C33O00017O00213O00028O00027O0040025O00E8AE40025O0022A54003083O009E6CB89235A46ABC03053O0053CD18D9E003053O00436F756E7403053O00D1D7CC29EE03043O005D86A5AD03093O00497343617374696E6703053O00577261746803053O0089E0C0D63203083O001EDE92A1A25AAED203083O00D65A7118E347620F03043O006A852E1003083O005374617266697265026O00F03F026O000840025O009C9E40025O00BAA740025O00649340025O004AA140025O0029B340025O006EB34003063O0042752O665570030C3O0045636C697073654C756E617203083O0042752O66446F776E030C3O0045636C69707365536F6C6172025O00CAAB4003053O006F3272E85203063O00203840139C3A03083O0069DCE4445CFB925F03073O00E03AA885363A9200CB3O0012953O00014O00F2000100013O0026EF3O0002000100010004C93O00020001001295000100013O0026EF00010058000100020004C93O00580001001295000200013O0026C00002000C000100010004C93O000C0001002E8800030053000100040004C93O005300012O003D000300013O00066A0003002A000100010004C93O002A00012O003D000300024O0038000400033O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200262O00030023000100010004C93O002300012O003D000300024O0026010400033O00122O000500083O00122O000600096O0004000600024O00030003000400202O0003000300074O000300020002000E2O0001002D000100030004C93O002D00012O003D000300043O0020D300030003000A4O000500023O00202O00050005000B4O00030005000200062O0003002E000100010004C93O002E00012O003D000300053O0004C93O002E00012O004900036O00D5000300014O002B00036O003D000300013O00066A0003004D000100010004C93O004D00012O003D000300024O0038000400033O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O0003000300074O00030002000200262O00030046000100010004C93O004600012O003D000300024O0026010400033O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300074O000300020002000E2O00010050000100030004C93O005000012O003D000300043O0020D300030003000A4O000500023O00202O0005000500104O00030005000200062O00030051000100010004C93O005100012O003D000300073O0004C93O005100012O004900036O00D5000300014O002B000300063O001295000200113O000E2E00110008000100020004C93O00080001001295000100123O0004C93O005800010004C93O00080001002E880013008B000100140004C93O008B00010026EF0001008B000100110004C93O008B0001001295000200013O000E2E00110061000100020004C93O00610001001295000100023O0004C93O008B0001000E2200010065000100020004C93O00650001002E880016005D000100150004C93O005D0001001295000300013O002E8800170085000100180004C93O008500010026EF00030085000100010004C93O008500012O003D000400043O0020150104000400194O000600023O00202O00060006001A4O00040006000200062O0004007600013O0004C93O007600012O003D000400043O00206E00040004001B2O003D000600023O00202700060006001C2O00050004000600022O002B000400074O003D000400043O0020150104000400194O000600023O00202O00060006001C4O00040006000200062O0004008300013O0004C93O008300012O003D000400043O00206E00040004001B2O003D000600023O00202700060006001A2O00050004000600022O002B000400053O001295000300113O0026EF00030066000100110004C93O00660001001295000200113O0004C93O005D00010004C93O006600010004C93O005D0001002E43001D001F0001001D0004C93O00AA00010026EF000100AA000100010004C93O00AA00012O003D000200043O0020D30002000200194O000400023O00202O00040004001C4O00020004000200062O0002009B000100010004C93O009B00012O003D000200043O00206E0002000200192O003D000400023O00202700040004001A2O00050002000400022O002B000200014O003D000200043O0020150102000200194O000400023O00202O00040004001C4O00020004000200062O000200A800013O0004C93O00A800012O003D000200043O00206E0002000200192O003D000400023O00202700040004001A2O00050002000400022O002B000200083O001295000100113O0026EF00010005000100120004C93O000500012O003D000200013O00066A000200C3000100010004C93O00C300012O003D000200024O00B2000300033O00122O0004001E3O00122O0005001F6O0003000500024O00020002000300202O0002000200074O000200020002000E2O000100C3000100020004C93O00C300012O003D000200024O0026010300033O00122O000400203O00122O000500216O0003000500024O00020002000300202O0002000200074O000200020002000E2O000100C4000100020004C93O00C400012O004900026O00D5000200014O002B000200093O0004C93O00CA00010004C93O000500010004C93O00CA00010004C93O000200012O00C33O00017O00033O0003113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66026O001440010D3O0020152O013O00014O00035O00202O0003000300024O00010003000200062O0001000B00013O0004C93O000B00012O003D000100013O000E080003000A000100010004C93O000A00012O004900016O00D5000100014O0092000100024O00C33O00017O00113O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O66026O002840026O00104003063O00456E65726779026O00494003083O0042752O66446F776E030E3O0048656172744F6654686557696C6403063O0042752O665570030A3O00446562752O66446F776E03073O0050726576474344026O00F03F03073O0053756E6669726503083O00446562752O665570030D3O00446562752O6652656D61696E73030E3O00446562752O664475726174696F6E029A5O99E93F01533O0020152O013O00014O00035O00202O0003000300024O00010003000200062O0001002D00013O0004C93O002D00012O003D000100013O000EB60003002D000100010004C93O002D00012O003D000100023O00261900010011000100040004C93O001100012O003D000100033O00206E0001000100052O00BB0001000200020026A500010018000100060004C93O001800012O003D000100033O0020D30001000100074O00035O00202O0003000300084O00010003000200062O00010027000100010004C93O002700012O003D000100023O00261900010020000100040004C93O002000012O003D000100033O00206E0001000100052O00BB0001000200020026A50001002D000100060004C93O002D00012O003D000100033O0020152O01000100094O00035O00202O0003000300084O00010003000200062O0001002D00013O0004C93O002D000100206E00013O000A2O003D00035O0020270003000300022O000500010003000200066A00010051000100010004C93O005100012O003D000100033O00206600010001000B00122O0003000C6O00045O00202O00040004000D4O00010004000200062O0001005100013O0004C93O0051000100206E00013O000E2O003D00035O0020270003000300022O000500010003000200061D0001004600013O0004C93O0046000100206E00013O000F2O000B01035O00202O0003000300024O00010003000200202O00023O00104O00045O00202O0004000400024O00020004000200202O00020002001100062O0001004C000100020004C93O004C000100206E00013O000A2O003D00035O0020270003000300022O000500010003000200061D0001005100013O0004C93O005100012O003D000100023O0026C0000100500001000C0004C93O005000012O004900016O00D5000100014O0092000100024O00C33O00017O00043O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O6603093O0054696D65546F446965026O001440010E3O0020152O013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004C93O000C000100206E00013O00032O00BB000100020002000E080004000B000100010004C93O000B00012O004900016O00D5000100014O0092000100024O00C33O00017O000D3O0003113O00446562752O665265667265736861626C652O033O0052697003063O00456E65726779025O00805640030D3O00446562752O6652656D61696E73026O002440030B3O00436F6D626F506F696E7473026O00144003093O0054696D65546F446965026O003840026O001040030A3O00446562752O66446F776E027O0040016D3O0020D300013O00014O00035O00202O0003000300024O00010003000200062O00010011000100010004C93O001100012O003D000100013O00206E0001000100032O00BB000100020002000EB600040053000100010004C93O0053000100206E00013O00052O003D00035O0020270003000300022O000500010003000200260B00010053000100060004C93O005300012O003D000100013O00206E0001000100072O00BB0001000200020026EF0001001F000100080004C93O001F000100206E00013O00092O007D00010002000200202O00023O00054O00045O00202O0004000400024O00020004000200202O00020002000A00062O0002006A000100010004C93O006A00012O003D000100023O00200A00023O00054O00045O00202O0004000400024O0002000400024O000300013O00202O0003000300074O00030002000200202O00030003000B4O0001000300024O000200033O00206E00033O00052O001800055O00202O0005000500024O0003000500024O000400013O00202O0004000400074O00040002000200202O00040004000B4O0002000400024O00010001000200202O00023O00092O00BB00020002000200062900010053000100020004C93O005300012O003D000100023O00205400023O00054O00045O00202O0004000400024O00020004000200202O00020002000B4O000300013O00202O0003000300074O00030002000200202O00030003000B4O0001000300024O000200033O00202O00033O00054O00055O00202O0005000500024O00030005000200202O00030003000B4O000400013O00202O0004000400074O00040002000200202O00040004000B4O0002000400024O00010001000200202O00023O00094O00020002000200062O0002006A000100010004C93O006A000100206E00013O000C2O003D00035O0020270003000300022O000500010003000200061D0001006B00013O0004C93O006B00012O003D000100013O0020250001000100074O0001000200024O000200023O00122O0003000D6O000400043O00202O00040004000D4O0002000400024O000300033O00122O0004000D6O000500043O00202O00050005000D4O0003000500024O00020002000300062O0002006A000100010004C93O006A00012O004900016O00D5000100014O0092000100024O00C33O00017O00073O00030A3O00446562752O66446F776E030A3O0052616B65446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O002440030B3O00436F6D626F506F696E7473026O00144001193O0020D300013O00014O00035O00202O0003000300024O00010003000200062O0001000C000100010004C93O000C000100206E00013O00032O003D00035O0020270003000300022O000500010003000200061D0001001700013O0004C93O0017000100206E00013O00042O00BB000100020002000EB600050015000100010004C93O001500012O003D000100013O00206E0001000100062O00BB0001000200020026A400010016000100070004C93O001600012O004900016O00D5000100014O0092000100024O00C33O00017O00023O0003083O00446562752O66557003133O004164617074697665537761726D446562752O6601063O00205B00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00043O00031A3O00467269656E646C79556E6974735769746842752O66436F756E74030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746800434O00C89O0000018O000200013O00202O0002000200014O000300023O00202O0003000300024O0002000200024O000300013O00202O0003000300014O000400023O00202O0004000400034O000300046O00013O00024O000200036O000300013O00202O0003000300014O000400023O00202O0004000400024O0003000200024O000400013O00202O0004000400014O000500023O00202O0005000500034O000400056O00023O00024O0001000100024O000200013O00202O0002000200014O000300023O00202O0003000300044O000200039O0000024O000100036O00028O000300013O00202O0003000300014O000400023O00202O0004000400024O0003000200024O000400013O00202O0004000400014O000500023O00202O0005000500034O000400056O00023O00024O000300036O000400013O00202O0004000400014O000500023O00202O0005000500024O0004000200024O000500013O00202O0005000500014O000600023O00202O0006000600034O000500066O00033O00024O0002000200034O000300013O00202O0003000300014O000400023O00202O0004000400044O000300046O00013O00028O00016O00028O00017O00023O00031D3O00467269656E646C79556E697473576974686F757442752O66436F756E74030C3O0052656A7576656E6174696F6E00074O00647O00206O00014O000100013O00202O0001000100026O00019O008O00017O00043O0003063O0042752O665570030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746801123O0020D300013O00014O00035O00202O0003000300024O00010003000200062O00010010000100010004C93O0010000100206E00013O00012O003D00035O0020270003000300032O000500010003000200066A00010010000100010004C93O0010000100206E00013O00012O003D00035O0020270003000300042O00050001000300022O0092000100024O00C33O00017O000C3O00028O00026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B657403063O0042752O665570030E3O0048656172744F6654686557696C64030F3O00496E6361726E6174696F6E42752O66026O004440025O0010774003103O0048616E646C65546F705472696E6B6574025O000AAC40025O0056A74000433O0012953O00013O000E2E0002001F00013O0004C93O001F00012O003D00015O0020270001000100042O003D000200014O003D000300023O00061D0003001500013O0004C93O001500012O003D000300033O0020D30003000300054O000500043O00202O0005000500064O00030005000200062O00030015000100010004C93O001500012O003D000300033O00206E0003000300052O003D000500043O0020270005000500072O0005000300050002001295000400084O001A010500056O00010005000200122O000100033O00122O000100033O00062O0001004200013O0004C93O0042000100121E000100034O0092000100023O0004C93O00420001002E43000900E2FF2O00090004C93O000100010026EF3O0001000100010004C93O000100012O003D00015O00202700010001000A2O003D000200014O003D000300023O00061D0003003500013O0004C93O003500012O003D000300033O0020D30003000300054O000500043O00202O0005000500064O00030005000200062O00030035000100010004C93O003500012O003D000300033O00206E0003000300052O003D000500043O0020270005000500072O0005000300050002001295000400084O0055000500056O00010005000200122O000100033O00122O000100033O00062O0001003E000100010004C93O003E0001002E88000B00400001000C0004C93O0040000100121E000100034O0092000100023O0012953O00023O0004C93O000100012O00C33O00017O00C43O00028O00026O00F03F025O001AB140025O004AA640026O000840030D3O00C2746E46D846EFF1625E40CF4A03073O008084111C29BB2F03073O0049735265616479030B3O00436F6D626F506F696E747303093O0054696D65546F446965026O002440026O00144003063O00456E65726779026O0039402O033O00333B1603053O003D6152665A030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E732O033O00526970030D3O004665726F63696F757342697465030E3O004973496E4D656C2O6552616E676503153O00AA2BB944C45E111CBF11A942D3525E0AAD3AEB189503083O0069CC4ECB2BA7377E026O001040030E3O006682E23F5AA8E5194682D424428303043O004D2EE783030A3O0049734361737461626C6503113O00995BB856B55FB374B2518550B346BF54A903043O0020DA34D6030F3O00432O6F6C646F776E52656D61696E73026O003E4003113O006D183FBEFEBB406E461202B8F8A24C4E5D03083O003A2E7751C891D02503083O0042752O66446F776E030E3O0048656172744F6654686557696C6403083O00446562752O665570030D3O0053756E66697265446562752O66030E3O004D2O6F6E66697265446562752O6603183O00238931BEBD82392DB324A4AC8221228034ECAABC226BDE6603073O00564BEC50CCC9DD03073O00514063A3F1997F03063O00EB122117E59E03073O00436174466F726D025O00C09A40025O0024AC40030F3O0053BBD58456B5D3B610B9C0AF10E89903043O00DB30DAA1025O00BBB140025O005AA54003043O00BEFC473703073O001AEC9D2C52722C025O00805640030B3O00504D756C7469706C69657203043O0052616B65025O004EA440025O00188040030B3O00382FDE5E6A2DD44F6A7A8503043O003B4A4EB503053O0016C6534AB603053O00D345B12O3A027O0040025O0054AD40025O00508940025O00849940025O00E49E4003053O005377697065026O002040030C3O00A4F270E5EC8BB4E46DB5BA9303063O00ABD78519958903053O00D2C020FFEB03083O002281A8529A8F509C025O00B0B140025O0046AC4003053O005368726564030C3O0096BA210E4C0E8A84A6735F1A03073O00E9E5D2536B282E025O00806540025O0058A04003093O0023428299953BBFF71503083O00907036E3EBE64ECD03093O00537461727375726765030E3O0049735370652O6C496E52616E676503103O00A03C0EEEC34EA12F0ABCD35AA7685DAA03063O003BD3486F9CB0025O0090A040025O00BCA240025O00607640025O00A6A240025O001DB24003073O004B92201171952B03043O007718E74E030A3O00446562752O66446F776E025O00C49340025O00AEA54003073O0053756E66697265030E3O009138AB4CD55214C22EA45E9C124503073O0071E24DC52ABC2003083O001719FBBB3C1FE6B003043O00D55A769403083O004D2O6F6E66697265025O004EB140025O00804940030F3O005621BB584B523CB1164E5A3AF4041903053O002D3B4ED436025O003C9D40025O00389F402O033O0097A33303083O0031C5CA437E7364A72O033O000552CF03073O003E573BBF49E036026O002640025O0046A040025O00E4AE40030A3O00F50BEA89E403EE89B45603043O00A987629A03063O00FF7F3655EE3B03073O00A8AB1744349D5303113O00446562752O665265667265736861626C65030C3O00546872617368446562752O6603063O00546872617368030A3O00E079E7AC3625C7F770E103073O00E7941195CD454D03043O00B2A6CCFE03063O009FE0C7A79B37025O00049D40025O00804D40030B3O00E5F237D7B7F03DC6B7A06A03043O00B297935C025O00409340025O00CAA740026O005A40030D3O001DAB805CF7706E399C964DF17403073O00185CCFE12C8319025O00B6B140025O002EA740030D3O004164617074697665537761726D03123O004AD7B95C0F745DD6875F0C7C59DEF84F1A6903063O001D2BB3D82C7B025O00F2AA40025O0080A240025O007DB240025O00B8AB4003043O006B5740F803083O006B39362B9D15E6E703093O00537465616C74685570025O00549F40025O004FB240030A3O00C98A1AF0F9DFCECFCB4303073O00AFBBEB7195D9BC030B3O005573655472696E6B657473025O009C9B40025O00A08C40025O000AAC40025O00C4AC40025O00C05240025O00E07A4003113O009ED62E5AB2D22578B5DC135CB4CB2958AE03043O002CDDB94003063O0042752O665570025O003DB040025O0026A940025O007C9C40025O00BCA540030E3O0029E2494D672EE17C577636EE445B03053O00136187283F026O004E40030E3O00865932293B1EA8683B3E1838A25803063O0051CE3C535B4F026O00494003113O00436F6E766F6B655468655370697269747303093O004973496E52616E6765031A3O004DA4DE6420C8489B5AA3D54D3CD344B647BFC3322CC259E41FF303083O00C42ECBB0124FA32D025O00D4AA40025O00909B4003073O008B3770182DE9EA03073O008FD8421E7E449B2O033O0098C11D03083O0081CAA86DABA5C3B703093O00436173744379636C6503103O0053756E666972654D6F7573656F766572030E3O00314D39DED706E3625B36CC9E46B603073O0086423857B8BE74025O0090AF40025O00709C4003083O00113E06B51FE2333003083O00555C5169DB798B412O033O00CFBA4003063O00BF9DD330251C025O0060B040025O00C2A34003113O004D2O6F6E666972654D6F7573656F766572030F3O00D210FB123CD60DF15C39DE0BB44E6803053O005ABF7F947C025O00489840025O002AA24000D0032O0012953O00014O00F2000100023O0026EF3O00C7030100020004C93O00C70301002E8800040004000100030004C93O000400010026EF00010004000100010004C93O00040001001295000200013O0026EF000200C3000100050004C93O00C30001001295000300014O00F2000400043O000E2E0001000D000100030004C93O000D0001001295000400013O0026EF00040053000100020004C93O005300012O003D00056O004C000600013O00122O000700063O00122O000800076O0006000800024O00050005000600202O0005000500084O00050002000200062O0005005100013O0004C93O005100012O003D000500023O00206E0005000500092O00BB000500020002000EB600050026000100050004C93O002600012O003D000500033O00206E00050005000A2O00BB0005000200020026A4000500410001000B0004C93O004100012O003D000500023O00206E0005000500092O00BB0005000200020026EF000500510001000C0004C93O005100012O003D000500023O00206E00050005000D2O00BB000500020002000E78000E0051000100050004C93O005100012O003D00056O004C000600013O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O00050002000200062O0005004100013O0004C93O004100012O003D000500033O00204E0005000500124O00075O00202O0007000700134O000500070002000E2O000C0051000100050004C93O005100012O003D000500044O003100065O00202O0006000600144O000700033O00202O00070007001500122O0009000C6O0007000900024O000700076O00050007000200062O0005005100013O0004C93O005100012O003D000500013O001295000600163O001295000700174O0063000500074O001601055O001295000200183O0004C93O00C300010026EF00040010000100010004C93O001000012O003D00056O004C000600013O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005009900013O0004C93O009900012O003D000500053O00061D0005009900013O0004C93O009900012O003D00056O0005010600013O00122O0007001C3O00122O0008001D6O0006000800024O00050005000600202O00050005001E4O00050002000200262O000500760001001F0004C93O007600012O003D00056O000F010600013O00122O000700203O00122O000800216O0006000800024O00050005000600202O0005000500114O00050002000200062O00050099000100010004C93O009900012O003D000500023O0020150105000500224O00075O00202O0007000700234O00050007000200062O0005009900013O0004C93O009900012O003D000500033O0020150105000500244O00075O00202O0007000700254O00050007000200062O0005009900013O0004C93O009900012O003D000500033O0020D30005000500244O00075O00202O0007000700264O00050007000200062O0005008E000100010004C93O008E00012O003D000500063O000EB600180099000100050004C93O009900012O003D000500044O003D00065O0020270006000600232O00BB00050002000200061D0005009900013O0004C93O009900012O003D000500013O001295000600273O001295000700284O0063000500074O001601056O003D00056O004C000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500B200013O0004C93O00B200012O003D000500023O0020150105000500224O00075O00202O00070007002B4O00050007000200062O000500B200013O0004C93O00B200012O003D000500023O00206E00050005000D2O00BB000500020002000E78001F00B2000100050004C93O00B200012O003D000500073O00066A000500B4000100010004C93O00B40001002E88002D00BF0001002C0004C93O00BF00012O003D000500044O003D00065O00202700060006002B2O00BB00050002000200061D000500BF00013O0004C93O00BF00012O003D000500013O0012950006002E3O0012950007002F4O0063000500074O001601055O001295000400023O0004C93O001000010004C93O00C300010004C93O000D0001002E67003100462O0100300004C93O00462O010026EF000200462O01000C0004C93O00462O012O003D00036O004C000400013O00122O000500323O00122O000600336O0004000600024O00030003000400202O0003000300084O00030002000200062O000300EC00013O0004C93O00EC00012O003D000300023O00206E0003000300092O00BB0003000200020026A4000300DB0001000C0004C93O00DB00012O003D000300023O00206E00030003000D2O00BB000300020002000EB6003400EC000100030004C93O00EC00012O003D000300033O00209F0003000300354O00055O00202O0005000500364O0003000500024O000400023O00202O0004000400354O00065O00202O0006000600364O00040006000200062O000300EC000100040004C93O00EC00012O003D000300084O003D000400034O00BB00030002000200066A000300EE000100010004C93O00EE0001002E67003700FE000100380004C93O00FE00012O003D000300044O003100045O00202O0004000400364O000500033O00202O00050005001500122O0007000C6O0005000700024O000500056O00030005000200062O000300FE00013O0004C93O00FE00012O003D000300013O001295000400393O0012950005003A4O0063000300054O001601036O003D00036O004C000400013O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003000B2O013O0004C93O000B2O012O003D000300063O000EA1003D000D2O0100030004C93O000D2O01002E88003E001F2O01003F0004C93O001F2O01002E670040001F2O0100410004C93O001F2O012O003D000300044O003100045O00202O0004000400424O000500033O00202O00050005001500122O000700436O0005000700024O000500056O00030005000200062O0003001F2O013O0004C93O001F2O012O003D000300013O001295000400443O001295000500454O0063000300054O001601036O003D00036O004C000400013O00122O000500463O00122O000600476O0004000600024O00030003000400202O0003000300084O00030002000200062O000300CF03013O0004C93O00CF03012O003D000300023O00206E0003000300092O00BB0003000200020026A4000300332O01000C0004C93O00332O012O003D000300023O00206E00030003000D2O00BB000300020002000EB6003400CF030100030004C93O00CF0301002E67004900CF030100480004C93O00CF03012O003D000300044O003100045O00202O00040004004A4O000500033O00202O00050005001500122O0007000C6O0005000700024O000500056O00030005000200062O000300CF03013O0004C93O00CF03012O003D000300013O0012170104004B3O00122O0005004C6O000300056O00035O00044O00CF0301000E22003D004A2O0100020004C93O004A2O01002E67004E00DC2O01004D0004C93O00DC2O01001295000300013O0026EF000300712O0100020004C93O00712O012O003D00046O004C000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500202O0004000400084O00040002000200062O0004006F2O013O0004C93O006F2O012O003D000400023O0020150104000400224O00065O00202O00060006002B4O00040006000200062O0004006F2O013O0004C93O006F2O012O003D000400044O005800055O00202O0005000500514O000600033O00202O0006000600524O00085O00202O0008000800514O0006000800024O000600066O00040006000200062O0004006F2O013O0004C93O006F2O012O003D000400013O001295000500533O001295000600544O0063000400064O001601045O001295000200053O0004C93O00DC2O010026EF0003004B2O0100010004C93O004B2O01001295000400013O002E4300550006000100550004C93O007A2O010026EF0004007A2O0100020004C93O007A2O01001295000300023O0004C93O004B2O010026C00004007E2O0100010004C93O007E2O01002E43005600F8FF2O00570004C93O00742O01002E88005800A92O0100590004C93O00A92O012O003D00056O004C000600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500084O00050002000200062O000500A92O013O0004C93O00A92O012O003D000500033O00201501050005005C4O00075O00202O0007000700254O00050007000200062O000500A92O013O0004C93O00A92O012O003D000500033O00206E00050005000A2O00BB000500020002000EB6000C00A92O0100050004C93O00A92O01002E88005D00A92O01005E0004C93O00A92O012O003D000500044O005800065O00202O00060006005F4O000700033O00202O0007000700524O00095O00202O00090009005F4O0007000900024O000700076O00050007000200062O000500A92O013O0004C93O00A92O012O003D000500013O001295000600603O001295000700614O0063000500074O001601056O003D00056O004C000600013O00122O000700623O00122O000800636O0006000800024O00050005000600202O0005000500084O00050002000200062O000500D92O013O0004C93O00D92O012O003D000500023O0020150105000500224O00075O00202O00070007002B4O00050007000200062O000500D92O013O0004C93O00D92O012O003D000500033O00201501050005005C4O00075O00202O0007000700264O00050007000200062O000500D92O013O0004C93O00D92O012O003D000500033O00206E00050005000A2O00BB000500020002000EB6000C00D92O0100050004C93O00D92O012O003D000500044O002800065O00202O0006000600644O000700033O00202O0007000700524O00095O00202O0009000900644O0007000900024O000700076O00050007000200062O000500D42O0100010004C93O00D42O01002E88006500D92O0100660004C93O00D92O012O003D000500013O001295000600673O001295000700684O0063000500074O001601055O001295000400023O0004C93O00742O010004C93O004B2O01002E67006900540201006A0004C93O005402010026EF00020054020100180004C93O005402012O003D00036O004C000400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300FC2O013O0004C93O00FC2O012O003D00036O004C000400013O00122O0005006D3O00122O0006006E6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300FC2O013O0004C93O00FC2O012O003D000300063O0026A5000300FC2O01006F0004C93O00FC2O012O003D000300094O003D000400034O00BB00030002000200066A000300FE2O0100010004C93O00FE2O01002E670071000E020100700004C93O000E02012O003D000300044O003100045O00202O0004000400134O000500033O00202O00050005001500122O0007000C6O0005000700024O000500056O00030005000200062O0003000E02013O0004C93O000E02012O003D000300013O001295000400723O001295000500734O0063000300054O001601036O003D00036O004C000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300084O00030002000200062O0003003202013O0004C93O003202012O003D000300063O000E78003D0032020100030004C93O003202012O003D000300033O0020150103000300764O00055O00202O0005000500774O00030005000200062O0003003202013O0004C93O003202012O003D000300044O003100045O00202O0004000400784O000500033O00202O00050005001500122O000700436O0005000700024O000500056O00030005000200062O0003003202013O0004C93O003202012O003D000300013O001295000400793O0012950005007A4O0063000300054O001601036O003D00036O004C000400013O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003005302013O0004C93O005302012O003D0003000A4O003D000400034O00BB00030002000200061D0003005302013O0004C93O00530201002E88007E00530201007D0004C93O005302012O003D000300044O003100045O00202O0004000400364O000500033O00202O00050005001500122O0007000C6O0005000700024O000500056O00030005000200062O0003005302013O0004C93O005302012O003D000300013O0012950004007F3O001295000500804O0063000300054O001601035O0012950002000C3O0026C000020058020100010004C93O00580201002E4300810084000100820004C93O00DA0201001295000300014O00F2000400043O002E4300833O000100830004C93O005A02010026EF0003005A020100010004C93O005A0201001295000400013O000E2E00020080020100040004C93O008002012O003D00056O004C000600013O00122O000700843O00122O000800856O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005007E02013O0004C93O007E0201002E880087007E020100860004C93O007E02012O003D000500044O005800065O00202O0006000600884O000700033O00202O0007000700524O00095O00202O0009000900884O0007000900024O000700076O00050007000200062O0005007E02013O0004C93O007E02012O003D000500013O001295000600893O0012950007008A4O0063000500074O001601055O001295000200023O0004C93O00DA0201000E2E0001005F020100040004C93O005F0201001295000500013O0026C000050087020100010004C93O00870201002E67008B00D00201008C0004C93O00D00201002E67008E00AC0201008D0004C93O00AC02012O003D00066O004C000700013O00122O0008008F3O00122O000900906O0007000900024O00060006000700202O0006000600084O00060002000200062O000600AC02013O0004C93O00AC02012O003D000600023O0020040106000600914O00088O000900016O00060009000200062O000600AC02013O0004C93O00AC02012O003D000600044O005000075O00202O0007000700364O000800033O00202O00080008001500122O000A000B6O0008000A00024O000800086O00060008000200062O000600A7020100010004C93O00A70201002E88009300AC020100920004C93O00AC02012O003D000600013O001295000700943O001295000800954O0063000600084O001601065O00121E000600963O00061D000600B602013O0004C93O00B602012O003D000600023O0020040106000600914O00088O000900016O00060009000200062O000600B802013O0004C93O00B80201002E67009700CF020100980004C93O00CF0201001295000600014O00F2000700083O002E88009900C90201009A0004C93O00C902010026EF000600C9020100020004C93O00C902010026EF000700BE020100010004C93O00BE02012O003D0009000B4O007A0009000100022O0047000800093O00061D000800CF02013O0004C93O00CF02012O0092000800023O0004C93O00CF02010004C93O00BE02010004C93O00CF02010026EF000600BA020100010004C93O00BA0201001295000700014O00F2000800083O001295000600023O0004C93O00BA0201001295000500023O000E22000200D4020100050004C93O00D40201002E67009C00830201009B0004C93O00830201001295000400023O0004C93O005F02010004C93O008302010004C93O005F02010004C93O00DA02010004C93O005A0201000E2E00020009000100020004C93O000900012O003D0003000C3O00061D0003003603013O0004C93O003603012O003D000300053O00061D0003003603013O0004C93O003603012O003D00036O004C000400013O00122O0005009D3O00122O0006009E6O0004000600024O00030003000400202O00030003001B4O00030002000200062O0003003603013O0004C93O003603012O003D000300023O0020D300030003009F4O00055O00202O00050005002B4O00030005000200062O000300F5020100010004C93O00F50201002E6700A00036030100A10004C93O00360301002E8800A20036030100A30004C93O003603012O003D000300023O0020D300030003009F4O00055O00202O0005000500234O00030005000200062O00030012030100010004C93O001203012O003D00036O0026010400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400202O00030003001E4O000300020002000E2O00A60012030100030004C93O001203012O003D00036O000F010400013O00122O000500A73O00122O000600A86O0004000600024O00030003000400202O0003000300114O00030002000200062O00030036030100010004C93O003603012O003D000300023O00206E00030003000D2O00BB0003000200020026A500030036030100A90004C93O003603012O003D000300023O00206E0003000300092O00BB0003000200020026A5000300230301000C0004C93O002303012O003D000300033O0020360003000300124O00055O00202O0005000500134O000300050002000E2O000C0026030100030004C93O002603012O003D000300063O000EB600020036030100030004C93O003603012O003D000300044O003100045O00202O0004000400AA4O000500033O00202O0005000500AB00122O0007001F6O0005000700024O000500056O00030005000200062O0003003603013O0004C93O003603012O003D000300013O001295000400AC3O001295000500AD4O0063000300054O001601035O002E6700AF007B030100AE0004C93O007B03012O003D00036O004C000400013O00122O000500B03O00122O000600B16O0004000600024O00030003000400202O0003000300084O00030002000200062O0003007B03013O0004C93O007B03012O003D000300023O0020150103000300224O00055O00202O00050005002B4O00030005000200062O0003007B03013O0004C93O007B03012O003D000300033O00206E00030003000A2O00BB000300020002000EB6000C007B030100030004C93O007B03012O003D00036O004C000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O0003000300114O00030002000200062O0003006403013O0004C93O006403012O003D000300033O0020D30003000300244O00055O00202O0005000500134O00030005000200062O00030064030100010004C93O006403012O003D000300023O00206E00030003000D2O00BB0003000200020026A50003007B0301001F0004C93O007B03012O003D0003000D3O0020EB0003000300B44O00045O00202O00040004005F4O0005000E6O0006000F6O000700033O00202O0007000700524O00095O00202O00090009005F4O0007000900024O000700076O000800096O000A00103O00202O000A000A00B54O0003000A000200062O0003007B03013O0004C93O007B03012O003D000300013O001295000400B63O001295000500B74O0063000300054O001601035O002E8800B900C2030100B80004C93O00C203012O003D00036O004C000400013O00122O000500BA3O00122O000600BB6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300C203013O0004C93O00C203012O003D000300023O0020150103000300224O00055O00202O00050005002B4O00030005000200062O000300C203013O0004C93O00C203012O003D000300033O00206E00030003000A2O00BB000300020002000EB6000C00C2030100030004C93O00C203012O003D00036O004C000400013O00122O000500BC3O00122O000600BD6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300A903013O0004C93O00A903012O003D000300033O0020D30003000300244O00055O00202O0005000500134O00030005000200062O000300A9030100010004C93O00A903012O003D000300023O00206E00030003000D2O00BB0003000200020026A5000300C20301001F0004C93O00C20301002E6700BF00C2030100BE0004C93O00C203012O003D0003000D3O0020EB0003000300B44O00045O00202O0004000400644O0005000E6O000600116O000700033O00202O0007000700524O00095O00202O0009000900644O0007000900024O000700076O000800096O000A00103O00202O000A000A00C04O0003000A000200062O000300C203013O0004C93O00C203012O003D000300013O001295000400C13O001295000500C24O0063000300054O001601035O0012950002003D3O0004C93O000900010004C93O00CF03010004C93O000400010004C93O00CF0301002E8800C30002000100C40004C93O000200010026EF3O0002000100010004C93O00020001001295000100014O00F2000200023O0012953O00023O0004C93O000200012O00C33O00017O005A3O00028O00026O00F03F03093O0002967DAE22976EBB3403043O00DC51E21C03073O0049735265616479026O001840026O00204003093O00537461727375726765030E3O0049735370652O6C496E52616E6765030F4O00C183E9F9D201D287BBE5D01F95DA03063O00A773B5E29B8A025O00509140025O00ADB14003083O00CF2DE8527D78D4E703073O00A68242873C1B11026O001440026O001C4003093O00436173744379636C6503083O004D2O6F6E6669726503113O004D2O6F6E666972654D6F7573656F766572030F3O004945C17B364D58CB353F53468E246003053O0050242AAE15025O000FB140025O0008AA40027O0040026O00084003053O00C3BFB7C0A003073O003994CDD6B4C83603083O0042752O66446F776E03073O00436174466F726D030E3O004973496E4D656C2O6552616E676503053O005772617468030C3O0005EF34207E52F222383643A903053O0016729D555403083O00F7DF12D65BFFBAC103073O00C8A4AB73A43D96025O00A0A640025O0021B240025O00908B40026O00354003083O005374617266697265030F3O00ADE0025785B7E606058CA9F84314D503053O00E3DE946325025O008AA240025O00B5B240030E3O00E94733C411EE4406DE00F64B3ED203053O0065A12252B6030A3O0049734361737461626C6503113O00CB0257E8D4E9871AE0086AEED2F08B3AFB03083O004E886D399EBB82E2030F3O00432O6F6C646F776E52656D61696E73026O003E4003113O001D30F7E73134FCC5363ACAE1372DF0E52D03043O00915E5F99025O0080564003113O00DEC21AC341BCF8F91CD07DA7F4DF1DC15D03063O00D79DAD74B52E030B3O004973417661696C61626C65030E3O0048656172744F6654686557696C64025O00BC9C40025O00C0914003173O003DB18AE0CE0ABB8DCDCE3DB1B4E5D339B0CBFDCD39F4D903053O00BA55D4EB92030B3O00EF8E19F032E756E48E04F303073O0038A2E1769E598E030B3O004D2O6F6E6B696E466F726D03123O00510ACFA129D1523AC6A030D51C0AD7A3628C03063O00B83C65A0CF42025O00CCAA40025O00608740025O00E0A140025O00D88B40025O0079B14003073O007D05397C47023203043O001A2E7057025O00FEA740025O00AEA44003073O0053756E6669726503103O0053756E666972654D6F7573656F766572030E3O00AA36A572B6AD40F4B634A734EEED03083O00D4D943CB142ODF2503113O009982A6C4B586ADE6B2889BC2B39FA1C6A903043O00B2DAEDC803063O0042752O66557003113O00436F6E766F6B655468655370697269747303093O004973496E52616E6765031E3O00B5BAE8C6B9BEE3EFA2BDE3EF2OA5EFC2BFA1F590BBBAE9DEBDBCE890E7ED03043O00B0D6D586025O00C88340025O00A099400094012O0012953O00014O00F2000100013O0026EF3O0002000100010004C93O00020001001295000100013O0026EF00010065000100020004C93O00650001001295000200013O000E2E0001005E000100020004C93O005E00012O003D00036O004C000400013O00122O000500033O00122O000600046O0004000600024O00030003000400202O0003000300054O00030002000200062O0003003100013O0004C93O003100012O003D000300023O0026A40003001D000100060004C93O001D00012O003D000300033O00066A00030031000100010004C93O003100012O003D000300023O0026A500030031000100070004C93O003100012O003D000300043O00061D0003003100013O0004C93O003100012O003D000300054O005800045O00202O0004000400084O000500063O00202O0005000500094O00075O00202O0007000700084O0005000700024O000500056O00030005000200062O0003003100013O0004C93O003100012O003D000300013O0012950004000A3O0012950005000B4O0063000300054O001601035O002E88000C005D0001000D0004C93O005D00012O003D00036O004C000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300054O00030002000200062O0003005D00013O0004C93O005D00012O003D000300023O0026A400030046000100100004C93O004600012O003D000300033O00066A0003005D000100010004C93O005D00012O003D000300023O0026A50003005D000100110004C93O005D00012O003D000300073O0020EB0003000300124O00045O00202O0004000400134O000500086O000600096O000700063O00202O0007000700094O00095O00202O0009000900134O0007000900024O000700076O000800096O000A000A3O00202O000A000A00144O0003000A000200062O0003005D00013O0004C93O005D00012O003D000300013O001295000400153O001295000500164O0063000300054O001601035O001295000200023O0026C000020062000100020004C93O00620001002E6700170008000100180004C93O00080001001295000100193O0004C93O006500010004C93O000800010026EF000100C00001001A0004C93O00C000012O003D00026O004C000300013O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O0002000200054O00020002000200062O0002009F00013O0004C93O009F00012O003D0002000B3O0020D300020002001D4O00045O00202O00040004001E4O00020004000200062O0002007E000100010004C93O007E00012O003D000200063O00206E00020002001F001295000400074O000500020004000200066A0002009F000100010004C93O009F00012O003D0002000C3O00061D0002008400013O0004C93O008400012O003D000200023O0026C00002008D000100020004C93O008D00012O003D0002000D3O00066A0002008D000100010004C93O008D00012O003D0002000E3O00061D0002009F00013O0004C93O009F00012O003D000200023O000EB60002009F000100020004C93O009F00012O003D000200054O005100035O00202O0003000300204O000400063O00202O0004000400094O00065O00202O0006000600204O0004000600024O000400046O000500016O00020005000200062O0002009F00013O0004C93O009F00012O003D000200013O001295000300213O001295000400224O0063000200044O001601026O003D00026O000F010300013O00122O000400233O00122O000500246O0003000500024O00020002000300202O0002000200054O00020002000200062O000200AB000100010004C93O00AB0001002E88002600932O0100250004C93O00932O01002E88002800932O0100270004C93O00932O012O003D000200054O005100035O00202O0003000300294O000400063O00202O0004000400094O00065O00202O0006000600294O0004000600024O000400046O000500016O00020005000200062O000200932O013O0004C93O00932O012O003D000200013O0012170103002A3O00122O0004002B6O000200046O00025O00044O00932O01002E67002C002D2O01002D0004C93O002D2O01000E2E0001002D2O0100010004C93O002D2O01001295000200013O0026EF000200262O0100010004C93O00262O012O003D00036O004C000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300304O00030002000200062O000300062O013O0004C93O00062O012O003D0003000F3O00061D000300062O013O0004C93O00062O012O003D00036O0005010400013O00122O000500313O00122O000600326O0004000600024O00030003000400202O0003000300334O00030002000200262O000300F2000100340004C93O00F200012O003D00036O0026010400013O00122O000500353O00122O000600366O0004000600024O00030003000400202O0003000300334O000300020002000E2O003700F2000100030004C93O00F200012O003D00036O000F010400013O00122O000500383O00122O000600396O0004000600024O00030003000400202O00030003003A4O00030002000200062O000300062O0100010004C93O00062O012O003D0003000B3O00201501030003001D4O00055O00202O00050005003B4O00030005000200062O000300062O013O0004C93O00062O012O003D000300054O003D00045O00202700040004003B2O00BB00030002000200066A0003003O0100010004C93O003O01002E88003C00062O01003D0004C93O00062O012O003D000300013O0012950004003E3O0012950005003F4O0063000300054O001601036O003D00036O004C000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O0003000300054O00030002000200062O000300252O013O0004C93O00252O012O003D0003000B3O00201501030003001D4O00055O00202O0005000500424O00030005000200062O000300252O013O0004C93O00252O012O003D000300043O00061D000300252O013O0004C93O00252O012O003D000300054O003D00045O0020270004000400422O00BB00030002000200061D000300252O013O0004C93O00252O012O003D000300013O001295000400433O001295000500444O0063000300054O001601035O001295000200023O002E430045009FFF2O00450004C93O00C50001000E2E000200C5000100020004C93O00C50001001295000100023O0004C93O002D2O010004C93O00C50001002E6700460005000100470004C93O000500010026EF00010005000100190004C93O00050001001295000200013O0026EF0002008B2O0100010004C93O008B2O01001295000300013O002E88004800842O0100490004C93O00842O010026EF000300842O0100010004C93O00842O012O003D00046O000F010500013O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500202O0004000400054O00040002000200062O000400452O0100010004C93O00452O01002E67004C005C2O01004D0004C93O005C2O012O003D000400073O0020EB0004000400124O00055O00202O00050005004E4O000600086O000700106O000800063O00202O0008000800094O000A5O00202O000A000A004E4O0008000A00024O000800086O0009000A6O000B000A3O00202O000B000B004F4O0004000B000200062O0004005C2O013O0004C93O005C2O012O003D000400013O001295000500503O001295000600514O0063000400064O001601046O003D000400113O00061D000400832O013O0004C93O00832O012O003D0004000F3O00061D000400832O013O0004C93O00832O012O003D00046O004C000500013O00122O000600523O00122O000700536O0005000700024O00040004000500202O0004000400304O00040002000200062O000400832O013O0004C93O00832O012O003D0004000B3O0020150104000400544O00065O00202O0006000600424O00040006000200062O000400832O013O0004C93O00832O012O003D000400054O003100055O00202O0005000500554O000600063O00202O00060006005600122O000800346O0006000800024O000600066O00040006000200062O000400832O013O0004C93O00832O012O003D000400013O001295000500573O001295000600584O0063000400064O001601045O001295000300023O0026C0000300882O0100020004C93O00882O01002E88005A00352O0100590004C93O00352O01001295000200023O0004C93O008B2O010004C93O00352O010026EF000200322O0100020004C93O00322O010012950001001A3O0004C93O000500010004C93O00322O010004C93O000500010004C93O00932O010004C93O000200012O00C33O00017O006F3O00028O00025O0068AD40025O00C8A240026O00184003083O0073CCFAEB2AC94CC603063O00A03EA395854C03073O004973526561647903083O0042752O66446F776E03073O00436174466F726D030E3O004973496E4D656C2O6552616E6765026O00204003083O004D2O6F6E66697265030E3O0049735370652O6C496E52616E6765025O00C6AD40025O003EB04003103O00DBAF0221C5DFB2086FCED7A9036F908403053O00A3B6C06D4F025O00388740025O0080474003043O00502O6F6C03133O00576169742F502O6F6C205265736F7572636573025O001EAC40025O008C9040027O0040025O006C9540025O0096A3402O033O00015B4203053O0099532O3296030B3O004973417661696C61626C65025O002EAC40025O00D0A340026O00F03F025O00989140025O00B6AC4003043O006F77781903073O002D3D16137C13CB026O000840025O0020AA40025O003EAC40030C3O0053686F756C6452657475726E03113O00496E74652O72757074576974685374756E03123O00496E636170616369746174696E67526F6172025O00A8B240025O00406A4003063O0042752O665570030B3O00436F6D626F506F696E7473025O006AA440025O0080A54003043O004D61696D025O00BEB140025O008EA040026O00144003093O00FD6AB31196DB6CB50603053O00E5AE1ED26303093O0053746172737572676503113O0008F98743FE282B1CE8C65CEC34375BBFDE03073O00597B8DE6318D5D03083O00C065F71E1643E17403063O002A9311966C7003083O005374617266697265030F3O001CB22C6D2OE11DA36D70F0E44FF77B03063O00886FC64D1F8703053O00351BA642B503083O00C96269C736DD8477025O003C9040025O0020754003053O005772617468030D3O00AE1E82350A75A1B8058D61516503073O00CCD96CE341625503063O00F51A1FF4117803073O00D9A1726D956210025O0023B040025O0002B240025O0021B040026O008540025O00D88F40025O0014AB40025O00207240025O00B88A40030D3O003324396CA87D04250B6BBD661F03063O00147240581CDC030A3O0049734361737461626C65030D3O004164617074697665537761726D03133O003005D3A4ECD9AB343EC1A3F9C2B0710CD3BDF603073O00DD5161B2D498B0026O001040030A3O004D696768747942617368025O00F9B140025O005EB140030B3O00E0E812F511C4E93BF408C003053O007AAD877D9B025O00188F40025O0066A040025O00088E40025O004CAF4003073O00B7D40EBF3623CD03073O00A8E4A160D95F5103113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66025O000CA540025O00F6B24003073O0053756E66697265030F3O00C8C4205A2645DE91235D26599B837A03063O0037BBB14E3C4F03084O00C150E540C6922803073O00E04DAE3F8B26AF030E3O004D2O6F6E66697265446562752O66025O004EB040025O002AAD4003103O00894E572082484A2BC44C59278A010A7803043O004EE4213800F7012O0012953O00014O00F2000100013O002E880003003B000100020004C93O003B00010026EF3O003B000100040004C93O003B00012O003D00026O004C000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002003000013O0004C93O003000012O003D000200023O0020D30002000200084O00045O00202O0004000400094O00020004000200062O0002001D000100010004C93O001D00012O003D000200033O00206E00020002000A0012950004000B4O000500020004000200066A00020030000100010004C93O003000012O003D000200044O002800035O00202O00030003000C4O000400033O00202O00040004000D4O00065O00202O00060006000C4O0004000600024O000400046O00020004000200062O0002002B000100010004C93O002B0001002E67000F00300001000E0004C93O003000012O003D000200013O001295000300103O001295000400114O0063000200044O001601025O002E88001300F62O0100120004C93O00F62O012O003D000200044O003D00035O0020270003000300142O00BB00020002000200061D000200F62O013O0004C93O00F62O01001295000200154O0092000200023O0004C93O00F62O01002E6700170075000100160004C93O007500010026EF3O0075000100180004C93O00750001001295000200013O002E670019005B0001001A0004C93O005B00010026EF0002005B000100010004C93O005B0001001295000100014O002201038O000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O00030003001D4O00030002000200062O00030051000100010004C93O00510001002E43001E000B0001001F0004C93O005A00012O003D000300054O008B000400013O00122O000500206O0003000500024O000400066O000500013O00122O000600206O0004000600024O000100030004001295000200203O000E2E00200040000100020004C93O00400001002E8800210072000100220004C93O007200012O003D00036O004C000400013O00122O000500233O00122O000600246O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003007200013O0004C93O007200012O003D000300054O008B000400013O00122O000500206O0003000500024O000400066O000500013O00122O000600206O0004000600024O0001000300040012953O00253O0004C93O007500010004C93O004000010026C03O0079000100010004C93O00790001002E67002700AD000100260004C93O00AD00012O003D000200073O0020680002000200294O00035O00202O00030003002A00122O0004000B6O00020004000200122O000200283O00122O000200283O00062O00020085000100010004C93O00850001002E67002B00870001002C0004C93O0087000100121E000200284O0092000200024O003D000200023O00201501020002002D4O00045O00202O0004000400094O00020004000200062O0002009300013O0004C93O009300012O003D000200023O00206E00020002002E2O00BB000200020002000E0800010095000100020004C93O00950001002E88003000AC0001002F0004C93O00AC0001001295000200014O00F2000300033O0026EF00020097000100010004C93O00970001001295000300013O000E2E0001009A000100030004C93O009A00012O003D000400073O0020120104000400294O00055O00202O00050005003100122O0006000B6O00040006000200122O000400283O00122O000400283O00062O000400AC00013O0004C93O00AC000100121E000400284O0092000400023O0004C93O00AC00010004C93O009A00010004C93O00AC00010004C93O009700010012953O00203O002E880033001E2O0100320004C93O001E2O010026EF3O001E2O0100340004C93O001E2O012O003D00026O004C000300013O00122O000400353O00122O000500366O0003000500024O00020002000300202O0002000200074O00020002000200062O000200D300013O0004C93O00D300012O003D000200023O0020150102000200084O00045O00202O0004000400094O00020004000200062O000200D300013O0004C93O00D300012O003D000200044O005800035O00202O0003000300374O000400033O00202O00040004000D4O00065O00202O0006000600374O0004000600024O000400046O00020004000200062O000200D300013O0004C93O00D300012O003D000200013O001295000300383O001295000400394O0063000200044O001601026O003D00026O004C000300013O00122O0004003A3O00122O0005003B6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200F200013O0004C93O00F200012O003D000200083O000EB6001800F2000100020004C93O00F200012O003D000200044O005100035O00202O00030003003C4O000400033O00202O00040004000D4O00065O00202O00060006003C4O0004000600024O000400046O000500016O00020005000200062O000200F200013O0004C93O00F200012O003D000200013O0012950003003D3O0012950004003E4O0063000200044O001601026O003D00026O004C000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200074O00020002000200062O000200092O013O0004C93O00092O012O003D000200023O0020D30002000200084O00045O00202O0004000400094O00020004000200062O0002000B2O0100010004C93O000B2O012O003D000200033O00206E00020002000A0012950004000B4O000500020004000200061D0002000B2O013O0004C93O000B2O01002E4300410014000100420004C93O001D2O012O003D000200044O005100035O00202O0003000300434O000400033O00202O00040004000D4O00065O00202O0006000600434O0004000600024O000400046O000500016O00020005000200062O0002001D2O013O0004C93O001D2O012O003D000200013O001295000300443O001295000400454O0063000200044O001601025O0012953O00043O0026EF3O006C2O0100250004C93O006C2O012O003D00026O000F010300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O00020002001D4O00020002000200062O0002002C2O0100010004C93O002C2O01002E880049002D2O0100480004C93O002D2O01002093000100010020000E780018004E2O0100010004C93O004E2O012O003D000200033O00206E00020002000A0012950004000B4O000500020004000200061D0002004E2O013O0004C93O004E2O01001295000200014O00F2000300043O002E67004B003E2O01004A0004C93O003E2O010026EF0002003E2O0100010004C93O003E2O01001295000300014O00F2000400043O001295000200203O002E88004C00372O01004D0004C93O00372O010026EF000200372O0100200004C93O00372O010026EF000300422O0100010004C93O00422O012O003D000500094O007A0005000100022O0047000400053O00061D0004004E2O013O0004C93O004E2O012O0092000400023O0004C93O004E2O010004C93O00422O010004C93O004E2O010004C93O00372O01002E67004E006B2O01004F0004C93O006B2O012O003D00026O004C000300013O00122O000400503O00122O000500516O0003000500024O00020002000300202O0002000200524O00020002000200062O0002006B2O013O0004C93O006B2O012O003D000200044O005800035O00202O0003000300534O000400033O00202O00040004000D4O00065O00202O0006000600534O0004000600024O000400046O00020004000200062O0002006B2O013O0004C93O006B2O012O003D000200013O001295000300543O001295000400554O0063000200044O001601025O0012953O00563O000E2E002000872O013O0004C93O00872O01001295000200013O000E2E002000752O0100020004C93O00752O012O003D0003000A4O00A90003000100010012953O00183O0004C93O00872O010026EF0002006F2O0100010004C93O006F2O012O003D000300073O0020EC0003000300294O00045O00202O00040004005700122O0005000B6O00030005000200122O000300283O002E2O005900852O0100580004C93O00852O0100121E000300283O00061D000300852O013O0004C93O00852O0100121E000300284O0092000300023O001295000200203O0004C93O006F2O010026EF3O0002000100560004C93O000200012O003D00026O004C000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O00020002001D4O00020002000200062O000200AC2O013O0004C93O00AC2O01001295000200014O00F2000300043O0026EF000200A42O0100200004C93O00A42O010026EF000300972O0100010004C93O00972O012O003D0005000B4O007A0005000100022O0047000400053O00066A000400A02O0100010004C93O00A02O01002E67005D00AC2O01005C0004C93O00AC2O012O0092000400023O0004C93O00AC2O010004C93O00972O010004C93O00AC2O01002E88005E00952O01005F0004C93O00952O010026EF000200952O0100010004C93O00952O01001295000300014O00F2000400043O001295000200203O0004C93O00952O012O003D00026O004C000300013O00122O000400603O00122O000500616O0003000500024O00020002000300202O0002000200074O00020002000200062O000200D02O013O0004C93O00D02O012O003D000200033O0020150102000200624O00045O00202O0004000400634O00020004000200062O000200D02O013O0004C93O00D02O01002E88006400D02O0100650004C93O00D02O012O003D000200044O005800035O00202O0003000300664O000400033O00202O00040004000D4O00065O00202O0006000600664O0004000600024O000400046O00020004000200062O000200D02O013O0004C93O00D02O012O003D000200013O001295000300673O001295000400684O0063000200044O001601026O003D00026O004C000300013O00122O000400693O00122O0005006A6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200F42O013O0004C93O00F42O012O003D000200033O0020150102000200624O00045O00202O00040004006B4O00020004000200062O000200F42O013O0004C93O00F42O012O003D000200044O002800035O00202O00030003000C4O000400033O00202O00040004000D4O00065O00202O00060006000C4O0004000600024O000400046O00020004000200062O000200EF2O0100010004C93O00EF2O01002E67006C00F42O01006D0004C93O00F42O012O003D000200013O0012950003006E3O0012950004006F4O0063000200044O001601025O0012953O00343O0004C93O000200012O00C33O00017O00093O0003173O0044697370652O6C61626C65467269656E646C79556E6974030B3O001A2714D5E7313523D5E73103053O0095544660A003073O0049735265616479025O0084A440025O0040844003103O004E61747572657343757265466F63757303153O00360719F82A031ED23B131FE8780204FE280301AD6A03043O008D58666D00204O003D7O00061D3O001200013O0004C93O001200012O003D3O00013O0020275O00012O007A3O0001000200061D3O001200013O0004C93O001200012O003D3O00024O000F2O0100033O00122O000200023O00122O000300036O0001000300028O000100206O00046O0002000200064O0014000100010004C93O00140001002E670005001F000100060004C93O001F00012O003D3O00044O003D000100053O0020270001000100072O00BB3O0002000200061D3O001F00013O0004C93O001F00012O003D3O00033O001295000100083O001295000200094O00633O00024O0016017O00C33O00017O00283O00028O00026O00F03F025O00EC9840025O003CA040030B3O00DBEA59DA315EE0FB57D82003063O0036938F38B64503073O004973526561647903103O004865616C746850657263656E74616765025O008C9940025O00688440030B3O004865616C746873746F6E6503173O00DE84FE45CBDE92EB46D1D3C1FB4CD9D38FEC40C9D3C1AC03053O00BFB6E19F29025O0034AD4003193O0019172E478E94CA221C2F15A382C3271B2652CBB7CD3F1B275B03073O00A24B724835EBE7025O00F6AE40025O0086B24003173O00BE3942F0561184354AE57B078D304DEC543283284DED5D03063O0062EC5C24823303173O0052656672657368696E674865616C696E67506F74696F6E03253O00B61C0AA840BBBD39AA1E4CB240A9B939AA1E4CAA4A2OBC3FAA5908BF43ADBB23AD0F09FA1103083O0050C4796CDA25C8D5025O00D0AF40025O0057B24003083O009152D87B09365CCF03083O00A1D333AA107A5D35025O0058A140025O0092A64003083O004261726B736B696E025O0032B340025O002FB14003143O00F9AFA023E8A5BB26BBAAB72EFEA0A121EDABF27A03043O00489BCED203073O00747F5A0B24477603053O0053261A346E025O0098AC4003073O0052656E6577616C03133O004A1229434F162B065C12214356042E505D577503043O002638774700A73O0012953O00014O00F2000100013O000E2E0001000200013O0004C93O00020001001295000100013O000E2E00020058000100010004C93O00580001002E670003002B000100040004C93O002B00012O003D00026O004C000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002B00013O0004C93O002B00012O003D000200023O00061D0002002B00013O0004C93O002B00012O003D000200033O00206E0002000200082O00BB0002000200022O003D000300043O0006AD0002002B000100030004C93O002B0001002E88000A002B000100090004C93O002B00012O003D000200054O0060000300063O00202O00030003000B4O000400056O000600016O00020006000200062O0002002B00013O0004C93O002B00012O003D000200013O0012950003000C3O0012950004000D4O0063000200044O001601025O002E43000E007B0001000E0004C93O00A600012O003D000200073O00061D000200A600013O0004C93O00A600012O003D000200033O00206E0002000200082O00BB0002000200022O003D000300083O0006AD000200A6000100030004C93O00A600012O003D000200094O0017000300013O00122O0004000F3O00122O000500106O00030005000200062O000200A6000100030004C93O00A60001002E8800120040000100110004C93O004000010004C93O00A600012O003D00026O004C000300013O00122O000400133O00122O000500146O0003000500024O00020002000300202O0002000200074O00020002000200062O000200A600013O0004C93O00A600012O003D000200054O0060000300063O00202O0003000300154O000400056O000600016O00020006000200062O000200A600013O0004C93O00A600012O003D000200013O001217010300163O00122O000400176O000200046O00025O00044O00A600010026C00001005C000100010004C93O005C0001002E8800190005000100180004C93O000500012O003D000200033O00206E0002000200082O00BB0002000200022O003D0003000A3O0006AD0002006F000100030004C93O006F00012O003D0002000B3O00061D0002006F00013O0004C93O006F00012O003D0002000C4O000F010300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200074O00020002000200062O00020071000100010004C93O00710001002E88001D00800001001C0004C93O008000012O003D000200054O00070003000C3O00202O00030003001E4O000400056O000600016O00020006000200062O0002007B000100010004C93O007B0001002E88001F0080000100200004C93O008000012O003D000200013O001295000300213O001295000400224O0063000200044O001601026O003D000200033O00206E0002000200082O00BB0002000200022O003D0003000D3O0006AD000200A2000100030004C93O00A200012O003D0002000E3O00061D000200A200013O0004C93O00A200012O003D0002000C4O004C000300013O00122O000400233O00122O000500246O0003000500024O00020002000300202O0002000200074O00020002000200062O000200A200013O0004C93O00A20001002E430025000F000100250004C93O00A200012O003D000200054O00600003000C3O00202O0003000300264O000400056O000600016O00020006000200062O000200A200013O0004C93O00A200012O003D000200013O001295000300273O001295000400284O0063000200044O001601025O001295000100023O0004C93O000500010004C93O00A600010004C93O000200012O00C33O00017O00383O00028O00026O00F03F025O00C6A640025O0080684003093O0063B6FC25502355AFF103063O004E30C195432403073O0049735265616479030E3O0053776966746D656E64466F637573025O001EB240025O007CAE40030E3O002309891E553D1B8E1C01221F8D0803053O0021507EE07803063O0042752O66557003133O00536F756C4F66546865466F7265737442752O66030A3O00DBA10FC05BFEA714D05403053O003C8CC863A4030F3O0057696C6467726F777468466F637573025O00309140025O00309440030F3O0090FD0822A595FB1332AAC7E6052BB203053O00C2E7946446027O0040025O00188140025O006EAB40025O00A07340025O00A8A040025O00208D4003063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O00444003093O0033640B795F038F0E7703073O00EA6013621F2B6E03083O0042752O66446F776E03113O0052656A7576656E6174696F6E466F637573025O00F6A640025O000EB14003113O00141A58D2BA7785070B5BC8A2329907124203073O00EB667F32A7CC1203093O006F42CFA6E4DE4758C403063O00A8262CA1C39603093O00492O6E657276617465025O0002AF40025O0092AC40030F3O00492O6E657276617465506C61796572025O008C9540025O00D89640030E3O0089F28C7322FEB70285BC90773DF803083O0076E09CE2165088D6030F3O0042752O665265667265736861626C65030C3O0052656A7576656E6174696F6E025O00FEB140025O002OAE4003153O0052656A7576656E6174696F6E4D6F7573656F76657203173O0050EB539554EB578156E7568E7DED40834EEB199243E34903043O00E0228E3900E63O0012953O00014O00F2000100013O0026EF3O0002000100010004C93O00020001001295000100013O0026EF0001004E000100020004C93O004E0001001295000200013O0026EF00020049000100010004C93O00490001002E6700040028000100030004C93O002800012O003D00036O004C000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003002800013O0004C93O002800012O003D000300024O003D000400034O00BB00030002000200061D0003002800013O0004C93O002800012O003D000300044O003D000400053O0020270004000400082O00BB00030002000200066A00030023000100010004C93O00230001002E88000900280001000A0004C93O002800012O003D000300013O0012950004000B3O0012950005000C4O0063000300054O001601036O003D000300063O00201501030003000D4O00055O00202O00050005000E4O00030005000200062O0003004800013O0004C93O004800012O003D00036O004C000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300074O00030002000200062O0003004800013O0004C93O004800012O003D000300044O0007000400053O00202O0004000400114O000500056O000600016O00030006000200062O00030043000100010004C93O00430001002E6700130048000100120004C93O004800012O003D000300013O001295000400143O001295000500154O0063000300054O001601035O001295000200023O0026EF00020008000100020004C93O00080001001295000100163O0004C93O004E00010004C93O000800010026EF00010096000100010004C93O00960001001295000200013O000E2200020055000100020004C93O00550001002E8800180057000100170004C93O00570001001295000100023O0004C93O009600010026C00002005B000100010004C93O005B0001002E88001A0051000100190004C93O00510001002E43001B00160001001B0004C93O007100012O003D000300033O00061D0003007000013O0004C93O007000012O003D000300033O00206E00030003001C2O00BB00030002000200061D0003007000013O0004C93O007000012O003D000300033O00206E00030003001D2O00BB00030002000200066A00030070000100010004C93O007000012O003D000300033O00206E00030003001E0012950005001F4O000500030005000200066A00030071000100010004C93O007100012O00C33O00014O003D00036O004C000400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O0003000300074O00030002000200062O0003009400013O0004C93O009400012O003D000300024O003D000400034O00BB00030002000200066A00030094000100010004C93O009400012O003D000300063O0020150103000300224O00055O00202O00050005000E4O00030005000200062O0003009400013O0004C93O009400012O003D000300044O003D000400053O0020270004000400232O00BB00030002000200066A0003008F000100010004C93O008F0001002E4300240007000100250004C93O009400012O003D000300013O001295000400263O001295000500274O0063000300054O001601035O001295000200023O0004C93O005100010026EF00010005000100160004C93O000500012O003D00026O004C000300013O00122O000400283O00122O000500296O0003000500024O00020002000300202O0002000200074O00020002000200062O000200A900013O0004C93O00A900012O003D000200063O0020D30002000200224O00045O00202O00040004002A4O00020004000200062O000200AB000100010004C93O00AB0001002E67002B00BA0001002C0004C93O00BA00012O003D000200044O0007000300053O00202O00030003002D4O000400056O000600016O00020006000200062O000200B5000100010004C93O00B50001002E43002E00070001002F0004C93O00BA00012O003D000200013O001295000300303O001295000400314O0063000200044O001601026O003D000200063O00201501020002000D4O00045O00202O00040004002A4O00020004000200062O000200D400013O0004C93O00D400012O003D000200074O007A000200010002000EB6000100D4000100020004C93O00D400012O003D000200083O00061D000200D400013O0004C93O00D400012O003D000200083O00206E00020002001C2O00BB00020002000200061D000200D400013O0004C93O00D400012O003D000200083O0020D30002000200324O00045O00202O0004000400334O00020004000200062O000200D6000100010004C93O00D60001002E67003400E5000100350004C93O00E500012O003D000200044O003D000300053O0020270003000300362O00BB00020002000200061D000200E500013O0004C93O00E500012O003D000200013O001217010300373O00122O000400386O000200046O00025O00044O00E500010004C93O000500010004C93O00E500010004C93O000200012O00C33O00017O0002012O00028O00025O00A89840025O00A08F40025O00BEA240025O0074AA4003063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O004440025O0028AB40025O005DB240025O0016B140025O0022AD40026O00F03F025O004AB340025O00B49440025O00E4A640025O002EB040025O00388240025O00A06040026O007B40027O0040025O00C09640025O0080B040030F3O00412O66656374696E67436F6D626174030B3O000DBA4D16D1F70735A1580103073O006E59C82C78A08203073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030B3O005472616E7175696C69747903133O00BFD14A48525F3241A2D752064B4F3A41A2CD4C03083O002DCBA32B26232A5B030B3O00E697DD2D96BC5DDE8CC83A03073O0034B2E5BC43E7C903063O0042752O665570030F3O00496E6361726E6174696F6E42752O66025O00889A40025O00A0A24003183O003553510AE6492A2D48441DC848312444100CF25D2F284F5703073O004341213064973C025O002EA540025O00C8AD40030E3O00D4112606877F0D77E10720118C4B03083O001693634970E23878030E3O009F67EDE3889F60E3E789B174ECE603053O00EDD815829503113O0054696D6553696E63654C61737443617374026O00144003133O0047726F7665477561726469616E73466F637573025O00508740025O0046A24003173O00855C5049B5F659974F4D5BB9C850910E575AB1C5578C4903073O003EE22E2O3FD0A9025O0074A740025O00F08B4003083O00C3155A960D043C5603083O003E857935E37F6D4F03083O0042752O66446F776E03083O00466C6F7572697368026O00104003103O0016183DE0C4A7B118543AF0D7A2AB1E1303073O00C270745295B6CE025O00809540025O00209040025O00F6A24003063O0004BC22FF31A203043O008654D043025O0046AB40025O0082AA40030D3O0036AA80501CBE834F10A9885F1603043O003C73CCE6026O002E4003133O00452O666C6F72657363656E6365506C61796572025O005AAE40025O00D8B040031C3O00E23CED7CE828EE63E43FE573E27AE375E636E27EE07AFB7CE623EE6203043O0010875A8B03063O0077611420414603073O0018341466532E34030D3O00E129272800D62A32270ACA2C2403053O006FA44F414403133O00452O666C6F72657363656E6365437572736F72025O002OA040025O00689B40031C3O00C3DF85D221F8C3CA80DB20E9C3998BDB2FE6CFD7849E2DFFD4CA8CCC03063O008AA6B9E3BE4E030C3O00E87BCB315B3114CA60CC385C03073O0079AB14A5573243025O00E8B140025O0090A940030D3O00E33EBF3AB610C32BBA33B701C303063O0062A658D956D9030D3O00452O666C6F72657363656E636503223O00F3F07F0D89CEF3E57A0488DFF3B6710487D0FFF87E4185D3F8F070138BDDE2FF760F03063O00BC2O961961E6030A3O00ED8053060BFFD59E4B0A03063O008DBAE93F626C03093O00C2FD25B031FCEF22B203053O0045918A4CD6030B3O004973417661696C61626C6503093O0043D8808FAB1B75C18D03063O007610AF2OE9DF030F3O0057696C6467726F777468466F63757303123O009C8D39BFE999729C903DFBE68E7C878D3BBC03073O001DEBE455DB8EEB025O004C9040025O00CCAB4003083O000FD1BDCF7859335A03083O00325DB4DABD172E47030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030D3O00526567726F777468466F63757303103O00CCA15C5E4BCB5CD6E4534945D041D0A303073O0028BEC43B2C24BC03093O00492O6E657276617465030F3O0042752O665265667265736861626C65030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572031A3O002E40D6A1EC78033D51D5BBF4420E2546D0B1BA75083D49D5BAFD03073O006D5C25BCD49A1D025O00C05140030C3O0036EAAED6275F0AEEB0CA3E5403063O003A648FC4A35103113O0052656A7576656E6174696F6E466F63757303143O00084729B6294CEB0F0E4B2CAD7F41E00F164B2DA403083O006E7A2243C35F2985025O00D2A54003083O0047B45C58D962A55303053O00B615D13B2A03103O00A552C20F2EA9A35F851524BFBB5ECB1A03063O00DED737A57D4103113O00FCE8A0CEFCD4E29AD0F6ECF7A7CAFACBF403053O0093BF87CEB8025O00888140025O00788C4003113O00436F6E766F6B6554686553706972697473025O00288540025O002FB040031B3O008727A82OD758B7BB3CAEC4E740A28D3AAFD5CB13BA8129AAC8D65403073O00D2E448C6A1B833025O0046B140025O00E8A140030C3O00154CFD1161C73947C41161CA03063O00AE562993701303113O0043656E6172696F6E57617264466F637573025O00F8A34003153O005805830A37061EA564178C19214F19AE5A0C84052203083O00CB3B60ED6B456F7103103O004E61747572657353776966746E652O7303083O001613ABF33EE7C32C03073O00B74476CC815190031A3O001CA877F604951AA54FF71C8B08B97EE118914EA575E5078B00AA03063O00E26ECD10846B03103O00C5C2F4CC53EED0D3CE48EDD7EEDC52F803053O00218BA380B9025O0044B340025O00308C4003193O002O5910CB455D17E1444F0DD8435601CD44180CDB56540DD05003043O00BE373864026O000840025O00707F40025O00449640030D3O00556E697447726F7570526F6C6503043O00D1F8261803053O004685B96853031A3O00467269656E646C79556E6974735769746842752O66436F756E7403093O004C696665626C2O6F6D03073O00436174466F726D03093O00284C422FCB084A4B2703053O00A96425244A025O0007B340030E3O004C696665626C2O6F6D466F63757303113O000C8EA455028BAD5F0DC7AA55018BAB5E0703043O003060E7C203043O00FC7B200603083O00E3A83A6E4D79B8CF030B3O004E32BB45A3DC63AA6C28B703083O00C51B5CDF20D1BB11030A3O004973536F6C6F4D6F646503093O002F56C5FE0153CCF40E03043O009B633FA303113O008ED8A788BB888DDEACCDB18183DDA883BE03063O00E4E2B1C1EDD9025O00A6A340025O00D0A14003063O0077A125111DE603073O009336CF5C7E7383025O0080A74003083O0024233A732F7F1F3A03063O001E6D51551D6D025O00707240025O00388840030D3O0049726F6E4261726B466F63757303113O00F6635BB809DCFDED7A14BE33DFF0F67F5303073O009C9F1134D656BE03093O009AEEB3B7EEC0B3B0B703043O00DCCE8FDD025O00DCB240025O0096A74003083O00AF6F2219FACDC08D03073O00B2E61D4D77B8AC03073O00436F2O6D6F6E7303043O00C19F243003063O009895DE6A7B17025O001AA240025O00CCA04003113O00D434F94D8ADF27E448F5D523F74FBCD32103053O00D5BD469623030D3O007B547A030F547A0C0F6671044903043O00682F351403083O008A5E8E129E0EB14703063O006FC32CE17CDC03043O00EC672E5803063O00CBB8266013CB03063O001156586DEB0B03053O00AE59131921025O0098A840025O0018874003113O0026005D40C8850A3D191246F28607261C5503073O006B4F72322E97E7025O00E0B140025O003AB240030D3O0018A2B4399E30A1C50AB1B43B8703083O00A059C6D549EA59D703123O004164617074697665537761726D466F637573025O0006AE40025O00ACA74003163O004975B5EED14167B1C1D65F70A6F3854074B5F2CC467603053O00A52811D49E025O00B4A340025O00C09840030B3O005573655472696E6B657473025O005AA940030C3O00F0A6D1C861F44E38D7A0CCD103083O006EBEC7A5BD13913D030C3O004E617475726573566967696C025O006AB140025O0014A74003153O00D4EA63FD99C2C9D461E18CCED6AB7FED8ACBD3E57003063O00A7BA8B1788EB025O0040A040025O00307D40026O004D40025O0050834003093O0029A2810B0EB88D031E03043O006D7AD5E803133O00536F756C4F66546865466F7265737442752O66030E3O0053776966746D656E64466F637573025O00D88B40025O008EAC4003113O00FDE0AB362OFAA73EEAB7AA35EFFBAB3EE903043O00508E97C2030A3O0034CF7B4804D4785B17CE03043O002C63A617025O00BFB040025O004CAC4003173O006BFE253234B673E03D3E0CB773E32F763BA17DFB20383403063O00C41C9749565300F0042O0012953O00014O00F2000100013O0026C03O0006000100010004C93O00060001002E6700020002000100030004C93O00020001001295000100013O0026C00001000B000100010004C93O000B0001002E8800050007000100040004C93O000700012O003D00025O00061D0002001E00013O0004C93O001E00012O003D00025O00206E0002000200062O00BB00020002000200061D0002001E00013O0004C93O001E00012O003D00025O00206E0002000200072O00BB00020002000200066A0002001E000100010004C93O001E00012O003D00025O00206E000200020008001295000400094O000500020004000200066A0002001F000100010004C93O001F00012O00C33O00014O003D000200013O00066A00020024000100010004C93O00240001002E88000B00EF0401000A0004C93O00EF0401001295000200014O00F2000300043O000E220001002A000100020004C93O002A0001002E67000C002D0001000D0004C93O002D0001001295000300014O00F2000400043O0012950002000E3O0026EF000200260001000E0004C93O002600010026C000030033000100010004C93O00330001002E67000F002F000100100004C93O002F0001001295000400013O000E22000E0038000100040004C93O00380001002E880012000E2O0100110004C93O000E2O01001295000500014O00F2000600063O002E670014003A000100130004C93O003A00010026EF0005003A000100010004C93O003A0001001295000600013O002E4300150006000100150004C93O004500010026EF00060045000100160004C93O00450001001295000400163O0004C93O000E2O01002E670017009F000100180004C93O009F00010026EF0006009F0001000E0004C93O009F00012O003D000700023O00206E0007000700192O00BB00070002000200061D0007006F00013O0004C93O006F00012O003D000700033O00061D0007006F00013O0004C93O006F00012O003D000700044O004C000800053O00122O0009001A3O00122O000A001B6O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007006F00013O0004C93O006F00012O003D000700063O0020B500070007001D4O000800076O000900086O00070009000200062O0007006F00013O0004C93O006F00012O003D000700094O0060000800043O00202O00080008001E4O000900096O000A00016O0007000A000200062O0007006F00013O0004C93O006F00012O003D000700053O0012950008001F3O001295000900204O0063000700094O001601076O003D000700023O00206E0007000700192O00BB00070002000200061D0007009E00013O0004C93O009E00012O003D000700033O00061D0007009E00013O0004C93O009E00012O003D000700044O004C000800053O00122O000900213O00122O000A00226O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007009E00013O0004C93O009E00012O003D000700023O0020150107000700234O000900043O00202O0009000900244O00070009000200062O0007009E00013O0004C93O009E00012O003D000700063O0020B500070007001D4O0008000A6O0009000B6O00070009000200062O0007009E00013O0004C93O009E00012O003D000700094O0007000800043O00202O00080008001E4O000900096O000A00016O0007000A000200062O00070099000100010004C93O00990001002E670026009E000100250004C93O009E00012O003D000700053O001295000800273O001295000900284O0063000700094O001601075O001295000600163O0026EF0006003F000100010004C93O003F0001001295000700013O0026EF000700A60001000E0004C93O00A600010012950006000E3O0004C93O003F0001002E88002900A20001002A0004C93O00A200010026EF000700A2000100010004C93O00A200012O003D0008000C3O00061D000800D600013O0004C93O00D600012O003D000800044O004C000900053O00122O000A002B3O00122O000B002C6O0009000B00024O00080008000900202O00080008001C4O00080002000200062O000800D600013O0004C93O00D600012O003D000800044O00B2000900053O00122O000A002D3O00122O000B002E6O0009000B00024O00080008000900202O00080008002F4O000800020002000E2O003000D6000100080004C93O00D600012O003D000800063O0020B500080008001D4O0009000D6O000A000E6O0008000A000200062O000800D600013O0004C93O00D600012O003D000800094O003A0009000F3O00202O0009000900314O000A000B6O0008000B000200062O000800D1000100010004C93O00D10001002E67003300D6000100320004C93O00D600012O003D000800053O001295000900343O001295000A00354O00630008000A4O001601085O002E67003700092O0100360004C93O00092O012O003D000800023O00206E0008000800192O00BB00080002000200061D000800092O013O0004C93O00092O012O003D000800033O00061D000800092O013O0004C93O00092O012O003D000800044O004C000900053O00122O000A00383O00122O000B00396O0009000B00024O00080008000900202O00080008001C4O00080002000200062O000800092O013O0004C93O00092O012O003D000800023O00201501080008003A4O000A00043O00202O000A000A003B4O0008000A000200062O000800092O013O0004C93O00092O012O003D000800104O007A000800010002000EB6003C00092O0100080004C93O00092O012O003D000800063O0020B500080008001D4O000900116O000A00126O0008000A000200062O000800092O013O0004C93O00092O012O003D000800094O0060000900043O00202O00090009003B4O000A000B6O000C00016O0008000C000200062O000800092O013O0004C93O00092O012O003D000800053O0012950009003D3O001295000A003E4O00630008000A4O001601085O0012950007000E3O0004C93O00A200010004C93O003F00010004C93O000E2O010004C93O003A00010026C0000400122O01003C0004C93O00122O01002E67003F00FE2O0100400004C93O00FE2O01002E4300410028000100410004C93O003A2O012O003D000500134O0017000600053O00122O000700423O00122O000800436O00060008000200062O0005003A2O0100060004C93O003A2O01002E88004500812O0100440004C93O00812O012O003D000500023O00206E0005000500192O00BB00050002000200061D000500812O013O0004C93O00812O012O003D000500044O00B2000600053O00122O000700463O00122O000800476O0006000800024O00050005000600202O00050005002F4O000500020002000E2O004800812O0100050004C93O00812O012O003D000500094O003D0006000F3O0020270006000600492O00BB00050002000200066A000500342O0100010004C93O00342O01002E88004B00812O01004A0004C93O00812O012O003D000500053O0012170106004C3O00122O0007004D6O000500076O00055O00044O00812O012O003D000500134O0017000600053O00122O0007004E3O00122O0008004F6O00060008000200062O0005005E2O0100060004C93O005E2O012O003D000500023O00206E0005000500192O00BB00050002000200061D000500812O013O0004C93O00812O012O003D000500044O00B2000600053O00122O000700503O00122O000800516O0006000800024O00050005000600202O00050005002F4O000500020002000E2O004800812O0100050004C93O00812O012O003D000500094O003D0006000F3O0020270006000600522O00BB00050002000200066A000500582O0100010004C93O00582O01002E88005300812O0100540004C93O00812O012O003D000500053O001217010600553O00122O000700566O000500076O00055O00044O00812O012O003D000500134O00F1000600053O00122O000700573O00122O000800586O00060008000200062O000500672O0100060004C93O00672O01002E67005900812O01005A0004C93O00812O012O003D000500023O00206E0005000500192O00BB00050002000200061D000500812O013O0004C93O00812O012O003D000500044O00B2000600053O00122O0007005B3O00122O0008005C6O0006000800024O00050005000600202O00050005002F4O000500020002000E2O004800812O0100050004C93O00812O012O003D000500094O003D000600043O00202700060006005D2O00BB00050002000200061D000500812O013O0004C93O00812O012O003D000500053O0012950006005E3O0012950007005F4O0063000500074O001601056O003D000500044O004C000600053O00122O000700603O00122O000800616O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500B62O013O0004C93O00B62O012O003D000500143O00061D000500B62O013O0004C93O00B62O012O003D000500063O0020B500050005001D4O000600156O000700166O00050007000200062O000500B62O013O0004C93O00B62O012O003D000500044O004C000600053O00122O000700623O00122O000800636O0006000800024O00050005000600202O0005000500644O00050002000200062O000500A92O013O0004C93O00A92O012O003D000500044O000F010600053O00122O000700653O00122O000800666O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500B62O0100010004C93O00B62O012O003D000500094O00600006000F3O00202O0006000600674O000700076O000800016O00050008000200062O000500B62O013O0004C93O00B62O012O003D000500053O001295000600683O001295000700694O0063000500074O001601055O002E67006A00D82O01006B0004C93O00D82O012O003D000500044O004C000600053O00122O0007006C3O00122O0008006D6O0006000800024O00050005000600202O00050005006E4O00050002000200062O000500D82O013O0004C93O00D82O012O003D000500173O00061D000500D82O013O0004C93O00D82O012O003D00055O00206E00050005006F2O00BB0005000200022O003D000600183O0006AD000500D82O0100060004C93O00D82O012O003D000500094O00600006000F3O00202O0006000600704O000700076O000800016O00050008000200062O000500D82O013O0004C93O00D82O012O003D000500053O001295000600713O001295000700724O0063000500074O001601056O003D000500023O0020150105000500234O000700043O00202O0007000700734O00050007000200062O000500FD2O013O0004C93O00FD2O012O003D000500194O007A000500010002000EB6000100FD2O0100050004C93O00FD2O012O003D0005001A3O00061D000500FD2O013O0004C93O00FD2O012O003D0005001A3O00206E0005000500062O00BB00050002000200061D000500FD2O013O0004C93O00FD2O012O003D0005001A3O0020150105000500744O000700043O00202O0007000700754O00050007000200062O000500FD2O013O0004C93O00FD2O012O003D000500094O003D0006000F3O0020270006000600762O00BB00050002000200061D000500FD2O013O0004C93O00FD2O012O003D000500053O001295000600773O001295000700784O0063000500074O001601055O001295000400303O002E4300790053000100790004C93O005102010026EF00040051020100300004C93O005102012O003D000500044O004C000600053O00122O0007007A3O00122O0008007B6O0006000800024O00050005000600202O00050005006E4O00050002000200062O0005002702013O0004C93O002702012O003D0005001B3O00061D0005002702013O0004C93O002702012O003D00055O0020150105000500744O000700043O00202O0007000700754O00050007000200062O0005002702013O0004C93O002702012O003D00055O00206E00050005006F2O00BB0005000200022O003D0006001C3O0006AD00050027020100060004C93O002702012O003D000500094O003D0006000F3O00202700060006007C2O00BB00050002000200061D0005002702013O0004C93O002702012O003D000500053O0012950006007D3O0012950007007E4O0063000500074O001601055O002E43007F00C80201007F0004C93O00EF04012O003D000500044O004C000600053O00122O000700803O00122O000800816O0006000800024O00050005000600202O00050005006E4O00050002000200062O000500EF04013O0004C93O00EF04012O003D0005001D3O00061D000500EF04013O0004C93O00EF04012O003D00055O0020150105000500234O000700043O00202O0007000700754O00050007000200062O000500EF04013O0004C93O00EF04012O003D00055O00206E00050005006F2O00BB0005000200022O003D0006001E3O0006AD000500EF040100060004C93O00EF04012O003D000500094O00600006000F3O00202O0006000600704O000700076O000800016O00050008000200062O000500EF04013O0004C93O00EF04012O003D000500053O001217010600823O00122O000700836O000500076O00055O00044O00EF04010026EF000400DA020100160004C93O00DA02012O003D000500023O00206E0005000500192O00BB00050002000200061D0005006C02013O0004C93O006C02012O003D000500033O00061D0005006C02013O0004C93O006C02012O003D000500044O004C000600053O00122O000700843O00122O000800856O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005006C02013O0004C93O006C02012O003D000500063O00207700050005001D4O0006001F6O000700206O00050007000200062O0005006E020100010004C93O006E0201002E880087007B020100860004C93O007B02012O003D000500094O003D000600043O0020270006000600882O00BB00050002000200066A00050076020100010004C93O00760201002E67008A007B020100890004C93O007B02012O003D000500053O0012950006008B3O0012950007008C4O0063000500074O001601055O002E88008E009D0201008D0004C93O009D02012O003D000500044O004C000600053O00122O0007008F3O00122O000800906O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005009D02013O0004C93O009D02012O003D000500213O00061D0005009D02013O0004C93O009D02012O003D00055O00206E00050005006F2O00BB0005000200022O003D000600223O0006AD0005009D020100060004C93O009D02012O003D000500094O003D0006000F3O0020270006000600912O00BB00050002000200066A00050098020100010004C93O00980201002E670005009D020100920004C93O009D02012O003D000500053O001295000600933O001295000700944O0063000500074O001601056O003D000500023O0020150105000500234O000700043O00202O0007000700954O00050007000200062O000500B902013O0004C93O00B902012O003D000500044O004C000600053O00122O000700963O00122O000800976O0006000800024O00050005000600202O00050005006E4O00050002000200062O000500B902013O0004C93O00B902012O003D000500094O003D0006000F3O0020270006000600702O00BB00050002000200061D000500B902013O0004C93O00B902012O003D000500053O001295000600983O001295000700994O0063000500074O001601056O003D000500044O004C000600053O00122O0007009A3O00122O0008009B6O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500CC02013O0004C93O00CC02012O003D000500233O00061D000500CC02013O0004C93O00CC02012O003D00055O00206E00050005006F2O00BB0005000200022O003D000600243O00064D00050003000100060004C93O00CE0201002E88009C00D90201009D0004C93O00D902012O003D000500094O003D000600043O0020270006000600952O00BB00050002000200061D000500D902013O0004C93O00D902012O003D000500053O0012950006009E3O0012950007009F4O0063000500074O001601055O001295000400A03O0026C0000400DE020100A00004C93O00DE0201002E6700A2003E040100A10004C93O003E0401001295000500014O00F2000600063O000E2E000100E0020100050004C93O00E00201001295000600013O0026EF000600830301000E0004C93O008303012O003D000700023O00206E0007000700192O00BB00070002000200061D0007002D03013O0004C93O002D03012O003D000700253O00061D0007002D03013O0004C93O002D03012O003D000700063O00208E0007000700A34O00088O0007000200024O000800053O00122O000900A43O00122O000A00A56O0008000A000200062O0007002D030100080004C93O002D03012O003D000700063O00206D0007000700A64O000800043O00202O0008000800A74O000900016O000A8O0007000A000200262O0007002D0301000E0004C93O002D03012O003D00075O00208D00070007006F4O0007000200024O000800266O000900276O000A00023O00202O000A000A00234O000C00043O00202O000C000C00A84O000A000C6O00093O000200202O0009000900484O00080008000900062O0007002D030100080004C93O002D03012O003D000700044O004C000800053O00122O000900A93O00122O000A00AA6O0008000A00024O00070007000800202O00070007006E4O00070002000200062O0007002D03013O0004C93O002D03012O003D00075O0020150107000700744O000900043O00202O0009000900A74O00070009000200062O0007002D03013O0004C93O002D0301002E4300AB000D000100AB0004C93O002D03012O003D000700094O003D0008000F3O0020270008000800AC2O00BB00070002000200061D0007002D03013O0004C93O002D03012O003D000700053O001295000800AD3O001295000900AE4O0063000700094O001601076O003D000700023O00206E0007000700192O00BB00070002000200061D0007008203013O0004C93O008203012O003D000700283O00061D0007008203013O0004C93O008203012O003D000700063O0020B10007000700A34O00088O0007000200024O000800053O00122O000900AF3O00122O000A00B06O0008000A000200062O00070082030100080004C93O008203012O003D000700063O00206D0007000700A64O000800043O00202O0008000800A74O00098O000A00016O0007000A000200262O000700820301000E0004C93O008203012O003D000700044O000F010800053O00122O000900B13O00122O000A00B26O0008000A00024O00070007000800202O0007000700644O00070002000200062O00070057030100010004C93O005703012O003D000700063O0020270007000700B32O007A00070001000200061D0007008203013O0004C93O008203012O003D00075O00208D00070007006F4O0007000200024O000800296O000900276O000A00023O00202O000A000A00234O000C00043O00202O000C000C00A84O000A000C6O00093O000200202O0009000900484O00080008000900062O00070082030100080004C93O008203012O003D000700044O004C000800053O00122O000900B43O00122O000A00B56O0008000A00024O00070007000800202O00070007006E4O00070002000200062O0007008203013O0004C93O008203012O003D00075O0020150107000700744O000900043O00202O0009000900A74O00070009000200062O0007008203013O0004C93O008203012O003D000700094O003D0008000F3O0020270008000800AC2O00BB00070002000200061D0007008203013O0004C93O008203012O003D000700053O001295000800B63O001295000900B74O0063000700094O001601075O001295000600163O002E8800B90089030100B80004C93O00890301000E2E00160089030100060004C93O008903010012950004003C3O0004C93O003E0401000E2E000100E3020100060004C93O00E302012O003D0007002A4O0017000800053O00122O000900BA3O00122O000A00BB6O0008000A000200062O000700B2030100080004C93O00B20301002E4300BC008A000100BC0004C93O001C04012O003D000700044O004C000800053O00122O000900BD3O00122O000A00BE6O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007001C04013O0004C93O001C04012O003D00075O00206E00070007006F2O00BB0007000200022O003D0008002B3O0006AD0007001C040100080004C93O001C0401002E8800BF001C040100C00004C93O001C04012O003D000700094O003D0008000F3O0020270008000800C12O00BB00070002000200061D0007001C04013O0004C93O001C04012O003D000700053O001217010800C23O00122O000900C36O000700096O00075O00044O001C04012O003D0007002A4O00F1000800053O00122O000900C43O00122O000A00C56O0008000A000200062O000700BB030100080004C93O00BB0301002E6700C600E3030100C70004C93O00E303012O003D000700044O004C000800053O00122O000900C83O00122O000A00C96O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007001C04013O0004C93O001C04012O003D00075O00206E00070007006F2O00BB0007000200022O003D0008002B3O0006AD0007001C040100080004C93O001C040100121E000700CA3O00208E0007000700A34O00088O0007000200024O000800053O00122O000900CB3O00122O000A00CC6O0008000A000200062O0007001C040100080004C93O001C0401002E6700CE001C040100CD0004C93O001C04012O003D000700094O003D0008000F3O0020270008000800C12O00BB00070002000200061D0007001C04013O0004C93O001C04012O003D000700053O001217010800CF3O00122O000900D06O000700096O00075O00044O001C04012O003D0007002A4O00F1000800053O00122O000900D13O00122O000A00D26O0008000A000200062O000700EB030100080004C93O00EB03010004C93O001C04012O003D000700044O004C000800053O00122O000900D33O00122O000A00D46O0008000A00024O00070007000800202O00070007001C4O00070002000200062O0007000F04013O0004C93O000F04012O003D00075O00206E00070007006F2O00BB0007000200022O003D0008002B3O0006AD0007000F040100080004C93O000F040100121E000700CA3O0020B10007000700A34O00088O0007000200024O000800053O00122O000900D53O00122O000A00D66O0008000A000200062O00070011040100080004C93O0011040100121E000700CA3O0020B10007000700A34O00088O0007000200024O000800053O00122O000900D73O00122O000A00D86O0008000A000200062O00070011040100080004C93O00110401002E4300D9000D000100DA0004C93O001C04012O003D000700094O003D0008000F3O0020270008000800C12O00BB00070002000200061D0007001C04013O0004C93O001C04012O003D000700053O001295000800DB3O001295000900DC4O0063000700094O001601075O002E8800DD003A040100DE0004C93O003A04012O003D000700044O004C000800053O00122O000900DF3O00122O000A00E06O0008000A00024O00070007000800202O00070007006E4O00070002000200062O0007003A04013O0004C93O003A04012O003D000700023O00206E0007000700192O00BB00070002000200061D0007003A04013O0004C93O003A04012O003D000700094O003D0008000F3O0020270008000800E12O00BB00070002000200066A00070035040100010004C93O00350401002E4300E20007000100E30004C93O003A04012O003D000700053O001295000800E43O001295000900E54O0063000700094O001601075O0012950006000E3O0004C93O00E302010004C93O003E04010004C93O00E002010026EF00040034000100010004C93O00340001001295000500013O000E2E0001007F040100050004C93O007F0401002E8800E70056040100E60004C93O0056040100121E000600E83O00061D0006005604013O0004C93O00560401001295000600014O00F2000700073O002E4300E93O000100E90004C93O004A04010026EF0006004A040100010004C93O004A04012O003D0008002C4O007A0008000100022O0047000700083O00061D0007005604013O0004C93O005604012O0092000700023O0004C93O005604010004C93O004A04012O003D0006002D3O00061D0006007E04013O0004C93O007E04012O003D000600033O00061D0006007E04013O0004C93O007E04012O003D000600023O00206E0006000600192O00BB00060002000200061D0006007E04013O0004C93O007E04012O003D000600104O007A000600010002000EB600A0007E040100060004C93O007E04012O003D000600044O004C000700053O00122O000800EA3O00122O000900EB6O0007000900024O00060006000700202O00060006001C4O00060002000200062O0006007E04013O0004C93O007E04012O003D000600094O0007000700043O00202O0007000700EC4O000800096O000A00016O0006000A000200062O00060079040100010004C93O00790401002E6700ED007E040100EE0004C93O007E04012O003D000600053O001295000700EF3O001295000800F04O0063000600084O001601065O0012950005000E3O0026EF00050083040100160004C93O008304010012950004000E3O0004C93O003400010026C0000500870401000E0004C93O00870401002E6700F10041040100F20004C93O00410401001295000600013O002E8800F3008E040100F40004C93O008E04010026EF0006008E0401000E0004C93O008E0401001295000500163O0004C93O004104010026EF00060088040100010004C93O008804012O003D000700044O004C000800053O00122O000900F53O00122O000A00F66O0008000A00024O00070007000800202O00070007001C4O00070002000200062O000700BC04013O0004C93O00BC04012O003D0007002E3O00061D000700BC04013O0004C93O00BC04012O003D000700023O00201501070007003A4O000900043O00202O0009000900F74O00070009000200062O000700BC04013O0004C93O00BC04012O003D0007002F4O003D00086O00BB00070002000200061D000700BC04013O0004C93O00BC04012O003D00075O00206E00070007006F2O00BB0007000200022O003D000800303O0006AD000700BC040100080004C93O00BC04012O003D000700094O003D0008000F3O0020270008000800F82O00BB00070002000200066A000700B7040100010004C93O00B70401002E8800FA00BC040100F90004C93O00BC04012O003D000700053O001295000800FB3O001295000900FC4O0063000700094O001601076O003D000700023O0020150107000700234O000900043O00202O0009000900F74O00070009000200062O000700D404013O0004C93O00D404012O003D000700044O004C000800053O00122O000900FD3O00122O000A00FE6O0008000A00024O00070007000800202O00070007001C4O00070002000200062O000700D404013O0004C93O00D404012O003D000700063O00207700070007001D4O000800316O000900326O00070009000200062O000700D6040100010004C93O00D60401002E8800FF00E304012O000104C93O00E304012O003D000700094O00600008000F3O00202O0008000800674O000900096O000A00016O0007000A000200062O000700E304013O0004C93O00E304012O003D000700053O0012950008002O012O00129500090002013O0063000700094O001601075O0012950006000E3O0004C93O008804010004C93O004104010004C93O003400010004C93O00EF04010004C93O002F00010004C93O00EF04010004C93O002600010004C93O00EF04010004C93O000700010004C93O00EF04010004C93O000200012O00C33O00017O00483O00028O00026O00F03F026O004140025O0012A440025O0078A640025O00AC9440025O00B89F40027O0040025O00E09F40025O00508540030F3O0048616E646C65412O666C696374656403083O00526567726F77746803113O00526567726F7774684D6F7573656F766572026O004440025O00D07040025O009CA240026O000840030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F766572025O00208A40025O0024B04003093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572025O005AA740025O009C9040026O001040030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F766572025O00CCA240025O002AA940025O00DEAB40025O006BB140025O00109D40025O0022A040025O0096A040025O001EB340030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572025O0046AC40025O00A8A040025O000EAA40025O007DB140025O0022AC40025O002CAB40025O00688240025O00109B40025O00406040025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA40025O0084AB40025O00C4A040025O0046AB40025O0074A940030D3O00546172676574497356616C6964025O0061B140025O0078AC40025O00206340025O007C9D40025O00949B40026O008440026O006940025O00B6AF40025O0014A940025O00E09540025O00909540025O002EAE40025O00E06640025O001AAA400028012O0012953O00014O00F2000100013O000E2E000100C700013O0004C93O00C70001001295000200013O0026EF00020009000100020004C93O000900010012953O00023O0004C93O00C70001002E6700030005000100040004C93O000500010026EF00020005000100010004C93O000500012O003D00035O00066A00030012000100010004C93O00120001002E4300050083000100060004C93O00930001001295000300014O00F2000400043O002E4300073O000100070004C93O00140001000E2E00010014000100030004C93O00140001001295000400013O0026EF00040035000100080004C93O00350001001295000500013O0026C000050020000100010004C93O00200001002E43000900120001000A0004C93O003000012O003D000600013O00203000060006000B4O000700023O00202O00070007000C4O000800033O00202O00080008000D00122O0009000E6O000A00016O0006000A00024O000100063O00062O0001002E000100010004C93O002E0001002E880010002F0001000F0004C93O002F00012O0092000100023O001295000500023O0026EF0005001C000100020004C93O001C0001001295000400113O0004C93O003500010004C93O001C00010026EF00040046000100010004C93O004600012O003D000500013O00209800050005000B4O000600023O00202O0006000600124O000700033O00202O00070007001300122O0008000E6O0005000800024O000100053O002E2O00140045000100150004C93O0045000100061D0001004500013O0004C93O004500012O0092000100023O001295000400023O0026EF00040057000100110004C93O005700012O003D000500013O0020C400050005000B4O000600023O00202O0006000600164O000700033O00202O00070007001700122O0008000E6O0005000800024O000100053O002E2O00190056000100180004C93O0056000100061D0001005600013O0004C93O005600012O0092000100023O0012950004001A3O0026EF000400690001001A0004C93O006900012O003D000500013O00204200050005000B4O000600023O00202O00060006001B4O000700033O00202O00070007001C00122O0008000E6O000900016O0005000900024O000100053O002E2O001D00930001001E0004C93O0093000100061D0001009300013O0004C93O009300012O0092000100023O0004C93O00930001002E88001F0019000100200004C93O00190001000E2E00020019000100040004C93O00190001001295000500014O00F2000600063O0026C000050073000100010004C93O00730001002E670022006F000100210004C93O006F0001001295000600013O0026C000060078000100010004C93O00780001002E6700240087000100230004C93O008700012O003D000700013O00200F00070007000B4O000800023O00202O0008000800254O000900033O00202O00090009002600122O000A000E6O0007000A00024O000100073O002E2O00270005000100270004C93O0086000100061D0001008600013O0004C93O008600012O0092000100023O001295000600023O002E8800280074000100290004C93O007400010026EF00060074000100020004C93O00740001001295000400083O0004C93O001900010004C93O007400010004C93O001900010004C93O006F00010004C93O001900010004C93O009300010004C93O001400012O003D000300043O00066A00030099000100010004C93O009900012O003D000300053O00061D000300C500013O0004C93O00C500012O003D000300063O00061D000300C500013O0004C93O00C50001001295000300014O00F2000400053O000E22000100A2000100030004C93O00A20001002E67002A00B10001002B0004C93O00B10001001295000600013O0026C0000600A7000100020004C93O00A70001002E43002C00040001002D0004C93O00A90001001295000300023O0004C93O00B10001002E67002F00A30001002E0004C93O00A300010026EF000600A3000100010004C93O00A30001001295000400014O00F2000500053O001295000600023O0004C93O00A300010026C0000300B5000100020004C93O00B50001002E880031009E000100300004C93O009E0001002E67003200B5000100330004C93O00B500010026EF000400B5000100010004C93O00B500012O003D000600074O007A0006000100022O0047000500063O002E67003400C5000100350004C93O00C5000100061D000500C500013O0004C93O00C500012O0092000500023O0004C93O00C500010004C93O00B500010004C93O00C500010004C93O009E0001001295000200023O0004C93O00050001000E22000200CB00013O0004C93O00CB0001002E88003600D2000100370004C93O00D200012O003D000200084O007A0002000100022O0047000100023O00061D000100D100013O0004C93O00D100012O0092000100023O0012953O00083O000E22001100D600013O0004C93O00D60001002E67003800062O0100390004C93O00062O0100061D000100D900013O0004C93O00D900012O0092000100024O003D000200013O00202700020002003A2O007A00020001000200061D000200E100013O0004C93O00E100012O003D000200093O00066A000200E3000100010004C93O00E30001002E88003B00272O01003C0004C93O00272O01001295000200014O00F2000300043O0026EF000200EA000100010004C93O00EA0001001295000300014O00F2000400043O001295000200023O0026C0000200EE000100020004C93O00EE0001002E67003E00E50001003D0004C93O00E50001002E88004000EE0001003F0004C93O00EE00010026EF000300EE000100010004C93O00EE0001001295000400013O002E88004100F3000100420004C93O00F300010026EF000400F3000100010004C93O00F300012O003D0005000A4O007A0005000100022O0047000100053O00066A000100FE000100010004C93O00FE0001002E67004300272O0100440004C93O00272O012O0092000100023O0004C93O00272O010004C93O00F300010004C93O00272O010004C93O00EE00010004C93O00272O010004C93O00E500010004C93O00272O01002E8800450002000100460004C93O000200010026EF3O0002000100080004C93O00020001001295000200013O0026EF0002001F2O0100010004C93O001F2O012O003D0003000B3O00061D0003001B2O013O0004C93O001B2O01001295000300013O0026EF000300112O0100010004C93O00112O012O003D0004000C4O007A0004000100022O0047000100043O00061D0001001B2O013O0004C93O001B2O012O0092000100023O0004C93O001B2O010004C93O00112O012O003D0003000D4O007A0003000100022O0047000100033O001295000200023O002E670047000B2O0100480004C93O000B2O010026EF0002000B2O0100020004C93O000B2O010012953O00113O0004C93O000200010004C93O000B2O010004C93O000200012O00C33O00017O00583O00028O00025O00A07A40025O0098A940026O001040030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C6963746564030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F766572026O004440025O0010AC40025O00F8AF40025O0068AA40026O000840025O00E9B240025O00F5B140026O00F03F025O00F4AE4003093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F766572030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572025O00E2A740025O006AA040027O004003083O00526567726F77746803113O00526567726F7774684D6F7573656F766572025O0012AF40025O0050B240025O00308840025O00707C4003113O0048616E646C65496E636F72706F7265616C03093O0048696265726E61746503123O0048696265726E6174654D6F7573656F766572026O003E40026O008A40025O0056A240025O00389E40025O00B2A540025O00E08240025O003DB240025O0050A040025O00B6A240025O00209F40025O0074A440025O00ECA940025O00207A40025O00C6AF40025O00D2A340025O0049B040025O00B8AF40025O00805540025O00F08240025O00206340025O002AA340025O00E8A440025O0083B040025O00B07140025O000EA640025O0092B040025O00E07640025O0068B240030D3O0001D0D411DDC7D94229E6CF16F603083O002A4CB1A67A92A18D030A3O0049734361737461626C6503083O0042752O66446F776E030D3O004D61726B4F6654686557696C6403103O0047726F757042752O664D692O73696E6703133O004D61726B4F6654686557696C64506C6179657203103O00A88B17C54679A3B511C67C49B28309CA03063O0016C5EA65AE19030D3O00546172676574497356616C696403043O001F35AED903083O00E64D54C5BC16CFB703073O004973526561647903093O00537465616C7468557003043O0052616B65030E3O004973496E4D656C2O6552616E6765026O00244003043O00EB15CDF903083O00559974A69CECC190025O000EAA40025O0060A740025O00289740025O00D09640025O00606540025O0053B2400097012O0012953O00013O0026EF3O00BA000100010004C93O00BA0001001295000100013O0026EF000100B3000100010004C93O00B300012O003D00025O00066A0002000B000100010004C93O000B0001002E8800030088000100020004C93O00880001001295000200013O0026EF00020020000100040004C93O002000012O003D000300013O00209B0003000300064O000400023O00202O0004000400074O000500033O00202O00050005000800122O000600096O000700016O00030007000200122O000300053O00122O000300053O00062O0003001D000100010004C93O001D0001002E43000A006D0001000B0004C93O0088000100121E000300054O0092000300023O0004C93O00880001002E43000C001F0001000C0004C93O003F00010026EF0002003F0001000D0004C93O003F0001001295000300013O002E67000F002B0001000E0004C93O002B00010026EF0003002B000100100004C93O002B0001001295000200043O0004C93O003F0001002E43001100FAFF2O00110004C93O002500010026EF00030025000100010004C93O002500012O003D000400013O0020AF0004000400064O000500023O00202O0005000500124O000600033O00202O00060006001300122O000700096O00040007000200122O000400053O00122O000400053O00062O0004003D00013O0004C93O003D000100121E000400054O0092000400023O001295000300103O0004C93O002500010026EF00020058000100010004C93O00580001001295000300013O0026EF00030053000100010004C93O005300012O003D000400013O0020AF0004000400064O000500023O00202O0005000500144O000600033O00202O00060006001500122O000700096O00040007000200122O000400053O00122O000400053O00062O0004005200013O0004C93O0052000100121E000400054O0092000400023O001295000300103O000E2E00100042000100030004C93O00420001001295000200103O0004C93O005800010004C93O004200010026EF00020073000100100004C93O00730001001295000300013O000E2E0001006E000100030004C93O006E00012O003D000400013O0020AB0004000400064O000500023O00202O0005000500164O000600033O00202O00060006001700122O000700096O00040007000200122O000400053O00122O000400053O00062O0004006B000100010004C93O006B0001002E670018006D000100190004C93O006D000100121E000400054O0092000400023O001295000300103O0026EF0003005B000100100004C93O005B00010012950002001A3O0004C93O007300010004C93O005B00010026EF0002000C0001001A0004C93O000C00012O003D000300013O00209B0003000300064O000400023O00202O00040004001B4O000500033O00202O00050005001C00122O000600096O000700016O00030007000200122O000300053O00122O000300053O00062O00030084000100010004C93O00840001002E67001E00860001001D0004C93O0086000100121E000300054O0092000300023O0012950002000D3O0004C93O000C00012O003D000200043O00061D000200B200013O0004C93O00B20001001295000200014O00F2000300043O0026EF00020092000100010004C93O00920001001295000300014O00F2000400043O001295000200103O0026EF0002008D000100100004C93O008D00010026EF00030094000100010004C93O00940001001295000400013O0026C00004009B000100010004C93O009B0001002E88001F0097000100200004C93O009700012O003D000500013O00209B0005000500214O000600023O00202O0006000600224O000700033O00202O00070007002300122O000800246O000900016O00050009000200122O000500053O00122O000500053O00062O000500AA000100010004C93O00AA0001002E430025000A000100260004C93O00B2000100121E000500054O0092000500023O0004C93O00B200010004C93O009700010004C93O00B200010004C93O009400010004C93O00B200010004C93O008D0001001295000100103O0026C0000100B7000100100004C93O00B70001002E430027004FFF2O00280004C93O000400010012953O00103O0004C93O00BA00010004C93O000400010026C03O00BE000100100004C93O00BE0001002E43002900580001002A0004C93O00142O012O003D000100053O00066A000100C4000100010004C93O00C400012O003D000100063O00061D000100C700013O0004C93O00C700012O003D000100073O00066A000100C9000100010004C93O00C90001002E88002C00F00001002B0004C93O00F00001001295000100014O00F2000200043O002E67002D00E80001002E0004C93O00E800010026EF000100E8000100100004C93O00E800012O00F2000400043O0026EF000200D5000100010004C93O00D50001001295000300014O00F2000400043O001295000200103O0026C0000200D9000100100004C93O00D90001002E43002F00F9FF2O00300004C93O00D00001000E22000100DD000100030004C93O00DD0001002E67003100D9000100320004C93O00D900012O003D000500084O007A0005000100022O0047000400053O00061D000400F000013O0004C93O00F000012O0092000400023O0004C93O00F000010004C93O00D900010004C93O00F000010004C93O00D000010004C93O00F000010026C0000100EC000100010004C93O00EC0001002E67003300CB000100340004C93O00CB0001001295000200014O00F2000300033O001295000100103O0004C93O00CB00012O003D000100093O00061D000100F600013O0004C93O00F600012O003D0001000A3O00066A000100F8000100010004C93O00F80001002E67003600132O0100350004C93O00132O01001295000100014O00F2000200033O0026EF000100FF000100010004C93O00FF0001001295000200014O00F2000300033O001295000100103O0026C0000100032O0100100004C93O00032O01002E67003800FA000100370004C93O00FA00010026C0000200072O0100010004C93O00072O01002E67003A00032O0100390004C93O00032O012O003D0004000B4O007A0004000100022O0047000300043O00066A0003000E2O0100010004C93O000E2O01002E67003C00132O01003B0004C93O00132O012O0092000300023O0004C93O00132O010004C93O00032O010004C93O00132O010004C93O00FA00010012953O001A3O002E88003E00682O01003D0004C93O00682O01000E2E001A00682O013O0004C93O00682O01002E43003F00290001003F0004C93O00412O012O003D0001000C3O00061D000100412O013O0004C93O00412O012O003D000100024O004C0002000D3O00122O000300403O00122O000400416O0002000400024O00010001000200202O0001000100424O00010002000200062O000100412O013O0004C93O00412O012O003D0001000E3O0020DA0001000100434O000300023O00202O0003000300444O000400016O00010004000200062O000100362O0100010004C93O00362O012O003D000100013O0020450001000100454O000200023O00202O0002000200444O00010002000200062O000100412O013O0004C93O00412O012O003D0001000F4O003D000200033O0020270002000200462O00BB00010002000200061D000100412O013O0004C93O00412O012O003D0001000D3O001295000200473O001295000300484O0063000100034O00162O016O003D000100013O0020270001000100492O007A00010001000200061D000100672O013O0004C93O00672O012O003D000100024O004C0002000D3O00122O0003004A3O00122O0004004B6O0002000400024O00010001000200202O00010001004C4O00010002000200062O000100672O013O0004C93O00672O012O003D0001000E3O0020042O010001004D4O00038O000400016O00010004000200062O000100672O013O0004C93O00672O012O003D0001000F4O0031000200023O00202O00020002004E4O000300103O00202O00030003004F00122O000500506O0003000500024O000300036O00010003000200062O000100672O013O0004C93O00672O012O003D0001000D3O001295000200513O001295000300524O0063000100034O00162O015O0012953O000D3O002E6700540001000100530004C93O000100010026EF3O00010001000D0004C93O000100012O003D000100013O0020270001000100492O007A00010001000200061D000100962O013O0004C93O00962O012O003D000100113O00061D000100962O013O0004C93O00962O01001295000100014O00F2000200033O002E670056007D2O0100550004C93O007D2O010026EF0001007D2O0100010004C93O007D2O01001295000200014O00F2000300033O001295000100103O0026EF000100762O0100100004C93O00762O010026C0000200832O0100010004C93O00832O01002E670058007F2O0100570004C93O007F2O01001295000300013O0026EF000300842O0100010004C93O00842O012O003D000400124O007A0004000100020012EE000400053O00121E000400053O00061D000400962O013O0004C93O00962O0100121E000400054O0092000400023O0004C93O00962O010004C93O00842O010004C93O00962O010004C93O007F2O010004C93O00962O010004C93O00762O010004C93O00962O010004C93O000100012O00C33O00017O009F3O00028O00026O00F03F025O00FAA040025O00E8B240026O001040025O0058AE40025O00089540026O000840026O001440025O0040AA40030C3O004570696353652O74696E677303083O00CB2O2A3CDC4B055703083O0024984F5E48B52562030B3O00E2CB4219DBD7522DDECB4F03043O005FB7B82703083O00863AF3325D8E05A603073O0062D55F874634E0030A3O00D8AFC66246F7B0C15F6403053O00349EC3A917027O0040025O00E89040026O00A64003083O0049B926608F3B7C9803083O00EB1ADC5214E6551B030D3O00AEADE6D76681B2E1E56687B4F903053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC77030D3O0026BDA11DDDE9FEDA3ABCAF14FA03083O00B16FCFCE739F888C034O00025O00ECAD40025O00E8B040025O002C9140025O0092B24003083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA03133O00C30C2CFFF0CFE5372AECCCD4E9112BFD2OECD003063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E98903163O009ABCA90987F8F58DBBA22C98FAE2B0A7B4389AFCE5A903073O0090D9D3C77FE893025O0007B340025O001CB34003083O006EB0B69354BBA59403043O00E73DD5C203113O0021A83C7F00A33A4306B9347C07833C7E0C03043O001369CD5D03083O009A0DCA9536A70FCD03053O005FC968BEE1030F3O0087CEC0C2A6C5C6FEA0DFC8C1A1E3F103043O00AECFABA1025O00B2A240025O0080994003083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803103O00191AE3212D1BED232A3DEE091B00EA0803043O006C4C698603083O00D8C0A5F5C7E5C2A203053O00AE8BA5D181030D3O0087BAF1D1C30F547DA1A6E4C7D503083O0018C3D382A1A6631003083O0097E559A7ED0EA3F303063O0060C4802DD384030A4O009E7E6DD3ACBDD9399E03083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F68396903103O003E94A16C0E86A84D0580944B1F8EAB4A03043O00246BE7C403083O007506FD385A18411003063O00762663894C33030B3O00D92F16020C2CDF3303141A03063O00409D4665726903083O0073ADB3F7194EAFB403053O007020C8C783030E3O0019435990C6AA2E38584FACCCA52703073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE030D3O00852F5240A2A5394743B8A8026303053O00D6CD4A332C03083O00C949F6E87EF44BF103053O00179A2C829C030F3O0039A7A3AA3A1630A0ABA23F1005A3A903063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E03113O009C88DE2A30A81CBA8ADF3C2CA227B188DC03073O0055D4E9B04E5CCD03083O00795D9CF643568FF103043O00822A38E803113O00C3BB30E6522DFFA530D4492BE28630F64E03063O005F8AD544832003083O00D6B84324C63AE2AE03063O005485DD3750AF03123O0098E122AAC84EB8F427A3C95FB8D237A7C05903063O003CDD8744C6A703083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030F3O007DC351F64C21F24BC652F44036DF6803073O009738A5379A2353025O00DCA24003083O00192DB5577F242FB203053O00164A48C12303163O000577F05D3E6BF1483856EA54354EEC51387CE8513F6D03043O00384C198403083O006DC4BF32C650C6B803053O00AF3EA1CB4603123O0015D3D716272EC8D3070134CFC6003D33D1C703053O00555CBDA373025O00C0984003083O001AA9242C20A2372B03043O005849CC50031A3O001B90156228D72F84156526D4388C1B431DD22BB0004F3BD33A9003063O00BA4EE370264903083O00CF52E9415A74FB4403063O001A9C379D353303153O00B9CB13FDB95D8DDF13F7B94499CA13CA8E598BD11A03063O0030ECB876B9D8025O00DAA140025O0032A04003083O00368C0400DD41581603073O003F65E97074B42F030A3O00EA29E21CDA37D130C52203063O0056A35B8D7298025O009CA640025O00DEA54003083O001D4E2AC1581FFB3D03073O009C4E2B5EB5317103133O0055FACBB50E646C73FAC0AA0A4D6A55FACBB61B03073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA1030F3O0018FF2EF90DD2833FE524D43FDD902903073O00E24D8C4BBA68BC025O00EC9340025O002AAC4003083O00934611FAA94D02FD03043O008EC0236503113O00E3662C84F583BA13F16028B1E385AD18C503083O0076B61549C387ECCC03083O003B390E540D03FA1B03073O009D685C7A20646D03103O0084B4C0DC380098AAB1A2C6CB3334A59B03083O00CBC3C6AFAA5D47ED026O006E40025O0098924003083O008ACBC42B46B7C9C303053O002FD9AEB05F030E3O009BD87803A05D77288FDC64069A6403083O0046D8BD1662D2341803083O00E9DAB793DAD4D8B003053O00B3BABFC3E703143O00CC2C1DC7F6310EEBF23A2CECFC0C08EDEB360CF703043O0084995F78025O00D88340025O00A2A140004F022O0012953O00014O00F2000100023O0026EF3O0007000100010004C93O00070001001295000100014O00F2000200023O0012953O00023O0026C03O000B000100020004C93O000B0001002E8800040002000100030004C93O000200010026EF0001000B000100010004C93O000B0001001295000200013O0026EF00020096000100050004C93O00960001001295000300014O00F2000400043O0026C000030016000100010004C93O00160001002E8800060012000100070004C93O00120001001295000400013O0026EF0004001B000100080004C93O001B0001001295000200093O0004C93O00960001002E43000A00280001000A0004C93O004300010026EF00040043000100020004C93O00430001001295000500013O0026EF0005003E000100010004C93O003E000100121E0006000B4O00D2000700013O00122O0008000C3O00122O0009000D6O0007000900024O0006000600074O000700013O00122O0008000E3O00122O0009000F6O0007000900024O0006000600074O00065O00122O0006000B6O000700013O00122O000800103O00122O000900116O0007000900024O0006000600074O000700013O00122O000800123O00122O000900136O0007000900024O00060006000700062O0006003C000100010004C93O003C0001001295000600014O002B000600023O001295000500023O0026EF00050020000100020004C93O00200001001295000400143O0004C93O004300010004C93O00200001002E6700150066000100160004C93O00660001000E2E00140066000100040004C93O0066000100121E0005000B4O00DB000600013O00122O000700173O00122O000800186O0006000800024O0005000500064O000600013O00122O000700193O00122O0008001A6O0006000800024O00050005000600062O00050055000100010004C93O00550001001295000500014O002B000500033O00127E0005000B6O000600013O00122O0007001B3O00122O0008001C6O0006000800024O0005000500064O000600013O00122O0007001D3O00122O0008001E6O0006000800024O00050005000600062O00050064000100010004C93O006400010012950005001F4O002B000500043O001295000400083O0026EF00040017000100010004C93O00170001001295000500013O0026C00005006D000100020004C93O006D0001002E670021006F000100200004C93O006F0001001295000400023O0004C93O001700010026C000050073000100010004C93O00730001002E6700230069000100220004C93O0069000100121E0006000B4O00DB000700013O00122O000800243O00122O000900256O0007000900024O0006000600074O000700013O00122O000800263O00122O000900276O0007000900024O00060006000700062O00060081000100010004C93O00810001001295000600014O002B000600053O00127E0006000B6O000700013O00122O000800283O00122O000900296O0007000900024O0006000600074O000700013O00122O0008002A3O00122O0009002B6O0007000900024O00060006000700062O00060090000100010004C93O00900001001295000600014O002B000600063O001295000500023O0004C93O006900010004C93O001700010004C93O009600010004C93O00120001002E67002C003O01002D0004C93O003O01000E2E0001003O0100020004C93O003O01001295000300013O0026EF000300BC000100020004C93O00BC000100121E0004000B4O00DB000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000500013O00122O000600303O00122O000700316O0005000700024O00040004000500062O000400AB000100010004C93O00AB00010012950004001F4O002B000400073O00127E0004000B6O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O00040004000500062O000400BA000100010004C93O00BA0001001295000400014O002B000400083O001295000300143O0026C0000300C0000100140004C93O00C00001002E67003600E1000100370004C93O00E10001001295000400013O0026EF000400C5000100020004C93O00C50001001295000300083O0004C93O00E100010026EF000400C1000100010004C93O00C1000100121E0005000B4O0009000600013O00122O000700383O00122O000800396O0006000800024O0005000500064O000600013O00122O0007003A3O00122O0008003B6O0006000800024O0005000500064O000500093O00122O0005000B6O000600013O00122O0007003C3O00122O0008003D6O0006000800024O0005000500064O000600013O00122O0007003E3O00122O0008003F6O0006000800024O0005000500064O0005000A3O00122O000400023O0004C93O00C100010026EF000300FC000100010004C93O00FC000100121E0004000B4O0009000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O0004000B3O00122O0004000B6O000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O0004000C3O00122O000300023O0026EF0003009B000100080004C93O009B0001001295000200023O0004C93O003O010004C93O009B00010026EF0002004F2O0100020004C93O004F2O0100121E0003000B4O0020010400013O00122O000500483O00122O000600496O0004000600024O0003000300044O000400013O00122O0005004A3O00122O0006004B6O0004000600024O0003000300042O002B0003000D3O00121E0003000B4O00D2000400013O00122O0005004C3O00122O0006004D6O0004000600024O0003000300044O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O0003000E3O00122O0003000B6O000400013O00122O000500503O00122O000600516O0004000600024O0003000300044O000400013O00122O000500523O00122O000600536O0004000600024O00030003000400062O000300292O0100010004C93O00292O01001295000300014O002B0003000F3O00126C0003000B6O000400013O00122O000500543O00122O000600556O0004000600024O0003000300044O000400013O00122O000500563O00122O000600576O0004000600022O00C50003000300042O002B000300103O00121E0003000B4O0009000400013O00122O000500583O00122O000600596O0004000600024O0003000300044O000400013O00122O0005005A3O00122O0006005B6O0004000600024O0003000300044O000300113O00122O0003000B6O000400013O00122O0005005C3O00122O0006005D6O0004000600024O0003000300044O000400013O00122O0005005E3O00122O0006005F6O0004000600024O0003000300044O000300123O00122O000200143O0026EF000200B52O0100140004C93O00B52O01001295000300013O0026EF000300732O0100140004C93O00732O0100121E0004000B4O00DB000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O00040004000500062O000400622O0100010004C93O00622O010012950004001F4O002B000400133O00127E0004000B6O000500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O00040004000500062O000400712O0100010004C93O00712O01001295000400014O002B000400143O001295000300083O002E4300680020000100680004C93O00932O01000E2E000100932O0100030004C93O00932O0100121E0004000B4O00D2000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000400153O00122O0004000B6O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O000500013O00122O0006006F3O00122O000700706O0005000700024O00040004000500062O000400912O0100010004C93O00912O01001295000400014O002B000400163O001295000300023O002E4300710006000100710004C93O00992O01000E2E000800992O0100030004C93O00992O01001295000200083O0004C93O00B52O010026EF000300522O0100020004C93O00522O0100121E0004000B4O0009000500013O00122O000600723O00122O000700736O0005000700024O0004000400054O000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000400173O00122O0004000B6O000500013O00122O000600763O00122O000700776O0005000700024O0004000400054O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000400183O00122O000300143O0004C93O00522O01002E88007B00C92O01007A0004C93O00C92O01000E2E000900C92O0100020004C93O00C92O0100121E0003000B4O00DB000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000400013O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400062O000300C72O0100010004C93O00C72O01001295000300014O002B000300193O0004C93O004E0201000E2E0008000E000100020004C93O000E0001001295000300014O00F2000400043O0026EF000300CD2O0100010004C93O00CD2O01001295000400013O0026C0000400D42O0100020004C93O00D42O01002E88008000F02O0100810004C93O00F02O0100121E0005000B4O00DB000600013O00122O000700823O00122O000800836O0006000800024O0005000500064O000600013O00122O000700843O00122O000800856O0006000800024O00050005000600062O000500E22O0100010004C93O00E22O01001295000500014O002B0005001A3O0012400005000B6O000600013O00122O000700863O00122O000800876O0006000800024O0005000500064O000600013O00122O000700883O00122O000800896O0006000800024O0005000500064O0005001B3O00122O000400143O0026C0000400F42O0100010004C93O00F42O01002E88008B00180201008A0004C93O00180201001295000500013O0026EF00050013020100010004C93O0013020100121E0006000B4O00D2000700013O00122O0008008C3O00122O0009008D6O0007000900024O0006000600074O000700013O00122O0008008E3O00122O0009008F6O0007000900024O0006000600074O0006001C3O00122O0006000B6O000700013O00122O000800903O00122O000900916O0007000900024O0006000600074O000700013O00122O000800923O00122O000900936O0007000900024O00060006000700062O00060011020100010004C93O00110201001295000600014O002B0006001D3O001295000500023O0026EF000500F52O0100020004C93O00F52O01001295000400023O0004C93O001802010004C93O00F52O010026EF0004001C020100080004C93O001C0201001295000200053O0004C93O000E0001002E88009400D02O0100950004C93O00D02O010026EF000400D02O0100140004C93O00D02O01001295000500013O000E2E0001003F020100050004C93O003F020100121E0006000B4O00DB000700013O00122O000800963O00122O000900976O0007000900024O0006000600074O000700013O00122O000800983O00122O000900996O0007000900024O00060006000700062O00060031020100010004C93O00310201001295000600014O002B0006001E3O0012400006000B6O000700013O00122O0008009A3O00122O0009009B6O0007000900024O0006000600074O000700013O00122O0008009C3O00122O0009009D6O0007000900024O0006000600074O0006001F3O00122O000500023O0026C000050043020100020004C93O00430201002E88009F00210201009E0004C93O00210201001295000400083O0004C93O00D02O010004C93O002102010004C93O00D02O010004C93O000E00010004C93O00CD2O010004C93O000E00010004C93O004E02010004C93O000B00010004C93O004E02010004C93O000200012O00C33O00017O00A63O00028O00025O00A49E40025O00B08040026O000840030C3O004570696353652O74696E677303083O00CAD21E2OB7DC53BB03083O00C899B76AC3DEB23403114O00E68F2F464D26EBBA384F4837F080157903063O003A5283E85D2903083O00B052C4015431844403063O005FE337B0753D030F3O002D6D2679AE126B354EA5196A2A44A503053O00CB781E432B03083O00C22059FBD0FF225E03053O00B991452D8F030E3O00B81A13B3CA8F1118B2D58511319603053O00BCEA7F79C6026O00104003083O00600E6067335D0C6703053O005A336B141303103O00B8E380C3348BF587E33282FDB1EE338603053O005DED90E58F03083O0026F3E40D024812E503063O0026759690796B030F3O0001B2E83F2FB7E135208FEF342693DE03043O005A4DDB8E026O00F03F025O00806840025O009EA74003083O00D501352D45097DF503073O001A866441592C67030C3O00C4F0350FADF7E6322FABFEEE03053O00C491835043026O00A040025O00CEA740026O001440025O00B07940025O0034A740025O00809440025O00D2A54003083O002DE561DEE3851EC503083O00B67E8015AA8AEB7903123O00BEC930D294123E179ED339EF920A04148EDF03083O0066EBBA5586E67350026O001840025O00E8A040025O0098AA40025O00E09040025O00CCA64003083O0063FC12AB5671FE6903083O001A309966DF3F1F99030D3O003652ECFD1355E4FF0B54F4DB3203043O009362208D03083O002B46F7DE0F584C0B03073O002B782383AA663603103O00601486B8B4A58D580F93AF82A28B411603073O00E43466E7D6C5D0026O001C4003083O00897AC7675714BD6C03063O007ADA1FB3133E03103O0084DFC1C5CEB34AA4C2C5F2C6B5639BE603073O0025D3B6ADA1A9C103083O00C43F59CD2175BEE403073O00D9975A2DB9481B03133O00F475EB1651D173F0065EF073F33471D173F20203053O0036A31C877203083O001BDE499647712FC803063O001F48BB3DE22E030D3O00F61546E54E7220C4144CC5537603073O0044A36623B2271E026O002040025O00C4AA40025O00D49B4003083O002DB5121C11E619A303063O00887ED0666878030B3O005483C846AD5E325E75A2FE03083O003118EAAE23CF325D03083O003FF7E99C7802F5EE03053O00116C929DE803133O007ED011C32EBC5ED111FE1CBF42C500E32ABB5803063O00C82BA3748D4F03083O008C332997B9FAE4AC03073O0083DF565DE3D09403123O00CD44A2A30FB0F076A1BF1BA1ED402OA5358503063O00D583252OD67D027O0040025O0018B140025O00CCAF40025O00288940025O0042B04003083O0079B208C14882A45903073O00C32AD77CB521EC03123O00384A320C20FF1F56202A2DCA085F253B36F003063O00986D39575E4503083O00152E31ABE8282C3603053O0081464B45DF030B3O0073D8F6DB79E854C4E4FD7403063O008F26AB93891C03083O00E387ADE70AEDD3C303073O00B4B0E2D9936383030A3O00E1BC2815DCAE3B0FFB8903043O0067B3D94F025O0028B340026O002240025O00BAA340025O0023B24003083O00F7C85328FB00F2D703073O0095A4AD275C926E030B3O00C634153D1B09F8341B161403063O007B9347707F7A03083O00FFC896654FC2CA9103053O0026ACADE21103093O007F1422EA5A1020C77D03043O008F2D714C03083O008BBD0828B1B61B2F03043O005C2OD87C030A3O006E21A972F85537BB41F103053O009D3B52CC20025O001EAF40025O00F89140025O00C4AF40025O0097B04003083O0064092A4B7BDA254403073O0042376C5E3F12B403113O00209F8439364C1D818C233E6D0688801F1703063O003974EDE5574703083O0099B4F9F37EE040B903073O0027CAD18D87178E03143O00CB21080423EDF63F001E2BCCED360C2D20F7EA2303063O00989F53696A52025O00989640025O0008814003083O00B2C345E6C05286D503063O003CE1A63192A903113O001A0D2A1D080B2B193D251613272D203E2703063O00674F7E4F4A61025O00408340025O00E0684003083O000B370797313C149003043O00E3585273030C3O00760CBF94157A450BB7A20C7703063O0013237FDAC76203083O002FFE1EF615F50DF103043O00827C9B6A030B3O00E6DCFFA9B7FB79B1D1E3C603083O00DFB5AB96CFC3961C03083O007F3FF7BA00423DF003053O00692C5A83CE030E3O00CAF3B78D1A3F2OF1A7B00437EBF903063O005E9F80D2D968025O0020B140025O00D0A14003083O00638E2A635985396403043O001730EB5E030A3O005EDBCA564438DB72F2E803073O00B21CBAB83D375303083O008D75CED30ABB840203083O0071DE10BAA763D5E3030C3O001907F7F2291CF4E13A06D3C603043O00964E6E9B03083O00B6C033F5AD10B85303083O0020E5A54781C47EDF030F3O00F480C88586C7CC9ED089A6C7CC9CD403063O00B5A3E9A42OE1025O00D4B140025O00B08240003A022O0012953O00014O00F2000100013O002E8800030002000100020004C93O000200010026EF3O0002000100010004C93O00020001001295000100013O0026EF00010034000100040004C93O0034000100121E000200054O00DB000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O00020002000300062O00020017000100010004C93O00170001001295000200014O002B00025O00121E000200054O00D2000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000200023O00122O000200056O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300013O00122O000400103O00122O000500116O0003000500024O00020002000300062O00020032000100010004C93O00320001001295000200014O002B000200033O001295000100123O0026EF00010068000100010004C93O00680001001295000200013O0026EF00020055000100010004C93O0055000100121E000300054O00D2000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000300043O00122O000300056O000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000400013O00122O000500193O00122O0006001A6O0004000600024O00030003000400062O00030053000100010004C93O00530001001295000300014O002B000300053O0012950002001B3O002E67001C00370001001D0004C93O003700010026EF000200370001001B0004C93O0037000100121E000300054O00DF000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000300063O00122O0001001B3O00044O006800010004C93O00370001002E67002200B5000100230004C93O00B500010026EF000100B5000100240004C93O00B50001001295000200014O00F2000300033O0026C000020072000100010004C93O00720001002E670026006E000100250004C93O006E0001001295000300013O002E6700270085000100280004C93O008500010026EF000300850001001B0004C93O0085000100121E000400054O00DF000500013O00122O000600293O00122O0007002A6O0005000700024O0004000400054O000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000400073O00122O0001002D3O00044O00B500010026C000030089000100010004C93O00890001002E67002F00730001002E0004C93O00730001001295000400013O0026EF0004008E0001001B0004C93O008E00010012950003001B3O0004C93O00730001002E670030008A000100310004C93O008A0001000E2E0001008A000100040004C93O008A000100121E000500054O00DB000600013O00122O000700323O00122O000800336O0006000800024O0005000500064O000600013O00122O000700343O00122O000800356O0006000800024O00050005000600062O000500A0000100010004C93O00A00001001295000500014O002B000500083O00127E000500056O000600013O00122O000700363O00122O000800376O0006000800024O0005000500064O000600013O00122O000700383O00122O000800396O0006000800024O00050005000600062O000500AF000100010004C93O00AF0001001295000500014O002B000500093O0012950004001B3O0004C93O008A00010004C93O007300010004C93O00B500010004C93O006E00010026EF000100E20001003A0004C93O00E2000100121E000200054O00DB000300013O00122O0004003B3O00122O0005003C6O0003000500024O0002000200034O000300013O00122O0004003D3O00122O0005003E6O0003000500024O00020002000300062O000200C5000100010004C93O00C50001001295000200014O002B0002000A3O00127E000200056O000300013O00122O0004003F3O00122O000500406O0003000500024O0002000200034O000300013O00122O000400413O00122O000500426O0003000500024O00020002000300062O000200D4000100010004C93O00D40001001295000200014O002B0002000B3O001240000200056O000300013O00122O000400433O00122O000500446O0003000500024O0002000200034O000300013O00122O000400453O00122O000500466O0003000500024O0002000200034O0002000C3O00122O000100473O0026EF000100192O01001B0004C93O00192O01001295000200013O0026C0000200E9000100010004C93O00E90001002E67004800052O0100490004C93O00052O0100121E000300054O00DB000400013O00122O0005004A3O00122O0006004B6O0004000600024O0003000300044O000400013O00122O0005004C3O00122O0006004D6O0004000600024O00030003000400062O000300F7000100010004C93O00F70001001295000300014O002B0003000D3O001240000300056O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O000400013O00122O000500503O00122O000600516O0004000600024O0003000300044O0003000E3O00122O0002001B3O000E2E001B00E5000100020004C93O00E5000100121E000300054O00DB000400013O00122O000500523O00122O000600536O0004000600024O0003000300044O000400013O00122O000500543O00122O000600556O0004000600024O00030003000400062O000300152O0100010004C93O00152O01001295000300014O002B0003000F3O001295000100563O0004C93O00192O010004C93O00E50001000E220056001D2O0100010004C93O001D2O01002E670057005F2O0100580004C93O005F2O01001295000200014O00F2000300033O0026EF0002001F2O0100010004C93O001F2O01001295000300013O0026C0000300262O01001B0004C93O00262O01002E88005A00342O0100590004C93O00342O0100121E000400054O00DF000500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000400103O00122O000100043O00044O005F2O010026EF000300222O0100010004C93O00222O01001295000400013O0026EF000400552O0100010004C93O00552O0100121E000500054O00D2000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000500113O00122O000500056O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O000600013O00122O000700653O00122O000800666O0006000800024O00050005000600062O000500532O0100010004C93O00532O01001295000500014O002B000500123O0012950004001B3O002E43006700E2FF2O00670004C93O00372O010026EF000400372O01001B0004C93O00372O010012950003001B3O0004C93O00222O010004C93O00372O010004C93O00222O010004C93O005F2O010004C93O001F2O010026C0000100632O0100680004C93O00632O01002E88006A008B2O0100690004C93O008B2O0100121E000200054O00D2000300013O00122O0004006B3O00122O0005006C6O0003000500024O0002000200034O000300013O00122O0004006D3O00122O0005006E6O0003000500024O0002000200034O000200133O00122O000200056O000300013O00122O0004006F3O00122O000500706O0003000500024O0002000200034O000300013O00122O000400713O00122O000500726O0003000500024O00020002000300062O0002007D2O0100010004C93O007D2O01001295000200014O002B000200143O00126C000200056O000300013O00122O000400733O00122O000500746O0003000500024O0002000200034O000300013O00122O000400753O00122O000500766O0003000500022O00C50002000200032O002B000200153O0004C93O00390201000E22002D008F2O0100010004C93O008F2O01002E88007700C62O0100780004C93O00C62O01001295000200013O002E88007900B32O01007A0004C93O00B32O010026EF000200B32O0100010004C93O00B32O0100121E000300054O00DB000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400062O000300A22O0100010004C93O00A22O01001295000300014O002B000300163O00127E000300056O000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O00030003000400062O000300B12O0100010004C93O00B12O01001295000300014O002B000300173O0012950002001B3O0026C0000200B72O01001B0004C93O00B72O01002E88008300902O0100840004C93O00902O0100121E000300054O00DF000400013O00122O000500853O00122O000600866O0004000600024O0003000300044O000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000300183O00122O0001003A3O00044O00C62O010004C93O00902O010026C0000100CA2O0100120004C93O00CA2O01002E430089002A0001008A0004C93O00F22O0100121E000200054O00D2000300013O00122O0004008B3O00122O0005008C6O0003000500024O0002000200034O000300013O00122O0004008D3O00122O0005008E6O0003000500024O0002000200034O000200193O00122O000200056O000300013O00122O0004008F3O00122O000500906O0003000500024O0002000200034O000300013O00122O000400913O00122O000500926O0003000500024O00020002000300062O000200E42O0100010004C93O00E42O01001295000200014O002B0002001A3O001240000200056O000300013O00122O000400933O00122O000500946O0003000500024O0002000200034O000300013O00122O000400953O00122O000500966O0003000500024O0002000200034O0002001B3O00122O000100243O0026EF00010007000100470004C93O00070001001295000200013O0026C0000200F92O01001B0004C93O00F92O01002E670097000A020100980004C93O000A020100121E000300054O00DB000400013O00122O000500993O00122O0006009A6O0004000600024O0003000300044O000400013O00122O0005009B3O00122O0006009C6O0004000600024O00030003000400062O00030007020100010004C93O00070201001295000300014O002B0003001C3O001295000100683O0004C93O000700010026EF000200F52O0100010004C93O00F52O01001295000300013O0026EF0003002E020100010004C93O002E020100121E000400054O00DB000500013O00122O0006009D3O00122O0007009E6O0005000700024O0004000400054O000500013O00122O0006009F3O00122O000700A06O0005000700024O00040004000500062O0004001D020100010004C93O001D0201001295000400014O002B0004001D3O00127E000400056O000500013O00122O000600A13O00122O000700A26O0005000700024O0004000400054O000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500062O0004002C020100010004C93O002C0201001295000400014O002B0004001E3O0012950003001B3O002E8800A6000D020100A50004C93O000D02010026EF0003000D0201001B0004C93O000D02010012950002001B3O0004C93O00F52O010004C93O000D02010004C93O00F52O010004C93O000700010004C93O003902010004C93O000200012O00C33O00017O00B13O00028O00025O0046AD40026O001440025O0062AE40025O009EB240026O00F03F03173O00476574456E656D696573496E53706C61736852616E6765026O002040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0088A440025O0040A340024O0080B3C540025O00FAA840025O006EA740030C3O00466967687452656D61696E73025O00C08D40025O00C05140025O0056A240025O00707A4003103O00426F2O73466967687452656D61696E73025O0085B340025O00A7B240025O000AAA40025O0068AC4003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O00F4AC40025O00B2A240025O00709B40025O003EAD4003163O0044656164467269656E646C79556E697473436F756E74025O004CA440025O0028A94003073O001CF9881FD33AF403053O00A14E9CEA7603073O0049735265616479025O0062B340025O00B8AC4003073O0052656269727468025O0016AB40025O007AA94003073O00B5B2CBD5B5A3C103043O00BCC7D7A9025O00D49640025O000AA240030A3O005265766974616C697A65030A3O00EE0C4972FCFD055661ED03053O00889C693F1B03063O0052657669766503093O004973496E52616E6765026O00444003063O0009896F3D0D8903043O00547BEC19026O001840026O000840025O003DB240025O00F07F40025O007EB040025O00309D40025O0024A840025O00805940025O0039B040025O00C49740030B3O00ADF1BE9ECFB390D3BF99D803063O00D6E390CAEBBD031B3O00497354616E6B42656C6F774865616C746850657263656E7461676503083O00C4B7887532B2413703083O005C8DC5E71B70D33303093O00D2FE84A891C9F186BA03053O00B1869FEAC3030D3O0089EA31AB89BCE53BE0FAB8E73903053O00A9DD8B5FC0025O00206F40025O00C05640025O0004B240025O003C9C40025O00C88340025O0066B140030C3O0053686F756C6452657475726E03093O00466F637573556E697403043O00EAAA511403063O0046BEEB1F5F42026O003440025O0030A240025O00907740025O005EA94003103O004865616C746850657263656E7461676503083O0093F015E8C7BBF01103053O0085DA827A86030D3O0008FEEDCF9CA23638BFD0C1D0A503073O00585C9F83A4BCC3025O00709540025O002AAF4003063O00A80B9E67F2D903073O00BDE04EDF2BB78B025O0080AD40025O00A89C40025O00109440025O002EAF40025O005BB040025O00D2A940026O001040025O000C9140030C3O004570696353652O74696E677303073O002313C859C4DCA903073O00DA777CAF3EA8B903073O00ADF549C8ACFE4F03043O00A4C59028025O008CAD40025O0016AE40025O00288540025O00B49240025O00DCAE40025O00F0B240025O00A06140025O00A4AB40025O003EAE4003093O0049734D6F756E746564025O00C4AD40025O00B8A84003083O0049734D6F76696E6703073O0047657454696D65025O00FAA340025O0052A440025O001CA240025O00E8904003063O0042752O665570030A3O0054726176656C466F726D03083O0042656172466F726D03073O00436174466F726D025O00AAA940025O00F2AA40025O00688040025O00149540030C3O0044656275674D652O73616765030C3O0049734368612O6E656C696E67025O003AB040025O00EEA24003073O00D323AF5F2A73F403063O0016874CC838462O033O008C3FFD03063O0081ED5098443D03073O0065A703F410124B03073O003831C864937C772O033O00CF3AAC03043O0090AC5EDF025O0068B240025O00CAAD4003073O001000A540280AB103043O0027446FC203063O00D2AFF4D77CBB03063O00D7B6C687A719027O0040025O00206340025O001EA04003073O00B946ED4F814CF903043O0028ED298A03043O00D575F7E803053O002AA7149A9803073O007EF1A5457D245903063O00412A9EC222112O033O001E374103083O008E7A47326C4D8D7B03073O0021ADF81F3710B103053O005B75C29F7803073O001E0D2D1E3AE32903073O00447A7D5E785591025O0030A440025O006C9B40025O00A8854003073O000C31E4FDE5EFC003083O00D1585E839A898AB32O033O0027AEC703083O004248C1A41C7E435100F5022O0012953O00014O00F2000100013O0026EF3O0002000100010004C93O00020001001295000100013O002E43000200EB000100020004C93O00F000010026EF000100F0000100030004C93O00F000012O003D00025O00061D0002002B00013O0004C93O002B0001001295000200014O00F2000300043O002E8800040015000100050004C93O001500010026EF00020015000100010004C93O00150001001295000300014O00F2000400043O001295000200063O000E2E0006000E000100020004C93O000E00010026EF00030017000100010004C93O00170001001295000400013O0026EF0004001A000100010004C93O001A00012O003D000500023O00208F00050005000700122O000700086O0005000700024O000500016O000500016O000500056O000500033O00044O003400010004C93O001A00010004C93O003400010004C93O001700010004C93O003400010004C93O000E00010004C93O00340001001295000200013O0026EF0002002C000100010004C93O002C00012O004A00036O002B000300013O001295000300064O002B000300033O0004C93O003400010004C93O002C00012O003D000200043O0020270002000200092O007A00020001000200066A0002003E000100010004C93O003E00012O003D000200053O00206E00020002000A2O00BB00020002000200061D0002007000013O0004C93O00700001001295000200014O00F2000300033O0026EF00020040000100010004C93O00400001001295000300013O002E88000C00540001000B0004C93O00540001000E2E00060054000100030004C93O005400012O003D000400063O0026EF000400700001000D0004C93O00700001002E67000E004D0001000F0004C93O004D00010004C93O007000012O003D000400073O00209C0004000400104O000500016O00068O0004000600024O000400063O00044O007000010026C000030058000100010004C93O00580001002E6700110043000100120004C93O00430001001295000400013O002E6700140066000100130004C93O00660001000E2E00010066000100040004C93O006600012O003D000500073O0020DD0005000500154O000600066O000700016O0005000700024O000500086O000500086O000500063O00122O000400063O002E6700170059000100160004C93O005900010026EF00040059000100060004C93O00590001001295000300063O0004C93O004300010004C93O005900010004C93O004300010004C93O007000010004C93O00400001002E88001800EF000100190004C93O00EF00012O003D000200023O00061D000200EF00013O0004C93O00EF00012O003D000200023O00206E00020002001A2O00BB00020002000200061D000200EF00013O0004C93O00EF00012O003D000200023O00206E00020002001B2O00BB00020002000200061D000200EF00013O0004C93O00EF00012O003D000200023O00206E00020002001C2O00BB00020002000200061D000200EF00013O0004C93O00EF00012O003D000200053O00206E00020002001D2O003D000400024O000500020004000200066A000200EF000100010004C93O00EF00012O003D000200053O00206E00020002000A2O00BB00020002000200066A000200EF000100010004C93O00EF00012O003D000200093O00061D000200EF00013O0004C93O00EF0001001295000200014O00F2000300043O002E67001F009B0001001E0004C93O009B00010026EF0002009B000100010004C93O009B0001001295000300014O00F2000400043O001295000200063O002E8800200094000100210004C93O009400010026EF00020094000100060004C93O009400010026EF0003009F000100010004C93O009F00012O003D000500043O0020270005000500222O007A0005000100022O0047000400053O002E67002300C8000100240004C93O00C800012O003D000500053O00206E00050005000A2O00BB00050002000200061D000500C800013O0004C93O00C800012O003D0005000A4O000F0106000B3O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500274O00050002000200062O000500B8000100010004C93O00B80001002E67002800EF000100290004C93O00EF00012O003D0005000C4O00070006000A3O00202O00060006002A4O000700076O000800016O00050008000200062O000500C2000100010004C93O00C20001002E88002B00EF0001002C0004C93O00EF00012O003D0005000B3O0012170106002D3O00122O0007002E6O000500076O00055O00044O00EF0001000EB6000600DA000100040004C93O00DA0001002E67002F00EF000100300004C93O00EF00012O003D0005000C4O00600006000A3O00202O0006000600314O000700076O000800016O00050008000200062O000500EF00013O0004C93O00EF00012O003D0005000B3O001217010600323O00122O000700336O000500076O00055O00044O00EF00012O003D0005000C4O00F40006000A3O00202O0006000600344O000700023O00202O00070007003500122O000900366O0007000900024O000700076O000800016O00050008000200062O000500EF00013O0004C93O00EF00012O003D0005000B3O001217010600373O00122O000700386O000500076O00055O00044O00EF00010004C93O009F00010004C93O00EF00010004C93O00940001001295000100393O000E2E003A00E22O0100010004C93O00E22O01001295000200014O00F2000300033O000E22000100F8000100020004C93O00F80001002E88003B00F40001003C0004C93O00F40001001295000300013O0026C0000300FD000100060004C93O00FD0001002E67003D00BE2O01003E0004C93O00BE2O01002E67004000BC2O01003F0004C93O00BC2O012O003D000400053O00206E00040004000A2O00BB00040002000200066A000400072O0100010004C93O00072O012O003D0004000D3O00061D000400BC2O013O0004C93O00BC2O01001295000400014O00F2000500063O0026EF000400B42O0100060004C93O00B42O01002E880042000B2O0100410004C93O000B2O010026EF0005000B2O0100010004C93O000B2O012O003D0007000D3O0006AA0006001D2O0100070004C93O001D2O012O003D0007000A4O00FB0008000B3O00122O000900433O00122O000A00446O0008000A00024O00070007000800202O0007000700274O00070002000200062O0006001D2O0100070004C93O001D2O012O003D0006000E4O003D000700043O0020270007000700452O003D0008000F4O00BB00070002000200061D0007003B2O013O0004C93O003B2O012O003D0007000A4O004C0008000B3O00122O000900463O00122O000A00476O0008000A00024O00070007000800202O0007000700274O00070002000200062O0007003B2O013O0004C93O003B2O012O003D000700104O00F10008000B3O00122O000900483O00122O000A00496O0008000A000200062O0007003D2O0100080004C93O003D2O012O003D000700104O00F10008000B3O00122O0009004A3O00122O000A004B6O0008000A000200062O0007003D2O0100080004C93O003D2O01002E88004C005F2O01004D0004C93O005F2O01001295000700014O00F2000800083O0026C0000700432O0100010004C93O00432O01002E43004E00FEFF2O004F0004C93O003F2O01001295000800013O002E67005000442O0100510004C93O00442O010026EF000800442O0100010004C93O00442O012O003D000900043O00207B0009000900534O000A00066O000B000C6O000D000B3O00122O000E00543O00122O000F00556O000D000F000200122O000E00566O0009000E000200122O000900523O00122O000900523O00062O000900582O0100010004C93O00582O01002E88005700BC2O0100580004C93O00BC2O0100121E000900524O0092000900023O0004C93O00BC2O010004C93O00442O010004C93O00BC2O010004C93O003F2O010004C93O00BC2O01002E4300590039000100590004C93O00982O012O003D000700053O00206E00070007005A2O00BB0007000200022O003D0008000F3O000629000700982O0100080004C93O00982O012O003D0007000A4O004C0008000B3O00122O0009005B3O00122O000A005C6O0008000A00024O00070007000800202O0007000700274O00070002000200062O000700982O013O0004C93O00982O012O003D000700104O00170008000B3O00122O0009005D3O00122O000A005E6O0008000A000200062O000700982O0100080004C93O00982O01001295000700014O00F2000800083O000E2E0001007A2O0100070004C93O007A2O01001295000800013O002E88005F007D2O0100600004C93O007D2O010026EF0008007D2O0100010004C93O007D2O012O003D000900043O0020F60009000900534O000A00066O000B000C6O000D000B3O00122O000E00613O00122O000F00626O000D000F000200122O000E00566O0009000E000200122O000900523O002E67006400BC2O0100630004C93O00BC2O0100121E000900523O00061D000900BC2O013O0004C93O00BC2O0100121E000900524O0092000900023O0004C93O00BC2O010004C93O007D2O010004C93O00BC2O010004C93O007A2O010004C93O00BC2O01001295000700014O00F2000800083O0026EF0007009A2O0100010004C93O009A2O01001295000800013O0026EF0008009D2O0100010004C93O009D2O012O003D000900043O0020C10009000900534O000A00066O000B000D3O00122O000E00566O0009000E000200122O000900523O00122O000900523O00062O000900AB2O0100010004C93O00AB2O01002E67006600BC2O0100650004C93O00BC2O0100121E000900524O0092000900023O0004C93O00BC2O010004C93O009D2O010004C93O00BC2O010004C93O009A2O010004C93O00BC2O010004C93O000B2O010004C93O00BC2O01000E22000100B82O0100040004C93O00B82O01002E67006700092O0100680004C93O00092O01001295000500014O00F2000600063O001295000400063O0004C93O00092O01001295000100693O0004C93O00E22O01002E43006A003BFF2O006A0004C93O00F900010026EF000300F9000100010004C93O00F90001001295000400013O0026EF000400DA2O0100010004C93O00DA2O0100121E0005006B4O00200106000B3O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O0006000B3O00122O0007006E3O00122O0008006F6O0006000800024O0005000500062O002B000500113O002E88007000D92O0100710004C93O00D92O012O003D000500053O00206E00050005001C2O00BB00050002000200061D000500D92O013O0004C93O00D92O012O00C33O00013O001295000400063O0026EF000400C32O0100060004C93O00C32O01001295000300063O0004C93O00F900010004C93O00C32O010004C93O00F900010004C93O00E22O010004C93O00F40001002E670072002B020100730004C93O002B02010026EF0001002B020100690004C93O002B0201001295000200014O00F2000300033O002E4300743O000100740004C93O00E82O010026EF000200E82O0100010004C93O00E82O01001295000300013O002E6700760004020100750004C93O000402010026EF00030004020100010004C93O00040201002E88007700F92O0100780004C93O00F92O012O003D000400053O00206E0004000400792O00BB00040002000200061D000400F92O013O0004C93O00F92O012O00C33O00013O002E88007B00030201007A0004C93O000302012O003D000400053O00206E00040004007C2O00BB00040002000200061D0004000302013O0004C93O0003020100121E0004007D4O007A0004000100022O002B000400123O001295000300063O002E67007E00ED2O01007F0004C93O00ED2O010026EF000300ED2O0100060004C93O00ED2O01002E8800810026020100800004C93O002602012O003D000400053O0020D30004000400824O0006000A3O00202O0006000600834O00040006000200062O0004001F020100010004C93O001F02012O003D000400053O0020D30004000400824O0006000A3O00202O0006000600844O00040006000200062O0004001F020100010004C93O001F02012O003D000400053O0020150104000400824O0006000A3O00202O0006000600854O00040006000200062O0004002602013O0004C93O0026020100121E0004007D4O007A0004000100022O003D000500124O00800004000400050026A500040026020100060004C93O002602012O00C33O00013O001295000100033O0004C93O002B02010004C93O00ED2O010004C93O002B02010004C93O00E82O010026C00001002F020100390004C93O002F0201002E670087006E020100860004C93O006E02012O003D000200113O00066A00020034020100010004C93O00340201002E880089004C020100880004C93O004C0201001295000200013O0026EF00020040020100010004C93O004002012O003D000300134O007A0003000100020012EE0003008A3O00121E0003008A3O00061D0003003F02013O0004C93O003F020100121E0003008A4O0092000300023O001295000200063O0026EF00020035020100060004C93O003502012O003D000300144O007A0003000100020012EE0003008A3O00121E0003008A3O00061D0003004C02013O0004C93O004C020100121E0003008A4O0092000300023O0004C93O004C02010004C93O003502012O003D000200053O00206E00020002008B2O00BB00020002000200066A000200F4020100010004C93O00F402012O003D000200053O00206E00020002000A2O00BB00020002000200061D0002006502013O0004C93O00650201001295000200014O00F2000300033O0026C00002005C020100010004C93O005C0201002E67008C00580201007A0004C93O005802012O003D000400154O007A0004000100022O0047000300043O00061D000300F402013O0004C93O00F402012O0092000300023O0004C93O00F402010004C93O005802010004C93O00F402012O003D000200093O00061D000200F402013O0004C93O00F402012O003D000200164O007A00020001000200061D000200F402013O0004C93O00F402012O0092000200023O0004C93O00F40201002E43008D00330001008D0004C93O00A102010026EF000100A1020100060004C93O00A10201001295000200013O0026EF0002008E020100010004C93O008E020100121E0003006B4O00090004000B3O00122O0005008E3O00122O0006008F6O0004000600024O0003000300044O0004000B3O00122O000500903O00122O000600916O0004000600024O0003000300044O00035O00122O0003006B6O0004000B3O00122O000500923O00122O000600936O0004000600024O0003000300044O0004000B3O00122O000500943O00122O000600956O0004000600024O0003000300044O000300173O00122O000200063O002E6700970073020100960004C93O007302010026EF00020073020100060004C93O0073020100121E0003006B4O00DF0004000B3O00122O000500983O00122O000600996O0004000600024O0003000300044O0004000B3O00122O0005009A3O00122O0006009B6O0004000600024O0003000300044O0003000E3O00122O0001009C3O00044O00A102010004C93O007302010026EF000100D20201009C0004C93O00D20201001295000200013O0026C0000200A8020100010004C93O00A80201002E43009D001B0001009E0004C93O00C1020100121E0003006B4O00090004000B3O00122O0005009F3O00122O000600A06O0004000600024O0003000300044O0004000B3O00122O000500A13O00122O000600A26O0004000600024O0003000300044O000300183O00122O0003006B6O0004000B3O00122O000500A33O00122O000600A46O0004000600024O0003000300044O0004000B3O00122O000500A53O00122O000600A66O0004000600024O0003000300044O000300193O00122O000200063O0026EF000200A4020100060004C93O00A4020100121E0003006B4O00DF0004000B3O00122O000500A73O00122O000600A86O0004000600024O0003000300044O0004000B3O00122O000500A93O00122O000600AA6O0004000600024O0003000300044O0003001A3O00122O0001003A3O00044O00D202010004C93O00A402010026C0000100D6020100010004C93O00D60201002E4300AB0031FD2O00590004C93O00050001001295000200013O0026C0000200DB020100060004C93O00DB0201002E6700AC00E9020100AD0004C93O00E9020100121E0003006B4O00DF0004000B3O00122O000500AE3O00122O000600AF6O0004000600024O0003000300044O0004000B3O00122O000500B03O00122O000600B16O0004000600024O0003000300044O000300093O00122O000100063O00044O000500010026EF000200D7020100010004C93O00D702012O003D0003001B4O00D90003000100014O0003001C6O00030001000100122O000200063O00044O00D702010004C93O000500010004C93O00F402010004C93O000200012O00C33O00017O00103O00028O00025O002OAA40026O00F03F025O00EFB140025O00E8A740025O00B8A940025O00EC964003053O005072696E7403233O00C28EB903A3A7F19FA318A2F5D499BF1EA8F5C284BE16B8BCFF85EA15B5F5D59BA314E203063O00D590EBCA77CC030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03263O00111DCD3E27314C3711D12468075F3611DA6A10635B63498E647A6D1D7358FC336801422C15F503073O002D4378BE4A4843025O00689540026O00834000403O0012953O00014O00F2000100023O002E4300020037000100020004C93O003900010026EF3O0039000100030004C93O003900010026C00001000A000100010004C93O000A0001002E6700040006000100050004C93O00060001001295000200013O0026C00002000F000100010004C93O000F0001002E8800060030000100070004C93O00300001001295000300013O0026EF00030014000100030004C93O00140001001295000200033O0004C93O003000010026EF00030010000100010004C93O00100001001295000400013O0026EF00040028000100010004C93O002800012O003D00055O0020E70005000500084O000600013O00122O000700093O00122O0008000A6O000600086O00053O000100122O0005000B3O00202O00050005000C4O000600013O00122O0007000D3O00122O0008000E6O000600086O00053O000100122O000400033O0026C00004002C000100030004C93O002C0001002E43000F00EDFF2O00100004C93O00170001001295000300033O0004C93O001000010004C93O001700010004C93O001000010026EF0002000B000100030004C93O000B00012O003D000300024O00A90003000100010004C93O003F00010004C93O000B00010004C93O003F00010004C93O000600010004C93O003F00010026EF3O0002000100010004C93O00020001001295000100014O00F2000200023O0012953O00033O0004C93O000200012O00C33O00017O00", GetFEnv(), ...);

