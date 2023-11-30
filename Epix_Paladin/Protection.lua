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
				if (Enum <= 132) then
					if (Enum <= 65) then
						if (Enum <= 32) then
							if (Enum <= 15) then
								if (Enum <= 7) then
									if (Enum <= 3) then
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
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 6) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
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
									elseif (Enum > 10) then
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
									if (Enum > 12) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum == 14) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum > 16) then
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
										elseif (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 18) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 21) then
									if (Enum == 20) then
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 22) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum == 24) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 26) then
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
							elseif (Enum <= 29) then
								if (Enum == 28) then
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 31) then
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
						elseif (Enum <= 48) then
							if (Enum <= 40) then
								if (Enum <= 36) then
									if (Enum <= 34) then
										if (Enum == 33) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 35) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 38) then
									if (Enum > 37) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										if (Inst[2] < Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 44) then
								if (Enum <= 42) then
									if (Enum == 41) then
										do
											return Stk[Inst[2]];
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
								elseif (Enum == 43) then
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
							elseif (Enum <= 46) then
								if (Enum == 45) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 47) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 56) then
							if (Enum <= 52) then
								if (Enum <= 50) then
									if (Enum > 49) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum == 51) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 54) then
								if (Enum > 53) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 60) then
							if (Enum <= 58) then
								if (Enum > 57) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum > 59) then
								VIP = Inst[3];
							else
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
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
								A = Inst[2];
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
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 63) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 64) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 98) then
						if (Enum <= 81) then
							if (Enum <= 73) then
								if (Enum <= 69) then
									if (Enum <= 67) then
										if (Enum == 66) then
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
											if (Inst[2] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 68) then
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
									if (Enum == 70) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 72) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 77) then
								if (Enum <= 75) then
									if (Enum > 74) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										VIP = Inst[3];
									elseif (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 76) then
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
							elseif (Enum <= 79) then
								if (Enum > 78) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Inst[2] == Stk[Inst[4]]) then
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
									if (Mvm[1] == 107) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 89) then
							if (Enum <= 85) then
								if (Enum <= 83) then
									if (Enum == 82) then
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
										if (Inst[2] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 84) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								end
							elseif (Enum <= 87) then
								if (Enum == 86) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum == 88) then
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
						elseif (Enum <= 93) then
							if (Enum <= 91) then
								if (Enum == 90) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 92) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Inst[2] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 95) then
							if (Enum > 94) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 96) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 97) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 115) then
						if (Enum <= 106) then
							if (Enum <= 102) then
								if (Enum <= 100) then
									if (Enum == 99) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 101) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum > 103) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 105) then
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
						elseif (Enum <= 110) then
							if (Enum <= 108) then
								if (Enum > 107) then
									do
										return;
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]];
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
						elseif (Enum <= 112) then
							if (Enum == 111) then
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
							end
						elseif (Enum <= 113) then
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
						elseif (Enum > 114) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 123) then
						if (Enum <= 119) then
							if (Enum <= 117) then
								if (Enum > 116) then
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
							elseif (Enum == 118) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 121) then
							if (Enum > 120) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 122) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 127) then
						if (Enum <= 125) then
							if (Enum == 124) then
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
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
						elseif (Enum == 126) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 129) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 130) then
						Stk[Inst[2]] = {};
					elseif (Enum > 131) then
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
						Upvalues[Inst[3]] = Stk[Inst[2]];
					end
				elseif (Enum <= 199) then
					if (Enum <= 165) then
						if (Enum <= 148) then
							if (Enum <= 140) then
								if (Enum <= 136) then
									if (Enum <= 134) then
										if (Enum > 133) then
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
											if (Inst[2] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 135) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
									end
								elseif (Enum <= 138) then
									if (Enum > 137) then
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
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 139) then
									local A = Inst[2];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 144) then
								if (Enum <= 142) then
									if (Enum == 141) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 143) then
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
									Env[Inst[3]] = Stk[Inst[2]];
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 146) then
								if (Enum == 145) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum == 147) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							end
						elseif (Enum <= 156) then
							if (Enum <= 152) then
								if (Enum <= 150) then
									if (Enum == 149) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
											return Stk[Inst[2]]();
										end
									end
								elseif (Enum > 151) then
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 154) then
								if (Enum > 153) then
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
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 155) then
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
						elseif (Enum <= 160) then
							if (Enum <= 158) then
								if (Enum > 157) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 159) then
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
						elseif (Enum <= 162) then
							if (Enum > 161) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 163) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 164) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 182) then
						if (Enum <= 173) then
							if (Enum <= 169) then
								if (Enum <= 167) then
									if (Enum > 166) then
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
								elseif (Enum > 168) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								if (Enum == 170) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum == 172) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 177) then
							if (Enum <= 175) then
								if (Enum == 174) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum == 176) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 179) then
							if (Enum == 178) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 180) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 181) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 190) then
						if (Enum <= 186) then
							if (Enum <= 184) then
								if (Enum == 183) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 185) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 188) then
							if (Enum > 187) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 189) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Inst[2] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 194) then
						if (Enum <= 192) then
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
						elseif (Enum > 193) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						else
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Stk[Inst[4]]];
						end
					elseif (Enum <= 196) then
						if (Enum > 195) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 197) then
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Stk[A + 1]));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					elseif (Enum > 198) then
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
				elseif (Enum <= 232) then
					if (Enum <= 215) then
						if (Enum <= 207) then
							if (Enum <= 203) then
								if (Enum <= 201) then
									if (Enum == 200) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum > 202) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
								elseif (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 205) then
								if (Enum == 204) then
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum > 206) then
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
							if (Enum <= 209) then
								if (Enum == 208) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 210) then
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
						elseif (Enum <= 213) then
							if (Enum > 212) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 214) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 223) then
						if (Enum <= 219) then
							if (Enum <= 217) then
								if (Enum == 216) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 218) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum > 220) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum == 222) then
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
					elseif (Enum <= 227) then
						if (Enum <= 225) then
							if (Enum == 224) then
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
						elseif (Enum == 226) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 229) then
						if (Enum == 228) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 230) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 231) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 249) then
					if (Enum <= 240) then
						if (Enum <= 236) then
							if (Enum <= 234) then
								if (Enum > 233) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 235) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 238) then
							if (Enum > 237) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 239) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 244) then
						if (Enum <= 242) then
							if (Enum > 241) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 243) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 246) then
						if (Enum == 245) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
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
					elseif (Enum <= 247) then
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 248) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 257) then
					if (Enum <= 253) then
						if (Enum <= 251) then
							if (Enum == 250) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum > 252) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 255) then
						if (Enum == 254) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 256) then
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
				elseif (Enum <= 261) then
					if (Enum <= 259) then
						if (Enum == 258) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum == 260) then
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
				elseif (Enum <= 263) then
					if (Enum > 262) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 264) then
					if (Inst[2] < Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 265) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD98BC612D0C7D22BD98BD511C5C6D831EFB4C950DDD6DA03083O007EB1A3BB4586DBA7031B3O00F592B0EB3CD3D5DC83BDFA0DDCE4C28DADF600F7DDDF8CF7FF16E203073O00B4B0E2D9936383002C3O0012633O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100043C3O000A0001001292000300063O0020B2000400030007001292000500083O0020B2000500050009001292000600083O0020B200060006000A00065100073O000100062O006B3O00064O006B8O006B3O00044O006B3O00014O006B3O00024O006B3O00053O0020B200080003000B0020B200090003000C2O0082000A5O001292000B000D3O000651000C0001000100022O006B3O000A4O006B3O000B4O006B000D00073O0012C7000E000E3O0012C7000F000F4O0097000D000F0002000651000E0002000100012O006B3O00074O0058000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00D500025O00122O000300016O00045O00122O000500013O00042O0003002100012O00CB00076O00DA000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004DE0003000500012O00CB000300054O006B000400024O00C2000300044O003E00036O006C3O00017O000A3O00028O00026O00F03F025O0068A640025O0057B140025O0046A040025O00DCB140025O00E7B140025O0062AD40025O00FCAA40025O00B09840013A3O0012C7000200014O00AC000300043O002698000200070001000100043C3O000700010012C7000300014O00AC000400043O0012C7000200023O0026FF0002000B0001000200043C3O000B0001002ECA000400020001000300043C3O000200010012C7000500013O0026980005000C0001000100043C3O000C00010026FF000300120001000100043C3O00120001002ECA0006002E0001000500043C3O002E00010012C7000600014O00AC000700073O002E38000800140001000700043C3O00140001002698000600140001000100043C3O001400010012C7000700013O0026980007001D0001000200043C3O001D00010012C7000300023O00043C3O002E0001002698000700190001000100043C3O001900012O00CB00086O00BC000400083O002E38000A002A0001000900043C3O002A000100061B0004002A0001000100043C3O002A00012O00CB000800014O006B00096O007C000A6O00AA00086O003E00085O0012C7000700023O00043C3O0019000100043C3O002E000100043C3O001400010026980003000B0001000200043C3O000B00012O006B000600044O007C00076O00AA00066O003E00065O00043C3O000B000100043C3O000C000100043C3O000B000100043C3O0039000100043C3O000200012O006C3O00017O00433O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203053O008D2B13236003073O009BCB44705613C503063O0076D137E5456A03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203043O0020B3853303053O00B962DAEB5703053O00E63D24F4D103063O00CAAB5C4786BE03053O0019D3299B3A03043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D47903073O0037EFA9CF03E7AB03043O00AE678EC5030A3O00663A502C205DEC5F275103073O009836483F58453E03073O00E4C5E25DD0CDE003043O003CB4A48E030A3O00684C0A3D22EE062O510B03073O0072383E6549478D03073O0088E8D7C5BCE0D503043O00A4D889BB030A3O00E2F43EA6A3FD1FDBE93F03073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703103O005265676973746572466F724576656E7403243O003BCE8C999A2O982AC1992O898F9829DD9D93859C8B33D7998485928925CE9091829A823E03073O00C77A8DD8D0CCDD03063O0053657441504C025O0080504000A3013O0067000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0006000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0014000F00142O00CB00155O0012B9001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400154O00155O00122O001600263O00122O001700276O0015001700024O0015000F00154O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B6O0016001800024O00150015001600122O0016002C6O00175O00122O0018002D3O00122O0019002E6O0017001900024O0016001600174O001700176O00188O00198O001A8O001B8O001C00596O005A5O00122O005B002F3O00122O005C00306O005A005C00024O005A000D005A4O005B5O00122O005C00313O00122O005D00326O005B005D00024O005A005A005B4O005B5O00122O005C00333O00122O005D00346O005B005D00024O005B000E005B4O005C5O00122O005D00353O00122O005E00366O005C005E00024O005B005B005C4O005C5O00122O005D00373O00122O005E00386O005C005E00024O005C0012005C4O005D5O00122O005E00393O00122O005F003A6O005D005F00024O005C005C005D4O005D8O005E00636O00645O00122O0065003B3O00122O0066003C6O0064006600024O0064000F00644O00655O00122O0066003D3O00122O0067003E6O0065006700024O00640064006500065100653O000100042O006B3O005A4O00CB8O006B3O00644O006B3O00073O0020C400660004003F00065100680001000100012O006B3O00654O00EE00695O00122O006A00403O00122O006B00416O0069006B6O00663O000100065100660002000100012O006B3O005A3O00065100670003000100022O006B3O00094O006B3O005A3O00065100680004000100062O006B3O005A4O00CB8O006B3O001B4O006B3O00644O006B3O00134O006B3O005C3O00065100690005000100062O006B3O00584O006B3O00094O006B3O00594O006B3O005A4O00CB8O006B3O00133O000651006A0006000100042O006B3O00174O006B3O00644O006B3O005D4O006B3O001A3O000651006B0007000100182O006B3O005B4O00CB8O006B3O00544O006B3O00094O006B3O00564O006B3O00134O006B3O005C4O006B3O00534O006B3O00554O006B3O00574O006B3O005A4O006B3O003D4O006B3O00334O006B3O003B4O006B3O00314O006B3O003C4O006B3O00324O006B3O003E4O006B3O00344O006B3O003F4O006B3O00354O006B3O00364O006B3O005E4O006B3O00403O000651006C00080001000E2O006B3O00084O006B3O005A4O00CB8O006B3O00384O006B3O00094O006B3O00424O006B3O00134O006B3O005C4O006B3O00374O006B3O00414O006B3O003A4O006B3O00444O006B3O00394O006B3O00433O000651006D00090001000B2O006B3O005A4O00CB8O006B3O00224O006B3O00134O006B3O000B4O006B3O001E4O006B3O001C4O006B3O004E4O006B3O00514O006B3O00524O006B3O001A3O000651006E000A000100172O006B3O005A4O00CB8O006B3O00274O006B3O002D4O006B3O001A4O006B3O00094O006B3O00044O006B3O00134O006B3O000B4O006B3O00254O006B3O002B4O006B3O00624O006B3O00644O006B3O00234O006B3O00294O006B3O00284O006B3O002E4O006B3O00244O006B3O002A4O006B3O001C4O006B3O00514O006B3O00524O006B3O00633O000651006F000B0001001A2O006B3O005A4O00CB8O006B3O001E4O006B3O00094O006B3O00134O006B3O000B4O006B3O00214O006B3O00224O006B3O00644O006B3O00604O006B3O00664O006B3O00514O006B3O00524O006B3O001A4O006B3O001F4O006B3O004E4O006B3O00264O006B3O002C4O006B3O001C4O006B3O00634O006B3O00254O006B3O002B4O006B3O00624O006B3O001D4O006B3O00204O006B3O00363O0006510070000C000100142O006B3O002A4O00CB8O006B3O00284O006B3O00294O006B3O002D4O006B3O002B4O006B3O002C4O006B3O00254O006B3O00264O006B3O00274O006B3O002E4O006B3O001F4O006B3O00204O006B3O00214O006B3O001C4O006B3O001D4O006B3O001E4O006B3O00244O006B3O00224O006B3O00233O0006510071000D000100192O006B3O00434O00CB8O006B3O00444O006B3O00454O006B3O00464O006B3O00334O006B3O00344O006B3O00354O006B3O00364O006B3O00394O006B3O003A4O006B3O00374O006B3O00384O006B3O00314O006B3O00324O006B3O002F4O006B3O00304O006B3O003B4O006B3O003C4O006B3O003D4O006B3O003E4O006B3O003F4O006B3O00404O006B3O00414O006B3O00423O0006510072000E000100142O006B3O00564O00CB8O006B3O00554O006B3O00574O006B3O00494O006B3O004A4O006B3O00584O006B3O00594O006B3O00504O006B3O004F4O006B3O00514O006B3O004E4O006B3O004B4O006B3O004C4O006B3O00474O006B3O004D4O006B3O00484O006B3O00534O006B3O00524O006B3O00543O0006510073000F000100292O006B3O001A4O00CB8O006B3O001B4O006B3O00614O006B3O00094O006B3O00604O006B3O005A4O006B3O00644O006B3O00084O006B3O000D4O006B3O00134O006B3O005C4O006B3O00044O006B3O00674O006B3O00184O006B3O006D4O006B3O006C4O006B3O000A4O006B3O00494O006B3O00454O006B3O00464O006B3O004A4O006B3O00484O006B3O00684O006B3O00694O006B3O000B4O006B3O005F4O006B3O006B4O006B3O004E4O006B3O006E4O006B3O004F4O006B3O00504O006B3O006A4O006B3O006F4O006B3O00194O006B3O00714O006B3O00704O006B3O00724O006B3O00624O006B3O00634O006B3O005E3O00065100740010000100032O006B3O000F4O00CB8O006B3O00653O0020050075000F004200122O007600436O007700736O007800746O0075007800016O00013O00113O000A3O00030D3O00323CB73940242C253FAA31402403073O00497150D2582E57030B3O004973417661696C61626C65025O001C9940026O00344003123O00A525DE02E28D20CC10EB8408C810F2872ADE03053O0087E14CAD72030A3O004D657267655461626C6503193O0044697370652O6C61626C6544697365617365446562752O667303183O0044697370652O6C61626C65506F69736F6E446562752O6673001A4O00459O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000C0001000100043C3O000C0001002EBB0004000F0001000500043C3O001900012O00CB3O00024O00A1000100013O00122O000200063O00122O000300076O0001000300024O000200033O00202O0002000200084O000300023O00202O0003000300094O000400023O00202O00040004000A4O0002000400026O000100022O006C3O00019O003O00034O00CB8O00693O000100012O006C3O00017O00023O00030D3O00446562752O6652656D61696E73030E3O004A7564676D656E74446562752O6601063O0020EC00013O00014O00035O00202O0003000300024O000100036O00019O0000017O00053O0003083O0042752O66446F776E030F3O005265747269627574696F6E41757261030C3O004465766F74696F6E4175726103113O00436F6E63656E74726174696F6E41757261030C3O00437275736164657241757261001C4O000B7O00206O00014O000200013O00202O0002000200026O0002000200064O001A00013O00043C3O001A00012O00CB7O0020B65O00014O000200013O00202O0002000200036O0002000200064O001A00013O00043C3O001A00012O00CB7O0020B65O00014O000200013O00202O0002000200046O0002000200064O001A00013O00043C3O001A00012O00CB7O0020C45O00012O00CB000200013O0020B20002000200052O00973O000200022O00293O00024O006C3O00017O00083O00030D3O008ED115F176E5A8E91FE871F8BE03063O0096CDBD70901803073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00394003123O00436C65616E7365546F78696E73466F63757303153O002688BA4D0A9B142F3694B65E0D9C51142C97AF490803083O007045E4DF2C64E871001F4O00289O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001E00013O00043C3O001E00012O00CB3O00023O00060F3O001E00013O00043C3O001E00012O00CB3O00033O0020B25O00040012C7000100054O00753O0002000200060F3O001E00013O00043C3O001E00012O00CB3O00044O00CB000100053O0020B20001000100062O00753O0002000200060F3O001E00013O00043C3O001E00012O00CB3O00013O0012C7000100073O0012C7000200084O00C23O00024O003E8O006C3O00017O000B3O0003103O004865616C746850657263656E74616765025O00108E40025O003AB240030C3O00F21306C0BE7380F81600DBA203073O00E6B47F67B3D61C03073O0049735265616479025O00A09D40025O00B09A40030C3O00466C6173686F664C6967687403173O008A095E55EC7EEF8A3A534FE349F4CC0D5A47E801EF830603073O0080EC653F26842100234O00CB7O00060F3O000900013O00043C3O000900012O00CB3O00013O0020C45O00012O00753O000200022O00CB000100023O0006AB3O00030001000100043C3O000B0001002ECA000300220001000200043C3O002200012O00CB3O00034O00C3000100043O00122O000200043O00122O000300056O0001000300028O000100206O00066O0002000200064O00170001000100043C3O00170001002EBB0007000D0001000800043C3O002200012O00CB3O00054O00CB000100033O0020B20001000100092O00753O0002000200060F3O002200013O00043C3O002200012O00CB3O00043O0012C70001000A3O0012C70002000B4O00C23O00024O003E8O006C3O00017O00113O00028O00025O0022AF40025O00109440026O00F03F025O000C9F40025O0008814003133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O0020B340025O00B49340026O003740025O0034AC40025O008EAE40025O0024A44003103O0048616E646C65546F705472696E6B6574025O008EB040025O00C0554000463O0012C73O00014O00AC000100023O002ECA000300090001000200043C3O000900010026983O00090001000100043C3O000900010012C7000100014O00AC000200023O0012C73O00043O0026983O00020001000400043C3O000200010026980001000B0001000100043C3O000B00010012C7000200013O0026FF000200120001000400043C3O00120001002EBB000500120001000600043C3O002200012O00CB000300013O0020310003000300074O000400026O000500033O00122O000600086O000700076O0003000700024O00038O00035O00062O0003001F0001000100043C3O001F0001002E38000900450001000A00043C3O004500012O00CB00036O0029000300023O00043C3O00450001002E38000B000E0001000C00043C3O000E00010026980002000E0001000100043C3O000E00010012C7000300013O0026FF0003002B0001000100043C3O002B0001002E38000D00390001000E00043C3O003900012O00CB000400013O0020A000040004000F4O000500026O000600033O00122O000700086O000800086O0004000800024O00048O00045O00062O0004003800013O00043C3O003800012O00CB00046O0029000400023O0012C7000300043O0026FF0003003D0001000400043C3O003D0001002E38001000270001001100043C3O002700010012C7000200043O00043C3O000E000100043C3O0027000100043C3O000E000100043C3O0045000100043C3O000B000100043C3O0045000100043C3O000200012O006C3O00017O00763O00028O00025O00D4A340026O000840025O001AB040030B3O0095DC2140A9D13358B2D72503043O002CDDB94003073O004973526561647903103O004865616C746850657263656E74616765030B3O004865616C746873746F6E65025O0086A240025O00BCA44003153O0009E249536709F45C507D04A74C5A7504E95B56650403053O00136187283F025O0014AB40025O00A8B140026O00F03F03193O009C5935292A22A6553D3C6F19AB5D3F322136EE6C3C2F263EA003063O0051CE3C535B4F03173O007CAED6602AD045AD40ACF8772ECF44AA499BDF6626CC4303083O00C42ECBB0124FA32D03173O0052656672657368696E674865616C696E67506F74696F6E025O00B88D40025O000C904003233O00AA27780C21E8E7B12C795E2CFEEEB42B701964EBE0AC2B711064FFEABE27700D2DEDEA03073O008FD8421E7E449B031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O008EDA08CAC8B4D6EDA1CD1FD8EDA6D6EDA3C60AFBCAB7DEEEA403083O0081CAA86DABA5C3B7025O00649540025O0094A140025O00488D40025O0094AD4003253O00264A32D9D303E72E5332CACD54EE27593BD1D013A63257232OD11AA6265D31DDD007EF345D03073O0086423857B8BE74025O00288C40025O007AB040025O00ABB240025O009EAF40025O00A4AF40025O0074954003163O0099E7C0D03EC7B370B1F4E0CC39C7B770AAD9C8CC3DDD03083O001EDE92A1A25AAED2030A3O0049734361737461626C6503083O0042752O66446F776E03123O00417264656E74446566656E64657242752O66025O00349040025O0026B14003163O00477561726469616E6F66416E6369656E744B696E677303253O00E25B7118E1477104DA417635E4407303E0406435EE477E0DF60E740FE34B7E19EC58754AB103043O006A852E10030E3O00793277F92O547C2575F954445D3203063O00203840139C3A031A3O00477561726469616E6F66416E6369656E744B696E677342752O66025O00FC9540025O00FC9D40030E3O00417264656E74446566656E646572031B3O005BDAE15354E6BF5ECDE35354F6854888E1535CF78E49C1F3531AA403073O00E03AA885363A92025O00BCA340025O00D49A40025O0048AC40025O005CA040027O0040025O00EC9A40025O001EA340030C3O0088A0074DB8EEFCA4A01448B203073O00AFCCC97124D68B030A3O00446562752O66446F776E03113O00466F7262656172616E6365446562752O66025O00BC9240025O00AEAB40025O00449940025O008EA940030C3O00446976696E65536869656C6403173O0043C523D50A42F326D40D42C0319C0042CA30D2174EDA3003053O006427AC55BC025O001AA840025O00389240030A3O008179A08F3D8579B7842003053O0053CD18D9E0025O008DB140025O0026AC4003103O004C61796F6E48616E6473506C6179657203183O00EAC4D402E9CBF235E7CBC92EA6C1C83BE3CBDE34F0C08D6F03043O005D86A5AD025O0036A640025O003EA740025O00149F40025O00C06540025O00206A40025O00D2A040030B3O006E2O59F97A80A00756445203083O006B39362B9D15E6E7030F3O004865616C696E674162736F72626564030B3O0042752O6652656D61696E7303183O00536869656C646F667468655269676874656F757342752O66026O00144003063O0042752O66557003113O00446976696E65507572706F736542752O6603143O005368696E696E674C6967687446722O6542752O66025O00909F40025O00D89E4003113O00576F72646F66476C6F7279506C61796572025O000C9540025O0040954003193O00CC8403F186D3C9E48C1DFAABC58FDF8E17F0B7CFC6CD8E51AD03073O00AFBBEB7195D9BC03143O000FA78849EF7D773ABB8949D1707F34BB8443F66A03073O00185CCFE12C831903093O00486F6C79506F776572030F3O0042752O665265667265736861626C6503143O00536869656C646F667468655269676874656F757303243O0058DBB149177974DCBE730F754EECAA451C755FD6B759083D4FD6BE49156E42C5BD0C4A2F03063O001D2BB3D82C7B025O006DB140025O00E8AB40025O0070A640025O00E0734000E6012O0012C73O00013O002EBB000200830001000200043C3O008400010026983O00840001000300043C3O00840001002EBB000400220001000400043C3O002700012O00CB00016O00A8000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002700013O00043C3O002700012O00CB000100023O00060F0001002700013O00043C3O002700012O00CB000100033O0020C40001000100082O00750001000200022O00CB000200043O0006F7000100270001000200043C3O002700012O00CB000100054O00CB000200063O0020B20002000200092O007500010002000200061B000100220001000100043C3O00220001002E38000B00270001000A00043C3O002700012O00CB000100013O0012C70002000C3O0012C70003000D4O00C2000100034O003E00016O00CB000100073O00060F0001003000013O00043C3O003000012O00CB000100033O0020C40001000100082O00750001000200022O00CB000200083O0006AB000100030001000200043C3O00320001002E38000F00E52O01000E00043C3O00E52O010012C7000100014O00AC000200033O000E4E0010007B0001000100043C3O007B0001000E4E000100360001000200043C3O003600010012C7000300013O002698000300390001000100043C3O003900012O00CB000400094O0015000500013O00122O000600113O00122O000700126O00050007000200062O000400430001000500043C3O0043000100043C3O005A00012O00CB00046O00A8000500013O00122O000600133O00122O000700146O0005000700024O00040004000500202O0004000400074O00040002000200062O0004005A00013O00043C3O005A00012O00CB000400054O00CB000500063O0020B20005000500152O007500040002000200061B000400550001000100043C3O00550001002ECA0017005A0001001600043C3O005A00012O00CB000400013O0012C7000500183O0012C7000600194O00C2000400064O003E00046O00CB000400093O002698000400E52O01001A00043C3O00E52O012O00CB00046O00C3000500013O00122O0006001B3O00122O0007001C6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400690001000100043C3O00690001002E38001E00E52O01001D00043C3O00E52O012O00CB000400054O00CB000500063O0020B20005000500152O007500040002000200061B000400710001000100043C3O00710001002E38002000E52O01001F00043C3O00E52O012O00CB000400013O0012A4000500213O00122O000600226O000400066O00045O00044O00E52O0100043C3O0039000100043C3O00E52O0100043C3O0036000100043C3O00E52O010026FF0001007F0001000100043C3O007F0001002E38002400340001002300043C3O003400010012C7000200014O00AC000300033O0012C7000100103O00043C3O0034000100043C3O00E52O01002E38002600F30001002500043C3O00F300010026983O00F30001001000043C3O00F300010012C7000100014O00AC000200023O0026980001008A0001000100043C3O008A00010012C7000200013O002E38002800EA0001002700043C3O00EA0001002698000200EA0001000100043C3O00EA00010012C7000300013O002698000300E30001000100043C3O00E300012O00CB0004000A4O00A8000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400AE00013O00043C3O00AE00012O00CB000400033O0020C40004000400082O00750004000200022O00CB0005000B3O0006F7000400AE0001000500043C3O00AE00012O00CB0004000C3O00060F000400AE00013O00043C3O00AE00012O00CB000400033O0020F100040004002C4O0006000A3O00202O00060006002D4O00040006000200062O000400B00001000100043C3O00B00001002E38002F00BB0001002E00043C3O00BB00012O00CB000400054O00CB0005000A3O0020B20005000500302O007500040002000200060F000400BB00013O00043C3O00BB00012O00CB000400013O0012C7000500313O0012C7000600324O00C2000400064O003E00046O00CB0004000A4O00A8000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400E200013O00043C3O00E200012O00CB000400033O0020C40004000400082O00750004000200022O00CB0005000D3O0006F7000400E20001000500043C3O00E200012O00CB0004000E3O00060F000400E200013O00043C3O00E200012O00CB000400033O0020B600040004002C4O0006000A3O00202O0006000600354O00040006000200062O000400E200013O00043C3O00E20001002ECA003600E20001003700043C3O00E200012O00CB000400054O00CB0005000A3O0020B20005000500382O007500040002000200060F000400E200013O00043C3O00E200012O00CB000400013O0012C7000500393O0012C70006003A4O00C2000400064O003E00045O0012C7000300103O002ECA003C00920001003B00043C3O00920001002698000300920001001000043C3O009200010012C7000200103O00043C3O00EA000100043C3O009200010026FF000200EE0001001000043C3O00EE0001002ECA003D008D0001003E00043C3O008D00010012C73O003F3O00043C3O00F3000100043C3O008D000100043C3O00F3000100043C3O008A00010026983O005A2O01000100043C3O005A2O010012C7000100014O00AC000200023O0026FF000100FB0001000100043C3O00FB0001002ECA004100F70001004000043C3O00F700010012C7000200013O002698000200512O01000100043C3O00512O012O00CB000300033O0020C40003000300082O00750003000200022O00CB0004000F3O0006F7000300182O01000400043C3O00182O012O00CB000300103O00060F000300182O013O00043C3O00182O012O00CB0003000A4O00A8000400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O00030003002B4O00030002000200062O000300182O013O00043C3O00182O012O00CB000300033O0020F10003000300444O0005000A3O00202O0005000500454O00030005000200062O0003001A2O01000100043C3O001A2O01002E38004700272O01004600043C3O00272O01002E38004800272O01004900043C3O00272O012O00CB000300054O00CB0004000A3O0020B200040004004A2O007500030002000200060F000300272O013O00043C3O00272O012O00CB000300013O0012C70004004B3O0012C70005004C4O00C2000300054O003E00035O002E38004E00502O01004D00043C3O00502O012O00CB000300033O0020C40003000300082O00750003000200022O00CB000400113O0006F7000300502O01000400043C3O00502O012O00CB000300123O00060F000300502O013O00043C3O00502O012O00CB0003000A4O00A8000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003002B4O00030002000200062O000300502O013O00043C3O00502O012O00CB000300033O0020B60003000300444O0005000A3O00202O0005000500454O00030005000200062O000300502O013O00043C3O00502O01002ECA005200502O01005100043C3O00502O012O00CB000300054O00CB000400063O0020B20004000400532O007500030002000200060F000300502O013O00043C3O00502O012O00CB000300013O0012C7000400543O0012C7000500554O00C2000300054O003E00035O0012C7000200103O002ECA005600FC0001005700043C3O00FC0001002698000200FC0001001000043C3O00FC00010012C73O00103O00043C3O005A2O0100043C3O00FC000100043C3O005A2O0100043C3O00F700010026FF3O005E2O01003F00043C3O005E2O01002ECA005800010001005900043C3O000100010012C7000100014O00AC000200023O002698000100602O01000100043C3O00602O010012C7000200013O000E4E000100DB2O01000200043C3O00DB2O010012C7000300013O0026FF0003006A2O01000100043C3O006A2O01002E38005B00D42O01005A00043C3O00D42O012O00CB0004000A4O00A8000500013O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500202O0004000400074O00040002000200062O000400A62O013O00043C3O00A62O012O00CB000400033O0020C40004000400082O00750004000200022O00CB000500133O0006F7000400A62O01000500043C3O00A62O012O00CB000400143O00060F000400A62O013O00043C3O00A62O012O00CB000400033O0020C400040004005E2O007500040002000200061B000400A62O01000100043C3O00A62O012O00CB000400033O00200100040004005F4O0006000A3O00202O0006000600604O000400060002000E2O006100992O01000400043C3O00992O012O00CB000400033O0020F10004000400624O0006000A3O00202O0006000600634O00040006000200062O000400992O01000100043C3O00992O012O00CB000400033O0020F10004000400624O0006000A3O00202O0006000600644O00040006000200062O000400992O01000100043C3O00992O01002EBB0065000F0001006600043C3O00A62O012O00CB000400054O00CB000500063O0020B20005000500672O007500040002000200061B000400A12O01000100043C3O00A12O01002EBB006800070001006900043C3O00A62O012O00CB000400013O0012C70005006A3O0012C70006006B4O00C2000400064O003E00046O00CB0004000A4O00A8000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500202O00040004002B4O00040002000200062O000400D32O013O00043C3O00D32O012O00CB000400033O0020C400040004006E2O0075000400020002000E08013F00D32O01000400043C3O00D32O012O00CB000400033O0020B600040004006F4O0006000A3O00202O0006000600604O00040006000200062O000400D32O013O00043C3O00D32O012O00CB000400153O00060F000400D32O013O00043C3O00D32O012O00CB000400163O00061B000400C82O01000100043C3O00C82O012O00CB000400033O0020C40004000400082O00750004000200022O00CB000500173O0006F7000400D32O01000500043C3O00D32O012O00CB000400054O00CB0005000A3O0020B20005000500702O007500040002000200060F000400D32O013O00043C3O00D32O012O00CB000400013O0012C7000500713O0012C7000600724O00C2000400064O003E00045O0012C7000300103O000E89001000D82O01000300043C3O00D82O01002EBB00730090FF2O007400043C3O00662O010012C7000200103O00043C3O00DB2O0100043C3O00662O010026FF000200DF2O01001000043C3O00DF2O01002EBB00750086FF2O007600043C3O00632O010012C73O00033O00043C3O0001000100043C3O00632O0100043C3O0001000100043C3O00602O0100043C3O000100012O006C3O00017O00323O00028O00025O00C08140025O0068B04003063O0045786973747303093O004973496E52616E6765026O003E40025O00BDB040025O00649540025O0080AB40025O002EB340025O0034A640025O0001B140030B3O000B3E1BBF16ED063933231003083O00555C5169DB798B4103073O004973526561647903063O0042752O66557003143O005368696E696E674C6967687446722O6542752O6603103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F637573031D3O00EABC424143D0FB8C574973CDE4F354407ADAF3A05953799FFBBC53506F03063O00BF9DD330251C030A3O00F31EED1334F71EFA182903053O005ABF7F947C030A3O0049734361737461626C65030A3O00446562752O66446F776E03113O00466F7262656172616E6365446562752O66030F3O004C61796F6E48616E6473466F637573031C3O00748637287789111F79892A0438832B117D893D1E6E826E1177843B0403043O007718E74E026O00F03F025O004EAD40025O00AC994003133O00A021A059CF491F8522A379DD43038B2BAC49D903073O0071E24DC52ABC20030A3O00556E69744973556E697403023O004944025O002FB340025O009CAB40025O0072A740026O00304003183O00426C652O73696E676F66536163726966696365466F63757303253O00381AF1A6291FFAB20519F28A2917F7A73310FDB63F56F0B03C13FAA63300F1F53C19F7A02903043O00D55A7694025O0076A640025O006EA94003143O007922B1455E5220B3594B6B3CBB4248583ABD594303053O002D3B4ED43603193O00426C652O73696E676F6650726F74656374696F6E466F63757303263O00125A86989527A3F72F5985B4963CA2E4155597828920EDF4155086859527BBF52O508C88933D03083O00907036E3EBE64ECD00EB3O0012C73O00014O00AC000100013O000E4E0001000200013O00043C3O000200010012C7000100013O002EBB00023O0001000200043C3O00050001002698000100050001000100043C3O00050001002EBB000300110001000300043C3O001A00012O00CB00025O00060F0002001900013O00043C3O001900012O00CB00025O0020C40002000200042O007500020002000200060F0002001900013O00043C3O001900012O00CB00025O0020C40002000200050012C7000400064O009700020004000200061B0002001A0001000100043C3O001A00012O006C3O00014O00CB00025O00060F000200EA00013O00043C3O00EA00010012C7000200014O00AC000300033O0026980002001F0001000100043C3O001F00010012C7000300013O0026FF000300260001000100043C3O00260001002E380007008D0001000800043C3O008D00010012C7000400014O00AC000500053O0026FF0004002C0001000100043C3O002C0001002E38000A00280001000900043C3O002800010012C7000500013O002698000500860001000100043C3O008600010012C7000600013O0026980006007F0001000100043C3O007F0001002ECA000B00590001000C00043C3O005900012O00CB000700014O00A8000800023O00122O0009000D3O00122O000A000E6O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007005900013O00043C3O005900012O00CB000700033O00060F0007005900013O00043C3O005900012O00CB000700043O0020B60007000700104O000900013O00202O0009000900114O00070009000200062O0007005900013O00043C3O005900012O00CB00075O0020C40007000700122O00750007000200022O00CB000800053O0006F7000700590001000800043C3O005900012O00CB000700064O00CB000800073O0020B20008000800132O007500070002000200060F0007005900013O00043C3O005900012O00CB000700023O0012C7000800143O0012C7000900154O00C2000700094O003E00076O00CB000700014O00A8000800023O00122O000900163O00122O000A00176O0008000A00024O00070007000800202O0007000700184O00070002000200062O0007007E00013O00043C3O007E00012O00CB000700083O00060F0007007E00013O00043C3O007E00012O00CB00075O0020B60007000700194O000900013O00202O00090009001A4O00070009000200062O0007007E00013O00043C3O007E00012O00CB00075O0020C40007000700122O00750007000200022O00CB000800093O0006F70007007E0001000800043C3O007E00012O00CB000700064O00CB000800073O0020B200080008001B2O007500070002000200060F0007007E00013O00043C3O007E00012O00CB000700023O0012C70008001C3O0012C70009001D4O00C2000700094O003E00075O0012C70006001E3O0026FF000600830001001E00043C3O00830001002E38001F00300001002000043C3O003000010012C70005001E3O00043C3O0086000100043C3O003000010026980005002D0001001E00043C3O002D00010012C70003001E3O00043C3O008D000100043C3O002D000100043C3O008D000100043C3O00280001002698000300220001001E00043C3O002200012O00CB000400014O00A8000500023O00122O000600213O00122O000700226O0005000700024O00040004000500202O0004000400184O00040002000200062O000400AC00013O00043C3O00AC00012O00CB0004000A3O00060F000400AC00013O00043C3O00AC0001001292000400234O00C000055O00202O0005000500244O0005000200024O000600043O00202O0006000600244O000600076O00043O000200062O000400AC0001000100043C3O00AC00012O00CB00045O0020C40004000400122O00750004000200022O00CB0005000B3O0006AB000400030001000500043C3O00AE0001002EBB0025000F0001002600043C3O00BB0001002E38002800BB0001002700043C3O00BB00012O00CB000400064O00CB000500073O0020B20005000500292O007500040002000200060F000400BB00013O00043C3O00BB00012O00CB000400023O0012C70005002A3O0012C70006002B4O00C2000400064O003E00045O002ECA002C00EA0001002D00043C3O00EA00012O00CB000400014O00A8000500023O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O0004000400184O00040002000200062O000400EA00013O00043C3O00EA00012O00CB0004000C3O00060F000400EA00013O00043C3O00EA00012O00CB00045O0020B60004000400194O000600013O00202O00060006001A4O00040006000200062O000400EA00013O00043C3O00EA00012O00CB00045O0020C40004000400122O00750004000200022O00CB0005000D3O0006F7000400EA0001000500043C3O00EA00012O00CB000400064O00CB000500073O0020B20005000500302O007500040002000200060F000400EA00013O00043C3O00EA00012O00CB000400023O0012A4000500313O00122O000600326O000400066O00045O00044O00EA000100043C3O0022000100043C3O00EA000100043C3O001F000100043C3O00EA000100043C3O0005000100043C3O00EA000100043C3O000200012O006C3O00017O00363O00028O00027O0040026O007740025O009EB04003083O002B27023D50043C1203053O003D6152665A03073O004973526561647903083O004A7564676D656E74030E3O0049735370652O6C496E52616E676503153O00A63BAF4CCA52101DEC3EB94EC458130BAD3AEB1A9503083O0069CC4ECB2BA7377E026O00F03F025O00E9B240025O0036A140030C3O0008833EBFACBE242A9839A3A703073O00564BEC50CCC9DD030A3O0049734361737461626C65025O0035B240025O00408340030C3O00436F6E736563726174696F6E03093O004973496E52616E6765026O002040030C3O00714E7996FB886040638CF18503063O00EB122117E59E030E3O0071ACC4B557BFD3A863B2C8BE5CBE03043O00DB30DAA1025O005C9E40025O0030A540030E3O004176656E67657273536869656C64031C3O00E5677947DC4AF2F74E6F41D24AECE0316C5BDE4CEFE9737D5D9B1EB003073O008084111C29BB2F025O007BB040025O00804340025O00FEAE40025O00E2A140025O00988A40025O0056A740025O001DB340025O00E06040030C3O00466967687452656D61696E73030E3O009F2108F4C448993D0BFBDD5EBD3C03063O003BD3486F9CB0030E3O004C69676874734A7564676D656E74031B3O00428EE4255A94DC275B83E4204B89F76D5E95E62E418AE12C5AC7B703043O004D2EE783030D3O009B46B541B451824FA846B34EAE03043O0020DA34D603093O00486F6C79506F776572026O001440030D3O00417263616E65546F2O72656E74025O0018A840025O001CA940031A3O004F0532A9FFB57A4E410523ADFFA4054A5C1232A7FCB2444E0E4103083O003A2E7751C891D02500EB3O0012C73O00014O00AC000100013O0026983O00020001000100043C3O000200010012C7000100013O002698000100280001000200043C3O00280001002E38000300EA0001000400043C3O00EA00012O00CB00026O00A8000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O000200EA00013O00043C3O00EA00012O00CB000200023O00060F000200EA00013O00043C3O00EA00012O00CB000200034O002O01035O00202O0003000300084O000400043O00202O0004000400094O00065O00202O0006000600084O0004000600024O000400046O00020004000200062O000200EA00013O00043C3O00EA00012O00CB000200013O0012A40003000A3O00122O0004000B6O000200046O00025O00044O00EA00010026980001007C0001000C00043C3O007C00010012C7000200014O00AC000300033O0026FF000200300001000100043C3O00300001002ECA000D002C0001000E00043C3O002C00010012C7000300013O002698000300730001000100043C3O007300012O00CB00046O00A8000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004005200013O00043C3O005200012O00CB000400053O00060F0004005200013O00043C3O00520001002E38001300520001001200043C3O005200012O00CB000400034O00C600055O00202O0005000500144O000600043O00202O00060006001500122O000800166O0006000800024O000600066O00040006000200062O0004005200013O00043C3O005200012O00CB000400013O0012C7000500173O0012C7000600184O00C2000400064O003E00046O00CB00046O00A8000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O0004000400114O00040002000200062O0004005F00013O00043C3O005F00012O00CB000400063O00061B000400610001000100043C3O00610001002EBB001B00130001001C00043C3O007200012O00CB000400034O002O01055O00202O00050005001D4O000600043O00202O0006000600094O00085O00202O00080008001D4O0006000800024O000600066O00040006000200062O0004007200013O00043C3O007200012O00CB000400013O0012C70005001E3O0012C70006001F4O00C2000400064O003E00045O0012C70003000C3O002ECA002100310001002000043C3O00310001002698000300310001000C00043C3O003100010012C7000100023O00043C3O007C000100043C3O0031000100043C3O007C000100043C3O002C0001002E38002300050001002200043C3O00050001002698000100050001000100043C3O000500010012C7000200013O002698000200850001000C00043C3O008500010012C70001000C3O00043C3O00050001000E89000100890001000200043C3O00890001002E38002500810001002400043C3O00810001002ECA002700B60001002600043C3O00B600012O00CB000300073O001292000400283O00064C000300B60001000400043C3O00B600012O00CB00036O00A8000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300B600013O00043C3O00B600012O00CB000300083O00060F000300B600013O00043C3O00B600012O00CB000300093O00060F000300A200013O00043C3O00A200012O00CB0003000A3O00061B000300A50001000100043C3O00A500012O00CB000300093O00061B000300B60001000100043C3O00B600012O00CB000300034O002O01045O00202O00040004002B4O000500043O00202O0005000500094O00075O00202O00070007002B4O0005000700024O000500056O00030005000200062O000300B600013O00043C3O00B600012O00CB000300013O0012C70004002C3O0012C70005002D4O00C2000300054O003E00036O00CB000300073O001292000400283O00064C000300E50001000400043C3O00E500012O00CB00036O00A8000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300114O00030002000200062O000300E500013O00043C3O00E500012O00CB000300083O00060F000300E500013O00043C3O00E500012O00CB000300093O00060F000300CD00013O00043C3O00CD00012O00CB0003000A3O00061B000300D00001000100043C3O00D000012O00CB000300093O00061B000300E50001000100043C3O00E50001001292000300303O00264A000300E50001003100043C3O00E500012O00CB000300034O00B000045O00202O0004000400324O000500043O00202O00050005001500122O000700166O0005000700024O000500056O00030005000200062O000300E00001000100043C3O00E00001002E38003400E50001003300043C3O00E500012O00CB000300013O0012C7000400353O0012C7000500364O00C2000300054O003E00035O0012C70002000C3O00043C3O0081000100043C3O0005000100043C3O00EA000100043C3O000200012O006C3O00017O00703O00028O00025O00C4AA40025O00AEA440026O00F03F025O00A09840025O0017B140025O00D0A640025O0040A440025O00589140025O0006A640026O000840025O00809C40025O0036A640025O00ECA740030D3O000721D85E243ADA5D0D22DA493303043O003B4A4EB5030A3O0049734361737461626C65030B3O0042752O6652656D61696E73030C3O0053656E74696E656C42752O66026O002E40030A3O00436F6D62617454696D65026O00244003083O0016D4544EBA2BD45603053O00D345B12O3A030F3O00432O6F6C646F776E52656D61696E73030D3O0096F37CFBEEC2B9E24EE7E8DFBF03063O00ABD785199589030E3O00C0DE37F4E835EE51D2C03BFFE33403083O002281A8529A8F509C03083O00AFA7370C454B879103073O00E9E5D2536B282E030D3O00E9433FDB00D34D34E117C0563A03053O0065A12252B6030D3O004D6F6D656E746F66476C6F727903093O004973496E52616E6765026O002040031C3O00E50254FBD5F6BD21EE325EF2D4F09B6EEB0256F2DFED9520FB4D08AE03083O004E886D399EBB82E2025O00608640025O00EEB040030A3O001A36EFF8303ACDFE323303043O00915E5F9903073O0049735265616479030A3O00446976696E65546F2O6C026O003E4003183O00F9C402DC40B2C2D91BD942F7FEC21BD94AB8EAC307951FE503063O00D79DAD74B52E025O00488F40025O00B4A740026O001040027O0040025O00888E40025O00049D40025O00208B40025O00088C40030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003113O004176656E67696E67577261746842752O66025O006C9140025O006DB240025O0068A540025O000BB040025O00C07140025O00E08540025O00207840025O00206140030D3O00D567F0A3222489F346E7AC312503073O00E7941195CD454D025O00D88C40030D3O004176656E67696E675772617468031A3O0081B1C2F550F68EA0F8EC45FE94AF87F858F08CA3C8EC59ECC0F103063O009FE0C7A79B3703083O00C4F632C6FEFD39DE03043O00B297935C025O004DB040025O0070764003083O0053656E74696E656C03143O009FF842261B427F80BD4F3D1D407E83EA4221521403073O001AEC9D2C52722C025O00E89A40030E3O0017B598E6D33ABA84F4F63CB383E603053O00BA55D4EB92030D3O00E39713F03EE756C5B604FF2DE603073O0038A2E1769E598E030E3O0042617374696F6E6F664C69676874025O0034AF40025O00D8AD40031D3O005E04D3BB2BD7523ACFA91DD45502C8BB62DB530ACCAB2DCF521680FE7603063O00B83C65A0CF42025O00409740025O00A49940025O00107B40025O0076A140025O00B89C40025O004EA340025O0018A340025O00E2A940030E3O0084BC26101401D54296A22A1B1F0003083O0031C5CA437E7364A703073O0048617354696572026O003D40030E3O004176656E67657273536869656C64030E3O0049735370652O6C496E52616E6765025O00CAAC40025O00206740031B3O00364DDA2787534C2464CC21895352331BDC268F2O5A384CD13AC00403073O003E573BBF49E036030E3O00CB0BFDC1F311D0DCE305F7CCE91603043O00A987629A030E3O004C69676874734A7564676D656E74031B3O00C77E235CE920F7C1622053F036C6DF37275BF23FCCC4602A47BD6703073O00A8AB1744349D5300FA012O0012C73O00014O00AC000100033O0026FF3O00060001000100043C3O00060001002E38000200090001000300043C3O000900010012C7000100014O00AC000200023O0012C73O00043O000E890004000D00013O00043C3O000D0001002EBB000500F7FF2O000600043C3O000200012O00AC000300033O0026980001001F0001000100043C3O001F00010012C7000400013O000E89000400150001000400043C3O00150001002E38000700170001000800043C3O001700010012C7000100043O00043C3O001F0001000E890001001B0001000400043C3O001B0001002ECA000A00110001000900043C3O001100010012C7000200014O00AC000300033O0012C7000400043O00043C3O001100010026980001000E0001000400043C3O000E0001002698000200C70001000B00043C3O00C700010012C7000400014O00AC000500053O002ECA000C00250001000D00043C3O00250001002698000400250001000100043C3O002500010012C7000500013O002EBB000E00940001000E00043C3O00BE0001002698000500BE0001000100043C3O00BE00012O00CB00066O00A8000700013O00122O0008000F3O00122O000900106O0007000900024O00060006000700202O0006000600114O00060002000200062O0006009200013O00043C3O009200012O00CB000600023O00060F0006009200013O00043C3O009200012O00CB000600033O00060F0006004100013O00043C3O004100012O00CB000600043O00061B000600440001000100043C3O004400012O00CB000600033O00061B000600920001000100043C3O009200012O00CB000600053O0020210006000600124O00085O00202O0008000800134O00060008000200262O000600820001001400043C3O008200012O00CB000600063O0020B20006000600152O00F5000600010002000E09001600640001000600043C3O006400012O00CB00066O00B1000700013O00122O000800173O00122O000900186O0007000900024O00060006000700202O0006000600194O000600020002000E2O001400640001000600043C3O006400012O00CB00066O0043000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O0006000600194O000600020002000E2O001400920001000600043C3O009200012O00CB00066O0043000700013O00122O0008001C3O00122O0009001D6O0007000900024O00060006000700202O0006000600194O000600020002000E2O000100920001000600043C3O009200012O00CB00066O0043000700013O00122O0008001E3O00122O0009001F6O0007000900024O00060006000700202O0006000600194O000600020002000E2O000100920001000600043C3O009200012O00CB00066O0043000700013O00122O000800203O00122O000900216O0007000900024O00060006000700202O0006000600194O000600020002000E2O000100920001000600043C3O009200012O00CB000600074O00C600075O00202O0007000700224O000800083O00202O00080008002300122O000A00246O0008000A00024O000800086O00060008000200062O0006009200013O00043C3O009200012O00CB000600013O0012C7000700253O0012C7000800264O00C2000600084O003E00065O002ECA002700BD0001002800043C3O00BD00012O00CB000600093O00060F000600BD00013O00043C3O00BD00012O00CB0006000A3O00060F0006009D00013O00043C3O009D00012O00CB000600043O00061B000600A00001000100043C3O00A000012O00CB0006000A3O00061B000600BD0001000100043C3O00BD00012O00CB00066O00A8000700013O00122O000800293O00122O0009002A6O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600BD00013O00043C3O00BD00012O00CB0006000B3O000EB3000B00BD0001000600043C3O00BD00012O00CB000600074O00C600075O00202O00070007002C4O000800083O00202O00080008002300122O000A002D6O0008000A00024O000800086O00060008000200062O000600BD00013O00043C3O00BD00012O00CB000600013O0012C70007002E3O0012C70008002F4O00C2000600084O003E00065O0012C7000500043O002E380030002A0001003100043C3O002A00010026980005002A0001000400043C3O002A00010012C7000200323O00043C3O00C7000100043C3O002A000100043C3O00C7000100043C3O002500010026FF000200CB0001003300043C3O00CB0001002E38003500EE0001003400043C3O00EE00010012C7000400013O0026FF000400D00001000100043C3O00D00001002E38003700E90001003600043C3O00E900010012C7000500013O002698000500E20001000100043C3O00E200012O00CB0006000C3O0020A50006000600384O000700053O00202O0007000700394O00095O00202O00090009003A4O000700096O00063O00024O000300063O00062O000300E00001000100043C3O00E00001002EBB003B00030001003C00043C3O00E100012O0029000300023O0012C7000500043O002E38003D00D10001003E00043C3O00D10001002698000500D10001000400043C3O00D100010012C7000400043O00043C3O00E9000100043C3O00D10001002698000400CC0001000400043C3O00CC00010012C70002000B3O00043C3O00EE000100043C3O00CC0001002E38003F00452O01004000043C3O00452O01002698000200452O01000400043C3O00452O01002ECA0042001C2O01004100043C3O001C2O012O00CB00046O00A8000500013O00122O000600433O00122O000700446O0005000700024O00040004000500202O0004000400114O00040002000200062O0004001C2O013O00043C3O001C2O012O00CB0004000D3O00060F0004001C2O013O00043C3O001C2O012O00CB0004000E3O00060F000400072O013O00043C3O00072O012O00CB000400043O00061B0004000A2O01000100043C3O000A2O012O00CB0004000E3O00061B0004001C2O01000100043C3O001C2O01002EBB004500120001004500043C3O001C2O012O00CB000400074O00C600055O00202O0005000500464O000600083O00202O00060006002300122O000800246O0006000800024O000600066O00040006000200062O0004001C2O013O00043C3O001C2O012O00CB000400013O0012C7000500473O0012C7000600484O00C2000400064O003E00046O00CB00046O00A8000500013O00122O000600493O00122O0007004A6O0005000700024O00040004000500202O0004000400114O00040002000200062O000400322O013O00043C3O00322O012O00CB0004000F3O00060F000400322O013O00043C3O00322O012O00CB000400103O00060F0004002F2O013O00043C3O002F2O012O00CB000400043O00061B000400342O01000100043C3O00342O012O00CB000400103O00060F000400342O013O00043C3O00342O01002EBB004B00120001004C00043C3O00442O012O00CB000400074O00C600055O00202O00050005004D4O000600083O00202O00060006002300122O000800246O0006000800024O000600066O00040006000200062O000400442O013O00043C3O00442O012O00CB000400013O0012C70005004E3O0012C70006004F4O00C2000400064O003E00045O0012C7000200333O002EBB0050003E0001005000043C3O00832O01002698000200832O01003200043C3O00832O012O00CB00046O00A8000500013O00122O000600513O00122O000700526O0005000700024O00040004000500202O0004000400114O00040002000200062O000400F92O013O00043C3O00F92O012O00CB000400113O00060F000400F92O013O00043C3O00F92O012O00CB000400123O00060F0004005C2O013O00043C3O005C2O012O00CB000400043O00061B0004005F2O01000100043C3O005F2O012O00CB000400123O00061B000400F92O01000100043C3O00F92O012O00CB000400053O0020F10004000400394O00065O00202O00060006003A4O00040006000200062O000400702O01000100043C3O00702O012O00CB00046O0007000500013O00122O000600533O00122O000700546O0005000700024O00040004000500202O0004000400194O00040002000200262O000400F92O01002D00043C3O00F92O012O00CB000400074O00B000055O00202O0005000500554O000600083O00202O00060006002300122O000800246O0006000800024O000600066O00040006000200062O0004007D2O01000100043C3O007D2O01002ECA005600F92O01005700043C3O00F92O012O00CB000400013O0012A4000500583O00122O000600596O000400066O00045O00044O00F92O01002E38005A00210001005B00043C3O00210001002698000200210001000100043C3O002100010012C7000400013O002ECA005C00EF2O01005D00043C3O00EF2O01002698000400EF2O01000100043C3O00EF2O010012C7000500013O002698000500912O01000400043C3O00912O010012C7000400043O00043C3O00EF2O010026FF000500952O01000100043C3O00952O01002E38005F008D2O01005E00043C3O008D2O01002E38006000C32O01006100043C3O00C32O012O00CB00066O00A8000700013O00122O000800623O00122O000900636O0007000900024O00060006000700202O0006000600114O00060002000200062O000600C32O013O00043C3O00C32O012O00CB000600133O00060F000600C32O013O00043C3O00C32O012O00CB000600063O0020B20006000600152O00F500060001000200264A000600C32O01003300043C3O00C32O012O00CB000600053O00208600060006006400122O000800653O00122O000900336O00060009000200062O000600C32O013O00043C3O00C32O012O00CB000600074O000601075O00202O0007000700664O000800083O00202O0008000800674O000A5O00202O000A000A00664O0008000A00024O000800086O00060008000200062O000600BE2O01000100043C3O00BE2O01002ECA006800C32O01006900043C3O00C32O012O00CB000600013O0012C70007006A3O0012C70008006B4O00C2000600084O003E00066O00CB00066O00A8000700013O00122O0008006C3O00122O0009006D6O0007000900024O00060006000700202O0006000600114O00060002000200062O000600ED2O013O00043C3O00ED2O012O00CB000600143O00060F000600ED2O013O00043C3O00ED2O012O00CB000600153O00060F000600D62O013O00043C3O00D62O012O00CB000600043O00061B000600D92O01000100043C3O00D92O012O00CB000600153O00061B000600ED2O01000100043C3O00ED2O012O00CB000600163O000EB3003300ED2O01000600043C3O00ED2O012O00CB000600074O002O01075O00202O00070007006E4O000800083O00202O0008000800674O000A5O00202O000A000A006E4O0008000A00024O000800086O00060008000200062O000600ED2O013O00043C3O00ED2O012O00CB000600013O0012C70007006F3O0012C7000800704O00C2000600084O003E00065O0012C7000500043O00043C3O008D2O01002698000400882O01000400043C3O00882O010012C7000200043O00043C3O0021000100043C3O00882O0100043C3O0021000100043C3O00F92O0100043C3O000E000100043C3O00F92O0100043C3O000200012O006C3O00017O00C03O00028O00025O00108740025O009C9E40026O000840025O002O9440025O002AA840026O00F03F025O0066A440025O0053B140030C3O00D07EF81F1549E170E2051F4403063O002A9311966C70030A3O0049734361737461626C6503083O0042752O66446F776E03103O00436F6E736563726174696F6E42752O6603093O0042752O66537461636B03123O0053616E6374696669636174696F6E42752O66026O00144003073O0048617354696572026O003F40027O0040030C3O00436F6E736563726174696F6E03093O004973496E52616E6765026O002040025O00405D40025O003DB34003183O000CA9236CE2EB1DA73976E8E64FB5397EE9EC0EB4293FB5BC03063O00886FC64D1F87026O001040030D3O0005CF52E643DD8F2BF94DEA52C703073O00E04DAE3F8B26AF03073O0049735265616479025O00C05A40025O0029B340030D3O0048612O6D65726F665772617468030E3O0049735370652O6C496E52616E6765031B3O008C40552381536721827E4F3C8555506E9755592080404A2AC4130803043O004EE4213803083O00E46BB60488CB70A603053O00E5AE1ED263025O00608F40025O0086AF4003093O00436173744379636C6503083O004A7564676D656E7403143O0011F88256E038370FAD9545EC333D1AFF8211BF6F03073O00597B8DE6318D5D025O00E4A540025O0010774003083O009098ACD5B788A6C603043O00B2DAEDC803193O0053616E6374696669636174696F6E456D706F77657242752O66025O00649740025O0002A44003133O00BCA0E2D7BBB0E8C4F6A6F2D1B8B1E7C2B2F5BE03043O00B0D6D586030D3O00DCACBBD9AD4456F29AA4D5BC5E03073O003994CDD6B4C836025O00808940025O00C09A40031B3O001AFC38397300C23A324905EF34207E52EE21357816FC27303643AD03053O0016729D5554025O005AA540025O0036A74003083O00EEDE17C350F3A6D003073O00C8A4AB73A43D9603083O0094E107428EBBFA1703053O00E3DE94632503073O004368617267657303083O00194756F1F4365C4603053O0099532O329603103O0046752O6C526563686172676554696D652O033O00474344025O004EA440025O00A4AF4003143O005763771B7EAE434936600872A5495C64775C22F903073O002D3D16137C13CB025O00C89F40030D3O000A002B548582F624003A50859303073O00A24B724835EBE703093O00486F6C79506F776572025O00C0A740025O00B0B140030D3O00417263616E65546F2O72656E74031A3O008D2E47E35D07B3284BF04107822804F14703823845F05742DF6A03063O0062EC5C248233026O001840030E3O00D8BCA73BFAAAB73AC8BAA021F0AB03043O00489BCED2025O0058A040025O000AA040025O0090A040025O00BFB240030E3O004372757361646572537472696B65031B3O004568411D32427F46312052685D05360669400F3D427B460A73152803053O0053261A346E030C3O00466967687452656D61696E7303083O007D0E22495E233E5403043O0026387747030B3O00DAE155D93642DFE65FDE3103063O0036938F38B645030B3O004973417661696C61626C65025O00BAB140025O0050784003083O004579656F6654797203163O00D398FA762OD0BEEB50CD9692EB48D1D280ED4D9F85D503053O00BFB6E19F29025O00E07040025O00D89840030E3O00E00408FB0575ABD22105FC077CBD03073O00D9A1726D95621003063O0042752O66557003113O004D6F6D656E746F66476C6F727942752O66030E3O004176656E67657273536869656C64031B3O0013363D72BB710033076FB47D172C2O3CAF60132E3C7DAE7052716C03063O00147240581CDC030A3O001508C4BDF6D5893E0DDE03073O00DD5161B2D498B0025O00649940025O00C49340030A3O00446976696E65546F2O6C026O003E4003173O00C9EE0BF214C8D809F416C1A70EEF1BC3E31CE91E8DB64B03053O007AAD877D9B030E3O00A5D705B73834DA97F208B03A3DCC03073O00A8E4A160D95F51025O00804940025O00C08C40031B3O00DAC72B522852C9C2114F275EDEDD2A1C3C43DADF2A5D3D539B807603063O0037BBB14E3C4F03083O002710A259BBD00EBB03083O00C96269C736DD8477030B3O0090028E2E112180B00B8B3503073O00CCD96CE3416255025O0030A740025O00389F40025O001AA840025O006CA54003163O005BDAF0DA23C661D7ECF76CD34AC2FBE12DD25A83A7B303063O00A03EA395854C030D3O00F4AC083CD0D3A4252ECEDBA51F03053O00A3B6C06D4F025O00807740025O0046A040025O005FB040025O00409340030D3O00426C652O73656448612O6D6572031A3O00362A05D3E631223FC8F4392B05D2B5273201CEF135340480A76C03053O0095544660A0025O00849740025O0009B340025O0050AE40025O00B6B14003143O00100700E03D1402EB2C0E08DF310105F93D0918FE03043O008D58666D03143O0048612O6D65726F667468655269676874656F7573025O0080A240025O00DAA34003233O00BB52C77D1F2F6ACEB56CDE781F0247C8B45BDE7515284681A047CB7E1E3C47C5F3009A03083O00A1D333AA107A5D35025O007DB240025O0007B040025O00DC9240025O00B1B040030C3O00128D72AF34816EBD258B73B203043O00DC51E21C03173O0010DA8CE8EFC401D496F2E5C953C696FAE4C312C786BBB803063O00A773B5E29B8A03143O00D12AEE597775C9E436EF594978C1EA36E2536E6203073O00A68242873C1B1103123O0042617374696F6E6F664C6967687442752O6603113O00446976696E65507572706F736542752O6603143O00536869656C646F667468655269676874656F7573025O00549F40025O00C2A34003223O005742C7703C4075C1730F5042CB4A222O4DC661354B5FDD3523504BC07131564E8E2103053O0050242AAE1503083O006405337D4315396E03043O001A2E7057031A3O0042756C7761726B6F665269676874656F75734675727942752O66025O00D08E40025O000AAC4003133O00B336AF73B2BA4BA0F930BF75B1BB44A6BD63FD03083O00D4D943CB142ODF25025O005EA840025O00E07A40025O00D2A240025O0026A940030C3O00871602A940ABA731B01003B403083O0050C4796CDA25C8D5025O00108C40025O00BCA54003183O00037C0C6C4E0D9801670B70454E9914720C7B4A1C8E40205A03073O00EA6013621F2B6E009B032O0012C73O00014O00AC000100013O002ECA000200020001000300043C3O000200010026983O00020001000100043C3O000200010012C7000100013O000E4E0004009B0001000100043C3O009B00010012C7000200014O00AC000300033O000E890001000F0001000200043C3O000F0001002EBB000500FEFF2O000600043C3O000B00010012C7000300013O0026FF000300140001000700043C3O00140001002ECA0009004A0001000800043C3O004A00012O00CB00046O00A8000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004800013O00043C3O004800012O00CB000400023O00060F0004004800013O00043C3O004800012O00CB000400033O0020B600040004000D4O00065O00202O00060006000E4O00040006000200062O0004004800013O00043C3O004800012O00CB000400033O00202100040004000F4O00065O00202O0006000600104O00040006000200262O000400360001001100043C3O003600012O00CB000400033O0020D600040004001200122O000600133O00122O000700146O00040007000200062O000400480001000100043C3O004800012O00CB000400044O00B000055O00202O0005000500154O000600053O00202O00060006001600122O000800176O0006000800024O000600066O00040006000200062O000400430001000100043C3O00430001002E38001900480001001800043C3O004800012O00CB000400013O0012C70005001A3O0012C70006001B4O00C2000400064O003E00045O0012C70001001C3O00043C3O009B0001002698000300100001000100043C3O001000010012C7000400013O000E4E000100930001000400043C3O009300012O00CB00056O00A8000600013O00122O0007001D3O00122O0008001E6O0006000800024O00050005000600202O00050005001F4O00050002000200062O0005006F00013O00043C3O006F00012O00CB000500063O00060F0005006F00013O00043C3O006F0001002ECA0020006F0001002100043C3O006F00012O00CB000500044O002O01065O00202O0006000600224O000700053O00202O0007000700234O00095O00202O0009000900224O0007000900024O000700076O00050007000200062O0005006F00013O00043C3O006F00012O00CB000500013O0012C7000600243O0012C7000700254O00C2000500074O003E00056O00CB00056O00A8000600013O00122O000700263O00122O000800276O0006000800024O00050005000600202O00050005001F4O00050002000200062O0005007C00013O00043C3O007C00012O00CB000500073O00061B0005007E0001000100043C3O007E0001002E38002900920001002800043C3O009200012O00CB000500083O00208A00050005002A4O00065O00202O00060006002B4O000700096O0008000A6O000900053O00202O0009000900234O000B5O00202O000B000B002B4O0009000B00024O000900096O00050009000200062O0005009200013O00043C3O009200012O00CB000500013O0012C70006002C3O0012C70007002D4O00C2000500074O003E00055O0012C7000400073O0026980004004D0001000700043C3O004D00010012C7000300073O00043C3O0010000100043C3O004D000100043C3O0010000100043C3O009B000100043C3O000B0001000E4E0007003B2O01000100043C3O003B2O010012C7000200014O00AC000300033O000E4E0001009F0001000200043C3O009F00010012C7000300013O0026FF000300A60001000100043C3O00A60001002E38002E00F80001002F00043C3O00F800012O00CB00046O00A8000500013O00122O000600303O00122O000700316O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400D700013O00043C3O00D700012O00CB000400073O00060F000400D700013O00043C3O00D700012O00CB000400033O0020B600040004000D4O00065O00202O0006000600324O00040006000200062O000400D700013O00043C3O00D700012O00CB000400033O00208600040004001200122O000600133O00122O000700146O00040007000200062O000400D700013O00043C3O00D70001002ECA003300D70001003400043C3O00D700012O00CB000400083O00208A00040004002A4O00055O00202O00050005002B4O000600096O0007000A6O000800053O00202O0008000800234O000A5O00202O000A000A002B4O0008000A00024O000800086O00040008000200062O000400D700013O00043C3O00D700012O00CB000400013O0012C7000500353O0012C7000600364O00C2000400064O003E00046O00CB00046O00A8000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400E400013O00043C3O00E400012O00CB000400063O00061B000400E60001000100043C3O00E60001002E38003A00F70001003900043C3O00F700012O00CB000400044O002O01055O00202O0005000500224O000600053O00202O0006000600234O00085O00202O0008000800224O0006000800024O000600066O00040006000200062O000400F700013O00043C3O00F700012O00CB000400013O0012C70005003B3O0012C70006003C4O00C2000400064O003E00045O0012C7000300073O0026FF000300FC0001000700043C3O00FC0001002EBB003D00A8FF2O003E00043C3O00A200012O00CB00046O00A8000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500202O00040004001F4O00040002000200062O000400362O013O00043C3O00362O012O00CB000400073O00060F000400362O013O00043C3O00362O012O00CB00046O0053000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O0004000400434O000400020002000E2O001400202O01000400043C3O00202O012O00CB00046O003D000500013O00122O000600443O00122O000700456O0005000700024O00040004000500202O0004000400464O0004000200024O000500033O00202O0005000500474O00050002000200062O000400362O01000500043C3O00362O01002E38004800362O01004900043C3O00362O012O00CB000400083O00208A00040004002A4O00055O00202O00050005002B4O000600096O0007000A6O000800053O00202O0008000800234O000A5O00202O000A000A002B4O0008000A00024O000800086O00040008000200062O000400362O013O00043C3O00362O012O00CB000400013O0012C70005004A3O0012C70006004B4O00C2000400064O003E00045O0012C7000100143O00043C3O003B2O0100043C3O00A2000100043C3O003B2O0100043C3O009F0001002698000100CB2O01001100043C3O00CB2O010012C7000200013O002EBB004C00310001004C00043C3O006F2O010026980002006F2O01000700043C3O006F2O012O00CB00036O00A8000400013O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006D2O013O00043C3O006D2O012O00CB0003000B3O00060F0003006D2O013O00043C3O006D2O012O00CB0003000C3O00060F000300552O013O00043C3O00552O012O00CB0003000D3O00061B000300582O01000100043C3O00582O012O00CB0003000C3O00061B0003006D2O01000100043C3O006D2O010012920003004F3O00264A0003006D2O01001100043C3O006D2O01002E380050006D2O01005100043C3O006D2O012O00CB000300044O00C600045O00202O0004000400524O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O0003006D2O013O00043C3O006D2O012O00CB000300013O0012C7000400533O0012C7000500544O00C2000300054O003E00035O0012C7000100553O00043C3O00CB2O010026980002003E2O01000100043C3O003E2O012O00CB00036O00A8000400013O00122O000500563O00122O000600576O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003007E2O013O00043C3O007E2O012O00CB0003000E3O00061B000300802O01000100043C3O00802O01002ECA005800932O01005900043C3O00932O01002E38005A00932O01005B00043C3O00932O012O00CB000300044O002O01045O00202O00040004005C4O000500053O00202O0005000500234O00075O00202O00070007005C4O0005000700024O000500056O00030005000200062O000300932O013O00043C3O00932O012O00CB000300013O0012C70004005D3O0012C70005005E4O00C2000300054O003E00036O00CB0003000F3O0012920004005F3O00064C000300B72O01000400043C3O00B72O012O00CB000300103O00060F000300B72O013O00043C3O00B72O012O00CB000300113O00060F000300A02O013O00043C3O00A02O012O00CB0003000D3O00061B000300A32O01000100043C3O00A32O012O00CB000300113O00061B000300B72O01000100043C3O00B72O012O00CB00036O00A8000400013O00122O000500603O00122O000600616O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300B72O013O00043C3O00B72O012O00CB00036O00A8000400013O00122O000500623O00122O000600636O0004000600024O00030003000400202O0003000300644O00030002000200062O000300B92O013O00043C3O00B92O01002ECA006500C92O01006600043C3O00C92O012O00CB000300044O00C600045O00202O0004000400674O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O000300C92O013O00043C3O00C92O012O00CB000300013O0012C7000400683O0012C7000500694O00C2000300054O003E00035O0012C7000200073O00043C3O003E2O01002698000100400201001400043C3O00400201002ECA006A00F72O01006B00043C3O00F72O012O00CB00026O00A8000300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O00020002000C4O00020002000200062O000200F72O013O00043C3O00F72O012O00CB000200123O00060F000200F72O013O00043C3O00F72O012O00CB000200133O000E09001400E62O01000200043C3O00E62O012O00CB000200033O0020B600020002006E4O00045O00202O00040004006F4O00020004000200062O000200F72O013O00043C3O00F72O012O00CB000200044O002O01035O00202O0003000300704O000400053O00202O0004000400234O00065O00202O0006000600704O0004000600024O000400046O00020004000200062O000200F72O013O00043C3O00F72O012O00CB000200013O0012C7000300713O0012C7000400724O00C2000200044O003E00026O00CB000200143O00060F0002001F02013O00043C3O001F02012O00CB000200153O00060F00022O0002013O00043C4O0002012O00CB0002000D3O00061B000200030201000100043C3O000302012O00CB000200153O00061B0002001F0201000100043C3O001F02012O00CB00026O00A8000300013O00122O000400733O00122O000500746O0003000500024O00020002000300202O00020002001F4O00020002000200062O0002001F02013O00043C3O001F0201002E380076001F0201007500043C3O001F02012O00CB000200044O00C600035O00202O0003000300774O000400053O00202O00040004001600122O000600786O0004000600024O000400046O00020004000200062O0002001F02013O00043C3O001F02012O00CB000200013O0012C7000300793O0012C70004007A4O00C2000200044O003E00026O00CB00026O00A8000300013O00122O0004007B3O00122O0005007C6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002003F02013O00043C3O003F02012O00CB000200123O00060F0002003F02013O00043C3O003F02012O00CB000200044O000601035O00202O0003000300704O000400053O00202O0004000400234O00065O00202O0006000600704O0004000600024O000400046O00020004000200062O0002003A0201000100043C3O003A0201002ECA007E003F0201007D00043C3O003F02012O00CB000200013O0012C70003007F3O0012C7000400804O00C2000200044O003E00025O0012C7000100043O002698000100CA0201001C00043C3O00CA02010012C7000200013O002698000200A20201000100043C3O00A202012O00CB0003000F3O0012920004005F3O00064C0003006C0201000400043C3O006C02012O00CB000300103O00060F0003006C02013O00043C3O006C02012O00CB000300113O00060F0003005202013O00043C3O005202012O00CB0003000D3O00061B000300550201000100043C3O005502012O00CB000300113O00061B0003006C0201000100043C3O006C02012O00CB00036O00A8000400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003006C02013O00043C3O006C02012O00CB00036O00A8000400013O00122O000500833O00122O000600846O0004000600024O00030003000400202O0003000300644O00030002000200062O0003006C02013O00043C3O006C02012O00CB000300163O000EBD0004006E0201000300043C3O006E0201002ECA008500800201008600043C3O008002012O00CB000300044O00B000045O00202O0004000400674O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O0003007B0201000100043C3O007B0201002ECA008700800201008800043C3O008002012O00CB000300013O0012C7000400893O0012C70005008A4O00C2000300054O003E00036O00CB00036O00A8000400013O00122O0005008B3O00122O0006008C6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003008D02013O00043C3O008D02012O00CB000300173O00061B0003008F0201000100043C3O008F0201002ECA008E00A10201008D00043C3O00A10201002E38009000A10201008F00043C3O00A102012O00CB000300044O00C600045O00202O0004000400914O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O000300A102013O00043C3O00A102012O00CB000300013O0012C7000400923O0012C7000500934O00C2000300054O003E00035O0012C7000200073O0026FF000200A60201000700043C3O00A60201002E38009500430201009400043C3O00430201002E38009600C70201009700043C3O00C702012O00CB00036O00A8000400013O00122O000500983O00122O000600996O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300C702013O00043C3O00C702012O00CB000300183O00060F000300C702013O00043C3O00C702012O00CB000300044O00B000045O00202O00040004009A4O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O000300C20201000100043C3O00C20201002ECA009C00C70201009B00043C3O00C702012O00CB000300013O0012C70004009D3O0012C70005009E4O00C2000300054O003E00035O0012C7000100113O00043C3O00CA020100043C3O004302010026FF000100CE0201000100043C3O00CE0201002ECA009F006A030100A000043C3O006A03010012C7000200013O0026FF000200D30201000100043C3O00D30201002EBB00A10062000100A200043C3O003303012O00CB00036O00A8000400013O00122O000500A33O00122O000600A46O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300F702013O00043C3O00F702012O00CB000300023O00060F000300F702013O00043C3O00F702012O00CB000300033O00209900030003000F4O00055O00202O0005000500104O00030005000200262O000300F70201001100043C3O00F702012O00CB000300044O00C600045O00202O0004000400154O000500053O00202O00050005001600122O000700176O0005000700024O000500056O00030005000200062O000300F702013O00043C3O00F702012O00CB000300013O0012C7000400A53O0012C7000500A64O00C2000300054O003E00036O00CB00036O00A8000400013O00122O000500A73O00122O000600A86O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003203013O00043C3O003203012O00CB000300193O00060F0003003203013O00043C3O003203012O00CB000300033O0020C400030003004F2O0075000300020002000E09001400170301000300043C3O001703012O00CB000300033O0020F100030003006E4O00055O00202O0005000500A94O00030005000200062O000300170301000100043C3O001703012O00CB000300033O0020B600030003006E4O00055O00202O0005000500AA4O00030005000200062O0003003203013O00043C3O003203012O00CB000300033O0020F100030003000D4O00055O00202O0005000500104O00030005000200062O000300250301000100043C3O002503012O00CB000300033O00202A00030003000F4O00055O00202O0005000500104O00030005000200262O000300320301001100043C3O003203012O00CB000300044O00CB00045O0020B20004000400AB2O007500030002000200061B0003002D0301000100043C3O002D0301002EBB00AC0007000100AD00043C3O003203012O00CB000300013O0012C7000400AE3O0012C7000500AF4O00C2000300054O003E00035O0012C7000200073O002698000200CF0201000700043C3O00CF02012O00CB00036O00A8000400013O00122O000500B03O00122O000600B16O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003006703013O00043C3O006703012O00CB000300073O00060F0003006703013O00043C3O006703012O00CB000300163O000E08010400670301000300043C3O006703012O00CB000300033O00205C00030003000F4O00055O00202O0005000500B24O000300050002000E2O000400670301000300043C3O006703012O00CB000300033O0020C400030003004F2O007500030002000200264A000300670301000400043C3O00670301002E3800B30067030100B400043C3O006703012O00CB000300083O00208A00030003002A4O00045O00202O00040004002B4O000500096O0006000A6O000700053O00202O0007000700234O00095O00202O00090009002B4O0007000900024O000700076O00030007000200062O0003006703013O00043C3O006703012O00CB000300013O0012C7000400B53O0012C7000500B64O00C2000300054O003E00035O0012C7000100073O00043C3O006A030100043C3O00CF02010026FF0001006E0301005500043C3O006E0301002EBB00B7009BFC2O00B800043C3O00070001002ECA00B9009A030100BA00043C3O009A03012O00CB00026O00A8000300013O00122O000400BB3O00122O000500BC6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002009A03013O00043C3O009A03012O00CB000200023O00060F0002009A03013O00043C3O009A03012O00CB000200033O0020B600020002000D4O00045O00202O0004000400324O00020004000200062O0002009A03013O00043C3O009A03012O00CB000200044O00B000035O00202O0003000300154O000400053O00202O00040004001600122O000600176O0004000600024O000400046O00020004000200062O000200910301000100043C3O00910301002E3800BE009A030100BD00043C3O009A03012O00CB000200013O0012A4000300BF3O00122O000400C06O000200046O00025O00044O009A030100043C3O0007000100043C3O009A030100043C3O000200012O006C3O00017O00693O00028O00026O001040026O00F03F025O0094A140025O00909B40030C3O004570696353652O74696E677303083O003DA864F0028C09BE03063O00E26ECD10846B03143O00E9C2F3CD48E4CDEFDF6DE2C4E8CD76E2D7E8FA6503053O00218BA380B9026O00144003083O00B72DB2D5D15DB59703073O00D2E448C6A1B833030B3O00235AF62376C02240FD157F03063O00AE562993701303083O006805991F2C0116B803083O00CB3B60ED6B456F7103133O002500A9EF36F9D92321BEE025F8E02D02A4C21503073O00B74476CC815190025O00A88540025O00C2A340025O00607B4003083O009DEAA9A8A7E1BAAF03043O00DCCE8FDD03133O008B722012D6D8DD805A2118CAD5E58F692534FC03073O00B2E61D4D77B8AC026O00184003083O00645D10CA5E5603CD03043O00BE37386403103O0052A62A171DE6C759A330291AF7FB758B03073O009336CF5C7E738303083O003E34216904700A2203063O001E6D51551D6D030E3O00FA6851B930EAE5ED465DA23EFDD803073O009C9F1134D656BE026O000840025O005C9B40025O000C9640025O0056B04003083O00231126E1DFA0A52O03073O00C270745295B6CE030D3O002CBB493CC9F40737AD7817CCEE03073O006E59C82C78A08203083O0098C65F524A443C5E03083O002DCBA32B26232A5B030B3O00C796D9069EAC5BD4B1C53103073O0034B2E5BC43E7C9025O003AB240025O0018834003083O00122O4410FE52243203073O004341213064973C03103O00CAF4ABF5FCD2E2A0CCDCD9C0A2D7E1C603053O0093BF87CEB803083O00C6BB1E0F7EF6F2AD03063O009895DE6A7B17030E3O00CE23F857BCD323FA74BCC92ED56703053O00D5BD469623025O0081B240025O00ADB14003083O00B3F9966239E6B10503083O0076E09CE2165088D603113O0057FD5CA350FB4A8146EB4BB356FC508B4703043O00E0228E3903083O00EDA2D1C97AFF5A1D03083O006EBEC7A5BD13913D03173O00CFF872C08ACAD7EE65E78DD3D2EE45E18CCFCEEE78FD9803063O00A7BA8B1788EB025O000FB140025O002EAD4003083O0029B09C1913BB8F1E03043O006D7AD5E803103O00FBE4A718EFFAAF35FCF8A407FCF6B63803043O00508E97C2027O0040025O00F4A24003083O00351A46D3A57C8C1503073O00EB667F32A7CC1203113O0045B2F002522B5EA6F031571D58A8F02F4003063O004E30C195432403083O00031B940C483E199303053O0021507EE07803103O00F9BB06E650E9BB10C158C4A90EC959FE03053O003C8CC863A403083O00B4F11032AB89F31703053O00C2E7946446030F3O00535FC480F9C65549C2B1F7DC4F43CF03063O00A8262CA1C396026O003540025O00CC9E40025O00D4A640025O00907B4003083O00B13O4BB9C7599103073O003EE22E2O3FD0A903113O00F00A50A12O1E3B57EA175A8533042856F103083O003E857935E37F6D4F025O0050AC40025O00C0914003083O0030C363580AC8705F03043O002C63A617030B3O0069E42C1C26A07BFA2C382703063O00C41C9749565303083O00C0063D048B561F6503083O001693634970E2387803103O00AD66E7D49BBD7BE5FC83BF42F0F499B003053O00EDD81582950078012O0012C73O00014O00AC000100013O0026983O00020001000100043C3O000200010012C7000100013O000E4E000200440001000100043C3O004400010012C7000200014O00AC000300033O002698000200090001000100043C3O000900010012C7000300013O0026FF000300100001000300043C3O00100001002ECA0004001E0001000500043C3O001E0001001292000400064O0055000500013O00122O000600073O00122O000700086O0005000700024O0004000400054O000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400054O00045O00122O0001000B3O00044O004400010026980003000C0001000100043C3O000C00010012C7000400013O0026980004003C0001000100043C3O003C0001001292000500064O003A000600013O00122O0007000C3O00122O0008000D6O0006000800024O0005000500064O000600013O00122O0007000E3O00122O0008000F6O0006000800024O0005000500064O000500023O00122O000500066O000600013O00122O000700103O00122O000800116O0006000800024O0005000500064O000600013O00122O000700123O00122O000800136O0006000800024O0005000500064O000500033O00122O000400033O002698000400210001000300043C3O002100010012C7000300033O00043C3O000C000100043C3O0021000100043C3O000C000100043C3O0044000100043C3O00090001002EBB001400390001001400043C3O007D00010026980001007D0001000B00043C3O007D00010012C7000200014O00AC000300033O000E890001004E0001000200043C3O004E0001002EBB001500FEFF2O001600043C3O004A00010012C7000300013O0026980003005F0001000300043C3O005F0001001292000400064O0055000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O0004000400054O000400043O00122O0001001B3O00044O007D00010026980003004F0001000100043C3O004F0001001292000400064O00B4000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000400053O00122O000400066O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000400063O00122O000300033O00044O004F000100043C3O007D000100043C3O004A0001002698000100B80001002400043C3O00B800010012C7000200014O00AC000300033O002E38002600810001002500043C3O00810001002698000200810001000100043C3O008100010012C7000300013O002EBB0027001D0001002700043C3O00A30001002698000300A30001000100043C3O00A30001001292000400064O003A000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000400073O00122O000400066O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000400083O00122O000300033O0026FF000300A70001000300043C3O00A70001002ECA003000860001003100043C3O00860001001292000400064O0055000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000400093O00122O000100023O00044O00B8000100043C3O0086000100043C3O00B8000100043C3O00810001002698000100C70001001B00043C3O00C70001001292000200064O004F000300013O00122O000400363O00122O000500376O0003000500024O0002000200034O000300013O00122O000400383O00122O000500396O0003000500024O0002000200034O0002000A3O00044O00772O0100269800012O002O01000300043C4O002O010012C7000200014O00AC000300033O002698000200CB0001000100043C3O00CB00010012C7000300013O0026FF000300D20001000100043C3O00D20001002ECA003A00EB0001003B00043C3O00EB0001001292000400064O003A000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O0004000B3O00122O000400066O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O0004000C3O00122O000300033O002ECA004500CE0001004400043C3O00CE0001002698000300CE0001000300043C3O00CE0001001292000400064O0055000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O0004000D3O00122O0001004A3O00045O002O0100043C3O00CE000100043C4O002O0100043C3O00CB0001002698000100312O01000100043C3O00312O010012C7000200013O002EBB004B001D0001004B00043C3O00202O01002698000200202O01000100043C3O00202O01001292000300064O003A000400013O00122O0005004C3O00122O0006004D6O0004000600024O0003000300044O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O0003000E3O00122O000300066O000400013O00122O000500503O00122O000600516O0004000600024O0003000300044O000400013O00122O000500523O00122O000600536O0004000600024O0003000300044O0003000F3O00122O000200033O002698000200032O01000300043C3O00032O01001292000300064O0055000400013O00122O000500543O00122O000600556O0004000600024O0003000300044O000400013O00122O000500563O00122O000600576O0004000600024O0003000300044O000300103O00122O000100033O00044O00312O0100043C3O00032O01002698000100050001004A00043C3O000500010012C7000200014O00AC000300033O002E38005800352O01005900043C3O00352O01002698000200352O01000100043C3O00352O010012C7000300013O0026FF0003003E2O01000300043C3O003E2O01002ECA005A004C2O01005B00043C3O004C2O01001292000400064O0055000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000400113O00122O000100243O00044O00050001002ECA0061003A2O01006000043C3O003A2O01000E4E0001003A2O01000300043C3O003A2O010012C7000400013O002698000400552O01000300043C3O00552O010012C7000300033O00043C3O003A2O01002698000400512O01000100043C3O00512O01001292000500064O00B4000600013O00122O000700623O00122O000800636O0006000800024O0005000500064O000600013O00122O000700643O00122O000800656O0006000800024O0005000500064O000500123O00122O000500066O000600013O00122O000700663O00122O000800676O0006000800024O0005000500064O000600013O00122O000700683O00122O000800696O0006000800024O0005000500064O000500133O00122O000400033O00044O00512O0100043C3O003A2O0100043C3O0005000100043C3O00352O0100043C3O0005000100043C3O00772O0100043C3O000200012O006C3O00017O008B3O00028O00026O00F03F025O00EC9F40025O00AEA440025O00207640025O00F89740026O001440030C3O004570696353652O74696E677303083O003B5C1D4B01570E4C03043O003F683969031B3O00098BA157188EAA43048194560493A1471F8EAB4A2D88A75118AF9403043O00246BE7C403083O006EB0B69354BBA59403043O00E73DD5C2031A3O000BA138601AA4337406AB0E720ABF347500AE385506AE2860219D03043O001369CD5D03083O009A0DCA9536A70FCD03053O005FC968BEE1031D3O00BAD8C4EDA3CE2OC0BCCEF5C1B7C2CFDD98C2D5C68ECDC7C2A6C8D5CBAB03043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D9398031B3O00391AE33B231BE2032A2EEA033E10D1053801C70A2A05EF0F380CE203043O006C4C6986025O0068AD40025O000CB340025O00B8AC40025O00F8854003083O003740503EC00A425703053O00A96425244A03193O001594A7771586B0540986AC5F06A6AC530982AC442B8EAC571303043O003060E7C203083O00FB5F1A3910D6A89003083O00E3A83A6E4D79B8CF030D3O006E2FBA6CB0C25EAB533DB144A203083O00C51B5CDF20D1BB11025O00C6AD40025O00F07340027O0040025O00804740025O0008914003083O00305AD7EF0A51C4E803043O009B633FA303143O0097C2A4BAB69686DEA7AAB58B90C89181B89D87C303063O00E4E2B1C1EDD903083O0007B537F23DBE24F503043O008654D04303173O0006BF836F1BA5835017A380481BA9B45514A492591CB99503043O003C73CCE6025O006C9540025O00A8A640025O00989140025O00807F40026O000840025O0028AD40025O00206840025O0020AA40025O00D2A940025O008AA640025O00149E4003083O00F871D1235B2D1ED803073O0079AB14A5573243031C3O00D32BBC14B507D52BB038BE2DC008AB39AD07C52CB039B724C93BAC2503063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E6031B3O00CF9A5A2000E8C99A560C0BC2DCBA5E011EE4DC805C072AE2D99C4C03063O008DBAE93F626C03083O00D43FFF64EE34EC6303043O0010875A8B03123O004167031F4F4D575A5C073D4A475E5B77132003073O0018341466532E3403083O00F72A353006CA283203053O006FA44F414403133O00D3CA86E921F8C2D685F922E5D4C0A5D12DFFD503063O008AA6B9E3BE4E025O00BEB140025O00E89840025O00207540025O0062AB4003083O001C17465AFE890C3C03073O006B4F72322E97E703113O002CB5B008983DB2CE2D82B02F8F37B3C52B03083O00A059C6D549EA59D703083O007B74A0EACC4676A703053O00A52811D49E030F3O00F0CA0D172FF3D0063615EDD00D3F2203053O004685B9685303083O007C50601C465B731B03043O00682F351403093O00B65F842EB90DB6478403063O006FC32CE17CDC03083O00EB431467A2A5DF5503063O00CBB8266013CB03123O002C607C69CF347E7C53C13F596C52DA30707C03053O00AE59131921025O00405140026O008540026O007740026O001040025O00D88F4003083O00C2EF38A22CFFED3F03053O0045918A4CD603103O0071DD8D8CB10254CA8F8CB11275DDA1B903063O007610AF2OE9DF03083O00B88121AFE7857A9803073O001DEBE455DB8EEB030E3O0039DDACD4794B145A34D1B6D95F7E03083O00325DB4DABD172E4703083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC03183O003B50DDA6FE740C324ADA95F47E04394BC89FF3730A2F6DEC03073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A351030C3O0016433AAC3161E4001E510B9303083O006E7A2243C35F2985025O00207240025O0074A540025O000C9E40025O00F9B14003083O0046B44F5EDF7BB64803053O00B615D13B2A030D3O00A058D7192EB8905BCA0F38968703063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03163O00B6820CCB7572AA8C11C67C44AC8D0DDA7C79B0992DFE03063O0016C5EA65AE1903083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB703113O00F515DFD38289F13BFD07E0F38FB4E31DC903083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD38403123O002282695BDDA993D43A9F6279DDACA1CB1DBD03083O00B855ED1B3FB2CFD4025O00EAAE40025O0066A04000DB012O0012C73O00014O00AC000100023O0026983O00070001000100043C3O000700010012C7000100014O00AC000200023O0012C73O00023O002E38000300020001000400043C3O000200010026983O00020001000200043C3O000200010026FF0001000F0001000100043C3O000F0001002ECA0006000B0001000500043C3O000B00010012C7000200013O002698000200430001000700043C3O00430001001292000300084O004B000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O00035O00122O000300086O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000300023O00122O000300086O000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000300033O00122O000300086O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000300043O00044O00DA2O01002698000200A10001000200043C3O00A100010012C7000300014O00AC000400043O0026FF0003004B0001000100043C3O004B0001002ECA001A00470001001900043C3O004700010012C7000400013O002698000400730001000100043C3O007300010012C7000500013O002ECA001C006C0001001B00043C3O006C00010026980005006C0001000100043C3O006C0001001292000600084O003A000700013O00122O0008001D3O00122O0009001E6O0007000900024O0006000600074O000700013O00122O0008001F3O00122O000900206O0007000900024O0006000600074O000600053O00122O000600086O000700013O00122O000800213O00122O000900226O0007000900024O0006000600074O000700013O00122O000800233O00122O000900246O0007000900024O0006000600074O000600063O00122O000500023O002E380026004F0001002500043C3O004F00010026980005004F0001000200043C3O004F00010012C7000400023O00043C3O0073000100043C3O004F0001000E4E002700770001000400043C3O007700010012C7000200273O00043C3O00A10001002E380028004C0001002900043C3O004C00010026980004004C0001000200043C3O004C00010012C7000500013O002698000500970001000100043C3O00970001001292000600084O003A000700013O00122O0008002A3O00122O0009002B6O0007000900024O0006000600074O000700013O00122O0008002C3O00122O0009002D6O0007000900024O0006000600074O000600073O00122O000600086O000700013O00122O0008002E3O00122O0009002F6O0007000900024O0006000600074O000700013O00122O000800303O00122O000900316O0007000900024O0006000600074O000600083O00122O000500023O0026FF0005009B0001000200043C3O009B0001002ECA0033007C0001003200043C3O007C00010012C7000400273O00043C3O004C000100043C3O007C000100043C3O004C000100043C3O00A1000100043C3O00470001002698000200F50001002700043C3O00F500010012C7000300014O00AC000400043O000E4E000100A50001000300043C3O00A500010012C7000400013O000E89002700AC0001000400043C3O00AC0001002ECA003400AE0001003500043C3O00AE00010012C7000200363O00043C3O00F500010026FF000400B20001000200043C3O00B20001002EBB003700270001003800043C3O00D700010012C7000500013O002ECA003A00B90001003900043C3O00B90001002698000500B90001000200043C3O00B900010012C7000400273O00043C3O00D70001000E89000100BD0001000500043C3O00BD0001002E38003B00B30001003C00043C3O00B30001001292000600084O00B4000700013O00122O0008003D3O00122O0009003E6O0007000900024O0006000600074O000700013O00122O0008003F3O00122O000900406O0007000900024O0006000600074O000600093O00122O000600086O000700013O00122O000800413O00122O000900426O0007000900024O0006000600074O000700013O00122O000800433O00122O000900446O0007000900024O0006000600074O0006000A3O00122O000500023O00044O00B30001002698000400A80001000100043C3O00A80001001292000500084O00B4000600013O00122O000700453O00122O000800466O0006000800024O0005000500064O000600013O00122O000700473O00122O000800486O0006000800024O0005000500064O0005000B3O00122O000500086O000600013O00122O000700493O00122O0008004A6O0006000800024O0005000500064O000600013O00122O0007004B3O00122O0008004C6O0006000800024O0005000500064O0005000C3O00122O000400023O00044O00A8000100043C3O00F5000100043C3O00A500010026FF000200F90001000100043C3O00F90001002ECA004D00392O01004E00043C3O00392O010012C7000300013O002ECA004F00172O01005000043C3O00172O01000E4E000200172O01000300043C3O00172O01001292000400084O003A000500013O00122O000600513O00122O000700526O0005000700024O0004000400054O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O0004000D3O00122O000400086O000500013O00122O000600553O00122O000700566O0005000700024O0004000400054O000500013O00122O000600573O00122O000700586O0005000700024O0004000400054O0004000E3O00122O000300273O002698000300322O01000100043C3O00322O01001292000400084O003A000500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O000500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O0004000F3O00122O000400086O000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000400103O00122O000300023O002EBB006100C8FF2O006100043C3O00FA0001002698000300FA0001002700043C3O00FA00010012C7000200023O00043C3O00392O0100043C3O00FA0001000E4E003600892O01000200043C3O00892O010012C7000300014O00AC000400043O000E89000100412O01000300043C3O00412O01002EBB006200FEFF2O006300043C3O003D2O010012C7000400013O002698000400462O01002700043C3O00462O010012C7000200643O00043C3O00892O01002EBB0065001D0001006500043C3O00632O01002698000400632O01000100043C3O00632O01001292000500084O003A000600013O00122O000700663O00122O000800676O0006000800024O0005000500064O000600013O00122O000700683O00122O000800696O0006000800024O0005000500064O000500113O00122O000500086O000600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000500123O00122O000400023O002698000400422O01000200043C3O00422O010012C7000500013O0026980005006A2O01000200043C3O006A2O010012C7000400273O00043C3O00422O01000E4E000100662O01000500043C3O00662O01001292000600084O00B4000700013O00122O0008006E3O00122O0009006F6O0007000900024O0006000600074O000700013O00122O000800703O00122O000900716O0007000900024O0006000600074O000600133O00122O000600086O000700013O00122O000800723O00122O000900736O0007000900024O0006000600074O000700013O00122O000800743O00122O000900756O0007000900024O0006000600074O000600143O00122O000500023O00044O00662O0100043C3O00422O0100043C3O00892O0100043C3O003D2O010026FF0002008D2O01006400043C3O008D2O01002E38007700100001007600043C3O001000010012C7000300013O002E38007800AB2O01007900043C3O00AB2O01002698000300AB2O01000100043C3O00AB2O01001292000400084O003A000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000500013O00122O0006007C3O00122O0007007D6O0005000700024O0004000400054O000400153O00122O000400086O000500013O00122O0006007E3O00122O0007007F6O0005000700024O0004000400054O000500013O00122O000600803O00122O000700816O0005000700024O0004000400054O000400163O00122O000300023O002698000300AF2O01002700043C3O00AF2O010012C7000200073O00043C3O001000010026980003008E2O01000200043C3O008E2O010012C7000400013O000E4E000100CD2O01000400043C3O00CD2O01001292000500084O003A000600013O00122O000700823O00122O000800836O0006000800024O0005000500064O000600013O00122O000700843O00122O000800856O0006000800024O0005000500064O000500173O00122O000500086O000600013O00122O000700863O00122O000800876O0006000800024O0005000500064O000600013O00122O000700883O00122O000800896O0006000800024O0005000500064O000500183O00122O000400023O0026FF000400D12O01000200043C3O00D12O01002EBB008A00E3FF2O008B00043C3O00B22O010012C7000300273O00043C3O008E2O0100043C3O00B22O0100043C3O008E2O0100043C3O0010000100043C3O00DA2O0100043C3O000B000100043C3O00DA2O0100043C3O000200012O006C3O00017O00763O00028O00025O004CAF40025O00288740026O00F03F025O006EA240025O002AAD40026O001040025O00F4B140025O00C4A240025O003CA040025O00606440030C3O004570696353652O74696E677303083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030D3O0050C056F6573BE44CCA59FF6B2O03073O009738A5379A235303083O00934611FAA94D02FD03043O008EC02365030F3O00DE7028AFEE82AB26D96120ACE9A49C03083O0076B61549C387ECCC03083O003B390E540D03FA1B03073O009D685C7A20646D03113O008BA3CEC634298A9BACB2C6C533098C2OA603083O00CBC3C6AFAA5D47ED034O00026O001440025O0014B040025O00088740025O005C9240025O00D4AF4003083O001D4E2AC1581FFB3D03073O009C4E2B5EB53171030F3O007AE9CAA707465874EEC8AA08577C7603073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA103113O0005ED25DE04D9AB23EF24C818D39028ED2703073O00E24D8C4BBA68BC025O00449540025O0086B240025O0058AF40025O00D0AF4003083O008ACBC42B46B7C9C303053O002FD9AEB05F03073O0090D8770E9D7B5B03083O0046D8BD1662D23418026O00184003083O00E9DAB793DAD4D8B003053O00B3BABFC3E703093O00D13A19E8D6103BCCC903043O0084995F78027O0040025O00BEAD40025O00F0934003083O006DC4BF32C650C6B803053O00AF3EA1CB46030E3O0028CFCA1D3E39C9D0243C28D5E03703053O00555CBDA373026O000840025O0058A140025O0009B140025O00806C4003083O00795D9CF643568FF103043O00822A38E8030B3O00FFA621D75236E4BE21F75303063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C123030A3O00396AE16A2D7AED59206A03043O00384C1984025O0016B040025O00F4AB4003083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103113O00A5BAE5C9D2312O75A2BAECD2E50B757BA803083O0018C3D382A1A6631003083O007506FD385A18411003063O00762663894C3303113O00D42811171B32E83611250034F515112O0703063O00409D4665726903083O0073ADB3F7194EAFB403053O007020C8C78303163O00055E48BDD1B9373C4473B6CFB215245948BDCFA2313803073O00424C303CD8A3CB025O00C6A640025O00D49D4003083O00B752EA4E8D59F94903043O003AE4379E030B3O009080C33E39A117A18FD63D03073O0055D4E9B04E5CCD025O00D08340025O00C6A14003083O0089836DE756C023A903073O0044DAE619933FAE03123O0084244749A4BF3F435882A538565FBEA2265703053O00D6CD4A332C03083O00C949F6E87EF44BF103053O00179A2C829C030D3O0035AF2OBE331F35A3AFBB30150203063O007371C6CDCE56025O000C9140025O00C2A540025O001EB240025O0030A640025O00309440025O003EB14003083O00D6B84324C63AE2AE03063O005485DD3750AF03103O00A8F4218EC25DB1EE2AA1F753A9EE2BA803063O003CDD8744C6A703083O001AA9242C20A2372B03043O005849CC50030D3O003C82134F28D63DB4195221F90A03063O00BA4EE370264903083O00CF52E9415A74FB4403063O001A9C379D3533030E3O0099CB13F1BD5180CC1ECAAC5F82DD03063O0030ECB876B9D80086012O0012C73O00014O00AC000100023O002E38000300090001000200043C3O00090001000E4E0001000900013O00043C3O000900010012C7000100014O00AC000200023O0012C73O00043O002ECA000500020001000600043C3O000200010026983O00020001000400043C3O000200010026980001000D0001000100043C3O000D00010012C7000200013O0026FF000200140001000700043C3O00140001002ECA0008004C0001000900043C3O004C00010012C7000300013O002E38000B00380001000A00043C3O00380001002698000300380001000100043C3O003800010012920004000C4O00EB000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500062O000400270001000100043C3O002700010012C7000400014O008300045O0012920004000C4O00EB000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000500013O00122O000600133O00122O000700146O0005000700024O00040004000500062O000400360001000100043C3O003600010012C7000400014O0083000400023O0012C7000300043O002698000300150001000400043C3O001500010012920004000C4O00EB000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000500013O00122O000600173O00122O000700186O0005000700024O00040004000500062O000400480001000100043C3O004800010012C7000400194O0083000400033O0012C70002001A3O00043C3O004C000100043C3O00150001002E38001C008B0001001B00043C3O008B00010026980002008B0001001A00043C3O008B00010012C7000300013O0026FF000300550001000100043C3O00550001002E38001E00780001001D00043C3O007800010012C7000400013O002698000400710001000100043C3O007100010012920005000C4O003A000600013O00122O0007001F3O00122O000800206O0006000800024O0005000500064O000600013O00122O000700213O00122O000800226O0006000800024O0005000500064O000500043O00122O0005000C6O000600013O00122O000700233O00122O000800246O0006000800024O0005000500064O000600013O00122O000700253O00122O000800266O0006000800024O0005000500064O000500053O00122O000400043O0026FF000400750001000400043C3O00750001002EBB002700E3FF2O002800043C3O005600010012C7000300043O00043C3O0078000100043C3O00560001000E890004007C0001000300043C3O007C0001002ECA002A00510001002900043C3O005100010012920004000C4O0055000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000500013O00122O0006002D3O00122O0007002E6O0005000700024O0004000400054O000400063O00122O0002002F3O00044O008B000100043C3O005100010026980002009D0001002F00043C3O009D00010012920003000C4O00EB000400013O00122O000500303O00122O000600316O0004000600024O0003000300044O000400013O00122O000500323O00122O000600336O0004000600024O00030003000400062O0003009B0001000100043C3O009B00010012C7000300014O0083000300073O00043C3O00852O01002698000200E00001003400043C3O00E000010012C7000300014O00AC000400043O002698000300A10001000100043C3O00A100010012C7000400013O002ECA003600B60001003500043C3O00B60001002698000400B60001000400043C3O00B600010012920005000C4O0055000600013O00122O000700373O00122O000800386O0006000800024O0005000500064O000600013O00122O000700393O00122O0008003A6O0006000800024O0005000500064O000500083O00122O0002003B3O00044O00E00001002698000400A40001000100043C3O00A400010012C7000500013O002ECA003C00BF0001003D00043C3O00BF0001002698000500BF0001000400043C3O00BF00010012C7000400043O00043C3O00A40001002EBB003E00FAFF2O003E00043C3O00B90001002698000500B90001000100043C3O00B900010012920006000C4O00B4000700013O00122O0008003F3O00122O000900406O0007000900024O0006000600074O000700013O00122O000800413O00122O000900426O0007000900024O0006000600074O000600093O00122O0006000C6O000700013O00122O000800433O00122O000900446O0007000900024O0006000600074O000700013O00122O000800453O00122O000900466O0007000900024O0006000600074O0006000A3O00122O000500043O00044O00B9000100043C3O00A4000100043C3O00E0000100043C3O00A100010026FF000200E40001000100043C3O00E40001002ECA0047000C2O01004800043C3O000C2O010012920003000C4O00EB000400013O00122O000500493O00122O0006004A6O0004000600024O0003000300044O000400013O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400062O000300F20001000100043C3O00F200010012C7000300014O00830003000B3O0012140003000C6O000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O0003000C3O00122O0003000C6O000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O000400013O00122O000500533O00122O000600546O0004000600024O0003000300044O0003000D3O00122O000200043O0026FF000200102O01000400043C3O00102O01002E38005500452O01005600043C3O00452O010012C7000300014O00AC000400043O002698000300122O01000100043C3O00122O010012C7000400013O002698000400252O01000400043C3O00252O010012920005000C4O0055000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O0005000E3O00122O000200343O00044O00452O01002ECA005B00152O01005C00043C3O00152O01000E4E000100152O01000400043C3O00152O010012920005000C4O00B4000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O0005000F3O00122O0005000C6O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O000500103O00122O000400043O00044O00152O0100043C3O00452O0100043C3O00122O01002ECA006500100001006600043C3O00100001002698000200100001003B00043C3O001000010012C7000300014O00AC000400043O002ECA0068004B2O01006700043C3O004B2O01000E4E0001004B2O01000300043C3O004B2O010012C7000400013O0026FF000400542O01000400043C3O00542O01002E38006A00622O01006900043C3O00622O010012920005000C4O0055000600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000600013O00122O0007006D3O00122O0008006E6O0006000800024O0005000500064O000500113O00122O000200073O00044O00100001002698000400502O01000100043C3O00502O010012920005000C4O00B4000600013O00122O0007006F3O00122O000800706O0006000800024O0005000500064O000600013O00122O000700713O00122O000800726O0006000800024O0005000500064O000500123O00122O0005000C6O000600013O00122O000700733O00122O000800746O0006000800024O0005000500064O000600013O00122O000700753O00122O000800766O0006000800024O0005000500064O000500133O00122O000400043O00044O00502O0100043C3O0010000100043C3O004B2O0100043C3O0010000100043C3O00852O0100043C3O000D000100043C3O00852O0100043C3O000200012O006C3O00017O0022012O00028O00025O006EAB40026O00F03F025O00A8A040025O00208D40025O0008AF40025O00D0B140025O000CA540025O00C6A340025O0002AF40030C3O004570696353652O74696E677303073O00CC20392FD9401103083O0024984F5E48B525622O033O00D4DC5403043O005FB7B82703073O008130E02158851103073O0062D55F874634E003063O00FAAADA6751F203053O00349EC3A917027O0040025O00108740025O0022A14003113O00476574456E656D696573496E52616E6765026O003E40025O00FEB140025O008CAA40025O00F49C40025O00389B40030D3O004973446561644F7247686F737403163O00476574456E656D696573496E4D656C2O6552616E6765026O002440026O000840025O0014A340025O0008A440025O0016B140025O0048B04003113O0027851507C7465102861632C64A5A01861D03073O003F65E97074B42F03073O004973526561647903153O00556E6974486173446562752O6646726F6D4C69737403073O00F33AE113FC3FCD03063O0056A35B8D729803113O0046722O65646F6D446562752O664C69737403163O00426C652O73696E676F6646722O65646F6D466F637573025O00E0B140025O004AB340031A3O0051077160295A05734C35553472613F560F7B7E7A500479713B4703053O005A336B1413025O00E4A640025O00488440030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O00C89540025O00A06040026O007B40025O00F07E40030C3O00466967687452656D61696E73024O0080B3C540025O00805040025O00C09640025O00708B40025O002CA94003103O00426F2O73466967687452656D61696E73025O00C06F40025O00B2A940031B3O00466F637573556E697457697468446562752O6646726F6D4C69737403073O003FAEA212FBE1E203083O00B16FCFCE739F888C026O004440026O003940025O002EA540025O00088640025O0094A340025O004CAA40030C3O00A9F593E02984FF8BCE289FF103053O005DED90E58F030A3O0049734361737461626C65030C3O004465766F74696F6E41757261025O00C05E40025O00508740030D3O0011F3E6161F4F1AF8CF181E541403063O0026759690796B026O001040026O001440025O005CB140025O00F08B40025O00809540025O00388240025O00F6A240025O002EA340025O0082AA40025O0052A540025O004FB040025O00E8B140025O00789D40026O001840030A3O001FBEEA3F20ABFA3322B503043O005A4DDB8E030A3O00D401253C41176EEF0B2F03073O001A866441592C6703063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B03133O00526564656D7074696F6E4D6F7573656F766572025O004C9040025O00D0A14003143O00E3E63426A9E1F7392CAAB1EE3F36B7F4EC2O26B603053O00C491835043025O00D88440025O00C05140030C3O0037BE120D0AEB1BA3150117E603063O00887ED066687803093O00486F6C79506F776572030C3O005184DA46BD5138426B83C14D03083O003118EAAE23CF325D025O0082B140025O00D2A540025O00888140025O00A7B14003153O00496E74657263652O73696F6E4D6F7573656F766572030C3O0025FCE98D630FF7EE9B7803FC03053O00116C929DE8025O00288540025O00689640025O0016A640025O00F8A340025O0044A840025O0044B340025O00049340025O00707F40025O00907B40025O0007B340030F3O0048616E646C65412O666C6963746564030D3O00436C65616E7365546F78696E7303163O00436C65616E7365546F78696E734D6F7573656F766572025O004EAD40025O00D8864003063O0042752O66557003143O005368696E696E674C6967687446722O6542752O66025O00A6A340025O00309C40025O0080A740025O00109E40030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572025O00707240025O00DCB240025O00F49A40025O0069B040025O00CCA040025O0008A840025O003AB24003113O0048616E646C65496E636F72706F7265616C030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573654F766572025O00AC9F40025O00ACA74003083O005475726E4576696C03113O005475726E4576696C4D6F7573654F766572025O005AA940025O00DCAB40025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD40025O00BFB040026O005F40025O0012A440025O009CAE40025O00A4A840025O00B89F40025O0062AD40025O00508540025O002OA040025O00208A40025O0072A240025O009C9040025O00F89B40025O002AA940025O006BB140025O0016AE40030C3O0062CD00E83DAB4ED007E420A603063O00C82BA3748D4F025O0032A740025O00109D40030C3O00496E74657263652O73696F6E03093O004973496E52616E6765025O0096A040025O00804340030C3O00B6382986A2F7E6AC25348CBE03073O0083DF565DE3D094030A3O00D140B2B310A5F74CB9B803063O00D583252OD67D030A3O00526564656D7074696F6E025O00206940030A3O00342E21BAEC363F2CB0EF03053O0081464B45DF030C3O0049734368612O6E656C696E6703093O00497343617374696E67025O00F2B040025O007DB140025O00109B40025O00B2AB40025O00949140026O00504003043O00502O6F6C025O001EA940025O004AAF4003133O00576169742F502O6F6C205265736F7572636573025O00DEA240025O00C88440025O00049140025O003AA140025O00C4A040025O00A08340025O00AEAA40025O0061B140025O00949B40025O00D6B040026O002040025O00508C40026O006940026O00A840025O00AAA040025O00408C40025O00E09540025O00708640025O002EAE40025O0066A340025O005EA14003073O003486EEB90C8CFA03043O00DE60E9892O033O00B8BCA203073O0090D9D3C77FE893025O00F49540025O00E88940025O001AAA40026O00AE40025O00408F4003073O0085BD092AFBDFB303073O00C0D1D26E4D97BA2O033O00EF0C2103063O00A4806342899F025O00C8A440025O00D09D40030C3O00497354616E6B696E67416F4503093O00497354616E6B696E6703093O0049734D6F756E746564025O00E0A140025O009EA340030C3O0059AE276787317E995BA9207503083O00EB1ADC5214E6551B03083O0042752O66446F776E030C3O00437275736164657241757261025O0010AC40025O0039B140030D3O008BB3FCD1758CA4FBFD759DB3E803053O0014E8C189A2025O00E9B240025O005EA740025O005EA640025O00D8A340025O00E2A740025O00D6B240025O0050B240025O0044974003163O004163746976654D697469676174696F6E4E2O65646564026O008A40025O00A2B240025O00389E40025O00ACB140025O0074A440025O0046B040025O0049B040025O001AAD40025O00805540030D3O0001D3C0A7E99F12452DC7CCA8F403083O001142BFA5C687EC7703093O00466F637573556E6974026O003440025O00206340025O00609C40025O00EAA140025O000EA640025O001AA940025O005EB240025O000EAA40025O0002A9400068052O0012C73O00014O00AC000100033O002EBB0002005A0501000200043C3O005C05010026983O005C0501000300043C3O005C05012O00AC000300033O000E4E0003003E0501000100043C3O003E0501002EBB0004005A0001000400043C3O00630001000E4E000300630001000200043C3O006300010012C7000400014O00AC000500053O0026980004000F0001000100043C3O000F00010012C7000500013O002ECA0005003B0001000600043C3O003B00010026980005003B0001000100043C3O003B00010012C7000600013O0026FF0006001B0001000300043C3O001B0001002ECA0007001D0001000800043C3O001D00010012C7000500033O00043C3O003B0001000E89000100210001000600043C3O00210001002ECA000A00170001000900043C3O001700010012920007000B4O00B4000800013O00122O0009000C3O00122O000A000D6O0008000A00024O0007000700084O000800013O00122O0009000E3O00122O000A000F6O0008000A00024O0007000700084O00075O00122O0007000B6O000800013O00122O000900103O00122O000A00116O0008000A00024O0007000700084O000800013O00122O000900123O00122O000A00136O0008000A00024O0007000700084O000700023O00122O000600033O00044O001700010026FF0005003F0001001400043C3O003F0001002E38001600460001001500043C3O004600012O00CB000600043O00208400060006001700122O000800186O0006000800024O000600033O00122O000200143O00044O00630001002698000500120001000300043C3O001200010012C7000600013O002ECA001A004F0001001900043C3O004F00010026980006004F0001000300043C3O004F00010012C7000500143O00043C3O00120001002698000600490001000100043C3O00490001002E38001C00590001001B00043C3O005900012O00CB000700043O0020C400070007001D2O007500070002000200060F0007005900013O00043C3O005900012O006C3O00014O00CB000700043O00208400070007001E00122O0009001F6O0007000900024O000700053O00122O000600033O00044O0049000100043C3O0012000100043C3O0063000100043C3O000F00010026FF000200670001002000043C3O00670001002E380022000A2O01002100043C3O000A2O010012C7000400013O002ECA002400CC0001002300043C3O00CC0001002698000400CC0001000300043C3O00CC00012O00CB000500064O00A8000600013O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500274O00050002000200062O0005009000013O00043C3O009000012O00CB000500073O0020160005000500284O000600086O000700096O000800013O00122O000900293O00122O000A002A6O0008000A00024O00070007000800202O00070007002B4O00050007000200062O0005009000013O00043C3O009000012O00CB0005000A4O00CB0006000B3O0020B200060006002C2O007500050002000200061B0005008B0001000100043C3O008B0001002E38002E00900001002D00043C3O009000012O00CB000500013O0012C70006002F3O0012C7000700304O00C2000500074O003E00055O002E38003200CB0001003100043C3O00CB00012O00CB000500073O0020B20005000500332O00F500050001000200061B0005009C0001000100043C3O009C00012O00CB000500043O0020C40005000500342O007500050002000200060F000500CB00013O00043C3O00CB00010012C7000500014O00AC000600063O000E89000100A20001000500043C3O00A20001002E380035009E0001003600043C3O009E00010012C7000600013O0026FF000600A70001000300043C3O00A70001002EBB0037000C0001003800043C3O00B10001001292000700393O002698000700CB0001003A00043C3O00CB00012O00CB0007000C3O0020CD0007000700394O000800056O00098O00070009000200122O000700393O00044O00CB0001002E38003B00A30001003C00043C3O00A30001002698000600A30001000100043C3O00A300010012C7000700013O0026FF000700BA0001000100043C3O00BA0001002ECA003E00C30001003D00043C3O00C300012O00CB0008000C3O00209000080008003F4O000900096O000A00016O0008000A000200122O0008003F3O00122O0008003F3O00122O000800393O00122O000700033O002698000700B60001000300043C3O00B600010012C7000600033O00043C3O00A3000100043C3O00B6000100043C3O00A3000100043C3O00CB000100043C3O009E00010012C7000400143O0026FF000400D00001000100043C3O00D00001002ECA004100E30001004000043C3O00E300012O00CB000500073O0020B70005000500424O000600096O000700013O00122O000800433O00122O000900446O0007000900024O00060006000700202O00060006002B00122O000700453O00122O000800466O0005000800024O000300053O00062O000300E10001000100043C3O00E10001002ECA004700E20001004800043C3O00E200012O0029000300023O0012C7000400033O002698000400680001001400043C3O006800012O00CB000500043O0020C40005000500342O007500050002000200060F000500EC00013O00043C3O00EC0001002ECA004A00072O01004900043C3O00072O012O00CB000500064O00A8000600013O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O00050005004D4O00050002000200062O000500072O013O00043C3O00072O012O00CB0005000D4O00F500050001000200060F000500072O013O00043C3O00072O012O00CB0005000A4O00CB000600063O0020B200060006004E2O007500050002000200061B000500022O01000100043C3O00022O01002E38005000072O01004F00043C3O00072O012O00CB000500013O0012C7000600513O0012C7000700524O00C2000500074O003E00055O0012C7000200533O00043C3O000A2O0100043C3O006800010026FF0002000E2O01005400043C3O000E2O01002ECA005500E32O01005600043C3O00E32O010012C7000400014O00AC000500053O002E38005800102O01005700043C3O00102O01002698000400102O01000100043C3O00102O010012C7000500013O0026FF000500192O01001400043C3O00192O01002EBB005900310001005A00043C3O00482O012O00CB000600073O0020B20006000600332O00F500060001000200060F000600462O013O00043C3O00462O012O00CB000600043O0020C40006000600342O007500060002000200061B000600462O01000100043C3O00462O012O00CB0006000E3O00060F000600462O013O00043C3O00462O010012C7000600014O00AC000700083O002ECA005C002F2O01005B00043C3O002F2O010026980006002F2O01000100043C3O002F2O010012C7000700014O00AC000800083O0012C7000600033O002EBB005D00F9FF2O005D00043C3O00282O01000E4E000300282O01000600043C3O00282O01002E38005F00332O01005E00043C3O00332O01002698000700332O01000100043C3O00332O010012C7000800013O002698000800382O01000100043C3O00382O012O00CB0009000F4O00F50009000100022O006B000300093O00060F000300462O013O00043C3O00462O012O0029000300023O00043C3O00462O0100043C3O00382O0100043C3O00462O0100043C3O00332O0100043C3O00462O0100043C3O00282O010012C7000200603O00043C3O00E32O01002698000500512O01000100043C3O00512O012O00CB000600104O00F50006000100022O006B000300063O00060F000300502O013O00043C3O00502O012O0029000300023O0012C7000500033O002698000500152O01000300043C3O00152O010012C7000600013O002698000600582O01000300043C3O00582O010012C7000500143O00043C3O00152O01002698000600542O01000100043C3O00542O012O00CB000700064O00A8000800013O00122O000900613O00122O000A00626O0008000A00024O00070007000800202O00070007004D4O00070002000200062O000700952O013O00043C3O00952O012O00CB000700064O00A8000800013O00122O000900633O00122O000A00646O0008000A00024O00070007000800202O0007000700274O00070002000200062O000700952O013O00043C3O00952O012O00CB000700043O0020C40007000700342O007500070002000200061B000700952O01000100043C3O00952O012O00CB000700113O0020C40007000700652O007500070002000200060F000700952O013O00043C3O00952O012O00CB000700113O0020C400070007001D2O007500070002000200060F000700952O013O00043C3O00952O012O00CB000700113O0020C40007000700662O007500070002000200060F000700952O013O00043C3O00952O012O00CB000700043O0020C40007000700672O00CB000900114O009700070009000200061B000700952O01000100043C3O00952O012O00CB0007000A4O00CB0008000B3O0020B20008000800682O007500070002000200061B000700902O01000100043C3O00902O01002ECA006A00952O01006900043C3O00952O012O00CB000700013O0012C70008006B3O0012C70009006C4O00C2000700094O003E00076O00CB000700043O0020C40007000700342O007500070002000200061B0007009C2O01000100043C3O009C2O01002E38006D00DE2O01006E00043C3O00DE2O012O00CB000700064O00A8000800013O00122O0009006F3O00122O000A00706O0008000A00024O00070007000800202O00070007004D4O00070002000200062O000700CF2O013O00043C3O00CF2O012O00CB000700043O0020C40007000700712O0075000700020002000EB3002000CF2O01000700043C3O00CF2O012O00CB000700064O00A8000800013O00122O000900723O00122O000A00736O0008000A00024O00070007000800202O0007000700274O00070002000200062O000700CF2O013O00043C3O00CF2O012O00CB000700043O0020C40007000700342O007500070002000200060F000700CF2O013O00043C3O00CF2O012O00CB000700113O0020C40007000700652O007500070002000200060F000700CF2O013O00043C3O00CF2O012O00CB000700113O0020C400070007001D2O007500070002000200060F000700CF2O013O00043C3O00CF2O012O00CB000700113O0020C40007000700662O007500070002000200060F000700CF2O013O00043C3O00CF2O012O00CB000700043O0020C40007000700672O00CB000900114O009700070009000200060F000700D12O013O00043C3O00D12O01002E38007400DE2O01007500043C3O00DE2O01002E38007600DE2O01007700043C3O00DE2O012O00CB0007000A4O00CB0008000B3O0020B20008000800782O007500070002000200060F000700DE2O013O00043C3O00DE2O012O00CB000700013O0012C7000800793O0012C70009007A4O00C2000700094O003E00075O0012C7000600033O00043C3O00542O0100043C3O00152O0100043C3O00E32O0100043C3O00102O01002698000200CF0201005300043C3O00CF02010012C7000400013O000E89000100EA2O01000400043C3O00EA2O01002EBB007B00AD0001007C00043C3O009502010012C7000500013O002EBB007D00A50001007D00043C3O00900201002698000500900201000100043C3O00900201002EBB007E00580001007E00043C3O004702012O00CB000600123O00060F0006004702013O00043C3O004702010012C7000600014O00AC000700073O0026FF000600FA2O01000100043C3O00FA2O01002ECA008000F62O01007F00043C3O00F62O010012C7000700013O002698000700FB2O01000100043C3O00FB2O012O00CB000800133O00061B0008002O0201000100043C3O002O0201002ECA0081001D0201008200043C3O001D02010012C7000800014O00AC000900093O0026FF000800080201000100043C3O00080201002ECA008400040201008300043C3O000402010012C7000900013O002698000900090201000100043C3O000902012O00CB000A00073O002070000A000A00854O000B00063O00202O000B000B00864O000C000B3O00202O000C000C008700122O000D00456O000A000D00024O0003000A3O002E2O0089001D0201008800043C3O001D020100060F0003001D02013O00043C3O001D02012O0029000300023O00043C3O001D020100043C3O0009020100043C3O001D020100043C3O000402012O00CB000800043O0020B600080008008A4O000A00063O00202O000A000A008B4O0008000A000200062O0008004702013O00043C3O004702012O00CB000800143O00060F0008004702013O00043C3O004702010012C7000800014O00AC000900093O0026FF0008002D0201000100043C3O002D0201002E38008C00290201008D00043C3O002902010012C7000900013O002E38008F002E0201008E00043C3O002E02010026980009002E0201000100043C3O002E02012O00CB000A00073O002042000A000A00854O000B00063O00202O000B000B00904O000C000B3O00202O000C000C009100122O000D00456O000E00016O000A000E00024O0003000A3O00062O0003004702013O00043C3O004702012O0029000300023O00043C3O0047020100043C3O002E020100043C3O0047020100043C3O0029020100043C3O0047020100043C3O00FB2O0100043C3O0047020100043C3O00F62O01002EBB009200480001009200043C3O008F02012O00CB000600153O00060F0006008F02013O00043C3O008F02010012C7000600014O00AC000700083O002698000600890201000300043C3O00890201002ECA009400500201009300043C3O00500201002698000700500201000100043C3O005002010012C7000800013O0026FF000800590201000100043C3O00590201002E38009500710201009600043C3O007102010012C7000900013O0026FF0009005E0201000100043C3O005E0201002ECA0098006C0201009700043C3O006C02012O00CB000A00073O002042000A000A00994O000B00063O00202O000B000B009A4O000C000B3O00202O000C000C009B00122O000D00186O000E00016O000A000E00024O0003000A3O00062O0003006B02013O00043C3O006B02012O0029000300023O0012C7000900033O0026980009005A0201000300043C3O005A02010012C7000800033O00043C3O0071020100043C3O005A02010026FF000800750201000300043C3O00750201002ECA009D00550201009C00043C3O005502012O00CB000900073O00201F0009000900994O000A00063O00202O000A000A009E4O000B000B3O00202O000B000B009F00122O000C00186O000D00016O0009000D00024O000300093O002E2O00A0008F020100A100043C3O008F020100060F0003008F02013O00043C3O008F02012O0029000300023O00043C3O008F020100043C3O0055020100043C3O008F020100043C3O0050020100043C3O008F02010026980006004E0201000100043C3O004E02010012C7000700014O00AC000800083O0012C7000600033O00043C3O004E02010012C7000500033O002698000500EB2O01000300043C3O00EB2O010012C7000400033O00043C3O0095020100043C3O00EB2O010026FF000400990201001400043C3O00990201002ECA00A200C5020100A300043C3O00C502012O00CB000500083O00060F000500C302013O00043C3O00C302012O00CB000500163O00060F000500C302013O00043C3O00C302010012C7000500014O00AC000600073O002E3800A400BB020100A500043C3O00BB0201002698000500BB0201000300043C3O00BB0201002E3800A600A5020100A700043C3O00A50201002698000600A50201000100043C3O00A502010012C7000700013O002ECA00A900AA020100A800043C3O00AA0201002698000700AA0201000100043C3O00AA02012O00CB000800174O00F50008000100022O006B000300083O002ECA00AA00C3020100AB00043C3O00C3020100060F000300C302013O00043C3O00C302012O0029000300023O00043C3O00C3020100043C3O00AA020100043C3O00C3020100043C3O00A5020100043C3O00C302010026FF000500BF0201000100043C3O00BF0201002ECA00AC00A1020100AD00043C3O00A102010012C7000600014O00AC000700073O0012C7000500033O00043C3O00A102010012C7000200543O00043C3O00CF0201002698000400E62O01000300043C3O00E62O012O00CB000500184O00F50005000100022O006B000300053O00060F000300CD02013O00043C3O00CD02012O0029000300023O0012C7000400143O00043C3O00E62O010026FF000200D30201006000043C3O00D30201002ECA00AE00FE030100AF00043C3O00FE0301002E3800B10067050100B000043C3O006705012O00CB000400073O0020B20004000400332O00F500040001000200060F0004006705013O00043C3O006705010012C7000400014O00AC000500063O0026FF000400E00201000300043C3O00E00201002ECA00B200F5030100B300043C3O00F503010026FF000500E40201000100043C3O00E40201002ECA00B500E0020100B400043C3O00E002010012C7000600013O002698000600E50201000100043C3O00E502012O00CB000700193O0020C40007000700652O007500070002000200060F0007004003013O00043C3O004003012O00CB000700193O0020C40007000700662O007500070002000200060F0007004003013O00043C3O004003012O00CB000700193O0020C400070007001D2O007500070002000200060F0007004003013O00043C3O004003012O00CB000700043O0020C40007000700672O00CB000900194O009700070009000200061B000700400301000100043C3O00400301002ECA00B70023030100B600043C3O002303012O00CB000700043O0020C40007000700342O007500070002000200060F0007002303013O00043C3O002303012O00CB000700064O00C3000800013O00122O000900B83O00122O000A00B96O0008000A00024O00070007000800202O00070007004D4O00070002000200062O0007000F0301000100043C3O000F0301002ECA00BA0040030100BB00043C3O004003012O00CB0007000A4O00BA000800063O00202O0008000800BC4O000900193O00202O0009000900BD00122O000B00186O0009000B00024O000900096O000A00016O0007000A000200062O0007001D0301000100043C3O001D0301002EBB00BE0025000100BF00043C3O004003012O00CB000700013O0012A4000800C03O00122O000900C16O000700096O00075O00044O004003012O00CB000700064O00A8000800013O00122O000900C23O00122O000A00C36O0008000A00024O00070007000800202O00070007004D4O00070002000200062O0007004003013O00043C3O004003012O00CB0007000A4O00BA000800063O00202O0008000800C44O000900193O00202O0009000900BD00122O000B00186O0009000B00024O000900096O000A00016O0007000A000200062O0007003B0301000100043C3O003B0301002ECA00040040030100C500043C3O004003012O00CB000700013O0012C7000800C63O0012C7000900C74O00C2000700094O003E00076O00CB000700073O0020B20007000700332O00F500070001000200060F0007006705013O00043C3O006705012O00CB000700043O0020C40007000700C82O007500070002000200061B000700670501000100043C3O006705012O00CB000700043O0020C40007000700C92O007500070002000200061B000700670501000100043C3O006705012O00CB000700043O0020C40007000700342O007500070002000200060F0007006705013O00043C3O006705010012C7000700014O00AC000800083O0026FF0007005A0301000100043C3O005A0301002ECA00CB0056030100CA00043C3O005603010012C7000800013O0026FF0008005F0301001400043C3O005F0301002ECA00CD006F030100CC00043C3O006F0301002ECA00CF0064030100CE00043C3O0064030100060F0003006403013O00043C3O006403012O0029000300024O00CB0009000A4O00CB000A00063O0020B2000A000A00D02O007500090002000200061B0009006C0301000100043C3O006C0301002E3800D20067050100D100043C3O006705010012C7000900D34O0029000900023O00043C3O00670501002698000800A50301000100043C3O00A503010012C7000900013O002E3800D50078030100D400043C3O00780301002698000900780301000300043C3O007803010012C7000800033O00043C3O00A503010026FF0009007C0301000100043C3O007C0301002E3800D70072030100D600043C3O007203012O00CB000A001A3O00060F000A008C03013O00043C3O008C03010012C7000A00013O0026FF000A00840301000100043C3O00840301002ECA00D80080030100D900043C3O008003012O00CB000B001B4O00F5000B000100022O006B0003000B3O00060F0003008C03013O00043C3O008C03012O0029000300023O00043C3O008C030100043C3O008003012O00CB000A001C3O001292000B00393O00064C000A00A30301000B00043C3O00A303010012C7000A00014O00AC000B000B3O002698000A00920301000100043C3O009203010012C7000B00013O0026FF000B00990301000100043C3O00990301002ECA00DB0095030100DA00043C3O009503012O00CB000C001D4O00F5000C000100022O006B0003000C3O00060F000300A303013O00043C3O00A303012O0029000300023O00043C3O00A3030100043C3O0095030100043C3O00A3030100043C3O009203010012C7000900033O00043C3O007203010026980008005B0301000300043C3O005B03010012C7000900014O00AC000A000A3O000E4E000100A90301000900043C3O00A903010012C7000A00013O000E4E000300B00301000A00043C3O00B003010012C7000800143O00043C3O005B03010026FF000A00B40301000100043C3O00B40301002E3800DD00AC030100DC00043C3O00AC03012O00CB000B001E3O00060F000B00E603013O00043C3O00E603012O00CB000B5O00060F000B00BD03013O00043C3O00BD03012O00CB000B001F3O00061B000B00C00301000100043C3O00C003012O00CB000B001F3O00061B000B00E60301000100043C3O00E603012O00CB000B00193O0020C4000B000B00BD0012C7000D00DE4O0097000B000D000200060F000B00E603013O00043C3O00E603010012C7000B00014O00AC000C000D3O002E3800E000CF030100DF00043C3O00CF0301000E4E000100CF0301000B00043C3O00CF03010012C7000C00014O00AC000D000D3O0012C7000B00033O002698000B00C80301000300043C3O00C803010026FF000C00D50301000100043C3O00D50301002ECA00E100D1030100E200043C3O00D103010012C7000D00013O002698000D00D60301000100043C3O00D603012O00CB000E00204O00F5000E000100022O006B0003000E3O002ECA00E300E6030100E400043C3O00E6030100060F000300E603013O00043C3O00E603012O0029000300023O00043C3O00E6030100043C3O00D6030100043C3O00E6030100043C3O00D1030100043C3O00E6030100043C3O00C803012O00CB000B00214O00F5000B000100022O006B0003000B3O0012C7000A00033O00043C3O00AC030100043C3O005B030100043C3O00A9030100043C3O005B030100043C3O0067050100043C3O0056030100043C3O0067050100043C3O00E5020100043C3O0067050100043C3O00E0020100043C3O006705010026FF000400F90301000100043C3O00F90301002E3800E600DC020100E500043C3O00DC02010012C7000500014O00AC000600063O0012C7000400033O00043C3O00DC020100043C3O00670501000E4E000100400401000200043C3O004004010012C7000400014O00AC000500053O002698000400020401000100043C3O000204010012C7000500013O000E89001400090401000500043C3O00090401002EBB00E70010000100E800043C3O001704010012920006000B4O0055000700013O00122O000800E93O00122O000900EA6O0007000900024O0006000600074O000700013O00122O000800EB3O00122O000900EC6O0007000900024O0006000600074O000600223O00122O000200033O00044O00400401002ECA00EE002A040100ED00043C3O002A04010026980005002A0401000100043C3O002A04010012C7000600013O002698000600230401000100043C3O002304012O00CB000700234O00690007000100012O00CB000700244O00690007000100010012C7000600033O002E3800EF001C040100E600043C3O001C04010026980006001C0401000300043C3O001C04010012C7000500033O00043C3O002A040100043C3O001C0401002E3800F10005040100F000043C3O00050401002698000500050401000300043C3O000504012O00CB000600254O007100060001000100122O0006000B6O000700013O00122O000800F23O00122O000900F36O0007000900024O0006000600074O000700013O00122O000800F43O00122O000900F56O0007000900024O0006000600074O0006000E3O00122O000500143O00044O0005040100043C3O0040040100043C3O000204010026FF000200440401001400043C3O00440401002E3800F60009000100F700043C3O000900010012C7000400013O0026980004008C0401000300043C3O008C04010012C7000500013O000E4E000100820401000500043C3O008204012O00CB000600043O0020C40006000600F80012C7000800DE4O009700060008000200061B000600540401000100043C3O005404012O00CB000600043O0020C40006000600F92O00CB000800194O00970006000800022O00830006001A4O00CB000600043O0020C40006000600342O007500060002000200061B0006005F0401000100043C3O005F04012O00CB000600043O0020C40006000600FA2O007500060002000200061B000600610401000100043C3O00610401002E3800FC0081040100FB00043C3O008104012O00CB000600064O00A8000700013O00122O000800FD3O00122O000900FE6O0007000900024O00060006000700202O00060006004D4O00060002000200062O0006007204013O00043C3O007204012O00CB000600043O0020F10006000600FF4O000800063O00202O000800082O00013O00060008000200062O000600760401000100043C3O007604010012C70006002O012O0012C700070002012O0006F7000700810401000600043C3O008104012O00CB0006000A4O00CB000700063O0020B2000700072O0001007500060002000200060F0006008104013O00043C3O008104012O00CB000600013O0012C700070003012O0012C700080004013O00C2000600084O003E00065O0012C7000500033O0012C7000600033O000635000600890401000500043C3O008904010012C700060005012O0012C700070006012O00064C000600480401000700043C3O004804010012C7000400143O00043C3O008C040100043C3O004804010012C7000500013O00069A000500D40401000400043C3O00D404012O00CB000500223O00060F000500BD04013O00043C3O00BD04010012C7000500014O00AC000600073O0012C7000800013O00069A0005009A0401000800043C3O009A04010012C7000600014O00AC000700073O0012C7000500033O0012C7000800033O000635000500A10401000800043C3O00A104010012C700080007012O0012C700090008012O0006F7000800940401000900043C3O009404010012C700080009012O0012C70009000A012O0006F7000800A10401000900043C3O00A104010012C7000800013O00069A000600A10401000800043C3O00A104010012C7000700013O0012C7000800013O000635000700B00401000800043C3O00B004010012C70008000B012O0012C70009000C012O00064C000800A90401000900043C3O00A904012O00CB000800054O00A6000800086O000800266O000800036O000800086O000800273O00044O00CE040100043C3O00A9040100043C3O00CE040100043C3O00A1040100043C3O00CE040100043C3O0094040100043C3O00CE04010012C7000500014O00AC000600063O0012C7000700013O00069A000700BF0401000500043C3O00BF04010012C7000600013O0012C7000700013O00069A000600C30401000700043C3O00C304010012C7000700034O0083000700263O0012C7000700034O0083000700273O00043C3O00CE040100043C3O00C3040100043C3O00CE040100043C3O00BF04012O00CB000500043O0012030107000D015O0005000500074O0005000200024O000500283O00122O000400033O0012C7000500143O000635000400DB0401000500043C3O00DB04010012C70005000E012O0012C70006000F012O0006F7000600450401000500043C3O004504012O00CB000500043O0020C40005000500342O007500050002000200061B000500E30401000100043C3O00E304012O00CB000500163O00060F0005003905013O00043C3O003905010012C7000500014O00AC000600073O0012C7000800033O00069A0005002E0501000800043C3O002E05010012C700080010012O0012C700090010012O00069A000800F30401000900043C3O00F304010012C7000800033O00069A000600F30401000800043C3O00F3040100060F0003003905013O00043C3O003905012O0029000300023O00043C3O003905010012C7000800013O000635000600FA0401000800043C3O00FA04010012C700080011012O0012C700090012012O0006F7000800E80401000900043C3O00E804010012C7000800014O00AC000900093O0012C7000A00013O00069A000800FC0401000A00043C3O00FC04010012C7000900013O0012C7000A00033O000635000900070501000A00043C3O000705010012C7000A0013012O0012C7000B0014012O0006F7000B00090501000A00043C3O000905010012C7000600033O00043C3O00E804010012C7000A00013O000635000900100501000A00043C3O001005010012C7000A0015012O0012C7000B0016012O00064C000A2O000501000B00043C4O0005012O00CB000A00163O0006610007001E0501000A00043C3O001E05012O00CB000A00064O0024000B00013O00122O000C0017012O00122O000D0018015O000B000D00024O000A000A000B00202O000A000A00274O000A0002000200062O0007001E0501000A00043C3O001E05012O00CB000700024O00CB000A00073O0012FC000B0019015O000A000A000B4O000B00076O000C000B3O00122O000D001A015O000E000E3O00122O000F00466O000A000F00024O0003000A3O00122O000900033O00045O00050100043C3O00E8040100043C3O00FC040100043C3O00E8040100043C3O003905010012C7000800013O000635000500350501000800043C3O003505010012C70008000A012O0012C70009001B012O0006F7000800E50401000900043C3O00E504010012C7000600014O00AC000700073O0012C7000500033O00043C3O00E504010012C7000200203O00043C3O0009000100043C3O0045040100043C3O0009000100043C3O006705010012C7000400013O000635000100450501000400043C3O004505010012C70004001C012O0012C70005001D012O00064C000500070001000400043C3O000700010012C7000400013O0012C7000500013O0006350004004D0501000500043C3O004D05010012C70005001E012O0012C70006001F012O0006F7000600500501000500043C3O005005010012C7000200014O00AC000300033O0012C7000400033O0012C700050020012O0012C7000600E23O00064C000600460501000500043C3O004605010012C7000500033O00069A000400460501000500043C3O004605010012C7000100033O00043C3O0007000100043C3O0046050100043C3O0007000100043C3O006705010012C7000400013O0006350004006305013O00043C3O006305010012C700040021012O0012C700050022012O0006F7000400020001000500043C3O000200010012C7000100014O00AC000200023O0012C73O00033O00043C3O000200012O006C3O00017O000A3O00028O00026O00F03F025O0026AA40025O00D09640025O0053B240025O0013B14003053O005072696E7403303O0076D9FCFD79EC52C2FCE73CDF47C7F2ED75E106C9EAA959FF4FC8BDA94FFA56DBFCFB68EA428BF1F03CF76DCAFDEC68E003063O008F26AB93891C025O0020834000243O0012C73O00014O00AC000100023O0026FF3O00060001000200043C3O00060001002E380003001B0001000400043C3O001B0001002698000100060001000100043C3O000600010012C7000200013O0026FF0002000D0001000100043C3O000D0001002E38000500090001000600043C3O000900012O00CB00035O0020C90003000300074O000400013O00122O000500083O00122O000600096O000400066O00033O00014O000300026O00030001000100044O0023000100043C3O0009000100043C3O0023000100043C3O0006000100043C3O00230001002EBB000A00E7FF2O000A00043C3O000200010026983O00020001000100043C3O000200010012C7000100014O00AC000200023O0012C73O00023O00043C3O000200012O006C3O00017O00", GetFEnv(), ...);

