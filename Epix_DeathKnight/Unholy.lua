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
				if (Enum <= 141) then
					if (Enum <= 70) then
						if (Enum <= 34) then
							if (Enum <= 16) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												if (Stk[Inst[2]] > Inst[4]) then
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
										elseif (Enum == 2) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
									elseif (Enum > 6) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
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
											A = Inst[2];
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
											if (Stk[Inst[2]] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 10) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 13) then
									if (Enum > 12) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 14) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 15) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 25) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum == 17) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 19) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
								elseif (Enum <= 22) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 23) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 24) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								end
							elseif (Enum <= 29) then
								if (Enum <= 27) then
									if (Enum > 26) then
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
								elseif (Enum == 28) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
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
							elseif (Enum <= 31) then
								if (Enum == 30) then
									if (Inst[2] > Stk[Inst[4]]) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 32) then
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
							elseif (Enum == 33) then
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 52) then
							if (Enum <= 43) then
								if (Enum <= 38) then
									if (Enum <= 36) then
										if (Enum > 35) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									elseif (Enum > 37) then
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
										VIP = Inst[3];
									end
								elseif (Enum <= 40) then
									if (Enum == 39) then
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
									else
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
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									end
								elseif (Enum <= 41) then
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
								elseif (Enum == 42) then
									if (Inst[2] < Stk[Inst[4]]) then
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
							elseif (Enum <= 47) then
								if (Enum <= 45) then
									if (Enum > 44) then
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
								elseif (Enum == 46) then
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
							elseif (Enum <= 49) then
								if (Enum > 48) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 50) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum > 51) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 61) then
							if (Enum <= 56) then
								if (Enum <= 54) then
									if (Enum > 53) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum == 55) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								else
									local T;
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
									T = Stk[A];
									for Idx = A + 1, Top do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 58) then
								if (Enum > 57) then
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
							elseif (Enum <= 59) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 60) then
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
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
						elseif (Enum <= 65) then
							if (Enum <= 63) then
								if (Enum > 62) then
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
							elseif (Enum > 64) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 67) then
							if (Enum == 66) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
						elseif (Enum <= 68) then
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
						elseif (Enum == 69) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							do
								return;
							end
						end
					elseif (Enum <= 105) then
						if (Enum <= 87) then
							if (Enum <= 78) then
								if (Enum <= 74) then
									if (Enum <= 72) then
										if (Enum > 71) then
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
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 73) then
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
								elseif (Enum <= 76) then
									if (Enum > 75) then
										local A = Inst[2];
										local T = Stk[A];
										for Idx = A + 1, Inst[3] do
											Insert(T, Stk[Idx]);
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
								elseif (Enum == 77) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 82) then
								if (Enum <= 80) then
									if (Enum == 79) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 81) then
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
							elseif (Enum <= 84) then
								if (Enum > 83) then
									local B;
									local A;
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 85) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 86) then
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
						elseif (Enum <= 96) then
							if (Enum <= 91) then
								if (Enum <= 89) then
									if (Enum > 88) then
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
								elseif (Enum > 90) then
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
									local A = Inst[2];
									Stk[A] = Stk[A]();
								end
							elseif (Enum <= 93) then
								if (Enum > 92) then
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
							elseif (Enum <= 94) then
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
							elseif (Enum > 95) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
						elseif (Enum <= 100) then
							if (Enum <= 98) then
								if (Enum > 97) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum == 99) then
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
							if (Enum == 101) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 103) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 104) then
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
					elseif (Enum <= 123) then
						if (Enum <= 114) then
							if (Enum <= 109) then
								if (Enum <= 107) then
									if (Enum > 106) then
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
									else
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
									end
								elseif (Enum == 108) then
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
									Stk[Inst[2]] = Inst[3];
								else
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								end
							elseif (Enum <= 111) then
								if (Enum == 110) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 112) then
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 113) then
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
						elseif (Enum <= 118) then
							if (Enum <= 116) then
								if (Enum == 115) then
									local A;
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A]();
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 117) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 120) then
							if (Enum > 119) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 121) then
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
						elseif (Enum > 122) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							VIP = VIP + 1;
						end
					elseif (Enum <= 132) then
						if (Enum <= 127) then
							if (Enum <= 125) then
								if (Enum > 124) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 126) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 129) then
							if (Enum > 128) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 130) then
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
						elseif (Enum > 131) then
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
							VIP = Inst[3];
						end
					elseif (Enum <= 136) then
						if (Enum <= 134) then
							if (Enum > 133) then
								local B;
								local A;
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum > 135) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Stk[Inst[2]] ~= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 138) then
						if (Enum == 137) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 139) then
						Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
					elseif (Enum == 140) then
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
						Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
				elseif (Enum <= 212) then
					if (Enum <= 176) then
						if (Enum <= 158) then
							if (Enum <= 149) then
								if (Enum <= 145) then
									if (Enum <= 143) then
										if (Enum == 142) then
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
										else
											local A = Inst[2];
											Stk[A](Stk[A + 1]);
										end
									elseif (Enum > 144) then
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
								elseif (Enum <= 147) then
									if (Enum > 146) then
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 148) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 153) then
								if (Enum <= 151) then
									if (Enum > 150) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 152) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								end
							elseif (Enum <= 155) then
								if (Enum > 154) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 156) then
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
							elseif (Enum > 157) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local T = Stk[A];
								for Idx = A + 1, Top do
									Insert(T, Stk[Idx]);
								end
							end
						elseif (Enum <= 167) then
							if (Enum <= 162) then
								if (Enum <= 160) then
									if (Enum > 159) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum == 161) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 165) then
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
							elseif (Enum == 166) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 171) then
							if (Enum <= 169) then
								if (Enum == 168) then
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
							elseif (Enum == 170) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							end
						elseif (Enum <= 174) then
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
						elseif (Enum > 175) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 194) then
						if (Enum <= 185) then
							if (Enum <= 180) then
								if (Enum <= 178) then
									if (Enum > 177) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
									end
								elseif (Enum == 179) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
							elseif (Enum <= 182) then
								if (Enum > 181) then
									Stk[Inst[2]] = {};
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 184) then
								local Edx;
								local Results;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 189) then
							if (Enum <= 187) then
								if (Enum > 186) then
									local A = Inst[2];
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
							elseif (Enum > 188) then
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
									if (Mvm[1] == 177) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 191) then
							if (Enum > 190) then
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
								A = Inst[2];
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
						elseif (Enum <= 192) then
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
						elseif (Enum > 193) then
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 203) then
						if (Enum <= 198) then
							if (Enum <= 196) then
								if (Enum == 195) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								end
							elseif (Enum > 197) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 200) then
							if (Enum == 199) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 201) then
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
						elseif (Enum > 202) then
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
						elseif (Inst[2] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 207) then
						if (Enum <= 205) then
							if (Enum > 204) then
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
						elseif (Enum > 206) then
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
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
						if (Enum > 208) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 210) then
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
					elseif (Enum == 211) then
						if (Inst[2] <= Stk[Inst[4]]) then
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
				elseif (Enum <= 247) then
					if (Enum <= 229) then
						if (Enum <= 220) then
							if (Enum <= 216) then
								if (Enum <= 214) then
									if (Enum > 213) then
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
								elseif (Enum > 215) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
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
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum == 219) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 224) then
							if (Enum <= 222) then
								if (Enum > 221) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							elseif (Enum > 223) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 226) then
							if (Enum > 225) then
								VIP = Inst[3];
							else
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 227) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 228) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
							A = Inst[2];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 238) then
						if (Enum <= 233) then
							if (Enum <= 231) then
								if (Enum == 230) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									VIP = Inst[3];
								end
							elseif (Enum == 232) then
								if (Stk[Inst[2]] <= Inst[4]) then
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
						elseif (Enum <= 235) then
							if (Enum > 234) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 236) then
							local Edx;
							local Results, Limit;
							local B;
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
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum > 237) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 242) then
						if (Enum <= 240) then
							if (Enum > 239) then
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
							else
								Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
							end
						elseif (Enum > 241) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] > Inst[4]) then
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
					elseif (Enum <= 244) then
						if (Enum == 243) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						end
					elseif (Enum <= 245) then
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
					elseif (Enum > 246) then
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
					end
				elseif (Enum <= 265) then
					if (Enum <= 256) then
						if (Enum <= 251) then
							if (Enum <= 249) then
								if (Enum == 248) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
								else
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum > 250) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							else
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							end
						elseif (Enum <= 253) then
							if (Enum > 252) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 254) then
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
						elseif (Enum == 255) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 260) then
						if (Enum <= 258) then
							if (Enum == 257) then
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
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum == 259) then
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
							A = Inst[2];
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
					elseif (Enum <= 262) then
						if (Enum == 261) then
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
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
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					elseif (Enum == 264) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 274) then
					if (Enum <= 269) then
						if (Enum <= 267) then
							if (Enum > 266) then
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
						elseif (Enum == 268) then
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
							do
								return Stk[Inst[2]];
							end
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 271) then
						if (Enum == 270) then
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
					elseif (Enum <= 272) then
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
					elseif (Enum == 273) then
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
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = VIP + Inst[3];
						end
					elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 278) then
					if (Enum <= 276) then
						if (Enum == 275) then
							Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
					elseif (Enum > 277) then
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
				elseif (Enum <= 280) then
					if (Enum > 279) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, A + Inst[3]);
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
				elseif (Enum <= 281) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum > 282) then
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
					Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
