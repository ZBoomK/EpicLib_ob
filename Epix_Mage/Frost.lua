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
				if (Enum <= 153) then
					if (Enum <= 76) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
										elseif (Enum > 2) then
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
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 6) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Enum == 7) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											local A = Inst[2];
											local B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
										end
									elseif (Enum <= 11) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									elseif (Enum == 12) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
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
								elseif (Enum <= 15) then
									if (Enum > 14) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 17) then
									local A;
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
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum > 19) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum == 21) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 24) then
									if (Enum == 23) then
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
								elseif (Enum <= 25) then
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
								elseif (Enum == 26) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									do
										return;
									end
								end
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum == 28) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 30) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 31) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 34) then
								if (Enum > 33) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 35) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							end
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
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
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 40) then
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
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
										if not Stk[Inst[2]] then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 45) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 53) then
								if (Enum > 52) then
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
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
							elseif (Enum <= 54) then
								Stk[Inst[2]] = Inst[3] ~= 0;
							elseif (Enum == 55) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 66) then
							if (Enum <= 61) then
								if (Enum <= 58) then
									if (Enum > 57) then
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
								elseif (Enum <= 59) then
									local B;
									local A;
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum == 60) then
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
							elseif (Enum <= 63) then
								if (Enum == 62) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 64) then
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
							elseif (Enum > 65) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 69) then
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
							elseif (Enum > 70) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
							if (Enum > 72) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 74) then
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
						elseif (Enum > 75) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 114) then
						if (Enum <= 95) then
							if (Enum <= 85) then
								if (Enum <= 80) then
									if (Enum <= 78) then
										if (Enum > 77) then
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 79) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 82) then
									if (Enum == 81) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									end
								elseif (Enum <= 83) then
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 84) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Enum > 86) then
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
								elseif (Enum <= 88) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 89) then
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 92) then
								if (Enum > 91) then
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
							elseif (Enum <= 93) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 94) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 104) then
							if (Enum <= 99) then
								if (Enum <= 97) then
									if (Enum > 96) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 98) then
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
							elseif (Enum <= 101) then
								if (Enum > 100) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A] = Stk[A]();
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
							elseif (Enum <= 102) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 103) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 109) then
							if (Enum <= 106) then
								if (Enum > 105) then
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
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
							elseif (Enum <= 107) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 108) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 111) then
							if (Enum == 110) then
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
						elseif (Enum <= 112) then
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
						elseif (Enum == 113) then
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
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
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
					elseif (Enum <= 133) then
						if (Enum <= 123) then
							if (Enum <= 118) then
								if (Enum <= 116) then
									if (Enum == 115) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 117) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum > 119) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 121) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 122) then
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
							end
						elseif (Enum <= 128) then
							if (Enum <= 125) then
								if (Enum == 124) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									Stk[Inst[2]]();
								end
							elseif (Enum <= 126) then
								if (Inst[2] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 127) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 130) then
							if (Enum > 129) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 131) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 132) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						end
					elseif (Enum <= 143) then
						if (Enum <= 138) then
							if (Enum <= 135) then
								if (Enum > 134) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 136) then
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							elseif (Enum == 137) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 140) then
							if (Enum > 139) then
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
							end
						elseif (Enum <= 141) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 142) then
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 148) then
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
							end
						elseif (Enum <= 146) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 147) then
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
					elseif (Enum <= 150) then
						if (Enum > 149) then
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
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 151) then
						Stk[Inst[2]] = Inst[3] ~= 0;
						VIP = VIP + 1;
					elseif (Enum == 152) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 230) then
					if (Enum <= 191) then
						if (Enum <= 172) then
							if (Enum <= 162) then
								if (Enum <= 157) then
									if (Enum <= 155) then
										if (Enum > 154) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											local A = Inst[2];
											do
												return Stk[A](Unpack(Stk, A + 1, Top));
											end
										end
									elseif (Enum > 156) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 159) then
									if (Enum == 158) then
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
									elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 160) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
								elseif (Enum == 161) then
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
							elseif (Enum <= 167) then
								if (Enum <= 164) then
									if (Enum == 163) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 165) then
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
								elseif (Enum > 166) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 169) then
								if (Enum == 168) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 170) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							elseif (Enum > 171) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 181) then
							if (Enum <= 176) then
								if (Enum <= 174) then
									if (Enum > 173) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										VIP = Inst[3];
									elseif (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 175) then
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
							elseif (Enum <= 178) then
								if (Enum == 177) then
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 179) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 180) then
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 186) then
							if (Enum <= 183) then
								if (Enum == 182) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 184) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 185) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 188) then
							if (Enum == 187) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							end
						elseif (Enum <= 189) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 190) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 210) then
						if (Enum <= 200) then
							if (Enum <= 195) then
								if (Enum <= 193) then
									if (Enum > 192) then
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
									end
								elseif (Enum > 194) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 197) then
								if (Enum == 196) then
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
							elseif (Enum <= 198) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
							elseif (Enum == 199) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 205) then
							if (Enum <= 202) then
								if (Enum > 201) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 203) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 204) then
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 207) then
							if (Enum == 206) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 209) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
						end
					elseif (Enum <= 220) then
						if (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum > 211) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 213) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 214) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum <= 217) then
							if (Enum == 216) then
								local B;
								local A;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 218) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 219) then
							do
								return Stk[Inst[2]]();
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
					elseif (Enum <= 225) then
						if (Enum <= 222) then
							if (Enum > 221) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 223) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 224) then
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
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 229) then
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
							if (Mvm[1] == 303) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
				elseif (Enum <= 269) then
					if (Enum <= 249) then
						if (Enum <= 239) then
							if (Enum <= 234) then
								if (Enum <= 232) then
									if (Enum > 231) then
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
								elseif (Enum == 233) then
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
									Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 236) then
								if (Enum == 235) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 237) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum > 238) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 244) then
							if (Enum <= 241) then
								if (Enum == 240) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
							elseif (Enum <= 242) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 243) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 246) then
							if (Enum > 245) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 247) then
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
						elseif (Enum > 248) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 259) then
						if (Enum <= 254) then
							if (Enum <= 251) then
								if (Enum == 250) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								end
							elseif (Enum <= 252) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							elseif (Enum == 253) then
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
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 256) then
							if (Enum == 255) then
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
						elseif (Enum <= 257) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
						elseif (Enum > 258) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 264) then
						if (Enum <= 261) then
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
						elseif (Enum <= 262) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 263) then
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
					elseif (Enum <= 266) then
						if (Enum == 265) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 267) then
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
					elseif (Enum > 268) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 288) then
					if (Enum <= 278) then
						if (Enum <= 273) then
							if (Enum <= 271) then
								if (Enum == 270) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 272) then
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
						elseif (Enum <= 275) then
							if (Enum == 274) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 276) then
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 277) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 283) then
						if (Enum <= 280) then
							if (Enum == 279) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 281) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum == 282) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 285) then
						if (Enum > 284) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 286) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 287) then
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
					else
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
						Stk[Inst[2]] = Inst[3] ~= 0;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Upvalues[Inst[3]] = Stk[Inst[2]];
					end
				elseif (Enum <= 298) then
					if (Enum <= 293) then
						if (Enum <= 290) then
							if (Enum > 289) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 291) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 292) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum == 294) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 296) then
						do
							return Stk[Inst[2]];
						end
					elseif (Enum == 297) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 303) then
					if (Enum <= 300) then
						if (Enum == 299) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 301) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 302) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 305) then
					if (Enum == 304) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = #Stk[Inst[3]];
					end
				elseif (Enum <= 306) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum == 307) then
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503133O00F4D3D23DD996C619D4FCFD37E9A8D350DDD6DA03083O007EB1A3BB4586DBA703133O00903EBD65BB982FB378BB933CBB6E90FB22A17C03053O00E4D54ED41D002C3O001203012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004783O000A00010012C7000300063O0020240004000300070012C7000500083O0020240005000500090012C7000600083O00202400060006000A0006E600073O000100062O002F012O00064O002F017O002F012O00044O002F012O00014O002F012O00024O002F012O00053O00202400080003000B00202400090003000C2O00B4000A5O0012C7000B000D3O0006E6000C0001000100022O002F012O000A4O002F012O000B4O002F010D00073O001253000E000E3O001253000F000F4O000B000D000F00020006E6000E0002000100012O002F012O00074O0054000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O000E00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AB00076O00A1000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00AB000C00034O00F7000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0006000C6O0029000A3O0002002032000A000A00022O00160109000A4O00EA00073O00010004F30003000500012O00AB000300054O002F010400024O003E000300044O00D300036O00943O00017O000A3O00028O00025O008CAA40025O0080A240026O00F03F025O005CAB40025O00A49E40025O00E6B040025O00389B40025O005DB240025O0028AB40013C3O001253000200014O002O010300043O0026D900020011000100010004783O00110001001253000500013O00264800050009000100010004783O00090001002EAD00020005000100030004783O000C0001001253000300014O002O010400043O001253000500043O0026D900050005000100040004783O00050001001253000200043O0004783O001100010004783O00050001002EE800060002000100050004783O000200010026D900020002000100040004783O00020001001253000500013O0026480005001A000100010004783O001A0001002E5A00070016000100080004783O00160001002E5A000A0030000100090004783O003000010026D900030030000100010004783O00300001001253000600013O0026D900060023000100040004783O00230001001253000300043O0004783O003000010026D90006001F000100010004783O001F00012O00AB00076O00C4000400073O0006300004002E000100010004783O002E00012O00AB000700014O002F01086O003500096O009A00076O00D300075O001253000600043O0004783O001F00010026D900030015000100040004783O001500012O002F010600044O003500076O009A00066O00D300065O0004783O001500010004783O001600010004783O001500010004783O003B00010004783O000200012O00943O00017O00693O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A3050030A3O0064570C3140711020454E03043O004529226003043O0095D7D20703063O004BDCA3B76A6203043O0021BB982303053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE030B3O0019D3299B3AE2399A3ACE3E03043O00E849A14C03053O0096D8414F1103053O007EDBB9223D03043O002EC7507603083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC503043O006D6174682O033O005B294703073O009836483F58453E03043O00F9C5E95903043O003CB4A48E03053O007E4C0A3A3303073O0072383E6549478D03043O0095E8DCC103043O00A4D889BB03053O002OF43EA1B203073O006BB28651D2C69E03043O00150F85C303053O00CA586EE2A603053O00E51D8DE4DE03053O00AAA36FE297028O00026O002E40024O0080B3C54003073O00323FBF3541393A03073O00497150D2582E5703083O00A43AC800FE8E22C803053O0087E14CAD7203103O005265676973746572466F724576656E7403243O00F53C33FA8059B9E43326EA934EB9E72F22F09F5DAAFD2526E79F53A8EB3C2FF2985BA3F003073O00E6B47F67B3D61C03093O00AA17505CE14FCF9E0703073O0080EC653F26842103163O005265676973746572496E466C69676874452O66656374024O0010AFF44003093O008ABB1E5EB3E5E0BEAB03073O00AFCCC97124D68B03103O005265676973746572496E466C6967687403143O00815D98B21D885C86B303885495BF1A83478DA11103053O0053CD18D9E003093O00C0D7C22EF2C7C231F203043O005D86A5AD024O00A8E70B4103093O0098E0CED12ECCBD72AA03083O001EDE92A1A25AAED203063O00C3426518F75703043O006A852E10024O0010E00B4103063O007E2C66EE485903063O00203840139C3A03083O0073CBE07A5BFC835F03073O00E03AA885363A92024O00B0E70B4103083O0070554ED17488840E03083O006B39362B9D15E6E7030C3O00FC8710F6B0DDC3E89B18FEBC03073O00AFBBEB7195D9BC024O00C0E70B41030C3O001BA3804FEA78740FBF8847E603073O00185CCFE12C831903143O007BFF99753E4F74E19D6B3E5374F6966D39516EF703063O001D2BB3D82C7B03063O0053657441504C026O0050400056023O008B000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00127B000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00127B0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00127B000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00127B000D00123O00122O000E00136O000C000E00024O000C0006000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O001253000F00163O001253001000174O000B000E001000022O00C4000E0004000E2O00AB000F5O00121D001000183O00122O001100196O000F001100024O000F0004000F00122O001000046O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011001000112O00F000125O00122O0013001C3O00122O0014001D6O0012001400024O0012001000124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013001000132O00AB00145O001253001500203O001253001600214O000B0014001600022O00C40014001000142O00AB00155O001295001600223O00122O001700236O0015001700024O0015001000154O00165O00122O001700243O00122O001800256O0016001800024O0016001000164O00175O00122O001800263O00122O001900276O0017001900024O0016001600174O00175O00122O001800283O00122O001900296O0017001900024O0016001600174O00175O00122O0018002A3O00122O0019002B6O0017001900024O0017001000174O00185O00122O0019002C3O00122O001A002D6O0018001A00024O0017001700184O00185O00122O0019002E3O00122O001A002F6O0018001A00024O00170017001800122O001800306O00195O00122O001A00313O00122O001B00326O0019001B00024O0018001800194O001900196O001A8O001B8O001C8O001D8O001E005B6O005C5O00122O005D00333O00122O005E00346O005C005E00024O005C000D005C4O005D5O00122O005E00353O00122O005F00366O005D005F00024O005C005C005D4O005D5O00122O005E00373O00122O005F00386O005D005F00024O005D000F005D4O005E5O00122O005F00393O00122O0060003A6O005E006000024O005D005D005E4O005E5O00122O005F003B3O00122O0060003C6O005E006000024O005E0014005E4O005F5O00122O0060003D3O00122O0061003E6O005F006100024O005E005E005F4O005F8O006000633O00122O0064003F3O00122O0065003F3O001253006600403O0012C0006700413O00122O006800416O006900696O006A5O00122O006B00423O00122O006C00436O006A006C00024O006A0010006A4O006B5O00122O006C00443O00122O006D00456O006B006D00024O006A006A006B0006E6006B3O000100032O002F012O005C4O00AB8O002F012O006A3O00200A006C000400460006E6006E0001000100012O002F012O006B4O0057006F5O00122O007000473O00122O007100486O006F00716O006C3O00012O00BA006C5O00122O006D00493O00122O006E004A6O006C006E00024O006C005C006C00202O006C006C004B00122O006E004C6O006C006E00014O006C5O00122O006D004D3O001252006E004E6O006C006E00024O006C005C006C00202O006C006C004F4O006C0002000100202O006C000400460006E6006E0002000100022O002F012O005C4O00AB8O0057006F5O00122O007000503O00122O007100516O006F00716O006C3O00012O00BA006C5O00122O006D00523O00122O006E00536O006C006E00024O006C005C006C00202O006C006C004B00122O006E00546O006C006E00014O006C5O00122O006D00553O001253006E00564O00BC006C006E00024O006C005C006C00202O006C006C004F4O006C000200014O006C5O00122O006D00573O00122O006E00586O006C006E00024O006C005C006C00202O006C006C004B001253006E00594O003B006C006E00014O006C5O00122O006D005A3O00122O006E005B6O006C006E00024O006C005C006C00202O006C006C004F4O006C000200014O006C5O00122O006D005C3O001253006E005D4O0066006C006E00024O006C005C006C00202O006C006C004B00122O006E005E6O006C006E00014O006C5O00122O006D005F3O00122O006E00606O006C006E00024O006C005C006C00200A006C006C004F2O00D8006C000200014O006C5O00122O006D00613O00122O006E00626O006C006E00024O006C005C006C00202O006C006C004B00122O006E00636O006C006E00014O006C5O001253006D00643O001252006E00656O006C006E00024O006C005C006C00202O006C006C004F4O006C0002000100202O006C000400460006E6006E0003000100032O002F012O00674O002F012O00684O002F012O00644O0057006F5O00122O007000663O00122O007100676O006F00716O006C3O00010006E6006C0004000100012O002F012O00093O0006E6006D0005000100042O002F012O00184O002F012O00084O002F012O005C4O002F012O00093O0006E6006E0006000100022O002F012O005C4O00AB7O0006E6006F0007000100012O002F012O005C3O0006E600700008000100012O002F012O005C3O0006E6007100090001001A2O002F012O005C4O00AB8O002F012O003C4O002F012O00084O002F012O00434O002F012O00124O002F012O003B4O002F012O00424O002F012O00384O002F012O003F4O002F012O005D4O002F012O004F4O002F012O00514O002F012O005E4O002F012O00394O002F012O00404O002F012O003D4O002F012O006A4O002F012O00454O002F012O003E4O002F012O00444O002F012O003A4O002F012O00414O002F012O004E4O002F012O00504O002F012O00523O0006E60072000A000100062O002F012O005C4O00AB8O002F012O001D4O002F012O006A4O002F012O00124O002F012O005E3O0006E60073000B000100042O002F012O00194O002F012O006A4O002F012O005F4O002F012O001C3O0006E60074000C000100082O002F012O006A4O002F012O005C4O00AB8O002F012O003E4O002F012O005A4O002F012O00124O002F012O00084O002F012O00093O0006E60075000D000100122O002F012O00594O002F012O005C4O00AB8O002F012O00084O002F012O00124O002F012O00094O002F012O006A4O002F012O001C4O002F012O002E4O002F012O00334O002F012O004D4O002F012O00684O002F012O00544O002F012O00554O002F012O00194O002F012O00734O002F012O00534O002F012O00563O0006E60076000E0001000A2O002F012O005C4O00AB8O002F012O001E4O002F012O00084O002F012O00614O002F012O00124O002F012O00094O002F012O00294O002F012O00284O002F012O002A3O0006E60077000F000100272O002F012O005C4O00AB8O002F012O00234O002F012O00124O002F012O00094O002F012O00084O002F012O00584O002F012O00764O002F012O00324O002F012O00374O002F012O001C4O002F012O004D4O002F012O00684O002F012O00274O002F012O00654O002F012O00694O002F012O00254O002F012O006C4O002F012O00644O002F012O00244O002F012O00664O002F012O00314O002F012O00364O002F012O000C4O002F012O00264O002F012O006D4O002F012O005E4O002F012O002A4O002F012O00204O002F012O00354O002F012O00304O002F012O00344O002F012O002F4O002F012O00214O002F012O00614O002F012O001E4O002F012O00294O002F012O00174O002F012O00603O0006E600780010000100212O002F012O005C4O00AB8O002F012O00644O002F012O002B4O002F012O006A4O002F012O00634O002F012O006F4O002F012O00094O002F012O00274O002F012O00654O002F012O00124O002F012O00344O002F012O001C4O002F012O002F4O002F012O004D4O002F012O00684O002F012O00084O002F012O005E4O002F012O00294O002F012O002A4O002F012O00614O002F012O00324O002F012O00374O002F012O00314O002F012O00364O002F012O00204O002F012O00234O002F012O00584O002F012O00764O002F012O00354O002F012O00304O002F012O00254O002F012O00703O0006E600790011000100202O002F012O005C4O00AB8O002F012O00274O002F012O00654O002F012O00124O002F012O00094O002F012O00294O002F012O00084O002F012O00174O002F012O00644O002F012O002A4O002F012O00614O002F012O00304O002F012O00354O002F012O001C4O002F012O004D4O002F012O00684O002F012O00534O002F012O00564O002F012O00234O002F012O00584O002F012O00764O002F012O00314O002F012O00364O002F012O00604O002F012O00204O002F012O005E4O002F012O00324O002F012O00374O002F012O002F4O002F012O00344O002F012O002B3O0006E6007A00120001002E2O002F012O00574O00AB8O002F012O00584O002F012O00444O002F012O00454O002F012O00414O002F012O00424O002F012O00304O002F012O00314O002F012O00324O002F012O00334O002F012O00344O002F012O00354O002F012O00594O002F012O005A4O002F012O005B4O002F012O001E4O002F012O001F4O002F012O00224O002F012O00234O002F012O00204O002F012O00214O002F012O00284O002F012O00294O002F012O00264O002F012O00274O002F012O00244O002F012O00254O002F012O002E4O002F012O002F4O002F012O002A4O002F012O002B4O002F012O002C4O002F012O002D4O002F012O00404O002F012O00434O002F012O003C4O002F012O003D4O002F012O003E4O002F012O003F4O002F012O003A4O002F012O003B4O002F012O00364O002F012O00374O002F012O00384O002F012O00393O0006E6007B0013000100122O002F012O00474O00AB8O002F012O00464O002F012O00544O002F012O00534O002F012O00524O002F012O00484O002F012O00514O002F012O00504O002F012O004F4O002F012O004E4O002F012O00554O002F012O00564O002F012O004B4O002F012O004C4O002F012O004D4O002F012O004A4O002F012O00493O0006E6007C0014000100292O002F012O007A4O002F012O007B4O002F012O001A4O00AB8O002F012O00084O002F012O00634O002F012O00094O002F012O001B4O002F012O00604O002F012O00184O002F012O00614O002F012O00624O002F012O005C4O002F012O006A4O002F012O00124O002F012O00654O002F012O00694O002F012O00684O002F012O00044O002F012O00644O002F012O00674O002F012O001D4O002F012O001C4O002F012O00194O002F012O00714O002F012O00754O002F012O00774O002F012O00784O002F012O00794O002F012O00584O002F012O00764O002F012O00474O002F012O005E4O002F012O00484O002F012O005B4O002F012O000A4O002F012O00724O002F012O00744O002F012O00494O002F012O00574O002F012O00463O0006E6007D0015000100032O002F012O006B4O002F012O00104O00AB7O002018017E0010006800122O007F00696O0080007C6O0081007D6O007E008100016O00013O00163O00093O00030B3O0028E8B5BFBAB8840FFFABB503073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65025O0016B140025O0022AD4003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD70901803173O00018DAC5C01841D112788BA6F119A02150181BD59028E0203083O007045E4DF2C64E87100194O002A019O000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000C000100010004783O000C0001002E5A00040018000100050004783O001800012O00AB3O00024O0079000100013O00122O000200063O00122O000300076O0001000300024O000200026O000300013O00122O000400083O00122O000500096O0003000500024O0002000200036O000100022O00943O00019O003O00034O00AB8O007D3O000100012O00943O00017O00033O0003093O0061DE3AC60149E327DE03053O006427AC55BC03103O005265676973746572496E466C6967687400094O001B9O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O000200016O00017O000A3O00028O00025O004AB340025O00B49440025O00E4A640025O002EB040025O00388240025O00A06040024O0080B3C540026O00F03F026O007B4000253O0012533O00014O003O0100013O0026483O0006000100010004783O00060001002E5A00020002000100030004783O00020001001253000100013O0026480001000B000100010004783O000B0001002EE80005001A000100040004783O001A0001001253000200013O002E5A00070015000100060004783O001500010026D900020015000100010004783O00150001001253000300084O00A000035O001253000300084O00A0000300013O001253000200093O0026D90002000C000100090004783O000C0001001253000100093O0004783O001A00010004783O000C0001002EAD000A00EDFF2O000A0004783O000700010026D900010007000100090004783O00070001001253000200014O00A0000200023O0004783O002400010004783O000700010004783O002400010004783O000200012O00943O00017O00123O00028O00025O00C09640025O0080B040026O00F03F025O00889A40025O00A0A240025O002EA540025O00C8AD40025O00508740025O0046A240025O0074A740025O00F08B4000030C3O004973496E426F2O734C69737403053O004C6576656C025O00405240025O00809540025O00209040013D3O001253000100014O002O010200033O002E5A00020034000100030004783O003400010026D900010034000100040004783O003400010026480002000A000100010004783O000A0001002E5A00060006000100050004783O00060001001253000300013O0026D90003000B000100010004783O000B0001001253000400014O002O010500053O002EE80007000F000100080004783O000F00010026D90004000F000100010004783O000F0001001253000500013O00264800050018000100010004783O00180001002E5A000A0014000100090004783O00140001001253000600013O002E5A000C00190001000B0004783O00190001000E7E00010019000100060004783O001900010026483O00200001000D0004783O002000010004783O002100012O00AB7O00200A00073O000E2O00190107000200020006630007002A00013O0004783O002A000100200A00073O000F2O00190107000200020026A90007002A000100100004783O002A00012O009700076O0036000700014O0028010700023O0004783O001900010004783O001400010004783O000B00010004783O000F00010004783O000B00010004783O003C00010004783O000600010004783O003C000100264800010038000100010004783O00380001002E5A00110002000100120004783O00020001001253000200014O002O010300033O001253000100043O0004783O000200012O00943O00017O00073O00030B3O0042752O6652656D61696E7303123O0046696E676572736F6646726F737442752O66030D3O00446562752O6652656D61696E7303123O0057696E746572734368692O6C446562752O6603093O0046726F73746269746503063O0046722O657A6503093O0046726F73744E6F7661001D4O00909O00000100013O00202O0001000100014O000300023O00202O0003000300024O0001000300024O000200033O00202O0002000200034O000400023O00202O0004000400042O000B0002000400022O0043000300033O00202O0003000300034O000500023O00202O0005000500054O0003000500024O000400033O00202O0004000400034O000600023O00202O0006000600064O0004000600022O00AB000500033O0020340005000500034O000700023O00202O0007000700074O000500079O009O008O00017O00113O00028O00025O00F6A240026O00F03F025O0046AB40025O0082AA40025O005AAE40025O00D8B04003053O007061697273030B3O00446562752O66537461636B03123O0057696E746572734368692O6C446562752O66025O002OA040025O00689B40025O00E8B140025O0090A94003123O008AD02E58B8CB336FB5D02C4099DC2259BBDF03043O002CDDB940030F3O0041757261416374697665436F756E7401523O001253000100014O002O010200033O002EAD00020049000100020004783O004B00010026D90001004B000100030004783O004B0001001253000400014O002O010500053O0026D900040008000100010004783O00080001001253000500013O0026D90005000B000100010004783O000B0001002EE800050029000100040004783O00290001000E7E00030029000100020004783O00290001001253000600014O002O010700073O0026D900060013000100010004783O00130001001253000700013O000EFF0001001A000100070004783O001A0001002EE800070016000100060004783O001600010012C7000800084O002F01096O006A00080002000A0004783O0023000100200A000D000C00092O00AB000F5O002024000F000F000A2O000B000D000F00022O000701030003000D0006150008001E000100020004783O001E00012O0028010300023O0004783O001600010004783O002900010004783O001300010026480002002D000100010004783O002D0001002EE8000B00060001000C0004783O00060001001253000600013O0026D900060032000100030004783O00320001001253000200033O0004783O0006000100264800060036000100010004783O00360001002E5A000D002E0001000E0004783O002E00012O00AB00076O000E010800013O00122O0009000F3O00122O000A00106O0008000A00024O00070007000800202O0007000700114O00070002000200262O00070042000100010004783O00420001001253000700014O0028010700023O001253000300013O001253000600033O0004783O002E00010004783O000600010004783O000B00010004783O000600010004783O000800010004783O000600010004783O005100010026D900010002000100010004783O00020001001253000200014O002O010300033O001253000100033O0004783O000200012O00943O00017O00023O00030B3O00446562752O66537461636B03123O0057696E746572734368692O6C446562752O6601063O00200900013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030A3O00446562752O66446F776E03123O0057696E746572734368692O6C446562752O6601063O00200900013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00593O00028O00025O004C9040025O00CCAB40026O00F03F030D3O0083CB08E8CAAFD3D5ABC408C5D103083O0081CAA86DABA5C3B7030B3O004973417661696C61626C65030E3O000B5B32FBD118E2035A3ED4D700FF03073O0086423857B8BE74030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030E3O00496365436F6C644162696C69747903143O0035320C841AE42D317C350CBD1CE5323C2A3449E803083O00555C5169DB798B41025O00C0514003083O00D4B0556770D0FEB803063O00BF9DD330251C03073O004973526561647903083O00496365426C6F636B03153O00D61CF12338D310F7177ADB1AF21934CC16E2197A8B03053O005ABF7F947C027O0040025O00D2A540026O00084003093O00315A978E941AA4FD1503083O00907036E3EBE64ECD025O00888140025O00788C4003093O00416C74657254696D6503163O00B2241BF9C264A72102F9905FB62E0AF2C352A52D4FAB03063O003BD3486F9CB0030B3O006682E2215A8FF0394189E603043O004D2EE783030B3O004865616C746873746F6E6503153O00B251B74CAE5CA554B55AB300BE51B045B447BF56BF03043O0020DA34D6026O001040025O00288540025O002FB040030A3O0028E44D7D7213F5415A6103053O00136187283F03083O0042752O66446F776E030A3O0049636542612O7269657203173O00A75F36042D30BC4E3A3E3D71AA59353E2122A74A367B7E03063O0051CE3C535B4F025O0046B140025O00E8A140030B3O0063AAC3610DC25FB647AEC203083O00C42ECBB0124FA32D031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030B3O004D612O7342612O7269657203183O00B5236D0D1BF9EEAA30771B36BBEBBD247B1037F2F9BD622C03073O008FD8421E7E449B030B3O00558E3C057795071A79802B03043O007718E74E025O0074AA40025O00F8A340030B3O004D692O726F72496D61676503183O008F24B758D3522E8B20A44DD90015872BA044CF4907876DF003073O0071E24DC52ABC2003133O001D04F1B42E13E69C3400FDA63314FDB93302ED03043O00D55A7694025O0044B340025O00308C4003133O0047726561746572496E7669736962696C69747903203O005C3CB157595E3C8B5F434D27A75F4F5222BD42541B2AB15048553DBD40481B7803053O002D3B4ED436025O00707F40025O00449640025O0007B34003193O007C1237BAF4A34D5340107180F4B1495340107198FEA44C554003083O003A2E7751C891D02503173O00198936BEACAE3E22823784ACBC3A2282379CA6A93F248203073O00564BEC50CCC9DD025O00A6A340025O00D0A14003173O0052656672657368696E674865616C696E67506F74696F6E03233O0060447197FB987A487982BE8377407B8CF08C32517891F7847C017380F88E7C527E93FB03063O00EB122117E59E025O0080A740031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O00707240025O0038884003193O0074A8C4BA5DADC0B75BBFD3A878BFC0B759B4C68B5FAEC8B45E03043O00DB30DAA1025O00DCB240025O0096A74003253O00E0637948D658E1E87A795BC80FE8E12O7040D548A0F47E6840D441A0E0747A4CD55CE9F27403073O008084111C29BB2F0080012O0012533O00013O002E5A0002004E000100030004783O004E00010026D93O004E000100040004783O004E00012O00AB00016O0089000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002D00013O0004783O002D00012O00AB00016O0089000200013O00122O000300083O00122O000400096O0002000400024O00010001000200202O00010001000A4O00010002000200062O0001002D00013O0004783O002D00012O00AB000100023O0006630001002D00013O0004783O002D00012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200043O00069F0001002D000100020004783O002D00012O00AB000100054O00AB00025O00202400020002000C2O00192O01000200020006630001002D00013O0004783O002D00012O00AB000100013O0012530002000D3O0012530003000E4O003E000100034O00D300015O002EAD000F00200001000F0004783O004D00012O00AB00016O0089000200013O00122O000300103O00122O000400116O0002000400024O00010001000200202O0001000100124O00010002000200062O0001004D00013O0004783O004D00012O00AB000100063O0006630001004D00013O0004783O004D00012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200073O00069F0001004D000100020004783O004D00012O00AB000100054O00AB00025O0020240002000200132O00192O01000200020006630001004D00013O0004783O004D00012O00AB000100013O001253000200143O001253000300154O003E000100034O00D300015O0012533O00163O002EAD00170043000100170004783O009100010026D93O0091000100180004783O009100012O00AB00016O0089000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200202O0001000100124O00010002000200062O0001006500013O0004783O006500012O00AB000100083O0006630001006500013O0004783O006500012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200093O0006132O010003000100020004783O00670001002EE8001C00720001001B0004783O007200012O00AB000100054O00AB00025O00202400020002001D2O00192O01000200020006630001007200013O0004783O007200012O00AB000100013O0012530002001E3O0012530003001F4O003E000100034O00D300016O00AB0001000A4O0089000200013O00122O000300203O00122O000400216O0002000400024O00010001000200202O0001000100124O00010002000200062O0001009000013O0004783O009000012O00AB0001000B3O0006630001009000013O0004783O009000012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB0002000C3O00069F00010090000100020004783O009000012O00AB000100054O00AB0002000D3O0020240002000200222O00192O01000200020006630001009000013O0004783O009000012O00AB000100013O001253000200233O001253000300244O003E000100034O00D300015O0012533O00253O0026483O0095000100010004783O00950001002E5A002700E3000100260004783O00E300012O00AB00016O0089000200013O00122O000300283O00122O000400296O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100BA00013O0004783O00BA00012O00AB0001000E3O000663000100BA00013O0004783O00BA00012O00AB000100033O00208600010001002A4O00035O00202O00030003002B4O00010003000200062O000100BA00013O0004783O00BA00012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB0002000F3O00069F000100BA000100020004783O00BA00012O00AB000100054O00AB00025O00202400020002002B2O00192O0100020002000663000100BA00013O0004783O00BA00012O00AB000100013O0012530002002C3O0012530003002D4O003E000100034O00D300015O002EE8002F00E20001002E0004783O00E200012O00AB00016O0089000200013O00122O000300303O00122O000400316O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100E200013O0004783O00E200012O00AB000100103O000663000100E200013O0004783O00E200012O00AB000100033O00208600010001002A4O00035O00202O00030003002B4O00010003000200062O000100E200013O0004783O00E200012O00AB000100113O0020170001000100324O000200123O00122O000300166O00010003000200062O000100E200013O0004783O00E200012O00AB000100054O00AB00025O0020240002000200332O00192O0100020002000663000100E200013O0004783O00E200012O00AB000100013O001253000200343O001253000300354O003E000100034O00D300015O0012533O00043O0026D93O00262O0100160004783O00262O012O00AB00016O0089000200013O00122O000300363O00122O000400376O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100F800013O0004783O00F800012O00AB000100133O000663000100F800013O0004783O00F800012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200143O0006132O010003000100020004783O00FA0001002E5A003800052O0100390004783O00052O012O00AB000100054O00AB00025O00202400020002003A2O00192O0100020002000663000100052O013O0004783O00052O012O00AB000100013O0012530002003B3O0012530003003C4O003E000100034O00D300016O00AB00016O0089000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200202O0001000100124O00010002000200062O000100182O013O0004783O00182O012O00AB000100153O000663000100182O013O0004783O00182O012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200163O0006132O010003000100020004783O001A2O01002EE8003F00252O0100400004783O00252O012O00AB000100054O00AB00025O0020240002000200412O00192O0100020002000663000100252O013O0004783O00252O012O00AB000100013O001253000200423O001253000300434O003E000100034O00D300015O0012533O00183O0026D93O0001000100250004783O000100012O00AB000100173O000663000100312O013O0004783O00312O012O00AB000100033O00200A00010001000B2O00192O01000200022O00AB000200183O0006132O010003000100020004783O00332O01002E5A0045007F2O0100440004783O007F2O01001253000100014O002O010200023O0026D9000100352O0100010004783O00352O01001253000200013O0026D9000200382O0100010004783O00382O01002EAD00460020000100460004783O005A2O012O00AB000300194O004C000400013O00122O000500473O00122O000600486O00040006000200062O0003005A2O0100040004783O005A2O012O00AB0003000A4O0089000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400202O0003000300124O00030002000200062O0003005A2O013O0004783O005A2O01002EE8004C005A2O01004B0004783O005A2O012O00AB000300054O00AB0004000D3O00202400040004004D2O00190103000200020006630003005A2O013O0004783O005A2O012O00AB000300013O0012530004004E3O0012530005004F4O003E000300054O00D300035O002EAD00500006000100500004783O00602O012O00AB000300193O002648000300602O0100510004783O00602O010004783O007F2O01002EE80052007F2O0100530004783O007F2O012O00AB0003000A4O0089000400013O00122O000500543O00122O000600556O0004000600024O00030003000400202O0003000300124O00030002000200062O0003007F2O013O0004783O007F2O012O00AB000300054O00AB0004000D3O00202400040004004D2O0019010300020002000630000300742O0100010004783O00742O01002E5A0056007F2O0100570004783O007F2O012O00AB000300013O00128F000400583O00122O000500596O000300056O00035O00044O007F2O010004783O00382O010004783O007F2O010004783O00352O010004783O007F2O010004783O000100012O00943O00017O000A3O00025O001AA240025O00CCA040030B3O0033370B354B041113284E0403053O003D6152665A03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00344003103O0052656D6F76654375727365466F63757303133O00BE2BA644D152210AB93CB84E8753171ABC2BA703083O0069CC4ECB2BA7377E00213O002E5A00020020000100010004783O002000012O00AB8O0089000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002000013O0004783O002000012O00AB3O00023O0006633O002000013O0004783O002000012O00AB3O00033O0020245O0006001253000100074O0019012O000200020006633O002000013O0004783O002000012O00AB3O00044O00AB000100053O0020240001000100082O0019012O000200020006633O002000013O0004783O002000012O00AB3O00013O001253000100093O0012530002000A4O003E3O00024O00D38O00943O00017O00103O00028O00025O0098A840025O00188740025O00E0B140025O003AB240026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O0006AE40025O00ACA740025O00B4A340025O00C09840025O005AA94003103O0048616E646C65546F705472696E6B6574025O006AB140025O0014A74000453O0012533O00014O003O0100013O0026483O0006000100010004783O00060001002EAD000200FEFF2O00030004783O00020001001253000100013O002EE80004001B000100050004783O001B00010026D90001001B000100060004783O001B00012O00AB000200013O00201D0102000200074O000300026O000400033O00122O000500086O000600066O0002000600024O00028O00025O00062O00020018000100010004783O00180001002EAD0009002E0001000A0004783O004400012O00AB00026O0028010200023O0004783O004400010026D900010007000100010004783O00070001001253000200013O0026D900020022000100060004783O00220001001253000100063O0004783O00070001002EE8000C001E0001000B0004783O001E00010026D90002001E000100010004783O001E0001001253000300013O002EAD000D00060001000D0004783O002D00010026D90003002D000100060004783O002D0001001253000200063O0004783O001E00010026D900030027000100010004783O002700012O00AB000400013O00201D01040004000E4O000500026O000600033O00122O000700086O000800086O0004000800024O00048O00045O00062O0004003C000100010004783O003C0001002E5A000F003E000100100004783O003E00012O00AB00046O0028010400023O001253000300063O0004783O002700010004783O001E00010004783O000700010004783O004400010004783O000200012O00943O00017O001C3O00030D3O00546172676574497356616C6964028O00025O0040A040025O00307D40026O00F03F026O004D40025O00508340025O00D88B40025O008EAC40030B3O0088A3310C1C16EE5CA4AD2603083O0031C5CA437E7364A7030A3O0049734361737461626C65025O00BFB040025O004CAC40030B3O004D692O726F72496D61676503183O003A52CD3B8F44613E56DE2E85164E255EDC268D545F231B8D03073O003E573BBF49E036026O004140025O0012A44003093O00C110F5DAF300F5C5F303043O00A987629A03093O00497343617374696E6703093O0046726F7374626F6C74030E3O0049735370652O6C496E52616E6765025O0078A640025O00AC944003153O00CD652B47E9312OC7636444EF36CBC47A2655E9739C03073O00A8AB1744349D5300634O00AB7O0020245O00012O00FC3O000100020006633O006200013O0004783O006200010012533O00024O003O0100023O0026483O000B000100020004783O000B0001002E5A0003000E000100040004783O000E0001001253000100024O002O010200023O0012533O00053O0026D93O0007000100050004783O00070001002EE800060010000100070004783O001000010026D900010010000100020004783O00100001001253000200023O00264800020019000100020004783O00190001002EE800090015000100080004783O001500012O00AB000300014O0089000400023O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003002900013O0004783O002900012O00AB000300033O0006630003002900013O0004783O002900012O00AB000300043O0006300003002B000100010004783O002B0001002EE8000D00360001000E0004783O003600012O00AB000300054O00AB000400013O00202400040004000F2O00190103000200020006630003003600013O0004783O003600012O00AB000300023O001253000400103O001253000500114O003E000300054O00D300035O002E5A00120062000100130004783O006200012O00AB000300014O0089000400023O00122O000500143O00122O000600156O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006200013O0004783O006200012O00AB000300063O0020060103000300164O000500013O00202O0005000500174O00030005000200062O00030062000100010004783O006200012O00AB000300054O0076000400013O00202O0004000400174O000500073O00202O0005000500184O000700013O00202O0007000700174O0005000700024O000500056O00030005000200062O00030057000100010004783O00570001002EAD0019000D0001001A0004783O006200012O00AB000300023O00128F0004001B3O00122O0005001C6O000300056O00035O00044O006200010004783O001500010004783O006200010004783O001000010004783O006200010004783O000700012O00943O00017O00553O00028O00025O00B89F4003083O00C078F8A8122C95E403073O00E7941195CD454D030A3O0049734361737461626C6503123O00426C2O6F646C757374457868617573745570030C3O00B4A2CAEB58ED81ABF0FA45EF03063O009FE0C7A79B37030B3O004973417661696C61626C65030D3O00426C2O6F646C757374446F776E03083O005072657647434450026O00F03F03083O004963795665696E7303083O0054696D655761727003093O004973496E52616E6765026O004440030E3O00E3FA31D7C8E43DC0E7B33FD6B7A103043O00B297935C030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030C3O004963795665696E7342752O66025O00E09F40025O00508540027O0040025O00D07040025O009CA240025O00208A40025O0024B040025O005AA740025O009C904003083O00A5FE55041745749F03073O001AEC9D2C52722C025O00CCA240025O002AA940030E3O00232DCC643C2BDC55396ED65F6A7803043O003B4A4EB5025O00DEAB40025O006BB140025O00109D40025O0022A040025O0096A040025O001EB340025O0046AC40025O00A8A040025O000EAA4003093O0007DD2O55B703C4484303053O00D345B12O3A025O007DB140025O0022AC4003093O00426C2O6F6446757279025O002CAB40025O0068824003103O00B5E976FAEDF4B1F06BECA9C8B3A528A503063O00ABD785199589030A3O00C3CD20E9EA22F74BEFCF03083O002281A8529A8F509C025O00109B40025O00406040030A3O004265727365726B696E6703103O0087B721184D5C828CBC342O4B4AC9D4E003073O00E9E5D2536B282E025O00188B40025O001EA940030D3O0014BA88F7C921A68AFEF934B88703053O00BA55D4EB92025O00C88440025O00BDB140030D3O00416E6365737472616C43612O6C03143O00C38F15FB2AFA4AC38D29FD38E2542O8212BE68B603073O0038A2E1769E598E025O00049140025O00FEAA40030E3O00ED4B35DE11D26827D202CC473CC203053O0065A12252B6025O0084AB40025O00C4A040030E3O004C69676874734A7564676D656E74030E3O0049735370652O6C496E52616E676503153O00E4045EF6CFF1BD24FD095EF3DEEC966EEB0919AF8F03083O004E886D399EBB82E203093O001836EBF43C33F6FE3A03043O00915E5F9903093O0046697265626C2O6F64030F3O00FBC406D04CBBF2C210954DB3BD9C4203063O00D79DAD74B52E0074012O0012533O00014O003O0100013O002EAD00020047000100020004783O00490001000E7E0001004900013O0004783O004900012O00AB00025O0006630002003F00013O0004783O003F00012O00AB000200014O0089000300023O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002003F00013O0004783O003F00012O00AB000200033O00200A0002000200062O00190102000200020006630002003F00013O0004783O003F00012O00AB000200014O0089000300023O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002003F00013O0004783O003F00012O00AB000200033O00200A00020002000A2O00190102000200020006630002003F00013O0004783O003F00012O00AB000200033O00207200020002000B00122O0004000C6O000500013O00202O00050005000D4O00020005000200062O0002003F00013O0004783O003F00012O00AB000200044O005C000300013O00202O00030003000E4O000400053O00202O00040004000F00122O000600106O0004000600024O000400046O00020004000200062O0002003F00013O0004783O003F00012O00AB000200023O001253000300113O001253000400124O003E000200044O00D300026O00AB000200063O00200C0102000200134O000300033O00202O0003000300144O000500013O00202O0005000500154O000300056O00023O00024O000100023O00124O000C3O0026483O004D0001000C0004783O004D0001002EAD00160042000100170004783O008D0001001253000200013O000E7E000C0052000100020004783O005200010012533O00183O0004783O008D000100264800020056000100010004783O00560001002EE8001A004E000100190004783O004E0001001253000300013O0026D900030085000100010004783O00850001002EE8001B005E0001001C0004783O005E00010006630001005E00013O0004783O005E00012O00282O0100023O002E5A001E00840001001D0004783O008400012O00AB000400014O0089000500023O00122O0006001F3O00122O000700206O0005000700024O00040004000500202O0004000400054O00040002000200062O0004008400013O0004783O008400012O00AB000400073O0006630004008400013O0004783O008400012O00AB000400083O0006630004008400013O0004783O008400012O00AB000400093O0006630004008400013O0004783O008400012O00AB0004000A4O00AB0005000B3O00061201040084000100050004783O00840001002E5A00210084000100220004783O008400012O00AB000400044O00AB000500013O00202400050005000D2O00190104000200020006630004008400013O0004783O008400012O00AB000400023O001253000500233O001253000600244O003E000400064O00D300045O0012530003000C3O002EE800250057000100260004783O005700010026D9000300570001000C0004783O005700010012530002000C3O0004783O004E00010004783O005700010004783O004E00010026483O0091000100180004783O00910001002E5A00280002000100270004783O000200012O00AB0002000A4O00AB0003000B3O00069F00030096000100020004783O009600010004783O00B700012O00AB0002000C3O000663000200B700013O0004783O00B700012O00AB000200073O0006630002009F00013O0004783O009F00012O00AB0002000D3O000630000200A2000100010004783O00A200012O00AB0002000D3O000630000200B7000100010004783O00B70001001253000200014O002O010300033O0026D9000200A4000100010004783O00A40001001253000300013O0026D9000300A7000100010004783O00A700012O00AB0004000F4O00FC0004000100022O00A00004000E4O00AB0004000E3O000630000400B1000100010004783O00B10001002E5A002A00B7000100290004783O00B700012O00AB0004000E4O0028010400023O0004783O00B700010004783O00A700010004783O00B700010004783O00A40001002EAD002B00BC0001002B0004783O00732O012O00AB000200103O000663000200732O013O0004783O00732O012O00AB000200113O000663000200C200013O0004783O00C200012O00AB000200073O000630000200C5000100010004783O00C500012O00AB000200113O000630000200732O0100010004783O00732O012O00AB0002000A4O00AB0003000B3O000612010200732O0100030004783O00732O01001253000200014O002O010300033O0026D9000200CB000100010004783O00CB0001001253000300013O0026D90003000B2O0100010004783O000B2O01001253000400013O002EE8002C00062O01002D0004783O00062O01000E7E000100062O0100040004783O00062O012O00AB000500014O002E010600023O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O0005000500054O00050002000200062O000500E1000100010004783O00E10001002E5A003000EE000100310004783O00EE00012O00AB000500044O00AB000600013O0020240006000600322O0019010500020002000630000500E9000100010004783O00E90001002EAD00330007000100340004783O00EE00012O00AB000500023O001253000600353O001253000700364O003E000500074O00D300056O00AB000500014O0089000600023O00122O000700373O00122O000800386O0006000800024O00050005000600202O0005000500054O00050002000200062O000500052O013O0004783O00052O01002E5A003A00052O0100390004783O00052O012O00AB000500044O00AB000600013O00202400060006003B2O0019010500020002000663000500052O013O0004783O00052O012O00AB000500023O0012530006003C3O0012530007003D4O003E000500074O00D300055O0012530004000C3O0026D9000400D10001000C0004783O00D100010012530003000C3O0004783O000B2O010004783O00D100010026480003000F2O0100180004783O000F2O01002EE8003F00272O01003E0004783O00272O012O00AB000400014O0089000500023O00122O000600403O00122O000700416O0005000700024O00040004000500202O0004000400054O00040002000200062O000400732O013O0004783O00732O01002E5A004200732O0100430004783O00732O012O00AB000400044O00AB000500013O0020240005000500442O0019010400020002000663000400732O013O0004783O00732O012O00AB000400023O00128F000500453O00122O000600466O000400066O00045O00044O00732O01002E5A004700CE000100480004783O00CE00010026D9000300CE0001000C0004783O00CE0001001253000400013O0026D9000400302O01000C0004783O00302O01001253000300183O0004783O00CE00010026D90004002C2O0100010004783O002C2O01001253000500013O000E7E000C00372O0100050004783O00372O010012530004000C3O0004783O002C2O01000E7E000100332O0100050004783O00332O012O00AB000600014O002E010700023O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O0006000600054O00060002000200062O000600452O0100010004783O00452O01002EE8004B00562O01004C0004783O00562O012O00AB000600044O00EB000700013O00202O00070007004D4O000800053O00202O00080008004E4O000A00013O00202O000A000A004D4O0008000A00024O000800086O00060008000200062O000600562O013O0004783O00562O012O00AB000600023O0012530007004F3O001253000800504O003E000600084O00D300066O00AB000600014O0089000700023O00122O000800513O00122O000900526O0007000900024O00060006000700202O0006000600054O00060002000200062O0006006B2O013O0004783O006B2O012O00AB000600044O00AB000700013O0020240007000700532O00190106000200020006630006006B2O013O0004783O006B2O012O00AB000600023O001253000700543O001253000800554O003E000600084O00D300065O0012530005000C3O0004783O00332O010004783O002C2O010004783O00CE00010004783O00732O010004783O00CB00010004783O00732O010004783O000200012O00943O00017O00383O00028O00026O00F03F025O0046AB40025O0074A940030F3O006558CD743E416FD6653C4B59C77A3E03053O0050242AAE15030A3O0049734361737461626C65030E3O004D616E6150657263656E74616765026O003E40027O0040025O0061B140025O0078AC40030F3O00417263616E654578706C6F73696F6E03093O004973496E52616E6765025O00206340025O007C9D4003193O004F02347B4015087F56003B755D1938740E1D386C4B1D32745A03043O001A2E7057025O00949B40026O00844003093O009F2AB9719DB344A7AD03083O00D4D943CB142ODF25030C3O0055736546697265626C617374026O006940025O00B6AF4003093O0046697265426C617374030E3O0049735370652O6C496E52616E676503133O00BC84BAD7858FA4D3A999E8DFB59BADDFBF83BC03043O00B2DAEDC8025O0014A940025O00E09540025O00909540025O002EAE4003083O009FB6E3FCB7BBE5D503043O00B0D6D58603083O004963654C616E636503123O00FDAEB3EBA42O57F7A8F6D9A7405CF9A8B8C003073O003994CDD6B4C836025O00E06640025O001AAA4003083O007506C5892ED7591603063O00B83C65A0CF4203083O0042752O66446F776E03083O00496365466C6F6573025O00A07A40025O0098A94003123O0038817983378E73B922C271B3278771B93F9603043O00DC51E21C03073O003AD687D5E5D11203063O00A773B5E29B8A025O0010AC40025O00F8AF4003073O004963654E6F766103113O00EB21E263757ED0E362EA536D74CBE72CF303073O00A68242873C1B11025O0068AA4000E53O0012533O00014O003O0100023O000E7E000200DC00013O0004783O00DC00010026D900010004000100010004783O00040001001253000200013O0026D900020061000100020004783O00610001001253000300013O0026480003000E000100010004783O000E0001002E5A0003005A000100040004783O005A00012O00AB00046O0089000500013O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400074O00040002000200062O0004002300013O0004783O002300012O00AB000400023O0006630004002300013O0004783O002300012O00AB000400033O00200A0004000400082O0019010400020002000E0F01090023000100040004783O002300012O00AB000400043O000ECD000A0025000100040004783O00250001002EE8000B00370001000C0004783O003700012O00AB000400054O00BF00055O00202O00050005000D4O000600063O00202O00060006000E00122O000800096O0006000800024O000600066O00040006000200062O00040032000100010004783O00320001002E5A001000370001000F0004783O003700012O00AB000400013O001253000500113O001253000600124O003E000400064O00D300045O002EE800140059000100130004783O005900012O00AB00046O0089000500013O00122O000600153O00122O000700166O0005000700024O00040004000500202O0004000400074O00040002000200062O0004005900013O0004783O005900010012C7000400173O0006630004005900013O0004783O00590001002EE800180059000100190004783O005900012O00AB000400054O00EB00055O00202O00050005001A4O000600063O00202O00060006001B4O00085O00202O00080008001A4O0006000800024O000600066O00040006000200062O0004005900013O0004783O005900012O00AB000400013O0012530005001C3O0012530006001D4O003E000400064O00D300045O001253000300023O000EFF0002005E000100030004783O005E0001002E5A001E000A0001001F0004783O000A00010012530002000A3O0004783O006100010004783O000A0001000E7E000A0084000100020004783O00840001002EE8002000E4000100210004783O00E400012O00AB00036O0089000400013O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300074O00030002000200062O000300E400013O0004783O00E400012O00AB000300073O000663000300E400013O0004783O00E400012O00AB000300054O00EB00045O00202O0004000400244O000500063O00202O00050005001B4O00075O00202O0007000700244O0005000700024O000500056O00030005000200062O000300E400013O0004783O00E400012O00AB000300013O00128F000400253O00122O000500266O000300056O00035O00044O00E400010026D900020007000100010004783O00070001001253000300014O002O010400043O002E5A00270088000100280004783O00880001000E7E00010088000100030004783O00880001001253000400013O0026D9000400D1000100010004783O00D100012O00AB00056O0089000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O0005000500074O00050002000200062O000500B000013O0004783O00B000012O00AB000500083O000663000500B000013O0004783O00B000012O00AB000500033O00208600050005002B4O00075O00202O00070007002C4O00050007000200062O000500B000013O0004783O00B000012O00AB000500054O00AB00065O00202400060006002C2O0019010500020002000630000500AB000100010004783O00AB0001002EE8002E00B00001002D0004783O00B000012O00AB000500013O0012530006002F3O001253000700304O003E000500074O00D300056O00AB00056O0089000600013O00122O000700313O00122O000800326O0006000800024O00050005000600202O0005000500074O00050002000200062O000500BD00013O0004783O00BD00012O00AB000500093O000630000500BF000100010004783O00BF0001002EAD00330013000100340004783O00D000012O00AB000500054O00EB00065O00202O0006000600354O000700063O00202O00070007001B4O00095O00202O0009000900354O0007000900024O000700076O00050007000200062O000500D000013O0004783O00D000012O00AB000500013O001253000600363O001253000700374O003E000500074O00D300055O001253000400023O0026D90004008D000100020004783O008D0001001253000200023O0004783O000700010004783O008D00010004783O000700010004783O008800010004783O000700010004783O00E400010004783O000400010004783O00E40001002EAD00380026FF2O00380004783O000200010026D93O0002000100010004783O00020001001253000100014O002O010200023O0012533O00023O0004783O000200012O00943O00017O00CD3O00028O00025O00E9B240025O00F5B140026O00104003093O009E67EDE699BA7AEEE103053O00EDD8158295030A3O0049734361737461626C65025O00F4AE4003093O0046726F7374626F6C74030E3O0049735370652O6C496E52616E676503103O00845C504CA4CB518E5A1F5EBFCC1ED11C03073O003EE22E2O3FD0A903083O0049734D6F76696E67025O00E2A740025O006AA040026O00F03F025O0012AF40025O0050B240025O00308840025O00707C40026O008A40025O0056A240025O00389E40025O00B2A540027O0040025O00E08240025O003DB240026O000840025O0050A040025O00B6A240030D3O00C0E751D0315FFDE868D93253E103063O0036938F38B645025O00209F40025O0074A440030D3O005368696674696E67506F77657203093O004973496E52616E6765026O00444003153O00C589F64FCBDF8FF876CFD996FA5B9FD78EFA098E8003053O00BFB6E19F29030C3O000C1E29568286CE1802215E8E03073O00A24B724835EBE703073O0049735265616479026O00144003083O00AE304DF849039E3803063O0062EC5C248233030F3O00432O6F6C646F776E52656D61696E73030C3O00476C616369616C5370696B65025O00ECA940025O00207A4003143O00A3150DB94CA9B90FB70905B140E8B43FA1595DE203083O0050C4796CDA25C8D503063O00267F176D591703073O00EA6013621F2B6E03083O00507265764743445003063O00201347D5BE6B03073O00EB667F32A7CC1203113O00436861726765734672616374696F6E616C02CD5OCCFC3F03063O00466C752O7279030D3O0056ADE031563710A0FA26047C0003063O004E30C195432403063O001612950A532903053O0021507EE07803063O0042752O665570030F3O00427261696E46722O657A6542752O6603123O0046696E676572736F6646726F737442752O66025O00C6AF40025O00D2A340025O0049B040025O00B8AF40030D3O00EAA416D64EF5E802CB59ACFA5203053O003C8CC863A4025O00805540025O00F0824003093O001E1402FE2C2802FB3903043O008D58666D030B3O00507265764F2O664743445003063O0046722O657A65030A3O00905CC475153B76CEBF5703083O00A1D333AA107A5D35030A3O00432O6F6C646F776E557003093O0042752O66537461636B030D3O00536E6F7773746F726D42752O6603093O0046726F73744E6F766103113O00FDBCBD3BEF91BC27EDAFF229F4ABF279A903043O00489BCED2030A3O0065755A0B3C40595B023703053O0053261A346E030A3O0042752O66537461636B50025O00206340025O002AA340030A3O00436F6E656F66436F6C6403133O005B182943671821795B182B421816284318467303043O0026387747025O00E8A440025O0083B040025O00B07140025O000EA64003083O00497341637469766503063O003DFF8354F73803073O00597B8DE6318D5D030C3O00D47DF70F194BFF42E6051B4F03063O002A9311966C70030B3O004973417661696C61626C6503093O003CA82268F4FC00B42003063O00886FC64D1F87030A3O002106A953B2E234A60E0D03083O00C96269C736DD8477025O0092B040025O00E0764003093O0046722O657A65506574030D3O00BF1E86241830ECB8038661536503073O00CCD96CE341625503073O0077C0F0CB23D65F03063O00A03EA395854C030A3O00F5AF032ACCD0830223C703053O00A3B6C06D4F025O0068B24003073O004963654E6F7661030F3O003D2505FFFB3B300180F43B234091A403053O0095544660A0025O000EAA40025O0060A740025O00289740025O00D0964003083O00302C3166A675002403063O00147240581CDC030E3O00426C692O7A617264437572736F72030E3O00330DDBAEE2D1AF3541D3BBFD90EB03073O00DD5161B2D498B0030A3O00EEE810FE0EFEF312E91703053O007AAD877D9B030B3O00A7CE0CBD3A22DCB7CF01A903073O00A8E4A160D95F51030A3O00F8DE20592051F8DE225803063O0037BBB14E3C4F03093O000BDC50F143C1AF3FCC03073O00E04DAE3F8B26AF026O003940030A3O00A74E562B8B477B21884503043O004EE42138026O003440025O00606540025O0053B240030A3O00436F6D657453746F726D03113O00CD71BF0691F16DA60C97C33EB30C808E2603053O00E5AE1ED263030A3O0031F23B317914DE3A387203053O0016729D5554030B3O00E7C41FC058E5BCF7C512D403073O00C8A4AB73A43D9603093O0046726F7A656E4F7262030A3O009DFB0E40978DE00C578E03053O00E3DE946325025O00FAA040025O00E8B24003123O00305D5CF3C63C546DF5F63F5612F7F636120003053O0099532O329603093O007B647C0676A5624F7403073O002D3D16137C13CB030D3O0046726F7A656E4F72624361737403103O00C70002EF077E86CE000FB5037FBC814603073O00D9A1726D956210025O0058AE40025O00089540025O0040AA40030D3O00CAE5A337E1F9B112FCF2A324E603043O00508E97C2026O001C40025O00E89040026O00A640030D3O00447261676F6E7342726561746803153O0007D4764B0CC8647301D4724D17CE374D0CC3371E5503043O002C63A617030F3O005DE52A373DA159EF393A3CB775F82703063O00C41C97495653030E3O004D616E6150657263656E74616765026O003E40030F3O00417263616E654578706C6F73696F6E025O00ECAD40025O00E8B04003173O00F2112A118C5D2773EB13251F91511778B3022615C20A4003083O001693634970E23878025O002C9140025O0092B24003083O00AEF7010AA389F70103053O00C2E794644603083O006F4FC48FF7C6454903063O00A8262CA1C396030A3O0054726176656C54696D65025O0007B340025O001CB34003083O004963654C616E636503103O0089FF87493CE9B81585BC837935A8E44403083O0076E09CE2165088D603073O006BED5CAE4DF85803043O00E0228E3903093O00EDA92OCA60E5521CD303083O006EBEC7A5BD13913D030C3O00FDE776EB82C6D6D867E180C203063O00A7BA8B1788EB025O00B2A240025O00809940030F3O0013B68D3214BA9E0C5AB487085AE7DB03043O006D7AD5E80064042O0012533O00013O002E5A00030060000100020004783O006000010026D93O0060000100040004783O006000012O00AB00016O0089000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002600013O0004783O002600012O00AB000100023O0006630001002600013O0004783O00260001002EAD00080014000100080004783O002600012O00AB000100034O004F00025O00202O0002000200094O000300043O00202O00030003000A4O00055O00202O0005000500094O0003000500024O000300036O000400016O00010004000200062O0001002600013O0004783O002600012O00AB000100013O0012530002000B3O0012530003000C4O003E000100034O00D300016O00AB000100053O00200A00010001000D2O00192O01000200020006630001006304013O0004783O006304012O00AB000100063O0006630001006304013O0004783O00630401001253000100014O002O010200043O00264800010034000100010004783O00340001002E5A000E00370001000F0004783O00370001001253000200014O002O010300033O001253000100103O0026480001003B000100100004783O003B0001002E5A00120030000100110004783O003000012O002O010400043O00264800020040000100100004783O00400001002EE80013004F000100140004783O004F000100264800030044000100010004783O00440001002EAD001500FEFF2O00160004783O004000012O00AB000500074O00FC0005000100022O002F010400053O0006300004004B000100010004783O004B0001002EAD0017001A040100180004783O006304012O0028010400023O0004783O006304010004783O004000010004783O006304010026D90002003C000100010004783O003C0001001253000500013O0026D900050057000100010004783O00570001001253000300014O002O010400043O001253000500103O0026D900050052000100100004783O00520001001253000200103O0004783O003C00010004783O005200010004783O003C00010004783O006304010004783O003000010004783O00630401000E7E001900452O013O0004783O00452O01001253000100014O002O010200023O00264800010068000100010004783O00680001002EAD001A00FEFF2O001B0004783O00640001001253000200013O0026D90002006D000100190004783O006D00010012533O001C3O0004783O00452O0100264800020071000100010004783O00710001002EE8001E00D50001001D0004783O00D50001001253000300013O0026D9000300D0000100010004783O00D000012O00AB00046O0089000500013O00122O0006001F3O00122O000700206O0005000700024O00040004000500202O0004000400074O00040002000200062O000400A100013O0004783O00A100012O00AB000400083O000663000400A100013O0004783O00A100012O00AB000400093O0006630004008700013O0004783O008700012O00AB0004000A3O0006300004008A000100010004783O008A00012O00AB000400093O000630000400A1000100010004783O00A100012O00AB0004000B4O00AB0005000C3O000612010400A1000100050004783O00A10001002E5A002100A1000100220004783O00A100012O00AB000400034O002401055O00202O0005000500234O000600043O00202O00060006002400122O000800256O0006000800024O000600066O000700016O00040007000200062O000400A100013O0004783O00A100012O00AB000400013O001253000500263O001253000600274O003E000400064O00D300046O00AB00046O0089000500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004002A4O00040002000200062O000400CF00013O0004783O00CF00012O00AB0004000D3O000663000400CF00013O0004783O00CF00012O00AB0004000E3O0026D9000400CF0001002B0004783O00CF00012O00AB00046O00EE000500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O00040004002E4O0004000200024O0005000F3O00062O000500CF000100040004783O00CF00012O00AB000400034O007600055O00202O00050005002F4O000600043O00202O00060006000A4O00085O00202O00080008002F4O0006000800024O000600066O00040006000200062O000400CA000100010004783O00CA0001002EAD00300007000100310004783O00CF00012O00AB000400013O001253000500323O001253000600334O003E000400064O00D300045O001253000300103O0026D900030072000100100004783O00720001001253000200103O0004783O00D500010004783O00720001000E7E00100069000100020004783O006900012O00AB00036O0089000400013O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300074O00030002000200062O0003000E2O013O0004783O000E2O012O00AB000300103O0006630003000E2O013O0004783O000E2O012O00AB000300114O00FC0003000100020006300003000E2O0100010004783O000E2O012O00AB000300123O0026D90003000E2O0100010004783O000E2O012O00AB000300053O0020AF00030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O000300FD000100010004783O00FD00012O00AB00036O0046000400013O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300394O000300020002000E2O003A000E2O0100030004783O000E2O012O00AB000300034O00EB00045O00202O00040004003B4O000500043O00202O00050005000A4O00075O00202O00070007003B4O0005000700024O000500056O00030005000200062O0003000E2O013O0004783O000E2O012O00AB000300013O0012530004003C3O0012530005003D4O003E000300054O00D300036O00AB00036O0089000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003002C2O013O0004783O002C2O012O00AB000300103O0006630003002C2O013O0004783O002C2O012O00AB000300123O0026D90003002C2O0100010004783O002C2O012O00AB000300053O0020060103000300404O00055O00202O0005000500414O00030005000200062O0003002E2O0100010004783O002E2O012O00AB000300053O0020060103000300404O00055O00202O0005000500424O00030005000200062O0003002E2O0100010004783O002E2O01002E5A004300412O0100440004783O00412O012O00AB000300034O007600045O00202O00040004003B4O000500043O00202O00050005000A4O00075O00202O00070007003B4O0005000700024O000500056O00030005000200062O0003003C2O0100010004783O003C2O01002E5A004500412O0100460004783O00412O012O00AB000300013O001253000400473O001253000500484O003E000300054O00D300035O001253000200193O0004783O006900010004783O00452O010004783O006400010026D93O0078020100100004783O00780201001253000100013O000EFF0010004C2O0100010004783O004C2O01002E5A004A00C02O0100490004783O00C02O012O00AB00026O0089000300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200902O013O0004783O00902O012O00AB000200133O000663000200902O013O0004783O00902O012O00AB000200114O00FC000200010002000663000200902O013O0004783O00902O012O00AB000200053O0020AF00020002004D00122O000400106O00055O00202O00050005004E4O00020005000200062O000200902O0100010004783O00902O012O00AB000200053O00207200020002003600122O000400106O00055O00202O00050005002F4O00020005000200062O000200702O013O0004783O00702O012O00AB000200123O002648000200852O0100010004783O00852O012O00AB00026O0089000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200514O00020002000200062O000200902O013O0004783O00902O012O00AB000200053O00201E0002000200524O00045O00202O0004000400534O0002000400024O000300143O00062O000200902O0100030004783O00902O012O00AB0002000F3O002642000200902O0100100004783O00902O012O00AB000200034O00AB00035O0020240003000300542O0019010200020002000663000200902O013O0004783O00902O012O00AB000200013O001253000300553O001253000400564O003E000200044O00D300026O00AB00026O0089000300013O00122O000400573O00122O000500586O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B22O013O0004783O00B22O012O00AB000200153O000663000200B22O013O0004783O00B22O012O00AB000200163O000663000200A32O013O0004783O00A32O012O00AB0002000A3O000630000200A62O0100010004783O00A62O012O00AB000200163O000630000200B22O0100010004783O00B22O012O00AB0002000B4O00AB0003000C3O000612010200B22O0100030004783O00B22O012O00AB000200053O0020230102000200594O00045O00202O0004000400534O0002000400024O000300143O00062O000200B42O0100030004783O00B42O01002E5A005B00BF2O01005A0004783O00BF2O012O00AB000200034O00AB00035O00202400030003005C2O0019010200020002000663000200BF2O013O0004783O00BF2O012O00AB000200013O0012530003005D3O0012530004005E4O003E000200044O00D300025O001253000100193O0026D9000100C42O0100190004783O00C42O010012533O00193O0004783O00780201002648000100C82O0100010004783O00C82O01002E5A006000482O01005F0004783O00482O01001253000200013O0026D9000200CD2O0100100004783O00CD2O01001253000100103O0004783O00482O01002648000200D12O0100010004783O00D12O01002E5A006200C92O0100610004783O00C92O012O00AB000300173O00200A0003000300632O00190103000200020006630003002C02013O0004783O002C02012O00AB000300183O0006630003002C02013O0004783O002C02012O00AB00036O0089000400013O00122O000500643O00122O000600656O0004000600024O00030003000400202O00030003002A4O00030002000200062O0003002C02013O0004783O002C02012O00AB000300114O00FC0003000100020006630003002C02013O0004783O002C02012O00AB000300194O00FC0003000100020026D90003002C020100010004783O002C02012O00AB00036O002E010400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O0003000300684O00030002000200062O000300FF2O0100010004783O00FF2O012O00AB00036O0089000400013O00122O000500693O00122O0006006A6O0004000600024O00030003000400202O0003000300684O00030002000200062O0003001902013O0004783O001902012O00AB000300053O0020AF00030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O00030019020100010004783O001902012O00AB00036O0089000400013O00122O0005006B3O00122O0006006C6O0004000600024O00030003000400202O0003000300514O00030002000200062O0003002C02013O0004783O002C02012O00AB000300053O00201E0003000300524O00055O00202O0005000500534O0003000500024O000400143O00062O0003002C020100040004783O002C0201002EE8006E002C0201006D0004783O002C02012O00AB000300034O00EB0004001A3O00202O00040004006F4O000500043O00202O00050005000A4O00075O00202O00070007004E4O0005000700024O000500056O00030005000200062O0003002C02013O0004783O002C02012O00AB000300013O001253000400703O001253000500714O003E000300054O00D300036O00AB00036O0089000400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007502013O0004783O007502012O00AB0003001B3O0006630003007502013O0004783O007502012O00AB000300114O00FC0003000100020006630003007502013O0004783O007502012O00AB000300053O0020AF00030003004D00122O000500106O00065O00202O00060006004E4O00030006000200062O00030075020100010004783O007502012O00AB000300053O0020AF00030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O00030062020100010004783O006202012O00AB00036O0089000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300514O00030002000200062O0003007502013O0004783O007502012O00AB000300053O00201E0003000300524O00055O00202O0005000500534O0003000500024O000400143O00062O00030075020100040004783O007502012O00AB0003000F3O00264200030075020100100004783O00750201002EAD00760013000100760004783O007502012O00AB000300034O00EB00045O00202O0004000400774O000500043O00202O00050005000A4O00075O00202O0007000700774O0005000700024O000500056O00030005000200062O0003007502013O0004783O007502012O00AB000300013O001253000400783O001253000500794O003E000300054O00D300035O001253000200103O0004783O00C92O010004783O00482O01002E5A007B00990301007A0004783O00990301000E7E0001009903013O0004783O00990301001253000100014O002O010200023O0026D90001007E020100010004783O007E0201001253000200013O000E7E0010000C030100020004783O000C0301002E5A007D00AE0201007C0004783O00AE02012O00AB00036O0089000400013O00122O0005007E3O00122O0006007F6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300AE02013O0004783O00AE02012O00AB0003001C3O000663000300AE02013O0004783O00AE02012O00AB000300053O00207200030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O0003009E02013O0004783O009E02012O00AB000300114O00FC000300010002000630000300AE020100010004783O00AE02012O00AB000300034O005C0004001A3O00202O0004000400804O000500043O00202O00050005002400122O000700256O0005000700024O000500056O00030005000200062O000300AE02013O0004783O00AE02012O00AB000300013O001253000400813O001253000500824O003E000300054O00D300036O00AB00036O0089000400013O00122O000500833O00122O000600846O0004000600024O00030003000400202O0003000300074O00030002000200062O000300F802013O0004783O00F802012O00AB0003001D3O000663000300BE02013O0004783O00BE02012O00AB0003000A3O000630000300C1020100010004783O00C102012O00AB0003001D3O000630000300F8020100010004783O00F802012O00AB0003001E3O000663000300F802013O0004783O00F802012O00AB0003000B4O00AB0004000C3O000612010300F8020100040004783O00F802012O00AB000300053O0020AF00030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O000300F8020100010004783O00F802012O00AB00036O0089000400013O00122O000500853O00122O000600866O0004000600024O00030003000400202O0003000300684O00030002000200062O000300FA02013O0004783O00FA02012O00AB00036O0089000400013O00122O000500873O00122O000600886O0004000600024O00030003000400202O0003000300514O00030002000200062O000300EE02013O0004783O00EE02012O00AB00036O00BD000400013O00122O000500893O00122O0006008A6O0004000600024O00030003000400202O00030003002E4O000300020002000E2O008B00FA020100030004783O00FA02012O00AB00036O00BD000400013O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400202O00030003002E4O000300020002000E2O008E00FA020100030004783O00FA0201002E5A0090000B0301008F0004783O000B03012O00AB000300034O00EB00045O00202O0004000400914O000500043O00202O00050005000A4O00075O00202O0007000700914O0005000700024O000500056O00030005000200062O0003000B03013O0004783O000B03012O00AB000300013O001253000400923O001253000500934O003E000300054O00D300035O001253000200193O0026D900020090030100010004783O009003012O00AB00036O0089000400013O00122O000500943O00122O000600956O0004000600024O00030003000400202O0003000300074O00030002000200062O0003005903013O0004783O005903012O00AB000300153O0006630003005903013O0004783O005903012O00AB000300163O0006630003002103013O0004783O002103012O00AB0003000A3O00063000030024030100010004783O002403012O00AB000300163O00063000030059030100010004783O005903012O00AB0003000B4O00AB0004000C3O00061201030059030100040004783O005903012O00AB00036O0089000400013O00122O000500963O00122O000600976O0004000600024O00030003000400202O0003000300684O00030002000200062O0003005903013O0004783O005903012O00AB000300053O0020AF00030003003600122O000500106O00065O00202O0006000600914O00030006000200062O0003004C030100010004783O004C03012O00AB000300053O00207200030003003600122O000500106O00065O00202O0006000600984O00030006000200062O0003005903013O0004783O005903012O00AB00036O002E010400013O00122O000500993O00122O0006009A6O0004000600024O00030003000400202O0003000300684O00030002000200062O00030059030100010004783O005903012O00AB000300034O00AB00045O00202400040004005C2O001901030002000200063000030054030100010004783O00540301002EE8009C00590301009B0004783O005903012O00AB000300013O0012530004009D3O0012530005009E4O003E000300054O00D300036O00AB00036O0089000400013O00122O0005009F3O00122O000600A06O0004000600024O00030003000400202O0003000300074O00030002000200062O0003008F03013O0004783O008F03012O00AB0003001F3O0006630003006903013O0004783O006903012O00AB0003000A3O0006300003006C030100010004783O006C03012O00AB0003001F3O0006300003008F030100010004783O008F03012O00AB000300203O0006630003008F03013O0004783O008F03012O00AB0003000B4O00AB0004000C3O0006120103008F030100040004783O008F03012O00AB000300053O00207200030003003600122O000500106O00065O00202O00060006002F4O00030006000200062O0003007F03013O0004783O007F03012O00AB000300114O00FC0003000100020006300003008F030100010004783O008F03012O00AB000300034O005C0004001A3O00202O0004000400A14O000500043O00202O00050005002400122O000700256O0005000700024O000500056O00030005000200062O0003008F03013O0004783O008F03012O00AB000300013O001253000400A23O001253000500A34O003E000300054O00D300035O001253000200103O00264800020094030100190004783O00940301002EE800A40081020100A50004783O008102010012533O00103O0004783O009903010004783O008102010004783O009903010004783O007E02010026D93O00010001001C0004783O00010001001253000100013O002EAD00A60049000100A60004783O00E50301000E7E001000E5030100010004783O00E503012O00AB00026O0089000300013O00122O000400A73O00122O000500A86O0003000500024O00020002000300202O0002000200074O00020002000200062O000200BD03013O0004783O00BD03012O00AB000200213O000663000200BD03013O0004783O00BD03012O00AB000200223O000E6E00A900BD030100020004783O00BD0301002E5A00AA00BD030100AB0004783O00BD03012O00AB000200034O00AB00035O0020240003000300AC2O0019010200020002000663000200BD03013O0004783O00BD03012O00AB000200013O001253000300AD3O001253000400AE4O003E000200044O00D300026O00AB00026O0089000300013O00122O000400AF3O00122O000500B06O0003000500024O00020002000300202O0002000200074O00020002000200062O000200E403013O0004783O00E403012O00AB000200233O000663000200E403013O0004783O00E403012O00AB000200053O00200A0002000200B12O0019010200020002000E0F01B200E4030100020004783O00E403012O00AB000200223O000E6E00A900E4030100020004783O00E403012O00AB000200034O00BF00035O00202O0003000300B34O000400043O00202O00040004002400122O000600B26O0004000600024O000400046O00020004000200062O000200DF030100010004783O00DF0301002E5A00B500E4030100B40004783O00E403012O00AB000200013O001253000300B63O001253000400B74O003E000200044O00D300025O001253000100193O002648000100E9030100010004783O00E90301002E5A00B9005D040100B80004783O005D04012O00AB00026O0089000300013O00122O000400BA3O00122O000500BB6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002104013O0004783O002104012O00AB000200243O0006630002002104013O0004783O002104012O00AB000200053O0020060102000200404O00045O00202O0004000400424O00020004000200062O0002000E040100010004783O000E04012O00AB000200194O00640002000100024O00038O000400013O00122O000500BC3O00122O000600BD6O0004000600024O00030003000400202O0003000300BE4O00030002000200062O0003000E040100020004783O000E04012O00AB000200254O00AB000300124O00190102000200020006630002002104013O0004783O00210401002E5A00BF0021040100C00004783O002104012O00AB000200034O00EB00035O00202O0003000300C14O000400043O00202O00040004000A4O00065O00202O0006000600C14O0004000600024O000400046O00020004000200062O0002002104013O0004783O002104012O00AB000200013O001253000300C23O001253000400C34O003E000200044O00D300026O00AB00026O0089000300013O00122O000400C43O00122O000500C56O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004904013O0004783O004904012O00AB0002001B3O0006630002004904013O0004783O004904012O00AB000200263O000E6E00040049040100020004783O004904012O00AB00026O002E010300013O00122O000400C63O00122O000500C76O0003000500024O00020002000300202O0002000200684O00020002000200062O00020045040100010004783O004504012O00AB00026O0089000300013O00122O000400C83O00122O000500C96O0003000500024O00020002000300202O0002000200684O00020002000200062O0002004B04013O0004783O004B04012O00AB000200114O00FC0002000100020006630002004B04013O0004783O004B0401002E5A00CA005C040100CB0004783O005C04012O00AB000200034O00EB00035O00202O0003000300774O000400043O00202O00040004000A4O00065O00202O0006000600774O0004000600024O000400046O00020004000200062O0002005C04013O0004783O005C04012O00AB000200013O001253000300CC3O001253000400CD4O003E000200044O00D300025O001253000100103O0026D90001009C030100190004783O009C03010012533O00043O0004783O000100010004783O009C03010004783O000100012O00943O00017O00CB3O00028O00025O00DCA240026O00F03F025O00C09840025O00DAA140025O0032A040025O009CA640025O00DEA540030A3O003CAC69EB0DA41CA263F003063O00E26ECD10846B030A3O0049734361737461626C65030C3O00436173745461726765744966030A3O005261796F6646726F73742O033O00E6C2F803053O00218BA380B9030E3O0049735370652O6C496E52616E676503153O0045591DE1585E3BD8455717CA175B08DB564E019E0F03043O00BE373864030C3O0071A33D1D1AE2FF65BF35151603073O009336CF5C7E738303073O0049735265616479026O00144003063O002B3D206F1F6703063O001E6D51551D6D030A3O00432O6F6C646F776E5570025O00EC9340025O002AAC40026O006E40025O00989240030C3O00476C616369616C5370696B6503173O00F87D55B53FDFF0C06244BF3DDBBCFC7D51B720DBBCAE2103073O009C9F1134D656BE03093O0088FDB2A6ABE192AEAC03043O00DCCE8FDD030A3O0042752O66537461636B5003123O0046696E676572736F6646726F737442752O66027O0040030A3O00B47C3418DEEAC0896E3903073O00B2E61D4D77B8AC030B3O004973417661696C61626C65030A3O00C7BF131471DEE7B1190F03063O009895DE6A7B17030C3O00432O6F6C646F776E446F776E025O00D88340025O00A2A140030D3O0046726F7A656E4F72624361737403093O0046726F7A656E4F726203143O00DB34F959B0D319F951B79D25FA46B4CB23B612E703053O00D5BD469623025O00A49E40025O00B08040026O000840025O00806840025O009EA740026O00A040025O00CEA740030C3O00E1D582DD27EBCAEA93D725EF03063O008AA6B9E3BE4E03173O00CC78C4345B2215F467D53E592659C878C036442659992403073O0079AB14A557324303083O00EF3BBC1AB80CC53D03063O0062A658D956D903083O005072657647434450025O00B07940025O0034A74003083O004963654C616E63652O033O00FBF76103063O00BC2O961961E603133O00D38A5A3D00ECD48A5A420FE1DF8849074CBF8803063O008DBAE93F626C025O00809440025O00D2A54003073O00D8E929982AE7EB03053O0045918A4CD6026O001040025O00E8A040025O0098AA40025O00E09040025O00CCA64003073O004963654E6F766103123O0079CC8CB6B11966CEC98AB31371D98CC9ED4203063O007610AF2OE9DF025O00C4AA40025O00D49B40025O0018B140025O00CCAF40025O00288940025O0042B040030D3O004834B646A5D27FA24B33A845A303083O00C51B5CDF20D1BB1103093O00254DCCE10651ECE90103043O009B633FA3030F3O00432O6F6C646F776E52656D61696E73026O002440030A3O00A1DEAC88ADB796DEB38003063O00E4E2B1C1EDD9030A3O0017BF2EE3208337E926BD03043O008654D043030A3O0021AD9F53158A945300B803043O003C73CCE6030A3O00D53BF27FE11CF97FF42E03043O0010875A8B03083O007D771F054B5D764703073O0018341466532E34026O003440025O0028B340030D3O005368696674696E67506F77657203183O00D72728221BCD21261B1FCB3824364FC723242519C16F707C03053O006FA44F4144025O00BAA340025O0023B240025O001EAF40025O00F89140025O00C4AF40025O0097B040030A3O006C5A7A0D40535707435103043O00682F3514030B3O0080438D18B91CB77F8F1DAC03063O006FC32CE17CDC030A3O00FB490D76BF98CC49127E03063O00CBB8266013CB03093O001F61765BCB375C6B4303053O00AE59131921025O00989640025O00088140030A3O00436F6E656F66436F6C64025O00408340025O00E0684003163O002C1D5C4BC8880D10115D42F3C70823175358F2C75A7B03073O006B4F72322E97E703083O001BAABC339038A5C403083O00A059C6D549EA59D703093O006172B1DDC4447DB1EC03053O00A52811D49E030C3O00C3CB0D363CECD70F0127ECD703053O004685B96853030F3O0037554823C710405623C703664B26CD03053O00A96425244A030A3O003286BB5F06A1B05F139303043O003060E7C203063O0042752O66557003103O0046722O657A696E675261696E42752O66025O0020B140025O00D0A140030E3O00426C692O7A617264437572736F7203083O00426C692O7A61726403123O00CA56073703D9BD878859022818CEAAC3990C03083O00E3A83A6E4D79B8CF025O00D4B140025O00B0824003093O00AD963AA8FA8972879003073O001DEBE455DB8EEB03093O0046726F7374626F6C7403133O003BC6B5CE634C285E2994B9D1724F31577D86EC03083O00325DB4DABD172E47025O0046AD4003083O0049734D6F76696E67025O0062AE40025O009EB240025O0088A440025O0040A340025O00FAA840025O006EA740025O00C08D40025O00C05140025O0056A240025O00707A40025O0085B340025O00A7B240025O000AAA40025O0068AC40030A3O00C61658860B3E3B51F71403083O003E857935E37F6D4F03063O00466C752O7279025O00F4AC40025O00B2A240030A3O00436F6D657453746F726D03143O00131B3FF0C291B1041B20F896ADAE2O1524F096FC03073O00C270745295B6CE03063O001FA4590AD2FB03073O006E59C82C78A08203063O008DCF5E54515303083O002DCBA32B26232A5B03113O00436861726765734672616374696F6E616C2O033O00DF8CD203073O0034B2E5BC43E7C9030F3O00274D4516E54563224D5505E159637503073O004341213064973C025O00709B40025O003EAD4003083O00F6E4ABF4F2D1E4AB03053O0093BF87CEB8030C3O00A324A7C2D152BEB738AFCADD03073O00D2E448C6A1B83303123O000140FD0476DC256AFB197FC2124CF10575C803063O00AE5629937013030F3O0041757261416374697665436F756E74025O004CA440025O0028A9402O033O0056019503083O00CB3B60ED6B456F7103123O002D15A9DE3DF1D92713ECE23DF5D63213ECB703073O00B74476CC81519000DC032O0012533O00014O003O0100023O002EAD00020007000100020004783O000900010026D93O0009000100010004783O00090001001253000100014O002O010200023O0012533O00033O0026D93O0002000100030004783O00020001002EAD00043O000100040004783O000B00010026D90001000B000100010004783O000B0001001253000200013O002EE8000600C2000100050004783O00C20001000E7E000300C2000100020004783O00C20001001253000300013O00264800030019000100010004783O00190001002EE800070075000100080004783O007500012O00AB00046O0089000500013O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004004200013O0004783O004200012O00AB000400023O0026D900040042000100030004783O004200012O00AB000400033O0006630004004200013O0004783O004200012O00AB000400043O00201B01040004000C4O00055O00202O00050005000D4O000600056O000700013O00122O0008000E3O00122O0009000F6O0007000900024O000800066O000900096O000A00073O00202O000A000A00104O000C5O00202O000C000C000D4O000A000C00024O000A000A6O0004000A000200062O0004004200013O0004783O004200012O00AB000400013O001253000500113O001253000600124O003E000400064O00D300046O00AB00046O0089000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400154O00040002000200062O0004005F00013O0004783O005F00012O00AB000400083O0006630004005F00013O0004783O005F00012O00AB000400093O0026D90004005F000100160004783O005F00012O00AB00046O002E010500013O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400194O00040002000200062O00040061000100010004783O006100012O00AB000400023O000EB200010061000100040004783O00610001002EE8001B00740001001A0004783O00740001002EE8001C00740001001D0004783O007400012O00AB0004000A4O00EB00055O00202O00050005001E4O000600073O00202O0006000600104O00085O00202O00080008001E4O0006000800024O000600066O00040006000200062O0004007400013O0004783O007400012O00AB000400013O0012530005001F3O001253000600204O003E000400064O00D300045O001253000300033O0026D900030015000100030004783O001500012O00AB00046O0089000500013O00122O000600213O00122O000700226O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400AC00013O0004783O00AC00012O00AB0004000B3O0006630004008700013O0004783O008700012O00AB0004000C3O0006300004008A000100010004783O008A00012O00AB0004000B3O000630000400AC000100010004783O00AC00012O00AB0004000D3O000663000400AC00013O0004783O00AC00012O00AB0004000E4O00AB0005000F3O000612010400AC000100050004783O00AC00012O00AB000400103O0020840004000400234O00065O00202O0006000600244O00040006000200262O000400AC000100250004783O00AC00012O00AB00046O0089000500013O00122O000600263O00122O000700276O0005000700024O00040004000500202O0004000400284O00040002000200062O000400AE00013O0004783O00AE00012O00AB00046O002E010500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400AE000100010004783O00AE0001002EE8002D00BF0001002C0004783O00BF00012O00AB0004000A4O00EB000500113O00202O00050005002E4O000600073O00202O0006000600104O00085O00202O00080008002F4O0006000800024O000600066O00040006000200062O000400BF00013O0004783O00BF00012O00AB000400013O001253000500303O001253000600314O003E000400064O00D300045O001253000200253O0004783O00C200010004783O00150001002EE80033005B2O0100320004783O005B2O010026D90002005B2O0100340004783O005B2O01001253000300014O002O010400043O002E5A003500C8000100360004783O00C800010026D9000300C8000100010004783O00C80001001253000400013O0026D90004002D2O0100010004783O002D2O01002E5A003700F2000100380004783O00F200012O00AB00056O0089000600013O00122O000700393O00122O0008003A6O0006000800024O00050005000600202O0005000500154O00050002000200062O000500F200013O0004783O00F200012O00AB000500083O000663000500F200013O0004783O00F200012O00AB000500093O0026D9000500F2000100160004783O00F200012O00AB0005000A4O00EB00065O00202O00060006001E4O000700073O00202O0007000700104O00095O00202O00090009001E4O0007000900024O000700076O00050007000200062O000500F200013O0004783O00F200012O00AB000500013O0012530006003B3O0012530007003C4O003E000500074O00D300056O00AB00056O0089000600013O00122O0007003D3O00122O0008003E6O0006000800024O00050005000600202O0005000500154O00050002000200062O000500112O013O0004783O00112O012O00AB000500123O000663000500112O013O0004783O00112O012O00AB000500103O0020860005000500234O00075O00202O0007000700244O00050007000200062O0005000E2O013O0004783O000E2O012O00AB000500103O00207200050005003F00122O000700036O00085O00202O00080008001E4O00050008000200062O000500132O013O0004783O00132O012O00AB000500023O000EB2000100132O0100050004783O00132O01002E5A0041002C2O0100400004783O002C2O012O00AB000500043O00201B01050005000C4O00065O00202O0006000600424O000700056O000800013O00122O000900433O00122O000A00446O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B00104O000D5O00202O000D000D00424O000B000D00024O000B000B6O0005000B000200062O0005002C2O013O0004783O002C2O012O00AB000500013O001253000600453O001253000700464O003E000500074O00D300055O001253000400033O002E5A004700CD000100480004783O00CD00010026D9000400CD000100030004783O00CD00012O00AB00056O0089000600013O00122O000700493O00122O0008004A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500412O013O0004783O00412O012O00AB000500133O000663000500412O013O0004783O00412O012O00AB000500143O000ECD004B00432O0100050004783O00432O01002E5A004D00562O01004C0004783O00562O01002E5A004E00562O01004F0004783O00562O012O00AB0005000A4O00EB00065O00202O0006000600504O000700073O00202O0007000700104O00095O00202O0009000900504O0007000900024O000700076O00050007000200062O000500562O013O0004783O00562O012O00AB000500013O001253000600513O001253000700524O003E000500074O00D300055O0012530002004B3O0004783O005B2O010004783O00CD00010004783O005B2O010004783O00C800010026480002005F2O0100250004783O005F2O01002E5A00530092020100540004783O00920201001253000300014O002O010400043O000EFF000100652O0100030004783O00652O01002E5A005500612O0100560004783O00612O01001253000400013O0026480004006A2O0100030004783O006A2O01002EE8005800D62O0100570004783O00D62O012O00AB00056O0089000600013O00122O000700593O00122O0008005A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500D42O013O0004783O00D42O012O00AB000500153O000663000500D42O013O0004783O00D42O012O00AB000500163O0006630005007D2O013O0004783O007D2O012O00AB0005000C3O000630000500802O0100010004783O00802O012O00AB000500163O000630000500D42O0100010004783O00D42O012O00AB0005000E4O00AB0006000F3O000612010500D42O0100060004783O00D42O012O00AB00056O0046000600013O00122O0007005B3O00122O0008005C6O0006000800024O00050005000600202O00050005005D4O000500020002000E2O005E00B62O0100050004783O00B62O012O00AB00056O0089000600013O00122O0007005F3O00122O000800606O0006000800024O00050005000600202O0005000500284O00050002000200062O000500A22O013O0004783O00A22O012O00AB00056O0046000600013O00122O000700613O00122O000800626O0006000800024O00050005000600202O00050005005D4O000500020002000E2O005E00B62O0100050004783O00B62O012O00AB00056O0089000600013O00122O000700633O00122O000800646O0006000800024O00050005000600202O0005000500284O00050002000200062O000500C02O013O0004783O00C02O012O00AB00056O00BD000600013O00122O000700653O00122O000800666O0006000800024O00050005000600202O00050005005D4O000500020002000E2O005E00C02O0100050004783O00C02O012O00AB00056O002C000600013O00122O000700673O00122O000800686O0006000800024O00050005000600202O00050005005D4O00050002000200262O000500D42O0100690004783O00D42O01002EAD006A00140001006A0004783O00D42O012O00AB0005000A4O004F00065O00202O00060006006B4O000700073O00202O0007000700104O00095O00202O00090009006B4O0007000900024O000700076O000800016O00050008000200062O000500D42O013O0004783O00D42O012O00AB000500013O0012530006006C3O0012530007006D4O003E000500074O00D300055O001253000200343O0004783O00920201000EFF000100DA2O0100040004783O00DA2O01002EE8006F00662O01006E0004783O00662O01001253000500013O002648000500DF2O0100030004783O00DF2O01002EE8007000E12O0100710004783O00E12O01001253000400033O0004783O00662O01002EE8007200DB2O0100730004783O00DB2O010026D9000500DB2O0100010004783O00DB2O012O00AB00066O0089000700013O00122O000800743O00122O000900756O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006002302013O0004783O002302012O00AB000600173O0006630006002302013O0004783O002302012O00AB000600183O000663000600F82O013O0004783O00F82O012O00AB0006000C3O000630000600FB2O0100010004783O00FB2O012O00AB000600183O00063000060023020100010004783O002302012O00AB0006000E4O00AB0007000F3O00061201060023020100070004783O002302012O00AB00066O0089000700013O00122O000800763O00122O000900776O0007000900024O00060006000700202O0006000600284O00060002000200062O0006002302013O0004783O002302012O00AB00066O0046000700013O00122O000800783O00122O000900796O0007000900024O00060006000700202O00060006005D4O000600020002000E2O005E0023020100060004783O002302012O00AB00066O0046000700013O00122O0008007A3O00122O0009007B6O0007000900024O00060006000700202O00060006005D4O000600020002000E2O005E0023020100060004783O002302012O00AB000600023O0026D900060023020100010004783O002302012O00AB000600143O000ECD00340025020100060004783O00250201002EE8007C00380201007D0004783O003802012O00AB0006000A4O007600075O00202O00070007007E4O000800073O00202O0008000800104O000A5O00202O000A000A007E4O0008000A00024O000800086O00060008000200062O00060033020100010004783O00330201002EAD007F0007000100800004783O003802012O00AB000600013O001253000700813O001253000800824O003E000600084O00D300066O00AB00066O0089000700013O00122O000800833O00122O000900846O0007000900024O00060006000700202O00060006000B4O00060002000200062O0006007A02013O0004783O007A02012O00AB000600193O0006630006007A02013O0004783O007A02012O00AB000600143O000E6E0025007A020100060004783O007A02012O00AB00066O0089000700013O00122O000800853O00122O000900866O0007000900024O00060006000700202O0006000600284O00060002000200062O0006007A02013O0004783O007A02012O00AB00066O0089000700013O00122O000800873O00122O000900886O0007000900024O00060006000700202O0006000600284O00060002000200062O0006007A02013O0004783O007A02012O00AB00066O002E010700013O00122O000800893O00122O0009008A6O0007000900024O00060006000700202O0006000600284O00060002000200062O00060070020100010004783O007002012O00AB00066O0089000700013O00122O0008008B3O00122O0009008C6O0007000900024O00060006000700202O0006000600284O00060002000200062O0006007C02013O0004783O007C02012O00AB000600103O00200601060006008D4O00085O00202O00080008008E4O00060008000200062O0006007C020100010004783O007C02012O00AB000600143O000ECD0034007C020100060004783O007C0201002E5A008F008D020100900004783O008D02012O00AB0006000A4O00EB000700113O00202O0007000700914O000800073O00202O0008000800104O000A5O00202O000A000A00924O0008000A00024O000800086O00060008000200062O0006008D02013O0004783O008D02012O00AB000600013O001253000700933O001253000800944O003E000600084O00D300065O001253000500033O0004783O00DB2O010004783O00662O010004783O009202010004783O00612O01000E7E004B00F1020100020004783O00F10201002EE8009600B5020100950004783O00B502012O00AB00036O0089000400013O00122O000500973O00122O000600986O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300B502013O0004783O00B502012O00AB0003001A3O000663000300B502013O0004783O00B502012O00AB0003000A4O004F00045O00202O0004000400994O000500073O00202O0005000500104O00075O00202O0007000700994O0005000700024O000500056O000600016O00030006000200062O000300B502013O0004783O00B502012O00AB000300013O0012530004009A3O0012530005009B4O003E000300054O00D300035O002EAD009C00262O01009C0004783O00DB03012O00AB000300103O00200A00030003009D2O0019010300020002000663000300DB03013O0004783O00DB03012O00AB0003001B3O000663000300DB03013O0004783O00DB0301001253000300014O002O010400063O002EE8009E00C80201009F0004783O00C802010026D9000300C8020100010004783O00C80201001253000400014O002O010500053O001253000300033O002EE800A100C1020100A00004783O00C102010026D9000300C1020100030004783O00C102012O002O010600063O0026D9000400DE020100030004783O00DE0201000EFF000100D3020100050004783O00D30201002E5A00A200CF020100A30004783O00CF02012O00AB0007001C4O00FC0007000100022O002F010600073O000630000600DA020100010004783O00DA0201002E5A00A400DB030100A50004783O00DB03012O0028010600023O0004783O00DB03010004783O00CF02010004783O00DB03010026D9000400CD020100010004783O00CD0201001253000700013O002E5A00A700E8020100A60004783O00E80201000E7E000100E8020100070004783O00E80201001253000500014O002O010600063O001253000700033O0026D9000700E1020100030004783O00E10201001253000400033O0004783O00CD02010004783O00E102010004783O00CD02010004783O00DB03010004783O00C102010004783O00DB0301002E5A00A90010000100A80004783O001000010026D900020010000100010004783O00100001001253000300013O0026D90003008B030100010004783O008B0301001253000400013O0026D900040084030100010004783O00840301002EE800AA003A030100AB0004783O003A03012O00AB00056O0089000600013O00122O000700AC3O00122O000800AD6O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005003A03013O0004783O003A03012O00AB000500103O0020AF00050005003F00122O000700036O00085O00202O0008000800AE4O00050008000200062O00050017030100010004783O001703012O00AB000500103O00207200050005003F00122O000700036O00085O00202O00080008007E4O00050008000200062O0005003A03013O0004783O003A03012O00AB0005001D3O0006630005001D03013O0004783O001D03012O00AB0005000C3O00063000050020030100010004783O002003012O00AB0005001D3O0006300005003A030100010004783O003A03012O00AB0005001E3O0006630005003A03013O0004783O003A03012O00AB0005000E4O00AB0006000F3O0006120105003A030100060004783O003A0301002E5A00B0003A030100AF0004783O003A03012O00AB0005000A4O00EB00065O00202O0006000600B14O000700073O00202O0007000700104O00095O00202O0009000900B14O0007000900024O000700076O00050007000200062O0005003A03013O0004783O003A03012O00AB000500013O001253000600B23O001253000700B34O003E000500074O00D300056O00AB00056O0089000600013O00122O000700B43O00122O000800B56O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005008303013O0004783O008303012O00AB0005001F3O0006630005008303013O0004783O008303012O00AB000500103O00207200050005003F00122O000700036O00085O00202O0008000800994O00050008000200062O0005005203013O0004783O005203012O00AB000500093O000ECD0034006A030100050004783O006A03012O00AB000500103O0020AF00050005003F00122O000700036O00085O00202O00080008001E4O00050008000200062O0005006A030100010004783O006A03012O00AB000500093O000E6E00340083030100050004783O008303012O00AB000500093O00264200050083030100160004783O008303012O00AB00056O000E010600013O00122O000700B63O00122O000800B76O0006000800024O00050005000600202O0005000500B84O00050002000200262O00050083030100250004783O008303012O00AB000500043O00201B01050005000C4O00065O00202O0006000600AE4O000700056O000800013O00122O000900B93O00122O000A00BA6O0008000A00024O000900066O000A000A6O000B00073O00202O000B000B00104O000D5O00202O000D000D00AE4O000B000D00024O000B000B6O0005000B000200062O0005008303013O0004783O008303012O00AB000500013O001253000600BB3O001253000700BC4O003E000500074O00D300055O001253000400033O002EE800BD00F9020100BE0004783O00F902010026D9000400F9020100030004783O00F90201001253000300033O0004783O008B03010004783O00F902010026D9000300F6020100030004783O00F602012O00AB00046O0089000500013O00122O000600BF3O00122O000700C06O0005000700024O00040004000500202O0004000400154O00040002000200062O000400D303013O0004783O00D303012O00AB000400123O000663000400D303013O0004783O00D303012O00AB00046O0089000500013O00122O000600C13O00122O000700C26O0005000700024O00040004000500202O0004000400284O00040002000200062O000400D303013O0004783O00D303012O00AB00046O000E010500013O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O0004000400C54O00040002000200262O000400D3030100010004783O00D303012O00AB000400093O0026D9000400D30301004B0004783O00D303012O00AB000400103O00208600040004008D4O00065O00202O0006000600244O00040006000200062O000400D303013O0004783O00D30301002E5A00C600D3030100C70004783O00D303012O00AB000400043O00201B01040004000C4O00055O00202O0005000500424O000600056O000700013O00122O000800C83O00122O000900C96O0007000900024O000800206O000900096O000A00073O00202O000A000A00104O000C5O00202O000C000C00424O000A000C00024O000A000A6O0004000A000200062O000400D303013O0004783O00D303012O00AB000400013O001253000500CA3O001253000600CB4O003E000400064O00D300045O001253000200033O0004783O001000010004783O00F602010004783O001000010004783O00DB03010004783O000B00010004783O00DB03010004783O000200012O00943O00017O00B93O00028O00025O0062B340025O00B8AC40026O000840025O0016AB40025O007AA940030C3O00098F114520DB22B0004F22DF03063O00BA4EE370264903073O0049735265616479026O001440030C3O00476C616369616C5370696B65030E3O0049735370652O6C496E52616E676503173O00FB5BFC565A7BF068EE455A71F917EE5C5D7DF052BD072O03063O001A9C379D353303083O00A5DB13F5B95E8FDD03063O0030ECB876B9D803063O0042752O66557003123O0046696E676572736F6646726F737442752O6603083O005072657647434450026O00F03F030C3O00C2B15633C635E98E4739C43103063O005485DD3750AF03083O00496E466C69676874025O00D49640025O000AA24003083O004963654C616E636503133O00B4E42199CB5DB3E421E6D455B3E028A3870EEF03063O003CDD8744C6A703073O00C7BEFDAD4DCFEF03063O00B98EDD98E322030A3O0049734361737461626C65026O00104003073O004963654E6F7661025O003DB240025O00F07F4003123O0051C652C54D3CE1598544F34D34FB5D8505AE03073O009738A5379A2353025O007EB040025O00309D40025O0024A840025O00805940030A3O00FDAB564950EF5CD1B65603073O0028BEC43B2C24BC03063O00466C752O7279030A3O00436F6E656F66436F6C64025O0039B040025O00C49740030A3O00436F6D657453746F726D03143O003F4AD1B1EE421E284ACEB9BA6E043242D0B1BA2F03073O006D5C25BCD49A1D03063O0022E3B1D1234303063O003A648FC4A351030A3O00446562752O66446F776E03123O0057696E746572734368692O6C446562752O6603093O0046726F7374626F6C74030F3O00427261696E46722O657A6542752O66030C3O003D4E22A03648E93D0A4B28A603083O006E7A2243C35F2985030B3O004973417661696C61626C6503083O0042752O66446F776E025O00206F40025O00C05640030F3O0073BD4E58C46CF14843D872BD5E0A8203053O00B615D13B2A03083O009E54C03120B0B45203063O00DED737A57D41030C3O000BDDC719FBC0E1793CD8CD1F03083O002A4CB1A67A92A18D030C3O00828604CD7077A9B915C7727303063O0016C5EA65AE1903123O002437A0E37AAED9852874B6D578A8DB836D6203083O00E64D54C5BC16CFB7025O0004B240025O003C9C40030B3O00824202E1A67717E7A3481603043O008EC02365030B3O004261676F66547269636B7303133O00D4742E9CE88A9302C47C2AA8F4CCAF1296217903083O0076B61549C387ECCC03093O002O2E1553100FF2042803073O009D685C7A20646D025O00C88340025O0066B14003133O00A5B4C0D9292582A7B7E6DCC3332081AEE3F49903083O00CBC3C6AFAA5D47ED03083O0049734D6F76696E67025O0030A240025O00907740025O005EA940025O00709540025O002AAF40025O0080AD40025O00A89C40025O00109440025O002EAF40027O0040025O005BB040025O00D2A940025O000C9140030A3O00C8CABFE4C1EDE6BEEDCA03053O00AE8BA5D181030B3O0080BCEEC5C310644BADB2F203083O0018C3D382A1A66310030A3O00650CE4294725520CFB2103063O00762663894C33030F3O00432O6F6C646F776E52656D61696E73026O00244003093O00DB340A080C2ED2340703063O00409D4665726903163O0043A7A9E62F4FAE98E01F4CACE7F0194EAFABE65011FC03053O007020C8C783025O008CAD40025O0016AE4003083O000E5C55A2D9AA302803073O00424C303CD8A3CB03093O0093857CD05EC228BF9403073O0044DAE619933FAE030C3O008B385649ACA424547EB7A42403053O00D6CD4A332C030F3O00C95CEEF579EE49F0F579FD6FEDF07303053O00179A2C829C030A3O0023A7B4A1303503A9BEBA03063O007371C6CDCE5603103O0046722O657A696E675261696E42752O66030E3O00426C692O7A617264437572736F7203093O004973496E52616E6765026O00444003123O00865BF7409E56EC5EC444F754835BFB1AD50103043O003AE4379E025O00288540025O00B49240030D3O008781D92O28A43BB3B9DF2O39BF03073O0055D4E9B04E5CCD03093O006C4A87F84F56A7F04803043O00822A38E8030A3O00C9BA29E6540CFEBA36EE03063O005F8AD5448320030A3O000927AC4662193CAE517B03053O00164A48C123030A3O001E78FD572A5FF6573F6D03043O00384C1984030A3O006CC0B229C978D3A435DB03053O00AF3EA1CB4603083O0015DEDA253035D3D003053O00555CBDA373026O003440025O00DCAE40030D3O005368696674696E67506F77657203183O003AA4393E3DA53E3F16BC3F2F2CBE702B20A237342CEC616003043O005849CC50025O00F0B240025O00A0614003093O008F1AD19B3AA727CC8303053O005FC968BEE1030A3O0042752O66537461636B50030A3O009DCAD8C1A9EDD3C1BCDF03043O00AECFABA1030A3O00DFFF14FCFEF1FFF11EE703063O00B78D9E6D9398030C3O00432O6F6C646F776E446F776E025O00A4AB40025O003EAE40030D3O0046726F7A656E4F72624361737403143O002A1BE9162907D9033E0BA61F2507E1002949B75E03043O006C4C6986030A3O00CB15DFF38A87E23AEA0003083O00559974A69CECC190030D3O00446562752O6652656D61696E73030A3O0096E154BCE226B6EF5EA703063O0060C4802DD38403083O004361737454696D65030A3O005261796F6646726F737403153O00278C6260DDA98BDE2782684B92BCBDD632817E1F8A03083O00B855ED1B3FB2CFD4030C3O002F55085C0158056C1850025A03043O003F68396903063O002D8BB156199E03043O00246BE7C403073O0043686172676573030C3O007AB9A38454B4AEB44DBCA98203043O00E73DD5C2025O00C4AD40025O00B8A84003173O000EA13C7000AC314C1ABD34780CED2E7A07AA317649FC6D03043O001369CD5D00EF032O0012533O00014O003O0100013O0026483O0006000100010004783O00060001002E5A00020002000100030004783O00020001001253000100013O0026480001000B000100040004783O000B0001002EE80005008E000100060004783O008E00012O00AB00026O0089000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002002C00013O0004783O002C00012O00AB000200023O0006630002002C00013O0004783O002C00012O00AB000200033O0026D90002002C0001000A0004783O002C00012O00AB000200044O00EB00035O00202O00030003000B4O000400053O00202O00040004000C4O00065O00202O00060006000B4O0004000600024O000400046O00020004000200062O0002002C00013O0004783O002C00012O00AB000200013O0012530003000D3O0012530004000E4O003E000200044O00D300026O00AB00026O0089000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200094O00020002000200062O0002006A00013O0004783O006A00012O00AB000200063O0006630002006A00013O0004783O006A00012O00AB000200073O0020860002000200114O00045O00202O0004000400124O00020004000200062O0002005200013O0004783O005200012O00AB000200073O0020AF00020002001300122O000400146O00055O00202O00050005000B4O00020005000200062O00020052000100010004783O005200012O00AB00026O0089000300013O00122O000400153O00122O000500166O0003000500024O00020002000300202O0002000200174O00020002000200062O0002005700013O0004783O005700012O00AB000200084O00AB000300094O00190102000200020006630002006A00013O0004783O006A0001002E5A0018006A000100190004783O006A00012O00AB000200044O00EB00035O00202O00030003001A4O000400053O00202O00040004000C4O00065O00202O00060006001A4O0004000600024O000400046O00020004000200062O0002006A00013O0004783O006A00012O00AB000200013O0012530003001B3O0012530004001C4O003E000200044O00D300026O00AB00026O0089000300013O00122O0004001D3O00122O0005001E6O0003000500024O00020002000300202O00020002001F4O00020002000200062O0002008D00013O0004783O008D00012O00AB0002000A3O0006630002008D00013O0004783O008D00012O00AB0002000B3O000E6E0020008D000100020004783O008D00012O00AB000200044O007600035O00202O0003000300214O000400053O00202O00040004000C4O00065O00202O0006000600214O0004000600024O000400046O00020004000200062O00020088000100010004783O00880001002EE80022008D000100230004783O008D00012O00AB000200013O001253000300243O001253000400254O003E000200044O00D300025O001253000100203O0026D90001007E2O0100010004783O007E2O01001253000200013O000EFF00010095000100020004783O00950001002E5A0026003A2O0100270004783O003A2O01001253000300013O0026D90003009A000100140004783O009A0001001253000200143O0004783O003A2O010026D900030096000100010004783O00960001002E5A002900DB000100280004783O00DB00012O00AB00046O0089000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400DB00013O0004783O00DB00012O00AB0004000C3O000663000400DB00013O0004783O00DB00012O00AB0004000D3O000663000400B100013O0004783O00B100012O00AB0004000E3O000630000400B4000100010004783O00B400012O00AB0004000D3O000630000400DB000100010004783O00DB00012O00AB0004000F4O00AB000500103O000612010400DB000100050004783O00DB00012O00AB000400073O0020AF00040004001300122O000600146O00075O00202O00070007002C4O00040007000200062O000400C8000100010004783O00C800012O00AB000400073O00207200040004001300122O000600146O00075O00202O00070007002D4O00040007000200062O000400DB00013O0004783O00DB0001002EE8002F00DB0001002E0004783O00DB00012O00AB000400044O00EB00055O00202O0005000500304O000600053O00202O00060006000C4O00085O00202O0008000800304O0006000800024O000600066O00040006000200062O000400DB00013O0004783O00DB00012O00AB000400013O001253000500313O001253000600324O003E000400064O00D300046O00AB00046O0089000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400382O013O0004783O00382O012O00AB000400093O0026D9000400382O0100010004783O00382O012O00AB000400053O0020860004000400354O00065O00202O0006000600364O00040006000200062O000400382O013O0004783O00382O012O00AB000400073O00207200040004001300122O000600146O00075O00202O0007000700374O00040007000200062O000400FA00013O0004783O00FA00012O00AB000400033O000ECD000400252O0100040004783O00252O012O00AB000400073O00207200040004001300122O000600146O00075O00202O0007000700374O00040007000200062O000400092O013O0004783O00092O012O00AB000400073O0020060104000400114O00065O00202O0006000600384O00040006000200062O000400252O0100010004783O00252O012O00AB000400073O0020AF00040004001300122O000600146O00075O00202O00070007000B4O00040007000200062O000400252O0100010004783O00252O012O00AB00046O0089000500013O00122O000600393O00122O0007003A6O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400382O013O0004783O00382O012O00AB000400033O0026D9000400382O0100200004783O00382O012O00AB000400073O00208600040004003C4O00065O00202O0006000600124O00040006000200062O000400382O013O0004783O00382O012O00AB000400044O007600055O00202O00050005002C4O000600053O00202O00060006000C4O00085O00202O00080008002C4O0006000800024O000600066O00040006000200062O000400332O0100010004783O00332O01002EE8003D00382O01003E0004783O00382O012O00AB000400013O0012530005003F3O001253000600404O003E000400064O00D300045O001253000300143O0004783O009600010026D900020091000100140004783O009100012O00AB00036O0089000400013O00122O000500413O00122O000600426O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007B2O013O0004783O007B2O012O00AB000300063O0006630003007B2O013O0004783O007B2O012O00AB00036O0089000400013O00122O000500433O00122O000600446O0004000600024O00030003000400202O00030003003B4O00030002000200062O0003007B2O013O0004783O007B2O012O00AB00036O002E010400013O00122O000500453O00122O000600466O0004000600024O00030003000400202O0003000300174O00030002000200062O0003007B2O0100010004783O007B2O012O00AB000300093O0026D90003007B2O0100010004783O007B2O012O00AB000300033O0026D90003007B2O0100200004783O007B2O012O00AB000300073O0020860003000300114O00055O00202O0005000500124O00030005000200062O0003007B2O013O0004783O007B2O012O00AB000300044O00EB00045O00202O00040004001A4O000500053O00202O00050005000C4O00075O00202O00070007001A4O0005000700024O000500056O00030005000200062O0003007B2O013O0004783O007B2O012O00AB000300013O001253000400473O001253000500484O003E000300054O00D300035O001253000100143O0004783O007E2O010004783O009100010026D900010004020100200004783O000402012O00AB000200113O0006630002008C2O013O0004783O008C2O012O00AB000200123O000663000200892O013O0004783O00892O012O00AB0002000E3O0006300002008E2O0100010004783O008E2O012O00AB000200123O0006630002008E2O013O0004783O008E2O01002EAD0049001D0001004A0004783O00A92O012O00AB00026O0089000300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O00020002001F4O00020002000200062O000200A92O013O0004783O00A92O012O00AB000200044O00EB00035O00202O00030003004D4O000400053O00202O00040004000C4O00065O00202O00060006004D4O0004000600024O000400046O00020004000200062O000200A92O013O0004783O00A92O012O00AB000200013O0012530003004E3O0012530004004F4O003E000200044O00D300026O00AB00026O0089000300013O00122O000400503O00122O000500516O0003000500024O00020002000300202O00020002001F4O00020002000200062O000200CA2O013O0004783O00CA2O012O00AB000200133O000663000200CA2O013O0004783O00CA2O01002E5A005200CA2O0100530004783O00CA2O012O00AB000200044O004F00035O00202O0003000300374O000400053O00202O00040004000C4O00065O00202O0006000600374O0004000600024O000400046O000500016O00020005000200062O000200CA2O013O0004783O00CA2O012O00AB000200013O001253000300543O001253000400554O003E000200044O00D300026O00AB000200073O00200A0002000200562O0019010200020002000663000200EE03013O0004783O00EE03012O00AB000200143O000663000200EE03013O0004783O00EE0301001253000200014O002O010300053O0026D9000200D92O0100010004783O00D92O01001253000300014O002O010400043O001253000200143O002648000200DD2O0100140004783O00DD2O01002EE8005700D42O0100580004783O00D42O012O002O010500053O002EAD0059000F000100590004783O00ED2O010026D9000300ED2O0100140004783O00ED2O010026D9000400E22O0100010004783O00E22O012O00AB000600154O00FC0006000100022O002F010500063O000663000500EE03013O0004783O00EE03012O0028010500023O0004783O00EE03010004783O00E22O010004783O00EE0301002EE8005A00DE2O01005B0004783O00DE2O010026D9000300DE2O0100010004783O00DE2O01001253000600013O002E5A005D00F82O01005C0004783O00F82O01000E7E001400F82O0100060004783O00F82O01001253000300143O0004783O00DE2O01002648000600FC2O0100010004783O00FC2O01002E5A005F00F22O01005E0004783O00F22O01001253000400014O002O010500053O001253000600143O0004783O00F22O010004783O00DE2O010004783O00EE03010004783O00D42O010004783O00EE0301000E7E00600025030100010004783O00250301001253000200013O0026480002000B020100010004783O000B0201002E5A006100B3020100620004783O00B30201001253000300013O0026D900030010020100140004783O00100201001253000200143O0004783O00B30201002EAD006300FCFF2O00630004783O000C02010026D90003000C020100010004783O000C02012O00AB00046O0089000500013O00122O000600643O00122O000700656O0005000700024O00040004000500202O00040004001F4O00040002000200062O0004005D02013O0004783O005D02012O00AB000400163O0006630004005D02013O0004783O005D02012O00AB000400173O0006630004002702013O0004783O002702012O00AB0004000E3O0006300004002A020100010004783O002A02012O00AB000400173O0006300004005D020100010004783O005D02012O00AB0004000F4O00AB000500103O0006120104005D020100050004783O005D02012O00AB00046O0089000500013O00122O000600663O00122O000700676O0005000700024O00040004000500202O00040004003B4O00040002000200062O0004005D02013O0004783O005D02012O00AB00046O0046000500013O00122O000600683O00122O000700696O0005000700024O00040004000500202O00040004006A4O000400020002000E2O006B005D020100040004783O005D02012O00AB00046O0046000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004006A4O000400020002000E2O006B005D020100040004783O005D02012O00AB000400093O0026D90004005D020100010004783O005D02012O00AB000400183O000E6E0004005D020100040004783O005D02012O00AB000400044O00AB00055O00202400050005002D2O00190104000200020006630004005D02013O0004783O005D02012O00AB000400013O0012530005006E3O0012530006006F4O003E000400064O00D300045O002EE8007000B1020100710004783O00B102012O00AB00046O0089000500013O00122O000600723O00122O000700736O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400B102013O0004783O00B102012O00AB000400193O000663000400B102013O0004783O00B102012O00AB000400183O000E6E006000B1020100040004783O00B102012O00AB00046O0089000500013O00122O000600743O00122O000700756O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400B102013O0004783O00B102012O00AB00046O0089000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400B102013O0004783O00B102012O00AB00046O002E010500013O00122O000600783O00122O000700796O0005000700024O00040004000500202O00040004003B4O00040002000200062O00040097020100010004783O009702012O00AB00046O0089000500013O00122O0006007A3O00122O0007007B6O0005000700024O00040004000500202O00040004003B4O00040002000200062O000400A102013O0004783O00A102012O00AB000400073O0020060104000400114O00065O00202O00060006007C4O00040006000200062O000400A1020100010004783O00A102012O00AB000400183O000E6E000400B1020100040004783O00B102012O00AB000400044O005C0005001A3O00202O00050005007D4O000600053O00202O00060006007E00122O0008007F6O0006000800024O000600066O00040006000200062O000400B102013O0004783O00B102012O00AB000400013O001253000500803O001253000600814O003E000400064O00D300045O001253000300143O0004783O000C0201002E5A00820007020100830004783O000702010026D900020007020100140004783O000702012O00AB00036O0089000400013O00122O000500843O00122O000600856O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003002203013O0004783O002203012O00AB0003001B3O0006630003002203013O0004783O002203012O00AB0003001C3O000663000300CA02013O0004783O00CA02012O00AB0003000E3O000630000300CD020100010004783O00CD02012O00AB0003001C3O00063000030022030100010004783O002203012O00AB0003000F4O00AB000400103O00061201030022030100040004783O002203012O00AB000300093O0026D900030022030100010004783O002203012O00AB00036O0046000400013O00122O000500863O00122O000600876O0004000600024O00030003000400202O00030003006A4O000300020002000E2O006B0006030100030004783O000603012O00AB00036O0089000400013O00122O000500883O00122O000600896O0004000600024O00030003000400202O00030003003B4O00030002000200062O000300F202013O0004783O00F202012O00AB00036O0046000400013O00122O0005008A3O00122O0006008B6O0004000600024O00030003000400202O00030003006A4O000300020002000E2O006B0006030100030004783O000603012O00AB00036O0089000400013O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400202O00030003003B4O00030002000200062O0003001003013O0004783O001003012O00AB00036O00BD000400013O00122O0005008E3O00122O0006008F6O0004000600024O00030003000400202O00030003006A4O000300020002000E2O006B0010030100030004783O001003012O00AB00036O002C000400013O00122O000500903O00122O000600916O0004000600024O00030003000400202O00030003006A4O00030002000200262O00030022030100920004783O00220301002EAD00930012000100930004783O002203012O00AB000300044O005C00045O00202O0004000400944O000500053O00202O00050005007E00122O0007007F6O0005000700024O000500056O00030005000200062O0003002203013O0004783O002203012O00AB000300013O001253000400953O001253000500964O003E000300054O00D300035O001253000100043O0004783O002503010004783O000702010026D900010007000100140004783O00070001001253000200013O002E5A00980078030100970004783O007803010026D900020078030100140004783O007803012O00AB00036O0089000400013O00122O000500993O00122O0006009A6O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003007603013O0004783O007603012O00AB0003001D3O0006630003007603013O0004783O007603012O00AB0003001E3O0006630003003F03013O0004783O003F03012O00AB0003000E3O00063000030042030100010004783O004203012O00AB0003001E3O00063000030076030100010004783O007603012O00AB0003000F4O00AB000400103O00061201030076030100040004783O007603012O00AB000300093O0026D900030076030100010004783O007603012O00AB000300073O00208400030003009B4O00055O00202O0005000500124O00030005000200262O00030076030100600004783O007603012O00AB00036O0089000400013O00122O0005009C3O00122O0006009D6O0004000600024O00030003000400202O00030003003B4O00030002000200062O0003006403013O0004783O006403012O00AB00036O0089000400013O00122O0005009E3O00122O0006009F6O0004000600024O00030003000400202O0003000300A04O00030002000200062O0003007603013O0004783O00760301002EE800A10076030100A20004783O007603012O00AB000300044O005C0004001A3O00202O0004000400A34O000500053O00202O00050005007E00122O0007007F6O0005000700024O000500056O00030005000200062O0003007603013O0004783O007603012O00AB000300013O001253000400A43O001253000500A54O003E000300054O00D300035O001253000100603O0004783O000700010026D900020028030100010004783O002803012O00AB00036O0089000400013O00122O000500A63O00122O000600A76O0004000600024O00030003000400202O00030003001F4O00030002000200062O000300AA03013O0004783O00AA03012O00AB0003001F3O000663000300AA03013O0004783O00AA03012O00AB000300053O0020270003000300A84O00055O00202O0005000500364O0003000500024O00048O000500013O00122O000600A93O00122O000700AA6O0005000700024O00040004000500202O0004000400AB4O00040002000200062O000400AA030100030004783O00AA03012O00AB000300093O0026D9000300AA030100140004783O00AA03012O00AB000300044O00EB00045O00202O0004000400AC4O000500053O00202O00050005000C4O00075O00202O0007000700AC4O0005000700024O000500056O00030005000200062O000300AA03013O0004783O00AA03012O00AB000300013O001253000400AD3O001253000500AE4O003E000300054O00D300036O00AB00036O0089000400013O00122O000500AF3O00122O000600B06O0004000600024O00030003000400202O0003000300094O00030002000200062O000300E903013O0004783O00E903012O00AB000300023O000663000300E903013O0004783O00E903012O00AB000300033O0026D9000300E90301000A0004783O00E903012O00AB00036O002C010400013O00122O000500B13O00122O000600B26O0004000600024O00030003000400202O0003000300B34O000300020002000E2O001400D6030100030004783O00D603012O00AB000300093O000E0F2O0100E9030100030004783O00E903012O00AB00036O00D2000400013O00122O000500B43O00122O000600B56O0004000600024O00030003000400202O0003000300AB4O0003000200024O000400053O00202O0004000400A84O00065O00202O0006000600364O00040006000200062O000300E9030100040004783O00E90301002EE800B700E9030100B60004783O00E903012O00AB000300044O00EB00045O00202O00040004000B4O000500053O00202O00050005000C4O00075O00202O00070007000B4O0005000700024O000500056O00030005000200062O000300E903013O0004783O00E903012O00AB000300013O001253000400B83O001253000500B94O003E000300054O00D300035O001253000200143O0004783O002803010004783O000700010004783O00EE03010004783O000200012O00943O00017O00DB3O00028O00025O00FAA340025O0052A440026O001840027O0040030C3O004570696353652O74696E677303083O008BBD0828B1B61B2F03043O005C2OD87C03133O004E21A973ED5E3EA073E95E33A074FC4935A95403053O009D3B52CC2003083O000B3BF7EEE0E4D4A203083O00D1585E839A898AB303143O003DB2C14F0E263D2E3B96CC7512261C2D3EA8CA7B03083O004248C1A41C7E4351026O000840026O00F03F03083O00F7C85328FB00F2D703073O0095A4AD275C926E030D3O00FE2E020D1509DA2A11181F33C303063O007B9347707F7A03083O00FFC896654FC2CA9103053O0026ACADE211030D3O0040103FFC6F103EFD44143EC77D03043O008F2D714C026O001C4003083O00B6C033F5AD10B85303083O0020E5A54781C47EDF03153O00C49BC18095D0D1A0CA9788C6CA8BCD8D88C1DAA1F403063O00B5A3E9A42OE103083O00638E2A635985396403043O001730EB5E030A3O0075D9DD7F5B3CD177F2E803073O00B21CBAB83D375303083O00E387ADE70AEDD3C303073O00B4B0E2D9936383030D3O00C6AA2A24DCB42A13E0AD2015DE03043O0067B3D94F03083O0079B208C14882A45903073O00C32AD77CB521EC030D3O00184A321D2AF60876311D2AF40903063O00986D39575E4503083O00CAD21E2OB7DC53BB03083O00C899B76AC3DEB23403103O0027F08D0E415334F781334E6A3DF48D2F03063O003A5283E85D2903083O00B052C4015431844403063O005FE337B0753D030E3O00117D3A7DAE1170307CA20C76006F03053O00CB781E432B03083O00C22059FBD0FF225E03053O00B991452D8F030F3O008C0D16BCD984300BA4EB830B1185F803053O00BCEA7F79C603083O000B370797313C149003043O00E358527303103O004010B7A216405710A8AA357A5717998303063O0013237FDAC762026O00104003083O00D429BC4C2F78E03F03063O0016874CC8384603153O009823FD1054EC8807F9364DD68424F0105CED883EEC03063O0081ED5098443D03083O0062AD10E715195F4203073O003831C864937C7703153O00C137ADE2C32C96FDCD39BAD2C938B0E2C90EAAFCC003043O0090AC5EDF03083O00170AB6532D01A55403043O0027446FC2031B3O00C3B5E2F57CBAD9B0E2E46CA5C5A3D0CE6DBFF7A0E1CB70B4C2A3E303063O00D7B6C687A71903083O001D4E2AC1581FFB3D03073O009C4E2B5EB5317103123O0067FBC1821940787CEDE1BB1B4F7661E1CBAD03073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA103123O0038FF2EFB1ADF8323E902D41CD98E21E928CE03073O00E24D8C4BBA68BC025O001CA240025O00E8904003083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA030C3O00F51027CFF6D6E5212EE8ECD003063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E989030C3O00ACA0A2399AFCE3ADB1A8139C03073O0090D9D3C77FE893025O00AAA940025O00F2AA4003083O008ACBC42B46B7C9C303053O002FD9AEB05F030B3O00ADCE7320BE5D623CB9CF7203083O0046D8BD1662D2341803083O00E9DAB793DAD4D8B003053O00B3BABFC3E703103O00EC2C1DC0EB3E1FEBF72C3AF6FC3E0CEC03043O0084995F78025O00688040025O00149540025O00C4AD40025O003AB04003083O00368C0400DD41581603073O003F65E97074B42F030B3O00D628E83BFB33E537E217EB03063O0056A35B8D729803083O00600E6067335D0C6703053O005A336B1413030B3O0098E380C63E88DC84E13E8803053O005DED90E58F025O00EEA240025O0068B240025O00CAAD4003083O0049B926608F3B7C9803083O00EB1ADC5214E6551B030C3O009DB2ECE4668DA4F3C7448DB503053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC77030F3O001ABCAB34F3E9EFD80EA39D03F6E3E903083O00B16FCFCE739F888C03083O00CB2O2A3CDC4B055703083O0024984F5E48B52562030C3O00C2CB4219C5D7542BF9D7513E03043O005FB7B82703083O00863AF3325D8E05A603073O0062D55F874634E003093O00EBB0CC5158EBB1DB6E03053O00349EC3A91703083O008C332997B9FAE4AC03073O0083DF565DE3D094030B3O00F656B39F1EACD540BFB80E03063O00D583252OD67D03083O00152E31ABE8282C3603053O0081464B45DF030C3O0053D8F6CF6EE05CCEFDC66EED03063O008F26AB93891C03083O0026F3E40D024812E503063O0026759690796B030A3O0038A8EB132EBEC0353BBA03043O005A4DDB8E03083O00D501352D45097DF503073O001A866441592C67030D3O00E4F03511A5E8CC3605B6FEF02403053O00C491835043025O00206340025O001EA040025O0030A440025O005EA94003083O002DB5121C11E619A303063O00887ED0666878030F3O006D99CB60A04733457D98DD53AA5E3103083O003118EAAE23CF325D03083O003FF7E99C7802F5EE03053O00116C929DE8030C3O005ED011CF23A958D723EC39AD03063O00C82BA3748D4F026O001440025O006C9B40025O00A88540025O002OAA4003083O001BDE499647712FC803063O001F48BB3DE22E030C3O00CA0546F0466C36CA0351FA7703073O0044A36623B2271E03083O008D75CED30ABB840203083O0071DE10BAA763D5E303093O00270DFED52102FFDE1E03043O00964E6E9B03083O0099B4F9F37EE040B903073O0027CAD18D87178E030A3O00EA200C2331FDDC3C050E03063O00989F53696A5203083O00B2C345E6C05286D503063O003CE1A63192A9030E3O003A0D2A0700142O3C2E38130E2A0C03063O00674F7E4F4A61025O00EFB140025O00E8A740025O00B8A940025O00EC964003083O00897AC7675714BD6C03063O007ADA1FB3133E030E3O00A6C5C8ECC0B357BCC4E4CCC8A64003073O0025D3B6ADA1A9C103083O00C43F59CD2175BEE403073O00D9975A2DB9481B030B3O00C270F31744F775EA177EF303053O0036A31C8772025O00689540026O00834003083O002DE561DEE3851EC503083O00B67E8015AA8AEB7903163O009EC930C1941631128EC81CE8901A230F89D339EF920A03083O0066EBBA5586E6735003083O0064092A4B7BDA254403073O0042376C5E3F12B4030B3O00019E801E245C36818A342C03063O003974EDE5574703083O002FFE1EF615F50DF103043O00827C9B6A03103O00D6C4F8AA8CF05FB0D9CFC1A6B7FE5F9B03083O00DFB5AB96CFC3961C03083O007F3FF7BA00423DF003053O00692C5A83CE03133O00ECE8BBBF1C37F1E782B61F3BEDD7BBAD001DDB03063O005E9F80D2D968025O007AA840025O00389A40025O0071B240025O0038944003083O0063FC12AB5671FE6903083O001A309966DF3F1F99030C3O001753E8D20E54E8E13649E0F603043O009362208D03083O002B46F7DE0F584C0B03073O002B782383AA6636030D3O004115829FA6B5A6551495BFA0A203073O00E43466E7D6C5D000FE022O0012533O00013O002E5A00020068000100030004783O006800010026D93O0068000100040004783O00680001001253000100013O0026D900010021000100050004783O002100010012C7000200064O00EC000300013O00122O000400073O00122O000500086O0003000500024O0002000200034O000300013O00122O000400093O00122O0005000A6O0003000500024O0002000200034O00025O00122O000200066O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200034O000300013O00122O0004000D3O00122O0005000E6O0003000500024O0002000200034O000200023O00122O0001000F3O0026D900010042000100100004783O004200010012C7000200064O00F5000300013O00122O000400113O00122O000500126O0003000500024O0002000200034O000300013O00122O000400133O00122O000500146O0003000500024O00020002000300062O00020031000100010004783O00310001001253000200014O00A0000200033O001204010200066O000300013O00122O000400153O00122O000500166O0003000500024O0002000200034O000300013O00122O000400173O00122O000500186O0003000500024O00020002000300062O00020040000100010004783O00400001001253000200014O00A0000200043O001253000100053O0026D9000100460001000F0004783O004600010012533O00193O0004783O006800010026D900010006000100010004783O000600010012C7000200064O00F5000300013O00122O0004001A3O00122O0005001B6O0003000500024O0002000200034O000300013O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300062O00020056000100010004783O00560001001253000200014O00A0000200053O001204010200066O000300013O00122O0004001E3O00122O0005001F6O0003000500024O0002000200034O000300013O00122O000400203O00122O000500216O0003000500024O00020002000300062O00020065000100010004783O00650001001253000200014O00A0000200063O001253000100103O0004783O000600010026D93O00B30001000F0004783O00B300010012C7000100064O00F0000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O000200013O00122O000300243O00122O000400256O0002000400024O0001000100022O00A0000100073O00129E000100066O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O000200013O00122O000300283O00122O000400296O0002000400022O00C40001000100022O00A0000100083O0012C7000100064O0022010200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100093O00122O000100066O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O0001000A3O00122O000100066O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O0001000B3O00122O000100066O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O0001000C3O00124O003A3O0026D93O00DA000100190004783O00DA00010012C7000100064O001C010200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O0001000D3O00122O000100066O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O000200013O00122O000300413O00122O000400426O0002000400024O0001000100024O0001000E3O00122O000100066O000200013O00122O000300433O00122O000400446O0002000400024O0001000100024O000200013O00122O000300453O00122O000400466O0002000400024O0001000100024O0001000F3O00044O00FD02010026D93O00472O0100010004783O00472O01001253000100013O000E7E000100022O0100010004783O00022O01001253000200013O0026D9000200FB000100010004783O00FB00010012C7000300064O00EC000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O000400013O00122O000500493O00122O0006004A6O0004000600024O0003000300044O000300103O00122O000300066O000400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300044O000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O000300113O00122O000200103O002EE8005000E00001004F0004783O00E000010026D9000200E0000100100004783O00E00001001253000100103O0004783O00022O010004783O00E00001000E7E000F00062O0100010004783O00062O010012533O00103O0004783O00472O010026D9000100212O0100050004783O00212O010012C7000200064O00EC000300013O00122O000400513O00122O000500526O0003000500024O0002000200034O000300013O00122O000400533O00122O000500546O0003000500024O0002000200034O000200123O00122O000200066O000300013O00122O000400553O00122O000500566O0003000500024O0002000200034O000300013O00122O000400573O00122O000500586O0003000500024O0002000200034O000200133O00122O0001000F3O002648000100252O0100100004783O00252O01002E5A005A00DD000100590004783O00DD0001001253000200013O0026D9000200412O0100010004783O00412O010012C7000300064O00EC000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000400013O00122O0005005D3O00122O0006005E6O0004000600024O0003000300044O000300143O00122O000300066O000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300044O000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O000300153O00122O000200103O000E7E001000262O0100020004783O00262O01001253000100053O0004783O00DD00010004783O00262O010004783O00DD00010026D93O00BE2O0100100004783O00BE2O01001253000100014O002O010200023O000EFF0001004F2O0100010004783O004F2O01002EE80064004B2O0100630004783O004B2O01001253000200013O0026D9000200752O0100050004783O00752O01001253000300013O002648000300572O0100010004783O00572O01002E5A006600702O0100650004783O00702O010012C7000400064O00EC000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O000400163O00122O000400066O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O000400173O00122O000300103O0026D9000300532O0100100004783O00532O010012530002000F3O0004783O00752O010004783O00532O01002EAD006F00270001006F0004783O009C2O01000E7E0010009C2O0100020004783O009C2O01001253000300013O002E5A007100802O0100700004783O00802O010026D9000300802O0100100004783O00802O01001253000200053O0004783O009C2O010026D90003007A2O0100010004783O007A2O010012C7000400064O00DC000500013O00122O000600723O00122O000700736O0005000700024O0004000400054O000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000400183O00122O000400066O000500013O00122O000600763O00122O000700776O0005000700024O0004000400054O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000400193O00122O000300103O00044O007A2O010026D9000200A02O01000F0004783O00A02O010012533O00053O0004783O00BE2O010026D9000200502O0100010004783O00502O010012C7000300064O00DC000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O0003001A3O00122O000300066O000400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300044O000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O0003001B3O00122O000200103O00044O00502O010004783O00BE2O010004783O004B2O010026D93O0023020100050004783O00230201001253000100013O0026D9000100DC2O0100050004783O00DC2O010012C7000200064O00EC000300013O00122O000400823O00122O000500836O0003000500024O0002000200034O000300013O00122O000400843O00122O000500856O0003000500024O0002000200034O0002001C3O00122O000200066O000300013O00122O000400863O00122O000500876O0003000500024O0002000200034O000300013O00122O000400883O00122O000500896O0003000500024O0002000200034O0002001D3O00122O0001000F3O0026D9000100E02O01000F0004783O00E02O010012533O000F3O0004783O00230201000E7E000100FB2O0100010004783O00FB2O010012C7000200064O00EC000300013O00122O0004008A3O00122O0005008B6O0003000500024O0002000200034O000300013O00122O0004008C3O00122O0005008D6O0003000500024O0002000200034O0002001E3O00122O000200066O000300013O00122O0004008E3O00122O0005008F6O0003000500024O0002000200034O000300013O00122O000400903O00122O000500916O0003000500024O0002000200034O0002001F3O00122O000100103O0026D9000100C12O0100100004783O00C12O01001253000200013O0026480002002O020100100004783O002O0201002EAD00920004000100930004783O00040201001253000100053O0004783O00C12O0100264800020008020100010004783O00080201002EAD009400F8FF2O00950004783O00FE2O010012C7000300064O00DC000400013O00122O000500963O00122O000600976O0004000600024O0003000300044O000400013O00122O000500983O00122O000600996O0004000600024O0003000300044O000300203O00122O000300066O000400013O00122O0005009A3O00122O0006009B6O0004000600024O0003000300044O000400013O00122O0005009C3O00122O0006009D6O0004000600024O0003000300044O000300213O00122O000200103O00044O00FE2O010004783O00C12O010026D93O009D0201009E0004783O009D0201001253000100013O0026480001002A020100050004783O002A0201002E5A009F0053020100A00004783O00530201001253000200013O002EAD00A10006000100A10004783O003102010026D900020031020100100004783O003102010012530001000F3O0004783O00530201000E7E0001002B020100020004783O002B02010012C7000300064O00F5000400013O00122O000500A23O00122O000600A36O0004000600024O0003000300044O000400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400062O00030041020100010004783O00410201001253000300014O00A0000300223O001204010300066O000400013O00122O000500A63O00122O000600A76O0004000600024O0003000300044O000400013O00122O000500A83O00122O000600A96O0004000600024O00030003000400062O00030050020100010004783O00500201001253000300014O00A0000300233O001253000200103O0004783O002B02010026D900010076020100010004783O00760201001253000200013O0026D900020071020100010004783O007102010012C7000300064O00EC000400013O00122O000500AA3O00122O000600AB6O0004000600024O0003000300044O000400013O00122O000500AC3O00122O000600AD6O0004000600024O0003000300044O000300243O00122O000300066O000400013O00122O000500AE3O00122O000600AF6O0004000600024O0003000300044O000400013O00122O000500B03O00122O000600B16O0004000600024O0003000300044O000300253O00122O000200103O0026D900020056020100100004783O00560201001253000100103O0004783O007602010004783O005602010026480001007A0201000F0004783O007A0201002E5A00B2007C020100B30004783O007C02010012533O00043O0004783O009D0201000EFF00100080020100010004783O00800201002EE800B40026020100B50004783O002602010012C7000200064O007F000300013O00122O000400B63O00122O000500B76O0003000500024O0002000200034O000300013O00122O000400B83O00122O000500B96O0003000500024O0002000200034O000200263O00122O000200066O000300013O00122O000400BA3O00122O000500BB6O0003000500024O0002000200034O000300013O00122O000400BC3O00122O000500BD6O0003000500024O00020002000300062O0002009A020100010004783O009A0201001253000200014O00A0000200273O001253000100053O0004783O002602010026D93O00010001003A0004783O00010001001253000100013O000EFF000500A4020100010004783O00A40201002EAD00BE001B000100BF0004783O00BD02010012C7000200064O00EC000300013O00122O000400C03O00122O000500C16O0003000500024O0002000200034O000300013O00122O000400C23O00122O000500C36O0003000500024O0002000200034O000200283O00122O000200066O000300013O00122O000400C43O00122O000500C56O0003000500024O0002000200034O000300013O00122O000400C63O00122O000500C76O0003000500024O0002000200034O000200293O00122O0001000F3O000E7E000100D8020100010004783O00D802010012C7000200064O00EC000300013O00122O000400C83O00122O000500C96O0003000500024O0002000200034O000300013O00122O000400CA3O00122O000500CB6O0003000500024O0002000200034O0002002A3O00122O000200066O000300013O00122O000400CC3O00122O000500CD6O0003000500024O0002000200034O000300013O00122O000400CE3O00122O000500CF6O0003000500024O0002000200034O0002002B3O00122O000100103O002E5A00D100DE020100D00004783O00DE02010026D9000100DE0201000F0004783O00DE02010012533O009E3O0004783O00010001002EE800D300A0020100D20004783O00A00201000E7E001000A0020100010004783O00A002010012C7000200064O00DC000300013O00122O000400D43O00122O000500D56O0003000500024O0002000200034O000300013O00122O000400D63O00122O000500D76O0003000500024O0002000200034O0002002C3O00122O000200066O000300013O00122O000400D83O00122O000500D96O0003000500024O0002000200034O000300013O00122O000400DA3O00122O000500DB6O0003000500024O0002000200034O0002002D3O00122O000100053O00044O00A002010004783O000100012O00943O00017O00633O00028O00026O00F03F025O003EA540025O00207540030C3O004570696353652O74696E677303083O00B0F5BE9FD4B884E303063O00D6E390CAEBBD030D3O00C9AC946B15BF7739EFB0817D2O03083O005C8DC5E71B70D33303083O00D5FA9EB7D8E8F89903053O00B1869FEAC3030B3O0099E22CB0CCB1C92AA6CFAE03053O00A9DD8B5FC003083O00ED8E6B2O2B28D99803063O0046BEEB1F5F42030B3O00AFF11FD2F7B3EC11E3F1A903053O0085DA827A8603083O000FFAF7D0D5AD3F2F03073O00585C9F83A4BCC3030A3O00953DBA79D6E8D48122AC03073O00BDE04EDF2BB78B027O0040026O000840025O00AEA140025O00F0B040026O001040025O00109240025O0010784003083O00704E0F210252A85003073O00CF232B7B556B3C03113O0058AFA1E6707EAD90E56D79A5AEC4787DAF03053O001910CAC08A034O0003083O002OCEB9F6A02OFAD803063O00949DABCD82C9030F3O002BD57A2DDDF302D27225D8F537D17003063O009643B41449B1025O009C9B40025O000CB04003083O00DF243C127283FE3F03083O004C8C4148661BED99030D3O0042DF17DEC309AD5ED518D7FF3103073O00DE2ABA76B2B76103083O006EE9509E54E2439903043O00EA3D8C24030F3O0029D8BB7E062FDA8A7D1B28D2B45A3F03053O006F41BDDA12025O0078A840025O0042AD40025O00FAB240025O004EB34003083O00C38EBE03A5BBF79803063O00D590EBCA77CC030E3O00360BDB022D22413710CD3E272D4803073O002D4378BE4A484303083O001327F9B1F086E9FA03083O008940428DC599E88E03103O0016C3278E8D02DC2BA88F33DF36AF870D03053O00E863B042C6025O00C49940025O0018A440025O0048B140025O0020A94003083O001DF99E02C820FB9903053O00A14E9CEA76030E3O00B3A5C0D2ACB2DDCF90BEDDD4849303043O00BCC7D7A903083O00CF0C4B6FE1F20E4C03053O00889C693F1B030D3O00098D7A3D1A806A03129871173F03043O00547BEC19025O00709840025O006CAC40025O0014A340025O00CCAF4003083O0026A7EB0C321BA5EC03053O005B75C29F7803163O0033132A1D27E3310A09111639E81312142A1D39F8370E03073O00447A7D5E78559103083O002419DB4AC1D7BD0403073O00DA777CAF3EA8B903123O008CFE5CC1B7E25DD4B1C440D6A0E340CBA9F403043O00A4C59028026O00AF40025O00F09040025O0029B040025O003C9C4003083O00BE4CFE5C8447ED5B03043O0028ED298A03113O00C17DFDF05EF571F7F943C967D9F04FC47F03053O002AA7149A9803083O0079FBB656782F4DED03063O00412A9EC2221103113O00332946093FFF0EFE0E105B1825DE0FFB1403083O008E7A47326C4D8D7B03083O00BE1D0E5984161D5E03043O002DED787A03113O00FFE9AC28DBED8B22D4E7B03CD8FAA72DDB03043O004CB788C20047012O0012533O00014O003O0100013O0026D93O0002000100010004783O00020001001253000100013O00264800010009000100020004783O00090001002EAD00030033000100040004783O003A00010012C7000200054O0022010300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O00025O00122O000200056O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000200023O00122O000200056O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300013O00122O000400103O00122O000500116O0003000500024O0002000200034O000200033O00122O000200056O000300013O00122O000400123O00122O000500136O0003000500024O0002000200034O000300013O00122O000400143O00122O000500156O0003000500024O0002000200034O000200043O00122O000100163O000E7E0017008F000100010004783O008F0001001253000200013O002E5A00180043000100190004783O004300010026D900020043000100160004783O004300010012530001001A3O0004783O008F000100264800020047000100020004783O00470001002E5A001B00630001001C0004783O006300010012C7000300054O00F5000400013O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000400013O00122O0005001F3O00122O000600206O0004000600024O00030003000400062O00030055000100010004783O00550001001253000300214O00A0000300053O00129E000300056O000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000400013O00122O000500243O00122O000600256O0004000600022O00C40003000300042O00A0000300063O001253000200163O0026D90002003D000100010004783O003D0001001253000300013O0026480003006A000100010004783O006A0001002EE800270089000100260004783O008900010012C7000400054O00F5000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000500013O00122O0006002A3O00122O0007002B6O0005000700024O00040004000500062O00040078000100010004783O00780001001253000400014O00A0000400073O001204010400056O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500062O00040087000100010004783O00870001001253000400014O00A0000400083O001253000300023O000E7E00020066000100030004783O00660001001253000200023O0004783O003D00010004783O006600010004783O003D00010026D9000100E5000100160004783O00E50001001253000200013O002EE8003000B9000100310004783O00B900010026D9000200B9000100020004783O00B90001001253000300013O0026480003009B000100020004783O009B0001002EAD00320004000100330004783O009D0001001253000200163O0004783O00B900010026D900030097000100010004783O009700010012C7000400054O00DC000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000400093O00122O000400056O000500013O00122O000600383O00122O000700396O0005000700024O0004000400054O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O0004000A3O00122O000300023O00044O00970001002E5A003C00BF0001003D0004783O00BF0001000E7E001600BF000100020004783O00BF0001001253000100173O0004783O00E50001002648000200C3000100010004783O00C30001002E5A003E00920001003F0004783O00920001001253000300013O0026D9000300DF000100010004783O00DF00010012C7000400054O00EC000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O0004000B3O00122O000400056O000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O0004000C3O00122O000300023O000E7E000200C4000100030004783O00C40001001253000200023O0004783O009200010004783O00C400010004783O00920001002648000100E9000100010004783O00E90001002EE8004900342O0100480004783O00342O01001253000200014O002O010300033O0026D9000200EB000100010004783O00EB0001001253000300013O002EE8004A000B2O01004B0004783O000B2O010026D90003000B2O0100020004783O000B2O010012C7000400054O00EC000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O0004000D3O00122O000400056O000500013O00122O000600503O00122O000700516O0005000700024O0004000400054O000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O0004000E3O00122O000300163O0026480003000F2O0100160004783O000F2O01002E5A005400112O0100550004783O00112O01001253000100023O0004783O00342O01002648000300152O0100010004783O00152O01002EE8005600EE000100570004783O00EE00010012C7000400054O00F5000500013O00122O000600583O00122O000700596O0005000700024O0004000400054O000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500062O000400232O0100010004783O00232O01001253000400014O00A00004000F3O0012C7000400054O00B6000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000400103O00122O000300023O00044O00EE00010004783O00342O010004783O00EB0001000E7E001A0005000100010004783O000500010012C7000200054O0082000300013O00122O000400603O00122O000500616O0003000500024O0002000200034O000300013O00122O000400623O00122O000500636O0003000500024O0002000200034O000200113O00044O00462O010004783O000500010004783O00462O010004783O000200012O00943O00017O00CD3O00028O00026O00F03F025O00B07B40025O00D09640025O0026A540025O00E06F40030C3O004570696353652O74696E677303073O004EE9E23F5C4A0703073O00741A868558302F2O033O0011CEA303063O00127EA1C084DD025O001CAF40025O00F4B240027O0040025O0041B240030D3O004973446561644F7247686F737403173O00476574456E656D696573496E53706C61736852616E6765026O001440030F3O00456E656D69657334307952616E676503113O00476574456E656D696573496E52616E6765026O004440026O000840025O00DEA640025O00B6A740025O0053B140025O00A49E40025O0058AB40025O00B88340031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O00C89C40025O00E8AE40030F3O00412O66656374696E67436F6D626174030F3O00E61C561FC90B7C10D30B5912C20D4103043O007EA76E35030A3O0049734361737461626C6503083O0042752O66446F776E030F3O00417263616E65496E74652O6C65637403103O0047726F757042752O664D692O73696E67025O0096A040025O0068974003103O003C022DF9D23A021920ECD93331152DEC03063O005F5D704E98BC030D3O00546172676574497356616C6964025O00EC9E40025O00109E40025O00408A40025O00FCB040030A3O0042752O66537461636B50030B3O00496369636C657342752O662O033O00474344025O00E7B140025O0093B140024O0080B3C540030C3O00466967687452656D61696E73030B3O00446562752O66537461636B03123O0057696E746572734368692O6C446562752O66025O007DB040025O0042B040025O0034A640025O00E3B240025O00549640025O0006AE4003103O00426F2O73466967687452656D61696E73026O001040025O008AA440025O00CAA740025O00EEAA40025O00B2A64003073O00C1F720254FF0EB03053O00239598474203063O001DE151A03F1503053O005A798822D0025O0002A640025O0008804003073O006B27A9032O5A3B03053O00363F48CE642O033O00C9564003063O001BA839251A8503073O0019A57BAFDB28B903053O00B74DCA1CC82O033O0014379A03043O00687753E9025O00E08640025O00ECA340025O0022A840025O00806440025O00BC9640025O00E4AE40025O00C06240025O00F2A840025O009CAD40025O00F07C40025O0046AB40025O00EAA340025O0018A040025O002EAF40025O00CCA840025O00A8A940025O00249C40030C3O0049734368612O6E656C696E6703093O00497343617374696E67025O007BB040025O00CDB040025O0060AD40025O00206E4003043O00502O6F6C025O00D89840025O00B08F40030D3O00EB11D6EE7624C2E95EEAD67E6B03073O00AD9B7EB9825642025O00149040025O0070A140025O00CC9C40025O0050B040025O00688540025O0075B240025O00B4A840026O001C4003073O0048617354696572026O003E4003093O00ACE0EAFA02AA89E6FD03063O00C6E5838FB963030B3O004973417661696C61626C65025O0063B040025O005EA940025O0062AD40025O006EA040025O0074B040025O00805840025O00708440025O0002A740030E3O004183A77F118AA76111ADA77619C503043O001331ECC8025O0084A240025O00CCB140025O006CA340025O009CAA40025O00108040025O000EA240025O0044A440025O00C1B140025O0098B04003113O00EE38F9BBA4BCF125B694E8BFFF21F3FFAD03063O00DA9E5796D784025O006C9A40025O00D88740025O002FB040025O001C9340025O001AA740025O00AAA340025O00788540025O0015B040025O00407240025O00889C40025O00AEB040025O009C9840025O00789F40025O00405F40025O004DB040025O00349D40025O00D07740025O00F8AD40025O00E0A940025O0012A940025O00489240026O002O40030B3O00F3F0881AF2BBF1D4E7961003073O00B2A195E57584DE03073O004973526561647903093O00466F637573556E6974026O003440025O0050AA40025O00808740030F3O0048616E646C65412O666C6963746564030B3O0052656D6F7665437572736503143O0052656D6F766543757273654D6F7573656F766572025O0034AE40025O00989640025O00D2AD40025O008AA240025O004CB140025O00C07F40025O001CB240025O00B09440025O00107A40025O0059B040025O00307C40025O0060A240025O00349540025O009EA54003113O0048616E646C65496E636F72706F7265616C03093O00506F6C796D6F72706803123O00506F6C796D6F7270684D6F7573654F766572025O0064AA40030A3O00BBCBD8A0AD05B22689D703083O0043E8BBBDCCC176C6030A3O00B83EB02C3711FB8E2FB903073O008FEB4ED5405B6203103O00556E69744861734D6167696342752O66025O00F8AA40025O0078AB40030A3O005370652O6C737465616C030E3O0049735370652O6C496E52616E676503113O009E5881E57CA5994D85E530B28C4585EE7503063O00D6ED28E489100016042O0012533O00014O003O0100023O000E7E0001000700013O0004783O00070001001253000100014O002O010200023O0012533O00023O0026D93O0002000100020004783O000200010026480001000D000100010004783O000D0001002E5A00040009000100030004783O00090001001253000200013O00264800020012000100010004783O00120001002EE800050031000100060004783O00310001001253000300014O002O010400043O0026D900030014000100010004783O00140001001253000400013O0026D90004001E000100010004783O001E00012O00AB00056O007D0005000100012O00AB000500014O007D000500010001001253000400023O0026D900040017000100020004783O001700010012C7000500074O00B6000600033O00122O000700083O00122O000800096O0006000800024O0005000500064O000600033O00122O0007000A3O00122O0008000B6O0006000800024O0005000500064O000500023O00122O000200023O00044O003100010004783O001700010004783O003100010004783O00140001002E5A000C00480001000D0004783O004800010026D9000200480001000E0004783O00480001002EAD000F00080001000F0004783O003D00012O00AB000300043O00200A0003000300102O00190103000200020006630003003D00013O0004783O003D00012O00943O00014O00AB000300063O00205900030003001100122O000500126O0003000500024O000300056O000300043O00202O00030003001400122O000500156O00030005000200122O000300133O00122O000200163O0026D90002003D2O0100160004783O003D2O01001253000300013O002EE8001700C9000100180004783O00C900010026D9000300C9000100010004783O00C90001001253000400013O0026D9000400C4000100010004783O00C400012O00AB000500073O0006630005008000013O0004783O00800001001253000500014O002O010600073O0026D900050079000100020004783O00790001002E5A001A0059000100190004783O005900010026D900060059000100010004783O00590001001253000700013O00264800070062000100010004783O00620001002E5A001B005E0001001C0004783O005E00012O00AB000800094O0071000900063O00202O00090009001D00122O000B00126O0009000B000200122O000A00136O000A000A6O0008000A00024O000800086O000800096O000900063O00200A00090009001D001211000B00126O0009000B000200122O000A00136O000A000A6O0008000A00024O0008000A3O00044O009800010004783O005E00010004783O009800010004783O005900010004783O009800010026D900050057000100010004783O00570001001253000600014O002O010700073O001253000500023O0004783O005700010004783O00980001001253000500013O0026D900050086000100020004783O00860001001253000600024O00A00006000A3O0004783O00980001000E7E00010081000100050004783O00810001001253000600013O0026D90006008D000100020004783O008D0001001253000500023O0004783O00810001002EE8001E00890001001F0004783O008900010026D900060089000100010004783O00890001001253000700024O00E10007000B3O00122O000700026O000700083O00122O000600023O00044O008900010004783O008100012O00AB000500043O00200A0005000500202O0019010500020002000630000500C3000100010004783O00C300012O00AB0005000C4O0089000600033O00122O000700213O00122O000800226O0006000800024O00050005000600202O0005000500234O00050002000200062O000500C300013O0004783O00C300012O00AB000500043O0020310005000500244O0007000C3O00202O0007000700254O000800016O00050008000200062O000500B6000100010004783O00B600012O00AB0005000D3O0020B90005000500264O0006000C3O00202O0006000600254O00050002000200062O000500C300013O0004783O00C30001002E5A002800C3000100270004783O00C300012O00AB0005000E4O00AB0006000C3O0020240006000600252O0019010500020002000663000500C300013O0004783O00C300012O00AB000500033O001253000600293O0012530007002A4O003E000500074O00D300055O001253000400023O0026D900040050000100020004783O00500001001253000300023O0004783O00C900010004783O005000010026D90003004B000100020004783O004B00012O00AB0004000D3O00202400040004002B2O00FC000400010002000630000400D5000100010004783O00D500012O00AB000400043O00200A0004000400202O00190104000200020006630004003A2O013O0004783O003A2O01001253000400014O002O010500063O002648000400DB000100010004783O00DB0001002EAD002C00050001002D0004783O00DE0001001253000500014O002O010600063O001253000400023O000EFF000200E2000100040004783O00E20001002EE8002F00D70001002E0004783O00D700010026D9000500E2000100010004783O00E20001001253000600013O0026D9000600F20001000E0004783O00F200012O00AB000700043O0020AE0007000700304O0009000C3O00202O0009000900314O0007000900024O0007000F6O000700043O00202O0007000700324O0007000200024O000700103O00044O003A2O010026D9000600102O0100020004783O00102O01001253000700013O002EE8003400092O0100330004783O00092O010026D9000700092O0100010004783O00092O012O00AB000800113O0026D9000800022O0100350004783O00022O012O00AB000800123O00201F01080008003600122O000900136O000A8O0008000A00024O000800114O00AB000800063O00200A0108000800374O000A000C3O00202O000A000A00384O0008000A00024O000800133O00122O000700023O002EE8003A00F5000100390004783O00F500010026D9000700F5000100020004783O00F500010012530006000E3O0004783O00102O010004783O00F500010026D9000600E5000100010004783O00E50001001253000700014O002O010800083O002EE8003B00142O01003C0004783O00142O01000E7E000100142O0100070004783O00142O01001253000800013O000EFF0001001D2O0100080004783O001D2O01002E5A003E002E2O01003D0004783O002E2O01001253000900013O0026D9000900292O0100010004783O00292O012O00AB000A00123O00203C000A000A003F4O000B000B6O000C00016O000A000C00024O000A00146O000A00146O000A00113O00122O000900023O0026D90009001E2O0100020004783O001E2O01001253000800023O0004783O002E2O010004783O001E2O010026D9000800192O0100020004783O00192O01001253000600023O0004783O00E500010004783O00192O010004783O00E500010004783O00142O010004783O00E500010004783O003A2O010004783O00E200010004783O003A2O010004783O00D70001001253000200403O0004783O003D2O010004783O004B0001002648000200412O0100020004783O00412O01002EE8004200722O0100410004783O00722O01001253000300013O002E5A004400542O0100430004783O00542O010026D9000300542O0100020004783O00542O010012C7000400074O00B6000500033O00122O000600453O00122O000700466O0005000700024O0004000400054O000500033O00122O000600473O00122O000700486O0005000700024O0004000400054O000400153O00122O0002000E3O00044O00722O01002648000300582O0100010004783O00582O01002EE8004900422O01004A0004783O00422O010012C7000400074O00DC000500033O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O000500033O00122O0006004D3O00122O0007004E6O0005000700024O0004000400054O000400073O00122O000400076O000500033O00122O0006004F3O00122O000700506O0005000700024O0004000400054O000500033O00122O000600513O00122O000700526O0005000700024O0004000400054O000400163O00122O000300023O00044O00422O01002648000200762O0100400004783O00762O01002E5A0054000E000100530004783O000E0001002EE800560015040100550004783O001504012O00AB0003000D3O00202400030003002B2O00FC0003000100020006630003001504013O0004783O00150401001253000300014O002O010400053O002E5A005700862O0100580004783O00862O01000E7E000100862O0100030004783O00862O01001253000400014O002O010500053O001253000300023O002EAD005900F9FF2O00590004783O007F2O01000E7E0002007F2O0100030004783O007F2O01002E5A005A008A2O01005B0004783O008A2O010026D90004008A2O0100010004783O008A2O01001253000500013O000EFF000200932O0100050004783O00932O01002EAD005C00270001005D0004783O00B82O01001253000600014O002O010700073O002E5A005F00952O01005E0004783O00952O010026D9000600952O0100010004783O00952O01001253000700013O0026D9000700B12O0100010004783O00B12O01001253000800013O002E5A006100A32O0100600004783O00A32O010026D9000800A32O0100020004783O00A32O01001253000700023O0004783O00B12O010026D90008009D2O0100010004783O009D2O012O00AB000900184O00FC0009000100022O00A0000900174O00AB000900173O000630000900AD2O0100010004783O00AD2O01002E5A006200AF2O0100630004783O00AF2O012O00AB000900174O0028010900023O001253000800023O0004783O009D2O010026D90007009A2O0100020004783O009A2O010012530005000E3O0004783O00B82O010004783O009A2O010004783O00B82O010004783O00952O01000E7E004000D3020100050004783O00D302012O00AB000600043O00200A0006000600202O00190106000200020006630006001504013O0004783O001504012O00AB0006000D3O00202400060006002B2O00FC0006000100020006630006001504013O0004783O001504012O00AB000600043O00200A0006000600642O001901060002000200063000060015040100010004783O001504012O00AB000600043O00200A0006000600652O001901060002000200063000060015040100010004783O00150401001253000600013O002E5A006600E82O0100670004783O00E82O010026D9000600E82O01000E0004783O00E82O012O00AB000700173O000630000700D82O0100010004783O00D82O01002EE8006800DA2O0100690004783O00DA2O012O00AB000700174O0028010700024O00AB0007000E4O00AB0008000C3O00202400080008006A2O0019010700020002000630000700E22O0100010004783O00E22O01002E5A006B00E72O01006C0004783O00E72O012O00AB000700033O0012530008006D3O0012530009006E4O003E000700094O00D300075O001253000600163O0026D900060059020100010004783O005902012O00AB000700163O000630000700EF2O0100010004783O00EF2O01002E5A007000080201006F0004783O00080201001253000700014O002O010800083O002648000700F52O0100010004783O00F52O01002E5A007200F12O0100710004783O00F12O01001253000800013O002648000800FA2O0100010004783O00FA2O01002EE8007400F62O0100730004783O00F62O012O00AB000900194O00FC0009000100022O00A0000900173O002EAD0075000B000100750004783O000802012O00AB000900173O0006630009000802013O0004783O000802012O00AB000900174O0028010900023O0004783O000802010004783O00F62O010004783O000802010004783O00F12O012O00AB000700073O0006630007002202013O0004783O002202012O00AB0007000A3O000E6E00760015020100070004783O001502012O00AB000700043O00203900070007007700122O000900783O00122O000A000E6O0007000A000200062O0007002402013O0004783O002402012O00AB0007000A3O000E6E00160022020100070004783O002202012O00AB0007000C4O002E010800033O00122O000900793O00122O000A007A6O0008000A00024O00070007000800202O00070007007B4O00070002000200062O00070024020100010004783O00240201002EAD007C00360001007D0004783O00580201001253000700014O002O010800093O0026480007002A020100020004783O002A0201002EE8007E00500201007F0004783O005002010026D90008002A020100010004783O002A0201001253000900013O00264800090031020100020004783O00310201002E5A0080003F020100810004783O003F0201002EE800820058020100830004783O005802012O00AB000A000E4O00AB000B000C3O002024000B000B006A2O0019010A00020002000663000A005802013O0004783O005802012O00AB000A00033O00128F000B00843O00122O000C00856O000A000C6O000A5O00044O005802010026D90009002D020100010004783O002D02012O00AB000A001A4O00FC000A000100022O00A0000A00174O00AB000A00173O000630000A0049020100010004783O00490201002EAD00860004000100870004783O004B02012O00AB000A00174O0028010A00023O001253000900023O0004783O002D02010004783O005802010004783O002A02010004783O00580201002E5A00880026020100890004783O002602010026D900070026020100010004783O00260201001253000800014O002O010900093O001253000700023O0004783O00260201001253000600023O0026480006005D020100020004783O005D0201002E5A008B00A90201008A0004783O00A902012O00AB000700073O000663000700A502013O0004783O00A502012O00AB0007000A3O0026D9000700A50201000E0004783O00A50201001253000700014O002O010800093O002EE80057009D0201008C0004783O009D02010026D90007009D020100020004783O009D02010026D900080069020100010004783O00690201001253000900013O000E7E0002007C020100090004783O007C0201002EE8008E00A50201008D0004783O00A502012O00AB000A000E4O00AB000B000C3O002024000B000B006A2O0019010A00020002000663000A00A502013O0004783O00A502012O00AB000A00033O00128F000B008F3O00122O000C00906O000A000C6O000A5O00044O00A50201002EAD009100F0FF2O00910004783O006C02010026D90009006C020100010004783O006C0201001253000A00014O002O010B000B3O002648000A0086020100010004783O00860201002EE800930082020100920004783O00820201001253000B00013O0026D9000B0092020100010004783O009202012O00AB000C001B4O00FC000C000100022O00A0000C00174O00AB000C00173O000663000C009102013O0004783O009102012O00AB000C00174O0028010C00023O001253000B00023O0026D9000B0087020100020004783O00870201001253000900023O0004783O006C02010004783O008702010004783O006C02010004783O008202010004783O006C02010004783O00A502010004783O006902010004783O00A50201002EAD009400C8FF2O00940004783O006502010026D900070065020100010004783O00650201001253000800014O002O010900093O001253000700023O0004783O006502012O00AB0007001C4O00FC0007000100022O00A0000700173O0012530006000E3O0026D9000600CF2O0100160004783O00CF2O012O00AB0007001D3O0006630007001504013O0004783O00150401001253000700014O002O010800093O002648000700B4020100020004783O00B40201002EE8009500CA020100960004783O00CA0201002EE8009700B4020100980004783O00B402010026D9000800B4020100010004783O00B40201001253000900013O0026D9000900B9020100010004783O00B902012O00AB000A001E4O00FC000A000100022O00A0000A00173O002EAD009900572O0100990004783O001504012O00AB000A00173O000663000A001504013O0004783O001504012O00AB000A00174O0028010A00023O0004783O001504010004783O00B902010004783O001504010004783O00B402010004783O001504010026D9000700B0020100010004783O00B00201001253000800014O002O010900093O001253000700023O0004783O00B002010004783O001504010004783O00CF2O010004783O001504010026D90005005D0301000E0004783O005D0301001253000600013O002EAD009A00060001009A0004783O00DC0201000E7E000200DC020100060004783O00DC0201001253000500163O0004783O005D0301002EE8009C00D60201009B0004783O00D602010026D9000600D6020100010004783O00D60201002E5A009E003A0301009D0004783O003A03012O00AB000700043O00200A0007000700202O0019010700020002000630000700EA020100010004783O00EA02012O00AB0007001F3O0006630007003A03013O0004783O003A0301001253000700014O002O0108000A3O0026D900070034030100020004783O003403012O002O010A000A3O000E7E000100FC020100080004783O00FC0201001253000B00013O0026D9000B00F7020100010004783O00F70201001253000900014O002O010A000A3O001253000B00023O0026D9000B00F2020100020004783O00F20201001253000800023O0004783O00FC02010004783O00F202010026D9000800EF020100020004783O00EF0201002E5A00A0000A0301009F0004783O000A0301000E7E0002000A030100090004783O000A03012O00AB000B00173O000630000B0007030100010004783O00070301002E5A00A2003A030100A10004783O003A03012O00AB000B00174O0028010B00023O0004783O003A03010026480009000E030100010004783O000E0301002E5A00A300FE020100A40004783O00FE0201001253000B00013O000E7E000200130301000B0004783O00130301001253000900023O0004783O00FE0201002E5A00A6000F030100A50004783O000F03010026D9000B000F030100010004783O000F03012O00AB000C001F3O000688000A00250301000C0004783O002503012O00AB000C000C4O0037000D00033O00122O000E00A73O00122O000F00A86O000D000F00024O000C000C000D00202O000C000C00A94O000C0002000200062O000A00250301000C0004783O002503012O00AB000A00154O00AB000C000D3O00204E000C000C00AA4O000D000A6O000E00203O00122O000F00AB6O001000103O00122O001100AB6O000C001100024O000C00173O00122O000B00023O00044O000F03010004783O00FE02010004783O003A03010004783O00EF02010004783O003A03010026D9000700EC020100010004783O00EC0201001253000800014O002O010900093O001253000700023O0004783O00EC02012O00AB000700213O0006630007005B03013O0004783O005B03012O00AB000700223O0006630007005B03013O0004783O005B0301001253000700014O002O010800083O000E7E00010042030100070004783O00420301001253000800013O00264800080049030100010004783O00490301002E5A00AC0045030100AD0004783O004503012O00AB0009000D3O0020260109000900AE4O000A000C3O00202O000A000A00AF4O000B00203O00202O000B000B00B000122O000C00786O0009000C00024O000900176O000900173O00062O0009005B03013O0004783O005B03012O00AB000900174O0028010900023O0004783O005B03010004783O004503010004783O005B03010004783O00420301001253000600023O0004783O00D602010026D9000500A0030100010004783O00A00301001253000600014O002O010700073O002EAD00B13O000100B10004783O006103010026D900060061030100010004783O00610301001253000700013O0026480007006A030100020004783O006A0301002EAD00B20004000100B30004783O006C0301001253000500023O0004783O00A0030100264800070070030100010004783O00700301002E5A00B50066030100B40004783O006603012O00AB000800233O0006630008008303013O0004783O008303012O00AB0008001F3O0006630008008303013O0004783O00830301001253000800013O0026D900080077030100010004783O007703012O00AB000900244O00FC0009000100022O00A0000900174O00AB000900173O0006630009008303013O0004783O008303012O00AB000900174O0028010900023O0004783O008303010004783O00770301002EE800B6009C030100B70004783O009C03012O00AB000800043O00200A0008000800202O00190108000200020006300008009C030100010004783O009C03012O00AB000800023O0006630008009C03013O0004783O009C0301001253000800013O002EAD00B83O000100B80004783O008E03010026D90008008E030100010004783O008E03012O00AB000900254O00FC0009000100022O00A0000900174O00AB000900173O0006630009009C03013O0004783O009C03012O00AB000900174O0028010900023O0004783O009C03010004783O008E0301001253000700023O0004783O006603010004783O00A003010004783O00610301002EE800B9008F2O0100BA0004783O008F2O010026D90005008F2O0100160004783O008F2O01001253000600013O002E5A00BB00AB030100BC0004783O00AB03010026D9000600AB030100020004783O00AB0301001253000500403O0004783O008F2O010026D9000600A5030100010004783O00A503012O00AB000700263O000663000700C803013O0004783O00C80301001253000700013O002EE800BD00B1030100BE0004783O00B103010026D9000700B1030100010004783O00B103012O00AB0008000D3O0020140108000800BF4O0009000C3O00202O0009000900C04O000A00203O00202O000A000A00C100122O000B00786O000C00016O0008000C00024O000800173O002E2O000400C8030100C20004783O00C803012O00AB000800173O000663000800C803013O0004783O00C803012O00AB000800174O0028010800023O0004783O00C803010004783O00B103012O00AB0007000C4O0089000800033O00122O000900C33O00122O000A00C46O0008000A00024O00070007000800202O00070007007B4O00070002000200062O000700F503013O0004783O00F503012O00AB000700273O000663000700F503013O0004783O00F503012O00AB0007000C4O0089000800033O00122O000900C53O00122O000A00C66O0008000A00024O00070007000800202O0007000700A94O00070002000200062O000700F503013O0004783O00F503012O00AB000700153O000663000700F503013O0004783O00F503012O00AB000700283O000663000700F503013O0004783O00F503012O00AB000700043O00200A0007000700652O0019010700020002000630000700F5030100010004783O00F503012O00AB000700043O00200A0007000700642O0019010700020002000630000700F5030100010004783O00F503012O00AB0007000D3O0020240007000700C72O00AB000800064O0019010700020002000630000700F7030100010004783O00F70301002EE800C90008040100C80004783O000804012O00AB0007000E4O00EB0008000C3O00202O0008000800CA4O000900063O00202O0009000900CB4O000B000C3O00202O000B000B00CA4O0009000B00024O000900096O00070009000200062O0007000804013O0004783O000804012O00AB000700033O001253000800CC3O001253000900CD4O003E000700094O00D300075O001253000600023O0004783O00A503010004783O008F2O010004783O001504010004783O008A2O010004783O001504010004783O007F2O010004783O001504010004783O000E00010004783O001504010004783O000900010004783O001504010004783O000200012O00943O00017O000B3O00028O00025O0052AE40025O00889D40026O00F03F025O00C0A140025O0098AC40025O00DCA740025O00089E4003053O005072696E7403323O00C3B4B5D49CACC8A7BDC2C8FEEAB2BBD381E3EBE6B8DEC8C9F5AFB989C8DFF0B6AAC89AF8E0A2FAC591ACFD8DBBC98DF8EAE803063O008C85C6DAA7E800243O0012533O00014O003O0100023O0026483O0006000100010004783O00060001002EE800020009000100030004783O00090001001253000100014O002O010200023O0012533O00043O0026483O000D000100040004783O000D0001002E5A00060002000100050004783O0002000100264800010011000100010004783O00110001002E5A0007000D000100080004783O000D0001001253000200013O0026D900020012000100010004783O001200012O00AB00036O00210103000100014O000300013O00202O0003000300094O000400023O00122O0005000A3O00122O0006000B6O000400066O00033O000100044O002300010004783O001200010004783O002300010004783O000D00010004783O002300010004783O000200012O00943O00017O00", GetFEnv(), ...);

