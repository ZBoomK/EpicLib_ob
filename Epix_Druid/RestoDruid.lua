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
											if (Enum > 0) then
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
										elseif (Enum == 2) then
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
											if (Stk[Inst[2]] == Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum == 6) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
											if (Stk[Inst[2]] > Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										end
									elseif (Enum > 10) then
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
								elseif (Enum <= 13) then
									if (Enum == 12) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 14) then
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
								elseif (Enum == 15) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
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
								elseif (Enum == 23) then
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
								end
							elseif (Enum <= 28) then
								if (Enum <= 26) then
									if (Enum > 25) then
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 27) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 30) then
								if (Enum > 29) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 31) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 32) then
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
						elseif (Enum <= 50) then
							if (Enum <= 41) then
								if (Enum <= 37) then
									if (Enum <= 35) then
										if (Enum > 34) then
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
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 36) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 39) then
									if (Enum == 38) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 40) then
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
							elseif (Enum <= 45) then
								if (Enum <= 43) then
									if (Enum == 42) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 44) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
							elseif (Enum <= 47) then
								if (Enum > 46) then
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
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 48) then
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
							elseif (Enum == 49) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 58) then
							if (Enum <= 54) then
								if (Enum <= 52) then
									if (Enum == 51) then
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								elseif (Enum == 53) then
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
							elseif (Enum <= 56) then
								if (Enum > 55) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
								end
							elseif (Enum > 57) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									return Unpack(Stk, A, Top);
								end
							end
						elseif (Enum <= 62) then
							if (Enum <= 60) then
								if (Enum == 59) then
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum > 61) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
						elseif (Enum <= 64) then
							if (Enum > 63) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 65) then
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
						elseif (Enum == 66) then
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
					elseif (Enum <= 101) then
						if (Enum <= 84) then
							if (Enum <= 75) then
								if (Enum <= 71) then
									if (Enum <= 69) then
										if (Enum > 68) then
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											Stk[Inst[2]] = Inst[3] ~= 0;
										end
									elseif (Enum == 70) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 73) then
									if (Enum == 72) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 74) then
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
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 79) then
								if (Enum <= 77) then
									if (Enum == 76) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
									end
								elseif (Enum > 78) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 81) then
								if (Enum == 80) then
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
							elseif (Enum <= 82) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum > 83) then
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
						elseif (Enum <= 92) then
							if (Enum <= 88) then
								if (Enum <= 86) then
									if (Enum > 85) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum > 87) then
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
							elseif (Enum <= 90) then
								if (Enum > 89) then
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
							elseif (Enum == 91) then
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
						elseif (Enum <= 96) then
							if (Enum <= 94) then
								if (Enum == 93) then
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
							elseif (Enum > 95) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 98) then
							if (Enum > 97) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 100) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Inst[2] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 118) then
						if (Enum <= 109) then
							if (Enum <= 105) then
								if (Enum <= 103) then
									if (Enum > 102) then
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
								elseif (Enum > 104) then
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
							elseif (Enum <= 107) then
								if (Enum > 106) then
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
								else
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
						elseif (Enum <= 113) then
							if (Enum <= 111) then
								if (Enum == 110) then
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
							elseif (Enum > 112) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
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
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 115) then
							if (Enum == 114) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							else
								Env[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 116) then
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
						elseif (Enum == 117) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							A = Inst[2];
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
						end
					elseif (Enum <= 126) then
						if (Enum <= 122) then
							if (Enum <= 120) then
								if (Enum > 119) then
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
							elseif (Enum == 121) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 124) then
							if (Enum > 123) then
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum > 125) then
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
							if (Enum == 127) then
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 129) then
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 132) then
						if (Enum > 131) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 133) then
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
					elseif (Enum > 134) then
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
							if (Mvm[1] == 59) then
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					if (Enum <= 169) then
						if (Enum <= 152) then
							if (Enum <= 143) then
								if (Enum <= 139) then
									if (Enum <= 137) then
										if (Enum > 136) then
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
									elseif (Enum > 138) then
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									elseif (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 141) then
									if (Enum > 140) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 142) then
									if (Inst[2] <= Stk[Inst[4]]) then
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
							elseif (Enum <= 147) then
								if (Enum <= 145) then
									if (Enum == 144) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum > 146) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 149) then
								if (Enum == 148) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 150) then
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
							elseif (Enum == 151) then
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
						elseif (Enum <= 160) then
							if (Enum <= 156) then
								if (Enum <= 154) then
									if (Enum == 153) then
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
										Stk[A] = Stk[A]();
									end
								elseif (Enum > 155) then
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
							elseif (Enum <= 158) then
								if (Enum > 157) then
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum > 159) then
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
							end
						elseif (Enum <= 164) then
							if (Enum <= 162) then
								if (Enum > 161) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 166) then
							if (Enum == 165) then
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
						elseif (Enum <= 167) then
							if (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 168) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 186) then
						if (Enum <= 177) then
							if (Enum <= 173) then
								if (Enum <= 171) then
									if (Enum > 170) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum == 172) then
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
							elseif (Enum <= 175) then
								if (Enum == 174) then
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							elseif (Enum == 176) then
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
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 181) then
							if (Enum <= 179) then
								if (Enum > 178) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 180) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 183) then
							if (Enum == 182) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 184) then
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
						elseif (Enum == 185) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum > 189) then
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
						elseif (Enum <= 192) then
							if (Enum == 191) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 193) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 198) then
						if (Enum <= 196) then
							if (Enum > 195) then
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
							if Stk[Inst[2]] then
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
					elseif (Enum <= 200) then
						if (Enum > 199) then
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 201) then
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
						VIP = VIP + 1;
						Inst = Instr[VIP];
						VIP = Inst[3];
					elseif (Enum > 202) then
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
				elseif (Enum <= 237) then
					if (Enum <= 220) then
						if (Enum <= 211) then
							if (Enum <= 207) then
								if (Enum <= 205) then
									if (Enum > 204) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum == 206) then
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								else
									Stk[Inst[2]] = #Stk[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 210) then
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
								end
							elseif (Enum == 214) then
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
						elseif (Enum <= 217) then
							if (Enum == 216) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 218) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 219) then
							do
								return Stk[Inst[2]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 228) then
						if (Enum <= 224) then
							if (Enum <= 222) then
								if (Enum > 221) then
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
								end
							elseif (Enum > 223) then
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
							else
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							end
						elseif (Enum <= 226) then
							if (Enum == 225) then
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
						elseif (Enum == 227) then
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
					elseif (Enum <= 232) then
						if (Enum <= 230) then
							if (Enum == 229) then
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
						elseif (Enum == 231) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
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
					elseif (Enum <= 234) then
						if (Enum == 233) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 235) then
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
					elseif (Enum > 236) then
						if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
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
				elseif (Enum <= 254) then
					if (Enum <= 245) then
						if (Enum <= 241) then
							if (Enum <= 239) then
								if (Enum > 238) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 240) then
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
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum > 244) then
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
					elseif (Enum <= 249) then
						if (Enum <= 247) then
							if (Enum == 246) then
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
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum > 248) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 251) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 252) then
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
					elseif (Enum > 253) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 262) then
					if (Enum <= 258) then
						if (Enum <= 256) then
							if (Enum > 255) then
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
						elseif (Enum == 257) then
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 260) then
						if (Enum == 259) then
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
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum == 261) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 266) then
					if (Enum <= 264) then
						if (Enum > 263) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum == 265) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 268) then
					if (Enum == 267) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 269) then
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
				elseif (Enum == 270) then
					if (Stk[Inst[2]] <= Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				else
					local A = Inst[2];
					Stk[A](Unpack(Stk, A + 1, Top));
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!333O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503053O005574696C7303043O00556E697403063O00506C617965722O033O0050657403063O0054617267657403053O00466F63757303093O004D6F7573654F76657203053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O004361737403053O005072652O7303053O004D6163726F03073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03063O00666F726D617403053O004472756964030B3O00526573746F726174696F6E028O00024O0080B3C540030C3O0047657445717569706D656E74026O002A40026O002C4003103O005265676973746572466F724576656E7403183O009BFC5316E67FCA6B9AE55B1FEE68DB7A94F35A0EED6AD06A03083O002ECBB0124FA32D9503143O0012523F1DDE8A1D4C3B03DE961D5B3005D994075A03063O00D8421E7E449B03243O008BEB39E2F386E8D186E934EEF79CE4D18FEB24EAE98AEDC09EE122E5FA80FFC084EF28EF03083O0081CAA86DABA5C3B703043O0052616B6503133O005265676973746572504D756C7469706C696572030A3O0052616B65446562752O6603063O0053657441504C025O00405A4000CB012O00125C3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004C03O000A0001001252000300063O002084000400030007001252000500083O002084000500050009001252000600083O00208400060006000A00068700073O000100062O003B3O00064O003B8O003B3O00044O003B3O00014O003B3O00024O003B3O00054O00710008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000E001100202O0010000E001200202O0011000E001300202O0012000E001400202O0013000E001500202O0014000B001600202O0015000B001700202O0016000B001800122O0017000D3O00202O00180017001900202O00190017001A00202O001A0017001B00202O001B0017001C00202O001B001B001D00202O001B001B001E00202O001C0017001C00202O001C001C001D00202O001C001C001F00122O001D00013O00202O001D001D00204O001E8O001F8O00208O00218O00228O00238O00248O00258O002600623O00202O00630017001C00202O00630063001D00202O00640014002100202O00640064002200202O00650016002100202O0065006500224O00665O00202O0067001A002100202O00670067002200122O006800236O0069006A3O00122O006B00243O00122O006C00246O006D8O006E8O006F8O00708O00718O00728O00735O00202O0074000F00254O00740002000200202O00750074002600062O0075005800013O0004C03O005800012O003B007500163O0020840076007400262O001E0075000200020006260075005B000100010004C03O005B00012O003B007500163O00121A007600234O001E0075000200020020840076007400270006F00076006300013O0004C03O006300012O003B007600163O0020840077007400272O001E00760002000200062600760066000100010004C03O006600012O003B007600163O00121A007700234O001E0076000200020020E10077000B002800068700790001000100052O003B3O00764O003B3O00744O003B3O00164O003B3O000F4O003B3O00754O00BA007A00073O00122O007B00293O00122O007C002A6O007A007C6O00773O00010020E10077000B002800068700790002000100022O003B3O006B4O003B3O006C4O00BA007A00073O00122O007B002B3O00122O007C002C6O007A007C6O00773O000100068700770003000100032O003B3O00644O003B3O00634O003B3O000D3O0020E10078000B0028000687007A0004000100012O003B3O00774O00BA007B00073O00122O007C002D3O00122O007D002E6O007B007D6O00783O000100068700780005000100012O003B3O000F3O00200801790064002F00202O00790079003000202O007B006400314O007C00786O0079007C000100068700790006000100092O003B3O006D4O003B3O000F4O003B3O00644O003B3O006E4O003B3O00734O003B3O00714O003B3O00704O003B3O00724O003B3O006F3O000687007A0007000100022O003B3O00644O003B3O006C3O000687007B0008000100042O003B3O00644O003B3O006C4O003B3O006A4O003B3O000F3O000687007C0009000100012O003B3O00643O000687007D000A000100032O003B3O00644O003B3O000F4O003B3O006A3O000687007E000B000100022O003B3O00644O003B3O000F3O000687007F000C000100012O003B3O00643O0006870080000D000100022O003B3O00634O003B3O00643O0006870081000E000100022O003B3O00634O003B3O00643O0006870082000F000100012O003B3O00643O00068700830010000100052O003B3O00634O003B3O00664O003B3O00204O003B3O000F4O003B3O00643O00068700840011000100122O003B3O00644O003B3O000F4O003B3O00114O003B3O00634O003B3O00694O003B3O007A4O003B3O00674O003B3O00074O003B3O007B4O003B3O00194O003B3O006A4O003B3O007D4O003B3O007E4O003B3O007F4O003B3O00204O003B3O00244O003B3O00834O003B3O00343O00068700850012000100122O003B3O00644O003B3O006A4O003B3O006F4O003B3O00244O003B3O00194O003B3O00114O003B3O00074O003B3O00634O003B3O00694O003B3O007C4O003B3O00674O003B3O00204O003B3O000F4O003B3O00704O003B3O00714O003B3O00734O003B3O007A4O003B3O00343O000687008600130001000A2O003B3O00644O003B3O000F4O003B3O00194O003B3O00114O003B3O00074O003B3O006A4O003B3O00634O003B3O00844O003B3O00854O003B3O00793O00068700870014000100062O003B3O00124O003B3O00634O003B3O00644O003B3O00194O003B3O00674O003B3O00073O000687008800150001000F2O003B3O000F4O003B3O005F4O003B3O00604O003B3O00644O003B3O00194O003B3O00074O003B3O00614O003B3O00624O003B3O00654O003B3O002D4O003B3O002E4O003B3O00674O003B3O00274O003B3O00294O003B3O00283O00068700890016000100092O003B3O00124O003B3O00644O003B3O00824O003B3O000F4O003B3O00194O003B3O00674O003B3O00074O003B3O00814O003B3O00133O000687008A0017000100332O003B3O00124O003B3O00254O003B3O000F4O003B3O00644O003B3O00634O003B3O005A4O003B3O005B4O003B3O00194O003B3O00674O003B3O00074O003B3O00384O003B3O00394O003B3O003A4O003B3O00204O003B3O00804O003B3O00414O003B3O00424O003B3O004D4O003B3O004E4O003B3O00434O003B3O00444O003B3O00454O003B3O00464O003B3O001B4O003B3O00544O003B3O00554O003B3O00574O003B3O00584O003B3O003E4O003B3O003F4O003B3O004B4O003B3O004C4O003B3O00814O003B3O00134O003B3O004F4O003B3O00504O003B3O00474O003B3O00484O003B3O00364O003B3O005C4O003B3O005D4O003B3O005E4O003B3O003B4O003B3O003C4O003B3O00494O003B3O004A4O003B3O00834O003B3O00354O003B3O00514O003B3O00824O003B3O00523O000687008B00180001000E2O003B3O00634O003B3O00234O003B3O00864O003B3O00224O003B3O00894O003B3O008A4O003B3O002F4O003B3O00644O003B3O00674O003B3O002C4O003B3O002B4O003B3O00214O003B3O00874O003B3O00883O000687008C0019000100132O003B3O002C4O003B3O002B4O003B3O00214O003B3O00874O003B3O001E4O003B3O00254O003B3O008A4O003B3O00634O003B3O00234O003B3O00864O003B3O002F4O003B3O00644O003B3O00674O003B3O00304O003B3O002A4O003B3O000F4O003B3O00194O003B3O00074O003B3O00113O000687008D001A000100202O003B3O003F4O003B3O00074O003B3O00404O003B3O00414O003B3O00424O003B3O00434O003B3O002B4O003B3O002C4O003B3O002D4O003B3O002E4O003B3O002F4O003B3O003A4O003B3O003B4O003B3O003C4O003B3O003D4O003B3O003E4O003B3O00304O003B3O00314O003B3O00324O003B3O00334O003B3O00344O003B3O00444O003B3O00264O003B3O00274O003B3O00284O003B3O00294O003B3O002A4O003B3O00354O003B3O00364O003B3O00374O003B3O00384O003B3O00393O000687008E001B0001001F2O003B3O00614O003B3O00074O003B3O00624O003B3O004D4O003B3O004E4O003B3O004F4O003B3O00504O003B3O00494O003B3O004A4O003B3O004B4O003B3O004C4O003B3O00514O003B3O00524O003B3O00534O003B3O00544O003B3O00454O003B3O00464O003B3O00474O003B3O00484O003B3O005D4O003B3O005E4O003B3O005F4O003B3O00604O003B3O00554O003B3O00564O003B3O00574O003B3O00584O003B3O00594O003B3O005A4O003B3O005B4O003B3O005C3O000687008F001C0001001D2O003B3O000F4O003B3O00684O003B3O00644O003B3O001F4O003B3O00694O003B3O00114O003B3O006A4O003B3O00204O003B3O00074O003B3O00214O003B3O00224O003B3O00234O003B3O00634O003B3O006B4O003B3O000B4O003B3O006C4O003B3O001E4O003B3O00194O003B3O00254O003B3O00894O003B3O008A4O003B3O008B4O003B3O008C4O003B3O00244O003B3O002B4O003B3O00444O003B3O00434O003B3O008D4O003B3O008E3O0006870090001D000100032O003B3O00774O003B3O00174O003B3O00073O00209C00910017003200122O009200336O0093008F6O009400906O0091009400016O00013O001E3O00023O00026O00F03F026O00704002264O00E300025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AA00076O0043000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004C40003000500012O00AA000300054O003B000400024O0046000300044O003900036O006E3O00017O00053O00028O00026O00F03F026O002C40030C3O0047657445717569706D656E74026O002A4000293O00121A3O00013O00261D3O0012000100020004C03O001200012O00AA000100013O0020840001000100030006F00001000D00013O0004C03O000D00012O00AA000100024O00AA000200013O0020840002000200032O001E00010002000200062600010010000100010004C03O001000012O00AA000100023O00121A000200014O001E0001000200022O009500015O0004C03O0028000100261D3O0001000100010004C03O000100012O00AA000100033O0020F40001000100044O0001000200024O000100016O000100013O00202O00010001000500062O0001002200013O0004C03O002200012O00AA000100024O00AA000200013O0020840002000200052O001E00010002000200062600010025000100010004C03O002500012O00AA000100023O00121A000200014O001E0001000200022O0095000100043O00121A3O00023O0004C03O000100012O006E3O00017O00023O00028O00024O0080B3C540000A3O00121A3O00013O00261D3O0001000100010004C03O0001000100121A000100024O009500015O00121A000100024O0095000100013O0004C03O000900010004C03O000100012O006E3O00017O00083O0003133O00496D70726F7665644E61747572657343757265030B3O004973417661696C61626C65028O0003123O0044697370652O6C61626C65446562752O6673030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303173O0044697370652O6C61626C654375727365446562752O667300234O00B07O00206O000100206O00026O0002000200064O001E00013O0004C03O001E000100121A3O00033O00261D3O0007000100030004C03O000700012O00AA000100014O009D000200023O00202O0002000200054O000300013O00202O0003000300064O000400013O00202O0004000400074O00020004000200102O0001000400024O000100016O000200023O00202O0002000200054O000300013O00202O0003000300044O000400013O00202O0004000400084O00020004000200102O00010004000200044O002200010004C03O000700010004C03O002200012O00AA3O00014O00AA000100013O00208400010001000600106A3O000400012O006E3O00019O003O00034O00AA8O00D83O000100012O006E3O00017O00033O0003093O00537465616C74685570029A5O99F93F026O00F03F000D4O00AC7O00206O00014O000200016O000300018O0003000200064O000A00013O0004C03O000A000100121A3O00023O0006263O000B000100010004C03O000B000100121A3O00034O00DC3O00024O006E3O00017O000C3O00028O0003063O0042752O665570030C3O0045636C69707365536F6C6172030C3O0045636C697073654C756E6172026O00F03F026O00084003053O00577261746803053O00436F756E7403083O005374617266697265027O004003093O00497343617374696E6703083O0042752O66446F776E008B3O00121A3O00013O00261D3O001E000100010004C03O001E00012O00AA000100013O0020FE0001000100024O000300023O00202O0003000300034O00010003000200062O0001000F000100010004C03O000F00012O00AA000100013O0020E10001000100022O00AA000300023O0020840003000300042O00CD0001000300022O009500016O0057000100013O00202O0001000100024O000300023O00202O0003000300034O00010003000200062O0001001C00013O0004C03O001C00012O00AA000100013O0020E10001000100022O00AA000300023O0020840003000300042O00CD0001000300022O0095000100033O00121A3O00053O00261D3O0033000100060004C03O003300012O00AA00015O0006260001002F000100010004C03O002F00012O00AA000100023O0020840001000100070020E10001000100082O001E000100020002000E8A0001002F000100010004C03O002F00012O00AA000100023O0020840001000100090020E10001000100082O001E000100020002000E8C00010030000100010004C03O003000012O004D00016O0044000100014O0095000100043O0004C03O008A000100261D3O006C0001000A0004C03O006C00012O00AA00015O0006260001004B000100010004C03O004B00012O00AA000100023O0020840001000100090020E10001000100082O001E00010002000200261D00010044000100010004C03O004400012O00AA000100023O0020840001000100070020E10001000100082O001E000100020002000E8C0001004E000100010004C03O004E00012O00AA000100013O0020FE00010001000B4O000300023O00202O0003000300074O00010003000200062O0001004F000100010004C03O004F00012O00AA000100063O0004C03O004F00012O004D00016O0044000100014O0095000100054O00AA00015O00062600010066000100010004C03O006600012O00AA000100023O0020840001000100070020E10001000100082O001E00010002000200261D0001005F000100010004C03O005F00012O00AA000100023O0020840001000100090020E10001000100082O001E000100020002000E8C00010069000100010004C03O006900012O00AA000100013O0020FE00010001000B4O000300023O00202O0003000300094O00010003000200062O0001006A000100010004C03O006A00012O00AA000100083O0004C03O006A00012O004D00016O0044000100014O0095000100073O00121A3O00063O00261D3O0001000100050004C03O000100012O00AA000100013O00203A0001000100024O000300023O00202O0003000300044O00010003000200062O0001007A00013O0004C03O007A00012O00AA000100013O0020E100010001000C2O00AA000300023O0020840003000300032O00CD0001000300022O0095000100084O0057000100013O00202O0001000100024O000300023O00202O0003000300034O00010003000200062O0001008700013O0004C03O008700012O00AA000100013O0020E100010001000C2O00AA000300023O0020840003000300042O00CD0001000300022O0095000100063O00121A3O000A3O0004C03O000100012O006E3O00017O00033O0003113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66026O001440010D3O00203A00013O00014O00035O00202O0003000300024O00010003000200062O0001000B00013O0004C03O000B00012O00AA000100013O000E8C0003000A000100010004C03O000A00012O004D00016O0044000100014O00DC000100024O006E3O00017O00113O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O66026O002840026O00104003063O00456E65726779026O00494003083O0042752O66446F776E030E3O0048656172744F6654686557696C6403063O0042752O665570030A3O00446562752O66446F776E03073O0050726576474344026O00F03F03073O0053756E6669726503083O00446562752O665570030D3O00446562752O6652656D61696E73030E3O00446562752O664475726174696F6E02009A4O99E93F01533O00203A00013O00014O00035O00202O0003000300024O00010003000200062O0001002D00013O0004C03O002D00012O00AA000100013O000E8A0003002D000100010004C03O002D00012O00AA000100023O00260900010011000100040004C03O001100012O00AA000100033O0020E10001000100052O001E0001000200020026B100010018000100060004C03O001800012O00AA000100033O0020FE0001000100074O00035O00202O0003000300084O00010003000200062O00010027000100010004C03O002700012O00AA000100023O00260900010020000100040004C03O002000012O00AA000100033O0020E10001000100052O001E0001000200020026B10001002D000100060004C03O002D00012O00AA000100033O00203A0001000100094O00035O00202O0003000300084O00010003000200062O0001002D00013O0004C03O002D00010020E100013O000A2O00AA00035O0020840003000300022O00CD00010003000200062600010051000100010004C03O005100012O00AA000100033O0020E200010001000B00122O0003000C6O00045O00202O00040004000D4O00010004000200062O0001005100013O0004C03O005100010020E100013O000E2O00AA00035O0020840003000300022O00CD0001000300020006F00001004600013O0004C03O004600010020E100013O000F2O001F00035O00202O0003000300024O00010003000200202O00023O00104O00045O00202O0004000400024O00020004000200202O00020002001100062O0001004C000100020004C03O004C00010020E100013O000A2O00AA00035O0020840003000300022O00CD0001000300020006F00001005100013O0004C03O005100012O00AA000100023O0026A7000100500001000C0004C03O005000012O004D00016O0044000100014O00DC000100024O006E3O00017O00043O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O6603093O0054696D65546F446965026O001440010E3O00203A00013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004C03O000C00010020E100013O00032O001E000100020002000E8C0004000B000100010004C03O000B00012O004D00016O0044000100014O00DC000100024O006E3O00017O000D3O0003113O00446562752O665265667265736861626C652O033O0052697003063O00456E65726779025O00805640030D3O00446562752O6652656D61696E73026O002440030B3O00436F6D626F506F696E7473026O00144003093O0054696D65546F446965026O002C40026O001040030A3O00446562752O66446F776E027O0040014D3O0020FE00013O00014O00035O00202O0003000300024O00010003000200062O00010011000100010004C03O001100012O00AA000100013O0020E10001000100032O001E000100020002000E8A0004003B000100010004C03O003B00010020E100013O00052O00AA00035O0020840003000300022O00CD00010003000200260E2O01003B000100060004C03O003B00012O00AA000100013O0020E10001000100072O001E00010002000200261D00010020000100080004C03O002000010020E100013O00092O00A100010002000200202O00023O00054O00045O00202O0004000400024O00020004000200202O00020002000A00202O00020002000600062O0002004A000100010004C03O004A00010020E100013O00052O000401035O00202O0003000300024O0001000300024O000200013O00202O0002000200074O00020002000200202O00020002000B4O00010001000200202O00023O00094O00020002000200062O0001003B000100020004C03O003B00010020E100013O00052O00FB00035O00202O0003000300024O00010003000200202O00010001000B4O000200013O00202O0002000200074O00020002000200202O00020002000B4O00010001000200202O00023O00094O00020002000200062O0002004A000100010004C03O004A00010020E100013O000C2O00AA00035O0020840003000300022O00CD0001000300020006F00001004B00013O0004C03O004B00012O00AA000100013O00203E0001000100074O0001000200024O000200023O00202O00020002000D00102O0002000D000200062O0002004A000100010004C03O004A00012O004D00016O0044000100014O00DC000100024O006E3O00017O00073O00030A3O00446562752O66446F776E030A3O0052616B65446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O002440030B3O00436F6D626F506F696E7473026O00144001193O0020FE00013O00014O00035O00202O0003000300024O00010003000200062O0001000C000100010004C03O000C00010020E100013O00032O00AA00035O0020840003000300022O00CD0001000300020006F00001001700013O0004C03O001700010020E100013O00042O001E000100020002000E8A00050015000100010004C03O001500012O00AA000100013O0020E10001000100062O001E0001000200020026A800010016000100070004C03O001600012O004D00016O0044000100014O00DC000100024O006E3O00017O00023O0003083O00446562752O66557003133O004164617074697665537761726D446562752O6601063O00207B00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00043O00031A3O00467269656E646C79556E6974735769746842752O66436F756E74030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746800134O008B7O00206O00014O000100013O00202O0001000100026O000200024O00015O00202O0001000100014O000200013O00202O0002000200034O0001000200028O00014O00015O00202O0001000100014O000200013O00202O0002000200044O0001000200028O00016O00028O00017O00023O00031D3O00467269656E646C79556E697473576974686F757442752O66436F756E74030C3O0052656A7576656E6174696F6E00074O006C7O00206O00014O000100013O00202O0001000100026O00019O008O00017O00043O0003063O0042752O665570030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746801123O0020FE00013O00014O00035O00202O0003000300024O00010003000200062O00010010000100010004C03O001000010020E100013O00012O00AA00035O0020840003000300032O00CD00010003000200062600010010000100010004C03O001000010020E100013O00012O00AA00035O0020840003000300042O00CD0001000300022O00DC000100024O006E3O00017O00093O00028O00030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B657403063O0042752O665570030E3O0048656172744F6654686557696C64030F3O00496E6361726E6174696F6E42752O66026O004440026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574003F3O00121A3O00013O00261D3O001F000100010004C03O001F00012O00AA00015O0020840001000100032O00AA000200014O00AA000300023O0006F00003001500013O0004C03O001500012O00AA000300033O0020FE0003000300044O000500043O00202O0005000500054O00030005000200062O00030015000100010004C03O001500012O00AA000300033O0020E10003000300042O00AA000500043O0020840005000500062O00CD00030005000200121A000400074O00BE000500056O00010005000200122O000100023O00122O000100023O00062O0001001E00013O0004C03O001E0001001252000100024O00DC000100023O00121A3O00083O00261D3O0001000100080004C03O000100012O00AA00015O0020840001000100092O00AA000200014O00AA000300023O0006F00003003300013O0004C03O003300012O00AA000300033O0020FE0003000300044O000500043O00202O0005000500054O00030005000200062O00030033000100010004C03O003300012O00AA000300033O0020E10003000300042O00AA000500043O0020840005000500062O00CD00030005000200121A000400074O00BE000500056O00010005000200122O000100023O00122O000100023O00062O0001003E00013O0004C03O003E0001001252000100024O00DC000100023O0004C03O003E00010004C03O000100012O006E3O00017O00563O00028O00026O00F03F03073O0053756E6669726503073O004973526561647903083O0042752O66446F776E03073O00436174466F726D03093O0054696D65546F446965026O0014402O033O00526970030B3O004973417661696C61626C6503083O00446562752O66557003063O00456E65726779026O003E4003093O00436173744379636C65030E3O0049735370652O6C496E52616E676503103O0053756E666972654D6F7573656F766572030E3O00314D39DED706E3625B36CC9E46B603073O0086423857B8BE7403083O004D2O6F6E6669726503113O004D2O6F6E666972654D6F7573656F766572030F3O00313E06B51FE233307C3208AF59B97303083O00555C5169DB798B41030A3O00446562752O66446F776E030D3O0053756E66697265446562752O66030E3O00EEA65E4375CDF8F35344689FAFE703063O00BF9DD330251C030E3O004D2O6F6E66697265446562752O66030F3O00D210FB123CD60DF15C39DE0BB44E6E03053O005ABF7F947C027O0040026O000840026O002640030E3O004973496E4D656C2O6552616E6765030A3O006A8E3E577B863A572BD303043O007718E74E03063O0054687261736803113O00446562752O665265667265736861626C65030C3O00546872617368446562752O66026O002040030A3O009625B74BCF4851812CB103073O0071E24DC52ABC2003043O0052616B65030B3O002817FFB07A15F5A17A45A203043O00D55A7694030B3O00436F6D626F506F696E7473025O00805640030B3O00504D756C7469706C696572030B3O00492FBF530D582FA016190B03053O002D3B4ED436026O00104003093O0053746172737572676503103O0003428299953BBFF71516808A926EFFA603083O00907036E3EBE64ECD030E3O0048656172744F6654686557696C64030A3O0049734361737461626C6503113O00436F6E766F6B6554686553706972697473030F3O00432O6F6C646F776E52656D61696E7303183O00BB2D0EEEC464BC2E30E8D85E8C3F06F0D41BB0291BBC820D03063O003BD3486F9CB0030F3O004D86F7124888F1200E84E2390ED5BB03043O004D2EE783030D3O004665726F63696F757342697465026O002440026O003940030D3O00446562752O6652656D61696E7303153O00BC51A44FB95DB955A96BB449AE51F643BB40F613E803043O0020DA34D603093O00537465616C74685570030A3O005C163AADB1B3444E0E4503083O003A2E7751C891D025030B3O005573655472696E6B657473030D3O004164617074697665537761726D03123O002A8831BCBDB4202EB323BBA8AF3B6B8F31B803073O00564BEC50CCC9DD03063O0042752O665570026O004E40026O00494003093O004973496E52616E6765031A3O00714E7993F180777E638DFBB461517E97F79F61017484EACB231903063O00EB122117E59E03053O005377697065030C3O0043ADC8AB55FAC2BA44FA92E303043O00DB30DAA103053O005368726564030C3O00F7796E4CDF0FE3E5653C1D8903073O008084111C29BB2F00DF022O00121A3O00013O000E64000200C700013O0004C03O00C700012O00AA00015O0020840001000100030020E10001000100042O001E0001000200020006F00001003E00013O0004C03O003E00012O00AA000100013O00203A0001000100054O00035O00202O0003000300064O00010003000200062O0001003E00013O0004C03O003E00012O00AA000100023O0020E10001000100072O001E000100020002000E8A0008003E000100010004C03O003E00012O00AA00015O0020840001000100090020E100010001000A2O001E0001000200020006F00001002700013O0004C03O002700012O00AA000100023O0020FE00010001000B4O00035O00202O0003000300094O00010003000200062O00010027000100010004C03O002700012O00AA000100013O0020E100010001000C2O001E0001000200020026B10001003E0001000D0004C03O003E00012O00AA000100033O0020F100010001000E4O00025O00202O0002000200034O000300046O000400056O000500023O00202O00050005000F4O00075O00202O0007000700034O0005000700024O000500056O000600076O000800063O00202O0008000800104O00010008000200062O0001003E00013O0004C03O003E00012O00AA000100073O00121A000200113O00121A000300124O0046000100034O003900016O00AA00015O0020840001000100130020E10001000100042O001E0001000200020006F00001007900013O0004C03O007900012O00AA000100013O00203A0001000100054O00035O00202O0003000300064O00010003000200062O0001007900013O0004C03O007900012O00AA000100023O0020E10001000100072O001E000100020002000E8A00080079000100010004C03O007900012O00AA00015O0020840001000100090020E100010001000A2O001E0001000200020006F00001006200013O0004C03O006200012O00AA000100023O0020FE00010001000B4O00035O00202O0003000300094O00010003000200062O00010062000100010004C03O006200012O00AA000100013O0020E100010001000C2O001E0001000200020026B1000100790001000D0004C03O007900012O00AA000100033O0020F100010001000E4O00025O00202O0002000200134O000300046O000400086O000500023O00202O00050005000F4O00075O00202O0007000700134O0005000700024O000500056O000600076O000800063O00202O0008000800144O00010008000200062O0001007900013O0004C03O007900012O00AA000100073O00121A000200153O00121A000300164O0046000100034O003900016O00AA00015O0020840001000100030020E10001000100042O001E0001000200020006F00001009C00013O0004C03O009C00012O00AA000100023O00203A0001000100174O00035O00202O0003000300184O00010003000200062O0001009C00013O0004C03O009C00012O00AA000100023O0020E10001000100072O001E000100020002000E8A0008009C000100010004C03O009C00012O00AA000100094O003C00025O00202O0002000200034O000300023O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001009C00013O0004C03O009C00012O00AA000100073O00121A000200193O00121A0003001A4O0046000100034O003900016O00AA00015O0020840001000100130020E10001000100042O001E0001000200020006F0000100C600013O0004C03O00C600012O00AA000100013O00203A0001000100054O00035O00202O0003000300064O00010003000200062O000100C600013O0004C03O00C600012O00AA000100023O00203A0001000100174O00035O00202O00030003001B4O00010003000200062O000100C600013O0004C03O00C600012O00AA000100023O0020E10001000100072O001E000100020002000E8A000800C6000100010004C03O00C600012O00AA000100094O003C00025O00202O0002000200134O000300023O00202O00030003000F4O00055O00202O0005000500134O0003000500024O000300036O00010003000200062O000100C600013O0004C03O00C600012O00AA000100073O00121A0002001C3O00121A0003001D4O0046000100034O003900015O00121A3O001E3O00261D3O005A2O01001F0004C03O005A2O012O00AA00015O0020840001000100090020E100010001000A2O001E0001000200020006F0000100ED00013O0004C03O00ED00012O00AA00015O0020840001000100090020E10001000100042O001E0001000200020006F0000100ED00013O0004C03O00ED00012O00AA0001000A3O0026B1000100ED000100200004C03O00ED00012O00AA0001000B4O00AA000200024O001E0001000200020006F0000100ED00013O0004C03O00ED00012O00AA000100094O006700025O00202O0002000200094O000300023O00202O00030003002100122O000500086O0003000500024O000300036O00010003000200062O000100ED00013O0004C03O00ED00012O00AA000100073O00121A000200223O00121A000300234O0046000100034O003900016O00AA00015O0020840001000100240020E10001000100042O001E0001000200020006F00001000D2O013O0004C03O000D2O012O00AA0001000A3O000E8F001E000D2O0100010004C03O000D2O012O00AA000100023O00203A0001000100254O00035O00202O0003000300264O00010003000200062O0001000D2O013O0004C03O000D2O012O00AA000100094O006700025O00202O0002000200244O000300023O00202O00030003002100122O000500276O0003000500024O000300036O00010003000200062O0001000D2O013O0004C03O000D2O012O00AA000100073O00121A000200283O00121A000300294O0046000100034O003900016O00AA00015O00208400010001002A0020E10001000100042O001E0001000200020006F0000100282O013O0004C03O00282O012O00AA0001000C4O00AA000200024O001E0001000200020006F0000100282O013O0004C03O00282O012O00AA000100094O006700025O00202O00020002002A4O000300023O00202O00030003002100122O000500086O0003000500024O000300036O00010003000200062O000100282O013O0004C03O00282O012O00AA000100073O00121A0002002B3O00121A0003002C4O0046000100034O003900016O00AA00015O00208400010001002A0020E10001000100042O001E0001000200020006F0000100592O013O0004C03O00592O012O00AA000100013O0020E100010001002D2O001E0001000200020026A8000100382O0100080004C03O00382O012O00AA000100013O0020E100010001000C2O001E000100020002000E8A002E00592O0100010004C03O00592O012O00AA000100023O00204000010001002F4O00035O00202O00030003002A4O0001000300024O000200013O00202O00020002002F4O00045O00202O00040004002A4O00020004000200062O000100592O0100020004C03O00592O012O00AA0001000D4O00AA000200024O001E0001000200020006F0000100592O013O0004C03O00592O012O00AA000100094O006700025O00202O00020002002A4O000300023O00202O00030003002100122O000500086O0003000500024O000300036O00010003000200062O000100592O013O0004C03O00592O012O00AA000100073O00121A000200303O00121A000300314O0046000100034O003900015O00121A3O00323O000E64001E000A02013O0004C03O000A02012O00AA00015O0020840001000100330020E10001000100042O001E0001000200020006F00001007A2O013O0004C03O007A2O012O00AA000100013O00203A0001000100054O00035O00202O0003000300064O00010003000200062O0001007A2O013O0004C03O007A2O012O00AA000100094O003C00025O00202O0002000200334O000300023O00202O00030003000F4O00055O00202O0005000500334O0003000500024O000300036O00010003000200062O0001007A2O013O0004C03O007A2O012O00AA000100073O00121A000200343O00121A000300354O0046000100034O003900016O00AA00015O0020840001000100360020E10001000100372O001E0001000200020006F0000100B22O013O0004C03O00B22O012O00AA0001000E3O0006F0000100B22O013O0004C03O00B22O012O00AA00015O0020840001000100380020E10001000100392O001E0001000200020026A80001008F2O01000D0004C03O008F2O012O00AA00015O0020840001000100380020E100010001000A2O001E000100020002000626000100B22O0100010004C03O00B22O012O00AA000100013O00203A0001000100054O00035O00202O0003000300364O00010003000200062O000100B22O013O0004C03O00B22O012O00AA000100023O00203A00010001000B4O00035O00202O0003000300184O00010003000200062O000100B22O013O0004C03O00B22O012O00AA000100023O0020FE00010001000B4O00035O00202O00030003001B4O00010003000200062O000100A72O0100010004C03O00A72O012O00AA0001000A3O000E8A003200B22O0100010004C03O00B22O012O00AA000100094O00AA00025O0020840002000200362O001E0001000200020006F0000100B22O013O0004C03O00B22O012O00AA000100073O00121A0002003A3O00121A0003003B4O0046000100034O003900016O00AA00015O0020840001000100060020E10001000100042O001E0001000200020006F0000100D22O013O0004C03O00D22O012O00AA000100013O00203A0001000100054O00035O00202O0003000300064O00010003000200062O000100D22O013O0004C03O00D22O012O00AA000100013O0020E100010001000C2O001E000100020002000E8F000D00D22O0100010004C03O00D22O012O00AA0001000F3O0006F0000100D22O013O0004C03O00D22O012O00AA000100094O00AA00025O0020840002000200062O001E0001000200020006F0000100D22O013O0004C03O00D22O012O00AA000100073O00121A0002003C3O00121A0003003D4O0046000100034O003900016O00AA00015O00208400010001003E0020E10001000100042O001E0001000200020006F00001000902013O0004C03O000902012O00AA000100013O0020E100010001002D2O001E000100020002000E8A001F00E22O0100010004C03O00E22O012O00AA000100023O0020E10001000100072O001E0001000200020026A8000100F92O01003F0004C03O00F92O012O00AA000100013O0020E100010001002D2O001E00010002000200261D00010009020100080004C03O000902012O00AA000100013O0020E100010001000C2O001E000100020002000E8F00400009020100010004C03O000902012O00AA00015O0020840001000100090020E100010001000A2O001E0001000200020006F0000100F92O013O0004C03O00F92O012O00AA000100023O0020092O01000100414O00035O00202O0003000300094O000100030002000E2O00080009020100010004C03O000902012O00AA000100094O006700025O00202O00020002003E4O000300023O00202O00030003002100122O000500086O0003000500024O000300036O00010003000200062O0001000902013O0004C03O000902012O00AA000100073O00121A000200423O00121A000300434O0046000100034O003900015O00121A3O001F3O00261D3O00A1020100010004C03O00A102012O00AA00015O00208400010001002A0020E10001000100042O001E0001000200020006F00001002902013O0004C03O002902012O00AA000100013O00207A0001000100444O00038O000400016O00010004000200062O0001002902013O0004C03O002902012O00AA000100094O006700025O00202O00020002002A4O000300023O00202O00030003002100122O0005003F6O0003000500024O000300036O00010003000200062O0001002902013O0004C03O002902012O00AA000100073O00121A000200453O00121A000300464O0046000100034O003900015O001252000100473O0006F00001003F02013O0004C03O003F02012O00AA000100013O0020380001000100444O00038O000400016O00010004000200062O0001003F020100010004C03O003F020100121A000100014O00A2000200023O000E6400010035020100010004C03O003502012O00AA000300104O009A0003000100022O003B000200033O0006F00002003F02013O0004C03O003F02012O00DC000200023O0004C03O003F02010004C03O003502012O00AA00015O0020840001000100480020E10001000100372O001E0001000200020006F00001005602013O0004C03O005602012O00AA000100094O003C00025O00202O0002000200484O000300023O00202O00030003000F4O00055O00202O0005000500484O0003000500024O000300036O00010003000200062O0001005602013O0004C03O005602012O00AA000100073O00121A000200493O00121A0003004A4O0046000100034O003900016O00AA000100113O0006F0000100A002013O0004C03O00A002012O00AA0001000E3O0006F0000100A002013O0004C03O00A002012O00AA00015O0020840001000100380020E10001000100372O001E0001000200020006F0000100A002013O0004C03O00A002012O00AA000100013O00203A00010001004B4O00035O00202O0003000300064O00010003000200062O000100A002013O0004C03O00A002012O00AA000100013O0020FE00010001004B4O00035O00202O0003000300364O00010003000200062O0001007C020100010004C03O007C02012O00AA00015O0020840001000100360020E10001000100392O001E000100020002000E8C004C007C020100010004C03O007C02012O00AA00015O0020840001000100360020E100010001000A2O001E000100020002000626000100A0020100010004C03O00A002012O00AA000100013O0020E100010001000C2O001E0001000200020026B1000100A00201004D0004C03O00A002012O00AA000100013O0020E100010001002D2O001E0001000200020026B10001008D020100080004C03O008D02012O00AA000100023O0020C70001000100414O00035O00202O0003000300094O000100030002000E2O00080090020100010004C03O009002012O00AA0001000A3O000E8A000200A0020100010004C03O00A002012O00AA000100094O006700025O00202O0002000200384O000300023O00202O00030003004E00122O0005000D6O0003000500024O000300036O00010003000200062O000100A002013O0004C03O00A002012O00AA000100073O00121A0002004F3O00121A000300504O0046000100034O003900015O00121A3O00023O00261D3O0001000100320004C03O000100012O00AA00015O0020840001000100510020E10001000100042O001E0001000200020006F0000100BC02013O0004C03O00BC02012O00AA0001000A3O000E8F001E00BC020100010004C03O00BC02012O00AA000100094O006700025O00202O0002000200514O000300023O00202O00030003002100122O000500276O0003000500024O000300036O00010003000200062O000100BC02013O0004C03O00BC02012O00AA000100073O00121A000200523O00121A000300534O0046000100034O003900016O00AA00015O0020840001000100540020E10001000100042O001E0001000200020006F0000100DE02013O0004C03O00DE02012O00AA000100013O0020E100010001002D2O001E0001000200020026A8000100CC020100080004C03O00CC02012O00AA000100013O0020E100010001000C2O001E000100020002000E8A002E00DE020100010004C03O00DE02012O00AA000100094O006700025O00202O0002000200544O000300023O00202O00030003002100122O000500086O0003000500024O000300036O00010003000200062O000100DE02013O0004C03O00DE02012O00AA000100073O001202000200553O00122O000300566O000100036O00015O00044O00DE02010004C03O000100012O006E3O00017O002F3O00028O00026O00F03F03093O0053746172737572676503073O0049735265616479026O001840026O002040030E3O0049735370652O6C496E52616E6765030F3O00122607284E1420013F1D0E250A7A0503053O003D6152665A03083O004D2O6F6E66697265026O001440026O001C4003093O00436173744379636C6503113O004D2O6F6E666972654D6F7573656F766572030F3O00A121A445C15E2O0CEC21BC4787064E03083O0069CC4ECB2BA7377E027O0040030E3O0048656172744F6654686557696C64030A3O0049734361737461626C6503113O00436F6E766F6B6554686553706972697473030F3O00432O6F6C646F776E52656D61696E73026O003E40025O00805640030B3O004973417661696C61626C6503083O0042752O66446F776E03173O00ADAF220C073BC8579ABE2B1B2C13CE5DA1EA2C091F449503083O0031C5CA437E7364A7030B3O004D2O6F6E6B696E466F726D03123O003A54D0278B5F50085DD03B8D165120579F7D03073O003E573BBF49E036026O00084003053O00577261746803073O00436174466F726D030E3O004973496E4D656C2O6552616E6765030C3O00F010FBDDEF42F5DEEB42AB9D03043O00A987629A03083O005374617266697265030F3O00D8632546FB3ADACE372B43F173999D03073O00A8AB1744349D5303073O0053756E6669726503103O0053756E666972654D6F7573656F766572030E3O00E764FBAB2C3F82B47EE2A1657CD503073O00E7941195CD454D03063O0042752O66557003093O004973496E52616E6765031E3O0083A8C9ED58F48598D3F352C093B7CEE95EEB93E7CAF458F18BAEC9BB06A703063O009FE0C7A79B37002C012O00121A3O00013O00261D3O004D000100020004C03O004D00012O00AA00015O0020840001000100030020E10001000100042O001E0001000200020006F00001002600013O0004C03O002600012O00AA000100013O0026A800010012000100050004C03O001200012O00AA000100023O00062600010026000100010004C03O002600012O00AA000100013O0026B100010026000100060004C03O002600012O00AA000100033O0006F00001002600013O0004C03O002600012O00AA000100044O003C00025O00202O0002000200034O000300053O00202O0003000300074O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001002600013O0004C03O002600012O00AA000100063O00121A000200083O00121A000300094O0046000100034O003900016O00AA00015O00208400010001000A0020E10001000100042O001E0001000200020006F00001004C00013O0004C03O004C00012O00AA000100013O0026A8000100350001000B0004C03O003500012O00AA000100023O0006260001004C000100010004C03O004C00012O00AA000100013O0026B10001004C0001000C0004C03O004C00012O00AA000100073O0020F100010001000D4O00025O00202O00020002000A4O000300086O000400096O000500053O00202O0005000500074O00075O00202O00070007000A4O0005000700024O000500056O000600076O0008000A3O00202O00080008000E4O00010008000200062O0001004C00013O0004C03O004C00012O00AA000100063O00121A0002000F3O00121A000300104O0046000100034O003900015O00121A3O00113O00261D3O0098000100010004C03O009800012O00AA00015O0020840001000100120020E10001000100132O001E0001000200020006F00001007C00013O0004C03O007C00012O00AA0001000B3O0006F00001007C00013O0004C03O007C00012O00AA00015O0020840001000100140020E10001000100152O001E0001000200020026A80001006A000100160004C03O006A00012O00AA00015O0020840001000100140020E10001000100152O001E000100020002000E8C0017006A000100010004C03O006A00012O00AA00015O0020840001000100140020E10001000100182O001E0001000200020006260001007C000100010004C03O007C00012O00AA0001000C3O00203A0001000100194O00035O00202O0003000300124O00010003000200062O0001007C00013O0004C03O007C00012O00AA000100044O00AA00025O0020840002000200122O001E0001000200020006F00001007C00013O0004C03O007C00012O00AA000100063O00121A0002001A3O00121A0003001B4O0046000100034O003900016O00AA00015O00208400010001001C0020E10001000100042O001E0001000200020006F00001009700013O0004C03O009700012O00AA0001000C3O00203A0001000100194O00035O00202O00030003001C4O00010003000200062O0001009700013O0004C03O009700012O00AA000100033O0006F00001009700013O0004C03O009700012O00AA000100044O00AA00025O00208400020002001C2O001E0001000200020006F00001009700013O0004C03O009700012O00AA000100063O00121A0002001D3O00121A0003001E4O0046000100034O003900015O00121A3O00023O00261D3O00E70001001F0004C03O00E700012O00AA00015O0020840001000100200020E10001000100042O001E0001000200020006F0000100CE00013O0004C03O00CE00012O00AA0001000C3O0020FE0001000100194O00035O00202O0003000300214O00010003000200062O000100AD000100010004C03O00AD00012O00AA000100053O0020E100010001002200121A000300064O00CD000100030002000626000100CE000100010004C03O00CE00012O00AA0001000D3O0006F0000100B300013O0004C03O00B300012O00AA000100013O0026A7000100BC000100020004C03O00BC00012O00AA0001000E3O000626000100BC000100010004C03O00BC00012O00AA0001000F3O0006F0000100CE00013O0004C03O00CE00012O00AA000100013O000E8A000200CE000100010004C03O00CE00012O00AA000100044O002B00025O00202O0002000200204O000300053O00202O0003000300074O00055O00202O0005000500204O0003000500024O000300036O000400016O00010004000200062O000100CE00013O0004C03O00CE00012O00AA000100063O00121A000200233O00121A000300244O0046000100034O003900016O00AA00015O0020840001000100250020E10001000100042O001E0001000200020006F00001002B2O013O0004C03O002B2O012O00AA000100044O002B00025O00202O0002000200254O000300053O00202O0003000300074O00055O00202O0005000500254O0003000500024O000300036O000400016O00010004000200062O0001002B2O013O0004C03O002B2O012O00AA000100063O001202000200263O00122O000300276O000100036O00015O00044O002B2O0100261D3O0001000100110004C03O000100012O00AA00015O0020840001000100280020E10001000100042O001E0001000200020006F0000100062O013O0004C03O00062O012O00AA000100073O0020F100010001000D4O00025O00202O0002000200284O000300086O000400106O000500053O00202O0005000500074O00075O00202O0007000700284O0005000700024O000500056O000600076O0008000A3O00202O0008000800294O00010008000200062O000100062O013O0004C03O00062O012O00AA000100063O00121A0002002A3O00121A0003002B4O0046000100034O003900016O00AA000100113O0006F0000100292O013O0004C03O00292O012O00AA0001000B3O0006F0000100292O013O0004C03O00292O012O00AA00015O0020840001000100140020E10001000100132O001E0001000200020006F0000100292O013O0004C03O00292O012O00AA0001000C3O00203A00010001002C4O00035O00202O00030003001C4O00010003000200062O000100292O013O0004C03O00292O012O00AA000100044O006700025O00202O0002000200144O000300053O00202O00030003002D00122O000500166O0003000500024O000300036O00010003000200062O000100292O013O0004C03O00292O012O00AA000100063O00121A0002002E3O00121A0003002F4O0046000100034O003900015O00121A3O001F3O0004C03O000100012O006E3O00017O00333O00028O00026O00144003093O0053746172737572676503073O004973526561647903083O0042752O66446F776E03073O00436174466F726D030E3O0049735370652O6C496E52616E676503113O00E4E73DC0E4E62ED5F2B331D3FEFD7C80AF03043O00B297935C03083O005374617266697265027O0040030F3O009FE94D2014456889BD43251E0C2BDA03073O001AEC9D2C52722C03053O005772617468030E3O004973496E4D656C2O6552616E6765026O002040030D3O003D3CD44F226ED85A232095087A03043O003B4A4EB5026O001840030C3O0053686F756C6452657475726E03113O00496E74652O72757074576974685374756E03123O00496E636170616369746174696E67526F617203063O0042752O665570030B3O00436F6D626F506F696E747303043O004D61696D026O00F03F2O033O00526970030B3O004973417661696C61626C6503043O0052616B65026O00084003063O00546872617368030D3O004164617074697665537761726D030A3O0049734361737461626C6503133O0024D55B4AA72CC75F65A032D04857F328D0535403053O00D345B12O3A026O00104003083O004D2O6F6E6669726503103O00BAEA76FBEFC2A5E039F8E8C2B9A52AA703063O00ABD78519958903043O00502O6F6C03133O00576169742F502O6F6C205265736F7572636573030B3O004D2O6F6E6B696E466F726D03073O0053756E6669726503113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66030F3O00F2DD3CFCE622F902ECC93BF4AF62A803083O002281A8529A8F509C030E3O004D2O6F6E66697265446562752O6603103O0088BD3C054E479B80F23E0A4140C9D7E403073O00E9E5D2536B282E030A3O004D696768747942617368006A012O00121A3O00014O00A2000100013O00261D3O0063000100020004C03O006300012O00AA00025O0020840002000200030020E10002000200042O001E0002000200020006F00002002200013O0004C03O002200012O00AA000200013O00203A0002000200054O00045O00202O0004000400064O00020004000200062O0002002200013O0004C03O002200012O00AA000200024O003C00035O00202O0003000300034O000400033O00202O0004000400074O00065O00202O0006000600034O0004000600024O000400046O00020004000200062O0002002200013O0004C03O002200012O00AA000200043O00121A000300083O00121A000400094O0046000200044O003900026O00AA00025O00208400020002000A0020E10002000200042O001E0002000200020006F00002003D00013O0004C03O003D00012O00AA000200053O000E8A000B003D000100020004C03O003D00012O00AA000200024O002B00035O00202O00030003000A4O000400033O00202O0004000400074O00065O00202O00060006000A4O0004000600024O000400046O000500016O00020005000200062O0002003D00013O0004C03O003D00012O00AA000200043O00121A0003000C3O00121A0004000D4O0046000200044O003900026O00AA00025O00208400020002000E0020E10002000200042O001E0002000200020006F00002006200013O0004C03O006200012O00AA000200013O0020FE0002000200054O00045O00202O0004000400064O00020004000200062O00020050000100010004C03O005000012O00AA000200033O0020E100020002000F00121A000400104O00CD00020004000200062600020062000100010004C03O006200012O00AA000200024O002B00035O00202O00030003000E4O000400033O00202O0004000400074O00065O00202O00060006000E4O0004000600024O000400046O000500016O00020005000200062O0002006200013O0004C03O006200012O00AA000200043O00121A000300113O00121A000400124O0046000200044O003900025O00121A3O00133O00261D3O008F000100010004C03O008F00012O00AA000200063O0020940002000200154O00035O00202O00030003001600122O000400106O00020004000200122O000200143O00122O000200143O00062O0002007100013O0004C03O00710001001252000200144O00DC000200024O00AA000200013O00203A0002000200174O00045O00202O0004000400064O00020004000200062O0002008E00013O0004C03O008E00012O00AA000200013O0020E10002000200182O001E000200020002000E8A0001008E000100020004C03O008E000100121A000200013O00261D0002007E000100010004C03O007E00012O00AA000300063O0020940003000300154O00045O00202O00040004001900122O000500106O00030005000200122O000300143O00122O000300143O00062O0003008E00013O0004C03O008E0001001252000300144O00DC000300023O0004C03O008E00010004C03O007E000100121A3O001A3O00261D3O00A20001000B0004C03O00A2000100121A000100014O00B000025O00202O00020002001B00202O00020002001C4O00020002000200062O0002009900013O0004C03O0099000100200800010001001A2O00AA00025O00208400020002001D0020E100020002001C2O001E0002000200020006F0000200A100013O0004C03O00A1000100200800020001001A00200800010002000100121A3O001E3O00261D3O00D70001001E0004C03O00D700012O00AA00025O00208400020002001F0020E100020002001C2O001E0002000200020006F0000200AB00013O0004C03O00AB000100200800010001001A000E8F000B00BF000100010004C03O00BF00012O00AA000200033O0020E100020002000F00121A000400104O00CD0002000400020006F0000200BF00013O0004C03O00BF000100121A000200014O00A2000300033O00261D000200B5000100010004C03O00B500012O00AA000400074O009A0004000100022O003B000300043O0006F0000300BF00013O0004C03O00BF00012O00DC000300023O0004C03O00BF00010004C03O00B500012O00AA00025O0020840002000200200020E10002000200212O001E0002000200020006F0000200D600013O0004C03O00D600012O00AA000200024O003C00035O00202O0003000300204O000400033O00202O0004000400074O00065O00202O0006000600204O0004000600024O000400046O00020004000200062O000200D600013O0004C03O00D600012O00AA000200043O00121A000300223O00121A000400234O0046000200044O003900025O00121A3O00243O00261D3O00062O0100130004C03O00062O012O00AA00025O0020840002000200250020E10002000200042O001E0002000200020006F0000200FD00013O0004C03O00FD00012O00AA000200013O0020FE0002000200054O00045O00202O0004000400064O00020004000200062O000200EC000100010004C03O00EC00012O00AA000200033O0020E100020002000F00121A000400104O00CD000200040002000626000200FD000100010004C03O00FD00012O00AA000200024O003C00035O00202O0003000300254O000400033O00202O0004000400074O00065O00202O0006000600254O0004000600024O000400046O00020004000200062O000200FD00013O0004C03O00FD00012O00AA000200043O00121A000300263O00121A000400274O0046000200044O003900026O00AA000200024O00AA00035O0020840003000300282O001E0002000200020006F0000200692O013O0004C03O00692O0100121A000200294O00DC000200023O0004C03O00692O0100261D3O00572O0100240004C03O00572O012O00AA00025O00208400020002002A0020E100020002001C2O001E0002000200020006F00002001A2O013O0004C03O001A2O0100121A000200014O00A2000300033O00261D000200102O0100010004C03O00102O012O00AA000400084O009A0004000100022O003B000300043O0006F00003001A2O013O0004C03O001A2O012O00DC000300023O0004C03O001A2O010004C03O00102O012O00AA00025O00208400020002002B0020E10002000200042O001E0002000200020006F0000200382O013O0004C03O00382O012O00AA000200033O00203A00020002002C4O00045O00202O00040004002D4O00020004000200062O000200382O013O0004C03O00382O012O00AA000200024O003C00035O00202O00030003002B4O000400033O00202O0004000400074O00065O00202O00060006002B4O0004000600024O000400046O00020004000200062O000200382O013O0004C03O00382O012O00AA000200043O00121A0003002E3O00121A0004002F4O0046000200044O003900026O00AA00025O0020840002000200250020E10002000200042O001E0002000200020006F0000200562O013O0004C03O00562O012O00AA000200033O00203A00020002002C4O00045O00202O0004000400304O00020004000200062O000200562O013O0004C03O00562O012O00AA000200024O003C00035O00202O0003000300254O000400033O00202O0004000400074O00065O00202O0006000600254O0004000600024O000400046O00020004000200062O000200562O013O0004C03O00562O012O00AA000200043O00121A000300313O00121A000400324O0046000200044O003900025O00121A3O00023O00261D3O00020001001A0004C03O000200012O00AA000200063O0020940002000200154O00035O00202O00030003003300122O000400106O00020004000200122O000200143O00122O000200143O00062O000200652O013O0004C03O00652O01001252000200144O00DC000200024O00AA000200094O00D800020001000100121A3O000B3O0004C03O000200012O006E3O00017O00063O0003173O0044697370652O6C61626C65467269656E646C79556E6974030B3O004E6174757265734375726503073O004973526561647903103O004E61747572657343757265466F63757303153O00CF4326C317C4510DD510D34772D20CD25237DA459303053O0065A12252B6001A4O00AA7O0006F03O001900013O0004C03O001900012O00AA3O00013O0020845O00012O009A3O000100020006F03O001900013O0004C03O001900012O00AA3O00023O0020845O00020020E15O00032O001E3O000200020006F03O001900013O0004C03O001900012O00AA3O00034O00AA000100043O0020840001000100042O001E3O000200020006F03O001900013O0004C03O001900012O00AA3O00053O00121A000100053O00121A000200064O00463O00024O00398O006E3O00017O00123O00028O0003103O004865616C746850657263656E7461676503083O004261726B736B696E03073O004973526561647903143O00EA0C4BF5C8E98B20A8095CF8DEEC9127FE0819AC03083O004E886D399EBB82E203073O0052656E6577616C03133O002C3AF7F4293EF5B12O3AFFF4302CF0E73B7FAB03043O00915E5F99026O00F03F030B3O004865616C746873746F6E6503173O00F5C815D95ABFEED91BDB4BF7F9C812D040A4F4DB11951D03063O00D79DAD74B52E03193O0007B18DE0DF26BC82FCDD759C8EF3D63CBA8CB2EA3AA082FDD403053O00BA55D4EB9203173O0052656672657368696E674865616C696E67506F74696F6E03253O00D08410EC3CFD50CB8F11BE31EB59CE8818F979FE57D68819F079EA5DC48418ED30F85D82D503073O0038A2E1769E598E00803O00121A3O00013O00261D3O003C000100010004C03O003C00012O00AA00015O0020E10001000100022O001E0001000200022O00AA000200013O00064A0001001F000100020004C03O001F00012O00AA000100023O0006F00001001F00013O0004C03O001F00012O00AA000100033O0020840001000100030020E10001000100042O001E0001000200020006F00001001F00013O0004C03O001F00012O00AA000100044O0035000200033O00202O0002000200034O000300046O000500016O00010005000200062O0001001F00013O0004C03O001F00012O00AA000100053O00121A000200053O00121A000300064O0046000100034O003900016O00AA00015O0020E10001000100022O001E0001000200022O00AA000200063O00064A0001003B000100020004C03O003B00012O00AA000100073O0006F00001003B00013O0004C03O003B00012O00AA000100033O0020840001000100070020E10001000100042O001E0001000200020006F00001003B00013O0004C03O003B00012O00AA000100044O0035000200033O00202O0002000200074O000300046O000500016O00010005000200062O0001003B00013O0004C03O003B00012O00AA000100053O00121A000200083O00121A000300094O0046000100034O003900015O00121A3O000A3O00261D3O00010001000A0004C03O000100012O00AA000100083O00208400010001000B0020E10001000100042O001E0001000200020006F00001005A00013O0004C03O005A00012O00AA000100093O0006F00001005A00013O0004C03O005A00012O00AA00015O0020E10001000100022O001E0001000200022O00AA0002000A3O00064A0001005A000100020004C03O005A00012O00AA000100044O00350002000B3O00202O00020002000B4O000300046O000500016O00010005000200062O0001005A00013O0004C03O005A00012O00AA000100053O00121A0002000C3O00121A0003000D4O0046000100034O003900016O00AA0001000C3O0006F00001007F00013O0004C03O007F00012O00AA00015O0020E10001000100022O001E0001000200022O00AA0002000D3O00064A0001007F000100020004C03O007F00012O00AA0001000E4O000C000200053O00122O0003000E3O00122O0004000F6O00020004000200062O0001007F000100020004C03O007F00012O00AA000100083O0020840001000100100020E10001000100042O001E0001000200020006F00001007F00013O0004C03O007F00012O00AA000100044O00350002000B3O00202O0002000200104O000300046O000500016O00010005000200062O0001007F00013O0004C03O007F00012O00AA000100053O001202000200113O00122O000300126O000100036O00015O00044O007F00010004C03O000100012O006E3O00017O001F3O00028O0003063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O00444003093O0053776966746D656E6403073O004973526561647903083O0042752O66446F776E03133O00536F756C4F66546865466F7265737442752O6603113O0052656A7576656E6174696F6E466F63757303113O004E00CABA34DD5204D4A62DD61C17C1A23203063O00B83C65A0CF42026O00F03F030E3O0053776966746D656E64466F637573030E3O00229575BA258F79B235C26EBD3C9203043O00DC51E21C03063O0042752O665570030A3O0057696C6467726F777468030F3O0057696C6467726F777468466F637573030F3O0004DC8EFFEDD51CC296F3AAD512D89203063O00A773B5E29B8A027O004003093O00492O6E657276617465030F3O00492O6E657276617465506C61796572030E3O00EB2CE9596967C7F627A74E7A7CD603073O00A68242873C1B11030F3O0042752O665265667265736861626C65030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F76657203173O00564FC460264144CF61394B44F176294746CB35224547DE03053O0050242AAE1500AC3O00121A3O00013O00261D3O0035000100010004C03O003500012O00AA00015O0006F00001001600013O0004C03O001600012O00AA00015O0020E10001000100022O001E0001000200020006F00001001600013O0004C03O001600012O00AA00015O0020E10001000100032O001E00010002000200062600010016000100010004C03O001600012O00AA00015O0020E100010001000400121A000300054O00CD00010003000200062600010017000100010004C03O001700012O006E3O00014O00AA000100013O0020840001000100060020E10001000100072O001E0001000200020006F00001003400013O0004C03O003400012O00AA000100024O00AA00026O001E00010002000200062600010034000100010004C03O003400012O00AA000100033O00203A0001000100084O000300013O00202O0003000300094O00010003000200062O0001003400013O0004C03O003400012O00AA000100044O00AA000200053O00208400020002000A2O001E0001000200020006F00001003400013O0004C03O003400012O00AA000100063O00121A0002000B3O00121A0003000C4O0046000100034O003900015O00121A3O000D3O000E64000D006800013O0004C03O006800012O00AA000100013O0020840001000100060020E10001000100072O001E0001000200020006F00001004D00013O0004C03O004D00012O00AA000100024O00AA00026O001E0001000200020006F00001004D00013O0004C03O004D00012O00AA000100044O00AA000200053O00208400020002000E2O001E0001000200020006F00001004D00013O0004C03O004D00012O00AA000100063O00121A0002000F3O00121A000300104O0046000100034O003900016O00AA000100033O00203A0001000100114O000300013O00202O0003000300094O00010003000200062O0001006700013O0004C03O006700012O00AA000100013O0020840001000100120020E10001000100072O001E0001000200020006F00001006700013O0004C03O006700012O00AA000100044O0035000200053O00202O0002000200134O000300036O000400016O00010004000200062O0001006700013O0004C03O006700012O00AA000100063O00121A000200143O00121A000300154O0046000100034O003900015O00121A3O00163O00261D3O0001000100160004C03O000100012O00AA000100013O0020840001000100170020E10001000100072O001E0001000200020006F00001008400013O0004C03O008400012O00AA000100033O00203A0001000100084O000300013O00202O0003000300174O00010003000200062O0001008400013O0004C03O008400012O00AA000100044O0035000200053O00202O0002000200184O000300046O000500016O00010005000200062O0001008400013O0004C03O008400012O00AA000100063O00121A000200193O00121A0003001A4O0046000100034O003900016O00AA000100033O00203A0001000100114O000300013O00202O0003000300174O00010003000200062O000100AB00013O0004C03O00AB00012O00AA000100074O009A000100010002000E8A000100AB000100010004C03O00AB00012O00AA000100083O0006F0000100AB00013O0004C03O00AB00012O00AA000100083O0020E10001000100022O001E0001000200020006F0000100AB00013O0004C03O00AB00012O00AA000100083O00203A00010001001B4O000300013O00202O00030003001C4O00010003000200062O000100AB00013O0004C03O00AB00012O00AA000100044O00AA000200053O00208400020002001D2O001E0001000200020006F0000100AB00013O0004C03O00AB00012O00AA000100063O0012020002001E3O00122O0003001F6O000100036O00015O00044O00AB00010004C03O000100012O006E3O00017O00843O00028O0003063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O004440026O00F03F03063O0042752O66557003133O00536F756C4F66546865466F7265737442752O66030A3O0057696C6467726F77746803073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030F3O0057696C6467726F777468466F63757303173O0059193B7E4902386D5A1808694104313A46153676471E3003043O001A2E7057030E3O0047726F7665477561726469616E7303113O0054696D6553696E63654C61737443617374026O00144003133O0047726F7665477561726469616E73466F63757303173O00BE31A462BA8042A1B831AF7DBEB156F4B126AA78B6B14203083O00D4D943CB142ODF25030F3O00412O66656374696E67436F6D62617403083O00466C6F757269736803083O0042752O66446F776E026O00104003103O00BC81A7C7A884BBDAFA85ADD3B684A6D503043O00B2DAEDC8027O0040026O001C4003083O00526567726F777468030A3O0049734361737461626C65030C3O0052656A7576656E6174696F6E03103O004865616C746850657263656E74616765030D3O00526567726F777468466F63757303103O00A4B0E1C2B9A2F2D8F6BDE3D1BABCE8D703043O00B0D6D58603063O00D5A3AFDBA65303073O003994CDD6B4C83603083O0049726F6E4261726B030D3O0049726F6E4261726B466F63757303113O001BEF2O3A4910FC273F361AF834387F1CFA03053O0016729D555403093O00F0CA1DCF1DD9A6C8D203073O00C8A4AB73A43D9603073O00436F2O6D6F6E73030D3O00556E697447726F7570526F6C6503043O008AD52D6E03053O00E3DE94632503113O003A405DF8C6315340FDB93B5753FAF03D5503053O0099532O3296030D3O0069777D1733AA43593640197FAD03073O002D3D16137C13CB03043O00F53323DE03073O00D9A1726D95621003063O003A051950994603063O00147240581CDC03113O003813DDBAC7D2BC230A92BCFDD1B1380FD503073O00DD5161B2D498B0030D3O004164617074697665537761726D03123O004164617074697665537761726D466F63757303163O00CCE31CEB0EC4F118C409DAE60FF65AC5E21CF713C3E003053O007AAD877D9B03043O00B0E02E9203073O00A8E4A160D95F51031A3O00467269656E646C79556E6974735769746842752O66436F756E7403093O004C696665626C2O6F6D03073O00436174466F726D026O002E40030F3O0042752O665265667265736861626C65030E3O004C696665626C2O6F6D466F63757303113O00D7D828592D5BD4DE231C2752DADD27522803063O0037BBB14E3C4F030B3O005472616E7175696C69747903133O0039DC5EE557DA8921C74BF206C7852CC256E54103073O00E04DAE3F8B26AF030F3O00496E6361726E6174696F6E42752O6603183O0090535920955451228D55411190535D2BC4495D2F8848562903043O004EE4213803113O00436F6E766F6B6554686553706972697473031B3O00CD71BC158AC57B8D178DCB41A1138CDC77A610C5C67BB30F8CC07903053O00E5AE1ED263026O000840026O00184003103O0009E88143E22A2D13AD8E54EC313015EA03073O00597B8DE6318D5D03093O00492O6E65727661746503153O0052656A7576656E6174696F6E4D6F7573656F766572031A3O00E174FC19064FFD70E2051F44CC72EF0F1C4FB379F30D1C43FD7603063O002A9311966C7003113O0052656A7576656E6174696F6E466F63757303143O001DA3276AF1ED01A73976E8E64FAE287EEBE101A103063O00886FC64D1F8703043O003628897D03083O00C96269C736DD8477030B3O00556E64657267726F777468030B3O004973417661696C61626C65030A3O004973536F6C6F4D6F646503113O00B50585240039A3B601C3290734A0B0028403073O00CCD96CE341625503063O006ECFF4FC29D203063O00A03EA395854C030D3O00452O666C6F72657363656E636503133O00452O666C6F72657363656E6365506C61796572031C3O00D3A60B23CCC4A51E2CC6D8A3086FCBD3A10126CDD1E01D23C2CFA51F03053O00A3B6C06D4F03063O00173312D3FA2603053O0095544660A003133O00452O666C6F72657363656E6365437572736F72031C3O003D000BE1371408FE3B2O03EE3D4605E8390A04E33F460EF82A1502FF03043O008D58666D030C3O00905CC476132F58C0A75AC57E03083O00A1D333AA107A5D3503223O00FEA8B424F4BCB73BF8ABBC2BFEEEBA2DFAA2BB26FCEEB127F5A8BB3AF6AFA621F4A003043O00489BCED203093O0053776966746D656E6403123O005173580A345475431A3B0672510F3F4F745303053O0053261A346E030C3O0043656E6172696F6E5761726403113O0043656E6172696F6E57617264466F63757303153O005B1229474A1E2848670026545C572F43591B2E485F03043O002638774703103O004E61747572657353776966746E652O73031A3O00E1EA5FC42A412OE767C5325FF5FB56D33645B3E75DD7295FFDE803063O0036938F38B64503193O00D880EB5CCDD392C05AC8DF87EB47DAC592BF41DAD78DF647D803053O00BFB6E19F29030B3O005573655472696E6B657473030C3O004E617475726573566967696C03153O0025133C409982D114042152828B82231729598289C503073O00A24B724835EBE7030E3O0053776966746D656E64466F63757303113O009F2B4DE4470F893240A25B078D304DEC5403063O0062EC5C24823300DB032O00121A3O00013O00261D3O0001000100010004C03O000100012O00AA00015O0006F00001001600013O0004C03O001600012O00AA00015O0020E10001000100022O001E0001000200020006F00001001600013O0004C03O001600012O00AA00015O0020E10001000100032O001E00010002000200062600010016000100010004C03O001600012O00AA00015O0020E100010001000400121A000300054O00CD00010003000200062600010017000100010004C03O001700012O006E3O00014O00AA000100013O0006F0000100DA03013O0004C03O00DA030100121A000100013O00261D0001008E000100060004C03O008E00012O00AA000200023O00203A0002000200074O000400033O00202O0004000400084O00020004000200062O0002003E00013O0004C03O003E00012O00AA000200033O0020840002000200090020E100020002000A2O001E0002000200020006F00002003E00013O0004C03O003E00012O00AA000200043O00203600020002000B4O000300056O000400066O00020004000200062O0002003E00013O0004C03O003E00012O00AA000200074O0035000300083O00202O00030003000C4O000400046O000500016O00020005000200062O0002003E00013O0004C03O003E00012O00AA000200093O00121A0003000D3O00121A0004000E4O0046000200044O003900026O00AA0002000A3O0006F00002006000013O0004C03O006000012O00AA000200033O00208400020002000F0020E100020002000A2O001E0002000200020006F00002006000013O0004C03O006000012O00AA000200033O00208400020002000F0020E10002000200102O001E000200020002000E8A00110060000100020004C03O006000012O00AA000200043O00203600020002000B4O0003000B6O0004000C6O00020004000200062O0002006000013O0004C03O006000012O00AA000200074O0007010300083O00202O0003000300124O000400056O00020005000200062O0002006000013O0004C03O006000012O00AA000200093O00121A000300133O00121A000400144O0046000200044O003900026O00AA000200023O0020E10002000200152O001E0002000200020006F00002008D00013O0004C03O008D00012O00AA0002000D3O0006F00002008D00013O0004C03O008D00012O00AA000200033O0020840002000200160020E100020002000A2O001E0002000200020006F00002008D00013O0004C03O008D00012O00AA000200023O00203A0002000200174O000400033O00202O0004000400164O00020004000200062O0002008D00013O0004C03O008D00012O00AA0002000E4O009A000200010002000E8A0018008D000100020004C03O008D00012O00AA000200043O00203600020002000B4O0003000F6O000400106O00020004000200062O0002008D00013O0004C03O008D00012O00AA000200074O0035000300033O00202O0003000300164O000400056O000600016O00020006000200062O0002008D00013O0004C03O008D00012O00AA000200093O00121A000300193O00121A0004001A4O0046000200044O003900025O00121A0001001B3O00261D000100B40001001C0004C03O00B400012O00AA000200033O00208400020002001D0020E100020002001E2O001E0002000200020006F0000200DA03013O0004C03O00DA03012O00AA000200113O0006F0000200DA03013O0004C03O00DA03012O00AA00025O00203A0002000200074O000400033O00202O00040004001F4O00020004000200062O000200DA03013O0004C03O00DA03012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300123O00064A000200DA030100030004C03O00DA03012O00AA000200074O0035000300083O00202O0003000300214O000400046O000500016O00020005000200062O000200DA03013O0004C03O00DA03012O00AA000200093O001202000300223O00122O000400236O000200046O00025O00044O00DA030100261D000100892O0100180004C03O00892O012O00AA000200134O000C000300093O00122O000400243O00122O000500256O00030005000200062O000200D5000100030004C03O00D500012O00AA000200033O0020840002000200260020E100020002000A2O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300143O00064A000200302O0100030004C03O00302O012O00AA000200074O00AA000300083O0020840003000300272O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA000200093O001202000300283O00122O000400296O000200046O00025O00044O00302O012O00AA000200134O000C000300093O00122O0004002A3O00122O0005002B6O00030005000200062O000200FE000100030004C03O00FE00012O00AA000200033O0020840002000200260020E100020002000A2O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300143O00064A000200302O0100030004C03O00302O010012520002002C3O00200600020002002D4O00038O0002000200024O000300093O00122O0004002E3O00122O0005002F6O00030005000200062O000200302O0100030004C03O00302O012O00AA000200074O00AA000300083O0020840003000300272O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA000200093O001202000300303O00122O000400316O000200046O00025O00044O00302O012O00AA000200134O000C000300093O00122O000400323O00122O000500336O00030005000200062O000200302O0100030004C03O00302O012O00AA000200033O0020840002000200260020E100020002000A2O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300143O00064A000200302O0100030004C03O00302O010012520002002C3O0020B400020002002D4O00038O0002000200024O000300093O00122O000400343O00122O000500356O00030005000200062O000200252O0100030004C03O00252O010012520002002C3O00200600020002002D4O00038O0002000200024O000300093O00122O000400363O00122O000500376O00030005000200062O000200302O0100030004C03O00302O012O00AA000200074O00AA000300083O0020840003000300272O001E0002000200020006F0000200302O013O0004C03O00302O012O00AA000200093O00121A000300383O00121A000400394O0046000200044O003900026O00AA000200033O00208400020002003A0020E100020002001E2O001E0002000200020006F0000200462O013O0004C03O00462O012O00AA000200023O0020E10002000200152O001E0002000200020006F0000200462O013O0004C03O00462O012O00AA000200074O00AA000300083O00208400030003003B2O001E0002000200020006F0000200462O013O0004C03O00462O012O00AA000200093O00121A0003003C3O00121A0004003D4O0046000200044O003900026O00AA000200023O0020E10002000200152O001E0002000200020006F0000200882O013O0004C03O00882O012O00AA000200153O0006F0000200882O013O0004C03O00882O012O00AA000200043O00200600020002002D4O00038O0002000200024O000300093O00122O0004003E3O00122O0005003F6O00030005000200062O000200882O0100030004C03O00882O012O00AA000200043O0020790002000200404O000300033O00202O0003000300414O000400016O00058O00020005000200262O000200882O0100060004C03O00882O012O00AA00025O00204F0002000200204O0002000200024O000300166O000400176O000500023O00202O0005000500074O000700033O00202O0007000700424O000500076O00043O000200202O0004000400434O00030003000400062O000200882O0100030004C03O00882O012O00AA000200033O0020840002000200410020E100020002001E2O001E0002000200020006F0000200882O013O0004C03O00882O012O00AA00025O00203A0002000200444O000400033O00202O0004000400414O00020004000200062O000200882O013O0004C03O00882O012O00AA000200074O00AA000300083O0020840003000300452O001E0002000200020006F0000200882O013O0004C03O00882O012O00AA000200093O00121A000300463O00121A000400474O0046000200044O003900025O00121A000100113O00261D000100F72O01001B0004C03O00F72O012O00AA000200023O0020E10002000200152O001E0002000200020006F0000200AD2O013O0004C03O00AD2O012O00AA0002000D3O0006F0000200AD2O013O0004C03O00AD2O012O00AA000200033O0020840002000200480020E100020002000A2O001E0002000200020006F0000200AD2O013O0004C03O00AD2O012O00AA000200043O00203600020002000B4O000300186O000400196O00020004000200062O000200AD2O013O0004C03O00AD2O012O00AA000200074O0035000300033O00202O0003000300484O000400046O000500016O00020005000200062O000200AD2O013O0004C03O00AD2O012O00AA000200093O00121A000300493O00121A0004004A4O0046000200044O003900026O00AA000200023O0020E10002000200152O001E0002000200020006F0000200D62O013O0004C03O00D62O012O00AA0002000D3O0006F0000200D62O013O0004C03O00D62O012O00AA000200033O0020840002000200480020E100020002000A2O001E0002000200020006F0000200D62O013O0004C03O00D62O012O00AA000200023O00203A0002000200074O000400033O00202O00040004004B4O00020004000200062O000200D62O013O0004C03O00D62O012O00AA000200043O00203600020002000B4O0003001A6O0004001B6O00020004000200062O000200D62O013O0004C03O00D62O012O00AA000200074O0035000300033O00202O0003000300484O000400046O000500016O00020005000200062O000200D62O013O0004C03O00D62O012O00AA000200093O00121A0003004C3O00121A0004004D4O0046000200044O003900026O00AA000200023O0020E10002000200152O001E0002000200020006F0000200F62O013O0004C03O00F62O012O00AA0002000D3O0006F0000200F62O013O0004C03O00F62O012O00AA000200033O00208400020002004E0020E100020002000A2O001E0002000200020006F0000200F62O013O0004C03O00F62O012O00AA000200043O00203600020002000B4O0003001C6O0004001D6O00020004000200062O000200F62O013O0004C03O00F62O012O00AA000200074O00AA000300033O00208400030003004E2O001E0002000200020006F0000200F62O013O0004C03O00F62O012O00AA000200093O00121A0003004F3O00121A000400504O0046000200044O003900025O00121A000100513O00261D0001005C020100520004C03O005C02012O00AA000200033O00208400020002001D0020E100020002001E2O001E0002000200020006F00002001502013O0004C03O001502012O00AA0002001E3O0006F00002001502013O0004C03O001502012O00AA00025O0020E10002000200202O001E0002000200022O00AA0003001F3O00064A00020015020100030004C03O001502012O00AA000200074O0035000300083O00202O0003000300214O000400046O000500016O00020005000200062O0002001502013O0004C03O001502012O00AA000200093O00121A000300533O00121A000400544O0046000200044O003900026O00AA000200023O00203A0002000200074O000400033O00202O0004000400554O00020004000200062O0002003A02013O0004C03O003A02012O00AA000200204O009A000200010002000E8A0001003A020100020004C03O003A02012O00AA000200213O0006F00002003A02013O0004C03O003A02012O00AA000200213O0020E10002000200022O001E0002000200020006F00002003A02013O0004C03O003A02012O00AA000200213O00203A0002000200444O000400033O00202O00040004001F4O00020004000200062O0002003A02013O0004C03O003A02012O00AA000200074O00AA000300083O0020840003000300562O001E0002000200020006F00002003A02013O0004C03O003A02012O00AA000200093O00121A000300573O00121A000400584O0046000200044O003900026O00AA000200033O00208400020002001F0020E100020002001E2O001E0002000200020006F00002005B02013O0004C03O005B02012O00AA000200223O0006F00002005B02013O0004C03O005B02012O00AA00025O00203A0002000200444O000400033O00202O00040004001F4O00020004000200062O0002005B02013O0004C03O005B02012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300233O00064A0002005B020100030004C03O005B02012O00AA000200074O00AA000300083O0020840003000300592O001E0002000200020006F00002005B02013O0004C03O005B02012O00AA000200093O00121A0003005A3O00121A0004005B4O0046000200044O003900025O00121A0001001C3O000E640011002E030100010004C03O002E03012O00AA000200023O0020E10002000200152O001E0002000200020006F0000200AB02013O0004C03O00AB02012O00AA000200243O0006F0000200AB02013O0004C03O00AB02012O00AA000200043O0020B400020002002D4O00038O0002000200024O000300093O00122O0004005C3O00122O0005005D6O00030005000200062O000200AB020100030004C03O00AB02012O00AA000200043O0020790002000200404O000300033O00202O0003000300414O00048O000500016O00020005000200262O000200AB020100060004C03O00AB02012O00AA000200033O00208400020002005E0020E100020002005F2O001E00020002000200062600020084020100010004C03O008402012O00AA000200043O0020840002000200602O009A0002000100020006F0000200AB02013O0004C03O00AB02012O00AA00025O00204F0002000200204O0002000200024O000300256O000400176O000500023O00202O0005000500074O000700033O00202O0007000700424O000500076O00043O000200202O0004000400434O00030003000400062O000200AB020100030004C03O00AB02012O00AA000200033O0020840002000200410020E100020002001E2O001E0002000200020006F0000200AB02013O0004C03O00AB02012O00AA00025O00203A0002000200444O000400033O00202O0004000400414O00020004000200062O000200AB02013O0004C03O00AB02012O00AA000200074O00AA000300083O0020840003000300452O001E0002000200020006F0000200AB02013O0004C03O00AB02012O00AA000200093O00121A000300613O00121A000400624O0046000200044O003900026O00AA000200264O000C000300093O00122O000400633O00122O000500646O00030005000200062O000200C9020100030004C03O00C902012O00AA000200023O0020E10002000200152O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200033O0020840002000200650020E10002000200102O001E000200020002000E8A00430004030100020004C03O000403012O00AA000200074O00AA000300083O0020840003000300662O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200093O001202000300673O00122O000400686O000200046O00025O00044O000403012O00AA000200264O000C000300093O00122O000400693O00122O0005006A6O00030005000200062O000200E7020100030004C03O00E702012O00AA000200023O0020E10002000200152O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200033O0020840002000200650020E10002000200102O001E000200020002000E8A00430004030100020004C03O000403012O00AA000200074O00AA000300083O00208400030003006B2O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200093O0012020003006C3O00122O0004006D6O000200046O00025O00044O000403012O00AA000200264O000C000300093O00122O0004006E3O00122O0005006F6O00030005000200062O00020004030100030004C03O000403012O00AA000200023O0020E10002000200152O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200033O0020840002000200650020E10002000200102O001E000200020002000E8A00430004030100020004C03O000403012O00AA000200074O00AA000300033O0020840003000300652O001E0002000200020006F00002000403013O0004C03O000403012O00AA000200093O00121A000300703O00121A000400714O0046000200044O003900026O00AA000200033O0020840002000200090020E100020002000A2O001E0002000200020006F00002002D03013O0004C03O002D03012O00AA000200273O0006F00002002D03013O0004C03O002D03012O00AA000200043O00203600020002000B4O000300286O000400296O00020004000200062O0002002D03013O0004C03O002D03012O00AA000200033O0020840002000200720020E100020002005F2O001E0002000200020006F00002002003013O0004C03O002003012O00AA000200033O0020840002000200720020E100020002000A2O001E0002000200020006260002002D030100010004C03O002D03012O00AA000200074O0035000300083O00202O00030003000C4O000400046O000500016O00020005000200062O0002002D03013O0004C03O002D03012O00AA000200093O00121A000300733O00121A000400744O0046000200044O003900025O00121A000100523O000E640051007D030100010004C03O007D03012O00AA000200033O0020840002000200750020E100020002000A2O001E0002000200020006F00002004A03013O0004C03O004A03012O00AA0002002A3O0006F00002004A03013O0004C03O004A03012O00AA00025O0020E10002000200202O001E0002000200022O00AA0003002B3O00064A0002004A030100030004C03O004A03012O00AA000200074O00AA000300083O0020840003000300762O001E0002000200020006F00002004A03013O0004C03O004A03012O00AA000200093O00121A000300773O00121A000400784O0046000200044O003900026O00AA000200023O00203A0002000200074O000400033O00202O0004000400794O00020004000200062O0002006203013O0004C03O006203012O00AA000200033O00208400020002001D0020E100020002001E2O001E0002000200020006F00002006203013O0004C03O006203012O00AA000200074O00AA000300083O0020840003000300212O001E0002000200020006F00002006203013O0004C03O006203012O00AA000200093O00121A0003007A3O00121A0004007B4O0046000200044O003900026O00AA000200033O0020840002000200790020E100020002000A2O001E0002000200020006F00002007C03013O0004C03O007C03012O00AA0002002C3O0006F00002007C03013O0004C03O007C03012O00AA00025O0020E10002000200202O001E0002000200022O00AA0003002D3O00064A0002007C030100030004C03O007C03012O00AA000200074O00AA000300033O0020840003000300792O001E0002000200020006F00002007C03013O0004C03O007C03012O00AA000200093O00121A0003007C3O00121A0004007D4O0046000200044O003900025O00121A000100183O00261D0001001B000100010004C03O001B00010012520002007E3O0006F00002008E03013O0004C03O008E030100121A000200014O00A2000300033O00261D00020084030100010004C03O008403012O00AA0004002E4O009A0004000100022O003B000300043O0006F00003008E03013O0004C03O008E03012O00DC000300023O0004C03O008E03010004C03O008403012O00AA0002002F3O0006F0000200B003013O0004C03O00B003012O00AA0002000D3O0006F0000200B003013O0004C03O00B003012O00AA000200023O0020E10002000200152O001E0002000200020006F0000200B003013O0004C03O00B003012O00AA0002000E4O009A000200010002000E8A005100B0030100020004C03O00B003012O00AA000200033O00208400020002007F0020E100020002000A2O001E0002000200020006F0000200B003013O0004C03O00B003012O00AA000200074O0035000300033O00202O00030003007F4O000400056O000600016O00020006000200062O000200B003013O0004C03O00B003012O00AA000200093O00121A000300803O00121A000400814O0046000200044O003900026O00AA000200033O0020840002000200720020E100020002000A2O001E0002000200020006F0000200D603013O0004C03O00D603012O00AA000200303O0006F0000200D603013O0004C03O00D603012O00AA000200023O00203A0002000200174O000400033O00202O0004000400084O00020004000200062O000200D603013O0004C03O00D603012O00AA000200314O00AA00036O001E0002000200020006F0000200D603013O0004C03O00D603012O00AA00025O0020E10002000200202O001E0002000200022O00AA000300323O00064A000200D6030100030004C03O00D603012O00AA000200074O00AA000300083O0020840003000300822O001E0002000200020006F0000200D603013O0004C03O00D603012O00AA000200093O00121A000300833O00121A000400844O0046000200044O003900025O00121A000100063O0004C03O001B00010004C03O00DA03010004C03O000100012O006E3O00017O00123O00028O00026O000840030D3O00546172676574497356616C6964027O0040030F3O0048616E646C65412O666C696374656403093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572026O004440026O001040026O00F03F030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F766572030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F76657203083O00526567726F77746803113O00526567726F7774684D6F7573656F76657200A43O00121A3O00014O00A2000100013O00261D3O001B000100020004C03O001B00010006F00001000700013O0004C03O000700012O00DC000100024O00AA00025O0020840002000200032O009A0002000100020006F0000200A300013O0004C03O00A300012O00AA000200013O0006F0000200A300013O0004C03O00A3000100121A000200013O000E6400010010000100020004C03O001000012O00AA000300024O009A0003000100022O003B000100033O0006F0000100A300013O0004C03O00A300012O00DC000100023O0004C03O00A300010004C03O001000010004C03O00A3000100261D3O002F000100040004C03O002F00012O00AA000200033O0006F00002002B00013O0004C03O002B000100121A000200013O000E6400010021000100020004C03O002100012O00AA000300044O009A0003000100022O003B000100033O0006F00001002B00013O0004C03O002B00012O00DC000100023O0004C03O002B00010004C03O002100012O00AA000200054O009A0002000100022O003B000100023O00121A3O00023O00261D3O0099000100010004C03O009900012O00AA000200063O0006F00002008300013O0004C03O0083000100121A000200013O00261D00020044000100020004C03O004400012O00AA00035O0020070003000300054O000400073O00202O0004000400064O000500083O00202O00050005000700122O000600086O0003000600024O000100033O00062O0001004300013O0004C03O004300012O00DC000100023O00121A000200093O00261D000200530001000A0004C03O005300012O00AA00035O0020070003000300054O000400073O00202O00040004000B4O000500083O00202O00050005000C00122O000600086O0003000600024O000100033O00062O0001005200013O0004C03O005200012O00DC000100023O00121A000200043O00261D00020063000100090004C03O006300012O00AA00035O0020150003000300054O000400073O00202O00040004000D4O000500083O00202O00050005000E00122O000600086O000700016O0003000700024O000100033O00062O0001008300013O0004C03O008300012O00DC000100023O0004C03O0083000100261D00020072000100010004C03O007200012O00AA00035O0020070003000300054O000400073O00202O00040004000F4O000500083O00202O00050005001000122O000600086O0003000600024O000100033O00062O0001007100013O0004C03O007100012O00DC000100023O00121A0002000A3O00261D00020035000100040004C03O003500012O00AA00035O0020150003000300054O000400073O00202O0004000400114O000500083O00202O00050005001200122O000600086O000700016O0003000700024O000100033O00062O0001008100013O0004C03O008100012O00DC000100023O00121A000200023O0004C03O003500012O00AA000200093O00062600020089000100010004C03O008900012O00AA0002000A3O0006F00002009800013O0004C03O009800012O00AA0002000B3O0006F00002009800013O0004C03O0098000100121A000200014O00A2000300033O00261D0002008E000100010004C03O008E00012O00AA0004000C4O009A0004000100022O003B000300043O0006F00003009800013O0004C03O009800012O00DC000300023O0004C03O009800010004C03O008E000100121A3O000A3O00261D3O00020001000A0004C03O000200012O00AA0002000D4O009A0002000100022O003B000100023O0006F0000100A100013O0004C03O00A100012O00DC000100023O00121A3O00043O0004C03O000200012O006E3O00017O00253O00028O00026O00F03F027O0040026O000840030D3O00546172676574497356616C6964030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C6963746564030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F766572026O00444003083O00526567726F77746803113O00526567726F7774684D6F7573656F76657203093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572026O001040030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F76657203113O0048616E646C65496E636F72706F7265616C03093O0048696265726E61746503123O0048696265726E6174654D6F7573656F766572026O003E40030D3O004D61726B4F6654686557696C64030A3O0049734361737461626C6503083O0042752O66446F776E03103O0047726F757042752O664D692O73696E6703133O004D61726B4F6654686557696C64506C6179657203103O00A9181EB17AA7B30FB011098552A1B93403083O0050C4796CDA25C8D503043O0052616B6503073O004973526561647903093O00537465616C74685570030E3O004973496E4D656C2O6552616E6765026O00244003043O001272097A03073O00EA6013621F2B6E0003012O00121A3O00013O00261D3O002B000100020004C03O002B00012O00AA00015O00062600010009000100010004C03O000900012O00AA000100013O0006F00001001800013O0004C03O001800012O00AA000100023O0006F00001001800013O0004C03O0018000100121A000100014O00A2000200023O00261D0001000E000100010004C03O000E00012O00AA000300034O009A0003000100022O003B000200033O0006F00002001800013O0004C03O001800012O00DC000200023O0004C03O001800010004C03O000E00012O00AA000100043O0006F00001002A00013O0004C03O002A00012O00AA000100053O0006F00001002A00013O0004C03O002A000100121A000100014O00A2000200023O00261D00010020000100010004C03O002000012O00AA000300064O009A0003000100022O003B000200033O0006F00002002A00013O0004C03O002A00012O00DC000200023O0004C03O002A00010004C03O0020000100121A3O00033O00261D3O0043000100040004C03O004300012O00AA000100073O0020840001000100052O009A0001000100020006F0000100022O013O0004C03O00022O012O00AA000100083O0006F0000100022O013O0004C03O00022O0100121A000100013O00261D00010036000100010004C03O003600012O00AA000200094O009A000200010002001273000200063O001252000200063O0006F0000200022O013O0004C03O00022O01001252000200064O00DC000200023O0004C03O00022O010004C03O003600010004C03O00022O0100261D3O00B9000100010004C03O00B900012O00AA0001000A3O0006F0000100A100013O0004C03O00A1000100121A000100013O00261D0001005A000100010004C03O005A00012O00AA000200073O0020A50002000200074O0003000B3O00202O0003000300084O0004000C3O00202O00040004000900122O0005000A6O00020005000200122O000200063O00122O000200063O00062O0002005900013O0004C03O00590001001252000200064O00DC000200023O00121A000100023O00261D0001006C000100030004C03O006C00012O00AA000200073O00203F0002000200074O0003000B3O00202O00030003000B4O0004000C3O00202O00040004000C00122O0005000A6O000600016O00020006000200122O000200063O00122O000200063O00062O0002006B00013O0004C03O006B0001001252000200064O00DC000200023O00121A000100043O00261D0001007D000100040004C03O007D00012O00AA000200073O0020A50002000200074O0003000B3O00202O00030003000D4O0004000C3O00202O00040004000E00122O0005000A6O00020005000200122O000200063O00122O000200063O00062O0002007C00013O0004C03O007C0001001252000200064O00DC000200023O00121A0001000F3O00261D0001008E000100020004C03O008E00012O00AA000200073O0020A50002000200074O0003000B3O00202O0003000300104O0004000C3O00202O00040004001100122O0005000A6O00020005000200122O000200063O00122O000200063O00062O0002008D00013O0004C03O008D0001001252000200064O00DC000200023O00121A000100033O00261D000100490001000F0004C03O004900012O00AA000200073O00203F0002000200074O0003000B3O00202O0003000300124O0004000C3O00202O00040004001300122O0005000A6O000600016O00020006000200122O000200063O00122O000200063O00062O000200A100013O0004C03O00A10001001252000200064O00DC000200023O0004C03O00A100010004C03O004900012O00AA0001000D3O0006F0000100B800013O0004C03O00B8000100121A000100013O00261D000100A5000100010004C03O00A500012O00AA000200073O00203F0002000200144O0003000B3O00202O0003000300154O0004000C3O00202O00040004001600122O000500176O000600016O00020006000200122O000200063O00122O000200063O00062O000200B800013O0004C03O00B80001001252000200064O00DC000200023O0004C03O00B800010004C03O00A5000100121A3O00023O00261D3O0001000100030004C03O000100012O00AA0001000E3O0006F0000100DE00013O0004C03O00DE00012O00AA0001000B3O0020840001000100180020E10001000100192O001E0001000200020006F0000100DE00013O0004C03O00DE00012O00AA0001000F3O00203D00010001001A4O0003000B3O00202O0003000300184O000400016O00010004000200062O000100D3000100010004C03O00D300012O00AA000100073O00200D00010001001B4O0002000B3O00202O0002000200184O00010002000200062O000100DE00013O0004C03O00DE00012O00AA000100104O00AA0002000C3O00208400020002001C2O001E0001000200020006F0000100DE00013O0004C03O00DE00012O00AA000100113O00121A0002001D3O00121A0003001E4O0046000100034O003900016O00AA000100073O0020840001000100052O009A0001000100020006F000012O002O013O0004C04O002O012O00AA0001000B3O00208400010001001F0020E10001000100202O001E0001000200020006F000012O002O013O0004C04O002O012O00AA0001000F3O00207A0001000100214O00038O000400016O00010004000200062O00012O002O013O0004C04O002O012O00AA000100104O00670002000B3O00202O00020002001F4O000300123O00202O00030003002200122O000500236O0003000500024O000300036O00010003000200062O00012O002O013O0004C04O002O012O00AA000100113O00121A000200243O00121A000300254O0046000100034O003900015O00121A3O00043O0004C03O000100012O006E3O00017O00483O00028O00026O001440030C3O004570696353652O74696E677303083O0053652O74696E677303163O0025105CD1A3798E321757F4BC7B990F0B41E0BE7D9E1603073O00EB667F32A7CC12030B3O0065B2F005482145B3FC304C03063O004E30C1954324030A3O0016128F0D53390D88307103053O0021507EE078030D3O00CAA40CD14EE5BB0BE34EE3BD1303053O003C8CC863A4030D3O00AEE60B288086E60F13B186F30103053O00C2E7946446034O00026O001840026O00F03F030D3O006245D2B3F3C46249C3B6F0CE5503063O00A8262CA1C396030B3O00A4F5916635E4940386FA9103083O0076E09CE2165088D6030E3O0077FD5CA847EF55944AFD4D8F4CEB03043O00E0228E39030D3O00F6A2C4D167F94E1AD1A9C0F54303083O006EBEC7A5BD13913D030F3O00F2EA79EC87C2FBED71E482C4CEEE7303063O00A7BA8B1788EB027O0040026O00104003133O003DA7871B1F929D0C08B1810C14A6AF1F15A09803043O006D7AD5E8030F3O00DBE4A713EBF9A322E7F8AC07EFE5A603043O00508E97C2030E3O0020C3794D11CF784234C765482BF603043O002C63A61703143O0049E42C153CAA6AF8223307AC79C4393F21AD68E403063O00C41C9749565303133O00D00C27068D531D42FB061A008B4A1162E02B1903083O001693634970E2387803113O009074ECF181BD5CECF682AA65EDE788B97903053O00EDD815829503113O00AB404B5AA2DB4B925A6856A4C16D965B5103073O003EE22E2O3FD0A903163O00CC1741860D1F3A4EF1365B8F063A2757F11C598A0C1903083O003E857935E37F6D4F03123O00391A26F0C4BCB72O0006FDC4ABB1181B3EF103073O00C270745295B6CE031A3O000CBB493CC1EF0F3EAD6F17CEF40132AD7810C5D11E30BA450CD303073O006E59C82C78A082026O000840030A3O0082D14448614B294683F303083O002DCBA32B26232A5B030A3O00E796D91186AA5DD389CF03073O0034B2E5BC43E7C903103O001452552CF25D2F284F5734F8482A2E4F03073O004341213064973C03113O00F7E2AFD4FAD1E09ED7E7D6E8A0F6F2D2E203053O0093BF87CEB8030F3O00AC2DA7CDD15DB5B427B2C8D75D9AB403073O00D2E448C6A1B83303103O00035AF63D72DC3D66F5247BCB0140FF1403063O00AE562993701303153O006E13882F240210AC5E2E8C1F301D14B86D098A022903083O00CB3B60ED6B456F7103123O000110AAED3EE2D23715A9EF32F5E23717ABE403073O00B74476CC815190030F3O002BAB76E804900BBE73E105810B854003063O00E26ECD10846B03113O00DED0E5FE53E4D5E5FE54EAD1E4D040E5D003053O00218BA380B903103O00704A0BC8527F11DF455C0DDF594B2CEE03043O00BE373864003D012O00121A3O00013O00261D3O0038000100020004C03O00380001001252000100033O0020BD0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004C03O000D000100121A000100014O009500015O00124B000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200062O00010020000100010004C03O0020000100121A000100014O0095000100033O001247000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O0001002B000100010004C03O002B000100121A000100014O0095000100043O001247000100033O00202O0001000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200062O00010036000100010004C03O0036000100121A0001000F4O0095000100053O00121A3O00103O00261D3O0066000100110004C03O00660001001252000100033O0020250001000100044O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O00010001000200062O0001005C000100010004C03O005C000100121A000100014O0095000100093O001251000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00124O001C3O00261D3O009A0001001D0004C03O009A0001001252000100033O0020BD0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O00010072000100010004C03O0072000100121A000100014O00950001000B3O00124B000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O00010001000200062O00010085000100010004C03O0085000100121A000100014O00950001000D3O00124B000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O00010001000200062O00010098000100010004C03O0098000100121A000100014O00950001000F3O00121A3O00023O00261D3O00C80001001C0004C03O00C80001001252000100033O0020250001000100044O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100BE000100010004C03O00BE000100121A000100014O0095000100133O001251000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100143O00124O00323O00261D3O00D6000100100004C03O00D60001001252000100033O0020BD0001000100044O000200013O00122O000300333O00122O000400346O0002000400024O00010001000200062O000100D4000100010004C03O00D4000100121A000100014O0095000100153O0004C03O003C2O0100261D3O00072O0100010004C03O00072O01001252000100033O0020690001000100044O000200013O00122O000300353O00122O000400366O0002000400024O0001000100024O000100163O00122O000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O0001000100024O000100173O00122O000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100F2000100010004C03O00F2000100121A0001000F4O0095000100183O001247000100033O00202O0001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200062O000100FD000100010004C03O00FD000100121A000100014O0095000100193O001251000100033O00202O0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O0001001A3O00124O00113O000E640032000100013O0004C03O00010001001252000100033O0020A00001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O0001001B3O00122O000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001001B2O0100010004C03O001B2O0100121A0001000F4O00950001001C3O001247000100033O00202O0001000100044O000200013O00122O000300433O00122O000400446O0002000400024O00010001000200062O000100262O0100010004C03O00262O0100121A000100014O00950001001D3O00124B000100033O00202O0001000100044O000200013O00122O000300453O00122O000400466O0002000400024O0001000100024O0001001E3O00122O000100033O00202O0001000100044O000200013O00122O000300473O00122O000400486O0002000400024O00010001000200062O000100392O0100010004C03O00392O0100121A000100014O00950001001F3O00121A3O001D3O0004C03O000100012O006E3O00017O00463O00028O00026O001C40030C3O004570696353652O74696E677303083O0053652O74696E677303093O0064AA321B04E2FF7E9F03073O009336CF5C7E7383030A3O003822304F08700826347103063O001E6D51551D6D027O004003123O00CA62518433D9EEF06640BE04DBFAED7447BE03073O009C9F1134D656BE03113O009CEABAAEA1F8A9B49CEABBAEABFCB5949E03043O00DCCE8FDD030F3O00B36E2825DDC6C790782316CCC5DD8803073O00B2E61D4D77B8AC030E3O00C7BB000E61FDFBBF1E1278F6DD8E03063O009895DE6A7B17026O000840026O00F03F03133O00E835F36DB4C933E446A6EE31FF45A1D323E55003053O00D5BD46962303123O006154601D5D50673B585C721C4150671B676503043O00682F3514030B3O00965F842EB908B1439608B403063O006FC32CE17CDC030A3O00EA430761A4BCCC4E284303063O00CBB8266013CB030C3O000C607C72D930756D4CCB377703053O00AE59131921030B3O001C055B48E38A0E21167A7E03073O006B4F72322E97E7030E3O000CB5B01D9838B9D12CAFB9209E2003083O00A059C6D549EA59D7030D3O007C63B5F0D45D78B8F7D151598403053O00A52811D49E026O00104003103O00D0CA0D1F2FE3DC0A3F29EAD43C3228EE03053O004685B96853030F3O00284C422FCB084A4B27FD054B4F02F903053O00A96425244A030C3O003594A77C0981A7520C88AD5D03043O003060E7C2030B3O00E45308281BD4A08CC5723E03083O00E3A83A6E4D79B8CF026O001840030C3O004C35B344B6C97EB26F34977003083O00C51B5CDF20D1BB11030F3O003456CFFF044DCCEC1757E4E90C4AD303043O009B633FA3030A3O00A0D0B386AA8F8BDF89BD03063O00E4E2B1C1EDD9030B3O0001A326C435A228F53FB92D03043O008654D04303103O0027BE875202B98F501AB89F7B01A3934C03043O003C73CCE603123O00D229EE44F53BE561F233E779F323DF62E23F03043O0010875A8B03113O006066073D5F4171587D122A7A467D515C3603073O0018341466532E3403143O00F03D202A1ED1262O2D1BDD1B33210AE33D2E311F03053O006FA44F4144026O00144003113O00F3CA86E927E6C2DE91D139FECEEA8CCA0803063O008AA6B9E3BE4E03103O00FC7DC933553116DC60CD045D373FE34403073O0079AB14A557324303133O00F131B532BE10C92FAD3E8A0DD21E9E24B617D603063O0062A658D956D9030D3O00C3E57C368FD0F2F16B0E91C8FE03063O00BC2O961961E6003E012O00121A3O00013O00261D3O0017000100020004C03O00170001001252000100033O0020BD0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004C03O000D000100121A000100014O009500015O0012E0000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00044O003D2O0100261D3O0040000100090004C03O00400001001252000100033O0020A00001000100044O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200062O0001002B000100010004C03O002B000100121A000100014O0095000100043O00124B000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O00010001000200062O0001003E000100010004C03O003E000100121A000100014O0095000100063O00121A3O00123O00261D3O0069000100130004C03O00690001001252000100033O0020A00001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O00010001000200062O00010054000100010004C03O0054000100121A000100014O0095000100083O00124B000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O00010067000100010004C03O0067000100121A000100014O00950001000A3O00121A3O00093O00261D3O0092000100120004C03O00920001001252000100033O0020A00001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O0001007D000100010004C03O007D000100121A000100014O00950001000C3O00124B000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O00010001000200062O00010090000100010004C03O0090000100121A000100014O00950001000E3O00121A3O00243O00261D3O00BB000100010004C03O00BB0001001252000100033O0020A00001000100044O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O00010001000200062O000100A6000100010004C03O00A6000100121A000100014O0095000100103O00124B000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200062O000100B9000100010004C03O00B9000100121A000100014O0095000100123O00121A3O00133O00261D3O00E70001002D0004C03O00E70001001252000100033O0020BD0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100C7000100010004C03O00C7000100121A000100014O0095000100133O001247000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100D2000100010004C03O00D2000100121A000100014O0095000100143O001247000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O00010001000200062O000100DD000100010004C03O00DD000100121A000100014O0095000100153O001251000100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100163O00124O00023O000E64002400132O013O0004C03O00132O01001252000100033O0020BD0001000100044O000200013O00122O000300363O00122O000400376O0002000400024O00010001000200062O000100F3000100010004C03O00F3000100121A000100014O0095000100173O00124B000100033O00202O0001000100044O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100183O00122O000100033O00202O0001000100044O000200013O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200062O000100062O0100010004C03O00062O0100121A000100014O0095000100193O001247000100033O00202O0001000100044O000200013O00122O0003003C3O00122O0004003D6O0002000400024O00010001000200062O000100112O0100010004C03O00112O0100121A000100014O00950001001A3O00121A3O003E3O000E64003E000100013O0004C03O00010001001252000100033O0020A00001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O0001000100024O0001001B3O00122O000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O000100272O0100010004C03O00272O0100121A000100014O00950001001C3O001247000100033O00202O0001000100044O000200013O00122O000300433O00122O000400446O0002000400024O00010001000200062O000100322O0100010004C03O00322O0100121A000100014O00950001001D3O001251000100033O00202O0001000100044O000200013O00122O000300453O00122O000400466O0002000400024O0001000100024O0001001E3O00124O002D3O0004C03O000100012O006E3O00017O00493O00028O00026O00084003093O0049734D6F756E74656403083O0049734D6F76696E6703073O0047657454696D6503063O0042752O665570030A3O0054726176656C466F726D03083O0042656172466F726D03073O00436174466F726D026O00F03F03173O00476574456E656D696573496E53706C61736852616E6765026O002040026O001040030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00D98D4C03063O008DBAE93F626C03063O00F5E33FA620FD03053O0045918A4CD603043O0062CE849903063O007610AF2OE9DF2O033O008F942603073O001DEBE455DB8EEB027O0040030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D62617403103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E7303063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B03163O0044656164467269656E646C79556E697473436F756E7403073O005265626972746803073O004973526561647903073O002FD1B8D4655A2F03083O00325DB4DABD172E47030A3O005265766974616C697A65030A3O00CCA14D4550DD44D7BE5E03073O0028BEC43B2C24BC03063O0052657669766503093O004973496E52616E6765026O00444003063O002E40CABDEC7803073O006D5C25BCD49A1D030C3O0044656275674D652O73616765030C3O0049734368612O6E656C696E6703074O00FFB7C53E480903063O003A648FC4A35103073O00124722AF3647E203083O006E7A2243C35F2985030B3O004E61747572657343757265031B3O00497354616E6B42656C6F774865616C746850657263656E7461676503083O0049726F6E4261726B03093O0041B05541965ABF575303053O00B615D13B2A030D3O008356CB1661BFB953852E24B2B103063O00DED737A57D41030C3O0053686F756C6452657475726E03093O00466F637573556E697403043O0018F0E83103083O002A4CB1A67A92A18D026O00344003103O004865616C746850657263656E74616765030D3O00918B0BC53977AB8E45FD7C7AA303063O0016C5EA65AE1903063O00051184F0539D03083O00E64D54C5BC16CFB72O033O00F61BC503083O00559974A69CECC1902O033O00A5EF4803063O0060C4802DD38400EA012O00121A3O00013O000E640002004800013O0004C03O004800012O00AA00015O0020E10001000100032O001E0001000200020006F00001000900013O0004C03O000900012O006E3O00014O00AA00015O0020E10001000100042O001E0001000200020006F00001001100013O0004C03O00110001001252000100054O009A0001000100022O0095000100014O00AA00015O0020FE0001000100064O000300023O00202O0003000300074O00010003000200062O00010026000100010004C03O002600012O00AA00015O0020FE0001000100064O000300023O00202O0003000300084O00010003000200062O00010026000100010004C03O002600012O00AA00015O00203A0001000100064O000300023O00202O0003000300094O00010003000200062O0001002D00013O0004C03O002D0001001252000100054O009A0001000100022O00AA000200014O00DF0001000100020026B10001002D0001000A0004C03O002D00012O006E3O00014O00AA000100033O0006F00001003E00013O0004C03O003E000100121A000100013O00261D00010031000100010004C03O003100012O00AA000200053O0020E700020002000B00122O0004000C6O0002000400024O000200046O000200046O000200026O000200063O00044O004700010004C03O003100010004C03O0047000100121A000100013O00261D0001003F000100010004C03O003F00012O00A300026O0095000200043O00121A0002000A4O0095000200063O0004C03O004700010004C03O003F000100121A3O000D3O00261D3O006B0001000A0004C03O006B00010012520001000E3O00209700010001000F4O000200083O00122O000300103O00122O000400116O0002000400024O0001000100024O000100073O00122O0001000E3O00202O00010001000F4O000200083O00121A000300123O001276000400136O0002000400024O0001000100024O000100093O00122O0001000E3O00202O00010001000F4O000200083O00122O000300143O00122O000400156O0002000400022O00560001000100022O00950001000A3O0012510001000E3O00202O00010001000F4O000200083O00122O000300163O00122O000400176O0002000400024O0001000100024O0001000B3O00124O00183O00261D3O00362O01000D0004C03O00362O012O00AA0001000C3O0020840001000100192O009A00010001000200062600010077000100010004C03O007700012O00AA00015O0020E100010001001A2O001E0001000200020006F00001009000013O0004C03O0090000100121A000100013O000E6400010083000100010004C03O008300012O00AA0002000E3O00202D00020002001B4O000300036O000400016O0002000400024O0002000D6O0002000D6O0002000F3O00122O0001000A3O00261D000100780001000A0004C03O007800012O00AA0002000F3O00261D000200900001001C0004C03O009000012O00AA0002000E3O00204100020002001D4O000300046O00048O0002000400024O0002000F3O00044O009000010004C03O007800012O00AA000100053O0006F0000100F400013O0004C03O00F400012O00AA000100053O0020E100010001001E2O001E0001000200020006F0000100F400013O0004C03O00F400012O00AA000100053O0020E100010001001F2O001E0001000200020006F0000100F400013O0004C03O00F400012O00AA000100053O0020E10001000100202O001E0001000200020006F0000100F400013O0004C03O00F400012O00AA00015O0020E10001000100212O00AA000300054O00CD000100030002000626000100F4000100010004C03O00F400012O00AA00015O0020E100010001001A2O001E000100020002000626000100F4000100010004C03O00F400012O00AA000100103O0006F0000100F400013O0004C03O00F4000100121A000100014O00A2000200023O00261D000100B2000100010004C03O00B200012O00AA0003000C3O0020F80003000300224O0003000100024O000200036O00035O00202O00030003001A4O00030002000200062O000300D100013O0004C03O00D100012O00AA000300023O0020840003000300230020E10003000300242O001E0003000200020006F0000300F400013O0004C03O00F400012O00AA000300114O0035000400023O00202O0004000400234O000500056O000600016O00030006000200062O000300F400013O0004C03O00F400012O00AA000300083O001202000400253O00122O000500266O000300056O00035O00044O00F40001000E8A000A00E1000100020004C03O00E100012O00AA000300114O0035000400023O00202O0004000400274O000500056O000600016O00030006000200062O000300F400013O0004C03O00F400012O00AA000300083O001202000400283O00122O000500296O000300056O00035O00044O00F400012O00AA000300114O0054000400023O00202O00040004002A4O000500053O00202O00050005002B00122O0007002C6O0005000700024O000500056O000600016O00030006000200062O000300F400013O0004C03O00F400012O00AA000300083O0012020004002D3O00122O0005002E6O000300056O00035O00044O00F400010004C03O00B200012O00AA000100123O0006F00001000F2O013O0004C03O000F2O0100121A000100013O00261D000100032O0100010004C03O00032O012O00AA000200134O009A0002000100020012730002002F3O0012520002002F3O0006F0000200022O013O0004C03O00022O010012520002002F4O00DC000200023O00121A0001000A3O00261D000100F80001000A0004C03O00F800012O00AA000200144O009A0002000100020012730002002F3O0012520002002F3O0006F00002000F2O013O0004C03O000F2O010012520002002F4O00DC000200023O0004C03O000F2O010004C03O00F800012O00AA00015O0020E10001000100302O001E000100020002000626000100E92O0100010004C03O00E92O012O00AA00015O0020E100010001001A2O001E0001000200020006F0000100262O013O0004C03O00262O0100121A000100014O00A2000200023O000E640001001B2O0100010004C03O001B2O012O00AA000300154O009A0003000100022O003B000200033O0006F0000200E92O013O0004C03O00E92O012O00DC000200023O0004C03O00E92O010004C03O001B2O010004C03O00E92O012O00AA000100103O0006F0000100E92O013O0004C03O00E92O0100121A000100014O00A2000200023O00261D0001002B2O0100010004C03O002B2O012O00AA000300164O009A0003000100022O003B000200033O0006F0000200E92O013O0004C03O00E92O012O00DC000200023O0004C03O00E92O010004C03O002B2O010004C03O00E92O01000E64001800D12O013O0004C03O00D12O010012520001000E3O00209100010001000F4O000200083O00122O000300313O00122O000400326O0002000400024O0001000100024O000100173O00122O0001000E3O00202O00010001000F4O000200083O00122O000300333O00122O000400346O0002000400024O0001000100024O000100126O00015O00202O0001000100204O00010002000200062O0001004E2O013O0004C03O004E2O012O006E3O00014O00AA00015O0020E100010001001A2O001E000100020002000626000100562O0100010004C03O00562O012O00AA000100183O0006F0000100D02O013O0004C03O00D02O0100121A000100014O00A2000200023O00261D000100582O0100010004C03O00582O012O00AA000300183O0006C5000200642O0100030004C03O00642O012O00AA000300023O0020840003000300350020E10003000300242O001E0003000200020006C5000200642O0100030004C03O00642O012O00AA000200094O00AA0003000C3O0020840003000300362O00AA000400194O001E0003000200020006F0000300942O013O0004C03O00942O012O00AA000300023O0020840003000300370020E10003000300242O001E0003000200020006F0000300942O013O0004C03O00942O012O00AA0003001A6O000400083O00122O000500383O00122O000600396O00040006000200062O0003007E2O0100040004C03O007E2O012O00AA0003001A4O000C000400083O00122O0005003A3O00122O0006003B6O00040006000200062O000300942O0100040004C03O00942O0100121A000300013O00261D0003007F2O0100010004C03O007F2O012O00AA0004000C3O0020D500040004003D4O000500026O000600076O000800083O00122O0009003E3O00122O000A003F6O0008000A000200122O000900406O00040009000200122O0004003C3O00122O0004003C3O00062O000400D02O013O0004C03O00D02O010012520004003C4O00DC000400023O0004C03O00D02O010004C03O007F2O010004C03O00D02O012O00AA00035O0020E10003000300412O001E0003000200022O00AA000400193O000645000300BD2O0100040004C03O00BD2O012O00AA000300023O0020840003000300370020E10003000300242O001E0003000200020006F0000300BD2O013O0004C03O00BD2O012O00AA0003001A4O000C000400083O00122O000500423O00122O000600436O00040006000200062O000300BD2O0100040004C03O00BD2O0100121A000300013O00261D000300A82O0100010004C03O00A82O012O00AA0004000C3O0020D500040004003D4O000500026O000600076O000800083O00122O000900443O00122O000A00456O0008000A000200122O000900406O00040009000200122O0004003C3O00122O0004003C3O00062O000400D02O013O0004C03O00D02O010012520004003C4O00DC000400023O0004C03O00D02O010004C03O00A82O010004C03O00D02O0100121A000300013O00261D000300BE2O0100010004C03O00BE2O012O00AA0004000C3O00201800040004003D4O000500026O000600083O00122O000900406O00040009000200122O0004003C3O00122O0004003C3O00062O000400D02O013O0004C03O00D02O010012520004003C4O00DC000400023O0004C03O00D02O010004C03O00BE2O010004C03O00D02O010004C03O00582O0100121A3O00023O00261D3O0001000100010004C03O000100012O00AA0001001B4O00BC0001000100014O0001001C6O00010001000100122O0001000E3O00202O00010001000F4O000200083O00122O000300463O00122O000400476O0002000400024O0001000100024O000100103O00122O0001000E3O00202O00010001000F4O000200083O00122O000300483O00122O000400496O0002000400024O0001000100024O000100033O00124O000A3O00044O000100012O006E3O00017O00093O00028O00026O00F03F03053O005072696E7403233O000788684BDDBDB5CC3C82751FF6BDA1D131CD4950C6AEA0D13A833B5DCBEF91C83C8E3503083O00B855ED1B3FB2CFD4030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03243O003A5C1A4B074B084B0156071F2C4B1C560C192O1F5909470D46095B1F2A40497D0756047403043O003F68396900193O00121A3O00013O00261D3O0006000100020004C03O000600012O00AA00016O00D80001000100010004C03O0018000100261D3O0001000100010004C03O000100012O00AA000100013O0020C90001000100034O000200023O00122O000300043O00122O000400056O000200046O00013O000100122O000100063O00202O0001000100074O000200023O00122O000300083O00122O000400096O000200046O00013O000100124O00023O00044O000100012O006E3O00017O00", GetFEnv(), ...);
