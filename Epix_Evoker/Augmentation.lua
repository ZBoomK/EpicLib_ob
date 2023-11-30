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
				if (Enum <= 160) then
					if (Enum <= 79) then
						if (Enum <= 39) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												if (Stk[Inst[2]] < Stk[Inst[4]]) then
													VIP = Inst[3];
												else
													VIP = VIP + 1;
												end
											else
												local A = Inst[2];
												do
													return Unpack(Stk, A, Top);
												end
											end
										elseif (Enum <= 2) then
											local Edx;
											local Results, Limit;
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
										elseif (Enum == 3) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
										end
									elseif (Enum <= 6) then
										if (Enum > 5) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									elseif (Enum <= 7) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 8) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 12) then
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									elseif (Enum > 13) then
										VIP = Inst[3];
									else
										local K;
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 16) then
									if (Enum == 15) then
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
									end
								elseif (Enum <= 17) then
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								elseif (Enum == 18) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									local B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum == 20) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum <= 22) then
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
									elseif (Enum > 23) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 26) then
									if (Enum == 25) then
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
									end
								elseif (Enum <= 27) then
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 28) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 32) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 33) then
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
							elseif (Enum <= 36) then
								if (Enum == 35) then
									local B = Inst[3];
									local K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 37) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 38) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 42) then
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
									elseif (Enum > 43) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
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
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 46) then
									if (Enum > 45) then
										if (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										do
											return Stk[Inst[2]]();
										end
									end
								elseif (Enum <= 47) then
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
								elseif (Enum == 48) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								else
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								end
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum > 50) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										local K;
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 52) then
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
								elseif (Enum > 53) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 56) then
								if (Enum > 55) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 57) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 58) then
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
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum > 60) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 62) then
									Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
								elseif (Enum > 63) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 66) then
								if (Enum == 65) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 67) then
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 68) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum > 70) then
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 72) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							elseif (Enum == 73) then
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
							else
								local K;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 76) then
							if (Enum > 75) then
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
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 77) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
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
					elseif (Enum <= 119) then
						if (Enum <= 99) then
							if (Enum <= 89) then
								if (Enum <= 84) then
									if (Enum <= 81) then
										if (Enum == 80) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
											end
										end
									elseif (Enum <= 82) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 83) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 86) then
									if (Enum == 85) then
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
									end
								elseif (Enum <= 87) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								elseif (Enum == 88) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 94) then
								if (Enum <= 91) then
									if (Enum > 90) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 92) then
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
								elseif (Enum > 93) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 96) then
								if (Enum == 95) then
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
							elseif (Enum <= 97) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 98) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 109) then
							if (Enum <= 104) then
								if (Enum <= 101) then
									if (Enum == 100) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
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
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 102) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
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
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								end
							elseif (Enum <= 106) then
								if (Enum == 105) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 107) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
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
							elseif (Enum > 108) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 114) then
							if (Enum <= 111) then
								if (Enum > 110) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 112) then
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
									if (Mvm[1] == 268) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							elseif (Enum == 113) then
								local Edx;
								local Results, Limit;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 116) then
							if (Enum > 115) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								local Edx;
								local Results, Limit;
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
						elseif (Enum <= 117) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 118) then
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
					elseif (Enum <= 139) then
						if (Enum <= 129) then
							if (Enum <= 124) then
								if (Enum <= 121) then
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
								elseif (Enum <= 122) then
									local B;
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								elseif (Enum == 123) then
									if (Inst[2] > Inst[4]) then
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
							elseif (Enum <= 126) then
								if (Enum == 125) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 127) then
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
							elseif (Enum == 128) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Stk[Inst[2]] ~= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 134) then
							if (Enum <= 131) then
								if (Enum > 130) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = {};
								end
							elseif (Enum <= 132) then
								do
									return Stk[Inst[2]];
								end
							elseif (Enum == 133) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 136) then
							if (Enum > 135) then
								local B;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							else
								local B;
								local Edx;
								local Results, Limit;
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								B = Stk[Inst[4]];
								if not B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 137) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 149) then
						if (Enum <= 144) then
							if (Enum <= 141) then
								if (Enum > 140) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 142) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 146) then
							if (Enum == 145) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							elseif (Inst[2] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
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
						elseif (Enum == 148) then
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
					elseif (Enum <= 154) then
						if (Enum <= 151) then
							if (Enum == 150) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 152) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 157) then
						if (Enum <= 155) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						elseif (Enum == 156) then
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
					elseif (Enum <= 158) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 159) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
					if (Enum <= 200) then
						if (Enum <= 180) then
							if (Enum <= 170) then
								if (Enum <= 165) then
									if (Enum <= 162) then
										if (Enum == 161) then
											if (Inst[2] < Inst[4]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
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
									elseif (Enum <= 163) then
										Upvalues[Inst[3]] = Stk[Inst[2]];
									elseif (Enum > 164) then
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
								elseif (Enum <= 167) then
									if (Enum > 166) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										VIP = Inst[3];
									end
								elseif (Enum <= 168) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 169) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 175) then
								if (Enum <= 172) then
									if (Enum > 171) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 173) then
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum > 174) then
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 177) then
								if (Enum == 176) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								end
							elseif (Enum <= 178) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum > 179) then
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
						elseif (Enum <= 190) then
							if (Enum <= 185) then
								if (Enum <= 182) then
									if (Enum > 181) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
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
								elseif (Enum <= 183) then
									local B;
									local Edx;
									local Results, Limit;
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
										VIP = Inst[3];
									end
								elseif (Enum == 184) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 187) then
								if (Enum == 186) then
									local B;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 188) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
								Stk[A] = Stk[A]();
							elseif (Enum == 189) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Env[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 195) then
							if (Enum <= 192) then
								if (Enum == 191) then
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
							elseif (Enum <= 193) then
								Stk[Inst[2]] = not Stk[Inst[3]];
							elseif (Enum == 194) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
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
						elseif (Enum <= 197) then
							if (Enum == 196) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
						elseif (Enum <= 198) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum == 199) then
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
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
					elseif (Enum <= 220) then
						if (Enum <= 210) then
							if (Enum <= 205) then
								if (Enum <= 202) then
									if (Enum == 201) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 203) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 204) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 207) then
								if (Enum == 206) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								elseif (Inst[2] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 208) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
						elseif (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum == 211) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 213) then
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
								Stk[Inst[2]] = Inst[3] ~= 0;
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
							elseif (Enum == 214) then
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
								A = Inst[2];
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 217) then
							if (Enum > 216) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 218) then
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 219) then
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
						elseif (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 230) then
						if (Enum <= 225) then
							if (Enum <= 222) then
								if (Enum == 221) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
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
								end
							elseif (Enum <= 223) then
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
							elseif (Enum > 224) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 227) then
							if (Enum > 226) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 228) then
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum > 229) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 235) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 233) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum > 234) then
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
					elseif (Enum <= 237) then
						if (Enum > 236) then
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 238) then
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
					elseif (Enum == 239) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 280) then
					if (Enum <= 260) then
						if (Enum <= 250) then
							if (Enum <= 245) then
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
								elseif (Enum <= 243) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 244) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 247) then
								if (Enum > 246) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 248) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							elseif (Enum > 249) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 255) then
							if (Enum <= 252) then
								if (Enum == 251) then
									Env[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum <= 253) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 254) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 257) then
							if (Enum == 256) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 258) then
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
						elseif (Enum > 259) then
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
							local K;
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 270) then
						if (Enum <= 265) then
							if (Enum <= 262) then
								if (Enum == 261) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 268) then
							Stk[Inst[2]] = Stk[Inst[3]];
						elseif (Enum == 269) then
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 275) then
						if (Enum <= 272) then
							if (Enum > 271) then
								local B;
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
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
						elseif (Enum <= 273) then
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
						elseif (Enum == 274) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 277) then
						if (Enum == 276) then
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
					elseif (Enum <= 278) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum > 279) then
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 300) then
					if (Enum <= 290) then
						if (Enum <= 285) then
							if (Enum <= 282) then
								if (Enum == 281) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 283) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
								Stk[A] = Stk[A]();
							elseif (Enum > 284) then
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
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Env[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum <= 287) then
							if (Enum > 286) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 288) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 289) then
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
					elseif (Enum <= 295) then
						if (Enum <= 292) then
							if (Enum > 291) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 293) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 294) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A]();
						end
					elseif (Enum <= 297) then
						if (Enum > 296) then
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
							Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
						end
					elseif (Enum <= 298) then
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
					elseif (Enum > 299) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 310) then
					if (Enum <= 305) then
						if (Enum <= 302) then
							if (Enum > 301) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 303) then
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
						elseif (Enum == 304) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 307) then
						if (Enum == 306) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 308) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 309) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 315) then
					if (Enum <= 312) then
						if (Enum > 311) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 313) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 314) then
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
						Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
					end
				elseif (Enum <= 318) then
					if (Enum <= 316) then
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
					elseif (Enum > 317) then
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
						Stk[Inst[2]] = Inst[3];
					else
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
					end
				elseif (Enum <= 319) then
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
				elseif (Enum > 320) then
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
					local K;
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031C3O00F4D3D23DD99ED111DAC6C91AC7AEC013D4CDCF24F2B2C8109FCFCE2403083O007EB1A3BB4586DBA7031C3O00A4D658EAF67997C95AF7DB63A0D356FFCC5295C745FBC652CFCA44F303063O003CE1A63192A9002E3O0012263O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100040E3O000A0001001213010300063O002006000400030007001213010500083O002006000500050009001213010600083O00200600060006000A00067000073O000100062O000C012O00064O000C017O000C012O00044O000C012O00014O000C012O00024O000C012O00053O00200600080003000B00200600090003000C2O0082000A5O001213010B000D3O000670000C0001000100022O000C012O000A4O000C012O000B4O000C010D00073O00123A000E000E3O00123A000F000F4O002B000D000F0002000670000E0002000100032O000C012O00074O000C012O00094O000C012O00084O00EE000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00C300025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AA00076O007F000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O00AA000C00034O003D010D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00C8000C6O00B2000A3O0002002091000A000A00022O00270109000A4O00B400073O00010004770003000500012O00AA000300054O000C010400024O00E9000300044O000100036O006D3O00017O00113O00028O00025O0020B340025O00B49340026O00F03F025O00E0A140025O009EA340025O0010AC40025O0039B140026O003740025O0034AC40025O008EAE40025O0024A440025O00E9B240025O005EA740025O008EB040025O00C05540025O00D4A340013F3O00123A000200014O0057000300033O00123A000400014O0057000500053O002681000400080001000100040E3O00080001002E05010200040001000300040E3O0004000100123A000500013O002694000500090001000100040E3O000900010026810002000F0001000400040E3O000F0001002EE8000600130001000500040E3O001300012O000C010600034O004B00076O006400066O000100065O002681000200170001000100040E3O00170001002E05010800020001000700040E3O0002000100123A000600014O0057000700073O002EE8000900190001000A00040E3O00190001002694000600190001000100040E3O0019000100123A000700013O002681000700240001000100040E3O00240001002EA1000B00240001000C00040E3O00240001002EE8000D00300001000E00040E3O003000012O00AA00086O00BD000300083O0006220003002A00013O00040E3O002A0001002EE8000F002F0001001000040E3O002F00012O00AA000800014O000C01096O004B000A6O006400086O000100085O00123A000700043O002EDA001100EEFF2O001100040E3O001E00010026940007001E0001000400040E3O001E000100123A000200043O00040E3O0002000100040E3O001E000100040E3O0002000100040E3O0019000100040E3O0002000100040E3O0009000100040E3O0002000100040E3O0004000100040E3O000200012O006D3O00017O005B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203093O00862B0525768AEDAE3603073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C030A3O009643C5B4336320C4B75A03083O00A1DB36A9C05A305003043O006056052803043O004529226003053O0089D7DE061103063O004BDCA3B76A6203043O0021BB982303053O00B962DAEB57030D3O00E83D34F2FFA4C52O33E7CAAFCF03063O00CAAB5C4786BE030B3O000AC03F9C19CE238420CF2B03043O00E849A14C03053O0096D8414F1103053O007EDBB9223D03053O003CDC5B616D03083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC5028O0003063O00733E5033204C03073O009836483F58453E030C3O00F5D1E951D1CAFA5DC0CDE15203043O003CB4A48E03063O007D480A2O22FF03073O0072383E6549478D030C3O0099FCDCC9BDE7CFC5ACE0D4CA03043O00A4D889BB03063O00F7F03EB9A3EC03073O006BB28651D2C69E030C3O00191B85CBAF361A83D2A3370003053O00CA586EE2A603073O00E0008FFAC5CD1C03053O00AAA36FE29703083O003426B72A5738271403073O00497150D2582E57030B3O00A723C306E88701CC15EE8203053O0087E14CAD72030B3O004973417661696C61626C65026O001040026O000840030B3O003CE2B6A4A3BB8A1BEAB1B303073O00C77A8DD8D0CCDD029A5O99E93F026O00F03F024O0080B3C54003093O0099DC19FC4BE1A4CD1503063O0096CDBD709018031B3O000685AC5844BC101929C48C5B0D9814506DADB158019A03053590F603083O007045E4DF2C64E871030A3O00E31609D4946980D21A1303073O00E6B47F67B3D61C031C3O00AF044C52A476E982021F64F147E689111F0ECD4FF489174D53F455A903073O0080EC653F26842103103O005265676973746572466F724576656E7403143O009C85307D93D9F09E8C366198D4EA8288336893CF03073O00AFCCC97124D68B030E3O00D5F5E811CAF6F21ECEE4E31AC3E103043O005D86A5AD03143O0092D7E0F014EB96418DC2E4EE16F19B5081C62OE003083O001EDE92A1A25AAED203063O0053657441504C025O0004974000BD013O0049000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O0012D2000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O0012D20009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O0012D2000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O0012D2000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00123A000F00163O00123A001000174O002B000E001000022O00BD000E0004000E2O00AA000F5O00121A011000183O00122O001100196O000F001100024O000F0004000F00122O001000046O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011001000112O00DD00125O00122O0013001C3O00122O0014001D6O0012001400024O0012001000124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013001000132O00AA00145O00123A001500203O00123A001600214O002B0014001600022O00BD0014001000142O00AA00155O001236001600223O00122O001700236O0015001700024O0015001000154O00165O00122O001700243O00122O001800256O0016001800024O0016001000164O00175O00122O001800263O00122O001900276O0017001900024O0016001600174O00175O00122O001800283O00122O001900296O0017001900024O0016001600174O00175O00122O0018002A3O00122O0019002B6O0017001900024O0017001000174O00185O00122O0019002C3O00122O001A002D6O0018001A00024O0017001700184O00185O00122O0019002E3O00122O001A002F6O0018001A00024O00170017001800122O001800306O00198O001A8O001B8O001C8O001D8O001E00446O00455O00122O004600313O00122O004700326O0045004700024O0045000C00454O00465O00122O004700333O00122O004800346O0046004800024O0045004500464O00465O00122O004700353O00122O004800366O0046004800024O0046000E00464O00475O00122O004800373O00122O004900386O0047004900024O0046004600474O00475O00122O004800393O00122O0049003A6O0047004900024O0047001400474O00485O00122O0049003B3O00122O004A003C6O0048004A00024O0047004700484O00488O00495O00122O004A003D3O00122O004B003E6O0049004B00024O0049001000494O004A5O00122O004B003F3O00122O004C00404O002B004A004C00022O00BD00490049004A2O0082004A6O0038004B5O00122O004C00413O00122O004D00426O004B004D00024O004B0045004B00202O004B004B00434O004B0002000200062O004B00B000013O00040E3O00B0000100123A004B00443O000647004B00B10001000100040E3O00B1000100123A004B00454O00AA004C5O001224004D00463O00122O004E00476O004C004E00024O004C0045004C00202O004C004C00434O004C0002000200062O004C00BD00013O00040E3O00BD000100123A004C00483O000647004C00BE0001000100040E3O00BE000100123A004C00493O00123A004D004A3O00120F014E004A3O00122O004F00493O00122O005000496O005100026O005200036O00535O00122O0054004B3O00122O0055004C6O0053005500024O0053004500534O00545O00122O0055004D3O00122O0056004E6O00540056000200023E00556O007E0052000300012O0082005300034O002C00545O00122O0055004F3O00122O005600506O0054005600024O0054004500544O00555O00122O005600513O00122O005700526O00550057000200023E005600014O007E0053000300012O007E00510002000100202700520004005300067000540002000100022O000C012O004D4O000C012O004E4O000A00555O00122O005600543O00122O005700556O005500576O00523O000100202O00520004005300067000540003000100042O000C012O004B4O000C012O00454O00AA8O000C012O004C4O001900555O00122O005600563O00122O005700576O0055005700024O00565O00122O005700583O00122O005800596O005600586O00523O00014O005200523O00023E005300044O0057005400543O00067000550005000100032O00AA8O000C012O00544O000C012O00064O0057005600563O00067000570006000100052O000C012O00074O000C012O00564O000C012O000A4O00AA8O000C012O00063O00067000580007000100112O000C012O00454O00AA8O000C012O00074O000C012O00114O000C012O001E4O000C012O000B4O000C012O001F4O000C012O00564O000C012O00474O000C012O00214O000C012O00494O000C012O00224O000C012O000A4O000C012O00304O000C012O00544O000C012O00204O000C012O001B3O00067000590008000100082O000C012O000B4O000C012O00494O000C012O00454O00AA8O000C012O00154O000C012O00474O000C012O003A4O000C012O000A3O000670005A00090001000F2O000C012O00454O00AA8O000C012O00304O000C012O00074O000C012O00494O000C012O00114O000C012O00214O000C012O000B4O000C012O00544O000C012O00474O000C012O001E4O000C012O00204O000C012O001F4O000C012O00224O000C012O00563O000670005B000A0001000A2O000C012O00284O00AA8O000C012O00454O000C012O00074O000C012O002A4O000C012O00114O000C012O00474O000C012O000B4O000C012O00294O000C012O002B3O000670005C000B000100232O000C012O00454O00AA8O000C012O00114O000C012O000A4O000C012O00074O000C012O004B4O000C012O00504O000C012O00124O000C012O004F4O000C012O00324O000C012O00314O000C012O00594O000C012O00354O000C012O00494O000C012O00474O000C012O00364O000C012O00044O000C012O001B4O000C012O00414O00AA3O00014O00AA3O00024O000C012O00404O000C012O003E4O000C012O003D4O000C012O00424O000C012O00184O000C012O00434O000C012O00154O000C012O001C4O000C012O005B4O000C012O003C4O000C012O003B4O000C012O004E4O000C012O003F4O000C012O00483O000670005D000C000100282O000C012O00404O00AA8O000C012O00414O000C012O003E4O000C012O003F4O000C012O00384O000C012O00394O000C012O00364O000C012O00374O000C012O00264O000C012O00274O000C012O00284O000C012O00294O000C012O00244O000C012O00254O000C012O00224O000C012O00234O000C012O00424O000C012O00434O000C012O00444O000C012O003A4O000C012O003B4O000C012O003C4O000C012O003D4O000C012O001E4O000C012O001F4O000C012O00204O000C012O00214O000C012O002A4O000C012O002B4O000C012O002C4O000C012O002D4O000C012O002E4O000C012O002F4O000C012O00304O000C012O00314O000C012O00324O000C012O00334O000C012O00344O000C012O00353O000670005E000D0001002C2O000C012O00494O000C012O00074O000C012O004D4O000C012O00044O000C012O004E4O000C012O001C4O000C012O00194O000C012O005B4O000C012O00424O000C012O00184O000C012O00434O000C012O00454O00AA8O000C012O00154O000C012O005A4O000C012O005C4O000C012O00504O000C012O00584O000C012O00084O000C012O00474O000C012O00464O000C012O00334O000C012O00344O000C012O002D4O000C012O002F4O000C012O002E4O000C012O004F4O000C012O00124O000C012O00314O000C012O00554O000C012O000B4O000C012O00214O000C012O00544O000C012O00574O000C012O001E4O000C012O001F4O000C012O00564O000C012O00284O000C012O00294O000C012O001A4O000C012O005D4O000C012O001B4O000C012O001D4O000C012O000A3O000670005F000E000100042O00AA8O000C012O00494O000C012O00104O000C012O00453O00202A00600010005A00122O0061005B6O0062005E6O0063005F6O0060006300016O00013O000F8O00034O00553O00014O00843O00024O006D3O00019O003O00034O00553O00014O00843O00024O006D3O00017O00053O00028O00025O001AB040025O005EA640025O00D8A340024O0080B3C54000143O00123A3O00014O0057000100013O002EDA00023O0001000200040E3O00020001000E2E0001000200013O00040E3O0002000100123A000100013O000E920001000B0001000100040E3O000B0001002E05010300070001000400040E3O0007000100123A000200054O00A300025O00123A000200054O00A3000200013O00040E3O0013000100040E3O0007000100040E3O0013000100040E3O000200012O006D3O00017O000C3O00028O00025O00E2A740025O00D6B240030B3O0061C33BC80B41E134DB0D4403053O006427AC55BC030B3O004973417661696C61626C65026O001040026O000840030B3O008B77B7943CAB55B8873AAE03053O0053CD18D9E0029A5O99E93F026O00F03F002C3O00123A3O00014O0057000100013O000E2E0001000200013O00040E3O0002000100123A000100013O002E05010200050001000300040E3O00050001002694000100050001000100040E3O000500012O00AA000200014O0038000300023O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002001600013O00040E3O0016000100123A000200073O000647000200170001000100040E3O0017000100123A000200084O00A300026O002A010200016O000300023O00122O000400093O00122O0005000A6O0003000500024O00020002000300202O0002000200064O00020002000200062O0002002500013O00040E3O0025000100123A0002000B3O000647000200260001000100040E3O0026000100123A0002000C4O00A3000200033O00040E3O002B000100040E3O0005000100040E3O002B000100040E3O000200012O006D3O00019O003O00014O006D3O00017O00213O00028O00026O00F03F025O0086A240025O00BCA440025O0050B240025O0044974003053O00706169727303063O0045786973747303163O00556E697447726F7570526F6C6573412O7369676E656403063O00F3AE30D99CEE03073O00AFBBEB7195D9BC03093O004973496E52616E6765026O00394003103O004865616C746850657263656E74616765026O008A40025O00A2B240025O0014AB40025O00A8B14003043O0047554944027O0040025O00389E40030A3O00556E6974496E5261696403063O00F5427113E05C03043O006A852E10025O00ACB140025O0074A44003043O006A217AF803063O00203840139C3A030B3O00556E6974496E506172747903063O004AC4E44F5FE003073O00E03AA885363A9203053O00695759E96C03083O006B39362B9D15E6E700663O00123A3O00014O0057000100023O0026813O00080001000200040E3O00080001002EA1000400080001000300040E3O00080001002EE8000500390001000600040E3O003900012O0057000200023O001213010300074O000C010400014O00AE00030002000500040E3O003600010020270008000700082O00FD0008000200020006220008003600013O00040E3O00360001001213010800094O000C010900064O00FD0008000200022O003401095O00122O000A000A3O00122O000B000B6O0009000B000200062O000800360001000900040E3O0036000100202700080007000C00123A000A000D4O002B0008000A00020006220008003600013O00040E3O0036000100202700080007000E2O00FD000800020002000EDC000100360001000800040E3O0036000100123A000800014O0057000900093O002681000800290001000100040E3O00290001002E05011000250001000F00040E3O0025000100123A000900013O0026810009002E0001000100040E3O002E0001002EE80012002A0001001100040E3O002A00012O000C010200073O002027000A000700132O00FD000A000200022O00A3000A00013O00040E3O0036000100040E3O002A000100040E3O0036000100040E3O002500010006180103000D0001000200040E3O000D000100123A3O00143O002EDA001500280001001500040E3O00610001000E2E0001006100013O00040E3O006100012O0057000100013O001273000300166O00045O00122O000500173O00122O000600186O000400066O00033O000200062O000300480001000100040E3O00480001002E050119004F0001001A00040E3O004F00012O00AA000300024O005400045O00122O0005001B3O00122O0006001C6O0004000600024O00010003000400044O006000010012130103001D4O000F00045O00122O0005001E3O00122O0006001F6O000400066O00033O000200062O0003005E00013O00040E3O005E00012O00AA000300024O005400045O00122O000500203O00122O000600216O0004000600024O00010003000400044O006000012O005500036O0084000300023O00123A3O00023O0026943O00020001001400040E3O000200012O0084000200023O00040E3O000200012O006D3O00017O00403O00028O00025O0046B040025O0049B040026O00F03F025O001AAD40025O00805540025O00D6B240025O00206340025O00B88D40025O000C9040025O00609C40025O00EAA140025O00649540025O0094A140025O000EA640025O001AA940025O00488D40025O0094AD40025O005EB240025O00AAA040025O00288C40025O007AB040025O000EAA40025O0002A940025O0026AA40025O00D09640025O00ABB240025O009EAF40025O00A4AF40025O00749540025O0053B240025O0013B14003043O004755494403053O007061697273025O0020834003063O00457869737473030C3O00497354616E6B696E67416F45026O00204003093O00497354616E6B696E6703163O00556E697447726F7570526F6C6573412O7369676E656403043O009A7D1D1003063O0051CE3C535B4F03093O004973496E52616E6765026O00394003103O004865616C746850657263656E74616765025O00E8B240025O004AB040025O00349040025O0026B140025O00FC9540025O00FC9D40025O00089540030A3O00556E6974496E5261696403063O002CA38055E66B03073O00185CCFE12C831903043O0079D2B14803063O001D2BB3D82C7B030B3O00556E6974496E506172747903063O00ADD52155B8CB03043O002CDDB94003053O0031E65A4B6A03053O00136187283F025O0098A740025O007EA54000D53O00123A3O00014O0057000100023O0026813O00060001000100040E3O00060001002E05010300150001000200040E3O0015000100123A000300013O0026810003000B0001000400040E3O000B0001002EE80005000D0001000600040E3O000D000100123A3O00043O00040E3O00150001000E92000100110001000300040E3O00110001002E05010700070001000800040E3O0007000100123A000100014O0057000200023O00123A000300043O00040E3O00070001000E920004001900013O00040E3O00190001002E05010A00020001000900040E3O0002000100123A000300014O0057000400043O000E920001001F0001000300040E3O001F0001002EE8000C001B0001000B00040E3O001B000100123A000400013O002681000400240001000100040E3O00240001002EE8000E00200001000D00040E3O00200001002681000100280001000400040E3O00280001002E05011000920001000F00040E3O0092000100123A000500013O002694000500290001000100040E3O002900012O00AA00065O000643000200300001000600040E3O00300001002EE80012005D0001001100040E3O005D000100123A000600014O0057000700073O002EE8001400320001001300040E3O00320001002694000600320001000100040E3O0032000100123A000700013O0026810007003D0001000100040E3O003D0001002EA10016003D0001001500040E3O003D0001002E05011700370001001800040E3O0037000100123A000800014O0057000900093O002681000800430001000100040E3O00430001002EE80019003F0001001A00040E3O003F000100123A000900013O002EE8001C00440001001B00040E3O00440001002694000900440001000100040E3O0044000100123A000A00013O002EE8001E004D0001001D00040E3O004D0001002681000A004F0001000100040E3O004F0001002EE8001F00490001002000040E3O004900012O00AA000B5O0020D7000B000B00214O000B000200024O000B00016O000B8O000B00023O00044O0049000100040E3O0044000100040E3O0037000100040E3O003F000100040E3O0037000100040E3O008F000100040E3O0032000100040E3O008F0001001213010600224O000C010700024O00AE00060002000800040E3O008D0001002EDA0023002C0001002300040E3O008D0001002027000B000A00242O00FD000B00020002000622000B008D00013O00040E3O008D0001002027000B000A002500123A000D00264O002B000B000D0002000647000B00710001000100040E3O00710001002027000B000A00272O00AA000D00024O002B000B000D0002000622000B008D00013O00040E3O008D0001001213010B00284O000C010C00094O00FD000B000200022O0034010C00033O00122O000D00293O00122O000E002A6O000C000E000200062O000B008D0001000C00040E3O008D0001002027000B000A002B00123A000D002C4O002B000B000D0002000622000B008D00013O00040E3O008D0001002027000B000A002D2O00FD000B00020002000EDC0001008D0001000B00040E3O008D000100123A000B00013O002681000B00880001000100040E3O00880001002E05012E00840001002F00040E3O00840001002027000C000A00212O00FD000C000200022O00A3000C00014O0084000A00023O00040E3O00840001000618010600610001000200040E3O006100012O0057000600064O0084000600023O00040E3O00290001002681000100960001000100040E3O00960001002EE8003100190001003000040E3O0019000100123A000500013O002E05013200C60001003300040E3O00C60001000E2E000100C60001000500040E3O00C6000100123A000600013O002EDA003400250001003400040E3O00C10001002694000600C10001000100040E3O00C100012O0057000200023O001202000700356O000800033O00122O000900363O00122O000A00376O0008000A6O00073O000200062O000700B000013O00040E3O00B000012O00AA000700044O0054000800033O00122O000900383O00122O000A00396O0008000A00024O00020007000800044O00C000010012130107003A4O000F000800033O00122O0009003B3O00122O000A003C6O0008000A6O00073O000200062O000700BF00013O00040E3O00BF00012O00AA000700044O0054000800033O00122O0009003D3O00122O000A003E6O0008000A00024O00020007000800044O00C000012O00AA00025O00123A000600043O0026940006009C0001000400040E3O009C000100123A000500043O00040E3O00C6000100040E3O009C0001002681000500CA0001000400040E3O00CA0001002E05013F00970001004000040E3O0097000100123A000100043O00040E3O0019000100040E3O0097000100040E3O0019000100040E3O0020000100040E3O0019000100040E3O001B000100040E3O0019000100040E3O00D4000100040E3O000200012O006D3O00017O00A63O00028O00027O0040025O00E0AD40025O00A6AC40025O00BCA340025O00D49A40026O00F03F025O0048AC40025O005CA040025O00D0A740025O00ECAD40026O000840025O00EC9A40025O001EA340025O008AA040025O0068904003103O00793CBB58575E0FA04258552BB953434F03053O002D3B4ED436030A3O0049734361737461626C6503083O0042752O66446F776E03143O0042726F6E7A65412O74756E656D656E7442752O6603063O0042752O66557003133O00426C61636B412O74756E656D656E7442752O66025O002C9140025O00489C4003103O0042726F6E7A65412O74756E656D656E74025O00BC9240025O00AEAB40031B3O0012448C859C2B92F1044296858323A8FE04169399832DA2FD12579703083O00907036E3EBE64ECD025O00449940025O008EA94003043O00923D1BF303063O003BD3486F9CB0025O001AA840025O0038924003103O006C8BEA3E5A82F1244080D02E4F8BE63E03043O004D2EE78303093O004973496E52616E6765026O00394003093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O6603043O004755494403153O00426C6973746572696E675363616C6573466F637573031D3O00B858BF53AE51A449B4538953B955BA45A914A652BF57B94DB855A200E803043O0020DA34D603083O00CEB65C407FCBF8B703063O00BF9DD330251C025O008DB140025O0026AC40025O001CB340025O00F8AC40025O00B2A240025O00488340025O0036A640025O003EA740025O00149F40025O00C0654003093O004E616D6564556E6974030D3O00EC10E10E39DA10F2313BD816F703053O005ABF7F947C030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O00206A40025O00D2A04003113O00536F757263656F664D616769634E616D65025O00909F40025O00D89E40025O00209540025O00DCA24003193O006B883B057B8211187EB823167F8E2D5768952B14778A2C166C03043O007718E74E030F3O00A021A449D761059638AB4FD1451F9603073O0071E24DC52ABC20025O00C09840025O00D6A140030F3O00426C61636B412O74756E656D656E74031A3O00381AF5B63129F5A12E03FAB03713FAA17A06E6B03919F9B73B0203043O00D55A7694026O001040025O000C9540025O00409540025O0032A040025O003AA64003093O00243009347008350E2E03053O003D6152665A03073O0049735265616479025O009CA640025O00BAA94003093O0045626F6E4D69676874025O006DB140025O00E8AB4003163O00A92CA445F85A170EA43AEB5BD5521D06A12CAA5F870F03083O0069CC4ECB2BA7377E025O00EC9340025O00708D40030B3O0089A335171D03E15DA4A72603083O0031C5CA437E7364A7025O00989240025O000CB040030B3O004C6976696E67466C616D65030E3O0049735370652O6C496E52616E6765025O0070A640025O00E0734003193O003B52C9208E51613157DE2485164E255EDC268D545F231B8E7903073O003E573BBF49E036025O00C8A240025O0056A340025O00C08140025O0068A040025O00D88340025O002EA740025O0080684003133O006CA7D5613CCA43A341ADC47A2AE15FAB40B1D503083O00C42ECBB0124FA32D03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E67025O0068B04003133O00426C652O73696E676F6674686542726F6E7A65025O0051B240025O00CEA74003203O00BA2E7B0D37F2E1BF1D71181BEFE7BD1D7C0C2B2OF5BD626E0C21F8E0B5207F0A03073O008FD8421E7E449B03043O008BDD19C403083O0081CAA86DABA5C3B7025O00607A40025O00B07940030D3O00115722CADD11E9247536DFD71703073O0086423857B8BE74025O00BDB040025O00649540025O0058A340025O002OA64003123O00536F757263656F664D61676963466F63757303193O002F3E1CA91AEE1E2O3A0E04BA1EE222752C230CB816E623342803083O00555C5169DB798B41025O0080AB40025O002EB340025O00809440025O0034A640025O0001B14003083O007D123DADF2A4405E03083O003A2E7751C891D025025O004EAD40025O00AC994003103O00098039BFBDB8242282379FAABC3A2E9F03073O00564BEC50CCC9DD025O002FB340025O009CAB4003143O00426C6973746572696E675363616C65734E616D65025O005EAB40025O0098AA40031D3O00704D7E96EA8E60487982C19871407B80EDCB62537286F186704063C5AC03063O00EB122117E59E025O00D8A140025O00A4B040025O0072A740026O003040030C3O0064B3D18F58BFF2B851B6C4A803043O00DB30DAA1025O0076A640025O006EA940030C3O005469705468655363616C6573031A3O00F0786C76CF47E5DB627F48D74AF3A4616E4CD840EDE67068098D03073O008084111C29BB2F0013022O00123A3O00014O0057000100013O0026943O00020001000100040E3O0002000100123A000100013O002694000100870001000200040E3O0087000100123A000200014O0057000300033O002EE8000400090001000300040E3O00090001002E05010600090001000500040E3O00090001002694000200090001000100040E3O0009000100123A000300013O002681000300160001000700040E3O00160001002E7B000800160001000900040E3O00160001002EE8000B00180001000A00040E3O0018000100123A0001000C3O00040E3O008700010026810003001E0001000100040E3O001E0001002E7B000E001E0001000D00040E3O001E0001002EE8000F00100001001000040E3O001000012O00AA00046O0038000500013O00122O000600113O00122O000700126O0005000700024O00040004000500202O0004000400134O00040002000200062O0004003E00013O00040E3O003E00012O00AA000400023O0020C90004000400144O00065O00202O0006000600154O00040006000200062O0004003E00013O00040E3O003E00012O00AA000400023O0020C90004000400164O00065O00202O0006000600174O00040006000200062O0004003E00013O00040E3O003E00012O00AA000400023O00203F0004000400164O00065O00202O0006000600174O00078O00040007000200062O0004004000013O00040E3O00400001002EDA0018000F0001001900040E3O004D00012O00AA000400034O00AA00055O00200600050005001A2O00FD000400020002000647000400480001000100040E3O00480001002EE8001C004D0001001B00040E3O004D00012O00AA000400013O00123A0005001D3O00123A0006001E4O00E9000400064O000100045O002EE8001F00570001002000040E3O005700012O00AA000400044O008C000500013O00122O000600213O00122O000700226O00050007000200062O000400570001000500040E3O0057000100040E3O00830001002EE8002400830001002300040E3O008300012O00AA00046O0038000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O0004000400134O00040002000200062O0004008300013O00040E3O008300012O00AA000400053O00202700040004002700123A000600284O002B0004000600020006220004008300013O00040E3O008300012O00AA000400053O00201E0004000400294O00065O00202O00060006002A4O0004000600024O000500063O00062O000400830001000500040E3O008300012O00AA000400074O00AA000500053O00202700050005002B2O00FD0005000200020006AF000400830001000500040E3O008300012O00AA000400034O00A4000500083O00202O00050005002C4O000600076O00040007000200062O0004008300013O00040E3O008300012O00AA000400013O00123A0005002D3O00123A0006002E4O00E9000400064O000100045O00123A000300073O00040E3O0010000100040E3O0087000100040E3O00090001002694000100F10001000700040E3O00F100012O00AA000200094O0034010300013O00122O0004002F3O00122O000500306O00030005000200062O000200D20001000300040E3O00D2000100123A000200014O0057000300043O002E05013200960001003100040E3O00960001002681000200980001000100040E3O00980001002EDA003300050001003400040E3O009B000100123A000300014O0057000400043O00123A000200073O002EE8003600920001003500040E3O00920001002E05013700920001003800040E3O00920001002694000200920001000700040E3O00920001002681000300A50001000100040E3O00A50001002E05013900A10001003A00040E3O00A100012O00AA0005000A3O00204D00050005003B00122O000600286O0007000B6O0005000700024O000400053O00062O000400BD00013O00040E3O00BD00012O00AA00056O0038000600013O00122O0007003C3O00122O0008003D6O0006000800024O00050005000600202O0005000500134O00050002000200062O000500BD00013O00040E3O00BD000100202700050004003E2O00AA00075O00200600070007003F2O002B0005000700020026AD000500BF0001004000040E3O00BF0001002EE8004200D20001004100040E3O00D200012O00AA000500034O00AA000600083O0020060006000600432O00FD000500020002000647000500C90001000100040E3O00C90001002ECF004400C90001004500040E3O00C90001002EE8004700D20001004600040E3O00D200012O00AA000500013O001224010600483O00122O000700496O000500076O00055O00044O00D2000100040E3O00A1000100040E3O00D2000100040E3O009200012O00AA00026O0038000300013O00122O0004004A3O00122O0005004B6O0003000500024O00020002000300202O0002000200134O00020002000200062O000200E300013O00040E3O00E300012O00AA000200023O0020AB0002000200144O00045O00202O0004000400174O00020004000200062O000200E50001000100040E3O00E50001002EDA004C000D0001004D00040E3O00F000012O00AA000200034O00AA00035O00200600030003004E2O00FD000200020002000622000200F000013O00040E3O00F000012O00AA000200013O00123A0003004F3O00123A000400504O00E9000200044O000100025O00123A000100023O002681000100F50001005100040E3O00F50001002EDA005200410001005300040E3O00342O01002EE8005400112O01005500040E3O00112O012O00AA00026O0038000300013O00122O000400563O00122O000500576O0003000500024O00020002000300202O0002000200584O00020002000200062O000200112O013O00040E3O00112O01002E05015900112O01005A00040E3O00112O012O00AA000200034O002901035O00202O00030003005B4O000400046O00020004000200062O0002000C2O01000100040E3O000C2O01002EDA005C00070001005D00040E3O00112O012O00AA000200013O00123A0003005E3O00123A0004005F4O00E9000200044O000100025O002EE8006100120201006000040E3O001202012O00AA00026O0038000300013O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200134O00020002000200062O0002001202013O00040E3O00120201002EE8006400120201006500040E3O001202012O00AA000200034O006E00035O00202O0003000300664O000400056O0006000C3O00202O0006000600674O00085O00202O0008000800664O0006000800024O000600066O00020006000200062O0002002E2O01000100040E3O002E2O01002EDA006800E60001006900040E3O001202012O00AA000200013O0012240103006A3O00122O0004006B6O000200046O00025O00044O00120201002E05016C00A82O01006D00040E3O00A82O01002694000100A82O01000100040E3O00A82O0100123A000200013O002EDA006E00040001006E00040E3O003D2O010026810002003F2O01000700040E3O003F2O01002E05016F00412O01007000040E3O00412O0100123A000100073O00040E3O00A82O01002EE8007200392O01007100040E3O00392O01002694000200392O01000100040E3O00392O012O00AA00036O0038000400013O00122O000500733O00122O000600746O0004000600024O00030003000400202O0003000300134O00030002000200062O000300712O013O00040E3O00712O012O00AA0003000D3O000622000300712O013O00040E3O00712O012O00AA000300023O0020C40003000300144O00055O00202O0005000500754O000600016O00030006000200062O000300612O01000100040E3O00612O012O00AA0003000A3O00201C0003000300764O00045O00202O0004000400754O00030002000200062O000300712O013O00040E3O00712O01002EDA007700090001007700040E3O006A2O012O00AA000300034O002901045O00202O0004000400784O000500056O00030005000200062O0003006C2O01000100040E3O006C2O01002EE8007900712O01007A00040E3O00712O012O00AA000300013O00123A0004007B3O00123A0005007C4O00E9000300054O000100036O00AA000300094O008C000400013O00122O0005007D3O00122O0006007E6O00040006000200062O0003007A2O01000400040E3O007A2O01002E05017F00A62O01008000040E3O00A62O012O00AA00036O0038000400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O0003000300134O00030002000200062O000300972O013O00040E3O00972O012O00AA000300053O00202700030003002700123A000500284O002B000300050002000622000300972O013O00040E3O00972O012O00AA0003000E4O00AA000400053O00202700040004002B2O00FD0004000200020006AF000300972O01000400040E3O00972O012O00AA000300053O0020FE00030003003E4O00055O00202O00050005003F4O00030005000200262O0003009B2O01004000040E3O009B2O01002EA10083009B2O01008400040E3O009B2O01002EE8008600A62O01008500040E3O00A62O012O00AA000300034O00AA000400083O0020060004000400872O00FD000300020002000622000300A62O013O00040E3O00A62O012O00AA000300013O00123A000400883O00123A000500894O00E9000300054O000100035O00123A000200073O00040E3O00392O01002694000100050001000C00040E3O0005000100123A000200013O000E92000100AF2O01000200040E3O00AF2O01002EE8008B000A0201008A00040E3O000A0201002EDA008C000C0001008C00040E3O00BB2O01002E05018D00BB2O01008E00040E3O00BB2O012O00AA000300044O008C000400013O00122O0005008F3O00122O000600906O00040006000200062O000300BB2O01000400040E3O00BB2O0100040E3O00EA2O0100123A000300014O0057000400043O002681000300C12O01000100040E3O00C12O01002EE8009100BD2O01009200040E3O00BD2O012O00AA0005000A3O00200D01050005003B00122O000600286O0007000F6O0005000700024O000400056O00058O000600013O00122O000700933O00122O000800946O0006000800024O00050005000600202O0005000500134O00050002000200062O000500D82O013O00040E3O00D82O010020270005000400292O005E00075O00202O00070007002A4O0005000700024O000600063O00062O000500030001000600040E3O00DA2O01002EDA009500120001009600040E3O00EA2O012O00AA000500034O0029010600083O00202O0006000600974O000700086O00050008000200062O000500E32O01000100040E3O00E32O01002EDA009800090001009900040E3O00EA2O012O00AA000500013O0012240106009A3O00122O0007009B6O000500076O00055O00044O00EA2O0100040E3O00BD2O01002EE8009C00090201009D00040E3O00090201002EE8009F00090201009E00040E3O000902012O00AA000300103O0006220003000902013O00040E3O000902012O00AA00036O0038000400013O00122O000500A03O00122O000600A16O0004000600024O00030003000400202O0003000300134O00030002000200062O0003000902013O00040E3O00090201002E0501A20009020100A300040E3O000902012O00AA000300034O00A400045O00202O0004000400A44O000500056O00030005000200062O0003000902013O00040E3O000902012O00AA000300013O00123A000400A53O00123A000500A64O00E9000300054O000100035O00123A000200073O000E2E000700AB2O01000200040E3O00AB2O0100123A000100513O00040E3O0005000100040E3O00AB2O0100040E3O0005000100040E3O0012020100040E3O000200012O006D3O00017O00243O00028O00025O00F08340025O00E09040026O007740025O009EB04003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E6974025O00E9B240025O0036A140025O0010A340025O002DB040025O0018B140025O001EA74003073O00C21AEADCE905FF03043O00A987629A03073O004973526561647903133O00556E6974486173506F69736F6E446562752O66025O00109A40025O0035B240025O00408340030C3O00457870756E6765466F637573030E3O00EE6F3441F334CD8B732D47ED36C403073O00A8AB1744349D53026O00F03F025O003CAA40025O0028B340030E3O00DB61E5BF203E94FD7FF29F2A2C9503073O00E7941195CD454D03113O00556E6974486173456E7261676542752O66025O008AA640025O0078A640030E3O004F2O7072652O73696E67526F617203163O00AFB7D7E952EC93AEC9FC17CD8FA6D5BB53F693B7C2F703063O009FE0C7A79B3700683O00123A3O00013O002E05010200410001000300040E3O00410001002EE8000400410001000500040E3O004100010026943O00410001000100040E3O004100012O00AA00015O0006220001001E00013O00040E3O001E00012O00AA00015O0020270001000100062O00FD0001000200020006220001001E00013O00040E3O001E00012O00AA00015O00202700010001000700123A000300084O002B0001000300020006220001001E00013O00040E3O001E00012O00AA000100013O0020060001000100092O00262O01000100020006220001001E00013O00040E3O001E0001002E7B000A001E0001000B00040E3O001E0001002EDA000C00030001000D00040E3O001F00012O006D3O00013O002EE8000F00400001000E00040E3O004000012O00AA000100024O0038000200033O00122O000300103O00122O000400116O0002000400024O00010001000200202O0001000100124O00010002000200062O0001004000013O00040E3O004000012O00AA000100013O0020060001000100132O00AA00026O00FD0001000200020006220001004000013O00040E3O00400001002EDA0014000F0001001400040E3O00400001002EE8001600400001001500040E3O004000012O00AA000100044O00AA000200053O0020060002000200172O00FD0001000200020006220001004000013O00040E3O004000012O00AA000100033O00123A000200183O00123A000300194O00E9000100034O000100015O00123A3O001A3O0026813O00450001001A00040E3O00450001002E05011C00010001001B00040E3O000100012O00AA000100024O0038000200033O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200202O0001000100124O00010002000200062O0001006700013O00040E3O006700012O00AA000100063O0006220001006700013O00040E3O006700012O00AA000100013O00200600010001001F2O00AA000200074O00FD0001000200020006220001006700013O00040E3O00670001002EE8002100670001002000040E3O006700012O00AA000100044O00AA000200023O0020060002000200222O00FD0001000200020006220001006700013O00040E3O006700012O00AA000100033O001224010200233O00122O000300246O000100036O00015O00044O0067000100040E3O000100012O006D3O00017O00613O00028O00025O00BAA340025O001AA740025O001EAF40025O00488440025O005C9E40025O0030A540025O00F09D40025O007BB040025O00804340026O00F03F025O0097B040025O0016AD4003133O00D5FF39C1E4FA32D5F8F528DAF2D12EDDF9E93903043O00B297935C030A3O0049734361737461626C6503083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E6703133O00426C652O73696E676F6674686542726F6E7A6503203O008EF149210145748BC243342D587289C24E201D426089BD5C20174F7581FF4D2603073O001AEC9D2C52722C025O00FEAE40025O00E2A14003043O000B3BC15403043O003B4A4EB5025O00989640025O0072A740030D3O0016DE4F48B020DE5C77B222D85903053O00D345B12O3A03093O004973496E52616E6765026O00394003043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O00988A40025O0056A74003123O00536F757263656F664D61676963466F63757303193O00A4EA6CE7EACE88EA7FCAE4CAB0EC7AB5F9D9B2E676F8EBCAA303063O00ABD785199589027O0040025O0068AA40025O00E0684003083O0006B187F7D921B18F03053O00BA55D4EB92025O00589740025O00D4B140025O00A0B040025O00507D40025O001DB340025O00E0604003093O004E616D6564556E697403103O00E08D1FED2DEB4ACB8F11CD3AEF54C79203073O0038A2E1769E598E03093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O66025O001EAD40025O00C0554003143O00426C6973746572696E675363616C65734E616D6503193O005E09C9BC36DD4E0CCEA81DCB5F04CCAA31985104C9A1628B0803063O00B83C65A0CF42025O00088340025O0062AE40025O0018A840025O001CA940025O0088A440025O00FEA040025O00C4AA40025O00AEA440025O006EA740025O00A09840025O0017B14003083O00D2CD3EFFEC24F94603083O002281A8529A8F509C025O0030A740025O00C05140025O00D0A640025O0040A440030D3O00B6BD26192O4B86839F320C414D03073O00E9E5D2536B282E025O00CAAA40025O0010AB4003113O00536F757263656F664D616769634E616D6503193O00D24D27C406C47D3DD03ACC4335DF06815220D306CE4F30D71103053O0065A12252B6025O00589140025O0006A64003043O00C9184DF103083O004E886D399EBB82E2025O00809C40025O0036A64003103O001C33F0E22A3AEBF83038CAF23F33FCE203043O00915E5F9903153O00426C6973746572696E675363616C6573466F63757303193O00FFC11DC65AB2EFC41AD271A4FECC18D05DF7F0CC1DDB0EE4A903063O00D79DAD74B52E004F012O00123A3O00014O0057000100013O0026813O00060001000100040E3O00060001002EDA000200FEFF2O000300040E3O0002000100123A000100013O002EE8000500790001000400040E3O007900010026810001000D0001000100040E3O000D0001002EDA0006006E0001000700040E3O0079000100123A000200013O002EDA000800080001000800040E3O00160001002E05010A00160001000900040E3O00160001002694000200160001000B00040E3O0016000100123A0001000B3O00040E3O00790001002E05010D000E0001000C00040E3O000E00010026940002000E0001000100040E3O000E00012O00AA00036O0038000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003004200013O00040E3O004200012O00AA000300023O0006220003004200013O00040E3O004200012O00AA000300033O0020C40003000300114O00055O00202O0005000500124O000600016O00030006000200062O000300360001000100040E3O003600012O00AA000300043O00201C0003000300134O00045O00202O0004000400124O00030002000200062O0003004200013O00040E3O004200012O00AA000300054O00A400045O00202O0004000400144O000500056O00030005000200062O0003004200013O00040E3O004200012O00AA000300013O00123A000400153O00123A000500164O00E9000300054O000100035O002EE8001800770001001700040E3O007700012O00AA000300064O0034010400013O00122O000500193O00122O0006001A6O00040006000200062O000300770001000400040E3O00770001002EE8001B00770001001C00040E3O007700012O00AA00036O0038000400013O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003006A00013O00040E3O006A00012O00AA000300073O00202700030003001F00123A000500204O002B0003000500020006220003006A00013O00040E3O006A00012O00AA000300084O00AA000400073O0020270004000400212O00FD0004000200020006AF0003006A0001000400040E3O006A00012O00AA000300073O0020FE0003000300224O00055O00202O0005000500234O00030005000200262O0003006C0001002400040E3O006C0001002EE8002600770001002500040E3O007700012O00AA000300054O00AA000400093O0020060004000400272O00FD0003000200020006220003007700013O00040E3O007700012O00AA000300013O00123A000400283O00123A000500294O00E9000300054O000100035O00123A0002000B3O00040E3O000E00010026810001007D0001002A00040E3O007D0001002EE8002B00CF0001002C00040E3O00CF00012O00AA0002000A4O0034010300013O00122O0004002D3O00122O0005002E6O00030005000200062O0002004E2O01000300040E3O004E2O0100123A000200014O0057000300043O002E05012F00B80001003000040E3O00B80001002694000200B80001000B00040E3O00B80001002EE80032008A0001003100040E3O008A0001002E050134008A0001003300040E3O008A00010026940003008A0001000100040E3O008A00012O00AA000500043O00200D01050005003500122O000600206O0007000B6O0005000700024O000400056O00058O000600013O00122O000700363O00122O000800376O0006000800024O00050005000600202O0005000500104O00050002000200062O000500A700013O00040E3O00A700010020270005000400382O005E00075O00202O0007000700394O0005000700024O0006000C3O00062O000500030001000600040E3O00A90001002EE8003A004E2O01003B00040E3O004E2O012O00AA000500054O00A4000600093O00202O00060006003C4O000700086O00050008000200062O0005004E2O013O00040E3O004E2O012O00AA000500013O0012240106003D3O00122O0007003E6O000500076O00055O00044O004E2O0100040E3O008A000100040E3O004E2O01002E05013F00860001004000040E3O00860001002694000200860001000100040E3O0086000100123A000500013O002681000500C30001000100040E3O00C30001002EA1004200C30001004100040E3O00C30001002EE8004300C60001004400040E3O00C6000100123A000300014O0057000400043O00123A0005000B3O002681000500CA0001000B00040E3O00CA0001002EE8004500BD0001004600040E3O00BD000100123A0002000B3O00040E3O0086000100040E3O00BD000100040E3O0086000100040E3O004E2O01002EDA00470038FF2O004700040E3O00070001002681000100D50001000B00040E3O00D50001002EDA00480034FF2O004900040E3O000700012O00AA000200064O0034010300013O00122O0004004A3O00122O0005004B6O00030005000200062O000200172O01000300040E3O00172O01002EDA004C00030001004D00040E3O00DF000100040E3O00172O0100123A000200014O0057000300043O0026940002000F2O01000B00040E3O000F2O01002681000300E70001000100040E3O00E70001002EE8004E00E30001004F00040E3O00E300012O00AA000500043O00204D00050005003500122O000600206O0007000D6O0005000700024O000400053O00062O000400172O013O00040E3O00172O012O00AA00056O0038000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O0005000500104O00050002000200062O000500172O013O00040E3O00172O010020270005000400222O00AA00075O0020060007000700232O002B0005000700020026E3000500172O01002400040E3O00172O01002EE8005200172O01005300040E3O00172O012O00AA000500054O00AA000600093O0020060006000600542O00FD000500020002000622000500172O013O00040E3O00172O012O00AA000500013O001224010600553O00122O000700566O000500076O00055O00044O00172O0100040E3O00E3000100040E3O00172O01002681000200132O01000100040E3O00132O01002E05015800E10001005700040E3O00E1000100123A000300014O0057000400043O00123A0002000B3O00040E3O00E100012O00AA0002000A4O0034010300013O00122O000400593O00122O0005005A6O00030005000200062O0002004A2O01000300040E3O004A2O01002E05015B004A2O01005C00040E3O004A2O012O00AA00026O0038000300013O00122O0004005D3O00122O0005005E6O0003000500024O00020002000300202O0002000200104O00020002000200062O0002004A2O013O00040E3O004A2O012O00AA000200073O00202700020002001F00123A000400204O002B0002000400020006220002004A2O013O00040E3O004A2O012O00AA000200073O00201E0002000200384O00045O00202O0004000400394O0002000400024O0003000C3O00062O0002004A2O01000300040E3O004A2O012O00AA0002000E4O00AA000300073O0020270003000300212O00FD0003000200020006AF0002004A2O01000300040E3O004A2O012O00AA000200054O00A4000300093O00202O00030003005F4O000400056O00020005000200062O0002004A2O013O00040E3O004A2O012O00AA000200013O00123A000300603O00123A000400614O00E9000200044O000100025O00123A0001002A3O00040E3O0007000100040E3O004E2O0100040E3O000200012O006D3O00017O00443O00028O00025O00ECA740025O0042A240025O00707A40030B3O00018E7DA534903C933F8E6503043O00DC51E21C030E3O0025D090FFEBC907F08FF9F8C610D003063O00A773B5E29B8A03073O004973526561647903103O004865616C746850657263656E74616765025O00A7B240025O00588640025O0068AC40025O006C9C4003143O0056657264616E74456D6272616365506C6179657203173O00F427F5587A7FD2DD27EA5E6970C5E762EA5D727F86B67203073O00A68242873C1B1103083O00615CCB67294B44CB03053O0050242AAE1503083O00601F233A7A11397103043O001A2E7057025O00608640025O00EEB040030E3O008F26B970BEB15191B421B975BCBA03083O00D4D943CB142ODF25025O00349140025O00B2A240025O000C9540025O00488F40025O00B4A74003133O0056657264616E74456D6272616365466F63757303173O00AC88BAD6BB83BCEDBF80AAC0BB8EAD92B78CA1DCFAD9F803043O00B2DAEDC8026O00F03F025O00888E40025O00049D40025O003EAD40025O0038A240025O00208B40025O00088C40030B3O0086B9E7C9B3A7A6FFB8B9FF03043O00B0D6D586025O0028A940025O007CB240030E3O00D1A0B3C6A95A5DD6A1B9C7BB595403073O003994CDD6B4C836025O006C9140025O006DB24003143O00456D6572616C64426C6F2O736F6D506C61796572025O0082B140025O0062B34003173O0017F03026771EF90A367A1DEE263B7B52F0343D7852A96703053O0016729D5554025O0016AB40025O00FCA24003083O00E1DD16D644F9A6C103073O00C8A4AB73A43D96025O0068A540025O000BB040030E3O009BF9065782B2F021498CADE70C4803053O00E3DE946325025O00708040025O00F07F40025O00C07140025O00E0854003133O00456D6572616C64426C6F2O736F6D466F63757303173O00365F57E4F83F566DF4F53C2O41F9F4735F53FFF773060003053O0099532O329600D13O00123A3O00014O0057000100013O002EDA00023O0001000200040E3O000200010026943O00020001000100040E3O0002000100123A000100013O002694000100700001000100040E3O0070000100123A000200013O0026810002000E0001000100040E3O000E0001002E05010300690001000400040E3O006900012O00AA00036O008C000400013O00122O000500053O00122O000600066O00040006000200062O000300160001000400040E3O0016000100040E3O003600012O00AA000300024O0038000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002600013O00040E3O002600012O00AA000300033O00202700030003000A2O00FD0003000200022O00AA000400043O000620010300280001000400040E3O00280001002EDA000B00100001000C00040E3O00360001002E05010E00360001000D00040E3O003600012O00AA000300054O00A4000400063O00202O00040004000F4O000500056O00030005000200062O0003003600013O00040E3O003600012O00AA000300013O00123A000400103O00123A000500114O00E9000300054O000100036O00AA00036O008C000400013O00122O000500123O00122O000600136O00040006000200062O000300440001000400040E3O004400012O00AA00036O0034010400013O00122O000500143O00122O000600156O00040006000200062O000300680001000400040E3O00680001002E05011600560001001700040E3O005600012O00AA000300024O0038000400013O00122O000500183O00122O000600196O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005600013O00040E3O005600012O00AA000300073O00202700030003000A2O00FD0003000200022O00AA000400043O000620010300580001000400040E3O00580001002E05011B00680001001A00040E3O00680001002EDA001C00100001001C00040E3O00680001002EE8001D00680001001E00040E3O006800012O00AA000300054O00A4000400063O00202O00040004001F4O000500056O00030005000200062O0003006800013O00040E3O006800012O00AA000300013O00123A000400203O00123A000500214O00E9000300054O000100035O00123A000200223O0026810002006D0001002200040E3O006D0001002EE80024000A0001002300040E3O000A000100123A000100223O00040E3O0070000100040E3O000A0001002EE8002600070001002500040E3O00070001002681000100760001002200040E3O00760001002EE8002800070001002700040E3O000700012O00AA000200084O008C000300013O00122O000400293O00122O0005002A6O00030005000200062O0002007E0001000300040E3O007E000100040E3O00A00001002E05012B00A00001002C00040E3O00A000012O00AA000200024O0038000300013O00122O0004002D3O00122O0005002E6O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009000013O00040E3O009000012O00AA000200033O00202700020002000A2O00FD0002000200022O00AA000300093O000620010200920001000300040E3O00920001002EDA002F00100001003000040E3O00A000012O00AA000200054O0029010300063O00202O0003000300314O000400046O00020004000200062O0002009B0001000100040E3O009B0001002E05013300A00001003200040E3O00A000012O00AA000200013O00123A000300343O00123A000400354O00E9000200044O000100025O002E05013700AA0001003600040E3O00AA00012O00AA000200084O008C000300013O00122O000400383O00122O000500396O00030005000200062O000200AA0001000300040E3O00AA000100040E3O00D00001002EE8003A00D00001003B00040E3O00D000012O00AA000200024O0038000300013O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200D000013O00040E3O00D000012O00AA000200073O00202700020002000A2O00FD0002000200022O00AA000300093O0006E0000200D00001000300040E3O00D00001002EE8003F00D00001003E00040E3O00D00001002EE8004000D00001004100040E3O00D000012O00AA000200054O00A4000300063O00202O0003000300424O000400046O00020004000200062O000200D000013O00040E3O00D000012O00AA000200013O001224010300433O00122O000400446O000200046O00025O00044O00D0000100040E3O0007000100040E3O00D0000100040E3O000200012O006D3O00017O00C2012O00028O00026O00F03F025O00207840025O00206140025O00A4A040025O00309D40026O001C40025O00D88C40025O0046A040025O0036AE40030A3O00F923F35397CF23F757BD03053O00D5BD469623030A3O0049734361737461626C65030C3O006D4771095B5D7B0E6A5A7A1B03043O00682F3514030B3O004973417661696C61626C65025O004DB040025O00707640025O0024A840025O0028AC40025O00E89A40030A3O00442O657042726561746803093O004973496E52616E6765026O003E4003133O00A749840C830DB1498008B44FAE4D8812FC5CF103063O006FC32CE17CDC026O002040025O0054AA40025O0039B040025O0024B040025O0034AF40025O00D8AD40030A3O00715116DB754A01DF435003043O00BE373864030C3O0077A13F1716EDE770A33D131603073O009336CF5C7E7383030B3O0042752O6652656D61696E7303113O0045626F6E4D6967687453656C6642752O66030F3O00456D706F7765724361737454696D65025O00409740025O00A49940025O00C05640025O0078A540025O00107B40025O0076A140030A3O0046697265427265617468026O00394003143O000B382778327C1F2O3469053E083C25721A7B1F7103063O001E6D51551D6D03083O00BF7C55BF389EAEA703073O009C9F1134D656BE03083O009BFFB5B9AFF9BCB003043O00DCCE8FDD025O00B89C40025O004EA340025O0018A340025O00E2A94003083O00557068656176616C03113O00936D2512D9DAD38A3D281AC8C3C5836F6D03073O00B2E61D4D77B8AC03083O00B5B30B1279B8A6EE03063O009895DE6A7B17025O003C9C40025O00F49A4003143O00456E656D696573436F756E74387953706C617368026O001040027O0040025O00CAAC40025O00206740025O00108740025O009C9E40026O000840026O001840026O001440025O002O9440025O002AA840025O00C88340025O0054A440025O0066A440025O0053B140025O00907740025O0031B240025O0004B340025O00809040025O00405D40025O003DB340025O00709540025O00C88740025O0080AD40025O00DCA940025O002EAF40025O00C05A40025O0029B340025O00A4AB40025O00D2A940030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O00608F40025O0086AF40025O00E4A540025O00107740025O00649740025O0002A44003113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572025O00349240025O000C9140025O008CAD4003073O008D7BF0F49BBD7903053O00EDD815829503073O004973526561647903073O00556E726176656C030E3O0049735370652O6C496E52616E6765025O00808940025O00C09A40025O002CA640025O0060A540030E3O0097404D5EA6CC52C2435E56BE890C03073O003EE22E2O3FD0A9025O0086AC40025O00989540025O00288540025O005AA540025O0036A740030B3O002FCF61450DC1514002CB7203043O002C63A61703063O0042752O66557003113O004C656170696E67466C616D657342752O6603103O005AFE3B3311B679F63D3E17A17EE22F3003063O00C41C97495653030F3O0041757261416374697665436F756E74025O004EA440025O00A4AF40030B3O004C6976696E67466C616D6503143O00FF0A3F198C5F2770FF022415C255197FFD437B4203083O001693634970E23878025O00388C40025O003EA540025O00C89F40025O00C0A740025O00B0B140025O00C2A040025O0067B240030B3O00C910438A110A0952E4145003083O003E857935E37F6D4F030A3O00436F6D62617454696D65030B3O003C1D24FCD8A9841C153FF003073O00C270745295B6CE03083O004361737454696D65025O00F0B240025O00DDB040025O0058A040025O000AA04003133O0035A15A11CEE5313FA44D15C5A20338A142589403073O006E59C82C78A082025O00088440025O00BBB24003083O009FCA46437041325D03083O002DCBA32B26232A5B030A3O00F48CCE26A5BB51D391D403073O0034B2E5BC43E7C9030F3O00432O6F6C646F776E52656D61696E7303083O0014515801F64A222D03073O004341213064973C030A3O00EFF5ABCBF0D6E2A0DBF603053O0093BF87CEB8025O00804140025O0090A040025O00BFB24003093O00486F76657242752O66025O0080924003083O0054696D65536B6970025O00C4AD40025O00A7B24003113O009021ABC4E740B98D38E6CCD95ABCC47AF203073O00D2E448C6A1B83303053O00486F766572030D3O003E46E515618E3B48FA1E339C6203063O00AE5629937013025O00BAB140025O0050784003113O004F09800E1A1C1AA24B40800A2C0151F90F03083O00CB3B60ED6B456F71025O0092AA40025O004EA140025O00FAA340025O00E07040025O00D89840030A3O00021FBEE413E2D22502A403073O00B74476CC815190030C3O002FA373ED0E8C1A8B7CE5068703063O00E26ECD10846B025O001CA240025O003C9E40025O00F2AA40025O00649940025O00C4934003013O0031031D3O00EDCAF2DC7EE9D1E5D855E383E5D451E4D4E5CB01BA83EDD848E583B28F03053O00218BA380B9025O00149540025O00409540025O00588840030C3O00B02O481A8C446B2D854D5D3D03043O004EE42138030A3O00E877A006A7DC7BB3178D03053O00E5AE1ED2632O033O00474344030C3O005469705468655363616C6573025O00EEA240025O00BC914003163O000FE4966EF9353C24FE8550E1382A5BE08758E37D684B03073O00597B8DE6318D5D025O00804940025O00C08C40025O0068B240026O00A740030E3O00E2E50EF21EC4E613C819CCEB18E803053O007AAD877D9B03103O004865616C746850657263656E7461676503083O0042752O66446F776E030E3O004F6273696469616E5363616C6573025O0030A740025O00389F40025O00EAB140025O001EA04003153O008BC313B03B38C98AD203B83334DBC4CC01B031719E03073O00A8E4A160D95F5103093O00FED32152025EDCD93A03063O0037BBB14E3C4F030F3O0042752O665265667265736861626C65025O001AA840025O006CA540025O000AAC40025O005EA94003093O0045626F6E4D6967687403113O0028CC50E579C2892AC64BAB4BCE89238E0703073O00E04DAE3F8B26AF025O00807740025O008C9B40025O006C9B4003073O0047657454696D65025O00C6AA40025O00CEA04003053O00757965196103073O002D3D16137C13CB025O00EAAD40025O00E8A740030C3O00C91D1BF01030B4C01B03B55003073O00D9A1726D956210030F3O00412O66656374696E67436F6D626174025O00406F40025O00307740025O0016B140025O00689540025O005FB040025O00409340025O007EAB40025O007AA840025O00849740025O0009B340025O0084B340025O0071B240025O006EAF40030D3O0020253679AB7D1C271A70BD6E1703063O00147240581CDC025O00606E40025O00A4B140030D3O0052656E6577696E67426C617A6503143O000304DCB1EFD9B33623DEB5E2D5FD3C00DBBAB88603073O00DD5161B2D498B0025O0050AE40025O00B6B140025O0080A240025O00DAA340025O007DB240025O0007B040030F3O0048616E646C65445053506F74696F6E03133O002EB0851D15A789012DBA9D031E918D2O0FB38E03043O006D7AD5E8030C3O00CCE5A731FAFFAD36CBF8AC2303043O00508E97C2025O003EAD40025O00389D40025O00A07240025O00ECA940030C3O00240D57C6B87A84003A5DC9BF03073O00EB667F32A7CC1203093O0075A3FA2D692757A9E103063O004E30C1954324025O00109240025O0040A94003073O00103D950A523F0C03053O0021507EE078025O00488840025O00C4A34003123O004272656174686F66456F6E73437572736F7203163O00EEBA06C548E4970CC263E9A70DD71CE1A90ACA1CBDF003053O003C8CC863A4025O0042AD40025O0036A540030C3O00A4FB0A20AB95F90532AB88FA03053O00C2E7946446030C3O004272656174686F66456F6E73025O00DC9240025O00B1B040025O004EB340025O00CC9A4003163O00445EC4A2E2C07943C79CF3C7485F81AEF7C1480C90FB03063O00A8262CA1C39603133O00B4F98F663FFAB71AB7F3977834CCB31495FA8403083O0076E09CE2165088D6030C3O0060FC5C8156E6568667E1579303043O00E0228E3903063O00F3A6CBC872FD03083O006EBEC7A5BD13913D03063O00F7EA79FD8ACB03063O00A7BA8B1788EB025O00549F40025O00C2A340025O003EA740025O0048B140025O00A4A640025O00F09040025O00D08E4003103O0048616E646C65546F705472696E6B657403133O0048616E646C65426F2O746F6D5472696E6B6574025O005EA840025O00E07A40025O00D2A240025O0026A940025O00C05940025O00EEAF40025O00B8A740025O002CA44003083O00FD541563BFA2D74803063O00CBB8266013CB03083O001C616C51DA307C7703053O00AE5913192103103O00452O73656E636554696D65546F4D617803083O000A00475EE38E042103073O006B4F72322E97E703103O00452O73656E6365427572737442752O6603083O004572757074696F6E025O00108C40025O00BCA540025O00E06F40026O00834003103O003CB4A0399E30B8CE79ABB4208479E49603083O00A059C6D549EA59D7030B3O006478A2F7CB4F57B8FFC84D03053O00A52811D49E03083O0049734D6F76696E6703123O00D5CC183A2AEADF293F23FDCA1C2127F6C30903053O004685B9685303143O00084C5223C7037A4226C809400427C80D4B047E9B03053O00A96425244A030B3O00219DB74205B4B642098CA703043O003060E7C203123O00F84F1E2415D7A9A2C45F163E0DCAAE90D25B03083O00E3A83A6E4D79B8CF025O0094A140025O00909B40030B3O00417A757265537472696B6503143O007A26AA52B4E462B16935B445F1D670AC757CEB1403083O00C51B5CDF20D1BB11025O00A88540025O001CAF40025O00F8A640025O009EAD40025O004CB24003083O00E391F74CDEC080F303053O00BFB6E19F2903083O001F1B2550B88CCB3B03073O00A24B724835EBE703113O00A53250E74115832A41EC670A9E3945E64003063O0062EC5C24823303083O00901001BF76A3BC2003083O0050C4796CDA25C8D5025O00607B40025O005C9B40025O000C9640025O00DEA640025O00388E40025O00B88340025O00E2A640025O0056B040031A3O0015630A7A4A188B0C330772441E9D0561422E0B038B097D422E1D03073O00EA6013621F2B6E025O003AB240025O00188340025O00507540025O00E8AE40030A3O00D578E4093258F670E20403063O002A9311966C70030D3O0023A32C6FEEE60880217EEAED1C03063O00886FC64D1F8703083O003600AA538EEF1EB903083O00C96269C736DD847703113O00900297241022A3AF098D150A27A9B8089003073O00CCD96CE341625503083O006ACAF8E01FCB57D303063O00A03EA395854C025O0081B240025O00ADB140025O000FB140025O002EAD40025O00EAB240025O00689740025O00F4A240026O003540025O00CC9E40025O00809440025O0056B340031D3O00D0A91F2AFCD4B2082ED7DEE00822D3D9B7083D8387E0002ECAD8E05C7D03053O00A3B6C06D4F030A3O00122F12C5D7262301D4FD03053O0095544660A0030D3O0014030CFD31080ACB340700E82B03043O008D58666D03083O00875AC77529365CD103083O00A1D333AA107A5D3503113O00D2A0A62DE9B9BD3EFEA08620E9ABB32CE803043O00489BCED203083O007273590B004D734403053O0053261A346E025O00D4A640025O00907B40025O00408A40025O00EC9240025O0093B140025O00C09840025O0050AC40025O00C09140025O00F8AC40025O007DB040025O00EC9F40025O00AEA44003143O005E1E35436715354359032F065D1A37494F12350603043O002638774703083O00B3E259DF2B16A2BB03063O0036938F38B645025O00C0AC40025O00307E40025O00549640025O00F2A84000A1072O00123A3O00014O0057000100033O0026943O00950701000200040E3O009507012O0057000300033O002E05010400090001000300040E3O000900010026810001000B0001000200040E3O000B0001002EDA000500800701000600040E3O008907010026940002001F2O01000700040E3O001F2O0100123A000400013O002EDA000800040001000800040E3O00120001002681000400140001000200040E3O00140001002EE8000A00410001000900040E3O004100012O00AA00056O0038000600013O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005002800013O00040E3O002800012O00AA00056O0038000600013O00122O0007000E3O00122O0008000F6O0006000800024O00050005000600202O0005000500104O00050002000200062O0005002C00013O00040E3O002C0001002ECF0011002C0001001200040E3O002C0001002E050114003F0001001300040E3O003F0001002EDA001500130001001500040E3O003F00012O00AA000500024O001901065O00202O0006000600164O000700086O000900033O00202O00090009001700122O000B00186O0009000B00024O000900096O00050009000200062O0005003F00013O00040E3O003F00012O00AA000500013O00123A000600193O00123A0007001A4O00E9000500074O000100055O00123A0002001B3O00040E3O001F2O010026940004000E0001000100040E3O000E000100123A000500013O002EE8001C004A0001001D00040E3O004A00010026940005004A0001000200040E3O004A000100123A000400023O00040E3O000E0001002EDA001E00FAFF2O001E00040E3O00440001002681000500500001000100040E3O00500001002E05011F00440001002000040E3O004400012O00AA00066O0038000700013O00122O000800213O00122O000900226O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600A400013O00040E3O00A400012O00AA00066O0038000700013O00122O000800233O00122O000900246O0007000900024O00060006000700202O0006000600104O00060002000200062O000600A400013O00040E3O00A400012O00AA000600043O0020750006000600254O00085O00202O0008000800264O0006000800024O000700043O00202O0007000700274O000900056O00070009000200062O000700A40001000600040E3O00A4000100123A000600014O0057000700083O002694000600760001000100040E3O0076000100123A000700014O0057000800083O00123A000600023O002694000600710001000200040E3O00710001002EE80028007C0001002900040E3O007C0001000E920001007E0001000700040E3O007E0001002E05012B00780001002A00040E3O0078000100123A000800013O002E05012C007F0001002D00040E3O007F00010026940008007F0001000100040E3O007F00012O00AA000900054O00D5000900066O000900076O000A5O00202O000A000A002E4O000B8O000C00056O000D00033O00202O000D000D001700122O000F002F6O000D000F00024O000D000D6O000E000E6O0009000E000200062O000900A400013O00040E3O00A400012O00AA000900013O0012C6000A00303O00122O000B00316O0009000B00024O000A00056O000B00013O00122O000C00323O00122O000D00336O000B000D00024O00090009000B4O000900023O00044O00A4000100040E3O007F000100040E3O00A4000100040E3O0078000100040E3O00A4000100040E3O007100012O00AA00066O0038000700013O00122O000800343O00122O000900356O0007000900024O00060006000700202O00060006000D4O00060002000200062O000600B900013O00040E3O00B900012O00AA000600043O0020EF0006000600254O00085O00202O0008000800264O0006000800024O000700043O00202O00070007002700122O000900026O00070009000200062O000700BB0001000600040E3O00BB0001002EE80037001C2O01003600040E3O001C2O0100123A000600014O0057000700073O002694000600DC0001000200040E3O00DC00012O00A3000700083O002EE80038001C2O01003900040E3O001C2O012O00AA000800074O007A00095O00202O00090009003A4O000A8O000B00076O000C00033O00202O000C000C001700122O000E002F6O000C000E00024O000C000C6O000D000D4O002B0008000D00020006220008001C2O013O00040E3O001C2O012O00AA000800013O00123A0009003B3O00123A000A003C4O002B0008000A00022O000C010900074O0003010A00013O00122O000B003D3O00122O000C003E6O000A000C00024O00080008000A4O000800023O00044O001C2O01000E2E000100BD0001000600040E3O00BD000100123A000700023O002E05014000F60001003F00040E3O00F60001001213010800413O000EDC000200F20001000800040E3O00F20001001213010800413O0026E3000800F20001004200040E3O00F200012O00AA000800043O0020EF0008000800254O000A5O00202O000A000A00264O0008000A00024O000900043O00202O00090009002700122O000B00436O0009000B000200062O000900F40001000800040E3O00F40001002E05014400F60001004500040E3O00F6000100123A000700433O00040E3O001A2O01002E050146000B2O01004700040E3O000B2O01001213010800413O000EDC0048000B2O01000800040E3O000B2O01001213010800413O0026E30008000B2O01004900040E3O000B2O012O00AA000800043O0020650008000800254O000A5O00202O000A000A00264O0008000A00024O000900043O00202O00090009002700122O000B00486O0009000B000200062O0009000B2O01000800040E3O000B2O0100123A000700483O00040E3O001A2O01001213010800413O000EDC004A001A2O01000800040E3O001A2O012O00AA000800043O0020750008000800254O000A5O00202O000A000A00264O0008000A00024O000900043O00202O0009000900274O000B00056O0009000B000200062O0009001A2O01000800040E3O001A2O012O00AA000700053O00123A000600023O00040E3O00BD000100123A000500023O00040E3O0044000100040E3O000E00010026940002008B2O01000100040E3O008B2O0100123A000400014O0057000500053O002681000400292O01000100040E3O00292O01002ECF004B00292O01004C00040E3O00292O01002E05014E00232O01004D00040E3O00232O0100123A000500013O002681000500302O01000100040E3O00302O01002E7B005000302O01004F00040E3O00302O01002E05015200692O01005100040E3O00692O01002EE80054004A2O01005300040E3O004A2O012O00AA000600093O000647000600382O01000100040E3O00382O012O00AA0006000A3O0006220006004A2O013O00040E3O004A2O0100123A000600014O0057000700073O002681000600402O01000100040E3O00402O01002EA1005600402O01005500040E3O00402O01002EE80057003A2O01005800040E3O003A2O012O00AA0008000B4O00260108000100022O000C010700083O000647000700472O01000100040E3O00472O01002EE80059004A2O01005A00040E3O004A2O012O0084000700023O00040E3O004A2O0100040E3O003A2O01002EDA005B001E0001005B00040E3O00682O01002E05015C00682O01005D00040E3O00682O012O00AA0006000C3O000622000600682O013O00040E3O00682O0100123A000600013O002E05015F00522O01005E00040E3O00522O01002694000600522O01000100040E3O00522O012O00AA0007000D3O0020390007000700614O00085O00202O0008000800624O0009000E3O00202O00090009006300122O000A00646O0007000A000200122O000700603O00122O000700603O00062O000700642O01000100040E3O00642O01002EE8006600682O01006500040E3O00682O01001213010700604O0084000700023O00040E3O00682O0100040E3O00522O0100123A000500023O0026810005006D2O01000200040E3O006D2O01002EE80067002A2O01006800040E3O002A2O01002E05016900862O01006A00040E3O00862O012O00AA0006000F3O000622000600862O013O00040E3O00862O0100123A000600013O002694000600732O01000100040E3O00732O012O00AA0007000D3O00203400070007006B4O00085O00202O00080008006C4O0009000E3O00202O00090009006D00122O000A00186O000B00016O0007000B000200122O000700603O00122O000700603O00062O000700862O013O00040E3O00862O01001213010700604O0084000700023O00040E3O00862O0100040E3O00732O0100123A000200023O00040E3O008B2O0100040E3O002A2O0100040E3O008B2O0100040E3O00232O010026810002008F2O01004A00040E3O008F2O01002EE8006E00FA2O01006F00040E3O00FA2O0100123A000400013O002694000400B62O01000200040E3O00B62O01002EDA007000220001007000040E3O00B42O012O00AA00056O0038000600013O00122O000700713O00122O000800726O0006000800024O00050005000600202O0005000500734O00050002000200062O000500B42O013O00040E3O00B42O012O00AA000500024O006E00065O00202O0006000600744O000700086O000900033O00202O0009000900754O000B5O00202O000B000B00744O0009000B00024O000900096O00050009000200062O000500AF2O01000100040E3O00AF2O01002EA1007700AF2O01007600040E3O00AF2O01002EE8007800B42O01007900040E3O00B42O012O00AA000500013O00123A0006007A3O00123A0007007B4O00E9000500074O000100055O00123A000200493O00040E3O00FA2O01002EDA007C00DAFF2O007C00040E3O00902O01000E2E000100902O01000400040E3O00902O0100123A000500013O002694000500F42O01000100040E3O00F42O01002EE8007E00C42O01007D00040E3O00C42O01000647000300C32O01000100040E3O00C32O01002EDA007F00030001008000040E3O00C42O012O0084000300024O00AA00066O0038000700013O00122O000800813O00122O000900826O0007000900024O00060006000700202O0006000600734O00060002000200062O000600F32O013O00040E3O00F32O012O00AA000600043O0020C90006000600834O00085O00202O0008000800844O00060008000200062O000600F32O013O00040E3O00F32O012O00AA00066O00A0000700013O00122O000800853O00122O000900866O0007000900024O00060006000700202O0006000600874O000600020002000E2O000100F32O01000600040E3O00F32O01002EE8008800F32O01008900040E3O00F32O012O00AA000600024O003500075O00202O00070007008A4O000800096O000A00033O00202O000A000A00754O000C5O00202O000C000C008A4O000A000C00024O000A000A6O0006000A000200062O000600F32O013O00040E3O00F32O012O00AA000600013O00123A0007008B3O00123A0008008C4O00E9000600084O000100065O00123A000500023O000E2E000200BB2O01000500040E3O00BB2O0100123A000400023O00040E3O00902O0100040E3O00BB2O0100040E3O00902O01002EE8008D002O0301008E00040E3O002O0301002EDA008F00072O01008F00040E3O002O03010026940002002O0301004900040E3O002O030100123A000400013O002EE8009000050201009100040E3O00050201002681000400070201000100040E3O00070201002EE8009300B90201009200040E3O00B902012O00AA00056O0038000600013O00122O000700943O00122O000800956O0006000800024O00050005000600202O0005000500734O00050002000200062O0005001F02013O00040E3O001F02012O00AA000500103O0020F30005000500964O0005000100024O00068O000700013O00122O000800973O00122O000900986O0007000900024O00060006000700202O0006000600994O00060002000200202O00060006004300062O000500210201000600040E3O00210201002E05019A00350201009B00040E3O003502012O00AA000500024O006E00065O00202O00060006008A4O000700086O000900033O00202O0009000900754O000B5O00202O000B000B008A4O0009000B00024O000900096O00050009000200062O000500300201000100040E3O00300201002E05019C00350201009D00040E3O003502012O00AA000500013O00123A0006009E3O00123A0007009F4O00E9000500074O000100055O002EE800A000B8020100A100040E3O00B802012O00AA000500113O000622000500B802013O00040E3O00B802012O00AA000500123O000622000500B802013O00040E3O00B802012O00AA00056O0038000600013O00122O000700A23O00122O000800A36O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500B802013O00040E3O00B802012O00AA000500134O008E00068O000700013O00122O000800A43O00122O000900A56O0007000900024O00060006000700202O0006000600A64O0006000200024O00078O000800013O00122O000900A73O00122O000A00A86O0008000A00024O00070007000800202O0007000700A64O0007000200024O0006000600074O00078O000800013O00122O000900A93O00122O000A00AA6O0008000A00024O00070007000800202O0007000700A64O000700086O00053O00024O000600146O00078O000800013O00122O000900A43O00122O000A00A56O0008000A00024O00070007000800202O0007000700A64O0007000200024O00088O000900013O00122O000A00A73O00122O000B00A86O0009000B00024O00080008000900202O0008000800A64O0008000200024O0007000700084O00088O000900013O00122O000A00A93O00122O000B00AA6O0009000B00024O00080008000900202O0008000800A64O000800096O00063O00024O000500050006000E2O00AB00B80201000500040E3O00B80201002EE800AC00AA020100AD00040E3O00AA02012O00AA000500153O000622000500AA02013O00040E3O00AA02012O00AA000500043O0020AB0005000500834O00075O00202O0007000700AE4O00050007000200062O0005008E0201000100040E3O008E0201002E05015E009D020100AF00040E3O009D02012O00AA000500024O002901065O00202O0006000600B04O000700076O00050007000200062O000500970201000100040E3O00970201002EE800B200B8020100B100040E3O00B802012O00AA000500013O001224010600B33O00122O000700B46O000500076O00055O00044O00B802012O00AA000500024O00A400065O00202O0006000600B54O000700076O00050007000200062O000500B802013O00040E3O00B802012O00AA000500013O001224010600B63O00122O000700B76O000500076O00055O00044O00B802012O00AA000500024O002901065O00202O0006000600B04O000700076O00050007000200062O000500B30201000100040E3O00B30201002E0501B800B8020100B900040E3O00B802012O00AA000500013O00123A000600BA3O00123A000700BB4O00E9000500074O000100055O00123A000400023O002681000400BD0201000200040E3O00BD0201002E0501BC0001020100BD00040E3O00010201002EDA00BE0043000100BE00040E4O000301002E0501BF2O00030100C000040E4O0003012O00AA00056O0038000600013O00122O000700C13O00122O000800C26O0006000800024O00050005000600202O00050005000D4O00050002000200062O00052O0003013O00040E4O0003012O00AA00056O00F7000600013O00122O000700C33O00122O000800C46O0006000800024O00050005000600202O0005000500104O00050002000200062O00052O000301000100040E4O0003012O00AA000500043O0020650005000500254O00075O00202O0007000700264O0005000700024O000600043O00202O00060006002700122O000800026O00060008000200062O00062O000301000500040E4O00030100123A000500013O002681000500E50201000100040E3O00E50201002E0501C500E1020100C600040E3O00E1020100123A000600024O00A3000600063O002EDA00C70019000100C700040E4O000301002EE800C92O00030100C800040E4O0003012O00AA000600074O00BA00075O00202O00070007002E4O00085O00122O000900CA6O000A00033O00202O000A000A001700122O000C002F6O000A000C00024O000A000A6O000B000B6O0006000B000200062O00062O0003013O00040E4O0003012O00AA000600013O001224010700CB3O00122O000800CC6O000600086O00065O00045O00030100040E3O00E1020100123A000200073O00040E3O002O030100040E3O00010201002681000200070301004300040E3O00070301002E0501CE008A030100CD00040E3O008A030100123A000400013O000E2E000200360301000400040E3O00360301002E0501CF0034030100B100040E3O003403012O00AA000500113O0006220005003403013O00040E3O003403012O00AA00056O0038000600013O00122O000700D03O00122O000800D16O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005003403013O00040E3O003403012O00AA00056O00E6000600013O00122O000700D23O00122O000800D36O0006000800024O00050005000600202O0005000500A64O0005000200024O000600043O00202O0006000600D44O0006000200020006E0000500340301000600040E3O003403012O00AA000500024O002901065O00202O0006000600D54O000700076O00050007000200062O0005002F0301000100040E3O002F0301002EDA00D60007000100D700040E3O003403012O00AA000500013O00123A000600D83O00123A000700D94O00E9000500074O000100055O00123A000200483O00040E3O008A03010026810004003C0301000100040E3O003C0301002E7B00DB003C030100DA00040E3O003C0301002E0501DC0008030100DD00040E3O000803012O00AA00056O0038000600013O00122O000700DE3O00122O000800DF6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005005603013O00040E3O005603012O00AA000500043O0020270005000500E02O00FD0005000200022O00AA000600163O0006E0000500560301000600040E3O005603012O00AA000500173O0006220005005603013O00040E3O005603012O00AA000500043O0020AB0005000500E14O00075O00202O0007000700E24O00050007000200062O0005005A0301000100040E3O005A0301002E7B00E3005A030100E400040E3O005A0301002E0501E50066030100E600040E3O006603012O00AA000500024O00A400065O00202O0006000600E24O000700086O00050008000200062O0005006603013O00040E3O006603012O00AA000500013O00123A000600E73O00123A000700E84O00E9000500074O000100056O00AA00056O0038000600013O00122O000700E93O00122O000800EA6O0006000800024O00050005000600202O0005000500734O00050002000200062O0005007803013O00040E3O007803012O00AA000500043O0020F20005000500EB4O00075O00202O00070007002600122O000800426O00050008000200062O0005007C0301000100040E3O007C0301002E7B00EC007C030100ED00040E3O007C0301002E0501EE0088030100EF00040E3O008803012O00AA000500024O00A400065O00202O0006000600F04O000700076O00050007000200062O0005008803013O00040E3O008803012O00AA000500013O00123A000600F13O00123A000700F24O00E9000500074O000100055O00123A000400023O00040E3O00080301002681000200900301000200040E3O00900301002E7B00090090030100F300040E3O00900301002EE800F40013040100F500040E3O001304012O00AA000400183O000622000400B303013O00040E3O00B30301001213010400F66O0004000100024O000500196O0004000400054O0005001A3O00062O0005009C0301000400040E3O009C0301002EE800F700B3030100F800040E3O00B303012O00AA00046O0038000500013O00122O000600F93O00122O000700FA6O0005000700024O00040004000500202O0004000400734O00040002000200062O000400B303013O00040E3O00B303012O00AA0004001B4O00AA00055O0020060005000500B52O00FD000400020002000647000400AE0301000100040E3O00AE0301002EDA00FB0007000100FC00040E3O00B303012O00AA000400013O00123A000500FD3O00123A000600FE4O00E9000400064O000100046O00AA0004001C3O000622000400BB03013O00040E3O00BB03012O00AA000400043O0020270004000400FF2O00FD000400020002000647000400BE0301000100040E3O00BE030100123A0004002O012O000E2E2O0001EA0301000400040E3O00EA030100123A000400014O0057000500063O00123A00070002012O00123A00080003012O0006E0000800CE0301000700040E3O00CE030100123A00070004012O00123A00080005012O0006E0000800CE0301000700040E3O00CE030100123A000700013O0006AF000700CE0301000400040E3O00CE030100123A000500014O0057000600063O00123A000400023O00123A000700023O0006AF000400C00301000700040E3O00C0030100123A00070006012O00123A00080007012O0006E0000800D10301000700040E3O00D1030100123A000700013O000643000500DC0301000700040E3O00DC030100123A00070008012O00123A00080009012O0006E0000800D10301000700040E3O00D103012O00AA0007001D4O00B50007000100024O000600073O00122O0007000A012O00122O0008000B012O00062O000800EA0301000700040E3O00EA0301000622000600EA03013O00040E3O00EA03012O0084000600023O00040E3O00EA030100040E3O00D1030100040E3O00EA030100040E3O00C0030100123A0004000C012O00123A0005008E3O00061B000500120401000400040E3O001204012O00AA00046O0038000500013O00122O0006000D012O00122O0007000E015O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004001204013O00040E3O001204012O00AA000400043O0020270004000400E02O00FD0004000200022O00AA0005001E3O0006E0000400120401000500040E3O001204012O00AA0004001F3O0006220004001204013O00040E3O0012040100123A0004000F012O00123A00050010012O00061B000400120401000500040E3O001204012O00AA000400024O005F00055O00122O00060011015O0005000500064O000600076O00040007000200062O0004001204013O00040E3O001204012O00AA000400013O00123A00050012012O00123A00060013013O00E9000400064O000100045O00123A000200433O00123A00040014012O00123A00050015012O0006E0000400400501000500040E3O0040050100123A000400423O0006AF000200400501000400040E3O0040050100123A000400014O0057000500053O00123A000600013O000643000400230401000600040E3O0023040100123A00060016012O00123A00070017012O00061B0007001C0401000600040E3O001C040100123A000500013O00123A000600023O0006430005002B0401000600040E3O002B040100123A00060018012O00123A00070019012O00061B0006004E0401000700040E3O004E04012O00AA0006000D3O0012880007001A015O0006000600074O00078O000800013O00122O0009001B012O00122O000A001C015O0008000A00024O00070007000800202O0007000700874O00070002000200123A000800013O000620010800490401000700040E3O004904012O00AA00076O008B000800013O00122O0009001D012O00122O000A001E015O0008000A00024O00070007000800202O0007000700A64O00070002000200122O000800183O00062O000800490401000700040E3O004904012O00AA000700203O00123A000800183O000620010700490401000800040E3O004904012O00DB00076O0055000700014O00FD0006000200022O000C010300063O00123A0002004A3O00040E3O0040050100123A0006001F012O00123A00070020012O00061B000700240401000600040E3O0024040100123A000600013O0006AF000600240401000500040E3O0024040100123A000600013O00123A00070021012O00123A00080022012O00061B0007005F0401000800040E3O005F040100123A000700023O0006AF0006005F0401000700040E3O005F040100123A000500023O00040E3O0024040100123A000700013O0006AF000600560401000700040E3O005604012O00AA000700113O000622000700C804013O00040E3O00C804012O00AA00076O0038000800013O00122O00090023012O00122O000A0024015O0008000A00024O00070007000800202O00070007000D4O00070002000200062O000700C804013O00040E3O00C804012O00AA000700043O0020AB0007000700834O00095O00202O0009000900264O00070009000200062O000700810401000100040E3O008104012O00AA00076O0028000800013O00122O00090025012O00122O000A0026015O0008000A00024O00070007000800202O0007000700A64O00070002000200122O000800423O00062O000700C80401000800040E3O00C8040100123A00070027012O00123A00080028012O0006E0000700A20401000800040E3O00A204012O00AA000700214O0034010800013O00122O00090029012O00122O000A002A015O0008000A000200062O000700A20401000800040E3O00A2040100123A0007002B012O00123A0008002C012O0006E0000700C80401000800040E3O00C804012O00AA0007001B4O00040008000E3O00122O0009002D015O0008000800094O000900033O00202O00090009001700122O000B00186O0009000B00024O000900096O00070009000200062O000700C804013O00040E3O00C804012O00AA000700013O0012240108002E012O00122O0009002F015O000700096O00075O00044O00C8040100123A00070030012O00123A00080031012O00061B000800AE0401000700040E3O00AE04012O00AA000700214O008C000800013O00122O00090032012O00122O000A0033015O0008000A000200062O000700AE0401000800040E3O00AE040100040E3O00C804012O00AA000700024O004F00085O00122O00090034015O0008000800094O0009000A6O000B00033O00202O000B000B001700122O000D00186O000B000D00024O000B000B6O0007000B000200062O000700C30401000100040E3O00C3040100123A00070035012O00123A00080036012O000643000700C30401000800040E3O00C3040100123A00070037012O00123A00080038012O0006AF000700C80401000800040E3O00C804012O00AA000700013O00123A00080039012O00123A0009003A013O00E9000700094O000100076O00AA00076O008B000800013O00122O0009003B012O00122O000A003C015O0008000A00024O00070007000800202O0007000700874O00070002000200122O000800013O00062O000800DE0401000700040E3O00DE04012O00AA00076O0028000800013O00122O0009003D012O00122O000A003E015O0008000A00024O00070007000800202O0007000700A64O00070002000200122O000800183O00062O000800E50401000700040E3O00E504012O00AA000700214O0034010800013O00122O0009003F012O00122O000A0040015O0008000A000200062O000700F70401000800040E3O00F704012O00AA000700203O00123A000800183O000620010700F70401000800040E3O00F704012O00AA000700043O0020C90007000700834O00095O00202O0009000900264O00070009000200062O0007003B05013O00040E3O003B05012O00AA000700214O0034010800013O00122O00090041012O00122O000A0042015O0008000A000200062O0007003B0501000800040E3O003B050100123A000700013O00123A000800013O000643000700FF0401000800040E3O00FF040100123A00080043012O00123A00090044012O0006AF000800240501000900040E3O0024050100123A000800013O00123A000900023O000643000900070501000800040E3O0007050100123A00090045012O00123A000A0046012O0006E0000A00090501000900040E3O0009050100123A000700023O00040E3O0024050100123A00090047012O00123A000A0048012O00061B000A2O000501000900040E4O00050100123A00090049012O00123A000A00EE3O0006E000092O000501000A00040E4O00050100123A000900013O0006AF00082O000501000900040E4O0005012O00AA0009000D3O00123A010A004A015O00090009000A4O000A00226O000B00113O00122O000C00646O000D000D6O0009000D000200122O000900603O00122O000900603O00062O0009002205013O00040E3O00220501001213010900604O0084000900023O00123A000800023O00040E4O00050100123A000800023O0006AF000700F80401000800040E3O00F804012O00AA0008000D3O0012380109004B015O0008000800094O000900226O000A00113O00122O000B00646O000C000C6O0008000C000200122O000800603O00122O000800603O00062O000800370501000100040E3O0037050100123A0008004C012O00123A0009004D012O0006AF0008003B0501000900040E3O003B0501001213010800604O0084000800023O00040E3O003B050100040E3O00F8040100123A000600023O00040E3O0056040100040E3O0024040100040E3O0040050100040E3O001C040100123A0004004E012O00123A0005004F012O00061B000400470501000500040E3O0047050100123A0004001B3O0006430002004B0501000400040E3O004B050100123A00040050012O00123A00050051012O0006AF000400F10501000500040E3O00F1050100123A00040052012O00123A00050053012O0006E0000500980501000400040E3O009805012O00AA00046O0038000500013O00122O00060054012O00122O00070055015O0005000700024O00040004000500202O0004000400734O00040002000200062O0004009805013O00040E3O009805012O00AA000400043O0020E70004000400254O00065O00202O0006000600264O0004000600024O00058O000600013O00122O00070056012O00122O00080057015O0006000800024O00050005000600202O0005000500994O00050002000200062O0005007E0501000400040E3O007E05012O00AA000400043O00122E01060058015O0004000400064O0004000200024O00058O000600013O00122O00070059012O00122O0008005A015O0006000800024O00050005000600202O0005000500994O00050002000200062O0004007E0501000500040E3O007E05012O00AA000400043O0020560004000400834O00065O00122O0007005B015O0006000600074O00040006000200062O0004009805013O00040E3O009805012O00AA000400024O004F00055O00122O0006005C015O0005000500064O000600076O000800033O00202O00080008001700122O000A002F6O0008000A00024O000800086O00040008000200062O000400930501000100040E3O0093050100123A0004005D012O00123A0005005E012O000620010500930501000400040E3O0093050100123A0004005F012O00123A00050060012O0006E0000500980501000400040E3O009805012O00AA000400013O00123A00050061012O00123A00060062013O00E9000400064O000100046O00AA00046O0038000500013O00122O00060063012O00122O00070064015O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400C405013O00040E3O00C405012O00AA000400043O00123A00060065013O00C20004000400062O00FD000400020002000622000400B205013O00040E3O00B205012O00AA00046O0038000500013O00122O00060066012O00122O00070067015O0005000700024O00040004000500202O0004000400104O00040002000200062O000400C405013O00040E3O00C405012O00AA000400024O003500055O00202O00050005008A4O000600076O000800033O00202O0008000800754O000A5O00202O000A000A008A4O0008000A00024O000800086O00040008000200062O000400C405013O00040E3O00C405012O00AA000400013O00123A00050068012O00123A00060069013O00E9000400064O000100046O00AA00046O0038000500013O00122O0006006A012O00122O0007006B015O0005000700024O00040004000500202O00040004000D4O00040002000200062O000400D805013O00040E3O00D805012O00AA00046O0038000500013O00122O0006006C012O00122O0007006D015O0005000700024O00040004000500202O0004000400104O00040002000200062O000400DC05013O00040E3O00DC050100123A0004006E012O00123A0005006F012O00061B000400A00701000500040E3O00A007012O00AA000400024O009700055O00122O00060070015O0005000500064O000600076O000800033O00202O0008000800754O000A5O00122O000B0070015O000A000A000B4O0008000A00024O000800086O00040008000200062O000400A007013O00040E3O00A007012O00AA000400013O00122401050071012O00122O00060072015O000400066O00045O00044O00A0070100123A00040073012O00123A00050073012O0006AF000400F80501000500040E3O00F8050100123A000400483O000643000200FC0501000400040E3O00FC050100123A00040074012O00123A00050075012O00061B0004000B0001000500040E3O000B000100123A000400013O00123A000500023O000643000500040601000400040E3O0004060100123A00050076012O00123A00060077012O0006E0000600730601000500040E3O007306012O00AA00056O0038000600013O00122O00070078012O00122O00080079015O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005003B06013O00040E3O003B06012O00AA00056O0038000600013O00122O0007007A012O00122O0008007B015O0006000800024O00050005000600202O0005000500104O00050002000200062O0005003B06013O00040E3O003B06012O00AA00056O00F7000600013O00122O0007007C012O00122O0008007D015O0006000800024O00050005000600202O0005000500104O00050002000200062O0005003B0601000100040E3O003B06012O00AA00056O009A000600013O00122O0007007E012O00122O0008007F015O0006000800024O00050005000600202O0005000500A64O0005000200024O000600043O00202O00060006002700122O000800026O00060008000200062O0005003B0601000600040E3O003B06012O00AA000500043O0020EF0005000500254O00075O00202O0007000700264O0005000700024O000600043O00202O00060006002700122O000800026O00060008000200062O0006003F0601000500040E3O003F060100123A00050044012O00123A00060080012O0006AF000500710601000600040E3O0071060100123A000500014O0057000600063O00123A00070081012O00123A00080082012O0006E0000800480601000700040E3O0048060100123A000700013O0006430005004C0601000700040E3O004C060100123A00070083012O00123A00080084012O00061B000700410601000800040E3O0041060100123A000600013O00123A000700013O000643000600540601000700040E3O0054060100123A00070085012O00123A00080086012O0006E00008004D0601000700040E3O004D060100123A000700024O00A3000700083O00123A00070087012O00123A00080087012O0006AF000700710601000800040E3O007106012O00AA000700074O00BA00085O00202O00080008003A4O00095O00122O000A00CA6O000B00033O00202O000B000B001700122O000D002F6O000B000D00024O000B000B6O000C000C6O0007000C000200062O0007007106013O00040E3O007106012O00AA000700013O00122401080088012O00122O00090089015O000700096O00075O00044O0071060100040E3O004D060100040E3O0071060100040E3O0041060100123A000200423O00040E3O000B000100123A000500013O0006430004007E0601000500040E3O007E060100123A0005008A012O00123A0006008B012O0006E4000500050001000600040E3O007E060100123A0005008C012O00123A0006008D012O0006E0000600FD0501000500040E3O00FD05012O00AA00056O0038000600013O00122O0007008E012O00122O0008008F015O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500BF06013O00040E3O00BF06012O00AA00056O00F7000600013O00122O00070090012O00122O00080091015O0006000800024O00050005000600202O0005000500104O00050002000200062O000500BF0601000100040E3O00BF06012O00AA00056O0038000600013O00122O00070092012O00122O00080093015O0006000800024O00050005000600202O0005000500104O00050002000200062O000500BF06013O00040E3O00BF06012O00AA00056O00F7000600013O00122O00070094012O00122O00080095015O0006000800024O00050005000600202O0005000500104O00050002000200062O000500BF0601000100040E3O00BF06012O00AA00056O009A000600013O00122O00070096012O00122O00080097015O0006000800024O00050005000600202O0005000500A64O0005000200024O000600043O00202O00060006002700122O000800026O00060008000200062O000500BF0601000600040E3O00BF06012O00AA000500043O0020EF0005000500254O00075O00202O0007000700264O0005000700024O000600043O00202O00060006002700122O000800026O00060008000200062O000600C30601000500040E3O00C3060100123A00050098012O00123A00060099012O00061B000500040701000600040E3O0004070100123A000500014O0057000600073O00123A000800013O0006AF000800CB0601000500040E3O00CB060100123A000600014O0057000700073O00123A000500023O00123A0008009A012O00123A0009009B012O00061B000900D20601000800040E3O00D2060100123A000800023O000643000500D60601000800040E3O00D6060100123A0008009C012O00123A0009009D012O00061B000800C50601000900040E3O00C5060100123A0008009E012O00123A0009009E012O0006AF000800D60601000900040E3O00D6060100123A000800013O0006AF000600D60601000800040E3O00D6060100123A000700013O00123A0008009F012O00123A000900A0012O0006E0000800E50601000900040E3O00E5060100123A000800013O000643000700E90601000800040E3O00E9060100123A000800A1012O00123A000900A2012O0006E0000900DE0601000800040E3O00DE060100123A000800024O00B6000800066O000800076O00095O00202O00090009002E4O000A5O00122O000B00CA6O000C00033O00202O000C000C001700122O000E002F6O000C000E00024O000C000C6O000D000D6O0008000D000200062O0008000407013O00040E3O000407012O00AA000800013O001224010900A3012O00122O000A00A4015O0008000A6O00085O00044O0004070100040E3O00DE060100040E3O0004070100040E3O00D6060100040E3O0004070100040E3O00C506012O00AA00056O0038000600013O00122O000700A5012O00122O000800A6015O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005004507013O00040E3O004507012O00AA00056O0038000600013O00122O000700A7012O00122O000800A8015O0006000800024O00050005000600202O0005000500104O00050002000200062O0005004507013O00040E3O004507012O00AA00056O0038000600013O00122O000700A9012O00122O000800AA015O0006000800024O00050005000600202O0005000500104O00050002000200062O0005004507013O00040E3O004507012O00AA00056O00F7000600013O00122O000700AB012O00122O000800AC015O0006000800024O00050005000600202O0005000500104O00050002000200062O000500450701000100040E3O004507012O00AA00056O00DE000600013O00122O000700AD012O00122O000800AE015O0006000800024O00050005000600202O0005000500A64O0005000200024O000600043O00202O0006000600274O000800054O002B00060008000200061B000500450701000600040E3O004507012O00AA000500043O0020D90005000500254O00075O00202O0007000700264O0005000700024O000600043O00202O0006000600274O000800056O00060008000200062O0006004D0701000500040E3O004D070100123A000500AF012O00123A000600B0012O0006E4000500050001000600040E3O004D070100123A000500B1012O00123A000600B2012O0006AF000500850701000600040E3O0085070100123A000500014O0057000600063O00123A000700013O0006AF0007004F0701000500040E3O004F070100123A000600013O00123A000700B3012O00123A000800B4012O0006E0000800530701000700040E3O0053070100123A000700B5012O00123A000800B6012O00061B000800530701000700040E3O0053070100123A000700013O0006AF000700530701000600040E3O005307012O00AA000700054O00A3000700063O00123A000700B7012O00123A000800B8012O00061B000700850701000800040E3O0085070100123A000700B9012O00123A000800BA012O0006E0000700850701000800040E3O008507012O00AA000700074O001001085O00202O00080008002E4O00098O000A00056O000B00033O00202O000B000B001700122O000D002F6O000B000D00024O000B000B6O000C000C6O0007000C000200062O0007008507013O00040E3O008507012O00AA000700013O0012C6000800BB012O00122O000900BC015O0007000900024O000800056O000900013O00122O000A00BD012O00122O000B00BE015O0009000B00024O0007000700094O000700023O00044O0085070100040E3O0053070100040E3O0085070100040E3O004F070100123A000400023O00040E3O00FD050100040E3O000B000100040E3O00A0070100123A000400013O000643000400900701000100040E3O0090070100123A000400BF012O00123A000500C0012O00061B000400050001000500040E3O0005000100123A000200014O0057000300033O00123A000100023O00040E3O0005000100040E3O00A0070100123A000400C1012O00123A000500C2012O00061B000400020001000500040E3O0002000100123A000400013O0006AF3O00020001000400040E3O0002000100123A000100014O0057000200023O00123A3O00023O00040E3O000200012O006D3O00017O0002012O00028O00025O00207640025O00F89740026O00F03F025O0068AD40025O000CB340025O008AA440025O00707E40026O002040025O00B8AC40025O00F88540025O0014B140025O00B2A640025O00B89140025O00088040027O0040025O00C6AD40025O00F07340025O00D2AA40025O00ECA340030C3O004570696353652O74696E677303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA103103O0018FF2EF207CA873FD822D70DEF8924FC03073O00E24D8C4BBA68BC03083O008ACBC42B46B7C9C303053O002FD9AEB05F030B3O008DCE7336BB597D15B3D46603083O0046D8BD1662D23418025O00707940025O00349F40025O00804740025O00089140025O006C9540025O00A8A64003083O003B390E540D03FA1B03073O009D685C7A20646D03103O008CA4DCC3392E8CA590A5CEC63834A59B03083O00CBC3C6AFAA5D47ED03083O001D4E2AC1581FFB3D03073O009C4E2B5EB5317103113O0050FAC1A21F4B7674CDCBAD18766A73EFC103073O00191288A4C36B23034O00025O00989140025O00807F40025O00BC9640025O0032A040026O002240026O001840025O0022AB40025O00E2B140025O0028AD40025O0020684003083O006DC4BF32C650C6B803053O00AF3EA1CB4603163O0015D3D716272EC8D3071A32D1DA243D35C9C61F3C2FC903053O00555CBDA37303083O001AA9242C20A2372B03043O005849CC5003123O00078D04433BC83B93047221C82B90184925DE03063O00BA4EE370264903083O00795D9CF643568FF103043O00822A38E803113O00C2B42AE74C3AC3BB27EC522FE5A721E24C03063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C12303113O000577F05D3E6BF148384EED4C244AF04D2203043O00384C1984026O001C40025O00AEA340025O00F2A84003083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC030F3O000C57D9A7F974083246D99AFB70086F03073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A351030F3O002A5026B03C40E00019470DA2324CB103083O006E7A2243C35F298503083O0046B44F5EDF7BB64803053O00B615D13B2A03133O008152D71920B0A372C81F33BFB452F00E20B9B203063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03133O00808700DC787AA1A809C16A65AA8730DD7871A003063O0016C5EA65AE19026O00084003083O00C2EF38A22CFFED3F03053O0045918A4CD6030F3O0040DD8C9ABC1F75C18A8C91177DCAD803063O007610AF2OE9DF03083O00B88121AFE7857A9803073O001DEBE455DB8EEB030F3O000DC6BFCE7447225C3ED194DC7A4B7503083O00325DB4DABD172E47025O00F07C40025O0049B340025O002EAF40025O005CAD40025O0023B140025O00F8A140025O0020AA40025O00D2A94003083O00F871D1235B2D1ED803073O0079AB14A557324303113O00F537AC24BA07E93E9437BE0BC516B83BBC03063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E6030F3O00EA9B5A110FE4DF875C0739FEDB8E5A03063O008DBAE93F626C025O008AA640025O00149E40025O00CDB040025O00C8A44003083O00E9DAB793DAD4D8B003053O00B3BABFC3E703083O00CC2C1DCCF6291DF603043O0084995F7803083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA03093O00C80C34ECEDF0E90E2703063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E989030E3O0095B2A91B9BFFF9BDB6920C89F4F503073O0090D9D3C77FE893025O00BEB140025O00E89840025O00207540025O0062AB4003083O00CF52E9415A74FB4403063O001A9C379D353303113O00B9CB13F6A8409EDD05CAB15E8BEA19D8AA03063O0030ECB876B9D803083O00D6B84324C63AE2AE03063O005485DD3750AF03103O0088F42194C252B8F02DA8C07EB1E63EA303063O003CDD8744C6A7025O00D89840025O000AA840025O00405140026O008540026O00774003083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030F3O006AC059FF543AF95FE75BFB5936DF6803073O009738A5379A235303083O00934611FAA94D02FD03043O008EC0236503113O00E3662C8CE59FA512DF742790E48DA013C503083O0076B61549C387ECCC025O00D88F40025O000BB040025O0014904003083O00305AD7EF0A51C4E803043O009B633FA303153O00A0DDA89EAD8190D8AF2O8A8783DDA49E8C9783D6A403063O00E4E2B1C1EDD903083O0007B537F23DBE24F503043O008654D04303173O0031A08F4F07A994551DABB55F12A0834F21A9804E16BF8E03043O003C73CCE603083O00D43FFF64EE34EC6303043O0010875A8B03143O0076780F205A516A5D7A01004D557451672832435103073O0018341466532E3403013O003003083O00F72A353006CA283203053O006FA44F414403123O00F5D696CC2DEFE9DFAEDF29E3C5EC90DF29EF03063O008AA6B9E3BE4E025O00207240025O0074A54003083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB703103O00CF11D4F88DAFE410F416D4FD8FA4D80503083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD38403103O0010807E4DD3A3B0FA3982684CDDA29CE803083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F683969030A3O003E94A1760A84AD45079403043O00246BE7C403083O006EB0B69354BBA59403043O00E73DD5C203103O003CBE385B0CAC317A07AA0D7C1DA4327D03043O001369CD5D026O001040025O000C9E40025O00F9B140025O00CC9C40025O0048AE40025O006BB240025O00189240025O00149F40025O00EAAE40025O0066A040025O00B4A840025O0007B04003083O009A0DCA9536A70FCD03053O005FC968BEE103113O0087CEC0C2A6C5C6FEA0DFC8C1A1E5C0C3AA03043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D9398030F3O00040CE7002507E13C231DEF032221D603043O006C4C6986025O004CAF40025O00288740026O001440025O006EA240025O002AAD40025O005EA940025O0030B140025O0062AD40025O0072A540025O00F4B140025O00C4A24003083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103163O0096A0E7E3CA06636BAABDE5EEC037787D81A1EDCFDC0603083O0018C3D382A1A6631003083O007506FD385A18411003063O00762663894C33030D3O00D92F16020C2CD9232O070F26EE03063O00409D46657269025O003CA040025O0060644003083O0073ADB3F7194EAFB403053O007020C8C783030B3O0008594FA8C6A70039565AAB03073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE030E3O0098395664B3AC264744A5B9255D4903053O00D6CD4A332C025O00208840025O0050B040025O0014B040025O00088740025O009CA540025O00708440025O005C9240025O00D4AF4003083O00C949F6E87EF44BF103053O00179A2C829C030D3O0039A3ACA2221B02B2A2A0333B2103063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E030F3O009C88DE2A30A814B28FDC273FB930B003073O0055D4E9B04E5CCD001B032O00123A3O00014O0057000100023O0026813O00060001000100040E3O00060001002E05010300090001000200040E3O0009000100123A000100014O0057000200023O00123A3O00043O0026943O00020001000400040E3O000200010026810001000F0001000100040E3O000F0001002E050106000B0001000500040E3O000B000100123A000200013O002EE8000800800001000700040E3O00800001002694000200800001000900040E3O0080000100123A000300014O0057000400043O002694000300160001000100040E3O0016000100123A000400013O002E05010B001D0001000A00040E3O001D00010026810004001F0001000400040E3O001F0001002EE8000C00460001000D00040E3O0046000100123A000500013O002EE8000F00260001000E00040E3O00260001002694000500260001000400040E3O0026000100123A000400103O00040E3O00460001002EE80012002A0001001100040E3O002A0001000E920001002C0001000500040E3O002C0001002EDA001300F6FF2O001400040E3O00200001001213010600154O0083000700013O00122O000800163O00122O000900176O0007000900024O0006000600074O000700013O00122O000800183O00122O000900196O0007000900024O0006000600074O00065O00122O000600156O000700013O00122O0008001A3O00122O0009001B6O0007000900024O0006000600074O000700013O00122O0008001C3O00122O0009001D6O0007000900024O0006000600074O000600023O00122O000500043O00040E3O00200001002E05011E00790001001F00040E3O00790001002EE8002000790001002100040E3O00790001000E2E000100790001000400040E3O0079000100123A000500013O002681000500510001000100040E3O00510001002E05012300700001002200040E3O00700001001213010600154O0007010700013O00122O000800243O00122O000900256O0007000900024O0006000600074O000700013O00122O000800263O00122O000900276O0007000900024O00060006000700062O0006005F0001000100040E3O005F000100123A000600014O00A3000600033O0012DF000600156O000700013O00122O000800283O00122O000900296O0007000900024O0006000600074O000700013O00122O0008002A3O00122O0009002B6O0007000900024O00060006000700062O0006006E0001000100040E3O006E000100123A0006002C4O00A3000600043O00123A000500043O002681000500760001000400040E3O00760001002E7B002D00760001002E00040E3O00760001002E050130004D0001002F00040E3O004D000100123A000400043O00040E3O0079000100040E3O004D0001002694000400190001001000040E3O0019000100123A000200313O00040E3O0080000100040E3O0019000100040E3O0080000100040E3O00160001002681000200840001003200040E3O00840001002EE8003400CB0001003300040E3O00CB000100123A000300014O0057000400043O002694000300860001000100040E3O0086000100123A000400013O0026810004008D0001000400040E3O008D0001002EDA0035001E0001003600040E3O00A90001001213010500154O0016010600013O00122O000700373O00122O000800386O0006000800024O0005000500064O000600013O00122O000700393O00122O0008003A6O0006000800024O0005000500064O000500053O00122O000500156O000600013O00122O0007003B3O00122O0008003C6O0006000800024O0005000500064O000600013O00122O0007003D3O00122O0008003E6O0006000800024O00050005000600062O000500A70001000100040E3O00A7000100123A000500014O00A3000500063O00123A000400103O002694000400C40001000100040E3O00C40001001213010500154O0083000600013O00122O0007003F3O00122O000800406O0006000800024O0005000500064O000600013O00122O000700413O00122O000800426O0006000800024O0005000500064O000500073O00122O000500156O000600013O00122O000700433O00122O000800446O0006000800024O0005000500064O000600013O00122O000700453O00122O000800466O0006000800024O0005000500064O000500083O00122O000400043O002694000400890001001000040E3O0089000100123A000200473O00040E3O00CB000100040E3O0089000100040E3O00CB000100040E3O00860001002EE80048000C2O01004900040E3O000C2O010026940002000C2O01001000040E3O000C2O01001213010300154O0007010400013O00122O0005004A3O00122O0006004B6O0004000600024O0003000300044O000400013O00122O0005004C3O00122O0006004D6O0004000600024O00030003000400062O000300DD0001000100040E3O00DD000100123A0003002C4O00A3000300093O0012DF000300156O000400013O00122O0005004E3O00122O0006004F6O0004000600024O0003000300044O000400013O00122O000500503O00122O000600516O0004000600024O00030003000400062O000300EC0001000100040E3O00EC000100123A0003002C4O00A30003000A3O0012DF000300156O000400013O00122O000500523O00122O000600536O0004000600024O0003000300044O000400013O00122O000500543O00122O000600556O0004000600024O00030003000400062O000300FB0001000100040E3O00FB000100123A0003002C4O00A30003000B3O0012DF000300156O000400013O00122O000500563O00122O000600576O0004000600024O0003000300044O000400013O00122O000500583O00122O000600596O0004000600024O00030003000400062O0003000A2O01000100040E3O000A2O0100123A0003002C4O00A30003000C3O00123A0002005A3O002694000200662O01000400040E3O00662O0100123A000300013O000E2E000400302O01000300040E3O00302O01001213010400154O0007010500013O00122O0006005B3O00122O0007005C6O0005000700024O0004000400054O000500013O00122O0006005D3O00122O0007005E6O0005000700024O00040004000500062O0004001F2O01000100040E3O001F2O0100123A0004002C4O00A30004000D3O0012DF000400156O000500013O00122O0006005F3O00122O000700606O0005000700024O0004000400054O000500013O00122O000600613O00122O000700626O0005000700024O00040004000500062O0004002E2O01000100040E3O002E2O0100123A0004002C4O00A30004000E3O00123A000300103O000E92001000342O01000300040E3O00342O01002E05016400362O01006300040E3O00362O0100123A000200103O00040E3O00662O010026810003003A2O01000100040E3O003A2O01002E050165000F2O01006600040E3O000F2O0100123A000400013O0026810004003F2O01000400040E3O003F2O01002E05016700412O01006800040E3O00412O0100123A000300043O00040E3O000F2O01002E05016A003B2O01006900040E3O003B2O010026940004003B2O01000100040E3O003B2O01001213010500154O0007010600013O00122O0007006B3O00122O0008006C6O0006000800024O0005000500064O000600013O00122O0007006D3O00122O0008006E6O0006000800024O00050005000600062O000500532O01000100040E3O00532O0100123A0005002C4O00A30005000F3O0012DF000500156O000600013O00122O0007006F3O00122O000800706O0006000800024O0005000500064O000600013O00122O000700713O00122O000800726O0006000800024O00050005000600062O000500622O01000100040E3O00622O0100123A0005002C4O00A3000500103O00123A000400043O00040E3O003B2O0100040E3O000F2O010026810002006C2O01003100040E3O006C2O01002EA10073006C2O01007400040E3O006C2O01002EDA0075002D0001007600040E3O00972O01001213010300154O0016010400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000300113O00122O000300156O000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400062O000300862O01000100040E3O00862O0100123A000300014O00A3000300123O0012DF000300156O000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O00030003000400062O000300952O01000100040E3O00952O0100123A0003002C4O00A3000300133O00040E3O001A03010026810002009B2O01004700040E3O009B2O01002E05018300E22O01008400040E3O00E22O0100123A000300013O002E05018500B92O01008600040E3O00B92O01002694000300B92O01000100040E3O00B92O01001213010400154O0083000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400054O000400143O00122O000400156O000500013O00122O0006008B3O00122O0007008C6O0005000700024O0004000400054O000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400054O000400153O00122O000300043O002E05018F00C12O01009000040E3O00C12O01002EDA009100060001009100040E3O00C12O01002694000300C12O01001000040E3O00C12O0100123A000200093O00040E3O00E22O01002681000300C52O01000400040E3O00C52O01002EDA009200D9FF2O009300040E3O009C2O01001213010400154O0007010500013O00122O000600943O00122O000700956O0005000700024O0004000400054O000500013O00122O000600963O00122O000700976O0005000700024O00040004000500062O000400D32O01000100040E3O00D32O0100123A000400014O00A3000400163O00121D010400156O000500013O00122O000600983O00122O000700996O0005000700024O0004000400054O000500013O00122O0006009A3O00122O0007009B6O0005000700022O00BD0004000400052O00A3000400173O00123A000300103O00040E3O009C2O01002EDA009C00040001009C00040E3O00E62O01002681000200E82O01000100040E3O00E82O01002E05019D00250201009E00040E3O00250201001213010300154O0007010400013O00122O0005009F3O00122O000600A06O0004000600024O0003000300044O000400013O00122O000500A13O00122O000600A26O0004000600024O00030003000400062O000300F62O01000100040E3O00F62O0100123A0003002C4O00A3000300183O0012DF000300156O000400013O00122O000500A33O00122O000600A46O0004000600024O0003000300044O000400013O00122O000500A53O00122O000600A66O0004000600024O00030003000400062O000300050201000100040E3O0005020100123A000300014O00A3000300193O0012DF000300156O000400013O00122O000500A73O00122O000600A86O0004000600024O0003000300044O000400013O00122O000500A93O00122O000600AA6O0004000600024O00030003000400062O000300140201000100040E3O0014020100123A000300AB4O00A30003001A3O0012DF000300156O000400013O00122O000500AC3O00122O000600AD6O0004000600024O0003000300044O000400013O00122O000500AE3O00122O000600AF6O0004000600024O00030003000400062O000300230201000100040E3O0023020100123A0003002C4O00A30003001B3O00123A000200043O002681000200290201005A00040E3O00290201002EE800B10060020100B000040E3O00600201001213010300154O0007010400013O00122O000500B23O00122O000600B36O0004000600024O0003000300044O000400013O00122O000500B43O00122O000600B56O0004000600024O00030003000400062O000300370201000100040E3O0037020100123A000300014O00A30003001C3O0012DF000300156O000400013O00122O000500B63O00122O000600B76O0004000600024O0003000300044O000400013O00122O000500B83O00122O000600B96O0004000600024O00030003000400062O000300460201000100040E3O0046020100123A000300014O00A30003001D3O0012E5000300156O000400013O00122O000500BA3O00122O000600BB6O0004000600024O0003000300044O000400013O00122O000500BC3O00122O000600BD6O0004000600024O0003000300044O0003001E3O00122O000300156O000400013O00122O000500BE3O00122O000600BF6O0004000600024O0003000300044O000400013O00122O000500C03O00122O000600C16O0004000600024O0003000300044O0003001F3O00122O000200C23O002EE800C30064020100C400040E3O0064020100268100020066020100C200040E3O00660201002EDA00C50066000100C600040E3O00CA020100123A000300013O002E0501C80098020100C700040E3O00980201000E2E000100980201000300040E3O0098020100123A000400013O002EDA00C90006000100C900040E3O00720201002694000400720201000400040E3O0072020100123A000300043O00040E3O00980201002681000400780201000100040E3O00780201002ECF00CA0078020100CB00040E3O00780201002EDA00CC00F6FF2O00CD00040E3O006C0201001213010500154O0007010600013O00122O000700CE3O00122O000800CF6O0006000800024O0005000500064O000600013O00122O000700D03O00122O000800D16O0006000800024O00050005000600062O000500860201000100040E3O0086020100123A0005002C4O00A3000500203O0012DF000500156O000600013O00122O000700D23O00122O000800D36O0006000800024O0005000500064O000600013O00122O000700D43O00122O000800D56O0006000800024O00050005000600062O000500950201000100040E3O0095020100123A000500014O00A3000500213O00123A000400043O00040E3O006C0201002EE800D7009E020100D600040E3O009E02010026940003009E0201001000040E3O009E020100123A000200D83O00040E3O00CA0201002694000300670201000400040E3O0067020100123A000400013O002E0501D900A5020100DA00040E3O00A50201002681000400A70201000400040E3O00A70201002EDA00DB0004000100DC00040E3O00A9020100123A000300103O00040E3O00670201002EE800DE00A1020100DD00040E3O00A10201002681000400AF0201000100040E3O00AF0201002E0501DF00A1020100E000040E3O00A10201001213010500154O0083000600013O00122O000700E13O00122O000800E26O0006000800024O0005000500064O000600013O00122O000700E33O00122O000800E46O0006000800024O0005000500064O000500223O00122O000500156O000600013O00122O000700E53O00122O000800E66O0006000800024O0005000500064O000600013O00122O000700E73O00122O000800E86O0006000800024O0005000500064O000500233O00122O000400043O00040E3O00A1020100040E3O0067020100269400020010000100D800040E3O0010000100123A000300013O002EE800EA00EA020100E900040E3O00EA0201002694000300EA0201000100040E3O00EA0201001213010400154O0083000500013O00122O000600EB3O00122O000700EC6O0005000700024O0004000400054O000500013O00122O000600ED3O00122O000700EE6O0005000700024O0004000400054O000400243O00122O000400156O000500013O00122O000600EF3O00122O000700F06O0005000700024O0004000400054O000500013O00122O000600F13O00122O000700F26O0005000700024O0004000400054O000400253O00122O000300043O002EE800F300F2020100F400040E3O00F20201002EE800F600F2020100F500040E3O00F20201002694000300F20201001000040E3O00F2020100123A000200323O00040E3O00100001002E0501F800CD020100F700040E3O00CD0201002681000300F80201000400040E3O00F80201002EE800FA00CD020100F900040E3O00CD0201001213010400154O0007010500013O00122O000600FB3O00122O000700FC6O0005000700024O0004000400054O000500013O00122O000600FD3O00122O000700FE6O0005000700024O00040004000500062O000400060301000100040E3O0006030100123A000400014O00A3000400263O00121D010400156O000500013O00122O000600FF3O00122O00072O00015O0005000700024O0004000400054O000500013O00122O0006002O012O00122O00070002015O0005000700022O00BD0004000400052O00A3000400273O00123A000300103O00040E3O00CD020100040E3O0010000100040E3O001A030100040E3O000B000100040E3O001A030100040E3O000200012O006D3O00017O00EA012O00028O00026O00F03F025O00449540025O0086B240025O00DBB240025O0084A240026O001040025O006CA340025O0046A640025O0058AF40025O00D0AF40030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174025O0020AF40025O00749940025O0052A340025O005EAA4003103O00426F2O73466967687452656D61696E73025O00BEAD40025O00F09340025O0016B340025O00CC9E40025O0058A140025O0009B140024O0080B3C540030C3O00466967687452656D61696E73030A3O00456E656D696573323579025O00806C40025O0016B040025O00F4AB40025O00C6A640025O00D49D40025O00D08340025O00C6A140025O000C9140025O00C2A540025O0044A440025O00589640025O001EB240025O0030A640025O00CDB240025O00C1B14003073O0047657454696D6503053O00D92A5BEACB03053O00B991452D8F03073O004973526561647903083O0042752O66446F776E03053O00486F766572025O00309440025O003EB140025O0033B340025O001DB340025O002FB040025O006EAB40030C3O0082100FA3CECA1218AFD2CA4D03053O00BCEA7F79C6026O001440025O001C9340025O00ACAA40025O00A8A040025O00207C40025O00AAA340025O00208D40025O0008AF40025O0076A140025O00F88C40025O00D0B140025O000CA540030C3O0053686F756C6452657475726E025O00C6A340025O0002AF40025O0032A040025O0015B040027O0040025O008EA740025O003AB240025O00108740025O0022A140025O003C9040025O00AEB040030C3O0049734368612O6E656C696E67030A3O0046697265427265617468025O00405F40025O0042A040025O00FEB140025O008CAA40025O00349D40025O0024B34003093O00436173745374617274025O00F49C40025O00389B40030F3O00456D706F7765724361737454696D65025O00C49B40025O00E0A940025O0014A340025O0008A440025O0016B140025O0048B040025O00E0B140025O004AB340025O00489240025O00A49D40030D3O00DAF0BBBA2O3BEBF4BBB70F2DCC03063O005E9F80D2D968025O00408F4003143O0063ED09AF4F76F77D10DF0FAD5A3FDB6855F812B703083O001A309966DF3F1F99025O00C08B40025O00808740025O00E4A640025O00488440025O00C89540025O00A06040026O007B40025O00F07E40025O0022A840025O006EAF40025O00F2B240025O00989640026O000840025O0040A840025O00E88F40025O00805040025O00C09640025O00C09840025O004CB14003093O00497343617374696E67025O00708B40025O002CA940025O00B09440025O00209E40025O0015B240025O00C06F40025O00B2A940025O002EA540025O00088640025O0094A340025O004CAA40025O00BEA640025O007AAE40025O00C05E40025O00508740025O00B07740025O00349540025O005CB140025O00F08B40025O00C49540025O00A07640025O00809540025O00388240025O00F6A240025O002EA340025O00D09640025O0078AB40025O00409540025O00889D4003093O00496E74652O7275707403053O005175652O6C026O002440025O004C9A40025O0002A840025O0082AA40025O0052A540025O00089E40025O00DAA440030E3O005175652O6C4D6F7573656F766572025O00406040025O00A0A940025O004FB040025O0042B340025O005DB040025O003C9240025O00449740025O00E8B140025O00789D40025O00B0AF40025O00F08440025O004C9040025O00D0A14003113O00496E74652O72757074576974685374756E03093O005461696C5377697065026O002040025O00907440025O00E07C40025O00D88440025O00C05140025O0082B140025O00D2A540025O00A6A940025O00F49040030B3O001037128F2C3A0097373C1603043O00E358527303103O004865616C746850657263656E74616765030B3O004865616C746873746F6E6503173O004B1ABBAB167B500BB5A90733471ABCA20C604A09BFE75103063O0013237FDAC762025O00888140025O00A7B14003193O002EFE0CF019E802EB12FC4ACA19FA06EB12FC4AD213EF03ED1203043O00827C9B6A025O00B88740025O0018B040025O00406940025O00EEA74003173O00E7CEF0BDA6E574B6DBCCDEAAA2FA75B1D2FBF9BBAAF97203083O00DFB5AB96CFC3961C025O00288540025O00689640025O0016A64003173O0052656672657368696E674865616C696E67506F74696F6E025O000C9940025O00FCB14003253O005E3FE5BC0C5F32EAA00E0C32E6AF054534E4EE19432EEAA1070C3EE6A80C4229EAB82O0C6E03053O00692C5A83CE03083O00557068656176616C025O00F8A340025O0040A440025O00E89840025O0026A140025O0084B340025O0044A840025O0044B340025O00108D40025O00508940025O00049340025O00707F40025O00BAB240025O0014A540025O00907B40025O0007B340025O00588140025O00388140030D3O002750E4F03145F9E70B4EEAE03103043O009362208D025O00488F4003113O002B57ECDA165F451F03D6DA0E534A0E42EF03073O002B782383AA6636025O004EAD40025O00D88640025O00507040025O003AAE4003043O00502O6F6C03043O006327AE8203073O00E43466E7D6C5D003093O00576169742F502O6F6C025O00A6A340025O00309C40025O00E07440025O00D4A740025O008AAC40025O00C7B240025O004EAC40030D3O004973446561644F7247686F737403073O007613646634540E03053O005A336B141303173O0044697370652O6C61626C65467269656E646C79556E6974025O0010B240025O00049E40025O0080A740025O00109E40025O0050A040025O00789F40025O00C2A940025O0052B240025O00807840025O00B8A940025O00C05D40025O00B3B140025O00707240025O0056A340025O002EAE40025O001AA140025O00F49A40025O00D49A40025O009AAA40025O00DCB24003093O00466F637573556E6974026O003E40025O0069B040025O00CCA040025O00805D40025O00609D40025O0040A940025O00089140025O0008A840025O00AC9F40025O00ACA740030F3O00CDF68AFD7DA9F996FF3881FC8CE13A03053O005DED90E58F025O0032A940025O00D09C40025O005AA940025O00DCAB40030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C0724003043O0034E3E41603063O0026759690796B030D3O001EB4FB282EBEE13C00BAE9332E03043O005A4DDB8E030A3O0049734361737461626C65025O0086A440025O00D07740025O0044A540025O00A5B240025O005C9B40025O00F0774003083O00A6022E2B0C3475CB03073O001A866441592C67025O00B07140025O00C0B14003043O004755494403123O00466F637573537065636966696564556E6974026O003940025O00C09340025O0083B040025O00508340025O00D8AD40025O00208E4003043O00D0F6242C03053O00C49183504303093O0042752O66537461636B03143O00426C6973746572696E675363616C657342752O6603103O003CBC0F1B0CED0CB9080F2BEB1FBC031B03063O00887ED0666878025O00BFB040026O005F40025O00F5B140025O004CA540025O00D4B040025O000FB240030F3O00388CC151EF7031586B9ECB51A65C3A03083O003118EAAE23CF325D025O0092A140025O00108140025O0020A540025O0072AC4003083O0029E4F89A6803FCF803053O00116C929DE8030E3O007DC606E92EA65FE619EF3DA948C603063O00C82BA3748D4F025O00B5B040025O00D09540025O0012A440025O009CAE40025O0054B040025O00E07640025O00A06240025O0086B14003143O00FF303291F0C2E6AD323C8DA4B4C6B2342F82B3F103073O0083DF565DE3D094025O00308440025O0034904003083O00C653B3A404BAED4003063O00D583252OD67D030E3O00032620ADE02A2F07B3EE35382AB203053O0081464B45DF025O00A4A840025O00B89F40025O0062AD40025O00508540025O001CAC40025O0034AD40025O002OA040025O00208A4003143O0006CDFCFB3CCA4BCEE1E870EB06E9FFE66FFC49C603063O008F26AB93891C03083O00FE8DADB337E2DADB03073O00B4B0E2D9936383030E3O00E5BC3D03D2B73B22DEBB3D06D0BC03043O0067B3D94F025O0072A240025O009C9040025O00B88940025O00988C40025O00F89B40025O002AA940025O006BB140025O0016AE40025O0062B340025O000DB140025O00188440025O0032A740025O00109D40025O00B07D4003063O00D1F22B8F9BE003083O00C899B76AC3DEB234025O00C4A540025O00405E4003133O0072E5872F097237E28434475D72CB8D3C455F2003063O003A5283E85D29025O0096A040025O00804340025O00A09D40025O00FEA540025O00206940025O0014A040025O0058A240025O00F2B040025O007DB140025O0092AB40025O007C9B4003073O00A776FD347A1AB103063O005FE337B0753D025O00607640025O00649D4003143O0058782C59EB307B2247A21679636FAA157F244EB903053O00CB781E432B025O00109B40025O00B2AB40025O004C9F40025O00A6A540030C3O00476574466F637573556E697403063O0062923DF964BE03073O00C32AD77CB521EC03073O0029781A1F02DD3F03063O00986D39575E45025O00949140026O005040025O004EA440025O0080A240025O008AA540025O0054A040025O001EA940025O004AAF40025O00DEA240025O00C88440025O00B08640025O003C9840025O00049140025O003AA140025O00A8A240025O00689E40025O00C4A040025O00A08340025O00A3B240025O0050A94003083O0049734D6F76696E67025O00AEAA40025O0061B140025O00949B40025O00D6B040025O00508C40026O006940026O00A840025O00AAA040030C3O004570696353652O74696E677303073O008130E02158851103073O0062D55F874634E02O033O00FFACCC03053O00349EC3A917025O00689D40025O00805840025O00408C40025O00E0954003073O00CC20392FD9401103083O0024984F5E48B525622O033O00D8D74403043O005FB7B827025O00708640025O00CAB040025O00C9B040025O0066A340025O005EA14003073O004EB335738A306803083O00EB1ADC5214E6551B2O033O008BA5FA03053O0014E8C189A203073O0016D0C2A1EB890403083O001142BFA5C687EC7703043O0007AAAF1F03083O00B16FCFCE739F888C025O0034A140025O0068B34003073O0031861713D84A4C03073O003F65E97074B42F03063O00C732FE02FD3A03063O0056A35B8D7298025O00407840025O00E06440025O00F49540025O00E8894003113O00476574456E656D696573496E52616E6765030F3O00456E656D696573387953706C61736803173O00476574456E656D696573496E53706C61736852616E6765025O00788440025O0002A940025O001AAA4003143O00456E656D696573436F756E74387953706C617368031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74009F072O00123A3O00014O0057000100023O0026943O00070001000100040E3O0007000100123A000100014O0057000200023O00123A3O00023O0026813O000B0001000200040E3O000B0001002EDA000300F9FF2O000400040E3O000200010026810001000F0001000100040E3O000F0001002EDA000500FEFF2O000600040E3O000B000100123A000200013O002681000200140001000700040E3O00140001002EE8000900C80001000800040E3O00C8000100123A000300013O002681000300190001000100040E3O00190001002E05010B00880001000A00040E3O0088000100123A000400013O002694000400830001000100040E3O008300012O00AA00055O00200600050005000C2O0026010500010002000647000500260001000100040E3O002600012O00AA000500013O00202700050005000D2O00FD0005000200020006220005005600013O00040E3O0056000100123A000500014O0057000600063O0026810005002C0001000100040E3O002C0001002EDA000E00FEFF2O000F00040E3O0028000100123A000600013O002681000600310001000100040E3O00310001002EE8001100420001001000040E3O0042000100123A000700013O0026940007003B0001000100040E3O003B00012O00AA000800033O00203E0108000800124O0008000100024O000800026O000800026O000800043O00122O000700023O002E05011400320001001300040E3O00320001002694000700320001000200040E3O0032000100123A000600023O00040E3O0042000100040E3O00320001000E92000200460001000600040E3O00460001002EDA001500E9FF2O001600040E3O002D0001002E050117004C0001001800040E3O004C00012O00AA000700043O0026810007004C0001001900040E3O004C000100040E3O005600012O00AA000700033O00205A00070007001A00122O0008001B6O00098O0007000900024O000700043O00044O0056000100040E3O002D000100040E3O0056000100040E3O00280001002EDA001C002C0001001C00040E3O008200012O00AA000500053O0006220005008200013O00040E3O008200012O00AA000500063O0006220005008200013O00040E3O008200012O00AA000500013O00202700050005000D2O00FD000500020002000647000500820001000100040E3O0082000100123A000500014O0057000600073O002681000500690001000200040E3O00690001002E05011D00780001001E00040E3O007800010026810006006D0001000100040E3O006D0001002EE8001F00690001002000040E3O006900012O00AA000800074O00260108000100022O000C010700083O002E05012100820001002200040E3O008200010006220007008200013O00040E3O008200012O0084000700023O00040E3O0082000100040E3O0069000100040E3O00820001002E050123007C0001002400040E3O007C00010026810005007E0001000100040E3O007E0001002E05012500650001002600040E3O0065000100123A000600014O0057000700073O00123A000500023O00040E3O0065000100123A000400023O0026940004001A0001000200040E3O001A000100123A000300023O00040E3O0088000100040E3O001A0001002E05012800150001002700040E3O00150001002694000300150001000200040E3O00150001002EE8002A00C50001002900040E3O00C500012O00AA000400083O000622000400C500013O00040E3O00C500012O00AA000400063O000647000400990001000100040E3O009900012O00AA000400013O00202700040004000D2O00FD000400020002000622000400C500013O00040E3O00C500010012130104002B4O00BF0004000100024O000500096O0004000400054O0005000A3O00062O000400A10001000500040E3O00A1000100040E3O00C500012O00AA0004000B4O00380005000C3O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O00040004002E4O00040002000200062O000400B200013O00040E3O00B200012O00AA000400013O0020AB00040004002F4O0006000B3O00202O0006000600304O00040006000200062O000400B60001000100040E3O00B60001002EA1003200B60001003100040E3O00B60001002EE8003300C50001003400040E3O00C50001002EDA0035000F0001003500040E3O00C50001002EDA0036000D0001003600040E3O00C500012O00AA0004000D4O00AA0005000B3O0020060005000500302O00FD000400020002000622000400C500013O00040E3O00C500012O00AA0004000C3O00123A000500373O00123A000600384O00E9000400064O000100045O00123A000200393O00040E3O00C8000100040E3O00150001002EE8003A003F0301003B00040E3O003F0301002EDA003C00750201003C00040E3O003F03010026940002003F0301003900040E3O003F0301002EE8003D00F50001003E00040E3O00F50001002E05013F00F50001004000040E3O00F500012O00AA000300063O000647000300DA0001000100040E3O00DA00012O00AA000300013O00202700030003000D2O00FD000300020002000622000300F500013O00040E3O00F5000100123A000300014O0057000400043O002EDA00413O0001004100040E3O00DC0001000E2E000100DC0001000300040E3O00DC000100123A000400013O002E05014200E10001003E00040E3O00E10001002681000400E70001000100040E3O00E70001002E05014300E10001004400040E3O00E100012O00AA0005000E4O00260105000100020012FB000500453O001213010500453O000647000500EF0001000100040E3O00EF0001002E05014700F50001004600040E3O00F50001001213010500454O0084000500023O00040E3O00F5000100040E3O00E1000100040E3O00F5000100040E3O00DC00012O00AA00035O00200600030003000C2O00260103000100020006220003009E07013O00040E3O009E070100123A000300014O0057000400043O00268100032O002O01000100040E4O002O01002EE8004900FC0001004800040E3O00FC000100123A000400013O002694000400A12O01004A00040E3O00A12O0100123A000500014O0057000600063O002681000500092O01000100040E3O00092O01002EE8004C00052O01004B00040E3O00052O0100123A000600013O000E920001000E2O01000600040E3O000E2O01002EE8004E00982O01004D00040E3O00982O012O00AA000700013O00202700070007000D2O00FD000700020002000647000700162O01000100040E3O00162O012O00AA000700063O000622000700242O013O00040E3O00242O0100123A000700014O0057000800083O002EE8004F00182O01005000040E3O00182O01000E2E000100182O01000700040E3O00182O012O00AA0009000F4O00260109000100022O000C010800093O000622000800242O013O00040E3O00242O012O0084000800023O00040E3O00242O0100040E3O00182O012O00AA000700013O0020C90007000700514O0009000B3O00202O0009000900524O00070009000200062O000700972O013O00040E3O00972O0100123A000700014O00570008000A3O002EE8005300342O01005400040E3O00342O01002694000700342O01000100040E3O00342O0100123A000800014O0057000900093O00123A000700023O0026940007002D2O01000200040E3O002D2O012O0057000A000A3O000E2E0002007D2O01000800040E3O007D2O01002E050156003D2O01005500040E3O003D2O010026810009003F2O01000100040E3O003F2O01002EDA005700FCFF2O005800040E3O00392O01001213010B002B4O0058000B000100024O000C00013O00202O000C000C00594O000C000200024O000A000B000C002E2O005B004D2O01005A00040E3O004D2O012O00AA000B00013O002027000B000B005C2O00AA000D00104O002B000B000D0002000620010A00972O01000B00040E3O00972O01002E05015E00502O01005D00040E3O00502O0100040E3O00972O0100123A000B00014O0057000C000D3O002694000B00572O01000100040E3O00572O0100123A000C00014O0057000D000D3O00123A000B00023O002694000B00522O01000200040E3O00522O01002681000C005D2O01000100040E3O005D2O01002EE8006000592O01005F00040E3O00592O0100123A000D00013O002E050162005E2O01006100040E3O005E2O01002694000D005E2O01000100040E3O005E2O0100123A000E00013O002681000E00692O01000100040E3O00692O01002EA1006400692O01006300040E3O00692O01002EE8006600632O01006500040E3O00632O012O00AA000F00034O00FF0010000C3O00122O001100673O00122O001200686O00100012000200202O000F001000694O000F000C3O0012240110006A3O00122O0011006B6O000F00116O000F5O00044O00632O0100040E3O005E2O0100040E3O00972O0100040E3O00592O0100040E3O00972O0100040E3O00522O0100040E3O00972O0100040E3O00392O0100040E3O00972O01002E05016D00372O01006C00040E3O00372O01002EE8006F00372O01006E00040E3O00372O01002694000800372O01000100040E3O00372O0100123A000B00013O000E92000200882O01000B00040E3O00882O01002EE80070008A2O01007100040E3O008A2O0100123A000800023O00040E3O00372O01002681000B00902O01000100040E3O00902O01002ECF007200902O01007300040E3O00902O01002EE8007500842O01007400040E3O00842O0100123A000900014O0057000A000A3O00123A000B00023O00040E3O00842O0100040E3O00372O0100040E3O00972O0100040E3O002D2O0100123A000600023O0026810006009C2O01000200040E3O009C2O01002EDA00760070FF2O007700040E3O000A2O0100123A000400783O00040E3O00A12O0100040E3O000A2O0100040E3O00A12O0100040E3O00052O01002681000400A52O01000100040E3O00A52O01002EDA007900D10001007A00040E3O0074020100123A000500013O002EE8007B006D0201007C00040E3O006D02010026940005006D0201000100040E3O006D0201002EE8007D00E82O01007E00040E3O00E82O012O00AA000600013O00202700060006000D2O00FD000600020002000647000600B92O01000100040E3O00B92O012O00AA000600013O00202700060006007F2O00FD000600020002000647000600B92O01000100040E3O00B92O012O00AA000600063O000647000600BB2O01000100040E3O00BB2O01002E05018100E82O01008000040E3O00E82O0100123A000600014O0057000700093O002EE8008200C42O01008300040E3O00C42O01000E2E000100C42O01000600040E3O00C42O0100123A000700014O0057000800083O00123A000600023O002EDA008400F9FF2O008400040E3O00BD2O01002681000600CA2O01000200040E3O00CA2O01002E05018600BD2O01008500040E3O00BD2O012O0057000900093O000E2E000200DC2O01000700040E3O00DC2O01002681000800D12O01000100040E3O00D12O01002E05018700CD2O01008800040E3O00CD2O012O00AA000A00114O0026010A000100022O000C0109000A3O000647000900D82O01000100040E3O00D82O01002E05018A00E82O01008900040E3O00E82O012O0084000900023O00040E3O00E82O0100040E3O00CD2O0100040E3O00E82O01002EE8008B00CB2O01008C00040E3O00CB2O01000E92000100E22O01000700040E3O00E22O01002EE8008E00CB2O01008D00040E3O00CB2O0100123A000800014O0057000900093O00123A000700023O00040E3O00CB2O0100040E3O00E82O0100040E3O00BD2O01002EE8008F006C0201009000040E3O006C02012O00AA000600013O00202700060006007F2O00FD0006000200020006470006006C0201000100040E3O006C02012O00AA000600013O0020270006000600512O00FD0006000200020006470006006C0201000100040E3O006C020100123A000600014O0057000700083O000E92000100FC2O01000600040E3O00FC2O01002E7B009100FC2O01009200040E3O00FC2O01002E05019300FF2O01009400040E3O00FF2O0100123A000700014O0057000800083O00123A000600023O002EE8009600F62O01009500040E3O00F62O01000E2E000200F62O01000600040E3O00F62O01002694000700310201000100040E3O0031020100123A000900014O0057000A000A3O0026810009000B0201000100040E3O000B0201002EDA009700FEFF2O009800040E3O0007020100123A000A00013O002EDA009900060001009900040E3O00120201000E2E000200120201000A00040E3O0012020100123A000700023O00040E3O00310201002694000A000C0201000100040E3O000C020100123A000B00013O002681000B00190201000200040E3O00190201002E05019A001B0201009B00040E3O001B020100123A000A00023O00040E3O000C0201002681000B001F0201000100040E3O001F0201002E05019C00150201008D00040E3O001502012O00AA000C5O0020B0000C000C009D4O000D000B3O00202O000D000D009E00122O000E009F6O000F00016O000C000F00024O0008000C3O00062O0008002B0201000100040E3O002B0201002E0501A1002C020100A000040E3O002C02012O0084000800023O00123A000B00023O00040E3O0015020100040E3O000C020100040E3O0031020100040E3O00070201002E0501A30035020100A200040E3O00350201002681000700370201004A00040E3O00370201002E0501A50048020100A400040E3O004802012O00AA00095O00205D00090009009D4O000A000B3O00202O000A000A009E00122O000B009F6O000C00016O000D00126O000E00133O00202O000E000E00A64O0009000E00024O000800093O00062O000800460201000100040E3O00460201002EDA00A70028000100A800040E3O006C02012O0084000800023O00040E3O006C0201002EDA00A90004000100A900040E3O004C02010026810007004E0201000200040E3O004E0201002E0501AA0003020100AB00040E3O0003020100123A000900013O002EE800AC0057020100AD00040E3O00570201002EE800AF0057020100AE00040E3O00570201000E2E000200570201000900040E3O0057020100123A0007004A3O00040E3O00030201002E0501B1004F020100B000040E3O004F02010026810009005D0201000100040E3O005D0201002E0501B3004F020100B200040E3O004F02012O00AA000A5O0020C5000A000A00B44O000B000B3O00202O000B000B00B500122O000C00B66O000A000C00024O0008000A3O00062O0008006702013O00040E3O006702012O0084000800023O00123A000900023O00040E3O004F020100040E3O0003020100040E3O006C020100040E3O00F62O0100123A000500023O002EE800B700A62O0100B800040E3O00A62O01002694000500A62O01000200040E3O00A62O0100123A000400023O00040E3O0074020100040E3O00A62O01002681000400780201000200040E3O00780201002EE800B900D9020100BA00040E3O00D9020100123A000500013O0026810005007D0201000200040E3O007D0201002EE800BB007F020100BC00040E3O007F020100123A0004004A3O00040E3O00D90201002EE800BE0079020100BD00040E3O00790201002694000500790201000100040E3O007902012O00AA000600144O00380007000C3O00122O000800BF3O00122O000900C06O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600A302013O00040E3O00A302012O00AA000600153O000622000600A302013O00040E3O00A302012O00AA000600013O0020270006000600C12O00FD0006000200022O00AA000700163O00061B000600A30201000700040E3O00A302012O00AA0006000D4O002C010700133O00202O0007000700C24O000800096O000A00016O0006000A000200062O000600A302013O00040E3O00A302012O00AA0006000C3O00123A000700C33O00123A000800C44O00E9000600084O000100065O002EE800C500D7020100C600040E3O00D702012O00AA000600173O000622000600D702013O00040E3O00D702012O00AA000600013O0020270006000600C12O00FD0006000200022O00AA000700183O00061B000600D70201000700040E3O00D702012O00AA000600194O00340107000C3O00122O000800C73O00122O000900C86O00070009000200062O000600D70201000700040E3O00D70201002EE800CA00B8020100C900040E3O00B8020100040E3O00D70201002EE800CB00D7020100CC00040E3O00D702012O00AA000600144O00F70007000C3O00122O000800CD3O00122O000900CE6O0007000900024O00060006000700202O00060006002E4O00060002000200062O000600C60201000100040E3O00C60201002EDA00CF0013000100D000040E3O00D70201002EDA00D1000A000100D100040E3O00D002012O00AA0006000D4O00B3000700133O00202O0007000700D24O000800096O000A00016O0006000A000200062O000600D20201000100040E3O00D20201002EE800D400D7020100D300040E3O00D702012O00AA0006000C3O00123A000700D53O00123A000800D64O00E9000600084O000100065O00123A000500023O00040E3O007902010026940004003O01007800040E3O003O012O00AA000500013O0020C90005000500514O0007000B3O00202O0007000700D74O00050007000200062O0005002B03013O00040E3O002B030100123A000500014O0057000600073O002694000500230301000200040E3O00230301002EDA00D80004000100D800040E3O00EA0201002681000600EC0201000100040E3O00EC0201002E0501D900E6020100DA00040E3O00E602010012130108002B4O002D0108000100024O000900013O00202O0009000900594O0009000200024O0007000800094O000800013O00202O00080008005C4O000A001A6O0008000A000200062O0007002B0301000800040E3O002B0301002E0501DC00FB020100DB00040E3O00FB020100040E3O002B030100123A000800014O0057000900093O0026810008002O0301000100040E3O002O0301002E7B00DE002O030100DD00040E3O002O0301002E0501DF00FD020100E000040E3O00FD020100123A000900013O0026810009000A0301000100040E3O000A0301002E7B00E1000A030100E200040E3O000A0301002EE800E30004030100E400040E3O0004030100123A000A00013O002681000A00110301000100040E3O00110301002E7B00E60011030100E500040E3O00110301002E0501E7000B030100E800040E3O000B03012O00AA000B00034O00FF000C000C3O00122O000D00E93O00122O000E00EA6O000C000E000200202O000B000C00EB4O000B000C3O001224010C00EC3O00122O000D00ED6O000B000D6O000B5O00044O000B030100040E3O0004030100040E3O002B030100040E3O00FD020100040E3O002B030100040E3O00E6020100040E3O002B0301002EE800EF00E4020100EE00040E3O00E40201002694000500E40201000100040E3O00E4020100123A000600014O0057000700073O00123A000500023O00040E3O00E40201002EE800F0009E070100F100040E3O009E07012O00AA0005001B4O009C0006000B3O00202O0006000600F24O00078O0008000C3O00122O000900F33O00122O000A00F46O0008000A6O00053O000200062O0005009E07013O00040E3O009E070100123A000500F54O0084000500023O00040E3O009E070100040E3O003O0100040E3O009E070100040E3O00FC000100040E3O009E0701002681000200450301004A00040E3O00450301002EA100F60045030100F700040E3O00450301002EE800F900C6060100F800040E3O00C6060100123A000300013O002E0501FA00B3060100FB00040E3O00B30601000E2E000100B30601000300040E3O00B30601002E05018A0052030100FC00040E3O005203012O00AA000400013O0020270004000400FD2O00FD0004000200020006220004005203013O00040E3O005203012O006D3O00014O00AA0004001C3O0006220004006403013O00040E3O006403012O00AA0004000B4O00380005000C3O00122O000600FE3O00122O000700FF6O0005000700024O00040004000500202O00040004002E4O00040002000200062O0004006403013O00040E3O006403012O00AA00045O002006000400042O00010026010400010002000647000400680301000100040E3O0068030100123A0004002O012O00123A00050002012O0006AF000400EF0301000500040E3O00EF030100123A000400014O0057000500083O00123A00090003012O00123A000A0004012O0006E0000A00710301000900040E3O0071030100123A000900023O000643000400750301000900040E3O0075030100123A00090005012O00123A000A0006012O0006E0000900770301000A00040E3O007703012O0057000700083O00123A0004004A3O00123A000900013O0006430009007E0301000400040E3O007E030100123A00090007012O00123A000A0008012O0006E0000A00810301000900040E3O0081030100123A000500014O0057000600063O00123A000400023O00123A00090009012O00123A000A000A012O00061B0009006A0301000A00040E3O006A030100123A0009004A3O0006AF0004006A0301000900040E3O006A030100123A000900013O0006430009008F0301000500040E3O008F030100123A0009000B012O00123A000A000C012O00061B000A00920301000900040E3O0092030100123A000600014O0057000700073O00123A000500023O00123A000900023O0006AF000500880301000900040E3O008803012O0057000800083O00123A0009000D012O00123A000A000D012O0006AF0009009D0301000A00040E3O009D030100123A000900013O000643000600A10301000900040E3O00A1030100123A0009000E012O00123A000A000F012O0006E0000A00D00301000900040E3O00D0030100123A000900014O0057000A000A3O00123A000B0010012O00123A000C0011012O00061B000C00A30301000B00040E3O00A3030100123A000B00013O0006AF000B00A30301000900040E3O00A3030100123A000A00013O00123A000B0012012O00123A000C0013012O0006E0000B00C00301000C00040E3O00C0030100123A000B0014012O00123A000C0011012O00061B000C00C00301000B00040E3O00C0030100123A000B00013O0006AF000A00C00301000B00040E3O00C003012O00AA0007001C4O008A000B5O00122O000C0015015O000B000B000C4O000C00076O000D00133O00122O000E0016015O000B000E00024O0008000B3O00122O000A00023O00123A000B00023O000643000A00CB0301000B00040E3O00CB030100123A000B0017012O00123A000C0018012O000620010B00CB0301000C00040E3O00CB030100123A000B0019012O00123A000C001A012O0006AF000B00AB0301000C00040E3O00AB030100123A000600023O00040E3O00D0030100040E3O00AB030100040E3O00D0030100040E3O00A3030100123A0009001B012O00123A000A001C012O0006E0000A00960301000900040E3O0096030100123A000900023O000643000600DB0301000900040E3O00DB030100123A0009001D012O00123A000A004C3O00061B000A00960301000900040E3O00960301000647000800E10301000100040E3O00E1030100123A0009001E012O00123A000A001F012O00061B000A00B20601000900040E3O00B206012O000C010900084O0003010A000C3O00122O000B0020012O00122O000C0021015O000A000C00024O00090009000A4O000900023O00044O00B2060100040E3O0096030100040E3O00B2060100040E3O0088030100040E3O00B2060100040E3O006A030100040E3O00B2060100123A00040022012O00123A00050023012O0006E00005006E0401000400040E3O006E040100123A00040024012O00123A00050025012O00061B0004006E0401000500040E3O006E04012O00AA0004001D4O00260104000100020006220004006E04013O00040E3O006E04012O00AA0004001E3O00121000060026015O0004000400064O0006000B3O00122O00070027015O0006000600074O00040006000200122O00050028012O00062O0004006E0401000500040E3O006E04012O00AA0004001F4O00340105000C3O00122O00060029012O00122O0007002A015O00050007000200062O0004006E0401000500040E3O006E04012O00AA0004001D4O006B00040001000200122O00060026015O0004000400064O0006000B3O00122O00070027015O0006000600074O00040006000200122O00050028012O00062O0004006E0401000500040E3O006E04012O00AA0004000B4O00170005000C3O00122O0006002B012O00122O0007002C015O0005000700024O00040004000500122O0006002D015O0004000400064O00040002000200062O0004006E04013O00040E3O006E040100123A000400014O0057000500053O00123A000600013O0006430004002F0401000600040E3O002F040100123A0006002E012O00123A0007002F012O0006E4000600050001000700040E3O002F040100123A00060030012O00123A00070031012O00061B000700240401000600040E3O0024040100123A000500013O00123A00060032012O00123A00070033012O0006E0000700420401000600040E3O0042040100123A000600023O0006AF000500420401000600040E3O00420401001213010600453O000622000600B206013O00040E3O00B20601001213010600454O00030107000C3O00122O00080034012O00122O00090035015O0007000900024O0006000600074O000600023O00044O00B2060100123A000600013O0006AF000500300401000600040E3O0030040100123A000600013O00123A00070036012O00123A00080037012O0006E00007005C0401000800040E3O005C040100123A000700013O0006AF0006005C0401000700040E3O005C04012O00AA0007001D4O001B01070001000200122O00090038015O0007000700094O0007000200024O000700206O00075O00122O00080039015O0007000700084O0008001D6O00080001000200123A0009003A013O002B0007000900020012FB000700453O00123A000600023O00123A0007003B012O00123A0008003C012O0006E0000700460401000800040E3O0046040100123A0007003D012O00123A0008003E012O0006E0000700460401000800040E3O0046040100123A000700023O0006AF000700460401000600040E3O0046040100123A000500023O00040E3O0030040100040E3O0046040100040E3O0030040100040E3O00B2060100040E3O0024040100040E3O00B2060100123A0004003F012O00123A0005003F012O0006AF000400C60401000500040E3O00C604012O00AA000400214O0026010400010002000622000400C604013O00040E3O00C604012O00AA000400224O00340105000C3O00122O00060040012O00122O00070041015O00050007000200062O000400C60401000500040E3O00C604012O00AA000400214O009000040001000200122O00060042015O0004000400064O0006000B3O00122O00070043015O0006000600074O0004000600024O000500233O00062O000400C60401000500040E3O00C604012O00AA0004000B4O00170005000C3O00122O00060044012O00122O00070045015O0005000700024O00040004000500122O0006002D015O0004000400064O00040002000200062O000400C604013O00040E3O00C6040100123A000400013O00123A00050046012O00123A00060047012O00061B0006009B0401000500040E3O009B040100123A000500023O0006430004009F0401000500040E3O009F040100123A00050048012O00123A00060049012O0006AF000500AE0401000600040E3O00AE0401001213010500453O000647000500A60401000100040E3O00A6040100123A0005004A012O00123A0006004B012O0006AF000500B20601000600040E3O00B20601001213010500454O00030106000C3O00122O0007004C012O00122O0008004D015O0006000800024O0005000500064O000500023O00044O00B2060100123A0005004E012O00123A0006004F012O0006E0000600940401000500040E3O0094040100123A000500013O0006AF000400940401000500040E3O009404012O00AA000500214O001B01050001000200122O00070038015O0005000500074O0005000200024O000500246O00055O00122O00060039015O0005000500064O000600216O00060001000200123A0007003A013O002B0005000700020012FB000500453O00123A000400023O00040E3O0094040100040E3O00B2060100123A00040050012O00123A00050051012O00061B000400180501000500040E3O001805012O00AA000400053O0006220004001805013O00040E3O001805012O00AA000400254O00340105000C3O00122O00060052012O00122O00070053015O00050007000200062O000400180501000500040E3O001805012O00AA0004000B4O00380005000C3O00122O00060054012O00122O00070055015O0005000700024O00040004000500202O00040004002E4O00040002000200062O0004001805013O00040E3O0018050100123A000400014O0057000500063O00123A000700013O000643000700E70401000400040E3O00E7040100123A00070056012O00123A00080057012O00061B000700EA0401000800040E3O00EA040100123A000500014O0057000600063O00123A000400023O00123A000700023O0006AF000400E00401000700040E3O00E0040100123A00070058012O00123A00080059012O00061B000700F40401000800040E3O00F4040100123A000700013O000643000500F80401000700040E3O00F8040100123A0007005A012O00123A0008005B012O00061B000700ED0401000800040E3O00ED040100123A000600013O00123A000700013O00064300062O000501000700040E4O00050100123A0007005C012O00123A0008005D012O00061B000800F90401000700040E3O00F904012O00AA00075O00121100080015015O0007000700084O00088O0009000B6O0007000B000200122O000700453O00122O000700453O00062O000700B206013O00040E3O00B20601001213010700454O00030108000C3O00122O0009005E012O00122O000A005F015O0008000A00024O0007000700084O000700023O00044O00B2060100040E3O00F9040100040E3O00B2060100040E3O00ED040100040E3O00B2060100040E3O00E0040100040E3O00B2060100123A00040060012O00123A00050061012O0006E00004006A0501000500040E3O006A05012O00AA000400053O0006220004006A05013O00040E3O006A05012O00AA000400264O00340105000C3O00122O00060062012O00122O00070063015O00050007000200062O0004006A0501000500040E3O006A05012O00AA0004000B4O00380005000C3O00122O00060064012O00122O00070065015O0005000700024O00040004000500202O00040004002E4O00040002000200062O0004006A05013O00040E3O006A050100123A000400014O0057000500063O00123A000700023O000643000400390501000700040E3O0039050100123A00070066012O00123A00080067012O00061B000700620501000800040E3O0062050100123A000700013O000643000500400501000700040E3O0040050100123A00070068012O00123A00080069012O00061B000700390501000800040E3O0039050100123A000600013O00123A0007006A012O00123A0008006B012O00061B000700410501000800040E3O0041050100123A000700013O0006AF000600410501000700040E3O004105012O00AA00075O00121C01080015015O0007000700084O00088O0009000B6O0007000B000200122O000700453O00122O0007006C012O00122O0008006D012O00062O000800B20601000700040E3O00B20601001213010700453O000622000700B206013O00040E3O00B20601001213010700454O00030108000C3O00122O0009006E012O00122O000A006F015O0008000A00024O0007000700084O000700023O00044O00B2060100040E3O0041050100040E3O00B2060100040E3O0039050100040E3O00B2060100123A000700013O0006AF000400320501000700040E3O0032050100123A000500014O0057000600063O00123A000400023O00040E3O0032050100040E3O00B206012O00AA000400053O0006220004007E05013O00040E3O007E05012O00AA000400254O00340105000C3O00122O00060070012O00122O00070071015O00050007000200062O0004007E0501000500040E3O007E05012O00AA0004000B4O00F70005000C3O00122O00060072012O00122O00070073015O0005000700024O00040004000500202O00040004002E4O00040002000200062O000400860501000100040E3O0086050100123A00040074012O00123A00050075012O0006E4000400050001000500040E3O0086050100123A00040076012O00123A00050077012O00061B000500B20601000400040E3O00B2060100123A000400014O0057000500083O00123A0009004A3O0006430004008F0501000900040E3O008F050100123A00090078012O00123A000A0079012O00061B000A009A0601000900040E3O009A060100123A0009007A012O00123A000A007B012O00061B000A00960501000900040E3O0096050100123A000900023O0006430005009A0501000900040E3O009A050100123A0009007C012O00123A000A007D012O00061B000900740601000A00040E3O007406012O0057000800083O00123A000900023O000643000600A20501000900040E3O00A2050100123A0009007E012O00123A000A00AD3O00061B000A00330601000900040E3O003306010020270009000700C12O00FD000900020002002027000A000800C12O00FD000A000200020006E0000900E60501000A00040E3O00E6050100123A000900014O0057000A000B3O00123A000C00023O000643000900B10501000C00040E3O00B1050100123A000C007F012O00123A000D0080012O00061B000C00DA0501000D00040E3O00DA050100123A000C00013O000643000A00B80501000C00040E3O00B8050100123A000C0081012O00123A000D00A93O0006AF000C00B10501000D00040E3O00B1050100123A000B00013O00123A000C00013O0006AF000B00B90501000C00040E3O00B905012O00AA000C5O001271000D0015015O000C000C000D4O000D8O000E000F6O0010000C3O00122O00110082012O00122O00120083015O001000126O000C3O000200122O000C00453O00122O000C00453O00062O000C00CE0501000100040E3O00CE050100123A000C0084012O00123A000D0085012O0006E0000C00B20601000D00040E3O00B20601001213010C00454O0003010D000C3O00122O000E0086012O00122O000F0087015O000D000F00024O000C000C000D4O000C00023O00044O00B2060100040E3O00B9050100040E3O00B2060100040E3O00B1050100040E3O00B2060100123A000C00013O000643000C00E10501000900040E3O00E1050100123A000C0088012O00123A000D0089012O0006AF000C00AA0501000D00040E3O00AA050100123A000A00014O0057000B000B3O00123A000900023O00040E3O00AA050100040E3O00B206010020270009000800C12O00FD000900020002002027000A000700C12O00FD000A0002000200061B000A00ED0501000900040E3O00ED050100040E3O00B2060100123A000900014O0057000A000B3O00123A000C008A012O00123A000D008B012O00061B000C002B0601000D00040E3O002B060100123A000C00023O0006AF0009002B0601000C00040E3O002B060100123A000C00013O000643000C00010601000A00040E3O0001060100123A000C003C3O00123A000D008C012O0006E4000C00050001000D00040E3O0001060100123A000C008D012O00123A000D008E012O0006AF000C00F60501000D00040E3O00F6050100123A000B00013O00123A000C00013O000643000B000D0601000C00040E3O000D060100123A000C008F012O00123A000D0090012O0006E4000D00050001000C00040E3O000D060100123A000C0091012O00123A000D0092012O00061B000C00020601000D00040E3O000206012O00AA000C5O001271000D0015015O000C000C000D4O000D8O000E000F6O0010000C3O00122O00110093012O00122O00120094015O001000126O000C3O000200122O000C00453O00122O000C00453O00062O000C001F0601000100040E3O001F060100123A000C0095012O00123A000D0096012O0006AF000C00B20601000D00040E3O00B20601001213010C00454O0003010D000C3O00122O000E0097012O00122O000F0098015O000D000F00024O000C000C000D4O000C00023O00044O00B2060100040E3O0002060100040E3O00B2060100040E3O00F6050100040E3O00B2060100123A000C00013O0006AF000900EF0501000C00040E3O00EF050100123A000A00014O0057000B000B3O00123A000900023O00040E3O00EF050100040E3O00B2060100123A000900013O0006AF0006009B0501000900040E3O009B050100123A000900014O0057000A000A3O00123A000B00013O0006430009003F0601000B00040E3O003F060100123A000B0099012O00123A000C009A012O00061B000C00380601000B00040E3O0038060100123A000A00013O00123A000B00013O000643000A00470601000B00040E3O0047060100123A000B009B012O00123A000C009C012O0006AF000B00620601000C00040E3O006206012O00AA000B5O001287000C009D015O000B000B000C4O000C8O000D000D6O000E000C3O00122O000F009E012O00122O0010009F015O000E00106O000B3O000200062O000700540601000B00040E3O005406012O00AA000700014O00AA000B5O001287000C009D015O000B000B000C4O000C8O000D000D6O000E000C3O00122O000F00A0012O00122O001000A1015O000E00106O000B3O000200062O000800610601000B00040E3O006106012O00AA000800013O00123A000A00023O00123A000B00A2012O00123A000C00A3012O00061B000C00690601000B00040E3O0069060100123A000B00023O000643000A006D0601000B00040E3O006D060100123A000B00A4012O00123A000C00A5012O0006E0000B00400601000C00040E3O0040060100123A000600023O00040E3O009B050100040E3O0040060100040E3O009B050100040E3O0038060100040E3O009B050100040E3O00B2060100123A000900A6012O00123A000A00A7012O00061B000A008F0501000900040E3O008F050100123A000900013O0006430009007F0601000500040E3O007F060100123A000900A8012O00123A000A00A9012O0006E0000A008F0501000900040E3O008F050100123A000900013O00123A000A00AA012O00123A000B00AB012O0006E0000B00890601000A00040E3O0089060100123A000A00023O0006AF000A00890601000900040E3O0089060100123A000500023O00040E3O008F050100123A000A00AC012O00123A000B00AD012O0006E0000A00800601000B00040E3O0080060100123A000A00013O000643000900940601000A00040E3O0094060100123A000A00AE012O00123A000B00AF012O0006E0000B00800601000A00040E3O0080060100123A000600014O0057000700073O00123A000900023O00040E3O0080060100040E3O008F050100040E3O00B2060100123A000900B0012O00123A000A00B1012O00061B000A00A40601000900040E3O00A4060100123A000900013O0006AF000400A40601000900040E3O00A4060100123A000500014O0057000600063O00123A000400023O00123A000900023O000643000400AF0601000900040E3O00AF060100123A000900B2012O00123A000A00B3012O0006E4000900050001000A00040E3O00AF060100123A000900B4012O00123A000A00B5012O0006AF000900880501000A00040E3O008805012O0057000700083O00123A0004004A3O00040E3O0088050100123A000300023O00123A000400023O0006AF000300460301000400040E3O004603012O00AA000400013O00123A000600B6013O00C20004000400062O00FD000400020002000622000400C006013O00040E3O00C0060100123A000400B7012O00123A000500B8012O00061B000500C30601000400040E3O00C306010012130104002B4O00260104000100022O00A3000400093O00123A000200783O00040E3O00C6060100040E3O0046030100123A000300013O000643000200CD0601000300040E3O00CD060100123A000300B9012O00123A000400BA012O0006E0000400130701000300040E3O0013070100123A000300014O0057000400043O00123A000500BB012O00123A000600BC012O0006E0000600CF0601000500040E3O00CF060100123A000500013O0006AF000300CF0601000500040E3O00CF060100123A000400013O00123A000500023O000643000400DE0601000500040E3O00DE060100123A000500BD012O00123A000600BE012O00061B000500EC0601000600040E3O00EC0601001213010500BF013O00DD0006000C3O00122O000700C0012O00122O000800C1015O0006000800024O0005000500064O0006000C3O00122O000700C2012O00122O000800C3015O0006000800024O0005000500062O00A3000500273O00123A000200023O00040E3O0013070100123A000500013O000643000400F30601000500040E3O00F3060100123A000500C4012O00123A000600C5012O00061B000500D70601000600040E3O00D7060100123A000500013O00123A000600C6012O00123A000700C7012O00061B000600FD0601000700040E3O00FD060100123A000600023O0006AF000600FD0601000500040E3O00FD060100123A000400023O00040E3O00D7060100123A000600013O0006AF000500F40601000600040E3O00F406012O00AA000600284O002F01060001000100122O000600BF015O0007000C3O00122O000800C8012O00122O000900C9015O0007000900024O0006000600074O0007000C3O00122O000800CA012O00122O000900CB015O0007000900024O0006000600074O000600063O00122O000500023O00044O00F4060100040E3O00D7060100040E3O0013070100040E3O00CF060100123A000300023O0006430002001A0701000300040E3O001A070100123A000300CC012O00123A0004000F012O0006E00004005C0701000300040E3O005C070100123A000300014O0057000400043O00123A000500013O0006AF0005001C0701000300040E3O001C070100123A000400013O00123A000500CD012O00123A000600CE012O0006E0000600440701000500040E3O0044070100123A000500013O0006430004002B0701000500040E3O002B070100123A000500CF012O00123A000600D0012O0006AF000500440701000600040E3O00440701001213010500BF013O00830006000C3O00122O000700D1012O00122O000800D2015O0006000800024O0005000500064O0006000C3O00122O000700D3012O00122O000800D4015O0006000800024O0005000500064O000500293O00122O000500BF015O0006000C3O00122O000700D5012O00122O000800D6015O0006000800024O0005000500064O0006000C3O00122O000700D7012O00122O000800D8015O0006000800024O0005000500064O000500053O00122O000400023O00123A000500D9012O00123A000600DA012O0006E0000500200701000600040E3O0020070100123A000500023O0006AF000400200701000500040E3O00200701001213010500BF013O00DD0006000C3O00122O000700DB012O00122O000800DC015O0006000800024O0005000500064O0006000C3O00122O000700DD012O00122O000800DE015O0006000800024O0005000500062O00A30005002A3O00123A0002004A3O00040E3O005C070100040E3O0020070100040E3O005C070100040E3O001C070100123A000300DF012O00123A000400E0012O00061B000400100001000300040E3O0010000100123A000300783O0006AF000300100001000200040E3O0010000100123A000300014O0057000400043O00123A000500013O0006AF000300650701000500040E3O0065070100123A000400013O00123A000500E1012O00123A000600E2012O00061B0006007D0701000500040E3O007D070100123A000500013O0006AF0004007D0701000500040E3O007D07012O00AA000500013O0012BE000700E3015O00050005000700122O0007003A015O00050007000200122O0005001B6O0005002B3O00122O000700E5015O00050005000700122O000700B66O00050007000200122O000500E4012O00122O000400023O00123A000500023O000643000400840701000500040E3O0084070100123A000500E6012O00123A000600E7012O0006AF000500690701000600040E3O0069070100123A000500E8012O00123A0006000F012O0006E0000500920701000600040E3O009207012O00AA000500273O0006220005009207013O00040E3O009207012O00AA0005002B3O001237010700EA015O00050005000700122O000700B66O00050007000200122O000500E9012O00044O0094070100123A000500023O0012FB000500E9012O00123A000200073O00040E3O0010000100040E3O0069070100040E3O0010000100040E3O0065070100040E3O0010000100040E3O009E070100040E3O000B000100040E3O009E070100040E3O000200012O006D3O00017O001A3O00028O00026O00AE40025O00408F40027O0040030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03283O00DE260E0737F6EB321D033DF6BF161F0539FDED73314A24B8AE6347587CA8AF732B1372DAF03C042103063O00989F53696A52026O00F03F03123O0073052D4F77D82E560E325A56D120420A384C03073O0042376C5E3F12B403183O00308496272255188C873B22691B849638297D118F9031214A03063O003974EDE5574703053O005072696E7403223O008BA42OEA72E053ABA5E4E879AE62BCBEE6E265AE45B3F1C8F77EED0788BEE2EA5CA003073O0027CAD18D87178E025O0036AC40025O00F08D40025O00C8A440025O00D09D40025O0046AC4003103O0038E967CFC8991CD70AE851CFE89E1FD003083O00B67E8015AA8AEB7903143O00526567697374657241757261547261636B696E6703133O00BFDF38F68901310ABCD520E8823735049EDC3303083O0066EBBA5586E67350004C3O00123A3O00014O0057000100013O0026943O00020001000100040E3O0002000100123A000100013O002EE8000300110001000200040E3O00110001002694000100110001000400040E3O00110001001213010200053O0020300102000200064O00035O00122O000400073O00122O000500086O000300056O00023O000100044O004B0001002694000100270001000900040E3O002700012O00AA000200014O003000035O00122O0004000A3O00122O0005000B6O0003000500024O000400016O00055O00122O0006000C3O00122O0007000D6O0005000700024O0004000400052O00310002000300042O001F000200023O00202O00020002000E4O00035O00122O0004000F3O00122O000500106O000300056O00023O000100122O000100043O002E05011200050001001100040E3O000500010026810001002D0001000100040E3O002D0001002EE8001300050001001400040E3O0005000100123A000200013O002EDA001500060001001500040E3O00340001002694000200340001000900040E3O0034000100123A000100093O00040E3O000500010026940002002E0001000100040E3O002E00012O00AA000300034O001D00045O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300184O0003000200014O000300036O00045O00122O000500193O00122O0006001A6O0004000600024O00030003000400202O0003000300184O00030002000100122O000200093O00044O002E000100040E3O0005000100040E3O004B000100040E3O000200012O006D3O00017O00", GetFEnv(), ...);

