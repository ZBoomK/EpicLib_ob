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
				if (Enum <= 144) then
					if (Enum <= 71) then
						if (Enum <= 35) then
							if (Enum <= 17) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
										elseif (Enum == 2) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 7) then
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
									else
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Inst[3]));
										end
									end
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum == 9) then
											if (Inst[2] < Stk[Inst[4]]) then
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
									elseif (Enum == 11) then
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
								elseif (Enum <= 15) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 16) then
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
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum == 18) then
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 20) then
										Upvalues[Inst[3]] = Stk[Inst[2]];
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
								elseif (Enum <= 23) then
									if (Enum > 22) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 24) then
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 25) then
									if not Stk[Inst[2]] then
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
							elseif (Enum <= 30) then
								if (Enum <= 28) then
									if (Enum > 27) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 29) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 32) then
								if (Enum == 31) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 33) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 34) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 53) then
							if (Enum <= 44) then
								if (Enum <= 39) then
									if (Enum <= 37) then
										if (Enum == 36) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 38) then
										local B;
										local A;
										Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 41) then
									if (Enum > 40) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 42) then
									Stk[Inst[2]]();
								elseif (Enum > 43) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 48) then
								if (Enum <= 46) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 47) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 50) then
								if (Enum == 49) then
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
							elseif (Enum <= 51) then
								local B;
								local A;
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
							elseif (Enum == 52) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							end
						elseif (Enum <= 62) then
							if (Enum <= 57) then
								if (Enum <= 55) then
									if (Enum == 54) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 56) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 59) then
								if (Enum == 58) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 60) then
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
							elseif (Enum == 61) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 66) then
							if (Enum <= 64) then
								if (Enum == 63) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 65) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 68) then
							if (Enum > 67) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								do
									return;
								end
							end
						elseif (Enum <= 69) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 70) then
							local B;
							local A;
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
					elseif (Enum <= 107) then
						if (Enum <= 89) then
							if (Enum <= 80) then
								if (Enum <= 75) then
									if (Enum <= 73) then
										if (Enum == 72) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 74) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 77) then
									if (Enum > 76) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 78) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 79) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Enum <= 82) then
									if (Enum > 81) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum > 83) then
									local B;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 86) then
								if (Enum > 85) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									local Edx;
									local Results, Limit;
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
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
							elseif (Enum == 88) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
						elseif (Enum <= 98) then
							if (Enum <= 93) then
								if (Enum <= 91) then
									if (Enum > 90) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, Top);
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
								elseif (Enum > 92) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									do
										return Stk[Inst[2]];
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
								end
							elseif (Enum <= 96) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum == 97) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 102) then
							if (Enum <= 100) then
								if (Enum == 99) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 101) then
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
						elseif (Enum <= 104) then
							if (Enum > 103) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 105) then
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 106) then
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
						else
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 125) then
						if (Enum <= 116) then
							if (Enum <= 111) then
								if (Enum <= 109) then
									if (Enum > 108) then
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
								elseif (Enum > 110) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								end
							elseif (Enum <= 113) then
								if (Enum == 112) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 114) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 115) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 120) then
							if (Enum <= 118) then
								if (Enum > 117) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum > 119) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 122) then
							if (Enum == 121) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 123) then
							local B;
							local A;
							Stk[Inst[2]] = Inst[3];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum == 124) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 134) then
						if (Enum <= 129) then
							if (Enum <= 127) then
								if (Enum > 126) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 128) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum > 130) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							else
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 132) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 133) then
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
						elseif Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 139) then
						if (Enum <= 136) then
							if (Enum > 135) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 137) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum == 138) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 141) then
						if (Enum == 140) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 142) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 143) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						do
							return Stk[A](Unpack(Stk, A + 1, Top));
						end
					end
				elseif (Enum <= 216) then
					if (Enum <= 180) then
						if (Enum <= 162) then
							if (Enum <= 153) then
								if (Enum <= 148) then
									if (Enum <= 146) then
										if (Enum > 145) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 147) then
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
								elseif (Enum <= 150) then
									if (Enum > 149) then
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
								elseif (Enum <= 151) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 152) then
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 157) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 156) then
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
										if (Mvm[1] == 182) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 159) then
								if (Enum > 158) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 160) then
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
							elseif (Enum == 161) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 171) then
							if (Enum <= 166) then
								if (Enum <= 164) then
									if (Enum > 163) then
										Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 165) then
									local Edx;
									local Results, Limit;
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
							elseif (Enum <= 168) then
								if (Enum == 167) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								else
									Stk[Inst[2]] = not Stk[Inst[3]];
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
								if (Inst[2] > Stk[Inst[4]]) then
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
						elseif (Enum <= 175) then
							if (Enum <= 173) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 174) then
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
						elseif (Enum <= 177) then
							if (Enum == 176) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 178) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 179) then
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
						elseif (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 198) then
						if (Enum <= 189) then
							if (Enum <= 184) then
								if (Enum <= 182) then
									if (Enum > 181) then
										Stk[Inst[2]] = Stk[Inst[3]];
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
								elseif (Enum > 183) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 186) then
								if (Enum == 185) then
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
							elseif (Enum <= 187) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 188) then
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
						elseif (Enum <= 193) then
							if (Enum <= 191) then
								if (Enum == 190) then
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
							elseif (Enum == 192) then
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
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 195) then
							if (Enum > 194) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 196) then
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
						elseif (Enum == 197) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 207) then
						if (Enum <= 202) then
							if (Enum <= 200) then
								if (Enum > 199) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								end
							elseif (Enum == 201) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum > 203) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 205) then
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
						elseif (Enum == 206) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Inst[2] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 211) then
						if (Enum <= 209) then
							if (Enum == 208) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum > 210) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 213) then
						if (Enum > 212) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
				elseif (Enum <= 252) then
					if (Enum <= 234) then
						if (Enum <= 225) then
							if (Enum <= 220) then
								if (Enum <= 218) then
									if (Enum > 217) then
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
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
							elseif (Enum <= 222) then
								if (Enum > 221) then
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
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 223) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum > 224) then
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 229) then
							if (Enum <= 227) then
								if (Enum == 226) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 228) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 231) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 232) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum == 233) then
							local B;
							local A;
							Stk[Inst[2]] = Inst[3];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 243) then
						if (Enum <= 238) then
							if (Enum <= 236) then
								if (Enum > 235) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									local B;
									local A;
									Stk[Inst[2]] = Inst[3];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum > 237) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 240) then
							if (Enum > 239) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 241) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
					elseif (Enum <= 247) then
						if (Enum <= 245) then
							if (Enum == 244) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							else
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 246) then
							local A;
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 249) then
						if (Enum > 248) then
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
					elseif (Enum <= 250) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 251) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = {};
					end
				elseif (Enum <= 270) then
					if (Enum <= 261) then
						if (Enum <= 256) then
							if (Enum <= 254) then
								if (Enum > 253) then
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
							elseif (Enum == 255) then
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
						elseif (Enum <= 258) then
							if (Enum == 257) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 259) then
							VIP = Inst[3];
						elseif (Enum > 260) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 265) then
						if (Enum <= 263) then
							if (Enum > 262) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 264) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 267) then
						if (Enum == 266) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
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
					elseif (Enum <= 268) then
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
					elseif (Enum > 269) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 279) then
					if (Enum <= 274) then
						if (Enum <= 272) then
							if (Enum == 271) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 273) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 276) then
						if (Enum > 275) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 277) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, A + Inst[3]);
						end
					elseif (Enum > 278) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 284) then
					if (Enum <= 281) then
						if (Enum == 280) then
							if (Inst[2] <= Inst[4]) then
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
					elseif (Enum <= 282) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 283) then
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
						Stk[Inst[2]] = Inst[3];
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
				elseif (Enum <= 286) then
					if (Enum > 285) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 287) then
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD98CC60CC3CAD437D98BD511C5C6D831EFB4C950DDD6DA03083O007EB1A3BB4586DBA7031B3O0059CAD1456804D36EC8D152450CE26ED5CC585427DB73D49651423203073O00B21CBAB83D3753002E3O0012A03O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000403012O000A00010012A7000300063O00208A0004000300070012A7000500083O00208A0005000500090012A7000600083O00208A00060006000A00069C00073O000100062O00B63O00064O00B68O00B63O00044O00B63O00014O00B63O00024O00B63O00053O00208A00080003000B00208A00090003000C2O00FC000A5O0012A7000B000D3O00069C000C0001000100022O00B63O000A4O00B63O000B4O00B6000D00073O001218000E000E3O001218000F000F4O001E000D000F000200069C000E0002000100032O00B63O00074O00B63O00094O00B63O00084O0087000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O002B00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00FD00076O00D7000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004EA0003000500012O00FD000300054O00B6000400024O0008000300044O005B00036O00433O00017O000F3O00028O00025O002DB140025O009CAE40026O00F03F025O00608840025O00E2A840025O0004A940025O00D6AF40026O005040025O0034A140025O00B08540025O00F4AC40025O0078AE40025O0094A640025O0072A44001403O001218000200014O000A010300043O002E180103000900010002000403012O000900010026090102000900010001000403012O00090001001218000300014O000A010400043O001218000200043O0026D90002000D00010004000403012O000D0001002EB1000500F7FF2O0006000403012O00020001001218000500013O0026D90005001200010001000403012O00120001002E180108000E00010007000403012O000E00010026090103001800010004000403012O001800012O00B6000600044O000701076O009000066O005B00065O0026090103000D00010001000403012O000D0001001218000600014O000A010700073O002EB100093O00010009000403012O001C00010026090106001C00010001000403012O001C0001001218000700013O002E18010B00270001000A000403012O002700010026090107002700010004000403012O00270001001218000300043O000403012O000D0001002E18010C00210001000D000403012O002100010026090107002100010001000403012O002100012O00FD00086O0082000400083O002ECF000F00360001000E000403012O0036000100061A0004003600010001000403012O003600012O00FD000800014O00B600096O0007010A6O009000086O005B00085O001218000700043O000403012O00210001000403012O000D0001000403012O001C0001000403012O000D0001000403012O000E0001000403012O000D0001000403012O003F0001000403012O000200012O00433O00017O00403O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203043O0001B9400203073O002654D72976DC4603053O0065022B1EED03053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C201885030C3O00C856B541F9439347EE50A25203043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003043O006B4B0E2103043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D9030A3O00556E69744973556E697403043O006D61746803053O00C1587F1BAB03063O007EA7341074D9026O001440024O0080B3C54003073O00EB212D8DBB17EF03073O009CA84E40E0D47903083O0022F8A0DC1EE1ABCB03043O00AE678EC503073O0061294D2A2C51EA03073O009836483F58453E030A3O00E4D6E148D1C7FA55DBCA03043O003CB4A48E03073O006F5F173B2EE20003073O0072383E6549478D030A3O0088FBD4D0BDEACFCDB7E703043O00A4D889BB03073O00E5E723A0AFF11903073O006BB28651D2C69E030A3O00081C8DD2AF3B1A8BC9A403053O00CA586EE2A603063O0053657441504C025O0040524000A1013O00EC000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400046O00055O00122O000600053O00122O000700066O0005000700024O0005000400054O00065O00122O000700073O00122O000800086O0006000800024O0006000400064O00075O00122O000800093O00122O0009000A6O0007000900024O0007000500074O00085O00122O0009000B3O00122O000A000C6O0008000A00024O0008000500084O00095O00122O000A000D3O00122O000B000E6O0009000B00024O0009000500094O000A5O00122O000B000F3O00122O000C00106O000A000C00024O000A0005000A4O000B5O00122O000C00113O00122O000D00126O000B000D00024O000B0004000B4O000C5O00122O000D00133O00122O000E00146O000C000E00024O000C0004000C00122O000D00046O000E5O00122O000F00153O00122O001000166O000E001000024O000E000D000E4O000F5O00122O001000173O00122O001100186O000F001100024O000F000D000F4O00105O00122O001100193O00122O0012001A6O0010001200024O0010000D00104O00115O00122O0012001B3O00122O0013001C6O0011001300024O0011000D00114O00125O00122O0013001D3O00122O0014001E6O0012001400024O0012000D00124O00135O00122O0014001F3O00122O001500206O0013001500024O0012001200134O00135O001218001400213O001241001500226O0013001500024O0012001200134O00135O00122O001400233O00122O001500246O0013001500024O0013000D00134O00145O00122O001500253O00122O001600266O0014001600024O0013001300144O00145O00122O001500273O00122O001600286O0014001600024O00130013001400122O001400293O00122O0015002A6O00165O00122O0017002B3O00122O0018002C6O0016001800024O00150015001600122O0016002D6O001700176O00188O00198O001A8O001B8O001C00573O00122O0058002E3O00122O0059002E6O005A005A6O005B5O00122O005C002F3O00122O005D00306O005B005D00024O005B000D005B4O005C5O00122O005D00313O00122O005E00326O005C005E00024O005B005B005C4O005C5O00122O005D00333O00122O005E00346O005C005E00024O005C000B005C4O005D5O00122O005E00353O00122O005F00366O005D005F00024O005C005C005D4O005D5O00122O005E00373O00122O005F00386O005D005F00024O005D000C005D4O005E5O00122O005F00393O00122O0060003A6O005E006000024O005D005D005E4O005E5O00122O005F003B3O00122O0060003C6O005E006000024O005E0010005E4O005F5O00122O0060003D3O00122O0061003E6O005F006100024O005E005E005F4O005F8O006000623O00069C00633O000100012O00B63O00083O00069C00640001000100022O00B63O00074O00B63O00083O00069C00650002000100052O00B63O00074O00B63O005C4O00FD8O00FD3O00014O00FD3O00023O00069C00660003000100032O00B63O00074O00B63O005C4O00FD7O00069C00670004000100042O00B63O00644O00B63O005C4O00FD8O00B63O00073O00069C00680005000100082O00B63O00074O00B63O00674O00B63O005C4O00FD8O00B63O00644O00B63O00654O00B63O00114O00B63O00603O00069C006900060001001B2O00B63O005C4O00FD8O00B63O003E4O00B63O000A4O00B63O004A4O00B63O00074O00B63O00114O00B63O005E4O00B63O00394O00B63O00444O00B63O00384O00B63O00434O00B63O003B4O00B63O00464O00B63O005D4O00B63O00404O00B63O004C4O00B63O00414O00B63O004D4O00B63O00534O00B63O003C4O00B63O00474O00B63O00654O00B63O003D4O00B63O00484O00B63O005B4O00B63O00493O00069C006A0007000100042O00B63O00174O00B63O005B4O00B63O005F4O00B63O001A3O00069C006B0008000100072O00B63O00084O00B63O00164O00B63O005C4O00FD8O00B63O00294O00B63O00114O00B63O001E3O00069C006C00090001000C2O00B63O005C4O00FD8O00B63O00244O00B63O00074O00B63O00114O00B63O00604O00B63O00294O00B63O00624O00B63O00684O00B63O00084O00B63O00164O00B63O00263O00069C006D000A0001000E2O00B63O005C4O00FD8O00B63O00244O00B63O00074O00B63O00084O00B63O00114O00B63O00604O00B63O00214O00B63O00624O00B63O00264O00B63O00684O00B63O00294O00B63O00164O00B63O00203O00069C006E000B0001000A2O00B63O00074O00B63O005C4O00FD8O00B63O001D4O00B63O005B4O00B63O00114O00B63O005A4O00B63O00184O00B63O00174O00B63O006B3O00069C006F000C000100342O00B63O00524O00B63O00174O00B63O005B4O00B63O005C4O00B63O005E4O00B63O00574O00B63O00594O00B63O002A4O00B63O00324O00B63O001A4O00FD8O00B63O00114O00B63O00084O00B63O00164O00B63O00264O00B63O00074O00B63O00604O00B63O00284O00B63O00314O00B63O00514O00B63O00684O00B63O005A4O00B63O004B4O00B63O00254O00B63O00304O00B63O001E4O00B63O002B4O00B63O00634O00B63O001C4O00B63O002E4O00B63O002C4O00B63O00334O00B63O006A4O00B63O00224O00B63O002D4O00B63O00344O00B63O003C4O00B63O00654O00B63O00274O00B63O00624O00B63O00674O00B63O003A4O00B63O000D4O00B63O006C4O00B63O00644O00B63O003B4O00B63O00234O00B63O002F4O00B63O00504O00B63O001F4O00B63O006D4O00B63O00693O00069C0070000D000100162O00B63O002F4O00FD8O00B63O002A4O00B63O002E4O00B63O001C4O00B63O00294O00B63O002B4O00B63O00284O00B63O00234O00B63O00254O00B63O00274O00B63O00244O00B63O00264O00B63O00204O00B63O00214O00B63O00224O00B63O001F4O00B63O001D4O00B63O001E4O00B63O00304O00B63O00314O00B63O00323O00069C0071000E000100192O00B63O00374O00FD8O00B63O00354O00B63O00364O00B63O003B4O00B63O003D4O00B63O003A4O00B63O004F4O00B63O00454O00B63O00444O00B63O00484O00B63O00464O00B63O00494O00B63O00384O00B63O003C4O00B63O003E4O00B63O004A4O00B63O00434O00B63O00474O00B63O004B4O00B63O00504O00B63O00514O00B63O005A4O00B63O00394O00B63O00423O00069C0072000F0001000F2O00B63O00404O00FD8O00B63O00414O00B63O004C4O00B63O004D4O00B63O00554O00B63O00564O00B63O00574O00B63O00544O00B63O00534O00B63O00524O00B63O00334O00B63O00344O00B63O002C4O00B63O002D3O00069C00730010000100162O00B63O00184O00FD8O00B63O00194O00B63O001A4O00B63O005C4O00B63O00164O00B63O001B4O00B63O00074O00B63O00614O00B63O00624O00B63O00604O00B63O00084O00B63O005B4O00B63O00594O00B63O00044O00B63O00584O00B63O00174O00B63O006F4O00B63O006E4O00B63O00724O00B63O00714O00B63O00703O00069C00740011000100022O00B63O000D4O00FD7O0020530075000D003F00122O007600406O007700736O007800746O0075007800016O00013O00123O00093O00028O00025O0036AA40025O0021B140026O00F03F025O00F6A740025O0026A14003133O00556E6974476574546F74616C4162736F726273025O00A2A740025O00FAA54000213O0012183O00014O000A2O0100023O0026D93O000600010001000403012O00060001002ECF0003000900010002000403012O00090001001218000100014O000A010200023O0012183O00043O002609012O000200010004000403012O000200010026D90001000F00010001000403012O000F0001002E180105000B00010006000403012O000B00010012A7000300074O00FD00046O00DF0003000200022O00B6000200033O002E180109001A00010008000403012O001A0001000E020001001A00010002000403012O001A00012O0075000300014O00A2000300023O000403012O002000012O007500036O00A2000300023O000403012O00200001000403012O000B0001000403012O00200001000403012O000200012O00433O00017O00043O00030C3O00497354616E6B696E67416F45026O00304003093O00497354616E6B696E6703073O00497344752O6D7900114O00597O00206O000100122O000200028O0002000200064O000F00010001000403012O000F00012O00FD7O0020895O00032O00FD000200014O001E3O0002000200061A3O000F00010001000403012O000F00012O00FD3O00013O0020895O00042O00DF3O000200022O00A23O00024O00433O00017O000B3O0003063O0042752O665570030A3O0049676E6F72655061696E028O00026O00F03F03063O00D3008BF9DED003053O00AAA36FE29703143O00412O7461636B506F77657244616D6167654D6F64026O000C4003113O00566572736174696C697479446D67506374026O00594003083O0041757261496E666F003F4O00317O00206O00014O000200013O00202O0002000200026O0002000200064O003C00013O000403012O003C00010012183O00034O000A2O0100033O001218000400033O0026090104000A00010003000403012O000A0001002609012O001900010004000403012O001900012O00FD000500023O0012BE000600053O00122O000700066O0005000700024O00050002000500202O00030005000400062O0003001700010001000403012O001700012O00C700056O0075000500014O00A2000500023O002609012O000900010003000403012O000900012O00FD00055O0020690005000500074O00050002000200202O0005000500084O000600033O00122O000700046O00085O00202O0008000800094O00080002000200202O00080008000A4O0006000800022O00FD000700043O001254000800046O00095O00202O0009000900094O00090002000200202O00090009000A4O0007000900024O0006000600074O0001000500064O00055O00202O00050005000B2O00FD000700013O00208C0007000700024O000800086O000900016O0005000900024O000200053O00124O00043O00044O00090001000403012O000A0001000403012O00090001000403012O003E00012O00753O00014O00A23O00024O00433O00017O000D3O00025O00D8A240025O0040764003063O0042752O665570030A3O0049676E6F72655061696E028O00025O002CA040025O004C9240026O00F03F025O000CB040025O00BCAE4003083O0042752O66496E666F03063O00013FBB365A2403073O00497150D2582E5700323O002E180102002F00010001000403012O002F00012O00FD7O0020745O00034O000200013O00202O0002000200046O0002000200064O002F00013O000403012O002F00010012183O00054O000A2O0100023O002ECF0007001200010006000403012O00120001000EA30005001200013O000403012O00120001001218000100054O000A010200023O0012183O00083O002609012O000B00010008000403012O000B0001000EA30005001400010001000403012O00140001001218000300053O0026D90003001B00010005000403012O001B0001002ECF000900170001000A000403012O001700012O00FD00045O00205F00040004000B4O000600013O00202O0006000600044O000700076O000800016O0004000800024O000200046O000400023O00122O0005000C3O00122O0006000D6O0004000600024O00040002000400202O0004000400084O000400023O00044O00170001000403012O00140001000403012O00310001000403012O000B0001000403012O003100010012183O00054O00A23O00024O00433O00017O000A3O00030B3O00B224C417EB850EC11DE48A03053O0087E14CAD7203073O0049735265616479030B3O0042752O6652656D61696E73030F3O00536869656C64426C6F636B42752O66026O00324003103O003FE3BCA5BEB4A91DC9BDB6A9B3B41FFE03073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65026O002840002A4O00FD8O00833O000100020006853O002800013O000403012O002800012O00FD3O00014O00BC000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O002800013O000403012O002800012O00FD3O00033O0020725O00044O000200013O00202O0002000200056O0002000200264O001F00010006000403012O001F00012O00FD3O00014O000D2O0100023O00122O000200073O00122O000300086O0001000300028O000100206O00096O0002000200064O002800010001000403012O002800012O00FD3O00033O00201F5O00044O000200013O00202O0002000200056O0002000200264O00270001000A000403012O002700012O00C78O00753O00014O00A23O00024O00433O00017O001B3O00028O00026O00F03F03043O0052616765025O00804140027O0040025O0056AB40025O00DEAA4003113O0089D81DFF6AF7A1D40AF976F19ED51FE56C03063O0096CDBD70901803073O0049735265616479025O00608B40025O00CEA940025O00D4A640025O00D4AB40025O0076A440025O00A89440030A3O0049676E6F72655061696E03173O002C83B143168D2E00248DB10C168916156587BE5C148D1503083O007045E4DF2C64E871025O0025B040025O00C8A24003073O00526576656E676503133O00C61A11D6B87B83940D06D4B33C85D50F17D6B203073O00E6B47F67B3D61C026O005440025O00649640025O00FCA44001673O001218000100014O000A010200043O000EA30002001100010001000403012O001100012O007500036O00FD00055O0020890005000500032O00DF000500020002000EB30004000E00010005000403012O000E00012O00FD000500014O00830005000100022O00A8000400053O000403012O001000012O00C700046O0075000400013O001218000100053O002E180107005600010006000403012O00560001000EA30005005600010001000403012O005600010006850004002800013O000403012O002800012O00FD00055O0020890005000500032O00DF0005000200022O006E000500053O0006990002000B00010005000403012O002700012O00FD000500024O00BC000600033O00122O000700083O00122O000800096O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005002800013O000403012O002800012O0075000300013O002ECF000B00660001000C000403012O006600010006850003006600013O000403012O00660001002E18010D00460001000E000403012O004600012O00FD000500044O00830005000100020006850005004600013O000403012O004600012O00FD000500054O00830005000100020006850005004600013O000403012O00460001002E18011000660001000F000403012O006600012O00FD000500064O0042000600023O00202O0006000600114O000700086O000900016O00050009000200062O0005006600013O000403012O006600012O00FD000500033O001248000600123O00122O000700136O000500076O00055O00044O00660001002E180115006600010014000403012O006600012O00FD000500064O000C010600023O00202O0006000600164O000700076O000700076O00050007000200062O0005006600013O000403012O006600012O00FD000500033O001248000600173O00122O000700186O000500076O00055O00044O00660001000EA30001000200010001000403012O00020001001218000200193O00266D0002006200010004000403012O006200012O00FD00055O0020890005000500032O00DF00050002000200266D0005006200010004000403012O00620001002EB1001A00040001001B000403012O006400012O007500056O00A2000500023O001218000100023O000403012O000200012O00433O00017O00603O00028O00027O0040025O001BB040025O0069B140025O0008AF40025O00A0694003093O0073C6F15348E48554CD03073O00E03AA885363A9203073O004973526561647903103O004865616C746850657263656E7461676503083O00556E69744E616D65025O006CAD40025O00608F40025O00E09B40025O0010A140030E3O00496E74657276656E65466F63757303133O0050585FF8679082055C164FF87383891850404E03083O006B39362B9D15E6E7030A3O00E88318F0B5D8F8DA871D03073O00AFBBEB7195D9BC030A3O0049734361737461626C6503083O0042752O66446F776E030E3O00536869656C6457612O6C42752O6603163O004163746976654D697469676174696F6E4E2O65646564030A3O00536869656C6457612O6C03153O002FA78849EF7D472BAE8D40A32O7D3AAA8F5FEA6F7D03073O00185CCFE12C8319026O00F03F026O000840025O00C49940025O0087B040025O00F2A840025O004EAB40025O00D2B040025O0042AF40025O00ACAD40030E3O00AE0C4B52E153C981084A48ED55F903073O0080EC653F268421030E3O0042692O746572492O6D756E69747903193O00AEA00550B3F9F0A5A41C51B8E2DBB5E91541B0EEC1BFA0074103073O00AFCCC97124D68B03093O006BCD26C83753CD3BD803053O006427AC55BC025O0050B240025O0093B14003093O004C6173745374616E64025O007C9840025O00F0734003143O00A179AA940CBE6CB88E37ED7CBC8636A36BB0963603053O0053CD18D9E0030B3O0063D6B9400F7558C7B7421E03063O001D2BB3D82C7B025O00E7B140025O0062AD40025O00FCAA40025O00B09840030B3O004865616C746873746F6E6503173O00B5DC2140A9D13358B2D7250CB9DC2649B3CA295AB8997303043O002CDDB94003193O0033E24E4D7612EF41517441CF4D5E7F08E94F1F430EF341507D03053O00136187283F03173O009C5935292A22A6553D3C0734AF503A352801A1483A342103063O0051CE3C535B4F03173O0052656672657368696E674865616C696E67506F74696F6E025O001C9940026O00344003253O005CAED6602AD045AD40AC907A2AC241AD40AC906220D744AB40EBD47729C643B747BDD5327B03083O00C42ECBB0124FA32D031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E025O00108E40025O003AB24003193O009C307B1F29ECEEB4297B0C37D3EAB92E771023CBE0AC2B711003073O008FD8421E7E449B025O00A09D40025O00B09A4003253O00AEDA08CAC8B4D6EDA1CD1FD885ABD2E0A6C103CC85B3D8F5A3C7038BC1A6D1E4A4DB04DDC003083O0081CAA86DABA5C3B7025O0022AF40025O00109440030A3O00CFC2C332F4C0FD3CEFCB03043O005D86A5AD030A3O0049676E6F72655061696E025O000C9F40025O0008814003153O00B7F5CFCD28CB8D6EBFFBCF823ECBB47BB0E1C8D43F03083O001EDE92A1A25AAED2030B3O00D74F7C06FC477E0DC65C6903043O006A852E1003103O00417370656374734661766F7242752O66030B3O0052612O6C79696E67437279030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O0020B340025O00B4934003163O004A217FF0434956274CFF4859182476FA5F4E4B2965F903063O00203840139C3A009F012O0012183O00014O000A2O0100013O000EA30001000200013O000403012O00020001001218000100013O000E1B0002000900010001000403012O00090001002EB10003006100010004000403012O00680001001218000200013O0026D90002000E00010001000403012O000E0001002E180105006300010006000403012O006300012O00FD00036O00BC000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002900013O000403012O002900012O00FD000300023O0006850003002900013O000403012O002900012O00FD000300033O00208900030003000A2O00DF0003000200022O00FD000400043O0006020103002900010004000403012O002900012O00FD000300033O00202800030003000B4O0003000200024O000400053O00202O00040004000B4O00040002000200062O0003002B00010004000403012O002B0001002ECF000C00380001000D000403012O00380001002ECF000E00380001000F000403012O003800012O00FD000300064O00FD000400073O00208A0004000400102O00DF0003000200020006850003003800013O000403012O003800012O00FD000300013O001218000400113O001218000500124O0008000300054O005B00036O00FD00036O00BC000400013O00122O000500133O00122O000600146O0004000600024O00030003000400202O0003000300154O00030002000200062O0003006200013O000403012O006200012O00FD000300083O0006850003006200013O000403012O006200012O00FD000300053O0020740003000300164O00055O00202O0005000500174O00030005000200062O0003006200013O000403012O006200012O00FD000300053O00208900030003000A2O00DF0003000200022O00FD000400093O0006990003000600010004000403012O005700012O00FD000300053O0020890003000300182O00DF0003000200020006850003006200013O000403012O006200012O00FD000300064O00FD00045O00208A0004000400192O00DF0003000200020006850003006200013O000403012O006200012O00FD000300013O0012180004001A3O0012180005001B4O0008000300054O005B00035O0012180002001C3O0026090102000A0001001C000403012O000A00010012180001001D3O000403012O00680001000403012O000A00010026D90001006C00010001000403012O006C0001002ECF001F00C00001001E000403012O00C00001001218000200013O002EB10020000600010020000403012O00730001002609010200730001001C000403012O007300010012180001001C3O000403012O00C000010026D90002007700010001000403012O00770001002ECF0022006D00010021000403012O006D0001002ECF0024009700010023000403012O009700012O00FD00036O00BC000400013O00122O000500253O00122O000600266O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009700013O000403012O009700012O00FD0003000A3O0006850003009700013O000403012O009700012O00FD000300053O00208900030003000A2O00DF0003000200022O00FD0004000B3O0006020103009700010004000403012O009700012O00FD000300064O00FD00045O00208A0004000400272O00DF0003000200020006850003009700013O000403012O009700012O00FD000300013O001218000400283O001218000500294O0008000300054O005B00036O00FD00036O00BC000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O0003000300154O00030002000200062O000300AF00013O000403012O00AF00012O00FD0003000C3O000685000300AF00013O000403012O00AF00012O00FD000300053O00208900030003000A2O00DF0003000200022O00FD0004000D3O0006990003000800010004000403012O00B100012O00FD000300053O0020890003000300182O00DF00030002000200061A000300B100010001000403012O00B10001002E18012C00BE0001002D000403012O00BE00012O00FD000300064O00FD00045O00208A00040004002E2O00DF00030002000200061A000300B900010001000403012O00B90001002E18012F00BE00010030000403012O00BE00012O00FD000300013O001218000400313O001218000500324O0008000300054O005B00035O0012180002001C3O000403012O006D00010026092O01002E2O01001D000403012O002E2O012O00FD0002000E4O00BC000300013O00122O000400333O00122O000500346O0003000500024O00020002000300202O0002000200094O00020002000200062O000200D500013O000403012O00D500012O00FD0002000F3O000685000200D500013O000403012O00D500012O00FD000200053O00208900020002000A2O00DF0002000200022O00FD000300103O0006990002000300010003000403012O00D70001002EB10035000F00010036000403012O00E40001002ECF003800E400010037000403012O00E400012O00FD000200064O00FD000300073O00208A0003000300392O00DF000200020002000685000200E400013O000403012O00E400012O00FD000200013O0012180003003A3O0012180004003B4O0008000200044O005B00026O00FD000200113O0006850002009E2O013O000403012O009E2O012O00FD000200053O00208900020002000A2O00DF0002000200022O00FD000300123O0006020102009E2O010003000403012O009E2O01001218000200013O002609010200EE00010001000403012O00EE00012O00FD000300134O0056000400013O00122O0005003C3O00122O0006003D6O00040006000200062O000300F800010004000403012O00F80001000403012O000F2O012O00FD0003000E4O00BC000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003000F2O013O000403012O000F2O012O00FD000300064O00FD000400073O00208A0004000400402O00DF00030002000200061A0003000A2O010001000403012O000A2O01002EB10041000700010042000403012O000F2O012O00FD000300013O001218000400433O001218000500444O0008000300054O005B00036O00FD000300133O0026D9000300142O010045000403012O00142O01002E180147009E2O010046000403012O009E2O012O00FD0003000E4O00BC000400013O00122O000500483O00122O000600496O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009E2O013O000403012O009E2O012O00FD000300064O00FD000400073O00208A0004000400402O00DF00030002000200061A000300262O010001000403012O00262O01002EB1004A007A0001004B000403012O009E2O012O00FD000300013O0012480004004C3O00122O0005004D6O000300056O00035O00044O009E2O01000403012O00EE0001000403012O009E2O010026092O0100050001001C000403012O00050001001218000200013O002609010200352O01001C000403012O00352O01001218000100023O000403012O00050001002E18014F00312O01004E000403012O00312O01002609010200312O010001000403012O00312O012O00FD00036O00BC000400013O00122O000500503O00122O000600516O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005F2O013O000403012O005F2O012O00FD000300143O0006850003005F2O013O000403012O005F2O012O00FD000300053O00208900030003000A2O00DF0003000200022O00FD000400153O0006020103005F2O010004000403012O005F2O012O00FD000300164O00830003000100020006850003005F2O013O000403012O005F2O012O00FD000300064O005D00045O00202O0004000400524O000500066O000700016O00030007000200062O0003005A2O010001000403012O005A2O01002EB10053000700010054000403012O005F2O012O00FD000300013O001218000400553O001218000500564O0008000300054O005B00036O00FD00036O00BC000400013O00122O000500573O00122O000600586O0004000600024O00030003000400202O0003000300094O00030002000200062O000300992O013O000403012O00992O012O00FD000300173O000685000300992O013O000403012O00992O012O00FD000300053O0020740003000300164O00055O00202O0005000500594O00030005000200062O000300992O013O000403012O00992O012O00FD000300053O0020740003000300164O00055O00202O00050005005A4O00030005000200062O000300992O013O000403012O00992O012O00FD000300053O00208900030003000A2O00DF0003000200022O00FD000400183O000602010300852O010004000403012O00852O012O00FD000300193O00208A00030003005B2O008300030001000200061A0003008C2O010001000403012O008C2O012O00FD000300193O00200B00030003005C4O000400186O0005001A6O00030005000200062O000300992O013O000403012O00992O012O00FD000300064O00FD00045O00208A00040004005A2O00DF00030002000200061A000300942O010001000403012O00942O01002ECF005D00992O01005E000403012O00992O012O00FD000300013O0012180004005F3O001218000500604O0008000300054O005B00035O0012180002001C3O000403012O00312O01000403012O00050001000403012O009E2O01000403012O000200012O00433O00017O000B3O00028O00026O003740025O0034AC40025O008EAE40025O0024A44003103O0048616E646C65546F705472696E6B6574026O004440026O00F03F025O008EB040025O00C0554003133O0048616E646C65426F2O746F6D5472696E6B657400373O0012183O00014O000A2O0100013O002ECF0002000200010003000403012O00020001002609012O000200010001000403012O00020001001218000100013O0026092O01002100010001000403012O00210001001218000200013O0026D90002000E00010001000403012O000E0001002ECF0004001C00010005000403012O001C00012O00FD000300013O00201B0103000300064O000400026O000500033O00122O000600076O000700076O0003000700024O00038O00035O00062O0003001B00013O000403012O001B00012O00FD00036O00A2000300023O001218000200083O0026090102000A00010008000403012O000A0001001218000100083O000403012O00210001000403012O000A00010026D90001002500010008000403012O00250001002ECF000900070001000A000403012O000700012O00FD000200013O00201B01020002000B4O000300026O000400033O00122O000500076O000600066O0002000600024O00028O00025O00062O0002003600013O000403012O003600012O00FD00026O00A2000200023O000403012O00360001000403012O00070001000403012O00360001000403012O000200012O00433O00017O00173O00025O00D4A340030E3O004973496E4D656C2O6552616E6765025O001AB040030B3O00165022D6DA11F4015436C803073O0086423857B8BE74030A3O0049734361737461626C65030B3O005468756E646572436C6170025O0086A240025O00BCA44003163O0028391CB51DEE330A3F3D08AB59FB33303F3E04B918FF03083O00555C5169DB798B4103063O00DEBB51577BDA03063O00BF9DD330251C03093O004973496E52616E6765026O002040025O0014AB40025O00A8B14003063O00436861726765030E3O0049735370652O6C496E52616E6765025O00B88D40025O000C904003103O00DC17F50E3DDA5FE40E3FDC10F91E3BCB03053O005ABF7F947C004E3O002EB10001002500010001000403012O002500012O00FD7O0020895O00022O00FD000200014O001E3O000200020006853O002500013O000403012O00250001002EB10003004500010003000403012O004D00012O00FD3O00024O00BC000100033O00122O000200043O00122O000300056O0001000300028O000100206O00066O0002000200064O004D00013O000403012O004D00012O00FD3O00043O0006853O004D00013O000403012O004D00012O00FD3O00054O00FD000100023O00208A0001000100072O00DF3O0002000200061A3O001F00010001000403012O001F0001002ECF0009004D00010008000403012O004D00012O00FD3O00033O0012480001000A3O00122O0002000B8O00029O003O00044O004D00012O00FD3O00063O0006853O003800013O000403012O003800012O00FD3O00024O00BC000100033O00122O0002000C3O00122O0003000D6O0001000300028O000100206O00066O0002000200064O003800013O000403012O003800012O00FD7O0020895O000E0012180002000F4O001E3O000200020006853O003A00013O000403012O003A0001002ECF0011004D00010010000403012O004D00012O00FD3O00054O00192O0100023O00202O0001000100124O00025O00202O0002000200134O000400023O00202O0004000400124O0002000400024O000200028O0002000200064O004800010001000403012O00480001002E180115004D00010014000403012O004D00012O00FD3O00033O001218000100163O001218000200174O00083O00024O005B8O00433O00017O00623O00028O00026O000840025O00649540025O0094A14003073O009E2BBD4EC9501B03083O0069CC4ECB2BA7377E03073O004973526561647903043O0052616765026O003E40026O00444003103O0087AB311C1216CE5291B822171D0DC95603083O0031C5CA437E7364A7030B3O004973417661696C61626C65025O00488D40025O0094AD4003073O00526576656E6765030E3O00255EC92C8E515B775AD02CC0070C03073O003E573BBF49E036026O00F03F025O00288C40025O007AB040025O00ABB240025O009EAF40027O0040025O00A4AF40025O00749540030B3O00245E9685822BBFD31C579303083O00907036E3EBE64ECD030A3O0049734361737461626C6503063O0042752O66557003133O0056696F6C656E744F7574627572737442752O66026O001440030A3O0041766174617242752O6603103O0086261CE8DF4BA3290DF0D57DBC3A0CF903063O003BD3486F9CB0025O00349040025O0026B140025O00FC9540025O00FC9D40030B3O005468756E646572436C6170030E3O004973496E4D656C2O6552616E676503123O005A8FF6234A82F1124D8BE23D0E86EC280ED303043O004D2EE783025O00BCA340025O00D49A4003073O008851A045B453B303043O0020DA34D6025O0080514003143O007D1238BBFCB946684B0134BAF3B5575B5A1E3EA603083O003A2E7751C891D025030D3O00398926A9A7BA336B8D3FA9E9EB03073O00564BEC50CCC9DD025O0048AC40025O005CA040025O00EC9A40025O001EA340030B3O004C8F3B197C823C3474863E03043O007718E74E030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O66025O00BC9240025O00AEAB40025O00449940025O008EA94003123O009625B044D84503BD2EA94BCC00108D28E51803073O0071E24DC52ABC20030A3O00091EFDB03612C7B93B1B03043O00D55A769403073O0048617354696572026O001C4003133O004561727468656E54656E616369747942752O66025O001AA840025O00389240030A3O00536869656C64536C616D03113O004826BD53415F11A75A4C566EB559481B7D03053O002D3B4ED436025O008DB140025O0026AC40025O0036A640025O003EA740030A3O0041497E80F28F414D768803063O00EB122117E59E026O004E40025O00149F40025O00C06540025O00206A40025O00D2A040026O003440025O00909F40025O00D89E4003113O0043B2C8BE5CBEFEA85CBBCCFB51B5C4FB0803043O00DB30DAA1030B3O00D0796947DF4AF2C72O7D5903073O008084111C29BB2F025O000C9540025O0040954003133O00153A13345904202O39510022463B520472576A03053O003D6152665A00B6012O0012183O00013O0026D93O000500010002000403012O00050001002ECF0004003600010003000403012O003600012O00FD00016O00BC000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002600013O000403012O002600012O00FD000100023O0006850001002600013O000403012O002600012O00FD000100033O0020890001000100082O00DF000100020002000EAA0009002800010001000403012O002800012O00FD000100033O0020890001000100082O00DF000100020002000EB3000A002600010001000403012O002600012O00FD00016O000D010200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200202O00010001000D4O00010002000200062O0001002800010001000403012O00280001002ECF000F00B52O01000E000403012O00B52O012O00FD000100044O000C01025O00202O0002000200104O000300056O000300036O00010003000200062O000100B52O013O000403012O00B52O012O00FD000100013O001248000200113O00122O000300126O000100036O00015O00044O00B52O010026D93O003A00010013000403012O003A0001002ECF001500C500010014000403012O00C50001001218000100014O000A010200023O002ECF0017003C00010016000403012O003C00010026092O01003C00010001000403012O003C0001001218000200013O0026090102004500010013000403012O004500010012183O00183O000403012O00C500010026090102004100010001000403012O00410001002ECF001A009300010019000403012O009300012O00FD00036O00BC000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O00030003001D4O00030002000200062O0003009300013O000403012O009300012O00FD000300063O0006850003009300013O000403012O009300012O00FD000300033O00207400030003001E4O00055O00202O00050005001F4O00030005000200062O0003009300013O000403012O009300012O00FD000300073O000E020020009300010003000403012O009300012O00FD000300033O00207400030003001E4O00055O00202O0005000500214O00030005000200062O0003009300013O000403012O009300012O00FD00036O00BC000400013O00122O000500223O00122O000600236O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003009300013O000403012O00930001001218000300014O000A010400043O0026D90003007700010001000403012O00770001002ECF0025007300010024000403012O00730001001218000400013O002E180126007800010027000403012O007800010026090104007800010001000403012O007800012O00FD000500083O0012E9000600206O0005000200014O000500046O00065O00202O0006000600284O000700093O00202O0007000700294O0009000A6O0007000900024O000700076O00050007000200062O0005009300013O000403012O009300012O00FD000500013O0012480006002A3O00122O0007002B6O000500076O00055O00044O00930001000403012O00780001000403012O00930001000403012O00730001002E18012D00C10001002C000403012O00C100012O00FD00036O00BC000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300C100013O000403012O00C100012O00FD000300023O000685000300C100013O000403012O00C100012O00FD000300033O0020890003000300082O00DF000300020002000EB3003000C100010003000403012O00C100012O00FD00036O00BC000400013O00122O000500313O00122O000600326O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300C100013O000403012O00C100012O00FD000300073O000EB3000200C100010003000403012O00C100012O00FD000300044O000C01045O00202O0004000400104O000500056O000500056O00030005000200062O000300C100013O000403012O00C100012O00FD000300013O001218000400333O001218000500344O0008000300054O005B00035O001218000200133O000403012O00410001000403012O00C50001000403012O003C00010026D93O00C900010001000403012O00C90001002E18013500462O010036000403012O00462O01001218000100014O000A010200023O0026092O0100CB00010001000403012O00CB0001001218000200013O000EA3001300D200010002000403012O00D200010012183O00133O000403012O00462O010026D9000200D600010001000403012O00D60001002E18013800CE00010037000403012O00CE00012O00FD00036O00BC000400013O00122O000500393O00122O0006003A6O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300152O013O000403012O00152O012O00FD000300063O000685000300152O013O000403012O00152O012O00FD000300093O00207200030003003B4O00055O00202O00050005003C4O00030005000200262O000300152O010013000403012O00152O01001218000300014O000A010400053O0026D9000300F000010013000403012O00F00001002ECF003E000F2O01003D000403012O000F2O01002ECF003F00F000010040000403012O00F00001002609010400F000010001000403012O00F00001001218000500013O002609010500F500010001000403012O00F500012O00FD000600083O0012E9000700206O0006000200014O000600046O00075O00202O0007000700284O000800093O00202O0008000800294O000A000A6O0008000A00024O000800086O00060008000200062O000600152O013O000403012O00152O012O00FD000600013O001248000700413O00122O000800426O000600086O00065O00044O00152O01000403012O00F50001000403012O00152O01000403012O00F00001000403012O00152O01002609010300EC00010001000403012O00EC0001001218000400014O000A010500053O001218000300133O000403012O00EC00012O00FD00036O00BC000400013O00122O000500433O00122O000600446O0004000600024O00030003000400202O00030003001D4O00030002000200062O000300422O013O000403012O00422O012O00FD0003000B3O000685000300422O013O000403012O00422O012O00FD000300033O0020B900030003004500122O000500093O00122O000600186O00030006000200062O0003002C2O013O000403012O002C2O012O00FD000300073O0026E1000300332O010046000403012O00332O012O00FD000300033O00207400030003001E4O00055O00202O0005000500474O00030005000200062O000300422O013O000403012O00422O01002ECF004900422O010048000403012O00422O012O00FD000300044O000C01045O00202O00040004004A4O000500056O000500056O00030005000200062O000300422O013O000403012O00422O012O00FD000300013O0012180004004B3O0012180005004C4O0008000300054O005B00035O001218000200133O000403012O00CE0001000403012O00462O01000403012O00CB0001002E18014E00010001004D000403012O00010001002609012O000100010018000403012O00010001001218000100013O002E18014F00512O010050000403012O00512O01000EA3001300512O010001000403012O00512O010012183O00023O000403012O000100010026092O01004B2O010001000403012O004B2O012O00FD00026O00BC000300013O00122O000400513O00122O000500526O0003000500024O00020002000300202O00020002001D4O00020002000200062O000200902O013O000403012O00902O012O00FD0002000B3O000685000200902O013O000403012O00902O012O00FD000200033O0020890002000200082O00DF0002000200020026E10002006F2O010053000403012O006F2O012O00FD000200033O00207400020002001E4O00045O00202O00040004001F4O00020004000200062O000200902O013O000403012O00902O012O00FD000200073O002673000200902O010046000403012O00902O01001218000200014O000A010300033O0026D9000200752O010001000403012O00752O01002E18015400712O010055000403012O00712O01001218000300013O0026D90003007A2O010001000403012O007A2O01002ECF005700762O010056000403012O00762O012O00FD000400083O001218000500584O00600004000200012O00FD000400044O004000055O00202O00050005004A4O000600056O000600066O00040006000200062O000400872O010001000403012O00872O01002EB10059000B0001005A000403012O00902O012O00FD000400013O0012480005005B3O00122O0006005C6O000400066O00045O00044O00902O01000403012O00762O01000403012O00902O01000403012O00712O012O00FD00026O00BC000300013O00122O0004005D3O00122O0005005E6O0003000500024O00020002000300202O00020002001D4O00020002000200062O0002009D2O013O000403012O009D2O012O00FD000200063O00061A0002009F2O010001000403012O009F2O01002EB1005F001500010060000403012O00B22O012O00FD000200083O0012E9000300206O0002000200014O000200046O00035O00202O0003000300284O000400093O00202O0004000400294O0006000A6O0004000600024O000400046O00020004000200062O000200B22O013O000403012O00B22O012O00FD000200013O001218000300613O001218000400624O0008000200044O005B00025O001218000100133O000403012O004B2O01000403012O000100012O00433O00017O00833O00028O00027O0040025O006DB140025O00E8AB4003073O00F08400FB37E95D03073O0038A2E1769E598E03073O004973526561647903043O0052616765026O004E4003103O004865616C746850657263656E74616765026O00344003063O0042752O665570030B3O00526576656E676542752O66026O003240030A3O006F0DC9AA2EDC6F09C1A203063O00B83C65A0CF42030C3O00432O6F6C646F776E446F776E025O00804140030A3O00028A75B93D864FB0308F03043O00DC51E21C03083O003ED491E8EBC401D003063O00A773B5E29B8A030B3O004973417661696C61626C65025O0070A640025O00E07340025O00C0814003073O00526576656E676503123O00F027F1597576C3A225E2527E63CFE162B60803073O00A68242873C1B1103073O006152CB7625504F03053O0050242AAE15026O00F03F03073O004578656375746503123O004B0832795B04323A4915397F5C19343A1F4603043O001A2E7057025O0068B04003073O008B26BD71B1B84003083O00D4D943CB142ODF25025O00BDB040025O0064954003123O00A888BED7B48AAD92BD88A6D7A884AB92EBD503043O00B2DAEDC8026O000840030A3O00D40AF3CCEB06C9C5E60F03043O00A987629A030A3O0049734361737461626C65025O0080AB40025O002EB340025O0034A640025O0001B140030A3O00536869656C64536C616D03153O00D87F2D51F137F7D87B2559BD34CDC572365DFE739A03073O00A8AB1744349D53030B3O00C079E0A3212895D77DF4BD03073O00E7941195CD454D030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O6603083O0042752O66446F776E03133O0056696F6C656E744F7574627572737442752O66025O004EAD40025O00AC9940026O001440030B3O005468756E646572436C6170030E3O004973496E4D656C2O6552616E6765025O002FB340025O009CAB4003163O0094AFD2F553FA9298C4F756EFC0A0C2F552ED89A487AF03063O009FE0C7A79B37025O0072A740026O00304003073O00D2EB39D1E2E73903043O00B297935C030F3O0053752O64656E446561746842752O66030B3O00BFE8483617425E89FC583A03073O001AEC9D2C52722C025O0076A640025O006EA94003113O002F36D0583F3AD01B2D2BDB5E3827D61B7C03043O003B4A4EB5026O007740025O009EB040030B3O0082BDF3DEB2B0F4F3BAB4F603043O00B0D6D586030A3O00C7A5BFD1A4526AF8ACBB03073O003994CDD6B4C836025O00E9B240025O0036A140025O0035B240025O00408340025O005C9E40025O0030A54003173O0006F5203A7217EF0A377A13ED7533731CF8273D7552AF6503053O0016729D555403093O00E0CE05C54EE2A9D0CE03073O00C8A4AB73A43D9603093O0044657661737461746503143O00BAF1154490AAF51740C3B9F10D4091B7F74317D103053O00E3DE946325025O007BB040025O00804340025O00FEAE40025O00E2A14003074O00C95F59A631D403053O00D345B12O3A03083O009AE46AE6E8C8A5E003063O00ABD785199589030A3O00CBDD35FDEA22F243F4DC03083O002281A8529A8F509C026O004940025O00988A40025O0056A74003113O0080AA36085D5A8CC5B536054D5C8086F26503073O00E9E5D2536B282E025O001DB340025O00E0604003073O00E45A37D510D54703053O0065A12252B6025O0018A840025O001CA94003123O00ED155CFDCEF6876EEF0857FBC9EB816EB95D03083O004E886D399EBB82E2025O00C4AA40025O00AEA440030B3O000A37ECFF2O3AEBD2323EE903043O00915E5F99030A3O00CEC51DD042B3CEC115D803063O00D79DAD74B52E025O00A09840025O0017B14003173O0021BC9EFCDE30A6B4F1D634A4CBF5DF3BB199FBD975E5D903053O00BA55D4EB92007B022O0012183O00013O0026D93O000500010002000403012O00050001002EB1000300CD00010004000403012O00D000012O00FD00016O00BC000200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001007E00013O000403012O007E00012O00FD000100023O0006850001007E00013O000403012O007E00012O00FD000100033O0020890001000100082O00DF000100020002000EB30009001C00010001000403012O001C00012O00FD000100043O00208900010001000A2O00DF000100020002000E09000B008000010001000403012O008000012O00FD000100033O00207400010001000C4O00035O00202O00030003000D4O00010003000200062O0001003700013O000403012O003700012O00FD000100043O00208900010001000A2O00DF000100020002002673000100370001000B000403012O003700012O00FD000100033O0020890001000100082O00DF000100020002002673000100370001000E000403012O003700012O00FD00016O000D010200013O00122O0003000F3O00122O000400106O0002000400024O00010001000200202O0001000100114O00010002000200062O0001008000010001000403012O008000012O00FD000100033O00207400010001000C4O00035O00202O00030003000D4O00010003000200062O0001004300013O000403012O004300012O00FD000100043O00208900010001000A2O00DF000100020002000E09000B008000010001000403012O008000012O00FD000100033O0020890001000100082O00DF000100020002000EB30009004D00010001000403012O004D00012O00FD000100043O00208900010001000A2O00DF000100020002000E090012007400010001000403012O007400012O00FD000100033O00207400010001000C4O00035O00202O00030003000D4O00010003000200062O0001006800013O000403012O006800012O00FD000100043O00208900010001000A2O00DF0001000200020026730001006800010012000403012O006800012O00FD000100033O0020890001000100082O00DF000100020002002673000100680001000E000403012O006800012O00FD00016O000D010200013O00122O000300133O00122O000400146O0002000400024O00010001000200202O0001000100114O00010002000200062O0001007400010001000403012O007400012O00FD000100033O00207400010001000C4O00035O00202O00030003000D4O00010003000200062O0001007E00013O000403012O007E00012O00FD000100043O00208900010001000A2O00DF000100020002000E020012007E00010001000403012O007E00012O00FD00016O000D010200013O00122O000300153O00122O000400166O0002000400024O00010001000200202O0001000100174O00010002000200062O0001008000010001000403012O00800001002EB10018001100010019000403012O008F0001002EB1001A000F0001001A000403012O008F00012O00FD000100054O000C01025O00202O00020002001B4O000300066O000300036O00010003000200062O0001008F00013O000403012O008F00012O00FD000100013O0012180002001C3O0012180003001D4O0008000100034O005B00016O00FD00016O00BC000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200202O0001000100074O00010002000200062O000100AC00013O000403012O00AC00012O00FD000100073O000685000100AC00013O000403012O00AC00012O00FD000100083O0026092O0100AC00010020000403012O00AC00012O00FD000100054O000C01025O00202O0002000200214O000300066O000300036O00010003000200062O000100AC00013O000403012O00AC00012O00FD000100013O001218000200223O001218000300234O0008000100034O005B00015O002EB10024002300010024000403012O00CF00012O00FD00016O00BC000200013O00122O000300253O00122O000400266O0002000400024O00010001000200202O0001000100074O00010002000200062O000100CF00013O000403012O00CF00012O00FD000100023O000685000100CF00013O000403012O00CF00012O00FD000100043O00208900010001000A2O00DF000100020002000E02000B00CF00010001000403012O00CF00012O00FD000100054O004000025O00202O00020002001B4O000300066O000300036O00010003000200062O000100CA00010001000403012O00CA0001002ECF002700CF00010028000403012O00CF00012O00FD000100013O001218000200293O0012180003002A4O0008000100034O005B00015O0012183O002B3O002609012O006B2O010001000403012O006B2O012O00FD00016O00BC000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200202O00010001002E4O00010002000200062O000100FE00013O000403012O00FE00012O00FD000100093O000685000100FE00013O000403012O00FE0001001218000100014O000A010200023O000EA3000100E100010001000403012O00E10001001218000200013O0026D9000200E800010001000403012O00E80001002ECF003000E40001002F000403012O00E400012O00FD0003000A3O0012180004000B4O0060000300020001002E18013100FE00010032000403012O00FE00012O00FD000300054O000C01045O00202O0004000400334O000500066O000500056O00030005000200062O000300FE00013O000403012O00FE00012O00FD000300013O001248000400343O00122O000500356O000300056O00035O00044O00FE0001000403012O00E40001000403012O00FE0001000403012O00E100012O00FD00016O00BC000200013O00122O000300363O00122O000400376O0002000400024O00010001000200202O00010001002E4O00010002000200062O0001003B2O013O000403012O003B2O012O00FD0001000B3O0006850001003B2O013O000403012O003B2O012O00FD000100043O0020720001000100384O00035O00202O0003000300394O00010003000200262O0001003B2O010020000403012O003B2O012O00FD000100033O00207400010001003A4O00035O00202O00030003003B4O00010003000200062O0001003B2O013O000403012O003B2O01001218000100014O000A010200023O0026092O01001B2O010001000403012O001B2O01001218000200013O000E1B000100222O010002000403012O00222O01002ECF003C001E2O01003D000403012O001E2O012O00FD0003000A3O0012260004003E6O0003000200014O000300056O00045O00202O00040004003F4O000500043O00202O0005000500404O0007000C6O0005000700024O000500056O00030005000200062O000300322O010001000403012O00322O01002EB10041000B00010042000403012O003B2O012O00FD000300013O001248000400433O00122O000500446O000300056O00035O00044O003B2O01000403012O001E2O01000403012O003B2O01000403012O001B2O01002ECF0046006A2O010045000403012O006A2O012O00FD00016O00BC000200013O00122O000300473O00122O000400486O0002000400024O00010001000200202O0001000100074O00010002000200062O0001006A2O013O000403012O006A2O012O00FD000100073O0006850001006A2O013O000403012O006A2O012O00FD000100033O00207400010001000C4O00035O00202O0003000300494O00010003000200062O0001006A2O013O000403012O006A2O012O00FD00016O00BC000200013O00122O0003004A3O00122O0004004B6O0002000400024O00010001000200202O0001000100174O00010002000200062O0001006A2O013O000403012O006A2O01002E18014C006A2O01004D000403012O006A2O012O00FD000100054O000C01025O00202O0002000200214O000300066O000300036O00010003000200062O0001006A2O013O000403012O006A2O012O00FD000100013O0012180002004E3O0012180003004F4O0008000100034O005B00015O0012183O00203O002609012O00CF2O01002B000403012O00CF2O01002ECF005000B42O010051000403012O00B42O012O00FD00016O00BC000200013O00122O000300523O00122O000400536O0002000400024O00010001000200202O00010001002E4O00010002000200062O000100B42O013O000403012O00B42O012O00FD0001000B3O000685000100B42O013O000403012O00B42O012O00FD000100083O000EAA002000902O010001000403012O00902O012O00FD00016O00BC000200013O00122O000300543O00122O000400556O0002000400024O00010001000200202O0001000100114O00010002000200062O000100B42O013O000403012O00B42O012O00FD000100033O00207400010001000C4O00035O00202O00030003003B4O00010003000200062O000100B42O013O000403012O00B42O01001218000100014O000A010200023O0026D9000100962O010001000403012O00962O01002E18015600922O010057000403012O00922O01001218000200013O002ECF005900972O010058000403012O00972O01002609010200972O010001000403012O00972O012O00FD0003000A3O0012260004003E6O0003000200014O000300056O00045O00202O00040004003F4O000500043O00202O0005000500404O0007000C6O0005000700024O000500056O00030005000200062O000300AB2O010001000403012O00AB2O01002EB1005A000B0001005B000403012O00B42O012O00FD000300013O0012480004005C3O00122O0005005D6O000300056O00035O00044O00B42O01000403012O00972O01000403012O00B42O01000403012O00922O012O00FD00016O00BC000200013O00122O0003005E3O00122O0004005F6O0002000400024O00010001000200202O00010001002E4O00010002000200062O0001007A02013O000403012O007A02012O00FD0001000D3O0006850001007A02013O000403012O007A02012O00FD000100054O000C01025O00202O0002000200604O000300066O000300036O00010003000200062O0001007A02013O000403012O007A02012O00FD000100013O001248000200613O00122O000300626O000100036O00015O00044O007A0201002609012O000100010020000403012O00010001001218000100013O002E180164003702010063000403012O003702010026092O01003702010001000403012O00370201002ECF0066001002010065000403012O001002012O00FD00026O00BC000300013O00122O000400673O00122O000500686O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001002013O000403012O001002012O00FD000200073O0006850002001002013O000403012O001002012O00FD000200083O0026090102001002010020000403012O001002012O00FD00026O000D010300013O00122O000400693O00122O0005006A6O0003000500024O00020002000300202O0002000200174O00020002000200062O000200FC2O010001000403012O00FC2O012O00FD00026O00BC000300013O00122O0004006B3O00122O0005006C6O0003000500024O00020002000300202O0002000200174O00020002000200062O0002001002013O000403012O001002012O00FD000200033O0020890002000200082O00DF000200020002000EB3006D001002010002000403012O001002012O00FD000200054O004000035O00202O0003000300214O000400066O000400046O00020004000200062O0002000B02010001000403012O000B0201002ECF006F00100201006E000403012O001002012O00FD000200013O001218000300703O001218000400714O0008000200044O005B00025O002E180173003602010072000403012O003602012O00FD00026O00BC000300013O00122O000400743O00122O000500756O0003000500024O00020002000300202O0002000200074O00020002000200062O0002003602013O000403012O003602012O00FD000200073O0006850002003602013O000403012O003602012O00FD000200083O0026090102003602010020000403012O003602012O00FD000200033O0020890002000200082O00DF000200020002000EB3006D003602010002000403012O003602012O00FD000200054O004000035O00202O0003000300214O000400066O000400046O00020004000200062O0002003102010001000403012O00310201002ECF0077003602010076000403012O003602012O00FD000200013O001218000300783O001218000400794O0008000200044O005B00025O001218000100203O000E1B0020003B02010001000403012O003B0201002ECF007A00D22O01007B000403012O00D22O012O00FD00026O00BC000300013O00122O0004007C3O00122O0005007D6O0003000500024O00020002000300202O00020002002E4O00020002000200062O0002005C02013O000403012O005C02012O00FD0002000B3O0006850002005C02013O000403012O005C02012O00FD000200083O000E090020005E02010002000403012O005E02012O00FD00026O00BC000300013O00122O0004007E3O00122O0005007F6O0003000500024O00020002000300202O0002000200114O00020002000200062O0002005C02013O000403012O005C02012O00FD000200033O00207400020002000C4O00045O00202O00040004003B4O00020004000200062O0002005E02013O000403012O005E0201002EB10080001A00010081000403012O00760201001218000200013O0026090102005F02010001000403012O005F02012O00FD0003000A3O0012E90004003E6O0003000200014O000300056O00045O00202O00040004003F4O000500043O00202O0005000500404O0007000C6O0005000700024O000500056O00030005000200062O0003007602013O000403012O007602012O00FD000300013O001248000400823O00122O000500836O000300056O00035O00044O00760201000403012O005F02010012183O00023O000403012O00010001000403012O00D22O01000403012O000100012O00433O00017O001C3O00028O00030F3O00412O66656374696E67436F6D626174025O00D0A640025O0040A440030B3O00115346E2F536615AF9EC2703053O0099532O3296030A3O0049734361737461626C6503083O0042752O66446F776E030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E67030B3O0042612O746C6553686F7574025O00589140025O0006A64003163O005F7767087FAE724E7E7C0967EB5D4F7370137EA94C4903073O002D3D16137C13CB030C3O00E31319E10E758AD51303F60703073O00D9A1726D95621003063O0042752O665570030C3O0042612O746C655374616E6365025O00809C40025O0036A64003173O0010212C68B0712D332C7DB2771760286EB9771D2D3A7DA803063O00147240581CDC030D3O00546172676574497356616C6964025O00ECA740026O00F03F025O00608640025O00EEB04000953O0012183O00014O000A2O0100013O002609012O000200010001000403012O00020001001218000100013O0026092O01000500010001000403012O000500012O00FD00025O0020890002000200022O00DF0002000200020006850002000E00013O000403012O000E0001002ECF0003006300010004000403012O00630001001218000200014O000A010300033O0026090102001000010001000403012O00100001001218000300013O0026090103001300010001000403012O001300012O00FD000400014O00BC000500023O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400074O00040002000200062O0004003E00013O000403012O003E00012O00FD000400033O0006850004003E00013O000403012O003E00012O00FD00045O00207A0004000400084O000600013O00202O0006000600094O000700016O00040007000200062O0004003100010001000403012O003100012O00FD000400043O00209300040004000A4O000500013O00202O0005000500094O00040002000200062O0004003E00013O000403012O003E00012O00FD000400054O00FD000500013O00208A00050005000B2O00DF00040002000200061A0004003900010001000403012O00390001002E18010D003E0001000C000403012O003E00012O00FD000400023O0012180005000E3O0012180006000F4O0008000400064O005B00046O00FD000400063O0006850004006300013O000403012O006300012O00FD000400014O00BC000500023O00122O000600103O00122O000700116O0005000700024O00040004000500202O0004000400074O00040002000200062O0004006300013O000403012O006300012O00FD00045O0020FB0004000400124O000600013O00202O0006000600134O00040006000200062O0004006300010001000403012O00630001002E180114006300010015000403012O006300012O00FD000400054O00FD000500013O00208A0005000500132O00DF0004000200020006850004006300013O000403012O006300012O00FD000400023O001248000500163O00122O000600176O000400066O00045O00044O00630001000403012O00130001000403012O00630001000403012O001000012O00FD000200043O00208A0002000200182O00830002000100020006850002009400013O000403012O009400012O00FD000200073O0006850002009400013O000403012O00940001002EB10019002900010019000403012O009400012O00FD00025O0020890002000200022O00DF00020002000200061A0002009400010001000403012O00940001001218000200014O000A010300043O000EA3001A008800010002000403012O008800010026090103007600010001000403012O00760001001218000400013O000EA30001007900010004000403012O007900012O00FD000500094O00830005000100022O0015000500084O00FD000500083O0006850005009400013O000403012O009400012O00FD000500084O00A2000500023O000403012O00940001000403012O00790001000403012O00940001000403012O00760001000403012O00940001002E18011B00740001001C000403012O007400010026090102007400010001000403012O00740001001218000300014O000A010400043O0012180002001A3O000403012O00740001000403012O00940001000403012O00050001000403012O00940001000403012O000200012O00433O00017O0085012O00028O00025O00488F40025O00B4A740026O00F03F025O00888E40025O00049D40025O00208B40025O00088C40025O006C9140025O006DB24003113O0048616E646C65496E636F72706F7265616C03113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O002040025O0068A540025O000BB040025O00C07140025O00E08540025O00207840025O0020614003093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O003440030D3O00546172676574497356616C6964025O00D88C40026O001040025O004DB040025O00707640025O00E89A40030E3O00348FB75E0482B05F1594905F019503043O003060E7C2030A3O0049734361737461626C65030E3O005468756E6465726F7573526F6172030E3O004973496E4D656C2O6552616E676503173O00DC521B231DDDBD8CDD49313F16D9BDC3C55B0723598BFF03083O00E3A83A6E4D79B8CF030A3O004834B645BDDF42A97A3103083O00C51B5CDF20D1BB1103063O0042752O665570030A3O0046657276696442752O66025O0034AF40025O00D8AD40025O00409740025O00A49940030A3O00536869656C64536C616D03133O001057CAFE0F5BFCE80F5ECEBB0E5ECAF5430C9203043O009B633FA3027O0040025O00107B40025O0076A14003063O00297F7858CB2B03053O00AE59131921030E3O001C02574FE5882O0D13415AFE880503073O006B4F72322E97E703143O0053706561724F6642617374696F6E506C61796572025O00B89C40025O004EA34003183O002AB6B0289806B8C606A4B43A9E30B8CE79ABB4208479E59803083O00A059C6D549EA59D703063O004B64A6EDCA5A03053O00A52811D49E030E3O00D6C90D3234EADF2A3235F1D0073D03053O004685B96853025O0018A340025O00E2A940025O00CAAC40025O00206740025O00108740025O009C9E40025O002O9440025O002AA84003143O0053706561724F6642617374696F6E437572736F7203183O001755412BDB3B4A4215CB05565023C60A05492BC00A05167203053O00A96425244A026O001440025O0066A440025O0053B14003103O004865616C746850657263656E74616765030F3O001504D4B1F6C3B42704E1A0F9DEBE3403073O00DD5161B2D498B0030F3O00446566656E736976655374616E6365025O00405D40025O003DB340025O00C05A40025O0029B340031E3O00C9E21BFE14DEEE0BFE25DEF31CF519C8A70AF313C1E25DEF1BC3EC14F51D03053O007AAD877D9B025O00608F40025O0086AF40030C3O00A6C014AD3334FB90C00EBA3A03073O00A8E4A160D95F51030C3O0042612O746C655374616E6365025O00E4A540025O00107740031F3O00D9D03A482352E4C23A5D2154DE913954265BDE9120533B17CFD020572659DC03063O0037BBB14E3C4F025O00649740025O0002A440030C3O001EC656EE4ACBA325CF4DEC4303073O00E04DAE3F8B26AF030C3O00536869656C64436861726765030E3O0049735370652O6C496E52616E676503153O009749512B8845672D8C404A298101552F8D4F187DD003043O004EE4213803063O00ED76B31182CB03053O00E5AE1ED26303063O00436861726765025O00808940025O00C09A40030E3O0018E58743EA387916EC8F5FAD6E6D03073O00597B8DE6318D5D025O005AA540025O0036A740030D3O00351BA255B6ED19AE3601B559AA03083O00C96269C736DD8477030F3O00412O66656374696E67436F6D626174025O004EA440025O00A4AF40030D3O00577265636B696E675468726F7703093O004973496E52616E6765026O003E4003133O00AE1E8622093CA2BE339729103ABBF90182280C03073O00CCD96CE3416255025O00C89F4003063O007FD5F4F12DD203063O00A03EA395854C03063O00417661746172030D3O00D7B60C3BC2C4E0002ECAD8E05F03053O00A3B6C06D4F025O00C0A740025O00B0B140025O0058A040025O000AA040025O0090A040025O00BFB240030B3O00DB74E4031949C779E4030703063O002A9311966C70030B3O004865726F69635468726F7703113O0007A33F70EEEB30B2256DE8FF4FAB2C76E903063O00886FC64D1F87025O00BAB140025O00507840025O00E07040025O00D89840025O00649940025O00C4934003093O00162A0FCFF1123312D903053O0095544660A003093O00426C2O6F644675727903113O003A0A02E23C390BF82A1F4DE0390F03AD6C03043O008D58666D030A3O009156D8631F2F5EC8BD5403083O00A1D333AA107A5D35030A3O004265727365726B696E67025O00804940025O00C08C4003113O00F9ABA03BFEBCB921F5A9F225FAA7BC68AD03043O00489BCED2025O0030A740025O00389F40025O001AA840025O006CA540025O00807740025O0046A040025O005FB040025O0040934003093O000D1B3A50898BCD241603073O00A24B724835EBE703093O0046697265626C2O6F64025O00849740025O0009B34003113O008A3556E7510E833340A25E03853204B30103063O0062EC5C248233025O0050AE40025O00B6B140030D3O0085170FBF56BCA731A83A0DB64903083O0050C4796CDA25C8D5030D3O00416E6365737472616C43612O6C025O0080A240025O00DAA34003163O00017D017A581A98017F3D7C4A0286407E0376454EDB5403073O00EA6013621F2B6E025O007DB240025O0007B040026O000840025O00DC9240025O00B1B040030B3O00241E55C8AA46990F1C59D403073O00EB667F32A7CC12030B3O004261676F66547269636B7303163O0051AFF626573A42A0F91C472F5CADB52E45275EE1A47503063O004E30C1954324030D3O006768570F3D434E5B1C2143744003053O0053261A346E025O00549F40025O00C2A340030D3O00417263616E65546F2O72656E7403153O005905244756121852570535435603674B591E29060003043O0026387747025O00D08E40025O000AAC40030E3O00DFE65FDE3145D9FA5CD12853FDFB03063O0036938F38B645030E3O004C69676874734A7564676D656E7403173O00DA88F841CBC5BEF55CDBD18CFA47CB968CFE40D196D0AF03053O00BFB6E19F29030F3O0048616E646C65445053506F74696F6E030A3O0041766174617242752O66025O005EA840025O00E07A40030A3O002O198E1753352E81114F03053O0021507EE07803073O0049735265616479030B3O005261676544656669636974026O002E40030A3O00DFA00AC150E89B0FC55103053O003C8CC863A4030A3O00432O6F6C646F776E5570026O004440030C3O00B4FC0D23AE83D70C27B080F103053O00C2E794644603103O006544C0AEE6C14942D281E3C4514DD3A803063O00A8262CA1C396030B3O004973417661696C61626C65030C3O00B3F48B733CEC951E81EE857303083O0076E09CE2165088D603113O0066EB548F50EF558958E7578771E656955603043O00E0228E39030C3O00FCA8CAD07AFF5A38D1AEC6D803083O006EBEC7A5BD13913D03063O00FBFD76FC8AD503063O00A7BA8B1788EB025O0080464003113O003EB0850208B4840400BC860A29BD87180E03043O006D7AD5E8030C3O00CCF8AD3DE7F9A506E1FEA13503043O00508E97C2030D3O004C6173745374616E6442752O66030E3O0036C8794911D07E4204E0784F16D503043O002C63A61703063O005DE1282232B603063O00C41C97495653030E3O00C60D2715904E1178F4252613974B03083O001693634970E23878030A3O008B7DEBF081BC46EEF48003053O00EDD815829503133O0056696F6C656E744F7574627572737442752O6603123O00AA4B5E49A9FB5B924B4D5CA5DA4D8B41514C03073O003EE22E2O3FD0A903103O00CC14458611083B4CE41B5986280C235203083O003E857935E37F6D4F025O00804B40030A3O00231C3BF0DAAA911C153F03073O00C270745295B6CE030E3O000CA6421DD2F40737AF6A17C3F71D03073O006E59C82C78A08203123O0083C64A505A783E5DAED1485350593242A5D003083O002DCBA32B26232A5B03103O00FB88CC2689AC40C084DE2F829E55DE8903073O0034B2E5BC43E7C9026O003140030A3O0012495901FB58102D405D03073O004341213064973C03123O00F7E2AFCEEAEDE2BEDDE1DCF2BDCBFAD0E9BD03053O0093BF87CEB8026O003240030A3O00B720AFC4D457818829AB03073O00D2E448C6A1B83303103O001F44E3157DCB225BF2127FCB0148FF1C03063O00AE5629937013025O00D2A240025O0026A940030A3O0049676E6F72655061696E03133O0052078304370A2EBB5A09834B280E18A51B52DD03083O00CB3B60ED6B456F7103093O00B1D9AE8EB29383C7A403063O00E4E2B1C1EDD903103O0001BE30F23BA033E736BC26C03BA220E303043O008654D043030D3O0021B98B5E1FA5885B36AD94481B03043O003C73CCE603093O00D435E579E418E47FEA03043O0010875A8B030D3O0066610B31425D76535107215A5C03073O0018341466532E3403093O00497343617374696E67026O00244003093O0053686F636B7761766503113O00D7272E2704D32E37214FC92E282A4F977D03053O006FA44F4144030C3O00F5D18ADB22EEE5D182CC29EF03063O008AA6B9E3BE4E025O00108C40025O00BCA540025O0094A140025O00909B4003153O00D87CCC325E2726C87CC425552659C675CC3912704D03073O0079AB14A5573243025O00A88540030B3O00536869656C64426C6F636B025O00607B4003143O00D530B033B506F93AB539BA098635B83FB742956003063O0062A658D956D9025O005C9B40025O000C9640030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O00C1D7503503063O00BC2O961961E6030E3O00EA86500E4CEBD59B1F2303E892C003063O008DBAE93F626C025O0056B040025O003AB240025O00188340026O001840025O0081B240025O00ADB140025O000FB140025O002EAD4003093O000817BFF502E4D62A1203073O00B74476CC81519003083O0042752O66446F776E030E3O00536869656C6457612O6C42752O66025O00805640030E3O003BA37EE1199407A377C204811BBE03063O00E26ECD10846B030E3O00DECDEEDC53FDCAEEDE67E4C0F5CA03053O00218BA380B903073O00755708CD435D1603043O00BE37386403073O0048617354696572025O00F4A24003093O004C6173745374616E6403143O005AAE2F0A2CF0E757A1385E17E6F553A12F1705E603073O009336CF5C7E7383026O003540025O00CC9E4003063O001D3D3464086C03063O001E6D51551D6D03073O00CD7042B731DBEE03073O009C9F1134D656BE025O00D4A640025O00907B40030D3O0052617661676572506C61796572030F3O00BCEEABBDA9EAAFFCA3EEB4B2EEBDE903043O00DCCE8FDD025O0050AC40025O00C09140025O00EC9F40025O00AEA44003063O0085683F04D7DE03073O00B2E61D4D77B8AC03073O00C7BF1C1A70FDE703063O009895DE6A7B17025O00207640025O00F89740030D3O0052617661676572437572736F72025O0068AD40025O000CB340030F3O00CF27E042B2D834B64EB4D428B611E103053O00D5BD469623025O00B8AC40025O00F8854003113O006B5079075D547801555C7A0F7C5D7B1D5B03043O00682F3514030C3O0081438E11B501A47A8E15BF0A03063O006FC32CE17CDC025O00C6AD40025O00F07340025O00804740025O0008914003113O0044656D6F72616C697A696E6753686F7574025O006C9540025O00A8A640031A3O00DC430D7CB9AAD44F1A7AA5ACE755087CBEBF984B017AA5EB8A1E03063O00CBB8266013CB025O00989140025O00807F40025O0028AD40025O00206840025O0020AA40025O00D2A94003043O00C6CB058203053O0045918A4CD603133O00576169742F502O6F6C205265736F7572636573025O008AA640025O00149E40025O00BEB140025O00E8984000D4072O0012183O00014O000A2O0100023O002ECF0002000900010003000403012O00090001002609012O000900010001000403012O00090001001218000100014O000A010200023O0012183O00043O002609012O000200010004000403012O000200010026D90001000F00010001000403012O000F0001002ECF0006000B00010005000403012O000B0001001218000200013O0026090102009F07010004000403012O009F07012O00FD00035O00061A0003001700010001000403012O00170001002ECF0008005C00010007000403012O005C0001001218000300014O000A010400053O000EA30001001E00010003000403012O001E0001001218000400014O000A010500053O001218000300043O0026090103001900010004000403012O001900010026090104002000010001000403012O00200001001218000500013O0026D90005002700010004000403012O00270001002EB1000900140001000A000403012O003900012O00FD000600023O00205E00060006000B4O000700033O00202O00070007000C4O000800043O00202O00080008000D00122O0009000E6O000A00016O0006000A00024O000600013O002E2O000F005C00010010000403012O005C00012O00FD000600013O0006850006005C00013O000403012O005C00012O00FD000600014O00A2000600023O000403012O005C00010026090105002300010001000403012O00230001001218000600013O002ECF0011004200010012000403012O004200010026090106004200010004000403012O00420001001218000500043O000403012O00230001002E180114003C00010013000403012O003C00010026090106003C00010001000403012O003C00012O00FD000700023O00206A00070007000B4O000800033O00202O0008000800154O000900043O00202O00090009001600122O000A00176O000B00016O0007000B00024O000700016O000700013O0006850007005500013O000403012O005500012O00FD000700014O00A2000700023O001218000600043O000403012O003C0001000403012O00230001000403012O005C0001000403012O00200001000403012O005C0001000403012O001900012O00FD000300023O00208A0003000300182O0083000300010002000685000300D307013O000403012O00D30701001218000300014O000A010400053O0026090103006800010001000403012O00680001001218000400014O000A010500053O001218000300043O002EB1001900FBFF2O0019000403012O006300010026090103006300010004000403012O00630001002609010400542O01001A000403012O00542O01001218000600013O0026D90006007300010004000403012O00730001002EB1001B00540001001C000403012O00C50001002EB1001D002C0001001D000403012O009F00012O00FD000700054O00FD000800063O0006D80007009F00010008000403012O009F00012O00FD000700073O0006850007009F00013O000403012O009F00012O00FD000700083O0006850007008200013O000403012O008200012O00FD000700093O00061A0007008500010001000403012O008500012O00FD000700083O00061A0007009F00010001000403012O009F00012O00FD000700034O00BC0008000A3O00122O0009001E3O00122O000A001F6O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007009F00013O000403012O009F00012O00FD0007000B4O006F000800033O00202O0008000800214O0009000C3O00202O0009000900224O000B000D6O0009000B00024O000900096O00070009000200062O0007009F00013O000403012O009F00012O00FD0007000A3O001218000800233O001218000900244O0008000700094O005B00076O00FD000700034O00BC0008000A3O00122O000900253O00122O000A00266O0008000A00024O00070007000800202O0007000700204O00070002000200062O000700B300013O000403012O00B300012O00FD0007000E3O000685000700B300013O000403012O00B300012O00FD0007000F3O0020FB0007000700274O000900033O00202O0009000900284O00070009000200062O000700B500010001000403012O00B50001002E18012900C40001002A000403012O00C40001002ECF002B00C40001002C000403012O00C400012O00FD0007000B4O000C010800033O00202O00080008002D4O000900106O000900096O00070009000200062O000700C400013O000403012O00C400012O00FD0007000A3O0012180008002E3O0012180009002F4O0008000700094O005B00075O001218000600303O0026090106004F2O010001000403012O004F2O01002E180131003O010032000403012O003O012O00FD000700054O00FD000800063O0006D80007003O010008000403012O003O012O00FD000700113O0006850007003O013O000403012O003O012O00FD000700123O000685000700D600013O000403012O00D600012O00FD000700093O00061A000700D900010001000403012O00D900012O00FD000700123O00061A0007003O010001000403012O003O012O00FD000700134O00290008000A3O00122O000900333O00122O000A00346O0008000A000200062O0007003O010008000403012O003O012O00FD000700034O00BC0008000A3O00122O000900353O00122O000A00366O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007003O013O000403012O003O01001218000700013O000EA3000100EB00010007000403012O00EB00012O00FD000800143O001218000900174O00600008000200012O00FD0008000B4O0040000900043O00202O0009000900374O000A00106O000A000A6O0008000A000200062O000800FA00010001000403012O00FA0001002ECF0039003O010038000403012O003O012O00FD0008000A3O0012480009003A3O00122O000A003B6O0008000A6O00085O00044O003O01000403012O00EB00012O00FD000700054O00FD000800063O0006D80007004E2O010008000403012O004E2O012O00FD000700113O0006850007004E2O013O000403012O004E2O012O00FD000700123O0006850007000E2O013O000403012O000E2O012O00FD000700093O00061A000700112O010001000403012O00112O012O00FD000700123O00061A0007004E2O010001000403012O004E2O012O00FD000700134O00290008000A3O00122O0009003C3O00122O000A003D6O0008000A000200062O0007004E2O010008000403012O004E2O012O00FD000700034O00BC0008000A3O00122O0009003E3O00122O000A003F6O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007004E2O013O000403012O004E2O01001218000700014O000A010800093O002ECF0040002B2O010041000403012O002B2O010026090107002B2O010001000403012O002B2O01001218000800014O000A010900093O001218000700043O0026D90007002F2O010004000403012O002F2O01002E18014200242O010043000403012O00242O01002E180144002F2O010045000403012O002F2O01000EA30001002F2O010008000403012O002F2O01001218000900013O0026D9000900382O010001000403012O00382O01002EB1004600FEFF2O0047000403012O00342O012O00FD000A00143O0012F6000B00176O000A000200014O000A000B6O000B00043O00202O000B000B00484O000C00106O000C000C6O000A000C000200062O000A004E2O013O000403012O004E2O012O00FD000A000A3O001248000B00493O00122O000C004A6O000A000C6O000A5O00044O004E2O01000403012O00342O01000403012O004E2O01000403012O002F2O01000403012O004E2O01000403012O00242O01001218000600043O0026090106006F00010030000403012O006F00010012180004004B3O000403012O00542O01000403012O006F00010026D9000400582O010001000403012O00582O01002E18014D00FE2O01004C000403012O00FE2O012O00FD000600153O000685000600812O013O000403012O00812O012O00FD0006000F3O00208900060006004E2O00DF0006000200022O00FD000700163O000602010600812O010007000403012O00812O012O00FD000600034O00BC0007000A3O00122O0008004F3O00122O000900506O0007000900024O00060006000700202O0006000600204O00060002000200062O000600722O013O000403012O00722O012O00FD0006000F3O0020740006000600274O000800033O00202O0008000800514O00060008000200062O000600742O013O000403012O00742O01002ECF005300812O010052000403012O00812O01002E18015400812O010055000403012O00812O012O00FD0006000B4O00FD000700033O00208A0007000700512O00DF000600020002000685000600812O013O000403012O00812O012O00FD0006000A3O001218000700563O001218000800574O0008000600084O005B00066O00FD000600153O0006850006008A2O013O000403012O008A2O012O00FD0006000F3O00208900060006004E2O00DF0006000200022O00FD000700163O00069D0007008C2O010006000403012O008C2O01002ECF005900AA2O010058000403012O00AA2O012O00FD000600034O00BC0007000A3O00122O0008005A3O00122O0009005B6O0007000900024O00060006000700202O0006000600204O00060002000200062O0006009D2O013O000403012O009D2O012O00FD0006000F3O0020740006000600274O000800033O00202O00080008005C4O00060008000200062O0006009F2O013O000403012O009F2O01002ECF005D00AA2O01005E000403012O00AA2O012O00FD0006000B4O00FD000700033O00208A00070007005C2O00DF000600020002000685000600AA2O013O000403012O00AA2O012O00FD0006000A3O0012180007005F3O001218000800604O0008000600084O005B00065O002E18016100DA2O010062000403012O00DA2O012O00FD000600173O000685000600DA2O013O000403012O00DA2O012O00FD000600183O000685000600B52O013O000403012O00B52O012O00FD000600093O00061A000600B82O010001000403012O00B82O012O00FD000600183O00061A000600DA2O010001000403012O00DA2O012O00FD000600054O00FD000700063O0006D8000600DA2O010007000403012O00DA2O012O00FD000600034O00BC0007000A3O00122O000800633O00122O000900646O0007000900024O00060006000700202O0006000600204O00060002000200062O000600DA2O013O000403012O00DA2O012O00FD000600103O00061A000600DA2O010001000403012O00DA2O012O00FD0006000B4O0032000700033O00202O0007000700654O0008000C3O00202O0008000800664O000A00033O00202O000A000A00654O0008000A00024O000800086O00060008000200062O000600DA2O013O000403012O00DA2O012O00FD0006000A3O001218000700673O001218000800684O0008000600084O005B00066O00FD000600193O000685000600FD2O013O000403012O00FD2O012O00FD000600034O00BC0007000A3O00122O000800693O00122O0009006A6O0007000900024O00060006000700202O0006000600204O00060002000200062O000600FD2O013O000403012O00FD2O012O00FD000600103O00061A000600FD2O010001000403012O00FD2O012O00FD0006000B4O0019010700033O00202O00070007006B4O0008000C3O00202O0008000800664O000A00033O00202O000A000A006B4O0008000A00024O000800086O00060008000200062O000600F82O010001000403012O00F82O01002ECF006D00FD2O01006C000403012O00FD2O012O00FD0006000A3O0012180007006E3O0012180008006F4O0008000600084O005B00065O001218000400043O002609010400A902010004000403012O00A90201001218000600013O0026D90006000502010004000403012O00050201002EB10070005200010071000403012O005502012O00FD000700034O00BC0008000A3O00122O000900723O00122O000A00736O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007002D02013O000403012O002D02012O00FD0007001A3O0006850007002D02013O000403012O002D02012O00FD0007000C3O0020890007000700742O00DF0007000200020006850007002D02013O000403012O002D02012O00FD0007001B4O00830007000100020006850007002D02013O000403012O002D0201002ECF0075002D02010076000403012O002D02012O00FD0007000B4O00F2000800033O00202O0008000800774O0009000C3O00202O00090009007800122O000B00796O0009000B00024O000900096O00070009000200062O0007002D02013O000403012O002D02012O00FD0007000A3O0012180008007A3O0012180009007B4O0008000700094O005B00075O002EB1007C00270001007C000403012O005402012O00FD000700054O00FD000800063O0006D80007005402010008000403012O005402012O00FD0007001C3O0006850007005402013O000403012O005402012O00FD0007001D3O0006850007003C02013O000403012O003C02012O00FD000700093O00061A0007003F02010001000403012O003F02012O00FD0007001D3O00061A0007005402010001000403012O005402012O00FD000700034O00BC0008000A3O00122O0009007D3O00122O000A007E6O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007005402013O000403012O005402012O00FD0007000B4O00FD000800033O00208A00080008007F2O00DF0007000200020006850007005402013O000403012O005402012O00FD0007000A3O001218000800803O001218000900814O0008000700094O005B00075O001218000600303O002609010600A402010001000403012O00A40201002ECF0082008002010083000403012O008002012O00FD000700054O00FD000800063O0006D80007008002010008000403012O008002012O00FD0007001E3O0006850007008002013O000403012O008002012O00FD000700093O0006850007006602013O000403012O006602012O00FD0007001F3O00061A0007006902010001000403012O006902012O00FD0007001F3O00061A0007008002010001000403012O00800201001218000700014O000A010800083O0026D90007006F02010001000403012O006F0201002E180184006B02010085000403012O006B0201001218000800013O002ECF0086007002010087000403012O00700201000EA30001007002010008000403012O007002012O00FD000900204O00830009000100022O0015000900014O00FD000900013O0006850009008002013O000403012O008002012O00FD000900014O00A2000900023O000403012O00800201000403012O00700201000403012O00800201000403012O006B02012O00FD000700213O000685000700A302013O000403012O00A302012O00FD000700034O00BC0008000A3O00122O000900883O00122O000A00896O0008000A00024O00070007000800202O0007000700204O00070002000200062O000700A302013O000403012O00A302012O00FD0007000C3O002089000700070078001218000900794O001E00070009000200061A000700A302010001000403012O00A302012O00FD0007000B4O00F2000800033O00202O00080008008A4O0009000C3O00202O00090009007800122O000B00796O0009000B00024O000900096O00070009000200062O000700A302013O000403012O00A302012O00FD0007000A3O0012180008008B3O0012180009008C4O0008000700094O005B00075O001218000600043O0026090106000102010030000403012O00010201001218000400303O000403012O00A90201000403012O00010201000E1B003000AD02010004000403012O00AD0201002E18018D002F0501008E000403012O002F0501001218000600013O002609010600B303010001000403012O00B30301002E18018F00A903010090000403012O00A903012O00FD000700054O00FD000800063O0006D8000700A903010008000403012O00A903012O00FD000700223O000685000700A903013O000403012O00A903012O00FD000700233O000685000700BF02013O000403012O00BF02012O00FD000700093O00061A000700C202010001000403012O00C202012O00FD000700233O00061A000700A903010001000403012O00A90301001218000700013O002ECF009200FE02010091000403012O00FE0201002609010700FE02010001000403012O00FE0201001218000800013O002609010800F702010001000403012O00F702012O00FD000900034O00BC000A000A3O00122O000B00933O00122O000C00946O000A000C00024O00090009000A00202O0009000900204O00090002000200062O000900DF02013O000403012O00DF02012O00FD0009000B4O00FD000A00033O00208A000A000A00952O00DF000900020002000685000900DF02013O000403012O00DF02012O00FD0009000A3O001218000A00963O001218000B00974O00080009000B4O005B00096O00FD000900034O00BC000A000A3O00122O000B00983O00122O000C00996O000A000C00024O00090009000A00202O0009000900204O00090002000200062O000900F602013O000403012O00F602012O00FD0009000B4O00FD000A00033O00208A000A000A009A2O00DF00090002000200061A000900F102010001000403012O00F10201002E18019C00F60201009B000403012O00F602012O00FD0009000A3O001218000A009D3O001218000B009E4O00080009000B4O005B00095O001218000800043O0026D9000800FB02010004000403012O00FB0201002E18019F00C8020100A0000403012O00C80201001218000700043O000403012O00FE0201000403012O00C802010026D90007000203010030000403012O00020301002E1801A1004F030100A2000403012O004F0301001218000800014O000A010900093O0026D90008000803010001000403012O00080301002E1801A40004030100A3000403012O00040301001218000900013O000EA30001004603010009000403012O00460301001218000A00013O002609010A001003010004000403012O00100301001218000900043O000403012O00460301002609010A000C03010001000403012O000C0301002ECF00A6002B030100A5000403012O002B03012O00FD000B00034O00BC000C000A3O00122O000D00A73O00122O000E00A86O000C000E00024O000B000B000C00202O000B000B00204O000B0002000200062O000B002B03013O000403012O002B03012O00FD000B000B4O00FD000C00033O00208A000C000C00A92O00DF000B0002000200061A000B002603010001000403012O00260301002ECF00AB002B030100AA000403012O002B03012O00FD000B000A3O001218000C00AC3O001218000D00AD4O0008000B000D4O005B000B5O002ECF00AE0044030100AF000403012O004403012O00FD000B00034O00BC000C000A3O00122O000D00B03O00122O000E00B16O000C000E00024O000B000B000C00202O000B000B00204O000B0002000200062O000B004403013O000403012O004403012O00FD000B000B4O00FD000C00033O00208A000C000C00B22O00DF000B0002000200061A000B003F03010001000403012O003F0301002E1801B40044030100B3000403012O004403012O00FD000B000A3O001218000C00B53O001218000D00B64O0008000B000D4O005B000B5O001218000A00043O000403012O000C03010026D90009004A03010004000403012O004A0301002E1801B70009030100B8000403012O00090301001218000700B93O000403012O004F0301000403012O00090301000403012O004F0301000403012O000403010026D900070053030100B9000403012O00530301002EB100BA0018000100BB000403012O006903012O00FD000800034O00BC0009000A3O00122O000A00BC3O00122O000B00BD6O0009000B00024O00080008000900202O0008000800204O00080002000200062O000800A903013O000403012O00A903012O00FD0008000B4O00FD000900033O00208A0009000900BE2O00DF000800020002000685000800A903013O000403012O00A903012O00FD0008000A3O001248000900BF3O00122O000A00C06O0008000A6O00085O00044O00A90301002609010700C302010004000403012O00C30201001218000800014O000A010900093O0026090108006D03010001000403012O006D0301001218000900013O0026090109007403010004000403012O00740301001218000700303O000403012O00C302010026090109007003010001000403012O007003012O00FD000A00034O000D010B000A3O00122O000C00C13O00122O000D00C26O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000A008203010001000403012O00820301002EB100C3000D000100C4000403012O008D03012O00FD000A000B4O00FD000B00033O00208A000B000B00C52O00DF000A00020002000685000A008D03013O000403012O008D03012O00FD000A000A3O001218000B00C63O001218000C00C74O0008000A000C4O005B000A5O002ECF00C800A4030100C9000403012O00A403012O00FD000A00034O00BC000B000A3O00122O000C00CA3O00122O000D00CB6O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000A00A403013O000403012O00A403012O00FD000A000B4O00FD000B00033O00208A000B000B00CC2O00DF000A00020002000685000A00A403013O000403012O00A403012O00FD000A000A3O001218000B00CD3O001218000C00CE4O0008000A000C4O005B000A5O001218000900043O000403012O00700301000403012O00C30201000403012O006D0301000403012O00C302012O00FD000700023O0020FF0007000700CF4O0008000C3O00202O0008000800274O000A00033O00202O000A000A00D04O0008000A6O00073O00024O000500073O00122O000600043O0026D9000600B703010030000403012O00B70301002EB100D10004000100D2000403012O00B90301001218000400B93O000403012O002F0501002609010600AE02010004000403012O00AE0201000685000500BE03013O000403012O00BE03012O00A2000500024O00FD000700034O00BC0008000A3O00122O000900D33O00122O000A00D46O0008000A00024O00070007000800202O0007000700D54O00070002000200062O0007002D05013O000403012O002D05012O00FD000700243O0006850007002D05013O000403012O002D05012O00FD000700254O00830007000100020006850007002D05013O000403012O002D05012O00FD0007000C3O00208900070007004E2O00DF000700020002000EB30017002D05010007000403012O002D05012O00FD0007000F3O0020890007000700D62O00DF000700020002002673000700E3030100D7000403012O00E303012O00FD000700034O000D0108000A3O00122O000900D83O00122O000A00D96O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF000700020002002673000700FC030100DB000403012O00FC03012O00FD000700034O00BC0008000A3O00122O000900DC3O00122O000A00DD6O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O000700FC03013O000403012O00FC03012O00FD000700034O000D0108000A3O00122O000900DE3O00122O000A00DF6O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026730007000B04010017000403012O000B04012O00FD000700034O000D0108000A3O00122O000900E13O00122O000A00E26O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026730007002404010079000403012O002404012O00FD000700034O00BC0008000A3O00122O000900E33O00122O000A00E46O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007002404013O000403012O002404012O00FD000700034O000D0108000A3O00122O000900E53O00122O000A00E66O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026730007003304010017000403012O003304012O00FD000700034O000D0108000A3O00122O000900E73O00122O000A00E86O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026730007005D040100E9000403012O005D04012O00FD000700034O00BC0008000A3O00122O000900EA3O00122O000A00EB6O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007005D04013O000403012O005D04012O00FD000700034O00BC0008000A3O00122O000900EC3O00122O000A00ED6O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007005D04013O000403012O005D04012O00FD0007000F3O0020740007000700274O000900033O00202O0009000900EE4O00070009000200062O0007005D04013O000403012O005D04012O00FD000700034O000D0108000A3O00122O000900EF3O00122O000A00F06O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026730007007D04010079000403012O007D04012O00FD000700034O00BC0008000A3O00122O000900F13O00122O000A00F26O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007007D04013O000403012O007D04012O00FD0007000F3O0020740007000700274O000900033O00202O0009000900EE4O00070009000200062O0007007D04013O000403012O007D04012O00FD000700034O000D0108000A3O00122O000900F33O00122O000A00F46O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020026E10007001B05010017000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF000700020002002673000700AC040100DB000403012O00AC04012O00FD000700034O00BC0008000A3O00122O000900F53O00122O000A00F66O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O000700AC04013O000403012O00AC04012O00FD0007000F3O0020740007000700274O000900033O00202O0009000900F74O00070009000200062O000700AC04013O000403012O00AC04012O00FD000700034O00BC0008000A3O00122O000900F83O00122O000A00F96O0008000A00024O00070007000800202O0007000700E04O00070002000200062O000700AC04013O000403012O00AC04012O00FD000700034O000D0108000A3O00122O000900FA3O00122O000A00FB6O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF000700020002002673000700E7040100FC000403012O00E704012O00FD000700034O00BC0008000A3O00122O000900FD3O00122O000A00FE6O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O000700E704013O000403012O00E704012O00FD0007000F3O0020740007000700274O000900033O00202O0009000900F74O00070009000200062O000700E704013O000403012O00E704012O00FD0007000F3O0020740007000700274O000900033O00202O0009000900EE4O00070009000200062O000700E704013O000403012O00E704012O00FD000700034O00BC0008000A3O00122O000900FF3O00122O000A2O00015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O000700E704013O000403012O00E704012O00FD000700034O00BC0008000A3O00122O0009002O012O00122O000A0002015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O000700E704013O000403012O00E704012O00FD000700034O000D0108000A3O00122O00090003012O00122O000A0004015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF00070002000200121800080005012O0006020107000105010008000403012O000105012O00FD000700034O00BC0008000A3O00122O00090006012O00122O000A0007015O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007000105013O000403012O000105012O00FD000700034O000D0108000A3O00122O00090008012O00122O000A0009015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007001B05010001000403012O001B05012O00FD0007000F3O0020890007000700D62O00DF0007000200020012180008000A012O0006020107002D05010008000403012O002D05012O00FD000700034O00BC0008000A3O00122O0009000B012O00122O000A000C015O0008000A00024O00070007000800202O0007000700DA4O00070002000200062O0007002D05013O000403012O002D05012O00FD000700034O00BC0008000A3O00122O0009000D012O00122O000A000E015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007002D05013O000403012O002D05010012180007000F012O00121800080010012O0006020107002D05010008000403012O002D05012O00FD0007000B4O00B5000800033O00122O00090011015O0008000800094O0009000A6O000B00016O0007000B000200062O0007002D05013O000403012O002D05012O00FD0007000A3O00121800080012012O00121800090013013O0008000700094O005B00075O001218000600303O000403012O00AE02010012180006004B3O0006040104001E06010006000403012O001E06012O00FD000600034O00BC0007000A3O00122O00080014012O00122O00090015015O0007000900024O00060006000700202O0006000600204O00060002000200062O0006005A05013O000403012O005A05012O00FD000600263O0006850006005A05013O000403012O005A05012O00FD0006000F3O0020740006000600274O000800033O00202O0008000800D04O00060008000200062O0006005A05013O000403012O005A05012O00FD000600034O00BC0007000A3O00122O00080016012O00122O00090017015O0007000900024O00060006000700202O0006000600E04O00060002000200062O0006005A05013O000403012O005A05012O00FD000600034O00BC0007000A3O00122O00080018012O00122O00090019015O0007000900024O00060006000700202O0006000600E04O00060002000200062O0006007805013O000403012O007805012O00FD000600034O00BC0007000A3O00122O0008001A012O00122O0009001B015O0007000900024O00060006000700202O0006000600E04O00060002000200062O0006009905013O000403012O009905012O00FD000600034O00BC0007000A3O00122O0008001C012O00122O0009001D015O0007000900024O00060006000700202O0006000600E04O00060002000200062O0006009905013O000403012O009905012O00FD000600273O001218000700B93O0006020107009905010006000403012O009905012O00FD0006000C3O0012180008001E013O00190006000600082O00DF0006000200020006850006009905013O000403012O00990501001218000600014O000A010700073O001218000800013O0006040106007A05010008000403012O007A0501001218000700013O001218000800013O0006040107007E05010008000403012O007E05012O00FD000800143O0012510009001F015O0008000200014O0008000B6O000900033O00122O000A0020015O00090009000A4O000A000C3O00202O000A000A00224O000C000D6O000A000C00022O00A8000A000A4O001E0008000A00020006850008009905013O000403012O009905012O00FD0008000A3O00124800090021012O00122O000A0022015O0008000A6O00085O00044O00990501000403012O007E0501000403012O00990501000403012O007A05012O00FD000600054O00FD000700063O0006D8000600B305010007000403012O00B305012O00FD000600034O00BC0007000A3O00122O00080023012O00122O00090024015O0007000900024O00060006000700202O0006000600204O00060002000200062O000600B305013O000403012O00B305012O00FD000600173O000685000600B305013O000403012O00B305012O00FD000600183O000685000600B005013O000403012O00B005012O00FD000600093O00061A000600B705010001000403012O00B705012O00FD000600183O000685000600B705013O000403012O00B7050100121800060025012O00121800070026012O0006D8000700CC05010006000403012O00CC05012O00FD0006000B4O0019010700033O00202O0007000700654O0008000C3O00202O0008000800664O000A00033O00202O000A000A00654O0008000A00024O000800086O00060008000200062O000600C705010001000403012O00C7050100121800060027012O00121800070028012O000602010600CC05010007000403012O00CC05012O00FD0006000A3O00121800070029012O0012180008002A013O0008000600084O005B00065O0012180006002B012O0012180007002B012O000604010600E705010007000403012O00E705012O00FD000600284O0083000600010002000685000600E705013O000403012O00E705012O00FD000600293O000685000600E705013O000403012O00E705012O00FD0006000B4O0007000700033O00122O0008002C015O0007000700084O00060002000200062O000600E205010001000403012O00E20501001218000600C43O0012180007002D012O000604010600E705010007000403012O00E705012O00FD0006000A3O0012180007002E012O0012180008002F013O0008000600084O005B00066O00FD000600273O001218000700B93O000602010600EC05010007000403012O00EC0501000403012O001D0601001218000600013O001218000700043O0006040106000806010007000403012O0008060100121800070030012O00121800080031012O0006D80008001D06010007000403012O001D06012O00FD0007002A3O0012A500080032015O0007000700084O000800033O00122O00090033015O0008000800094O00098O000A000A3O00122O000B0034012O00122O000C0035015O000A000C6O00073O000200062O0007001D06013O000403012O001D06012O00FD0007000A3O00124800080036012O00122O00090037015O000700096O00075O00044O001D060100121800070038012O00121800080038012O000604010700ED05010008000403012O00ED0501001218000700013O000604010600ED05010007000403012O00ED05012O00FD0007002B4O00830007000100022O0015000700014O00FD000700013O00061A0007001906010001000403012O0019060100121800070039012O0012180008003A012O0006020107001B06010008000403012O001B06012O00FD000700014O00A2000700023O001218000600043O000403012O00ED05010012180004003B012O001218000600B93O0006040104007307010006000403012O00730701001218000600013O001218000700303O0006040106002706010007000403012O002706010012180004001A3O000403012O00730701001218000700013O0006E00006002E06010007000403012O002E06010012180007003C012O0012180008003D012O000602010700D606010008000403012O00D606010012180007003E012O0012180008003F012O0006020108008E06010007000403012O008E06012O00FD0007002C4O00830007000100020006850007008E06013O000403012O008E06012O00FD0007002D3O0006850007008E06013O000403012O008E06012O00FD000700034O00BC0008000A3O00122O00090040012O00122O000A0041015O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007008E06013O000403012O008E06012O00FD0007000F3O00129400090042015O0007000700094O000900033O00122O000A0043015O00090009000A4O00070009000200062O0007008E06013O000403012O008E06012O00FD0007000C3O00208900070007004E2O00DF00070002000200121800080044012O0006020108005C06010007000403012O005C06012O00FD000700034O000D0108000A3O00122O00090045012O00122O000A0046015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007007E06010001000403012O007E06012O00FD0007000C3O00208900070007004E2O00DF000700020002001218000800173O0006020107006C06010008000403012O006C06012O00FD000700034O000D0108000A3O00122O00090047012O00122O000A0048015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007007E06010001000403012O007E06012O00FD000700034O000D0108000A3O00122O00090049012O00122O000A004A015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007007E06010001000403012O007E06012O00FD0007000F3O0012670009004B015O00070007000900122O000900793O00122O000A00306O0007000A000200062O0007008E06013O000403012O008E06010012180007004C012O0012180008004C012O0006040107008E06010008000403012O008E06012O00FD0007000B4O003C000800033O00122O0009004D015O0008000800094O00070002000200062O0007008E06013O000403012O008E06012O00FD0007000A3O0012180008004E012O0012180009004F013O0008000700094O005B00075O00121800070050012O00121800080051012O0006D8000700D506010008000403012O00D506012O00FD000700054O00FD000800063O0006D8000700D506010008000403012O00D506012O00FD0007002E3O000685000700D506013O000403012O00D506012O00FD0007002F3O0006850007009F06013O000403012O009F06012O00FD000700093O00061A000700A206010001000403012O00A206012O00FD0007002F3O00061A000700D506010001000403012O00D506012O00FD000700304O00290008000A3O00122O00090052012O00122O000A0053015O0008000A000200062O000700D506010008000403012O00D506012O00FD000700034O00BC0008000A3O00122O00090054012O00122O000A0055015O0008000A00024O00070007000800202O0007000700204O00070002000200062O000700D506013O000403012O00D50601001218000700014O000A010800083O001218000900013O0006E0000900BC06010007000403012O00BC060100121800090056012O001218000A0057012O000602010900B50601000A000403012O00B50601001218000800013O001218000900013O000604010800BD06010009000403012O00BD06012O00FD000900143O001230000A001F015O0009000200014O0009000B6O000A00043O00122O000B0058015O000A000A000B4O000B00106O000B000B6O0009000B000200062O000900D506013O000403012O00D506012O00FD0009000A3O001248000A0059012O00122O000B005A015O0009000B6O00095O00044O00D50601000403012O00BD0601000403012O00D50601000403012O00B50601001218000600043O0012180007005B012O0012180008005C012O0006020108002206010007000403012O00220601001218000700043O0006040106002206010007000403012O002206010012180007005D012O0012180008005E012O0006D80007002107010008000403012O002107012O00FD000700054O00FD000800063O0006D80007002107010008000403012O002107012O00FD0007002E3O0006850007002107013O000403012O002107012O00FD0007002F3O000685000700EE06013O000403012O00EE06012O00FD000700093O00061A000700F106010001000403012O00F106012O00FD0007002F3O00061A0007002107010001000403012O002107012O00FD000700304O00290008000A3O00122O0009005F012O00122O000A0060015O0008000A000200062O0007002107010008000403012O002107012O00FD000700034O00BC0008000A3O00122O00090061012O00122O000A0062015O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007002107013O000403012O00210701001218000700013O001218000800013O0006E00007000A07010008000403012O000A070100121800080063012O00121800090064012O0006020109000307010008000403012O000307012O00FD000800143O0012490009001F015O0008000200014O0008000B6O000900043O00122O000A0065015O00090009000A4O000A00106O000A000A6O0008000A000200062O0008001A07010001000403012O001A070100121800080066012O00121800090067012O0006020109002107010008000403012O002107012O00FD0008000A3O00124800090068012O00122O000A0069015O0008000A6O00085O00044O00210701000403012O000307010012180007006A012O0012180008006B012O0006020108007107010007000403012O007107012O00FD000700034O00BC0008000A3O00122O0009006C012O00122O000A006D015O0008000A00024O00070007000800202O0007000700204O00070002000200062O0007007107013O000403012O007107012O00FD000700313O0006850007007107013O000403012O007107012O00FD000700034O00BC0008000A3O00122O0009006E012O00122O000A006F015O0008000A00024O00070007000800202O0007000700E04O00070002000200062O0007007107013O000403012O00710701001218000700014O000A010800093O001218000A00013O000604010700440701000A000403012O00440701001218000800014O000A010900093O001218000700043O001218000A00043O0006040107003E0701000A000403012O003E0701001218000A0070012O001218000B0071012O0006D8000B00470701000A000403012O00470701001218000A00013O000604010800470701000A000403012O00470701001218000900013O001218000A0072012O001218000B0073012O0006D8000A004F0701000B000403012O004F0701001218000A00013O0006040109004F0701000A000403012O004F07012O00FD000A00143O001249000B00796O000A000200014O000A000B6O000B00033O00122O000C0074015O000B000B000C4O000C00106O000C000C6O000A000C000200062O000A006607010001000403012O00660701001218000A0075012O001218000B0076012O000602010B00710701000A000403012O007107012O00FD000A000A3O001248000B0077012O00122O000C0078015O000A000C6O000A5O00044O00710701000403012O004F0701000403012O00710701000403012O00470701000403012O00710701000403012O003E0701001218000600303O000403012O002206010012180006003B012O0006E00004007A07010006000403012O007A070100121800060079012O0012180007007A012O0006020106006C00010007000403012O006C00012O00FD000600324O00830006000100022O0015000600014O00FD000600013O00061A0006008407010001000403012O008407010012180006007B012O0012180007007C012O0006040106008607010007000403012O008607012O00FD000600014O00A2000600023O0012180006007D012O0012180007007E012O000602010700D307010006000403012O00D307012O00FD0006002A3O0012A500070032015O0006000600074O000700033O00122O00080033015O0007000700084O00088O0009000A3O00122O000A007F012O00122O000B0080015O0009000B6O00063O000200062O000600D307013O000403012O00D3070100121800060081013O00A2000600023O000403012O00D30701000403012O006C0001000403012O00D30701000403012O00630001000403012O00D30701001218000300013O0006040102001000010003000403012O00100001001218000300014O000A010400043O001218000500013O000604010300A407010005000403012O00A40701001218000400013O001218000500043O000604010400AD07010005000403012O00AD0701001218000200043O000403012O00100001001218000500013O000604010400A807010005000403012O00A80701001218000500013O001218000600013O0006E0000500B807010006000403012O00B8070100121800060082012O00121800070083012O0006D8000600C507010007000403012O00C507012O00FD000600334O00830006000100022O0015000600014O00FD000600013O00061A000600C207010001000403012O00C2070100121800060084012O00121800070085012O000602010600C407010007000403012O00C407012O00FD000600014O00A2000600023O001218000500043O001218000600043O000604010500B107010006000403012O00B10701001218000400043O000403012O00A80701000403012O00B10701000403012O00A80701000403012O00100001000403012O00A40701000403012O00100001000403012O00D30701000403012O000B0001000403012O00D30701000403012O000200012O00433O00017O00763O00028O00025O00207540025O0062AB40026O00F03F025O00405140026O001440026O008540026O007740025O00D88F40030C3O004570696353652O74696E677303083O00878CC43A35A332A703073O0055D4E9B04E5CCD030D3O0058599EE34D5D9AD5434C80C16E03043O00822A38E8026O001840025O00207240025O0074A54003083O009E2F4758BFA32D4003053O00D6CD4A332C03113O00EF5FE7C87FEF42E6F965F559F1CE78FB5E03053O00179A2C829C03083O0022A3B9BA3F1D16B503063O007371C6CDCE56030C3O008541FF4E8545C953905FDD7E03043O003AE4379E025O000C9E40025O00F9B140026O000840025O00EAAE40025O0066A04003083O001F0CF2182507E11F03043O006C4C698603093O00FED6B4C0D8EAD1B0F303053O00AE8BA5D181026O001040025O004CAF40025O0028874003083O003AA8296700A33A6003043O001369CD5D030E3O00BC1BDBB537BC06DA842D8A04DF9103053O005FC968BEE103083O009CCED5DAA6C5C6DD03043O00AECFABA103103O00F8ED08C4EAD2EEF504FDFFE3E5EC02E403063O00B78D9E6D9398025O006EA240025O002AAD4003083O001F5548ACCAA5253F03073O00424C303CD8A3CB03113O00AF957CC04FCB25A8A97FD15EDD30B3897703073O0044DAE619933FAE03083O0090B6F6D5CF0D776B03083O0018C3D382A1A66310030A3O005310EC1E52004704EC3E03063O00762663894C3303083O00CE231106002EFA3503063O00409D46657269030F3O0055BBA2D01849ADABE73348A9B5E41503053O007020C8C783027O0040025O00F4B140025O00C4A24003083O003882B0500289A35703043O00246BE7C4030C3O0048A6A7B455BAA18C4A2OB48203043O00E73DD5C203083O00CA11D2E885AFF72603083O00559974A69CECC190030A3O00B1F34881E116A1EE4AB603063O0060C4802DD38403083O0006886F4BDBA1B3CB03083O00B855ED1B3FB2CFD4030D3O001D4A0C6C00500C530C6A055E0503043O003F683969025O003CA040025O0060644003083O00294737B73647E21D03083O006E7A2243C35F2985030C3O0060A25E6ED363B0485ED761B403053O00B615D13B2A03083O008452D109282OB04403063O00DED737A57D41030A3O0039C2C33FEAC4EE5F38D403083O002A4CB1A67A92A18D03083O00968F11DA7078A29903063O0016C5EA65AE19030E3O003827A0F473BDD88F2E00ADCE79B803083O00E64D54C5BC16CFB7025O0014B040025O00088740025O005C9240025O00D4AF4003083O000F40C8A0F3730A2F03073O006D5C25BCD49A1D03143O0011FCA1E734570BFDA5CF38400DE1A3F0395511FB03063O003A648FC4A351025O00449540025O0086B24003083O0043CA2O9DB61877DC03063O007610AF2OE9DF030E3O009E973099EF9F69878106B3E19E6903073O001DEBE455DB8EEB03083O000ED1AEC97E40204103083O00325DB4DABD172E4703093O00CBB75E6F4CDD5AD9A103073O0028BEC43B2C24BC03083O00D9B030F74931EDA603063O005F8AD544832003123O003920A8467A2E0BA942642O2D964A62220B8503053O00164A48C12303083O001F7CF04C2577E34B03043O00384C198403143O004DD1AE27DD71C78927DC4AC8A428F857D5A305EB03053O00AF3EA1CB4603083O000FD8D7073C32DAD003053O00555CBDA37303143O003DA425362DA922373CBF023728BE07313DA4131C03043O005849CC50006F012O0012183O00014O000A2O0100023O002E180102000900010003000403012O00090001002609012O000900010001000403012O00090001001218000100014O000A010200023O0012183O00043O002EB1000500F9FF2O0005000403012O00020001002609012O000200010004000403012O000200010026092O01000D00010001000403012O000D0001001218000200013O0026D90002001400010006000403012O00140001002EB10007003300010008000403012O00450001001218000300013O002EB10009001200010009000403012O002700010026090103002700010004000403012O002700010012A70004000A4O004B000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O00045O00122O0002000F3O00044O004500010026D90003002B00010001000403012O002B0001002ECF0011001500010010000403012O001500010012A70004000A4O0016010500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000500013O00122O000600143O00122O000700156O0005000700024O0004000400054O000400023O00122O0004000A6O000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000400033O00122O000300043O000403012O00150001002ECF001A007A0001001B000403012O007A0001000EA3001C007A00010002000403012O007A0001001218000300013O000E1B0004004E00010003000403012O004E0001002EB1001D00100001001E000403012O005C00010012A70004000A4O004B000500013O00122O0006001F3O00122O000700206O0005000700024O0004000400054O000500013O00122O000600213O00122O000700226O0005000700024O0004000400054O000400043O00122O000200233O00044O007A0001002ECF0025004A00010024000403012O004A00010026090103004A00010001000403012O004A00010012A70004000A4O0016010500013O00122O000600263O00122O000700276O0005000700024O0004000400054O000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000400053O00122O0004000A6O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400063O00122O000300043O000403012O004A0001002E18012E00AB0001002F000403012O00AB0001002609010200AB00010023000403012O00AB0001001218000300013O0026090103008F00010004000403012O008F00010012A70004000A4O004B000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000400073O00122O000200063O00044O00AB00010026090103007F00010001000403012O007F00010012A70004000A4O0016010500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000400083O00122O0004000A6O000500013O00122O000600383O00122O000700396O0005000700024O0004000400054O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000400093O00122O000300043O000403012O007F00010026D9000200AF0001003C000403012O00AF0001002E18013D00DC0001003E000403012O00DC0001001218000300013O002609010300C000010004000403012O00C000010012A70004000A4O004B000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O0004000A3O00122O0002001C3O00044O00DC0001002609010300B000010001000403012O00B000010012A70004000A4O0016010500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O0004000400054O0004000B3O00122O0004000A6O000500013O00122O000600473O00122O000700486O0005000700024O0004000400054O000500013O00122O000600493O00122O0007004A6O0005000700024O0004000400054O0004000C3O00122O000300043O000403012O00B00001002ECF004C00052O01004B000403012O00052O01002609010200052O010004000403012O00052O010012A70003000A4O0023000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O0003000D3O00122O0003000A6O000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O000400013O00122O000500533O00122O000600546O0004000600024O0003000300044O0003000E3O00122O0003000A6O000400013O00122O000500553O00122O000600566O0004000600024O0003000300044O000400013O00122O000500573O00122O000600586O0004000600024O0003000300044O0003000F3O00122O0002003C3O002ECF005A00422O010059000403012O00422O01000EA3000100422O010002000403012O00422O01001218000300013O000E1B0004000E2O010003000403012O000E2O01002ECF005C001C2O01005B000403012O001C2O010012A70004000A4O004B000500013O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000400103O00122O000200043O00044O00422O010026090103000A2O010001000403012O000A2O01001218000400013O0026D9000400232O010004000403012O00232O01002EB10061000400010062000403012O00252O01001218000300043O000403012O000A2O010026090104001F2O010001000403012O001F2O010012A70005000A4O0016010600013O00122O000700633O00122O000800646O0006000800024O0005000500064O000600013O00122O000700653O00122O000800666O0006000800024O0005000500064O000500113O00122O0005000A6O000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O000600013O00122O000700693O00122O0008006A6O0006000800024O0005000500064O000500123O00122O000400043O000403012O001F2O01000403012O000A2O01002609010200100001000F000403012O001000010012A70003000A4O0014000400013O00122O0005006B3O00122O0006006C6O0004000600024O0003000300044O000400013O00122O0005006D3O00122O0006006E6O0004000600024O0003000300044O000300133O00122O0003000A6O000400013O00122O0005006F3O00122O000600706O0004000600024O0003000300044O000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000300143O00122O0003000A6O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000300153O00044O006E2O01000403012O00100001000403012O006E2O01000403012O000D0001000403012O006E2O01000403012O000200012O00433O00017O008D3O00028O00025O0058AF40025O00D0AF40025O00BEAD40025O00F09340025O0058A140025O0009B140026O00F03F030C3O004570696353652O74696E677303083O008EE230B2CE52BAF403063O003CDD8744C6A703143O00FBAEFDAA4CCDE7B0F18743CDE7B3FFB04AD6FBA903063O00B98EDD98E32203083O001D86045220D4299003063O00BA4EE370264903093O00E944F8654677F152F103063O001A9C379D353303083O00BFDD02CDB15E8BCB03063O0030ECB876B9D8030C3O00F0AE5203DB3BF7B0753FC32003063O005485DD3750AF025O00806C40027O0040025O0016B040025O00F4AB40025O00C6A640025O00D49D40025O00D08340025O00C6A140025O000C9140025O00C2A54003083O0041EDD0B7024D7E6103073O00191288A4C36B23030C3O00FD3EAC6373AFD58BFC2CA74B03083O00D8884DC92F12DCA103083O001EE93FCE01D2853E03073O00E24D8C4BBA68BC030E3O00ACDDD50D4EB5C2C93641BEEDC22603053O002FD9AEB05F025O001EB240025O0030A64003083O008BD86216BB5A7F3503083O0046D8BD1662D23418030E3O00CFCCA6B4DBD3DAAF83F1D6D0A08C03053O00B3BABFC3E7026O000840026O001840025O00309440025O003EB140025O006EAB4003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D030D3O001AFBFE9C7E1EEBCF9D6204DACD03053O00116C929DE8026O001C4003083O001EBEFA2E24B5E92903043O005A4DDB8E030D3O00F50C283C400358EA0B2232643703073O001A866441592C6703083O00C2E62437ADFFE42303053O00C491835043030C3O000DB80F0D14EC29B10A0430D803063O00887ED0666878025O00A8A040026O00144003083O00BEF591FB3483F79603053O005DED90E58F030D3O0007F7FC15124F1BF1D30B126E2503063O0026759690796B025O00208D40025O0008AF4003083O003CAABA07F6E6EBC203083O00B16FCFCE739F888C030B3O0009880300E75B5E0B8D382403073O003F65E97074B42F03083O00F03EF906F138C42803063O0056A35B8D729803103O00410A787F235A057350284A2C667C2F4303053O005A336B141303083O006BC043EE4A3DF04B03073O009738A5379A235303113O00B55000CCA95711EBB26A08E3B54D0CFAB903043O008EC0236503083O00E5703DB7EE82AB0503083O0076B61549C387ECCC030D3O001D2F1F692O03F21A392A410D2O03073O009D685C7A20646D025O00D0B140025O000CA54003083O0090A3DBDE34298AB803083O00CBC3C6AFAA5D47ED030C3O003B583BFC5F05F93C5D3BDB5403073O009C4E2B5EB53171026O00104003083O00BBA4FDD67D86A6FA03053O0014E8C189A2030B3O002B2OD1A3F59A127F27F7F503083O001142BFA5C687EC7703083O00E4DD532BDED6402C03043O005FB7B82703103O00B736F33251922BB832F2285D941B9D0F03073O0062D55F874634E003083O00CDA6DD635DF0A4DA03053O00349EC3A917030C3O0073BB3C7B94304B8A73B21A4403083O00EB1ADC5214E6551B025O00C6A340025O0002AF4003083O0078C600F926A64CD003063O00C82BA3748D4F03113O00BB333B86BEE7EAA9330E97B1FAE0BA1E0D03073O0083DF565DE3D09403083O00D0402OA214BBE45603063O00D583252OD67D030E3O00342A33BEE6233916BAF532222BB803053O0081464B45DF034O0003083O0075CEE7FD75E141D803063O008F26AB93891C030C3O00C392BCF211D0D1C496B0FD0403073O00B4B0E2D9936383025O00108740025O0022A140025O00FEB140025O008CAA40025O00F49C40025O00389B4003083O008AB6B30B81FDF7AA03073O0090D9D3C77FE893030F3O00ED3C3B0BDD440C43FD1C2A29DB460703083O0024984F5E48B5256203083O00CA3A0C2OF0311FF703043O0084995F78030D3O00A4A10B1EFFD3A5BDB6392CFBD603073O00C0D1D26E4D97BA03083O00D30636FDF6CAE71003063O00A4806342899F030E3O00159AEC88098AFDB11290DBAB138103043O00DE60E989025O0014A340025O0008A4400001022O0012183O00014O000A2O0100013O000E1B0001000600013O000403012O00060001002E180103000200010002000403012O00020001001218000100013O002E180105004A00010004000403012O004A00010026092O01004A00010001000403012O004A0001001218000200014O000A010300033O002E180106000D00010007000403012O000D00010026090102000D00010001000403012O000D0001001218000300013O0026090103002200010008000403012O002200010012A7000400094O004B000500013O00122O0006000A3O00122O0007000B6O0005000700024O0004000400054O000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O00045O00122O000100083O00044O004A00010026090103001200010001000403012O00120001001218000400013O0026090104004000010001000403012O004000010012A7000500094O0016010600013O00122O0007000E3O00122O0008000F6O0006000800024O0005000500064O000600013O00122O000700103O00122O000800116O0006000800024O0005000500064O000500023O00122O000500096O000600013O00122O000700123O00122O000800136O0006000800024O0005000500064O000600013O00122O000700143O00122O000800156O0006000800024O0005000500064O000500033O00122O000400083O002EB1001600E5FF2O0016000403012O002500010026090104002500010008000403012O00250001001218000300083O000403012O00120001000403012O00250001000403012O00120001000403012O004A0001000403012O000D00010026092O01009100010017000403012O00910001001218000200014O000A010300033O0026D90002005200010001000403012O00520001002E180118004E00010019000403012O004E0001001218000300013O000E1B0001005700010003000403012O00570001002ECF001A007C0001001B000403012O007C0001001218000400013O002E18011C005E0001001D000403012O005E00010026090104005E00010008000403012O005E0001001218000300083O000403012O007C0001002E18011E00580001001F000403012O005800010026090104005800010001000403012O005800010012A7000500094O0016010600013O00122O000700203O00122O000800216O0006000800024O0005000500064O000600013O00122O000700223O00122O000800236O0006000800024O0005000500064O000500043O00122O000500096O000600013O00122O000700243O00122O000800256O0006000800024O0005000500064O000600013O00122O000700263O00122O000800276O0006000800024O0005000500064O000500053O00122O000400083O000403012O00580001002E180129005300010028000403012O005300010026090103005300010008000403012O005300010012A7000400094O004B000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400063O00122O0001002E3O00044O00910001000403012O00530001000403012O00910001000403012O004E00010026D9000100950001002F000403012O00950001002ECF003100CD00010030000403012O00CD0001001218000200013O002EB10032001500010032000403012O00AB0001002609010200AB00010008000403012O00AB00010012A7000300094O00E2000400013O00122O000500333O00122O000600346O0004000600024O0003000300044O000400013O00122O000500353O00122O000600366O0004000600024O00030003000400062O000300A800010001000403012O00A80001001218000300014O0015000300073O001218000100373O000403012O00CD00010026090102009600010001000403012O009600010012A7000300094O00E2000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O000400013O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400062O000300BB00010001000403012O00BB0001001218000300014O0015000300083O0012A9000300096O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400062O000300CA00010001000403012O00CA0001001218000300014O0015000300093O001218000200083O000403012O00960001002EB10040004400010040000403012O00112O010026092O0100112O010041000403012O00112O01001218000200013O002609010200E500010008000403012O00E500010012A7000300094O00E2000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O00030003000400062O000300E200010001000403012O00E20001001218000300014O00150003000A3O0012180001002F3O000403012O00112O01002609010200D200010001000403012O00D20001001218000300013O002609010300EC00010008000403012O00EC0001001218000200083O000403012O00D20001002E18014600E800010047000403012O00E80001002609010300E800010001000403012O00E800010012A7000400094O00E2000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O000500013O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500062O000400FE00010001000403012O00FE0001001218000400014O00150004000B3O0012A9000400096O000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O00040004000500062O0004000D2O010001000403012O000D2O01001218000400014O00150004000C3O001218000300083O000403012O00E80001000403012O00D200010026092O0100482O010008000403012O00482O01001218000200014O000A010300033O002609010200152O010001000403012O00152O01001218000300013O000EA3000100332O010003000403012O00332O010012A7000400094O0016010500013O00122O000600503O00122O000700516O0005000700024O0004000400054O000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O0004000D3O00122O000400096O000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O000500013O00122O000600563O00122O000700576O0005000700024O0004000400054O0004000E3O00122O000300083O0026D9000300372O010008000403012O00372O01002E18015800182O010059000403012O00182O010012A7000400094O004B000500013O00122O0006005A3O00122O0007005B6O0005000700024O0004000400054O000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O0004000F3O00122O000100173O00044O00482O01000403012O00182O01000403012O00482O01000403012O00152O01000EA3005E00862O010001000403012O00862O01001218000200014O000A010300033O0026090102004C2O010001000403012O004C2O01001218000300013O002609010300622O010008000403012O00622O010012A7000400094O00E2000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000500013O00122O000600613O00122O000700626O0005000700024O00040004000500062O0004005F2O010001000403012O005F2O01001218000400014O0015000400103O001218000100413O000403012O00862O01000EA30001004F2O010003000403012O004F2O010012A7000400094O00E2000500013O00122O000600633O00122O000700646O0005000700024O0004000400054O000500013O00122O000600653O00122O000700666O0005000700024O00040004000500062O000400722O010001000403012O00722O01001218000400014O0015000400113O0012A9000400096O000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O00040004000500062O000400812O010001000403012O00812O01001218000400014O0015000400123O001218000300083O000403012O004F2O01000403012O00862O01000403012O004C2O010026D90001008A2O010037000403012O008A2O01002E18016C00B82O01006B000403012O00B82O010012A7000200094O00E2000300013O00122O0004006D3O00122O0005006E6O0003000500024O0002000200034O000300013O00122O0004006F3O00122O000500706O0003000500024O00020002000300062O000200982O010001000403012O00982O01001218000200014O0015000200133O0012A9000200096O000300013O00122O000400713O00122O000500726O0003000500024O0002000200034O000300013O00122O000400733O00122O000500746O0003000500024O00020002000300062O000200A72O010001000403012O00A72O01001218000200754O0015000200143O0012A9000200096O000300013O00122O000400763O00122O000500776O0003000500024O0002000200034O000300013O00122O000400783O00122O000500796O0003000500024O00020002000300062O000200B62O010001000403012O00B62O01001218000200754O0015000200153O000403013O0002010026D9000100BC2O01002E000403012O00BC2O01002ECF007B00070001007A000403012O00070001001218000200014O000A010300033O002E18017D00BE2O01007C000403012O00BE2O01002609010200BE2O010001000403012O00BE2O01001218000300013O002ECF007F00D52O01007E000403012O00D52O01000EA3000800D52O010003000403012O00D52O010012A7000400094O004B000500013O00122O000600803O00122O000700816O0005000700024O0004000400054O000500013O00122O000600823O00122O000700836O0005000700024O0004000400054O000400163O00122O0001005E3O00044O00070001000EA3000100C32O010003000403012O00C32O01001218000400013O002609010400F32O010001000403012O00F32O010012A7000500094O0016010600013O00122O000700843O00122O000800856O0006000800024O0005000500064O000600013O00122O000700863O00122O000800876O0006000800024O0005000500064O000500173O00122O000500096O000600013O00122O000700883O00122O000800896O0006000800024O0005000500064O000600013O00122O0007008A3O00122O0008008B6O0006000800024O0005000500064O000500183O00122O000400083O000E1B000800F72O010004000403012O00F72O01002ECF008D00D82O01008C000403012O00D82O01001218000300083O000403012O00C32O01000403012O00D82O01000403012O00C32O01000403012O00070001000403012O00BE2O01000403012O00070001000403013O000201000403012O000200012O00433O00017O00503O00028O00025O0016B140025O0048B040027O0040025O00E0B140025O004AB340025O00E4A640025O00488440030C3O004570696353652O74696E677303083O003145F9E70B4EEAE003043O009362208D030E3O000D50E6E20357470C4BF0DE09584E03073O002B782383AA663603083O00670393A2ACBE834703073O00E43466E7D6C5D003103O000BF370E2EF8A15DF10E745C5FE8216D803083O00B67E8015AA8AEB79026O00F03F025O00C89540025O00A06040026O00084003083O00B8DF21F28F1D371503083O0066EBBA5586E67350030D3O005F093F5366DC314303302O5AE403073O0042376C5E3F12B403083O00278891232E57139E03063O003974EDE55747030F3O00A2B4ECEB7EE0409ABEF9EE78E06F9A03073O0027CAD18D87178E03083O0001E69C29405435F003063O003A5283E85D2903163O00AA59C4104F2D9647C43A53339A60D81C493A8F5EC30103063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B03123O00D82B59EACBE3305DFBEDF93748FCD1FE294903053O00B991452D8F03083O00E0BC3B13DAB7281403043O0067B3D94F03113O004CBE1BDD55BEA647B615DB52AFAB4FB41703073O00C32AD77CB521EC03083O003E5C232A2CF60A4A03063O00986D39575E4503113O00D0D91EA6ACC041B8EDE003B7B6E140BDF703083O00C899B76AC3DEB234026O007B40025O00F07E4003083O00CC361D1E3BF6F82003063O00989F53696A5203113O00A9C350FEC05286F65EE6C0538FE850FFCC03063O003CE1A63192A9034O0003083O001C1B3B3E0809280D03063O00674F7E4F4A6103113O00927EDD77521F9371D07C4C0AB56DD6725203063O007ADA1FB3133E025O00805040025O00C09640025O00708B40025O002CA94003083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C030E3O005828EAA002492EF099005832C08A03053O00692C5A83CE03083O00CCE5A6AD0130F8F303063O005E9F80D2D968030D3O0042F805B65E73EA4D59ED0E9C7B03083O001A309966DF3F1F99025O00C06F40025O00B2A940025O002EA540025O0008864003083O00B91A0DB2D584180A03053O00BCEA7F79C6030B3O002D2116B72A3B1D883D260003043O00E358527303083O00701AAEB30B7D440C03063O0013237FDAC762030A3O0009E80FD01DF803E310E803043O00827C9B6A0012012O0012183O00014O000A2O0100013O000EA30001000200013O000403012O00020001001218000100013O002E180103005900010002000403012O005900010026092O01005900010004000403012O00590001001218000200013O0026D90002000E00010001000403012O000E0001002ECF0006003100010005000403012O00310001001218000300013O002ECF0008002C00010007000403012O002C00010026090103002C00010001000403012O002C00010012A7000400094O0016010500013O00122O0006000A3O00122O0007000B6O0005000700024O0004000400054O000500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O00045O00122O000400096O000500013O00122O0006000E3O00122O0007000F6O0005000700024O0004000400054O000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000400023O00122O000300123O0026090103000F00010012000403012O000F0001001218000200123O000403012O00310001000403012O000F00010026D90002003500010004000403012O00350001002ECF0013003700010014000403012O00370001001218000100153O000403012O005900010026090102000A00010012000403012O000A00010012A7000300094O00E2000400013O00122O000500163O00122O000600176O0004000600024O0003000300044O000400013O00122O000500183O00122O000600196O0004000600024O00030003000400062O0003004700010001000403012O00470001001218000300014O0015000300033O0012A9000300096O000400013O00122O0005001A3O00122O0006001B6O0004000600024O0003000300044O000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400062O0003005600010001000403012O00560001001218000300014O0015000300043O001218000200043O000403012O000A00010026092O0100A200010001000403012O00A20001001218000200014O000A010300033O0026090102005D00010001000403012O005D0001001218000300013O0026090103007B00010012000403012O007B00010012A7000400094O0016010500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000400053O00122O000400096O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000400063O00122O000300043O0026090103009900010001000403012O009900010012A7000400094O00E2000500013O00122O000600263O00122O000700276O0005000700024O0004000400054O000500013O00122O000600283O00122O000700296O0005000700024O00040004000500062O0004008B00010001000403012O008B0001001218000400014O0015000400073O001234000400096O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000400083O00122O000300123O0026D90003009D00010004000403012O009D0001002EB1002E00C5FF2O002F000403012O00600001001218000100123O000403012O00A20001000403012O00600001000403012O00A20001000403012O005D00010026092O0100C000010015000403012O00C000010012A7000200094O00E2000300013O00122O000400303O00122O000500316O0003000500024O0002000200034O000300013O00122O000400323O00122O000500336O0003000500024O00020002000300062O000200B200010001000403012O00B20001001218000200344O0015000200093O001211000200096O000300013O00122O000400353O00122O000500366O0003000500024O0002000200034O000300013O00122O000400373O00122O000500386O0003000500022O00820002000200032O00150002000A3O000403012O00112O01002ECF003900050001003A000403012O000500010026092O01000500010012000403012O00050001001218000200013O0026D9000200C900010012000403012O00C90001002E18013C00E20001003B000403012O00E200010012A7000300094O0016010400013O00122O0005003D3O00122O0006003E6O0004000600024O0003000300044O000400013O00122O0005003F3O00122O000600406O0004000600024O0003000300044O0003000B3O00122O000300096O000400013O00122O000500413O00122O000600426O0004000600024O0003000300044O000400013O00122O000500433O00122O000600446O0004000600024O0003000300044O0003000C3O00122O000200043O0026D9000200E600010004000403012O00E60001002E18014600E800010045000403012O00E80001001218000100043O000403012O000500010026D9000200EC00010001000403012O00EC0001002E18014700C500010048000403012O00C50001001218000300013O002609010300F100010012000403012O00F10001001218000200123O000403012O00C50001000EA3000100ED00010003000403012O00ED00010012A7000400094O0016010500013O00122O000600493O00122O0007004A6O0005000700024O0004000400054O000500013O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O0004000D3O00122O000400096O000500013O00122O0006004D3O00122O0007004E6O0005000700024O0004000400054O000500013O00122O0006004F3O00122O000700506O0005000700024O0004000400054O0004000E3O00122O000300123O000403012O00ED0001000403012O00C50001000403012O00050001000403012O00112O01000403012O000200012O00433O00017O00443O00028O00026O00F03F025O0094A340025O004CAA40030C3O004570696353652O74696E677303073O0087D9CAC6C5A45603073O0025D3B6ADA1A9C12O033O00F8354E03073O00D9975A2DB9481B03073O00F773E0155AC66F03053O0036A31C87722O033O0029D45803063O001F48BB3DE22E03073O00F70944D54B7B3703073O0044A36623B2271E2O033O00BD74C903083O0071DE10BAA763D5E3027O0040025O00C05E40025O00508740025O005CB140025O00F08B40025O00809540025O0038824003113O00EA87D0888CDCC788D0888FD2F081CB949503063O00B5A3E9A42OE1030B3O004973417661696C61626C65026O002040026O00084003073O001A01FCF1220BE803043O00964E6E9B03043O008ECC24EA03083O0020E5A54781C47EDF030D3O004973446561644F7247686F7374025O00F6A240025O002EA340025O0082AA40025O0052A54003163O00476574456E656D696573496E4D656C2O6552616E6765030E3O004973496E4D656C2O6552616E6765030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O004FB040025O00E8B140025O00789D40024O0080B3C540025O004C9040025O00D0A140030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E73026O001040025O00D88440025O00C05140030C3O0049734368612O6E656C696E67025O0082B140025O00D2A540025O00888140025O00A7B140025O00288540025O00689640025O0016A640025O00F8A340025O0044A840025O0044B340025O00049340025O00707F40025O00907B40025O0007B340002F012O0012183O00014O000A2O0100023O002609012O00262O010002000403012O00262O01000EA30001000400010001000403012O00040001001218000200013O000E1B0002000B00010002000403012O000B0001002E180104003000010003000403012O003000010012A7000300054O0023000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O00035O00122O000300056O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000300023O00122O000300056O000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000300033O00122O000200123O0026D90002003400010012000403012O00340001002ECF0014006100010013000403012O00610001001218000300013O0026D90003003900010002000403012O00390001002E180115004900010016000403012O00490001002ECF0018004700010017000403012O004700012O00FD000400044O00BC000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O00040004001B4O00040002000200062O0004004700013O000403012O004700010012180004001C4O0015000400053O0012180002001D3O000403012O00610001000EA30001003500010003000403012O003500010012A7000400054O009B000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000400066O000400073O00202O0004000400224O00040002000200062O0004005E00010001000403012O005E0001002EB10023000300010024000403012O005F00012O00433O00013O001218000300023O000403012O00350001002609010200CD0001001D000403012O00CD00012O00FD000300023O0006850003008500013O000403012O00850001001218000300014O000A010400053O002E180126006F00010025000403012O006F00010026090103006F00010001000403012O006F0001001218000400014O000A010500053O001218000300023O0026090103006800010002000403012O006800010026090104007100010001000403012O00710001001218000500013O000EA30001007400010005000403012O007400012O00FD000600073O0020330006000600274O000800056O0006000800024O000600086O000600086O000600066O000600093O00044O00870001000403012O00740001000403012O00870001000403012O00710001000403012O00870001000403012O00680001000403012O00870001001218000300024O0015000300094O00FD0003000B3O0020470003000300284O000500056O0003000500024O0003000A6O0003000C3O00202O0003000300294O00030001000200062O0003009600010001000403012O009600012O00FD000300073O00208900030003002A2O00DF000300020002000685000300CC00013O000403012O00CC0001001218000300014O000A010400053O0026090103009D00010001000403012O009D0001001218000400014O000A010500053O001218000300023O0026090103009800010002000403012O00980001002EB1002B3O0001002B000403012O009F0001000EA30001009F00010004000403012O009F0001001218000500013O002ECF002D00B40001002C000403012O00B40001002609010500B400010002000403012O00B400012O00FD0006000D3O0026D9000600AD0001002E000403012O00AD0001002E18013000CC0001002F000403012O00CC00012O00FD0006000E3O0020EE0006000600314O000700086O00088O0006000800024O0006000D3O00044O00CC0001002609010500A400010001000403012O00A40001001218000600013O002609010600C200010001000403012O00C200012O00FD0007000E3O0020DA0007000700324O000800086O000900016O0007000900024O0007000F6O0007000F6O0007000D3O00122O000600023O002609010600B700010002000403012O00B70001001218000500023O000403012O00A40001000403012O00B70001000403012O00A40001000403012O00CC0001000403012O009F0001000403012O00CC0001000403012O00980001001218000200333O0026D9000200D100010033000403012O00D10001002ECF0034000B2O010035000403012O000B2O012O00FD000300073O0020890003000300362O00DF000300020002000685000300D800013O000403012O00D80001002ECF0037002E2O010038000403012O002E2O01002ECF003900F30001003A000403012O00F300012O00FD000300073O00208900030003002A2O00DF000300020002000685000300F300013O000403012O00F30001001218000300014O000A010400043O002609010300E100010001000403012O00E10001001218000400013O002609010400E400010001000403012O00E400012O00FD000500114O00830005000100022O0015000500104O00FD000500103O0006850005002E2O013O000403012O002E2O012O00FD000500104O00A2000500023O000403012O002E2O01000403012O00E40001000403012O002E2O01000403012O00E10001000403012O002E2O01001218000300014O000A010400043O0026D9000300F900010001000403012O00F90001002EB1003B00FEFF2O003C000403012O00F50001001218000400013O002609010400FA00010001000403012O00FA00012O00FD000500124O00830005000100022O0015000500103O002EB1003D002F0001003D000403012O002E2O012O00FD000500103O0006850005002E2O013O000403012O002E2O012O00FD000500104O00A2000500023O000403012O002E2O01000403012O00FA0001000403012O002E2O01000403012O00F50001000403012O002E2O01002EB1003E00FCFE2O003E000403012O000700010026090102000700010001000403012O00070001001218000300013O000E1B000200142O010003000403012O00142O01002E18014000182O01003F000403012O00182O012O00FD000400134O002A000400010001001218000200023O000403012O000700010026D90003001C2O010001000403012O001C2O01002E18014100102O010042000403012O00102O012O00FD000400144O00AB0004000100014O000400156O00040001000100122O000300023O00044O00102O01000403012O00070001000403012O002E2O01000403012O00040001000403012O002E2O010026D93O002A2O010001000403012O002A2O01002E180144000200010043000403012O00020001001218000100014O000A010200023O0012183O00023O000403012O000200012O00433O00017O00033O0003053O005072696E7403313O006099316355882A7E5F857E4051992C7E5F997E7549CB1B6759887037639E2E675F992A7254CB3C6E109315765E8E2A781E03043O001730EB5E00084O00207O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);

