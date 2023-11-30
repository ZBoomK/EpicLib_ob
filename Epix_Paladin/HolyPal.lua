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
				if (Enum <= 152) then
					if (Enum <= 75) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
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
										elseif (Enum == 2) then
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
											VIP = Inst[3];
										else
											local A = Inst[2];
											do
												return Unpack(Stk, A, A + Inst[3]);
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
											local A = Inst[2];
											local B = Inst[3];
											for Idx = A, B do
												Stk[Idx] = Vararg[Idx - A];
											end
										end
									elseif (Enum <= 6) then
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 7) then
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 13) then
									if (Enum <= 10) then
										if (Enum > 9) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum <= 11) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 12) then
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
										Stk[Inst[2]] = not Stk[Inst[3]];
									end
								elseif (Enum <= 15) then
									if (Enum == 14) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 16) then
									if (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 17) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum > 19) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 21) then
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum <= 24) then
									if (Enum == 23) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 25) then
									local A = Inst[2];
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								elseif (Enum > 26) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum > 28) then
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
								elseif (Enum <= 30) then
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
								elseif (Enum == 31) then
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
							elseif (Enum <= 34) then
								if (Enum == 33) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 35) then
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
							elseif (Enum > 36) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum == 38) then
											local A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
										else
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
											Stk[Inst[2]] = Inst[3];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 40) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 43) then
									if (Enum > 42) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 44) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 45) then
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
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum == 47) then
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
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 49) then
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
								elseif (Enum > 50) then
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
							elseif (Enum <= 53) then
								if (Enum > 52) then
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
							elseif (Enum <= 54) then
								do
									return;
								end
							elseif (Enum > 55) then
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
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
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum == 57) then
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
								elseif (Enum == 59) then
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
							elseif (Enum <= 62) then
								if (Enum > 61) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
							elseif (Enum <= 63) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 64) then
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
							end
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum == 66) then
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
							elseif (Enum <= 68) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 69) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 72) then
							if (Enum > 71) then
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
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 73) then
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
							Stk[Inst[2]] = Inst[3];
						elseif (Enum > 74) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum > 76) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											Stk[Inst[2]] = Inst[3];
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
											if (Stk[Inst[2]] ~= Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 78) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 81) then
									if (Enum > 80) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									end
								elseif (Enum <= 82) then
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
								elseif (Enum == 83) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 89) then
								if (Enum <= 86) then
									if (Enum == 85) then
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
								elseif (Enum <= 87) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								elseif (Enum == 88) then
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
								if (Enum > 90) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									A = Inst[2];
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
							elseif (Enum > 93) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum == 95) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 100) then
								if (Enum > 99) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 101) then
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
							elseif (Enum == 102) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
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
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum > 104) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								else
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 106) then
								Stk[Inst[2]] = {};
							elseif (Enum == 107) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 110) then
							if (Enum > 109) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 111) then
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
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum > 112) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 132) then
						if (Enum <= 122) then
							if (Enum <= 117) then
								if (Enum <= 115) then
									if (Enum == 114) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum > 116) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 119) then
								if (Enum == 118) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 120) then
								Stk[Inst[2]]();
							elseif (Enum > 121) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum == 123) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 125) then
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
								do
									return Stk[Inst[2]]();
								end
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
						elseif (Enum <= 130) then
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
						elseif (Enum == 131) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum > 133) then
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
							elseif (Enum <= 135) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 136) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 139) then
							if (Enum == 138) then
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
						elseif (Enum <= 140) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 141) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 147) then
						if (Enum <= 144) then
							if (Enum == 143) then
								Stk[Inst[2]] = Stk[Inst[3]];
							else
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 145) then
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						elseif (Enum > 146) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 149) then
						if (Enum > 148) then
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						end
					elseif (Enum <= 150) then
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
					elseif (Enum == 151) then
						local A;
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
					else
						local B = Stk[Inst[4]];
						if B then
							VIP = VIP + 1;
						else
							Stk[Inst[2]] = B;
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 229) then
					if (Enum <= 190) then
						if (Enum <= 171) then
							if (Enum <= 161) then
								if (Enum <= 156) then
									if (Enum <= 154) then
										if (Enum > 153) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 155) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Inst[3] ~= 0;
									end
								elseif (Enum <= 158) then
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
								elseif (Enum <= 159) then
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
								elseif (Enum == 160) then
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
							elseif (Enum <= 166) then
								if (Enum <= 163) then
									if (Enum == 162) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 164) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 165) then
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
									VIP = Inst[3];
								end
							elseif (Enum <= 168) then
								if (Enum > 167) then
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
							elseif (Enum <= 169) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 180) then
							if (Enum <= 175) then
								if (Enum <= 173) then
									if (Enum > 172) then
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
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
									end
								elseif (Enum == 174) then
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
									if (Inst[2] == Inst[4]) then
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
							elseif (Enum <= 177) then
								if (Enum > 176) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 178) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 179) then
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
							end
						elseif (Enum <= 185) then
							if (Enum <= 182) then
								if (Enum > 181) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 184) then
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
									if (Mvm[1] == 143) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
						elseif (Enum <= 187) then
							if (Enum > 186) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
						elseif (Enum <= 188) then
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
						elseif (Enum > 189) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Stk[Inst[4]]];
						end
					elseif (Enum <= 209) then
						if (Enum <= 199) then
							if (Enum <= 194) then
								if (Enum <= 192) then
									if (Enum > 191) then
										local A;
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
								elseif (Enum == 193) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 196) then
								if (Enum == 195) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 197) then
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
							elseif (Enum == 198) then
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
						elseif (Enum <= 204) then
							if (Enum <= 201) then
								if (Enum == 200) then
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
									if (Inst[2] < Inst[4]) then
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
							elseif (Enum <= 202) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 203) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 206) then
							if (Enum > 205) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							end
						elseif (Enum <= 207) then
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
						elseif (Enum == 208) then
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
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 219) then
						if (Enum <= 214) then
							if (Enum <= 211) then
								if (Enum > 210) then
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Env[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 212) then
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
							elseif (Enum == 213) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 216) then
							if (Enum > 215) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 217) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 218) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 224) then
						if (Enum <= 221) then
							if (Enum == 220) then
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
						elseif (Enum <= 222) then
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
						elseif (Enum > 223) then
							if (Inst[2] <= Stk[Inst[4]]) then
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
					elseif (Enum <= 226) then
						if (Enum > 225) then
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
					elseif (Enum <= 227) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 228) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 267) then
					if (Enum <= 248) then
						if (Enum <= 238) then
							if (Enum <= 233) then
								if (Enum <= 231) then
									if (Enum > 230) then
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
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum == 232) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Enum == 234) then
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
							elseif (Enum <= 236) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 237) then
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
						elseif (Enum <= 243) then
							if (Enum <= 240) then
								if (Enum == 239) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 245) then
							if (Enum == 244) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 246) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 247) then
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
							if (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 257) then
						if (Enum <= 252) then
							if (Enum <= 250) then
								if (Enum > 249) then
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum > 251) then
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
							elseif (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 254) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 255) then
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
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 256) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						end
					elseif (Enum <= 262) then
						if (Enum <= 259) then
							if (Enum > 258) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local T;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 260) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 261) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 264) then
						if (Enum > 263) then
							if (Stk[Inst[2]] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 265) then
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
					elseif (Enum == 266) then
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 286) then
					if (Enum <= 276) then
						if (Enum <= 271) then
							if (Enum <= 269) then
								if (Enum > 268) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								else
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum > 270) then
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
						elseif (Enum <= 273) then
							if (Enum > 272) then
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
						elseif (Enum <= 274) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 275) then
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
					elseif (Enum <= 281) then
						if (Enum <= 278) then
							if (Enum == 277) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 279) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 280) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 283) then
						if (Enum == 282) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 284) then
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
					elseif (Enum == 285) then
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
				elseif (Enum <= 296) then
					if (Enum <= 291) then
						if (Enum <= 288) then
							if (Enum > 287) then
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
						elseif (Enum <= 289) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 290) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 293) then
						if (Enum > 292) then
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
					elseif (Enum <= 294) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 295) then
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
				elseif (Enum <= 301) then
					if (Enum <= 298) then
						if (Enum > 297) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 299) then
						local Edx;
						local Results;
						local A;
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
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum == 300) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 303) then
					if (Enum > 302) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
					end
				elseif (Enum <= 304) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum > 305) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503183O00F4D3D23DD98BC612D0C7D22BD993C812C8F3DA29A8B7D21F03083O007EB1A3BB4586DBA703183O0038B983B31C491CA58BAF2A77228185A73A491CA5C4A7367803063O00197DC9EACB43002E3O0012FC3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004A63O000A0001001238000300063O002018010400030007001238000500083O002018010500050009001238000600083O00201801060006000A0006B800073O000100062O008F3O00064O008F8O008F3O00044O008F3O00014O008F3O00024O008F3O00053O00201801080003000B00201801090003000C2O006A000A5O001238000B000D3O0006B8000C0001000100022O008F3O000A4O008F3O000B4O008F000D00073O0012E6000E000E3O0012E6000F000F4O0069000D000F00020006B8000E0002000100032O008F3O00074O008F3O00094O008F3O00084O00E8000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001001025O00122O000300016O00045O00122O000500013O00042O0003002100012O002E01076O00E7000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O000100043E0003000500012O002E010300054O008F000400024O00D6000300044O000D01036O00363O00017O00093O00028O00025O00308C40026O00F03F025O00DEA340025O0050AA40025O00B88140025O00F1B140025O006CA840025O0065B04001343O0012E6000200014O0020010300043O002EFB0002002B000100020004A63O002D00010026070102002D000100030004A63O002D00010012E6000500013O0026080005000B000100010004A63O000B0001002E7700050007000100040004A63O0007000100260701030011000100030004A63O001100012O008F000600044O001100076O00CB00066O000D01065O00260800030015000100010004A63O00150001002E7700070006000100060004A63O000600010012E6000600013O00260701060024000100010004A63O002400012O002E01076O00EE000400073O00061E0104001E00013O0004A63O001E0001002ED300090023000100080004A63O002300012O002E010700014O008F00086O001100096O00CB00076O000D01075O0012E6000600033O00260701060016000100030004A63O001600010012E6000300033O0004A63O000600010004A63O001600010004A63O000600010004A63O000700010004A63O000600010004A63O0033000100260701020002000100010004A63O000200010012E6000300014O0020010400043O0012E6000200033O0004A63O000200012O00363O00017O00433O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203053O008D2B13236003073O009BCB44705613C503063O0076D137E5456A03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D903043O006D61746803053O00C1587F1BAB03063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D479030C3O00476574546F74656D496E666F03073O0047657454696D6503073O0037EFA9CF03E7AB03043O00AE678EC503043O007E27532103073O009836483F58453E03073O00E4C5E25DD0CDE003043O003CB4A48E03043O007051093003073O0072383E6549478D03073O0088E8D7C5BCE0D503043O00A4D889BB03043O00FAE93DAB03073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703063O0053657441504C025O0040504000F6013O002B000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0013001300142O002O01145O00122O001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000F00142O002O01155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O0014001400150012380015002A4O002E01165O0012320017002B3O00122O0018002C6O0016001800024O00150015001600122O0016002D6O00175O00122O0018002E3O00122O0019002F6O0017001900024O001600160017001238001700303O00125C001800316O00195O00122O001A00323O00122O001B00336O0019001B00024O0019000D00194O001A5O00122O001B00343O00122O001C00356O001A001C00022O002301190019001A4O001A5O00122O001B00363O00122O001C00376O001A001C00024O001A000E001A2O002O011B5O00122O001C00383O00122O001D00396O001B001D00024O001A001A001B4O001B5O00122O001C003A3O00122O001D003B6O001B001D00024O001B0011001B2O002E011C5O0012E6001D003C3O0012E6001E003D4O0069001C001E00022O00EE001B001B001C2O0020011C00704O009C00716O009600728O00738O00748O00758O00768O00778O007800796O007A5O00122O007B003E3O00122O007C003F4O0069007A007C00022O0023017A000F007A4O007B5O00122O007C00403O00122O007D00416O007B007D00024O007A007A007B0006B8007B3O000100012O008F3O00193O0006B8007C0001000100072O008F3O00174O008F3O00194O002E017O008F3O00154O002E012O00014O002E012O00024O008F3O00183O0006B8007D0002000100022O008F3O00194O008F3O00373O0006B8007E0003000100072O008F3O00194O002E017O008F3O00094O008F3O00084O008F3O007A4O008F3O00124O008F3O001B3O0006B8007F0004000100032O008F3O007A4O008F3O00774O008F3O00723O0006B800800005000100032O008F3O00094O008F3O007A4O008F3O00193O0006B800810006000100062O008F3O00084O008F3O007A4O008F3O00194O002E017O008F3O00124O008F3O001B3O0006B800820007000100042O008F3O00194O002E017O008F3O000B4O008F3O00123O0006B800830008000100112O008F3O00194O002E017O008F3O00094O008F3O00504O008F3O004F4O008F3O00124O008F3O001B4O008F3O001A4O008F3O00304O008F3O00314O008F3O00394O008F3O00384O008F3O003D4O008F3O003C4O008F3O001D4O008F3O001F4O008F3O001E3O0006B8008400090001000A2O008F3O007A4O008F3O00774O008F3O00724O008F3O00194O002E017O008F3O00124O008F3O00334O008F3O00094O008F3O00324O008F3O007E3O0006B80085000A000100182O008F3O00194O002E017O008F3O00794O008F3O007C4O008F3O00124O008F3O000B4O008F3O00094O008F3O001B4O008F3O000A4O008F3O00764O008F3O007A4O008F3O00554O008F3O00564O008F3O00504O008F3O005B4O008F3O00724O008F3O00844O008F3O003F4O008F3O00344O008F3O007D4O008F3O00354O008F3O00364O008F3O00754O008F3O00783O0006B80086000B000100262O008F3O00604O002E017O008F3O00194O008F3O00084O008F3O00614O008F3O007A4O008F3O00124O008F3O001B4O008F3O00094O008F3O00444O008F3O00454O008F3O00434O008F3O00394O008F3O00384O008F3O006B4O008F3O006C4O008F3O006A4O008F3O00584O008F3O00594O008F3O00574O008F3O00494O008F3O00484O008F3O00474O008F3O00464O008F3O00414O008F3O00424O008F3O00404O008F3O00674O008F3O00684O008F3O00694O008F3O00524O008F3O00534O008F3O00514O008F3O00664O008F3O00644O008F3O00654O008F3O00634O008F3O00623O0006B80087000C000100142O008F3O00194O002E017O008F3O007A4O008F3O00524O008F3O00534O008F3O00514O008F3O00124O008F3O001B4O008F3O00094O008F3O00084O008F3O00504O008F3O004F4O008F3O00554O008F3O00564O008F3O00764O008F3O005E4O008F3O005F4O008F3O000B4O008F3O000A4O008F3O007C3O0006B80088000D000100172O008F3O00194O002E017O008F3O00094O008F3O00084O008F3O00504O008F3O004F4O008F3O00124O008F3O001B4O008F3O00494O008F3O00484O008F3O004E4O008F3O004D4O008F3O004B4O008F3O004A4O008F3O004C4O008F3O005C4O008F3O005A4O008F3O007A4O008F3O005E4O008F3O005F4O008F3O005D4O008F3O000B4O008F3O000A3O0006B80089000E000100032O008F3O00084O008F3O00874O008F3O00883O0006B8008A000F000100152O008F3O00834O008F3O00864O008F3O007A4O008F3O00194O002E017O008F3O00084O008F3O00124O008F3O001B4O008F3O000D4O008F3O00854O008F3O00844O008F3O00804O008F3O00894O008F3O00244O008F3O00814O008F3O00264O008F3O006F4O008F3O00704O008F3O00274O008F3O00284O008F3O00093O0006B8008B0010000100102O008F3O00244O008F3O00814O008F3O00264O008F3O007A4O008F3O00194O008F3O001B4O002E017O008F3O00094O008F3O00124O008F3O00824O008F3O00274O008F3O00284O008F3O00714O008F3O006F4O008F3O00704O008F3O00893O0006B8008C00110001002B2O008F3O00314O002E017O008F3O00324O008F3O002B4O008F3O00304O008F3O00334O008F3O00484O008F3O00494O008F3O00264O008F3O00274O008F3O002A4O008F3O00284O008F3O00294O008F3O00234O008F3O00244O008F3O00214O008F3O00224O008F3O00254O008F3O00434O008F3O00444O008F3O00474O008F3O00454O008F3O00464O008F3O00344O008F3O00354O008F3O00364O008F3O00374O008F3O00384O008F3O001C4O008F3O001D4O008F3O001E4O008F3O001F4O008F3O00204O008F3O003B4O008F3O003C4O008F3O003D4O008F3O00394O008F3O003A4O008F3O00424O008F3O004F4O008F3O003F4O008F3O00404O008F3O00413O0006B8008D0012000100282O008F3O004E4O002E017O008F3O004C4O008F3O004D4O008F3O004A4O008F3O004B4O008F3O00594O008F3O005A4O008F3O005B4O008F3O005C4O008F3O005D4O008F3O00684O008F3O00694O008F3O006A4O008F3O006B4O008F3O006C4O008F3O00514O008F3O00524O008F3O004F4O008F3O00504O008F3O00534O008F3O00544O008F3O00554O008F3O00564O008F3O00574O008F3O00584O008F3O00654O008F3O00664O008F3O00634O008F3O00644O008F3O00674O008F3O006D4O008F3O006E4O008F3O006F4O008F3O00704O008F3O005E4O008F3O005F4O008F3O00604O008F3O00614O008F3O00623O0006B8008E0013000100142O008F3O00734O002E017O008F3O00744O008F3O00754O008F3O00764O008F3O008C4O008F3O008D4O008F3O00714O008F3O00724O008F3O00094O008F3O000B4O008F3O007A4O008F3O00194O008F3O00124O008F3O00244O008F3O001B4O008F3O00784O008F3O00794O008F3O008A4O008F3O008B3O0006B8008F0014000100042O008F3O000F4O002E017O008F3O007A4O008F3O00063O0020510090000F004200122O009100436O0092008E6O0093008F6O0090009300016O00013O00153O00023O0003113O00446562752O665265667265736861626C65030E3O004A7564676D656E74446562752O6601063O00201F2O013O00014O00035O00202O0003000300024O000100036O00019O0000017O00103O00028O00026O00F03F025O00349640025O00E89240026O001040027O0040026O000840025O00309C40025O00A6A340025O0080A740025O00109E40030C3O00323FBC2B4B343B1024BB374003073O00497150D2582E5703043O004E616D65026O00E03F025O00707240008F3O0012E63O00014O00202O0100023O002607012O0088000100020004A63O0088000100260800010008000100010004A63O00080001002ED300030004000100040004A63O000400010012E6000200013O00260701020009000100010004A63O000900010012E6000300013O0026070103000C000100010004A63O000C00010012E6000400013O0026070104000F000100010004A63O000F00010012E6000500023O0012E6000600053O0012E6000700023O0004290105008000010012E6000900014O0020010A000F3O0026070109001C000100010004A63O001C00010012E6000A00014O0020010B000B3O0012E6000900023O00260701090020000100020004A63O002000012O0020010C000D3O0012E6000900063O0026070109007A000100070004A63O007A0001002E7700080065000100090004A63O00650001002607010A0065000100060004A63O006500012O0020010F000F3O002ED3000B00270001000A0004A63O00270001002607010B0027000100010004A63O002700012O002E01106O002B011100086O0010000200134O000F00136O000E00126O000D00116O000C00106O001000016O001100023O00122O0012000C3O00122O0013000D4O00690011001300022O00EE00100010001100205F00100010000E2O00900010000200020006AB000D003D000100100004A63O003D00010004A63O007F00012O002E011000034O00C0001100046O001200046O0013000E6O0014000F6O0012001400024O001300056O0014000E6O0015000F6O0013001500024O0012001200132O002E011300064O00F30013000100024O00120012001300122O0013000F6O0011001300024O001200056O001300046O0014000E6O0015000F6O0013001500024O001400054O008F0015000E4O00CD0016000F6O0014001600024O0013001300144O001400066O0014000100024O00130013001400122O0014000F6O0012001400024O0011001100124O00100002000200062501100061000100010004A63O006100010012E6001000014O003B001000023O0004A63O007F00010004A63O002700010004A63O007F0001002607010A0069000100020004A63O006900012O0020010D000E3O0012E6000A00063O002607010A0022000100010004A63O002200010012E6001000013O00260701100070000100020004A63O007000010012E6000A00023O0004A63O00220001002EFB001000FCFF2O00100004A63O006C00010026070110006C000100010004A63O006C00010012E6000B00014O0020010C000C3O0012E6001000023O0004A63O006C00010004A63O002200010004A63O007F000100260701090017000100060004A63O001700012O0020010E000F3O0012E6000900073O0004A63O0017000100043E0005001500010012E6000500014O003B000500023O0004A63O000F00010004A63O000C00010004A63O000900010004A63O008E00010004A63O000400010004A63O008E0001000E470001000200013O0004A63O000200010012E6000100014O0020010200023O0012E63O00023O0004A63O000200012O00363O00017O00023O0003113O00446562752O665265667265736861626C6503123O00476C692O6D65726F664C6967687442752O66010A3O00205B00013O00014O00035O00202O0003000300024O00010003000200062O00010008000100010004A63O000800012O002E2O0100014O000C000100014O003B000100024O00363O00017O002A3O00028O00025O00DCB240025O00F49A40026O00F03F025O0069B040025O00CCA040025O0008A840025O003AB240025O00AC9F40025O00ACA740025O005AA940025O00DCAB4003103O00A320C801F48822CA1DE1B239C01FE29303053O0087E14CAD72030A3O0049734361737461626C6503093O004973496E506172747903083O004973496E52616964025O0086A440025O00D0774003063O00457869737473030D3O00556E697447726F7570526F6C6503073O003ECC95918B989503073O00C77A8DD8D0CCDD03153O00426C652O73696E676F6653752O6D6572466F63757303123O00AFD115E36BFFA3DA2FFF7EC9BEC81DFD7DE403063O0096CDBD70901803103O000788BA5F17811F172A828C5C16811F1703083O007045E4DF2C64E87103103O00F61302C0A57588D31001E0A3718BD10D03073O00E6B47F67B3D61C03103O00AE095A55F748EE8B0A5967F155F5810B03073O0080EC653F26842103103O008EA51457A5E2C1ABA61773BFE5DBA9BB03073O00AFCCC97124D68B025O00B07140025O00C0B14003053O007061697273025O00508340025O00D8AD4003163O00426C652O73696E676F6653752O6D6572506C6179657203173O0045C030CF174EC232E30B41F321D40178DF30DD1748C22603053O006427AC55BC00943O0012E63O00014O00202O0100023O002E7700030013000100020004A63O00130001002607012O0013000100010004A63O001300010012E6000300013O0026070103000B000100040004A63O000B00010012E63O00043O0004A63O001300010026080003000F000100010004A63O000F0001002ED300050007000100060004A63O000700010012E6000100014O0020010200023O0012E6000300043O0004A63O00070001000E100004001700013O0004A63O00170001002E7700080002000100070004A63O000200010026080001001B000100010004A63O001B0001002E77000A0076000100090004A63O007600010012E6000300013O002E77000B006F0001000C0004A63O006F0001000E470001006F000100030004A63O006F00012O002E01046O007E000500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004003400013O0004A63O003400012O002E010400023O00205F0004000400102O009000040002000200061E0104003400013O0004A63O003400012O002E010400023O00205F0004000400112O009000040002000200061E0104003600013O0004A63O00360001002E7700120053000100130004A63O005300012O002E010400033O00061E0104005300013O0004A63O005300012O002E010400033O00205F0004000400142O009000040002000200061E0104005300013O0004A63O005300012O002E010400043O0020A10004000400154O000500036O0004000200024O000500013O00122O000600163O00122O000700176O00050007000200062O00040053000100050004A63O005300012O002E010400054O002E010500063O0020180105000500182O009000040002000200061E0104005300013O0004A63O005300012O002E010400013O0012E6000500193O0012E60006001A4O00D6000400064O000D01046O006A000400044O000201058O000600013O00122O0007001B3O00122O0008001C6O0006000800024O0005000500064O00068O000700013O00122O0008001D3O00122O0009001E6O0007000900024O0006000600074O00078O000800013O00122O0009001F3O00122O000A00206O0008000A00024O0007000700084O00088O000900013O00122O000A00213O00122O000B00226O0009000B00024O0008000800094O0004000400012O008F000200043O0012E6000300043O002ED30023001C000100240004A63O001C00010026070103001C000100040004A63O001C00010012E6000100043O0004A63O007600010004A63O001C00010026072O010017000100040004A63O00170001001238000300254O008F000400024O00680003000200050004A63O008D000100205F00080007000F2O009000080002000200061E0108008D00013O0004A63O008D0001002ED30026008D000100270004A63O008D00012O002E010800054O002E010900063O0020180109000900282O009000080002000200061E0108008D00013O0004A63O008D00012O002E010800013O0012E6000900293O0012E6000A002A4O00D60008000A4O000D01085O0006BC0003007C000100020004A63O007C00010004A63O009300010004A63O001700010004A63O009300010004A63O000200012O00363O00017O000A3O00028O00025O00BFB040026O005F40025O0012A440025O009CAE40026O00F03F030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574026O00444003133O0048616E646C65426F2O746F6D5472696E6B6574003D3O0012E63O00014O00202O0100013O002E7700030002000100020004A63O00020001002607012O0002000100010004A63O000200010012E6000100013O000E4700010029000100010004A63O002900010012E6000200013O00260701020024000100010004A63O002400010012E6000300013O002E7700040013000100050004A63O0013000100260701030013000100060004A63O001300010012E6000200063O0004A63O002400010026070103000D000100010004A63O000D00012O002E01045O0020820004000400084O000500016O000600023O00122O000700096O000800086O00040008000200122O000400073O00122O000400073O00062O0004002200013O0004A63O00220001001238000400074O003B000400023O0012E6000300063O0004A63O000D00010026070102000A000100060004A63O000A00010012E6000100063O0004A63O002900010004A63O000A00010026072O010007000100060004A63O000700012O002E01025O00208200020002000A4O000300016O000400023O00122O000500096O000600066O00020006000200122O000200073O00122O000200073O00062O0002003C00013O0004A63O003C0001001238000200074O003B000200023O0004A63O003C00010004A63O000700010004A63O003C00010004A63O000200012O00363O00017O000C3O0003093O00497343617374696E67030C3O0049734368612O6E656C696E67028O00026O00F03F03113O00496E74652O72757074576974685374756E030F3O0048612O6D65726F664A757374696365026O002040025O00A4A840025O00B89F4003093O00496E74652O7275707403063O00526562756B65026O00144000334O002E016O00205F5O00012O00903O00020002000625012O0032000100010004A63O003200012O002E016O00205F5O00022O00903O00020002000625012O0032000100010004A63O003200010012E63O00034O00202O0100013O000E470004001B00013O0004A63O001B00012O002E010200013O00201D0002000200054O000300023O00202O00030003000600122O000400076O0002000400024O000100023O00062O00010019000100010004A63O00190001002E7700080032000100090004A63O003200012O003B000100023O0004A63O00320001002607012O000C000100030004A63O000C00010012E6000200033O000E4700040022000100020004A63O002200010012E63O00043O0004A63O000C00010026070102001E000100030004A63O001E00012O002E010300013O00201201030003000A4O000400023O00202O00040004000B00122O0005000C6O000600016O0003000600024O000100033O00062O0001002F00013O0004A63O002F00012O003B000100023O0012E6000200043O0004A63O001E00010004A63O000C00012O00363O00017O00113O00028O00025O0062AD40025O00508540025O002OA040025O00208A4003063O0045786973747303093O004973496E52616E6765026O00444003173O0044697370652O6C61626C65467269656E646C79556E697403073O008E74BC813DBE7D03053O0053CD18D9E003073O0049735265616479030C3O00436C65616E7365466F637573025O0072A240025O009C9040030E3O00E5C9C83CE8D6C87DE2CCDE2DE3C903043O005D86A5AD003B3O0012E63O00014O00202O0100013O000E100001000600013O0004A63O00060001002E7700020002000100030004A63O000200010012E6000100013O0026072O010007000100010004A63O00070001002ED30005001F000100040004A63O001F00012O002E01025O00061E0102001E00013O0004A63O001E00012O002E01025O00205F0002000200062O009000020002000200061E0102001E00013O0004A63O001E00012O002E01025O00205F0002000200070012E6000400084O006900020004000200061E0102001E00013O0004A63O001E00012O002E010200013O0020180102000200092O00D50002000100020006250102001F000100010004A63O001F00012O00363O00014O002E010200024O007E000300033O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002003A00013O0004A63O003A00012O002E010200044O002E010300053O00201801030003000D2O009000020002000200062501020031000100010004A63O00310001002E77000E003A0001000F0004A63O003A00012O002E010200033O00127D000300103O00122O000400116O000200046O00025O00044O003A00010004A63O000700010004A63O003A00010004A63O000200012O00363O00017O00163O00028O00030C3O009DFDCFD13FCDA07FAAFBCECC03083O001EDE92A1A25AAED2030A3O0049734361737461626C65030E3O004973496E4D656C2O6552616E6765026O001440025O00F89B40025O002AA940030C3O00436F6E736563726174696F6E03163O00E6417E19E04D620BF14B301AF74B7305E84C711EA51A03043O006A852E10025O006BB140025O0016AE4003083O00723577FB5745563403063O00203840139C3A03073O004973526561647903083O004A7564676D656E74030E3O0049735370652O6C496E52616E6765025O0032A740025O00109D4003143O0050DDE15157F78E4E88F5445FF18F57CAE4421AA403073O00E03AA885363A9200423O0012E63O00013O002607012O0001000100010004A63O000100012O002E2O016O007E000200013O00122O000300023O00122O000400036O0002000400024O00010001000200202O0001000100044O00010002000200062O0001001300013O0004A63O001300012O002E2O0100023O00205F0001000100050012E6000300064O00690001000300020006252O010015000100010004A63O00150001002E7700080020000100070004A63O002000012O002E2O0100034O002E01025O0020180102000200092O009000010002000200061E2O01002000013O0004A63O002000012O002E2O0100013O0012E60002000A3O0012E60003000B4O00D6000100034O000D2O015O002E77000D00410001000C0004A63O004100012O002E2O016O007E000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200202O0001000100104O00010002000200062O0001004100013O0004A63O004100012O002E2O0100034O004A00025O00202O0002000200114O000300023O00202O0003000300124O00055O00202O0005000500114O0003000500024O000300036O00010003000200062O0001003A000100010004A63O003A0001002E7700130041000100140004A63O004100012O002E2O0100013O00127D000200153O00122O000300166O000100036O00015O00044O004100010004A63O000100012O00363O00017O003E3O00028O00025O0096A040025O00804340026O00F03F025O00A8A040025O00206940025O00F2B040025O007DB140030B3O008AD63248B2DF0740B2CB3903043O002CDDB94003073O004973526561647903093O00486F6C79506F776572026O00084003103O004865616C746850657263656E74616765030F3O004865616C696E674162736F72626564025O00109B40025O00B2AB4003113O00576F72646F66476C6F7279506C6179657203083O0036C86F1F6004EB4E03053O00136187283F030B3O00865932373B39BD483C352A03063O0051CE3C535B4F025O00949140026O005040030B3O004865616C746873746F6E6503173O0046AED17E3BCB5EB041A5D5322BC64BA140B8D9642A831E03083O00C42ECBB0124FA32D027O0040025O001EA940025O004AAF40025O00DEA240025O00C88440030A3O00755752F27BAE86055D4503083O006B39362B9D15E6E7030A3O0049734361737461626C6503103O004C61796F6E48616E6473506C61796572025O00049140025O003AA14003163O00D78A08CAB6D2F0D38A1FF1AA9CCBDE8D14FBAAD5D9DE03073O00AFBBEB7195D9BC03103O0018A69745ED7C482EA09549E06D7133A103073O00185CCFE12C8319025O00C4A040025O00A0834003103O00446976696E6550726F74656374696F6E025O00AEAA40025O0061B14003113O004FDAAE4515780BC3AA430F7848C7B1431503063O001D2BB3D82C7B025O00949B40025O00D6B040025O00508C40026O00694003193O008A27780C21E8E7B12C795E0CFEEEB42B701964CBE0AC2B711003073O008FD8421E7E449B03173O0098CD0BD9C0B0DFE8A4CF25CEC4AFDEEFADF802DFCCACD903083O0081CAA86DABA5C3B7026O00A840025O00AAA04003173O0052656672657368696E674865616C696E67506F74696F6E03253O00305D31CADB07EE2B563098D611E72E5139DF9E04E9365138D69E10E3245D39CBD702E3620C03073O0086423857B8BE7400E13O0012E63O00014O00202O0100023O000E100001000600013O0004A63O00060001002EFB00020005000100030004A63O000900010012E6000100014O0020010200023O0012E63O00043O000E100004000D00013O0004A63O000D0001002E7700050002000100060004A63O0002000100260800010011000100010004A63O00110001002E770008000D000100070004A63O000D00010012E6000200013O00260701020061000100040004A63O006100012O002E01036O007E000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003003100013O0004A63O003100012O002E010300023O00205F00030003000C2O0090000300020002000EE0000D0031000100030004A63O003100012O002E010300023O00205F00030003000E2O00900003000200022O002E010400033O00062100030031000100040004A63O003100012O002E010300043O00061E0103003100013O0004A63O003100012O002E010300023O00205F00030003000F2O009000030002000200061E0103003300013O0004A63O00330001002E770011003E000100100004A63O003E00012O002E010300054O002E010400063O0020180104000400122O009000030002000200061E0103003E00013O0004A63O003E00012O002E010300013O0012E6000400133O0012E6000500144O00D6000300054O000D01036O002E010300074O007E000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003006000013O0004A63O006000012O002E010300083O00061E0103006000013O0004A63O006000012O002E010300023O00205F00030003000E2O00900003000200022O002E010400093O00062100030060000100040004A63O00600001002E7700180060000100170004A63O006000012O002E010300054O0048000400063O00202O0004000400194O000500066O000700016O00030007000200062O0003006000013O0004A63O006000012O002E010300013O0012E60004001A3O0012E60005001B4O00D6000300054O000D01035O0012E60002001C3O00260800020065000100010004A63O00650001002ED3001E00AA0001001D0004A63O00AA0001002ED3002000870001001F0004A63O008700012O002E010300023O00205F00030003000E2O00900003000200022O002E0104000A3O00062100030087000100040004A63O008700012O002E0103000B3O00061E0103008700013O0004A63O008700012O002E01036O007E000400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300234O00030002000200062O0003008700013O0004A63O008700012O002E010300054O002E010400063O0020180104000400242O009000030002000200062501030082000100010004A63O00820001002ED300260087000100250004A63O008700012O002E010300013O0012E6000400273O0012E6000500284O00D6000300054O000D01036O002E01036O007E000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O0003000300234O00030002000200062O0003009A00013O0004A63O009A00012O002E010300023O00205F00030003000E2O00900003000200022O002E0104000C3O0006210003009A000100040004A63O009A00012O002E0103000D3O0006250103009C000100010004A63O009C0001002E77002B00A90001002C0004A63O00A900012O002E010300054O002E01045O00201801040004002D2O0090000300020002000625010300A4000100010004A63O00A40001002E77002F00A90001002E0004A63O00A900012O002E010300013O0012E6000400303O0012E6000500314O00D6000300054O000D01035O0012E6000200043O002608000200AE0001001C0004A63O00AE0001002ED300330012000100320004A63O00120001002ED3003500E0000100340004A63O00E000012O002E0103000E3O00061E010300E000013O0004A63O00E000012O002E010300023O00205F00030003000E2O00900003000200022O002E0104000F3O000621000300E0000100040004A63O00E000012O002E010300104O00F6000400013O00122O000500363O00122O000600376O00040006000200062O000300C1000100040004A63O00C100010004A63O00E000012O002E010300074O00BE000400013O00122O000500383O00122O000600396O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300CD000100010004A63O00CD0001002E77003A00E00001003B0004A63O00E000012O002E010300054O0048000400063O00202O00040004003C4O000500066O000700016O00030007000200062O000300E000013O0004A63O00E000012O002E010300013O00127D0004003D3O00122O0005003E6O000300056O00035O00044O00E000010004A63O001200010004A63O00E000010004A63O000D00010004A63O00E000010004A63O000200012O00363O00017O003D3O00028O00025O00408C40025O00E09540026O00F03F027O0040025O00708640025O002EAE4003133O0048616E646C65426F2O746F6D5472696E6B6574026O00444003083O008951A441AA5CBF4D03043O0020DA34D603073O004973526561647903083O00536572617068696D03153O005D1223A9E1B84C570E143EA7FDB44A4D400471F9A903083O003A2E7751C891D025030B3O009B2703E5F14DB62608F9C203063O003BD3486F9CB0030A3O0049734361737461626C65030B3O00486F6C794176656E676572025O0066A340025O005EA14003193O004688EF347186F5284080E63F0E84EC224283EC3A4094A37C1803043O004D2EE78303103O0048616E646C65546F705472696E6B657403093O00A021AA45D86604903403073O0071E24DC52ABC2003093O00426C2O6F644675727903173O00381AFBBA3E29F2A0280FB4B63519F8B13501FAA67A47A603043O00D55A7694025O00F49540025O00E88940030A3O00792BA645484925BD584A03053O002D3B4ED436030A3O004265727365726B696E6703173O0012539198833CA6F91E51C3888921A1F41F418D98C67FF903083O00907036E3EBE64ECD025O001AAA40026O00AE40025O00408F40025O00C8A440025O00D09D40030A3O00FB16E21534DA2BFB103603053O005ABF7F947C03063O0042752O66557003113O004176656E67696E67577261746842752O66025O00E0A140025O009EA340030A3O00446976696E65546F2O6C03173O007C8E381E76821103778B22577B88211B7C8839196BC77603043O007718E74E030D3O001D270CB51EE22F320B2308AF1103083O00555C5169DB798B41030D3O004176656E67696E675772617468025O0010AC40025O0039B140031A3O00FCA5554B7BD6F3B46F526EDEE9BB104673D0F1B75F5272CCBDE703063O00BF9DD330251C025O00E9B240025O005EA740025O005EA640025O00D8A340000A012O0012E63O00014O00202O0100023O002E77000200F7000100030004A63O00F70001002607012O00F7000100040004A63O00F700010026080001000A000100050004A63O000A0001002ED30007002E000100060004A63O002E000100061E0102000D00013O0004A63O000D00012O003B000200024O002E01035O00203F0003000300084O000400016O000500023O00122O000600096O000700076O0003000700024O000200033O00062O0002001800013O0004A63O001800012O003B000200024O002E010300034O007E000400043O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300092O013O0004A63O00092O012O002E010300054O002E010400033O00201801040004000D2O009000030002000200061E010300092O013O0004A63O00092O012O002E010300043O00127D0004000E3O00122O0005000F6O000300056O00035O00044O00092O01000E470004008F000100010004A63O008F00010012E6000300014O0020010400043O00260701030032000100010004A63O003200010012E6000400013O000E4700040057000100040004A63O005700012O002E010500034O007E000600043O00122O000700103O00122O000800116O0006000800024O00050005000600202O0005000500124O00050002000200062O0005004E00013O0004A63O004E00012O002E010500054O002E010600033O0020180106000600132O009000050002000200062501050049000100010004A63O00490001002EFB00140007000100150004A63O004E00012O002E010500043O0012E6000600163O0012E6000700174O00D6000500074O000D01056O002E01055O0020300005000500184O000600016O000700023O00122O000800096O000900096O0005000900024O000200053O00122O000400053O00260701040086000100010004A63O008600012O002E010500034O007E000600043O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O0005000500124O00050002000200062O0005006E00013O0004A63O006E00012O002E010500054O002E010600033O00201801060006001B2O009000050002000200061E0105006E00013O0004A63O006E00012O002E010500043O0012E60006001C3O0012E60007001D4O00D6000500074O000D01055O002E77001F00850001001E0004A63O008500012O002E010500034O007E000600043O00122O000700203O00122O000800216O0006000800024O00050005000600202O0005000500124O00050002000200062O0005008500013O0004A63O008500012O002E010500054O002E010600033O0020180106000600222O009000050002000200061E0105008500013O0004A63O008500012O002E010500043O0012E6000600233O0012E6000700244O00D6000500074O000D01055O0012E6000400043O002ED300250035000100070004A63O0035000100260701040035000100050004A63O003500010012E6000100053O0004A63O008F00010004A63O003500010004A63O008F00010004A63O00320001002ED300270006000100260004A63O000600010026072O010006000100010004A63O000600010012E6000300014O0020010400043O00260701030095000100010004A63O009500010012E6000400013O002607010400C4000100040004A63O00C400010006250102009E000100010004A63O009E0001002ED30028009F000100290004A63O009F00012O003B000200024O002E010500063O00061E010500B600013O0004A63O00B600012O002E010500023O00061E010500B600013O0004A63O00B600012O002E010500034O007E000600043O00122O0007002A3O00122O0008002B6O0006000800024O00050005000600202O0005000500124O00050002000200062O000500B600013O0004A63O00B600012O002E010500073O00205B00050005002C4O000700033O00202O00070007002D4O00050007000200062O000500B8000100010004A63O00B80001002ED3002F00C30001002E0004A63O00C300012O002E010500054O002E010600033O0020180106000600302O009000050002000200061E010500C300013O0004A63O00C300012O002E010500043O0012E6000600313O0012E6000700324O00D6000500074O000D01055O0012E6000400053O002607010400EE000100010004A63O00EE00012O002E010500083O00061E010500EA00013O0004A63O00EA00012O002E010500023O00061E010500EA00013O0004A63O00EA00012O002E010500034O007E000600043O00122O000700333O00122O000800346O0006000800024O00050005000600202O00050005000C4O00050002000200062O000500EA00013O0004A63O00EA00012O002E010500073O00205B00050005002C4O000700033O00202O00070007002D4O00050007000200062O000500EA000100010004A63O00EA00012O002E010500054O002E010600033O0020180106000600352O0090000500020002000625010500E5000100010004A63O00E50001002E77003700EA000100360004A63O00EA00012O002E010500043O0012E6000600383O0012E6000700394O00D6000500074O000D01056O002E010500094O00D50005000100022O008F000200053O0012E6000400043O00260701040098000100050004A63O009800010012E6000100043O0004A63O000600010004A63O009800010004A63O000600010004A63O009500010004A63O000600010004A63O00092O010026083O00FB000100010004A63O00FB0001002ED3003A00020001003B0004A63O000200010012E6000300013O000E4700042O002O0100030004A64O002O010012E63O00043O0004A63O00020001002608000300042O0100010004A63O00042O01002E77003C00FC0001003D0004A63O00FC00010012E6000100014O0020010200023O0012E6000300043O0004A63O00FC00010004A63O000200012O00363O00017O000B012O00028O00025O00E2A740025O00D6B240026O00F03F025O0050B240025O00449740026O008A40025O00A2B240025O00389E40030C3O00C2C73CE9EA33EE43F5C13DF403083O002281A8529A8F509C030A3O0049734361737461626C65027O0040030C3O00436F6E736563726174696F6E030E3O004973496E4D656C2O6552616E6765026O001440025O00ACB140025O0074A44003173O0086BD3D182O4D9B84A63A04460E9997BB3C19415A90C5EA03073O00E9E5D2536B282E025O0046B040025O0049B040030D3O008DAB2E132O16C85792B8220A1B03083O0031C5CA437E7364A703073O004973526561647903093O00486F6C79506F776572025O001AAD40025O00805540030D3O0048612O6D65726F665772617468030E3O0049735370652O6C496E52616E6765025O00206340031A3O003F5AD224854461385DE03E92574A3F1BCF3B89594C3E4FC669D403073O003E573BBF49E036031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O00D70EFBD0E21003043O00A987629A030C3O00E77E235CE920E0CA7A2951EF03073O00A8AB1744349D5303123O004C696768747348612O6D6572506C61796572026O00204003183O00F878F2A5313EB8FC70F8A0203FC7E463FCA2372493ED31A303073O00E7941195CD454D03063O00A3B2D5E858ED03063O009FE0C7A79B37025O00609C40025O00EAA140030C3O00DBFA3BDAE3E014D3FAFE39C003043O00B297935C025O000EA640025O001AA940025O005EB240025O00AAA04003123O004C696768747348612O6D6572637572736F7203183O0080F44B3A065F4584FC413F175E3A9CEF453D00456E95BD1A03073O001AEC9D2C52722C03123O000F20D056336EE0552E2BC71B093BC748253C03043O003B4A4EB5030C3O0009D85D52A736F95B57BE20C303053O00D345B12O3A03063O0045786973747303093O0043616E412O7461636B025O000EAA40025O0002A94003183O00BBEC7E2OFDD888ED78F8E4CE2OA569E7E0C4A5EC6DECA99D03063O00ABD785199589026O001840030B3O0095058429163AAA9D0D942F03073O00CCD96CE3416255026O00084003093O007FD4F4EE29CE57CDF203063O00A03EA395854C030B3O004973417661696C61626C65031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E74025O0026AA40025O00D09640030B3O004C696768746F664461776E03193O00DAA90A27D7E9AF0B10C7D7B7036FD3C4A9023DCAC2B94D7C9103053O00A3B6C06D4F030E3O00173415D3F4302312F3E1262F0BC503053O0095544660A0025O0053B240025O0013B140030E3O004372757361646572537472696B65031B3O003B1418FE390208FF071519FF310D08AD281404E22A0F19F478555903043O008D58666D025O00208340030C3O00905CC4631F3E47C0A75AC57E03083O00A1D333AA107A5D35025O00E8B240025O004AB04003183O00F8A1BC3BFEADA029EFA7BD26BBBEA021F4BCBB3CE2EEE17E03043O00489BCED2025O0008954003083O001B9778BB3C8772A803043O00DC51E21C03083O004A7564676D656E7403143O0019C086FCE7C21DC1C2EBF8CE1CC78BEFF387428303063O00A773B5E29B8A030C3O004C696768747348612O6D657203063O00D22EE6457E6303073O00A68242873C1B11025O0098A740025O007EA540030C3O006843C97D245762CF783D415803053O0050242AAE15025O00E0AD40025O00A6AC4003183O00421930725A0308724F1D3A7F5C502768471F25735A09772C03043O001A2E705703063O009A36B967B0AD03083O00D4D943CB142ODF25030C3O009684AFDAAE9E80D3B780ADC003043O00B2DAEDC803183O00BABCE1D8A2A6D9D8B7B8EBD5A4F5F6C2BFBAF4D9A2ACA68603043O00B0D6D58603123O00D1A3B3D9B1166CFAA9B3C6E8754CE6BEB9C603073O003994CDD6B4C836025O00D0A740025O00ECAD40030C3O003EF4323C6201D534397B17EF03053O0016729D5554025O008AA040025O00689040025O002C9140025O00489C4003183O00C8C214CC49E597CCCA1EC958E4E8D4D91ACB4FFFBCDD8B4503073O00C8A4AB73A43D96030C3O009DFB0D5686BDE602518AB1FA03053O00E3DE946325025O001CB340025O00F8AC40025O00B2A240025O0048834003183O00305D5CE5FC304053E2F03C5C12E6EB3A5D40FFED2A1200A603053O0099532O3296026O001040025O00209540025O00DCA240025O00C09840025O00D6A140030D3O00EA801BF33CFC57C4B604FF2DE603073O0038A2E1769E598E025O0032A040025O003AA640031B3O005404CDA227CA630AC69035CA5D11C8EF32CA550AD2A636C11C549403063O00B83C65A0CF42025O009CA640025O00BAA940025O00EC9340025O00708D40030B3O00ED4B35DE11CE4416D712CF03053O0065A12252B603093O00C91A58F5DEEC8B20EF03083O004E886D399EBB82E203063O0042752O665570030B3O00486F6C794176656E676572025O00989240025O000CB04003193O003236FEF92A00F6F7013BF8E6307FE9E33730EBF82A26B9A06E03043O00915E5F99025O00C8A240025O0056A34003183O00CEC51DD042B3F2CB00DD4B85F4CA1CC14BB8E8DE3CDA42AE03063O00D79DAD74B52E03183O00536869656C646F667468655269676874656F7573486F6C7903233O0026BC82F7D6318B84F4E521BC8ECDC83CB383E6DF3AA198B2CA27BD84E0D321ADCBA38803053O00BA55D4EB92025O0068A040025O00D88340025O002EA740025O00806840025O0051B240025O00CEA74003093O00AC4E5437B453513D8903043O004EE42138030F3O00486F6C79507269736D506C61796572025O00607A40025O00B07940031E3O00C671BE1ABADE6CBB10888E71BC4396CB72B44395DC77BD118CDA67F251D303053O00E5AE1ED26303093O0033E28A48DD2F3008E003073O00597B8DE6318D5D025O0058A340025O002OA64003093O00486F6C79507269736D03163O00FB7EFA152F5AE178E501505AE178F91E195EEA31A45403063O002A9311966C70025O00809440030D3O002EB42E7EE9ED3BA93F6DE2E61B03063O00886FC64D1F87025O005EAB40025O0098AA40025O00D8A140025O00A4B040030D3O00417263616E65546F2O72656E74031A3O00031BA457B3E128BD0D1BB553B3F057B91000A844B4F00EE9515903083O00C96269C736DD8477025O00F08340025O00E09040025O0010A340025O002DB040025O0018B140025O001EA740025O00109A4003183O00188439A9A5B9392D9838A99BB431239835A3BCAE1E24802903073O00564BEC50CCC9DD03113O004176656E67696E67577261746842752O6603093O005356768EFB857B4F7003063O00EB122117E59E025O003CAA40025O0028B340025O008AA640025O0078A64003223O0043B2C8BE5CBEFEB45685D5B35585D3B257B2D5BE5FAFD2FB40A8C8B442B3D5A210E803043O00DB30DAA1025O00BAA340025O001AA740025O001EAF40025O0048844003183O00D779754CD74BEFE265744CE946E7EC657946CE5CC8EB7D6503073O008084111C29BB2F03103O002937073649090203285E043C123B5A0403053O003D6152665A025O00F09D4003223O00BF26A24ECB532106AA11BF43C2680C00AB26BF4EC8420D49BC3CA244D55E0A10EC7C03083O0069CC4ECB2BA7377E025O0097B040025O0016AD40025O00989640025O0072A740025O0068AA40025O00E06840025O00589740025O00D4B14003093O0075797F0540A3425E7D03073O002D3D16137C13CB030A3O00446562752O66446F776E03123O00476C692O6D65726F664C6967687442752O66030E3O00E61E04F80F75ABCE1421FC0578AD03073O00D9A1726D95621003093O00486F6C7953686F636B03113O001A2F346583671A2F3B77FC70132D397BB903063O00147240581CDC025O00A0B040025O00507D4003093O00190EDEADCBD8B2320A03073O00DD5161B2D498B003163O00456E656D69657357697468446562752O66436F756E74026O00444003093O00436173744379636C6503123O00486F6C7953686F636B4D6F7573656F766572025O001EAD40025O00C0554003173O00C5E811E225DEEF12F811F2E404F816C8A719FA17CCE01803053O007AAD877D9B025O00088340025O0062AE40030E3O00A7D315AA3E35CD96F214AB363ACD03073O00A8E4A160D95F51030E3O00F8C33B4F2E53DEC31D483D5ED0D403063O0037BBB14E3C4F03073O0043686172676573025O0088A440025O00FEA040031B3O002EDC4AF847CB853FF14CFF54C68B288E4FF94FC09224DA46AB149B03073O00E04DAE3F8B26AF0083042O0012E63O00014O00202O0100013O002E7700020002000100030004A63O00020001002607012O0002000100010004A63O000200010012E6000100013O0026080001000B000100040004A63O000B0001002ED3000500DC000100060004A63O00DC00010012E6000200014O0020010300033O0026070102000D000100010004A63O000D00010012E6000300013O000E1000040014000100030004A63O00140001002E770008003B000100070004A63O003B0001002EFB00090025000100090004A63O003900012O002E01046O007E000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004003900013O0004A63O003900012O002E010400023O000EE0000D0039000100040004A63O003900012O002E010400034O00D500040001000200260600040039000100010004A63O003900012O002E010400044O004000055O00202O00050005000E4O000600053O00202O00060006000F00122O000800106O0006000800024O000600066O00040006000200062O00040034000100010004A63O00340001002E7700110039000100120004A63O003900012O002E010400013O0012E6000500133O0012E6000600144O00D6000400064O000D01045O0012E60001000D3O0004A63O00DC00010026080003003F000100010004A63O003F0001002E7700160010000100150004A63O001000012O002E01046O007E000500013O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400194O00040002000200062O0004005100013O0004A63O005100012O002E010400063O00205F00040004001A2O00900004000200020026FA00040051000100100004A63O005100012O002E010400023O002608000400530001000D0004A63O00530001002ED3001B00660001001C0004A63O006600012O002E010400044O004A00055O00202O00050005001D4O000600053O00202O00060006001E4O00085O00202O00080008001D4O0006000800024O000600066O00040006000200062O00040061000100010004A63O00610001002E77000300660001001F0004A63O006600012O002E010400013O0012E6000500203O0012E6000600214O00D6000400064O000D01045O001238000400224O002A000500013O00122O000600233O00122O000700246O00050007000200062O0004008B000100050004A63O008B00012O002E01046O007E000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400D800013O0004A63O00D800012O002E010400023O000EE0000D00D8000100040004A63O00D800012O002E010400044O002F000500073O00202O0005000500274O000600053O00202O00060006000F00122O000800286O0006000800024O000600066O00040006000200062O000400D800013O0004A63O00D800012O002E010400013O00127D000500293O00122O0006002A6O000400066O00045O00044O00D80001001238000400224O00F6000500013O00122O0006002B3O00122O0007002C6O00050007000200062O00040094000100050004A63O00940001002ED3002E00AE0001002D0004A63O00AE00012O002E01046O00BE000500013O00122O0006002F3O00122O000700306O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400A0000100010004A63O00A00001002E77003200D8000100310004A63O00D80001002ED3003400D8000100330004A63O00D800012O002E010400044O002E010500073O0020180105000500352O009000040002000200061E010400D800013O0004A63O00D800012O002E010400013O00127D000500363O00122O000600376O000400066O00045O00044O00D80001001238000400224O00F6000500013O00122O000600383O00122O000700396O00050007000200062O000400B6000100050004A63O00B600010004A63O00D800012O002E01046O007E000500013O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400CB00013O0004A63O00CB00012O002E010400083O00205F00040004003C2O009000040002000200061E010400CB00013O0004A63O00CB00012O002E010400063O00205F00040004003D2O002E010600084O0069000400060002000625010400CD000100010004A63O00CD0001002E77003E00D80001003F0004A63O00D800012O002E010400044O002E010500073O0020180105000500352O009000040002000200061E010400D800013O0004A63O00D800012O002E010400013O0012E6000500403O0012E6000600414O00D6000400064O000D01045O0012E6000300043O0004A63O001000010004A63O00DC00010004A63O000D00010026072O0100552O0100420004A63O00552O012O002E01026O007E000300013O00122O000400433O00122O000500446O0003000500024O00020002000300202O0002000200194O00020002000200062O000200072O013O0004A63O00072O012O002E010200093O00061E010200072O013O0004A63O00072O012O002E010200063O00205F00020002001A2O0090000200020002000EE0004500072O0100020004A63O00072O012O002E01026O007E000300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O0002000200484O00020002000200062O0002003O013O0004A63O003O012O002E0102000A3O00207A0002000200494O0003000B6O0004000C6O00020004000200062O000200092O0100010004A63O00092O012O002E0102000A3O00201801020002004A2O002E0103000D4O0090000200020002000E88000D00092O0100020004A63O00092O01002ED3004B001A2O01004C0004A63O001A2O012O002E010200044O00D400035O00202O00030003004D4O000400053O00202O00040004001E4O00065O00202O00060006004D4O0004000600024O000400046O00020004000200062O0002001A2O013O0004A63O001A2O012O002E010200013O0012E60003004E3O0012E60004004F4O00D6000200044O000D01026O002E01026O00BE000300013O00122O000400503O00122O000500516O0003000500024O00020002000300202O0002000200194O00020002000200062O000200262O0100010004A63O00262O01002ED3005200362O0100530004A63O00362O012O002E010200044O002F00035O00202O0003000300544O000400053O00202O00040004000F00122O000600106O0004000600024O000400046O00020004000200062O000200362O013O0004A63O00362O012O002E010200013O0012E6000300553O0012E6000400564O00D6000200044O000D01025O002EFB0057004C030100570004A63O008204012O002E01026O007E000300013O00122O000400583O00122O000500596O0003000500024O00020002000300202O0002000200194O00020002000200062O0002008204013O0004A63O008204012O002E010200044O004000035O00202O00030003000E4O000400053O00202O00040004000F00122O000600106O0004000600024O000400046O00020004000200062O0002004F2O0100010004A63O004F2O01002E77005A00820401005B0004A63O008204012O002E010200013O00127D0003005C3O00122O0004005D6O000200046O00025O00044O008204010026072O010016020100450004A63O001602010012E6000200014O0020010300033O002EFB005E3O0001005E0004A63O00592O01002607010200592O0100010004A63O00592O010012E6000300013O000E47000100ED2O0100030004A63O00ED2O012O002E01046O007E000500013O00122O0006005F3O00122O000700606O0005000700024O00040004000500202O0004000400194O00040002000200062O0004007B2O013O0004A63O007B2O012O002E010400044O00D400055O00202O0005000500614O000600053O00202O00060006001E4O00085O00202O0008000800614O0006000800024O000600066O00040006000200062O0004007B2O013O0004A63O007B2O012O002E010400013O0012E6000500623O0012E6000600634O00D6000400064O000D01045O001238000400644O00F6000500013O00122O000600653O00122O000700666O00050007000200062O000400842O0100050004A63O00842O01002E77006700A12O0100680004A63O00A12O012O002E01046O007E000500013O00122O000600693O00122O0007006A6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400EC2O013O0004A63O00EC2O01002ED3006C00EC2O01006B0004A63O00EC2O012O002E010400044O002F000500073O00202O0005000500274O000600053O00202O00060006000F00122O000800286O0006000800024O000600066O00040006000200062O000400EC2O013O0004A63O00EC2O012O002E010400013O00127D0005006D3O00122O0006006E6O000400066O00045O00044O00EC2O01001238000400644O002A000500013O00122O0006006F3O00122O000700706O00050007000200062O000400BE2O0100050004A63O00BE2O012O002E01046O007E000500013O00122O000600713O00122O000700726O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400EC2O013O0004A63O00EC2O012O002E010400044O002E010500073O0020180105000500352O009000040002000200061E010400EC2O013O0004A63O00EC2O012O002E010400013O00127D000500733O00122O000600746O000400066O00045O00044O00EC2O01001238000400644O002A000500013O00122O000600753O00122O000700766O00050007000200062O000400EC2O0100050004A63O00EC2O01002ED3007800C82O0100770004A63O00C82O010004A63O00EC2O012O002E01046O007E000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400DD2O013O0004A63O00DD2O012O002E010400083O00205F00040004003C2O009000040002000200061E010400DD2O013O0004A63O00DD2O012O002E010400063O00205F00040004003D2O002E010600084O0069000400060002000625010400DF2O0100010004A63O00DF2O01002ED3007B00EC2O01007C0004A63O00EC2O012O002E010400044O002E010500073O0020180105000500352O0090000400020002000625010400E72O0100010004A63O00E72O01002EFB007D00070001007E0004A63O00EC2O012O002E010400013O0012E60005007F3O0012E6000600804O00D6000400064O000D01045O0012E6000300043O0026070103005E2O0100040004A63O005E2O012O002E01046O007E000500013O00122O000600813O00122O000700826O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400FD2O013O0004A63O00FD2O012O002E010400034O00D5000400010002002608010400FF2O0100010004A63O00FF2O01002EFB00830014000100840004A63O00110201002ED300860011020100850004A63O001102012O002E010400044O002F00055O00202O00050005000E4O000600053O00202O00060006000F00122O000800106O0006000800024O000600066O00040006000200062O0004001102013O0004A63O001102012O002E010400013O0012E6000500873O0012E6000600884O00D6000400064O000D01045O0012E6000100893O0004A63O001602010004A63O005E2O010004A63O001602010004A63O00592O010026072O0100AD0201000D0004A63O00AD02010012E6000200014O0020010300033O0026080002001E020100010004A63O001E0201002ED3008B001A0201008A0004A63O001A02010012E6000300013O00260800030023020100040004A63O00230201002EFB008C00210001008D0004A63O004202012O002E01046O007E000500013O00122O0006008E3O00122O0007008F6O0005000700024O00040004000500202O0004000400194O00040002000200062O0004004002013O0004A63O00400201002ED300900040020100910004A63O004002012O002E010400044O00D400055O00202O00050005001D4O000600053O00202O00060006001E4O00085O00202O00080008001D4O0006000800024O000600066O00040006000200062O0004004002013O0004A63O004002012O002E010400013O0012E6000500923O0012E6000600934O00D6000400064O000D01045O0012E6000100453O0004A63O00AD0201002E770094001F020100950004A63O001F02010026070103001F020100010004A63O001F0201002ED30097008A020100960004A63O008A02012O002E01046O007E000500013O00122O000600983O00122O000700996O0005000700024O00040004000500202O0004000400194O00040002000200062O0004008A02013O0004A63O008A02012O002E010400093O00061E0104008A02013O0004A63O008A02012O002E01046O007E000500013O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500202O0004000400484O00040002000200062O0004006602013O0004A63O006602012O002E0104000A3O00207A0004000400494O0005000B6O0006000C6O00040006000200062O0004007D020100010004A63O007D02012O002E0104000A3O00201801040004004A2O002E0105000D4O0090000400020002000EC2000D008A020100040004A63O008A02012O002E010400063O00205F00040004001A2O0090000400020002000E240110007D020100040004A63O007D02012O002E010400063O00206E00040004009C4O00065O00202O00060006009D4O00040006000200062O0004008A02013O0004A63O008A02012O002E010400063O00205F00040004001A2O0090000400020002000EE00045008A020100040004A63O008A0201002ED3009E008A0201009F0004A63O008A02012O002E010400044O002E01055O00201801050005004D2O009000040002000200061E0104008A02013O0004A63O008A02012O002E010400013O0012E6000500A03O0012E6000600A14O00D6000400064O000D01045O002E7700A200A9020100A30004A63O00A902012O002E01046O007E000500013O00122O000600A43O00122O000700A56O0005000700024O00040004000500202O0004000400194O00040002000200062O000400A902013O0004A63O00A902012O002E010400023O000EC2004500A9020100040004A63O00A902012O002E010400044O002F00055O00202O0005000500A64O000600053O00202O00060006000F00122O000800106O0006000800024O000600066O00040006000200062O000400A902013O0004A63O00A902012O002E010400013O0012E6000500A73O0012E6000600A84O00D6000400064O000D01045O0012E6000300043O0004A63O001F02010004A63O00AD02010004A63O001A02010026072O01001E030100100004A63O001E03010012E6000200013O002608000200B4020100010004A63O00B40201002E7700A900FE020100AA0004A63O00FE02010012E6000300013O002ED300AC00BB020100AB0004A63O00BB0201002607010300BB020100040004A63O00BB02010012E6000200043O0004A63O00FE0201002608000300BF020100010004A63O00BF0201002ED300AD00B5020100AE0004A63O00B502012O002E01046O007E000500013O00122O000600AF3O00122O000700B06O0005000700024O00040004000500202O0004000400194O00040002000200062O000400DC02013O0004A63O00DC02012O002E010400023O000EE0000D00DC020100040004A63O00DC02012O002E0104000E3O00061E010400DC02013O0004A63O00DC02012O002E010400044O002E010500073O0020180105000500B12O0090000400020002000625010400D7020100010004A63O00D70201002E7700B200DC020100B30004A63O00DC02012O002E010400013O0012E6000500B43O0012E6000600B54O00D6000400064O000D01046O002E01046O007E000500013O00122O000600B63O00122O000700B76O0005000700024O00040004000500202O0004000400194O00040002000200062O000400E902013O0004A63O00E902012O002E0104000E3O000625010400EB020100010004A63O00EB0201002ED300B900FC020100B80004A63O00FC02012O002E010400044O00D400055O00202O0005000500BA4O000600053O00202O00060006001E4O00085O00202O0008000800BA4O0006000800024O000600066O00040006000200062O000400FC02013O0004A63O00FC02012O002E010400013O0012E6000500BB3O0012E6000600BC4O00D6000400064O000D01045O0012E6000300043O0004A63O00B50201002EFB00BD00B2FF2O00BD0004A63O00B00201002607010200B0020100040004A63O00B002012O002E01036O00BE000400013O00122O000500BE3O00122O000600BF6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003000E030100010004A63O000E0301002EFB00C0000F000100C10004A63O001B0301002ED300C2001B030100C30004A63O001B03012O002E010300044O002E01045O0020180104000400C42O009000030002000200061E0103001B03013O0004A63O001B03012O002E010300013O0012E6000400C53O0012E6000500C64O00D6000300054O000D01035O0012E6000100423O0004A63O001E03010004A63O00B002010026072O0100C4030100010004A63O00C403010012E6000200013O002E7700C7008E030100C80004A63O008E03010026070102008E030100010004A63O008E03010012E6000300013O000E4700010087030100030004A63O008703012O002E0104000F3O00061E0104005003013O0004A63O005003010012E6000400014O0020010500073O00260701040032030100010004A63O003203010012E6000500014O0020010600063O0012E6000400043O00260800040036030100040004A63O00360301002EFB00C900F9FF2O00CA0004A63O002D03012O0020010700073O002ED300CC0046030100CB0004A63O0046030100260701050046030100040004A63O004603010026070106003B030100010004A63O003B03012O002E010800104O00D50008000100022O008F000700083O00061E0107005003013O0004A63O005003012O003B000700023O0004A63O005003010004A63O003B03010004A63O00500301002EFB00CD00F1FF2O00CD0004A63O00370301000E4700010037030100050004A63O003703010012E6000600014O0020010700073O0012E6000500043O0004A63O003703010004A63O005003010004A63O002D03012O002E01046O007E000500013O00122O000600CE3O00122O000700CF6O0005000700024O00040004000500202O0004000400194O00040002000200062O0004007203013O0004A63O007203012O002E010400063O00205B00040004009C4O00065O00202O0006000600D04O00040006000200062O00040074030100010004A63O007403012O002E010400063O00205B00040004009C4O00065O00202O00060006009D4O00040006000200062O00040074030100010004A63O007403012O002E01046O007E000500013O00122O000600D13O00122O000700D26O0005000700024O00040004000500202O0004000400484O00040002000200062O0004007403013O0004A63O00740301002E7700D40086030100D30004A63O00860301002ED300D60086030100D50004A63O008603012O002E010400044O002F00055O00202O0005000500A64O000600053O00202O00060006000F00122O000800106O0006000800024O000600066O00040006000200062O0004008603013O0004A63O008603012O002E010400013O0012E6000500D73O0012E6000600D84O00D6000400064O000D01045O0012E6000300043O0026080003008B030100040004A63O008B0301002EFB00D9009DFF2O00DA0004A63O002603010012E6000200043O0004A63O008E03010004A63O0026030100260701020021030100040004A63O00210301002ED300DC00C1030100DB0004A63O00C103012O002E01036O007E000400013O00122O000500DD3O00122O000600DE6O0004000600024O00030003000400202O0003000300194O00030002000200062O000300C103013O0004A63O00C103010012380003001A3O000EE0004500C1030100030004A63O00C103012O002E0103000A4O003D000400013O00122O000500DF3O00122O000600E06O0004000600024O0003000300044O000400113O00062O000400C1030100030004A63O00C103012O002E0103000A3O00207400030003004A4O0004000B6O0003000200024O0004000C3O00062O000300C1030100040004A63O00C10301002EFB00E10012000100E10004A63O00C103012O002E010300044O002F00045O00202O0004000400A64O000500053O00202O00050005000F00122O000700106O0005000700024O000500056O00030005000200062O000300C103013O0004A63O00C103012O002E010300013O0012E6000400E23O0012E6000500E34O00D6000300054O000D01035O0012E6000100043O0004A63O00C403010004A63O00210301002E7700E50007000100E40004A63O000700010026072O010007000100890004A63O000700010012E6000200014O0020010300033O002607010200CA030100010004A63O00CA03010012E6000300013O002ED300E60049040100E70004A63O0049040100260701030049040100010004A63O004904010012E6000400013O002608000400D6030100040004A63O00D60301002ED300E800D8030100E90004A63O00D803010012E6000300043O0004A63O00490401002E7700EA00D2030100EB0004A63O00D20301002607010400D2030100010004A63O00D203012O002E010500123O00061E0105001004013O0004A63O001004012O002E01056O007E000600013O00122O000700EC3O00122O000800ED6O0006000800024O00050005000600202O0005000500194O00050002000200062O0005001004013O0004A63O001004012O002E010500053O00206E0005000500EE4O00075O00202O0007000700EF4O00050007000200062O0005001004013O0004A63O001004012O002E01056O007E000600013O00122O000700F03O00122O000800F16O0006000800024O00050005000600202O0005000500484O00050002000200062O000500FF03013O0004A63O00FF03012O002E010500134O002E010600054O009000050002000200061E0105001004013O0004A63O001004012O002E010500044O00D400065O00202O0006000600F24O000700053O00202O00070007001E4O00095O00202O0009000900F24O0007000900024O000700076O00050007000200062O0005001004013O0004A63O001004012O002E010500013O0012E6000600F33O0012E6000700F44O00D6000500074O000D01055O002ED300F60047040100F50004A63O004704012O002E010500123O00061E0105004704013O0004A63O004704012O002E010500143O00061E0105004704013O0004A63O004704012O002E01056O007E000600013O00122O000700F73O00122O000800F86O0006000800024O00050005000600202O0005000500194O00050002000200062O0005004704013O0004A63O004704012O002E0105000A3O0020EF0005000500F94O00065O00202O0006000600EF00122O000700FA6O0005000700024O000600153O00062O00050047040100060004A63O004704012O002E010500163O00061E0105004704013O0004A63O004704012O002E0105000A3O0020520005000500FB4O00065O00202O0006000600F24O000700176O000800136O000900053O00202O00090009001E4O000B5O00202O000B000B00F24O0009000B00022O000C000900094O0097000A000B6O000C00073O00202O000C000C00FC4O0005000C000200062O00050042040100010004A63O00420401002ED300FD0047040100FE0004A63O004704012O002E010500013O0012E6000600FF3O0012E600072O00013O00D6000500074O000D01055O0012E6000400043O0004A63O00D203010012E60004002O012O0012E600050002012O000621000400CD030100050004A63O00CD03010012E6000400043O000618000400CD030100030004A63O00CD03012O002E01046O007E000500013O00122O00060003012O00122O00070004015O0005000700024O00040004000500202O0004000400194O00040002000200062O0004007A04013O0004A63O007A04012O002E01046O0046000500013O00122O00060005012O00122O00070006015O0005000700024O00040004000500122O00060007015O0004000400064O00040002000200122O0005000D3O00062O0004007A040100050004A63O007A04012O002E010400044O004000055O00202O0005000500544O000600053O00202O00060006000F00122O000800106O0006000800024O000600066O00040006000200062O00040075040100010004A63O007504010012E600040008012O0012E600050009012O0006630004007A040100050004A63O007A04012O002E010400013O0012E60005000A012O0012E60006000B013O00D6000400064O000D01045O0012E6000100103O0004A63O000700010004A63O00CD03010004A63O000700010004A63O00CA03010004A63O000700010004A63O008204010004A63O000200012O00363O00017O006D3O00028O00027O0040026O00F03F03083O00DDE04C961157FDE403063O0036938F38B645025O006EA74003143O00F48DFA5ACCDF8FF846D9E693F05DDAD595F646D103053O00BFB6E19F29030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030D3O00556E697447726F7570526F6C6503043O001F33067E03073O00A24B724835EBE703193O00426C652O73696E676F6650726F74656374696F6E466F637573025O0030A740025O00C0514003273O008E3041F1400B823B7BED553D9C2E4BF6560198354BEC1301833348E65C1582034CE7520E85324303063O0062EC5C24823303063O0094150DA340BA03083O0050C4796CDA25C8D503143O00227F076C580784077C044F59019E05701676440003073O00EA6013621F2B6E031A3O00426C652O73696E676F6650726F74656374696F6E706C6179657203273O00041357D4BF7B8501205DC1936299090B57C4B87B84085F51C8A37E8F09085CF8A4778A0A165CC003073O00EB667F32A7CC12030B3O0071B4E722692F43B5F0315D03063O004E30C1954324031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030B3O00417572614D617374657279031D3O00310B92197E3D1F930C442207C01B4E3F128417563E21881D403C178E1F03053O0021507EE078025O00CAAA40025O0010AB4003063O0045786973747303093O004973496E52616E6765026O004440030A3O006A7B4D013D6E7B5A0A2003053O0053261A346E025O0042A240025O00707A40030F3O004C61796F6E48616E6473466F637573025O00A7B240025O00588640031D3O0054163E795719184E59192355181428495413285156282F43591B2E485F03043O0026387747025O0068AC40025O006C9C40030E3O00C6F6AC34E1F18639F8FEAC39FAEE03043O00508E97C203073O0049735265616479030E3O0048616E646F66446976696E697479025O00349140025O00B2A240031C3O0007CF61450DC348580CCA7B0C00C9784007C960423CCE724D0FCF794B03043O002C63A617025O000C9540030A3O0058FE2O3F3DA148F8253A03063O00C41C97495653030F3O00446976696E65546F2O6C466F637573031C3O00F70A3F198C5D2762FC0F25508157177AF70C3E1EBD501D77FF0A271703083O001693634970E2387803093O00907AEEECBEB07AE1FE03053O00EDD8158295025O003EAD40025O0038A240030E3O00486F6C7953686F636B466F637573031B3O008A4153468FDA568D4D541FB3C6518E4A5048BEF656874F5356BECE03073O003EE22E2O3FD0A903133O00C71550900C042159EA1F66821C1F2658EC1A5003083O003E857935E37F6D4F03043O0047554944025O0028A940025O007CB24003183O00426C652O73696E676F66536163726966696365466F63757303263O00121837E6C5A7AC172B3DF3E9BDA313063BF3DFADA750173DFADAAAAD071A0DFDD3AFAE191A3503073O00C270745295B6CE025O0082B140025O0062B340030D3O00CDBE06CA5BE5A604F34EEDBC0B03053O003C8CC863A403063O0042752O66557003113O004176656E67696E67577261746842752O66025O0016AB40025O00FCA240030D3O004176656E67696E675772617468031F3O0086E20128A58EFA0319B595F5102EE284FB0B2AA688E30A19AA82F5082FAC8003053O00C2E7946446025O00708040025O00F07F40030F3O007255D3B0D2CD4A45D7A6E4C9484FC403063O00A8262CA1C396030F3O005479727344656C69766572616E636503213O0094E590650FECB31A89EA876431E6B513C0FF8D793CECB9018EC38A7331E4BF188703083O0076E09CE2165088D6030E3O0060EB58834DE0568674E74B9457EB03043O00E0228E39025O00A4A040025O00309D4003133O00426561636F6E6F66566972747565466F63757303213O00DCA2C4DE7CFF6201D898D3D461E5480B9EA4CAD27FF55219D098CDD872FD5400D903083O006EBEC7A5BD13913D03083O00FEEA6EEA99C2DBE003063O00A7BA8B1788EB031A3O00467269656E646C79556E6974735769746842752O66436F756E7403123O00476C692O6D65726F664C6967687442752O66030E3O004D616E6150657263656E7461676503083O00446179627265616B03193O001EB4910F08B089065AB6870216B1871A148A80081BB981031D03043O006D7AD5E800E4012O0012E63O00013O002607012O00B5000100010004A63O00B500010012E6000100013O0026072O010008000100020004A63O000800010012E63O00033O0004A63O00B500010026072O01007E000100030004A63O007E00012O002E01026O002A000300013O00122O000400043O00122O000500056O00030005000200062O0002003C000100030004A63O003C0001002EFB0006004D000100060004A63O005E00012O002E010200024O007E000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002005E00013O0004A63O005E00012O002E010200033O00205F00020002000A2O00900002000200022O002E010300043O0006210002005E000100030004A63O005E00012O002E010200053O00201801020002000B2O002E010300034O00900002000200022O000C000200024O002A000300013O00122O0004000C3O00122O0005000D6O00030005000200062O0002005E000100030004A63O005E00012O002E010200064O002E010300073O00201801030003000E2O009000020002000200062501020036000100010004A63O00360001002EFB000F002A000100100004A63O005E00012O002E010200013O00127D000300113O00122O000400126O000200046O00025O00044O005E00012O002E01026O002A000300013O00122O000400133O00122O000500146O00030005000200062O0002005E000100030004A63O005E00012O002E010200024O007E000300013O00122O000400153O00122O000500166O0003000500024O00020002000300202O0002000200094O00020002000200062O0002005E00013O0004A63O005E00012O002E010200083O00205F00020002000A2O00900002000200022O002E010300043O0006210002005E000100030004A63O005E00012O002E010200064O002E010300073O0020180103000300172O009000020002000200061E0102005E00013O0004A63O005E00012O002E010200013O0012E6000300183O0012E6000400194O00D6000200044O000D01026O002E010200024O007E000300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200094O00020002000200062O0002007D00013O0004A63O007D00012O002E010200053O00203500020002001C4O000300096O0004000A6O00020004000200062O0002007D00013O0004A63O007D00012O002E0102000B3O00061E0102007D00013O0004A63O007D00012O002E010200064O002E010300023O00201801030003001D2O009000020002000200061E0102007D00013O0004A63O007D00012O002E010200013O0012E60003001E3O0012E60004001F4O00D6000200044O000D01025O0012E6000100023O0026072O010004000100010004A63O00040001002ED300200091000100210004A63O009100012O002E010200033O00061E0102009000013O0004A63O009000012O002E010200033O00205F0002000200222O009000020002000200061E0102009000013O0004A63O009000012O002E010200033O00205F0002000200230012E6000400244O006900020004000200062501020091000100010004A63O009100012O00363O00014O002E010200024O007E000300013O00122O000400253O00122O000500266O0003000500024O00020002000300202O0002000200094O00020002000200062O000200A400013O0004A63O00A400012O002E010200033O00205F00020002000A2O00900002000200022O002E0103000C3O000621000200A4000100030004A63O00A400012O002E0102000D3O000625010200A6000100010004A63O00A60001002E77002700B3000100280004A63O00B300012O002E010200064O002E010300073O0020180103000300292O0090000200020002000625010200AE000100010004A63O00AE0001002EFB002A00070001002B0004A63O00B300012O002E010200013O0012E60003002C3O0012E60004002D4O00D6000200044O000D01025O0012E6000100033O0004A63O00040001002E77002F00442O01002E0004A63O00442O01002607012O00442O0100020004A63O00442O012O002E2O0100024O007E000200013O00122O000300303O00122O000400316O0002000400024O00010001000200202O0001000100324O00010002000200062O000100DA00013O0004A63O00DA00012O002E2O0100053O00203500010001001C4O0002000E6O0003000F6O00010003000200062O000100DA00013O0004A63O00DA00012O002E2O0100103O00061E2O0100DA00013O0004A63O00DA00012O002E2O0100064O002E010200023O0020180102000200332O00900001000200020006252O0100D5000100010004A63O00D50001002E77003500DA000100340004A63O00DA00012O002E2O0100013O0012E6000200363O0012E6000300374O00D6000100034O000D2O015O002EFB00380021000100380004A63O00FB00012O002E2O0100024O007E000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200202O0001000100324O00010002000200062O000100FB00013O0004A63O00FB00012O002E2O0100053O00203500010001001C4O000200116O000300126O00010003000200062O000100FB00013O0004A63O00FB00012O002E2O0100133O00061E2O0100FB00013O0004A63O00FB00012O002E2O0100064O002E010200073O00201801020002003B2O009000010002000200061E2O0100FB00013O0004A63O00FB00012O002E2O0100013O0012E60002003C3O0012E60003003D4O00D6000100034O000D2O016O002E2O0100024O007E000200013O00122O0003003E3O00122O0004003F6O0002000400024O00010001000200202O0001000100324O00010002000200062O0001001B2O013O0004A63O001B2O012O002E2O0100033O00205F00010001000A2O00900001000200022O002E010200143O0006210001001B2O0100020004A63O001B2O012O002E2O0100153O00061E2O01001B2O013O0004A63O001B2O01002ED30041001B2O0100400004A63O001B2O012O002E2O0100064O002E010200073O0020180102000200422O009000010002000200061E2O01001B2O013O0004A63O001B2O012O002E2O0100013O0012E6000200433O0012E6000300444O00D6000100034O000D2O016O002E2O0100024O007E000200013O00122O000300453O00122O000400466O0002000400024O00010001000200202O0001000100324O00010002000200062O000100E32O013O0004A63O00E32O012O002E2O0100033O00201E0001000100474O0001000200024O000200083O00202O0002000200474O00020002000200062O000100E32O0100020004A63O00E32O012O002E2O0100033O00205F00010001000A2O00900001000200022O002E010200163O000621000100E32O0100020004A63O00E32O012O002E2O0100173O00061E2O0100E32O013O0004A63O00E32O01002E77004800E32O0100490004A63O00E32O012O002E2O0100064O002E010200073O00201801020002004A2O009000010002000200061E2O0100E32O013O0004A63O00E32O012O002E2O0100013O00127D0002004B3O00122O0003004C6O000100036O00015O00044O00E32O01000E10000300482O013O0004A63O00482O01002E77004E00010001004D0004A63O000100012O002E2O0100024O007E000200013O00122O0003004F3O00122O000400506O0002000400024O00010001000200202O0001000100094O00010002000200062O000100702O013O0004A63O00702O012O002E2O0100083O00205B0001000100514O000300023O00202O0003000300524O00010003000200062O000100702O0100010004A63O00702O012O002E2O0100053O00203500010001001C4O000200186O000300196O00010003000200062O000100702O013O0004A63O00702O012O002E2O01001A3O00061E2O0100702O013O0004A63O00702O01002E77005400702O0100530004A63O00702O012O002E2O0100064O002E010200023O0020180102000200552O009000010002000200061E2O0100702O013O0004A63O00702O012O002E2O0100013O0012E6000200563O0012E6000300574O00D6000100034O000D2O015O002ED3005900912O0100580004A63O00912O012O002E2O0100024O007E000200013O00122O0003005A3O00122O0004005B6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100912O013O0004A63O00912O012O002E2O01001B3O00061E2O0100912O013O0004A63O00912O012O002E2O0100053O00203500010001001C4O0002001C6O0003001D6O00010003000200062O000100912O013O0004A63O00912O012O002E2O0100064O002E010200023O00201801020002005C2O009000010002000200061E2O0100912O013O0004A63O00912O012O002E2O0100013O0012E60002005D3O0012E60003005E4O00D6000100034O000D2O016O002E2O0100024O007E000200013O00122O0003005F3O00122O000400606O0002000400024O00010001000200202O0001000100324O00010002000200062O000100A52O013O0004A63O00A52O012O002E2O0100053O00203500010001001C4O0002001E6O0003001F6O00010003000200062O000100A52O013O0004A63O00A52O012O002E2O0100203O0006252O0100A72O0100010004A63O00A72O01002EFB0061000D000100620004A63O00B22O012O002E2O0100064O002E010200073O0020180102000200632O009000010002000200061E2O0100B22O013O0004A63O00B22O012O002E2O0100013O0012E6000200643O0012E6000300654O00D6000100034O000D2O016O002E2O0100024O007E000200013O00122O000300663O00122O000400676O0002000400024O00010001000200202O0001000100324O00010002000200062O000100E12O013O0004A63O00E12O012O002E2O0100053O0020E50001000100684O000200023O00202O0002000200694O00038O00048O0001000400024O000200213O00062O000200E12O0100010004A63O00E12O012O002E2O0100053O00207A00010001001C4O000200226O000300236O00010003000200062O000100D32O0100010004A63O00D32O012O002E2O0100083O00205F00010001006A2O00900001000200022O002E010200243O000621000100E12O0100020004A63O00E12O012O002E2O0100253O00061E2O0100E12O013O0004A63O00E12O012O002E2O0100064O002E010200023O00201801020002006B2O009000010002000200061E2O0100E12O013O0004A63O00E12O012O002E2O0100013O0012E60002006C3O0012E60003006D4O00D6000100034O000D2O015O0012E63O00023O0004A63O000100012O00363O00017O008A3O00028O00025O0046A040025O0036AE40025O0024A840025O0028AC40030E3O001BAD4D1BCFEC013F9E450AD4F70B03073O006E59C82C78A08203073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O0054AA40025O0039B04003133O00426561636F6E6F66566972747565466F637573031C3O00A9C64A454C440442ADFC5D4F515E2E48EBC244437C423E4CA7CA454103083O002DCBA32B26232A5B025O0024B040030B3O00E58ACE2788AF73DE8ACE3A03073O0034B2E5BC43E7C903093O00486F6C79506F776572026O00084003063O0042752O66557003123O00456D70797265616E4C656761637942752O6603103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F63757303193O00364E4200C853251E465C0BE54563204E553BFF59222D485E2O03073O004341213064973C026O00F03F025O00C05640025O0078A540025O003C9C40025O00F49A40030B3O002OE8BCDCFCD9C0A2D7E1C603053O0093BF87CEB803113O00556E656E64696E674C6967687442752O66025O00C88340025O0054A440025O00907740025O0031B24003193O009327B4C5E75CB4BB2FAACECA4AF28527A3FED056B38821A8C603073O00D2E448C6A1B833025O0004B340025O00809040030B3O001A40F41867C1306DF2077D03063O00AE562993701303273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E74027O0040030B3O004C696768746F664461776E03193O0057098A0331301EAD64048C1C2B4F10A45E3F850E240318A55C03083O00CB3B60ED6B456F71025O00709540025O00C88740030D3O00546172676574497356616C6964025O0080AD40025O00DCA940025O002EAF40025O00A4AB40025O00D2A940025O00349240025O000C9140025O008CAD40031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O00ED2AF75AB0CF03053O00D5BD469623030C3O00635C73005B465C094258711A03043O00682F3514030A3O0049734361737461626C6503123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O00AF458614A81C9C448011B10AB10C910EB500B1459505FC5903063O006FC32CE17CDC03063O00FB531260A4B903063O00CBB8266013CB025O002CA640025O0060A540030C3O00157A7E49DA2A5B784CC33C6103053O00AE59131921025O0086AC4003123O004C696768747348612O6D6572637572736F7203183O00231B5546E3943427135F43F2954B3F005B41E58E1F36520403073O006B4F72322E97E7025O00989540025O0028854003123O001CA8B024937982CE3DA3A769A92CA5D336B403083O00A059C6D549EA59D7025O00388C40025O003EA540030C3O006478B3F6D15B59B5F3C84D6303053O00A52811D49E03063O0045786973747303093O0043616E412O7461636B025O00C2A040025O0067B24003183O00E9D00F3B32F6E600322BE8DC1A7336F7D007212FF1C0486503053O004685B96853025O00F0B240025O00DDB040025O00088440025O00BBB240030C3O0075A0320D16E0E157BB35111D03073O009336CF5C7E7383030A3O002A3E397908703D30217503063O001E6D51551D6D030B3O004973417661696C61626C65025O00809240030C3O00436F6E736563726174696F6E026O00144003183O00FC7E5AA533DDEEFE655DB9389EFDF0746BBE33DFF0F67F5303073O009C9F1134D656BE03083O0084FAB9BBA3EAB3A803043O00DCCE8FDD030F3O00AC682910D5C9DC92722B3BD1CBDA9203073O00B2E61D4D77B8AC030A3O00446562752O66446F776E03153O004A7564676D656E746F664C69676874446562752O66025O00C4AD40025O00A7B24003083O004A7564676D656E74030E3O0049735370652O6C496E52616E6765025O0092AA40025O004EA14003143O00FFAB0E1C7AFDFBAA4A1A78FDCAB60F1A7BF1FBB903063O009895DE6A7B17025O00FAA340030B3O001319BEE53EF6F02819BEF803073O00B74476CC815190030D3O00557365576F644F66476C6F727903193O0019A262E0348D089277E8049017ED71EB0EBD06A871E8028C0903063O00E26ECD10846B03103O00C7CAE7D155E4C5F4D144C6C2F2CD58F903053O00218BA380B903133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D6172747972025O001CA240025O003C9E40025O00F2AA4003153O004C696768746F667468654D6172747972466F637573031B3O005F5708C7684B0CD1545344DD585708DA584F0AE15F5D05D25E562O03043O00BE373864002E022O0012E63O00014O00202O0100013O0026083O0006000100010004A63O00060001002ED300030002000100020004A63O000200010012E6000100013O0026080001000B000100010004A63O000B0001002E7700050060000100040004A63O006000012O002E01026O007E000300013O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002002C00013O0004A63O002C00012O002E010200023O0020350002000200094O000300036O000400046O00020004000200062O0002002C00013O0004A63O002C00012O002E010200053O00061E0102002C00013O0004A63O002C0001002ED3000A002C0001000B0004A63O002C00012O002E010200064O002E010300073O00201801030003000C2O009000020002000200061E0102002C00013O0004A63O002C00012O002E010200013O0012E60003000D3O0012E60004000E4O00D6000200044O000D01025O002EFB000F00330001000F0004A63O005F00012O002E01026O007E000300013O00122O000400103O00122O000500116O0003000500024O00020002000300202O0002000200084O00020002000200062O0002005F00013O0004A63O005F00012O002E010200083O00205F0002000200122O0090000200020002000EE00013005F000100020004A63O005F00012O002E010200083O00206E0002000200144O00045O00202O0004000400154O00020004000200062O0002005F00013O0004A63O005F00012O002E010200093O00205F0002000200162O00900002000200022O002E0103000A3O0006210002004D000100030004A63O004D00012O002E0102000B3O00062501020054000100010004A63O005400012O002E010200023O0020350002000200094O0003000C6O0004000D6O00020004000200062O0002005F00013O0004A63O005F00012O002E010200064O002E010300073O0020180103000300172O009000020002000200061E0102005F00013O0004A63O005F00012O002E010200013O0012E6000300183O0012E6000400194O00D6000200044O000D01025O0012E60001001A3O002608000100640001001A0004A63O00640001002E77001C00C90001001B0004A63O00C900010012E6000200013O002E77001E00C40001001D0004A63O00C40001002607010200C4000100010004A63O00C400012O002E01036O007E000400013O00122O0005001F3O00122O000600206O0004000600024O00030003000400202O0003000300084O00030002000200062O0003008800013O0004A63O008800012O002E010300083O00205F0003000300122O0090000300020002000EE000130088000100030004A63O008800012O002E010300083O00206E0003000300144O00055O00202O0005000500214O00030005000200062O0003008800013O0004A63O008800012O002E010300093O00205F0003000300162O00900003000200022O002E0104000A3O00062100030088000100040004A63O008800012O002E0103000B3O0006250103008A000100010004A63O008A0001002E7700230097000100220004A63O009700012O002E010300064O002E010400073O0020180104000400172O009000030002000200062501030092000100010004A63O00920001002E7700250097000100240004A63O009700012O002E010300013O0012E6000400263O0012E6000500274O00D6000300054O000D01035O002ED3002900C3000100280004A63O00C300012O002E01036O007E000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300C300013O0004A63O00C300012O002E0103000E3O00061E010300C300013O0004A63O00C300012O002E010300083O00205F0003000300122O0090000300020002000EE0001300C3000100030004A63O00C300012O002E010300023O00207A0003000300094O0004000C6O0005000D6O00030005000200062O000300B8000100010004A63O00B800012O002E010300023O00201801030003002C2O002E0104000A4O0090000300020002000EC2002D00C3000100030004A63O00C300012O002E010300064O002E01045O00201801040004002E2O009000030002000200061E010300C300013O0004A63O00C300012O002E010300013O0012E60004002F3O0012E6000500304O00D6000300054O000D01035O0012E60002001A3O002607010200650001001A0004A63O006500010012E60001002D3O0004A63O00C900010004A63O00650001002608000100CD000100130004A63O00CD0001002ED3003100D22O0100320004A63O00D22O012O002E010200023O0020180102000200332O00D5000200010002000625010200D4000100010004A63O00D40001002ED30034002D020100350004A63O002D02010012E6000200014O0020010300043O002EFB003600F5000100360004A63O00CB2O01002607010200CB2O01001A0004A63O00CB2O01000E47000100DA000100030004A63O00DA00010012E6000400013O002E770038005E2O0100370004A63O005E2O010026070104005E2O01001A0004A63O005E2O012O002E010500023O00207A0005000500094O0006000F6O000700106O00050007000200062O000500EA000100010004A63O00EA0001002ED30039002D0201003A0004A63O002D0201002EFB003B00240001003B0004A63O000E2O010012380005003C4O002A000600013O00122O0007003D3O00122O0008003E6O00060008000200062O0005000E2O0100060004A63O000E2O012O002E01056O007E000600013O00122O0007003F3O00122O000800406O0006000800024O00050005000600202O0005000500414O00050002000200062O0005002D02013O0004A63O002D02012O002E010500064O002F000600073O00202O0006000600424O000700113O00202O00070007004300122O000900446O0007000900024O000700076O00050007000200062O0005002D02013O0004A63O002D02012O002E010500013O00127D000600453O00122O000700466O000500076O00055O00044O002D02010012380005003C4O00F6000600013O00122O000700473O00122O000800486O00060008000200062O000500172O0100060004A63O00172O01002ED30049002F2O01004A0004A63O002F2O012O002E01056O007E000600013O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O0005000500414O00050002000200062O0005002D02013O0004A63O002D0201002EFB004D000C2O01004D0004A63O002D02012O002E010500064O002E010600073O00201801060006004E2O009000050002000200061E0105002D02013O0004A63O002D02012O002E010500013O00127D0006004F3O00122O000700506O000500076O00055O00044O002D0201002ED3005200392O0100510004A63O00392O010012380005003C4O00F6000600013O00122O000700533O00122O000800546O00060008000200062O000500392O0100060004A63O00392O010004A63O002D0201002ED30055002D020100560004A63O002D02012O002E01056O007E000600013O00122O000700573O00122O000800586O0006000800024O00050005000600202O0005000500414O00050002000200062O0005002D02013O0004A63O002D02012O002E010500123O00205F0005000500592O009000050002000200061E0105002D02013O0004A63O002D02012O002E010500083O00205F00050005005A2O002E010700124O006900050007000200061E0105002D02013O0004A63O002D02012O002E010500064O002E010600073O00201801060006004E2O0090000500020002000625010500582O0100010004A63O00582O01002ED3005C002D0201005B0004A63O002D02012O002E010500013O00127D0006005D3O00122O0007005E6O000500076O00055O00044O002D0201002608000400622O0100010004A63O00622O01002E77005F00DD000100600004A63O00DD00010012E6000500013O002607010500672O01001A0004A63O00672O010012E60004001A3O0004A63O00DD0001002ED3006100632O0100620004A63O00632O01002607010500632O0100010004A63O00632O012O002E01066O007E000700013O00122O000800633O00122O000900646O0007000900024O00060006000700202O0006000600414O00060002000200062O000600832O013O0004A63O00832O012O002E01066O007E000700013O00122O000800653O00122O000900666O0007000900024O00060006000700202O0006000600674O00060002000200062O000600832O013O0004A63O00832O012O002E010600134O00D5000600010002002608010600852O0100010004A63O00852O01002E77003700952O0100680004A63O00952O012O002E010600064O002F00075O00202O0007000700694O000800113O00202O00080008004300122O000A006A6O0008000A00024O000800086O00060008000200062O000600952O013O0004A63O00952O012O002E010600013O0012E60007006B3O0012E60008006C4O00D6000600084O000D01066O002E01066O007E000700013O00122O0008006D3O00122O0009006E6O0007000900024O00060006000700202O0006000600084O00060002000200062O000600B02O013O0004A63O00B02O012O002E01066O007E000700013O00122O0008006F3O00122O000900706O0007000900024O00060006000700202O0006000600674O00060002000200062O000600B02O013O0004A63O00B02O012O002E010600113O00205B0006000600714O00085O00202O0008000800724O00060008000200062O000600B22O0100010004A63O00B22O01002ED3007400C52O0100730004A63O00C52O012O002E010600064O004A00075O00202O0007000700754O000800113O00202O0008000800764O000A5O00202O000A000A00754O0008000A00024O000800086O00060008000200062O000600C02O0100010004A63O00C02O01002E77007700C52O0100780004A63O00C52O012O002E010600013O0012E6000700793O0012E60008007A4O00D6000600084O000D01065O0012E60005001A3O0004A63O00632O010004A63O00DD00010004A63O002D02010004A63O00DA00010004A63O002D0201002607010200D6000100010004A63O00D600010012E6000300014O0020010400043O0012E60002001A3O0004A63O00D600010004A63O002D0201000E47002D0007000100010004A63O000700010012E6000200013O002EFB007B00060001007B0004A63O00DB2O01002607010200DB2O01001A0004A63O00DB2O010012E6000100133O0004A63O00070001002607010200D52O0100010004A63O00D52O012O002E01036O007E000400013O00122O0005007C3O00122O0006007D6O0004000600024O00030003000400202O0003000300084O00030002000200062O0003000602013O0004A63O000602012O002E010300083O00205F0003000300122O0090000300020002000EE000130006020100030004A63O000602012O002E010300093O00205F0003000300162O00900003000200022O002E0104000A3O00062100030006020100040004A63O000602010012380003007E3O00061E0103000602013O0004A63O000602012O002E010300023O00201801030003002C2O002E0104000A4O00900003000200020026FA00030006020100130004A63O000602012O002E010300064O002E010400073O0020180104000400172O009000030002000200061E0103000602013O0004A63O000602012O002E010300013O0012E60004007F3O0012E6000500804O00D6000300054O000D01036O002E01036O007E000400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O0003000300084O00030002000200062O0003001902013O0004A63O001902012O002E010300093O00205F0003000300162O0090000300020002001238000400833O00062100030019020100040004A63O00190201001238000300843O0006250103001B020100010004A63O001B0201002E7700850028020100860004A63O00280201002EFB0087000D000100870004A63O002802012O002E010300064O002E010400073O0020180104000400882O009000030002000200061E0103002802013O0004A63O002802012O002E010300013O0012E6000400893O0012E60005008A4O00D6000300054O000D01035O0012E60002001A3O0004A63O00D52O010004A63O000700010004A63O002D02010004A63O000200012O00363O00017O00683O00030B3O00334A562EC602624825DB1D03053O00A96425244A03073O004973526561647903093O00486F6C79506F776572026O00084003103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F637573025O00149540025O0040954003183O001788B0543F88A46F078BAD4219C7B1443F8FA7510C8EAC5703043O003060E7C203093O00E05502342AD0A080C303083O00E3A83A6E4D79B8CF025O00C4AD40025O00588840030E3O00486F6C7953686F636B466F63757303153O007333B3598EC879AA7837FF53A5E479A07A30B64EB603083O00C51B5CDF20D1BB11030B3O002756D5F20D5AE5FA1550D103043O009B633FA3025O00EEA240025O00BC9140030B3O00446976696E654661766F72025O0068B240026O00A74003173O0086D8B784B781BDD7A09BB6962OC2B5B2B18183DDA883BE03063O00E4E2B1C1EDD9030C3O0012BC22F53CBF25CA3DB72BF203043O008654D043030A3O0049734361737461626C65025O00EAB140025O001EA04003113O00466C6173686F664C69676874466F637573025O000AAC40025O005EA94003193O0015A0874F1B93895A2CA08F5B1BB8C64F07938E5912A08F521403043O003C73CCE603103O00CB33EC78F335ED64EF3FC671F52EF26203043O0010875A8B03133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D6172747972025O008C9B40025O006C9B4003153O004C696768746F667468654D6172747972466F637573031B3O005C7B0A2A7147705B770D734D5B7758700924406B7051750A3A405303073O0018341466532E34030E3O00E62E333606C13D2E2229C526352C03053O006FA44F414403103O0042612O726965726F664661697468485003113O0055736542612O726965726F664661697468030E3O0042612O726965726F664661697468025O00C6AA40025O00CEA040031B3O00C4D891CC27EFD4E68CD811ECC7D097D66EF9D2E68BDB2FE6CFD78403063O008AA6B9E3BE4E030C3O00ED78C4245A2C1FE77DC23F4603073O0079AB14A557324303063O0042752O66557003133O00496E667573696F6E6F664C6967687442752O66025O00EAAD40025O00E8A74003193O00C034B825B13DC93E863AB005CE2CF925AD3DCE3DB83AB00CC103063O0062A658D956D903093O00DEF97518B6CEFFE57403063O00BC2O961961E6030F3O00486F6C79507269736D506C61796572031E3O00D286531B33FDC8804C0F4CE2D4C94C0700EB9A994D0B03FFD39D46425EBB03063O008DBAE93F626C03093O00D9E520AF09F8ED24A203053O0045918A4CD6025O00406F40025O00307740030E3O00486F6C794C69676874466F63757303153O0078C08590801A79C8819DFF0564F0818CBE1A79C18E03063O007610AF2OE9DF031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503063O00BB8834A2EB9903073O001DEBE455DB8EEB030C3O0011DDBDD5635D0F5330D9BFCF03083O00325DB4DABD172E4703123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O00D2AD5C4450CF77D6A5562O41CE08CEB6524356D55CC7E40D03073O0028BEC43B2C24BC025O0016B140025O0068954003063O001F50CEA7F56F03073O006D5C25BCD49A1D025O007EAB40025O007AA840030C3O0028E6A3CB25492CEEA9CE344803063O003A648FC4A35103123O004C696768747348612O6D6572637572736F7203183O00164B24AB2B5ADA061B4F2EA62D09F51C134D31AA2B50A55803083O006E7A2243C35F298503123O0050BF5E47CF3584554ED367F1785FC466BE4903053O00B615D13B2A030C3O009B5EC21535AD9F56C81024AC03063O00DED737A57D4103063O0045786973747303093O0043616E412O7461636B03183O0020D8C112E62OD2422DDCCB1FE081FD5825DED413E6D8AD1C03083O002A4CB1A67A92A18D00A8013O002E017O007E000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O002500013O0004A63O002500012O002E012O00023O00205F5O00042O00903O00020002000EE00005002500013O0004A63O002500012O002E012O00033O00205F5O00062O00903O000200022O002E2O0100043O0006213O0025000100010004A63O002500012O002E012O00053O00061E012O002500013O0004A63O002500012O002E012O00064O002E2O0100073O0020182O01000100072O00903O00020002000625012O0020000100010004A63O00200001002E7700090025000100080004A63O002500012O002E012O00013O0012E60001000A3O0012E60002000B4O00D63O00024O000D017O002E017O007E000100013O00122O0002000C3O00122O0003000D6O0001000300028O000100206O00036O0002000200064O004500013O0004A63O004500012O002E012O00033O00205F5O00062O00903O000200022O002E2O0100083O0006213O0045000100010004A63O004500012O002E012O00093O00061E012O004500013O0004A63O00450001002E77000F00450001000E0004A63O004500012O002E012O00064O002E2O0100073O0020182O01000100102O00903O0002000200061E012O004500013O0004A63O004500012O002E012O00013O0012E6000100113O0012E6000200124O00D63O00024O000D017O002E017O007E000100013O00122O000200133O00122O000300146O0001000300028O000100206O00036O0002000200064O005800013O0004A63O005800012O002E012O00033O00205F5O00062O00903O000200022O002E2O01000A3O0006213O0058000100010004A63O005800012O002E012O000B3O000625012O005A000100010004A63O005A0001002EFB0015000F000100160004A63O006700012O002E012O00064O002E2O015O0020182O01000100172O00903O00020002000625012O0062000100010004A63O00620001002E7700180067000100190004A63O006700012O002E012O00013O0012E60001001A3O0012E60002001B4O00D63O00024O000D017O002E017O007E000100013O00122O0002001C3O00122O0003001D6O0001000300028O000100206O001E6O0002000200064O007A00013O0004A63O007A00012O002E012O00033O00205F5O00062O00903O000200022O002E2O01000C3O0006213O007A000100010004A63O007A00012O002E012O000D3O000625012O007C000100010004A63O007C0001002E77001F008B000100200004A63O008B00012O002E012O00064O00A0000100073O00202O0001000100214O000200026O000300018O0003000200064O0086000100010004A63O00860001002E770022008B000100230004A63O008B00012O002E012O00013O0012E6000100243O0012E6000200254O00D63O00024O000D017O002E017O007E000100013O00122O000200263O00122O000300276O0001000300028O000100206O00036O0002000200064O009E00013O0004A63O009E00012O002E012O00033O00205F5O00062O00903O00020002001238000100283O0006213O009E000100010004A63O009E00010012383O00293O000625012O00A0000100010004A63O00A00001002ED3002A00AB0001002B0004A63O00AB00012O002E012O00064O002E2O0100073O0020182O010001002C2O00903O0002000200061E012O00AB00013O0004A63O00AB00012O002E012O00013O0012E60001002D3O0012E60002002E4O00D63O00024O000D017O002E017O007E000100013O00122O0002002F3O00122O000300306O0001000300028O000100206O001E6O0002000200064O00CD00013O0004A63O00CD00012O002E012O00033O00205F5O00062O00903O00020002001238000100313O0006213O00CD000100010004A63O00CD00010012383O00323O00061E012O00CD00013O0004A63O00CD00012O002E012O00064O00A0000100073O00202O0001000100334O000200026O000300018O0003000200064O00C8000100010004A63O00C80001002ED3003400CD000100350004A63O00CD00012O002E012O00013O0012E6000100363O0012E6000200374O00D63O00024O000D017O002E017O007E000100013O00122O000200383O00122O000300396O0001000300028O000100206O001E6O0002000200064O00E700013O0004A63O00E700012O002E012O00023O00206E5O003A4O00025O00202O00020002003B6O0002000200064O00E700013O0004A63O00E700012O002E012O00033O00205F5O00062O00903O000200022O002E2O01000E3O0006213O00E7000100010004A63O00E700012O002E012O000D3O000625012O00E9000100010004A63O00E90001002EFB003C000F0001003D0004A63O00F600012O002E012O00064O0048000100073O00202O0001000100214O000200026O000300018O0003000200064O00F600013O0004A63O00F600012O002E012O00013O0012E60001003E3O0012E60002003F4O00D63O00024O000D017O002E017O007E000100013O00122O000200403O00122O000300416O0001000300028O000100206O00036O0002000200064O00142O013O0004A63O00142O012O002E012O00033O00205F5O00062O00903O000200022O002E2O01000F3O0006213O00142O0100010004A63O00142O012O002E012O00103O00061E012O00142O013O0004A63O00142O012O002E012O00064O002E2O0100073O0020182O01000100422O00903O0002000200061E012O00142O013O0004A63O00142O012O002E012O00013O0012E6000100433O0012E6000200444O00D63O00024O000D017O002E017O007E000100013O00122O000200453O00122O000300466O0001000300028O000100206O001E6O0002000200064O00272O013O0004A63O00272O012O002E012O00033O00205F5O00062O00903O000200022O002E2O01000A3O0006213O00272O0100010004A63O00272O012O002E012O000B3O000625012O00292O0100010004A63O00292O01002EFB0047000F000100480004A63O00362O012O002E012O00064O0048000100073O00202O0001000100494O000200026O000300018O0003000200064O00362O013O0004A63O00362O012O002E012O00013O0012E60001004A3O0012E60002004B4O00D63O00024O000D017O002E012O00113O0020355O004C4O000100126O000200138O0002000200064O00A72O013O0004A63O00A72O012O002E012O00144O002A000100013O00122O0002004D3O00122O0003004E6O00010003000200064O005F2O0100010004A63O005F2O012O002E017O007E000100013O00122O0002004F3O00122O000300506O0001000300028O000100206O001E6O0002000200064O00A72O013O0004A63O00A72O012O002E012O00064O002F000100073O00202O0001000100514O000200153O00202O00020002005200122O000400536O0002000400024O000200028O0002000200064O00A72O013O0004A63O00A72O012O002E012O00013O00127D000100543O00122O000200558O00029O003O00044O00A72O01002ED3005700802O0100560004A63O00802O012O002E012O00144O002A000100013O00122O000200583O00122O000300596O00010003000200064O00802O0100010004A63O00802O01002ED3005B00A72O01005A0004A63O00A72O012O002E017O007E000100013O00122O0002005C3O00122O0003005D6O0001000300028O000100206O001E6O0002000200064O00A72O013O0004A63O00A72O012O002E012O00064O002E2O0100073O0020182O010001005E2O00903O0002000200061E012O00A72O013O0004A63O00A72O012O002E012O00013O00127D0001005F3O00122O000200608O00029O003O00044O00A72O012O002E012O00144O002A000100013O00122O000200613O00122O000300626O00010003000200064O00A72O0100010004A63O00A72O012O002E017O007E000100013O00122O000200633O00122O000300646O0001000300028O000100206O001E6O0002000200064O00A72O013O0004A63O00A72O012O002E012O00163O00205F5O00652O00903O0002000200061E012O00A72O013O0004A63O00A72O012O002E012O00023O00205F5O00662O002E010200164O00693O0002000200061E012O00A72O013O0004A63O00A72O012O002E012O00064O002E2O0100073O0020182O010001005E2O00903O0002000200061E012O00A72O013O0004A63O00A72O012O002E012O00013O0012E6000100673O0012E6000200684O00D63O00024O000D017O00363O00017O00143O00028O00025O0084B340025O0071B240026O00F03F025O006EAF40025O003EA540025O00606E40025O00A4B140025O003EAD40025O00389D4003063O0045786973747303093O004973496E52616E6765026O004440025O00A07240025O00ECA940027O0040025O00109240025O0040A940025O00488840025O00C4A34000493O0012E63O00014O00202O0100033O002ED300030040000100020004A63O00400001002607012O0040000100040004A63O004000012O0020010300033O002E770006000E000100050004A63O000E00010026072O01000E000100010004A63O000E00010012E6000200014O0020010300033O0012E6000100043O000E4700040007000100010004A63O00070001002E7700070029000100080004A63O0029000100260701020029000100010004A63O00290001002E77000A0025000100090004A63O002500012O002E01045O00061E0104002400013O0004A63O002400012O002E01045O00205F00040004000B2O009000040002000200061E0104002400013O0004A63O002400012O002E01045O00205F00040004000C0012E60006000D4O006900040006000200062501040025000100010004A63O002500012O00363O00014O002E010400014O00D50004000100022O008F000300043O0012E6000200043O002E77000E00340001000F0004A63O0034000100260701020034000100040004A63O0034000100061E0103003000013O0004A63O003000012O003B000300024O002E010400024O00D50004000100022O008F000300043O0012E6000200103O002ED300110010000100120004A63O00100001000E4700100010000100020004A63O0010000100061E0103004800013O0004A63O004800012O003B000300023O0004A63O004800010004A63O001000010004A63O004800010004A63O000700010004A63O00480001002ED300130002000100140004A63O00020001002607012O0002000100010004A63O000200010012E6000100014O0020010200023O0012E63O00043O0004A63O000200012O00363O00017O00C53O00028O00025O0042AD40025O0036A540026O00F03F026O001440027O0040025O004EB340025O00CC9A40026O001840025O003EA740025O0048B140025O00A4A640025O00F09040025O00C05940025O00EEAF40025O00B8A740025O002CA440025O00E06F40026O008340030F3O0047657443617374696E67456E656D7903143O00426C61636B6F757442612O72656C446562752O6603113O00878600DD6A7FAB8D0AC85F64A08F01C17403063O0016C5EA65AE1903073O0049735265616479025O001CAF40025O00F8A640025O009EAD40025O004CB240030A3O00556E69744973556E697403023O00494403163O00476574556E697473546172676574467269656E646C79025O00DEA640025O00388E4003163O00426C652O73696E676F6646722O65646F6D466F637573025O00B88340025O00E2A640031A3O002F38A0CF65A6D981123BA3E370BDD283293BA89C75A0DA842C2003083O00E64D54C5BC16CFB7025O00507540025O00E8AE4003123O00466F637573537065636966696564556E6974026O004440025O00EAB240025O00689740031B3O00466F637573556E697457697468446562752O6646726F6D4C69737403073O00C915CAFD88A8FE03083O00559974A69CECC19003113O0046722O65646F6D446562752O664C697374026O003440025O00809440025O0056B34003113O0086EC48A0F709AAE742B5C212A1E549BCE903063O0060C4802DD38403153O00556E6974486173446562752O6646726F6D4C69737403073O00058C775ED6A6BA03083O00B855ED1B3FB2CFD4025O00408A40025O00EC9240031A3O000A550C4C1B50075837560F600E4B0C5A0C56041F0B56045D094D03043O003F683969026O001C40030D3O00546172676574497356616C6964025O0093B140025O00C09840025O00F8AC40025O007DB040025O00C0AC40025O00307E40025O00549640025O00F2A840025O008AA440025O00707E40030D3O0048616E646C654368726F6D6965030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572025O0014B140025O00B2A640026O000840025O00B89140025O00088040025O00D2AA40025O00ECA34003093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F766572025O00707940025O00349F40025O00BC9640025O0032A040025O0022AB40025O00E2B140025O00AEA340025O00F07C40025O0049B340025O002EAF40025O005CAD40025O0023B140025O00F8A140030F3O0048616E646C65412O666C6963746564026O001040025O00CDB040025O00C8A44003093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572025O00D89840025O000AA840025O000BB040025O0014904003073O00436C65616E736503103O00436C65616E73654D6F7573656F766572025O00CC9C40025O0048AE40025O006BB240025O00189240025O00149F40030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F766572025O00B4A840025O0007B040025O005EA940025O0030B140025O0062AD40025O0072A540025O00208840025O0050B040025O009CA540025O00708440025O00DBB240025O0084A240025O006CA340025O0046A64003043O0027A2337603043O001369CD5D025O0020AF40025O00749940030D3O008B0DDF8230A707D8AD36AE00CA03053O005FC968BEE1030A3O0049734361737461626C6503093O004E616D6564556E6974026O003E400003083O0042752O66446F776E030D3O00426561636F6E6F664C69676874025O0052A340025O005EAA4003123O00426561636F6E6F664C696768744D6163726F03163O00ADCEC0CDA0C5FEC1A9F4CDC7A8C3D58EACC42OCCAEDF03043O00AECFABA103043O00C3F103F603063O00B78D9E6D9398030D3O000E0CE70F2307E92O0A08EF182403043O006C4C6986030D3O00426561636F6E6F664661697468025O0016B340025O00CC9E4003123O00426561636F6E6F6646616974684D6163726F025O0044A440025O0058964003163O00E9C0B0E2C1E5FABEE7F1EDC4B8F5C6ABC6BEECCCEAD103053O00AE8BA5D181025O00CDB240025O00C1B140025O0033B340025O001DB340025O002FB040025O001C9340025O00ACAA4003113O0048616E646C65496E636F72706F7265616C03083O005475726E4576696C03113O005475726E4576696C4D6F7573656F766572025O00207C40025O00AAA340030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F766572025O0076A140025O00F88C4003083O00446562752O66557003093O00456E74616E676C656403113O00298BA157188EAA43048182560E82A04B0603043O00246BE7C403173O00426C652O73696E676F6646722O65646F6D506C61796572025O0015B040031A3O005FB9A7944EBCAC8062BAA4B85B2OA78259BAAFC75EBAAF855CA103043O00E73DD5C2025O008EA740025O003AB240025O003C9040025O00AEB040025O00405F40025O0042A040025O00349D40025O0024B340025O00C49B40025O00E0A940025O00489240025O00A49D40025O00C08B40025O00808740004F032O0012E63O00014O00202O0100023O002E7700030048030100020004A63O00480301002607012O0048030100040004A63O004803010026072O01002A000100050004A63O002A00010012E6000300013O0026080003000D000100060004A63O000D0001002EFB00070004000100080004A63O000F00010012E6000100093O0004A63O002A000100260800030013000100010004A63O00130001002ED3000B001C0001000A0004A63O001C00012O002E01046O00D50004000100022O008F000200043O002E77000D001B0001000C0004A63O001B000100061E0102001B00013O0004A63O001B00012O003B000200023O0012E6000300043O00260800030020000100040004A63O00200001002EFB000E00EBFF2O000F0004A63O000900012O002E010400014O00D50004000100022O008F000200043O002ED300110028000100100004A63O0028000100061E0102002800013O0004A63O002800012O003B000200023O0012E6000300063O0004A63O000900010026080001002E000100010004A63O002E0001002ED3001300D6000100120004A63O00D600010012E6000300013O002607010300A5000100010004A63O00A500012O002E010400023O0020090104000400144O000500033O00202O0005000500154O00040002000200062O0004004200013O0004A63O004200012O002E010400034O00BE000500043O00122O000600163O00122O000700176O0005000700024O00040004000500202O0004000400184O00040002000200062O00040044000100010004A63O00440001002E77001900970001001A0004A63O009700010012E6000400014O0020010500063O0026070104004B000100010004A63O004B00010012E6000500014O0020010600063O0012E6000400043O0026080004004F000100040004A63O004F0001002ED3001C00460001001B0004A63O0046000100260701050075000100040004A63O007500012O002E010700053O00061E0107006500013O0004A63O006500010012380007001D4O00F0000800053O00202O00080008001E4O0008000200024O000900023O00202O00090009001F4O000A00023O00202O000A000A00144O000B00033O00202O000B000B00154O000A000B6O00093O000200202O00090009001E4O0009000A6O00073O000200062O00070067000100010004A63O00670001002E7700200097000100210004A63O009700012O002E010700064O002E010800073O0020180108000800222O00900007000200020006250107006F000100010004A63O006F0001002ED300240097000100230004A63O009700012O002E010700043O00127D000800253O00122O000900266O000700096O00075O00044O009700010026070105004F000100010004A63O004F00010012E6000700013O0026080007007C000100010004A63O007C0001002ED30028008D000100270004A63O008D00012O002E010800023O0020130108000800294O000900023O00202O00090009001F4O000A00023O00202O000A000A00144O000B00033O00202O000B000B00154O000A000B6O00093O000200122O000A002A6O0008000A00024O000600083O00062O0006008C00013O0004A63O008C00012O003B000600023O0012E6000700043O00260800070091000100040004A63O00910001002E77002B00780001002C0004A63O007800010012E6000500043O0004A63O004F00010004A63O007800010004A63O004F00010004A63O009700010004A63O004600012O002E010400023O00204200040004002D4O000500086O000600043O00122O0007002E3O00122O0008002F6O0006000800024O00050005000600202O00050005003000122O0006002A3O00122O000700316O0004000700024O000200043O00122O000300043O002608000300A9000100040004A63O00A90001002ED3003300D1000100320004A63O00D1000100061E010200AC00013O0004A63O00AC00012O003B000200024O002E010400034O007E000500043O00122O000600343O00122O000700356O0005000700024O00040004000500202O0004000400184O00040002000200062O000400C300013O0004A63O00C300012O002E010400023O0020750004000400364O000500056O000600086O000700043O00122O000800373O00122O000900386O0007000900024O00060006000700202O0006000600304O000400060002000625010400C5000100010004A63O00C50001002EFB0039000D0001003A0004A63O00D000012O002E010400064O002E010500073O0020180105000500222O009000040002000200061E010400D000013O0004A63O00D000012O002E010400043O0012E60005003B3O0012E60006003C4O00D6000400064O000D01045O0012E6000300063O0026070103002F000100060004A63O002F00010012E6000100043O0004A63O00D600010004A63O002F00010026072O0100F80001003D0004A63O00F800012O002E010300023O00201801030003003E2O00D500030001000200061E0103004E03013O0004A63O004E03010012E6000300013O000E47000400E9000100030004A63O00E900012O002E010400094O00D50004000100022O008F000200043O002ED30040004E0301003F0004A63O004E030100061E0102004E03013O0004A63O004E03012O003B000200023O0004A63O004E0301002E77004100DE000100420004A63O00DE0001002607010300DE000100010004A63O00DE00012O002E0104000A4O00D50004000100022O008F000200043O000625010200F4000100010004A63O00F40001002E77004300F5000100440004A63O00F500012O003B000200023O0012E6000300043O0004A63O00DE00010004A63O004E03010026072O0100142O0100090004A63O00142O010012E6000300013O002607010300062O0100010004A63O00062O012O002E0104000B4O00D50004000100022O008F000200043O002E77004500052O0100460004A63O00052O0100061E010200052O013O0004A63O00052O012O003B000200023O0012E6000300043O0026070103000A2O0100060004A63O000A2O010012E60001003D3O0004A63O00142O01002607010300FB000100040004A63O00FB00012O002E0104000C4O00D50004000100022O008F000200043O00061E010200122O013O0004A63O00122O012O003B000200023O0012E6000300063O0004A63O00FB0001000E47000600522O0100010004A63O00522O010012E6000300014O0020010400043O000E47000100182O0100030004A63O00182O010012E6000400013O002ED30048002C2O0100470004A63O002C2O010026070104002C2O0100040004A63O002C2O012O002E010500023O0020390005000500494O000600033O00202O00060006004A4O000700073O00202O00070007004B00122O0008002A6O0005000800024O000200053O00062O0002002B2O013O0004A63O002B2O012O003B000200023O0012E6000400063O000E10000600302O0100040004A63O00302O01002ED3004C00322O01004D0004A63O00322O010012E60001004E3O0004A63O00522O01002ED30050001B2O01004F0004A63O001B2O010026070104001B2O0100010004A63O001B2O010012E6000500013O000E470004003B2O0100050004A63O003B2O010012E6000400043O0004A63O001B2O01000E100001003F2O0100050004A63O003F2O01002EFB005100FAFF2O00520004A63O00372O012O002E010600023O0020B00006000600494O000700033O00202O0007000700534O000800073O00202O00080008005400122O0009002A6O0006000900024O000200063O002E2O0055004D2O0100560004A63O004D2O0100061E0102004D2O013O0004A63O004D2O012O003B000200023O0012E6000500043O0004A63O00372O010004A63O001B2O010004A63O00522O010004A63O00182O01000E10000400562O0100010004A63O00562O01002E7700580012020100570004A63O001202010012E6000300013O000E47000100FA2O0100030004A63O00FA2O012O002E0104000D3O0006250104005E2O0100010004A63O005E2O01002ED3005A00732O0100590004A63O00732O010012E6000400014O0020010500053O002ED3005B00602O0100460004A63O00602O01002607010400602O0100010004A63O00602O010012E6000500013O002608000500692O0100010004A63O00692O01002E77005D00652O01005C0004A63O00652O012O002E0106000E4O00D50006000100022O008F000200063O00061E010200732O013O0004A63O00732O012O003B000200023O0004A63O00732O010004A63O00652O010004A63O00732O010004A63O00602O012O002E0104000F3O00061E010400F92O013O0004A63O00F92O010012E6000400014O0020010500053O0026080004007C2O0100010004A63O007C2O01002E77005E00782O01005F0004A63O00782O010012E6000500013O002608000500812O0100060004A63O00812O01002E77006000962O0100610004A63O00962O010012E6000600013O002607010600912O0100010004A63O00912O012O002E010700023O0020390007000700624O000800033O00202O00080008004A4O000900073O00202O00090009004B00122O000A002A6O0007000A00024O000200073O00062O000200902O013O0004A63O00902O012O003B000200023O0012E6000600043O002607010600822O0100040004A63O00822O010012E60005004E3O0004A63O00962O010004A63O00822O010026080005009A2O0100630004A63O009A2O01002EFB0064000F000100650004A63O00A72O012O002E010600023O0020390006000600624O000700033O00202O0007000700664O000800073O00202O00080008006700122O0009002A6O0006000900024O000200063O00062O000200F92O013O0004A63O00F92O012O003B000200023O0004A63O00F92O01002607010500B82O0100040004A63O00B82O012O002E010600023O0020B00006000600624O000700033O00202O0007000700534O000800073O00202O00080008005400122O0009002A6O0006000900024O000200063O002E2O006800B72O0100690004A63O00B72O0100061E010200B72O013O0004A63O00B72O012O003B000200023O0012E6000500063O002608000500BC2O0100010004A63O00BC2O01002E77006A00C92O01006B0004A63O00C92O012O002E010600023O0020390006000600624O000700033O00202O00070007006C4O000800073O00202O00080008006D00122O0009002A6O0006000900024O000200063O00062O000200C82O013O0004A63O00C82O012O003B000200023O0012E6000500043O002608000500CD2O01004E0004A63O00CD2O01002EFB006E00B2FF2O006F0004A63O007D2O010012E6000600014O0020010700073O002607010600CF2O0100010004A63O00CF2O010012E6000700013O002607010700D62O0100040004A63O00D62O010012E6000500633O0004A63O007D2O01002E77007100D22O0100700004A63O00D22O01002607010700D22O0100010004A63O00D22O010012E6000800013O002EFB00720013000100720004A63O00EE2O01002607010800EE2O0100010004A63O00EE2O012O002E010900023O0020580009000900624O000A00033O00202O000A000A00734O000B00073O00202O000B000B007400122O000C002A6O0009000C00024O000200093O00062O000200EC2O0100010004A63O00EC2O01002EFB00750003000100760004A63O00ED2O012O003B000200023O0012E6000800043O002607010800DB2O0100040004A63O00DB2O010012E6000700043O0004A63O00D22O010004A63O00DB2O010004A63O00D22O010004A63O007D2O010004A63O00CF2O010004A63O007D2O010004A63O00F92O010004A63O00782O010012E6000300043O002608000300FE2O0100040004A63O00FE2O01002EFB00770011000100780004A63O000D02012O002E010400023O0020EA0004000400494O000500033O00202O00050005006C4O000600073O00202O00060006006D00122O0007002A6O0004000700024O000200043O002E2O007A000C020100790004A63O000C020100061E0102000C02013O0004A63O000C02012O003B000200023O0012E6000300063O002607010300572O0100060004A63O00572O010012E6000100063O0004A63O001202010004A63O00572O01002ED3007B000A0301007C0004A63O000A0301000E470063000A030100010004A63O000A03010012E6000300014O0020010400043O00260701030018020100010004A63O001802010012E6000400013O002E77007E00960201007D0004A63O00960201000E4700040096020100040004A63O009602010012E6000500013O00260800050024020100040004A63O00240201002EFB007F0004000100800004A63O002602010012E6000400063O0004A63O009602010026080005002A020100010004A63O002A0201002ED300820020020100810004A63O002002012O002E010600104O00F6000700043O00122O000800833O00122O000900846O00070009000200062O0006005F020100070004A63O005F0201002EFB00850003000100860004A63O003402010004A63O005F02012O002E010600034O007E000700043O00122O000800873O00122O000900886O0007000900024O00060006000700202O0006000600894O00060002000200062O0006005202013O0004A63O005202012O002E010600023O00204C00060006008A00122O0007002A6O000800103O00122O0009008B6O00060009000200262O000600520201008C0004A63O005202012O002E010600023O00202700060006008A00122O0007002A6O000800103O00122O0009008B6O00060009000200202O00060006008D4O000800033O00202O00080008008E4O00060008000200062O00060054020100010004A63O00540201002ED30090005F0201008F0004A63O005F02012O002E010600064O002E010700073O0020180107000700912O009000060002000200061E0106005F02013O0004A63O005F02012O002E010600043O0012E6000700923O0012E6000800934O00D6000600084O000D01066O002E010600114O002A000700043O00122O000800943O00122O000900956O00070009000200062O00060067020100070004A63O006702010004A63O009402012O002E010600034O007E000700043O00122O000800963O00122O000900976O0007000900024O00060006000700202O0006000600894O00060002000200062O0006008502013O0004A63O008502012O002E010600023O00204C00060006008A00122O0007002A6O000800113O00122O0009008B6O00060009000200262O000600850201008C0004A63O008502012O002E010600023O00202700060006008A00122O0007002A6O000800113O00122O0009008B6O00060009000200202O00060006008D4O000800033O00202O0008000800984O00060008000200062O00060087020100010004A63O00870201002EFB0099000F0001009A0004A63O009402012O002E010600064O002E010700073O00201801070007009B2O00900006000200020006250106008F020100010004A63O008F0201002E77009C00940201009D0004A63O009402012O002E010600043O0012E60007009E3O0012E60008009F4O00D6000600084O000D01065O0012E6000500043O0004A63O00200201002ED300A1002O030100A00004A63O002O03010026070104002O030100010004A63O002O03010012E6000500013O0026070105009F020100040004A63O009F02010012E6000400043O0004A63O002O0301002608000500A3020100010004A63O00A30201002ED300A2009B020100A30004A63O009B02012O002E010600123O00061E010600DE02013O0004A63O00DE02010012E6000600014O0020010700073O002EFB00A43O000100A40004A63O00A80201002607010600A8020100010004A63O00A802010012E6000700013O002ED300A500C1020100A60004A63O00C10201000E47000400C1020100070004A63O00C102012O002E010800023O0020220008000800A74O000900033O00202O0009000900A84O000A00073O00202O000A000A00A900122O000B008B6O000C00016O0008000C00024O000200083O002E2O00AA00DE020100AB0004A63O00DE020100061E010200DE02013O0004A63O00DE02012O003B000200023O0004A63O00DE0201002607010700AD020100010004A63O00AD02010012E6000800013O000E47000400C8020100080004A63O00C802010012E6000700043O0004A63O00AD0201002607010800C4020100010004A63O00C402012O002E010900023O0020AE0009000900A74O000A00033O00202O000A000A00AC4O000B00073O00202O000B000B00AD00122O000C008B6O000D00016O0009000D00024O000200093O002E2O00AE0005000100AE0004A63O00D9020100061E010200D902013O0004A63O00D902012O003B000200023O0012E6000800043O0004A63O00C402010004A63O00AD02010004A63O00DE02010004A63O00A802012O002E010600133O00061E0106000103013O0004A63O00010301002E7700AF0001030100AB0004A63O000103012O002E010600143O00206E0006000600B04O000800033O00202O0008000800B14O00060008000200062O0006000103013O0004A63O000103012O002E010600034O007E000700043O00122O000800B23O00122O000900B36O0007000900024O00060006000700202O0006000600184O00060002000200062O0006000103013O0004A63O000103012O002E010600064O002E010700073O0020180107000700B42O0090000600020002000625010600FC020100010004A63O00FC0201002ED300B50001030100580004A63O000103012O002E010600043O0012E6000700B63O0012E6000800B74O00D6000600084O000D01065O0012E6000500043O0004A63O009B0201000E470006001B020100040004A63O001B02010012E6000100053O0004A63O000A03010004A63O001B02010004A63O000A03010004A63O001802010026080001000E0301004E0004A63O000E0301002ED300B90006000100B80004A63O000600010012E6000300013O002ED300BA0022030100BB0004A63O0022030100260701030022030100010004A63O002203012O002E010400023O0020EA0004000400494O000500033O00202O0005000500734O000600073O00202O00060006007400122O0007002A6O0004000700024O000200043O002E2O00BC0021030100BD0004A63O0021030100061E0102002103013O0004A63O002103012O003B000200023O0012E6000300043O0026070103003F030100040004A63O003F03010012E6000400013O00260800040029030100040004A63O00290301002EFB00BE0004000100BF0004A63O002B03010012E6000300063O0004A63O003F03010026080004002F030100010004A63O002F0301002E7700C10025030100C00004A63O002503012O002E010500023O0020580005000500494O000600033O00202O0006000600664O000700073O00202O00070007006700122O0008002A6O0005000800024O000200053O00062O0002003C030100010004A63O003C0301002ED300C3003D030100C20004A63O003D03012O003B000200023O0012E6000400043O0004A63O00250301002E7700C5000F030100C40004A63O000F03010026070103000F030100060004A63O000F03010012E6000100633O0004A63O000600010004A63O000F03010004A63O000600010004A63O004E0301002607012O0002000100010004A63O000200010012E6000100014O0020010200023O0012E63O00043O0004A63O000200012O00363O00017O00843O00028O00025O0022A840025O006EAF40025O00F2B240025O00989640030C3O0053686F756C6452657475726E025O0040A840025O00E88F40025O00C09840025O004CB140026O00F03F025O00B09440025O00209E40027O0040025O0015B240030F3O0048616E646C65412O666C6963746564030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572026O004440026O000840025O00BEA640025O007AAE40030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F766572026O00104003093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572025O00B07740025O00349540025O00C49540025O00A0764003073O00436C65616E736503103O00436C65616E73654D6F7573656F76657203093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F766572025O00D09640030D3O0048616E646C654368726F6D6965026O001440030C3O0035A3BBA1221A1EA88CBB241203063O007371C6CDCE56030A3O0049734361737461626C6503083O0042752O66446F776E030C3O004465766F74696F6E41757261025O0078AB40025O00409540030D3O008052E855905EF154BB56EB488503043O003AE4379E030D3O00546172676574497356616C6964025O00889D40025O00C05E40025O004C9A40025O0002A840025O00089E40025O00DAA440025O00406040025O00A0A940025O0042B340025O005DB040025O003C9240025O0044974003113O0048616E646C65496E636F72706F7265616C030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F766572026O003E40025O00B0AF40025O00F0844003083O005475726E4576696C03113O005475726E4576696C4D6F7573656F766572025O00907440025O00E07C4003083O00446562752O66557003093O00456E74616E676C656403113O0081BFE7D2D50A7E7FACB5C4D3C3067477AE03083O0018C3D382A1A6631003073O004973526561647903173O00426C652O73696E676F6646722O65646F6D506C6179657203213O00440FEC3F401F4804D62355294011EC2957194B43E63947564905A92F5C1B4402FD03063O00762663894C33025O00A6A940025O00F49040025O00B88740025O0018B040025O00406940025O00EEA740025O000C9940025O00FCB140025O0040A440025O00E8984003043O00D3290B1703063O00409D46657269025O0026A140025O0084B340030D3O0062ADA6E01F4EA7A1CF1947A0B303053O007020C8C78303093O004E616D6564556E697400030D3O00426561636F6E6F664C69676874025O00108D40025O0050894003123O00426561636F6E6F664C696768744D6163726F03163O002E555DBBCCA51D235663B4CAAC2A38105FB7CEA9233803073O00424C303CD8A3CB03043O00948977F603073O0044DAE619933FAE025O00BAB240025O0014A540030D3O008F2F524FB9A325556AB7A43E5B03053O00D6CD4A332C030D3O00426561636F6E6F66466169746803123O00426561636F6E6F6646616974684D6163726F03163O00F849E3FF78F473EDFA48FC4DEBE87FBA4FEDF175FB5803053O00179A2C829C025O00588140025O00388140025O00507040025O003AAE40025O00E07440025O00D4A740025O008AAC40025O00C7B240025O004CAA40025O004EAC40025O0010B240025O00049E40025O0050A040025O00789F40025O00C2A940025O0052B240025O00807840025O00B8A940025O00C05D40025O00B3B140009B022O0012E63O00014O00202O0100013O002607012O0002000100010004A63O000200010012E6000100013O00260800010009000100010004A63O00090001002ED3000300D2000100020004A63O00D200012O002E01025O0006250102000E000100010004A63O000E0001002EFB00040011000100050004A63O001D00010012E6000200013O0026070102000F000100010004A63O000F00012O002E010300014O00D50003000100020012D2000300063O001238000300063O00062501030019000100010004A63O00190001002EFB00070006000100080004A63O001D0001001238000300064O003B000300023O0004A63O001D00010004A63O000F0001002ED3000900C80001000A0004A63O00C800012O002E010200023O00061E010200C800013O0004A63O00C800010012E6000200014O0020010300043O002607010200C00001000B0004A63O00C00001002ED3000C00260001000D0004A63O0026000100260701030026000100010004A63O002600010012E6000400013O0026070104004E0001000E0004A63O004E00010012E6000500013O002EFB000F001B0001000F0004A63O00490001000E4700010049000100050004A63O004900010012E6000600013O00260701060044000100010004A63O004400012O002E010700033O0020140007000700104O000800043O00202O0008000800114O000900053O00202O00090009001200122O000A00136O0007000A000200122O000700063O00122O000700063O00062O0007004300013O0004A63O00430001001238000700064O003B000700023O0012E60006000B3O002607010600330001000B0004A63O003300010012E60005000B3O0004A63O004900010004A63O003300010026070105002E0001000B0004A63O002E00010012E6000400143O0004A63O004E00010004A63O002E0001002ED30015006F000100160004A63O006F00010026070104006F000100140004A63O006F00010012E6000500014O0020010600063O00260701050054000100010004A63O005400010012E6000600013O00260701060068000100010004A63O006800012O002E010700033O0020140007000700104O000800043O00202O0008000800174O000900053O00202O00090009001800122O000A00136O0007000A000200122O000700063O00122O000700063O00062O0007006700013O0004A63O00670001001238000700064O003B000700023O0012E60006000B3O002607010600570001000B0004A63O005700010012E6000400193O0004A63O006F00010004A63O005700010004A63O006F00010004A63O0054000100260701040080000100190004A63O008000012O002E010500033O0020140005000500104O000600043O00202O00060006001A4O000700053O00202O00070007001B00122O000800136O00050008000200122O000500063O00122O000500063O00062O000500C800013O0004A63O00C80001001238000500064O003B000500023O0004A63O00C80001002ED3001C00A30001001D0004A63O00A30001002607010400A3000100010004A63O00A300010012E6000500014O0020010600063O00260701050086000100010004A63O008600010012E6000600013O0026080006008D0001000B0004A63O008D0001002E77001E008F0001001F0004A63O008F00010012E60004000B3O0004A63O00A3000100260701060089000100010004A63O008900012O002E010700033O0020140007000700104O000800043O00202O0008000800204O000900053O00202O00090009002100122O000A00136O0007000A000200122O000700063O00122O000700063O00062O0007009F00013O0004A63O009F0001001238000700064O003B000700023O0012E60006000B3O0004A63O008900010004A63O00A300010004A63O008600010026070104002B0001000B0004A63O002B00010012E6000500013O002607010500AA0001000B0004A63O00AA00010012E60004000E3O0004A63O002B0001002607010500A6000100010004A63O00A600012O002E010600033O0020140006000600104O000700043O00202O0007000700224O000800053O00202O00080008002300122O000900136O00060009000200122O000600063O00122O000600063O00062O000600BA00013O0004A63O00BA0001001238000600064O003B000600023O0012E60005000B3O0004A63O00A600010004A63O002B00010004A63O00C800010004A63O002600010004A63O00C80001002EFB00240064FF2O00240004A63O0024000100260701020024000100010004A63O002400010012E6000300014O0020010400043O0012E60002000B3O0004A63O002400012O002E010200033O0020490002000200254O000300043O00202O0003000300204O000400053O00202O00040004002100122O000500136O00020005000200122O000200063O00122O0001000B3O0026072O0100132O0100260004A63O00132O012O002E010200044O007E000300063O00122O000400273O00122O000500286O0003000500024O00020002000300202O0002000200294O00020002000200062O000200F200013O0004A63O00F200012O002E010200073O00206E00020002002A4O000400043O00202O00040004002B4O00020004000200062O000200F200013O0004A63O00F200012O002E010200084O002E010300043O00201801030003002B2O0090000200020002000625010200ED000100010004A63O00ED0001002E77002C00F20001002D0004A63O00F200012O002E010200063O0012E60003002E3O0012E60004002F4O00D6000200044O000D01026O002E010200033O0020180102000200302O00D5000200010002000625010200F9000100010004A63O00F90001002E770031009A020100320004A63O009A02010012E6000200014O0020010300043O002608000200FF000100010004A63O00FF0001002E77003400022O0100330004A63O00022O010012E6000300014O0020010400043O0012E60002000B3O002608000200062O01000B0004A63O00062O01002E77003600FB000100350004A63O00FB0001002607010300062O0100010004A63O00062O012O002E010500094O00D50005000100022O008F000400053O00061E0104009A02013O0004A63O009A02012O003B000400023O0004A63O009A02010004A63O00062O010004A63O009A02010004A63O00FB00010004A63O009A0201002608000100172O0100190004A63O00172O01002EFB003700122O0100380004A63O002702010012E6000200013O0026080002001C2O0100010004A63O001C2O01002E77003900792O01003A0004A63O00792O010012E6000300013O002607010300212O01000B0004A63O00212O010012E60002000B3O0004A63O00792O010026070103001D2O0100010004A63O001D2O012O002E0104000A3O00061E010400582O013O0004A63O00582O010012E6000400014O0020010500053O002ED3003B00282O01003C0004A63O00282O01002607010400282O0100010004A63O00282O010012E6000500013O0026070105003F2O0100010004A63O003F2O012O002E010600033O00201101060006003D4O000700043O00202O00070007003E4O000800053O00202O00080008003F00122O000900406O000A00016O0006000A000200122O000600063O00122O000600063O00062O0006003E2O013O0004A63O003E2O01001238000600064O003B000600023O0012E60005000B3O002E770042002D2O0100410004A63O002D2O01000E47000B002D2O0100050004A63O002D2O012O002E010600033O0020C800060006003D4O000700043O00202O0007000700434O000800053O00202O00080008004400122O000900406O000A00016O0006000A000200122O000600063O002E2O004500582O0100460004A63O00582O01001238000600063O00061E010600582O013O0004A63O00582O01001238000600064O003B000600023O0004A63O00582O010004A63O002D2O010004A63O00582O010004A63O00282O012O002E0104000B3O00061E010400772O013O0004A63O00772O012O002E010400073O00206E0004000400474O000600043O00202O0006000600484O00040006000200062O000400772O013O0004A63O00772O012O002E010400044O007E000500063O00122O000600493O00122O0007004A6O0005000700024O00040004000500202O00040004004B4O00040002000200062O000400772O013O0004A63O00772O012O002E010400084O002E010500053O00201801050005004C2O009000040002000200061E010400772O013O0004A63O00772O012O002E010400063O0012E60005004D3O0012E60006004E4O00D6000400064O000D01045O0012E60003000B3O0004A63O001D2O01002ED3005000182O01004F0004A63O00182O01000E47000B00182O0100020004A63O00182O012O002E0103000C3O00061E0103002402013O0004A63O002402010012E6000300014O0020010400063O002607010300872O0100010004A63O00872O010012E6000400014O0020010500053O0012E60003000B3O000E10000B008B2O0100030004A63O008B2O01002ED3005200822O0100510004A63O00822O012O0020010600063O002607010400912O0100010004A63O00912O010012E6000500014O0020010600063O0012E60004000B3O002ED30053008C2O0100540004A63O008C2O010026070104008C2O01000B0004A63O008C2O01002608000500992O0100010004A63O00992O01002ED300560014020100550004A63O001402010012E6000700013O0026070107009E2O01000B0004A63O009E2O010012E60005000B3O0004A63O00140201002608000700A22O0100010004A63O00A22O01002E770057009A2O0100580004A63O009A2O010012E6000800013O002607010800A72O01000B0004A63O00A72O010012E60007000B3O0004A63O009A2O01002607010800A32O0100010004A63O00A32O012O002E0109000D4O00F6000A00063O00122O000B00593O00122O000C005A6O000A000C000200062O000900DE2O01000A0004A63O00DE2O01002E77005C00B32O01005B0004A63O00B32O010004A63O00DE2O012O002E010900044O007E000A00063O00122O000B005D3O00122O000C005E6O000A000C00024O00090009000A00202O0009000900294O00090002000200062O000900D12O013O0004A63O00D12O012O002E010900033O00204C00090009005F00122O000A00136O000B000D3O00122O000C00406O0009000C000200262O000900D12O0100600004A63O00D12O012O002E010900033O00202700090009005F00122O000A00136O000B000D3O00122O000C00406O0009000C000200202O00090009002A4O000B00043O00202O000B000B00614O0009000B000200062O000900D32O0100010004A63O00D32O01002E77006200DE2O0100630004A63O00DE2O012O002E010900084O002E010A00053O002018010A000A00642O009000090002000200061E010900DE2O013O0004A63O00DE2O012O002E010900063O0012E6000A00653O0012E6000B00664O00D60009000B4O000D01096O002E0109000E4O00F6000A00063O00122O000B00673O00122O000C00686O000A000C000200062O000900110201000A0004A63O00110201002ED3006900E82O01006A0004A63O00E82O010004A63O001102012O002E010900044O007E000A00063O00122O000B006B3O00122O000C006C6O000A000C00024O00090009000A00202O0009000900294O00090002000200062O0009001102013O0004A63O001102012O002E010900033O00204C00090009005F00122O000A00136O000B000E3O00122O000C00406O0009000C000200262O00090011020100600004A63O001102012O002E010900033O00205E00090009005F00122O000A00136O000B000E3O00122O000C00406O0009000C000200202O00090009002A4O000B00043O00202O000B000B006D4O0009000B000200062O0009001102013O0004A63O001102012O002E010900084O002E010A00053O002018010A000A006E2O009000090002000200061E0109001102013O0004A63O001102012O002E010900063O0012E6000A006F3O0012E6000B00704O00D60009000B4O000D01095O0012E60008000B3O0004A63O00A32O010004A63O009A2O01002608000500180201000B0004A63O00180201002E77007100952O0100720004A63O00952O012O002E0107000F4O00D50007000100022O008F000600073O00061E0106002402013O0004A63O002402012O003B000600023O0004A63O002402010004A63O00952O010004A63O002402010004A63O008C2O010004A63O002402010004A63O00822O010012E6000100263O0004A63O002702010004A63O00182O01002ED30073004F020100740004A63O004F0201000E47000E004F020100010004A63O004F02010012E6000200013O00260800020030020100010004A63O00300201002ED300760041020100750004A63O004102012O002E010300033O0020F80003000300254O000400043O00202O0004000400114O000500053O00202O00050005001200122O000600136O00030006000200122O000300063O002E2O00770040020100780004A63O00400201001238000300063O00061E0103004002013O0004A63O00400201001238000300064O003B000300023O0012E60002000B3O000E47000B002C020100020004A63O002C02012O002E010300033O0020D10003000300254O000400043O00202O0004000400174O000500053O00202O00050005001800122O000600136O00030006000200122O000300063O00122O000100143O00044O004F02010004A63O002C02010026072O010073020100140004A63O007302010012E6000200013O0026070102005D0201000B0004A63O005D0201002E770079005B0201007A0004A63O005B0201001238000300063O00061E0103005B02013O0004A63O005B0201001238000300064O003B000300023O0012E6000100193O0004A63O0073020100260800020061020100010004A63O00610201002EFB007B00F3FF2O007C0004A63O00520201001238000300063O00062501030066020100010004A63O00660201002ED3007D00680201007E0004A63O00680201001238000300064O003B000300024O002E010300033O0020D10003000300254O000400043O00202O00040004001A4O000500053O00202O00050005001B00122O000600136O00030006000200122O000300063O00122O0002000B3O00044O005202010026072O0100050001000B0004A63O000500010012E6000200013O0026080002007A0201000B0004A63O007A0201002ED3008000810201007F0004A63O00810201001238000300063O00061E0103007F02013O0004A63O007F0201001238000300064O003B000300023O0012E60001000E3O0004A63O00050001002E7700810076020100820004A63O00760201000E4700010076020100020004A63O00760201001238000300063O0006250103008A020100010004A63O008A0201002E770084008C020100830004A63O008C0201001238000300064O003B000300024O002E010300033O0020D10003000300254O000400043O00202O0004000400224O000500053O00202O00050005002300122O000600136O00030006000200122O000300063O00122O0002000B3O00044O007602010004A63O000500010004A63O009A02010004A63O000200012O00363O00017O00F43O00028O00026O00F03F025O0056A340025O002EAE40025O001AA140025O00F49A40025O00D49A40025O009AAA40026O000840025O00805D40025O00609D40030C3O004570696353652O74696E677303083O00CDA6DD635DF0A4DA03053O00349EC3A917030D3O0052B93378923D689F75B2375CB603083O00EB1ADC5214E6551B03083O00BBA4FDD67D86A6FA03053O0014E8C189A2031B3O0017CCC087F18919762BD1C291F58D03790DD9C3A3E99F1E6727D3DC03083O001142BFA5C687EC77027O0040025O0040A940025O0008914003083O008AB6B30B81FDF7AA03073O0090D9D3C77FE89303123O00D1212A2DC7571754EC1B363AD0560A4BF42B03083O0024984F5E48B5256203083O00E4DD532BDED6402C03043O005FB7B827030E3O00802CE20E51810EA137F4325B8E0703073O0062D55F874634E0025O0032A940025O00D09C4003083O003CAABA07F6E6EBC203083O00B16FCFCE739F888C03183O00309A1530DD59560B8C241BD84370038F151AC7464900850903073O003F65E97074B42F026O001040026O002040025O0044A540025O00A5B24003083O00CC361D1E3BF6F82003063O00989F53696A52030C3O00B4D554DAC65098F559FDCA5703063O003CE1A63192A903083O001C1B3B3E0809280D03063O00674F7E4F4A61030B3O009270DF6A6D12B57CD85B6E03063O007ADA1FB3133E025O005C9B40025O00F07740025O00C09340025O0083B04003083O0041EDD0B7024D7E6103073O00191288A4C36B23030F3O00C02CA74B7EB9E0BEEE21A04C66B9C503083O00D8884DC92F12DCA103083O001EE93FCE01D2853E03073O00E24D8C4BBA68BC03113O0091CFDE3B43BCE7DE3C40ABDEDF2D4AB8C203053O002FD9AEB05F03083O00D30636FDF6CAE71003063O00A4806342899F03163O002987FDBB129BFCAE14A6E7B219BEE1B7148CE5B7139D03043O00DE60E989025O00208E40025O00F5B140025O004CA54003083O008BD86216BB5A7F3503083O0046D8BD1662D2341803103O00F2DEAD832ODFFAAD93D2D4D8AF8E2ODD03053O00B3BABFC3E703083O00CA3A0C2OF0311FF703043O0084995F7803113O0098BC1A28E5C8B5A1A63924E3D293A5A70003073O00C0D1D26E4D97BA025O00D4B040025O000FB240025O0092A140025O00108140025O0020A540025O0072AC4003083O006BC043EE4A3DF04B03073O009738A5379A2353030D3O008D4C13EBAD460BFA844609EFB903043O008EC0236503083O00E5703DB7EE82AB0503083O0076B61549C387ECCC030D3O002C3509502O01D90D3E0F46021E03073O009D685C7A20646D025O00B5B040025O00D0954003083O00BFDD02CDB15E8BCB03063O0030ECB876B9D803113O00D0AE5211C133E0B15E33E931E4A95F35DD03063O005485DD3750AF03083O008EE230B2CE52BAF403063O003CDD8744C6A7030E3O00DBAEFDA14DDDF79CF68771D6FBB103063O00B98EDD98E32203083O0090A3DBDE34298AB803083O00CBC3C6AFAA5D47ED030B3O000A422DC5541DDE3B4D38C603073O009C4E2B5EB53171026O001C4003083O00CCE5A6AD0130F8F303063O005E9F80D2D968030E3O0065EA039E4A6DF85751EA12BA4D6603083O001A309966DF3F1F9903083O003145F9E70B4EEAE003043O009362208D030E3O003956F1CB2B57580C46F1D30E7E7B03073O002B782383AA6636025O0054B040025O00E0764003083O00278891232E57139E03063O003974EDE5574703153O0088BDE8F464E749AD9EEBD476ED55A3B72OE472C67703073O0027CAD18D87178E025O00A06240025O0086B14003083O00670393A2ACBE834703073O00E43466E7D6C5D003103O003FF567CBC78A0AC21BF26CEDF8840CC603083O00B67E8015AA8AEB7903083O00B8DF21F28F1D371503083O0066EBBA5586E6735003163O00621F3B7D7ED131440530585DD211560F2C5674DD215203073O0042376C5E3F12B4025O00308440025O00349040025O001CAC40025O0034AD40025O00B88940025O00988C40025O0062B340025O000DB140025O00188440025O0044974003083O00F03EF906F138C42803063O0056A35B8D729803173O006618715B355F12477B3550005B753C5605677A2C56076D03053O005A336B141303083O00BEF591FB3483F79603053O005DED90E58F03113O0020E5F531044A0CC5F816084D36EFF3150E03063O0026759690796B03083O001EBEFA2E24B5E92903043O005A4DDB8E03113O00D3172411430B63D50C2E3A472068E9113103073O001A866441592C6703083O00C2E62437ADFFE42303053O00C49183504303173O002BA3032017E407830E071BE32CB5001A1DFB169F08040103063O00887ED0666878025O00B07D40025O004FB04003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D030D3O0039E1F8A47015DDF3A07002F6EE03053O00116C929DE8026O001440025O00C4A540025O00405E4003083O00878CC43A35A332A703073O0055D4E9B04E5CCD030A3O007F4B8DD04B5B81E3464B03043O00822A38E803083O00D9B030F74931EDA603063O005F8AD544832003103O001F3BA46B732B24A84D711A27B54A792403053O00164A48C123025O00A09D40025O00FEA540025O0014A040025O0058A24003083O001F7CF04C2577E34B03043O00384C198403113O0076C4AA2AC650C69B29DB57CEA508CE53C403053O00AF3EA1CB46034O0003083O000FD8D7073C32DAD003053O00555CBDA373030F3O0001A9313420A2370826B8393727840003043O005849CC50025O0092AB40025O007C9B4003083O001D86045220D4299003063O00BA4EE370264903153O00C944F8655C6DF945CA5A417EDA58EF415A6EE953F803063O001A9C379D3533025O00607640025O00649D4003083O0075CEE7FD75E141D803063O008F26AB93891C03123O00F48BAFFA0DE6E4C28DADF600F7DDDF8C91C303073O00B4B0E2D993638303083O00E0BC3B13DAB7281403043O0067B3D94F030F3O007FA419F1489AAA44B22FDD4889AF4E03073O00C32AD77CB521EC025O004C9F40025O00A6A54003083O003E5C232A2CF60A4A03063O00986D39575E45030E3O00DDDE1CAAB0D767A0F0D206A796E203083O00C899B76AC3DEB234026O00184003083O0078C600F926A64CD003063O00C82BA3748D4F030C3O00933724ACBEDCE2B1322EAB8003073O0083DF565DE3D09403083O00D0402OA214BBE45603063O00D583252OD67D03133O001338209BE830222BBAD1342431BAE232222AB103053O0081464B45DF025O004EA440025O0080A240025O008AA540025O0054A04003083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C03123O006D2CE6A00E4534E4991B4D2EEB891B432FF303053O00692C5A83CE025O00B08640025O003C984003083O0001E69C29405435F003063O003A5283E85D29030E3O00B644D522522D8778D6325130914E03063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B030E3O00C62A5FEBD6F70241E0CBE82165DF03053O00B991452D8F025O00A8A240025O00689E4003083O00B91A0DB2D584180A03053O00BCEA7F79C603103O000D2116A22E371D84313C14B42A33078B03043O00E358527303083O00701AAEB30B7D440C03063O0013237FDAC762030F3O003DED0FEC1BF204E52BE90BF614D33A03043O00827C9B6A0037032O0012E63O00014O00202O0100023O000E470001000700013O0004A63O000700010012E6000100014O0020010200023O0012E63O00023O0026083O000B000100020004A63O000B0001002ED300040002000100030004A63O00020001002E770006000B000100050004A63O000B00010026072O01000B000100010004A63O000B00010012E6000200013O002ED300070068000100080004A63O0068000100260701020068000100090004A63O006800010012E6000300013O00260800030019000100020004A63O00190001002EFB000A001E0001000B0004A63O003500010012380004000C4O0025000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500062O00040027000100010004A63O002700010012E6000400014O009900045O0012CC0004000C6O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000400023O00122O000300153O002ED300170055000100160004A63O0055000100260701030055000100010004A63O005500010012380004000C4O0025000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000500013O00122O0006001A3O00122O0007001B6O0005000700024O00040004000500062O00040047000100010004A63O004700010012E6000400014O0099000400033O0012CC0004000C6O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000400043O00122O000300023O002ED300210015000100200004A63O0015000100260701030015000100150004A63O001500010012380004000C4O0017000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O0004000400054O000400053O00122O000200263O00044O006800010004A63O001500010026080002006C000100270004A63O006C0001002E7700290088000100280004A63O008800010012380003000C4O0006010400013O00122O0005002A3O00122O0006002B6O0004000600024O0003000300044O000400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000300063O00122O0003000C6O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000400013O00122O000500303O00122O000600316O0004000600024O00030003000400062O00030086000100010004A63O008600010012E6000300014O0099000300073O0004A63O00360301002ED3003300EA000100320004A63O00EA0001002607010200EA000100150004A63O00EA00010012E6000300014O0020010400043O002ED30034008E000100350004A63O008E00010026070103008E000100010004A63O008E00010012E6000400013O002607010400AE000100010004A63O00AE00010012380005000C4O0009000600013O00122O000700363O00122O000800376O0006000800024O0005000500064O000600013O00122O000700383O00122O000800396O0006000800024O0005000500064O000500083O00122O0005000C6O000600013O00122O0007003A3O00122O0008003B6O0006000800024O0005000500064O000600013O00122O0007003C3O00122O0008003D6O0006000800024O0005000500064O000500093O00122O000400023O000E47001500BE000100040004A63O00BE00010012380005000C4O0017000600013O00122O0007003E3O00122O0008003F6O0006000800024O0005000500064O000600013O00122O000700403O00122O000800416O0006000800024O0005000500064O0005000A3O00122O000200093O00044O00EA0001002EFB004200D5FF2O00420004A63O0093000100260701040093000100020004A63O009300010012E6000500013O002608000500C7000100010004A63O00C70001002EFB0043001B000100440004A63O00E000010012380006000C4O0009000700013O00122O000800453O00122O000900466O0007000900024O0006000600074O000700013O00122O000800473O00122O000900486O0007000900024O0006000600074O0006000B3O00122O0006000C6O000700013O00122O000800493O00122O0009004A6O0007000900024O0006000600074O000700013O00122O0008004B3O00122O0009004C6O0007000900024O0006000600074O0006000C3O00122O000500023O002608000500E4000100020004A63O00E40001002EFB004D00E1FF2O004E0004A63O00C300010012E6000400153O0004A63O009300010004A63O00C300010004A63O009300010004A63O00EA00010004A63O008E0001002ED3005000432O01004F0004A63O00432O01000E47000200432O0100020004A63O00432O010012E6000300014O0020010400043O002607010300F0000100010004A63O00F000010012E6000400013O002E77005100132O0100520004A63O00132O01002607010400132O0100020004A63O00132O010012380005000C4O0025000600013O00122O000700533O00122O000800546O0006000800024O0005000500064O000600013O00122O000700553O00122O000800566O0006000800024O00050005000600062O000500052O0100010004A63O00052O010012E6000500014O00990005000D3O0012CC0005000C6O000600013O00122O000700573O00122O000800586O0006000800024O0005000500064O000600013O00122O000700593O00122O0008005A6O0006000800024O0005000500064O0005000E3O00122O000400153O002608000400172O0100010004A63O00172O01002E77005B00302O01005C0004A63O00302O010012380005000C4O0009000600013O00122O0007005D3O00122O0008005E6O0006000800024O0005000500064O000600013O00122O0007005F3O00122O000800606O0006000800024O0005000500064O0005000F3O00122O0005000C6O000600013O00122O000700613O00122O000800626O0006000800024O0005000500064O000600013O00122O000700633O00122O000800646O0006000800024O0005000500064O000500103O00122O000400023O002607010400F3000100150004A63O00F300010012380005000C4O0017000600013O00122O000700653O00122O000800666O0006000800024O0005000500064O000600013O00122O000700673O00122O000800686O0006000800024O0005000500064O000500113O00122O000200153O00044O00432O010004A63O00F300010004A63O00432O010004A63O00F00001000E47006900A42O0100020004A63O00A42O010012E6000300013O002607010300642O0100010004A63O00642O010012380004000C4O0006010500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000500013O00122O0006006C3O00122O0007006D6O0005000700024O0004000400054O000400123O00122O0004000C6O000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000500013O00122O000600703O00122O000700716O0005000700024O00040004000500062O000400622O0100010004A63O00622O010012E6000400014O0099000400133O0012E6000300023O002608000300682O0100150004A63O00682O01002E77007200792O0100730004A63O00792O010012380004000C4O0025000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000500013O00122O000600763O00122O000700776O0005000700024O00040004000500062O000400762O0100010004A63O00762O010012E6000400014O0099000400143O0012E6000200273O0004A63O00A42O01002607010300462O0100020004A63O00462O010012E6000400013O002608000400802O0100010004A63O00802O01002E770079009C2O0100780004A63O009C2O010012380005000C4O0025000600013O00122O0007007A3O00122O0008007B6O0006000800024O0005000500064O000600013O00122O0007007C3O00122O0008007D6O0006000800024O00050005000600062O0005008E2O0100010004A63O008E2O010012E6000500014O0099000500153O0012CC0005000C6O000600013O00122O0007007E3O00122O0008007F6O0006000800024O0005000500064O000600013O00122O000700803O00122O000800816O0006000800024O0005000500064O000500163O00122O000400023O002ED30082007C2O0100830004A63O007C2O010026070104007C2O0100020004A63O007C2O010012E6000300153O0004A63O00462O010004A63O007C2O010004A63O00462O01002E7700840009020100850004A63O0009020100260701020009020100260004A63O000902010012E6000300014O0020010400043O002608000300AE2O0100010004A63O00AE2O01002E77008700AA2O0100860004A63O00AA2O010012E6000400013O002607010400D62O0100010004A63O00D62O010012E6000500013O002608000500B62O0100020004A63O00B62O01002E77008800B82O0100890004A63O00B82O010012E6000400023O0004A63O00D62O01002608000500BC2O0100010004A63O00BC2O01002E77008B00B22O01008A0004A63O00B22O010012380006000C4O0009000700013O00122O0008008C3O00122O0009008D6O0007000900024O0006000600074O000700013O00122O0008008E3O00122O0009008F6O0007000900024O0006000600074O000600173O00122O0006000C6O000700013O00122O000800903O00122O000900916O0007000900024O0006000600074O000700013O00122O000800923O00122O000900936O0007000900024O0006000600074O000600183O00122O000500023O0004A63O00B22O01002607010400F42O0100020004A63O00F42O010012380005000C4O0025000600013O00122O000700943O00122O000800956O0006000800024O0005000500064O000600013O00122O000700963O00122O000800976O0006000800024O00050005000600062O000500E62O0100010004A63O00E62O010012E6000500014O0099000500193O0012CC0005000C6O000600013O00122O000700983O00122O000800996O0006000800024O0005000500064O000600013O00122O0007009A3O00122O0008009B6O0006000800024O0005000500064O0005001A3O00122O000400153O002608000400F82O0100150004A63O00F82O01002EFB009C00B9FF2O009D0004A63O00AF2O010012380005000C4O0017000600013O00122O0007009E3O00122O0008009F6O0006000800024O0005000500064O000600013O00122O000700A03O00122O000800A16O0006000800024O0005000500064O0005001B3O00122O000200A23O00044O000902010004A63O00AF2O010004A63O000902010004A63O00AA2O01000E4700010069020100020004A63O006902010012E6000300013O00260800030010020100010004A63O00100201002ED300A30029020100A40004A63O002902010012380004000C4O0009000500013O00122O000600A53O00122O000700A66O0005000700024O0004000400054O000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O0004001C3O00122O0004000C6O000500013O00122O000600A93O00122O000700AA6O0005000700024O0004000400054O000500013O00122O000600AB3O00122O000700AC6O0005000700024O0004000400054O0004001D3O00122O000300023O002E7700AD0056020100AE0004A63O0056020100260701030056020100020004A63O005602010012E6000400013O000E1000020032020100040004A63O00320201002EFB00AF0004000100B00004A63O003402010012E6000300153O0004A63O005602010026070104002E020100010004A63O002E02010012380005000C4O0025000600013O00122O000700B13O00122O000800B26O0006000800024O0005000500064O000600013O00122O000700B33O00122O000800B46O0006000800024O00050005000600062O00050044020100010004A63O004402010012E6000500B54O00990005001E3O0012D80005000C6O000600013O00122O000700B63O00122O000800B76O0006000800024O0005000500064O000600013O00122O000700B83O00122O000800B96O0006000800024O00050005000600062O00050053020100010004A63O005302010012E6000500014O00990005001F3O0012E6000400023O0004A63O002E02010026080003005A020100150004A63O005A0201002E7700BA000C020100BB0004A63O000C02010012380004000C4O0017000500013O00122O000600BC3O00122O000700BD6O0005000700024O0004000400054O000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000400203O00122O000200023O00044O006902010004A63O000C02010026080002006D020100A20004A63O006D0201002EFB00C00055000100C10004A63O00C002010012E6000300013O000E470002008C020100030004A63O008C02010012380004000C4O0025000500013O00122O000600C23O00122O000700C36O0005000700024O0004000400054O000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500062O0004007E020100010004A63O007E02010012E6000400014O0099000400213O0012CC0004000C6O000500013O00122O000600C63O00122O000700C76O0005000700024O0004000400054O000500013O00122O000600C83O00122O000700C96O0005000700024O0004000400054O000400223O00122O000300153O000E1000150090020100030004A63O00900201002EFB00CA0013000100CB0004A63O00A102010012380004000C4O0025000500013O00122O000600CC3O00122O000700CD6O0005000700024O0004000400054O000500013O00122O000600CE3O00122O000700CF6O0005000700024O00040004000500062O0004009E020100010004A63O009E02010012E6000400014O0099000400233O0012E6000200D03O0004A63O00C002010026070103006E020100010004A63O006E02010012380004000C4O0025000500013O00122O000600D13O00122O000700D26O0005000700024O0004000400054O000500013O00122O000600D33O00122O000700D46O0005000700024O00040004000500062O000400B1020100010004A63O00B102010012E6000400014O0099000400243O0012CC0004000C6O000500013O00122O000600D53O00122O000700D66O0005000700024O0004000400054O000500013O00122O000600D73O00122O000700D86O0005000700024O0004000400054O000400253O00122O000300023O0004A63O006E0201002608000200C4020100D00004A63O00C40201002ED300D90010000100DA0004A63O001000010012E6000300014O0020010400043O000E47000100C6020100030004A63O00C602010012E6000400013O002E7700DC00DE020100DB0004A63O00DE0201002607010400DE020100150004A63O00DE02010012380005000C4O0025000600013O00122O000700DD3O00122O000800DE6O0006000800024O0005000500064O000600013O00122O000700DF3O00122O000800E06O0006000800024O00050005000600062O000500DB020100010004A63O00DB02010012E6000500014O0099000500263O0012E6000200693O0004A63O00100001000E4700010006030100040004A63O000603010012E6000500013O002ED300E10001030100E20004A63O00010301000E4700010001030100050004A63O000103010012380006000C4O0006010700013O00122O000800E33O00122O000900E46O0007000900024O0006000600074O000700013O00122O000800E53O00122O000900E66O0007000900024O0006000600074O000600273O00122O0006000C6O000700013O00122O000800E73O00122O000900E86O0007000900024O0006000600074O000700013O00122O000800E93O00122O000900EA6O0007000900024O00060006000700062O000600FF020100010004A63O00FF02010012E6000600014O0099000600283O0012E6000500023O002607010500E1020100020004A63O00E102010012E6000400023O0004A63O000603010004A63O00E10201002607010400C9020100020004A63O00C902010012E6000500013O002E7700EC0029030100EB0004A63O0029030100260701050029030100010004A63O002903010012380006000C4O0006010700013O00122O000800ED3O00122O000900EE6O0007000900024O0006000600074O000700013O00122O000800EF3O00122O000900F06O0007000900024O0006000600074O000600293O00122O0006000C6O000700013O00122O000800F13O00122O000900F26O0007000900024O0006000600074O000700013O00122O000800F33O00122O000900F46O0007000900024O00060006000700062O00060027030100010004A63O002703010012E6000600014O00990006002A3O0012E6000500023O00260701050009030100020004A63O000903010012E6000400153O0004A63O00C902010004A63O000903010004A63O00C902010004A63O001000010004A63O00C602010004A63O001000010004A63O003603010004A63O000B00010004A63O003603010004A63O000200012O00363O00017O00D43O00028O00025O00A3B240025O0050A940027O0040025O00689D40025O00805840030C3O004570696353652O74696E677303083O00F08CD09588DBC49A03063O00B5A3E9A42OE1030B3O007884326E7C82397F44A30E03043O001730EB5E026O00F03F025O00CAB040025O00C9B040025O0034A140025O0068B340025O00407840025O00E0644003083O00F00357C64E7023D003073O0044A36623B2271E03163O00987CDBD40B9A853DB777D2D32ABB8504AD79D5C92B8503083O0071DE10BAA763D5E303083O001D0BEFE22700FCE503043O00964E6E9B030C3O00B0D622C9AB12A66C8CC22FF503083O0020E5A54781C47EDF025O00788440025O0002A940025O0036AC40025O00F08D4003083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C1030F3O00C22948FF247AAAFF154BF5217CB1E303073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C8772030E3O000ED75C9146502EF75485466B00EB03063O001F48BB3DE22E025O0046AC40026O000840025O00D2AD40025O009C9E40025O0010A740025O00AEAD40026O006640025O00E4994003083O0029182A0C3CFF230903073O00447A7D5E785591030F3O003315D957C6DC8E1810C379DAD6AF0703073O00DA777CAF3EA8B903083O0096F55CD0ACFE4FD703043O00A4C59028030C3O00B6E3AFA3D2BA9AC0B882CEBB03063O00D6E390CAEBBD025O00409940025O00ECAF4003083O00DEA0936F19BD542F03083O005C8DC5E71B70D33303173O00D3EC8F8BDEEAE6BAB1D8F5F22OA5D7E3F199AAC7E3F39303053O00B1869FEAC303083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC0030B3O00F68473261234D79872171203063O0046BEEB1F5F42025O00B4A440025O00A0984003083O0089E70EF2ECB4E50903053O0085DA827A8603113O0010F6E4CCC8B0103DF2EEC1CE962B3DF8E603073O00585C9F83A4BCC3034O00026O001040025O00D07340025O00E0AC40026O00184003083O002DC4B4F0B47C19D203063O00127EA1C084DD03113O006B31BC17725A24A712534D29A00753771803053O00363F48CE6403083O00FB5C516EEC75CF4A03063O001BA839251A8503143O0019B36EBBF328A675BED23FAB72ABD20AB873BDC703053O00B74DCA1CC803083O0024369D1C1E3D8E1B03043O00687753E903113O00C0EB220A42FBFC082467FCEE2E2C4A2OE103053O00239598474203083O002AED56A43317EF5103053O005A798822D003103O00EF0F5B1AE8087117D1075B17D3177D2E03043O007EA76E3503083O000E153AECD5313A2O03063O005F5D704E98BC03133O00E9F48B11CBB8F6C8E38C1BEDAACBE6E78A00F403073O00B2A195E57584DE026O001C4003083O007E1438FB441F2BFC03043O008F2D714C03113O008DAB191EBDB91F33B6971A0AB1AA0829BD03043O005C2OD87C03083O006837B854F45535BF03053O009D3B52CC2003103O001A3BE2F9E6E4FCB70E37F1EEFCEFFB8103083O00D1585E839A898AB3025O0070AA4003083O004FDFCC495E3DD56F03073O00B21CBAB83D3753030E3O00F1DE420BFD1CF1EBCB6030FD1CEC03073O0095A4AD275C926E03083O00C022040B1315F43403063O007B9347707F7A030D3O00FBC2907569CAEA8E7E54D5E5B203053O0026ACADE211025O001EAD40025O00BCA04003083O001BA4D068172D363103083O004248C1A41C7E435103133O00C529A95B2978C82A9E513462F2298F4A2963F703063O0016874CC83846025O00409A40025O002EA44003083O00BE35EC3054EF8A2303063O0081ED5098443D030E3O0064BB01DF151050458702D71D005603073O003831C864937C7703083O00FF3BABE4C530B8E303043O0090AC5EDF030E3O000806A54F3020A4632518AC4F0C3F03043O0027446FC203083O00E5A3F3D370B9D1B503063O00D7B6C687A71903103O00A140ED409966EC6C8C5EE46F9F46FF5803043O0028ED298A03083O00F471EEEC43C973E903053O002AA7149A98030D3O007FEDA766783743F0A7767E2D4603063O00412A9EC2221103083O002922461824E31CFD03083O008E7A47326C4D8D7B030C3O0031ABE911351096F014373D9203053O005B75C29F78025O00709F40025O00E0A040026O00144003083O0043AFB4FE707EADB303053O001910CAC08A030E3O00D9CAB4E0BBF1FCC085C5BBFBE8DB03063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B1030D3O00A919034F9F1D1B46AA0A15589D03043O002DED787A025O004CA240025O00D6AC4003083O0079DF02C6DE0FB95903073O00DE2ABA76B2B761030C3O0079ED5D884FE9458170ED4A8B03043O00EA3D8C2403083O0012D8AE66062FDAA903053O006F41BDDA12030A3O00674A02371959AE48632B03073O00CF232B7B556B3C025O002OB240025O00C06D40025O00F4AA40025O00D3B14003083O00E4EDB638DEE6A53F03043O004CB788C203123O004FF5E00C495D075EE3E931464A067BE8E63D03073O00741A868558302F025O00607040025O002OA84003083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C603113O00BE3DB0023A10FD822BA70F3D24EE823ABD03073O008FEB4ED5405B6203083O00BE4D90FD79B88A5B03063O00D6ED28E4891003103O00A7E2FDCB0AA397CCE9FF02AF91EBC7E903063O00C6E5838FB96303083O006289BC675882AF6003043O001331ECC803123O00DC32F7B4EBB4D131DABEE3B2EA02E5B6E3BF03063O00DA9E5796D78403083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203123O00C7A3BBC487E2CAA09CC681F8ED93A9C68FE903063O008C85C6DAA7E8025O00A0A240025O00E4AF40025O0022AE40025O00EEA04003083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B030E3O0002F58D1ED53DD48B1BCC2BEEA22603053O00A14E9CEA7603083O0094B2DDC8AEB9CECF03043O00BCC7D7A903113O00D0005873FCEF215E76E5F91B7869E7E91903053O00889C693F1B03083O0028896D2012827E2703043O00547BEC1903193O00D287AF04BFBCFE8C85119CA7FF9FAF14B8BCFF859F04ADB2F503063O00D590EBCA77CC03083O00101DCA3E212D4A3003073O002D4378BE4A484303143O00022EE8B6EA81E0EE0F24DDB7F69CEBEA342BE2AB03083O008940428DC599E88E03083O0030D536B2810DD73103053O00E863B042C6030B3O00D9322D227A94FB3EE9202303083O004C8C4148661BED9900ED022O0012E63O00014O00202O0100013O0026083O0006000100010004A63O00060001002EFB000200FEFF2O00030004A63O000200010012E6000100013O000E470001007C000100010004A63O007C00010012E6000200014O0020010300033O0026070102000B000100010004A63O000B00010012E6000300013O00260800030012000100040004A63O00120001002E7700050023000100060004A63O00230001001238000400074O0025000500013O00122O000600083O00122O000700096O0005000700024O0004000400054O000500013O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500062O00040020000100010004A63O002000010012E6000400014O009900045O0012E60001000C3O0004A63O007C0001002ED3000E004F0001000D0004A63O004F00010026070103004F0001000C0004A63O004F00010012E6000400013O002ED3000F002E000100100004A63O002E00010026070104002E0001000C0004A63O002E00010012E6000300043O0004A63O004F0001002E7700120028000100110004A63O0028000100260701040028000100010004A63O00280001001238000500074O0025000600013O00122O000700133O00122O000800146O0006000800024O0005000500064O000600013O00122O000700153O00122O000800166O0006000800024O00050005000600062O00050040000100010004A63O004000010012E6000500014O0099000500023O0012CC000500076O000600013O00122O000700173O00122O000800186O0006000800024O0005000500064O000600013O00122O000700193O00122O0008001A6O0006000800024O0005000500064O000500033O00122O0004000C3O0004A63O002800010026070103000E000100010004A63O000E00010012E6000400013O002608000400560001000C0004A63O00560001002EFB001B00040001001C0004A63O005800010012E60003000C3O0004A63O000E0001002E77001E00520001001D0004A63O0052000100260701040052000100010004A63O00520001001238000500074O0006010600013O00122O0007001F3O00122O000800206O0006000800024O0005000500064O000600013O00122O000700213O00122O000800226O0006000800024O0005000500064O000500043O00122O000500076O000600013O00122O000700233O00122O000800246O0006000800024O0005000500064O000600013O00122O000700253O00122O000800266O0006000800024O00050005000600062O00050076000100010004A63O007600010012E6000500014O0099000500053O0012E60004000C3O0004A63O005200010004A63O000E00010004A63O007C00010004A63O000B0001002EFB0027006D000100270004A63O00E90001000E47002800E9000100010004A63O00E900010012E6000200014O0020010300033O002E77002A0082000100290004A63O0082000100260701020082000100010004A63O008200010012E6000300013O000E100001008B000100030004A63O008B0001002ED3002C00B30001002B0004A63O00B300010012E6000400013O002E77002D00AC0001002E0004A63O00AC0001002607010400AC000100010004A63O00AC0001001238000500074O0025000600013O00122O0007002F3O00122O000800306O0006000800024O0005000500064O000600013O00122O000700313O00122O000800326O0006000800024O00050005000600062O0005009E000100010004A63O009E00010012E6000500014O0099000500063O0012CC000500076O000600013O00122O000700333O00122O000800346O0006000800024O0005000500064O000600013O00122O000700353O00122O000800366O0006000800024O0005000500064O000500073O00122O0004000C3O002608000400B00001000C0004A63O00B00001002E770038008C000100370004A63O008C00010012E60003000C3O0004A63O00B300010004A63O008C0001002607010300D10001000C0004A63O00D10001001238000400074O0006010500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O000400083O00122O000400076O000500013O00122O0006003D3O00122O0007003E6O0005000700024O0004000400054O000500013O00122O0006003F3O00122O000700406O0005000700024O00040004000500062O000400CF000100010004A63O00CF00010012E6000400014O0099000400093O0012E6000300043O002E7700420087000100410004A63O0087000100260701030087000100040004A63O00870001001238000400074O0025000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O00040004000500062O000400E3000100010004A63O00E300010012E6000400474O00990004000A3O0012E6000100483O0004A63O00E900010004A63O008700010004A63O00E900010004A63O00820001002ED3004900362O01004A0004A63O00362O010026072O0100362O01004B0004A63O00362O01001238000200074O0025000300013O00122O0004004C3O00122O0005004D6O0003000500024O0002000200034O000300013O00122O0004004E3O00122O0005004F6O0003000500024O00020002000300062O000200FB000100010004A63O00FB00010012E6000200014O00990002000B3O0012D8000200076O000300013O00122O000400503O00122O000500516O0003000500024O0002000200034O000300013O00122O000400523O00122O000500536O0003000500024O00020002000300062O0002000A2O0100010004A63O000A2O010012E6000200014O00990002000C3O001292000200076O000300013O00122O000400543O00122O000500556O0003000500024O0002000200034O000300013O00122O000400563O00122O000500576O0003000500024O0002000200034O0002000D3O00122O000200076O000300013O00122O000400583O00122O000500596O0003000500024O0002000200034O000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300062O000200252O0100010004A63O00252O010012E6000200014O00990002000E3O0012D8000200076O000300013O00122O0004005C3O00122O0005005D6O0003000500024O0002000200034O000300013O00122O0004005E3O00122O0005005F6O0003000500024O00020002000300062O000200342O0100010004A63O00342O010012E6000200014O00990002000F3O0012E6000100603O0026072O01009B2O01000C0004A63O009B2O010012E6000200014O0020010300033O0026070102003A2O0100010004A63O003A2O010012E6000300013O0026070103005B2O01000C0004A63O005B2O01001238000400074O0006010500013O00122O000600613O00122O000700626O0005000700024O0004000400054O000500013O00122O000600633O00122O000700646O0005000700024O0004000400054O000400103O00122O000400076O000500013O00122O000600653O00122O000700666O0005000700024O0004000400054O000500013O00122O000600673O00122O000700686O0005000700024O00040004000500062O000400592O0100010004A63O00592O010012E6000400014O0099000400113O0012E6000300043O002607010300832O0100010004A63O00832O010012E6000400013O002EFB00690020000100690004A63O007E2O010026070104007E2O0100010004A63O007E2O01001238000500074O0006010600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000500123O00122O000500076O000600013O00122O0007006E3O00122O0008006F6O0006000800024O0005000500064O000600013O00122O000700703O00122O000800716O0006000800024O00050005000600062O0005007C2O0100010004A63O007C2O010012E6000500014O0099000500133O0012E60004000C3O000E47000C005E2O0100040004A63O005E2O010012E60003000C3O0004A63O00832O010004A63O005E2O01002608000300872O0100040004A63O00872O01002ED30072003D2O0100730004A63O003D2O01001238000400074O0025000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000500013O00122O000600763O00122O000700776O0005000700024O00040004000500062O000400952O0100010004A63O00952O010012E6000400014O0099000400143O0012E6000100043O0004A63O009B2O010004A63O003D2O010004A63O009B2O010004A63O003A2O01002ED3007800E52O0100790004A63O00E52O010026072O0100E52O0100040004A63O00E52O01001238000200074O0006010300013O00122O0004007A3O00122O0005007B6O0003000500024O0002000200034O000300013O00122O0004007C3O00122O0005007D6O0003000500024O0002000200034O000200153O00122O000200076O000300013O00122O0004007E3O00122O0005007F6O0003000500024O0002000200034O000300013O00122O000400803O00122O000500816O0003000500024O00020002000300062O000200B92O0100010004A63O00B92O010012E6000200014O0099000200163O0012D8000200076O000300013O00122O000400823O00122O000500836O0003000500024O0002000200034O000300013O00122O000400843O00122O000500856O0003000500024O00020002000300062O000200C82O0100010004A63O00C82O010012E6000200014O0099000200173O001292000200076O000300013O00122O000400863O00122O000500876O0003000500024O0002000200034O000300013O00122O000400883O00122O000500896O0003000500024O0002000200034O000200183O00122O000200076O000300013O00122O0004008A3O00122O0005008B6O0003000500024O0002000200034O000300013O00122O0004008C3O00122O0005008D6O0003000500024O00020002000300062O000200E32O0100010004A63O00E32O010012E6000200014O0099000200193O0012E6000100283O002ED3008E004B0201008F0004A63O004B02010026072O01004B020100900004A63O004B02010012E6000200013O0026070102000B0201000C0004A63O000B0201001238000300074O0025000400013O00122O000500913O00122O000600926O0004000600024O0003000300044O000400013O00122O000500933O00122O000600946O0004000600024O00030003000400062O000300FA2O0100010004A63O00FA2O010012E6000300014O00990003001A3O0012D8000300076O000400013O00122O000500953O00122O000600966O0004000600024O0003000300044O000400013O00122O000500973O00122O000600986O0004000600024O00030003000400062O00030009020100010004A63O000902010012E6000300014O00990003001B3O0012E6000200043O0026080002000F020100010004A63O000F0201002EFB0099002B0001009A0004A63O003802010012E6000300013O00260701030031020100010004A63O00310201001238000400074O0025000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O000500013O00122O0006009D3O00122O0007009E6O0005000700024O00040004000500062O00040020020100010004A63O002002010012E6000400014O00990004001C3O0012D8000400076O000500013O00122O0006009F3O00122O000700A06O0005000700024O0004000400054O000500013O00122O000600A13O00122O000700A26O0005000700024O00040004000500062O0004002F020100010004A63O002F02010012E6000400014O00990004001D3O0012E60003000C3O002608000300350201000C0004A63O00350201002E7700A30010020100A40004A63O001002010012E60002000C3O0004A63O003802010004A63O00100201002E7700A500EA2O0100A60004A63O00EA2O01002607010200EA2O0100040004A63O00EA2O01001238000300074O0017000400013O00122O000500A73O00122O000600A86O0004000600024O0003000300044O000400013O00122O000500A93O00122O000600AA6O0004000600024O0003000300044O0003001E3O00122O0001004B3O00044O004B02010004A63O00EA2O01002E7700AB0089020100AC0004A63O008902010026072O010089020100600004A63O00890201001238000200074O0006010300013O00122O000400AD3O00122O000500AE6O0003000500024O0002000200034O000300013O00122O000400AF3O00122O000500B06O0003000500024O0002000200034O0002001F3O00122O000200076O000300013O00122O000400B13O00122O000500B26O0003000500024O0002000200034O000300013O00122O000400B33O00122O000500B46O0003000500024O00020002000300062O00020069020100010004A63O006902010012E6000200014O0099000200203O0012D8000200076O000300013O00122O000400B53O00122O000500B66O0003000500024O0002000200034O000300013O00122O000400B73O00122O000500B86O0003000500024O00020002000300062O00020078020100010004A63O007802010012E6000200474O0099000200213O0012D8000200076O000300013O00122O000400B93O00122O000500BA6O0003000500024O0002000200034O000300013O00122O000400BB3O00122O000500BC6O0003000500024O00020002000300062O00020087020100010004A63O008702010012E6000200474O0099000200223O0004A63O00EC0201002ED300BD0007000100BE0004A63O000700010026072O010007000100480004A63O000700010012E6000200014O0020010300033O0026070102008F020100010004A63O008F02010012E6000300013O00260800030096020100010004A63O00960201002ED300BF00B5020100C00004A63O00B50201001238000400074O0025000500013O00122O000600C13O00122O000700C26O0005000700024O0004000400054O000500013O00122O000600C33O00122O000700C46O0005000700024O00040004000500062O000400A4020100010004A63O00A402010012E6000400014O0099000400233O0012D8000400076O000500013O00122O000600C53O00122O000700C66O0005000700024O0004000400054O000500013O00122O000600C73O00122O000700C86O0005000700024O00040004000500062O000400B3020100010004A63O00B302010012E6000400014O0099000400243O0012E60003000C3O002607010300D60201000C0004A63O00D60201001238000400074O0025000500013O00122O000600C93O00122O000700CA6O0005000700024O0004000400054O000500013O00122O000600CB3O00122O000700CC6O0005000700024O00040004000500062O000400C5020100010004A63O00C502010012E6000400474O0099000400253O0012D8000400076O000500013O00122O000600CD3O00122O000700CE6O0005000700024O0004000400054O000500013O00122O000600CF3O00122O000700D06O0005000700024O00040004000500062O000400D4020100010004A63O00D402010012E6000400014O0099000400263O0012E6000300043O00260701030092020100040004A63O00920201001238000400074O0017000500013O00122O000600D13O00122O000700D26O0005000700024O0004000400054O000500013O00122O000600D33O00122O000700D46O0005000700024O0004000400054O000400273O00122O000100903O00044O000700010004A63O009202010004A63O000700010004A63O008F02010004A63O000700010004A63O00EC02010004A63O000200012O00363O00017O005C3O00028O00025O0056B140025O00289E40026O00F03F030C3O004570696353652O74696E677303073O0064E5FFCF4D55F903053O0021308A98A803063O00761F2341C43B03063O005712765031A103073O007811DDA7BC490D03053O00D02C7EBAC003063O00E40AB6C315F803083O002E977AC4A6749CA903073O00D1E2411DF7E0FE03053O009B858D267A03053O002633AF4D4A03073O00C5454ACC212F1F03073O00C4405D80FC4A4903043O00E7902F3A2O033O00BED7DE03083O0059D2B8BA15785DAF027O004003073O008121B37A88B03D03053O00E4D54ED41D2O033O008843B503053O008BE72CD66503073O00EDE001591CB42203083O0076B98F663E70D1512O033O005F743A03083O00583C104986C5757C03093O0049734D6F756E746564030D3O004973446561644F7247686F7374025O00608A40025O00C07140025O005C9140025O00709340025O0004AF40025O0032A24003063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O00949240025O009AA740025O0048B040025O005EAC4003163O0044656164467269656E646C79556E697473436F756E74030F3O00412O66656374696E67436F6D626174030C3O00985D68D06B39B4406FDC763403063O005AD1331CB519030A3O0049734361737461626C65025O00C8A640025O0076AF40030C3O00496E74657263652O73696F6E030C3O00D97543EBADD37E44FDB6DF7503053O00DFB01B378E030A3O004162736F6C7574696F6E030A3O0025B9DDBA28AEDABC2BB503043O00D544DBAE030A3O00526564656D7074696F6E03093O004973496E52616E6765026O004440030A3O0019E527E227D52B7604EE03083O001F6B8043874AA55F025O00909840025O00D6AF4003073O00FBE4F94C4FA2DD03063O00D1B8889C2D2103073O004973526561647903093O00466F637573556E6974026O003440025O00489C40026O00B340026O00084003163O00476574456E656D696573496E4D656C2O6552616E6765026O002040025O00E49740025O00A8B1402O033O00414F45030C3O0049734368612O6E656C696E67025O00F09E40025O00049640025O0022A040025O00209A40025O00E8B140025O00B49340025O007C9040025O00788440025O00E07F40025O0030B040025O0012A240025O0050A340025O006AA9400089012O0012E63O00014O00202O0100013O0026083O0006000100010004A63O00060001002EFB000200FEFF2O00030004A63O000200010012E6000100013O0026072O01003A000100040004A63O003A0001001238000200054O0029000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O00025O00122O000200056O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000200023O00122O000200056O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300013O00122O000400103O00122O000500116O0003000500024O0002000200034O000200033O00122O000200056O000300013O00122O000400123O00122O000500136O0003000500024O0002000200034O000300013O00122O000400143O00122O000500156O0003000500024O0002000200034O000200043O00122O000100163O000E4700010059000100010004A63O005900012O002E010200054O00220102000100014O000200066O00020001000100122O000200056O000300013O00122O000400173O00122O000500186O0003000500024O0002000200034O000300013O00122O000400193O00122O0005001A6O0003000500024O0002000200034O000200073O00122O000200056O000300013O00122O0004001B3O00122O0005001C6O0003000500024O0002000200034O000300013O00122O0004001D3O00122O0005001E6O0003000500024O0002000200034O000200083O00122O000100043O0026072O0100282O0100160004A63O00282O010012E6000200013O00260701020077000100010004A63O007700010012E6000300013O00260701030070000100010004A63O007000012O002E010400093O00205F00040004001F2O009000040002000200061E0104006700013O0004A63O006700012O00363O00014O002E010400093O00205F0004000400202O00900004000200020006250104006E000100010004A63O006E0001002ED30021006F000100220004A63O006F00012O00363O00013O0012E6000300043O002E770023005F000100240004A63O005F0001000E470004005F000100030004A63O005F00010012E6000200043O0004A63O007700010004A63O005F00010026080002007B000100040004A63O007B0001002E77002500232O0100260004A63O00232O012O002E0103000A3O00061E010300F400013O0004A63O00F400012O002E0103000A3O00205F0003000300272O009000030002000200061E010300F400013O0004A63O00F400012O002E0103000A3O00205F0003000300282O009000030002000200061E010300F400013O0004A63O00F400012O002E0103000A3O00205F0003000300202O009000030002000200061E010300F400013O0004A63O00F400012O002E010300093O00205F0003000300292O002E0105000A4O0069000300050002000625010300F4000100010004A63O00F400010012E6000300014O0020010400063O002ED3002A009C0001002B0004A63O009C00010026070103009C000100010004A63O009C00010012E6000400014O0020010500053O0012E6000300043O00260701030095000100040004A63O009500012O0020010600063O002ED3002D00A60001002C0004A63O00A60001002607010400A6000100010004A63O00A600010012E6000500014O0020010600063O0012E6000400043O0026070104009F000100040004A63O009F0001002607010500A8000100010004A63O00A800012O002E0107000B3O00202701070007002E4O0007000100024O000600076O000700093O00202O00070007002F4O00070002000200062O000700CD00013O0004A63O00CD00012O002E0107000C4O007E000800013O00122O000900303O00122O000A00316O0008000A00024O00070007000800202O0007000700324O00070002000200062O000700F400013O0004A63O00F40001002E77003300F4000100340004A63O00F400012O002E0107000D4O00480008000C3O00202O0008000800354O000900096O000A00016O0007000A000200062O000700F400013O0004A63O00F400012O002E010700013O00127D000800363O00122O000900376O000700096O00075O00044O00F40001000EC2000400DD000100060004A63O00DD00012O002E0107000D4O00480008000C3O00202O0008000800384O000900096O000A00016O0007000A000200062O000700F400013O0004A63O00F400012O002E010700013O00127D000800393O00122O0009003A6O000700096O00075O00044O00F400012O002E0107000D4O00430008000C3O00202O00080008003B4O0009000A3O00202O00090009003C00122O000B003D6O0009000B00024O000900096O000A00016O0007000A000200062O000700F400013O0004A63O00F400012O002E010700013O00127D0008003E3O00122O0009003F6O000700096O00075O00044O00F400010004A63O00A800010004A63O00F400010004A63O009F00010004A63O00F400010004A63O009500012O002E010300093O00205F00030003002F2O0090000300020002000625010300FF000100010004A63O00FF00012O002E0103000E3O00061E010300222O013O0004A63O00222O012O002E01035O00061E010300222O013O0004A63O00222O010012E6000300014O0020010400053O002E77004000192O0100410004A63O00192O01002607010300192O0100010004A63O00192O012O002E0106000E3O000698000400112O0100060004A63O00112O012O002E0106000C4O0050000700013O00122O000800423O00122O000900436O0007000900024O00060006000700202O0006000600444O0006000200024O000400064O002E0106000B3O0020B40006000600454O000700046O0008000F3O00122O000900466O0006000900024O000500063O00122O000300043O0026070103003O0100040004A63O003O010006250105001F2O0100010004A63O001F2O01002ED3004800222O0100470004A63O00222O012O003B000500023O0004A63O00222O010004A63O003O010012E6000200163O0026070102005C000100160004A63O005C00010012E6000100493O0004A63O00282O010004A63O005C0001000E4700490007000100010004A63O000700012O002E010200093O0020AD00020002004A00122O0004004B6O0002000400024O000200103O002E2O004C00382O01004D0004A63O00382O010012380002004E3O00061E010200382O013O0004A63O00382O012O002E010200104O000C010200024O0099000200113O0004A63O003A2O010012E6000200044O0099000200114O002E010200093O00205F00020002004F2O009000020002000200061E010200412O013O0004A63O00412O01002EFB00500049000100510004A63O00882O01002EFB00520047000100520004A63O00882O012O002E010200073O0006250102004B2O0100010004A63O004B2O012O002E010200093O00205F00020002002F2O009000020002000200061E010200882O013O0004A63O00882O012O002E010200093O00205F00020002002F2O0090000200020002000625010200522O0100010004A63O00522O01002E77005400782O0100530004A63O00782O010012E6000200014O0020010300043O002607010200652O0100040004A63O00652O010026080003005A2O0100010004A63O005A2O01002ED3005500562O0100560004A63O00562O012O002E010500124O00D50005000100022O008F000400053O000625010400612O0100010004A63O00612O01002E77005700882O0100580004A63O00882O012O003B000400023O0004A63O00882O010004A63O00562O010004A63O00882O01002E77005A00542O0100590004A63O00542O01002607010200542O0100010004A63O00542O010012E6000500013O0026070105006E2O0100040004A63O006E2O010012E6000200043O0004A63O00542O01002E77005B006A2O01005C0004A63O006A2O010026070105006A2O0100010004A63O006A2O010012E6000300014O0020010400043O0012E6000500043O0004A63O006A2O010004A63O00542O010004A63O00882O010012E6000200014O0020010300033O0026070102007A2O0100010004A63O007A2O012O002E010400134O00D50004000100022O008F000300043O00061E010300882O013O0004A63O00882O012O003B000300023O0004A63O00882O010004A63O007A2O010004A63O00882O010004A63O000700010004A63O00882O010004A63O000200012O00363O00017O00183O00028O00026O00F03F025O00509840025O00F0A840025O00A7B240025O00D0964003053O005072696E7403153O002FC77911F837C97909BC0EC6350AA147ED6501BB4903053O00D867A8156803123O005CA450B47DA14FA57AA146807DAF56A27EBE03043O00C418CD2303173O000A82F0162B87EF072C87E62B2F8CEA050A8EE113288DF003043O00664EEB83025O00B07F40025O00ECAA4003123O00DE2O27544235BB35F8223160423BA232FC3D03083O00549A4E54242759D7030A3O004D657267655461626C6503123O0044697370652O6C61626C65446562752O667303193O0044697370652O6C61626C6544697365617365446562752O6673030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03213O00D5EE5A4145CDE05A5901F4EF166045EBA107084B2OAF060845DFF8167A0AF2EC7D03053O00659D813638004D3O0012E63O00014O00202O0100023O002607012O0007000100010004A63O000700010012E6000100014O0020010200023O0012E63O00023O000E470002000200013O0004A63O00020001000E4700010009000100010004A63O000900010012E6000200013O002ED30003002E000100040004A63O002E00010026070102002E000100010004A63O002E00010012E6000300013O000E1000010015000100030004A63O00150001002ED300050029000100060004A63O002900012O002E01045O00204E0004000400074O000500013O00122O000600083O00122O000700096O000500076O00043O00014O000400026O000500013O00122O0006000A3O00122O0007000B6O0005000700024O000600026O000700013O00122O0008000C3O00122O0009000D6O0007000900024O0006000600074O00040005000600122O000300023O000E4700020011000100030004A63O001100010012E6000200023O0004A63O002E00010004A63O0011000100260800020032000100020004A63O00320001002E77000F000C0001000E0004A63O000C00012O002E010300024O0002000400013O00122O000500103O00122O000600116O0004000600024O000500033O00202O0005000500124O000600023O00202O0006000600134O000700023O00202O0007000700144O0005000700024O00030004000500122O000300153O00202O0003000300164O000400013O00122O000500173O00122O000600186O000400066O00033O000100044O004C00010004A63O000C00010004A63O004C00010004A63O000900010004A63O004C00010004A63O000200012O00363O00017O00", GetFEnv(), ...);

