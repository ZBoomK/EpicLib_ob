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
				if (Enum <= 135) then
					if (Enum <= 67) then
						if (Enum <= 33) then
							if (Enum <= 16) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												if (Stk[Inst[2]] ~= Inst[4]) then
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
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
											Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
											if (Stk[Inst[2]] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 6) then
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
											local A = Inst[2];
											local B = Inst[3];
											for Idx = A, B do
												Stk[Idx] = Vararg[Idx - A];
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
									elseif (Enum > 10) then
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
								elseif (Enum <= 13) then
									if (Enum == 12) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 15) then
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
							elseif (Enum <= 24) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum > 17) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 19) then
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
								elseif (Enum <= 22) then
									if (Enum > 21) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 23) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 28) then
								if (Enum <= 26) then
									if (Enum == 25) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum > 27) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 30) then
								if (Enum == 29) then
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
								end
							elseif (Enum <= 31) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 32) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 50) then
							if (Enum <= 41) then
								if (Enum <= 37) then
									if (Enum <= 35) then
										if (Enum == 34) then
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									elseif (Enum == 36) then
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
								elseif (Enum <= 39) then
									if (Enum == 38) then
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									else
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
									end
								elseif (Enum > 40) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 45) then
								if (Enum <= 43) then
									if (Enum == 42) then
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 44) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 47) then
								if (Enum == 46) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 48) then
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
							elseif (Enum > 49) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 58) then
							if (Enum <= 54) then
								if (Enum <= 52) then
									if (Enum > 51) then
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
								elseif (Enum == 53) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 56) then
								if (Enum > 55) then
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
							elseif (Enum == 57) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 62) then
							if (Enum <= 60) then
								if (Enum == 59) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
										if (Mvm[1] == 111) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								end
							elseif (Enum > 61) then
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
						elseif (Enum <= 64) then
							if (Enum == 63) then
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
						elseif (Enum <= 65) then
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
						elseif (Enum == 66) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 101) then
						if (Enum <= 84) then
							if (Enum <= 75) then
								if (Enum <= 71) then
									if (Enum <= 69) then
										if (Enum > 68) then
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
									elseif (Enum > 70) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										VIP = Inst[3];
									end
								elseif (Enum <= 73) then
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
										local Edx;
										local Results, Limit;
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
										if Stk[Inst[2]] then
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
							elseif (Enum <= 79) then
								if (Enum <= 77) then
									if (Enum == 76) then
										if (Stk[Inst[2]] > Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									end
								elseif (Enum > 78) then
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
							elseif (Enum <= 81) then
								if (Enum > 80) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 82) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 83) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 92) then
							if (Enum <= 88) then
								if (Enum <= 86) then
									if (Enum > 85) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 87) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 90) then
								if (Enum > 89) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum > 91) then
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
						elseif (Enum <= 96) then
							if (Enum <= 94) then
								if (Enum == 93) then
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
								end
							elseif (Enum == 95) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 98) then
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
						elseif (Enum <= 99) then
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
						elseif (Enum > 100) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
					elseif (Enum <= 118) then
						if (Enum <= 109) then
							if (Enum <= 105) then
								if (Enum <= 103) then
									if (Enum > 102) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
								elseif (Enum > 104) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 107) then
								if (Enum == 106) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum > 108) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 113) then
							if (Enum <= 111) then
								if (Enum == 110) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
								end
							elseif (Enum > 112) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 115) then
							if (Enum == 114) then
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
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 116) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 117) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 126) then
						if (Enum <= 122) then
							if (Enum <= 120) then
								if (Enum == 119) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								end
							elseif (Enum == 121) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 124) then
							if (Enum == 123) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 125) then
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
					elseif (Enum <= 130) then
						if (Enum <= 128) then
							if (Enum > 127) then
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
						elseif (Enum > 129) then
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
					elseif (Enum <= 132) then
						if (Enum == 131) then
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
					elseif (Enum <= 133) then
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
					elseif (Enum > 134) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 203) then
					if (Enum <= 169) then
						if (Enum <= 152) then
							if (Enum <= 143) then
								if (Enum <= 139) then
									if (Enum <= 137) then
										if (Enum == 136) then
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
									elseif (Enum == 138) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 141) then
									if (Enum == 140) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 142) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Enum <= 145) then
									if (Enum == 144) then
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
								elseif (Enum == 146) then
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
								end
							elseif (Enum <= 149) then
								if (Enum > 148) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 150) then
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
							elseif (Enum == 151) then
								local B;
								local A;
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
						elseif (Enum <= 160) then
							if (Enum <= 156) then
								if (Enum <= 154) then
									if (Enum > 153) then
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
								elseif (Enum == 155) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 158) then
								if (Enum == 157) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum == 159) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							elseif (Inst[2] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 164) then
							if (Enum <= 162) then
								if (Enum == 161) then
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
							elseif (Enum > 163) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 166) then
							if (Enum == 165) then
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
						elseif (Enum <= 167) then
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum == 168) then
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
						end
					elseif (Enum <= 186) then
						if (Enum <= 177) then
							if (Enum <= 173) then
								if (Enum <= 171) then
									if (Enum == 170) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 172) then
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
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum <= 175) then
								if (Enum > 174) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 176) then
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
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
						elseif (Enum <= 181) then
							if (Enum <= 179) then
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
							elseif (Enum > 180) then
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
								do
									return;
								end
							end
						elseif (Enum <= 183) then
							if (Enum > 182) then
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
						elseif (Enum <= 184) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 185) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 194) then
						if (Enum <= 190) then
							if (Enum <= 188) then
								if (Enum == 187) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 189) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 192) then
							if (Enum == 191) then
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
						elseif (Enum > 193) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
					elseif (Enum <= 198) then
						if (Enum <= 196) then
							if (Enum == 195) then
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
						elseif (Enum > 197) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 200) then
						if (Enum == 199) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
					elseif (Enum <= 201) then
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
					elseif (Enum == 202) then
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
						Stk[Inst[2]] = #Stk[Inst[3]];
					end
				elseif (Enum <= 237) then
					if (Enum <= 220) then
						if (Enum <= 211) then
							if (Enum <= 207) then
								if (Enum <= 205) then
									if (Enum == 204) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Inst[2] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 206) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								end
							elseif (Enum <= 209) then
								if (Enum == 208) then
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
									local A = Inst[2];
									Stk[A] = Stk[A]();
								end
							elseif (Enum == 210) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 215) then
							if (Enum <= 213) then
								if (Enum == 212) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 214) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 217) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 218) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 219) then
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
					elseif (Enum <= 228) then
						if (Enum <= 224) then
							if (Enum <= 222) then
								if (Enum == 221) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 223) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 226) then
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 227) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
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
					elseif (Enum <= 232) then
						if (Enum <= 230) then
							if (Enum > 229) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 231) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 234) then
						if (Enum > 233) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 235) then
						Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
					elseif (Enum > 236) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 254) then
					if (Enum <= 245) then
						if (Enum <= 241) then
							if (Enum <= 239) then
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
							elseif (Enum == 240) then
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
						elseif (Enum <= 243) then
							if (Enum == 242) then
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
						elseif (Enum > 244) then
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
					elseif (Enum <= 249) then
						if (Enum <= 247) then
							if (Enum == 246) then
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
						elseif (Enum == 248) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 251) then
						if (Enum == 250) then
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
					elseif (Enum <= 252) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 253) then
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
				elseif (Enum <= 263) then
					if (Enum <= 258) then
						if (Enum <= 256) then
							if (Enum == 255) then
								Stk[Inst[2]] = {};
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
						elseif (Enum == 257) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						end
					elseif (Enum <= 260) then
						if (Enum == 259) then
							Stk[Inst[2]]();
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 261) then
						Upvalues[Inst[3]] = Stk[Inst[2]];
					elseif (Enum > 262) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 267) then
					if (Enum <= 265) then
						if (Enum > 264) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum == 266) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					if (Enum == 268) then
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
				elseif (Enum <= 270) then
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
					if (Stk[Inst[2]] <= Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 271) then
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
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!2E3O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403053O005574696C7303063O00506C6179657203063O00546172676574030C3O0054617267657454617267657403053O00466F63757303053O005370652O6C03043O004974656D03043O0042696E6403043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C026O001440030C3O0047657445717569706D656E74026O002A40028O00026O002C4003073O0057612O72696F7203043O0041726D73030F3O005370652O6C5265666C656374494473024O0080B3C54003103O005265676973746572466F724576656E7403143O006AE4C46F7FC0BF68EDC27374CDA574E9C77A7FD603073O00E03AA885363A9203183O00697A6AC450B4B82E686362CD58A3A93F667563DC5BA1A22F03083O006B39362B9D15E6E703063O0053657441504C025O00C0514000AF012O001206012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004CF3O000A000100123B000300063O0020C500040003000700123B000500083O0020C500050005000900123B000600083O0020C500060006000A00063C00073O000100062O006F3O00064O006F8O006F3O00044O006F3O00014O006F3O00024O006F3O00054O00790008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000D001100202O0010000D001200202O0011000D00130020C50012000D001400206A0013000B001500202O0014000B001600122O0015000D3O00202O00160015001700202O00170015001800202O00180015001900202O00190015001A00202O001A0015001B00202O001A001A001C00202O001A001A001D0020C5001B0015001B00201A001B001B001C00202O001B001B001E00122O001C001F6O001D001D6O001E8O001F8O00208O0021005E3O00202O005F000B001B00202O005F005F001C00209E0060000F00202O00650060000200020020C50061006000210006070061004000013O0004CF3O004000012O006F006100143O0020C50062006000212O006500610002000200061100610043000100010004CF3O004300012O006F006100143O00122D006200224O00650061000200020020C50062006000230006070062004B00013O0004CF3O004B00012O006F006200143O0020C50063006000232O00650062000200020006110062004E000100010004CF3O004E00012O006F006200143O00122D006300224O00650062000200020020C50063001300240020FE00630063002500202O00640014002400202O00640064002500202O00650018002400202O00650065002500202O0066005F00264O00678O006800683O00122O006900273O00122O006A00273O00209E006B000B002800063C006D0001000100022O006F3O00694O006F3O006A4O0027006E00073O00122O006F00293O00122O0070002A6O006E00706O006B3O000100202O006B000B002800063C006D0002000100052O006F3O00624O006F3O00604O006F3O00144O006F3O000F4O006F3O00614O00A3006E00073O00122O006F002B3O00122O0070002C6O006E00706O006B3O00014O006B006C3O00063C006D0003000100012O006F3O00103O00063C006E0004000100012O006F3O00633O00063C006F0005000100032O006F3O00634O006F3O000F4O006F3O006C3O00063C00700006000100032O006F3O000F4O006F3O00634O006F3O006C3O00063C00710007000100052O006F3O000E4O006F3O00664O006F3O00104O006F3O00114O006F3O000F3O00063C007200080001001C2O006F3O00634O006F3O00424O006F3O000F4O006F3O004B4O006F3O00194O006F3O00074O006F3O00434O006F3O004C4O006F3O00444O006F3O004D4O006F3O005F4O006F3O004E4O006F3O00454O006F3O00124O006F3O004F4O006F3O00654O006F3O00714O006F3O00414O006F3O004A4O006F3O00644O006F3O00474O006F3O00514O006F3O00484O006F3O00524O006F3O00584O006F3O00464O006F3O00504O006F3O00533O00063C00730009000100042O006F3O001D4O006F3O005F4O006F3O00674O006F3O00203O00063C0074000A0001000E2O006F3O00684O006F3O005C4O006F3O006A4O006F3O00634O006F3O00334O006F3O003B4O006F3O00204O006F3O00194O006F3O00074O006F3O002A4O006F3O002E4O006F3O00264O006F3O00384O006F3O00243O00063C0075000B0001002A2O006F3O005C4O006F3O006A4O006F3O00234O006F3O00374O006F3O00204O006F3O00634O006F3O006C4O006F3O000F4O006F3O00104O006F3O00194O006F3O00684O006F3O00074O006F3O00254O006F3O00344O006F3O001C4O006F3O002E4O006F3O00294O006F3O002A4O006F3O005F4O006F3O006B4O006F3O006F4O006F3O00274O006F3O00704O006F3O00324O006F3O003A4O006F3O002D4O006F3O002F4O006F3O00554O006F3O00394O006F3O00564O006F3O00654O006F3O00434O006F3O00314O006F3O002B4O006F3O00304O006F3O00214O006F3O00364O006F3O00334O006F3O003B4O006F3O00264O006F3O00384O006F3O006E3O00063C0076000C000100212O006F3O005C4O006F3O006A4O006F3O00334O006F3O003B4O006F3O00204O006F3O00634O006F3O00194O006F3O00684O006F3O00074O006F3O00264O006F3O00384O006F3O00274O006F3O000F4O006F3O00104O006F3O002A4O006F3O002D4O006F3O001C4O006F3O002E4O006F3O00324O006F3O003A4O006F3O00554O006F3O00394O006F3O00564O006F3O00654O006F3O00304O006F3O006C4O006F3O002B4O006F3O00214O006F3O00364O006F3O00234O006F3O00374O006F3O00254O006F3O00293O00063C0077000D000100232O006F3O00634O006F3O002B4O006F3O00104O006F3O000F4O006F3O00194O006F3O00684O006F3O00074O006F3O005C4O006F3O006A4O006F3O00214O006F3O00364O006F3O00204O006F3O00554O006F3O00394O006F3O00564O006F3O00654O006F3O002E4O006F3O00324O006F3O003A4O006F3O001C4O006F3O00304O006F3O006C4O006F3O00294O006F3O00254O006F3O00234O006F3O00374O006F3O002D4O006F3O00344O006F3O002A4O006F3O002F4O006F3O00334O006F3O003B4O006F3O00264O006F3O00384O006F3O00313O00063C0078000E000100092O006F3O000F4O006F3O00634O006F3O00194O006F3O00074O006F3O00224O006F3O005F4O006F3O001E4O006F3O001D4O006F3O00743O00063C0079000F0001001F2O006F3O001D4O006F3O00724O006F3O00574O006F3O005F4O006F3O00634O006F3O00654O006F3O00154O006F3O00074O006F3O00284O006F3O00104O006F3O00194O006F3O00354O006F3O006D4O006F3O001F4O006F3O006C4O006F3O00754O006F3O00244O006F3O00684O006F3O000F4O006F3O00544O006F3O00494O006F3O005D4O006F3O003D4O006F3O00204O006F3O005C4O006F3O006A4O006F3O005E4O006F3O003C4O006F3O00734O006F3O00764O006F3O00773O00063C007A00100001001C2O006F3O002A4O006F3O00074O006F3O002B4O006F3O002D4O006F3O00224O006F3O00244O006F3O00254O006F3O00554O006F3O00324O006F3O00334O006F3O00274O006F3O00284O006F3O00294O006F3O00364O006F3O00374O006F3O00384O006F3O00214O006F3O00234O006F3O00264O006F3O00314O006F3O00344O006F3O00354O006F3O002E4O006F3O002F4O006F3O00304O006F3O00394O006F3O003A4O006F3O003B3O00063C007B0011000100152O006F3O00544O006F3O00074O006F3O00564O006F3O00434O006F3O00454O006F3O00444O006F3O003E4O006F3O003F4O006F3O00404O006F3O00414O006F3O00464O006F3O00424O006F3O00534O006F3O004B4O006F3O004C4O006F3O00494O006F3O004A4O006F3O00504O006F3O004F4O006F3O004E4O006F3O004D3O00063C007C00120001000F2O006F3O00474O006F3O00074O006F3O00484O006F3O00514O006F3O00524O006F3O00584O006F3O00574O006F3O005C4O006F3O00594O006F3O005A4O006F3O005B4O006F3O005E4O006F3O005D4O006F3O003C4O006F3O003D3O00063C007D0013000100152O006F3O007B4O006F3O007A4O006F3O007C4O006F3O001E4O006F3O00074O006F3O001F4O006F3O00204O006F3O00684O006F3O00104O006F3O001C4O006F3O005F4O006F3O000F4O006F3O00694O006F3O000B4O006F3O006A4O006F3O006B4O006F3O001D4O006F3O00794O006F3O00784O006F3O00634O006F3O006C3O00063C007E0014000100022O006F3O00154O006F3O00073O0020E8007F0015002D00122O0080002E6O0081007D6O0082007E6O007F008200016O00013O00153O00023O00026O00F03F026O00704002264O006300025O00122O000300016O00045O00122O000500013O00042O0003002100012O006000076O0047000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004820003000500012O0060000300054O006F000400024O002E000300044O009F00036O00B43O00017O00023O00028O00024O0080B3C540000A3O00122D3O00013O00261F3O0001000100010004CF3O0001000100122D000100024O00052O015O00122D000100024O00052O0100013O0004CF3O000900010004CF3O000100012O00B43O00017O00053O00028O00026O00F03F026O002C40030C3O0047657445717569706D656E74026O002A4000293O00122D3O00013O00261F3O0012000100020004CF3O001200012O0060000100013O0020C50001000100030006070001000D00013O0004CF3O000D00012O0060000100024O0060000200013O0020C50002000200032O006500010002000200061100010010000100010004CF3O001000012O0060000100023O00122D000200014O00650001000200022O00052O015O0004CF3O0028000100261F3O0001000100010004CF3O000100012O0060000100033O0020300001000100044O0001000200024O000100016O000100013O00202O00010001000500062O0001002200013O0004CF3O002200012O0060000100024O0060000200013O0020C50002000200052O006500010002000200061100010025000100010004CF3O002500012O0060000100023O00122D000200014O00650001000200022O00052O0100043O00122D3O00023O0004CF3O000100012O00B43O00017O00023O00028O0003133O00556E6974476574546F74616C4162736F72627300123O00122D3O00014O00FA000100013O00261F3O0002000100010004CF3O0002000100123B000200024O006000036O00650002000200022O006F000100023O000E240001000D000100010004CF3O000D00012O0036000200014O00AD000200023O0004CF3O001100012O003600026O00AD000200023O0004CF3O001100010004CF3O000200012O00B43O00017O00053O0003103O004865616C746850657263656E74616765026O00344003083O004D612O7361637265030B3O004973417661696C61626C65025O0080414001123O00209E00013O00012O0065000100020002000EDA0002000F000100010004CF3O000F00012O006000015O0020C500010001000300209E0001000100042O00650001000200020006070001001000013O0004CF3O0010000100209E00013O00012O0065000100020002002O260001000F000100050004CF3O000F00012O00B000016O0036000100014O00AD000100024O00B43O00017O00093O00030B3O00446562752O66537461636B031B3O00457865637574696F6E657273507265636973696F6E446562752O66027O0040030D3O00446562752O6652656D61696E7303103O00442O6570576F756E6473446562752O662O033O00474344030B3O0044726561646E6175676874030B3O004973417661696C61626C65030A3O0042612O746C656C6F726401223O00206B00013O00014O00035O00202O0003000300024O00010003000200262O0001001F000100030004CF3O001F000100209E00013O00042O00A700035O00202O0003000300054O0001000300024O000200013O00202O0002000200064O00020002000200062O00010011000100020004CF3O001F00012O006000015O0020C500010001000700209E0001000100082O00650001000200020006070001002000013O0004CF3O002000012O006000015O0020C500010001000900209E0001000100082O00650001000200020006070001002000013O0004CF3O002000012O0060000100023O00264C0001001F000100030004CF3O001F00012O00B000016O0036000100014O00AD000100024O00B43O00017O00093O0003063O0042752O665570030F3O0053752O64656E446561746842752O66027O004003103O004865616C746850657263656E74616765026O00344003083O004D612O7361637265030B3O004973417661696C61626C65025O00804140030F3O0053772O6570696E67537472696B657301224O007500015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O00010020000100010004CF3O002000012O0060000100023O0026D900010018000100030004CF3O0018000100209E00013O00042O0065000100020002002O260001001F000100050004CF3O001F00012O0060000100013O0020C500010001000600209E0001000100072O00650001000200020006070001001800013O0004CF3O0018000100209E00013O00042O0065000100020002002O260001001F000100080004CF3O001F00012O006000015O00207A0001000100014O000300013O00202O0003000300094O00010003000200044O002000012O00B000016O0036000100014O00AD000100024O00B43O00017O00053O00030E3O0056616C75654973496E412O726179030B3O00436173745370652O6C494403063O00457869737473030A3O00556E69744973556E697403023O00494400184O00497O00206O00014O000100016O000200023O00202O0002000200024O000200039O00000200064O001600013O0004CF3O001600012O00603O00033O00209E5O00032O00653O000200020006073O001600013O0004CF3O0016000100123B3O00044O000C2O0100033O00202O0001000100054O0001000200024O000200043O00202O0002000200054O000200039O0000022O00AD3O00024O00B43O00017O00323O00028O00026O00F03F030D3O00446965427954686553776F7264030A3O0049734361737461626C6503103O004865616C746850657263656E74616765031A3O00DF8214CABBC5F0CF8314CAAACBC0C98F51F1BCDACAD59818E3BC03073O00AFBBEB7195D9BC030A3O0049676E6F72655061696E03153O0035A88F43F17C472CAE8842A32O7D3AAA8F5FEA6F7D03073O00185CCFE12C8319027O0040030B3O0052612O6C79696E6743727903083O0042752O66446F776E03103O00417370656374734661766F7242752O66030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503163O0059D2B440027445D4874F09640BD7BD4A1E7358DAAE4903063O001D2BB3D82C7B03093O00496E74657276656E6503083O00556E69744E616D65030E3O00496E74657276656E65466F63757303133O00B4D73449AFCF2542B8992449BBDC2E5FB4CF2503043O002CDDB940026O000840030F3O005370652O6C5265666C656374696F6E03073O0049735265616479031A3O0012F74D537F3EF54D597F04E45C567C0FA74C5A7504E95B56650403053O00136187283F030E3O0042692O746572492O6D756E69747903193O00AC55272F2A2391553E363A3FA7482A7B2B34A8593D282627AB03063O0051CE3C535B4F026O001040030B3O004865616C746873746F6E6503173O0046AED17E3BCB5EB041A5D5322BC64BA140B8D9642A831E03083O00C42ECBB0124FA32D03193O008A27780C21E8E7B12C795E0CFEEEB42B701964CBE0AC2B711003073O008FD8421E7E449B03173O0052656672657368696E674865616C696E67506F74696F6E03253O00B8CD0BD9C0B0DFE8A4CF4DC3C0A2DBE8A4CF4DDBCAB7DEEEA48809CEC3A6D9F2A3DE088B9103083O0081CAA86DABA5C3B7031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O00264A32D9D303E72E5332CACD54EE27593BD1D013A63257232OD11AA6265D31DDD007EF345D03073O0086423857B8BE74030F3O00446566656E736976655374616E6365031A3O0038340FBE17F82823390E1AAF18E522307C350CBD1CE5323C2A3403083O00555C5169DB798B41030C3O0042612O746C655374616E6365032E3O00FFB2445170DAC2A02O4472DCF8F3514368DAEFF354407ADAF3A05953799FEEA7514B7FDABDB7554379D1EEBA464003063O00BF9DD330251C0065012O00122D3O00013O00261F3O003A000100020004CF3O003A00012O006000015O0020C500010001000300209E0001000100042O00650001000200020006070001001D00013O0004CF3O001D00012O0060000100013O0006070001001D00013O0004CF3O001D00012O0060000100023O00209E0001000100052O00650001000200022O0060000200033O0006900001001D000100020004CF3O001D00012O0060000100044O006000025O0020C50002000200032O00650001000200020006070001001D00013O0004CF3O001D00012O0060000100053O00122D000200063O00122D000300074O002E000100034O009F00016O006000015O0020C500010001000800209E0001000100042O00650001000200020006070001003900013O0004CF3O003900012O0060000100063O0006070001003900013O0004CF3O003900012O0060000100023O00209E0001000100052O00650001000200022O0060000200073O00069000010039000100020004CF3O003900012O0060000100044O008500025O00202O0002000200084O000300046O000500016O00010005000200062O0001003900013O0004CF3O003900012O0060000100053O00122D000200093O00122D0003000A4O002E000100034O009F00015O00122D3O000B3O00261F3O00930001000B0004CF3O009300012O006000015O0020C500010001000C00209E0001000100042O00650001000200020006070001007000013O0004CF3O007000012O0060000100083O0006070001007000013O0004CF3O007000012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O0001007000013O0004CF3O007000012O0060000100023O00200900010001000D4O00035O00202O00030003000C4O00010003000200062O0001007000013O0004CF3O007000012O0060000100023O00209E0001000100052O00650001000200022O0060000200093O0006900001005E000100020004CF3O005E00012O00600001000A3O0020C500010001000F2O00D100010001000200061100010065000100010004CF3O006500012O00600001000A3O0020EF0001000100104O000200096O0003000B6O00010003000200062O0001007000013O0004CF3O007000012O0060000100044O006000025O0020C500020002000C2O00650001000200020006070001007000013O0004CF3O007000012O0060000100053O00122D000200113O00122D000300124O002E000100034O009F00016O006000015O0020C500010001001300209E0001000100042O00650001000200020006070001009200013O0004CF3O009200012O00600001000C3O0006070001009200013O0004CF3O009200012O00600001000D3O00209E0001000100052O00650001000200022O00600002000E3O00069000010092000100020004CF3O009200012O00600001000D3O0020430001000100144O0001000200024O000200023O00202O0002000200144O00020002000200062O00010092000100020004CF3O009200012O0060000100044O00600002000F3O0020C50002000200152O00650001000200020006070001009200013O0004CF3O009200012O0060000100053O00122D000200163O00122D000300174O002E000100034O009F00015O00122D3O00183O00261F3O00C5000100010004CF3O00C500012O006000015O0020C500010001001900209E00010001001A2O0065000100020002000607000100AA00013O0004CF3O00AA00012O0060000100104O00D1000100010002000607000100AA00013O0004CF3O00AA00012O0060000100044O006000025O0020C50002000200192O0065000100020002000607000100AA00013O0004CF3O00AA00012O0060000100053O00122D0002001B3O00122D0003001C4O002E000100034O009F00016O006000015O0020C500010001001D00209E00010001001A2O0065000100020002000607000100C400013O0004CF3O00C400012O0060000100113O000607000100C400013O0004CF3O00C400012O0060000100023O00209E0001000100052O00650001000200022O0060000200123O000690000100C4000100020004CF3O00C400012O0060000100044O006000025O0020C500020002001D2O0065000100020002000607000100C400013O0004CF3O00C400012O0060000100053O00122D0002001E3O00122D0003001F4O002E000100034O009F00015O00122D3O00023O00261F3O001C2O0100200004CF3O001C2O012O0060000100133O0020C500010001002100209E00010001001A2O0065000100020002000607000100E100013O0004CF3O00E100012O0060000100143O000607000100E100013O0004CF3O00E100012O0060000100023O00209E0001000100052O00650001000200022O0060000200153O000690000100E1000100020004CF3O00E100012O0060000100044O00600002000F3O0020C50002000200212O0065000100020002000607000100E100013O0004CF3O00E100012O0060000100053O00122D000200223O00122D000300234O002E000100034O009F00016O0060000100163O000607000100642O013O0004CF3O00642O012O0060000100023O00209E0001000100052O00650001000200022O0060000200173O000690000100642O0100020004CF3O00642O0100122D000100013O00261F000100EB000100010004CF3O00EB00012O0060000200184O008C000300053O00122O000400243O00122O000500256O00030005000200062O000200052O0100030004CF3O00052O012O0060000200133O0020C500020002002600209E00020002001A2O0065000200020002000607000200052O013O0004CF3O00052O012O0060000200044O00600003000F3O0020C50003000300262O0065000200020002000607000200052O013O0004CF3O00052O012O0060000200053O00122D000300273O00122D000400284O002E000200044O009F00026O0060000200183O00261F000200642O0100290004CF3O00642O012O0060000200133O0020C500020002002A00209E00020002001A2O0065000200020002000607000200642O013O0004CF3O00642O012O0060000200044O00600003000F3O0020C50003000300262O0065000200020002000607000200642O013O0004CF3O00642O012O0060000200053O0012480003002B3O00122O0004002C6O000200046O00025O00044O00642O010004CF3O00EB00010004CF3O00642O0100261F3O0001000100180004CF3O000100012O006000015O0020C500010001002D00209E0001000100042O0065000100020002000607000100402O013O0004CF3O00402O012O0060000100023O00206200010001000D4O00035O00202O00030003002D4O000400016O00010004000200062O000100402O013O0004CF3O00402O012O0060000100193O000607000100402O013O0004CF3O00402O012O0060000100023O00209E0001000100052O00650001000200022O00600002001A3O000690000100402O0100020004CF3O00402O012O0060000100044O006000025O0020C500020002002D2O0065000100020002000607000100402O013O0004CF3O00402O012O0060000100053O00122D0002002E3O00122D0003002F4O002E000100034O009F00016O006000015O0020C500010001003000209E0001000100042O0065000100020002000607000100622O013O0004CF3O00622O012O0060000100023O00206200010001000D4O00035O00202O0003000300304O000400016O00010004000200062O000100622O013O0004CF3O00622O012O0060000100193O000607000100622O013O0004CF3O00622O012O0060000100023O00209E0001000100052O00650001000200022O00600002001B3O00067C000200622O0100010004CF3O00622O012O0060000100044O006000025O0020C50002000200302O0065000100020002000607000100622O013O0004CF3O00622O012O0060000100053O00122D000200313O00122D000300324O002E000100034O009F00015O00122D3O00203O0004CF3O000100012O00B43O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O00122D3O00013O000E9A0002001100013O0004CF3O001100012O0060000100013O0020C40001000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004CF3O002200012O006000016O00AD000100023O0004CF3O0022000100261F3O0001000100010004CF3O000100012O0060000100013O0020C40001000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004CF3O002000012O006000016O00AD000100023O00122D3O00023O0004CF3O000100012O00B43O00017O00123O00028O00026O00F03F030A3O00576172627265616B6572030A3O0049734361737461626C6503143O00C81EE61E28DA1EFF19289F0FE61939D012F61D2E03053O005ABF7F947C03093O004F766572706F77657203133O0077912B05688839126AC73E057D84211A7A863A03043O007718E74E030D3O00536B752O6C73706C692O74657203173O009126B046D053018E24B15ED95251923FA049D34D13833903073O0071E24DC52ABC20030D3O00436F6C6F2O737573536D61736803183O003919F8BA2905E1A62O05F9B4291EB4A52813F7BA3714F5A103043O00D55A769403063O0043686172676503103O005826B5444A5E6EA444485821B9544C4F03053O002D3B4ED436008F3O00122D3O00013O00261F3O0001000100010004CF3O000100012O006000015O0006070001007800013O0004CF3O0078000100122D000100013O000E9A0002003F000100010004CF3O003F00012O0060000200014O0060000300023O00067C0002002A000100030004CF3O002A00012O0060000200033O0020C500020002000300209E0002000200042O00650002000200020006070002002A00013O0004CF3O002A00012O0060000200043O0006070002002A00013O0004CF3O002A00012O0060000200053O0006070002001C00013O0004CF3O001C00012O0060000200063O0006110002001F000100010004CF3O001F00012O0060000200053O0006110002002A000100010004CF3O002A00012O0060000200074O0060000300033O0020C50003000300032O00650002000200020006070002002A00013O0004CF3O002A00012O0060000200083O00122D000300053O00122D000400064O002E000200044O009F00026O0060000200033O0020C500020002000700209E0002000200042O00650002000200020006070002007800013O0004CF3O007800012O0060000200093O0006070002007800013O0004CF3O007800012O0060000200074O0060000300033O0020C50003000300072O00650002000200020006070002007800013O0004CF3O007800012O0060000200083O001248000300083O00122O000400096O000200046O00025O00044O0078000100261F00010007000100010004CF3O000700012O0060000200033O0020C500020002000A00209E0002000200042O00650002000200020006070002005500013O0004CF3O005500012O00600002000A3O0006070002005500013O0004CF3O005500012O0060000200074O0060000300033O0020C500030003000A2O00650002000200020006070002005500013O0004CF3O005500012O0060000200083O00122D0003000B3O00122D0004000C4O002E000200044O009F00026O0060000200014O0060000300023O00067C00020076000100030004CF3O007600012O0060000200033O0020C500020002000D00209E0002000200042O00650002000200020006070002007600013O0004CF3O007600012O00600002000B3O0006070002007600013O0004CF3O007600012O00600002000C3O0006070002006800013O0004CF3O006800012O0060000200063O0006110002006B000100010004CF3O006B00012O00600002000C3O00061100020076000100010004CF3O007600012O0060000200074O0060000300033O0020C500030003000D2O00650002000200020006070002007600013O0004CF3O007600012O0060000200083O00122D0003000E3O00122D0004000F4O002E000200044O009F00025O00122D000100023O0004CF3O000700012O00600001000D3O0006070001008E00013O0004CF3O008E00012O0060000100033O0020C500010001001000209E0001000100042O00650001000200020006070001008E00013O0004CF3O008E00012O0060000100074O0060000200033O0020C50002000200102O00650001000200020006070001008E00013O0004CF3O008E00012O0060000100083O001248000200113O00122O000300126O000100036O00015O00044O008E00010004CF3O000100012O00B43O00017O00963O00028O00026O000840030A3O00426C61646573746F726D030A3O0049734361737461626C65026O00F03F03063O0042752O665570030F3O00546573746F664D6967687442752O66030B3O00546573746F664D69676874030B3O004973417661696C61626C6503083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66030D3O00446562752O6652656D61696E7303103O00442O6570576F756E6473446562752O6603113O00125A828F833DB9FF025BC383872DEDA74803083O00907036E3EBE64ECD03063O00436C6561766503073O0049735265616479027O0040030A3O0042612O746C656C6F726403183O004D657263696C652O73426F6E656772696E64657242752O66030C3O004D6F7274616C537472696B65030F3O00432O6F6C646F776E52656D61696E732O033O00474344030D3O00B0240AFDC65EF3200EFF900CEA03063O003BD3486F9CB003093O00576869726C77696E64030D3O0053746F726D6F6653776F726473030D3O0048752O726963616E6542752O66030E3O004973496E4D656C2O6552616E676503103O00598FEA3F4290EA234AC7EB2C4DC7BB7D03043O004D2EE783030D3O00536B752O6C73706C692O74657203043O0052616765026O004440030B3O00546964656F66426C2O6F64030A3O0052656E64446562752O66030F3O0053772O6570696E67537472696B6573031B3O00A943B345AA5DB8478547A252B35FB353FA51AE45B941A245FA0CE703043O0020DA34D6026O00104003093O0042752O66537461636B03133O004372757368696E67416476616E636542752O6603163O00431823BCF0BC7A495A0538A3F4F04D5B4D5769F9BFE503083O003A2E7751C891D02503093O004F766572706F776572030B3O0044726561646E617567687403103O00249A35BEB9B2212E9E70A4A8BE7673DE03073O00564BEC50CCC9DD03093O00436173744379636C6503143O007F4E6591FF874D526397F78077017F84FDCB2A1203063O00EB122117E59E03073O0045786563757465030F3O0053752O64656E446561746842752O6603103O004865616C746850657263656E74616765026O00344003083O004D612O7361637265025O00804140030E3O0055A2C4B845AEC4FB58BBC2FB08EE03043O00DB30DAA1026O001440030E3O005468756E6465726F7573526F617203163O00F0796947DF4AF2EB646F76C940E1F6317448D80FB8B103073O008084111C29BB2F03093O0053686F636B7761766503093O00536F6E6963422O6F6D03093O00497343617374696E6703103O00123A0939561633103F1D0933057A055703053O003D6152665A03073O0043686172676573030A3O00446562752O66646F776E030E3O005261676550657263656E74616765026O00394003103O00A338AE59D758090CBE6EA34AC417465E03083O0069CC4ECB2BA7377E03043O00536C616D025O00805140030B3O00B6A62213530CC652E5F27B03083O0031C5CA437E7364A7026O00184003163O002353CA2784534C384ECC1692595F251BD7288316096203073O003E573BBF49E03603063O00F70EFBD0E21003043O00A987629A030E3O0053706561726F6642617374696F6E03143O0053706561724F6642617374696F6E506C61796572030E3O0049735370652O6C496E52616E676503173O00D8672155EF0CC7CD482655EE27C1C479645CFC30889C2103073O00A8AB1744349D5303063O00F764E7BE2A3F03073O00E7941195CD454D03143O0053706561724F6642617374696F6E437572736F7203173O0093B7C2FA45C08FA1F8F956EC94AEC8F517F781A487AC0103063O009FE0C7A79B3703083O00556E68696E67656403113O00F5FF3DD6F2E028DDE5FE7CDAF6F07C85A003043O00B297935C026O001C40030E3O00466572766F726F6642612O746C6503103O009BF545201E5B7382F90C3A134F3AD5AE03073O001AEC9D2C52722C030D3O004372757368696E67466F726365030D3O002922D05A3C2B95532B2D95027E03043O003B4A4EB5030A3O0049676E6F72655061696E030F3O00416E6765724D616E6167656D656E74026O003E4003123O002CD65455A120EE4A5BBA2B91525BB065880F03053O00D345B12O3A030B3O00A4E978F8A9C3B6E639ACBF03063O00ABD785199589026O00204003103O00EEDE37E8FF3FEB47F3883AFBEC70A41B03083O002281A8529A8F509C030B3O005468756E646572436C617003133O0091BA26054C4B9BBAB13F0A580E8184B173521803073O00E9E5D2536B282E03143O00CC4D20C204CD7D21C217C84937960DC041728F5403053O0065A12252B603043O0052656E6403113O00446562752O665265667265736861626C65030B3O00FA0857FA9BEA832DA8540B03083O004E886D399EBB82E2030E3O004A752O6765726E61757442752O66030B3O0042752O6652656D61696E73030E3O003B27FCF22O2BFCB1363EFAB12O6803043O00915E5F99030F3O00426C2O6F64616E645468756E64657203133O00E9C501DB4AB2EFF217D94FA7BDC515D60EE1A503063O00D79DAD74B52E026O002E4003173O0026A38EF7CA3CBA8CCDC921A682F9DF26F483F3D975E2D303053O00BA55D4EB92030D3O00436F6C6F2O737573536D617368025O99D93140030B3O00D08418FA79E6592OC141AE03073O0038A2E1769E598E03103O004F0DCFAC29CF5D13C5EF2AD95F4599F803063O00B83C65A0CF4203113O00338E7DB8349168B3238F3CB430813CE56903043O00DC51E21C03063O00417661746172030D3O0012C383EFEBD553DD83F8AA904203063O00A773B5E29B8A030A3O00576172627265616B657203113O00F523F55E6974C7E927F51C7370C5A275B503073O00A68242873C1B1103153O004745C27A23575FDD4A23494BDD7D704C4BCD35671703053O0050242AAE1503153O004D1F3B755D03226971033A7B5D1877724F13772D1A03043O001A2E70570020062O00122D3O00013O00261F3O00EA000100020004CF3O00EA00012O006000016O0060000200013O00067C00010047000100020004CF3O004700012O0060000100023O0006070001004700013O0004CF3O004700012O0060000100033O0006070001001000013O0004CF3O001000012O0060000100043O00061100010013000100010004CF3O001300012O0060000100033O00061100010047000100010004CF3O004700012O0060000100053O0020C500010001000300209E0001000100042O00650001000200020006070001004700013O0004CF3O004700012O0060000100063O000E2400050030000100010004CF3O003000012O0060000100073O0020EC0001000100064O000300053O00202O0003000300074O00010003000200062O0001003A000100010004CF3O003A00012O0060000100053O0020C500010001000800209E0001000100092O006500010002000200061100010030000100010004CF3O003000012O0060000100083O0020EC00010001000A4O000300053O00202O00030003000B4O00010003000200062O0001003A000100010004CF3O003A00012O0060000100063O000E2400050047000100010004CF3O004700012O0060000100083O0020E100010001000C4O000300053O00202O00030003000D4O000100030002000E2O00010047000100010004CF3O004700012O0060000100094O004E000200053O00202O0002000200034O0003000A6O000300036O00010003000200062O0001004700013O0004CF3O004700012O00600001000B3O00122D0002000E3O00122D0003000F4O002E000100034O009F00016O0060000100053O0020C500010001001000209E0001000100112O00650001000200020006070001007600013O0004CF3O007600012O00600001000C3O0006070001007600013O0004CF3O007600012O0060000100063O000EDA00120069000100010004CF3O006900012O0060000100053O0020C500010001001300209E0001000100092O006500010002000200061100010076000100010004CF3O007600012O0060000100073O0020090001000100064O000300053O00202O0003000300144O00010003000200062O0001007600013O0004CF3O007600012O0060000100053O00207600010001001500202O0001000100164O0001000200024O000200073O00202O0002000200174O00020002000200062O00020076000100010004CF3O007600012O0060000100094O004E000200053O00202O0002000200104O0003000A6O000300036O00010003000200062O0001007600013O0004CF3O007600012O00600001000B3O00122D000200183O00122D000300194O002E000100034O009F00016O0060000100053O0020C500010001001A00209E0001000100112O0065000100020002000607000100A600013O0004CF3O00A600012O00600001000D3O000607000100A600013O0004CF3O00A600012O0060000100063O000EDA00120096000100010004CF3O009600012O0060000100053O0020C500010001001B00209E0001000100092O0065000100020002000607000100A600013O0004CF3O00A600012O0060000100073O0020EC0001000100064O000300053O00202O0003000300144O00010003000200062O00010096000100010004CF3O009600012O0060000100073O0020090001000100064O000300053O00202O00030003001C4O00010003000200062O000100A600013O0004CF3O00A600012O0060000100094O0033000200053O00202O00020002001A4O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O000100A600013O0004CF3O00A600012O00600001000B3O00122D0002001E3O00122D0003001F4O002E000100034O009F00016O0060000100053O0020C500010001002000209E0001000100042O0065000100020002000607000100E900013O0004CF3O00E900012O00600001000F3O000607000100E900013O0004CF3O00E900012O0060000100073O00209E0001000100212O0065000100020002002O26000100D9000100220004CF3O00D900012O0060000100053O0020C500010001002300209E0001000100092O0065000100020002000607000100E900013O0004CF3O00E900012O0060000100083O0020E100010001000C4O000300053O00202O0003000300244O000100030002000E2O000100E9000100010004CF3O00E900012O0060000100073O0020090001000100064O000300053O00202O0003000300254O00010003000200062O000100CB00013O0004CF3O00CB00012O0060000100063O000EDA001200D9000100010004CF3O00D900012O0060000100083O0020EC00010001000A4O000300053O00202O00030003000B4O00010003000200062O000100D9000100010004CF3O00D900012O0060000100073O0020090001000100064O000300053O00202O0003000300074O00010003000200062O000100E900013O0004CF3O00E900012O0060000100094O0033000200053O00202O0002000200204O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O000100E900013O0004CF3O00E900012O00600001000B3O00122D000200263O00122D000300274O002E000100034O009F00015O00122D3O00283O00261F3O00872O0100280004CF3O00872O012O0060000100053O0020C500010001001500209E0001000100112O0065000100020002000607000100102O013O0004CF3O00102O012O0060000100103O000607000100102O013O0004CF3O00102O012O0060000100073O0020090001000100064O000300053O00202O0003000300254O00010003000200062O000100102O013O0004CF3O00102O012O0060000100073O0020730001000100294O000300053O00202O00030003002A4O00010003000200262O000100102O0100020004CF3O00102O012O0060000100094O004E000200053O00202O0002000200154O0003000A6O000300036O00010003000200062O000100102O013O0004CF3O00102O012O00600001000B3O00122D0002002B3O00122D0003002C4O002E000100034O009F00016O0060000100053O0020C500010001002D00209E0001000100042O0065000100020002000607000100332O013O0004CF3O00332O012O0060000100113O000607000100332O013O0004CF3O00332O012O0060000100073O0020090001000100064O000300053O00202O0003000300254O00010003000200062O000100332O013O0004CF3O00332O012O0060000100053O0020C500010001002E00209E0001000100092O0065000100020002000607000100332O013O0004CF3O00332O012O0060000100094O004E000200053O00202O00020002002D4O0003000A6O000300036O00010003000200062O000100332O013O0004CF3O00332O012O00600001000B3O00122D0002002F3O00122D000300304O002E000100034O009F00016O0060000100053O0020C500010001001500209E0001000100112O00650001000200020006070001004C2O013O0004CF3O004C2O012O0060000100103O0006070001004C2O013O0004CF3O004C2O012O0060000100123O00203D0001000100314O000200053O00202O0002000200154O000300136O000400146O0005000A6O000500056O00010005000200062O0001004C2O013O0004CF3O004C2O012O00600001000B3O00122D000200323O00122D000300334O002E000100034O009F00016O0060000100053O0020C500010001003400209E0001000100112O0065000100020002000607000100862O013O0004CF3O00862O012O0060000100153O000607000100862O013O0004CF3O00862O012O0060000100073O0020EC0001000100064O000300053O00202O0003000300354O00010003000200062O000100762O0100010004CF3O00762O012O0060000100063O0026D90001006F2O0100120004CF3O006F2O012O0060000100083O00209E0001000100362O0065000100020002002O26000100762O0100370004CF3O00762O012O0060000100053O0020C500010001003800209E0001000100092O00650001000200020006070001006F2O013O0004CF3O006F2O012O0060000100083O00209E0001000100362O0065000100020002002O26000100762O0100390004CF3O00762O012O0060000100073O0020090001000100064O000300053O00202O0003000300254O00010003000200062O000100862O013O0004CF3O00862O012O0060000100123O00203D0001000100314O000200053O00202O0002000200344O000300136O000400166O0005000A6O000500056O00010005000200062O000100862O013O0004CF3O00862O012O00600001000B3O00122D0002003A3O00122D0003003B4O002E000100034O009F00015O00122D3O003C3O00261F3O00320201003C0004CF3O003202012O006000016O0060000200013O00067C000100AF2O0100020004CF3O00AF2O012O0060000100173O000607000100AF2O013O0004CF3O00AF2O012O0060000100183O000607000100962O013O0004CF3O00962O012O0060000100043O000611000100992O0100010004CF3O00992O012O0060000100183O000611000100AF2O0100010004CF3O00AF2O012O0060000100053O0020C500010001003D00209E0001000100042O0065000100020002000607000100AF2O013O0004CF3O00AF2O012O0060000100094O0033000200053O00202O00020002003D4O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O000100AF2O013O0004CF3O00AF2O012O00600001000B3O00122D0002003E3O00122D0003003F4O002E000100034O009F00016O0060000100053O0020C500010001004000209E0001000100042O0065000100020002000607000100D62O013O0004CF3O00D62O012O0060000100193O000607000100D62O013O0004CF3O00D62O012O0060000100063O000E24001200D62O0100010004CF3O00D62O012O0060000100053O0020C500010001004100209E0001000100092O0065000100020002000611000100C62O0100010004CF3O00C62O012O0060000100083O00209E0001000100422O0065000100020002000607000100D62O013O0004CF3O00D62O012O0060000100094O0033000200053O00202O0002000200404O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O000100D62O013O0004CF3O00D62O012O00600001000B3O00122D000200433O00122D000300444O002E000100034O009F00016O0060000100053O0020C500010001002D00209E0001000100042O00650001000200020006070001000D02013O0004CF3O000D02012O0060000100113O0006070001000D02013O0004CF3O000D02012O0060000100063O00261F0001000D020100050004CF3O000D02012O0060000100053O0020C500010001002D00209E0001000100452O006500010002000200261F000100FA2O0100120004CF3O00FA2O012O0060000100053O0020C500010001001300209E0001000100092O0065000100020002000611000100FA2O0100010004CF3O00FA2O012O0060000100083O0020EC0001000100464O000300053O00202O00030003000B4O00010003000200062O00012O00020100010004CF4O0002012O0060000100073O00209E0001000100472O0065000100020002002O2600012O00020100480004CF4O0002012O0060000100053O0020C500010001001300209E0001000100092O00650001000200020006070001000D02013O0004CF3O000D02012O0060000100094O004E000200053O00202O00020002002D4O0003000A6O000300036O00010003000200062O0001000D02013O0004CF3O000D02012O00600001000B3O00122D000200493O00122D0003004A4O002E000100034O009F00016O0060000100053O0020C500010001004B00209E0001000100112O00650001000200020006070001003102013O0004CF3O003102012O00600001001A3O0006070001003102013O0004CF3O003102012O0060000100063O00261F00010031020100050004CF3O003102012O0060000100053O0020C500010001001300209E0001000100092O006500010002000200061100010031020100010004CF3O003102012O0060000100073O00209E0001000100472O0065000100020002000E24004C0031020100010004CF3O003102012O0060000100094O004E000200053O00202O00020002004B4O0003000A6O000300036O00010003000200062O0001003102013O0004CF3O003102012O00600001000B3O00122D0002004D3O00122D0003004E4O002E000100034O009F00015O00122D3O004F3O00261F3O003A030100120004CF3O003A03012O006000016O0060000200013O00067C00010078020100020004CF3O007802012O0060000100173O0006070001007802013O0004CF3O007802012O0060000100183O0006070001004102013O0004CF3O004102012O0060000100043O00061100010044020100010004CF3O004402012O0060000100183O00061100010078020100010004CF3O007802012O0060000100053O0020C500010001003D00209E0001000100042O00650001000200020006070001007802013O0004CF3O007802012O0060000100073O0020EC0001000100064O000300053O00202O0003000300074O00010003000200062O00010068020100010004CF3O006802012O0060000100053O0020C500010001000800209E0001000100092O00650001000200020006110001005E020100010004CF3O005E02012O0060000100083O0020EC00010001000A4O000300053O00202O00030003000B4O00010003000200062O00010068020100010004CF3O006802012O0060000100063O000E2400050078020100010004CF3O007802012O0060000100083O0020E100010001000C4O000300053O00202O00030003000D4O000100030002000E2O00010078020100010004CF3O007802012O0060000100094O0033000200053O00202O00020002003D4O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O0001007802013O0004CF3O007802012O00600001000B3O00122D000200503O00122D000300514O002E000100034O009F00016O006000016O0060000200013O00067C000100BA020100020004CF3O00BA02012O00600001001B3O000607000100BA02013O0004CF3O00BA02012O00600001001C3O0006070001008502013O0004CF3O008502012O0060000100043O00061100010088020100010004CF3O008802012O00600001001C3O000611000100BA020100010004CF3O00BA02012O00600001001D4O008C0002000B3O00122O000300523O00122O000400536O00020004000200062O000100BA020100020004CF3O00BA02012O0060000100053O0020C500010001005400209E0001000100042O0065000100020002000607000100BA02013O0004CF3O00BA02012O0060000100073O0020EC0001000100064O000300053O00202O0003000300074O00010003000200062O000100A9020100010004CF3O00A902012O0060000100053O0020C500010001000800209E0001000100092O0065000100020002000611000100BA020100010004CF3O00BA02012O0060000100083O00200900010001000A4O000300053O00202O00030003000B4O00010003000200062O000100BA02013O0004CF3O00BA02012O0060000100094O00720002001E3O00202O0002000200554O000300083O00202O0003000300564O000500053O00202O0005000500544O0003000500024O000300036O00010003000200062O000100BA02013O0004CF3O00BA02012O00600001000B3O00122D000200573O00122D000300584O002E000100034O009F00016O006000016O0060000200013O00067C000100FC020100020004CF3O00FC02012O00600001001B3O000607000100FC02013O0004CF3O00FC02012O00600001001C3O000607000100C702013O0004CF3O00C702012O0060000100043O000611000100CA020100010004CF3O00CA02012O00600001001C3O000611000100FC020100010004CF3O00FC02012O00600001001D4O008C0002000B3O00122O000300593O00122O0004005A6O00020004000200062O000100FC020100020004CF3O00FC02012O0060000100053O0020C500010001005400209E0001000100042O0065000100020002000607000100FC02013O0004CF3O00FC02012O0060000100073O0020EC0001000100064O000300053O00202O0003000300074O00010003000200062O000100EB020100010004CF3O00EB02012O0060000100053O0020C500010001000800209E0001000100092O0065000100020002000611000100FC020100010004CF3O00FC02012O0060000100083O00200900010001000A4O000300053O00202O00030003000B4O00010003000200062O000100FC02013O0004CF3O00FC02012O0060000100094O00720002001E3O00202O00020002005B4O000300083O00202O0003000300564O000500053O00202O0005000500544O0003000500024O000300036O00010003000200062O000100FC02013O0004CF3O00FC02012O00600001000B3O00122D0002005C3O00122D0003005D4O002E000100034O009F00016O006000016O0060000200013O00067C00010039030100020004CF3O003903012O0060000100023O0006070001003903013O0004CF3O003903012O0060000100033O0006070001000903013O0004CF3O000903012O0060000100043O0006110001000C030100010004CF3O000C03012O0060000100033O00061100010039030100010004CF3O003903012O0060000100053O0020C500010001000300209E0001000100042O00650001000200020006070001003903013O0004CF3O003903012O0060000100053O0020C500010001005E00209E0001000100092O00650001000200020006070001003903013O0004CF3O003903012O0060000100073O0020EC0001000100064O000300053O00202O0003000300074O00010003000200062O0001002C030100010004CF3O002C03012O0060000100053O0020C500010001000800209E0001000100092O006500010002000200061100010039030100010004CF3O003903012O0060000100083O00200900010001000A4O000300053O00202O00030003000B4O00010003000200062O0001003903013O0004CF3O003903012O0060000100094O004E000200053O00202O0002000200034O0003000A6O000300036O00010003000200062O0001003903013O0004CF3O003903012O00600001000B3O00122D0002005F3O00122D000300604O002E000100034O009F00015O00122D3O00023O00261F3O00E8030100610004CF3O00E803012O0060000100053O0020C500010001001A00209E0001000100112O00650001000200020006070001006403013O0004CF3O006403012O00600001000D3O0006070001006403013O0004CF3O006403012O0060000100053O0020C500010001001B00209E0001000100092O006500010002000200061100010054030100010004CF3O005403012O0060000100053O0020C500010001006200209E0001000100092O00650001000200020006070001006403013O0004CF3O006403012O0060000100063O000E2400050064030100010004CF3O006403012O0060000100094O0033000200053O00202O00020002001A4O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O0001006403013O0004CF3O006403012O00600001000B3O00122D000200633O00122D000300644O002E000100034O009F00016O0060000100053O0020C500010001001000209E0001000100112O00650001000200020006070001008003013O0004CF3O008003012O00600001000C3O0006070001008003013O0004CF3O008003012O0060000100053O0020C500010001006500209E0001000100092O006500010002000200061100010080030100010004CF3O008003012O0060000100094O004E000200053O00202O0002000200104O0003000A6O000300036O00010003000200062O0001008003013O0004CF3O008003012O00600001000B3O00122D000200663O00122D000300674O002E000100034O009F00016O0060000100053O0020C500010001006800209E0001000100112O0065000100020002000607000100B703013O0004CF3O00B703012O00600001001F3O000607000100B703013O0004CF3O00B703012O0060000100053O0020C500010001001300209E0001000100092O0065000100020002000607000100B703013O0004CF3O00B703012O0060000100053O0020C500010001006900209E0001000100092O0065000100020002000607000100B703013O0004CF3O00B703012O0060000100073O00209E0001000100212O0065000100020002000E24006A00B7030100010004CF3O00B703012O0060000100083O00209E0001000100362O0065000100020002002O26000100AA030100370004CF3O00AA03012O0060000100053O0020C500010001003800209E0001000100092O0065000100020002000607000100B703013O0004CF3O00B703012O0060000100083O00209E0001000100362O0065000100020002002622000100B7030100390004CF3O00B703012O0060000100094O004E000200053O00202O0002000200684O0003000A6O000300036O00010003000200062O000100B703013O0004CF3O00B703012O00600001000B3O00122D0002006B3O00122D0003006C4O002E000100034O009F00016O0060000100053O0020C500010001004B00209E0001000100112O0065000100020002000607000100E703013O0004CF3O00E703012O00600001001A3O000607000100E703013O0004CF3O00E703012O0060000100053O0020C500010001006500209E0001000100092O0065000100020002000607000100E703013O0004CF3O00E703012O0060000100073O00209E0001000100212O0065000100020002000E24006A00E7030100010004CF3O00E703012O0060000100053O0020C500010001006200209E0001000100092O0065000100020002000607000100D403013O0004CF3O00D403012O0060000100063O00262O000100DA030100050004CF3O00DA03012O0060000100053O0020C500010001006200209E0001000100092O0065000100020002000611000100E7030100010004CF3O00E703012O0060000100094O004E000200053O00202O00020002004B4O0003000A6O000300036O00010003000200062O000100E703013O0004CF3O00E703012O00600001000B3O00122D0002006D3O00122D0003006E4O002E000100034O009F00015O00122D3O006F3O00261F3O00740401004F0004CF3O007404012O0060000100053O0020C500010001002D00209E0001000100042O00650001000200020006070001002404013O0004CF3O002404012O0060000100113O0006070001002404013O0004CF3O002404012O0060000100053O0020C500010001002D00209E0001000100452O006500010002000200261F00010012040100120004CF3O001204012O0060000100053O0020C500010001000800209E0001000100092O00650001000200020006070001001704013O0004CF3O001704012O0060000100053O0020C500010001000800209E0001000100092O00650001000200020006070001000C04013O0004CF3O000C04012O0060000100083O0020EC00010001000A4O000300053O00202O00030003000B4O00010003000200062O00010017040100010004CF3O001704012O0060000100053O0020C500010001001300209E0001000100092O006500010002000200061100010017040100010004CF3O001704012O0060000100073O00209E0001000100212O0065000100020002002622000100240401004C0004CF3O002404012O0060000100094O004E000200053O00202O00020002002D4O0003000A6O000300036O00010003000200062O0001002404013O0004CF3O002404012O00600001000B3O00122D000200703O00122D000300714O002E000100034O009F00016O0060000100053O0020C500010001007200209E0001000100112O00650001000200020006070001003D04013O0004CF3O003D04012O0060000100203O0006070001003D04013O0004CF3O003D04012O0060000100063O000E240012003D040100010004CF3O003D04012O0060000100094O004E000200053O00202O0002000200724O0003000A6O000300036O00010003000200062O0001003D04013O0004CF3O003D04012O00600001000B3O00122D000200733O00122D000300744O002E000100034O009F00016O0060000100053O0020C500010001001500209E0001000100112O00650001000200020006070001005304013O0004CF3O005304012O0060000100103O0006070001005304013O0004CF3O005304012O0060000100094O004E000200053O00202O0002000200154O0003000A6O000300036O00010003000200062O0001005304013O0004CF3O005304012O00600001000B3O00122D000200753O00122D000300764O002E000100034O009F00016O0060000100053O0020C500010001007700209E0001000100112O00650001000200020006070001007304013O0004CF3O007304012O0060000100213O0006070001007304013O0004CF3O007304012O0060000100063O00261F00010073040100050004CF3O007304012O0060000100083O0020090001000100784O000300053O00202O0003000300244O00010003000200062O0001007304013O0004CF3O007304012O0060000100094O004E000200053O00202O0002000200774O0003000A6O000300036O00010003000200062O0001007304013O0004CF3O007304012O00600001000B3O00122D000200793O00122D0003007A4O002E000100034O009F00015O00122D3O00613O00261F3O0041050100010004CF3O004105012O0060000100053O0020C500010001003400209E0001000100112O00650001000200020006070001009D04013O0004CF3O009D04012O0060000100153O0006070001009D04013O0004CF3O009D04012O0060000100073O0020090001000100064O000300053O00202O00030003007B4O00010003000200062O0001009D04013O0004CF3O009D04012O0060000100073O00203700010001007C4O000300053O00202O00030003007B4O0001000300024O000200073O00202O0002000200174O00020002000200062O0001009D040100020004CF3O009D04012O0060000100094O004E000200053O00202O0002000200344O0003000A6O000300036O00010003000200062O0001009D04013O0004CF3O009D04012O00600001000B3O00122D0002007D3O00122D0003007E4O002E000100034O009F00016O0060000100053O0020C500010001007200209E0001000100112O0065000100020002000607000100C904013O0004CF3O00C904012O0060000100203O000607000100C904013O0004CF3O00C904012O0060000100063O000E24001200C9040100010004CF3O00C904012O0060000100053O0020C500010001007F00209E0001000100092O0065000100020002000607000100C904013O0004CF3O00C904012O0060000100053O0020C500010001007700209E0001000100092O0065000100020002000607000100C904013O0004CF3O00C904012O0060000100083O0020090001000100784O000300053O00202O0003000300244O00010003000200062O000100C904013O0004CF3O00C904012O0060000100094O004E000200053O00202O0002000200724O0003000A6O000300036O00010003000200062O000100C904013O0004CF3O00C904012O00600001000B3O00122D000200803O00122D000300814O002E000100034O009F00016O0060000100053O0020C500010001002500209E0001000100042O0065000100020002000607000100F104013O0004CF3O00F104012O0060000100223O000607000100F104013O0004CF3O00F104012O0060000100063O000EA0001200F1040100010004CF3O00F104012O0060000100053O0020C500010001000300209E0001000100162O0065000100020002000EDA008200E1040100010004CF3O00E104012O0060000100053O0020C500010001000300209E0001000100092O0065000100020002000611000100F1040100010004CF3O00F104012O0060000100094O0033000200053O00202O0002000200254O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O000100F104013O0004CF3O00F104012O00600001000B3O00122D000200833O00122D000300844O002E000100034O009F00016O0060000100053O0020C500010001007700209E0001000100112O00650001000200020006070001000D05013O0004CF3O000D05012O0060000100213O0006070001000D05013O0004CF3O000D05012O0060000100063O00261F0001000D050100050004CF3O000D05012O0060000100083O00209E0001000100362O0065000100020002000EDA00370033050100010004CF3O003305012O0060000100053O0020C500010001003800209E0001000100092O00650001000200020006070001000D05013O0004CF3O000D05012O0060000100083O00209E0001000100362O0065000100020002002O2600010033050100390004CF3O003305012O0060000100053O0020C500010001002300209E0001000100092O00650001000200020006070001004005013O0004CF3O004005012O0060000100053O00200400010001002000202O0001000100164O0001000200024O000200073O00202O0002000200174O00020002000200062O00010040050100020004CF3O004005012O0060000100053O00209600010001008500202O0001000100164O0001000200024O000200073O00202O0002000200174O00020002000200062O0001002C050100020004CF3O002C05012O0060000100083O00200900010001000A4O000300053O00202O00030003000B4O00010003000200062O0001004005013O0004CF3O004005012O0060000100083O002O2000010001000C4O000300053O00202O0003000300244O00010003000200262O00010040050100860004CF3O004005012O0060000100094O004E000200053O00202O0002000200774O0003000A6O000300036O00010003000200062O0001004005013O0004CF3O004005012O00600001000B3O00122D000200873O00122D000300884O002E000100034O009F00015O00122D3O00053O00261F3O00890501006F0004CF3O008905012O0060000100053O0020C500010001004000209E0001000100042O00650001000200020006070001006205013O0004CF3O006205012O0060000100193O0006070001006205013O0004CF3O006205012O0060000100053O0020C500010001004100209E0001000100092O00650001000200020006070001006205013O0004CF3O006205012O0060000100094O0033000200053O00202O0002000200404O000300083O00202O00030003001D4O0005000E6O0003000500024O000300036O00010003000200062O0001006205013O0004CF3O006205012O00600001000B3O00122D000200893O00122D0003008A4O002E000100034O009F00016O0060000100043O0006070001001F06013O0004CF3O001F06012O006000016O0060000200013O00067C0001001F060100020004CF3O001F06012O0060000100023O0006070001001F06013O0004CF3O001F06012O0060000100033O0006070001007205013O0004CF3O007205012O0060000100043O00061100010075050100010004CF3O007505012O0060000100033O0006110001001F060100010004CF3O001F06012O0060000100053O0020C500010001000300209E0001000100042O00650001000200020006070001001F06013O0004CF3O001F06012O0060000100094O004E000200053O00202O0002000200034O0003000A6O000300036O00010003000200062O0001001F06013O0004CF3O001F06012O00600001000B3O0012480002008B3O00122O0003008C6O000100036O00015O00044O001F060100261F3O0001000100050004CF3O000100012O006000016O0060000200013O00067C000100AE050100020004CF3O00AE05012O0060000100233O000607000100AE05013O0004CF3O00AE05012O0060000100243O0006070001009805013O0004CF3O009805012O0060000100043O0006110001009B050100010004CF3O009B05012O0060000100243O000611000100AE050100010004CF3O00AE05012O0060000100053O0020C500010001008D00209E0001000100042O0065000100020002000607000100AE05013O0004CF3O00AE05012O0060000100094O004E000200053O00202O00020002008D4O0003000A6O000300036O00010003000200062O000100AE05013O0004CF3O00AE05012O00600001000B3O00122D0002008E3O00122D0003008F4O002E000100034O009F00016O006000016O0060000200013O00067C000100D4050100020004CF3O00D405012O0060000100053O0020C500010001009000209E0001000100042O0065000100020002000607000100D405013O0004CF3O00D405012O0060000100253O000607000100D405013O0004CF3O00D405012O0060000100263O000607000100C105013O0004CF3O00C105012O0060000100043O000611000100C4050100010004CF3O00C405012O0060000100263O000611000100D4050100010004CF3O00D405012O0060000100063O000E24000500D4050100010004CF3O00D405012O0060000100094O004E000200053O00202O0002000200904O0003000A6O000300036O00010003000200062O000100D405013O0004CF3O00D405012O00600001000B3O00122D000200913O00122D000300924O002E000100034O009F00016O006000016O0060000200013O00067C000100FA050100020004CF3O00FA05012O0060000100273O000607000100FA05013O0004CF3O00FA05012O0060000100283O000607000100E105013O0004CF3O00E105012O0060000100043O000611000100E4050100010004CF3O00E405012O0060000100283O000611000100FA050100010004CF3O00FA05012O0060000100053O0020C500010001008500209E0001000100042O0065000100020002000607000100FA05013O0004CF3O00FA05012O0060000100123O00203D0001000100314O000200053O00202O0002000200854O000300136O000400296O0005000A6O000500056O00010005000200062O000100FA05013O0004CF3O00FA05012O00600001000B3O00122D000200933O00122D000300944O002E000100034O009F00016O006000016O0060000200013O00067C0001001D060100020004CF3O001D06012O0060000100273O0006070001001D06013O0004CF3O001D06012O0060000100283O0006070001000706013O0004CF3O000706012O0060000100043O0006110001000A060100010004CF3O000A06012O0060000100283O0006110001001D060100010004CF3O001D06012O0060000100053O0020C500010001008500209E0001000100042O00650001000200020006070001001D06013O0004CF3O001D06012O0060000100094O004E000200053O00202O0002000200854O0003000A6O000300036O00010003000200062O0001001D06013O0004CF3O001D06012O00600001000B3O00122D000200953O00122D000300964O002E000100034O009F00015O00122D3O00123O0004CF3O000100012O00B43O00017O005B3O00028O00026O00F03F030A3O00576172627265616B6572030A3O0049734361737461626C6503153O00AE22B976ADBA44BFBC31EB71A7BA46A1AD26EB21EB03083O00D4D943CB142ODF25030D3O00436F6C6F2O737573536D61736803193O00B982A4DDA99EBDC1859EA5D3A985E8D7A288ABC7AE88E887EF03043O00B2DAEDC803073O004578656375746503073O004973526561647903063O0042752O665570030F3O0053752O64656E446561746842752O66030D3O00446562752O6652656D61696E7303103O00442O6570576F756E6473446562752O6603123O00B3ADE3D3A3A1E390B3ADE3D3A3A1E3902OE303043O00B0D6D586027O0040026O00104003093O004F766572706F77657203043O0052616765026O00444003093O0042752O66537461636B03123O004D61727469616C50726F77652O7342752O6603143O00FBBBB3C6B8594EF1BFF6D1B0535AE1B9B394FE0603073O003994CDD6B4C83603123O0017E530376306F875316E17FE2O207352AB6703053O0016729D555403093O0053686F636B7761766503093O00536F6E6963422O6F6D030B3O004973417661696C61626C6503093O00497343617374696E67030E3O004973496E4D656C2O6552616E676503143O00D7C31CC756E1A9D2CE53C145F3ABD1DF16840BA503073O00C8A4AB73A43D96026O001440030D3O00536B752O6C73706C692O746572030B3O00546573746F664D69676874030E3O005261676550657263656E74616765026O003E4003083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66030F3O00432O6F6C646F776E52656D61696E7303183O00ADFF16498FADE40F4C97AAF1110586A6F1005097BBB4561203053O00E3DE946325030E3O005468756E6465726F7573526F6172030F3O00546573746F664D6967687442752O66031A3O00275A47F8FD36405DE3EA0C405DF7EB73574AF3FA264657B6AC6403053O0099532O329603063O004D7A720576B903073O002D3D16137C13CB030E3O0053706561726F6642617374696F6E03143O0053706561724F6642617374696F6E506C61796572030E3O0049735370652O6C496E52616E6765031B3O00D20208F4104FB6C72D0FF41164B0CE1C4DF01A75BAD40608B5572703073O00D9A1726D956210026O000840030F3O0053772O6570696E67537472696B6573031B3O0001373D79AC7D1C27076FA8661B2B3D6FFC710A253B69A87152756903063O00147240581CDC03043O0052656E64030A3O0052656E64446562752O662O033O00474344030C3O00426C2O6F646C652O74696E6703093O0054696D65546F446965026O002840030F3O002304DCB0B8D5A53402C7A0FD90E86303073O00DD5161B2D498B003063O00417661746172030A3O00432O6F6C646F776E5570026O00344003113O00CCF11CEF1BDFA718E31FCEF209FE5A98B403053O007AAD877D9B03143O008BD705AB2F3EDF81D340BC2734CB91D505F9696503073O00A8E4A160D95F51030A3O00426C61646573746F726D03153O00D9DD2F582A44CFDE3C516F52C3D42D493B529B877B03063O0037BBB14E3C4F03063O002EDB4DF849DD03073O00E04DAE3F8B26AF03143O0053706561724F6642617374696F6E437572736F72031B3O0097515D2F967E5728BB43593D90485720C444402B87544C2BC4140F03043O004EE4213803063O00436C6561766503113O00CD72B70293CB3EB71B80CD6BA606C59B2603053O00E5AE1ED263030C3O004D6F7274616C537472696B65030B3O00446562752O66537461636B031B3O00457865637574696F6E657273507265636973696F6E446562752O6603183O0016E29445EC310608F99458E638791EF58352F8293C5BB8DF03073O00597B8DE6318D5D00E2022O00122D3O00013O00261F3O006E000100020004CF3O006E00012O006000016O0060000200013O00067C00010026000100020004CF3O002600012O0060000100023O0006070001002600013O0004CF3O002600012O0060000100033O0006070001001000013O0004CF3O001000012O0060000100043O00061100010013000100010004CF3O001300012O0060000100033O00061100010026000100010004CF3O002600012O0060000100053O0020C500010001000300209E0001000100042O00650001000200020006070001002600013O0004CF3O002600012O0060000100064O004E000200053O00202O0002000200034O000300076O000300036O00010003000200062O0001002600013O0004CF3O002600012O0060000100083O00122D000200053O00122D000300064O002E000100034O009F00016O006000016O0060000200013O00067C00010049000100020004CF3O004900012O0060000100093O0006070001004900013O0004CF3O004900012O00600001000A3O0006070001003300013O0004CF3O003300012O0060000100043O00061100010036000100010004CF3O003600012O00600001000A3O00061100010049000100010004CF3O004900012O0060000100053O0020C500010001000700209E0001000100042O00650001000200020006070001004900013O0004CF3O004900012O0060000100064O004E000200053O00202O0002000200074O000300076O000300036O00010003000200062O0001004900013O0004CF3O004900012O0060000100083O00122D000200083O00122D000300094O002E000100034O009F00016O0060000100053O0020C500010001000A00209E00010001000B2O00650001000200020006070001006D00013O0004CF3O006D00012O00600001000B3O0006070001006D00013O0004CF3O006D00012O00600001000C3O00200900010001000C4O000300053O00202O00030003000D4O00010003000200062O0001006D00013O0004CF3O006D00012O00600001000D3O0020E100010001000E4O000300053O00202O00030003000F4O000100030002000E2O0001006D000100010004CF3O006D00012O0060000100064O004E000200053O00202O00020002000A4O000300076O000300036O00010003000200062O0001006D00013O0004CF3O006D00012O0060000100083O00122D000200103O00122D000300114O002E000100034O009F00015O00122D3O00123O00261F3O00CD000100130004CF3O00CD00012O0060000100053O0020C500010001001400209E0001000100042O00650001000200020006070001009200013O0004CF3O009200012O00600001000E3O0006070001009200013O0004CF3O009200012O00600001000C3O00209E0001000100152O006500010002000200262200010092000100160004CF3O009200012O00600001000C3O002O200001000100174O000300053O00202O0003000300184O00010003000200262O00010092000100120004CF3O009200012O0060000100064O004E000200053O00202O0002000200144O000300076O000300036O00010003000200062O0001009200013O0004CF3O009200012O0060000100083O00122D000200193O00122D0003001A4O002E000100034O009F00016O0060000100053O0020C500010001000A00209E00010001000B2O0065000100020002000607000100A800013O0004CF3O00A800012O00600001000B3O000607000100A800013O0004CF3O00A800012O0060000100064O004E000200053O00202O00020002000A4O000300076O000300036O00010003000200062O000100A800013O0004CF3O00A800012O0060000100083O00122D0002001B3O00122D0003001C4O002E000100034O009F00016O0060000100053O0020C500010001001D00209E0001000100042O0065000100020002000607000100CC00013O0004CF3O00CC00012O00600001000F3O000607000100CC00013O0004CF3O00CC00012O0060000100053O0020C500010001001E00209E00010001001F2O0065000100020002000611000100BC000100010004CF3O00BC00012O00600001000D3O00209E0001000100202O0065000100020002000607000100CC00013O0004CF3O00CC00012O0060000100064O0033000200053O00202O00020002001D4O0003000D3O00202O0003000300214O000500106O0003000500024O000300036O00010003000200062O000100CC00013O0004CF3O00CC00012O0060000100083O00122D000200223O00122D000300234O002E000100034O009F00015O00122D3O00243O00261F3O00822O0100120004CF3O00822O012O0060000100053O0020C500010001002500209E0001000100042O00650001000200020006070001000B2O013O0004CF3O000B2O012O0060000100113O0006070001000B2O013O0004CF3O000B2O012O0060000100053O0020C500010001002600209E00010001001F2O0065000100020002000607000100E300013O0004CF3O00E300012O00600001000C3O00209E0001000100272O006500010002000200264C000100FB000100280004CF3O00FB00012O0060000100053O0020C500010001002600209E00010001001F2O00650001000200020006110001000B2O0100010004CF3O000B2O012O00600001000D3O0020EC0001000100294O000300053O00202O00030003002A4O00010003000200062O000100F6000100010004CF3O00F600012O0060000100053O0020C500010001000700209E00010001002B2O0065000100020002000E240024000B2O0100010004CF3O000B2O012O00600001000C3O00209E0001000100272O00650001000200020026D90001000B2O0100280004CF3O000B2O012O0060000100064O0033000200053O00202O0002000200254O0003000D3O00202O0003000300214O000500106O0003000500024O000300036O00010003000200062O0001000B2O013O0004CF3O000B2O012O0060000100083O00122D0002002C3O00122D0003002D4O002E000100034O009F00016O006000016O0060000200013O00067C000100452O0100020004CF3O00452O012O0060000100123O000607000100452O013O0004CF3O00452O012O0060000100133O000607000100182O013O0004CF3O00182O012O0060000100043O0006110001001B2O0100010004CF3O001B2O012O0060000100133O000611000100452O0100010004CF3O00452O012O0060000100053O0020C500010001002E00209E0001000100042O0065000100020002000607000100452O013O0004CF3O00452O012O00600001000C3O0020EC00010001000C4O000300053O00202O00030003002F4O00010003000200062O000100352O0100010004CF3O00352O012O0060000100053O0020C500010001002600209E00010001001F2O0065000100020002000611000100452O0100010004CF3O00452O012O00600001000D3O0020090001000100294O000300053O00202O00030003002A4O00010003000200062O000100452O013O0004CF3O00452O012O0060000100064O0033000200053O00202O00020002002E4O0003000D3O00202O0003000300214O000500106O0003000500024O000300036O00010003000200062O000100452O013O0004CF3O00452O012O0060000100083O00122D000200303O00122D000300314O002E000100034O009F00016O006000016O0060000200013O00067C000100812O0100020004CF3O00812O012O0060000100143O000607000100812O013O0004CF3O00812O012O0060000100153O000607000100522O013O0004CF3O00522O012O0060000100043O000611000100552O0100010004CF3O00552O012O0060000100153O000611000100812O0100010004CF3O00812O012O0060000100164O008C000200083O00122O000300323O00122O000400336O00020004000200062O000100812O0100020004CF3O00812O012O0060000100053O0020C500010001003400209E0001000100042O0065000100020002000607000100812O013O0004CF3O00812O012O00600001000D3O0020EC0001000100294O000300053O00202O00030003002A4O00010003000200062O000100702O0100010004CF3O00702O012O00600001000C3O00200900010001000C4O000300053O00202O00030003002F4O00010003000200062O000100812O013O0004CF3O00812O012O0060000100064O0072000200173O00202O0002000200354O0003000D3O00202O0003000300364O000500053O00202O0005000500344O0003000500024O000300036O00010003000200062O000100812O013O0004CF3O00812O012O0060000100083O00122D000200373O00122D000300384O002E000100034O009F00015O00122D3O00393O00261F3O001B020100010004CF3O001B02012O006000016O0060000200013O00067C000100A42O0100020004CF3O00A42O012O0060000100183O000607000100A42O013O0004CF3O00A42O012O0060000100053O0020C500010001003A00209E0001000100042O0065000100020002000607000100A42O013O0004CF3O00A42O012O0060000100193O000E24000200A42O0100010004CF3O00A42O012O0060000100064O0033000200053O00202O00020002003A4O0003000D3O00202O0003000300214O000500106O0003000500024O000300036O00010003000200062O000100A42O013O0004CF3O00A42O012O0060000100083O00122D0002003B3O00122D0003003C4O002E000100034O009F00016O0060000100053O0020C500010001003D00209E00010001000B2O0065000100020002000607000100E72O013O0004CF3O00E72O012O00600001001A3O000607000100E72O013O0004CF3O00E72O012O00600001000D3O00208F00010001000E4O000300053O00202O00030003003E4O0001000300024O0002000C3O00202O00020002003F4O00020002000200062O000100E72O0100020004CF3O00E72O012O0060000100053O0020C500010001004000209E00010001001F2O0065000100020002000611000100E72O0100010004CF3O00E72O012O0060000100053O0020C500010001000300209E00010001001F2O0065000100020002000611000100C92O0100010004CF3O00C92O012O0060000100053O0020C500010001000700209E00010001002B2O0065000100020002002O26000100D52O0100130004CF3O00D52O012O0060000100053O0020C500010001000300209E00010001001F2O0065000100020002000607000100E72O013O0004CF3O00E72O012O0060000100053O0020C500010001000300209E00010001002B2O0065000100020002002622000100E72O0100130004CF3O00E72O012O00600001000D3O00209E0001000100412O0065000100020002000E24004200E72O0100010004CF3O00E72O012O0060000100064O004E000200053O00202O00020002003D4O000300076O000300036O00010003000200062O000100E72O013O0004CF3O00E72O012O0060000100083O00122D000200433O00122D000300444O002E000100034O009F00016O006000016O0060000200013O00067C0001001A020100020004CF3O001A02012O00600001001B3O0006070001001A02013O0004CF3O001A02012O00600001001C3O000607000100F42O013O0004CF3O00F42O012O0060000100043O000611000100F72O0100010004CF3O00F72O012O00600001001C3O0006110001001A020100010004CF3O001A02012O0060000100053O0020C500010001004500209E0001000100042O00650001000200020006070001001A02013O0004CF3O001A02012O0060000100053O0020C500010001000700209E0001000100462O00650001000200020006110001000D020100010004CF3O000D02012O00600001000D3O0020EC0001000100294O000300053O00202O00030003002A4O00010003000200062O0001000D020100010004CF3O000D02012O0060000100013O0026220001001A020100470004CF3O001A02012O0060000100064O004E000200053O00202O0002000200454O000300076O000300036O00010003000200062O0001001A02013O0004CF3O001A02012O0060000100083O00122D000200483O00122D000300494O002E000100034O009F00015O00122D3O00023O00261F3O0057020100240004CF3O005702012O0060000100053O0020C500010001001400209E0001000100042O00650001000200020006070001003302013O0004CF3O003302012O00600001000E3O0006070001003302013O0004CF3O003302012O0060000100064O004E000200053O00202O0002000200144O000300076O000300036O00010003000200062O0001003302013O0004CF3O003302012O0060000100083O00122D0002004A3O00122D0003004B4O002E000100034O009F00016O006000016O0060000200013O00067C000100E1020100020004CF3O00E102012O00600001001D3O000607000100E102013O0004CF3O00E102012O00600001001E3O0006070001004002013O0004CF3O004002012O0060000100043O00061100010043020100010004CF3O004302012O00600001001E3O000611000100E1020100010004CF3O00E102012O0060000100053O0020C500010001004C00209E0001000100042O0065000100020002000607000100E102013O0004CF3O00E102012O0060000100064O004E000200053O00202O00020002004C4O000300076O000300036O00010003000200062O000100E102013O0004CF3O00E102012O0060000100083O0012480002004D3O00122O0003004E6O000100036O00015O00044O00E1020100261F3O0001000100390004CF3O000100012O006000016O0060000200013O00067C00010095020100020004CF3O009502012O0060000100143O0006070001009502013O0004CF3O009502012O0060000100153O0006070001006602013O0004CF3O006602012O0060000100043O00061100010069020100010004CF3O006902012O0060000100153O00061100010095020100010004CF3O009502012O0060000100164O008C000200083O00122O0003004F3O00122O000400506O00020004000200062O00010095020100020004CF3O009502012O0060000100053O0020C500010001003400209E0001000100042O00650001000200020006070001009502013O0004CF3O009502012O00600001000D3O0020EC0001000100294O000300053O00202O00030003002A4O00010003000200062O00010084020100010004CF3O008402012O00600001000C3O00200900010001000C4O000300053O00202O00030003002F4O00010003000200062O0001009502013O0004CF3O009502012O0060000100064O0072000200173O00202O0002000200514O0003000D3O00202O0003000300364O000500053O00202O0005000500344O0003000500024O000300036O00010003000200062O0001009502013O0004CF3O009502012O0060000100083O00122D000200523O00122D000300534O002E000100034O009F00016O0060000100053O0020C500010001005400209E00010001000B2O0065000100020002000607000100B802013O0004CF3O00B802012O00600001001F3O000607000100B802013O0004CF3O00B802012O0060000100193O000E24001200B8020100010004CF3O00B802012O00600001000D3O00203700010001000E4O000300053O00202O00030003000F4O0001000300024O0002000C3O00202O00020002003F4O00020002000200062O000100B8020100020004CF3O00B802012O0060000100064O004E000200053O00202O0002000200544O000300076O000300036O00010003000200062O000100B802013O0004CF3O00B802012O0060000100083O00122D000200553O00122D000300564O002E000100034O009F00016O0060000100053O0020C500010001005700209E00010001000B2O0065000100020002000607000100DF02013O0004CF3O00DF02012O0060000100203O000607000100DF02013O0004CF3O00DF02012O00600001000D3O00206B0001000100584O000300053O00202O0003000300594O00010003000200262O000100D2020100120004CF3O00D202012O00600001000D3O00208F00010001000E4O000300053O00202O00030003000F4O0001000300024O0002000C3O00202O00020002003F4O00020002000200062O000100DF020100020004CF3O00DF02012O0060000100064O004E000200053O00202O0002000200574O000300076O000300036O00010003000200062O000100DF02013O0004CF3O00DF02012O0060000100083O00122D0002005A3O00122D0003005B4O002E000100034O009F00015O00122D3O00133O0004CF3O000100012O00B43O00017O00873O00028O00026O00F03F03043O0052656E6403073O0049735265616479030D3O00446562752O6652656D61696E73030A3O0052656E64446562752O662O033O00474344030B3O00546964656F66426C2O6F64030B3O004973417661696C61626C65030D3O00536B752O6C73706C692O746572030F3O00432O6F6C646F776E52656D61696E73030D3O00436F6C6F2O737573536D61736803083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O66030C3O00426173654475726174696F6E026O33EB3F03163O00E174F8085059FA7FF1001575E770E40B155EB320A65C03063O002A9311966C7003063O00417661746172030A3O0049734361737461626C65030F3O005761726C6F726473546F726D656E74030E3O005261676550657263656E74616765025O00802O40030A3O00432O6F6C646F776E557003063O0042752O665570030F3O00546573746F664D6967687442752O6603183O000EB02C6BE6FA4FB52471E0E40A99397EF5EF0AB26D2EB7B903063O00886FC64D1F8703063O001205A64FB8F603083O00C96269C736DD8477030E3O0053706561726F6642617374696F6E030A3O00576172627265616B657203143O0053706561724F6642617374696F6E506C61796572030E3O0049735370652O6C496E52616E676503223O00AA1C8620100AA3BF3381201121A5B602C3320B3BABB509BC350327ABBC18C370526703073O00CCD96CE3416255027O0040026O000840030B3O00546573746F664D6967687403103O00442O6570576F756E6473446562752O66031F3O004DC8E0E920D34ECFFCF138C54C83E6EC22C752C6CAF12DD259C6E1A57D900B03063O00A03EA395854C031F3O00C5AB1823CFC5B00126D7C2A51F6FD0DFAE0A23C6E9B40C3DC4D3B44D7E938003053O00A3B6C06D4F030E3O005468756E6465726F7573526F6172030E3O004973496E4D656C2O6552616E676503213O00202E15CEF131340FD5E60B340FC1E7743509CEF238233FD4F4262105D4B565765703053O0095544660A0026O001040030F3O0053772O6570696E67537472696B657303213O002B1108E8280F03EA071519FF310D08FE781504E33F0A08D22C071FEA3D124DB46F03043O008D58666D03073O0045786563757465030F3O0053752O64656E446561746842752O6603183O00B64BCF730F295081A05AC47716386AD5B241CD750E7D0C9903083O00A1D333AA107A5D35030C3O004D6F7274616C537472696B65031E3O00F6A1A03CFAA28D3BEFBCBB23FEEEA121F5A9BE2DC4BAB33AFCABA668A2F703043O00489BCED2026O00204003063O00436C6561766503073O0048617354696572026O003D40030D3O004372757368696E67466F72636503183O004576510F25433A47073D41765131274768530B27062B065F03053O0053261A346E030A3O00426C61646573746F726D031C3O005A1B26425D0433494A1A67555119204A5D2833474A1022521846751403043O002638774703183O00F0E35DD73353B3FC51D8225AF6D04CD73751F6FB1887770503063O0036938F38B645026O002240026O00144003093O0053686F636B7761766503093O00536F6E6963422O6F6D03093O00497343617374696E67031B3O00C589F04AD4C180E94C9FC588F14E2OD3BEEB48CDD184EB098E87D003053O00BFB6E19F2903093O00576869726C77696E64030D3O0053746F726D6F6653776F726473026O001C40031B3O003C1A21478790CB251668468289C5272O17418A95C52E066804DAD403073O00A24B724835EBE703093O004F766572706F77657203073O0043686172676573030A3O0042612O746C656C6F7264026O003940031B3O00832A41F0430D9B3956A2400B823B48E76C168D2E43E74742DD6D1003063O0062EC5C248233026O00184003043O00536C616D03043O0052616765026O004E40030C3O00496D70726F766564536C616D030E3O00466572766F726F6642612O746C6503163O00B7150DB705BBBC3EA315098551A9A737A10D4CEB14FD03083O0050C4796CDA25C8D5031B3O00177B0B6D4719830E77426C42008D0C763D6B4A1C8D0567422E1A5803073O00EA6013621F2B6E026O003E4003163O00151353CAEC618208185EC293668A141857D3EC23DA5103073O00EB667F32A7CC1203113O00446562752O665265667265736861626C6503163O0042A4FB27043D59AFF22F411144A0E724413A10F0A77703063O004E30C195432403063O00330B920B4E2203053O0021507EE07803143O0053706561724F6642617374696F6E437572736F7203223O00FFB806C54ED3A705FB5EEDBB17CD53E2E810CD52EBA406FB48EDBA04C148ACF9539603053O003C8CC863A403093O004973496E52616E6765031C3O0090F51624B082F50F23B0C7E70D28A58BF13B32A395F30132E2D6A45703053O00C2E794644603203O004543CDACE5DB535FFEB0FBC9554481B0FFC64140C49CE2C9544BC4B7B699161803063O00A8262CA1C396030B3O005468756E646572436C6170030F3O00426C2O6F64616E645468756E646572031E3O0094F4977834EDA42983F0836670FBBF1887F0874924E9A41185E8C22761B003083O0076E09CE2165088D6030A3O00446562752O66446F776E026O004940031B3O004DF85C9252E14E8550AE4A894CE955857DFA589245EB4DC013BF0003043O00E0228E3903183O004D657263696C652O73426F6E656772696E64657242752O66031B3O00C9AFCCCF7FE65400DAE7D6D47DF6510BE1B3C4CF74F4494E8FF59503083O006EBEC7A5BD13913D026O005440031B3O00CDE37EFA87D0D3E573A898CED4EC7BEDB4D3DBF970ED9F878BBB2F03063O00A7BA8B1788EB031E3O000EBD9D031EB09A3219B9891D5AA681031DB98D320EB49A0A1FA1C85C4AEC03043O006D7AD5E803093O0048752O726963616E6503083O00556E68696E676564031C3O00ECFBA334EBE4B63FFCFAE223E7F9A53CEBC8B631FCF0A724AEA6F36003043O00508E97C2003D052O00122D3O00013O000E9A000200E400013O0004CF3O00E400012O006000015O0020C500010001000300209E0001000100042O00650001000200020006070001004E00013O0004CF3O004E00012O0060000100013O0006070001004E00013O0004CF3O004E00012O0060000100023O00209E0001000100052O00A700035O00202O0003000300064O0001000300024O000200033O00202O0002000200074O00020002000200062O0001002C000100020004CF3O004100012O006000015O0020C500010001000800209E0001000100092O00650001000200020006070001004E00013O0004CF3O004E00012O006000015O00200400010001000A00202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O0001004E000100020004CF3O004E00012O006000015O0020F500010001000C00202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O00010008000100020004CF3O003500012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O0001004E00013O0004CF3O004E00012O0060000100023O00202B0001000100054O00035O00202O0003000300064O0001000300024O00025O00202O00020002000600202O00020002000F4O00020002000200202O00020002001000062O0001004E000100020004CF3O004E00012O0060000100044O004E00025O00202O0002000200034O000300056O000300036O00010003000200062O0001004E00013O0004CF3O004E00012O0060000100063O00122D000200113O00122D000300124O002E000100034O009F00016O0060000100074O0060000200083O00067C000100A3000100020004CF3O00A300012O0060000100093O000607000100A300013O0004CF3O00A300012O00600001000A3O0006070001005B00013O0004CF3O005B00012O00600001000B3O0006110001005E000100010004CF3O005E00012O00600001000A3O000611000100A3000100010004CF3O00A300012O006000015O0020C500010001001300209E0001000100142O0065000100020002000607000100A300013O0004CF3O00A300012O006000015O0020C500010001001500209E0001000100092O00650001000200020006070001008300013O0004CF3O008300012O0060000100033O00209E0001000100162O006500010002000200262200010083000100170004CF3O008300012O006000015O0020C500010001000C00209E0001000100182O006500010002000200061100010096000100010004CF3O009600012O0060000100023O0020EC00010001000D4O00035O00202O00030003000E4O00010003000200062O00010096000100010004CF3O009600012O0060000100033O0020EC0001000100194O00035O00202O00030003001A4O00010003000200062O00010096000100010004CF3O009600012O006000015O0020C500010001001500209E0001000100092O0065000100020002000611000100A3000100010004CF3O00A300012O006000015O0020C500010001000C00209E0001000100182O006500010002000200061100010096000100010004CF3O009600012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O000100A300013O0004CF3O00A300012O0060000100044O004E00025O00202O0002000200134O000300056O000300036O00010003000200062O000100A300013O0004CF3O00A300012O0060000100063O00122D0002001B3O00122D0003001C4O002E000100034O009F00016O0060000100074O0060000200083O00067C000100E3000100020004CF3O00E300012O00600001000C3O000607000100E300013O0004CF3O00E300012O00600001000D3O000607000100B000013O0004CF3O00B000012O00600001000B3O000611000100B3000100010004CF3O00B300012O00600001000D3O000611000100E3000100010004CF3O00E300012O00600001000E4O008C000200063O00122O0003001D3O00122O0004001E6O00020004000200062O000100E3000100020004CF3O00E300012O006000015O0020C500010001001F00209E0001000100142O0065000100020002000607000100E300013O0004CF3O00E300012O006000015O0020F500010001000C00202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O0001000A000100020004CF3O00D200012O006000015O00200400010001002000202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O000100E3000100020004CF3O00E300012O0060000100044O00720002000F3O00202O0002000200214O000300023O00202O0003000300224O00055O00202O00050005001F4O0003000500024O000300036O00010003000200062O000100E300013O0004CF3O00E300012O0060000100063O00122D000200233O00122D000300244O002E000100034O009F00015O00122D3O00253O00261F3O00862O0100260004CF3O00862O012O006000015O0020C500010001000A00209E0001000100142O0065000100020002000607000100162O013O0004CF3O00162O012O0060000100103O000607000100162O013O0004CF3O00162O012O006000015O0020C500010001002700209E0001000100092O0065000100020002000611000100162O0100010004CF3O00162O012O0060000100023O0020E10001000100054O00035O00202O0003000300284O000100030002000E2O000100162O0100010004CF3O00162O012O0060000100023O0020EC00010001000D4O00035O00202O00030003000E4O00010003000200062O000100092O0100010004CF3O00092O012O006000015O0020C500010001000C00209E00010001000B2O0065000100020002000E24002600162O0100010004CF3O00162O012O0060000100044O004E00025O00202O00020002000A4O000300056O000300036O00010003000200062O000100162O013O0004CF3O00162O012O0060000100063O00122D000200293O00122D0003002A4O002E000100034O009F00016O006000015O0020C500010001000A00209E0001000100142O0065000100020002000607000100392O013O0004CF3O00392O012O0060000100103O000607000100392O013O0004CF3O00392O012O006000015O0020C500010001002700209E0001000100092O0065000100020002000607000100392O013O0004CF3O00392O012O0060000100023O0020E10001000100054O00035O00202O0003000300284O000100030002000E2O000100392O0100010004CF3O00392O012O0060000100044O004E00025O00202O00020002000A4O000300056O000300036O00010003000200062O000100392O013O0004CF3O00392O012O0060000100063O00122D0002002B3O00122D0003002C4O002E000100034O009F00016O0060000100074O0060000200083O00067C000100852O0100020004CF3O00852O012O0060000100113O000607000100852O013O0004CF3O00852O012O0060000100123O000607000100462O013O0004CF3O00462O012O00600001000B3O000611000100492O0100010004CF3O00492O012O0060000100123O000611000100852O0100010004CF3O00852O012O006000015O0020C500010001002D00209E0001000100142O0065000100020002000607000100852O013O0004CF3O00852O012O0060000100033O0020EC0001000100194O00035O00202O00030003001A4O00010003000200062O000100752O0100010004CF3O00752O012O006000015O0020C500010001002700209E0001000100092O0065000100020002000607000100682O013O0004CF3O00682O012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O000100682O013O0004CF3O00682O012O0060000100033O00209E0001000100162O0065000100020002002O26000100752O0100170004CF3O00752O012O006000015O0020C500010001002700209E0001000100092O0065000100020002000611000100852O0100010004CF3O00852O012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O000100852O013O0004CF3O00852O012O0060000100044O003300025O00202O00020002002D4O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O000100852O013O0004CF3O00852O012O0060000100063O00122D0002002F3O00122D000300304O002E000100034O009F00015O00122D3O00313O00261F3O00D92O0100010004CF3O00D92O012O0060000100074O0060000200083O00067C000100A82O0100020004CF3O00A82O012O0060000100143O000607000100A82O013O0004CF3O00A82O012O006000015O0020C500010001003200209E0001000100142O0065000100020002000607000100A82O013O0004CF3O00A82O012O0060000100153O000E24000200A82O0100010004CF3O00A82O012O0060000100044O003300025O00202O0002000200324O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O000100A82O013O0004CF3O00A82O012O0060000100063O00122D000200333O00122D000300344O002E000100034O009F00016O006000015O0020C500010001003500209E0001000100042O0065000100020002000607000100C22O013O0004CF3O00C22O012O0060000100033O0020090001000100194O00035O00202O0003000300364O00010003000200062O000100C22O013O0004CF3O00C22O012O0060000100044O004E00025O00202O0002000200354O000300056O000300036O00010003000200062O000100C22O013O0004CF3O00C22O012O0060000100063O00122D000200373O00122D000300384O002E000100034O009F00016O006000015O0020C500010001003900209E0001000100042O0065000100020002000607000100D82O013O0004CF3O00D82O012O0060000100163O000607000100D82O013O0004CF3O00D82O012O0060000100044O004E00025O00202O0002000200394O000300056O000300036O00010003000200062O000100D82O013O0004CF3O00D82O012O0060000100063O00122D0002003A3O00122D0003003B4O002E000100034O009F00015O00122D3O00023O00261F3O00380201003C0004CF3O003802012O006000015O0020C500010001003D00209E0001000100042O0065000100020002000607000100FE2O013O0004CF3O00FE2O012O0060000100173O000607000100FE2O013O0004CF3O00FE2O012O0060000100033O00206E00010001003E00122O0003003F3O00122O000400256O00010004000200062O000100FE2O013O0004CF3O00FE2O012O006000015O0020C500010001004000209E0001000100092O0065000100020002000611000100FE2O0100010004CF3O00FE2O012O0060000100044O004E00025O00202O00020002003D4O000300056O000300036O00010003000200062O000100FE2O013O0004CF3O00FE2O012O0060000100063O00122D000200413O00122D000300424O002E000100034O009F00016O0060000100074O0060000200083O00067C00010021020100020004CF3O002102012O0060000100183O0006070001002102013O0004CF3O002102012O0060000100193O0006070001000B02013O0004CF3O000B02012O00600001000B3O0006110001000E020100010004CF3O000E02012O0060000100193O00061100010021020100010004CF3O002102012O006000015O0020C500010001004300209E0001000100142O00650001000200020006070001002102013O0004CF3O002102012O0060000100044O004E00025O00202O0002000200434O000300056O000300036O00010003000200062O0001002102013O0004CF3O002102012O0060000100063O00122D000200443O00122D000300454O002E000100034O009F00016O006000015O0020C500010001003D00209E0001000100042O00650001000200020006070001003702013O0004CF3O003702012O0060000100173O0006070001003702013O0004CF3O003702012O0060000100044O004E00025O00202O00020002003D4O000300056O000300036O00010003000200062O0001003702013O0004CF3O003702012O0060000100063O00122D000200463O00122D000300474O002E000100034O009F00015O00122D3O00483O000E9A004900C202013O0004CF3O00C202012O006000015O0020C500010001004A00209E0001000100142O00650001000200020006070001005E02013O0004CF3O005E02012O00600001001A3O0006070001005E02013O0004CF3O005E02012O006000015O0020C500010001004B00209E0001000100092O00650001000200020006110001004E020100010004CF3O004E02012O0060000100023O00209E00010001004C2O00650001000200020006070001005E02013O0004CF3O005E02012O0060000100044O003300025O00202O00020002004A4O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O0001005E02013O0004CF3O005E02012O0060000100063O00122D0002004D3O00122D0003004E4O002E000100034O009F00016O006000015O0020C500010001004F00209E0001000100042O00650001000200020006070001008D02013O0004CF3O008D02012O00600001001B3O0006070001008D02013O0004CF3O008D02012O006000015O0020C500010001005000209E0001000100092O00650001000200020006070001008D02013O0004CF3O008D02012O006000015O0020C500010001002700209E0001000100092O00650001000200020006070001008D02013O0004CF3O008D02012O006000015O00203200010001000C00202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200202O00020002005100062O0002008D020100010004CF3O008D02012O0060000100044O003300025O00202O00020002004F4O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O0001008D02013O0004CF3O008D02012O0060000100063O00122D000200523O00122D000300534O002E000100034O009F00016O006000015O0020C500010001005400209E0001000100142O0065000100020002000607000100C102013O0004CF3O00C102012O00600001001C3O000607000100C102013O0004CF3O00C102012O006000015O0020C500010001005400209E0001000100552O006500010002000200261F000100AE020100250004CF3O00AE02012O006000015O0020C500010001005600209E0001000100092O0065000100020002000611000100AE020100010004CF3O00AE02012O0060000100023O0020EC00010001000D4O00035O00202O00030003000E4O00010003000200062O000100B4020100010004CF3O00B402012O0060000100033O00209E0001000100162O0065000100020002002O26000100B4020100570004CF3O00B402012O006000015O0020C500010001005600209E0001000100092O0065000100020002000607000100C102013O0004CF3O00C102012O0060000100044O004E00025O00202O0002000200544O000300056O000300036O00010003000200062O000100C102013O0004CF3O00C102012O0060000100063O00122D000200583O00122D000300594O002E000100034O009F00015O00122D3O005A3O00261F3O00660301005A0004CF3O006603012O006000015O0020C500010001005B00209E0001000100042O00650001000200020006070001000703013O0004CF3O000703012O00600001001D3O0006070001000703013O0004CF3O000703012O006000015O0020C500010001004000209E0001000100092O0065000100020002000607000100E502013O0004CF3O00E502012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O000100E502013O0004CF3O00E502012O0060000100033O00209E00010001005C2O0065000100020002000EA0005D00E5020100010004CF3O00E502012O006000015O0020C500010001002700209E0001000100092O0065000100020002000611000100EB020100010004CF3O00EB02012O006000015O0020C500010001005E00209E0001000100092O00650001000200020006070001000703013O0004CF3O000703012O006000015O0020C500010001005F00209E0001000100092O0065000100020002000607000100FA02013O0004CF3O00FA02012O006000015O0020C500010001005F00209E0001000100092O00650001000200020006070001000703013O0004CF3O000703012O0060000100153O00261F00010007030100020004CF3O000703012O0060000100044O004E00025O00202O00020002005B4O000300056O000300036O00010003000200062O0001000703013O0004CF3O000703012O0060000100063O00122D000200603O00122D000300614O002E000100034O009F00016O006000015O0020C500010001004F00209E0001000100042O00650001000200020006070001002F03013O0004CF3O002F03012O00600001001B3O0006070001002F03013O0004CF3O002F03012O006000015O0020C500010001005000209E0001000100092O00650001000200020006110001001F030100010004CF3O001F03012O006000015O0020C500010001005F00209E0001000100092O00650001000200020006070001002F03013O0004CF3O002F03012O0060000100153O000E240002002F030100010004CF3O002F03012O0060000100044O003300025O00202O00020002004F4O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O0001002F03013O0004CF3O002F03012O0060000100063O00122D000200623O00122D000300634O002E000100034O009F00016O006000015O0020C500010001005B00209E0001000100042O00650001000200020006070001006503013O0004CF3O006503012O00600001001D3O0006070001006503013O0004CF3O006503012O006000015O0020C500010001004000209E0001000100092O006500010002000200061100010049030100010004CF3O004903012O006000015O0020C500010001004000209E0001000100092O006500010002000200061100010065030100010004CF3O006503012O0060000100033O00209E00010001005C2O0065000100020002000EA000640065030100010004CF3O006503012O006000015O0020C500010001005F00209E0001000100092O00650001000200020006070001005803013O0004CF3O005803012O006000015O0020C500010001005F00209E0001000100092O00650001000200020006070001006503013O0004CF3O006503012O0060000100153O00261F00010065030100020004CF3O006503012O0060000100044O004E00025O00202O00020002005B4O000300056O000300036O00010003000200062O0001006503013O0004CF3O006503012O0060000100063O00122D000200653O00122D000300664O002E000100034O009F00015O00122D3O00513O00261F3O008C030100480004CF3O008C03012O006000015O0020C500010001000300209E0001000100042O00650001000200020006070001003C05013O0004CF3O003C05012O0060000100013O0006070001003C05013O0004CF3O003C05012O0060000100023O0020090001000100674O00035O00202O0003000300064O00010003000200062O0001003C05013O0004CF3O003C05012O006000015O0020C500010001004000209E0001000100092O00650001000200020006110001003C050100010004CF3O003C05012O0060000100044O004E00025O00202O0002000200034O000300056O000300036O00010003000200062O0001003C05013O0004CF3O003C05012O0060000100063O001248000200683O00122O000300696O000100036O00015O00044O003C0501000E9A0025001804013O0004CF3O001804012O0060000100074O0060000200083O00067C000100CE030100020004CF3O00CE03012O00600001000C3O000607000100CE03013O0004CF3O00CE03012O00600001000D3O0006070001009B03013O0004CF3O009B03012O00600001000B3O0006110001009E030100010004CF3O009E03012O00600001000D3O000611000100CE030100010004CF3O00CE03012O00600001000E4O008C000200063O00122O0003006A3O00122O0004006B6O00020004000200062O000100CE030100020004CF3O00CE03012O006000015O0020C500010001001F00209E0001000100142O0065000100020002000607000100CE03013O0004CF3O00CE03012O006000015O0020F500010001000C00202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O0001000A000100020004CF3O00BD03012O006000015O00200400010001002000202O00010001000B4O0001000200024O000200033O00202O0002000200074O00020002000200062O000100CE030100020004CF3O00CE03012O0060000100044O00720002000F3O00202O00020002006C4O000300023O00202O0003000300224O00055O00202O00050005001F4O0003000500024O000300036O00010003000200062O000100CE03013O0004CF3O00CE03012O0060000100063O00122D0002006D3O00122D0003006E4O002E000100034O009F00016O0060000100074O0060000200083O00067C000100F4030100020004CF3O00F403012O00600001001E3O000607000100F403013O0004CF3O00F403012O00600001001F3O000607000100DB03013O0004CF3O00DB03012O00600001000B3O000611000100DE030100010004CF3O00DE03012O00600001001F3O000611000100F4030100010004CF3O00F403012O006000015O0020C500010001002000209E0001000100142O0065000100020002000607000100F403013O0004CF3O00F403012O0060000100044O009100025O00202O0002000200204O000300023O00202O00030003006F00122O0005003C6O0003000500024O000300036O00010003000200062O000100F403013O0004CF3O00F403012O0060000100063O00122D000200703O00122D000300714O002E000100034O009F00016O0060000100074O0060000200083O00067C00010017040100020004CF3O001704012O0060000100203O0006070001001704013O0004CF3O001704012O0060000100213O0006070001000104013O0004CF3O000104012O00600001000B3O0006110001002O040100010004CF3O002O04012O0060000100213O00061100010017040100010004CF3O001704012O006000015O0020C500010001000C00209E0001000100142O00650001000200020006070001001704013O0004CF3O001704012O0060000100044O004E00025O00202O00020002000C4O000300056O000300036O00010003000200062O0001001704013O0004CF3O001704012O0060000100063O00122D000200723O00122D000300734O002E000100034O009F00015O00122D3O00263O00261F3O008A040100510004CF3O008A04012O006000015O0020C500010001007400209E0001000100042O00650001000200020006070001003C04013O0004CF3O003C04012O0060000100223O0006070001003C04013O0004CF3O003C04012O006000015O0020C500010001005600209E0001000100092O00650001000200020006070001003C04013O0004CF3O003C04012O006000015O0020C500010001007500209E0001000100092O00650001000200020006070001003C04013O0004CF3O003C04012O0060000100044O004E00025O00202O0002000200744O000300056O000300036O00010003000200062O0001003C04013O0004CF3O003C04012O0060000100063O00122D000200763O00122D000300774O002E000100034O009F00016O006000015O0020C500010001005400209E0001000100142O00650001000200020006070001006904013O0004CF3O006904012O00600001001C3O0006070001006904013O0004CF3O006904012O0060000100023O0020090001000100784O00035O00202O00030003000E4O00010003000200062O0001005704013O0004CF3O005704012O0060000100033O00209E0001000100162O006500010002000200262200010057040100790004CF3O005704012O006000015O0020C500010001005600209E0001000100092O00650001000200020006070001005C04013O0004CF3O005C04012O0060000100033O00209E0001000100162O006500010002000200262200010069040100570004CF3O006904012O0060000100044O004E00025O00202O0002000200544O000300056O000300036O00010003000200062O0001006904013O0004CF3O006904012O0060000100063O00122D0002007A3O00122D0003007B4O002E000100034O009F00016O006000015O0020C500010001004F00209E0001000100042O00650001000200020006070001008904013O0004CF3O008904012O00600001001B3O0006070001008904013O0004CF3O008904012O0060000100033O0020090001000100194O00035O00202O00030003007C4O00010003000200062O0001008904013O0004CF3O008904012O0060000100044O009100025O00202O00020002004F4O000300023O00202O00030003006F00122O0005003C6O0003000500024O000300036O00010003000200062O0001008904013O0004CF3O008904012O0060000100063O00122D0002007D3O00122D0003007E4O002E000100034O009F00015O00122D3O003C3O00261F3O0001000100310004CF3O000100012O006000015O0020C500010001004F00209E0001000100042O0065000100020002000607000100BD04013O0004CF3O00BD04012O00600001001B3O000607000100BD04013O0004CF3O00BD04012O006000015O0020C500010001005000209E0001000100092O0065000100020002000607000100BD04013O0004CF3O00BD04012O006000015O0020C500010001002700209E0001000100092O0065000100020002000607000100BD04013O0004CF3O00BD04012O0060000100033O00209E0001000100162O0065000100020002000E24007F00BD040100010004CF3O00BD04012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O000100BD04013O0004CF3O00BD04012O0060000100044O003300025O00202O00020002004F4O000300023O00202O00030003002E4O000500136O0003000500024O000300036O00010003000200062O000100BD04013O0004CF3O00BD04012O0060000100063O00122D000200803O00122D000300814O002E000100034O009F00016O006000015O0020C500010001007400209E0001000100042O0065000100020002000607000100E304013O0004CF3O00E304012O0060000100223O000607000100E304013O0004CF3O00E304012O0060000100023O00208F0001000100054O00035O00202O0003000300064O0001000300024O000200033O00202O0002000200074O00020002000200062O000100E3040100020004CF3O00E304012O006000015O0020C500010001000800209E0001000100092O0065000100020002000611000100E3040100010004CF3O00E304012O0060000100044O004E00025O00202O0002000200744O000300056O000300036O00010003000200062O000100E304013O0004CF3O00E304012O0060000100063O00122D000200823O00122D000300834O002E000100034O009F00016O0060000100074O0060000200083O00067C0001003A050100020004CF3O003A05012O0060000100183O0006070001003A05013O0004CF3O003A05012O0060000100193O000607000100F004013O0004CF3O00F004012O00600001000B3O000611000100F3040100010004CF3O00F304012O0060000100193O0006110001003A050100010004CF3O003A05012O006000015O0020C500010001004300209E0001000100142O00650001000200020006070001003A05013O0004CF3O003A05012O006000015O0020C500010001008400209E0001000100092O00650001000200020006070001001305013O0004CF3O001305012O0060000100033O0020EC0001000100194O00035O00202O00030003001A4O00010003000200062O0001002D050100010004CF3O002D05012O006000015O0020C500010001002700209E0001000100092O006500010002000200061100010013050100010004CF3O001305012O0060000100023O0020EC00010001000D4O00035O00202O00030003000E4O00010003000200062O0001002D050100010004CF3O002D05012O006000015O0020C500010001008500209E0001000100092O00650001000200020006070001003A05013O0004CF3O003A05012O0060000100033O0020EC0001000100194O00035O00202O00030003001A4O00010003000200062O0001002D050100010004CF3O002D05012O006000015O0020C500010001002700209E0001000100092O00650001000200020006110001003A050100010004CF3O003A05012O0060000100023O00200900010001000D4O00035O00202O00030003000E4O00010003000200062O0001003A05013O0004CF3O003A05012O0060000100044O004E00025O00202O0002000200434O000300056O000300036O00010003000200062O0001003A05013O0004CF3O003A05012O0060000100063O00122D000200863O00122D000300874O002E000100034O009F00015O00122D3O00493O0004CF3O000100012O00B43O00017O000D3O00028O00030F3O00412O66656374696E67436F6D626174030C3O0042612O746C655374616E6365030A3O0049734361737461626C6503083O0042752O66446F776E030D3O0001C763580FC3485F17C7794F0603043O002C63A617030B3O0042612O746C6553686F7574030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E6703163O007EF63D223FA143E4213926B03CE73B3330AB71F5282203063O00C41C97495653030D3O00546172676574497356616C696400663O00122D3O00013O00261F3O0001000100010004CF3O000100012O006000015O00209E0001000100022O006500010002000200061100010049000100010004CF3O0049000100122D000100013O00261F00010009000100010004CF3O000900012O0060000200013O0020C500020002000300209E0002000200042O00650002000200020006070002002400013O0004CF3O002400012O006000025O0020620002000200054O000400013O00202O0004000400034O000500016O00020005000200062O0002002400013O0004CF3O002400012O0060000200024O0060000300013O0020C50003000300032O00650002000200020006070002002400013O0004CF3O002400012O0060000200033O00122D000300063O00122D000400074O002E000200044O009F00026O0060000200013O0020C500020002000800209E0002000200042O00650002000200020006070002004900013O0004CF3O004900012O0060000200043O0006070002004900013O0004CF3O004900012O006000025O0020A20002000200054O000400013O00202O0004000400094O000500016O00020005000200062O0002003C000100010004CF3O003C00012O0060000200053O0020F100020002000A4O000300013O00202O0003000300094O00020002000200062O0002004900013O0004CF3O004900012O0060000200024O0060000300013O0020C50003000300082O00650002000200020006070002004900013O0004CF3O004900012O0060000200033O0012480003000B3O00122O0004000C6O000200046O00025O00044O004900010004CF3O000900012O0060000100053O0020C500010001000D2O00D10001000100020006070001006500013O0004CF3O006500012O0060000100063O0006070001006500013O0004CF3O006500012O006000015O00209E0001000100022O006500010002000200061100010065000100010004CF3O0065000100122D000100013O00261F00010057000100010004CF3O005700012O0060000200084O00D10002000100022O0005010200074O0060000200073O0006070002006500013O0004CF3O006500012O0060000200074O00AD000200023O0004CF3O006500010004CF3O005700010004CF3O006500010004CF3O000100012O00B43O00017O004C3O00028O00026O00F03F03113O0048616E646C65496E636F72706F7265616C03093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O00344003113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O002040030D3O00546172676574497356616C6964026O001040030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O00C422002403083O001693634970E2387803133O00576169742F502O6F6C205265736F7572636573027O0040030B3O004865726F69635468726F77030A3O0049734361737461626C6503093O004973496E52616E6765026O003E4003113O00B070F0FA84BB4AF6FD9FB762A2F88CB17B03053O00EDD8158295030D3O00577265636B696E675468726F77030F3O00412O66656374696E67436F6D62617403133O00955C5A5CBBC05085714B57A2C649C2435E56BE03073O003EE22E2O3FD0A9026O00084003063O00436861726765030E3O0049735370652O6C496E52616E6765030E3O00E611549118086F53E4105BC34C5903083O003E857935E37F6D4F03103O004865616C746850657263656E74616765030B3O00566963746F72795275736803073O004973526561647903113O00061D31E1D9BCBB2F0627E6DEEEAA2O153E03073O00C270745295B6CE03103O00496D70656E64696E67566963746F727903163O0030A55C1DCEE60737AF730EC9E11A36BA5558C8E70F3503073O006E59C82C78A082030F3O0048616E646C65445053506F74696F6E03083O00446562752O66557003133O00436F6C6F2O737573536D617368446562752O6603093O00426C2O6F644675727903123O00A9CF444947753D58B9DA0B4B4243350DF89A03083O002DCBA32B26232A5B030A3O004265727365726B696E67030D3O00446562752O6652656D61696E73026O00184003123O00D080CE3082BB5FDB8BDB638AA85DDCC5887303073O0034B2E5BC43E7C9030D3O00417263616E65546F2O72656E74030C3O004D6F7274616C537472696B65030F3O00432O6F6C646F776E52656D61696E73026O00F83F03043O0052616765026O00494003163O00202O5305F9591C354E4216F25237614C510DF91C777003073O004341213064973C030E3O004C69676874734A7564676D656E74030A3O00446562752O66446F776E030A3O00432O6F6C646F776E557003173O00D3EEA9D0E7CCD8A4CDF7D8EAABD6E79FEAAFD1FD9FB3FC03053O0093BF87CEB803093O0046697265626C2O6F6403113O008221B4C4DA5FBD8B2CE6CCD95ABCC47CF503073O00D2E448C6A1B833030D3O00416E6365737472616C43612O6C03163O003747F01560DA2448FF2F70CF3A45B31D72C73809A74403063O00AE5629937013030B3O004261676F66547269636B7303153O0059018A342A092EBF49098E00364F1CAA520ECD5A7503083O00CB3B60ED6B456F7103083O004D612O7361637265030B3O004973417661696C61626C65025O00804140003F022O00122D3O00013O00261F3O000C000100010004CF3O000C00012O0060000100014O00D10001000100022O00052O016O006000015O0006070001000B00013O0004CF3O000B00012O006000016O00AD000100023O00122D3O00023O00261F3O0001000100020004CF3O000100012O0060000100023O0006070001003700013O0004CF3O0037000100122D000100013O00261F00010024000100010004CF3O002400012O0060000200033O0020830002000200034O000300043O00202O0003000300044O000400053O00202O00040004000500122O000500066O000600016O0002000600024O00028O00025O0006070002002300013O0004CF3O002300012O006000026O00AD000200023O00122D000100023O00261F00010012000100020004CF3O001200012O0060000200033O0020830002000200034O000300043O00202O0003000300074O000400053O00202O00040004000800122O000500096O000600016O0002000600024O00028O00025O0006070002003700013O0004CF3O003700012O006000026O00AD000200023O0004CF3O003700010004CF3O001200012O0060000100033O0020C500010001000A2O00D10001000100020006070001003E02013O0004CF3O003E020100122D000100014O00FA000200023O00261F0001004F0001000B0004CF3O004F00012O0060000300063O00205E00030003000C4O000400043O00202O00040004000D4O00058O000600073O00122O0007000E3O00122O0008000F6O000600086O00033O000200062O0003003E02013O0004CF3O003E020100122D000300104O00AD000300023O0004CF3O003E020100261F000100A6000100110004CF3O00A600012O0060000300083O0006070003007000013O0004CF3O007000012O0060000300043O0020C500030003001200209E0003000300132O00650003000200020006070003007000013O0004CF3O007000012O0060000300093O00209E00030003001400122D000500154O00B900030005000200061100030070000100010004CF3O007000012O00600003000A4O0091000400043O00202O0004000400124O000500093O00202O00050005001400122O000700156O0005000700024O000500056O00030005000200062O0003007000013O0004CF3O007000012O0060000300073O00122D000400163O00122D000500174O002E000300054O009F00036O0060000300043O0020C500030003001800209E0003000300132O00650003000200020006070003009200013O0004CF3O009200012O00600003000B3O0006070003009200013O0004CF3O009200012O0060000300093O00209E0003000300192O00650003000200020006070003009200013O0004CF3O009200012O00600003000C4O00D10003000100020006070003009200013O0004CF3O009200012O00600003000A4O0091000400043O00202O0004000400184O000500093O00202O00050005001400122O000700156O0005000700024O000500056O00030005000200062O0003009200013O0004CF3O009200012O0060000300073O00122D0004001A3O00122D0005001B4O002E000300054O009F00036O00600003000D3O000607000300A500013O0004CF3O00A500012O00600003000E3O000E24001100A5000100030004CF3O00A5000100122D000300013O00261F00030099000100010004CF3O009900012O00600004000F4O00D10004000100022O000501046O006000045O000607000400A500013O0004CF3O00A500012O006000046O00AD000400023O0004CF3O00A500010004CF3O0099000100122D0001001C3O00261F000100062O0100010004CF3O00062O012O0060000300103O000607000300C500013O0004CF3O00C500012O0060000300043O0020C500030003001D00209E0003000300132O0065000300020002000607000300C500013O0004CF3O00C500012O0060000300113O000611000300C5000100010004CF3O00C500012O00600003000A4O0072000400043O00202O00040004001D4O000500093O00202O00050005001E4O000700043O00202O00070007001D4O0005000700024O000500056O00030005000200062O000300C500013O0004CF3O00C500012O0060000300073O00122D0004001F3O00122D000500204O002E000300054O009F00036O0060000300123O00209E0003000300212O00650003000200022O0060000400133O00067C000300FC000100040004CF3O00FC000100122D000300013O00261F000300CC000100010004CF3O00CC00012O0060000400043O0020C500040004002200209E0004000400232O0065000400020002000607000400E400013O0004CF3O00E400012O0060000400143O000607000400E400013O0004CF3O00E400012O00600004000A4O004E000500043O00202O0005000500224O000600116O000600066O00040006000200062O000400E400013O0004CF3O00E400012O0060000400073O00122D000500243O00122D000600254O002E000400064O009F00046O0060000400043O0020C500040004002600209E0004000400232O0065000400020002000607000400FC00013O0004CF3O00FC00012O0060000400143O000607000400FC00013O0004CF3O00FC00012O00600004000A4O004E000500043O00202O0005000500264O000600116O000600066O00040006000200062O000400FC00013O0004CF3O00FC00012O0060000400073O001248000500273O00122O000600286O000400066O00045O00044O00FC00010004CF3O00CC00012O0060000300033O0020A80003000300294O000400093O00202O00040004002A4O000600043O00202O00060006002B4O000400066O00033O00024O000200033O00122O000100023O00261F00010013020100020004CF3O001302010006070002000B2O013O0004CF3O000B2O012O00AD000200024O0060000300113O000607000300F52O013O0004CF3O00F52O012O0060000300153O000607000300F52O013O0004CF3O00F52O012O0060000300163O000607000300172O013O0004CF3O00172O012O0060000300173O0006110003001A2O0100010004CF3O001A2O012O0060000300163O000611000300F52O0100010004CF3O00F52O012O0060000300184O0060000400193O00067C000300F52O0100040004CF3O00F52O0100122D000300013O00261F000300522O0100010004CF3O00522O012O0060000400043O0020C500040004002C00209E0004000400132O0065000400020002000607000400392O013O0004CF3O00392O012O0060000400093O00200900040004002A4O000600043O00202O00060006002B4O00040006000200062O000400392O013O0004CF3O00392O012O00600004000A4O0060000500043O0020C500050005002C2O0065000400020002000607000400392O013O0004CF3O00392O012O0060000400073O00122D0005002D3O00122D0006002E4O002E000400064O009F00046O0060000400043O0020C500040004002F00209E0004000400132O0065000400020002000607000400512O013O0004CF3O00512O012O0060000400093O0020E10004000400304O000600043O00202O00060006002B4O000400060002000E2O003100512O0100040004CF3O00512O012O00600004000A4O0060000500043O0020C500050005002F2O0065000400020002000607000400512O013O0004CF3O00512O012O0060000400073O00122D000500323O00122D000600334O002E000400064O009F00045O00122D000300023O00261F0003009A2O0100020004CF3O009A2O012O0060000400043O0020C500040004003400209E0004000400132O0065000400020002000607000400752O013O0004CF3O00752O012O0060000400043O0020C500040004003500209E0004000400362O0065000400020002000E24003700752O0100040004CF3O00752O012O0060000400123O00209E0004000400382O0065000400020002002622000400752O0100390004CF3O00752O012O00600004000A4O0091000500043O00202O0005000500344O000600093O00202O00060006001400122O000800096O0006000800024O000600066O00040006000200062O000400752O013O0004CF3O00752O012O0060000400073O00122D0005003A3O00122D0006003B4O002E000400064O009F00046O0060000400043O0020C500040004003C00209E0004000400132O0065000400020002000607000400992O013O0004CF3O00992O012O0060000400093O00200900040004003D4O000600043O00202O00060006002B4O00040006000200062O000400992O013O0004CF3O00992O012O0060000400043O0020C500040004003500209E00040004003E2O0065000400020002000611000400992O0100010004CF3O00992O012O00600004000A4O0072000500043O00202O00050005003C4O000600093O00202O00060006001E4O000800043O00202O00080008003C4O0006000800024O000600066O00040006000200062O000400992O013O0004CF3O00992O012O0060000400073O00122D0005003F3O00122D000600404O002E000400064O009F00045O00122D000300113O00261F000300CD2O0100110004CF3O00CD2O012O0060000400043O0020C500040004004100209E0004000400132O0065000400020002000607000400B42O013O0004CF3O00B42O012O0060000400093O00200900040004002A4O000600043O00202O00060006002B4O00040006000200062O000400B42O013O0004CF3O00B42O012O00600004000A4O0060000500043O0020C50005000500412O0065000400020002000607000400B42O013O0004CF3O00B42O012O0060000400073O00122D000500423O00122D000600434O002E000400064O009F00046O0060000400043O0020C500040004004400209E0004000400132O0065000400020002000607000400CC2O013O0004CF3O00CC2O012O0060000400093O00200900040004002A4O000600043O00202O00060006002B4O00040006000200062O000400CC2O013O0004CF3O00CC2O012O00600004000A4O0060000500043O0020C50005000500442O0065000400020002000607000400CC2O013O0004CF3O00CC2O012O0060000400073O00122D000500453O00122D000600464O002E000400064O009F00045O00122D0003001C3O00261F0003001F2O01001C0004CF3O001F2O012O0060000400043O0020C500040004004700209E0004000400132O0065000400020002000607000400F52O013O0004CF3O00F52O012O0060000400093O00200900040004003D4O000600043O00202O00060006002B4O00040006000200062O000400F52O013O0004CF3O00F52O012O0060000400043O0020C500040004003500209E00040004003E2O0065000400020002000611000400F52O0100010004CF3O00F52O012O00600004000A4O0072000500043O00202O0005000500474O000600093O00202O00060006001E4O000800043O00202O0008000800474O0006000800024O000600066O00040006000200062O000400F52O013O0004CF3O00F52O012O0060000400073O001248000500483O00122O000600496O000400066O00045O00044O00F52O010004CF3O001F2O012O0060000300184O0060000400193O00067C00030012020100040004CF3O001202012O00600003001A3O0006070003001202013O0004CF3O001202012O0060000300173O0006070003002O02013O0004CF3O002O02012O00600003001B3O00061100030005020100010004CF3O000502012O00600003001B3O00061100030012020100010004CF3O0012020100122D000300013O00261F00030006020100010004CF3O000602012O00600004001C4O00D10004000100022O000501046O006000045O0006070004001202013O0004CF3O001202012O006000046O00AD000400023O0004CF3O001202010004CF3O0006020100122D000100113O00261F0001003E0001001C0004CF3O003E00012O0060000300043O0020C500030003004A00209E00030003004B2O00650003000200020006070003002002013O0004CF3O002002012O0060000300093O00209E0003000300212O0065000300020002002O26000300250201004C0004CF3O002502012O0060000300093O00209E0003000300212O006500030002000200262200030032020100060004CF3O0032020100122D000300013O00261F00030026020100010004CF3O002602012O00600004001D4O00D10004000100022O000501046O006000045O0006070004003202013O0004CF3O003202012O006000046O00AD000400023O0004CF3O003202010004CF3O002602012O00600003001E4O00D10003000100022O000501036O006000035O0006070003003A02013O0004CF3O003A02012O006000036O00AD000300023O00122D0001000B3O0004CF3O003E00010004CF3O003E02010004CF3O000100012O00B43O00017O00413O00028O00027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030C3O003105A9CE27F5C53419BBE42303073O00B74476CC81519003073O001BBE75D60E8C0A03063O00E26ECD10846B030C3O00FED0E5EA49E4C0EBCE40FDC603053O00218BA380B9026O000840030E3O00424B01FC564C10D2526B0CD1424C03043O00BE37386403093O0043BC393D1BE2E151AA03073O009336CF5C7E738303093O001822305E017B0C273003063O001E6D51551D6D026O00F03F026O00184003113O00EA62518526DBFDED5E529437CDE8F67E5A03073O009C9F1134D656BE03113O00BBFCB888A6FAB3B8ABFDB2A9BDDDB2BDBC03043O00DCCE8FDD030D3O00936E2820D9DED094782C1CDDDE03073O00B2E61D4D77B8AC026O001C40030A3O00E0AD0F3E6FFDF6AB2O1E03063O009895DE6A7B17030E3O00C835F36BB0CF29FF4081D534F95403053O00D5BD469623030F3O005A467125404760094366601A465E7103043O00682F3514030C3O00A25A8008BD1D944595149F2B03063O006FC32CE17CDC03103O00DA4A0177AEB8CC49127E9CA2CC4E235703063O00CBB8266013CB03133O003A7C754EDD2A666A72C338607176C72D7B5A6503053O00AE59131921026O002040026O00144003093O003A01576FE1861F2E0003073O006B4F72322E97E7030D3O002CB5B00B8638B3C52AB2BA3B8703083O00A059C6D549EA59D703103O005D62B1DDCA447EA7EDD05B42B9FFD64003053O00A52811D49E026O001040030E3O00F0CA0D072EF0D70C3634C6D5092303053O004685B96853030C3O001156411DC10D57483DC00A4103053O00A96425244A03103O001594A7671282A15B0989A5640895AD4703043O003060E7C203103O00DD490B1E12CDA38FDB4A02240DCCAA9103083O00E3A83A6E4D79B8CF03073O006E2FBA73BDDA7C03083O00C51B5CDF20D1BB1103123O00164CC6C8145AC6EB0A51C4C8174DCAF0064C03043O009B633FA303143O0091C1A48C2OAB84F3A09EAD2O8DDF9684AD8CA1F503063O00E4E2B1C1EDD903143O0020B836E830B531E921A311E935A214EF20B800C203043O008654D04303103O0004AD945E01A9875716BEB15507A4A57803043O003C73CCE600F63O00122D3O00013O00261F3O001C000100020004CF3O001C000100123B000100033O0020DD0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00124O000B3O000E9A0001003700013O0004CF3O0037000100123B000100033O0020DD0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00124O00123O00261F3O0052000100130004CF3O0052000100123B000100033O0020DD0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00124O001A3O00261F3O006D000100120004CF3O006D000100123B000100033O0020DD0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00124O00023O000E9A001A008800013O0004CF3O0088000100123B000100033O0020DD0001000100044O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00124O00273O00261F3O00A3000100280004CF3O00A3000100123B000100033O0020DD0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100123O00124O00133O00261F3O00BE0001002F0004CF3O00BE000100123B000100033O0020DD0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100143O00122O000100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100153O00124O00283O00261F3O00D90001000B0004CF3O00D9000100123B000100033O0020DD0001000100044O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100173O00122O000100033O00202O0001000100044O000200013O00122O0003003A3O00122O0004003B6O0002000400024O0001000100024O000100183O00124O002F3O000E9A0027000100013O0004CF3O0001000100123B000100033O0020460001000100044O000200013O00122O0003003C3O00122O0004003D6O0002000400024O0001000100024O000100193O00122O000100033O00202O0001000100044O000200013O00122O0003003E3O00122O0004003F6O0002000400024O0001000100024O0001001A3O00122O000100033O00202O0001000100044O000200013O00122O000300403O00122O000400416O0002000400024O0001000100024O0001001B3O00044O00F500010004CF3O000100012O00B43O00017O00333O00028O00026O001840030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00F133E864E828F242F229E358D703043O0010875A8B030C3O00476403325C677D40600F3D4903073O0018341466532E3403063O00D423203D0AD603053O006FA44F4144027O0040030D3O00D3CA86F729E4C9CB86EE2FE3C803063O008AA6B9E3BE4E030C3O00DE67C01E5C371CD962C0395703073O0079AB14A5573243030E3O00D32BBC04B80ECA21B038BE21D42103063O0062A658D956D9026O00084003093O00E3E57C3193D1FBF37503063O00BC2O961961E6030C3O00CF9A5A3118E2C8847D0D00F903063O008DBAE93F626C03143O00E4F9299F2BE5E321BF21F0FE25B822C2E223A33103053O0045918A4CD6026O00F03F03113O0065DC8CABB60264CA9BA0B21B65C1809DA603063O007610AF2OE9DF03123O009E97309FEB8D7885973CADEBB8692O8A36BE03073O001DEBE455DB8EEB03103O0028C7BFF97E4B054B09DCBFEE6041355603083O00325DB4DABD172E47026O001040030A3O00CBAA485845D24BDB8C6B03073O0028BEC43B2C24BC030F3O00384CD996E349053976CBBBE879250C03073O006D5C25BCD49A1D030C3O000DE8AACC235F34EEADCD196A03063O003A648FC4A351026O001440030E3O000F512695364AF101085B11B62C4103083O006E7A2243C35F298503103O0077B84F5ED367985647C37BB84F53FE4503053O00B615D13B2A03113O00B352C3182FADBE41C02E35BFB954C0351103063O00DED737A57D41030B3O0025DFD21FE0D7E84429F9F603083O002A4CB1A67A92A18D03103O00B78B09C2607FAB8D26DC6051B78510DE03063O0016C5EA65AE19030D3O003F35A9D06FA6D9810E26BCF44603083O00E64D54C5BC16CFB700D93O00122D3O00013O000E9A0002001D00013O0004CF3O001D000100123B000100033O00208B0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004CF3O000D000100122D000100014O00052O015O00125B000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O00010001000200062O0001001B000100010004CF3O001B00012O0060000100013O00122D000200093O00122D0003000A4O00B90001000300022O00052O0100023O0004CF3O00D8000100261F3O00380001000B0004CF3O0038000100123B000100033O0020DD0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100053O00124O00123O00261F3O0053000100010004CF3O0053000100123B000100033O0020DD0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300173O00122O000400186O0002000400024O0001000100024O000100083O00124O00193O00261F3O006E000100190004CF3O006E000100123B000100033O0020DD0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000B3O00124O000B3O00261F3O0092000100200004CF3O0092000100123B000100033O00208B0001000100044O000200013O00122O000300213O00122O000400226O0002000400024O00010001000200062O0001007A000100010004CF3O007A000100122D000100014O00052O01000C3O00125B000100033O00202O0001000100044O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O00010085000100010004CF3O0085000100122D000100014O00052O01000D3O00125B000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O00010090000100010004CF3O0090000100122D000100014O00052O01000E3O00122D3O00273O00261F3O00B3000100120004CF3O00B3000100123B000100033O00202C0001000100044O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O00010001000200062O000100A6000100010004CF3O00A6000100122D000100014O00052O0100103O00125B000100033O00202O0001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100B1000100010004CF3O00B1000100122D000100014O00052O0100113O00122D3O00203O00261F3O0001000100270004CF3O0001000100123B000100033O00208B0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100BF000100010004CF3O00BF000100122D000100014O00052O0100123O00125B000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100CA000100010004CF3O00CA000100122D000100014O00052O0100133O00125B000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O00010001000200062O000100D5000100010004CF3O00D5000100122D000100014O00052O0100143O00122D3O00023O0004CF3O000100012O00B43O00017O00233O00028O00027O0040030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O00EC07C3D489A0FC21F107D2F382A403083O00559974A69CECC19003103O00B1F3489BE101A8E943B4D40FB0E942BD03063O0060C4802DD384030D3O003D887A53C62OA7CC3A837E77E203083O00B855ED1B3FB2CFD4030F4O005C085301570E6F074D005006713903043O003F683969026O00084003113O002382A5480289A3740493AD4B05A9A5490E03043O00246BE7C4034O0003113O0075B4AC8351B08B895EBAB097522OA7865103043O00E73DD5C203113O000FA43A7B1D9F387E08A433602AA538700203043O001369CD5D03113O008006CA842DBB1DCE9508A01CD6B22BBC0603053O005FC968BEE103163O0086C5D5CBBDD9D4DEBBE4CFC2B6FCC9C7BBCECDC7BCDF03043O00AECFABA103123O00C4F019F6EAC5F8EE19C7F0C5E8ED05FCF4D303063O00B78D9E6D9398026O00F03F030B3O00391AE3383E00E807291DF503043O006C4C6986030A3O00FED6B4D3CFE8CCB0EDDD03053O00AE8BA5D181030E3O00B7A1EBCFCD06646B94BAF6C9E52703083O0018C3D382A1A66310030D3O005402EA25521A5534E0385B356203063O00762663894C33008B3O00122D3O00013O000E9A0002002A00013O0004CF3O002A000100123B000100033O0020B10001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200062O0001001D000100010004CF3O001D000100122D000100014O00052O0100033O00125B000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O00010028000100010004CF3O0028000100122D000100014O00052O0100043O00122D3O000D3O00261F3O00400001000D0004CF3O0040000100123B000100033O00208B0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200062O00010036000100010004CF3O0036000100122D000100104O00052O0100053O001231000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00044O008A0001000E9A0001006600013O0004CF3O0066000100123B000100033O00208B0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O00010001000200062O0001004C000100010004CF3O004C000100122D000100014O00052O0100073O001268000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300173O00122O000400186O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O0001000A3O00124O001B3O00261F3O00010001001B0004CF3O0001000100123B000100033O0020A10001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000E3O00124O00023O00044O000100012O00B43O00017O00183O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00F2290603063O00409D466572692O033O0041A7A203053O007020C8C7832O033O002F544F03073O00424C303CD8A3CB027O0040026O000840030E3O004973496E4D656C2O6552616E6765030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D62617403103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E73030C3O0049734368612O6E656C696E67030D3O004973446561644F7247686F737403113O00496E74696D69646174696E6753686F7574030B3O004973417661696C61626C65026O00204003163O00476574456E656D696573496E4D656C2O6552616E6765009B3O00122D3O00013O000E9A0001000A00013O0004CF3O000A00012O006000016O00AC0001000100014O000100016O0001000100014O000100026O00010001000100124O00023O000E9A0002002500013O0004CF3O0025000100123B000100033O0020DD0001000100044O000200043O00122O000300053O00122O000400066O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200043O00122O000300073O00122O000400086O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200043O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100063O00124O000B3O00261F3O00750001000C0004CF3O007500012O0060000100083O00205000010001000D4O000300096O0001000300024O000100076O0001000A3O00202O00010001000E4O00010001000200062O00010036000100010004CF3O003600012O00600001000B3O00209E00010001000F2O00650001000200020006070001004F00013O0004CF3O004F000100122D000100013O000E9A00010042000100010004CF3O004200012O00600002000D3O0020930002000200104O000300036O000400016O0002000400024O0002000C6O0002000C6O0002000E3O00122O000100023O00261F00010037000100020004CF3O003700012O00600002000E3O00261F0002004F000100110004CF3O004F00012O00600002000D3O0020100002000200124O0003000F6O00048O0002000400024O0002000E3O00044O004F00010004CF3O003700012O00600001000B3O00209E0001000100132O00650001000200020006110001009A000100010004CF3O009A00012O00600001000B3O00209E00010001000F2O00650001000200020006070001006700013O0004CF3O0067000100122D000100013O000E9A0001005A000100010004CF3O005A00012O0060000200114O00D10002000100022O0005010200104O0060000200103O0006070002009A00013O0004CF3O009A00012O0060000200104O00AD000200023O0004CF3O009A00010004CF3O005A00010004CF3O009A000100122D000100013O00261F00010068000100010004CF3O006800012O0060000200124O00D10002000100022O0005010200104O0060000200103O0006070002009A00013O0004CF3O009A00012O0060000200104O00AD000200023O0004CF3O009A00010004CF3O006800010004CF3O009A000100261F3O00010001000B0004CF3O000100012O00600001000B3O00209E0001000100142O00650001000200020006070001007D00013O0004CF3O007D00012O00B43O00014O0060000100133O0020C500010001001500209E0001000100162O00650001000200020006070001008500013O0004CF3O0085000100122D000100174O00052O0100094O0060000100053O0006070001009600013O0004CF3O0096000100122D000100013O00261F00010089000100010004CF3O008900012O00600002000B3O0020970002000200184O000400096O0002000400024O0002000F6O0002000F6O000200026O000200143O00044O009800010004CF3O008900010004CF3O0098000100122D000100024O00052O0100143O00122D3O000C3O0004CF3O000100012O00B43O00017O00033O0003053O005072696E74032B3O009B9474E01FF925A89470FC4D8E26A3C65CE356CD6AFAB56CE34FC136AE837DB35DD764A2AD78FD5ADA2BF403073O0044DAE619933FAE00084O00557O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);
