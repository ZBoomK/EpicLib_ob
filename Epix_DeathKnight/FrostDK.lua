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
				if (Enum <= 169) then
					if (Enum <= 84) then
						if (Enum <= 41) then
							if (Enum <= 20) then
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
										elseif (Enum <= 2) then
											do
												return Stk[Inst[2]];
											end
										elseif (Enum > 3) then
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
									elseif (Enum <= 6) then
										if (Enum == 5) then
											local A = Inst[2];
											Top = (A + Varargsz) - 1;
											for Idx = A, Top do
												local VA = Vararg[Idx - A];
												Stk[Idx] = VA;
											end
										elseif (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Upvalues[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 12) then
										Upvalues[Inst[3]] = Stk[Inst[2]];
									elseif (Enum == 13) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 17) then
									if (Enum <= 15) then
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
									elseif (Enum > 16) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 18) then
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
								elseif (Enum == 19) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 30) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum == 21) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 24) then
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
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 27) then
									if (Enum == 26) then
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
								elseif (Enum <= 28) then
									do
										return Stk[Inst[2]]();
									end
								elseif (Enum == 29) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 35) then
								if (Enum <= 32) then
									if (Enum > 31) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 33) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Enum > 34) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 38) then
								if (Enum <= 36) then
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
								elseif (Enum > 37) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 39) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 40) then
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
						elseif (Enum <= 62) then
							if (Enum <= 51) then
								if (Enum <= 46) then
									if (Enum <= 43) then
										if (Enum > 42) then
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
											Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
									elseif (Enum > 45) then
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
								elseif (Enum <= 48) then
									if (Enum > 47) then
										local B;
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 49) then
									VIP = Inst[3];
								elseif (Enum > 50) then
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
							elseif (Enum <= 56) then
								if (Enum <= 53) then
									if (Enum == 52) then
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
										A = Inst[2];
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
								elseif (Enum <= 54) then
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
								elseif (Enum > 55) then
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
								end
							elseif (Enum <= 59) then
								if (Enum <= 57) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 58) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 60) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 61) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 73) then
							if (Enum <= 67) then
								if (Enum <= 64) then
									if (Enum == 63) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 65) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								elseif (Enum > 66) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 70) then
								if (Enum <= 68) then
									if (Stk[Inst[2]] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 69) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 71) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 72) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 78) then
							if (Enum <= 75) then
								if (Enum > 74) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 76) then
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
							elseif (Enum > 77) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 81) then
							if (Enum <= 79) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 80) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
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
						elseif (Enum <= 82) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						elseif (Enum > 83) then
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
						if (Enum <= 105) then
							if (Enum <= 94) then
								if (Enum <= 89) then
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
									elseif (Enum == 88) then
										local A;
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
								elseif (Enum <= 91) then
									if (Enum > 90) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 92) then
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
									A = Inst[2];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 93) then
									local Edx;
									local Results;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
									Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								else
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 99) then
								if (Enum <= 96) then
									if (Enum > 95) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 98) then
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
							elseif (Enum <= 102) then
								if (Enum <= 100) then
									local Edx;
									local Results;
									local A;
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 101) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 103) then
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
							elseif (Enum == 104) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 115) then
							if (Enum <= 110) then
								if (Enum <= 107) then
									if (Enum == 106) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 108) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 109) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 112) then
								if (Enum > 111) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 113) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 114) then
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
						elseif (Enum <= 120) then
							if (Enum <= 117) then
								if (Enum == 116) then
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
							elseif (Enum <= 118) then
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
							elseif (Enum > 119) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 123) then
							if (Enum <= 121) then
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
							elseif (Enum == 122) then
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 124) then
							Stk[Inst[2]] = #Stk[Inst[3]];
						elseif (Enum == 125) then
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
					elseif (Enum <= 147) then
						if (Enum <= 136) then
							if (Enum <= 131) then
								if (Enum <= 128) then
									if (Enum > 127) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 129) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum > 130) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 133) then
								if (Enum == 132) then
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
							elseif (Enum <= 134) then
								local B;
								local A;
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 135) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 141) then
							if (Enum <= 138) then
								if (Enum > 137) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 139) then
								Stk[Inst[2]] = Stk[Inst[3]];
							elseif (Enum > 140) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 144) then
							if (Enum <= 142) then
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
							elseif (Enum == 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 145) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						elseif (Enum == 146) then
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
					elseif (Enum <= 158) then
						if (Enum <= 152) then
							if (Enum <= 149) then
								if (Enum > 148) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 151) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 155) then
							if (Enum <= 153) then
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
							elseif (Enum == 154) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							end
						elseif (Enum <= 156) then
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
						elseif (Enum > 157) then
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
						end
					elseif (Enum <= 163) then
						if (Enum <= 160) then
							if (Enum > 159) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 161) then
							local A = Inst[2];
							local Results = {Stk[A](Unpack(Stk, A + 1, Inst[3]))};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 162) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 166) then
						if (Enum <= 164) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 167) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 168) then
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
				elseif (Enum <= 254) then
					if (Enum <= 211) then
						if (Enum <= 190) then
							if (Enum <= 179) then
								if (Enum <= 174) then
									if (Enum <= 171) then
										if (Enum > 170) then
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
											Stk[Inst[2]] = {};
										else
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										end
									elseif (Enum <= 172) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum == 173) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 176) then
									if (Enum == 175) then
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
									elseif (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 177) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 178) then
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
							elseif (Enum <= 184) then
								if (Enum <= 181) then
									if (Enum > 180) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									end
								elseif (Enum <= 182) then
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
								elseif (Enum > 183) then
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
							elseif (Enum <= 187) then
								if (Enum <= 185) then
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
								elseif (Enum > 186) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								else
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 188) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 189) then
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
								Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 200) then
							if (Enum <= 195) then
								if (Enum <= 192) then
									if (Enum == 191) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 193) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 194) then
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
									do
										return Stk[Inst[2]];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return;
									end
								end
							elseif (Enum <= 197) then
								if (Enum > 196) then
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
							elseif (Enum <= 198) then
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
							elseif (Enum == 199) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 205) then
							if (Enum <= 202) then
								if (Enum == 201) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								else
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
								end
							elseif (Enum <= 203) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							elseif (Enum == 204) then
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
							else
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 208) then
							if (Enum <= 206) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 207) then
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
						elseif (Enum <= 209) then
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
						elseif (Enum > 210) then
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
						else
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						end
					elseif (Enum <= 232) then
						if (Enum <= 221) then
							if (Enum <= 216) then
								if (Enum <= 213) then
									if (Enum > 212) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum <= 214) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 215) then
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
									A = Inst[2];
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
							elseif (Enum <= 218) then
								if (Enum == 217) then
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
							elseif (Enum <= 219) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 220) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum <= 226) then
							if (Enum <= 223) then
								if (Enum > 222) then
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
							elseif (Enum <= 224) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 225) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 229) then
							if (Enum <= 227) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 228) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 230) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
					elseif (Enum <= 243) then
						if (Enum <= 237) then
							if (Enum <= 234) then
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
							elseif (Enum <= 235) then
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
							elseif (Enum > 236) then
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
							if (Enum <= 238) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
								local T;
								local Edx;
								local Results, Limit;
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
						elseif (Enum > 242) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 248) then
						if (Enum <= 245) then
							if (Enum > 244) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 246) then
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 247) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Top do
								Insert(T, Stk[Idx]);
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
					elseif (Enum <= 251) then
						if (Enum <= 249) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 250) then
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
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 252) then
						local B;
						local A;
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						Stk[Inst[2]] = Inst[3];
					elseif (Enum > 253) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 297) then
					if (Enum <= 275) then
						if (Enum <= 264) then
							if (Enum <= 259) then
								if (Enum <= 256) then
									if (Enum > 255) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 257) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 258) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 261) then
								if (Enum > 260) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 263) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 269) then
							if (Enum <= 266) then
								if (Enum > 265) then
									local A = Inst[2];
									Stk[A] = Stk[A]();
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
							elseif (Enum <= 267) then
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
							elseif (Enum == 268) then
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
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 272) then
							if (Enum <= 270) then
								Stk[Inst[2]]();
							elseif (Enum == 271) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 274) then
							Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
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
					elseif (Enum <= 286) then
						if (Enum <= 280) then
							if (Enum <= 277) then
								if (Enum == 276) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 278) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
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
							elseif (Enum == 279) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 283) then
							if (Enum <= 281) then
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
							elseif (Enum == 282) then
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
						elseif (Enum <= 284) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 285) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 291) then
						if (Enum <= 288) then
							if (Enum > 287) then
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
						elseif (Enum <= 289) then
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 290) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 294) then
						if (Enum <= 292) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						elseif (Enum == 293) then
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
					elseif (Enum <= 295) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 296) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 318) then
					if (Enum <= 307) then
						if (Enum <= 302) then
							if (Enum <= 299) then
								if (Enum > 298) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 300) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 301) then
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 304) then
							if (Enum > 303) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 305) then
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
						elseif (Enum == 306) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = #Stk[Inst[3]];
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
					elseif (Enum <= 312) then
						if (Enum <= 309) then
							if (Enum == 308) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 310) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
						elseif (Enum > 311) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 315) then
						if (Enum <= 313) then
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
						elseif (Enum == 314) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Stk[Inst[2]] ~= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 316) then
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
					elseif (Enum > 317) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
						A = Inst[2];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						A = Inst[2];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Upvalues[Inst[3]] = Stk[Inst[2]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						VIP = Inst[3];
					end
				elseif (Enum <= 329) then
					if (Enum <= 323) then
						if (Enum <= 320) then
							if (Enum > 319) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 321) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 322) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 326) then
						if (Enum <= 324) then
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
								if (Mvm[1] == 139) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						elseif (Enum > 325) then
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
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 327) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					elseif (Enum > 328) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 334) then
					if (Enum <= 331) then
						if (Enum == 330) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local B;
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
							A = Inst[2];
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
					elseif (Enum <= 332) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 333) then
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
					elseif (Inst[2] > Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 337) then
					if (Enum <= 335) then
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
					elseif (Enum > 336) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Stk[Inst[2]] < Inst[4]) then
						VIP = Inst[3];
					else
						VIP = VIP + 1;
					end
				elseif (Enum <= 338) then
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
				elseif (Enum > 339) then
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD99FC21FC5CBF02BEFBCCF0AEEE5C92AF5AFE3359FCFCE2403083O007EB1A3BB4586DBA7031C3O0050E8855D8488D974EC846EB5A5DB7DECB363A9A3CF61DCA70BB7B9DD03073O00BC1598EC25DBCC002E3O00121B012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004313O000A0001001281000300063O00204E010400030007001281000500083O00204E010500050009001281000600083O00204E01060006000A00064401073O000100062O008B3O00064O008B8O008B3O00044O008B3O00014O008B3O00024O008B3O00053O00204E01080003000B00204E01090003000C2O0029000A5O001281000B000D3O000644010C0001000100022O008B3O000A4O008B3O000B4O008B000D00073O00122F000E000E3O00122F000F000F4O0065000D000F0002000644010E0002000100032O008B3O00074O008B3O00094O008B3O00084O000F000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001800025O00122O000300016O00045O00122O000500013O00042O0003002100012O003001076O0043010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0030010C00034O003C010D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00ED000C6O00E1000A3O00020020CB000A000A00022O00370109000A4O004100073O00010004F00003000500012O0030010300054O008B000400024O007B000300044O00C900036O0053012O00017O00043O00028O00026O00F03F025O002OA040025O00208A4001263O00122F000200014O0036010300043O00261400020007000100010004313O0007000100122F000300014O0036010400043O00122F000200023O00261400020002000100020004313O0002000100122F000500013O000E060001000A000100050004313O000A00010026140003001A000100010004313O001A00012O003001066O00AA000400063O00062C0104001400013O0004313O00140001002E2101030007000100040004313O001900012O0030010600014O008B00076O000500086O00D500066O00C900065O00122F000300023O000E0600020009000100030004313O000900012O008B000600044O000500076O00D500066O00C900065O0004313O000900010004313O000A00010004313O000900010004313O002500010004313O000200012O0053012O00017O007A3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00CF47A24AF003043O00269C37C7030A3O008568703C1A47EA46A47103083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C2O033O008B53DD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003073O009FCCDA070D25AF03063O004BDCA3B76A6203083O0027AC8E25C00DB48E03053O00B962DAEB572O033O00C5292A03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D03043O000EC1517E03083O00876CAE3E121E179303043O006D6174682O033O00BBE02403083O00A7D6894AAB78CE532O033O008AF22103063O00C7EB90523D982O033O000A17A103043O004B6776D903043O00E455630003063O007EA7341074D903053O007461626C6503063O00C1203385A60D03073O009CA84E40E0D47903073O0047657454696D6503083O0073747273706C697403143O00476574496E76656E746F72794974656D4C696E6B028O00030B3O00C307FBDDEF29F4C0E00AEE03043O00A987629A03053O00ED652B47E903073O00A8AB1744349D53030B3O00D074F4B92D0689FD76FDB903073O00E7941195CD454D03053O00A6B5C8E84303063O009FE0C7A79B37030B3O00D3F63DC6FFD832DBF0FB2803043O00B297935C03053O00AAEF43210603073O001AEC9D2C52722C03113O000B22D25E3E26D4491A3BCF41262BF7543203043O003B4A4EB503023O00494403073O0006DE2O57BC2BC203053O00D345B12O3A03083O0092F37CE7F0C4B9E003063O00ABD785199589030E3O00C6C926F2EA22F54CE6FB26F5FD3D03083O002281A8529A8F509C030B3O004973417661696C61626C6503093O00A0A436194E5C8696A603073O00E9E5D2536B282E025O00804D40026O003940025O00804640024O0080B3C540030A3O00E64A3DC309F54330DA0003053O0065A12252B603103O005265676973746572466F724576656E7403143O00D82178C7FED0BD1CCD2A7CD0E4C7AC0FCA217CDA03083O004E886D399EBB82E2030E3O000684AEDEF6068BA8DAFB1B93AED603053O00BA55D4EB9203143O00EEA437CC17CB7CFDB226DB15C267EBAF29CA18CC03073O0038A2E1769E598E030A3O007D16D0A73BC05504D4AA03063O00B83C65A0CF42031B3O0012836FA871A36FAC399B64B5309679FC79AB72A834906EA921963503043O00DC51E21C03063O0003D983E2EFD503063O00A773B5E29B8A026O003040034O0003063O00F22EE6457E6303073O00A68242873C1B11026O00314003013O003A03043O001719992503053O0050242AAE1503043O001D43602A03043O001A2E705703043O00EA70FD2C03083O00D4D943CB142ODF2503043O00E9DEFE8A03043O00B2DAEDC803043O00E0E7B28303043O00B0D6D58603043O00A2FFE28703073O003994CDD6B4C83603123O004973457175692O7065644974656D5479706503083O0026EA3A795E13F33103053O0016729D5554030C3O0047657445717569706D656E74026O002A40026O002C4003183O00FDCB3CC23FFFD838CA2FE4D730DE34F9D83ED33BE3C038DF03053O007AAD877D9B03063O0053657441504C025O00606F400070023O0054000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122B000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122B0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122B000B000E3O00122O000C000F6O000A000C00024O000A0004000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00122B000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122B000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F4O00105O00122B0011001A3O00122O0012001B6O0010001200024O000F000F00104O00105O00122O0011001C3O00122O0012001D6O0010001200024O000F000F00104O00105O00122B0011001E3O00122O0012001F6O0010001200024O0010000400104O00115O00122O001200203O00122O001300216O0011001300024O0010001000114O00115O00122F001200223O00122F001300234O00580011001300024O00100010001100122O001100246O00125O00122O001300253O00122O001400266O0012001400024O00110011001200122O001200246O00135O00122F001400273O00122F001500284O00650013001500022O00AA001200120013001281001300244O003001145O00122F001500293O0012150116002A6O0014001600024O0013001300144O00148O00158O00168O00175O00122O0018002B3O00122O0019002C6O0017001900022O00AA00170004001700129D0018002D6O00195O00122O001A002E3O00122O001B002F6O0019001B00024O00180018001900122O001900303O00122O001A00313O00122O001B00326O001C001F3O00122F002000334O0034012100213O00122O002200336O002300263O00122O002700333O00122O002800336O002900313O00122O003200336O003300383O00064401393O0001001C2O008B3O00214O0030017O008B3O00224O008B3O00234O008B3O00244O008B3O00324O008B3O00334O008B3O00344O008B3O00354O008B3O00364O008B3O00374O008B3O00384O008B3O00304O008B3O00314O008B3O002E4O008B3O002F4O008B3O002C4O008B3O002D4O008B3O002A4O008B3O002B4O008B3O00254O008B3O00274O008B3O00284O008B3O00294O008B3O001F4O008B3O00204O008B3O001C4O008B3O001E4O00EE003A5O00122O003B00343O00122O003C00356O003A003C00024O003A000A003A4O003B5O00122O003C00363O00122O003D00376O003B003D00024O003A003A003B2O00EE003B5O00122O003C00383O00122O003D00396O003B003D00024O003B000C003B4O003C5O00122O003D003A3O00122O003E003B6O003C003E00024O003B003B003C2O00EE003C5O00122O003D003C3O00122O003E003D6O003C003E00024O003C000E003C4O003D5O00122O003E003E3O00122O003F003F6O003D003F00024O003C003C003D2O0029003D6O0030013E5O00122F003F00403O0012EF004000416O003E004000024O003E003B003E00202O003E003E00424O003E003F6O003D3O00012O0030013E5O0012D7003F00433O00122O004000446O003E004000024O003E0004003E4O003F5O00122O004000453O00122O004100466O003F004100024O003E003E003F4O003F00416O00425O00122O004300473O00122O004400486O0042004400024O0042003A004200202O0042004200494O00420002000200062O004200E0000100010004313O00E000012O003001425O0012CA0043004A3O00122O0044004B6O0042004400024O0042003A004200202O0042004200494O004200020002000EDC004C00E5000100320004313O00E5000100122F0043004D3O000663004300E6000100010004313O00E6000100122F0043004E4O0036014400523O0012860053004F3O00122O0054004F6O00555O00122O005600503O00122O005700516O0055005700024O0055000400554O0056005C3O00202O005D00040052000644015F0001000100022O008B3O00534O008B3O00544O004000605O00122O006100533O00122O006200546O006000626O005D3O000100202O005D00040052000644015F0002000100032O008B3O00424O008B3O003A4O0030017O00AB00605O00122O006100553O00122O006200566O0060006200024O00615O00122O006200573O00122O006300586O006100636O005D3O00014O005D00014O0029005E00034O0095005F5O00122O006000593O00122O0061005A6O005F006100024O005F003A005F4O00605O00122O0061005B3O00122O0062005C6O006000620002000212016100034O00CD005E000300012O00CD005D000100012O008B005E001B4O0010005F5O00122O0060005D3O00122O0061005E6O005F0061000200122O0060005F6O005E0060000200062O005E001E2O0100010004313O001E2O0100122F005E00604O008B005F001B4O001000605O00122O006100613O00122O006200626O00600062000200122O006100636O005F0061000200062O005F00282O0100010004313O00282O0100122F005F00604O008B0060001A3O001264006100646O0062005E6O0060006200624O0063001A3O00122O006400646O0065005F6O0063006500654O00665O00122O006700653O00122O006800666O00660068000200062O0062003D2O0100660004313O003D2O012O003001665O00122F006700673O00122F006800684O00650066006800020006290165003D2O0100660004313O003D2O012O002B01666O0052006600014O002F01675O00122O006800693O00122O0069006A6O00670069000200062O0062004B2O0100670004313O004B2O012O003001675O00122F0068006B3O00122F0069006C4O00650067006900020006290165004B2O0100670004313O004B2O012O002B01676O0052006700014O002F01685O00122O0069006D3O00122O006A006E6O0068006A000200062O006200592O0100680004313O00592O012O003001685O00122F0069006F3O00122F006A00704O00650068006A0002000629016500592O0100680004313O00592O012O002B01686O0052006800013O00124B016900716O006A5O00122O006B00723O00122O006C00736O006A006C6O00693O000200202O006A000800744O006A0002000200202O006B006A007500062O006B006A2O013O0004313O006A2O012O008B006B000C3O00204E016C006A00752O0021006B00020002000663006B006D2O0100010004313O006D2O012O008B006B000C3O00122F006C00334O0021006B0002000200204E016C006A007600062C016C00752O013O0004313O00752O012O008B006C000C3O00204E016D006A00762O0021006C00020002000663006C00782O0100010004313O00782O012O008B006C000C3O00122F006D00334O0021006C0002000200209E006D00040052000644016F0004000100102O008B3O006B4O008B3O006A4O008B3O000C4O008B3O006C4O008B3O00694O0030017O008B3O00084O008B3O00664O008B3O00624O008B3O00654O008B3O00674O008B3O005E4O008B3O001B4O008B3O005F4O008B3O00644O008B3O001A4O002301705O00122O007100773O00122O007200786O007000726O006D3O0001000644016D0005000100042O008B3O00084O008B3O00274O008B3O00284O008B3O003A3O000644016E0006000100052O0030012O00014O008B3O003A4O0030012O00024O008B3O000F4O008B3O00663O000644016F0007000100012O008B3O003A3O00064401700008000100062O008B3O003A4O0030017O008B3O00094O008B3O00174O008B3O00434O008B3O00323O00064401710009000100032O008B3O003E4O008B3O003D4O008B3O00163O0006440172000A0001000C2O008B3O003A4O0030017O008B3O00524O008B3O004C4O008B3O00174O008B3O00094O008B3O00084O008B3O004E4O008B3O00364O008B3O00164O008B3O00304O008B3O00343O0006440173000B000100112O008B3O003A4O0030017O008B3O00084O008B3O003E4O008B3O005B4O008B3O006E4O008B3O00094O008B3O00174O008B3O003C4O008B3O002C4O008B3O00304O008B3O00424O008B3O004A4O008B3O004B4O008B3O000F4O008B3O00364O008B3O004E3O0006440174000C0001000B2O008B3O003A4O0030017O008B3O00084O008B3O00174O008B3O00364O008B3O00304O008B3O00094O008B3O004E4O008B3O003E4O008B3O005B4O008B3O006E3O0006440175000D0001000B2O008B3O003A4O0030017O008B3O00544O008B3O00084O008B3O00694O008B3O00174O008B3O00094O0030012O00014O008B3O000F4O0030012O00024O008B3O00673O0006440176000E000100152O008B3O003A4O0030017O008B3O00084O008B3O004A4O008B3O00544O008B3O00584O008B3O00174O008B3O003C4O008B3O002C4O008B3O00494O008B3O00384O008B3O00094O008B3O00334O008B3O002D4O008B3O00044O008B3O00434O008B3O00354O008B3O00694O008B3O00664O008B3O00554O008B3O002E3O0006440177000F0001000E2O008B3O00294O008B3O00164O008B3O003A4O0030017O008B3O00084O008B3O00174O008B3O002A4O008B3O002B4O008B3O00094O008B3O00584O008B3O00424O008B3O004A4O008B3O004C4O008B3O00503O00064401780010000100112O008B3O003A4O0030017O008B3O00084O008B3O00094O008B3O004C4O008B3O00174O008B3O00664O008B3O00574O008B3O00524O008B3O00584O008B3O00344O008B3O003E4O008B3O005B4O008B3O006E4O008B3O00164O008B3O00304O008B3O004E3O00064401790011000100072O008B3O003A4O0030017O008B3O00084O008B3O00174O008B3O00304O008B3O00094O008B3O004D3O000644017A0012000100122O008B3O003A4O0030017O008B3O004B4O008B3O00174O008B3O00094O008B3O00524O008B3O00664O008B3O00084O008B3O00514O008B3O00364O008B3O00424O008B3O004A4O008B3O00694O008B3O00344O008B3O004E4O008B3O004C4O008B3O00164O008B3O00303O000644017B0013000100122O008B3O004B4O008B3O00084O008B3O003A4O0030017O008B3O004C4O008B3O004D4O008B3O00574O008B3O00514O008B3O004F4O008B3O00524O008B3O00504O008B3O004E4O008B3O00584O0030012O00014O0030012O00024O008B3O004A4O008B3O00154O008B3O00493O000644017C0014000100222O008B3O00154O0030017O008B3O00164O008B3O00394O008B3O00144O008B3O003E4O008B3O00084O008B3O00534O008B3O00044O008B3O00544O008B3O005B4O008B3O00704O008B3O003A4O008B3O003F4O008B3O00174O008B3O00094O008B3O007B4O008B3O00774O008B3O00764O008B3O00714O008B3O00794O008B3O00664O0030012O00014O0030012O00024O008B3O00754O008B3O00744O008B3O00734O008B3O00784O008B3O00584O008B3O00724O008B3O007A4O008B3O006D4O008B3O00564O008B3O00573O000644017D0015000100032O008B3O00394O008B3O00044O0030016O002085007E0004007900122O007F007A6O0080007C6O0081007D6O007E008100016O00013O00163O009A3O00028O00025O0072A240025O009C9040026O00F03F025O00F89B40025O002AA940027O0040025O006BB140025O0016AE40030C3O004570696353652O74696E677303083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD709018025O0032A740025O00109D4003083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B026O00144003083O00682BA042445529A703053O002D3B4ED43603103O00317BB0AA843DA2E212668699852BA3E403083O00907036E3EBE64ECD03083O00802D1BE8D955B43B03063O003BD3486F9CB003153O006C95E62C5A8FCC2B7D8EED295C86E4225D86C40E6A03043O004D2EE783025O0096A040025O00804340026O00184003083O008951A254B35AB15303043O0020DA34D6030E3O0068053EBBE5835148471C348FD29403083O003A2E7751C891D02503083O00188924B8A0B3313803073O00564BEC50CCC9DD03113O0054537896EA9C6B537A96D89E605850A6DA03063O00EB122117E59E03083O0063BFD5AF59B4C6A803043O00DB30DAA1030F3O00CC7E6E47F449D7ED7F684CC968C3C003073O008084111C29BB2F03083O003237122E540F351503053O003D6152665A03163O008437BB44D35F2O1BA127A87BD5520D0CA22DAE6CE47303083O0069CC4ECB2BA7377E03083O0096AF370A1A0AC04203083O0031C5CA437E7364A703103O000752D325814471317DCD26934279147F03073O003E573BBF49E036026O001040025O00A8A040025O0020694003083O00EC1AE00833D118E703053O005ABF7F947C030D3O004A862D1E798B3D387E8109345C03043O007718E74E03083O00B128B15ED54E169103073O0071E24DC52ABC2003113O001E1FE7B4381AF1973525C4BA351AFDBB3D03043O00D55A7694025O00F2B040025O007DB14003083O0099CD19DFCCADD0F203083O0081CAA86DABA5C3B703123O00115934CAD712EF215136D4EE15E5367F14FC03073O0086423857B8BE7403083O000F341DAF10E52O2603083O00555C5169DB798B4103103O00D0BA5E415ACDF8B64A4053D9FB94736103063O00BF9DD330251C025O00109B40025O00B2AB40025O00949140026O005040026O000840025O001EA940025O004AAF4003083O0032E25C4B7A0FE05B03053O00136187283F03103O008A59322F2710A058173E2C30B77B101F03063O0051CE3C535B4F03083O007DAEC46626CD4AB703083O00C42ECBB0124FA32D03143O009D2F6E1133FEFD8A37701B13FEEEA82D703907DF03073O008FD8421E7E449B03083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC03113O001DA19545CE787F35ACB244E675741B8CA503073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B03103O009CD7344590D82745BEE32F42B8FE036803043O002CDDB940025O00DEA240025O00C88440025O00049140025O003AA14003083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O00D5C0D929EFCBCA2E03043O005D86A5AD03103O008BE1C4E63FCFA6768DE6D3CB31CB9A4E03083O001EDE92A1A25AAED2025O00C4A040025O00A0834003083O00D64B641EEC40771903043O006A852E10030F3O006D3376D85B52531366FF594F4A084303063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A9203143O006C454EDC58B5A62663794DFB708894024F5347E403083O006B39362B9D15E6E7025O00AEAA40025O0061B140025O00949B40025O00D6B040025O00508C40026O006940026O00A840025O00AAA04003083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E03083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE297025O00408C40025O00E09540025O00708640025O002EAE4003083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D00FB012O00122F3O00014O00362O0100013O00263B012O0006000100010004313O00060001002E7A00020002000100030004313O0002000100122F000100013O00263B2O01000B000100040004313O000B0001002E7A00060054000100050004313O0054000100122F000200013O00261400020010000100070004313O0010000100122F000100073O0004313O00540001002E7A00090030000100080004313O0030000100261400020030000100010004313O003000010012810003000A4O00EE000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300042O000C00035O00125F0003000A6O000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600024O00030003000400062O0003002E000100010004313O002E000100122F000300014O000C000300023O00122F000200043O00263B01020034000100040004313O00340001002E7A0013000C000100140004313O000C00010012810003000A4O00FE000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000400013O00122O000500173O00122O000600186O0004000600024O00030003000400062O00030042000100010004313O0042000100122F000300014O000C000300033O00125F0003000A6O000400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400062O00030051000100010004313O0051000100122F000300014O000C000300043O00122F000200073O0004313O000C0001002614000100970001001D0004313O0097000100122F000200013O00261400020075000100010004313O007500010012810003000A4O00FE000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000400013O00122O000500203O00122O000600216O0004000600024O00030003000400062O00030067000100010004313O0067000100122F000300014O000C000300053O00124F0103000A6O000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000300063O00122O000200043O00263B01020079000100070004313O00790001002E2101260004000100270004313O007B000100122F000100283O0004313O0097000100261400020057000100040004313O005700010012810003000A4O00A0000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000300073O00122O0003000A6O000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300044O000400013O00122O0005002F3O00122O000600306O0004000600024O0003000300044O000300083O00122O000200073O0004313O00570001000E06002800BE000100010004313O00BE00010012810002000A4O001F000300013O00122O000400313O00122O000500326O0003000500024O0002000200034O000300013O00122O000400333O00122O000500346O0003000500024O0002000200034O000200093O00122O0002000A6O000300013O00122O000400353O00122O000500366O0003000500024O0002000200034O000300013O00122O000400373O00122O000500386O0003000500024O0002000200034O0002000A3O00122O0002000A6O000300013O00122O000400393O00122O0005003A6O0003000500024O0002000200034O000300013O00122O0004003B3O00122O0005003C6O0003000500024O0002000200034O0002000B3O00044O00FA2O0100263B2O0100C20001003D0004313O00C20001002E7A003E00022O01003F0004313O00022O0100122F000200013O002614000200DE000100040004313O00DE00010012810003000A4O00A0000400013O00122O000500403O00122O000600416O0004000600024O0003000300044O000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O0003000C3O00122O0003000A6O000400013O00122O000500443O00122O000600456O0004000600024O0003000300044O000400013O00122O000500463O00122O000600476O0004000600024O0003000300044O0003000D3O00122O000200073O00263B010200E2000100010004313O00E20001002E7A004900FB000100480004313O00FB00010012810003000A4O00A0000400013O00122O0005004A3O00122O0006004B6O0004000600024O0003000300044O000400013O00122O0005004C3O00122O0006004D6O0004000600024O0003000300044O0003000E3O00122O0003000A6O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O000400013O00122O000500503O00122O000600516O0004000600024O0003000300044O0003000F3O00122O000200043O00263B010200FF000100070004313O00FF0001002E7A005300C3000100520004313O00C3000100122F0001001D3O0004313O00022O010004313O00C30001002E7A005500442O0100540004313O00442O01002614000100442O0100560004313O00442O0100122F000200013O0026140002000B2O0100070004313O000B2O0100122F0001003D3O0004313O00442O0100263B0102000F2O0100040004313O000F2O01002EB0005800282O0100570004313O00282O010012810003000A4O00A0000400013O00122O000500593O00122O0006005A6O0004000600024O0003000300044O000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000300103O00122O0003000A6O000400013O00122O0005005D3O00122O0006005E6O0004000600024O0003000300044O000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300044O000300113O00122O000200073O002614000200072O0100010004313O00072O010012810003000A4O00A0000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O000400013O00122O000500633O00122O000600646O0004000600024O0003000300044O000300123O00122O0003000A6O000400013O00122O000500653O00122O000600666O0004000600024O0003000300044O000400013O00122O000500673O00122O000600686O0004000600024O0003000300044O000300133O00122O000200043O0004313O00072O010026140001009B2O0100070004313O009B2O0100122F000200013O002EB0006A004D2O0100690004313O004D2O010026140002004D2O0100070004313O004D2O0100122F000100563O0004313O009B2O01000E89000100512O0100020004313O00512O01002EB0006C00702O01006B0004313O00702O010012810003000A4O00FE000400013O00122O0005006D3O00122O0006006E6O0004000600024O0003000300044O000400013O00122O0005006F3O00122O000600706O0004000600024O00030003000400062O0003005F2O0100010004313O005F2O0100122F000300014O000C000300143O00125F0003000A6O000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O00030003000400062O0003006E2O0100010004313O006E2O0100122F000300014O000C000300153O00122F000200043O002614000200472O0100040004313O00472O0100122F000300013O00263B010300772O0100010004313O00772O01002E7A007500932O0100760004313O00932O010012810004000A4O00FE000500013O00122O000600773O00122O000700786O0005000700024O0004000400054O000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500062O000400852O0100010004313O00852O0100122F000400014O000C000400163O00124F0104000A6O000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400054O000500013O00122O0006007D3O00122O0007007E6O0005000700024O0004000400054O000400173O00122O000300043O000E89000400972O0100030004313O00972O01002E7A008000732O01007F0004313O00732O0100122F000200073O0004313O00472O010004313O00732O010004313O00472O0100263B2O01009F2O0100010004313O009F2O01002EB000820007000100810004313O0007000100122F000200014O0036010300033O002EB0008400A12O0100830004313O00A12O01000E06000100A12O0100020004313O00A12O0100122F000300013O00263B010300AA2O0100040004313O00AA2O01002E7A008500C92O0100860004313O00C92O010012810004000A4O00FE000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000500013O00122O000600893O00122O0007008A6O0005000700024O00040004000500062O000400B82O0100010004313O00B82O0100122F000400014O000C000400183O00125F0004000A6O000500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400054O000500013O00122O0006008D3O00122O0007008E6O0005000700024O00040004000500062O000400C72O0100010004313O00C72O0100122F000400014O000C000400193O00122F000300073O002614000300CD2O0100070004313O00CD2O0100122F000100043O0004313O00070001002614000300A62O0100010004313O00A62O0100122F000400013O002E7A008F00D62O0100900004313O00D62O01002614000400D62O0100040004313O00D62O0100122F000300043O0004313O00A62O01000E89000100DA2O0100040004313O00DA2O01002EB0009200D02O0100910004313O00D02O010012810005000A4O00A0000600013O00122O000700933O00122O000800946O0006000800024O0005000500064O000600013O00122O000700953O00122O000800966O0006000800024O0005000500064O0005001A3O00122O0005000A6O000600013O00122O000700973O00122O000800986O0006000800024O0005000500064O000600013O00122O000700993O00122O0008009A6O0006000800024O0005000500064O0005001B3O00122O000400043O0004313O00D02O010004313O00A62O010004313O000700010004313O00A12O010004313O000700010004313O00FA2O010004313O000200012O0053012O00017O00073O00028O00025O0066A340025O005EA140026O00F03F025O00F49540025O00E88940024O0080B3C540001D3O00122F3O00014O00362O0100023O00263B012O0006000100010004313O00060001002E2101020005000100030004313O0009000100122F000100014O0036010200023O00122F3O00043O002E7A00060002000100050004313O000200010026143O0002000100040004313O000200010026140001000D000100010004313O000D000100122F000200013O00261400020010000100010004313O0010000100122F000300074O000C00035O00122F000300074O000C000300013O0004313O001C00010004313O001000010004313O001C00010004313O000D00010004313O001C00010004313O000200012O0053012O00017O00053O00030E3O00193EEDF93B2DF0FF390CEDFE2C3203043O00915E5F99030B3O004973417661696C61626C6503093O00D8DB11C748A5F2DE0003063O00D79DAD74B52E00144O00973O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O0012000100010004313O001200012O0030012O00014O0050000100023O00122O000200043O00122O000300056O0001000300028O000100206O00036O000200022O000C8O0053012O00019O003O00034O00523O00014O00023O00024O0053012O00017O00323O00028O00025O001AAA40025O002EAE40026O00F03F026O00AE40025O00408F40026O001040025O00C8A440025O00D09D40026O002A40026O002C40026O00084003123O004973457175692O7065644974656D5479706503083O000516DDF9D0D1B33503073O00DD5161B2D498B0030C3O0047657445717569706D656E74027O0040025O00E0A140025O009EA340025O0010AC40025O0039B140025O00E9B240025O005EA74003043O00600105A603053O0099532O329603043O000E25244C03073O002D3D16137C13CB03043O0092415BAD03073O00D9A1726D95621003043O0041736E2403063O00147240581CDC025O005EA640025O00D8A340025O00E2A740025O00D6B240025O0050B240025O0044974003063O00D4C712DD58E403073O00C8A4AB73A43D96026O003040034O0003063O00AEF8025C86AC03053O00E3DE946325026O003140026O008A40025O00A2B24003013O003A025O00389E40025O00ACB140025O0074A44000E43O00122F3O00014O00362O0100023O002EB000020009000100030004313O000900010026143O0009000100010004313O0009000100122F000100014O0036010200023O00122F3O00043O002EB000060002000100050004313O000200010026143O0002000100040004313O000200010026140001000D000100010004313O000D000100122F000200013O00263B01020014000100070004313O00140001002EB000080031000100090004313O003100012O0030010300013O00204E01030003000A00062C0103001E00013O0004313O001E00012O0030010300024O0030010400013O00204E01040004000A2O002100030002000200066300030021000100010004313O002100012O0030010300023O00122F000400014O00210003000200022O000C00036O0030010300013O00204E01030003000B00062C0103002C00013O0004313O002C00012O0030010300024O0030010400013O00204E01040004000B2O00210003000200020006630003002F000100010004313O002F00012O0030010300023O00122F000400014O00210003000200022O000C000300033O0004313O00E30001002614000200470001000C0004313O0047000100122F000300013O00261400030038000100040004313O0038000100122F000200073O0004313O0047000100261400030034000100010004313O003400010012810004000D4O00FF000500053O00122O0006000E3O00122O0007000F6O000500076O00043O00024O000400046O000400063O00202O0004000400104O0004000200024O000400013O00122F000300043O0004313O0034000100263B0102004B000100110004313O004B0001002EB000130084000100120004313O0084000100122F000300013O00263B01030050000100040004313O00500001002E7A00150052000100140004313O0052000100122F0002000C3O0004313O008400010026140003004C000100010004313O004C000100122F000400013O00263B01040059000100010004313O00590001002EB00016007C000100170004313O007C00012O0030010500084O002F010600053O00122O000700183O00122O000800196O00060008000200062O00050068000100060004313O006800012O0030010500094O002F010600053O00122O0007001A3O00122O0008001B6O00060008000200062O00050068000100060004313O006800012O002B01056O0052000500014O000C000500074O0030010500084O002F010600053O00122O0007001C3O00122O0008001D6O00060008000200062O00050079000100060004313O007900012O0030010500094O002F010600053O00122O0007001E3O00122O0008001F6O00060008000200062O00050079000100060004313O007900012O002B01056O0052000500014O000C0005000A3O00122F000400043O00263B01040080000100040004313O00800001002E7A00200055000100210004313O0055000100122F000300043O0004313O004C00010004313O005500010004313O004C0001002614000200B7000100010004313O00B7000100122F000300014O0036010400043O00261400030088000100010004313O0088000100122F000400013O002E7A002200B0000100230004313O00B00001002614000400B0000100010004313O00B0000100122F000500013O000E8900010094000100050004313O00940001002EB0002400AB000100250004313O00AB00012O00300106000C4O0010000700053O00122O000800263O00122O000900276O00070009000200122O000800286O00060008000200062O0006009E000100010004313O009E000100122F000600294O000C0006000B6O0006000C6O000700053O00122O0008002A3O00122O0009002B6O00070009000200122O0008002C6O00060008000200062O000600A9000100010004313O00A9000100122F000600294O000C0006000D3O00122F000500043O00261400050090000100040004313O0090000100122F000400043O0004313O00B000010004313O00900001000E060004008B000100040004313O008B000100122F000200043O0004313O00B700010004313O008B00010004313O00B700010004313O0088000100263B010200BB000100040004313O00BB0001002E7A002E00100001002D0004313O0010000100122F000300013O002614000300D7000100010004313O00D7000100122F000400013O002614000400D0000100010004313O00D000012O00300105000F3O00125E0006002F6O0007000B6O0005000700074O000700086O0006000E6O0005000E6O0005000F3O00122O0006002F6O0007000D6O0005000700074O000700096O0006000E6O0005000E3O00122O000400043O002E21013000EFFF2O00300004313O00BF0001002614000400BF000100040004313O00BF000100122F000300043O0004313O00D700010004313O00BF000100263B010300DB000100040004313O00DB0001002E7A003100BC000100320004313O00BC000100122F000200113O0004313O001000010004313O00BC00010004313O001000010004313O00E300010004313O000D00010004313O00E300010004313O000200012O0053012O00017O00033O0003103O004865616C746850657263656E7461676503063O0042752O665570030F3O004465617468537472696B6542752O6600164O00F67O00206O00016O000200024O000100013O00064O0013000100010004313O001300012O0030016O00209E5O00012O00213O000200022O00302O0100023O00060A3O0012000100010004313O001200012O0030016O00201D5O00024O000200033O00202O0002000200036O0002000200044O001400012O002B017O00523O00014O00023O00024O0053012O00017O00043O00030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66026O00F03F030D3O00446562752O6652656D61696E7301254O00DF00015O00202O00023O00014O000400013O00202O0004000400024O00020004000200122O000300036O0001000300024O000200023O00202O00033O00014O000500013O00204E0105000500022O00FC00030005000200122O000400036O0002000400024O0001000100024O00025O00202O00033O00044O000500013O00202O0005000500024O00030005000200122O000400034O00650002000400022O00BE000300023O00202O00043O00044O000600013O00202O0006000600024O00040006000200122O000500036O0003000500024O0002000200034O0001000100024O000200034O0030010300044O00210002000200022O009B0001000100022O0002000100024O0053012O00017O00023O00030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O6601063O0020C300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O001F3O00028O00025O0046B040025O0049B040026O00F03F025O001AAD40025O0080554003113O001FCB52E454DC8521CB4CF871C68E39CB4D03073O00E04DAE3F8B26AF03073O004973526561647903093O004973496E52616E6765026O00204003113O0052656D6F7273656C652O7357696E746572025O00D6B240025O00206340031E3O009644552196525D2281524B119348563A8153183E96445B218943593AC41503043O004EE42138025O00609C40025O00EAA140025O000EA640025O001AA940025O00804D40026O003940025O00804640030C3O00ACCE17B5363FCFA6CD01AA2B03073O00A8E4A160D95F51025O005EB240025O00AAA040030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E676503193O00D3DE39502659DCEE2C502E44CF913E4E2A54D4DC2C5D3B178903063O0037BBB14E3C4F006E3O00122F3O00014O00362O0100013O00263B012O0006000100010004313O00060001002E7A00030002000100020004313O0002000100122F000100013O00263B2O01000B000100040004313O000B0001002EB000050029000100060004313O002900012O003001026O006A000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002006D00013O0004313O006D00012O0030010200023O00209E00020002000A00122F0004000B4O006500020004000200062C0102006D00013O0004313O006D00012O0030010200034O003001035O00204E01030003000C2O002100020002000200066300020023000100010004313O00230001002E7A000D006D0001000E0004313O006D00012O0030010200013O0012220103000F3O00122O000400106O000200046O00025O00044O006D000100261400010007000100010004313O0007000100122F000200014O0036010300033O0026140002002D000100010004313O002D000100122F000300013O000E8900040034000100030004313O00340001002EB000120036000100110004313O0036000100122F000100043O0004313O0007000100263B0103003A000100010004313O003A0001002E7A00140030000100130004313O003000012O0030010400053O000EDC00150040000100040004313O0040000100122F000400163O00066300040041000100010004313O0041000100122F000400174O000C000400044O00AE00048O000500013O00122O000600183O00122O000700196O0005000700024O00040004000500202O0004000400094O00040002000200062O0004006600013O0004313O006600012O0030010400023O00209E00040004000A00122F0006000B4O006500040006000200066300040066000100010004313O00660001002EB0001B00660001001A0004313O006600012O0030010400034O007400055O00202O00050005001C4O000600076O000800023O00202O00080008001D4O000A5O00202O000A000A001C4O0008000A00024O000800086O00040008000200062O0004006600013O0004313O006600012O0030010400013O00122F0005001E3O00122F0006001F4O007B000400064O00C900045O00122F000300043O0004313O003000010004313O000700010004313O002D00010004313O000700010004313O006D00010004313O000200012O0053012O00017O00093O00028O00025O000EAA40025O0002A940026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O0026AA40025O00D0964003103O0048616E646C65546F705472696E6B657400433O00122F3O00014O00362O0100023O000E890001000600013O0004313O00060001002E7A00020009000100030004313O0009000100122F000100014O0036010200023O00122F3O00043O0026143O0002000100040004313O00020001000E0600040019000100010004313O001900012O003001035O00206F0003000300054O000400016O000500023O00122O000600066O000700076O0003000700024O000200033O00062O0002004200013O0004313O004200012O0002000200023O0004313O0042000100263B2O01001D000100010004313O001D0001002EB00007000B000100080004313O000B000100122F000300014O0036010400043O0026140003001F000100010004313O001F000100122F000400013O000E0600040026000100040004313O0026000100122F000100043O0004313O000B000100261400040022000100010004313O0022000100122F000500013O000E060004002D000100050004313O002D000100122F000400043O0004313O0022000100261400050029000100010004313O002900012O003001065O00206F0006000600094O000700016O000800023O00122O000900066O000A000A6O0006000A00024O000200063O00062O0002003A00013O0004313O003A00012O0002000200023O00122F000500043O0004313O002900010004313O002200010004313O000B00010004313O001F00010004313O000B00010004313O004200010004313O000200012O0053012O00017O00673O00028O00025O0053B240025O0013B140026O00F03F025O00208340027O0040025O00E8B240025O004AB040025O00089540030E3O002505A655B4E51B88061FA658BEE103083O00C96269C736DD847703073O0049735265616479030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O005940025O0098A740025O007EA54003153O00BE0082220B34A0860D8737033BAFBC4C822E0775FA03073O00CCD96CE3416255030A3O0071C1F9EC38C54CC2E1E003063O00A03EA395854C03063O0042752O66557003123O004B692O6C696E674D616368696E6542752O66030F3O00F5AC082ED5DFAE0A1CD7C4A9062AD003053O00A3B6C06D4F030B3O004973417661696C61626C6503113O004465617468416E64446563617942752O66030A3O004F626C69746572617465030E3O004973496E4D656C2O6552616E6765026O00144003103O003B240CC9E1313401D4F074270FC5B56C03053O0095544660A0026O001040030C3O008C161EB44AAE8239AA0D09A803083O0050C4796CDA25C8D5030A3O0049734361737461626C6503043O0052756E6503113O0052756E6963506F77657244656669636974026O003940030C3O00486F726E6F6657696E74657203153O00087C107174018C3F640B715F0B9840720D7A0B5FD203073O00EA6013621F2B6E030D3O00270D51C6A277BF090D40C2A26603073O00EB667F32A7CC12030D3O00417263616E65546F2O72656E7403153O0051B3F6224A2B6FB5FA31562B5E2OB5224B2B10F3A503063O004E30C1954324026O000840030A3O0077152B4F4C1235474C1203043O0026387747025O00E0AD40025O00A6AC4003113O00FCED54DF3153E1EE4CD36557FCEA18877103063O0036938F38B645030B3O00F093F05ACBE595ED40D4D303053O00BFB6E19F29030E3O000C1E29568286CE0A163E548584C703073O00A24B724835EBE7030B3O0046726F7374537472696B65030E3O0049735370652O6C496E52616E6765025O00D0A740025O00ECAD4003133O008A2E4BF1473D9F2856EB5807CC3D4BE71353DA03063O0062EC5C248233025O008AA040025O0068904003113O00FC7BBF0C97DD7BBE0696DD49BB0D91CB6C03053O00E5AE1ED263025O002C9140025O00489C4003113O0052656D6F7273656C652O7357696E746572026O002040025O001CB340025O00F8AC4003183O0009E88B5EFF2E3C17E89542D22A3015F98343AD3C361EADD403073O00597B8DE6318D5D025O00B2A240025O00488340030C3O00DB7EE1001944F453FA0D035E03063O002A9311966C7003083O0052696D6542752O66030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O66030C3O00486F776C696E67426C61737403133O0007A93A73EEE608992F73E6FB1BE62C70E2A85B03063O00886FC64D1F87025O00209540025O00DCA240030E3O001F0A0CEE310701CC3C100CE33B2O03043O008D58666D025O00C09840025O00D6A14003163O00B45FCB73133C59FEB257DC71143E5081B25CCF304B6D03083O00A1D333AA107A5D35025O0032A040025O003AA640030B3O00DDBCBD3BEFBDB131EFA6B703043O00489BCED2025O009CA640025O00BAA940030B3O0046726F737473637974686503123O0040685B1D2755794D1A3B433A550136062B0603053O0053261A346E00B8012O00122F3O00014O00362O0100013O00263B012O0006000100010004313O00060001002EB000020002000100030004313O0002000100122F000100013O0026140001007F000100040004313O007F000100122F000200014O0036010300033O002E2101053O000100050004313O000B00010026140002000B000100010004313O000B000100122F000300013O00261400030014000100040004313O0014000100122F000100063O0004313O007F000100263B01030018000100010004313O00180001002E7A00070010000100080004313O0010000100122F000400013O002E210109005E000100090004313O0077000100261400040077000100010004313O007700012O003001056O006A000600013O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005004000013O0004313O004000012O0030010500023O00066300050040000100010004313O004000012O0030010500033O00062C0105004000013O0004313O004000012O0030010500044O001200065O00202O00060006000D4O000700086O000900053O00202O00090009000E00122O000B000F6O0009000B00024O000900096O00050009000200062O0005003B000100010004313O003B0001002E7A00100040000100110004313O004000012O0030010500013O00122F000600123O00122F000700134O007B000500074O00C900056O003001056O006A000600013O00122O000700143O00122O000800156O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005007600013O0004313O007600012O0030010500063O0020980005000500164O00075O00202O0007000700174O00050007000200062O0005007600013O0004313O007600012O003001056O006A000600013O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005001A4O00050002000200062O0005007600013O0004313O007600012O0030010500063O0020980005000500164O00075O00202O00070007001B4O00050007000200062O0005007600013O0004313O007600012O0030010500073O00066300050076000100010004313O007600012O0030010500044O009900065O00202O00060006001C4O000700086O000900053O00202O00090009001D00122O000B001E6O0009000B00024O000900096O00050009000200062O0005007600013O0004313O007600012O0030010500013O00122F0006001F3O00122F000700204O007B000500074O00C900055O00122F000400043O00261400040019000100040004313O0019000100122F000300043O0004313O001000010004313O001900010004313O001000010004313O007F00010004313O000B0001002614000100C0000100210004313O00C000012O003001026O006A000300013O00122O000400223O00122O000500236O0003000500024O00020002000300202O0002000200244O00020002000200062O000200A100013O0004313O00A100012O0030010200063O00209E0002000200252O002100020002000200264A010200A1000100060004313O00A100012O0030010200063O00209E0002000200262O0021000200020002000EDC002700A1000100020004313O00A100012O0030010200044O005201035O00202O0003000300284O000400086O00020004000200062O000200A100013O0004313O00A100012O0030010200013O00122F000300293O00122F0004002A4O007B000200044O00C900026O0030010200093O00062C010200B72O013O0004313O00B72O012O003001026O006A000300013O00122O0004002B3O00122O0005002C6O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200B72O013O0004313O00B72O012O0030010200063O00209E0002000200262O0021000200020002000EDC002700B72O0100020004313O00B72O012O0030010200044O005201035O00202O00030003002D4O0004000A6O00020004000200062O000200B72O013O0004313O00B72O012O0030010200013O0012220103002E3O00122O0004002F6O000200046O00025O00044O00B72O01000E060030000F2O0100010004313O000F2O012O003001026O006A000300013O00122O000400313O00122O000500326O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200E200013O0004313O00E200012O0030010200073O000663000200E2000100010004313O00E20001002EB0003400E2000100330004313O00E200012O0030010200044O009900035O00202O00030003001C4O000400056O000600053O00202O00060006001D00122O0008001E6O0006000800024O000600066O00020006000200062O000200E200013O0004313O00E200012O0030010200013O00122F000300353O00122F000400364O007B000200044O00C900026O003001026O006A000300013O00122O000400373O00122O000500386O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002000E2O013O0004313O000E2O012O0030010200023O0006630002000E2O0100010004313O000E2O012O003001026O0011010300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300202O00020002001A4O00020002000200062O0002000E2O0100010004313O000E2O012O0030010200044O008400035O00202O00030003003B4O0004000B6O000500056O000600053O00202O00060006003C4O00085O00202O00080008003B4O0006000800024O000600064O0065000200060002000663000200092O0100010004313O00092O01002EB0003E000E2O01003D0004313O000E2O012O0030010200013O00122F0003003F3O00122F000400404O007B000200044O00C900025O00122F000100213O000E060001006D2O0100010004313O006D2O0100122F000200014O0036010300033O00263B010200172O0100010004313O00172O01002EB0004100132O0100420004313O00132O0100122F000300013O0026140003001C2O0100040004313O001C2O0100122F000100043O0004313O006D2O01002614000300182O0100010004313O00182O012O003001046O0011010500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004002A2O0100010004313O002A2O01002E2101450015000100460004313O003D2O012O0030010400044O001200055O00202O0005000500474O000600076O000800053O00202O00080008001D00122O000A00486O0008000A00024O000800086O00040008000200062O000400382O0100010004313O00382O01002E21014900070001004A0004313O003D2O012O0030010400013O00122F0005004B3O00122F0006004C4O007B000400064O00C900045O002EB0004E00692O01004D0004313O00692O012O003001046O006A000500013O00122O0006004F3O00122O000700506O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400692O013O0004313O00692O012O0030010400063O0020B70004000400164O00065O00202O0006000600514O00040006000200062O000400572O0100010004313O00572O012O0030010400053O0020980004000400524O00065O00202O0006000600534O00040006000200062O000400692O013O0004313O00692O012O0030010400044O007400055O00202O0005000500544O000600076O000800053O00202O00080008003C4O000A5O00202O000A000A00544O0008000A00024O000800086O00040008000200062O000400692O013O0004313O00692O012O0030010400013O00122F000500553O00122F000600564O007B000400064O00C900045O00122F000300043O0004313O00182O010004313O006D2O010004313O00132O0100263B2O0100712O0100060004313O00712O01002EB000580007000100570004313O000700012O003001026O006A000300013O00122O000400593O00122O0005005A6O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200912O013O0004313O00912O012O0030010200023O000663000200912O0100010004313O00912O012O0030010200044O001200035O00202O00030003000D4O000400056O000600053O00202O00060006000E00122O0008000F6O0006000800024O000600066O00020006000200062O0002008C2O0100010004313O008C2O01002E21015B00070001005C0004313O00912O012O0030010200013O00122F0003005D3O00122F0004005E4O007B000200044O00C900025O002EB0005F00B32O0100600004313O00B32O012O003001026O006A000300013O00122O000400613O00122O000500626O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200B32O013O0004313O00B32O012O0030010200073O00062C010200B32O013O0004313O00B32O01002E7A006300B32O0100640004313O00B32O012O0030010200044O009900035O00202O0003000300654O000400056O000600053O00202O00060006001D00122O000800486O0006000800024O000600066O00020006000200062O000200B32O013O0004313O00B32O012O0030010200013O00122F000300663O00122F000400674O007B000200044O00C900025O00122F000100303O0004313O000700010004313O00B72O010004313O000200012O0053012O00017O008A3O00028O00025O00EC9340025O00708D40027O0040025O00989240025O000CB040030A3O00AD4C5356A4CC4C832O5A03073O003EE22E2O3FD0A903073O004973526561647903113O0052756E6963506F77657244656669636974026O00444003063O0042752O66557003113O0050692O6C61726F6646726F737442752O66026O003140025O00C8A240025O0056A340030C3O00436173745461726765744966030A3O004F626C697465726174652O033O00E8184D03083O003E857935E37F6D4F030E3O004973496E4D656C2O6552616E6765026O00144003143O001F163EFCC2ABB0110037B5D4BCA711003AB587FA03073O00C270745295B6CE030D3O001DAD4D0CC8C3003D8C491BC1FB03073O006E59C82C78A082030A3O0052756E6963506F776572026O004240030B3O0052756E6554696D65546F58026O003240025O0068A040025O00D8834003093O00446144506C61796572030E3O0049735370652O6C496E52616E6765030D3O004465617468416E64446563617903193O00AFC64A524B753A43AFFC4F43404B220DA9D14E4757427B1CFD03083O002DCBA32B26232A5B026O00F03F025O002EA740025O0080684003113O00E080D12C95BA51DE80CF30B0A05AC680CE03073O0034B2E5BC43E7C903113O0052656D6F7273656C652O7357696E746572026O002040031C3O0033445D0BE54F262D444317C84B2A2F2O5516B75E312440440CB70D7B03073O004341213064973C026O000840026O001040030D3O00764A07DF595D30D1454A01D04303043O00BE373864026O004E40030D3O00417263616E65546F2O72656E7403183O0057BD3F1F1DE6CC42A02E0C16EDE716AD2E1B12F7FB16FD6A03073O009336CF5C7E7383025O0051B240025O00CEA740025O00607A40025O00B07940030C3O00F7E8B9D4FAD1E08CD4F2CCF303053O0093BF87CEB8025O0058A340025O002OA640025O00809440030C3O00486F776C696E67426C61737403173O008C27B1CDD15DB5BB2AAAC0CB47F2863AA3C0CC5BF2D67803073O00D2E448C6A1B833030A3O00194BFF1967CB2448E71503063O00AE5629937013026O003940025O005EAB40025O0098AA40025O00D8A140025O00A4B0402O033O0056019503083O00CB3B60ED6B456F7103143O002B14A0E825F5C52502A9A133E2D22502A4A163A203073O00B74476CC815190025O00F08340025O00E09040030C3O0026A267E8028C098F7CE5189603063O00E26ECD10846B03083O0052696D6542752O6603173O00E3CCF7D548E5C4DFDB4DEAD0F49943F9C6E1CD49AB91B403053O00218BA380B9025O0010A340025O002DB040025O0018B140025O001EA740025O00109A4003113O00021B8D1753231B8C1D522329891655350C03053O0021507EE078031B3O00FEAD0ECB4EFFAD0FC14FFF9714CD52F8AD11845EFEAD02D054ACFA03053O003C8CC863A4030C3O00AFFB132AAB89F3262AA394E003053O00C2E794644603173O00744DC6A6F9CE5244C485E4C75C49CF80FEC94B5CC8ACF803063O00A8262CA1C396030B3O004973417661696C61626C65025O0080464003163O0088F3957A39E6B12982F0836524A8B40485FD967E70BC03083O0076E09CE2165088D6025O003CAA40025O0028B340030C3O006AE14B8E4DE86E894CFA5C9203043O00E0228E3903043O0052756E65025O008AA640025O0078A640030C3O00486F726E6F6657696E74657203173O00D6A8D7D34CFE5B31C9AECBC976E31D0CCCA2C4C97BB10B03083O006EBEC7A5BD13913D025O00BAA340025O001AA740025O001EAF40025O00488440030B3O00D5112603964B1B6FE70B2C03083O001693634970E23878025O00F09D40030B3O0046726F737473637974686503153O00BE67EDE699AB76FBE185BD35E0E788B961EAB5DCEA03053O00EDD8158295030A3O00F5E97BE19FC2C8EA63ED03063O00A7BA8B1788EB03123O004B692O6C696E674D616368696E6542752O66025O0097B040025O0016AD402O033O0017B49003043O006D7AD5E803133O00E1F5AE39FAF2B031FAF2E232FCF2A324E6B7FA03043O00508E97C2025O00989640025O0072A740030B3O0025D4785F17D5745517CE7203043O002C63A617025O0068AA40025O00E0684003153O007AE5262527B77FEE3D3E36E47EE52C3727AC3CA67903063O00C41C974956530078022O00122F3O00014O00362O0100013O0026143O0002000100010004313O0002000100122F000100013O002EB0000300A9000100020004313O00A90001002614000100A9000100040004313O00A9000100122F000200014O0036010300033O002EB00005000B000100060004313O000B00010026140002000B000100010004313O000B000100122F000300013O00261400030076000100010004313O007600012O003001046O006A000500013O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O00040002000200062O0004004700013O0004313O004700012O0030010400023O00209E00040004000A2O0021000400020002000E4A000B002D000100040004313O002D00012O0030010400023O00209800040004000C4O00065O00202O00060006000D4O00040006000200062O0004004700013O0004313O004700012O0030010400023O00209E00040004000A2O0021000400020002000EDC000E0047000100040004313O00470001002E7A000F0047000100100004313O004700012O0030010400033O0020940004000400114O00055O00202O0005000500124O000600046O000700013O00122O000800133O00122O000900146O0007000900024O000800056O000900096O000A00063O00202O000A000A001500122O000C00166O000A000C00024O000A000A6O0004000A000200062O0004004700013O0004313O004700012O0030010400013O00122F000500173O00122F000600184O007B000400064O00C900046O003001046O006A000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004006000013O0004313O006000012O0030010400023O00209E00040004001B2O002100040002000200264A010400600001001C0004313O006000012O0030010400023O00203400040004001D00122O000600046O0004000600024O000500023O00202O00050005001B4O00050002000200202O00050005001E00062O00050062000100040004313O00620001002E7A001F0075000100200004313O007500012O0030010400074O0084000500083O00202O0005000500214O000600096O000700076O000800063O00202O0008000800224O000A5O00202O000A000A00234O0008000A00024O000800084O006500040008000200062C0104007500013O0004313O007500012O0030010400013O00122F000500243O00122F000600254O007B000400064O00C900045O00122F000300263O00261400030010000100260004313O00100001002EB0002800A4000100270004313O00A400012O003001046O006A000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400A400013O0004313O00A400012O0030010400023O00209E00040004001B2O002100040002000200264A010400A40001001C0004313O00A400012O0030010400023O00205C00040004001D00122O000600046O0004000600024O000500023O00202O00050005001B4O00050002000200202O00050005001E00062O000500A4000100040004313O00A400012O0030010400074O009900055O00202O00050005002B4O000600076O000800063O00202O00080008001500122O000A002C6O0008000A00024O000800086O00040008000200062O000400A400013O0004313O00A400012O0030010400013O00122F0005002D3O00122F0006002E4O007B000400064O00C900045O00122F0001002F3O0004313O00A900010004313O001000010004313O00A900010004313O000B0001002614000100C7000100300004313O00C700012O003001026O006A000300013O00122O000400313O00122O000500326O0003000500024O00020002000300202O0002000200094O00020002000200062O0002007702013O0004313O007702012O0030010200023O00209E00020002001B2O002100020002000200264A01020077020100330004313O007702012O0030010200074O005201035O00202O0003000300344O0004000A6O00020004000200062O0002007702013O0004313O007702012O0030010200013O001222010300353O00122O000400366O000200046O00025O00044O0077020100263B2O0100CB0001002F0004313O00CB0001002EB00037005D2O0100380004313O005D2O0100122F000200013O002614000200332O0100010004313O00332O0100122F000300013O00263B010300D3000100260004313O00D30001002E7A003900D50001003A0004313O00D5000100122F000200263O0004313O00332O01002614000300CF000100010004313O00CF00012O003001046O006A000500013O00122O0006003B3O00122O0007003C6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400F000013O0004313O00F000012O0030010400023O00209E00040004001B2O002100040002000200264A010400F00001001C0004313O00F000012O0030010400023O00203400040004001D00122O000600046O0004000600024O000500023O00202O00050005001B4O00050002000200202O00050005001E00062O000500F2000100040004313O00F20001002EB0003E00062O01003D0004313O00062O01002E21013F00140001003F0004313O00062O012O0030010400074O007400055O00202O0005000500404O000600076O000800063O00202O0008000800224O000A5O00202O000A000A00404O0008000A00024O000800086O00040008000200062O000400062O013O0004313O00062O012O0030010400013O00122F000500413O00122F000600424O007B000400064O00C900046O003001046O006A000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400094O00040002000200062O000400152O013O0004313O00152O012O0030010400023O00209E00040004000A2O0021000400020002000E4A004500172O0100040004313O00172O01002E210146001C000100470004313O00312O01002EB0004800312O0100490004313O00312O012O0030010400033O0020940004000400114O00055O00202O0005000500124O000600046O000700013O00122O0008004A3O00122O0009004B6O0007000900024O000800056O000900096O000A00063O00202O000A000A001500122O000C00166O000A000C00024O000A000A6O0004000A000200062O000400312O013O0004313O00312O012O0030010400013O00122F0005004C3O00122F0006004D4O007B000400064O00C900045O00122F000300263O0004313O00CF0001002614000200CC000100260004313O00CC0001002E7A004E005A2O01004F0004313O005A2O012O003001036O006A000400013O00122O000500503O00122O000600516O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005A2O013O0004313O005A2O012O0030010300023O00209800030003000C4O00055O00202O0005000500524O00030005000200062O0003005A2O013O0004313O005A2O012O0030010300074O007400045O00202O0004000400404O000500066O000700063O00202O0007000700224O00095O00202O0009000900404O0007000900024O000700076O00030007000200062O0003005A2O013O0004313O005A2O012O0030010300013O00122F000400533O00122F000500544O007B000300054O00C900035O00122F000100303O0004313O005D2O010004313O00CC0001002614000100E92O0100010004313O00E92O0100122F000200014O0036010300033O00263B010200652O0100010004313O00652O01002E21015500FEFF2O00560004313O00612O0100122F000300013O002EB0005800BE2O0100570004313O00BE2O01002614000300BE2O0100010004313O00BE2O01002E2101590023000100590004313O008D2O012O003001046O006A000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008D2O013O0004313O008D2O012O00300104000B3O0006630004007C2O0100010004313O007C2O012O00300104000C3O00062C0104008D2O013O0004313O008D2O012O0030010400074O009900055O00202O00050005002B4O000600076O000800063O00202O00080008001500122O000A002C6O0008000A00024O000800086O00040008000200062O0004008D2O013O0004313O008D2O012O0030010400013O00122F0005005C3O00122F0006005D4O007B000400064O00C900046O003001046O006A000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400BD2O013O0004313O00BD2O012O00300104000D3O00062C010400BD2O013O0004313O00BD2O012O0030010400023O00208A00040004001B4O0004000200024O0005000E6O00068O000700013O00122O000800603O00122O000900616O0007000900024O00060006000700202O0006000600622O0037010600074O00E100053O00020020D200050005002C00102001050063000500060A000500BD2O0100040004313O00BD2O012O0030010400074O007400055O00202O0005000500404O000600076O000800063O00202O0008000800224O000A5O00202O000A000A00404O0008000A00024O000800086O00040008000200062O000400BD2O013O0004313O00BD2O012O0030010400013O00122F000500643O00122F000600654O007B000400064O00C900045O00122F000300263O00263B010300C22O0100260004313O00C22O01002E7A006700662O0100660004313O00662O012O003001046O006A000500013O00122O000600683O00122O000700696O0005000700024O00040004000500202O0004000400094O00040002000200062O000400E42O013O0004313O00E42O012O0030010400023O00209E00040004006A2O002100040002000200264A010400E42O0100040004313O00E42O012O0030010400023O00209E00040004000A2O0021000400020002000EDC004500E42O0100040004313O00E42O01002EB0006C00E42O01006B0004313O00E42O012O0030010400074O005201055O00202O00050005006D4O0006000F6O00040006000200062O000400E42O013O0004313O00E42O012O0030010400013O00122F0005006E3O00122F0006006F4O007B000400064O00C900045O00122F000100263O0004313O00E92O010004313O00662O010004313O00E92O010004313O00612O0100261400010005000100260004313O0005000100122F000200013O00263B010200F02O0100260004313O00F02O01002E210170002B000100710004313O00190201002EB000730017020100720004313O001702012O003001036O006A000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300094O00030002000200062O0003001702013O0004313O001702012O0030010300103O00062C0103001702013O0004313O001702012O0030010300023O00209E00030003001B2O0021000300020002000EDC00630017020100030004313O00170201002E2101760013000100760004313O001702012O0030010300074O009900045O00202O0004000400774O000500066O000700063O00202O00070007001500122O0009002C6O0007000900024O000700076O00030007000200062O0003001702013O0004313O001702012O0030010300013O00122F000400783O00122F000500794O007B000300054O00C900035O00122F000100043O0004313O00050001002614000200EC2O0100010004313O00EC2O012O003001036O006A000400013O00122O0005007A3O00122O0006007B6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003004902013O0004313O004902012O0030010300023O00209800030003000C4O00055O00202O00050005007C4O00030005000200062O0003004902013O0004313O004902012O0030010300103O00066300030049020100010004313O00490201002E7A007E00490201007D0004313O004902012O0030010300033O0020940003000300114O00045O00202O0004000400124O000500046O000600013O00122O0007007F3O00122O000800806O0006000800024O000700056O000800086O000900063O00202O00090009001500122O000B00166O0009000B00024O000900096O00030009000200062O0003004902013O0004313O004902012O0030010300013O00122F000400813O00122F000500824O007B000300054O00C900035O002EB000830072020100840004313O007202012O003001036O006A000400013O00122O000500853O00122O000600866O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007202013O0004313O007202012O0030010300023O00209800030003000C4O00055O00202O00050005007C4O00030005000200062O0003007202013O0004313O007202012O0030010300103O00062C0103007202013O0004313O007202012O0030010300074O001200045O00202O0004000400774O000500066O000700063O00202O00070007001500122O0009002C6O0007000900024O000700076O00030007000200062O0003006D020100010004313O006D0201002EB000870072020100880004313O007202012O0030010300013O00122F000400893O00122F0005008A4O007B000300054O00C900035O00122F000200263O0004313O00EC2O010004313O000500010004313O007702010004313O000200012O0053012O00017O00443O00028O00025O00589740025O00D4B140026O00F03F025O00A0B040025O00507D40027O0040025O001EAD40025O00C05540030C3O00117C6B4FC13F44704FDA3C6103053O00AE5913192103073O004973526561647903113O0052756E6963506F77657244656669636974026O003940025O00088340025O0062AE40030C3O00486F726E6F6657696E746572031E3O00271D2O40C8880D10055B40E382196F10404BF69303101D5042FE934B7E4203073O006B4F72322E97E7030D3O0018B4B628843C83CF2BB4B0279E03083O00A059C6D549EA59D7026O003440025O0088A440025O00FEA040030D3O00417263616E65546F2O72656E74031E3O004963B7FFCB4D4EA0F1D75A74BAEA854A63B1FFD1404EBBFCC94165F4AF9703053O00A52811D49E025O006EA740030C3O00F529E14FBCD321D44FB4CE3203053O00D5BD46962303063O0042752O66557003083O0052696D6542752O66030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E6765025O0030A740025O00C05140031C3O00475A6304465B73374D59751B5B15761A4A546000705A76044641345E03043O00682F3514030C3O008B439610B501A46E8D1DAF1B03063O006FC32CE17CDC03083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O66031C3O00D049177FA2A5DF79027FAAB8CC060261AEAACC4E3F7CA9A7D152402B03063O00CBB8266013CB025O00CAAA40025O0010AB40025O0042A240025O00707A40030B3O002B233A6E196D0E2821750803063O001E6D51551D6D030B3O0046726F7374736379746865030E3O004973496E4D656C2O6552616E6765026O002040031A3O00F9635BA522CDFFE6655CB376DCEEFA7040BE09D1FEF37840F66403073O009C9F1134D656BE030A3O0081EDB1B5BAEAAFBDBAEA03043O00DCCE8FDD025O00A7B240025O00588640025O0068AC40025O006C9C40030C3O00436173745461726765744966030A3O004F626C697465726174652O033O008B7C3503073O00B2E61D4D77B8AC026O00144003193O00FABC061263FDE7BF2O1E37FAE7BB0B0F7FC7FABC061263B8A103063O009895DE6A7B170003012O00122F3O00014O00362O0100023O002E7A000200FC000100030004313O00FC0001000E06000400FC00013O0004313O00FC0001002EB000060006000100050004313O0006000100261400010006000100010004313O0006000100122F000200013O00263B0102000F000100070004313O000F0001002EB00008004A000100090004313O004A00012O003001036O006A000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003002C00013O0004313O002C00012O0030010300023O00209E00030003000D2O0021000300020002000EDC000E002C000100030004313O002C0001002E7A000F002C000100100004313O002C00012O0030010300034O005201045O00202O0004000400114O000500046O00030005000200062O0003002C00013O0004313O002C00012O0030010300013O00122F000400123O00122F000500134O007B000300054O00C900036O003001036O006A000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003B00013O0004313O003B00012O0030010300023O00209E00030003000D2O0021000300020002000E4A0016003D000100030004313O003D0001002EB0001700022O0100180004313O00022O012O0030010300034O005201045O00202O0004000400194O000500056O00030005000200062O000300022O013O0004313O00022O012O0030010300013O0012220104001A3O00122O0005001B6O000300056O00035O00044O00022O01002E21011C00570001001C0004313O00A10001002614000200A1000100040004313O00A1000100122F000300013O0026140003009A000100010004313O009A00012O003001046O006A000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004007600013O0004313O007600012O0030010400023O00209800040004001F4O00065O00202O0006000600204O00040006000200062O0004007600013O0004313O007600012O0030010400034O001100055O00202O0005000500214O000600076O000800063O00202O0008000800224O000A5O00202O000A000A00214O0008000A00024O000800086O00040008000200062O00040071000100010004313O00710001002E2101230007000100240004313O007600012O0030010400013O00122F000500253O00122F000600264O007B000400064O00C900046O003001046O006A000500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004009900013O0004313O009900012O0030010400023O0020980004000400294O00065O00202O00060006002A4O00040006000200062O0004009900013O0004313O009900012O0030010400034O007400055O00202O0005000500214O000600076O000800063O00202O0008000800224O000A5O00202O000A000A00214O0008000A00024O000800086O00040008000200062O0004009900013O0004313O009900012O0030010400013O00122F0005002B3O00122F0006002C4O007B000400064O00C900045O00122F000300043O002EB0002D004F0001002E0004313O004F0001000E060004004F000100030004313O004F000100122F000200073O0004313O00A100010004313O004F000100263B010200A5000100010004313O00A50001002E7A002F000B000100300004313O000B00012O003001036O006A000400013O00122O000500313O00122O000600326O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300CA00013O0004313O00CA00012O0030010300023O00209800030003001F4O00055O00202O00050005002A4O00030005000200062O000300CA00013O0004313O00CA00012O0030010300073O00062C010300CA00013O0004313O00CA00012O0030010300034O009900045O00202O0004000400334O000500066O000700063O00202O00070007003400122O000900356O0007000900024O000700076O00030007000200062O000300CA00013O0004313O00CA00012O0030010300013O00122F000400363O00122F000500374O007B000300054O00C900036O003001036O006A000400013O00122O000500383O00122O000600396O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300DB00013O0004313O00DB00012O0030010300023O0020B700030003001F4O00055O00202O00050005002A4O00030005000200062O000300DD000100010004313O00DD0001002E21013A001C0001003B0004313O00F70001002E7A003D00F70001003C0004313O00F700012O0030010300083O00209400030003003E4O00045O00202O00040004003F4O000500096O000600013O00122O000700403O00122O000800416O0006000800024O0007000A6O000800086O000900063O00202O00090009003400122O000B00426O0009000B00024O000900096O00030009000200062O000300F700013O0004313O00F700012O0030010300013O00122F000400433O00122F000500444O007B000300054O00C900035O00122F000200043O0004313O000B00010004313O00022O010004313O000600010004313O00022O010026143O0002000100010004313O0002000100122F000100014O0036010200023O00122F3O00043O0004313O000200012O0053012O00017O004A3O00028O00025O00349140025O00B2A240026O00F03F025O000C9540030B3O00C6D1093A28F6D60E1A25E003053O004685B9685303073O00497352656164792O033O0047434403043O0052756E65027O004003083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O6603093O0042752O66537461636B030D3O00436F6C64486561727442752O66026O001040026O00204003063O0042752O665570026O002440030B3O00436861696E736F66496365030E3O0049735370652O6C496E52616E6765031A3O00074D4523C7177A4B2CF60D46416ACA0B494015C10144563E895603053O00A96425244A030B3O00238FA3590E94AD562984A703043O003060E7C2030C3O00E75802240DDDBD82DC53012303083O00E3A83A6E4D79B8CF030B3O004973417661696C61626C6503113O0050692O6C61726F6646726F737442752O66030B3O0042752O6652656D61696E73030E3O005D2EB053A5CC68B7762F9955A3C203083O00C51B5CDF20D1BB11030E3O00254DCCE81748DAE90E4CE5EE114603043O009B633FA303123O00556E686F6C79537472656E67746842752O66031A3O0081D9A084B797BDDEA7B2B02O8791A282B580BDD9A48CAB90C28503063O00E4E2B1C1EDD9030B3O0017B822EF3AA32CE01DB32603043O008654D043030C3O003CAE8A5507A9945D07A5895203043O003C73CCE6030D3O00D733E77CE628E476C128E463F303043O0010875A8B030F3O00432O6F6C646F776E52656D61696E73026O002E40026O002A40025O003EAD40025O0038A240031A3O00577C073A402O475B72393A4D5138577B0A37715C7D556612731803073O0018341466532E34025O0028A940025O007CB240030B3O00E727202D01D720270D0CC103053O006FA44F4144030C3O00E9DB8FD73AEFD4D897D721E403063O008AA6B9E3BE4E030D3O00FB7DC93B533116CD52D738413703073O0079AB14A5573243026O003440025O0082B140025O0062B340031A3O00C530B83FB711F937BF09B001C378BA39B506F930BC37AB16866003063O0062A658D956D9030B3O00D5FE780888CFF9F050028303063O00BC2O961961E6030C3O00F58B530B18E8C8884B0B03E303063O008DBAE93F626C026O002C40026O003340030D3O00C1E320BA24E3E52A9037FEF93803053O0045918A4CD6026O000840031B3O0073C78880B1054FC08F2OB615758F8A86B3124FC78C88AD02309ED903063O007610AF2OE9DF00F1012O00122F3O00014O00362O0100013O00263B012O0006000100010004313O00060001002E7A00030002000100020004313O0002000100122F000100013O002614000100F0000100010004313O00F0000100122F000200013O0026140002000E000100040004313O000E000100122F000100043O0004313O00F000010026140002000A000100010004313O000A0001002E210105005F000100050004313O006F00012O003001036O006A000400013O00122O000500063O00122O000600076O0004000600024O00030003000400202O0003000300084O00030002000200062O0003006F00013O0004313O006F00012O0030010300024O0030010400033O00209E0004000400092O002100040002000200060A0003006F000100040004313O006F00012O0030010300033O00209E00030003000A2O00210003000200020026500103005D0001000B0004313O005D00012O0030010300033O00209800030003000C4O00055O00202O00050005000D4O00030005000200062O0003004200013O0004313O004200012O0030010300043O00066300030038000100010004313O003800012O0030010300033O00201500030003000E4O00055O00202O00050005000F4O000300050002000E2O0010005D000100030004313O005D00012O0030010300043O00062C0103004200013O0004313O004200012O0030010300033O00204700030003000E4O00055O00202O00050005000F4O000300050002000E2O0011005D000100030004313O005D00012O0030010300033O0020980003000300124O00055O00202O00050005000D4O00030005000200062O0003006F00013O0004313O006F00012O0030010300043O00066300030053000100010004313O005300012O0030010300033O00204700030003000E4O00055O00202O00050005000F4O000300050002000E2O0011005D000100030004313O005D00012O0030010300043O00062C0103006F00013O0004313O006F00012O0030010300033O00202701030003000E4O00055O00202O00050005000F4O000300050002000E2O0013006F000100030004313O006F00012O0030010300054O007400045O00202O0004000400144O000500056O000600063O00202O0006000600154O00085O00202O0008000800144O0006000800024O000600066O00030006000200062O0003006F00013O0004313O006F00012O0030010300013O00122F000400163O00122F000500174O007B000300054O00C900036O003001036O006A000400013O00122O000500183O00122O000600196O0004000600024O00030003000400202O0003000300084O00030002000200062O000300EE00013O0004313O00EE00012O003001036O0011010400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300EE000100010004313O00EE00012O0030010300033O0020980003000300124O00055O00202O00050005001D4O00030005000200062O000300EE00013O0004313O00EE00012O0030010300033O00200D01030003000E4O00055O00202O00050005000F4O000300050002000E2O001300EE000100030004313O00EE00012O0030010300033O0020D600030003001E4O00055O00202O00050005001D4O0003000500024O000400033O00202O0004000400094O0004000200024O000500073O00122O000600046O000700086O00088O000900013O00122O000A001F3O00122O000B00206O0009000B00024O00080008000900202O00080008001C4O00080002000200062O000800AE00013O0004313O00AE00012O003001086O0050000900013O00122O000A00213O00122O000B00226O0009000B00024O00080008000900202O0008000800084O0008000200022O0037010700084O003000053O00024O000600093O00122O000700046O000800086O00098O000A00013O00122O000B001F3O00122O000C00206O000A000C00024O00090009000A00202O00090009001C4O00090002000200062O000900C500013O0004313O00C500012O003001096O0050000A00013O00122O000B00213O00122O000C00226O000A000C00024O00090009000A00202O0009000900084O0009000200022O0037010800094O00E100063O00022O00B40005000500062O009B000400040005000638000300DC000100040004313O00DC00012O0030010300033O0020980003000300124O00055O00202O0005000500234O00030005000200062O000300EE00013O0004313O00EE00012O0030010300033O00208800030003001E4O00055O00202O0005000500234O0003000500024O000400033O00202O0004000400094O00040002000200062O000300EE000100040004313O00EE00012O0030010300054O007400045O00202O0004000400144O000500056O000600063O00202O0006000600154O00085O00202O0008000800144O0006000800024O000600066O00030006000200062O000300EE00013O0004313O00EE00012O0030010300013O00122F000400243O00122F000500254O007B000300054O00C900035O00122F000200043O0004313O000A0001002614000100972O0100040004313O00972O0100122F000200014O0036010300033O000E06000100F4000100020004313O00F4000100122F000300013O002614000300FB000100040004313O00FB000100122F0001000B3O0004313O00972O01002614000300F7000100010004313O00F700012O003001046O006A000500013O00122O000600263O00122O000700276O0005000700024O00040004000500202O0004000400084O00040002000200062O0004004E2O013O0004313O004E2O012O003001046O0011010500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004001C4O00040002000200062O0004004E2O0100010004313O004E2O012O00300104000A3O00062C0104004E2O013O0004313O004E2O012O0030010400033O00209800040004000C4O00065O00202O00060006001D4O00040006000200062O0004004E2O013O0004313O004E2O012O003001046O0061000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O00040004002C4O000400020002000E2O002D004E2O0100040004313O004E2O012O0030010400033O00200D01040004000E4O00065O00202O00060006000F4O000400060002000E2O001300332O0100040004313O00332O012O0030010400033O0020B70004000400124O00065O00202O0006000600234O00040006000200062O0004003A2O0100010004313O003A2O012O0030010400033O00200D01040004000E4O00065O00202O00060006000F4O000400060002000E2O002E004E2O0100040004313O004E2O01002EB00030004E2O01002F0004313O004E2O012O0030010400054O007400055O00202O0005000500144O000600066O000700063O00202O0007000700154O00095O00202O0009000900144O0007000900024O000700076O00040007000200062O0004004E2O013O0004313O004E2O012O0030010400013O00122F000500313O00122F000600324O007B000400064O00C900045O002E7A003300932O0100340004313O00932O012O003001046O006A000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O0004000400084O00040002000200062O000400932O013O0004313O00932O012O003001046O0011010500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O00040004001C4O00040002000200062O000400932O0100010004313O00932O012O00300104000A3O000663000400932O0100010004313O00932O012O0030010400033O00200D01040004000E4O00065O00202O00060006000F4O000400060002000E2O001300932O0100040004313O00932O012O0030010400033O00209800040004000C4O00065O00202O00060006001D4O00040006000200062O000400932O013O0004313O00932O012O003001046O0061000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004002C4O000400020002000E2O003B00932O0100040004313O00932O012O0030010400054O001100055O00202O0005000500144O000600066O000700063O00202O0007000700154O00095O00202O0009000900144O0007000900024O000700076O00040007000200062O0004008E2O0100010004313O008E2O01002E7A003D00932O01003C0004313O00932O012O0030010400013O00122F0005003E3O00122F0006003F4O007B000400064O00C900045O00122F000300043O0004313O00F700010004313O00972O010004313O00F40001002614000100070001000B0004313O000700012O003001026O006A000300013O00122O000400403O00122O000500416O0003000500024O00020002000300202O0002000200084O00020002000200062O000200F02O013O0004313O00F02O012O003001026O006A000300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O00020002001C4O00020002000200062O000200F02O013O0004313O00F02O012O0030010200033O00209800020002000C4O00045O00202O00040004001D4O00020004000200062O000200F02O013O0004313O00F02O012O0030010200033O00200D01020002000E4O00045O00202O00040004000F4O000200040002000E2O004400C22O0100020004313O00C22O012O0030010200033O0020B70002000200124O00045O00202O0004000400234O00020004000200062O000200DA2O0100010004313O00DA2O012O0030010200033O00201500020002000E4O00045O00202O00040004000F4O000200040002000E2O004500DA2O0100020004313O00DA2O012O003001026O0050000300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O00020002002C4O00020002000200264A010200F02O0100480004313O00F02O012O0030010200033O00200D01020002000E4O00045O00202O00040004000F4O000200040002000E2O004400F02O0100020004313O00F02O012O0030010200054O007400035O00202O0003000300144O000400046O000500063O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00020005000200062O000200F02O013O0004313O00F02O012O0030010200013O001222010300493O00122O0004004A6O000200046O00025O00044O00F02O010004313O000700010004313O00F02O010004313O000200012O0053012O00017O00FC3O00028O00026O00F03F025O0016AB40025O00FCA240025O00708040025O00F07F40026O001840030D3O00A9F584FB35ACFE81CB388EF19C03053O005DED90E58F03073O004973526561647903083O0042752O66446F776E03113O004465617468416E64446563617942752O6603063O0042752O66557003113O0050692O6C61726F6646726F737442752O66030B3O0042752O6652656D61696E73026O001440026O002640030D3O0025FFFC150A541AF0D60B04550103063O0026759690796B030F3O00432O6F6C646F776E52656D61696E73026O002440030F3O000EB7EB2O3BB2E03D1EAFFC3326BEFD03043O005A4DDB8E030B3O004973417661696C61626C65027O004003093O00446144506C61796572031C3O00E201202D44387BE8001E3D49047BFF442236430B7EE9132F2A0C542203073O001A866441592C67030D3O0021AFA1A237011EA08BBC39000503063O007371C6CDCE56030A3O0049734361737461626C65030C3O00AB55F2539052EC5B905EF15403043O003AE4379E03153O00456D706F77657252756E65576561706F6E42752O6603113O009184C0212BA827869CDE2B0BA834A486DE03073O0055D4E9B04E5CCD026O002840030D3O0050692O6C61726F6646726F7374031C3O005A5184EE4B4AB7ED4C678EF0454B9CA2495787EE4E579FEC5918D9BA03043O00822A38E8026O000840030B3O00DE2E0C1E0513E93400130203063O00409D4665726903073O0048617354696572026O003F40025O00A4A040025O00309D40030B3O004368692O6C53747265616B030E3O0049735370652O6C496E52616E676503193O0043A0AEEF1C7FBBB3F11541A3E7E01F4FA4A3EC074EBBE7B24503053O007020C8C783030B3O000F5855B4CF98363E555DB303073O00424C303CD8A3CB030F3O00998A7CF249C72ABDB56DE156C521A903073O0044DAE619933FAE030F3O008E26564DA0A424547FA2BF235849A503053O00D6CD4A332C03193O00F944EBF07BC55FF6EE72FB47A2FF78F540E6F360F45FA2AD2103053O00179A2C829C025O0046A040025O0036AE40025O0024A840025O0028AC40025O0054AA40025O0039B040030F3O00295B06520157084B0156077301540B03043O003F683969030C3O002485A84D1F82B6451F8EAB4A03043O00246BE7C4030D3O006DBCAE8B5CA7AD817BA7AD944903043O00E73DD5C2030F3O0041626F6D696E6174696F6E4C696D6203093O004973496E52616E6765026O00344003243O0008AF327E00A33C6700A2334C05A4307136B93C7F0CA329330AA2327F0DA22A7D1AED6C2303043O001369CD5D025O0024B040030F3O00880AD18C36A709CA8830A724D78C3D03053O005FC968BEE103123O008DD9C4CFBBC3CEC89CC2CFCABDCAC6C1BCCA03043O00AECFABA1025O00C05640025O0078A54003243O00ECFC02FEF1D9ECEA04FCF6E8E1F700F1C7C3ECF208FDEC97EEF102FFFCD8FAF01EB3A98503063O00B78D9E6D9398025O003C9C40025O00F49A40030F3O000D0BE9012507E7182506E8202504E403043O006C4C698603123O00C9D7B4E0DAE3CAB7D2C7E5C1A3E0C9E4D6B003053O00AE8BA5D181030C3O008CB1EEC8D2066279B7BAEDCF03083O0018C3D382A1A6631003243O004701E6215A184717E0235D294A0AE42E6C02470FEC224756450CE6205719510DFA6C024203063O00762663894C3303123O007AD752FB573BF85EF65EF44721F65FCA44FB03073O009738A5379A235303123O004272656174686F6653696E647261676F7361030A3O0052756E6963506F776572026O004E40026O003E40025O00C88340025O0054A44003213O00A25100EFB44B3AE1A67C16E7AE4717EFA74C16EFE0400AE1AC470AF9AE5045BCF403043O008EC02365026O001040030D3O00DABC28EF412DE5B302F14F2CFE03063O005F8AD544832003123O00083AA442622227A7707F242CB34271253BA003053O00164A48C12303063O00057AE15B2D6903043O00384C1984025O0080514003123O007CD3AE27DB56CEAD15C650C5B927C851D2AA03053O00AF3EA1CB46026O00444003063O0015DEC610342C03053O00555CBDA37303123O000BBE35393DA43F3E1AA53E3C3BAD2O373AAD03043O005849CC50031C3O003E8A1C4A28C8118C16792FC8219004062AD5218F14493ED43DC3421603063O00BA4EE3702649030D3O00CC5EF1595268F351DB475C69E803063O001A9C379D353303063O00A5DB13DAB94003063O0030ECB876B9D8030C3O00CABF5B39DB31F7BC4339C03A03063O005485DD3750AF03123O009FF521A7D354B2E117AFC958AFE623A9D45D03063O003CDD8744C6A7031C3O00FEB4F48F43CBD1B2FEBC44CBE1AEECC341D6E1B1FC8C55D72OFDAAD103063O00B98EDD98E32203113O0009DCD615E5C4FF7839DFC32DF7C0FD452203083O002A4CB1A67A92A18D03123O00879800CF6D7EAA8C36C77772B78B02C16A7703063O0016C5EA65AE19030C3O000236A9D562AAC587393DAAD203083O00E64D54C5BC16CFB703043O0052756E65030D3O00C91DCAF08DB3FF33DF06C9EF9803083O00559974A69CECC190026O001C40030D3O0094E941BFE512ABE66BA1EB13B003063O0060C4802DD384025O00907740025O0031B240025O0004B340025O0080904003113O00456D706F77657252756E65576561706F6E031F3O0030806B50C5AAA6E72798755AEDB8B1D92582751FD1A0BBD431826C51C1EFEC03083O00B855ED1B3FB2CFD403113O00AE8925B4F98E6FB9913BBED98E7C9B8B3B03073O001DEBE455DB8EEB030C3O0012D6B6D4634B355329DDB5D303083O00325DB4DABD172E47030D3O00EEAD574045CE47D882494357C803073O0028BEC43B2C24BC031F3O003948CCBBED781F0357C9BAFF421A3944CCBBF43D0E334AD0B0F56A032F058803073O006D5C25BCD49A1D03113O0021E2B4CC265F16DDB1CD346D01EEB4CC3F03063O003A648FC4A351030A3O00436F6D62617454696D65030B3O00426C2O6F646C757374557003123O00385026A22B41EA08294B2DA72D48E201094303083O006E7A2243C35F298503113O0050BC4B45C170A3695FD870865E4BC67ABF03053O00B615D13B2A03103O0046752O6C526563686172676554696D65031F3O00B25AD51236BBA568D7082FBB8840C01C31B1B917C6122EB2B358D21332FEE103063O00DED737A57D41025O00709540025O00C88740030E3O00F06726B0F39BB504DB660FB6F59503083O0076B61549C387ECCC030D3O003835164C051FF20E1A084F171903073O009D685C7A20646D2O033O00474344030C3O008CA42OC329229FAAB7AFC0C403083O00CBC3C6AFAA5D47ED030D3O001E4232D95003F3286D2CDA420503073O009C4E2B5EB53171030E3O0046726F73747779726D7346757279025O0080AD40025O00DCA940031C3O0074FACBB01F542O60E5D79C0D562O6BA8C7AC044F2O7DFFCAB04B112F03073O00191288A4C36B23030E3O00CE3FA65C66ABD8AAE53E8F5A60A503083O00D8884DC92F12DCA1030D3O001DE527D609CE8D2BCA39D51BC803073O00E24D8C4BBA68BC031C3O00BFDCDF2C5BAED7C2325C86C8C52D56F9CDDF3043BDC1C7315CF99C8803053O002FD9AEB05F030E3O009ECF7911A6436134B5CE5017A04D03083O0046D8BD1662D23418030C3O00F5DDAF8EC7DFCDA293DAD5D103053O00B3BABFC3E7030D3O00C93614E8F82D17E2DF2D17F7ED03043O0084995F78030D3O0081BB0221F6C8AFB7941C22E4CE03073O00C0D1D26E4D97BA030C3O00432O6F6C646F776E446F776E030D3O00D00A2EE5FED6EF0504FBF0D7F403063O00A4806342899F03123O00556E686F6C79537472656E67746842752O66030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66030E3O002785E8BD0988E59F049FE8B0038C03043O00DE60E989025O002EAF40031C3O00BFA1A80C9CE4E9ABBEB4208EE6E2A0F3A41087FFF4B6A4A90CC82OA003073O0090D9D3C77FE893025O00A4AB40025O00D2A940025O00349240025O000C9140025O008CAD4003093O00CA2E373BD0610745FC03083O0024984F5E48B5256203093O00526169736544656164025O002CA640025O0060A54003173O00C5D94E2CD2E7433AD6DC073CD8D74B3BD8CF492C978B1503043O005FB7B827025O0086AC40030A3O008630F22A668503A53AF503073O0062D55F874634E003073O0054696D65546F58025O0080414003103O004865616C746850657263656E74616765030C3O00D1A1C57E40FBB1C8635DF1AD03053O00349EC3A91703123O004B692O6C696E674D616368696E6542752O6603123O0058AE3775923D748D49B53C7094347C8469BD03083O00EB1ADC5214E6551B03123O00AAB3ECC36080AEEFF17D86A5FBC37387B2E803053O0014E8C189A2030C3O000DDDC9AFF389057036D6CAA803083O001142BFA5C687EC77030A3O00536F756C526561706572030E3O004973496E4D656C2O6552616E676503183O001CA0BB1FC0FAE9D01FAABC53FCE7E3DD0BA0B91DECA8BF8503083O00B16FCFCE739F888C025O00989540025O00288540030F3O0036881306DD495606801118E44E5C1103073O003F65E97074B42F030E3O00E437EC11F137CF1AE904F938C03E03063O0056A35B8D7298030C3O0047686F756C52656D61696E73030F3O00536163726966696369616C50616374031D3O00400A7761335502777A3B5F34647239474B777C355F0F7B6434404B272503053O005A336B141300A0052O00122F3O00014O00362O0100023O000E060001000700013O0004313O0007000100122F000100014O0036010200023O00122F3O00023O002E7A00040002000100030004313O000200010026143O0002000100020004313O00020001002EB00006000B000100050004313O000B00010026140001000B000100010004313O000B000100122F000200013O0026140002006C000100070004313O006C00012O003001036O006A000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003009F05013O0004313O009F05012O0030010300023O00209800030003000B4O00055O00202O00050005000C4O00030005000200062O0003009F05013O0004313O009F05012O0030010300033O00062C0103009F05013O0004313O009F05012O0030010300023O00209800030003000D4O00055O00202O00050005000E4O00030005000200062O0003003B00013O0004313O003B00012O0030010300023O00202701030003000F4O00055O00202O00050005000E4O000300050002000E2O0010003B000100030004313O003B00012O0030010300023O0020E400030003000F4O00055O00202O00050005000E4O00030005000200262O0003004F000100110004313O004F00012O0030010300023O00209800030003000B4O00055O00202O00050005000E4O00030005000200062O0003004C00013O0004313O004C00012O003001036O0019000400013O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O000300020002000E2O0015004F000100030004313O004F00012O0030010300043O00264A0103009F050100110004313O009F05012O0030010300053O000E4A0010005F000100030004313O005F00012O003001036O006A000400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300184O00030002000200062O0003009F05013O0004313O009F05012O0030010300053O000EF40019009F050100030004313O009F05012O0030010300064O0052010400073O00202O00040004001A4O000500086O00030005000200062O0003009F05013O0004313O009F05012O0030010300013O0012220104001B3O00122O0005001C6O000300056O00035O00044O009F05010026140002001A2O0100190004313O001A2O0100122F000300013O002614000300AD000100020004313O00AD00012O003001046O006A000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400AB00013O0004313O00AB00012O003001046O006A000500013O00122O000600203O00122O000700216O0005000700024O00040004000500202O0004000400184O00040002000200062O0004009C00013O0004313O009C00012O0030010400033O0006630004008B000100010004313O008B00012O0030010400093O00062C0104009C00013O0004313O009C00012O0030010400023O0020B700040004000D4O00065O00202O0006000600224O00040006000200062O0004009F000100010004313O009F00012O003001046O0019000500013O00122O000600233O00122O000700246O0005000700024O00040004000500202O0004000400144O000400020002000E2O0001009F000100040004313O009F00012O0030010400043O00264A010400AB000100250004313O00AB00012O0030010400064O005201055O00202O0005000500264O0006000A6O00040006000200062O000400AB00013O0004313O00AB00012O0030010400013O00122F000500273O00122F000600284O007B000400064O00C900045O00122F000200293O0004313O001A2O01000E060001006F000100030004313O006F00012O003001046O006A000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400C000013O0004313O00C000012O0030010400023O00203B00040004002C00122O0006002D3O00122O000700196O00040007000200062O000400C2000100010004313O00C20001002E21012E00140001002F0004313O00D400012O0030010400064O007400055O00202O0005000500304O000600076O0008000B3O00202O0008000800314O000A5O00202O000A000A00304O0008000A00024O000800086O00040008000200062O000400D400013O0004313O00D400012O0030010400013O00122F000500323O00122F000600334O007B000400064O00C900046O003001046O006A000500013O00122O000600343O00122O000700356O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400182O013O0004313O00182O012O0030010400023O00203B00040004002C00122O0006002D3O00122O000700196O00040007000200062O000400182O0100010004313O00182O012O0030010400053O000EF4001900182O0100040004313O00182O012O0030010400023O00209800040004000B4O00065O00202O00060006000C4O00040006000200062O000400F900013O0004313O00F900012O003001046O0011010500013O00122O000600363O00122O000700376O0005000700024O00040004000500202O0004000400184O00040002000200062O000400062O0100010004313O00062O012O003001046O006A000500013O00122O000600383O00122O000700396O0005000700024O00040004000500202O0004000400184O00040002000200062O000400062O013O0004313O00062O012O0030010400053O002644000400182O0100100004313O00182O012O0030010400064O007400055O00202O0005000500304O000600076O0008000B3O00202O0008000800314O000A5O00202O000A000A00304O0008000A00024O000800086O00040008000200062O000400182O013O0004313O00182O012O0030010400013O00122F0005003A3O00122F0006003B4O007B000400064O00C900045O00122F000300023O0004313O006F0001000E06000200D62O0100020004313O00D62O0100122F000300014O0036010400043O00263B010300222O0100010004313O00222O01002EB0003D001E2O01003C0004313O001E2O0100122F000400013O00263B010400272O0100010004313O00272O01002E7A003F00982O01003E0004313O00982O01002EB0004000682O0100410004313O00682O012O003001056O006A000600013O00122O000700423O00122O000800436O0006000800024O00050005000600202O00050005001F4O00050002000200062O000500682O013O0004313O00682O012O003001056O006A000600013O00122O000700443O00122O000800456O0006000800024O00050005000600202O0005000500184O00050002000200062O000500542O013O0004313O00542O012O0030010500023O00209800050005000B4O00075O00202O00070007000E4O00050007000200062O000500542O013O0004313O00542O012O003001056O0050000600013O00122O000700463O00122O000800476O0006000800024O00050005000600202O0005000500144O00050002000200264A010500542O0100290004313O00542O012O0030010500033O000663000500572O0100010004313O00572O012O0030010500093O000663000500572O0100010004313O00572O012O0030010500043O00264A010500682O0100250004313O00682O012O0030010500064O009900065O00202O0006000600484O000700076O0008000B3O00202O00080008004900122O000A004A6O0008000A00024O000800086O00050008000200062O000500682O013O0004313O00682O012O0030010500013O00122F0006004B3O00122F0007004C4O007B000500074O00C900055O002E21014D002F0001004D0004313O00972O012O003001056O006A000600013O00122O0007004E3O00122O0008004F6O0006000800024O00050005000600202O00050005001F4O00050002000200062O000500972O013O0004313O00972O012O003001056O006A000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O0005000500184O00050002000200062O000500972O013O0004313O00972O012O0030010500033O000663000500842O0100010004313O00842O012O0030010500093O00062C010500972O013O0004313O00972O012O0030010500064O001200065O00202O0006000600484O000700076O0008000B3O00202O00080008004900122O000A004A6O0008000A00024O000800086O00050008000200062O000500922O0100010004313O00922O01002E7A005300972O0100520004313O00972O012O0030010500013O00122F000600543O00122F000700554O007B000500074O00C900055O00122F000400023O002614000400232O0100020004313O00232O01002E7A005700D12O0100560004313O00D12O012O003001056O006A000600013O00122O000700583O00122O000800596O0006000800024O00050005000600202O00050005001F4O00050002000200062O000500D12O013O0004313O00D12O012O003001056O0011010600013O00122O0007005A3O00122O0008005B6O0006000800024O00050005000600202O0005000500184O00050002000200062O000500D12O0100010004313O00D12O012O003001056O0011010600013O00122O0007005C3O00122O0008005D6O0006000800024O00050005000600202O0005000500184O00050002000200062O000500D12O0100010004313O00D12O012O0030010500033O000663000500C02O0100010004313O00C02O012O0030010500093O00062C010500D12O013O0004313O00D12O012O0030010500064O009900065O00202O0006000600484O000700076O0008000B3O00202O00080008004900122O000A004A6O0008000A00024O000800086O00050008000200062O000500D12O013O0004313O00D12O012O0030010500013O00122F0006005E3O00122F0007005F4O007B000500074O00C900055O00122F000200193O0004313O00D62O010004313O00232O010004313O00D62O010004313O001E2O01002614000200A8020100290004313O00A8020100122F000300013O000E0600020010020100030004313O001002012O003001046O006A000500013O00122O000600603O00122O000700616O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004000E02013O0004313O000E02012O0030010400023O00209800040004000B4O00065O00202O0006000600624O00040006000200062O000400F72O013O0004313O00F72O012O0030010400023O00209E0004000400632O0021000400020002000EDC006400F72O0100040004313O00F72O012O0030010400033O000663000400FA2O0100010004313O00FA2O012O0030010400093O000663000400FA2O0100010004313O00FA2O012O0030010400043O00264A0104000E020100650004313O000E02012O0030010400064O007300055O00202O0005000500624O0006000C6O000700076O0008000B3O00202O00080008004900122O000A00256O0008000A00024O000800086O00040008000200062O00040009020100010004313O00090201002E7A0067000E020100660004313O000E02012O0030010400013O00122F000500683O00122F000600694O007B000400064O00C900045O00122F0002006A3O0004313O00A80201000E06000100D92O0100030004313O00D92O012O003001046O006A000500013O00122O0006006B3O00122O0007006C6O0005000700024O00040004000500202O00040004001F4O00040002000200062O0004006C02013O0004313O006C02012O003001046O006A000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500202O0004000400184O00040002000200062O0004006C02013O0004313O006C02012O0030010400033O0006630004002C020100010004313O002C02012O0030010400093O00062C0104006C02013O0004313O006C02012O003001046O0011010500013O00122O0006006F3O00122O000700706O0005000700024O00040004000500202O0004000400184O00040002000200062O00040045020100010004313O004502012O0030010400023O00209E0004000400632O0021000400020002000E4A00710060020100040004313O006002012O003001046O0019000500013O00122O000600723O00122O000700736O0005000700024O00040004000500202O0004000400144O000400020002000E2O00740060020100040004313O006002012O003001046O006A000500013O00122O000600753O00122O000700766O0005000700024O00040004000500202O0004000400184O00040002000200062O0004006C02013O0004313O006C02012O003001046O0019000500013O00122O000600773O00122O000700786O0005000700024O00040004000500202O0004000400144O000400020002000E2O00150060020100040004313O006002012O0030010400023O00209800040004000D4O00065O00202O0006000600624O00040006000200062O0004006C02013O0004313O006C02012O0030010400064O005201055O00202O0005000500264O0006000A6O00040006000200062O0004006C02013O0004313O006C02012O0030010400013O00122F000500793O00122F0006007A4O007B000400064O00C900046O003001046O006A000500013O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400A602013O0004313O00A602012O003001046O006A000500013O00122O0006007D3O00122O0007007E6O0005000700024O00040004000500202O0004000400184O00040002000200062O000400A602013O0004313O00A602012O003001046O0011010500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O0004000400184O00040002000200062O000400A6020100010004313O00A602012O003001046O0011010500013O00122O000600813O00122O000700826O0005000700024O00040004000500202O0004000400184O00040002000200062O000400A6020100010004313O00A602012O0030010400033O0006630004009A020100010004313O009A02012O0030010400093O00062C010400A602013O0004313O00A602012O0030010400064O005201055O00202O0005000500264O0006000A6O00040006000200062O000400A602013O0004313O00A602012O0030010400013O00122F000500833O00122F000600844O007B000400064O00C900045O00122F000300023O0004313O00D92O010026140002009B030100010004313O009B030100122F000300013O000E0600020004030100030004313O000403012O003001046O006A000500013O00122O000600853O00122O000700866O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400F202013O0004313O00F202012O003001046O0011010500013O00122O000600873O00122O000700886O0005000700024O00040004000500202O0004000400184O00040002000200062O000400F2020100010004313O00F202012O003001046O0011010500013O00122O000600893O00122O0007008A6O0005000700024O00040004000500202O0004000400184O00040002000200062O000400F2020100010004313O00F202012O0030010400023O00209800040004000B4O00065O00202O0006000600224O00040006000200062O000400F202013O0004313O00F202012O0030010400023O00209E00040004008B2O002100040002000200264A010400F2020100100004313O00F202012O003001046O00F5000500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O0004000400144O00040002000200262O000400F40201008E0004313O00F402012O0030010400023O0020B700040004000D4O00065O00202O00060006000E4O00040006000200062O000400F4020100010004313O00F402012O003001046O006A000500013O00122O0006008F3O00122O000700906O0005000700024O00040004000500202O0004000400184O00040002000200062O000400F402013O0004313O00F40201002E7A00920002030100910004313O00020301002EB000940002030100930004313O000203012O0030010400064O005201055O00202O0005000500954O0006000D6O00040006000200062O0004000203013O0004313O000203012O0030010400013O00122F000500963O00122F000600974O007B000400064O00C900045O00122F000200023O0004313O009B0301002614000300AB020100010004313O00AB02012O003001046O006A000500013O00122O000600983O00122O000700996O0005000700024O00040004000500202O00040004001F4O00040002000200062O0004004C03013O0004313O004C03012O003001046O006A000500013O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500202O0004000400184O00040002000200062O0004003D03013O0004313O003D03012O0030010400023O00209800040004000B4O00065O00202O0006000600224O00040006000200062O0004003D03013O0004313O003D03012O0030010400023O00209E00040004008B2O002100040002000200264A0104003D030100070004313O003D03012O003001046O0050000500013O00122O0006009C3O00122O0007009D6O0005000700024O00040004000500202O0004000400144O00040002000200264A010400360301008E0004313O003603012O0030010400033O00066300040040030100010004313O004003012O0030010400093O00066300040040030100010004313O004003012O0030010400023O0020B700040004000D4O00065O00202O00060006000E4O00040006000200062O00040040030100010004313O004003012O0030010400043O00264A0104004C0301004A0004313O004C03012O0030010400064O005201055O00202O0005000500954O0006000D6O00040006000200062O0004004C03013O0004313O004C03012O0030010400013O00122F0005009E3O00122F0006009F4O007B000400064O00C900046O003001046O006A000500013O00122O000600A03O00122O000700A16O0005000700024O00040004000500202O00040004001F4O00040002000200062O0004009903013O0004313O009903012O0030010400023O00209800040004000D4O00065O00202O0006000600624O00040006000200062O0004006E03013O0004313O006E03012O0030010400023O00209800040004000B4O00065O00202O0006000600224O00040006000200062O0004006E03013O0004313O006E03012O00300104000E3O00204E0104000400A22O000A01040001000200264A0104006E030100150004313O006E03012O0030010400023O00209E0004000400A32O00210004000200020006630004008D030100010004313O008D03012O0030010400023O00209E0004000400632O002100040002000200264A01040099030100710004313O009903012O0030010400023O00209E00040004008B2O002100040002000200264A01040099030100290004313O009903012O003001046O00E0000500013O00122O000600A43O00122O000700A56O0005000700024O00040004000500202O0004000400144O0004000200024O0005000F3O00062O0005008D030100040004313O008D03012O003001046O0050000500013O00122O000600A63O00122O000700A76O0005000700024O00040004000500202O0004000400A84O00040002000200264A01040099030100150004313O009903012O0030010400064O005201055O00202O0005000500954O0006000D6O00040006000200062O0004009903013O0004313O009903012O0030010400013O00122F000500A93O00122F000600AA4O007B000400064O00C900045O00122F000300023O0004313O00AB020100263B0102009F0301006A0004313O009F0301002EB000AB00B8040100AC0004313O00B804012O003001036O006A000400013O00122O000500AD3O00122O000600AE6O0004000600024O00030003000400202O00030003001F4O00030002000200062O000300F303013O0004313O00F303012O0030010300053O002614000300DC030100020004313O00DC03012O003001036O006A000400013O00122O000500AF3O00122O000600B06O0004000600024O00030003000400202O0003000300184O00030002000200062O000300D203013O0004313O00D203012O0030010300023O00206E00030003000F4O00055O00202O00050005000E4O0003000500024O000400023O00202O0004000400B14O00040002000200202O00040004001900062O000300D2030100040004313O00D203012O0030010300023O00209800030003000D4O00055O00202O00050005000E4O00030005000200062O000300D203013O0004313O00D203012O003001036O006A000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400202O0003000300184O00030002000200062O000300DF03013O0004313O00DF03012O003001036O006A000400013O00122O000500B43O00122O000600B56O0004000600024O00030003000400202O0003000300184O00030002000200062O000300DF03013O0004313O00DF03012O0030010300043O00264A010300F3030100290004313O00F303012O0030010300064O007300045O00202O0004000400B64O000500106O000600066O0007000B3O00202O00070007004900122O000900746O0007000900024O000700076O00030007000200062O000300EE030100010004313O00EE0301002EB000B700F3030100B80004313O00F303012O0030010300013O00122F000400B93O00122F000500BA4O007B000300054O00C900036O003001036O006A000400013O00122O000500BB3O00122O000600BC6O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003002E04013O0004313O002E04012O0030010300053O000EF40019002E040100030004313O002E04012O003001036O006A000400013O00122O000500BD3O00122O000600BE6O0004000600024O00030003000400202O0003000300184O00030002000200062O0003002E04013O0004313O002E04012O0030010300023O00209800030003000D4O00055O00202O00050005000E4O00030005000200062O0003002E04013O0004313O002E04012O0030010300023O00206E00030003000F4O00055O00202O00050005000E4O0003000500024O000400023O00202O0004000400B14O00040002000200202O00040004001900062O0003002E040100040004313O002E04012O0030010300064O005401045O00202O0004000400B64O000500106O000600066O0007000B3O00202O00070007004900122O000900746O0007000900024O000700076O00030007000200062C0103002E04013O0004313O002E04012O0030010300013O00122F000400BF3O00122F000500C04O007B000300054O00C900036O003001036O006A000400013O00122O000500C13O00122O000600C26O0004000600024O00030003000400202O00030003001F4O00030002000200062O000300B704013O0004313O00B704012O003001036O006A000400013O00122O000500C33O00122O000600C46O0004000600024O00030003000400202O0003000300184O00030002000200062O000300B704013O0004313O00B704012O003001036O006A000400013O00122O000500C53O00122O000600C66O0004000600024O00030003000400202O0003000300184O00030002000200062O0003005604013O0004313O005604012O0030010300023O00209800030003000D4O00055O00202O00050005000E4O00030005000200062O0003005604013O0004313O005604012O0030010300113O00062C0103007404013O0004313O007404012O0030010300023O00209800030003000B4O00055O00202O00050005000E4O00030005000200062O0003006A04013O0004313O006A04012O0030010300113O00062C0103006A04013O0004313O006A04012O003001036O0011010400013O00122O000500C73O00122O000600C86O0004000600024O00030003000400202O0003000300C94O00030002000200062O00030074040100010004313O007404012O003001036O0011010400013O00122O000500CA3O00122O000600CB6O0004000600024O00030003000400202O0003000300184O00030002000200062O000300B7040100010004313O00B704012O0030010300023O00202E01030003000F4O00055O00202O00050005000E4O0003000500024O000400023O00202O0004000400B14O00040002000200062O0003008F040100040004313O008F04012O0030010300023O00209800030003000D4O00055O00202O0005000500CC4O00030005000200062O000300B704013O0004313O00B704012O0030010300023O00208800030003000F4O00055O00202O0005000500CC4O0003000500024O000400023O00202O0004000400B14O00040002000200062O000300B7040100040004313O00B704012O00300103000B3O0020510103000300CD4O00055O00202O0005000500CE4O00030005000200262O000300A3040100100004313O00A304012O0030010300123O000663000300B7040100010004313O00B704012O003001036O0011010400013O00122O000500CF3O00122O000600D06O0004000600024O00030003000400202O0003000300184O00030002000200062O000300B7040100010004313O00B70401002E2101D10014000100D10004313O00B704012O0030010300064O005401045O00202O0004000400B64O000500106O000600066O0007000B3O00202O00070007004900122O000900746O0007000900024O000700076O00030007000200062C010300B704013O0004313O00B704012O0030010300013O00122F000400D23O00122F000500D34O007B000300054O00C900035O00122F000200103O002E7A00D50010000100D40004313O0010000100261400020010000100100004313O0010000100122F000300014O0036010400043O002614000300BE040100010004313O00BE040100122F000400013O000E89000100C5040100040004313O00C50401002EB000D6005E050100D70004313O005E0501002E2101D8001A000100D80004313O00DF04012O003001056O006A000600013O00122O000700D93O00122O000800DA6O0006000800024O00050005000600202O00050005001F4O00050002000200062O000500DF04013O0004313O00DF04012O0030010500064O00B300065O00202O0006000600DB4O000700076O00050007000200062O000500DA040100010004313O00DA0401002EB000DC00DF040100DD0004313O00DF04012O0030010500013O00122F000600DE3O00122F000700DF4O007B000500074O00C900055O002E2101E0007E000100E00004313O005D05012O003001056O006A000600013O00122O000700E13O00122O000800E26O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005D05013O0004313O005D05012O0030010500043O000EDC0010005D050100050004313O005D05012O00300105000B3O00209E0005000500E300122F000700E44O0065000500070002002650010500F9040100100004313O00F904012O00300105000B3O00209E0005000500E52O00210005000200020026440005005D050100E40004313O005D05012O0030010500053O0026440005005D050100190004313O005D05012O003001056O006A000600013O00122O000700E63O00122O000800E76O0006000800024O00050005000600202O0005000500184O00050002000200062O0005001B05013O0004313O001B05012O0030010500023O00209800050005000D4O00075O00202O00070007000E4O00050007000200062O0005001405013O0004313O001405012O0030010500023O0020B700050005000B4O00075O00202O0007000700E84O00050007000200062O0005004C050100010004313O004C05012O0030010500023O0020B700050005000B4O00075O00202O00070007000E4O00050007000200062O0005004C050100010004313O004C05012O003001056O006A000600013O00122O000700E93O00122O000800EA6O0006000800024O00050005000600202O0005000500184O00050002000200062O0005003805013O0004313O003805012O0030010500023O00209800050005000D4O00075O00202O0007000700624O00050007000200062O0005003105013O0004313O003105012O0030010500023O00209E0005000500632O0021000500020002000E4A0074004C050100050004313O004C05012O0030010500023O0020B700050005000B4O00075O00202O0007000700624O00050007000200062O0005004C050100010004313O004C05012O003001056O0011010600013O00122O000700EB3O00122O000800EC6O0006000800024O00050005000600202O0005000500184O00050002000200062O0005005D050100010004313O005D05012O003001056O0011010600013O00122O000700ED3O00122O000800EE6O0006000800024O00050005000600202O0005000500184O00050002000200062O0005005D050100010004313O005D05012O0030010500064O009900065O00202O0006000600EF4O000700086O0009000B3O00202O0009000900F000122O000B00106O0009000B00024O000900096O00050009000200062O0005005D05013O0004313O005D05012O0030010500013O00122F000600F13O00122F000700F24O007B000500074O00C900055O00122F000400023O000E06000200C1040100040004313O00C10401002EB000F40095050100F30004313O009505012O003001056O006A000600013O00122O000700F53O00122O000800F66O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009505013O0004313O009505012O003001056O0011010600013O00122O000700F73O00122O000800F86O0006000800024O00050005000600202O0005000500184O00050002000200062O00050095050100010004313O009505012O0030010500023O00209800050005000B4O00075O00202O0007000700624O00050007000200062O0005009505013O0004313O009505012O0030010500133O0020C10005000500F94O0005000200024O000600023O00202O0006000600B14O00060002000200202O00060006001900062O00050095050100060004313O009505012O0030010500053O000EDC00290095050100050004313O009505012O0030010500064O005201065O00202O0006000600FA4O000700146O00050007000200062O0005009505013O0004313O009505012O0030010500013O00122F000600FB3O00122F000700FC4O007B000500074O00C900055O00122F000200073O0004313O001000010004313O00C104010004313O001000010004313O00BE04010004313O001000010004313O009F05010004313O000B00010004313O009F05010004313O000200012O0053012O00017O00AC3O00028O00026O00F03F025O00388C40025O003EA540025O00C2A040025O0067B240025O00F0B240025O00DDB040025O00088440025O00BBB240025O00A4AB40025O00809240030E3O00D0ED242A89F0E4392097F9E63C2F03053O00C491835043030A3O0049734361737461626C6503113O0052756E6963506F77657244656669636974026O004440030E3O00416E74694D616769635368652O6C025O00C4AD40025O00A7B24003233O001FBE120115E919B905370BE01BBC0A4810E119B839180AE1118F070B0CE111BE15484A03063O00887ED0666878030D3O005984DA4A82533A587BB0C14DAA03083O003118EAAE23CF325D025O00805140030C3O002DE1EE817C05FEFC9C7803FC03053O00116C929DE8030B3O004973417661696C61626C6503063O0042752O66557003123O004272656174686F6653696E647261676F736103113O006ECE04E238AD59F101E32A9F4EC204E22103063O00C82BA3748D4F03073O0043686172676573027O004003123O009D243882A4FCECB905348DB4E6E2B8392E8203073O0083DF565DE3D09403083O0042752O66446F776E03113O0050692O6C61726F6646726F737442752O66030D3O00416E74694D616769635A6F6E65025O0092AA40025O004EA14003223O00E24BA2BF10B4E44CB58907BAED40F6BE14B2EB7AA6A414BADC44B5A214BAED56F6E203063O00D583252OD67D030C3O000E2432B3E8282C07B3E0353F03053O0081464B45DF03073O0049735265616479030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O66030C3O0069C9FFE068EA54CAE7E073E103063O008F26AB93891C030C3O00FF80B5FA17E6C6D196B0FC0D03073O00B4B0E2D9936383030D3O00E3B0230BD2AB2001F5AB2014C703043O0067B3D94F030C3O00432O6F6C646F776E446F776E03123O004B692O6C696E674D616368696E6542752O66025O00FAA340030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E676503213O0042B80BD94882A475B510D45298E342BE1BDD7E9CB143B823D44298AA45B90F951703073O00C32AD77CB521EC025O001CA240025O003C9E40025O00F2AA40026O00104003113O0081D3C0CEDBB240BFD3DED2FEA84BA7D3DF03073O0025D3B6ADA1A9C103123O00D52848D83C73B6F10944D72C69B8F0355ED803073O00D9975A2DB9481B030C3O00EC7EEB1B42C66EE6065FCC7203053O0036A31C8772025O00149540025O0040954003113O0052656D6F7273656C652O7357696E746572030E3O004973496E4D656C2O6552616E6765026O00204003273O003ADE508D5C6C2DD758915D403FD253964B6D68D35485464038C9548D717E2BCF548D406C68890D03063O001F48BB3DE22E025O0058884003113O00F1034EDD556D21CF0350C170772AD7035103073O0044A36623B2271E030C3O009172D6CE17B09110AA79D5C903083O0071DE10BAA763D5E3026O000840025O00EEA240025O00BC914003273O003C0BF6F93C1DFEFA2B1DE8C93907F5E22B1CBBFE2709F3C93E1CF2F9110FF8E22701F5E56E5CA903043O00964E6E9B025O0068B240026O00A740030E3O003BF70BE115FA06C318ED0BEC1FFE03043O00827C9B6A03123O00F7D9F3AEB7FE73B9E6C2F8ABB1F77BB0C6CA03083O00DFB5AB96CFC3961C030C3O006338EFA71D4928E2BA00433403053O00692C5A83CE030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O005940025O00EAB140025O001EA04003243O00F8ECB3BA013FF3DFB3BD1E3FF1E3B7F90037F8E88DA91A37F0DFB3BA1C37F0EEA1F9596C03063O005E9F80D2D968030B3O0076EB09AC4B4CED6859F22O03083O001A309966DF3F1F99030C3O002D42E1FA1645FFF21649E2FD03043O009362208D03123O003A51E6CB125E441E70EAC402444A1F4CF0CB03073O002B782383AA663603123O00761482B7B1B88B52358EB8A1A285530994B703073O00E43466E7D6C5D0030F3O00432O6F6C646F776E52656D61696E73030B3O0046726F7374537472696B65025O000AAC40025O005EA94003213O0018F27AD9FEB40AC20CE97ECFAA8310D116DF65D8E38426D71DF47CC5E49859874A03083O00B67E8015AA8AEB79025O008C9B40025O006C9B40025O00C6AA40025O00CEA040025O00EAAD40025O00E8A740030B3O00ADC83AF59220241482D13003083O0066EBBA5586E6735003123O00751E3B5E66DC2D513F375176C62350032D5E03073O0042376C5E3F12B403123O00369F803633511B8BB63E295D068C8238345803063O003974EDE55747025O00406F40025O00307740025O0016B140025O0068954003213O00ACA3E2F463D154BEA3E4EC72AE4FA3B6E5D867FC4EA58EECE463E748A4A2ADB62103073O0027CAD18D87178E025O007EAB40025O007AA840030B3O00D921061926CBEB2100013703063O00989F53696A5203123O00A3D454F3DD548EC062FBC75893C756FDDA5D03063O003CE1A63192A9030C4O001C2O2315023D1F3B230E0903063O00674F7E4F4A61025O0084B340025O0071B24003213O00BC6DDC604A25A96BC17A551FFA77DA745625AA6DDA7C611BB96BDA7C5009FA2E8B03063O007ADA1FB3133E025O006EAF40030E3O002A55363D2CF90178332824F60E5C03063O00986D39575E45030C3O00D6D5062OAAD746A9EDDE05AD03083O00C899B76AC3DEB23403123O0010F18D3C5D523DE5BB34475E20E28F325A5B03063O003A5283E85D2903123O00A145D51449378C51E31C533B9156D71A4E3E03063O005FE337B0753D025O00606E40025O00A4B14003233O001F722248A219721C4AAF0E7F2D48AE58762A4CA3276E3142A4277F205FA21770300BF303053O00CB781E432B025O003EAD40025O00389D40030E3O00D6294CECD0F0296CEBCFF02B4EEA03053O00B991452D8F03123O00A80D1CA7C882101F95D5841B0BA7DB850C1803053O00BCEA7F79C603123O001A2016822C3A1C850B3B1D872A33148C2B3303043O00E3585273025O00A07240025O00ECA94003243O004413BBA40B724F20BBA314724D1CBFE70A7A441785B7107A4C20BBA4167A4C11A9E7532303063O0013237FDAC7620030032O00122F3O00014O00362O0100023O0026143O0029030100020004313O0029030100261400010004000100010004313O0004000100122F000200013O000E06000100F7000100020004313O00F7000100122F000300014O0036010400043O002EB00003000B000100040004313O000B0001000E060001000B000100030004313O000B000100122F000400013O00263B01040014000100010004313O00140001002EB0000600EE000100050004313O00EE000100122F000500013O00263B01050019000100020004313O00190001002E7A0007001B000100080004313O001B000100122F000400023O0004313O00EE000100261400050015000100010004313O001500012O003001065O00062C0106009800013O0004313O009800012O0030010600013O00062C0106009800013O0004313O0098000100122F000600014O0036010700073O002EB0000900250001000A0004313O0025000100261400060025000100010004313O0025000100122F000700013O00263B0107002E000100010004313O002E0001002E7A000B002A0001000C0004313O002A00012O0030010800024O006A000900033O00122O000A000D3O00122O000B000E6O0009000B00024O00080008000900202O00080008000F4O00080002000200062O0008004B00013O0004313O004B00012O0030010800043O00209E0008000800102O0021000800020002000EDC0011004B000100080004313O004B00012O0030010800054O0092000900023O00202O0009000900124O000A00066O0008000A000200062O00080046000100010004313O00460001002EB00014004B000100130004313O004B00012O0030010800033O00122F000900153O00122F000A00164O007B0008000A4O00C900086O0030010800024O006A000900033O00122O000A00173O00122O000B00186O0009000B00024O00080008000900202O00080008000F4O00080002000200062O0008009800013O0004313O009800012O0030010800043O00209E0008000800102O0021000800020002000EDC00190098000100080004313O009800012O0030010800024O006A000900033O00122O000A001A3O00122O000B001B6O0009000B00024O00080008000900202O00080008001C4O00080002000200062O0008009800013O0004313O009800012O0030010800043O00209800080008001D4O000A00023O00202O000A000A001E4O0008000A000200062O0008007500013O0004313O007500012O0030010800024O00F5000900033O00122O000A001F3O00122O000B00206O0009000B00024O00080008000900202O0008000800214O00080002000200262O00080086000100220004313O008600012O0030010800024O0011010900033O00122O000A00233O00122O000B00246O0009000B00024O00080008000900202O00080008001C4O00080002000200062O00080098000100010004313O009800012O0030010800043O0020980008000800254O000A00023O00202O000A000A00264O0008000A000200062O0008009800013O0004313O009800012O0030010800054O0092000900023O00202O0009000900274O000A00076O0008000A000200062O0008008F000100010004313O008F0001002E7A00280098000100290004313O009800012O0030010800033O0012220109002A3O00122O000A002B6O0008000A6O00085O00044O009800010004313O002A00010004313O009800010004313O002500012O0030010600024O006A000700033O00122O0008002C3O00122O0009002D6O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600EC00013O0004313O00EC00012O0030010600083O00209800060006002F4O000800023O00202O0008000800304O00060008000200062O000600EC00013O0004313O00EC00012O0030010600093O000EF4002200EC000100060004313O00EC00012O0030010600024O006A000700033O00122O000800313O00122O000900326O0007000900024O00060006000700202O00060006001C4O00060002000200062O000600D800013O0004313O00D800012O0030010600024O006A000700033O00122O000800333O00122O000900346O0007000900024O00060006000700202O00060006001C4O00060002000200062O000600EC00013O0004313O00EC00012O0030010600024O0011010700033O00122O000800353O00122O000900366O0007000900024O00060006000700202O0006000600374O00060002000200062O000600D8000100010004313O00D800012O0030010600043O00209800060006001D4O000800023O00202O0008000800264O00060008000200062O000600EC00013O0004313O00EC00012O0030010600043O0020980006000600254O000800023O00202O0008000800384O00060008000200062O000600EC00013O0004313O00EC0001002E2101390014000100390004313O00EC00012O0030010600054O0074000700023O00202O00070007003A4O000800096O000A00083O00202O000A000A003B4O000C00023O00202O000C000C003A4O000A000C00024O000A000A6O0006000A000200062O000600EC00013O0004313O00EC00012O0030010600033O00122F0007003C3O00122F0008003D4O007B000600084O00C900065O00122F000500023O0004313O0015000100263B010400F2000100020004313O00F20001002E7A003E00100001003F0004313O0010000100122F000200023O0004313O00F700010004313O001000010004313O00F700010004313O000B0001002E2101400068000100400004313O005F2O010026140002005F2O0100410004313O005F2O012O0030010300024O006A000400033O00122O000500423O00122O000600436O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003001C2O013O0004313O001C2O012O0030010300024O0011010400033O00122O000500443O00122O000600456O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003001C2O0100010004313O001C2O012O0030010300024O0011010400033O00122O000500463O00122O000600476O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003001C2O0100010004313O001C2O012O00300103000A3O0006630003001E2O0100010004313O001E2O01002E7A0049002F2O0100480004313O002F2O012O0030010300054O0099000400023O00202O00040004004A4O000500066O000700083O00202O00070007004B00122O0009004C6O0007000900024O000700076O00030007000200062O0003002F2O013O0004313O002F2O012O0030010300033O00122F0004004D3O00122F0005004E4O007B000300054O00C900035O002E7A004F002F030100130004313O002F03012O0030010300024O006A000400033O00122O000500503O00122O000600516O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003002F03013O0004313O002F03012O0030010300024O006A000400033O00122O000500523O00122O000600536O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003002F03013O0004313O002F03012O0030010300093O000EF40054002F030100030004313O002F03012O00300103000B3O00062C0103002F03013O0004313O002F03012O0030010300054O0012000400023O00202O00040004004A4O000500066O000700083O00202O00070007004B00122O0009004C6O0007000900024O000700076O00030007000200062O000300592O0100010004313O00592O01002E21015500D82O0100560004313O002F03012O0030010300033O001222010400573O00122O000500586O000300056O00035O00044O002F030100263B010200632O0100220004313O00632O01002E7A005900070201005A0004313O0007020100122F000300013O000E0600012O00020100030004314O00020100122F000400013O002614000400F92O0100010004313O00F92O012O0030010500024O006A000600033O00122O0007005B3O00122O0008005C6O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500A72O013O0004313O00A72O012O0030010500093O000EF4002200A72O0100050004313O00A72O012O00300105000C3O00062C010500A72O013O0004313O00A72O012O0030010500024O0011010600033O00122O0007005D3O00122O0008005E6O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500A72O0100010004313O00A72O012O0030010500024O006A000600033O00122O0007005F3O00122O000800606O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500A72O013O0004313O00A72O012O0030010500043O0020980005000500254O000700023O00202O0007000700264O00050007000200062O000500A72O013O0004313O00A72O012O0030010500054O0012000600023O00202O0006000600614O000700086O000900083O00202O00090009006200122O000B00636O0009000B00024O000900096O00050009000200062O000500A22O0100010004313O00A22O01002E7A006400A72O0100650004313O00A72O012O0030010500033O00122F000600663O00122F000700674O007B000500074O00C900056O0030010500024O006A000600033O00122O000700683O00122O000800696O0006000800024O00050005000600202O00050005002E4O00050002000200062O000500F82O013O0004313O00F82O012O0030010500093O002614000500F82O0100020004313O00F82O012O00300105000C3O00062C010500F82O013O0004313O00F82O012O0030010500024O006A000600033O00122O0007006A3O00122O0008006B6O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500F82O013O0004313O00F82O012O0030010500024O006A000600033O00122O0007006C3O00122O0008006D6O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500F82O013O0004313O00F82O012O0030010500043O0020980005000500254O000700023O00202O0007000700264O00050007000200062O000500F82O013O0004313O00F82O012O0030010500043O0020980005000500254O000700023O00202O00070007001E4O00050007000200062O000500F82O013O0004313O00F82O012O0030010500024O0050000600033O00122O0007006E3O00122O0008006F6O0006000800024O00050005000600202O0005000500704O0005000200022O00300106000D3O00060A000600F82O0100050004313O00F82O012O0030010500054O0011000600023O00202O0006000600714O000700086O000900083O00202O00090009003B4O000B00023O00202O000B000B00714O0009000B00024O000900096O00050009000200062O000500F32O0100010004313O00F32O01002E7A007200F82O0100730004313O00F82O012O0030010500033O00122F000600743O00122F000700754O007B000500074O00C900055O00122F000400023O00263B010400FD2O0100020004313O00FD2O01002EB0007600672O0100770004313O00672O0100122F000300023O0004314O0002010004313O00672O0100263B01030004020100020004313O00040201002EB0007800642O0100790004313O00642O0100122F000200543O0004313O000702010004313O00642O0100263B0102000B020100540004313O000B0201002E21017A00860001007B0004313O008F02012O0030010300024O006A000400033O00122O0005007C3O00122O0006007D6O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003003702013O0004313O003702012O0030010300093O00261400030037020100020004313O003702012O00300103000C3O00062C0103003702013O0004313O003702012O0030010300024O006A000400033O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003003702013O0004313O003702012O0030010300043O0020980003000300254O000500023O00202O00050005001E4O00030005000200062O0003003702013O0004313O003702012O0030010300024O00E0000400033O00122O000500803O00122O000600816O0004000600024O00030003000400202O0003000300704O0003000200024O0004000D3O00062O00040039020100030004313O00390201002E2101820016000100830004313O004D0201002EB00085004D020100840004313O004D02012O0030010300054O0074000400023O00202O0004000400714O000500066O000700083O00202O00070007003B4O000900023O00202O0009000900714O0007000900024O000700076O00030007000200062O0003004D02013O0004313O004D02012O0030010300033O00122F000400863O00122F000500874O007B000300054O00C900035O002EB00089008E020100880004313O008E02012O0030010300024O006A000400033O00122O0005008A3O00122O0006008B6O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003008E02013O0004313O008E02012O0030010300093O0026140003008E020100020004313O008E02012O00300103000C3O00062C0103008E02013O0004313O008E02012O0030010300024O0011010400033O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003008E020100010004313O008E02012O0030010300024O006A000400033O00122O0005008E3O00122O0006008F6O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003008E02013O0004313O008E02012O0030010300043O0020980003000300254O000500023O00202O0005000500264O00030005000200062O0003008E02013O0004313O008E0201002EB00091008E020100900004313O008E02012O0030010300054O0074000400023O00202O0004000400714O000500066O000700083O00202O00070007003B4O000900023O00202O0009000900714O0007000900024O000700076O00030007000200062O0003008E02013O0004313O008E02012O0030010300033O00122F000400923O00122F000500934O007B000300054O00C900035O00122F000200413O002E7A00040007000100940004313O0007000100261400020007000100020004313O000700012O0030010300024O006A000400033O00122O000500953O00122O000600966O0004000600024O00030003000400202O00030003002E4O00030002000200062O000300E302013O0004313O00E302012O0030010300093O000EF4002200E3020100030004313O00E302012O00300103000C3O00062C010300E302013O0004313O00E302012O0030010300024O006A000400033O00122O000500973O00122O000600986O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300E302013O0004313O00E302012O0030010300024O006A000400033O00122O000500993O00122O0006009A6O0004000600024O00030003000400202O00030003001C4O00030002000200062O000300E302013O0004313O00E302012O0030010300043O0020980003000300254O000500023O00202O0005000500264O00030005000200062O000300E302013O0004313O00E302012O0030010300043O0020980003000300254O000500023O00202O00050005001E4O00030005000200062O000300E302013O0004313O00E302012O0030010300024O0050000400033O00122O0005009B3O00122O0006009C6O0004000600024O00030003000400202O0003000300704O0003000200022O00300104000D3O00060A000400E3020100030004313O00E30201002E7A009D00E30201009E0004313O00E302012O0030010300054O0099000400023O00202O0004000400614O000500066O000700083O00202O00070007006200122O000900636O0007000900024O000700076O00030007000200062O000300E302013O0004313O00E302012O0030010300033O00122F0004009F3O00122F000500A04O007B000300054O00C900035O002E7A00A20024030100A10004313O002403012O0030010300024O006A000400033O00122O000500A33O00122O000600A46O0004000600024O00030003000400202O00030003002E4O00030002000200062O0003002403013O0004313O002403012O0030010300093O000EF400220024030100030004313O002403012O00300103000C3O00062C0103002403013O0004313O002403012O0030010300024O006A000400033O00122O000500A53O00122O000600A66O0004000600024O00030003000400202O00030003001C4O00030002000200062O0003002403013O0004313O002403012O0030010300043O0020980003000300254O000500023O00202O00050005001E4O00030005000200062O0003002403013O0004313O002403012O0030010300024O0050000400033O00122O000500A73O00122O000600A86O0004000600024O00030003000400202O0003000300704O0003000200022O00300104000D3O00060A00040024030100030004313O00240301002E7A00A90024030100AA0004313O002403012O0030010300054O0099000400023O00202O0004000400614O000500066O000700083O00202O00070007006200122O000900636O0007000900024O000700076O00030007000200062O0003002403013O0004313O002403012O0030010300033O00122F000400AB3O00122F000500AC4O007B000300054O00C900035O00122F000200223O0004313O000700010004313O002F03010004313O000400010004313O002F03010026143O0002000100010004313O0002000100122F000100014O0036010200023O00122F3O00023O0004313O000200012O0053012O00017O00B63O00028O00025O00109240025O0040A940027O0040025O00488840025O00C4A340030C3O0079A713FF15195F73A405E00803073O003831C864937C7703073O004973526561647903083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O66030A3O00446562752O66446F776E03103O0046726F73744665766572446562752O6603063O0042752O66557003083O0052696D6542752O6603073O0048617354696572026O003E40025O0042AD40025O0036A540030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E6765031D3O00C431A8FCC530B8CFCE32BEE3D87EB0F2C037ABF5DE3FABF9C330FFA19803043O0090AC5EDF030E3O002O03A3442D0EAE662019A349270A03043O0027446FC203093O00F7B0E6CB78B9D5AEE203063O00D7B6C687A719030B3O004973417661696C61626C65030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66026O001440030D3O00446562752O6652656D61696E732O033O00474344026O000840026O00F03F025O004EB340025O00CC9A40030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O005940031F3O008A45EB4B8448E6778C4DFC49834AEF08824BE641994CF8499940E546CD18BC03043O0028ED298A030B3O00E166F5EB5EF460E8F141C203053O002AA7149A9803043O0052756E65030F3O0079F6A356652458F7AC45532D4BFAA703063O00412A9EC22211030E3O003D2B530F24EC17CF1E3153022EE803083O008E7A47326C4D8D7B030B3O0046726F7374537472696B65030E3O004973496E4D656C2O6552616E6765025O003EA740025O0048B140031C3O0013B0F00B2F2AB1EB0A321EA7BF173919ABEB1D2914B6F6173555F3A703053O005B75C29F78025O00A4A640025O00F0904003113O00B7C02AEEB60DBA4C80D634D6AD10AB459703083O0020E5A54781C47EDF030E3O00E488D08984C7CA87C3B295DAD18403063O00B5A3E9A42OE1025O00C05940025O00EEAF40025O00B8A740025O002CA44003113O0052656D6F7273656C652O7357696E746572026O00204003213O00428E337842983B7B55982D484782306355997E785287376355993F63598430370203043O001730EB5E030C3O0054D5CF515E3DD55ED6D94E4303073O00B21CBAB83D375303093O0042752O66537461636B030B3O0042752O6652656D61696E7303113O0050692O6C61726F6646726F737442752O66025O00E06F40026O008340031C3O00CCC25030FB00F2FBCF4B3DE11AB5CBCF4B35E60BE7C5D94E33FC4EA103073O0095A4AD275C926E030B3O00D5351F0C0E28E73519141F03063O007B9347707F7A03113O004465617468416E64446563617942752O66025O001CAF40025O00F8A640025O009EAD40025O004CB240031B3O00CADF8D6252F3DE96634FC7C8C27E44C0C4967454CDD98B7E488C9B03053O0026ACADE211030B3O00DA1B5068FCCF1D4D72E3F903053O00889C693F1B030E3O003C807837128D75151F9A783A188903043O00547BEC19025O00DEA640025O00388E40030C3O004361737454617267657449662O033O00FD8AB203063O00D590EBCA77CC031C3O00250AD1393C1C5E370AD7212D63422114D73E2D314C3711D12468701F03073O002D4378BE4A4843030C3O00082DFAA9F086E9CB2C23FEB103083O008940428DC599E88E025O00B88340025O00E2A640031D3O000BDF35AA810DD71DA48402C336E68701DC2BB28D11D136AF870D9071F203053O00E863B042C6030A3O00C323240F6F88EB2DF82403083O004C8C4148661BED99025O00507540025O00E8AE40030A3O004F626C697465726174652O033O0047DB0E03073O00DE2ABA76B2B761031A3O0052EE488349E9568B49E904855FE04D9E58FE459E54E34ACA0EBA03043O00EA3D8C24026O001040025O00EAB240025O00689740030C3O00F68468332B28D9A9733E313203063O0046BEEB1F5F42030A3O0052756E6963506F776572026O003940031D3O00B2ED0DEAECB4E525E4E9BBF10EA6EAB8EE13F2E0A8E30EEFEAB4A248B003053O0085DA827A86030D3O001DEDE0C5D2A60C33EDF1C1D2B703073O00585C9F83A4BCC3025O00809440025O0056B340030D3O00417263616E65546F2O72656E74025O00408A40025O00EC9240031E3O00813CBC4AD9EEE29421AD59D2E5C9C021BD47DEFFD8922FAB42D8E59DD27603073O00BDE04EDF2BB78B025O0093B140025O00C09840030E3O0009F08B15C82FF0AB12D72FF2891303053O00A14E9CEA76025O00F8AC40025O007DB040031F3O00A0BBC8DFAEB6C5E3A6B3DFDDA9B4CC9CA8B5C5D5B3B2DBDDB3BEC6D2E7E49903043O00BCC7D7A9030C3O00321229143CFF2338113F0B2103073O00447A7D5E785591025O00C0AC40025O00307E40031D3O001F13D852C1D7BD281EC35FDBCDFA181EC3572ODCA81608C651C699E84703073O00DA777CAF3EA8B9030E3O0082FC49C7ACF144E5A1E649CAA6F503043O00A4C59028025O00549640025O00F2A840031F3O0084FCAB88D4B78FCFAB8FCBB78DF3AFCBD2B48FF9BE8ECFB797F9A5859DE4D103063O00D6E390CAEBBD025O008AA440025O00707E40030B3O00CBB788680480472EE4AE8203083O005C8DC5E71B70D333030E3O00C1F38BA0D8E7F3ABA7C7E7F189A603053O00B1869FEAC3031C3O00BBF930B3DD82F82BB2C0B6EE7FAFCBB1E22BA5DBBCFF36AFC7FDB96B03053O00A9DD8B5FC0025O0014B140025O00B2A640025O00B89140025O00088040030E3O006A1D2DEC441020CE49072DE14E1403043O008F2D714C031E3O00BFB41D3FB1B91003B9BC0A3DB6BB197CB7BA1035ACBD0E3DACB11332F8E003043O005C2OD87C030A3O007430A049E95E20AD54F803053O009D3B52CC20025O00D2AA40025O00ECA3402O033O00353FFB03083O00D1585E839A898AB3031A3O0027A3C8750A262O233CA484731C2F38362DB3C568172C3F6279F103083O004248C1A41C7E4351025O00707940025O00349F40030B3O00C13EA74B3265E435BC502303063O0016874CC83846030B3O0046726F7374736379746865031B3O008B22F73749F28E29EC2C58A18232F42D49E49F31EC2D52EFCD61AA03063O0081ED5098443D009E032O00122F3O00013O002EB0000200DC000100030004313O00DC00010026143O00DC000100040004313O00DC0001002EB000050044000100060004313O004400012O00302O016O006A000200013O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200062O0001004400013O0004313O004400012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O0001004400013O0004313O004400012O00302O0100033O0020B700010001000C4O00035O00202O00030003000D4O00010003000200062O00010030000100010004313O003000012O00302O0100023O00209800010001000E4O00035O00202O00030003000F4O00010003000200062O0001004400013O0004313O004400012O00302O0100023O0020C200010001001000122O000300113O00122O000400046O00010004000200062O0001004400013O0004313O004400012O00302O0100043O00066300010044000100010004313O00440001002E7A00130044000100120004313O004400012O00302O0100054O007400025O00202O0002000200144O000300046O000500033O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O0001004400013O0004313O004400012O00302O0100013O00122F000200163O00122F000300174O007B000100034O00C900016O00302O016O006A000200013O00122O000300183O00122O000400196O0002000400024O00010001000200202O0001000100094O00010002000200062O0001007A00013O0004313O007A00012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O0001007A00013O0004313O007A00012O00302O0100063O00066300010074000100010004313O007400012O00302O016O006A000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200202O00010001001C4O00010002000200062O0001007C00013O0004313O007C00012O00302O0100033O0020E400010001001D4O00035O00202O00030003001E4O00010003000200262O0001007C0001001F0004313O007C00012O00302O0100033O0020FB0001000100204O00035O00202O00030003001E4O0001000300024O000200023O00202O0002000200214O00020002000200202O00020002002200062O0001007C000100020004313O007C00012O00302O0100043O00062C2O01007A00013O0004313O007A00012O00302O0100073O000E4A0023007C000100010004313O007C0001002E2101240013000100250004313O008D00012O00302O0100054O009900025O00202O0002000200264O000300046O000500033O00202O00050005002700122O000700286O0005000700024O000500056O00010005000200062O0001008D00013O0004313O008D00012O00302O0100013O00122F000200293O00122F0003002A4O007B000100034O00C900016O00302O016O006A000200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100DB00013O0004313O00DB00012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O000100DB00013O0004313O00DB00012O00302O0100023O00209E00010001002D2O00210001000200020026502O0100B7000100040004313O00B700012O00302O0100043O000663000100B7000100010004313O00B700012O00302O0100033O0020E300010001001D4O00035O00202O00030003001E4O00010003000200262O000100DB0001001F0004313O00DB00012O00302O016O006A000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200202O00010001001C4O00010002000200062O000100DB00013O0004313O00DB00012O00302O0100083O000663000100DB000100010004313O00DB00012O00302O016O006A000200013O00122O000300303O00122O000400316O0002000400024O00010001000200202O00010001001C4O00010002000200062O000100C700013O0004313O00C700012O00302O0100093O002614000100DB000100230004313O00DB00012O00302O0100054O007300025O00202O0002000200324O0003000A6O000400046O000500033O00202O00050005003300122O0007001F6O0005000700024O000500056O00010005000200062O000100D6000100010004313O00D60001002EB0003500DB000100340004313O00DB00012O00302O0100013O00122F000200363O00122F000300374O007B000100034O00C900015O00122F3O00223O002E7A0039007B2O0100380004313O007B2O010026143O007B2O0100010004313O007B2O012O00302O016O006A000200013O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100F700013O0004313O00F700012O00302O0100093O000E4A002200F9000100010004313O00F900012O00302O016O0011010200013O00122O0003003C3O00122O0004003D6O0002000400024O00010001000200202O00010001001C4O00010002000200062O000100F9000100010004313O00F90001002E21013E00150001003F0004313O000C2O01002EB00041000C2O0100400004313O000C2O012O00302O0100054O009900025O00202O0002000200424O000300046O000500033O00202O00050005003300122O000700436O0005000700024O000500056O00010005000200062O0001000C2O013O0004313O000C2O012O00302O0100013O00122F000200443O00122F000300454O007B000100034O00C900016O00302O016O006A000200013O00122O000300463O00122O000400476O0002000400024O00010001000200202O0001000100094O00010002000200062O000100422O013O0004313O00422O012O00302O0100023O0020A70001000100484O00035O00202O00030003000B4O00010003000200262O000100422O0100040004313O00422O012O00302O0100023O0020880001000100494O00035O00202O00030003004A4O0001000300024O000200023O00202O0002000200214O00020002000200062O000100422O0100020004313O00422O012O00302O0100023O00209800010001000E4O00035O00202O00030003000F4O00010003000200062O000100422O013O0004313O00422O012O00302O0100054O001100025O00202O0002000200144O000300046O000500033O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O0001003D2O0100010004313O003D2O01002EB0004C00422O01004B0004313O00422O012O00302O0100013O00122F0002004D3O00122F0003004E4O007B000100034O00C900016O00302O016O006A000200013O00122O0003004F3O00122O000400506O0002000400024O00010001000200202O0001000100094O00010002000200062O000100642O013O0004313O00642O012O00302O0100023O0020A70001000100484O00035O00202O00030003000B4O00010003000200262O000100642O0100040004313O00642O012O00302O0100023O0020880001000100494O00035O00202O00030003004A4O0001000300024O000200023O00202O0002000200214O00020002000200062O000100642O0100020004313O00642O012O00302O0100023O0020B700010001000A4O00035O00202O0003000300514O00010003000200062O000100662O0100010004313O00662O01002E7A0052007A2O0100530004313O007A2O012O00302O0100054O007300025O00202O0002000200324O0003000A6O000400046O000500033O00202O00050005003300122O0007001F6O0005000700024O000500056O00010005000200062O000100752O0100010004313O00752O01002EB00055007A2O0100540004313O007A2O012O00302O0100013O00122F000200563O00122F000300574O007B000100034O00C900015O00122F3O00233O0026143O00FB2O01001F0004313O00FB2O012O00302O016O006A000200013O00122O000300583O00122O000400596O0002000400024O00010001000200202O0001000100094O00010002000200062O000100972O013O0004313O00972O012O00302O0100083O000663000100972O0100010004313O00972O012O00302O016O006A000200013O00122O0003005A3O00122O0004005B6O0002000400024O00010001000200202O00010001001C4O00010002000200062O000100992O013O0004313O00992O012O00302O0100093O00263B2O0100992O0100230004313O00992O01002E7A005C00B12O01005D0004313O00B12O012O00302O01000B3O00209400010001005E4O00025O00202O0002000200324O0003000C6O000400013O00122O0005005F3O00122O000600606O0004000600024O0005000D6O000600066O000700033O00202O00070007003300122O0009001F6O0007000900024O000700076O00010007000200062O000100B12O013O0004313O00B12O012O00302O0100013O00122F000200613O00122F000300624O007B000100034O00C900016O00302O016O006A000200013O00122O000300633O00122O000400646O0002000400024O00010001000200202O0001000100094O00010002000200062O000100D62O013O0004313O00D62O012O00302O0100023O00209800010001000E4O00035O00202O00030003000F4O00010003000200062O000100D62O013O0004313O00D62O012O00302O0100054O001100025O00202O0002000200144O000300046O000500033O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O000100D12O0100010004313O00D12O01002EB0006600D62O0100650004313O00D62O012O00302O0100013O00122F000200673O00122F000300684O007B000100034O00C900016O00302O016O0011010200013O00122O000300693O00122O0004006A6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100E22O0100010004313O00E22O01002EB0006C009D0301006B0004313O009D03012O00302O01000B3O00209400010001005E4O00025O00202O00020002006D4O0003000C6O000400013O00122O0005006E3O00122O0006006F6O0004000600024O0005000D6O000600066O000700033O00202O00070007003300122O0009001F6O0007000900024O000700076O00010007000200062O0001009D03013O0004313O009D03012O00302O0100013O001222010200703O00122O000300716O000100036O00015O00044O009D030100263B012O00FF2O0100720004313O00FF2O01002E7A00730074020100740004313O007402012O00302O016O006A000200013O00122O000300753O00122O000400766O0002000400024O00010001000200202O0001000100094O00010002000200062O0001002702013O0004313O002702012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O0001002702013O0004313O002702012O00302O0100023O00209E0001000100772O002100010002000200264A2O010027020100780004313O002702012O00302O0100054O007400025O00202O0002000200144O000300046O000500033O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O0001002702013O0004313O002702012O00302O0100013O00122F000200793O00122F0003007A4O007B000100034O00C900016O00302O01000E3O00062C2O01003E02013O0004313O003E02012O00302O016O006A000200013O00122O0003007B3O00122O0004007C6O0002000400024O00010001000200202O0001000100094O00010002000200062O0001003E02013O0004313O003E02012O00302O0100023O00209E00010001002D2O002100010002000200264A2O01003E020100230004313O003E02012O00302O0100023O00209E0001000100772O00210001000200020026502O010040020100780004313O00400201002EB0007E004E0201007D0004313O004E02012O00302O0100054O009200025O00202O00020002007F4O0003000F6O00010003000200062O00010049020100010004313O00490201002E2101800007000100810004313O004E02012O00302O0100013O00122F000200823O00122F000300834O007B000100034O00C900015O002EB000850073020100840004313O007302012O00302O016O006A000200013O00122O000300863O00122O000400876O0002000400024O00010001000200202O0001000100094O00010002000200062O0001007302013O0004313O007302012O00302O0100083O00066300010073020100010004313O007302012O00302O0100093O000EF400040073020100010004313O00730201002E7A00880073020100890004313O007302012O00302O0100054O009900025O00202O0002000200264O000300046O000500033O00202O00050005002700122O000700286O0005000700024O000500056O00010005000200062O0001007302013O0004313O007302012O00302O0100013O00122F0002008A3O00122F0003008B4O007B000100034O00C900015O00122F3O001F3O0026143O0005030100220004313O000503012O00302O016O006A000200013O00122O0003008C3O00122O0004008D6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100A202013O0004313O00A202012O00302O0100023O00209800010001000E4O00035O00202O00030003000F4O00010003000200062O000100A202013O0004313O00A202012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O000100A202013O0004313O00A202012O00302O0100054O001100025O00202O0002000200144O000300046O000500033O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00010005000200062O0001009D020100010004313O009D0201002E7A008E00A20201008F0004313O00A202012O00302O0100013O00122F000200903O00122F000300914O007B000100034O00C900016O00302O016O006A000200013O00122O000300923O00122O000400936O0002000400024O00010001000200202O0001000100094O00010002000200062O000100CF02013O0004313O00CF02012O00302O0100083O000663000100CF020100010004313O00CF02012O00302O0100043O00062C2O0100CF02013O0004313O00CF02012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O000100CF02013O0004313O00CF02012O00302O0100093O000EF4000400CF020100010004313O00CF0201002E7A009400CF020100950004313O00CF02012O00302O0100054O009900025O00202O0002000200264O000300046O000500033O00202O00050005002700122O000700286O0005000700024O000500056O00010005000200062O000100CF02013O0004313O00CF02012O00302O0100013O00122F000200963O00122F000300974O007B000100034O00C900015O002EB000990004030100980004313O000403012O00302O016O006A000200013O00122O0003009A3O00122O0004009B6O0002000400024O00010001000200202O0001000100094O00010002000200062O0001000403013O0004313O000403012O00302O0100023O00209800010001000A4O00035O00202O00030003000B4O00010003000200062O0001000403013O0004313O000403012O00302O0100083O00066300010004030100010004313O000403012O00302O016O006A000200013O00122O0003009C3O00122O0004009D6O0002000400024O00010001000200202O00010001001C4O00010002000200062O000100F202013O0004313O00F202012O00302O0100093O00261400010004030100230004313O000403012O00302O0100054O005401025O00202O0002000200324O0003000A6O000400046O000500033O00202O00050005003300122O0007001F6O0005000700024O000500056O00010005000200062C2O01000403013O0004313O000403012O00302O0100013O00122F0002009E3O00122F0003009F4O007B000100034O00C900015O00122F3O00723O0026143O0001000100230004313O0001000100122F000100013O00263B2O01000C030100010004313O000C0301002EB000A00070030100A10004313O00700301002EB000A30041030100A20004313O004103012O003001026O006A000300013O00122O000400A43O00122O000500A56O0003000500024O00020002000300202O0002000200094O00020002000200062O0002004103013O0004313O004103012O0030010200023O0020A70002000200484O00045O00202O00040004000B4O00020004000200262O00020041030100040004313O004103012O0030010200023O0020880002000200494O00045O00202O00040004004A4O0002000400024O000300023O00202O0003000300214O00030002000200062O00020041030100030004313O004103012O0030010200023O00209800020002000A4O00045O00202O0004000400514O00020004000200062O0002004103013O0004313O004103012O0030010200054O009900035O00202O0003000300264O000400056O000600033O00202O00060006002700122O000800286O0006000800024O000600066O00020006000200062O0002004103013O0004313O004103012O0030010200013O00122F000300A63O00122F000400A74O007B000200044O00C900026O003001026O006A000300013O00122O000400A83O00122O000500A96O0003000500024O00020002000300202O0002000200094O00020002000200062O0002005503013O0004313O005503012O0030010200023O00209800020002000E4O00045O00202O00040004000B4O00020004000200062O0002005503013O0004313O005503012O0030010200103O00062C0102005703013O0004313O00570301002E2101AA001A000100AB0004313O006F03012O00300102000B3O00209400020002005E4O00035O00202O00030003006D4O0004000C6O000500013O00122O000600AC3O00122O000700AD6O0005000700024O0006000D6O000700076O000800033O00202O00080008003300122O000A001F6O0008000A00024O000800086O00020008000200062O0002006F03013O0004313O006F03012O0030010200013O00122F000300AE3O00122F000400AF4O007B000200044O00C900025O00122F000100233O002E7A00B00008030100B10004313O00080301000E0600230008030100010004313O000803012O003001026O006A000300013O00122O000400B23O00122O000500B36O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009903013O0004313O009903012O0030010200023O00209800020002000E4O00045O00202O00040004000B4O00020004000200062O0002009903013O0004313O009903012O0030010200103O00062C0102009903013O0004313O009903012O0030010200054O009900035O00202O0003000300B44O000400056O000600033O00202O00060006003300122O000800436O0006000800024O000600066O00020006000200062O0002009903013O0004313O009903012O0030010200013O00122F000300B53O00122F000400B64O007B000200044O00C900025O00122F3O00043O0004313O000100010004313O000803010004313O000100012O0053012O00017O00603O00028O00026O00F03F025O00BC9640025O0032A040030B3O00E50F5211C13A4717C4054603043O007EA76E35030A3O0049734361737461626C65030C3O002O1222F1C83A2F113AF1D33103063O005F5D704E98BC030B3O004973417661696C61626C6503063O0042752O66557003113O0050692O6C61726F6646726F737442752O6603123O00556E686F6C79537472656E67746842752O66030B3O0042752O6652656D61696E732O033O00474344026O000840025O0022AB40025O00E2B140025O00AEA340025O00F2A840030B3O004261676F66547269636B7303093O004973496E52616E6765026O00444003183O00C3F4822AEBB8EDD5E78C16EFAD92D3F4861CE5B2C181A4D303073O00B2A195E57584DE025O00F07C40025O0049B340025O002EAF40025O005CAD40025O0023B140025O00F8A140025O00CDB040025O00C8A440025O00D89840025O000AA840027O0040030B3O0002C67728DFF313C1783AD403063O009643B41449B1025O000BB040025O00149040030B3O00417263616E6550756C7365026O002040025O00CC9C40025O0048AE4003163O008C0A194C831D255D98140948CD0A1B4E8419165ECD4E03043O002DED787A025O006BB240025O00189240030E3O00FBE1A524C3FB8839D3EFAF29D9FC03043O004CB788C2030E3O004C69676874734A7564676D656E74030E3O0049735370652O6C496E52616E676503193O0076EFE230445C2B70F3E13F5D4A1A6EA6F73953461576F5A56003073O00741A868558302F025O00149F40030D3O003FCFA3E1AE660CC0ACC7BC7E1203063O00127EA1C084DD025O00B4A840025O0007B040030D3O00416E6365737472616C43612O6C025O005EA940025O0030B14003193O005E26AD01454B3AAF08695C29A208164D29AD0D57533BEE550603053O00363F48CE64025O0062AD40025O0072A54003093O00EE50577FE777C7564103063O001BA839251A8503093O0046697265626C2O6F6403143O002BA36EADD521A573AC973FAB7FA1D621B93CF98503053O00B74DCA1CC8025O00208840025O0050B04003093O0003D1B57D0B07C8A86B03053O006F41BDDA12025O009CA540025O0070844003093O00426C2O6F644675727903143O004147143A0F63A956590275195DAC2O4A17264B0E03073O00CF232B7B556B3C030A3O0052AFB2F97C62A1A9E47E03053O001910CAC08A030A3O004265727365726B696E6703143O00FFCEBFF1ACE6F6C2A3E5E9E6FCC8A4E3A5E7BD9F03063O00949DABCD82C9030B3O0035328E0711079B0114389A03043O00687753E9030C3O00DAFA2O2B57F0EA26364AFAF603053O00239598474203083O0042752O66446F776E025O00DBB240025O0084A240025O006CA340025O0046A64003183O001BE9458F351FD756A2331AE351F02818EB4BB1360AA813E403053O005A798822D0006B012O00122F3O00013O00263B012O0005000100020004313O00050001002E7A00040054000100030004313O005400012O00302O016O006A000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001003D00013O0004313O003D00012O00302O016O0011010200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001003D000100010004313O003D00012O00302O0100023O00209800010001000B4O00035O00202O00030003000C4O00010003000200062O0001003D00013O0004313O003D00012O00302O0100023O00209800010001000B4O00035O00202O00030003000D4O00010003000200062O0001003200013O0004313O003200012O00302O0100023O0020FB00010001000E4O00035O00202O00030003000D4O0001000300024O000200023O00202O00020002000F4O00020002000200202O00020002001000062O0001003F000100020004313O003F00012O00302O0100023O0020FB00010001000E4O00035O00202O00030003000C4O0001000300024O000200023O00202O00020002000F4O00020002000200202O00020002001000062O0001003F000100020004313O003F0001002EB00012006A2O0100110004313O006A2O01002EB00013006A2O0100140004313O006A2O012O00302O0100034O005401025O00202O0002000200154O000300046O000400046O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00010005000200062C2O01006A2O013O0004313O006A2O012O00302O0100013O001222010200183O00122O000300196O000100036O00015O00044O006A2O0100263B012O0058000100010004313O00580001002E7A001B00010001001A0004313O000100012O00302O0100063O0006630001005D000100010004313O005D0001002E7A001C00302O01001D0004313O00302O0100122F000100014O0036010200033O00261400010064000100010004313O0064000100122F000200014O0036010300033O00122F000100023O00263B2O010068000100020004313O00680001002E7A001E005F0001001F0004313O005F000100263B0102006C000100010004313O006C0001002E21012000FEFF2O00210004313O0068000100122F000300013O002E7A002200B9000100230004313O00B90001002614000300B9000100020004313O00B9000100122F000400013O00261400040076000100020004313O0076000100122F000300243O0004313O00B9000100261400040072000100010004313O007200012O003001056O0011010600013O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500074O00050002000200062O00050084000100010004313O00840001002E7A00270098000100280004313O009800012O0030010500034O007300065O00202O0006000600294O000700046O000800086O000900053O00202O00090009001600122O000B002A6O0009000B00024O000900096O00050009000200062O00050093000100010004313O00930001002E21012B00070001002C0004313O009800012O0030010500013O00122F0006002D3O00122F0007002E4O007B000500074O00C900055O002E7A003000B70001002F0004313O00B700012O003001056O006A000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500074O00050002000200062O000500B700013O0004313O00B700012O0030010500034O008400065O00202O0006000600334O000700046O000800086O000900053O00202O0009000900344O000B5O00202O000B000B00334O0009000B00024O000900094O006500050009000200062C010500B700013O0004313O00B700012O0030010500013O00122F000600353O00122F000700364O007B000500074O00C900055O00122F000400023O0004313O00720001002E2101370037000100370004313O00F00001002614000300F0000100240004313O00F000012O003001046O0011010500013O00122O000600383O00122O000700396O0005000700024O00040004000500202O0004000400074O00040002000200062O000400C9000100010004313O00C90001002E21013A00100001003B0004313O00D700012O0030010400034O009200055O00202O00050005003C4O000600046O00040006000200062O000400D2000100010004313O00D20001002E21013D00070001003E0004313O00D700012O0030010400013O00122F0005003F3O00122F000600404O007B000400064O00C900045O002EB0004200302O0100410004313O00302O012O003001046O006A000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400074O00040002000200062O000400302O013O0004313O00302O012O0030010400034O005201055O00202O0005000500454O000600046O00040006000200062O000400302O013O0004313O00302O012O0030010400013O001222010500463O00122O000600476O000400066O00045O00044O00302O010026140003006D000100010004313O006D000100122F000400013O002EB0004800262O0100490004313O00262O01002614000400262O0100010004313O00262O012O003001056O006A000600013O00122O0007004A3O00122O0008004B6O0006000800024O00050005000600202O0005000500074O00050002000200062O0005000F2O013O0004313O000F2O01002E7A004D000F2O01004C0004313O000F2O012O0030010500034O005201065O00202O00060006004E4O000700046O00050007000200062O0005000F2O013O0004313O000F2O012O0030010500013O00122F0006004F3O00122F000700504O007B000500074O00C900056O003001056O006A000600013O00122O000700513O00122O000800526O0006000800024O00050005000600202O0005000500074O00050002000200062O000500252O013O0004313O00252O012O0030010500034O005201065O00202O0006000600534O000700046O00050007000200062O000500252O013O0004313O00252O012O0030010500013O00122F000600543O00122F000700554O007B000500074O00C900055O00122F000400023O002614000400F3000100020004313O00F3000100122F000300023O0004313O006D00010004313O00F300010004313O006D00010004313O00302O010004313O006800010004313O00302O010004313O005F00012O00302O016O006A000200013O00122O000300563O00122O000400576O0002000400024O00010001000200202O0001000100074O00010002000200062O000100522O013O0004313O00522O012O00302O016O006A000200013O00122O000300583O00122O000400596O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100522O013O0004313O00522O012O00302O0100023O00209800010001005A4O00035O00202O00030003000C4O00010003000200062O000100522O013O0004313O00522O012O00302O0100023O0020B700010001000B4O00035O00202O00030003000D4O00010003000200062O000100542O0100010004313O00542O01002E21015B00160001005C0004313O00682O012O00302O0100034O007300025O00202O0002000200154O000300046O000400046O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00010005000200062O000100632O0100010004313O00632O01002EB0005E00682O01005D0004313O00682O012O00302O0100013O00122F0002005F3O00122F000300604O007B000100034O00C900015O00122F3O00023O0004313O000100012O0053012O00017O00913O00028O00027O0040025O0020AF40025O00749940030C3O00995C6BD97034B67170D46A2E03063O005AD1331CB51903073O0049735265616479025O0052A340025O005EAA40030C3O00486F776C696E67426C617374030E3O0049735370652O6C496E52616E6765031E3O00D87440E2B6DE7C68ECB3D16843AEACD97550E2BAEF6F56FCB8D56F17BFE703053O00DFB01B378E030E3O0003B7CFB62DBAC29420ADCFBB27BE03043O00D544DBAE030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66026O001440030D3O00446562752O6652656D61696E732O033O00474344026O000840025O0016B340025O00CC9E40030E3O00476C616369616C416476616E636503093O004973496E52616E6765026O005940025O0044A440025O0058964003203O000CEC22E423C433400AE435E624C63A3F18E92DE026C0006B0AF224E23E856D2F03083O001F6B8043874AA55F026O00F03F025O00CDB240025O00C1B140030A3O00F7EAF04455B4CAE9E84803063O00D1B8889C2D21025O0033B340025O001DB340025O002FB040030A3O004F626C69746572617465030E3O004973496E4D656C2O6552616E6765031B3O0008CA7901AC02DA741CBD47DB7C06BF0BCD4A1CB915CF701CF8559A03053O00D867A81568025O001C9340025O00ACAA40030C3O0050A251AA77AB74AD76B946B603043O00C418CD2303043O0052756E65026O00104003113O0052756E6963506F77657244656669636974026O00394003123O000C99E6073A83EC001D82ED023C8AE4093D8A03043O00664EEB83030B3O004973417661696C61626C6503123O00D83C31455331B832C9273A405538B03BE92F03083O00549A4E54242759D7030F3O00432O6F6C646F776E52656D61696E73025O00804640030C3O00486F726E6F6657696E746572031F3O00F5EE44563AF2E7694F0CF3F5534A45EEE8585F09F8DE425917FAE4421857A903053O00659D813638025O00207C40025O00AAA340025O0076A14003113O00BADED0A3B305A32F8DC8CE9BA818B2269A03083O0043E8BBBDCCC176C603113O0052656D6F7273656C652O7357696E746572026O00204003223O00992BB82F2911EA872BA6330415E6853AB0327B11E68529B9250416EE9929B0347B5003073O008FEB4ED5405B62025O00F88C40030B3O00AB5A8BFA6485995A8DE27503063O00D6ED28E4891003093O0042752O66537461636B03123O004B692O6C696E674D616368696E6542752O66026O003440030B3O0046726F7374537472696B65025O0032A040025O0015B040031C3O0083F1E0CA179996F7FDD008A3C5F0E6D704AA80DCFBD811A180F7AF8D03063O00C6E5838FB963030C3O007983BF7F5882AF515D8DBB6703043O001331ECC803063O0042752O66557003083O0052696D6542752O6603073O0048617354696572026O003E40031D3O00F638E1BBEDB4F908F4BBE5A9EA77E5BEEABDF232C9A3E5A8F932E2F7B203063O00DA9E5796D784030B3O00DD0CD6F12231CEE20AD1E703073O00AD9B7EB9825642025O008EA740025O003AB240030B3O0046726F7374736379746865031B3O00E3B4B5D49CFFE6BFAECF8DACF6AFB4C084E9DAB2BBD58FE9F1E6E203063O008C85C6DAA7E8025O003C9040025O00AEB040030A3O009A2CB87490B03CB5698103053O00E4D54ED41D025O00405F40025O0042A040031B3O00884EBA0CFF825EB711EEC75FBF0BEC8B498911EA954BB311ABD61C03053O008BE72CD665030C3O00F1E0115219BF3634D5EE154A03083O0076B98F663E70D151030A3O0075732CE4B7101D33596203083O00583C104986C5757C030A3O0054616C656E7452616E6B031E3O0058E5EFC4485EEDC7CA4D51F9EC885259E4FFC4446FFEF9DA4655FEB8991303053O0021308A98A8025O00349D40025O0024B340025O00C49B40025O00E0A940030C3O005A19225FCE31451F3E45C42503063O005712765031A1030C3O00631CD6A9A4490CDBB4B9431003053O00D02C7EBAC003123O00D508A1C700F4C648C413AAC206FDCE41E41B03083O002E977AC4A6749CA9025O00489240025O00A49D40031F3O00EDE25414C4EAEB790DF2EBF94308BBF6E4481DF7E0D2521BE9E2E8525AAAB103053O009B858D267A025O00C08B40025O00808740030B3O000338A3525B4CB13723A74403073O00C5454ACC212F1F030F3O00C3475B93E44A488EFE48788BF14B5F03043O00E7902F3A031D3O00B4CAD5660C02DC2DA02OD170582EC637B5D4DF4A0C3CDD3EB7CC9A244E03083O0059D2B8BA15785DAF025O0022A840025O006EAF40030D3O003CBB89AA2D7C29A698B926770903063O00197DC9EACB43025O00F2B240025O00989640030D3O00417263616E65546F2O72656E74031F3O0078E61B021A222C6DFB0A2O11290739E7110D132B1646E0191113220739A64E03073O0073199478637447030B3O002A2FB637553F29AB2D4A0903053O00216C5DD944031D3O00DD59AEBECF74B2B9C942AAA89B58A8A3DC47A492CF4AB3AADE5FE1FF8303043O00CDBB2BC100AE022O00122F3O00014O00362O0100013O0026143O0002000100010004313O0002000100122F000100013O00263B2O010009000100020004313O00090001002E21010300C8000100040004313O00CF000100122F000200013O00261400020065000100010004313O006500012O003001036O006A000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003001900013O0004313O001900012O0030010300023O0006630003001B000100010004313O001B0001002EB00009002D000100080004313O002D00012O0030010300034O007400045O00202O00040004000A4O000500066O000700043O00202O00070007000B4O00095O00202O00090009000A4O0007000900024O000700076O00030007000200062O0003002D00013O0004313O002D00012O0030010300013O00122F0004000C3O00122F0005000D4O007B000300054O00C900036O003001036O006A000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003004F00013O0004313O004F00012O0030010300053O0006630003004F000100010004313O004F00012O0030010300063O0006630003004F000100010004313O004F00012O0030010300043O0020E40003000300104O00055O00202O0005000500114O00030005000200262O00030051000100120004313O005100012O0030010300043O0020FB0003000300134O00055O00202O0005000500114O0003000500024O000400073O00202O0004000400144O00040002000200202O00040004001500062O00030051000100040004313O00510001002E2101160015000100170004313O006400012O0030010300034O001200045O00202O0004000400184O000500066O000700043O00202O00070007001900122O0009001A6O0007000900024O000700076O00030007000200062O0003005F000100010004313O005F0001002E7A001B00640001001C0004313O006400012O0030010300013O00122F0004001D3O00122F0005001E4O007B000300054O00C900035O00122F0002001F3O002EB00021006B000100200004313O006B00010026140002006B000100020004313O006B000100122F000100153O0004313O00CF00010026140002000A0001001F0004313O000A000100122F000300013O002614000300C9000100010004313O00C900012O003001046O006A000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O0004000400074O00040002000200062O0004007D00013O0004313O007D00012O0030010400083O00062C0104007F00013O0004313O007F0001002EB000240092000100250004313O00920001002E2101260013000100260004313O009200012O0030010400034O009900055O00202O0005000500274O000600076O000800043O00202O00080008002800122O000A00126O0008000A00024O000800086O00040008000200062O0004009200013O0004313O009200012O0030010400013O00122F000500293O00122F0006002A4O007B000400064O00C900045O002EB0002B00C80001002C0004313O00C800012O003001046O006A000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400C800013O0004313O00C800012O0030010400073O00209E00040004002F2O002100040002000200264A010400C8000100300004313O00C800012O0030010400073O00209E0004000400312O0021000400020002000EDC003200C8000100040004313O00C800012O003001046O006A000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O0004000400354O00040002000200062O000400BC00013O0004313O00BC00012O003001046O0061000500013O00122O000600363O00122O000700376O0005000700024O00040004000500202O0004000400384O000400020002000E2O003900C8000100040004313O00C800012O0030010400034O005201055O00202O00050005003A4O000600096O00040006000200062O000400C800013O0004313O00C800012O0030010400013O00122F0005003B3O00122F0006003C4O007B000400064O00C900045O00122F0003001F3O0026140003006E0001001F0004313O006E000100122F000200023O0004313O000A00010004313O006E00010004313O000A0001002614000100892O0100010004313O00892O0100122F000200013O002EB0003D00292O01003E0004313O00292O01002614000200292O0100010004313O00292O01002E21013F00230001003F0004313O00F900012O003001036O006A000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O0003000300074O00030002000200062O000300F900013O0004313O00F900012O00300103000A3O000663000300E8000100010004313O00E800012O00300103000B3O00062C010300F900013O0004313O00F900012O0030010300034O009900045O00202O0004000400424O000500066O000700043O00202O00070007002800122O000900436O0007000900024O000700076O00030007000200062O000300F900013O0004313O00F900012O0030010300013O00122F000400443O00122F000500454O007B000300054O00C900035O002E7A004600282O01003E0004313O00282O012O003001036O006A000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300074O00030002000200062O000300282O013O0004313O00282O012O0030010300073O0020A70003000300494O00055O00202O00050005004A4O00030005000200262O000300282O0100020004313O00282O012O0030010300073O00209E0003000300312O002100030002000200264A010300282O01004B0004313O00282O012O00300103000C3O000663000300282O0100010004313O00282O012O0030010300034O007300045O00202O00040004004C4O0005000D6O000600066O000700043O00202O00070007002800122O000900126O0007000900024O000700076O00030007000200062O000300232O0100010004313O00232O01002EB0004E00282O01004D0004313O00282O012O0030010300013O00122F0004004F3O00122F000500504O007B000300054O00C900035O00122F0002001F3O000E06001F00842O0100020004313O00842O012O003001036O006A000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300074O00030002000200062O0003005C2O013O0004313O005C2O012O0030010300073O0020980003000300534O00055O00202O0005000500544O00030005000200062O0003005C2O013O0004313O005C2O012O0030010300073O0020C200030003005500122O000500563O00122O000600026O00030006000200062O0003005C2O013O0004313O005C2O012O0030010300073O0020A70003000300494O00055O00202O00050005004A4O00030005000200262O0003005C2O0100020004313O005C2O012O0030010300034O007400045O00202O00040004000A4O000500066O000700043O00202O00070007000B4O00095O00202O00090009000A4O0007000900024O000700076O00030007000200062O0003005C2O013O0004313O005C2O012O0030010300013O00122F000400573O00122F000500584O007B000300054O00C900036O003001036O006A000400013O00122O000500593O00122O0006005A6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300702O013O0004313O00702O012O0030010300073O0020980003000300534O00055O00202O00050005004A4O00030005000200062O000300702O013O0004313O00702O012O00300103000E3O000663000300722O0100010004313O00722O01002EB0005C00832O01005B0004313O00832O012O0030010300034O009900045O00202O00040004005D4O000500066O000700043O00202O00070007002800122O000900436O0007000900024O000700076O00030007000200062O000300832O013O0004313O00832O012O0030010300013O00122F0004005E3O00122F0005005F4O007B000300054O00C900035O00122F000200023O002614000200D2000100020004313O00D2000100122F0001001F3O0004313O00892O010004313O00D20001002614000100680201001F0004313O0068020100122F000200013O002EB0006000E22O0100610004313O00E22O01002614000200E22O0100010004313O00E22O012O003001036O006A000400013O00122O000500623O00122O000600636O0004000600024O00030003000400202O0003000300074O00030002000200062O000300B42O013O0004313O00B42O012O0030010300073O0020980003000300534O00055O00202O00050005004A4O00030005000200062O000300B42O013O0004313O00B42O01002EB0006400B42O0100650004313O00B42O012O0030010300034O009900045O00202O0004000400274O000500066O000700043O00202O00070007002800122O000900126O0007000900024O000700076O00030007000200062O000300B42O013O0004313O00B42O012O0030010300013O00122F000400663O00122F000500674O007B000300054O00C900036O003001036O006A000400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O0003000300074O00030002000200062O000300E12O013O0004313O00E12O012O0030010300073O0020980003000300534O00055O00202O0005000500544O00030005000200062O000300E12O013O0004313O00E12O012O003001036O0042000400013O00122O0005006A3O00122O0006006B6O0004000600024O00030003000400202O00030003006C4O00030002000200262O000300E12O0100020004313O00E12O012O0030010300034O007400045O00202O00040004000A4O000500066O000700043O00202O00070007000B4O00095O00202O00090009000A4O0007000900024O000700076O00030007000200062O000300E12O013O0004313O00E12O012O0030010300013O00122F0004006D3O00122F0005006E4O007B000300054O00C900035O00122F0002001F3O00263B010200E62O0100020004313O00E62O01002E21016F0004000100700004313O00E82O0100122F000100023O0004313O006802010026140002008C2O01001F0004313O008C2O0100122F000300013O00263B010300EF2O0100010004313O00EF2O01002E7A00720060020100710004313O006002012O003001046O006A000500013O00122O000600733O00122O000700746O0005000700024O00040004000500202O0004000400074O00040002000200062O0004001702013O0004313O001702012O0030010400073O00209E00040004002F2O002100040002000200264A01040017020100300004313O001702012O0030010400073O00209E0004000400312O0021000400020002000EDC00320017020100040004313O001702012O003001046O006A000500013O00122O000600753O00122O000700766O0005000700024O00040004000500202O0004000400354O00040002000200062O0004001702013O0004313O001702012O003001046O0011010500013O00122O000600773O00122O000700786O0005000700024O00040004000500202O0004000400354O00040002000200062O00040019020100010004313O00190201002EB0007A0025020100790004313O002502012O0030010400034O005201055O00202O00050005003A4O000600096O00040006000200062O0004002502013O0004313O002502012O0030010400013O00122F0005007B3O00122F0006007C4O007B000400064O00C900045O002E7A007E005F0201007D0004313O005F02012O003001046O006A000500013O00122O0006007F3O00122O000700806O0005000700024O00040004000500202O0004000400074O00040002000200062O0004005F02013O0004313O005F02012O0030010400053O0006630004005F020100010004313O005F02012O00300104000F3O0006630004004D020100010004313O004D02012O0030010400073O00209E0004000400312O00210004000200020026500104004D020100320004313O004D02012O0030010400043O0020E30004000400104O00065O00202O0006000600114O00040006000200262O0004005F020100120004313O005F02012O003001046O006A000500013O00122O000600813O00122O000700826O0005000700024O00040004000500202O0004000400354O00040002000200062O0004005F02013O0004313O005F02012O0030010400034O005401055O00202O00050005004C4O0006000D6O000700076O000800043O00202O00080008002800122O000A00126O0008000A00024O000800086O00040008000200062C0104005F02013O0004313O005F02012O0030010400013O00122F000500833O00122F000600844O007B000400064O00C900045O00122F0003001F3O00263B010300640201001F0004313O00640201002EB0008600EB2O0100850004313O00EB2O0100122F000200023O0004313O008C2O010004313O00EB2O010004313O008C2O0100261400010005000100150004313O000500012O0030010200103O00062C0102007C02013O0004313O007C02012O003001026O006A000300013O00122O000400873O00122O000500886O0003000500024O00020002000300202O0002000200074O00020002000200062O0002007C02013O0004313O007C02012O0030010200073O00209E0002000200312O0021000200020002000E4A004B007E020100020004313O007E0201002E210189000E0001008A0004313O008A02012O0030010200034O005201035O00202O00030003008B4O000400116O00020004000200062O0002008A02013O0004313O008A02012O0030010200013O00122F0003008C3O00122F0004008D4O007B000200044O00C900026O003001026O006A000300013O00122O0004008E3O00122O0005008F6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AD02013O0004313O00AD02012O0030010200053O000663000200AD020100010004313O00AD02012O0030010200034O005401035O00202O00030003004C4O0004000D6O000500056O000600043O00202O00060006002800122O000800126O0006000800024O000600066O00020006000200062C010200AD02013O0004313O00AD02012O0030010200013O001222010300903O00122O000400916O000200046O00025O00044O00AD02010004313O000500010004313O00AD02010004313O000200012O0053012O00017O00673O00028O00026O00F03F025O0040A840025O00E88F4003063O0042752O66557003083O0052696D6542752O6603173O00CC7302DAF17411D7FB5417D0E4770BFCF67308CFF77D0B03043O00BF9E1265030B3O004973417661696C61626C6503093O00E4D586BBAECBC08FB203053O00CFA5A3E7D7030A3O00EFFAFC543675C7F2FC4403063O0010A62O993644030F3O00E7BDCC433532F1D7B7E654312FE3CB03073O0099B2D3A0265441030B3O0042752O6652656D61696E7303133O00556E6C6561736865644672656E7A7942752O66026O00084003093O0042752O66537461636B03093O00AB08431F830755259103043O004BE26B3A030D3O0049637954616C6F6E7342752O66025O00C09840025O004CB140025O00B09440025O00209E40030D3O0068D71D7610D0C25EF8037502D603073O00AD38BE711A71A203113O0050692O6C61726F6646726F737442752O66030C3O00E4DC210CE3CECC2C11FEC4D003053O0097ABBE4D65026O001840030C3O00EA2DF4A0EC7819C43BF1A6F603073O006BA54F98C9981D030D3O006747E4C7556D5848CED95B6C4303063O001F372E88AB3403153O00456D706F77657252756E65576561706F6E42752O66030D3O00E121D0F8D03AD3F2F73AD3E7C503043O0094B148BC03113O0083BB47DCB1B345E1B3B852E4A3B747DCA803043O00B3C6D637027O004003043O0052756E65026O001040030C3O006FE6EAC454E1F4CC54EDE9C303043O00AD208486030D3O007E1204E3AF23C2483D1AE0BD2503073O00AD2E7B688FCE51030F3O00432O6F6C646F776E52656D61696E7303123O00960F278B518B0EB22E2B84419100B312318B03073O0061D47D42EA25E303123O00A8F1B3340A82ECB0061784E7A4341985F0B703053O007EEA83D655030C3O00ABD745535B81C7484E468BDB03053O002FE4B5293A030A3O0052756E6963506F776572025O00804140030D3O0096F5D537022210A0DACB34102403073O007FC69CB95B6350025O0015B240030B3O00D61E7D6551C0F315667E4003063O00B3906C12162503123O004B692O6C696E674D616368696E6542752O6603123O00EFAE0B9BC0D0A61FA6CDCAAA0F8CDDC7B71E03053O00AFA6C37BE903113O00C9D0544EF9EBE7454CF3FAD65446FEEAD003053O00908FA23D29030B3O00C6C11243669536E1C3184203073O005380B37D3012E703163O0070BEF4D553115BA3FBD8610C52ADF6D3701F4EA3F6CE03063O007E3DD793BD27030F3O005BF318446EF613424BEB0F4C73FA0E03043O0025189F7D030F3O00F9AA7043CCAF7B45E9B2674BD1A36603043O0022BAC61503083O0042752O66446F776E03113O004465617468416E64446563617942752O66025O00BEA640025O007AAE40030D3O00C801C951C3EA07C37BD0F71BD103053O00A29868A53D026O002440030D3O00FD26BE2O71F7C229946F7FF6D903063O0085AD4FD21D10026O001440026O005940025O00B07740025O0034954003113O0052756E6963506F7765724465666963697403123O00AF6EE82A9974E22DBE75E32F9F7DEA249E7D03043O004BED1C8D025O00C49540025O00A0764003123O00FE4DC9B03B13E8E7EF56C2B53D1AE0EECF5E03083O0081BC3FACD14F7B87026O003440025O00D09640025O0078AB40025O00409540025O00889D40025O00C05E402O033O00474344026O00D03F005B022O00122F3O00014O00362O0100023O0026143O004C020100020004313O004C020100263B2O010008000100020004313O00080001002E21010300CD000100040004313O00D3000100122F000300013O0026140003006F000100010004313O006F000100122F000400013O00261400040068000100010004313O006800012O0030010500013O0020980005000500054O000700023O00202O0007000700064O00050007000200062O0005003100013O0004313O003100012O0030010500024O0011010600033O00122O000700073O00122O000800086O0006000800024O00050005000600202O0005000500094O00050002000200062O00050031000100010004313O003100012O0030010500024O0011010600033O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O0005000500094O00050002000200062O00050031000100010004313O003100012O0030010500024O0050000600033O00122O0007000C3O00122O0008000D6O0006000800024O00050005000600202O0005000500094O0005000200022O000C00056O00AE000500026O000600033O00122O0007000E3O00122O0008000F6O0006000800024O00050005000600202O0005000500094O00050002000200062O0005004B00013O0004313O004B00012O0030010500013O0020400105000500104O000700023O00202O0007000700114O00050007000200202O00060002001200062O00050065000100060004313O006500012O0030010500013O0020E40005000500134O000700023O00202O0007000700114O00050007000200262O00050065000100120004313O006500012O0030010500024O006A000600033O00122O000700143O00122O000800156O0006000800024O00050005000600202O0005000500094O00050002000200062O0005006600013O0004313O006600012O0030010500013O0020400105000500104O000700023O00202O0007000700164O00050007000200202O00060002001200062O00050065000100060004313O006500012O0030010500013O0020E40005000500134O000700023O00202O0007000700164O00050007000200262O00050065000100120004313O006500012O002B01056O0052000500014O000C000500043O00122F000400023O002EB00017000C000100180004313O000C0001000E060002000C000100040004313O000C000100122F000300023O0004313O006F00010004313O000C0001002EB0001900090001001A0004313O0009000100261400030009000100020004313O000900012O0030010400024O006A000500033O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004009F00013O0004313O009F00012O0030010400013O0020980004000400054O000600023O00202O00060006001D4O00040006000200062O0004009F00013O0004313O009F00012O0030010400024O006A000500033O00122O0006001E3O00122O0007001F6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004009500013O0004313O009500012O0030010400013O0020E40004000400104O000600023O00202O00060006001D4O00040006000200262O000400CE000100200004313O00CE00012O0030010400024O006A000500033O00122O000600213O00122O000700226O0005000700024O00040004000500202O0004000400094O00040002000200062O000400CE00013O0004313O00CE00012O0030010400024O0011010500033O00122O000600233O00122O000700246O0005000700024O00040004000500202O0004000400094O00040002000200062O000400B0000100010004313O00B000012O0030010400013O0020B70004000400054O000600023O00202O0006000600254O00040006000200062O000400CF000100010004313O00CF00012O0030010400024O0011010500033O00122O000600263O00122O000700276O0005000700024O00040004000500202O0004000400094O00040002000200062O000400C4000100010004313O00C400012O0030010400024O006A000500033O00122O000600283O00122O000700296O0005000700024O00040004000500202O0004000400094O00040002000200062O000400CE00013O0004313O00CE00012O0030010400063O000EF4002A00CD000100040004313O00CD00012O0030010400013O00201D0004000400054O000600023O00202O00060006001D4O00040006000200044O00CF00012O002B01046O0052000400014O000C000400053O00122F0001002A3O0004313O00D300010004313O00090001002614000100252O0100120004313O00252O012O0030010300013O00209E00030003002B2O002100030002000200264A010300EF0001002C0004313O00EF00012O0030010300024O006A000400033O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O0003000300094O00030002000200062O000300F100013O0004313O00F100012O0030010300024O00E0000400033O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300314O0003000200024O000400083O00062O000300F0000100040004313O00F000012O002B01036O0052000300014O000C000300074O00AE000300026O000400033O00122O000500323O00122O000600336O0004000600024O00030003000400202O0003000300094O00030002000200062O000300072O013O0004313O00072O012O0030010300024O00E0000400033O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300314O0003000200024O0004000A3O00062O000300222O0100040004313O00222O012O0030010300024O006A000400033O00122O000500363O00122O000600376O0004000600024O00030003000400202O0003000300094O00030002000200062O000300232O013O0004313O00232O012O0030010300013O00209E0003000300382O002100030002000200264A010300212O0100390004313O00212O012O0030010300024O00E0000400033O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400202O0003000300314O0003000200024O000400083O00062O000300222O0100040004313O00222O012O002B01036O0052000300014O000C000300093O0004313O005A0201002E21013C00F60001003C0004313O001B02010026140001001B0201002A0004313O001B020100122F000300013O002614000300CA2O0100010004313O00CA2O012O0030010400024O006A000500033O00122O0006003D3O00122O0007003E6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008B2O013O0004313O008B2O012O0030010400013O0020B70004000400054O000600023O00202O00060006003F4O00040006000200062O000400402O0100010004313O00402O012O00300104000C3O000EF4001200892O0100040004313O00892O012O0030010400024O0011010500033O00122O000600403O00122O000700416O0005000700024O00040004000500202O0004000400094O00040002000200062O000400682O0100010004313O00682O012O0030010400024O0011010500033O00122O000600423O00122O000700436O0005000700024O00040004000500202O0004000400094O00040002000200062O000400682O0100010004313O00682O012O0030010400024O0011010500033O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400094O00040002000200062O000400682O0100010004313O00682O012O0030010400024O006A000500033O00122O000600463O00122O000700476O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008A2O013O0004313O008A2O012O0030010400024O006A000500033O00122O000600483O00122O000700496O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008A2O013O0004313O008A2O012O0030010400024O006A000500033O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008B2O013O0004313O008B2O012O00300104000C3O000E4A0020008A2O0100040004313O008A2O012O0030010400013O00209800040004004C4O000600023O00202O00060006004D4O00040006000200062O0004008B2O013O0004313O008B2O012O00300104000C3O000E4A0012008A2O0100040004313O008A2O012O002B01046O0052000400014O000C0004000B3O002EB0004E00C72O01004F0004313O00C72O012O0030010400013O00209E0004000400382O002100040002000200264A010400C72O0100390004313O00C72O012O0030010400013O00209E00040004002B2O002100040002000200264A010400C72O01002A0004313O00C72O012O0030010400024O0050000500033O00122O000600503O00122O000700516O0005000700024O00040004000500202O0004000400314O00040002000200264A010400C72O0100520004313O00C72O012O00300104000D4O000B000500026O000600033O00122O000700533O00122O000800546O0006000800024O00050005000600202O0005000500314O00050002000200122O000600026O0004000600024O0005000E6O000600026O000700033O00122O000800533O00122O000900546O0007000900024O00060006000700202O0006000600314O00060002000200122O000700026O0005000700024O0004000400054O0004000400024O000500013O00202O00050005002B4O00050002000200202O0005000500124O000600013O00202O0006000600384O00060002000200202O0006000600554O0005000500064O00040004000500202O0004000400564O000400083O00044O00C92O0100122F000400124O000C000400083O00122F000300023O002EB00057002A2O0100580004313O002A2O010026140003002A2O0100020004313O002A2O012O0030010400013O00209E0004000400592O0021000400020002000EDC005200DD2O0100040004313O00DD2O012O0030010400024O00F5000500033O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500202O0004000400314O00040002000200262O000400DF2O0100520004313O00DF2O01002E7A005C00160201005D0004313O001602012O00300104000D4O003D010500026O000600033O00122O0007005E3O00122O0008005F6O0006000800024O00050005000600202O0005000500314O00050002000200122O000600026O0004000600024O0005000E6O000600026O000700033O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O0006000600314O00060002000200122O000700026O0005000700024O0004000400054O0004000400024O0005000D6O000600013O00202O00060006002B4O00060002000200122O000700026O0005000700024O0006000E6O000700013O00202O00070007002B4O00070002000200122O000800026O0006000800024O0005000500064O0006000D6O000700013O00202O0007000700384O00070002000200122O000800606O0006000800024O0007000E6O000800013O00202O0008000800384O00080002000200122O000900606O0007000900024O0006000600074O0005000500064O00040004000500202O0004000400564O0004000A3O00044O0018020100122F000400124O000C0004000A3O00122F000100123O0004313O001B02010004313O002A2O01002E21016100E9FD2O00610004313O0004000100261400010004000100010004313O0004000100122F000300013O00263B01030024020100020004313O00240201002E7A0062002E020100630004313O002E02012O00300104000C3O000EF4002A0029020100040004313O002902012O0030010400103O0004313O002B02012O002B01046O0052000400014O000C0004000F3O00122F000100023O0004313O0004000100263B01030032020100010004313O00320201002E7A00640020020100650004313O002002012O00300104000D4O003A000500013O00202O0005000500664O00050002000200122O000600676O0004000600024O0005000E6O000600013O00202O0006000600664O00060002000200122O000700676O0005000700024O0002000400054O0004000C3O00262O00040046020100020004313O004602012O0030010400104O00FA000400043O0004313O004702012O002B01046O0052000400014O000C000400113O00122F000300023O0004313O002002010004313O000400010004313O005A02010026143O0002000100010004313O0002000100122F000300013O000E0600010054020100030004313O0054020100122F000100014O0036010200023O00122F000300023O0026140003004F020100020004313O004F020100122F3O00023O0004313O000200010004313O004F02010004313O000200012O0053012O00017O00AA3O00028O00026O00F03F025O004C9A40025O0002A840030C3O004570696353652O74696E677303073O0044F105114875ED03053O0024109E62762O033O00C119C603083O0085A076A39B38884703073O00C2AD76F5BA1AA603073O00D596C21192D67F2O033O0018ADB703083O00567BC9C4B426C4C2025O00089E40025O00DAA440027O004003073O00C115CBF7AB0E2A03083O00BE957AAC90C76B592O033O003D0AF203053O009E5265919E026O000840025O00406040025O00A0A940030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0042B340025O005DB040025O003C9240025O0044974003103O00426F2O73466967687452656D61696E73025O00B0AF40025O00F08440025O00907440025O00E07C40024O0080B3C540030C3O00466967687452656D61696E73025O00A6A940025O00F49040025O00B88740025O0018B040025O00406940025O00EEA740025O000C9940025O00FCB140030B3O00D3EDD8BBFFDBCDBDFEE3DC03043O00CF9788B903073O0049735265616479025O0040A440025O00E89840030B3O004465617468537472696B65030E3O004973496E4D656C2O6552616E6765026O001440031B3O00AC8629967C4762BC91218971387DA794688A64387EBAC338902O7B03073O0011C8E348E21418025O0026A140025O0084B340025O00108D40025O00508940025O00BAB240025O0014A540025O00588140025O00388140025O00507040025O003AAE40025O00E07440025O00D4A740025O008AAC40025O00C7B240025O004CAA40025O004EAC40025O0010B240025O00049E40025O0050A040025O00789F40025O00C2A940025O0052B240025O00807840025O00B8A94003093O00934E17D3E1F4EEEDA403083O009FD0217BB7A9918F030B3O004973417661696C61626C6503083O0042752O66446F776E03123O004B692O6C696E674D616368696E6542752O6603123O00D0483D37E6523730C1533632E05B3F39E15B03043O0056923A58030B3O00446562752O66537461636B030E3O0052617A6F72696365446562752O66030E3O007FD3EBC3A7E83ADB5CC9EBCEADEC03083O009A38BF8AA0CE895603093O00A74FF48B7D3482C48303083O00ACE63995E71C5AE12O033O00474344026O00E03F025O00C05D40025O00B3B140025O0056A340025O002EAE40025O001AA140025O00F49A40025O00D49A40025O009AAA4003063O0042752O66557003123O004272656174686F6653696E647261676F7361030C3O002DA88ADB3CDE10AB92DB27D503063O00BB62CAE6B24803113O0050692O6C61726F6646726F737442752O66025O00805D40025O00609D40025O0040A940025O0008914003043O00502O6F6C03163O0031EEAB3C0A27EEB6706833E4A524420EE3A8395E69A803053O002A4181C450025O0032A940025O00D09C40025O0044A540025O00A5B240025O005C9B40025O00F07740025O00C09340025O0083B040030C3O002D4851D3030210EF164352D403083O008E622A3DBA776762030C3O0017BD0E012CBA10092CB60D0603043O006858DF62025O00208E4003113O0054F8EDC242EB4BE5A2EC10E845E3EA864B03063O008D249782AE62025O00F5B140025O004CA540030C3O00AB78CE04907FD00C9073CD2O03043O006DE41AA2025O00D4B040025O000FB240025O0092A140025O0010814003173O004EEAF274A0E051F7BD57E2EA57F1F86AE1F257EAF330A903063O00863E859D1880025O0020A540025O0072AC40025O00B5B040025O00D09540025O0054B040025O00E07640025O00A06240025O0086B140025O00308440025O00349040025O001CAC40025O0034AD40030D3O0043617374412O6E6F746174656403043O00308433ED03073O00B667C57AB94FD103133O00576169742F502O6F6C205265736F7572636573025O00B88940025O00988C40025O0062B340025O000DB140025O00188440025O00B07D40025O004FB04003163O00476574456E656D696573496E4D656C2O6552616E6765026O002040026O002440025O00C4A540025O00405E40025O00A09D40025O00FEA540025O0014A040025O0058A2400019032O00122F3O00013O0026143O002E000100020004313O002E000100122F000100014O0036010200023O00263B2O010009000100010004313O00090001002E7A00040005000100030004313O0005000100122F000200013O00261400020025000100010004313O00250001001281000300054O00A0000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O00035O00122O000300056O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000300023O00122O000200023O00263B01020029000100020004313O00290001002E7A000F000A0001000E0004313O000A000100122F3O00103O0004313O002E00010004313O000A00010004313O002E00010004313O000500010026143O003F000100010004313O003F00012O00302O0100034O00B600010001000100122O000100056O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100043O00124O00023O000E890015004300013O0004313O00430001002E210116006E020100170004313O00AF02012O00302O0100053O00204E2O01000100182O000A2O01000100020006630001004D000100010004313O004D00012O00302O0100063O00209E0001000100192O002100010002000200062C2O01007500013O0004313O0075000100122F000100013O00263B2O010052000100010004313O00520001002E7A001A00650001001B0004313O0065000100122F000200013O002EB0001C005E0001001D0004313O005E00010026140002005E000100010004313O005E00012O0030010300083O0020F200030003001E4O0003000100024O000300076O000300076O000300093O00122O000200023O002E7A002000530001001F0004313O0053000100261400020053000100020004313O0053000100122F000100023O0004313O006500010004313O005300010026140001004E000100020004313O004E0001002EB00021006D000100220004313O006D00012O0030010200093O00263B0102006D000100230004313O006D00010004313O007500012O0030010200083O0020D40002000200244O0003000A6O00048O0002000400024O000200093O00044O007500010004313O004E0001002EB000260018030100250004313O001803012O00302O0100053O00204E2O01000100182O000A2O010001000200062C2O01001803013O0004313O001803012O00302O0100063O00209E0001000100192O002100010002000200062C2O01008300013O0004313O00830001002EB00028009C000100270004313O009C000100122F000100014O0036010200033O002EB00029008C0001002A0004313O008C00010026140001008C000100010004313O008C000100122F000200014O0036010300033O00122F000100023O000E0600020085000100010004313O008500010026140002008E000100010004313O008E00012O00300104000B4O000A0104000100022O008B000300043O00066300030097000100010004313O00970001002EB0002C009C0001002B0004313O009C00012O0002000300023O0004313O009C00010004313O008E00010004313O009C00010004313O008500012O00302O01000C4O006A000200013O00122O0003002D3O00122O0004002E6O0002000400024O00010001000200202O00010001002F4O00010002000200062O000100A900013O0004313O00A900012O00302O01000D3O00062C2O0100AB00013O0004313O00AB0001002E7A003000BC000100310004313O00BC00012O00302O01000E4O00990002000C3O00202O0002000200324O000300046O0005000F3O00202O00050005003300122O000700346O0005000700024O000500056O00010005000200062O000100BC00013O0004313O00BC00012O00302O0100013O00122F000200353O00122F000300364O007B000100034O00C900016O00302O0100104O000E2O01000100012O00302O0100114O000A2O0100010002000663000100C4000100010004313O00C40001002E7A003800C5000100370004313O00C500012O0002000100024O0030010200023O000663000200CA000100010004313O00CA0001002E7A003900E70001003A0004313O00E7000100122F000200014O0036010300043O000E89000100D0000100020004313O00D00001002EB0003B00D30001003C0004313O00D3000100122F000300014O0036010400043O00122F000200023O00263B010200D7000100020004313O00D70001002E7A003D00CC0001003E0004313O00CC0001002EB0003F00D7000100400004313O00D70001002614000300D7000100010004313O00D700012O0030010500124O000A0105000100022O008B000400053O000663000400E2000100010004313O00E20001002EB0004200E7000100410004313O00E700012O0002000400023O0004313O00E700010004313O00D700010004313O00E700010004313O00CC0001002E7A004300132O0100440004313O00132O012O0030010200023O00062C010200132O013O0004313O00132O0100122F000200014O0036010300033O002E7A004500FB000100460004313O00FB0001002614000200FB000100020004313O00FB00012O0030010400134O000A0104000100022O008B000300043O000663000300F9000100010004313O00F90001002E210147001C000100480004313O00132O012O0002000300023O0004313O00132O0100263B010200FF000100010004313O00FF0001002EB0004900EE0001004A0004313O00EE000100122F000400013O00263B010400042O0100020004313O00042O01002EB0004C00062O01004B0004313O00062O0100122F000200023O0004313O00EE000100261400042O002O0100010004314O002O012O0030010500144O000A0105000100022O008B000300053O002E7A004D00102O01004E0004313O00102O0100062C010300102O013O0004313O00102O012O0002000300023O00122F000400023O0004314O002O010004313O00EE00012O00300102000C4O006A000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200514O00020002000200062O0002005C2O013O0004313O005C2O012O0030010200063O0020B70002000200524O0004000C3O00202O0004000400534O00020004000200062O0002002E2O0100010004313O002E2O012O00300102000C4O006A000300013O00122O000400543O00122O000500556O0003000500024O00020002000300202O0002000200514O00020002000200062O0002005C2O013O0004313O005C2O012O00300102000F3O0020510102000200564O0004000C3O00202O0004000400574O00020004000200262O0002005E2O0100340004313O005E2O012O0030010200153O0006630002004C2O0100010004313O004C2O012O00300102000C4O0011010300013O00122O000400583O00122O000500596O0003000500024O00020002000300202O0002000200514O00020002000200062O0002004C2O0100010004313O004C2O012O00300102000C4O006A000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O0002000200514O00020002000200062O0002005E2O013O0004313O005E2O012O0030010200094O004C000300166O000400063O00202O00040004005C4O00040002000200122O0005005D6O0003000500024O000400176O000500063O00202O00050005005C4O00050002000200122F0006005D4O00650004000600022O00B400030003000400068C00020003000100030004313O005E2O01002E7A005F00772O01005E0004313O00772O0100122F000200014O0036010300043O002614000200712O0100020004313O00712O0100263B010300662O0100010004313O00662O01002EB0006100622O0100600004313O00622O012O0030010500184O000A0105000100022O008B000400053O002E7A006300772O0100620004313O00772O0100062C010400772O013O0004313O00772O012O0002000400023O0004313O00772O010004313O00622O010004313O00772O01002614000200602O0100010004313O00602O0100122F000300014O0036010400043O00122F000200023O0004313O00602O01002EB0006400C62O0100650004313O00C62O012O0030010200063O0020980002000200664O0004000C3O00202O0004000400674O00020004000200062O000200C62O013O0004313O00C62O012O00300102000C4O006A000300013O00122O000400683O00122O000500696O0003000500024O00020002000300202O0002000200514O00020002000200062O000200C62O013O0004313O00C62O012O0030010200063O0020980002000200664O0004000C3O00202O00040004006A4O00020004000200062O000200C62O013O0004313O00C62O0100122F000200014O0036010300043O002614000200982O0100010004313O00982O0100122F000300014O0036010400043O00122F000200023O00263B0102009C2O0100020004313O009C2O01002E21016B00F9FF2O006C0004313O00932O01002EB0006E00AC2O01006D0004313O00AC2O01000E06000200AC2O0100030004313O00AC2O012O00300105000E4O00300106000C3O00204E01060006006F2O002100050002000200062C010500C62O013O0004313O00C62O012O0030010500013O001222010600703O00122O000700716O000500076O00055O00044O00C62O01002EB00073009C2O0100720004313O009C2O010026140003009C2O0100010004313O009C2O0100122F000500013O00263B010500B52O0100010004313O00B52O01002E7A007500BE2O0100740004313O00BE2O012O0030010600194O000A0106000100022O008B000400063O002EB0007700BD2O0100760004313O00BD2O0100062C010400BD2O013O0004313O00BD2O012O0002000400023O00122F000500023O002614000500B12O0100020004313O00B12O0100122F000300023O0004313O009C2O010004313O00B12O010004313O009C2O010004313O00C62O010004313O00932O01002EB000780010020100790004313O001002012O0030010200063O0020980002000200664O0004000C3O00202O0004000400674O00020004000200062O0002001002013O0004313O001002012O00300102000C4O006A000300013O00122O0004007A3O00122O0005007B6O0003000500024O00020002000300202O0002000200514O00020002000200062O000200EA2O013O0004313O00EA2O012O00300102000C4O006A000300013O00122O0004007C3O00122O0005007D6O0003000500024O00020002000300202O0002000200514O00020002000200062O0002001002013O0004313O001002012O0030010200063O0020980002000200524O0004000C3O00202O00040004006A4O00020004000200062O0002001002013O0004313O0010020100122F000200014O0036010300033O002E21017E00100001007E0004313O00FC2O01002614000200FC2O0100020004313O00FC2O012O00300104000E4O00300105000C3O00204E01050005006F2O002100040002000200062C0104001002013O0004313O001002012O0030010400013O0012220105007F3O00122O000600806O000400066O00045O00044O00100201002614000200EC2O0100010004313O00EC2O0100122F000400013O00263B01040003020100020004313O00030201002E2101810004000100820004313O0005020100122F000200023O0004313O00EC2O01002614000400FF2O0100010004313O00FF2O012O00300105001A4O000A0105000100022O008B000300053O00062C0103000D02013O0004313O000D02012O0002000300023O00122F000400023O0004313O00FF2O010004313O00EC2O012O00300102000C4O006A000300013O00122O000400833O00122O000500846O0003000500024O00020002000300202O0002000200514O00020002000200062O0002002802013O0004313O002802012O0030010200063O0020980002000200664O0004000C3O00202O00040004006A4O00020004000200062O0002002802013O0004313O002802012O0030010200063O0020B70002000200524O0004000C3O00202O0004000400674O00020004000200062O0002002A020100010004313O002A0201002E2101850035000100860004313O005D020100122F000200014O0036010300043O00261400020031020100010004313O0031020100122F000300014O0036010400043O00122F000200023O0026140002002C020100020004313O002C02010026140003004C020100010004313O004C020100122F000500014O0036010600063O00261400050037020100010004313O0037020100122F000600013O00261400060045020100010004313O004502012O00300107001B4O000A0107000100022O008B000400073O002EB000880044020100870004313O0044020100062C0104004402013O0004313O004402012O0002000400023O00122F000600023O000E060002003A020100060004313O003A020100122F000300023O0004313O004C02010004313O003A02010004313O004C02010004313O0037020100261400030033020100020004313O003302012O00300105000E4O00300106000C3O00204E01060006006F2O002100050002000200062C0105005D02013O0004313O005D02012O0030010500013O001222010600893O00122O0007008A6O000500076O00055O00044O005D02010004313O003302010004313O005D02010004313O002C0201002E7A008B008E0201008C0004313O008E02012O00300102001C3O000EF40010008E020100020004313O008E02012O003001025O00062C0102008E02013O0004313O008E020100122F000200014O0036010300053O00263B0102006B020100020004313O006B0201002E7A008D00860201008E0004313O008602012O0036010500053O00261400030071020100010004313O0071020100122F000400014O0036010500053O00122F000300023O00263B01030075020100020004313O00750201002E7A008F006C020100900004313O006C020100263B01040079020100010004313O00790201002E7A00920075020100910004313O007502012O00300106001D4O000A0106000100022O008B000500063O002EB00093008E020100940004313O008E020100062C0105008E02013O0004313O008E02012O0002000500023O0004313O008E02010004313O007502010004313O008E02010004313O006C02010004313O008E0201002E7A00950067020100960004313O0067020100261400020067020100010004313O0067020100122F000300014O0036010400043O00122F000200023O0004313O006702012O00300102001C3O00263B01020094020100020004313O009402012O003001025O000663000200A0020100010004313O00A0020100122F000200014O0036010300033O00261400020096020100010004313O009602012O00300104001E4O000A0104000100022O008B000300043O00062C010300A002013O0004313O00A002012O0002000300023O0004313O00A002010004313O009602012O0030010200083O0020EB0002000200974O0003000C3O00202O00030003006F4O00048O000500013O00122O000600983O00122O000700996O000500076O00023O000200062O0002001803013O0004313O0018030100122F0002009A4O0002000200023O0004313O0018030100263B012O00B3020100100004313O00B30201002E7A009C00010001009B0004313O0001000100122F000100013O002614000100B8020100020004313O00B8020100122F3O00153O0004313O00010001002614000100B4020100010004313O00B402012O00300102001F4O00160102000100024O000200026O0002000D6O00025O00062O000200C3020100010004313O00C30201002E7A009D00050301009E0004313O0005030100122F000200014O0036010300043O002614000200FC020100020004313O00FC0201000E89000100CB020100030004313O00CB0201002E7A001D00C70201009F0004313O00C7020100122F000400013O002614000400ED020100010004313O00ED020100122F000500013O00263B010500D3020100010004313O00D30201002E2101A00015000100A10004313O00E6020100122F000600013O002614000600D8020100020004313O00D8020100122F000500023O0004313O00E60201000E06000100D4020100060004313O00D402012O0030010700063O0020C60007000700A200122O000900A36O0007000900024O000700206O000700063O00202O0007000700A200122O000900A46O0007000900024O0007000A3O00122O000600023O0004313O00D40201000E89000200EA020100050004313O00EA0201002EB000A500CF020100A60004313O00CF020100122F000400023O0004313O00ED02010004313O00CF0201002E7A00A700CC020100A80004313O00CC0201002614000400CC020100020004313O00CC02012O00300105000A4O0033010500056O0005001C6O000500206O000500056O000500213O00044O001503010004313O00CC02010004313O001503010004313O00C702010004313O0015030100263B01022O00030100010004314O000301002E2101A900C7FF2O00AA0004313O00C5020100122F000300014O0036010400043O00122F000200023O0004313O00C502010004313O0015030100122F000200013O0026140002000D030100020004313O000D030100122F000300024O000C0003001C3O00122F000300024O000C000300213O0004313O0015030100261400020006030100010004313O000603012O002900036O005A000300206O00038O0003000A3O00122O000200023O00044O0006030100122F000100023O0004313O00B402010004313O000100012O0053012O00017O00083O00028O00025O0092AB40025O007C9B40025O00607640025O00649D4003053O005072696E7403323O00D595EE641408D7ACA1650F5CF293E8780E08F19EA1521041F0C9A1400F5AF8C7E8794058E188E665055BE0C7C6780A41E18603063O002893E781176000193O00122F3O00014O00362O0100013O00263B012O0006000100010004313O00060001002E7A00020002000100030004313O0002000100122F000100013O000E890001000B000100010004313O000B0001002E21010400FEFF2O00050004313O000700012O003001026O00240002000100014O000200013O00202O0002000200064O000300023O00122O000400073O00122O000500086O000300056O00023O000100044O001800010004313O000700010004313O001800010004313O000200012O0053012O00017O00", GetFEnv(), ...);

