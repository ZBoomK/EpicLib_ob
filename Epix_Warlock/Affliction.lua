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
											if (Enum > 0) then
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
											elseif (Stk[Inst[2]] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										elseif (Enum == 2) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											for Idx = Inst[2], Inst[3] do
												Stk[Idx] = nil;
											end
										end
									elseif (Enum <= 5) then
										if (Enum > 4) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 7) then
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 11) then
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
									elseif (Enum > 12) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[A] = Stk[A]();
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 17) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum == 19) then
											local A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Inst[3]));
											end
										else
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										end
									elseif (Enum > 21) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 25) then
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 26) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 31) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
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
							elseif (Enum <= 35) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 36) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum > 38) then
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
									elseif (Enum == 40) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 43) then
									if (Enum == 42) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
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
									end
								elseif (Enum <= 49) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 53) then
								if (Enum > 52) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 55) then
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
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum == 57) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 59) then
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
							elseif (Enum <= 62) then
								if (Enum == 61) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
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
							elseif (Enum <= 63) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Enum > 64) then
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum > 66) then
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
								else
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 68) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 69) then
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
						elseif (Enum <= 72) then
							if (Enum == 71) then
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
						elseif (Enum <= 73) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 74) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum > 76) then
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
											local A = Inst[2];
											Stk[A](Stk[A + 1]);
										end
									elseif (Enum > 78) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 81) then
									if (Enum == 80) then
										if (Inst[2] ~= Stk[Inst[4]]) then
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
									if (Inst[2] > Stk[Inst[4]]) then
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
							elseif (Enum <= 89) then
								if (Enum <= 86) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 91) then
								if (Enum == 90) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								else
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
									end
								end
							elseif (Enum <= 92) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 93) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum > 95) then
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
									end
								elseif (Enum > 97) then
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
							elseif (Enum <= 100) then
								if (Enum > 99) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 101) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 102) then
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
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum == 104) then
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
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 106) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 110) then
							if (Enum == 109) then
								local A = Inst[2];
								local T = Stk[A];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 111) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						elseif (Enum == 112) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 132) then
						if (Enum <= 122) then
							if (Enum <= 117) then
								if (Enum <= 115) then
									if (Enum > 114) then
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
								elseif (Enum > 116) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 119) then
								if (Enum == 118) then
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
									if (Inst[2] < Inst[4]) then
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
							elseif (Enum <= 120) then
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
							elseif (Enum > 121) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum > 123) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 125) then
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
							elseif (Enum > 126) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 129) then
							if (Enum > 128) then
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
						elseif (Enum <= 130) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 131) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
							Stk[Inst[2]] = Env;
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum <= 142) then
						if (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum > 133) then
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
							elseif (Enum <= 135) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 136) then
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
						elseif (Enum <= 139) then
							if (Enum > 138) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 141) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 147) then
						if (Enum <= 144) then
							if (Enum == 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							else
								local B;
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
						elseif (Enum <= 145) then
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
						elseif (Enum > 146) then
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
					elseif (Enum <= 149) then
						if (Enum > 148) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 150) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 151) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						do
							return Stk[Inst[2]];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
										end
									elseif (Enum > 155) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 158) then
									if (Enum == 157) then
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									else
										Stk[Inst[2]]();
									end
								elseif (Enum <= 159) then
									Stk[Inst[2]] = {};
								elseif (Enum == 160) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 166) then
								if (Enum <= 163) then
									if (Enum > 162) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 164) then
									local B;
									local A;
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
								elseif (Enum > 165) then
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
							elseif (Enum <= 168) then
								if (Enum > 167) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 169) then
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
							elseif (Enum == 170) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
							else
								local T;
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
						elseif (Enum <= 180) then
							if (Enum <= 175) then
								if (Enum <= 173) then
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
								elseif (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 177) then
								if (Enum == 176) then
									Env[Inst[3]] = Stk[Inst[2]];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 179) then
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
						elseif (Enum <= 185) then
							if (Enum <= 182) then
								if (Enum > 181) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 183) then
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
							elseif (Enum > 184) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 188) then
							if (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
						elseif (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 209) then
						if (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 192) then
									if (Enum == 191) then
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
								elseif (Enum > 193) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 196) then
								if (Enum == 195) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum > 200) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 202) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 203) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 206) then
							if (Enum > 205) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum == 208) then
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
					elseif (Enum <= 218) then
						if (Enum <= 213) then
							if (Enum <= 211) then
								if (Enum == 210) then
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
									Stk[Inst[2]] = {};
								end
							elseif (Enum > 212) then
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
						elseif (Enum <= 215) then
							if (Enum == 214) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
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
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 223) then
						if (Enum <= 220) then
							if (Enum == 219) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							end
						elseif (Enum <= 221) then
							local B;
							local A;
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
						elseif (Enum == 222) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum <= 225) then
						if (Enum > 224) then
							Stk[Inst[2]] = #Stk[Inst[3]];
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 226) then
						local B;
						local A;
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
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
					end
				elseif (Enum <= 266) then
					if (Enum <= 247) then
						if (Enum <= 237) then
							if (Enum <= 232) then
								if (Enum <= 230) then
									if (Enum == 229) then
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									else
										local A = Inst[2];
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Stk[Inst[4]]];
									end
								elseif (Enum > 231) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 235) then
								local B;
								local A;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 236) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 242) then
							if (Enum <= 239) then
								if (Enum > 238) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 240) then
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
							elseif (Enum == 241) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 244) then
							if (Enum > 243) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 245) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 246) then
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
					elseif (Enum <= 256) then
						if (Enum <= 251) then
							if (Enum <= 249) then
								if (Enum == 248) then
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
							elseif (Enum == 250) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 254) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 255) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						end
					elseif (Enum <= 261) then
						if (Enum <= 258) then
							if (Enum == 257) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 259) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 260) then
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
					elseif (Enum <= 263) then
						if (Enum > 262) then
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
					elseif (Enum <= 264) then
						local A = Inst[2];
						local B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
					elseif (Enum > 265) then
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
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								if (Enum == 267) then
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
							elseif (Enum == 269) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 272) then
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
							if not Stk[Inst[2]] then
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
						end
					elseif (Enum <= 280) then
						if (Enum <= 277) then
							if (Enum > 276) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 279) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
						end
					elseif (Enum <= 283) then
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
							if (Mvm[1] == 148) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
					elseif (Enum > 284) then
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
					if (Enum <= 290) then
						if (Enum <= 287) then
							if (Enum > 286) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 288) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 292) then
						if (Enum > 291) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							do
								return;
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum > 294) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
					if (Enum <= 297) then
						if (Enum == 296) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 299) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 302) then
					if (Enum == 301) then
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
					if not Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum == 304) then
					Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD98CC60CDDCCD82ED99AC118DDCAD831EFB4C950DDD6DA03083O007EB1A3BB4586DBA7031B3O00011FAB5F1B38A3552800A14C1B2EA4412806A1532D00AC09281AA303043O0027446FC2002E3O0012263O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000402012O000A0001001284000300063O00203F000400030007001284000500083O00203F000500050009001284000600083O00203F00060006000A00061B01073O000100062O00943O00064O00948O00943O00044O00943O00014O00943O00024O00943O00053O00203F00080003000B00203F00090003000C2O009F000A5O001284000B000D3O00061B010C0001000100022O00943O000A4O00943O000B4O0094000D00073O001204000E000E3O001204000F000F4O0086000D000F000200061B010E0002000100032O00943O00074O00943O00094O00943O00084O000A010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00C300025O00122O000300016O00045O00122O000500013O00042O0003002100012O006F00076O0030000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O000100042D0003000500012O006F000300054O0094000400024O0013000300044O006900036O0023012O00017O00073O00028O00026O00F03F025O0025B040025O00209E40025O0042B140025O00649640025O001BB040013A3O001204000200014O009D000300043O000E450002002B00010002000402012O002B0001001204000500013O0026190005000900010001000402012O00090001002EBC0003000500010004000402012O00050001002EBC0006002100010005000402012O0021000100261B0003002100010001000402012O00210001001204000600013O000E450001001A00010006000402012O001A00012O006F00076O003B000400073O00061D0104001900010001000402012O001900012O006F000700014O009400086O005B00096O009200076O006900075O001204000600023O000E500002001E00010006000402012O001E0001002EBC0007000E00010007000402012O000E0001001204000300023O000402012O00210001000402012O000E000100261B0003000400010002000402012O000400012O0094000600044O005B00076O009200066O006900065O000402012O00040001000402012O00050001000402012O00040001000402012O0039000100261B0002000200010001000402012O00020001001204000500013O000E450002003200010005000402012O00320001001204000200023O000402012O0002000100261B0005002E00010001000402012O002E0001001204000300014O009D000400043O001204000500023O000402012O002E0001000402012O000200012O0023012O00017O00593O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203053O008D2B13236003073O009BCB44705613C503093O006BD223EF4557F3FD5403083O009826BD569C2018852O033O00CC52B303043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003053O0091C2D4180D03063O004BDCA3B76A6203053O0023B5AE18F703053O00B962DAEB5703053O00E81834C9F003063O00CAAB5C4786BE03043O000AC03F9C03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03073O002FC1537F7179E003083O00876CAE3E121E179303083O0093FF2FD901A13DC203083O00A7D6894AAB78CE532O033O0085E53F03063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D903043O00CA212F8C03073O009CA84E40E0D47903073O006DA4DD7F20CD5E03083O00C42ECBB0124FA32D03083O009D347B0C3DF4E1BD03073O008FD8421E7E449B03073O009DC91FC7CAA0DC03083O0081CAA86DABA5C3B7030A3O00035E31D4D717F22B573903073O0086423857B8BE7403073O000B301BB716E82A03083O00555C5169DB798B41030A3O00DCB5564975DCE9BA5F4B03063O00BF9DD330251C03123O00FC10FA162FCD1AF03F32D613F81B36D01DF103053O005ABF7F947C03023O00494403163O005C823D077D952F037DAE2001778C2B056BA421137D9F03043O007718E74E03163O00A028A945CE52148E22B65ED445229723A64BD04C149003073O0071E24DC52ABC20030C3O0047657445717569706D656E74026O002A40028O00026O002C4003073O000D17E6B93515FF03043O00D55A7694030A3O007A28B25A44583ABD594303053O002D3B4ED436024O0080B3C54003103O005265676973746572466F724576656E7403143O00967197729471927F8964936C966B9F6E8560976203043O0020DA34D603103O007D1234ACFEB666555C0524B8E5B94A5403083O003A2E7751C891D02503103O005265676973746572496E466C69676874030A3O00188431A8A6AA1424802403073O00564BEC50CCC9DD03053O005A40628BEA03063O00EB122117E59E03183O006096E0827588FE9E618FE88B7D9FEF8F6F99E99A7E9DE49F03043O00DB30DAA103143O00D42O5D70FE7DDFD6545B6CF570C5CA505E65FE6B03073O008084111C29BB2F03063O0053657441504C025O0090704000C2013O00A7000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D00122O000E00046O000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000E00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00134O00145O00122O001500203O00122O001600216O0014001600024O0014000E00142O006F00155O001216001600223O00122O001700236O0015001700024O0015000E00154O00165O00122O001700243O00122O001800256O0016001800024O0015001500164O00165O00122O001700263O00122O001800276O0016001800024O0015001500164O00165O00122O001700283O00122O001800296O0016001800024O0016000E00164O00175O00122O0018002A3O00122O0019002B6O0017001900024O0016001600174O00175O00122O0018002C3O00122O0019002D6O0017001900024O0016001600174O00178O00188O00198O001A00293O00061B012A3O000100102O00943O00264O006F8O00943O00234O00943O00254O00943O00224O00943O00204O00943O00214O00943O00274O00943O00284O00943O00294O00943O001C4O00943O001B4O00943O001A4O00943O001D4O00943O001E4O00943O001F4O00A3002B5O00122O002C002E3O00122O002D002F6O002B002D00024O002B000E002B4O002C5O00122O002D00303O00122O002E00316O002C002E00024O002B002B002C2O00A3002C5O00122O002D00323O00122O002E00336O002C002E00024O002C000C002C4O002D5O00122O002E00343O00122O002F00356O002D002F00024O002C002C002D2O00A3002D5O00122O002E00363O00122O002F00376O002D002F00024O002D000D002D4O002E5O00122O002F00383O00122O003000396O002E003000024O002D002D002E2O009F002E00024O0033002F5O00122O0030003A3O00122O0031003B6O002F003100024O002F002D002F00202O002F002F003C4O002F000200022O003300305O00122O0031003D3O00122O0032003E6O0030003200024O0030002D003000202O00300030003C4O0030000200022O00AB00315O00122O0032003F3O00122O003300406O0031003300024O0031002D003100202O00310031003C4O003100326O002E3O0001002008012F000700412O00BB002F0002000200203F0030002F0042000693003000C200013O000402012O00C200012O00940030000D3O00203F0031002F00422O00BB00300002000200061D013000C500010001000402012O00C500012O00940030000D3O001204003100434O00BB00300002000200203F0031002F0044000693003100CD00013O000402012O00CD00012O00940031000D3O00203F0032002F00442O00BB00310002000200061D013100D000010001000402012O00D000012O00940031000D3O001204003200434O00BB0031000200022O006F00325O001203003300453O00122O003400466O0032003400024O0032001000324O00335O00122O003400473O00122O003500486O0033003500024O0032003200334O0033003E3O001204003F00493O001204004000493O00200801410004004A00061B01430001000100022O00943O002C4O006F8O002O01445O00122O0045004B3O00122O0046004C6O004400466O00413O00014O00415O00122O0042004D3O00122O0043004E6O0041004300024O0041002C004100202O00410041004F4O0041000200014O00415O00122O004200503O00122O004300516O0041004300024O0041002C004100202O00410041004F4O0041000200014O00415O00122O004200523O00122O004300536O0041004300024O0041002C004100202O00410041004F4O00410002000100202O00410004004A00061B01430002000100052O00943O00314O00943O002F4O00943O000D4O00943O00074O00943O00304O00B300445O00122O004500543O00122O004600556O004400466O00413O000100200801410004004A00061B01430003000100022O00943O003F4O00943O00404O00B300445O00122O004500563O00122O004600576O004400466O00413O000100061B01410004000100042O006F3O00014O00943O002C4O00943O00154O006F3O00023O00061B01420005000100052O006F3O00014O006F3O00024O00943O002C4O006F8O00943O00073O00061B01430006000100012O00943O002C3O00061B01440007000100012O00943O002C3O00061B01450008000100012O00943O002C3O00061B01460009000100042O00943O002C4O006F3O00014O006F8O006F3O00023O00061B0147000A000100012O00943O002C3O00061B0148000B000100012O00943O002C3O00061B0149000C000100012O00943O002C3O00061B014A000D000100012O00943O002C3O00061B014B000E000100012O00943O002C3O00061B014C000F000100012O00943O002C3O00061B014D0010000100012O00943O002C3O00061B014E0011000100012O00943O002C3O00061B014F0012000100012O00943O002C3O00061B01500013000100042O00943O002C4O006F8O00943O00144O00943O000B3O00061B015100140001000C2O00943O00384O00943O000B4O00943O002C4O006F8O00943O00394O00943O003A4O00943O00364O00943O00374O00943O003B4O00943O003C4O00943O00044O00943O00073O00061B01520015000100032O00943O002B4O00943O002E4O00943O00193O00061B01530016000100062O00943O00524O00943O002D4O006F8O00943O00144O00943O00324O00943O000B3O00061B01540017000100052O00943O003C4O00943O002C4O006F8O00943O00144O00943O002B3O00061B01550018000100192O00943O00194O00943O00544O00943O00534O00943O003D4O00943O00414O00943O00344O00943O002C4O006F8O00943O002B4O00943O00334O00943O004F4O00943O000B4O00943O00134O00943O00284O00943O00324O00943O00374O00943O00364O00943O00434O00943O00464O00943O00074O00943O004E4O00943O00404O00943O00394O00943O00294O00943O003E3O00061B015600190001001D2O00943O002C4O006F8O00943O002B4O00943O00334O00943O00454O00943O00494O00943O000B4O00943O00134O00943O00284O00943O00424O00943O00444O00943O00484O00943O00194O00943O00544O00943O00534O00943O00364O00943O00374O00943O00394O00943O00294O00943O003E4O00943O00074O00943O004B4O00943O004D4O00943O003A4O00943O00384O00943O00324O00943O00434O00943O00474O00943O00403O00061B0157001A000100252O00943O00184O00943O00354O00943O000B4O00943O002B4O00943O00074O00943O003F4O00943O00044O00943O00404O00943O00344O00943O00334O00943O003E4O00943O002C4O006F8O00943O00254O00943O000A4O00943O00144O00943O00134O00943O00284O00943O00324O00943O00174O00943O00504O00943O00094O00943O00514O00943O00374O00943O00364O00943O003A4O00943O00384O00943O00564O00943O00554O00943O00124O00943O00544O00943O00394O00943O00294O00943O001B4O00943O00534O00943O002A4O00943O00193O00061B0158001B000100022O00943O000E4O006F7O0020610059000E005800122O005A00596O005B00576O005C00586O0059005C00016O00013O001C3O00523O00028O00026O000840025O00A06940025O0052A240026O00F03F025O00C88040025O00608F40030C3O004570696353652O74696E677303083O0069CDF14253FC874903073O00E03AA885363A92030A3O007D5759F64587841F716603083O006B39362B9D15E6E7026O001040025O0008814003083O00D5C0D929EFCBCA2E03043O005D86A5AD03123O0097FCD5C728DCA76EAAC6C9D03FDDBA71B2F603083O001EDE92A1A25AAED203083O00D64B641EEC40771903043O006A852E1003093O006B357EF1554E68256703063O00203840139C3A027O0040025O00C49940025O00606E4003083O0074C921C80D49CB2603053O006427AC55BC03163O008476AD8521BF6DA9941CA374A0B73BA46CBC8C3ABE6C03053O0053CD18D9E0025O008CAE40025O00F2A840025O00549F4003083O001681AB580D86162O03083O007045E4DF2C64E871030D3O00FC1A06DFA27495C01009D69E4C03073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103113O0085A70541A4F9DABCBD264DA2E3FCB8BC1F03073O00AFCCC97124D68B03083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03093O000AA68D49D7787132BB03073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B03123O008DD12142A9D62D7FB4D72759B1D83245A9C003043O002CDDB94003083O0032E25C4B7A0FE05B03053O00136187283F030F3O009D493E36203F8A5D2130283DAF4E3603063O0051CE3C535B4F025O0050B240025O00DCB14003083O008BECCFD0B1E7DCD703043O00A4D889BB03103O00E7F5349AA3FF07DBE83682A9EA02DDE803073O006BB28651D2C69E025O007C9840025O0078A94003083O0034EBB1DA0EE0A2DD03043O00AE678EC5030B3O00633B5A0C3757F65D2D4B2B03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E030A3O006D4D001B26EE1B59521603073O0072383E6549478D025O0062AD40025O0068834003083O002O0B96D2A336099103053O00CA586EE2A603113O00EB0A83FBC3CD08B2F8DECA008CD9CBCE0A03053O00AAA36FE29703083O002235A62C47392E0203073O00497150D2582E57030F3O00A929CC1EEE8F2BFD1DF38823C33AD703053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030E3O0098CE15D87DF7A1C918E36CF9A3D803063O0096CDBD709018001B012O0012043O00014O009D000100013O000E450001000200013O000402012O00020001001204000100013O0026190001000900010002000402012O00090001002EBC0004004800010003000402012O00480001001204000200013O0026190002000E00010005000402012O000E0001002E890006001300010007000402012O001F0001001284000300084O0079000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400062O0003001C00010001000402012O001C0001001204000300014O001100035O0012040001000D3O000402012O0048000100261B0002000A00010001000402012O000A0001001204000300013O0026190003002600010005000402012O00260001002EAF000400280001000E000402012O00280001001204000200053O000402012O000A000100261B0003002200010001000402012O00220001001284000400084O0079000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O00040004000500062O0004003800010001000402012O00380001001204000400014O0011000400023O00128D000400086O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000400033O00122O000300053O00044O00220001000402012O000A000100261B0001008E00010017000402012O008E0001001204000200013O002EAF0019006000010018000402012O0060000100261B0002006000010005000402012O00600001001284000300084O0079000400013O00122O0005001A3O00122O0006001B6O0004000600024O0003000300044O000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400062O0003005D00010001000402012O005D0001001204000300014O0011000300043O001204000100023O000402012O008E000100261B0002004B00010001000402012O004B0001001204000300013O000E500005006700010003000402012O00670001002EBC001E00690001001F000402012O00690001001204000200053O000402012O004B0001002E89002000FAFF2O0020000402012O0063000100261B0003006300010001000402012O00630001001284000400084O0079000500013O00122O000600213O00122O000700226O0005000700024O0004000400054O000500013O00122O000600233O00122O000700246O0005000700024O00040004000500062O0004007B00010001000402012O007B0001001204000400014O0011000400053O0012A9000400086O000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O000500013O00122O000600273O00122O000700286O0005000700024O00040004000500062O0004008A00010001000402012O008A0001001204000400014O0011000400063O001204000300053O000402012O00630001000402012O004B000100261B000100B50001000D000402012O00B50001001284000200084O00A3000300013O00122O000400293O00122O0005002A6O0003000500024O0002000200034O000300013O00122O0004002B3O00122O0005002C6O0003000500024O0002000200032O002C010200073O00122O000200086O000300013O00122O0004002D3O00122O0005002E6O0003000500024O0002000200034O000300013O00122O0004002F3O00122O000500304O00860003000500022O003B0002000200032O002C010200083O00122O000200086O000300013O00122O000400313O00122O000500326O0003000500024O0002000200034O000300013O00122O000400333O00122O000500344O00860003000500022O003B0002000200032O0011000200093O000402012O001A2O0100261B000100E800010001000402012O00E80001001204000200013O002EAF003600CA00010035000402012O00CA0001000E45000500CA00010002000402012O00CA0001001284000300084O00A3000400013O00122O000500373O00122O000600386O0004000600024O0003000300044O000400013O00122O000500393O00122O0006003A6O0004000600024O0003000300042O00110003000A3O001204000100053O000402012O00E80001002EAF003B00B80001003C000402012O00B8000100261B000200B800010001000402012O00B80001001284000300084O00B2000400013O00122O0005003D3O00122O0006003E6O0004000600024O0003000300044O000400013O00122O0005003F3O00122O000600406O0004000600024O0003000300044O0003000B3O00122O000300086O000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O0003000C3O00122O000200053O00044O00B80001002619000100EC00010005000402012O00EC0001002E890045001BFF2O0046000402012O00050001001284000200084O0079000300013O00122O000400473O00122O000500486O0003000500024O0002000200034O000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300062O000200FA00010001000402012O00FA0001001204000200014O00110002000D3O0012A9000200086O000300013O00122O0004004B3O00122O0005004C6O0003000500024O0002000200034O000300013O00122O0004004D3O00122O0005004E6O0003000500024O00020002000300062O000200092O010001000402012O00092O01001204000200014O00110002000E3O00128D000200086O000300013O00122O0004004F3O00122O000500506O0003000500024O0002000200034O000300013O00122O000400513O00122O000500526O0003000500024O0002000200034O0002000F3O00122O000100173O00044O00050001000402012O001A2O01000402012O000200012O0023012O00017O000B3O00028O00026O00F03F03053O006686F6235A03043O004D2EE78303103O005265676973746572496E466C69676874025O0093B240025O00FCAA4003103O002353868F89288EFF0244969B9227A2FE03083O00907036E3EBE64ECD030A3O0080200EF8DF4C912703E803063O003BD3486F9CB000233O0012043O00013O00261B3O000C00010002000402012O000C00012O006F00016O009A000200013O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O00010002000100044O00220001002EAF0007000100010006000402012O0001000100261B3O000100010001000402012O000100012O006F00016O0015010200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100054O0001000200014O00018O000200013O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O0001000100054O00010002000100124O00023O00044O000100012O0023012O00017O000D3O00028O00025O00D3B240025O001C9940026O00F03F026O002C40025O00C2B140025O00A09D40025O00B4AB40025O00288D40030C3O0047657445717569706D656E74026O002A40025O0022AF40025O00B0A84000473O0012043O00014O009D000100013O00261B3O000200010001000402012O00020001001204000100013O002EBC0003001800010002000402012O0018000100261B0001001800010004000402012O001800012O006F000200013O00203F0002000200050006930002001300013O000402012O001300012O006F000200024O006F000300013O00203F0003000300052O00BB00020002000200061D0102001600010001000402012O001600012O006F000200023O001204000300014O00BB0002000200022O001100025O000402012O0046000100261B0001000500010001000402012O00050001001204000200013O002EBC0007002100010006000402012O0021000100261B0002002100010004000402012O00210001001204000100043O000402012O0005000100261B0002001B00010001000402012O001B0001001204000300013O002EAF0009003B00010008000402012O003B000100261B0003003B00010001000402012O003B00012O006F000400033O00201001040004000A4O0004000200024O000400016O000400013O00202O00040004000B00062O0004003600013O000402012O003600012O006F000400024O006F000500013O00203F00050005000B2O00BB00040002000200061D0104003900010001000402012O003900012O006F000400023O001204000500014O00BB0004000200022O0011000400043O001204000300043O0026190003003F00010004000402012O003F0001002EBC000C00240001000D000402012O00240001001204000200043O000402012O001B0001000402012O00240001000402012O001B0001000402012O00050001000402012O00460001000402012O000200012O0023012O00017O00033O00028O00025O000C9F40024O0080B3C540000C3O0012043O00013O002E8900023O00010002000402012O00010001000E450001000100013O000402012O00010001001204000100034O001100015O001204000100034O0011000100013O000402012O000B0001000402012O000100012O0023012O00017O00173O00028O00025O00108F40025O00BCB140026O00F03F025O0035B340025O00407440025O0020B340025O00208840025O003EB240025O00C8A840025O0024A44003053O007061697273025O00888640025O00108A40025O00809440025O00BCA440030D3O00446562752O6652656D61696E73030B3O0041676F6E79446562752O66030A3O00446562752O66446F776E025O00C05840025O001AA940025O003499400001793O001204000100014O009D000200033O00261B0001001100010001000402012O00110001001204000400013O002EBC0002000B00010003000402012O000B000100261B0004000B00010004000402012O000B0001001204000100043O000402012O0011000100261B0004000500010001000402012O00050001001204000200014O009D000300033O001204000400043O000402012O00050001002E89000500F1FF2O0005000402012O0002000100261B0001000200010004000402012O00020001001204000400013O00261B0004001600010001000402012O001600010026190002001C00010004000402012O001C0001002EAF0007002000010006000402012O002000010006350005001F00010003000402012O001F0001001204000500014O0097000500023O002EAF0008001500010009000402012O0015000100261B0002001500010001000402012O00150001001204000500013O002EBC000B002B0001000A000402012O002B0001000E450004002B00010005000402012O002B0001001204000200043O000402012O00150001000E450001002500010005000402012O002500012O009D000300033O0012840006000C4O009400076O00FB000600020008000402012O006F0001001204000B00014O009D000C000D3O002619000B003800010004000402012O00380001002E89000D002B0001000E000402012O00610001002EAF000F003800010010000402012O0038000100261B000C003800010001000402012O003800012O006F000E5O0020AA000F000A00114O001100013O00202O0011001100124O000F001100024O001000023O00202O0011000A00134O001300013O00202O0013001300124O001100136O00103O00020010DC0010001400102O00DD000E001000024O000F00033O00202O0010000A00114O001200013O00202O0012001200124O0010001200024O001100023O00202O0012000A00134O001400013O00202O0014001400122O0040001200144O00C800113O000200102O0011001400114O000F001100024O000D000E000F002E2O0016006F00010015000402012O006F00010026190003005D00010017000402012O005D000100068C000D006F00010003000402012O006F00012O00940003000D3O000402012O006F0001000402012O00380001000402012O006F000100261B000B003400010001000402012O00340001001204000E00013O00261B000E006900010001000402012O00690001001204000C00014O009D000D000D3O001204000E00043O00261B000E006400010004000402012O00640001001204000B00043O000402012O00340001000402012O00640001000402012O003400010006290006003200010002000402012O00320001001204000500043O000402012O00250001000402012O00150001000402012O00160001000402012O00150001000402012O00780001000402012O000200012O0023012O00017O00263O00028O00027O0040026O00F03F025O0094AD40025O0064B040025O007AB040025O00B49740025O00A4AF40025O0026B140025O00FC9D40025O00107240025O00D49240025O00788740025O0002A440025O00D49A40025O00EC9A40025O0020AC40025O008EA940025O00849940025O003EA840025O0072A64003053O00706169727303083O00446562752O66557003163O00532O65646F66436F2O72757074696F6E446562752O66025O0026AC40025O00A88640025O0036A640025O00C06540025O00A6A340025O003BB140025O00909F4003103O003237033E52071109284F14221233520F03053O003D6152665A03083O00496E466C6967687403083O00507265764743445003103O00532O65646F66436F2O72757074696F6E025O000C9540025O006DB14001CB3O001204000100014O009D000200053O00261B000100C000010002000402012O00C0000100261B0002001500010001000402012O00150001001204000600013O0026190006000B00010003000402012O000B0001002EAF0005000D00010004000402012O000D0001001204000200033O000402012O00150001002E89000600FAFF2O0006000402012O0007000100261B0006000700010001000402012O00070001001204000300014O009D000400043O001204000600033O000402012O00070001002EAF0007000400010008000402012O0004000100261B0002000400010003000402012O000400012O009D000500053O001204000600014O009D000700073O002E8900093O00010009000402012O001C000100261B0006001C00010001000402012O001C0001001204000700013O002EAF000B00AD0001000A000402012O00AD0001000E45000100AD00010007000402012O00AD0001001204000800013O0026190008002A00010003000402012O002A0001002EAF000C002C0001000D000402012O002C0001001204000700033O000402012O00AD00010026190008003000010001000402012O00300001002EBC000E00260001000F000402012O00260001002EBC0010007B00010011000402012O007B000100261B0003007B00010003000402012O007B0001001204000900014O009D000A000A3O002EBC0013003600010012000402012O0036000100261B0009003600010001000402012O00360001001204000A00013O00261B000A007200010001000402012O00720001001204000B00013O00261B000B004200010003000402012O00420001001204000A00033O000402012O00720001002EBC0015003E00010014000402012O003E000100261B000B003E00010001000402012O003E0001001204000500013O001284000C00164O0094000D6O00FB000C0002000E000402012O006E0001001204001100014O009D001200123O00261B0011004D00010001000402012O004D0001001204001200013O00261B0012005000010001000402012O005000012O006F00136O0090001400043O00122O001500036O0013001500024O001400016O001500043O00122O001600036O0014001600024O00040013001400202O0013001000174O001500023O00202O0015001500184O00130015000200062O0013006E00013O000402012O006E00012O006F00136O00F3001400053O00122O001500036O0013001500024O001400016O001500053O00122O001600036O0014001600024O00050013001400044O006E0001000402012O00500001000402012O006E0001000402012O004D0001000629000C004B00010002000402012O004B0001001204000B00033O000402012O003E0001002619000A007600010003000402012O00760001002E89001900C7FF2O001A000402012O003B0001001204000300023O000402012O007B0001000402012O003B0001000402012O007B0001000402012O0036000100261B000300AB00010001000402012O00AB0001001204000900013O002E89001B00260001001B000402012O00A4000100261B000900A400010001000402012O00A40001001204000A00013O00261B000A008700010003000402012O00870001001204000900033O000402012O00A40001002619000A008B00010001000402012O008B0001002EBC001D00830001001C000402012O00830001002EBC001F00A10001001E000402012O00A100012O006F000B00024O00E8000C00033O00122O000D00203O00122O000E00216O000C000E00024O000B000B000C00202O000B000B00224O000B0002000200062O000B009F00010001000402012O009F00012O006F000B00043O00202F000B000B002300122O000D00036O000E00023O00202O000E000E00244O000B000E000200062O000B00A100013O000402012O00A100012O00F1000B6O0097000B00023O001204000400013O001204000A00033O000402012O00830001002E89002500DAFF2O0025000402012O007E000100261B0009007E00010003000402012O007E0001001204000300033O000402012O00AB0001000402012O007E0001001204000800033O000402012O0026000100261B0007002100010003000402012O00210001002E890026006BFF2O0026000402012O001A000100261B0003001A00010002000402012O001A000100065C000400B600010005000402012O00B600012O006B00086O00F1000800014O0097000800023O000402012O001A0001000402012O00210001000402012O001A0001000402012O001C0001000402012O001A0001000402012O00CA0001000402012O00040001000402012O00CA000100261B000100C400010003000402012O00C400012O009D000400053O001204000100023O00261B0001000200010001000402012O00020001001204000200014O009D000300033O001204000100033O000402012O000200012O0023012O00017O00023O00030D3O00446562752O6652656D61696E73030B3O0041676F6E79446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303103O00436F2O72757074696F6E446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E7303103O00536970686F6E4C696665446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00073O00030D3O00446562752O6652656D61696E73030B3O0041676F6E79446562752O66030F3O0056696C655461696E74446562752O6603093O009A27A74EF3561707B803083O0069CC4ECB2BA7377E03083O004361737454696D65026O001440012D3O0020B600013O00014O00035O00202O0003000300024O0001000300024O000200013O00202O00033O00014O00055O00202O0005000500034O0003000500024O00048O000500023O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400064O000400056O00023O00024O000300033O00202O00043O00014O00065O00202O0006000600034O0004000600024O00058O000600023O00122O000700043O00122O000800056O0006000800024O00050005000600202O0005000500064O000500066O00033O00024O00020002000300062O0001002900010002000402012O002900010020082O013O00012O006F00035O00203F0003000300022O008600010003000200262O0001002A00010007000402012O002A00012O006B00016O00F1000100014O0097000100024O0023012O00017O00033O00030D3O00446562752O6652656D61696E73030B3O0041676F6E79446562752O66026O001440010A3O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000700010003000402012O000700012O006B00016O00F1000100014O0097000100024O0023012O00017O00033O00030D3O00446562752O6652656D61696E7303103O00436F2O72757074696F6E446562752O66026O001440010A3O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000700010003000402012O000700012O006B00016O00F1000100014O0097000100024O0023012O00017O00023O0003113O00446562752O665265667265736861626C6503103O00536970686F6E4C696665446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E73030B3O0041676F6E79446562752O66026O001440010A3O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000700010003000402012O000700012O006B00016O00F1000100014O0097000100024O0023012O00017O00023O0003113O00446562752O665265667265736861626C65030B3O0041676F6E79446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303103O00436F2O72757074696F6E446562752O66026O001440010A3O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000700010003000402012O000700012O006B00016O00F1000100014O0097000100024O0023012O00017O00023O0003113O00446562752O665265667265736861626C6503103O00436F2O72757074696F6E446562752O6601063O00202500013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00043O00030B3O00446562752O66537461636B03133O00536861646F77456D6272616365446562752O66026O000840030D3O00446562752O6652656D61696E7301103O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000D00010003000402012O000D00010020082O013O00042O006F00035O00203F0003000300022O008600010003000200262O0001000D00010003000402012O000D00012O006B00016O00F1000100014O0097000100024O0023012O00017O00033O00030D3O00446562752O6652656D61696E7303103O00536970686F6E4C696665446562752O66026O001440010A3O00202A2O013O00014O00035O00202O0003000300024O00010003000200262O0001000700010003000402012O000700012O006B00016O00F1000100014O0097000100024O0023012O00017O00283O00028O00026O00F03F025O00F4B040025O0070A64003133O0082B82A131C0DD554AAAC101F1016CE57ACA92603083O0031C5CA437E7364A7030A3O0049734361737461626C6503133O004772696D6F6972656F6653616372696669636503213O003049D6248F5F4C3264D02FBF455F3449D62F89555B774BCD2C835953355ACB69D203073O003E573BBF49E036025O00C08140025O003EA14003053O00CF03EFC7F303043O00A987629A03073O004973526561647903053O004861756E74030E3O0049735370652O6C496E52616E676503113O00C376315AE973D8D972275BF031C9DF377203073O00A8AB1744349D53025O009AAD40025O00F88A40025O00C06D40025O0085B340025O00BDB040025O00B6AD4003123O00C17FE6B9242F8BF150F3AB292484E078FAA303073O00E7941195CD454D03083O00B3A8D2F764E881B703063O009FE0C7A79B37030B3O004973417661696C61626C6503123O00556E737461626C65412O666C696374696F6E031F3O00E2FD2FC6F6F130D7C8F23AD4FBFA3FC6FEFC3292E7E139D1F8FE3ED3E3B36403043O00B297935C025O00E0A440025O002EB340030A3O00BFF54D361D5B5883F15803073O001AEC9D2C52722C030A3O00536861646F77426F6C7403183O003926D45F2539EA592522C11B3A3CD0582523D75A3E6E840B03043O003B4A4EB500A73O0012043O00014O009D000100023O00261B3O000700010001000402012O00070001001204000100014O009D000200023O0012043O00023O00261B3O000200010002000402012O0002000100261B0001000900010001000402012O00090001001204000200013O0026190002001000010001000402012O00100001002E890003004800010004000402012O00560001001204000300013O000E450001005100010003000402012O00510001001204000400013O00261B0004004A00010001000402012O004A00012O006F00056O00C7000600013O00122O000700053O00122O000800066O0006000800024O00050005000600202O0005000500074O00050002000200062O0005002B00013O000402012O002B00012O006F000500024O006F00065O00203F0006000600082O00BB0005000200020006930005002B00013O000402012O002B00012O006F000500013O001204000600093O0012040007000A4O0013000500074O006900055O002EBC000B00490001000C000402012O004900012O006F00056O00C7000600013O00122O0007000D3O00122O0008000E6O0006000800024O00050005000600202O00050005000F4O00050002000200062O0005004900013O000402012O004900012O006F000500024O003400065O00202O0006000600104O000700033O00202O0007000700114O00095O00202O0009000900104O0007000900024O000700076O000800016O00050008000200062O0005004900013O000402012O004900012O006F000500013O001204000600123O001204000700134O0013000500074O006900055O001204000400023O0026190004004E00010002000402012O004E0001002EBC0014001400010015000402012O00140001001204000300023O000402012O00510001000402012O0014000100261B0003001100010002000402012O00110001001204000200023O000402012O00560001000402012O00110001002EAF0016000C00010017000402012O000C000100261B0002000C00010002000402012O000C0001002EAF0019008200010018000402012O008200012O006F00036O00C7000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003008200013O000402012O008200012O006F00036O00E8000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003001E4O00030002000200062O0003008200010001000402012O008200012O006F000300024O003400045O00202O00040004001F4O000500033O00202O0005000500114O00075O00202O00070007001F4O0005000700024O000500056O000600016O00030006000200062O0003008200013O000402012O008200012O006F000300013O001204000400203O001204000500214O0013000300054O006900035O002EAF002200A600010023000402012O00A600012O006F00036O00C7000400013O00122O000500243O00122O000600256O0004000600024O00030003000400202O00030003000F4O00030002000200062O000300A600013O000402012O00A600012O006F000300024O003400045O00202O0004000400264O000500033O00202O0005000500114O00075O00202O0007000700264O0005000700024O000500056O000600016O00030006000200062O000300A600013O000402012O00A600012O006F000300013O001227000400273O00122O000500286O000300056O00035O00044O00A60001000402012O000C0001000402012O00A60001000402012O00090001000402012O00A60001000402012O000200012O0023012O00017O00333O00028O00026O00F03F025O0018A740025O0001B140025O009CAB40025O0062A04003083O00446562752O665570030F3O0056696C655461696E74446562752O6603183O005068616E746F6D53696E67756C6172697479446562752O6603093O00D7C13EFFDB31F54CF503083O002281A8529A8F509C030B3O004973417661696C61626C6503123O00B5BA32055C4184B6BB3D0C5D428897BB271203073O00E9E5D2536B282E030D3O00536F756C526F74446562752O6603073O00F24D27DA37CE5603053O0065A12252B6025O006EA940025O00B08040027O0040025O009EB040025O006CB14003123O00D80558F0CFED8F1DE1035EEBD7E39027FC1403083O004E886D399EBB82E203093O000836F5F40A3EF0FF2A03043O00915E5F9903073O00CEC201D97CB8E903063O00D79DAD74B52E030F3O0006A186FFD53B908AE0D132B88AE0DF03053O00BA55D4EB92025O0035B240025O0035B140026O000840025O00DFB140025O005C9E40025O00607440025O00C4914003123O0015D95B54A72ADC6953BD22C4565BA12CC54303053O00D345B12O3A03093O0081EC75F0DDCABEEB6D03063O00ABD785199589025O00109440030E3O00E59417EC3DE759CC9222FF3BE25D03073O0038A2E1769E598E03113O007804D2A425D45D17C58B37CA5D11C9A02C03063O00B83C65A0CF42030F3O00029771B13E8C58BD23897BB030907903043O00DC51E21C030F3O00432O6F6C646F776E52656D61696E73026O003440030F3O00506F776572496E667573696F6E557000F13O0012043O00014O009D000100023O00261B3O000700010001000402012O00070001001204000100014O009D000200023O0012043O00023O00261B3O000200010002000402012O000200010026190001000D00010001000402012O000D0001002EAF0004000900010003000402012O00090001001204000200013O002EAF0006005300010005000402012O0053000100261B0002005300010002000402012O00530001001204000300013O00261B0003004C00010001000402012O004C00012O006F000400013O0020060104000400074O000600023O00202O0006000600084O00040006000200062O0004003900010001000402012O003900012O006F000400013O0020060104000400074O000600023O00202O0006000600094O00040006000200062O0004003900010001000402012O003900012O006F000400024O00E8000500033O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004003700010001000402012O003700012O006F000400024O004B000500033O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000C4O0004000200024O000400043O000402012O003900012O006B00046O00F1000400014O001100046O006F000400013O0020060104000400074O000600023O00202O00060006000F4O00040006000200062O0004004A00010001000402012O004A00012O006F000400024O004B000500033O00122O000600103O00122O000700116O0005000700024O00040004000500202O00040004000C4O0004000200024O000400044O0011000400043O001204000300023O002EBC0013001300010012000402012O0013000100261B0003001300010002000402012O00130001001204000200143O000402012O00530001000402012O0013000100261B0002009100010014000402012O00910001001204000300013O002EAF0015008A00010016000402012O008A000100261B0003008A00010001000402012O008A00012O006F000400063O0006930004006100013O000402012O006100012O006F000400073O0006930004006100013O000402012O006100012O006F000400044O0011000400054O006F000400024O00E8000500033O00122O000600173O00122O000700186O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004008800010001000402012O008800012O006F000400024O00E8000500033O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004008800010001000402012O008800012O006F000400024O00E8000500033O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004008800010001000402012O008800012O006F000400024O0033000500033O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O00040004000C4O0004000200022O0011000400083O001204000300023O0026190003008E00010002000402012O008E0001002EBC001F005600010020000402012O00560001001204000200213O000402012O00910001000402012O00560001000E45000100C200010002000402012O00C20001001204000300013O002EBC0023009A00010022000402012O009A0001000E450002009A00010003000402012O009A0001001204000200023O000402012O00C200010026190003009E00010001000402012O009E0001002EAF0025009400010024000402012O009400012O006F000400013O0020060104000400074O000600023O00202O0006000600094O00040006000200062O000400AE00010001000402012O00AE00012O006F000400024O004B000500033O00122O000600263O00122O000700276O0005000700024O00040004000500202O00040004000C4O0004000200024O000400044O0011000400064O006F000400013O0020060104000400074O000600023O00202O0006000600084O00040006000200062O000400BF00010001000402012O00BF00012O006F000400024O004B000500033O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004000C4O0004000200024O000400044O0011000400073O001204000300023O000402012O00940001002E89002A004CFF2O002A000402012O000E000100261B0002000E00010021000402012O000E00012O006F000300083O000693000300E800013O000402012O00E800012O006F0003000A4O00A3000400033O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000400033O00122O0005002D3O00122O0006002E6O0004000600024O000300030004000E81000100E800010003000402012O00E800012O006F000300053O000693000300E300013O000402012O00E300012O006F000300024O0033000400033O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300314O000300020002000E81003200E800010003000402012O00E800012O006F0003000B3O0020080103000300332O00BB000300020002000402012O00E900012O006B00036O00F1000300014O0011000300093O000402012O00F00001000402012O000E0001000402012O00F00001000402012O00090001000402012O00F00001000402012O000200012O0023012O00017O000A3O00028O00026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440026O00A840025O00C4AA40025O0088AF40025O0017B14003103O0048616E646C65546F705472696E6B6574002F3O0012043O00013O000E450002001300013O000402012O001300012O006F00015O0020A50001000100044O000200016O000300023O00122O000400056O000500056O00010005000200122O000100033O00122O000100033O00062O0001001000010001000402012O00100001002EBC0007002E00010006000402012O002E0001001284000100034O0097000100023O000402012O002E000100261B3O000100010001000402012O00010001001204000100013O0026190001001A00010001000402012O001A0001002EAF0009002800010008000402012O002800012O006F00025O00206200020002000A4O000300016O000400023O00122O000500056O000600066O00020006000200122O000200033O00122O000200033O00062O0002002700013O000402012O00270001001284000200034O0097000200023O001204000100023O000E450002001600010001000402012O001600010012043O00023O000402012O00010001000402012O00160001000402012O000100012O0023012O00017O001C3O00028O00025O00B0AE40026O00F03F025O008AA440025O007AA740025O0078A440025O00607A4003163O0037D091EBEFD512C187D2E4D11CDE87E9F9E41CD187E303063O00A773B5E29B8A03123O004973457175692O706564416E64526561647903163O00446573706572617465496E766F6B657273436F64657803093O004973496E52616E6765025O0080464003203O00E627F44C7E63C7F627D8557567C9E927F54F4472C9E627FF1C7265C3EF31A70E03073O00A68242873C1B1103123O006745C07F25564FCA56384D46C2723C4B48CB03053O0050242AAE15025O00A09D40025O00049D4003123O00436F6E6A757265644368692O6C676C6F6265031B3O004D1F39705B02327E71133F73421C30764112323A470432775D506303043O001A2E7057025O00E89640025O00C07E40025O00208B40025O001AAE40025O005C9C40025O006DB24000663O0012043O00014O009D000100023O002E890002004F00010002000402012O0051000100261B3O005100010003000402012O0051000100261B0001001900010001000402012O00190001001204000300013O00261B0003001400010001000402012O001400012O006F00046O000E0004000100022O0094000200043O00061D0102001200010001000402012O00120001002EBC0005001300010004000402012O001300012O0097000200023O001204000300033O00261B0003000900010003000402012O00090001001204000100033O000402012O00190001000402012O000900010026190001001D00010003000402012O001D0001002EBC0006000600010007000402012O000600012O006F000300014O00C7000400023O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003700013O000402012O003700012O006F000300034O00E7000400043O00202O00040004000B4O000500053O00202O00050005000C00122O0007000D6O0005000700024O000500056O00030005000200062O0003003700013O000402012O003700012O006F000300023O0012040004000E3O0012040005000F4O0013000300054O006900036O006F000300014O00C7000400023O00122O000500103O00122O000600116O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006500013O000402012O00650001002EAF0013006500010012000402012O006500012O006F000300034O006F000400043O00203F0004000400142O00BB0003000200020006930003006500013O000402012O006500012O006F000300023O001227000400153O00122O000500166O000300056O00035O00044O00650001000402012O00060001000402012O00650001002EBC0018000200010017000402012O0002000100261B3O000200010001000402012O00020001001204000300013O002EAF0019005C0001001A000402012O005C000100261B0003005C00010003000402012O005C00010012043O00033O000402012O000200010026190003006000010001000402012O00600001002EAF001C00560001001B000402012O00560001001204000100014O009D000200023O001204000300033O000402012O00560001000402012O000200012O0023012O00017O00223O00028O00026O00F03F027O004003093O0034F42731741EF23A3003053O0016729D5554030A3O0049734361737461626C65025O00AEAC4003093O0046697265626C2O6F6403103O002OC201C15FFAA7CBCF53CB5AF5AC849303073O00C8A4AB73A43D96026O006B40025O00C07140025O0072A940025O003EA140025O004EA040025O00206140030F3O0048616E646C65445053506F74696F6E025O00A6AE40025O009BB240030A3O009B26B967BAAD4EBDB72403083O00D4D943CB142ODF25025O00409B40030A3O004265727365726B696E6703113O00B888BAC1BF9FA3DBB48AE8DDBD8EAC92EE03043O00B2DAEDC8026O006F40025O00F8914003093O0094B9E9DFB293F3C2AF03043O00B0D6D586025O0034AF40025O0060724003093O00426C2O6F644675727903113O00F6A1B9DBAC695FE1BFAF94A7515AF0EDE003073O003994CDD6B4C83600774O006F7O0006933O007600013O000402012O007600010012043O00014O009D000100023O000E450001000A00013O000402012O000A0001001204000100014O009D000200023O0012043O00023O00261B3O000500010002000402012O0005000100261B0001002600010003000402012O002600012O006F000300014O00C7000400023O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O00030002000200062O0003007600013O000402012O00760001002E890007005E00010007000402012O007600012O006F000300034O006F000400013O00203F0004000400082O00BB0003000200020006930003007600013O000402012O007600012O006F000300023O001227000400093O00122O0005000A6O000300056O00035O00044O00760001002EBC000B00400001000C000402012O00400001000E450001004000010001000402012O00400001001204000300013O002EAF000E00310001000D000402012O0031000100261B0003003100010002000402012O00310001001204000100023O000402012O004000010026190003003500010001000402012O00350001002EAF000F002B00010010000402012O002B00012O006F000400043O00203F0004000400112O000E0004000100022O0094000200043O00061D0102003D00010001000402012O003D0001002EBC0013003E00010012000402012O003E00012O0097000200023O001204000300023O000402012O002B000100261B0001000C00010002000402012O000C00012O006F000300014O00C7000400023O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300064O00030002000200062O0003005900013O000402012O00590001002E890016000D00010016000402012O005900012O006F000300034O006F000400013O00203F0004000400172O00BB0003000200020006930003005900013O000402012O005900012O006F000300023O001204000400183O001204000500194O0013000300054O006900035O002EBC001A00720001001B000402012O007200012O006F000300014O00C7000400023O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O0003000300064O00030002000200062O0003007200013O000402012O00720001002EBC001F00720001001E000402012O007200012O006F000300034O006F000400013O00203F0004000400202O00BB0003000200020006930003007200013O000402012O007200012O006F000300023O001204000400213O001204000500224O0013000300054O006900035O001204000100033O000402012O000C0001000402012O00760001000402012O000500012O0023012O00017O00ED3O00028O00025O00A49940025O00A88540025O00A7B140025O0076A140026O00F03F025O00E08B40025O00F49240025O00E2A940025O002FB240026O001440025O00E8AE40025O0022A540030A3O00ECEEBED0FCD1CBA7DEF603053O0093BF87CEB803073O004973526561647903103O00B721B6C9D75D9E8D2EA3E5DD51A7822E03073O00D2E448C6A1B833030F3O0041757261416374697665436F756E74025O009C9E40025O00BAA74003093O00436173744379636C65030A3O00536970686F6E4C696665030E3O0049735370652O6C496E52616E676503123O002540E3187CC00945FA16768E3746F650209A03063O00AE562993701303093O007F128C022B3C1EBE5703083O00CB3B60ED6B456F71025O00649340025O004AA14003093O00447261696E536F756C03113O002004ADE83FCFC42B03A0A130FFD26445FA03073O00B74476CC815190025O0029B340025O006EB340030A3O003DA571E004952CA27CF003063O00E26ECD10846B025O00CAAB40030A3O00536861646F77426F6C7403123O00F8CBE1DD4E2OFCE2D64DFF83E1D644AB90B803053O00218BA380B9025O00107740025O000AAC40025O0056A740025O001AB140025O004AA64003123O003FAE2C71F3E702952471E0FD03A73F76F3F103063O00886FC64D1F87030A3O0049734361737461626C65025O00C09A40025O0024AC40025O00BBB140025O005AA54003123O005068616E746F6D53696E67756C617269747903193O001201A658A9EB1A961100A951A8E816BB0B1DBE16BCEB12E95403083O00C96269C736DD847703123O008C0290350337A0BC2D85270E3CAFAD058C2F03073O00CCD96CE3416255030D3O00446562752O6652656D61696E7303183O00556E737461626C65412O666C696374696F6E446562752O66025O004EA440025O0018804003123O00556E737461626C65412O666C696374696F6E03193O004BCDE6F12DC252C6CAE42AC652CAF6F125CF5083F4EA29800603063O00A03EA395854C027O0040025O0054AD40025O0050894003053O0096F5164B9703053O00E3DE946325030B3O004861756E74446562752O66026O000840025O00849940025O00E49E4003053O004861756E74030B3O003B5347F8ED73535DF3B96103053O0099532O3296025O00B0B140025O0046AC4003093O006B2O7F1947AA44536203073O002D3D16137C13CB03123O00F21D18F90771ADC4001ED20E65ADD51D03EC03073O00D9A1726D956210030A3O0054616C656E7452616E6B026O00F83F03073O00212F2D708E7B0603063O00147240581CDC030F3O00432O6F6C646F776E52656D61696E7303093O000708DEB1CCD1B43F1503073O00DD5161B2D498B0030B3O004578656375746554696D6503123O00FEE808F71FCCF318E909EAEB08EF0EC2E90403053O007AAD877D9B03073O00B7CE15B50D3EDC03073O00A8E4A160D95F5103093O00EDD822591B56D2DF3A03063O0037BBB14E3C4F03123O001EC14AE743CE9428DC4CCC4ADA9439C151F203073O00E04DAE3F8B26AF030B3O004973417661696C61626C6503073O00B74E4D22B64E4C03043O004EE4213803093O00F877BE06B1CF77BC1703053O00E5AE1ED26303093O002DE48A54D93C3015F903073O00597B8DE6318D5D026O003940030F3O0056696C655461696E74437572736F7203093O004973496E52616E6765026O00444003103O00E578FA092F5EF278F818504BFC74B65803063O002A9311966C70025O00806540025O0058A040030A3O00E5A91D27CCD88C0429C603053O00A3B6C06D4F03103O00072F10C8FA3A0A09C6F0102302D5F33203053O0095544660A0026O001840030F3O000B1300E0370829EC2A0D0AE139140803043O008D58666D030A3O00432O6F6C646F776E5570025O0090A04003123O00A05ADA7815336ACDBA55CF301B325081E22O03083O00A1D333AA107A5D3503073O00C8A1A724C9A1A603043O00489BCED2025O00BCA240025O0060764003073O00536F756C526F74030F3O00557541020C5475404E32497F145F6103053O0053261A346E025O00A6A240025O001DB24003103O006B122242571104494A0532564C1E284803043O002638774703103O00436F2O72757074696F6E446562752O6603103O00C0EA5DD22A50D0E04AC43046E7E657D803063O0036938F38B64503083O00496E466C6967687403083O00446562752O66557003163O00532O65646F66436F2O72757074696F6E446562752O6603103O00532O65646F66436F2O72757074696F6E03193O00C584FA4DE0D987C04AD0C493EA59CBDF8EF109DED984BF188B03053O00BFB6E19F29025O00C49340025O00AEA54003053O000A15275B9203073O00A24B724835EBE7030B3O00AD3B4BEC4A26893E51E45503063O0062EC5C248233026O002040030C3O0043617374546172676574496603053O0041676F6E792O033O00A9100203083O0050C4796CDA25C8D5025O004EB140025O00804940030C3O0001740D71524E8B0F76422E1D03073O00EA6013621F2B6E026O00104003093O00CAE5A339E0DBAB36EB03043O00508E97C2030D3O00536F756C526F74446562752O6603073O0030C9624031C96303043O002C63A61703093O0042752O66537461636B03143O00496E6576697461626C6544656D69736542752O66026O00244003093O00447261696E4C69666503113O0078E5283F3D9B70FE2F3373A573F269646503063O00C41C9749565303093O00D71128198C6B1763FF03083O001693634970E2387803063O0042752O665570030D3O004E6967687466612O6C42752O66030D3O008B7DE3F182AF50EFF79FB976E703053O00EDD815829503113O00865C5E56BEF64D8D5B531FB1C65BC21C0703073O003EE22E2O3FD0A9025O003C9D40025O00389F4003093O00C10B548A113E204BE903083O003E857935E37F6D4F025O0046A040025O00E4AE40025O00049D40025O00804D4003113O00140633FCD891B11F013EB5D7A1A750476203073O00C270745295B6CE03103O000ABD4115CFEC3D36BD4013C5E71E3CBA03073O006E59C82C78A08203103O0098D6464B4C440842BECF4043465A3E5F03083O002DCBA32B26232A5B03053O00436F756E7403103O00E190D12E88A767DD90D02882AC44D79703073O0034B2E5BC43E7C903103O0053752O6D6F6E536F756C6B2O65706572025O00409340025O00CAA74003123O00324E4508C84F3733485B01B75D2C2401035603073O004341213064973C026O005A40030F3O00350A5FCAA37CAF070D59C0A073992O03073O00EB667F32A7CC12030F3O0053752O6D6F6E4461726B676C61726503173O0043B4F82E4B206FA5F4314F295CA0E726042F5FA4B5721C03063O004E30C1954324030E3O001D1F8C1D47391DB21951240B921D03053O0021507EE07803153O00556D627261666972654B696E646C696E6742752O66025O00B6B140025O002EA740030E3O004D616C6566696352617074757265026O00594003163O00E1A90FC15AE5AB3CD65DFCBC16D659ACA90CC11CBEF803053O003C8CC863A4025O00F2AA40025O0080A24003103O00B4F10122AD81D70B34B092E4102FAD8903053O00C2E7946446030B3O007543D697FECD7549C4A7E503063O00A8262CA1C39603193O0093F987720FE7B02983F3906425F8A21F8FF2C2773FEDF644D203083O0076E09CE2165088D6025O007DB240025O00B8AB40030E3O006FEF558544E75AB243FE4D9550EB03043O00E0228E39030F3O00EDB2C8D07CFF790FCCACC2D172E35803083O006EBEC7A5BD13913D026O002E40030B3O00E9E460DC83C2E9EE72EC9803063O00A7BA8B1788EB03163O00546F726D656E7465644372657363656E646F42752O6603163O0017B484081CBC8B3208B498190FA78D4D1BBA8D4D48E103043O006D7AD5E8002O042O0012043O00014O009D000100023O002EAF0003001500010002000402012O0015000100261B3O001500010001000402012O00150001001204000300013O0026190003000B00010001000402012O000B0001002EAF0004000E00010005000402012O000E0001001204000100014O009D000200023O001204000300063O002EAF0007000700010008000402012O00070001000E450006000700010003000402012O000700010012043O00063O000402012O00150001000402012O0007000100261B3O000200010006000402012O00020001002EBC0009002E0001000A000402012O002E000100261B0001002E00010001000402012O002E00012O006F00035O0006930003002300013O000402012O002300012O006F000300014O000E0003000100020006930003002300013O000402012O002300012O0097000300024O006F000300024O000E0003000100022O0094000200033O0006930002002900013O000402012O002900012O0097000200024O006F000300044O006F000400054O00BB0003000200022O0011000300033O001204000100063O002619000100320001000B000402012O00320001002EAF000C009B0001000D000402012O009B00012O006F000300064O00C7000400073O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003005C00013O000402012O005C00012O006F000300064O009C000400073O00122O000500113O00122O000600126O0004000600024O00030003000400202O0003000300134O00030002000200262O0003005C0001000B000402012O005C0001002EAF0014005C00010015000402012O005C00012O006F000300083O0020D60003000300164O000400063O00202O0004000400174O000500096O0006000A6O0007000B3O00202O0007000700184O000900063O00202O0009000900174O0007000900024O000700076O00030007000200062O0003005C00013O000402012O005C00012O006F000300073O001204000400193O0012040005001A4O0013000300054O006900036O006F000300064O00E8000400073O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003006800010001000402012O00680001002EAF001E007A0001001D000402012O007A00012O006F0003000C4O00F2000400063O00202O00040004001F4O000500066O0007000B3O00202O0007000700184O000900063O00202O00090009001F4O0007000900024O000700076O00030007000200062O0003007A00013O000402012O007A00012O006F000300073O001204000400203O001204000500214O0013000300054O006900035O002EAF0022000304010023000402012O000304012O006F000300064O00C7000400073O00122O000500243O00122O000600256O0004000600024O00030003000400202O0003000300104O00030002000200062O0003000304013O000402012O00030401002E890026007D03010026000402012O000304012O006F0003000C4O00F2000400063O00202O0004000400274O000500066O0007000B3O00202O0007000700184O000900063O00202O0009000900274O0007000900024O000700076O00030007000200062O0003000304013O000402012O000304012O006F000300073O001227000400283O00122O000500296O000300056O00035O00044O00030401002E89002A000F2O01002A000402012O00AA2O0100261B000100AA2O010006000402012O00AA2O01001204000300014O009D000400043O002619000300A500010001000402012O00A50001002EAF002B00A10001002C000402012O00A10001001204000400013O002EAF002E00F10001002D000402012O00F1000100261B000400F100010006000402012O00F100012O006F000500064O00E8000600073O00122O0007002F3O00122O000800306O0006000800024O00050005000600202O0005000500314O00050002000200062O000500B600010001000402012O00B60001002EAF003300CB00010032000402012O00CB0001002EBC003500CB00010034000402012O00CB00012O006F0005000C4O0078000600063O00202O0006000600364O0007000D6O000800086O0009000B3O00202O0009000900184O000B00063O00202O000B000B00364O0009000B00024O000900096O00050009000200062O000500CB00013O000402012O00CB00012O006F000500073O001204000600373O001204000700384O0013000500074O006900056O006F000500064O00C7000600073O00122O000700393O00122O0008003A6O0006000800024O00050005000600202O0005000500104O00050002000200062O000500DC00013O000402012O00DC00012O006F0005000B3O00202A01050005003B4O000700063O00202O00070007003C4O00050007000200262O000500DE0001000B000402012O00DE0001002EBC003D00F00001003E000402012O00F000012O006F0005000C4O00F2000600063O00202O00060006003F4O000700086O0009000B3O00202O0009000900184O000B00063O00202O000B000B003F4O0009000B00024O000900096O00050009000200062O000500F000013O000402012O00F000012O006F000500073O001204000600403O001204000700414O0013000500074O006900055O001204000400423O00261B000400A32O010001000402012O00A32O01001204000500013O002619000500F800010001000402012O00F80001002EAF0043009C2O010044000402012O009C2O012O006F000600064O00C7000700073O00122O000800453O00122O000900466O0007000900024O00060006000700202O0006000600104O00060002000200062O0006001D2O013O000402012O001D2O012O006F0006000B3O0020AC00060006003B4O000800063O00202O0008000800474O00060008000200262O0006001D2O010048000402012O001D2O01002EBC0049001D2O01004A000402012O001D2O012O006F0006000C4O00F2000700063O00202O00070007004B4O000800096O000A000B3O00202O000A000A00184O000C00063O00202O000C000C004B4O000A000C00024O000A000A6O0006000A000200062O0006001D2O013O000402012O001D2O012O006F000600073O0012040007004C3O0012040008004D4O0013000600084O006900065O002EBC004F009B2O01004E000402012O009B2O012O006F000600064O00C7000700073O00122O000800503O00122O000900516O0007000900024O00060006000700202O0006000600104O00060002000200062O0006009B2O013O000402012O009B2O012O006F000600064O003E000700073O00122O000800523O00122O000900536O0007000900024O00060006000700202O0006000600544O00060002000200262O000600482O010042000402012O00482O012O006F000600033O00262O0006008A2O010055000402012O008A2O012O006F000600064O003D000700073O00122O000800563O00122O000900576O0007000900024O00060006000700202O0006000600584O0006000200024O000700066O000800073O00122O000900593O00122O000A005A6O0008000A00024O00070007000800202O00070007005B4O00070002000200062O0006004300010007000402012O008A2O012O006F000600064O003E000700073O00122O0008005C3O00122O0009005D6O0007000900024O00060006000700202O0006000600544O00060002000200262O000600642O010006000402012O00642O012O006F000600064O003D000700073O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O0006000600584O0006000200024O000700066O000800073O00122O000900603O00122O000A00616O0008000A00024O00070007000800202O00070007005B4O00070002000200062O0006002700010007000402012O008A2O012O006F000600064O00E8000700073O00122O000800623O00122O000900636O0007000900024O00060006000700202O0006000600644O00060002000200062O0006009B2O010001000402012O009B2O012O006F000600064O003D000700073O00122O000800653O00122O000900666O0007000900024O00060006000700202O0006000600584O0006000200024O000700066O000800073O00122O000900673O00122O000A00686O0008000A00024O00070007000800202O00070007005B4O00070002000200062O0006000B00010007000402012O008A2O012O006F000600064O001E000700073O00122O000800693O00122O0009006A6O0007000900024O00060006000700202O0006000600584O000600020002000E2O006B009B2O010006000402012O009B2O012O006F0006000C4O00910007000E3O00202O00070007006C4O000800096O000A000B3O00202O000A000A006D00122O000C006E6O000A000C00024O000A000A6O0006000A000200062O0006009B2O013O000402012O009B2O012O006F000600073O0012040007006F3O001204000800704O0013000600084O006900065O001204000500063O002619000500A02O010006000402012O00A02O01002EBC007200F400010071000402012O00F40001001204000400063O000402012O00A32O01000402012O00F4000100261B000400A600010042000402012O00A60001001204000100423O000402012O00AA2O01000402012O00A60001000402012O00AA2O01000402012O00A1000100261B0001007702010042000402012O00770201001204000300013O00261B0003000802010001000402012O000802012O006F000400064O00C7000500073O00122O000600733O00122O000700746O0005000700024O00040004000500202O0004000400104O00040002000200062O000400E32O013O000402012O00E32O012O006F000400064O009C000500073O00122O000600753O00122O000700766O0005000700024O00040004000500202O0004000400134O00040002000200262O000400E32O010077000402012O00E32O012O006F000400064O00C7000500073O00122O000600783O00122O000700796O0005000700024O00040004000500202O00040004007A4O00040002000200062O000400E32O013O000402012O00E32O01002E89007B00160001007B000402012O00E32O012O006F000400083O0020D60004000400164O000500063O00202O0005000500174O000600096O0007000A6O0008000B3O00202O0008000800184O000A00063O00202O000A000A00174O0008000A00024O000800086O00040008000200062O000400E32O013O000402012O00E32O012O006F000400073O0012040005007C3O0012040006007D4O0013000400064O006900046O006F000400064O00C7000500073O00122O0006007E3O00122O0007007F6O0005000700024O00040004000500202O0004000400104O00040002000200062O000400F32O013O000402012O00F32O012O006F0004000F3O000693000400F32O013O000402012O00F32O012O006F000400103O00061D010400F52O010001000402012O00F52O01002E890080001400010081000402012O000702012O006F0004000C4O00F2000500063O00202O0005000500824O000600076O0008000B3O00202O0008000800184O000A00063O00202O000A000A00824O0008000A00024O000800086O00040008000200062O0004000702013O000402012O000702012O006F000400073O001204000500833O001204000600844O0013000400064O006900045O001204000300063O002EAF0085007202010086000402012O0072020100261B0003007202010006000402012O007202012O006F000400064O00C7000500073O00122O000600873O00122O000700886O0005000700024O00040004000500202O0004000400104O00040002000200062O0004004002013O000402012O004002012O006F0004000B3O0020AC00040004003B4O000600063O00202O0006000600894O00040006000200262O000400400201000B000402012O004002012O006F000400064O00E8000500073O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500202O00040004008C4O00040002000200062O0004004002010001000402012O004002012O006F0004000B3O00200601040004008D4O000600063O00202O00060006008E4O00040006000200062O0004004002010001000402012O004002012O006F0004000C4O00F2000500063O00202O00050005008F4O000600076O0008000B3O00202O0008000800184O000A00063O00202O000A000A008F4O0008000A00024O000800086O00040008000200062O0004004002013O000402012O004002012O006F000400073O001204000500903O001204000600914O0013000400064O006900045O002EAF0092007102010093000402012O007102012O006F000400064O00C7000500073O00122O000600943O00122O000700956O0005000700024O00040004000500202O0004000400104O00040002000200062O0004007102013O000402012O007102012O006F000400064O009C000500073O00122O000600963O00122O000700976O0005000700024O00040004000500202O0004000400134O00040002000200262O0004007102010098000402012O007102012O006F000400083O00206E0004000400994O000500063O00202O00050005009A4O000600096O000700073O00122O0008009B3O00122O0009009C6O0007000900024O000800116O000900126O000A000B3O00202O000A000A00184O000C00063O00202O000C000C009A4O000A000C00024O000A000A6O0004000A000200062O0004006C02010001000402012O006C0201002EAF009D00710201009E000402012O007102012O006F000400073O0012040005009F3O001204000600A04O0013000400064O006900045O001204000300423O00261B000300AD2O010042000402012O00AD2O01001204000100483O000402012O00770201000402012O00AD2O0100261B00010047030100A1000402012O00470301001204000300013O00261B0003007E02010042000402012O007E02010012040001000B3O000402012O00470301000E45000100E402010003000402012O00E402012O006F000400064O00C7000500073O00122O000600A23O00122O000700A36O0005000700024O00040004000500202O0004000400104O00040002000200062O000400B402013O000402012O00B402012O006F0004000B3O00200601040004008D4O000600063O00202O0006000600A44O00040006000200062O0004009B02010001000402012O009B02012O006F000400064O00E8000500073O00122O000600A53O00122O000700A66O0005000700024O00040004000500202O0004000400644O00040002000200062O000400B402010001000402012O00B402012O006F000400133O0020000104000400A74O000600063O00202O0006000600A84O000400060002000E2O00A900B402010004000402012O00B402012O006F0004000C4O00F2000500063O00202O0005000500AA4O000600076O0008000B3O00202O0008000800184O000A00063O00202O000A000A00AA4O0008000A00024O000800086O00040008000200062O000400B402013O000402012O00B402012O006F000400073O001204000500AB3O001204000600AC4O0013000400064O006900046O006F000400064O00C7000500073O00122O000600AD3O00122O000700AE6O0005000700024O00040004000500202O0004000400104O00040002000200062O000400E302013O000402012O00E302012O006F000400133O00200E0104000400AF4O000600063O00202O0006000600B04O00040006000200062O000400E302013O000402012O00E302012O006F000400064O00C7000500073O00122O000600B13O00122O000700B26O0005000700024O00040004000500202O0004000400644O00040002000200062O000400E302013O000402012O00E302012O006F000400083O0020D60004000400164O000500063O00202O00050005001F4O000600096O000700146O0008000B3O00202O0008000800184O000A00063O00202O000A000A001F4O0008000A00024O000800086O00040008000200062O000400E302013O000402012O00E302012O006F000400073O001204000500B33O001204000600B44O0013000400064O006900045O001204000300063O002EBC00B5007A020100B6000402012O007A0201000E450006007A02010003000402012O007A0201001204000400013O00261B000400ED02010006000402012O00ED0201001204000300423O000402012O007A020100261B000400E902010001000402012O00E902012O006F000500064O00C7000600073O00122O000700B73O00122O000800B86O0006000800024O00050005000600202O0005000500104O00050002000200062O00052O0003013O000402013O0003012O006F000500133O0020060105000500AF4O000700063O00202O0007000700B04O00050007000200062O0005000203010001000402012O00020301002EBC00BA0016030100B9000402012O00160301002EAF00BC0016030100BB000402012O001603012O006F0005000C4O00F2000600063O00202O00060006001F4O000700086O0009000B3O00202O0009000900184O000B00063O00202O000B000B001F4O0009000B00024O000900096O00050009000200062O0005001603013O000402012O001603012O006F000500073O001204000600BD3O001204000700BE4O0013000500074O006900056O006F000500064O00C7000600073O00122O000700BF3O00122O000800C06O0006000800024O00050005000600202O0005000500104O00050002000200062O0005004403013O000402012O004403012O006F000500064O0033000600073O00122O000700C13O00122O000800C26O0006000800024O00050005000600202O0005000500C34O00050002000200261900050037030100A9000402012O003703012O006F000500064O001E000600073O00122O000700C43O00122O000800C56O0006000800024O00050005000600202O0005000500C34O000500020002000E2O0048004403010005000402012O004403012O006F000500153O0026B800050044030100A9000402012O004403012O006F0005000C4O006F000600063O00203F0006000600C62O00BB00050002000200061D0105003F03010001000402012O003F0301002E8900C70007000100C8000402012O004403012O006F000500073O001204000600C93O001204000700CA4O0013000500074O006900055O001204000400063O000402012O00E90201000402012O007A020100261B0001001700010048000402012O00170001001204000300013O00261B0003004E03010042000402012O004E0301001204000100A13O000402012O00170001002E8900CB004B000100CB000402012O0099030100261B0003009903010001000402012O009903012O006F00045O0006930004007403013O000402012O007403012O006F000400064O00C7000500073O00122O000600CC3O00122O000700CD6O0005000700024O00040004000500202O0004000400314O00040002000200062O0004007403013O000402012O007403012O006F000400103O0006930004007403013O000402012O007403012O006F0004000F3O0006930004007403013O000402012O007403012O006F000400163O0006930004007403013O000402012O007403012O006F0004000C4O0088000500063O00202O0005000500CE4O000600176O00040006000200062O0004007403013O000402012O007403012O006F000400073O001204000500CF3O001204000600D04O0013000400064O006900046O006F000400064O00C7000500073O00122O000600D13O00122O000700D26O0005000700024O00040004000500202O0004000400104O00040002000200062O0004009803013O000402012O009803012O006F000400133O00200E0104000400AF4O000600063O00202O0006000600D34O00040006000200062O0004009803013O000402012O00980301002EAF00D50098030100D4000402012O009803012O006F0004000C4O0091000500063O00202O0005000500D64O000600076O0008000B3O00202O00080008006D00122O000A00D76O0008000A00024O000800086O00040008000200062O0004009803013O000402012O009803012O006F000400073O001204000500D83O001204000600D94O0013000400064O006900045O001204000300063O0026190003009D03010006000402012O009D0301002EBC00DA004A030100DB000402012O004A03012O006F000400064O00C7000500073O00122O000600DC3O00122O000700DD6O0005000700024O00040004000500202O0004000400104O00040002000200062O000400C303013O000402012O00C303012O006F000400064O00C7000500073O00122O000600DE3O00122O000700DF6O0005000700024O00040004000500202O0004000400644O00040002000200062O000400C303013O000402012O00C303012O006F0004000C4O00F2000500063O00202O00050005008F4O000600076O0008000B3O00202O0008000800184O000A00063O00202O000A000A008F4O0008000A00024O000800086O00040008000200062O000400C303013O000402012O00C303012O006F000400073O001204000500E03O001204000600E14O0013000400064O006900045O002EBC00E300FE030100E2000402012O00FE03012O006F000400064O00C7000500073O00122O000600E43O00122O000700E56O0005000700024O00040004000500202O0004000400104O00040002000200062O000400FE03013O000402012O00FE03012O006F000400064O0033000500073O00122O000600E63O00122O000700E76O0005000700024O00040004000500202O0004000400584O000400020002000E8100E800DC03010004000402012O00DC03012O006F000400183O000EFE004800E603010004000402012O00E603012O006F000400064O00C7000500073O00122O000600E93O00122O000700EA6O0005000700024O00040004000500202O0004000400644O00040002000200062O000400ED03013O000402012O00ED03012O006F000400133O00200E0104000400AF4O000600063O00202O0006000600EB4O00040006000200062O000400FE03013O000402012O00FE03012O006F0004000C4O0091000500063O00202O0005000500D64O000600076O0008000B3O00202O00080008006D00122O000A00D76O0008000A00024O000800086O00040008000200062O000400FE03013O000402012O00FE03012O006F000400073O001204000500EC3O001204000600ED4O0013000400064O006900045O001204000300423O000402012O004A0301000402012O00170001000402012O00030401000402012O000200012O0023012O00017O005C012O00028O00026O00F03F025O00549F40025O004FB240027O0040025O009C9B40025O00A08C40030A3O0006846B57DDA198D1338803083O00B855ED1B3FB2CFD403073O0049735265616479025O000AAC40025O00C4AC40030C3O00436173745461726765744966030A3O00536970686F6E4C6966652O033O0005500703043O003F683969030E3O0049735370652O6C496E52616E676503153O00188EB44C04899B480281A104088BA1451D82E4165B03043O00246BE7C403053O0075B4B7894903043O00E73DD5C2030D3O00446562752O6652656D61696E73030B3O004861756E74446562752O66026O000840025O00C05240025O00E07A4003053O004861756E74025O003DB040025O0026A940030F3O0001AC287D1DED3E7F0CAC2B7649FF6F03043O001369CD5D025O007C9C40025O00BCA54003123O009900DF8F2BA605ED8831AE1DD2802DA01CC703053O005FC968BEE103073O009CC4D4C29DC4D503043O00AECFABA1030F3O00432O6F6C646F776E52656D61696E7303123O00DDF60CFDECD8E0CD04FDFFC2E1FF1FFAECCE03063O00B78D9E6D9398030B3O004578656375746554696D6503123O001F06F3002908F2093E1AC100391DF203221003043O006C4C6986030B3O004973417661696C61626C6503073O00D8CAA4EDFCE4D103053O00AE8BA5D18103073O0090BCF7CDF40C6403083O0018C3D382A1A6631003123O00760BE82247194B30E02254034A02FB25470F03063O00762663894C3303073O00CE29101E3B2FE903063O00409D46657269026O003940025O00D4AA40025O00909B4003123O005068616E746F6D53696E67756C6172697479031D3O0050A0A6ED044FA598F0194EAFB2EF1152A1B3FA5043A4A2E20645E8F5B703053O007020C8C783025O0090AF40025O00709C40025O0060B040025O00C2A34003103O0046B45E4ED973925458C460A14F43D97B03053O00B615D13B2A03123O009655D6122DABA352E61233ACA247D1142EB003063O00DED737A57D4103103O00436F2O72757074696F6E446562752O66026O001440030B3O001FDED12EFAC4DE4F292OD503083O002A4CB1A67A92A18D025O00489840025O002AA24003103O00532O65646F66436F2O72757074696F6E031C3O00B68F00CA4679A3B506C16B64B09A11C77678E58909CB7860A0CA549803063O0016C5EA65AE19025O00509140025O00ADB140030A3O000E3BB7CE63BFC38F223A03083O00E64D54C5BC16CFB7030A3O00436F2O72757074696F6E2O033O00F41DC803083O00559974A69CECC19003143O00A7EF5FA1F110B0E942BDA403A8E54CA5E140F5B803063O0060C4802DD384025O000FB140025O0008AA40025O00A0A640025O0021B240025O00908B40026O003540030F3O00644D09D3585620DF455303D2564A0103043O00BE373864030A3O0049734361737461626C65025O008AA240025O00B5B240030F3O0053752O6D6F6E4461726B676C61726503193O0045BA31131CEDCC52AE2E1514EFF244AA7C1D1FE6F240AA7C4C03073O009336CF5C7E7383030E3O00203039780B770E03346D196B1F3403063O001E6D51551D6D030A3O00DB6351B732EAF3EA725C03073O009C9F1134D656BE03103O004472656164546F756368446562752O6603083O00446562752O665570030B3O0041676F6E79446562752O66030A3O009DE6ADB4A1E191B5A8EA03043O00DCCE8FDD03103O00536970686F6E4C696665446562752O6603123O00B6752C19CCC3DFB5742310CDC0D39474390E03073O00B2E61D4D77B8AC03123O00C5B60B1563F7F88D031570EDF9BF181263E103063O009895DE6A7B17030C3O00432O6F6C646F776E446F776E03093O00EB2FFA4681DC2FF85703053O00D5BD46962303093O00795C780D7B547D065B03043O00682F351403073O00904394108E00B703063O006FC32CE17CDC03073O00EB49157F99A4CC03063O00CBB8266013CB026O00104003063O0042752O66557003153O00556D627261666972654B696E646C696E6742752O66030E3O004D616C656669635261707475726503093O004973496E52616E6765026O005940025O00BC9C40025O00C0914003183O0034727544C830704653CF29676C53CB79707544CF2F76391503053O00AE59131921025O00CCAA40025O00608740025O00E0A14003093O0087B4CEC3330B84ADA603083O00CBC3C6AFAA5D47ED030D3O00536F756C526F74446562752O6603093O0042752O66537461636B03143O00496E6576697461626C6544656D69736542752O66026O002440025O00D88B40025O0079B14003093O00447261696E4C69666503143O002A593FDC5F2EF0274D3B95521DF92F5D3B95054703073O009C4E2B5EB5317103053O0053EFCBAD1203073O00191288A4C36B2303093O00436173744379636C6503053O0041676F6E79030F3O00E92AA6416BFCC2B4ED2CBF4A32E89903083O00D8884DC92F12DCA1025O00FEA740025O00AEA44003093O00DD2D19EDF70C17F1F503043O0084995F7803093O00447261696E536F756C025O00C88340025O00A0994003143O00B5A00F24F9E5B3BEA7026DF4D6A5B0A40B6DA28E03073O00C0D1D26E4D97BA026O001840030A3O000EE339C81DCC9624E32503073O00E24D8C4BBA68BC025O0068AD40025O00C8A24003143O00BAC1C22D5AA9DAD93041F9CDDC3A4EAFCB906A1F03053O002FD9AEB05F030E3O0095DC7A07B45D7B14B9CD6217A05103083O0046D8BD1662D23418025O00C6AD40025O003EB040025O00388740025O0080474003193O00D7DEAF82D5D3DC9C95D2CACBB695D69ADCAF82D2CCDAE3D28103053O00B3BABFC3E7025O001EAC40025O008C9040030A3O00D30B23EDF0D3C20C2EFD03063O00A4806342899F025O006C9540025O0096A340030A3O00536861646F77426F6C7403153O001381E8BA0F9ED6BC0F85FDFE0385ECBF168CA9EB5603043O00DE60E989025O002EAC40025O00D0A340025O00989140025O00B6AC4003073O001F5F49B4F1A43603073O00424C303CD8A3CB025O0020AA40025O003EAC4003073O00536F756C526F74025O00A8B240025O00406A4003123O00A9896CFF60DC2BAEC67AFF5ACF32BFC62BA503073O0044DAE619933FAE030E3O00802B5F49B0A429614DA6B93F414903053O00D6CD4A332C03123O00CE43F0F172F458E7F854E849F1FF72F448ED03053O00179A2C829C03163O00546F726D656E7465644372657363656E646F42752O66025O006AA440025O0080A540025O00BEB140025O008EA04003193O001CA7A1AB301A1299BFAF260704B4A8EE351F14A7BBAB76414903063O007371C6CDCE56025O003C9040025O00207540030E3O0073C0A723C957C29927DF4AD4B92303053O00AF3EA1CB46025O0023B040025O0002B24003193O0031DCCF163335DEFC01342CC9D601307CDECF16342AD883406103053O00555CBDA373030E3O00A956F25F825EFD688547EA4F965203043O003AE4379E030A3O00909BD52F38993AA18AD803073O0055D4E9B04E5CCD2O033O00474344025O0021B040026O00854003193O00475984E74C518BDD585998F65F4A8DA249548DE35C5DC8B11A03043O00822A38E8030E3O00C7B428E64636E98725F3542AF8B003063O005F8AD5448320030A3O000E3AA442721E27B4407E03053O00164A48C123025O00D88F40025O0014AB4003193O002178E85D2A70E7673E78F44C396BE1182F75E1593A7CA40B7E03043O00384C1984025O00207240025O00B88A40025O00F9B140025O005EB14003093O00368EAE553486AB5E1403043O003060E7C2030B3O00E95D012300FCAA81DD5C0803083O00E3A83A6E4D79B8CF030F3O0041757261416374697665436F756E7403103O005833AD52A4CB65AC74329B45B3CE77A303083O00C51B5CDF20D1BB11030A3O003056D3F30C51EFF2055A03043O009B633FA303103O00B1D8B185B68AAED8A7889D8180C4A78B03063O00E4E2B1C1EDD903073O0007BF36EA06BF3703043O008654D04303073O0020A3935021A39203043O003C73CCE603093O00D133E775D33BE27EF303043O0010875A8B03123O00677B133F4B556C5166151442416C407B082A03073O0018341466532E3403073O00F72034283DCB3B03053O006FA44F4144026O002840030F3O0056696C655461696E74437572736F7203093O0056696C655461696E74025O00188F40025O0066A04003143O002OD08FDB11FEC7D08DCA6EE9CADC82C82BAA978903063O008AA6B9E3BE4E03123O00FB7CC439462C14F87DCB30472F18D97DD12E03073O0079AB14A5573243030B3O00E73FB638A026C33AAC30BF03063O0062A658D956D903103O00D5F96B1393CCE2FF760FA2D9F4E37F0703063O00BC2O961961E6030A3O00E9804F0A03E3F680590703063O008DBAE93F626C03103O00C2E33CBE2AFFC625B020D5EF2EA323F703053O0045918A4CD603073O0043C09C858D196403063O007610AF2OE9DF03073O00B88B20B7DC846903073O001DEBE455DB8EEB03123O000DDCBBD363412A6134DABDC87B4F355B29CD03083O00325DB4DABD172E4703073O00EDAB4E4076D35C03073O0028BEC43B2C24BC025O00088E40025O004CAF40031D3O002C4DDDBAEE72000356D5BAFD68013D57D5A0E33D0E3040DDA2FF3D5C6E03073O006D5C25BCD49A1D025O000CA540025O00F6B24003123O0031E1B7D7305808EA85C537560DECB0CA3E5403063O003A648FC4A35103183O00556E737461626C65412O666C696374696F6E446562752O6603123O00556E737461626C65412O666C696374696F6E031D3O000F4C30B73E4BE90B254325A53340E61A134D2DE33C45E00F0C4763F26B03083O006E7A2243C35F298503053O000E155D40EE03073O006B4F72322E97E7025O004EB040025O002AAD402O033O0034AFBB03083O00A059C6D549EA59D7025O0084A440025O00408440030E3O004976BBF0DC0872B8FBC45E74F4A803053O00A52811D49E03073O002OD61D3F14EACD03053O004685B96853025O00EC9840025O003CA04003113O00174A5126F6164A506ACA0840453CCC441D03053O00A96425244A025O008C9940025O00688440025O0034AD4003093O00F26728AAE9A0A510D303083O0076B61549C387ECCC026O004840026O00344003143O000C2E1B490A32F1013A1F000701F8092A1F00505903073O009D685C7A20646D030A3O008EEF25A2C84B9FE828B203063O003CDD8744C6A7030D3O004E6967687466612O6C42752O6603153O00FDB5F9874DCED1BFF78F5699EDB1FD8254DCAEE9A803063O00B98EDD98E322030E3O0075C45BFF453AF46AC447EE5621F203073O009738A5379A2353025O00F6AE40025O0086B24003193O00AD4209EBA64A06D1B24215FAB55100AEA34F00EFB64645BAF203043O008EC02365025O00D0AF40025O0057B24003093O000DBE2O31279F3F2D2503043O005849CC50030D3O001D8B114226CD0B8E125428D92B03063O00BA4EE3702649025O0058A140025O0092A64003163O004576616C756174656379636C65447261696E536F756C03143O00F845FC5C5D45EF58E8591379F052FC43563AAF0103063O001A9C379D353303093O00A8CA17D0B66383CD1A03063O0030ECB876B9D803143O00E1AF5639C10BF6B2423C8F37E9B85626CA74B6E503063O005485DD3750AF025O0032B340025O002FB140006B062O0012043O00014O009D000100023O0026193O000600010002000402012O00060001002EAF0004005F06010003000402012O005F06010026190001000A00010005000402012O000A0001002EBC000600332O010007000402012O00332O01001204000300013O00261B0003006200010002000402012O00620001001204000400013O00261B0004005D00010001000402012O005D00012O006F00056O00C7000600013O00122O000700083O00122O000800096O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005003500013O000402012O00350001002EAF000B00350001000C000402012O003500012O006F000500023O0020D200050005000D4O00065O00202O00060006000E4O000700036O000800013O00122O0009000F3O00122O000A00106O0008000A00024O000900046O000A00056O000B00063O00202O000B000B00114O000D5O00202O000D000D000E4O000B000D00024O000B000B6O0005000B000200062O0005003500013O000402012O003500012O006F000500013O001204000600123O001204000700134O0013000500074O006900056O006F00056O00C7000600013O00122O000700143O00122O000800156O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004600013O000402012O004600012O006F000500063O00202A0105000500164O00075O00202O0007000700174O00050007000200262O0005004800010018000402012O00480001002EBC001A005C00010019000402012O005C00012O006F000500074O006000065O00202O00060006001B4O000700086O000900063O00202O0009000900114O000B5O00202O000B000B001B4O0009000B00024O000900096O00050009000200062O0005005700010001000402012O00570001002EBC001C005C0001001D000402012O005C00012O006F000500013O0012040006001E3O0012040007001F4O0013000500074O006900055O001204000400023O00261B0004000E00010002000402012O000E0001001204000300053O000402012O00620001000402012O000E0001002EAF002000C900010021000402012O00C9000100261B000300C900010005000402012O00C900012O006F00046O00C7000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400C700013O000402012O00C700012O006F00046O003D000500013O00122O000600243O00122O000700256O0005000700024O00040004000500202O0004000400264O0004000200024O00058O000600013O00122O000700273O00122O000800286O0006000800024O00050005000600202O0005000500294O00050002000200062O0004003100010005000402012O00B200012O006F00046O00E8000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400C700010001000402012O00C700012O006F00046O00C7000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400B200013O000402012O00B200012O006F00046O003D000500013O00122O0006002F3O00122O000700306O0005000700024O00040004000500202O0004000400264O0004000200024O00058O000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500294O00050002000200062O0004000B00010005000402012O00B200012O006F00046O0015000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O0004000400264O000400020002000E2O003500C700010004000402012O00C70001002EBC003700C700010036000402012O00C700012O006F000400074O007800055O00202O0005000500384O000600086O000700076O000800063O00202O0008000800114O000A5O00202O000A000A00384O0008000A00024O000800086O00040008000200062O000400C700013O000402012O00C700012O006F000400013O001204000500393O0012040006003A4O0013000400064O006900045O001204000100183O000402012O00332O01002EAF003C000B0001003B000402012O000B000100261B0003000B00010001000402012O000B0001002EBC003E000C2O01003D000402012O000C2O012O006F00046O00C7000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004000C2O013O000402012O000C2O012O006F00046O00E8000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O00040004002C4O00040002000200062O0004000C2O010001000402012O000C2O012O006F000400063O0020AC0004000400164O00065O00202O0006000600434O00040006000200262O0004000C2O010044000402012O000C2O012O006F00046O00C7000500013O00122O000600453O00122O000700466O0005000700024O00040004000500202O00040004002C4O00040002000200062O0004000C2O013O000402012O000C2O012O006F000400094O000E0004000100020006930004000C2O013O000402012O000C2O01002EAF0047000C2O010048000402012O000C2O012O006F000400074O00F200055O00202O0005000500494O000600076O000800063O00202O0008000800114O000A5O00202O000A000A00494O0008000A00024O000800086O00040008000200062O0004000C2O013O000402012O000C2O012O006F000400013O0012040005004A3O0012040006004B4O0013000400064O006900045O002EAF004C00312O01004D000402012O00312O012O006F00046O00C7000500013O00122O0006004E3O00122O0007004F6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400312O013O000402012O00312O012O006F000400023O0020D200040004000D4O00055O00202O0005000500504O000600036O000700013O00122O000800513O00122O000900526O0007000900024O0008000A6O0009000B6O000A00063O00202O000A000A00114O000C5O00202O000C000C00504O000A000C00024O000A000A6O0004000A000200062O000400312O013O000402012O00312O012O006F000400013O001204000500533O001204000600544O0013000400064O006900045O001204000300023O000402012O000B0001002619000100372O010001000402012O00372O01002EBC0055000802010056000402012O000802012O006F0003000C3O00061D0103003C2O010001000402012O003C2O01002EAF0058004A2O010057000402012O004A2O01001204000300014O009D000400043O00261B0003003E2O010001000402012O003E2O012O006F0005000D4O000E0005000100022O0094000400053O002EAF005A004A2O010059000402012O004A2O010006930004004A2O013O000402012O004A2O012O0097000400023O000402012O004A2O01000402012O003E2O012O006F0003000E4O000E0003000100022O0094000200033O000693000200502O013O000402012O00502O012O0097000200024O006F0003000C3O000693000300742O013O000402012O00742O012O006F00036O00C7000400013O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O00030003005D4O00030002000200062O000300742O013O000402012O00742O012O006F0003000F3O000693000300742O013O000402012O00742O012O006F000300103O000693000300742O013O000402012O00742O012O006F000300113O000693000300742O013O000402012O00742O01002EBC005E00742O01005F000402012O00742O012O006F000300074O008800045O00202O0004000400604O000500126O00030005000200062O000300742O013O000402012O00742O012O006F000300013O001204000400613O001204000500624O0013000300054O006900036O006F00036O00C7000400013O00122O000500633O00122O000600646O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003000702013O000402012O000702012O006F00036O00C7000400013O00122O000500653O00122O000600666O0004000600024O00030003000400202O00030003002C4O00030002000200062O000300EA2O013O000402012O00EA2O012O006F000300063O0020AC0003000300164O00055O00202O0005000500674O00030005000200262O000300EA2O010005000402012O00EA2O012O006F000300063O00200E0103000300684O00055O00202O0005000500694O00030005000200062O000300EA2O013O000402012O00EA2O012O006F000300063O00200E0103000300684O00055O00202O0005000500434O00030005000200062O000300EA2O013O000402012O00EA2O012O006F00036O00C7000400013O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O00030003002C4O00030002000200062O000300AE2O013O000402012O00AE2O012O006F000300063O00200E0103000300684O00055O00202O00050005006C4O00030005000200062O000300EA2O013O000402012O00EA2O012O006F00036O00C7000400013O00122O0005006D3O00122O0006006E6O0004000600024O00030003000400202O00030003002C4O00030002000200062O000300C22O013O000402012O00C22O012O006F00036O00C7000400013O00122O0005006F3O00122O000600706O0004000600024O00030003000400202O0003000300714O00030002000200062O000300EA2O013O000402012O00EA2O012O006F00036O00C7000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O00030003002C4O00030002000200062O000300D62O013O000402012O00D62O012O006F00036O00C7000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300714O00030002000200062O000300EA2O013O000402012O00EA2O012O006F00036O00C7000400013O00122O000500763O00122O000600776O0004000600024O00030003000400202O00030003002C4O00030002000200062O000300F42O013O000402012O00F42O012O006F00036O00E8000400013O00122O000500783O00122O000600796O0004000600024O00030003000400202O0003000300714O00030002000200062O000300F42O010001000402012O00F42O012O006F000300133O000E81007A00F42O010003000402012O00F42O012O006F000300143O00200E01030003007B4O00055O00202O00050005007C4O00030005000200062O0003000702013O000402012O000702012O006F000300074O00D000045O00202O00040004007D4O000500066O000700063O00202O00070007007E00122O0009007F6O0007000900024O000700076O00030007000200062O0003002O02010001000402012O002O0201002EAF0080000702010081000402012O000702012O006F000300013O001204000400823O001204000500834O0013000300054O006900035O001204000100023O00261B000100D402010044000402012O00D40201001204000300014O009D000400043O00261B0003000C02010001000402012O000C0201001204000400013O002E890084005100010084000402012O0060020100261B0004006002010001000402012O00600201002EBC0085004102010086000402012O004102012O006F00056O00C7000600013O00122O000700873O00122O000800886O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004102013O000402012O004102012O006F000500063O00200E0105000500684O00075O00202O0007000700894O00050007000200062O0005004102013O000402012O004102012O006F000500143O00200001050005008A4O00075O00202O00070007008B4O000500070002000E2O008C004102010005000402012O00410201002EAF008D00410201008E000402012O004102012O006F000500074O00F200065O00202O00060006008F4O000700086O000900063O00202O0009000900114O000B5O00202O000B000B008F4O0009000B00024O000900096O00050009000200062O0005004102013O000402012O004102012O006F000500013O001204000600903O001204000700914O0013000500074O006900056O006F00056O00C7000600013O00122O000700923O00122O000800936O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005F02013O000402012O005F02012O006F000500023O0020D60005000500944O00065O00202O0006000600954O000700036O000800156O000900063O00202O0009000900114O000B5O00202O000B000B00954O0009000B00024O000900096O00050009000200062O0005005F02013O000402012O005F02012O006F000500013O001204000600963O001204000700974O0013000500074O006900055O001204000400023O000E500005006402010004000402012O00640201002EBC0098008402010099000402012O008402012O006F00056O00C7000600013O00122O0007009A3O00122O0008009B6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005008202013O000402012O008202012O006F000500074O006000065O00202O00060006009C4O000700086O000900063O00202O0009000900114O000B5O00202O000B000B009C4O0009000B00024O000900096O00050009000200062O0005007D02010001000402012O007D0201002EAF009E00820201009D000402012O008202012O006F000500013O0012040006009F3O001204000700A04O0013000500074O006900055O001204000100A13O000402012O00D4020100261B0004000F02010002000402012O000F0201001204000500013O00261B000500CC02010001000402012O00CC02012O006F00066O00C7000700013O00122O000800A23O00122O000900A36O0007000900024O00060006000700202O00060006005D4O00060002000200062O000600A902013O000402012O00A90201002EAF00A500A9020100A4000402012O00A902012O006F000600023O0020D60006000600944O00075O00202O0007000700504O000800036O000900166O000A00063O00202O000A000A00114O000C5O00202O000C000C00504O000A000C00024O000A000A6O0006000A000200062O000600A902013O000402012O00A902012O006F000600013O001204000700A63O001204000800A74O0013000600084O006900066O006F00066O00C7000700013O00122O000800A83O00122O000900A96O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600B602013O000402012O00B602012O006F000600133O000E81000200B802010006000402012O00B80201002EBC00AB00CB020100AA000402012O00CB0201002EAF00AD00CB020100AC000402012O00CB02012O006F000600074O009100075O00202O00070007007D4O000800096O000A00063O00202O000A000A007E00122O000C007F6O000A000C00024O000A000A6O0006000A000200062O000600CB02013O000402012O00CB02012O006F000600013O001204000700AE3O001204000800AF4O0013000600084O006900065O001204000500023O00261B0005008702010002000402012O00870201001204000400053O000402012O000F0201000402012O00870201000402012O000F0201000402012O00D40201000402012O000C0201002EBC00B100F7020100B0000402012O00F7020100261B000100F7020100A1000402012O00F702012O006F00036O00C7000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006A06013O000402012O006A0601002EBC00B4006A060100B5000402012O006A06012O006F000300074O00F200045O00202O0004000400B64O000500066O000700063O00202O0007000700114O00095O00202O0009000900B64O0007000900024O000700076O00030007000200062O0003006A06013O000402012O006A06012O006F000300013O001227000400B73O00122O000500B86O000300056O00035O00044O006A0601002619000100FB02010018000402012O00FB0201002E8900B900F2000100BA000402012O00EB0301001204000300013O00261B0003005F03010001000402012O005F0301001204000400013O00261B0004002O03010002000402012O002O0301001204000300023O000402012O005F0301002EAF00BB00FF020100BC000402012O00FF020100261B000400FF02010001000402012O00FF02012O006F00056O00E8000600013O00122O000700BD3O00122O000800BE6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005001303010001000402012O00130301002EBC00C00027030100BF000402012O002703012O006F000500074O006000065O00202O0006000600C14O000700086O000900063O00202O0009000900114O000B5O00202O000B000B00C14O0009000B00024O000900096O00050009000200062O0005002203010001000402012O00220301002EBC00C20027030100C3000402012O002703012O006F000500013O001204000600C43O001204000700C54O0013000500074O006900056O006F00056O00C7000600013O00122O000700C63O00122O000800C76O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005004803013O000402012O004803012O006F000500133O000E81007A004A03010005000402012O004A03012O006F00056O00C7000600013O00122O000700C83O00122O000800C96O0006000800024O00050005000600202O00050005002C4O00050002000200062O0005004803013O000402012O004803012O006F000500143O0020CF00050005008A4O00075O00202O0007000700CA4O00050007000200262O0005004803010002000402012O004803012O006F000500133O000E810018004A03010005000402012O004A0301002EAF00CC005D030100CB000402012O005D0301002EAF00CE005D030100CD000402012O005D03012O006F000500074O009100065O00202O00060006007D4O000700086O000900063O00202O00090009007E00122O000B007F6O0009000B00024O000900096O00050009000200062O0005005D03013O000402012O005D03012O006F000500013O001204000600CF3O001204000700D04O0013000500074O006900055O001204000400023O000402012O00FF02010026190003006303010005000402012O00630301002E8900D10027000100D2000402012O008803012O006F00046O00C7000500013O00122O000600D33O00122O000700D46O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004007303013O000402012O007303012O006F000400173O00061D0104007503010001000402012O007503012O006F000400183O00061D0104007503010001000402012O00750301002EAF00D60086030100D5000402012O008603012O006F000400074O009100055O00202O00050005007D4O000600076O000800063O00202O00080008007E00122O000A007F6O0008000A00024O000800086O00040008000200062O0004008603013O000402012O008603012O006F000400013O001204000500D73O001204000600D84O0013000400064O006900045O0012040001007A3O000402012O00EB030100261B000300FC02010002000402012O00FC02012O006F00046O00C7000500013O00122O000600D93O00122O000700DA6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400BB03013O000402012O00BB03012O006F00046O00C7000500013O00122O000600DB3O00122O000700DC6O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400BB03013O000402012O00BB03012O006F000400063O00204E0004000400164O00065O00202O0006000600674O0004000600024O000500143O00202O0005000500DD4O00050002000200062O000400BB03010005000402012O00BB0301002EBC00DF00BB030100DE000402012O00BB03012O006F000400074O009100055O00202O00050005007D4O000600076O000800063O00202O00080008007E00122O000A007F6O0008000A00024O000800086O00040008000200062O000400BB03013O000402012O00BB03012O006F000400013O001204000500E03O001204000600E14O0013000400064O006900046O006F00046O00C7000500013O00122O000600E23O00122O000700E36O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400E903013O000402012O00E903012O006F00046O00E8000500013O00122O000600E43O00122O000700E56O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400E903010001000402012O00E903012O006F000400143O00200E01040004007B4O00065O00202O0006000600CA4O00040006000200062O000400E903013O000402012O00E90301002EAF00E600E9030100E7000402012O00E903012O006F000400074O009100055O00202O00050005007D4O000600076O000800063O00202O00080008007E00122O000A007F6O0008000A00024O000800086O00040008000200062O000400E903013O000402012O00E903012O006F000400013O001204000500E83O001204000600E94O0013000400064O006900045O001204000300053O000402012O00FC0201002EBC00EA0069050100EB000402012O0069050100261B0001006905010002000402012O00690501001204000300013O002EAF00ED00E3040100EC000402012O00E3040100261B000300E304010002000402012O00E304012O006F00046O00C7000500013O00122O000600EE3O00122O000700EF6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004006F04013O000402012O006F04012O006F00046O003E000500013O00122O000600F03O00122O000700F16O0005000700024O00040004000500202O0004000400F24O00040002000200262O0004006F04010005000402012O006F04012O006F00046O003E000500013O00122O000600F33O00122O000700F46O0005000700024O00040004000500202O0004000400F24O00040002000200262O0004006F04010005000402012O006F04012O006F00046O00C7000500013O00122O000600F53O00122O000700F66O0005000700024O00040004000500202O00040004002C4O00040002000200062O0004002604013O000402012O002604012O006F00046O003E000500013O00122O000600F73O00122O000700F86O0005000700024O00040004000500202O0004000400F24O00040002000200262O0004006F04010005000402012O006F04012O006F00046O00C7000500013O00122O000600F93O00122O000700FA6O0005000700024O00040004000500202O00040004002C4O00040002000200062O0004005704013O000402012O005704012O006F00046O003D000500013O00122O000600FB3O00122O000700FC6O0005000700024O00040004000500202O0004000400264O0004000200024O00058O000600013O00122O000700FD3O00122O000800FE6O0006000800024O00050005000600202O0005000500294O00050002000200062O0004001600010005000402012O005704012O006F00046O00E8000500013O00122O000600FF3O00122O00072O00015O0005000700024O00040004000500202O00040004002C4O00040002000200062O0004006F04010001000402012O006F04012O006F00046O007B000500013O00122O0006002O012O00122O00070002015O0005000700024O00040004000500202O0004000400264O00040002000200122O00050003012O00062O0005006F04010004000402012O006F04012O006F000400074O00E9000500193O00122O00060004015O0005000500064O000600076O000800063O00202O0008000800114O000A5O00122O000B0005015O000A000A000B4O0008000A00024O000800086O00040008000200062O0004006A04010001000402012O006A040100120400040006012O00120400050007012O0006EC0005006F04010004000402012O006F04012O006F000400013O00120400050008012O00120400060009013O0013000400064O006900046O006F00046O00C7000500013O00122O0006000A012O00122O0007000B015O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400E204013O000402012O00E204012O006F00046O008F000500013O00122O0006000C012O00122O0007000D015O0005000700024O00040004000500202O0004000400F24O00040002000200122O000500053O00062O000400E204010005000402012O00E204012O006F00046O008F000500013O00122O0006000E012O00122O0007000F015O0005000700024O00040004000500202O0004000400F24O00040002000200122O000500053O00062O000400E204010005000402012O00E204012O006F00046O00C7000500013O00122O00060010012O00122O00070011015O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400A404013O000402012O00A404012O006F00046O008F000500013O00122O00060012012O00122O00070013015O0005000700024O00040004000500202O0004000400F24O00040002000200122O000500053O00062O000400E204010005000402012O00E204012O006F00046O00E8000500013O00122O00060014012O00122O00070015015O0005000700024O00040004000500202O00040004002C4O00040002000200062O000400CB04010001000402012O00CB04012O006F00046O003D000500013O00122O00060016012O00122O00070017015O0005000700024O00040004000500202O0004000400264O0004000200024O00058O000600013O00122O00070018012O00122O00080019015O0006000800024O00050005000600202O0005000500294O00050002000200062O0004000C00010005000402012O00CB04012O006F00046O007B000500013O00122O0006001A012O00122O0007001B015O0005000700024O00040004000500202O0004000400264O00040002000200122O000500353O00062O000500E204010004000402012O00E204010012040004001C012O0012040005001D012O00068C000400E204010005000402012O00E204012O006F000400074O007800055O00202O0005000500384O000600086O000700076O000800063O00202O0008000800114O000A5O00202O000A000A00384O0008000A00024O000800086O00040008000200062O000400E204013O000402012O00E204012O006F000400013O0012040005001E012O0012040006001F013O0013000400064O006900045O001204000300053O001204000400053O0006230003001305010004000402012O0013050100120400040020012O00120400050021012O00068C0004001105010005000402012O001105012O006F00046O00C7000500013O00122O00060022012O00122O00070023015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001105013O000402012O001105012O006F000400063O0020E20004000400164O00065O00122O00070024015O0006000600074O00040006000200122O000500443O00062O0004001105010005000402012O001105012O006F000400074O007F00055O00122O00060025015O0005000500064O000600076O000800063O00202O0008000800114O000A5O00122O000B0025015O000A000A000B4O0008000A00024O000800086O00040008000200062O0004001105013O000402012O001105012O006F000400013O00120400050026012O00120400060027013O0013000400064O006900045O001204000100053O000402012O00690501001204000400013O000623000300F003010004000402012O00F003012O006F00046O00E8000500013O00122O00060028012O00122O00070029015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004002405010001000402012O002405010012040004002A012O0012040005002B012O0006EC0004004105010005000402012O004105012O006F000400023O00206E00040004000D4O00055O00202O0005000500954O000600036O000700013O00122O0008002C012O00122O0009002D015O0007000900024O0008001A6O0009001B6O000A00063O00202O000A000A00114O000C5O00202O000C000C00954O000A000C00024O000A000A6O0004000A000200062O0004003C05010001000402012O003C05010012040004002E012O0012040005002F012O0006EC0004004105010005000402012O004105012O006F000400013O00120400050030012O00120400060031013O0013000400064O006900046O006F00046O00C7000500013O00122O00060032012O00122O00070033015O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004006705013O000402012O006705012O006F000400103O0006930004006705013O000402012O006705012O006F0004000F3O0006930004006705013O000402012O0067050100120400040034012O00120400050035012O0006EC0004006705010005000402012O006705012O006F000400074O00F200055O00202O0005000500C14O000600076O000800063O00202O0008000800114O000A5O00202O000A000A00C14O0008000A00024O000800086O00040008000200062O0004006705013O000402012O006705012O006F000400013O00120400050036012O00120400060037013O0013000400064O006900045O001204000300023O000402012O00F003010012040003007A3O0006230001000600010003000402012O00060001001204000300014O009D000400043O00120400050038012O00120400060039012O00068C0006006E05010005000402012O006E0501001204000500013O0006230003006E05010005000402012O006E0501001204000400013O001204000500053O000623000400AF05010005000402012O00AF05010012040005003A012O0012040006003A012O000623000500AD05010006000402012O00AD05012O006F00056O00C7000600013O00122O0007003B012O00122O0008003C015O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500AD05013O000402012O00AD05012O006F000500143O00202501050005008A4O00075O00202O00070007008B4O00050007000200122O0006003D012O00062O0006009B05010005000402012O009B05012O006F000500143O00205A00050005008A4O00075O00202O00070007008B4O00050007000200122O0006003E012O00062O000600AD05010005000402012O00AD05012O006F0005001C3O0012040006007A3O00068C000500AD05010006000402012O00AD05012O006F000500074O00F200065O00202O00060006008F4O000700086O000900063O00202O0009000900114O000B5O00202O000B000B008F4O0009000B00024O000900096O00050009000200062O000500AD05013O000402012O00AD05012O006F000500013O0012040006003F012O00120400070040013O0013000500074O006900055O001204000100443O000402012O00060001001204000500023O000623000400FA05010005000402012O00FA05012O006F00056O00C7000600013O00122O00070041012O00122O00080042015O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500D605013O000402012O00D605012O006F000500143O0020A400050005007B4O00075O00122O00080043015O0007000700084O00050007000200062O000500D605013O000402012O00D605012O006F000500074O00F200065O00202O0006000600B64O000700086O000900063O00202O0009000900114O000B5O00202O000B000B00B64O0009000B00024O000900096O00050009000200062O000500D605013O000402012O00D605012O006F000500013O00120400060044012O00120400070045013O0013000500074O006900056O006F00056O00C7000600013O00122O00070046012O00122O00080047015O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500F905013O000402012O00F905012O006F000500133O001204000600183O00068C000600F905010005000402012O00F905012O006F000500074O00D000065O00202O00060006007D4O000700086O000900063O00202O00090009007E00122O000B007F6O0009000B00024O000900096O00050009000200062O000500F405010001000402012O00F4050100120400050048012O00120400060049012O00068C000600F905010005000402012O00F905012O006F000500013O0012040006004A012O0012040007004B013O0013000500074O006900055O001204000400053O001204000500013O00065C0005000106010004000402012O000106010012040005004C012O0012040006004D012O00068C0006007605010005000402012O007605012O006F00056O00C7000600013O00122O0007004E012O00122O0008004F015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005001D06013O000402012O001D06012O006F000500143O0020A400050005007B4O00075O00122O00080043015O0007000700084O00050007000200062O0005001D06013O000402012O001D06012O006F00056O00E8000600013O00122O00070050012O00122O00080051015O0006000800024O00050005000600202O00050005002C4O00050002000200062O0005002106010001000402012O0021060100120400050052012O00120400060053012O00068C0006003506010005000402012O003506012O006F000500023O00201E0105000500944O00065O00202O00060006009C4O000700033O00122O00080054015O000900063O00202O0009000900114O000B5O00202O000B000B009C4O0009000B00022O00D9000900094O00860005000900020006930005003506013O000402012O003506012O006F000500013O00120400060055012O00120400070056013O0013000500074O006900056O006F00056O00C7000600013O00122O00070057012O00122O00080058015O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005906013O000402012O005906012O006F000500143O0020A400050005007B4O00075O00122O00080043015O0007000700084O00050007000200062O0005005906013O000402012O005906012O006F000500074O00F200065O00202O00060006009C4O000700086O000900063O00202O0009000900114O000B5O00202O000B000B009C4O0009000B00024O000900096O00050009000200062O0005005906013O000402012O005906012O006F000500013O00120400060059012O0012040007005A013O0013000500074O006900055O001204000400023O000402012O00760501000402012O00060001000402012O006E0501000402012O00060001000402012O006A0601001204000300013O00065C0003006606013O000402012O006606010012040003005B012O0012040004005C012O00068C0003000200010004000402012O00020001001204000100014O009D000200023O0012043O00023O000402012O000200012O0023012O00017O006D012O00028O00026O00F03F025O0098AC40025O00C6A640025O00806840025O001EB240025O007CAE40031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74026O002440030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00309140025O0030944003103O00426F2O73466967687452656D61696E73024O0080B3C540025O00188140025O006EAB40030C3O00466967687452656D61696E73027O0040025O00A07340025O00A8A04003113O00476574456E656D696573496E52616E6765026O00444003173O00476574456E656D696573496E53706C61736852616E6765030B3O00536F756C53686172647350025O00208D4003093O00BBB4E4CF7B8691ECD603053O0014E8C189A2030A3O0049734361737461626C6503083O00497341637469766503093O0053752O6D6F6E506574025O00F6A640025O000EB140030E3O0031CAC8ABE882286127CB85A9E88F03083O001142BFA5C687EC77025O0002AF40025O0092AC40025O008C9540025O00D89640026O001440030A3O00C22D4CEBD6E60742E3CD03053O00B991452D8F03073O0049735265616479030D3O00B91718A2D39D3A14A4CE8B2O1C03053O00BCEA7F79C6030B3O004973417661696C61626C65030B3O00446562752O66537461636B03133O00536861646F77456D6272616365446562752O66026O000840030D3O00446562752O6652656D61696E73030A3O00536861646F77426F6C74030E3O0049735370652O6C496E52616E676503133O002B3A128737252C81373E07C335331A8D78634B03043O00E358527303123O007317BBA9167C4E2CB3A905664F1EA8AE166A03063O0013237FDAC76203073O002FF41FEE2EF41E03043O00827C9B6A030F3O00432O6F6C646F776E52656D61696E7303123O00E5C3F7A1B7F9718CDCC5F1BAAFF76EB6C1D203083O00DFB5AB96CFC3961C030B3O004578656375746554696D6503123O007F35F6A20C4D2EE6BC1A6B36F6BA1D4334FA03053O00692C5A83CE03073O00CCEFA7B53A31EB03063O005E9F80D2D96803073O0063F613B36D70ED03083O001A309966DF3F1F9903123O003248ECFD164FE0C00B4EEAE60E41FFFA165903043O009362208D03073O002B4CF6C634595F03073O002B782383AA6636026O00394003123O005068616E746F6D53696E67756C6172697479031B3O00440E86B8B1BF896B158EB8A2A58855148EA2BCF089550F89F6F7E003073O00E43466E7D6C5D003093O0028E979CFDE8A10D80A03083O00B67E8015AA8AEB7903073O00B8D520EAB41C2403083O0066EBBA5586E6735003073O0064032B5340DB3603073O0042376C5E3F12B403093O002284893213581D839103063O003974EDE5574703123O0099BEF8EB72EF53AFA3FEC07BFB532OBEE3FE03073O0027CAD18D87178E03073O00CC3C1C0600F7EB03063O00989F53696A52026O002840025O00FEB140025O002OAE40030F3O0056696C655461696E74437572736F7203093O004973496E52616E6765025O00A89840025O00A08F4003123O0097CF5DF7F64880CF5FE6895180CF5FB29B0E03063O003CE1A63192A9026O001840025O00BEA240025O0074AA40025O0028AB40025O005DB240025O0016B140025O0022AD40025O004AB340025O00B4944003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O00E4A640025O002EB040025O00388240025O00A06040026O007B40025O00C09640025O0080B040025O00889A40025O00A0A24003093O00496E74652O7275707403073O00417865546F2O73025O002EA540025O00C8AD40025O00508740025O0046A24003103O00417865546F2O734D6F7573656F766572025O0074A740025O00F08B40025O00809540025O0020904003093O005370652O6C4C6F636B025O00F6A240025O0046AB40025O0082AA4003123O005370652O6C4C6F636B4D6F7573656F766572025O005AAE40025O00D8B04003113O00496E74652O72757074576974685374756E025O002OA040025O00689B40025O00E8B140025O0090A940025O004C9040025O00CCAB40025O00C05140025O00D2A54003073O001C113A2633083B03063O00674F7E4F4A6103123O008970C67F5B1BAE7AC1607916AF6BC77C502O03063O007ADA1FB3133E030A3O0054616C656E7452616E6B03073O00536F756C526F74025O00888140025O00788C4003103O00A0D9D8CDF6B34AA7963OC0AF05E18203073O0025D3B6ADA1A9C1030E3O00DA3B41DC2E72BAC53B5DCD3D69BC03073O00D9975A2DB9481B026O00104003123O00F773F51F53CD68E21675D179F41153CD78E803053O0036A31C877203093O0042752O66537461636B03163O00546F726D656E7465644372657363656E646F42752O6603123O001CD44F8F4B713CDE59A15C7A3BD8588C4A7003063O001F48BB3DE22E03063O0042752O665570030A3O00446562752O66446F776E03103O004472656164546F756368446562752O6603123O00F70951DF427030C60260C0426D27C60847DD03073O0044A36623B2271E03123O008A7FC8CA06BB9714BA53C8C210B6861FBA7F03083O0071DE10BAA763D5E303094O0007FCFE3A082OFA2203043O00964E6E9B030D3O004E6967687466612O6C42752O66030E3O004D616C6566696352617074757265026O005940025O00288540025O002FB04003173O0088C42BE4A217BC7F97C437F5B10CBA0088C42EEFE44CE903083O0020E5A54781C47EDF025O0046B140025O00E8A14003093O00E79BC5888FF9CA8FC103063O00B5A3E9A42OE103143O00496E6576697461626C6544656D69736542752O66026O004840026O00344003093O00447261696E4C69666503123O0054993F7E5EB4327E568E7E7A5182303702D303043O001730EB5E026O001C40025O00F8A340030A3O0065C4E1FB69FF52C2FCE703063O008F26AB93891C03113O00446562752O665265667265736861626C6503103O00436F2O72757074696F6E446562752O66030A3O00436F2O72757074696F6E025O0044B340025O00308C4003123O00D38DABE116F3C0D98DB7B30EE2DDDEC2E8A303073O00B4B0E2D993638303053O006AC41BE33603063O00C82BA3748D4F030B3O0041676F6E79446562752O66025O00707F40025O00449640025O0007B34003053O0041676F6E79030C3O00BE31328DA9B4EEBE3F33C3E603073O0083DF565DE3D094025O00A6A340025O00D0A14003123O00D64BA5A21CB7EF4097B01BB9EA46A2BF12BB03063O00D583252OD67D03183O00556E737461626C65412O666C696374696F6E446562752O6603123O00556E737461626C65412O666C696374696F6E031A3O00332536ABE024272080E0202D29B6E232222AB1A12B2A2CB1A17E03053O0081464B45DF025O0080A740025O00707240025O00388840025O00DCB240025O0096A740025O001AA240025O00CCA040025O0098A840025O00188740025O00E0B140025O003AB240025O0006AE40025O00ACA740025O00B4A340025O00C09840025O005AA940025O006AB140025O0014A740025O0040A040025O00307D40026O004D40025O00508340025O00D88B40025O008EAC40025O00BFB040025O004CAC40026O004140025O0012A440025O0078A640025O00AC9440030A3O00E0B03F0FDCB7030ED5BC03043O0067B3D94F03103O00536970686F6E4C696665446562752O66025O00B89F40030A3O00536970686F6E4C69666503133O0059BE0CDD4E829C46BE1AD00181A243B95C841303073O00C32AD77CB521EC03053O00255822303103063O00986D39575E45030B3O004861756E74446562752O66025O00E09F40025O0050854003053O004861756E74025O00D07040025O009CA240030D3O00F1D61FADAA9259A9F0D94AF2EA03083O00C899B76AC3DEB234025O00208A40025O0024B04003093O0016F1893447693DF68403063O003A5283E85D29030D3O00B05FD1115228A65AD2075C3C8603063O005FE337B0753D03093O00447261696E536F756C03123O001C6C2242A5276D2C5EA758732242A5582F7503053O00CB781E432B025O005AA740025O009C9040026O002040025O00CCA240025O002AA940030A3O00783DBE52E84B26A54FF303053O009D3B52CC20025O00DEAB40025O006BB14003123O003B31F1E8FCFAC7B83730A3F7E8E3DDF16B6803083O00D1585E839A898AB303093O000CB3C5752O103E372403083O004248C1A41C7E435103123O00E33EA9512849F423BD54667BE625A618722603063O0016874CC83846030A3O00BE38F92052F6AF3FF43003063O0081ED5098443D025O00109D40025O0022A04003133O0042A005F713006753A708E75C1A5958A644A74E03073O003831C864937C77025O0096A040025O001EB34003093O0058C8D9545900DD69D603073O00B21CBAB83D3753025O0046AC4003123O00C0DF4635FC31E6CBD84B7CFF0FFCCA8D146C03073O0095A4AD275C926E025O000EAA40030A3O00C02F111B150CD1281C0B03063O007B9347707F7A03133O00DFC5837549DBF2807E4AD88D8F704FC28DD12303053O0026ACADE211025O007DB140025O0022AC4003053O006C1623E15403043O008F2D714C025O002CAB40025O00688240030D3O00B9BF1332A1F8113DB1B65C6FEC03043O005C2OD87C030F3O004B9FC34EA05C19506A81C94FAE403803083O003118EAAE23CF325D025O00109B40025O00406040030F3O0053752O6D6F6E4461726B676C61726503173O001FE7F0857E02CDF9896307F5F1896309B2F0897802B2A903053O00116C929DE8025O00188B40025O001EA940025O00C88440025O00BDB140030E3O0022AEA216F9E1EFE30EBFBA062OED03083O00B16FCFCE739F888C030A3O00219B2O15D07B50108A1803073O003F65E97074B42F03083O00446562752O665570030A3O00F032FD1AF738EF32EB1703063O0056A35B8D729803123O006303757D2E5C06477A34541E7872285A1F6D03053O005A336B141303123O00BDF884E12982FDB6E6338AE589EE2F84E49C03053O005DED90E58F030C3O00432O6F6C646F776E446F776E03093O0023FFFC1C3F471CF8E403063O0026759690796B03093O001BB2E23F19BAE7343903043O005A4DDB8E03073O00D50B34357E086E03073O001A866441592C6703073O00C2EC252F96FEF703053O00C49183504303163O0013B10A0D1EE11D8F140908FC0BA2034815E917BE465A03063O00887ED0666878025O00049140025O00FEAA40030C3O004570696353652O74696E677303073O008DBCA01884F6E303073O0090D9D3C77FE8932O033O00F7203D03083O0024984F5E48B52562025O0084AB40025O00C4A04003073O00E3D74038DBDD5403043O005FB7B8272O033O00B430E203073O0062D55F874634E003073O00CAACCE7058FBB003053O00349EC3A9172O033O0079B82103083O00EB1ADC5214E6551B025O0074A9400069072O0012043O00014O009D000100023O00261B3O000700010001000402012O00070001001204000100014O009D000200023O0012043O00023O002E89000300FBFF2O0003000402012O00020001000E450002000200013O000402012O00020001000E450001000B00010001000402012O000B0001001204000200013O002EBC0005006B00010004000402012O006B000100261B0002006B00010002000402012O006B0001001204000300014O009D000400043O000E450001001400010003000402012O00140001001204000400013O0026190004001B00010002000402012O001B0001002EAF0006005500010007000402012O005500012O006F00055O0006930005002400013O000402012O002400012O006F000500023O00200A00050005000800122O000700096O0005000700024O000500013O00044O00260001001204000500024O0011000500014O006F000500033O00203F00050005000A2O000E00050001000200061D0105003000010001000402012O003000012O006F000500043O00200801050005000B2O00BB0005000200020006930005005400013O000402012O00540001001204000500014O009D000600063O0026190005003600010001000402012O00360001002EBC000D00320001000C000402012O00320001001204000600013O000E450001004200010006000402012O004200012O006F000700063O0020F000070007000E4O000800086O000900016O0007000900024O000700056O000700056O000700073O00122O000600023O000E450002003700010006000402012O003700012O006F000700073O00261B000700540001000F000402012O00540001002EAF0011004A00010010000402012O004A0001000402012O005400012O006F000700063O00200B0107000700124O000800086O00098O0007000900024O000700073O00044O00540001000402012O00370001000402012O00540001000402012O00320001001204000400133O00261B0004005900010013000402012O00590001001204000200133O000402012O006B0001000E500001005D00010004000402012O005D0001002EAF0015001700010014000402012O001700012O006F000500043O00206700050005001600122O000700176O0005000700024O000500096O000500023O00202O00050005001800122O000700096O0005000700024O000500083O00122O000400023O00044O00170001000402012O006B0001000402012O0014000100261B0002001807010013000402012O001807012O006F000300043O0020080103000300192O00BB0003000200022O00110003000A3O002E89001A00210001001A000402012O009200012O006F0003000B4O00C70004000C3O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003009200013O000402012O009200012O006F0003000D3O0006930003009200013O000402012O009200012O006F0003000E3O00200801030003001E2O00BB00030002000200061D0103009200010001000402012O009200012O006F0003000F4O006F0004000B3O00203F00040004001F2O00BB00030002000200061D0103008D00010001000402012O008D0001002E890020000700010021000402012O009200012O006F0003000C3O001204000400223O001204000500234O0013000300054O006900036O006F000300033O00203F00030003000A2O000E00030001000200061D0103009900010001000402012O00990001002EBC0024006807010025000402012O00680701001204000300014O009D000400043O0026190003009F00010001000402012O009F0001002E89002600FEFF2O0027000402012O009B0001001204000400013O00261B000400852O010028000402012O00852O012O006F0005000B4O00C70006000C3O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500D600013O000402012O00D600012O006F0005000B4O00C70006000C3O00122O0007002C3O00122O0008002D6O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500D600013O000402012O00D600012O006F000500023O00202A01050005002F4O0007000B3O00202O0007000700304O00050007000200262O000500C400010031000402012O00C400012O006F000500023O0020AC0005000500324O0007000B3O00202O0007000700304O00050007000200262O000500D600010031000402012O00D600012O006F000500104O00F20006000B3O00202O0006000600334O000700086O000900023O00202O0009000900344O000B000B3O00202O000B000B00334O0009000B00024O000900096O00050009000200062O000500D600013O000402012O00D600012O006F0005000C3O001204000600353O001204000700364O0013000500074O006900056O006F0005000B4O00C70006000C3O00122O000700373O00122O000800386O0006000800024O00050005000600202O00050005001D4O00050002000200062O000500352O013O000402012O00352O012O006F0005000B4O003D0006000C3O00122O000700393O00122O0008003A6O0006000800024O00050005000600202O00050005003B4O0005000200024O0006000B6O0007000C3O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O00060006003E4O00060002000200062O0005003100010006000402012O00222O012O006F0005000B4O00E80006000C3O00122O0007003F3O00122O000800406O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500352O010001000402012O00352O012O006F0005000B4O00C70006000C3O00122O000700413O00122O000800426O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500222O013O000402012O00222O012O006F0005000B4O003D0006000C3O00122O000700433O00122O000800446O0006000800024O00050005000600202O00050005003B4O0005000200024O0006000B6O0007000C3O00122O000800453O00122O000900466O0007000900024O00060006000700202O00060006003E4O00060002000200062O0005000B00010006000402012O00222O012O006F0005000B4O00150006000C3O00122O000700473O00122O000800486O0006000800024O00050005000600202O00050005003B4O000500020002000E2O004900352O010005000402012O00352O012O006F000500104O00780006000B3O00202O00060006004A4O000700116O000800086O000900023O00202O0009000900344O000B000B3O00202O000B000B004A4O0009000B00024O000900096O00050009000200062O000500352O013O000402012O00352O012O006F0005000C3O0012040006004B3O0012040007004C4O0013000500074O006900056O006F0005000B4O00C70006000C3O00122O0007004D3O00122O0008004E6O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005006F2O013O000402012O006F2O012O006F0005000B4O00C70006000C3O00122O0007004F3O00122O000800506O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500712O013O000402012O00712O012O006F0005000B4O003D0006000C3O00122O000700513O00122O000800526O0006000800024O00050005000600202O00050005003B4O0005000200024O0006000B6O0007000C3O00122O000800533O00122O000900546O0007000900024O00060006000700202O00060006003E4O00060002000200062O0005001700010006000402012O00712O012O006F0005000B4O00E80006000C3O00122O000700553O00122O000800566O0006000800024O00050005000600202O00050005002E4O00050002000200062O0005006F2O010001000402012O006F2O012O006F0005000B4O00330006000C3O00122O000700573O00122O000800586O0006000800024O00050005000600202O00050005003B4O000500020002000E52005900712O010005000402012O00712O01002EBC005A00842O01005B000402012O00842O012O006F000500104O00D0000600123O00202O00060006005C4O000700086O000900023O00202O00090009005D00122O000B00176O0009000B00024O000900096O00050009000200062O0005007F2O010001000402012O007F2O01002EBC005E00842O01005F000402012O00842O012O006F0005000C3O001204000600603O001204000700614O0013000500074O006900055O001204000400623O00261B0004007302010001000402012O00730201001204000500013O0026190005008C2O010001000402012O008C2O01002EAF0064006C02010063000402012O006C02012O006F000600043O00200801060006000B2O00BB00060002000200061D010600B92O010001000402012O00B92O012O006F000600133O000693000600B92O013O000402012O00B92O01001204000600014O009D000700093O0026190006009A2O010001000402012O009A2O01002EAF0066009D2O010065000402012O009D2O01001204000700014O009D000800083O001204000600023O002619000600A12O010002000402012O00A12O01002EBC006700962O010068000402012O00962O012O009D000900093O000E45000200B12O010007000402012O00B12O01002619000800A82O010001000402012O00A82O01002EBC006900A42O01006A000402012O00A42O012O006F000A00144O000E000A000100022O00940009000A3O000693000900B92O013O000402012O00B92O012O0097000900023O000402012O00B92O01000402012O00A42O01000402012O00B92O0100261B000700A22O010001000402012O00A22O01001204000800014O009D000900093O001204000700023O000402012O00A22O01000402012O00B92O01000402012O00962O012O006F000600043O00200801060006006B2O00BB00060002000200061D010600C32O010001000402012O00C32O012O006F000600043O00200801060006006C2O00BB000600020002000693000600C52O013O000402012O00C52O01002EAF006E006B0201006D000402012O006B0201001204000600014O009D000700083O000E45000100D42O010006000402012O00D42O01001204000900013O00261B000900CE2O010002000402012O00CE2O01001204000600023O000402012O00D42O0100261B000900CA2O010001000402012O00CA2O01001204000700014O009D000800083O001204000900023O000402012O00CA2O01002EBC007000C72O01006F000402012O00C72O0100261B000600C72O010002000402012O00C72O01002E890071003700010071000402012O000F020100261B0007000F02010002000402012O000F0201001204000900014O009D000A000A3O002EBC007200DE2O010073000402012O00DE2O01000E45000100DE2O010009000402012O00DE2O01001204000A00013O002619000A00E72O010001000402012O00E72O01002EBC007500F52O010074000402012O00F52O012O006F000B00033O002076000B000B00764O000C000B3O00202O000C000C007700122O000D00176O000E00016O000B000E00024O0008000B3O002E2O007800F42O010079000402012O00F42O01000693000800F42O013O000402012O00F42O012O0097000800023O001204000A00023O000E50000200F92O01000A000402012O00F92O01002EBC007B00080201007A000402012O000802012O006F000B00033O0020B4000B000B00764O000C000B3O00202O000C000C007700122O000D00176O000E00016O000F00156O001000123O00202O00100010007C4O000B001000024O0008000B3O00062O0008000702013O000402012O000702012O0097000800023O001204000A00133O00261B000A00E32O010013000402012O00E32O01001204000700133O000402012O000F0201000402012O00E32O01000402012O000F0201000402012O00DE2O01002EBC007E00460201007D000402012O0046020100261B0007004602010001000402012O00460201001204000900013O0026190009001802010001000402012O00180201002EBC007F002E02010080000402012O002E0201001204000A00013O00261B000A001D02010002000402012O001D0201001204000900023O000402012O002E0201000E45000100190201000A000402012O001902012O006F000B00033O002022000B000B00764O000C000B3O00202O000C000C008100122O000D00176O000E00016O000B000E00024O0008000B3O002E2O0082000500010082000402012O002C02010006930008002C02013O000402012O002C02012O0097000800023O001204000A00023O000402012O00190201002EAF0084003402010083000402012O0034020100261B0009003402010013000402012O00340201001204000700023O000402012O0046020100261B0009001402010002000402012O001402012O006F000A00033O0020B4000A000A00764O000B000B3O00202O000B000B008100122O000C00176O000D00016O000E00156O000F00123O00202O000F000F00854O000A000F00024O0008000A3O00062O0008004402013O000402012O004402012O0097000800023O001204000900133O000402012O001402010026190007004A02010013000402012O004A0201002EAF008700D82O010086000402012O00D82O012O006F000900033O00203C0009000900884O000A000B3O00202O000A000A007700122O000B00176O000C00016O0009000C00024O000800093O00062O0008005602010001000402012O00560201002EAF008900570201008A000402012O005702012O0097000800024O006F000900033O0020430009000900884O000A000B3O00202O000A000A007700122O000B00176O000C00016O000D00156O000E00123O00202O000E000E007C4O0009000E00024O000800093O00061D0108006602010001000402012O00660201002EBC008B006B0201008C000402012O006B02012O0097000800023O000402012O006B0201000402012O00D82O01000402012O006B0201000402012O00C72O01001204000500023O000E45000200882O010005000402012O00882O012O006F000600164O009E000600010001001204000400023O000402012O00730201000402012O00882O01002EBC008D00770301008E000402012O0077030100261B0004007703010062000402012O00770301001204000500014O009D000600063O002E89008F3O0001008F000402012O0079020100261B0005007902010001000402012O00790201001204000600013O002E89009000C300010090000402012O0041030100261B0006004103010001000402012O00410301001204000700013O000E450002008702010007000402012O00870201001204000600023O000402012O0041030100261B0007008302010001000402012O008302012O006F0008000B4O00C70009000C3O00122O000A00913O00122O000B00926O0009000B00024O00080008000900202O00080008002B4O00080002000200062O000800B702013O000402012O00B702012O006F000800173O000693000800B702013O000402012O00B702012O006F000800183O00061D010800A302010001000402012O00A302012O006F0008000B4O00330009000C3O00122O000A00933O00122O000B00946O0009000B00024O00080008000900202O0008000800954O000800020002002619000800B702010002000402012O00B702012O006F000800104O00600009000B3O00202O0009000900964O000A000B6O000C00023O00202O000C000C00344O000E000B3O00202O000E000E00964O000C000E00024O000C000C6O0008000C000200062O000800B202010001000402012O00B20201002EAF009800B702010097000402012O00B702012O006F0008000C3O001204000900993O001204000A009A4O00130008000A4O006900086O006F0008000B4O00C70009000C3O00122O000A009B3O00122O000B009C6O0009000B00024O00080008000900202O00080008002B4O00080002000200062O0008003F03013O000402012O003F03012O006F0008000A3O000E81009D002C03010008000402012O002C03012O006F0008000B4O00C70009000C3O00122O000A009E3O00122O000B009F6O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800D802013O000402012O00D802012O006F000800043O0020CF0008000800A04O000A000B3O00202O000A000A00A14O0008000A000200262O000800D802010002000402012O00D802012O006F0008000A3O000E810031002C03010008000402012O002C03012O006F0008000B4O00C70009000C3O00122O000A00A23O00122O000B00A36O0009000B00024O00080008000900202O00080008002E4O00080002000200062O000800F002013O000402012O00F002012O006F000800043O00200E0108000800A44O000A000B3O00202O000A000A00A14O0008000A000200062O000800F002013O000402012O00F002012O006F000800023O0020060108000800A54O000A000B3O00202O000A000A00A64O0008000A000200062O0008002C03010001000402012O002C03012O006F0008000B4O00C70009000C3O00122O000A00A73O00122O000B00A86O0009000B00024O00080008000900202O00080008002E4O00080002000200062O0008000103013O000402012O000103012O006F000800043O0020540008000800A04O000A000B3O00202O000A000A00A14O0008000A000200262O0008002C03010013000402012O002C03012O006F000800193O00061D0108002C03010001000402012O002C03012O006F0008001A3O0006930008000A03013O000402012O000A03012O006F0008000A3O000E810002002C03010008000402012O002C03012O006F0008000B4O00C70009000C3O00122O000A00A93O00122O000B00AA6O0009000B00024O00080008000900202O00080008002E4O00080002000200062O0008003F03013O000402012O003F03012O006F0008000B4O00C70009000C3O00122O000A00AB3O00122O000B00AC6O0009000B00024O00080008000900202O00080008002E4O00080002000200062O0008003F03013O000402012O003F03012O006F000800043O00200E0108000800A44O000A000B3O00202O000A000A00A14O0008000A000200062O0008003F03013O000402012O003F03012O006F000800043O00200E0108000800A44O000A000B3O00202O000A000A00AD4O0008000A000200062O0008003F03013O000402012O003F03012O006F000800104O00D00009000B3O00202O0009000900AE4O000A000B6O000C00023O00202O000C000C005D00122O000E00AF6O000C000E00024O000C000C6O0008000C000200062O0008003A03010001000402012O003A0301002EBC00B1003F030100B0000402012O003F03012O006F0008000C3O001204000900B23O001204000A00B34O00130008000A4O006900085O001204000700023O000402012O00830201002EAF00B5007E020100B4000402012O007E020100261B0006007E02010002000402012O007E02012O006F0007000B4O00C70008000C3O00122O000900B63O00122O000A00B76O0008000A00024O00070007000800202O00070007002B4O00070002000200062O0007007203013O000402012O007203012O006F000700043O0020210107000700A04O0009000B3O00202O0009000900B84O000700090002000E2O00B9006003010007000402012O006003012O006F000700043O0020000107000700A04O0009000B3O00202O0009000900B84O000700090002000E2O00BA007203010007000402012O007203012O006F000700073O0026B8000700720301009D000402012O007203012O006F000700104O00F20008000B3O00202O0008000800BB4O0009000A6O000B00023O00202O000B000B00344O000D000B3O00202O000D000D00BB4O000B000D00024O000B000B6O0007000B000200062O0007007203013O000402012O007203012O006F0007000C3O001204000800BC3O001204000900BD4O0013000700094O006900075O001204000400BE3O000402012O00770301000402012O007E0201000402012O00770301000402012O0079020100261B000400F503010031000402012O00F50301001204000500013O0026190005007E03010002000402012O007E0301002EBC006400A5030100BF000402012O00A503012O006F0006000B4O00C70007000C3O00122O000800C03O00122O000900C16O0007000900024O00060006000700202O00060006001D4O00060002000200062O000600A303013O000402012O00A303012O006F000600023O00200E0106000600C24O0008000B3O00202O0008000800C34O00060008000200062O000600A303013O000402012O00A303012O006F000600104O00600007000B3O00202O0007000700C44O000800096O000A00023O00202O000A000A00344O000C000B3O00202O000C000C00C44O000A000C00024O000A000A6O0006000A000200062O0006009E03010001000402012O009E0301002EAF00C500A3030100C6000402012O00A303012O006F0006000C3O001204000700C73O001204000800C84O0013000600084O006900065O0012040004009D3O000402012O00F5030100261B0005007A03010001000402012O007A03012O006F0006000B4O00C70007000C3O00122O000800C93O00122O000900CA6O0007000900024O00060006000700202O00060006001D4O00060002000200062O000600B803013O000402012O00B803012O006F000600023O00202A0106000600324O0008000B3O00202O0008000800CB4O00060008000200262O000600BA03010028000402012O00BA0301002EBC00CD00CE030100CC000402012O00CE0301002E8900CE0014000100CE000402012O00CE03012O006F000600104O00F20007000B3O00202O0007000700CF4O000800096O000A00023O00202O000A000A00344O000C000B3O00202O000C000C00CF4O000A000C00024O000A000A6O0006000A000200062O000600CE03013O000402012O00CE03012O006F0006000C3O001204000700D03O001204000800D14O0013000600084O006900065O002EAF00D300F3030100D2000402012O00F303012O006F0006000B4O00C70007000C3O00122O000800D43O00122O000900D56O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600F303013O000402012O00F303012O006F000600023O0020AC0006000600324O0008000B3O00202O0008000800D64O00060008000200262O000600F303010028000402012O00F303012O006F000600104O00F20007000B3O00202O0007000700D74O000800096O000A00023O00202O000A000A00344O000C000B3O00202O000C000C00D74O000A000C00024O000A000A6O0006000A000200062O000600F303013O000402012O00F303012O006F0006000C3O001204000700D83O001204000800D94O0013000600084O006900065O001204000500023O000402012O007A0301002E8900DA0099000100DA000402012O008E040100261B0004008E04010002000402012O008E0401001204000500013O002EAF00DB005E040100DC000402012O005E040100261B0005005E04010001000402012O005E0401001204000600013O000E450001005904010006000402012O005904012O006F000700013O000EFE0002000704010007000402012O000704012O006F000700013O00262O0007000904010031000402012O00090401002EBC00DD002E040100DE000402012O002E0401001204000700014O009D0008000A3O002EBC00E00028040100DF000402012O0028040100261B0007002804010002000402012O002804012O009D000A000A3O00261B0008001504010001000402012O00150401001204000900014O009D000A000A3O001204000800023O00261B0008001004010002000402012O001004010026190009001B04010001000402012O001B0401002E8900E100FEFF2O00E2000402012O001704012O006F000B001B4O000E000B000100022O0094000A000B3O002EAF00E3002E040100E4000402012O002E0401000693000A002E04013O000402012O002E04012O0097000A00023O000402012O002E0401000402012O00170401000402012O002E0401000402012O00100401000402012O002E040100261B0007000B04010001000402012O000B0401001204000800014O009D000900093O001204000700023O000402012O000B04012O006F000700013O000E810013003304010007000402012O00330401002E8900E50027000100E6000402012O00580401001204000700014O009D0008000A3O002EAF00E8003C040100E7000402012O003C040100261B0007003C04010001000402012O003C0401001204000800014O009D000900093O001204000700023O00261B0007003504010002000402012O003504012O009D000A000A3O000E450001004404010008000402012O00440401001204000900014O009D000A000A3O001204000800023O00261B0008003F04010002000402012O003F0401002E8900E93O000100E9000402012O0046040100261B0009004604010001000402012O004604012O006F000B001C4O000E000B000100022O0094000A000B3O00061D010A005104010001000402012O00510401002EBC00EA0058040100EB000402012O005804012O0097000A00023O000402012O00580401000402012O00460401000402012O00580401000402012O003F0401000402012O00580401000402012O00350401001204000600023O00261B000600FF03010002000402012O00FF0301001204000500023O000402012O005E0401000402012O00FF03010026190005006204010002000402012O00620401002EBC00EC00FA030100ED000402012O00FA0301002EAF00EE008B040100EF000402012O008B04012O006F0006001D4O000E0006000100020006930006008B04013O000402012O008B0401001204000600014O009D000700093O000E500002006E04010006000402012O006E0401002EAF00F10085040100F0000402012O008504012O009D000900093O0026190007007304010001000402012O00730401002EAF00F20076040100F3000402012O00760401001204000800014O009D000900093O001204000700023O00261B0007006F04010002000402012O006F040100261B0008007804010001000402012O007804012O006F000A001E4O000E000A000100022O00940009000A3O0006930009008B04013O000402012O008B04012O0097000900023O000402012O008B0401000402012O00780401000402012O008B0401000402012O006F0401000402012O008B040100261B0006006A04010001000402012O006A0401001204000700014O009D000800083O001204000600023O000402012O006A0401001204000400133O000402012O008E0401000402012O00FA0301002EBC00F40037050100F5000402012O00370501000E45009D003705010004000402012O00370501001204000500013O00261B000500F504010001000402012O00F50401001204000600013O0026190006009A04010001000402012O009A0401002E8900F60057000100F7000402012O00EF04012O006F0007000B4O00C70008000C3O00122O000900F83O00122O000A00F96O0008000A00024O00070007000800202O00070007001D4O00070002000200062O000700BF04013O000402012O00BF04012O006F000700023O00200E0107000700C24O0009000B3O00202O0009000900FA4O00070009000200062O000700BF04013O000402012O00BF0401002E8900FB0014000100FB000402012O00BF04012O006F000700104O00F20008000B3O00202O0008000800FC4O0009000A6O000B00023O00202O000B000B00344O000D000B3O00202O000D000D00FC4O000B000D00024O000B000B6O0007000B000200062O000700BF04013O000402012O00BF04012O006F0007000C3O001204000800FD3O001204000900FE4O0013000700094O006900076O006F0007000B4O00C70008000C3O00122O000900FF3O00122O000A2O00015O0008000A00024O00070007000800202O00070007002B4O00070002000200062O000700D204013O000402012O00D204012O006F000700023O0020EB0007000700324O0009000B3O00122O000A002O015O00090009000A4O00070009000200122O000800313O00062O000700D604010008000402012O00D6040100120400070002012O00120400080003012O000623000700EE04010008000402012O00EE04012O006F000700104O00E90008000B3O00122O00090004015O0008000800094O0009000A6O000B00023O00202O000B000B00344O000D000B3O00122O000E0004015O000D000D000E4O000B000D00024O000B000B6O0007000B000200062O000700E904010001000402012O00E9040100120400070005012O00120400080006012O00068C000800EE04010007000402012O00EE04012O006F0007000C3O00120400080007012O00120400090008013O0013000700094O006900075O001204000600023O001204000700023O0006230007009604010006000402012O00960401001204000500023O000402012O00F50401000402012O00960401001204000600023O0006230005009304010006000402012O0093040100120400060009012O0012040007000A012O00068C0006003405010007000402012O003405012O006F0006000B4O00C70007000C3O00122O0008000B012O00122O0009000C015O0007000900024O00060006000700202O00060006002B4O00060002000200062O0006003405013O000402012O003405012O006F0006000B4O00C70007000C3O00122O0008000D012O00122O0009000E015O0007000900024O00060006000700202O00060006002E4O00060002000200062O0006003405013O000402012O003405012O006F000600023O00202501060006002F4O0008000B3O00202O0008000800304O00060008000200122O000700313O00062O0006002005010007000402012O002005012O006F000600023O00205A0006000600324O0008000B3O00202O0008000800304O00060008000200122O000700313O00062O0006003405010007000402012O003405012O006F000600104O007F0007000B3O00122O0008000F015O0007000700084O000800096O000A00023O00202O000A000A00344O000C000B3O00122O000D000F015O000C000C000D4O000A000C00024O000A000A6O0006000A000200062O0006003405013O000402012O003405012O006F0006000C3O00120400070010012O00120400080011013O0013000600084O006900065O001204000400283O000402012O00370501000402012O0093040100120400050012012O00120400060013012O0006EC000600A805010005000402012O00A8050100120400050014012O000623000400A805010005000402012O00A8050100120400050015012O00120400060016012O0006EC0005006905010006000402012O006905012O006F0005000B4O00C70006000C3O00122O00070017012O00122O00080018015O0006000800024O00050005000600202O00050005001D4O00050002000200062O0005006905013O000402012O006905012O006F000500023O00200E0105000500C24O0007000B3O00202O0007000700C34O00050007000200062O0005006905013O000402012O0069050100120400050019012O0012040006001A012O00068C0005006905010006000402012O006905012O006F000500104O00F20006000B3O00202O0006000600C44O000700086O000900023O00202O0009000900344O000B000B3O00202O000B000B00C44O0009000B00024O000900096O00050009000200062O0005006905013O000402012O006905012O006F0005000C3O0012040006001B012O0012040007001C013O0013000500074O006900056O006F0005000B4O00C70006000C3O00122O0007001D012O00122O0008001E015O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005008705013O000402012O008705012O006F000500104O007F0006000B3O00122O0007000F015O0006000600074O000700086O000900023O00202O0009000900344O000B000B3O00122O000C000F015O000B000B000C4O0009000B00024O000900096O00050009000200062O0005008705013O000402012O008705012O006F0005000C3O0012040006001F012O00120400070020013O0013000500074O006900056O006F0005000B4O00C70006000C3O00122O00070021012O00122O00080022015O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005006807013O000402012O006807012O006F000500104O00600006000B3O00202O0006000600334O000700086O000900023O00202O0009000900344O000B000B3O00202O000B000B00334O0009000B00024O000900096O00050009000200062O000500A205010001000402012O00A2050100120400050023012O00120400060024012O0006EC0006006807010005000402012O006807012O006F0005000C3O00122700060025012O00122O00070026015O000500076O00055O00044O00680701001204000500BE3O00065C000400AF05010005000402012O00AF050100120400050027012O00120400060028012O0006EC0006003506010005000402012O00350601001204000500013O001204000600013O0006230005000406010006000402012O000406012O006F0006000B4O00C70007000C3O00122O00080029012O00122O0009002A015O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600DC05013O000402012O00DC05012O006F000600043O00200E0106000600A44O0008000B3O00202O0008000800AD4O00060008000200062O000600DC05013O000402012O00DC05010012040006002B012O0012040007002B012O000623000600DC05010007000402012O00DC05012O006F000600104O007F0007000B3O00122O0008000F015O0007000700084O000800096O000A00023O00202O000A000A00344O000C000B3O00122O000D000F015O000C000C000D4O000A000C00024O000A000A6O0006000A000200062O000600DC05013O000402012O00DC05012O006F0006000C3O0012040007002C012O0012040008002D013O0013000600084O006900065O001204000600153O0012040007002E012O00068C0006000306010007000402012O000306012O006F0006000B4O00C70007000C3O00122O0008002F012O00122O00090030015O0007000900024O00060006000700202O00060006002B4O00060002000200062O0006000306013O000402012O000306012O006F000600043O00200E0106000600A44O0008000B3O00202O0008000800AD4O00060008000200062O0006000306013O000402012O000306012O006F000600104O00F20007000B3O00202O0007000700334O000800096O000A00023O00202O000A000A00344O000C000B3O00202O000C000C00334O000A000C00024O000A000A6O0006000A000200062O0006000306013O000402012O000306012O006F0006000C3O00120400070031012O00120400080032013O0013000600084O006900065O001204000500023O001204000600023O00065C0005000B06010006000402012O000B060100120400060033012O00120400070034012O0006EC000600B005010007000402012O00B005012O006F0006000B4O00C70007000C3O00122O00080035012O00122O00090036015O0007000900024O00060006000700202O00060006001D4O00060002000200062O0006003206013O000402012O003206012O006F000600023O00200E0106000600C24O0008000B3O00202O0008000800CB4O00060008000200062O0006003206013O000402012O003206012O006F000600104O00600007000B3O00202O0007000700CF4O000800096O000A00023O00202O000A000A00344O000C000B3O00202O000C000C00CF4O000A000C00024O000A000A6O0006000A000200062O0006002D06010001000402012O002D060100120400060037012O00120400070038012O0006230006003206010007000402012O003206012O006F0006000C3O00120400070039012O0012040008003A013O0013000600084O006900065O00120400040014012O000402012O00350601000402012O00B00501001204000500133O000623000400A000010005000402012O00A00001001204000500014O009D000600063O001204000700013O0006230005003A06010007000402012O003A0601001204000600013O001204000700023O0006230006006706010007000402012O006706012O006F0007000B4O00C70008000C3O00122O0009003B012O00122O000A003C015O0008000A00024O00070007000800202O00070007002B4O00070002000200062O0007006506013O000402012O006506012O006F000700183O0006930007006506013O000402012O006506012O006F000700173O0006930007006506013O000402012O006506012O006F0007001F3O0006930007006506013O000402012O006506010012040007003D012O0012040008003E012O0006EC0008006506010007000402012O006506012O006F000700104O00090108000B3O00122O0009003F015O0008000800094O000900206O00070009000200062O0007006506013O000402012O006506012O006F0007000C3O00120400080040012O00120400090041013O0013000700094O006900075O001204000400313O000402012O00A00001001204000700013O0006230006003E06010007000402012O003E06012O006F000700213O00061D0107007106010001000402012O0071060100120400070042012O00120400080043012O00068C0008007E06010007000402012O007E0601001204000700014O009D000800083O001204000900013O0006230007007306010009000402012O007306012O006F000900224O000E0009000100022O0094000800093O0006930008007E06013O000402012O007E06012O0097000800023O000402012O007E0601000402012O0073060100120400070044012O00120400080045012O0006EC0007001007010008000402012O001007012O006F0007000B4O00C70008000C3O00122O00090046012O00122O000A0047015O0008000A00024O00070007000800202O00070007002B4O00070002000200062O0007001007013O000402012O001007012O006F0007000B4O00C70008000C3O00122O00090048012O00122O000A0049015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O0007001007013O000402012O001007012O006F000700023O00205A0007000700324O0009000B3O00202O0009000900A64O00070009000200122O000800133O00062O0007001007010008000402012O001007012O006F000700023O0012680009004A015O0007000700094O0009000B3O00202O0009000900CB4O00070009000200062O0007001007013O000402012O001007012O006F000700023O0012680009004A015O0007000700094O0009000B3O00202O0009000900C34O00070009000200062O0007001007013O000402012O001007012O006F0007000B4O00C70008000C3O00122O0009004B012O00122O000A004C015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O000700C006013O000402012O00C006012O006F000700023O0012680009004A015O0007000700094O0009000B3O00202O0009000900FA4O00070009000200062O0007001007013O000402012O001007012O006F0007000B4O00C70008000C3O00122O0009004D012O00122O000A004E015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O000700D506013O000402012O00D506012O006F0007000B4O00BD0008000C3O00122O0009004F012O00122O000A0050015O0008000A00024O00070007000800122O00090051015O0007000700094O00070002000200062O0007001007013O000402012O001007012O006F0007000B4O00C70008000C3O00122O00090052012O00122O000A0053015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O000700EA06013O000402012O00EA06012O006F0007000B4O00BD0008000C3O00122O00090054012O00122O000A0055015O0008000A00024O00070007000800122O00090051015O0007000700094O00070002000200062O0007001007013O000402012O001007012O006F0007000B4O00C70008000C3O00122O00090056012O00122O000A0057015O0008000A00024O00070007000800202O00070007002E4O00070002000200062O000700FF06013O000402012O00FF06012O006F0007000B4O00BD0008000C3O00122O00090058012O00122O000A0059015O0008000A00024O00070007000800122O00090051015O0007000700094O00070002000200062O0007001007013O000402012O001007012O006F000700104O00910008000B3O00202O0008000800AE4O0009000A6O000B00023O00202O000B000B005D00122O000D00AF6O000B000D00024O000B000B6O0007000B000200062O0007001007013O000402012O001007012O006F0007000C3O0012040008005A012O0012040009005B013O0013000700094O006900075O001204000600023O000402012O003E0601000402012O00A00001000402012O003A0601000402012O00A00001000402012O00680701000402012O009B0001000402012O00680701001204000300013O0006230002000E00010003000402012O000E0001001204000300014O009D000400043O001204000500013O0006230003001D07010005000402012O001D0701001204000400013O0012040005005C012O0012040006005D012O0006EC0005003707010006000402012O00370701001204000500013O0006230005003707010004000402012O003707012O006F000500234O00BF00050001000100122O0005005E015O0006000C3O00122O0007005F012O00122O00080060015O0006000800024O0005000500064O0006000C3O00122O00070061012O00122O00080062013O00860006000800022O003B0005000500062O0011000500133O001204000400023O001204000500023O00065C0004003E07010005000402012O003E070100120400050063012O00120400060064012O00068C0005005707010006000402012O005707010012840005005E013O00A30006000C3O00122O00070065012O00122O00080066015O0006000800024O0005000500064O0006000C3O00122O00070067012O00122O00080068015O0006000800024O0005000500062O002C01055O00122O0005005E015O0006000C3O00122O00070069012O00122O0008006A015O0006000800024O0005000500064O0006000C3O00122O0007006B012O00122O0008006C013O00860006000800022O003B0005000500062O0011000500243O001204000400133O001204000500133O00065C0004005E07010005000402012O005E0701001204000500833O0012040006006D012O0006EC0005002107010006000402012O00210701001204000200023O000402012O000E0001000402012O00210701000402012O000E0001000402012O001D0701000402012O000E0001000402012O00680701000402012O000B0001000402012O00680701000402012O000200012O0023012O00017O00033O0003053O005072696E7403383O00ED38B9FCC53DABF9C330FFC7CD2CB3FFCF35FFE2C32ABEE4C531B1B0CE27FFD5DC37BCBE8C0DAAE0DC31ADE4C93AFFF2D57E98FFC637ADF103043O0090AC5EDF00084O00667O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