VMCall("LOL!423O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503053O005574696C7303043O00556E697403063O00506C617965722O033O0050657403063O0054617267657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03053O004D6163726F03073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O006D6174682O033O006D696E2O033O006162732O033O006D617803043O004361737403073O0047657454696D65030B3O0044656174684B6E6967687403063O00556E686F6C7903113O00416C67657468617250752O7A6C65426F7803023O004944030F3O0049726964657573467261676D656E7403133O005669616C6F66416E696D61746564426C2O6F64030C3O0047657445717569706D656E74026O002A40028O00026O002C40030E3O00436C6177696E67536861646F7773030B3O004973417661696C61626C65030D3O0053636F75726765537472696B6503063O00446566696C65030D3O004465617468416E644465636179030C3O00446566696C65506C6179657203093O00446144506C61796572024O0080B3C540030A3O0047686F756C5461626C65030A3O0041737068797869617465031B3O0086AB300A5325D441ADB33B171210C211ED832D0A2O16D544B5BE6A03083O0031C5CA437E7364A703103O005265676973746572466F724576656E7403183O000777FE10A56461126AEA00B02O7B196FE00AA87770107EFB03073O003E573BBF49E03603143O00D72EDBF0C230C5FBC225DFE7D827D4E8C52EDFED03043O00A987629A030E3O00F8470178D100F7E85F057ADA16EC03073O00A8AB1744349D5303143O00D854D49F0B08A3CB42C5880901B8DD5FCA99040F03073O00E7941195CD454D03063O0053657441504C025O00806F40000B022O00123D3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004E23O000A0001001235000300063O002068000400030007001235000500083O002068000500050009001235000600083O00206800060006000A0006BC00073O000100062O00B13O00064O00B18O00B13O00044O00B13O00014O00B13O00024O00B13O00054O008E0008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000E001100202O0010000E001200202O0011000E00130020680012000B001400204A0013000B001500202O0014000B001600202O0015000B001700202O0016000B001800202O00160016001900202O00160016001A00202O0017000B001800202O00170017001900202O00170017001B00122O0018001C3O00206800180018001D0012CF0019001C3O00202O00190019001E00122O001A001C3O00202O001A001A001F4O001B8O001C8O001D5O00202O001E000B002000122O001F00083O00202O001F001F000A001235002000214O00070021003C3O0006BC003D00010001001B2O00B13O00214O00B13O00074O00B13O00234O00B13O00244O00B13O00354O00B13O00364O00B13O00374O00B13O003B4O00B13O003C4O00B13O002F4O00B13O00304O00B13O00314O00B13O00284O00B13O00294O00B13O002A4O00B13O00384O00B13O00394O00B13O003A4O00B13O002C4O00B13O002D4O00B13O002E4O00B13O00254O00B13O00264O00B13O00274O00B13O00324O00B13O00334O00B13O00343O00201F003E0012002200202O003E003E002300202O003F0014002200202O003F003F002300202O00400015002200202O0040004000234O004100023O00202O0042003F002400202O0042004200254O0042000200020020680043003F00260020380043004300254O00430002000200202O0044003F002700202O0044004400254O004400456O00413O00010020100042000F00282O00BB0042000200020020680043004200290006D80043006F00013O0004E23O006F00012O00B1004300143O0020680044004200292O00BB00430002000200060F00430072000100010004E23O007200012O00B1004300143O0012080144002A4O00BB00430002000200206800440042002B0006D80044007A00013O0004E23O007A00012O00B1004400143O00206800450042002B2O00BB00440002000200060F0044007D000100010004E23O007D00012O00B1004400143O0012080145002A4O00BB0044000200022O0007004500463O0020180047000B001800202O0047004700194O004800563O00202O0057003E002C00202O00570057002D4O00570002000200062O0057008900013O0004E23O008900010020680057003E002C00060F0057008A000100010004E23O008A00010020680057003E002E0020680058003E002F00201000580058002D2O00BB0058000200020006D80058009200013O0004E23O009200010020680058003E002F00060F00580093000100010004E23O009300010020680058003E00300020680059003E002F00201000590059002D2O00BB0059000200020006D80059009B00013O0004E23O009B000100206800590040003100060F0059009C000100010004E23O009C00010020680059004000322O0007005A005A3O001202005B00333O00122O005C00333O00202O005D000B00344O005E00626O006300016O006400033O00202O0065003E00354O006600073O00122O006700363O00122O006800374O000701660068000200028B006700024O00050164000300012O00050163000100010020100064000B00380006BC00660003000100052O00B13O00424O00B13O000F4O00B13O00434O00B13O00144O00B13O00444O0048006700073O00122O006800393O00122O0069003A6O006700696O00643O000100202O0064000B00380006BC00660004000100022O00B13O005B4O00B13O005C4O0048006700073O00122O0068003B3O00122O0069003C6O006700696O00643O000100202O0064000B00380006BC00660005000100052O00B13O00584O00B13O003E4O00B13O00574O00B13O00594O00B13O00404O0029006700073O00122O0068003D3O00122O0069003E6O0067006900024O006800073O00122O0069003F3O00122O006A00406O0068006A6O00643O00010006BC00640006000100042O00B13O000F4O00B13O002C4O00B13O002D4O00B13O003E3O0006BC00650007000100012O00B13O003E3O0006BC00660008000100032O00B13O000E4O00B13O001F4O00B13O000B3O0006BC00670009000100012O00B13O003E3O0006BC0068000A000100012O00B13O003E3O0006BC0069000B000100022O00B13O003E4O00B13O000F3O0006BC006A000C000100012O00B13O003E3O0006BC006B000D000100012O00B13O003E3O0006BC006C000E000100012O00B13O003E3O0006BC006D000F000100012O00B13O003E3O0006BC006E0010000100012O00B13O003E3O0006BC006F0011000100022O00B13O003E4O00B13O00103O0006BC00700012000100022O00B13O003E4O00B13O00583O0006BC00710013000100012O00B13O003E3O0006BC00720014000100022O00B13O003E4O00B13O00163O0006BC00730015000100062O00B13O003E4O00B13O00104O00B13O000B4O00B13O00074O00B13O001D4O00B13O00113O0006BC00740016000100042O00B13O00454O00B13O00474O00B13O00414O00B13O001D3O0006BC007500170001000C2O00B13O003E4O00B13O004E4O00B13O005C4O00B13O000B4O00B13O00384O00B13O00114O00B13O00074O00B13O00574O00B13O004D4O00B13O00474O00B13O005E4O00B13O00673O0006BC007600180001000F2O00B13O003E4O00B13O004E4O00B13O005C4O00B13O000B4O00B13O00384O00B13O00114O00B13O00074O00B13O000F4O00B13O005A4O00B13O005F4O00B13O00574O00B13O00474O00B13O005E4O00B13O00674O00B13O00713O0006BC00770019000100152O00B13O003E4O00B13O00584O00B13O00474O00B13O005E4O00B13O00074O00B13O00674O00B13O00704O00B13O00114O00B13O000B4O00B13O00394O00B13O00614O00B13O00374O00B13O00104O00B13O00324O00B13O006F4O00B13O003A4O00B13O005C4O00B13O000F4O00B13O00334O00B13O005A4O00B13O00693O0006BC0078001A000100102O00B13O003E4O00B13O004E4O00B13O005C4O00B13O000B4O00B13O00384O00B13O00114O00B13O00074O00B13O00614O00B13O00474O00B13O005E4O00B13O00674O00B13O004B4O00B13O006B4O00B13O00584O00B13O00594O00B13O00313O0006BC0079001B000100182O00B13O003E4O00B13O000B4O00B13O00374O00B13O00074O00B13O004F4O00B13O00474O00B13O005E4O00B13O00674O00B13O006A4O00B13O00364O00B13O003A4O00B13O005F4O00B13O00114O00B13O000F4O00B13O00394O00B13O00104O00B13O00554O00B13O00564O00B13O00534O00B13O00514O00B13O005C4O00B13O00324O00B13O00684O00B13O006E3O0006BC007A001C000100122O00B13O003E4O00B13O005A4O00B13O000F4O00B13O00564O00B13O000B4O00B13O00364O00B13O00074O00B13O001D4O00B13O00554O00B13O00324O00B13O003A4O00B13O00374O00B13O005F4O00B13O00114O00B13O00394O00B13O00584O00B13O00594O00B13O00313O0006BC007B001D000100162O00B13O003E4O00B13O005F4O00B13O00554O00B13O000F4O00B13O00114O00B13O000B4O00B13O00074O00B13O00614O00B13O00384O00B13O00574O00B13O004B4O00B13O004F4O00B13O00504O00B13O005C4O00B13O003B4O00B13O00474O00B13O005E4O00B13O00724O00B13O002E4O00B13O002F4O00B13O00304O00B13O001D3O0006BC007C001E000100102O00B13O003E4O00B13O00564O00B13O00554O00B13O00534O00B13O00544O00B13O00514O00B13O00524O00B13O005F4O00B13O000F4O00B13O005C4O00B13O000B4O00B13O00354O00B13O00074O00B13O005E4O00B13O00114O00B13O005A3O0006BC007D001F0001001D2O00B13O00574O00B13O004D4O00B13O00474O00B13O005E4O00B13O00074O00B13O00674O00B13O006D4O00B13O00114O00B13O003E4O00B13O00494O00B13O004E4O00B13O004A4O00B13O005C4O00B13O000B4O00B13O00384O00B13O006C4O00B13O00584O00B13O000F4O00B13O005F4O00B13O00514O00B13O00524O00B13O00554O00B13O00564O00B13O00534O00B13O00544O00B13O005A4O00B13O00104O00B13O00594O00B13O00313O0006BC007E0020000100022O00B13O00224O00B13O00743O0006BC007F0021000100142O00B13O00494O00B13O003E4O00B13O005F4O00B13O00484O00B13O000B4O00B13O004D4O00B13O004B4O00B13O004C4O00B13O005A4O00B13O004F4O00B13O00114O00B13O000F4O00B13O005D4O00B13O005C4O00B13O004E4O00B13O001C4O00B13O00504O00B13O004A4O00B13O00554O00B13O00163O0006BC008000220001002F2O00B13O001C4O00B13O00074O00B13O001D4O00B13O003D4O00B13O001B4O00B13O00464O00B13O00644O00B13O005E4O00B13O000F4O00B13O003E4O00B13O00474O00B13O005B4O00B13O000B4O00B13O005C4O00B13O00564O00B13O005D4O00B13O005A4O00B13O00114O00B13O00624O00B13O00654O00B13O00604O00B13O00514O00B13O00524O00B13O00534O00B13O00544O00B13O00554O00B13O00224O00B13O007E4O00B13O00484O00B13O007A4O00B13O004F4O00B13O00794O00B13O00504O00B13O00774O00B13O007C4O00B13O00584O00B13O00784O00B13O005F4O00B13O00764O00B13O00754O00B13O00734O00B13O004E4O00B13O00384O00B13O007D4O00B13O007F4O00B13O007B4O00B13O00613O0006BC00810023000100032O00B13O000B4O00B13O00074O00B13O003E3O0020C00082000B004100122O008300426O008400806O008500816O0082008500016O00013O00243O00023O00026O00F03F026O00704002264O000B01025O00122O000300016O00045O00122O000500013O00042O0003002100012O009F00076O005D000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004190003000500012O009F000300054O00B1000400024O00EE000300044O00D900036O00463O00017O003F3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030A3O0079F07CD17C48DA8040F003083O00E12C8319831D2BB303103O002E5C4995DC21334515487CB2CD29304203083O002C7B2F2CDDB9405F03113O00CF4D5E0DEE465831E85C560EE9665E0CE203043O006187283F026O00F03F026O001840030D3O009C5D30322E3DBD73353D08128A03063O0051CE3C535B4F030D3O006FBBDF712ECF54B45DAEF7510B03083O00C42ECBB0124FA32D03153O009C236C1510E9EEB631781136F6EEAC2B711003D8CB03073O008FD8421E7E449B026O001C40026O002040030F3O009FC605C4C9BAF5EDA3CF05DFE280F303083O0081CAA86DABA5C3B703103O0014513BDDFD1BE83659302OD11AC1017C03073O0086423857B8BE74026O00104003113O001D3F1DB234EA263C3F0201BE15E706161803083O00555C5169DB798B4103103O00DCBD444C51DEFABA537F73D1F894736103063O00BF9DD330251C03103O00FB1AF50832FE11F0383FDC1EED3B19FB03053O005ABF7F947C026O001440027O004003113O0051893A126A953B076CB0270370B43A027603043O007718E74E03163O00AB23B14FCE520492398A44D059268A24B14FD049029603073O0071E24DC52ABC2003123O001318E0B02804E1A52E22FCA73F05FCBA361203043O00D55A7694026O000840030B3O007E3EBD52485627B7716E7F03053O002D3B4ED43603113O0023438E8689208AF102518C928A2B8AD33403083O00907036E3EBE64ECD03103O00862607F3DC42923B1CFDC557A70F2CD803063O003BD3486F9CB003103O007B94E6094B86F7257D93F1244582CB1D03043O004D2EE783030F3O008F47B364BB46BD73AF57B54FA87C8603043O0020DA34D603143O007B043489DC836477743837AEF4BE565358123DB103083O003A2E7751C891D025030F3O000389312OA0B3311B8324A5A6B31E1B03073O00564BEC50CCC9DD030E3O00475272ADFB8A7E557F96EA847C4403063O00EB122117E59E030D3O0078BFC0B744B2D2AF5FB4C4936003043O00DB30DAA103143O00C17C6C46CC4AF2D664724CEC4AE1F47E726EF86B03073O008084111C29BB2F03123O003233052854073B05335C0D0207394926112203053O003D6152665A03103O008127A54FE1451B0CB62B844DC1703D2D03083O0069CC4ECB2BA7377E0006012O001208012O00013O00266F3O001F000100010004E23O001F0001001235000100023O0020740001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O00010001000200062O0001001D000100010004E23O001D00010012082O0100014O00E1000100033O001208012O000A3O00266F3O003A0001000B0004E23O003A0001001235000100023O0020F10001000100034O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O00122O000100023O00202O0001000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00124O00123O00266F3O004D000100130004E23O004D0001001235000100023O0020E70001000100034O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O00044O00052O0100266F3O0068000100180004E23O00680001001235000100023O0020F10001000100034O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100093O00122O000100023O00202O0001000100034O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100023O00202O0001000100034O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00124O001F3O00266F3O008C000100200004E23O008C0001001235000100023O0020F60001000100034O000200013O00122O000300213O00122O000400226O0002000400024O00010001000200062O00010074000100010004E23O007400010012082O0100014O00E10001000C3O0012A5000100023O00202O0001000100034O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O0001007F000100010004E23O007F00010012082O0100014O00E10001000D3O0012A5000100023O00202O0001000100034O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001008A000100010004E23O008A00010012082O0100014O00E10001000E3O001208012O00273O00266F3O00A7000100120004E23O00A70001001235000100023O0020F10001000100034O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O0001000F3O00122O000100023O00202O0001000100034O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100113O00124O00133O00266F3O00C8000100270004E23O00C80001001235000100023O0020F60001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100B3000100010004E23O00B300010012082O0100014O00E1000100123O0012A5000100023O00202O0001000100034O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100BE000100010004E23O00BE00010012082O0100014O00E1000100133O001284000100023O00202O0001000100034O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100143O00124O00183O00266F3O00E90001000A0004E23O00E90001001235000100023O0020F60001000100034O000200013O00122O000300343O00122O000400356O0002000400024O00010001000200062O000100D4000100010004E23O00D400010012082O0100014O00E1000100153O00127F000100023O00202O0001000100034O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100163O00122O000100023O00202O0001000100034O000200013O00122O000300383O00122O000400396O0002000400024O00010001000200062O000100E7000100010004E23O00E700010012082O0100014O00E1000100173O001208012O00203O00266F3O00010001001F0004E23O00010001001235000100023O0020F10001000100034O000200013O00122O0003003A3O00122O0004003B6O0002000400024O0001000100024O000100183O00122O000100023O00202O0001000100034O000200013O00122O0003003C3O00122O0004003D6O0002000400024O0001000100024O000100193O00122O000100023O00202O0001000100034O000200013O00122O0003003E3O00122O0004003F6O0002000400024O0001000100024O0001001A3O00124O000B3O0004E23O000100012O00463O00019O003O00034O00603O00014O0002012O00024O00463O00017O00053O00028O00030C3O0047657445717569706D656E74026O002A40026O00F03F026O002C4000293O001208012O00013O000ECA0001001600013O0004E23O001600012O009F000100013O0020570001000100024O0001000200024O00018O00015O00202O00010001000300062O0001001100013O0004E23O001100012O009F000100034O009F00025O0020680002000200032O00BB00010002000200060F00010014000100010004E23O001400012O009F000100033O001208010200014O00BB0001000200022O00E1000100023O001208012O00043O00266F3O0001000100040004E23O000100012O009F00015O0020680001000100050006D80001002200013O0004E23O002200012O009F000100034O009F00025O0020680002000200052O00BB00010002000200060F00010025000100010004E23O002500012O009F000100033O001208010200014O00BB0001000200022O00E1000100043O0004E23O002800010004E23O000100012O00463O00017O00023O00028O00024O0080B3C540000A3O001208012O00013O00266F3O0001000100010004E23O000100010012082O0100024O00E100015O0012082O0100024O00E1000100013O0004E23O000900010004E23O000100012O00463O00017O00093O00028O00026O00F03F03063O00446566696C65030B3O004973417661696C61626C65030D3O004465617468416E644465636179030E3O00436C6177696E67536861646F7773030D3O0053636F75726765537472696B65030C3O00446566696C65506C6179657203093O00446144506C6179657200303O001208012O00013O00266F3O0011000100020004E23O001100012O009F000100013O0020680001000100030020100001000100042O00BB0001000200020006D80001000D00013O0004E23O000D00012O009F000100013O00206800010001000300060F0001000F000100010004E23O000F00012O009F000100013O0020680001000100052O00E100015O0004E23O002F0001000ECA0001000100013O0004E23O000100012O009F000100013O0020680001000100060020100001000100042O00BB0001000200020006D80001001D00013O0004E23O001D00012O009F000100013O00206800010001000600060F0001001F000100010004E23O001F00012O009F000100013O0020680001000100072O00E1000100024O006A000100013O00202O00010001000300202O0001000100044O00010002000200062O0001002A00013O0004E23O002A00012O009F000100043O00206800010001000800060F0001002C000100010004E23O002C00012O009F000100043O0020680001000100092O00E1000100033O001208012O00023O0004E23O000100012O00463O00017O00033O0003103O004865616C746850657263656E7461676503063O0042752O665570030F3O004465617468537472696B6542752O6600164O00277O00206O00016O000200024O000100013O00064O0013000100010004E23O001300012O009F7O0020105O00012O00BB3O000200022O009F000100023O0006663O0012000100010004E23O001200012O009F7O0020765O00024O000200033O00202O0002000200036O0002000200044O001400012O007A8O00603O00014O0002012O00024O00463O00017O00053O00028O00026O00F03F03053O007061697273030A3O00446562752O66446F776E03143O00566972756C656E74506C61677565446562752O6601183O0012082O0100014O0007000200023O000ECA00020005000100010004E23O000500012O0002010200023O00266F00010002000100010004E23O00020001001208010200013O001235000300034O00B100046O003C0003000200050004E23O001300010020100008000700042O009F000A5O002068000A000A00052O00070108000A00020006D80008001300013O0004E23O0013000100203100020002000200062E0003000C000100020004E23O000C00010012082O0100023O0004E23O000200012O00463O00017O00063O00028O0003053O007061697273030C3O004973496E426F2O734C69737403093O00556E69744E50434944026O00F03F030C3O00466967687452656D61696E7301213O0012082O0100014O0007000200023O00266F00010018000100010004E23O001800012O00B600036O00B9000200033O00122O000300026O00048O00030002000500044O001500012O009F00075O0020D00007000700034O00093O000600202O0009000900044O00070009000200062O00070015000100010004E23O001500012O009F000700014O00B1000800024O005600093O00062O00E300070009000100062E0003000A000100010004E23O000A00010012082O0100053O00266F00010002000100050004E23O000200012O009F000300023O0020F80003000300064O000400026O000300046O00035O00044O000200012O00463O00017O00023O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O6601063O0020F300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O00030D3O00446562752O6652656D61696E73030A3O00536F756C52656170657201063O0020F300013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00113O00030D3O004275727374696E67536F726573030B3O004973417661696C61626C6503083O00446562752O66557003143O00466573746572696E67576F756E64446562752O6603083O0042752O66446F776E03113O004465617468416E64446563617942752O66030D3O004465617468416E644465636179030C3O00432O6F6C646F776E446F776E03043O0052756E65026O00084003063O0042752O665570028O00030B3O00446562752O66537461636B026O00104003073O0048617354696572026O003F40027O004001464O006A00015O00202O00010001000100202O0001000100024O00010002000200062O0001002A00013O0004E23O002A000100201000013O00032O009F00035O0020680003000300042O00072O01000300020006D80001002A00013O0004E23O002A00012O009F000100013O0020550001000100054O00035O00202O0003000300064O00010003000200062O0001001E00013O0004E23O001E00012O009F00015O0020680001000100070020100001000100082O00BB0001000200020006D80001001E00013O0004E23O001E00012O009F000100013O0020100001000100092O00BB00010002000200260E000100430001000A0004E23O004300012O009F000100013O00205500010001000B4O00035O00202O0003000300064O00010003000200062O0001002A00013O0004E23O002A00012O009F000100013O0020100001000100092O00BB000100020002002687000100430001000C0004E23O004300012O009F00015O0020680001000100010020100001000100022O00BB00010002000200060F00010036000100010004E23O0036000100201000013O000D2O009F00035O0020680003000300042O00072O0100030002000E1E000E0043000100010004E23O004300012O009F000100013O0020DC00010001000F00122O000300103O00122O000400116O00010004000200062O0001004400013O0004E23O0044000100201000013O00032O009F00035O0020680003000300042O00072O01000300020004E23O004400012O007A00016O0060000100014O00022O0100024O00463O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020E000013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004E23O000700012O007A00016O0060000100014O00022O0100024O00463O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O00201700013O00014O00035O00202O0003000300024O00010003000200262O00010007000100030004E23O000700012O007A00016O0060000100014O00022O0100024O00463O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O00201700013O00014O00035O00202O0003000300024O00010003000200262O00010007000100030004E23O000700012O007A00016O0060000100014O00022O0100024O00463O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040010A3O0020E000013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004E23O000700012O007A00016O0060000100014O00022O0100024O00463O00017O00073O0003073O0054696D65546F58025O00804140026O00144003103O004865616C746850657263656E7461676503093O0054696D65546F446965030D3O00446562752O6652656D61696E73030A3O00536F756C52656170657201163O00201000013O0001001208010300024O00072O010003000200260E00010009000100030004E23O0009000100201000013O00042O00BB0001000200020026E800010012000100020004E23O0012000100201000013O00052O006500010002000200202O00023O00064O00045O00202O0004000400074O00020004000200202O00020002000300062O00020013000100010004E23O001300012O007A00016O0060000100014O00022O0100024O00463O00017O00053O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66027O004003063O0042752O66557003123O004461726B5472616E73666F726D6174696F6E01103O0020F200013O00014O00035O00202O0003000300024O00010003000200262O0001000D000100030004E23O000D00012O009F000100013O0020760001000100044O00035O00202O0003000300054O00010003000200044O000E00012O007A00016O0060000100014O00022O0100024O00463O00017O00053O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O001040030F3O00432O6F6C646F776E52656D61696E73026O000840010F3O0020172O013O00014O00035O00202O0003000300024O000100030002000E2O0003000B000100010004E23O000B00012O009F000100013O0020100001000100042O00BB00010002000200260E0001000C000100050004E23O000C00012O007A00016O0060000100014O00022O0100024O00463O00017O00033O00030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66026O00F03F010A3O0020E000013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004E23O000700012O007A00016O0060000100014O00022O0100024O00463O00017O000F3O0003093O0054696D65546F446965030D3O00446562752O6652656D61696E7303143O00566972756C656E74506C61677565446562752O6603113O00446562752O665265667265736861626C65030B3O00537570657273747261696E030B3O004973417661696C61626C6503103O0046726F73744665766572446562752O6603113O00426C2O6F64506C61677565446562752O66030C3O00556E686F6C79426C69676874030F3O00432O6F6C646F776E52656D61696E73026O000840030D3O00506C616775656272696E676572027O004003093O0045626F6E4665766572026O002E40014E3O00209700013O00014O00010002000200202O00023O00024O00045O00202O0004000400034O00020004000200062O0002004A000100010004E23O004A000100201000013O00042O009F00035O0020680003000300032O00072O010003000200060F00010020000100010004E23O002000012O009F00015O0020680001000100050020100001000100062O00BB0001000200020006D80001004C00013O0004E23O004C000100201000013O00042O009F00035O0020680003000300072O00072O010003000200060F00010020000100010004E23O0020000100201000013O00042O009F00035O0020680003000300082O00072O01000300020006D80001004C00013O0004E23O004C00012O009F00015O0020680001000100090020100001000100062O00BB0001000200020006D80001004B00013O0004E23O004B00012O009F00015O0020680001000100090020100001000100062O00BB0001000200020006D80001004C00013O0004E23O004C00012O009F00015O0020E500010001000900202O00010001000A4O0001000200024O000200016O00035O00202O00030003000500202O0003000300064O000300046O00023O000200202O00020002000B4O000300016O00045O00202O00040004000C00202O0004000400064O000400056O00033O000200202O00030003000D4O0002000200034O000300016O00045O00202O00040004000E00202O0004000400064O000400056O00033O000200202O00030003000D4O00020002000300102O0002000F000200062O0002004B000100010004E23O004B00012O007A00016O0060000100014O00022O0100024O00463O00017O00143O00028O0003093O00526169736544656164030A3O0049734361737461626C65030D3O004973446561644F7247686F737403083O00497341637469766503053O005072652O7303233O0092A6CEE852C084A2C6FF17EF92A2C4F45AFD81B387A917FB89B4D7F756E693B3DEF75203063O009FE0C7A79B37030D3O0041726D796F667468654465616403073O0049735265616479031C3O00F6E131CBC8FC3AEDE3FB39EDF3F63DD6B7E32ED7F4FC31D0F6E77C8603043O00B297935C026O00F03F03083O004F7574627265616B030E3O0049735370652O6C496E52616E676503143O0083E8583000497B87BD5C20174F7581FF4D26521A03073O001AEC9D2C52722C030F3O00466573746572696E67537472696B65031C3O002C2BC64F2F3CDC552D11C64F3827DE5E6A3EC75E2921D8592B3A952O03043O003B4A4EB5006D3O001208012O00013O00266F3O003C000100010004E23O003C00012O009F00015O0020680001000100020020100001000100032O00BB0001000200020006D80001002500013O0004E23O002500012O009F000100013O0020100001000100042O00BB00010002000200060F00010018000100010004E23O001800012O009F000100013O0020100001000100052O00BB0001000200020006D80001001800013O0004E23O001800012O009F000100013O0020100001000100052O00BB00010002000200060F00010025000100010004E23O002500012O009F000100023O0020230001000100064O00025O00202O0002000200024O000300036O00010003000200062O0001002500013O0004E23O002500012O009F000100033O001208010200073O001208010300084O00EE000100034O00D900016O009F00015O00206800010001000900201000010001000A2O00BB0001000200020006D80001003B00013O0004E23O003B00012O009F000100043O0006D80001003B00013O0004E23O003B00012O009F000100023O0020230001000100064O00025O00202O0002000200094O000300036O00010003000200062O0001003B00013O0004E23O003B00012O009F000100033O0012080102000B3O0012080103000C4O00EE000100034O00D900015O001208012O000D3O00266F3O00010001000D0004E23O000100012O009F00015O00206800010001000E00201000010001000A2O00BB0001000200020006D80001005700013O0004E23O005700012O009F000100023O0020400001000100064O00025O00202O00020002000E4O000300046O000500053O00202O00050005000F4O00075O00202O00070007000E4O0005000700024O000500056O00010005000200062O0001005700013O0004E23O005700012O009F000100033O001208010200103O001208010300114O00EE000100034O00D900016O009F00015O00206800010001001200201000010001000A2O00BB0001000200020006D80001006C00013O0004E23O006C00012O009F000100023O0020230001000100064O00025O00202O0002000200124O000300046O00010004000200062O0001006C00013O0004E23O006C00012O009F000100033O0012BA000200133O00122O000300146O000100036O00015O00044O006C00010004E23O000100012O00463O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O001208012O00013O00266F3O0011000100020004E23O001100012O009F000100013O00200F2O01000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004E23O002200012O009F00016O00022O0100023O0004E23O0022000100266F3O0001000100010004E23O000100012O009F000100013O00200F2O01000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004E23O002000012O009F00016O00022O0100023O001208012O00023O0004E23O000100012O00463O00017O00193O00028O0003083O0045706964656D696303073O0049735265616479026O00244003053O005072652O7303093O004973496E52616E6765026O003E40030E3O0020C1535EB628D8591AB22AD41A0803053O00D345B12O3A030C3O004361737454617267657449662O033O00BAE46103063O00ABD785199589030E3O0049735370652O6C496E52616E676503133O00F6C727F4EB0FEF52E4C636FFFD70FD4DE4886603083O002281A8529A8F509C026O00F03F030F3O00466573746572696E67537472696B652O033O0088B32B03073O00E9E5D2536B282E03163O00C74721C200D34B3CD13AD25620DF0EC40233D900811403053O0065A12252B603093O004465617468436F696C030B3O004973417661696C61626C6503103O00EC0858EAD3DD8121E10119FFD4E7C27603083O004E886D399EBB82E200853O001208012O00013O00266F3O0042000100010004E23O004200012O009F00015O0020680001000100020020100001000100032O00BB0001000200020006D80001002200013O0004E23O002200012O009F000100013O0006D80001000F00013O0004E23O000F00012O009F000100023O0026A700010022000100040004E23O002200012O009F000100033O00200A2O01000100054O00025O00202O0002000200024O000300046O000400046O000500053O00202O00050005000600122O000700076O0005000700024O000500056O00010005000200062O0001002200013O0004E23O002200012O009F000100063O001208010200083O001208010300094O00EE000100034O00D900016O009F000100073O0020100001000100032O00BB0001000200020006D80001004100013O0004E23O004100012O009F000100083O0006D80001004100013O0004E23O004100012O009F000100093O00200D00010001000A4O000200076O0003000A6O000400063O00122O0005000B3O00122O0006000C6O0004000600024O0005000B6O000600066O000700053O00202O00070007000D4O000900076O0007000900024O000700076O00010007000200062O0001004100013O0004E23O004100012O009F000100063O0012080102000E3O0012080103000F4O00EE000100034O00D900015O001208012O00103O00266F3O0001000100100004E23O000100012O009F00015O0020680001000100110020100001000100032O00BB0001000200020006D80001006000013O0004E23O006000012O009F000100083O00060F00010060000100010004E23O006000012O009F000100093O00201200010001000A4O00025O00202O0002000200114O0003000A6O000400063O00122O000500123O00122O000600136O0004000600024O0005000B6O000600066O00010006000200062O0001006000013O0004E23O006000012O009F000100063O001208010200143O001208010300154O00EE000100034O00D900016O009F00015O0020680001000100160020100001000100032O00BB0001000200020006D80001008400013O0004E23O008400012O009F000100013O00060F00010084000100010004E23O008400012O009F00015O0020680001000100020020100001000100172O00BB00010002000200060F00010084000100010004E23O008400012O009F000100033O0020400001000100054O00025O00202O0002000200164O000300046O000500053O00202O00050005000D4O00075O00202O0007000700164O0005000700024O000500056O00010005000200062O0001008400013O0004E23O008400012O009F000100063O0012BA000200183O00122O000300196O000100036O00015O00044O008400010004E23O000100012O00463O00017O00203O00028O00026O00F03F03083O0045706964656D696303073O0049735265616479026O00244003053O005072652O7303093O004973496E52616E6765026O003E4003143O003B2FF0F53B32F0F27E3EF6F4013DECE32D2BB9A703043O00915E5F9903093O004465617468436F696C030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503163O00F9C815C14688FEC21DD90EB6F2C82BD75BA5EED9548D03063O00D79DAD74B52E027O0040030D3O004275727374696E67536F72657303043O0052756E65026O00184003113O0052756E6963506F7765724465666963697403093O0042752O66537461636B030F3O004665737465726D6967687442752O66026O00344003143O0030A482F6DF38BD88B2DB3AB1B4F0CF27A79FB28803053O00BA55D4EB92030C3O004361737454617267657449662O033O00CF800E03073O0038A2E1769E598E03193O004B0AD5A126E74F15C5A126DD4E45C1A027E75E10D2BC36980803063O00B83C65A0CF42031A3O00268D69B235BD6FAC348C78B923C27DB334BD7EA9239168FC60D203043O00DC51E21C00BE3O001208012O00013O00266F3O0045000100020004E23O004500012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001002200013O0004E23O002200012O009F000100013O0006D80001000F00013O0004E23O000F00012O009F000100023O0026A700010022000100050004E23O002200012O009F000100033O00200A2O01000100064O00025O00202O0002000200034O000300046O000400046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002200013O0004E23O002200012O009F000100063O001208010200093O0012080103000A4O00EE000100034O00D900016O009F00015O00206800010001000B0020100001000100042O00BB0001000200020006D80001004400013O0004E23O004400012O009F000100013O00060F00010044000100010004E23O004400012O009F00015O00206800010001000300201000010001000C2O00BB00010002000200060F00010044000100010004E23O004400012O009F000100033O0020400001000100064O00025O00202O00020002000B4O000300046O000500053O00202O00050005000D4O00075O00202O00070007000B4O0005000700024O000500056O00010005000200062O0001004400013O0004E23O004400012O009F000100063O0012080102000E3O0012080103000F4O00EE000100034O00D900015O001208012O00103O00266F3O00A3000100010004E23O00A300012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001008600013O0004E23O008600012O009F00015O00206800010001001100201000010001000C2O00BB0001000200020006D80001006100013O0004E23O006100012O009F000100073O0020100001000100122O00BB00010002000200260E00010061000100020004E23O006100012O009F00015O00206800010001001100201000010001000C2O00BB0001000200020006D80001008600013O0004E23O008600012O009F000100083O00266F00010086000100010004E23O008600012O009F000100013O00060F00010086000100010004E23O008600012O009F000100093O000E1E00130073000100010004E23O007300012O009F000100073O0020100001000100142O00BB00010002000200260E00010073000100080004E23O007300012O009F000100073O00200B0001000100154O00035O00202O0003000300164O00010003000200262O00010086000100170004E23O008600012O009F000100033O00200A2O01000100064O00025O00202O0002000200034O000300046O000400046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001008600013O0004E23O008600012O009F000100063O001208010200183O001208010300194O00EE000100034O00D900016O009F0001000A3O0020100001000100042O00BB0001000200020006D8000100A200013O0004E23O00A200012O009F0001000B3O00201A2O010001001A4O0002000A6O0003000C6O000400063O00122O0005001B3O00122O0006001C6O0004000600024O0005000D6O0006000E6O000700053O00202O00070007000D4O0009000A6O0007000900024O000700076O00010007000200062O000100A200013O0004E23O00A200012O009F000100063O0012080102001D3O0012080103001E4O00EE000100034O00D900015O001208012O00023O000ECA0010000100013O0004E23O000100012O009F0001000A3O0020100001000100042O00BB0001000200020006D8000100BD00013O0004E23O00BD00012O009F000100033O0020AB0001000100064O0002000A6O000300046O000500053O00202O00050005000D4O0007000A6O0005000700024O000500056O00010005000200062O000100BD00013O0004E23O00BD00012O009F000100063O0012BA0002001F3O00122O000300206O000100036O00015O00044O00BD00010004E23O000100012O00463O00017O003E3O00028O00030D3O0056696C65436F6E746167696F6E03073O0049735265616479030F3O00432O6F6C646F776E52656D61696E73026O000840030C3O004361737454617267657449662O033O001ED49A03063O00A773B5E29B8A030E3O0049735370652O6C496E52616E6765031E3O00F42BEB594472C9EC36E65B727EC8A223E8594472C9ED2EE3536C7FD5A27003073O00A68242873C1B11030E3O0053752O6D6F6E476172676F796C6503053O005072652O73031F3O00575FC3783F4A75C974224345D77935044BC1700F4745C179344B5DC066701003053O0050242AAE15026O00F03F03123O004461726B5472616E73666F726D6174696F6E030A3O0049734361737461626C65026O002440030D3O00496E666563746564436C617773030B3O004973417661696C61626C6503143O00466573746572696E67576F756E64446562752O66030F3O0041757261416374697665436F756E7403243O004A11252O7104257B400331755C1D366E471F393A4F1F32454D1F38764A1F20745D50662E03043O001A2E705703113O00456D706F77657252756E65576561706F6E03063O0042752O66557003243O00BC2EBB7BA8BA578BAB36A57180A840B5A92CA534BEB0408BBA2CA478BBB052BAAA63FA2203083O00D4D943CB142ODF25026O001040027O0040030D3O00556E686F6C79412O7361756C742O033O00B784A603043O00B2DAEDC8031F3O00A3BBEEDFBAACD9D1A5A6E7C5BAA1A6D1B9B0D9D3B9BAEAD4B9A2E8C3F6E4B603043O00B0D6D58603093O00526169736544656164030D3O004973446561644F7247686F737403083O00497341637469766503283O00E6ACBFC7AD695DF1ACB294A9595CCBAEB9DBA45256E3A3A594F90419F0A4A5C4A45740E7B9AFD8AD03073O003994CDD6B4C836030F3O00536163726966696369616C5061637403083O0042752O66446F776E026O0018402O033O0047434403213O0001FC36267F14F4363D771EC225357506BD343B732DFE3A3B7A16F2223A6552AC6D03053O0016729D5554030F3O0041626F6D696E6174696F6E4C696D6203043O0052756E65030B3O004665737465726D69676874030F3O004665737465726D6967687442752O66030B3O0042752O6652656D61696E73026O00284003093O004973496E52616E6765026O00344003203O00C5C91CC954F8A9D0C21CCA62FAA12OC953C552F397C7C41CC859F9BFCAD8539203073O00C8A4AB73A43D96030A3O0041706F63616C797073652O033O00B3FD0D03053O00E3DE946325031A3O0032425DF5F83F4B42E5FC73535DF3C6302O5DFAFD3C455CE5B96B03053O0099532O3296003E012O001208012O00013O00266F3O003B000100010004E23O003B00012O009F00015O0020680001000100020020100001000100032O00BB0001000200020006D80001002700013O0004E23O002700012O009F000100013O0020100001000100042O00BB0001000200020026A700010027000100050004E23O002700012O009F000100023O00205E0001000100064O00025O00202O0002000200024O000300036O000400043O00122O000500073O00122O000600086O0004000600024O000500056O000600066O000700073O00202O0007000700094O00095O00202O0009000900024O0007000900024O000700076O00010007000200062O0001002700013O0004E23O002700012O009F000100043O0012080102000A3O0012080103000B4O00EE000100034O00D900016O009F00015O00206800010001000C0020100001000100032O00BB0001000200020006D80001003A00013O0004E23O003A00012O009F000100083O0020CE00010001000D4O00025O00202O00020002000C4O000300096O00010003000200062O0001003A00013O0004E23O003A00012O009F000100043O0012080102000E3O0012080103000F4O00EE000100034O00D900015O001208012O00103O00266F3O0089000100050004E23O008900012O009F00015O0020680001000100110020100001000100122O00BB0001000200020006D80001006E00013O0004E23O006E00012O009F000100013O0020100001000100042O00BB0001000200020026A70001005B000100130004E23O005B00012O009F00015O0020680001000100140020100001000100152O00BB0001000200020006D80001005B00013O0004E23O005B00012O009F00015O0020DE00010001001600202O0001000100174O0001000200024O0002000A3O00062O00010061000100020004E23O006100012O009F00015O0020680001000100020020100001000100152O00BB0001000200020006D80001006100013O0004E23O006100012O009F00015O0020680001000100140020100001000100152O00BB00010002000200060F0001006E000100010004E23O006E00012O009F000100083O0020CE00010001000D4O00025O00202O0002000200114O0003000B6O00010003000200062O0001006E00013O0004E23O006E00012O009F000100043O001208010200183O001208010300194O00EE000100034O00D900016O009F00015O00206800010001001A0020100001000100122O00BB0001000200020006D80001008800013O0004E23O008800012O009F0001000C3O00205500010001001B4O00035O00202O0003000300114O00010003000200062O0001008800013O0004E23O008800012O009F000100083O0020CE00010001000D4O00025O00202O00020002001A4O0003000D6O00010003000200062O0001008800013O0004E23O008800012O009F000100043O0012080102001C3O0012080103001D4O00EE000100034O00D900015O001208012O001E3O00266F3O00C30001001F0004E23O00C300012O009F00015O0020680001000100200020100001000100122O00BB0001000200020006D8000100A500013O0004E23O00A500012O009F000100023O00209B0001000100064O00025O00202O0002000200204O000300036O000400043O00122O000500213O00122O000600226O0004000600024O000500056O0006000E6O0007000F6O00010007000200062O000100A500013O0004E23O00A500012O009F000100043O001208010200233O001208010300244O00EE000100034O00D900016O009F00015O0020680001000100250020100001000100122O00BB0001000200020006D8000100C200013O0004E23O00C200012O009F0001000C3O0020100001000100262O00BB00010002000200060F000100B5000100010004E23O00B500012O009F0001000C3O0020100001000100272O00BB00010002000200060F000100C2000100010004E23O00C200012O009F000100083O00202300010001000D4O00025O00202O0002000200254O000300036O00010003000200062O000100C200013O0004E23O00C200012O009F000100043O001208010200283O001208010300294O00EE000100034O00D900015O001208012O00053O00266F3O00EC0001001E0004E23O00EC00012O009F00015O00206800010001002A0020100001000100032O00BB0001000200020006D80001003D2O013O0004E23O003D2O012O009F0001000C3O00205500010001002B4O00035O00202O0003000300114O00010003000200062O000100D800013O0004E23O00D800012O009F00015O0020680001000100110020100001000100042O00BB000100020002000E21002C00DE000100010004E23O00DE00012O009F000100104O009F000200113O00201000020002002D2O00BB0002000200020006660001003D2O0100020004E23O003D2O012O009F000100083O0020CE00010001000D4O00025O00202O00020002002A4O000300126O00010003000200062O0001003D2O013O0004E23O003D2O012O009F000100043O0012BA0002002E3O00122O0003002F6O000100036O00015O00044O003D2O0100266F3O0001000100100004E23O000100012O009F00015O0020680001000100300020100001000100122O00BB0001000200020006D8000100222O013O0004E23O00222O012O009F000100113O0020100001000100312O00BB00010002000200260E000100102O01001F0004E23O00102O012O009F000100133O000E21001300102O0100010004E23O00102O012O009F00015O0020680001000100320020100001000100152O00BB0001000200020006D8000100102O013O0004E23O00102O012O009F000100113O00205500010001001B4O00035O00202O0003000300334O00010003000200062O000100222O013O0004E23O00222O012O009F000100113O0020C80001000100344O00035O00202O0003000300334O00010003000200262O000100222O0100350004E23O00222O012O009F000100083O00204E00010001000D4O00025O00202O0002000200304O000300036O000400073O00202O00040004003600122O000600376O0004000600024O000400046O00010004000200062O000100222O013O0004E23O00222O012O009F000100043O001208010200383O001208010300394O00EE000100034O00D900016O009F00015O00206800010001003A0020100001000100032O00BB0001000200020006D80001003B2O013O0004E23O003B2O012O009F000100023O0020B50001000100064O00025O00202O00020002003A4O000300036O000400043O00122O0005003B3O00122O0006003C6O0004000600024O000500056O000600146O00010006000200062O0001003B2O013O0004E23O003B2O012O009F000100043O0012080102003D3O0012080103003E4O00EE000100034O00D900015O001208012O001F3O0004E23O000100012O00463O00017O00263O00028O00026O00F03F03083O0045706964656D696303073O0049735265616479026O00244003053O005072652O7303093O004973496E52616E6765026O003E4003143O0058667A1876A6445E36721376945E5862660C33FD03073O002D3D16137C13CB030F3O00466573746572696E67537472696B6503143O00466573746572696E67576F756E64446562752O66030F3O0041757261416374697665436F756E74030C3O004361737454617267657449662O033O00CC1B2O03073O00D9A1726D956210031C3O0014252B68B9661B2E3F43AF6000293379FC751D25076FB9600730782403063O00147240581CDC027O0040030A3O0041706F63616C79707365030F3O00432O6F6C646F776E52656D61696E732O033O003C00CA03073O00DD5161B2D498B0031D3O00CBE20EEF1FDFEE13FC25DEF30FF211C8A71CF41FF2F418EF0FDDA74CAB03053O007AAD877D9B03093O004465617468436F696C030B3O004973417661696C61626C65030E3O0049735370652O6C496E52616E676503173O0080C401AD370ECB8BC80CF92O3ECDBBD205AD2A2188D59303073O00A8E4A160D95F51030D3O004275727374696E67536F726573026O00204003133O00DADF37632B59DF912F532A68C8D43A493F178903063O0037BBB14E3C4F2O033O0020C75103073O00E04DAE3F8B26AF031C3O0082444B3A81535120837E4B3A9648532BC440572BBB525D3A9151187A03043O004EE4213800D73O001208012O00013O00266F3O0043000100020004E23O004300012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001002200013O0004E23O002200012O009F000100013O0006D80001000F00013O0004E23O000F00012O009F000100023O0026A700010022000100050004E23O002200012O009F000100033O00200A2O01000100064O00025O00202O0002000200034O000300046O000400046O000500053O00202O00050005000700122O000700086O0005000700024O000500056O00010005000200062O0001002200013O0004E23O002200012O009F000100063O001208010200093O0012080103000A4O00EE000100034O00D900016O009F00015O00206800010001000B0020100001000100042O00BB0001000200020006D80001004200013O0004E23O004200012O009F00015O0020BE00010001000C00202O00010001000D4O0001000200024O000200073O00062O00010042000100020004E23O004200012O009F000100083O00201200010001000E4O00025O00202O00020002000B4O000300096O000400063O00122O0005000F3O00122O000600106O0004000600024O0005000A6O000600066O00010006000200062O0001004200013O0004E23O004200012O009F000100063O001208010200113O001208010300124O00EE000100034O00D900015O001208012O00133O000ECA0013008800013O0004E23O008800012O009F00015O00206800010001000B0020100001000100042O00BB0001000200020006D80001006500013O0004E23O006500012O009F00015O0020BE00010001001400202O0001000100154O0001000200024O0002000B3O00062O00010065000100020004E23O006500012O009F000100083O0020B500010001000E4O00025O00202O00020002000B4O000300096O000400063O00122O000500163O00122O000600176O0004000600024O0005000A6O0006000C6O00010006000200062O0001006500013O0004E23O006500012O009F000100063O001208010200183O001208010300194O00EE000100034O00D900016O009F00015O00206800010001001A0020100001000100042O00BB0001000200020006D8000100D600013O0004E23O00D600012O009F000100013O00060F000100D6000100010004E23O00D600012O009F00015O00206800010001000300201000010001001B2O00BB00010002000200060F000100D6000100010004E23O00D600012O009F000100033O0020400001000100064O00025O00202O00020002001A4O000300046O000500053O00202O00050005001C4O00075O00202O00070007001A4O0005000700024O000500056O00010005000200062O000100D600013O0004E23O00D600012O009F000100063O0012BA0002001D3O00122O0003001E6O000100036O00015O00044O00D6000100266F3O0001000100010004E23O000100012O009F0001000D3O0020100001000100042O00BB0001000200020006D8000100AE00013O0004E23O00AE00012O009F00015O00206800010001001F00201000010001001B2O00BB0001000200020006D8000100A200013O0004E23O00A200012O009F00015O0020C200010001000C00202O00010001000D4O0001000200024O000200073O00062O000100A2000100020004E23O00A200012O009F00015O00206800010001000C00201000010001000D2O00BB000100020002000ED3002000AE000100010004E23O00AE00012O009F000100033O00201D0001000100064O0002000E6O0003000F6O00010003000200062O000100AE00013O0004E23O00AE00012O009F000100063O001208010200213O001208010300224O00EE000100034O00D900016O009F00015O00206800010001000B0020100001000100042O00BB0001000200020006D8000100D400013O0004E23O00D400012O009F00015O0020BE00010001000C00202O00010001000D4O0001000200024O000200073O00062O000100D4000100020004E23O00D400012O009F00015O00206800010001001F00201000010001001B2O00BB0001000200020006D8000100D400013O0004E23O00D400012O009F000100083O00201200010001000E4O00025O00202O00020002000B4O000300096O000400063O00122O000500233O00122O000600246O0004000600024O0005000A6O000600066O00010006000200062O000100D400013O0004E23O00D400012O009F000100063O001208010200253O001208010300264O00EE000100034O00D900015O001208012O00023O0004E23O000100012O00463O00017O003A3O00028O00026O00F03F03123O004461726B5472616E73666F726D6174696F6E030A3O0049734361737461626C65030A3O0041706F63616C79707365030F3O00432O6F6C646F776E52656D61696E73026O00144003053O005072652O73031F3O00CA7FA008BADA6CB30D96C871A00E84DA77BD0DC5CD71BD0F81C169BC10C59803053O00E5AE1ED26303073O0049735265616479030C3O004361737454617267657449662O033O0016EC9E03073O00597B8DE6318D5D03163O00F261F90F1146EA61E5095049FC7EFA081F5DFD62B65403063O002A9311966C70027O0040026O000840030D3O00556E686F6C79412O7361756C742O033O0002AF2303063O00886FC64D1F87031B3O001707AF59B1FD28A8111AA643B1F057AA0D06AB52B2F319BA4258F303083O00C96269C736DD8477030A3O00536F756C52656170657203073O0054696D65546F58025O0080414003103O004865616C746850657263656E7461676503093O0054696D65546F446965030E3O0049735370652O6C496E52616E676503183O00AA03962D3D27A9B81C86334236A3B600872E153BBFF95DD503073O00CCD96CE3416255026O001040030E3O0053752O6D6F6E476172676F796C6503063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O6603123O00436F2O6D616E6465726F6674686544656164030B3O004973417661696C61626C65031B3O004DD6F8E823CE61C4F4F72BCF47CFF0A52FCF51CFF1EA3BCE4D83A703063O00A03EA395854C03093O00526169736544656164030D3O004973446561644F7247686F737403083O00497341637469766503233O00C4A1043CC6E9A4082EC796A30220CFD2AF1A21D096F44D2BCAC5B0012EDAC5B41423C603053O00A3B6C06D4F03113O00456D706F77657252756E65576561706F6E026O003740030F3O0041726D796F6674686544616D6E6564026O00354003203O00312B10CFE231343FD2E03A233FD7F035360FCEB537290FCCF13B310ED3B5657603053O0095544660A0030F3O0041626F6D696E6174696F6E4C696D6203043O0052756E65031D3O00390402E031080CF9310903D2340F00EF780502E2342O02FA36154DBC6A03043O008D58666D2O033O00BE5AC403083O00A1D333AA107A5D3503183O00E8A1A724C4BCB729EBABA068F8A1BD24FFA1A526E8EEE37003043O00489BCED2005C012O001208012O00013O00266F3O003A000100020004E23O003A00012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001001C00013O0004E23O001C00012O009F00015O0020680001000100050020100001000100062O00BB0001000200020026A70001001C000100070004E23O001C00012O009F000100013O0020CE0001000100084O00025O00202O0002000200034O000300026O00010003000200062O0001001C00013O0004E23O001C00012O009F000100033O001208010200093O0012080103000A4O00EE000100034O00D900016O009F00015O00206800010001000500201000010001000B2O00BB0001000200020006D80001003900013O0004E23O003900012O009F000100043O0006D80001003900013O0004E23O003900012O009F000100053O00209B00010001000C4O00025O00202O0002000200054O000300066O000400033O00122O0005000D3O00122O0006000E6O0004000600024O000500076O000600086O000700096O00010007000200062O0001003900013O0004E23O003900012O009F000100033O0012080102000F3O001208010300104O00EE000100034O00D900015O001208012O00113O00266F3O0086000100120004E23O008600012O009F00015O00206800010001001300201000010001000B2O00BB0001000200020006D80001005900013O0004E23O005900012O009F000100043O0006D80001005900013O0004E23O005900012O009F000100053O0020D700010001000C4O00025O00202O0002000200134O000300066O000400033O00122O000500143O00122O000600156O0004000600024O000500076O000600066O0007000A6O00010007000200062O0001005900013O0004E23O005900012O009F000100033O001208010200163O001208010300174O00EE000100034O00D900016O009F00015O00206800010001001800201000010001000B2O00BB0001000200020006D80001008500013O0004E23O008500012O009F0001000B3O00266F00010085000100020004E23O008500012O009F0001000C3O0020100001000100190012080103001A4O00072O010003000200260E0001006D000100070004E23O006D00012O009F0001000C3O00201000010001001B2O00BB0001000200020026E8000100850001001A0004E23O008500012O009F0001000C3O00201000010001001C2O00BB000100020002000E2A00070085000100010004E23O008500012O009F000100013O0020400001000100084O00025O00202O0002000200184O000300046O0005000C3O00202O00050005001D4O00075O00202O0007000700184O0005000700024O000500056O00010005000200062O0001008500013O0004E23O008500012O009F000100033O0012080102001E3O0012080103001F4O00EE000100034O00D900015O001208012O00203O000ECA000100C600013O0004E23O00C600012O009F00015O0020680001000100210020100001000100042O00BB0001000200020006D8000100A800013O0004E23O00A800012O009F0001000D3O0020620001000100224O00035O00202O0003000300234O00010003000200062O0001009B000100010004E23O009B00012O009F00015O0020680001000100240020100001000100252O00BB00010002000200060F000100A8000100010004E23O00A800012O009F000100013O0020CE0001000100084O00025O00202O0002000200214O0003000E6O00010003000200062O000100A800013O0004E23O00A800012O009F000100033O001208010200263O001208010300274O00EE000100034O00D900016O009F00015O0020680001000100280020100001000100042O00BB0001000200020006D8000100C500013O0004E23O00C500012O009F0001000F3O0020100001000100292O00BB00010002000200060F000100B8000100010004E23O00B800012O009F0001000F3O00201000010001002A2O00BB00010002000200060F000100C5000100010004E23O00C500012O009F000100013O0020230001000100084O00025O00202O0002000200284O000300036O00010003000200062O000100C500013O0004E23O00C500012O009F000100033O0012080102002B3O0012080103002C4O00EE000100034O00D900015O001208012O00023O00266F3O00352O0100110004E23O00352O012O009F00015O00206800010001002D0020100001000100042O00BB0001000200020006D8000100192O013O0004E23O00192O012O009F000100043O0006D8000100092O013O0004E23O00092O012O009F000100103O0006D8000100D700013O0004E23O00D700012O009F000100113O00262O0001000C2O01002E0004E23O000C2O012O009F00015O0020680001000100210020100001000100252O00BB00010002000200060F000100E9000100010004E23O00E900012O009F00015O00206800010001002F0020100001000100252O00BB0001000200020006D8000100E900013O0004E23O00E900012O009F000100123O0006D8000100E900013O0004E23O00E900012O009F000100133O00060F0001000C2O0100010004E23O000C2O012O009F00015O0020680001000100210020100001000100252O00BB00010002000200060F000100FC000100010004E23O00FC00012O009F00015O00206800010001002F0020100001000100252O00BB00010002000200060F000100FC000100010004E23O00FC00012O009F0001000F3O0020620001000100224O00035O00202O0003000300034O00010003000200062O0001000C2O0100010004E23O000C2O012O009F00015O0020680001000100210020100001000100252O00BB00010002000200060F000100092O0100010004E23O00092O012O009F0001000F3O0020620001000100224O00035O00202O0003000300034O00010003000200062O0001000C2O0100010004E23O000C2O012O009F000100143O0026E8000100192O0100300004E23O00192O012O009F000100013O0020CE0001000100084O00025O00202O00020002002D4O000300156O00010003000200062O000100192O013O0004E23O00192O012O009F000100033O001208010200313O001208010300324O00EE000100034O00D900016O009F00015O0020680001000100330020100001000100042O00BB0001000200020006D8000100342O013O0004E23O00342O012O009F0001000D3O0020100001000100342O00BB0001000200020026A7000100342O0100120004E23O00342O012O009F000100043O0006D8000100342O013O0004E23O00342O012O009F000100013O0020230001000100084O00025O00202O0002000200334O000300036O00010003000200062O000100342O013O0004E23O00342O012O009F000100033O001208010200353O001208010300364O00EE000100034O00D900015O001208012O00123O00266F3O0001000100200004E23O000100012O009F00015O00206800010001001800201000010001000B2O00BB0001000200020006D80001005B2O013O0004E23O005B2O012O009F0001000B3O000ED30011005B2O0100010004E23O005B2O012O009F000100053O00205E00010001000C4O00025O00202O0002000200184O000300066O000400033O00122O000500373O00122O000600386O0004000600024O000500166O000600176O0007000C3O00202O00070007001D4O00095O00202O0009000900184O0007000900024O000700076O00010007000200062O0001005B2O013O0004E23O005B2O012O009F000100033O0012BA000200393O00122O0003003A6O000100036O00015O00044O005B2O010004E23O000100012O00463O00017O00373O00028O00030A3O0041706F63616C7970736503073O0049735265616479026O00104003063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O66026O00374003123O00436F2O6D616E6465726F6674686544656164030B3O004973417661696C61626C6503053O005072652O7303173O00476A5B0D324A63441D36067D551C347969511A26563A0603053O0053261A346E030D3O0041726D796F667468654465616403123O004461726B5472616E73666F726D6174696F6E030F3O00432O6F6C646F776E52656D61696E73026O000840030D3O00556E686F6C79412O7361756C74026O002440031D3O0059052A5F671821794C1F22795C122642181026545F2834434C0237060C03043O0026387747026O00F03F027O004003113O00456D706F77657252756E65576561706F6E030A3O0049734361737461626C6503213O00F6E248D93253E1D04AC32B53CCF85DD73559FDAF5FD73751CCFC5DC23046B3BE0803063O0036938F38B645031C3O00C38FF746D3CFBEFE5ACCD794F35D9FD180ED4EE0C584EB5CCF96D0AD03053O00BFB6E19F29030A3O0052756E6963506F776572026O00444003213O002F133A5EB493D02A1C3B538495CF2A06215A85C7C52A002F6A9882D63E026804DD03073O00A24B724835EBE7030A3O00536F756C52656170657203073O0054696D65546F58025O00804140026O00144003103O004865616C746850657263656E7461676503093O0054696D65546F44696503183O009F3351EE6C10893D54E741428B3D56E56C11892851F2135403063O0062EC5C248233030E3O0053752O6D6F6E476172676F796C65031C3O00B70C01B74AA68A37A52O0BB55CA4B070A3181EBD7ABBB024B1094CE203083O0050C4796CDA25C8D503083O0042752O66446F776E03113O004465617468416E64446563617942752O6603153O00017D1B404F008E4074036D4C31990567176F0B5FD203073O00EA6013621F2B6E030F3O00466573746572696E67537472696B65031E4O001A41D3A9608208186DD4B860820D1A12C0AD608C390C57D3B962CB544F03073O00EB667F32A7CC1203093O004465617468436F696C03043O0052756E65030E3O0049735370652O6C496E52616E676503183O0054A4F4374C1153AEFC2F042951B3F21C572B44B4E563167C03063O004E30C19543240084012O001208012O00013O00266F3O0072000100010004E23O007200012O009F00015O0020680001000100020020100001000100032O00BB0001000200020006D80001002A00013O0004E23O002A00012O009F000100013O000ED30004002A000100010004E23O002A00012O009F000100023O0020550001000100054O00035O00202O0003000300064O00010003000200062O0001001600013O0004E23O001600012O009F000100033O00260E0001001C000100070004E23O001C00012O009F00015O0020680001000100080020100001000100092O00BB00010002000200060F0001002A000100010004E23O002A00012O009F000100043O00202B00010001000A4O00025O00202O0002000200024O000300056O000400046O00010004000200062O0001002A00013O0004E23O002A00012O009F000100063O0012080102000B3O0012080103000C4O00EE000100034O00D900016O009F00015O00206800010001000D0020100001000100032O00BB0001000200020006D80001007100013O0004E23O007100012O009F000100073O0006D80001007100013O0004E23O007100012O009F00015O0020680001000100080020100001000100092O00BB0001000200020006D80001004600013O0004E23O004600012O009F00015O00206800010001000E00201000010001000F2O00BB00010002000200260E00010064000100100004E23O006400012O009F000100023O0020620001000100054O00035O00202O0003000300064O00010003000200062O00010064000100010004E23O006400012O009F00015O0020680001000100080020100001000100092O00BB00010002000200060F00010058000100010004E23O005800012O009F00015O0020680001000100110020100001000100092O00BB0001000200020006D80001005800013O0004E23O005800012O009F00015O00206800010001001100201000010001000F2O00BB00010002000200260E00010064000100120004E23O006400012O009F00015O0020680001000100110020100001000100092O00BB00010002000200060F00010071000100010004E23O007100012O009F00015O0020680001000100080020100001000100092O00BB00010002000200060F00010071000100010004E23O007100012O009F000100043O00202300010001000A4O00025O00202O00020002000D4O000300036O00010003000200062O0001007100013O0004E23O007100012O009F000100063O001208010200133O001208010300144O00EE000100034O00D900015O001208012O00153O00266F3O00CE000100160004E23O00CE00012O009F000100073O0006D8000100A900013O0004E23O00A900012O009F000100083O0006D8000100A900013O0004E23O00A900012O009F000100033O0026E8000100A9000100070004E23O00A900010012082O0100013O000ECA0001007E000100010004E23O007E00012O009F00025O0020680002000200170020100002000200182O00BB0002000200020006D80002009300013O0004E23O009300012O009F000200043O0020CE00020002000A4O00035O00202O0003000300174O000400096O00020004000200062O0002009300013O0004E23O009300012O009F000200063O001208010300193O0012080104001A4O00EE000200044O00D900026O009F00025O0020680002000200110020100002000200182O00BB0002000200020006D8000200A900013O0004E23O00A900012O009F000200043O00202B00020002000A4O00035O00202O0003000300114O0004000A6O000500056O00020005000200062O000200A900013O0004E23O00A900012O009F000200063O0012BA0003001B3O00122O0004001C6O000200046O00025O00044O00A900010004E23O007E00012O009F00015O00206800010001000E0020100001000100182O00BB0001000200020006D8000100CD00013O0004E23O00CD00012O009F00015O0020680001000100080020100001000100092O00BB0001000200020006D8000100BA00013O0004E23O00BA00012O009F000100023O00201000010001001D2O00BB000100020002000E21001E00C0000100010004E23O00C000012O009F00015O0020680001000100080020100001000100092O00BB00010002000200060F000100CD000100010004E23O00CD00012O009F000100043O0020CE00010001000A4O00025O00202O00020002000E4O0003000B6O00010003000200062O000100CD00013O0004E23O00CD00012O009F000100063O0012080102001F3O001208010300204O00EE000100034O00D900015O001208012O00103O000ECA0015001F2O013O0004E23O001F2O012O009F00015O0020680001000100210020100001000100032O00BB0001000200020006D8000100F600013O0004E23O00F600012O009F0001000C3O00266F000100F6000100150004E23O00F600012O009F0001000D3O002010000100010022001208010300234O00072O010003000200260E000100E4000100240004E23O00E400012O009F0001000D3O0020100001000100252O00BB0001000200020026E8000100F6000100230004E23O00F600012O009F0001000D3O0020100001000100262O00BB000100020002000E2A002400F6000100010004E23O00F600012O009F000100043O00202300010001000A4O00025O00202O0002000200214O000300046O00010004000200062O000100F600013O0004E23O00F600012O009F000100063O001208010200273O001208010300284O00EE000100034O00D900016O009F00015O0020680001000100290020100001000100182O00BB0001000200020006D80001001E2O013O0004E23O001E2O012O009F000100073O0006D80001001E2O013O0004E23O001E2O012O009F000100023O0020620001000100054O00035O00202O0003000300064O00010003000200062O000100112O0100010004E23O00112O012O009F00015O0020680001000100080020100001000100092O00BB00010002000200060F0001001E2O0100010004E23O001E2O012O009F000100023O00201000010001001D2O00BB000100020002000ED3001E001E2O0100010004E23O001E2O012O009F000100043O0020CE00010001000A4O00025O00202O0002000200294O0003000E6O00010003000200062O0001001E2O013O0004E23O001E2O012O009F000100063O0012080102002A3O0012080103002B4O00EE000100034O00D900015O001208012O00163O00266F3O00612O0100100004E23O00612O012O009F0001000F3O0020100001000100032O00BB0001000200020006D80001003C2O013O0004E23O003C2O012O009F000100023O00205500010001002C4O00035O00202O00030003002D4O00010003000200062O0001003C2O013O0004E23O003C2O012O009F000100013O000E2A0001003C2O0100010004E23O003C2O012O009F000100043O00201D00010001000A4O000200106O000300116O00010003000200062O0001003C2O013O0004E23O003C2O012O009F000100063O0012080102002E3O0012080103002F4O00EE000100034O00D900016O009F00015O0020680001000100300020100001000100032O00BB0001000200020006D8000100602O013O0004E23O00602O012O009F000100013O002687000100532O0100010004E23O00532O012O009F00015O0020680001000100020020100001000100092O00BB0001000200020006D8000100532O013O0004E23O00532O012O009F000100023O00201000010001001D2O00BB0001000200020026A7000100602O01001E0004E23O00602O012O009F000100083O00060F000100602O0100010004E23O00602O012O009F000100043O00202300010001000A4O00025O00202O0002000200304O000300046O00010004000200062O000100602O013O0004E23O00602O012O009F000100063O001208010200313O001208010300324O00EE000100034O00D900015O001208012O00043O00266F3O0001000100040004E23O000100012O009F00015O0020680001000100330020100001000100032O00BB0001000200020006D8000100832O013O0004E23O00832O012O009F000100023O0020100001000100342O00BB0001000200020026E8000100832O0100150004E23O00832O012O009F000100043O00204000010001000A4O00025O00202O0002000200334O000300046O0005000D3O00202O0005000500354O00075O00202O0007000700334O0005000700024O000500056O00010005000200062O000100832O013O0004E23O00832O012O009F000100063O0012BA000200363O00122O000300376O000100036O00015O00044O00832O010004E23O000100012O00463O00017O003C3O00028O00026O00F03F03093O004465617468436F696C03073O0049735265616479026O00084003083O0045706964656D6963030B3O004973417661696C61626C6503123O00436F2O6D616E6465726F667468654465616403063O0042752O66557003163O00436F2O6D616E6465726F667468654465616442752O66030A3O0041706F63616C79707365030F3O00432O6F6C646F776E52656D61696E73026O001440030B3O0042752O6652656D61696E73026O003B4003083O00446562752O665570030E3O004465617468526F74446562752O66030D3O00446562752O6652656D61696E732O033O0047434403053O005072652O73030E3O0049735370652O6C496E52616E6765031E3O00341B810C490F1D8F114D7016891F490F0E92114E0F1F830C483F1093581703053O0021507EE078026O00104003093O004973496E52616E6765026O003E40031C3O00E9B80AC059E1A1008454E5AF0BFB4CFEA10CFB5DEFBC0ACB52FFE85B03053O003C8CC863A4027O0040030D3O00506C616775656272696E676572030B3O00537570657273747261696E030C3O00556E686F6C79426C6967687403113O00506C616775656272696E67657242752O6603223O0090FB1128A6B8E71423AC83F11666AA8EF30C19B295FD0B19A384E00D29AC94B4557603053O00C2E7946446030C3O00432O6F6C646F776E446F776E03093O004D6F72626964697479026O00354003223O005342C9ACFAD1794ECDAAF1C0520CC9AAF1C0795CD3AAF9F7474FD5AAF9C6550C90F103063O00A8262CA1C39603083O004F7574627265616B03093O00436173744379636C65031D3O008FE9967422EDB71DC0F48B7138D7A60489F3BD7733FCBF198EEFC2276403083O0076E09CE2165088D6030E3O00416E74694D616769635368652O6C030A3O0049734361737461626C6503113O0052756E6963506F77657244656669636974026O004440030E3O0053752O6D6F6E476172676F796C6503193O0043E04D894FEF5E8941D14A8847E255C043E34ABF43E343C01003043O00E0228E39030D3O00416E74694D616769635A6F6E65025O00805140030C3O00412O73696D696C6174696F6E03183O00DFA9D1D47EF05A07DD98DFD27DF41D0FD3B4FADC7EEB1D5A03083O006EBEC7A5BD13913D030D3O0041726D796F6674686544656164025O0080414003243O00DBF97AF1B4C8DCD463E08EF8DEEE76ECCBCFD3EC7FD79BD5D3E448E9882OD3E479FBCB9303063O00A7BA8B1788EB00AD012O001208012O00013O00266F3O0094000100020004E23O009400012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001005300013O0004E23O005300012O009F000100013O00262O00010012000100050004E23O001200012O009F00015O0020680001000100060020100001000100072O00BB00010002000200060F00010053000100010004E23O005300012O009F000100023O0006D80001002F00013O0004E23O002F00012O009F00015O0020680001000100080020100001000100072O00BB0001000200020006D80001002F00013O0004E23O002F00012O009F000100033O0020550001000100094O00035O00202O00030003000A4O00010003000200062O0001002F00013O0004E23O002F00012O009F00015O00206800010001000B00201000010001000C2O00BB0001000200020026A70001002F0001000D0004E23O002F00012O009F000100033O00204100010001000E4O00035O00202O00030003000A4O000100030002000E2O000F0040000100010004E23O004000012O009F000100043O0020550001000100104O00035O00202O0003000300114O00010003000200062O0001005300013O0004E23O005300012O009F000100043O0020390001000100124O00035O00202O0003000300114O0001000300024O000200033O00202O0002000200134O00020002000200062O00010053000100020004E23O005300012O009F000100053O0020400001000100144O00025O00202O0002000200034O000300046O000500043O00202O0005000500154O00075O00202O0007000700034O0005000700024O000500056O00010005000200062O0001005300013O0004E23O005300012O009F000100063O001208010200163O001208010300174O00EE000100034O00D900016O009F00015O0020680001000100060020100001000100042O00BB0001000200020006D80001009300013O0004E23O009300012O009F000100073O000ED300180093000100010004E23O009300012O009F00015O0020680001000100080020100001000100072O00BB0001000200020006D80001006F00013O0004E23O006F00012O009F000100033O0020550001000100094O00035O00202O00030003000A4O00010003000200062O0001006F00013O0004E23O006F00012O009F00015O00206800010001000B00201000010001000C2O00BB00010002000200260E000100800001000D0004E23O008000012O009F000100043O0020550001000100104O00035O00202O0003000300114O00010003000200062O0001009300013O0004E23O009300012O009F000100043O0020390001000100124O00035O00202O0003000300114O0001000300024O000200033O00202O0002000200134O00020002000200062O00010093000100020004E23O009300012O009F000100053O00200A2O01000100144O00025O00202O0002000200064O000300086O000400046O000500043O00202O00050005001900122O0007001A6O0005000700024O000500056O00010005000200062O0001009300013O0004E23O009300012O009F000100063O0012080102001B3O0012080103001C4O00EE000100034O00D900015O001208012O001D3O00266F3O000A2O01001D0004E23O000A2O012O009F000100093O0020100001000100042O00BB0001000200020006D8000100D400013O0004E23O00D400012O009F00015O00201300010001000B00202O00010001000C4O0001000200024O0002000A3O00202O00020002000200202O00020002001D00062O000200A7000100010004E23O00A700012O009F000100013O000ED3000500D4000100010004E23O00D400012O009F00015O00206800010001001E0020100001000100072O00BB0001000200020006D8000100D400013O0004E23O00D400012O009F00015O00206800010001001F0020100001000100072O00BB00010002000200060F000100B9000100010004E23O00B900012O009F00015O0020680001000100200020100001000100072O00BB0001000200020006D8000100D400013O0004E23O00D400012O009F000100033O00203900010001000E4O00035O00202O0003000300214O0001000300024O000200033O00202O0002000200134O00020002000200062O000100D4000100020004E23O00D400012O009F000100053O0020AB0001000100144O000200096O000300046O000500043O00202O0005000500154O000700096O0005000700024O000500056O00010005000200062O000100D400013O0004E23O00D400012O009F000100063O001208010200223O001208010300234O00EE000100034O00D900016O009F00015O0020680001000100200020100001000100042O00BB0001000200020006D8000100092O013O0004E23O00092O012O009F0001000B3O0006D8000100F500013O0004E23O00F500012O009F00015O00206800010001000B0020100001000100072O00BB0001000200020006D8000100E900013O0004E23O00E900012O009F00015O00206800010001000B0020100001000100242O00BB0001000200020006D8000100EF00013O0004E23O00EF00012O009F00015O0020680001000100250020100001000100072O00BB00010002000200060F000100FB000100010004E23O00FB00012O009F00015O0020680001000100250020100001000100072O00BB0001000200020006D8000100FB00013O0004E23O00FB00012O009F0001000C3O00060F000100FB000100010004E23O00FB00012O009F0001000D3O0026A7000100092O0100260004E23O00092O012O009F000100053O00202B0001000100144O00025O00202O0002000200204O0003000E6O000400046O00010004000200062O000100092O013O0004E23O00092O012O009F000100063O001208010200273O001208010300284O00EE000100034O00D900015O001208012O00053O00266F3O00272O0100050004E23O00272O012O009F00015O0020680001000100290020100001000100042O00BB0001000200020006D8000100AC2O013O0004E23O00AC2O012O009F0001000F3O00209600010001002A4O00025O00202O0002000200294O000300106O000400116O000500043O00202O0005000500154O00075O00202O0007000700294O0005000700024O000500056O00010005000200062O000100AC2O013O0004E23O00AC2O012O009F000100063O0012BA0002002B3O00122O0003002C6O000100036O00015O00044O00AC2O0100266F3O0001000100010004E23O000100012O009F000100123O0006D80001007F2O013O0004E23O007F2O010012082O0100013O00266F0001002D2O0100010004E23O002D2O012O009F00025O00206800020002002D00201000020002002E2O00BB0002000200020006D8000200562O013O0004E23O00562O012O009F000200033O00201000020002002F2O00BB000200020002000E2A003000562O0100020004E23O00562O012O009F000200023O00060F000200492O0100010004E23O00492O012O009F00025O0020680002000200310020100002000200072O00BB0002000200020006D8000200492O013O0004E23O00492O012O009F00025O00206800020002003100201000020002000C2O00BB000200020002000E2A003000562O0100020004E23O00562O012O009F000200053O0020CE0002000200144O00035O00202O00030003002D4O000400136O00020004000200062O000200562O013O0004E23O00562O012O009F000200063O001208010300323O001208010400334O00EE000200044O00D900026O009F00025O00206800020002003400201000020002002E2O00BB0002000200020006D80002007F2O013O0004E23O007F2O012O009F000200033O00201000020002002F2O00BB000200020002000E2A0035007F2O0100020004E23O007F2O012O009F00025O0020680002000200360020100002000200072O00BB0002000200020006D80002007F2O013O0004E23O007F2O012O009F000200023O00060F000200702O0100010004E23O00702O012O009F00025O0020680002000200310020100002000200072O00BB00020002000200060F0002007F2O0100010004E23O007F2O012O009F000200053O0020CE0002000200144O00035O00202O0003000300344O000400146O00020004000200062O0002007F2O013O0004E23O007F2O012O009F000200063O0012BA000300373O00122O000400386O000200046O00025O00044O007F2O010004E23O002D2O012O009F00015O0020680001000100390020100001000100042O00BB0001000200020006D8000100AA2O013O0004E23O00AA2O012O009F000100153O0006D8000100AA2O013O0004E23O00AA2O012O009F00015O0020680001000100310020100001000100072O00BB0001000200020006D8000100942O013O0004E23O00942O012O009F00015O00206800010001003100201000010001000C2O00BB00010002000200260E0001009D2O01001D0004E23O009D2O012O009F00015O0020680001000100310020100001000100072O00BB0001000200020006D80001009D2O013O0004E23O009D2O012O009F0001000D3O0026A7000100AA2O01003A0004E23O00AA2O012O009F000100053O0020230001000100144O00025O00202O0002000200394O000300036O00010003000200062O000100AA2O013O0004E23O00AA2O012O009F000100063O0012080102003B3O0012080103003C4O00EE000100034O00D900015O001208012O00023O0004E23O000100012O00463O00017O00333O00028O00026O00084003093O0046697265626C2O6F64030A3O0049734361737461626C65030C3O00426173654475726174696F6E030E3O0053752O6D6F6E476172676F796C65030B3O004973417661696C61626C65030F3O00432O6F6C646F776E52656D61696E73026O004E40027O004003063O0042752O66557003113O004465617468416E64446563617942752O6603053O005072652O7303143O001CBC9A0818B987021EF59A0C19BC890109F5D95903043O006D7AD5E8030B3O004261676F66547269636B73026O00F03F03123O00556E686F6C79537472656E67746842752O6603143O0046696C7465726564466967687452656D61696E7303013O003C026O001440030E3O0049735370652O6C496E52616E676503183O00ECF6A50FE1F19D24FCFEA13BFDB7B031EDFEA33CFDB7F36603043O00508E97C2030A3O004265727365726B696E6703143O0001C3655F06D47C450DC1375E02C57E4D0FD5371A03043O002C63A617030E3O004C69676874734A7564676D656E74030B3O004665737465726D69676874030B3O0042752O6652656D61696E73030F3O004665737465726D6967687442752O6603093O0054696D65546F44696503193O0070FE2E3E27B743FD3C3234A979F93D7621A57FFE283A20E42403063O00C41C97495653030D3O00416E6365737472616C43612O6C026O00324003193O00F20D2A15914C0A77FF3C2A118E545864F20020118E4B5827A303083O001693634970E23878030B3O00417263616E6550756C736503043O0052756E6503113O0052756E6963506F7765724465666963697403173O00B967E1F483BD4AF2E081AB70A2E78CBB7CE3F99EF824B003053O00EDD8158295030D3O00417263616E65546F2O72656E74026O0034402O033O0047434403183O00832O5C5EBECC6196412O4DB5C74AC25C5E5CB9C852910E0D03073O003EE22E2O3FD0A903093O00426C2O6F644675727903143O00E7155A8C1B32294BF70015911E0E265FE90A15D703083O003E857935E37F6D4F0003022O001208012O00013O00266F3O0082000100020004E23O008200012O009F00015O0020680001000100030020100001000100042O00BB0001000200020006D80001005500013O0004E23O005500012O009F00015O00201B2O010001000300202O0001000100054O00010002000200202O0001000100024O000200013O00062O00020014000100010004E23O001400012O009F000100023O00060F00010048000100010004E23O004800012O009F00015O0020680001000100060020100001000100072O00BB0001000200020006D80001002000013O0004E23O002000012O009F00015O0020680001000100060020100001000100082O00BB000100020002000E2A00090040000100010004E23O004000012O009F000100033O0006D80001002B00013O0004E23O002B00012O009F000100044O008900025O00202O00020002000300202O0002000200054O00020002000200202O00020002000200062O0001001E000100020004E23O004800012O009F000100053O0006D80001003600013O0004E23O003600012O009F000100064O008900025O00202O00020002000300202O0002000200054O00020002000200202O00020002000200062O00010013000100020004E23O004800012O009F000100073O000ED3000A0040000100010004E23O004000012O009F000100083O00206200010001000B4O00035O00202O00030003000C4O00010003000200062O00010048000100010004E23O004800012O009F000100094O00B300025O00202O00020002000300202O0002000200054O00020002000200202O00020002000200062O00010055000100020004E23O005500012O009F0001000A3O0020CE00010001000D4O00025O00202O0002000200034O0003000B6O00010003000200062O0001005500013O0004E23O005500012O009F0001000C3O0012080102000E3O0012080103000F4O00EE000100034O00D900016O009F00015O0020680001000100100020100001000100042O00BB0001000200020006D80001002O02013O0004E23O002O02012O009F000100073O00266F0001002O020100110004E23O002O02012O009F000100083O00206200010001000B4O00035O00202O0003000300124O00010003000200062O0001006D000100010004E23O006D00012O009F0001000A3O0020A80001000100134O0002000D3O00122O000300143O00122O000400156O00010004000200062O0001002O02013O0004E23O002O02012O009F0001000A3O00205200010001000D4O00025O00202O0002000200104O0003000B6O000400046O0005000E3O00202O0005000500164O00075O00202O0007000700104O0005000700024O000500056O00010005000200062O0001002O02013O0004E23O002O02012O009F0001000C3O0012BA000200173O00122O000300186O000100036O00015O00044O002O020100266F3O00152O0100110004E23O00152O012O009F00015O0020680001000100190020100001000100042O00BB0001000200020006D8000100D900013O0004E23O00D900012O009F00015O0020F400010001001900202O0001000100054O00010002000200202O00010001000A00202O0001000100114O000200013O00062O00020096000100010004E23O009600012O009F000100023O00060F000100CC000100010004E23O00CC00012O009F00015O0020680001000100060020100001000100072O00BB0001000200020006D8000100A200013O0004E23O00A200012O009F00015O0020680001000100060020100001000100082O00BB000100020002000E2A000900C3000100010004E23O00C300012O009F000100033O0006D8000100AD00013O0004E23O00AD00012O009F000100044O008900025O00202O00020002001900202O0002000200054O00020002000200202O00020002000200062O00010020000100020004E23O00CC00012O009F000100053O0006D8000100B900013O0004E23O00B900012O009F000100064O00C700025O00202O00020002001900202O0002000200054O00020002000200202O00020002000A00202O00020002001100062O00010014000100020004E23O00CC00012O009F000100073O000ED3000A00C3000100010004E23O00C300012O009F000100083O00206200010001000B4O00035O00202O00030003000C4O00010003000200062O000100CC000100010004E23O00CC00012O009F000100094O009500025O00202O00020002001900202O0002000200054O00020002000200202O00020002000A00202O00020002001100062O000100D9000100020004E23O00D900012O009F0001000A3O0020CE00010001000D4O00025O00202O0002000200194O0003000B6O00010003000200062O000100D900013O0004E23O00D900012O009F0001000C3O0012080102001A3O0012080103001B4O00EE000100034O00D900016O009F00015O00206800010001001C0020100001000100042O00BB0001000200020006D8000100142O013O0004E23O00142O012O009F000100083O00205500010001000B4O00035O00202O0003000300124O00010003000200062O000100142O013O0004E23O00142O012O009F00015O00206800010001001D0020100001000100072O00BB0001000200020006D800012O002O013O0004E24O002O012O009F000100083O0020ED00010001001E4O00035O00202O00030003001F4O0001000300024O0002000E3O00202O0002000200204O00020002000200062O00012O002O0100020004E24O002O012O009F000100083O00203900010001001E4O00035O00202O0003000300124O0001000300024O0002000E3O00202O0002000200204O00020002000200062O000100142O0100020004E23O00142O012O009F0001000A3O00205200010001000D4O00025O00202O00020002001C4O0003000B6O000400046O0005000E3O00202O0005000500164O00075O00202O00070007001C4O0005000700024O000500056O00010005000200062O000100142O013O0004E23O00142O012O009F0001000C3O001208010200213O001208010300224O00EE000100034O00D900015O001208012O000A3O00266F3O00772O01000A0004E23O00772O012O009F00015O0020680001000100230020100001000100042O00BB0001000200020006D8000100552O013O0004E23O00552O012O009F000100013O0026E8000100232O0100240004E23O00232O012O009F000100023O00060F000100482O0100010004E23O00482O012O009F00015O0020680001000100060020100001000100072O00BB0001000200020006D80001002F2O013O0004E23O002F2O012O009F00015O0020680001000100060020100001000100082O00BB000100020002000E2A000900452O0100010004E23O00452O012O009F000100033O0006D8000100352O013O0004E23O00352O012O009F000100043O00262O000100482O0100240004E23O00482O012O009F000100053O0006D80001003B2O013O0004E23O003B2O012O009F000100063O00262O000100482O0100240004E23O00482O012O009F000100073O000ED3000A00452O0100010004E23O00452O012O009F000100083O00206200010001000B4O00035O00202O00030003000C4O00010003000200062O000100482O0100010004E23O00482O012O009F000100093O0026E8000100552O0100240004E23O00552O012O009F0001000A3O0020CE00010001000D4O00025O00202O0002000200234O0003000B6O00010003000200062O000100552O013O0004E23O00552O012O009F0001000C3O001208010200253O001208010300264O00EE000100034O00D900016O009F00015O0020680001000100270020100001000100042O00BB0001000200020006D8000100762O013O0004E23O00762O012O009F000100073O000E1E000A00682O0100010004E23O00682O012O009F000100083O0020100001000100282O00BB0001000200020026E8000100762O0100110004E23O00762O012O009F000100083O0020100001000100292O00BB000100020002000ED3000900762O0100010004E23O00762O012O009F0001000A3O00202B00010001000D4O00025O00202O0002000200274O0003000B6O000400046O00010004000200062O000100762O013O0004E23O00762O012O009F0001000C3O0012080102002A3O0012080103002B4O00EE000100034O00D900015O001208012O00023O00266F3O0001000100010004E23O000100012O009F00015O00206800010001002C0020100001000100042O00BB0001000200020006D8000100AC2O013O0004E23O00AC2O012O009F000100083O0020100001000100292O00BB000100020002000E2A002D00AC2O0100010004E23O00AC2O012O009F00015O0020042O010001000600202O0001000100084O0001000200024O000200083O00202O00020002002E4O00020002000200062O0001009E2O0100020004E23O009E2O012O009F00015O0020680001000100060020100001000100072O00BB0001000200020006D80001009E2O013O0004E23O009E2O012O009F000100023O0006D8000100AC2O013O0004E23O00AC2O012O009F000100083O0020100001000100282O00BB0001000200020026A7000100AC2O01000A0004E23O00AC2O012O009F0001000F3O0026A7000100AC2O0100110004E23O00AC2O012O009F0001000A3O00202B00010001000D4O00025O00202O00020002002C4O0003000B6O000400046O00010004000200062O000100AC2O013O0004E23O00AC2O012O009F0001000C3O0012080102002F3O001208010300304O00EE000100034O00D900016O009F00015O0020680001000100310020100001000100042O00BB0001000200020006D800012O0002013O0004E24O0002012O009F00015O00201B2O010001003100202O0001000100054O00010002000200202O0001000100024O000200013O00062O000200BD2O0100010004E23O00BD2O012O009F000100023O00060F000100F32O0100010004E23O00F32O012O009F00015O0020680001000100060020100001000100072O00BB0001000200020006D8000100C92O013O0004E23O00C92O012O009F00015O0020680001000100060020100001000100082O00BB000100020002000E2A000900EB2O0100010004E23O00EB2O012O009F000100033O0006D8000100D52O013O0004E23O00D52O012O009F000100044O00C700025O00202O00020002003100202O0002000200054O00020002000200202O00020002000A00202O00020002001100062O0001001F000100020004E23O00F32O012O009F000100053O0006D8000100E12O013O0004E23O00E12O012O009F000100064O00C700025O00202O00020002003100202O0002000200054O00020002000200202O00020002001100202O00020002000A00062O00010013000100020004E23O00F32O012O009F000100073O000ED3000A00EB2O0100010004E23O00EB2O012O009F000100083O00206200010001000B4O00035O00202O00030003000C4O00010003000200062O000100F32O0100010004E23O00F32O012O009F000100094O00B300025O00202O00020002003100202O0002000200054O00020002000200202O00020002000200062O00012O00020100020004E24O0002012O009F0001000A3O0020CE00010001000D4O00025O00202O0002000200314O0003000B6O00010003000200062O00012O0002013O0004E24O0002012O009F0001000C3O001208010200323O001208010300334O00EE000100034O00D900015O001208012O00113O0004E23O000100012O00463O00017O002C3O00028O00026O00084003073O0049735265616479030C3O004361737454617267657449662O033O001D152A03073O00C270745295B6CE030E3O0049735370652O6C496E52616E676503133O002EA75916C4DD1D29AD421CC5F04E2ABC0C499403073O006E59C82C78A08203093O004465617468436F696C026O00244003053O005072652O73030F3O00AFC64A524B753842A2CF0B55570A6903083O002DCBA32B26232A5B03083O0045706964656D696303093O004973496E52616E6765026O003E40030D3O00D795D52782A45DD1C5CF37C7FD03073O0034B2E5BC43E7C9026O00F03F027O0040030F3O00466573746572696E67537472696B652O033O002C485E03073O004341213064973C03163O00D9E2BDCCF6CDEEA0DF2OCCF3BCD1F8DAA7BDCCB38EB703053O0093BF87CEB803103O00802DA7D5D06CB18B21AA81CB47F2D57A03073O00D2E448C6A1B83303083O0042752O66446F776E03113O004465617468416E64446563617942752O66030C3O00556E686F6C7947726F756E64030B3O004973417661696C61626C65026O002A40026O002040026O00104003063O00446566696C6503063O0042752O66557003123O004461726B5472616E73666F726D6174696F6E03143O00466573746572696E67576F756E64446562752O66030F3O0041757261416374697665436F756E74030C3O003747EA2F77C03209E004339803063O00AE562993701303123O004C0F9805213002BB5E0E890E374F02BF1B5803083O00CB3B60ED6B456F710029012O001208012O00013O00266F3O0023000100020004E23O002300012O009F00015O0020100001000100032O00BB0001000200020006D8000100282O013O0004E23O00282O012O009F000100013O00060F000100282O0100010004E23O00282O012O009F000100023O00201A2O01000100044O00028O000300036O000400043O00122O000500053O00122O000600066O0004000600024O000500056O000600066O000700073O00202O0007000700074O00098O0007000900024O000700076O00010007000200062O000100282O013O0004E23O00282O012O009F000100043O0012BA000200083O00122O000300096O000100036O00015O00044O00282O0100266F3O0070000100010004E23O007000012O009F000100083O00206800010001000A0020100001000100032O00BB0001000200020006D80001004A00013O0004E23O004A00012O009F000100093O00060F0001004A000100010004E23O004A00012O009F0001000A3O00060F00010034000100010004E23O003400012O009F0001000B3O00060F00010037000100010004E23O003700012O009F0001000C3O0026A70001004A0001000B0004E23O004A00012O009F0001000D3O00204000010001000C4O000200083O00202O00020002000A4O000300046O000500073O00202O0005000500074O000700083O00202O00070007000A4O0005000700024O000500056O00010005000200062O0001004A00013O0004E23O004A00012O009F000100043O0012080102000D3O0012080103000E4O00EE000100034O00D900016O009F000100083O00206800010001000F0020100001000100032O00BB0001000200020006D80001006F00013O0004E23O006F00012O009F000100093O0006D80001006F00013O0004E23O006F00012O009F0001000A3O00060F00010059000100010004E23O005900012O009F0001000B3O00060F0001005C000100010004E23O005C00012O009F0001000C3O0026A70001006F0001000B0004E23O006F00012O009F0001000D3O00200A2O010001000C4O000200083O00202O00020002000F4O0003000E6O000400046O000500073O00202O00050005001000122O000700116O0005000700024O000500056O00010005000200062O0001006F00013O0004E23O006F00012O009F000100043O001208010200123O001208010300134O00EE000100034O00D900015O001208012O00143O000ECA001500A800013O0004E23O00A800012O009F000100083O0020680001000100160020100001000100032O00BB0001000200020006D80001008E00013O0004E23O008E00012O009F000100013O00060F0001008E000100010004E23O008E00012O009F000100023O0020B50001000100044O000200083O00202O0002000200164O000300036O000400043O00122O000500173O00122O000600186O0004000600024O000500056O0006000F6O00010006000200062O0001008E00013O0004E23O008E00012O009F000100043O001208010200193O0012080103001A4O00EE000100034O00D900016O009F000100083O00206800010001000A0020100001000100032O00BB0001000200020006D8000100A700013O0004E23O00A700012O009F0001000D3O00204000010001000C4O000200083O00202O00020002000A4O000300046O000500073O00202O0005000500074O000700083O00202O00070007000A4O0005000700024O000500056O00010005000200062O000100A700013O0004E23O00A700012O009F000100043O0012080102001B3O0012080103001C4O00EE000100034O00D900015O001208012O00023O00266F3O0001000100140004E23O000100012O009F000100103O0020100001000100032O00BB0001000200020006D8000100032O013O0004E23O00032O012O009F000100113O00205500010001001D4O000300083O00202O00030003001E4O00010003000200062O000100032O013O0004E23O00032O012O009F000100123O000E1E001500ED000100010004E23O00ED00012O009F000100083O00206800010001001F0020100001000100202O00BB0001000200020006D8000100D700013O0004E23O00D700012O009F000100133O0006D8000100C500013O0004E23O00C500012O009F000100143O000E1E002100ED000100010004E23O00ED00012O009F000100153O0006D8000100CB00013O0004E23O00CB00012O009F000100163O000E21002200ED000100010004E23O00ED00012O009F000100173O0006D8000100D100013O0004E23O00D100012O009F000100183O000E21002200ED000100010004E23O00ED00012O009F000100013O00060F000100D7000100010004E23O00D700012O009F000100193O000E1E002300ED000100010004E23O00ED00012O009F000100083O0020680001000100240020100001000100202O00BB0001000200020006D8000100032O013O0004E23O00032O012O009F000100153O00060F000100ED000100010004E23O00ED00012O009F000100133O00060F000100ED000100010004E23O00ED00012O009F000100173O00060F000100ED000100010004E23O00ED00012O009F0001001A3O0020550001000100254O000300083O00202O0003000300264O00010003000200062O000100032O013O0004E23O00032O012O009F000100083O0020C200010001002700202O0001000100284O0001000200024O000200123O00062O000100F7000100020004E23O00F700012O009F000100123O00266F000100032O0100140004E23O00032O012O009F0001000D3O00201D00010001000C4O0002001B6O0003001C6O00010003000200062O000100032O013O0004E23O00032O012O009F000100043O001208010200293O0012080103002A4O00EE000100034O00D900016O009F00015O0020100001000100032O00BB0001000200020006D8000100262O013O0004E23O00262O012O009F000100013O00060F000100152O0100010004E23O00152O012O009F000100123O000ED3001500262O0100010004E23O00262O012O009F000100113O0020550001000100254O000300083O00202O00030003001E4O00010003000200062O000100262O013O0004E23O00262O012O009F0001000D3O0020AB00010001000C4O00028O000300046O000500073O00202O0005000500074O00078O0005000700024O000500056O00010005000200062O000100262O013O0004E23O00262O012O009F000100043O0012080102002B3O0012080103002C4O00EE000100034O00D900015O001208012O00153O0004E23O000100012O00463O00017O00013O00029O00104O009F7O0006D83O000F00013O0004E23O000F0001001208012O00014O0007000100013O00266F3O0005000100010004E23O000500012O009F000200014O005A0002000100022O00B1000100023O0006D80001000F00013O0004E23O000F00012O00022O0100023O0004E23O000F00010004E23O000500012O00463O00017O00253O00028O0003113O00496D70726F7665644465617468436F696C030B3O004973417661696C61626C6503113O00436F696C6F664465766173746174696F6E026O000840026O001040027O0040030E3O0053752O6D6F6E476172676F796C65030F3O00432O6F6C646F776E52656D61696E73026O00F03F030A3O0041706F63616C79707365030A3O00436F6D62617454696D65026O003440030D3O00556E686F6C79412O7361756C7403083O00446562752O66557003113O00526F2O74656E546F756368446562752O6603073O0048617354696572026O003F40030F3O0041706F634D61677573416374697665030F3O0041726D794D61677573416374697665026O001440030D3O0056696C65436F6E746167696F6E030A3O0052756E6963506F776572026O004E40030B3O00526F2O74656E546F756368030A3O00446562752O66446F776E03113O0052756E6963506F7765724465666963697403043O0052756E6503063O0042752O665570030E3O0053752O64656E442O6F6D42752O66026O002440026O001C40030B3O004665737465726D69676874030F3O004665737465726D6967687442752O66030B3O0042752O6652656D61696E732O033O00474344030D3O00496E666563746564436C617773007B012O001208012O00013O00266F3O004B000100010004E23O004B00012O009F000100013O0020680001000100020020100001000100032O00BB0001000200020006D80001001200013O0004E23O001200012O009F000100013O0020680001000100040020100001000100032O00BB00010002000200060F00010012000100010004E23O001200012O009F000100023O000E1E00050025000100010004E23O002500012O009F000100013O0020680001000100040020100001000100032O00BB0001000200020006D80001001B00013O0004E23O001B00012O009F000100023O000E1E00060025000100010004E23O002500012O009F000100013O0020680001000100020020100001000100032O00BB00010002000200060F00010024000100010004E23O002400012O009F000100023O000E1E00070025000100010004E23O002500012O007A00016O0060000100014O00E100016O009F000100023O000E1E00050048000100010004E23O004800012O009F000100013O0020680001000100080020100001000100092O00BB000100020002000E2A000A003C000100010004E23O003C00012O009F000100013O00206800010001000B0020100001000100092O00BB000100020002000E21000A0048000100010004E23O004800012O009F000100013O00206800010001000B0020100001000100032O00BB0001000200020006D80001004800013O0004E23O004800012O009F000100013O0020680001000100080020100001000100032O00BB0001000200020006D80001004800013O0004E23O004800012O009F000100043O00206800010001000C2O005A000100010002000E21000D0048000100010004E23O004800012O007A00016O0060000100014O00E1000100033O001208012O000A3O00266F3O00B1000100070004E23O00B100012O009F000100013O0020DE00010001000B00202O0001000100094O0001000200024O000200063O00062O0002005A000100010004E23O005A00012O009F000100013O00206800010001000B0020100001000100032O00BB00010002000200060F00010090000100010004E23O009000012O009F000100073O00060F00010098000100010004E23O009800012O009F000100083O000ED3000A006F000100010004E23O006F00012O009F000100013O00206800010001000E0020100001000100092O00BB0001000200020026A70001006F0001000D0004E23O006F00012O009F000100013O00206800010001000E0020100001000100032O00BB0001000200020006D80001006F00013O0004E23O006F00012O009F000100093O00060F00010098000100010004E23O009800012O009F0001000A3O00205500010001000F4O000300013O00202O0003000300104O00010003000200062O0001007900013O0004E23O007900012O009F000100083O000E1E000A0097000100010004E23O009700012O009F000100083O000E2100060097000100010004E23O009700012O009F0001000B3O0020DC00010001001100122O000300123O00122O000400066O00010004000200062O0001009000013O0004E23O009000012O009F0001000C3O0020100001000100132O00BB00010002000200060F0001008D000100010004E23O008D00012O009F0001000C3O0020100001000100142O00BB0001000200020006D80001009000013O0004E23O009000012O009F000100083O000E1E000A0097000100010004E23O009700012O009F0001000D3O0026A700010096000100150004E23O009600012O009F000100083O000E1E000A0097000100010004E23O009700012O007A00016O0060000100014O00E1000100054O006A000100013O00202O00010001001600202O0001000100034O00010002000200062O000100AF00013O0004E23O00AF00012O009F000100013O0020680001000100160020100001000100092O00BB0001000200020026A7000100AD000100050004E23O00AD00012O009F0001000B3O0020100001000100172O00BB0001000200020026A7000100AD000100180004E23O00AD00012O009F000100094O00DF000100013O0004E23O00AF00012O007A00016O0060000100014O00E10001000E3O001208012O00053O000ECA000500C500013O0004E23O00C500012O009F000100023O002687000100BA0001000A0004E23O00BA00012O009F0001000F4O00DF000100013O0004E23O00BB00012O007A00016O0060000100014O00E1000100094O009F000100023O000ED3000700C1000100010004E23O00C100012O009F0001000F3O0004E23O00C300012O007A00016O0060000100014O00E1000100103O001208012O00063O00266F3O00322O0100060004E23O00322O012O009F000100013O0020680001000100190020100001000100032O00BB0001000200020006D8000100DF00013O0004E23O00DF00012O009F000100013O0020680001000100190020100001000100032O00BB0001000200020006D8000100DA00013O0004E23O00DA00012O009F0001000A3O00206200010001001A4O000300013O00202O0003000300104O00010003000200062O000100DF000100010004E23O00DF00012O009F0001000B3O00201000010001001B2O00BB0001000200020026A70001002E2O01000D0004E23O002E2O012O009F0001000B3O0020DC00010001001100122O000300123O00122O000400066O00010004000200062O0001003O013O0004E23O003O012O009F0001000B3O0020DC00010001001100122O000300123O00122O000400066O00010004000200062O000100F700013O0004E23O00F700012O009F0001000C3O0020100001000100132O00BB00010002000200060F000100F7000100010004E23O00F700012O009F0001000C3O0020100001000100142O00BB0001000200020006D80001003O013O0004E23O003O012O009F0001000B3O00201000010001001B2O00BB00010002000200260E0001003O01000D0004E23O003O012O009F0001000B3O00201000010001001C2O00BB0001000200020026A70001002E2O0100050004E23O002E2O012O009F000100013O0020680001000100020020100001000100032O00BB0001000200020006D8000100102O013O0004E23O00102O012O009F000100023O0026870001002F2O0100070004E23O002F2O012O009F000100013O0020680001000100040020100001000100032O00BB00010002000200060F000100302O0100010004E23O00302O012O009F0001000B3O00201000010001001C2O00BB00010002000200260E0001002F2O0100050004E23O002F2O012O009F000100123O00060F000100302O0100010004E23O00302O012O009F0001000B3O00206200010001001D4O000300013O00202O00030003001E4O00010003000200062O000100302O0100010004E23O00302O012O009F000100013O00206800010001000B0020100001000100092O00BB0001000200020026A7000100282O01001F0004E23O00282O012O009F000100083O000E210005002F2O0100010004E23O002F2O012O009F000100053O00060F0001002E2O0100010004E23O002E2O012O009F000100083O000E1E0006002F2O0100010004E23O002F2O012O007A00016O0060000100014O00E1000100113O0004E23O007A2O0100266F3O00010001000A0004E23O000100012O009F000100013O00206800010001000B0020100001000100092O00BB0001000200020026A7000100462O01001F0004E23O00462O012O009F000100083O0026E8000100462O0100060004E23O00462O012O009F000100013O00206800010001000E0020100001000100092O00BB000100020002000E2A001F00462O0100010004E23O00462O010012082O0100203O00060F000100472O0100010004E23O00472O010012082O0100074O00E1000100064O009F000100123O00060F0001006B2O0100010004E23O006B2O012O009F000100013O0020680001000100210020100001000100032O00BB0001000200020006D80001006B2O013O0004E23O006B2O012O009F0001000B3O00205500010001001D4O000300013O00202O0003000300224O00010003000200062O0001006B2O013O0004E23O006B2O012O009F0001000B3O0020140001000100234O000300013O00202O0003000300224O0001000300024O0002000B3O00202O0002000200244O00020002000200102O0002001500024O000100010002000E2O000A006B2O0100010004E23O006B2O012O009F000100083O000E1E000A00682O0100010004E23O00682O012O007A00016O0060000100014O00E1000100073O0004E23O00782O012O009F000100084O00EC000200136O000300013O00202O00030003002500202O0003000300034O000300046O00023O000200102O00020005000200062O00020002000100010004E23O00762O012O007A00016O0060000100014O00E1000100073O001208012O00073O0004E23O000100012O00463O00017O00393O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O002519A903073O00B74476CC8151902O033O000DA96303063O00E26ECD10846B027O00402O033O00E4CCE303053O00218BA380B903163O00476574456E656D696573496E4D656C2O6552616E6765026O002040030F3O00466573746572696E67537472696B65026O000840026O001040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D62617403103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E73030B3O004761726752656D61696E73030B3O00446562752O66537461636B03143O00466573746572696E67576F756E64446562752O66030A3O0041706F63616C7970736503113O0054696D6553696E63654C61737443617374026O002E40030D3O0041726D796F6674686544656164026O003E40030A3O0047617267416374697665030F3O00432O6F6C646F776E52656D61696E73026O00244003083O0042752O66446F776E03113O004465617468416E64446563617942752O6603063O0042752O665570030B3O004465617468537472696B6503073O004973526561647903053O005072652O73031B3O00535D05CA5F6717CA45510FDB17540BC91750149E584A44CE45570703043O00BE37386403083O004F7574627265616B030E3O0049735370652O6C496E52616E676503153O0059BA281C01E6F25DEF330B07DCFC50902E1F1DE4F603073O009336CF5C7E738303083O0045706964656D696303143O00566972756C656E74506C61677565446562752O66030F3O0041757261416374697665436F756E7403093O004973496E52616E676503153O0008213C79087304327572186A323E33421F7F03363003063O001E6D51551D6D03093O004465617468436F696C03173O00FB7455A23EE1FFF07858F639CBE8C07E528924DFF2F87403073O009C9F1134D656BE031C3O00A8EAAEA8ABFDB4B2A9D0AEA8BCE6B6B9EEFFAFB9ADE0B0BEAFFBFDE403043O00DCCE8FDD03173O00476574456E656D696573496E53706C61736852616E6765031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74003F022O001208012O00013O00266F3O0014000100020004E23O00140001001235000100033O00206C0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00124O00093O00266F3O0021000100010004E23O002100012O009F000100034O009C00010001000100122O000100033O00202O0001000100044O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100043O00124O00023O000ECA0009002F00013O0004E23O002F00012O009F000100064O00610001000100024O000100016O000100056O000100083O00202O00010001000C00122O0003000D6O000400093O00202O00040004000E4O0001000400024O000100073O00124O000F3O00266F3O001B020100100004E23O001B02012O009F0001000A3O0020680001000100112O005A00010001000200060F0001003B000100010004E23O003B00012O009F000100083O0020100001000100122O00BB0001000200020006D80001009400013O0004E23O009400010012082O0100013O00266F0001004E000100010004E23O004E00012O009F0002000C3O0020A40002000200134O0002000100024O0002000B6O0002000B6O0002000D6O0002000D3O00262O0002004D000100140004E23O004D00012O009F0002000C3O00206B0002000200154O000300076O00048O0002000400024O0002000D3O0012082O0100023O000ECA000F005B000100010004E23O005B00012O009F0002000F3O0020C40002000200164O0002000200024O0002000E6O000200113O00202O0002000200174O000400093O00202O0004000400184O0002000400024O000200103O00044O0094000100266F00010077000100020004E23O007700012O009F000200134O0045000300146O0002000200024O000200126O000200093O00202O00020002001900202O00020002001A4O00020002000200262O000200680001001B0004E23O006800012O007A00026O0060000200014O00E1000200154O009F000200153O0006D80002007400013O0004E23O007400012O009F000200093O00208C00020002001900202O00020002001A4O00020002000200102O0002001B000200062O00020075000100010004E23O00750001001208010200014O00E1000200163O0012082O0100093O00266F0001003C000100090004E23O003C00012O009F000200093O00206800020002001C00201000020002001A2O00BB00020002000200262O000200800001001D0004E23O008000012O007A00026O0060000200014O00E1000200174O009F000200173O0006D80002008C00013O0004E23O008C00012O009F000200093O00208C00020002001C00202O00020002001A4O00020002000200102O0002001D000200062O0002008D000100010004E23O008D0001001208010200014O00E1000200184O00630002000F3O00202O00020002001E4O0002000200024O000200193O00122O0001000F3O00044O003C00012O009F0001000A3O0020680001000100112O005A0001000100020006D80001003E02013O0004E23O003E02010012082O0100014O0007000200023O000ECA000900D1000100010004E23O00D100012O009F0003001A3O0006D8000300AC00013O0004E23O00AC0001001208010300014O0007000400043O000ECA000100A2000100030004E23O00A200012O009F0005001B4O005A0005000100022O00B1000400053O0006D8000400AC00013O0004E23O00AC00012O0002010400023O0004E23O00AC00010004E23O00A200012O009F000300023O0006D8000300BE00013O0004E23O00BE00012O009F0003001C3O00060F000300BE000100010004E23O00BE0001001208010300014O0007000400043O00266F000300B4000100010004E23O00B400012O009F0005001D4O005A0005000100022O00B1000400053O0006D8000400BE00013O0004E23O00BE00012O0002010400023O0004E23O00BE00010004E23O00B400012O009F000300023O0006D8000300D000013O0004E23O00D000012O009F0003001E3O0006D8000300D000013O0004E23O00D00001001208010300014O0007000400043O00266F000300C6000100010004E23O00C600012O009F0005001F4O005A0005000100022O00B1000400053O0006D8000400D000013O0004E23O00D000012O0002010400023O0004E23O00D000010004E23O00C600010012082O01000F3O00266F000100522O01000F0004E23O00522O012O009F00035O0006D8000300E800013O0004E23O00E800012O009F000300023O0006D8000300E800013O0004E23O00E800012O009F000300203O0006D8000300E800013O0004E23O00E80001001208010300014O0007000400043O000ECA000100DE000100030004E23O00DE00012O009F000500214O005A0005000100022O00B1000400053O0006D8000400E800013O0004E23O00E800012O0002010400023O0004E23O00E800010004E23O00DE00012O009F000300023O0006D8000300F700013O0004E23O00F70001001208010300014O0007000400043O00266F000300ED000100010004E23O00ED00012O009F000500224O005A0005000100022O00B1000400053O0006D8000400F700013O0004E23O00F700012O0002010400023O0004E23O00F700010004E23O00ED00012O009F00035O0006D8000300512O013O0004E23O00512O01001208010300013O00266F0003002F2O0100010004E23O002F2O012O009F000400203O0006D8000400182O013O0004E23O00182O012O009F000400233O00201000040004001F2O00BB0004000200020026A7000400182O0100200004E23O00182O012O009F000400083O0020550004000400214O000600093O00202O0006000600224O00040006000200062O000400182O013O0004E23O00182O01001208010400014O0007000500053O00266F0004000E2O0100010004E23O000E2O012O009F000600244O005A0006000100022O00B1000500063O0006D8000500182O013O0004E23O00182O012O0002010500023O0004E23O00182O010004E23O000E2O012O009F000400253O000ED30010002E2O0100040004E23O002E2O012O009F000400083O0020550004000400234O000600093O00202O0006000600224O00040006000200062O0004002E2O013O0004E23O002E2O01001208010400014O0007000500053O00266F000400242O0100010004E23O00242O012O009F000600264O005A0006000100022O00B1000500063O0006D80005002E2O013O0004E23O002E2O012O0002010500023O0004E23O002E2O010004E23O00242O01001208010300023O00266F000300FB000100020004E23O00FB00012O009F000400253O000ED3001000512O0100040004E23O00512O012O009F000400233O00201000040004001F2O00BB000400020002000E2A002000402O0100040004E23O00402O012O009F000400083O0020620004000400214O000600093O00202O0006000600224O00040006000200062O000400432O0100010004E23O00432O012O009F000400203O00060F000400512O0100010004E23O00512O01001208010400014O0007000500053O00266F000400452O0100010004E23O00452O012O009F000600274O005A0006000100022O00B1000500063O0006D8000500512O013O0004E23O00512O012O0002010500023O0004E23O00512O010004E23O00452O010004E23O00512O010004E23O00FB00010012082O0100103O000ECA000100E92O0100010004E23O00E92O012O009F000300083O0020100003000300122O00BB00030002000200060F000300652O0100010004E23O00652O01001208010300014O0007000400043O00266F0003005B2O0100010004E23O005B2O012O009F000500284O005A0005000100022O00B1000400053O0006D8000400652O013O0004E23O00652O012O0002010400023O0004E23O00652O010004E23O005B2O012O009F000300093O0020680003000300240020100003000300252O00BB0003000200020006D80003007A2O013O0004E23O007A2O012O009F000300053O00060F0003007A2O0100010004E23O007A2O012O009F0003000C3O0020430003000300264O000400093O00202O0004000400244O00030002000200062O0003007A2O013O0004E23O007A2O012O009F000300013O001208010400273O001208010500284O00EE000300054O00D900036O009F000300253O00266F000300E82O0100010004E23O00E82O01001208010300013O00266F000300C22O0100010004E23O00C22O012O009F000400093O0020680004000400290020100004000400252O00BB0004000200020006D80004009C2O013O0004E23O009C2O012O009F000400123O000E2A0001009C2O0100040004E23O009C2O012O009F0004000C3O0020400004000400264O000500093O00202O0005000500294O000600076O000800113O00202O00080008002A4O000A00093O00202O000A000A00294O0008000A00024O000800086O00040008000200062O0004009C2O013O0004E23O009C2O012O009F000400013O0012080105002B3O0012080106002C4O00EE000400064O00D900046O009F000400093O00206800040004002D0020100004000400252O00BB0004000200020006D8000400C12O013O0004E23O00C12O012O009F00045O0006D8000400C12O013O0004E23O00C12O012O009F000400093O00206800040004002E00201000040004002F2O00BB000400020002000E2A000200C12O0100040004E23O00C12O012O009F000400293O00060F000400C12O0100010004E23O00C12O012O009F0004000C3O00200A0104000400264O000500093O00202O00050005002D4O0006002A6O000700076O000800113O00202O00080008003000122O000A001D6O0008000A00024O000800086O00040008000200062O000400C12O013O0004E23O00C12O012O009F000400013O001208010500313O001208010600324O00EE000400064O00D900045O001208010300023O00266F0003007E2O0100020004E23O007E2O012O009F000400093O0020680004000400330020100004000400252O00BB0004000200020006D8000400E82O013O0004E23O00E82O012O009F000400093O00206800040004002E00201000040004002F2O00BB0004000200020026A7000400E82O0100090004E23O00E82O012O009F000400293O00060F000400E82O0100010004E23O00E82O012O009F0004000C3O0020400004000400264O000500093O00202O0005000500334O000600076O000800113O00202O00080008002A4O000A00093O00202O000A000A00334O0008000A00024O000800086O00040008000200062O000400E82O013O0004E23O00E82O012O009F000400013O0012BA000500343O00122O000600356O000400066O00045O00044O00E82O010004E23O007E2O010012082O0100023O00266F0001000E020100100004E23O000E02012O009F000300253O0026E8000300FA2O01000F0004E23O00FA2O01001208010300014O0007000400043O00266F000300F02O0100010004E23O00F02O012O009F0005002B4O005A0005000100022O00B1000400053O0006D8000400FA2O013O0004E23O00FA2O012O0002010400023O0004E23O00FA2O010004E23O00F02O012O009F000300093O00206800030003000E0020100003000300252O00BB0003000200020006D80003003E02013O0004E23O003E02012O009F0003000C3O0020230003000300264O000400093O00202O00040004000E4O000500066O00030006000200062O0003003E02013O0004E23O003E02012O009F000300013O0012BA000400363O00122O000500376O000300056O00035O00044O003E020100266F0001009B000100020004E23O009B00012O009F0003002C4O00730003000100014O0003002D6O0003000100024O000200033O00062O0002001802013O0004E23O001802012O0002010200023O0012082O0100093O0004E23O009B00010004E23O003E0201000ECA000F000100013O0004E23O000100012O009F000100113O00202600010001003800122O000300206O0001000300024O000100146O00015O00062O0001003302013O0004E23O003302010012082O0100013O00266F00010026020100010004E23O002602012O009F000200074O0025000200026O000200256O000200113O00202O00020002003900122O000400206O0002000400024O0002002E3O00044O003C02010004E23O002602010004E23O003C02010012082O0100013O00266F00010034020100010004E23O00340201001208010200024O00E1000200253O001208010200024O00E10002002E3O0004E23O003C02010004E23O00340201001208012O00103O0004E23O000100012O00463O00017O00083O00028O00026O00F03F03053O005072696E74032A3O00B3732518D4D592A2566D15C18CF796742E5998FBDD94766D1ED68CE294722A05DDDFC1C65A221DD1DED303073O00B2E61D4D77B8AC03143O00566972756C656E74506C61677565446562752O6603143O00526567697374657241757261547261636B696E6703143O00466573746572696E67576F756E64446562752O6600183O001208012O00013O00266F3O000B000100020004E23O000B00012O009F00015O00203F0001000100034O000200013O00122O000300043O00122O000400056O000200046O00013O000100044O00170001000ECA0001000100013O0004E23O000100012O009F000100023O0020F000010001000600202O0001000100074O0001000200014O000100023O00202O00010001000800202O0001000100074O00010002000100124O00023O00044O000100012O00463O00017O00", GetFEnv(), ...);
