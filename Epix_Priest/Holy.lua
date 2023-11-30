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
				if (Enum <= 134) then
					if (Enum <= 66) then
						if (Enum <= 32) then
							if (Enum <= 15) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
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
										elseif (Enum > 2) then
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										if Stk[Inst[2]] then
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum > 10) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 13) then
									if (Enum == 12) then
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
								elseif (Enum == 14) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum > 16) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 18) then
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
								elseif (Enum > 22) then
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
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum == 24) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local A = Inst[2];
										Top = (A + Varargsz) - 1;
										for Idx = A, Top do
											local VA = Vararg[Idx - A];
											Stk[Idx] = VA;
										end
									end
								elseif (Enum > 26) then
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 29) then
								if (Enum > 28) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 30) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 31) then
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 49) then
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 35) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 38) then
									if (Enum == 37) then
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
								elseif (Enum > 39) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Top));
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
								if (Enum <= 42) then
									if (Enum == 41) then
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
								elseif (Enum > 43) then
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 46) then
								if (Enum == 45) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 47) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum == 48) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 57) then
							if (Enum <= 53) then
								if (Enum <= 51) then
									if (Enum == 50) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 52) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 55) then
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
							elseif (Enum == 56) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
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
						elseif (Enum <= 61) then
							if (Enum <= 59) then
								if (Enum == 58) then
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
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 60) then
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
						elseif (Enum <= 63) then
							if (Enum > 62) then
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
						elseif (Enum <= 64) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 65) then
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
					elseif (Enum <= 100) then
						if (Enum <= 83) then
							if (Enum <= 74) then
								if (Enum <= 70) then
									if (Enum <= 68) then
										if (Enum > 67) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 69) then
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 72) then
									if (Enum > 71) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 73) then
									do
										return;
									end
								else
									do
										return Stk[Inst[2]]();
									end
								end
							elseif (Enum <= 78) then
								if (Enum <= 76) then
									if (Enum > 75) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 77) then
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
							elseif (Enum <= 80) then
								if (Enum == 79) then
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 81) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 82) then
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
						elseif (Enum <= 91) then
							if (Enum <= 87) then
								if (Enum <= 85) then
									if (Enum == 84) then
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
								elseif (Enum == 86) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 89) then
								if (Enum == 88) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								else
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum > 90) then
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
						elseif (Enum <= 95) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 97) then
							if (Enum > 96) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 99) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 117) then
						if (Enum <= 108) then
							if (Enum <= 104) then
								if (Enum <= 102) then
									if (Enum > 101) then
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									else
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 103) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								end
							elseif (Enum <= 106) then
								if (Enum > 105) then
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
							elseif (Enum == 107) then
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
						elseif (Enum <= 112) then
							if (Enum <= 110) then
								if (Enum > 109) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 111) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 114) then
							if (Enum == 113) then
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
						elseif (Enum <= 115) then
							Stk[Inst[2]] = not Stk[Inst[3]];
						elseif (Enum == 116) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 125) then
						if (Enum <= 121) then
							if (Enum <= 119) then
								if (Enum > 118) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum == 120) then
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
						elseif (Enum <= 123) then
							if (Enum == 122) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 124) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 129) then
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
							end
						elseif (Enum > 128) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 131) then
						if (Enum == 130) then
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
					elseif (Enum <= 132) then
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
					else
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 202) then
					if (Enum <= 168) then
						if (Enum <= 151) then
							if (Enum <= 142) then
								if (Enum <= 138) then
									if (Enum <= 136) then
										if (Enum > 135) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 137) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 140) then
									if (Enum > 139) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 141) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 146) then
								if (Enum <= 144) then
									if (Enum > 143) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum > 145) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 148) then
								if (Enum > 147) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 149) then
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
							elseif (Enum == 150) then
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
						elseif (Enum <= 159) then
							if (Enum <= 155) then
								if (Enum <= 153) then
									if (Enum == 152) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									end
								elseif (Enum > 154) then
									if (Inst[2] > Stk[Inst[4]]) then
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
							elseif (Enum <= 157) then
								if (Enum > 156) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 158) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 163) then
							if (Enum <= 161) then
								if (Enum == 160) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 165) then
							if (Enum > 164) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 166) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 167) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 185) then
						if (Enum <= 176) then
							if (Enum <= 172) then
								if (Enum <= 170) then
									if (Enum == 169) then
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum > 171) then
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
							elseif (Enum <= 174) then
								if (Enum == 173) then
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
							elseif (Enum > 175) then
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
						elseif (Enum <= 180) then
							if (Enum <= 178) then
								if (Enum > 177) then
									VIP = Inst[3];
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
							elseif (Enum == 179) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 182) then
							if (Enum == 181) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 183) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 184) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 193) then
						if (Enum <= 189) then
							if (Enum <= 187) then
								if (Enum == 186) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 188) then
								if (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 191) then
							if (Enum == 190) then
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
						elseif (Enum == 192) then
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
					elseif (Enum <= 197) then
						if (Enum <= 195) then
							if (Enum > 194) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 196) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 199) then
						if (Enum > 198) then
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
					elseif (Enum <= 200) then
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
					elseif (Enum > 201) then
						Stk[Inst[2]] = {};
					else
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
					end
				elseif (Enum <= 236) then
					if (Enum <= 219) then
						if (Enum <= 210) then
							if (Enum <= 206) then
								if (Enum <= 204) then
									if (Enum == 203) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 205) then
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
							elseif (Enum == 209) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 214) then
							if (Enum <= 212) then
								if (Enum > 211) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 213) then
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
							end
						elseif (Enum <= 216) then
							if (Enum == 215) then
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
						elseif (Enum <= 217) then
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
						elseif (Enum == 218) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 227) then
						if (Enum <= 223) then
							if (Enum <= 221) then
								if (Enum == 220) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 222) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 225) then
							if (Enum > 224) then
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
						elseif (Enum > 226) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
					elseif (Enum <= 231) then
						if (Enum <= 229) then
							if (Enum > 228) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum > 230) then
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
					elseif (Enum <= 233) then
						if (Enum == 232) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							do
								return Stk[Inst[2]];
							end
						end
					elseif (Enum <= 234) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 235) then
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
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					end
				elseif (Enum <= 253) then
					if (Enum <= 244) then
						if (Enum <= 240) then
							if (Enum <= 238) then
								if (Enum > 237) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 239) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 242) then
							if (Enum > 241) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum > 243) then
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
					elseif (Enum <= 248) then
						if (Enum <= 246) then
							if (Enum == 245) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 247) then
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
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum <= 250) then
						if (Enum > 249) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
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
				elseif (Enum <= 261) then
					if (Enum <= 257) then
						if (Enum <= 255) then
							if (Enum == 254) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum > 256) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 259) then
						if (Enum > 258) then
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
					elseif (Enum > 260) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 265) then
					if (Enum <= 263) then
						if (Enum == 262) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum > 264) then
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
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
					if (Enum > 266) then
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
				elseif (Enum <= 268) then
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
				elseif (Enum > 269) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503143O00F4D3D23DD98BD517D4D0CF1ACEB4CB079FCFCE2403083O007EB1A3BB4586DBA703143O00DCC703BB81E246A1FCC41E9C96DD58B1B7DB1FA203083O00C899B76AC3DEB234002E3O00122A3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004B23O000A00010012FE000300063O0020F50004000300070012FE000500083O0020F50005000500090012FE000600083O0020F500060006000A00061700073O000100062O00593O00064O00598O00593O00044O00593O00014O00593O00024O00593O00053O0020F500080003000B0020F500090003000C2O00CA000A5O0012FE000B000D3O000617000C0001000100022O00593O000A4O00593O000B4O0059000D00073O001276000E000E3O001276000F000F4O00BD000D000F0002000617000E0002000100032O00593O00074O00593O00094O00593O00084O00E6000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001C00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00E400076O00C4000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004030103000500012O00E4000300054O0059000400024O006C000300044O003800036O004A3O00017O000B3O00028O00026O00F03F025O000BB040025O0068A540025O00C07140025O00E08540025O00207840025O00206140025O00D88C40025O004DB040025O00707640013E3O001276000200014O00AA000300043O00261E00020007000100010004B23O00070001001276000300014O00AA000400043O001276000200023O00260C0002000B000100020004B23O000B0001002E6B00030002000100040004B23O00020001001276000500013O002EBC0005000C000100060004B23O000C000100261E0005000C000100010004B23O000C000100261E00030016000100020004B23O001600012O0059000600044O001900076O002800066O003800065O002E6B0008000B000100070004B23O000B000100261E0003000B000100010004B23O000B0001001276000600013O002EA500090006000100090004B23O0021000100261E00060021000100020004B23O00210001001276000300023O0004B23O000B000100261E0006001B000100010004B23O001B0001001276000700013O00260C00070028000100010004B23O00280001002EA5000A000C0001000B0004B23O003200012O00E400086O0051000400083O00063300040031000100010004B23O003100012O00E4000800014O005900096O0019000A6O002800086O003800085O001276000700023O00261E00070024000100020004B23O00240001001276000600023O0004B23O001B00010004B23O002400010004B23O001B00010004B23O000B00010004B23O000C00010004B23O000B00010004B23O003D00010004B23O000200012O004A3O00017O004C3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O007C5609295A03043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O0032A88E24CA03053O00B962DAEB57030B3O00FB2E22F5CD89DE2E34E9CC03063O00CAAB5C4786BE030A3O0019D3299B3AE7238B3CD203043O00E849A14C030E3O008BCB474E0D96D6574E1BB4CF474F03053O007EDBB9223D030B3O003CDC5B616D47FFE615CB4C03083O00876CAE3E121E179303043O0094E024CF03083O00A7D6894AAB78CE5303053O00A6F1314FF703063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D92O033O00C63B2D03073O009CA84E40E0D47903073O0024E1A8C308E0B603043O00AE678EC503083O00733E5A2A3C51F65303073O009836483F58453E03043O00D6CBE15003043O003CB4A48E03063O00737472696E6703063O005E51172426F903073O0072383E6549478D028O0003063O0088FBD2C1ABFD03043O00A4D889BB03043O00FAE93DAB03073O006BB28651D2C69E03063O00081C8BC3B92C03053O00CA586EE2A603043O00EB008EEE03053O00AAA36FE29703063O002122BB3D5D2303073O00497150D2582E5703043O00A923C10B03053O0087E14CAD7203073O0039E2B5BDA3B3B403073O00C77A8DD8D0CCDD03083O0088CB15E261F9A3D803063O0096CDBD70901803103O005265676973746572466F724576656E7403243O0066EF01F53262F305F0257EE907E33777E916F5256BE50FFD306EE31BE3276FED1BFB216303053O006427AC55BC03063O0053657441504C025O0010704000CD013O0095000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000400124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000400134O00145O00122O001500203O00122O001600216O0014001600024O0014000400142O00E400155O001224001600223O00122O001700236O0015001700024O0015000400154O00165O00122O001700243O00122O001800256O0016001800024O0016000F00164O00175O00122O001800263O00122O001900276O0017001900024O0017000F00174O00185O00122O001900283O00122O001A00296O0018001A00024O0018000F00184O00195O00122O001A002A3O00122O001B002B6O0019001B00024O0018001800194O00195O00122O001A002C3O00122O001B002D6O0019001B00024O0018001800194O00195O00122O001A002E3O00122O001B002F6O0019001B00024O0019000F00194O001A5O00122O001B00303O00122O001C00316O001A001C00024O00190019001A4O001A5O00122O001B00323O00122O001C00336O001A001C00024O00190019001A00122O001A00346O001B5O00122O001C00353O00122O001D00366O001B001D00024O001A001A001B4O001B8O001C8O001D8O001E5O00122O001F00376O00208O00215O00122O002200376O00238O00245O00122O002500373O00122O002600376O00275O00122O002800373O00122O002900376O002A005B3O00122O005C00376O005D5O00122O005E00383O00122O005F00396O005D005F00024O005D000C005D4O005E5O00122O005F003A3O00122O0060003B6O005E006000024O005D005D005E4O005E5O00122O005F003C3O00122O0060003D4O00BD005E006000022O0034005E000D005E4O005F5O00122O0060003E3O00122O0061003F6O005F006100024O005E005E005F4O005F5O00122O006000403O00122O006100416O005F006100024O005F0017005F4O00605O00122O006100423O00122O006200436O0060006200024O005F005F00604O00608O006100666O00675O00122O006800443O00122O006900456O0067006900024O0067000F00674O00685O00122O006900463O00122O006A00476O0068006A00024O00670067006800061700683O000100042O00593O005D4O00E48O00593O00674O00593O000E3O0020F7006900040048000617006B0001000100012O00593O00684O0037006C5O00122O006D00493O00122O006E004A6O006C006E6O00693O000100061700690002000100012O00593O005D3O000617006A0003000100062O00593O005D4O00E48O00593O001E4O00593O00674O00593O00114O00593O005F3O000617006B00040001000F2O00593O005E4O00E48O00593O004C4O00593O00074O00593O004D4O00593O00114O00593O005F4O00593O00534O00593O00554O00593O00544O00593O005D4O00593O00584O00593O00594O00593O00574O00593O001F3O000617006C0005000100062O00593O00614O00593O00674O00593O00604O00593O001D4O00593O00074O00593O005D3O000617006D0006000100092O00593O005C4O00593O00224O00593O005D4O00E48O00593O00214O00593O00074O00593O00114O00593O005F4O00593O00203O000617006E00070001000E2O00593O00494O00E48O00593O005D4O00593O00094O00593O004A4O00593O00114O00593O005F4O00593O00404O00593O00674O00593O00414O00593O00424O00593O002E4O00593O002F4O00593O00303O000617006F0008000100282O00593O005D4O00E48O00593O00464O00593O00074O00593O00674O00593O00474O00593O00484O00593O00114O00593O005F4O00593O00094O00593O00324O00593O00314O00593O00354O00593O00364O00593O00374O00593O003C4O00593O003D4O00593O003A4O00593O003B4O00593O00434O00593O00444O00593O00454O00593O000A4O00593O003E4O00593O003F4O00593O00254O00593O00264O00593O00244O00593O001D4O00593O00274O00593O00284O00593O00294O00593O00334O00593O00344O00593O00394O00593O00664O00593O00384O00593O00234O00593O005A4O00593O005B3O000617007000090001001A2O00593O005D4O00E48O00593O00634O00593O00114O00593O00074O00593O00614O00593O006D4O00593O00674O00593O00644O00593O00694O00593O00084O00593O005F4O00593O00254O00593O00264O00593O00244O00593O001D4O00E43O00014O00E43O00024O00593O00654O00593O00354O00593O004F4O00593O00504O00593O006C4O00593O000A4O00593O001E4O00593O004E3O0006170071000A000100102O00593O00674O00593O00614O00593O00704O00593O00074O00593O006D4O00593O006B4O00593O00514O00593O005D4O00593O005F4O00593O00094O00593O00524O00593O006F4O00593O004B4O00593O006A4O00593O001D4O00593O006E3O0006170072000B000100102O00593O00514O00593O00614O00593O00674O00593O005D4O00593O005F4O00593O00094O00593O004B4O00593O006A4O00593O001B4O00593O006F4O00E48O00593O00564O00593O00074O00593O00114O00593O006D4O00593O00083O0006170073000C0001001C2O00593O00354O00E48O00593O00364O00593O00334O00593O00344O00593O00294O00593O002A4O00593O00274O00593O00284O00593O002B4O00593O002C4O00593O002D4O00593O002E4O00593O00374O00593O00384O00593O00394O00593O00254O00593O00264O00593O00234O00593O00244O00593O002F4O00593O00304O00593O00314O00593O00324O00593O001F4O00593O00204O00593O00214O00593O00223O0006170074000D000100232O00593O00494O00E48O00593O004A4O00593O004D4O00593O004B4O00593O004C4O00593O00534O00593O00544O00593O00554O00593O00564O00593O00574O00593O00484O00593O00444O00593O00454O00593O00464O00593O00474O00593O003F4O00593O00404O00593O00434O00593O00414O00593O00424O00593O004E4O00593O004F4O00593O00504O00593O00514O00593O00524O00593O00584O00593O00594O00593O005A4O00593O005B4O00593O003A4O00593O003B4O00593O003C4O00593O003D4O00593O003E3O0006170075000E000100172O00593O00074O00593O00614O00593O00714O00593O001B4O00593O00704O00593O00724O00E48O00593O00734O00593O00744O00593O005C4O00593O001C4O00593O001D4O00593O001E4O00593O00664O00593O005D4O00593O00634O00593O00624O00593O00654O00593O004B4O00593O00674O00593O004A4O00593O00494O00593O00643O0006170076000F000100032O00593O00684O00593O000F4O00E47O0020530077000F004B00122O0078004C6O007900756O007A00766O0077007A00016O00013O00103O000C3O00030E3O000C89AF5E0B9E2O141591AD45029103083O007045E4DF2C64E871030B3O004973417661696C61626C6503123O00F01614C3B3708AD51D0BD6927984C11901C003073O00E6B47F67B3D61C030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303123O00A80C4C56E14DEC8D075343C044E29903595503073O0080EC653F26842103173O0088A00254B3E7C3ADAB1D419BEAC8A5AA3541B4FEC9AABA03073O00AFCCC97124D68B00254O00C79O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001800013O0004B23O001800012O00E43O00024O0067000100013O00122O000200043O00122O000300056O0001000300024O000200033O00202O0002000200064O000300023O00202O0003000300074O000400023O00202O0004000400084O0002000400026O0001000200044O002400012O00E43O00024O0047000100013O00122O000200093O00122O0003000A6O0001000300024O000200026O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200036O000100022O004A3O00019O003O00034O00E48O003D3O000100012O004A3O00017O00043O0003113O00446562752O665265667265736861626C65030E3O00536861646F77576F72645061696E03093O0054696D65546F446965026O002840010E3O00202100013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004B23O000C00010020F700013O00032O005B000100020002000E9B0004000B000100010004B23O000B00014O00016O0026000100014O00E9000100024O004A3O00017O00083O00025O00E89A4003063O009D6DAB8935B403053O0053CD18D9E003073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974030B3O00507572696679466F637573030D3O00F6D0DF34E0DC8D39EFD6DD38EA03043O005D86A5AD00203O002EA50001001F000100010004B23O001F00012O00E48O0085000100013O00122O000200023O00122O000300036O0001000300028O000100206O00046O0002000200064O001F00013O0004B23O001F00012O00E43O00023O0006E23O001F00013O0004B23O001F00012O00E43O00033O0020F55O00052O00FF3O000100020006E23O001F00013O0004B23O001F00012O00E43O00044O00E4000100053O0020F50001000100062O005B3O000200020006E23O001F00013O0004B23O001F00012O00E43O00013O001276000100073O001276000200084O006C3O00024O00388O004A3O00017O002F3O00028O00026O00F03F025O0034AF40025O00D8AD40030B3O0071534AF1618E941F56584E03083O006B39362B9D15E6E703073O004973526561647903103O004865616C746850657263656E74616765030B3O004865616C746873746F6E6503173O00D38E10F9ADD4DCCF841FF0F9D8CADD8E1FE6B02OCA9BD803073O00AFBBEB7195D9BC025O00409740025O00A49940025O00107B40025O0076A14003193O000EAA875EE66A7035A1860CCB7C7930A68F4BA3497728A68E4203073O00185CCFE12C831903173O0079D6BE5E1E6E43DAB64B33784ADFB1421C4D44C7B1431503063O001D2BB3D82C7B03173O0052656672657368696E674865616C696E67506F74696F6E025O00B89C40025O004EA34003253O00AFDC265EB8CA2845B3DE6044B8D82C45B3DE605CB2CD2943B3992449BBDC2E5FB4CF250CE903043O002CDDB940025O0018A340025O00E2A940025O00CAAC40025O00206740025O00108740025O009C9E40025O002O9440025O002AA84003043O0098F3C5C703083O001EDE92A1A25AAED203043O0046616465025O0066A440025O0053B140030E3O00E34F740FA54A750CE0406303F34B03043O006A852E10030F3O007C2560EC5F52593476CC482O41256103063O00203840139C3A030A3O0049734361737461626C65025O00405D40025O003DB340030F3O00446573706572617465507261796572031A3O005ECDF6465FE0814ECDDA4648F3995FDAA5525FF48554DBEC405F03073O00E03AA885363A9200BF3O0012763O00014O00AA000100013O000E960001000200013O0004B23O00020001001276000100013O000E8D00020009000100010004B23O00090001002E6B00030058000100040004B23O005800012O00E400026O0085000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002900013O0004B23O002900012O00E4000200023O0006E20002002900013O0004B23O002900012O00E4000200033O0020F70002000200082O005B0002000200022O00E4000300043O0006AC00020029000100030004B23O002900012O00E4000200054O00A7000300063O00202O0003000300094O000400056O000600016O00020006000200062O0002002900013O0004B23O002900012O00E4000200013O0012760003000A3O0012760004000B4O006C000200044O003800025O002EBC000C00BE0001000D0004B23O00BE00012O00E4000200073O0006E2000200BE00013O0004B23O00BE00012O00E4000200033O0020F70002000200082O005B0002000200022O00E4000300083O0006AC000200BE000100030004B23O00BE0001002E6B000E003E0001000F0004B23O003E00012O00E4000200094O005F000300013O00122O000400103O00122O000500116O00030005000200062O0002003E000100030004B23O003E00010004B23O00BE00012O00E400026O0085000300013O00122O000400123O00122O000500136O0003000500024O00020002000300202O0002000200074O00020002000200062O000200BE00013O0004B23O00BE00012O00E4000200054O00CC000300063O00202O0003000300144O000400056O000600016O00020006000200062O00020052000100010004B23O00520001002EBC001600BE000100150004B23O00BE00012O00E4000200013O00126D000300173O00122O000400186O000200046O00025O00044O00BE000100261E00010005000100010004B23O00050001001276000200014O00AA000300033O002EBC0019005C0001001A0004B23O005C000100261E0002005C000100010004B23O005C0001001276000300013O00260C00030065000100020004B23O00650001002E6B001B00670001001C0004B23O00670001001276000100023O0004B23O00050001002E6B001D00610001001E0004B23O0061000100261E00030061000100010004B23O00610001001276000400013O00261E00040070000100020004B23O00700001001276000300023O0004B23O0061000100260C00040074000100010004B23O00740001002EA5001F00FAFF2O00200004B23O006C00012O00E40005000A4O0085000600013O00122O000700213O00122O000800226O0006000800024O00050005000600202O0005000500074O00050002000200062O0005009600013O0004B23O009600012O00E40005000B3O0006E20005009600013O0004B23O009600012O00E4000500033O0020F70005000500082O005B0005000200022O00E40006000C3O0006AC00050096000100060004B23O009600012O00E4000500054O00CC0006000A3O00202O0006000600234O000700086O000900016O00050009000200062O00050091000100010004B23O00910001002E6B00250096000100240004B23O009600012O00E4000500013O001276000600263O001276000700274O006C000500074O003800056O00E40005000A4O0085000600013O00122O000700283O00122O000800296O0006000800024O00050005000600202O00050005002A4O00050002000200062O000500A900013O0004B23O00A900012O00E40005000D3O0006E2000500A900013O0004B23O00A900012O00E4000500033O0020F70005000500082O005B0005000200022O00E40006000E3O00066F00050003000100060004B23O00AB0001002EBC002C00B60001002B0004B23O00B600012O00E4000500054O00E40006000A3O0020F500060006002D2O005B0005000200020006E2000500B600013O0004B23O00B600012O00E4000500013O0012760006002E3O0012760007002F4O006C000500074O003800055O001276000400023O0004B23O006C00010004B23O006100010004B23O000500010004B23O005C00010004B23O000500010004B23O00BE00010004B23O000200012O004A3O00017O000F3O00028O00026O00F03F025O00C05A40025O0029B340025O00608F40025O0086AF4003133O0048616E646C65426F2O746F6D5472696E6B657403063O0042752O66557003113O00506F776572496E667573696F6E42752O66026O004440025O00E4A540025O0010774003103O0048616E646C65546F705472696E6B6574025O00649740025O0002A44000503O0012763O00014O00AA000100023O000E960001000700013O0004B23O00070001001276000100014O00AA000200023O0012763O00023O00261E3O0002000100020004B23O00020001002E6B00030009000100040004B23O0009000100261E00010009000100010004B23O00090001001276000200013O00260C00020012000100020004B23O00120001002EBC00060029000100050004B23O002900012O00E4000300013O0020F50003000300072O00E4000400024O00E4000500033O0006E20005001D00013O0004B23O001D00012O00E4000500043O0020F70005000500082O00E4000700053O0020F50007000700092O00BD0005000700020012760006000A4O00C3000700076O0003000700024O00038O00035O00062O00030026000100010004B23O00260001002EBC000B004F0001000C0004B23O004F00012O00E400036O00E9000300023O0004B23O004F000100261E0002000E000100010004B23O000E0001001276000300013O00261E00030030000100020004B23O00300001001276000200023O0004B23O000E000100261E0003002C000100010004B23O002C00012O00E4000400013O0020F500040004000D2O00E4000500024O00E4000600033O0006E20006003D00013O0004B23O003D00012O00E4000600043O0020F70006000600082O00E4000800053O0020F50008000800092O00BD0006000800020012760007000A4O00AA000800084O00BD0004000800022O002E00045O002E6B000E00480001000F0004B23O004800012O00E400045O0006E20004004800013O0004B23O004800012O00E400046O00E9000400023O001276000300023O0004B23O002C00010004B23O000E00010004B23O004F00010004B23O000900010004B23O004F00010004B23O000200012O004A3O00017O001B3O0003073O0047657454696D65028O00026O00F03F025O00808940025O00C09A40025O005AA540025O0036A740025O004EA440025O00A4AF40030B3O0023E84C46720FE37B50660D03053O00136187283F030B3O004973417661696C61626C65030F3O009E53243E3D06A14E37082738AB503703063O0051CE3C535B4F03073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O6603153O00506F776572576F7264536869656C64506C61796572031D3O005EA4C7773DFC5AAB5CAFEF6127CA48A84A94C07E2EDA48B60EA6DF642A03083O00C42ECBB0124FA32D025O00C89F40030E3O00992C791B28F2EC9E277F0A2CFEFD03073O008FD8421E7E449B03143O00416E67656C696346656174686572506C61796572031B3O00ABC60ACEC9AAD4DEACCD0CDFCDA6C5DEBAC40CD2C0B197ECA5DE0803083O0081CAA86DABA5C3B700813O0012203O00018O000100024O00019O003O00014O000100013O00062O0001008000013O0004B23O008000010012763O00024O00AA000100023O00261E3O000E000100020004B23O000E0001001276000100024O00AA000200023O0012763O00033O000E8D0003001200013O0004B23O00120001002EBC00050009000100040004B23O0009000100260C00010016000100020004B23O00160001002EA5000600FEFF2O00070004B23O00120001001276000200023O00261E00020017000100020004B23O00170001002EBC0008004B000100090004B23O004B00012O00E4000300024O0085000400033O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003004B00013O0004B23O004B00012O00E4000300024O0085000400033O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003004B00013O0004B23O004B00012O00E4000300043O0006E20003004B00013O0004B23O004B00012O00E4000300053O0020210003000300104O000500023O00202O0005000500114O00030005000200062O0003004B00013O0004B23O004B00012O00E4000300053O0020210003000300104O000500023O00202O0005000500124O00030005000200062O0003004B00013O0004B23O004B00012O00E4000300064O00E4000400073O0020F50004000400132O005B0003000200020006E20003004B00013O0004B23O004B00012O00E4000300033O001276000400143O001276000500154O006C000300054O003800035O002EA500160035000100160004B23O008000012O00E4000300024O0085000400033O00122O000500173O00122O000600186O0004000600024O00030003000400202O00030003000F4O00030002000200062O0003008000013O0004B23O008000012O00E4000300083O0006E20003008000013O0004B23O008000012O00E4000300053O0020210003000300104O000500023O00202O0005000500114O00030005000200062O0003008000013O0004B23O008000012O00E4000300053O0020210003000300104O000500023O00202O0005000500124O00030005000200062O0003008000013O0004B23O008000012O00E4000300053O0020210003000300104O000500023O00202O0005000500114O00030005000200062O0003008000013O0004B23O008000012O00E4000300064O00E4000400073O0020F50004000400192O005B0003000200020006E20003008000013O0004B23O008000012O00E4000300033O00126D0004001A3O00122O0005001B6O000300056O00035O00044O008000010004B23O001700010004B23O008000010004B23O001200010004B23O008000010004B23O000900012O004A3O00017O003C3O00028O00025O00C0A740025O00B0B14003063O0003562ED7D01103073O0086423857B8BE74030E3O001B2408A91DE2203B0F2100A910FF03083O00555C5169DB798B4103073O004973526561647903103O004865616C746850657263656E74616765025O0058A040025O000AA040025O0090A040025O00BFB24003133O00477561726469616E537069726974466F637573031D3O00FAA6515778D6FCBD6F566CD6EFBA440574DAFCBF6F4673D0F1B75F527203063O00BF9DD330251C03093O00EB1EFA177AF011F80503053O005ABF7F947C030E3O005F922F057C8E2F194B972705719303043O007718E74E03073O00436F2O6D6F6E73030D3O00556E697447726F7570526F6C6503043O00B60C8B6103073O0071E24DC52ABC20025O00BAB140025O00507840031D3O003D03F5A73E1FF5BB2O05E4BC281FE0F53213F5B90515FBBA3612FBA23403043O00D55A7694025O00E07040025O00D89840030D3O006F2FBA5D0D5A20B0167E5E22B203053O002D3B4ED436030E3O00374382998227ACFE23468A998F3A03083O00907036E3EBE64ECD03043O00870921D703063O003BD3486F9CB003063O0066A2C2016BB503043O004D2EE783025O00649940025O00C49340031D3O00BD41B752BE5DB74E8547A649A85DA200B251B74C8557B94FB650B957B403043O0020DA34D603113O0066183DB1C6BF575E7D163DBEF0A44C554003083O003A2E7751C891D025031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503113O00486F6C79576F726453616C766174696F6E03213O0023833CB596AA2O39880FBFA8B1202A9839A3A7FD3E2E8D3C93AAB23927883FBBA703073O00564BEC50CCC9DD026O00F03F025O00804940025O00C08C40030A3O005648618CF08E5A587A8B03063O00EB122117E59E025O0030A740025O00389F40030A3O00446976696E6548796D6E025O001AA840025O006CA54003193O0054B3D7B25EBFFEB349B7CFFB58BFC0B76FB9CEB45CBECEAC5E03043O00DB30DAA100F03O0012763O00014O00AA000100013O000E960001000200013O0004B23O00020001001276000100013O002EBC000200C2000100030004B23O00C2000100261E000100C2000100010004B23O00C200012O00E400026O0070000300013O00122O000400043O00122O000500056O00030005000200062O00020032000100030004B23O003200012O00E4000200024O0085000300013O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002002000013O0004B23O002000012O00E4000200033O0020F70002000200092O005B0002000200022O00E4000300043O00066F00020003000100030004B23O00220001002E6B000A00A00001000B0004B23O00A00001002EBC000C00A00001000D0004B23O00A000012O00E4000200054O00A7000300063O00202O00030003000E4O000400056O000600016O00020006000200062O000200A000013O0004B23O00A000012O00E4000200013O00126D0003000F3O00122O000400106O000200046O00025O00044O00A000012O00E400026O0070000300013O00122O000400113O00122O000500126O00030005000200062O00020063000100030004B23O006300012O00E4000200024O0085000300013O00122O000400133O00122O000500146O0003000500024O00020002000300202O0002000200084O00020002000200062O0002005300013O0004B23O005300012O00E4000200033O0020F70002000200092O005B0002000200022O00E4000300043O0006AC00020053000100030004B23O005300010012FE000200153O00203A0002000200164O000300036O0002000200024O000300013O00122O000400173O00122O000500186O00030005000200062O00020055000100030004B23O00550001002E6B001900A00001001A0004B23O00A000012O00E4000200054O00A7000300063O00202O00030003000E4O000400056O000600016O00020006000200062O000200A000013O0004B23O00A000012O00E4000200013O00126D0003001B3O00122O0004001C6O000200046O00025O00044O00A00001002E6B001D006D0001001E0004B23O006D00012O00E400026O005F000300013O00122O0004001F3O00122O000500206O00030005000200062O0002006D000100030004B23O006D00010004B23O00A000012O00E4000200024O0085000300013O00122O000400213O00122O000500226O0003000500024O00020002000300202O0002000200084O00020002000200062O000200A000013O0004B23O00A000012O00E4000200033O0020F70002000200092O005B0002000200022O00E4000300043O0006AC000200A0000100030004B23O00A000010012FE000200153O00203A0002000200164O000300036O0002000200024O000300013O00122O000400233O00122O000500246O00030005000200062O00020091000100030004B23O009100010012FE000200153O0020D60002000200164O000300036O0002000200024O000300013O00122O000400253O00122O000500266O00030005000200062O000200A0000100030004B23O00A00001002EBC002800A0000100270004B23O00A000012O00E4000200054O00A7000300063O00202O00030003000E4O000400056O000600016O00020006000200062O000200A000013O0004B23O00A000012O00E4000200013O001276000300293O0012760004002A4O006C000200044O003800026O00E4000200024O0085000300013O00122O0004002B3O00122O0005002C6O0003000500024O00020002000300202O0002000200084O00020002000200062O000200C100013O0004B23O00C100012O00E4000200073O0006E2000200C100013O0004B23O00C100012O00E4000200083O00208000020002002D4O000300096O0004000A6O00020004000200062O000200C100013O0004B23O00C100012O00E4000200054O00A7000300023O00202O00030003002E4O000400046O000500016O00020005000200062O000200C100013O0004B23O00C100012O00E4000200013O0012760003002F3O001276000400304O006C000200044O003800025O001276000100313O00260C000100C6000100310004B23O00C60001002E6B00330005000100320004B23O000500012O00E4000200024O0085000300013O00122O000400343O00122O000500356O0003000500024O00020002000300202O0002000200084O00020002000200062O000200DA00013O0004B23O00DA00012O00E40002000B3O0006E2000200DA00013O0004B23O00DA00012O00E4000200083O00209300020002002D4O0003000C6O0004000D6O00020004000200062O000200DC000100010004B23O00DC0001002E6B003600EF000100370004B23O00EF00012O00E4000200054O00CC000300023O00202O0003000300384O000400046O000500016O00020005000200062O000200E6000100010004B23O00E60001002E6B003900EF0001003A0004B23O00EF00012O00E4000200013O00126D0003003B3O00122O0004003C6O000200046O00025O00044O00EF00010004B23O000500010004B23O00EF00010004B23O000200012O004A3O00017O00933O00028O00027O0040026O00F03F025O00807740025O0046A040025O005FB040025O00409340030F3O0005A68AEBDF27BB8DDADF34B882FCDD03053O00BA55D4EB9203073O004973526561647903063O0042752O66557003103O00507261796572436972636C6542752O66031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503143O005072617965726F664865616C696E67466F63757303163O00D29317E73CFC67CD8729F63CEF54CB8F11BE31EB59CE03073O0038A2E1769E598E026O000840025O00849740025O0009B340025O0050AE40025O00B6B140030A3O00E54B24DF0BC47126D71703053O0065A12252B603103O004865616C746850657263656E7461676503103O00446976696E6553746172506C6179657203093O004973496E52616E6765026O003E4003103O00EC044FF7D5E7BD3DFC0C4BBED3E7832203083O004E886D399EBB82E203043O00163EF5FE03043O00915E5F99025O0080A240025O00DAA340030A3O0048616C6F506C6179657203093O00F5CC18DA0EBFF8CC1803063O00D79DAD74B52E025O007DB240025O0007B040030D3O00D47E6B4CC978EFF6755040DD4A03073O008084111C29BB2F03123O00506F776572576F72644C696665466F637573025O00DC9240025O00B1B04003143O00113D113F4F3E250928592O3E0F3C58413A033B5103053O003D6152665A030F3O009C3CAA52C245110F812BA54FCE591903083O0069CC4ECB2BA7377E030F3O0042752O665265667265736861626C65030F3O005072617965726F664D656E64696E6703143O005072617965726F664D656E64696E67466F637573025O00549F40025O00C2A34003163O00B5B822072O16F85EA3952E1B1D00CE5FA2EA2B1B120803083O0031C5CA437E7364A7025O00D08E40025O000AAC4003103O001F54D330B7594C3368DE27834257314203073O003E573BBF49E03603093O00497341506C6179657203093O0043616E412O7461636B03163O00486F6C79576F726453616E6374696679437572736F7203173O00EF0DF6D0D815F5DBE33DE9C8E901EEC0E11BBAC1E203F603043O00A987629A025O005EA840025O00E07A40025O00D2A240025O0026A940025O00108C40025O00BCA540025O0094A140025O00909B40025O00A8854003103O00E378284DCA3CDACF442146F83DC1DF6E03073O00A8AB1744349D5303153O00486F6C79576F7264536572656E697479466F637573025O00607B4003173O00FC7EF9B41A3A88E675CABE203F82FA78E1B4652582F57D03073O00E7941195CD454D030A3O00A1B7C8EF5FFA8FB4CEE803063O009FE0C7A79B37030F3O00412O66656374696E67436F6D62617403103O00DFFC30CBC0FC2ED6C4F232D1E3FA3ACB03043O00B297935C030C3O00432O6F6C646F776E446F776E03103O00A4F2402B25436888CE492017427398E403073O001AEC9D2C52722C03103O000221D9421D21C75F192BC75E2427C14203043O003B4A4EB503103O000DDE5643842AC35E69B22BD24E53B53C03053O00D345B12O3A030A3O0041706F7468656F736973030F3O00B6F5762OE1CEB8F670E6A9C3B2E47503063O00ABD785199589030F3O00C2C120F9E335F344C9CD33F6E63EFB03083O002281A8529A8F509C03143O00436972636C656F664865616C696E67466F63757303163O0086BB2108444BB68AB40C034D4F858CBC344B404B888903073O00E9E5D2536B282E025O005C9B40025O000C9640025O0056B04003093O007A09C1BC2AF05904CC03063O00B83C65A0CF42030B3O001D8B7BB4259579BD27876E03043O00DC51E21C030B3O004973417661696C61626C6503083O0042752O66446F776E030F3O004C6967687477656176657242752O6603093O0042752O66537461636B030C3O0053757267656F664C69676874030B3O003FDC85F3FED016D494FEF803063O00A773B5E29B8A030E3O004D616E6150657263656E74616765026O004440025O003AB240025O00188340030E3O00466C6173684865616C466F637573030F3O00E42EE64F734ECEE723EB1C7374C7EE03073O00A68242873C1B1103043O006C4FCF7903053O0050242AAE15025O0081B240025O00ADB140025O000FB140025O002EAD4003093O004865616C466F63757303093O00461536760E18327B4203043O001A2E7057025O00F4A240030C3O008A3AA676B0B34AB2912CBB7103083O00D4D943CB142ODF25030F3O009E88BBC2BF9FA9C6BFBDBAD3A388BA03043O00B2DAEDC8030C3O0053796D626F6C6F66486F706503133O00A5ACEBD22OB9D9DFB08AEEDFA6B0A6D8B3B4EA03043O00B0D6D586026O001040026O003540025O00CC9E4003053O00C6A8B8D1BF03073O003994CDD6B4C83603053O0052656E6577030A3O0052656E6577466F637573025O00D4A640025O00907B40030A4O00F83B316152F530357A03053O0016729D555400AB022O0012763O00013O00261E3O0088000100020004B23O00880001001276000100014O00AA000200023O00261E00010005000100010004B23O00050001001276000200013O00260C0002000C000100030004B23O000C0001002E6B00050038000100040004B23O00380001002EBC00070036000100060004B23O003600012O00E400036O0085000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003600013O0004B23O003600012O00E4000300023O0006E20003003600013O0004B23O003600012O00E4000300033O00202100030003000B4O00055O00202O00050005000C4O00030005000200062O0003003600013O0004B23O003600012O00E4000300043O00208000030003000D4O000400056O000500066O00030005000200062O0003003600013O0004B23O003600012O00E4000300074O00A7000400083O00202O00040004000E4O000500056O000600016O00030006000200062O0003003600013O0004B23O003600012O00E4000300013O0012760004000F3O001276000500104O006C000300054O003800035O0012763O00113O0004B23O00880001000E8D0001003C000100020004B23O003C0001002EBC00130008000100120004B23O00080001002EBC00140061000100150004B23O006100012O00E400036O0085000400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006100013O0004B23O006100012O00E4000300093O0020F70003000300182O005B0003000200022O00E40004000A3O00061A00030061000100040004B23O006100012O00E40003000B3O0006E20003006100013O0004B23O006100012O00E4000300074O0025000400083O00202O0004000400194O000500093O00202O00050005001A00122O0007001B6O0005000700024O000500056O00030005000200062O0003006100013O0004B23O006100012O00E4000300013O0012760004001C3O0012760005001D4O006C000300054O003800036O00E400036O0085000400013O00122O0005001E3O00122O0006001F6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003007500013O0004B23O007500012O00E40003000C3O0006E20003007500013O0004B23O007500012O00E4000300043O00209300030003000D4O0004000D6O0005000E6O00030005000200062O00030077000100010004B23O00770001002E6B00210084000100200004B23O008400012O00E4000300074O00A7000400083O00202O0004000400224O000500056O000600016O00030006000200062O0003008400013O0004B23O008400012O00E4000300013O001276000400233O001276000500244O006C000300054O003800035O001276000200033O0004B23O000800010004B23O008800010004B23O00050001000E960001000B2O013O0004B23O000B2O01001276000100013O00260C0001008F000100010004B23O008F0001002E6B002500D7000100260004B23O00D700012O00E400026O0085000300013O00122O000400273O00122O000500286O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200AF00013O0004B23O00AF00012O00E40002000F3O0006E2000200AF00013O0004B23O00AF00012O00E4000200093O0020F70002000200182O005B0002000200022O00E4000300103O00061A000200AF000100030004B23O00AF00012O00E4000200074O00E4000300083O0020F50003000300292O005B000200020002000633000200AA000100010004B23O00AA0001002EA5002A00070001002B0004B23O00AF00012O00E4000200013O0012760003002C3O0012760004002D4O006C000200044O003800026O00E400026O0085000300013O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200D600013O0004B23O00D600012O00E4000200113O0006E2000200D600013O0004B23O00D600012O00E4000200093O0020210002000200304O00045O00202O0004000400314O00020004000200062O000200D600013O0004B23O00D600012O00E4000200093O0020F70002000200182O005B0002000200022O00E4000300123O0006AC000200D6000100030004B23O00D600012O00E4000200074O00E4000300083O0020F50003000300322O005B000200020002000633000200D1000100010004B23O00D10001002EA500330007000100340004B23O00D600012O00E4000200013O001276000300353O001276000400364O006C000200044O003800025O001276000100033O002EBC0037008B000100380004B23O008B0001000E960003008B000100010004B23O008B00012O00E400026O0085000300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200082O013O0004B23O00082O012O00E4000200133O0006E2000200082O013O0004B23O00082O012O00E4000200043O00208000020002000D4O000300146O000400156O00020004000200062O000200082O013O0004B23O00082O012O00E4000200163O0006E2000200082O013O0004B23O00082O012O00E4000200163O0020F700020002003B2O005B0002000200020006E2000200082O013O0004B23O00082O012O00E4000200033O0020F700020002003C2O00E4000400164O00BD000200040002000633000200082O0100010004B23O00082O012O00E4000200074O00E4000300083O0020F500030003003D2O005B0002000200020006E2000200082O013O0004B23O00082O012O00E4000200013O0012760003003E3O0012760004003F4O006C000200044O003800025O0012763O00033O0004B23O000B2O010004B23O008B000100260C3O000F2O0100030004B23O000F2O01002EA5004000B6000100410004B23O00C32O01001276000100013O002E6B0042009F2O0100430004B23O009F2O0100261E0001009F2O0100010004B23O009F2O01001276000200013O00260C000200192O0100030004B23O00192O01002EBC0045001B2O0100440004B23O001B2O01001276000100033O0004B23O009F2O0100260C0002001F2O0100010004B23O001F2O01002E6B004600152O0100470004B23O00152O01002EA500480022000100480004B23O00412O012O00E400036O0085000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300412O013O0004B23O00412O012O00E4000300173O0006E2000300412O013O0004B23O00412O012O00E4000300093O0020F70003000300182O005B0003000200022O00E4000400183O0006AC000300412O0100040004B23O00412O012O00E4000300074O00E4000400083O0020F500040004004B2O005B0003000200020006330003003C2O0100010004B23O003C2O01002EA5003400070001004C0004B23O00412O012O00E4000300013O0012760004004D3O0012760005004E4O006C000300054O003800036O00E4000300043O00208000030003000D4O000400196O0005001A6O00030005000200062O0003009D2O013O0004B23O009D2O012O00E40003001B3O0006E20003009D2O013O0004B23O009D2O012O00E400036O0085000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003009D2O013O0004B23O009D2O012O00E40003001C3O0006E20003009D2O013O0004B23O009D2O012O00E4000300033O0020F70003000300512O005B0003000200020006E20003009D2O013O0004B23O009D2O012O00E400036O0085000400013O00122O000500523O00122O000600536O0004000600024O00030003000400202O0003000300544O00030002000200062O000300712O013O0004B23O00712O012O00E400036O008E000400013O00122O000500553O00122O000600566O0004000600024O00030003000400202O0003000300544O00030002000200062O000300922O0100010004B23O00922O012O00E400036O0085000400013O00122O000500573O00122O000600586O0004000600024O00030003000400202O0003000300544O00030002000200062O000300812O013O0004B23O00812O012O00E4000300093O0020F70003000300182O005B0003000200022O00E4000400183O00066F00030012000100040004B23O00922O012O00E400036O0085000400013O00122O000500593O00122O0006005A6O0004000600024O00030003000400202O0003000300544O00030002000200062O0003009D2O013O0004B23O009D2O012O00E4000300043O00208000030003000D4O000400146O000500156O00030005000200062O0003009D2O013O0004B23O009D2O012O00E4000300074O00E400045O0020F500040004005B2O005B0003000200020006E20003009D2O013O0004B23O009D2O012O00E4000300013O0012760004005C3O0012760005005D4O006C000300054O003800035O001276000200033O0004B23O00152O0100261E000100102O0100030004B23O00102O012O00E400026O0085000300013O00122O0004005E3O00122O0005005F6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200C02O013O0004B23O00C02O012O00E40002001D3O0006E2000200C02O013O0004B23O00C02O012O00E4000200043O00208000020002000D4O0003001E6O0004001F6O00020004000200062O000200C02O013O0004B23O00C02O012O00E4000200074O00E4000300083O0020F50003000300602O005B0002000200020006E2000200C02O013O0004B23O00C02O012O00E4000200013O001276000300613O001276000400624O006C000200044O003800025O0012763O00023O0004B23O00C32O010004B23O00102O01002EBC0064007B020100630004B23O007B0201000E960011007B02013O0004B23O007B0201001276000100014O00AA000200023O00261E000100C92O0100010004B23O00C92O01001276000200013O00261E0002004B020100010004B23O004B0201002EA500650058000100650004B23O002602012O00E400036O0085000400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002602013O0004B23O002602012O00E4000300203O0006E20003002602013O0004B23O002602012O00E400036O0085000400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O00030003006A4O00030002000200062O000300F52O013O0004B23O00F52O012O00E4000300033O00204B00030003006B4O00055O00202O00050005006C4O00030005000200062O0003000B020100010004B23O000B02012O00E4000300033O00204600030003006D4O00055O00202O00050005006C4O00030005000200262O0003000B020100020004B23O000B02012O00E4000300033O00204B00030003000B4O00055O00202O00050005006E4O00030005000200062O0003000B020100010004B23O000B02012O00E400036O008E000400013O00122O0005006F3O00122O000600706O0004000600024O00030003000400202O00030003006A4O00030002000200062O00030026020100010004B23O002602012O00E4000300033O0020F70003000300712O005B000300020002000EB400720026020100030004B23O002602012O00E4000300093O0020F70003000300182O005B0003000200022O00E4000400213O00066F00030009000100040004B23O001902012O00E4000300093O0020F70003000300182O005B0003000200022O00E4000400223O00066F00030003000100040004B23O00190201002E6B00730026020100740004B23O002602012O00E4000300074O00B6000400083O00202O0004000400754O000500056O000600236O00030006000200062O0003002602013O0004B23O002602012O00E4000300013O001276000400763O001276000500774O006C000300054O003800036O00E400036O0085000400013O00122O000500783O00122O000600796O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003902013O0004B23O003902012O00E4000300243O0006E20003003902013O0004B23O003902012O00E4000300093O0020F70003000300182O005B0003000200022O00E4000400223O00066F00030003000100040004B23O003B0201002E6B007A004A0201007B0004B23O004A0201002E6B007D004A0201007C0004B23O004A02012O00E4000300074O00A7000400083O00202O00040004007E4O000500056O000600016O00030006000200062O0003004A02013O0004B23O004A02012O00E4000300013O0012760004007F3O001276000500804O006C000300054O003800035O001276000200033O00261E000200CC2O0100030004B23O00CC2O01002EA500810029000100810004B23O007602012O00E400036O0085000400013O00122O000500823O00122O000600836O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003007602013O0004B23O007602012O00E4000300253O0006E20003007602013O0004B23O007602012O00E40003001C3O0006E20003007602013O0004B23O007602012O00E400036O0085000400013O00122O000500843O00122O000600856O0004000600024O00030003000400202O0003000300544O00030002000200062O0003007602013O0004B23O007602012O00E4000300074O00A700045O00202O0004000400864O000500056O000600016O00030006000200062O0003007602013O0004B23O007602012O00E4000300013O001276000400873O001276000500884O006C000300054O003800035O0012763O00893O0004B23O007B02010004B23O00CC2O010004B23O007B02010004B23O00C92O0100261E3O0001000100890004B23O00010001002EBC008A00AA0201008B0004B23O00AA02012O00E400016O0085000200013O00122O0003008C3O00122O0004008D6O0002000400024O00010001000200202O00010001000A4O00010002000200062O000100AA02013O0004B23O00AA02012O00E4000100263O0006E2000100AA02013O0004B23O00AA02012O00E4000100093O00202100010001006B4O00035O00202O00030003008E4O00010003000200062O000100AA02013O0004B23O00AA02012O00E4000100093O0020F70001000100182O005B0001000200022O00E4000200273O0006AC000100AA020100020004B23O00AA02012O00E4000100074O00CC000200083O00202O00020002008F4O000300036O000400016O00010004000200062O000100A3020100010004B23O00A30201002E6B009000AA020100910004B23O00AA02012O00E4000100013O00126D000200923O00122O000300936O000100036O00015O00044O00AA02010004B23O000100012O004A3O00017O00E83O00028O00025O0050AC40025O00C09140026O001040025O00EC9F40025O00AEA44003083O0018118C016F3F088103053O0021507EE07803073O004973526561647903083O00486F6C794E6F7661025O00207640025O00F8974003143O00E4A70FDD63E2A715C563EDA7068458EDA502C35903053O003C8CC863A403083O0049734D6F76696E67025O0068AD40025O000CB340026O00F03F025O00B8AC40025O00F88540025O00C6AD40025O00F07340025O00804740025O00089140030E3O00B4FC0522AD90C30B34A6B7F50D2803053O00C2E794644603093O00436173744379636C65030E3O00536861646F77576F72645061696E030E3O0049735370652O6C496E52616E676503173O00536861646F77576F72645061696E4D6F7573656F766572025O006C9540025O00A8A640031D3O005544C0A7F9DF795BCEB1F2F7564DC8ADC9CB5F4FCDA6B6CC4741C0A4F303063O00A8262CA1C39603083O00A8F38E6F1EE7A01703083O0076E09CE2165088D6027O0040025O00989140025O00807F40025O0028AD40025O0020684003103O004AE155997DE0569643AE5D814FEF5E8503043O00E0228E39025O0020AA40025O00D2A940026O00144003053O00EDAACCC97603083O006EBEC7A5BD13913D025O008AA640025O00149E4003053O00536D697465025O00BEB140025O00E89840030C3O00C9E67EFC8E87DEEA7AE98CC203063O00A7BA8B1788EB030E3O0029BD890915A2BF0208B1B80C13BB03043O006D7AD5E8025O00207540025O0062AB4003203O00FDFFA334E1E09D27E1E5A60FFEF6AB3ED1FAAD26EBFAA73EFAB7A631E3F6A53503043O00508E97C2025O00405140026O000840030D3O000E1F384C9982C327302454918203073O00A24B724835EBE703083O00A43348FB750B9E3903063O0062EC5C248233030C3O00432O6F6C646F776E446F776E03083O008C1600A36BA7A33103083O0050C4796CDA25C8D5030B3O004973417661696C61626C65026O008540026O007740025O00D88F40030D3O00456D70797265616C426C617A6503083O00486F6C794669726503153O00057E1266590B8B0C4C00734A148F407703724A098F03073O00EA6013621F2B6E03093O002B165CC3AB7386030C03073O00EB667F32A7CC12025O00207240025O0074A540025O000C9E40025O00F9B14003093O004D696E6467616D657303093O004973496E52616E6765026O00444003103O005DA8FB27432F5DA4E663402F5DA0F22603063O004E30C1954324025O00EAAE40025O0066A040031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O004CAF40025O00288740030A3O00F7B0023BCBD3AF1E26D003053O00A3B6C06D4F030F3O00412O66656374696E67436F6D62617403103O001C290CD9C23B3404F3F43A2514C9F32D03053O0095544660A003103O00100901F40F091FE90B031FE8360F19F403043O008D58666D03103O009B5CC6692D3247C5905BCB630E3446C403083O00A1D333AA107A5D35030F3O00432O6F6C646F776E52656D61696E732O033O004743440200304O33C33F026O33C33F03083O00D3A1BE31D5A1A42903043O00489BCED2030A3O0041706F7468656F73697303113O00476A5B1A3B4375470720067E550332417F03053O0053261A346E025O006EA240025O002AAD4003083O0070182B5F7E1E354303043O002638774703083O00DBE054CF0B59E5EE03063O0036938F38B645025O00F4B140025O00C4A24003103O00DE8EF350E0D088ED4C9FD280F248D8D303053O00BFB6E19F29025O003CA040025O00606440025O0014B040025O00088740025O005C9240025O00D4AF40030A3O0009C749E248CAB339CF4D03073O00E04DAE3F8B26AF03133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C61796572026O003E40025O00449540025O0086B24003123O0080484E278A44673D90404A6E8040552F834403043O004EE4213803043O00E67FBE0C03053O00E5AE1ED263025O0058AF40025O00D0AF40025O00BEAD40025O00F09340030A3O0048616C6F506C61796572030B3O0013EC8A5EAD393816EC815403073O00597B8DE6318D5D025O0058A140025O0009B140025O00806C40025O0016B040025O00F4AB4003083O00DB7EFA153E45E57003063O002A9311966C7003093O0042752O66537461636B030C3O0052686170736F647942752O66026O003440025O00C6A640025O00D49D4003193O0007A92166D8E600B02C40F5E00EB63E70E3F14FA22C72E6EF0A03063O00886FC64D1F87025O00D08340025O00C6A14003103O002A06AB4F8AEB05AD2101A645A9ED04AC03083O00C96269C736DD847703083O0091038F382C3ABAB803073O00CCD96CE341625503103O00486F6C79576F7264436861737469736503193O0056CCF9FC13D751D1F1DA2FC85FD0E1EC3FC51EC7F4E82DC75B03063O00A03EA395854C025O000C9140025O00C2A540025O001EB240025O0030A640030D3O00E0000EF40C758DCE001FF00C6403073O00D9A1726D956210030E3O004D616E6150657263656E74616765025O00C05740030D3O00417263616E65546F2O72656E7403153O0013323B7DB2712D34376EAE711C342O78BD7913273D03063O00147240581CDC03063O0042752O66557003113O00506F776572496E667573696F6E42752O66025O00309440025O003EB140025O006EAB40025O00A8A040025O00208D40025O0008AF40030F3O000209D3B0F7C78A3E13D690FDD1A93903073O00DD5161B2D498B0030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030F3O00536861646F77576F72644465617468025O00D0B140025O000CA54003183O00DEEF1CFF15DAD80AF408C9D819FE1BD9EF5DFF1BC0E61AFE03053O007AAD877D9B030F3O00B7C901BD3026FF8BD3049D3A30DC8C03073O00A8E4A160D95F51025O00C6A340025O0002AF4003183O00536861646F77576F726444656174684D6F7573656F766572025O00108740025O0022A14003223O00C8D92F582040E4C6214E2B68DFD42F482768D6DE3B4F2A58CDD43C1C2B56D6D0295903063O0037BBB14E3C4F025O00FEB140025O008CAA40025O00F49C40025O00389B40030B3O00E0C200D458FA85C5CC1AC703073O00C8A4AB73A43D9603093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030B3O0044697370656C4D6167696303133O00BAFD105586B2CB0E4484B7F7434182B3F5044003053O00E3DE946325030B4O005A53F2F624545BF3F73703053O0099532O3296025O0014A340025O0008A440025O0016B140025O0048B040030B3O00536861646F776669656E6403123O004E7E72187CBC4B54737D1833AF4C5077741903073O002D3D16137C13CB025O00E0B140025O004AB34003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O00204000A5032O0012763O00014O00AA000100013O002E6B00030002000100020004B23O0002000100261E3O0002000100010004B23O00020001001276000100013O000E96000400A3000100010004B23O00A30001001276000200013O002EBC00050050000100060004B23O0050000100261E00020050000100010004B23O005000012O00E400036O0085000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002800013O0004B23O002800012O00E4000300023O000EB400040028000100030004B23O002800012O00E4000300034O00E400045O0020F500040004000A2O005B00030002000200063300030023000100010004B23O00230001002E6B000C00280001000B0004B23O002800012O00E4000300013O0012760004000D3O0012760005000E4O006C000300054O003800036O00E4000300043O0020F700030003000F2O005B0003000200020006E20003004F00013O0004B23O004F0001001276000300014O00AA000400053O00260C00030033000100010004B23O00330001002E6B00110036000100100004B23O00360001001276000400014O00AA000500053O001276000300123O002E6B0014002F000100130004B23O002F000100261E0003002F000100120004B23O002F0001002EBC0016003A000100150004B23O003A000100261E0004003A000100010004B23O003A0001001276000500013O000E960001003F000100050004B23O003F00012O00E4000600064O00FF0006000100022O002E000600054O00E4000600053O0006E20006004F00013O0004B23O004F00012O00E4000600054O00E9000600023O0004B23O004F00010004B23O003F00010004B23O004F00010004B23O003A00010004B23O004F00010004B23O002F0001001276000200123O00261E0002009C000100120004B23O009C0001001276000300013O002EBC00170097000100180004B23O0097000100261E00030097000100010004B23O009700012O00E400046O0085000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O0004000400094O00040002000200062O0004007A00013O0004B23O007A00012O00E4000400073O0020F600040004001B4O00055O00202O00050005001C4O000600086O000700096O0008000A3O00202O00080008001D4O000A5O00202O000A000A001C4O0008000A00024O000800086O0009000A6O000B000B3O00202O000B000B001E4O0004000B000200062O00040075000100010004B23O00750001002E6B0020007A0001001F0004B23O007A00012O00E4000400013O001276000500213O001276000600224O006C000400064O003800046O00E400046O0085000500013O00122O000600233O00122O000700246O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008700013O0004B23O008700012O00E4000400023O000E9B00250089000100040004B23O00890001002E6B00260096000100270004B23O009600012O00E4000400034O00E400055O0020F500050005000A2O005B00040002000200063300040091000100010004B23O00910001002EA500280007000100290004B23O009600012O00E4000400013O0012760005002A3O0012760006002B4O006C000400064O003800045O001276000300123O00261E00030053000100120004B23O00530001001276000200253O0004B23O009C00010004B23O00530001002E6B002D000A0001002C0004B23O000A000100261E0002000A000100250004B23O000A00010012760001002E3O0004B23O00A300010004B23O000A000100261E000100E30001002E0004B23O00E300012O00E400026O008E000300013O00122O0004002F3O00122O000500306O0003000500024O00020002000300202O0002000200094O00020002000200062O000200B1000100010004B23O00B10001002EBC003100C5000100320004B23O00C500012O00E4000200034O002O01035O00202O0003000300334O0004000A3O00202O00040004001D4O00065O00202O0006000600334O0004000600024O000400046O000500016O00020005000200062O000200C0000100010004B23O00C00001002E6B003400C5000100350004B23O00C500012O00E4000200013O001276000300363O001276000400374O006C000200044O003800026O00E400026O0085000300013O00122O000400383O00122O000500396O0003000500024O00020002000300202O0002000200094O00020002000200062O000200A403013O0004B23O00A40301002E6B003A00A40301003B0004B23O00A403012O00E4000200034O00D400035O00202O00030003001C4O0004000A3O00202O00040004001D4O00065O00202O00060006001C4O0004000600024O000400046O00020004000200062O000200A403013O0004B23O00A403012O00E4000200013O00126D0003003C3O00122O0004003D6O000200046O00025O00044O00A40301002EA5003E00F60001003E0004B23O00D92O0100261E000100D92O01003F0004B23O00D92O01001276000200013O000E96001200402O0100020004B23O00402O012O00E400036O0085000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O0003000300094O00030002000200062O0003000B2O013O0004B23O000B2O012O00E400036O0085000400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O0003000300444O00030002000200062O0003000B2O013O0004B23O000B2O012O00E400036O0085000400013O00122O000500453O00122O000600466O0004000600024O00030003000400202O0003000300474O00030002000200062O0003000D2O013O0004B23O000D2O012O00E4000300023O0026500003000D2O01002E0004B23O000D2O01002EA500480015000100490004B23O00202O01002EA5004A00130001004A0004B23O00202O012O00E4000300034O00D400045O00202O00040004004B4O0005000A3O00202O00050005001D4O00075O00202O00070007004C4O0005000700024O000500056O00030005000200062O000300202O013O0004B23O00202O012O00E4000300013O0012760004004D3O0012760005004E4O006C000300054O003800036O00E400036O008E000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002C2O0100010004B23O002C2O01002EBC0052003F2O0100510004B23O003F2O01002EBC0053003F2O0100540004B23O003F2O012O00E4000300034O000201045O00202O0004000400554O0005000A3O00202O00050005005600122O000700576O0005000700024O000500056O000600016O00030006000200062O0003003F2O013O0004B23O003F2O012O00E4000300013O001276000400583O001276000500594O006C000300054O003800035O001276000200253O000E96002500442O0100020004B23O00442O01001276000100043O0004B23O00D92O0100260C000200482O0100010004B23O00482O01002EA5005A00A2FF2O005B0004B23O00E800012O00E4000300073O00208000030003005C4O0004000C6O0005000D6O00030005000200062O000300AA2O013O0004B23O00AA2O012O00E40003000E3O0006E2000300AA2O013O0004B23O00AA2O01002EBC005E00AA2O01005D0004B23O00AA2O012O00E400036O0085000400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O0003000300094O00030002000200062O000300AA2O013O0004B23O00AA2O012O00E40003000F3O0006E2000300AA2O013O0004B23O00AA2O012O00E4000300043O0020F70003000300612O005B0003000200020006E2000300AA2O013O0004B23O00AA2O012O00E400036O0085000400013O00122O000500623O00122O000600636O0004000600024O00030003000400202O0003000300444O00030002000200062O000300AA2O013O0004B23O00AA2O012O00E400036O0085000400013O00122O000500643O00122O000600656O0004000600024O00030003000400202O0003000300444O00030002000200062O000300AA2O013O0004B23O00AA2O012O00E400036O000B000400013O00122O000500663O00122O000600676O0004000600024O00030003000400202O0003000300684O0003000200024O000400106O000500043O00202O0005000500694O00050002000200122O0006006A6O0004000600024O000500116O000600043O00202O0006000600694O00060002000200122O0007006B6O0005000700024O00040004000500202O00040004003F00062O000400AA2O0100030004B23O00AA2O012O00E400036O0085000400013O00122O0005006C3O00122O0006006D6O0004000600024O00030003000400202O0003000300474O00030002000200062O0003009F2O013O0004B23O009F2O012O00E4000300023O00260A000300AA2O01002E0004B23O00AA2O012O00E4000300034O00E400045O0020F500040004006E2O005B0003000200020006E2000300AA2O013O0004B23O00AA2O012O00E4000300013O0012760004006F3O001276000500704O006C000300054O003800035O002E6B007100D72O0100720004B23O00D72O012O00E400036O0085000400013O00122O000500733O00122O000600746O0004000600024O00030003000400202O0003000300094O00030002000200062O000300D72O013O0004B23O00D72O012O00E400036O0085000400013O00122O000500753O00122O000600766O0004000600024O00030003000400202O0003000300474O00030002000200062O000300C32O013O0004B23O00C32O012O00E4000300023O00260A000300D72O01002E0004B23O00D72O012O00E4000300034O009100045O00202O00040004004C4O0005000A3O00202O00050005001D4O00075O00202O00070007004C4O0005000700024O000500056O000600126O00030006000200062O000300D22O0100010004B23O00D22O01002E6B007700D72O0100780004B23O00D72O012O00E4000300013O001276000400793O0012760005007A4O006C000300054O003800035O001276000200123O0004B23O00E8000100261E0001008C020100250004B23O008C0201001276000200014O00AA000300033O002EBC007C00DD2O01007B0004B23O00DD2O0100261E000200DD2O0100010004B23O00DD2O01001276000300013O002EBC007E00360201007D0004B23O0036020100261E00030036020100010004B23O00360201001276000400013O000E8D000100EB2O0100040004B23O00EB2O01002EBC0080002F0201007F0004B23O002F02012O00E400056O0085000600013O00122O000700813O00122O000800826O0006000800024O00050005000600202O0005000500094O00050002000200062O0005000C02013O0004B23O000C02012O00E40005000A3O0020F70005000500832O005B0005000200020006330005000C020100010004B23O000C02012O00E4000500035O000106000B3O00202O0006000600844O0007000A3O00202O00070007005600122O000900856O0007000900024O000700076O00050007000200062O00050007020100010004B23O00070201002EA500860007000100870004B23O000C02012O00E4000500013O001276000600883O001276000700894O006C000500074O003800056O00E400056O0085000600013O00122O0007008A3O00122O0008008B6O0006000800024O00050005000600202O0005000500094O00050002000200062O0005001902013O0004B23O001902012O00E4000500133O0006330005001B020100010004B23O001B0201002E6B008D002E0201008C0004B23O002E0201002E6B008F002E0201008E0004B23O002E02012O00E4000500034O00020106000B3O00202O0006000600904O0007000A3O00202O00070007005600122O000900856O0007000900024O000700076O000800016O00050008000200062O0005002E02013O0004B23O002E02012O00E4000500013O001276000600913O001276000700924O006C000500074O003800055O001276000400123O002E6B009300E72O0100940004B23O00E72O0100261E000400E72O0100120004B23O00E72O01001276000300123O0004B23O003602010004B23O00E72O01002EA500950006000100950004B23O003C0201000E960025003C020100030004B23O003C02010012760001003F3O0004B23O008C0201000E8D00120040020100030004B23O00400201002E6B009600E22O0100970004B23O00E22O012O00E400046O0085000500013O00122O000600983O00122O000700996O0005000700024O00040004000500202O0004000400094O00040002000200062O0004005E02013O0004B23O005E02012O00E4000400043O00200501040004009A4O00065O00202O00060006009B4O00040006000200262O0004005E0201009C0004B23O005E02012O00E4000400034O00E400055O0020F500050005000A2O005B00040002000200063300040059020100010004B23O00590201002EBC009D005E0201009E0004B23O005E02012O00E4000400013O0012760005009F3O001276000600A04O006C000400064O003800045O002E6B00A10088020100A20004B23O008802012O00E400046O0085000500013O00122O000600A33O00122O000700A46O0005000700024O00040004000500202O0004000400094O00040002000200062O0004008802013O0004B23O008802012O00E400046O0085000500013O00122O000600A53O00122O000700A66O0005000700024O00040004000500202O0004000400474O00040002000200062O0004007702013O0004B23O007702012O00E4000400023O00260A000400880201002E0004B23O008802012O00E4000400034O00D400055O00202O0005000500A74O0006000A3O00202O00060006001D4O00085O00202O0008000800A74O0006000800024O000600066O00040006000200062O0004008802013O0004B23O008802012O00E4000400013O001276000500A83O001276000600A94O006C000400064O003800045O001276000300253O0004B23O00E22O010004B23O008C02010004B23O00DD2O01002E6B00AA002F030100AB0004B23O002F030100261E0001002F030100120004B23O002F0301001276000200013O002E6B00AD00DA020100AC0004B23O00DA020100261E000200DA020100010004B23O00DA02012O00E400036O0085000400013O00122O000500AE3O00122O000600AF6O0004000600024O00030003000400202O0003000300094O00030002000200062O000300B502013O0004B23O00B502012O00E4000300143O0006E2000300B502013O0004B23O00B502012O00E40003000F3O0006E2000300B502013O0004B23O00B502012O00E4000300043O0020F70003000300B02O005B00030002000200260E000300B5020100B10004B23O00B502012O00E4000300034O00E400045O0020F50004000400B22O005B0003000200020006E2000300B502013O0004B23O00B502012O00E4000300013O001276000400B33O001276000500B44O006C000300054O003800036O00E4000300153O0006E2000300D902013O0004B23O00D902012O00E40003000F3O0006E2000300D902013O0004B23O00D902012O00E4000300043O0020210003000300B54O00055O00202O0005000500B64O00030005000200062O000300D902013O0004B23O00D90201001276000300014O00AA000400043O00260C000300C8020100010004B23O00C80201002EBC00B800C4020100B70004B23O00C40201001276000400013O000E96000100C9020100040004B23O00C902012O00E4000500164O00FF0005000100022O002E000500053O002EA500B9000B000100B90004B23O00D902012O00E4000500053O0006E2000500D902013O0004B23O00D902012O00E4000500054O00E9000500023O0004B23O00D902010004B23O00C902010004B23O00D902010004B23O00C40201001276000200123O002EA500BA0050000100BA0004B23O002A0301000E960012002A030100020004B23O002A0301002E6B00BB0002030100BC0004B23O000203012O00E400036O0085000400013O00122O000500BD3O00122O000600BE6O0004000600024O00030003000400202O0003000300BF4O00030002000200062O0003000203013O0004B23O000203012O00E40003000A3O0020F70003000300C02O005B00030002000200260E000300020301009C0004B23O000203012O00E4000300034O00A300045O00202O0004000400C14O0005000A3O00202O00050005001D4O00075O00202O0007000700C14O0005000700024O000500056O00030005000200062O000300FD020100010004B23O00FD0201002E6B00C20002030100C30004B23O000203012O00E4000300013O001276000400C43O001276000500C54O006C000300054O003800036O00E400036O0085000400013O00122O000500C63O00122O000600C76O0004000600024O00030003000400202O0003000300BF4O00030002000200062O0003001403013O0004B23O001403012O00E4000300173O0006E20003001403013O0004B23O001403012O00E4000300173O0020F70003000300C02O005B000300020002002682000300160301009C0004B23O00160301002E6B00C90029030100C80004B23O002903012O00E4000300034O00A30004000B3O00202O0004000400CA4O000500173O00202O00050005001D4O00075O00202O0007000700C14O0005000700024O000500056O00030005000200062O00030024030100010004B23O00240301002EBC00CC0029030100CB0004B23O002903012O00E4000300013O001276000400CD3O001276000500CE4O006C000300054O003800035O001276000200253O000E9600250091020100020004B23O00910201001276000100253O0004B23O002F03010004B23O00910201002E6B00D00007000100CF0004B23O00070001000E9600010007000100010004B23O00070001001276000200013O002EBC00D2008B030100D10004B23O008B030100261E0002008B030100120004B23O008B03012O00E400036O0085000400013O00122O000500D33O00122O000600D46O0004000600024O00030003000400202O0003000300094O00030002000200062O0003006903013O0004B23O006903012O00E4000300183O0006E20003006903013O0004B23O006903012O00E4000300193O0006E20003006903013O0004B23O006903012O00E4000300043O0020F70003000300D52O005B00030002000200063300030069030100010004B23O006903012O00E4000300043O0020F70003000300D62O005B00030002000200063300030069030100010004B23O006903012O00E4000300073O0020F50003000300D72O00E40004000A4O005B0003000200020006E20003006903013O0004B23O006903012O00E4000300034O00D400045O00202O0004000400D84O0005000A3O00202O00050005001D4O00075O00202O0007000700D84O0005000700024O000500056O00030005000200062O0003006903013O0004B23O006903012O00E4000300013O001276000400D93O001276000500DA4O006C000300054O003800036O00E400036O0085000400013O00122O000500DB3O00122O000600DC6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003007B03013O0004B23O007B03012O00E40003000F3O0006E20003007B03013O0004B23O007B03012O00E4000300043O0020F70003000300B02O005B0003000200020026820003007D030100B10004B23O007D0301002EBC00DE008A030100DD0004B23O008A0301002E6B00E0008A030100DF0004B23O008A03012O00E4000300034O00E400045O0020F50004000400E12O005B0003000200020006E20003008A03013O0004B23O008A03012O00E4000300013O001276000400E23O001276000500E34O006C000300054O003800035O001276000200253O00260C0002008F030100010004B23O008F0301002EBC00E5009C030100E40004B23O009C03012O00E4000300073O0020450003000300E64O00045O00202O0004000400E700122O000500E86O0003000500024O000300056O000300053O00062O0003009B03013O0004B23O009B03012O00E4000300054O00E9000300023O001276000200123O00261E00020034030100250004B23O00340301001276000100123O0004B23O000700010004B23O003403010004B23O000700010004B23O00A403010004B23O000200012O004A3O00017O00643O00028O00026O00F03F027O0040030D3O00546172676574497356616C6964025O00E4A640025O00488440025O00C89540025O00A06040026O007B40025O00F07E40025O00805040025O00C0964003083O0049734D6F76696E67025O00708B40025O002CA940025O00C06F40025O00B2A940025O002EA540025O00088640025O0094A340025O004CAA40025O00C05E40025O00508740025O005CB140025O00F08B40025O00809540025O00388240025O00F6A240025O002EA340030F3O0048616E646C65412O666C6963746564030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572026O004440025O0082AA40025O0052A540025O004FB040025O00E8B140025O00789D4003063O00507572696679030F3O005075726966794D6F7573656F766572026O00084003093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572025O004C9040025O00D0A140025O00D88440025O00C0514003103O00486F6C79576F7264536572656E69747903193O00486F6C79576F7264536572656E6974794D6F7573656F766572025O0082B140025O00D2A540025O00888140025O00A7B140025O00288540025O00689640025O0016A640025O00F8A340026O001040025O0044A840025O0044B340025O00049340025O00707F4003113O0048616E646C65496E636F72706F7265616C030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572026O003E40025O00907B40025O0007B340025O004EAD40025O00D88640030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572025O00A6A340025O00309C40025O0080A740025O00109E40025O00707240025O00DCB240025O00F49A40025O0069B040025O00CCA040025O0008A840025O003AB240025O00AC9F40025O00ACA740025O005AA940025O00DCAB40025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD40030D3O0048616E646C654368726F6D6965025O00BFB040026O005F40025O0012A440025O009CAE40025O00A4A840025O00B89F40001C022O0012763O00014O00AA000100023O00261E3O0015020100020004B23O0015020100261E00010004000100010004B23O00040001001276000200013O00261E00020050000100030004B23O005000012O00E400035O0020F50003000300042O00FF0003000100020006E20003003100013O0004B23O00310001001276000300014O00AA000400053O002EBC00060017000100050004B23O00170001000E9600010017000100030004B23O00170001001276000400014O00AA000500053O001276000300023O00261E00030010000100020004B23O0010000100260C0004001D000100010004B23O001D0001002EBC00070019000100080004B23O00190001001276000500013O00261E0005001E000100010004B23O001E00012O00E4000600024O00FF0006000100022O002E000600014O00E4000600013O00063300060028000100010004B23O00280001002EA5000900F52O01000A0004B23O001B02012O00E4000600014O00E9000600023O0004B23O001B02010004B23O001E00010004B23O001B02010004B23O001900010004B23O001B02010004B23O001000010004B23O001B0201002EBC000B001B0201000C0004B23O001B02012O00E4000300033O0020F700030003000D2O005B0003000200020006E20003001B02013O0004B23O001B0201001276000300014O00AA000400043O000E8D0001003E000100030004B23O003E0001002E6B000F003A0001000E0004B23O003A0001001276000400013O00261E0004003F000100010004B23O003F00012O00E4000500044O00FF0005000100022O002E000500014O00E4000500013O00063300050049000100010004B23O00490001002E6B0011001B020100100004B23O001B02012O00E4000500014O00E9000500023O0004B23O001B02010004B23O003F00010004B23O001B02010004B23O003A00010004B23O001B020100261E0002006B000100010004B23O006B0001001276000300014O00AA000400043O00261E00030054000100010004B23O00540001001276000400013O00261E0004005B000100020004B23O005B0001001276000200023O0004B23O006B000100261E00040057000100010004B23O005700012O00E4000500054O00FF0005000100022O002E000500014O00E4000500013O00063300050065000100010004B23O00650001002E6B00120067000100130004B23O006700012O00E4000500014O00E9000500023O001276000400023O0004B23O005700010004B23O006B00010004B23O00540001000E8D0002006F000100020004B23O006F0001002E6B00150007000100140004B23O00070001001276000300013O00261E0003000A020100010004B23O000A02012O00E4000400063O00063300040077000100010004B23O00770001002EBC001700F6000100160004B23O00F60001001276000400013O00260C0004007C000100020004B23O007C0001002E6B00180099000100190004B23O00990001001276000500013O002EBC001B00830001001A0004B23O0083000100261E00050083000100020004B23O00830001001276000400033O0004B23O0099000100260C00050087000100010004B23O00870001002EA5001C00F8FF2O001D0004B23O007D00012O00E400065O00202B00060006001E4O000700073O00202O00070007001F4O000800083O00202O00080008002000122O000900216O0006000900024O000600013O002E2O00230097000100220004B23O009700012O00E4000600013O0006E20006009700013O0004B23O009700012O00E4000600014O00E9000600023O001276000500023O0004B23O007D000100261E000400BE000100010004B23O00BE0001001276000500013O002EA50024001D000100240004B23O00B9000100261E000500B9000100010004B23O00B90001001276000600013O002EBC002600B4000100250004B23O00B40001000E96000100B4000100060004B23O00B400012O00E400075O00206A00070007001E4O000800073O00202O0008000800274O000900083O00202O00090009002800122O000A00216O0007000A00024O000700016O000700013O00062O000700B300013O0004B23O00B300012O00E4000700014O00E9000700023O001276000600023O000E96000200A1000100060004B23O00A10001001276000500023O0004B23O00B900010004B23O00A10001000E960002009C000100050004B23O009C0001001276000400023O0004B23O00BE00010004B23O009C000100261E000400D0000100290004B23O00D000012O00E400055O00207C00050005001E4O000600073O00202O00060006002A4O000700083O00202O00070007002B00122O000800216O000900016O0005000900024O000500016O000500013O00062O000500F600013O0004B23O00F600012O00E4000500014O00E9000500023O0004B23O00F6000100261E00040078000100030004B23O00780001001276000500014O00AA000600063O00261E000500D4000100010004B23O00D40001001276000600013O00260C000600DB000100020004B23O00DB0001002E6B002D00DD0001002C0004B23O00DD0001001276000400293O0004B23O0078000100260C000600E1000100010004B23O00E10001002EBC002E00D70001002F0004B23O00D700012O00E400075O00202200070007001E4O000800073O00202O0008000800304O000900083O00202O00090009003100122O000A00216O0007000A00024O000700016O000700013O00062O000700EF000100010004B23O00EF0001002EBC003200F1000100330004B23O00F100012O00E4000700014O00E9000700023O001276000600023O0004B23O00D700010004B23O007800010004B23O00D400010004B23O00780001002EBC00340009020100350004B23O000902012O00E4000400093O0006E20004000902013O0004B23O00090201001276000400014O00AA000500053O00260C0004003O0100010004B23O003O01002EA5003600FEFF2O00370004B23O00FD0001001276000500013O002EA500380069000100380004B23O006B2O01000E960029006B2O0100050004B23O006B2O01001276000600014O00AA000700073O002EA500393O000100390004B23O00082O0100261E000600082O0100010004B23O00082O01001276000700013O000E96000200112O0100070004B23O00112O010012760005003A3O0004B23O006B2O01000E960001000D2O0100070004B23O000D2O01001276000800013O00261E000800632O0100010004B23O00632O012O00E40009000A3O0006330009001B2O0100010004B23O001B2O01002E6B003C005F2O01003B0004B23O005F2O01001276000900014O00AA000A000A3O00261E0009001D2O0100010004B23O001D2O01001276000A00013O00261E000A00462O0100010004B23O00462O01001276000B00013O00261E000B00272O0100020004B23O00272O01001276000A00023O0004B23O00462O0100261E000B00232O0100010004B23O00232O01001276000C00013O00260C000C002E2O0100010004B23O002E2O01002E6B003D00402O01003E0004B23O00402O012O00E4000D5O00200F000D000D003F4O000E00073O00202O000E000E00404O000F00083O00202O000F000F004100122O001000426O001100016O000D001100024O000D00016O000D00013O00062O000D003D2O0100010004B23O003D2O01002E6B0044003F2O0100430004B23O003F2O012O00E4000D00014O00E9000D00023O001276000C00023O00261E000C002A2O0100020004B23O002A2O01001276000B00023O0004B23O00232O010004B23O002A2O010004B23O00232O01002EBC004600202O0100450004B23O00202O01000E96000200202O01000A0004B23O00202O012O00E4000B5O00200F000B000B003F4O000C00073O00202O000C000C00474O000D00083O00202O000D000D004800122O000E00426O000F00016O000B000F00024O000B00016O000B00013O00062O000B00592O0100010004B23O00592O01002EBC0049005F2O01004A0004B23O005F2O012O00E4000B00014O00E9000B00023O0004B23O005F2O010004B23O00202O010004B23O005F2O010004B23O001D2O012O00E40009000B4O00FF0009000100022O002E000900013O001276000800023O00261E000800142O0100020004B23O00142O01001276000700023O0004B23O000D2O010004B23O00142O010004B23O000D2O010004B23O006B2O010004B23O00082O0100261E000500BD2O0100010004B23O00BD2O01001276000600013O002EBC004C00742O01004B0004B23O00742O0100261E000600742O0100020004B23O00742O01001276000500023O0004B23O00BD2O01002EA5004D00FAFF2O004D0004B23O006E2O01000E960001006E2O0100060004B23O006E2O012O00E40007000C3O0006E20007009F2O013O0004B23O009F2O01001276000700014O00AA000800093O00261E000700822O0100010004B23O00822O01001276000800014O00AA000900093O001276000700023O002E6B004F007D2O01004E0004B23O007D2O0100261E0007007D2O0100020004B23O007D2O0100260C0008008A2O0100010004B23O008A2O01002EBC005000862O0100510004B23O00862O01001276000900013O00260C0009008F2O0100010004B23O008F2O01002E6B0053008B2O0100520004B23O008B2O012O00E4000A000D4O00FF000A000100022O002E000A00014O00E4000A00013O000633000A00972O0100010004B23O00972O01002E6B0055009F2O0100540004B23O009F2O012O00E4000A00014O00E9000A00023O0004B23O009F2O010004B23O008B2O010004B23O009F2O010004B23O00862O010004B23O009F2O010004B23O007D2O01002E6B005600BB2O0100570004B23O00BB2O012O00E40007000E3O0006E2000700BB2O013O0004B23O00BB2O01001276000700014O00AA000800083O00260C000700AA2O0100010004B23O00AA2O01002E6B005800A62O0100590004B23O00A62O01001276000800013O002EBC005A00AB2O01005B0004B23O00AB2O0100261E000800AB2O0100010004B23O00AB2O012O00E40009000F4O00FF0009000100022O002E000900014O00E4000900013O0006E2000900BB2O013O0004B23O00BB2O012O00E4000900014O00E9000900023O0004B23O00BB2O010004B23O00AB2O010004B23O00BB2O010004B23O00A62O01001276000600023O0004B23O006E2O0100261E000500D92O0100030004B23O00D92O01001276000600013O002EBC005C00D42O01005D0004B23O00D42O0100261E000600D42O0100010004B23O00D42O012O00E400075O00207C00070007005E4O000800073O00202O00080008002A4O000900083O00202O00090009002B00122O000A00216O000B00016O0007000B00024O000700016O000700013O00062O000700D32O013O0004B23O00D32O012O00E4000700014O00E9000700023O001276000600023O00261E000600C02O0100020004B23O00C02O01001276000500293O0004B23O00D92O010004B23O00C02O0100261E000500FC2O0100020004B23O00FC2O01001276000600013O00261E000600F72O0100010004B23O00F72O01001276000700013O00261E000700F02O0100010004B23O00F02O012O00E400085O00206A00080008005E4O000900073O00202O0009000900304O000A00083O00202O000A000A003100122O000B00216O0008000B00024O000800016O000800013O00062O000800EF2O013O0004B23O00EF2O012O00E4000800014O00E9000800023O001276000700023O002E6B006000DF2O01005F0004B23O00DF2O0100261E000700DF2O0100020004B23O00DF2O01001276000600023O0004B23O00F72O010004B23O00DF2O0100261E000600DC2O0100020004B23O00DC2O01001276000500033O0004B23O00FC2O010004B23O00DC2O0100261E000500022O01003A0004B23O00022O01002E6B00610009020100620004B23O000902012O00E4000600013O0006E20006000902013O0004B23O000902012O00E4000600014O00E9000600023O0004B23O000902010004B23O00022O010004B23O000902010004B23O00FD0001001276000300023O00260C0003000E020100020004B23O000E0201002E6B00630070000100640004B23O00700001001276000200033O0004B23O000700010004B23O007000010004B23O000700010004B23O001B02010004B23O000400010004B23O001B020100261E3O0002000100010004B23O00020001001276000100014O00AA000200023O0012763O00023O0004B23O000200012O004A3O00017O004B3O00028O00025O0062AD40025O00508540025O002OA040025O00208A40026O00F03F025O0072A240025O009C9040026O000840025O00F89B40025O002AA940030F3O0048616E646C65412O666C696374656403093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572026O004440027O0040025O006BB140025O0016AE4003103O00486F6C79576F7264536572656E69747903193O00486F6C79576F7264536572656E6974794D6F7573656F766572025O0032A740025O00109D40025O0096A040025O00804340030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572025O00A8A040025O00206940025O00F2B040025O007DB14003063O00507572696679030F3O005075726966794D6F7573656F766572025O00109B40025O00B2AB40025O00949140026O005040025O001EA940025O004AAF40025O00DEA240025O00C8844003123O00C30C3E15906F1764F725260296510C63F70603083O001693634970E23878030A3O0049734361737461626C6503083O0042752O66446F776E03163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E6703183O00506F776572576F7264466F72746974756465506C6179657203143O00A87AF5F09F8762EDE7898773EDE799B161F7F18803053O00EDD8158295025O00049140025O003AA140025O00C4A040025O00A0834003083O0049734D6F76696E67025O00AEAA40025O0061B140025O00949B40025O00D6B040025O00508C40026O00694003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B026O00A840025O00AAA040025O00408C40025O00E0954003163O0044656164467269656E646C79556E697473436F756E7403103O004D612O73526573752O72656374696F6E03113O000EC7645F3CD4725F16D4654900D27E430D03043O002C63A617030C3O00526573752O72656374696F6E030C3O006EF23A2321B679F43D3F3CAA03063O00C41C97495653008A012O0012763O00014O00AA000100013O00260C3O0006000100010004B23O00060001002E6B00020002000100030004B23O00020001001276000100013O00261E000100DB000100010004B23O00DB0001001276000200013O002EBC000500D6000100040004B23O00D6000100261E000200D6000100010004B23O00D600012O00E400035O0006E20003009500013O0004B23O00950001001276000300014O00AA000400053O00261E00030018000100010004B23O00180001001276000400014O00AA000500053O001276000300063O00260C0003001C000100060004B23O001C0001002E6B00070013000100080004B23O0013000100261E0004001C000100010004B23O001C0001001276000500013O00260C00050023000100090004B23O00230001002E6B000B00330001000A0004B23O003300012O00E4000600023O00207C00060006000C4O000700033O00202O00070007000D4O000800043O00202O00080008000E00122O0009000F6O000A00016O0006000A00024O000600016O000600013O00062O0006009500013O0004B23O009500012O00E4000600014O00E9000600023O0004B23O0095000100261E00050058000100100004B23O00580001001276000600014O00AA000700073O002E6B00120037000100110004B23O0037000100261E00060037000100010004B23O00370001001276000700013O00261E0007004F000100010004B23O004F00012O00E4000800023O00202200080008000C4O000900033O00202O0009000900134O000A00043O00202O000A000A001400122O000B000F6O0008000B00024O000800016O000800013O00062O0008004C000100010004B23O004C0001002E6B0015004E000100160004B23O004E00012O00E4000800014O00E9000800023O001276000700063O000E8D00060053000100070004B23O00530001002EA5001700EBFF2O00180004B23O003C0001001276000500093O0004B23O005800010004B23O003C00010004B23O005800010004B23O00370001000E9600060075000100050004B23O00750001001276000600013O000E960001006E000100060004B23O006E00012O00E4000700023O00202200070007000C4O000800033O00202O0008000800194O000900043O00202O00090009001A00122O000A000F6O0007000A00024O000700016O000700013O00062O0007006B000100010004B23O006B0001002E6B001B006D0001001C0004B23O006D00012O00E4000700014O00E9000700023O001276000600063O00260C00060072000100060004B23O00720001002E6B001E005B0001001D0004B23O005B0001001276000500103O0004B23O007500010004B23O005B000100261E0005001F000100010004B23O001F0001001276000600013O000E960006007C000100060004B23O007C0001001276000500063O0004B23O001F000100261E00060078000100010004B23O007800012O00E4000700023O00202200070007000C4O000800033O00202O00080008001F4O000900043O00202O00090009002000122O000A000F6O0007000A00024O000700016O000700013O00062O0007008C000100010004B23O008C0001002E6B0022008E000100210004B23O008E00012O00E4000700014O00E9000700023O001276000600063O0004B23O007800010004B23O001F00010004B23O009500010004B23O001C00010004B23O009500010004B23O001300012O00E4000300053O0006E2000300D500013O0004B23O00D50001001276000300014O00AA000400043O002E6B0024009A000100230004B23O009A0001000E960001009A000100030004B23O009A0001001276000400013O00261E0004009F000100010004B23O009F00012O00E4000500063O0006E2000500B900013O0004B23O00B90001001276000500014O00AA000600063O00260C000500AA000100010004B23O00AA0001002EBC002600A6000100250004B23O00A60001001276000600013O00261E000600AB000100010004B23O00AB00012O00E4000700074O00FF0007000100022O002E000700014O00E4000700013O0006E2000700B900013O0004B23O00B900012O00E4000700014O00E9000700023O0004B23O00B900010004B23O00AB00010004B23O00B900010004B23O00A600012O00E4000500083O0006E2000500D500013O0004B23O00D50001001276000500014O00AA000600063O00261E000500BE000100010004B23O00BE0001001276000600013O002EBC002800C1000100270004B23O00C1000100261E000600C1000100010004B23O00C100012O00E4000700094O00FF0007000100022O002E000700014O00E4000700013O0006E2000700D500013O0004B23O00D500012O00E4000700014O00E9000700023O0004B23O00D500010004B23O00C100010004B23O00D500010004B23O00BE00010004B23O00D500010004B23O009F00010004B23O00D500010004B23O009A0001001276000200063O000E960006000A000100020004B23O000A0001001276000100063O0004B23O00DB00010004B23O000A000100261E000100052O0100100004B23O00052O012O00E4000200034O00850003000A3O00122O000400293O00122O0005002A6O0003000500024O00020002000300202O00020002002B4O00020002000200062O000200892O013O0004B23O00892O012O00E40002000B3O0006E2000200892O013O0004B23O00892O012O00E40002000C3O00209A00020002002C4O000400033O00202O00040004002D4O000500016O00020005000200062O000200F9000100010004B23O00F900012O00E4000200023O00201300020002002E4O000300033O00202O00030003002D4O00020002000200062O000200892O013O0004B23O00892O012O00E40002000D4O00E4000300043O0020F500030003002F2O005B0002000200020006E2000200892O013O0004B23O00892O012O00E40002000A3O00126D000300303O00122O000400316O000200046O00025O00044O00892O01000E8D000600092O0100010004B23O00092O01002EBC00330007000100320004B23O00070001001276000200013O00260C0002000E2O0100010004B23O000E2O01002E6B003400812O0100350004B23O00812O01001276000300013O00261E0003007C2O0100010004B23O007C2O012O00E40004000C3O0020F70004000400362O005B000400020002000633000400182O0100010004B23O00182O01002E6B0038002F2O0100370004B23O002F2O01001276000400014O00AA000500053O00260C0004001E2O0100010004B23O001E2O01002EBC003A001A2O0100390004B23O001A2O01001276000500013O00261E0005001F2O0100010004B23O001F2O012O00E40006000E4O00FF0006000100022O002E000600013O002EBC003C002F2O01003B0004B23O002F2O012O00E4000600013O0006E20006002F2O013O0004B23O002F2O012O00E4000600014O00E9000600023O0004B23O002F2O010004B23O001F2O010004B23O002F2O010004B23O001A2O012O00E40004000F3O0006E20004007B2O013O0004B23O007B2O012O00E40004000F3O0020F700040004003D2O005B0004000200020006E20004007B2O013O0004B23O007B2O012O00E40004000F3O0020F700040004003E2O005B0004000200020006E20004007B2O013O0004B23O007B2O012O00E40004000F3O0020F700040004003F2O005B0004000200020006E20004007B2O013O0004B23O007B2O012O00E40004000C3O0020F70004000400402O00E40006000F4O00BD0004000600020006330004007B2O0100010004B23O007B2O01001276000400014O00AA000500063O000E960001004E2O0100040004B23O004E2O01001276000500014O00AA000600063O001276000400063O00260C000400522O0100060004B23O00522O01002E6B004100492O0100420004B23O00492O01002E6B004300522O0100440004B23O00522O0100261E000500522O0100010004B23O00522O012O00E4000700023O0020F50007000700452O00FF0007000100022O0059000600073O000EB40006006A2O0100060004B23O006A2O012O00E40007000D4O00A7000800033O00202O0008000800464O000900096O000A00016O0007000A000200062O0007007B2O013O0004B23O007B2O012O00E40007000A3O00126D000800473O00122O000900486O000700096O00075O00044O007B2O012O00E40007000D4O00A7000800033O00202O0008000800494O000900096O000A00016O0007000A000200062O0007007B2O013O0004B23O007B2O012O00E40007000A3O00126D0008004A3O00122O0009004B6O000700096O00075O00044O007B2O010004B23O00522O010004B23O007B2O010004B23O00492O01001276000300063O00261E0003000F2O0100060004B23O000F2O01001276000200063O0004B23O00812O010004B23O000F2O0100261E0002000A2O0100060004B23O000A2O01001276000100103O0004B23O000700010004B23O000A2O010004B23O000700010004B23O00892O010004B23O000200012O004A3O00017O009A3O00028O00026O001440025O00708640025O002EAE40027O0040026O001840026O00F03F030C3O004570696353652O74696E677303083O00C5F36D158FD2F1E503063O00BC2O961961E603073O00EF9A5A2A0DE1D503063O008DBAE93F626C03083O00C2EF38A22CFFED3F03053O0045918A4CD603063O0058CE8586972603063O007610AF2OE9DF025O0066A340025O005EA14003083O00F72A353006CA283203053O006FA44F4144030C3O00F3CA86F822EBD5D1ABDB2FE603063O008AA6B9E3BE4E03083O00F871D1235B2D1ED803073O0079AB14A5573243030B3O00E034B825B12AC339B51E8903063O0062A658D956D9025O00F49540025O00E88940025O001AAA40026O00AE40025O00408F4003083O00C6BB1E0F7EF6F2AD03063O009895DE6A7B1703143O00FE2FE440B9D809F06BB0DC2AFF4DB2FA34F956A503053O00D5BD46962303083O007C50601C465B731B03043O00682F351403123O0093439619AE26AD4A940FB500AD79921DBB0A03063O006FC32CE17CDC034O00026O000840025O00C8A440025O00D09D40025O00E0A140025O009EA34003083O003E34216904700A2203063O001E6D51551D6D03123O00CA6251953FCCFFF3747BB01EDBFDF3785AB103073O009C9F1134D656BE03083O009DEAA9A8A7E1BAAF03043O00DCCE8FDD03113O00A5743F14D4C9FD80552816D4C5DC81551D03073O00B2E61D4D77B8AC025O0010AC40025O0039B140025O00E9B240025O005EA740025O005EA640025O00D8A34003083O00EB431467A2A5DF5503063O00CBB8266013CB03073O00095A5740C33C2203053O00AE5913192103083O001C17465AFE890C3C03073O006B4F72322E97E703073O00098F9B28873CE503083O00A059C6D549EA59D7025O00E2A740025O00D6B240026O00104003083O007B74A0EACC4676A703053O00A52811D49E03073O00D5F026322BE08A03053O004685B9685303083O003740503EC00A425703053O00A96425244A030D3O003594A7740991AB5E05AFBB5D0E03043O003060E7C203083O00B88121AFE7857A9803073O001DEBE455DB8EEB03093O0015D5B6D2505C28472D03083O00325DB4DABD172E4703083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC03073O000956D99CFF7C0103073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A35103063O00324722AF177903083O006E7A2243C35F2985025O0050B240025O00449740026O008A40025O00A2B24003083O003DA864F0028C09BE03063O00E26ECD10846B030C3O00CAD3EFCD49EECCF3D052C3F303053O00218BA380B903083O00645D10CA5E5603CD03043O00BE373864030F3O0077BF330A1BE6FC45A62F3901ECE64603073O009336CF5C7E738303083O00B72DB2D5D15DB59703073O00D2E448C6A1B833030F3O00035AF6236AC33446FF3F75E63959F603063O00AE562993701303083O006805991F2C0116B803083O00CB3B60ED6B456F71030D3O001105A9C021FFC32C13A3F238E303073O00B74476CC815190025O00389E40025O00ACB140025O0074A440025O0046B040025O0049B04003083O00FB5F1A3910D6A89003083O00E3A83A6E4D79B8CF030C3O005F35A949BFDE59BC7632977003083O00C51B5CDF20D1BB1103083O00305AD7EF0A51C4E803043O009B633FA3030F3O00A6D8B784B781AAC8AC839E968DC4B103063O00E4E2B1C1EDD9025O001AAD40025O0080554003083O0007B537F23DBE24F503043O008654D043030D3O0026BF83781ABA8F52169F925D0103043O003C73CCE603083O00D43FFF64EE34EC6303043O0010875A8B030C3O00707D103A40514B4075141B7E03073O0018341466532E34025O0020634003083O00B13O4BB9C7599103073O003EE22E2O3FD0A903113O00C11C46931A1F2E4AE029478206083D76D503083O003E857935E37F6D4F03083O00231126E1DFA0A52O03073O00C270745295B6CE03113O000CBB4939CEE50B35A14F3EC5E31A31AD5E03073O006E59C82C78A082025O00609C40025O00EAA140025O000EA640025O001AA94003083O0098C65F524A443C5E03083O002DCBA32B26232A5B030E3O00E796D90188AD4DF38BD81088BC5803073O0034B2E5BC43E7C903083O00122O4410FE52243203073O004341213064973C030D3O00F2E8B8DDFEDAE9BAFCF6D3E6B703053O0093BF87CEB8002B022O0012763O00014O00AA000100013O00261E3O0002000100010004B23O00020001001276000100013O000E8D00020009000100010004B23O00090001002EBC0004004D000100030004B23O004D0001001276000200013O00261E0002000E000100050004B23O000E0001001276000100063O0004B23O004D000100261E0002002C000100070004B23O002C00010012FE000300084O00D1000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O00035O00122O000300086O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400062O0003002A000100010004B23O002A0001001276000300014O002E000300023O001276000200053O00260C00020030000100010004B23O00300001002EA5001100DCFF2O00120004B23O000A00010012FE000300084O00D1000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000300033O00122O000300086O000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000400013O00122O000500193O00122O0006001A6O0004000600024O00030003000400062O0003004A000100010004B23O004A0001001276000300014O002E000300043O001276000200073O0004B23O000A0001002E6B001C00B00001001B0004B23O00B0000100261E000100B0000100050004B23O00B00001001276000200013O002EBC001D007F000100040004B23O007F0001000E960007007F000100020004B23O007F0001001276000300013O002EBC001F007A0001001E0004B23O007A000100261E0003007A000100010004B23O007A00010012FE000400084O00AB000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000500013O00122O000600223O00122O000700236O0005000700024O00040004000500062O00040069000100010004B23O00690001001276000400014O002E000400053O00124D000400086O000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000500013O00122O000600263O00122O000700276O0005000700024O00040004000500062O00040078000100010004B23O00780001001276000400284O002E000400063O001276000300073O00261E00030057000100070004B23O00570001001276000200053O0004B23O007F00010004B23O00570001000E9600050083000100020004B23O00830001001276000100293O0004B23O00B0000100260C00020087000100010004B23O00870001002EBC002A00520001002B0004B23O00520001001276000300013O000E8D0001008C000100030004B23O008C0001002EBC002D00A80001002C0004B23O00A800010012FE000400084O00D1000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000400073O00122O000400086O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000500013O00122O000600343O00122O000700356O0005000700024O00040004000500062O000400A6000100010004B23O00A60001001276000400014O002E000400083O001276000300073O00260C000300AC000100070004B23O00AC0001002E6B00370088000100360004B23O00880001001276000200073O0004B23O005200010004B23O008800010004B23O0052000100260C000100B4000100290004B23O00B40001002EBC003800052O0100390004B23O00052O01001276000200013O00261E000200E0000100010004B23O00E00001001276000300013O00260C000300BC000100070004B23O00BC0001002E6B003A00BE0001003B0004B23O00BE0001001276000200073O0004B23O00E0000100261E000300B8000100010004B23O00B800010012FE000400084O00AB000500013O00122O0006003C3O00122O0007003D6O0005000700024O0004000400054O000500013O00122O0006003E3O00122O0007003F6O0005000700024O00040004000500062O000400CE000100010004B23O00CE0001001276000400284O002E000400093O00124D000400086O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O000500013O00122O000600423O00122O000700436O0005000700024O00040004000500062O000400DD000100010004B23O00DD0001001276000400284O002E0004000A3O001276000300073O0004B23O00B80001002E6B004400E6000100450004B23O00E6000100261E000200E6000100050004B23O00E60001001276000100463O0004B23O00052O0100261E000200B5000100070004B23O00B500010012FE000300084O00AB000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400062O000300F6000100010004B23O00F60001001276000300284O002E0003000B3O001229000300086O000400013O00122O0005004B3O00122O0006004C6O0004000600024O0003000300044O000400013O00122O0005004D3O00122O0006004E6O0004000600024O0003000300044O0003000C3O00122O000200053O0004B23O00B5000100261E000100322O0100060004B23O00322O010012FE000200084O00AB000300013O00122O0004004F3O00122O000500506O0003000500024O0002000200034O000300013O00122O000400513O00122O000500526O0003000500024O00020002000300062O000200152O0100010004B23O00152O01001276000200014O002E0002000D3O001214000200086O000300013O00122O000400533O00122O000500546O0003000500024O0002000200034O000300013O00122O000400553O00122O000500566O0003000500024O0002000200034O0002000E3O00122O000200086O000300013O00122O000400573O00122O000500586O0003000500024O0002000200034O000300013O00122O000400593O00122O0005005A6O0003000500024O00020002000300062O000200302O0100010004B23O00302O01001276000200014O002E0002000F3O0004B23O002A020100261E000100802O0100070004B23O00802O01001276000200014O00AA000300033O00260C0002003A2O0100010004B23O003A2O01002EBC005B00362O01005C0004B23O00362O01001276000300013O000E8D0005003F2O0100030004B23O003F2O01002E6B005E00412O01005D0004B23O00412O01001276000100053O0004B23O00802O0100261E000300622O0100070004B23O00622O010012FE000400084O00AB000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000500013O00122O000600613O00122O000700626O0005000700024O00040004000500062O000400512O0100010004B23O00512O01001276000400014O002E000400103O00124D000400086O000500013O00122O000600633O00122O000700646O0005000700024O0004000400054O000500013O00122O000600653O00122O000700666O0005000700024O00040004000500062O000400602O0100010004B23O00602O01001276000400014O002E000400113O001276000300053O00261E0003003B2O0100010004B23O003B2O010012FE000400084O00DB000500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O000400123O00122O000400086O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O0004000400054O000400133O00122O000300073O00044O003B2O010004B23O00802O010004B23O00362O01002EA5006F005D0001006F0004B23O00DD2O0100261E000100DD2O0100460004B23O00DD2O01001276000200014O00AA000300033O00260C0002008A2O0100010004B23O008A2O01002E6B007000862O0100710004B23O00862O01001276000300013O00260C0003008F2O0100050004B23O008F2O01002E6B007300912O0100720004B23O00912O01001276000100023O0004B23O00DD2O0100261E000300B22O0100010004B23O00B22O010012FE000400084O00AB000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000500013O00122O000600763O00122O000700776O0005000700024O00040004000500062O000400A12O0100010004B23O00A12O01001276000400014O002E000400143O00124D000400086O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000500013O00122O0006007A3O00122O0007007B6O0005000700024O00040004000500062O000400B02O0100010004B23O00B02O01001276000400014O002E000400153O001276000300073O00261E0003008B2O0100070004B23O008B2O01001276000400013O00260C000400B92O0100070004B23O00B92O01002EBC007C00BB2O01007D0004B23O00BB2O01001276000300053O0004B23O008B2O01000E96000100B52O0100040004B23O00B52O010012FE000500084O00D1000600013O00122O0007007E3O00122O0008007F6O0006000800024O0005000500064O000600013O00122O000700803O00122O000800816O0006000800024O0005000500064O000500163O00122O000500086O000600013O00122O000700823O00122O000800836O0006000800024O0005000500064O000600013O00122O000700843O00122O000800856O0006000800024O00050005000600062O000500D72O0100010004B23O00D72O01001276000500014O002E000500173O001276000400073O0004B23O00B52O010004B23O008B2O010004B23O00DD2O010004B23O00862O0100261E00010005000100010004B23O00050001001276000200013O00260C000200E42O0100010004B23O00E42O01002E6B00452O00020100860004B24O0002010012FE000300084O00AB000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000400013O00122O000500893O00122O0006008A6O0004000600024O00030003000400062O000300F22O0100010004B23O00F22O01001276000300014O002E000300183O001229000300086O000400013O00122O0005008B3O00122O0006008C6O0004000600024O0003000300044O000400013O00122O0005008D3O00122O0006008E6O0004000600024O0003000300044O000300193O00122O000200073O00260C00020004020100050004B23O00040201002EBC009000060201008F0004B23O00060201001276000100073O0004B23O0005000100260C0002000A020100070004B23O000A0201002E6B009200E02O0100910004B23O00E02O010012FE000300084O00D1000400013O00122O000500933O00122O000600946O0004000600024O0003000300044O000400013O00122O000500953O00122O000600966O0004000600024O0003000300044O0003001A3O00122O000300086O000400013O00122O000500973O00122O000600986O0004000600024O0003000300044O000400013O00122O000500993O00122O0006009A6O0004000600024O00030003000400062O00030024020100010004B23O00240201001276000300014O002E0003001B3O001276000200053O0004B23O00E02O010004B23O000500010004B23O002A02010004B23O000200012O004A3O00017O00BB3O00028O00025O005EB240025O00AAA040026O000840025O000EAA40025O0002A940025O0026AA40025O00D09640030C3O004570696353652O74696E677303083O00192DB5577F242FB203053O00164A48C12303133O000B6CE54A2870E5561F69ED4A256DD14B2D7EE103043O00384C1984034O0003083O006DC4BF32C650C6B803053O00AF3EA1CB4603103O001BC8C2013135DCCD202535CFCA071D0C03053O00555CBDA373026O00F03F027O0040025O0053B240025O0013B14003083O00D6B84324C63AE2AE03063O005485DD3750AF030D3O0095E225AAD354AEF32BA8C2748D03063O003CDD8744C6A7026O00104003083O001AA9242C20A2372B03043O005849CC50030D3O000A8A03562CD60A8612532FDC3D03063O00BA4EE370264903083O00CF52E9415A74FB4403063O001A9C379D3533030E3O00B9CB13F1BD5180CC1ECAAC5F82DD03063O0030ECB876B9D8026O001440025O0020834003083O008ACBC42B46B7C9C303053O002FD9AEB05F03103O008DCE732AB755742FB6DA460DA65D772803083O0046D8BD1662D2341803083O00E9DAB793DAD4D8B003053O00B3BABFC3E703113O00D13A19E8F0311FD4F62B11EBF71119E9FC03043O0084995F78025O00E8B240025O004AB04003083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA030F3O00C80623E5F6CAE7332DFDF6CBEE2B1203063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E98903153O008CA0A22F87E4F5AB84A80D8CD5FFABA7AE0B9DF7F503073O0090D9D3C77FE893025O00089540025O0098A740025O007EA54003083O00CB2O2A3CDC4B055703083O0024984F5E48B5256203123O00E2CB421BD2CB573AC5D9533AE7CA4626D2CA03043O005FB7B827026O001840025O00E0AD40025O00A6AC40025O00D0A740025O00ECAD4003083O00795D9CF643568FF103043O00822A38E803143O00DAA725FA452DC5B30CE64133E3BB23C45230FFA503063O005F8AD544832003083O0073ADB3F7194EAFB403053O007020C8C78303123O00045F50A1F4A43028635DB6C0BF2B2A49748803073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE03153O0085255F5581A238577FB7A3294745B0B40D4143A3BD03053O00D6CD4A332C025O008AA040025O0068904003083O00C949F6E87EF44BF103053O00179A2C829C03123O0024B5A89E241208A3BF81303B14A7A1A7381403063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E03113O00849BD13739BF1AB2A1D52F30A43BB3A1E003073O0055D4E9B04E5CCD025O002C9140025O00489C4003083O006EB0B69354BBA59403043O00E73DD5C203123O0021A2316A3EA22F773AA82F7607A4296A219D03043O001369CD5D03083O009A0DCA9536A70FCD03053O005FC968BEE103143O009AD8C4E6A0C7D8F9A0D9C5FDAEC7D7CFBBC2CEC003043O00AECFABA1025O001CB340025O00F8AC4003083O007506FD385A18411003063O00762663894C3303133O00C835003A062CE4110A000D13FC282O060026E403063O00409D4665726903083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803133O000406EA151B06F4081F08EA1A2D1DEF032221D603043O006C4C698603083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103163O008BBCEED8F10C627C90B2EED7C7177977AD94F0CED31303083O0018C3D382A1A66310025O00B2A240025O00488340025O00209540025O00DCA240025O00C09840025O00D6A140025O0032A040025O003AA64003083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030B3O007CCC44EA463FD54DC351E903073O009738A5379A235303083O00934611FAA94D02FD03043O008EC02365030A3O00E3662C91E68FA517DA6603083O0076B61549C387ECCC025O009CA640025O00BAA94003083O003B390E540D03FA1B03073O009D685C7A20646D030B3O0096B5CAFE2F2E83A0A6B2DC03083O00CBC3C6AFAA5D47ED03083O001D4E2AC1581FFB3D03073O009C4E2B5EB53171030F3O005AE9CAA707465874EEC8AA08577C7603073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA103113O0005ED25DE04D9AB23EF24C818D39028ED2703073O00E24D8C4BBA68BC025O00EC9340025O00708D4003083O00863AF3325D8E05A603073O0062D55F874634E003073O00CBB0CC5155FAA603053O00349EC3A91703083O0049B926608F3B7C9803083O00EB1ADC5214E6551B03063O00AEA0EDC75CB803053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC7703083O003ABCAB21FAE6E9C603083O00B16FCFCE739F888C03083O00368C0400DD41581603073O003F65E97074B42F03073O00F13EE317EF1EF303063O0056A35B8D7298025O00989240025O000CB04003083O0046B44F5EDF7BB64803053O00B615D13B2A03123O008244C02D33BFAE52D7322793B259C1142FB903063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03113O00959804D77C648A8C28CB7772AC8402E64903063O0016C5EA65AE19025O00C8A240025O0056A34003083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB703103O00CC07C3CC83B6F527CE1BD4F8A0A8F63003083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD384030F3O0005826C5AC098BBCA31A17259D7878403083O00B855ED1B3FB2CFD4025O0068A040025O00D8834003083O003B5C1D4B01570E4C03043O003F68396903133O003E94A16C048BBD730495A0770E95A14A0293BD03043O00246BE7C40081022O0012763O00014O00AA000100013O002EBC00030002000100020004B23O00020001000E960001000200013O0004B23O00020001001276000100013O00260C0001000B000100040004B23O000B0001002E6B00050066000100060004B23O00660001001276000200014O00AA000300033O00260C00020011000100010004B23O00110001002EBC0007000D000100080004B23O000D0001001276000300013O00261E00030033000100010004B23O003300010012FE000400094O00AB000500013O00122O0006000A3O00122O0007000B6O0005000700024O0004000400054O000500013O00122O0006000C3O00122O0007000D6O0005000700024O00040004000500062O00040022000100010004B23O002200010012760004000E4O002E00045O00124D000400096O000500013O00122O0006000F3O00122O000700106O0005000700024O0004000400054O000500013O00122O000600113O00122O000700126O0005000700024O00040004000500062O00040031000100010004B23O00310001001276000400014O002E000400023O001276000300133O00260C00030037000100140004B23O00370001002EBC00150048000100160004B23O004800010012FE000400094O00AB000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500062O00040045000100010004B23O00450001001276000400014O002E000400033O0012760001001B3O0004B23O0066000100261E00030012000100130004B23O001200010012FE000400094O00DB000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000400043O00122O000400096O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000400053O00122O000300143O00044O001200010004B23O006600010004B23O000D000100261E000100C6000100240004B23O00C60001001276000200013O002EA500250020000100250004B23O00890001000E9600010089000100020004B23O008900010012FE000300094O00D1000400013O00122O000500263O00122O000600276O0004000600024O0003000300044O000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000300063O00122O000300096O000400013O00122O0005002A3O00122O0006002B6O0004000600024O0003000300044O000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400062O00030087000100010004B23O008700010012760003000E4O002E000300073O001276000200133O00261E000200B3000100130004B23O00B30001001276000300013O00260C00030090000100010004B23O00900001002E6B002E00AC0001002F0004B23O00AC00010012FE000400094O00AB000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O00040004000500062O0004009E000100010004B23O009E0001001276000400014O002E000400083O001229000400096O000500013O00122O000600343O00122O000700356O0005000700024O0004000400054O000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000400093O00122O000300133O002EA5003800E0FF2O00380004B23O008C000100261E0003008C000100130004B23O008C0001001276000200143O0004B23O00B300010004B23O008C000100260C000200B7000100140004B23O00B70001002E6B003900690001003A0004B23O006900010012FE000300094O00A4000400013O00122O0005003B3O00122O0006003C6O0004000600024O0003000300044O000400013O00122O0005003D3O00122O0006003E6O0004000600024O0003000300044O0003000A3O00122O0001003F3O00044O00C600010004B23O00690001002EBC004100282O0100400004B23O00282O0100261E000100282O0100140004B23O00282O01001276000200014O00AA000300033O00261E000200CC000100010004B23O00CC0001001276000300013O000E8D001400D3000100030004B23O00D30001002EBC004300E4000100420004B23O00E400010012FE000400094O00AB000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O000500013O00122O000600463O00122O000700476O0005000700024O00040004000500062O000400E1000100010004B23O00E10001001276000400014O002E0004000B3O001276000100043O0004B23O00282O0100261E000300052O0100010004B23O00052O010012FE000400094O00AB000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O000500013O00122O0006004A3O00122O0007004B6O0005000700024O00040004000500062O000400F4000100010004B23O00F40001001276000400014O002E0004000C3O00124D000400096O000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O00040004000500062O000400032O0100010004B23O00032O01001276000400014O002E0004000D3O001276000300133O00260C000300092O0100130004B23O00092O01002EBC005000CF000100510004B23O00CF00010012FE000400094O00D1000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O0004000E3O00122O000400096O000500013O00122O000600563O00122O000700576O0005000700024O0004000400054O000500013O00122O000600583O00122O000700596O0005000700024O00040004000500062O000400232O0100010004B23O00232O01001276000400014O002E0004000F3O001276000300143O0004B23O00CF00010004B23O00282O010004B23O00CC000100260C0001002C2O0100130004B23O002C2O01002EA5005A005D0001005B0004B23O00872O01001276000200013O000E960001004B2O0100020004B23O004B2O010012FE000300094O00AB000400013O00122O0005005C3O00122O0006005D6O0004000600024O0003000300044O000400013O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400062O0003003D2O0100010004B23O003D2O01001276000300014O002E000300103O001229000300096O000400013O00122O000500603O00122O000600616O0004000600024O0003000300044O000400013O00122O000500623O00122O000600636O0004000600024O0003000300044O000300113O00122O000200133O000E8D0014004F2O0100020004B23O004F2O01002EA500640010000100650004B23O005D2O010012FE000300094O00A4000400013O00122O000500663O00122O000600676O0004000600024O0003000300044O000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000300123O00122O000100143O00044O00872O01000E960013002D2O0100020004B23O002D2O01001276000300013O00261E000300642O0100130004B23O00642O01001276000200143O0004B23O002D2O01000E96000100602O0100030004B23O00602O010012FE000400094O00AB000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500062O000400742O0100010004B23O00742O01001276000400014O002E000400133O00124D000400096O000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000500013O00122O000600703O00122O000700716O0005000700024O00040004000500062O000400832O0100010004B23O00832O01001276000400014O002E000400143O001276000300133O0004B23O00602O010004B23O002D2O01002EBC007300E92O0100720004B23O00E92O0100261E000100E92O01001B0004B23O00E92O01001276000200014O00AA000300033O00260C000200912O0100010004B23O00912O01002EBC0075008D2O0100740004B23O008D2O01001276000300013O00261E000300B92O0100010004B23O00B92O01001276000400013O00260C000400992O0100130004B23O00992O01002EA500760004000100770004B23O009B2O01001276000300133O0004B23O00B92O01002EBC007800952O0100790004B23O00952O0100261E000400952O0100010004B23O00952O010012FE000500094O00DB000600013O00122O0007007A3O00122O0008007B6O0006000800024O0005000500064O000600013O00122O0007007C3O00122O0008007D6O0006000800024O0005000500064O000500153O00122O000500096O000600013O00122O0007007E3O00122O0008007F6O0006000800024O0005000500064O000600013O00122O000700803O00122O000800816O0006000800024O0005000500064O000500163O00122O000400133O00044O00952O01002E6B008200D62O0100830004B23O00D62O01000E96001300D62O0100030004B23O00D62O010012FE000400094O00A0000500013O00122O000600843O00122O000700856O0005000700024O0004000400054O000500013O00122O000600863O00122O000700876O0005000700024O0004000400054O000400173O00122O000400096O000500013O00122O000600883O00122O000700896O0005000700024O0004000400054O000500013O00122O0006008A3O00122O0007008B6O0005000700024O0004000400054O000400183O00122O000300143O00261E000300922O0100140004B23O00922O010012FE000400094O00A4000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400054O000500013O00122O0006008E3O00122O0007008F6O0005000700024O0004000400054O000400193O00122O000100243O00044O00E92O010004B23O00922O010004B23O00E92O010004B23O008D2O01002EBC00910027020100900004B23O0027020100261E000100270201003F0004B23O002702010012FE000200094O00AB000300013O00122O000400923O00122O000500936O0003000500024O0002000200034O000300013O00122O000400943O00122O000500956O0003000500024O00020002000300062O000200FB2O0100010004B23O00FB2O01001276000200014O002E0002001A3O00124D000200096O000300013O00122O000400963O00122O000500976O0003000500024O0002000200034O000300013O00122O000400983O00122O000500996O0003000500024O00020002000300062O0002000A020100010004B23O000A0201001276000200014O002E0002001B3O001214000200096O000300013O00122O0004009A3O00122O0005009B6O0003000500024O0002000200034O000300013O00122O0004009C3O00122O0005009D6O0003000500024O0002000200034O0002001C3O00122O000200096O000300013O00122O0004009E3O00122O0005009F6O0003000500024O0002000200034O000300013O00122O000400A03O00122O000500A16O0003000500024O00020002000300062O00020025020100010004B23O00250201001276000200014O002E0002001D3O0004B23O0080020100261E00010007000100010004B23O00070001001276000200013O002EBC00A2004A020100A30004B23O004A020100261E0002004A020100010004B23O004A02010012FE000300094O00D1000400013O00122O000500A43O00122O000600A56O0004000600024O0003000300044O000400013O00122O000500A63O00122O000600A76O0004000600024O0003000300044O0003001E3O00122O000300096O000400013O00122O000500A83O00122O000600A96O0004000600024O0003000300044O000400013O00122O000500AA3O00122O000600AB6O0004000600024O00030003000400062O00030048020100010004B23O00480201001276000300014O002E0003001F3O001276000200133O002E6B00AC006A020100AD0004B23O006A020100261E0002006A020100130004B23O006A02010012FE000300094O00D1000400013O00122O000500AE3O00122O000600AF6O0004000600024O0003000300044O000400013O00122O000500B03O00122O000600B16O0004000600024O0003000300044O000300203O00122O000300096O000400013O00122O000500B23O00122O000600B36O0004000600024O0003000300044O000400013O00122O000500B43O00122O000600B56O0004000600024O00030003000400062O00030068020100010004B23O00680201001276000300014O002E000300213O001276000200143O00260C0002006E020100140004B23O006E0201002E6B00B6002A020100B70004B23O002A02010012FE000300094O00A4000400013O00122O000500B83O00122O000600B96O0004000600024O0003000300044O000400013O00122O000500BA3O00122O000600BB6O0004000600024O0003000300044O000300223O00122O000100133O00044O000700010004B23O002A02010004B23O000700010004B23O008002010004B23O000200012O004A3O00017O00733O00028O00025O002EA740025O00806840026O001440030C3O0049734368612O6E656C696E67030F3O00412O66656374696E67436F6D626174025O0051B240025O00CEA740026O00F03F025O00607A40025O00B07940025O0058A340025O002OA640025O00809440025O005EAB40025O0098AA40025O00D8A140025O00A4B040025O00F08340025O00E09040025O0010A340025O002DB040025O0018B140025O001EA740025O00109A40025O003CAA40025O0028B340030C3O004570696353652O74696E677303073O006704737436561803053O005A336B14132O033O0082FF8603053O005DED90E58F025O008AA640025O0078A640027O004003083O0049734D6F76696E67025O00BAA340025O001AA74003073O0047657454696D65026O000840025O001EAF40025O00488440030D3O004973446561644F7247686F7374025O00F09D4003093O0049734D6F756E74656403073O0021F9F71E07430603063O0026759690796B2O033O002CB4EB03043O005A4DDB8E03073O00D20B263E40026903073O001A866441592C672O033O00F2E72303053O00C491835043025O0097B040025O0016AD4003073O002ABF010F14ED0D03063O00887ED066687803063O007C83DD53AA5E03083O003118EAAE23CF325D026O001040025O00989640025O0072A74003083O0042752O66446F776E030C3O0053757267656F664C69676874025O0068AA40025O00E0684003113O00456D70797265616C426C617A6542752O66025O00589740025O00D4B140025O00A0B040025O00507D40025O001EAD40025O00C0554003063O003CE7EF81771503053O00116C929DE803073O0049735265616479031B3O00497354616E6B42656C6F774865616C746850657263656E74616765030E3O006CD615FF2BA14ACD27FD26BA42D703063O00C82BA3748D4F03093O008B373388F0DBEDB32F03073O0083DF565DE3D094030D3O00D744B8BD5DB4ED41F68518B9E503063O00D583252OD67D025O00088340025O0062AE4003093O00466F637573556E697403043O00120A0B9403053O0081464B45DF026O003440025O0088A440025O00FEA040025O006EA74003103O004865616C746850657263656E74616765030E3O0061DEF2FB78E647C5C0F975FD4FDF03063O008F26AB93891C030D3O00E483B7F843E2DAD4C28AF60FE503073O00B4B0E2D9936383025O0030A740025O00C0514003063O00FB9C0E2BF68B03043O0067B3D94F025O00CAAA40025O0010AB40025O0042A240025O00707A40025O00A7B240025O00588640025O0068AC40025O006C9C40025O00349140025O00B2A24003113O00476574456E656D696573496E52616E6765026O00444003163O00476574456E656D696573496E4D656C2O6552616E6765026O00284000FB012O0012763O00013O002EBC00030070000100020004B23O0070000100261E3O0070000100040004B23O007000012O00E400015O0020F70001000100052O005B000100020002000633000100FA2O0100010004B23O00FA2O012O00E400015O0020F70001000100062O005B00010002000200063300010011000100010004B23O00110001002EBC00070030000100080004B23O00300001001276000100014O00AA000200033O000E9600010018000100010004B23O00180001001276000200014O00AA000300033O001276000100093O00261E00010013000100090004B23O00130001000E8D0001001E000100020004B23O001E0001002E6B000A001A0001000B0004B23O001A0001001276000300013O00261E0003001F000100010004B23O001F00012O00E4000400024O00FF0004000100022O002E000400014O00E4000400013O0006E2000400FA2O013O0004B23O00FA2O012O00E4000400014O00E9000400023O0004B23O00FA2O010004B23O001F00010004B23O00FA2O010004B23O001A00010004B23O00FA2O010004B23O001300010004B23O00FA2O012O00E4000100033O00063300010035000100010004B23O00350001002EBC000D00FA2O01000C0004B23O00FA2O01001276000100014O00AA000200023O000E9600010037000100010004B23O00370001001276000200013O002EA5000E000D0001000E0004B23O0047000100261E00020047000100090004B23O004700012O00E4000300044O00FF0003000100022O002E000300014O00E4000300013O0006E2000300FA2O013O0004B23O00FA2O012O00E4000300014O00E9000300023O0004B23O00FA2O0100261E0002003A000100010004B23O003A0001001276000300013O00260C0003004E000100010004B23O004E0001002EA5000F0019000100100004B23O00650001001276000400013O002EBC0011005E000100120004B23O005E000100261E0004005E000100010004B23O005E00012O00E4000500054O00FF0005000100022O002E000500013O002E6B0013005D000100140004B23O005D00012O00E4000500013O0006E20005005D00013O0004B23O005D00012O00E4000500014O00E9000500023O001276000400093O00260C00040062000100090004B23O00620001002EA5001500EFFF2O00160004B23O004F0001001276000300093O0004B23O006500010004B23O004F0001002EBC0018004A000100170004B23O004A000100261E0003004A000100090004B23O004A0001001276000200093O0004B23O003A00010004B23O004A00010004B23O003A00010004B23O00FA2O010004B23O003700010004B23O00FA2O0100261E3O0097000100010004B23O00970001001276000100014O00AA000200023O002EA500193O000100190004B23O00740001000E9600010074000100010004B23O00740001001276000200013O00260C0002007D000100090004B23O007D0001002E6B001B008B0001001A0004B23O008B00010012FE0003001C4O00A4000400063O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000400063O00122O0005001F3O00122O000600206O0004000600024O0003000300044O000300033O00124O00093O00044O00970001002EBC00220079000100210004B23O0079000100261E00020079000100010004B23O007900012O00E4000300074O00060003000100014O000300086O00030001000100122O000200093O00044O007900010004B23O009700010004B23O0074000100261E3O00C2000100230004B23O00C20001001276000100014O00AA000200023O00261E0001009B000100010004B23O009B0001001276000200013O00261E000200AC000100090004B23O00AC00012O00E400035O0020F70003000300242O005B0003000200020006E2000300A700013O0004B23O00A70001002EA500250005000100260004B23O00AA00010012FE000300274O00FF0003000100022O002E000300093O0012763O00283O0004B23O00C20001002EBC002A009E000100290004B23O009E000100261E0002009E000100010004B23O009E00012O00E400035O0020F700030003002B2O005B0003000200020006E2000300B600013O0004B23O00B600012O004A3O00013O002EA5002C00080001002C0004B23O00BE00012O00E400035O0020F700030003002D2O005B0003000200020006E2000300BE00013O0004B23O00BE00012O004A3O00013O001276000200093O0004B23O009E00010004B23O00C200010004B23O009B000100261E3O00F3000100090004B23O00F30001001276000100013O00261E000100E0000100010004B23O00E000010012FE0002001C4O00A0000300063O00122O0004002E3O00122O0005002F6O0003000500024O0002000200034O000300063O00122O000400303O00122O000500316O0003000500024O0002000200034O0002000A3O00122O0002001C6O000300063O00122O000400323O00122O000500336O0003000500024O0002000200034O000300063O00122O000400343O00122O000500356O0003000500024O0002000200034O0002000B3O00122O000100093O002E6B003700C5000100360004B23O00C5000100261E000100C5000100090004B23O00C500010012FE0002001C4O00A4000300063O00122O000400383O00122O000500396O0003000500024O0002000200034O000300063O00122O0004003A3O00122O0005003B6O0003000500024O0002000200034O0002000C3O00124O00233O00044O00F300010004B23O00C5000100261E3O00172O01003C0004B23O00172O01001276000100013O002EBC003D00022O01003E0004B23O00022O0100261E000100022O0100090004B23O00022O012O00E400025O00203100020002003F4O0004000E3O00202O0004000400404O0002000400024O0002000D3O00124O00043O00044O00172O01000E96000100F6000100010004B23O00F600012O00E40002000A3O000633000200092O0100010004B23O00092O01002EBC0041000D2O0100420004B23O000D2O012O00E4000200104O0077000200024O002E0002000F3O0004B23O000F2O01001276000200094O002E0002000F4O00E400025O00203100020002003F4O0004000E3O00202O0004000400434O0002000400024O000200113O00122O000100093O00044O00F60001002E6B00440001000100450004B23O00010001000E960028000100013O0004B23O00010001001276000100013O000E96000100EF2O0100010004B23O00EF2O01002EBC004700E92O0100460004B23O00E92O012O00E400025O0020F70002000200062O005B000200020002000633000200282O0100010004B23O00282O012O00E4000200123O0006E2000200E92O013O0004B23O00E92O01001276000200014O00AA000300053O000E96000900E32O0100020004B23O00E32O012O00AA000500053O00260C000300312O0100090004B23O00312O01002EBC004800CE2O0100490004B23O00CE2O0100261E000400312O0100010004B23O00312O012O00E4000600123O000699000500412O0100060004B23O00412O012O00E40006000E4O00B8000700063O00122O0008004A3O00122O0009004B6O0007000900024O00060006000700202O00060006004C4O00060002000200062O000500412O0100060004B23O00412O012O00E40005000C4O00E4000600133O0020F500060006004D2O00E4000700144O005B0006000200020006E20006007F2O013O0004B23O007F2O012O00E40006000E4O0085000700063O00122O0008004E3O00122O0009004F6O0007000900024O00060006000700202O00060006004C4O00060002000200062O0006007F2O013O0004B23O007F2O012O00E4000600154O005F000700063O00122O000800503O00122O000900516O00070009000200062O0006005F2O0100070004B23O005F2O012O00E4000600154O0070000700063O00122O000800523O00122O000900536O00070009000200062O0006007F2O0100070004B23O007F2O01001276000600014O00AA000700073O00261E000600612O0100010004B23O00612O01001276000700013O002E6B005400642O0100550004B23O00642O0100261E000700642O0100010004B23O00642O012O00E4000800133O0020090108000800564O000900056O000A000B6O000C00063O00122O000D00573O00122O000E00586O000C000E000200122O000D00596O0008000D00024O000800016O000800013O00062O000800782O0100010004B23O00782O01002EBC005A00E92O01005B0004B23O00E92O012O00E4000800014O00E9000800023O0004B23O00E92O010004B23O00642O010004B23O00E92O010004B23O00612O010004B23O00E92O01002EA5005C00370001005C0004B23O00B62O012O00E400065O0020F700060006005D2O005B0006000200022O00E4000700143O00061A000600B62O0100070004B23O00B62O012O00E40006000E4O0085000700063O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O00060006004C4O00060002000200062O000600B62O013O0004B23O00B62O012O00E4000600154O0070000700063O00122O000800603O00122O000900616O00070009000200062O000600B62O0100070004B23O00B62O01001276000600014O00AA000700073O000E8D0001009E2O0100060004B23O009E2O01002EA5006200FEFF2O00630004B23O009A2O01001276000700013O000E960001009F2O0100070004B23O009F2O012O00E4000800133O0020E00008000800564O000900056O000A000B6O000C00063O00122O000D00643O00122O000E00656O000C000E000200122O000D00596O0008000D00024O000800016O000800013O00062O000800E92O013O0004B23O00E92O012O00E4000800014O00E9000800023O0004B23O00E92O010004B23O009F2O010004B23O00E92O010004B23O009A2O010004B23O00E92O01001276000600013O002EBC006600B72O0100670004B23O00B72O0100261E000600B72O0100010004B23O00B72O012O00E4000700133O0020020007000700564O000800056O0009000B3O00122O000C00596O0007000C00024O000700016O000700013O00062O000700C72O0100010004B23O00C72O01002E6B006800E92O0100690004B23O00E92O012O00E4000700014O00E9000700023O0004B23O00E92O010004B23O00B72O010004B23O00E92O010004B23O00312O010004B23O00E92O0100260C000300D22O0100010004B23O00D22O01002EA5006A005DFF2O006B0004B23O002D2O01001276000600013O002E6B006D00D92O01006C0004B23O00D92O0100261E000600D92O0100090004B23O00D92O01001276000300093O0004B23O002D2O0100260C000600DD2O0100010004B23O00DD2O01002E6B006F00D32O01006E0004B23O00D32O01001276000400014O00AA000500053O001276000600093O0004B23O00D32O010004B23O002D2O010004B23O00E92O0100261E0002002A2O0100010004B23O002A2O01001276000300014O00AA000400043O001276000200093O0004B23O002A2O012O00E400025O0020DE00020002007000122O000400716O0002000400024O000200163O00122O000100093O00261E0001001C2O0100090004B23O001C2O012O00E400025O0020DE00020002007200122O000400736O0002000400024O000200103O00124O003C3O0004B23O000100010004B23O001C2O010004B23O000100012O004A3O00017O000E3O00028O00025O000C9540025O003EAD40025O0038A240025O0028A940025O007CB24003053O005072696E7403193O0062B810CC01BCB143B20FC1018EBA0A920CDC42CC8145B811FE03073O00C32AD77CB521EC026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03203O0025563B2765C81F50322D31B83519217E74A8430B796E75B82F40771C2AF7007203063O00986D39575E4500353O0012763O00014O00AA000100013O002EA500023O000100020004B23O0002000100261E3O0002000100010004B23O00020001001276000100013O002EBC00040027000100030004B23O0027000100261E00010027000100010004B23O00270001001276000200013O00261E00020022000100010004B23O00220001001276000300013O002E6B0005001D000100060004B23O001D000100261E0003001D000100010004B23O001D00012O00E400046O00D20004000100014O000400013O00202O0004000400074O000500023O00122O000600083O00122O000700096O000500076O00043O000100122O0003000A3O00261E0003000F0001000A0004B23O000F00010012760002000A3O0004B23O002200010004B23O000F0001000E96000A000C000100020004B23O000C00010012760001000A3O0004B23O002700010004B23O000C000100261E000100070001000A0004B23O000700010012FE0002000B3O0020F400020002000C4O000300023O00122O0004000D3O00122O0005000E6O000300056O00023O000100044O003400010004B23O000700010004B23O003400010004B23O000200012O004A3O00017O00", GetFEnv(), ...);

