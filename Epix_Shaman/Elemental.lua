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
											if (Enum > 0) then
												Env[Inst[3]] = Stk[Inst[2]];
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
										elseif (Enum > 2) then
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 6) then
										Stk[Inst[2]] = Stk[Inst[3]];
									elseif (Enum == 7) then
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
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum > 9) then
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Inst[2] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 11) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 14) then
									if (Enum > 13) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 16) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									Stk[Inst[2]] = Inst[3];
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
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
										if (Enum > 18) then
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
									elseif (Enum == 20) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, A + Inst[3]);
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 24) then
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
								elseif (Enum == 25) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum > 27) then
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									elseif (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 29) then
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
								elseif (Enum > 30) then
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
							elseif (Enum <= 33) then
								if (Enum == 32) then
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
							elseif (Enum <= 34) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum == 35) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum > 37) then
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
											Stk[A] = Stk[A](Stk[A + 1]);
										end
									elseif (Enum > 39) then
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
								elseif (Enum <= 42) then
									if (Enum > 41) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 43) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								elseif (Enum > 44) then
									local B;
									local A;
									A = Inst[2];
									Stk[A](Stk[A + 1]);
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
									Stk[A](Stk[A + 1]);
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 50) then
								if (Enum <= 47) then
									if (Enum > 46) then
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
								elseif (Enum <= 48) then
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
								elseif (Enum > 49) then
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
								if (Enum == 51) then
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
									Stk[A] = Stk[A]();
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
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 53) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum == 56) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 58) then
									local B;
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
									A = Inst[2];
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
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Inst[2] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 61) then
								if (Enum > 60) then
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
							elseif (Enum <= 62) then
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
								Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 63) then
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
							end
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum == 65) then
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
							elseif (Enum <= 67) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 68) then
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
						elseif (Enum <= 71) then
							if (Enum == 70) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 72) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 73) then
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
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 111) then
						if (Enum <= 92) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum == 75) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
										end
									elseif (Enum > 77) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									else
										Stk[Inst[2]] = {};
									end
								elseif (Enum <= 80) then
									if (Enum > 79) then
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
								elseif (Enum <= 81) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 82) then
									local A = Inst[2];
									local Results = {Stk[A]()};
									local Limit = Inst[4];
									local Edx = 0;
									for Idx = A, Limit do
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
							elseif (Enum <= 87) then
								if (Enum <= 85) then
									if (Enum > 84) then
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
										Stk[Inst[2]] = Inst[3];
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 89) then
								if (Enum == 88) then
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
							elseif (Enum <= 90) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 91) then
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
						elseif (Enum <= 101) then
							if (Enum <= 96) then
								if (Enum <= 94) then
									if (Enum > 93) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 95) then
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
									Stk[Inst[2]] = #Stk[Inst[3]];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 98) then
								if (Enum > 97) then
									local A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 100) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
										if (Mvm[1] == 6) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								end
							elseif (Enum <= 104) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 105) then
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
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 108) then
							if (Enum > 107) then
								local B;
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 109) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 110) then
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
					elseif (Enum <= 130) then
						if (Enum <= 120) then
							if (Enum <= 115) then
								if (Enum <= 113) then
									if (Enum == 112) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 114) then
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
							elseif (Enum <= 117) then
								if (Enum > 116) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 118) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 119) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 125) then
							if (Enum <= 122) then
								if (Enum == 121) then
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
									A = Inst[2];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 123) then
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
							elseif (Enum > 124) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 127) then
							if (Enum == 126) then
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
						elseif (Enum <= 128) then
							local B;
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Enum == 129) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 139) then
						if (Enum <= 134) then
							if (Enum <= 132) then
								if (Enum > 131) then
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
									do
										return;
									end
								end
							elseif (Enum == 133) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 136) then
							if (Enum == 135) then
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
						elseif (Enum <= 137) then
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
					elseif (Enum <= 144) then
						if (Enum <= 141) then
							if (Enum == 140) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 142) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 143) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 147) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 148) then
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
											VIP = Inst[3];
										end
									elseif (Enum == 152) then
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
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 155) then
									if (Enum == 154) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										local A = Inst[2];
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									end
								elseif (Enum <= 156) then
									Stk[Inst[2]] = not Stk[Inst[3]];
								elseif (Enum > 157) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 162) then
								if (Enum <= 160) then
									if (Enum > 159) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
								elseif (Enum == 161) then
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							elseif (Enum <= 164) then
								if (Enum == 163) then
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
							elseif (Enum <= 165) then
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
							elseif (Enum > 166) then
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
						elseif (Enum <= 176) then
							if (Enum <= 171) then
								if (Enum <= 169) then
									if (Enum > 168) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									end
								elseif (Enum == 170) then
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
							elseif (Enum <= 173) then
								if (Enum == 172) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 174) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 175) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 181) then
							if (Enum <= 178) then
								if (Enum > 177) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum > 180) then
								Stk[Inst[2]]();
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
						elseif (Enum <= 183) then
							if (Enum == 182) then
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
						elseif (Enum <= 184) then
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
						elseif (Enum > 185) then
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
							local B = Inst[3];
							for Idx = A, B do
								Stk[Idx] = Vararg[Idx - A];
							end
						end
					elseif (Enum <= 205) then
						if (Enum <= 195) then
							if (Enum <= 190) then
								if (Enum <= 188) then
									if (Enum == 187) then
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
								elseif (Enum > 189) then
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
							elseif (Enum <= 193) then
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 194) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 200) then
							if (Enum <= 197) then
								if (Enum == 196) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 199) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 203) then
							local B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						elseif (Enum > 204) then
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
					elseif (Enum <= 214) then
						if (Enum <= 209) then
							if (Enum <= 207) then
								if (Enum == 206) then
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
							elseif (Enum > 208) then
								Stk[Inst[2]]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 211) then
							if (Enum == 210) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 212) then
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
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 213) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 219) then
						if (Enum <= 216) then
							if (Enum > 215) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 217) then
							local B;
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
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Enum == 218) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 221) then
						if (Enum > 220) then
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
							Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]]();
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
					elseif (Enum <= 222) then
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
					elseif (Enum > 223) then
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
				elseif (Enum <= 262) then
					if (Enum <= 243) then
						if (Enum <= 233) then
							if (Enum <= 228) then
								if (Enum <= 226) then
									if (Enum > 225) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 227) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 230) then
								if (Enum == 229) then
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
							elseif (Enum <= 231) then
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
						elseif (Enum <= 238) then
							if (Enum <= 235) then
								if (Enum == 234) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 236) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 237) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
						elseif (Enum <= 240) then
							if (Enum > 239) then
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
						elseif (Enum <= 241) then
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
						elseif (Enum == 242) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 252) then
						if (Enum <= 247) then
							if (Enum <= 245) then
								if (Enum > 244) then
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
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum > 246) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum <= 249) then
							if (Enum == 248) then
								Stk[Inst[2]] = Inst[3] ~= 0;
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 250) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 251) then
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
					elseif (Enum <= 257) then
						if (Enum <= 254) then
							if (Enum == 253) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
						elseif (Enum <= 255) then
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
						elseif (Enum > 256) then
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
							VIP = Inst[3];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
						end
					elseif (Enum <= 259) then
						if (Enum > 258) then
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
					elseif (Enum <= 260) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 261) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
						end
					elseif (Stk[Inst[2]] < Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 281) then
					if (Enum <= 271) then
						if (Enum <= 266) then
							if (Enum <= 264) then
								if (Enum == 263) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 265) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 268) then
							if (Enum == 267) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 269) then
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
						elseif (Enum == 270) then
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
					elseif (Enum <= 276) then
						if (Enum <= 273) then
							if (Enum > 272) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
						elseif (Enum <= 274) then
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
						elseif (Enum > 275) then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 278) then
						if (Enum > 277) then
							local B;
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
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						else
							local Edx;
							local Results, Limit;
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 279) then
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
						Stk[Inst[2]] = Inst[3];
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 280) then
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
				elseif (Enum <= 290) then
					if (Enum <= 285) then
						if (Enum <= 283) then
							if (Enum == 282) then
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
						elseif (Enum == 284) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 287) then
						if (Enum > 286) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 289) then
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
						end
					elseif (Enum <= 293) then
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
					elseif (Enum > 294) then
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
				elseif (Enum <= 297) then
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
				elseif (Enum > 299) then
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
VMCall("LOL!303O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403053O005574696C7303063O00506C6179657203093O004D6F7573654F7665722O033O0050657403063O0054617267657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C030C3O0047657454696D656C6F63616C03143O00476574576561706F6E456E6368616E74496E666F03063O005368616D616E03093O00456C656D656E74616C03103O005265676973746572466F724576656E7403243O001D123D922FCE1E052O10309E2BD412051912209A35C21B140818269526C8091412162C9F03083O00555C5169DB798B4103143O00D196717752FAD98C637559F3D18C796B43EBDC9103063O00BF9DD330251C030E3O005072696D6F726469616C5761766503163O005265676973746572496E466C69676874452O66656374024O00E8F7134103103O005265676973746572496E466C6967687403093O004C6176614275727374024O0080B3C540028O0003063O0053657441504C025O0060704000AC012O0012D53O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004973O000A00010012E5000300063O0020B10004000300070012E5000500083O0020B10005000500090012E5000600083O0020B100060006000A00066600073O000100062O00063O00064O00068O00063O00044O00063O00014O00063O00024O00063O00054O00780008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000D001100202O0010000D001200202O0011000D00130020B10012000D001400201F0113000B001500202O0014000B001600202O0015000B001700122O0016000D3O00202O00170016001800202O00180016001900202O00190016001A00202O001A0016001B00202O001A001A001C00202O001A001A001D0020B1001B0016001B0020C4001B001B001C00202O001B001B001E00122O001C001F3O00122O001D00206O001E001E6O001F8O00208O00218O00228O00236O00850024005C3O0020D2005D0013002100202O005D005D002200202O005E0015002100202O005E005E002200202O005F0018002100202O005F005F00224O00605O00202O00610016001B00202O00610061001C00066600620001000100022O00063O005D4O00063O00613O00209B0063000B002300066600650002000100012O00063O00624O006C006600073O00122O006700243O00122O006800256O006600686O00633O000100202O0063000B002300066600650003000100012O00063O005D4O0080006600073O00122O006700263O00122O006800276O006600686O00633O000100202O0063005D002800202O00630063002900122O0065002A6O00630065000100202O0063005D002800209B00630063002B2O002D00630002000100202O0063005D002C00202O00630063002B4O00630002000100122O0063002D3O00122O0064002D6O006500683O00122O0069002E3O00122O006A002E3O000666006B0004000100012O00063O001C3O000666006C0005000100012O00063O005D3O000666006D0006000100012O00063O005D3O000666006E0007000100012O00063O005D3O000666006F0008000100012O00063O005D3O00066600700009000100012O00063O005D3O0006660071000A000100012O00063O005D3O0006660072000B000100032O00063O000F4O00063O005D4O00063O006A3O0006660073000C000100022O00063O000F4O00063O005D3O0006660074000D000100022O00063O000F4O00063O005D3O0006660075000E000100022O00063O000F4O00063O005D3O0006660076000F000100062O00063O005D4O00063O00234O00063O00614O00063O00194O00063O005F4O00063O00073O00066600770010000100062O00063O005B4O00063O000F4O00063O005C4O00063O005D4O00063O00194O00063O00073O00066600780011000100142O00063O005D4O00063O00444O00063O00614O00063O00484O00063O00494O00063O00194O00063O00074O00063O005E4O00063O00564O00063O000F4O00063O00584O00063O005F4O00063O00554O00063O00574O00063O00594O00063O00434O00063O00474O00063O00424O00063O00454O00063O00463O00066600790012000100042O00063O001E4O00063O00614O00063O00604O00063O00213O000666007A00130001000F2O00063O000F4O00063O005D4O00063O00194O00063O00124O00063O00074O00063O002C4O00063O00274O00063O002D4O00063O003D4O00063O00224O00063O002E4O00063O003E4O00063O00544O00063O00644O00063O002A3O000666007B00140001002F2O00063O005D4O00063O002A4O00063O006A4O00063O00194O00063O00124O00063O00074O00063O00294O00063O00754O00063O00694O00063O002B4O00063O000F4O00063O00244O00063O002C4O00063O00734O00063O00614O00063O00684O00063O006F4O00063O00324O00063O00384O00063O00214O00063O00544O00063O00644O00063O00344O00063O00394O00063O002E4O00063O003E4O00063O00224O00063O00744O00063O002F4O00063O006C4O00063O006B4O00063O00724O00063O001A4O00063O00334O00063O003A4O00063O005F4O00063O002D4O00063O003D4O00063O00284O00063O006D4O00063O006E4O00063O00314O00063O00374O00063O00274O00063O00264O00063O00714O00063O00253O000666007C00150001002C2O00063O005D4O00063O00294O00063O00754O00063O000F4O00063O00194O00063O00124O00063O00074O00063O002C4O00063O00744O00063O00614O00063O00684O00063O00704O00063O00274O00063O00244O00063O00734O00063O00694O00063O006A4O00063O00724O00063O00264O00063O002A4O00063O00114O00063O002B4O00063O00314O00063O00374O00063O00214O00063O00544O00063O00644O00063O00324O00063O00384O00063O00344O00063O00394O00063O002F4O00063O00334O00063O003A4O00063O005F4O00063O002D4O00063O003D4O00063O00224O00063O006F4O00063O006C4O00063O002E4O00063O003E4O00063O00174O00063O00253O000666007D0016000100102O00063O005D4O00063O000F4O00063O00074O00063O00194O00063O001E4O00063O00774O00063O00104O00063O005F4O00063O00654O00063O00664O00063O001D4O00063O00124O00063O00304O00063O001F4O00063O00614O00063O007A3O000666007E0017000100202O00063O004E4O00063O001E4O00063O00764O00063O005D4O00063O005A4O00063O00234O00063O004D4O00063O000F4O00063O00614O00063O00124O00063O00194O00063O00074O00063O00204O00063O00694O00063O006A4O00063O007B4O00063O00544O00063O00644O00063O00364O00063O003C4O00063O00214O00063O00354O00063O003B4O00063O00794O00063O007C4O00063O004F4O00063O004A4O00063O005F4O00063O004B4O00063O004C4O00063O00504O00063O00783O000666007F0018000100172O00063O00074O00063O00294O00063O002A4O00063O002B4O00063O003E4O00063O003A4O00063O00384O00063O00394O00063O003D4O00063O002C4O00063O002D4O00063O00334O00063O00324O00063O00344O00063O00374O00063O00244O00063O00254O00063O00264O00063O00274O00063O002E4O00063O002F4O00063O00304O00063O00313O00066600800019000100122O00063O003F4O00063O00074O00063O00404O00063O00414O00063O00424O00063O00434O00063O00444O00063O00454O00063O00464O00063O00474O00063O005B4O00063O005C4O00063O005A4O00063O00484O00063O00494O00063O004A4O00063O004B4O00063O004C3O0006660081001A000100122O00063O004F4O00063O00074O00063O00504O00063O00584O00063O00574O00063O00594O00063O00544O00063O00514O00063O00524O00063O00354O00063O00364O00063O003B4O00063O003C4O00063O00564O00063O00554O00063O00534O00063O004E4O00063O004D3O0006660082001B0001001E2O00063O00804O00063O007F4O00063O00814O00063O00234O00063O00074O00063O00224O00063O000F4O00063O00674O00063O00684O00063O00124O00063O00204O00063O00694O00063O006A4O00063O001F4O00063O00214O00063O004E4O00063O001E4O00063O005D4O00063O00614O00063O005F4O00063O00644O00063O000B4O00063O00634O00063O007E4O00063O007D4O00063O00764O00063O004F4O00063O004C4O00063O004A4O00063O004B3O0006660083001C000100042O00063O005D4O00063O00624O00063O00164O00063O00073O00207B00840016002F00122O008500306O008600826O008700836O0084008700016O00013O001D3O00023O00026O00F03F026O00704002264O006B00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AE00076O0026010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00AE000C00034O001E010D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O004E000C6O00C9000A3O0002002023000A000A00022O00460009000A4O006200073O000100046F0003000500012O00AE000300054O0006000400024O00E4000300044O000501036O00833O00017O00043O00030D3O00436C65616E7365537069726974030B3O004973417661696C61626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O6673000B4O000B016O00206O000100206O00026O0002000200064O000A00013O0004973O000A00012O00AE3O00014O00AE000100013O0020B100010001000400101C3O000300012O00833O00019O003O00034O00AE8O00B53O000100012O00833O00017O00073O00028O00026O00F03F03093O004C617661427572737403103O005265676973746572496E466C69676874030E3O005072696D6F726469616C5761766503163O005265676973746572496E466C69676874452O66656374024O00E8F7134100163O0012C13O00013O0026043O0008000100020004973O000800012O00AE00015O0020B100010001000300209B0001000100042O00EB0001000200010004973O001500010026043O0001000100010004973O000100012O00AE00015O00203E00010001000500202O00010001000600122O000300076O0001000300014O00015O00202O00010001000500202O0001000100044O00010002000100124O00023O00044O000100012O00833O00017O00033O0003063O005368616D616E030E3O004C61737454333032706342752O66026O00444000084O00A09O003O0001000200122O000100013O00202O0001000100028O000100104O00038O00028O00017O00023O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O6601063O00206100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00053O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F446965026O00144001133O0020092O013O00014O00035O00202O0003000300024O00010003000200062O0001001100013O0004973O0011000100209B00013O00032O009800035O00202O0003000300024O00010003000200202O00023O00044O00020002000200202O00020002000500062O00010010000100020004973O001000012O00ED00016O00F8000100014O0047000100024O00833O00017O00063O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F446965026O001440028O0001193O0020092O013O00014O00035O00202O0003000300024O00010003000200062O0001001700013O0004973O0017000100209B00013O00032O00A700035O00202O0003000300024O00010003000200202O00023O00044O00020002000200202O00020002000500062O00010015000100020004973O0015000100209B00013O00032O00AE00035O0020B10003000300022O009E000100030002000E9D00060016000100010004973O001600012O00ED00016O00F8000100014O0047000100024O00833O00017O00023O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6601063O00206100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O66027O0040010A3O00205600013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004973O000700012O00ED00016O00F8000100014O0047000100024O00833O00017O00023O00030D3O00446562752O6652656D61696E7303123O004C696768746E696E67526F64446562752O6601063O00206100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000D3O00028O0003093O004D61656C7374726F6D03093O00497343617374696E67030E3O00456C656D656E74616C426C617374025O00C0524003073O0049636566757279026O001040026O003540030D3O004C696768746E696E67426F6C74026O00244003093O004C6176614275727374026O002840030E3O00436861696E4C696768746E696E6700483O0012C13O00014O0085000100013O0026043O0002000100010004973O000200012O00AE00025O0020790002000200024O0002000200024O000100026O00025O00202O0002000200034O00020002000200062O0002000F000100010004973O000F00012O0047000100023O0004973O004700012O00AE00025O0020090102000200034O000400013O00202O0004000400044O00020004000200062O0002001900013O0004973O0019000100200E0102000100052O0047000200023O0004973O004700012O00AE00025O0020090102000200034O000400013O00202O0004000400064O00020004000200062O0002002400013O0004973O002400010020030102000100070020030102000200082O0047000200023O0004973O004700012O00AE00025O0020090102000200034O000400013O00202O0004000400094O00020004000200062O0002002E00013O0004973O002E000100200301020001000A2O0047000200023O0004973O004700012O00AE00025O0020090102000200034O000400013O00202O00040004000B4O00020004000200062O0002003800013O0004973O0038000100200301020001000C2O0047000200023O0004973O004700012O00AE00025O0020090102000200034O000400013O00202O00040004000D4O00020004000200062O0002004400013O0004973O004400012O00AE000200023O0010A80002000700022O00F70002000100022O0047000200023O0004973O004700012O0047000100023O0004973O004700010004973O000200012O00833O00017O000C3O00028O00026O00F03F03093O00497343617374696E6703093O004C6176614275727374030E3O00456C656D656E74616C426C61737403073O0049636566757279030D3O004C696768746E696E67426F6C74030E3O00436861696E4C696768746E696E6703133O004D61737465726F66746865456C656D656E7473030B3O004973417661696C61626C6503063O0042752O66557003173O004D61737465726F66746865456C656D656E747342752O6600523O0012C13O00014O0085000100013O0026043O003F000100020004973O003F00012O00AE00025O00209B0002000200032O00250002000200020006AA0002000B000100010004973O000B00012O0047000100023O0004973O005100012O00AE00025O0020090102000200034O000400013O00202O0004000400044O00020004000200062O0002001500013O0004973O001500012O00F8000200014O0047000200023O0004973O005100012O00AE00025O0020090102000200034O000400013O00202O0004000400054O00020004000200062O0002001F00013O0004973O001F00012O00F800026O0047000200023O0004973O005100012O00AE00025O0020090102000200034O000400013O00202O0004000400064O00020004000200062O0002002900013O0004973O002900012O00F800026O0047000200023O0004973O005100012O00AE00025O0020090102000200034O000400013O00202O0004000400074O00020004000200062O0002003300013O0004973O003300012O00F800026O0047000200023O0004973O005100012O00AE00025O0020090102000200034O000400013O00202O0004000400084O00020004000200062O0002003D00013O0004973O003D00012O00F800026O0047000200023O0004973O005100012O0047000100023O0004973O005100010026043O0002000100010004973O000200012O00AE000200013O0020B100020002000900209B00020002000A2O00250002000200020006AA00020049000100010004973O004900012O00F800026O0047000200024O00AE00025O00209A00020002000B4O000400013O00202O00040004000C4O0002000400024O000100023O00124O00023O00044O000200012O00833O00017O00073O00028O00026O00F03F03093O00497343617374696E67030B3O0053746F726D6B2O65706572030B3O004973417661696C61626C6503063O0042752O665570030F3O0053746F726D6B2O6570657242752O66002A3O0012C13O00014O0085000100013O0026043O0017000100020004973O001700012O00AE00025O00209B0002000200032O00250002000200020006AA0002000B000100010004973O000B00012O0047000100023O0004973O002900012O00AE00025O0020090102000200034O000400013O00202O0004000400044O00020004000200062O0002001500013O0004973O001500012O00F8000200014O0047000200023O0004973O002900012O0047000100023O0004973O002900010026043O0002000100010004973O000200012O00AE000200013O0020B100020002000400209B0002000200052O00250002000200020006AA00020021000100010004973O002100012O00F800026O0047000200024O00AE00025O00209A0002000200064O000400013O00202O0004000400074O0002000400024O000100023O00124O00023O00044O000200012O00833O00017O00073O00028O00026O00F03F03093O00497343617374696E6703073O0049636566757279030B3O004973417661696C61626C6503063O0042752O665570030B3O004963656675727942752O66002A3O0012C13O00014O0085000100013O0026043O0017000100020004973O001700012O00AE00025O00209B0002000200032O00250002000200020006AA0002000B000100010004973O000B00012O0047000100023O0004973O002900012O00AE00025O0020090102000200034O000400013O00202O0004000400044O00020004000200062O0002001500013O0004973O001500012O00F8000200014O0047000200023O0004973O002900012O0047000100023O0004973O00290001000E3A0001000200013O0004973O000200012O00AE000200013O0020B100020002000400209B0002000200052O00250002000200020006AA00020021000100010004973O002100012O00F800026O0047000200024O00AE00025O00209A0002000200064O000400013O00202O0004000400074O0002000400024O000100023O00124O00023O00044O000200012O00833O00017O00073O00030D3O00436C65616E736553706972697403073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00394003123O00436C65616E7365537069726974466F63757303153O00DC13F11D34CC1ACB0F2AD60DFD087ADB16E70C3FD303053O005ABF7F947C001B4O000B016O00206O000100206O00026O0002000200064O001A00013O0004973O001A00012O00AE3O00013O000618012O001A00013O0004973O001A00012O00AE3O00023O0020B15O00030012C1000100044O00253O00020002000618012O001A00013O0004973O001A00012O00AE3O00034O00AE000100043O0020B10001000100052O00253O00020002000618012O001A00013O0004973O001A00012O00AE3O00053O0012C1000100063O0012C1000200074O00E43O00024O0005017O00833O00017O00053O0003103O004865616C746850657263656E74616765030C3O004865616C696E67537572676503073O004973526561647903163O0070822F1B718929286B923C107DC72612798B6E18778403043O007718E74E001B4O00AE7O000618012O001A00013O0004973O001A00012O00AE3O00013O00209B5O00012O00253O000200022O00AE000100023O0006863O001A000100010004973O001A00012O00AE3O00033O0020B15O000200209B5O00032O00253O00020002000618012O001A00013O0004973O001A00012O00AE3O00044O00AE000100033O0020B10001000100022O00253O00020002000618012O001A00013O0004973O001A00012O00AE3O00053O0012C1000100043O0012C1000200054O00E43O00024O0005017O00833O00017O001B3O00028O00026O00F03F03123O004865616C696E6753747265616D546F74656D03073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503203O008A28A446D54E16BD3EB158D9411CBD39AA5ED94D518628A34FD253189428E51903073O0071E24DC52ABC20030B3O004865616C746873746F6E6503103O004865616C746850657263656E7461676503173O003213F5B92E1EE7A13518F1F53E13F2B03405FDA33F56A703043O00D55A7694027O004003193O00692BB2442O4826BD584A1B06B157415220B3167D543ABD594303053O002D3B4ED43603173O0052656672657368696E674865616C696E67506F74696F6E03253O0002538599833DA5F91E51C32O832FA1F91E51C39B893AA4FF1E16878E802BA3E3194086CBD203083O00907036E3EBE64ECD031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O00B73A0AFDDD4CB22404F9C248F3200AFDDC52BD2F4FECDF4FBA2701BCD45EB52D01EFD94DB603063O003BD3486F9CB0030B3O0041737472616C536869667403183O004F94F73F4F8BDC3E468EE5390E83E62B4B89F0245882A37C03043O004D2EE78303113O00416E6365737472616C47756964616E6365031E3O00BB5AB545A940A441B66BB155B350B74EB951F644BF52B34EA95DA045FA0603043O0020DA34D600B03O0012C13O00013O0026043O0039000100020004973O003900012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01001E00013O0004973O001E00012O00AE000100013O0006182O01001E00013O0004973O001E00012O00AE000100023O0020F50001000100054O000200036O000300046O00010003000200062O0001001E00013O0004973O001E00012O00AE000100054O00AE00025O0020B10002000200032O00250001000200020006182O01001E00013O0004973O001E00012O00AE000100063O0012C1000200063O0012C1000300074O00E4000100034O00052O016O00AE000100073O0020B100010001000800209B0001000100042O00250001000200020006182O01003800013O0004973O003800012O00AE000100083O0006182O01003800013O0004973O003800012O00AE000100093O00209B0001000100092O00250001000200022O00AE0002000A3O00068600010038000100020004973O003800012O00AE000100054O00AE0002000B3O0020B10002000200082O00250001000200020006182O01003800013O0004973O003800012O00AE000100063O0012C10002000A3O0012C10003000B4O00E4000100034O00052O015O0012C13O000C3O0026043O00760001000C0004973O007600012O00AE0001000C3O0006182O0100AF00013O0004973O00AF00012O00AE000100093O00209B0001000100092O00250001000200022O00AE0002000D3O000686000100AF000100020004973O00AF00010012C1000100013O00260400010045000100010004973O004500012O00AE0002000E4O00D3000300063O00122O0004000D3O00122O0005000E6O00030005000200062O0002005F000100030004973O005F00012O00AE000200073O0020B100020002000F00209B0002000200042O00250002000200020006180102005F00013O0004973O005F00012O00AE000200054O00AE0003000B3O0020B100030003000F2O00250002000200020006180102005F00013O0004973O005F00012O00AE000200063O0012C1000300103O0012C1000400114O00E4000200044O000501026O00AE0002000E3O002604000200AF000100120004973O00AF00012O00AE000200073O0020B100020002001300209B0002000200042O0025000200020002000618010200AF00013O0004973O00AF00012O00AE000200054O00AE0003000B3O0020B100030003000F2O0025000200020002000618010200AF00013O0004973O00AF00012O00AE000200063O0012A3000300143O00122O000400156O000200046O00025O00044O00AF00010004973O004500010004973O00AF00010026043O0001000100010004973O000100012O00AE00015O0020B100010001001600209B0001000100042O00250001000200020006182O01009200013O0004973O009200012O00AE0001000F3O0006182O01009200013O0004973O009200012O00AE000100093O00209B0001000100092O00250001000200022O00AE000200103O00068600010092000100020004973O009200012O00AE000100054O00AE00025O0020B10002000200162O00250001000200020006182O01009200013O0004973O009200012O00AE000100063O0012C1000200173O0012C1000300184O00E4000100034O00052O016O00AE00015O0020B100010001001900209B0001000100042O00250001000200020006182O0100AD00013O0004973O00AD00012O00AE000100113O0006182O0100AD00013O0004973O00AD00012O00AE000100023O0020F50001000100054O000200126O000300136O00010003000200062O000100AD00013O0004973O00AD00012O00AE000100054O00AE00025O0020B10002000200192O00250001000200020006182O0100AD00013O0004973O00AD00012O00AE000100063O0012C10002001A3O0012C10003001B4O00E4000100034O00052O015O0012C13O00023O0004973O000100012O00833O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O0012C13O00013O000E3A0002001100013O0004973O001100012O00AE000100013O0020C00001000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004973O002200012O00AE00016O0047000100023O0004973O002200010026043O0001000100010004973O000100012O00AE000100013O0020C00001000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004973O002000012O00AE00016O0047000100023O0012C13O00023O0004973O000100012O00833O00017O00233O00028O00027O004003093O00497343617374696E67030E3O00456C656D656E74616C426C617374030D3O00557365466C616D6553686F636B030E3O005072696D6F726469616C57617665030B3O004973417661696C61626C65030A3O00466C616D6553686F636B03073O0049735265616479030E3O0049735370652O6C496E52616E676503173O00481B30A5F4A34D554D1C71B8E3B54655431530BCB1E11503083O003A2E7751C891D02503093O004C6176614275727374030A3O0049734361737461626C6503163O00278D26ADABA824389870BCBBB835248132ADBDFD677903073O00564BEC50CCC9DD026O000840026O00F03F031B3O00774D7288FB8566407BBAFC87735263C5EE9977427888FC8A66012103063O00EB122117E59E031B3O0040A8C8B65FA8C5B251B6FEAC51ACC4FB40A8C4B85FB7C3BA44FA9903043O00DB30DAA1030B3O0053746F726D6B2O65706572030F3O00432O6F6C646F776E52656D61696E7303063O0042752O665570030F3O0053746F726D6B2O6570657242752O6603173O00F765735BD644E5E161795B9B5FF2E1727344D94EF4A42303073O008084111C29BB2F03073O004963656675727903133O000831033C48132B462A4F043109375F0026466E03053O003D6152665A03173O00AA22AA46C2441606AF25EB5BD5521D06A12CAA5F87064A03083O0069CC4ECB2BA7377E031C3O00B5B82A131C16C358A4A61C092O12C211B5B8261D1C09C550B1EA724803083O0031C5CA437E7364A70046012O0012C13O00013O0026043O005E000100020004973O005E00012O00AE00015O0020092O01000100034O000300013O00202O0003000300044O00010003000200062O0001002A00013O0004973O002A00010012E5000100053O0006182O01002A00013O0004973O002A00012O00AE000100013O0020B100010001000600209B0001000100072O00250001000200020006AA0001002A000100010004973O002A00012O00AE000100013O0020B100010001000800209B0001000100092O00250001000200020006182O01002A00013O0004973O002A00012O00AE000100024O0025010200013O00202O0002000200084O000300033O00202O00030003000A4O000500013O00202O0005000500084O0003000500024O000300036O00010003000200062O0001002A00013O0004973O002A00012O00AE000100043O0012C10002000B3O0012C10003000C4O00E4000100034O00052O016O00AE000100013O0020B100010001000D00209B00010001000E2O00250001000200020006182O01005D00013O0004973O005D00012O00AE000100053O0006182O01005D00013O0004973O005D00012O00AE00015O0020370001000100034O000300013O00202O00030003000D4O00010003000200062O0001005D000100010004973O005D00012O00AE000100013O0020B100010001000400209B0001000100072O00250001000200020006182O01004C00013O0004973O004C00012O00AE000100013O0020B100010001000400209B0001000100072O00250001000200020006182O01005D00013O0004973O005D00012O00AE000100013O0020B100010001000400209B0001000100072O00250001000200020006AA0001005D000100010004973O005D00012O00AE000100024O0025010200013O00202O00020002000D4O000300033O00202O00030003000A4O000500013O00202O00050005000D4O0003000500024O000300036O00010003000200062O0001005D00013O0004973O005D00012O00AE000100043O0012C10002000F3O0012C1000300104O00E4000100034O00052O015O0012C13O00113O0026043O00A5000100120004973O00A500012O00AE000100013O0020B100010001000400209B00010001000E2O00250001000200020006182O01007A00013O0004973O007A00012O00AE000100063O0006182O01007A00013O0004973O007A00012O00AE000100024O0025010200013O00202O0002000200044O000300033O00202O00030003000A4O000500013O00202O0005000500044O0003000500024O000300036O00010003000200062O0001007A00013O0004973O007A00012O00AE000100043O0012C1000200133O0012C1000300144O00E4000100034O00052O016O00AE00015O0020092O01000100034O000300013O00202O0003000300044O00010003000200062O000100A400013O0004973O00A400012O00AE000100073O0006182O0100A400013O0004973O00A400012O00AE000100083O0006182O01008A00013O0004973O008A00012O00AE000100093O0006AA0001008D000100010004973O008D00012O00AE000100083O0006AA000100A4000100010004973O00A400012O00AE000100013O0020B100010001000600209B0001000100072O00250001000200020006182O0100A400013O0004973O00A400012O00AE000100024O0025010200013O00202O0002000200064O000300033O00202O00030003000A4O000500013O00202O0005000500064O0003000500024O000300036O00010003000200062O000100A400013O0004973O00A400012O00AE000100043O0012C1000200153O0012C1000300164O00E4000100034O00052O015O0012C13O00023O0026043O00F6000100010004973O00F600012O00AE000100013O0020B100010001001700209B00010001000E2O00250001000200020006182O0100D500013O0004973O00D500012O00AE000100013O0020B100010001001700209B0001000100182O0025000100020002002604000100D5000100010004973O00D500012O00AE00015O0020370001000100194O000300013O00202O00030003001A4O00010003000200062O000100D5000100010004973O00D500012O00AE0001000A3O0006182O0100D500013O0004973O00D500012O00AE0001000B3O0006182O0100C300013O0004973O00C300012O00AE000100093O0006AA000100C6000100010004973O00C600012O00AE0001000B3O0006AA000100D5000100010004973O00D500012O00AE0001000C4O00AE0002000D3O00060A000100D5000100020004973O00D500012O00AE000100024O00AE000200013O0020B10002000200172O00250001000200020006182O0100D500013O0004973O00D500012O00AE000100043O0012C10002001B3O0012C10003001C4O00E4000100034O00052O016O00AE000100013O0020B100010001001D00209B00010001000E2O00250001000200020006182O0100F500013O0004973O00F500012O00AE000100013O0020B100010001001D00209B0001000100182O0025000100020002002604000100F5000100010004973O00F500012O00AE0001000E3O0006182O0100F500013O0004973O00F500012O00AE000100024O0025010200013O00202O00020002001D4O000300033O00202O00030003000A4O000500013O00202O00050005001D4O0003000500024O000300036O00010003000200062O000100F500013O0004973O00F500012O00AE000100043O0012C10002001E3O0012C10003001F4O00E4000100034O00052O015O0012C13O00123O0026043O0001000100110004973O000100012O00AE00015O0020092O01000100034O000300013O00202O00030003000D4O00010003000200062O000100192O013O0004973O00192O010012E5000100053O0006182O0100192O013O0004973O00192O012O00AE000100013O0020B100010001000800209B0001000100092O00250001000200020006182O0100192O013O0004973O00192O012O00AE000100024O0025010200013O00202O0002000200084O000300033O00202O00030003000A4O000500013O00202O0005000500084O0003000500024O000300036O00010003000200062O000100192O013O0004973O00192O012O00AE000100043O0012C1000200203O0012C1000300214O00E4000100034O00052O016O00AE00015O0020092O01000100034O000300013O00202O00030003000D4O00010003000200062O000100452O013O0004973O00452O012O00AE000100073O0006182O0100452O013O0004973O00452O012O00AE000100083O0006182O0100292O013O0004973O00292O012O00AE000100093O0006AA0001002C2O0100010004973O002C2O012O00AE000100083O0006AA000100452O0100010004973O00452O012O00AE000100013O0020B100010001000600209B0001000100072O00250001000200020006182O0100452O013O0004973O00452O012O00AE000100024O0025010200013O00202O0002000200064O000300033O00202O00030003000A4O000500013O00202O0005000500064O0003000500024O000300036O00010003000200062O000100452O013O0004973O00452O012O00AE000100043O0012A3000200223O00122O000300236O000100036O00015O00044O00452O010004973O000100012O00833O00017O00CE3O00028O00026O00224003073O0049636566757279030B3O004973417661696C61626C65030F3O00432O6F6C646F776E52656D61696E7303113O00456C65637472696669656453686F636B73026O001440030E3O0049735370652O6C496E52616E6765030E3O003E58DA2F954447775AD02CC0010603073O003E573BBF49E036030A3O0046726F737453686F636B030A3O0049734361737461626C65030A3O00446562752O66446F776E03173O00456C65637472696669656453686F636B73446562752O6603133O00556E72656C656E74696E6743616C616D69747903123O00E110F5DAF33DE9C1E801F189E60DFF89BF5203043O00A987629A03083O004C6176614265616D030B3O0042752O6652656D61696E73030E3O00417363656E64616E636542752O6603083O004361737454696D6503103O00C7763255C231CDCA7A6455F23688932503073O00A8AB1744349D53030E3O00436861696E4C696768746E696E6703163O00F779F4A42B128BFD76FDB92B2489F331F4A2206DDFA003073O00E7941195CD454D026O002440026O00204003093O004C617661427572737403063O0042752O665570030D3O004C617661537572676542752O6603143O00442O65706C79522O6F746564456C656D656E7473031E3O0057696E64737065616B6572734C617661526573757267656E636542752O6603113O008CA6D1FA68FD95B5D4EF17FE8FA287AC0703063O009FE0C7A79B3703103O00FBF22AD3C8F139D3FAB33DDDF2B36B8003043O00B297935C026O00084003133O004D61737465726F66746865456C656D656E747303093O00436173744379636C6503113O0080FC5A332D4E6F9EEE587213437FCCAA1803073O001AEC9D2C52722C03113O00262FC35A152CC049393A955A252B950C7C03043O003B4A4EB5030D3O0046697265456C656D656E74616C03073O004973526561647903143O0023D8485F8C20DD5F57B62BC55B56F324DE5F1AE103053O00D345B12O3A030E3O0053746F726D456C656D656E74616C03153O00A4F176E7E4F4B2E97CF8ECC5A3E475B5E8C4B2A52D03063O00ABD785199589030B3O0053746F726D6B2O65706572030F3O0053746F726D6B2O6570657242752O6603113O00F2DC3DE8E23BF947F1CD20BAEE3FF902B603083O002281A8529A8F509C030D3O00546F74656D6963526563612O6C03103O004C69717569644D61676D61546F74656D025O0080464003143O0091BD270E45478ABAA03608494285C5B33C0E081603073O00E9E5D2536B282E026O00F03F030A3O00466C616D6553686F636B030D3O00557365466C616D6553686F636B03193O00C74E33DB00FE513AD906CA023FD913C84C359604CE47728E5303053O0065A12252B603193O00EE1F56EDCFDD9126E70E52BED6ED9427E60A19FFD4E7C276B003083O004E886D399EBB82E2026O00184003083O0042752O66446F776E030B3O004963656675727942752O662O033O00474344030C3O004C696768746E696E67526F6403193O00382DF6E22A00EAF9313CF2B13330EFF83038B9F0313AB9A46A03043O00915E5F9903073O0048617354696572026O003E40027O0040030D3O004579656F6674686553746F726D030A3O0054616C656E7452616E6B026O004E40030B3O00466C6F776F66506F77657203113O00F1CC02D471B5E8DF07C10EB6F2C854801803063O00D79DAD74B52E03103O0039B59DF3E537B18AFF9A34BB8EB28F6D03053O00BA55D4EB9203163O00C18917F737D154CB861EEA37E756C5C117F13CAE0E9203073O0038A2E1769E598E026O001C4003173O004C69717569644D61676D61546F74656D53652O74696E6703063O005F10D2BC2DCA03063O00B83C65A0CF4203163O004C69717569644D61676D61546F74656D437572736F7203093O004973496E52616E6765026O00444003193O003D8B6DA9388643B1308571BD0E9673A8348F3CBD3E873CED6103043O00DC51E21C03063O0003D983E2EFD503063O00A773B5E29B8A03163O004C69717569644D61676D61546F74656D506C6179657203193O00EE2BF6497275F9EF23E0517A4ED2ED36E2513B70C9E762B60D03073O00A68242873C1B11030E3O005072696D6F726469616C5761766503123O005072696D6F726469616C5761766542752O6603103O0053757267656F66506F77657242752O6603163O0053706C696E7465726564456C656D656E747342752O66030C3O004361737454617267657449662O033O004943C003053O0050242AAE1503083O0053652O74696E677303073O00436F2O6D6F6E73030C3O00446973706C61795374796C6503093O005369676E617475726503163O005E023E77410233734F1C086D4F06323A4F1F323A1F4203043O001A2E7057030C3O0053757267656F66506F7765722O033O00B42AA503083O00D4D943CB142ODF2503163O00AA9FA1DFB59FACDBBB8197C5BB9BAD92BB82AD92EBD903043O00B2DAEDC82O033O00BBBCE803043O00B0D6D58603163O00E42OBFD9A7445DFDACBAEBBF574FF1EDB7DBAD1608A203073O003994CDD6B4C836031A3O0057696E64737065616B6572734C617661526573757267656E6365030D3O00446562752O6652656D61696E7303103O00466C616D6553686F636B446562752O6603093O0054696D65546F44696503123O0014F13439732DEE3D3B7519BD343B7352AC6D03053O0016729D555403163O00536B79627265616B657273466965727944656D697365030F3O0041757261416374697665436F756E7403123O00C2C712C958C9BBCCC410CF1DF7A7C18B419403073O00C8A4AB73A43D9603123O00B8F802488681E70B4A80B5B4024A86FEA75303053O00E3DE94632503123O00355E53FBFC0C415AF9FA381253F9FC732O0003053O0099532O329603123O005B7A721176945E5579701733AA425836214803073O002D3D16137C13CB03123O00C71E0CF8074FAAC91D0EFE4271B6C4525FA303073O00D9A1726D95621003123O00142C3971B94B0128377FB734132F3D3CEE2C03063O00147240581CDC030A3O00417363656E64616E636503113O003012D1B1F6D4BC3F02D7F4F9DFB871528003073O00DD5161B2D498B003163O004563686F65736F66477265617453756E646572696E67031A3O004563686F65736F66477265617453756E646572696E6742752O6603113O00C1E60BFA25CFF20FE80E8DE612FE5A9EB303053O007AAD877D9B030E3O00456C656D656E74616C426C61737403163O0081CD05B43A3FDC85CD3FBB3330DB908101B63A719CD203073O00A8E4A160D95F51030A3O00456172746853686F636B2O033O00D6D82003063O0037BBB14E3C4F03123O0028CF4DFF4EF09325C15CE006CE8F288E0BB303073O00E04DAE3F8B26AF03123O0081404A3A8C7E4B268B42536E854E5D6ED11103043O004EE42138030E3O00C77DB70590DC67F2028ACB3EE75103053O00E5AE1ED26303053O00506F77657203103O0017EC9050D23F3C1AE0C650E238794DBF03073O00597B8DE6318D5D03163O00F079F7051E75FF78F12O0444FA7FF14C1145F631A05803063O002A9311966C7003103O0003A73B7ED8EA0AA7203FE6E70AE67B2903063O00886FC64D1F8703163O002O01A65FB3DB1BA00501B358B4EA10E90306A216EBBC03083O00C96269C736DD8477026O001040030A3O0045617274687175616B6503113O0045617274687175616B6553652O74696E6703063O00BA1991320D2703073O00CCD96CE341625503103O0045617274687175616B65437572736F7203113O005BC2E7F124D14BC2FEE06CC151C6B5B17C03063O00A03EA395854C03063O00C6AC0C36C6C403053O00A3B6C06D4F03103O0045617274687175616B65506C6179657203113O00312712D4FD253301CBF074270FC5B5607603053O0095544660A02O033O00350F2O03043O008D58666D03163O00B65FCF7D1F3341C0BF6CC87C1B2E4181B25CCF304E6F03083O00A1D333AA107A5D3503163O00FEA2B725FEA0A629F791B024FABDA668FAA1B768AFFA03043O00489BCED203063O00456F461D3C5403053O0053261A346E03113O005D1635525006324753126747571267150E03043O002638774703063O002OE359CF204403063O0036938F38B64503113O00D380ED5DD7C794FE42DA9680F04C9F85D703053O00BFB6E19F2903063O0028073A46849503073O00A24B724835EBE703113O00893D56F65B13993D4FE71303833904B10B03063O0062EC5C24823303063O00B4150DA340BA03083O0050C4796CDA25C8D503113O000572106B431F9F0178073F4A018F40205A03073O00EA6013621F2B6E0091082O0012C13O00013O0026043O00A0000100020004973O00A000012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01002C00013O0004973O002C00012O00AE00015O0020B100010001000300209B0001000100052O00250001000200020026040001002C000100010004973O002C00012O00AE000100013O0006182O01002C00013O0004973O002C00012O00AE00015O0020B100010001000600209B0001000100042O00250001000200020006182O01002C00013O0004973O002C00012O00AE000100023O0026062O01002C000100070004973O002C00012O00AE000100034O002501025O00202O0002000200034O000300043O00202O0003000300084O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001002C00013O0004973O002C00012O00AE000100053O0012C1000200093O0012C10003000A4O00E4000100034O00052O016O00AE00015O0020B100010001000B00209B00010001000C2O00250001000200020006182O01006000013O0004973O006000012O00AE000100063O0006182O01006000013O0004973O006000012O00AE000100074O00F90001000100020006182O01006000013O0004973O006000012O00AE00015O0020B100010001000600209B0001000100042O00250001000200020006182O01006000013O0004973O006000012O00AE000100043O0020092O010001000D4O00035O00202O00030003000E4O00010003000200062O0001006000013O0004973O006000012O00AE000100083O0026062O010060000100070004973O006000012O00AE00015O0020B100010001000F00209B0001000100042O00250001000200020006182O01006000013O0004973O006000012O00AE000100034O002501025O00202O00020002000B4O000300043O00202O0003000300084O00055O00202O00050005000B4O0003000500024O000300036O00010003000200062O0001006000013O0004973O006000012O00AE000100053O0012C1000200103O0012C1000300114O00E4000100034O00052O016O00AE00015O0020B100010001001200209B0001000100042O00250001000200020006182O01008500013O0004973O008500012O00AE000100093O0006182O01008500013O0004973O008500012O00AE0001000A3O0020E10001000100134O00035O00202O0003000300144O0001000300024O00025O00202O00020002001200202O0002000200154O00020002000200062O00020085000100010004973O008500012O00AE000100034O002501025O00202O0002000200124O000300043O00202O0003000300084O00055O00202O0005000500124O0003000500024O000300036O00010003000200062O0001008500013O0004973O008500012O00AE000100053O0012C1000200163O0012C1000300174O00E4000100034O00052O016O00AE00015O0020B100010001001800209B0001000100042O00250001000200020006182O01009F00013O0004973O009F00012O00AE0001000B3O0006182O01009F00013O0004973O009F00012O00AE000100034O002501025O00202O0002000200184O000300043O00202O0003000300084O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001009F00013O0004973O009F00012O00AE000100053O0012C1000200193O0012C10003001A4O00E4000100034O00052O015O0012C13O001B3O0026043O004A2O01001C0004973O004A2O012O00AE00015O0020B100010001001D00209B0001000100042O00250001000200020006182O0100D000013O0004973O00D000012O00AE0001000C3O0006182O0100D000013O0004973O00D000012O00AE0001000A3O0020092O010001001E4O00035O00202O00030003001F4O00010003000200062O000100D000013O0004973O00D000012O00AE00015O0020B100010001002000209B0001000100042O00250001000200020006182O0100D000013O0004973O00D000012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300214O00010003000200062O000100D000013O0004973O00D000012O00AE000100034O002501025O00202O00020002001D4O000300043O00202O0003000300084O00055O00202O00050005001D4O0003000500024O000300036O00010003000200062O000100D000013O0004973O00D000012O00AE000100053O0012C1000200223O0012C1000300234O00E4000100034O00052O016O00AE00015O0020B100010001001200209B0001000100042O00250001000200020006182O0100F900013O0004973O00F900012O00AE000100093O0006182O0100F900013O0004973O00F900012O00AE0001000D4O00F90001000100020006182O0100F900013O0004973O00F900012O00AE0001000A3O0020E10001000100134O00035O00202O0003000300144O0001000300024O00025O00202O00020002001200202O0002000200154O00020002000200062O000200F9000100010004973O00F900012O00AE000100034O002501025O00202O0002000200124O000300043O00202O0003000300084O00055O00202O0005000500124O0003000500024O000300036O00010003000200062O000100F900013O0004973O00F900012O00AE000100053O0012C1000200243O0012C1000300254O00E4000100034O00052O016O00AE00015O0020B100010001001D00209B0001000100042O00250001000200020006182O01001F2O013O0004973O001F2O012O00AE0001000C3O0006182O01001F2O013O0004973O001F2O012O00AE000100083O0026040001001F2O0100260004973O001F2O012O00AE00015O0020B100010001002700209B0001000100042O00250001000200020006182O01001F2O013O0004973O001F2O012O00AE0001000E3O0020BA0001000100284O00025O00202O00020002001D4O0003000F6O000400106O000500043O00202O0005000500084O00075O00202O00070007001D4O0005000700024O000500056O00010005000200062O0001001F2O013O0004973O001F2O012O00AE000100053O0012C1000200293O0012C10003002A4O00E4000100034O00052O016O00AE00015O0020B100010001001D00209B0001000100042O00250001000200020006182O0100492O013O0004973O00492O012O00AE0001000C3O0006182O0100492O013O0004973O00492O012O00AE0001000A3O0020092O010001001E4O00035O00202O00030003001F4O00010003000200062O000100492O013O0004973O00492O012O00AE00015O0020B100010001002000209B0001000100042O00250001000200020006182O0100492O013O0004973O00492O012O00AE0001000E3O0020BA0001000100284O00025O00202O00020002001D4O0003000F6O000400106O000500043O00202O0005000500084O00075O00202O00070007001D4O0005000700024O000500056O00010005000200062O000100492O013O0004973O00492O012O00AE000100053O0012C10002002B3O0012C10003002C4O00E4000100034O00052O015O0012C13O00023O0026043O00DB2O0100010004973O00DB2O012O00AE00015O0020B100010001002D00209B00010001002E2O00250001000200020006182O01006D2O013O0004973O006D2O012O00AE000100113O0006182O01006D2O013O0004973O006D2O012O00AE000100123O0006182O01005B2O013O0004973O005B2O012O00AE000100133O0006AA0001005E2O0100010004973O005E2O012O00AE000100123O0006AA0001006D2O0100010004973O006D2O012O00AE000100144O00AE000200153O00060A0001006D2O0100020004973O006D2O012O00AE000100034O00AE00025O0020B100020002002D2O00250001000200020006182O01006D2O013O0004973O006D2O012O00AE000100053O0012C10002002F3O0012C1000300304O00E4000100034O00052O016O00AE00015O0020B100010001003100209B00010001002E2O00250001000200020006182O01008E2O013O0004973O008E2O012O00AE000100163O0006182O01008E2O013O0004973O008E2O012O00AE000100173O0006182O01007C2O013O0004973O007C2O012O00AE000100133O0006AA0001007F2O0100010004973O007F2O012O00AE000100173O0006AA0001008E2O0100010004973O008E2O012O00AE000100144O00AE000200153O00060A0001008E2O0100020004973O008E2O012O00AE000100034O00AE00025O0020B10002000200312O00250001000200020006182O01008E2O013O0004973O008E2O012O00AE000100053O0012C1000200323O0012C1000300334O00E4000100034O00052O016O00AE00015O0020B100010001003400209B0001000100042O00250001000200020006182O0100C02O013O0004973O00C02O012O00AE00015O0020B100010001003400209B0001000100052O0025000100020002002604000100C02O0100010004973O00C02O012O00AE0001000A3O00203700010001001E4O00035O00202O0003000300354O00010003000200062O000100C02O0100010004973O00C02O012O00AE000100183O0006182O0100C02O013O0004973O00C02O012O00AE000100193O0006182O0100AA2O013O0004973O00AA2O012O00AE0001001A3O0006AA000100AD2O0100010004973O00AD2O012O00AE000100193O0006AA000100C02O0100010004973O00C02O012O00AE000100144O00AE000200153O00060A000100C02O0100020004973O00C02O012O00AE0001001B4O00F90001000100020006AA000100C02O0100010004973O00C02O012O00AE000100034O00AE00025O0020B10002000200342O00250001000200020006182O0100C02O013O0004973O00C02O012O00AE000100053O0012C1000200363O0012C1000300374O00E4000100034O00052O016O00AE00015O0020B100010001003800209B00010001000C2O00250001000200020006182O0100DA2O013O0004973O00DA2O012O00AE00015O0020B100010001003900209B0001000100052O0025000100020002000E48003A00DA2O0100010004973O00DA2O012O00AE0001001C3O0006182O0100DA2O013O0004973O00DA2O012O00AE000100034O00AE00025O0020B10002000200382O00250001000200020006182O0100DA2O013O0004973O00DA2O012O00AE000100053O0012C10002003B3O0012C10003003C4O00E4000100034O00052O015O0012C13O003D3O0026043O00150201001B0004973O001502012O00AE00015O0020B100010001003E00209B00010001000C2O00250001000200020006182O0100FA2O013O0004973O00FA2O010012E50001003F3O0006182O0100FA2O013O0004973O00FA2O012O00AE0001000E3O0020BA0001000100284O00025O00202O00020002003E4O0003000F6O0004001D6O000500043O00202O0005000500084O00075O00202O00070007003E4O0005000700024O000500056O00010005000200062O000100FA2O013O0004973O00FA2O012O00AE000100053O0012C1000200403O0012C1000300414O00E4000100034O00052O016O00AE00015O0020B100010001000B00209B00010001000C2O00250001000200020006182O01009008013O0004973O009008012O00AE000100063O0006182O01009008013O0004973O009008012O00AE000100034O002501025O00202O00020002000B4O000300043O00202O0003000300084O00055O00202O00050005000B4O0003000500024O000300036O00010003000200062O0001009008013O0004973O009008012O00AE000100053O0012A3000200423O00122O000300436O000100036O00015O00044O009008010026043O00F2020100440004973O00F202012O00AE00015O0020B100010001000B00209B00010001000C2O00250001000200020006182O01006902013O0004973O006902012O00AE000100063O0006182O01006902013O0004973O006902012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300144O00010003000200062O0001006902013O0004973O006902012O00AE000100074O00F90001000100020006182O01006902013O0004973O006902012O00AE00015O0020B100010001000600209B0001000100042O00250001000200020006182O01006902013O0004973O006902012O00AE000100043O00203700010001000D4O00035O00202O00030003000E4O00010003000200062O00010042020100010004973O004202012O00AE0001000A3O0020A90001000100134O00035O00202O0003000300464O0001000300024O0002000A3O00202O0002000200474O00020002000200062O00010069020100020004973O006902012O00AE00015O0020B100010001004800209B0001000100042O00250001000200020006182O01004F02013O0004973O004F02012O00AE000100083O0026062O01004F020100070004973O004F02012O00AE0001000D4O00F90001000100020006182O01005802013O0004973O005802012O00AE00015O0020B100010001002000209B0001000100042O00250001000200020006182O01006902013O0004973O006902012O00AE000100083O00260400010069020100260004973O006902012O00AE000100034O002501025O00202O00020002000B4O000300043O00202O0003000300084O00055O00202O00050005000B4O0003000500024O000300036O00010003000200062O0001006902013O0004973O006902012O00AE000100053O0012C1000200493O0012C10003004A4O00E4000100034O00052O016O00AE00015O0020B100010001001D00209B0001000100042O00250001000200020006182O0100B502013O0004973O00B502012O00AE0001000C3O0006182O0100B502013O0004973O00B502012O00AE00015O0020B100010001002700209B0001000100042O00250001000200020006182O0100B502013O0004973O00B502012O00AE0001000D4O00F90001000100020006AA000100B5020100010004973O00B502012O00AE0001001B4O00F90001000100020006AA0001008B020100010004973O008B02012O00AE0001000A3O00209000010001004B00122O0003004C3O00122O0004004D6O00010004000200062O000100B502013O0004973O00B502012O00AE0001001E4O00F90001000100020026062O0100B5020100260004973O00B502012O00AE0001001F4O00D90001000100024O00025O00202O00020002004E00202O00020002004F4O00020002000200102O00020007000200102O0002005000024O000300206O00045O00202O00040004005100209B0004000400042O0010010400056O00033O000200102O0003004D00034O00020002000300202O00020002001B00062O000100B5020100020004973O00B502012O00AE000100083O0026062O0100B5020100070004973O00B502012O00AE0001000E3O0020BA0001000100284O00025O00202O00020002001D4O0003000F6O000400106O000500043O00202O0005000500084O00075O00202O00070007001D4O0005000700024O000500056O00010005000200062O000100B502013O0004973O00B502012O00AE000100053O0012C1000200523O0012C1000300534O00E4000100034O00052O016O00AE00015O0020B100010001001200209B0001000100042O00250001000200020006182O0100D302013O0004973O00D302012O00AE000100093O0006182O0100D302013O0004973O00D302012O00AE0001001B4O00F90001000100020006182O0100D302013O0004973O00D302012O00AE000100034O002501025O00202O0002000200124O000300043O00202O0003000300084O00055O00202O0005000500124O0003000500024O000300036O00010003000200062O000100D302013O0004973O00D302012O00AE000100053O0012C1000200543O0012C1000300554O00E4000100034O00052O016O00AE00015O0020B100010001001800209B0001000100042O00250001000200020006182O0100F102013O0004973O00F102012O00AE0001000B3O0006182O0100F102013O0004973O00F102012O00AE0001001B4O00F90001000100020006182O0100F102013O0004973O00F102012O00AE000100034O002501025O00202O0002000200184O000300043O00202O0003000300084O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O000100F102013O0004973O00F102012O00AE000100053O0012C1000200563O0012C1000300574O00E4000100034O00052O015O0012C13O00583O0026043O00DE0301003D0004973O00DE03012O00AE00015O0020B100010001003900209B00010001002E2O00250001000200020006182O01002103013O0004973O002103012O00AE000100213O0006182O01002103013O0004973O002103012O00AE000100223O0006182O01002O03013O0004973O002O03012O00AE000100133O0006AA00010006030100010004973O000603012O00AE000100223O0006AA00010021030100010004973O002103012O00AE000100144O00AE000200153O00060A00010021030100020004973O002103010012E5000100594O00D3000200053O00122O0003005A3O00122O0004005B6O00020004000200062O00010021030100020004973O002103012O00AE000100034O00BB000200233O00202O00020002005C4O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001002103013O0004973O002103012O00AE000100053O0012C10002005F3O0012C1000300604O00E4000100034O00052O016O00AE00015O0020B100010001003900209B00010001002E2O00250001000200020006182O01004E03013O0004973O004E03012O00AE000100213O0006182O01004E03013O0004973O004E03012O00AE000100223O0006182O01003003013O0004973O003003012O00AE000100133O0006AA00010033030100010004973O003303012O00AE000100223O0006AA0001004E030100010004973O004E03012O00AE000100144O00AE000200153O00060A0001004E030100020004973O004E03010012E5000100594O00D3000200053O00122O000300613O00122O000400626O00020004000200062O0001004E030100020004973O004E03012O00AE000100034O00BB000200233O00202O0002000200634O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001004E03013O0004973O004E03012O00AE000100053O0012C1000200643O0012C1000300654O00E4000100034O00052O016O00AE00015O0020B100010001006600209B0001000100042O00250001000200020006182O01009303013O0004973O009303012O00AE000100243O0006182O01009303013O0004973O009303012O00AE000100253O0006182O01005D03013O0004973O005D03012O00AE0001001A3O0006AA00010060030100010004973O006003012O00AE000100253O0006AA00010093030100010004973O009303012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300674O00010003000200062O0001009303013O0004973O009303012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300684O00010003000200062O0001009303013O0004973O009303012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300694O00010003000200062O0001009303013O0004973O009303012O00AE0001000E3O00205400010001006A4O00025O00202O0002000200664O0003000F6O000400053O00122O0005006B3O00122O0006006C6O0004000600024O000500106O000600066O000700043O00202O0007000700084O00095O00202O0009000900664O0007000900024O000700076O000800083O00122O0009006D3O00202O00090009006E00202O00090009006F00202O0009000900704O00010009000200062O0001009303013O0004973O009303012O00AE000100053O0012C1000200713O0012C1000300724O00E4000100034O00052O016O00AE00015O0020B100010001006600209B0001000100042O00250001000200020006182O0100DD03013O0004973O00DD03012O00AE000100243O0006182O0100DD03013O0004973O00DD03012O00AE000100253O0006182O0100A203013O0004973O00A203012O00AE0001001A3O0006AA000100A5030100010004973O00A503012O00AE000100253O0006AA000100DD030100010004973O00DD03012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300674O00010003000200062O000100DD03013O0004973O00DD03012O00AE00015O0020B100010001002000209B0001000100042O00250001000200020006182O0100DD03013O0004973O00DD03012O00AE00015O0020B100010001007300209B0001000100042O00250001000200020006AA000100DD030100010004973O00DD03012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300694O00010003000200062O000100DD03013O0004973O00DD03012O00AE0001000E3O00205400010001006A4O00025O00202O0002000200664O0003000F6O000400053O00122O000500743O00122O000600756O0004000600024O000500106O000600066O000700043O00202O0007000700084O00095O00202O0009000900664O0007000900024O000700076O000800083O00122O0009006D3O00202O00090009006E00202O00090009006F00202O0009000900704O00010009000200062O000100DD03013O0004973O00DD03012O00AE000100053O0012C1000200763O0012C1000300774O00E4000100034O00052O015O0012C13O004D3O0026043O00E60501004D0004973O00E605012O00AE00015O0020B100010001006600209B0001000100042O00250001000200020006182O01002304013O0004973O002304012O00AE000100243O0006182O01002304013O0004973O002304012O00AE000100253O0006182O0100EF03013O0004973O00EF03012O00AE0001001A3O0006AA000100F2030100010004973O00F203012O00AE000100253O0006AA00010023040100010004973O002304012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300674O00010003000200062O0001002304013O0004973O002304012O00AE00015O0020B100010001002700209B0001000100042O00250001000200020006182O01002304013O0004973O002304012O00AE00015O0020B100010001004800209B0001000100042O00250001000200020006AA00010023040100010004973O002304012O00AE0001000E3O00205400010001006A4O00025O00202O0002000200664O0003000F6O000400053O00122O000500783O00122O000600796O0004000600024O000500106O000600066O000700043O00202O0007000700084O00095O00202O0009000900664O0007000900024O000700076O000800083O00122O0009006D3O00202O00090009006E00202O00090009006F00202O0009000900704O00010009000200062O0001002304013O0004973O002304012O00AE000100053O0012C10002007A3O0012C10003007B4O00E4000100034O00052O016O00AE00015O0020B100010001003E00209B00010001000C2O00250001000200020006182O01005E05013O0004973O005E05010012C1000100013O00260400010092040100010004973O009204012O00AE0002000A3O00200901020002001E4O00045O00202O0004000400684O00020004000200062O0002006104013O0004973O006104012O00AE000200263O0006180102006104013O0004973O006104012O00AE00025O0020B100020002004800209B0002000200042O00250002000200020006180102006104013O0004973O006104012O00AE00025O0020B100020002007C00209B0002000200042O00250002000200020006180102006104013O0004973O006104012O00AE000200043O0020FD00020002007D4O00045O00202O00040004007E4O0002000400024O000300043O00202O00030003007F4O00030002000200202O00030003003D00062O00020061040100030004973O006104012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500276O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002006104013O0004973O006104012O00AE000200053O0012C1000300803O0012C1000400814O00E4000200044O000501026O00AE0002000A3O00200901020002001E4O00045O00202O0004000400684O00020004000200062O0002009104013O0004973O009104012O00AE000200263O0006180102009104013O0004973O009104012O00AE00025O0020B100020002004800209B0002000200042O00250002000200020006180102007704013O0004973O007704012O00AE00025O0020B100020002008200209B0002000200042O00250002000200020006180102009104013O0004973O009104012O00AE00025O0020B100020002007E00209B0002000200832O002500020002000200260601020091040100440004973O009104012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500276O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002009104013O0004973O009104012O00AE000200053O0012C1000300843O0012C1000400854O00E4000200044O000501025O0012C10001003D3O000E3A002600B8040100010004973O00B804012O00AE00025O0020B100020002002000209B0002000200042O00250002000200020006180102005E05013O0004973O005E05012O00AE000200263O0006180102005E05013O0004973O005E05012O00AE00025O0020B100020002007300209B0002000200042O00250002000200020006AA0002005E050100010004973O005E05012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500286O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002005E05013O0004973O005E05012O00AE000200053O0012A3000300863O00122O000400876O000200046O00025O00044O005E05010026040001000D0501003D0004973O000D05012O00AE00025O0020B100020002002700209B0002000200042O0025000200020002000618010200E304013O0004973O00E304012O00AE000200263O000618010200E304013O0004973O00E304012O00AE00025O0020B100020002004800209B0002000200042O00250002000200020006AA000200E3040100010004973O00E304012O00AE00025O0020B100020002007E00209B0002000200832O0025000200020002002606010200E3040100440004973O00E304012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500276O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O000200E304013O0004973O00E304012O00AE000200053O0012C1000300883O0012C1000400894O00E4000200044O000501026O00AE00025O0020B100020002002000209B0002000200042O00250002000200020006180102000C05013O0004973O000C05012O00AE000200263O0006180102000C05013O0004973O000C05012O00AE00025O0020B100020002007300209B0002000200042O00250002000200020006AA0002000C050100010004973O000C05012O00AE00025O0020B100020002007E00209B0002000200832O00250002000200020026060102000C050100440004973O000C05012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500276O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002000C05013O0004973O000C05012O00AE000200053O0012C10003008A3O0012C10004008B4O00E4000200044O000501025O0012C10001004D3O000E3A004D002A040100010004973O002A04012O00AE0002000A3O00200901020002001E4O00045O00202O0004000400684O00020004000200062O0002003905013O0004973O003905012O00AE000200263O0006180102003905013O0004973O003905012O00AE00025O0020B100020002004800209B0002000200042O00250002000200020006180102002505013O0004973O002505012O00AE00025O0020B100020002008200209B0002000200042O00250002000200020006180102003905013O0004973O003905012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500286O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002003905013O0004973O003905012O00AE000200053O0012C10003008C3O0012C10004008D4O00E4000200044O000501026O00AE00025O0020B100020002002700209B0002000200042O00250002000200020006180102005C05013O0004973O005C05012O00AE000200263O0006180102005C05013O0004973O005C05012O00AE00025O0020B100020002004800209B0002000200042O00250002000200020006AA0002005C050100010004973O005C05012O00AE0002000E3O0020BA0002000200284O00035O00202O00030003003E4O0004000F6O000500286O000600043O00202O0006000600084O00085O00202O00080008003E4O0006000800024O000600066O00020006000200062O0002005C05013O0004973O005C05012O00AE000200053O0012C10003008E3O0012C10004008F4O00E4000200044O000501025O0012C1000100263O0004973O002A04012O00AE00015O0020B100010001009000209B00010001000C2O00250001000200020006182O01007F05013O0004973O007F05012O00AE000100293O0006182O01007F05013O0004973O007F05012O00AE0001002A3O0006182O01006D05013O0004973O006D05012O00AE000100133O0006AA00010070050100010004973O007005012O00AE0001002A3O0006AA0001007F050100010004973O007F05012O00AE000100144O00AE000200153O00060A0001007F050100020004973O007F05012O00AE000100034O00AE00025O0020B10002000200902O00250001000200020006182O01007F05013O0004973O007F05012O00AE000100053O0012C1000200913O0012C1000300924O00E4000100034O00052O016O00AE00015O0020B100010001001D00209B0001000100042O00250001000200020006182O0100E505013O0004973O00E505012O00AE0001000C3O0006182O0100E505013O0004973O00E505012O00AE0001000A3O0020092O010001001E4O00035O00202O00030003001F4O00010003000200062O000100E505013O0004973O00E505012O00AE00015O0020B100010001002700209B0001000100042O00250001000200020006182O0100E505013O0004973O00E505012O00AE0001000D4O00F90001000100020006AA000100E5050100010004973O00E505012O00AE0001001F4O00D90001000100024O00025O00202O00020002004E00202O00020002004F4O00020002000200102O00020007000200102O0002005000024O000300206O00045O00202O00040004005100209B0004000400042O0015010400056O00033O000200102O0003004D00034O00020002000300062O000200E5050100010004973O00E505012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA000100B7050100010004973O00B705012O00AE00015O0020B100010001004800209B0001000100042O00250001000200020006182O0100BE05013O0004973O00BE05012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300944O00010003000200062O000100E505013O0004973O00E505012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300144O00010003000200062O000100CE05013O0004973O00CE05012O00AE000100083O000E48002600CE050100010004973O00CE05012O00AE00015O0020B100010001000F00209B0001000100042O00250001000200020006182O0100D105013O0004973O00D105012O00AE000100023O002604000100E5050100260004973O00E505012O00AE0001000E3O0020BA0001000100284O00025O00202O00020002001D4O0003000F6O000400106O000500043O00202O0005000500084O00075O00202O00070007001D4O0005000700024O000500056O00010005000200062O000100E505013O0004973O00E505012O00AE000100053O0012C1000200953O0012C1000300964O00E4000100034O00052O015O0012C13O00263O0026043O0097060100070004973O009706012O00AE00015O0020B100010001009700209B0001000100042O00250001000200020006182O01000B06013O0004973O000B06012O00AE0001002B3O0006182O01000B06013O0004973O000B06012O00AE000100083O0026040001000B060100260004973O000B06012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA0001000B060100010004973O000B06012O00AE000100034O002501025O00202O0002000200974O000300043O00202O0003000300084O00055O00202O0005000500974O0003000500024O000300036O00010003000200062O0001000B06013O0004973O000B06012O00AE000100053O0012C1000200983O0012C1000300994O00E4000100034O00052O016O00AE00015O0020B100010001009A00209B00010001002E2O00250001000200020006182O01003306013O0004973O003306012O00AE0001002C3O0006182O01003306013O0004973O003306012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006182O01003306013O0004973O003306012O00AE0001000E3O0020D400010001006A4O00025O00202O00020002009A4O0003000F6O000400053O00122O0005009B3O00122O0006009C6O0004000600024O0005002D6O000600066O000700043O00202O0007000700084O00095O00202O00090009009A4O0007000900024O000700076O00010007000200062O0001003306013O0004973O003306012O00AE000100053O0012C10002009D3O0012C10003009E4O00E4000100034O00052O016O00AE00015O0020B100010001009A00209B00010001002E2O00250001000200020006182O01005306013O0004973O005306012O00AE0001002C3O0006182O01005306013O0004973O005306012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006182O01005306013O0004973O005306012O00AE000100034O002501025O00202O00020002009A4O000300043O00202O0003000300084O00055O00202O00050005009A4O0003000500024O000300036O00010003000200062O0001005306013O0004973O005306012O00AE000100053O0012C10002009F3O0012C1000300A04O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01009606013O0004973O009606012O00AE00015O0020B100010001000300209B0001000100052O002500010002000200260400010096060100010004973O009606012O00AE000100013O0006182O01009606013O0004973O009606012O00AE0001000A3O0020092O01000100454O00035O00202O0003000300144O00010003000200062O0001009606013O0004973O009606012O00AE00015O0020B100010001000600209B0001000100042O00250001000200020006182O01009606013O0004973O009606012O00AE00015O0020B100010001004800209B0001000100042O00250001000200020006182O01007C06013O0004973O007C06012O00AE000100083O0026062O01007C060100070004973O007C06012O00AE0001000D4O00F90001000100020006182O01008506013O0004973O008506012O00AE00015O0020B100010001002000209B0001000100042O00250001000200020006182O01009606013O0004973O009606012O00AE000100083O00260400010096060100260004973O009606012O00AE000100034O002501025O00202O0002000200034O000300043O00202O0003000300084O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001009606013O0004973O009606012O00AE000100053O0012C1000200A13O0012C1000300A24O00E4000100034O00052O015O0012C13O00443O0026043O0037070100580004973O003707012O00AE00015O0020B100010001001200209B0001000100042O00250001000200020006182O0100C506013O0004973O00C506012O00AE000100093O0006182O0100C506013O0004973O00C506012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300A34O00010003000200062O000100C506013O0004973O00C506012O00AE0001000A3O0020E10001000100134O00035O00202O0003000300144O0001000300024O00025O00202O00020002001200202O0002000200154O00020002000200062O000200C5060100010004973O00C506012O00AE000100034O002501025O00202O0002000200124O000300043O00202O0003000300084O00055O00202O0005000500124O0003000500024O000300036O00010003000200062O000100C506013O0004973O00C506012O00AE000100053O0012C1000200A43O0012C1000300A54O00E4000100034O00052O016O00AE00015O0020B100010001001800209B0001000100042O00250001000200020006182O0100E306013O0004973O00E306012O00AE0001000B3O0006182O0100E306013O0004973O00E306012O00AE0001000D4O00F90001000100020006182O0100E306013O0004973O00E306012O00AE000100034O002501025O00202O0002000200184O000300043O00202O0003000300084O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O000100E306013O0004973O00E306012O00AE000100053O0012C1000200A63O0012C1000300A74O00E4000100034O00052O016O00AE00015O0020B100010001001200209B0001000100042O00250001000200020006182O01001207013O0004973O001207012O00AE000100093O0006182O01001207013O0004973O001207012O00AE000100083O000E7200440012070100010004973O001207012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300684O00010003000200062O0001001207013O0004973O001207012O00AE0001000A3O0020E10001000100134O00035O00202O0003000300144O0001000300024O00025O00202O00020002001200202O0002000200154O00020002000200062O00020012070100010004973O001207012O00AE000100034O002501025O00202O0002000200124O000300043O00202O0003000300084O00055O00202O0005000500124O0003000500024O000300036O00010003000200062O0001001207013O0004973O001207012O00AE000100053O0012C1000200A83O0012C1000300A94O00E4000100034O00052O016O00AE00015O0020B100010001001800209B0001000100042O00250001000200020006182O01003607013O0004973O003607012O00AE0001000B3O0006182O01003607013O0004973O003607012O00AE000100083O000E7200440036070100010004973O003607012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300684O00010003000200062O0001003607013O0004973O003607012O00AE000100034O002501025O00202O0002000200184O000300043O00202O0003000300084O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001003607013O0004973O003607012O00AE000100053O0012C1000200AA3O0012C1000300AB4O00E4000100034O00052O015O0012C13O001C3O0026043O00D0070100AC0004973O00D007012O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O01006007013O0004973O006007012O00AE0001002E3O0006182O01006007013O0004973O006007010012E5000100AE4O00D3000200053O00122O000300AF3O00122O000400B06O00020004000200062O00010060070100020004973O006007012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300944O00010003000200062O0001006007013O0004973O006007012O00AE000100034O00BB000200233O00202O0002000200B14O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001006007013O0004973O006007012O00AE000100053O0012C1000200B23O0012C1000300B34O00E4000100034O00052O016O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O01008707013O0004973O008707012O00AE0001002E3O0006182O01008707013O0004973O008707010012E5000100AE4O00D3000200053O00122O000300B43O00122O000400B56O00020004000200062O00010087070100020004973O008707012O00AE0001000A3O0020092O010001001E4O00035O00202O0003000300944O00010003000200062O0001008707013O0004973O008707012O00AE000100034O00BB000200233O00202O0002000200B64O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001008707013O0004973O008707012O00AE000100053O0012C1000200B73O0012C1000300B84O00E4000100034O00052O016O00AE00015O0020B100010001009700209B0001000100042O00250001000200020006182O0100AF07013O0004973O00AF07012O00AE0001002B3O0006182O0100AF07013O0004973O00AF07012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006182O0100AF07013O0004973O00AF07012O00AE0001000E3O0020D400010001006A4O00025O00202O0002000200974O0003000F6O000400053O00122O000500B93O00122O000600BA6O0004000600024O0005002D6O000600066O000700043O00202O0007000700084O00095O00202O0009000900974O0007000900024O000700076O00010007000200062O000100AF07013O0004973O00AF07012O00AE000100053O0012C1000200BB3O0012C1000300BC4O00E4000100034O00052O016O00AE00015O0020B100010001009700209B0001000100042O00250001000200020006182O0100CF07013O0004973O00CF07012O00AE0001002B3O0006182O0100CF07013O0004973O00CF07012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006182O0100CF07013O0004973O00CF07012O00AE000100034O002501025O00202O0002000200974O000300043O00202O0003000300084O00055O00202O0005000500974O0003000500024O000300036O00010003000200062O000100CF07013O0004973O00CF07012O00AE000100053O0012C1000200BD3O0012C1000300BE4O00E4000100034O00052O015O0012C13O00073O0026043O0001000100260004973O000100012O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O0100FE07013O0004973O00FE07012O00AE0001002E3O0006182O0100FE07013O0004973O00FE07010012E5000100AE4O00D3000200053O00122O000300BF3O00122O000400C06O00020004000200062O000100FE070100020004973O00FE07012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA000100FE070100010004973O00FE07012O00AE000100083O000E48002600FE070100010004973O00FE07012O00AE000100023O000E48002600FE070100010004973O00FE07012O00AE000100034O00BB000200233O00202O0002000200B14O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O000100FE07013O0004973O00FE07012O00AE000100053O0012C1000200C13O0012C1000300C24O00E4000100034O00052O016O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O01002A08013O0004973O002A08012O00AE0001002E3O0006182O01002A08013O0004973O002A08010012E5000100AE4O00D3000200053O00122O000300C33O00122O000400C46O00020004000200062O0001002A080100020004973O002A08012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA0001002A080100010004973O002A08012O00AE000100083O000E480026002A080100010004973O002A08012O00AE000100023O000E480026002A080100010004973O002A08012O00AE000100034O00BB000200233O00202O0002000200B64O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001002A08013O0004973O002A08012O00AE000100053O0012C1000200C53O0012C1000300C64O00E4000100034O00052O016O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O01005C08013O0004973O005C08012O00AE0001002E3O0006182O01005C08013O0004973O005C08010012E5000100AE4O00D3000200053O00122O000300C73O00122O000400C86O00020004000200062O0001005C080100020004973O005C08012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA0001005C080100010004973O005C08012O00AE00015O0020B100010001009700209B0001000100042O00250001000200020006AA0001005C080100010004973O005C08012O00AE000100083O0026040001005C080100260004973O005C08012O00AE000100023O0026040001005C080100260004973O005C08012O00AE000100034O00BB000200233O00202O0002000200B14O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001005C08013O0004973O005C08012O00AE000100053O0012C1000200C93O0012C1000300CA4O00E4000100034O00052O016O00AE00015O0020B10001000100AD00209B00010001002E2O00250001000200020006182O01008E08013O0004973O008E08012O00AE0001002E3O0006182O01008E08013O0004973O008E08010012E5000100AE4O00D3000200053O00122O000300CB3O00122O000400CC6O00020004000200062O0001008E080100020004973O008E08012O00AE00015O0020B100010001009300209B0001000100042O00250001000200020006AA0001008E080100010004973O008E08012O00AE00015O0020B100010001009700209B0001000100042O00250001000200020006AA0001008E080100010004973O008E08012O00AE000100083O0026040001008E080100260004973O008E08012O00AE000100023O0026040001008E080100260004973O008E08012O00AE000100034O00BB000200233O00202O0002000200B64O000300043O00202O00030003005D00122O0005005E6O0003000500024O000300036O00010003000200062O0001008E08013O0004973O008E08012O00AE000100053O0012C1000200CD3O0012C1000300CE4O00E4000100034O00052O015O0012C13O00AC3O0004973O000100012O00833O00017O00FD3O00028O00026O001C40030A3O0046726F737453686F636B030A3O0049734361737461626C65030B3O00466C75784D656C74696E67030B3O004973417661696C61626C6503083O0042752O66446F776E030F3O00466C75784D656C74696E6742752O66030E3O0049735370652O6C496E52616E6765031C4O000D5DD4B84D980E1051CCEC618208185EC293668A141857D3EC2ADB03073O00EB667F32A7CC1203113O00456C65637472696669656453686F636B73030D3O00446562752O6652656D61696E7303173O00456C65637472696669656453686F636B73446562752O66027O0040030B3O0042752O6652656D61696E73030B3O004963656675727942752O66026O001840031C3O0056B3FA30501143A9FA204F6E43A8FB24482B6FB5F431432B44E1AD7103063O004E30C195432403093O004C617661427572737403113O004563682O6F66746865456C656D656E747303093O004C6176615375726765030F3O005072696D6F726469616C5375726765030E3O00456C656D656E74616C426C61737403133O004D61737465726F66746865456C656D656E747303093O00436173744379636C65031B3O003C1F96197E320B920B55700D8916463C1BBF0C402219850C01684A03053O0021507EE07803203O00E9A406C959E2BC02C863EEA402D748ACBB0ACA5BE0AD3CD05DFEAF06D01CB4FE03053O003C8CC863A4030E3O00436861696E4C696768746E696E6703133O00556E72656C656E74696E6743616C616D697479026O00F03F03203O0084FC052FACB8F80D21AA93FA0D28A5C7E70D28A58BF13B32A395F30132E2DFAC03053O00C2E7946446030D3O004C696768746E696E67426F6C7403103O005573654C696768746E696E67426F6C74031F3O004A45C6ABE2C64F42C69CF4C74A5881B0FFC64140C49CE2C9544BC4B7B6911603063O00A8262CA1C396026O00204003083O00446562752O66557003203O0085F0877B35E6A2178CC3807A31FBA25693F58C713CED890281EE857324A8E04E03083O0076E09CE2165088D6025O00805B4003113O00436861726765734672616374696F6E616C030C3O004C696768746E696E67526F64031C3O0044FC569356D14A884DED52C051E757874EEB669443FC5E8556AE0ED003043O00E0228E3903203O00DBABC0D076FF490FD298C7D172E2494ECDAECBDA7FF4621ADFB5C2D867B10A5C03083O006EBEC7A5BD13913D030A3O00456172746853686F636B03073O0049735265616479031C3O00DFEA65FC83F8C9E378EB8087C9E279EF87C2E5FF76FA8CC2CEAB20BC03063O00A7BA8B1788EB031C3O001CA7871E0E8A9B0515B6834D09BC860A16B0B7191BA78F080EF5DF5B03043O006D7AD5E803063O0042752O665570031B3O00E2F6B431D1F5B722FDE3E223E7F9A53CEBC8B631FCF0A724AEA0FA03043O00508E97C203073O0049636566757279030F3O00432O6F6C646F776E52656D61696E7303183O000AC5724A16D46E0C10CF794B0FC3485802D4704917862E1E03043O002C63A61703083O00497341637469766503043O004E616D6503173O005BE52C3727A16EB71A223CB671B70C3A36A979F93D373F03063O00C41C9749565303123O004C696768746E696E67526F64446562752O6603203O00F00B28198C67147FF40B3D1E8B561F36E00A27178E5D2762F2112E159618412203083O001693634970E2387803173O009F67E7F499BD67A2C699B767EFB5A8B470EFF083AC74EE03053O00EDD8158295031F3O008E475857A4C7578C49605DBFC54AC25D5651B7C55BBD5A5E4DB7CC4AC2170903073O003EE22E2O3FD0A9030D3O004C617661537572676542752O66031C3O00E30B5A900B323C56EA1A5EC30C042159E91C6A971E1F285BF1590CDB03083O003E857935E37F6D4F031D3O0016063DE6C291B1181B31FE96BDAB1E133EF0E9BAA3021337E196FFF24003073O00C270745295B6CE03213O003AA04D11CEDD0230AF440CCEEB003EE85F11CEE5023C975819D2E50B2DE81D489203073O006E59C82C78A082026O002240026O000840030C3O0053757267656F66506F776572031F3O00A7CA4C4E57443243ACFC2O494F5E7B5EA2CD4C4A46752F4CB9C44E5203196D03083O002DCBA32B26232A5B03103O0053757267656F66506F77657242752O66031F3O00DE8CDB2B93A75DDC82E32188A5409296D52D80A551ED91DD3180AC4092D68403073O0034B2E5BC43E7C903183O0028425502E24E3A6152590AF050261E555116F0593761150003073O004341213064973C2O033O00474344031C3O00D9F5A1CBE7E0F4A6D7F0D4A7BDD1FDD8EBAB2OE7DEF5A9DDE79FB3FC03053O0093BF87CEB8026O004940031C3O00823AA9D2CC6CA18C27A5CA9840BB8A2FAAC4E747B3962FA3D59807E603073O00D2E448C6A1B83303083O004C6176614265616D030E3O00417363656E64616E636542752O6603083O004361737454696D6503073O0048617354696572026O003F40026O001040031A3O003A48E5114CCC3348FE5060C7384EFF154CDA375BF415678E621F03063O00AE5629937013030A3O00417363656E64616E6365031B3O005A138E0E2B0B10A55805CD182C0116A75E3F990A370814BF1B52D903083O00CB3B60ED6B456F71031F3O00281FABE925FEDE2A1193E33EFCC36405A5EF36FCD21B02ADF336F5C36444FA03073O00B74476CC815190031A3O0002AC66E534800BAC7DA4188B00AA7CE134960FBF77E11FC25CF503063O00E26ECD10846B03203O00E8CBE1D04FD4CFE9DE49FFCDE9D746ABD0E9D746E7C6DFCD40F9C4E5CD01B89303053O00218BA380B9031B3O005B5912DF685A11CC444C44CD5E5603D2526710DF455F01CA170B5603043O00BE373864031F3O005AA63B1607EDFA58A8032O1CEFE716BC351014EFF669BB3D0C14E6E716FC6803073O009336CF5C7E7383030D3O0046697265456C656D656E74616C031E3O000B382778327B01343878036A0C3D756E04700A3D3042197F1F3630694D2C03063O001E6D51551D6D030E3O0053746F726D456C656D656E74616C031F3O00EC655BA43BE1F9F37459B338CAFDF33147BF38D9F0FA4E40B724D9F9EB310003073O009C9F1134D656BE030D3O00546F74656D6963526563612O6C03103O004C69717569644D61676D61546F74656D025O0080464003123O0053706C696E7465726564456C656D656E7473031E3O00BAE0A9B9A3E6BE83BCEABEBDA2E3FDAFA7E1BAB0ABD0A9BDBCE8B8A8EEB803043O00DCCE8FDD03173O004C69717569644D61676D61546F74656D53652O74696E6703063O0085683F04D7DE03073O00B2E61D4D77B8AC03103O00466C616D6553686F636B446562752O66030F3O0041757261416374697665436F756E7403163O004C69717569644D61676D61546F74656D437572736F7203093O004973496E52616E6765026O00444003223O00F9B71B0E7EFCCAB30B1C7AF9CAAA050F72F5B5AD031570F4F0811E1A65FFF0AA4A4303063O009895DE6A7B1703063O00CD2AF75AB0CF03053O00D5BD46962303163O004C69717569644D61676D61546F74656D506C6179657203223O00435C651D46514B054E52790970417B1C4A58341B465B73044A6A60095D52711C0F0D03043O00682F3514030E3O005072696D6F726469616C5761766503123O005072696D6F726469616C5761766542752O6603163O0053706C696E7465726564456C656D656E747342752O66030C3O004361737454617267657449662O033O00AE458F03063O006FC32CE17CDC03083O0053652O74696E677303073O00436F2O6D6F6E73030C3O00446973706C61795374796C6503093O005369676E617475726503203O00C854097EA4B9DC4F017F94BCD9500533B8A2D6410C7694BFD9540776BFEB891603063O00CBB8266013CB030A3O00466C616D6553686F636B030D3O00557365466C616D6553686F636B03113O00446562752O665265667265736861626C65030D3O004579656F6674686553746F726D030A3O0054616C656E7452616E6B025O00805640026O001440026O004E40031C3O003F7F784CCB0660714ECD32336A48C03E7F7C7EDA38617E44DA79222B03053O00AE5913192103143O00442O65706C79522O6F746564456C656D656E7473030D3O0053656172696E67466C616D6573030C3O004D61676D614368616D626572030B3O0053746F726D6B2O657065722O033O00221B5C03073O006B4F72322E97E7031C3O003FAAB4248F06A4C836A5BE699930B9C735A38A3D8B2BB0C52DE6E47D03083O00A059C6D549EA59D72O033O004578BA03053O00A52811D49E031C3O00E3D5093E23DACA003C25EE991B3A28E2D50D0C32E4CB0F3632A5885E03053O004685B96853030F3O0053746F726D6B2O6570657242752O66026O005D4003113O005377652O6C696E674D61656C7374726F6D031C3O0017514B38C40F40413ACC16055723C703494115DD0557432FDD44141C03053O00A96425244A031C3O001393AD420D8CA7551082B010138EAC570C829D440195A55514C7F00003043O003060E7C2031C3O00DB4E013F14D3AA86D85F1C6D0AD1A184C45F313918CAA886DC1A5C7F03083O00E3A83A6E4D79B8CF031B3O00773DA9418ED964B76828FF53B8D576A97E03AB41A3DC74B13B6AEF03083O00C51B5CDF20D1BB11025O00C05240025O00406040031B3O000F5ED5FA3C5DD6E9104B83E80A51C4F70660D7FA1158C6EF43099103043O009B633FA3030A3O0045617274687175616B6503113O0045617274687175616B6553652O74696E6703063O0081C4B39EB69603063O00E4E2B1C1EDD9031A3O004563686F65736F66477265617453756E646572696E6742752O6603103O0045617274687175616B65437572736F72031B3O0031B131F23CA136E73FB563F53DBE24EA318F37E726B726F274E67703043O008654D04303063O0003A0874516BE03043O003C73CCE603103O0045617274687175616B65506C61796572031B3O00E23BF964EF2BFE71EC3FAB63EE34EC7CE205FF71F53DEE64A76CBF03043O0010875A8B03063O0057611420414603073O0018341466532E3403163O004563686F65736F66477265617453756E646572696E67031B3O00C12E333007D53A202F0A843C282A08C82A1E300ED62824304F927903053O006FA44F414403063O00D6D582C72BF803063O008AA6B9E3BE4E031B3O00CE75D7235A320CCA7FC077412A17CC78C00846220BCC71D177047503073O0079AB14A557324303203O00CA31BE3EAD0CCF36BE09BB0DCA2CF925B00CC134BC09AD03D43FBC22F953966C03063O0062A658D956D9031D3O00F0E4761292E3E5FE76028D9CE5FF77068AD9C9E2781381D9E2B62851D003063O00BC2O961961E603213O00D9815E0B02D2D680580A18E3D38758421FE4D48E530733F9DB9B580718AD8BD90703063O008DBAE93F626C03203O00FDE32BBE31FFE322B11AF3E520A265E2E322B129F4D538B737F6EF38F674A0BA03053O0045918A4CD603083O0049734D6F76696E67031D3O0076C38884BA2963C7868AB45663C6878EB3134FDB889BB813648F2OD8ED03063O007610AF2OE9DF031D3O008D8834B6EBB46E838B36B0AE9874858339BED19F7C998330AFAEDA2CDF03073O001DEBE455DB8EEB026O002440025O00804E40025O00804840025O00804F40031C3O003BC6B5CE6371345A32D7B19D6447295531D185C9765C20572994EE8503083O00325DB4DABD172E47026O004240026O003840026O004340031C3O00D8B6545F50E35BD6AB584704CF41D0A357497BC849CCA35E5804891803073O0028BEC43B2C24BC031E3O0057696E64737065616B6572734C617661526573757267656E636542752O66031B3O003044CAB5C57F182E56C8F4E974033B49D98BEE7C1F3B40C8F4AF2F03073O006D5C25BCD49A1D031B3O0008EEB2C20E5811FDB7D771490DE1A3CF346510EEB6C4344E44BAF003063O003A648FC4A351031B3O00164335A2004BF01C095663B03647E2021F7D37A22D4EE01A5A177503083O006E7A2243C35F298503113O004D6F756E7461696E7357692O6C46612O6C031B3O0079B04D4BE977A44959C235A25244D179B4645ED767B62O5E9620E903053O00B615D13B2A031D3O00B145CA0E3581A45FCA1E2AFEA45ECB1A2DBB8843C40F26BBA317944C7703063O00DED737A57D4100B10C2O0012C13O00013O0026043O00082O0100020004973O00082O012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01002E00013O0004973O002E00012O00AE000100013O0006182O01002E00013O0004973O002E00012O00AE000100024O00F90001000100020006182O01002E00013O0004973O002E00012O00AE00015O0020B100010001000500209B0001000100062O00250001000200020006182O01002E00013O0004973O002E00012O00AE000100033O0020092O01000100074O00035O00202O0003000300084O00010003000200062O0001002E00013O0004973O002E00012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001002E00013O0004973O002E00012O00AE000100063O0012C10002000A3O0012C10003000B4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01006000013O0004973O006000012O00AE000100013O0006182O01006000013O0004973O006000012O00AE000100024O00F90001000100020006182O01006000013O0004973O006000012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O01004800013O0004973O004800012O00AE000100053O0020E800010001000D4O00035O00202O00030003000E4O00010003000200262O0001004F0001000F0004973O004F00012O00AE000100033O00206A0001000100104O00035O00202O0003000300114O00010003000200262O00010060000100120004973O006000012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001006000013O0004973O006000012O00AE000100063O0012C1000200133O0012C1000300144O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O01009F00013O0004973O009F00012O00AE000100073O0006182O01009F00013O0004973O009F00012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA0001008B000100010004973O008B00012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA0001008B000100010004973O008B00012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA0001008B000100010004973O008B00012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O01008B00013O0004973O008B00012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O01008B00013O0004973O008B00012O00AE000100084O00F90001000100020006182O01009F00013O0004973O009F00012O00AE000100093O0020BA00010001001B4O00025O00202O0002000200154O0003000A6O0004000B6O000500053O00202O0005000500094O00075O00202O0007000700154O0005000700024O000500056O00010005000200062O0001009F00013O0004973O009F00012O00AE000100063O0012C10002001C3O0012C10003001D4O00E4000100034O00052O016O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100B900013O0004973O00B900012O00AE0001000C3O0006182O0100B900013O0004973O00B900012O00AE000100044O002501025O00202O0002000200194O000300053O00202O0003000300094O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100B900013O0004973O00B900012O00AE000100063O0012C10002001E3O0012C10003001F4O00E4000100034O00052O016O00AE00015O0020B100010001002000209B0001000100062O00250001000200020006182O0100E300013O0004973O00E300012O00AE0001000D3O0006182O0100E300013O0004973O00E300012O00AE0001000E4O00F90001000100020006182O0100E300013O0004973O00E300012O00AE00015O0020B100010001002100209B0001000100062O00250001000200020006182O0100E300013O0004973O00E300012O00AE0001000F3O000E48002200E3000100010004973O00E300012O00AE000100103O000E48002200E3000100010004973O00E300012O00AE000100044O002501025O00202O0002000200204O000300053O00202O0003000300094O00055O00202O0005000500204O0003000500024O000300036O00010003000200062O000100E300013O0004973O00E300012O00AE000100063O0012C1000200233O0012C1000300244O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100072O013O0004973O00072O010012E5000100263O0006182O0100072O013O0004973O00072O012O00AE0001000E4O00F90001000100020006182O0100072O013O0004973O00072O012O00AE00015O0020B100010001002100209B0001000100062O00250001000200020006182O0100072O013O0004973O00072O012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100072O013O0004973O00072O012O00AE000100063O0012C1000200273O0012C1000300284O00E4000100034O00052O015O0012C13O00293O0026043O000D020100120004973O000D02012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100352O013O0004973O00352O012O00AE0001000C3O0006182O0100352O013O0004973O00352O012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O0100242O013O0004973O00242O012O00AE0001000E4O00F90001000100020006182O0100352O013O0004973O00352O012O00AE000100053O0020092O010001002A4O00035O00202O00030003000E4O00010003000200062O000100352O013O0004973O00352O012O00AE000100044O002501025O00202O0002000200194O000300053O00202O0003000300094O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100352O013O0004973O00352O012O00AE000100063O0012C10002002B3O0012C10003002C4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100732O013O0004973O00732O012O00AE000100013O0006182O0100732O013O0004973O00732O012O00AE000100024O00F90001000100020006182O0100732O013O0004973O00732O012O00AE0001000E4O00F90001000100020006182O0100732O013O0004973O00732O012O00AE000100114O00F90001000100020026062O0100732O01002D0004973O00732O012O00AE00015O0020B100010001001500209B00010001002E2O00250001000200020026062O0100732O0100220004973O00732O012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O0100732O013O0004973O00732O012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100732O013O0004973O00732O012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006AA000100732O0100010004973O00732O012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100732O013O0004973O00732O012O00AE000100063O0012C1000200303O0012C1000300314O00E4000100034O00052O016O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100972O013O0004973O00972O012O00AE0001000C3O0006182O0100972O013O0004973O00972O012O00AE0001000E4O00F90001000100020006AA000100862O0100010004973O00862O012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O0100972O013O0004973O00972O012O00AE000100044O002501025O00202O0002000200194O000300053O00202O0003000300094O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O000100972O013O0004973O00972O012O00AE000100063O0012C1000200323O0012C1000300334O00E4000100034O00052O016O00AE00015O0020B100010001003400209B0001000100352O00250001000200020006182O0100B12O013O0004973O00B12O012O00AE000100123O0006182O0100B12O013O0004973O00B12O012O00AE000100044O002501025O00202O0002000200344O000300053O00202O0003000300094O00055O00202O0005000500344O0003000500024O000300036O00010003000200062O000100B12O013O0004973O00B12O012O00AE000100063O0012C1000200363O0012C1000300374O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100E52O013O0004973O00E52O012O00AE000100013O0006182O0100E52O013O0004973O00E52O012O00AE000100024O00F90001000100020006182O0100E52O013O0004973O00E52O012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O0100E52O013O0004973O00E52O012O00AE0001000E4O00F90001000100020006182O0100E52O013O0004973O00E52O012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006AA000100E52O0100010004973O00E52O012O00AE0001000F3O000E48002200E52O0100010004973O00E52O012O00AE000100103O000E48002200E52O0100010004973O00E52O012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100E52O013O0004973O00E52O012O00AE000100063O0012C1000200383O0012C1000300394O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O01000C02013O0004973O000C02012O00AE000100073O0006182O01000C02013O0004973O000C02012O00AE000100033O0020092O010001003A4O00035O00202O0003000300084O00010003000200062O0001000C02013O0004973O000C02012O00AE0001000F3O000E480022000C020100010004973O000C02012O00AE000100093O0020BA00010001001B4O00025O00202O0002000200154O0003000A6O0004000B6O000500053O00202O0005000500094O00075O00202O0007000700154O0005000700024O000500056O00010005000200062O0001000C02013O0004973O000C02012O00AE000100063O0012C10002003B3O0012C10003003C4O00E4000100034O00052O015O0012C13O00023O0026043O0052030100290004973O005203012O00AE00015O0020B100010001003D00209B0001000100062O00250001000200020006182O01002F02013O0004973O002F02012O00AE00015O0020B100010001003D00209B00010001003E2O00250001000200020026040001002F020100010004973O002F02012O00AE000100133O0006182O01002F02013O0004973O002F02012O00AE000100044O002501025O00202O00020002003D4O000300053O00202O0003000300094O00055O00202O00050005003D4O0003000500024O000300036O00010003000200062O0001002F02013O0004973O002F02012O00AE000100063O0012C10002003F3O0012C1000300404O00E4000100034O00052O016O00AE00015O0020B100010001002000209B0001000100062O00250001000200020006182O01006F02013O0004973O006F02012O00AE0001000D3O0006182O01006F02013O0004973O006F02012O00AE000100143O00209B0001000100412O00250001000200020006182O01006F02013O0004973O006F02012O00AE000100143O0020260001000100424O0001000200024O000200063O00122O000300433O00122O000400446O00020004000200062O0001006F020100020004973O006F02012O00AE000100053O0020092O010001002A4O00035O00202O0003000300454O00010003000200062O0001006F02013O0004973O006F02012O00AE000100053O00203700010001002A4O00035O00202O00030003000E4O00010003000200062O00010058020100010004973O005802012O00AE0001000E4O00F90001000100020006182O01006F02013O0004973O006F02012O00AE0001000F3O000E480022006F020100010004973O006F02012O00AE000100103O000E480022006F020100010004973O006F02012O00AE000100044O002501025O00202O0002000200204O000300053O00202O0003000300094O00055O00202O0005000500204O0003000500024O000300036O00010003000200062O0001006F02013O0004973O006F02012O00AE000100063O0012C1000200463O0012C1000300474O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100A902013O0004973O00A902010012E5000100263O0006182O0100A902013O0004973O00A902012O00AE000100143O00209B0001000100412O00250001000200020006182O0100A902013O0004973O00A902012O00AE000100143O0020260001000100424O0001000200024O000200063O00122O000300483O00122O000400496O00020004000200062O000100A9020100020004973O00A902012O00AE000100053O0020092O010001002A4O00035O00202O0003000300454O00010003000200062O000100A902013O0004973O00A902012O00AE000100053O00203700010001002A4O00035O00202O00030003000E4O00010003000200062O00010098020100010004973O009802012O00AE0001000E4O00F90001000100020006182O0100A902013O0004973O00A902012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100A902013O0004973O00A902012O00AE000100063O0012C10002004A3O0012C10003004B4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100EA02013O0004973O00EA02012O00AE000100013O0006182O0100EA02013O0004973O00EA02012O00AE000100024O00F90001000100020006182O0100EA02013O0004973O00EA02012O00AE0001000E4O00F90001000100020006182O0100EA02013O0004973O00EA02012O00AE000100033O0020092O01000100074O00035O00202O00030003004C4O00010003000200062O000100EA02013O0004973O00EA02012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006AA000100EA020100010004973O00EA02012O00AE00015O0020B100010001000500209B0001000100062O00250001000200020006AA000100EA020100010004973O00EA02012O00AE00015O0020B100010001001500209B00010001002E2O00250001000200020026062O0100EA020100220004973O00EA02012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006182O0100EA02013O0004973O00EA02012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100EA02013O0004973O00EA02012O00AE000100063O0012C10002004D3O0012C10003004E4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01001A03013O0004973O001A03012O00AE000100013O0006182O01001A03013O0004973O001A03012O00AE000100024O00F90001000100020006182O01001A03013O0004973O001A03012O00AE00015O0020B100010001000500209B0001000100062O00250001000200020006AA00010009030100010004973O000903012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O01001A03013O0004973O001A03012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006AA0001001A030100010004973O001A03012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001001A03013O0004973O001A03012O00AE000100063O0012C10002004F3O0012C1000300504O00E4000100034O00052O016O00AE00015O0020B100010001002000209B0001000100062O00250001000200020006182O01005103013O0004973O005103012O00AE0001000D3O0006182O01005103013O0004973O005103012O00AE0001000E4O00F90001000100020006182O01005103013O0004973O005103012O00AE000100033O0020092O01000100074O00035O00202O00030003004C4O00010003000200062O0001005103013O0004973O005103012O00AE00015O0020B100010001001500209B00010001002E2O00250001000200020026062O010051030100220004973O005103012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006182O01005103013O0004973O005103012O00AE0001000F3O000E4800220051030100010004973O005103012O00AE000100103O000E4800220051030100010004973O005103012O00AE000100044O002501025O00202O0002000200204O000300053O00202O0003000300094O00055O00202O0005000500204O0003000500024O000300036O00010003000200062O0001005103013O0004973O005103012O00AE000100063O0012C1000200513O0012C1000300524O00E4000100034O00052O015O0012C13O00533O0026043O0086040100540004973O008604012O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O01007E03013O0004973O007E03010012E5000100263O0006182O01007E03013O0004973O007E03012O00AE000100084O00F90001000100020006182O01007E03013O0004973O007E03012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA0001007E030100010004973O007E03012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006AA0001007E030100010004973O007E03012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O0001007E03013O0004973O007E03012O00AE000100063O0012C1000200563O0012C1000300574O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100A503013O0004973O00A503010012E5000100263O0006182O0100A503013O0004973O00A503012O00AE000100033O0020092O010001003A4O00035O00202O0003000300584O00010003000200062O000100A503013O0004973O00A503012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O0100A503013O0004973O00A503012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100A503013O0004973O00A503012O00AE000100063O0012C1000200593O0012C10003005A4O00E4000100034O00052O016O00AE00015O0020B100010001003D00209B0001000100062O00250001000200020006182O0100D703013O0004973O00D703012O00AE00015O0020B100010001003D00209B00010001003E2O0025000100020002002604000100D7030100010004973O00D703012O00AE000100133O0006182O0100D703013O0004973O00D703012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O0100D703013O0004973O00D703012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O0100D703013O0004973O00D703012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O0100D703013O0004973O00D703012O00AE000100044O002501025O00202O00020002003D4O000300053O00202O0003000300094O00055O00202O00050005003D4O0003000500024O000300036O00010003000200062O000100D703013O0004973O00D703012O00AE000100063O0012C10002005B3O0012C10003005C4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01001204013O0004973O001204012O00AE000100013O0006182O01001204013O0004973O001204012O00AE000100024O00F90001000100020006182O01001204013O0004973O001204012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O01001204013O0004973O001204012O00AE000100053O0020E800010001000D4O00035O00202O00030003000E4O00010003000200262O000100FB0301000F0004973O00FB03012O00AE000100033O0020810001000100104O00035O00202O0003000300114O0001000300024O000200033O00202O00020002005D4O00020002000200062O00010012040100020004973O001204012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O01001204013O0004973O001204012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001001204013O0004973O001204012O00AE000100063O0012C10002005E3O0012C10003005F4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01004F04013O0004973O004F04012O00AE000100013O0006182O01004F04013O0004973O004F04012O00AE000100024O00F90001000100020006182O01004F04013O0004973O004F04012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006182O01004F04013O0004973O004F04012O00AE000100114O00F9000100010002000E720060004F040100010004973O004F04012O00AE000100053O00202400010001000D4O00035O00202O00030003000E4O0001000300024O000200033O00202O00020002005D4O00020002000200102O0002000F000200062O0001004F040100020004973O004F04012O00AE000100084O00F90001000100020006182O01004F04013O0004973O004F04012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006182O01004F04013O0004973O004F04012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001004F04013O0004973O004F04012O00AE000100063O0012C1000200613O0012C1000300624O00E4000100034O00052O016O00AE00015O0020B100010001006300209B0001000100042O00250001000200020006182O01008504013O0004973O008504012O00AE000100153O0006182O01008504013O0004973O008504012O00AE0001000F3O000E4800220085040100010004973O008504012O00AE000100103O000E4800220085040100010004973O008504012O00AE0001000E4O00F90001000100020006182O01008504013O0004973O008504012O00AE000100033O0020E10001000100104O00035O00202O0003000300644O0001000300024O00025O00202O00020002006300202O0002000200654O00020002000200062O00020085040100010004973O008504012O00AE000100033O0020DE00010001006600122O000300673O00122O000400686O00010004000200062O00010085040100010004973O008504012O00AE000100044O002501025O00202O0002000200634O000300053O00202O0003000300094O00055O00202O0005000500634O0003000500024O000300036O00010003000200062O0001008504013O0004973O008504012O00AE000100063O0012C1000200693O0012C10003006A4O00E4000100034O00052O015O0012C13O00683O0026043O007D0501000F0004973O007D05012O00AE00015O0020B100010001006B00209B0001000100042O00250001000200020006182O0100AD04013O0004973O00AD04012O00AE000100163O0006182O0100AD04013O0004973O00AD04012O00AE000100173O0006182O01009704013O0004973O009704012O00AE000100183O0006AA0001009A040100010004973O009A04012O00AE000100173O0006AA000100AD040100010004973O00AD04012O00AE000100194O00AE0002001A3O00060A000100AD040100020004973O00AD04012O00AE000100084O00F90001000100020006AA000100AD040100010004973O00AD04012O00AE000100044O00AE00025O0020B100020002006B2O00250001000200020006182O0100AD04013O0004973O00AD04012O00AE000100063O0012C10002006C3O0012C10003006D4O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100D204013O0004973O00D204010012E5000100263O0006182O0100D204013O0004973O00D204012O00AE000100084O00F90001000100020006182O0100D204013O0004973O00D204012O00AE000100033O0020092O010001003A4O00035O00202O0003000300584O00010003000200062O000100D204013O0004973O00D204012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100D204013O0004973O00D204012O00AE000100063O0012C10002006E3O0012C10003006F4O00E4000100034O00052O016O00AE00015O0020B100010001006300209B0001000100042O00250001000200020006182O0100FC04013O0004973O00FC04012O00AE000100153O0006182O0100FC04013O0004973O00FC04012O00AE0001000F3O000E48002200FC040100010004973O00FC04012O00AE000100103O000E48002200FC040100010004973O00FC04012O00AE000100084O00F90001000100020006182O0100FC04013O0004973O00FC04012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA000100FC040100010004973O00FC04012O00AE000100044O002501025O00202O0002000200634O000300053O00202O0003000300094O00055O00202O0005000500634O0003000500024O000300036O00010003000200062O000100FC04013O0004973O00FC04012O00AE000100063O0012C1000200703O0012C1000300714O00E4000100034O00052O016O00AE00015O0020B100010001002000209B0001000100062O00250001000200020006182O01002605013O0004973O002605012O00AE0001000D3O0006182O01002605013O0004973O002605012O00AE0001000F3O000E4800220026050100010004973O002605012O00AE000100103O000E4800220026050100010004973O002605012O00AE000100084O00F90001000100020006182O01002605013O0004973O002605012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA00010026050100010004973O002605012O00AE000100044O002501025O00202O0002000200204O000300053O00202O0003000300094O00055O00202O0005000500204O0003000500024O000300036O00010003000200062O0001002605013O0004973O002605012O00AE000100063O0012C1000200723O0012C1000300734O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O01005405013O0004973O005405012O00AE000100073O0006182O01005405013O0004973O005405012O00AE000100084O00F90001000100020006182O01005405013O0004973O005405012O00AE0001000E4O00F90001000100020006AA00010054050100010004973O005405012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA00010054050100010004973O005405012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O01005405013O0004973O005405012O00AE000100044O002501025O00202O0002000200154O000300053O00202O0003000300094O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O0001005405013O0004973O005405012O00AE000100063O0012C1000200743O0012C1000300754O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O01007C05013O0004973O007C05010012E5000100263O0006182O01007C05013O0004973O007C05012O00AE000100084O00F90001000100020006182O01007C05013O0004973O007C05012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA0001007C050100010004973O007C05012O00AE0001000E4O00F90001000100020006182O01007C05013O0004973O007C05012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O0001007C05013O0004973O007C05012O00AE000100063O0012C1000200763O0012C1000300774O00E4000100034O00052O015O0012C13O00543O0026043O00C5060100010004973O00C506012O00AE00015O0020B100010001007800209B0001000100042O00250001000200020006182O0100A005013O0004973O00A005012O00AE0001001B3O0006182O0100A005013O0004973O00A005012O00AE0001001C3O0006182O01008E05013O0004973O008E05012O00AE000100183O0006AA00010091050100010004973O009105012O00AE0001001C3O0006AA000100A0050100010004973O00A005012O00AE000100194O00AE0002001A3O00060A000100A0050100020004973O00A005012O00AE000100044O00AE00025O0020B10002000200782O00250001000200020006182O0100A005013O0004973O00A005012O00AE000100063O0012C1000200793O0012C10003007A4O00E4000100034O00052O016O00AE00015O0020B100010001007B00209B0001000100042O00250001000200020006182O0100C105013O0004973O00C105012O00AE0001001D3O0006182O0100C105013O0004973O00C105012O00AE0001001E3O0006182O0100AF05013O0004973O00AF05012O00AE000100183O0006AA000100B2050100010004973O00B205012O00AE0001001E3O0006AA000100C1050100010004973O00C105012O00AE000100194O00AE0002001A3O00060A000100C1050100020004973O00C105012O00AE000100044O00AE00025O0020B100020002007B2O00250001000200020006182O0100C105013O0004973O00C105012O00AE000100063O0012C10002007C3O0012C10003007D4O00E4000100034O00052O016O00AE00015O0020B100010001007E00209B0001000100042O00250001000200020006182O0100ED05013O0004973O00ED05012O00AE0001001F3O0006182O0100ED05013O0004973O00ED05012O00AE00015O0020B100010001007F00209B00010001003E2O0025000100020002000E48008000ED050100010004973O00ED05012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006182O0100DC05013O0004973O00DC05012O00AE00015O0020B100010001008100209B0001000100062O00250001000200020006AA000100E2050100010004973O00E205012O00AE0001000F3O000E48002200ED050100010004973O00ED05012O00AE000100103O000E48002200ED050100010004973O00ED05012O00AE000100044O00AE00025O0020B100020002007E2O00250001000200020006182O0100ED05013O0004973O00ED05012O00AE000100063O0012C1000200823O0012C1000300834O00E4000100034O00052O016O00AE00015O0020B100010001007F00209B0001000100042O00250001000200020006182O01003906013O0004973O003906012O00AE000100203O0006182O01003906013O0004973O003906012O00AE000100213O0006182O0100FC05013O0004973O00FC05012O00AE000100183O0006AA000100FF050100010004973O00FF05012O00AE000100213O0006AA00010039060100010004973O003906012O00AE000100194O00AE0002001A3O00060A00010039060100020004973O003906010012E5000100844O00D3000200063O00122O000300853O00122O000400866O00020004000200062O00010039060100020004973O003906012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006182O01001606013O0004973O001606012O00AE00015O0020B100010001008100209B0001000100062O00250001000200020006AA00010029060100010004973O002906012O00AE00015O0020B100010001008700209B0001000100882O002500010002000200268C00010029060100010004973O002906012O00AE000100053O0020E800010001000D4O00035O00202O0003000300874O00010003000200262O00010029060100120004973O002906012O00AE0001000F3O000E4800220039060100010004973O003906012O00AE000100103O000E4800220039060100010004973O003906012O00AE000100044O00BB000200223O00202O0002000200894O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O0001003906013O0004973O003906012O00AE000100063O0012C10002008C3O0012C10003008D4O00E4000100034O00052O016O00AE00015O0020B100010001007F00209B0001000100042O00250001000200020006182O01008506013O0004973O008506012O00AE000100203O0006182O01008506013O0004973O008506012O00AE000100213O0006182O01004806013O0004973O004806012O00AE000100183O0006AA0001004B060100010004973O004B06012O00AE000100213O0006AA00010085060100010004973O008506012O00AE000100194O00AE0002001A3O00060A00010085060100020004973O008506010012E5000100844O00D3000200063O00122O0003008E3O00122O0004008F6O00020004000200062O00010085060100020004973O008506012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006182O01006206013O0004973O006206012O00AE00015O0020B100010001008100209B0001000100062O00250001000200020006AA00010075060100010004973O007506012O00AE00015O0020B100010001008700209B0001000100882O002500010002000200268C00010075060100010004973O007506012O00AE000100053O0020E800010001000D4O00035O00202O0003000300874O00010003000200262O00010075060100120004973O007506012O00AE0001000F3O000E4800220085060100010004973O008506012O00AE000100103O000E4800220085060100010004973O008506012O00AE000100044O00BB000200223O00202O0002000200904O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O0001008506013O0004973O008506012O00AE000100063O0012C1000200913O0012C1000300924O00E4000100034O00052O016O00AE00015O0020B100010001009300209B0001000100062O00250001000200020006182O0100C406013O0004973O00C406012O00AE000100233O0006182O0100C406013O0004973O00C406012O00AE000100243O0006182O0100C406013O0004973O00C406012O00AE000100194O00AE0002001A3O00060A000100C4060100020004973O00C406012O00AE000100253O0006182O0100C406013O0004973O00C406012O00AE000100033O0020092O01000100074O00035O00202O0003000300944O00010003000200062O000100C406013O0004973O00C406012O00AE000100033O0020092O01000100074O00035O00202O0003000300954O00010003000200062O000100C406013O0004973O00C406012O00AE000100093O0020540001000100964O00025O00202O0002000200934O0003000A6O000400063O00122O000500973O00122O000600986O0004000600024O000500266O000600066O000700053O00202O0007000700094O00095O00202O0009000900934O0007000900024O000700076O000800083O00122O000900993O00202O00090009009A00202O00090009009B00202O00090009009C4O00010009000200062O000100C406013O0004973O00C406012O00AE000100063O0012C10002009D3O0012C10003009E4O00E4000100034O00052O015O0012C13O00223O0026043O00DC080100220004973O00DC08012O00AE00015O0020B100010001009F00209B0001000100042O00250001000200020006182O01001407013O0004973O001407010012E5000100A03O0006182O01001407013O0004973O001407012O00AE0001000F3O00260400010014070100220004973O001407012O00AE000100053O0020092O01000100A14O00035O00202O0003000300874O00010003000200062O0001001407013O0004973O001407012O00AE000100033O0020092O01000100074O00035O00202O0003000300584O00010003000200062O0001001407013O0004973O001407012O00AE0001000E4O00F90001000100020006182O01000307013O0004973O000307012O00AE000100084O00F90001000100020006AA00010014070100010004973O001407012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100F906013O0004973O00F906012O00AE000100114O003B0001000100024O00025O00202O0002000200A200202O0002000200A34O00020002000200102O00020029000200102O000200A4000200062O00010003070100020004973O000307012O00AE000100114O00340001000100024O00025O00202O0002000200A200202O0002000200A34O00020002000200102O000200A5000200102O000200A6000200062O00010014070100020004973O001407012O00AE000100044O002501025O00202O00020002009F4O000300053O00202O0003000300094O00055O00202O00050005009F4O0003000500024O000300036O00010003000200062O0001001407013O0004973O001407012O00AE000100063O0012C1000200A73O0012C1000300A84O00E4000100034O00052O016O00AE00015O0020B100010001009F00209B0001000100042O00250001000200020006182O01007407013O0004973O007407010012E5000100A03O0006182O01007407013O0004973O007407012O00AE00015O0020B100010001008700209B0001000100882O002500010002000200260400010074070100010004973O007407012O00AE0001000F3O000E4800220074070100010004973O007407012O00AE000100103O000E4800220074070100010004973O007407012O00AE00015O0020B10001000100A900209B0001000100062O00250001000200020006AA00010047070100010004973O004707012O00AE00015O0020B100010001006B00209B0001000100062O00250001000200020006AA00010047070100010004973O004707012O00AE00015O0020B100010001009300209B0001000100062O00250001000200020006AA00010047070100010004973O004707012O00AE00015O0020B10001000100AA00209B0001000100062O00250001000200020006AA00010047070100010004973O004707012O00AE00015O0020B10001000100AB00209B0001000100062O00250001000200020006182O01007407013O0004973O007407012O00AE0001000E4O00F90001000100020006AA00010055070100010004973O005507012O00AE000100084O00F90001000100020006AA0001005B070100010004973O005B07012O00AE00015O0020B10001000100AC00209B00010001003E2O0025000100020002000E9D0001005B070100010004973O005B07012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA00010074070100010004973O007407012O00AE000100093O0020D40001000100964O00025O00202O00020002009F4O0003000A6O000400063O00122O000500AD3O00122O000600AE6O0004000600024O000500266O000600066O000700053O00202O0007000700094O00095O00202O00090009009F4O0007000900024O000700076O00010007000200062O0001007407013O0004973O007407012O00AE000100063O0012C1000200AF3O0012C1000300B04O00E4000100034O00052O016O00AE00015O0020B100010001009F00209B0001000100042O00250001000200020006182O0100D107013O0004973O00D107010012E5000100A03O0006182O0100D107013O0004973O00D107012O00AE0001000F3O000E48002200D1070100010004973O00D107012O00AE000100103O000E48002200D1070100010004973O00D107012O00AE00015O0020B10001000100A900209B0001000100062O00250001000200020006AA000100A1070100010004973O00A107012O00AE00015O0020B100010001006B00209B0001000100062O00250001000200020006AA000100A1070100010004973O00A107012O00AE00015O0020B100010001009300209B0001000100062O00250001000200020006AA000100A1070100010004973O00A107012O00AE00015O0020B10001000100AA00209B0001000100062O00250001000200020006AA000100A1070100010004973O00A107012O00AE00015O0020B10001000100AB00209B0001000100062O00250001000200020006182O0100D107013O0004973O00D107012O00AE000100033O0020092O010001003A4O00035O00202O0003000300584O00010003000200062O000100B207013O0004973O00B207012O00AE000100084O00F90001000100020006AA000100B2070100010004973O00B207012O00AE00015O0020B10001000100AC00209B0001000100062O00250001000200020006AA000100B8070100010004973O00B807012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006AA000100D1070100010004973O00D107012O00AE000100093O0020142O01000100964O00025O00202O00020002009F4O0003000A6O000400063O00122O000500B13O00122O000600B26O0004000600024O000500266O000600274O00AE000700053O0020310007000700094O00095O00202O00090009009F4O0007000900024O000700076O00010007000200062O000100D107013O0004973O00D107012O00AE000100063O0012C1000200B33O0012C1000300B44O00E4000100034O00052O016O00AE00015O0020B10001000100AC00209B0001000100062O00250001000200020006182O01003208013O0004973O003208012O00AE00015O0020B10001000100AC00209B00010001003E2O002500010002000200260400010032080100010004973O003208012O00AE000100033O00203700010001003A4O00035O00202O0003000300B54O00010003000200062O00010032080100010004973O003208012O00AE000100283O0006182O01003208013O0004973O003208012O00AE000100293O0006182O0100ED07013O0004973O00ED07012O00AE000100253O0006AA000100F0070100010004973O00F007012O00AE000100293O0006AA00010032080100010004973O003208012O00AE000100194O00AE0002001A3O00060A00010032080100020004973O003208012O00AE000100033O0020092O01000100074O00035O00202O0003000300644O00010003000200062O0001003208013O0004973O003208012O00AE000100084O00F90001000100020006AA00010032080100010004973O003208012O00AE000100114O00F9000100010002000E7200B60032080100010004973O003208012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O01003208013O0004973O003208012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006182O01003208013O0004973O003208012O00AE00015O0020B10001000100B700209B0001000100062O00250001000200020006182O01003208013O0004973O003208012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA00010032080100010004973O003208012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA00010032080100010004973O003208012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA00010032080100010004973O003208012O00AE000100044O00AE00025O0020B10002000200AC2O00250001000200020006182O01003208013O0004973O003208012O00AE000100063O0012C1000200B83O0012C1000300B94O00E4000100034O00052O016O00AE00015O0020B10001000100AC00209B0001000100062O00250001000200020006182O01008408013O0004973O008408012O00AE00015O0020B10001000100AC00209B00010001003E2O002500010002000200260400010084080100010004973O008408012O00AE000100033O00203700010001003A4O00035O00202O0003000300B54O00010003000200062O00010084080100010004973O008408012O00AE000100283O0006182O01008408013O0004973O008408012O00AE000100293O0006182O01004E08013O0004973O004E08012O00AE000100253O0006AA00010051080100010004973O005108012O00AE000100293O0006AA00010084080100010004973O008408012O00AE000100194O00AE0002001A3O00060A00010084080100020004973O008408012O00AE000100033O0020092O01000100074O00035O00202O0003000300644O00010003000200062O0001008408013O0004973O008408012O00AE000100084O00F90001000100020006AA00010084080100010004973O008408012O00AE000100033O0020092O010001003A4O00035O00202O0003000300584O00010003000200062O0001008408013O0004973O008408012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA00010084080100010004973O008408012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA00010084080100010004973O008408012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA00010084080100010004973O008408012O00AE000100044O00AE00025O0020B10002000200AC2O00250001000200020006182O01008408013O0004973O008408012O00AE000100063O0012C1000200BA3O0012C1000300BB4O00E4000100034O00052O016O00AE00015O0020B10001000100AC00209B0001000100062O00250001000200020006182O0100DB08013O0004973O00DB08012O00AE00015O0020B10001000100AC00209B00010001003E2O0025000100020002002604000100DB080100010004973O00DB08012O00AE000100033O00203700010001003A4O00035O00202O0003000300B54O00010003000200062O000100DB080100010004973O00DB08012O00AE000100283O0006182O0100DB08013O0004973O00DB08012O00AE000100293O0006182O0100A008013O0004973O00A008012O00AE000100253O0006AA000100A3080100010004973O00A308012O00AE000100293O0006AA000100DB080100010004973O00DB08012O00AE000100194O00AE0002001A3O00060A000100DB080100020004973O00DB08012O00AE000100033O0020092O01000100074O00035O00202O0003000300644O00010003000200062O000100DB08013O0004973O00DB08012O00AE000100084O00F90001000100020006AA000100DB080100010004973O00DB08012O00AE00015O0020B100010001005500209B0001000100062O00250001000200020006182O0100D008013O0004973O00D008012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100D008013O0004973O00D008012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA000100D0080100010004973O00D008012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA000100D0080100010004973O00D008012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006182O0100DB08013O0004973O00DB08012O00AE000100044O00AE00025O0020B10002000200AC2O00250001000200020006182O0100DB08013O0004973O00DB08012O00AE000100063O0012C1000200BC3O0012C1000300BD4O00E4000100034O00052O015O0012C13O000F3O0026043O00120A0100A50004973O00120A012O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O01000B09013O0004973O000B09012O00AE000100073O0006182O01000B09013O0004973O000B09012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O01000B09013O0004973O000B09012O00AE0001000E4O00F90001000100020006AA0001000B090100010004973O000B09012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006AA0001000B090100010004973O000B09012O00AE000100093O0020BA00010001001B4O00025O00202O0002000200154O0003000A6O0004000B6O000500053O00202O0005000500094O00075O00202O0007000700154O0005000700024O000500056O00010005000200062O0001000B09013O0004973O000B09012O00AE000100063O0012C1000200BE3O0012C1000300BF4O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O01004709013O0004973O004709012O00AE000100073O0006182O01004709013O0004973O004709012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O01004709013O0004973O004709012O00AE0001000E4O00F90001000100020006AA00010047090100010004973O004709012O00AE000100114O00F9000100010002000E0900C0002C090100010004973O002C09012O00AE000100114O00F9000100010002000E7200600047090100010004973O004709012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA00010047090100010004973O004709012O00AE00015O0020B10001000100B700209B0001000100062O00250001000200020006182O01004709013O0004973O004709012O00AE000100114O00F900010001000200261B00010047090100C10004973O004709012O00AE0001002A4O002501025O00202O0002000200154O000300053O00202O0003000300094O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O0001004709013O0004973O004709012O00AE000100063O0012C1000200C23O0012C1000300C34O00E4000100034O00052O016O00AE00015O0020B10001000100C400209B0001000100352O00250001000200020006182O01007A09013O0004973O007A09012O00AE0001002B3O0006182O01007A09013O0004973O007A09010012E5000100C54O00D3000200063O00122O000300C63O00122O000400C76O00020004000200062O0001007A090100020004973O007A09012O00AE000100033O0020092O010001003A4O00035O00202O0003000300C84O00010003000200062O0001007A09013O0004973O007A09012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA00010067090100010004973O006709012O00AE0001000F3O00260A2O01006A0901000F0004973O006A09012O00AE0001000F3O000E480022007A090100010004973O007A09012O00AE000100044O00BB000200223O00202O0002000200C94O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O0001007A09013O0004973O007A09012O00AE000100063O0012C1000200CA3O0012C1000300CB4O00E4000100034O00052O016O00AE00015O0020B10001000100C400209B0001000100352O00250001000200020006182O0100AD09013O0004973O00AD09012O00AE0001002B3O0006182O0100AD09013O0004973O00AD09010012E5000100C54O00D3000200063O00122O000300CC3O00122O000400CD6O00020004000200062O000100AD090100020004973O00AD09012O00AE000100033O0020092O010001003A4O00035O00202O0003000300C84O00010003000200062O000100AD09013O0004973O00AD09012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA0001009A090100010004973O009A09012O00AE0001000F3O00260A2O01009D0901000F0004973O009D09012O00AE0001000F3O000E48002200AD090100010004973O00AD09012O00AE000100044O00BB000200223O00202O0002000200CE4O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O000100AD09013O0004973O00AD09012O00AE000100063O0012C1000200CF3O0012C1000300D04O00E4000100034O00052O016O00AE00015O0020B10001000100C400209B0001000100352O00250001000200020006182O0100DF09013O0004973O00DF09012O00AE0001002B3O0006182O0100DF09013O0004973O00DF09010012E5000100C54O00D3000200063O00122O000300D13O00122O000400D26O00020004000200062O000100DF090100020004973O00DF09012O00AE0001000F3O000E48002200DF090100010004973O00DF09012O00AE000100103O000E48002200DF090100010004973O00DF09012O00AE00015O0020B10001000100D300209B0001000100062O00250001000200020006AA000100DF090100010004973O00DF09012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100DF090100010004973O00DF09012O00AE000100044O00BB000200223O00202O0002000200C94O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O000100DF09013O0004973O00DF09012O00AE000100063O0012C1000200D43O0012C1000300D54O00E4000100034O00052O016O00AE00015O0020B10001000100C400209B0001000100352O00250001000200020006182O0100110A013O0004973O00110A012O00AE0001002B3O0006182O0100110A013O0004973O00110A010012E5000100C54O00D3000200063O00122O000300D63O00122O000400D76O00020004000200062O000100110A0100020004973O00110A012O00AE0001000F3O000E48002200110A0100010004973O00110A012O00AE000100103O000E48002200110A0100010004973O00110A012O00AE00015O0020B10001000100D300209B0001000100062O00250001000200020006AA000100110A0100010004973O00110A012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100110A0100010004973O00110A012O00AE000100044O00BB000200223O00202O0002000200CE4O000300053O00202O00030003008A00122O0005008B6O0003000500024O000300036O00010003000200062O000100110A013O0004973O00110A012O00AE000100063O0012C1000200D83O0012C1000300D94O00E4000100034O00052O015O0012C13O00123O0026043O00E60A0100530004973O00E60A012O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100450A013O0004973O00450A010012E5000100263O0006182O0100450A013O0004973O00450A012O00AE0001000E4O00F90001000100020006182O0100450A013O0004973O00450A012O00AE000100033O0020092O01000100074O00035O00202O00030003004C4O00010003000200062O000100450A013O0004973O00450A012O00AE00015O0020B100010001001500209B00010001002E2O00250001000200020026062O0100450A0100220004973O00450A012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006182O0100450A013O0004973O00450A012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100450A013O0004973O00450A012O00AE000100063O0012C1000200DA3O0012C1000300DB4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01006F0A013O0004973O006F0A012O00AE000100013O0006182O01006F0A013O0004973O006F0A012O00AE000100024O00F90001000100020006182O01006F0A013O0004973O006F0A012O00AE00015O0020B100010001000C00209B0001000100062O00250001000200020006AA0001006F0A0100010004973O006F0A012O00AE00015O0020B100010001000500209B0001000100062O00250001000200020006AA0001006F0A0100010004973O006F0A012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001006F0A013O0004973O006F0A012O00AE000100063O0012C1000200DC3O0012C1000300DD4O00E4000100034O00052O016O00AE00015O0020B100010001002000209B0001000100062O00250001000200020006182O01008F0A013O0004973O008F0A012O00AE0001000D3O0006182O01008F0A013O0004973O008F0A012O00AE0001000F3O000E480022008F0A0100010004973O008F0A012O00AE000100103O000E480022008F0A0100010004973O008F0A012O00AE000100044O002501025O00202O0002000200204O000300053O00202O0003000300094O00055O00202O0005000500204O0003000500024O000300036O00010003000200062O0001008F0A013O0004973O008F0A012O00AE000100063O0012C1000200DE3O0012C1000300DF4O00E4000100034O00052O016O00AE00015O0020B100010001002500209B0001000100062O00250001000200020006182O0100A90A013O0004973O00A90A010012E5000100263O0006182O0100A90A013O0004973O00A90A012O00AE000100044O002501025O00202O0002000200254O000300053O00202O0003000300094O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100A90A013O0004973O00A90A012O00AE000100063O0012C1000200E03O0012C1000300E14O00E4000100034O00052O016O00AE00015O0020B100010001009F00209B0001000100042O00250001000200020006182O0100CB0A013O0004973O00CB0A010012E5000100A03O0006182O0100CB0A013O0004973O00CB0A012O00AE000100033O00209B0001000100E22O00250001000200020006182O0100CB0A013O0004973O00CB0A012O00AE000100093O0020BA00010001001B4O00025O00202O00020002009F4O0003000A6O000400276O000500053O00202O0005000500094O00075O00202O00070007009F4O0005000700024O000500056O00010005000200062O000100CB0A013O0004973O00CB0A012O00AE000100063O0012C1000200E33O0012C1000300E44O00E4000100034O00052O016O00AE00015O0020B100010001009F00209B0001000100042O00250001000200020006182O0100E50A013O0004973O00E50A010012E5000100A03O0006182O0100E50A013O0004973O00E50A012O00AE000100044O002501025O00202O00020002009F4O000300053O00202O0003000300094O00055O00202O00050005009F4O0003000500024O000300036O00010003000200062O000100E50A013O0004973O00E50A012O00AE000100063O0012C1000200E53O0012C1000300E64O00E4000100034O00052O015O0012C13O00E73O000E3A006800920C013O0004973O00920C012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100410B013O0004973O00410B012O00AE000100013O0006182O0100410B013O0004973O00410B012O00AE000100024O00F90001000100020006182O0100410B013O0004973O00410B012O00AE000100084O00F90001000100020006182O0100410B013O0004973O00410B012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA000100410B0100010004973O00410B012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA000100410B0100010004973O00410B012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA000100410B0100010004973O00410B012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100410B013O0004973O00410B012O00AE000100114O00F9000100010002000E7200E800220B0100010004973O00220B012O00AE000100114O00F90001000100020026062O0100220B0100C00004973O00220B012O00AE00015O00201F00010001001500202O00010001003E4O0001000200024O000200033O00202O00020002005D4O00020002000200062O000200300B0100010004973O00300B012O00AE000100114O00F9000100010002000E7200E900410B0100010004973O00410B012O00AE000100114O00F90001000100020026062O0100410B0100EA0004973O00410B012O00AE00015O0020B100010001001500209B00010001003E2O0025000100020002000E48000100410B0100010004973O00410B012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100410B013O0004973O00410B012O00AE000100063O0012C1000200EB3O0012C1000300EC4O00E4000100034O00052O016O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100900B013O0004973O00900B012O00AE000100013O0006182O0100900B013O0004973O00900B012O00AE000100024O00F90001000100020006182O0100900B013O0004973O00900B012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA000100900B0100010004973O00900B012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA000100900B0100010004973O00900B012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100900B0100010004973O00900B012O00AE000100114O00F9000100010002000E7200ED00710B0100010004973O00710B012O00AE000100114O00F90001000100020026062O0100710B0100600004973O00710B012O00AE00015O00201F00010001001500202O00010001003E4O0001000200024O000200033O00202O00020002005D4O00020002000200062O0002007F0B0100010004973O007F0B012O00AE000100114O00F9000100010002000E7200EE00900B0100010004973O00900B012O00AE000100114O00F90001000100020026062O0100900B0100EF0004973O00900B012O00AE00015O0020B100010001001500209B00010001003E2O0025000100020002000E48000100900B0100010004973O00900B012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100900B013O0004973O00900B012O00AE000100063O0012C1000200F03O0012C1000300F14O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O0100E40B013O0004973O00E40B012O00AE000100073O0006182O0100E40B013O0004973O00E40B012O00AE000100033O0020092O010001003A4O00035O00202O0003000300F24O00010003000200062O000100E40B013O0004973O00E40B012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA000100D30B0100010004973O00D30B012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA000100D30B0100010004973O00D30B012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA000100D30B0100010004973O00D30B012O00AE000100114O00F9000100010002000E7200EA00BC0B0100010004973O00BC0B012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006AA000100D30B0100010004973O00D30B012O00AE000100114O00F9000100010002000E7200EF00CD0B0100010004973O00CD0B012O00AE000100033O0020092O010001003A4O00035O00202O0003000300C84O00010003000200062O000100CD0B013O0004973O00CD0B012O00AE0001000F3O000E48002200CD0B0100010004973O00CD0B012O00AE000100103O000E9D002200D30B0100010004973O00D30B012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100E40B0100010004973O00E40B012O00AE000100044O002501025O00202O0002000200154O000300053O00202O0003000300094O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O000100E40B013O0004973O00E40B012O00AE000100063O0012C1000200F33O0012C1000300F44O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O0100230C013O0004973O00230C012O00AE000100073O0006182O0100230C013O0004973O00230C012O00AE000100033O0020092O010001003A4O00035O00202O00030003004C4O00010003000200062O000100230C013O0004973O00230C012O00AE00015O0020B100010001001600209B0001000100062O00250001000200020006AA000100120C0100010004973O00120C012O00AE00015O0020B100010001001700209B0001000100062O00250001000200020006AA000100120C0100010004973O00120C012O00AE00015O0020B100010001001800209B0001000100062O00250001000200020006AA000100120C0100010004973O00120C012O00AE00015O0020B100010001001A00209B0001000100062O00250001000200020006182O0100120C013O0004973O00120C012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100230C0100010004973O00230C012O00AE000100044O002501025O00202O0002000200154O000300053O00202O0003000300094O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O000100230C013O0004973O00230C012O00AE000100063O0012C1000200F53O0012C1000300F64O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O0100540C013O0004973O00540C012O00AE000100073O0006182O0100540C013O0004973O00540C012O00AE000100033O0020092O010001003A4O00035O00202O0003000300644O00010003000200062O000100540C013O0004973O00540C012O00AE000100033O0020DE00010001006600122O000300673O00122O000400686O00010004000200062O000100400C0100010004973O00400C012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006AA000100540C0100010004973O00540C012O00AE000100093O0020BA00010001001B4O00025O00202O0002000200154O0003000A6O0004000B6O000500053O00202O0005000500094O00075O00202O0007000700154O0005000700024O000500056O00010005000200062O000100540C013O0004973O00540C012O00AE000100063O0012C1000200F73O0012C1000300F84O00E4000100034O00052O016O00AE00015O0020B100010001001500209B0001000100062O00250001000200020006182O0100910C013O0004973O00910C012O00AE000100073O0006182O0100910C013O0004973O00910C012O00AE000100033O0020092O01000100074O00035O00202O0003000300644O00010003000200062O000100910C013O0004973O00910C012O00AE00015O0020B100010001001900209B0001000100062O00250001000200020006182O0100700C013O0004973O00700C012O00AE00015O0020B10001000100F900209B0001000100062O00250001000200020006AA000100910C0100010004973O00910C012O00AE00015O0020B100010001002F00209B0001000100062O00250001000200020006AA000100910C0100010004973O00910C012O00AE000100033O00209000010001006600122O000300673O00122O000400686O00010004000200062O000100910C013O0004973O00910C012O00AE000100093O0020BA00010001001B4O00025O00202O0002000200154O0003000A6O0004000B6O000500053O00202O0005000500094O00075O00202O0007000700154O0005000700024O000500056O00010005000200062O000100910C013O0004973O00910C012O00AE000100063O0012C1000200FA3O0012C1000300FB4O00E4000100034O00052O015O0012C13O00A53O0026043O0001000100E70004973O000100012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O0100B00C013O0004973O00B00C012O00AE000100013O0006182O0100B00C013O0004973O00B00C012O00AE000100044O002501025O00202O0002000200034O000300053O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100B00C013O0004973O00B00C012O00AE000100063O0012A3000200FC3O00122O000300FD6O000100036O00015O00044O00B00C010004973O000100012O00833O00017O002A3O00028O00030A3O004175746F536869656C64030B3O004561727468536869656C64030A3O0049734361737461626C6503083O0042752O66446F776E030F3O004561727468536869656C6442752O6603093O00536869656C64557365030C3O0009D0D40EFA81DE4225D4CA1E03083O002A4CB1A67A92A18D030E3O00456C656D656E74616C4F72626974030B3O004973417661696C61626C6503063O0042752O665570030F3O004C696768746E696E67536869656C6403133O00A08B17DA7149B6820CCB7572E58704C77736F703063O0016C5EA65AE1903133O004C696768746E696E67536869656C6442752O6603103O00013DA2D462A1DE882A7496D47FAADB8203083O00E64D54C5BC16CFB703173O00F51DC1F498AFF93BFE2BD5F485A4FC31B919C7F582E1A203083O00559974A69CECC190026O00F03F027O0040030F3O00416E6365737472616C53706972697403073O0049735265616479030F3O00412O66656374696E67436F6D62617403063O00457869737473030D3O004973446561644F7247686F737403093O00497341506C6179657203093O0043616E412O7461636B03183O00416E6365737472616C5370697269744D6F7573656F766572031A3O00A5EE4EB6F714B6E1418CF710ADF244A7A40DABF55EB6EB16A1F203063O0060C4802DD384026O00084003103O003483785AC1BBA6D939B2684FDB2OBDCC03083O00B855ED1B3FB2CFD403193O00496D70726F766564466C616D65746F6E677565576561706F6E024O00804F224103113O00466C616D65746F6E677565576561706F6E03123O00466C616D656E746F6E677565576561706F6E031A3O000E5508520D4D06510F4C0C601F5C084F0757495A065A015E064D03043O003F683969030D3O00546172676574497356616C6964000A012O0012C13O00013O0026043O0066000100010004973O006600010012E5000100023O0006182O01003300013O0004973O003300012O00AE00015O0020B100010001000300209B0001000100042O00250001000200020006182O01003300013O0004973O003300012O00AE000100013O0020092O01000100054O00035O00202O0003000300064O00010003000200062O0001003300013O0004973O003300010012E5000100074O00D7000200023O00122O000300083O00122O000400096O00020004000200062O00010027000100020004973O002700012O00AE00015O0020B100010001000A00209B00010001000B2O00250001000200020006182O01003300013O0004973O003300012O00AE000100013O0020092O010001000C4O00035O00202O00030003000D4O00010003000200062O0001003300013O0004973O003300012O00AE000100034O00AE00025O0020B10002000200032O00250001000200020006182O01006200013O0004973O006200012O00AE000100023O0012A30002000E3O00122O0003000F6O000100036O00015O00044O006200010012E5000100023O0006182O01006200013O0004973O006200012O00AE00015O0020B100010001000D00209B0001000100042O00250001000200020006182O01006200013O0004973O006200012O00AE000100013O0020092O01000100054O00035O00202O0003000300104O00010003000200062O0001006200013O0004973O006200010012E5000100074O00D7000200023O00122O000300113O00122O000400126O00020004000200062O00010057000100020004973O005700012O00AE00015O0020B100010001000A00209B00010001000B2O00250001000200020006182O01006200013O0004973O006200012O00AE000100013O0020092O010001000C4O00035O00202O0003000300034O00010003000200062O0001006200013O0004973O006200012O00AE000100034O00AE00025O0020B100020002000D2O00250001000200020006182O01006200013O0004973O006200012O00AE000100023O0012C1000200133O0012C1000300144O00E4000100034O00052O016O00AE000100054O00F90001000100022O007A000100043O0012C13O00153O0026043O009E000100160004973O009E00012O00AE00015O0020B100010001001700209B0001000100042O00250001000200020006182O01009900013O0004973O009900012O00AE00015O0020B100010001001700209B0001000100182O00250001000200020006182O01009900013O0004973O009900012O00AE000100013O00209B0001000100192O00250001000200020006AA00010099000100010004973O009900012O00AE000100063O00209B00010001001A2O00250001000200020006182O01009900013O0004973O009900012O00AE000100063O00209B00010001001B2O00250001000200020006182O01009900013O0004973O009900012O00AE000100063O00209B00010001001C2O00250001000200020006182O01009900013O0004973O009900012O00AE000100013O00209B00010001001D2O00AE000300064O009E0001000300020006AA00010099000100010004973O009900012O00AE000100034O00AE000200073O0020B100020002001E2O00250001000200020006182O01009900013O0004973O009900012O00AE000100023O0012C10002001F3O0012C1000300204O00E4000100034O00052O016O00AE0001000A4O00530001000100022O007A000200094O007A000100083O0012C13O00213O0026043O00CB000100150004973O00CB00012O00AE000100043O0006182O0100A500013O0004973O00A500012O00AE000100044O0047000100024O00AE0001000B3O0006182O0100CA00013O0004973O00CA00012O00AE0001000B3O00209B00010001001A2O00250001000200020006182O0100CA00013O0004973O00CA00012O00AE0001000B3O00209B00010001001C2O00250001000200020006182O0100CA00013O0004973O00CA00012O00AE0001000B3O00209B00010001001B2O00250001000200020006182O0100CA00013O0004973O00CA00012O00AE000100013O00209B00010001001D2O00AE0003000B4O009E0001000300020006AA000100CA000100010004973O00CA00012O00AE000100034O004100025O00202O0002000200174O000300036O000400016O00010004000200062O000100CA00013O0004973O00CA00012O00AE000100023O0012C1000200223O0012C1000300234O00E4000100034O00052O015O0012C13O00163O0026043O0001000100210004973O000100012O00AE00015O0020B100010001002400209B00010001000B2O00250001000200020006182O0100ED00013O0004973O00ED00012O00AE0001000C3O0006182O0100ED00013O0004973O00ED00012O00AE000100083O0006182O0100DC00013O0004973O00DC00012O00AE000100093O0026062O0100ED000100250004973O00ED00012O00AE00015O0020B100010001002600209B00010001000B2O00250001000200020006182O0100ED00013O0004973O00ED00012O00AE000100034O00AE00025O0020B10002000200272O00250001000200020006182O0100ED00013O0004973O00ED00012O00AE000100023O0012C1000200283O0012C1000300294O00E4000100034O00052O016O00AE000100013O00209B0001000100192O00250001000200020006AA000100092O0100010004973O00092O012O00AE0001000D3O0006182O0100092O013O0004973O00092O012O00AE0001000E3O0020B100010001002A2O00F90001000100020006182O0100092O013O0004973O00092O010012C1000100013O002604000100FB000100010004973O00FB00012O00AE0002000F4O00F90002000100022O007A000200044O00AE000200043O000618010200092O013O0004973O00092O012O00AE000200044O0047000200023O0004973O00092O010004973O00FB00010004973O00092O010004973O000100012O00833O00017O003B3O00028O00027O004003053O00466F637573030C3O00477265617465725075726765030B3O004973417661696C61626C6503073O004973526561647903093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030E3O0049735370652O6C496E52616E676503143O000C95A1451F82B67B1B92B6430EC7A0450686A34103043O00246BE7C4026O00084003053O005075726765030C3O004DA0B08058F5A68650B4A58203043O00E73DD5C2030D3O00546172676574497356616C6964026O00F03F03043O00502O6F6C030E3O0039A2327F49AB3261498C327641E403043O001369CD5D03103O004E61747572657353776966746E652O73030A3O0049734361737461626C6503133O005573654E61747572657353776966746E652O7303193O00A709CA942DAC1BE19228A00ECA8F3ABA1B9E8C3EA0069ED06D03053O005FC968BEE1030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030E3O00417363656E64616E636542752O6603093O0046697265626C2O6F64030A3O00417363656E64616E6365030F3O00432O6F6C646F776E52656D61696E73026O00494003103O00A9C2D3CBADC7CEC1AB8BCCCFA6C5819803043O00AECFABA1030D3O00416E6365737472616C43612O6C03153O00ECF00EF6EBC32OFF01CCFBD6E1F24DFEF9DEE3BE5503063O00B78D9E6D939803093O00426C2O6F644675727903113O002E05E9032836E0193E10A6012D00E84C7E03043O006C4C6986030A3O004265727365726B696E6703113O00E9C0A3F2CBF9CEB8EFC9ABC8B0E8C0AB9103053O00AE8BA5D181030B3O004261676F66547269636B7303153O00A1B2E5FEC9054F6CB1BAE1CAD5437D79AABDA2909603083O0018C3D382A1A6631003173O00760CE62013104911A91F5A18410FEC1852044106FD641A03063O00762663894C33030F3O0048616E646C65412O666C6963746564030D3O00436C65616E736553706972697403163O00436C65616E73655370697269744D6F7573656F766572026O004440030B3O005472656D6F72546F74656D026O003E4003143O00506F69736F6E436C65616E73696E67546F74656D03113O0048616E646C65496E636F72706F7265616C2O033O00486578030C3O004865784D6F7573654F7665720051022O0012C13O00013O0026043O004D000100020004973O004D00010012E5000100033O0006182O01001600013O0004973O001600012O00AE00015O0006182O01001600013O0004973O001600010012C1000100013O0026040001000A000100010004973O000A00012O00AE000200024O00F90002000100022O007A000200014O00AE000200013O0006180102001600013O0004973O001600012O00AE000200014O0047000200023O0004973O001600010004973O000A00012O00AE000100033O0020B100010001000400209B0001000100052O00250001000200020006182O01004C00013O0004973O004C00012O00AE000100043O0006182O01004C00013O0004973O004C00012O00AE000100033O0020B100010001000400209B0001000100062O00250001000200020006182O01004C00013O0004973O004C00012O00AE000100053O0006182O01004C00013O0004973O004C00012O00AE000100063O0006182O01004C00013O0004973O004C00012O00AE000100073O00209B0001000100072O00250001000200020006AA0001004C000100010004973O004C00012O00AE000100073O00209B0001000100082O00250001000200020006AA0001004C000100010004973O004C00012O00AE000100083O0020B10001000100092O00AE000200094O00250001000200020006182O01004C00013O0004973O004C00012O00AE0001000A4O0025010200033O00202O0002000200044O000300093O00202O00030003000A4O000500033O00202O0005000500044O0003000500024O000300036O00010003000200062O0001004C00013O0004973O004C00012O00AE0001000B3O0012C10002000B3O0012C10003000C4O00E4000100034O00052O015O0012C13O000D3O0026043O00DD2O01000D0004973O00DD2O012O00AE000100033O0020B100010001000E00209B0001000100062O00250001000200020006182O01007F00013O0004973O007F00012O00AE000100043O0006182O01007F00013O0004973O007F00012O00AE000100053O0006182O01007F00013O0004973O007F00012O00AE000100063O0006182O01007F00013O0004973O007F00012O00AE000100073O00209B0001000100072O00250001000200020006AA0001007F000100010004973O007F00012O00AE000100073O00209B0001000100082O00250001000200020006AA0001007F000100010004973O007F00012O00AE000100083O0020B10001000100092O00AE000200094O00250001000200020006182O01007F00013O0004973O007F00012O00AE0001000A4O0025010200033O00202O00020002000E4O000300093O00202O00030003000A4O000500033O00202O00050005000E4O0003000500024O000300036O00010003000200062O0001007F00013O0004973O007F00012O00AE0001000B3O0012C10002000F3O0012C1000300104O00E4000100034O00052O016O00AE000100083O0020B10001000100112O00F90001000100020006182O01005002013O0004973O005002012O00AE000100073O00209B0001000100082O00250001000200020006AA00010050020100010004973O005002012O00AE000100073O00209B0001000100072O00250001000200020006AA00010050020100010004973O005002010012C1000100014O0085000200023O002604000100BA000100020004973O00BA00010006180102009500013O0004973O009500012O0047000200024O00AE0003000C3O000618010300B900013O0004973O00B900012O00AE0003000D3O000E48000200B9000100030004973O00B900012O00AE0003000E3O000E48000200B9000100030004973O00B900010012C1000300013O002604000300AA000100010004973O00AA00012O00AE0004000F4O00F90004000100022O007A000400014O00AE000400013O000618010400A900013O0004973O00A900012O00AE000400014O0047000400023O0012C1000300123O0026040003009F000100120004973O009F00012O00AE0004000A4O00AE000500033O0020B10005000500132O0025000400020002000618010400B900013O0004973O00B900012O00AE0004000B3O0012A3000500143O00122O000600156O000400066O00045O00044O00B900010004973O009F00010012C10001000D3O002604000100DA000100120004973O00DA00012O00AE000300033O0020B100030003001600209B0003000300172O0025000300020002000618010300D000013O0004973O00D000010012E5000300183O000618010300D000013O0004973O00D000012O00AE0003000A4O00AE000400033O0020B10004000400162O0025000300020002000618010300D000013O0004973O00D000012O00AE0003000B3O0012C1000400193O0012C10005001A4O00E4000300054O000501036O00AE000300083O00200001030003001B4O000400073O00202O00040004001C4O000600033O00202O00060006001D4O000400066O00033O00024O000200033O00122O000100023O002604000100BD2O0100010004973O00BD2O012O00AE000300104O00AE000400113O00060A0003009F2O0100040004973O009F2O012O00AE000300123O0006180103009F2O013O0004973O009F2O012O00AE000300133O000618010300E900013O0004973O00E900012O00AE000300143O0006AA000300EC000100010004973O00EC00012O00AE000300133O0006AA0003009F2O0100010004973O009F2O010012C1000300013O000E3A001200382O0100030004973O00382O012O00AE000400033O0020B100040004001E00209B0004000400172O0025000400020002000618010400132O013O0004973O00132O012O00AE000400033O0020B100040004001F00209B0004000400052O0025000400020002000618010400082O013O0004973O00082O012O00AE000400073O00203700040004001C4O000600033O00202O00060006001D4O00040006000200062O000400082O0100010004973O00082O012O00AE000400033O0020B100040004001F00209B0004000400202O0025000400020002000E48002100132O0100040004973O00132O012O00AE0004000A4O00AE000500033O0020B100050005001E2O0025000400020002000618010400132O013O0004973O00132O012O00AE0004000B3O0012C1000500223O0012C1000600234O00E4000400064O000501046O00AE000400033O0020B100040004002400209B0004000400172O0025000400020002000618010400372O013O0004973O00372O012O00AE000400033O0020B100040004001F00209B0004000400052O00250004000200020006180104002C2O013O0004973O002C2O012O00AE000400073O00203700040004001C4O000600033O00202O00060006001D4O00040006000200062O0004002C2O0100010004973O002C2O012O00AE000400033O0020B100040004001F00209B0004000400202O0025000400020002000E48002100372O0100040004973O00372O012O00AE0004000A4O00AE000500033O0020B10005000500242O0025000400020002000618010400372O013O0004973O00372O012O00AE0004000B3O0012C1000500253O0012C1000600264O00E4000400064O000501045O0012C1000300023O0026040003007D2O0100010004973O007D2O012O00AE000400033O0020B100040004002700209B0004000400172O00250004000200020006180104005E2O013O0004973O005E2O012O00AE000400033O0020B100040004001F00209B0004000400052O0025000400020002000618010400532O013O0004973O00532O012O00AE000400073O00203700040004001C4O000600033O00202O00060006001D4O00040006000200062O000400532O0100010004973O00532O012O00AE000400033O0020B100040004001F00209B0004000400202O0025000400020002000E480021005E2O0100040004973O005E2O012O00AE0004000A4O00AE000500033O0020B10005000500272O00250004000200020006180104005E2O013O0004973O005E2O012O00AE0004000B3O0012C1000500283O0012C1000600294O00E4000400064O000501046O00AE000400033O0020B100040004002A00209B0004000400172O00250004000200020006180104007C2O013O0004973O007C2O012O00AE000400033O0020B100040004001F00209B0004000400052O0025000400020002000618010400712O013O0004973O00712O012O00AE000400073O00200901040004001C4O000600033O00202O00060006001D4O00040006000200062O0004007C2O013O0004973O007C2O012O00AE0004000A4O00AE000500033O0020B100050005002A2O00250004000200020006180104007C2O013O0004973O007C2O012O00AE0004000B3O0012C10005002B3O0012C10006002C4O00E4000400064O000501045O0012C1000300123O000E3A000200ED000100030004973O00ED00012O00AE000400033O0020B100040004002D00209B0004000400172O00250004000200020006180104009F2O013O0004973O009F2O012O00AE000400033O0020B100040004001F00209B0004000400052O0025000400020002000618010400922O013O0004973O00922O012O00AE000400073O00200901040004001C4O000600033O00202O00060006001D4O00040006000200062O0004009F2O013O0004973O009F2O012O00AE0004000A4O00AE000500033O0020B100050005002D2O00250004000200020006180104009F2O013O0004973O009F2O012O00AE0004000B3O0012A30005002E3O00122O0006002F6O000400066O00045O00044O009F2O010004973O00ED00012O00AE000300104O00AE000400113O00060A000300BC2O0100040004973O00BC2O012O00AE000300153O000618010300BC2O013O0004973O00BC2O012O00AE000300143O000618010300AC2O013O0004973O00AC2O012O00AE000300163O0006AA000300AF2O0100010004973O00AF2O012O00AE000300163O0006AA000300BC2O0100010004973O00BC2O010012C1000300013O002604000300B02O0100010004973O00B02O012O00AE000400174O00F90004000100022O007A000400014O00AE000400013O000618010400BC2O013O0004973O00BC2O012O00AE000400014O0047000400023O0004973O00BC2O010004973O00B02O010012C1000100123O002604000100900001000D0004973O009000010012C1000300013O002604000300CB2O0100010004973O00CB2O012O00AE000400184O00F90004000100022O007A000400014O00AE000400013O000618010400CA2O013O0004973O00CA2O012O00AE000400014O0047000400023O0012C1000300123O002604000300C02O0100120004973O00C02O012O00AE0004000A4O00AE000500033O0020B10005000500132O00250004000200020006180104005002013O0004973O005002012O00AE0004000B3O0012A3000500303O00122O000600316O000400066O00045O00044O005002010004973O00C02O010004973O005002010004973O009000010004973O005002010026043O0044020100120004973O004402012O00AE000100193O0006182O01002C02013O0004973O002C02010012C1000100013O00260400010012020100010004973O001202012O00AE0002001A3O000618010200FB2O013O0004973O00FB2O010012C1000200013O002604000200E92O0100010004973O00E92O012O00AE000300083O00208D0003000300324O000400033O00202O0004000400334O0005001B3O00202O00050005003400122O000600356O0003000600024O000300016O000300013O00062O000300FB2O013O0004973O00FB2O012O00AE000300014O0047000300023O0004973O00FB2O010004973O00E92O012O00AE0002001C3O0006180102001102013O0004973O001102010012C1000200013O002604000200FF2O0100010004973O00FF2O012O00AE000300083O00208D0003000300324O000400033O00202O0004000400364O000500033O00202O00050005003600122O000600376O0003000600024O000300016O000300013O00062O0003001102013O0004973O001102012O00AE000300014O0047000300023O0004973O001102010004973O00FF2O010012C1000100123O002604000100E32O0100120004973O00E32O012O00AE0002001D3O0006180102002C02013O0004973O002C02010012C1000200013O00260400020018020100010004973O001802012O00AE000300083O00208D0003000300324O000400033O00202O0004000400384O000500033O00202O00050005003800122O000600376O0003000600024O000300016O000300013O00062O0003002C02013O0004973O002C02012O00AE000300014O0047000300023O0004973O002C02010004973O001802010004973O002C02010004973O00E32O012O00AE0001001E3O0006182O01004302013O0004973O004302010012C1000100013O00260400010030020100010004973O003002012O00AE000200083O0020B00002000200394O000300033O00202O00030003003A4O0004001B3O00202O00040004003B00122O000500376O000600016O0002000600024O000200016O000200013O00062O0002004302013O0004973O004302012O00AE000200014O0047000200023O0004973O004302010004973O003002010012C13O00023O0026043O0001000100010004973O000100012O00AE0001001F4O00F90001000100022O007A000100014O00AE000100013O0006182O01004E02013O0004973O004E02012O00AE000100014O0047000100023O0012C13O00123O0004973O000100012O00833O00017O003E3O00028O00026O00F03F030D3O00557365466C616D6553686F636B030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00E83500340521F023361A0623F603063O00409D46657269030D3O0055BBA2C5024FBBB3D0184FABAC03053O007020C8C783030A3O0039435991C0AE0439424503073O00424C303CD8A3CB030B3O00AF957CDF5ED825988378FE03073O0044DAE619933FAE027O0040026O00184003153O00BE3E5C5EBBA62F565CB3BF1D5A58BE80235D45958903053O00D6CD4A332C026O00144003163O00F645F3E97EFE61E3FB7AFB78EDE872F77BEBE87FD96803053O00179A2C829C03133O0017AFBFAB131F14ABA8A022121D91A4BA3E303503063O007371C6CDCE5603143O009743F1488972F25F8952F04E855BC953905FDD7E03043O003AE4379E03183O00A49BD92333BF31BD88DC193DBB308380C42611A43BBDAAF403073O0055D4E9B04E5CCD030C3O005F4B8DCE4B4E89C05F4A9BF603043O00822A38E803103O005573654C696768746E696E67426F6C7403103O00FFA621CF4938E2A12AEA4E38C8BA28F703063O005F8AD544832003133O005573654E61747572657353776966746E652O7303133O003F3BA46D773E3DB34665193FA84562242DB25003053O00164A48C12303113O00396AE1683E70E9573E7DED59204EE54E2903043O00384C1984026O000840026O00104003133O004BD2AE0AC64FD4A222E25FC6A627FB51D5AE2B03053O00AF3EA1CB4603103O0029CEC6353C2ED8E61F3031D8CD07343003053O00555CBDA37303113O003CBF350B3DA322350CA02O352CA224392503043O005849CC5003103O002F90134327DE2F8D13431ED33A8B336203063O00BA4EE370264903113O00E944F8765B7BF559F15C5472E859F45B5403063O001A9C379D3533030D3O0099CB13FCB94298D007CCB95B8903063O0030ECB876B9D8030D3O00F0AE5215CE26F1B54438C037EE03063O005485DD3750AF03113O00A8F42183CB59B0E22AB2C6509FEB25B5D303063O003CDD8744C6A7030E3O00FBAEFDB056D6FCB0F38647C9EBAF03063O00B98EDD98E32203103O004DD652CE4C27F255CC54C84630F654C903073O009738A5379A235303103O00B55000D9A54215E1AE660BEDA8420BFA03043O008EC02365030D3O00C3662C82F48FA918D27427A0E203083O0076B61549C387ECCC00E03O0012C13O00013O0026043O0024000100020004973O002400010012E5000100043O0020EF0001000100054O00025O00122O000300063O00122O000400076O0002000400024O00010001000200122O000100033O00122O000100043O00202O0001000100054O00025O00122O000300083O00122O000400096O0002000400024O0001000100024O000100013O00122O000100043O00202O0001000100054O00025O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100023O00122O000100043O00202O0001000100054O00025O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100033O00124O000E3O000E3A000F002F00013O0004973O002F00010012E5000100043O00203O01000100054O00025O00122O000300103O00122O000400116O0002000400024O0001000100024O000100043O00044O00DF00010026043O0052000100120004973O005200010012E5000100043O00201A2O01000100054O00025O00122O000300133O00122O000400146O0002000400024O0001000100024O000100053O00122O000100043O00202O0001000100054O00025O00122O000300153O00122O000400166O0002000400024O0001000100024O000100063O00122O000100043O00202O0001000100054O00025O00122O000300173O00122O000400186O0002000400024O0001000100024O000100073O00122O000100043O00202O0001000100054O00025O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100083O00124O000F3O0026043O00750001000E0004973O007500010012E5000100043O00200C2O01000100054O00025O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O000100093O00123F000100043O00202O0001000100054O00025O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200122O0001001D3O00123F000100043O00202O0001000100054O00025O00122O000300213O00122O000400226O0002000400024O00010001000200122O000100203O0012B8000100043O00202O0001000100054O00025O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000A3O00124O00253O000E3A0026009800013O0004973O009800010012E5000100043O00201A2O01000100054O00025O00122O000300273O00122O000400286O0002000400024O0001000100024O0001000B3O00122O000100043O00202O0001000100054O00025O00122O000300293O00122O0004002A6O0002000400024O0001000100024O0001000C3O00122O000100043O00202O0001000100054O00025O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O0001000D3O00122O000100043O00202O0001000100054O00025O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O0001000E3O00124O00123O000E3A000100BB00013O0004973O00BB00010012E5000100043O00201A2O01000100054O00025O00122O0003002F3O00122O000400306O0002000400024O0001000100024O0001000F3O00122O000100043O00202O0001000100054O00025O00122O000300313O00122O000400326O0002000400024O0001000100024O000100103O00122O000100043O00202O0001000100054O00025O00122O000300333O00122O000400346O0002000400024O0001000100024O000100113O00122O000100043O00202O0001000100054O00025O00122O000300353O00122O000400366O0002000400024O0001000100024O000100123O00124O00023O0026043O0001000100250004973O000100010012E5000100043O00201A2O01000100054O00025O00122O000300373O00122O000400386O0002000400024O0001000100024O000100133O00122O000100043O00202O0001000100054O00025O00122O000300393O00122O0004003A6O0002000400024O0001000100024O000100143O00122O000100043O00202O0001000100054O00025O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100153O00122O000100043O00202O0001000100054O00025O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O000100163O00124O00263O0004973O000100012O00833O00017O003A3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030C3O001D2F1F770D03F93B341F411603073O009D685C7A20646D03113O00B6B5CAE93C378CA8AAB2C0D80928992OAE03083O00CBC3C6AFAA5D47ED030F3O003B583BE15904F22A4E2CC6451EEE2303073O009C4E2B5EB53171026O00F03F026O00104003173O004C69717569644D61676D61546F74656D53652O74696E6703173O007EE1D5B602475473EFC9A23F4C6D77E5F7A61F57707CEF03073O00191288A4C36B23034O00030A3O004175746F536869656C64030A3O00E938BD4041B4C8BDE42903083O00D8884DC92F12DCA103093O00536869656C6455736503093O003EE422DF04D8B73EE903073O00E24D8C4BBA68BC03103O0095C7D7375BB7C7DE380F8AC6D93A43BD03053O002FD9AEB05F026O00144003143O00ADCE7323BC577D35ACCF770E95417122B9D3750703083O0046D8BD1662D23418030E3O00CFCC2OA6C0CECDA28BE0D2D6A59303053O00B3BABFC3E703153O00EC2C1DCCFC3E14EDF7382BF0EB3A19E9CD300CE1F403043O0084995F78027O004003133O00B0BC0D28E4CEB2B0BE2938FEDEA1BFB10B05C703073O00C0D1D26E4D97BA03163O00E10D212OECD0F2022ECEEACDE4022CEAFAE3F20C37F903063O00A4806342899F030D3O00019AFDAC0185DAB6098FFD963003043O00DE60E989026O00084003073O00B1B6A613A7DCD303073O0090D9D3C77FE89303093O00F02A3F24FA6A216CC803083O0024984F5E48B52562030E3O00C2CB420FC2CA403AE3D95538D2CC03043O005FB7B827026O00184003143O00BD3AE62A5D8E05862BF523558D36BA2BE22B7CB003073O0062D55F874634E003173O00F6A6C87B5DF0A4FA6346FBA2C4435BEAA6C45046F1B6D903053O00349EC3A91703113O0045617274687175616B6553652O74696E6703113O007FBD20608E246E8A71B90171922172857D03083O00EB1ADC5214E6551B031D3O009DB2ECE1788DA0E7D171BBB1E0D07D9C96E0D67CA9A7EFCE7D8BB5ECC603053O0014E8C189A2031B3O0037CCC092F5891A7E30EBCAB2E281207836D7E4A0E1801E7236DAC103083O001142BFA5C687EC7703243O001ABCAB23F0E1FFDE018CA216FEE6FFD801A89A1CEBEDE1E606BBA632F9EEE0D80CBBAB1703083O00B16FCFCE739F888C00DE3O0012C13O00013O0026043O001C000100010004973O001C00010012E5000100023O00202C0001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100033O00124O000A3O0026043O00400001000B0004973O004000010012E5000100023O0020440001000100034O000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200062O00010028000100010004973O002800010012C10001000F3O0012010001000C3O00123F000100023O00202O0001000100034O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200122O000100103O00122F000100023O00202O0001000100034O000200013O00122O000300143O00122O000400156O0002000400024O00010001000200062O0001003E000100010004973O003E00012O00AE000100013O0012C1000200163O0012C1000300174O009E000100030002001201000100133O0012C13O00183O000E3A000A005B00013O0004973O005B00010012E5000100023O00202C0001000100034O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100043O00122O000100023O00202O0001000100034O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O000100063O00124O001F3O000E3A001F007F00013O0004973O007F00010012E5000100023O0020440001000100034O000200013O00122O000300203O00122O000400216O0002000400024O00010001000200062O00010067000100010004973O006700010012C1000100014O007A000100073O00122F000100023O00202O0001000100034O000200013O00122O000300223O00122O000400236O0002000400024O00010001000200062O00010072000100010004973O007200010012C1000100014O007A000100083O00122F000100023O00202O0001000100034O000200013O00122O000300243O00122O000400256O0002000400024O00010001000200062O0001007D000100010004973O007D00010012C1000100014O007A000100093O0012C13O00263O0026043O009D000100180004973O009D00010012E5000100023O00200C2O01000100034O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O0001000A3O00122F000100023O00202O0001000100034O000200013O00122O000300293O00122O0004002A6O0002000400024O00010001000200062O00010093000100010004973O009300010012C1000100014O007A0001000B3O0012B8000100023O00202O0001000100034O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O0001000C3O00124O002D3O0026043O00C1000100260004973O00C100010012E5000100023O0020440001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100A9000100010004973O00A900010012C1000100014O007A0001000D3O00122F000100023O00202O0001000100034O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100B4000100010004973O00B400010012C1000100014O007A0001000E3O00122F000100023O00202O0001000100034O000200013O00122O000300333O00122O000400346O0002000400024O00010001000200062O000100BF000100010004973O00BF00010012C10001000F3O001201000100323O0012C13O000B3O000E3A002D000100013O0004973O000100010012E5000100023O00200C2O01000100034O000200013O00122O000300353O00122O000400366O0002000400024O0001000100024O0001000F3O0012E5000100023O00200C2O01000100034O000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000100103O0012E5000100023O00203O01000100034O000200013O00122O000300393O00122O0004003A6O0002000400024O0001000100024O000100113O00044O00DD00010004973O000100012O00833O00017O002B3O00028O00026O001440030C3O004570696353652O74696E677303083O0053652O74696E6773030F3O000D881E10D84A7E038F1C1DD75B5A0103073O003F65E97074B42F03113O00EB3AE316F433EA35EE1DEA26CC29E813F403063O0056A35B8D7298026O001040030D3O005B0E757F2E5B18607C3456234403053O005A336B1413030F3O0085F584E33483F7B5E02984FF8BC70D03053O005DED90E58F03113O003DF3F115024812C6FF0D02491BD8F1140E03063O0026759690796B034O0003113O002BB2E9323989EB372CB2E0290EB3EB392603043O005A4DDB8E03113O00CF0A353C5E156FF6101630580F49F2112F03073O001A866441592C6703163O00D8ED2426B6E3F620378BFFEF2914ACF8F7352FADE2F703053O00C491835043026O00F03F027O0040030B3O000BA3033C0AE110BB031C0B03063O00887ED0666878030A3O006D99CB71AE513450749903083O003118EAAE23CF325D030E3O0018E0F4867A09E6EEBF7818FADEAC03053O00116C929DE8026O000840030D3O0059C217E42EA458F41DF9278B6F03063O00C82BA3748D4F030E3O00AA2538ABB5F5EFAB3E2E97BFFAE603073O0083DF565DE3D09403103O00F656B39E18B4EF4CB8B12DBAF74CB9B803063O00D583252OD67D03123O000F2531BAF3343E35ABD52E3920ACE929272103053O0081464B45DF030D3O0062C2E0F979E362CEF1FC7AE95503063O008F26AB93891C030B3O00F48BAAE306EFF6C584BFE003073O00B4B0E2D993638300A93O0012C13O00013O0026043O0014000100020004973O001400010012E5000100033O00200C2O01000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O0012E5000100033O00203O01000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00044O00A800010026043O0038000100090004973O003800010012E5000100033O0020440001000100044O000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200062O00010020000100010004973O002000010012C1000100014O007A000100033O00122F000100033O00202O0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200062O0001002B000100010004973O002B00010012C1000100014O007A000100043O00122F000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200062O00010036000100010004973O003600010012C1000100104O007A000100053O0012C13O00023O0026043O0056000100010004973O005600010012E5000100033O0020440001000100044O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200062O00010044000100010004973O004400010012C1000100014O007A000100063O001213000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00124O00173O0026043O0071000100180004973O007100010012E5000100033O00202C0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00124O001F3O000E3A001F008C00013O0004973O008C00010012E5000100033O00202C0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O0001000100024O0001000E3O00124O00093O0026043O0001000100170004973O000100010012E5000100033O0020242O01000100044O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100113O00124O00183O00044O000100012O00833O00017O00293O00028O00026O00F03F027O0040030C3O004570696353652O74696E677303073O00546F2O676C657303063O00D7B03C17D6B503043O0067B3D94F03073O0047BE12DC4288B003073O00C32AD77CB521EC030D3O004973446561644F7247686F7374026O00084003113O00476574456E656D696573496E52616E6765026O00444003173O00476574456E656D696573496E53706C61736852616E6765026O0014402O033O006D6178031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74026O0010402O033O0002563403063O00986D39575E452O033O00F8D80F03083O00C899B76AC3DEB2342O033O0031E79B03063O003A5283E85D29030F3O00412O66656374696E67436F6D626174030D3O00436C65616E736553706972697403073O004973526561647903093O00466F637573556E6974026O003440026O003940030D3O00546172676574497356616C6964024O0080B3C540030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E73030C3O0049734368612O6E656C696E6703053O00466F637573030F3O0048616E646C65412O666C696374656403143O00506F69736F6E436C65616E73696E67546F74656D026O003E4003163O00436C65616E73655370697269744D6F7573656F766572030B3O005472656D6F72546F74656D0049012O0012C13O00013O0026043O000A000100010004973O000A00012O00AE00016O00D10001000100014O000100016O0001000100014O000100026O00010001000100124O00023O0026043O0023000100030004973O002300010012E5000100043O0020DA0001000100054O000200043O00122O000300063O00122O000400076O0002000400024O0001000100024O000100033O00122O000100043O00202O0001000100054O000200043O00122O000300083O00122O000400096O0002000400024O0001000100024O000100056O000100063O00202O00010001000A4O00010002000200062O0001002200013O0004973O002200012O00833O00013O0012C13O000B3O0026043O004D0001000B0004973O004D00012O00AE000100063O00201A00010001000C00122O0003000D6O0001000300024O000100076O000100093O00202O00010001000E00122O0003000F6O0001000300024O000100086O0001000A3O00062O0001004300013O0004973O004300010012C1000100013O00260400010033000100010004973O003300012O00AE000200074O005F000200026O0002000B3O00122O000200106O000300093O00202O00030003001100122O0005000F6O0003000500024O0004000B6O0002000400024O0002000C3O0004973O004C00010004973O003300010004973O004C00010012C1000100013O00260400010044000100010004973O004400010012C1000200024O007A0002000B3O0012C1000200024O007A0002000C3O0004973O004C00010004973O004400010012C13O00123O0026043O0068000100020004973O006800010012E5000100043O00202C0001000100054O000200043O00122O000300133O00122O000400146O0002000400024O0001000100024O0001000D3O00122O000100043O00202O0001000100054O000200043O00122O000300153O00122O000400166O0002000400024O0001000100024O0001000A3O00122O000100043O00202O0001000100054O000200043O00122O000300173O00122O000400186O0002000400024O0001000100024O0001000E3O00124O00033O0026043O0001000100120004973O000100012O00AE000100063O00209B0001000100192O00250001000200020006AA00010072000100010004973O007200012O00AE0001000F3O0006182O01009300013O0004973O009300010012C1000100014O0085000200023O000E3A0002007C000100010004973O007C00012O00AE000300103O0006180103009300013O0004973O009300012O00AE000300104O0047000300023O0004973O0093000100260400010074000100010004973O007400012O00AE0003000F3O0006CB00020088000100030004973O008800012O00AE000300113O0020B100030003001A00209B00030003001B2O00250003000200020006CB00020088000100030004973O008800012O00AE000200034O00AE000300123O0020C600030003001C4O000400026O000500133O00122O0006001D6O000700073O00122O0008001E6O0003000800024O000300103O00122O000100023O00044O007400012O00AE000100123O0020B100010001001F2O00F90001000100020006AA0001009D000100010004973O009D00012O00AE000100063O00209B0001000100192O00250001000200020006182O0100B400013O0004973O00B400010012C1000100013O002604000100AA000100020004973O00AA00012O00AE000200143O002604000200B4000100200004973O00B400012O00AE000200153O0020FF0002000200214O000300076O00048O0002000400024O000200143O00044O00B400010026040001009E000100010004973O009E00012O00AE000200153O00206D0002000200224O0002000100024O000200166O000200166O000200143O00122O000100023O00044O009E00012O00AE000100063O00209B0001000100232O00250001000200020006AA000100482O0100010004973O00482O012O00AE000100063O00209B0001000100232O00250001000200020006AA000100482O0100010004973O00482O010012C1000100013O002604000100E2000100020004973O00E200012O00AE000200063O00209B0002000200192O0025000200020002000618010200D400013O0004973O00D400010012C1000200013O002604000200C7000100010004973O00C700012O00AE000300174O00F90003000100022O007A000300104O00AE000300103O000618010300482O013O0004973O00482O012O00AE000300104O0047000300023O0004973O00482O010004973O00C700010004973O00482O010012C1000200013O002604000200D5000100010004973O00D500012O00AE000300184O00F90003000100022O007A000300104O00AE000300103O000618010300482O013O0004973O00482O012O00AE000300104O0047000300023O0004973O00482O010004973O00D500010004973O00482O01002604000100BF000100010004973O00BF00010012E5000200243O000618010200F700013O0004973O00F700012O00AE0002000F3O000618010200F700013O0004973O00F700010012C1000200013O002604000200EB000100010004973O00EB00012O00AE000300194O00F90003000100022O007A000300104O00AE000300103O000618010300F700013O0004973O00F700012O00AE000300104O0047000300023O0004973O00F700010004973O00EB00012O00AE0002001A3O000618010200442O013O0004973O00442O010012C1000200013O002604000200142O0100020004973O00142O012O00AE0003001B3O000618010300442O013O0004973O00442O010012C1000300013O000E3A0001003O0100030004973O003O012O00AE000400123O00208D0004000400254O000500113O00202O0005000500264O000600113O00202O00060006002600122O000700276O0004000700024O000400106O000400103O00062O000400442O013O0004973O00442O012O00AE000400104O0047000400023O0004973O00442O010004973O003O010004973O00442O01002604000200FB000100010004973O00FB00012O00AE0003001C3O0006180103002C2O013O0004973O002C2O010012C1000300013O0026040003001A2O0100010004973O001A2O012O00AE000400123O00208D0004000400254O000500113O00202O00050005001A4O000600133O00202O00060006002800122O0007000D6O0004000700024O000400106O000400103O00062O0004002C2O013O0004973O002C2O012O00AE000400104O0047000400023O0004973O002C2O010004973O001A2O012O00AE0003001D3O000618010300422O013O0004973O00422O010012C1000300013O000E3A000100302O0100030004973O00302O012O00AE000400123O00208D0004000400254O000500113O00202O0005000500294O000600113O00202O00060006002900122O000700276O0004000700024O000400106O000400103O00062O000400422O013O0004973O00422O012O00AE000400104O0047000400023O0004973O00422O010004973O00302O010012C1000200023O0004973O00FB00010012C1000100023O0004973O00BF00010004973O00482O010004973O000100012O00833O00017O00073O00028O0003103O00466C616D6553686F636B446562752O6603143O00526567697374657241757261547261636B696E67026O00F03F03053O005072696E74032F3O00A65BD51858319756DC556E37825AD11B1D3D9A17F505543CCD17E3004D2F8C45C410597F814E900D763E8D52C41A1303063O005FE337B0753D00163O0012C13O00013O0026043O000A000100010004973O000A00012O00AE00015O0020DD00010001000200202O0001000100034O0001000200014O000100016O00010001000100124O00043O0026043O0001000100040004973O000100012O00AE000100023O00204F0001000100054O000200033O00122O000300063O00122O000400076O000200046O00013O000100044O001500010004973O000100012O00833O00017O00", GetFEnv(), ...);
