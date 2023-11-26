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
											if (Enum > 0) then
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
												Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
											end
										elseif (Enum > 2) then
											Stk[Inst[2]] = Upvalues[Inst[3]];
										elseif (Stk[Inst[2]] > Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
									elseif (Enum <= 6) then
										if (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 7) then
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
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum > 9) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 11) then
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
									elseif (Enum == 12) then
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
									elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										do
											return Unpack(Stk, A, Top);
										end
									end
								elseif (Enum <= 16) then
									do
										return Stk[Inst[2]];
									end
								elseif (Enum > 17) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum > 19) then
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
										end
									elseif (Enum == 21) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									end
								elseif (Enum <= 24) then
									if (Enum > 23) then
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
								elseif (Enum <= 25) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 26) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 30) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 31) then
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
								end
							elseif (Enum <= 34) then
								if (Enum > 33) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 35) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 36) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 40) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 43) then
									if (Enum > 42) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									else
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
									end
								elseif (Enum <= 44) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 45) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								end
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum > 47) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum <= 49) then
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
									VIP = Inst[3];
								elseif (Enum > 50) then
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
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								else
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								end
							elseif (Enum <= 53) then
								if (Enum == 52) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 54) then
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
							elseif (Enum == 55) then
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
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 66) then
							if (Enum <= 61) then
								if (Enum <= 58) then
									if (Enum > 57) then
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
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
								elseif (Enum <= 59) then
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
									Stk[Inst[2]] = #Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum > 60) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 63) then
								if (Enum == 62) then
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
							elseif (Enum <= 64) then
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
							elseif (Enum == 65) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								end
							elseif (Enum <= 69) then
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 70) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 73) then
							if (Enum > 72) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 74) then
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
						elseif (Enum == 75) then
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 114) then
						if (Enum <= 95) then
							if (Enum <= 85) then
								if (Enum <= 80) then
									if (Enum <= 78) then
										if (Enum == 77) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
										A = Inst[2];
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
									end
								elseif (Enum <= 82) then
									if (Enum > 81) then
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									else
										local A;
										if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
											Stk[Inst[2]] = Env;
										else
											Stk[Inst[2]] = Env[Inst[3]];
										end
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
										Stk[Inst[2]] = not Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 83) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 84) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 90) then
								if (Enum <= 87) then
									if (Enum == 86) then
										local B;
										local A;
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 88) then
									local B;
									local A;
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
								elseif (Enum == 89) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
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
							elseif (Enum <= 92) then
								if (Enum == 91) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 93) then
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
							elseif (Enum == 94) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 104) then
							if (Enum <= 99) then
								if (Enum <= 97) then
									if (Enum > 96) then
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
									else
										local B;
										local A;
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 98) then
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
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
									end
								end
							elseif (Enum <= 101) then
								if (Enum > 100) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 102) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 103) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 109) then
							if (Enum <= 106) then
								if (Enum > 105) then
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
									Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
								end
							elseif (Enum <= 107) then
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
							elseif (Enum == 108) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 111) then
							if (Enum == 110) then
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 112) then
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 113) then
							if (Stk[Inst[2]] ~= Inst[4]) then
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								elseif (Enum > 117) then
									local Edx;
									local Results, Limit;
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 120) then
								if (Enum == 119) then
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
										if (Mvm[1] == 75) then
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
							elseif (Enum <= 121) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 122) then
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
						elseif (Enum <= 128) then
							if (Enum <= 125) then
								if (Enum == 124) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 126) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							elseif (Enum == 127) then
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
						elseif (Enum <= 130) then
							if (Enum == 129) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 131) then
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
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum > 132) then
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 143) then
						if (Enum <= 138) then
							if (Enum <= 135) then
								if (Enum > 134) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
								end
							elseif (Enum <= 136) then
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
							elseif (Enum == 137) then
								Stk[Inst[2]] = not Stk[Inst[3]];
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum <= 141) then
							Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						elseif (Enum > 142) then
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
					elseif (Enum <= 148) then
						if (Enum <= 145) then
							if (Enum > 144) then
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
								A = Inst[2];
								Stk[A] = Stk[A]();
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
						elseif (Enum <= 146) then
							Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						end
					elseif (Enum <= 150) then
						if (Enum > 149) then
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
						elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 151) then
						Stk[Inst[2]] = Inst[3] / Stk[Inst[4]];
					elseif (Enum > 152) then
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
				elseif (Enum <= 230) then
					if (Enum <= 191) then
						if (Enum <= 172) then
							if (Enum <= 162) then
								if (Enum <= 157) then
									if (Enum <= 155) then
										if (Enum > 154) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										end
									elseif (Enum > 156) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 159) then
									if (Enum == 158) then
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
										Stk[Inst[2]] = not Stk[Inst[3]];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 160) then
									Stk[Inst[2]]();
								elseif (Enum > 161) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 167) then
								if (Enum <= 164) then
									if (Enum == 163) then
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
										VIP = Inst[3];
									end
								elseif (Enum <= 165) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 166) then
									if (Inst[2] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 169) then
								if (Enum > 168) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 170) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum == 171) then
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
							end
						elseif (Enum <= 181) then
							if (Enum <= 176) then
								if (Enum <= 174) then
									if (Enum > 173) then
										if (Stk[Inst[2]] < Inst[4]) then
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
								elseif (Enum == 175) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 178) then
								if (Enum == 177) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum <= 179) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 180) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 186) then
							if (Enum <= 183) then
								if (Enum == 182) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 184) then
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
							elseif (Enum == 185) then
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 188) then
							if (Enum == 187) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 189) then
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum == 190) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 210) then
						if (Enum <= 200) then
							if (Enum <= 195) then
								if (Enum <= 193) then
									if (Enum == 192) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 194) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								else
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								end
							elseif (Enum <= 197) then
								if (Enum == 196) then
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
									A = Inst[2];
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
								end
							elseif (Enum <= 198) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
						elseif (Enum <= 205) then
							if (Enum <= 202) then
								if (Enum > 201) then
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
							elseif (Enum <= 203) then
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
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 204) then
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
							if (Enum > 206) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 208) then
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
						elseif (Enum == 209) then
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
						end
					elseif (Enum <= 220) then
						if (Enum <= 215) then
							if (Enum <= 212) then
								if (Enum == 211) then
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
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
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 213) then
								Stk[Inst[2]] = Inst[3];
							elseif (Enum == 214) then
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 218) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
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
							Stk[Inst[2]] = Inst[3];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 225) then
						if (Enum <= 222) then
							if (Enum > 221) then
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
						elseif (Enum <= 223) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 224) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							local A;
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 227) then
						if (Enum > 226) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
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
							Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
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
					elseif (Enum <= 228) then
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
					elseif (Enum > 229) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 268) then
					if (Enum <= 249) then
						if (Enum <= 239) then
							if (Enum <= 234) then
								if (Enum <= 232) then
									if (Enum == 231) then
										if (Stk[Inst[2]] <= Inst[4]) then
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
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum == 233) then
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
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
								end
							elseif (Enum <= 236) then
								if (Enum == 235) then
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
							elseif (Enum <= 237) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 238) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 244) then
							if (Enum <= 241) then
								if (Enum > 240) then
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
							elseif (Enum <= 242) then
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
							elseif (Enum > 243) then
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
							elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum <= 246) then
							if (Enum > 245) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 247) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 248) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 258) then
						if (Enum <= 253) then
							if (Enum <= 251) then
								if (Enum > 250) then
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
							elseif (Enum > 252) then
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
							end
						elseif (Enum <= 255) then
							if (Enum > 254) then
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
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 256) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum > 257) then
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
					elseif (Enum <= 263) then
						if (Enum <= 260) then
							if (Enum > 259) then
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
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 261) then
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
						elseif (Enum == 262) then
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Enum > 264) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
					elseif (Enum <= 266) then
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
					elseif (Enum > 267) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 287) then
					if (Enum <= 277) then
						if (Enum <= 272) then
							if (Enum <= 270) then
								if (Enum > 269) then
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
							elseif (Enum == 271) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 274) then
							if (Enum > 273) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
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
						elseif (Enum == 276) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 282) then
						if (Enum <= 279) then
							if (Enum == 278) then
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 280) then
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
						elseif (Enum > 281) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 284) then
						if (Enum > 283) then
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
					elseif (Enum <= 285) then
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
					elseif (Enum > 286) then
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
						Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 297) then
					if (Enum <= 292) then
						if (Enum <= 289) then
							if (Enum == 288) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 290) then
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
						elseif (Enum == 291) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
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
						end
					elseif (Enum <= 294) then
						if (Enum > 293) then
							Env[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum <= 295) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 296) then
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
						Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
				elseif (Enum <= 302) then
					if (Enum <= 299) then
						if (Enum > 298) then
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
					elseif (Enum <= 300) then
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
					elseif (Enum > 301) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 304) then
					if (Enum > 303) then
						if (Inst[2] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
					end
				elseif (Enum <= 305) then
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
				elseif (Enum == 306) then
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
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
					Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!4B3O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403053O005574696C7303063O00506C6179657203063O005461726765742O033O0050657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O004361737403053O005072652O73030B3O005072652O73437572736F7203053O004D6163726F03043O0042696E6403073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O006D6174682O033O006D617803043O006365696C03043O004D61676503043O004669726503103O005265676973746572466F724576656E7403243O0058C049CA4FC642D355C244C64BDC4ED35CC054C255CA47C24DCA52CD46C055C257C458C703043O008319831D03103O0053756E4B696E6773426C652O73696E67030B3O004973417661696C61626C65030A3O00466C616D655061746368026O000840025O00388F40030B3O004675656C74686546697265026O004440029A5O99D93F028O00026O001840026O00344003083O004B696E646C696E67026O00F03F026O002040024O0080B3C54003183O0088603AEA9D7E24F6897932E3956935E7876F33F2966B3EF703043O00B3D82C7B03143O0091FC017E93FC04738EE9056091E6096282ED016E03043O002CDDB94003093O005079726F626C61737403103O005265676973746572496E466C6967687403083O004669726562612O6C03063O004D6574656F7203163O005265676973746572496E466C69676874452O66656374024O00906E1541030D3O0050686F656E6978466C616D6573024O0030700F41030E3O00436F6D62757374696F6E42752O6603143O0031CB69665633D82O7A5424C9777A5D20C5647A5703053O00136187283F030E3O009D6C16170302917F1B1A01168B7803063O0051CE3C535B4F03143O00628EF14001E6699B7D9BF55E03FC648A719FF15003083O00C42ECBB0124FA32D03063O0053657441504C025O00804F400046022O00126D3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004A43O000A000100120D000300063O0020AF00040003000700120D000500083O0020AF00050005000900120D000600083O0020AF00060006000A00067700073O000100062O004B3O00064O004B8O004B3O00044O004B3O00014O004B3O00024O004B3O00054O001F0008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000D001100202O0010000D001200202O0011000D00130020AF0012000B00140020160113000B001500202O0014000B001600122O0015000D3O00202O00160015001700202O00170015001800202O00180015001900202O00190015001A00202O001A0015001B00202O001B0015001C00202O001B001B001D0020AF001B001B001E002037001C0015001C00202O001C001C001D00202O001C001C001F00122O001D00203O00202O001D001D002100122O001E00203O00202O001E001E00224O001F001F6O00208O00216O007D00226O00D200238O002400573O00202O00580012002300202O00580058002400202O00590014002300202O00590059002400202O005A0019002300202O005A005A00244O005B5O00202O005C0015001C0020AF005C005C001D000677005D0001000100022O004B3O00584O004B3O005C3O00207F005E000B002500067700600002000100012O004B3O005D4O00B2006100073O00122O006200263O00122O006300276O006100636O005E3O00014O005E00223O00202O005F0058002800202O005F005F00294O005F0002000200202O00600058002A00207F0060006000293O000160000200020006100160005900013O0004A43O005900010012D50060002B3O0006450060005A000100010004A43O005A00010012D50060002C3O0012D50061002C4O00E3006200606O0063001B3O00202O00640058002D00202O0064006400294O006400656O00633O000200102O0063002B00634O0064001B3O00202O00650058002D00202O0065006500293O000165000200022O00E0006500656O00640002000200102O0064002C00644O00630063006400122O0064002C3O00122O0065002E3O00122O0066002C3O00122O0067002F3O00122O006800303O00122O006900314O007D006A5O000610016A007600013O0004A43O007600010012D5006B00323O000645006B0077000100010004A43O007700010012D5006B00304O00BC006C006C3O0020AF006D0058003300207F006D006D00293O00016D00020002000610016D008000013O0004A43O008000010012D5006D002F3O000645006D0081000100010004A43O008100010012D5006D00344O007D006E6O00EA006F8O00705O00122O007100303O00122O007200303O00122O007300353O00122O0074002B6O007500773O00122O0078002B3O00122O007900363O00122O007A00364O00BC007B00843O00207F0085000B002500067700870003000100022O004B3O006A4O004B3O006B4O0004008800073O00122O008900373O00122O008A00386O0088008A6O00853O000100202O0085000B002500067700870004000100012O004B3O00584O0011008800073O00122O008900393O00122O008A003A6O0088008A6O00853O000100202O00850058003B00202O00850085003C4O00850002000100202O00850058003D00202O00850085003C2O00A70085000200010020A500850058003E00202O00850085003F00122O008700406O00850087000100202O00850058003E00202O00850085003C4O00850002000100202O00850058004100202O00850085003F00122O008700424O005200850087000100203300850058004100202O00850085003C4O00850002000100202O00850058003B00202O00850085003C00202O0087005800434O00850087000100202O00850058003D00202O00850085003C00202O0087005800432O005200850087000100207F0085000B002500067700870005000100022O004B3O00794O004B3O007A4O0004008800073O00122O008900443O00122O008A00456O0088008A6O00853O000100202O0085000B002500067700870006000100052O004B3O005F4O004B3O00584O004B3O00604O004B3O00624O004B3O006D4O00F4008800073O00122O008900463O00122O008A00476O0088008A00024O008900073O00122O008A00483O00122O008B00496O0089008B6O00853O000100067700850007000100022O004B3O00584O004B3O00103O00067700860008000100022O004B3O00584O004B3O00103O00067700870009000100022O004B3O00584O004B3O00103O0006770088000A000100022O004B3O00584O004B3O00103O0006770089000B000100022O004B3O00784O004B3O00583O000677008A000C000100052O004B3O00854O004B3O001B4O004B3O00584O004B3O000F4O004B3O00883O000677008B000D000100012O004B3O00583O000677008C000E000100012O004B3O00583O000677008D000F000100042O004B3O001F4O004B3O005C4O004B3O005B4O004B3O00223O000677008E0010000100062O004B3O00584O004B3O00234O004B3O005C4O004B3O00174O004B3O005A4O004B3O00073O000677008F00110001001A2O004B3O00584O004B3O00384O004B3O000F4O004B3O003F4O004B3O00174O004B3O00074O004B3O00394O004B3O00404O004B3O004B4O004B3O004D4O004B3O004F4O004B3O00594O004B3O005A4O004B3O00354O004B3O003C4O004B3O004C4O004B3O004E4O004B3O003A4O004B3O00414O004B3O00374O004B3O003E4O004B3O00364O004B3O003D4O004B3O003B4O004B3O005C4O004B3O00423O000677009000120001000B2O004B3O00584O004B3O00254O004B3O000F4O004B3O005C4O004B3O00174O004B3O00074O004B3O003A4O004B3O00544O004B3O002D4O004B3O00104O004B3O00283O00067700910013000100112O004B3O00584O004B3O002A4O004B3O007D4O004B3O00764O004B3O006C4O004B3O00174O004B3O00104O004B3O00074O004B3O002B4O004B3O004A4O004B3O007A4O004B3O000F4O004B3O005A4O004B3O00264O004B3O000B4O004B3O00884O004B3O00863O00067700920014000100102O004B3O00504O004B3O00534O004B3O00224O004B3O004A4O004B3O007A4O004B3O00584O004B3O00174O004B3O00074O004B3O00754O004B3O00564O004B3O000F4O004B3O005C4O004B3O00514O004B3O00524O004B3O001F4O004B3O008D3O000677009300150001002B2O004B3O00584O004B3O002C4O004B3O000F4O004B3O00104O004B3O007B4O004B3O00174O004B3O00074O004B3O001F4O004B3O00914O004B3O00314O004B3O00334O004B3O00224O004B3O004A4O004B3O007A4O004B3O008C4O004B3O00764O004B3O006C4O004B3O00674O004B3O00274O004B3O008A4O004B3O00704O004B3O00884O004B3O00754O004B3O001B4O004B3O00214O004B3O00294O004B3O007C4O004B3O00624O004B3O005A4O004B3O002D4O004B3O00504O004B3O00534O004B3O002A4O004B3O007D4O004B3O00694O004B3O00924O004B3O00634O004B3O00284O004B3O002E4O004B3O007E4O004B3O00324O004B3O00344O004B3O00663O00067700940016000100102O004B3O006C4O004B3O00714O004B3O00584O004B3O005F4O004B3O001D4O004B3O00864O004B3O006D4O004B3O00724O004B3O001B4O004B3O007C4O004B3O00624O004B3O007A4O004B3O00854O004B3O000F4O004B3O00734O004B3O007B3O000677009500170001000B2O004B3O00584O004B3O00274O004B3O008A4O004B3O00704O004B3O000F4O004B3O001B4O004B3O008C4O004B3O007B4O004B3O00174O004B3O00104O004B3O00073O00067700960018000100222O004B3O00584O004B3O002E4O004B3O00884O004B3O00104O004B3O007B4O004B3O000F4O004B3O00174O004B3O00074O004B3O002D4O004B3O00274O004B3O008A4O004B3O00854O004B3O00704O004B3O00874O004B3O00744O004B3O008C4O004B3O00214O004B3O00264O004B3O007E4O004B3O00244O004B3O007F4O004B3O00644O004B3O00654O004B3O00294O004B3O007C4O004B3O00614O004B3O005A4O004B3O00284O004B3O00604O004B3O00634O004B3O002C4O004B3O006F4O004B3O001F4O004B3O00913O00067700970019000100292O004B3O00584O004B3O00274O004B3O008A4O004B3O000F4O004B3O00784O004B3O00174O004B3O00104O004B3O00074O004B3O006C4O004B3O00764O004B3O001F4O004B3O00964O004B3O00874O004B3O002E4O004B3O00704O004B3O00894O004B3O001B4O004B3O006E4O004B3O00684O004B3O007A4O004B3O005E4O004B3O00754O004B3O00724O004B3O00934O004B3O007B4O004B3O00224O004B3O00344O004B3O00324O004B3O004A4O004B3O00884O004B3O00944O004B3O00564O004B3O00854O004B3O00514O004B3O00524O004B3O008D4O004B3O007C4O004B3O00624O004B3O006F4O004B3O00614O004B3O00953O0006770098001A000100242O004B3O00244O004B3O00074O004B3O00254O004B3O00264O004B3O00274O004B3O00284O004B3O00294O004B3O002A4O004B3O002B4O004B3O002C4O004B3O002D4O004B3O002E4O004B3O002F4O004B3O00304O004B3O00314O004B3O00324O004B3O00334O004B3O00344O004B3O00354O004B3O00424O004B3O00544O004B3O00554O004B3O00564O004B3O00574O004B3O003C4O004B3O003D4O004B3O003E4O004B3O003F4O004B3O00404O004B3O00414O004B3O00364O004B3O00374O004B3O00384O004B3O00394O004B3O003B4O004B3O003A3O0006770099001B000100122O004B3O004A4O004B3O00074O004B3O00474O004B3O00484O004B3O00494O004B3O00524O004B3O00534O004B3O004C4O004B3O004B4O004B3O00464O004B3O004E4O004B3O004D4O004B3O004F4O004B3O00454O004B3O00444O004B3O00434O004B3O00514O004B3O00503O000677009A001C0001002B2O004B3O00814O004B3O00104O004B3O00824O004B3O000F4O004B3O00834O004B3O00224O004B3O00074O004B3O00234O004B3O00214O004B3O00804O004B3O007C4O004B3O001D4O004B3O007D4O004B3O007E4O004B3O007F4O004B3O005C4O004B3O00754O004B3O00584O004B3O00764O004B3O00444O004B3O001F4O004B3O005A4O004B3O00794O004B3O000B4O004B3O005E4O004B3O006C4O004B3O007B4O004B3O00844O004B3O008B4O004B3O007A4O004B3O00204O004B3O00904O004B3O00454O004B3O00574O004B3O00464O004B3O00554O004B3O00434O004B3O00174O004B3O00974O004B3O008E4O004B3O008F4O004B3O00984O004B3O00993O000677009B001D000100032O004B3O005D4O004B3O00154O004B3O00073O00202F009C0015004A00122O009D004B6O009E009A6O009F009B6O009C009F00016O00013O001E3O00023O00026O00F03F026O00704002264O002B01025O00122O000300016O00045O00122O000500013O00042O0003002100012O000300076O0020000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0003000C00034O003E000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00DA000C6O0094000A3O000200207E000A000A00022O002B0009000A4O00C300073O00010004080103000500012O0003000300054O004B000400024O00AA000300044O000E00036O002E012O00017O00043O00030B3O0052656D6F76654375727365030B3O004973417661696C61626C6503123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O6673000B4O0033016O00206O000100206O00026O0002000200064O000A00013O0004A43O000A00012O00033O00014O0003000100013O0020AF0001000100040010D33O000300012O002E012O00019O003O00034O00038O00A03O000100012O002E012O00017O00023O00028O00026O00344000103O0012D53O00013O0026703O0001000100010004A43O000100012O007D00016O004800016O000300015O0006102O01000B00013O0004A43O000B00010012D5000100023O0006450001000C000100010004A43O000C00010012D5000100014O0048000100013O0004A43O000F00010004A43O000100012O002E012O00017O000D3O00028O00026O00084003093O005079726F626C61737403103O005265676973746572496E466C69676874030E3O00436F6D62757374696F6E42752O6603083O004669726562612O6C026O00F03F027O0040030D3O0050686F656E6978466C616D657303163O005265676973746572496E466C69676874452O66656374024O0030700F4103063O004D6574656F72024O00906E154100353O0012D53O00013O0026703O0010000100020004A43O001000012O000300015O0020BE00010001000300202O0001000100044O00035O00202O0003000300054O0001000300014O00015O00202O00010001000600202O0001000100044O00035O00202O0003000300052O00520001000300010004A43O003400010026703O001B000100010004A43O001B00012O000300015O00208700010001000300202O0001000100044O0001000200014O00015O00202O00010001000600202O0001000100044O00010002000100124O00073O0026703O0027000100080004A43O002700012O000300015O00204300010001000900202O00010001000A00122O0003000B6O0001000300014O00015O00202O00010001000900202O0001000100044O00010002000100124O00023O0026703O0001000100070004A43O000100012O000300015O00206B00010001000C00202O00010001000A00122O0003000D6O0001000300014O00015O00202O00010001000C00202O0001000100044O00010002000100124O00083O00044O000100012O002E012O00017O00023O00028O00024O0080B3C540000A3O0012D53O00013O0026703O0001000100010004A43O000100010012D5000100024O004800015O0012D5000100024O0048000100013O0004A43O000900010004A43O000100012O002E012O00017O00093O00028O0003103O0053756E4B696E6773426C652O73696E67030B3O004973417661696C61626C65030A3O00466C616D655061746368026O000840025O00388F40026O00F03F03083O004B696E646C696E670200A04O99D93F00263O0012D53O00013O0026703O0014000100010004A43O001400012O0003000100013O0020C100010001000200202O0001000100034O0001000200024O00018O000100013O00202O00010001000400202O0001000100034O00010002000200062O0001001100013O0004A43O001100010012D5000100053O00064500010012000100010004A43O001200010012D5000100064O0048000100023O0012D53O00073O0026703O0001000100070004A43O000100012O0003000100024O0060000100036O000100013O00202O00010001000800202O0001000100034O00010002000200062O0001002100013O0004A43O002100010012D5000100093O00064500010022000100010004A43O002200010012D5000100074O0048000100043O0004A43O002500010004A43O000100012O002E012O00017O00043O00030B3O004669726573746172746572030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765025O00805640000F4O0033016O00206O000100206O00026O0002000200064O000D00013O0004A43O000D00012O00033O00013O00207F5O00033O00012O00020002000E170104000C00013O0004A43O000C00012O003A8O007D3O00014O00103O00024O002E012O00017O00063O00030B3O004669726573746172746572030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765025O0080564003073O0054696D65546F58029O00174O0033016O00206O000100206O00026O0002000200064O001400013O0004A43O001400012O00033O00013O00207F5O00033O00012O00020002000E300104001100013O0004A43O001100012O00033O00013O00207F5O00050012D5000200044O00E13O000200020006453O0015000100010004A43O001500010012D53O00063O0006453O0015000100010004A43O001500010012D53O00064O00103O00024O002E012O00017O00043O00030C3O0053656172696E67546F756368030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O003E40000F4O0033016O00206O000100206O00026O0002000200064O000D00013O0004A43O000D00012O00033O00013O00207F5O00033O00012O000200020026FE3O000C000100040004A43O000C00012O003A8O007D3O00014O00103O00024O002E012O00017O00043O00030E3O00496D70726F76656453636F726368030B3O004973417661696C61626C6503103O004865616C746850657263656E74616765026O003E40000F4O0033016O00206O000100206O00026O0002000200064O000D00013O0004A43O000D00012O00033O00013O00207F5O00033O00012O000200020026FE3O000C000100040004A43O000C00012O003A8O007D3O00014O00103O00024O002E012O00017O00033O00030D3O005368696674696E67506F776572030C3O00426173654475726174696F6E030C3O00426173655469636B54696D65000D4O0032019O000100013O00202O00010001000100202O0001000100024O0001000200028O00014O000100013O00202O00010001000100202O0001000100034O0001000200028O00016O00028O00017O000D3O00028O0003093O005079726F626C61737403083O00496E466C6967687403083O004669726562612O6C030D3O0050686F656E6978466C616D657303083O005072657647434450026O00F03F03063O0042752O665570030D3O00486F7453747265616B42752O6603103O004879706572746865726D696142752O66030D3O0048656174696E67557042752O6603093O00497343617374696E6703063O0053636F72636800633O0012D53O00014O00BC000100013O0026703O0028000100010004A43O002800012O000300026O00120102000100020006100102001700013O0004A43O001700012O0003000200014O00CA000300023O00202O00030003000200202O0003000300034O000300046O00023O00024O000300016O000400023O00202O00040004000400202O0004000400034O000400054O009400033O00022O00BB00020002000300068E00010018000100020004A43O001800010012D5000100014O0003000200014O00FB000300023O00202O00030003000500202O0003000300034O00030002000200062O00030025000100010004A43O002500012O0003000300033O00203600030003000600122O000500076O000600023O00202O0006000600054O0003000600023O000102000200022O00BB0001000100020012D53O00073O0026703O0002000100070004A43O000200012O0003000200033O00201B0102000200084O000400023O00202O0004000400094O00020004000200062O00020060000100010004A43O006000012O0003000200033O00201B0102000200084O000400023O00202O00040004000A4O00020004000200062O00020060000100010004A43O006000012O0003000200033O0020790002000200084O000400023O00202O00040004000B4O00020004000200062O0002006000013O0004A43O006000012O0003000200044O00120102000100020006100102004A00013O0004A43O004A00012O0003000200033O00201B01020002000C4O000400023O00202O00040004000D4O00020004000200062O00020060000100010004A43O006000012O000300026O00120102000100020006100102006000013O0004A43O006000012O0003000200033O00201B01020002000C4O000400023O00202O0004000400044O00020004000200062O00020060000100010004A43O006000012O0003000200033O00201B01020002000C4O000400023O00202O0004000400024O00020004000200062O00020060000100010004A43O00600001000E172O01005F000100010004A43O005F00012O003A00026O007D000200014O0010000200023O0004A43O000200012O002E012O00017O00053O00028O00026O00F03F03053O00706169727303083O00446562752O665570030C3O0049676E697465446562752O6601183O0012D5000100014O00BC000200023O000E0600020005000100010004A43O000500012O0010000200023O00267000010002000100010004A43O000200010012D5000200013O00120D000300034O004B00046O00BD0003000200050004A43O0013000100207F0008000700042O0003000A5O0020AF000A000A00052O00E10008000A00020006100108001300013O0004A43O0013000100202F0102000200020006D60003000C000100020004A43O000C00010012D5000100023O0004A43O000200012O002E012O00017O00053O00028O0003083O004669726562612O6C03083O00496E466C69676874030D3O0050686F656E6978466C616D6573026O00F03F00183O0012D53O00014O00BC000100013O0026703O0013000100010004A43O001300010012D5000100014O00FB00025O00202O00020002000200202O0002000200034O00020002000200062O00020011000100010004A43O001100012O000300025O0020AF00020002000400207F0002000200033O000102000200020006100102001200013O0004A43O0012000100202F2O01000100050012D53O00053O0026703O0002000100050004A43O000200012O0010000100023O0004A43O000200012O002E012O00017O00053O00028O00026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003103O0048616E646C65546F705472696E6B657400233O0012D53O00013O0026703O0011000100020004A43O001100012O0003000100013O00201C0001000100034O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002200013O0004A43O002200012O000300016O0010000100023O0004A43O00220001000E060001000100013O0004A43O000100012O0003000100013O00201C0001000100054O000200026O000300033O00122O000400046O000500056O0001000500024O00018O00015O00062O0001002000013O0004A43O002000012O000300016O0010000100023O0012D53O00023O0004A43O000100012O002E012O00017O00073O00030B3O0052656D6F7665437572736503073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974026O00344003103O0052656D6F76654375727365466F63757303133O00AA27731132FED0BB376C0D21BBEBB1316E1B2803073O008FD8421E7E449B001B4O0033016O00206O000100206O00026O0002000200064O001A00013O0004A43O001A00012O00033O00013O000610012O001A00013O0004A43O001A00012O00033O00023O0020AF5O00030012D5000100045O00012O00020002000610012O001A00013O0004A43O001A00012O00033O00034O0003000100043O0020AF0001000100053O00012O00020002000610012O001A00013O0004A43O001A00012O00033O00053O0012D5000100063O0012D5000200074O00AA3O00024O000E8O002E012O00017O002D3O00028O00026O00F03F03083O00496365426C6F636B030A3O0049734361737461626C6503103O004865616C746850657263656E7461676503153O00A3CB08F4C7AFD8E2A18809CEC3A6D9F2A3DE088B9603083O0081CAA86DABA5C3B7030D3O00496365436F6C6454616C656E74030B3O004973417661696C61626C65030E3O00496365436F6C644162696C69747903143O002B5B32E7DD1BEA261833DDD811E8315121DD9E4703073O0086423857B8BE74027O0040026O00104003193O000E340FA91CF8293C323649931CEA2D3C3236498B16FF283A3203083O00555C5169DB798B4103173O0052656672657368696E674865616C696E67506F74696F6E03073O004973526561647903233O00EFB6565779CCF5BA5E423CD7F8B25C4C72D8BDA35F5175D02OF354407ADAF3A059537903063O00BF9DD330251C031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O00DB0DF11D37C81EF8173FCD0CB4143FDE13FD123D9F0FFB0833D011B4183FD91AFA0F33C91A03053O005ABF7F947C026O00084003093O00416C74657254696D6503163O00798B3A126AB83A1E75826E137D812B196B8E381238D103043O007718E74E030B3O004865616C746873746F6E6503153O008A28A446C848029622AB4F9C44148428AB59D5561403073O0071E24DC52ABC20030B3O004D692O726F72496D61676503183O00371FE6A73504CBBC3717F3B07A12F1B33F18E7BC2C13B4E103043O00D55A769403133O0047726561746572496E7669736962696C69747903203O005C3CB157595E3C8B5F434D27A75F4F5222BD42541B2AB15048553DBD40481B7B03053O002D3B4ED436030E3O00426C617A696E6742612O7269657203083O0042752O66446F776E031B3O00125A82918F20AACF125791998F2BBFB01453858E883DA4E61516D203083O00907036E3EBE64ECD030B3O004D612O7342612O72696572031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503183O00BE291C2OEF59B23A1DF5D549F32C0AFAD555A02119F9900903063O003BD3486F9CB00031012O0012D53O00013O0026703O003E000100020004A43O003E00012O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01001D00013O0004A43O001D00012O0003000100013O0006102O01001D00013O0004A43O001D00012O0003000100023O00207F0001000100053O002O01000200022O0003000200033O00068F0001001D000100020004A43O001D00012O0003000100044O000300025O0020AF0002000200033O002O01000200020006102O01001D00013O0004A43O001D00012O0003000100053O0012D5000200063O0012D5000300074O00AA000100034O000E00016O000300015O0020AF00010001000800207F0001000100093O002O01000200020006102O01003D00013O0004A43O003D00012O000300015O0020AF00010001000A00207F0001000100043O002O01000200020006102O01003D00013O0004A43O003D00012O0003000100063O0006102O01003D00013O0004A43O003D00012O0003000100023O00207F0001000100053O002O01000200022O0003000200073O00068F0001003D000100020004A43O003D00012O0003000100044O000300025O0020AF00020002000A3O002O01000200020006102O01003D00013O0004A43O003D00012O0003000100053O0012D50002000B3O0012D50003000C4O00AA000100034O000E00015O0012D53O000D3O0026703O007B0001000E0004A43O007B00012O0003000100083O0006102O0100302O013O0004A43O00302O012O0003000100023O00207F0001000100053O002O01000200022O0003000200093O00068F000100302O0100020004A43O00302O010012D5000100013O0026700001004A000100010004A43O004A00012O00030002000A4O009B000300053O00122O0004000F3O00122O000500106O00030005000200062O00020064000100030004A43O006400012O00030002000B3O0020AF00020002001100207F0002000200123O000102000200020006100102006400013O0004A43O006400012O0003000200044O00030003000C3O0020AF0003000300113O000102000200020006100102006400013O0004A43O006400012O0003000200053O0012D5000300133O0012D5000400144O00AA000200044O000E00026O00030002000A3O002670000200302O0100150004A43O00302O012O00030002000B3O0020AF00020002001600207F0002000200123O00010200020002000610010200302O013O0004A43O00302O012O0003000200044O00030003000C3O0020AF0003000300113O00010200020002000610010200302O013O0004A43O00302O012O0003000200053O00124A000300173O00122O000400186O000200046O00025O00044O00302O010004A43O004A00010004A43O00302O010026703O00B2000100190004A43O00B200012O000300015O0020AF00010001001A00207F0001000100123O002O01000200020006102O01009700013O0004A43O009700012O00030001000D3O0006102O01009700013O0004A43O009700012O0003000100023O00207F0001000100053O002O01000200022O00030002000E3O00068F00010097000100020004A43O009700012O0003000100044O000300025O0020AF00020002001A3O002O01000200020006102O01009700013O0004A43O009700012O0003000100053O0012D50002001B3O0012D50003001C4O00AA000100034O000E00016O00030001000B3O0020AF00010001001D00207F0001000100123O002O01000200020006102O0100B100013O0004A43O00B100012O00030001000F3O0006102O0100B100013O0004A43O00B100012O0003000100023O00207F0001000100053O002O01000200022O0003000200103O00068F000100B1000100020004A43O00B100012O0003000100044O00030002000C3O0020AF00020002001D3O002O01000200020006102O0100B100013O0004A43O00B100012O0003000100053O0012D50002001E3O0012D50003001F4O00AA000100034O000E00015O0012D53O000E3O0026703O00E90001000D0004A43O00E900012O000300015O0020AF00010001002000207F0001000100043O002O01000200020006102O0100CE00013O0004A43O00CE00012O0003000100113O0006102O0100CE00013O0004A43O00CE00012O0003000100023O00207F0001000100053O002O01000200022O0003000200123O00068F000100CE000100020004A43O00CE00012O0003000100044O000300025O0020AF0002000200203O002O01000200020006102O0100CE00013O0004A43O00CE00012O0003000100053O0012D5000200213O0012D5000300224O00AA000100034O000E00016O000300015O0020AF00010001002300207F0001000100123O002O01000200020006102O0100E800013O0004A43O00E800012O0003000100133O0006102O0100E800013O0004A43O00E800012O0003000100023O00207F0001000100053O002O01000200022O0003000200143O00068F000100E8000100020004A43O00E800012O0003000100044O000300025O0020AF0002000200233O002O01000200020006102O0100E800013O0004A43O00E800012O0003000100053O0012D5000200243O0012D5000300254O00AA000100034O000E00015O0012D53O00193O0026703O0001000100010004A43O000100012O000300015O0020AF00010001002600207F0001000100043O002O01000200020006102O01000C2O013O0004A43O000C2O012O0003000100153O0006102O01000C2O013O0004A43O000C2O012O0003000100023O0020790001000100274O00035O00202O0003000300264O00010003000200062O0001000C2O013O0004A43O000C2O012O0003000100023O00207F0001000100053O002O01000200022O0003000200163O00068F0001000C2O0100020004A43O000C2O012O0003000100044O000300025O0020AF0002000200263O002O01000200020006102O01000C2O013O0004A43O000C2O012O0003000100053O0012D5000200283O0012D5000300294O00AA000100034O000E00016O000300015O0020AF00010001002A00207F0001000100043O002O01000200020006102O01002E2O013O0004A43O002E2O012O0003000100173O0006102O01002E2O013O0004A43O002E2O012O0003000100023O0020790001000100274O00035O00202O0003000300264O00010003000200062O0001002E2O013O0004A43O002E2O012O0003000100183O0020FD00010001002B4O000200193O00122O0003000D6O00010003000200062O0001002E2O013O0004A43O002E2O012O0003000100044O000300025O0020AF00020002002A3O002O01000200020006102O01002E2O013O0004A43O002E2O012O0003000100053O0012D50002002C3O0012D50003002D4O00AA000100034O000E00015O0012D53O00023O0004A43O000100012O002E012O00017O00153O00028O00030F3O00417263616E65496E74652O6C656374030A3O0049734361737461626C6503083O0042752O66446F776E03103O0047726F757042752O664D692O73696E67031C3O004F95E02C4082DC244093E6214282E0390E97F1284D88EE2F4F93A37F03043O004D2EE783030B3O004D692O726F72496D616765030D3O00546172676574497356616C696403183O00B75DA452B5468949B755B145FA44A445B95BBB42BB40F61203043O0020DA34D6026O00F03F03093O005079726F626C61737403073O004973526561647903093O00497343617374696E67030E3O0049735370652O6C496E52616E676503153O005E0E23A7F3BC44495A5721BAF4B34A574C1625E8A503083O003A2E7751C891D02503083O004669726562612O6C03143O002D8522A9ABBC3A27CC20BEACBE39268E31B8E9EB03073O00564BEC50CCC9DD00853O0012D53O00013O0026703O0043000100010004A43O004300012O000300015O0020AF00010001000200207F0001000100033O002O01000200020006102O01002600013O0004A43O002600012O0003000100013O0006102O01002600013O0004A43O002600012O0003000100023O0020590001000100044O00035O00202O0003000300024O000400016O00010004000200062O0001001B000100010004A43O001B00012O0003000100033O0020CD0001000100054O00025O00202O0002000200024O00010002000200062O0001002600013O0004A43O002600012O0003000100044O000300025O0020AF0002000200023O002O01000200020006102O01002600013O0004A43O002600012O0003000100053O0012D5000200063O0012D5000300074O00AA000100034O000E00016O000300015O0020AF00010001000800207F0001000100033O002O01000200020006102O01004200013O0004A43O004200012O0003000100033O0020AF0001000100092O00122O01000100020006102O01004200013O0004A43O004200012O0003000100063O0006102O01004200013O0004A43O004200012O0003000100073O0006102O01004200013O0004A43O004200012O0003000100044O000300025O0020AF0002000200083O002O01000200020006102O01004200013O0004A43O004200012O0003000100053O0012D50002000A3O0012D50003000B4O00AA000100034O000E00015O0012D53O000C3O0026703O00010001000C0004A43O000100012O000300015O0020AF00010001000D00207F00010001000E3O002O01000200020006102O01006700013O0004A43O006700012O0003000100083O0006102O01006700013O0004A43O006700012O0003000100023O00201B2O010001000F4O00035O00202O00030003000D4O00010003000200062O00010067000100010004A43O006700012O0003000100044O002100025O00202O00020002000D4O000300093O00202O0003000300104O00055O00202O00050005000D4O0003000500024O000300036O000400016O00010004000200062O0001006700013O0004A43O006700012O0003000100053O0012D5000200113O0012D5000300124O00AA000100034O000E00016O000300015O0020AF00010001001300207F00010001000E3O002O01000200020006102O01008400013O0004A43O008400012O00030001000A3O0006102O01008400013O0004A43O008400012O0003000100044O002100025O00202O0002000200134O000300093O00202O0003000300104O00055O00202O0005000500134O0003000500024O000300036O000400016O00010004000200062O0001008400013O0004A43O008400012O0003000100053O00124A000200143O00122O000300156O000100036O00015O00044O008400010004A43O000100012O002E012O00017O00213O00028O00030A3O004C6976696E67426F6D6203073O0049735265616479026O00F03F030F3O00432O6F6C646F776E52656D61696E73030E3O0049735370652O6C496E52616E6765031C3O007E48618CF08C4D437888FCCB7342638CE88E4D557689FB85665237D703063O00EB122117E59E03063O004D6574656F72030B3O0042752O6652656D61696E73030E3O00436F6D62757374696F6E42752O66030A3O0054726176656C54696D6503103O0053756E4B696E6773426C652O73696E67030B3O004973417661696C61626C65025O00804640030C3O004D6574656F72437572736F7203093O004973496E52616E6765026O00444003173O005DBFD5BE5FA881BA53AEC8AD5585D5BA5CBFCFAF43FA9503043O00DB30DAA1030D3O00447261676F6E7342726561746803103O00416C657873747261737A61734675727903083O0042752O66446F776E030D3O00486F7453747265616B42752O6603063O0042752O665570030F3O00462O656C7468654275726E42752O66030A3O00436F6D62617454696D65026O002E40030E3O0054656D7065726564466C616D6573031F3O00E0637D4ED441F3DB736E4CDA5BE8A4707F5DD259E5DB657D45DE41F4F7312A03073O008084111C29BB2F031F3O000520073D520F2139384F043312321D003112334B040D123B51043C12291D5903053O003D6152665A00E33O0012D53O00013O0026703O0066000100010004A43O006600012O000300015O0020AF00010001000200207F0001000100033O002O01000200020006102O01002D00013O0004A43O002D00012O0003000100013O0006102O01002D00013O0004A43O002D00012O0003000100023O000E300104002D000100010004A43O002D00012O0003000100033O0006102O01002D00013O0004A43O002D00012O0003000100044O001900025O00202O00020002000200202O0002000200054O00020002000200062O0002001C000100010004A43O001C00012O0003000100043O0026E70001002D000100010004A43O002D00012O0003000100054O008C00025O00202O0002000200024O000300063O00202O0003000300064O00055O00202O0005000500024O0003000500024O000300036O00010003000200062O0001002D00013O0004A43O002D00012O0003000100073O0012D5000200073O0012D5000300084O00AA000100034O000E00016O000300015O0020AF00010001000900207F0001000100033O002O01000200020006102O01006500013O0004A43O006500012O0003000100083O0006102O01006500013O0004A43O006500012O0003000100094O00030002000A3O0006D700010065000100020004A43O006500012O0003000100043O00260200010055000100010004A43O005500012O00030001000B3O0020DF00010001000A4O00035O00202O00030003000B4O0001000300024O00025O00202O00020002000900202O00020002000C4O00020002000200062O00020055000100010004A43O005500012O000300015O0020AF00010001000D00207F00010001000E3O002O010002000200064500010065000100010004A43O006500012O0003000100043O000E17010F0055000100010004A43O005500012O00030001000A4O0003000200043O0006D700010065000100020004A43O006500012O0003000100054O00240002000C3O00202O0002000200104O000300063O00202O00030003001100122O000500126O0003000500024O000300036O00010003000200062O0001006500013O0004A43O006500012O0003000100073O0012D5000200133O0012D5000300144O00AA000100034O000E00015O0012D53O00043O0026703O0001000100040004A43O000100012O000300015O0020AF00010001001500207F0001000100033O002O01000200020006102O0100A600013O0004A43O00A600012O00030001000D3O0006102O0100A600013O0004A43O00A600012O000300015O0020AF00010001001600207F00010001000E3O002O01000200020006102O0100A600013O0004A43O00A600012O0003000100033O0006102O0100A600013O0004A43O00A600012O00030001000B3O0020790001000100174O00035O00202O0003000300184O00010003000200062O000100A600013O0004A43O00A600012O00030001000B3O00201B2O01000100194O00035O00202O00030003001A4O00010003000200062O0001008D000100010004A43O008D00012O00030001000E3O0020AF00010001001B2O00122O0100010002000E30011C00A6000100010004A43O00A600012O00030001000F4O00122O0100010002000645000100A6000100010004A43O00A600012O0003000100104O00122O0100010002002670000100A6000100010004A43O00A600012O000300015O0020AF00010001001D00207F00010001000E3O002O0100020002000645000100A6000100010004A43O00A600012O0003000100054O000300025O0020AF0002000200153O002O01000200020006102O0100A600013O0004A43O00A600012O0003000100073O0012D50002001E3O0012D50003001F4O00AA000100034O000E00016O000300015O0020AF00010001001500207F0001000100033O002O01000200020006102O0100E200013O0004A43O00E200012O00030001000D3O0006102O0100E200013O0004A43O00E200012O000300015O0020AF00010001001600207F00010001000E3O002O01000200020006102O0100E200013O0004A43O00E200012O0003000100033O0006102O0100E200013O0004A43O00E200012O00030001000B3O0020790001000100174O00035O00202O0003000300184O00010003000200062O000100E200013O0004A43O00E200012O00030001000B3O00201B2O01000100194O00035O00202O00030003001A4O00010003000200062O000100CB000100010004A43O00CB00012O00030001000E3O0020AF00010001001B2O00122O0100010002000E30011C00E2000100010004A43O00E200012O00030001000F4O00122O0100010002000645000100E2000100010004A43O00E200012O000300015O0020AF00010001001D00207F00010001000E3O002O01000200020006102O0100E200013O0004A43O00E200012O0003000100054O000300025O0020AF0002000200153O002O01000200020006102O0100E200013O0004A43O00E200012O0003000100073O00124A000200203O00122O000300216O000100036O00015O00044O00E200010004A43O000100012O002E012O00017O001A3O00028O00026O00F03F03093O00426C2O6F6446757279030A3O0049734361737461626C6503213O00AE22A444C368181CBE37EB48C85A2O1CBF3AA244C9681D06A322AF44D0590D49F803083O0069CC4ECB2BA7377E030A3O004265727365726B696E6703213O00A7AF310D2O16CC58ABAD631D1C09C544B6BE2A111D3BC45EAAA62711040AD411F303083O0031C5CA437E7364A703093O0046697265626C2O6F6403203O003152CD2C825A51385F9F2A8F5B5C2248CB208F58613454D02584594939489F7103073O003E573BBF49E036030D3O00416E6365737472616C43612O6C03263O00E60CF9CCF416E8C8EB3DF9C8EB0EBACAE80FF8DCF416F3C6E93DF9C6E80EFEC6F00CE989B65203043O00A987629A03083O0054696D655761727003073O0049735265616479030C3O0054656D706F72616C57617270030B3O004973417661696C61626C6503123O00426C2O6F646C75737445786861757374557003213O00DF7E2951C224C9D9676457F23ECADE64305DF23DF7C8782B58F93CDFC52O6405AF03073O00A8AB1744349D53027O0040030F3O0048616E646C65445053506F74696F6E03063O0042752O665570030E3O00436F6D62757374696F6E42752O6600B63O0012D53O00014O00BC000100013O0026703O0085000100020004A43O008500012O000300025O0006100102006300013O0004A43O006300012O0003000200013O0006100102000D00013O0004A43O000D00012O0003000200023O00064500020010000100010004A43O001000012O0003000200013O00064500020063000100010004A43O006300012O0003000200034O0003000300043O0006D700020063000100030004A43O006300010012D5000200013O0026700002003D000100010004A43O003D00012O0003000300053O0020AF00030003000300207F0003000300043O000103000200020006100103002800013O0004A43O002800012O0003000300064O0003000400053O0020AF0004000400033O000103000200020006100103002800013O0004A43O002800012O0003000300073O0012D5000400053O0012D5000500064O00AA000300054O000E00036O0003000300053O0020AF00030003000700207F0003000300043O000103000200020006100103003C00013O0004A43O003C00012O0003000300083O0006100103003C00013O0004A43O003C00012O0003000300064O0003000400053O0020AF0004000400073O000103000200020006100103003C00013O0004A43O003C00012O0003000300073O0012D5000400083O0012D5000500094O00AA000300054O000E00035O0012D5000200023O00267000020015000100020004A43O001500012O0003000300053O0020AF00030003000A00207F0003000300043O000103000200020006100103005000013O0004A43O005000012O0003000300064O0003000400053O0020AF00040004000A3O000103000200020006100103005000013O0004A43O005000012O0003000300073O0012D50004000B3O0012D50005000C4O00AA000300054O000E00036O0003000300053O0020AF00030003000D00207F0003000300043O000103000200020006100103006300013O0004A43O006300012O0003000300064O0003000400053O0020AF00040004000D3O000103000200020006100103006300013O0004A43O006300012O0003000300073O00124A0004000E3O00122O0005000F6O000300056O00035O00044O006300010004A43O001500012O0003000200093O0006100102008400013O0004A43O008400012O0003000200053O0020AF00020002001000207F0002000200113O000102000200020006100102008400013O0004A43O008400012O0003000200053O0020AF00020002001200207F0002000200133O000102000200020006100102008400013O0004A43O008400012O00030002000A3O00207F0002000200143O000102000200020006100102008400013O0004A43O008400012O0003000200064O00EC000300053O00202O0003000300104O000400056O000600016O00020006000200062O0002008400013O0004A43O008400012O0003000200073O0012D5000300153O0012D5000400164O00AA000200044O000E00025O0012D53O00173O000E060001009400013O0004A43O009400012O00030002000B3O00209D0002000200184O0003000A3O00202O0003000300194O000500053O00202O00050005001A4O000300056O00023O00024O000100023O00062O0001009300013O0004A43O009300012O0010000100023O0012D53O00023O0026703O0002000100170004A43O000200012O0003000200034O0003000300043O0006D7000200B5000100030004A43O00B500012O00030002000C3O000610010200B500013O0004A43O00B500012O0003000200023O000610010200A300013O0004A43O00A300012O00030002000D3O000645000200A6000100010004A43O00A600012O00030002000D3O000645000200B5000100010004A43O00B500010012D5000200013O000E06000100A7000100020004A43O00A700012O00030003000F4O00120103000100022O00480003000E4O00030003000E3O000610010300B500013O0004A43O00B500012O00030003000E4O0010000300023O0004A43O00B500010004A43O00A700010004A43O00B500010004A43O000200012O002E012O00017O00663O00028O00026O00F03F030D3O0050686F656E6978466C616D6573030A3O0049734361737461626C6503083O0042752O66446F776E030E3O00436F6D62757374696F6E42752O6603073O0048617354696572026O003E40027O004003083O00496E466C69676874030D3O00446562752O6652656D61696E7303143O004368612O72696E67456D62657273446562752O66026O001040030D3O00486F7453747265616B42752O66030E3O0049735370652O6C496E52616E676503213O00E479FAA82B249FCB77F9AC2O2894B472FAA0273894E078FAA31A3D8FF562F0ED7D03073O00E7941195CD454D030A3O00436F6D62757374696F6E03073O004973526561647903093O00497343617374696E6703063O0053636F726368030E3O004578656375746552656D61696E7303083O004669726562612O6C03093O005079726F626C617374030B3O00466C616D65737472696B6503093O004973496E52616E6765026O004440031E3O0083A8CAF942EC94AEC8F517FC8FAAC5EE44EB89A8C9C447F781B4C2BB06AF03063O009FE0C7A79B37026O00084003093O0046697265426C61737403143O00496D70726F76656453636F726368446562752O6603143O00467572796F6674686553756E4B696E6742752O6603103O004879706572746865726D696142752O6603063O0042752O665570030D3O0048656174696E67557042752O66030A3O0047434452656D61696E73031E3O00F1FA2ED7C8F130D3E4E77CD1F8FE3EC7E4E735DDF9CC2CDAF6E03992A5A303043O00B297935C030C3O004879706572746865726D6961030B3O004973417661696C61626C6503113O00466C616D65737472696B65437572736F72031F3O008AF14D3F175F6E9EF44737524F7581FF592106457582C25C3A135F7FCCAF1E03073O001AEC9D2C52722C031D3O003A37C7542822D4483E6ED654272CC0483E27DA55153EDD5A392B95097E03043O003B4A4EB5031D3O0035C84855B129D0494EF326DE5758A636C55355BD1AC1525BA02091080C03053O00D345B12O3A030E3O004C69676874734A7564676D656E7403223O00BBEC7E2OFDD888EF6CF1EEC6B2EB6DB5EAC4BAE76CE6FDC2B8EB46E5E1CAA4E039A703063O00ABD785199589030B3O004261676F66547269636B7303203O00E3C935C5E036C356F3C131F1FC70FF4DECCA27E9FB39F34CDED83AFBFC35BC1603083O002281A8529A8F509C030A3O004C6976696E67426F6D62031E3O0089BB25024649B687BD3E09084D8688B026185C47868B8D2303495D8CC5E403073O00E9E5D2536B282E030B3O0042752O6652656D61696E73026O00344003083O004361737454696D65030F3O00432O6F6C646F776E52656D61696E73031F3O00C74E33DB00D25620DF0EC40231D908C35721C20CCE4C0DC60DC0513796549303053O0065A12252B6031D3O00F8144BF1D9EE833DFC4D5AF1D6E0973DFC0456F0E4F28A2FFB0819AF8F03083O004E886D399EBB82E2031C3O003836EBF43C3EF5FD7E3CF6FC3C2AEAE53730F7CE2E37F8E23B7FA8A703043O00915E5F99031A3O00EECE1BC74DBFBDCE1BD84CA2EED91DDA4088EDC515C64BF7AC9503063O00D79DAD74B52E026O001440031A3O0026B784E0D93DF488FDD737A198E6D33ABAB4E2D234A78EB2896303053O00BA55D4EB92030A3O0054726176656C54696D6503093O0042752O66537461636B030E3O00466C616D65734675727942752O6603223O00D28919FB37E740FD871AFF34EB4B2O8219F33BFB4BD68819F006FE50C39213BE6AB603073O0038A2E1769E598E03133O00466C616D65412O63656C6572616E7442752O66031C3O005A0CD2AA20D9500980AC2DD55E10D3BB2BD7523AD0A723CB594594FF03063O00B83C65A0CF4203103O00416C657873747261737A61734675727903223O00218A73B93F8B6483378E7DB134913CBF3E8F7EA9229675B33FBD6CB4309179FC65D003043O00DC51E21C026O001840031A4O00D68D2OE9CF53D68DF6E8D200C18BF4E4F803DD83E8EF87478103063O00A773B5E29B8A031C3O00E42BF5597970CAEE62E4537673D3F136EE53754ED6EA23F4593B259003073O00A68242873C1B11031F3O004843D87C3E4375CC7A3D460ACD7A3D465FDD61394B44F165384559CB35641C03053O0050242AAE1503083O005072657647434450031D3O005E0925754C1C36695A503475431222695A19387471003F7B5D1577281603043O001A2E7057030D3O005368696674696E67506F77657203073O0043686172676573030A3O004D61784368617267657303223O00AA2BA272ABB64BB38633A463BAAD05B7B62EA961ACAB4CBBB71CBB7CBEAC40F4EA7303083O00D4D943CB142ODF25031F3O00BC81A9DFBF9EBCC0B386AD92B982A5D0AF9EBCDBB58397C2B28CBBD7FADEFA03043O00B2DAEDC8031D3O00A6ACF4DFB4B9E7C3A2F5E5DFBBB7F3C3A2BCE9DE89A5EED1A5B0A683E203043O00B0D6D5860045052O0012D53O00013O000E06000200B400013O0004A43O00B400012O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01004100013O0004A43O004100012O0003000100013O0006102O01004100013O0004A43O004100012O0003000100023O0020790001000100054O00035O00202O0003000300064O00010003000200062O0001004100013O0004A43O004100012O0003000100023O0020DB00010001000700122O000300083O00122O000400096O00010004000200062O0001004100013O0004A43O004100012O000300015O0020AF00010001000300207F00010001000A3O002O010002000200064500010041000100010004A43O004100012O0003000100033O0020D800010001000B4O00035O00202O00030003000C4O0001000300024O000200043O00102O0002000D000200062O00010041000100020004A43O004100012O0003000100023O0020790001000100054O00035O00202O00030003000E4O00010003000200062O0001004100013O0004A43O004100012O0003000100054O008C00025O00202O0002000200034O000300033O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001004100013O0004A43O004100012O0003000100063O0012D5000200103O0012D5000300114O00AA000100034O000E00016O0003000100084O00122O01000100022O0048000100074O0003000100073O0006102O01004900013O0004A43O004900012O0003000100074O0010000100024O000300015O0020AF00010001001200207F0001000100133O002O01000200020006102O0100B300013O0004A43O00B300012O0003000100093O0006102O0100B300013O0004A43O00B300012O00030001000A3O0006102O01005800013O0004A43O005800012O00030001000B3O0006450001005B000100010004A43O005B00012O00030001000A3O000645000100B3000100010004A43O00B300012O00030001000C4O00030002000D3O0006D7000100B3000100020004A43O00B300012O00030001000E4O00122O0100010002002670000100B3000100010004A43O00B300012O00030001000F3O0006102O0100B300013O0004A43O00B300012O0003000100103O0026E7000100B3000100010004A43O00B300012O0003000100023O0020790001000100144O00035O00202O0003000300154O00010003000200062O0001007700013O0004A43O007700012O000300015O0020C500010001001500202O0001000100164O0001000200024O000200113O00062O000100A1000100020004A43O00A100012O0003000100023O0020790001000100144O00035O00202O0003000300174O00010003000200062O0001008500013O0004A43O008500012O000300015O0020C500010001001700202O0001000100164O0001000200024O000200113O00062O000100A1000100020004A43O00A100012O0003000100023O0020790001000100144O00035O00202O0003000300184O00010003000200062O0001009300013O0004A43O009300012O000300015O0020C500010001001800202O0001000100164O0001000200024O000200113O00062O000100A1000100020004A43O00A100012O0003000100023O0020790001000100144O00035O00202O0003000300194O00010003000200062O000100B300013O0004A43O00B300012O000300015O0020F200010001001900202O0001000100164O0001000200024O000200113O00062O000100B3000100020004A43O00B300012O0003000100054O009A00025O00202O0002000200124O000300033O00202O00030003001A00122O0005001B6O0003000500024O000300036O000400046O000500016O0001000500020006102O0100B300013O0004A43O00B300012O0003000100063O0012D50002001C3O0012D50003001D4O00AA000100034O000E00015O0012D53O00093O000E06001E00A12O013O0004A43O00A12O012O000300015O0020AF00010001001F00207F0001000100133O002O01000200020006102O0100222O013O0004A43O00222O012O0003000100123O0006102O0100222O013O0004A43O00222O012O0003000100134O00122O0100010002000645000100222O0100010004A43O00222O012O0003000100143O000645000100222O0100010004A43O00222O012O0003000100154O00122O01000100020006102O0100DA00013O0004A43O00DA00012O0003000100023O00201B2O01000100144O00035O00202O0003000300154O00010003000200062O000100DA000100010004A43O00DA00012O0003000100033O0020D800010001000B4O00035O00202O0003000300204O0001000300024O000200043O00102O0002000D000200062O000200222O0100010004A43O00222O012O0003000100023O00201B2O01000100054O00035O00202O0003000300214O00010003000200062O000100E8000100010004A43O00E800012O0003000100023O0020790001000100144O00035O00202O0003000300184O00010003000200062O000100222O013O0004A43O00222O012O0003000100163O0006102O0100222O013O0004A43O00222O012O0003000100023O0020790001000100054O00035O00202O0003000300224O00010003000200062O000100222O013O0004A43O00222O012O0003000100023O0020790001000100054O00035O00202O00030003000E4O00010003000200062O000100222O013O0004A43O00222O012O00030001000E4O00760001000100024O000200176O000300023O00202O0003000300234O00055O00202O0005000500244O000300056O00023O00024O000300176O000400023O00207F0004000400253O00010400020002000E172O0100092O0100040004A43O00092O012O003A00046O007D000400015O000103000200022O00C20002000200032O00BB0001000100020026AE000100222O0100090004A43O00222O012O0003000100054O009100025O00202O00020002001F4O000300033O00202O00030003000F4O00055O00202O00050005001F4O0003000500024O000300036O000400046O000500016O00010005000200062O000100222O013O0004A43O00222O012O0003000100063O0012D5000200263O0012D5000300274O00AA000100034O000E00016O0003000100183O0006102O01005B2O013O0004A43O005B2O012O000300015O0020AF00010001001900207F0001000100133O002O01000200020006102O01005B2O013O0004A43O005B2O012O0003000100193O0006102O01005B2O013O0004A43O005B2O012O0003000100023O0020790001000100234O00035O00202O00030003000E4O00010003000200062O000100392O013O0004A43O00392O012O00030001001A4O00030002001B3O0006F300020013000100010004A43O004B2O012O0003000100023O0020790001000100234O00035O00202O0003000300224O00010003000200062O0001005B2O013O0004A43O005B2O012O00030001001A4O001E0102001B6O000300176O00045O00202O00040004002800202O0004000400294O000400056O00033O00024O00020002000300062O0002005B2O0100010004A43O005B2O012O0003000100054O00240002001C3O00202O00020002002A4O000300033O00202O00030003001A00122O0005001B6O0003000500024O000300036O00010003000200062O0001005B2O013O0004A43O005B2O012O0003000100063O0012D50002002B3O0012D50003002C4O00AA000100034O000E00016O000300015O0020AF00010001001800207F0001000100133O002O01000200020006102O01007C2O013O0004A43O007C2O012O00030001001D3O0006102O01007C2O013O0004A43O007C2O012O0003000100023O0020790001000100234O00035O00202O0003000300224O00010003000200062O0001007C2O013O0004A43O007C2O012O0003000100054O008C00025O00202O0002000200184O000300033O00202O00030003000F4O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001007C2O013O0004A43O007C2O012O0003000100063O0012D50002002D3O0012D50003002E4O00AA000100034O000E00016O000300015O0020AF00010001001800207F0001000100133O002O01000200020006102O0100A02O013O0004A43O00A02O012O00030001001D3O0006102O0100A02O013O0004A43O00A02O012O0003000100023O0020790001000100234O00035O00202O00030003000E4O00010003000200062O000100A02O013O0004A43O00A02O012O0003000100163O0006102O0100A02O013O0004A43O00A02O012O0003000100054O008C00025O00202O0002000200184O000300033O00202O00030003000F4O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O000100A02O013O0004A43O00A02O012O0003000100063O0012D50002002F3O0012D5000300304O00AA000100034O000E00015O0012D53O000D3O000E060001002D02013O0004A43O002D02012O000300015O0020AF00010001003100207F0001000100043O002O01000200020006102O0100CD2O013O0004A43O00CD2O012O00030001001E3O0006102O0100CD2O013O0004A43O00CD2O012O00030001001F3O0006102O0100B22O013O0004A43O00B22O012O00030001000B3O000645000100B52O0100010004A43O00B52O012O00030001001F3O000645000100CD2O0100010004A43O00CD2O012O00030001000C4O00030002000D3O0006D7000100CD2O0100020004A43O00CD2O012O00030001000F3O0006102O0100CD2O013O0004A43O00CD2O012O0003000100054O008C00025O00202O0002000200314O000300033O00202O00030003000F4O00055O00202O0005000500314O0003000500024O000300036O00010003000200062O000100CD2O013O0004A43O00CD2O012O0003000100063O0012D5000200323O0012D5000300334O00AA000100034O000E00016O000300015O0020AF00010001003400207F0001000100043O002O01000200020006102O0100F12O013O0004A43O00F12O012O00030001001E3O0006102O0100F12O013O0004A43O00F12O012O00030001001F3O0006102O0100DC2O013O0004A43O00DC2O012O00030001000B3O000645000100DF2O0100010004A43O00DF2O012O00030001001F3O000645000100F12O0100010004A43O00F12O012O00030001000C4O00030002000D3O0006D7000100F12O0100020004A43O00F12O012O00030001000F3O0006102O0100F12O013O0004A43O00F12O012O0003000100054O000300025O0020AF0002000200343O002O01000200020006102O0100F12O013O0004A43O00F12O012O0003000100063O0012D5000200353O0012D5000300364O00AA000100034O000E00016O000300015O0020AF00010001003700207F0001000100133O002O01000200020006102O01001402013O0004A43O001402012O0003000100183O0006102O01001402013O0004A43O001402012O0003000100203O0006102O01001402013O0004A43O001402012O0003000100213O000E3001020014020100010004A43O001402012O00030001000F3O0006102O01001402013O0004A43O001402012O0003000100054O008C00025O00202O0002000200374O000300033O00202O00030003000F4O00055O00202O0005000500374O0003000500024O000300036O00010003000200062O0001001402013O0004A43O001402012O0003000100063O0012D5000200383O0012D5000300394O00AA000100034O000E00016O0003000100023O00209300010001003A4O00035O00202O0003000300064O0001000300024O000200223O00062O0002001F020100010004A43O001F02012O00030001000D3O0026AE0001002C0201003B0004A43O002C02010012D5000100013O00267000010020020100010004A43O002002012O0003000200234O00120102000100022O0048000200074O0003000200073O0006100102002C02013O0004A43O002C02012O0003000200074O0010000200023O0004A43O002C02010004A43O002002010012D53O00023O000E060009000103013O0004A43O000103012O0003000100183O0006102O01007502013O0004A43O007502012O000300015O0020AF00010001001900207F0001000100133O002O01000200020006102O01007502013O0004A43O007502012O0003000100193O0006102O01007502013O0004A43O007502012O0003000100023O00201B2O01000100144O00035O00202O0003000300194O00010003000200062O00010075020100010004A43O007502012O00030001000F3O0006102O01007502013O0004A43O007502012O0003000100023O0020790001000100234O00035O00202O0003000300214O00010003000200062O0001007502013O0004A43O007502012O0003000100023O00208400010001003A4O00035O00202O0003000300214O0001000300024O00025O00202O00020002001900202O00020002003C4O00020002000200062O00020075020100010004A43O007502012O000300015O0020B000010001001200202O00010001003D4O0001000200024O00025O00202O00020002001900202O00020002003C4O00020002000200062O00010075020100020004A43O007502012O00030001001A4O0003000200243O00068F00020075020100010004A43O007502012O0003000100054O00240002001C3O00202O00020002002A4O000300033O00202O00030003001A00122O0005001B6O0003000500024O000300036O00010003000200062O0001007502013O0004A43O007502012O0003000100063O0012D50002003E3O0012D50003003F4O00AA000100034O000E00016O000300015O0020AF00010001001800207F0001000100133O002O01000200020006102O0100AB02013O0004A43O00AB02012O00030001001D3O0006102O0100AB02013O0004A43O00AB02012O0003000100023O00201B2O01000100144O00035O00202O0003000300184O00010003000200062O000100AB020100010004A43O00AB02012O00030001000F3O0006102O0100AB02013O0004A43O00AB02012O0003000100023O0020790001000100234O00035O00202O0003000300214O00010003000200062O000100AB02013O0004A43O00AB02012O0003000100023O00208400010001003A4O00035O00202O0003000300214O0001000300024O00025O00202O00020002001800202O00020002003C4O00020002000200062O000200AB020100010004A43O00AB02012O0003000100054O008C00025O00202O0002000200184O000300033O00202O00030003000F4O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O000100AB02013O0004A43O00AB02012O0003000100063O0012D5000200403O0012D5000300414O00AA000100034O000E00016O000300015O0020AF00010001001700207F0001000100133O002O01000200020006102O0100D902013O0004A43O00D902012O0003000100253O0006102O0100D902013O0004A43O00D902012O00030001000F3O0006102O0100D902013O0004A43O00D902012O000300015O0020B000010001001200202O00010001003D4O0001000200024O00025O00202O00020002001700202O00020002003C4O00020002000200062O000100D9020100020004A43O00D902012O00030001001A3O0026AE000100D9020100090004A43O00D902012O0003000100154O00122O0100010002000645000100D9020100010004A43O00D902012O0003000100054O008C00025O00202O0002000200174O000300033O00202O00030003000F4O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O000100D902013O0004A43O00D902012O0003000100063O0012D5000200423O0012D5000300434O00AA000100034O000E00016O000300015O0020AF00010001001500207F0001000100133O002O01000200020006102O012O0003013O0004A44O0003012O0003000100263O0006102O012O0003013O0004A44O0003012O00030001000F3O0006102O012O0003013O0004A44O0003012O000300015O0020B000010001001200202O00010001003D4O0001000200024O00025O00202O00020002001500202O00020002003C4O00020002000200062O00012O00030100020004A44O0003012O0003000100054O008C00025O00202O0002000200154O000300033O00202O00030003000F4O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O00012O0003013O0004A44O0003012O0003000100063O0012D5000200443O0012D5000300454O00AA000100034O000E00015O0012D53O001E3O0026703O00E8030100460004A43O00E803012O000300015O0020AF00010001001500207F0001000100133O002O01000200020006102O01002E03013O0004A43O002E03012O0003000100263O0006102O01002E03013O0004A43O002E03012O0003000100154O00122O01000100020006102O01002E03013O0004A43O002E03012O0003000100033O0020D800010001000B4O00035O00202O0003000300204O0001000300024O000200043O00102O0002000D000200062O0001002E030100020004A43O002E03012O0003000100274O00030002001B3O0006D70001002E030100020004A43O002E03012O0003000100054O008C00025O00202O0002000200154O000300033O00202O00030003000F4O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O0001002E03013O0004A43O002E03012O0003000100063O0012D5000200473O0012D5000300484O00AA000100034O000E00016O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01007D03013O0004A43O007D03012O0003000100013O0006102O01007D03013O0004A43O007D03012O0003000100023O0020DB00010001000700122O000300083O00122O000400096O00010004000200062O0001007D03013O0004A43O007D03012O000300015O00200F2O010001000300202O0001000100494O0001000200024O000200023O00202O00020002003A4O00045O00202O0004000400064O00020004000200062O0001007D030100020004A43O007D03012O0003000100174O0090000200023O00202O0002000200234O00045O00202O0004000400244O000200046O00013O00024O0002000E6O0002000100024O00010001000200262O0001007D030100090004A43O007D03012O0003000100033O0020C600010001000B4O00035O00202O00030003000C4O0001000300024O000200043O00102O0002000D000200062O0001006C030100020004A43O006C03012O0003000100023O00203900010001004A4O00035O00202O00030003004B4O000100030002000E2O0002006C030100010004A43O006C03012O0003000100023O0020790001000100234O00035O00202O00030003004B4O00010003000200062O0001007D03013O0004A43O007D03012O0003000100054O008C00025O00202O0002000200034O000300033O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001007D03013O0004A43O007D03012O0003000100063O0012D50002004C3O0012D50003004D4O00AA000100034O000E00016O000300015O0020AF00010001001700207F0001000100133O002O01000200020006102O0100A903013O0004A43O00A903012O0003000100253O0006102O0100A903013O0004A43O00A903012O0003000100023O00208400010001003A4O00035O00202O0003000300064O0001000300024O00025O00202O00020002001700202O00020002003C4O00020002000200062O000200A9030100010004A43O00A903012O0003000100023O0020790001000100234O00035O00202O00030003004E4O00010003000200062O000100A903013O0004A43O00A903012O0003000100054O008C00025O00202O0002000200174O000300033O00202O00030003000F4O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O000100A903013O0004A43O00A903012O0003000100063O0012D50002004F3O0012D5000300504O00AA000100034O000E00016O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O0100E703013O0004A43O00E703012O0003000100013O0006102O0100E703013O0004A43O00E703012O0003000100023O0020022O010001000700122O000300083O00122O000400096O00010004000200062O000100E7030100010004A43O00E703012O000300015O0020AF00010001005100207F0001000100293O002O0100020002000645000100E7030100010004A43O00E703012O000300015O00200F2O010001000300202O0001000100494O0001000200024O000200023O00202O00020002003A4O00045O00202O0004000400064O00020004000200062O000100E7030100020004A43O00E703012O0003000100174O0090000200023O00202O0002000200234O00045O00202O0004000400244O000200046O00013O00024O0002000E6O0002000100024O00010001000200262O000100E7030100090004A43O00E703012O0003000100054O008C00025O00202O0002000200034O000300033O00202O00030003000F4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100E703013O0004A43O00E703012O0003000100063O0012D5000200523O0012D5000300534O00AA000100034O000E00015O0012D53O00543O0026703O0061040100540004A43O006104012O000300015O0020AF00010001001500207F0001000100133O002O01000200020006102O01001604013O0004A43O001604012O0003000100263O0006102O01001604013O0004A43O001604012O0003000100023O00208400010001003A4O00035O00202O0003000300064O0001000300024O00025O00202O00020002001500202O00020002003C4O00020002000200062O00020016040100010004A43O001604012O000300015O00208A00010001001500202O00010001003C4O0001000200024O000200043O00062O00020016040100010004A43O001604012O0003000100054O008C00025O00202O0002000200154O000300033O00202O00030003000F4O00055O00202O0005000500154O0003000500024O000300036O00010003000200062O0001001604013O0004A43O001604012O0003000100063O0012D5000200553O0012D5000300564O00AA000100034O000E00016O000300015O0020AF00010001001700207F0001000100133O002O01000200020006102O01003B04013O0004A43O003B04012O0003000100253O0006102O01003B04013O0004A43O003B04012O0003000100023O00208400010001003A4O00035O00202O0003000300064O0001000300024O00025O00202O00020002001700202O00020002003C4O00020002000200062O0002003B040100010004A43O003B04012O0003000100054O008C00025O00202O0002000200174O000300033O00202O00030003000F4O00055O00202O0005000500174O0003000500024O000300036O00010003000200062O0001003B04013O0004A43O003B04012O0003000100063O0012D5000200573O0012D5000300584O00AA000100034O000E00016O000300015O0020AF00010001003700207F0001000100133O002O01000200020006102O01004405013O0004A43O004405012O0003000100203O0006102O01004405013O0004A43O004405012O0003000100023O00202D00010001003A4O00035O00202O0003000300064O0001000300024O000200043O00062O00010044050100020004A43O004405012O0003000100213O000E3001020044050100010004A43O004405012O0003000100054O008C00025O00202O0002000200374O000300033O00202O00030003000F4O00055O00202O0005000500374O0003000500024O000300036O00010003000200062O0001004405013O0004A43O004405012O0003000100063O00124A000200593O00122O0003005A6O000100036O00015O00044O004405010026703O00010001000D0004A43O000100012O000300015O0020AF00010001001800207F0001000100133O002O01000200020006102O01009304013O0004A43O009304012O00030001001D3O0006102O01009304013O0004A43O009304012O0003000100023O00203600010001005B00122O000300026O00045O00202O0004000400154O0001000400020006102O01009304013O0004A43O009304012O0003000100023O0020790001000100234O00035O00202O0003000300244O00010003000200062O0001009304013O0004A43O009304012O00030001001A4O00030002001B3O0006D700010093040100020004A43O009304012O0003000100163O0006102O01009304013O0004A43O009304012O0003000100054O008C00025O00202O0002000200184O000300033O00202O00030003000F4O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001009304013O0004A43O009304012O0003000100063O0012D50002005C3O0012D50003005D4O00AA000100034O000E00016O000300015O0020AF00010001005E00207F0001000100133O002O01000200020006102O0100D604013O0004A43O00D604012O0003000100283O0006102O0100D604013O0004A43O00D604012O0003000100293O0006102O0100A204013O0004A43O00A204012O00030001000B3O000645000100A5040100010004A43O00A504012O0003000100293O000645000100D6040100010004A43O00D604012O00030001000C4O00030002000D3O0006D7000100D6040100020004A43O00D604012O0003000100163O0006102O0100D604013O0004A43O00D604012O000300015O0020AF00010001001F00207F00010001005F3O002O0100020002002670000100D6040100010004A43O00D604012O000300015O00200B2O010001000300202O00010001005F4O0001000200024O00025O00202O00020002000300202O0002000200604O00020002000200062O000100C2040100020004A43O00C204012O000300015O0020AF00010001005100207F0001000100293O002O01000200020006102O0100D604013O0004A43O00D604012O00030001002A4O00030002001A3O00068F000100D6040100020004A43O00D604012O0003000100054O002400025O00202O00020002005E4O000300033O00202O00030003001A00122O0005001B6O0003000500024O000300036O00010003000200062O000100D604013O0004A43O00D604012O0003000100063O0012D5000200613O0012D5000300624O00AA000100034O000E00016O0003000100183O0006102O01000F05013O0004A43O000F05012O000300015O0020AF00010001001900207F0001000100133O002O01000200020006102O01000F05013O0004A43O000F05012O0003000100193O0006102O01000F05013O0004A43O000F05012O0003000100023O00201B2O01000100144O00035O00202O0003000300194O00010003000200062O0001000F050100010004A43O000F05012O0003000100023O0020790001000100234O00035O00202O0003000300214O00010003000200062O0001000F05013O0004A43O000F05012O0003000100023O00208400010001003A4O00035O00202O0003000300214O0001000300024O00025O00202O00020002001900202O00020002003C4O00020002000200062O0002000F050100010004A43O000F05012O00030001001A4O0003000200243O00068F0002000F050100010004A43O000F05012O0003000100054O00240002001C3O00202O00020002002A4O000300033O00202O00030003001A00122O0005001B6O0003000500024O000300036O00010003000200062O0001000F05013O0004A43O000F05012O0003000100063O0012D5000200633O0012D5000300644O00AA000100034O000E00016O000300015O0020AF00010001001800207F0001000100133O002O01000200020006102O01004205013O0004A43O004205012O00030001001D3O0006102O01004205013O0004A43O004205012O0003000100023O00201B2O01000100144O00035O00202O0003000300184O00010003000200062O00010042050100010004A43O004205012O0003000100023O0020790001000100234O00035O00202O0003000300214O00010003000200062O0001004205013O0004A43O004205012O0003000100023O00208400010001003A4O00035O00202O0003000300214O0001000300024O00025O00202O00020002001800202O00020002003C4O00020002000200062O00020042050100010004A43O004205012O0003000100054O008C00025O00202O0002000200184O000300033O00202O00030003000F4O00055O00202O0005000500184O0003000500024O000300036O00010003000200062O0001004205013O0004A43O004205012O0003000100063O0012D5000200653O0012D5000300664O00AA000100034O000E00015O0012D53O00463O0004A43O000100012O002E012O00017O00183O00028O00026O00F03F030B3O004669726573746172746572030B3O004973417661696C61626C65027O0040030A3O00436F6D62757374696F6E030F3O00432O6F6C646F776E52656D61696E7303083O004669726562612O6C03083O004361737454696D65030B3O00466C616D65737472696B65026O33D33F026O000840029A5O99C93F029A5O99D93F03083O004B696E646C696E67026O005E40026O00344003103O0053756E4B696E6773426C652O73696E6703083O0042752O66446F776E03143O00467572796F6674686553756E4B696E6742752O6603093O0042752O66537461636B03143O0053756E4B696E6773426C652O73696E6742752O66030B3O0042752O6652656D61696E73030E3O00436F6D62757374696F6E42752O6600893O0012D53O00013O0026703O0015000100020004A43O001500012O0003000100014O006000018O000100023O00202O00010001000300202O0001000100044O00010002000200062O0001001400013O0004A43O001400012O0003000100033O00064500010014000100010004A43O001400012O0003000100044O0024010200056O0002000100024O00038O0001000300024O00015O0012D53O00053O0026703O003C000100010004A43O003C00012O0003000100023O00208600010001000600202O0001000100074O0001000200024O000200066O0001000100024O000100016O000100023O00202O00010001000800202O0001000100094O0001000200022O0003000200084O0003000300094O00030004000A3O0006E900030028000100040004A43O002800012O003A00036O007D000300014O00060102000200024O0001000100024O000200023O00202O00020002000A00202O0002000200094O0002000200024O000300086O000400096O0005000A3O00062O00050002000100040004A43O003500012O003A00046O007D000400014O00850003000200024O0002000200034O00010001000200202O00010001000B4O000100073O00124O00023O0026703O005C0001000C0004A43O005C00012O0003000100014O00E8000200086O000300023O00202O00030003000300202O0003000300044O000300046O00023O000200102O0002000D000200102O0002000E00024O000300086O000400023O0020AF00040004000F0020830004000400044O000400056O00033O00024O00020002000300102O00020002000200102O0002001000024O0001000100024O00025O00062O00010006000100020004A43O005900012O000300016O00030002000B3O0020690002000200110006D700020088000100010004A43O008800012O0003000100014O004800015O0004A43O008800010026703O0001000100050004A43O000100012O0003000100023O0020AF00010001001200207F0001000100043O002O01000200020006102O01007D00013O0004A43O007D00012O00030001000C4O00122O01000100020006102O01007D00013O0004A43O007D00012O00030001000D3O0020790001000100134O000300023O00202O0003000300144O00010003000200062O0001007D00013O0004A43O007D00012O0003000100044O002E0002000E6O0003000D3O00202O0003000300154O000500023O00202O0005000500164O0003000500024O00020002000300202O00020002000C4O0003000F6O0002000200034O00038O0001000300024O00016O0003000100044O00250102000D3O00202O0002000200174O000400023O00202O0004000400184O0002000400024O00038O0001000300024O00015O00124O000C3O00044O000100012O002E012O00017O00173O00028O0003093O0046697265426C61737403073O004973526561647903083O0042752O66446F776E030D3O00486F7453747265616B42752O6603063O0042752O665570030D3O0048656174696E67557042752O66026O00F03F030D3O005368696674696E67506F776572030A3O00432O6F6C646F776E557003073O0043686172676573030B3O0042752O6652656D61696E73030F3O00462O656C7468654275726E42752O66027O0040030E3O0049735370652O6C496E52616E676503243O00F22OA4D1975455F5BEA294AE5F4BF1BEA2D5BA425CE692B0DDBA5366F6A1B7C7BC4519A603073O003994CDD6B4C83603073O0048617354696572026O003E40030D3O00446562752O6652656D61696E7303143O004368612O72696E67456D62657273446562752O6603243O0014F427314910F134276252FB3C267301E934266217EF0A327F00F80A367A13EE2127364603053O0016729D555400963O0012D53O00013O0026703O0001000100010004A43O000100012O000300015O0020AF00010001000200207F0001000100033O002O01000200020006102O01004E00013O0004A43O004E00012O0003000100013O0006102O01004E00013O0004A43O004E00012O0003000100024O00122O01000100020006450001004E000100010004A43O004E00012O0003000100033O0006450001004E000100010004A43O004E00012O0003000100043O0020790001000100044O00035O00202O0003000300054O00010003000200062O0001004E00013O0004A43O004E00012O0003000100054O0066000200043O00202O0002000200064O00045O00202O0004000400074O000200046O00013O00024O000200066O0002000100024O00010001000200262O0001004E000100080004A43O004E00012O000300015O0020AF00010001000900207F00010001000A3O002O01000200020006450001003B000100010004A43O003B00012O000300015O0020AF00010001000200207F00010001000B3O002O0100020002000E170108003B000100010004A43O003B00012O0003000100043O0020D800010001000C4O00035O00202O00030003000D4O0001000300024O000200073O00102O0002000E000200062O0001004E000100020004A43O004E00012O0003000100084O009100025O00202O0002000200024O000300093O00202O00030003000F4O00055O00202O0005000500024O0003000500024O000300036O000400046O000500016O00010005000200062O0001004E00013O0004A43O004E00012O00030001000A3O0012D5000200103O0012D5000300114O00AA000100034O000E00016O000300015O0020AF00010001000200207F0001000100033O002O01000200020006102O01009500013O0004A43O009500012O0003000100013O0006102O01009500013O0004A43O009500012O0003000100024O00122O010001000200064500010095000100010004A43O009500012O0003000100033O00064500010095000100010004A43O009500012O0003000100054O0066000200043O00202O0002000200064O00045O00202O0004000400074O000200046O00013O00024O000200066O0002000100024O00010001000200262O00010095000100080004A43O009500012O000300015O0020AF00010001000900207F00010001000A3O002O01000200020006102O01009500013O0004A43O009500012O0003000100043O0020DB00010001001200122O000300133O00122O0004000E6O00010004000200062O0001008000013O0004A43O008000012O0003000100093O0020D80001000100144O00035O00202O0003000300154O0001000300024O000200073O00102O0002000E000200062O00020095000100010004A43O009500012O0003000100084O009100025O00202O0002000200024O000300093O00202O00030003000F4O00055O00202O0005000500024O0003000500024O000300036O000400046O000500016O00010005000200062O0001009500013O0004A43O009500012O00030001000A3O00124A000200163O00122O000300176O000100036O00015O00044O009500010004A43O000100012O002E012O00017O00583O00028O00026O00F03F03063O0053636F72636803073O0049735265616479030D3O00446562752O6652656D61696E7303143O00496D70726F76656453636F726368446562752O6603093O005079726F626C61737403083O004361737454696D65026O00144003063O0042752O66557003143O00467572796F6674686553756E4B696E6742752O6603093O00497343617374696E67030E3O0049735370652O6C496E52616E6765031B3O00D7C81CD65EFEE8D7DF12CA59F7BAC0F401CB49F7BCCDC41D840CA503073O00C8A4AB73A43D96031E3O00AEED114A81B2F51051C3ADE0024B87BFE6077A91B1E002518AB1FA4314D703053O00E3DE94632503093O0046697265426C61737403083O0042752O66446F776E03083O004669726562612O6C030E3O004578656375746552656D61696E73030C3O004879706572746865726D6961030B3O004973417661696C61626C65030D3O0048656174696E67557042752O66030B3O00446562752O66537461636B03103O0046752O6C526563686172676554696D65026O000840030D3O00486F7453747265616B42752O66031F3O00355B40F3C6315E53E5ED7341462OF7375340F2C6215D46F7ED3A5D5CB6A86503053O0099532O3296027O0040030D3O00447261676F6E7342726561746803103O00416C657873747261737A61734675727903233O005964721B7CA55E6274611972BF451D65671D7DAF4C4F724C0E7CBF4C497F7C1233F91503073O002D3D16137C13CB031B3O00D21102E70178F9D2060CFB0671ABC52D1FFA1671ADC81D03B5512003073O00D9A1726D956210030F3O00417263616E654578706C6F73696F6E030F3O004D616E6150657263656E746167655003093O004973496E52616E6765026O003E4003253O0013323B7DB2712D25206CB07B01293772FC6706213678BD66161F2A73A87506293772FC274003063O00147240581CDC026O001840030B3O00466C616D65737472696B6503113O00466C616D65737472696B65437572736F72026O00444003203O00370DD3B9FDC3A92308D9B1B8C3A9300FD6B5EAD482230EC6B5ECD9B23F4181E003073O00DD5161B2D498B0030E3O0054656D7065726564466C616D657303133O00466C616D65412O63656C6572616E7442752O66031E3O00DDFE0FF418C1E60EEF5ADEF31CF51ECCF519C408C2F31CEF13C2E95DA84F03053O007AAD877D9B031D3O0082C812BC3D30C4888113AD3E3FCC85D304862D3EDC85D509B631719BD203073O00A8E4A160D95F51031F3O002ODD2F512A44CFC327572A17C8C52F522B56C9D5114E2043DAC5275321178903063O0037BBB14E3C4F031D3O003DD74DE444C3813EDA1FF852CE8E29CF4DEF79DD8F39CF4BE249C1C07903073O00E04DAE3F8B26AF03203O00824D592381524C3C8D4A5D6E9755592080404A2ABB53573A855551218A01097C03043O004EE4213803083O005072657647434450031E3O00DE67A00C87C27FA117C5DD6AB30D81CF6CB63C97C16AB3178CC170F252DD03053O00E5AE1ED263026O001040031B3O0008EE8943EE357908F9875FE93C2B1FD2945EF93C2D12E28811BC6403073O00597B8DE6318D5D030D3O0050686F656E6978466C616D6573030A3O0049734361737461626C65030B3O00462O656C7468654275726E030B3O0042752O6652656D61696E73030F3O00462O656C7468654275726E42752O6603233O00E379F9091E43EB4EF0001147F662B61F044BFD75F71E1475E17EE20D0443FC7FB65E4003063O002A9311966C70030E3O00466C616D65734675727942752O6603113O00436861726765734672616374696F6E616C026O000440026O00F83F03233O001FAE227AE9E117992B73E6E50AB56D6CF3E901A22C6DE3D71DA9397EF3E100A86D2DB103063O00886FC64D1F8703073O004861735469657203143O004368612O72696E67456D62657273446562752O6603233O001201A853B3ED0F960405A65BB8F757BA1608A952BCF613961006B357A9ED18A7425BF603083O00C96269C736DD8477031B3O00AA0F8C33013DECAA18822F0634BEBD33912E1634B8B0038D61506703073O00CCD96CE341625503233O004ECBFAE022C946FCF3E92DCD5BD0B5F638C150C7F4F728FF4CCCE1E438C951CDB5B77803063O00A03EA395854C00C0032O0012D53O00013O0026703O003O0100020004A43O003O012O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01003D00013O0004A43O003D00012O0003000100013O0006102O01003D00013O0004A43O003D00012O0003000100024O00122O01000100020006102O01003D00013O0004A43O003D00012O0003000100033O00204E0001000100054O00035O00202O0003000300064O0001000300024O00025O00202O00020002000700202O0002000200084O0002000200024O000300043O00102O0003000900034O00020002000300062O0001003D000100020004A43O003D00012O0003000100053O00207900010001000A4O00035O00202O00030003000B4O00010003000200062O0001003D00013O0004A43O003D00012O0003000100053O00201B2O010001000C4O00035O00202O0003000300034O00010003000200062O0001003D000100010004A43O003D00012O0003000100064O008C00025O00202O0002000200034O000300033O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001003D00013O0004A43O003D00012O0003000100073O0012D50002000E3O0012D50003000F4O00AA000100034O000E00016O000300015O0020AF00010001000700207F0001000100043O002O01000200020006102O01006600013O0004A43O006600012O0003000100083O0006102O01006600013O0004A43O006600012O0003000100053O00201B2O010001000C4O00035O00202O0003000300074O00010003000200062O00010066000100010004A43O006600012O0003000100053O00207900010001000A4O00035O00202O00030003000B4O00010003000200062O0001006600013O0004A43O006600012O0003000100064O002100025O00202O0002000200074O000300033O00202O00030003000D4O00055O00202O0005000500074O0003000500024O000300036O000400016O00010004000200062O0001006600013O0004A43O006600012O0003000100073O0012D5000200103O0012D5000300114O00AA000100034O000E00016O000300015O0020AF00010001001200207F0001000100043O002O01000200020006102O012O002O013O0004A44O002O012O0003000100093O0006102O012O002O013O0004A44O002O012O00030001000A4O00122O010001000200064500012O002O0100010004A44O002O012O00030001000B4O00122O010001000200064500012O002O0100010004A44O002O012O00030001000C3O00064500012O002O0100010004A44O002O012O0003000100053O0020790001000100134O00035O00202O00030003000B4O00010003000200062O00012O002O013O0004A44O002O012O0003000100053O00207900010001000C4O00035O00202O0003000300144O00010003000200062O0001009500013O0004A43O009500012O000300015O0020C500010001001400202O0001000100154O0001000200024O000200043O00062O000100A9000100020004A43O00A900012O000300015O0020AF00010001001600207F0001000100173O002O01000200020006102O0100A900013O0004A43O00A900012O0003000100053O00207900010001000C4O00035O00202O0003000300074O00010003000200062O000100B000013O0004A43O00B000012O000300015O0020C500010001000700202O0001000100154O0001000200024O000200043O00062O000100A9000100020004A43O00A900012O000300015O0020AF00010001001600207F0001000100173O002O0100020002000645000100B0000100010004A43O00B000012O0003000100053O00201B2O010001000A4O00035O00202O0003000300184O00010003000200062O000100ED000100010004A43O00ED00012O00030001000D4O00122O01000100020006102O012O002O013O0004A44O002O012O0003000100024O00122O01000100020006102O0100C600013O0004A43O00C600012O0003000100033O0020ED0001000100194O00035O00202O0003000300064O0001000300024O0002000E3O00062O000100C6000100020004A43O00C600012O000300015O0020AF00010001001200207F00010001001A3O002O01000200020026AE00012O002O01001B0004A44O002O012O0003000100053O00207900010001000A4O00035O00202O0003000300184O00010003000200062O000100D400013O0004A43O00D400012O0003000100053O00207900010001000C4O00035O00202O0003000300034O00010003000200062O000100ED00013O0004A43O00ED00012O0003000100053O0020790001000100134O00035O00202O00030003001C4O00010003000200062O00012O002O013O0004A44O002O012O0003000100053O0020790001000100134O00035O00202O0003000300184O00010003000200062O00012O002O013O0004A44O002O012O0003000100053O00207900010001000C4O00035O00202O0003000300034O00010003000200062O00012O002O013O0004A44O002O012O00030001000F4O00122O010001000200267000012O002O0100010004A44O002O012O0003000100064O009100025O00202O0002000200124O000300033O00202O00030003000D4O00055O00202O0005000500124O0003000500024O000300036O000400046O000500016O00010005000200062O00012O002O013O0004A44O002O012O0003000100073O0012D50002001D3O0012D50003001E4O00AA000100034O000E00015O0012D53O001F3O0026703O00682O0100090004A43O00682O012O0003000100103O0006102O0100232O013O0004A43O00232O012O000300015O0020AF00010001002000207F0001000100043O002O01000200020006102O0100232O013O0004A43O00232O012O0003000100113O0006102O0100232O013O0004A43O00232O012O0003000100123O000E30010200232O0100010004A43O00232O012O000300015O0020AF00010001002100207F0001000100173O002O01000200020006102O0100232O013O0004A43O00232O012O0003000100064O000300025O0020AF0002000200203O002O01000200020006102O0100232O013O0004A43O00232O012O0003000100073O0012D5000200223O0012D5000300234O00AA000100034O000E00016O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O0100412O013O0004A43O00412O012O0003000100013O0006102O0100412O013O0004A43O00412O012O00030001000D4O00122O01000100020006102O0100412O013O0004A43O00412O012O0003000100064O008C00025O00202O0002000200034O000300033O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100412O013O0004A43O00412O012O0003000100073O0012D5000200243O0012D5000300254O00AA000100034O000E00016O0003000100103O0006102O0100672O013O0004A43O00672O012O000300015O0020AF00010001002600207F0001000100043O002O01000200020006102O0100672O013O0004A43O00672O012O0003000100133O0006102O0100672O013O0004A43O00672O012O0003000100144O0003000200153O00068F000200672O0100010004A43O00672O012O0003000100053O00207F0001000100273O002O01000200022O0003000200163O00068F000200672O0100010004A43O00672O012O0003000100064O002400025O00202O0002000200264O000300033O00202O00030003002800122O000500296O0003000500024O000300036O00010003000200062O000100672O013O0004A43O00672O012O0003000100073O0012D50002002A3O0012D50003002B4O00AA000100034O000E00015O0012D53O002C3O0026703O00D22O01002C0004A43O00D22O012O0003000100103O0006102O01008A2O013O0004A43O008A2O012O000300015O0020AF00010001002D00207F0001000100043O002O01000200020006102O01008A2O013O0004A43O008A2O012O0003000100173O0006102O01008A2O013O0004A43O008A2O012O0003000100184O0003000200193O00068F0002008A2O0100010004A43O008A2O012O0003000100064O00240002001A3O00202O00020002002E4O000300033O00202O00030003002800122O0005002F6O0003000500024O000300036O00010003000200062O0001008A2O013O0004A43O008A2O012O0003000100073O0012D5000200303O0012D5000300314O00AA000100034O000E00016O000300015O0020AF00010001000700207F0001000100043O002O01000200020006102O0100B22O013O0004A43O00B22O012O0003000100083O0006102O0100B22O013O0004A43O00B22O012O000300015O0020AF00010001003200207F0001000100173O002O01000200020006102O0100B22O013O0004A43O00B22O012O0003000100053O0020790001000100134O00035O00202O0003000300334O00010003000200062O000100B22O013O0004A43O00B22O012O0003000100064O002100025O00202O0002000200074O000300033O00202O00030003000D4O00055O00202O0005000500074O0003000500024O000300036O000400016O00010004000200062O000100B22O013O0004A43O00B22O012O0003000100073O0012D5000200343O0012D5000300354O00AA000100034O000E00016O000300015O0020AF00010001001400207F0001000100043O002O01000200020006102O0100BF03013O0004A43O00BF03012O00030001001B3O0006102O0100BF03013O0004A43O00BF03012O00030001000A4O00122O0100010002000645000100BF030100010004A43O00BF03012O0003000100064O002100025O00202O0002000200144O000300033O00202O00030003000D4O00055O00202O0005000500144O0003000500024O000300036O000400016O00010004000200062O000100BF03013O0004A43O00BF03012O0003000100073O00124A000200363O00122O000300376O000100036O00015O00044O00BF03010026703O0046020100010004A43O004602012O0003000100103O0006102O0100F82O013O0004A43O00F82O012O000300015O0020AF00010001002D00207F0001000100043O002O01000200020006102O0100F82O013O0004A43O00F82O012O0003000100173O0006102O0100F82O013O0004A43O00F82O012O0003000100184O00030002001C3O00068F000200F82O0100010004A43O00F82O012O00030001000A4O00122O01000100020006102O0100F82O013O0004A43O00F82O012O0003000100064O00240002001A3O00202O00020002002E4O000300033O00202O00030003002800122O0005002F6O0003000500024O000300036O00010003000200062O000100F82O013O0004A43O00F82O012O0003000100073O0012D5000200383O0012D5000300394O00AA000100034O000E00016O000300015O0020AF00010001000700207F0001000100043O002O01000200020006102O01001702013O0004A43O001702012O0003000100083O0006102O01001702013O0004A43O001702012O00030001000A4O00122O01000100020006102O01001702013O0004A43O001702012O0003000100064O002100025O00202O0002000200074O000300033O00202O00030003000D4O00055O00202O0005000500074O0003000500024O000300036O000400016O00010004000200062O0001001702013O0004A43O001702012O0003000100073O0012D50002003A3O0012D50003003B4O00AA000100034O000E00016O0003000100103O0006102O01004502013O0004A43O004502012O000300015O0020AF00010001002D00207F0001000100043O002O01000200020006102O01004502013O0004A43O004502012O0003000100173O0006102O01004502013O0004A43O004502012O0003000100053O00201B2O010001000C4O00035O00202O00030003002D4O00010003000200062O00010045020100010004A43O004502012O0003000100184O00030002001D3O00068F00020045020100010004A43O004502012O0003000100053O00207900010001000A4O00035O00202O00030003000B4O00010003000200062O0001004502013O0004A43O004502012O0003000100064O00240002001A3O00202O00020002002E4O000300033O00202O00030003002800122O0005002F6O0003000500024O000300036O00010003000200062O0001004502013O0004A43O004502012O0003000100073O0012D50002003C3O0012D50003003D4O00AA000100034O000E00015O0012D53O00023O0026703O00D80201001F0004A43O00D802012O000300015O0020AF00010001000700207F0001000100043O002O01000200020006102O01008102013O0004A43O008102012O0003000100083O0006102O01008102013O0004A43O008102012O0003000100053O00201B2O010001000C4O00035O00202O0003000300034O00010003000200062O00010060020100010004A43O006002012O0003000100053O00203600010001003E00122O000300026O00045O00202O0004000400034O0001000400020006102O01008102013O0004A43O008102012O0003000100053O00207900010001000A4O00035O00202O0003000300184O00010003000200062O0001008102013O0004A43O008102012O00030001000D4O00122O01000100020006102O01008102013O0004A43O008102012O0003000100184O00030002001C3O0006D700010081020100020004A43O008102012O0003000100064O002100025O00202O0002000200074O000300033O00202O00030003000D4O00055O00202O0005000500074O0003000500024O000300036O000400016O00010004000200062O0001008102013O0004A43O008102012O0003000100073O0012D50002003F3O0012D5000300404O00AA000100034O000E00016O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O0100A802013O0004A43O00A802012O0003000100013O0006102O0100A802013O0004A43O00A802012O0003000100024O00122O01000100020006102O0100A802013O0004A43O00A802012O0003000100033O0020D80001000100054O00035O00202O0003000300064O0001000300024O000200043O00102O00020041000200062O000100A8020100020004A43O00A802012O0003000100064O008C00025O00202O0002000200034O000300033O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O000100A802013O0004A43O00A802012O0003000100073O0012D5000200423O0012D5000300434O00AA000100034O000E00016O000300015O0020AF00010001004400207F0001000100453O002O01000200020006102O0100D702013O0004A43O00D702012O00030001001E3O0006102O0100D702013O0004A43O00D702012O000300015O0020AF00010001002100207F0001000100173O002O01000200020006102O0100D702013O0004A43O00D702012O000300015O0020AF00010001004600207F0001000100173O002O01000200020006102O0100C602013O0004A43O00C602012O0003000100053O0020D80001000100474O00035O00202O0003000300484O0001000300024O000200043O00102O0002001F000200062O000100D7020100020004A43O00D702012O0003000100064O008C00025O00202O0002000200444O000300033O00202O00030003000D4O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O000100D702013O0004A43O00D702012O0003000100073O0012D5000200493O0012D50003004A4O00AA000100034O000E00015O0012D53O001B3O0026703O0033030100410004A43O003303012O000300015O0020AF00010001004400207F0001000100453O002O01000200020006102O01002A03013O0004A43O002A03012O00030001001E3O0006102O01002A03013O0004A43O002A03012O000300015O0020AF00010001002100207F0001000100173O002O01000200020006102O01002A03013O0004A43O002A03012O0003000100053O0020790001000100134O00035O00202O00030003001C4O00010003000200062O0001002A03013O0004A43O002A03012O00030001000F4O00122O01000100020026700001002A030100010004A43O002A03012O00030001001F3O000645000100FE020100010004A43O00FE02012O0003000100053O00201B2O010001000A4O00035O00202O00030003004B4O00010003000200062O00010019030100010004A43O001903012O000300015O0020AF00010001004400207F00010001004C3O002O0100020002000E17014D0019030100010004A43O001903012O000300015O0020AF00010001004400207F00010001004C3O002O0100020002000E30014E002A030100010004A43O002A03012O000300015O0020AF00010001004600207F0001000100173O002O01000200020006102O01001903013O0004A43O001903012O0003000100053O0020D80001000100474O00035O00202O0003000300484O0001000300024O000200043O00102O0002001B000200062O0001002A030100020004A43O002A03012O0003000100064O008C00025O00202O0002000200444O000300033O00202O00030003000D4O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O0001002A03013O0004A43O002A03012O0003000100073O0012D50002004F3O0012D5000300504O00AA000100034O000E00016O0003000100214O00122O01000100022O0048000100204O0003000100203O0006102O01003203013O0004A43O003203012O0003000100204O0010000100023O0012D53O00093O0026703O00010001001B0004A43O000100012O000300015O0020AF00010001004400207F0001000100453O002O01000200020006102O01006603013O0004A43O006603012O00030001001E3O0006102O01006603013O0004A43O006603012O0003000100053O0020DB00010001005100122O000300293O00122O0004001F6O00010004000200062O0001006603013O0004A43O006603012O0003000100033O0020D80001000100054O00035O00202O0003000300524O0001000300024O000200043O00102O0002001F000200062O00010066030100020004A43O006603012O0003000100053O0020790001000100134O00035O00202O00030003001C4O00010003000200062O0001006603013O0004A43O006603012O0003000100064O008C00025O00202O0002000200444O000300033O00202O00030003000D4O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O0001006603013O0004A43O006603012O0003000100073O0012D5000200533O0012D5000300544O00AA000100034O000E00016O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01008C03013O0004A43O008C03012O0003000100013O0006102O01008C03013O0004A43O008C03012O0003000100024O00122O01000100020006102O01008C03013O0004A43O008C03012O0003000100033O00202D0001000100194O00035O00202O0003000300064O0001000300024O0002000E3O00062O0001008C030100020004A43O008C03012O0003000100064O008C00025O00202O0002000200034O000300033O00202O00030003000D4O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001008C03013O0004A43O008C03012O0003000100073O0012D5000200553O0012D5000300564O00AA000100034O000E00016O000300015O0020AF00010001004400207F0001000100453O002O01000200020006102O0100BD03013O0004A43O00BD03012O00030001001E3O0006102O0100BD03013O0004A43O00BD03012O000300015O0020AF00010001002100207F0001000100173O002O0100020002000645000100BD030100010004A43O00BD03012O0003000100053O0020790001000100134O00035O00202O00030003001C4O00010003000200062O000100BD03013O0004A43O00BD03012O00030001001F3O000645000100BD030100010004A43O00BD03012O0003000100053O00207900010001000A4O00035O00202O00030003004B4O00010003000200062O000100BD03013O0004A43O00BD03012O0003000100064O008C00025O00202O0002000200444O000300033O00202O00030003000D4O00055O00202O0005000500444O0003000500024O000300036O00010003000200062O000100BD03013O0004A43O00BD03012O0003000100073O0012D5000200573O0012D5000300584O00AA000100034O000E00015O0012D53O00413O0004A43O000100012O002E012O00017O00363O00028O00026O00084003093O0046697265426C61737403073O004973526561647903093O00497343617374696E67030D3O005368696674696E67506F77657203103O0046752O6C526563686172676554696D65030E3O0049735370652O6C496E52616E676503123O00D0A91F2AFCD4AC0C3CD796AD0C26CD96F15B03053O00A3B6C06D4F03073O004963654E6F7661030A3O0049734361737461626C65030A3O005573654963654E6F766103103O003D2505FFFB3B300180F8352F0E80A46C03053O0095544660A003063O0053636F726368030E3O002B0502FF3B0E4DE0390F03AD6A5603043O008D58666D026O00F03F03113O00436861726765734672616374696F6E616C03083O00432O6F6C646F776E030A3O004D617843686172676573026O002840030A3O00436F6D62757374696F6E030F3O00432O6F6C646F776E52656D61696E7303103O0053756E4B696E6773426C652O73696E67030B3O004973417661696C61626C6503073O0043686172676573030D3O00446562752O6652656D61696E7303143O00496D70726F76656453636F726368446562752O6603083O004361737454696D6503083O0042752O66446F776E03143O00467572796F6674686553756E4B696E6742752O66030D3O00486F7453747265616B42752O6603093O004973496E52616E6765026O00444003163O00A05BC3760E345BC68C43C5671F2F15CCB25AC4304B6F03083O00A1D333AA107A5D35027O004003083O0054696D655761727003123O00426C2O6F646C757374457868617573745570030C3O0054656D706F72616C5761727003213O00EFA7BF2DC4B9B33AEBEEB127F6ACA73BEFA7BD26C4ADBD27F7AABD3FF5BDF279A903043O00489BCED2026O001440030D3O0050686F656E6978466C616D657303103O00416C657873747261737A61734675727903063O0042752O665570030D3O0048656174696E67557042752O66030B3O00466C616D65737472696B65030E3O004578656375746552656D61696E73026O00E03F03123O004073460B0C4476551D27067755073D062B0003053O0053261A346E0051022O0012D53O00013O0026703O007D000100020004A43O007D00012O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01003100013O0004A43O003100012O0003000100013O0006102O01003100013O0004A43O003100012O0003000100024O00122O010001000200064500010031000100010004A43O003100012O0003000100033O0020790001000100054O00035O00202O0003000300064O00010003000200062O0001003100013O0004A43O003100012O000300015O0020F200010001000300202O0001000100074O0001000200024O000200043O00062O00010031000100020004A43O003100012O0003000100054O009100025O00202O0002000200034O000300063O00202O0003000300084O00055O00202O0005000500034O0003000500024O000300036O000400046O000500016O00010005000200062O0001003100013O0004A43O003100012O0003000100073O0012D5000200093O0012D50003000A4O00AA000100034O000E00016O0003000100083O000E302O010044000100010004A43O004400012O0003000100093O0006102O01004400013O0004A43O004400010012D5000100013O00267000010038000100010004A43O003800012O00030002000B4O00120102000100022O00480002000A4O00030002000A3O0006100102004400013O0004A43O004400012O00030002000A4O0010000200023O0004A43O004400010004A43O003800012O000300015O0020AF00010001000B00207F00010001000C3O002O01000200020006102O01006200013O0004A43O0062000100120D0001000D3O0006102O01006200013O0004A43O006200012O00030001000C4O00122O010001000200064500010062000100010004A43O006200012O0003000100054O008C00025O00202O00020002000B4O000300063O00202O0003000300084O00055O00202O00050005000B4O0003000500024O000300036O00010003000200062O0001006200013O0004A43O006200012O0003000100073O0012D50002000E3O0012D50003000F4O00AA000100034O000E00016O000300015O0020AF00010001001000207F0001000100043O002O01000200020006102O01005002013O0004A43O005002012O00030001000D3O0006102O01005002013O0004A43O005002012O0003000100054O008C00025O00202O0002000200104O000300063O00202O0003000300084O00055O00202O0005000500104O0003000500024O000300036O00010003000200062O0001005002013O0004A43O005002012O0003000100073O00124A000200113O00122O000300126O000100036O00015O00044O005002010026703O00422O0100130004A43O00422O012O0003000100093O0006102O0100AF00013O0004A43O00AF00012O000300015O00205400010001000300202O0001000100144O0001000200024O000200086O0003000F6O0003000100024O000400106O000500116O0004000200024O0003000300044O0002000200034O00035O00202O00030003000300202O0003000300154O0003000200024O0002000200034O00010001000200202O0001000100134O00025O00202O00020002000300202O0002000200164O0002000200024O000300126O00045O00202O00040004000300202O0004000400154O0004000200024O0003000300044O0002000200034O00035O00202O00030003000300202O0003000300154O00030002000200102O00030017000300202O0003000300134O00020002000300062O000100AD000100020004A43O00AD00012O0003000100084O0003000200133O0006E9000100AE000100020004A43O00AE00012O003A00016O007D000100014O00480001000E4O0003000100143O000645000100D1000100010004A43O00D100012O0003000100083O002602000100C4000100010004A43O00C400012O0003000100153O000645000100C4000100010004A43O00C400012O0003000100084O0003000200163O0006D7000100D1000100020004A43O00D100012O000300015O0020F200010001001800202O0001000100194O0001000200024O000200163O00062O000100D1000100020004A43O00D100010012D5000100013O002670000100C5000100010004A43O00C500012O0003000200174O00120102000100022O00480002000A4O00030002000A3O000610010200D100013O0004A43O00D100012O00030002000A4O0010000200023O0004A43O00D100010004A43O00C500012O00030001000E3O000645000100E9000100010004A43O00E900012O000300015O0020AF00010001001A00207F00010001001B3O002O01000200020006102O0100E900013O0004A43O00E900012O00030001000C4O00122O01000100020006102O0100E800013O0004A43O00E800012O000300015O0020292O010001000300202O0001000100074O0001000200024O000200183O00102O00020002000200062O000200E7000100010004A43O00E700012O003A00016O007D000100014O00480001000E4O000300015O0020AF00010001000600207F0001000100043O002O01000200020006102O0100412O013O0004A43O00412O012O0003000100193O0006102O0100F500013O0004A43O00F500012O00030001001A3O000645000100F8000100010004A43O00F800012O00030001001A3O000645000100412O0100010004A43O00412O012O00030001001B3O0006102O0100412O013O0004A43O00412O012O00030001001C4O0003000200133O0006D7000100412O0100020004A43O00412O012O0003000100093O0006102O0100412O013O0004A43O00412O012O000300015O0020AF00010001000300207F00010001001C3O002O01000200020026720001000B2O0100010004A43O000B2O012O00030001000E3O0006102O0100412O013O0004A43O00412O012O00030001001D4O00122O01000100020006102O0100262O013O0004A43O00262O012O0003000100063O00201A2O010001001D4O00035O00202O00030003001E4O0001000300024O00025O00202O00020002000600202O00020002001F4O0002000200024O00035O00202O00030003001000202O00030003001F4O0003000200024O00020002000300062O000200412O0100010004A43O00412O012O0003000100033O0020790001000100204O00035O00202O0003000300214O00010003000200062O000100412O013O0004A43O00412O012O0003000100033O0020790001000100204O00035O00202O0003000300224O00010003000200062O000100412O013O0004A43O00412O012O0003000100113O0006102O0100412O013O0004A43O00412O012O0003000100054O002C01025O00202O0002000200064O000300063O00202O00030003002300122O000500246O0003000500024O000300036O000400016O00010004000200062O000100412O013O0004A43O00412O012O0003000100073O0012D5000200253O0012D5000300264O00AA000100034O000E00015O0012D53O00273O0026703O009C2O0100010004A43O009C2O012O0003000100143O000645000100492O0100010004A43O00492O012O00030001001E4O00A00001000100012O0003000100193O0006102O0100742O013O0004A43O00742O012O00030001001F3O0006102O0100742O013O0004A43O00742O012O000300015O0020AF00010001002800207F0001000100043O002O01000200020006102O0100742O013O0004A43O00742O012O0003000100033O00207F0001000100293O002O01000200020006102O0100742O013O0004A43O00742O012O000300015O0020AF00010001002A00207F00010001001B3O002O01000200020006102O0100742O013O0004A43O00742O012O0003000100204O00122O0100010002000645000100672O0100010004A43O00672O012O0003000100133O0026AE000100742O0100240004A43O00742O012O0003000100054O00EC00025O00202O0002000200284O000300046O000500016O00010005000200062O000100742O013O0004A43O00742O012O0003000100073O0012D50002002B3O0012D50003002C4O00AA000100034O000E00016O00030001001C4O0003000200133O0006D7000100912O0100020004A43O00912O012O0003000100213O0006102O0100912O013O0004A43O00912O012O0003000100193O0006102O0100812O013O0004A43O00812O012O0003000100223O000645000100842O0100010004A43O00842O012O0003000100223O000645000100912O0100010004A43O00912O010012D5000100013O000E06000100852O0100010004A43O00852O012O0003000200234O00120102000100022O00480002000A4O00030002000A3O000610010200912O013O0004A43O00912O012O00030002000A4O0010000200023O0004A43O00912O010004A43O00852O012O0003000100084O001900025O00202O00020002000600202O0002000200194O00020002000200062O000200992O0100010004A43O00992O012O003A00016O007D000100014O0048000100113O0012D53O00133O0026703O0001000100270004A43O000100012O0003000100244O0003000200253O0006D7000100CA2O0100020004A43O00CA2O012O000300015O0020AF00010001001A00207F00010001001B3O002O0100020002000645000100C12O0100010004A43O00C12O012O0003000100083O00202A00010001002700202O00010001002D4O00025O00202O00020002002E00202O0002000200074O0002000200024O00035O00202O00030003002E00202O0003000300154O0003000200022O00BB0002000200032O001E0003000F6O0003000100024O000400106O000500116O0004000200024O0003000300044O00020002000300062O000100C72O0100020004A43O00C72O012O0003000100084O0003000200133O0006D7000100C72O0100020004A43O00C72O012O000300015O0020B700010001002F00202O00010001001B4O0001000200024O000100013O00044O00C92O012O003A00016O007D000100014O0048000100264O0003000100244O0003000200253O00068F000200EF2O0100010004A43O00EF2O012O000300015O0020AF00010001001A00207F00010001001B3O002O0100020002000645000100E62O0100010004A43O00E62O012O0003000100084O004700025O00202O00020002002E00202O0002000200074O0002000200024O0003000F6O0003000100024O000400106O000500116O0004000200024O0003000300044O00020002000300062O000100EC2O0100020004A43O00EC2O012O0003000100084O0003000200133O0006D7000100EC2O0100020004A43O00EC2O012O000300015O0020B700010001002F00202O00010001001B4O0001000200024O000100013O00044O00EE2O012O003A00016O007D000100014O0048000100264O000300015O0020AF00010001000300207F0001000100043O002O01000200020006102O01003702013O0004A43O003702012O0003000100013O0006102O01003702013O0004A43O003702012O0003000100024O00122O010001000200064500010037020100010004A43O003702012O00030001000E3O00064500010037020100010004A43O003702012O0003000100083O000E302O010037020100010004A43O003702012O0003000100244O0003000200273O00068F00020037020100010004A43O003702012O0003000100204O00122O010001000200064500010037020100010004A43O003702012O0003000100033O0020790001000100204O00035O00202O0003000300224O00010003000200062O0001003702013O0004A43O003702012O0003000100033O0020790001000100304O00035O00202O0003000300314O00010003000200062O0001001E02013O0004A43O001E02012O000300015O0020AF00010001003200207F0001000100333O002O01000200020026FE00010024020100340004A43O002402012O000300015O0020AF00010001000300207F0001000100143O002O0100020002000EA600270037020100010004A43O003702012O0003000100054O009100025O00202O0002000200034O000300063O00202O0003000300084O00055O00202O0005000500034O0003000500024O000300036O000400046O000500016O00010005000200062O0001003702013O0004A43O003702012O0003000100073O0012D5000200353O0012D5000300364O00AA000100034O000E00016O0003000100093O0006102O01004E02013O0004A43O004E02012O0003000100204O00122O01000100020006102O01004E02013O0004A43O004E02012O0003000100083O000E302O01004E020100010004A43O004E02010012D5000100013O00267000010042020100010004A43O004202012O0003000200284O00120102000100022O00480002000A4O00030002000A3O0006100102004E02013O0004A43O004E02012O00030002000A4O0010000200023O0004A43O004E02010004A43O004202010012D53O00023O0004A43O000100012O002E012O00017O004E3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E677303123O004D0422674A1426485D323F565418344F571903043O002638774703123O00E6FC5DF73755F2E15DFF2B42F6E354D3264203063O0036938F38B64503103O00C392FA6DCDD786F047CCF493FA48CBDE03053O00BFB6E19F29030C3O003E012D738295C7091E29469F03073O00A24B724835EBE7030B3O00992F41C45A10893E45EE5F03063O0062EC5C248233030E3O00B10A099C49A9B835B70D1EB34EAD03083O0050C4796CDA25C8D5026O00F03F030D3O00156007534218830E742070460C03073O00EA6013621F2B6E03093O00130C57EAA9668E090D03073O00EB667F32A7CC1203103O0045B2F0134C2155AFFC3B622251ACF03003063O004E30C1954324030C3O00250D8528582211821440230A03053O0021507EE07803093O00F9BB06F75FE3BA00CC03053O003C8CC863A4030F3O0092E70105AD92FA1023B094E4012AAE03053O00C2E7946446027O0040030C3O00535FC481FAC95558F6A2E0CD03063O00A8262CA1C396030D3O0095EF87553FE5B40393E88B793E03083O0076E09CE2165088D603103O0057FD5CB34AE75F944BE05EB04DF95C9203043O00E0228E3903103O00DDA8C8DF66E24907D1A9F2D467F97E2A03083O006EBEC7A5BD13913D03133O00C9E37EEE9FCED4EC47E79CC2C8DC7EFC83E4FE03063O00A7BA8B1788EB030C3O000FA68D2C16A18D1F2EBC850803043O006D7AD5E8026O000840026O001440030D3O00E3F6B123CCF6B022E7F2B018DE03043O00508E97C203153O000ECF655E0CD45E4102C1726E06C0785E06F662400F03043O002C63A61703133O0069E42C0523A170FB1A2236A570C3282434A16803063O00C41C9749565303153O00E6102C248B551D41F21139278B4C1042F20F2C1E9603083O001693634970E23878031B3O00AD66E7C788B57AF4F0AEAD67F1F0BAB161EAD48BBE79EBF699BD7103053O00EDD8158295026O001040030B3O0083424B5AA2FD578F4B776F03073O003EE22E2O3FD0A903103O00E71554991603287CE40B478A1A1F076E03083O003E857935E37F6D4F03153O00170637F4C2ABB0391A24FCC5A7A019183BE1CF869203073O00C270745295B6CE030A3O0030AB493ACCED0D32807C03073O006E59C82C78A08203093O00A2C04E654C463F659B03083O002DCBA32B26232A5B030D3O00DF8CCE3188BB7DDF84DB26AF9903073O0034B2E5BC43E7C903113O0034525526FB5D39284F5726F64E3128444203073O004341213064973C03163O00CAF4ABFFE1DAE6BADDE1F6E9B8D1E0D6E5A7D4FACBFE03053O0093BF87CEB8030B3O00913BA3E8DB56908827A5CA03073O00D2E448C6A1B833030A3O00235AF63970CB1546FF1403063O00AE5629937013030E3O004E138826241C02895A129F02201D03083O00CB3B60ED6B456F71030E3O003105A9CC38E2C52B0485EC30F7D203073O00B74476CC8151900042012O0012D53O00013O0026703O0034000100010004A43O0034000100120D000100023O00205D0001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100033O00122O000100023O00202O0001000100034O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100043O00122O000100023O00202O0001000100034O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100063O00124O00103O0026703O0067000100100004A43O0067000100120D000100023O00205D0001000100034O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100083O00122O000100023O00202O0001000100034O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100093O00122O000100023O00202O0001000100034O000200013O00122O000300173O00122O000400186O0002000400024O0001000100024O0001000A3O00122O000100023O00202O0001000100034O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O0001000B3O00122O000100023O00202O0001000100034O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000C3O00124O001D3O0026703O009A0001001D0004A43O009A000100120D000100023O00205D0001000100034O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000D3O00122O000100023O00202O0001000100034O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000E3O00122O000100023O00202O0001000100034O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000F3O00122O000100023O00202O0001000100034O000200013O00122O000300243O00122O000400256O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O000100113O00122O000100023O00202O0001000100034O000200013O00122O000300283O00122O000400296O0002000400024O0001000100024O000100123O00124O002A3O0026703O00C80001002B0004A43O00C8000100120D000100023O0020EB0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100A6000100010004A43O00A600010012D5000100014O0048000100133O001288000100023O00202O0001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000100143O00122O000100023O00202O0001000100034O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100153O00122O000100023O00202O0001000100034O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100163O00122O000100023O00202O0001000100034O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100173O00044O00412O010026703O000D2O0100360004A43O000D2O0100120D000100023O0020EB0001000100034O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100D4000100010004A43O00D400010012D5000100014O0048000100183O0012C0000100023O00202O0001000100034O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100DF000100010004A43O00DF00010012D5000100014O0048000100193O0012C0000100023O00202O0001000100034O000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200062O000100EA000100010004A43O00EA00010012D5000100014O00480001001A3O0012C0000100023O00202O0001000100034O000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200062O000100F5000100010004A43O00F500010012D5000100014O00480001001B3O0012C0000100023O00202O0001000100034O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O00012O002O0100010004A44O002O010012D5000100014O00480001001C3O0012C0000100023O00202O0001000100034O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001000B2O0100010004A43O000B2O010012D5000100014O00480001001D3O0012D53O002B3O0026703O00010001002A0004A43O0001000100120D000100023O00205D0001000100034O000200013O00122O000300433O00122O000400446O0002000400024O0001000100024O0001001E3O00122O000100023O00202O0001000100034O000200013O00122O000300453O00122O000400466O0002000400024O0001000100024O0001001F3O00122O000100023O00202O0001000100034O000200013O00122O000300473O00122O000400486O0002000400024O0001000100024O000100203O00122O000100023O00202O0001000100034O000200013O00122O000300493O00122O0004004A6O0002000400024O0001000100024O000100213O00122O000100023O00202O0001000100034O000200013O00122O0003004B3O00122O0004004C6O0002000400024O0001000100024O000100223O00122O000100023O00202O0001000100034O000200013O00122O0003004D3O00122O0004004E6O0002000400024O0001000100024O000100233O00124O00363O0004A43O000100012O002E012O00017O002A3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E677303113O0008A477EC1FB00BA071ED05912DA575E70003063O00E26ECD10846B03113O00C2CDF4DC53F9D6F0CD76E2D7E8EA55FECD03053O00218BA380B903163O007E5610DB454A11CE43770AD24E6F0CD7435D08D7444C03043O00BE37386403123O007FA1281B01F1E646BB081601E6E05EA0301A03073O009336CF5C7E7383026O00F03F027O0040030E3O0019233C73067B1922027419762E1503063O001E6D51551D6D030D3O00ED7057BF37D2EFC87840BE15FA03073O009C9F1134D656BE030E3O00BBFCB894ABEEB1A8A6FCA9B3A0EA03043O00DCCE8FDD03103O00936E283FDDCDDE8F732A27D7D8DB897303073O00B2E61D4D77B8AC026O000840026O00104003113O00DDBF041F7BFDDCB0091465E8FAAC0F1A7B03063O009895DE6A7B17030D3O00D523F74FA1D535E24CBBD80EC603053O00D5BD469623030F3O0047507504465B733840417D07417D4403043O00682F351403113O008B498010B501A47C8E08B500AD628011B903063O006FC32CE17CDC034O00030F3O00D0470E77A7AEF940067FA2A8CC430403063O00CBB8266013CB030D3O001D7A6A51CB35577C43DB3F756A03053O00AE59131921030B3O000B1B415EF28B293A14545D03073O006B4F72322E97E7030B3O002CB5B01D9830B9CB3CB2A603083O00A059C6D549EA59D7030A3O005D62B1CCC44B78B5F2D603053O00A52811D49E00A63O0012D53O00013O0026703O0027000100010004A43O0027000100120D000100023O0020EB0001000100034O000200013O00122O000300043O00122O000400056O0002000400024O00010001000200062O0001000D000100010004A43O000D00010012D5000100014O004800015O00120D2O0100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100033O00122O000100023O00202O0001000100034O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100043O00124O000C3O0026703O004A0001000D0004A43O004A000100120D000100023O0020B10001000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00122O000100023O00202O0001000100034O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00124O00163O0026703O0055000100170004A43O0055000100120D000100023O0020310001000100034O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00044O00A500010026703O0081000100160004A43O0081000100120D000100023O0020EB0001000100034O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O00010061000100010004A43O006100010012D5000100014O00480001000A3O0012C0000100023O00202O0001000100034O000200013O00122O0003001C3O00122O0004001D6O0002000400024O00010001000200062O0001006C000100010004A43O006C00010012D5000100014O00480001000B3O0012C0000100023O00202O0001000100034O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O00010077000100010004A43O007700010012D5000100204O00480001000C3O001242000100023O00202O0001000100034O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00124O00173O000E06000C000100013O0004A43O0001000100120D000100023O0020B10001000100034O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100023O00202O0001000100034O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100023O00202O0001000100034O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00124O000D3O0004A43O000100012O002E012O00017O00363O00028O00027O004003173O00476574456E656D696573496E53706C61736852616E6765026O00144003163O00476574456E656D696573496E4D656C2O6552616E6765030F3O00456E656D69657334307952616E676503113O00476574456E656D696573496E52616E6765026O004440026O000840026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00E6DD1B03053O004685B9685303043O004B69636B03043O000F4C472103053O00A96425244A03063O00048EB140058B03043O003060E7C2030D3O004973446561644F7247686F7374031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174026O00104003063O0042752O665570030E3O00436F6D62757374696F6E42752O66030B3O0052656D6F7665437572736503073O004973526561647903093O00466F637573556E6974026O00344003103O00426F2O73466967687452656D61696E73024O00F069F8402O033O00474344024O0080B3C540030C3O00466967687452656D61696E73030F3O0048616E646C65412O666C696374656403143O0052656D6F766543757273654D6F7573656F766572026O003E4003113O0048616E646C65496E636F72706F7265616C03093O00506F6C796D6F72706803123O00506F6C796D6F7270684D6F7573654F766572030A3O005370652O6C737465616C030B3O004973417661696C61626C6503093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030E3O0049735370652O6C496E52616E676503113O00DB4A0B2115CBBB86C9564E2918D5AE84CD03083O00E3A83A6E4D79B8CF03053O00466F6375732O033O007433BC03083O00C51B5CDF20D1BB112O033O000250C603043O009B633FA300BE012O0012D53O00013O0026703O0018000100020004A43O001800012O0003000100013O00205000010001000300122O000300046O0001000300024O00018O000100033O00202O00010001000500122O000300046O0001000300024O000100026O000100033O00202O00010001000500122O000300046O0001000300024O000100046O000100033O00202O00010001000700122O000300086O00010003000200122O000100063O00124O00093O000E06000A003900013O0004A43O0039000100120D0001000B3O0020FC00010001000C4O000200063O00122O0003000D3O00122O0004000E6O0002000400024O0001000100024O000100053O00122O0001000B3O00202O00010001000C4O000200063O0012D5000300103O00123F000400116O0002000400024O00010001000200122O0001000F3O00122O0001000B3O00202O00010001000C4O000200063O00122O000300123O00122O000400136O0002000400022O00160001000100022O0058000100076O000100033O00202O0001000100144O00010002000200062O0001003800013O0004A43O003800012O002E012O00013O0012D53O00023O0026703O00A52O0100090004A43O00A52O012O0003000100083O0006102O01006B00013O0004A43O006B00010012D5000100013O000E0600020045000100010004A43O004500012O0003000200044O008B000200024O0048000200093O0004A43O00800001000E060001005A000100010004A43O005A00012O00030002000B4O00CB000300013O00202O00030003001500122O000500046O00030005000200122O000400066O000400046O0002000400024O0002000A6O0002000B6O000300013O00202O00030003001500122O000500046O00030005000200122O000400066O000400046O0002000400024O0002000C3O00122O0001000A3O0026700001003F0001000A0004A43O003F00012O00030002000B4O003B000300013O00202O00030003001500122O000500046O00030005000200122O000400066O000400046O0002000400024O0002000D6O000200026O000200026O0002000E3O00122O000100023O00044O003F00010004A43O008000010012D5000100013O000E0600020071000100010004A43O007100010012D50002000A4O0048000200093O0004A43O00800001002670000100780001000A0004A43O007800010012D50002000A4O00480002000D3O0012D50002000A4O00480002000E3O0012D5000100023O0026700001006C000100010004A43O006C00010012D50002000A4O007B0002000A3O00122O0002000A6O0002000C3O00122O0001000A3O00044O006C00012O00030001000F3O0020AF0001000100162O00122O01000100020006450001008A000100010004A43O008A00012O0003000100033O00207F0001000100173O002O01000200020006102O0100EE00013O0004A43O00EE00010012D5000100013O00267000010097000100180004A43O009700012O0003000200033O0020640002000200194O000400113O00202O00040004001A4O0002000400024O000200106O000200106O000200026O000200123O00044O00EE0001002670000100C9000100010004A43O00C900012O0003000200033O00207F0002000200173O00010200020002000645000200A1000100010004A43O00A100012O0003000200133O000610010200C200013O0004A43O00C200010012D5000200014O00BC000300033O000E06000A00AB000100020004A43O00AB00012O0003000400143O000610010400C200013O0004A43O00C200012O0003000400144O0010000400023O0004A43O00C20001000E06000100A3000100020004A43O00A300012O0003000400133O000603010300B7000100040004A43O00B700012O0003000400113O0020AF00040004001B00207F00040004001C3O00010400020002000603010300B7000100040004A43O00B700012O0003000300074O00030004000F3O00201400040004001D4O000500036O000600153O00122O0007001E6O000800083O00122O0009001E6O0004000900024O000400143O00122O0002000A3O00044O00A300012O0003000200173O00201501020002001F4O000300036O000400016O0002000400024O000200163O00122O0001000A3O002670000100D5000100090004A43O00D500012O0003000200183O000610010200D000013O0004A43O00D000010012D5000200204O0048000200194O0003000200033O00207F0002000200213O000102000200022O00480002001A3O0012D5000100183O000E06000200DF000100010004A43O00DF00012O00030002001C3O001251000300066O0002000200024O0002001B6O000200056O000200026O000200183O00122O000100093O0026700001008B0001000A0004A43O008B00012O0003000200164O00480002001D4O00030002001D3O002670000200EC000100220004A43O00EC00012O0003000200173O00201800020002002300122O000300066O00048O0002000400024O0002001D3O0012D5000100023O0004A43O008B00012O0003000100033O00207F0001000100173O002O0100020002000645000100032O0100010004A43O00032O012O00030001001E3O0006102O0100032O013O0004A43O00032O010012D5000100013O002670000100F7000100010004A43O00F700012O00030002001F4O00120102000100022O0048000200144O0003000200143O000610010200032O013O0004A43O00032O012O0003000200144O0010000200023O0004A43O00032O010004A43O00F700012O0003000100033O00207F0001000100173O002O01000200020006102O0100BD2O013O0004A43O00BD2O012O00030001000F3O0020AF0001000100162O00122O01000100020006102O0100BD2O013O0004A43O00BD2O010012D5000100013O0026700001002F2O01000A0004A43O002F2O012O0003000200143O000610010200152O013O0004A43O00152O012O0003000200144O0010000200024O0003000200203O0006100102002E2O013O0004A43O002E2O012O0003000200213O0006100102002E2O013O0004A43O002E2O010012D5000200013O0026700002001C2O0100010004A43O001C2O012O00030003000F3O0020CE0003000300244O000400113O00202O00040004001B4O000500153O00202O00050005002500122O000600266O0003000600024O000300146O000300143O00062O0003002E2O013O0004A43O002E2O012O0003000300144O0010000300023O0004A43O002E2O010004A43O001C2O010012D5000100023O0026700001007F2O0100020004A43O007F2O012O0003000200223O000610010200482O013O0004A43O00482O010012D5000200013O002670000200352O0100010004A43O00352O012O00030003000F3O00207A0003000300274O000400113O00202O0004000400284O000500153O00202O00050005002900122O000600266O000700016O0003000700024O000300146O000300143O00062O000300482O013O0004A43O00482O012O0003000300144O0010000300023O0004A43O00482O010004A43O00352O012O0003000200113O0020AF00020002002A00207F00020002002B3O000102000200020006100102007E2O013O0004A43O007E2O012O0003000200233O0006100102007E2O013O0004A43O007E2O012O0003000200113O0020AF00020002002A00207F00020002001C3O000102000200020006100102007E2O013O0004A43O007E2O012O0003000200073O0006100102007E2O013O0004A43O007E2O012O0003000200243O0006100102007E2O013O0004A43O007E2O012O0003000200033O00207F00020002002C3O000102000200020006450002007E2O0100010004A43O007E2O012O0003000200033O00207F00020002002D3O000102000200020006450002007E2O0100010004A43O007E2O012O00030002000F3O0020AF00020002002E2O0003000300015O000102000200020006100102007E2O013O0004A43O007E2O012O0003000200254O008C000300113O00202O00030003002A4O000400013O00202O00040004002F4O000600113O00202O00060006002A4O0004000600024O000400046O00020004000200062O0002007E2O013O0004A43O007E2O012O0003000200063O0012D5000300303O0012D5000400314O00AA000200044O000E00025O0012D5000100093O0026700001008A2O0100090004A43O008A2O012O0003000200264O00120102000100022O0048000200144O0003000200143O000610010200BD2O013O0004A43O00BD2O012O0003000200144O0010000200023O0004A43O00BD2O010026700001000E2O0100010004A43O000E2O0100120D000200323O0006100102009F2O013O0004A43O009F2O012O0003000200133O0006100102009F2O013O0004A43O009F2O010012D5000200013O002670000200932O0100010004A43O00932O012O0003000300274O00120103000100022O0048000300144O0003000300143O0006100103009F2O013O0004A43O009F2O012O0003000300144O0010000300023O0004A43O009F2O010004A43O00932O012O0003000200284O00120102000100022O0048000200143O0012D50001000A3O0004A43O000E2O010004A43O00BD2O010026703O0001000100010004A43O000100012O0003000100294O001C2O01000100014O0001002A6O00010001000100122O0001000B3O00202O00010001000C4O000200063O00122O000300333O00122O000400346O0002000400024O0001000100024O0001001E3O00122O0001000B3O00202O00010001000C4O000200063O00122O000300353O00122O000400366O0002000400024O0001000100024O000100083O00124O000A3O00044O000100012O002E012O00017O00043O00028O0003053O005072696E7403313O00A4D8B388F9A983D6A4CDAB8B96D0B584B68AC2D3B8CD9C948BD2EFCD8A9192C1AE9FAD818691A394F99CA9D0AF88AD8BCC03063O00E4E2B1C1EDD9000F3O0012D53O00013O000E060001000100013O0004A43O000100012O000300016O00610001000100014O000100013O00202O0001000100024O000200023O00122O000300033O00122O000400046O000200046O00013O000100044O000E00010004A43O000100012O002E012O00017O00", GetFEnv(), ...);
