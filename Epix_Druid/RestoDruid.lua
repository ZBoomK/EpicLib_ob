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
				if (Enum <= 159) then
					if (Enum <= 79) then
						if (Enum <= 39) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
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
												local B;
												local A;
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
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if (Stk[Inst[2]] < Stk[Inst[4]]) then
													VIP = Inst[3];
												else
													VIP = VIP + 1;
												end
											end
										elseif (Enum <= 2) then
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
										elseif (Enum == 3) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 6) then
										if (Enum > 5) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 7) then
										local A;
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
									elseif (Enum == 8) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
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
												return Unpack(Stk, A, A + Inst[3]);
											end
										end
									elseif (Enum <= 12) then
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
									elseif (Enum == 13) then
										local A = Inst[2];
										Stk[A] = Stk[A]();
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
									if (Enum == 15) then
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
								elseif (Enum <= 17) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 18) then
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
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum > 20) then
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
											if (Inst[2] <= Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 22) then
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
										if not Stk[Inst[2]] then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 26) then
									if (Enum > 25) then
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
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
								elseif (Enum <= 27) then
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
								else
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
								end
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum == 30) then
										local A = Inst[2];
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
								elseif (Enum == 33) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 36) then
								if (Enum == 35) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 37) then
								local B;
								local A;
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
							elseif (Enum == 38) then
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
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
						elseif (Enum <= 59) then
							if (Enum <= 49) then
								if (Enum <= 44) then
									if (Enum <= 41) then
										if (Enum == 40) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 42) then
										local Edx;
										local Results, Limit;
										local A;
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
									elseif (Enum > 43) then
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
								elseif (Enum <= 46) then
									if (Enum > 45) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 47) then
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								elseif (Enum == 48) then
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
								end
							elseif (Enum <= 54) then
								if (Enum <= 51) then
									if (Enum == 50) then
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
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 52) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 53) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 57) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 58) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 69) then
							if (Enum <= 64) then
								if (Enum <= 61) then
									if (Enum == 60) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum <= 62) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 63) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = not Stk[Inst[3]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 68) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 74) then
							if (Enum <= 71) then
								if (Enum == 70) then
									if (Inst[2] < Stk[Inst[4]]) then
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
							elseif (Enum <= 72) then
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
							elseif (Enum > 73) then
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
						elseif (Enum <= 76) then
							if (Enum == 75) then
								if (Inst[2] == Inst[4]) then
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
						elseif (Enum <= 77) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 78) then
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = {};
						end
					elseif (Enum <= 119) then
						if (Enum <= 99) then
							if (Enum <= 89) then
								if (Enum <= 84) then
									if (Enum <= 81) then
										if (Enum > 80) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											if (Stk[Inst[2]] == Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 82) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 86) then
									if (Enum == 85) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
											if (Mvm[1] == 233) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 88) then
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 94) then
								if (Enum <= 91) then
									if (Enum > 90) then
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
										Stk[Inst[2]] = Inst[3];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 93) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 96) then
								if (Enum > 95) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 109) then
							if (Enum <= 104) then
								if (Enum <= 101) then
									if (Enum > 100) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										if (Inst[2] == Inst[4]) then
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
								elseif (Enum > 103) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 106) then
								if (Enum > 105) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 107) then
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
							elseif (Enum > 108) then
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
							end
						elseif (Enum <= 114) then
							if (Enum <= 111) then
								if (Enum > 110) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 112) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 113) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 116) then
							if (Enum > 115) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 117) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 118) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 122) then
									Stk[Inst[2]]();
								elseif (Enum == 123) then
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
							elseif (Enum <= 126) then
								if (Enum == 125) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 127) then
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
							elseif (Enum == 128) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 132) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							elseif (Enum > 133) then
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
						elseif (Enum <= 136) then
							if (Enum == 135) then
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
							elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum <= 137) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 138) then
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
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 149) then
						if (Enum <= 144) then
							if (Enum <= 141) then
								if (Enum > 140) then
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
							elseif (Enum <= 142) then
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
							elseif (Enum > 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 146) then
							if (Enum == 145) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
							end
						elseif (Enum <= 147) then
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
						elseif (Enum == 148) then
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
					elseif (Enum <= 154) then
						if (Enum <= 151) then
							if (Enum > 150) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 152) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum > 153) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 156) then
						if (Enum == 155) then
							do
								return Stk[Inst[2]]();
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
					elseif (Enum <= 157) then
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 158) then
						local A = Inst[2];
						local B = Inst[3];
						for Idx = A, B do
							Stk[Idx] = Vararg[Idx - A];
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
				elseif (Enum <= 239) then
					if (Enum <= 199) then
						if (Enum <= 179) then
							if (Enum <= 169) then
								if (Enum <= 164) then
									if (Enum <= 161) then
										if (Enum == 160) then
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
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum <= 162) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 163) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 166) then
									if (Enum > 165) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum <= 167) then
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
									if (Inst[2] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 168) then
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
									Env[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 174) then
								if (Enum <= 171) then
									if (Enum == 170) then
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
								elseif (Enum <= 172) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 173) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 176) then
								if (Enum > 175) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 177) then
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
							elseif (Enum > 178) then
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							else
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
							end
						elseif (Enum <= 189) then
							if (Enum <= 184) then
								if (Enum <= 181) then
									if (Enum > 180) then
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
								elseif (Enum <= 182) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 183) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 186) then
								if (Enum == 185) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
										return;
									end
								end
							elseif (Enum <= 187) then
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
							elseif (Enum == 188) then
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
						elseif (Enum <= 194) then
							if (Enum <= 191) then
								if (Enum > 190) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 192) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 196) then
							if (Enum == 195) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 197) then
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
						elseif (Enum == 198) then
							if (Inst[2] <= Stk[Inst[4]]) then
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
					elseif (Enum <= 219) then
						if (Enum <= 209) then
							if (Enum <= 204) then
								if (Enum <= 201) then
									if (Enum == 200) then
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
									end
								elseif (Enum <= 202) then
									if (Inst[2] > Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 203) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								else
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
							elseif (Enum <= 206) then
								if (Enum > 205) then
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 207) then
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
							elseif (Enum > 208) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 214) then
							if (Enum <= 211) then
								if (Enum == 210) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 212) then
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
							elseif (Enum > 213) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 216) then
							if (Enum > 215) then
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
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							end
						elseif (Enum <= 217) then
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
						elseif (Enum > 218) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
						end
					elseif (Enum <= 229) then
						if (Enum <= 224) then
							if (Enum <= 221) then
								if (Enum > 220) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 222) then
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
							elseif (Enum > 223) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 226) then
							if (Enum == 225) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 227) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 228) then
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
					elseif (Enum <= 234) then
						if (Enum <= 231) then
							if (Enum > 230) then
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
						elseif (Enum <= 232) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 233) then
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 236) then
						if (Enum > 235) then
							VIP = Inst[3];
						elseif (Inst[2] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 237) then
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
					elseif (Enum == 238) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 279) then
					if (Enum <= 259) then
						if (Enum <= 249) then
							if (Enum <= 244) then
								if (Enum <= 241) then
									if (Enum > 240) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 242) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 243) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 246) then
								if (Enum == 245) then
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
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 247) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
						elseif (Enum <= 254) then
							if (Enum <= 251) then
								if (Enum > 250) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 252) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 253) then
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
						elseif (Enum <= 256) then
							if (Enum > 255) then
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
							end
						elseif (Enum <= 257) then
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						elseif (Enum == 258) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 269) then
						if (Enum <= 264) then
							if (Enum <= 261) then
								if (Enum > 260) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								else
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 262) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum > 263) then
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
								if (Inst[2] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 266) then
							if (Enum > 265) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 267) then
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
						elseif (Enum == 268) then
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
					elseif (Enum <= 274) then
						if (Enum <= 271) then
							if (Enum > 270) then
								if (Stk[Inst[2]] > Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 272) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 273) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 276) then
						if (Enum > 275) then
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum <= 277) then
						if (Inst[2] ~= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 278) then
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
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 299) then
					if (Enum <= 289) then
						if (Enum <= 284) then
							if (Enum <= 281) then
								if (Enum == 280) then
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
							elseif (Enum <= 282) then
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
							elseif (Enum > 283) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 286) then
							if (Enum > 285) then
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
						elseif (Enum <= 287) then
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
						elseif (Enum > 288) then
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
							Stk[Inst[2]] = Inst[3] ~= 0;
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
					elseif (Enum <= 294) then
						if (Enum <= 291) then
							if (Enum == 290) then
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
						elseif (Enum <= 292) then
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
						elseif (Enum > 293) then
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
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 296) then
						if (Enum > 295) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 297) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 298) then
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
				elseif (Enum <= 309) then
					if (Enum <= 304) then
						if (Enum <= 301) then
							if (Enum == 300) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 302) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						elseif (Enum == 303) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 306) then
						if (Enum > 305) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 307) then
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
					elseif (Enum == 308) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 314) then
					if (Enum <= 311) then
						if (Enum > 310) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
						end
					elseif (Enum <= 312) then
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 313) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
						end
					else
						Stk[Inst[2]] = #Stk[Inst[3]];
					end
				elseif (Enum <= 317) then
					if (Enum <= 315) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 316) then
						if (Stk[Inst[2]] <= Inst[4]) then
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
				elseif (Enum <= 318) then
					local A;
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
				elseif (Enum > 319) then
					Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503193O00F4D3D23DD99FD50BD8C7E417E3A8D311F5D1CE2CE2F5CB0BD003083O007EB1A3BB4586DBA703193O000532E4BDC6AC2OFC2926D297FC9BFAE60430F8ACFDC6E2FC2103083O008940428DC599E88E002E3O001223012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004EC3O000A0001001288000300063O002025010400030007001288000500083O002025010500050009001288000600083O00202501060006000A00065600073O000100062O00E93O00064O00E98O00E93O00044O00E93O00014O00E93O00024O00E93O00053O00202501080003000B00202501090003000C2O004E000A5O001288000B000D3O000656000C0001000100022O00E93O000A4O00E93O000B4O00E9000D00073O001237000E000E3O001237000F000F4O001E000D000F0002000656000E0002000100032O00E93O00074O00E93O00094O00E93O00084O007F000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O000C00025O00122O000300016O00045O00122O000500013O00042O0003002100012O003B00076O0073000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O003B000C00034O00C8000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O0080000C6O00A6000A3O00020020D6000A000A00022O00320009000A4O007100073O00010004D40003000500012O003B000300054O00E9000400024O004C000300044O003901036O00BA3O00017O001B3O00028O00025O0016A140025O00D2AD40025O00907B40025O00E89240026O00F03F025O00C07A40025O00C88E40025O00A6A340025O00D0A140025O0010A740025O00F88F40025O00508140025O0034AB40025O0080A740025O00805240025O009AAB40025O00707240025O00388840025O00E49940025O00EEA940025O00DCB240025O0096A740025O00409940025O00588F40025O00B0AC40025O00F88A40015E3O001237000200014O0084000300053O002E540002000B000100030004EC3O000B0001000EEB00010008000100020004EC3O00080001002E4B00040005000100050004EC3O000B0001001237000300014O0084000400043O001237000200063O0026F600020002000100060004EC3O000200012O0084000500053O002E1E01070053000100080004EC3O005300010026F600030053000100060004EC3O00530001001237000600013O002E54000A0013000100090004EC3O001300010026F600060013000100010004EC3O00130001002E1E010C00470001000B0004EC3O004700010026F600040047000100010004EC3O00470001001237000700014O0084000800083O002E1E010D001D0001000E0004EC3O001D0001002E4B000F00FEFF2O000F0004EC3O001D00010026F60007001D000100010004EC3O001D0001001237000800013O002E1E0110002C000100110004EC3O002C0001002E540012002C000100130004EC3O002C00010026F60008002C000100060004EC3O002C0001001237000400063O0004EC3O00470001002E5400140024000100150004EC3O00240001000EEB00010032000100080004EC3O00320001002E1E01160024000100170004EC3O00240001001237000900013O0026F60009003F000100010004EC3O003F00012O003B000A6O00270105000A3O00069D0005003E000100010004EC3O003E00012O003B000A00014O00E9000B6O007E000C6O00D7000A6O0039010A5O001237000900063O0026F600090033000100060004EC3O00330001001237000800063O0004EC3O002400010004EC3O003300010004EC3O002400010004EC3O004700010004EC3O001D00010026160104004B000100060004EC3O004B0001002E4B001800C9FF2O00190004EC3O001200012O00E9000700054O007E00086O00D700076O003901075O0004EC3O001200010004EC3O001300010004EC3O001200010004EC3O005D000100261601030057000100010004EC3O00570001002E1E011A000E0001001B0004EC3O000E0001001237000400014O0084000500053O001237000300063O0004EC3O000E00010004EC3O005D00010004EC3O000200012O00BA3O00017O00503O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203063O009B28112F76B703073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503063O00C856B541F94303043O00269C37C703053O008E727F3D0003083O0023C81D1C4873149A03093O0034B0C4CC8803221CAD03073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A3050030A3O0064570C3140711020454E03043O004529226003043O0095D7D20703063O004BDCA3B76A6203043O0021BB982303053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D47903073O0024E1A8C308E0B603043O00AE678EC503083O00733E5A2A3C51F65303073O009836483F58453E03053O00F0D6FB55D003043O003CB4A48E030B3O006A5B163D28FF134C570A2703073O0072383E6549478D03053O009CFBCECDBC03043O00A4D889BB030B3O00E0E322A6A9EC0AC6EF3EBC03073O006BB28651D2C69E03053O002O1C97CFAE03053O00CA586EE2A6030B3O00F10A91E3C5D10E96FEC5CD03053O00AAA36FE297028O00024O0080B3C540030C3O0047657445717569706D656E74026O002A40026O002C4003103O005265676973746572466F724576656E7403183O00211C93016B0516340187117E1A0C3F048D1B66160736159603073O00497150D2582E5703143O00B100EC2BC2B313FF37C0A402F237C9A00EE137C303053O0087E14CAD7203243O008D8A256D80CEF09C85307D93D9F09F9934679FCAE3859330709FC4E1938A396598CCEA8803073O00AFCCC97124D68B03043O0075CD3ED903053O006427AC55BC03133O005265676973746572504D756C7469706C696572030A3O0052616B65446562752O6603063O0053657441504C025O00405A400033023O0017000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E4O000F5O00122O001000183O00122O001100196O000F001100024O000F0004000F00122O001000046O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011001000114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012001000124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013001000134O00145O00122O001500203O00122O001600216O0014001600024O0014001000142O00FC00155O00122O001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0014001400152O00FC00155O00122O001600263O00122O001700276O0015001700024O0015001000154O00165O00122O001700283O00122O001800296O0016001800024O0015001500162O003B00165O0012370017002A3O0012210118002B6O0016001800024O00150015001600122O0016002C6O00175O00122O0018002D3O00122O0019002E6O0017001900024O0016001600174O00176O006700186O007B00198O001A8O001B8O001C8O001D8O001E8O001F005B6O005C5O00122O005D002F3O00122O005E00304O001E005C005E00022O0048005C0010005C4O005D5O00122O005E00313O00122O005F00326O005D005F00024O005C005C005D4O005D5O00122O005E00333O00122O005F00346O005D005F00022O0048005D000D005D4O005E5O00122O005F00353O00122O006000366O005E006000024O005D005D005E4O005E5O00122O005F00373O00122O006000386O005E006000022O0027015E000F005E2O003B005F5O001218016000393O00122O0061003A6O005F006100024O005E005E005F4O005F8O00605O00122O0061003B3O00122O0062003C6O0060006200024O0060001300602O003B00615O0012FD0062003D3O00122O0063003E6O0061006300024O00600060006100122O0061003F4O0025006200633O00122O006400403O00122O006500406O00668O00678O00688O00698O006A8O006B8O006C5O00202O006D000800414O006D0002000200202O006E006D004200062O006E00B600013O0004EC3O00B600012O00E9006E000F3O002025016F006D00422O0005016E0002000200069D006E00B9000100010004EC3O00B900012O00E9006E000F3O001237006F003F4O0005016E00020002002025016F006D004300064F006F00C100013O0004EC3O00C100012O00E9006F000F3O0020250170006D00432O0005016F0002000200069D006F00C4000100010004EC3O00C400012O00E9006F000F3O0012370070003F4O0005016F0002000200202E01700004004400065600723O000100052O00E93O006F4O00E93O006D4O00E93O000F4O00E93O00084O00E93O006E4O002200735O00122O007400453O00122O007500466O007300756O00703O000100202E01700004004400065600720001000100022O00E93O00644O00E93O00654O002200735O00122O007400473O00122O007500486O007300756O00703O000100065600700002000100042O00E93O005D4O003B8O00E93O005C4O00E93O00063O00202E01710004004400065600730003000100012O00E93O00704O002200745O00122O007500493O00122O0076004A6O007400766O00713O000100065600710004000100012O00E93O00084O009800725O00122O0073004B3O00122O0074004C6O0072007400024O0072005D007200202O00720072004D00202O0074005D004E4O007500716O007200750001000656007200050001000A2O00E93O006C4O00E93O00664O00E93O005D4O003B8O00E93O006A4O00E93O00084O00E93O00694O00E93O006B4O00E93O00684O00E93O00673O00065600730006000100022O00E93O005D4O00E93O00653O00065600740007000100042O00E93O005D4O00E93O00654O00E93O00634O00E93O00083O00065600750008000100012O00E93O005D3O00065600760009000100052O00E93O005D4O00E93O00084O003B3O00014O003B3O00024O00E93O00633O0006560077000A000100022O00E93O005D4O00E93O00083O0006560078000B000100012O00E93O005D3O0006560079000C000100042O003B3O00014O00E93O005C4O00E93O005D4O003B3O00023O000656007A000D000100022O00E93O005C4O00E93O005D3O000656007B000E000100012O00E93O005D3O000656007C000F000100052O00E93O005C4O00E93O005F4O00E93O00194O00E93O00084O00E93O005D3O000656007D0010000100122O00E93O005D4O003B8O00E93O00634O00E93O00124O00E93O000A4O00E93O00084O00E93O005C4O00E93O00624O00E93O00734O00E93O00604O00E93O00744O00E93O002D4O00E93O00194O00E93O007C4O00E93O001D4O00E93O00774O00E93O00784O00E93O00763O000656007E0011000100122O00E93O005D4O003B8O00E93O005C4O00E93O00624O00E93O00734O00E93O000A4O00E93O00604O00E93O002D4O00E93O00194O00E93O00084O00E93O00124O00E93O00634O00E93O00684O00E93O001D4O00E93O00754O00E93O00694O00E93O006A4O00E93O006C3O000656007F00120001000A2O00E93O005C4O00E93O005D4O00E93O00724O00E93O00084O003B8O00E93O007E4O00E93O000A4O00E93O00124O00E93O00634O00E93O007D3O00065600800013000100062O00E93O000B4O00E93O005C4O00E93O005D4O003B8O00E93O00124O00E93O00603O000656008100140001000F2O00E93O005E4O003B8O00E93O00264O00E93O00084O00E93O00274O00E93O00124O00E93O00604O00E93O00204O00E93O00224O00E93O00214O00E93O00584O00E93O00594O00E93O005D4O00E93O005A4O00E93O005B3O00065600820015000100092O00E93O005D4O003B8O00E93O00084O00E93O00124O00E93O00604O00E93O007A4O00E93O000C4O00E93O000B4O00E93O007B3O00065600830016000100332O00E93O000B4O00E93O001E4O00E93O005D4O003B8O00E93O004A4O00E93O00084O00E93O007B4O00E93O004B4O00E93O00124O00E93O00604O00E93O007C4O00E93O002E4O00E93O00194O00E93O00794O00E93O00554O00E93O005C4O00E93O00564O00E93O00574O00E93O00404O00E93O00414O00E93O00144O00E93O002F4O00E93O003A4O00E93O003B4O00E93O00534O00E93O00544O00E93O00314O00E93O00324O00E93O00334O00E93O00464O00E93O00474O00E93O00344O00E93O00354O00E93O00424O00E93O00434O00E93O00484O00E93O00494O00E93O00444O00E93O00454O00E93O007A4O00E93O000C4O00E93O003C4O00E93O003D4O00E93O003E4O00E93O003F4O00E93O004D4O00E93O004E4O00E93O00504O00E93O00514O00E93O00374O00E93O00383O000656008400170001000E2O00E93O00814O00E93O00284O00E93O005C4O00E93O005D4O00E93O00604O00E93O00254O00E93O00244O00E93O001A4O00E93O00804O00E93O001C4O00E93O007F4O00E93O001B4O00E93O00824O00E93O00833O00065600850018000100132O00E93O00284O00E93O005C4O00E93O005D4O00E93O00604O00E93O00294O00E93O001C4O00E93O007F4O00E93O00254O00E93O00244O00E93O001A4O00E93O00804O00E93O00174O00E93O001E4O00E93O00834O00E93O00234O003B8O00E93O00084O00E93O00124O00E93O000A3O00065600860019000100202O00E93O003D4O003B8O00E93O002B4O00E93O002C4O00E93O002D4O00E93O002E4O00E93O002F4O00E93O00304O00E93O00394O00E93O003A4O00E93O00374O00E93O00384O00E93O003B4O00E93O003C4O00E93O00214O00E93O00224O00E93O00234O00E93O00244O00E93O001F4O00E93O00204O00E93O00294O00E93O002A4O00E93O00274O00E93O00284O00E93O00254O00E93O00264O00E93O00354O00E93O00364O00E93O00334O00E93O00344O00E93O00314O00E93O00323O0006560087001A0001001F2O00E93O00444O003B8O00E93O00454O00E93O00464O00E93O00564O00E93O00574O00E93O00584O00E93O00404O00E93O003E4O00E93O003F4O00E93O004F4O00E93O004D4O00E93O004E4O00E93O00504O00E93O00514O00E93O00524O00E93O004A4O00E93O004B4O00E93O004C4O00E93O00594O00E93O005A4O00E93O005B4O00E93O00414O00E93O00424O00E93O00434O00E93O00534O00E93O00544O00E93O00554O00E93O00474O00E93O00484O00E93O00493O0006560088001B0001001D2O00E93O001D4O003B8O00E93O001E4O00E93O00084O00E93O00244O00E93O005D4O00E93O001A4O00E93O005C4O00E93O003D4O00E93O003C4O00E93O00194O00E93O001B4O00E93O001C4O00E93O00614O00E93O00184O00E93O00624O00E93O000A4O00E93O00634O00E93O00864O00E93O00874O00E93O00174O00E93O00654O00E93O00044O00E93O00644O00E93O00124O00E93O00824O00E93O00834O00E93O00844O00E93O00853O0006560089001C000100032O00E93O00704O00E93O00104O003B7O002013008A0010004F00122O008B00506O008C00886O008D00896O008A008D00016O00013O001D3O00103O00028O00025O00208340025O00E89040026O00F03F025O001AA240025O00CCA040025O00BCA040026O002C40025O0098A840025O00188740025O00409A40025O00688740030C3O0047657445717569706D656E74026O002A40025O00E0B140025O003AB240004C3O0012373O00014O0084000100023O002E5400020043000100030004EC3O004300010026F63O0043000100040004EC3O00430001002E1E01060006000100050004EC3O000600010026F600010006000100010004EC3O00060001001237000200013O002E4B00070013000100070004EC3O001E00010026F60002001E000100040004EC3O001E00012O003B000300013O00202501030003000800064F0003001900013O0004EC3O001900012O003B000300024O003B000400013O0020250104000400082O000501030002000200069D0003001C000100010004EC3O001C00012O003B000300023O001237000400014O00050103000200022O004A00035O0004EC3O004B000100261601020022000100010004EC3O00220001002E4B000900EBFF2O000A0004EC3O000B0001001237000300013O0026F600030027000100040004EC3O00270001001237000200043O0004EC3O000B00010026160103002B000100010004EC3O002B0001002E54000B00230001000C0004EC3O002300012O003B000400033O00202401040004000D4O0004000200024O000400016O000400013O00202O00040004000E00062O0004003900013O0004EC3O003900012O003B000400024O003B000500013O00202501050005000E2O000501040002000200069D0004003C000100010004EC3O003C00012O003B000400023O001237000500014O00050104000200022O004A000400043O001237000300043O0004EC3O002300010004EC3O000B00010004EC3O004B00010004EC3O000600010004EC3O004B0001002E54000F0002000100100004EC3O000200010026F63O0002000100010004EC3O00020001001237000100014O0084000200023O0012373O00043O0004EC3O000200012O00BA3O00017O00063O00028O00025O0006AE40025O00ACA740025O00709F40025O00A06A40024O0080B3C54000143O0012373O00014O0084000100013O002616012O0008000100010004EC3O00080001002E1501020008000100030004EC3O00080001002E5400040002000100050004EC3O00020001001237000100013O0026F600010009000100010004EC3O00090001001237000200064O004A00025O001237000200064O004A000200013O0004EC3O001300010004EC3O000900010004EC3O001300010004EC3O000200012O00BA3O00017O00183O00025O00A4B140025O004CA24003133O0033E0A8A2A3ABA21EC3B9A4B9AFA209CEADA2A903073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65028O00025O00B4A340025O00C09840025O00C4A240025O00EAAA40025O005AA94003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD709018030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303123O00018DAC5C01841D112788BA68018A0416239703083O007045E4DF2C64E87103123O0044697370652O6C61626C65446562752O667303173O0044697370652O6C61626C654375727365446562752O667303123O00F01614C3B3708AD51D0BD6927984C11901C003073O00E6B47F67B3D61C03173O00A80C4C56E14DEC8D075343C940E785067B43E654E68A1603073O0080EC653F26842100453O002E1E01020038000100010004EC3O003800012O003B8O00102O0100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O003800013O0004EC3O003800010012373O00064O0084000100013O002E5400080012000100070004EC3O00120001002616012O0014000100060004EC3O00140001002E4B000900FCFF2O000A0004EC3O000E0001001237000100063O002E4B000B3O0001000B0004EC3O001500010026F600010015000100060004EC3O001500012O003B000200024O002D010300013O00122O0004000C3O00122O0005000D6O0003000500024O000400033O00202O00040004000E4O000500023O00202O00050005000F4O000600023O00202O0006000600102O001E0004000600022O00070002000300044O000200026O000300013O00122O000400113O00122O000500126O0003000500024O000400033O00202O00040004000E4O000500023O00202O0005000500132O003B000600023O0020250106000600142O001E0004000600022O00260002000300040004EC3O004400010004EC3O001500010004EC3O004400010004EC3O000E00010004EC3O004400012O003B3O00024O00172O0100013O00122O000200153O00122O000300166O0001000300024O000200026O000300013O00122O000400173O00122O000500186O0003000500024O0002000200036O000100022O00BA3O00019O003O00034O003B8O007A3O000100012O00BA3O00017O00033O0003093O00537465616C74685570029A5O99F93F026O00F03F000D4O003B7O0020EF5O00014O000200016O000300018O0003000200064O000A00013O0004EC3O000A00010012373O00023O00069D3O000B000100010004EC3O000B00010012373O00034O002D3O00024O00BA3O00017O002A3O00028O00026O000840025O006AB140025O0014A74003053O006F3272E85203063O00203840139C3A03053O00436F756E7403083O0069DCE4445CFB925F03073O00E03AA885363A92026O006440025O00BCAB40027O0040025O0040A040025O00307D40026O00F03F025O00A06240025O00F4AA4003083O009E6CB89235A46ABC03053O0053CD18D9E003053O00D1D7CC29EE03043O005D86A5AD03093O00497343617374696E6703053O00577261746803053O0089E0C0D63203083O001EDE92A1A25AAED203083O00D65A7118E347620F03043O006A852E1003083O005374617266697265025O009CAA40025O00C6A440025O00EAAA40026O004D40025O0050834003063O0042752O665570030C3O0045636C69707365536F6C6172030C3O0045636C697073654C756E6172025O0007B340025O00D88B40025O008EAC40025O00BFB040025O004CAC4003083O0042752O66446F776E00CF3O0012373O00013O002616012O0005000100020004EC3O00050001002E1E01030020000100040004EC3O002000012O003B000100013O00069D0001001C000100010004EC3O001C00012O003B000100024O0039000200033O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O000100020002000E2O0001001C000100010004EC3O001C00012O003B000100024O005D000200033O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100074O000100020002000E2O0001001D000100010004EC3O001D00012O00CB00016O0067000100014O004A00015O0004EC3O00CE0001002E1E010A00770001000B0004EC3O00770001000EEB000C002600013O0004EC3O00260001002E1E010D00770001000E0004EC3O00770001001237000100013O0026F60001002B0001000F0004EC3O002B00010012373O00023O0004EC3O00770001002E5400100027000100110004EC3O002700010026F600010027000100010004EC3O002700012O003B000200013O00069D0002004D000100010004EC3O004D00012O003B000200024O0050000300033O00122O000400123O00122O000500136O0003000500024O00020002000300202O0002000200074O00020002000200262O00020046000100010004EC3O004600012O003B000200024O005D000300033O00122O000400143O00122O000500156O0003000500024O00020002000300202O0002000200074O000200020002000E2O00010050000100020004EC3O005000012O003B000200053O0020B70002000200164O000400023O00202O0004000400174O00020004000200062O00020051000100010004EC3O005100012O003B000200063O0004EC3O005100012O00CB00026O0067000200014O004A000200044O003B000200013O00069D00020070000100010004EC3O007000012O003B000200024O0050000300033O00122O000400183O00122O000500196O0003000500024O00020002000300202O0002000200074O00020002000200262O00020069000100010004EC3O006900012O003B000200024O005D000300033O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200074O000200020002000E2O00010073000100020004EC3O007300012O003B000200053O0020B70002000200164O000400023O00202O00040004001C4O00020004000200062O00020074000100010004EC3O007400012O003B000200083O0004EC3O007400012O00CB00026O0067000200014O004A000200073O0012370001000F3O0004EC3O00270001002616012O007B000100010004EC3O007B0001002E54001D00A40001001E0004EC3O00A40001001237000100013O002E4B001F00210001001F0004EC3O009D0001002E540020009D000100210004EC3O009D00010026F60001009D000100010004EC3O009D00012O003B000200053O0020B70002000200224O000400023O00202O0004000400234O00020004000200062O0002008E000100010004EC3O008E00012O003B000200053O00202E0102000200222O003B000400023O0020250104000400242O001E0002000400022O004A000200014O003B000200053O0020850002000200224O000400023O00202O0004000400234O00020004000200062O0002009B00013O0004EC3O009B00012O003B000200053O00202E0102000200222O003B000400023O0020250104000400242O001E0002000400022O004A000200093O0012370001000F3O002E4B002500DFFF2O00250004EC3O007C0001000EA3000F007C000100010004EC3O007C00010012373O000F3O0004EC3O00A400010004EC3O007C0001000EA3000F000100013O0004EC3O00010001001237000100013O000EEB000F00AB000100010004EC3O00AB0001002E54002700AD000100260004EC3O00AD00010012373O000C3O0004EC3O000100010026162O0100B1000100010004EC3O00B10001002E54002800A7000100290004EC3O00A700012O003B000200053O0020850002000200224O000400023O00202O0004000400244O00020004000200062O000200BD00013O0004EC3O00BD00012O003B000200053O00202E01020002002A2O003B000400023O0020250104000400232O001E0002000400022O004A000200084O003B000200053O0020850002000200224O000400023O00202O0004000400234O00020004000200062O000200CA00013O0004EC3O00CA00012O003B000200053O00202E01020002002A2O003B000400023O0020250104000400242O001E0002000400022O004A000200063O0012370001000F3O0004EC3O00A700010004EC3O000100012O00BA3O00017O00033O0003113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66026O001440010D3O00208500013O00014O00035O00202O0003000300024O00010003000200062O0001000B00013O0004EC3O000B00012O003B000100013O000E460003000A000100010004EC3O000A00012O00CB00016O0067000100014O002D000100024O00BA3O00017O00113O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O66026O002840026O00104003063O00456E65726779026O00494003083O0042752O66446F776E030E3O0048656172744F6654686557696C6403063O0042752O665570030A3O00446562752O66446F776E03073O0050726576474344026O00F03F03073O0053756E6669726503083O00446562752O665570030D3O00446562752O6652656D61696E73030E3O00446562752O664475726174696F6E029A5O99E93F01533O00208500013O00014O00035O00202O0003000300024O00010003000200062O0001002D00013O0004EC3O002D00012O003B000100013O002O0E0103002D000100010004EC3O002D00012O003B000100023O00260F2O010011000100040004EC3O001100012O003B000100033O00202E2O01000100052O00052O01000200020026CE00010018000100060004EC3O001800012O003B000100033O0020B70001000100074O00035O00202O0003000300084O00010003000200062O00010027000100010004EC3O002700012O003B000100023O00260F2O010020000100040004EC3O002000012O003B000100033O00202E2O01000100052O00052O01000200020026CE0001002D000100060004EC3O002D00012O003B000100033O0020850001000100094O00035O00202O0003000300084O00010003000200062O0001002D00013O0004EC3O002D000100202E2O013O000A2O003B00035O0020250103000300022O001E00010003000200069D00010051000100010004EC3O005100012O003B000100033O00201F2O010001000B00122O0003000C6O00045O00202O00040004000D4O00010004000200062O0001005100013O0004EC3O0051000100202E2O013O000E2O003B00035O0020250103000300022O001E00010003000200064F0001004600013O0004EC3O0046000100202E2O013O000F2O001B01035O00202O0003000300024O00010003000200202O00023O00104O00045O00202O0004000400024O00020004000200202O00020002001100062O0001004C000100020004EC3O004C000100202E2O013O000A2O003B00035O0020250103000300022O001E00010003000200064F0001005100013O0004EC3O005100012O003B000100023O0026162O0100500001000C0004EC3O005000012O00CB00016O0067000100014O002D000100024O00BA3O00017O00043O0003113O00446562752O665265667265736861626C65030E3O004D2O6F6E66697265446562752O6603093O0054696D65546F446965026O001440010E3O00208500013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004EC3O000C000100202E2O013O00032O00052O0100020002000E460004000B000100010004EC3O000B00012O00CB00016O0067000100014O002D000100024O00BA3O00017O000D3O0003113O00446562752O665265667265736861626C652O033O0052697003063O00456E65726779025O00805640030D3O00446562752O6652656D61696E73026O002440030B3O00436F6D626F506F696E7473026O00144003093O0054696D65546F446965026O003840026O001040030A3O00446562752O66446F776E027O0040016F3O0020B700013O00014O00035O00202O0003000300024O00010003000200062O00010011000100010004EC3O001100012O003B000100013O00202E2O01000100032O00052O0100020002002O0E0104005D000100010004EC3O005D000100202E2O013O00052O003B00035O0020250103000300022O001E00010003000200263C2O01005D000100060004EC3O005D00012O003B000100013O00202E2O01000100072O00052O01000200020026F600010029000100080004EC3O0029000100202E2O013O00094O0001000200024O000200023O00202O00033O00054O00055O00202O0005000500024O00030005000200122O0004000A6O0002000400024O000300033O00202O00043O00054O00065O00202O0006000600024O00040006000200122O0005000A6O0003000500024O00020002000300062O0002006C000100010004EC3O006C00012O003B000100023O0020DA00023O00054O00045O00202O0004000400024O0002000400024O000300013O00202O0003000300074O00030002000200202O00030003000B4O0001000300024O000200033O00202E01033O00052O00B300055O00202O0005000500024O0003000500024O000400013O00202O0004000400074O00040002000200202O00040004000B4O0002000400024O00010001000200202O00023O00092O00050102000200020006580001005D000100020004EC3O005D00012O003B000100023O0020A100023O00054O00045O00202O0004000400024O00020004000200202O00020002000B4O000300013O00202O0003000300074O00030002000200202O00030003000B4O0001000300024O000200033O00202O00033O00054O00055O00202O0005000500024O00030005000200202O00030003000B4O000400013O00202O0004000400074O00040002000200202O00040004000B4O0002000400024O00010001000200202O00023O00094O00020002000200062O0002006C000100010004EC3O006C000100202E2O013O000C2O003B00035O0020250103000300022O001E00010003000200064F0001006D00013O0004EC3O006D00012O003B000100013O0020092O01000100074O0001000200024O000200043O00202O00020002000D00102O0002000D000200062O0002006C000100010004EC3O006C00012O00CB00016O0067000100014O002D000100024O00BA3O00017O00073O00030A3O00446562752O66446F776E030A3O0052616B65446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O002440030B3O00436F6D626F506F696E7473026O00144001193O0020B700013O00014O00035O00202O0003000300024O00010003000200062O0001000C000100010004EC3O000C000100202E2O013O00032O003B00035O0020250103000300022O001E00010003000200064F0001001700013O0004EC3O0017000100202E2O013O00042O00052O0100020002002O0E01050015000100010004EC3O001500012O003B000100013O00202E2O01000100062O00052O01000200020026132O010016000100070004EC3O001600012O00CB00016O0067000100014O002D000100024O00BA3O00017O00023O0003083O00446562752O66557003133O004164617074697665537761726D446562752O6601063O00203B2O013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00043O00031A3O00467269656E646C79556E6974735769746842752O66436F756E74030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746800274O00319O00000100013O00202O0001000100014O000200023O00202O0002000200024O0001000200024O000200013O00202O0002000200014O000300023O00202O0003000300032O00050102000200022O002A0001000100024O000200013O00202O0002000200014O000300023O00202O0003000300044O000200039O0000024O000100036O000200013O00202O0002000200012O003B000300023O00203E0103000300024O0002000200024O000300013O00202O0003000300014O000400023O00202O0004000400034O0003000200024O0002000200034O000300013O00202O0003000300012O003B000400023O0020770004000400044O000300046O00013O00028O00016O00028O00017O00023O00031D3O00467269656E646C79556E697473576974686F757442752O66436F756E74030C3O0052656A7576656E6174696F6E00074O00E67O00206O00014O000100013O00202O0001000100026O00019O008O00017O00043O0003063O0042752O665570030C3O0052656A7576656E6174696F6E03083O00526567726F777468030A3O0057696C6467726F77746801123O0020B700013O00014O00035O00202O0003000300024O00010003000200062O00010010000100010004EC3O0010000100202E2O013O00012O003B00035O0020250103000300032O001E00010003000200069D00010010000100010004EC3O0010000100202E2O013O00012O003B00035O0020250103000300042O001E0001000300022O002D000100024O00BA3O00017O00153O00028O00026O004140025O0012A440025O00A0A240025O00E08940026O00F03F025O0044AB40025O0022AE40025O00289E40030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B657403063O0042752O665570030E3O0048656172744F6654686557696C64030F3O00496E6361726E6174696F6E42752O66026O004440025O00C07140025O0020A340025O00C49840025O0078A640025O00AC944003133O0048616E646C65426F2O746F6D5472696E6B657400613O0012373O00014O0084000100013O002E1E01020002000100030004EC3O000200010026F63O0002000100010004EC3O00020001001237000100013O000EA30001003B000100010004EC3O003B0001001237000200014O0084000300033O0026160102000F000100010004EC3O000F0001002E540004000B000100050004EC3O000B0001001237000300013O00261601030014000100060004EC3O00140001002E1E01080016000100070004EC3O00160001001237000100063O0004EC3O003B00010026160103001A000100010004EC3O001A0001002E4B000900F8FF2O00070004EC3O001000012O003B00045O00202501040004000B2O003B000500014O003B000600023O00064F0006002C00013O0004EC3O002C00012O003B000600033O0020B700060006000C4O000800043O00202O00080008000D4O00060008000200062O0006002C000100010004EC3O002C00012O003B000600033O00202E01060006000C2O003B000800043O00202501080008000E2O001E0006000800020012370007000F4O0084000800084O001E0004000800020012A80004000A3O002E4B00100007000100100004EC3O003700010012880004000A3O00064F0004003700013O0004EC3O003700010012880004000A4O002D000400023O001237000300063O0004EC3O001000010004EC3O003B00010004EC3O000B0001002E5400120007000100110004EC3O000700010026162O010041000100060004EC3O00410001002E4B001300C8FF2O00140004EC3O000700012O003B00025O0020250102000200152O003B000300014O003B000400023O00064F0004005300013O0004EC3O005300012O003B000400033O0020B700040004000C4O000600043O00202O00060006000D4O00040006000200062O00040053000100010004EC3O005300012O003B000400033O00202E01040004000C2O003B000600043O00202501060006000E2O001E0004000600020012370005000F4O001C000600066O00020006000200122O0002000A3O00122O0002000A3O00062O0002006000013O0004EC3O006000010012880002000A4O002D000200023O0004EC3O006000010004EC3O000700010004EC3O006000010004EC3O000200012O00BA3O00017O0005012O00028O00025O0004AF40025O00107240025O00B89F40026O00104003053O0016C6534AB603053O00D345B12O3A03073O0049735265616479027O0040025O0079B24003053O005377697065030E3O004973496E4D656C2O6552616E6765026O002040025O00E09F40025O00508540030C3O00A4F270E5EC8BB4E46DB5BA9303063O00ABD785199589025O0094924003053O00D2C020FFEB03083O002281A8529A8F509C030B3O00436F6D626F506F696E7473026O00144003063O00456E65726779025O00805640025O00D07040025O009CA240025O00208A40025O0024B04003053O005368726564030C3O0096BA210E4C0E8A84A6735F1A03073O00E9E5D2536B282E026O00F03F025O0048B040025O00D89A40025O005AA740025O009C9040025O00CCA240025O002AA94003073O004B92201171952B03043O007718E74E030A3O00446562752O66446F776E030D3O0053756E66697265446562752O6603093O0054696D65546F446965025O00DEAB40025O006BB14003073O0053756E66697265030E3O0049735370652O6C496E52616E6765025O0096A240025O002CA840030E3O009138AB4CD55214C22EA45E9C124503073O0071E24DC52ABC2003083O001719FBBB3C1FE6B003043O00D55A769403083O0042752O66446F776E03073O00436174466F726D030E3O004D2O6F6E66697265446562752O66025O00109D40025O0022A040025O00D6AF40025O006DB24003083O004D2O6F6E66697265030F3O005621BB584B523CB1164E5A3AF4041903053O002D3B4ED436025O0096A040025O001EB34003073O008B3770182DE9EA03073O008FD8421E7E449B2O033O0098C11D03083O0081CAA86DABA5C3B7030B3O004973417661696C61626C6503083O00446562752O6655702O033O00526970026O003E40025O0046AC4003093O00436173744379636C6503103O0053756E666972654D6F7573656F766572030E3O00314D39DED706E3625B36CC9E46B603073O0086423857B8BE74026O009740025O00A8A040025O000EAA4003083O00113E06B51FE2333003083O00555C5169DB798B412O033O00CFBA4003063O00BF9DD330251C03113O004D2O6F6E666972654D6F7573656F766572030F3O00D210FB123CD60DF15C39DE0BB44E6803053O005ABF7F947C025O00A8B140025O0086B140025O007DB140025O0022AC40025O002CAB40025O00688240025O00708340025O00049640025O00109B40025O00406040025O002EB240025O00188B40025O001EA940025O00E8B140025O005EA340025O00649B40025O007C9040025O00C88440025O00BDB140030D3O001DAB805CF7706E399C964DF17403073O00185CCFE12C8319030A3O0049734361737461626C65030D3O004164617074697665537761726D03123O004AD7B95C0F745DD6875F0C7C59DEF84F1A6903063O001D2BB3D82C7B03113O009ED62E5AB2D22578B5DC135CB4CB2958AE03043O002CDDB940025O00B0A040025O00E07F40025O00049140025O00FEAA4003063O0042752O665570025O0092A240025O0050A340030E3O0048656172744F6654686557696C64030E3O0029E2494D672EE17C577636EE445B03053O00136187283F030F3O00432O6F6C646F776E52656D61696E73026O004E40030E3O00865932293B1EA8683B3E1838A25803063O0051CE3C535B4F026O004940030D3O00446562752O6652656D61696E7303113O00436F6E766F6B655468655370697269747303093O004973496E52616E6765025O0098A540025O0018A740031A3O004DA4DE6420C8489B5AA3D54D3CD344B647BFC3322CC259E41FF303083O00C42ECBB0124FA32D025O00F0A840025O00EAAA40025O00A7B240025O0012AB4003043O006B5740F803083O006B39362B9D15E6E703093O00537465616C74685570025O0084AB40025O00C4A04003043O0052616B65026O002440025O00FEAC40025O00B07F40030A3O00C98A1AF0F9DFCECFCB4303073O00AFBBEB7195D9BC025O0098A940025O0045B240030B3O005573655472696E6B657473025O00C0A140025O004C9140025O0046AB40025O0074A940025O00788C40025O00488040025O00B8AD40025O0080AA40025O0061B140025O0078AC40025O00206340025O007C9D40025O00388D40025O00406440025O00E07940025O007C9240025O00949B40026O008440025O0002B040025O00F08740026O006940025O00B6AF4003093O0023428299953BBFF71503083O00907036E3EBE64ECD03093O00537461727375726765025O0014A940025O00E0954003103O00A03C0EEEC34EA12F0ABCD35AA7685DAA03063O003BD3486F9CB0030E3O006682E23F5AA8E5194682D424428303043O004D2EE78303113O00995BB856B55FB374B2518550B346BF54A903043O0020DA34D603113O006D183FBEFEBB406E461202B8F8A24C4E5D03083O003A2E7751C891D025025O0080AE40025O0080584003183O00238931BEBD82392DB324A4AC8221228034ECAABC226BDE6603073O00564BEC50CCC9DD03073O00514063A3F1997F03063O00EB122117E59E025O009FB040025O00288140025O00807D40025O00208040030F3O0053BBD58456B5D3B610B9C0AF10E89903043O00DB30DAA1025O00A8B040025O00B88E40030D3O00C2746E46D846EFF1625E40CF4A03073O008084111C29BB2F026O000840026O0039402O033O00333B1603053O003D6152665A030D3O004665726F63696F75734269746503153O00AA2BB944C45E111CBF11A942D3525E0AAD3AEB189503083O0069CC4ECB2BA7377E025O00909540025O002EAE40025O00207840025O009FB140025O00E06640025O001AAA4003043O00B2A6CCFE03063O009FE0C7A79B37025O00A07A40030B3O00E5F237D7B7F03DC6B7A06A03043O00B297935C025O00BBB240025O00F2A74003043O00BEFC473703073O001AEC9D2C52722C030B3O00504D756C7469706C696572025O0010AC40025O00F8AF40030B3O00382FDE5E6A2DD44F6A7A8503043O003B4A4EB5025O0068AA40025O0014B340025O00C49B40025O00E9B240025O00F5B1402O033O0097A33303083O0031C5CA437E7364A72O033O000552CF03073O003E573BBF49E036026O002640025O00F4AE40025O006AA740025O0008A840030A3O00F50BEA89E403EE89B45603043O00A987629A03063O00FF7F3655EE3B03073O00A8AB1744349D5303113O00446562752O665265667265736861626C65030C3O00546872617368446562752O66025O00E2A740025O006AA040025O00189240025O009DB24003063O00546872617368030A3O00E079E7AC3625C7F770E103073O00E7941195CD454D025O0012AF40025O0050B2400001042O0012373O00013O002E5400030053000100020004EC3O00530001002E4B00040050000100040004EC3O005300010026F63O0053000100050004EC3O005300012O003B00016O0010010200013O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O00010002000200062O0001002800013O0004EC3O002800012O003B000100023O000EC600090028000100010004EC3O00280001002E4B000A00140001000A0004EC3O002800012O003B000100034O007900025O00202O00020002000B4O000300043O00202O00030003000C00122O0005000D6O0003000500024O000300036O00010003000200062O00010023000100010004EC3O00230001002E4B000E00070001000F0004EC3O002800012O003B000100013O001237000200103O001237000300114O004C000100034O00392O015O002E4B001200D8030100120004EC4O0004012O003B00016O0010010200013O00122O000300133O00122O000400146O0002000400024O00010001000200202O0001000100084O00010002000200062O0001003E00013O0004EC3O003E00012O003B000100053O00202E2O01000100152O00052O01000200020026132O010040000100160004EC3O004000012O003B000100053O00202E2O01000100172O00052O0100020002000E4600180040000100010004EC3O00400001002E54001A2O00040100190004EC4O000401002E54001B2O000401001C0004EC4O0004012O003B000100034O00FA00025O00202O00020002001D4O000300043O00202O00030003000C00122O000500166O0003000500024O000300036O00010003000200062O00012O0004013O0004EC4O0004012O003B000100013O0012690002001E3O00122O0003001F6O000100036O00015O00045O000401002616012O0057000100200004EC3O00570001002E1E012100562O0100220004EC3O00562O01001237000100013O002E1E012400BC000100230004EC3O00BC00010026F6000100BC000100200004EC3O00BC0001002E1E01250089000100260004EC3O008900012O003B00026O0010010300013O00122O000400273O00122O000500286O0003000500024O00020002000300202O0002000200084O00020002000200062O0002008900013O0004EC3O008900012O003B000200043O0020850002000200294O00045O00202O00040004002A4O00020004000200062O0002008900013O0004EC3O008900012O003B000200043O00202E01020002002B2O0005010200020002002O0E01160089000100020004EC3O00890001002E54002C00820001002D0004EC3O008200012O003B000200034O003000035O00202O00030003002E4O000400043O00202O00040004002F4O00065O00202O00060006002E4O0004000600024O000400046O00020004000200062O00020084000100010004EC3O00840001002E5400310089000100300004EC3O008900012O003B000200013O001237000300323O001237000400334O004C000200044O003901026O003B00026O0010010300013O00122O000400343O00122O000500356O0003000500024O00020002000300202O0002000200084O00020002000200062O000200A600013O0004EC3O00A600012O003B000200053O0020850002000200364O00045O00202O0004000400374O00020004000200062O000200A600013O0004EC3O00A600012O003B000200043O0020850002000200294O00045O00202O0004000400384O00020004000200062O000200A600013O0004EC3O00A600012O003B000200043O00202E01020002002B2O0005010200020002000E46001600A8000100020004EC3O00A80001002E1E013A00BB000100390004EC3O00BB0001002E1E013B00BB0001003C0004EC3O00BB00012O003B000200034O002900035O00202O00030003003D4O000400043O00202O00040004002F4O00065O00202O00060006003D4O0004000600024O000400046O00020004000200062O000200BB00013O0004EC3O00BB00012O003B000200013O0012370003003E3O0012370004003F4O004C000200044O003901025O001237000100093O0026162O0100C0000100010004EC3O00C00001002E1E0141004D2O0100400004EC3O004D2O012O003B00026O0010010300013O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200084O00020002000200062O000200052O013O0004EC3O00052O012O003B000200053O0020850002000200364O00045O00202O0004000400374O00020004000200062O000200052O013O0004EC3O00052O012O003B000200043O00202E01020002002B2O0005010200020002002O0E011600052O0100020004EC3O00052O012O003B00026O0010010300013O00122O000400443O00122O000500456O0003000500024O00020002000300202O0002000200464O00020002000200062O000200EC00013O0004EC3O00EC00012O003B000200043O0020B70002000200474O00045O00202O0004000400484O00020004000200062O000200EC000100010004EC3O00EC00012O003B000200053O00202E0102000200172O00050102000200020026CE000200052O0100490004EC3O00052O01002E4B004A00190001004A0004EC3O00052O012O003B000200063O00203600020002004B4O00035O00202O00030003002E4O000400076O000500086O000600043O00202O00060006002F4O00085O00202O00080008002E4O0006000800024O000600066O000700086O000900093O00202O00090009004C4O00020009000200062O000200052O013O0004EC3O00052O012O003B000200013O0012370003004D3O0012370004004E4O004C000200044O003901025O002E4B004F00470001004F0004EC3O004C2O01002E540050004C2O0100510004EC3O004C2O012O003B00026O0010010300013O00122O000400523O00122O000500536O0003000500024O00020002000300202O0002000200084O00020002000200062O0002004C2O013O0004EC3O004C2O012O003B000200053O0020850002000200364O00045O00202O0004000400374O00020004000200062O0002004C2O013O0004EC3O004C2O012O003B000200043O00202E01020002002B2O0005010200020002002O0E0116004C2O0100020004EC3O004C2O012O003B00026O0010010300013O00122O000400543O00122O000500556O0003000500024O00020002000300202O0002000200464O00020002000200062O000200352O013O0004EC3O00352O012O003B000200043O0020B70002000200474O00045O00202O0004000400484O00020004000200062O000200352O0100010004EC3O00352O012O003B000200053O00202E0102000200172O00050102000200020026CE0002004C2O0100490004EC3O004C2O012O003B000200063O00203600020002004B4O00035O00202O00030003003D4O000400076O0005000A6O000600043O00202O00060006002F4O00085O00202O00080008003D4O0006000800024O000600066O000700086O000900093O00202O0009000900564O00020009000200062O0002004C2O013O0004EC3O004C2O012O003B000200013O001237000300573O001237000400584O004C000200044O003901025O001237000100203O002E54005A0058000100590004EC3O005800010026162O0100532O0100090004EC3O00532O01002E1E015B00580001005C0004EC3O005800010012373O00093O0004EC3O00562O010004EC3O00580001002616012O005C2O0100010004EC3O005C2O01002E15015D005C2O01005E0004EC3O005C2O01002E54006000510201005F0004EC3O00510201001237000100013O002E1E016200612O0100610004EC3O00612O010026162O0100632O0100090004EC3O00632O01002E4B003A0004000100630004EC3O00652O010012373O00203O0004EC3O005102010026162O01006B2O0100200004EC3O006B2O01002E3D0065006B2O0100640004EC3O006B2O01002E54006600E92O0100670004EC3O00E92O01002E1E0169008A2O0100680004EC3O008A2O01002E1E016A008A2O01006B0004EC3O008A2O012O003B00026O0010010300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O00020002006E4O00020002000200062O0002008A2O013O0004EC3O008A2O012O003B000200034O002900035O00202O00030003006F4O000400043O00202O00040004002F4O00065O00202O00060006006F4O0004000600024O000400046O00020004000200062O0002008A2O013O0004EC3O008A2O012O003B000200013O001237000300703O001237000400714O004C000200044O003901026O003B0002000B3O00064F000200E82O013O0004EC3O00E82O012O003B0002000C3O00064F000200E82O013O0004EC3O00E82O012O003B00026O0010010300013O00122O000400723O00122O000500736O0003000500024O00020002000300202O00020002006E4O00020002000200062O000200E82O013O0004EC3O00E82O01002E1E017500E82O0100740004EC3O00E82O01002E1E017600E82O0100770004EC3O00E82O012O003B000200053O0020850002000200784O00045O00202O0004000400374O00020004000200062O000200E82O013O0004EC3O00E82O01002E54007900E82O01007A0004EC3O00E82O012O003B000200053O0020B70002000200784O00045O00202O00040004007B4O00020004000200062O000200C22O0100010004EC3O00C22O012O003B00026O005D000300013O00122O0004007C3O00122O0005007D6O0003000500024O00020002000300202O00020002007E4O000200020002000E2O007F00C22O0100020004EC3O00C22O012O003B00026O00D3000300013O00122O000400803O00122O000500816O0003000500024O00020002000300202O0002000200464O00020002000200062O000200E82O0100010004EC3O00E82O012O003B000200053O00202E0102000200172O00050102000200020026CE000200E82O0100820004EC3O00E82O012O003B000200053O00202E0102000200152O00050102000200020026CE000200D32O0100160004EC3O00D32O012O003B000200043O0020CD0002000200834O00045O00202O0004000400484O000200040002000E2O001600D62O0100020004EC3O00D62O012O003B000200023O002O0E012000E82O0100020004EC3O00E82O012O003B000200034O007900035O00202O0003000300844O000400043O00202O00040004008500122O000600496O0004000600024O000400046O00020004000200062O000200E32O0100010004EC3O00E32O01002E54008700E82O0100860004EC3O00E82O012O003B000200013O001237000300883O001237000400894O004C000200044O003901025O001237000100093O002E1E018A005D2O01008B0004EC3O005D2O010026F60001005D2O0100010004EC3O005D2O01002E54008D00140201008C0004EC3O001402012O003B00026O0010010300013O00122O0004008E3O00122O0005008F6O0003000500024O00020002000300202O0002000200084O00020002000200062O00022O0002013O0004EC4O0002012O003B000200053O0020FF0002000200904O00048O000500016O00020005000200062O0002002O020100010004EC3O002O0201002E5400910014020100920004EC3O001402012O003B000200034O007900035O00202O0003000300934O000400043O00202O00040004000C00122O000600946O0004000600024O000400046O00020004000200062O0002000F020100010004EC3O000F0201002E5400950014020100960004EC3O001402012O003B000200013O001237000300973O001237000400984O004C000200044O003901025O002E1E0199004F0201009A0004EC3O004F02010012880002009B3O00064F0002004F02013O0004EC3O004F02012O003B000200053O0020FF0002000200904O00048O000500016O00020005000200062O0002004F020100010004EC3O004F0201001237000200014O0084000300053O002E1E019D002B0201009C0004EC3O002B0201000EEB00010028020100020004EC3O00280201002E1E019E002B0201009F0004EC3O002B0201001237000300014O0084000400043O001237000200203O002E1E01A10022020100A00004EC3O002202010026F600020022020100200004EC3O002202012O0084000500053O002E5400A30039020100A20004EC3O0039020100261601030036020100010004EC3O00360201002E5400A40039020100A50004EC3O00390201001237000400014O0084000500053O001237000300203O0026160103003F020100200004EC3O003F0201002ECA00A7003F020100A60004EC3O003F0201002E1E01A80030020100A90004EC3O003002010026F60004003F020100010004EC3O003F02012O003B0006000D4O000D0006000100022O00E9000500063O002E5400AA004F020100AB0004EC3O004F020100064F0005004F02013O0004EC3O004F02012O002D000500023O0004EC3O004F02010004EC3O003F02010004EC3O004F02010004EC3O003002010004EC3O004F02010004EC3O00220201001237000100203O0004EC3O005D2O01002E5400AD002D030100AC0004EC3O002D03010026F63O002D030100090004EC3O002D0301002E5400AF007D020100AE0004EC3O007D0201002E5400B0007D020100B10004EC3O007D02012O003B00016O0010010200013O00122O000300B23O00122O000400B36O0002000400024O00010001000200202O0001000100084O00010002000200062O0001007D02013O0004EC3O007D02012O003B000100053O0020850001000100364O00035O00202O0003000300374O00010003000200062O0001007D02013O0004EC3O007D02012O003B000100034O003000025O00202O0002000200B44O000300043O00202O00030003002F4O00055O00202O0005000500B44O0003000500024O000300036O00010003000200062O00010078020100010004EC3O00780201002E1E01B5007D020100B60004EC3O007D02012O003B000100013O001237000200B73O001237000300B84O004C000100034O00392O016O003B00016O0010010200013O00122O000300B93O00122O000400BA6O0002000400024O00010001000200202O00010001006E4O00010002000200062O000100B602013O0004EC3O00B602012O003B0001000C3O00064F000100B602013O0004EC3O00B602012O003B00016O0034010200013O00122O000300BB3O00122O000400BC6O0002000400024O00010001000200202O00010001007E4O00010002000200262O0001009E020100490004EC3O009E02012O003B00016O00D3000200013O00122O000300BD3O00122O000400BE6O0002000400024O00010001000200202O0001000100464O00010002000200062O000100B6020100010004EC3O00B602012O003B000100053O0020850001000100364O00035O00202O00030003007B4O00010003000200062O000100B602013O0004EC3O00B602012O003B000100043O0020850001000100474O00035O00202O00030003002A4O00010003000200062O000100B602013O0004EC3O00B602012O003B000100043O0020B70001000100474O00035O00202O0003000300384O00010003000200062O000100B8020100010004EC3O00B802012O003B000100023O000E46000500B8020100010004EC3O00B80201002E1E01BF00C3020100C00004EC3O00C302012O003B000100034O003B00025O00202501020002007B2O00052O010002000200064F000100C302013O0004EC3O00C302012O003B000100013O001237000200C13O001237000300C24O004C000100034O00392O016O003B00016O0010010200013O00122O000300C33O00122O000400C46O0002000400024O00010001000200202O0001000100084O00010002000200062O000100DC02013O0004EC3O00DC02012O003B000100053O0020850001000100364O00035O00202O0003000300374O00010003000200062O000100DC02013O0004EC3O00DC02012O003B000100053O00202E2O01000100172O00052O0100020002000EC6004900DC020100010004EC3O00DC02012O003B0001000E3O00069D000100DE020100010004EC3O00DE0201002E1E01C500EB020100C60004EC3O00EB02012O003B000100034O003B00025O0020250102000200372O00052O010002000200069D000100E6020100010004EC3O00E60201002E5400C800EB020100C70004EC3O00EB02012O003B000100013O001237000200C93O001237000300CA4O004C000100034O00392O015O002E5400CC002C030100CB0004EC3O002C03012O003B00016O0010010200013O00122O000300CD3O00122O000400CE6O0002000400024O00010001000200202O0001000100084O00010002000200062O0001002C03013O0004EC3O002C03012O003B000100053O00202E2O01000100152O00052O0100020002002O0E01CF0001030100010004EC3O000103012O003B000100043O00202E2O010001002B2O00052O01000200020026132O01001C030100940004EC3O001C03012O003B000100053O00202E2O01000100152O00052O01000200020026F60001002C030100160004EC3O002C03012O003B000100053O00202E2O01000100172O00052O0100020002000EC600D0002C030100010004EC3O002C03012O003B00016O0010010200013O00122O000300D13O00122O000400D26O0002000400024O00010001000200202O0001000100464O00010002000200062O0001001C03013O0004EC3O001C03012O003B000100043O0020400001000100834O00035O00202O0003000300484O000100030002000E2O0016002C030100010004EC3O002C03012O003B000100034O00FA00025O00202O0002000200D34O000300043O00202O00030003000C00122O000500166O0003000500024O000300036O00010003000200062O0001002C03013O0004EC3O002C03012O003B000100013O001237000200D43O001237000300D54O004C000100034O00392O015O0012373O00CF3O002E5400D60001000100D70004EC3O000100010026F63O0001000100CF0004EC3O00010001001237000100013O0026F600010093030100200004EC3O00930301002E5400D80059030100D90004EC3O00590301002E1E01DA0059030100DB0004EC3O005903012O003B00026O0010010300013O00122O000400DC3O00122O000500DD6O0003000500024O00020002000300202O0002000200084O00020002000200062O0002005903013O0004EC3O005903012O003B0002000F4O003B000300044O000501020002000200064F0002005903013O0004EC3O005903012O003B000200034O007900035O00202O0003000300934O000400043O00202O00040004000C00122O000600166O0004000600024O000400046O00020004000200062O00020054030100010004EC3O00540301002E5400990059030100DE0004EC3O005903012O003B000200013O001237000300DF3O001237000400E04O004C000200044O003901025O002E5400E20092030100E10004EC3O009203012O003B00026O0010010300013O00122O000400E33O00122O000500E46O0003000500024O00020002000300202O0002000200084O00020002000200062O0002009203013O0004EC3O009203012O003B000200053O00202E0102000200152O00050102000200020026130102006F030100160004EC3O006F03012O003B000200053O00202E0102000200172O0005010200020002002O0E01180092030100020004EC3O009203012O003B000200043O0020D00002000200E54O00045O00202O0004000400934O0002000400024O000300053O00202O0003000300E54O00055O00202O0005000500934O00030005000200062O00020092030100030004EC3O009203012O003B000200104O003B000300044O000501020002000200064F0002009203013O0004EC3O009203012O003B000200034O007900035O00202O0003000300934O000400043O00202O00040004000C00122O000600166O0004000600024O000400046O00020004000200062O0002008D030100010004EC3O008D0301002E4B00E60007000100E70004EC3O009203012O003B000200013O001237000300E83O001237000400E94O004C000200044O003901025O001237000100093O002E4B00EA0004000100EA0004EC3O009703010026162O010099030100010004EC3O00990301002E4B00EB005E000100EC0004EC3O00F50301002E1E01EE00CB030100ED0004EC3O00CB03012O003B00026O0010010300013O00122O000400EF3O00122O000500F06O0003000500024O00020002000300202O0002000200464O00020002000200062O000200CB03013O0004EC3O00CB03012O003B00026O0010010300013O00122O000400F13O00122O000500F26O0003000500024O00020002000300202O0002000200084O00020002000200062O000200CB03013O0004EC3O00CB03012O003B000200023O0026CE000200CB030100F30004EC3O00CB03012O003B000200114O003B000300044O000501020002000200064F000200CB03013O0004EC3O00CB0301002E4B00F4000D000100F40004EC3O00C403012O003B000200034O007900035O00202O0003000300484O000400043O00202O00040004000C00122O000600166O0004000600024O000400046O00020004000200062O000200C6030100010004EC3O00C60301002E4B00F50007000100F60004EC3O00CB03012O003B000200013O001237000300F73O001237000400F84O004C000200044O003901026O003B00026O0010010300013O00122O000400F93O00122O000500FA6O0003000500024O00020002000300202O0002000200084O00020002000200062O000200DF03013O0004EC3O00DF03012O003B000200023O000EC6000900DF030100020004EC3O00DF03012O003B000200043O0020B70002000200FB4O00045O00202O0004000400FC4O00020004000200062O000200E3030100010004EC3O00E30301002ECA00FD00E3030100FE0004EC3O00E30301002E1E010001F4030100FF0004EC3O00F403012O003B000200034O00B100035O00122O0004002O015O0003000300044O000400043O00202O00040004000C00122O0006000D6O0004000600024O000400046O00020004000200062O000200F403013O0004EC3O00F403012O003B000200013O00123700030002012O00123700040003013O004C000200044O003901025O001237000100203O001237000200093O000612000100FC030100020004EC3O00FC030100123700020004012O00123700030005012O00063801030032030100020004EC3O003203010012373O00053O0004EC3O000100010004EC3O003203010004EC3O000100012O00BA3O00017O00873O00028O00027O0040025O00308840025O00707C40025O00608A40025O00406F40025O0095B240025O0008AC40026O008A40025O0056A240025O00A06840025O006CB140025O00389E40025O00B2A54003073O007D05397C47023203043O001A2E705703073O0049735265616479025O00B07D40025O00C06C40025O00405140025O0020614003093O00436173744379636C6503073O0053756E66697265030E3O0049735370652O6C496E52616E676503103O0053756E666972654D6F7573656F766572025O00E08240025O003DB240030E3O00AA36A572B6AD40F4B634A734EEED03083O00D4D943CB142ODF25025O00F0A14003113O009982A6C4B586ADE6B2889BC2B39FA1C6A903043O00B2DAEDC8030A3O0049734361737461626C6503063O0042752O665570030B3O004D2O6F6E6B696E466F726D025O0050A040025O00B6A240025O00209F40025O0074A44003113O00436F6E766F6B655468655370697269747303093O004973496E52616E6765026O003E40031E3O00B5BAE8C6B9BEE3EFA2BDE3EF2OA5EFC2BFA1F590BBBAE9DEBDBCE890E7ED03043O00B0D6D586026O00F03F025O00ECA940025O00207A40025O00A08040025O00809540026O000840025O00889A40025O004AA540025O00C6AF40025O00D2A340025O00C0AF4003093O0002967DAE22976EBB3403043O00DC51E21C026O001840026O002040025O0049B040025O00B8AF4003093O00537461727375726765025O00805540025O00F08240025O00BCA140025O0054A840030F4O00C183E9F9D201D287BBE5D01F95DA03063O00A773B5E29B8A03083O00CF2DE8527D78D4E703073O00A68242873C1B11026O001440026O001C40025O00206340025O002AA340025O00709840025O00CEA94003083O004D2O6F6E6669726503113O004D2O6F6E666972654D6F7573656F766572025O00E8A440025O0083B040025O00E8A040025O0094A840030F3O004945C17B364D58CB353F53468E246003053O0050242AAE15025O00B07140025O000EA640025O00708540025O0066A140025O00E8824003053O00C3BFB7C0A003073O003994CDD6B4C83603083O0042752O66446F776E03073O00436174466F726D030E3O004973496E4D656C2O6552616E676503053O005772617468025O007CA640025O00A06140030C3O0005EF34207E52F222383643A903053O0016729D555403083O00F7DF12D65BFFBAC103073O00C8A4AB73A43D96025O00A07D40025O00A4904003083O005374617266697265030F3O00ADE0025785B7E606058CA9F84314D503053O00E3DE946325025O002BB040025O00CAA840025O0092B040025O00E07640025O0068B240025O0028B140030E3O00E94733C411EE4406DE00F64B3ED203053O0065A12252B603113O00CB0257E8D4E9871AE0086AEED2F08B3AFB03083O004E886D399EBB82E2030F3O00432O6F6C646F776E52656D61696E7303113O001D30F7E73134FCC5363ACAE1372DF0E52D03043O00915E5F99025O0080564003113O00DEC21AC341BCF8F91CD07DA7F4DF1DC15D03063O00D79DAD74B52E030B3O004973417661696C61626C65030E3O0048656172744F6654686557696C64025O000EAA40025O0060A74003173O003DB18AE0CE0ABB8DCDCE3DB1B4E5D339B0CBFDCD39F4D903053O00BA55D4EB92025O00289740025O00D09640030B3O00EF8E19F032E756E48E04F303073O0038A2E1769E598E025O00A88F4003123O00510ACFA129D1523AC6A030D51C0AD7A3628C03063O00B83C65A0CF4200D2012O0012373O00014O0084000100013O0026F63O0002000100010004EC3O00020001001237000100013O000EEB0002000B000100010004EC3O000B0001002E3D0003000B000100040004EC3O000B0001002E4B00050079000100060004EC3O00820001001237000200014O0084000300033O00261601020011000100010004EC3O00110001002E540007000D000100080004EC3O000D0001001237000300013O00261601030018000100010004EC3O00180001002E15010900180001000A0004EC3O00180001002E54000C00790001000B0004EC3O00790001001237000400013O0026160104001D000100010004EC3O001D0001002E4B000D00570001000E0004EC3O007200012O003B00056O00D3000600013O00122O0007000F3O00122O000800106O0006000800024O00050005000600202O0005000500114O00050002000200062O00050029000100010004EC3O00290001002E5400120044000100130004EC3O00440001002E1E01140044000100150004EC3O004400012O003B000500023O00201C0105000500164O00065O00202O0006000600174O000700036O000800046O000900053O00202O0009000900184O000B5O00202O000B000B00174O0009000B00024O000900096O000A000B6O000C00063O00202O000C000C00194O0005000C000200062O0005003F000100010004EC3O003F0001002E4B001A00070001001B0004EC3O004400012O003B000500013O0012370006001C3O0012370007001D4O004C000500074O003901055O002E4B001E002D0001001E0004EC3O007100012O003B000500073O00064F0005007100013O0004EC3O007100012O003B000500083O00064F0005007100013O0004EC3O007100012O003B00056O0010010600013O00122O0007001F3O00122O000800206O0006000800024O00050005000600202O0005000500214O00050002000200062O0005007100013O0004EC3O007100012O003B000500093O0020B70005000500224O00075O00202O0007000700234O00050007000200062O0005005F000100010004EC3O005F0001002E5400250071000100240004EC3O00710001002E1E01260071000100270004EC3O007100012O003B0005000A4O00FA00065O00202O0006000600284O000700053O00202O00070007002900122O0009002A6O0007000900024O000700076O00050007000200062O0005007100013O0004EC3O007100012O003B000500013O0012370006002B3O0012370007002C4O004C000500074O003901055O0012370004002D3O002616010400760001002D0004EC3O00760001002E4B002E00A5FF2O002F0004EC3O001900010012370003002D3O0004EC3O007900010004EC3O001900010026160103007D0001002D0004EC3O007D0001002E1E01310012000100300004EC3O00120001001237000100323O0004EC3O008200010004EC3O001200010004EC3O008200010004EC3O000D00010026F6000100F40001002D0004EC3O00F40001001237000200013O002E54003300ED000100340004EC3O00ED00010026160102008B000100010004EC3O008B0001002E1E013500ED000100360004EC3O00ED0001002E4B0037002F000100370004EC3O00BA00012O003B00036O0010010400013O00122O000500383O00122O000600396O0004000600024O00030003000400202O0003000300114O00030002000200062O000300A300013O0004EC3O00A300012O003B0003000B3O002613010300A00001003A0004EC3O00A000012O003B0003000C3O00069D000300A3000100010004EC3O00A300012O003B0003000B3O0026CE000300A30001003B0004EC3O00A300012O003B0003000D3O00069D000300A5000100010004EC3O00A50001002E1E013C00BA0001003D0004EC3O00BA00012O003B0003000A4O003000045O00202O00040004003E4O000500053O00202O0005000500184O00075O00202O00070007003E4O0005000700024O000500056O00030005000200062O000300B5000100010004EC3O00B50001002ECA004000B50001003F0004EC3O00B50001002E4B00410007000100420004EC3O00BA00012O003B000300013O001237000400433O001237000500444O004C000300054O003901036O003B00036O0010010400013O00122O000500453O00122O000600466O0004000600024O00030003000400202O0003000300114O00030002000200062O000300CD00013O0004EC3O00CD00012O003B0003000B3O002613010300D1000100470004EC3O00D100012O003B0003000C3O00069D000300CD000100010004EC3O00CD00012O003B0003000B3O002613010300D1000100480004EC3O00D10001002ECA004A00D1000100490004EC3O00D10001002E54004C00EC0001004B0004EC3O00EC00012O003B000300023O00201C0103000300164O00045O00202O00040004004D4O000500036O0006000E6O000700053O00202O0007000700184O00095O00202O00090009004D4O0007000900024O000700076O000800096O000A00063O00202O000A000A004E4O0003000A000200062O000300E7000100010004EC3O00E70001002ECA005000E70001004F0004EC3O00E70001002E54005200EC000100510004EC3O00EC00012O003B000300013O001237000400533O001237000500544O004C000300054O003901035O0012370002002D3O002616010200F10001002D0004EC3O00F10001002E1E01560085000100550004EC3O00850001001237000100023O0004EC3O00F400010004EC3O00850001002E54005700532O0100580004EC3O00532O010026F6000100532O0100320004EC3O00532O01002E4B0059003C000100590004EC3O00342O012O003B00026O0010010300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O0002000200114O00020002000200062O000200342O013O0004EC3O00342O012O003B000200093O0020B700020002005C4O00045O00202O00040004005D4O00020004000200062O000200112O0100010004EC3O00112O012O003B000200053O00202E01020002005E0012370004003B4O001E00020004000200069D000200342O0100010004EC3O00342O012O003B0002000F3O00064F000200172O013O0004EC3O00172O012O003B0002000B3O002616010200202O01002D0004EC3O00202O012O003B000200103O00069D000200202O0100010004EC3O00202O012O003B000200113O00064F000200342O013O0004EC3O00342O012O003B0002000B3O002O0E012D00342O0100020004EC3O00342O012O003B0002000A4O00B500035O00202O00030003005F4O000400053O00202O0004000400184O00065O00202O00060006005F4O0004000600024O000400046O000500016O00020005000200062O0002002F2O0100010004EC3O002F2O01002E54006000342O0100610004EC3O00342O012O003B000200013O001237000300623O001237000400634O004C000200044O003901026O003B00026O0010010300013O00122O000400643O00122O000500656O0003000500024O00020002000300202O0002000200114O00020002000200062O000200D12O013O0004EC3O00D12O01002E54006600D12O0100670004EC3O00D12O012O003B0002000A4O00D800035O00202O0003000300684O000400053O00202O0004000400184O00065O00202O0006000600684O0004000600024O000400046O000500016O00020005000200062O000200D12O013O0004EC3O00D12O012O003B000200013O001269000300693O00122O0004006A6O000200046O00025O00044O00D12O010026F600010005000100010004EC3O00050001001237000200014O0084000300033O0026F6000200572O0100010004EC3O00572O01001237000300013O002E54006C00622O01006B0004EC3O00622O01002E54006E00622O01006D0004EC3O00622O010026F6000300622O01002D0004EC3O00622O010012370001002D3O0004EC3O00050001002E4B006F00F8FF2O006F0004EC3O005A2O010026F60003005A2O0100010004EC3O005A2O01002E4B00700041000100700004EC3O00A72O012O003B00046O0010010500013O00122O000600713O00122O000700726O0005000700024O00040004000500202O0004000400214O00040002000200062O000400A72O013O0004EC3O00A72O012O003B000400083O00064F000400A72O013O0004EC3O00A72O012O003B00046O0034010500013O00122O000600733O00122O000700746O0005000700024O00040004000500202O0004000400754O00040002000200262O000400932O01002A0004EC3O00932O012O003B00046O005D000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O0004000400754O000400020002000E2O007800932O0100040004EC3O00932O012O003B00046O00D3000500013O00122O000600793O00122O0007007A6O0005000700024O00040004000500202O00040004007B4O00040002000200062O000400A72O0100010004EC3O00A72O012O003B000400093O00208500040004005C4O00065O00202O00060006007C4O00040006000200062O000400A72O013O0004EC3O00A72O01002E1E017E00A72O01007D0004EC3O00A72O012O003B0004000A4O003B00055O00202501050005007C2O000501040002000200064F000400A72O013O0004EC3O00A72O012O003B000400013O0012370005007F3O001237000600804O004C000400064O003901045O002E1E018200CA2O0100810004EC3O00CA2O012O003B00046O0010010500013O00122O000600833O00122O000700846O0005000700024O00040004000500202O0004000400114O00040002000200062O000400CA2O013O0004EC3O00CA2O012O003B000400093O00208500040004005C4O00065O00202O0006000600234O00040006000200062O000400CA2O013O0004EC3O00CA2O012O003B0004000D3O00064F000400CA2O013O0004EC3O00CA2O01002E4B0085000D000100850004EC3O00CA2O012O003B0004000A4O003B00055O0020250105000500232O000501040002000200064F000400CA2O013O0004EC3O00CA2O012O003B000400013O001237000500863O001237000600874O004C000400064O003901045O0012370003002D3O0004EC3O005A2O010004EC3O000500010004EC3O00572O010004EC3O000500010004EC3O00D12O010004EC3O000200012O00BA3O00017O00AD3O00028O00026O00F03F025O00606540025O0053B240030C3O0053686F756C6452657475726E03113O00496E74652O72757074576974685374756E030A3O004D696768747942617368026O002040025O00408040025O00FAA040025O00E8B240025O00B4AB40025O008EA540027O0040025O0058AE40025O00089540025O0040AA4003123O00496E636170616369746174696E67526F6172025O0060AF40025O00D2AB40025O00E89040026O00A640025O00049D40025O0044A940025O00ECAD40025O00E8B04003063O0042752O66557003073O00436174466F726D030B3O00436F6D626F506F696E7473025O002C9140025O0092B24003043O004D61696D025O0007B340025O001CB340025O00C8AF40025O00709240026O001040025O00A2A340025O0006AA40026O009440030B3O00E0E812F511C4E93BF408C003053O007AAD877D9B030B3O004973417661696C61626C65025O00B2A240025O00809940025O00DCA240025O0056A240025O00188240025O00C09840025O00DAA140025O0032A04003073O00B7D40EBF3623CD03073O00A8E4A160D95F5103073O004973526561647903113O00446562752O665265667265736861626C65030D3O0053756E66697265446562752O66025O00D2A24003073O0053756E66697265030E3O0049735370652O6C496E52616E6765030F3O00C8C4205A2645DE91235D26599B837A03063O0037BBB14E3C4F025O009CA640025O00DEA540025O00108E40025O0014AD4003084O00C150E540C6922803073O00E04DAE3F8B26AF030E3O004D2O6F6E66697265446562752O66025O00B6A240025O00B2A44003083O004D2O6F6E66697265025O00EC9340025O002AAC4003103O00894E572082484A2BC44C59278A010A7803043O004EE42138026O001440025O00749540025O0088B240026O006E40025O00989240025O00D88340025O00A2A140025O005EA340025O00D8A740025O00A49E40025O00B080402O033O00015B4203053O0099532O3296025O0082AD40025O00A49140025O00849240025O0068A440025O00806840025O009EA74003043O006F77781903073O002D3D16137C13CB026O000840025O0080B140025O00588540026O00A040025O00CEA740025O00D8A540025O0080A340025O00B07940025O0034A74003093O00FD6AB31196DB6CB50603053O00E5AE1ED26303083O0042752O66446F776E025O00809440025O00D2A54003093O0053746172737572676503113O0008F98743FE282B1CE8C65CEC34375BBFDE03073O00597B8DE6318D5D025O001CB240025O0034AC4003083O00C065F71E1643E17403063O002A9311966C7003083O005374617266697265025O00E8A040025O0098AA40030F3O001CB22C6D2OE11DA36D70F0E44FF77B03063O00886FC64D1F87025O00E09040025O00CCA640026O003840025O00A09E40025O00F88340025O0026AA4003053O00351BA642B503083O00C96269C736DD8477030E3O004973496E4D656C2O6552616E6765025O0047B040025O00BEB04003053O005772617468030D3O00AE1E82350A75A1B8058D61516503073O00CCD96CE3416255026O001840025O00E2AA40025O008AAB40025O00C4AA40025O00D49B4003083O0073CCFAEB2AC94CC603063O00A03EA395854C025O0018B140025O00CCAF4003103O00DBAF0221C5DFB2086FCED7A9036F908403053O00A3B6C06D4F025O00288940025O0042B040025O0012B040025O0064B34003043O00502O6F6C03133O00576169742F502O6F6C205265736F7572636573025O00249240025O001EA440025O0028B340030D3O003324396CA87D04250B6BBD661F03063O00147240581CDC030A3O0049734361737461626C65030D3O004164617074697665537761726D025O0096AB40025O00AEAB4003133O003005D3A4ECD9AB343EC1A3F9C2B0710CD3BDF603073O00DD5161B2D498B003063O00F51A1FF4117803073O00D9A1726D956210025O00F88040025O0098AD40026O004640025O00BAA340025O0023B240025O001EAF40025O00F89140006F022O0012373O00014O0084000100023O0026F63O0066020100020004EC3O006602010026F60001002D000100020004EC3O002D0001001237000300013O000EEB0001000B000100030004EC3O000B0001002E1E01040022000100030004EC3O00220001001237000400013O0026F60004001D000100010004EC3O001D00012O003B00055O0020640005000500064O000600013O00202O00060006000700122O000700086O00050007000200122O000500053O002E2O00090007000100090004EC3O001C0001001288000500053O00064F0005001C00013O0004EC3O001C0001001288000500054O002D000500023O001237000400023O0026F60004000C000100020004EC3O000C0001001237000300023O0004EC3O002200010004EC3O000C000100261601030028000100020004EC3O00280001002E3D000B00280001000A0004EC3O00280001002E1E010C00070001000D0004EC3O000700012O003B000400024O007A0004000100010012370001000E3O0004EC3O002D00010004EC3O000700010026162O010031000100010004EC3O00310001002E54000F0071000100100004EC3O00710001001237000300013O002E4B00110015000100110004EC3O00470001000EA300010047000100030004EC3O004700012O003B00045O0020330004000400064O000500013O00202O00050005001200122O000600086O00040006000200122O000400053O002E2O00140046000100130004EC3O00460001002E1E01150046000100160004EC3O00460001001288000400053O00064F0004004600013O0004EC3O00460001001288000400054O002D000400023O001237000300023O002E5400170032000100180004EC3O003200010026160103004D000100020004EC3O004D0001002E1E011A0032000100190004EC3O003200012O003B000400033O00208500040004001B4O000600013O00202O00060006001C4O00040006000200062O0004006E00013O0004EC3O006E00012O003B000400033O00202E01040004001D2O0005010400020002002O0E2O01006E000100040004EC3O006E0001001237000400013O0026160104005E000100010004EC3O005E0001002E1E011F005A0001001E0004EC3O005A00012O003B00055O0020470005000500064O000600013O00202O00060006002000122O000700086O00050007000200122O000500053O002E2O0021006E000100220004EC3O006E0001001288000500053O00064F0005006E00013O0004EC3O006E0001001288000500054O002D000500023O0004EC3O006E00010004EC3O005A0001001237000100023O0004EC3O007100010004EC3O00320001002E540024003O0100230004EC3O003O010026F60001003O0100250004EC3O003O01001237000300013O002E4B0026005C000100260004EC3O00D200010026F6000300D2000100010004EC3O00D20001001237000400013O002E5400280081000100270004EC3O00810001000EA300020081000100040004EC3O00810001001237000300023O0004EC3O00D20001000EA30001007B000100040004EC3O007B00012O003B000500014O00D3000600043O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005008F000100010004EC3O008F0001002E1E012C00AA0001002D0004EC3O00AA0001001237000500014O0084000600073O0026F600050096000100010004EC3O00960001001237000600014O0084000700073O001237000500023O000EA300020091000100050004EC3O00910001002E4B002E3O0001002E0004EC3O00980001000EA300010098000100060004EC3O009800012O003B000800054O000D0008000100022O00E9000700083O002E1E013000AA0001002F0004EC3O00AA0001002E4B00310009000100310004EC3O00AA000100064F000700AA00013O0004EC3O00AA00012O002D000700023O0004EC3O00AA00010004EC3O009800010004EC3O00AA00010004EC3O00910001002E54003300D0000100320004EC3O00D000012O003B000500014O0010010600043O00122O000700343O00122O000800356O0006000800024O00050005000600202O0005000500364O00050002000200062O000500D000013O0004EC3O00D000012O003B000500063O0020850005000500374O000700013O00202O0007000700384O00050007000200062O000500D000013O0004EC3O00D00001002E4B00390013000100390004EC3O00D000012O003B000500074O0029000600013O00202O00060006003A4O000700063O00202O00070007003B4O000900013O00202O00090009003A4O0007000900024O000700076O00050007000200062O000500D000013O0004EC3O00D000012O003B000500043O0012370006003C3O0012370007003D4O004C000500074O003901055O001237000400023O0004EC3O007B0001002616010300D8000100020004EC3O00D80001002E3D003E00D80001003F0004EC3O00D80001002E1E01410076000100400004EC3O007600012O003B000400014O0010010500043O00122O000600423O00122O000700436O0005000700024O00040004000500202O0004000400364O00040002000200062O000400FE00013O0004EC3O00FE00012O003B000400063O0020850004000400374O000600013O00202O0006000600444O00040006000200062O000400FE00013O0004EC3O00FE0001002E54004500FE000100460004EC3O00FE00012O003B000400074O0030000500013O00202O0005000500474O000600063O00202O00060006003B4O000800013O00202O0008000800474O0006000800024O000600066O00040006000200062O000400F9000100010004EC3O00F90001002E54004900FE000100480004EC3O00FE00012O003B000400043O0012370005004A3O0012370006004B4O004C000400064O003901045O0012370001004C3O0004EC3O003O010004EC3O007600010026162O0100052O01000E0004EC3O00052O01002E54004E00422O01004D0004EC3O00422O01001237000300014O0084000400043O002E54004F00072O0100500004EC3O00072O010026F6000300072O0100010004EC3O00072O01001237000400013O002616010400102O0100010004EC3O00102O01002E540052002E2O0100510004EC3O002E2O01001237000500013O002E54005300272O0100540004EC3O00272O010026F6000500272O0100010004EC3O00272O01001237000200013O002E54005600222O0100550004EC3O00222O012O003B000600014O00D3000700043O00122O000800573O00122O000900586O0007000900024O00060006000700202O00060006002B4O00060002000200062O000600242O0100010004EC3O00242O01002E54005900262O01005A0004EC3O00262O010020C00006000200020020C0000200060001001237000500023O002E54005B00112O01005C0004EC3O00112O010026F6000500112O0100020004EC3O00112O01001237000400023O0004EC3O002E2O010004EC3O00112O010026F60004000C2O0100020004EC3O000C2O01002E1E015D003D2O01005E0004EC3O003D2O012O003B000500014O0010010600043O00122O0007005F3O00122O000800606O0006000800024O00050005000600202O00050005002B4O00050002000200062O0005003D2O013O0004EC3O003D2O010020C0000200020002001237000100613O0004EC3O00422O010004EC3O000C2O010004EC3O00422O010004EC3O00072O01002E1E016300D32O0100620004EC3O00D32O01002E1E016400D32O0100650004EC3O00D32O010026F6000100D32O01004C0004EC3O00D32O01001237000300014O0084000400043O002E1E0167004A2O0100660004EC3O004A2O010026F60003004A2O0100010004EC3O004A2O01001237000400013O002616010400532O0100010004EC3O00532O01002E1E0169009B2O0100680004EC3O009B2O012O003B000500014O0010010600043O00122O0007006A3O00122O0008006B6O0006000800024O00050005000600202O0005000500364O00050002000200062O000500772O013O0004EC3O00772O012O003B000500033O00208500050005006C4O000700013O00202O00070007001C4O00050007000200062O000500772O013O0004EC3O00772O01002E1E016D00772O01006E0004EC3O00772O012O003B000500074O0029000600013O00202O00060006006F4O000700063O00202O00070007003B4O000900013O00202O00090009006F4O0007000900024O000700076O00050007000200062O000500772O013O0004EC3O00772O012O003B000500043O001237000600703O001237000700714O004C000500074O003901055O002E540073009A2O0100720004EC3O009A2O012O003B000500014O0010010600043O00122O000700743O00122O000800756O0006000800024O00050005000600202O0005000500364O00050002000200062O0005009A2O013O0004EC3O009A2O012O003B000500083O002O0E010E009A2O0100050004EC3O009A2O012O003B000500074O00B5000600013O00202O0006000600764O000700063O00202O00070007003B4O000900013O00202O0009000900764O0007000900024O000700076O000800016O00050008000200062O000500952O0100010004EC3O00952O01002E1E0178009A2O0100770004EC3O009A2O012O003B000500043O001237000600793O0012370007007A4O004C000500074O003901055O001237000400023O002E1E017B009F2O01007C0004EC3O009F2O01002616010400A12O0100020004EC3O00A12O01002E4B007D00B0FF2O007E0004EC3O004F2O01002E54007F00CE2O0100800004EC3O00CE2O012O003B000500014O0010010600043O00122O000700813O00122O000800826O0006000800024O00050005000600202O0005000500364O00050002000200062O000500CE2O013O0004EC3O00CE2O012O003B000500033O0020B700050005006C4O000700013O00202O00070007001C4O00050007000200062O000500BA2O0100010004EC3O00BA2O012O003B000500063O00202E010500050083001237000700084O001E00050007000200069D000500CE2O0100010004EC3O00CE2O01002E1E018400CE2O0100850004EC3O00CE2O012O003B000500074O00D8000600013O00202O0006000600864O000700063O00202O00070007003B4O000900013O00202O0009000900864O0007000900024O000700076O000800016O00050008000200062O000500CE2O013O0004EC3O00CE2O012O003B000500043O001237000600873O001237000700884O004C000500074O003901055O001237000100893O0004EC3O00D32O010004EC3O004F2O010004EC3O00D32O010004EC3O004A2O01002E54008A00130201008B0004EC3O00130201000EEB008900D92O0100010004EC3O00D92O01002E1E018C00130201008D0004EC3O001302012O003B000300014O0010010400043O00122O0005008E3O00122O0006008F6O0004000600024O00030003000400202O0003000300364O00030002000200062O0003000302013O0004EC3O000302012O003B000300033O0020B700030003006C4O000500013O00202O00050005001C4O00030005000200062O000300F02O0100010004EC3O00F02O012O003B000300063O00202E010300030083001237000500084O001E00030005000200069D00030003020100010004EC3O000302012O003B000300074O0030000400013O00202O0004000400474O000500063O00202O00050005003B4O000700013O00202O0007000700474O0005000700024O000500056O00030005000200062O000300FE2O0100010004EC3O00FE2O01002E1E01900003020100910004EC3O000302012O003B000300043O001237000400923O001237000500934O004C000300054O003901036O0067000300013O00069D00030008020100010004EC3O00080201002E540095006E020100940004EC3O006E0201002E540096006E020100970004EC3O006E02012O003B000300074O003B000400013O0020250104000400982O000501030002000200064F0003006E02013O0004EC3O006E0201001237000300994O002D000300023O0004EC3O006E02010026F600010004000100610004EC3O00040001001237000300013O000EEB0002001A020100030004EC3O001A0201002E4B009A00230001009B0004EC3O003B0201002E4B009C001F0001009C0004EC3O003902012O003B000400014O0010010500043O00122O0006009D3O00122O0007009E6O0005000700024O00040004000500202O00040004009F4O00040002000200062O0004003902013O0004EC3O003902012O003B000400074O0030000500013O00202O0005000500A04O000600063O00202O00060006003B4O000800013O00202O0008000800A04O0006000800024O000600066O00040006000200062O00040034020100010004EC3O00340201002E5400A20039020100A10004EC3O003902012O003B000400043O001237000500A33O001237000600A44O004C000400064O003901045O001237000100253O0004EC3O000400010026F600030016020100010004EC3O001602012O003B000400014O0010010500043O00122O000600A53O00122O000700A66O0005000700024O00040004000500202O00040004002B4O00040002000200062O0004004802013O0004EC3O004802010020C0000200020002002E4B00A7001A000100A70004EC3O00620201000EC6000E0062020100020004EC3O006202012O003B000400063O00202E010400040083001237000600084O001E00040006000200064F0004006202013O0004EC3O00620201001237000400014O0084000500053O000EEB00010058020100040004EC3O00580201002E5400A80054020100A90004EC3O005402012O003B000600094O000D0006000100022O00E9000500063O00069D0005005F020100010004EC3O005F0201002E5400AB0062020100AA0004EC3O006202012O002D000500023O0004EC3O006202010004EC3O00540201001237000300023O0004EC3O001602010004EC3O000400010004EC3O006E0201002616012O006A020100010004EC3O006A0201002E5400AC0002000100AD0004EC3O00020001001237000100014O0084000200023O0012373O00023O0004EC3O000200012O00BA3O00017O000B3O00025O00C4AF40025O0097B04003173O0044697370652O6C61626C65467269656E646C79556E6974030B3O001A2714D5E7313523D5E73103053O0095544660A003073O004973526561647903103O004E61747572657343757265466F637573025O00B6B240025O00A0A54003153O00360719F82A031ED23B131FE8780204FE280301AD6A03043O008D58666D00223O002E5400010021000100020004EC3O002100012O003B7O00064F3O002100013O0004EC3O002100012O003B3O00013O002025014O00032O000D3O0001000200064F3O002100013O0004EC3O002100012O003B3O00024O00102O0100033O00122O000200043O00122O000300056O0001000300028O000100206O00066O0002000200064O002100013O0004EC3O002100012O003B3O00044O003B000100053O0020252O01000100072O0005012O0002000200069D3O001C000100010004EC3O001C0001002E5400080021000100090004EC3O002100012O003B3O00033O0012370001000A3O0012370002000B4O004C3O00024O0039017O00BA3O00017O00313O00028O00025O00989640025O00088140026O00F03F030B3O00DBEA59DA315EE0FB57D82003063O0036938F38B64503073O004973526561647903103O004865616C746850657263656E74616765030B3O004865616C746873746F6E65025O00408340025O00E0684003173O00DE84FE45CBDE92EB46D1D3C1FB4CD9D38FEC40C9D3C1AC03053O00BFB6E19F29025O0020B140025O00D0A14003193O0019172E478E94CA221C2F15A382C3271B2652CBB7CD3F1B275B03073O00A24B724835EBE7025O00C5B240025O0004A84003173O00BE3942F0561184354AE57B078D304DEC543283284DED5D03063O0062EC5C248233025O00D4B140025O00B0824003173O0052656672657368696E674865616C696E67506F74696F6E03253O00B61C0AA840BBBD39AA1E4CB240A9B939AA1E4CAA4A2OBC3FAA5908BF43ADBB23AD0F09FA1103083O0050C4796CDA25C8D5025O0046AD40025O0048A040025O007EAB40025O00F7B240025O0030AE40025O0062AE40025O009EB24003083O009152D87B09365CCF03083O00A1D333AA107A5D3503083O004261726B736B696E03143O00F9AFA023E8A5BB26BBAAB72EFEA0A121EDABF27A03043O00489BCED2025O00B2B04003073O00747F5A0B24477603053O0053261A346E025O00149040025O0088A440025O0040A34003073O0052656E6577616C03133O004A1229434F162B065C12214356042E505D577503043O0026387747025O00FAA840025O006EA74000B83O0012373O00014O0084000100013O002616012O0006000100010004EC3O00060001002E5400020002000100030004EC3O00020001001237000100013O0026F600010059000100040004EC3O005900012O003B00026O0010010300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002B00013O0004EC3O002B00012O003B000200023O00064F0002002B00013O0004EC3O002B00012O003B000200033O00202E0102000200082O00050102000200022O003B000300043O0006380102002B000100030004EC3O002B00012O003B000200054O0027000300063O00202O0003000300094O000400056O000600016O00020006000200062O00020026000100010004EC3O00260001002E4B000A00070001000B0004EC3O002B00012O003B000200013O0012370003000C3O0012370004000D4O004C000200044O003901026O003B000200073O00064F0002003400013O0004EC3O003400012O003B000200033O00202E0102000200082O00050102000200022O003B000300083O00062O01020003000100030004EC3O00360001002E1E010E00B70001000F0004EC3O00B700012O003B000200094O005A000300013O00122O000400103O00122O000500116O00030005000200062O0002003F000100030004EC3O003F0001002E54001200B7000100130004EC3O00B700012O003B00026O0010010300013O00122O000400143O00122O000500156O0003000500024O00020002000300202O0002000200074O00020002000200062O000200B700013O0004EC3O00B70001002E54001700B7000100160004EC3O00B700012O003B000200054O0097000300063O00202O0003000300184O000400056O000600016O00020006000200062O000200B700013O0004EC3O00B700012O003B000200013O001269000300193O00122O0004001A6O000200046O00025O00044O00B70001002E4B001B00040001001B0004EC3O005D00010026162O01005F000100010004EC3O005F0001002E1E011D00070001001C0004EC3O00070001001237000200013O002E54001F00AD0001001E0004EC3O00AD00010026F6000200AD000100010004EC3O00AD0001002E5400200086000100210004EC3O008600012O003B000300033O00202E0103000300082O00050103000200022O003B0004000A3O00063801030086000100040004EC3O008600012O003B0003000B3O00064F0003008600013O0004EC3O008600012O003B0003000C4O0010010400013O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300074O00030002000200062O0003008600013O0004EC3O008600012O003B000300054O00970004000C3O00202O0004000400244O000500066O000700016O00030007000200062O0003008600013O0004EC3O008600012O003B000300013O001237000400253O001237000500264O004C000300054O003901035O002E4B00270026000100270004EC3O00AC00012O003B000300033O00202E0103000300082O00050103000200022O003B0004000D3O000638010300AC000100040004EC3O00AC00012O003B0003000E3O00064F000300AC00013O0004EC3O00AC00012O003B0003000C4O0010010400013O00122O000500283O00122O000600296O0004000600024O00030003000400202O0003000300074O00030002000200062O000300AC00013O0004EC3O00AC0001002E4B002A00110001002A0004EC3O00AC0001002E54002C00AC0001002B0004EC3O00AC00012O003B000300054O00970004000C3O00202O00040004002D4O000500066O000700016O00030007000200062O000300AC00013O0004EC3O00AC00012O003B000300013O0012370004002E3O0012370005002F4O004C000300054O003901035O001237000200043O000EEB000400B1000100020004EC3O00B10001002E1E01300060000100310004EC3O00600001001237000100043O0004EC3O000700010004EC3O006000010004EC3O000700010004EC3O00B700010004EC3O000200012O00BA3O00017O00483O00028O00025O00405640027O004003093O006F42CFA6E4DE4758C403063O00A8262CA1C39603073O004973526561647903083O0042752O66446F776E03093O00492O6E657276617465025O00C08D40025O00C05140025O0056A240025O00707A40030F3O00492O6E657276617465506C61796572030E3O0089F28C7322FEB70285BC90773DF803083O0076E09CE2165088D603063O0042752O66557003063O00457869737473030F3O0042752O665265667265736861626C65030C3O0052656A7576656E6174696F6E025O00508940025O00808D40025O0085B340025O00A7B24003153O0052656A7576656E6174696F6E4D6F7573656F766572025O005EAB40026O002A4003173O0050EB539554EB578156E7568E7DED40834EEB199243E34903043O00E0228E39025O0055B340025O0094A740025O00089940025O00A07240026O00F03F025O005DB040025O004FB040025O000AAA40025O0068AC40030D3O004973446561644F7247686F737403093O004973496E52616E6765026O00444003093O0033640B795F038F0E7703073O00EA6013621F2B6E03133O00536F756C4F66546865466F7265737442752O6603113O0052656A7576656E6174696F6E466F63757303113O00141A58D2BA7785070B5BC8A2329907124203073O00EB667F32A7CC12025O000DB240025O005C9C40025O00F4AC40025O00B2A240025O00A49D40025O00607440025O00709B40025O003EAD4003093O0063B6FC25502355AFF103063O004E30C1954324025O004CA440025O0028A940030E3O0053776966746D656E64466F637573025O00F6A540025O001CA540030E3O002309891E553D1B8E1C01221F8D0803053O0021507EE078030A3O00DBA10FC05BFEA714D05403053O003C8CC863A4025O0062B340025O00B8AC40025O00A6AB40025O00809D40030F3O0057696C6467726F777468466F637573030F3O0090FD0822A595FB1332AAC7E6052BB203053O00C2E794644600F63O0012373O00014O0084000100013O002E4B00023O000100020004EC3O000200010026F63O0002000100010004EC3O00020001001237000100013O000EA300030057000100010004EC3O005700012O003B00026O0010010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002001A00013O0004EC3O001A00012O003B000200023O0020B70002000200074O00045O00202O0004000400084O00020004000200062O0002001C000100010004EC3O001C0001002E1E0109002B0001000A0004EC3O002B0001002E1E010C002B0001000B0004EC3O002B00012O003B000200034O0097000300043O00202O00030003000D4O000400056O000600016O00020006000200062O0002002B00013O0004EC3O002B00012O003B000200013O0012370003000E3O0012370004000F4O004C000200044O003901026O003B000200023O0020850002000200104O00045O00202O0004000400084O00020004000200062O0002004500013O0004EC3O004500012O003B000200054O000D000200010002002O0E2O010045000100020004EC3O004500012O003B000200063O00064F0002004500013O0004EC3O004500012O003B000200063O00202E0102000200112O000501020002000200064F0002004500013O0004EC3O004500012O003B000200063O0020B70002000200124O00045O00202O0004000400134O00020004000200062O00020047000100010004EC3O00470001002E54001500F5000100140004EC3O00F50001002E1E0117004F000100160004EC3O004F00012O003B000200034O003B000300043O0020250103000300182O000501020002000200069D00020051000100010004EC3O00510001002E1E011900F50001001A0004EC3O00F500012O003B000200013O0012690003001B3O00122O0004001C6O000200046O00025O00044O00F500010026162O01005B000100010004EC3O005B0001002E1E011D009F0001001E0004EC3O009F0001001237000200013O002E1E012000620001001F0004EC3O006200010026F600020062000100210004EC3O00620001001237000100213O0004EC3O009F0001002E1E0123005C000100220004EC3O005C00010026F60002005C000100010004EC3O005C0001002E540024007C000100250004EC3O007C00012O003B000300073O00064F0003007B00013O0004EC3O007B00012O003B000300073O00202E0103000300112O000501030002000200064F0003007B00013O0004EC3O007B00012O003B000300073O00202E0103000300262O000501030002000200069D0003007B000100010004EC3O007B00012O003B000300073O00202E010300030027001237000500284O001E00030005000200069D0003007C000100010004EC3O007C00012O00BA3O00014O003B00036O0010010400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O0003000300064O00030002000200062O0003009D00013O0004EC3O009D00012O003B000300084O003B000400074O000501030002000200069D0003009D000100010004EC3O009D00012O003B000300023O0020850003000300074O00055O00202O00050005002B4O00030005000200062O0003009D00013O0004EC3O009D00012O003B000300034O003B000400043O00202501040004002C2O000501030002000200064F0003009D00013O0004EC3O009D00012O003B000300013O0012370004002D3O0012370005002E4O004C000300054O003901035O001237000200213O0004EC3O005C0001002E1E013000070001002F0004EC3O00070001002E1E01320007000100310004EC3O00070001000EA300210007000100010004EC3O00070001001237000200013O0026F6000200AA000100210004EC3O00AA0001001237000100033O0004EC3O00070001002E1E013400A6000100330004EC3O00A60001002E54003500A6000100360004EC3O00A60001000EA3000100A6000100020004EC3O00A600012O003B00036O0010010400013O00122O000500373O00122O000600386O0004000600024O00030003000400202O0003000300064O00030002000200062O000300CE00013O0004EC3O00CE00012O003B000300084O003B000400074O000501030002000200064F000300CE00013O0004EC3O00CE0001002E1E013900C70001003A0004EC3O00C700012O003B000300034O003B000400043O00202501040004003B2O000501030002000200069D000300C9000100010004EC3O00C90001002E54003C00CE0001003D0004EC3O00CE00012O003B000300013O0012370004003E3O0012370005003F4O004C000300054O003901036O003B000300023O0020850003000300104O00055O00202O00050005002B4O00030005000200062O000300DF00013O0004EC3O00DF00012O003B00036O00D3000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O0003000300064O00030002000200062O000300E1000100010004EC3O00E10001002E1E014200F0000100430004EC3O00F00001002E54004500F0000100440004EC3O00F000012O003B000300034O0097000400043O00202O0004000400464O000500056O000600016O00030006000200062O000300F000013O0004EC3O00F000012O003B000300013O001237000400473O001237000500484O004C000300054O003901035O001237000200213O0004EC3O00A600010004EC3O000700010004EC3O00F500010004EC3O000200012O00BA3O00017O0073012O00028O00025O00C88E40025O005AA640025O0016AB40025O007AA940025O00D49640025O000AA24003063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O004440025O00A9B240025O009AB240025O00A09B40025O003DB240025O00F07F40025O0024AA40025O00A09640026O00F03F025O007EB040025O00309D4003093O0029A2810B0EB88D031E03043O006D7AD5E803073O004973526561647903083O0042752O66446F776E03133O00536F756C4F66546865466F7265737442752O6603103O004865616C746850657263656E74616765030E3O0053776966746D656E64466F637573025O00E4A240025O0050B14003113O00FDE0AB362OFAA73EEAB7AA35EFFBAB3EE903043O00508E97C2025O0024A840025O00805940030B3O005573655472696E6B657473025O0039B040025O00C49740025O00789B40025O00BEAA40025O00206F40025O00C05640025O0056A040025O00D4A740025O0022B140025O00489140025O0030AF40025O009AAB40025O00AAAB40025O003BB040030F3O00412O66656374696E67436F6D626174026O000840030C3O00F0A6D1C861F44E38D7A0CCD103083O006EBEC7A5BD13913D025O0004B240025O003C9C40025O000DB140025O0012A640030C3O004E617475726573566967696C03153O00D4EA63FD99C2C9D461E18CCED6AB7FED8ACBD3E57003063O00A7BA8B1788EB025O00C88340025O0066B140026O001440025O0030A240025O00907740025O005EA940030A3O00ED8053060BFFD59E4B0A03063O008DBAE93F626C031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503093O00C2FD25B031FCEF22B203053O0045918A4CD6030B3O004973417661696C61626C6503093O0043D8808FAB1B75C18D03063O007610AF2OE9DF025O00749040025O0028AC40025O0012B340025O0080AE40030F3O0057696C6467726F777468466F63757303123O009C8D39BFE999729C903DFBE68E7C878D3BBC03073O001DEBE455DB8EEB026O001840025O00709540025O002AAF40025O00FC9840025O0030AD40025O0080AD40025O00A89C40030D3O00556E697447726F7570526F6C6503043O00FC7B200603083O00E3A83A6E4D79B8CF031A3O00467269656E646C79556E6974735769746842752O66436F756E7403093O004C696665626C2O6F6D030B3O004E32BB45A3DC63AA6C28B703083O00C51B5CDF20D1BB11030A3O004973536F6C6F4D6F646503063O0042752O66557003073O00436174466F726D026O002E4003093O002F56C5FE0153CCF40E03043O009B633FA3030A3O0049734361737461626C65030F3O0042752O665265667265736861626C65030E3O004C696665626C2O6F6D466F637573025O00109440025O002EAF40025O005EA740025O0052B14003113O008ED8A788BB888DDEACCDB18183DDA883BE03063O00E4E2B1C1EDD903063O0004BC22FF31A203043O008654D043025O005BB040025O00D2A940030D3O0036AA80501CBE834F10A9885F1603043O003C73CCE603113O0054696D6553696E63654C61737443617374025O00309A40025O00A09A4003133O00452O666C6F72657363656E6365506C61796572031C3O00E23CED7CE828EE63E43FE573E27AE375E636E27EE07AFB7CE623EE6203043O0010875A8B025O00E49140025O00DEA540025O000C914003063O0077611420414603073O0018341466532E34025O008CAD40025O0016AE40030D3O00E129272800D62A32270ACA2C2403053O006FA44F4144025O00E49D4003133O00452O666C6F72657363656E6365437572736F72031C3O00C3DF85D221F8C3CA80DB20E9C3998BDB2FE6CFD7849E2DFFD4CA8CCC03063O008AA6B9E3BE4E030C3O00E87BCB315B3114CA60CC385C03073O0079AB14A5573243030D3O00E33EBF3AB610C32BBA33B701C303063O0062A658D956D9025O004CA040025O00E09F40025O00288540025O00B49240030D3O00452O666C6F72657363656E6365025O00E07F40025O0032B14003223O00F3F07F0D89CEF3E57A0488DFF3B6710487D0FFF87E4185D3F8F070138BDDE2FF760F03063O00BC2O961961E6025O00B49D40025O0058AE40025O0019B140025O00507340025O00DCAE4003083O00C3155A960D043C5603083O003E857935E37F6D4F03083O00466C6F7572697368026O001040025O00F07640025O00B2A640025O00F0B240025O00A0614003103O0016183DE0C4A7B118543AF0D7A2AB1E1303073O00C270745295B6CE027O0040025O00A4AB40025O003EAE40025O00849A40025O00D2A240030A3O0034CF7B4804D4785B17CE03043O002C63A617025O004AAE40025O0046A54003173O006BFE253234B673E03D3E0CB773E32F763BA17DFB20383403063O00C41C97495653030E3O00D4112606877F0D77E10720118C4B03083O001693634970E23878030E3O009F67EDE3889F60E3E789B174ECE603053O00EDD8158295025O007AA340025O00AEA040025O00C4AD40025O00B8A84003133O0047726F7665477561726469616E73466F637573025O003C9040025O00C8984003173O00855C5049B5F659974F4D5BB9C850910E575AB1C5578C4903073O003EE22E2O3FD0A9025O0054A340025O00B3B140025O00FAA340025O0052A440026O001C40025O001CA240025O00E8904003083O0047B45C58D962A55303053O00B615D13B2A030C3O0052656A7576656E6174696F6E026O00A340025O00A08E40030D3O00526567726F777468466F637573025O00AAA940025O00F2AA4003103O00A552C20F2EA9A35F851524BFBB5ECB1A03063O00DED737A57D41025O00688040025O00149540025O00B49040025O003AB040030C3O00154CFD1161C73947C41161CA03063O00AE5629937013025O00B9B240025O003AA240025O00EEA24003113O0043656E6172696F6E57617264466F63757303153O005805830A37061EA564178C19214F19AE5A0C84052203083O00CB3B60ED6B456F71025O0068B240025O00CAAD4003103O004E61747572657353776966746E652O7303083O001613ABF33EE7C32C03073O00B74476CC815190025O003EB340025O00A09440025O00206340025O001EA040031A3O001CA877F604951AA54FF71C8B08B97EE118914EA575E5078B00AA03063O00E26ECD10846B025O00A49B4003103O00C5C2F4CC53EED0D3CE48EDD7EEDC52F803053O00218BA380B9025O0030A440025O00C09C40025O00949640025O0068A940025O00D0804003193O002O5910CB455D17E1444F0DD8435601CD44180CDB56540DD05003043O00BE373864025O002C9440025O00AAA740025O006C9B40025O00A88540025O00908D40025O0042A140030C3O0036EAAED6275F0AEEB0CA3E5403063O003A648FC4A351025O002OAA4003113O0052656A7576656E6174696F6E466F637573025O00108B40025O0020B14003143O00084729B6294CEB0F0E4B2CAD7F41E00F164B2DA403083O006E7A2243C35F2985025O0060A740025O0068954003083O000FD1BDCF7859335A03083O00325DB4DABD172E47025O00EFB140025O00E8A740025O00D1B240025O00B8A940025O00EC964003103O00CCA15C5E4BCB5CD6E4534945D041D0A303073O0028BEC43B2C24BC03093O00492O6E657276617465026O00834003153O0052656A7576656E6174696F6E4D6F7573656F766572031A3O002E40D6A1EC78033D51D5BBF4420E2546D0B1BA75083D49D5BAFD03073O006D5C25BCD49A1D025O00A08840025O00E2AF40025O0046A240026O003D40025O007AA840025O00389A40025O009C9F40025O0006AD4003063O0077A125111DE603073O009336CF5C7E7383025O007AAB40025O0026AE40025O0071B240025O0038944003083O0024233A732F7F1F3A03063O001E6D51551D6D030D3O0049726F6E4261726B466F637573025O0008A140025O00EAA94003113O00F6635BB809DCFDED7A14BE33DFF0F67F5303073O009C9F1134D656BE03093O009AEEB3B7EEC0B3B0B703043O00DCCE8FDD025O003EA540025O00207540025O0034A840025O00509240025O0078B040025O00708940025O00AEA140025O00F0B04003083O00AF6F2219FACDC08D03073O00B2E61D4D77B8AC03073O00436F2O6D6F6E7303043O00C19F243003063O009895DE6A7B17025O00109240025O0010784003113O00D434F94D8ADF27E448F5D523F74FBCD32103053O00D5BD469623030D3O007B547A030F547A0C0F6671044903043O00682F3514025O000EAF40025O00CCB14003083O008A5E8E129E0EB14703063O006FC32CE17CDC03043O00EC672E5803063O00CBB8266013CB03063O001156586DEB0B03053O00AE59131921025O009C9B40025O000CB040025O0078A840025O0042AD40025O00789C40025O00488E4003113O0026005D40C8850A3D191246F28607261C5503073O006B4F72322E97E7030D3O0018A2B4399E30A1C50AB1B43B8703083O00A059C6D549EA59D7025O00FAB240025O004EB34003123O004164617074697665537761726D466F63757303163O004975B5EED14167B1C1D65F70A6F3854074B5F2CC467603053O00A52811D49E03043O00D1F8261803053O004685B9685303093O00284C422FCB084A4B2703053O00A96425244A025O00709B40025O00549440025O0070AD4003113O000C8EA455028BAD5F0DC7AA55018BAB5E0703043O003060E7C2025O002CA140025O00249340025O00C49940025O0018A440025O0042A840030B3O000DBA4D16D1F70735A1580103073O006E59C82C78A082030B3O005472616E7175696C69747903133O00BFD14A48525F3241A2D752064B4F3A41A2CD4C03083O002DCBA32B26232A5B025O00DC9A40025O001AA940030B3O00E697DD2D96BC5DDE8CC83A03073O0034B2E5BC43E7C9030F3O00496E6361726E6174696F6E42752O6603183O003553510AE6492A2D48441DC848312444100CF25D2F284F5703073O004341213064973C025O0048B140025O0020A940025O0078A740025O007CA64003113O00FCE8A0CEFCD4E29AD0F6ECF7A7CAFACBF403053O0093BF87CEB8025O00709840025O006CAC40025O0014A340025O00CCAF4003113O00436F6E766F6B6554686553706972697473031B3O008727A82OD758B7BB3CAEC4E740A28D3AAFD5CB13BA8129AAC8D65403073O00D2E448C6A1B83300CA052O0012373O00014O0084000100013O002E5400020002000100030004EC3O00020001002616012O0008000100010004EC3O00080001002E5400040002000100050004EC3O00020001001237000100013O002E1E01060009000100070004EC3O000900010026F600010009000100010004EC3O000900012O003B00025O00064F0002002200013O0004EC3O002200012O003B00025O00202E0102000200082O000501020002000200064F0002002200013O0004EC3O002200012O003B00025O00202E0102000200092O000501020002000200069D00020022000100010004EC3O002200012O003B00025O00202E01020002000A0012370004000B4O001E00020004000200064F0002002200013O0004EC3O00220001002E4B000C00030001000D0004EC3O002300012O00BA3O00013O002E4B000E00A60501000E0004EC3O00C905012O003B000200013O00064F000200C905013O0004EC3O00C90501001237000200014O0084000300033O0026160102002E000100010004EC3O002E0001002E54000F002A000100100004EC3O002A0001001237000300013O002E54001200C4000100110004EC3O00C400010026F6000300C4000100010004EC3O00C40001001237000400013O00261601040038000100130004EC3O00380001002E1E01140066000100150004EC3O006600012O003B000500024O0010010600033O00122O000700163O00122O000800176O0006000800024O00050005000600202O0005000500184O00050002000200062O0005006400013O0004EC3O006400012O003B000500043O00064F0005006400013O0004EC3O006400012O003B000500053O0020850005000500194O000700023O00202O00070007001A4O00050007000200062O0005006400013O0004EC3O006400012O003B000500064O003B00066O000501050002000200064F0005006400013O0004EC3O006400012O003B00055O00202E01050005001B2O00050105000200022O003B000600073O00063801050064000100060004EC3O006400012O003B000500084O003B000600093O00202501060006001C2O000501050002000200069D0005005F000100010004EC3O005F0001002E54001E00640001001D0004EC3O006400012O003B000500033O0012370006001F3O001237000700204O004C000500074O003901055O001237000300133O0004EC3O00C40001002E1E01220034000100210004EC3O00340001000EA300010034000100040004EC3O00340001001288000500233O00064F0005009600013O0004EC3O00960001001237000500014O0084000600073O0026F600050082000100010004EC3O00820001001237000800013O002E5400250079000100240004EC3O007900010026F600080079000100010004EC3O00790001001237000600014O0084000700073O001237000800133O002E1E01260072000100270004EC3O007200010026160108007F000100130004EC3O007F0001002E5400280072000100290004EC3O00720001001237000500133O0004EC3O008200010004EC3O00720001000EEB00130086000100050004EC3O00860001002E54002B006F0001002A0004EC3O006F00010026160106008A000100010004EC3O008A0001002E1E012C00860001002D0004EC3O008600012O003B0008000A4O000D0008000100022O00E9000700083O002E1E012F00960001002E0004EC3O0096000100064F0007009600013O0004EC3O009600012O002D000700023O0004EC3O009600010004EC3O008600010004EC3O009600010004EC3O006F0001002E1E013000C2000100310004EC3O00C200012O003B0005000B3O00064F000500B100013O0004EC3O00B100012O003B0005000C3O00064F000500B100013O0004EC3O00B100012O003B000500053O00202E0105000500322O000501050002000200064F000500B100013O0004EC3O00B100012O003B0005000D4O000D000500010002002O0E013300B1000100050004EC3O00B100012O003B000500024O00D3000600033O00122O000700343O00122O000800356O0006000800024O00050005000600202O0005000500184O00050002000200062O000500B3000100010004EC3O00B30001002E4B00360011000100370004EC3O00C20001002E1E013900C2000100380004EC3O00C200012O003B000500084O0097000600023O00202O00060006003A4O000700086O000900016O00050009000200062O000500C200013O0004EC3O00C200012O003B000500033O0012370006003B3O0012370007003C4O004C000500074O003901055O001237000400133O0004EC3O00340001002E1E013D00EA2O01003E0004EC3O00EA2O010026F6000300EA2O01003F0004EC3O00EA2O01001237000400014O0084000500053O000EEB000100CE000100040004EC3O00CE0001002E54004000CA000100410004EC3O00CA0001001237000500013O0026F60005000E2O0100130004EC3O000E2O01002E4B0042002A000100420004EC3O00FB00012O003B000600024O0010010700033O00122O000800433O00122O000900446O0007000900024O00060006000700202O0006000600184O00060002000200062O000600FB00013O0004EC3O00FB00012O003B0006000E3O00064F000600FB00013O0004EC3O00FB00012O003B0006000F3O00200D0106000600454O000700106O000800116O00060008000200062O000600FB00013O0004EC3O00FB00012O003B000600024O0010010700033O00122O000800463O00122O000900476O0007000900024O00060006000700202O0006000600484O00060002000200062O000600FD00013O0004EC3O00FD00012O003B000600024O0010010700033O00122O000800493O00122O0009004A6O0007000900024O00060006000700202O0006000600184O00060002000200062O000600FD00013O0004EC3O00FD0001002E54004C000C2O01004B0004EC3O000C2O01002E1E014E000C2O01004D0004EC3O000C2O012O003B000600084O0097000700093O00202O00070007004F4O000800086O000900016O00060009000200062O0006000C2O013O0004EC3O000C2O012O003B000600033O001237000700503O001237000800514O004C000600084O003901065O001237000300523O0004EC3O00EA2O01002E54005300122O0100540004EC3O00122O01002616010500142O0100010004EC3O00142O01002E4B005500BDFF2O00560004EC3O00CF0001002E1E0158006F2O0100570004EC3O006F2O012O003B000600053O00202E0106000600322O000501060002000200064F0006006F2O013O0004EC3O006F2O012O003B000600123O00064F0006006F2O013O0004EC3O006F2O012O003B0006000F3O0020E70006000600594O00078O0006000200024O000700033O00122O0008005A3O00122O0009005B6O00070009000200062O0006006F2O0100070004EC3O006F2O012O003B0006000F3O00206300060006005C4O000700023O00202O00070007005D4O00088O000900016O00060009000200262O0006006F2O0100130004EC3O006F2O012O003B000600024O00D3000700033O00122O0008005E3O00122O0009005F6O0007000900024O00060006000700202O0006000600484O00060002000200062O000600402O0100010004EC3O00402O012O003B0006000F3O0020250106000600602O000D00060001000200064F0006006F2O013O0004EC3O006F2O012O003B00065O0020B200060006001B4O0006000200024O000700136O000800146O000900053O00202O0009000900614O000B00023O00202O000B000B00624O0009000B6O00083O00020020330108000800632O006C0007000700080006380106006F2O0100070004EC3O006F2O012O003B000600024O0010010700033O00122O000800643O00122O000900656O0007000900024O00060006000700202O0006000600664O00060002000200062O0006006F2O013O0004EC3O006F2O012O003B00065O0020850006000600674O000800023O00202O00080008005D4O00060008000200062O0006006F2O013O0004EC3O006F2O012O003B000600084O003B000700093O0020250107000700682O000501060002000200069D0006006A2O0100010004EC3O006A2O01002ECA006A006A2O0100690004EC3O006A2O01002E54006C006F2O01006B0004EC3O006F2O012O003B000600033O0012370007006D3O0012370008006E4O004C000600084O003901066O003B000600154O005A000700033O00122O0008006F3O00122O000900706O00070009000200062O000600782O0100070004EC3O00782O01002E1E017100952O0100720004EC3O00952O012O003B000600053O00202E0106000600322O000501060002000200064F000600872O013O0004EC3O00872O012O003B000600024O005D000700033O00122O000800733O00122O000900746O0007000900024O00060006000700202O0006000600754O000600020002000E2O006300892O0100060004EC3O00892O01002E4B0076005F000100770004EC3O00E62O012O003B000600084O003B000700093O0020250107000700782O000501060002000200064F000600E62O013O0004EC3O00E62O012O003B000600033O001269000700793O00122O0008007A6O000600086O00065O00044O00E62O01002E1E017B00BF2O01007C0004EC3O00BF2O01002E4B007D00280001007D0004EC3O00BF2O012O003B000600154O0096000700033O00122O0008007E3O00122O0009007F6O00070009000200062O000600BF2O0100070004EC3O00BF2O01002E54008000E62O0100810004EC3O00E62O012O003B000600053O00202E0106000600322O000501060002000200064F000600E62O013O0004EC3O00E62O012O003B000600024O0039000700033O00122O000800823O00122O000900836O0007000900024O00060006000700202O0006000600754O000600020002000E2O006300E62O0100060004EC3O00E62O01002E4B00840035000100840004EC3O00E62O012O003B000600084O003B000700093O0020250107000700852O000501060002000200064F000600E62O013O0004EC3O00E62O012O003B000600033O001269000700863O00122O000800876O000600086O00065O00044O00E62O012O003B000600154O0096000700033O00122O000800883O00122O000900896O00070009000200062O000600E62O0100070004EC3O00E62O012O003B000600053O00202E0106000600322O000501060002000200064F000600D52O013O0004EC3O00D52O012O003B000600024O005D000700033O00122O0008008A3O00122O0009008B6O0007000900024O00060006000700202O0006000600754O000600020002000E2O006300D72O0100060004EC3O00D72O01002E54008C00E62O01008D0004EC3O00E62O01002E1E018E00DF2O01008F0004EC3O00DF2O012O003B000600084O003B000700023O0020250107000700902O000501060002000200069D000600E12O0100010004EC3O00E12O01002E4B00910007000100920004EC3O00E62O012O003B000600033O001237000700933O001237000800944O004C000600084O003901065O001237000500133O0004EC3O00CF00010004EC3O00EA2O010004EC3O00CA00010026F600030091020100130004EC3O00910201001237000400014O0084000500053O002616010400F22O0100010004EC3O00F22O01002E1E019600EE2O0100950004EC3O00EE2O01001237000500013O002E1E01980030020100970004EC3O003002010026F600050030020100130004EC3O00300201002E4B00990037000100990004EC3O002E02012O003B000600053O00202E0106000600322O000501060002000200064F0006002E02013O0004EC3O002E02012O003B0006000C3O00064F0006002E02013O0004EC3O002E02012O003B000600024O0010010700033O00122O0008009A3O00122O0009009B6O0007000900024O00060006000700202O0006000600184O00060002000200062O0006002E02013O0004EC3O002E02012O003B000600053O0020850006000600194O000800023O00202O00080008009C4O00060008000200062O0006002E02013O0004EC3O002E02012O003B0006000D4O000D000600010002002O0E019D002E020100060004EC3O002E02012O003B0006000F3O00200D0106000600454O000700166O000800176O00060008000200062O0006002E02013O0004EC3O002E0201002E54009E002E0201009F0004EC3O002E0201002E1E01A1002E020100A00004EC3O002E02012O003B000600084O0097000700023O00202O00070007009C4O000800096O000A00016O0006000A000200062O0006002E02013O0004EC3O002E02012O003B000600033O001237000700A23O001237000800A34O004C000600084O003901065O001237000300A43O0004EC3O00910201002E5400A500F32O0100A60004EC3O00F32O01000EA3000100F32O0100050004EC3O00F32O01002E5400A7005D020100A80004EC3O005D02012O003B000600053O0020850006000600614O000800023O00202O00080008001A4O00060008000200062O0006005D02013O0004EC3O005D02012O003B000600024O0010010700033O00122O000800A93O00122O000900AA6O0007000900024O00060006000700202O0006000600184O00060002000200062O0006005D02013O0004EC3O005D02012O003B0006000F3O00200D0106000600454O000700186O000800196O00060008000200062O0006005D02013O0004EC3O005D02012O003B000600084O0027000700093O00202O00070007004F4O000800086O000900016O00060009000200062O00060058020100010004EC3O00580201002E1E01AB005D020100AC0004EC3O005D02012O003B000600033O001237000700AD3O001237000800AE4O004C000600084O003901066O003B0006001A3O00064F0006007B02013O0004EC3O007B02012O003B000600024O0010010700033O00122O000800AF3O00122O000900B06O0007000900024O00060006000700202O0006000600184O00060002000200062O0006007B02013O0004EC3O007B02012O003B000600024O0039000700033O00122O000800B13O00122O000900B26O0007000900024O00060006000700202O0006000600754O000600020002000E2O003F007B020100060004EC3O007B02012O003B0006000F3O00201B0006000600454O0007001B6O0008001C6O00060008000200062O0006007D020100010004EC3O007D0201002E5400B3008D020100B40004EC3O008D0201002E5400B60086020100B50004EC3O008602012O003B000600084O006D000700093O00202O0007000700B74O000800096O00060009000200062O00060088020100010004EC3O00880201002E1E01B9008D020100B80004EC3O008D02012O003B000600033O001237000700BA3O001237000800BB4O004C000600084O003901065O001237000500133O0004EC3O00F32O010004EC3O009102010004EC3O00EE2O01002E1E01BC00C5020100BD0004EC3O00C50201002E1E01BE00C5020100BF0004EC3O00C502010026F6000300C5020100C00004EC3O00C50201002E5400C200C9050100C10004EC3O00C905012O003B000400024O0010010500033O00122O000600C33O00122O000700C46O0005000700024O00040004000500202O0004000400664O00040002000200062O000400C905013O0004EC3O00C905012O003B0004001D3O00064F000400C905013O0004EC3O00C905012O003B00045O0020850004000400614O000600023O00202O0006000600C54O00040006000200062O000400C905013O0004EC3O00C905012O003B00045O00202E01040004001B2O00050104000200022O003B0005001E3O000638010400C9050100050004EC3O00C90501002E5400C700C9050100C60004EC3O00C905012O003B000400084O0027000500093O00202O0005000500C84O000600066O000700016O00040007000200062O000400BF020100010004EC3O00BF0201002E1E01CA00C9050100C90004EC3O00C905012O003B000400033O001269000500CB3O00122O000600CC6O000400066O00045O00044O00C90501000EEB003300C9020100030004EC3O00C90201002E5400CE0040030100CD0004EC3O00400301001237000400013O002E4B00CF004B000100CF0004EC3O00150301002616010400D0020100010004EC3O00D00201002E1E01D00015030100B50004EC3O001503012O003B000500024O0010010600033O00122O000700D13O00122O000800D26O0006000800024O00050005000600202O0005000500184O00050002000200062O000500E302013O0004EC3O00E302012O003B0005001F3O00064F000500E302013O0004EC3O00E302012O003B00055O00202E01050005001B2O00050105000200022O003B000600203O00062O01050003000100060004EC3O00E50201002E5400D300F2020100D40004EC3O00F20201002E4B00D5000D000100D50004EC3O00F202012O003B000500084O003B000600093O0020250106000600D62O000501050002000200064F000500F202013O0004EC3O00F202012O003B000500033O001237000600D73O001237000700D84O004C000500074O003901055O002E1E01DA0005030100D90004EC3O000503012O003B000500053O0020850005000500614O000700023O00202O0007000700DB4O00050007000200062O0005000503013O0004EC3O000503012O003B000500024O00D3000600033O00122O000700DC3O00122O000800DD6O0006000800024O00050005000600202O0005000500664O00050002000200062O00050007030100010004EC3O00070301002E5400DE0014030100DF0004EC3O001403012O003B000500084O003B000600093O0020250106000600C82O000501050002000200069D0005000F030100010004EC3O000F0301002E4B00E00007000100E10004EC3O001403012O003B000500033O001237000600E23O001237000700E34O004C000500074O003901055O001237000400133O002E4B00E400B5FF2O00E40004EC3O00CA02010026F6000400CA020100130004EC3O00CA02012O003B000500024O0010010600033O00122O000700E53O00122O000800E66O0006000800024O00050005000600202O0005000500184O00050002000200062O0005002C03013O0004EC3O002C03012O003B000500213O00064F0005002C03013O0004EC3O002C03012O003B00055O00202E01050005001B2O00050105000200022O003B000600223O00062O01050005000100060004EC3O00300301002E1501E70030030100420004EC3O00300301002E1E01E8003D030100E90004EC3O003D03012O003B000500084O003B000600023O0020250106000600DB2O000501050002000200069D00050038030100010004EC3O00380301002E1E01EA003D030100EB0004EC3O003D03012O003B000500033O001237000600EC3O001237000700ED4O004C000500074O003901055O0012370003009D3O0004EC3O004003010004EC3O00CA020100261601030044030100520004EC3O00440301002E5400EF00D3030100EE0004EC3O00D30301001237000400013O0026160104004B030100130004EC3O004B0301002ECA00F0004B030100F10004EC3O004B0301002E4B00F2002D000100F30004EC3O007603012O003B000500024O0010010600033O00122O000700F43O00122O000800F56O0006000800024O00050005000600202O0005000500664O00050002000200062O0005007403013O0004EC3O007403012O003B000500233O00064F0005007403013O0004EC3O007403012O003B00055O0020850005000500674O000700023O00202O0007000700C54O00050007000200062O0005007403013O0004EC3O007403012O003B00055O00202E01050005001B2O00050105000200022O003B000600243O00063801050074030100060004EC3O00740301002E4B00F60008000100F60004EC3O006D03012O003B000500084O003B000600093O0020250106000600F72O000501050002000200069D0005006F030100010004EC3O006F0301002E5400F90074030100F80004EC3O007403012O003B000500033O001237000600FA3O001237000700FB4O004C000500074O003901055O001237000300C03O0004EC3O00D303010026160104007A030100010004EC3O007A0301002E1E01FC0045030100FD0004EC3O004503012O003B000500024O0010010600033O00122O000700FE3O00122O000800FF6O0006000800024O00050005000600202O0005000500664O00050002000200062O0005008D03013O0004EC3O008D03012O003B000500253O00064F0005008D03013O0004EC3O008D03012O003B00055O00202E01050005001B2O00050105000200022O003B000600263O00062O01050004000100060004EC3O009003010012370005002O012O000EC62O0001A5030100050004EC3O00A5030100123700050002012O00123700060002012O0006AA000500A5030100060004EC3O00A503012O003B000500084O0027000600093O00202O0006000600C84O000700076O000800016O00050008000200062O000500A0030100010004EC3O00A0030100123700050003012O00123700060004012O000658000500A5030100060004EC3O00A503012O003B000500033O00123700060005012O00123700070006013O004C000500074O003901056O003B000500053O00208F0005000500614O000700023O00122O00080007015O0007000700084O00050007000200062O000500C103013O0004EC3O00C103012O003B000500274O000D000500010002001237000600013O000658000600C1030100050004EC3O00C103012O003B000500283O00064F000500C103013O0004EC3O00C103012O003B000500283O00202E0105000500082O000501050002000200064F000500C103013O0004EC3O00C103012O003B000500283O0020B70005000500674O000700023O00202O0007000700C54O00050007000200062O000500C5030100010004EC3O00C50301001237000500FD3O00123700060008012O0006AA000500D1030100060004EC3O00D103012O003B000500084O0052000600093O00122O00070009015O0006000600074O00050002000200062O000500D103013O0004EC3O00D103012O003B000500033O0012370006000A012O0012370007000B013O004C000500074O003901055O001237000400133O0004EC3O004503010012370004000C012O0012370005000D012O00065800040019050100050004EC3O001905010012370004009D3O0006AA00030019050100040004EC3O00190501001237000400013O0012370005000E012O0012370006000F012O000658000600C3040100050004EC3O00C3040100123700050010012O00123700060011012O000638010600C3040100050004EC3O00C30401001237000500013O0006AA000400C3040100050004EC3O00C3040100123700050012012O00123700060013012O0006580005001A040100060004EC3O001A04012O003B000500294O0096000600033O00122O00070014012O00122O00080015015O00060008000200062O0005001A040100060004EC3O001A040100123700050016012O00123700060017012O000658000500A3040100060004EC3O00A3040100123700050018012O00123700060019012O000658000600A3040100050004EC3O00A304012O003B000500024O0010010600033O00122O0007001A012O00122O0008001B015O0006000800024O00050005000600202O0005000500184O00050002000200062O000500A304013O0004EC3O00A304012O003B00055O00202E01050005001B2O00050105000200022O003B0006002A3O000638010500A3040100060004EC3O00A304012O003B000500084O0028010600093O00122O0007001C015O0006000600074O00050002000200062O00050014040100010004EC3O001404010012370005001D012O0012370006001E012O0006AA000500A3040100060004EC3O00A304012O003B000500033O0012690006001F012O00122O00070020015O000500076O00055O00044O00A304012O003B000500294O005A000600033O00122O00070021012O00122O00080022015O00060008000200062O00050029040100060004EC3O0029040100123700050023012O00123700060024012O00061200050029040100060004EC3O0029040100123700050025012O00123700060026012O0006380105005C040100060004EC3O005C040100123700050027012O00123700060028012O000638010600A3040100050004EC3O00A3040100123700050029012O0012370006002A012O000638010500A3040100060004EC3O00A304012O003B000500024O0010010600033O00122O0007002B012O00122O0008002C015O0006000800024O00050005000600202O0005000500184O00050002000200062O000500A304013O0004EC3O00A304012O003B00055O00202E01050005001B2O00050105000200022O003B0006002A3O000638010500A3040100060004EC3O00A304010012880005002D012O00200B0105000500594O00068O0005000200024O000600033O00122O0007002E012O00122O0008002F015O00060008000200062O000500A3040100060004EC3O00A304012O003B000500084O0028010600093O00122O0007001C015O0006000600074O00050002000200062O00050056040100010004EC3O0056040100123700050030012O00123700060031012O000638010500A3040100060004EC3O00A304012O003B000500033O00126900060032012O00122O00070033015O000500076O00055O00044O00A304012O003B000500294O005A000600033O00122O00070034012O00122O00080035015O00060008000200062O00050067040100060004EC3O0067040100123700050036012O00123700060037012O0006AA000500A3040100060004EC3O00A304012O003B000500024O0010010600033O00122O00070038012O00122O00080039015O0006000800024O00050005000600202O0005000500184O00050002000200062O0005008B04013O0004EC3O008B04012O003B00055O00202E01050005001B2O00050105000200022O003B0006002A3O0006380105008B040100060004EC3O008B04010012880005002D012O0020E70005000500594O00068O0005000200024O000600033O00122O0007003A012O00122O0008003B015O00060008000200062O0005008F040100060004EC3O008F04010012880005002D012O0020E70005000500594O00068O0005000200024O000600033O00122O0007003C012O00122O0008003D015O00060008000200062O0005008F040100060004EC3O008F04010012370005003E012O0012370006003F012O000658000600A3040100050004EC3O00A3040100123700050040012O00123700060041012O0006580005009A040100060004EC3O009A04012O003B000500084O0028010600093O00122O0007001C015O0006000600074O00050002000200062O0005009E040100010004EC3O009E040100123700050042012O00123700060043012O000658000500A3040100060004EC3O00A304012O003B000500033O00123700060044012O00123700070045013O004C000500074O003901056O003B000500024O0010010600033O00122O00070046012O00122O00080047015O0006000800024O00050005000600202O0005000500664O00050002000200062O000500B204013O0004EC3O00B204012O003B000500053O00202E0105000500322O000501050002000200069D000500B6040100010004EC3O00B6040100123700050048012O00123700060049012O0006AA000500C2040100060004EC3O00C204012O003B000500084O0052000600093O00122O0007004A015O0006000600074O00050002000200062O000500C204013O0004EC3O00C204012O003B000500033O0012370006004B012O0012370007004C013O004C000500074O003901055O001237000400133O001237000500133O0006AA000400DB030100050004EC3O00DB03012O003B000500053O00202E0105000500322O000501050002000200064F0005000305013O0004EC3O000305012O003B0005002B3O00064F0005000305013O0004EC3O000305012O003B0005000F3O00200B0105000500594O00068O0005000200024O000600033O00122O0007004D012O00122O0008004E015O00060008000200062O00050003050100060004EC3O000305012O003B0005000F3O00200801050005005C4O000600023O00202O00060006005D4O000700016O00088O00050008000200122O000600133O00062O00050003050100060004EC3O000305012O003B00055O0020CC00050005001B4O0005000200024O0006002C6O000700146O000800053O00202O0008000800614O000A00023O00202O000A000A00624O0008000A6O00073O000200122O000800636O0007000700084O00060006000700062O00050003050100060004EC3O000305012O003B000500024O0010010600033O00122O0007004F012O00122O00080050015O0006000800024O00050005000600202O0005000500664O00050002000200062O0005000305013O0004EC3O000305012O003B00055O0020B70005000500674O000700023O00202O00070007005D4O00050007000200062O00050007050100010004EC3O0007050100123700050051012O00123700060052012O00065800050016050100060004EC3O0016050100123700050053012O00123700060053012O0006AA00050016050100060004EC3O001605012O003B000500084O003B000600093O0020250106000600682O000501050002000200064F0005001605013O0004EC3O001605012O003B000500033O00123700060054012O00123700070055013O004C000500074O003901055O0012370003003F3O0004EC3O001905010004EC3O00DB030100123700040056012O00123700050057012O0006380105002F000100040004EC3O002F000100123700040058012O00123700050059012O0006380104002F000100050004EC3O002F0001001237000400A43O0006AA0004002F000100030004EC3O002F0001001237000400013O001237000500013O0006AA00040087050100050004EC3O008705010012370005005A012O0012370006005A012O0006AA00050053050100060004EC3O005305012O003B000500053O00202E0105000500322O000501050002000200064F0005005305013O0004EC3O005305012O003B0005000C3O00064F0005005305013O0004EC3O005305012O003B000500024O0010010600033O00122O0007005B012O00122O0008005C015O0006000800024O00050005000600202O0005000500184O00050002000200062O0005005305013O0004EC3O005305012O003B0005000F3O00200D0105000500454O0006002D6O0007002E6O00050007000200062O0005005305013O0004EC3O005305012O003B000500084O0093000600023O00122O0007005D015O0006000600074O000700076O000800016O00050008000200062O0005005305013O0004EC3O005305012O003B000500033O0012370006005E012O0012370007005F013O004C000500074O003901055O00123700050060012O00123700060061012O00063801050086050100060004EC3O008605012O003B000500053O00202E0105000500322O000501050002000200064F0005008605013O0004EC3O008605012O003B0005000C3O00064F0005008605013O0004EC3O008605012O003B000500024O0010010600033O00122O00070062012O00122O00080063015O0006000800024O00050005000600202O0005000500184O00050002000200062O0005008605013O0004EC3O008605012O003B000500053O00208F0005000500614O000700023O00122O00080064015O0007000700084O00050007000200062O0005008605013O0004EC3O008605012O003B0005000F3O00200D0105000500454O0006002F6O000700306O00050007000200062O0005008605013O0004EC3O008605012O003B000500084O0093000600023O00122O0007005D015O0006000600074O000700076O000800016O00050008000200062O0005008605013O0004EC3O008605012O003B000500033O00123700060065012O00123700070066013O004C000500074O003901055O001237000400133O001237000500133O00061200040092050100050004EC3O0092050100123700050067012O00123700060068012O00062O01050005000100060004EC3O0092050100123700050069012O0012370006006A012O00063801050025050100060004EC3O002505012O003B000500053O00202E0105000500322O000501050002000200064F000500AB05013O0004EC3O00AB05012O003B0005000C3O00064F000500AB05013O0004EC3O00AB05012O003B000500024O0010010600033O00122O0007006B012O00122O0008006C015O0006000800024O00050005000600202O0005000500184O00050002000200062O000500AB05013O0004EC3O00AB05012O003B0005000F3O00201B0005000500454O000600316O000700326O00050007000200062O000500AF050100010004EC3O00AF05010012370005006D012O0012370006006E012O000658000600BF050100050004EC3O00BF05010012370005006F012O00123700060070012O000658000500BF050100060004EC3O00BF05012O003B000500084O0052000600023O00122O00070071015O0006000600074O00050002000200062O000500BF05013O0004EC3O00BF05012O003B000500033O00123700060072012O00123700070073013O004C000500074O003901055O001237000300333O0004EC3O002F00010004EC3O002505010004EC3O002F00010004EC3O00C905010004EC3O002A00010004EC3O00C905010004EC3O000900010004EC3O00C905010004EC3O000200012O00BA3O00017O00693O00028O00026O00F03F025O00A3B140025O00B4B240025O0044A840025O0072A840026O00AF40025O00F09040025O00804740025O00489440025O0029B040025O003C9C40025O00B07B40025O00D09640027O0040025O0094A140025O0012B040025O0026A540025O00E06F40025O00607040025O0061B040025O001CAF40025O00F4B240025O0041B240025O00DEA640025O00B6A740030F3O0048616E646C65412O666C6963746564030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572026O004440025O0020A740025O00C08A40025O0053B140025O00A49E40026O00084003093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572025O0058AB40025O00B88340026O001040025O00B09540025O00C89C40025O00E8AE40030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F766572025O00BAAE40026O007A40025O0096A040025O00689740025O00806F40025O00B8874003083O00526567726F77746803113O00526567726F7774684D6F7573656F766572025O00488740025O00EAA340025O0074A540025O00EDB240025O00AEA240025O003EA440030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F766572025O00EC9E40025O00109E40025O00408A40025O00FCB040025O00E7B140025O0093B140025O00AC9240025O009C9440025O00ACAA40025O0096A140025O007DB040025O0042B040025O0034A640025O00E3B240030D3O00546172676574497356616C6964025O00549640025O0006AE40025O0008A640026O006C40025O008AA440025O00CAA740025O00EEAA40025O00B2A640025O005EAD40025O00C49040025O0024AE40025O00C09B40025O0002A640025O00088040025O0054AA40025O0072A940025O00E08640025O00ECA340025O0022A840025O00806440025O00BC9640025O00E4AE40025O00FAA240025O003C9240025O00C06240025O00F2A840025O009CAD40025O00F07C40025O0046AB400036012O0012373O00014O0084000100023O002616012O0006000100020004EC3O00060001002E4B000300292O0100040004EC3O002D2O01000EA300020021000100010004EC3O00210001001237000300013O002E1E0105001A000100060004EC3O001A00010026160103000F000100010004EC3O000F0001002E1E0107001A000100080004EC3O001A00012O003B00046O000D0004000100022O00E9000200043O002E54000900190001000A0004EC3O0019000100069D00020018000100010004EC3O00180001002E54000B00190001000C0004EC3O001900012O002D000200023O001237000300023O0026160103001E000100020004EC3O001E0001002E1E010E00090001000D0004EC3O000900010012370001000F3O0004EC3O002100010004EC3O00090001002E1E011000C9000100110004EC3O00C900010026F6000100C9000100010004EC3O00C90001001237000300013O0026160103002A000100020004EC3O002A0001002E540012002C000100130004EC3O002C0001001237000100023O0004EC3O00C90001002E5400140026000100150004EC3O00260001002E1E01160026000100170004EC3O002600010026F600030026000100010004EC3O00260001002E4B00180076000100180004EC3O00A800012O003B000400013O00064F000400A800013O0004EC3O00A80001001237000400013O002E540019004D0001001A0004EC3O004D00010026F60004004D000100020004EC3O004D00012O003B000500023O0020C900050005001B4O000600033O00202O00060006001C4O000700043O00202O00070007001D00122O0008001E6O0005000800024O000200053O002E2O0020004C0001001F0004EC3O004C0001002E1E0122004C000100210004EC3O004C000100064F0002004C00013O0004EC3O004C00012O002D000200023O0012370004000F3O0026F60004005E000100230004EC3O005E00012O003B000500023O0020ED00050005001B4O000600033O00202O0006000600244O000700043O00202O00070007002500122O0008001E6O0005000800024O000200053O00062O0002005C000100010004EC3O005C0001002E1E0126005D000100270004EC3O005D00012O002D000200023O001237000400283O002E4B00290018000100290004EC3O00760001002E54002A00760001002B0004EC3O007600010026F600040076000100280004EC3O007600012O003B000500023O00202201050005001B4O000600033O00202O00060006002C4O000700043O00202O00070007002D00122O0008001E6O000900016O0005000900024O000200053O002E2O002F00A80001002E0004EC3O00A80001002E1E013100A8000100300004EC3O00A8000100064F000200A800013O0004EC3O00A800012O002D000200023O0004EC3O00A80001000EEB000F007A000100040004EC3O007A0001002E540033008A000100320004EC3O008A00012O003B000500023O0020D500050005001B4O000600033O00202O0006000600344O000700043O00202O00070007003500122O0008001E6O000900016O0005000900024O000200053O002E2O00360089000100370004EC3O0089000100064F0002008900013O0004EC3O008900012O002D000200023O001237000400233O0026F600040038000100010004EC3O00380001001237000500013O002E1E01380093000100390004EC3O009300010026F600050093000100020004EC3O00930001001237000400023O0004EC3O00380001002E54003A008D0001003B0004EC3O008D00010026F60005008D000100010004EC3O008D00012O003B000600023O0020ED00060006001B4O000700033O00202O00070007003C4O000800043O00202O00080008003D00122O0009001E6O0006000900024O000200063O00062O000200A4000100010004EC3O00A40001002E4B003E00030001003F0004EC3O00A500012O002D000200023O001237000500023O0004EC3O008D00010004EC3O003800012O003B000400053O00069D000400AE000100010004EC3O00AE00012O003B000400063O00064F000400B100013O0004EC3O00B100012O003B000400073O00069D000400B3000100010004EC3O00B30001002E54004100C7000100400004EC3O00C70001001237000400014O0084000500053O002E54004300B9000100420004EC3O00B90001002616010400BB000100010004EC3O00BB0001002E1E014500B5000100440004EC3O00B500012O003B000600084O000D0006000100022O00E9000500063O002E54004700C7000100460004EC3O00C70001002E54004900C7000100480004EC3O00C7000100064F000500C700013O0004EC3O00C700012O002D000500023O0004EC3O00C700010004EC3O00B50001001237000300023O0004EC3O002600010026F60001003O0100230004EC3O003O01002E54004A00D00001004B0004EC3O00D0000100064F000200D000013O0004EC3O00D000012O002D000200024O003B000300023O00202501030003004C2O000D00030001000200064F000300D800013O0004EC3O00D800012O003B000300093O00069D000300DA000100010004EC3O00DA0001002E1E014E00352O01004D0004EC3O00352O01001237000300014O0084000400053O002E54005000F60001004F0004EC3O00F60001002616010300E2000100020004EC3O00E20001002E54005200F6000100510004EC3O00F60001002E1E015400E6000100530004EC3O00E60001002616010400E8000100010004EC3O00E80001002E54005500E2000100560004EC3O00E20001001237000500013O0026F6000500E9000100010004EC3O00E900012O003B0006000A4O000D0006000100022O00E9000200063O00064F000200352O013O0004EC3O00352O012O002D000200023O0004EC3O00352O010004EC3O00E900010004EC3O00352O010004EC3O00E200010004EC3O00352O01002E1E015800DC000100570004EC3O00DC0001002616010300FC000100010004EC3O00FC0001002E54005900DC0001005A0004EC3O00DC0001001237000400014O0084000500053O001237000300023O0004EC3O00DC00010004EC3O00352O010026F6000100060001000F0004EC3O00060001001237000300013O002E1E015C000C2O01005B0004EC3O000C2O010026160103000A2O0100020004EC3O000A2O01002E1E015E000C2O01005D0004EC3O000C2O01001237000100233O0004EC3O00060001002E54006000042O01005F0004EC3O00042O010026F6000300042O0100010004EC3O00042O01002E1E016100262O0100620004EC3O00262O012O003B0004000B3O00064F000400262O013O0004EC3O00262O01001237000400013O002E54006400162O0100630004EC3O00162O01002E4B006500FEFF2O00650004EC3O00162O010026F6000400162O0100010004EC3O00162O012O003B0005000C4O000D0005000100022O00E9000200053O002E1E016600262O0100670004EC3O00262O0100064F000200262O013O0004EC3O00262O012O002D000200023O0004EC3O00262O010004EC3O00162O012O003B0004000D4O000D0004000100022O00E9000200043O001237000300023O0004EC3O00042O010004EC3O000600010004EC3O00352O01002616012O00312O0100010004EC3O00312O01002E4B006800D3FE2O00690004EC3O00020001001237000100014O0084000200023O0012373O00023O0004EC3O000200012O00BA3O00017O008B3O00028O00025O00EAA340025O0018A040025O00B8AE40025O00E88D40025O002EAF40025O00CCA840025O00208440025O00A8A940025O00249C40025O00A3B240025O00309240025O001C9140025O007BB040025O00CDB040026O00F03F025O0060AD40025O00206E40030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C6963746564030B3O004E6174757265734375726503143O004E617475726573437572654D6F7573656F766572026O004440025O00F07F40025O002FB240030C3O0052656A7576656E6174696F6E03153O0052656A7576656E6174696F6E4D6F7573656F766572025O00D89840025O00B08F40027O0040025O002EAB40025O0094A240026O000840025O00149040025O0070A140025O002AA040025O00FAB040025O00CC9C40025O0050B04003093O0053776966746D656E6403123O0053776966746D656E644D6F7573656F766572025O00688540025O0075B240026O005F40025O00E06740025O00B4A840025O00B88440025O008AA140026O001040030A3O0057696C6467726F77746803133O0057696C6467726F7774684D6F7573656F766572025O0063B040025O005EA940025O00209940025O00D09740025O00288240025O00ACA540025O0062AD40025O006EA04003083O00526567726F77746803113O00526567726F7774684D6F7573656F766572025O0074B040025O00805840025O00EEAB40025O00849440025O00708440025O0002A740025O00E5B140025O006C9240025O0084A240025O00CCB140025O00C4B240025O00B0884003113O0048616E646C65496E636F72706F7265616C03093O0048696265726E61746503123O0048696265726E6174654D6F7573656F766572026O003E40025O006CA340025O009CAA40025O00B07140025O00D4A240025O00C4A340025O008C9E40025O00108040025O000EA240030D3O00546172676574497356616C6964025O00309E40025O0044A440025O00BC9640025O00C88B40025O00E2A240025O00C1B140025O0098B040025O00609740025O0092A140025O006C9A40025O004AA740025O00D07440025O00D88740025O002FB040025O00C07640025O004CB340025O001C9340025O00B2A140025O00508040025O001AA740025O00AAA340025O0038B040025O00AC9940025O00788540025O0015B040025O00F4A540025O00EAA040025O00407240030D3O0001D0D411DDC7D94229E6CF16F603083O002A4CB1A67A92A18D030A3O0049734361737461626C6503083O0042752O66446F776E030D3O004D61726B4F6654686557696C6403103O0047726F757042752O664D692O73696E67025O00889C4003133O004D61726B4F6654686557696C64506C6179657203103O00A88B17C54679A3B511C67C49B28309CA03063O0016C5EA65AE19025O00AEB040025O009C9840025O00789F40025O00405F4003043O001F35AED903083O00E64D54C5BC16CFB703073O004973526561647903093O00537465616C74685570025O004DB040025O00349D4003043O0052616B65030E3O004973496E4D656C2O6552616E6765026O00244003043O00EB15CDF903083O00559974A69CECC19000D4012O0012373O00013O002E1E010300F1000100020004EC3O00F100010026F63O00F1000100010004EC3O00F10001001237000100013O002E54000500EA000100040004EC3O00EA0001002E1E010700EA000100060004EC3O00EA00010026F6000100EA000100010004EC3O00EA0001002E4B000800B4000100080004EC3O00C000012O003B00025O00069D00020013000100010004EC3O00130001002E1E010900C00001000A0004EC3O00C00001001237000200014O0084000300033O002E4B000B3O0001000B0004EC3O001500010026F600020015000100010004EC3O00150001001237000300013O002E54000D003B0001000C0004EC3O003B0001002E1E010E003B0001000F0004EC3O003B00010026F60003003B000100010004EC3O003B0001001237000400013O00261601040025000100100004EC3O00250001002E5400110027000100120004EC3O00270001001237000300103O0004EC3O003B00010026F600040021000100010004EC3O002100012O003B000500013O0020C50005000500144O000600023O00202O0006000600154O000700033O00202O00070007001600122O000800176O00050008000200122O000500133O00122O000500133O00062O00050037000100010004EC3O00370001002E4B00180004000100190004EC3O00390001001288000500134O002D000500023O001237000400103O0004EC3O002100010026F600030056000100100004EC3O00560001001237000400013O0026F600040051000100010004EC3O005100012O003B000500013O0020C50005000500144O000600023O00202O00060006001A4O000700033O00202O00070007001B00122O000800176O00050008000200122O000500133O00122O000500133O00062O0005004E000100010004EC3O004E0001002E1E011C00500001001D0004EC3O00500001001288000500134O002D000500023O001237000400103O0026F60004003E000100100004EC3O003E00010012370003001E3O0004EC3O005600010004EC3O003E0001002E1E012000850001001F0004EC3O008500010026160103005C000100210004EC3O005C0001002E1E01230085000100220004EC3O00850001001237000400014O0084000500053O0026F60004005E000100010004EC3O005E0001001237000500013O002E1E0124007A000100250004EC3O007A000100261601050067000100010004EC3O00670001002E1E0127007A000100260004EC3O007A00012O003B000600013O0020C50006000600144O000700023O00202O0007000700284O000800033O00202O00080008002900122O000900176O00060009000200122O000600133O00122O000600133O00062O00060077000100010004EC3O00770001002E3D002B00770001002A0004EC3O00770001002E54002D00790001002C0004EC3O00790001001288000600134O002D000600023O001237000500103O002E4B002E00040001002E0004EC3O007E000100261601050080000100100004EC3O00800001002E54003000610001002F0004EC3O00610001001237000300313O0004EC3O008500010004EC3O006100010004EC3O008500010004EC3O005E0001000EA30031009B000100030004EC3O009B00012O003B000400013O0020B40004000400144O000500023O00202O0005000500324O000600033O00202O00060006003300122O000700176O000800016O00040008000200122O000400133O00122O000400133O00062O00040098000100010004EC3O00980001002E1501340098000100350004EC3O00980001002E4B0036002A000100370004EC3O00C00001001288000400134O002D000400023O0004EC3O00C00001002E1E0138001A000100390004EC3O001A0001000EEB001E00A1000100030004EC3O00A10001002E54003A001A0001003B0004EC3O001A0001001237000400013O000EA3000100B6000100040004EC3O00B600012O003B000500013O0020B40005000500144O000600023O00202O00060006003C4O000700033O00202O00070007003D00122O000800176O000900016O00050009000200122O000500133O00122O000500133O00062O000500B3000100010004EC3O00B30001002E1E013E00B50001003F0004EC3O00B50001001288000500134O002D000500023O001237000400103O002E54004100A2000100400004EC3O00A20001000EA3001000A2000100040004EC3O00A20001001237000300213O0004EC3O001A00010004EC3O00A200010004EC3O001A00010004EC3O00C000010004EC3O00150001002E54004200E9000100430004EC3O00E900012O003B000200043O00064F000200E900013O0004EC3O00E90001001237000200014O0084000300033O002E1E014500C7000100440004EC3O00C70001000EA3000100C7000100020004EC3O00C70001001237000300013O002616010300D2000100010004EC3O00D20001002E15014600D2000100470004EC3O00D20001002E4B004800FCFF2O00490004EC3O00CC00012O003B000400013O00201400040004004A4O000500023O00202O00050005004B4O000600033O00202O00060006004C00122O0007004D6O000800016O00040008000200122O000400133O002E2O004E00E10001004F0004EC3O00E10001001288000400133O00069D000400E3000100010004EC3O00E30001002E1E015100E9000100500004EC3O00E90001001288000400134O002D000400023O0004EC3O00E900010004EC3O00CC00010004EC3O00E900010004EC3O00C70001001237000100103O002E1E01530006000100520004EC3O00060001000EA300100006000100010004EC3O000600010012373O00103O0004EC3O00F100010004EC3O00060001002616012O00F5000100210004EC3O00F50001002E1E015500172O0100540004EC3O00172O012O003B000100013O0020252O01000100562O000D00010001000200064F000100D32O013O0004EC3O00D32O012O003B000100053O00064F000100D32O013O0004EC3O00D32O01001237000100014O0084000200023O0026F6000100FF000100010004EC3O00FF0001001237000200013O002E4B00573O000100570004EC3O00022O01002E54005900022O0100580004EC3O00022O010026F6000200022O0100010004EC3O00022O012O003B000300064O000D0003000100020012A8000300133O002E1E015A00D32O01005B0004EC3O00D32O01001288000300133O00064F000300D32O013O0004EC3O00D32O01001288000300134O002D000300023O0004EC3O00D32O010004EC3O00022O010004EC3O00D32O010004EC3O00FF00010004EC3O00D32O010026F63O00782O0100100004EC3O00782O01001237000100014O0084000200023O002E54005D001F2O01005C0004EC3O001F2O010026162O0100212O0100010004EC3O00212O01002E54005F001B2O01005E0004EC3O001B2O01001237000200013O002E4B00600004000100600004EC3O00262O01002616010200282O0100010004EC3O00282O01002E1E016100712O0100620004EC3O00712O012O003B000300073O00069D0003002E2O0100010004EC3O002E2O012O003B000300083O00064F000300312O013O0004EC3O00312O012O003B000300093O00069D000300332O0100010004EC3O00332O01002E54006400432O0100630004EC3O00432O01001237000300014O0084000400043O002E1E016500352O0100660004EC3O00352O010026F6000300352O0100010004EC3O00352O012O003B0005000A4O000D0005000100022O00E9000400053O002E4B00670007000100670004EC3O00432O0100064F000400432O013O0004EC3O00432O012O002D000400023O0004EC3O00432O010004EC3O00352O012O003B0003000B3O00064F000300702O013O0004EC3O00702O012O003B0003000C3O00064F000300702O013O0004EC3O00702O01001237000300014O0084000400053O002E540069005C2O0100680004EC3O005C2O01000EEB000100512O0100030004EC3O00512O01002E54006A005C2O01006B0004EC3O005C2O01001237000600013O0026F6000600562O0100100004EC3O00562O01001237000300103O0004EC3O005C2O010026F6000600522O0100010004EC3O00522O01001237000400014O0084000500053O001237000600103O0004EC3O00522O01002E1E016D004B2O01006C0004EC3O004B2O010026F60003004B2O0100100004EC3O004B2O01002E54006E00602O01006F0004EC3O00602O010026F6000400602O0100010004EC3O00602O012O003B0006000D4O000D0006000100022O00E9000500063O002E1E017100702O0100700004EC3O00702O0100064F000500702O013O0004EC3O00702O012O002D000500023O0004EC3O00702O010004EC3O00602O010004EC3O00702O010004EC3O004B2O01001237000200103O0026F6000200222O0100100004EC3O00222O010012373O001E3O0004EC3O00782O010004EC3O00222O010004EC3O00782O010004EC3O001B2O010026F63O00010001001E0004EC3O00010001002E4B0072002B000100720004EC3O00A52O012O003B0001000E3O00064F000100A52O013O0004EC3O00A52O012O003B000100024O00100102000F3O00122O000300733O00122O000400746O0002000400024O00010001000200202O0001000100754O00010002000200062O000100A52O013O0004EC3O00A52O012O003B000100103O0020910001000100764O000300023O00202O0003000300774O000400016O00010004000200062O000100982O0100010004EC3O00982O012O003B000100013O0020352O01000100784O000200023O00202O0002000200774O00010002000200062O000100A52O013O0004EC3O00A52O01002E4B0079000D000100790004EC3O00A52O012O003B000100114O003B000200033O00202501020002007A2O00052O010002000200064F000100A52O013O0004EC3O00A52O012O003B0001000F3O0012370002007B3O0012370003007C4O004C000100034O00392O015O002E54007E00D12O01007D0004EC3O00D12O012O003B000100013O0020252O01000100562O000D00010001000200064F000100D12O013O0004EC3O00D12O01002E1E018000D12O01007F0004EC3O00D12O012O003B000100024O00100102000F3O00122O000300813O00122O000400826O0002000400024O00010001000200202O0001000100834O00010002000200062O000100D12O013O0004EC3O00D12O012O003B000100103O0020EF0001000100844O00038O000400016O00010004000200062O000100D12O013O0004EC3O00D12O01002E1E018600D12O0100850004EC3O00D12O012O003B000100114O00FA000200023O00202O0002000200874O000300123O00202O00030003008800122O000500896O0003000500024O000300036O00010003000200062O000100D12O013O0004EC3O00D12O012O003B0001000F3O0012370002008A3O0012370003008B4O004C000100034O00392O015O0012373O00213O0004EC3O000100012O00BA3O00017O00B63O00028O00025O00D07740025O00F8AD40026O001440030C3O004570696353652O74696E677303083O00368C0400DD41581603073O003F65E97074B42F030A3O00EA29E21CDA37D130C52203063O0056A35B8D7298025O0055B240025O006CA640027O0040025O00E0A940025O0012A94003083O00192DB5577F242FB203053O00164A48C12303163O000577F05D3E6BF1483856EA54354EEC51387CE8513F6D03043O00384C198403083O006DC4BF32C650C6B803053O00AF3EA1CB4603123O0015D3D716272EC8D3070134CFC6003D33D1C703053O00555CBDA37303083O001AA9242C20A2372B03043O005849CC50031A3O001B90156228D72F84156526D4388C1B431DD22BB0004F3BD33A9003063O00BA4EE370264903083O00CF52E9415A74FB4403063O001A9C379D353303153O00B9CB13FDB95D8DDF13F7B94499CA13CA8E598BD11A03063O0030ECB876B9D803083O00D6B84324C63AE2AE03063O005485DD3750AF03123O0098E122AAC84EB8F427A3C95FB8D237A7C05903063O003CDD8744C6A7034O0003083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030F3O007DC351F64C21F24BC652F44036DF6803073O009738A5379A2353026O000840025O00507640025O00C8AD40025O00489240026O002O40026O001040025O0050AA40025O00808740025O00889240026O00F03F03083O00CB2O2A3CDC4B055703083O0024984F5E48B52562030B3O00E2CB4219DBD7522DDECB4F03043O005FB7B82703083O00863AF3325D8E05A603073O0062D55F874634E0030A3O00D8AFC66246F7B0C15F6403053O00349EC3A917025O0034AE40025O00508240025O00188340025O00AAB240025O00C0584003083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA03133O00C30C2CFFF0CFE5372AECCCD4E9112BFD2OECD003063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E98903163O009ABCA90987F8F58DBBA22C98FAE2B0A7B4389AFCE5A903073O0090D9D3C77FE893025O00A49F40025O0049B240025O00649840025O00A8A44003083O0049B926608F3B7C9803083O00EB1ADC5214E6551B030D3O00AEADE6D76681B2E1E56687B4F903053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC77030D3O0026BDA11DDDE9FEDA3ABCAF14FA03083O00B16FCFCE739F888C026O004640025O008CA840025O00989640025O00D2AD4003083O006EB0B69354BBA59403043O00E73DD5C203113O0021A83C7F00A33A4306B9347C07833C7E0C03043O001369CD5D03083O009A0DCA9536A70FCD03053O005FC968BEE1030F3O0087CEC0C2A6C5C6FEA0DFC8C1A1E3F103043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803103O00191AE3212D1BED232A3DEE091B00EA0803043O006C4C698603083O00D8C0A5F5C7E5C2A203053O00AE8BA5D181030D3O0087BAF1D1C30F547DA1A6E4C7D503083O0018C3D382A1A6631003083O0097E559A7ED0EA3F303063O0060C4802DD384030A4O009E7E6DD3ACBDD9399E03083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F68396903103O003E94A16C0E86A84D0580944B1F8EAB4A03043O00246BE7C4025O008AA240025O004CB140025O00649C40025O00D8AF40025O00C07F40025O001CB240025O00AAB140025O00406D4003083O00B752EA4E8D59F94903043O003AE4379E03113O009C88DE2A30A81CBA8ADF3C2CA227B188DC03073O0055D4E9B04E5CCD03083O00795D9CF643568FF103043O00822A38E803113O00C3BB30E6522DFFA530D4492BE28630F64E03063O005F8AD5448320025O0010B240025O00D09840025O00B0944003083O0089836DE756C023A903073O0044DAE619933FAE030D3O00852F5240A2A5394743B8A8026303053O00D6CD4A332C03083O00C949F6E87EF44BF103053O00179A2C829C030F3O0039A7A3AA3A1630A0ABA23F1005A3A903063O007371C6CDCE5603083O007506FD385A18411003063O00762663894C33030B3O00D92F16020C2CDF3303141A03063O00409D4665726903083O0073ADB3F7194EAFB403053O007020C8C783030E3O0019435990C6AA2E38584FACCCA52703073O00424C303CD8A3CB025O00349140025O0026A040025O00107A40025O0059B04003083O008ACBC42B46B7C9C303053O002FD9AEB05F030E3O009BD87803A05D77288FDC64069A6403083O0046D8BD1662D2341803083O00E9DAB793DAD4D8B003053O00B3BABFC3E703143O00CC2C1DC7F6310EEBF23A2CECFC0C08EDEB360CF703043O0084995F78025O00307C40025O0060A240025O00805E40025O000AA74003083O001D4E2AC1581FFB3D03073O009C4E2B5EB5317103133O0055FACBB50E646C73FAC0AA0A4D6A55FACBB61B03073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA1030F3O0018FF2EF90DD2833FE524D43FDD902903073O00E24D8C4BBA68BC025O00349540025O009EA54003083O00934611FAA94D02FD03043O008EC0236503113O00E3662C84F583BA13F16028B1E385AD18C503083O0076B61549C387ECCC03083O003B390E540D03FA1B03073O009D685C7A20646D03103O0084B4C0DC380098AAB1A2C6CB3334A59B03083O00CBC3C6AFAA5D47ED025O0036AF40025O00D09640025O0064AA400058022O0012373O00014O0084000100013O002616012O0006000100010004EC3O00060001002E1E01030002000100020004EC3O00020001001237000100013O0026F600010019000100040004EC3O00190001001288000200054O0083000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O000300013O00122O000400083O00122O000500096O0003000500024O00020002000300062O00020017000100010004EC3O00170001001237000200014O004A00025O0004EC3O00570201002E54000B00710001000A0004EC3O007100010026162O01001F0001000C0004EC3O001F0001002E1E010D00710001000E0004EC3O00710001001288000200054O005C000300013O00122O0004000F3O00122O000500106O0003000500024O0002000200034O000300013O00122O000400113O00122O000500126O0003000500024O0002000200034O000200023O00122O000200056O000300013O00122O000400133O00122O000500146O0003000500024O0002000200034O000300013O00122O000400153O00122O000500166O0003000500024O00020002000300062O00020039000100010004EC3O00390001001237000200014O004A000200033O0012CF000200056O000300013O00122O000400173O00122O000500186O0003000500024O0002000200034O000300013O00122O000400193O00122O0005001A6O0003000500024O0002000200034O000200043O00122O000200056O000300013O00122O0004001B3O00122O0005001C6O0003000500024O0002000200034O000300013O00122O0004001D3O00122O0005001E6O0003000500024O0002000200034O000200053O00122O000200056O000300013O00122O0004001F3O00122O000500206O0003000500024O0002000200034O000300013O00122O000400213O00122O000500226O0003000500024O00020002000300062O00020060000100010004EC3O00600001001237000200234O004A000200063O00126B000200056O000300013O00122O000400243O00122O000500256O0003000500024O0002000200034O000300013O00122O000400263O00122O000500276O0003000500024O00020002000300062O0002006F000100010004EC3O006F0001001237000200014O004A000200073O001237000100283O002E1E012900FB0001002A0004EC3O00FB0001002E1E012C00FB0001002B0004EC3O00FB00010026F6000100FB0001002D0004EC3O00FB0001001237000200013O000EEB0028007C000100020004EC3O007C0001002E1E012E007E0001002F0004EC3O007E0001001237000100043O0004EC3O00FB0001002E4B00300020000100300004EC3O009E00010026F60002009E000100310004EC3O009E0001001288000300054O005C000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300083O00122O000300056O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O00030003000400062O0003009C000100010004EC3O009C0001001237000300014O004A000300093O0012370002000C3O0026F6000200CD000100010004EC3O00CD0001001237000300013O002E4B003A00040001003A0004EC3O00A50001002616010300A7000100310004EC3O00A70001002E4B003B00040001003C0004EC3O00A90001001237000200313O0004EC3O00CD0001002616010300AD000100010004EC3O00AD0001002E54003D00A10001003E0004EC3O00A10001001288000400054O0083000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000500013O00122O000600413O00122O000700426O0005000700024O00040004000500062O000400BB000100010004EC3O00BB0001001237000400014O004A0004000A3O00126B000400056O000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O00040004000500062O000400CA000100010004EC3O00CA0001001237000400014O004A0004000B3O001237000300313O0004EC3O00A10001002616010200D10001000C0004EC3O00D10001002E1E01480078000100470004EC3O00780001001237000300013O002E54004900F50001004A0004EC3O00F500010026F6000300F5000100010004EC3O00F50001001288000400054O0083000500013O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O000500013O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500062O000400E4000100010004EC3O00E40001001237000400014O004A0004000C3O00126B000400056O000500013O00122O0006004F3O00122O000700506O0005000700024O0004000400054O000500013O00122O000600513O00122O000700526O0005000700024O00040004000500062O000400F3000100010004EC3O00F30001001237000400234O004A0004000D3O001237000300313O0026F6000300D2000100310004EC3O00D20001001237000200283O0004EC3O007800010004EC3O00D200010004EC3O00780001002E1E015300602O0100540004EC3O00602O01000EA3000100602O0100010004EC3O00602O01001237000200013O002616010200042O0100310004EC3O00042O01002E4B00550021000100560004EC3O00232O01001288000300054O0083000400013O00122O000500573O00122O000600586O0004000600024O0003000300044O000400013O00122O000500593O00122O0006005A6O0004000600024O00030003000400062O000300122O0100010004EC3O00122O01001237000300234O004A0003000E3O00126B000300056O000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000400013O00122O0005005D3O00122O0006005E6O0004000600024O00030003000400062O000300212O0100010004EC3O00212O01001237000300014O004A0003000F3O0012370002000C3O0026F60002003E2O01000C0004EC3O003E2O01001288000300054O0008000400013O00122O0005005F3O00122O000600606O0004000600024O0003000300044O000400013O00122O000500613O00122O000600626O0004000600024O0003000300044O000300103O00122O000300056O000400013O00122O000500633O00122O000600646O0004000600024O0003000300044O000400013O00122O000500653O00122O000600666O0004000600024O0003000300044O000300113O00122O000200283O0026F6000200592O0100010004EC3O00592O01001288000300054O0008000400013O00122O000500673O00122O000600686O0004000600024O0003000300044O000400013O00122O000500693O00122O0006006A6O0004000600024O0003000300044O000300123O00122O000300056O000400013O00122O0005006B3O00122O0006006C6O0004000600024O0003000300044O000400013O00122O0005006D3O00122O0006006E6O0004000600024O0003000300044O000300133O00122O000200313O0026160102005D2O0100280004EC3O005D2O01002E1E01702O002O01006F0004EC4O002O01001237000100313O0004EC3O00602O010004EC4O002O010026162O0100642O0100310004EC3O00642O01002E1E017200CE2O0100710004EC3O00CE2O01001237000200013O002E540073006B2O0100740004EC3O006B2O010026F60002006B2O0100280004EC3O006B2O010012370001000C3O0004EC3O00CE2O01002E1E017600882O0100750004EC3O00882O010026F6000200882O01000C0004EC3O00882O01001288000300054O0008000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000300143O00122O000300056O000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O0003000300044O000300153O00122O000200283O002E54008000B22O01007F0004EC3O00B22O010026F6000200B22O0100310004EC3O00B22O01001237000300013O002E4B00810006000100810004EC3O00932O010026F6000300932O0100310004EC3O00932O010012370002000C3O0004EC3O00B22O010026F60003008D2O0100010004EC3O008D2O01001288000400054O0083000500013O00122O000600823O00122O000700836O0005000700024O0004000400054O000500013O00122O000600843O00122O000700856O0005000700024O00040004000500062O000400A32O0100010004EC3O00A32O01001237000400014O004A000400163O001235000400056O000500013O00122O000600863O00122O000700876O0005000700024O0004000400054O000500013O00122O000600883O00122O000700896O0005000700024O0004000400054O000400173O00122O000300313O0004EC3O008D2O010026F6000200652O0100010004EC3O00652O01001288000300054O0008000400013O00122O0005008A3O00122O0006008B6O0004000600024O0003000300044O000400013O00122O0005008C3O00122O0006008D6O0004000600024O0003000300044O000300183O00122O000300056O000400013O00122O0005008E3O00122O0006008F6O0004000600024O0003000300044O000400013O00122O000500903O00122O000600916O0004000600024O0003000300044O000300193O00122O000200313O0004EC3O00652O01000EEB002800D22O0100010004EC3O00D22O01002E1E01930007000100920004EC3O00070001001237000200014O0084000300033O002E54009400D42O0100950004EC3O00D42O010026F6000200D42O0100010004EC3O00D42O01001237000300013O0026F6000300F72O01000C0004EC3O00F72O01001288000400054O0083000500013O00122O000600963O00122O000700976O0005000700024O0004000400054O000500013O00122O000600983O00122O000700996O0005000700024O00040004000500062O000400E92O0100010004EC3O00E92O01001237000400014O004A0004001A3O001235000400056O000500013O00122O0006009A3O00122O0007009B6O0005000700024O0004000400054O000500013O00122O0006009C3O00122O0007009D6O0005000700024O0004000400054O0004001B3O00122O000300283O002E1E019E00FD2O01009F0004EC3O00FD2O010026F6000300FD2O0100280004EC3O00FD2O010012370001002D3O0004EC3O000700010026F600030027020100310004EC3O00270201001237000400013O00261601040004020100010004EC3O00040201002E1E01A10020020100A00004EC3O00200201001288000500054O0083000600013O00122O000700A23O00122O000800A36O0006000800024O0005000500064O000600013O00122O000700A43O00122O000800A56O0006000800024O00050005000600062O00050012020100010004EC3O00120201001237000500014O004A0005001C3O001235000500056O000600013O00122O000700A63O00122O000800A76O0006000800024O0005000500064O000600013O00122O000700A83O00122O000800A96O0006000800024O0005000500064O0005001D3O00122O000400313O002E5400AA2O00020100AB0004EC4O0002010026F600042O00020100310004EC4O0002010012370003000C3O0004EC3O002702010004EC4O0002010026F6000300D92O0100010004EC3O00D92O01001237000400013O000EA300010048020100040004EC3O00480201001288000500054O005C000600013O00122O000700AC3O00122O000800AD6O0006000800024O0005000500064O000600013O00122O000700AE3O00122O000800AF6O0006000800024O0005000500064O0005001E3O00122O000500056O000600013O00122O000700B03O00122O000800B16O0006000800024O0005000500064O000600013O00122O000700B23O00122O000800B36O0006000800024O00050005000600062O00050046020100010004EC3O00460201001237000500014O004A0005001F3O001237000400313O002E4B00B400E2FF2O00B40004EC3O002A0201002E5400B5002A020100B60004EC3O002A02010026F60004002A020100310004EC3O002A0201001237000300313O0004EC3O00D92O010004EC3O002A02010004EC3O00D92O010004EC3O000700010004EC3O00D42O010004EC3O000700010004EC3O005702010004EC3O000200012O00BA3O00017O00C53O00028O00025O00F8AA40025O0078AB40025O00A8A240025O00689D40027O0040025O0066AB40025O006AA340026O00F03F025O00288D40025O003AA840025O00E49E40025O005EA840025O0052AE40025O00889D40030C3O004570696353652O74696E677303083O00152E31ABE8282C3603053O0081464B45DF030B3O0073D8F6DB79E854C4E4FD7403063O008F26AB93891C03083O00E387ADE70AEDD3C303073O00B4B0E2D9936383030A3O00E1BC2815DCAE3B0FFB8903043O0067B3D94F025O00C0A140025O0098AC4003083O0079B208C14882A45903073O00C32AD77CB521EC03123O00384A320C20FF1F56202A2DCA085F253B36F003063O00986D39575E45026O000840026O00204003083O008D75CED30ABB840203083O0071DE10BAA763D5E3030C3O001907F7F2291CF4E13A06D3C603043O00964E6E9B03083O00B6C033F5AD10B85303083O0020E5A54781C47EDF030F3O00F480C88586C7CC9ED089A6C7CC9CD403063O00B5A3E9A42OE1025O0022A240025O00BCAA4003083O00638E2A635985396403043O001730EB5E030A3O005EDBCA564438DB72F2E803073O00B21CBAB83D3753026O002240025O005AAD40025O0027B34003083O00D501352D45097DF503073O001A866441592C67030C3O00C4F0350FADF7E6322FABFEEE03053O00C491835043025O00408B40025O007CB040025O00DCA740025O00089E4003083O00600E6067335D0C6703053O005A336B141303103O00B8E380C3348BF587E33282FDB1EE338603053O005DED90E58F03083O0026F3E40D024812E503063O0026759690796B030F3O0001B2E83F2FB7E135208FEF342693DE03043O005A4DDB8E026O001440025O005DB040025O00BCA340025O008C9340025O00449740025O00549540025O008EB040025O00F08440025O00AC9B4003083O002DE561DEE3851EC503083O00B67E8015AA8AEB7903123O00BEC930D294123E179ED339EF920A04148EDF03083O0066EBBA5586E67350026O001840025O00CC9640025O00907440025O00C07040025O00CEAB4003083O0063FC12AB5671FE6903083O001A309966DF3F1F99030D3O003652ECFD1355E4FF0B54F4DB3203043O009362208D03083O002B46F7DE0F584C0B03073O002B782383AA663603103O00601486B8B4A58D580F93AF82A28B411603073O00E43466E7D6C5D0025O00D8A440025O00949F4003083O0064092A4B7BDA254403073O0042376C5E3F12B403113O00209F8439364C1D818C233E6D0688801F1703063O003974EDE5574703083O0099B4F9F37EE040B903073O0027CAD18D87178E03143O00CB21080423EDF63F001E2BCCED360C2D20F7EA2303063O00989F53696A5203083O00B2C345E6C05286D503063O003CE1A63192A903113O001A0D2A1D080B2B193D251613272D203E2703063O00674F7E4F4A61026O001C40025O00BC9940025O0058A840026O001040025O0065B240025O0096B140025O00BCA640025O00609140025O00789E40025O0006AE40025O00E2A240025O00CEAC4003083O000B370797313C149003043O00E3585273030C3O00760CBF94157A450BB7A20C7703063O0013237FDAC76203083O002FFE1EF615F50DF103043O00827C9B6A030B3O00E6DCFFA9B7FB79B1D1E3C603083O00DFB5AB96CFC3961C025O00C2A240025O00EC9C4003083O007F3FF7BA00423DF003053O00692C5A83CE030E3O00CAF3B78D1A3F2OF1A7B00437EBF903063O005E9F80D2D96803083O00F7C85328FB00F2D703073O0095A4AD275C926E030B3O00C634153D1B09F8341B161403063O007B9347707F7A03083O00FFC896654FC2CA9103053O0026ACADE21103093O007F1422EA5A1020C77D03043O008F2D714C03083O008BBD0828B1B61B2F03043O005C2OD87C030A3O006E21A972F85537BB41F103053O009D3B52CC20025O00649B40025O0074AB40025O00188240025O00FCB140025O00189D40025O0028AD40025O00F89F40025O007AB04003083O002DB5121C11E619A303063O00887ED0666878030B3O005483C846AD5E325E75A2FE03083O003118EAAE23CF325D03083O003FF7E99C7802F5EE03053O00116C929DE803133O007ED011C32EBC5ED111FE1CBF42C500E32ABB5803063O00C82BA3748D4F025O0070A340025O0050894003083O008C332997B9FAE4AC03073O0083DF565DE3D09403123O00CD44A2A30FB0F076A1BF1BA1ED402OA5358503063O00D583252OD67D025O0079B140025O00789A40025O00BAB240025O00D8AB4003083O00897AC7675714BD6C03063O007ADA1FB3133E03103O0084DFC1C5CEB34AA4C2C5F2C6B5639BE603073O0025D3B6ADA1A9C103083O00C43F59CD2175BEE403073O00D9975A2DB9481B03133O00F475EB1651D173F0065EF073F33471D173F20203053O0036A31C8772025O00507040025O0020614003083O001BDE499647712FC803063O001F48BB3DE22E030D3O00F61546E54E7220C4144CC5537603073O0044A36623B2271E025O000C9140025O004CA74003083O00CAD21E2OB7DC53BB03083O00C899B76AC3DEB23403114O00E68F2F464D26EBBA384F4837F080157903063O003A5283E85D2903083O00B052C4015431844403063O005FE337B0753D030F3O002D6D2679AE126B354EA5196A2A44A503053O00CB781E432B03083O00C22059FBD0FF225E03053O00B991452D8F030E3O00B81A13B3CA8F1118B2D58511319603053O00BCEA7F79C60072022O0012373O00014O0084000100013O002616012O0008000100010004EC3O00080001002E3D00030008000100020004EC3O00080001002E1E01040002000100050004EC3O00020001001237000100013O0026162O01000D000100060004EC3O000D0001002E540007004D000100080004EC3O004D0001001237000200013O0026F60002003A000100010004EC3O003A0001001237000300013O00261601030015000100090004EC3O00150001002E1E010B00170001000A0004EC3O00170001001237000200093O0004EC3O003A0001002E1E010C00110001000D0004EC3O001100010026160103001D000100010004EC3O001D0001002E54000E00110001000F0004EC3O00110001001288000400104O005C000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O00045O00122O000400106O000500013O00122O000600153O00122O000700166O0005000700024O0004000400054O000500013O00122O000600173O00122O000700186O0005000700024O00040004000500062O00040037000100010004EC3O00370001001237000400014O004A000400023O001237000300093O0004EC3O001100010026160102003E000100090004EC3O003E0001002E1E011A000E000100190004EC3O000E0001001288000300104O009C000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000400013O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000300033O00122O0001001F3O00044O004D00010004EC3O000E00010026F60001008F000100200004EC3O008F0001001237000200013O0026F60002007B000100010004EC3O007B0001001237000300013O000EA300010074000100030004EC3O00740001001288000400104O0083000500013O00122O000600213O00122O000700226O0005000700024O0004000400054O000500013O00122O000600233O00122O000700246O0005000700024O00040004000500062O00040063000100010004EC3O00630001001237000400014O004A000400043O00126B000400106O000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O000500013O00122O000600273O00122O000700286O0005000700024O00040004000500062O00040072000100010004EC3O00720001001237000400014O004A000400053O001237000300093O002E54002900530001002A0004EC3O005300010026F600030053000100090004EC3O00530001001237000200093O0004EC3O007B00010004EC3O005300010026F600020050000100090004EC3O00500001001288000300104O0083000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400062O0003008B000100010004EC3O008B0001001237000300014O004A000300063O0012370001002F3O0004EC3O008F00010004EC3O00500001002E1E013000C7000100310004EC3O00C70001000EA3000100C7000100010004EC3O00C70001001237000200013O000EA3000900A4000100020004EC3O00A40001001288000300104O009C000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300073O00122O000100093O00044O00C70001002E5400360094000100370004EC3O00940001002616010200AA000100010004EC3O00AA0001002E1E01380094000100390004EC3O00940001001288000300104O005C000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000300083O00122O000300106O000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000400013O00122O000500403O00122O000600416O0004000600024O00030003000400062O000300C4000100010004EC3O00C40001001237000300014O004A000300093O001237000200093O0004EC3O009400010026162O0100CB000100420004EC3O00CB0001002E540043000E2O0100440004EC3O000E2O01001237000200014O0084000300033O002616010200D1000100010004EC3O00D10001002E54004600CD000100450004EC3O00CD0001001237000300013O002E1E014700E6000100480004EC3O00E60001002616010300D8000100090004EC3O00D80001002E4B004900100001004A0004EC3O00E60001001288000400104O009C000500013O00122O0006004B3O00122O0007004C6O0005000700024O0004000400054O000500013O00122O0006004D3O00122O0007004E6O0005000700024O0004000400054O0004000A3O00122O0001004F3O00044O000E2O01002E1E015100EA000100500004EC3O00EA0001002616010300EC000100010004EC3O00EC0001002E4B005200E8FF2O00530004EC3O00D20001001288000400104O0083000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O000500013O00122O000600563O00122O000700576O0005000700024O00040004000500062O000400FA000100010004EC3O00FA0001001237000400014O004A0004000B3O00126B000400106O000500013O00122O000600583O00122O000700596O0005000700024O0004000400054O000500013O00122O0006005A3O00122O0007005B6O0005000700024O00040004000500062O000400092O0100010004EC3O00092O01001237000400014O004A0004000C3O001237000300093O0004EC3O00D200010004EC3O000E2O010004EC3O00CD00010026162O0100122O01004F0004EC3O00122O01002E54005C003D2O01005D0004EC3O003D2O01001288000200104O0083000300013O00122O0004005E3O00122O0005005F6O0003000500024O0002000200034O000300013O00122O000400603O00122O000500616O0003000500024O00020002000300062O000200202O0100010004EC3O00202O01001237000200014O004A0002000D3O00126B000200106O000300013O00122O000400623O00122O000500636O0003000500024O0002000200034O000300013O00122O000400643O00122O000500656O0003000500024O00020002000300062O0002002F2O0100010004EC3O002F2O01001237000200014O004A0002000E3O001235000200106O000300013O00122O000400663O00122O000500676O0003000500024O0002000200034O000300013O00122O000400683O00122O000500696O0003000500024O0002000200034O0002000F3O00122O0001006A3O002E1E016B00832O01006C0004EC3O00832O010026F6000100832O01006D0004EC3O00832O01001237000200013O002616010200462O0100010004EC3O00462O01002E4B006E002C0001006F0004EC3O00702O01001237000300013O002E540071004B2O0100700004EC3O004B2O01000EEB0009004D2O0100030004EC3O004D2O01002E1E0173004F2O0100720004EC3O004F2O01001237000200093O0004EC3O00702O01002616010300532O0100010004EC3O00532O01002E54007500472O0100740004EC3O00472O01001288000400104O005C000500013O00122O000600763O00122O000700776O0005000700024O0004000400054O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000400103O00122O000400106O000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500062O0004006D2O0100010004EC3O006D2O01001237000400014O004A000400113O001237000300093O0004EC3O00472O01002E1E017F00422O01007E0004EC3O00422O010026F6000200422O0100090004EC3O00422O01001288000300104O009C000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000400013O00122O000500823O00122O000600836O0004000600024O0003000300044O000300123O00122O000100423O00044O00832O010004EC3O00422O010026F6000100AD2O01002F0004EC3O00AD2O01001288000200104O005C000300013O00122O000400843O00122O000500856O0003000500024O0002000200034O000300013O00122O000400863O00122O000500876O0003000500024O0002000200034O000200133O00122O000200106O000300013O00122O000400883O00122O000500896O0003000500024O0002000200034O000300013O00122O0004008A3O00122O0005008B6O0003000500024O00020002000300062O0002009F2O0100010004EC3O009F2O01001237000200014O004A000200143O0012BB000200106O000300013O00122O0004008C3O00122O0005008D6O0003000500024O0002000200034O000300013O00122O0004008E3O00122O0005008F6O0003000500022O00270102000200032O004A000200153O0004EC3O007102010026162O0100B12O0100090004EC3O00B12O01002E54009100F42O0100900004EC3O00F42O01001237000200013O002E54009200DE2O0100930004EC3O00DE2O010026F6000200DE2O0100010004EC3O00DE2O01001237000300013O002616010300BB2O0100090004EC3O00BB2O01002E1E019500BD2O0100940004EC3O00BD2O01001237000200093O0004EC3O00DE2O01002E1E019600B72O0100970004EC3O00B72O010026F6000300B72O0100010004EC3O00B72O01001288000400104O0083000500013O00122O000600983O00122O000700996O0005000700024O0004000400054O000500013O00122O0006009A3O00122O0007009B6O0005000700024O00040004000500062O000400CF2O0100010004EC3O00CF2O01001237000400014O004A000400163O001235000400106O000500013O00122O0006009C3O00122O0007009D6O0005000700024O0004000400054O000500013O00122O0006009E3O00122O0007009F6O0005000700024O0004000400054O000400173O00122O000300093O0004EC3O00B72O01002E5400A100B22O0100A00004EC3O00B22O01000EA3000900B22O0100020004EC3O00B22O01001288000300104O0083000400013O00122O000500A23O00122O000600A36O0004000600024O0003000300044O000400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400062O000300F02O0100010004EC3O00F02O01001237000300014O004A000300183O001237000100063O0004EC3O00F42O010004EC3O00B22O01002E5400A7002F020100A60004EC3O002F0201002E1E01A9002F020100A80004EC3O002F0201000EA3006A002F020100010004EC3O002F0201001237000200013O0026F60002001C020100010004EC3O001C0201001288000300104O0083000400013O00122O000500AA3O00122O000600AB6O0004000600024O0003000300044O000400013O00122O000500AC3O00122O000600AD6O0004000600024O00030003000400062O0003000B020100010004EC3O000B0201001237000300014O004A000300193O00126B000300106O000400013O00122O000500AE3O00122O000600AF6O0004000600024O0003000300044O000400013O00122O000500B03O00122O000600B16O0004000600024O00030003000400062O0003001A020100010004EC3O001A0201001237000300014O004A0003001A3O001237000200093O00261601020020020100090004EC3O00200201002E1E01B200FB2O0100B30004EC3O00FB2O01001288000300104O009C000400013O00122O000500B43O00122O000600B56O0004000600024O0003000300044O000400013O00122O000500B63O00122O000600B76O0004000600024O0003000300044O0003001B3O00122O000100203O00044O002F02010004EC3O00FB2O010026F6000100090001001F0004EC3O00090001001237000200013O0026F60002005A020100010004EC3O005A0201001237000300013O000EA300090039020100030004EC3O00390201001237000200093O0004EC3O005A02010026160103003D020100010004EC3O003D0201002E5400B90035020100B80004EC3O00350201001288000400104O0083000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O000500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500062O0004004B020100010004EC3O004B0201001237000400014O004A0004001C3O001235000400106O000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000500013O00122O000600C03O00122O000700C16O0005000700024O0004000400054O0004001D3O00122O000300093O0004EC3O00350201000EA300090032020100020004EC3O00320201001288000300104O0083000400013O00122O000500C23O00122O000600C36O0004000600024O0003000300044O000400013O00122O000500C43O00122O000600C56O0004000600024O00030003000400062O0003006A020100010004EC3O006A0201001237000300014O004A0003001E3O0012370001006D3O0004EC3O000900010004EC3O003202010004EC3O000900010004EC3O007102010004EC3O000200012O00BA3O00017O0010012O00028O00025O00688440025O008C9A40027O0040025O00ACA340025O00D4A740025O006AA040025O00D09B40026O000840025O00C7B240025O00206640025O0019B140025O00709E40030C3O004570696353652O74696E677303073O0021ADF81F3710B103053O005B75C29F7803073O001E0D2D1E3AE32903073O00447A7D5E78559103073O002313C859C4DCA903073O00DA777CAF3EA8B903073O00ADF549C8ACFE4F03043O00A4C59028026O00F03F025O009EAC40025O00F88A40026O008D40025O007FB040025O0064AF40025O0052B240030D3O004973446561644F7247686F7374025O00C09440025O00609C40030F3O00412O66656374696E67436F6D626174025O00689440025O00C8A140025O0077B240025O00049240025O0020AA40030B3O00ADF1BE9ECFB390D3BF99D803063O00D6E390CAEBBD03073O0049735265616479031B3O00497354616E6B42656C6F774865616C746850657263656E7461676503083O00C4B7887532B2413703083O005C8DC5E71B70D33303093O00D2FE84A891C9F186BA03053O00B1869FEAC3030D3O0089EA31AB89BCE53BE0FAB8E73903053O00A9DD8B5FC0025O006CAE40025O0058B140025O00807840025O00B8A040025O00BAA040025O0012B340025O00B3B140025O0042A840025O00FDB040025O00B4B240030C3O0053686F756C6452657475726E03093O00466F637573556E697403043O00EAAA511403063O0046BEEB1F5F42026O003440025O00D6A240025O00C88F4003103O004865616C746850657263656E7461676503083O0093F015E8C7BBF01103053O0085DA827A86030D3O0008FEEDCF9CA23638BFD0C1D0A503073O00585C9F83A4BCC3025O002EAE40025O00608440025O00289C40025O0006A940025O001AA14003063O00A80B9E67F2D903073O00BDE04EDF2BB78B025O0022AC40025O00B89A40025O00E88E40025O0095B040025O00C49F40025O00688940026O002E40025O00607840025O00888640025O00B49740025O00E2A340025O00D49A40025O001BB240025O00805D40025O006FB240025O00FAA540025O00289340025O0040A94003073O0065A703F410124B03073O003831C864937C772O033O00CF3AAC03043O0090AC5EDF03073O001000A540280AB103043O0027446FC203063O00D2AFF4D77CBB03063O00D7B6C687A719025O006EAD40025O00108640025O00B8A940025O000C9740025O00A5B240025O00FC944003073O00B946ED4F814CF903043O0028ED298A03043O00D575F7E803053O002AA7149A9803073O007EF1A5457D245903063O00412A9EC222112O033O001E374103083O008E7A47326C4D8D7B025O005C9B40025O00E09740025O00688D40025O00ABB040025O00B0AB40025O00D89740025O00C09340025O00D4A440025O0072B34003093O0049734D6F756E746564025O00607040025O00709940025O000CB04003083O0049734D6F76696E67025O0048AB40025O00208E4003073O0047657454696D65025O002EB240025O004CA540025O00E2B140025O000FB240025O00E09B40025O00B6B040025O00108140025O00BC904003063O0042752O665570030A3O0054726176656C466F726D03083O0042656172466F726D03073O00436174466F726D025O00FEB240025O0072AC40025O0006A440025O0044A640025O00288F40025O0054B040025O0096B14003173O00476574456E656D696573496E53706C61736852616E6765026O002040025O00B4A340025O0051B040025O00849240025O00B0A840025O00BC9340025O00A06240025O00E88B40026O001040025O00F8AF40026O007D4003073O000C31E4FDE5EFC003083O00D1585E839A898AB32O033O0027AEC703083O004248C1A41C7E435103073O00D323AF5F2A73F403063O0016874CC838462O033O008C3FFD03063O0081ED5098443D025O0018A640025O0028A040025O00349040025O00489B40030D3O00546172676574497356616C6964025O006C9040025O0064B340025O0034AD40025O00D8AC40024O0080B3C540030C3O00466967687452656D61696E73025O00C4A740025O0084B040025O0023B340025O00BCA340025O00DCAD40025O00B8894003103O00426F2O73466967687452656D61696E73025O00BAAB40025O00E9B14003063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O0062B340025O0094A840025O00609340025O0088A140025O00B07D40025O0032B040025O00307C40025O0002B340025O00405E40025O00206040025O00A8994003163O0044656164467269656E646C79556E697473436F756E74025O00AEA340025O0014A040025O005EB340025O007C9B4003073O001CF9881FD33AF403053O00A14E9CEA7603073O005265626972746803073O00B5B2CBD5B5A3C103043O00BCC7D7A9030A3O005265766974616C697A65025O00BFB140025O00607640030A3O00EE0C4972FCFD055661ED03053O00889C693F1B025O00E8A640025O003BB140025O004C9F4003063O0052657669766503093O004973496E52616E6765026O00444003063O0009896F3D0D8903043O00547BEC19025O0080A240025O00805940030C3O0044656275674D652O73616765025O008AA540026O00AF40025O00608940025O00389D40025O0062AE40025O00949B40025O00B49240025O000C9640025O00A8A240030C3O0049734368612O6E656C696E67025O00D4B040025O0030A440025O00A3B240025O00805840025O0052A240025O006AA640025O00CC9840025O00C06F40025O0062B040025O0023B040025O00707C40025O00C9B040025O006C9340025O00E06440025O006CB140025O00308640025O0014AC40025O00707540025O00C49640025O00B4AF40025O00D49540025O00C8AD40025O0012A840025O00208D40025O00F4A340025O00509940025O00BEAD40025O00907340025O00788C4000D8032O0012373O00014O0084000100013O002616012O0006000100010004EC3O00060001002E1E01030002000100020004EC3O00020001001237000100013O0026F60001001F2O0100040004EC3O001F2O01001237000200013O002E1E0105000E000100060004EC3O000E000100261601020010000100040004EC3O00100001002E4B00070004000100080004EC3O00120001001237000100093O0004EC3O001F2O01002E54000B00160001000A0004EC3O00160001000EEB00010018000100020004EC3O00180001002E1E010C00310001000D0004EC3O003100010012880003000E4O0008000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O00035O00122O0003000E6O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O0003000300044O000300023O00122O000200173O002E1E0119000A000100180004EC3O000A00010026F60002000A000100170004EC3O000A0001001237000300013O002E1E011A00172O01001B0004EC3O00172O01002E1E011C00172O01001D0004EC3O00172O010026F6000300172O0100010004EC3O00172O012O003B000400033O00202E01040004001E2O000501040002000200064F0004004200013O0004EC3O004200012O00BA3O00013O002E1E011F00162O0100200004EC3O00162O012O003B000400033O00202E0104000400212O000501040002000200069D0004004C000100010004EC3O004C00012O003B000400043O00064F000400162O013O0004EC3O00162O01001237000400014O0084000500063O00261601040052000100010004EC3O00520001002E1E01230055000100220004EC3O00550001001237000500014O0084000600063O001237000400173O002E540025004E000100240004EC3O004E00010026F60004004E000100170004EC3O004E0001002E4B00263O000100260004EC3O005900010026F600050059000100010004EC3O005900012O003B000700043O00061A0006006B000100070004EC3O006B00012O003B000700054O001D000800013O00122O000900273O00122O000A00286O0008000A00024O00070007000800202O0007000700294O00070002000200062O0006006B000100070004EC3O006B00012O003B000600064O003B000700073O00202501070007002A2O003B000800084O000501070002000200064F0007008900013O0004EC3O008900012O003B000700054O0010010800013O00122O0009002B3O00122O000A002C6O0008000A00024O00070007000800202O0007000700294O00070002000200062O0007008900013O0004EC3O008900012O003B000700094O005A000800013O00122O0009002D3O00122O000A002E6O0008000A000200062O0007008B000100080004EC3O008B00012O003B000700094O005A000800013O00122O0009002F3O00122O000A00306O0008000A000200062O0007008B000100080004EC3O008B0001002E54003200B1000100310004EC3O00B10001001237000700014O0084000800083O00261601070093000100010004EC3O00930001002E3D00340093000100330004EC3O00930001002E1E0136008D000100350004EC3O008D0001001237000800013O0026160108009A000100010004EC3O009A0001002ECA0037009A000100380004EC3O009A0001002E1E013A0094000100390004EC3O009400012O003B000900073O0020A700090009003C4O000A00066O000B000C6O000D00013O00122O000E003D3O00122O000F003E6O000D000F000200122O000E003F6O0009000E000200122O0009003B3O002E2O004100162O0100400004EC3O00162O010012880009003B3O00064F000900162O013O0004EC3O00162O010012880009003B4O002D000900023O0004EC3O00162O010004EC3O009400010004EC3O00162O010004EC3O008D00010004EC3O00162O012O003B000700033O00202E0107000700422O00050107000200022O003B000800083O000658000700F5000100080004EC3O00F500012O003B000700054O0010010800013O00122O000900433O00122O000A00446O0008000A00024O00070007000800202O0007000700294O00070002000200062O000700F500013O0004EC3O00F500012O003B000700094O0096000800013O00122O000900453O00122O000A00466O0008000A000200062O000700F5000100080004EC3O00F50001001237000700014O0084000800093O0026F6000700CF000100010004EC3O00CF0001001237000800014O0084000900093O001237000700173O002E4B00470004000100470004EC3O00D30001002616010700D5000100170004EC3O00D50001002E54004900CA000100480004EC3O00CA00010026F6000800D5000100010004EC3O00D50001001237000900013O002E54004B00D80001004A0004EC3O00D800010026F6000900D8000100010004EC3O00D800012O003B000A00073O00200C010A000A003C4O000B00066O000C000D6O000E00013O00122O000F004C3O00122O0010004D6O000E0010000200122O000F003F6O000A000F000200122O000A003B3O00122O000A003B3O00062O000A00EC000100010004EC3O00EC0001002E54004E00162O01004F0004EC3O00162O01001288000A003B4O002D000A00023O0004EC3O00162O010004EC3O00D800010004EC3O00162O010004EC3O00D500010004EC3O00162O010004EC3O00CA00010004EC3O00162O01001237000700014O0084000800083O002E54005000F7000100510004EC3O00F700010026F6000700F7000100010004EC3O00F70001001237000800013O00261601082O002O0100010004EC4O002O01002E1E015200FC000100530004EC3O00FC00012O003B000900073O00200701090009003C4O000A00066O000B000D3O00122O000E003F6O0009000E000200122O0009003B3O002E2O005400162O0100550004EC3O00162O010012880009003B3O00064F000900162O013O0004EC3O00162O010012880009003B4O002D000900023O0004EC3O00162O010004EC3O00FC00010004EC3O00162O010004EC3O00F700010004EC3O00162O010004EC3O005900010004EC3O00162O010004EC3O004E0001001237000300173O0026160103001B2O0100170004EC3O001B2O01002E1E01570036000100560004EC3O00360001001237000200043O0004EC3O000A00010004EC3O003600010004EC3O000A0001002E1E0159007B2O0100580004EC3O007B2O010026F60001007B2O0100170004EC3O007B2O01001237000200013O0026F6000200282O0100040004EC3O00282O01001237000100043O0004EC3O007B2O010026160102002C2O0100010004EC3O002C2O01002E4B005A00270001005B0004EC3O00512O01001237000300013O002E1E015D00332O01005C0004EC3O00332O010026F6000300332O0100170004EC3O00332O01001237000200173O0004EC3O00512O01002E54005E002D2O01005F0004EC3O002D2O01000EA30001002D2O0100030004EC3O002D2O010012880004000E4O0008000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O0004000400054O0004000A3O00122O0004000E6O000500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O000400063O00122O000300173O0004EC3O002D2O01002E54006900242O0100680004EC3O00242O01000EA3001700242O0100020004EC3O00242O01001237000300013O002E1E016B005C2O01006A0004EC3O005C2O010026F60003005C2O0100170004EC3O005C2O01001237000200043O0004EC3O00242O01002616010300602O0100010004EC3O00602O01002E54006C00562O01006D0004EC3O00562O010012880004000E4O0008000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000500013O00122O000600703O00122O000700716O0005000700024O0004000400054O0004000B3O00122O0004000E6O000500013O00122O000600723O00122O000700736O0005000700024O0004000400054O000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O0004000C3O00122O000300173O0004EC3O00562O010004EC3O00242O010026162O01007F2O0100090004EC3O007F2O01002E5400760019020100770004EC3O00190201001237000200014O0084000300033O0026F6000200812O0100010004EC3O00812O01001237000300013O002E54007800AB2O0100790004EC3O00AB2O010026F6000300AB2O0100010004EC3O00AB2O01001237000400013O002E4B007A00080001007A0004EC3O00912O01002E1E017C00912O01007B0004EC3O00912O01000EA3001700912O0100040004EC3O00912O01001237000300173O0004EC3O00AB2O01002616010400952O0100010004EC3O00952O01002E1E017E00892O01007D0004EC3O00892O012O003B000500033O00202E01050005007F2O000501050002000200069D0005009C2O0100010004EC3O009C2O01002E540081009D2O0100800004EC3O009D2O012O00BA3O00013O002E4B0082000C000100820004EC3O00A92O012O003B000500033O00202E0105000500832O000501050002000200069D000500A62O0100010004EC3O00A62O01002E1E018400A92O0100850004EC3O00A92O01001288000500864O000D0005000100022O004A0005000D3O001237000400173O0004EC3O00892O01002E4B00870065000100870004EC3O00100201002616010300B12O0100170004EC3O00B12O01002E4B00880061000100890004EC3O00100201001237000400013O002616010400B62O0100010004EC3O00B62O01002E4B008A00550001008B0004EC3O00090201002E1E015000D82O01008C0004EC3O00D82O01002E1E018D00D82O01008E0004EC3O00D82O012O003B000500033O0020B700050005008F4O000700053O00202O0007000700904O00050007000200062O000500CF2O0100010004EC3O00CF2O012O003B000500033O0020B700050005008F4O000700053O00202O0007000700914O00050007000200062O000500CF2O0100010004EC3O00CF2O012O003B000500033O00208500050005008F4O000700053O00202O0007000700924O00050007000200062O000500D82O013O0004EC3O00D82O01001288000500864O000D0005000100022O003B0006000D4O006C000500050006002613010500D72O0100170004EC3O00D72O01002E1E019300D82O0100940004EC3O00D82O012O00BA3O00014O003B0005000E3O00069D000500DD2O0100010004EC3O00DD2O01002E4B0095001A000100390004EC3O00F52O01001237000500014O0084000600063O002E54009700DF2O0100960004EC3O00DF2O010026F6000500DF2O0100010004EC3O00DF2O01001237000600013O002E1E019800E42O0100990004EC3O00E42O01000EA3000100E42O0100060004EC3O00E42O012O003B000700103O00201A01070007009A00122O0009009B6O0007000900024O0007000F6O0007000F6O000700076O000700113O00044O000802010004EC3O00E42O010004EC3O000802010004EC3O00DF2O010004EC3O00080201001237000500014O0084000600063O002616010500FB2O0100010004EC3O00FB2O01002E4B009C00FEFF2O009D0004EC3O00F72O01001237000600013O002E1E019E00FC2O01009F0004EC3O00FC2O01000EA3000100FC2O0100060004EC3O00FC2O012O004E00076O004A0007000F3O001237000700174O004A000700113O0004EC3O000802010004EC3O00FC2O010004EC3O000802010004EC3O00F72O01001237000400173O002E4B00A000A9FF2O00A00004EC3O00B22O010026F6000400B22O0100170004EC3O00B22O01001237000300043O0004EC3O001002010004EC3O00B22O0100261601030014020100040004EC3O00140201002E4B00A10072FF2O00A20004EC3O00842O01001237000100A33O0004EC3O001902010004EC3O00842O010004EC3O001902010004EC3O00812O010026162O01001D020100010004EC3O001D0201002E4B00A4001F000100A50004EC3O003A02012O003B000200124O007A0002000100012O003B000200134O007A0002000100010012880002000E4O0008000300013O00122O000400A63O00122O000500A76O0003000500024O0002000200034O000300013O00122O000400A83O00122O000500A96O0003000500024O0002000200034O000200143O00122O0002000E6O000300013O00122O000400AA3O00122O000500AB6O0003000500024O0002000200034O000300013O00122O000400AC3O00122O000500AD6O0003000500024O0002000200034O0002000E3O00122O000100173O0026162O01003E020100A30004EC3O003E0201002E5400AE0007000100AF0004EC3O00070001002E5400B0004A020100B10004EC3O004A02012O003B000200073O0020250102000200B22O000D00020001000200069D0002004C020100010004EC3O004C02012O003B000200033O00202E0102000200212O000501020002000200069D0002004C020100010004EC3O004C0201002E5400B4007B020100B30004EC3O007B0201001237000200014O0084000300033O0026F60002004E020100010004EC3O004E0201001237000300013O002E1E01B6005F020100B50004EC3O005F02010026F60003005F020100170004EC3O005F02012O003B000400153O0026F60004007B020100B70004EC3O007B02012O003B000400163O0020870004000400B84O0005000F6O00068O0004000600024O000400153O00044O007B0201002E5400B90051020100BA0004EC3O00510201000EA300010051020100030004EC3O00510201001237000400013O00261601040068020100170004EC3O00680201002E1E01BB006A020100BC0004EC3O006A0201001237000300173O0004EC3O005102010026160104006E020100010004EC3O006E0201002E5400BD0064020100BE0004EC3O006402012O003B000500163O00202C0005000500BF4O000600066O000700016O0005000700024O000500176O000500176O000500153O00122O000400173O00044O006402010004EC3O005102010004EC3O007B02010004EC3O004E0201002E5400C00010030100C10004EC3O001003012O003B000200103O00064F0002009D02013O0004EC3O009D02012O003B000200103O00202E0102000200C22O000501020002000200064F0002009D02013O0004EC3O009D02012O003B000200103O00202E0102000200C32O000501020002000200064F0002009D02013O0004EC3O009D02012O003B000200103O00202E01020002001E2O000501020002000200064F0002009D02013O0004EC3O009D02012O003B000200033O00202E0102000200C42O003B000400104O001E00020004000200069D0002009D020100010004EC3O009D02012O003B000200033O00202E0102000200212O000501020002000200069D0002009D020100010004EC3O009D02012O003B000200143O00069D0002009F020100010004EC3O009F0201002E4B00C50073000100C60004EC3O00100301001237000200014O0084000300053O002E1E01C7000A030100C80004EC3O000A03010026F60002000A030100170004EC3O000A03012O0084000500053O002616010300AA020100010004EC3O00AA0201002E5400CA00AD020100C90004EC3O00AD0201001237000400014O0084000500053O001237000300173O002616010300B1020100170004EC3O00B10201002E5400CC00A6020100CB0004EC3O00A60201002616010400B7020100010004EC3O00B70201002ECA00CE00B7020100CD0004EC3O00B70201002E1E01CF00B1020100330004EC3O00B102012O003B000600073O0020250106000600D02O000D0006000100022O00E9000500063O002E4B00D10023000100D10004EC3O00DE02012O003B000600033O00202E0106000600212O000501060002000200069D000600C4020100010004EC3O00C40201002E5400D300DE020100D20004EC3O00DE0201002E4B00D4004C000100D40004EC3O001003012O003B000600054O0010010700013O00122O000800D53O00122O000900D66O0007000900024O00060006000700202O0006000600294O00060002000200062O0006001003013O0004EC3O001003012O003B000600184O0097000700053O00202O0007000700D74O000800086O000900016O00060009000200062O0006001003013O0004EC3O001003012O003B000600013O001269000700D83O00122O000800D96O000600086O00065O00044O00100301002O0E011700F0020100050004EC3O00F002012O003B000600184O0027000700053O00202O0007000700DA4O000800086O000900016O00060009000200062O000600EA020100010004EC3O00EA0201002E4B00DB0028000100DC0004EC3O001003012O003B000600013O001269000700DD3O00122O000800DE6O000600086O00065O00044O00100301002E1E01DF0010030100E00004EC3O00100301002E4B00E1001E000100E10004EC3O001003012O003B000600184O00AD000700053O00202O0007000700E24O000800103O00202O0008000800E300122O000A00E46O0008000A00024O000800086O000900016O00060009000200062O0006001003013O0004EC3O001003012O003B000600013O001269000700E53O00122O000800E66O000600086O00065O00044O001003010004EC3O00B102010004EC3O001003010004EC3O00A602010004EC3O00100301000EA3000100A1020100020004EC3O00A10201001237000300014O0084000400043O001237000200173O0004EC3O00A102012O003B000200023O00069D00020015030100010004EC3O00150301002E4B0009002C000100E70004EC3O003F0301001237000200013O0026F60002002D030100010004EC3O002D0301001237000300013O0026160103001D030100010004EC3O001D0301002E54008C0026030100E80004EC3O002603012O003B000400194O000D0004000100020012A8000400E93O001288000400E93O00064F0004002503013O0004EC3O00250301001288000400E94O002D000400023O001237000300173O0026160103002A030100170004EC3O002A0301002E5400EB0019030100EA0004EC3O00190301001237000200173O0004EC3O002D03010004EC3O00190301002E1E01EC0016030100ED0004EC3O001603010026F600020016030100170004EC3O001603012O003B0003001A4O000D0003000100020012A8000300E93O002E4B00EE0005000100EE0004EC3O00390301001288000300E93O00069D0003003B030100010004EC3O003B0301002E1E01EF003F030100F00004EC3O003F0301001288000300E94O002D000300023O0004EC3O003F03010004EC3O00160301002E5400F10046030100F20004EC3O004603012O003B000200033O00202E0102000200F32O000501020002000200064F0002004803013O0004EC3O00480301002E1E01F400D7030100F50004EC3O00D70301002E4B00F6003A000100F60004EC3O008203012O003B000200033O00202E0102000200212O000501020002000200064F0002008203013O0004EC3O00820301001237000200014O0084000300053O0026F600020056030100010004EC3O00560301001237000300014O0084000400043O001237000200173O0026160102005A030100170004EC3O005A0301002E1E01F80051030100F70004EC3O005103012O0084000500053O000EEB0017005F030100030004EC3O005F0301002E5400F9006A030100FA0004EC3O006A03010026F60004005F030100010004EC3O005F03012O003B0006001B4O000D0006000100022O00E9000500063O00064F000500D703013O0004EC3O00D703012O002D000500023O0004EC3O00D703010004EC3O005F03010004EC3O00D703010026160103006E030100010004EC3O006E0301002E5400FC005B030100FB0004EC3O005B0301001237000600013O002E5400FE0075030100FD0004EC3O007503010026F600060075030100170004EC3O00750301001237000300173O0004EC3O005B0301002E542O00016F030100FF0004EC3O006F0301001237000700013O0006AA0007006F030100060004EC3O006F0301001237000400014O0084000500053O001237000600173O0004EC3O006F03010004EC3O005B03010004EC3O00D703010004EC3O005103010004EC3O00D703010012370002002O012O00123700030002012O00063801020089030100030004EC3O008903012O003B000200143O00069D0002008D030100010004EC3O008D030100123700020003012O00123700030004012O000638010300D7030100020004EC3O00D70301001237000200014O0084000300053O001237000600013O0006AA00060095030100020004EC3O00950301001237000300014O0084000400043O001237000200173O001237000600173O0006AA0002008F030100060004EC3O008F03012O0084000500053O00123700060005012O00123700070006012O000658000600B5030100070004EC3O00B50301001237000600013O0006AA000600B5030100030004EC3O00B50301001237000600013O001237000700173O0006AA000700A6030100060004EC3O00A60301001237000300173O0004EC3O00B5030100123700070007012O00123700080008012O000638010800A1030100070004EC3O00A10301001237000700013O000612000700B1030100060004EC3O00B1030100123700070009012O0012370008000A012O000658000700A1030100080004EC3O00A10301001237000400014O0084000500053O001237000600173O0004EC3O00A103010012370006000B012O0012370007000C012O00065800060099030100070004EC3O00990301001237000600173O0006AA00060099030100030004EC3O00990301001237000600013O000612000400C3030100060004EC3O00C303010012370006000D012O0012370007000E012O000658000700BC030100060004EC3O00BC03012O003B0006001C4O000D0006000100022O00E9000500063O00069D000500CC030100010004EC3O00CC03010012370006000F012O00123700070010012O000658000700D7030100060004EC3O00D703012O002D000500023O0004EC3O00D703010004EC3O00BC03010004EC3O00D703010004EC3O009903010004EC3O00D703010004EC3O008F03010004EC3O00D703010004EC3O000700010004EC3O00D703010004EC3O000200012O00BA3O00017O000F3O00028O00026O00F03F025O0036AC40025O0011B340025O008EA740025O0002A040025O00E88240025O0060884003053O005072696E7403233O00C28EB903A3A7F19FA318A2F5D499BF1EA8F5C284BE16B8BCFF85EA15B5F5D59BA314E203063O00D590EBCA77CC030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03243O00111DCD3E27314C3711D12468075F3611DA6A3E631C73568C6478710D2O019E08272C400803073O002D4378BE4A4843002D3O0012373O00014O0084000100013O0026F63O0002000100010004EC3O00020001001237000100013O0026162O01000B000100020004EC3O000B0001002E3D0004000B000100030004EC3O000B0001002E1E0105000E000100060004EC3O000E00012O003B00026O007A0002000100010004EC3O002C00010026F600010005000100010004EC3O00050001001237000200013O000EEB00010015000100020004EC3O00150001002E4B00070011000100080004EC3O002400012O003B000300013O0020D90003000300094O000400023O00122O0005000A3O00122O0006000B6O000400066O00033O000100122O0003000C3O00202O00030003000D4O000400023O00122O0005000E3O00122O0006000F6O000400066O00033O000100122O000200023O0026F600020011000100020004EC3O00110001001237000100023O0004EC3O000500010004EC3O001100010004EC3O000500010004EC3O002C00010004EC3O000200012O00BA3O00017O00", GetFEnv(), ...);

