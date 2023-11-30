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
				if (Enum <= 127) then
					if (Enum <= 63) then
						if (Enum <= 31) then
							if (Enum <= 15) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
												if (Stk[Inst[2]] < Inst[4]) then
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
										elseif (Enum > 2) then
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
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										if (Enum > 4) then
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
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
									elseif (Enum > 6) then
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 10) then
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
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									if (Enum > 12) then
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 14) then
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
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum > 16) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
										end
									end
								elseif (Enum <= 21) then
									if (Enum == 20) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 22) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
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
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum == 24) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum == 26) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
									end
								end
							elseif (Enum <= 29) then
								if (Enum == 28) then
									if (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum > 30) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
						elseif (Enum <= 47) then
							if (Enum <= 39) then
								if (Enum <= 35) then
									if (Enum <= 33) then
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 34) then
										if (Stk[Inst[2]] == Inst[4]) then
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
								elseif (Enum <= 37) then
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
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 38) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 43) then
								if (Enum <= 41) then
									if (Enum > 40) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
									end
								elseif (Enum == 42) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 45) then
								if (Enum > 44) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 46) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 55) then
							if (Enum <= 51) then
								if (Enum <= 49) then
									if (Enum == 48) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 50) then
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
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 53) then
								if (Enum > 52) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 54) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 57) then
								if (Enum > 56) then
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum == 58) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 61) then
							if (Enum == 60) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum == 62) then
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
						if (Enum <= 79) then
							if (Enum <= 71) then
								if (Enum <= 67) then
									if (Enum <= 65) then
										if (Enum > 64) then
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
									elseif (Enum > 66) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 69) then
									if (Enum == 68) then
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 70) then
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								else
									do
										return;
									end
								end
							elseif (Enum <= 75) then
								if (Enum <= 73) then
									if (Enum == 72) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 74) then
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
									Stk[Inst[2]]();
								end
							elseif (Enum <= 77) then
								if (Enum == 76) then
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
								elseif (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 78) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 87) then
							if (Enum <= 83) then
								if (Enum <= 81) then
									if (Enum > 80) then
										local B = Inst[3];
										local K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
									else
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 82) then
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
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 85) then
								if (Enum > 84) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								else
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum > 86) then
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
						elseif (Enum <= 91) then
							if (Enum <= 89) then
								if (Enum == 88) then
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
							elseif (Enum == 90) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
									if (Mvm[1] == 133) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 93) then
							if (Enum > 92) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
							else
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum > 94) then
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
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
					elseif (Enum <= 111) then
						if (Enum <= 103) then
							if (Enum <= 99) then
								if (Enum <= 97) then
									if (Enum > 96) then
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
								elseif (Enum > 98) then
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
							elseif (Enum <= 101) then
								if (Enum == 100) then
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
								else
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
							elseif (Enum == 102) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 107) then
							if (Enum <= 105) then
								if (Enum == 104) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 106) then
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
						elseif (Enum <= 109) then
							if (Enum == 108) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum > 110) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
						end
					elseif (Enum <= 119) then
						if (Enum <= 115) then
							if (Enum <= 113) then
								if (Enum == 112) then
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
							elseif (Enum == 114) then
								do
									return Stk[Inst[2]];
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
						elseif (Enum <= 117) then
							if (Enum == 116) then
								VIP = Inst[3];
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
						elseif (Enum > 118) then
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
					elseif (Enum <= 123) then
						if (Enum <= 121) then
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
						elseif (Enum > 122) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 125) then
						if (Enum > 124) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum > 126) then
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
					end
				elseif (Enum <= 191) then
					if (Enum <= 159) then
						if (Enum <= 143) then
							if (Enum <= 135) then
								if (Enum <= 131) then
									if (Enum <= 129) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 130) then
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
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									else
										local K;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return Stk[Inst[2]];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 133) then
									if (Enum > 132) then
										Stk[Inst[2]] = Stk[Inst[3]];
									else
										local A = Inst[2];
										Stk[A] = Stk[A]();
									end
								elseif (Enum > 134) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 139) then
								if (Enum <= 137) then
									if (Enum == 136) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 138) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 141) then
								if (Enum == 140) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum > 142) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 151) then
							if (Enum <= 147) then
								if (Enum <= 145) then
									if (Enum > 144) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 146) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 149) then
								if (Enum == 148) then
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
							elseif (Enum == 150) then
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
						elseif (Enum <= 155) then
							if (Enum <= 153) then
								if (Enum > 152) then
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
							elseif (Enum == 154) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 157) then
							if (Enum == 156) then
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
						elseif (Enum > 158) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 175) then
						if (Enum <= 167) then
							if (Enum <= 163) then
								if (Enum <= 161) then
									if (Enum > 160) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 162) then
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum <= 165) then
								if (Enum == 164) then
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
							elseif (Enum > 166) then
								Stk[Inst[2]] = #Stk[Inst[3]];
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
						elseif (Enum <= 171) then
							if (Enum <= 169) then
								if (Enum == 168) then
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
								else
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum == 170) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 173) then
							if (Enum == 172) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum > 174) then
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
					elseif (Enum <= 183) then
						if (Enum <= 179) then
							if (Enum <= 177) then
								if (Enum > 176) then
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
							elseif (Enum == 178) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 181) then
							if (Enum > 180) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 182) then
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
							do
								return Stk[Inst[2]]();
							end
						end
					elseif (Enum <= 187) then
						if (Enum <= 185) then
							if (Enum == 184) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 186) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 189) then
						if (Enum == 188) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum > 190) then
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
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					end
				elseif (Enum <= 223) then
					if (Enum <= 207) then
						if (Enum <= 199) then
							if (Enum <= 195) then
								if (Enum <= 193) then
									if (Enum > 192) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 194) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
							elseif (Enum <= 197) then
								if (Enum > 196) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum == 198) then
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							end
						elseif (Enum <= 203) then
							if (Enum <= 201) then
								if (Enum == 200) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 202) then
								Stk[Inst[2]] = Inst[3];
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 205) then
							if (Enum == 204) then
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
						elseif (Enum > 206) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 215) then
						if (Enum <= 211) then
							if (Enum <= 209) then
								if (Enum == 208) then
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
							elseif (Enum > 210) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 213) then
							if (Enum > 212) then
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
						elseif (Enum > 214) then
							local K;
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							B = Inst[3];
							K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
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
					elseif (Enum <= 219) then
						if (Enum <= 217) then
							if (Enum > 216) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							local A;
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 221) then
						if (Enum > 220) then
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
					elseif (Enum == 222) then
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
				elseif (Enum <= 239) then
					if (Enum <= 231) then
						if (Enum <= 227) then
							if (Enum <= 225) then
								if (Enum == 224) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 226) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 229) then
							if (Enum == 228) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 230) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						if (Enum <= 233) then
							if (Enum == 232) then
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
						elseif (Enum > 234) then
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
					elseif (Enum <= 237) then
						if (Enum == 236) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum == 238) then
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
					else
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
				elseif (Enum <= 247) then
					if (Enum <= 243) then
						if (Enum <= 241) then
							if (Enum == 240) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum == 242) then
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] < Inst[4]) then
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
					elseif (Enum <= 245) then
						if (Enum > 244) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 246) then
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
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						if (Enum == 248) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
						else
							Env[Inst[3]] = Stk[Inst[2]];
						end
					elseif (Enum > 250) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 253) then
					if (Enum == 252) then
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
						Stk[Inst[2]] = Inst[3] ~= 0;
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
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					end
				elseif (Enum <= 254) then
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
					if (Inst[2] == Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 255) then
					local B;
					local A;
					A = Inst[2];
					Stk[A] = Stk[A]();
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
					Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if (Inst[2] <= Inst[4]) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD99ED111DAC6C91AD6A9C20DD4D1CD24F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O000B5B37CD6E34EA21403BC76E21EE2B583BC74710E82744309B5D04FD03073O009C4E2B5EB53171002C3O00124O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004743O000A000100125F000300063O0020D800040003000700125F000500083O0020D800050005000900125F000600083O0020D800060006000A00065B00073O000100062O00853O00064O00858O00853O00044O00853O00014O00853O00024O00853O00053O0020D800080003000B0020D800090003000C2O006D000A5O00125F000B000D3O00065B000C0001000100022O00853O000A4O00853O000B4O0085000D00073O0012CA000E000E3O0012CA000F000F4O00FD000D000F000200065B000E0002000100012O00853O00074O00B2000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O006800025O00122O000300016O00045O00122O000500013O00042O0003002100012O001D00076O00DD000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004B60003000500012O001D000300054O0085000400024O008C000300044O00A900036O00473O00017O00023O00028O00026O00F03F011E3O0012CA000200014O00BE000300033O00262200020008000100020004743O000800012O0085000400034O001B00056O001300046O00A900045O002O0E00010002000100020004743O000200010012CA000400013O0026220004000F000100020004743O000F00010012CA000200023O0004743O000200010026220004000B000100010004743O000B00012O001D00056O0046000300053O0006990003001A000100010004743O001A00012O001D000500014O008500066O001B00076O001300056O00A900055O0012CA000400023O0004743O000B00010004743O000200012O00473O00017O00503O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A62030B3O0021BB9823E90DB5873ED70503053O00B962DAEB57030D3O00E83D34F2FFA4C52O33E7CAAFCF03063O00CAAB5C4786BE030D3O000AC03F9C1AD42B8F2CD2388D2D03043O00E849A14C03053O008BCB474E0D03053O007EDBB9223D03053O0021CF5D607103083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803073O002419B4260818AA03043O004B6776D903083O00E2427506A011C95103063O007EA7341074D92O033O00C63B2D03073O009CA84E40E0D47903073O0024E1A8C308E0B603043O00AE678EC503083O00733E5A2A3C51F65303073O009836483F58453E03043O00D6CBE15003043O003CB4A48E03063O00737472696E6703063O005E51172426F903073O0072383E6549478D031B3O00476574556E6974456D706F77657253746167654475726174696F6E028O00026O00F03F03063O009DFFD4CFBDFB03043O00A4D889BB030C3O00E2F434A1A3EC1DD3F238BDA803073O006BB28651D2C69E03063O001D188DCDAF2A03053O00CA586EE2A6030C3O00F31D87E4CFD11983E3C3CC0103053O00AAA36FE29703063O003426BD334B2503073O00497150D2582E57030C3O00B13EC801E2933ACC06EE8E2203053O0087E14CAD72030C3O0047657445717569706D656E74026O002A40026O002C40024O0080B3C54003103O005265676973746572466F724576656E7403183O002AC1992O898F983FDC8D999C908234D98793849C893DC89C03073O00C77A8DD8D0CCDD03143O009DF131C95DC492EF35D75DD892F83ED15ADA88F903063O0096CDBD70901803063O0053657441504C025O00F0964000E3013O0077000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0014000F00142O001D00155O001282001600223O00122O001700236O0015001700024O0015000F00154O00165O00122O001700243O00122O001800256O0016001800024O0016000F00164O00175O00122O001800263O00122O001900276O0017001900024O0016001600174O00175O00122O001800283O00122O001900296O0017001900024O0017000F00174O00185O00122O0019002A3O00122O001A002B6O0018001A00024O0017001700184O00185O00122O0019002C3O00122O001A002D6O0018001A00024O0017001700184O00185O00122O0019002E3O00122O001A002F6O0018001A00024O0018000F00184O00195O00122O001A00303O00122O001B00316O0019001B00024O0018001800194O00195O00122O001A00323O00122O001B00336O0019001B00024O00180018001900122O001900346O001A5O00122O001B00353O00122O001C00366O001A001C00024O00190019001A00122O001A00373O00122O001B00383O00122O001C00393O00122O001D00393O00122O001E00396O001F8O00208O00218O00228O002300576O00585O00122O0059003A3O00122O005A003B6O0058005A00024O0058000D00584O00595O00122O005A003C3O00122O005B003D6O0059005B00024O0058005800594O00595O00122O005A003E3O00122O005B003F6O0059005B00024O0059000E00594O005A5O00122O005B00403O00122O005C00416O005A005C00024O00590059005A2O001D005A5O001253005B00423O00122O005C00436O005A005C00024O005A0015005A4O005B5O00122O005C00443O00122O005D00456O005B005D00024O005A005A005B4O005B5O00202O005C000800464O005C0002000200202O005D005C004700062O005D00B600013O0004743O00B600012O0085005D000E3O0020D8005E005C00472O00F0005D00020002000699005D00B9000100010004743O00B900012O0085005D000E3O0012CA005E00384O00F0005D000200020020D8005E005C00480006BB005E00C100013O0004743O00C100012O0085005E000E3O0020D8005F005C00482O00F0005E00020002000699005E00C4000100010004743O00C400012O0085005E000E3O0012CA005F00384O00F0005E000200022O00BE005F00613O001228006200493O00122O006300496O006400643O00122O006500383O00122O006600383O00122O006700383O00122O006800383O00202O00690004004A00065B006B3O000100052O00853O005C4O00853O00084O00853O005D4O00853O000E4O00853O005E4O00F3006C5O00122O006D004B3O00122O006E004C6O006C006E6O00693O000100202O00690004004A00065B006B0001000100022O00853O00624O00853O00634O0033006C5O00122O006D004D3O00122O006E004E6O006C006E6O00693O000100065B00690002000100052O00853O00584O001D8O00853O00144O00853O00094O00853O00643O00065B006A0003000100102O00853O00244O00853O00084O00853O00264O00853O00254O001D8O00853O00594O00853O00144O00853O005A4O00853O00584O00853O00524O00853O00514O00853O00104O00853O00314O00853O00324O00853O002A4O00853O002B3O00065B006B0004000100082O00853O00584O001D8O00853O00164O00853O000A4O00853O00144O00853O005A4O00853O00504O00853O00093O00065B006C0005000100052O00853O00084O00853O00164O00853O00584O00853O000B4O00853O005A3O00065B006D0006000100032O00853O00164O00853O005B4O00853O00213O00065B006E00070001000A2O00853O00584O001D8O00853O00144O00853O00094O00853O00084O00853O00644O00853O00614O00853O00654O00853O001C4O00853O005A3O00065B006F00080001001F2O00853O00584O001D8O00853O00554O00853O00164O00853O00564O00853O00574O00853O00144O00853O005A4O00853O003C4O00853O003D4O00853O003E4O00853O00364O00853O00374O00853O00384O00853O001D4O00853O00394O00853O003A4O00853O003B4O00853O001E4O00853O00334O00853O00344O00853O00354O00853O00084O00853O000A4O00853O006D4O00853O003F4O00853O00404O00853O00614O00853O00654O00853O001C4O00853O00093O00065B007000090001001B2O00853O00584O001D8O00853O00364O00853O00164O00853O00374O00853O00384O00853O00684O00853O00664O00853O001D4O00853O00144O00853O005A4O00853O00394O00853O003A4O00853O003B4O00853O00674O00853O001E4O00853O00464O00853O00084O00853O000A4O00853O00474O00853O00644O00853O00434O00853O00444O00853O00454O00853O00414O00853O00424O00853O00103O00065B0071000A000100112O00853O00584O001D8O00853O00464O00853O000A4O00853O00474O00853O00144O00853O005A4O00853O00644O00853O00484O00853O00164O00853O00494O00853O004A4O00853O004B4O00853O004C4O00853O004D4O00853O004E4O00853O004F3O00065B0072000B000100032O00853O000A4O00853O00704O00853O00713O00065B0073000C000100092O00853O00164O00853O006E4O00853O00724O00853O006C4O00853O00294O00853O00284O00853O006B4O00853O006A4O00853O006F3O00065B0074000D0001000B2O00853O00294O00853O00284O00853O006B4O00853O001F4O00853O00584O001D8O00853O00084O00853O00164O00853O00144O00853O00694O00853O00723O00065B0075000E000100332O00853O004D4O001D8O00853O004E4O00853O00514O00853O00524O00853O004F4O00853O00504O00853O004B4O00853O004C4O00853O00494O00853O004A4O00853O00474O00853O00484O00853O00374O00853O00384O00853O00354O00853O00364O00853O00394O00853O003A4O00853O00414O00853O00424O00853O00434O00853O00444O00853O00454O00853O00464O00853O003D4O00853O003E4O00853O003F4O00853O00404O00853O003B4O00853O003C4O00853O00314O00853O00324O00853O002F4O00853O00304O00853O00334O00853O00344O00853O002B4O00853O002C4O00853O00294O00853O002A4O00853O002D4O00853O002E4O00853O00534O00853O00544O00853O00234O00853O00244O00853O00254O00853O00264O00853O00274O00853O00283O00065B0076000F000100042O00853O00574O001D8O00853O00554O00853O00563O00065B00770010000100202O00853O005F4O00853O00084O00853O00604O00853O00094O00853O00204O00853O00614O00853O00754O00853O00764O00853O00584O00853O001D4O00853O00044O001D8O00853O00164O00853O00634O00853O00624O00853O001C4O00853O00214O00853O001F4O00853O001E4O00853O00144O00853O00734O00853O00744O00853O00224O00853O001B4O00853O00284O00853O005A4O00853O002C4O00853O002D4O00853O00534O00853O00544O00853O00644O00853O00683O00065B00780011000100042O00853O00164O001D8O00853O00064O00853O000F3O00206F0079000F004F00122O007A00506O007B00776O007C00786O0079007C00016O00013O00123O000B3O00028O00025O00C8A840025O0024A440030C3O0047657445717569706D656E74026O002A40026O00F03F025O00888640025O00108A40025O00809440025O00BCA440026O002C40003D3O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O002E4D00030026000100020004743O0026000100262200010026000100010004743O002600010012CA000200013O0026220002001F000100010004743O001F00012O001D000300013O0020410003000300044O0003000200024O00038O00035O00202O00030003000500062O0003001A00013O0004743O001A00012O001D000300034O001D00045O0020D80004000400052O00F00003000200020006990003001D000100010004743O001D00012O001D000300033O0012CA000400014O00F00003000200022O006E000300023O0012CA000200063O00264900020023000100060004743O00230001002E1C000700E9FF2O00080004743O000A00010012CA000100063O0004743O002600010004743O000A0001002E0D000900050001000A0004743O0005000100262200010005000100060004743O000500012O001D00025O0020D800020002000B0006BB0002003400013O0004743O003400012O001D000200034O001D00035O0020D800030003000B2O00F000020002000200069900020037000100010004743O003700012O001D000200033O0012CA000300014O00F00002000200022O006E000200043O0004743O003C00010004743O000500010004743O003C00010004743O000200012O00473O00017O00043O00028O00025O001AA940025O00349940024O0080B3C540000C3O0012CA3O00013O002E4D00030001000100020004743O000100010026223O0001000100010004743O000100010012CA000100044O006E00015O0012CA000100044O006E000100013O0004743O000B00010004743O000100012O00473O00017O00183O00028O00026O00F03F025O0094AD40025O0064B040025O007AB040025O00B49740025O00A4AF40025O0026B140030B3O00098DA9450A8F371C2489BA03083O007045E4DF2C64E871030A3O0049734361737461626C65030B3O004C6976696E67466C616D6503093O004973496E52616E6765026O00394003163O00D81611DAB87BB9D21306DEB33C96C61A04DCBB7E87C003073O00E6B47F67B3D61C030B3O00AD1F4A54E172F49E0C544303073O0080EC653F268421025O00FC9D40025O00107240030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E676503163O00ADB30456B3D4DCB8BB184FB3ABDFBEAC124BBBE9CEB803073O00AFCCC97124D68B00553O0012CA3O00014O00BE000100023O0026223O0007000100010004743O000700010012CA000100014O00BE000200023O0012CA3O00023O0026493O000B000100020004743O000B0001002E0D00040002000100030004743O00020001002E1C00053O000100050004743O000B00010026220001000B000100010004743O000B00010012CA000200013O002E0D00060010000100070004743O00100001002O0E00010010000100020004743O00100001002E1C0008001D000100080004743O003100012O001D00036O009B000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003100013O0004743O003100012O001D000300024O00F500045O00202O00040004000C4O000500033O00202O00050005000D00122O0007000E6O0005000700024O000500056O000600046O00030006000200062O0003003100013O0004743O003100012O001D000300013O0012CA0004000F3O0012CA000500104O008C000300054O00A900036O001D00036O009B000400013O00122O000500113O00122O000600126O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003005400013O0004743O00540001002E0D00140054000100130004743O005400012O001D000300024O00DE00045O00202O0004000400154O000500033O00202O0005000500164O00075O00202O0007000700154O0005000700024O000500056O00030005000200062O0003005400013O0004743O005400012O001D000300013O0012C6000400173O00122O000500186O000300056O00035O00044O005400010004743O001000010004743O005400010004743O000B00010004743O005400010004743O000200012O00473O00017O00243O00028O00026O00F03F025O00D49240025O0078874003103O004865616C746850657263656E7461676503193O00D74B7618E05D7803EB493022E04F7C03EB49303AEA5A7905EB03043O006A852E10025O0002A440025O00D49A40025O00EC9A40025O0020AC4003173O006A2575EE5F5350297DFB7245592C7AF25D7057347AF35403063O00203840139C3A03073O004973526561647903173O0052656672657368696E674865616C696E67506F74696F6E03253O0048CDE3445FE18853C6E21652F78156C1EB511AE28F4EC1EA581AF6855CCDEB4553E4851A9C03073O00E03AA885363A92025O008EA940025O00849940030D3O006B5345F8628F890C7B5A4AE77003083O006B39362B9D15E6E7030A3O0049734361737461626C65030D3O0052656E6577696E67426C617A6503173O00E98E1FF0AED5C1DCA91DF4A3D98FDF8E17F0B7CFC6CD8E03073O00AFBBEB7195D9BC030E3O0068CE26D5004ECD3BEF0746C030CF03053O006427AC55BC03083O0042752O66446F776E030E3O004F6273696469616E5363616C6573031A3O00A27AAA8937A479B7BF20AE79B58520ED7CBC8636A36BB09636BE03053O0053CD18D9E0030B3O00CEC0CC31F2CDDE29E9CBC803043O005D86A5AD030B3O004865616C746873746F6E6503173O00B6F7C0CE2EC6A16AB1FCC4823ECBB47BB0E1C8D43F8EE103083O001EDE92A1A25AAED200A53O0012CA3O00013O0026493O0005000100020004743O00050001002E0D00030053000100040004743O005300012O001D00015O0006BB0001003100013O0004743O003100012O001D000100013O00203A0001000100052O00F00001000200022O001D000200023O0006B900010031000100020004743O003100012O001D000100034O00D9000200043O00122O000300063O00122O000400076O00020004000200062O00010031000100020004743O00310001002E4D00080018000100090004743O001800010004743O00310001002E4D000A00310001000B0004743O003100012O001D000100054O009B000200043O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O00010001000E4O00010002000200062O0001003100013O0004743O003100012O001D000100064O00D0000200073O00202O00020002000F4O000300046O000500016O00010005000200062O0001003100013O0004743O003100012O001D000100043O0012CA000200103O0012CA000300114O008C000100034O00A900015O002E4D001300A4000100120004743O00A400012O001D000100084O009B000200043O00122O000300143O00122O000400156O0002000400024O00010001000200202O0001000100164O00010002000200062O000100A400013O0004743O00A400012O001D000100013O00203A0001000100052O00F00001000200022O001D000200093O0006C2000100A4000100020004743O00A400012O001D0001000A3O0006BB000100A400013O0004743O00A400012O001D0001000B4O00CD000200083O00202O0002000200174O000300046O00010004000200062O000100A400013O0004743O00A400012O001D000100043O0012C6000200183O00122O000300196O000100036O00015O00044O00A400010026223O0001000100010004743O000100010012CA000100013O002O0E0001009E000100010004743O009E00012O001D000200084O009B000300043O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200164O00020002000200062O0002007D00013O0004743O007D00012O001D0002000C3O0006BB0002007D00013O0004743O007D00012O001D000200013O00202A00020002001C4O000400083O00202O00040004001D4O00020004000200062O0002007D00013O0004743O007D00012O001D000200013O00203A0002000200052O00F00002000200022O001D0003000D3O0006C20002007D000100030004743O007D00012O001D000200064O001D000300083O0020D800030003001D2O00F00002000200020006BB0002007D00013O0004743O007D00012O001D000200043O0012CA0003001E3O0012CA0004001F4O008C000200044O00A900026O001D000200054O009B000300043O00122O000400203O00122O000500216O0003000500024O00020002000300202O00020002000E4O00020002000200062O0002009D00013O0004743O009D00012O001D0002000E3O0006BB0002009D00013O0004743O009D00012O001D000200013O00203A0002000200052O00F00002000200022O001D0003000F3O0006B90002009D000100030004743O009D00012O001D000200064O00D0000300073O00202O0003000300224O000400056O000600016O00020006000200062O0002009D00013O0004743O009D00012O001D000200043O0012CA000300233O0012CA000400244O008C000200044O00A900025O0012CA000100023O00262200010056000100020004743O005600010012CA3O00023O0004743O000100010004743O005600010004743O000100012O00473O00017O002B3O00028O00025O003EA840025O0072A640026O00F03F025O0026AC40025O00A88640025O0036A640025O00C06540025O00A6A34003103O009ED83558B8CB2956B4D7276AB1D82D4903043O002CDDB94003073O004973526561647903123O00556E69744861734375727365446562752O6603143O00556E697448617344697365617365446562752O66025O003BB140025O00909F4003153O00436175746572697A696E67466C616D65466F63757303183O0002E65D4B7613EE52567D06D84E53720CE2085B7A12F74D5303053O00136187283F025O000C9540030E3O00814C23292A22BD553D3C1D3EAF4E03063O0051CE3C535B4F03113O00556E6974486173456E7261676542752O66030E3O004F2O7072652O73696E67526F617203163O0061BBC0602AD05EAD40AC904020C25FE44AA2C3622ACF03083O00C42ECBB0124FA32D025O006DB140025O00F4B040025O0070A640025O00C08140025O003EA14003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E697403073O0019B79159ED7E7D03073O00185CCFE12C831903123O00556E69744861734D61676963446562752O66030C3O00457870756E6765466F637573025O009AAD40025O00F88A40030E3O004ECBA859157A4E93BC45086D4EDF03063O001D2BB3D82C7B00B03O0012CA3O00014O00BE000100023O002E4D00030009000100020004743O00090001002O0E0001000900013O0004743O000900010012CA000100014O00BE000200023O0012CA3O00043O0026493O000D000100040004743O000D0001002E1C000500F7FF2O00060004743O00020001002E1C00073O000100070004743O000D0001002O0E0001000D000100010004743O000D00010012CA000200013O00264900020016000100040004743O00160001002E4D0009005A000100080004743O005A00012O001D00036O009B000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003900013O0004743O003900012O001D000300023O0020D800030003000D2O001D000400034O00F00003000200020006990003002C000100010004743O002C00012O001D000300023O0020D800030003000E2O001D000400034O00F00003000200020006BB0003003900013O0004743O00390001002E4D001000390001000F0004743O003900012O001D000300044O001D000400053O0020D80004000400112O00F00003000200020006BB0003003900013O0004743O003900012O001D000300013O0012CA000400123O0012CA000500134O008C000300054O00A900035O002E1C00140076000100140004743O00AF00012O001D00036O009B000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300AF00013O0004743O00AF00012O001D000300063O0006BB000300AF00013O0004743O00AF00012O001D000300023O0020D80003000300172O001D000400074O00F00003000200020006BB000300AF00013O0004743O00AF00012O001D000300044O001D00045O0020D80004000400182O00F00003000200020006BB000300AF00013O0004743O00AF00012O001D000300013O0012C6000400193O00122O0005001A6O000300056O00035O00044O00AF0001002E1C001B00B8FF2O001B0004743O0012000100262200020012000100010004743O001200010012CA000300013O00262200030063000100040004743O006300010012CA000200043O0004743O0012000100264900030067000100010004743O00670001002E1C001C00FAFF2O001D0004743O005F00010012CA000400013O002E4D001E006E0001001F0004743O006E00010026220004006E000100040004743O006E00010012CA000300043O0004743O005F000100262200040068000100010004743O006800012O001D000500033O0006BB0005008300013O0004743O008300012O001D000500033O00203A0005000500202O00F00005000200020006BB0005008300013O0004743O008300012O001D000500033O00203A0005000500210012CA000700224O00FD0005000700020006BB0005008300013O0004743O008300012O001D000500023O0020D80005000500232O008400050001000200069900050084000100010004743O008400012O00473O00014O001D00056O009B000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500A700013O0004743O00A700012O001D000500023O0020D80005000500262O001D000600034O00F00005000200020006990005009A000100010004743O009A00012O001D000500023O0020D800050005000E2O001D000600034O00F00005000200020006BB000500A700013O0004743O00A700012O001D000500044O001D000600053O0020D80006000600272O00F0000500020002000699000500A2000100010004743O00A20001002E4D002800A7000100290004743O00A700012O001D000500013O0012CA0006002A3O0012CA0007002B4O008C000500074O00A900055O0012CA000400043O0004743O006800010004743O005F00010004743O001200010004743O00AF00010004743O000D00010004743O00AF00010004743O000200012O00473O00017O00183O00025O00C06D40025O0085B34003093O00497343617374696E67030C3O0049734368612O6E656C696E67028O00026O00F03F025O00BDB040025O00B6AD4003093O00496E74652O7275707403053O005175652O6C026O002440025O00E0A440025O002EB340025O0018A740025O0001B14003113O00496E74652O72757074576974685374756E03093O005461696C5377697065026O002040025O009CAB40025O0062A040027O0040025O006EA940025O00B08040030E3O005175652O6C4D6F7573656F76657200573O002E0D00010056000100020004743O005600012O001D7O00203A5O00032O00F03O000200020006993O0056000100010004743O005600012O001D7O00203A5O00042O00F03O000200020006993O0056000100010004743O005600010012CA3O00054O00BE000100023O0026223O0050000100060004743O00500001002E0D00080022000100070004743O0022000100262200010022000100050004743O002200012O001D000300013O0020A30003000300094O000400023O00202O00040004000A00122O0005000B6O000600016O0003000600024O000200033O002E2O000C00210001000D0004743O002100010006BB0002002100013O0004743O002100012O0072000200023O0012CA000100063O00264900010026000100060004743O00260001002E0D000F003B0001000E0004743O003B00010012CA000300053O00262200030034000100050004743O003400012O001D000400013O0020C00004000400104O000500023O00202O00050005001100122O000600126O0004000600024O000200043O00062O0002003300013O0004743O003300012O0072000200023O0012CA000300063O002E0D00140027000100130004743O0027000100262200030027000100060004743O002700010012CA000100153O0004743O003B00010004743O00270001002E4D00170010000100160004743O0010000100262200010010000100150004743O001000012O001D000300013O00200A0003000300094O000400023O00202O00040004000A00122O0005000B6O000600016O000700036O000800043O00202O0008000800184O0003000800024O000200033O00062O0002005600013O0004743O005600012O0072000200023O0004743O005600010004743O001000010004743O005600010026223O000E000100050004743O000E00010012CA000100054O00BE000200023O0012CA3O00063O0004743O000E00012O00473O00017O000F3O00028O00025O009EB040025O006CB140026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O0035B240025O0035B140025O00DFB140025O005C9E40025O00607440025O00C4914003103O0048616E646C65546F705472696E6B6574025O0010944000493O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O002E0D00020017000100030004743O0017000100262200010017000100040004743O001700012O001D00025O0020D30002000200064O000300016O000400023O00122O000500076O000600066O00020006000200122O000200053O00122O000200053O00062O0002004800013O0004743O0048000100125F000200054O0072000200023O0004743O004800010026490001001B000100010004743O001B0001002E4D00080005000100090004743O000500010012CA000200014O00BE000300033O002O0E0001001D000100020004743O001D00010012CA000300013O002E4D000B00260001000A0004743O0026000100262200030026000100040004743O002600010012CA000100043O0004743O000500010026490003002A000100010004743O002A0001002E0D000D00200001000C0004743O002000010012CA000400013O0026220004002F000100040004743O002F00010012CA000300043O0004743O00200001002O0E0001002B000100040004743O002B00012O001D00055O0020FE00050005000E4O000600016O000700023O00122O000800076O000900096O00050009000200122O000500053O002E2O000F00070001000F0004743O0040000100125F000500053O0006BB0005004000013O0004743O0040000100125F000500054O0072000500023O0012CA000400043O0004743O002B00010004743O002000010004743O000500010004743O001D00010004743O000500010004743O004800010004743O000200012O00473O00017O003C3O00028O00027O0040026O00A840025O00C4AA40030B3O001B0CE1A73F25E0A7331DF103043O00D55A7694030A3O0049734361737461626C65030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E6765025O0088AF40025O0017B14003133O005A34A14448643DA02O44502BF4524C562FB35303053O002D3B4ED436025O00B0AE40030B3O00942B68172AFCC9B423731B03073O008FD8421E7E449B03063O0042752O66557003113O004C656170696E67466C616D657342752O66030B3O004C6976696E67466C616D6503223O00A6C11BC2CBA4E8E7A6C900CEFAAFD2E0BAC103CCFAA5DBE0A7CD1E8BC1A2DAE0ADCD03083O0081CAA86DABA5C3B7030A3O00045125DDFC06E3234C3F03073O0086423857B8BE7403073O0049735265616479025O008AA440025O007AA740025O0078A440025O00607A40025O00A09D40025O00049D40025O00E89640025O00C07E40025O00208B40025O001AAE40026O00F03F026O001040026O001840026O000840025O005C9C40025O006DB240025O00AEAC40030F3O00466972654272656174684D6163726F03093O004973496E52616E6765026O003E4003133O003A381BBE26E933303D2501FB1DEA2C343B344903083O00555C5169DB798B41030C3O00D9BA434C72CBF8B4424468DA03063O00BF9DD330251C03103O00452O73656E6365427572737442752O66026O006B40025O00C07140030C3O00446973696E7465677261746503133O00DB16E71534CB1AF30E3BCB1AB4183BD21EF31903053O005ABF7F947C025O0072A940025O003EA140030B3O00548E381E7680081B798A2B03043O007718E74E03133O008E24B343D2472E8421A447D900158320A44DD903073O0071E24DC52ABC2000F23O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O00264900010009000100020004743O00090001002E4D00040027000100030004743O002700012O001D00026O009B000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O000200F100013O0004743O00F100012O001D000200024O00AC00035O00202O0003000300084O000400033O00202O0004000400094O00065O00202O0006000600084O0004000600024O000400046O00020004000200062O00020021000100010004743O00210001002E0D000B00F10001000A0004743O00F100012O001D000200013O0012C60003000C3O00122O0004000D6O000200046O00025O00044O00F10001002O0E000100A8000100010004743O00A80001002E1C000E00250001000E0004743O004E00012O001D00026O009B000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004E00013O0004743O004E00012O001D000200043O00202A0002000200114O00045O00202O0004000400124O00020004000200062O0002004E00013O0004743O004E00012O001D000200024O004C00035O00202O0003000300134O000400033O00202O0004000400094O00065O00202O0006000600134O0004000600024O000400046O000500056O00020005000200062O0002004E00013O0004743O004E00012O001D000200013O0012CA000300143O0012CA000400154O008C000200044O00A900026O001D00026O0043000300013O00122O000400163O00122O000500176O0003000500024O00020002000300202O0002000200184O00020002000200062O0002005A000100010004743O005A0001002E4D001A00A7000100190004743O00A700010012CA000200014O00BE000300033O00264900020060000100010004743O00600001002E4D001B005C0001001C0004743O005C00010012CA000300013O002E0D001E008A0001001D0004743O008A00010026220003008A000100010004743O008A00010012CA000400013O002E4D002000830001001F0004743O00830001002O0E00010083000100040004743O00830001002E0D00210072000100220004743O007200012O001D000500063O002O2600050072000100020004743O007200010012CA000500234O006E000500073O0004743O008000012O001D000500063O002O2600050078000100240004743O007800010012CA000500024O006E000500073O0004743O008000012O001D000500063O002O260005007E000100250004743O007E00010012CA000500264O006E000500073O0004743O008000010012CA000500244O006E000500074O001D000500074O006E000500083O0012CA000400233O00264900040087000100230004743O00870001002E0D00280066000100270004743O006600010012CA000300233O0004743O008A00010004743O0066000100262200030061000100230004743O00610001002E1C0029001B000100290004743O00A700012O001D000400024O00BC000500093O00202O00050005002A4O000600033O00202O00060006002B00122O0008002C6O0006000800024O000600066O000700016O000800086O000900016O00040009000200062O000400A700013O0004743O00A700012O001D000400013O0012D70005002D3O00122O0006002E6O0004000600024O000500076O0004000400054O000400023O00044O00A700010004743O006100010004743O00A700010004743O005C00010012CA000100233O00262200010005000100230004743O000500012O001D00026O009B000300013O00122O0004002F3O00122O000500306O0003000500024O00020002000300202O0002000200184O00020002000200062O000200CF00013O0004743O00CF00012O001D000200043O00202A0002000200114O00045O00202O0004000400314O00020004000200062O000200CF00013O0004743O00CF0001002E4D003200CF000100330004743O00CF00012O001D000200024O004C00035O00202O0003000300344O000400033O00202O0004000400094O00065O00202O0006000600344O0004000600024O000400046O000500056O00020005000200062O000200CF00013O0004743O00CF00012O001D000200013O0012CA000300353O0012CA000400364O008C000200044O00A900025O002E0D003800ED000100370004743O00ED00012O001D00026O009B000300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200ED00013O0004743O00ED00012O001D000200024O004C00035O00202O0003000300134O000400033O00202O0004000400094O00065O00202O0006000600134O0004000600024O000400046O000500056O00020005000200062O000200ED00013O0004743O00ED00012O001D000200013O0012CA0003003B3O0012CA0004003C4O008C000200044O00A900025O0012CA000100023O0004743O000500010004743O00F100010004743O000200012O00473O00017O00643O00028O00026O00F03F027O0040025O004EA040025O00206140030B3O002520033B50273E0F3D551503053O003D6152665A030A3O0049734361737461626C6503093O008D3AEB68D2450D06BE03083O0069CC4ECB2BA7377E031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00A6AE40025O009BB24003113O00447265616D466C69676874437572736F7203153O0081B8261F1E3BE15DACAD2B0A5307C85EA9AE2C091D03083O0031C5CA437E7364A7025O00409B40030B3O001349DA288D70523E5CD73D03073O003E573BBF49E036030C3O00C40DF4CFEE10F7C8F30BF5C703043O00A987629A026O006F40025O00F89140030B3O00447265616D466C6967687403153O00EF652155F00CEEC77E235CE973CBC4782850F224C603073O00A8AB1744349D53025O0034AF40025O0060724003063O00C674E2A42B2903073O00E7941195CD454D03063O00526577696E64030F3O0092A2D0F259FBC0A4C8F45BFB8FB0C903063O009FE0C7A79B37026O000840030C3O007A1E219CF9B576594F1B34BB03083O003A2E7751C891D025025O00A49940025O00A88540030B3O000F9E35ADA49F242E8D24A403073O00564BEC50CCC9DD03073O0049735265616479025O00A7B140025O0076A140025O00E08B40025O00F4924003173O005469705468655363616C6573447265616D42726561746803153O0076537284F3B470537284EA833242788AF28F7D567903063O00EB122117E59E025O00E2A940025O002FB240030B3O0063AAC8A959AEC3B75FB5CC03043O00DB30DAA103173O005469705468655363616C6573537069726974626C2O6F6D03153O00F761755BD25BDFE67D7346D60FE3EB7E704DD458EE03073O008084111C29BB2F03063O00234282988F3D03083O00907036E3EBE64ECD025O00E8AE40025O0022A540025O009C9E40025O00BAA74003063O00537461736973030F3O00A03C0EEFD948F32B00F3DC5FBC3F0103063O003BD3486F9CB003103O007D93E23E4794D1284F84F7245886F72803043O004D2EE78303063O0042752O665570030A3O0053746173697342752O66030B3O0042752O6652656D61696E73025O00649340025O004AA140025O0029B340025O006EB34003103O0053746173697352656163746976617465031A3O00A940B753B3478952BF55B554B342B754BF14B54FB558B24FAD5A03043O0020DA34D6025O00CAAB40025O0010774003063O0045786973747303093O004973496E52616E6765026O003E40030C3O00C3FA31D7D3FA30D3E3FA33DC03043O00B297935C03103O004865616C746850657263656E74616765025O000AAC40025O0056A74003113O0054696D6544696C6174696F6E466F63757303163O0098F441372D487380FC583B1D423A8FF2433E16436D8203073O001AEC9D2C52722C030A3O000C27C75E083CD05A3E2603043O003B4A4EB5026O001040025O001AB140025O004AA640026O001840030F3O00466972654272656174684D6163726F03103O0023D8485F8C27C35F5BA72D91595EA06503053O00D345B12O3A025O00C09A40025O0024AC4000E2012O0012CA3O00014O00BE000100023O0026223O00D12O0100020004743O00D12O010026220001007E000100030004743O007E00010012CA000300013O0026490003000B000100010004743O000B0001002E0D00040058000100050004743O005800012O001D00046O009B000500013O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400084O00040002000200062O0004002300013O0004743O002300012O001D000400024O00D9000500013O00122O000600093O00122O0007000A6O00050007000200062O00040023000100050004743O002300012O001D000400033O0020AF00040004000B4O000500046O000600056O00040006000200062O00040025000100010004743O00250001002E4D000D00300001000C0004743O003000012O001D000400064O001D000500073O0020D800050005000E2O00F00004000200020006BB0004003000013O0004743O003000012O001D000400013O0012CA0005000F3O0012CA000600104O008C000400064O00A900045O002E1C00110027000100110004743O005700012O001D00046O009B000500013O00122O000600123O00122O000700136O0005000700024O00040004000500202O0004000400084O00040002000200062O0004005700013O0004743O005700012O001D000400024O00D9000500013O00122O000600143O00122O000700156O00050007000200062O00040057000100050004743O005700012O001D000400033O0020A400040004000B4O000500046O000600056O00040006000200062O0004005700013O0004743O00570001002E4D00160057000100170004743O005700012O001D000400064O001D00055O0020D80005000500182O00F00004000200020006BB0004005700013O0004743O005700012O001D000400013O0012CA000500193O0012CA0006001A4O008C000400064O00A900045O0012CA000300023O002E4D001C00070001001B0004743O0007000100262200030007000100020004743O000700012O001D00046O009B000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500202O0004000400084O00040002000200062O0004007B00013O0004743O007B00012O001D000400083O0006BB0004007B00013O0004743O007B00012O001D000400033O0020A400040004000B4O000500096O0006000A6O00040006000200062O0004007B00013O0004743O007B00012O001D000400064O001D00055O0020D800050005001F2O00F00004000200020006BB0004007B00013O0004743O007B00012O001D000400013O0012CA000500203O0012CA000600214O008C000400064O00A900045O0012CA000100223O0004743O007E00010004743O00070001002622000100512O0100020004743O00512O010012CA000300013O002O0E000200F9000100030004743O00F900012O001D00046O009B000500013O00122O000600233O00122O000700246O0005000700024O00040004000500202O0004000400084O00040002000200062O000400F700013O0004743O00F70001002E0D002600C9000100250004743O00C900012O001D00046O009B000500013O00122O000600273O00122O000700286O0005000700024O00040004000500202O0004000400294O00040002000200062O000400C900013O0004743O00C900012O001D0004000B3O0006BB000400C900013O0004743O00C900012O001D000400033O0020A400040004000B4O0005000C6O0006000D6O00040006000200062O000400C900013O0004743O00C900010012CA000400014O00BE000500063O002649000400A9000100020004743O00A90001002E0D002A00C20001002B0004743O00C20001002O0E000100A9000100050004743O00A900010012CA000600013O002E0D002C00AC0001002D0004743O00AC0001002622000600AC000100010004743O00AC00010012CA000700024O00EF0007000E6O000700066O000800073O00202O00080008002E4O00070002000200062O000700F700013O0004743O00F700012O001D000700013O0012C60008002F3O00122O000900306O000700096O00075O00044O00F700010004743O00AC00010004743O00F700010004743O00A900010004743O00F70001002622000400A5000100010004743O00A500010012CA000500014O00BE000600063O0012CA000400023O0004743O00A500010004743O00F70001002E4D003100F7000100320004743O00F700012O001D00046O009B000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O0004000400294O00040002000200062O000400F700013O0004743O00F700012O001D0004000F3O0006BB000400F700013O0004743O00F700012O001D000400033O0020A400040004000B4O000500106O000600116O00040006000200062O000400F700013O0004743O00F700010012CA000400014O00BE000500053O002622000400E1000100010004743O00E100010012CA000500013O002622000500E4000100010004743O00E400010012CA000600224O00EF000600126O000600066O000700073O00202O0007000700354O00060002000200062O000600F700013O0004743O00F700012O001D000600013O0012C6000700363O00122O000800376O000600086O00065O00044O00F700010004743O00E400010004743O00F700010004743O00E100010012CA000100033O0004743O00512O0100262200030081000100010004743O008100012O001D00046O009B000500013O00122O000600383O00122O000700396O0005000700024O00040004000500202O0004000400294O00040002000200062O0004000F2O013O0004743O000F2O012O001D000400133O0006BB0004000F2O013O0004743O000F2O012O001D000400033O0020AF00040004000B4O000500146O000600156O00040006000200062O000400112O0100010004743O00112O01002E0D003A001E2O01003B0004743O001E2O01002E0D003C001E2O01003D0004743O001E2O012O001D000400064O001D00055O0020D800050005003E2O00F00004000200020006BB0004001E2O013O0004743O001E2O012O001D000400013O0012CA0005003F3O0012CA000600404O008C000400064O00A900046O001D00046O009B000500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O0004000400294O00040002000200062O000400402O013O0004743O00402O012O001D000400133O0006BB000400402O013O0004743O00402O012O001D000400033O0020AF00040004000B4O000500146O000600156O00040006000200062O000400422O0100010004743O00422O012O001D000400163O00202A0004000400434O00065O00202O0006000600444O00040006000200062O000400402O013O0004743O00402O012O001D000400163O0020210004000400454O00065O00202O0006000600444O00040006000200262O000400422O0100220004743O00422O01002E0D0047004F2O0100460004743O004F2O01002E0D0048004F2O0100490004743O004F2O012O001D000400064O001D00055O0020D800050005004A2O00F00004000200020006BB0004004F2O013O0004743O004F2O012O001D000400013O0012CA0005004B3O0012CA0006004C4O008C000400064O00A900045O0012CA000300023O0004743O00810001002622000100752O0100010004743O00752O010012CA000300013O0026220003005D2O0100020004743O005D2O01002E1C004D00050001004D0004743O005B2O010006BB0002005B2O013O0004743O005B2O012O0072000200023O0012CA000100023O0004743O00752O01002E1C004E00F7FF2O004E0004743O00542O01002622000300542O0100010004743O00542O012O001D000400173O0006BB0004006F2O013O0004743O006F2O012O001D000400173O00203A00040004004F2O00F00004000200020006BB0004006F2O013O0004743O006F2O012O001D000400173O00203A0004000400500012CA000600514O00FD000400060002000699000400702O0100010004743O00702O012O00473O00014O001D000400184O00840004000100022O0085000200043O0012CA000300023O0004743O00542O0100262200010004000100220004743O000400012O001D00036O009B000400013O00122O000500523O00122O000600536O0004000600024O00030003000400202O0003000300084O00030002000200062O0003008A2O013O0004743O008A2O012O001D000300193O0006BB0003008A2O013O0004743O008A2O012O001D000300173O00203A0003000300542O00F00003000200022O001D0004001A3O00060500030003000100040004743O008C2O01002E0D005500972O0100560004743O00972O012O001D000300064O001D000400073O0020D80004000400572O00F00003000200020006BB000300972O013O0004743O00972O012O001D000300013O0012CA000400583O0012CA000500594O008C000300054O00A900036O001D00036O009B000400013O00122O0005005A3O00122O0006005B6O0004000600024O00030003000400202O0003000300294O00030002000200062O000300E12O013O0004743O00E12O012O001D0003001B3O002O26000300A72O0100030004743O00A72O010012CA000300024O006E0003001C3O0004743O00B72O012O001D0003001B3O002O26000300AD2O01005C0004743O00AD2O010012CA000300034O006E0003001C3O0004743O00B72O01002E0D005E00B52O01005D0004743O00B52O012O001D0003001B3O002O26000300B52O01005F0004743O00B52O010012CA000300224O006E0003001C3O0004743O00B72O010012CA0003005C4O006E0003001C4O001D0003001C4O00750003001D6O000300066O000400073O00202O0004000400604O0005001E3O00202O00050005005000122O000700516O0005000700024O000500056O000600016O000700076O000800016O00030008000200062O000300E12O013O0004743O00E12O012O001D000300013O0012D7000400613O00122O000500626O0003000500024O0004001C6O0003000300044O000300023O00044O00E12O010004743O000400010004743O00E12O01000E25000100D52O013O0004743O00D52O01002E0D00640002000100630004743O000200010012CA000300013O002O0E000100DB2O0100030004743O00DB2O010012CA000100014O00BE000200023O0012CA000300023O002O0E000200D62O0100030004743O00D62O010012CA3O00023O0004743O000200010004743O00D62O010004743O000200012O00473O00017O00673O00028O00025O00BBB140025O005AA540026O00F03F025O004EA440025O00188040027O0040025O0054AD40025O00508940026O000840025O00849940025O00E49E40025O00B0B140025O0046AC40030B3O00C630E25D7653D4E723F35403073O00A68242873C1B1103073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00806540025O0058A040025O0090A040025O00BCA240025O00607640025O00A6A240025O001DB240025O00C49340025O00AEA54003103O00447265616D4272656174684D6163726F03183O004058CB743D7B48DC703150428E743F4175C670314843C07203053O0050242AAE15030B3O007D003E6847043576411F3A03043O001A2E7057025O004EB140025O00804940025O003C9D40025O00389F40025O0046A040025O00E4AE40025O00049D40025O00804D4003103O00537069726974626C2O6F6D466F63757303183O00AA33A266B6AB7AB6B52CA479FFBE4AB1862BAE75B3B64BB303083O00D4D943CB142ODF25025O00409340025O00CAA740026O005A40030B3O009684BEDBB48A8EDEBB80AD03043O00B2DAEDC8030A3O0049734361737461626C6503063O0042752O66557003113O004C656170696E67466C616D657342752O6603103O004865616C746850657263656E7461676503103O004C6976696E67466C616D65466F637573030E3O0049735370652O6C496E52616E6765030B3O004C6976696E67466C616D6503273O00BABCF0D9B8B2D9D6BAB4EBD589B9E3D1A6BCE8D789B3EAD1BBB0F590B7BAE3EFBEB0E7DCBFBBE103043O00B0D6D586025O00B6B140025O002EA740025O00F2AA40025O0080A240025O007DB240025O00B8AB40030E3O0092E87CE7E8C7B3C7752OFAD8B8E803063O00ABD78519958903133O00456D6572616C64426C6F2O736F6D466F637573025O00549F40025O004FB240031B3O00E4C537E8EE3CF87DE3C43DE9FC3FF102E0C737C5E735FD4EE8C63503083O002281A8529A8F509C030B3O00B5BE32124D5CC9AABC3F1203073O00E9E5D2536B282E030E3O00F74720D204CF5617DB07D34331D303053O0065A12252B6025O009C9B40025O00A08C4003143O0056657264616E74456D6272616365506C61796572031B3O00FE084BFADAEC9611ED005BECDAE1876EE9025CC1D3E78322E1035E03083O004E886D399EBB82E2025O000AAC40025O00C4AC40025O00C05240025O00E07A4003083O001B29FCE32730F7F403043O00915E5F99030E3O00CBC806D14FB9E9E819D75CB6FEC803063O00D79DAD74B52E03133O0056657264616E74456D6272616365466F637573025O003DB040025O0026A940031B3O0023B199F6DB3BA0B4F7D737A68AF1DF75B584F7E53DB18AFED33BB303053O00BA55D4EB9203083O00EC8E02BE0DEF56C903073O0038A2E1769E598E025O007C9C40025O00BCA540030E3O006A00D2AB23D64820CDAD30D95F0003063O00B83C65A0CF42030D3O00556E697447726F7570526F6C6503043O0005A3529703043O00DC51E21C031B3O0005D090FFEBC907EA87F6E8D512D687BBEBC816EA8AFEEBCB1ADB8503063O00A773B5E29B8A00BE012O0012CA3O00014O00BE000100023O002E4D00030009000100020004743O000900010026223O0009000100010004743O000900010012CA000100014O00BE000200023O0012CA3O00043O0026223O0002000100040004743O000200010026490001000F000100010004743O000F0001002E4D0005000B000100060004743O000B00010012CA000200013O00264900020014000100070004743O00140001002E0D000800BB000100090004743O00BB00010012CA000300013O00262200030019000100040004743O001900010012CA0002000A3O0004743O00BB0001002E4D000B00150001000C0004743O0015000100262200030015000100010004743O00150001002E4D000E006A0001000D0004743O006A00012O001D00046O009B000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O0004000400114O00040002000200062O0004006A00013O0004743O006A00012O001D000400023O0006BB0004006A00013O0004743O006A00012O001D000400033O0020A40004000400124O000500046O000600056O00040006000200062O0004006A00013O0004743O006A00010012CA000400014O00BE000500053O00264900040039000100010004743O00390001002E4D00140035000100130004743O003500010012CA000500013O002E1C0015001B000100150004743O0055000100262200050055000100010004743O005500010012CA000600013O00262200060043000100040004743O004300010012CA000500043O0004743O00550001000E2500010047000100060004743O00470001002E1C001600FAFF2O00170004743O003F0001002E0D0018004F000100190004743O004F00012O001D000700063O002O260007004F000100070004743O004F00010012CA000700044O006E000700073O0004743O005100010012CA000700074O006E000700074O001D000700074O006E000700083O0012CA000600043O0004743O003F00010026220005003A000100040004743O003A0001002E0D001A006A0001001B0004743O006A00012O001D000600094O00D00007000A3O00202O00070007001C4O000800086O000900016O00060009000200062O0006006A00013O0004743O006A00012O001D000600013O0012C60007001D3O00122O0008001E6O000600086O00065O00044O006A00010004743O003A00010004743O006A00010004743O003500012O001D00046O009B000500013O00122O0006001F3O00122O000700206O0005000700024O00040004000500202O0004000400114O00040002000200062O0004007E00013O0004743O007E00012O001D0004000B3O0006BB0004007E00013O0004743O007E00012O001D000400033O0020AF0004000400124O0005000C6O0006000D6O00040006000200062O00040080000100010004743O00800001002E0D002100B9000100220004743O00B900010012CA000400014O00BE000500053O002E4D00230082000100240004743O0082000100262200040082000100010004743O008200010012CA000500013O002622000500A2000100010004743O00A200010012CA000600014O00BE000700073O0026220006008B000100010004743O008B00010012CA000700013O00262200070092000100040004743O009200010012CA000500043O0004743O00A200010026220007008E000100010004743O008E00012O001D000800063O000E700007009A000100080004743O009A00010012CA0008000A4O006E0008000E3O0004743O009C00010012CA000800044O006E0008000E3O0012CA0008000A4O006E0008000F3O0012CA000700043O0004743O008E00010004743O00A200010004743O008B0001002649000500A6000100040004743O00A60001002E4D00260087000100250004743O00870001002E0D002800B9000100270004743O00B900012O001D000600094O00D00007000A3O00202O0007000700294O000800086O000900016O00060009000200062O000600B900013O0004743O00B900012O001D000600013O0012C60007002A3O00122O0008002B6O000600086O00065O00044O00B900010004743O008700010004743O00B900010004743O008200010012CA000300043O0004743O00150001002649000200BF0001000A0004743O00BF0001002E1C002C00310001002D0004743O00EE0001002E1C002E00FE0001002E0004743O00BD2O012O001D00036O009B000400013O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O0003000300314O00030002000200062O000300BD2O013O0004743O00BD2O012O001D000300103O0006BB000300BD2O013O0004743O00BD2O012O001D000300113O00202A0003000300324O00055O00202O0005000500334O00030005000200062O000300BD2O013O0004743O00BD2O012O001D000300123O00203A0003000300342O00F00003000200022O001D000400133O0006B9000300BD2O0100040004743O00BD2O012O001D000300094O004C0004000A3O00202O0004000400354O000500123O00202O0005000500364O00075O00202O0007000700374O0005000700024O000500056O000600146O00030006000200062O000300BD2O013O0004743O00BD2O012O001D000300013O0012C6000400383O00122O000500396O000300056O00035O00044O00BD2O01002E0D003B00542O01003A0004743O00542O01002622000200542O0100010004743O00542O010012CA000300014O00BE000400043O002649000300F8000100010004743O00F80001002E4D003C00F40001003D0004743O00F400010012CA000400013O002622000400FD000100040004743O00FD00010012CA000200043O0004743O00542O01002E4D003F00F90001003E0004743O00F90001002622000400F9000100010004743O00F900010012CA000500013O0026220005004C2O0100010004743O004C2O012O001D00066O009B000700013O00122O000800403O00122O000900416O0007000900024O00060006000700202O0006000600314O00060002000200062O000600252O013O0004743O00252O012O001D000600153O0006BB000600252O013O0004743O00252O012O001D000600033O0020A40006000600124O000700166O000800176O00060008000200062O000600252O013O0004743O00252O012O001D000600094O001D0007000A3O0020D80007000700422O00F0000600020002000699000600202O0100010004743O00202O01002E0D004400252O0100430004743O00252O012O001D000600013O0012CA000700453O0012CA000800464O008C000600084O00A900066O001D000600184O00AB000700013O00122O000800473O00122O000900486O00070009000200062O0006002D2O0100070004743O002D2O010004743O004B2O012O001D00066O009B000700013O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O0006000600114O00060002000200062O0006003D2O013O0004743O003D2O012O001D000600113O00203A0006000600342O00F00006000200022O001D000700193O00060C0006003F2O0100070004743O003F2O01002E4D004B004B2O01004C0004743O004B2O012O001D0006001A4O00CD0007000A3O00202O00070007004D4O000800086O00060008000200062O0006004B2O013O0004743O004B2O012O001D000600013O0012CA0007004E3O0012CA0008004F4O008C000600084O00A900065O0012CA000500043O002622000500022O0100040004743O00022O010012CA000400043O0004743O00F900010004743O00022O010004743O00F900010004743O00542O010004743O00F4000100262200020010000100040004743O001000010012CA000300013O002E0D0050005D2O0100510004743O005D2O010026220003005D2O0100040004743O005D2O010012CA000200073O0004743O00100001002649000300612O0100010004743O00612O01002E4D005300572O0100520004743O00572O012O001D000400184O00D9000500013O00122O000600543O00122O000700556O00050007000200062O000400862O0100050004743O00862O012O001D00046O009B000500013O00122O000600563O00122O000700576O0005000700024O00040004000500202O0004000400114O00040002000200062O000400862O013O0004743O00862O012O001D000400123O00203A0004000400342O00F00004000200022O001D000500193O0006C2000400862O0100050004743O00862O012O001D0004001A4O00B10005000A3O00202O0005000500584O000600066O00040006000200062O000400812O0100010004743O00812O01002E4D005900862O01005A0004743O00862O012O001D000400013O0012CA0005005B3O0012CA0006005C4O008C000400064O00A900046O001D000400184O00AB000500013O00122O0006005D3O00122O0007005E6O00050007000200062O0004008E2O0100050004743O008E2O010004743O00B62O01002E0D005F00B62O0100600004743O00B62O012O001D00046O009B000500013O00122O000600613O00122O000700626O0005000700024O00040004000500202O0004000400114O00040002000200062O000400B62O013O0004743O00B62O012O001D000400123O00203A0004000400342O00F00004000200022O001D000500193O0006C2000400B62O0100050004743O00B62O012O001D000400033O0020570004000400634O000500126O0004000200024O000500013O00122O000600643O00122O000700656O00050007000200062O000400B62O0100050004743O00B62O012O001D0004001A4O00CD0005000A3O00202O0005000500584O000600066O00040006000200062O000400B62O013O0004743O00B62O012O001D000400013O0012CA000500663O0012CA000600674O008C000400064O00A900045O0012CA000300043O0004743O00572O010004743O001000010004743O00BD2O010004743O000B00010004743O00BD2O010004743O000200012O00473O00017O003D3O00028O00026O00F03F025O00D4AA40025O00909B40025O0090AF40025O00709C40025O0060B040025O00C2A340027O0040030B3O00A8C816B03136EE88C00DBC03073O00A8E4A160D95F5103073O004973526561647903103O004865616C746850657263656E7461676503103O004C6976696E67466C616D65466F637573030E3O0049735370652O6C496E52616E6765030B3O004C6976696E67466C616D6503173O00D7D838552150E4D7225D22529BC23A632752DADD27522803063O0037BBB14E3C4F025O00489840025O002AA24003093O00C6A8A0D1BA4550FBA303073O003994CDD6B4C836030D3O00556E697447726F7570526F6C6503043O0026DC1B1F03053O0016729D5554031A3O00467269656E646C79556E6974735769746842752O66436F756E7403093O00526576657273696F6E030E3O00526576657273696F6E466F63757303193O00D6CE05C14FE5A1CBC52CD05CF8A384D807FB55F3A9C8C21DC303073O00C8A4AB73A43D96025O00509140025O00ADB14003093O008CF1154091ADFD0C4B03053O00E3DE94632503043O0007737CDD03053O0099532O3296025O000FB140025O0008AA4003193O004F73651961B84452784C0872A5461D6567237BAE4C517F7D1B03073O002D3D16137C13CB025O00A0A640025O0021B240025O00908B40026O003540030F3O00F51700E50D62B8CD3303FA0F71B5D803073O00D9A1726D956210031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030F3O0054656D706F72616C416E6F6D616C7903093O004973496E52616E6765026O003E40031B3O000625356CB366132C077DB27B1F213465FC67061F3079BD781B2E3F03063O00147240581CDC03043O001402DABB03073O00DD5161B2D498B003063O0042752O66557003043O004563686F025O008AA240025O00B5B24003093O004563686F466F637573030F3O00C8E415F45ADEF322F31FCCEB14F51D03053O007AAD877D9B0012012O0012CA3O00014O00BE000100023O0026223O0007000100010004743O000700010012CA000100014O00BE000200023O0012CA3O00023O002E4D00040002000100030004743O000200010026223O0002000100020004743O00020001002E0D0006000B000100050004743O000B00010026220001000B000100010004743O000B00010012CA000200013O002E4D0008003A000100070004743O003A00010026220002003A000100090004743O003A00012O001D00036O009B000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300112O013O0004743O00112O012O001D000300023O0006BB000300112O013O0004743O00112O012O001D000300033O00203A00030003000D2O00F00003000200022O001D000400043O0006B9000300112O0100040004743O00112O012O001D000300054O004C000400063O00202O00040004000E4O000500033O00202O00050005000F4O00075O00202O0007000700104O0005000700024O000500056O000600076O00030006000200062O000300112O013O0004743O00112O012O001D000300013O0012C6000400113O00122O000500126O000300056O00035O00044O00112O01002E0D001300B1000100140004743O00B10001002622000200B1000100010004743O00B100010012CA000300014O00BE000400043O00262200030040000100010004743O004000010012CA000400013O00262200040047000100020004743O004700010012CA000200023O0004743O00B1000100262200040043000100010004743O004300012O001D00056O009B000600013O00122O000700153O00122O000800166O0006000800024O00050005000600202O00050005000C4O00050002000200062O0005007800013O0004743O007800012O001D000500083O0006BB0005007800013O0004743O007800012O001D000500093O0020570005000500174O000600036O0005000200024O000600013O00122O000700183O00122O000800196O00060008000200062O00050078000100060004743O007800012O001D000500093O00201200050005001A4O00065O00202O00060006001B4O00050002000200262O00050078000100020004743O007800012O001D000500033O00203A00050005000D2O00F00005000200022O001D0006000A3O0006B900050078000100060004743O007800012O001D000500054O001D000600063O0020D800060006001C2O00F00005000200020006BB0005007800013O0004743O007800012O001D000500013O0012CA0006001D3O0012CA0007001E4O008C000500074O00A900055O002E0D001F00AD000100200004743O00AD00012O001D00056O009B000600013O00122O000700213O00122O000800226O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500AD00013O0004743O00AD00012O001D000500083O0006BB000500AD00013O0004743O00AD00012O001D000500093O0020960005000500174O000600036O0005000200024O000600013O00122O000700233O00122O000800246O00060008000200062O000500AD000100060004743O00AD00012O001D000500093O0020FC00050005001A4O00065O00202O00060006001B4O000700016O00088O00050008000200262O000500AD000100020004743O00AD00012O001D000500033O00203A00050005000D2O00F00005000200022O001D0006000B3O0006B9000500AD000100060004743O00AD00012O001D000500054O001D000600063O0020D800060006001C2O00F0000500020002000699000500A8000100010004743O00A80001002E4D002500AD000100260004743O00AD00012O001D000500013O0012CA000600273O0012CA000700284O008C000500074O00A900055O0012CA000400023O0004743O004300010004743O00B100010004743O0040000100262200020010000100020004743O001000010012CA000300013O002649000300B8000100020004743O00B80001002E0D002A00BA000100290004743O00BA00010012CA000200093O0004743O00100001002E0D002C00B40001002B0004743O00B40001002622000300B4000100010004743O00B400012O001D00046O009B000500013O00122O0006002D3O00122O0007002E6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400E300013O0004743O00E300012O001D0004000C3O0006BB000400E300013O0004743O00E300012O001D000400093O0020A400040004002F4O0005000D6O0006000E6O00040006000200062O000400E300013O0004743O00E300012O001D000400054O00F500055O00202O0005000500304O000600033O00202O00060006003100122O000800326O0006000800024O000600066O000700076O00040007000200062O000400E300013O0004743O00E300012O001D000400013O0012CA000500333O0012CA000600344O008C000400064O00A900046O001D00046O009B000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004000A2O013O0004743O000A2O012O001D0004000F3O0006BB0004000A2O013O0004743O000A2O012O001D000400033O00209E0004000400374O00065O00202O0006000600384O00040006000200062O0004000A2O0100010004743O000A2O012O001D000400033O00203A00040004000D2O00F00004000200022O001D000500103O0006B90004000A2O0100050004743O000A2O01002E4D0039000A2O01003A0004743O000A2O012O001D000400054O001D000500063O0020D800050005003B2O00F00004000200020006BB0004000A2O013O0004743O000A2O012O001D000400013O0012CA0005003C3O0012CA0006003D4O008C000400064O00A900045O0012CA000300023O0004743O00B400010004743O001000010004743O00112O010004743O000B00010004743O00112O010004743O000200012O00473O00017O00133O00028O00026O00F03F025O00BC9C40025O00C09140025O00CCAA40025O00608740025O00E0A140027O0040025O00D88B40025O0079B140025O00FEA740025O00AEA44003063O0045786973747303093O004973496E52616E6765026O003E40025O00C88340025O00A09940025O0068AD40025O00C8A240005F3O0012CA3O00014O00BE000100033O0026493O0006000100020004743O00060001002E0D00030058000100040004743O005800012O00BE000300033O002E1C00050007000100050004743O000E00010026220001000E000100010004743O000E00010012CA000200014O00BE000300033O0012CA000100023O002E4D00060007000100070004743O00070001002O0E00020007000100010004743O000700010026220002001A000100080004743O001A0001002E0D0009005E0001000A0004743O005E00010006BB0003005E00013O0004743O005E00012O0072000300023O0004743O005E000100262200020039000100010004743O003900010012CA000400013O00262200040021000100020004743O002100010012CA000200023O0004743O0039000100264900040025000100010004743O00250001002E4D000B001D0001000C0004743O001D00012O001D00055O0006BB0005003300013O0004743O003300012O001D00055O00203A00050005000D2O00F00005000200020006BB0005003300013O0004743O003300012O001D00055O00203A00050005000E0012CA0007000F4O00FD00050007000200069900050034000100010004743O003400012O00473O00014O001D000500014O00840005000100022O0085000300053O0012CA000400023O0004743O001D000100262200020012000100020004743O001200010012CA000400014O00BE000500053O00264900040041000100010004743O00410001002E0D0011003D000100100004743O003D00010012CA000500013O0026220005004B000100010004743O004B00010006BB0003004700013O0004743O004700012O0072000300024O001D000600024O00840006000100022O0085000300063O0012CA000500023O002E0D00130042000100120004743O0042000100262200050042000100020004743O004200010012CA000200083O0004743O001200010004743O004200010004743O001200010004743O003D00010004743O001200010004743O005E00010004743O000700010004743O005E00010026223O0002000100010004743O000200010012CA000100014O00BE000200023O0012CA3O00023O0004743O000200012O00473O00017O00393O00028O00026O00F03F025O00C6AD40025O003EB040026O001040030D3O00546172676574497356616C6964025O00388740025O00804740025O001EAC40025O008C9040025O006C9540025O0096A340026O000840025O002EAC40025O00D0A340025O00989140025O00B6AC40025O0020AA40025O003EAC40025O00A8B240025O00406A40025O006AA440025O0080A540025O00BEB140025O008EA040025O003C9040025O00207540027O0040025O0023B040025O0002B240025O0021B040026O008540025O00D88F40025O0014AB40025O00207240025O00B88A40025O00F9B140025O005EB140025O00188F40025O0066A040025O00088E40025O004CAF40025O000CA540025O00F6B240025O004EB040025O002AAD40025O0084A440025O00408440025O00EC9840025O003CA040025O008C9940025O00688440025O0034AD40025O00F6AE40025O0086B240025O00D0AF40025O0057B24000ED3O0012CA3O00014O00BE000100023O0026493O0006000100020004743O00060001002E4D000400DC000100030004743O00DC000100262200010028000100050004743O002800010006BB0002000B00013O0004743O000B00012O0072000200024O001D00035O0020D80003000300062O00840003000100020006BB000300EC00013O0004743O00EC00010012CA000300014O00BE000400043O002E0D00080012000100070004743O0012000100262200030012000100010004743O001200010012CA000400013O002E4D000A0017000100090004743O00170001002O0E00010017000100040004743O001700012O001D000500014O00840005000100022O0085000200053O002E4D000B00EC0001000C0004743O00EC00010006BB000200EC00013O0004743O00EC00012O0072000200023O0004743O00EC00010004743O001700010004743O00EC00010004743O001200010004743O00EC00010026490001002C0001000D0004743O002C0001002E1C000E002B0001000F0004743O005500010012CA000300014O00BE000400043O002E0D0010002E000100110004743O002E00010026220003002E000100010004743O002E00010012CA000400013O000E2500020037000100040004743O00370001002E4D00130039000100120004743O003900010012CA000100053O0004743O005500010026490004003D000100010004743O003D0001002E4D00140033000100150004743O003300010012CA000500013O00264900050042000100020004743O00420001002E0D00170044000100160004743O004400010012CA000400023O0004743O00330001002E0D0019003E000100180004743O003E00010026220005003E000100010004743O003E00010006990002004C000100010004743O004C0001002E1C001A00030001001B0004743O004D00012O0072000200024O001D000600024O00840006000100022O0085000200063O0012CA000500023O0004743O003E00010004743O003300010004743O005500010004743O002E0001000E25001C0059000100010004743O00590001002E0D001E00740001001D0004743O007400010012CA000300014O00BE000400043O002E4D0020005B0001001F0004743O005B00010026220003005B000100010004743O005B00010012CA000400013O0026220004006B000100010004743O006B0001002E0D00210067000100220004743O006700010006BB0002006700013O0004743O006700012O0072000200024O001D000500034O00840005000100022O0085000200053O0012CA000400023O002E4D00230060000100240004743O00600001002O0E00020060000100040004743O006000010012CA0001000D3O0004743O007400010004743O006000010004743O007400010004743O005B0001002622000100BD000100010004743O00BD00010012CA000300013O002E0D002600B6000100250004743O00B60001002622000300B6000100010004743O00B600010012CA000400013O002622000400B1000100010004743O00B100012O001D000500043O00069900050086000100010004743O008600012O001D000500053O00069900050086000100010004743O00860001002E4D002800AD000100270004743O00AD00010012CA000500014O00BE000600083O002E0D0029008F0001002A0004743O008F00010026220005008F000100010004743O008F00010012CA000600014O00BE000700073O0012CA000500023O00262200050088000100020004743O008800012O00BE000800083O002E0D002B00990001002C0004743O0099000100262200060099000100010004743O009900010012CA000700014O00BE000800083O0012CA000600023O0026490006009D000100020004743O009D0001002E4D002D00920001002E0004743O00920001002649000700A1000100010004743O00A10001002E4D002F009D000100300004743O009D00012O001D000900064O00840009000100022O0085000800093O0006BB000800AD00013O0004743O00AD00012O0072000800023O0004743O00AD00010004743O009D00010004743O00AD00010004743O009200010004743O00AD00010004743O008800012O001D000500074O00840005000100022O0085000200053O0012CA000400023O0026220004007C000100020004743O007C00010012CA000300023O0004743O00B600010004743O007C0001002E4D00310077000100320004743O00770001002O0E00020077000100030004743O007700010012CA000100023O0004743O00BD00010004743O00770001002E0D00340006000100330004743O0006000100262200010006000100020004743O000600010012CA000300014O00BE000400043O002E1C00353O000100350004743O00C30001002622000300C3000100010004743O00C300010012CA000400013O000E25000100CC000100040004743O00CC0001002E0D003700D3000100360004743O00D300010006BB000200CF00013O0004743O00CF00012O0072000200024O001D000500084O00840005000100022O0085000200053O0012CA000400023O002622000400C8000100020004743O00C800010012CA0001001C3O0004743O000600010004743O00C800010004743O000600010004743O00C300010004743O000600010004743O00EC00010026223O0002000100010004743O000200010012CA000300013O000E25000100E3000100030004743O00E30001002E0D003900E6000100380004743O00E600010012CA000100014O00BE000200023O0012CA000300023O002622000300DF000100020004743O00DF00010012CA3O00023O0004743O000200010004743O00DF00010004743O000200012O00473O00017O00253O00028O00025O0058A140025O0092A640025O0032B340025O002FB140026O00F03F025O0098AC40025O00C6A640025O0080684003163O00557365426C652O73696E676F6674686542726F6E7A6503133O000FC25AF855C68E2AC159FF4ECAA23FC151F14303073O00E04DAE3F8B26AF030A3O0049734361737461626C6503083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E6703133O00426C652O73696E676F6674686542726F6E7A6503203O00864D5D3D97485629BB4E5E1190495D11865357209E44183E96445B218943593A03043O004EE42138030D3O00546172676574497356616C6964025O001EB240025O007CAE40025O00309140025O00309440025O00188140025O006EAB40025O00A07340025O00A8A040025O00208D40025O00F6A640025O000EB140025O0002AF40025O0092AC40025O008C9540025O00D89640025O00FEB140025O002OAE4000AE3O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O00262200010005000100010004743O000500012O001D00025O0006990002000D000100010004743O000D00012O001D000200013O0006BB0002001B00013O0004743O001B00010012CA000200014O00BE000300033O0026220002000F000100010004743O000F00012O001D000400024O00840004000100022O0085000300043O00069900030018000100010004743O00180001002E0D0003001B000100020004743O001B00012O0072000300023O0004743O001B00010004743O000F00012O001D000200033O00069900020020000100010004743O00200001002E0D000400AD000100050004743O00AD00010012CA000200014O00BE000300043O00262200020027000100010004743O002700010012CA000300014O00BE000400043O0012CA000200063O002E1C000700FBFF2O00070004743O0022000100262200020022000100060004743O002200010026220003008D000100060004743O008D0001002E4D00090056000100080004743O0056000100125F0005000A3O0006BB0005005600013O0004743O005600012O001D000500044O009B000600053O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005005600013O0004743O005600012O001D000500063O00201F00050005000E4O000700043O00202O00070007000F4O000800016O00050008000200062O0005004B000100010004743O004B00012O001D000500073O0020950005000500104O000600043O00202O00060006000F4O00050002000200062O0005005600013O0004743O005600012O001D000500084O001D000600043O0020D80006000600112O00F00005000200020006BB0005005600013O0004743O005600012O001D000500053O0012CA000600123O0012CA000700134O008C000500074O00A900056O001D000500073O0020D80005000500142O00840005000100020006BB000500AD00013O0004743O00AD00010012CA000500014O00BE000600083O00262200050062000100010004743O006200010012CA000600014O00BE000700073O0012CA000500063O00264900050066000100060004743O00660001002E0D0015005D000100160004743O005D00012O00BE000800083O00262200060078000100010004743O007800010012CA000900013O0026490009006E000100010004743O006E0001002E4D00180071000100170004743O007100010012CA000700014O00BE000800083O0012CA000900063O00264900090075000100060004743O00750001002E0D001A006A000100190004743O006A00010012CA000600063O0004743O007800010004743O006A000100262200060067000100060004743O006700010026490007007E000100010004743O007E0001002E0D001C007A0001001B0004743O007A00012O001D000900094O00840009000100022O0085000800093O002E1C001D002C0001001D0004743O00AD00010006BB000800AD00013O0004743O00AD00012O0072000800023O0004743O00AD00010004743O007A00010004743O00AD00010004743O006700010004743O00AD00010004743O005D00010004743O00AD000100264900030091000100010004743O00910001002E1C001E009CFF2O001F0004743O002B00010012CA000500013O00264900050096000100010004743O00960001002E4D0020009F000100210004743O009F00012O001D0006000A4O00840006000100022O0085000400063O0006990004009D000100010004743O009D0001002E1C00220003000100230004743O009E00012O0072000400023O0012CA000500063O002649000500A3000100060004743O00A30001002E4D00240092000100250004743O009200010012CA000300063O0004743O002B00010004743O009200010004743O002B00010004743O00AD00010004743O002200010004743O00AD00010004743O000500010004743O00AD00010004743O000200012O00473O00017O0010012O00028O00025O00A89840025O00A08F40026O001C40025O00BEA240025O0074AA40025O0028AB40025O005DB240030C3O004570696353652O74696E677303083O00B88121AFE7857A9803073O001DEBE455DB8EEB03143O0009D1B7CD785C265E1CDAB5D076423E752FDBAFCD03083O00325DB4DABD172E4703083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC03073O000956D991F9750203073O006D5C25BCD49A1D026O00F03F026O000840026O002040027O0040025O0016B140025O0022AD4003083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03103O00909900FC7C78A09D0CC07E54A98B1FCB03063O0016C5EA65AE1903083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB7030F3O00CB11C8F99BA8FE32DB18C7E62O89C003083O00559974A69CECC190025O004AB340025O00B49440025O00E4A640025O002EB040025O00388240025O00A06040026O007B4003083O0037EAB0D7385403FC03063O003A648FC4A35103063O003F412BAC177903083O006E7A2243C35F298503083O0046B44F5EDF7BB64803053O00B615D13B2A03113O008244C03231AEA552D60E282OB065CA1C3303063O00DED737A57D41025O00C09640025O0080B040026O001840025O00889A40025O00A0A240025O002EA540025O00C8AD4003083O00C5F36D158FD2F1E503063O00BC2O961961E603123O00EF9A5A3609E0CA864D0300CCD486520300F403063O008DBAE93F626C03083O00C2EF38A22CFFED3F03053O0045918A4CD603113O0044CA8499B00471C3A887B01B71C390A18F03063O007610AF2OE9DF025O00508740025O0046A240025O0074A740025O00F08B40025O00809540025O0020904003083O00F72A353006CA283203053O006FA44F4144030B3O00F4DC95DB3CF9CFD68DF61E03063O008AA6B9E3BE4E03083O00F871D1235B2D1ED803073O0079AB14A5573243030F3O00F43DAF33AB11CF37B702B80CCD108903063O0062A658D956D9025O00F6A240025O0046AB40025O0082AA4003083O0007B537F23DBE24F503043O008654D043030D3O003FA590551DABA05012A183742303043O003C73CCE603083O00D43FFF64EE34EC6303043O0010875A8B030C3O00616703014B427D46670F3C4003073O0018341466532E34025O005AAE40025O00D8B040025O002OA040025O00689B40025O00E8B140025O0090A940026O00104003083O0098C65F524A443C5E03083O002DCBA32B26232A5B030D3O00F697D9228A8B46D784C82BAF9903073O0034B2E5BC43E7C903083O00122O4410FE52243203073O004341213064973C03103O00FBF5ABD9FEFDF5ABD9E7D7C0BCD7E6CF03053O0093BF87CEB803083O00B13O4BB9C7599103073O003EE22E2O3FD0A9030B3O00D60D5490161E084CEA0C4503083O003E857935E37F6D4F03083O00231126E1DFA0A52O03073O00C270745295B6CE030E3O000CBB493CD2E70F348A5E1DC1F60603073O006E59C82C78A08203083O00B72DB2D5D15DB59703073O00D2E448C6A1B833030E3O00035AF62363C72440E7127FC1394403063O00AE562993701303083O006805991F2C0116B803083O00CB3B60ED6B456F71030D3O001706A5F338E4D52819A3EC19C003073O00B74476CC815190025O004C9040025O00CCAB40026O001440025O00C0514003083O00EB431467A2A5DF5503063O00CBB8266013CB03133O000F766B45CF37675C4CCC2B727A44FB2A727E4403053O00AE59131921034O0003083O001C17465AFE890C3C03073O006B4F72322E97E703103O000FA3A72D8B37A3E534A4A728893C9FF003083O00A059C6D549EA59D703083O007B74A0EACC4676A703053O00A52811D49E03113O00D0CA0D162BE0CB093F22C7D5072035EAD403053O004685B9685303083O003740503EC00A425703053O00A96425244A03103O00258AA742018BA6720C88B1430F2O8A6003043O003060E7C2025O00D2A54003083O00FB5F1A3910D6A89003083O00E3A83A6E4D79B8CF03133O005E31BA52B0D775877733AC53BED656B77429AF03083O00C51B5CDF20D1BB1103083O00305AD7EF0A51C4E803043O009B633FA3030E3O00B7C2A4A1B0928BDFA6ABB5858FD403063O00E4E2B1C1EDD9025O00888140025O00788C40025O00288540025O002FB040025O0046B140025O00E8A14003083O003E34216904700A2203063O001E6D51551D6D03083O00CD7443BF38DAD4CF03073O009C9F1134D656BE03083O009DEAA9A8A7E1BAAF03043O00DCCE8FDD030B3O00B4783A1ED6C8F59472380703073O00B2E61D4D77B8AC025O00F8A340025O0044B340025O00308C4003083O00C6BB1E0F7EF6F2AD03063O009895DE6A7B17030F3O00E835F377BCD023D24AB9DC32FF4CBB03053O00D5BD46962303083O007C50601C465B731B03043O00682F3514030E3O0097458C199806AF4D9515B3018B7C03063O006FC32CE17CDC025O00707F40025O0044964003083O003DA864F0028C09BE03063O00E26ECD10846B03103O00D8D3E9CB48FFC1ECD64EE6E4F2D654FB03053O00218BA380B903083O00645D10CA5E5603CD03043O00BE37386403093O0063BC392C16F4FA58AB03073O009336CF5C7E7383025O0007B34003083O00EDA2D1C97AFF5A1D03083O006EBEC7A5BD13913D03113O00EFF872C789D4D3EF7EE985F4D9EA7BED9803063O00A7BA8B1788EB03083O0029B09C1913BB8F1E03043O006D7AD5E803103O00C1F5B139EAFEA33EDDF4A33CEBE48A0003043O00508E97C2025O00A6A340025O00D0A14003083O00B4F11032AB89F31703053O00C2E794644603163O006F42D5A6E4DA535CD58CF8C45F7BC9AAE2CD4A45D2B703063O00A8262CA1C39603083O00B3F9966239E6B10503083O0076E09CE2165088D603123O006BE04D8550FC4C9056DA519247FD518F4EEA03043O00E0228E39025O0080A74003083O0030C363580AC8705F03043O002C63A61703093O0049E42C0527A56FFE3A03063O00C41C9749565303083O00C0063D048B561F6503083O001693634970E2387803083O008B61E3E684AB5DD203053O00EDD8158295025O00707240025O0038884003083O0018173C418289C53803073O00A24B724835EBE7030D3O00A43945EE470A9F284BEC562ABC03063O0062EC5C24823303083O00971C18AE4CA6B22303083O0050C4796CDA25C8D5030F3O0028720C7B470BAB06750E76481A8F0403073O00EA6013621F2B6E03083O00757F401A3A487D4703053O0053261A346E030B3O007C1E34565D1B05535E113403043O002638774703083O00C0EA4CC22C58F4FC03063O0036938F38B645030E3O00E392FA61DAD78DEB41CCC28EF14C03053O00BFB6E19F29025O00DCB240025O0096A740025O001AA240025O00CCA04003083O00351A46D3A57C8C1503073O00EB667F32A7CC1203113O0078A0FB27482B79AFF62C563E5FB3F0224803063O004E30C195432403083O00031B940C483E199303053O0021507EE07803113O00C5A617C14EFEBD13D06BE5BC0BF748F9A603053O003C8CC863A403083O0097E559A7ED0EA3F303063O0060C4802DD38403084O009E7E77DDB9B1CA03083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F68396903093O002388B24119B3AD490E03043O00246BE7C403083O00FD7BA6178CC079A103053O00E5AE1ED263030A3O002EFE8363EC3E301AE19503073O00597B8DE6318D5D03083O00C074E2181944F46203063O002A9311966C7003103O003AB52857E2E903AF2378D7E71BAF227103063O00886FC64D1F8703083O00310CB342B4EA10BA03083O00C96269C736DD847703113O009109822D0B3BAB890397280D3B82B8018603073O00CCD96CE341625503083O006DC6E1F125CE59D003063O00A03EA395854C030F3O00FEA50C23CAD8A73D20D7DFAF0307F303053O00A3B6C06D4F03083O00072314D4FC3A211303053O0095544660A003163O000D1508CF34031EFE31080AC23E3205E81A1402E3222O03043O008D58666D03083O008056DE64133352D203083O00A1D333AA107A5D35030D3O00DFA7A138FEA2962DF9BBB42EE803043O00489BCED200CA032O0012CA3O00014O00BE000100013O0026493O0006000100010004743O00060001002E4D00020002000100030004743O000200010012CA000100013O0026490001000B000100040004743O000B0001002E0D00060087000100050004743O008700010012CA000200013O00264900020010000100010004743O00100001002E0D0008002C000100070004743O002C000100125F000300094O0034000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400062O0003001E000100010004743O001E00010012CA000300014O006E00035O001219000300096O000400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000300023O00122O000200123O00262200020030000100130004743O003000010012CA000100143O0004743O0087000100264900020034000100150004743O00340001002E4D0016005A000100170004743O005A00010012CA000300013O00262200030053000100010004743O0053000100125F000400094O00C1000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000400033O00122O000400096O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O00040004000500062O00040051000100010004743O005100010012CA000400014O006E000400043O0012CA000300123O00264900030057000100120004743O00570001002E4D00200035000100210004743O003500010012CA000200133O0004743O005A00010004743O003500010026490002005E000100120004743O005E0001002E0D0023000C000100220004743O000C00010012CA000300013O002E4D00250065000100240004743O0065000100262200030065000100120004743O006500010012CA000200153O0004743O000C0001002E1C002600FAFF2O00260004743O005F00010026220003005F000100010004743O005F000100125F000400094O0034000500013O00122O000600273O00122O000700286O0005000700024O0004000400054O000500013O00122O000600293O00122O0007002A6O0005000700024O00040004000500062O00040077000100010004743O007700010012CA000400014O006E000400053O001219000400096O000500013O00122O0006002B3O00122O0007002C6O0005000700024O0004000400054O000500013O00122O0006002D3O00122O0007002E6O0005000700024O0004000400054O000400063O00122O000300123O0004743O005F00010004743O000C0001002E4D002F00122O0100300004743O00122O01002622000100122O0100310004743O00122O010012CA000200014O00BE000300033O0026220002008D000100010004743O008D00010012CA000300013O000E2500130094000100030004743O00940001002E4D00330096000100320004743O009600010012CA000100043O0004743O00122O01002E0D003400B6000100350004743O00B60001002622000300B6000100150004743O00B6000100125F000400094O00C1000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000500013O00122O000600383O00122O000700396O0005000700024O0004000400054O000400073O00122O000400096O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500013O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500062O000400B4000100010004743O00B400010012CA000400014O006E000400083O0012CA000300133O002649000300BA000100120004743O00BA0001002E4D003F00E50001003E0004743O00E500010012CA000400013O002E4D004100C1000100400004743O00C10001002622000400C1000100120004743O00C100010012CA000300153O0004743O00E50001002649000400C5000100010004743O00C50001002E4D004200BB000100430004743O00BB000100125F000500094O0034000600013O00122O000700443O00122O000800456O0006000800024O0005000500064O000600013O00122O000700463O00122O000800476O0006000800024O00050005000600062O000500D3000100010004743O00D300010012CA000500014O006E000500093O0012D5000500096O000600013O00122O000700483O00122O000800496O0006000800024O0005000500064O000600013O00122O0007004A3O00122O0008004B6O0006000800024O00050005000600062O000500E2000100010004743O00E200010012CA000500014O006E0005000A3O0012CA000400123O0004743O00BB000100262200030090000100010004743O009000010012CA000400013O002E1C004C00060001004C0004743O00EE0001002622000400EE000100120004743O00EE00010012CA000300123O0004743O00900001002E0D004E00E80001004D0004743O00E80001002622000400E8000100010004743O00E8000100125F000500094O0034000600013O00122O0007004F3O00122O000800506O0006000800024O0005000500064O000600013O00122O000700513O00122O000800526O0006000800024O00050005000600062O00052O002O0100010004744O002O010012CA000500014O006E0005000B3O001219000500096O000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O000600013O00122O000700553O00122O000800566O0006000800024O0005000500064O0005000C3O00122O000400123O0004743O00E800010004743O009000010004743O00122O010004743O008D0001002649000100162O0100130004743O00162O01002E0D005800832O0100570004743O00832O010012CA000200014O00BE000300033O0026490002001C2O0100010004743O001C2O01002E0D005900182O01005A0004743O00182O010012CA000300013O002649000300212O0100130004743O00212O01002E4D005B00232O01005C0004743O00232O010012CA0001005D3O0004743O00832O01002O0E001200442O0100030004743O00442O0100125F000400094O0034000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000500013O00122O000600603O00122O000700616O0005000700024O00040004000500062O000400332O0100010004743O00332O010012CA000400014O006E0004000D3O0012D5000400096O000500013O00122O000600623O00122O000700636O0005000700024O0004000400054O000500013O00122O000600643O00122O000700656O0005000700024O00040004000500062O000400422O0100010004743O00422O010012CA000400014O006E0004000E3O0012CA000300153O002622000300622O0100010004743O00622O0100125F000400094O0034000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O000500013O00122O000600683O00122O000700696O0005000700024O00040004000500062O000400542O0100010004743O00542O010012CA000400014O006E0004000F3O001219000400096O000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000500013O00122O0006006C3O00122O0007006D6O0005000700024O0004000400054O000400103O00122O000300123O0026220003001D2O0100150004743O001D2O0100125F000400094O00C1000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000500013O00122O000600703O00122O000700716O0005000700024O0004000400054O000400113O00122O000400096O000500013O00122O000600723O00122O000700736O0005000700024O0004000400054O000500013O00122O000600743O00122O000700756O0005000700024O00040004000500062O0004007E2O0100010004743O007E2O010012CA000400014O006E000400123O0012CA000300133O0004743O001D2O010004743O00832O010004743O00182O01002E4D007600F42O0100770004743O00F42O01002622000100F42O0100780004743O00F42O010012CA000200014O00BE000300033O002622000200892O0100010004743O00892O010012CA000300013O002E1C00790006000100790004743O00922O01002622000300922O0100130004743O00922O010012CA000100313O0004743O00F42O01002622000300B32O0100010004743O00B32O0100125F000400094O0034000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500062O000400A22O0100010004743O00A22O010012CA0004007E4O006E000400133O0012D5000400096O000500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O00040004000500062O000400B12O0100010004743O00B12O010012CA000400014O006E000400143O0012CA000300123O002622000300D12O0100120004743O00D12O0100125F000400094O00C1000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O000400153O00122O000400096O000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000500013O00122O000600893O00122O0007008A6O0005000700024O00040004000500062O000400CF2O0100010004743O00CF2O010012CA000400014O006E000400163O0012CA000300153O002E1C008B00BBFF2O008B0004743O008C2O010026220003008C2O0100150004743O008C2O0100125F000400094O0034000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400054O000500013O00122O0006008E3O00122O0007008F6O0005000700024O00040004000500062O000400E32O0100010004743O00E32O010012CA000400014O006E000400173O001219000400096O000500013O00122O000600903O00122O000700916O0005000700024O0004000400054O000500013O00122O000600923O00122O000700936O0005000700024O0004000400054O000400183O00122O000300133O0004743O008C2O010004743O00F42O010004743O00892O01002649000100F82O01005D0004743O00F82O01002E0D00950073020100940004743O007302010012CA000200014O00BE000300033O000E25000100FE2O0100020004743O00FE2O01002E4D009700FA2O0100960004743O00FA2O010012CA000300013O002E0D0099002C020100980004743O002C02010026220003002C020100120004743O002C02010012CA000400013O00262200040025020100010004743O0025020100125F000500094O0034000600013O00122O0007009A3O00122O0008009B6O0006000800024O0005000500064O000600013O00122O0007009C3O00122O0008009D6O0006000800024O00050005000600062O00050014020100010004743O001402010012CA000500014O006E000500193O0012D5000500096O000600013O00122O0007009E3O00122O0008009F6O0006000800024O0005000500064O000600013O00122O000700A03O00122O000800A16O0006000800024O00050005000600062O00050023020100010004743O002302010012CA000500014O006E0005001A3O0012CA000400123O000E2500120029020100040004743O00290201002E4D00060004020100A20004743O000402010012CA000300153O0004743O002C02010004743O0004020100264900030030020100150004743O00300201002E0D00A3004C020100A40004743O004C020100125F000400094O00C1000500013O00122O000600A53O00122O000700A66O0005000700024O0004000400054O000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O0004001B3O00122O000400096O000500013O00122O000600A93O00122O000700AA6O0005000700024O0004000400054O000500013O00122O000600AB3O00122O000700AC6O0005000700024O00040004000500062O0004004A020100010004743O004A02010012CA000400014O006E0004001C3O0012CA000300133O00264900030050020100010004743O00500201002E4D00AE006C020100AD0004743O006C020100125F000400094O0034000500013O00122O000600AF3O00122O000700B06O0005000700024O0004000400054O000500013O00122O000600B13O00122O000700B26O0005000700024O00040004000500062O0004005E020100010004743O005E02010012CA000400014O006E0004001D3O001219000400096O000500013O00122O000600B33O00122O000700B46O0005000700024O0004000400054O000500013O00122O000600B53O00122O000700B66O0005000700024O0004000400054O0004001E3O00122O000300123O002622000300FF2O0100130004743O00FF2O010012CA000100783O0004743O007302010004743O00FF2O010004743O007302010004743O00FA2O01002E1C00B70073000100B70004743O00E60201002622000100E6020100150004743O00E602010012CA000200013O0026220002009E020100120004743O009E02010012CA000300013O0026220003007F020100120004743O007F02010012CA000200153O0004743O009E02010026220003007B020100010004743O007B020100125F000400094O00C1000500013O00122O000600B83O00122O000700B96O0005000700024O0004000400054O000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O0004001F3O00122O000400096O000500013O00122O000600BC3O00122O000700BD6O0005000700024O0004000400054O000500013O00122O000600BE3O00122O000700BF6O0005000700024O00040004000500062O0004009B020100010004743O009B02010012CA000400014O006E000400203O0012CA000300123O0004743O007B0201002E0D00C100A4020100C00004743O00A40201002622000200A4020100130004743O00A402010012CA000100133O0004743O00E60201002622000200C5020100010004743O00C5020100125F000300094O0034000400013O00122O000500C23O00122O000600C36O0004000600024O0003000300044O000400013O00122O000500C43O00122O000600C56O0004000600024O00030003000400062O000300B4020100010004743O00B402010012CA000300014O006E000300213O0012D5000300096O000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000400013O00122O000500C83O00122O000600C96O0004000600024O00030003000400062O000300C3020100010004743O00C302010012CA000300014O006E000300223O0012CA000200123O002E1C00CA00B3FF2O00CA0004743O00780201002O0E00150078020100020004743O0078020100125F000300094O00C1000400013O00122O000500CB3O00122O000600CC6O0004000600024O0003000300044O000400013O00122O000500CD3O00122O000600CE6O0004000600024O0003000300044O000300233O00122O000300096O000400013O00122O000500CF3O00122O000600D06O0004000600024O0003000300044O000400013O00122O000500D13O00122O000600D26O0004000600024O00030003000400062O000300E3020100010004743O00E302010012CA000300014O006E000300243O0012CA000200133O0004743O0078020100262200010054030100120004743O005403010012CA000200013O002E0D00D3000C030100D40004743O000C03010026220002000C030100120004743O000C030100125F000300094O0034000400013O00122O000500D53O00122O000600D66O0004000600024O0003000300044O000400013O00122O000500D73O00122O000600D86O0004000600024O00030003000400062O000300FB020100010004743O00FB02010012CA000300014O006E000300253O0012D5000300096O000400013O00122O000500D93O00122O000600DA6O0004000600024O0003000300044O000400013O00122O000500DB3O00122O000600DC6O0004000600024O00030003000400062O0003000A030100010004743O000A03010012CA000300014O006E000300263O0012CA000200153O002O0E0001002A030100020004743O002A030100125F000300094O0034000400013O00122O000500DD3O00122O000600DE6O0004000600024O0003000300044O000400013O00122O000500DF3O00122O000600E06O0004000600024O00030003000400062O0003001C030100010004743O001C03010012CA000300014O006E000300273O001219000300096O000400013O00122O000500E13O00122O000600E26O0004000600024O0003000300044O000400013O00122O000500E33O00122O000600E46O0004000600024O0003000300044O000300283O00122O000200123O0026490002002E030100130004743O002E0301002E4D00E50030030100E60004743O003003010012CA000100153O0004743O00540301002E4D00E800E9020100E70004743O00E90201002622000200E9020100150004743O00E9020100125F000300094O0034000400013O00122O000500E93O00122O000600EA6O0004000600024O0003000300044O000400013O00122O000500EB3O00122O000600EC6O0004000600024O00030003000400062O00030042030100010004743O004203010012CA000300014O006E000300293O0012D5000300096O000400013O00122O000500ED3O00122O000600EE6O0004000600024O0003000300044O000400013O00122O000500EF3O00122O000600F06O0004000600024O00030003000400062O00030051030100010004743O005103010012CA000300014O006E0003002A3O0012CA000200133O0004743O00E9020100262200010072030100140004743O0072030100125F000200094O00C1000300013O00122O000400F13O00122O000500F26O0003000500024O0002000200034O000300013O00122O000400F33O00122O000500F46O0003000500024O0002000200034O0002002B3O00122O000200096O000300013O00122O000400F53O00122O000500F66O0003000500024O0002000200034O000300013O00122O000400F73O00122O000500F86O0003000500024O00020002000300062O00020070030100010004743O007003010012CA000200014O006E0002002C3O0004743O00C9030100262200010007000100010004743O0007000100125F000200094O00E3000300013O00122O000400F93O00122O000500FA6O0003000500024O0002000200034O000300013O00122O000400FB3O00122O000500FC6O0003000500024O0002000200034O0002002D3O00122O000200096O000300013O00122O000400FD3O00122O000500FE6O0003000500024O0002000200034O000300013O00122O000400FF3O00122O00052O00015O0003000500024O0002000200034O0002002E3O00122O000200096O000300013O00122O0004002O012O00122O00050002015O0003000500024O0002000200034O000300013O00122O00040003012O00122O00050004015O0003000500024O00020002000300062O0002009A030100010004743O009A03010012CA000200014O006E0002002F3O0012D5000200096O000300013O00122O00040005012O00122O00050006015O0003000500024O0002000200034O000300013O00122O00040007012O00122O00050008015O0003000500024O00020002000300062O000200A9030100010004743O00A903010012CA000200014O006E000200303O001203000200096O000300013O00122O00040009012O00122O0005000A015O0003000500024O0002000200034O000300013O00122O0004000B012O00122O0005000C015O0003000500024O0002000200034O000200313O00122O000200096O000300013O00122O0004000D012O00122O0005000E015O0003000500024O0002000200034O000300013O00122O0004000F012O00122O00050010015O0003000500024O00020002000300062O000200C4030100010004743O00C403010012CA000200014O006E000200323O0012CA000100123O0004743O000700010004743O00C903010004743O000200012O00473O00017O001B3O00028O00026O00F03F025O0098A840025O00188740030C3O004570696353652O74696E677303083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803103O00081BE30D212FEA052B01F22B3E06F31C03043O006C4C6986025O00E0B140025O003AB240025O0006AE40025O00ACA740025O00B4A340025O00C09840025O005AA940025O006AB140025O0014A74003083O006EB0B69354BBA59403043O00E73DD5C203103O002DBF3872048B317A0EA529461AAC3A7603043O001369CD5D034O0003083O009A0DCA9536A70FCD03053O005FC968BEE1030D3O008BD9C4CFA2EDCDC7A8C3D5E69F03043O00AECFABA100673O0012CA3O00014O00BE000100023O0026493O0006000100020004743O00060001002E1C0003005C000100040004743O0060000100262200010006000100010004743O000600010012CA000200013O0026220002001B000100020004743O001B000100125F000300054O0034000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O00030003000400062O00030019000100010004743O001900010012CA000300014O006E00035O0004743O0066000100262200020009000100010004743O000900010012CA000300014O00BE000400043O002E0D000A001F0001000B0004743O001F00010026220003001F000100010004743O001F00010012CA000400013O00264900040028000100020004743O00280001002E1C000C00040001000D0004743O002A00010012CA000200023O0004743O00090001002E0D000F00240001000E0004743O0024000100262200040024000100010004743O002400010012CA000500013O002E1C00100006000100100004743O0035000100262200050035000100020004743O003500010012CA000400023O0004743O0024000100264900050039000100010004743O00390001002E4D0011002F000100120004743O002F000100125F000600054O0034000700013O00122O000800133O00122O000900146O0007000900024O0006000600074O000700013O00122O000800153O00122O000900166O0007000900024O00060006000700062O00060047000100010004743O004700010012CA000600174O006E000600023O0012D5000600056O000700013O00122O000800183O00122O000900196O0007000900024O0006000600074O000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700062O00060056000100010004743O005600010012CA000600014O006E000600033O0012CA000500023O0004743O002F00010004743O002400010004743O000900010004743O001F00010004743O000900010004743O006600010004743O000600010004743O006600010026223O0002000100010004743O000200010012CA000100014O00BE000200023O0012CA3O00023O0004743O000200012O00473O00017O00E73O00028O00026O001440025O0040A040025O00307D40026O004D40025O00508340026O00F03F025O00D88B40025O008EAC4003113O00476574456E656D696573496E52616E6765026O00394003173O00476574456E656D696573496E53706C61736852616E6765026O002040025O00BFB040025O004CAC40026O004140025O0012A440026O001840030D3O004973446561644F7247686F7374025O0078A640025O00AC9440030C3O0049734368612O6E656C696E67030B3O00447265616D427265617468025O00B89F40025O00E09F40025O0050854003073O0047657454696D6503093O00436173745374617274030F3O00456D706F7765724361737454696D65025O00D07040025O009CA240025O00208A40025O0024B040030D3O000969ED5B1F7CF04C2577E34B1F03043O00384C1984030B3O007AD3AE27C27CD3AE27DB5603053O00AF3EA1CB4603083O000ED8D7062732F4E703053O00555CBDA37303143O001AB83F2839A53E3F6988223D28A1122A2CAD243003043O005849CC50025O005AA740025O009C9040025O00CCA240025O002AA940026O001C40025O00DEAB40025O006BB140025O00109D40025O0022A040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0096A040025O001EB340025O0046AC40025O00A8A040025O000EAA40024O0080B3C540030C3O00466967687452656D61696E73025O007DB140025O0022AC4003103O00426F2O73466967687452656D61696E73025O002CAB40025O00688240025O00109B40025O00406040030A3O0046697265427265617468025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA40025O0084AB40025O00C4A040025O0046AB40025O0074A940030D3O009199D92D0FA821A080DE292F9E03073O0055D4E9B04E5CCD030A3O006C519AE7684A8DE35E5003043O00822A38E803083O00D8B030F65231C39103063O005F8AD544832003143O00193CAE53662326A60350233AA40354382DA0577E03053O00164A48C123025O0061B140025O0078AC40025O00206340025O007C9D40025O00949B40026O008440030C3O004570696353652O74696E677303073O0074A7A0E41C45BB03053O007020C8C7832O033O002F544F03073O00424C303CD8A3CB027O004003073O00DFCAB6E6C2EED603053O00AE8BA5D1812O033O00ACBCE103083O0018C3D382A1A6631003073O00720CEE2B5F135503063O00762663894C332O033O00FC290003063O00409D46657269030B3O00537069726974626C2O6F6D026O006940025O00B6AF40025O0014A940025O00E09540025O00909540025O002EAE40025O00E06640025O001AAA40025O00A07A40025O0098A940025O0010AC40025O00F8AF40030D3O000B9319451ADF3A9719482EC91D03063O00BA4EE3702649030B3O00CF47F4475A6EFE5BF25A5E03063O001A9C379D353303083O00BEDD02CCAA5EA5FC03063O0030ECB876B9D803143O00D6A95820DF3DEBBA1703DF3DF7B44332C33BEAB003063O005485DD3750AF025O0068AA4003063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O00E9B240025O00F5B140025O00F4AE4003163O0044656164467269656E646C79556E697473436F756E74025O00E2A740025O006AA040030A3O004D612O7352657475726E030B3O00B0E637B5F84EB8F331B4C903063O003CDD8744C6A703063O0052657475726E03093O004973496E52616E6765026O003E40025O0012AF40025O0050B24003063O00FCB8EC9650D703063O00B98EDD98E322025O00308840025O00707C40026O008A40025O0056A240025O00389E40025O00B2A540025O00E08240025O003DB240025O0050A040025O00B6A240025O00209F40025O0074A44003073O008E897EF453CB3703073O0044DAE619933FAE03063O00A923405CB3A103053O00D6CD4A332C03093O0049734D6F756E746564025O00ECA940025O00207A4003083O0049734D6F76696E67026O000840025O00C6AF40025O00D2A340025O0049B040025O00B8AF40025O00805540025O00F08240025O002AA34003073O00DF54F2E979FD4903053O00179A2C829C03073O004973526561647903093O00466F637573556E6974026O003440025O00E8A440025O0083B040025O00B07140025O000EA640025O0092B040025O00E07640025O0068B240025O0060A740025O00289740025O00D09640025O00606540025O0053B240025O00FAA040025O00E8B240030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O0058AE40025O00089540025O0040AA40025O00E89040026O00A640025O00ECAD40025O00E8B040025O002C9140025O0092B240025O0007B340025O001CB34003113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572025O00B2A240025O00809940026O001040025O00DCA240025O00C0984003053O0039A9BBAB2403063O007371C6CDCE5603083O0042752O66446F776E03053O00486F766572025O00DAA140025O0032A040030C3O008C58E85F9617F35B8D59BE0803043O003AE4379E030B3O0042752O6652656D61696E7303093O00486F76657242752O66025O009CA640025O00DEA54003273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E74025O0040554000DA032O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O00262200010035000100020004743O003500010012CA000200013O0026490002000C000100010004743O000C0001002E4D00030023000100040004743O002300010012CA000300013O002E0D00050013000100060004743O0013000100262200030013000100070004743O001300010012CA000200073O0004743O0023000100264900030017000100010004743O00170001002E0D0009000D000100080004743O000D00012O001D000400013O00207E00040004000A00122O0006000B6O0004000600024O00048O000400033O00202O00040004000C00122O0006000D6O0004000600024O000400023O00122O000300073O00044O000D000100264900020027000100070004743O00270001002E0D000E00080001000F0004743O00080001002E4D00100030000100110004743O003000012O001D000300043O0006BB0003003000013O0004743O003000012O001D000300024O00A7000300034O006E000300053O0004743O003200010012CA000300074O006E000300053O0012CA000100123O0004743O003500010004743O0008000100262200010054000100010004743O005400010012CA000200013O002O0E00070042000100020004743O004200012O001D000300013O00203A0003000300132O00F00003000200020006BB0003004000013O0004743O004000012O00473O00013O0012CA000100073O0004743O0054000100262200020038000100010004743O003800010012CA000300013O0026220003004C000100010004743O004C00012O001D000400064O004B0004000100012O001D000400074O004B0004000100010012CA000300073O00264900030050000100070004743O00500001002E1C001400F7FF2O00150004743O004500010012CA000200073O0004743O003800010004743O004500010004743O003800010026220001005A2O0100120004743O005A2O010012CA000200013O002622000200B6000100070004743O00B600012O001D000300013O00202A0003000300164O000500083O00202O0005000500174O00030005000200062O000300B400013O0004743O00B400010012CA000300014O00BE000400053O002E1C00180040000100180004743O00A20001002622000300A2000100070004743O00A200010026490004006A000100010004743O006A0001002E1C001900FEFF2O001A0004743O0066000100125F0006001B4O00480006000100024O000700013O00202O00070007001C4O0007000200024O0005000600074O000600013O00202O00060006001D4O000800096O00060008000200062O000500B4000100060004743O00B40001002E0D001F00790001001E0004743O007900010004743O00B400010012CA000600014O00BE000700073O002E0D0020007B000100210004743O007B00010026220006007B000100010004743O007B00010012CA000700013O00262200070080000100010004743O008000010012CA000800013O00262200080083000100010004743O008300012O001D0009000A4O0080000A000B3O00122O000B00223O00122O000C00236O000A000C00024O000B00086O000C000B3O00122O000D00243O00122O000E00256O000C000E00024O000B000B000C4O000C000B3O00122O000D00263O00122O000E00276O000C000E00024O000B000B000C4O0009000A000B4O0009000B3O00122O000A00283O00122O000B00296O0009000B6O00095O00044O008300010004743O008000010004743O00B400010004743O007B00010004743O00B400010004743O006600010004743O00B40001002E4D002B00620001002A0004743O0062000100262200030062000100010004743O006200010012CA000600013O002622000600AC000100010004743O00AC00010012CA000400014O00BE000500053O0012CA000600073O002E4D002C00A70001002D0004743O00A70001002622000600A7000100070004743O00A700010012CA000300073O0004743O006200010004743O00A700010004743O006200010012CA0001002E3O0004743O005A2O01002E0D002F0057000100300004743O0057000100262200020057000100010004743O005700010012CA000300013O002649000300BF000100070004743O00BF0001002E4D003200C1000100310004743O00C100010012CA000200073O0004743O00570001002622000300BB000100010004743O00BB00012O001D0004000C3O0020D80004000400332O0084000400010002000699000400CD000100010004743O00CD00012O001D000400013O00203A0004000400342O00F00004000200020006BB000400062O013O0004743O00062O010012CA000400014O00BE000500053O002649000400D3000100010004743O00D30001002E4D003600CF000100350004743O00CF00010012CA000500013O002E1C00370010000100370004743O00E40001002622000500E4000100070004743O00E40001002E0D003800062O0100390004743O00062O012O001D0006000D3O002622000600062O01003A0004743O00062O012O001D0006000A3O00204000060006003B4O00078O00088O0006000800024O0006000D3O00044O00062O01002622000500D4000100010004743O00D400010012CA000600013O002649000600EB000100070004743O00EB0001002E4D003C00ED0001003D0004743O00ED00010012CA000500073O0004743O00D40001002622000600E7000100010004743O00E700010012CA000700013O002622000700FB000100010004743O00FB00012O001D0008000A3O00209200080008003E4O000900096O000A00016O0008000A00024O0008000E6O0008000E6O0008000D3O00122O000700073O002649000700FF000100070004743O00FF0001002E1C003F00F3FF2O00400004743O00F000010012CA000600073O0004743O00E700010004743O00F000010004743O00E700010004743O00D400010004743O00062O010004743O00CF0001002E4D004200572O0100410004743O00572O012O001D000400013O00202A0004000400164O000600083O00202O0006000600434O00040006000200062O000400572O013O0004743O00572O010012CA000400014O00BE000500063O002649000400152O0100070004743O00152O01002E0D0045004F2O0100440004743O004F2O01002E4D004600152O0100470004743O00152O01002622000500152O0100010004743O00152O0100125F0007001B5O000107000100024O000800013O00202O00080008001C4O0008000200024O000600070008002E2O004800282O0100490004743O00282O012O001D000700013O00203A00070007001D2O001D0009000F4O00FD0007000900020006C2000600282O0100070004743O00282O010004743O00572O010012CA000700014O00BE000800083O0026490007002E2O0100010004743O002E2O01002E0D004A002A2O01004B0004743O002A2O010012CA000800013O000E25000100332O0100080004743O00332O01002E4D004C002F2O01004D0004743O002F2O012O001D0009000A4O0080000A000B3O00122O000B004E3O00122O000C004F6O000A000C00024O000B00086O000C000B3O00122O000D00503O00122O000E00516O000C000E00024O000B000B000C4O000C000B3O00122O000D00523O00122O000E00536O000C000E00024O000B000B000C4O0009000A000B4O0009000B3O00122O000A00543O00122O000B00556O0009000B6O00095O00044O002F2O010004743O00572O010004743O002A2O010004743O00572O010004743O00152O010004743O00572O01002649000400532O0100010004743O00532O01002E0D005600112O0100570004743O00112O010012CA000500014O00BE000600063O0012CA000400073O0004743O00112O010012CA000300073O0004743O00BB00010004743O00570001000E250007005E2O0100010004743O005E2O01002E4D005900932O0100580004743O00932O010012CA000200014O00BE000300033O002E0D005B00602O01005A0004743O00602O01002622000200602O0100010004743O00602O010012CA000300013O002O0E000700752O0100030004743O00752O0100125F0004005C4O00790005000B3O00122O0006005D3O00122O0007005E6O0005000700024O0004000400054O0005000B3O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000400103O00122O000100613O00044O00932O01002622000300652O0100010004743O00652O0100125F0004005C4O001A0005000B3O00122O000600623O00122O000700636O0005000700024O0004000400054O0005000B3O00122O000600643O00122O000700656O0005000700024O0004000400054O000400113O00122O0004005C6O0005000B3O00122O000600663O00122O000700676O0005000700024O0004000400054O0005000B3O00122O000600683O00122O000700696O0005000700024O0004000400054O000400043O00122O000300073O00044O00652O010004743O00932O010004743O00602O010026220001008F0201002E0004743O008F02012O001D000200013O00202A0002000200164O000400083O00202O00040004006A4O00020004000200062O000200F62O013O0004743O00F62O010012CA000200014O00BE000300053O002E0D006B00F02O01006C0004743O00F02O01002O0E000700F02O0100020004743O00F02O012O00BE000500053O002622000300E92O0100070004743O00E92O01002649000400A92O0100010004743O00A92O01002E4D006D00A52O01006E0004743O00A52O0100125F0006001B4O00F20006000100024O000700013O00202O00070007001C4O0007000200024O000500060007002E2O006F00B82O0100700004743O00B82O012O001D000600013O00203A00060006001D2O001D000800124O00FD0006000800020006C2000500B82O0100060004743O00B82O010004743O00F62O010012CA000600014O00BE000700073O002E4D007100BA2O0100720004743O00BA2O01002622000600BA2O0100010004743O00BA2O010012CA000700013O002649000700C32O0100010004743O00C32O01002E0D007400BF2O0100730004743O00BF2O010012CA000800013O002622000800C42O0100010004743O00C42O010012CA000900013O002649000900CB2O0100010004743O00CB2O01002E1C007500FEFF2O00760004743O00C72O012O001D000A000A4O0080000B000B3O00122O000C00773O00122O000D00786O000B000D00024O000C00086O000D000B3O00122O000E00793O00122O000F007A6O000D000F00024O000C000C000D4O000D000B3O00122O000E007B3O00122O000F007C6O000D000F00024O000C000C000D4O000A000B000C4O000A000B3O00122O000B007D3O00122O000C007E6O000A000C6O000A5O00044O00C72O010004743O00C42O010004743O00BF2O010004743O00F62O010004743O00BA2O010004743O00F62O010004743O00A52O010004743O00F62O01002622000300A32O0100010004743O00A32O010012CA000400014O00BE000500053O0012CA000300073O0004743O00A32O010004743O00F62O010026220002009E2O0100010004743O009E2O010012CA000300014O00BE000400043O0012CA000200073O0004743O009E2O01002E1C007F005B0001007F0004743O005102012O001D000200033O0006BB0002005102013O0004743O005102012O001D000200033O00203A0002000200802O00F00002000200020006BB0002005102013O0004743O005102012O001D000200033O00203A0002000200812O00F00002000200020006BB0002005102013O0004743O005102012O001D000200033O00203A0002000200132O00F00002000200020006BB0002005102013O0004743O005102012O001D000200013O00203A0002000200822O001D000400034O00FD00020004000200069900020051020100010004743O005102010012CA000200014O00BE000300043O002E4D00840019020100830004743O0019020100262200020019020100010004743O001902010012CA000300014O00BE000400043O0012CA000200073O002E1C008500F9FF2O00850004743O0012020100262200020012020100070004743O001202010026220003001D020100010004743O001D02012O001D0005000C3O0020860005000500864O0005000100024O000400056O000500013O00202O0005000500344O00050002000200062O0005002A02013O0004743O002A0201002E4D00870051020100880004743O00510201000E700007003A020100040004743O003A02012O001D000500134O00D0000600083O00202O0006000600894O000700076O000800016O00050008000200062O0005005102013O0004743O005102012O001D0005000B3O0012C60006008A3O00122O0007008B6O000500076O00055O00044O005102012O001D000500134O0078000600083O00202O00060006008C4O000700033O00202O00070007008D00122O0009008E6O0007000900024O000700076O000800016O00050008000200062O00050048020100010004743O00480201002E4D009000510201008F0004743O005102012O001D0005000B3O0012C6000600913O00122O000700926O000500076O00055O00044O005102010004743O001D02010004743O005102010004743O001202012O001D000200013O00203A0002000200162O00F00002000200020006BB0002005802013O0004743O00580201002E0D009300D9030100940004743O00D903012O001D000200013O00203A0002000200342O00F00002000200020006990002005F020100010004743O005F0201002E1C0095001C000100960004743O007902010012CA000200014O00BE000300043O00264900020065020100010004743O00650201002E1C00970005000100980004743O006802010012CA000300014O00BE000400043O0012CA000200073O00262200020061020100070004743O006102010026220003006A020100010004743O006A02012O001D000500144O00840005000100022O0085000400053O00069900040073020100010004743O00730201002E1C009900682O01009A0004743O00D903012O0072000400023O0004743O00D903010004743O006A02010004743O00D903010004743O006102010004743O00D903010012CA000200014O00BE000300043O00262200020088020100070004743O00880201002O0E0001007D020100030004743O007D02012O001D000500154O00840005000100022O0085000400053O0006BB000400D903013O0004743O00D903012O0072000400023O0004743O00D903010004743O007D02010004743O00D903010026220002007B020100010004743O007B02010012CA000300014O00BE000400043O0012CA000200073O0004743O007B02010004743O00D9030100264900010093020100610004743O00930201002E0D009C00C80201009B0004743O00C802010012CA000200014O00BE000300033O002E4D009D00950201009E0004743O0095020100262200020095020100010004743O009502010012CA000300013O002622000300B9020100010004743O00B902010012CA000400013O002622000400A1020100070004743O00A102010012CA000300073O0004743O00B902010026220004009D020100010004743O009D020100125F0005005C4O004F0006000B3O00122O0007009F3O00122O000800A06O0006000800024O0005000500064O0006000B3O00122O000700A13O00122O000800A26O0006000800024O0005000500064O000500166O000500013O00202O0005000500A34O00050002000200062O000500B6020100010004743O00B60201002E1C00A40003000100A50004743O00B702012O00473O00013O0012CA000400073O0004743O009D0201002O0E0007009A020100030004743O009A02012O001D000400013O00203A0004000400A62O00F0000400020002000699000400C3020100010004743O00C3020100125F0004001B4O00840004000100022O006E000400173O0012CA000100A73O0004743O00C802010004743O009A02010004743O00C802010004743O0095020100262200010085030100A70004743O008503010012CA000200013O002649000200CF020100010004743O00CF0201002E4D00A8004C030100A90004743O004C03010012CA000300013O002649000300D4020100010004743O00D40201002E4D00AA0047030100AB0004743O004703012O001D000400013O00203A0004000400342O00F0000400020002000699000400DC020100010004743O00DC02012O001D000400183O0006BB0004002603013O0004743O002603010012CA000400014O00BE000500073O002649000400E2020100070004743O00E20201002E4D00AD0012030100AC0004743O001203012O00BE000700073O00262200050006030100010004743O000603010012CA000800013O002649000800EA020100010004743O00EA0201002E4D00AE00FF020100580004743O00FF02012O001D000900183O00065C000600F6020100090004743O00F602012O001D000900084O0055000A000B3O00122O000B00AF3O00122O000C00B06O000A000C00024O00090009000A00202O0009000900B14O0009000200024O000600094O001D0009000C3O0020630009000900B24O000A00066O000B00193O00122O000C008E3O00122O000D00B36O0009000D00024O000700093O00122O000800073O0026490008002O030100070004743O002O0301002E4D00B500E6020100B40004743O00E602010012CA000500073O0004743O000603010004743O00E602010026490005000A030100070004743O000A0301002E4D00B700E3020100B60004743O00E30201002E0D00B90026030100B80004743O002603010006BB0007002603013O0004743O002603012O0072000700023O0004743O002603010004743O00E302010004743O00260301002E1C00BA00CCFF2O00BA0004743O00DE0201002622000400DE020100010004743O00DE02010012CA000800013O002E4D00BB001D030100390004743O001D03010026220008001D030100070004743O001D03010012CA000400073O0004743O00DE0201002E4D00BD0017030100BC0004743O0017030100262200080017030100010004743O001703010012CA000500014O00BE000600063O0012CA000800073O0004743O001703010004743O00DE02012O001D0004001A3O0006990004002B030100010004743O002B0301002E4D00BF0046030100BE0004743O004603010012CA000400014O00BE000500053O00264900040031030100010004743O00310301002E0D00C1002D030100C00004743O002D03010012CA000500013O002O0E00010032030100050004743O003203012O001D0006000C3O00204A0006000600C34O000700083O00202O0007000700C44O000800193O00202O0008000800C500122O000900C66O00060009000200122O000600C23O00122O000600C23O00062O0006004603013O0004743O0046030100125F000600C24O0072000600023O0004743O004603010004743O003203010004743O004603010004743O002D03010012CA000300073O002622000300D0020100070004743O00D002010012CA000200073O0004743O004C03010004743O00D0020100264900020050030100070004743O00500301002E0D00C700CB020100C80004743O00CB0201002E1C00C90032000100C90004743O008203012O001D0003001B3O0006BB0003008203013O0004743O008203010012CA000300014O00BE000400053O002E4D00CA005E030100CB0004743O005E03010026220003005E030100010004743O005E03010012CA000400014O00BE000500053O0012CA000300073O000E2500070062030100030004743O00620301002E4D00CD0057030100CC0004743O0057030100264900040066030100010004743O00660301002E4D00CF0062030100CE0004743O006203010012CA000500013O002E4D00D00067030100D10004743O0067030100262200050067030100010004743O006703012O001D0006000C3O0020F10006000600D24O000700083O00202O0007000700D34O000800193O00202O0008000800D400122O0009008E6O000A00016O0006000A000200122O000600C23O00122O000600C23O00062O0006007A030100010004743O007A0301002E4D00D50082030100D60004743O0082030100125F000600C24O0072000600023O0004743O008203010004743O006703010004743O008203010004743O006203010004743O008203010004743O005703010012CA000100D73O0004743O008503010004743O00CB0201002E1C00D80080FC2O00D80004743O0005000100262200010005000100D70004743O000500010012CA000200013O002622000200CA030100010004743O00CA03012O001D0003001C3O0006BB000300BF03013O0004743O00BF03012O001D000300113O00069900030097030100010004743O009703012O001D000300013O00203A0003000300342O00F00003000200020006BB000300BF03013O0004743O00BF030100125F0003001B4O00DB0003000100024O000400176O0003000300044O0004001D3O00062O0003009F030100040004743O009F03010004743O00BF0301002E1C00D90020000100D90004743O00BF03012O001D000300084O009B0004000B3O00122O000500DA3O00122O000600DB6O0004000600024O00030003000400202O0003000300B14O00030002000200062O000300BF03013O0004743O00BF03012O001D000300013O00202A0003000300DC4O000500083O00202O0005000500DD4O00030005000200062O000300BF03013O0004743O00BF0301002E0D00DF00BF030100DE0004743O00BF03012O001D000300134O001D000400083O0020D80004000400DD2O00F00003000200020006BB000300BF03013O0004743O00BF03012O001D0003000B3O0012CA000400E03O0012CA000500E14O008C000300054O00A900036O001D000300013O0020210003000300E24O000500083O00202O0005000500E34O00030005000200262O000300C7030100610004743O00C703012O00C800036O0038000300014O006E0003001E3O0012CA000200073O002649000200CE030100070004743O00CE0301002E0D00E4008A030100E50004743O008A03012O001D0003000C3O0020440003000300E600122O000400E76O0003000200024O0003001F3O00122O000100023O00044O000500010004743O008A03010004743O000500010004743O00D903010004743O000200012O00473O00017O001F3O00028O00026O00F03F025O00EC9340025O002AAC4003123O00F27C3AB3E280A017D4792C87E28EB910D06603083O0076B61549C387ECCC030A3O004D657267655461626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654D61676963446562752O667303123O002C3509502O01F1093E16452008FF1D3A1C5303073O009D685C7A20646D03193O0044697370652O6C61626C6544697365617365446562752O6673026O006E40025O00989240025O00D88340025O00A2A140027O0040025O00A49E40025O00B0804003123O0087AFDCDA382B81AAA1AACAEE382598ADA5B503083O00CBC3C6AFAA5D47ED03173O0044697370652O6C61626C654375727365446562752O6673025O00806840025O009EA74003053O005072696E7403213O0068D752E94621E159D15EF54D73D24ECA5CFF5173F5418572EA4A30B77ACA58F76803073O009738A5379A2353030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03283O00905100FDA55113EFB44A0A2OE06613E1AB4617AE980313AEF1134BBCEE1355AE825A45CCAF4C08C503043O008EC0236500753O0012CA3O00014O00BE000100013O0026223O0002000100010004743O000200010012CA000100013O0026220001003E000100020004743O003E00010012CA000200014O00BE000300033O00262200020009000100010004743O000900010012CA000300013O00262200030035000100010004743O003500010012CA000400013O00264900040013000100010004743O00130001002E0D0004002E000100030004743O002E00012O001D00056O00F8000600013O00122O000700053O00122O000800066O0006000800024O000700023O00202O0007000700074O00085O00202O0008000800084O00095O00202O0009000900094O0007000900024O0005000600074O00058O000600013O00122O0007000A3O00122O0008000B6O0006000800024O000700023O00202O0007000700074O00085O00202O0008000800084O00095O00202O00090009000C4O0007000900024O00050006000700122O000400023O002E0D000D000F0001000E0004743O000F00010026220004000F000100020004743O000F00010012CA000300023O0004743O003500010004743O000F000100264900030039000100020004743O00390001002E0D0010000C0001000F0004743O000C00010012CA000100113O0004743O003E00010004743O000C00010004743O003E00010004743O00090001002E0D00130050000100120004743O0050000100262200010050000100110004743O005000012O001D00026O00C5000300013O00122O000400143O00122O000500156O0003000500024O000400023O00202O0004000400074O00055O00202O0005000500084O00065O00202O0006000600164O0004000600024O00020003000400044O0074000100262200010005000100010004743O000500010012CA000200014O00BE000300033O002E4D00170054000100180004743O0054000100262200020054000100010004743O005400010012CA000300013O0026220003006A000100010004743O006A00012O001D000400033O0020E90004000400194O000500013O00122O0006001A3O00122O0007001B6O000500076O00043O000100122O0004001C3O00202O00040004001D4O000500013O00122O0006001E3O00122O0007001F6O000500076O00043O000100122O000300023O00262200030059000100020004743O005900010012CA000100023O0004743O000500010004743O005900010004743O000500010004743O005400010004743O000500010004743O007400010004743O000200012O00473O00017O00", GetFEnv(), ...);

