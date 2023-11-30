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
				if (Enum <= 154) then
					if (Enum <= 76) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Enum == 2) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = not Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
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
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 6) then
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
									elseif (Enum == 7) then
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 12) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
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
								elseif (Enum <= 16) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 17) then
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
							elseif (Enum <= 27) then
								if (Enum <= 22) then
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
									elseif (Enum > 21) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 24) then
									if (Enum > 23) then
										local B;
										local A;
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
								elseif (Enum <= 25) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 26) then
									local B;
									local A;
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
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
									end
								elseif (Enum <= 30) then
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
								elseif (Enum == 31) then
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
							elseif (Enum <= 34) then
								if (Enum == 33) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 35) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 36) then
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
									if (Mvm[1] == 89) then
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
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
									elseif (Enum == 40) then
										if (Inst[2] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 43) then
									if (Enum > 42) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									else
										local A;
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 44) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 45) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								end
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum > 47) then
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									end
								elseif (Enum <= 49) then
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
								elseif (Enum > 50) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 53) then
								if (Enum == 52) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 54) then
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
							elseif (Enum == 55) then
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
						elseif (Enum <= 66) then
							if (Enum <= 61) then
								if (Enum <= 58) then
									if (Enum == 57) then
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
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
									end
								elseif (Enum <= 59) then
									local A;
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 60) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 63) then
								if (Enum > 62) then
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
							elseif (Enum <= 64) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							elseif (Enum == 65) then
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							end
						elseif (Enum <= 71) then
							if (Enum <= 68) then
								if (Enum > 67) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 69) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum == 70) then
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
						elseif (Enum <= 73) then
							if (Enum > 72) then
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
							end
						elseif (Enum <= 74) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 75) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
					elseif (Enum <= 115) then
						if (Enum <= 95) then
							if (Enum <= 85) then
								if (Enum <= 80) then
									if (Enum <= 78) then
										if (Enum > 77) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum > 79) then
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
								elseif (Enum <= 82) then
									if (Enum == 81) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 83) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 84) then
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
							elseif (Enum <= 90) then
								if (Enum <= 87) then
									if (Enum == 86) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum <= 88) then
									local A;
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
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 89) then
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 92) then
								if (Enum == 91) then
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
							elseif (Enum <= 93) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 94) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 105) then
							if (Enum <= 100) then
								if (Enum <= 97) then
									if (Enum == 96) then
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									else
										local A = Inst[2];
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									end
								elseif (Enum <= 98) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 99) then
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
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 102) then
								if (Enum == 101) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
								end
							elseif (Enum <= 103) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 104) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 110) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 108) then
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
							elseif (Enum == 109) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 112) then
							if (Enum == 111) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 113) then
							Stk[Inst[2]] = {};
						elseif (Enum > 114) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 134) then
						if (Enum <= 124) then
							if (Enum <= 119) then
								if (Enum <= 117) then
									if (Enum > 116) then
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 118) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								end
							elseif (Enum <= 121) then
								if (Enum > 120) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 122) then
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
							elseif (Enum > 123) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 129) then
							if (Enum <= 126) then
								if (Enum > 125) then
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
							elseif (Enum == 128) then
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
						elseif (Enum <= 131) then
							if (Enum == 130) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
						elseif (Enum == 133) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						else
							local B = Stk[Inst[4]];
							if not B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 144) then
						if (Enum <= 139) then
							if (Enum <= 136) then
								if (Enum > 135) then
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
							elseif (Enum <= 137) then
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
							elseif (Enum == 138) then
								Stk[Inst[2]]();
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
						elseif (Enum <= 141) then
							if (Enum > 140) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 143) then
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
						elseif (Inst[2] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 149) then
						if (Enum <= 146) then
							if (Enum == 145) then
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
					elseif (Enum <= 151) then
						if (Enum > 150) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 152) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 153) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 231) then
					if (Enum <= 192) then
						if (Enum <= 173) then
							if (Enum <= 163) then
								if (Enum <= 158) then
									if (Enum <= 156) then
										if (Enum > 155) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
												VIP = Inst[3];
											else
												VIP = VIP + 1;
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
									elseif (Enum == 157) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
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
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 160) then
									if (Enum == 159) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									end
								elseif (Enum <= 161) then
									do
										return Stk[Inst[2]];
									end
								elseif (Enum > 162) then
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
							elseif (Enum <= 168) then
								if (Enum <= 165) then
									if (Enum > 164) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									end
								elseif (Enum <= 166) then
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
								elseif (Enum > 167) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
							elseif (Enum <= 170) then
								if (Enum > 169) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum == 172) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 182) then
							if (Enum <= 177) then
								if (Enum <= 175) then
									if (Enum > 174) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum == 176) then
									local A;
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
							elseif (Enum <= 179) then
								if (Enum == 178) then
									local B;
									local A;
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
									B = Stk[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 180) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 181) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 187) then
							if (Enum <= 184) then
								if (Enum > 183) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 185) then
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
							elseif (Enum > 186) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 189) then
							if (Enum == 188) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							end
						elseif (Enum <= 190) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 191) then
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
					elseif (Enum <= 211) then
						if (Enum <= 201) then
							if (Enum <= 196) then
								if (Enum <= 194) then
									if (Enum == 193) then
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
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 195) then
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
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 198) then
								if (Enum > 197) then
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
								elseif (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 199) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 200) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 206) then
							if (Enum <= 203) then
								if (Enum == 202) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 204) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 205) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 208) then
							if (Enum > 207) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 210) then
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
							local B;
							local A;
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 221) then
						if (Enum <= 216) then
							if (Enum <= 213) then
								if (Enum > 212) then
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
							elseif (Enum == 215) then
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
								Stk[Inst[2]] = Inst[3];
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
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							end
						elseif (Enum <= 218) then
							if (Enum > 217) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 219) then
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
						elseif (Enum > 220) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
						end
					elseif (Enum <= 226) then
						if (Enum <= 223) then
							if (Enum == 222) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 224) then
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
							Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum == 225) then
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 228) then
						if (Enum == 227) then
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
					elseif (Enum <= 229) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum == 230) then
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
				elseif (Enum <= 270) then
					if (Enum <= 250) then
						if (Enum <= 240) then
							if (Enum <= 235) then
								if (Enum <= 233) then
									if (Enum == 232) then
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum > 234) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 237) then
								if (Enum == 236) then
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
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 238) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 245) then
							if (Enum <= 242) then
								if (Enum > 241) then
									if (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 243) then
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
							elseif (Enum > 244) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							end
						elseif (Enum <= 247) then
							if (Enum == 246) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 248) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum == 249) then
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
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 260) then
						if (Enum <= 255) then
							if (Enum <= 252) then
								if (Enum > 251) then
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
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 253) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum > 254) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 257) then
							if (Enum > 256) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
								if (Stk[Inst[2]] ~= Inst[4]) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 258) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 259) then
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
					elseif (Enum <= 265) then
						if (Enum <= 262) then
							if (Enum == 261) then
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							else
								local B;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 263) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum > 264) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
					elseif (Enum <= 267) then
						if (Enum == 266) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 268) then
						local B;
						local A;
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
					elseif (Enum == 269) then
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
					elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 289) then
					if (Enum <= 279) then
						if (Enum <= 274) then
							if (Enum <= 272) then
								if (Enum == 271) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								end
							elseif (Enum > 273) then
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
						elseif (Enum <= 276) then
							if (Enum == 275) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						elseif (Enum == 278) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 284) then
						if (Enum <= 281) then
							if (Enum > 280) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 282) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						elseif (Enum > 283) then
							local A = Inst[2];
							Top = (A + Varargsz) - 1;
							for Idx = A, Top do
								local VA = Vararg[Idx - A];
								Stk[Idx] = VA;
							end
						elseif (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 286) then
						if (Enum == 285) then
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
					elseif (Enum <= 287) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						VIP = Inst[3];
					elseif (Enum == 288) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 299) then
					if (Enum <= 294) then
						if (Enum <= 291) then
							if (Enum > 290) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
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
						elseif (Enum <= 292) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 293) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 296) then
						if (Enum == 295) then
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
							if not Stk[Inst[2]] then
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
					elseif (Enum <= 297) then
						do
							return Stk[Inst[2]]();
						end
					elseif (Enum > 298) then
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
						Stk[Inst[2]] = Stk[Inst[3]];
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
				elseif (Enum <= 304) then
					if (Enum <= 301) then
						if (Enum > 300) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 302) then
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum == 303) then
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
				elseif (Enum <= 306) then
					if (Enum > 305) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 307) then
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
					if (Inst[2] == Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 308) then
					if (Stk[Inst[2]] <= Inst[4]) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503163O00F4D3D23DD99FD50BD8C7E407E7B7C610D2C69529F3BA03083O007EB1A3BB4586DBA703163O00319D8C2F187D06988C33187B15818439245C5A81903603063O003974EDE55747002E3O0012FC3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004F03O000A000100123D000300063O00202200040003000700123D000500083O00202200050005000900123D000600083O00202200060006000A00062500073O000100062O00593O00064O00598O00593O00044O00593O00014O00593O00024O00593O00053O00202200080003000B00202200090003000C2O0071000A5O00123D000B000D3O000625000C0001000100022O00593O000A4O00593O000B4O0059000D00073O00123C000E000E3O00123C000F000F4O0069000D000F0002000625000E0002000100032O00593O00074O00593O00094O00593O00084O00A2000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O007E00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00DA00076O00E3000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004DB0003000500012O00DA000300054O0059000400024O0034000300044O00C300036O00543O00017O000F3O00028O00026O00F03F025O009CAB40025O0062A040025O006EA940025O00B08040025O009EB040025O006CB140025O0035B240025O0035B140025O00DFB140025O005C9E40025O00607440025O00C49140025O0010944001463O00123C000200014O0040000300043O000EF200010007000100020004F03O0007000100123C000300014O0040000400043O00123C000200023O000EF200020002000100020004F03O0002000100123C000500014O0040000600063O0026C50005000F000100010004F03O000F0001002E90000300FEFF2O00040004F03O000B000100123C000600013O002E2800060010000100050004F03O0010000100262900060010000100010004F03O00100001002EF700070036000100080004F03O0036000100262900030036000100010004F03O0036000100123C000700014O0040000800083O0026C50007001E000100010004F03O001E0001002E280009001A0001000A0004F03O001A000100123C000800013O002E28000C00250001000B0004F03O0025000100262900080025000100020004F03O0025000100123C000300023O0004F03O00360001000EFB00010029000100080004F03O00290001002EF7000E001F0001000D0004F03O001F00012O00DA00096O006F000400093O00066400040032000100010004F03O003200012O00DA000900014O0059000A6O001C010B6O002E00096O00C300095O00123C000800023O0004F03O001F00010004F03O003600010004F03O001A0001002E90000F00D3FF2O000F0004F03O0009000100262900030009000100020004F03O000900012O0059000700044O001C01086O002E00076O00C300075O0004F03O000900010004F03O001000010004F03O000900010004F03O000B00010004F03O000900010004F03O004500010004F03O000200012O00543O00017O00593O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203093O00862B0525768AEDAE3603073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003043O009ECAD90E03063O004BDCA3B76A6203053O0023B5AE18F703053O00B962DAEB5703053O00E81834C9F003063O00CAAB5C4786BE03043O000AC03F9C03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03073O002FC1537F7179E003083O00876CAE3E121E179303083O0093FF2FD901A13DC203083O00A7D6894AAB78CE532O033O0085E53F03063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D903043O00CA212F8C03073O009CA84E40E0D47903073O0022E845527C0FF403053O00136187283F03083O008B4A3629363EA05903063O0051CE3C535B4F03053O006AB9C57B2B03083O00C42ECBB0124FA32D03073O009A23721F2AF8EA03073O008FD8421E7E449B03053O008EDA18C2C103083O0081CAA86DABA5C3B703074O00593BD9D017E303073O0086423857B8BE74031A3O0011381BA916F92E331A2308B80DFE3330380506B616F9333A2B2203083O00555C5169DB798B4103023O00494403053O00D9A1454C7803063O00BF9DD330251C03073O00FD1EF81D34DC1A03053O005ABF7F947C030C3O0047657445717569706D656E74026O002A40028O00026O002C4003053O005C953B1E7C03043O007718E74E024O0080B3C54003113O00AB23A64BCE4E109624AA44E8411D8723B103073O0071E24DC52ABC20030B3O004973417661696C61626C65030B3O001318F7B42818F5A13319FA03043O00D55A769403123O00782BB8535E4F27B55A6C5727B358405E20A003053O002D3B4ED43603103O005265676973746572466F724576656E7403183O00207AA2B2A31C92D52163AABBAB0B83C42F75ABAAA80988D403083O00907036E3EBE64ECD03143O0083042EC5F5698C1A2ADBF5758C0D21DDF277960C03063O003BD3486F9CB0030E3O0018BC1580858E0908A411828E981203073O00564BEC50CCC9DD03143O005E6456B7D0AE567E44B5DBA75E7E5EABC1BF536303063O00EB122117E59E03063O0053657441504C025O0080594000FF013O00D8000100033O00123D000300014O000C00045O00122O000500023O00122O000600036O0004000600024O00030003000400123D000400043O00123D000500054O000C00065O00122O000700063O00122O000800076O0006000800024O0006000400062O000C00075O00122O000800083O00122O000900096O0007000900024O0007000600072O000C00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600082O000C00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600092O000C000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A2O000C000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B2O000C000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C2O000C000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D2O000C000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E2O000C000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F2O000C00105O00122O0011001A3O00122O0012001B6O0010001200024O0010000400102O000C00115O00122O0012001C3O00122O0013001D6O0011001300024O0011000400112O000C00125O00122O0013001E3O00122O0014001F6O0012001400024O0012000400122O000C00135O00122O001400203O00122O001500216O0013001500024O0013000400132O000C00145O00122O001500223O00122O001600236O0014001600024O0014000400142O000C00155O00122O001600243O00122O001700256O0015001700024O0014001400152O000C00155O00122O001600263O00122O001700276O0015001700024O0014001400152O000C00155O00122O001600283O00122O001700296O0015001700024O0015000400152O000C00165O00122O0017002A3O00122O0018002B6O0016001800024O0015001500162O000C00165O00122O0017002C3O00122O0018002D6O0016001800024O0015001500162O00D200168O00178O00188O00198O001A00283O00062500293O0001000F2O00593O001A4O00DA8O00593O001C4O00593O001D4O00593O001E4O00593O001F4O00593O00204O00593O00214O00593O00224O00593O00234O00593O00244O00593O00254O00593O00264O00593O00274O00593O00284O000C002A5O00122O002B002E3O00122O002C002F6O002A002C00024O002A0004002A2O000C002B5O00122O002C00303O00122O002D00316O002B002D00024O002A002A002B2O000C002B5O00122O002C00323O00122O002D00336O002B002D00024O002B000B002B2O000C002C5O00122O002D00343O00122O002E00356O002C002E00024O002B002B002C2O000C002C5O00122O002D00363O00122O002E00376O002C002E00024O002C000D002C2O000C002D5O00122O002E00383O00122O002F00396O002D002F00024O002C002C002D2O0071002D6O000C002E5O00122O002F003A3O00122O0030003B6O002E003000024O002E002C002E002061002E002E003C2O0045002E002F4O0050002D3O00012O00DA002E5O00123C002F003D3O00123C0030003E4O0069002E003000022O006F002E000E002E2O000C002F5O00122O0030003F3O00122O003100406O002F003100024O002E002E002F002061002F000700412O0060002F000200020020220030002F00420006D5003000BD00013O0004F03O00BD00012O00590030000D3O0020220031002F00422O0060003000020002000664003000C0000100010004F03O00C000012O00590030000D3O00123C003100434O00600030000200020020220031002F00440006D5003100C800013O0004F03O00C800012O00590031000D3O0020220032002F00442O0060003100020002000664003100CB000100010004F03O00CB00012O00590031000D3O00123C003200434O00600031000200022O008200326O00D3003300436O00445O00122O004500453O00122O004600466O0044004600024O00440004004400122O004500473O00122O004600476O00475O00122O004800483O00122O004900496O0047004900024O0047002B004700202O00470047004A4O00470002000200062O004700E400013O0004F03O00E400012O00DA00475O002O120048004B3O00122O0049004C6O0047004900024O0047002B004700062O004700E9000100010004F03O00E900012O00DA00475O00123C0048004D3O00123C0049004E4O00690047004900022O006F0047002B00472O008200486O000C01498O004A8O004B8O004C8O004D8O004E5O00202O004F0004004F00062500510001000100062O00593O002F4O00593O00074O00593O00304O00593O000D4O00593O00314O00593O00324O000900525O00122O005300503O00122O005400516O005200546O004F3O000100202O004F0004004F00062500510002000100032O00593O00464O00593O00324O00593O00454O000900525O00122O005300523O00122O005400536O005200546O004F3O000100202O004F0004004F00062500510003000100042O00593O00474O00593O002B4O00DA8O00593O00324O001D01525O00122O005300543O00122O005400556O0052005400024O00535O00122O005400563O00122O005500576O005300556O004F3O00014O004F00503O00062500510004000100062O00593O002B4O00DA8O00593O00074O00DA3O00014O00DA3O00024O00593O00503O00062500520005000100012O00593O002B3O00062500530006000100062O00593O002B4O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O00062500540007000100012O00593O002B3O00062500550008000100062O00593O002B4O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O00062500560009000100062O00593O002B4O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O0006250057000A000100062O00593O002B4O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O0006250058000B000100082O00593O002B4O00593O000A4O00593O00504O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O0006250059000C000100072O00593O002B4O00593O000A4O00593O00074O00DA3O00014O00593O003A4O00DA8O00DA3O00023O000625005A000D000100042O00593O002B4O00DA3O00014O00593O00504O00DA3O00023O000625005B000E000100012O00593O002B3O000625005C000F0001000A2O00593O00484O00593O00074O00593O002B4O00593O00494O00593O004A4O00593O004B4O00593O004C4O00DA8O00593O004D4O00593O004E3O000625005D00100001000B2O00593O00374O00DA3O00014O00593O00144O00593O00304O00DA3O00024O00593O00314O00593O00324O00593O00334O00593O002B4O00DA8O00593O00113O000625005E0011000100092O00593O002B4O00DA8O00593O00074O00593O00134O00593O000A4O00593O00434O00593O002A4O00593O00124O00593O00253O000625005F0012000100082O00593O002B4O00DA8O00593O002A4O00593O004F4O00593O005B4O00593O000A4O00593O00134O00593O00383O00062500600013000100252O00593O002B4O00DA8O00593O002A4O00593O004F4O00593O00544O00593O000A4O00593O00564O00593O00524O00593O003B4O00593O00184O00593O00474O00593O00414O00593O00404O00593O00464O00DA3O00014O00593O00144O00DA3O00024O00593O00074O00593O00124O00593O004A4O00593O00044O00593O002E4O00593O00134O00593O00364O00593O00504O00593O003D4O00593O004E4O00593O00424O00593O00554O00593O00574O00593O00534O00593O003F4O00593O00334O00593O003A4O00593O00514O00593O00114O00593O005F3O000625006100140001001D2O00593O002B4O00DA8O00593O00124O00593O000A4O00593O00074O00593O003C4O00DA3O00014O00593O003A4O00593O00504O00DA3O00024O00593O00144O00593O00044O00593O002E4O00593O00184O00593O00134O00593O002A4O00593O004F4O00593O005A4O00593O00414O00593O00404O00593O00474O00593O00464O00593O00594O00593O00114O00593O00584O00593O004A4O00593O005F4O00593O004E4O00593O00423O00062500620015000100032O00593O002A4O00593O002D4O00593O00183O000625006300160001002D2O00593O00164O00DA8O00593O00174O00593O00074O00593O00134O00593O002B4O00593O004F4O00593O000A4O00593O00294O00593O00184O00593O00194O00593O00504O00593O002A4O00593O00324O00593O005D4O00593O00404O00593O00434O00593O00454O00593O00044O00593O00414O00593O00424O00593O00464O00593O00264O00593O00624O00593O005C4O00593O005E4O00593O003A4O00DA3O00014O00593O00144O00593O00444O00DA3O00024O00593O00114O00593O00334O00593O00124O00593O001A4O00593O00384O00593O00614O00593O00604O00593O00394O00593O00204O00593O001F4O00593O002C4O00593O002E4O00593O00284O00593O00273O00062500640017000100022O00593O00044O00DA7O00209100650004005800122O006600596O006700636O006800646O0065006800016O00013O00183O003A3O00030C3O004570696353652O74696E677303083O0034EBB1DA0EE0A2DD03043O00AE678EC5030A3O00633B5A0A245DF157244C03073O009836483F58453E03083O00E7C1FA48DDCAE94F03043O003CB4A48E03103O006D4D000122EC1E5150021928F91B575003073O0072383E6549478D03083O008BECCFD0B1E7DCD703043O00A4D889BB03113O00FAE330BEAFF00CE2E925BBA9F025D3EB3403073O006BB28651D2C69E028O0003083O002O0B96D2A336099103053O00CA586EE2A6030F3O00EB0A83FBC3CD08B2F8DECA008CDFFA03053O00AAA36FE29703083O002235A62C47392E0203073O00497150D2582E57030E3O00B43FC83AE28020D91AF49523C31703053O0087E14CAD7203083O0029E8ACA4A5B3A00903073O00C77A8DD8D0CCDD030D3O0085D811FC6CFEBEC91FFE7DDE9D03063O0096CDBD70901803083O001681AB580D86162O03083O007045E4DF2C64E87103113O00FD1113D6A46E93C40B30DAA274B5C00A0903073O00E6B47F67B3D61C03083O00BF004B52ED4FE79F03073O0080EC653F26842103163O0085A70541A4F9DABCBD3E4ABAF2F8A4A00541BAE2DCB803073O00AFCCC97124D68B03083O0074C921C80D49CB2603053O006427AC55BC03123O008476AD8521BF6DA99407A56ABC933BA274BD03053O0053CD18D9E003083O00D5C0D929EFCBCA2E03043O005D86A5AD03123O0091E7D5ED3CEDBD73BCF3D5EA3FCFBE77B0F503083O001EDE92A1A25AAED203083O00D64B641EEC40771903043O006A852E10030D3O00752161F775466C2876CB534C5C03063O00203840139C3A03083O0069CDF14253FC874903073O00E03AA885363A92030E3O00745944F37E8F892D564446D25AA503083O006B39362B9D15E6E703083O00E88E05E1B0D22OC803073O00AFBBEB7195D9BC030A3O001EAE9347F072713287B103073O00185CCFE12C831903083O0078D6AC5812734CC003063O001D2BB3D82C7B030E3O0093D83459AFDC337AB4DE294095E903043O002CDDB94000C13O00122C012O00016O000100013O00122O000200023O00122O000300036O0001000300028O00014O000100013O00122O000200043O00122O000300056O0001000300028O00019O0000124O00016O000100013O00122O000200063O00122O000300076O0001000300028O00014O000100013O00122O000200083O00122O000300096O0001000300028O00016O00023O00124O00016O000100013O00122O0002000A3O00122O0003000B6O0001000300028O00014O000100013O00122O0002000C3O00122O0003000D6O0001000300028O000100064O0026000100010004F03O0026000100123C3O000E4O00843O00033O0012BA3O00016O000100013O00122O0002000F3O00122O000300106O0001000300028O00014O000100013O00122O000200113O00122O000300126O0001000300028O000100064O0035000100010004F03O0035000100123C3O000E4O00843O00043O00123D3O00014O000C000100013O00122O000200133O00122O000300146O0001000300028O00012O000C000100013O00122O000200153O00122O000300166O0001000300028O00012O00843O00053O0012BA3O00016O000100013O00122O000200173O00122O000300186O0001000300028O00014O000100013O00122O000200193O00122O0003001A6O0001000300028O000100064O0050000100010004F03O0050000100123C3O000E4O00843O00063O0012BA3O00016O000100013O00122O0002001B3O00122O0003001C6O0001000300028O00014O000100013O00122O0002001D3O00122O0003001E6O0001000300028O000100064O005F000100010004F03O005F000100123C3O000E4O00843O00073O0012BA3O00016O000100013O00122O0002001F3O00122O000300206O0001000300028O00014O000100013O00122O000200213O00122O000300226O0001000300028O000100064O006E000100010004F03O006E000100123C3O000E4O00843O00083O0012BA3O00016O000100013O00122O000200233O00122O000300246O0001000300028O00014O000100013O00122O000200253O00122O000300266O0001000300028O000100064O007D000100010004F03O007D000100123C3O000E4O00843O00093O00123D3O00014O000C000100013O00122O000200273O00122O000300286O0001000300028O00012O000C000100013O00122O000200293O00122O0003002A6O0001000300028O00012O00843O000A3O00122C012O00016O000100013O00122O0002002B3O00122O0003002C6O0001000300028O00014O000100013O00122O0002002D3O00122O0003002E6O0001000300028O00016O000B3O00124O00016O000100013O00122O0002002F3O00122O000300306O0001000300028O00014O000100013O00122O000200313O00122O000300326O0001000300028O00016O000C3O00124O00016O000100013O00122O000200333O00122O000300346O0001000300028O00014O000100013O00122O000200353O00122O000300366O0001000300028O000100064O00B0000100010004F03O00B0000100123C3O000E4O00843O000D3O0012BA3O00016O000100013O00122O000200373O00122O000300386O0001000300028O00014O000100013O00122O000200393O00122O0003003A6O0001000300028O000100064O00BF000100010004F03O00BF000100123C3O000E4O00843O000E4O00543O00017O000A3O00028O00026O00A840025O00C4AA40025O0088AF40025O0017B140030C3O0047657445717569706D656E74026O002A40026O00F03F025O00B0AE40026O002C4000373O00123C3O00014O0040000100013O0026C53O0006000100010004F03O00060001002E2800030002000100020004F03O0002000100123C000100013O0026C50001000B000100010004F03O000B0001002EF70005001E000100040004F03O001E00012O00DA000200013O0020110102000200064O0002000200024O00028O00025O00202O00020002000700062O0002001900013O0004F03O001900012O00DA000200034O00DA00035O0020220003000300072O00600002000200020006640002001C000100010004F03O001C00012O00DA000200033O00123C000300014O00600002000200022O0084000200023O00123C000100083O002E90000900E9FF2O00090004F03O0007000100262900010007000100080004F03O000700012O00DA00025O00202200020002000A0006D50002002C00013O0004F03O002C00012O00DA000200034O00DA00035O00202200030003000A2O00600002000200020006640002002F000100010004F03O002F00012O00DA000200033O00123C000300014O00600002000200022O0084000200044O008200026O0084000200053O0004F03O003600010004F03O000700010004F03O003600010004F03O000200012O00543O00017O00093O00028O00025O008AA440025O007AA740026O00F03F024O0080B3C540025O0078A440025O00607A40025O00A09D40025O00049D4000293O00123C3O00014O0040000100013O000EFB0001000600013O0004F03O00060001002E2800030002000100020004F03O0002000100123C000100013O0026290001000C000100040004F03O000C000100123C000200054O008400025O0004F03O002800010026C500010010000100010004F03O00100001002E2800060007000100070004F03O0007000100123C000200014O0040000300033O00262900020012000100010004F03O0012000100123C000300013O002EF70009001E000100080004F03O001E00010026290003001E000100010004F03O001E00012O008200046O0084000400013O00123C000400054O0084000400023O00123C000300043O00262900030015000100040004F03O0015000100123C000100043O0004F03O000700010004F03O001500010004F03O000700010004F03O001200010004F03O000700010004F03O002800010004F03O000200012O00543O00017O000D3O00028O00025O00E89640025O00C07E40026O00F03F03113O006789E02C5C89E2394788ED194F8BE6235A03043O004D2EE783030B3O004973417661696C61626C65030B3O00935AB541A85AB754B35BB803043O0020DA34D603123O006D123DADE2A44C5B42363DA1F6BE485F402O03083O003A2E7751C891D025025O00208B40025O001AAE4000343O00123C3O00014O0040000100023O002E280003002B000100020004F03O002B00010026293O002B000100040004F03O002B000100262900010006000100010004F03O0006000100123C000200013O00262900020009000100010004F03O000900012O00DA000300014O00A5000400023O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003001D00013O0004F03O001D00012O00DA000300014O0018010400023O00122O000500083O00122O000600096O0004000600024O00030003000400062O00030023000100010004F03O002300012O00DA000300014O000C000400023O00122O0005000A3O00122O0006000B6O0004000600024O0003000300042O008400036O008200036O0084000300033O0004F03O003300010004F03O000900010004F03O003300010004F03O000600010004F03O00330001002EF7000C00020001000D0004F03O00020001000EF20001000200013O0004F03O0002000100123C000100014O0040000200023O00123C3O00043O0004F03O000200012O00543O00017O00373O00028O00025O005C9C40025O006DB240026O00F03F025O00AEAC40026O006B40025O00C07140025O0072A940025O003EA140025O004EA040025O0020614003053O0067A8C0AF5803043O00DB30DAA1025O00A6AE40025O009BB240025O00409B40026O006F40025O00F89140030F3O00323D13365207260E3F7B0E2003294903053O003D6152665A030B3O004973417661696C61626C6503063O0042752O665570030C3O0045636C69707365536F6C6172029A5O99F93F025O0034AF40025O00607240026O002040025O00A49940025O00A88540030A3O00D378704DE85AF2E3746F03073O008084111C29BB2F027O004003083O009F3AAA59C15E2O0C03083O0069CC4ECB2BA7377E025O00A7B140025O0076A14003123O0057612O72696F726F66456C756E6542752O66026O66F63F030F3O000454CA258F504A3F5EF92692534D2303073O003E573BBF49E036030C3O0045636C697073654C756E6172025O00E08B40025O00F49240025O00E2A940025O002FB240029A5O99C93F025O00E8AE40025O0022A540026O002440030A3O0092A32F1A2011D556A0B903083O0031C5CA437E7364A7025O009C9E40025O00BAA740025O00649340025O004AA14001F63O00123C000100014O0040000200043O0026C500010006000100010004F03O00060001002EF700030009000100020004F03O0009000100123C000200014O0040000300033O00123C000100043O000EF200040002000100010004F03O000200012O0040000400043O002E90000500DF000100050004F03O00EB0001002629000200EB000100040004F03O00EB000100123C000500013O002E2800060011000100070004F03O0011000100262900050011000100010004F03O00110001002EF70009001A000100080004F03O001A00010026290003001A000100040004F03O001A00012O00A1000400023O00262900030010000100010004F03O0010000100123C000600013O0026C500060021000100010004F03O00210001002EF7000A00E20001000B0004F03O00E2000100123C000400014O006500078O000800013O00122O0009000C3O00122O000A000D6O0008000A00024O00070007000800064O0071000100070004F03O0071000100123C000700014O0040000800083O000EFB00010030000100070004F03O00300001002E28000F002C0001000E0004F03O002C000100123C000800013O002E9000100019000100100004F03O004A00010026290008004A000100040004F03O004A0001002E28001100E1000100120004F03O00E100012O00DA00096O00A5000A00013O00122O000B00133O00122O000C00146O000A000C00024O00090009000A00202O0009000900154O00090002000200062O000900E100013O0004F03O00E100012O00DA000900023O0020530009000900164O000B5O00202O000B000B00174O0009000B000200062O000900E100013O0004F03O00E1000100201F0004000400180004F03O00E1000100262900080031000100010004F03O0031000100123C000900013O00262900090051000100040004F03O0051000100123C000800043O0004F03O00310001002E28001A004D000100190004F03O004D00010026290009004D000100010004F03O004D000100123C0004001B3O002EF7001D006B0001001C0004F03O006B00012O00DA000A6O00A5000B00013O00122O000C001E3O00122O000D001F6O000B000D00024O000A000A000B00202O000A000A00154O000A0002000200062O000A006B00013O0004F03O006B00012O00DA000A00034O0039000B00043O00122O000C00206O000A000C00024O000B00046O000C00043O00122O000D00206O000B000D00024O0004000A000B00123C000900043O0004F03O004D00010004F03O003100010004F03O00E100010004F03O002C00010004F03O00E100012O00DA00076O000C000800013O00122O000900213O00122O000A00226O0008000A00024O00070007000800060E012O007B000100070004F03O007B0001002EF7002300E1000100240004F03O00E1000100123C000700013O002629000700BF000100040004F03O00BF00012O00DA000800023O0020530008000800164O000A5O00202O000A000A00254O0008000A000200062O0008008600013O0004F03O0086000100201F0004000400262O00DA00086O00A5000900013O00122O000A00273O00122O000B00286O0009000B00024O00080008000900202O0008000800154O00080002000200062O000800E100013O0004F03O00E100012O00DA000800023O0020530008000800164O000A5O00202O000A000A00294O0008000A000200062O000800E100013O0004F03O00E1000100123C000800014O0040000900093O0026290008009D000100040004F03O009D00012O00DC0004000400090004F03O00E10001002EF7002A00990001002B0004F03O0099000100262900080099000100010004F03O0099000100123C000A00013O002E28002C00B80001002D0004F03O00B80001002629000A00B8000100010004F03O00B800012O00DA000B00033O0012B3000C00046O000D00053O00102O000D002E000D4O000B000D00024O000C00043O00122O000D00046O000E00053O00102O000E002E000E4O000C000E00024O0009000B000C00261B010900B7000100180004F03O00B70001002EF7002F00B6000100300004F03O00B600010004F03O00B7000100123C000900183O00123C000A00043O000EF2000400A20001000A0004F03O00A2000100123C000800043O0004F03O009900010004F03O00A200010004F03O009900010004F03O00E100010026290007007C000100010004F03O007C000100123C000800013O000EF2000100D9000100080004F03O00D9000100123C000400314O008C00098O000A00013O00122O000B00323O00122O000C00336O000A000C00024O00090009000A00202O0009000900154O00090002000200062O000900D800013O0004F03O00D800012O00DA000900034O0039000A00043O00122O000B00206O0009000B00024O000A00046O000B00043O00122O000C00206O000A000C00024O00040009000A00123C000800043O002EF7003400C2000100350004F03O00C20001002629000800C2000100040004F03O00C2000100123C000700043O0004F03O007C00010004F03O00C200010004F03O007C000100123C000600043O000EF20004001D000100060004F03O001D000100123C000300043O0004F03O001000010004F03O001D00010004F03O001000010004F03O001100010004F03O001000010004F03O00F500010026C5000200EF000100010004F03O00EF0001002EF70037000C000100360004F03O000C000100123C000300014O0040000400043O00123C000200043O0004F03O000C00010004F03O00F500010004F03O000200012O00543O00017O000E3O00028O00025O0029B340025O006EB340026O00F03F025O00CAAB40025O00107740025O000AAC40025O0056A740030D3O00446562752O6652656D61696E73030D3O0053756E66697265446562752O6603113O00446562752O665265667265736861626C65027O004003093O0054696D65546F446965026O001840013A3O00123C000100014O0040000200043O002EF700020009000100030004F03O0009000100262900010009000100010004F03O0009000100123C000200014O0040000300033O00123C000100043O002E90000500F9FF2O00050004F03O0002000100262900010002000100040004F03O000200012O0040000400043O002E9000060023000100060004F03O0031000100262900020031000100040004F03O00310001000EFB00010016000100030004F03O00160001002EF700070012000100080004F03O0012000100123C000500013O00262900050017000100010004F03O0017000100206100063O00092O009F00085O00202O00080008000A4O0006000800024O000400063O00202O00063O000B4O00085O00202O00080008000A4O00060008000200062O0006002D00013O0004F03O002D00010026460004002B0001000C0004F03O002B000100206100063O000D2O00600006000200022O002F000600060004000EC1000E002C000100060004F03O002C00012O002600066O0082000600014O00A1000600023O0004F03O001700010004F03O001200010004F03O003900010026290002000E000100010004F03O000E000100123C000300014O0040000400043O00123C000200043O0004F03O000E00010004F03O003900010004F03O000200012O00543O00017O00063O0003113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O6603123O0041737472616C506F7765724465666963697403073O00D417F4CFEE10FF03043O00A987629A030E3O00456E657267697A65416D6F756E7401263O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001002400013O0004F03O002400012O00DA000100013O0020262O01000100034O0001000200024O000200026O000300036O00048O000500043O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400064O000400056O00023O00024O000300056O000400036O00058O000600043O00122O000700043O00122O000800056O0006000800024O00050005000600202O0005000500064O000500066O00033O00024O00020002000300062O00020023000100010004F03O002300012O002600016O0082000100014O00A1000100024O00543O00017O00083O00028O00026O00F03F030D3O00446562752O6652656D61696E73030E3O004D2O6F6E66697265446562752O6603113O00446562752O665265667265736861626C65027O004003093O0054696D65546F446965026O00184001283O00123C000100014O0040000200033O00262900010007000100010004F03O0007000100123C000200014O0040000300033O00123C000100023O00262900010002000100020004F03O00020001000EF200010009000100020004F03O0009000100123C000400013O000EF20001000C000100040004F03O000C000100206100053O00032O009F00075O00202O0007000700044O0005000700024O000300053O00202O00053O00054O00075O00202O0007000700044O00050007000200062O0005002200013O0004F03O0022000100264600030020000100060004F03O0020000100206100053O00072O00600005000200022O002F000500050003000EC100080021000100050004F03O002100012O002600056O0082000500014O00A1000500023O0004F03O000C00010004F03O000900010004F03O002700010004F03O000200012O00543O00017O00063O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O6603123O0041737472616C506F7765724465666963697403083O00E6782B5AFB3ADACE03073O00A8AB1744349D53030E3O00456E657267697A65416D6F756E7401263O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001002400013O0004F03O002400012O00DA000100013O0020262O01000100034O0001000200024O000200026O000300036O00048O000500043O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400064O000400056O00023O00024O000300056O000400036O00058O000600043O00122O000700043O00122O000800056O0006000800024O00050005000600202O0005000500064O000500066O00033O00024O00020002000300062O00020023000100010004F03O002300012O002600016O0082000100014O00A1000100024O00543O00017O00103O00028O00025O001AB140025O004AA640026O00F03F025O00C09A40025O0024AC40030D3O00446562752O6652656D61696E7303123O005374652O6C6172466C617265446562752O6603113O00446562752O665265667265736861626C6503123O0041737472616C506F77657244656669636974030C3O00C765F0A1292C95D27DF4BF2003073O00E7941195CD454D030E3O00456E657267697A65416D6F756E74027O004003093O0054696D65546F446965026O00204001443O00123C000100014O0040000200033O002EF70003003D000100020004F03O003D00010026290001003D000100040004F03O003D00010026C50002000A000100010004F03O000A0001002EF700060006000100050004F03O0006000100206100043O00072O009F00065O00202O0006000600084O0004000600024O000300043O00202O00043O00094O00065O00202O0006000600084O00040006000200062O0004003A00013O0004F03O003A00012O00DA000400013O0020F500040004000A4O0004000200024O000500026O000600036O00078O000800043O00122O0009000B3O00122O000A000C6O0008000A00024O00070007000800202O00070007000D4O000700086O00053O00024O000600056O000700036O00088O000900043O00122O000A000B3O00122O000B000C6O0009000B00024O00080008000900202O00080008000D4O000800096O00063O00024O00050005000600062O00050038000100040004F03O00380001002646000300380001000E0004F03O0038000100206100043O000F2O00600004000200022O002F000400040003000EC100100039000100040004F03O003900012O002600046O0082000400014O00A1000400023O0004F03O000600010004F03O0043000100262900010002000100010004F03O0002000100123C000200014O0040000300033O00123C000100043O0004F03O000200012O00543O00017O00063O0003113O00446562752O665265667265736861626C6503123O005374652O6C6172466C617265446562752O6603123O0041737472616C506F77657244656669636974030C3O002OB3C2F75BFE9281CBFA45FA03063O009FE0C7A79B37030E3O00456E657267697A65416D6F756E7401263O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001002400013O0004F03O002400012O00DA000100013O0020262O01000100034O0001000200024O000200026O000300036O00048O000500043O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400064O000400056O00023O00024O000300056O000400036O00058O000600043O00122O000700043O00122O000800056O0006000800024O00050005000600202O0005000500064O000500066O00033O00024O00020002000300062O00020023000100010004F03O002300012O002600016O0082000100014O00A1000100024O00543O00017O000A3O0003113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O6603093O0054696D65546F446965030D3O00446562752O6652656D61696E73027O0040026O00184003123O0041737472616C506F7765724465666963697403073O00C4E632D4FEE13903043O00B297935C030E3O00456E657267697A65416D6F756E7401333O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001003100013O0004F03O0031000100206100013O00032O00A80001000200024O000200013O00202O0002000200044O00045O00202O0004000400024O0002000400024O0001000100024O000200023O00202O00020002000500102O00020006000200062O0002002F000100010004F03O002F00012O00DA000100033O0020262O01000100074O0001000200024O000200046O000300056O00048O000500063O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O000400056O00023O00024O000300076O000400056O00058O000600063O00122O000700083O00122O000800096O0006000800024O00050005000600202O00050005000A4O000500066O00033O00024O00020002000300062O00020030000100010004F03O003000012O002600016O0082000100014O00A1000100024O00543O00017O00093O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O6603093O0054696D65546F446965030D3O00446562752O6652656D61696E73026O00184003123O0041737472616C506F7765724465666963697403083O00A1F2433C1445688903073O001AEC9D2C52722C030E3O00456E657267697A65416D6F756E7401303O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001002E00013O0004F03O002E000100206100013O00033O002O01000200024O000200013O00202O0002000200044O00045O00202O0004000400024O0002000400024O000100010002000E2O0005002C000100010004F03O002C00012O00DA000100023O0020262O01000100064O0001000200024O000200036O000300046O00048O000500053O00122O000600073O00122O000700086O0005000700024O00040004000500202O0004000400094O000400056O00023O00024O000300066O000400046O00058O000600053O00122O000700073O00122O000800086O0006000800024O00050005000600202O0005000500094O000500066O00033O00024O00020002000300062O0002002D000100010004F03O002D00012O002600016O0082000100014O00A1000100024O00543O00017O00063O0003113O00446562752O665265667265736861626C6503123O005374652O6C6172466C617265446562752O6603093O0054696D65546F446965030D3O00446562752O6652656D61696E73031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74026O00204001203O00205300013O00014O00035O00202O0003000300024O00010003000200062O0001001E00013O0004F03O001E000100206100013O00032O00A400010002000200202O00023O00044O00045O00202O0004000400024O0002000400024O00010001000200202O00023O000500122O000400066O0002000400024O0001000100024O000200013O00122O000300066O000400026O0002000400024O000300033O00122O000400066O000500026O0003000500024O00020002000300062O0002001D000100010004F03O001D00012O002600016O0082000100014O00A1000100024O00543O00017O00053O00030D3O00446562752O6652656D61696E73030E3O004D2O6F6E66697265446562752O66030D3O0053756E66697265446562752O66026O003640026O00324001103O00208E00013O00014O00035O00202O0003000300024O00010003000200202O00023O00014O00045O00202O0004000400034O00020004000200202O00020002000400202O00020002000500062O0002000D000100010004F03O000D00012O002600016O0082000100014O00A1000100024O00543O00017O00223O00028O00025O00BBB140025O005AA54003063O0042752O665570030C3O0045636C69707365536F6C6172030C3O0045636C697073654C756E6172026O00F03F025O004EA440025O00188040025O0054AD40025O0050894003083O0042752O66446F776E025O00849940025O00E49E40027O0040026O000840025O00B0B140025O0046AC4003083O00193AD4492C27C75E03043O003B4A4EB503053O00436F756E7403053O0012C35B4EBB03053O00D345B12O3A03093O00497343617374696E6703053O00577261746803053O0080F7782OE103063O00ABD78519958903083O00D2DC33E8E939EE4703083O002281A8529A8F509C03083O00537461726669726503053O00B2A0321F4003073O00E9E5D2536B282E03083O00F25633C403C8503703053O0065A12252B600DB3O00123C3O00014O0040000100013O0026293O0002000100010004F03O0002000100123C000100013O00262900010034000100010004F03O0034000100123C000200013O0026290002002F000100010004F03O002F000100123C000300013O002E280003002A000100020004F03O002A00010026290003002A000100010004F03O002A00012O00DA000400013O0020310104000400044O000600023O00202O0006000600054O00040006000200062O0004001B000100010004F03O001B00012O00DA000400013O0020610004000400042O00DA000600023O0020220006000600062O00690004000600022O008400046O00B7000400013O00202O0004000400044O000600023O00202O0006000600054O00040006000200062O0004002800013O0004F03O002800012O00DA000400013O0020610004000400042O00DA000600023O0020220006000600062O00690004000600022O0084000400033O00123C000300073O0026290003000B000100070004F03O000B000100123C000200073O0004F03O002F00010004F03O000B0001000EF200070008000100020004F03O0008000100123C000100073O0004F03O003400010004F03O0008000100262900010067000100070004F03O0067000100123C000200013O000EFB0001003B000100020004F03O003B0001002E2800080062000100090004F03O0062000100123C000300013O0026C500030040000100010004F03O00400001002EF7000A005B0001000B0004F03O005B00012O00DA000400013O0020530004000400044O000600023O00202O0006000600064O00040006000200062O0004004C00013O0004F03O004C00012O00DA000400013O00206100040004000C2O00DA000600023O0020220006000600052O00690004000600022O0084000400044O00B7000400013O00202O0004000400044O000600023O00202O0006000600054O00040006000200062O0004005900013O0004F03O005900012O00DA000400013O00206100040004000C2O00DA000600023O0020220006000600062O00690004000600022O0084000400053O00123C000300073O002E28000D003C0001000E0004F03O003C00010026290003003C000100070004F03O003C000100123C000200073O0004F03O006200010004F03O003C000100262900020037000100070004F03O0037000100123C0001000F3O0004F03O006700010004F03O00370001000EF2000F00BA000100010004F03O00BA000100123C000200013O0026290002006E000100070004F03O006E000100123C000100103O0004F03O00BA0001002E280012006A000100110004F03O006A00010026290002006A000100010004F03O006A00012O00DA00035O00066400030090000100010004F03O009000012O00DA000300024O00C2000400073O00122O000500133O00122O000600146O0004000600024O00030003000400202O0003000300154O00030002000200262O00030089000100010004F03O008900012O00DA000300024O004A000400073O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300154O000300020002000E2O00010093000100030004F03O009300012O00DA000300013O0020310103000300184O000500023O00202O0005000500194O00030005000200062O00030094000100010004F03O009400012O00DA000300053O0004F03O009400012O002600036O0082000300014O0084000300064O00DA00035O000664000300B3000100010004F03O00B300012O00DA000300024O00C2000400073O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O0003000300154O00030002000200262O000300AC000100010004F03O00AC00012O00DA000300024O004A000400073O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O0003000300154O000300020002000E2O000100B6000100030004F03O00B600012O00DA000300013O0020310103000300184O000500023O00202O00050005001E4O00030005000200062O000300B7000100010004F03O00B700012O00DA000300043O0004F03O00B700012O002600036O0082000300014O0084000300083O00123C000200073O0004F03O006A000100262900010005000100100004F03O000500012O00DA00025O000664000200D3000100010004F03O00D300012O00DA000200024O0079000300073O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O0002000200154O000200020002000E2O000100D3000100020004F03O00D300012O00DA000200024O004A000300073O00122O000400213O00122O000500226O0003000500024O00020002000300202O0002000200154O000200020002000E2O000100D4000100020004F03O00D400012O002600026O0082000200014O0084000200093O0004F03O00DA00010004F03O000500010004F03O00DA00010004F03O000200012O00543O00017O00153O00028O00025O00806540025O0058A040026O00F03F025O0090A040025O00BCA240025O00607640027O004003073O0049735265616479030F3O00432O6F6C646F776E52656D61696E73025O00A6A240025O001DB240025O00C49340025O00AEA540025O004EB140025O0080494003123O00CB0855FBC8F68B2FE42C55F7DCEC8F2BE61903083O004E886D399EBB82E2030B3O004973417661696C61626C6503113O001731FAF02C31F8E53730F7C53F33FCFF2A03043O00915E5F9900A83O00123C3O00014O0040000100023O0026C53O0006000100010004F03O00060001002E2800030009000100020004F03O0009000100123C000100014O0040000200023O00123C3O00043O002E90000500F9FF2O00050004F03O000200010026293O0002000100040004F03O00020001000EF20001000D000100010004F03O000D000100123C000200013O0026C500020014000100040004F03O00140001002E900006005F000100070004F03O0071000100123C000300013O00262900030019000100040004F03O0019000100123C000200083O0004F03O0071000100262900030015000100010004F03O0015000100123C000400013O00262900040069000100010004F03O006900012O00DA000500014O00D400068O000700026O000800033O00202O0008000800094O00080002000200062O0008002D000100010004F03O002D00012O00DA000800033O00206100080008000A2O0060000800020002000EC10001002C000100080004F03O002C00012O002600086O0082000800014O0045000700084O001A00053O00024O000600046O00078O000800026O000900033O00202O0009000900094O00090002000200062O0009003E000100010004F03O003E00012O00DA000900033O00206100090009000A2O0060000900020002000EC10001003D000100090004F03O003D00012O002600096O0082000900014O0045000800094O001501063O00022O00BD0005000500062O008400056O00DA000500014O00D400068O000700026O000800053O00202O0008000800094O00080002000200062O00080051000100010004F03O005100012O00DA000800053O00206100080008000A2O0060000800020002000EC100010050000100080004F03O005000012O002600086O0082000800014O00600007000200020020180007000700084O0005000700024O000600046O00078O000800026O000900053O00202O0009000900094O00090002000200062O00090063000100010004F03O006300012O00DA000900053O00206100090009000A2O0060000900020002000EC100010062000100090004F03O006200012O002600096O0082000900014O006000080002000200203B0008000800084O0006000800024O0005000500064O00055O00122O000400043O002EF7000B001C0001000C0004F03O001C00010026290004001C000100040004F03O001C000100123C000300043O0004F03O001500010004F03O001C00010004F03O00150001002EF7000D00780001000E0004F03O0078000100262900020078000100080004F03O007800012O0082000300014O0084000300063O0004F03O00A7000100262900020010000100010004F03O0010000100123C000300013O0026C50003007F000100010004F03O007F0001002EF7000F009D000100100004F03O009D00012O00DA000400084O000A010500093O00122O000600113O00122O000700126O0005000700024O00040004000500202O0004000400134O00040002000200062O00040093000100010004F03O009300012O00DA000400084O00A5000500093O00122O000600143O00122O000700156O0005000700024O00040004000500202O0004000400134O00040002000200062O0004009800013O0004F03O009800012O00DA0004000A4O009A0004000100022O00F1000400043O0004F03O009900012O002600046O0082000400014O0084000400073O00123C000400014O008400045O00123C000300043O0026290003007B000100040004F03O007B000100123C000200043O0004F03O001000010004F03O007B00010004F03O001000010004F03O00A700010004F03O000D00010004F03O00A700010004F03O000200012O00543O00017O00483O00028O00026O00F03F025O003C9D40025O00389F40025O0046A040025O00E4AE40025O00049D40025O00804D4003053O0006907DA83903043O00DC51E21C030A3O0049734361737461626C6503093O00497343617374696E6703053O005772617468030E3O0049735370652O6C496E52616E676503053O0004C783EFE203063O00A773B5E29B8A03053O00D530E6487303073O00A68242873C1B1103053O007358CF613803053O0050242AAE1503053O00436F756E74027O004003073O005072657647434403053O007902366E4603043O001A2E7057025O00409340025O00CAA740026O005A4003053O00AE31AA60B703083O00D4D943CB142ODF25025O00B6B140025O002EA740030D3O00D0CC06DE61B1C9C511E247BBF903063O00D79DAD74B52E03103O0047726F757042752O664D692O73696E67030D3O004D61726B4F6654686557696C64025O00F2AA40025O0080A240031A3O0038B599F9E53AB2B4E6D2308B9CFBD631F49BE0DF36BB86F0DB2103053O00BA55D4EB92030B3O00EF8E19F032E756E48E04F303073O0038A2E1769E598E025O007DB240025O00B8AB40030B3O004D2O6F6E6B696E466F726D030C3O00510ACFA129D1523AC6A030D503063O00B83C65A0CF42025O00549F40025O004FB240025O009C9B40025O00A08C40025O000AAC40025O00C4AC40030C3O008999ADDEB68CBAF4B68CBAD703043O00B2DAEDC8030C3O005374652O6C6172466C61726503193O00A5A1E3DCBAB4F4EFB0B9E7C2B3F5F6C2B3B6E9DD2OB4F290E003043O00B0D6D58603083O00C7B9B7C6AE5F4BF103073O003994CDD6B4C836030C3O0021E930387A13EF13387700F803053O0016729D5554030B3O004973417661696C61626C65025O00C05240025O00E07A4003083O005374617266697265025O003DB040025O0026A94003143O00D7DF12D65BFFBAC18B03D658F5A72OC912D01DAE03073O00C8A4AB73A43D96025O007C9C40025O00BCA5400025012O00123C3O00014O0040000100023O0026293O001C2O0100020004F03O001C2O01002E2800030004000100040004F03O0004000100262900010004000100010004F03O0004000100123C000200013O0026290002007E000100020004F03O007E000100123C000300013O0026C500030010000100010004F03O00100001002E2800060079000100050004F03O00790001002EF700080035000100070004F03O003500012O00DA00046O00A5000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003500013O0004F03O003500012O00DA000400023O00203101040004000C4O00065O00202O00060006000D4O00040006000200062O00040035000100010004F03O003500012O00DA000400034O00A600055O00202O00050005000D4O000600043O00202O00060006000E4O00085O00202O00080008000D4O0006000800024O000600066O000700056O00040007000200062O0004003500013O0004F03O003500012O00DA000400013O00123C0005000F3O00123C000600104O0034000400064O00C300046O00DA00046O00A5000500013O00122O000600113O00122O000700126O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004006200013O0004F03O006200012O00DA000400023O00205300040004000C4O00065O00202O00060006000D4O00040006000200062O0004005000013O0004F03O005000012O00DA00046O00DD000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400154O00040002000200262O00040064000100160004F03O006400012O00DA000400023O00204D00040004001700122O000600026O00075O00202O00070007000D4O00040007000200062O0004006200013O0004F03O006200012O00DA00046O00DD000500013O00122O000600183O00122O000700196O0005000700024O00040004000500202O0004000400154O00040002000200262O00040064000100020004F03O00640001002E90001A00160001001B0004F03O00780001002E90001C00140001001C0004F03O007800012O00DA000400034O00A600055O00202O00050005000D4O000600043O00202O00060006000E4O00085O00202O00080008000D4O0006000800024O000600066O000700056O00040007000200062O0004007800013O0004F03O007800012O00DA000400013O00123C0005001D3O00123C0006001E4O0034000400064O00C300045O00123C000300023O0026290003000C000100020004F03O000C000100123C000200163O0004F03O007E00010004F03O000C0001002629000200CB000100010004F03O00CB000100123C000300013O002EF7002000C40001001F0004F03O00C40001000EF2000100C4000100030004F03O00C4000100123C000400013O0026290004008A000100020004F03O008A000100123C000300023O0004F03O00C4000100262900040086000100010004F03O008600012O00DA00056O00A5000600013O00122O000700213O00122O000800226O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500AB00013O0004F03O00AB00012O00DA000500063O0020E40005000500234O00065O00202O0006000600244O00050002000200062O000500AB00013O0004F03O00AB00012O00DA000500074O007400065O00202O0006000600244O000700086O00050007000200062O000500A6000100010004F03O00A60001002E28002500AB000100260004F03O00AB00012O00DA000500013O00123C000600273O00123C000700284O0034000500074O00C300056O00DA00056O00A5000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500C200013O0004F03O00C20001002E28002C00C20001002B0004F03O00C200012O00DA000500034O00DA00065O00202200060006002D2O00600005000200020006D5000500C200013O0004F03O00C200012O00DA000500013O00123C0006002E3O00123C0007002F4O0034000500074O00C300055O00123C000400023O0004F03O008600010026C5000300C8000100020004F03O00C80001002EF700310081000100300004F03O0081000100123C000200023O0004F03O00CB00010004F03O008100010026C5000200CF000100160004F03O00CF0001002E2800320009000100330004F03O00090001002EF7003400ED000100350004F03O00ED00012O00DA00036O00A5000400013O00122O000500363O00122O000600376O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300ED00013O0004F03O00ED00012O00DA000300074O000B00045O00202O0004000400384O000500066O000700043O00202O00070007000E4O00095O00202O0009000900384O0007000900024O000700076O00030007000200062O000300ED00013O0004F03O00ED00012O00DA000300013O00123C000400393O00123C0005003A4O0034000300054O00C300036O00DA00036O00A5000400013O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003O013O0004F03O003O012O00DA00036O00A5000400013O00122O0005003D3O00122O0006003E6O0004000600024O00030003000400202O00030003003F4O00030002000200062O000300032O013O0004F03O00032O01002E28004100242O0100400004F03O00242O012O00DA000300074O003100045O00202O0004000400424O000500066O000700043O00202O00070007000E4O00095O00202O0009000900424O0007000900024O000700076O00030007000200062O000300122O0100010004F03O00122O01002E28004300242O0100440004F03O00242O012O00DA000300013O00125B000400453O00122O000500466O000300056O00035O00044O00242O010004F03O000900010004F03O00242O010004F03O000400010004F03O00242O01002EF700470002000100480004F03O000200010026293O0002000100010004F03O0002000100123C000100014O0040000200023O00123C3O00023O0004F03O000200012O00543O00017O002E3O00028O00025O00D4AA40025O00909B40026O00F03F03073O002135367AB5661703063O00147240581CDC030A3O0049734361737461626C65025O0090AF40025O00709C4003093O00436173744379636C6503073O0053756E66697265030E3O0049735370652O6C496E52616E676503123O002214DCB2F1C2B87107D3B8F4C4B5231492E203073O00DD5161B2D498B003083O00E0E812F51CC4F51803053O007AAD877D9B025O0060B040025O00C2A34003083O004D2O6F6E6669726503133O0089CE0FB73938DA2O8106B8333DDC8CD315F96703073O00A8E4A160D95F51025O00489840025O002AA240025O00509140025O00ADB140025O000FB140025O0008AA4003083O008DE0025785BFF80F03053O00E3DE94632503073O004973526561647903083O005374617266612O6C03093O004973496E52616E6765025O00804640025O00A0A640025O0021B24003133O00204653E4FF322O5EB6FF322O5EE2F1214712A403053O0099532O3296025O00908B40026O00354003093O006E62720E60BE5F5A7303073O002D3D16137C13CB025O008AA240025O00B5B24003093O0053746172737572676503143O00D2060CE71165ABC6174DF3037CB5D51A1FE0422403073O00D9A1726D956210009A3O00123C3O00014O0040000100013O002E2800030002000100020004F03O000200010026293O0002000100010004F03O0002000100123C000100013O00262900010047000100040004F03O004700012O00DA00026O00A5000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002900013O0004F03O00290001002EF700090029000100080004F03O002900012O00DA000200023O00208900020002000A4O00035O00202O00030003000B4O000400036O000500046O000600053O00202O00060006000C4O00085O00202O00080008000B4O0006000800024O000600066O00020006000200062O0002002900013O0004F03O002900012O00DA000200013O00123C0003000D3O00123C0004000E4O0034000200044O00C300026O00DA00026O00A5000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200074O00020002000200062O0002009900013O0004F03O00990001002E2800120099000100110004F03O009900012O00DA000200064O00B900035O00202O0003000300134O000400053O00202O00040004000C4O00065O00202O0006000600134O0004000600024O000400046O00020004000200062O0002009900013O0004F03O009900012O00DA000200013O00125B000300143O00122O000400156O000200046O00025O00044O00990001002EF700160007000100170004F03O0007000100262900010007000100010004F03O0007000100123C000200013O002EF700180052000100190004F03O00520001000EF200040052000100020004F03O0052000100123C000100043O0004F03O000700010026C500020056000100010004F03O00560001002E28001A004C0001001B0004F03O004C00012O00DA00036O00A5000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003001E4O00030002000200062O0003007500013O0004F03O007500012O00DA000300073O0006D50003007500013O0004F03O007500012O00DA000300064O002100045O00202O00040004001F4O000500053O00202O00050005002000122O000700216O0005000700024O000500056O00030005000200062O00030070000100010004F03O00700001002EF700230075000100220004F03O007500012O00DA000300013O00123C000400243O00123C000500254O0034000300054O00C300035O002EF700270094000100260004F03O009400012O00DA00036O00A5000400013O00122O000500283O00122O000600296O0004000600024O00030003000400202O00030003001E4O00030002000200062O0003009400013O0004F03O00940001002E28002A00940001002B0004F03O009400012O00DA000300064O00B900045O00202O00040004002C4O000500053O00202O00050005000C4O00075O00202O00070007002C4O0005000700024O000500056O00030005000200062O0003009400013O0004F03O009400012O00DA000300013O00123C0004002D3O00123C0005002E4O0034000300054O00C300035O00123C000200043O0004F03O004C00010004F03O000700010004F03O009900010004F03O000200012O00543O00017O0066012O00028O00027O0040025O00BC9C40025O00C09140025O00CCAA40026O00F03F025O00608740025O00E0A14003083O00E371BD0D83C76CB703053O00E5AE1ED263030A3O0049734361737461626C6503093O00436173744379636C6503083O004D2O6F6E66697265030E3O0049735370652O6C496E52616E6765030D3O0016E2895FEB342B1EAD9545AD6B03073O00597B8DE6318D5D025O00D88B40025O0079B140030C3O00C065F3001C4BE157FA0D024F03063O002A9311966C70030C3O005374652O6C6172466C61726503133O001CB22873EBE91D992B73E6FA0AE63E6BA7B95F03063O00886FC64D1F87025O00FEA740025O00AEA440025O00C88340025O00A0994003073O00E8C4205A2645DE03063O0037BBB14E3C4F03073O0053756E66697265030C3O003EDB51ED4FDD856DDD4BAB1403073O00E04DAE3F8B26AF030F3O00432O6F6C646F776E52656D61696E73026O00144003093O0054696D65546F446965026O002E40026O007E40026O003940030B3O00AD4F5B2F964F593A8D4E5603043O004EE42138030B3O004973417661696C61626C65026O002440025O0068AD40025O00C8A240025O00C6AD40025O003EB040025O00388740025O0080474003093O00073201D2E6213407C503053O0095544660A003073O0049735265616479025O0080814003063O0042752O665570030F3O00537461727765617665727357656674025O001EAC40025O008C904003093O00537461727375726765030F3O002B120CFF2B131FEA3D461EF978575E03043O008D58666D03083O008047CB621C3447C403083O00A1D333AA107A5D35030E3O00447265616D737461746542752O6603083O005374617266697265030E3O00E8BAB33AFDA7A02DBBBDA668AAFA03043O00489BCED2030C3O00537461726C6F726442752O66030B3O0042752O6652656D61696E73025O00308140030F3O00537461727765617665727357617270025O006C9540025O0096A340030D3O0043617374412O6E6F7461746564030E3O0043616E63656C537461726C6F726403063O002128897598C803083O00C96269C736DD8477031A3O00BA0D8D22073993BB19852742262OB81E8F2E1031ECAA18C3705303073O00CCD96CE341625503083O006DD7F4F72AC152CF03063O00A03EA395854C025O002EAC40025O00D0A340025O00989140025O00B6AC4003083O005374617266612O6C03093O004973496E52616E6765025O00804640030E3O00C5B40C3DC5D7AC016FD0C2E05C7D03053O00A3B6C06D4F025O0020AA40025O003EAC4003053O007168551A3B03053O0053261A346E030C3O0045636C69707365536F6C6172025O00A8B240025O00406A4003053O005772617468030B3O004F0526525057345218467203043O0026387747025O006AA440025O0080A540025O00BEB140025O008EA04003123O00D0EA54D33642FAEE54F7295FF4E155D32B4203063O0036938F38B64503123O0043656C65737469616C416C69676E6D656E7403193O00D584F34CCCC288FE45E0D78DF64ED1DB84F15D9FC595BF188903053O00BFB6E19F29030B3O00021C2B549989C33F1B275B03073O00A24B724835EBE7030B3O00496E6361726E6174696F6E025O003C9040025O0020754003113O00853247E3410C8D284DED5D429F2804B30B03063O0062EC5C248233025O0023B040025O0002B240026O000840025O0040804003073O0048617354696572026O003F4003083O00972O0DA843A1A73503083O0050C4796CDA25C8D503083O004361737454696D65030C3O0045636C697073654C756E617203053O003761036B4303073O00EA6013621F2B6E025O0021B040026O008540025O00D88F40025O0014AB4003083O0012555116FB53312503073O004341213064973C03093O0042752O66537461636B030E3O00424F4154417263616E6542752O66030E3O00424F41544E617475726542752O66026O001040025O00207240025O00B88A4003063O00FCC680FBD6F303053O0093BF87CEB8031A3O008729A8C2DD5F8D863DA0C79840A6853AAACECA57F2973CE6928103073O00D2E448C6A1B833025O00F9B140025O005EB140026O001840030B3O00360120ECF9A8871C013CF003073O00C270745295B6CE026O003E40025O00807140030C3O0041737472616C506F77657250026O004940030B3O00467572794F66456C756E6503133O003FBD5E01FFED0806AD400DCEE74E2ABC0C4B9603073O006E59C82C78A08203083O0098D74A54454B374103083O002DCBA32B26232A5B025O00188F40025O0066A040030E3O00C191DD3181A858DEC5CF37C7FA0C03073O0034B2E5BC43E7C9025O00088E40025O004CAF40025O000CA540025O00F6B24003083O00C6CCEFD747E2D1E503053O00218BA380B9025O004EB040025O002AAD40025O0084A440025O00408440030E3O005A570BD02O5116DB174B109E030C03043O00BE373864025O00EC9840025O003CA040030C3O0065BB39121FE2E170A33D0C1603073O009336CF5C7E7383025O008C9940025O0068844003133O001E253071017F1F0E33710C6C087126694D2A5B03063O001E6D51551D6D025O0034AD4003093O00055DF20260DB244EF603063O00AE5629937013025O00F6AE40025O0086B240030F3O0048148C19361A03AC5E409E1F655B4103083O00CB3B60ED6B456F7103073O001703A2E738E2D203073O00B74476CC815190025O00D0AF40025O0057B240030D3O001DB87EE202900BED63F04BD65C03063O00E26ECD10846B026O001C40026O002240025O0058A140025O0092A64003043O00502O6F6C03063O00EBF6B5F700CD03063O008AA6B9E3BE4E025O0032B340025O002FB14003273O00FB7BCA3B12102D8B70D0321237168B79CA21572E1CC56085365C2759C57B8531532F15DF7CD72203073O0079AB14A5573243025O0098AC4003053O00B0E60532AA03053O00C2E7946446025O00C6A640025O00806840030B3O00515EC0B7FE88555881F1A003063O00A8262CA1C396030E3O00311E40D5A57D99091977CBB97C8E03073O00EB667F32A7CC12025O001EB240025O007CAE40030E3O0057612O72696F726F66456C756E65025O00309140025O0030944003163O0047A0E7314D21429EFA257B2B5CB4FB26043D44E1A77303063O004E30C195432403083O00030A810A47390C8503053O0021507EE078025O00188140025O006EAB40025O00A07340025O00A8A040030E3O00FFBC02D65AE5BA06844FF8E8519003053O003C8CC863A4025O00208D40025O00F6A640025O000EB14003083O001FB3B925A736B8CE03083O00A059C6D549EA59D703123O0041737472616C506F7765724465666963697403083O006E64B8F2E8477EBA03053O00A52811D49E030E3O00456E657267697A65416D6F756E7403083O00C3CC043F0BEAD60603053O004685B96853030B3O004578656375746554696D6503083O0022504826E40B2O4A03053O00A96425244A03083O002886AE562D88AD5E03043O003060E7C203113O00436861726765734672616374696F6E616C026O000440025O0002AF40025O0092AC4003083O0046752O6C4D2O6F6E030F3O00CE4F022126D5A08CC61A1D39598DFD03083O00E3A83A6E4D79B8CF2O033O00474344030F3O005A2FAB52B0D752AA7631AA4EB8D47F03083O00C51B5CDF20D1BB11030F3O00224CD7E90253E0F40E52D6F50A50CD03043O009B633FA3025O008C9540025O00D8964003073O00D174439B39D1F203073O009C9F1134D656BE03073O0080EAAA91A1E0B303043O00DCCE8FDD03073O00A8782O3AD7C3DC03073O00B2E61D4D77B8AC025O00FEB140025O002OAE4003073O004E65774D2O6F6E025O00A89840025O00A08F40030E3O00FBBB1D247AF7FAB04A0863B8A1E603063O009895DE6A7B1703083O00F527FA4598D229F803053O00D5BD46962303083O006754780E625A7B0603043O00682F351403083O008B4D8D1A9100AC4203063O006FC32CE17CDC03083O00F0470C7586A4D74803063O00CBB8266013CB03083O0011727547E3367C7703053O00AE59131921025O00BEA240025O0074AA4003083O0048616C664D2O6F6E030F3O0027135E48C88A04201C125DE3C75E7F03073O006B4F72322E97E7026O00204003093O00B3E8836423FDA4118503083O0076E09CE2165088D603113O0061E157964DE55CB44AEB6A904BFC50945103043O00E0228E3903113O00FDA82OCB7CFA583AD6A2F6CD7AE3541ACD03083O006EBEC7A5BD13913D025O0028AB40025O005DB240025O0016B140025O0022AD40030F3O00C9FF76FA98D2C8EC72A898D39AB92F03063O00A7BA8B1788EB03113O0039BA861B15BE8D3912B0BB1D13A781190903043O006D7AD5E803113O00436F6E766F6B6554686553706972697473026O00444003193O00EDF8AC26E1FCA70FFAFFA70FFDE7AB22E7E3B170FDE3E263BE03043O00508E97C2030F3O0022D5635E02CA54430ECB62420AC97903043O002C63A617030F3O005DE43D2432A85FF8243B26AA75F82703063O00C41C97495653025O004AB340025O00B49440030F3O0041737472616C436F2O6D756E696F6E025O00E4A640025O002EB04003163O00F2103D0283542775FC0E24058C511778B3103D50D10A03083O001693634970E23878025O00388240025O00A06040030D3O009E7AF0F6889773CCF499AD67E703053O00EDD8158295030D3O00A4414D5CB5E658AC4F4B4AA2CC03073O003EE22E2O3FD0A9030D3O00466F7263654F664E617475726503153O00E31647801A322058DA1754970A1F2A1EF60D15D04B03083O003E857935E37F6D4F026O007B40025O00C09640025O0080B04003053O00636607274603073O0018341466532E3403083O0049734D6F76696E67025O00889A40025O00A0A240030B3O00D33D203007843C3564599403053O006FA44F4144025O002EA540025O00C8AD40025O00508740025O0046A240025O0074A740025O00F08B4003063O00A1F08FAE9CA803063O00E4E2B1C1EDD9031A3O0037B12DE531BC1CE421B625A627A422F438BF31E274A337A661E303043O008654D04303093O0020B8874E00B9945B1603043O003C73CCE6025O00809540025O00209040025O00F6A240030F3O00F42EEA62F42FF977E27AF864A76FBF03043O0010875A8B025O0046AB40025O0082AA40025O005AAE40025O00D8B040025O002OA040025O00689B4000E6072O00123C3O00014O0040000100043O0026293O00C3070100020004F03O00C307010026C500010008000100010004F03O00080001002EF7000300B6000100040004F03O00B6000100123C000500013O002E9000050045000100050004F03O004E00010026290005004E000100060004F03O004E0001002E280007002D000100080004F03O002D00012O00DA00066O00A5000700013O00122O000800093O00122O0009000A6O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006002D00013O0004F03O002D00012O00DA000600023O00208900060006000C4O00075O00202O00070007000D4O000800036O000900046O000A00053O00202O000A000A000E4O000C5O00202O000C000C000D4O000A000C00024O000A000A6O0006000A000200062O0006002D00013O0004F03O002D00012O00DA000600013O00123C0007000F3O00123C000800104O0034000600084O00C300065O002EF70011004D000100120004F03O004D00012O00DA00066O00A5000700013O00122O000800133O00122O000900146O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006004D00013O0004F03O004D00012O00DA000600023O00208900060006000C4O00075O00202O0007000700154O000800036O000900066O000A00053O00202O000A000A000E4O000C5O00202O000C000C00154O000A000C00024O000A000A6O0006000A000200062O0006004D00013O0004F03O004D00012O00DA000600013O00123C000700163O00123C000800174O0034000600084O00C300065O00123C000500023O0026C500050052000100020004F03O00520001002E2800180054000100190004F03O0054000100123C000100063O0004F03O00B600010026C500050058000100010004F03O00580001002EF7001B00090001001A0004F03O0009000100123C000600013O0026290006005D000100060004F03O005D000100123C000500063O0004F03O0009000100262900060059000100010004F03O005900012O00DA00076O00A5000800013O00122O0009001C3O00122O000A001D6O0008000A00024O00070007000800202O00070007000B4O00070002000200062O0007007D00013O0004F03O007D00012O00DA000700023O00208900070007000C4O00085O00202O00080008001E4O000900036O000A00076O000B00053O00202O000B000B000E4O000D5O00202O000D000D001E4O000B000D00024O000B000B6O0007000B000200062O0007007D00013O0004F03O007D00012O00DA000700013O00123C0008001F3O00123C000900204O0034000700094O00C300076O00DA000700093O0006D5000700B200013O0004F03O00B200012O00DA0007000A3O0020610007000700212O0060000700020002002646000700B0000100220004F03O00B000012O00DA0007000B3O000664000700B0000100010004F03O00B000012O00DA000700053O0020610007000700232O0060000700020002000E4100240090000100070004F03O009000012O00DA0007000C3O00260F010700B1000100250004F03O00B100012O00DA0007000D4O00DA0008000E3O00123C000900264O00DA000A000F4O00DA000B6O000C000C00013O00122O000D00273O00122O000E00286O000C000E00024O000B000B000C00202B000B000B00294O000B000C6O000A3O000200102O000A002A000A4O0008000A00024O000900103O00122O000A00266O000B000F6O000C6O000C000D00013O00122O000E00273O00122O000F00286O000D000F00024O000C000C000D0020E5000C000C00294O000C000D6O000B3O000200102O000B002A000B4O0009000B00024O00080008000900062O000700B1000100080004F03O00B100012O002600076O0082000700014O0084000700083O00123C000600063O0004F03O005900010004F03O00090001002EF7002C00872O01002B0004F03O00872O01000EF2000600872O0100010004F03O00872O0100123C000500013O0026C5000500BF000100020004F03O00BF0001002E28002E00C10001002D0004F03O00C1000100123C000100023O0004F03O00872O01002629000500172O0100060004F03O00172O01002EF7003000ED0001002F0004F03O00ED00012O00DA00066O00A5000700013O00122O000800313O00122O000900326O0007000900024O00060006000700202O0006000600334O00060002000200062O000600ED00013O0004F03O00ED00012O00DA0006000C3O000EE7003400ED000100060004F03O00ED00012O00DA000600113O0020530006000600354O00085O00202O0008000800364O00060008000200062O000600ED00013O0004F03O00ED0001002E28003800ED000100370004F03O00ED00012O00DA000600124O000B00075O00202O0007000700394O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C00394O000A000C00024O000A000A6O0006000A000200062O000600ED00013O0004F03O00ED00012O00DA000600013O00123C0007003A3O00123C0008003B4O0034000600084O00C300066O00DA00066O00A5000700013O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O0006000600334O00060002000200062O000600162O013O0004F03O00162O012O00DA000600113O0020530006000600354O00085O00202O00080008003E4O00060008000200062O000600162O013O0004F03O00162O012O00DA000600083O0006D5000600162O013O0004F03O00162O012O00DA000600133O0006D5000600162O013O0004F03O00162O012O00DA000600124O000B00075O00202O00070007003F4O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C003F4O000A000C00024O000A000A6O0006000A000200062O000600162O013O0004F03O00162O012O00DA000600013O00123C000700403O00123C000800414O0034000600084O00C300065O00123C000500023O002629000500BB000100010004F03O00BB000100123C000600013O0026290006001E2O0100060004F03O001E2O0100123C000500063O0004F03O00BB00010026290006001A2O0100010004F03O001A2O012O00DA000700113O0020530007000700354O00095O00202O0009000900424O00070009000200062O000700582O013O0004F03O00582O012O00DA000700113O00202O0007000700434O00095O00202O0009000900424O00070009000200262O000700582O0100020004F03O00582O012O00DA0007000C3O000EE70044003B2O0100070004F03O003B2O012O00DA0007000B3O0006640007003B2O0100010004F03O003B2O012O00DA000700113O0020310107000700354O00095O00202O0009000900454O00070009000200062O000700452O0100010004F03O00452O012O00DA0007000C3O000EE7003400582O0100070004F03O00582O012O00DA000700113O0020530007000700354O00095O00202O0009000900364O00070009000200062O000700582O013O0004F03O00582O01002E28004600582O0100470004F03O00582O012O00DA000700143O0020220007000700482O00CF000800153O00202O0008000800494O00098O000A00013O00122O000B004A3O00122O000C004B6O000A000C6O00073O000200062O000700582O013O0004F03O00582O012O00DA000700013O00123C0008004C3O00123C0009004D4O0034000700094O00C300076O00DA00076O00A5000800013O00122O0009004E3O00122O000A004F6O0008000A00024O00070007000800202O0007000700334O00070002000200062O0007006F2O013O0004F03O006F2O012O00DA0007000C3O000EE70044006F2O0100070004F03O006F2O012O00DA0007000B3O0006640007006F2O0100010004F03O006F2O012O00DA000700113O0020310107000700354O00095O00202O0009000900454O00070009000200062O000700712O0100010004F03O00712O01002E9000500015000100510004F03O00842O01002EF7005200842O0100530004F03O00842O012O00DA000700124O00C400085O00202O0008000800544O000900096O000A00053O00202O000A000A005500122O000C00566O000A000C00024O000A000A6O0007000A000200062O000700842O013O0004F03O00842O012O00DA000700013O00123C000800573O00123C000900584O0034000700094O00C300075O00123C000600063O0004F03O001A2O010004F03O00BB000100262900010052020100020004F03O0052020100123C000500013O0026C50005008E2O0100010004F03O008E2O01002E28005A00FC2O0100590004F03O00FC2O012O00DA00066O00A5000700013O00122O0008005B3O00122O0009005C6O0007000900024O00060006000700202O0006000600334O00060002000200062O000600A92O013O0004F03O00A92O012O00DA000600113O0020530006000600354O00085O00202O00080008003E4O00060008000200062O000600A92O013O0004F03O00A92O012O00DA000600083O0006D5000600A92O013O0004F03O00A92O012O00DA000600113O0020310106000600354O00085O00202O00080008005D4O00060008000200062O000600AB2O0100010004F03O00AB2O01002E28005E00BD2O01005F0004F03O00BD2O012O00DA000600124O000B00075O00202O0007000700604O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C00604O000A000C00024O000A000A6O0006000A000200062O000600BD2O013O0004F03O00BD2O012O00DA000600013O00123C000700613O00123C000800624O0034000600084O00C300066O00DA000600093O0006D5000600FB2O013O0004F03O00FB2O0100123C000600013O0026C5000600C52O0100010004F03O00C52O01002EF7006400C12O0100630004F03O00C12O01002EF7006600DF2O0100650004F03O00DF2O012O00DA00076O00A5000800013O00122O000900673O00122O000A00686O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700DF2O013O0004F03O00DF2O012O00DA000700083O0006D5000700DF2O013O0004F03O00DF2O012O00DA000700164O00DA00085O0020220008000800692O00600007000200020006D5000700DF2O013O0004F03O00DF2O012O00DA000700013O00123C0008006A3O00123C0009006B4O0034000700094O00C300076O00DA00076O00A5000800013O00122O0009006C3O00122O000A006D6O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700FB2O013O0004F03O00FB2O012O00DA000700083O0006D5000700FB2O013O0004F03O00FB2O012O00DA000700164O00DA00085O00202200080008006E2O0060000700020002000664000700F42O0100010004F03O00F42O01002E90006F0009000100700004F03O00FB2O012O00DA000700013O00125B000800713O00122O000900726O000700096O00075O00044O00FB2O010004F03O00C12O0100123C000500063O0026C500052O00020100020004F04O000201002EF70074002O020100730004F03O002O020100123C000100753O0004F03O005202010026290005008A2O0100060004F03O008A2O012O00DA0006000C3O0026460006000F020100760004F03O000F02012O00DA0006000A3O0020610006000600212O0060000600020002000E410022000F020100060004F03O000F02012O00DA000600183O00260F01060016020100750004F03O001602012O00DA000600113O00204400060006007700122O000800783O00122O000900026O00060009000200044O001702012O002600066O0082000600014O0084000600174O00DA0006001A3O0006640006004F020100010004F03O004F02012O00DA000600173O0006D50006003402013O0004F03O003402012O00DA000600113O0020530006000600354O00085O00202O00080008005D4O00060008000200062O0006003402013O0004F03O003402012O00DA000600113O0020020006000600434O00085O00202O00080008005D4O0006000800024O00078O000800013O00122O000900793O00122O000A007A6O0008000A00024O00070007000800202O00070007007B4O00070002000200062O0006004E020100070004F03O004E02012O00DA000600173O0006640006004D020100010004F03O004D02012O00DA000600113O0020530006000600354O00085O00202O00080008007C4O00060008000200062O0006004F02013O0004F03O004F02012O00DA000600113O0020020006000600434O00085O00202O00080008007C4O0006000800024O00078O000800013O00122O0009007D3O00122O000A007E6O0008000A00024O00070007000800202O00070007007B4O00070002000200062O0006004E020100070004F03O004E02012O002600066O0082000600014O0084000600193O00123C000500023O0004F03O008A2O010026290001001F030100220004F03O001F030100123C000500014O0040000600063O002E28008000560201007F0004F03O00560201000EF200010056020100050004F03O0056020100123C000600013O002EF7008100B8020100820004F03O00B80201000EF2000600B8020100060004F03O00B802012O00DA00076O00A5000800013O00122O000900833O00122O000A00846O0008000A00024O00070007000800202O0007000700294O00070002000200062O0007007002013O0004F03O007002012O00DA000700113O0020FA0007000700854O00095O00202O0009000900424O00070009000200262O00070093020100750004F03O009302012O00DA0007000E4O0097000800113O00202O0008000800854O000A5O00202O000A000A00864O0008000A00024O000900113O00202O0009000900854O000B5O00202O000B000B00874O0009000B6O00073O00024O000800106O000900113O00202O0009000900854O000B5O00202O000B000B00864O0009000B00024O000A00113O00202O000A000A00854O000C5O00202O000C000C00874O000A000C6O00083O00024O000700070008000E2O00020092020100070004F03O009202012O00DA000700113O0020CB0007000700434O00095O00202O0009000900424O000700090002000E2O00880093020100070004F03O009302012O002600026O0082000200014O00B7000700113O00202O0007000700354O00095O00202O0009000900424O00070009000200062O000700B702013O0004F03O00B702012O00DA000700113O00202O0007000700434O00095O00202O0009000900424O00070009000200262O000700B7020100020004F03O00B702010006D5000200B702013O0004F03O00B70201002E28008900B70201008A0004F03O00B702012O00DA000700143O0020220007000700482O00CF000800153O00202O0008000800494O00098O000A00013O00122O000B008B3O00122O000C008C6O000A000C6O00073O000200062O000700B702013O0004F03O00B702012O00DA000700013O00123C0008008D3O00123C0009008E4O0034000700094O00C300075O00123C000600023O002EF7009000BE0201008F0004F03O00BE0201002629000600BE020100020004F03O00BE020100123C000100913O0004F03O001F03010026290006005B020100010004F03O005B02012O00DA00076O00A5000800013O00122O000900923O00122O000A00936O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700F702013O0004F03O00F702012O00DA000700053O0020610007000700232O0060000700020002000E41000200E2020100070004F03O00E202012O00DA0007001B3O000EC1007500E5020100070004F03O00E502012O00DA0007000A3O0020610007000700212O0060000700020002000E41009400DA020100070004F03O00DA02012O00DA0007000C3O00261B010700E5020100950004F03O00E502012O00DA0007000C3O000EE7003400E2020100070004F03O00E202012O00DA000700113O0020610007000700962O0060000700020002000EC1009700E5020100070004F03O00E502012O00DA0007000D3O002646000700F70201002A0004F03O00F702012O00DA000700124O000B00085O00202O0008000800984O000900096O000A00053O00202O000A000A000E4O000C5O00202O000C000C00984O000A000C00024O000A000A6O0007000A000200062O000700F702013O0004F03O00F702012O00DA000700013O00123C000800993O00123C0009009A4O0034000700094O00C300076O00DA00076O00A5000800013O00122O0009009B3O00122O000A009C6O0008000A00024O00070007000800202O0007000700334O00070002000200062O0007000803013O0004F03O000803012O00DA000700113O0020310107000700354O00095O00202O0009000900454O00070009000200062O0007000A030100010004F03O000A0301002E28009E001B0301009D0004F03O001B03012O00DA000700124O00C400085O00202O0008000800544O000900096O000A00053O00202O000A000A005500122O000C00566O000A000C00024O000A000A6O0007000A000200062O0007001B03013O0004F03O001B03012O00DA000700013O00123C0008009F3O00123C000900A04O0034000700094O00C300075O00123C000600063O0004F03O005B02010004F03O001F03010004F03O00560201002EF700A100BD030100A20004F03O00BD0301002629000100BD030100910004F03O00BD030100123C000500014O0040000600063O00262900050025030100010004F03O0025030100123C000600013O002EF700A30071030100A40004F03O0071030100262900060071030100060004F03O007103012O00DA00076O000A010800013O00122O000900A53O00122O000A00A66O0008000A00024O00070007000800202O00070007000B4O00070002000200062O00070038030100010004F03O00380301002E2800A7004E030100A80004F03O004E03012O00DA000700023O0020CC00070007000C4O00085O00202O00080008000D4O000900036O000A001C6O000B00053O00202O000B000B000E4O000D5O00202O000D000D000D4O000B000D00024O000B000B6O0007000B000200062O00070049030100010004F03O00490301002E2800A9004E030100AA0004F03O004E03012O00DA000700013O00123C000800AB3O00123C000900AC4O0034000700094O00C300075O002E2800AD0070030100AE0004F03O007003012O00DA00076O00A5000800013O00122O000900AF3O00122O000A00B06O0008000A00024O00070007000800202O00070007000B4O00070002000200062O0007007003013O0004F03O00700301002EF700B20070030100B10004F03O007003012O00DA000700023O00208900070007000C4O00085O00202O0008000800154O000900036O000A001D6O000B00053O00202O000B000B000E4O000D5O00202O000D000D00154O000B000D00024O000B000B6O0007000B000200062O0007007003013O0004F03O007003012O00DA000700013O00123C000800B33O00123C000900B44O0034000700094O00C300075O00123C000600023O002629000600B6030100010004F03O00B60301002E9000B50022000100B50004F03O009503012O00DA00076O00A5000800013O00122O000900B63O00122O000A00B76O0008000A00024O00070007000800202O0007000700334O00070002000200062O0007009503013O0004F03O009503010006D50002009503013O0004F03O009503012O00DA000700124O003100085O00202O0008000800394O0009000A6O000B00053O00202O000B000B000E4O000D5O00202O000D000D00394O000B000D00024O000B000B6O0007000B000200062O00070090030100010004F03O00900301002EF700B90095030100B80004F03O009503012O00DA000700013O00123C000800BA3O00123C000900BB4O0034000700094O00C300076O00DA00076O00A5000800013O00122O000900BC3O00122O000A00BD6O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700B503013O0004F03O00B503012O00DA000700023O0020CC00070007000C4O00085O00202O00080008001E4O000900036O000A001E6O000B00053O00202O000B000B000E4O000D5O00202O000D000D001E4O000B000D00024O000B000B6O0007000B000200062O000700B0030100010004F03O00B00301002EF700BF00B5030100BE0004F03O00B503012O00DA000700013O00123C000800C03O00123C000900C14O0034000700094O00C300075O00123C000600063O00262900060028030100020004F03O0028030100123C000100C23O0004F03O00BD03010004F03O002803010004F03O00BD03010004F03O002503010026C5000100C1030100C30004F03O00C10301002EF700C500D8030100C40004F03O00D803010006D5000400C403013O0004F03O00C403012O00A1000400024O00DA000500143O0020150005000500484O00065O00202O0006000600C64O00078O000800013O00122O000900C73O00122O000A00C86O0008000A6O00053O000200062O000500D2030100010004F03O00D20301002EF700C900E5070100CA0004F03O00E507012O00DA000500013O00125B000600CB3O00122O000700CC6O000500076O00055O00044O00E50701000EF200750078040100010004F03O0078040100123C000500013O002E9000CD0042000100CD0004F03O001D04010026290005001D040100060004F03O001D04012O00DA00066O00A5000700013O00122O000800CE3O00122O000900CF6O0007000900024O00060006000700202O00060006000B4O00060002000200062O00062O0004013O0004F04O0004012O00DA000600193O0006D500062O0004013O0004F04O000401002E2800D12O00040100D00004F04O0004012O00DA000600124O000B00075O00202O0007000700604O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C00604O000A000C00024O000A000A6O0006000A000200062O00062O0004013O0004F04O0004012O00DA000600013O00123C000700D23O00123C000800D34O0034000600084O00C300066O00DA0006001B3O000EC10088001A040100060004F03O001A04012O00DA0006000A3O0020610006000600212O0060000600020002000EC10094000B040100060004F03O000B04012O00DA000600203O0006D50006001B04013O0004F03O001B04012O00DA000600113O0020CB0006000600434O00085O00202O00080008007C4O000600080002000E2O0088001A040100060004F03O001A04012O00DA000600113O0020CB0006000600434O00085O00202O00080008005D4O000600080002000E2O0088001A040100060004F03O001A04012O002600066O0082000600014O00840006001F3O00123C000500023O000EF200010073040100050004F03O007304012O00DA00066O00A5000700013O00122O000800D43O00122O000900D56O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006003604013O0004F03O003604012O00DA000600173O0006D50006003604013O0004F03O003604012O00DA000600193O00066400060038040100010004F03O003804012O00DA000600113O0020FA0006000600434O00085O00202O00080008005D4O00060008000200262O00060038040100C20004F03O00380401002EF700D60045040100D70004F03O004504012O00DA000600124O00DA00075O0020220007000700D82O006000060002000200066400060040040100010004F03O00400401002E2800DA0045040100D90004F03O004504012O00DA000600013O00123C000700DB3O00123C000800DC4O0034000600084O00C300066O00DA00066O00A5000700013O00122O000800DD3O00122O000900DE6O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006005C04013O0004F03O005C04012O00DA000600193O0006D50006005C04013O0004F03O005C04012O00DA000600173O0006640006005E040100010004F03O005E04012O00DA000600113O0020310106000600354O00085O00202O00080008005D4O00060008000200062O0006005E040100010004F03O005E0401002EF700E00072040100DF0004F03O007204012O00DA000600124O003100075O00202O00070007003F4O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C003F4O000A000C00024O000A000A6O0006000A000200062O0006006D040100010004F03O006D0401002EF700E20072040100E10004F03O007204012O00DA000600013O00123C000700E33O00123C000800E44O0034000600084O00C300065O00123C000500063O000EF2000200DB030100050004F03O00DB030100123C000100883O0004F03O007804010004F03O00DB0301002E9000E500DA2O0100E50004F03O00520601000EF200C20052060100010004F03O0052060100123C000500014O0040000600063O0026290005007E040100010004F03O007E040100123C000600013O000EFB00060085040100060004F03O00850401002E9000E600E9000100E70004F03O006C05012O00DA00076O00A5000800013O00122O000900E83O00122O000A00E96O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700E104013O0004F03O00E104012O00DA000700113O0020F50007000700EA4O0007000200024O0008000E6O000900216O000A8O000B00013O00122O000C00EB3O00122O000D00EC6O000B000D00024O000A000A000B00202O000A000A00ED4O000A000B6O00083O00024O000900106O000A00216O000B8O000C00013O00122O000D00EB3O00122O000E00EC6O000C000E00024O000B000B000C00202O000B000B00ED4O000B000C6O00093O00024O00080008000900062O000800E1040100070004F03O00E104012O00DA000700113O0020020007000700434O00095O00202O00090009007C4O0007000900024O00088O000900013O00122O000A00EE3O00122O000B00EF6O0009000B00024O00080008000900202O0008000800F04O00080002000200062O000800C9040100070004F03O00C904012O00DA000700113O0020040007000700434O00095O00202O00090009005D4O0007000900024O00088O000900013O00122O000A00F13O00122O000B00F26O0009000B00024O00080008000900202O0008000800F04O00080002000200062O000800E1040100070004F03O00E104012O00DA0007000B3O000664000700E3040100010004F03O00E304012O00DA00076O0079000800013O00122O000900F33O00122O000A00F46O0008000A00024O00070007000800202O0007000700F54O000700020002000E2O00F600DE040100070004F03O00DE04012O00DA0007000C3O002635010700DE040100760004F03O00DE04012O00DA0007000A3O0020610007000700212O0060000700020002000EC1002A00E3040100070004F03O00E304012O00DA0007000D3O00260F010700E30401002A0004F03O00E30401002E2800F700F5040100F80004F03O00F504012O00DA000700124O000B00085O00202O0008000800F94O0009000A6O000B00053O00202O000B000B000E4O000D5O00202O000D000D00F94O000B000D00024O000B000B6O0007000B000200062O000700F504013O0004F03O00F504012O00DA000700013O00123C000800FA3O00123C000900FB4O0034000700094O00C300076O00DA000700113O00201C0007000700354O00095O00202O0009000900364O00070009000200062O0003006B050100070004F03O006B05012O00DA000700113O00209E0007000700EA4O0007000200024O0008000E6O000900216O000A00226O000B5O00202O000B000B00604O000A000200024O00090009000A4O000A000E4O00E9000B00226O000C5O00202O000C000C003F4O000B000200024O000C00216O000A000C00024O000B00106O000C00226O000D5O00202O000D000D003F2O0060000C000200022O0035000D00216O000B000D00024O000A000A000B4O000B000F6O000C00113O00202O000C000C00434O000E5O00202O000E000E005D4O000C000E00024O000D00113O002061000D000D00FC2O0060000D0002000200201F000D000D007500065F000C00220501000D0004F03O002205012O0026000C6O0082000C00014O00B0000B000200024O000A000A000B4O0008000A00024O000900106O000A00216O000B00226O000C5O00202O000C000C00604O000B000200024O000A000A000B2O00DA000B000E4O00E9000C00226O000D5O00202O000D000D003F4O000C000200024O000D00216O000B000D00024O000C00106O000D00226O000E5O00202O000E000E003F2O0060000D000200022O0035000E00216O000C000E00024O000B000B000C4O000C000F6O000D00113O00202O000D000D00434O000F5O00202O000F000F005D4O000D000F00024O000E00113O002061000E000E00FC2O0060000E0002000200201F000E000E007500065F000D00490501000E0004F03O004905012O0026000D6O0082000D00014O002A000C000200024O000B000B000C4O0009000B00024O00080008000900062O0007006A050100080004F03O006A05012O00DA00076O00A5000800013O00122O000900FD3O00122O000A00FE6O0008000A00024O00070007000800202O0007000700294O00070002000200062O0007006505013O0004F03O006505012O00DA00076O00FF000800013O00122O000900FF3O00122O000A2O00015O0008000A00024O00070007000800202O0007000700214O00070002000200122O000800753O00062O0007006A050100080004F03O006A05012O00DA0007000D3O00123C000800223O00065F0007006A050100080004F03O006A05012O002600036O0082000300013O00123C000600023O00123C000700013O00060E01060073050100070004F03O0073050100123C0007002O012O00123C00080002012O0006E10007004A060100080004F03O004A06012O00DA00076O00A5000800013O00122O00090003012O00122O000A0004015O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700B505013O0004F03O00B505012O00DA000700113O0020F50007000700EA4O0007000200024O0008000E6O000900216O000A8O000B00013O00122O000C0005012O00122O000D0006015O000B000D00024O000A000A000B00202O000A000A00ED4O000A000B6O00083O00024O000900106O000A00216O000B8O000C00013O00122O000D0005012O00122O000E0006015O000C000E00024O000B000B000C00202O000B000B00ED4O000B000C6O00093O00024O00080008000900062O000800B5050100070004F03O00B505012O00DA0007000B3O000664000700B9050100010004F03O00B905012O00DA00076O00D9000800013O00122O00090007012O00122O000A0008015O0008000A00024O00070007000800202O0007000700F54O00070002000200122O000800F63O00062O000800B1050100070004F03O00B105012O00DA0007000C3O00123C000800763O000612010700B1050100080004F03O00B105012O00DA0007000A3O0020610007000700212O006000070002000200123C0008002A3O00065F000800B9050100070004F03O00B905012O00DA0007000D3O00123C0008002A3O00065F000700B9050100080004F03O00B9050100123C00070009012O00123C0008000A012O000612010700D1050100080004F03O00D105012O00DA000700124O000301085O00122O0009000B015O0008000800094O0009000A6O000B00053O00202O000B000B000E4O000D5O00122O000E000B015O000D000D000E4O000B000D00024O000B000B6O0007000B000200062O000700CC050100010004F03O00CC050100123C0007000C012O00123C0008000D012O000612010700D1050100080004F03O00D105012O00DA000700013O00123C0008000E012O00123C0009000F013O0034000700094O00C300076O00DA00076O00A5000800013O00122O00090010012O00122O000A0011015O0008000A00024O00070007000800202O00070007000B4O00070002000200062O0007003106013O0004F03O003106012O00DA000700113O0020F50007000700EA4O0007000200024O0008000E6O000900216O000A8O000B00013O00122O000C0012012O00122O000D0013015O000B000D00024O000A000A000B00202O000A000A00ED4O000A000B6O00083O00024O000900106O000A00216O000B8O000C00013O00122O000D0012012O00122O000E0013015O000C000E00024O000B000B000C00202O000B000B00ED4O000B000C6O00093O00024O00080008000900062O00080031060100070004F03O003106012O00DA000700113O0020020007000700434O00095O00202O00090009007C4O0007000900024O00088O000900013O00122O000A0014012O00122O000B0015015O0009000B00024O00080008000900202O0008000800F04O00080002000200062O00080015060100070004F03O001506012O00DA000700113O0020040007000700434O00095O00202O00090009005D4O0007000900024O00088O000900013O00122O000A0016012O00122O000B0017015O0009000B00024O00080008000900202O0008000800F04O00080002000200062O00080031060100070004F03O003106012O00DA0007000B3O00066400070035060100010004F03O003506012O00DA00076O00D9000800013O00122O00090018012O00122O000A0019015O0008000A00024O00070007000800202O0007000700F54O00070002000200122O000800F63O00062O0008002D060100070004F03O002D06012O00DA0007000C3O00123C000800763O0006120107002D060100080004F03O002D06012O00DA0007000A3O0020610007000700212O006000070002000200123C0008002A3O00065F00080035060100070004F03O003506012O00DA0007000D3O00123C0008002A3O00065F00070035060100080004F03O0035060100123C0007001A012O00123C0008001B012O00067000080049060100070004F03O004906012O00DA000700124O00F400085O00122O0009001C015O0008000800094O0009000A6O000B00053O00202O000B000B000E4O000D5O00122O000E001C015O000D000D000E4O000B000D00024O000B000B6O0007000B000200062O0007004906013O0004F03O004906012O00DA000700013O00123C0008001D012O00123C0009001E013O0034000700094O00C300075O00123C000600063O00123C000700023O0006E100070081040100060004F03O0081040100123C0001001F012O0004F03O005206010004F03O008104010004F03O005206010004F03O007E040100123C000500883O0006E100010021070100050004F03O002107012O00DA00056O00A5000600013O00122O00070020012O00122O00080021015O0006000800024O00050005000600202O0005000500334O00050002000200062O0005007606013O0004F03O007606012O00DA00056O00A5000600013O00122O00070022012O00122O00080023015O0006000800024O00050005000600202O0005000500294O00050002000200062O0005007606013O0004F03O007606012O00DA00056O00A5000600013O00122O00070024012O00122O00080025015O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005007606013O0004F03O007606012O00DA0005001F3O0006640005007A060100010004F03O007A060100123C00050026012O00123C00060027012O00067000060090060100050004F03O009006012O00DA000500124O003100065O00202O0006000600394O000700086O000900053O00202O00090009000E4O000B5O00202O000B000B00394O0009000B00024O000900096O00050009000200062O0005008B060100010004F03O008B060100123C00050028012O00123C00060029012O00061201050090060100060004F03O009006012O00DA000500013O00123C0006002A012O00123C0007002B013O0034000500074O00C300056O00DA00056O00A5000600013O00122O0007002C012O00122O0008002D015O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500B306013O0004F03O00B306012O00DA000500234O009A0005000100020006D5000500B306013O0004F03O00B306012O00DA0005001F3O0006D5000500B306013O0004F03O00B306012O00DA000500124O008100065O00122O0007002E015O0006000600074O000700076O000800053O00202O00080008005500122O000A002F015O0008000A00024O000800086O00050008000200062O000500B306013O0004F03O00B306012O00DA000500013O00123C00060030012O00123C00070031013O0034000500074O00C300056O00DA00056O00A5000600013O00122O00070032012O00122O00080033015O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500CC06013O0004F03O00CC06012O00DA000500113O0020FD0005000500EA4O0005000200024O000600216O00078O000800013O00122O00090034012O00122O000A0035015O0008000A00024O00070007000800202O0007000700ED4O0007000200024O00060006000700062O000600D0060100050004F03O00D0060100123C00050036012O00123C00060037012O000612010500E0060100060004F03O00E006012O00DA000500124O007200065O00122O00070038015O0006000600074O00050002000200062O000500DB060100010004F03O00DB060100123C00050039012O00123C0006003A012O000670000600E0060100050004F03O00E006012O00DA000500013O00123C0006003B012O00123C0007003C013O0034000500074O00C300055O00123C0005003D012O00123C0006003E012O00061201060020070100050004F03O002007012O00DA00056O00A5000600013O00122O0007003F012O00122O00080040015O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005002007013O0004F03O002007012O00DA000500234O009A0005000100020006D50005002007013O0004F03O002007012O00DA000500113O0020F50005000500EA4O0005000200024O0006000E6O000700216O00088O000900013O00122O000A0041012O00122O000B0042015O0009000B00024O00080008000900202O0008000800ED4O000800096O00063O00024O000700106O000800216O00098O000A00013O00122O000B0041012O00122O000C0042015O000A000C00024O00090009000A00202O0009000900ED4O0009000A6O00073O00024O00060006000700062O00060020070100050004F03O002007012O00DA000500124O008100065O00122O00070043015O0006000600074O000700076O000800053O00202O00080008005500122O000A00566O0008000A00024O000800086O00050008000200062O0005002007013O0004F03O002007012O00DA000500013O00123C00060044012O00123C00070045013O0034000500074O00C300055O00123C000100223O00123C0005001F012O0006E100010004000100050004F03O0004000100123C000500013O00123C00060046012O00123C00070046012O0006E10006002E070100070004F03O002E070100123C000600023O0006E10006002E070100050004F03O002E070100123C000100C33O0004F03O0004000100123C00060047012O00123C00070048012O0006120106006D070100070004F03O006D070100123C000600063O0006E10005006D070100060004F03O006D070100123C000600013O00123C000700013O0006E100060063070100070004F03O006307012O00DA00076O00A5000800013O00122O00090049012O00122O000A004A015O0008000A00024O00070007000800202O00070007000B4O00070002000200062O0007005F07013O0004F03O005F07012O00DA000700113O00123C0009004B013O00230107000700092O00600007000200020006640007005F070100010004F03O005F07012O00DA000700124O003100085O00202O0008000800604O0009000A6O000B00053O00202O000B000B000E4O000D5O00202O000D000D00604O000B000D00024O000B000B6O0007000B000200062O0007005A070100010004F03O005A070100123C0007004C012O00123C0008004D012O0006120108005F070100070004F03O005F07012O00DA000700013O00123C0008004E012O00123C0009004F013O0034000700094O00C300076O00DA000700244O009A0007000100022O0059000400073O00123C000600063O00123C00070050012O00123C00080051012O00067000070036070100080004F03O0036070100123C000700063O0006E100060036070100070004F03O0036070100123C000500023O0004F03O006D07010004F03O0036070100123C000600013O0006E100060025070100050004F03O002507012O00DA000600113O0020530006000600354O00085O00202O0008000800424O00060008000200062O0006008107013O0004F03O008107012O00DA000600113O0020AA0006000600434O00085O00202O0008000800424O00060008000200122O000700023O00062O00060081070100070004F03O0081070100066400030085070100010004F03O0085070100123C00060052012O00123C00070053012O00061201070099070100060004F03O0099070100123C00060054012O00123C00070055012O00061201070099070100060004F03O009907012O00DA000600164O00CF000700153O00202O0007000700494O00088O000900013O00122O000A0056012O00122O000B0057015O0009000B6O00063O000200062O0006009907013O0004F03O009907012O00DA000600013O00123C00070058012O00123C00080059013O0034000600084O00C300066O00DA00066O00A5000700013O00122O0008005A012O00122O0009005B015O0007000900024O00060006000700202O0006000600334O00060002000200062O000600A507013O0004F03O00A50701000664000300A9070100010004F03O00A9070100123C0006005C012O00123C0007005D012O000612010600BF070100070004F03O00BF070100123C0006005E012O00123C0007005E012O0006E1000600BF070100070004F03O00BF07012O00DA000600124O000B00075O00202O0007000700394O000800096O000A00053O00202O000A000A000E4O000C5O00202O000C000C00394O000A000C00024O000A000A6O0006000A000200062O000600BF07013O0004F03O00BF07012O00DA000600013O00123C0007005F012O00123C00080060013O0034000600084O00C300065O00123C000500063O0004F03O002507010004F03O000400010004F03O00E5070100123C00050061012O00123C00060062012O000670000600DF070100050004F03O00DF070100123C000500013O0006E1000500DF07013O0004F03O00DF070100123C000500013O00123C000600013O00060E010600D2070100050004F03O00D2070100123C00060063012O00123C00070064012O000670000700D5070100060004F03O00D5070100123C000100014O0040000200023O00123C000500063O00123C000600063O00060E010600DC070100050004F03O00DC070100123C00060065012O00123C00070066012O000670000600CB070100070004F03O00CB070100123C3O00063O0004F03O00DF07010004F03O00CB070100123C000500063O0006E13O0002000100050004F03O000200012O0040000300043O00123C3O00023O0004F03O000200012O00543O00017O0075012O00028O00026O00F03F025O00E8B140025O0090A940027O0040025O004C9040025O00CCAB40026O000840026O001040025O00C0514003083O001E20A4CE70AEDB8A03083O00E64D54C5BC16CFB703073O0049735265616479025O00D2A54003083O005374617266612O6C03093O004973496E52616E6765025O00804640030F3O00EA00C7EE8AA0FC39B915C9F9CCF0A003083O00559974A69CECC19003083O0097F44CA1E209B6E503063O0060C4802DD38403063O0042752O665570030E3O00447265616D737461746542752O66030C3O0045636C697073654C756E6172025O00888140025O00788C4003083O005374617266697265030E3O0049735370652O6C496E52616E6765025O00288540025O002FB040030F3O0026997A4DD42OA6DD758C745A92FEE503083O00B855ED1B3FB2CFD4025O0046B140025O00E8A140030D3O009845C71435BFBB64D10F28B5B203063O00DED737A57D41030B3O004973417661696C61626C6503123O0041737472616C506F77657244656669636974026O002040030E3O00546F756368746865436F736D6F73030B3O0042752O6652656D61696E73030C3O0045636C69707365536F6C6172026O002840030C3O00537461726C6F726442752O66025O0074AA40025O00F8A340030D3O0043617374412O6E6F7461746564030E3O0043616E63656C537461726C6F726403063O000FF0E839D7ED03083O002A4CB1A67A92A18D031C3O00A68B0BCD7C7A9A8810C87F36B69E04DC7579B78E45CF7673E5D34B9B03063O0016C5EA65AE19025O0044B340025O00308C4003123O002B5C055A1B4D005E047805560F57045A064D03043O003F683969030A3O0049734361737461626C65025O00707F40025O00449640025O0007B34003123O0043656C65737469616C416C69676E6D656E74031A3O000882A8411893AD4507B8A5480280AA490E89B0040A88A1045AD703043O00246BE7C4030B3O0074BBA1864FBBA39354BAAC03043O00E73DD5C2025O00A6A340025O00D0A140030B3O00496E6361726E6174696F6E031A3O000AA831761AB9347205923C7F00AA337E0CA3293308A2383358FF03043O001369CD5D025O0080A740030E3O009E09CC9336A61AD1871AA51DD08403053O005FC968BEE1025O00707240025O00388840030E3O0057612O72696F726F66456C756E6503173O00B8CAD3DCA6C4D3F1A0CDFECBA3DECFCBEFCACECBEF9A9503043O00AECFABA1025O00DCB240025O0096A740025O001AA240025O00CCA04003063O00A776D079A17B03043O003AE4379E031B3O00B788DE2D39A10AB69CD6287CBE21B59BDC212EA975B586D52O6EFE03073O0055D4E9B04E5CCD03083O00794C89F04C5984EE03043O00822A38E8025O0098A840025O00188740030F3O00F9A125F1463EE6B964E24F3AAAE77003063O005F8AD5448320025O00E0B140025O003AB240025O0006AE40025O00ACA740025O00B4A340025O00C09840030C3O00D6A9523CC335F79B5B31DD3103063O005485DD3750AF030C3O008EF321AACB5DAFC128A7D55903063O003CDD8744C6A7030E3O00456E657267697A65416D6F756E74030F3O00DBB0FA9143D5C7B3EC864CCAE7A9E103063O00B98EDD98E322030A3O0054616C656E7452616E6B026O002640030D3O0079D643E8423FC455CA5BFE462103073O009738A5379A235303093O00436173744379636C65030C3O005374652O6C6172466C61726503143O00B35700E2AC4217D1A64F04FCA50304E1A50356BC03043O008EC02365025O005AA940030F3O00F7663DB1E6808F19DB783CADEE83A203083O0076B61549C387ECCC030F3O00292F0E520501DE073117550A04F20603073O009D685C7A20646D030D3O00466F7263654F664E6174757265025O006AB140025O0014A74003173O00A2B5DBD83C2BB2A8ACABC2DF332E82A5E3A7C0CF7D74D903083O00CBC3C6AFAA5D47ED03083O000C3DAD4F5B2527AF03053O00164A48C12303083O000A6CE8540176EB5603043O00384C198403083O0078D4A72AE251CEA503053O00AF3EA1CB46030B3O004578656375746554696D6503083O001AC8CF1F1833D2CD03053O00555CBDA37303083O0001AD3C3E04A33F3603043O005849CC5003113O00436861726765734672616374696F6E616C026O000440025O00408040030F3O00432O6F6C646F776E52656D61696E73026O002440025O0040A040025O00307D40026O004D40025O0050834003083O0046752O6C4D2O6F6E03103O0028961C4A16D7218C1E0628D52BC3421003063O00BA4EE370264903093O00CF43FC47406FEE50F803063O001A9C379D3533030F3O00537461727765617665727357656674025O00D88B40025O008EAC4003093O00537461727375726765025O00BFB040025O004CAC4003103O009FCC17CBAB459EDF1399B95F8998458903063O0030ECB876B9D8026O004140025O0012A44003093O004973496E506172747903083O004973496E5261696403083O00EB37B638BF0BD43D03063O0062A658D956D9025O0078A640025O00AC9440025O00B89F4003083O004D2O6F6E66697265030E3O00FBF9760F80D5E4F3390089D9B6A403063O00BC2O961961E6025O00E09F40025O00508540025O00D07040025O009CA240026O00144003093O0054696D65546F446965025O00407F40026O003940030B3O00F3875C031EE3DB9D560D0203063O008DBAE93F626C03073O00C2FF22B02CE3EF03053O0045918A4CD6025O00208A40025O0024B04003073O0053756E66697265030D3O0063DA878FB604758F8886BA562403063O007610AF2OE9DF025O005AA740025O009C9040025O00CCA240025O002AA940025O00DEAB40025O006BB14003083O00A68B3AB5E8826F8E03073O001DEBE455DB8EEB025O00109D40025O0022A040030E3O0030DBB5D3714735577DD5B5D8371803083O00325DB4DABD172E47030C3O00EDB05E4048DD5AF8A85A5E4103073O0028BEC43B2C24BC030C3O000F51D9B8F67C1F1A49DDA6FF03073O006D5C25BCD49A1D030F3O0031E2A6D130562DE1B0C63F490DFBBD03063O003A648FC4A351030D3O003B5137B13E45D603154E27A62D03083O006E7A2243C35F2985025O0096A040025O001EB34003133O0066A55E46DA74A3644CDA74A35E0AD77AB41B1303053O00B615D13B2A025O0046AC4003093O00862BE634479510B23A03073O0062D55F874634E0026O003140025O00A8A040025O000EAA4003103O00EDB7C86547EBB1CE7214FFACCC3700AA03053O00349EC3A917025O007DB140025O0022AC40025O002CAB40025O00688240025O00109B40025O0040604003083O00F2DEAF81FED5D0AD03053O00B3BABFC3E703083O00D13E14E2D43017EA03043O0084995F7803083O0097A70221DAD5AFBF03073O00C0D1D26E4D97BA03083O00C6162EE5D2CBEF0D03063O00A4806342899F03083O0048616C664D2O6F6E03103O000888E5B83F84E6B10EC9E8B105C9BDEE03043O00DE60E989030D3O009FBCB51C8DDCF697B2B30A9AF603073O0090D9D3C77FE893030D3O00DE202C2BD06A046AF93B2B3AD003083O0024984F5E48B5256203163O00D1D7553CD2E74839E8D6462BC2CA427FD6D7427F838A03043O005FB7B827025O00188B40025O001EA94003113O000D4430C35E1AF91A433BE64118EE275F2D03073O009C4E2B5EB53171030C3O0041737472616C506F77657250026O004940030E3O0057E4D1AD0E505E67E1C0A205407C03073O00191288A4C36B2303113O00436F6E766F6B6554686553706972697473026O004440031A3O00EB22A7597DB7C487FC25AC7061ACC8AAE139BA0F73B3C4F8BB7B03083O00D8884DC92F12DCA1025O00C88440025O00BDB14003073O0003E93CF707D38C03073O00E24D8C4BBA68BC03073O0097CBC71240B6C003053O002FD9AEB05F025O00049140025O00FEAA4003073O004E65774D2O6F6E030F3O00B6D8613DBF5B7728F8DC7907F2072003083O0046D8BD1662D23418025O0084AB40025O00C4A040025O0046AB40025O0074A940025O0061B140025O0078AC40025O00206340025O007C9D40025O00949B40026O008440026O006940025O00B6AF4003083O0042752O66496E666F03063O0098AEE0CC609B03053O0014E8C189A2025O0014A940025O00E09540026O002E40025O00909540025O002EAE4003083O0011CBC4B4E185057403083O001142BFA5C687EC7703083O0049734D6F76696E67025O00E06640025O001AAA40030F3O001CBBAF01F9E1FED44FAEA116BFBCBA03083O00B16FCFCE739F888C025O00A07A40025O0098A940025O0010AC40025O00F8AF40025O0068AA40025O00E9B240025O00F5B14003063O006AB33B7A922603083O00EB1ADC5214E6551B025O00F4AE40025O00E2A740025O006AA040025O0012AF40025O0050B24003053O00329B1100DC03073O003F65E97074B42F03053O005772617468025O00308840025O00707C40030C3O00D429EC06F076C234E852AC6E03063O0056A35B8D7298026O00184003043O00502O6F6C03063O007E24425A147403053O005A336B141303283O00BDFF8AE37DACFFA0AF3998F5C5FB32CDFD8AF93880F58BFB7D8CFE81AF3382B083EE3181E48DFD2803053O005DED90E58F026O008A40025O0056A24003053O0094A1E3D5CE03083O0018C3D382A1A6631003053O007111E8385B03063O00762663894C3303083O004361737454696D65030C3O00EA3404060160FC290052587803063O00409D46657269030C3O0077A1ABE73D55BBAFF11F4FA503053O007020C8C783026O003440030E3O001B5152B1CDAC163B5950B1C4A33603073O00424C303CD8A3CB030D3O00446562752O6652656D61696E7303123O0046756E67616C47726F777468446562752O66026O001C4003083O005072657647434450030C3O0057696C644D757368722O6F6D025O00389E40025O00B2A540025O00E08240025O003DB24003143O00AD8F75F760C331A98E6BFC50C364BB897CB30D9E03073O0044DAE619933FAE03083O00DEEA0CE1FEDEFFFB03063O00B78D9E6D939803083O001F1DE71E2A00F40903043O006C4C6986030F3O00F8D1B0F3C8E2D7B4A1CFE4C0F1B09903053O00AE8BA5D181025O0050A040025O00B6A240025O00209F40025O0074A440030B3O008B3F415599AB0F5F59B8A803053O00D6CD4A332C026O003E40025O00807140025O00808140030B3O00467572794F66456C756E65025O00ECA940025O00207A4003143O00FC59F0E548F54ADDF97BEF42E7BC76F549A2AE2503053O00179A2C829C030F3O0053746172776561766572735761727003083O0022B2ACBC3A1C03A203063O007371C6CDCE5603093O0042752O66537461636B025O00C6AF40025O00D2A340025O0049B040025O00B8AF40025O00805540025O00F08240025O002AA340006E082O00123C3O00014O0040000100093O0026C53O0006000100020004F03O00060001002E2800030008000100040004F03O000800012O0040000300043O00123C3O00053O002E280006000E000100070004F03O000E00010026293O000E000100050004F03O000E00012O0040000500063O00123C3O00083O0026293O0013000100010004F03O0013000100123C000100014O0040000200023O00123C3O00023O0026293O0063080100090004F03O006308012O0040000900093O002E90000A00200801000A0004F03O00360801000EF200090036080100010004F03O00360801002629000200592O0100020004F03O00592O0100123C000A00013O000EF2000200700001000A0004F03O007000012O00DA000B6O00A5000C00013O00122O000D000B3O00122O000E000C6O000C000E00024O000B000B000C00202O000B000B000D4O000B0002000200062O000B003E00013O0004F03O003E00010006D50004003E00013O0004F03O003E0001002E90000E00130001000E0004F03O003E00012O00DA000B00024O00C4000C5O00202O000C000C000F4O000D000D6O000E00033O00202O000E000E001000122O001000116O000E001000024O000E000E6O000B000E000200062O000B003E00013O0004F03O003E00012O00DA000B00013O00123C000C00123O00123C000D00134O0034000B000D4O00C3000B6O00DA000B6O00A5000C00013O00122O000D00143O00122O000E00156O000C000E00024O000B000B000C00202O000B000B000D4O000B0002000200062O000B005900013O0004F03O005900012O00DA000B00043O002053000B000B00164O000D5O00202O000D000D00174O000B000D000200062O000B005900013O0004F03O005900012O00DA000B00053O0006D5000B005900013O0004F03O005900012O00DA000B00043O002031010B000B00164O000D5O00202O000D000D00184O000B000D000200062O000B005B000100010004F03O005B0001002EF7001A006F000100190004F03O006F00012O00DA000B00024O0031000C5O00202O000C000C001B4O000D000E6O000F00033O00202O000F000F001C4O00115O00202O00110011001B4O000F001100024O000F000F6O000B000F000200062O000B006A000100010004F03O006A0001002E28001E006F0001001D0004F03O006F00012O00DA000B00013O00123C000C001F3O00123C000D00204O0034000B000D4O00C3000B5O00123C000A00053O002629000A0074000100080004F03O0074000100123C000200053O0004F03O00592O01002EF7002200F6000100210004F03O00F60001002629000A00F6000100010004F03O00F600012O00DA000B00053O0006D5000B009C00013O0004F03O009C00012O00DA000B6O00A5000C00013O00122O000D00233O00122O000E00246O000C000E00024O000B000B000C00202O000B000B00254O000B0002000200062O000B009500013O0004F03O009500012O00DA000B00043O002088000B000B00264O000B000200024O000C00066O000D00076O000E00083O00102O000E0027000E4O000C000E00024O000D00096O000E00076O000F00083O00102O000F0027000F4O000D000F00024O000C000C000D00062O000B00D10001000C0004F03O00D100012O00DA000B00043O00201C000B000B00164O000D5O00202O000D000D00284O000B000D000200062O000400D20001000B0004F03O00D200012O00DA000B00043O002062000B000B00264O000B000200024O000C00066O000D00073O00202O000D000D00274O000E000A6O000F00043O00202O000F000F00294O00115O00202O0011001100184O000F0011000200262O000F00B2000100090004F03O00B200012O00DA000F00043O0020FA000F000F00294O00115O00202O00110011002A4O000F0011000200262O000F00B2000100090004F03O00B200012O0026000F6O0082000F00014O00AE000E0002000200102O000E002B000E4O000C000E00024O000D00096O000E00073O00202O000E000E00274O000F000A6O001000043O00202O0010001000294O00125O00202O0012001200184O00100012000200262O001000C9000100090004F03O00C900012O00DA001000043O0020FA0010001000294O00125O00202O00120012002A4O00100012000200262O001000C9000100090004F03O00C900012O002600106O0082001000014O00ED000F0002000200102O000F002B000F4O000D000F00024O000C000C000D00062O000B00D10001000C0004F03O00D100012O002600046O0082000400014O00DA000B00043O002053000B000B00164O000D5O00202O000D000D002C4O000B000D000200062O000B00E200013O0004F03O00E200012O00DA000B00043O00202O000B000B00294O000D5O00202O000D000D002C4O000B000D000200262O000B00E2000100050004F03O00E20001000664000400E4000100010004F03O00E40001002E28002D00F50001002E0004F03O00F500012O00DA000B000B3O002022000B000B002F2O00CF000C000C3O00202O000C000C00304O000D8O000E00013O00122O000F00313O00122O001000326O000E00106O000B3O000200062O000B00F500013O0004F03O00F500012O00DA000B00013O00123C000C00333O00123C000D00344O0034000B000D4O00C3000B5O00123C000A00023O002629000A001D000100050004F03O001D00012O00DA000B000D3O0006D5000B003E2O013O0004F03O003E2O0100123C000B00014O0040000C000C3O002629000B00FD000100010004F03O00FD000100123C000C00013O0026C5000C00042O0100010004F03O00042O01002EF700352O002O0100360004F04O002O012O00DA000D6O00A5000E00013O00122O000F00373O00122O001000386O000E001000024O000D000D000E00202O000D000D00394O000D0002000200062O000D00112O013O0004F03O00112O012O00DA000D00053O000664000D00132O0100010004F03O00132O01002E28003B00202O01003A0004F03O00202O01002E90003C000D0001003C0004F03O00202O012O00DA000D000E4O00DA000E5O002022000E000E003D2O0060000D000200020006D5000D00202O013O0004F03O00202O012O00DA000D00013O00123C000E003E3O00123C000F003F4O0034000D000F4O00C3000D6O00DA000D6O00A5000E00013O00122O000F00403O00122O001000416O000E001000024O000D000D000E00202O000D000D00394O000D0002000200062O000D003E2O013O0004F03O003E2O012O00DA000D00053O0006D5000D003E2O013O0004F03O003E2O01002EF70043003E2O0100420004F03O003E2O012O00DA000D000E4O00DA000E5O002022000E000E00442O0060000D000200020006D5000D003E2O013O0004F03O003E2O012O00DA000D00013O00125B000E00453O00122O000F00466O000D000F6O000D5O00044O003E2O010004F04O002O010004F03O003E2O010004F03O00FD0001002E9000470019000100470004F03O00572O012O00DA000B6O00A5000C00013O00122O000D00483O00122O000E00496O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B00572O013O0004F03O00572O01002EF7004A00572O01004B0004F03O00572O012O00DA000B000E4O00DA000C5O002022000C000C004C2O0060000B000200020006D5000B00572O013O0004F03O00572O012O00DA000B00013O00123C000C004D3O00123C000D004E4O0034000B000D4O00C3000B5O00123C000A00083O0004F03O001D0001002629000200DE020100080004F03O00DE020100123C000A00013O002629000A00AD2O0100010004F03O00AD2O0100123C000B00013O000EF2000100A62O01000B0004F03O00A62O012O00DA000C00043O002053000C000C00164O000E5O00202O000E000E002C4O000C000E000200062O000C00712O013O0004F03O00712O012O00DA000C00043O00202O000C000C00294O000E5O00202O000E000E002C4O000C000E000200262O000C00712O0100050004F03O00712O01000664000600732O0100010004F03O00732O01002E28004F00862O0100500004F03O00862O01002E28005200862O0100510004F03O00862O012O00DA000C000B3O002022000C000C002F2O00CF000D000C3O00202O000D000D00304O000E8O000F00013O00122O001000533O00122O001100546O000F00116O000C3O000200062O000C00862O013O0004F03O00862O012O00DA000C00013O00123C000D00553O00123C000E00564O0034000C000E4O00C3000C6O00DA000C6O00A5000D00013O00122O000E00573O00122O000F00586O000D000F00024O000C000C000D00202O000C000C000D4O000C0002000200062O000C00922O013O0004F03O00922O01000664000600942O0100010004F03O00942O01002E90005900130001005A0004F03O00A52O012O00DA000C00024O00C4000D5O00202O000D000D000F4O000E000E6O000F00033O00202O000F000F001000122O001100116O000F001100024O000F000F6O000C000F000200062O000C00A52O013O0004F03O00A52O012O00DA000C00013O00123C000D005B3O00123C000E005C4O0034000C000E4O00C3000C5O00123C000B00023O002EF7005D005F2O01005E0004F03O005F2O01002629000B005F2O0100020004F03O005F2O0100123C000A00023O0004F03O00AD2O010004F03O005F2O01000EFB000500B12O01000A0004F03O00B12O01002E90005F0089000100600004F03O00380201002EF70062002O020100610004F03O002O02012O00DA000B6O00A5000C00013O00122O000D00633O00122O000E00646O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B002O02013O0004F03O002O02012O00DA000B00043O0020F5000B000B00264O000B000200024O000C00066O000D00076O000E8O000F00013O00122O001000653O00122O001100666O000F001100024O000E000E000F00202O000E000E00674O000E000F6O000C3O00024O000D00096O000E00076O000F8O001000013O00122O001100653O00122O001200666O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000C000C000D00062O000C002O0201000B0004F03O002O02012O00DA000B00084O006B000C8O000D00013O00122O000E00683O00122O000F00696O000D000F00024O000C000C000D00202O000C000C006A4O000C0002000200102O000C006B000C4O000D8O000E00013O00122O000F006C3O00122O0010006D6O000E001000024O000D000D000E00202O000D000D006A4O000D000200024O000C000C000D00062O000B002O0201000C0004F03O002O02012O00DA000B000F3O002089000B000B006E4O000C5O00202O000C000C006F4O000D00106O000E00116O000F00033O00202O000F000F001C4O00115O00202O00110011006F4O000F001100024O000F000F6O000B000F000200062O000B002O02013O0004F03O002O02012O00DA000B00013O00123C000C00703O00123C000D00714O0034000B000D4O00C3000B5O002E9000720035000100720004F03O003702012O00DA000B6O00A5000C00013O00122O000D00733O00122O000E00746O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B003702013O0004F03O003702012O00DA000B00043O0020F5000B000B00264O000B000200024O000C00066O000D00076O000E8O000F00013O00122O001000753O00122O001100766O000F001100024O000E000E000F00202O000E000E00674O000E000F6O000C3O00024O000D00096O000E00076O000F8O001000013O00122O001100753O00122O001200766O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000C000C000D00062O000C00370201000B0004F03O003702012O00DA000B00024O00DA000C5O002022000C000C00772O0060000B00020002000664000B0032020100010004F03O00320201002E2800780037020100790004F03O003702012O00DA000B00013O00123C000C007A3O00123C000D007B4O0034000B000D4O00C3000B5O00123C000A00083O000EF2000200D70201000A0004F03O00D702012O00DA000B6O00A5000C00013O00122O000D007C3O00122O000E007D6O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B009602013O0004F03O009602012O00DA000B00043O0020F5000B000B00264O000B000200024O000C00066O000D00076O000E8O000F00013O00122O0010007E3O00122O0011007F6O000F001100024O000E000E000F00202O000E000E00674O000E000F6O000C3O00024O000D00096O000E00076O000F8O001000013O00122O0011007E3O00122O0012007F6O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000C000C000D00062O000C00960201000B0004F03O009602012O00DA000B00043O002002000B000B00294O000D5O00202O000D000D00184O000B000D00024O000C8O000D00013O00122O000E00803O00122O000F00816O000D000F00024O000C000C000D00202O000C000C00824O000C0002000200062O000C007E0201000B0004F03O007E02012O00DA000B00043O002004000B000B00294O000D5O00202O000D000D002A4O000B000D00024O000C8O000D00013O00122O000E00833O00122O000F00846O000D000F00024O000C000C000D00202O000C000C00824O000C0002000200062O000C00960201000B0004F03O009602012O00DA000B00123O000664000B0098020100010004F03O009802012O00DA000B6O0079000C00013O00122O000D00853O00122O000E00866O000C000E00024O000B000B000C00202O000B000B00874O000B00020002000E2O008800930201000B0004F03O009302012O00DA000B00133O002635010B0093020100890004F03O009302012O00DA000B00143O002061000B000B008A2O0060000B00020002000EC1008B00980201000B0004F03O009802012O00DA000B00153O00260F010B00980201008B0004F03O00980201002E28008C00AC0201008D0004F03O00AC0201002EF7008E00AC0201008F0004F03O00AC02012O00DA000B00024O000B000C5O00202O000C000C00904O000D000E6O000F00033O00202O000F000F001C4O00115O00202O0011001100904O000F001100024O000F000F6O000B000F000200062O000B00AC02013O0004F03O00AC02012O00DA000B00013O00123C000C00913O00123C000D00924O0034000B000D4O00C3000B6O00DA000B6O00A5000C00013O00122O000D00933O00122O000E00946O000C000E00024O000B000B000C00202O000B000B000D4O000B0002000200062O000B00C002013O0004F03O00C002012O00DA000B00043O002053000B000B00164O000D5O00202O000D000D00954O000B000D000200062O000B00C002013O0004F03O00C002012O00DA000B00083O00260F010B00C2020100080004F03O00C20201002EF7009700D6020100960004F03O00D602012O00DA000B00024O0031000C5O00202O000C000C00984O000D000E6O000F00033O00202O000F000F001C4O00115O00202O0011001100984O000F001100024O000F000F6O000B000F000200062O000B00D1020100010004F03O00D10201002EF7009900D60201009A0004F03O00D602012O00DA000B00013O00123C000C009B3O00123C000D009C4O0034000B000D4O00C3000B5O00123C000A00053O002E28009D005C2O01009E0004F03O005C2O01002629000A005C2O0100080004F03O005C2O0100123C000200093O0004F03O00DE02010004F03O005C2O01000EF200010009040100020004F03O0009040100123C000A00014O0040000B000B3O002629000A00E2020100010004F03O00E2020100123C000B00013O002629000B00E9020100080004F03O00E9020100123C000200023O0004F03O00090401002629000B0019030100010004F03O001903012O00DA000C00043O002061000C000C009F2O0060000C000200020006DF000300F40201000C0004F03O00F402012O00DA000C00043O002061000C000C00A02O0060000C000200022O00F10003000C4O00DA000C6O00A5000D00013O00122O000E00A13O00122O000F00A26O000D000F00024O000C000C000D00202O000C000C00394O000C0002000200062O000C2O0003013O0004F04O00030100066400030002030100010004F03O00020301002E9000A30018000100A40004F03O00180301002E9000A50016000100A50004F03O001803012O00DA000C000F3O002089000C000C006E4O000D5O00202O000D000D00A64O000E00106O000F00166O001000033O00202O00100010001C4O00125O00202O0012001200A64O0010001200024O001000106O000C0010000200062O000C001803013O0004F03O001803012O00DA000C00013O00123C000D00A73O00123C000E00A84O0034000C000E4O00C3000C5O00123C000B00023O0026C5000B001D030100020004F03O001D0301002E9000A90064000100AA0004F03O007F030100123C000C00013O0026C5000C0022030100010004F03O00220301002EF700AC007A030100AB0004F03O007A03012O00DA000D00174O009A000D000100020006D5000D005803013O0004F03O005803012O00DA000D00143O002061000D000D008A2O0060000D00020002002646000D0056030100AD0004F03O005603012O00DA000D00123O000664000D0056030100010004F03O005603012O00DA000D00033O002061000D000D00AE2O0060000D00020002000E41008B00360301000D0004F03O003603012O00DA000D00133O00260F010D0057030100AF0004F03O005703012O00DA000D00154O00DA000E00063O00123C000F00B04O00DA0010000A4O00DA00116O000C001200013O00122O001300B13O00122O001400B26O0012001400024O00110011001200202B0011001100254O001100126O00103O000200102O0010008B00104O000E001000024O000F00093O00122O001000B06O0011000A6O00126O000C001300013O00122O001400B13O00122O001500B26O0013001500024O0012001200130020E50012001200254O001200136O00113O000200102O0011008B00114O000F001100024O000E000E000F00062O000D00570301000E0004F03O005703012O0026000D6O0082000D00014O0084000D00054O008C000D8O000E00013O00122O000F00B33O00122O001000B46O000E001000024O000D000D000E00202O000D000D00394O000D0002000200062O000D007903013O0004F03O00790301002EF700B50079030100B60004F03O007903012O00DA000D000F3O002089000D000D006E4O000E5O00202O000E000E00B74O000F00106O001000186O001100033O00202O00110011001C4O00135O00202O0013001300B74O0011001300024O001100116O000D0011000200062O000D007903013O0004F03O007903012O00DA000D00013O00123C000E00B83O00123C000F00B94O0034000D000F4O00C3000D5O00123C000C00023O002629000C001E030100020004F03O001E030100123C000B00053O0004F03O007F03010004F03O001E0301002E2800BB00E5020100BA0004F03O00E50201000EF2000500E50201000B0004F03O00E5020100123C000C00013O002E2800BC0001040100BD0004F03O00010401002629000C0001040100010004F03O00010401002EF700BE00AC030100BF0004F03O00AC03012O00DA000D6O00A5000E00013O00122O000F00C03O00122O001000C16O000E001000024O000D000D000E00202O000D000D00394O000D0002000200062O000D00AC03013O0004F03O00AC0301000664000300AC030100010004F03O00AC03012O00DA000D000F3O0020CC000D000D006E4O000E5O00202O000E000E00A64O000F00106O001000166O001100033O00202O00110011001C4O00135O00202O0013001300A64O0011001300024O001100116O000D0011000200062O000D00A7030100010004F03O00A70301002E2800C300AC030100C20004F03O00AC03012O00DA000D00013O00123C000E00C43O00123C000F00C54O0034000D000F4O00C3000D6O00DA000D6O00A5000E00013O00122O000F00C63O00122O001000C76O000E001000024O000D000D000E00202O000D000D00394O000D0002000200062O000D00EA03013O0004F03O00EA03012O00DA000D00043O0020F5000D000D00264O000D000200024O000E00066O000F00076O00108O001100013O00122O001200C83O00122O001300C96O0011001300024O00100010001100202O0010001000674O001000116O000E3O00024O000F00096O001000076O00118O001200013O00122O001300C83O00122O001400C96O0012001400024O00110011001200202O0011001100674O001100126O000F3O00024O000E000E000F00062O000E00EA0301000D0004F03O00EA03012O00DA000D00084O006B000E8O000F00013O00122O001000CA3O00122O001100CB6O000F001100024O000E000E000F00202O000E000E006A4O000E0002000200102O000E006B000E4O000F8O001000013O00122O001100CC3O00122O001200CD6O0010001200024O000F000F001000202O000F000F006A4O000F000200024O000E000E000F00062O000D00EA0301000E0004F03O00EA03012O00DA000D00053O000664000D00EC030100010004F03O00EC0301002E2800CF2O00040100CE0004F04O0004012O00DA000D000F3O002089000D000D006E4O000E5O00202O000E000E006F4O000F00106O001000116O001100033O00202O00110011001C4O00135O00202O00130013006F4O0011001300024O001100116O000D0011000200062O000D2O0004013O0004F04O0004012O00DA000D00013O00123C000E00D03O00123C000F00D14O0034000D000F4O00C3000D5O00123C000C00023O002629000C0084030100020004F03O0084030100123C000B00083O0004F03O00E502010004F03O008403010004F03O00E502010004F03O000904010004F03O00E2020100262900020062050100090004F03O0062050100123C000A00013O002E9000D2002E000100D20004F03O003A0401002629000A003A040100050004F03O003A04012O00DA000B6O00A5000C00013O00122O000D00D33O00122O000E00D46O000C000E00024O000B000B000C00202O000B000B000D4O000B0002000200062O000B003804013O0004F03O003804012O00DA000B00043O002053000B000B00164O000D5O00202O000D000D00954O000B000D000200062O000B003804013O0004F03O003804012O00DA000B00083O002646000B0038040100D50004F03O00380401002EF700D60038040100D70004F03O003804012O00DA000B00024O000B000C5O00202O000C000C00984O000D000E6O000F00033O00202O000F000F001C4O00115O00202O0011001100984O000F001100024O000F000F6O000B000F000200062O000B003804013O0004F03O003804012O00DA000B00013O00123C000C00D83O00123C000D00D94O0034000B000D4O00C3000B5O00123C000700013O00123C000A00083O0026C5000A003E040100080004F03O003E0401002E2800DA0040040100DB0004F03O0040040100123C000200AD3O0004F03O006205010026C5000A0044040100020004F03O00440401002E9000DC0092000100DD0004F03O00D40401002E2800DF009C040100DE0004F03O009C04012O00DA000B6O00A5000C00013O00122O000D00E03O00122O000E00E16O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B009C04013O0004F03O009C04012O00DA000B00043O0020F5000B000B00264O000B000200024O000C00066O000D00076O000E8O000F00013O00122O001000E23O00122O001100E36O000F001100024O000E000E000F00202O000E000E00674O000E000F6O000C3O00024O000D00096O000E00076O000F8O001000013O00122O001100E23O00122O001200E36O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000C000C000D00062O000C009C0401000B0004F03O009C04012O00DA000B00043O002002000B000B00294O000D5O00202O000D000D00184O000B000D00024O000C8O000D00013O00122O000E00E43O00122O000F00E56O000D000F00024O000C000C000D00202O000C000C00824O000C0002000200062O000C008A0401000B0004F03O008A04012O00DA000B00043O002004000B000B00294O000D5O00202O000D000D002A4O000B000D00024O000C8O000D00013O00122O000E00E63O00122O000F00E76O000D000F00024O000C000C000D00202O000C000C00824O000C0002000200062O000C009C0401000B0004F03O009C04012O00DA000B00024O000B000C5O00202O000C000C00E84O000D000E6O000F00033O00202O000F000F001C4O00115O00202O0011001100E84O000F001100024O000F000F6O000B000F000200062O000B009C04013O0004F03O009C04012O00DA000B00013O00123C000C00E93O00123C000D00EA4O0034000B000D4O00C3000B6O00DA000B6O00A5000C00013O00122O000D00EB3O00122O000E00EC6O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B00D304013O0004F03O00D304012O00DA000B00043O0020F5000B000B00264O000B000200024O000C00066O000D00076O000E8O000F00013O00122O001000ED3O00122O001100EE6O000F001100024O000E000E000F00202O000E000E00674O000E000F6O000C3O00024O000D00096O000E00076O000F8O001000013O00122O001100ED3O00122O001200EE6O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000C000C000D00062O000C00D30401000B0004F03O00D304012O00DA000B00024O00C4000C5O00202O000C000C00774O000D000D6O000E00033O00202O000E000E001000122O001000116O000E001000024O000E000E6O000B000E000200062O000B00D304013O0004F03O00D304012O00DA000B00013O00123C000C00EF3O00123C000D00F04O0034000B000D4O00C3000B5O00123C000A00053O002629000A000C040100010004F03O000C040100123C000B00013O0026C5000B00DB040100020004F03O00DB0401002EF700F200DD040100F10004F03O00DD040100123C000A00023O0004F03O000C0401002629000B00D7040100010004F03O00D704012O00DA000C6O00A5000D00013O00122O000E00F33O00122O000F00F46O000D000F00024O000C000C000D00202O000C000C00394O000C0002000200062O000C001F05013O0004F03O001F05012O00DA000C00174O009A000C000100020006D5000C001F05013O0004F03O001F05012O00DA000C00043O002061000C000C00F52O0060000C00020002002646000C001F050100F60004F03O001F05012O00DA000C00084O00DA000D000A4O00DA000E6O000C000F00013O00122O001000F73O00122O001100F86O000F001100024O000E000E000F0020EC000E000E00254O000E000F6O000D3O000200102O000D0008000D00062O000C001F0501000D0004F03O001F05012O00DA000C00043O0020CB000C000C00294O000E5O00202O000E000E00184O000C000E0002000E2O0009000E0501000C0004F03O000E05012O00DA000C00043O002019010C000C00294O000E5O00202O000E000E002A4O000C000E0002000E2O0009001F0501000C0004F03O001F05012O00DA000C00024O00C4000D5O00202O000D000D00F94O000E000E6O000F00033O00202O000F000F001000122O001100FA6O000F001100024O000F000F6O000C000F000200062O000C001F05013O0004F03O001F05012O00DA000C00013O00123C000D00FB3O00123C000E00FC4O0034000C000E4O00C3000C5O002E2800FD005F050100FE0004F03O005F05012O00DA000C6O00A5000D00013O00122O000E00FF3O00122O000F2O00015O000D000F00024O000C000C000D00202O000C000C00394O000C0002000200062O000C005F05013O0004F03O005F05012O00DA000C00043O0020F5000C000C00264O000C000200024O000D00066O000E00076O000F8O001000013O00122O0011002O012O00122O00120002015O0010001200024O000F000F001000202O000F000F00674O000F00106O000D3O00024O000E00096O000F00076O00108O001100013O00122O0012002O012O00122O00130002015O0011001300024O00100010001100202O0010001000674O001000116O000E3O00024O000D000D000E00062O000D005F0501000C0004F03O005F050100123C000C0003012O00123C000D0004012O000612010C005F0501000D0004F03O005F05012O00DA000C00024O00F4000D5O00122O000E0005015O000D000D000E4O000E000F6O001000033O00202O00100010001C4O00125O00122O00130005015O0012001200134O0010001200024O001000106O000C0010000200062O000C005F05013O0004F03O005F05012O00DA000C00013O00123C000D0006012O00123C000E0007013O0034000C000E4O00C3000C5O00123C000B00023O0004F03O00D704010004F03O000C040100123C000A00AD3O00060E010200690501000A0004F03O0069050100123C000A0008012O00123C000B0009012O000670000A00D00601000B0004F03O00D0060100123C000A00013O00123C000B00023O00060E010A00710501000B0004F03O0071050100123C000B000A012O00123C000C000B012O000612010B002A0601000C0004F03O002A06012O00DA000B00043O002053000B000B00164O000D5O00202O000D000D002A4O000B000D000200062O000B00E705013O0004F03O00E7050100123C000B00014O0040000C000F3O00123C001000013O0006E1000B0092050100100004F03O0092050100123C001000013O00123C001100023O00060E01110085050100100004F03O0085050100123C0011000C012O00123C0012000D012O00067000110087050100120004F03O0087050100123C000B00023O0004F03O0092050100123C001100013O00060E0110008E050100110004F03O008E050100123C0011000E012O00123C0012000F012O0006120112007E050100110004F03O007E050100123C000C00014O0040000D000D3O00123C001000023O0004F03O007E050100123C001000053O0006E1000B00D3050100100004F03O00D3050100123C00100010012O00123C00110011012O000670001100C5050100100004F03O00C5050100123C001000013O0006E1001000C50501000C0004F03O00C5050100123C001000013O00123C001100023O0006E1001000A2050100110004F03O00A2050100123C000C00023O0004F03O00C5050100123C00110012012O00123C00120013012O0006700011009D050100120004F03O009D050100123C001100013O0006E10010009D050100110004F03O009D050100123C001100013O00123C001200023O0006E1001100AF050100120004F03O00AF050100123C001000023O0004F03O009D050100123C001200013O0006E1001100AA050100120004F03O00AA05012O00DA001200043O0012C800140014015O0012001200144O00145O00202O00140014002A4O001500156O001600016O0012001600024O000D00126O001200013O00122O00130015012O00122O00140016015O0012001400024O0012000D001200122O001300026O000E0012001300122O001100023O00044O00AA05010004F03O009D050100123C001000023O00060E011000CC0501000C0004F03O00CC050100123C00100017012O00123C00110018012O00061201100095050100110004F03O0095050100123C00100019013O002F0010000E001000123C001100054O00CE000F001000110004F03O00E705010004F03O009505010004F03O00E7050100123C001000023O0006E1000B007A050100100004F03O007A050100123C001000013O00123C0011001A012O00123C0012001B012O000670001100E0050100120004F03O00E0050100123C001100013O0006E1001000E0050100110004F03O00E005012O0040000E000F3O00123C001000023O00123C001100023O0006E1001000D7050100110004F03O00D7050100123C000B00053O0004F03O007A05010004F03O00D705010004F03O007A05012O00DA000B6O00A5000C00013O00122O000D001C012O00122O000E001D015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B002906013O0004F03O002906012O00DA000B00043O00123C000D001E013O0023010B000B000D2O0060000B00020002000664000B0029060100010004F03O002906012O00DA000B00084O00EE000C000A6O000D00043O00202O000D000D00164O000F5O00202O000F000F00174O000D000F000200062O000D0004060100010004F03O0004060100065F00080003060100070004F03O000306012O0026000D6O0082000D00014O0060000C0002000200123C000D00084O002F000C000D000C000670000C00100601000B0004F03O001006012O00DA000B00043O002031010B000B00164O000D5O00202O000D000D00184O000B000D000200062O000B0013060100010004F03O001306012O00DA000B00193O0006D5000B002906013O0004F03O0029060100123C000B001F012O00123C000C0020012O000612010B00290601000C0004F03O002906012O00DA000B00024O000B000C5O00202O000C000C001B4O000D000E6O000F00033O00202O000F000F001C4O00115O00202O00110011001B4O000F001100024O000F000F6O000B000F000200062O000B002906013O0004F03O002906012O00DA000B00013O00123C000C0021012O00123C000D0022013O0034000B000D4O00C3000B5O00123C000A00053O00123C000B00013O00060E010A00310601000B0004F03O0031060100123C000B0023012O00123C000C0024012O000670000C00980601000B0004F03O0098060100123C000B00013O00123C000C00013O0006E1000B008E0601000C0004F03O008E060100123C000800014O008B000C00043O00202O000C000C00164O000E5O00202O000E000E00184O000C000E000200062O000C0041060100010004F03O0041060100123C000C0025012O00123C000D0026012O0006E1000C008D0601000D0004F03O008D060100123C000C00014O0040000D00113O00123C001200053O0006E1000C007D060100120004F03O007D06012O0040001100113O00123C00120027012O00123C00130027012O0006E100120051060100130004F03O0051060100123C001200013O0006E1000D0051060100120004F03O0051060100123C000E00014O0040000F000F3O00123C000D00023O00123C001200023O0006E1000D0056060100120004F03O005606012O0040001000113O00123C000D00053O00123C001200053O0006E1001200470601000D0004F03O0047060100123C00120028012O00123C00130029012O00061201130065060100120004F03O0065060100123C001200023O0006E1000E0065060100120004F03O0065060100123C00120019013O002F00120010001200123C001300054O00CE0011001200130004F03O008D060100123C001200013O0006E1001200590601000E0004F03O005906012O00DA001200043O0012C800140014015O0012001200144O00145O00202O0014001400184O001500156O001600016O0012001600024O000F00126O001200013O00122O0013002A012O00122O0014002B015O0012001400024O0012000F001200122O001300026O00100012001300122O000E00023O00044O005906010004F03O008D06010004F03O004706010004F03O008D060100123C0012002C012O00123C0013002C012O0006E100120087060100130004F03O0087060100123C001200013O0006E1001200870601000C0004F03O0087060100123C000D00014O0040000E000E3O00123C000C00023O00123C001200023O0006E1000C0043060100120004F03O004306012O0040000F00103O00123C000C00053O0004F03O0043060100123C000B00023O00123C000C00023O00060E010C00950601000B0004F03O0095060100123C000C002D012O00123C000D002E012O000612010C00320601000D0004F03O0032060100123C000A00023O0004F03O009806010004F03O0032060100123C000B00053O00060E010B009F0601000A0004F03O009F060100123C000B002F012O00123C000C0030012O000612010C00CA0601000B0004F03O00CA06012O00DA000B6O00A5000C00013O00122O000D0031012O00122O000E0032015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B00C606013O0004F03O00C606012O00DA000B00043O00123C000D001E013O0023010B000B000D2O0060000B00020002000664000B00C6060100010004F03O00C606012O00DA000B000E4O0096000C5O00122O000D0033015O000C000C000D4O000D00033O00202O000D000D001C4O000F5O00122O00100033015O000F000F00104O000D000F00024O000D000D6O000B000D000200062O000B00C1060100010004F03O00C1060100123C000B0034012O00123C000C0035012O000670000B00C60601000C0004F03O00C606012O00DA000B00013O00123C000C0036012O00123C000D0037013O0034000B000D4O00C3000B6O00DA000B001A4O009A000B000100022O00590009000B3O00123C000A00083O00123C000B00083O0006E1000B006A0501000A0004F03O006A050100123C00020038012O0004F03O00D006010004F03O006A050100123C000A0038012O0006E1000200E90601000A0004F03O00E906010006D5000900D606013O0004F03O00D606012O00A1000900024O00DA000A000B3O002010010A000A002F4O000B5O00122O000C0039015O000B000B000C4O000C8O000D00013O00122O000E003A012O00122O000F003B015O000D000F6O000A3O00020006D5000A006D08013O0004F03O006D08012O00DA000A00013O00125B000B003C012O00122O000C003D015O000A000C6O000A5O00044O006D080100123C000A00053O00060E010200F00601000A0004F03O00F0060100123C000A003E012O00123C000B003F012O0006E1000A001A0001000B0004F03O001A000100123C000A00013O00123C000B00023O0006E1000A00800701000B0004F03O008007012O00DA000B6O00A5000C00013O00122O000D0040012O00122O000E0041015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B002707013O0004F03O0027070100066400050027070100010004F03O002707012O00DA000B001B3O000664000B0013070100010004F03O001307012O00DA000B00043O0020C9000B000B00294O000D5O00202O000D000D00184O000B000D00024O000C8O000D00013O00122O000E0042012O00122O000F0043015O000D000F00024O000C000C000D00122O000E0044015O000C000C000E4O000C0002000200062O000B00270701000C0004F03O002707012O00DA000B00024O00F4000C5O00122O000D0033015O000C000C000D4O000D000E6O000F00033O00202O000F000F001C4O00115O00122O00120033015O0011001100124O000F001100024O000F000F6O000B000F000200062O000B002707013O0004F03O002707012O00DA000B00013O00123C000C0045012O00123C000D0046013O0034000B000D4O00C3000B6O00DA000B6O00A5000C00013O00122O000D0047012O00122O000E0048015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B006307013O0004F03O006307012O00DA000B00043O00202E010B000B00264O000B000200024O000C00066O000D00073O00122O000E0049015O000C000E00024O000D00096O000E00073O00122O000F0049015O000D000F00024O000C000C000D00062O000C00630701000B0004F03O006307012O00DA000B6O00A5000C00013O00122O000D004A012O00122O000E004B015O000C000E00024O000B000B000C00202O000B000B00254O000B0002000200062O000B006707013O0004F03O006707012O00DA000B00033O00122C000D004C015O000B000B000D4O000D5O00122O000E004D015O000D000D000E4O000B000D000200122O000C00053O00062O000B00630701000C0004F03O006307012O00DA000B00033O002061000B000B00AE2O0060000B0002000200123C000C004E012O000670000C00630701000B0004F03O006307012O00DA000B00043O0012D7000D004F015O000B000B000D00122O000D00026O000E5O00122O000F0050015O000E000E000F4O000B000E000200062O000B006707013O0004F03O0067070100123C000B0051012O00123C000C0052012O0006E1000B007F0701000C0004F03O007F07012O00DA000B00024O0003010C5O00122O000D0050015O000C000C000D4O000D000D6O000E00033O00202O000E000E001C4O00105O00122O00110050015O0010001000114O000E001000024O000E000E6O000B000E000200062O000B007A070100010004F03O007A070100123C000B0053012O00123C000C0054012O0006E1000B007F0701000C0004F03O007F07012O00DA000B00013O00123C000C0055012O00123C000D0056013O0034000B000D4O00C3000B5O00123C000A00053O00123C000B00013O0006E1000A00BB0701000B0004F03O00BB07012O00DA000B00083O00123C000C00083O00065F000B00880701000C0004F03O008807012O002600056O0082000500014O008C000B8O000C00013O00122O000D0057012O00122O000E0058015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B00BA07013O0004F03O00BA07010006D5000500BA07013O0004F03O00BA07012O00DA000B001B3O000664000B00A8070100010004F03O00A807012O00DA000B00043O0020C9000B000B00294O000D5O00202O000D000D002A4O000B000D00024O000C8O000D00013O00122O000E0059012O00122O000F005A015O000D000F00024O000C000C000D00122O000E0044015O000C000C000E4O000C0002000200062O000B00BA0701000C0004F03O00BA07012O00DA000B00024O000B000C5O00202O000C000C001B4O000D000E6O000F00033O00202O000F000F001C4O00115O00202O00110011001B4O000F001100024O000F000F6O000B000F000200062O000B00BA07013O0004F03O00BA07012O00DA000B00013O00123C000C005B012O00123C000D005C013O0034000B000D4O00C3000B5O00123C000A00023O00123C000B00083O00060E010A00C20701000B0004F03O00C2070100123C000B005D012O00123C000C005E012O000670000C00C40701000B0004F03O00C4070100123C000200083O0004F03O001A000100123C000B005F012O00123C000C0060012O000612010B00F10601000C0004F03O00F1060100123C000B00053O0006E1000A00F10601000B0004F03O00F106012O00DA000B6O00A5000C00013O00122O000D0061012O00122O000E0062015O000C000E00024O000B000B000C00202O000B000B00394O000B0002000200062O000B000F08013O0004F03O000F08012O00DA000B00033O002061000B000B00AE2O0060000B0002000200123C000C00053O000670000C00F30701000B0004F03O00F307012O00DA000B001C3O00123C000C00083O00065F000C00F70701000B0004F03O00F707012O00DA000B00143O002061000B000B008A2O0060000B0002000200123C000C0063012O000670000C00E90701000B0004F03O00E907012O00DA000B00133O00123C000C0064012O000605010B000F0001000C0004F03O00F707012O00DA000B00133O00123C000C0065012O000612010C00F30701000B0004F03O00F307012O00DA000B00043O002061000B000B00F52O0060000B0002000200123C000C00F63O00065F000C00F70701000B0004F03O00F707012O00DA000B00153O00123C000C008B3O000670000B000F0801000C0004F03O000F08012O00DA000B00024O0003010C5O00122O000D0066015O000C000C000D4O000D000D6O000E00033O00202O000E000E001C4O00105O00122O00110066015O0010001000114O000E001000024O000E000E6O000B000E000200062O000B000A080100010004F03O000A080100123C000B0067012O00123C000C0068012O0006E1000B000F0801000C0004F03O000F08012O00DA000B00013O00123C000C0069012O00123C000D006A013O0034000B000D4O00C3000B6O00DA000B00033O002061000B000B00AE2O0060000B0002000200123C000C00093O000670000C00300801000B0004F03O003008012O00DA000B00043O0020B2000B000B00164O000D5O00122O000E006B015O000D000D000E4O000B000D000200062O000600320801000B0004F03O003208012O00DA000B6O000C000C00013O00122O000D006C012O00122O000E006D015O000C000E00024O000B000B000C002061000B000B00252O0060000B000200020006DF000600320801000B0004F03O003208012O00DA000B00043O00120B010D006E015O000B000B000D4O000D5O00202O000D000D002C4O000B000D000200122O000C00083O00062O000B00310801000C0004F03O003108012O002600066O0082000600013O00123C000A00083O0004F03O00F106010004F03O001A00010004F03O006D080100123C000A00013O0006E10001003C0801000A0004F03O003C080100123C000200014O0040000300033O00123C000100023O00123C000A00023O00060E2O0100430801000A0004F03O0043080100123C000A006F012O00123C000B0070012O000612010A00450801000B0004F03O004508012O0040000400053O00123C000100053O00123C000A00053O00060E2O01004C0801000A0004F03O004C080100123C000A0071012O00123C000B0072012O000612010A00580801000B0004F03O0058080100123C000A00013O00123C000B00023O0006E1000A00520801000B0004F03O0052080100123C000100083O0004F03O0058080100123C000B00013O0006E1000A004D0801000B0004F03O004D08012O0040000600073O00123C000A00023O0004F03O004D080100123C000A00083O00060E2O01005F0801000A0004F03O005F080100123C000A0073012O00123C000B0074012O000612010B00160001000A0004F03O001600012O0040000800093O00123C000100093O0004F03O001600010004F03O006D080100123C000A00083O00060E010A006A08013O0004F03O006A080100123C000A000E012O00123C000B0075012O000612010B00020001000A0004F03O000200012O0040000700083O00123C3O00093O0004F03O000200012O00543O00017O000C3O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00E8A440025O0083B040025O00B07140025O000EA640025O0092B040025O00E0764003103O0048616E646C65546F705472696E6B6574025O0068B24000303O00123C3O00014O0040000100013O000EF20002001200013O0004F03O001200012O00DA00025O0020270102000200034O000300016O000400023O00122O000500046O000600066O0002000600024O000100023O00062O00010010000100010004F03O00100001002E280006002F000100050004F03O002F00012O00A1000100023O0004F03O002F00010026C53O0016000100010004F03O00160001002E2800080002000100070004F03O0002000100123C000200013O002EF7000A0029000100090004F03O0029000100262900020029000100010004F03O002900012O00DA00035O00203301030003000B4O000400016O000500023O00122O000600046O000700076O0003000700024O000100033O002E2O000C00050001000C0004F03O002800010006D50001002800013O0004F03O002800012O00A1000100023O00123C000200023O00262900020017000100020004F03O0017000100123C3O00023O0004F03O000200010004F03O001700010004F03O000200012O00543O00017O00033O0003073O00435F54696D657203053O004166746572026O33C33F00333O00123D3O00013O0020225O000200123C000100033O00062500023O0001002D2O00DA8O00DA3O00014O00DA3O00024O00DA3O00034O00DA3O00044O00DA3O00054O00DA3O00064O00DA3O00074O00DA3O00084O00DA3O00094O00DA3O000A4O00DA3O000B4O00DA3O000C4O00DA3O000D4O00DA3O000E4O00DA3O000F4O00DA3O00104O00DA3O00114O00DA3O00124O00DA3O00134O00DA3O00144O00DA3O00154O00DA3O00164O00DA3O00174O00DA3O00184O00DA3O00194O00DA3O001A4O00DA3O001B4O00DA3O001C4O00DA3O001D4O00DA3O001E4O00DA3O001F4O00DA3O00204O00DA3O00214O00DA3O00224O00DA3O00234O00DA3O00244O00DA3O00254O00DA3O00264O00DA3O00274O00DA3O00284O00DA3O00294O00DA3O002A4O00DA3O002B4O00DA3O002C4O00753O000200012O00543O00013O00013O00EC3O00028O00026O00F03F030C3O004570696353652O74696E677303073O0021F9F71E07430603063O0026759690796B2O033O0022B4ED03043O005A4DDB8E03073O00D20B263E40026903073O001A866441592C672O033O00F0EC3503053O00C491835043027O0040026O000840030D3O004973446561644F7247686F737403073O004E6F7468696E6703043O009B333C8703073O0083DF565DE3D09403173O00476574456E656D696573496E53706C61736852616E6765026O002440025O000EAA40025O0060A740026O001040025O00289740025O00D09640025O00606540025O0053B240025O00FAA040025O00E8B240025O0058AE40025O0008954003073O002ABF010F14ED0D03063O00887ED06668782O033O007B8EDD03083O003118EAAE23CF325D03073O0038FDFA8F7D09E103053O00116C929DE803063O005FCC13EA23AD03063O00C82BA3748D4F031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74030C3O0049734368612O6E656C696E67025O0040AA40025O00E89040026O00A640025O00ECAD40025O00E8B040025O002C9140025O0092B240025O0007B340025O001CB340030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00B2A240025O00809940025O00DCA240025O00C09840025O00DAA140025O0032A040025O009CA640025O00DEA54003173O00286C2A46A40A7A2A4AA7396C204AA5117D135EA70B7F3103053O00CB781E432B030B3O004973417661696C61626C65025O00EC9340025O002AAC40026O006E40025O0098924003083O0042752O66496E666F03073O0050415042752O6600025O00D88340025O00A2A14003063O00E12A44E1CDE203053O00B991452D8F025O00A49E40025O00B08040025O00806840025O009EA740026O00A040025O00CEA740025O00B07940025O0034A74003103O00426F2O73466967687452656D61696E73025O00809440025O00D2A540025O00E8A040025O0098AA4003063O0042752O66557003063O00434142752O66030F3O00496E6361726E6174696F6E42752O66025O00E09040025O00CCA640025O00C4AA40025O00D49B40024O0080B3C540030C3O00466967687452656D61696E73025O0018B140025O00CCAF4003113O00A3111AA7CE841E0DAFD3842B18AAD9840B03053O00BCEA7F79C6030B3O0042752O6652656D61696E73025O00288940025O0042B040025O0028B340030B3O00153D1C8D333B1DA537201E03043O00E3585273030A3O0049734361737461626C65030B3O004D2O6F6E6B696E466F726D025O00BAA340025O0023B24003103O004E10B5A9097A4D20BCA8107E0310B5A403063O0013237FDAC762025O001EAF40025O00F89140025O00C4AF40025O0097B040025O00989640025O00088140025O00408340025O00E06840025O0020B140025O00D0A140025O00D4B140025O00B08240025O0046AD40025O0062AE40025O009EB240030A3O005370652O6C4861737465026O001840030E3O00D1E1A6AC1A3BECC2B3B50930FCE503063O005E9F80D2D968030C3O007FEB04B64B5DEB7F51F203AD03083O001A309966DF3F1F9903083O00446562752O665570030E3O004D2O6F6E66697265446562752O6603123O002D52EFFA1662FFF6034BE8E13154ECF0095303043O009362208D030C3O00536F6C737469636542752O66026O003B40026O004440030A3O003A46F1D9034440114DE403073O002B782383AA6636026O003440026O002E40025O0088A440025O0040A340030A3O004265727365726B696E6703113O00560395A5A0A28F5D0880F6A8B18D5A46D503073O00E43466E7D6C5D0025O00FAA840025O006EA740025O00C08D40025O00C05140025O0056A240025O00707A40030D3O0043617374412O6E6F746174656403043O00502O6F6C03083O00574149542F416F45030C3O0029E17CDEAA8D16C45EC17AEF03083O00B67E8015AA8AEB79025O0085B340025O00A7B240025O000AAA40025O0068AC40025O00F4AC40025O00709B40025O003EAD4003073O00574149542F5354030B3O00BCDB3CF2C6153F14CBE90103083O0066EBBA5586E67350025O004CA440025O0028A940025O0062B340025O00B8AC40025O0016AB40025O007AA940025O00D49640025O000AA240025O003DB240025O00F07F4003113O003DFE1EEA19E903E310D003EC18F703EC1B03043O00827C9B6A030A3O00E6DFF7BDB4F37DA9D0D903083O00DFB5AB96CFC3961C03083O007F2EE2BC0F4D36EF03053O00692C5A83CE025O007EB040025O00309D4003103O004865616C746850657263656E74616765030B3O00FBBC2E0BC7B13C13DCB72A03043O0067B3D94F03073O0049735265616479025O0024A840025O00805940030B3O004865616C746873746F6E6503173O0042B21DD95584B05EB812D00188A64CB212C6489AA60AE303073O00C32AD77CB521EC025O0039B040025O00C49740030C3O00CD44A2A30FB0F073BFB114B903063O00D583252OD67D030C3O004E617475726573566967696C03143O00242A37B4F22D222BFFE5232D20B1F22F3D20FFB303053O0081464B45DF03083O0064CAE1E26FE44FC503063O008F26AB93891C025O00206F40025O00C0564003083O004261726B736B696E03143O00D283ABF810E8DDDEC2BDF605E6DAC38BAFF643B103073O00B4B0E2D993638303063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O0004B240025O003C9C40025O00C88340025O0066B14003163O0044656164467269656E646C79556E697473436F756E74025O0030A240025O00907740025O005EA94003073O003F5C352O37EC0503063O00986D39575E45025O00709540025O002AAF4003073O005265626972746803073O00EBD208AAACC65C03083O00C899B76AC3DEB234025O0080AD40025O00A89C4003064O00E69E342O5F03063O003A5283E85D2903063O0052657669766503093O004973496E52616E676503063O009152C61C4B3A03063O005FE337B0753D00CA042O00123C3O00014O0040000100013O0026293O0002000100010004F03O0002000100123C000100013O00262900010020000100020004F03O0020000100123D000200034O0048000300013O00122O000400043O00122O000500056O0003000500024O0002000200034O000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O00025O00122O000200036O000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000200023O00122O0001000C3O0026290001004B0001000D0004F03O004B000100123C000200013O00262900020044000100010004F03O0044000100123C000300013O0026290003002A000100020004F03O002A000100123C000200023O0004F03O0044000100262900030026000100010004F03O002600012O00DA000400033O00206100040004000E2O00600004000200020006D50004003D00013O0004F03O003D00012O00DA000400044O003E000500053O00202O00050005000F4O000600076O00040007000200062O0004003D00013O0004F03O003D00012O00DA000400013O00123C000500103O00123C000600114O0034000400064O00C300046O00DA000400073O00200700040004001200122O000600136O0004000600024O000400063O00122O000300023O00044O00260001002E2800150023000100140004F03O0023000100262900020023000100020004F03O0023000100123C000100163O0004F03O004B00010004F03O00230001000EF200010067000100010004F03O0067000100123C000200014O0040000300033O0026290002004F000100010004F03O004F000100123C000300013O002E280018005E000100170004F03O005E0001000EF20001005E000100030004F03O005E00012O00DA000400073O00201400040004001200122O000600136O0004000600024O000400066O000400086O00040001000100122O000300023O0026C500030062000100020004F03O00620001002E28001A0052000100190004F03O0052000100123C000100023O0004F03O006700010004F03O005200010004F03O006700010004F03O004F00010026C50001006B0001000C0004F03O006B0001002EF7001C00960001001B0004F03O0096000100123C000200013O00262900020091000100010004F03O0091000100123C000300013O0026C500030073000100020004F03O00730001002EF7001D00750001001E0004F03O0075000100123C000200023O0004F03O009100010026290003006F000100010004F03O006F000100123D000400034O0048000500013O00122O0006001F3O00122O000700206O0005000700024O0004000400054O000500013O00122O000600213O00122O000700226O0005000700024O0004000400054O000400093O00122O000400036O000500013O00122O000600233O00122O000700246O0005000700024O0004000400054O000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O0004000A3O00122O000300023O0004F03O006F00010026290002006C000100020004F03O006C000100123C0001000D3O0004F03O009600010004F03O006C000100262900010005000100160004F03O000500012O00DA000200023O0006D5000200A100013O0004F03O00A100012O00DA000200073O00201300020002002700122O000400136O0002000400024O0002000B3O00044O00A3000100123C000200024O00840002000B4O00DA000200033O0020610002000200282O0060000200020002000664000200C9040100010004F03O00C904012O00DA0002000A3O0006D5000200C904013O0004F03O00C9040100123C000200014O0040000300033O002629000200AD000100010004F03O00AD000100123C000300013O002E900029000E2O0100290004F03O00BE2O01000EF2000200BE2O0100030004F03O00BE2O0100123C000400014O0040000500053O002E28002A00B60001002B0004F03O00B60001002629000400B6000100010004F03O00B6000100123C000500013O0026C5000500BF000100020004F03O00BF0001002E28002D00C10001002C0004F03O00C1000100123C0003000C3O0004F03O00BE2O010026C5000500C5000100010004F03O00C50001002E28002F00BB0001002E0004F03O00BB0001002E28003000D1000100310004F03O00D100012O00DA0006000C3O0020220006000600322O009A0006000100020006D5000600D100013O0004F03O00D100012O00DA0006000D3O000664000600D1000100010004F03O00D100012O00DA0006000E4O008A0006000100012O00DA0006000C3O0020220006000600322O009A000600010002000664000600DD000100010004F03O00DD00012O00DA000600033O0020610006000600332O0060000600020002000664000600DD000100010004F03O00DD0001002E28003400BA2O0100350004F03O00BA2O0100123C000600014O0040000700083O002E9000360007000100360004F03O00E60001002629000600E6000100010004F03O00E6000100123C000700014O0040000800083O00123C000600023O002E90003700F9FF2O00370004F03O00DF0001002629000600DF000100020004F03O00DF0001002629000700EA000100010004F03O00EA000100123C000800013O002629000800302O01000C0004F03O00302O0100123C000900013O002EF70039002B2O0100380004F03O002B2O010026290009002B2O0100010004F03O002B2O0100123C000A00013O0026C5000A00F9000100010004F03O00F90001002EF7003A00242O01003B0004F03O00242O0100123C000B00014O0006010B000F6O000B00056O000C00013O00122O000D003C3O00122O000E003D6O000C000E00024O000B000B000C00202O000B000B003E4O000B0002000200062O000B00072O0100010004F03O00072O01002EF7004000232O01003F0004F03O00232O0100123C000B00014O0040000C000C3O002EF7004100092O0100420004F03O00092O01002629000B00092O0100010004F03O00092O012O00DA000D00033O00202O010D000D00434O000F00053O00202O000F000F00444O00108O001100016O000D001100024O000C000D3O00262O000C00232O0100450004F03O00232O01002EF70047001A2O0100460004F03O001A2O010004F03O00232O012O00DA000D00013O0012E8000E00483O00122O000F00496O000D000F00024O000D000C000D00202O000D000D00024O000D000F3O00044O00232O010004F03O00092O0100123C000A00023O002EF7004B00F50001004A0004F03O00F50001002629000A00F5000100020004F03O00F5000100123C000900023O0004F03O002B2O010004F03O00F50001002629000900F0000100020004F03O00F0000100123C0008000D3O0004F03O00302O010004F03O00F00001002E28004C004F2O01004D0004F03O004F2O010026290008004F2O0100010004F03O004F2O0100123C000900013O002629000900392O0100020004F03O00392O0100123C000800023O0004F03O004F2O01002E28004E00352O01004F0004F03O00352O01002629000900352O0100010004F03O00352O0100123C000A00013O002629000A00422O0100020004F03O00422O0100123C000900023O0004F03O00352O010026C5000A00462O0100010004F03O00462O01002E280051003E2O0100500004F03O003E2O012O0082000B00014O0058000B00106O000B00123O00202O000B000B00524O000B000100024O000B00113O00122O000A00023O00044O003E2O010004F03O00352O010026290008007D2O01000D0004F03O007D2O0100123C000900014O0040000A000A3O002629000900532O0100010004F03O00532O0100123C000A00013O002E28005300762O0100540004F03O00762O01002629000A00762O0100010004F03O00762O0100123C000B00013O000EFB0001005F2O01000B0004F03O005F2O01002E280056006F2O0100550004F03O006F2O012O00DA000C00033O002031010C000C00574O000E00053O00202O000E000E00584O000C000E000200062O000C006B2O0100010004F03O006B2O012O00DA000C00033O002061000C000C00572O00DA000E00053O002022000E000E00592O0069000C000E00022O0084000C00133O00123C000C00014O0084000C00143O00123C000B00023O002E28005A005B2O01005B0004F03O005B2O01002629000B005B2O0100020004F03O005B2O0100123C000A00023O0004F03O00762O010004F03O005B2O01002629000A00562O0100020004F03O00562O0100123C000800163O0004F03O007D2O010004F03O00562O010004F03O007D2O010004F03O00532O01002629000800962O0100020004F03O00962O0100123C000900013O000EFB000100842O0100090004F03O00842O01002E28005C00912O01005D0004F03O00912O012O00DA000A00114O0084000A00154O00DA000A00153O0026C5000A008A2O01005E0004F03O008A2O010004F03O00902O012O00DA000A00123O002006000A000A005F4O000B00066O000C8O000A000C00024O000A00153O00123C000900023O000EF2000200802O0100090004F03O00802O0100123C0008000C3O0004F03O00962O010004F03O00802O01002629000800ED000100160004F03O00ED00012O00DA000900133O0006640009009D2O0100010004F03O009D2O01002E28006000BA2O0100610004F03O00BA2O012O00DA000900054O00A5000A00013O00122O000B00623O00122O000C00636O000A000C00024O00090009000A00202O00090009003E4O00090002000200062O000900AE2O013O0004F03O00AE2O012O00DA000900033O0020310109000900644O000B00053O00202O000B000B00594O0009000B000200062O000900B32O0100010004F03O00B32O012O00DA000900033O0020610009000900642O00DA000B00053O002022000B000B00582O00690009000B00022O0084000900143O0004F03O00BA2O010004F03O00ED00010004F03O00BA2O010004F03O00EA00010004F03O00BA2O010004F03O00DF000100123C000500023O0004F03O00BB00010004F03O00BE2O010004F03O00B60001000EFB000C00C22O0100030004F03O00C22O01002EF7006600D3030100650004F03O00D303012O00DA000400033O0020610004000400332O0060000400020002000664000400E32O0100010004F03O00E32O01002E900067001C000100670004F03O00E32O012O00DA000400054O00A5000500013O00122O000600683O00122O000700696O0005000700024O00040004000500202O00040004006A4O00040002000200062O000400E32O013O0004F03O00E32O012O00DA000400163O0006D5000400E32O013O0004F03O00E32O012O00DA000400044O00DA000500053O00202200050005006B2O0060000400020002000664000400DE2O0100010004F03O00DE2O01002EF7006D00E32O01006C0004F03O00E32O012O00DA000400013O00123C0005006E3O00123C0006006F4O0034000400064O00C300046O00DA0004000C3O0020220004000400322O009A0004000100020006D5000400EB2O013O0004F03O00EB2O012O00DA00045O000664000400F22O0100010004F03O00F22O012O00DA000400033O0020610004000400332O0060000400020002000664000400F22O0100010004F03O00F22O01002EF7007000C9040100710004F03O00C9040100123C000400014O0040000500063O000EF2000100F92O0100040004F03O00F92O0100123C000500014O0040000600063O00123C000400023O002EF7007200F42O0100730004F03O00F42O01002629000400F42O0100020004F03O00F42O01002629000500220201000D0004F03O0022020100123C000700014O0040000800083O00262900070001020100010004F03O0001020100123C000800013O00262900080019020100010004F03O0019020100123C000900013O0026C50009000B020100010004F03O000B0201002EF700740014020100750004F03O001402012O00DA000A00174O009A000A000100022O00590006000A3O00066400060012020100010004F03O00120201002E9000760003000100770004F03O001302012O00A1000600023O00123C000900023O00262900090007020100020004F03O0007020100123C000800023O0004F03O001902010004F03O000702010026C50008001D020100020004F03O001D0201002E2800780004020100790004F03O0004020100123C000500163O0004F03O002202010004F03O000402010004F03O002202010004F03O000102010026290005004D020100010004F03O004D020100123C000700013O002EF7007B00480201007A0004F03O0048020100262900070048020100010004F03O004802012O00DA000800184O008A000800010001002E90007C001C0001007C0004F03O004702012O00DA000800033O0020610008000800332O006000080002000200066400080047020100010004F03O0047020100123C000800014O00400009000A3O000EF200020041020100080004F03O0041020100262900090036020100010004F03O003602012O00DA000B00194O009A000B000100022O0059000A000B3O0006D5000A004702013O0004F03O004702012O00A1000A00023O0004F03O004702010004F03O003602010004F03O0047020100262900080034020100010004F03O0034020100123C000900014O0040000A000A3O00123C000800023O0004F03O0034020100123C000700023O000EF200020025020100070004F03O0025020100123C000500023O0004F03O004D02010004F03O00250201002EF7007D00FD0201007E0004F03O00FD0201002629000500FD0201000C0004F03O00FD020100123C000700014O0040000800083O00262900070053020100010004F03O0053020100123C000800013O002629000800F4020100010004F03O00F402012O00DA0009001B4O00E0000A00033O00202O000A000A007F4O000A0002000200102O000A0080000A4O000B001C6O000C00056O000D00013O00122O000E00813O00122O000F00826O000D000F00024O000C000C000D00202O000C000C003E4O000C000D6O000B3O00024O000A000A000B4O000B001C6O000C00056O000D00013O00122O000E00833O00122O000F00846O000D000F00024O000C000C000D00202O000C000C003E4O000C000D6O000B3O00024O000C001C6O000D00073O00202O000D000D00854O000F00053O00202O000F000F00864O000D000F6O000C3O00024O000B000B000C4O000C001C6O000D001D6O000E00013O00122O000F00873O00122O001000886O000E001000024O000D000D000E4O000E001C6O000F00033O00202O000F000F00574O001100053O00202O0011001100894O000F00116O000E3O000200102O000E000C000E00102O000E008A000E00062O000E008D0201000D0004F03O008D02012O0026000D6O0082000D00014O00F8000C000200024O000B000B000C00202O000B000B008B4O0009000B00024O000A001E6O000B00033O00202O000B000B007F4O000B0002000200102O000B0080000B4O000C001C6O000D00056O000E00013O00122O000F00813O00122O001000826O000E001000024O000D000D000E00202O000D000D003E4O000D000E6O000C3O00024O000B000B000C4O000C001C6O000D00056O000E00013O00122O000F00833O00122O001000846O000E001000024O000D000D000E00202O000D000D003E4O000D000E6O000C3O00024O000D001C6O000E00073O00202O000E000E00854O001000053O00202O0010001000864O000E00106O000D3O00024O000C000C000D4O000D001C6O000E001D6O000F00013O00122O001000873O00122O001100886O000F001100024O000E000E000F4O000F001C6O001000033O00202O0010001000574O001200053O00202O0012001200894O001000126O000F3O000200102O000F000C000F00102O000F008A000F00062O000F00C70201000E0004F03O00C702012O0026000E6O0082000E00014O0016000D000200024O000C000C000D00202O000C000C008B4O000A000C00024O00090009000A4O0009001A6O000900056O000A00013O00122O000B008C3O00122O000C008D6O000A000C00024O00090009000A00202O00090009006A4O00090002000200062O000900F302013O0004F03O00F302012O00DA0009001F4O009A0009000100020006D5000900F302013O0004F03O00F302012O00DA000900143O000EF6008E00E5020100090004F03O00E502012O00DA000900203O000664000900E5020100010004F03O00E502012O00DA000900153O002646000900F30201008F0004F03O00F30201002EF7009100F3020100900004F03O00F302012O00DA000900214O001B000A00053O00202O000A000A00924O000B00226O0009000B000200062O000900F302013O0004F03O00F302012O00DA000900013O00123C000A00933O00123C000B00944O00340009000B4O00C300095O00123C000800023O0026C5000800F8020100020004F03O00F80201002E2800950056020100960004F03O0056020100123C0005000D3O0004F03O00FD02010004F03O005602010004F03O00FD02010004F03O005302010026290005006A030100160004F03O006A03012O00DA000700233O0006D50007000503013O0004F03O000503012O00DA000700023O00066400070007030100010004F03O00070301002E280097002F030100980004F03O002F030100123C000700014O0040000800093O000EF200020029030100070004F03O0029030100262900080016030100010004F03O001603012O00DA000A00244O009A000A000100022O00590009000A3O002E28009A0015030100990004F03O001503010006D50009001503013O0004F03O001503012O00A1000900023O00123C000800023O0026290008000B030100020004F03O000B03012O00DA000A00123O002037000A000A009B4O000B00053O00202O000B000B009C4O000C5O00122O000D009D6O000A000D000200062O000A002F03013O0004F03O002F03012O00DA000A00013O00125B000B009E3O00122O000C009F6O000A000C6O000A5O00044O002F03010004F03O000B03010004F03O002F030100262900070009030100010004F03O0009030100123C000800014O0040000900093O00123C000700023O0004F03O00090301002E2800A100C9040100A00004F03O00C9040100123C000700014O0040000800093O002EF700A2003A030100A30004F03O003A03010026290007003A030100010004F03O003A030100123C000800014O0040000900093O00123C000700023O002E2800340033030100A40004F03O0033030100262900070033030100020004F03O00330301000EF200020051030100080004F03O00510301002EF700A500C9040100A60004F03O00C904012O00DA000A00123O002037000A000A009B4O000B00053O00202O000B000B009C4O000C5O00122O000D00A76O000A000D000200062O000A00C904013O0004F03O00C904012O00DA000A00013O00125B000B00A83O00122O000C00A96O000A000C6O000A5O00044O00C90401002E2800AA003E030100AB0004F03O003E0301000EF20001003E030100080004F03O003E030100123C000A00013O002629000A005F030100010004F03O005F03012O00DA000B00254O009A000B000100022O00590009000B3O0006D50009005E03013O0004F03O005E03012O00A1000900023O00123C000A00023O000EFB000200630301000A0004F03O00630301002E2800AC0056030100AD0004F03O0056030100123C000800023O0004F03O003E03010004F03O005603010004F03O003E03010004F03O00C904010004F03O003303010004F03O00C90401000EFB0002006E030100050004F03O006E0301002EF700AE00FD2O0100AF0004F03O00FD2O0100123C000700013O00262900070073030100020004F03O0073030100123C0005000C3O0004F03O00FD2O01002E2800B0006F030100B10004F03O006F0301000EF20001006F030100070004F03O006F030100123C000800013O0026290008007C030100020004F03O007C030100123C000700023O0004F03O006F03010026C500080080030100010004F03O00800301002EF700B20078030100B30004F03O007803012O00DA0009000B4O00DA000A001B3O00123C000B00024O00DA000C001C4O00DA000D00054O000A010E00013O00122O000F00B43O00122O001000B56O000E001000024O000D000D000E00202O000D000D003E4O000D0002000200062O000D0098030100010004F03O009803012O00DA000D00054O001F010E00013O00122O000F00B63O00122O001000B76O000E001000024O000D000D000E00202O000D000D003E4O000D000200024O000D000D3O00044O009A03012O0026000D6O0082000D00014O0045000C000D4O0063000A3O00024O000B001E3O00122O000C00026O000D001C6O000E00054O000A010F00013O00122O001000B43O00122O001100B56O000F001100024O000E000E000F00202O000E000E003E4O000E0002000200062O000E00B3030100010004F03O00B303012O00DA000E00054O001F010F00013O00122O001000B63O00122O001100B76O000F001100024O000E000E000F00202O000E000E003E4O000E000200024O000E000E3O00044O00B503012O0026000E6O0082000E00014O0045000D000E4O0015010B3O00022O00BD000A000A000B000670000A00C3030100090004F03O00C303012O00DA000900054O0009010A00013O00122O000B00B83O00122O000C00B96O000A000C00024O00090009000A00202O00090009003E4O00090002000200044O00C503012O002600096O0082000900014O0084000900234O00DA0009000B3O000EC1000200CA030100090004F03O00CA03012O002600096O0082000900014O0084000900263O00123C000800023O0004F03O007803010004F03O006F03010004F03O00FD2O010004F03O00C904010004F03O00F42O010004F03O00C90401002629000300B0000100010004F03O00B000012O00DA000400033O0020610004000400332O00600004000200020006D50004005204013O0004F03O0052040100123C000400014O0040000500053O0026C5000400E0030100010004F03O00E00301002E2800BA00DC030100BB0004F03O00DC030100123C000500013O00262900050006040100020004F03O000604012O00DA000600033O0020610006000600BC2O00600006000200022O00DA000700273O00061201060052040100070004F03O005204012O00DA000600283O0006D50006005204013O0004F03O005204012O00DA000600294O00A5000700013O00122O000800BD3O00122O000900BE6O0007000900024O00060006000700202O0006000600BF4O00060002000200062O0006005204013O0004F03O00520401002E2800C10052040100C00004F03O005204012O00DA000600044O00C60007002A3O00202O0007000700C24O000800096O000A00016O0006000A000200062O0006005204013O0004F03O005204012O00DA000600013O00125B000700C33O00122O000800C46O000600086O00065O00044O00520401002EF700C600E1030100C50004F03O00E10301002629000500E1030100010004F03O00E1030100123C000600013O0026290006004A040100010004F03O004A04012O00DA000700033O0020610007000700BC2O00600007000200022O00DA0008002B3O0006120107002A040100080004F03O002A04012O00DA000700054O00A5000800013O00122O000900C73O00122O000A00C86O0008000A00024O00070007000800202O0007000700BF4O00070002000200062O0007002A04013O0004F03O002A04012O00DA000700044O00C6000800053O00202O0008000800C94O0009000A6O000B00016O0007000B000200062O0007002A04013O0004F03O002A04012O00DA000700013O00123C000800CA3O00123C000900CB4O0034000700094O00C300076O00DA000700033O0020610007000700BC2O00600007000200022O00DA0008002C3O0006120107003A040100080004F03O003A04012O00DA000700054O000A010800013O00122O000900CC3O00122O000A00CD6O0008000A00024O00070007000800202O0007000700BF4O00070002000200062O0007003C040100010004F03O003C0401002EF700CE0049040100CF0004F03O004904012O00DA000700044O00C6000800053O00202O0008000800D04O0009000A6O000B00016O0007000B000200062O0007004904013O0004F03O004904012O00DA000700013O00123C000800D13O00123C000900D24O0034000700094O00C300075O00123C000600023O0026290006000B040100020004F03O000B040100123C000500023O0004F03O00E103010004F03O000B04010004F03O00E103010004F03O005204010004F03O00DC03012O00DA000400073O0006D50004006A04013O0004F03O006A04012O00DA000400073O0020610004000400D32O00600004000200020006D50004006A04013O0004F03O006A04012O00DA000400073O0020610004000400D42O00600004000200020006D50004006A04013O0004F03O006A04012O00DA000400073O00206100040004000E2O00600004000200020006D50004006A04013O0004F03O006A04012O00DA000400033O0020610004000400D52O00DA000600074O00690004000600020006D50004006C04013O0004F03O006C0401002E9000D60057000100D70004F03O00C1040100123C000400014O0040000500063O002E2800D800BB040100D90004F03O00BB0401002629000400BB040100020004F03O00BB0401000EF200010072040100050004F03O007204012O00DA0007000C3O0020220107000700DA4O0007000100024O000600076O000700033O00202O0007000700334O00070002000200062O0007007F040100010004F03O007F0401002EF700DB009B040100DC0004F03O009B0401002E9000DD0042000100DD0004F03O00C104012O00DA000700054O00A5000800013O00122O000900DE3O00122O000A00DF6O0008000A00024O00070007000800202O00070007006A4O00070002000200062O000700C104013O0004F03O00C10401002EF700E000C1040100E10004F03O00C104012O00DA000700044O00C6000800053O00202O0008000800E24O000900096O000A00016O0007000A000200062O000700C104013O0004F03O00C104012O00DA000700013O00125B000800E33O00122O000900E46O000700096O00075O00044O00C10401002E2800E600C1040100E50004F03O00C104012O00DA000700054O00A5000800013O00122O000900E73O00122O000A00E86O0008000A00024O00070007000800202O00070007006A4O00070002000200062O000700C104013O0004F03O00C104012O00DA000700044O0030010800053O00202O0008000800E94O000900073O00202O0009000900EA00122O000B008B6O0009000B00024O000900096O000A00016O0007000A000200062O000700C104013O0004F03O00C104012O00DA000700013O00125B000800EB3O00122O000900EC6O000700096O00075O00044O00C104010004F03O007204010004F03O00C104010026290004006E040100010004F03O006E040100123C000500014O0040000600063O00123C000400023O0004F03O006E040100123C000300023O0004F03O00B000010004F03O00C904010004F03O00AD00010004F03O00C904010004F03O000500010004F03O00C904010004F03O000200012O00543O00017O00033O0003053O005072696E7403333O00750D325E7CD72717282C4A7BD06265032A5E66DD2D594C3C4632F1325E0F701F41C13247032C4B77D06255157E787DDE2B450D03073O0042376C5E3F12B400084O008F7O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

