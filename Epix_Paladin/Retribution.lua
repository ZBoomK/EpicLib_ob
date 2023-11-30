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
										elseif (Enum == 2) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 7) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									elseif (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum == 9) then
											if (Inst[2] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											do
												return Stk[Inst[2]]();
											end
										end
									elseif (Enum == 11) then
										if (Inst[2] ~= Inst[4]) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 14) then
									if (Enum == 13) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 15) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 16) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								end
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum > 18) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 20) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Stk[Inst[4]]];
									end
								elseif (Enum <= 23) then
									if (Enum > 22) then
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
										if not Stk[Inst[2]] then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 25) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								else
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum == 27) then
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
								elseif (Enum <= 29) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum == 30) then
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
								end
							elseif (Enum <= 33) then
								if (Enum == 32) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 34) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 35) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum == 37) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
										elseif (Inst[2] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 39) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 42) then
									if (Enum > 41) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									end
								elseif (Enum <= 43) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 44) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 50) then
								if (Enum <= 47) then
									if (Enum > 46) then
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
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
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
									end
								elseif (Enum <= 48) then
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 49) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 52) then
								if (Enum > 51) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 53) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum > 54) then
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
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum > 56) then
										Stk[Inst[2]] = not Stk[Inst[3]];
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
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 61) then
								if (Enum == 60) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									do
										return;
									end
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							elseif (Enum > 63) then
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
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
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum > 65) then
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
									if (Inst[2] < Stk[Inst[4]]) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 68) then
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
						elseif (Enum <= 71) then
							if (Enum == 70) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							VIP = Inst[3];
						elseif (Enum == 73) then
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 111) then
						if (Enum <= 92) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum > 75) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 77) then
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
								elseif (Enum <= 80) then
									if (Enum > 79) then
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
								elseif (Enum <= 81) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 82) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 87) then
								if (Enum <= 85) then
									if (Enum == 84) then
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
								elseif (Enum == 86) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 89) then
								if (Enum > 88) then
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
							elseif (Enum <= 90) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 91) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
									if (Enum == 93) then
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
											if (Mvm[1] == 55) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
									else
										Stk[Inst[2]] = {};
									end
								elseif (Enum == 95) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 98) then
								if (Enum > 97) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								elseif (Inst[2] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 99) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 106) then
							if (Enum <= 103) then
								if (Enum == 102) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 104) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum > 105) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 108) then
							if (Enum == 107) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 109) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 110) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 120) then
							if (Enum <= 115) then
								if (Enum <= 113) then
									if (Enum == 112) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 114) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A] = Stk[A]();
								end
							elseif (Enum <= 117) then
								if (Enum == 116) then
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
							elseif (Enum <= 118) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							end
						elseif (Enum <= 125) then
							if (Enum <= 122) then
								if (Enum == 121) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 123) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 124) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 127) then
							if (Enum == 126) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 128) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						elseif (Enum > 129) then
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
							if not Stk[Inst[2]] then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum > 133) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 136) then
							if (Enum == 135) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 137) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 138) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						end
					elseif (Enum <= 144) then
						if (Enum <= 141) then
							if (Enum > 140) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 142) then
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
						elseif (Enum > 143) then
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Inst[2] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 146) then
						if (Enum == 145) then
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 148) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										end
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
								elseif (Enum <= 155) then
									if (Enum == 154) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 156) then
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
									Stk[Inst[2]] = {};
								elseif (Enum == 157) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								end
							elseif (Enum <= 162) then
								if (Enum <= 160) then
									if (Enum == 159) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 161) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 164) then
								if (Enum > 163) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 165) then
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
							elseif (Enum == 166) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 176) then
							if (Enum <= 171) then
								if (Enum <= 169) then
									if (Enum == 168) then
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
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum == 170) then
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
							elseif (Enum <= 173) then
								if (Enum > 172) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 174) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 181) then
							if (Enum <= 178) then
								if (Enum == 177) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 179) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 180) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 183) then
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
						elseif (Enum <= 184) then
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
					elseif (Enum <= 205) then
						if (Enum <= 195) then
							if (Enum <= 190) then
								if (Enum <= 188) then
									if (Enum > 187) then
										local B = Stk[Inst[4]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 192) then
								if (Enum > 191) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 194) then
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
								if (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 200) then
							if (Enum <= 197) then
								if (Enum == 196) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 198) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 199) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 204) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 214) then
						if (Enum <= 209) then
							if (Enum <= 207) then
								if (Enum == 206) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum == 208) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 211) then
							if (Enum > 210) then
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
						elseif (Enum <= 212) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 213) then
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
							if not Stk[Inst[2]] then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 217) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 218) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 221) then
						if (Enum == 220) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
					if (Enum <= 242) then
						if (Enum <= 233) then
							if (Enum <= 228) then
								if (Enum <= 226) then
									if (Enum == 225) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 227) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 230) then
								if (Enum == 229) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 231) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 232) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum <= 235) then
								if (Enum == 234) then
									local A;
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
									Stk[Inst[2]] = Inst[3];
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
									Stk[A] = Stk[A]();
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 236) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 239) then
							if (Enum == 238) then
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
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 240) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 241) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
						end
					elseif (Enum <= 251) then
						if (Enum <= 246) then
							if (Enum <= 244) then
								if (Enum == 243) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 245) then
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
						elseif (Enum <= 248) then
							if (Enum > 247) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 249) then
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
						elseif (Enum > 250) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 256) then
						if (Enum <= 253) then
							if (Enum > 252) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							end
						elseif (Enum <= 254) then
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
						elseif (Enum > 255) then
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
					elseif (Enum <= 258) then
						if (Enum > 257) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 259) then
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
					elseif (Enum == 260) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
					end
				elseif (Enum <= 280) then
					if (Enum <= 270) then
						if (Enum <= 265) then
							if (Enum <= 263) then
								if (Enum > 262) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 264) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 267) then
							if (Enum == 266) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 268) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						elseif (Enum > 269) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 275) then
						if (Enum <= 272) then
							if (Enum > 271) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 273) then
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
						elseif (Enum > 274) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 277) then
						if (Enum > 276) then
							if (Inst[2] < Inst[4]) then
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
					elseif (Enum <= 278) then
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
				elseif (Enum <= 289) then
					if (Enum <= 284) then
						if (Enum <= 282) then
							if (Enum == 281) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum > 283) then
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
						elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 286) then
						if (Enum == 285) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 287) then
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
					elseif (Enum > 288) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					end
				elseif (Enum <= 294) then
					if (Enum <= 291) then
						if (Enum == 290) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 296) then
					if (Enum > 295) then
						if (Stk[Inst[2]] < Inst[4]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
						Stk[Inst[2]] = Env;
					else
						Stk[Inst[2]] = Env[Inst[3]];
					end
				elseif (Enum <= 297) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
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
				elseif (Enum > 298) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD98BC612D0C7D22BD989C20AC3CAD930F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O0030B2F6000425A3F3193F1CACC02A3E01B0F61A2E01ABF0167519B7FE03053O005B75C29F78002E3O0012C93O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004483O000A0001001227010300063O002016010400030007001227010500083O002016010500050009001227010600083O00201601060006000A00065D00073O000100062O00373O00064O00378O00373O00044O00373O00014O00373O00024O00373O00053O00201601080003000B00201601090003000C2O005E000A5O001227010B000D3O00065D000C0001000100022O00373O000A4O00373O000B4O0037000D00073O00124D000E000E3O00124D000F000F4O0008000D000F000200065D000E0002000100032O00373O00074O00373O00094O00373O00084O001C010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001F01025O00122O000300016O00045O00122O000500013O00042O0003002100012O000501076O0012010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004790003000500012O0005010300054O0037000400024O0019000300044O001A00036O003D3O00017O001C3O00028O00026O00F03F025O008C9840025O008CAE40025O00C49640025O00549F40025O0069B040025O00CCA040025O0042AF40025O00ACAD40025O0050B240025O0093B140025O0008A840025O003AB240025O007C9840025O00F07340025O00E7B140025O0062AD40025O00AC9F40025O00ACA740025O005AA940025O00DCAB40025O00FCAA40025O00B09840025O001C9940026O003440025O0086A440025O00D0774001603O00124D000200014O008A000300053O00266B00020007000100010004483O0007000100124D000300014O008A000400043O00124D000200023O0026490002000B000100020004483O000B0001002E7200040002000100030004483O000200012O008A000500053O00264900030012000100020004483O00120001002E6100060012000100050004483O00120001002E7200070049000100080004483O0049000100124D000600013O002E26000A0013000100090004483O0013000100266B00060013000100010004483O001300010026490004001B000100010004483O001B0001002E26000B003D0001000C0004483O003D000100124D000700013O00264900070020000100020004483O00200001002E26000E00220001000D0004483O0022000100124D000400023O0004483O003D0001000E7F00010026000100070004483O00260001002E26000F001C000100100004483O001C000100124D000800013O0026490008002D000100020004483O002D0001002E0B0011002D000100120004483O002D0001002E260014002F000100130004483O002F000100124D000700023O0004483O001C0001000EE200010027000100080004483O002700012O000501096O0097000500093O0006570005003A000100010004483O003A00012O0005010900014O0037000A6O0040000B6O003500096O001A00095O00124D000800023O0004483O002700010004483O001C0001002E2600150012000100160004483O0012000100266B00040012000100020004483O001200012O0037000700054O004000086O003500076O001A00075O0004483O001200010004483O001300010004483O001200010004483O005F0001002E720018000C000100170004483O000C000100266B0003000C000100010004483O000C000100124D000600013O00266B00060053000100010004483O0053000100124D000400014O008A000500053O00124D000600023O00264900060059000100020004483O00590001002E0B001900590001001A0004483O00590001002E26001B004E0001001C0004483O004E000100124D000300023O0004483O000C00010004483O004E00010004483O000C00010004483O005F00010004483O000200012O003D3O00017O004A3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203053O008D2B13236003073O009BCB44705613C503063O0076D137E5456A03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203043O0020B3853303053O00B962DAEB5703053O00E63D24F4D103063O00CAAB5C4786BE03053O0019D3299B3A03043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903043O006D6174682O033O00C5272E03073O009CA84E40E0D4792O033O000AEFBD03043O00AE678EC503073O00752752352A50EB03073O009836483F58453E03083O00F1D2EB4ECDCBE05903043O003CB4A48E03073O00685F092823E41C03073O0072383E6549478D030B3O008AECCFD6B1EBCED0B1E6D503043O00A4D889BB03073O00E2E73DB3A2F70503073O006BB28651D2C69E030B3O000A0B96D4A33A1B96CFA53603053O00CA586EE2A603103O005265676973746572466F724576656E7403243O00A00FF93BD1A413FD3EC6B809FF2DD4B109EE3BC6AD05F733D3A803E32DC4A90DE335C2A503053O0087E14CAD7203073O002AECB4B1A8B4A903073O00C77A8DD8D0CCDD030B3O009FD804E271F4B8C919FF7603063O0096CDBD709018024O0080B3C540028O0003143O0015A89E7521BA2E2200A39A623BAD3F3107A89A6803083O007045E4DF2C64E87103063O0053657441504C025O0080514003063O004F6E496E697400BE013O002A2O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0006000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0014000F00142O000901155O00122O001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400152O000901155O00122O001600263O00122O001700276O0015001700024O0015000F00154O00165O00122O001700283O00122O001800296O0016001800024O0015001500162O000501165O00124D0017002A3O00122E0018002B6O0016001800024O00150015001600122O0016002C6O00175O00122O0018002D3O00122O0019002E6O0017001900024O00160016001700122O0017002C4O000501185O0012AA0019002F3O00122O001A00306O0018001A00024O0017001700184O001800186O00198O001A8O001B8O001C8O001D00584O000901595O00122O005A00313O00122O005B00326O0059005B00024O0059000F00594O005A5O00122O005B00333O00122O005C00346O005A005C00024O00590059005A2O0009015A5O00122O005B00353O00122O005C00366O005A005C00024O005A000D005A4O005B5O00122O005C00373O00122O005D00386O005B005D00024O005A005A005B2O0009015B5O00122O005C00393O00122O005D003A6O005B005D00024O005B000E005B4O005C5O00122O005D003B3O00122O005E003C6O005C005E00024O005B005B005C2O005E005C5O00065D005D3O000100042O00373O005A4O0005017O00373O00594O00373O00073O0020D0005E0004003D00065D00600001000100012O00373O005D4O00F300615O00122O0062003E3O00122O0063003F6O006100636O005E3O00012O0009015E5O00122O005F00403O00122O006000416O005E006000024O005E0012005E4O005F5O00122O006000423O00122O006100436O005F006100024O005E005E005F2O008A005F00603O00124D006100443O00124D006200444O008A006300633O00124D006400453O00124D006500454O008A006600663O0020D000670004003D00065D00690002000100022O00373O00614O00373O00624O00F3006A5O00122O006B00463O00122O006C00476O006A006C6O00673O000100065D00670003000100042O00373O00094O00373O00164O00373O005A4O0005016O00065D00680004000100022O00373O00094O00373O005A3O00065D00690005000100062O00373O005A4O0005017O00373O001C4O00373O00594O00373O00134O00373O005E3O00065D006A0006000100062O00373O00564O00373O00094O00373O00574O00373O005A4O0005017O00373O00133O00065D006B00070001000E2O00373O00084O00373O005A4O0005017O00373O00394O00373O00404O00373O00134O00373O005E4O00373O00384O00373O003F4O00373O003B4O00373O00094O00373O00424O00373O003A4O00373O00413O00065D006C0008000100042O00373O00184O00373O00594O00373O005C4O00373O001B3O00065D006D00090001000E2O00373O005A4O0005017O00373O001D4O00373O00134O00373O000B4O00373O00254O00373O002E4O00373O001B4O00373O00324O00373O00264O00373O00644O00373O002A4O00373O00244O00373O001F3O00065D006E000A0001001C2O00373O00594O00373O00094O00373O005A4O00373O00624O00373O004D4O00373O001B4O00373O004E4O00373O000B4O00373O00184O00373O006C4O0005017O00373O002E4O00373O00324O00373O00134O00373O00234O00373O00644O00373O00044O00373O002B4O00373O002F4O00373O002C4O00373O00304O00373O002D4O00373O00314O00373O00634O00373O00584O00373O005E4O00373O004F4O00373O00503O00065D006F000B0001000B2O00373O005A4O0005017O00373O002A4O00373O00654O00373O00094O00373O00134O00373O000B4O00373O00664O00373O00604O00373O00214O00373O00263O00065D0070000C0001001B2O00373O00644O00373O00094O00373O005A4O0005017O00373O000B4O00373O00184O00373O006F4O00373O00294O00373O00624O00373O00134O00373O001D4O00373O00224O00373O001F4O00373O00654O00373O00274O00373O00244O00373O00604O0005012O00014O0005012O00024O00373O00254O00373O001E4O00373O00204O00373O00504O00373O001B4O00373O004F4O00373O004C4O00373O00283O00065D0071000D000100172O00373O001D4O0005017O00373O001E4O00373O001F4O00373O00324O00373O002C4O00373O002D4O00373O002E4O00373O00284O00373O00264O00373O00274O00373O00254O00373O00234O00373O00244O00373O00314O00373O002F4O00373O00304O00373O00224O00373O00204O00373O00214O00373O002B4O00373O00294O00373O002A3O00065D0072000E000100142O00373O00394O0005017O00373O003A4O00373O003B4O00373O00584O00373O00414O00373O003F4O00373O00404O00373O00334O00373O00344O00373O00354O00373O00424O00373O00434O00373O00444O00373O00384O00373O00364O00373O00374O00373O003C4O00373O003D4O00373O003E3O00065D0073000F000100142O00373O00484O0005017O00373O00564O00373O00574O00373O004E4O00373O00504O00373O00524O00373O00514O00373O00464O00373O00454O00373O004D4O00373O004F4O00373O00554O00373O00474O00373O00544O00373O00534O00373O004A4O00373O004B4O00373O004C4O00373O00493O00065D00740010000100322O00373O00094O00373O005A4O0005017O00373O00684O00373O00134O00373O000B4O00373O000A4O00373O005E4O00373O00594O00373O00624O00373O00044O00373O005F4O00373O00654O00373O00614O00373O00644O00373O00474O00373O00434O00373O00444O00373O00484O00373O006A4O00373O000D4O00373O00084O00373O00634O00373O00674O00373O001C4O00373O001A4O00373O001B4O00373O00604O00373O00464O00373O00194O00373O006D4O00373O00354O00373O003C4O00373O005B4O00373O00524O00373O00544O00373O00704O00373O00514O00373O00534O00373O00554O00373O004C4O00373O006E4O00373O003E4O00373O00364O00373O003D4O00373O00724O00373O00714O00373O00734O00373O00694O00373O006B3O00065D00750011000100032O00373O000F4O0005017O00373O005D3O00202F0076000F004800122O007700496O007800743O00122O0079004A6O0076007900016O00013O00123O000A3O00025O00B07140025O00C0B140030D3O00E00387F6C4D00AB6F8D2CA019103053O00AAA36FE297030B3O004973417661696C61626C6503123O003539A1284B3B251032BE3D6A322B0436B42B03073O00497150D2582E57030A3O004D657267655461626C6503193O0044697370652O6C61626C6544697365617365446562752O667303183O0044697370652O6C61626C65506F69736F6E446562752O6673001A3O002E7200010019000100020004483O001900012O0005017O0034000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O001900013O0004483O001900012O0005012O00024O005B000100013O00122O000200063O00122O000300076O0001000300024O000200033O00202O0002000200084O000300023O00202O0003000300094O000400023O00202O00040004000A4O0002000400026O000100022O003D3O00019O003O00034O0005017O00503O000100012O003D3O00017O00043O00028O00025O00108E40025O003AB240024O0080B3C54000123O00124D3O00014O008A000100013O00266B3O0002000100010004483O0002000100124D000100013O00264900010009000100010004483O00090001002E2600030005000100020004483O0005000100124D000200044O00CE00025O00124D000200044O00CE000200013O0004483O001100010004483O000500010004483O001100010004483O000200012O003D3O00017O002A3O00028O00025O00A09D40025O00B09A40025O00508340025O00D8AD40026O00F03F025O00BFB040026O005F40025O0012A440025O009CAE40025O0022AF40025O00109440025O00A4A840025O00B89F40030A3O0047434452656D61696E73030E3O00F70D12C0B77883C62C13C1BF778303073O00E6B47F67B3D61C030F3O00432O6F6C646F776E52656D61696E73030E3O00AE095E42E14EE6A6104C52ED42E503073O0080EC653F26842103083O0086BC1543BBEEC1B803073O00AFCCC97124D68B030D3O006FCD38D10155C333EB1646D83D03053O006427AC55BC03083O004973557361626C65030D3O008579B48D36BF77BFB721AC6CB103053O0053CD18D9E0026O002440030B3O00D1C4C638E9C3EC2EEEC0DE03043O005D86A5AD025O0062AD40025O00508540025O002OA040025O00208A40025O000C9F40025O00088140025O0072A240025O009C9040025O0020B340025O00B49340025O00F89B40025O002AA940008B3O00124D3O00014O008A000100033O0026493O0006000100010004483O00060001002E0700020011000100030004483O0015000100124D000400013O002E720004000E000100050004483O000E000100266B0004000E000100010004483O000E000100124D000100014O008A000200023O00124D000400063O002E2600080007000100070004483O0007000100266B00040007000100060004483O0007000100124D3O00063O0004483O001500010004483O0007000100266B3O0002000100060004483O000200012O008A000300033O00124D000400013O00266B00040019000100010004483O00190001002E26000900680001000A0004483O00680001002E26000C00680001000B0004483O0068000100266B00010068000100010004483O0068000100124D000500013O000E7F00060026000100050004483O00260001002E26000D00280001000E0004483O0028000100124D000100063O0004483O0068000100266B00050022000100010004483O002200012O000501065O00200400060006000F4O0006000200024O000200066O000600016O000700026O000800033O00122O000900103O00122O000A00116O0008000A00024O0007000700080020D00007000700122O00690007000200024O000800026O000900033O00122O000A00133O00122O000B00146O0009000B00024O00080008000900202O0008000800124O0008000200024O000900024O0005010A00033O00129E000B00153O00122O000C00166O000A000C00024O00090009000A00202O0009000900124O0009000200024O000A00024O0034000B00033O00122O000C00173O00122O000D00186O000B000D00024O000A000A000B00202O000A000A00194O000A0002000200062O000A005B00013O0004483O005B00012O0005010A00024O00C1000B00033O00122O000C001A3O00122O000D001B6O000B000D00024O000A000A000B00202O000A000A00124O000A0002000200062O000A005C000100010004483O005C000100124D000A001C4O0005010B00024O002B000C00033O00122O000D001D3O00122O000E001E6O000C000E00024O000B000B000C00202O000B000B00124O000B000C6O00063O00024O000300063O00122O000500063O0004483O002200010026490001006C000100060004483O006C0001002E26001F0018000100200004483O0018000100124D000500014O008A000600063O002E720022006E000100210004483O006E0001000E7F00010074000100050004483O00740001002E07002300FCFF2O00240004483O006E000100124D000600013O00264900060079000100010004483O00790001002E2600250075000100260004483O0075000100065900020007000100030004483O00810001002E1501270081000100280004483O00810001002E26002A0080000100290004483O008000010004483O008100012O00EF000200024O00EF000300023O0004483O007500010004483O001800010004483O006E00010004483O001800010004483O001900010004483O001800010004483O008A00010004483O000200012O003D3O00017O00053O0003083O0042752O66446F776E030F3O005265747269627574696F6E41757261030C3O004465766F74696F6E4175726103113O00436F6E63656E74726174696F6E41757261030C3O00437275736164657241757261001C4O00C07O00206O00014O000200013O00202O0002000200026O0002000200064O001A00013O0004483O001A00012O0005016O0020275O00014O000200013O00202O0002000200036O0002000200064O001A00013O0004483O001A00012O0005016O0020275O00014O000200013O00202O0002000200046O0002000200064O001A00013O0004483O001A00012O0005016O0020D05O00012O0005010200013O0020160102000200052O00083O000200022O00EF3O00024O003D3O00017O000A3O00026O003740025O0034AC40030D3O009DFEC4C334DDB74AB1EAC8CC2903083O001EDE92A1A25AAED203073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00394003123O00436C65616E7365546F78696E73466F63757303153O00E642750BEB5D7535F65E7918EC5A300EEC5D600FE903043O006A852E1000213O002E7200010020000100020004483O002000012O0005017O0034000100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O002000013O0004483O002000012O0005012O00023O0006303O002000013O0004483O002000012O0005012O00033O002016014O000600124D000100074O00DC3O000200020006303O002000013O0004483O002000012O0005012O00044O00052O0100053O0020162O01000100082O00DC3O000200020006303O002000013O0004483O002000012O0005012O00013O00124D000100093O00124D0002000A4O00193O00024O001A8O003D3O00017O000F3O00025O006BB140025O0016AE4003103O004865616C746850657263656E74616765025O008EAE40025O0024A440030C3O007E2C72EF524F5E0C7AFB525403063O00203840139C3A03073O0049735265616479025O0032A740025O00109D40030C3O00466C6173686F664C69676874025O008EB040025O00C0554003173O005CC4E44552CD8F5CF7E95F5DFA941AC0E05756B28F55CB03073O00E03AA885363A9200273O002E2600020026000100010004483O002600012O0005016O0006303O000B00013O0004483O000B00012O0005012O00013O0020D05O00032O00DC3O000200022O00052O0100023O0006593O0003000100010004483O000D0001002E7200040026000100050004483O002600012O0005012O00034O00C1000100043O00122O000200063O00122O000300076O0001000300028O000100206O00086O0002000200064O0019000100010004483O00190001002E26000900260001000A0004483O002600012O0005012O00054O00052O0100033O0020162O010001000B2O00DC3O000200020006573O0021000100010004483O00210001002E72000C00260001000D0004483O002600012O0005012O00043O00124D0001000E3O00124D0002000F4O00193O00024O001A8O003D3O00017O004C3O00028O0003063O0045786973747303093O004973496E52616E6765026O003E40025O0096A040025O00804340025O00D4A340025O001AB040025O00A8A040025O00206940025O0086A240025O00BCA440025O00F2B040025O007DB140026O00F03F025O0014AB40025O00A8B140025O00B88D40025O000C9040025O00109B40025O00B2AB40025O00949140026O005040030B3O006E2O59F97A80A00756445203083O006B39362B9D15E6E703073O004973526561647903103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F637573025O001EA940025O004AAF40031D3O00CC8403F186D3C9E48C1DFAABC58FDF8E17F0B7CFC6CD8E51F3B6DFDAC803073O00AFBBEB7195D9BC030A3O0010AE9843ED517932AB9203073O00185CCFE12C8319030A3O0049734361737461626C65030A3O00446562752O66446F776E03113O00466F7262656172616E6365446562752O66025O00649540025O0094A140025O00DEA240025O00C88440030F3O004C61796F6E48616E6473466F637573025O00488D40025O0094AD40031C3O0047D2A173147374DBB9421F6E0BD7BD4A1E7358DAAE495B7B44D0AD5F03063O001D2BB3D82C7B025O00288C40025O007AB040025O00049140025O003AA140025O00ABB240025O009EAF40025O00C4A040025O00A0834003133O009FD5255FAED02E4BB2DF134DBECB294AB4DA2503043O002CDDB940030A3O00556E69744973556E697403023O004944025O00AEAA40025O0061B14003183O00426C652O73696E676F66536163726966696365466F637573025O00949B40025O00D6B04003253O0003EB4D4C6008E94F607C07D85B5E7013EE4E567004A74C5A7504E95B566504A74E507014F403053O00136187283F025O00508C40026O00694003143O008C5036283C38A05B3C3D1F23A14836383B38A15203063O0051CE3C535B4F025O00A4AF40025O0074954003193O00426C652O73696E676F6650726F74656374696F6E466F637573026O00A840025O00AAA04003263O004CA7D5613CCA43A371A4D64D3FD142B04BA8C47B20CD0DA04BADD57C3CCA5BA10EADDF713AD003083O00C42ECBB0124FA32D00F43O00124D3O00014O008A000100013O00266B3O0002000100010004483O0002000100124D000100013O00266B00010005000100010004483O000500012O000501025O0006300002001700013O0004483O001700012O000501025O0020D00002000200022O00DC0002000200020006300002001700013O0004483O001700012O000501025O0020D000020002000300124D000400044O00080002000400020006300002001700013O0004483O00170001002E0700050003000100060004483O001800012O003D3O00013O002E07000700DB000100070004483O00F300012O000501025O000630000200F300013O0004483O00F3000100124D000200013O002E0700080004000100080004483O0022000100264900020024000100010004483O00240001002E26000900900001000A0004483O0090000100124D000300013O0026490003002B000100010004483O002B0001002E15010C002B0001000B0004483O002B0001002E26000E00870001000D0004483O0087000100124D000400013O002649000400300001000F0004483O00300001002E7200110032000100100004483O0032000100124D0003000F3O0004483O00870001000E7F00010038000100040004483O00380001002E6100130038000100120004483O00380001002E260015002C000100140004483O002C0001002E260017005A000100160004483O005A00012O0005010500014O0034000600023O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005001A4O00050002000200062O0005005A00013O0004483O005A00012O0005010500033O0006300005005A00013O0004483O005A00012O000501055O0020D000050005001B2O00DC0005000200022O0005010600043O00061B0105005A000100060004483O005A00012O0005010500054O0005010600063O00201601060006001C2O00DC00050002000200065700050055000100010004483O00550001002E72001E005A0001001D0004483O005A00012O0005010500023O00124D0006001F3O00124D000700204O0019000500074O001A00056O0005010500014O0034000600023O00122O000700213O00122O000800226O0006000800024O00050005000600202O0005000500234O00050002000200062O0005007400013O0004483O007400012O0005010500073O0006300005007400013O0004483O007400012O000501055O0020270005000500244O000700013O00202O0007000700254O00050007000200062O0005007400013O0004483O007400012O000501055O0020D000050005001B2O00DC0005000200022O0005010600083O00065900050003000100060004483O00760001002E7200270085000100260004483O00850001002E7200290085000100280004483O008500012O0005010500054O0005010600063O00201601060006002A2O00DC00050002000200065700050080000100010004483O00800001002E72002C00850001002B0004483O008500012O0005010500023O00124D0006002D3O00124D0007002E4O0019000500074O001A00055O00124D0004000F3O0004483O002C0001000E7F000F008D000100030004483O008D0001002E150130008D0001002F0004483O008D0001002E7200320025000100310004483O0025000100124D0002000F3O0004483O009000010004483O00250001002E7200340094000100330004483O00940001002649000200960001000F0004483O00960001002E260035001E000100360004483O001E00012O0005010300014O0034000400023O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300234O00030002000200062O000300B300013O0004483O00B300012O0005010300093O000630000300B300013O0004483O00B30001001227010300394O008500045O00202O00040004003A4O0004000200024O0005000A3O00202O00050005003A4O000500066O00033O000200062O000300B3000100010004483O00B300012O000501035O0020D000030003001B2O00DC0003000200022O00050104000B3O00065900030003000100040004483O00B50001002E26003C00C20001003B0004483O00C200012O0005010300054O0005010400063O00201601040004003D2O00DC000300020002000657000300BD000100010004483O00BD0001002E72003F00C20001003E0004483O00C200012O0005010300023O00124D000400403O00124D000500414O0019000300054O001A00035O002E72004300F3000100420004483O00F300012O0005010300014O0034000400023O00122O000500443O00122O000600456O0004000600024O00030003000400202O0003000300234O00030002000200062O000300F300013O0004483O00F300012O00050103000C3O000630000300F300013O0004483O00F300012O000501035O0020270003000300244O000500013O00202O0005000500254O00030005000200062O000300F300013O0004483O00F300012O000501035O0020D000030003001B2O00DC0003000200022O00050104000D3O00061B010300F3000100040004483O00F30001002E72004700E6000100460004483O00E600012O0005010300054O0005010400063O0020160104000400482O00DC000300020002000657000300E8000100010004483O00E80001002E26004900F30001004A0004483O00F300012O0005010300023O00120E0004004B3O00122O0005004C6O000300056O00035O00044O00F300010004483O001E00010004483O00F300010004483O000500010004483O00F300010004483O000200012O003D3O00017O000F3O00028O00025O00408C40025O00E09540026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00349040025O0026B140025O00708640025O002EAE40025O00FC9540025O00FC9D40025O0066A340025O005EA14003103O0048616E646C65546F705472696E6B6574003D3O00124D3O00013O002E2600020015000100030004483O0015000100266B3O0015000100040004483O001500012O00052O0100013O00200F2O01000100054O000200026O000300033O00122O000400066O000500056O0001000500024O00018O00015O00062O00010012000100010004483O00120001002E720008003C000100070004483O003C00012O00052O016O00EF000100023O0004483O003C00010026493O0019000100010004483O00190001002E72000A0001000100090004483O0001000100124D000100013O00266B00010036000100010004483O0036000100124D000200013O002E26000B00210001000C0004483O00210001000E7F00010023000100020004483O00230001002E07000D00100001000E0004483O003100012O0005010300013O0020C800030003000F4O000400026O000500033O00122O000600066O000700076O0003000700024O00038O00035O00062O0003003000013O0004483O003000012O000501036O00EF000300023O00124D000200043O00266B0002001D000100040004483O001D000100124D000100043O0004483O003600010004483O001D000100266B0001001A000100040004483O001A000100124D3O00043O0004483O000100010004483O001A00010004483O000100012O003D3O00017O00623O00028O00025O00F49540025O00E88940025O001AAA40025O002EAE40025O00BCA340025O00D49A40027O0040026O00AE40025O00408F40025O0048AC40025O005CA040030E3O00325A828F8321ABDA05459782852B03083O00907036E3EBE64ECD030A3O0049734361737461626C65025O00EC9A40025O001EA340025O00C8A440025O00D09D40030E3O00426C6164656F664A757374696365030E3O0049735370652O6C496E52616E6765025O00E0A140025O009EA340031C3O00B1240EF8D564BC2E30F6C548A7210CF9904BA12D0CF3DD59B23C4FA903063O003BD3486F9CB003083O006492E72A4382ED3903043O004D2EE783025O00BC9240025O00AEAB40025O0010AC40025O0039B14003083O004A7564676D656E7403143O00B041B247B751B854FA44A445B95BBB42BB40F61603043O0020DA34D6026O00F03F026O000840025O00449940025O008EA940025O00E9B240025O005EA74003113O008B2A771B28FFE0BE147B1023FEEEB6217B03073O008FD8421E7E449B025O001AA840025O0038924003113O00536869656C646F6656656E6765616E6365031F3O00B9C004CEC9A7E8EEACF71BCECBA4D2E0A4CB088BD5B1D2E2A5C50FCAD1E38603083O0081CAA86DABA5C3B7025O008DB140025O0026AC4003123O00084D24CCD717E7304B01DDD013E3235634DD03073O0086423857B8BE74030B3O004973417661696C61626C6503123O0016241AAF10E820272F070CB51EEE203B3F3403083O00555C5169DB798B4103073O0049735265616479026O00104003123O004A757374696361727356656E6765616E636503203O00F7A6434668D6FEB242563CC9F8BD57407DD1FEB610556EDAFEBC5D477DCBBDE103063O00BF9DD330251C025O0036A640025O003EA740025O00149F40025O00C06540025O005EA640025O00D8A340030C3O00F916FA1D36E91AE61833DC0B03053O005ABF7F947C030C3O005E8E201674B12B057C8E2D2O03043O007718E74E030C3O0046696E616C5665726469637403193O008424AB4BD00007873FA143DF5451923FA049D34D138339E51903073O0071E24DC52ABC20030F3O000E13F9A53617E6A60C13E6B13315E003043O00D55A7694025O00206A40025O00D2A040030F3O0054656D706C61727356657264696374031C3O004F2BB946415A3CA7165B5E3CB05F4E4F6EA444485821B9544C4F6EE003053O002D3B4ED436025O00E2A740025O00D6B240030D3O0066163CA5F4A24A5C790530BCF903083O003A2E7751C891D025025O00909F40025O00D89E40025O0050B240025O00449740030D3O0048612O6D65726F665772617468031B3O00238D3DA1ACAF09248A0F2OBBBC2223CC20BEACBE39268E31B8E9EA03073O00564BEC50CCC9DD030E3O0051536296FF8F77534491EC82794403063O00EB122117E59E026O008A40025O00A2B240025O00389E40030E3O004372757361646572537472696B65031D3O0053A8D4A851BEC4A96FA9D5A959B1C4FB40A8C4B85FB7C3BA44FA90E30003043O00DB30DAA10063012O00124D3O00014O008A000100013O002E2600030002000100020004483O0002000100266B3O0002000100010004483O0002000100124D000100013O002E7200040060000100050004483O00600001002E2600070060000100060004483O0060000100266B00010060000100080004483O0060000100124D000200013O002E72000A005B000100090004483O005B000100264900020014000100010004483O00140001002E26000B005B0001000C0004483O005B00012O000501036O0034000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003002100013O0004483O002100012O0005010300023O00065700030025000100010004483O00250001002E6100110025000100100004483O00250001002E7200120038000100130004483O003800012O0005010300034O001801045O00202O0004000400144O000500043O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00030005000200062O00030033000100010004483O00330001002E7200170038000100160004483O003800012O0005010300013O00124D000400183O00124D000500194O0019000300054O001A00036O000501036O0034000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003004500013O0004483O004500012O0005010300053O00065700030049000100010004483O00490001002E15011D00490001001C0004483O00490001002E26001F005A0001001E0004483O005A00012O0005010300034O00D200045O00202O0004000400204O000500043O00202O0005000500154O00075O00202O0007000700204O0005000700024O000500056O00030005000200062O0003005A00013O0004483O005A00012O0005010300013O00124D000400213O00124D000500224O0019000300054O001A00035O00124D000200233O00266B0002000E000100230004483O000E000100124D000100243O0004483O006000010004483O000E0001002E72002500C1000100260004483O00C1000100266B000100C1000100010004483O00C1000100124D000200013O00264900020069000100010004483O00690001002E72002700BA000100280004483O00BA00012O000501036O0034000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003008C00013O0004483O008C00012O0005010300063O0006300003008C00013O0004483O008C00012O0005010300073O0006300003007C00013O0004483O007C00012O0005010300083O0006570003007F000100010004483O007F00012O0005010300083O0006570003008C000100010004483O008C0001002E72002C008C0001002B0004483O008C00012O0005010300034O000501045O00201601040004002D2O00DC0003000200020006300003008C00013O0004483O008C00012O0005010300013O00124D0004002E3O00124D0005002F4O0019000300054O001A00035O002E26003100B9000100300004483O00B900012O000501036O0034000400013O00122O000500323O00122O000600336O0004000600024O00030003000400202O0003000300344O00030002000200062O000300B900013O0004483O00B900012O000501036O0034000400013O00122O000500353O00122O000600366O0004000600024O00030003000400202O0003000300374O00030002000200062O000300B900013O0004483O00B900012O0005010300093O000630000300B900013O0004483O00B900012O00050103000A3O000E09003800B9000100030004483O00B900012O0005010300034O00D200045O00202O0004000400394O000500043O00202O0005000500154O00075O00202O0007000700394O0005000700024O000500056O00030005000200062O000300B900013O0004483O00B900012O0005010300013O00124D0004003A3O00124D0005003B4O0019000300054O001A00035O00124D000200233O002E26003C00650001003D0004483O0065000100266B00020065000100230004483O0065000100124D000100233O0004483O00C100010004483O00650001002649000100C7000100230004483O00C70001002E61003E00C70001003F0004483O00C70001002E26004000162O0100410004483O00162O012O000501026O0034000300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200344O00020002000200062O000200F200013O0004483O00F200012O000501026O0034000300013O00122O000400443O00122O000500456O0003000500024O00020002000300202O0002000200374O00020002000200062O000200F200013O0004483O00F200012O00050102000B3O000630000200F200013O0004483O00F200012O00050102000A3O000E09003800F2000100020004483O00F200012O0005010200034O00D200035O00202O0003000300464O000400043O00202O0004000400154O00065O00202O0006000600464O0004000600024O000400046O00020004000200062O000200F200013O0004483O00F200012O0005010200013O00124D000300473O00124D000400484O0019000200044O001A00026O000501026O0034000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300202O0002000200374O00020002000200062O000200022O013O0004483O00022O012O00050102000B3O000630000200022O013O0004483O00022O012O00050102000A3O000E90003800042O0100020004483O00042O01002E72004C00152O01004B0004483O00152O012O0005010200034O00D200035O00202O00030003004D4O000400043O00202O0004000400154O00065O00202O00060006004D4O0004000600024O000400046O00020004000200062O000200152O013O0004483O00152O012O0005010200013O00124D0003004E3O00124D0004004F4O0019000200044O001A00025O00124D000100083O002E2600500007000100510004483O0007000100266B00010007000100240004483O000700012O000501026O0034000300013O00122O000400523O00122O000500536O0003000500024O00020002000300202O0002000200374O00020002000200062O000200272O013O0004483O00272O012O00050102000C3O0006570002002B2O0100010004483O002B2O01002E0B0054002B2O0100550004483O002B2O01002E720056003C2O0100570004483O003C2O012O0005010200034O00D200035O00202O0003000300584O000400043O00202O0004000400154O00065O00202O0006000600584O0004000600024O000400046O00020004000200062O0002003C2O013O0004483O003C2O012O0005010200013O00124D000300593O00124D0004005A4O0019000200044O001A00026O000501026O0034000300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200492O013O0004483O00492O012O00050102000D3O0006570002004B2O0100010004483O004B2O01002E26005E00622O01005D0004483O00622O01002E07005F00170001005F0004483O00622O012O0005010200034O00D200035O00202O0003000300604O000400043O00202O0004000400154O00065O00202O0006000600604O0004000600024O000400046O00020004000200062O000200622O013O0004483O00622O012O0005010200013O00120E000300613O00122O000400626O000200046O00025O00044O00622O010004483O000700010004483O00622O010004483O000200012O003D3O00017O00B53O00028O00025O00ACB140025O0074A440026O00F03F025O000C9540025O00409540030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003113O004176656E67696E67577261746842752O66030B3O004372757361646542752O6603093O0042752O66537461636B03073O0043727573616465026O002440026O003940025O006DB140025O00E8AB40027O0040025O0046B040025O0049B040026O000840025O001AAD40025O0080554003093O004973496E52616E6765026O002040025O0070A640025O00E07340025O00D6B240025O0020634003113O000453D62C8C5251316DDA2787535F3958DA03073O003E573BBF49E036030A3O0049734361737461626C65026O002E4003113O00C21AFFCAF216F3C6E931FFC7F307F4CAE203043O00A987629A030B3O004973417661696C61626C65030A3O00446562752O66446F776E03113O00457865637574696F6E53656E74656E6365025O00609C40025O00EAA14003113O00536869656C646F6656656E6765616E6365025O000EA640025O001AA94003203O00D87F2D51F137F7C4711B42F83DCFCE762A57F873CBC4782850F224C6D837750403073O00A8AB1744349D53025O005EB240025O00AAA040025O00C08140025O0068B040026O001040025O00BDB040025O00649540025O0080AB40025O002EB340025O000EAA40025O0002A940025O0034A640025O0001B14003113O00D169F0AE30398EFB7FC6A82B3982FA72F003073O00E7941195CD454D03083O0042752O66446F776E03073O00A3B5D2E856FB8503063O009FE0C7A79B37030F3O00432O6F6C646F776E52656D61696E73030D3O00D6E539DCF0FA32D5C0E13DC6FF03043O00B297935C026O00E83F030D3O00ADEB493C1545748BCA5E33064403073O001AEC9D2C52722C030A3O00436F6D62617454696D65026O001440030F3O000E27C352242BF44E3227D9522B3CCC03043O003B4A4EB503104O00C95F59A631D85554B637C26D53BF2903053O00D345B12O3A026O002840025O004EAD40025O00AC9940025O0026AA40025O00D09640030E3O0049735370652O6C496E52616E6765025O0053B240025O0013B140031F3O00B2FD7CF6FCDFBEEA77CAFACEB9F17CFBEACEF7E676FAE5CFB8F277E6A99AE103063O00ABD785199589030D3O00C0DE37F4E839F245D6DA33EEE703083O002281A8529A8F509C030F3O00A1BB2502464BA890AA3A07414F9B9C03073O00E9E5D2536B282E03113O00E45A37D510D54B3DD836C44C26D30BC24703053O0065A12252B6030A3O00432O6F6C646F776E5570030E3O00CE0457FFD7D0872DE30257F7D5E503083O004E886D399EBB82E2025O00208340030D3O004176656E67696E675772617468025O002FB340025O009CAB40031B3O003F29FCFF3936F7F60128EBF02A37B9F231302OF53128F7E27E6EAB03043O00915E5F99025O00E8B240025O004AB040025O00089540025O0072A740026O00304003073O00DEDF01C64FB3F803063O00D79DAD74B52E025O0076A640025O006EA940025O0098A740025O007EA54003143O0036A69EE1DB31B1CBF1D53AB88FFDCD3BA7CBA38E03053O00BA55D4EB92026O007740025O009EB040030E3O00E48818FF35DC5DC18A19F030E05F03073O0038A2E1769E598E030F3O00780CD6A62CDD7D10D8A62ED15D17D903063O00B83C65A0CF42030D3O00109479B2368B72BB06907DA83903043O00DC51E21C03073O0030C797E8EBC31603063O00A773B5E29B8A030C3O00432O6F6C646F776E446F776E030F3O00C62BF1557574E7F73AEE507270D4FB03073O00A68242873C1B11025O00E0AD40025O00A6AC40025O00E9B240025O0036A140025O00D0A740025O00ECAD40025O0035B240025O0040834003063O005446CF6C355603053O0050242AAE15025O008AA040025O0068904003143O0046696E616C5265636B6F6E696E67506C61796572025O005C9E40025O0030A540025O002C9140025O00489C40031C3O004819397B422F257F4D1B3874471E303A4D1F38764A1F20745D50662203043O001A2E7057025O007BB040025O0080434003063O00BA36B967B0AD03083O00D4D943CB142ODF25025O001CB340025O00F8AC4003143O0046696E616C5265636B6F6E696E67437572736F72026O003440031C3O00BC84A6D3B6B2BAD7B986A7DCB383AF92B982A7DEBE82BFDCA9CDF98A03043O00B2DAEDC8025O00B2A240025O00488340025O00FEAE40025O00E2A140025O00209540025O00DCA240025O00C09840025O00D6A140025O0032A040025O003AA640030E3O00C8787B41CF5CCAF1757B44DE41F403073O008084111C29BB2F030E3O004C69676874734A7564676D656E74026O004440031B3O000D3B013249120D0C2F59063F0334494131093551053D11344E416603053O003D6152665A025O009CA640025O00BAA94003093O008A27B94EC55B1106A803083O0069CC4ECB2BA7377E025O00988A40025O0056A740025O001DB340025O00E0604003093O0046697265626C2O6F6403153O002OA3311B1108C85EA1EA20111C08C35EB2A4305E4503083O0031C5CA437E7364A7002D032O00124D3O00014O008A000100023O0026493O0006000100010004483O00060001002E2600020009000100030004483O0009000100124D000100014O008A000200023O00124D3O00043O000EE20004000200013O0004483O0002000100266B0001003B000100010004483O003B000100124D000300013O000EE200040012000100030004483O0012000100124D000100043O0004483O003B000100264900030016000100010004483O00160001002E07000500FAFF2O00060004483O000E00012O000501045O0020160004000400074O000500013O00202O0005000500084O000700023O00202O0007000700094O00050007000200062O00050032000100010004483O003200012O0005010500013O0020270005000500084O000700023O00202O00070007000A4O00050007000200062O0005002D00013O0004483O002D00012O0005010500013O00203A00050005000B4O000600023O00202O00060006000C4O00050002000200262O000500310001000D0004483O003100012O0005010500033O002628010500310001000E0004483O003100012O002400056O0080000500014O00DC0004000200022O0037000200043O00065700020038000100010004483O00380001002E07000F0003000100100004483O003900012O00EF000200023O00124D000300043O0004483O000E0001000E7F0011003F000100010004483O003F0001002E26001300AC000100120004483O00AC000100124D000300013O00266B00030044000100040004483O0044000100124D000100143O0004483O00AC0001000E7F00010048000100030004483O00480001002E7200150040000100160004483O004000012O0005010400043O0006300004005A00013O0004483O005A00012O0005010400053O0006300004005100013O0004483O005100012O0005010400063O00065700040054000100010004483O005400012O0005010400063O0006570004005A000100010004483O005A00012O0005010400073O0020D000040004001700124D000600184O00080004000600020006570004005C000100010004483O005C0001002E07001900170001001A0004483O0071000100124D000400014O008A000500053O00266B0004005E000100010004483O005E000100124D000500013O00264900050065000100010004483O00650001002E26001B00610001001C0004483O006100012O0005010600094O00730006000100022O00CE000600084O0005010600083O0006300006007100013O0004483O007100012O0005010600084O00EF000600023O0004483O007100010004483O006100010004483O007100010004483O005E00012O0005010400024O00340005000A3O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O00040004001F4O00040002000200062O0004009B00013O0004483O009B00012O00050104000B3O0006300004009B00013O0004483O009B00012O0005010400053O0006300004008400013O0004483O008400012O00050104000C3O00065700040087000100010004483O008700012O00050104000C3O0006570004009B000100010004483O009B00012O0005010400033O000E1B0020009B000100040004483O009B00012O0005010400024O00340005000A3O00122O000600213O00122O000700226O0005000700024O00040004000500202O0004000400234O00040002000200062O0004009D00013O0004483O009D00012O0005010400073O0020020104000400244O000600023O00202O0006000600254O00040006000200062O0004009D000100010004483O009D0001002E72002700AA000100260004483O00AA00012O00050104000D4O0005010500023O0020160105000500282O00DC000400020002000657000400A5000100010004483O00A50001002E26002A00AA000100290004483O00AA00012O00050104000A3O00124D0005002B3O00124D0006002C4O0019000400064O001A00045O00124D000300043O0004483O00400001002E72002E00AB2O01002D0004483O00AB2O0100266B000100AB2O0100140004483O00AB2O0100124D000300014O008A000400043O002E07002F3O0001002F0004483O00B2000100266B000300B2000100010004483O00B2000100124D000400013O002E0700300006000100300004483O00BD0001000EE2000400BD000100040004483O00BD000100124D000100313O0004483O00AB2O01002649000400C1000100010004483O00C10001002E72003200B7000100330004483O00B7000100124D000500013O002649000500C8000100040004483O00C80001002E15013500C8000100340004483O00C80001002E26003600CA000100370004483O00CA000100124D000400043O0004483O00B70001002E26003800C2000100390004483O00C2000100266B000500C2000100010004483O00C200012O0005010600024O00340007000A3O00122O0008003A3O00122O0009003B6O0007000900024O00060006000700202O00060006001F4O00060002000200062O000600342O013O0004483O00342O012O00050106000E3O000630000600342O013O0004483O00342O012O0005010600013O00202700060006003C4O000800023O00202O00080008000A4O00060008000200062O000600EC00013O0004483O00EC00012O0005010600024O009A0007000A3O00122O0008003D3O00122O0009003E6O0007000900024O00060006000700202O00060006003F4O000600020002000E2O002000072O0100060004483O00072O012O0005010600013O00204B00060006000B4O000800023O00202O00080008000A4O00060008000200262O000600072O01000D0004483O00072O012O0005010600024O00700007000A3O00122O000800403O00122O000900416O0007000900024O00060006000700202O00060006003F4O00060002000200262O000600072O0100420004483O00072O012O0005010600024O009B0007000A3O00122O000800433O00122O000900446O0007000900024O00060006000700202O00060006003F4O000600020002000E2O002000342O0100060004483O00342O012O00050106000F3O000E090031000F2O0100060004483O000F2O012O0005010600103O0020160106000600452O0073000600010002002628010600242O0100460004483O00242O012O00050106000F3O000E09001400172O0100060004483O00172O012O0005010600103O0020160106000600452O0073000600010002000E8F004600242O0100060004483O00242O012O00050106000F3O000E09001100342O0100060004483O00342O012O0005010600024O00340007000A3O00122O000800473O00122O000900486O0007000900024O00060006000700202O0006000600234O00060002000200062O000600342O013O0004483O00342O012O0005010600033O000E1B001800312O0100060004483O00312O012O0005010600024O00340007000A3O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O0006000600234O00060002000200062O000600382O013O0004483O00382O012O0005010600033O000E8F004B00382O0100060004483O00382O01002E15014C00382O01004D0004483O00382O01002E72004E004B2O01004F0004483O004B2O012O00050106000D4O0018010700023O00202O0007000700254O000800073O00202O0008000800504O000A00023O00202O000A000A00254O0008000A00024O000800086O00060008000200062O000600462O0100010004483O00462O01002E720051004B2O0100520004483O004B2O012O00050106000A3O00124D000700533O00124D000800544O0019000600084O001A00066O0005010600024O00340007000A3O00122O000800553O00122O000900566O0007000900024O00060006000700202O00060006001F4O00060002000200062O000600A62O013O0004483O00A62O012O0005010600113O000630000600A62O013O0004483O00A62O012O0005010600053O0006300006005E2O013O0004483O005E2O012O0005010600123O000657000600612O0100010004483O00612O012O0005010600123O000657000600A62O0100010004483O00A62O012O00050106000F3O000E09003100692O0100060004483O00692O012O0005010600103O0020160106000600452O0073000600010002002628010600922O0100460004483O00922O012O00050106000F3O000E09001400712O0100060004483O00712O012O0005010600103O0020160106000600452O0073000600010002000E8F004600922O0100060004483O00922O012O00050106000F3O000E09001100A62O0100060004483O00A62O012O0005010600024O00340007000A3O00122O000800573O00122O000900586O0007000900024O00060006000700202O0006000600234O00060002000200062O000600A62O013O0004483O00A62O012O0005010600024O00C10007000A3O00122O000800593O00122O0009005A6O0007000900024O00060006000700202O00060006005B4O00060002000200062O000600922O0100010004483O00922O012O0005010600024O00340007000A3O00122O0008005C3O00122O0009005D6O0007000900024O00060006000700202O00060006005B4O00060002000200062O000600A62O013O0004483O00A62O01002E07005E00140001005E0004483O00A62O012O00050106000D4O00F9000700023O00202O00070007005F4O000800073O00202O00080008001700122O000A000D6O0008000A00024O000800086O00060008000200062O000600A12O0100010004483O00A12O01002E0700600007000100610004483O00A62O012O00050106000A3O00124D000700623O00124D000800634O0019000600084O001A00065O00124D000500043O0004483O00C200010004483O00B700010004483O00AB2O010004483O00B20001002649000100AF2O0100310004483O00AF2O01002E26006400A5020100650004483O00A50201002E070066003E000100660004483O00ED2O01002E72006800ED2O0100670004483O00ED2O012O0005010300024O00340004000A3O00122O000500693O00122O0006006A6O0004000600024O00030003000400202O00030003001F4O00030002000200062O000300ED2O013O0004483O00ED2O012O0005010300133O000630000300ED2O013O0004483O00ED2O012O0005010300053O000630000300C62O013O0004483O00C62O012O0005010300143O000657000300C92O0100010004483O00C92O012O0005010300143O000657000300ED2O0100010004483O00ED2O012O00050103000F3O000E09003100D12O0100030004483O00D12O012O0005010300103O0020160103000300452O0073000300010002002628010300D92O0100460004483O00D92O012O00050103000F3O000E09001400ED2O0100030004483O00ED2O012O0005010300103O0020160103000300452O0073000300010002000E09004600ED2O0100030004483O00ED2O01002E26006B00E62O01006C0004483O00E62O012O00050103000D4O00F9000400023O00202O00040004000C4O000500073O00202O00050005001700122O0007000D6O0005000700024O000500056O00030005000200062O000300E82O0100010004483O00E82O01002E26006D00ED2O01006E0004483O00ED2O012O00050103000A3O00124D0004006F3O00124D000500704O0019000300054O001A00035O002E720071002C030100720004483O002C03012O0005010300024O00340004000A3O00122O000500733O00122O000600746O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003002C03013O0004483O002C03012O0005010300153O0006300003002C03013O0004483O002C03012O0005010300053O0006300003002O02013O0004483O002O02012O0005010300163O00065700030005020100010004483O000502012O0005010300163O0006570003002C030100010004483O002C03012O00050103000F3O000E090031000D020100030004483O000D02012O0005010300103O0020160103000300452O007300030001000200262801030022020100180004483O002202012O00050103000F3O000E0900140015020100030004483O001502012O0005010300103O0020160103000300452O0073000300010002000E9000180022020100030004483O002202012O00050103000F3O000E090011002C030100030004483O002C03012O0005010300024O00340004000A3O00122O000500753O00122O000600766O0004000600024O00030003000400202O0003000300234O00030002000200062O0003002C03013O0004483O002C03012O0005010300024O009A0004000A3O00122O000500773O00122O000600786O0004000600024O00030003000400202O00030003003F4O000300020002000E2O000D0044020100030004483O004402012O0005010300024O00340004000A3O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O00030003007B4O00030002000200062O0003002C03013O0004483O002C03012O0005010300013O00200201030003003C4O000500023O00202O00050005000A4O00030005000200062O00030044020100010004483O004402012O0005010300013O00200F00030003000B4O000500023O00202O00050005000A4O000300050002000E2O000D002C030100030004483O002C03012O0005010300173O000E8F00010057020100030004483O005702012O00050103000F3O00264900030057020100460004483O005702012O00050103000F3O000E090011002C030100030004483O002C03012O0005010300024O00340004000A3O00122O0005007C3O00122O0006007D6O0004000600024O00030003000400202O0003000300234O00030002000200062O0003002C03013O0004483O002C030100124D000300014O008A000400043O002E72007F00590201007E0004483O005902010026490003005F020100010004483O005F0201002E2600800059020100810004483O0059020100124D000400013O00264900040064020100010004483O00640201002E7200830060020100820004483O00600201002E720085006D020100840004483O006D02012O0005010500184O002A0006000A3O00122O000700863O00122O000800876O00060008000200062O00050084020100060004483O00840201002E7200880070020100890004483O007002010004483O008402012O00050105000D4O00F9000600193O00202O00060006008A4O000700073O00202O00070007001700122O0009000D6O0007000900024O000700076O00050007000200062O0005007F020100010004483O007F0201002E0B008B007F0201008C0004483O007F0201002E07008D00070001008E0004483O008402012O00050105000A3O00124D0006008F3O00124D000700904O0019000500074O001A00055O002E260092008D020100910004483O008D02012O0005010500184O002A0006000A3O00122O000700933O00122O000800946O00060008000200062O0005002C030100060004483O002C0301002E0700950003000100960004483O009002010004483O002C03012O00050105000D4O00FE000600193O00202O0006000600974O000700073O00202O00070007001700122O000900986O0007000900024O000700076O00050007000200062O0005002C03013O0004483O002C03012O00050105000A3O00120E000600993O00122O0007009A6O000500076O00055O00044O002C03010004483O006002010004483O002C03010004483O005902010004483O002C030100266B0001000B000100040004483O000B000100124D000300013O002E72009C00B00201009B0004483O00B00201002E72009E00B00201009D0004483O00B0020100266B000300B0020100040004483O00B0020100124D000100113O0004483O000B000100266B000300A8020100010004483O00A8020100124D000400013O002649000400B7020100040004483O00B70201002E7200A000B90201009F0004483O00B9020100124D000300043O0004483O00A80201002649000400BD020100010004483O00BD0201002E0700A100F8FF2O00A20004483O00B30201002E7200A300E5020100A40004483O00E502012O0005010500024O00340006000A3O00122O000700A53O00122O000800A66O0006000800024O00050005000600202O00050005001F4O00050002000200062O000500E502013O0004483O00E502012O00050105001A3O000630000500E502013O0004483O00E502012O00050105001B3O000630000500D202013O0004483O00D202012O0005010500053O000657000500D5020100010004483O00D502012O00050105001B3O000657000500E5020100010004483O00E502012O00050105000D4O00FE000600023O00202O0006000600A74O000700073O00202O00070007001700122O000900A86O0007000900024O000700076O00050007000200062O000500E502013O0004483O00E502012O00050105000A3O00124D000600A93O00124D000700AA4O0019000500074O001A00055O002E2600AB0026030100AC0004483O002603012O0005010500024O00340006000A3O00122O000700AD3O00122O000800AE6O0006000800024O00050005000600202O00050005001F4O00050002000200062O0005001203013O0004483O001203012O00050105001A3O0006300005001203013O0004483O001203012O00050105001B3O000630000500FA02013O0004483O00FA02012O0005010500053O000657000500FD020100010004483O00FD02012O00050105001B3O00065700050012030100010004483O001203012O0005010500013O0020020105000500084O000700023O00202O0007000700094O00050007000200062O00050014030100010004483O001403012O0005010500013O0020270005000500084O000700023O00202O00070007000A4O00050007000200062O0005001203013O0004483O001203012O0005010500013O00204B00050005000B4O000700023O00202O00070007000A4O00050007000200262O000500140301000D0004483O00140301002E7200B00026030100AF0004483O00260301002E2600B20026030100B10004483O002603012O00050105000D4O00FE000600023O00202O0006000600B34O000700073O00202O00070007001700122O0009000D6O0007000900024O000700076O00050007000200062O0005002603013O0004483O002603012O00050105000A3O00124D000600B43O00124D000700B54O0019000500074O001A00055O00124D000400043O0004483O00B302010004483O00A802010004483O000B00010004483O002C03010004483O000200012O003D3O00017O005C3O00028O00025O00EC9340025O00708D40025O0018A840025O001CA940027O0040025O00C4AA40025O00AEA440030F3O00B044553E88404A3DB2444A2A8D424C03043O004EE4213803073O004973526561647903073O00ED6CA71084CA7B03053O00E5AE1ED263030B3O004973417661696C61626C6503073O0038FF9342EC393C03073O00597B8DE6318D5D030F3O00432O6F6C646F776E52656D61696E73026O00084003063O0042752O665570030B3O004372757361646542752O6603093O0042752O66537461636B026O002440030F3O0054656D706C61727356657264696374030E3O0049735370652O6C496E52616E6765025O00A09840025O0017B140031C3O00E774FB2O1C4BE162B61A1558F778F518504CFA7FFF1F184FE162B65403063O002A9311966C70025O00D0A640025O0040A440025O00989240025O000CB040025O00589140025O0006A640030D3O0092BCF0D9B8B0C7C2B4BCF2D5A403043O00B0D6D58603113O00456D70797265616E506F77657242752O6603083O0042752O66446F776E03123O00456D70797265616E4C656761637942752O6603113O00446976696E654172626974657242752O66026O003840025O00C8A240025O0056A340030B3O00D0A4A0DDA6536AE0A2A4D903073O003994CDD6B4C83603073O0031EF20277716F803053O0016729D555403073O00E7D906D75CF2AD03073O00C8A4AB73A43D96030B3O00446976696E6553746F726D03093O004973496E52616E6765025O0068A040025O00D8834003183O00BAFD154C8DBBCB10518CACF92O438AB0FD104D86ACE7431703053O00E3DE946325026O00F03F025O002EA740025O00806840025O0051B240025O00CEA740025O00809C40025O0036A640025O00ECA74003123O00194741E2F0305340E5CF365C55F3F83D515703053O0099532O329603073O007E64660F72AF4803073O002D3D16137C13CB03073O00E20018E60374BC03073O00D9A1726D956210025O00608640025O00EEB04003123O004A757374696361727356656E6765616E6365025O00607A40025O00B07940031F3O0018352B68B57713322B43AA711C273D7DB27717603E75B27D01283D6EAF344603063O00147240581CDC025O00488F40025O00B4A740030C3O001708DCB5F4E6B82305DBB7EC03073O00DD5161B2D498B0030C3O00EBEE13FA16FBE20FFF13CEF303053O007AAD877D9B030A3O0049734361737461626C6503073O00A7D315AA3E35CD03073O00A8E4A160D95F5103073O00F8C33B4F2E53DE03063O0037BBB14E3C4F025O0058A340025O002OA640030C3O0046696E616C5665726469637403193O002BC751EA4A8F9628DC5BE245DBC02BC751E255C7853FDD1FBD03073O00E04DAE3F8B26AF008D012O00124D3O00014O008A000100013O002E7200030002000100020004483O000200010026493O0008000100010004483O00080001002E7200050002000100040004483O0002000100124D000100013O0026490001000D000100060004483O000D0001002E7200070052000100080004483O005200012O000501026O0034000300013O00122O000400093O00122O0005000A6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008C2O013O0004483O008C2O012O0005010200023O0006300002008C2O013O0004483O008C2O012O000501026O0034000300013O00122O0004000C3O00122O0005000D6O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002003E00013O0004483O003E00012O000501026O00CB000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200114O0002000200024O000300033O00202O00030003001200062O0003003E000100020004483O003E00012O0005010200043O0020270002000200134O00045O00202O0004000400144O00020004000200062O0002008C2O013O0004483O008C2O012O0005010200043O0020890002000200154O00045O00202O0004000400144O00020004000200262O0002008C2O0100160004483O008C2O012O0005010200054O001801035O00202O0003000300174O000400063O00202O0004000400184O00065O00202O0006000600174O0004000600024O000400046O00020004000200062O0002004C000100010004483O004C0001002E07001900422O01001A0004483O008C2O012O0005010200013O00120E0003001B3O00122O0004001C6O000200046O00025O00044O008C2O0100264900010056000100010004483O00560001002E72001D00E20001001E0004483O00E2000100124D000200014O008A000300033O00266B00020058000100010004483O0058000100124D000300013O002E72001F00D9000100200004483O00D9000100264900030061000100010004483O00610001002E26002200D9000100210004483O00D900012O0005010400083O000E9000120078000100040004483O007800012O0005010400083O000E0900060071000100040004483O007100012O000501046O0034000500013O00122O000600233O00122O000700246O0005000700024O00040004000500202O00040004000E4O00040002000200062O0004007800013O0004483O007800012O0005010400043O0020270004000400134O00065O00202O0006000600254O00040006000200062O0004008F00013O0004483O008F00012O0005010400043O0020270004000400264O00065O00202O0006000600274O00040006000200062O0004008F00013O0004483O008F00012O0005010400043O0020270004000400134O00065O00202O0006000600284O00040006000200062O0004008E00013O0004483O008E00012O0005010400043O0020410004000400154O00065O00202O0006000600284O000400060002000E2O0029008E000100040004483O008E00012O002400046O0080000400014O00CE000400073O002E26002A00D80001002B0004483O00D800012O000501046O0034000500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O00040004000B4O00040002000200062O000400D800013O0004483O00D800012O0005010400093O000630000400D800013O0004483O00D800012O0005010400073O000630000400D800013O0004483O00D800012O000501046O0034000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400C600013O0004483O00C600012O000501046O00CB000500013O00122O000600303O00122O000700316O0005000700024O00040004000500202O0004000400114O0004000200024O000500033O00202O00050005001200062O000500C6000100040004483O00C600012O0005010400043O0020270004000400134O00065O00202O0006000600144O00040006000200062O000400D800013O0004483O00D800012O0005010400043O0020890004000400154O00065O00202O0006000600144O00040006000200262O000400D8000100160004483O00D800012O0005010400054O00F900055O00202O0005000500324O000600063O00202O00060006003300122O000800166O0006000800024O000600066O00040006000200062O000400D3000100010004483O00D30001002E26003400D8000100350004483O00D800012O0005010400013O00124D000500363O00124D000600374O0019000400064O001A00045O00124D000300383O002E72003A005B000100390004483O005B000100266B0003005B000100380004483O005B000100124D000100383O0004483O00E200010004483O005B00010004483O00E200010004483O00580001002649000100E6000100380004483O00E60001002E72003B00090001003C0004483O0009000100124D000200013O002E26003D00ED0001003E0004483O00ED000100266B000200ED000100380004483O00ED000100124D000100063O0004483O00090001002E07003F00FAFF2O003F0004483O00E7000100266B000200E7000100010004483O00E700012O000501036O0034000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300372O013O0004483O00372O012O00050103000A3O000630000300372O013O0004483O00372O012O000501036O0034000400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300222O013O0004483O00222O012O000501036O00CB000400013O00122O000500443O00122O000600456O0004000600024O00030003000400202O0003000300114O0003000200024O000400033O00202O00040004001200062O000400222O0100030004483O00222O012O0005010300043O0020270003000300134O00055O00202O0005000500144O00030005000200062O000300372O013O0004483O00372O012O0005010300043O0020890003000300154O00055O00202O0005000500144O00030005000200262O000300372O0100160004483O00372O01002E26004600302O0100470004483O00302O012O0005010300054O001801045O00202O0004000400484O000500063O00202O0005000500184O00075O00202O0007000700484O0005000700024O000500056O00030005000200062O000300322O0100010004483O00322O01002E26004900372O01004A0004483O00372O012O0005010300013O00124D0004004B3O00124D0005004C4O0019000300054O001A00035O002E72004D00742O01004E0004483O00742O012O000501036O0034000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300742O013O0004483O00742O012O000501036O0034000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300534O00030002000200062O000300742O013O0004483O00742O012O0005010300023O000630000300742O013O0004483O00742O012O000501036O0034000400013O00122O000500543O00122O000600556O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300762O013O0004483O00762O012O000501036O00CB000400013O00122O000500563O00122O000600576O0004000600024O00030003000400202O0003000300114O0003000200024O000400033O00202O00040004001200062O000400762O0100030004483O00762O012O0005010300043O0020270003000300134O00055O00202O0005000500144O00030005000200062O000300742O013O0004483O00742O012O0005010300043O0020130103000300154O00055O00202O0005000500144O00030005000200262O000300762O0100160004483O00762O01002E72005900872O0100580004483O00872O012O0005010300054O00D200045O00202O00040004005A4O000500063O00202O0005000500184O00075O00202O00070007005A4O0005000700024O000500056O00030005000200062O000300872O013O0004483O00872O012O0005010300013O00124D0004005B3O00124D0005005C4O0019000300054O001A00035O00124D000200383O0004483O00E700010004483O000900010004483O008C2O010004483O000200012O003D3O00017O004C012O00028O00025O00809440025O00888E40025O00049D40026O00144003063O0042752O66557003113O004563686F65736F66577261746842752O6603073O0048617354696572026O003F40026O00104003103O002CB4386CE6EC06A82A4CF3FA06AD286C03063O00886FC64D1F87030B3O004973417661696C61626C6503083O00446562752O665570030E3O004A7564676D656E74446562752O6603133O00446976696E655265736F6E616E636542752O66027O0040025O00208B40025O00088C40025O005EAB40025O0098AA40025O00D8A140025O00A4B040025O006C9140025O006DB240025O0068A540025O000BB040030B3O003508AC53B2E236BA0A0CB403083O00C96269C736DD8477030A3O0049734361737461626C65030D3O00981A862F053CA2BE3B9120163D03073O00CCD96CE3416255030C3O00432O6F6C646F776E446F776E03073O007DD1E0F62DC45B03063O00A03EA395854C03113O00F3B8082CD6C2A90221F0D3AE192ACDD5A503053O00A3B6C06D4F03113O00113E05C3E0202F0FCEC6312814C5FB372303053O0095544660A0030F3O00432O6F6C646F776E52656D61696E73026O002040025O00C07140025O00E08540030B3O0057616B656F66417368657303093O004973496E52616E6765026O002440031A3O002F0706E807090BD2391505E82B460AE836031FEC2C091FFE785403043O008D58666D030E3O00915FCB741F3253EBA640DE79193803083O00A1D333AA107A5D3503113O004578707572676174696F6E446562752O66026O000840030E3O00426C6164656F664A757374696365030E3O0049735370652O6C496E52616E6765031D3O00F9A2B32CFE91BD2EC4A4A73BEFA7B12DBBA9B726FEBCB33CF4BCA168AF03043O00489BCED2025O00207840025O00206140030A3O00627342073D434E5B023F03053O0053261A346E030D3O00790122485F1E29416F0526525003043O0026387747026O002E4003073O00D0FD4DC52452F603063O0036938F38B645025O00F08340025O00E09040025O00D88C40030A3O00446976696E65546F2O6C026O003E4003183O00D288E940D1D3BEEB46D3DAC1F84CD1D393FE5DD0C492BF1F03053O00BFB6E19F29026O00F03F025O004DB040025O00707640025O0010A340025O002DB040025O0018B140025O001EA740025O00E89A40030E3O00155BE60372CA335BC00461C73D4C03063O00AE5629937013030E3O0078129818240B14B968149F022E0A03083O00CB3B60ED6B456F7103113O00436861726765734672616374696F6E616C026O00FC3F030E3O00061AADE534FFD10E03BFF538F3D203073O00B74476CC815190030E3O002CA171E00E8D088765F71F8B0DA803063O00E26ECD10846B03083O00C1D6E4DE4CEECDF403053O00218BA380B9030E3O004372757361646572537472696B65031D3O00544A11CD565C01CC684B10CC5E53019E505D0ADB455910D1454B448C0103043O00BE373864025O00109A40030C3O0062AA310E1FE2E165A33D0D1B03073O009336CF5C7E738303073O0049735265616479025O003CAA40025O0028B340025O008AA640025O0078A640030C3O0054656D706C6172536C617368031B3O001934386D017F1F0E26710C6D05713278037B1F3021721F6D4D636D03063O001E6D51551D6D025O0034AF40025O00D8AD40025O00BAA340025O001AA740025O001EAF40025O00488440025O00409740025O00A49940030D3O006E4DCCAEF3DA494AF6B1F7DC4E03063O00A8262CA1C396030F3O00A2F0876523EDB23588FD8F6639E7B803083O0076E09CE2165088D603103O004865616C746850657263656E74616765026O00344003113O0074EF578757EF4B8451C3568D47E04D954F03043O00E0228E39025O00F09D40025O00107B40025O0076A140030D3O0048612O6D65726F665772617468031D3O00D6A6C8D076E36201D898D2CF72E5554ED9A2CBD861F04901CCB4858C2103083O006EBEC7A5BD13913D025O0097B040025O0016AD40030C3O002OEE7AF887C6C8D87BE998CF03063O00A7BA8B1788EB030D3O002EB0851D16B49A3E0EA781061F03043O006D7AD5E803113O0054696D6553696E63654C61737443617374025O00B89C40025O004EA340031B3O00FAF2AF20E2F6B00FFDFBA323E6B7A535E0F2B031FAF8B023AEA6F603043O00508E97C2025O0018A340025O00E2A94003083O0029D3734B0EC3795803043O002C63A617030A3O00446562752O66446F776E03113O005EF83C3837A879E43A1C26A07BFA2C382703063O00C41C97495653025O00989640025O0072A74003083O004A7564676D656E74025O00CAAC40025O0020674003163O00F9162D178F5D1662B3042C1E874A1962FC113A50D30E03083O001693634970E23878025O00108740025O009C9E40030E3O009A79E3F188B773C8E09EAC7CE1F003053O00EDD815829503093O00AA41534692C55F864B03073O003EE22E2O3FD0A9025O002O9440025O002AA840031E3O00E71554871A322058DA1340900B042C5BA51E508D1A1F2E4AEA0B46C34E5503083O003E857935E37F6D4F025O0066A440025O0053B140025O0068AA40025O00E06840025O00589740025O00D4B14003083O003A0136F2DBABAC0403073O00C270745295B6CE03113O001BA75916C4EE0B2ABB660DC4E5033CA65803073O006E59C82C78A082025O00405D40025O003DB340025O00A0B040025O00507D4003163O00A1D64F414E4F3559EBC44E4846583A59A4D15806111A03083O002DCBA32B26232A5B03113O004176656E67696E67577261746842752O66030B3O004372757361646542752O6603113O00456D70797265616E506F77657242752O66025O001EAD40025O00C05540025O00C05A40025O0029B340025O00088340025O0062AE40025O00608F40025O0086AF40030C3O00F18AD23082AA46D391D52C8903073O0034B2E5BC43E7C903123O00436F6E736563726174696F6E446562752O66025O00E4A540025O00107740025O00649740025O0002A440030C3O00436F6E736563726174696F6E025O0088A440025O00FEA040031A3O00224E5E17F25F312055590BF91C2O244F5516F6482C33521056A503073O004341213064973C025O006EA740030C3O00FBEEB8D1FDDACFAFD5FEDAF503053O0093BF87CEB8030C3O00446976696E6548612O6D6572025O0030A740025O00C05140031B3O008021B0C8D6568D8C29ABCCDD41F2832DA8C4CA52A68B3AB5818A0703073O00D2E448C6A1B833026O001840025O00CAAA40025O0010AB40030D3O0018B4B628843C83CF2BB4B0279E03083O00A059C6D549EA59D7025O00808940025O00C09A40030D3O00417263616E65546F2O72656E74025O0042A240025O00707A40031C3O004963B7FFCB4D4EA0F1D75A74BAEA854F74BAFBD74965BBECD60823EC03053O00A52811D49E030C3O00C6D6062023E6CB09272FEAD703053O004685B96853025O005AA540025O0036A740025O00A7B240025O00588640025O0068AC40025O006C9C40025O004EA440025O00A4AF40031A3O00072O4A39CC0757453EC00B4B042DCC0A40562BDD0B2O576A9A5403053O00A96425244A030C3O00248EB4590E828A510D8AA74203043O003060E7C2025O00349140025O00B2A240025O000C9540031B3O00CC53182417DD908BC95703280B98A886C65F1C2C0DD7BD9088095C03083O00E3A83A6E4D79B8CF025O00C89F40025O003EAD40025O0038A240025O00C0A740025O00B0B140030D3O00675479054A477B0E7847751C4703043O00682F351403113O00954D8F1BA90EB1489231B302A6429509B103063O006FC32CE17CDC025O0058A040025O000AA040025O0028A940025O007CB240025O0090A040025O00BFB240031D3O00D0470D7EAEB9E749064CBCB9D9520833ACAED6431272BFA4CA554020FF03063O00CBB8266013CB030E3O001A616C52CF3D766B72DA2B7A724403053O00AE59131921025O00BAB140025O00507840031D3O002C00475DF6830E3D2D415AE58E002A52554BF982192E065D5CE4C7597903073O006B4F72322E97E7025O00E07040025O00D89840030D3O00CB7459A63ADFEECC6546BF3DDB03073O009C9F1134D656BE025O00649940025O00C49340030D3O0054656D706C6172537472696B65031C3O00BAEAB0ACA2EEAF83BDFBAFB5A5EAFDBBABE1B8AEAFFBB2AEBDAFEEEC03043O00DCCE8FDD03083O00AC682910D5C9DC9203073O00B2E61D4D77B8AC03113O00D7B11F1573F4F0AD193162FCF2B30F156303063O009895DE6A7B17025O00804940025O00C08C40025O0082B140025O0062B340025O0016AB40025O00FCA240025O00389F4003163O00D733F244B8D828E203B2D828F351B4C929E450F58E7403053O00D5BD469623025O00708040025O00F07F4003083O0001072C528682CC3F03073O00A24B724835EBE703083O0042752O66446F776E025O001AA840025O006CA540025O00A4A040025O00309D40025O00807740025O0046A04003153O00862940E55E07822804E5560C892E45F65C109F7C1303063O0062EC5C24823303093O0042752O66537461636B025O0036AE40025O005FB040025O00409340025O0024A840025O0028AC40025O0054AA40025O0039B040025O00849740025O0009B340025O0050AE40025O00B6B140025O0024B040030C3O00901C01AA49A9A703A8181FB203083O0050C4796CDA25C8D5030D3O0034760F6F470F9833671076400B03073O00EA6013621F2B6E025O00C05640025O0078A540031A3O00121A5FD7A07399390C5EC6BF7ACB011A5CC2BE739F090D4187F403073O00EB667F32A7CC12025O003C9C40025O00F49A40030E3O0072ADF4274121568BE030502753A403063O004E30C195432403093O0018118C01633C1F841D03053O0021507EE07803103O00CFBA16D75DE8A10DC36FF8BA0ACF59FF03053O003C8CC863A4025O0080A240025O00DAA340031E3O0085F80522A7B8FB0219A892E7102FA182B40323AC82E60532AD95E74477F203053O00C2E794644600B0052O00124D3O00013O002E07000200102O0100020004483O00112O010026493O0007000100010004483O00070001002E72000400112O0100030004483O00112O012O00052O015O000E900005003E000100010004483O003E00012O00052O0100013O0020270001000100064O000300023O00202O0003000300074O00010003000200062O0001002200013O0004483O002200012O00052O0100013O00204200010001000800122O000300093O00122O0004000A6O00010004000200062O0001002200013O0004483O002200012O00052O0100024O00C1000200033O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200202O00010001000D4O00010002000200062O0001003E000100010004483O003E00012O00052O0100043O0020022O010001000E4O000300023O00202O00030003000F4O00010003000200062O0001002C000100010004483O002C00012O00052O015O00266B0001003A0001000A0004483O003A00012O00052O0100013O0020270001000100064O000300023O00202O0003000300104O00010003000200062O0001003A00013O0004483O003A00012O00052O0100013O00204200010001000800122O000300093O00122O000400116O00010004000200062O0001003E00013O0004483O003E0001002E150113003E000100120004483O003E0001002E0700140019000100150004483O0055000100124D000100014O008A000200023O002E7200160040000100170004483O0040000100266B00010040000100010004483O0040000100124D000200013O00264900020049000100010004483O00490001002E07001800FEFF2O00190004483O004500012O0005010300064O00730003000100022O00CE000300054O0005010300053O0006300003005500013O0004483O005500012O0005010300054O00EF000300023O0004483O005500010004483O004500010004483O005500010004483O00400001002E72001A00A40001001B0004483O00A400012O00052O0100024O0034000200033O00122O0003001C3O00122O0004001D6O0002000400024O00010001000200202O00010001001E4O00010002000200062O000100A400013O0004483O00A400012O00052O0100073O000630000100A400013O0004483O00A400012O00052O015O00266C000100A4000100110004483O00A400012O00052O0100024O00C1000200033O00122O0003001F3O00122O000400206O0002000400024O00010001000200202O0001000100214O00010002000200062O0001007B000100010004483O007B00012O00052O0100024O0034000200033O00122O000300223O00122O000400236O0002000400024O00010001000200202O0001000100214O00010002000200062O000100A400013O0004483O00A400012O00052O0100024O0034000200033O00122O000300243O00122O000400256O0002000400024O00010001000200202O00010001000D4O00010002000200062O0001009200013O0004483O009200012O00052O0100024O009A000200033O00122O000300263O00122O000400276O0002000400024O00010001000200202O0001000100284O000100020002000E2O000A0092000100010004483O009200012O00052O0100083O0026AE000100A4000100290004483O00A40001002E72002A00A40001002B0004483O00A400012O00052O0100094O00FE000200023O00202O00020002002C4O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O000100A400013O0004483O00A400012O00052O0100033O00124D0002002F3O00124D000300304O0019000100034O001A00016O00052O0100024O0034000200033O00122O000300313O00122O000400326O0002000400024O00010001000200202O00010001001E4O00010002000200062O000100D300013O0004483O00D300012O00052O01000A3O000630000100D300013O0004483O00D300012O00052O0100043O0020022O010001000E4O000300023O00202O0003000300334O00010003000200062O000100D3000100010004483O00D300012O00052O015O00266C000100D3000100340004483O00D300012O00052O0100013O00204200010001000800122O000300093O00122O000400116O00010004000200062O000100D300013O0004483O00D300012O00052O0100094O00D2000200023O00202O0002000200354O000300043O00202O0003000300364O000500023O00202O0005000500354O0003000500024O000300036O00010003000200062O000100D300013O0004483O00D300012O00052O0100033O00124D000200373O00124D000300384O0019000100034O001A00015O002E26003A00102O0100390004483O00102O012O00052O0100024O0034000200033O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200202O00010001001E4O00010002000200062O000100102O013O0004483O00102O012O00052O01000B3O000630000100102O013O0004483O00102O012O00052O015O00266C000100102O0100110004483O00102O012O00052O0100024O009A000200033O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200202O0001000100284O000100020002000E2O003F00FC000100010004483O00FC00012O00052O0100024O009A000200033O00122O000300403O00122O000400416O0002000400024O00010001000200202O0001000100284O000100020002000E2O003F00FC000100010004483O00FC00012O00052O0100083O0026AE000100102O0100290004483O00102O01002E26004200102O0100430004483O00102O01002E0700440012000100440004483O00102O012O00052O0100094O00FE000200023O00202O0002000200454O000300043O00202O00030003002D00122O000500466O0003000500024O000300036O00010003000200062O000100102O013O0004483O00102O012O00052O0100033O00124D000200473O00124D000300484O0019000100034O001A00015O00124D3O00493O000E7F000A00172O013O0004483O00172O01002E0B004A00172O01004B0004483O00172O01002E07004C00870001004D0004483O009C2O01002E72004F00702O01004E0004483O00702O01002E0700500057000100500004483O00702O012O00052O0100024O0034000200033O00122O000300513O00122O000400526O0002000400024O00010001000200202O00010001001E4O00010002000200062O000100702O013O0004483O00702O012O00052O01000C3O000630000100702O013O0004483O00702O012O00052O0100024O0025000200033O00122O000300533O00122O000400546O0002000400024O00010001000200202O0001000100554O000100020002000E2O005600702O0100010004483O00702O012O00052O015O0026B10001005F2O0100110004483O005F2O012O00052O015O00266C000100442O0100340004483O00442O012O00052O0100024O00CB000200033O00122O000300573O00122O000400586O0002000400024O00010001000200202O0001000100284O0001000200024O0002000D3O00202O00020002001100062O0002005F2O0100010004483O005F2O012O00052O015O00266B000100702O01000A0004483O00702O012O00052O0100024O0006010200033O00122O000300593O00122O0004005A6O0002000400024O00010001000200202O0001000100284O0001000200024O0002000D3O00202O00020002001100062O000200702O0100010004483O00702O012O00052O0100024O0006010200033O00122O0003005B3O00122O0004005C6O0002000400024O00010001000200202O0001000100284O0001000200024O0002000D3O00202O00020002001100062O000200702O0100010004483O00702O012O00052O0100094O00D2000200023O00202O00020002005D4O000300043O00202O0003000300364O000500023O00202O00050005005D4O0003000500024O000300036O00010003000200062O000100702O013O0004483O00702O012O00052O0100033O00124D0002005E3O00124D0003005F4O0019000100034O001A00016O00052O0100064O00730001000100022O00CE000100053O002E0700600007000100600004483O007A2O012O00052O0100053O0006300001007A2O013O0004483O007A2O012O00052O0100054O00EF000100024O00052O0100024O0034000200033O00122O000300613O00122O000400626O0002000400024O00010001000200202O0001000100634O00010002000200062O000100872O013O0004483O00872O012O00052O01000E3O000657000100892O0100010004483O00892O01002E260065009B2O0100640004483O009B2O01002E720067009B2O0100660004483O009B2O012O00052O0100094O00FE000200023O00202O0002000200684O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O0001009B2O013O0004483O009B2O012O00052O0100033O00124D000200693O00124D0003006A4O0019000100034O001A00015O00124D3O00053O0026493O00A22O0100110004483O00A22O01002E61006B00A22O01006C0004483O00A22O01002E07006D00F10001006E0004483O00910201002E72007000EE2O01006F0004483O00EE2O01002E72007100EE2O0100720004483O00EE2O012O00052O0100024O0034000200033O00122O000300733O00122O000400746O0002000400024O00010001000200202O0001000100634O00010002000200062O000100EE2O013O0004483O00EE2O012O00052O01000F3O000630000100EE2O013O0004483O00EE2O012O00052O0100103O0026282O0100C72O0100110004483O00C72O012O00052O0100024O0034000200033O00122O000300753O00122O000400766O0002000400024O00010001000200202O00010001000D4O00010002000200062O000100C72O013O0004483O00C72O012O00052O0100013O00204200010001000800122O000300463O00122O0004000A6O00010004000200062O000100EE2O013O0004483O00EE2O012O00052O015O0026B1000100D92O0100340004483O00D92O012O00052O0100043O0020D00001000100772O00DC000100020002000E8F007800D92O0100010004483O00D92O012O00052O0100024O00C1000200033O00122O000300793O00122O0004007A6O0002000400024O00010001000200202O00010001000D4O00010002000200062O000100EE2O0100010004483O00EE2O01002E07007B00150001007B0004483O00EE2O01002E26007C00EE2O01007D0004483O00EE2O012O00052O0100094O00D2000200023O00202O00020002007E4O000300043O00202O0003000300364O000500023O00202O00050005007E4O0003000500024O000300036O00010003000200062O000100EE2O013O0004483O00EE2O012O00052O0100033O00124D0002007F3O00124D000300804O0019000100034O001A00015O002E2600820029020100810004483O002902012O00052O0100024O0034000200033O00122O000300833O00122O000400846O0002000400024O00010001000200202O0001000100634O00010002000200062O0001002902013O0004483O002902012O00052O01000E3O0006300001002902013O0004483O002902012O00052O0100114O00AC000200026O000300033O00122O000400853O00122O000500866O0003000500024O00020002000300202O0002000200874O0002000200024O0003000D6O0001000300024O000200126O000300026O000400033O00122O000500853O00122O000600866O0004000600024O00030003000400202O0003000300874O0003000200024O0004000D6O0002000400024O00010001000200262O000100290201000A0004483O002902012O00052O0100094O0018010200023O00202O0002000200684O000300043O00202O0003000300364O000500023O00202O0005000500684O0003000500024O000300036O00010003000200062O00010024020100010004483O00240201002E7200890029020100880004483O002902012O00052O0100033O00124D0002008A3O00124D0003008B4O0019000100034O001A00015O002E72008C00610201008D0004483O006102012O00052O0100024O0034000200033O00122O0003008E3O00122O0004008F6O0002000400024O00010001000200202O0001000100634O00010002000200062O0001006102013O0004483O006102012O00052O0100133O0006300001006102013O0004483O006102012O00052O0100043O0020270001000100904O000300023O00202O00030003000F4O00010003000200062O0001006102013O0004483O006102012O00052O015O0026B10001004C020100340004483O004C02012O00052O0100024O00C1000200033O00122O000300913O00122O000400926O0002000400024O00010001000200202O00010001000D4O00010002000200062O00010061020100010004483O00610201002E7200930061020100940004483O006102012O00052O0100094O0018010200023O00202O0002000200954O000300043O00202O0003000300364O000500023O00202O0005000500954O0003000500024O000300036O00010003000200062O0001005C020100010004483O005C0201002E2600960061020100970004483O006102012O00052O0100033O00124D000200983O00124D000300994O0019000100034O001A00015O002E26009A00900201009B0004483O009002012O00052O0100024O0034000200033O00122O0003009C3O00122O0004009D6O0002000400024O00010001000200202O00010001001E4O00010002000200062O0001009002013O0004483O009002012O00052O01000A3O0006300001009002013O0004483O009002012O00052O015O0026B10001007D020100340004483O007D02012O00052O0100024O00C1000200033O00122O0003009E3O00122O0004009F6O0002000400024O00010001000200202O00010001000D4O00010002000200062O00010090020100010004483O009002012O00052O0100094O0018010200023O00202O0002000200354O000300043O00202O0003000300364O000500023O00202O0005000500354O0003000500024O000300036O00010003000200062O0001008B020100010004483O008B0201002E0700A00007000100A10004483O009002012O00052O0100033O00124D000200A23O00124D000300A34O0019000100034O001A00015O00124D3O00343O000E7F0034009702013O0004483O00970201002E6100A50097020100A40004483O00970201002E7200A60056030100A70004483O00560301002E2600A800CF020100A90004483O00CF02012O00052O0100024O0034000200033O00122O000300AA3O00122O000400AB6O0002000400024O00010001000200202O0001000100634O00010002000200062O000100BA02013O0004483O00BA02012O00052O0100133O000630000100BA02013O0004483O00BA02012O00052O0100043O0020270001000100904O000300023O00202O00030003000F4O00010003000200062O000100BA02013O0004483O00BA02012O00052O015O0026B1000100BC020100340004483O00BC02012O00052O0100024O0034000200033O00122O000300AC3O00122O000400AD6O0002000400024O00010001000200202O00010001000D4O00010002000200062O000100BC02013O0004483O00BC0201002E7200AF00CF020100AE0004483O00CF0201002E7200B100CF020100B00004483O00CF02012O00052O0100094O00D2000200023O00202O0002000200954O000300043O00202O0003000300364O000500023O00202O0005000500954O0003000500024O000300036O00010003000200062O000100CF02013O0004483O00CF02012O00052O0100033O00124D000200B23O00124D000300B34O0019000100034O001A00016O00052O0100043O0020D00001000100772O00DC0001000200020026B1000100E9020100780004483O00E902012O00052O0100013O0020022O01000100064O000300023O00202O0003000300B44O00010003000200062O000100E9020100010004483O00E902012O00052O0100013O0020022O01000100064O000300023O00202O0003000300B54O00010003000200062O000100E9020100010004483O00E902012O00052O0100013O0020270001000100064O000300023O00202O0003000300B64O00010003000200062O0001000403013O0004483O0004030100124D000100014O008A000200023O002649000100EF020100010004483O00EF0201002E7200B700EB020100B80004483O00EB020100124D000200013O002E2600B900F0020100BA0004483O00F0020100266B000200F0020100010004483O00F002012O0005010300064O00730003000100022O00CE000300053O002E2600BB0004030100BC0004483O000403012O0005010300053O000657000300FE020100010004483O00FE0201002E7200BE0004030100BD0004483O000403012O0005010300054O00EF000300023O0004483O000403010004483O00F002010004483O000403010004483O00EB02012O00052O0100024O0034000200033O00122O000300BF3O00122O000400C06O0002000400024O00010001000200202O00010001001E4O00010002000200062O0001001B03013O0004483O001B03012O00052O0100143O0006300001001B03013O0004483O001B03012O00052O0100043O0020270001000100904O000300023O00202O0003000300C14O00010003000200062O0001001B03013O0004483O001B03012O00052O0100103O000E900011001D030100010004483O001D0301002E7200C20031030100C30004483O00310301002E2600C4002A030100C50004483O002A03012O00052O0100094O00F9000200023O00202O0002000200C64O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O0001002C030100010004483O002C0301002E7200C70031030100C80004483O003103012O00052O0100033O00124D000200C93O00124D000300CA4O0019000100034O001A00015O002E0700CB0024000100CB0004483O005503012O00052O0100024O0034000200033O00122O000300CC3O00122O000400CD6O0002000400024O00010001000200202O00010001001E4O00010002000200062O0001005503013O0004483O005503012O00052O0100153O0006300001005503013O0004483O005503012O00052O0100103O000E0900110055030100010004483O005503012O00052O0100094O00F9000200023O00202O0002000200CE4O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O00010050030100010004483O00500301002E0700CF0007000100D00004483O005503012O00052O0100033O00124D000200D13O00124D000300D24O0019000100034O001A00015O00124D3O000A3O00266B3O00D2030100D30004483O00D20301002E7200D4008B030100D50004483O008B03012O00052O0100024O0034000200033O00122O000300D63O00122O000400D76O0002000400024O00010001000200202O00010001001E4O00010002000200062O0001007703013O0004483O007703012O00052O0100163O0006300001006A03013O0004483O006A03012O00052O0100173O0006570001006D030100010004483O006D03012O00052O0100163O00065700010077030100010004483O007703012O00052O0100183O0006300001007703013O0004483O007703012O00052O015O0026AE00010077030100050004483O007703012O00052O0100194O0005010200083O0006DD00010079030100020004483O00790301002E7200D9008B030100D80004483O008B03012O00052O0100094O00F9000200023O00202O0002000200DA4O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O00010086030100010004483O00860301002E2600DB008B030100DC0004483O008B03012O00052O0100033O00124D000200DD3O00124D000300DE4O0019000100034O001A00016O00052O0100024O0034000200033O00122O000300DF3O00122O000400E06O0002000400024O00010001000200202O00010001001E4O00010002000200062O0001009803013O0004483O009803012O00052O0100143O0006570001009C030100010004483O009C0301002E0B00E1009C030100E20004483O009C0301002E0700E30016000100E40004483O00B00301002E2600E600B0030100E50004483O00B00301002E7200E700B0030100E80004483O00B003012O00052O0100094O00FE000200023O00202O0002000200C64O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O000100B003013O0004483O00B003012O00052O0100033O00124D000200E93O00124D000300EA4O0019000100034O001A00016O00052O0100024O0034000200033O00122O000300EB3O00122O000400EC6O0002000400024O00010001000200202O00010001001E4O00010002000200062O000100BD03013O0004483O00BD03012O00052O0100153O000657000100BF030100010004483O00BF0301002E2600EE00AF050100ED0004483O00AF0501002E0700EF00F02O0100EF0004483O00AF05012O00052O0100094O00FE000200023O00202O0002000200CE4O000300043O00202O00030003002D00122O0005002E6O0003000500024O000300036O00010003000200062O000100AF05013O0004483O00AF05012O00052O0100033O00120E000200F03O00122O000300F16O000100036O00015O00044O00AF0501002E0700F200D0000100F20004483O00A2040100266B3O00A2040100050004483O00A2040100124D000100013O002E7200F40036040100F30004483O00360401002E7200F50036040100F60004483O0036040100266B00010036040100490004483O003604012O0005010200024O0034000300033O00122O000400F73O00122O000500F86O0003000500024O00020002000300202O0002000200634O00020002000200062O000200FC03013O0004483O00FC03012O00050102000F3O000630000200FC03013O0004483O00FC03012O000501025O0026B1000200FE030100340004483O00FE03012O0005010200043O0020D00002000200772O00DC000200020002000E8F007800FE030100020004483O00FE03012O0005010200024O0034000300033O00122O000400F93O00122O000500FA6O0003000500024O00020002000300202O00020002000D4O00020002000200062O000200FE03013O0004483O00FE0301002E2600FB0013040100FC0004483O00130401002E2600FD0013040100FE0004483O00130401002E7200FF001304012O000104483O001304012O0005010200094O00D2000300023O00202O00030003007E4O000400043O00202O0004000400364O000600023O00202O00060006007E4O0004000600024O000400046O00020004000200062O0002001304013O0004483O001304012O0005010200033O00124D0003002O012O00124D00040002013O0019000200044O001A00026O0005010200024O0034000300033O00122O00040003012O00122O00050004015O0003000500024O00020002000300202O00020002001E4O00020002000200062O0002002004013O0004483O002004012O00050102000C3O00065700020024040100010004483O0024040100124D00020005012O00124D00030006012O00061B01020035040100030004483O003504012O0005010200094O00D2000300023O00202O00030003005D4O000400043O00202O0004000400364O000600023O00202O00060006005D4O0004000600024O000400046O00020004000200062O0002003504013O0004483O003504012O0005010200033O00124D00030007012O00124D00040008013O0019000200044O001A00025O00124D000100113O00124D00020009012O00124D0003000A012O00061B0102009C040100030004483O009C040100124D000200013O0006710001009C040100020004483O009C04012O0005010200024O0034000300033O00122O0004000B012O00122O0005000C015O0003000500024O00020002000300202O0002000200634O00020002000200062O0002005F04013O0004483O005F04012O00050102001A3O0006300002005F04013O0004483O005F040100124D0002000D012O00124D0003000E012O0006D40003005F040100020004483O005F04012O0005010200094O0011010300023O00122O0004000F015O0003000300044O000400043O00202O00040004002D00122O0006002E6O0004000600024O000400046O00020004000200062O0002005F04013O0004483O005F04012O0005010200033O00124D00030010012O00124D00040011013O0019000200044O001A00026O0005010200024O0034000300033O00122O00040012012O00122O00050013015O0003000500024O00020002000300202O0002000200634O00020002000200062O0002007A04013O0004483O007A04012O0005010200133O0006300002007A04013O0004483O007A04012O000501025O00124D000300343O00065900020013000100030004483O008204012O0005010200024O0034000300033O00122O00040014012O00122O00050015015O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002008204013O0004483O0082040100124D00020016012O00124D00030017012O00065900030005000100020004483O0082040100124D00020018012O00124D00030019012O00061B0103009B040100020004483O009B040100124D0002001A012O00124D0003001B012O00061B0103009B040100020004483O009B04012O0005010200094O0018010300023O00202O0003000300954O000400043O00202O0004000400364O000600023O00202O0006000600954O0004000600024O000400046O00020004000200062O00020096040100010004483O0096040100124D000200CF3O00124D0003001C012O00061B0102009B040100030004483O009B04012O0005010200033O00124D0003001D012O00124D0004001E013O0019000200044O001A00025O00124D000100493O00124D000200113O000671000100D7030100020004483O00D7030100124D3O00D33O0004483O00A204010004483O00D7030100124D0001001F012O00124D00020020012O0006D400020001000100010004483O0001000100124D000100493O0006713O0001000100010004483O0001000100124D000100013O00124D000200013O0006710002001C050100010004483O001C05012O0005010200024O0034000300033O00122O00040021012O00122O00050022015O0003000500024O00020002000300202O0002000200634O00020002000200062O000200D004013O0004483O00D004012O0005010200133O000630000200D004013O0004483O00D004012O0005010200043O00202700020002000E4O000400023O00202O0004000400334O00020004000200062O000200D004013O0004483O00D004012O0005010200013O00129600040023015O0002000200044O000400023O00202O0004000400074O00020004000200062O000200D004013O0004483O00D004012O0005010200013O00208100020002000800122O000400093O00122O000500116O00020005000200062O000200D8040100010004483O00D8040100124D00020024012O00124D00030025012O00065900020005000100030004483O00D8040100124D00020026012O00124D00030027012O000671000200ED040100030004483O00ED04012O0005010200094O0018010300023O00202O0003000300954O000400043O00202O0004000400364O000600023O00202O0006000600954O0004000600024O000400046O00020004000200062O000200E8040100010004483O00E8040100124D00020028012O00124D00030029012O00061B010300ED040100020004483O00ED04012O0005010200033O00124D0003002A012O00124D0004002B013O0019000200044O001A00026O000501025O00124D000300343O00061B01030001050100020004483O000105012O0005010200013O0020270002000200064O000400023O00202O0004000400B54O00020004000200062O0002000105013O0004483O000105012O0005010200013O0012210104002C015O0002000200044O000400023O00202O0004000400B54O00020004000200122O0003002E3O00062O0002002O050100030004483O002O050100124D00020029012O00124D0003002D012O0006D40003001B050100020004483O001B050100124D000200013O00124D0003002E012O00124D0004002F012O0006D400040006050100030004483O0006050100124D000300013O00067100020006050100030004483O000605012O0005010300064O00730003000100022O00CE000300054O0005010300053O00065700030017050100010004483O0017050100124D00030030012O00124D00040031012O00061B0104001B050100030004483O001B05012O0005010300054O00EF000300023O0004483O001B05010004483O0006050100124D000100493O00124D00020032012O00124D00030033012O0006D400020029050100030004483O0029050100124D000200113O00060100010027050100020004483O0027050100124D00020034012O00124D00030035012O0006D400030029050100020004483O0029050100124D3O00113O0004483O0001000100124D00020036012O00124D00030037012O0006D4000200AA040100030004483O00AA040100124D000200493O000671000100AA040100020004483O00AA040100124D00020038012O00124D00030038012O00067100020066050100030004483O006605012O0005010200024O0034000300033O00122O00040039012O00122O0005003A015O0003000500024O00020002000300202O0002000200634O00020002000200062O0002006605013O0004483O006605012O00050102000E3O0006300002006605013O0004483O006605012O0005010200024O003E000300033O00122O0004003B012O00122O0005003C015O0003000500024O00020002000300202O0002000200874O0002000200024O0003000D6O00020002000300122O0003000A3O00062O00020066050100030004483O006605012O0005010200103O00124D000300113O00061B01030066050100020004483O006605012O0005010200094O00F9000300023O00202O0003000300684O000400043O00202O00040004002D00122O0006002E6O0004000600024O000400046O00020004000200062O00020061050100010004483O0061050100124D0002003D012O00124D0003003E012O00061B01030066050100020004483O006605012O0005010200033O00124D0003003F012O00124D00040040013O0019000200044O001A00025O00124D00020041012O00124D00030042012O00061B010300AC050100020004483O00AC05012O0005010200024O0034000300033O00122O00040043012O00122O00050044015O0003000500024O00020002000300202O00020002001E4O00020002000200062O0002009705013O0004483O009705012O00050102000A3O0006300002009705013O0004483O009705012O000501025O00124D000300343O0006590002000B000100030004483O008505012O0005010200024O00C1000300033O00122O00040045012O00122O00050046015O0003000500024O00020002000300202O00020002000D4O00020002000200062O00020097050100010004483O009705012O0005010200103O00124D000300113O00061B01030093050100020004483O009305012O0005010200024O0034000300033O00122O00040047012O00122O00050048015O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002009B05013O0004483O009B05012O0005010200103O00124D0003000A3O00065900030005000100020004483O009B050100124D00020049012O00124D0003004A012O00061B010300AC050100020004483O00AC05012O0005010200094O00D2000300023O00202O0003000300354O000400043O00202O0004000400364O000600023O00202O0006000600354O0004000600024O000400046O00020004000200062O000200AC05013O0004483O00AC05012O0005010200033O00124D0003004B012O00124D0004004C013O0019000200044O001A00025O00124D000100113O0004483O00AA04010004483O000100012O003D3O00017O00913O00028O00025O00C88340025O0054A440025O007DB240025O0007B040025O00907740025O0031B240030C3O004570696353652O74696E677303083O004839AB54B8D576B603083O00C51B5CDF20D1BB1103113O00164CC6D90F5EC7FE0C59E9EE104BCAF80603043O009B633FA303083O00B1D4B599B08A85C203063O00E4E2B1C1EDD9030F3O0021A326C53BBE30E337A222F23DBF2D03043O008654D043026O00F03F025O00DC9240025O00B1B04003083O0020A992481AA2814F03043O003C73CCE603113O00F229EE53F52FF871E33FF943F328E27BE203043O0010875A8B026O001C4003083O001F5548ACCAA5253F03073O00424C303CD8A3CB03173O00A98E70F653CA2BBCB07CFD58CB25B4857CC456DA2C99A203073O0044DAE619933FAE026O001440025O00549F40025O00C2A340025O0004B340025O0080904003083O003882B0500289A35703043O00246BE7C4030A3O0048A6A7A44FA0B18659B003043O00E73DD5C203083O003AA8296700A33A6003043O001369CD5D03113O00BC1BDBA736A709D2B33AAA03D18F36A70F03053O005FC968BEE1025O00D08E40025O000AAC4003083O009CCED5DAA6C5C6DD03043O00AECFABA103143O00F8ED08C0F0DEE8F209FCFEE1E8F00AF6F9D9EEFB03063O00B78D9E6D9398026O001840026O000840025O005EA840025O00E07A40025O00709540025O00C88740025O00D2A240025O0026A94003083O008452D109282OB04403063O00DED737A57D4103103O0039C2C32EF7CCFD462DC3F50EE0C8E64F03083O002A4CB1A67A92A18D026O001040025O0080AD40025O00DCA94003083O000F40C8A0F3730A2F03073O006D5C25BCD49A1D03153O0011FCA1E9244910E6A7C2234932EAAAC4345B0AECA103063O003A648FC4A35103083O00294737B73647E21D03083O006E7A2243C35F2985030F3O0060A25E7ED378A1574BC446BD5A59DE03053O00B615D13B2A027O0040025O002EAF40025O00108C40025O00BCA54003083O000ED1AEC97E40204103083O00325DB4DABD172E47030B3O00CBB75E6651D84FD3A1555803073O0028BEC43B2C24BC025O00A4AB40025O00D2A94003083O00E98C4B1605E3DD9A03063O008DBAE93F626C03143O00E4F929933DF4E939A22CFEE41FB32BE5EF22B52003053O0045918A4CD603083O0043CA2O9DB61877DC03063O007610AF2OE9DF03103O009E973093EF86708E963ABDD9997C9F8C03073O001DEBE455DB8EEB025O00349240025O000C9140025O008CAD40025O0094A140025O00909B40025O00A88540025O002CA640025O0060A54003083O00CE231106002EFA3503063O00409D4665726903143O0046A1A9E21C72ADA4E81F4EA1A9E42749BCAFC03403053O007020C8C783025O0086AC40025O00607B4003083O001F0CF2182507E11F03043O006C4C698603133O00EAD3B4EFC9E2CBB6D6DCEAD1B9D6C7FFCD92C503053O00AE8BA5D18103083O0090B6F6D5CF0D776B03083O0018C3D382A1A66310030D3O004511FC3F52124334E0385B356203063O00762663894C33025O00989540025O0028854003083O00F53DAD22B00CC12B03063O0062A658D956D9030D3O00E3E57C258FCAFFF87C3589D0FA03063O00BC2O961961E6025O00388C40025O003EA54003083O0067711227475A7F4703073O0018341466532E34030F3O00D13C240006D2262F2127C5222C211D03053O006FA44F414403083O00F5DC97CA27E4C1CA03063O008AA6B9E3BE4E030E3O00DE67C0135B3510C571F6235D311403073O0079AB14A5573243025O005C9B40025O000C964003083O0006886F4BDBA1B3CB03083O00B855ED1B3FB2CFD403103O001D4A0C7E1E5C075801570E681A581D5703043O003F683969025O0056B040025O003AB240025O00188340025O00C2A040025O0067B24003083O00968F11DA7078A29903063O0016C5EA65AE19030E3O003827A0EB77A4D2892B15B6D473BC03083O00E64D54C5BC16CFB703083O00CA11D2E885AFF72603083O00559974A69CECC190030A3O00B1F34885E112A0E94EA703063O0060C4802DD38400B3012O00124D3O00014O008A000100013O000EE20001000200013O0004483O0002000100124D000100013O000EE200010044000100010004483O0044000100124D000200013O0026490002000C000100010004483O000C0001002E2600030033000100020004483O0033000100124D000300013O00264900030013000100010004483O00130001002E6100040013000100050004483O00130001002E260007002C000100060004483O002C0001001227010400084O0065000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400054O000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O00045O00122O000400086O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000400023O00122O000300113O00264900030030000100110004483O00300001002E07001200DFFF2O00130004483O000D000100124D000200113O0004483O003300010004483O000D000100266B00020008000100110004483O00080001001227010300084O000E010400013O00122O000500143O00122O000600156O0004000600024O0003000300044O000400013O00122O000500163O00122O000600176O0004000600024O0003000300044O000300033O00122O000100113O00044O004400010004483O00080001000EE200180053000100010004483O00530001001227010200084O0009010300013O00122O000400193O00122O0005001A6O0003000500024O0002000200034O000300013O00122O0004001B3O00122O0005001C6O0003000500024O0002000200032O00CE000200043O0004483O00B22O01002649000100570001001D0004483O00570001002E07001E00330001001F0004483O0088000100124D000200013O002E7200210075000100200004483O0075000100266B00020075000100010004483O00750001001227010300084O0065000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000300053O00122O000300086O000400013O00122O000500263O00122O000600276O0004000600024O0003000300044O000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000300063O00122O000200113O002E72002A00580001002B0004483O0058000100266B00020058000100110004483O00580001001227010300084O000E010400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000300073O00122O000100303O00044O008800010004483O005800010026490001008C000100310004483O008C0001002E070032003B000100330004483O00C5000100124D000200014O008A000300033O00264900020092000100010004483O00920001002E720034008E000100350004483O008E000100124D000300013O002E26003600A5000100370004483O00A5000100266B000300A5000100110004483O00A50001001227010400084O000E010500013O00122O000600383O00122O000700396O0005000700024O0004000400054O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000400083O00122O0001003C3O00044O00C50001002649000300A9000100010004483O00A90001002E72003D00930001003E0004483O00930001001227010400084O00A1000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O000400093O00122O000400086O000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O0004000400054O0004000A3O00122O000300113O00044O009300010004483O00C500010004483O008E000100266B000100FA000100470004483O00FA000100124D000200013O002E0700480014000100480004483O00DC0001000E7F001100CE000100020004483O00CE0001002E72004A00DC000100490004483O00DC0001001227010300084O000E010400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300044O000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O0003000B3O00122O000100313O00044O00FA0001002E26005000C80001004F0004483O00C8000100266B000200C8000100010004483O00C80001001227010300084O00A1000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O000400013O00122O000500533O00122O000600546O0004000600024O0003000300044O0003000C3O00122O000300086O000400013O00122O000500553O00122O000600566O0004000600024O0003000300044O000400013O00122O000500573O00122O000600586O0004000600024O0003000300044O0003000D3O00122O000200113O00044O00C80001002649000100FE000100300004483O00FE0001002E720059003D2O01005A0004483O003D2O0100124D000200014O008A000300033O002E07005B3O0001005B0004484O002O01000E7F000100062O0100020004483O00062O01002E26005C2O002O01005D0004484O002O0100124D000300013O002E07005E00040001005E0004483O000B2O01000E7F0011000D2O0100030004483O000D2O01002E72005F001B2O0100600004483O001B2O01001227010400084O000E010500013O00122O000600613O00122O000700626O0005000700024O0004000400054O000500013O00122O000600633O00122O000700646O0005000700024O0004000400054O0004000E3O00122O000100183O00044O003D2O01002E07006500ECFF2O00650004483O00072O01000E7F000100212O0100030004483O00212O01002E07001F00E8FF2O00660004483O00072O01001227010400084O00A1000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O0004000F3O00122O000400086O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O000400103O00122O000300113O00044O00072O010004483O003D2O010004484O002O01002E72007000702O01006F0004483O00702O0100266B000100702O0100110004483O00702O0100124D000200013O00266B000200522O0100110004483O00522O01001227010300084O000E010400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000300113O00122O000100473O00044O00702O01002E72007500422O0100760004483O00422O01000EE2000100422O0100020004483O00422O01001227010300084O00A1000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000300123O00122O000300086O000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O0003000300044O000300133O00122O000200113O00044O00422O01002E72008000050001007F0004483O0005000100266B000100050001003C0004483O0005000100124D000200013O00266B000200852O0100110004483O00852O01001227010300084O000E010400013O00122O000500813O00122O000600826O0004000600024O0003000300044O000400013O00122O000500833O00122O000600846O0004000600024O0003000300044O000300143O00122O0001001D3O00044O00050001002E07008500F0FF2O00850004483O00752O0100266B000200752O0100010004483O00752O0100124D000300013O00266B0003008E2O0100110004483O008E2O0100124D000200113O0004483O00752O01002649000300942O0100010004483O00942O01002E61008600942O0100870004483O00942O01002E720089008A2O0100880004483O008A2O01001227010400084O00A1000500013O00122O0006008A3O00122O0007008B6O0005000700024O0004000400054O000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400054O000400153O00122O000400086O000500013O00122O0006008E3O00122O0007008F6O0005000700024O0004000400054O000500013O00122O000600903O00122O000700916O0005000700024O0004000400054O000400163O00122O000300113O00044O008A2O010004483O00752O010004483O000500010004483O00B22O010004483O000200012O003D3O00017O00693O00028O00027O0040025O0081B240025O00ADB140025O00F0B240025O00DDB040030C3O004570696353652O74696E677303083O001D86045220D4299003063O00BA4EE370264903133O00E944F8625C68F858FB725F75EE4EDB5A506FEF03063O001A9C379D353303083O00BFDD02CDB15E8BCB03063O0030ECB876B9D8031C3O00F0AE5212C331F6AE5E3EC81BE38D453FDB31E6A95E3FC112EABE422303063O005485DD3750AF03083O008EE230B2CE52BAF403063O003CDD8744C6A7031B3O00FBAEFDA14EDCFDAEF18D45F6E88EF98050D0E8B4FB8664D6EDA8EB03063O00B98EDD98E322026O000840025O00088440025O00BBB240026O00184003083O00E4DD532BDED6402C03043O005FB7B82703153O00B336E92758B207B634E8285D8E05863AF3325D8E0503073O0062D55F874634E0034O00026O001040025O000FB140025O002EAD40026O00F03F03083O008BD86216BB5A7F3503083O0046D8BD1662D23418031B3O00D8D3A694C0D3D1A488D5EACDAC93D6D9CBAA88DDFCD0A092C0F2EF03053O00B3BABFC3E7026O00144003083O0041EDD0B7024D7E6103073O00191288A4C36B2303113O00E42CB0407C94C0B6EC3E8F4071A9D290D803083O00D8884DC92F12DCA103083O001EE93FCE01D2853E03073O00E24D8C4BBA68BC03123O00AEC1C23B40BFE9DC305DA0E8DF3C5AAAE6E003053O002FD9AEB05F025O00A4AB40025O0080924003083O009E2F4758BFA32D4003053O00D6CD4A332C03093O00EF5FE7CE72F859E9F903053O00179A2C829C03083O0022A3B9BA3F1D16B503063O007371C6CDCE5603123O009144FB72855AF35F9658F8709144EA53875203043O003AE4379E03083O00878CC43A35A332A703073O0055D4E9B04E5CCD03133O005F4B8DC6434E81EC4F689AED5E5D8BF643578603043O00822A38E8025O00F4A240025O00C4AD40025O00A7B240025O0092AA40025O004EA14003083O00CA3A0C2OF0311FF703043O0084995F78031A3O00B3BE0B3EE4D3AEB6BD081EF6D9B2B8B4072EF2FCAFB2A71D05C703073O00C0D1D26E4D97BA03083O00D30636FDF6CAE71003063O00A4806342899F031D3O00159AEC9D0C8CE8B0138CDDB11880E7AD3780FDB6218FEFB2098AFDBB0403043O00DE60E98903083O008AB6B30B81FDF7AA03073O0090D9D3C77FE893031B3O00ED3C3B1FDA57064BFE083227C75C354DEC271F2ED3490B47EC2A3A03083O0024984F5E48B52562025O00FAA340025O001CA240025O003C9E4003083O000FD8D7073C32DAD003053O00555CBDA37303123O003CBF351428B53F3601AD3E3C3A8A3F3B3CBF03043O005849CC5003083O00D9B030F74931EDA603063O005F8AD5448320030F3O003F3BA4677F3C21AF46452221A44F7203053O00164A48C12303083O001F7CF04C2577E34B03043O00384C1984030D3O004BD2AE0ACE47CEA50ECE50C5B803053O00AF3EA1CB46026O003540025O00CC9E4003083O006BC043EE4A3DF04B03073O009738A5379A235303123O00A44A13E7AE4635FCAF5700EDB44A0AE0887303043O008EC0236503083O00E5703DB7EE82AB0503083O0076B61549C387ECCC030E3O000C350C490A08CE00351F4C0025CD03073O009D685C7A20646D03083O0090A3DBDE34298AB803083O00CBC3C6AFAA5D47ED030C3O00224A27DA5F39FD204F2DFD6103073O009C4E2B5EB531710042012O00124D3O00013O0026493O0007000100020004483O00070001002E6100030007000100040004483O00070001002E260005002C000100060004483O002C00010012272O0100074O0046000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O00015O00122O000100076O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100023O00122O000100076O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100033O00124O00143O002E7200150040000100160004483O0040000100266B3O0040000100170004483O004000010012272O0100074O0020000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O0001003E000100010004483O003E000100124D0001001C4O00CE000100043O0004483O00412O0100266B3O007A0001001D0004483O007A000100124D000100013O002E26001F00580001001E0004483O0058000100266B00010058000100200004483O00580001001227010200074O0020000300013O00122O000400213O00122O000500226O0003000500024O0002000200034O000300013O00122O000400233O00122O000500246O0003000500024O00020002000300062O00020055000100010004483O0055000100124D000200014O00CE000200053O00124D3O00253O0004483O007A000100266B00010043000100010004483O00430001001227010200074O0020000300013O00122O000400263O00122O000500276O0003000500024O0002000200034O000300013O00122O000400283O00122O000500296O0003000500024O00020002000300062O00020068000100010004483O0068000100124D000200014O00CE000200063O00122O010200076O000300013O00122O0004002A3O00122O0005002B6O0003000500024O0002000200034O000300013O00122O0004002C3O00122O0005002D6O0003000500024O00020002000300062O00020077000100010004483O0077000100124D000200014O00CE000200073O00124D000100203O0004483O004300010026493O007E000100010004483O007E0001002E26002E00A30001002F0004483O00A300010012272O0100074O0046000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100083O00122O000100076O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100093O00122O000100076O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000200013O00122O0003003A3O00122O0004003B6O0002000400024O0001000100024O0001000A3O00124O00203O002E07003C00040001003C0004483O00A700010026493O00A9000100250004483O00A90001002E72003E00DB0001003D0004483O00DB000100124D000100013O002649000100AE000100010004483O00AE0001002E26003F00CA000100400004483O00CA0001001227010200074O0020000300013O00122O000400413O00122O000500426O0003000500024O0002000200034O000300013O00122O000400433O00122O000500446O0003000500024O00020002000300062O000200BC000100010004483O00BC000100124D000200014O00CE0002000B3O0012FD000200076O000300013O00122O000400453O00122O000500466O0003000500024O0002000200034O000300013O00122O000400473O00122O000500486O0003000500024O0002000200034O0002000C3O00122O000100203O00266B000100AA000100200004483O00AA0001001227010200074O000E010300013O00122O000400493O00122O0005004A6O0003000500024O0002000200034O000300013O00122O0004004B3O00122O0005004C6O0003000500024O0002000200034O0002000D3O00124O00173O00044O00DB00010004483O00AA0001002E07004D00330001004D0004483O000E2O0100266B3O000E2O0100200004483O000E2O0100124D000100013O002649000100E4000100200004483O00E40001002E26004E00F20001004F0004483O00F20001001227010200074O000E010300013O00122O000400503O00122O000500516O0003000500024O0002000200034O000300013O00122O000400523O00122O000500536O0003000500024O0002000200034O0002000E3O00124O00023O00044O000E2O0100266B000100E0000100010004483O00E00001001227010200074O00A1000300013O00122O000400543O00122O000500556O0003000500024O0002000200034O000300013O00122O000400563O00122O000500576O0003000500024O0002000200034O0002000F3O00122O000200076O000300013O00122O000400583O00122O000500596O0003000500024O0002000200034O000300013O00122O0004005A3O00122O0005005B6O0003000500024O0002000200034O000200103O00122O000100203O00044O00E00001002E72005C00010001005D0004483O0001000100266B3O0001000100140004483O000100010012272O0100074O0020000200013O00122O0003005E3O00122O0004005F6O0002000400024O0001000100024O000200013O00122O000300603O00122O000400616O0002000400024O00010001000200062O000100202O0100010004483O00202O0100124D000100014O00CE000100113O00123O0100076O000200013O00122O000300623O00122O000400636O0002000400024O0001000100024O000200013O00122O000300643O00122O000400656O0002000400024O00010001000200062O0001002F2O0100010004483O002F2O0100124D000100014O00CE000100123O00123O0100076O000200013O00122O000300663O00122O000400676O0002000400024O0001000100024O000200013O00122O000300683O00122O000400696O0002000400024O00010001000200062O0001003E2O0100010004483O003E2O0100124D000100014O00CE000100133O00124D3O001D3O0004483O000100012O003D3O00017O00783O00028O00025O00F2AA40026O001040030C3O004570696353652O74696E677303083O00701AAEB30B7D440C03063O0013237FDAC76203113O0034FA04E610FE23EC1FF418F213E90FE31003043O00827C9B6A03083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C03073O00643FE2A226631903053O00692C5A83CE03083O00CCE5A6AD0130F8F303063O005E9F80D2D96803093O0078FC07B37050DA526003083O001A309966DF3F1F99027O0040025O00D4A640025O00907B40025O00149540025O0040954003083O0078C600F926A64CD003063O00C82BA3748D4F030E3O00AB24348DBBF1F7AC013497B8D7C703073O0083DF565DE3D09403083O00D0402OA214BBE45603063O00D583252OD67D030D3O00342A26B6E02A3812B6F52E080103053O0081464B45DF026O00F03F025O00C4AD40025O00588840025O0050AC40025O00C0914003083O0075CEE7FD75E141D803063O008F26AB93891C030E3O00C591BCDB06E2D8C48AAAE70CEDD103073O00B4B0E2D993638303083O00E0BC3B13DAB7281403043O0067B3D94F03103O005FA419FD448DAF43B91BE54E98AA45B903073O00C32AD77CB521EC025O00EC9F40025O00AEA440025O00EEA240025O00BC9140026O000840025O00207640025O00F89740025O0068AD40025O000CB340025O0068B240026O00A74003083O00BEF591FB3483F79603053O005DED90E58F030D3O0031FFE3090E4A31F3F20C0D400603063O0026759690796B03083O001EBEFA2E24B5E92903043O005A4DDB8E030B3O00C20D3229490B58F302272A03073O001A866441592C6703083O00C2E62437ADFFE42303053O00C491835043030B3O000BA3033C0AE110BB031C0B03063O00887ED066687803083O004B8FDA57A65C3A4203083O003118EAAE23CF325D030A3O0019E1F8BA700FFBFC846203053O00116C929DE8025O00B8AC40025O00F88540025O00EAB140025O001EA040025O00C6AD40025O00F07340025O000AAC40025O005EA94003083O002B7B375FA216793003053O00CB781E432B03113O00D9204CE3D0FF227DE0CDF82A43C1D8FC2003053O00B991452D8F034O0003083O00B91A0DB2D584180A03053O00BCEA7F79C6030F3O0030331D87343732852O3E1A802C371703043O00E3585273025O00804740025O0008914003083O003E5C232A2CF60A4A03063O00986D39575E45030D3O00F1D20BAFAADA47BCF6D90F8B8E03083O00C899B76AC3DEB23403083O0001E69C29405435F003063O003A5283E85D29030F3O008B52D11954318467DF0154308D7FE003063O005FE337B0753D025O006C9540025O00A8A640025O008C9B40025O006C9B4003083O003CAABA07F6E6EBC203083O00B16FCFCE739F888C03163O002C870411C65D4A159D3F1AD856680D800411D8464C1103073O003F65E97074B42F03083O00F03EF906F138C42803063O0056A35B8D729803123O007A05607628411E64670E5B197160325C077003053O005A336B1413025O00989140025O00807F40025O00C6AA40025O00CEA04003083O00CDA6DD635DF0A4DA03053O00349EC3A91703113O007CB5357C92077E867BB53C67A53D7E887103083O00EB1ADC5214E6551B03083O00BBA4FDD67D86A6FA03053O0014E8C189A203113O000B2OD1A3F59E026136E8CCB2EFBF03642C03083O001142BFA5C687EC77007B012O00124D3O00014O008A000100013O002E0700023O000100020004483O00020001000EE20001000200013O0004483O0002000100124D000100013O00266B00010031000100030004483O00310001001227010200044O0088000300013O00122O000400053O00122O000500066O0003000500024O0002000200034O000300013O00122O000400073O00122O000500086O0003000500024O0002000200034O00025O00122O000200046O000300013O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200034O000200023O00122O000200046O000300013O00122O0004000D3O00122O0005000E6O0003000500024O0002000200034O000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300062O0002002F000100010004483O002F000100124D000200014O00CE000200033O0004483O007A2O0100264900010035000100110004483O00350001002E260012007B000100130004483O007B000100124D000200013O000E7F0001003A000100020004483O003A0001002E2600150053000100140004483O00530001001227010300044O0065000400013O00122O000500163O00122O000600176O0004000600024O0003000300044O000400013O00122O000500183O00122O000600196O0004000600024O0003000300044O000300043O00122O000300046O000400013O00122O0005001A3O00122O0006001B6O0004000600024O0003000300044O000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000300053O00122O0002001E3O002E26002000720001001F0004483O00720001002E2600220072000100210004483O0072000100266B000200720001001E0004483O00720001001227010300044O0065000400013O00122O000500233O00122O000600246O0004000600024O0003000300044O000400013O00122O000500253O00122O000600266O0004000600024O0003000300044O000300063O00122O000300046O000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000300073O00122O000200113O002E72002B00760001002C0004483O0076000100264900020078000100110004483O00780001002E07002D00C0FF2O002E0004483O0036000100124D0001002F3O0004483O007B00010004483O003600010026490001007F0001001E0004483O007F0001002E26003100C3000100300004483O00C3000100124D000200013O00264900020086000100010004483O00860001002E6100330086000100320004483O00860001002E260034009F000100350004483O009F0001001227010300044O0065000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O000300083O00122O000300046O000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000300093O00122O0002001E3O00266B000200BA0001001E0004483O00BA0001001227010300044O0065000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000400013O00122O000500403O00122O000600416O0004000600024O0003000300044O0003000A3O00122O000300046O000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O0003000300044O0003000B3O00122O000200113O002E26004700BE000100460004483O00BE0001000E7F001100C0000100020004483O00C00001002E2600480080000100490004483O0080000100124D000100113O0004483O00C300010004483O0080000100266B000100202O01002F0004483O00202O0100124D000200013O002E72004B00CC0001004A0004483O00CC000100266B000200CC000100110004483O00CC000100124D000100033O0004483O00202O0100266B000200F40001001E0004483O00F4000100124D000300013O00266B000300D30001001E0004483O00D3000100124D000200113O0004483O00F40001002649000300D7000100010004483O00D70001002E26004C00CF0001004D0004483O00CF0001001227010400044O0020000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O000500013O00122O000600503O00122O000700516O0005000700024O00040004000500062O000400E5000100010004483O00E5000100124D000400524O00CE0004000C3O0012A3000400046O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O000500013O00122O000600553O00122O000700566O0005000700024O0004000400054O0004000D3O00122O0003001E3O00044O00CF0001000EE2000100C6000100020004483O00C6000100124D000300013O000EE2001E00FB000100030004483O00FB000100124D0002001E3O0004483O00C60001002E72005700F7000100580004483O00F7000100266B000300F7000100010004483O00F70001001227010400044O0020000500013O00122O000600593O00122O0007005A6O0005000700024O0004000400054O000500013O00122O0006005B3O00122O0007005C6O0005000700024O00040004000500062O0004000D2O0100010004483O000D2O0100124D000400014O00CE0004000E3O00122O010400046O000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000500013O00122O0006005F3O00122O000700606O0005000700024O00040004000500062O0004001C2O0100010004483O001C2O0100124D000400014O00CE0004000F3O00124D0003001E3O0004483O00F700010004483O00C6000100266B00010007000100010004483O0007000100124D000200014O008A000300033O00266B000200242O0100010004483O00242O0100124D000300013O0026490003002D2O0100110004483O002D2O01002E610062002D2O0100610004483O002D2O01002E720063002F2O0100640004483O002F2O0100124D0001001E3O0004483O0007000100266B000300562O01001E0004483O00562O0100124D000400013O00266B0004004D2O0100010004483O004D2O01001227010500044O0065000600013O00122O000700653O00122O000800666O0006000800024O0005000500064O000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O000500103O00122O000500046O000600013O00122O000700693O00122O0008006A6O0006000800024O0005000500064O000600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000500113O00122O0004001E3O002649000400532O01001E0004483O00532O01002E61006D00532O01006E0004483O00532O01002E72006F00322O0100700004483O00322O0100124D000300113O0004483O00562O010004483O00322O0100266B000300272O0100010004483O00272O01001227010400044O0020000500013O00122O000600713O00122O000700726O0005000700024O0004000400054O000500013O00122O000600733O00122O000700746O0005000700024O00040004000500062O000400662O0100010004483O00662O0100124D000400014O00CE000400123O0012A3000400046O000500013O00122O000600753O00122O000700766O0005000700024O0004000400054O000500013O00122O000600773O00122O000700786O0005000700024O0004000400054O000400133O00122O0003001E3O00044O00272O010004483O000700010004483O00242O010004483O000700010004483O007A2O010004483O000200012O003D3O00017O009C012O00028O00026O00F03F026O001040025O0028AD40025O00206840025O00EAAD40025O00E8A740025O0020AA40025O00D2A940025O008AA640025O00149E40025O00406F40025O00307740030F3O00412O66656374696E67436F6D626174025O0016B140025O00689540030F3O001ADE4990477D3DCF548D405E3DC95C03063O001F48BB3DE22E030A3O0049734361737461626C65025O00BEB140025O00E89840025O007EAB40025O007AA840025O00207540025O0062AB40030F3O005265747269627574696F6E4175726103103O00D10357C04E7C31D70F4CDC787F31D10703073O0044A36623B2271E03063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O0084B340025O0071B240025O00405140030C3O00977ECEC211B68602AD79D5C903083O0071DE10BAA763D5E3030C3O00496E74657263652O73696F6E03093O004973496E52616E6765026O003E40026O008540026O00774003133O002700EFF33C0DFEE53D07F4F86E1AFAE4290BEF03043O00964E6E9B025O00D88F40030A3O00B7C023E4A90EAB498ACB03083O0020E5A54781C47EDF025O006EAF40025O003EA540030A3O00526564656D7074696F6E03113O00D18CC0848CC5D780CB8F2OC1C29BC3849503063O00B5A3E9A42OE1025O00606E40025O00A4B140027O0040026O001440025O00207240025O0074A540030A3O00628E3A725D9B2A7E5F8503043O001730EB5E030A3O004EDFDC585A23C675D5D603073O00B21CBAB83D375303073O0049735265616479025O003EAD40025O00389D40025O000C9E40025O00F9B14003133O00526564656D7074696F6E4D6F7573656F76657203143O00D6C84339FF1EE1CDC2497CFF01E0D7C8482AF71C03073O0095A4AD275C926E030C3O00DA29041A0818F63403162O1503063O007B9347707F7A03093O00486F6C79506F776572026O000840030C3O00E5C3967454CFC891624F2OC303053O0026ACADE211025O00EAAE40025O0066A04003153O00496E74657263652O73696F6E4D6F7573656F76657203163O00641F38EA5F1229FC5E1823E10D1C23FA5E1423F9482O03043O008F2D714C030D3O00546172676574497356616C6964025O004CAF40025O00288740025O00A07240025O00ECA940025O006EA240025O002AAD40025O00109240025O0040A940025O00F4B140025O00C4A240025O003CA040025O00606440025O00488840025O00C4A340025O0042AD40025O0036A540025O0014B040025O00088740024O0080B3C540030C3O00466967687452656D61696E732O033O00474344025O004EB340025O00CC9A40025O005C9240025O00D4AF40025O00449540025O0086B240025O0058AF40025O00D0AF4003103O00426F2O73466967687452656D61696E73025O003EA740025O0048B140025O00BEAD40025O00F09340025O00A4A640025O00F09040025O0058A140025O0009B140025O00C05940025O00EEAF40025O00B8A740025O002CA440025O00E06F40026O008340025O00806C40030F3O0048616E646C65412O666C6963746564030D3O00436C65616E7365546F78696E7303163O00436C65616E7365546F78696E734D6F7573656F766572026O004440025O001CAF40025O00F8A640025O0016B040025O00F4AB40025O009EAD40025O004CB240025O00DEA640025O00388E40030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572025O00C6A640025O00D49D40025O00B88340025O00E2A640025O00D08340025O00C6A140025O000C9140025O00C2A540025O00507540025O00E8AE40025O001EB240025O0030A640025O00309440025O003EB140025O00EAB240025O0068974003113O0048616E646C65496E636F72706F7265616C03083O005475726E4576696C03113O005475726E4576696C4D6F7573654F766572025O006EAB40025O00809440025O0056B340025O00A8A040025O00408A40025O00EC9240030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573654F766572025O0093B140025O00C09840025O00208D40025O0008AF40026O001840025O00F8AC40025O007DB040025O00C0AC40025O00307E40025O00549640025O00F2A840025O00D0B140025O000CA540031B3O00466F637573556E697457697468446562752O6646726F6D4C69737403073O008A7EDF725A13B403063O007ADA1FB3133E03113O0046722O65646F6D446562752O664C697374026O003940025O00C6A340025O0002AF40025O008AA440025O00707E4003113O0091DAC8D2DAA84BB4D9CBE7DBA440B7D9C003073O0025D3B6ADA1A9C103153O00556E6974486173446562752O6646726F6D4C69737403073O00C73B41D82C72B703073O00D9975A2DB9481B03163O00426C652O73696E676F6646722O65646F6D466F637573025O0014B140025O00B2A640031A3O00C170E20145CA72E02D59C543E10053C678E81F16C073EA1057D703053O0036A31C8772025O00B89140025O00088040025O00108740025O0022A140025O00FEB140025O008CAA40025O00D2AA40025O00ECA340025O00707940025O00349F40025O00F49C40025O00389B40030C3O004570696353652O74696E677303073O00202O82302B5C0703063O003974EDE5574703063O00AEB8FEF772E203073O0027CAD18D87178E025O0014A340025O0008A440025O00BC9640025O0032A04003073O00600980B1A9B59703073O00E43466E7D6C5D02O033O001FEF7003083O00B67E8015AA8AEB7903073O00BFD532E18A162303083O0066EBBA5586E673502O033O0054082D03073O0042376C5E3F12B403163O00476574456E656D696573496E4D656C2O6552616E6765026O002440025O0048B040025O0022AB40025O00E2B140025O00AEA340025O00E0B140025O004AB340025O00E4A640025O00488440025O00F07C40025O0049B340025O002EAF40025O005CAD40025O00C89540025O00A06040025O0023B140025O00F8A14003093O0049734D6F756E746564030C3O00DC211C1933FCFA21281F20F903063O00989F53696A5203083O0042752O66446F776E030C3O00437275736164657241757261026O007B40025O00F07E40025O00CDB040025O00C8A440025O00805040025O00C09640030D3O0082D444E1C85884D46EF3DC4E8003063O003CE1A63192A9025O00D89840025O000AA840025O00708B40025O002CA940025O000BB040025O00149040030D3O000C122A2B0F142O2A203208093C03063O00674F7E4F4A6103093O00466F637573556E6974026O003440025O00CC9C40025O0048AE40025O006BB240025O00189240025O00C06F40025O00B2A940025O00149F40025O002EA540025O00088640026O001C40025O0094A340025O004CAA40025O00C05E40025O00508740025O005CB140025O00F08B40025O00B4A840025O0007B040025O00809540025O00388240025O005EA940025O0030B140030C3O0049734368612O6E656C696E6703093O00497343617374696E67025O0062AD40025O0072A540025O00F6A240025O002EA34003103O00C325BE512873D73EA74C2375F325A75603063O0016874CC8384603103O004865616C746850657263656E74616765025O00208840025O0050B04003103O00446976696E6550726F74656374696F6E031B3O008939EE2D53E4B220EA2B49E48E24F12B53A18935FE2153F28426FD03063O0081ED5098443D030B3O0079AD05FF081F4B45A70AF603073O003831C864937C77025O0082AA40025O0052A540030B3O004865616C746873746F6E6503153O00C43BBEFCD836ACE4C330BAB0C83BB9F5C22DB6E6C903043O0090AC5EDF025O009CA540025O00708440025O004FB040025O00E8B140025O00789D40025O00DBB240025O0084A240025O004C9040025O00D0A14003043O00502O6F6C025O00D88440025O00C05140025O006CA340025O0046A64003133O00576169742F502O6F6C205265736F7572636573025O0020AF40025O00749940025O0052A340025O005EAA40025O0082B140025O00D2A540025O0016B340025O00CC9E40025O00888140025O00A7B14003193O00160AA455211CAA4E2A08E26F210EAE4E2A08E2772B1BAB482A03043O0027446FC2025O0044A440025O00589640025O00CDB240025O00C1B14003173O00E4A3E1D57CA4DEAFE9C051B2D7AAEEC97E87D9B2EEC87703063O00D7B6C687A719025O00288540025O00689640025O0016A64003173O0052656672657368696E674865616C696E67506F74696F6E03233O009F4CEC5A885AE241834EAA408848E641834EAA58825DE3478309EE4D8B4CE45B845FEF03043O0028ED298A031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O0033B340025O001DB34003193O00E366FFF947D075F6F34FD567D2FD4BCB7DF4FF7AC860F3F74403053O002AA7149A98025O00F8A34003253O004EECA7437C364BF2A94763320AF6A7437D2844F9E2527E3543F1AC0275244CFBAC5178374F03063O00412A9EC22211025O0044A840025O0044B340025O00049340025O00707F40025O002FB040025O001C9340025O00ACAA40025O00207C40025O00AAA340025O0076A140030D3O005573654C61794F6E48616E6473030A3O0094B90533B6901D32BCAB03043O005C2OD87C030A3O00446562752O66446F776E03113O00466F7262656172616E6365446562752O66025O00F88C40030A3O004C61796F6E48616E6473025O00907B40025O0007B340031D3O005733B57FF2550DA441F35F219350F15A2BA952BD5F37AA45F3483BBA4503053O009D3B52CC20030C3O001C37F5F3E7EFE0B9313BEFFE03083O00D1585E839A898AB3025O0015B040030C3O00446976696E65536869656C6403173O002CA8D27510260E3120A8C1701A6335272EA4CA6F17353403083O004248C1A41C7E4351025O004EAD40025O00D88640025O008EA740025O003AB240025O003C9040025O00AEB040025O00A6A340025O00309C40025O00405F40025O0042A04003073O00364FEAF40E45FE03043O009362208D2O033O00174CE003073O002B782383AA6636025O00349D40025O0024B340025O0080A740025O00109E40025O00C49B40025O00E0A940025O00707240025O00489240025O00A49D40025O00DCB240025O00F49A40008C062O00124D3O00014O008A000100023O00266B3O0080060100020004483O0080060100264900010008000100030004483O00080001002E07000400282O0100050004483O002E2O0100124D000300013O0026490003000D000100010004483O000D0001002E0700060095000100070004483O00A0000100124D000400013O002E2600090014000100080004483O00140001000EE200020014000100040004483O0014000100124D000300023O0004483O00A000010026490004001A000100010004483O001A0001002E15010A001A0001000B0004483O001A0001002E07000C00F6FF2O000D0004483O000E00012O000501055O0020D000050005000E2O00DC00050002000200065700050040000100010004483O00400001002E72001000400001000F0004483O004000012O0005010500014O0034000600023O00122O000700113O00122O000800126O0006000800024O00050005000600202O0005000500134O00050002000200062O0005002F00013O0004483O002F00012O0005010500034O007300050001000200065700050031000100010004483O00310001002E2600140040000100150004483O00400001002E7200170040000100160004483O00400001002E2600180040000100190004483O004000012O0005010500044O0005010600013O00201601060006001A2O00DC0005000200020006300005004000013O0004483O004000012O0005010500023O00124D0006001B3O00124D0007001C4O0019000500074O001A00056O0005010500053O0006300005009E00013O0004483O009E00012O0005010500053O0020D000050005001D2O00DC0005000200020006300005009E00013O0004483O009E00012O0005010500053O0020D000050005001E2O00DC0005000200020006300005009E00013O0004483O009E00012O0005010500053O0020D000050005001F2O00DC0005000200020006300005009E00013O0004483O009E00012O000501055O0020D00005000500202O0005010700054O00080005000700020006570005009E000100010004483O009E0001002E720022007F000100210004483O007F00012O000501055O0020D000050005000E2O00DC0005000200020006300005007F00013O0004483O007F0001002E070023003F000100230004483O009E00012O0005010500014O0034000600023O00122O000700243O00122O000800256O0006000800024O00050005000600202O0005000500134O00050002000200062O0005009E00013O0004483O009E00012O0005010500044O00F1000600013O00202O0006000600264O000700053O00202O00070007002700122O000900286O0007000900024O000700076O000800016O00050008000200062O00050079000100010004483O00790001002E07002900270001002A0004483O009E00012O0005010500023O00120E0006002B3O00122O0007002C6O000500076O00055O00044O009E0001002E07002D001F0001002D0004483O009E00012O0005010500014O0034000600023O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O0005000500134O00050002000200062O0005009E00013O0004483O009E0001002E260031009E000100300004483O009E00012O0005010500045O00010600013O00202O0006000600324O000700053O00202O00070007002700122O000900286O0007000900024O000700076O000800016O00050008000200062O0005009E00013O0004483O009E00012O0005010500023O00124D000600333O00124D000700344O0019000500074O001A00055O00124D000400023O0004483O000E0001002E26003500A6000100360004483O00A6000100266B000300A6000100370004483O00A6000100124D000100383O0004483O002E2O01002649000300AA000100020004483O00AA0001002E72003A0009000100390004483O000900012O0005010400014O0034000500023O00122O0006003B3O00122O0007003C6O0005000700024O00040004000500202O0004000400134O00040002000200062O000400E700013O0004483O00E700012O0005010400014O0034000500023O00122O0006003D3O00122O0007003E6O0005000700024O00040004000500202O00040004003F4O00040002000200062O000400E700013O0004483O00E700012O000501045O0020D000040004000E2O00DC000400020002000657000400E7000100010004483O00E700012O0005010400063O0020D000040004001D2O00DC000400020002000630000400E700013O0004483O00E700012O0005010400063O0020D000040004001F2O00DC000400020002000630000400E700013O0004483O00E700012O0005010400063O0020D000040004001E2O00DC000400020002000630000400E700013O0004483O00E700012O000501045O0020D00004000400202O0005010600064O0008000400060002000657000400E7000100010004483O00E70001002E26004100E7000100400004483O00E70001002E72004200E7000100430004483O00E700012O0005010400044O0005010500073O0020160105000500442O00DC000400020002000630000400E700013O0004483O00E700012O0005010400023O00124D000500453O00124D000600464O0019000400064O001A00046O000501045O0020D000040004000E2O00DC0004000200020006300004002C2O013O0004483O002C2O012O0005010400014O0034000500023O00122O000600473O00122O000700486O0005000700024O00040004000500202O0004000400134O00040002000200062O0004001F2O013O0004483O001F2O012O000501045O0020D00004000400492O00DC000400020002000E09004A001F2O0100040004483O001F2O012O0005010400014O0034000500023O00122O0006004B3O00122O0007004C6O0005000700024O00040004000500202O00040004003F4O00040002000200062O0004001F2O013O0004483O001F2O012O000501045O0020D000040004000E2O00DC0004000200020006300004001F2O013O0004483O001F2O012O0005010400063O0020D000040004001D2O00DC0004000200020006300004001F2O013O0004483O001F2O012O0005010400063O0020D000040004001F2O00DC0004000200020006300004001F2O013O0004483O001F2O012O0005010400063O0020D000040004001E2O00DC0004000200020006300004001F2O013O0004483O001F2O012O000501045O0020D00004000400202O0005010600064O0008000400060002000630000400212O013O0004483O00212O01002E07004D000D0001004E0004483O002C2O012O0005010400044O0005010500073O00201601050005004F2O00DC0004000200020006300004002C2O013O0004483O002C2O012O0005010400023O00124D000500503O00124D000600514O0019000400064O001A00045O00124D000300373O0004483O0009000100266B0001006D020100380004483O006D02012O0005010300083O0020160103000300522O00730003000100020006570003003A2O0100010004483O003A2O012O000501035O0020D000030003000E2O00DC000300020002000630000300B72O013O0004483O00B72O0100124D000300014O008A000400053O002E72005400AF2O0100530004483O00AF2O0100266B000300AF2O0100020004483O00AF2O01002E26005500402O0100560004483O00402O01002E26005700402O0100580004483O00402O0100266B000400402O0100010004483O00402O0100124D000500013O002E720059007B2O01005A0004483O007B2O010026490005004D2O0100020004483O004D2O01002E26005B007B2O01005C0004483O007B2O0100124D000600014O008A000700073O00266B0006004F2O0100010004483O004F2O0100124D000700013O002E72005E00582O01005D0004483O00582O0100266B000700582O0100020004483O00582O0100124D000500373O0004483O007B2O01002E72005F00522O0100600004483O00522O0100266B000700522O0100010004483O00522O0100124D000800013O002E26006200712O0100610004483O00712O01002E72006400712O0100630004483O00712O0100266B000800712O0100010004483O00712O012O0005010900093O00266B0009006C2O0100650004483O006C2O012O00050109000A3O00201F0009000900664O000A000B6O000B8O0009000B00024O000900094O000501095O0020D00009000900672O00DC0009000200022O00CE0009000C3O00124D000800023O002649000800752O0100020004483O00752O01002E07006800EAFF2O00690004483O005D2O0100124D000700023O0004483O00522O010004483O005D2O010004483O00522O010004483O007B2O010004483O004F2O0100266B000500A22O0100010004483O00A22O0100124D000600014O008A000700073O00266B0006007F2O0100010004483O007F2O0100124D000700013O002649000700862O0100020004483O00862O01002E72006B00882O01006A0004483O00882O0100124D000500023O0004483O00A22O010026490007008C2O0100010004483O008C2O01002E07006C00F8FF2O006D0004483O00822O0100124D000800013O00266B000800912O0100020004483O00912O0100124D000700023O0004483O00822O01000E7F000100952O0100080004483O00952O01002E26006F008D2O01006E0004483O008D2O012O00050109000A3O0020510009000900704O000A000A6O000B00016O0009000B00024O0009000D6O0009000D6O000900093O00122O000800023O00044O008D2O010004483O00822O010004483O00A22O010004483O007F2O01002649000500A62O0100370004483O00A62O01002E72007200472O0100710004483O00472O012O000501065O0020D00006000600492O00DC0006000200022O00CE0006000E3O0004483O00B72O010004483O00472O010004483O00B72O010004483O00402O010004483O00B72O01002E260074003C2O0100730004483O003C2O01000EE20001003C2O0100030004483O003C2O0100124D000400014O008A000500053O00124D000300023O0004483O003C2O01002E2600760013020100750004483O00130201002E2600770013020100780004483O001302012O00050103000F3O0006300003001302013O0004483O0013020100124D000300014O008A000400043O000E7F000100C42O0100030004483O00C42O01002E07007900FEFF2O007A0004483O00C02O0100124D000400013O002E72007C00C52O01007B0004483O00C52O0100266B000400C52O0100010004483O00C52O012O0005010500103O000657000500CE2O0100010004483O00CE2O01002E72007E00E92O01007D0004483O00E92O0100124D000500014O008A000600063O002E07007F3O0001007F0004483O00D02O0100266B000500D02O0100010004483O00D02O0100124D000600013O00266B000600D52O0100010004483O00D52O012O0005010700083O0020B20007000700804O000800013O00202O0008000800814O000900073O00202O00090009008200122O000A00836O0007000A00024O000200073O00062O000200E42O0100010004483O00E42O01002E26008400E92O0100850004483O00E92O012O00EF000200023O0004483O00E92O010004483O00D52O010004483O00E92O010004483O00D02O012O0005010500113O000630000500EF2O013O0004483O00EF2O012O00050105000E3O000E8F003700F32O0100050004483O00F32O01002E61008600F32O0100870004483O00F32O01002E7200890013020100880004483O0013020100124D000500014O008A000600063O002649000500F92O0100010004483O00F92O01002E26008A00F52O01008B0004483O00F52O0100124D000600013O000EE2000100FA2O0100060004483O00FA2O012O0005010700083O0020F60007000700804O000800013O00202O00080008008C4O000900073O00202O00090009008D00122O000A00836O000B00016O0007000B00024O000200073O00062O0002000A020100010004483O000A0201002E72008E00130201008F0004483O001302012O00EF000200023O0004483O001302010004483O00FA2O010004483O001302010004483O00F52O010004483O001302010004483O00C52O010004483O001302010004483O00C02O012O0005010300123O00065700030018020100010004483O00180201002E7200910069020100900004483O0069020100124D000300014O008A000400053O002E2600920021020100930004483O0021020100266B00030021020100010004483O0021020100124D000400014O008A000500053O00124D000300023O002E2600940025020100950004483O00250201000E7F00020027020100030004483O00270201002E720097001A020100960004483O001A0201002E2600990027020100980004483O0027020100266B00040027020100010004483O0027020100124D000500013O00264900050032020100020004483O00320201002E15019B00320201009A0004483O00320201002E26009C00400201009D0004483O004002012O0005010600083O0020D300060006009E4O000700013O00202O00070007009F4O000800073O00202O0008000800A000122O000900286O000A00016O0006000A00024O000200063O00062O0002006902013O0004483O006902012O00EF000200023O0004483O00690201002E0700A10004000100A10004483O0044020100264900050046020100010004483O00460201002E7200A3002C020100A20004483O002C020100124D000600013O002E0700A40004000100A40004483O004B02010026490006004D020100010004483O004D0201002E0700A50012000100A60004483O005D02012O0005010700083O0020C200070007009E4O000800013O00202O0008000800A74O000900073O00202O0009000900A800122O000A00286O000B00016O0007000B00024O000200073O002E2O00AA005C020100A90004483O005C02010006300002005C02013O0004483O005C02012O00EF000200023O00124D000600023O002E2600AB0047020100AC0004483O0047020100266B00060047020100020004483O0047020100124D000500023O0004483O002C02010004483O004702010004483O002C02010004483O006902010004483O002702010004483O006902010004483O001A02012O0005010300134O00730003000100022O0037000200033O00124D000100AD3O00266B000100D00201004A0004483O00D0020100124D000300014O008A000400043O002E2600AE0071020100AF0004483O0071020100266B00030071020100010004483O0071020100124D000400013O000E7F0001007A020100040004483O007A0201002E2600B00099020100B10004483O0099020100124D000500013O002E2600B20092020100B30004483O0092020100264900050081020100010004483O00810201002E2600B40092020100B50004483O009202012O0005010600083O0020ED0006000600B64O000700146O000800023O00122O000900B73O00122O000A00B86O0008000A00024O00070007000800202O0007000700B900122O000800833O00122O000900BA4O00080006000900022O0037000200063O0006300002009102013O0004483O009102012O00EF000200023O00124D000500023O000E7F00020096020100050004483O00960201002E2600BC007B020100BB0004483O007B020100124D000400023O0004483O009902010004483O007B020100266B000400C5020100020004483O00C50201002E7200BE00C1020100BD0004483O00C102012O0005010500014O0034000600023O00122O000700BF3O00122O000800C06O0006000800024O00050005000600202O00050005003F4O00050002000200062O000500C102013O0004483O00C102012O0005010500083O002O200105000500C14O000600156O000700146O000800023O00122O000900C23O00122O000A00C36O0008000A00024O00070007000800202O0007000700B94O00050007000200062O000500C102013O0004483O00C102012O0005010500044O0005010600073O0020160106000600C42O00DC000500020002000657000500BC020100010004483O00BC0201002E7200C500C1020100C60004483O00C102012O0005010500023O00124D000600C73O00124D000700C84O0019000500074O001A00056O0005010500174O00730005000100022O00CE000500163O00124D000400373O002E7200CA0076020100C90004483O00760201002649000400CB020100370004483O00CB0201002E7200CC0076020100CB0004483O0076020100124D000100033O0004483O00D002010004483O007602010004483O00D002010004483O00710201002E2600CE00D4020100CD0004483O00D40201002649000100D6020100020004483O00D60201002E0700CF0040000100D00004483O0014030100124D000300013O002E2600D100DD020100D20004483O00DD0201000EE2003700DD020100030004483O00DD020100124D000100373O0004483O00140301002E7200D400F4020100D30004483O00F4020100266B000300F4020100020004483O00F40201001227010400D54O00CC000500023O00122O000600D63O00122O000700D76O0005000700024O0004000400054O000500023O00122O000600D83O00122O000700D96O0005000700024O0004000400054O000400186O00045O00202O00040004001F4O00040002000200062O000400F302013O0004483O00F302012O003D3O00013O00124D000300373O002649000300FA020100010004483O00FA0201002E1501DB00FA020100DA0004483O00FA0201002E2600DD00D7020100DC0004483O00D70201001227010400D54O00A1000500023O00122O000600DE3O00122O000700DF6O0005000700024O0004000400054O000500023O00122O000600E03O00122O000700E16O0005000700024O0004000400054O000400193O00122O000400D56O000500023O00122O000600E23O00122O000700E36O0005000700024O0004000400054O000500023O00122O000600E43O00122O000700E56O0005000700024O0004000400054O0004001A3O00122O000300023O00044O00D7020100266B000100E0030100370004483O00E0030100124D000300013O00266B00030041030100010004483O004103012O000501045O00203B0004000400E600122O000600E76O0004000600024O0004000B3O002E2O00E800230301000F0004483O002303012O0005010400193O00065700040025030100010004483O00250301002E7200EA0029030100E90004483O002903012O00050104000B4O00F2000400044O00CE0004001B3O0004483O0040030100124D000400014O008A000500053O002E7200EB002B030100B30004483O002B0301000E7F00010031030100040004483O00310301002E7200ED002B030100EC0004483O002B030100124D000500013O002E7200EF0036030100EE0004483O00360301000E7F00010038030100050004483O00380301002E2600F10032030100F00004483O003203012O005E00066O00CE0006000B3O00124D000600024O00CE0006001B3O0004483O004003010004483O003203010004483O004003010004483O002B030100124D000300023O00264900030045030100370004483O00450301002E2600F20047030100F30004483O0047030100124D0001004A3O0004483O00E003010026490003004D030100020004483O004D0301002E1501F4004D030100F50004483O004D0301002E2600F60017030100F70004483O001703012O000501045O0020D000040004000E2O00DC0004000200020006570004007B030100010004483O007B03012O000501045O0020D00004000400F82O00DC0004000200020006300004007B03013O0004483O007B03012O0005010400014O0034000500023O00122O000600F93O00122O000700FA6O0005000700024O00040004000500202O0004000400134O00040002000200062O0004006803013O0004483O006803012O000501045O0020020104000400FB4O000600013O00202O0006000600FC4O00040006000200062O0004006C030100010004483O006C0301002E0B00FD006C030100FE0004483O006C0301002E0700FF001100012O000104483O007B030100124D0004002O012O00124D00050002012O0006D40004007B030100050004483O007B03012O0005010400044O0005010500013O0020160105000500FC2O00DC0004000200020006300004007B03013O0004483O007B03012O0005010400023O00124D00050003012O00124D00060004013O0019000400064O001A00046O000501045O0020D000040004000E2O00DC00040002000200065700040083030100010004483O008303012O00050104001C3O000630000400DE03013O0004483O00DE030100124D000400014O008A000500063O00124D00070005012O00124D00080006012O00061B0107008F030100080004483O008F030100124D000700013O0006710004008F030100070004483O008F030100124D000500014O008A000600063O00124D000400023O00124D000700023O00067100040085030100070004483O0085030100124D000700013O00060100050099030100070004483O0099030100124D00070007012O00124D00080008012O00061B010800C4030100070004483O00C4030100124D000700013O00124D000800013O000601000800A1030100070004483O00A1030100124D00080009012O00124D0009000A012O00061B010800BA030100090004483O00BA03012O00050108001C3O0006BC000600AF030100080004483O00AF03012O0005010800014O00AF000900023O00122O000A000B012O00122O000B000C015O0009000B00024O00080008000900202O00080008003F4O00080002000200062O000600AF030100080004483O00AF03012O0005010600184O0005010800083O00128E0009000D015O0008000800094O000900066O000A00073O00122O000B000E015O000C000C3O00122O000D00BA6O0008000D00024O000200083O00122O000700023O00124D000800023O000601000800C1030100070004483O00C1030100124D0008000F012O00124D00090010012O0006710008009A030100090004483O009A030100124D000500023O0004483O00C403010004483O009A030100124D00070011012O00124D00080012012O00061B01080092030100070004483O0092030100124D000700023O000601000500CF030100070004483O00CF030100124D00070013012O00124D00080014012O00061B01080092030100070004483O0092030100124D00070015012O00124D00080015012O000671000700DE030100080004483O00DE0301000657000200D9030100010004483O00D9030100124D00070016012O00124D00080017012O00061B010700DE030100080004483O00DE03012O00EF000200023O0004483O00DE03010004483O009203010004483O00DE03010004483O0085030100124D000300373O0004483O0017030100124D00030018012O000601000100E7030100030004483O00E7030100124D00030019012O00124D0004001A012O00061B0104000C060100030004483O000C06012O000501035O0020D000030003000E2O00DC000300020002000657000300F4030100010004483O00F403012O00050103001D3O000630000300F403013O0004483O00F403012O0005010300083O0020160103000300522O0073000300010002000657000300F8030100010004483O00F8030100124D0003001B012O00124D0004001C012O0006D40004001B040100030004483O001B040100124D000300014O008A000400043O00124D000500013O000671000300FA030100050004483O00FA030100124D000400013O00124D000500013O00060100040009040100050004483O0009040100124D0005001D012O00124D0006001E012O00065900050005000100060004483O0009040100124D0005001F012O00124D00060020012O000671000500FE030100060004483O00FE03012O00050105001E4O00EB0005000100024O000200053O00122O00050021012O00122O00060022012O00062O00060012040100050004483O0012040100065700020016040100010004483O0016040100124D00050023012O00124D00060024012O0006710005001B040100060004483O001B04012O00EF000200023O0004483O001B04010004483O00FE03010004483O001B04010004483O00FA03012O000501035O0020D000030003000E2O00DC0003000200020006300003008B06013O0004483O008B06012O0005010300083O0020160103000300522O00730003000100020006300003008B06013O0004483O008B06012O000501035O00124D00050025013O00150003000300052O00DC0003000200020006570003008B060100010004483O008B06012O000501035O00124D00050026013O00150003000300052O00DC0003000200020006570003008B060100010004483O008B060100124D000300014O008A000400043O00124D00050027012O00124D00060028012O0006D400060033040100050004483O0033040100124D000500013O00067100050033040100030004483O0033040100124D000400013O00124D000500023O00060100040042040100050004483O0042040100124D00050029012O00124D0006002A012O00067100050095040100060004483O0095040100124D000500013O00124D000600013O0006710005008F040100060004483O008F04012O00050106001F3O0006300006006A04013O0004483O006A04012O0005010600014O0034000700023O00122O0008002B012O00122O0009002C015O0007000900024O00060006000700202O0006000600134O00060002000200062O0006006A04013O0004483O006A04012O000501065O00123C0008002D015O0006000600084O0006000200024O000700203O00062O0006006A040100070004483O006A040100124D0006002E012O00124D0007002F012O0006D40006006A040100070004483O006A04012O0005010600044O00B4000700013O00122O00080030015O0007000700084O00060002000200062O0006006A04013O0004483O006A04012O0005010600023O00124D00070031012O00124D00080032013O0019000600084O001A00066O0005010600214O0034000700023O00122O00080033012O00122O00090034015O0007000900024O00060006000700202O00060006003F4O00060002000200062O0006008E04013O0004483O008E04012O0005010600223O0006300006008E04013O0004483O008E04012O000501065O00123C0008002D015O0006000600084O0006000200024O000700233O00062O0006008E040100070004483O008E040100124D00060035012O00124D00070036012O00061B0107008E040100060004483O008E04012O0005010600044O00B4000700073O00122O00080037015O0007000700084O00060002000200062O0006008E04013O0004483O008E04012O0005010600023O00124D00070038012O00124D00080039013O0019000600084O001A00065O00124D000500023O00124D000600023O00067100050043040100060004483O0043040100124D000400373O0004483O009504010004483O0043040100124D0005004A3O000671000500C4040100040004483O00C4040100124D000500014O008A000600063O00124D0007003A012O00124D0008003B012O00061B0108009A040100070004483O009A040100124D0007003C012O00124D0008003C012O0006710007009A040100080004483O009A040100124D000700013O0006710007009A040100050004483O009A040100124D000600013O00124D0007003D012O00124D0008003E012O0006D4000800AF040100070004483O00AF040100124D000700023O000671000600AF040100070004483O00AF040100124D000400033O0004483O00C4040100124D000700013O000601000600B6040100070004483O00B6040100124D0007003F012O00124D00080040012O000671000700A6040100080004483O00A604012O0005010700244O00730007000100022O0037000200073O000657000200BF040100010004483O00BF040100124D00070041012O00124D00080042012O00061B010800C0040100070004483O00C004012O00EF000200023O00124D000600023O0004483O00A604010004483O00C404010004483O009A040100124D000500033O000671000400D9040100050004483O00D904012O0005010500044O00BF000600013O00122O00070043015O0006000600074O00050002000200062O000500D6040100010004483O00D6040100124D00050044012O00124D00060045012O0006DD000500D6040100060004483O00D6040100124D00050046012O00124D00060047012O0006D40006008B060100050004483O008B060100124D00050048013O00EF000500023O0004483O008B060100124D000500373O00067100040098050100050004483O0098050100124D000500013O00124D000600013O000601000500E4040100060004483O00E4040100124D00060049012O00124D0007004A012O0006710006008E050100070004483O008E05012O0005010600253O000630000600EE04013O0004483O00EE04012O000501065O00121A0108002D015O0006000600084O0006000200024O000700263O00062O00060005000100070004483O00F2040100124D0006004B012O00124D0007004C012O0006D40007005B050100060004483O005B050100124D000600014O008A000700073O00124D000800013O000601000600FF040100080004483O00FF040100124D0008004D012O00124D0009004E012O0006DD000800FF040100090004483O00FF040100124D0008004F012O00124D00090050012O000671000800F4040100090004483O00F4040100124D000700013O00124D00080051012O00124D00090052012O0006D400082O00050100090004484O00050100124D000800013O00067100072O00050100080004484O0005012O0005010800274O00E6000900023O00122O000A0053012O00122O000B0054015O0009000B000200062O00080012050100090004483O0012050100124D00080055012O00124D00090056012O00061B01080034050100090004483O0034050100124D00080057012O00124D00090058012O0006D400090034050100080004483O003405012O0005010800214O00C1000900023O00122O000A0059012O00122O000B005A015O0009000B00024O00080008000900202O00080008003F4O00080002000200062O00080024050100010004483O0024050100124D0008005B012O00124D0009005C012O00067100080034050100090004483O0034050100124D0008005D012O00124D0009005D012O00067100080034050100090004483O003405012O0005010800044O00B4000900073O00122O000A005E015O00090009000A4O00080002000200062O0008003405013O0004483O003405012O0005010800023O00124D0009005F012O00124D000A0060013O00190008000A4O001A00086O0005010800273O00124D00090061012O0006710008005B050100090004483O005B050100124D00080062012O00124D00090063012O0006D40008003D050100090004483O003D05010004483O005B05012O0005010800214O0034000900023O00122O000A0064012O00122O000B0065015O0009000B00024O00080008000900202O00080008003F4O00080002000200062O0008005B05013O0004483O005B050100124D00080066012O00124D00090066012O0006710008005B050100090004483O005B05012O0005010800044O00B4000900073O00122O000A005E015O00090009000A4O00080002000200062O0008005B05013O0004483O005B05012O0005010800023O00120E00090067012O00122O000A0068015O0008000A6O00085O00044O005B05010004484O0005010004483O005B05010004483O00F404012O0005010600284O0005010700093O0006DD00060063050100070004483O0063050100124D00060069012O00124D0007006A012O00061B0107008D050100060004483O008D050100124D000600014O008A000700083O00124D000900023O0006010006006C050100090004483O006C050100124D0009006B012O00124D000A006C012O00061B010900860501000A0004483O0086050100124D000900013O0006710007006C050100090004483O006C050100124D000800013O00124D0009006D012O00124D000A006D012O000671000900700501000A0004483O0070050100124D000900013O00067100080070050100090004483O007005012O0005010900294O00EB0009000100024O000200093O00122O0009006E012O00122O000A006F012O00062O0009008D0501000A0004483O008D05010006300002008D05013O0004483O008D05012O00EF000200023O0004483O008D05010004483O007005010004483O008D05010004483O006C05010004483O008D050100124D000900013O00067100060065050100090004483O0065050100124D000700014O008A000800083O00124D000600023O0004483O0065050100124D000500023O00124D00060070012O00124D00070071012O0006D4000600DD040100070004483O00DD040100124D000600023O000671000500DD040100060004483O00DD040100124D0004004A3O0004483O009805010004483O00DD040100124D000500013O0006710004003B040100050004483O003B040100124D000500013O00124D00060072012O00124D00070072012O00067100060002060100070004483O0002060100124D000600013O00067100050002060100060004483O0002060100122701060073012O000630000600D405013O0004483O00D405012O000501065O00123C0008002D015O0006000600084O0006000200024O0007002A3O00062O000600D4050100070004483O00D405012O0005010600014O0034000700023O00122O00080074012O00122O00090075015O0007000900024O00060006000700202O00060006003F4O00060002000200062O000600D405013O0004483O00D405012O000501065O00127B00080076015O0006000600084O000800013O00122O00090077015O0008000800094O00060008000200062O000600D405013O0004483O00D4050100124D00060078012O00124D00070071012O00061B010600D4050100070004483O00D405012O0005010600044O00BF000700013O00122O00080079015O0007000700084O00060002000200062O000600CF050100010004483O00CF050100124D0006007A012O00124D0007007B012O00061B010700D4050100060004483O00D405012O0005010600023O00124D0007007C012O00124D0008007D013O0019000600084O001A00066O00050106002B3O000630000600F105013O0004483O00F105012O000501065O00123C0008002D015O0006000600084O0006000200024O0007002C3O00062O000600F1050100070004483O00F105012O0005010600014O0034000700023O00122O0008007E012O00122O0009007F015O0007000900024O00060006000700202O0006000600134O00060002000200062O000600F105013O0004483O00F105012O000501065O00128200080076015O0006000600084O000800013O00122O00090077015O0008000800094O00060008000200062O000600F5050100010004483O00F5050100124D000600DD3O00124D00070080012O0006D400070001060100060004483O000106012O0005010600044O00B4000700013O00122O00080081015O0007000700084O00060002000200062O0006000106013O0004483O000106012O0005010600023O00124D00070082012O00124D00080083013O0019000600084O001A00065O00124D000500023O00124D000600023O0006710005009C050100060004483O009C050100124D000400023O0004483O003B04010004483O009C05010004483O003B04010004483O008B06010004483O003304010004483O008B060100124D00030084012O00124D00040085012O0006D40004004B060100030004483O004B060100124D000300013O0006710001004B060100030004483O004B060100124D000300014O008A000400043O00124D000500013O0006010003001C060100050004483O001C060100124D00050086012O00124D00060087012O0006D400060015060100050004483O0015060100124D000400013O00124D00050088012O00124D00060089012O0006D40005002A060100060004483O002A060100124D000500373O00060100040028060100050004483O0028060100124D0005008A012O00124D0006008B012O0006D40005002A060100060004483O002A060100124D000100023O0004483O004B060100124D000500013O00067100040032060100050004483O003206012O00050105002D4O00500005000100012O00050105002E4O005000050001000100124D000400023O00124D0005008C012O00124D0006008D012O0006D40005001D060100060004483O001D060100124D000500023O0006710004001D060100050004483O001D06012O00050105002F4O00500005000100010012A3000500D56O000600023O00122O0007008E012O00122O0008008F015O0006000800024O0005000500064O000600023O00122O00070090012O00122O00080091015O0006000800024O0005000500064O0005001D3O00122O000400373O00044O001D06010004483O004B06010004483O0015060100124D000300AD3O00060100030052060100010004483O0052060100124D00030092012O00124D00040093012O00067100030004000100040004483O0004000100124D00030094012O00124D00040095012O0006D400040059060100030004483O005906010006300002005906013O0004483O005906012O00EF000200024O0005010300153O00065700030060060100010004483O0060060100124D00030096012O00124D00040097012O00061B01040077060100030004483O007706012O00050103001C3O0006300003007706013O0004483O0077060100124D000300013O00124D00040098012O00124D00050098012O0006710004006B060100050004483O006B060100124D000400013O0006010003006F060100040004483O006F060100124D00040099012O00124D0005009A012O0006D400050064060100040004483O006406012O0005010400304O00730004000100022O0037000200043O0006300002007706013O0004483O007706012O00EF000200023O0004483O007706010004483O006406012O0005010300314O00730003000100022O0037000200033O0006300002007D06013O0004483O007D06012O00EF000200023O00124D00010018012O0004483O000400010004483O008B060100124D0003009B012O00124D0004009C012O00061B01040002000100030004483O0002000100124D000300013O0006713O0002000100030004483O0002000100124D000100014O008A000200023O00124D3O00023O0004483O000200012O003D3O00017O00063O00028O00025O00C08B40025O0080874003053O005072696E7403323O002822461E24EF0EFA13285C4C1DEC17EF1E2E5C4C2FF45BCB0A2E51426DDE0EFE0A28401828E95BEC03674A272CE31EFA156903083O008E7A47326C4D8D7B00113O00124D3O00013O002E2600030001000100020004483O0001000100266B3O0001000100010004483O000100012O00052O015O0020032O01000100044O000200013O00122O000300053O00122O000400066O000200046O00013O00014O000100026O00010001000100044O001000010004483O000100012O003D3O00017O00", GetFEnv(), ...);

