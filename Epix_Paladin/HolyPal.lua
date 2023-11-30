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
				if (Enum <= 142) then
					if (Enum <= 70) then
						if (Enum <= 34) then
							if (Enum <= 16) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
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
										elseif (Enum == 2) then
											local A = Inst[2];
											Top = (A + Varargsz) - 1;
											for Idx = A, Top do
												local VA = Vararg[Idx - A];
												Stk[Idx] = VA;
											end
										else
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
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
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
									elseif (Enum == 10) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 14) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum == 15) then
									local B = Stk[Inst[4]];
									if B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
							elseif (Enum <= 25) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum == 17) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
									elseif (Enum > 19) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 22) then
									if (Enum > 21) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 24) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 29) then
								if (Enum <= 27) then
									if (Enum == 26) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum == 28) then
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
									if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 31) then
								if (Enum == 30) then
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
										if (Mvm[1] == 142) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
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
							elseif (Enum <= 32) then
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
							elseif (Enum > 33) then
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
						elseif (Enum <= 52) then
							if (Enum <= 43) then
								if (Enum <= 38) then
									if (Enum <= 36) then
										if (Enum > 35) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum > 37) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 40) then
									if (Enum == 39) then
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
								elseif (Enum <= 41) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 42) then
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
							elseif (Enum <= 47) then
								if (Enum <= 45) then
									if (Enum > 44) then
										Env[Inst[3]] = Stk[Inst[2]];
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
								elseif (Enum > 46) then
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
							elseif (Enum <= 49) then
								if (Enum > 48) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 50) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 51) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 56) then
								if (Enum <= 54) then
									if (Enum == 53) then
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
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum == 55) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 58) then
								if (Enum == 57) then
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
								end
							elseif (Enum <= 59) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 60) then
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
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 65) then
							if (Enum <= 63) then
								if (Enum > 62) then
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
							elseif (Enum == 64) then
								if (Inst[2] <= Stk[Inst[4]]) then
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
						elseif (Enum <= 67) then
							if (Enum > 66) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 68) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 69) then
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
					elseif (Enum <= 106) then
						if (Enum <= 88) then
							if (Enum <= 79) then
								if (Enum <= 74) then
									if (Enum <= 72) then
										if (Enum == 71) then
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
									elseif (Enum == 73) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 76) then
									if (Enum > 75) then
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
									elseif (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 77) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 78) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								else
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
									end
								end
							elseif (Enum <= 83) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
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
								elseif (Enum > 82) then
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 85) then
								if (Enum == 84) then
									if (Inst[2] > Stk[Inst[4]]) then
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
							elseif (Enum <= 86) then
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
							elseif (Enum == 87) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 97) then
							if (Enum <= 92) then
								if (Enum <= 90) then
									if (Enum > 89) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 91) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 94) then
								if (Enum == 93) then
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
							elseif (Enum <= 95) then
								Stk[Inst[2]] = Inst[3] ~= 0;
							elseif (Enum > 96) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 101) then
							if (Enum <= 99) then
								if (Enum == 98) then
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
								end
							elseif (Enum == 100) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 103) then
							if (Enum == 102) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 104) then
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
						elseif (Enum > 105) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 124) then
						if (Enum <= 115) then
							if (Enum <= 110) then
								if (Enum <= 108) then
									if (Enum > 107) then
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
								elseif (Enum == 109) then
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
							elseif (Enum <= 112) then
								if (Enum > 111) then
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
							elseif (Enum <= 113) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 114) then
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
						elseif (Enum <= 119) then
							if (Enum <= 117) then
								if (Enum > 116) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 118) then
								VIP = Inst[3];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 121) then
							if (Enum == 120) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 122) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 123) then
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
						end
					elseif (Enum <= 133) then
						if (Enum <= 128) then
							if (Enum <= 126) then
								if (Enum > 125) then
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
							elseif (Enum == 127) then
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
						elseif (Enum <= 130) then
							if (Enum == 129) then
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
						elseif (Enum <= 131) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 132) then
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 137) then
						if (Enum <= 135) then
							if (Enum == 134) then
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
						elseif (Enum > 136) then
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
					elseif (Enum <= 139) then
						if (Enum == 138) then
							Stk[Inst[2]] = #Stk[Inst[3]];
						else
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
						end
					elseif (Enum <= 140) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
					elseif (Enum > 141) then
						Stk[Inst[2]] = Stk[Inst[3]];
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
				elseif (Enum <= 214) then
					if (Enum <= 178) then
						if (Enum <= 160) then
							if (Enum <= 151) then
								if (Enum <= 146) then
									if (Enum <= 144) then
										if (Enum > 143) then
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
									elseif (Enum > 145) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 149) then
									if (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 150) then
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
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
								end
							elseif (Enum <= 155) then
								if (Enum <= 153) then
									if (Enum == 152) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 154) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 157) then
								if (Enum == 156) then
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
							elseif (Enum <= 158) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, Top);
								end
							elseif (Enum == 159) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 169) then
							if (Enum <= 164) then
								if (Enum <= 162) then
									if (Enum == 161) then
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
										Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
									end
								elseif (Enum > 163) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 166) then
								if (Enum == 165) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 167) then
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
							elseif (Enum == 168) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 173) then
							if (Enum <= 171) then
								if (Enum == 170) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 172) then
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
						elseif (Enum <= 175) then
							if (Enum > 174) then
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 176) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 177) then
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
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						end
					elseif (Enum <= 196) then
						if (Enum <= 187) then
							if (Enum <= 182) then
								if (Enum <= 180) then
									if (Enum > 179) then
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
								elseif (Enum == 181) then
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
							elseif (Enum <= 184) then
								if (Enum > 183) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 185) then
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
							elseif (Enum > 186) then
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
						elseif (Enum <= 191) then
							if (Enum <= 189) then
								if (Enum == 188) then
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
							elseif (Enum == 190) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum <= 193) then
							if (Enum == 192) then
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
								Stk[Inst[2]] = Stk[Inst[3]];
							end
						elseif (Enum <= 194) then
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
						elseif (Enum > 195) then
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
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 205) then
						if (Enum <= 200) then
							if (Enum <= 198) then
								if (Enum > 197) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum == 199) then
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
						elseif (Enum <= 202) then
							if (Enum > 201) then
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
						elseif (Enum <= 203) then
							local A = Inst[2];
							Stk[A] = Stk[A]();
						elseif (Enum > 204) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 209) then
						if (Enum <= 207) then
							if (Enum == 206) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 208) then
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
						elseif (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 211) then
						if (Enum == 210) then
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
					elseif (Enum <= 212) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 213) then
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
					elseif (Inst[2] < Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 250) then
					if (Enum <= 232) then
						if (Enum <= 223) then
							if (Enum <= 218) then
								if (Enum <= 216) then
									if (Enum == 215) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 217) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 220) then
								if (Enum > 219) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 222) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 227) then
							if (Enum <= 225) then
								if (Enum == 224) then
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
							elseif (Enum == 226) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 229) then
							if (Enum == 228) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 230) then
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum == 231) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 241) then
						if (Enum <= 236) then
							if (Enum <= 234) then
								if (Enum > 233) then
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
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								end
							elseif (Enum > 235) then
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
						elseif (Enum <= 238) then
							if (Enum == 237) then
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							else
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 239) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 240) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 245) then
						if (Enum <= 243) then
							if (Enum == 242) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 244) then
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
					elseif (Enum <= 247) then
						if (Enum > 246) then
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
					elseif (Enum <= 248) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum == 249) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					else
						Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
					end
				elseif (Enum <= 268) then
					if (Enum <= 259) then
						if (Enum <= 254) then
							if (Enum <= 252) then
								if (Enum > 251) then
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
							elseif (Enum == 253) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 256) then
							if (Enum > 255) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 257) then
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
						elseif (Enum > 258) then
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
					elseif (Enum <= 263) then
						if (Enum <= 261) then
							if (Enum > 260) then
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
						elseif (Enum > 262) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						end
					elseif (Enum <= 265) then
						if (Enum > 264) then
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
				elseif (Enum <= 277) then
					if (Enum <= 272) then
						if (Enum <= 270) then
							if (Enum == 269) then
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
							end
						elseif (Enum == 271) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 274) then
						if (Enum > 273) then
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
					elseif (Enum <= 275) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 276) then
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
					else
						Stk[Inst[2]] = {};
					end
				elseif (Enum <= 281) then
					if (Enum <= 279) then
						if (Enum > 278) then
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
					elseif (Enum > 280) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						do
							return;
						end
					end
				elseif (Enum <= 283) then
					if (Enum == 282) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif not Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 284) then
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
				elseif (Enum == 285) then
					Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
				else
					Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503183O00F4D3D23DD98BC612D0C7D22BD993C812C8F3DA29A8B7D21F03083O007EB1A3BB4586DBA703183O00DF3E3D5C7809B638FB2A3D4A7811B838E31E35480935A23503083O00549A4E54242759D7002E3O0012453O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004763O000A000100120E000300063O00201D01040003000700120E000500083O00201D01050005000900120E000600083O00201D01060006000A00061E00073O000100062O008E3O00064O008E8O008E3O00044O008E3O00014O008E3O00024O008E3O00053O00201D01080003000B00201D01090003000C2O0014010A5O00120E000B000D3O00061E000C0001000100022O008E3O000A4O008E3O000B4O008E000D00073O001272000E000E3O001272000F000F4O00E4000D000F000200061E000E0002000100032O008E3O00074O008E3O00094O008E3O00085O00010A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O003300025O00122O000300016O00045O00122O000500013O00042O0003002100012O000C01076O00B5000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004D60003000500012O000C010300054O008E000400024O00E9000300044O009E00036O0018012O00017O00093O00028O00025O002OA040025O00689B40026O00F03F025O00E8B140025O0090A940025O004C9040025O00CCAB40025O00C0514001343O001272000200014O00F9000300043O00265300020006000100010004763O00060001002E4B00020009000100030004763O00090001001272000300014O00F9000400043O001272000200043O000ECF00040002000100020004763O00020001001272000500013O00265300050010000100010004763O00100001002E4B0005000C000100060004763O000C0001000ECF00040016000100030004763O001600012O008E000600044O000200076O006600066O009E00065O00261A0103000B000100010004763O000B0001001272000600013O002E4B00070027000100080004763O0027000100261A01060027000100010004763O002700012O000C01076O005C000400073O00061B01040026000100010004763O002600012O000C010700014O008E00086O000200096O006600076O009E00075O001272000600043O002EC5000900F2FF2O00090004763O0019000100261A01060019000100040004763O00190001001272000300043O0004763O000B00010004763O001900010004763O000B00010004763O000C00010004763O000B00010004763O003300010004763O000200012O0018012O00017O00433O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503053O0001A3401AAF03073O002654D72976DC4603043O0065182B0603053O009E3076427203053O008D2B13236003073O009BCB44705613C503063O0076D137E5456A03083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C703063O009C7C6E2F166003083O0023C81D1C4873149A2O033O0029BAC503073O005479DFB1BFED4C03053O008846CCAC3603083O00A1DB36A9C05A305003043O006056052803043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O002FBB8825D603053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D903043O006D61746803053O00C1587F1BAB03063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D479030C3O00476574546F74656D496E666F03073O0047657454696D6503073O0037EFA9CF03E7AB03043O00AE678EC503043O007E27532103073O009836483F58453E03073O00E4C5E25DD0CDE003043O003CB4A48E03043O007051093003073O0072383E6549478D03073O0088E8D7C5BCE0D503043O00A4D889BB03043O00FAE93DAB03073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703063O0053657441504C025O0040504000F2013O0057000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000400074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000700084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000700094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0007000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0007000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0007000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0013001300142O000C01145O001251001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000F00144O00155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O00140014001500122O0015002A6O00165O00122O0017002B3O00122O0018002C6O0016001800024O00150015001600122O0016002D6O00175O00122O0018002E3O00122O0019002F6O0017001900024O00160016001700122O001700303O00122O001800316O00195O00122O001A00323O00122O001B00336O0019001B00024O0019000D00194O001A5O00122O001B00343O00122O001C00356O001A001C00024O00190019001A4O001A5O00122O001B00363O00122O001C00376O001A001C00024O001A000E001A4O001B5O00122O001C00383O00122O001D00396O001B001D00024O001A001A001B4O001B5O00122O001C003A3O00122O001D003B6O001B001D00024O001B0011001B4O001C5O00122O001D003C3O00122O001E003D6O001C001E00024O001B001B001C4O001C00706O00718O00728O00738O00748O00758O00768O007700786O00795O00122O007A003E3O00122O007B003F6O0079007B00024O0079000F00794O007A5O00122O007B00403O00122O007C00416O007A007C00022O005C00790079007A00061E007A3O000100012O008E3O00193O00061E007B0001000100072O008E3O00174O008E3O00194O000C017O008E3O00154O000C012O00014O000C012O00024O008E3O00183O00061E007C0002000100022O008E3O00194O008E3O00373O00061E007D0003000100072O008E3O00124O008E3O001B4O000C017O008E3O00194O008E3O00094O008E3O00084O008E3O00793O00061E007E0004000100032O008E3O00794O008E3O00764O008E3O00723O00061E007F0005000100032O008E3O00094O008E3O00794O008E3O00193O00061E00800006000100062O008E3O00084O008E3O00794O008E3O00194O000C017O008E3O00124O008E3O001B3O00061E00810007000100042O008E3O00194O000C017O008E3O000B4O008E3O00123O00061E00820008000100112O008E3O00094O008E3O00394O008E3O00384O008E3O00194O000C017O008E3O00124O008E3O001B4O008E3O003D4O008E3O003C4O008E3O001D4O008E3O001F4O008E3O001E4O008E3O001A4O008E3O00504O008E3O004F4O008E3O00304O008E3O00313O00061E008300090001000A2O008E3O00794O008E3O00764O008E3O00724O008E3O00194O000C017O008E3O00124O008E3O00334O008E3O00094O008E3O00324O008E3O007D3O00061E0084000A000100172O008E3O00194O000C017O008E3O00794O008E3O00554O008E3O00564O008E3O00504O008E3O00094O008E3O00124O008E3O000B4O008E3O00784O008E3O001B4O008E3O000A4O008E3O007B4O008E3O005B4O008E3O00344O008E3O007C4O008E3O00354O008E3O00364O008E3O00754O008E3O00774O008E3O00724O008E3O00834O008E3O003F3O00061E0085000B000100262O008E3O00194O000C017O008E3O00794O008E3O00584O008E3O00594O008E3O00574O008E3O00124O008E3O001B4O008E3O00084O008E3O00494O008E3O00484O008E3O00094O008E3O00474O008E3O00464O008E3O00524O008E3O00534O008E3O00514O008E3O00664O008E3O00644O008E3O00654O008E3O00634O008E3O00624O008E3O006B4O008E3O006C4O008E3O006A4O008E3O00444O008E3O00454O008E3O00434O008E3O00414O008E3O00424O008E3O00404O008E3O00674O008E3O00684O008E3O00694O008E3O00394O008E3O00384O008E3O00604O008E3O00613O00061E0086000C000100132O008E3O00194O000C017O008E3O00094O008E3O00084O008E3O00504O008E3O00794O008E3O00124O008E3O001B4O008E3O004F4O008E3O00554O008E3O00564O008E3O00524O008E3O00534O008E3O00514O008E3O007B4O008E3O000B4O008E3O005E4O008E3O005F4O008E3O000A3O00061E0087000D000100172O008E3O00194O000C017O008E3O00084O008E3O00124O008E3O001B4O008E3O004E4O008E3O004D4O008E3O004B4O008E3O004A4O008E3O00094O008E3O004C4O008E3O005C4O008E3O005A4O008E3O00794O008E3O005E4O008E3O005F4O008E3O005D4O008E3O000B4O008E3O000A4O008E3O00504O008E3O004F4O008E3O00494O008E3O00483O00061E0088000E000100032O008E3O00874O008E3O00084O008E3O00863O00061E0089000F000100152O008E3O00824O008E3O006F4O000C017O008E3O00194O008E3O00794O008E3O00124O008E3O001B4O008E3O00704O008E3O00084O008E3O000D4O008E3O007F4O008E3O00884O008E3O00244O008E3O00804O008E3O00264O008E3O00834O008E3O00844O008E3O00854O008E3O00274O008E3O00284O008E3O00093O00061E008A0010000100102O008E3O00244O008E3O00804O008E3O00264O008E3O00794O008E3O00194O008E3O001B4O008E3O00274O008E3O00284O008E3O00094O000C017O008E3O00124O008E3O00714O008E3O006F4O008E3O00704O008E3O00884O008E3O00813O00061E008B00110001002B2O008E3O002B4O000C017O008E3O00304O008E3O00314O008E3O00324O008E3O00334O008E3O00484O008E3O00494O008E3O00284O008E3O00294O008E3O002A4O008E3O00264O008E3O00274O008E3O00214O008E3O00224O008E3O00254O008E3O00234O008E3O00244O008E3O00434O008E3O00444O008E3O00474O008E3O00454O008E3O00464O008E3O00344O008E3O00354O008E3O00384O008E3O00364O008E3O00374O008E3O00204O008E3O001E4O008E3O001F4O008E3O001C4O008E3O001D4O008E3O003B4O008E3O003C4O008E3O003D4O008E3O00394O008E3O003A4O008E3O004F4O008E3O003F4O008E3O00424O008E3O00404O008E3O00413O00061E008C0012000100282O008E3O004A4O000C017O008E3O004B4O008E3O004E4O008E3O004C4O008E3O004D4O008E3O005D4O008E3O00594O008E3O005A4O008E3O005B4O008E3O005C4O008E3O006C4O008E3O006A4O008E3O006B4O008E3O00684O008E3O00694O008E3O004F4O008E3O00504O008E3O00514O008E3O00524O008E3O00534O008E3O00544O008E3O00554O008E3O00564O008E3O00574O008E3O00584O008E3O00634O008E3O00644O008E3O00674O008E3O00654O008E3O00664O008E3O006D4O008E3O006E4O008E3O006F4O008E3O00704O008E3O005E4O008E3O005F4O008E3O00604O008E3O00614O008E3O00623O00061E008D0013000100132O008E3O00734O000C017O008E3O00744O008E3O00754O008E3O00094O008E3O008B4O008E3O008C4O008E3O00714O008E3O00724O008E3O000B4O008E3O00794O008E3O00194O008E3O00124O008E3O00244O008E3O001B4O008E3O00774O008E3O00784O008E3O00894O008E3O008A3O00061E008E0014000100042O008E3O000F4O000C017O008E3O00794O008E3O00063O00208F008F000F004200122O009000436O0091008D6O0092008E6O008F009200016O00013O00153O00023O0003113O00446562752O665265667265736861626C65030E3O004A7564676D656E74446562752O6601063O00208700013O00014O00035O00202O0003000300024O000100036O00019O0000017O000C3O00028O00025O00D2A540025O00888140025O00788C40026O00F03F026O001040025O00288540025O002FB040030C3O00323FBC2B4B343B1024BB374003073O00497150D2582E5703043O004E616D65026O00E03F00403O0012723O00013O002EC500023O000100020004763O0001000100261A012O0001000100010004763O00010001001272000100013O0026530001000A000100010004763O000A0001002ED500040006000100030004763O00060001001272000200053O001272000300063O001272000400053O0004C40002003B0001001272000600014O00F90007000A3O00265300060014000100010004763O00140001002E4B00080010000100070004763O001000012O000C010B6O000E010C00056O000B0002000E4O000A000E6O0009000D6O0008000C6O0007000B6O000B00016O000C00023O00122O000D00093O00122O000E000A4O00E4000C000E00022O005C000B000B000C00204E000B000B000B2O00F5000B000200020006840008003A0001000B0004763O003A00012O000C010B00034O0089000C00046O000D00096O000E000A6O000C000E00024O000D00056O000E00096O000F000A6O000D000F00024O000C000C000D4O000D00066O000D000100024O000C000C000D00202O000C000C000C4O000B0002000200062O000B0037000100010004763O00370001001272000B00014O003C000B00023O0004763O003A00010004763O001000010004D60002000E0001001272000200014O003C000200023O0004763O000600010004763O000100012O0018012O00017O00023O0003113O00446562752O665265667265736861626C6503123O00476C692O6D65726F664C6967687442752O66010A3O00207400013O00014O00035O00202O0003000300024O00010003000200062O00010008000100010004763O000800012O000C2O0100014O00C3000100014O003C000100024O0018012O00017O00253O00028O00025O0046B140025O00E8A140026O00F03F03053O007061697273030A3O0049734361737461626C6503163O00426C652O73696E676F6653752O6D6572506C61796572025O0074AA40025O00F8A34003173O0045C030CF174EC232E30B41F321D40178DF30DD1748C22603053O006427AC55BC025O0044B340025O00308C40025O00707F40025O00449640025O0007B34003103O00A320C801F48822CA1DE1B239C01FE29303053O0087E14CAD7203093O004973496E506172747903083O004973496E5261696403063O00457869737473030D3O00556E697447726F7570526F6C6503073O003ECC95918B989503073O00C77A8DD8D0CCDD025O00A6A340025O00D0A14003153O00426C652O73696E676F6653752O6D6572466F63757303123O00AFD115E36BFFA3DA2FFF7EC9BEC81DFD7DE403063O0096CDBD70901803103O000788BA5F17811F172A828C5C16811F1703083O007045E4DF2C64E87103103O00F61302C0A57588D31001E0A3718BD10D03073O00E6B47F67B3D61C03103O00AE095A55F748EE8B0A5967F155F5810B03073O0080EC653F26842103103O008EA51457A5E2C1ABA61773BFE5DBA9BB03073O00AFCCC97124D68B00873O0012723O00014O00F9000100013O002ED50003001E000100020004763O001E000100261A012O001E000100040004763O001E000100120E000200054O008E000300014O00E60002000200040004763O001B000100204E0007000600062O00F50007000200020006F70007001B00013O0004763O001B00012O000C01076O000C010800013O00201D0108000800072O00F500070002000200061B01070016000100010004763O00160001002E4B0008001B000100090004763O001B00012O000C010700023O0012720008000A3O0012720009000B4O00E9000700094O009E00075O002O060102000A000100020004763O000A00010004763O008600010026533O0022000100010004763O00220001002ED5000C00020001000D0004763O00020001001272000200013O00261A01020027000100040004763O002700010012723O00043O0004763O00020001000ECF00010023000100020004763O00230001001272000300013O0026530003002E000100040004763O002E0001002E4B000F00300001000E0004763O00300001001272000200043O0004763O0023000100261A0103002A000100010004763O002A0001002EC500100035000100100004763O006700012O000C010400034O0008010500023O00122O000600113O00122O000700126O0005000700024O00040004000500202O0004000400064O00040002000200062O0004006700013O0004763O006700012O000C010400043O00204E0004000400132O00F50004000200020006F70004006700013O0004763O006700012O000C010400043O00204E0004000400142O00F500040002000200061B01040067000100010004763O006700012O000C010400053O0006F70004006700013O0004763O006700012O000C010400053O00204E0004000400152O00F50004000200020006F70004006700013O0004763O006700012O000C010400063O00201D0104000400162O000C010500054O00F50004000200022O0050000500023O00122O000600173O00122O000700186O00050007000200062O00040067000100050004763O00670001002ED5001A0067000100190004763O006700012O000C01046O000C010500013O00201D01050005001B2O00F50004000200020006F70004006700013O0004763O006700012O000C010400023O0012720005001C3O0012720006001D4O00E9000400064O009E00046O0014010400044O0009000500036O000600023O00122O0007001E3O00122O0008001F6O0006000800024O0005000500064O000600036O000700023O00122O000800203O00122O000900214O00E40007000900022O003A0006000600074O000700036O000800023O00122O000900223O00122O000A00236O0008000A00024O0007000700084O000800036O000900023O00122O000A00243O001272000B00254O00E40009000B00022O005C0008000800092O00EE0004000400012O008E000100043O001272000300043O0004763O002A00010004763O002300010004763O000200012O0018012O00017O000B3O00028O00025O0080A740026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00707240025O0038884003103O0048616E646C65546F705472696E6B6574025O00DCB240025O0096A74000293O0012723O00013O002EC500020012000100020004763O0013000100261A012O0013000100030004763O001300012O000C2O015O0020900001000100054O000200016O000300023O00122O000400066O000500056O00010005000200122O000100043O00122O000100043O00062O0001002800013O0004763O0028000100120E000100044O003C000100023O0004763O00280001002ED500070001000100080004763O0001000100261A012O0001000100010004763O000100012O000C2O015O0020BF0001000100094O000200016O000300023O00122O000400066O000500056O00010005000200122O000100043O00122O000100043O00062O00010024000100010004763O00240001002E4B000A00260001000B0004763O0026000100120E000100044O003C000100023O0012723O00033O0004763O000100012O0018012O00017O00103O00025O001AA240025O00CCA04003093O00497343617374696E67030C3O0049734368612O6E656C696E67028O0003093O00496E74652O7275707403063O00526562756B65026O001440025O0098A840025O00188740026O00F03F025O00E0B140025O003AB24003113O00496E74652O72757074576974685374756E030F3O0048612O6D65726F664A757374696365026O002040002F3O002E4B0002002E000100010004763O002E00012O000C016O00204E5O00032O00F53O0002000200061B012O002E000100010004763O002E00012O000C016O00204E5O00042O00F53O0002000200061B012O002E000100010004763O002E00010012723O00054O00F9000100013O00261A012O001E000100050004763O001E00012O000C010200013O00202O0002000200064O000300023O00202O00030003000700122O000400086O000500016O0002000500024O000100023O00062O0001001C000100010004763O001C0001002EC5000900030001000A0004763O001D00012O003C000100023O0012723O000B3O002ED5000C000E0001000D0004763O000E000100261A012O000E0001000B0004763O000E00012O000C010200013O00201501020002000E4O000300023O00202O00030003000F00122O000400106O0002000400024O000100023O00062O0001002E00013O0004763O002E00012O003C000100023O0004763O002E00010004763O000E00012O0018012O00017O000F3O00028O00025O0006AE40025O00ACA740025O00B4A340025O00C0984003063O0045786973747303093O004973496E52616E6765026O00444003173O0044697370652O6C61626C65467269656E646C79556E697403073O008E74BC813DBE7D03053O0053CD18D9E003073O0049735265616479030C3O00436C65616E7365466F637573030E3O00E5C9C83CE8D6C87DE2CCDE2DE3C903043O005D86A5AD00393O0012723O00014O00F9000100013O00261A012O0002000100010004763O00020001001272000100013O000E9500010009000100010004763O00090001002EC5000200FEFF2O00030004763O00050001002ED50005001F000100040004763O001F00012O000C01025O0006F70002001E00013O0004763O001E00012O000C01025O00204E0002000200062O00F50002000200020006F70002001E00013O0004763O001E00012O000C01025O00204E000200020007001272000400084O00E40002000400020006F70002001E00013O0004763O001E00012O000C010200013O00201D0102000200092O00CB00020001000200061B0102001F000100010004763O001F00012O0018012O00014O000C010200024O0008010300033O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002003800013O0004763O003800012O000C010200044O000C010300053O00201D01030003000D2O00F50002000200020006F70002003800013O0004763O003800012O000C010200033O00120A0103000E3O00122O0004000F6O000200046O00025O00044O003800010004763O000500010004763O003800010004763O000200012O0018012O00017O00133O00028O00025O005AA940030C3O009DFDCFD13FCDA07FAAFBCECC03083O001EDE92A1A25AAED2030A3O0049734361737461626C65030E3O004973496E4D656C2O6552616E6765026O001440030C3O00436F6E736563726174696F6E03163O00E6417E19E04D620BF14B301AF74B7305E84C711EA51A03043O006A852E1003083O00723577FB5745563403063O00203840139C3A03073O004973526561647903083O004A7564676D656E74030E3O0049735370652O6C496E52616E6765025O006AB140025O0014A74003143O0050DDE15157F78E4E88F5445FF18F57CAE4421AA403073O00E03AA885363A9200463O0012723O00014O00F9000100013O002EC500023O000100020004763O0002000100261A012O0002000100010004763O00020001001272000100013O000ECF00010007000100010004763O000700012O000C01026O0008010300013O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002002400013O0004763O002400012O000C010200023O00204E000200020006001272000400074O00E40002000400020006F70002002400013O0004763O002400012O000C010200034O000C01035O00201D0103000300082O00F50002000200020006F70002002400013O0004763O002400012O000C010200013O001272000300093O0012720004000A4O00E9000200044O009E00026O000C01026O0008010300013O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002004500013O0004763O004500012O000C010200034O000201035O00202O00030003000E4O000400023O00202O00040004000F4O00065O00202O00060006000E4O0004000600024O000400046O00020004000200062O0002003C000100010004763O003C0001002E4B00100045000100110004763O004500012O000C010200013O00120A010300123O00122O000400136O000200046O00025O00044O004500010004763O000700010004763O004500010004763O000200012O0018012O00017O00353O00028O00025O0040A040025O00307D40026O004D40025O0050834003103O004865616C746850657263656E74616765030A3O00755752F27BAE86055D4503083O006B39362B9D15E6E7030A3O0049734361737461626C65025O00D88B40025O008EAC4003103O004C61796F6E48616E6473506C6179657203163O00D78A08CAB6D2F0D38A1FF1AA9CCBDE8D14FBAAD5D9DE03073O00AFBBEB7195D9BC03103O0018A69745ED7C482EA09549E06D7133A103073O00185CCFE12C831903103O00446976696E6550726F74656374696F6E03113O004FDAAE4515780BC3AA430F7848C7B1431503063O001D2BB3D82C7B026O00F03F025O00BFB040025O004CAC40027O0040026O004140025O0012A44003193O008A27780C21E8E7B12C795E0CFEEEB42B701964CBE0AC2B711003073O008FD8421E7E449B03173O0098CD0BD9C0B0DFE8A4CF25CEC4AFDEEFADF802DFCCACD903083O0081CAA86DABA5C3B703073O004973526561647903173O0052656672657368696E674865616C696E67506F74696F6E03253O00305D31CADB07EE2B563098D611E72E5139DF9E04E9365138D69E10E3245D39CBD702E3620C03073O0086423857B8BE74025O0078A640025O00AC9440025O00B89F40030B3O008AD63248B2DF0740B2CB3903043O002CDDB94003093O00486F6C79506F776572026O000840030F3O004865616C696E674162736F7262656403113O00576F72646F66476C6F7279506C61796572025O00E09F40025O0050854003083O0036C86F1F6004EB4E03053O00136187283F030B3O00865932373B39BD483C352A03063O0051CE3C535B4F025O00D07040025O009CA240030B3O004865616C746873746F6E6503173O0046AED17E3BCB5EB041A5D5322BC64BA140B8D9642A831E03083O00C42ECBB0124FA32D00DF3O0012723O00014O00F9000100013O0026533O0006000100010004763O00060001002E4B00020002000100030004763O00020001001272000100013O00261A2O010054000100010004763O00540001001272000200013O002ED50004004D000100050004763O004D0001000ECF0001004D000100020004763O004D00012O000C01035O00204E0003000300062O00F50003000200022O000C010400013O00066700030021000100040004763O002100012O000C010300023O0006F70003002100013O0004763O002100012O000C010300034O009F000400043O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O00030023000100010004763O00230001002ED5000B002E0001000A0004763O002E00012O000C010300054O000C010400063O00201D01040004000C2O00F50003000200020006F70003002E00013O0004763O002E00012O000C010300043O0012720004000D3O0012720005000E4O00E9000300054O009E00036O000C010300034O0008010400043O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300094O00030002000200062O0003004C00013O0004763O004C00012O000C01035O00204E0003000300062O00F50003000200022O000C010400073O0006670003004C000100040004763O004C00012O000C010300083O0006F70003004C00013O0004763O004C00012O000C010300054O000C010400033O00201D0104000400112O00F50003000200020006F70003004C00013O0004763O004C00012O000C010300043O001272000400123O001272000500134O00E9000300054O009E00035O001272000200143O00265300020051000100140004763O00510001002ED50015000A000100160004763O000A0001001272000100143O0004763O005400010004763O000A000100261A2O010080000100170004763O008000012O000C010200093O0006F7000200DE00013O0004763O00DE00012O000C01025O00204E0002000200062O00F50002000200022O000C0103000A3O000667000200DE000100030004763O00DE0001002E4B001800DE000100190004763O00DE00012O000C0102000B4O0050000300043O00122O0004001A3O00122O0005001B6O00030005000200062O000200DE000100030004763O00DE00012O000C0102000C4O0008010300043O00122O0004001C3O00122O0005001D6O0003000500024O00020002000300202O00020002001E4O00020002000200062O000200DE00013O0004763O00DE00012O000C010200054O00E0000300063O00202O00030003001F4O000400056O000600016O00020006000200062O000200DE00013O0004763O00DE00012O000C010200043O00120A010300203O00122O000400216O000200046O00025O00044O00DE000100261A2O010007000100140004763O00070001001272000200013O00265300020087000100010004763O00870001002EC500220051000100230004763O00D60001002EC50024002C000100240004763O00B300012O000C010300034O0008010400043O00122O000500253O00122O000600266O0004000600024O00030003000400202O00030003001E4O00030002000200062O000300B300013O0004763O00B300012O000C01035O00204E0003000300272O00F5000300020002000E40002800B3000100030004763O00B300012O000C01035O00204E0003000300062O00F50003000200022O000C0104000D3O000667000300B3000100040004763O00B300012O000C0103000E3O0006F7000300B300013O0004763O00B300012O000C01035O00204E0003000300292O00F500030002000200061B010300B3000100010004763O00B300012O000C010300054O000C010400063O00201D01040004002A2O00F500030002000200061B010300AE000100010004763O00AE0001002EC5002B00070001002C0004763O00B300012O000C010300043O0012720004002D3O0012720005002E4O00E9000300054O009E00036O000C0103000C4O0008010400043O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O00030003001E4O00030002000200062O000300C600013O0004763O00C600012O000C0103000F3O0006F7000300C600013O0004763O00C600012O000C01035O00204E0003000300062O00F50003000200022O000C010400103O0006ED00030003000100040004763O00C80001002ED5003200D5000100310004763O00D500012O000C010300054O00E0000400063O00202O0004000400334O000500066O000700016O00030007000200062O000300D500013O0004763O00D500012O000C010300043O001272000400343O001272000500354O00E9000300054O009E00035O001272000200143O00261A01020083000100140004763O00830001001272000100173O0004763O000700010004763O008300010004763O000700010004763O00DE00010004763O000200012O0018012O00017O004A3O00028O00026O00F03F025O00208A40025O0024B040026O00084003133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O005AA740025O009C9040025O00CCA240025O002AA94003083O008951A441AA5CBF4D03043O0020DA34D603073O0049735265616479025O00DEAB40025O006BB14003083O00536572617068696D03153O005D1223A9E1B84C570E143EA7FDB44A4D400471F9A903083O003A2E7751C891D025025O00109D40025O0022A040025O0096A040025O001EB340025O0046AC40030A3O00FB16E21534DA2BFB103603053O005ABF7F947C030A3O0049734361737461626C6503063O0042752O66557003113O004176656E67696E67577261746842752O66030A3O00446976696E65546F2O6C03173O007C8E381E76821103778B22577B88211B7C8839196BC77603043O007718E74E025O00A8A040025O000EAA4003093O00A021AA45D86604903403073O0071E24DC52ABC2003093O00426C2O6F6446757279025O007DB140025O0022AC4003173O00381AFBBA3E29F2A0280FB4B63519F8B13501FAA67A47A603043O00D55A7694025O002CAB40025O00688240030A3O00792BA645484925BD584A03053O002D3B4ED436030A3O004265727365726B696E6703173O0012539198833CA6F91E51C3888921A1F41F418D98C67FF903083O00907036E3EBE64ECD027O0040025O00109B40025O00406040030D3O001D270CB51EE22F320B2308AF1103083O00555C5169DB798B41030D3O004176656E67696E675772617468031A3O00FCA5554B7BD6F3B46F526EDEE9BB104673D0F1B75F5272CCBDE703063O00BF9DD330251C025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA40030B3O009B2703E5F14DB62608F9C203063O003BD3486F9CB0030B3O00486F6C794176656E676572025O0084AB40025O00C4A04003193O004688EF347186F5284080E63F0E84EC224283EC3A4094A37C1803043O004D2EE78303103O0048616E646C65546F705472696E6B6574025O0046AB40025O0074A940025O0061B140025O0078AC400015012O0012723O00014O00F9000100023O00261A012O000E2O0100020004763O000E2O01002ED50003002F000100040004763O002F000100261A2O01002F000100050004763O002F00012O000C01035O00202F0003000300064O000400016O000500023O00122O000600076O000700076O0003000700024O000200033O002E2O00090015000100080004763O001500010006F70002001500013O0004763O001500012O003C000200023O002E4B000A00142O01000B0004763O00142O012O000C010300034O0008010400043O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300142O013O0004763O00142O01002ED5000F00142O0100100004763O00142O012O000C010300054O000C010400033O00201D0104000400112O00F50003000200020006F7000300142O013O0004763O00142O012O000C010300043O00120A010400123O00122O000500136O000300056O00035O00044O00142O0100265300010033000100020004763O00330001002E4B00150098000100140004763O00980001001272000300014O00F9000400043O000ECF00010035000100030004763O00350001001272000400013O0026530004003C000100010004763O003C0001002E4B0017007A000100160004763O007A0001002EC500180024000100180004763O006000012O000C010500063O0006F70005006000013O0004763O006000012O000C010500023O0006F70005006000013O0004763O006000012O000C010500034O0008010600043O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005006000013O0004763O006000012O000C010500073O00201001050005001C4O000700033O00202O00070007001D4O00050007000200062O0005006000013O0004763O006000012O000C010500054O000C010600033O00201D01060006001E2O00F50005000200020006F70005006000013O0004763O006000012O000C010500043O0012720006001F3O001272000700204O00E9000500074O009E00055O002ED500210079000100220004763O007900012O000C010500034O0008010600043O00122O000700233O00122O000800246O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005007900013O0004763O007900012O000C010500054O000C010600033O00201D0106000600252O00F500050002000200061B01050074000100010004763O00740001002E4B00260079000100270004763O007900012O000C010500043O001272000600283O001272000700294O00E9000500074O009E00055O001272000400023O0026530004007E000100020004763O007E0001002EC5002A00BCFF2O002B0004763O003800012O000C010500034O0008010600043O00122O0007002C3O00122O0008002D6O0006000800024O00050005000600202O00050005001B4O00050002000200062O0005009300013O0004763O009300012O000C010500054O000C010600033O00201D01060006002E2O00F50005000200020006F70005009300013O0004763O009300012O000C010500043O0012720006002F3O001272000700304O00E9000500074O009E00055O001272000100313O0004763O009800010004763O003800010004763O009800010004763O0035000100261A2O0100D7000100010004763O00D70001001272000300013O000ECF000100CD000100030004763O00CD0001001272000400013O00261A010400A2000100020004763O00A20001001272000300023O0004763O00CD000100261A0104009E000100010004763O009E0001002E4B003300C8000100320004763O00C800012O000C010500083O0006F7000500C800013O0004763O00C800012O000C010500023O0006F7000500C800013O0004763O00C800012O000C010500034O0008010600043O00122O000700343O00122O000800356O0006000800024O00050005000600202O00050005000E4O00050002000200062O000500C800013O0004763O00C800012O000C010500073O00207400050005001C4O000700033O00202O00070007001D4O00050007000200062O000500C8000100010004763O00C800012O000C010500054O000C010600033O00201D0106000600362O00F50005000200020006F7000500C800013O0004763O00C800012O000C010500043O001272000600373O001272000700384O00E9000500074O009E00056O000C010500094O00CB0005000100022O008E000200053O001272000400023O0004763O009E0001002653000300D1000100020004763O00D10001002ED5003A009B000100390004763O009B00010006F7000200D400013O0004763O00D400012O003C000200023O001272000100023O0004763O00D700010004763O009B0001002E4B003B00040001003C0004763O0004000100261A2O010004000100310004763O00040001001272000300013O002E4B003D2O002O01003E0004764O002O0100261A01032O002O0100010004764O002O012O000C010400034O0008010500043O00122O0006003F3O00122O000700406O0005000700024O00040004000500202O00040004001B4O00040002000200062O000400F700013O0004763O00F700012O000C010400054O000C010500033O00201D0105000500412O00F500040002000200061B010400F2000100010004763O00F20001002ED5004200F7000100430004763O00F700012O000C010400043O001272000500443O001272000600454O00E9000400064O009E00046O000C01045O0020050104000400464O000500016O000600023O00122O000700076O000800086O0004000800024O000200043O00122O000300023O002653000300042O0100020004763O00042O01002E4B004700DC000100480004763O00DC000100061B010200082O0100010004763O00082O01002ED5004900092O01004A0004763O00092O012O003C000200023O001272000100053O0004763O000400010004763O00DC00010004763O000400010004763O00142O0100261A012O0002000100010004763O00020001001272000100014O00F9000200023O0012723O00023O0004763O000200012O0018012O00017O00E53O00028O00027O0040025O00206340025O007C9D40025O00949B40026O008440030B3O00ED4B35DE11CE4416D712CF03053O0065A12252B603073O004973526561647903093O00C91A58F5DEEC8B20EF03083O004E886D399EBB82E2030B3O004973417661696C61626C65031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403093O00486F6C79506F776572026O00144003063O0042752O665570030B3O00486F6C794176656E676572026O000840030B3O004C696768746F664461776E030E3O0049735370652O6C496E52616E676503193O003236FEF92A00F6F7013BF8E6307FE9E33730EBF82A26B9A06E03043O00915E5F9903183O00CEC51DD042B3F2CB00DD4B85F4CA1CC14BB8E8DE3CDA42AE03063O00D79DAD74B52E026O006940025O00B6AF4003183O00536869656C646F667468655269676874656F7573486F6C79030E3O004973496E4D656C2O6552616E676503233O0026BC82F7D6318B84F4E521BC8ECDC83CB383E6DF3AA198B2CA27BD84E0D321ADCBA38803053O00BA55D4EB92026O00F03F025O0014A940025O00E09540025O00909540025O002EAE40030D3O00EA801BF33CFC57C4B604FF2DE603073O0038A2E1769E598E025O00E06640025O001AAA40030D3O0048612O6D65726F665772617468031B3O005404CDA227CA630AC69035CA5D11C8EF32CA550AD2A636C11C549403063O00B83C65A0CF42025O00A07A40025O0098A940030D3O008DAB2E132O16C85792B8220A1B03083O0031C5CA437E7364A7025O0010AC40025O00F8AF40031A3O003F5AD224854461385DE03E92574A3F1BCF3B89594C3E4FC669D403073O003E573BBF49E036025O0068AA40031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O00D70EFBD0E21003043O00A987629A030C3O00E77E235CE920E0CA7A2951EF03073O00A8AB1744349D53030A3O0049734361737461626C65025O00E9B240025O00F5B14003123O004C696768747348612O6D6572506C61796572026O00204003183O00F878F2A5313EB8FC70F8A0203FC7E463FCA2372493ED31A303073O00E7941195CD454D03063O00A3B2D5E858ED03063O009FE0C7A79B37025O00F4AE40030C3O00DBFA3BDAE3E014D3FAFE39C003043O00B297935C03123O004C696768747348612O6D6572637572736F7203183O0080F44B3A065F4584FC413F175E3A9CEF453D00456E95BD1A03073O001AEC9D2C52722C03123O000F20D056336EE0552E2BC71B093BC748253C03043O003B4A4EB5030C3O0009D85D52A736F95B57BE20C303053O00D345B12O3A03063O0045786973747303093O0043616E412O7461636B025O00E2A740025O006AA04003183O00BBEC7E2OFDD888ED78F8E4CE2OA569E7E0C4A5EC6DECA99D03063O00ABD785199589030C3O00C2C73CE9EA33EE43F5C13DF403083O002281A8529A8F509C030C3O00436F6E736563726174696F6E03173O0086BD3D182O4D9B84A63A04460E9997BB3C19415A90C5EA03073O00E9E5D2536B282E025O0012AF40025O0050B240025O00308840025O00707C4003093O00AC4E5437B453513D8903043O004EE42138030F3O00486F6C79507269736D506C61796572031E3O00C671BE1ABADE6CBB10888E71BC4396CB72B44395DC77BD118CDA67F251D303053O00E5AE1ED26303093O0033E28A48DD2F3008E003073O00597B8DE6318D5D026O008A40025O0056A24003093O00486F6C79507269736D03163O00FB7EFA152F5AE178E501505AE178F91E195EEA31A45403063O002A9311966C70030D3O002EB42E7EE9ED3BA93F6DE2E61B03063O00886FC64D1F87025O00389E40025O00B2A540030D3O00417263616E65546F2O72656E74031A3O00031BA457B3E128BD0D1BB553B3F057B91000A844B4F00EE9515903083O00C96269C736DD8477026O001840026O001040030E3O00A7D315AA3E35CD96F214AB363ACD03073O00A8E4A160D95F51030E3O00F8C33B4F2E53DEC31D483D5ED0D403063O0037BBB14E3C4F03073O0043686172676573030E3O004372757361646572537472696B65031B3O002EDC4AF847CB853FF14CFF54C68B288E4FF94FC09224DA46AB149B03073O00E04DAE3F8B26AF025O00E08240025O003DB24003093O0075797F0540A3425E7D03073O002D3D16137C13CB030A3O00446562752O66446F776E03123O00476C692O6D65726F664C6967687442752O66030E3O00E61E04F80F75ABCE1421FC0578AD03073O00D9A1726D956210025O0050A040025O00B6A24003093O00486F6C7953686F636B03113O001A2F346583671A2F3B77FC70132D397BB903063O00147240581CDC025O00209F40025O0074A44003093O00190EDEADCBD8B2320A03073O00DD5161B2D498B003163O00456E656D69657357697468446562752O66436F756E74026O00444003093O00436173744379636C6503123O00486F6C7953686F636B4D6F7573656F766572025O00ECA940025O00207A4003173O00C5E811E225DEEF12F811F2E404F816C8A719FA17CCE01803053O007AAD877D9B030B3O0095058429163AAA9D0D942F03073O00CCD96CE341625503093O007FD4F4EE29CE57CDF203063O00A03EA395854C025O00C6AF40025O00D2A34003193O00DAA90A27D7E9AF0B10C7D7B7036FD3C4A9023DCAC2B94D7C9103053O00A3B6C06D4F030E3O00173415D3F4302312F3E1262F0BC503053O0095544660A0031B3O003B1418FE390208FF071519FF310D08AD281404E22A0F19F478555903043O008D58666D030C3O00905CC4631F3E47C0A75AC57E03083O00A1D333AA107A5D35025O0049B040025O00B8AF4003183O00F8A1BC3BFEADA029EFA7BD26BBBEA021F4BCBB3CE2EEE17E03043O00489BCED2025O00805540025O00F08240030C3O009DFB0D5686BDE602518AB1FA03053O00E3DE946325025O002AA34003183O00305D5CE5FC304053E2F03C5C12E6EB3A5D40FFED2A1200A603053O0099532O329603083O001B9778BB3C8772A803043O00DC51E21C025O00E8A440025O0083B04003083O004A7564676D656E7403143O0019C086FCE7C21DC1C2EBF8CE1CC78BEFF387428303063O00A773B5E29B8A030C3O004C696768747348612O6D657203063O00D22EE6457E6303073O00A68242873C1B11025O00B07140025O000EA640030C3O006843C97D245762CF783D415803053O0050242AAE1503183O00421930725A0308724F1D3A7F5C502768471F25735A09772C03043O001A2E705703063O009A36B967B0AD03083O00D4D943CB142ODF25025O0092B040025O00E07640030C3O009684AFDAAE9E80D3B780ADC003043O00B2DAEDC8025O0068B24003183O00BABCE1D8A2A6D9D8B7B8EBD5A4F5F6C2BFBAF4D9A2ACA68603043O00B0D6D586025O000EAA40025O0060A74003123O00D1A3B3D9B1166CFAA9B3C6E8754CE6BEB9C603073O003994CDD6B4C836030C3O003EF4323C6201D534397B17EF03053O0016729D555403183O00C8C214CC49E597CCCA1EC958E4E8D4D91ACB4FFFBCDD8B4503073O00C8A4AB73A43D96025O00289740025O00D09640025O00606540025O0053B240025O00FAA040025O00E8B240025O0058AE40025O00089540025O0040AA4003183O00188439A9A5B9392D9838A99BB431239835A3BCAE1E24802903073O00564BEC50CCC9DD03113O004176656E67696E67577261746842752O6603093O005356768EFB857B4F7003063O00EB122117E59E03223O0043B2C8BE5CBEFEB45685D5B35585D3B257B2D5BE5FAFD2FB40A8C8B442B3D5A210E803043O00DB30DAA1025O00E89040026O00A64003183O00D779754CD74BEFE265744CE946E7EC657946CE5CC8EB7D6503073O008084111C29BB2F03103O002937073649090203285E043C123B5A0403053O003D6152665A025O00ECAD40025O00E8B04003223O00BF26A24ECB532106AA11BF43C2680C00AB26BF4EC8420D49BC3CA244D55E0A10EC7C03083O0069CC4ECB2BA7377E002F042O0012723O00013O00261A012O009B000100020004763O009B0001001272000100013O00261A2O010077000100010004763O00770001001272000200013O0026530002000B000100010004763O000B0001002E4B00040070000100030004763O00700001002ED500060050000100050004763O005000012O000C01036O0008010400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005000013O0004763O005000012O000C01036O0008010400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003002800013O0004763O002800012O000C010300023O0020FD00030003000D4O000400036O000500046O00030005000200062O0003003F000100010004763O003F00012O000C010300023O00201D01030003000E2O000C010400054O00F5000300020002000EAE00020050000100030004763O005000012O000C010300063O00204E00030003000F2O00F5000300020002000E540010003F000100030004763O003F00012O000C010300063O0020100103000300114O00055O00202O0005000500124O00030005000200062O0003005000013O0004763O005000012O000C010300063O00204E00030003000F2O00F5000300020002000E4000130050000100030004763O005000012O000C010300074O00C200045O00202O0004000400144O000500083O00202O0005000500154O00075O00202O0007000700144O0005000700024O000500056O00030005000200062O0003005000013O0004763O005000012O000C010300013O001272000400163O001272000500174O00E9000300054O009E00036O000C01036O0008010400013O00122O000500183O00122O000600196O0004000600024O00030003000400202O0003000300094O00030002000200062O0003006F00013O0004763O006F00012O000C010300093O000EAE0013006F000100030004763O006F0001002ED5001A006F0001001B0004763O006F00012O000C010300074O002O01045O00202O00040004001C4O000500083O00202O00050005001D00122O000700106O0005000700024O000500056O00030005000200062O0003006F00013O0004763O006F00012O000C010300013O0012720004001E3O0012720005001F4O00E9000300054O009E00035O001272000200203O00265300020074000100200004763O00740001002E4B00210007000100220004763O00070001001272000100203O0004763O007700010004763O0007000100261A2O010004000100200004763O00040001002ED500230098000100240004763O009800012O000C01026O0008010300013O00122O000400253O00122O000500266O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009800013O0004763O00980001002E4B00270098000100280004763O009800012O000C010200074O00C200035O00202O0003000300294O000400083O00202O0004000400154O00065O00202O0006000600294O0004000600024O000400046O00020004000200062O0002009800013O0004763O009800012O000C010200013O0012720003002A3O0012720004002B4O00E9000200044O009E00025O0012723O00133O0004763O009B00010004763O000400010026533O009F000100200004763O009F0001002ED5002D00572O01002C0004763O00572O012O000C2O016O0008010200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100C400013O0004763O00C400012O000C2O0100063O00204E00010001000F2O00F50001000200020026D0000100C4000100100004763O00C400012O000C2O0100093O00261A2O0100C4000100020004763O00C400012O000C2O0100074O000201025O00202O0002000200294O000300083O00202O0003000300154O00055O00202O0005000500294O0003000500024O000300036O00010003000200062O000100BF000100010004763O00BF0001002EC500300007000100310004763O00C400012O000C2O0100013O001272000200323O001272000300334O00E9000100034O009E00015O002EC500340029000100340004763O00ED000100120E000100354O0050000200013O00122O000300363O00122O000400376O00020004000200062O000100ED000100020004763O00ED00012O000C2O016O0008010200013O00122O000300383O00122O000400396O0002000400024O00010001000200202O00010001003A4O00010002000200062O000100352O013O0004763O00352O012O000C2O0100093O000E40000200352O0100010004763O00352O01002E4B003C00352O01003B0004763O00352O012O000C2O0100074O002O0102000A3O00202O00020002003D4O000300083O00202O00030003001D00122O0005003E6O0003000500024O000300036O00010003000200062O000100352O013O0004763O00352O012O000C2O0100013O00120A0102003F3O00122O000300406O000100036O00015O00044O00352O0100120E000100354O0050000200013O00122O000300413O00122O000400426O00020004000200062O0001000C2O0100020004763O000C2O01002EC500430041000100430004763O00352O012O000C2O016O0008010200013O00122O000300443O00122O000400456O0002000400024O00010001000200202O00010001003A4O00010002000200062O000100352O013O0004763O00352O012O000C2O0100074O000C0102000A3O00201D0102000200462O00F50001000200020006F7000100352O013O0004763O00352O012O000C2O0100013O00120A010200473O00122O000300486O000100036O00015O00044O00352O0100120E000100354O0050000200013O00122O000300493O00122O0004004A6O00020004000200062O000100352O0100020004763O00352O012O000C2O016O0008010200013O00122O0003004B3O00122O0004004C6O0002000400024O00010001000200202O00010001003A4O00010002000200062O000100352O013O0004763O00352O012O000C2O01000B3O00204E00010001004D2O00F50001000200020006F7000100352O013O0004763O00352O012O000C2O0100063O00204E00010001004E2O000C0103000B4O00E40001000300020006F7000100352O013O0004763O00352O012O000C2O0100074O000C0102000A3O00201D0102000200462O00F500010002000200061B2O0100302O0100010004763O00302O01002E4B004F00352O0100500004763O00352O012O000C2O0100013O001272000200513O001272000300524O00E9000100034O009E00016O000C2O016O0008010200013O00122O000300533O00122O000400546O0002000400024O00010001000200202O00010001003A4O00010002000200062O000100562O013O0004763O00562O012O000C2O0100093O000E40000200562O0100010004763O00562O012O000C2O01000C4O00CB000100010002002685000100562O0100010004763O00562O012O000C2O0100074O002O01025O00202O0002000200554O000300083O00202O00030003001D00122O000500106O0003000500024O000300036O00010003000200062O000100562O013O0004763O00562O012O000C2O0100013O001272000200563O001272000300574O00E9000100034O009E00015O0012723O00023O0026533O005B2O0100100004763O005B2O01002E4B005900C62O0100580004763O00C62O01001272000100014O00F9000200023O002653000100612O0100010004763O00612O01002ED5005A005D2O01005B0004763O005D2O01001272000200013O00261A010200A82O0100010004763O00A82O01001272000300013O000ECF002000692O0100030004763O00692O01001272000200203O0004763O00A82O0100261A010300652O0100010004763O00652O012O000C01046O0008010500013O00122O0006005C3O00122O0007005D6O0005000700024O00040004000500202O0004000400094O00040002000200062O000400862O013O0004763O00862O012O000C010400093O000E40000200862O0100040004763O00862O012O000C0104000D3O0006F7000400862O013O0004763O00862O012O000C010400074O000C0105000A3O00201D01050005005E2O00F50004000200020006F7000400862O013O0004763O00862O012O000C010400013O0012720005005F3O001272000600604O00E9000400064O009E00046O000C01046O0008010500013O00122O000600613O00122O000700626O0005000700024O00040004000500202O0004000400094O00040002000200062O000400932O013O0004763O00932O012O000C0104000D3O00061B010400952O0100010004763O00952O01002EC500630013000100640004763O00A62O012O000C010400074O00C200055O00202O0005000500654O000600083O00202O0006000600154O00085O00202O0008000800654O0006000800024O000600066O00040006000200062O000400A62O013O0004763O00A62O012O000C010400013O001272000500663O001272000600674O00E9000400064O009E00045O001272000300203O0004763O00652O0100261A010200622O0100200004763O00622O012O000C01036O009F000400013O00122O000500683O00122O000600696O0004000600024O00030003000400202O00030003003A4O00030002000200062O000300B62O0100010004763O00B62O01002EC5006A000D0001006B0004763O00C12O012O000C010300074O000C01045O00201D01040004006C2O00F50003000200020006F7000300C12O013O0004763O00C12O012O000C010300013O0012720004006D3O0012720005006E4O00E9000300054O009E00035O0012723O006F3O0004763O00C62O010004763O00622O010004763O00C62O010004763O005D2O0100261A012O006C020100700004763O006C0201001272000100013O000ECF002000F12O0100010004763O00F12O012O000C01026O0008010300013O00122O000400713O00122O000500726O0003000500024O00020002000300202O0002000200094O00020002000200062O000200EF2O013O0004763O00EF2O012O000C01026O0032000300013O00122O000400733O00122O000500746O0003000500024O00020002000300202O0002000200754O00020002000200262O000200EF2O0100020004763O00EF2O012O000C010200074O002O01035O00202O0003000300764O000400083O00202O00040004001D00122O000600106O0004000600024O000400046O00020004000200062O000200EF2O013O0004763O00EF2O012O000C010200013O001272000300773O001272000400784O00E9000200044O009E00025O0012723O00103O0004763O006C020100261A2O0100C92O0100010004763O00C92O01001272000200013O00261A010200F82O0100200004763O00F82O01001272000100203O0004763O00C92O01002653000200FC2O0100010004763O00FC2O01002EC5007900FAFF2O007A0004763O00F42O012O000C0103000E3O0006F70003001F02013O0004763O001F02012O000C01036O0008010400013O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003001F02013O0004763O001F02012O000C010300083O00201001030003007D4O00055O00202O00050005007E4O00030005000200062O0003001F02013O0004763O001F02012O000C01036O0008010400013O00122O0005007F3O00122O000600806O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003002102013O0004763O002102012O000C0103000F4O000C010400084O00F500030002000200061B01030021020100010004763O00210201002ED500820032020100810004763O003202012O000C010300074O00C200045O00202O0004000400834O000500083O00202O0005000500154O00075O00202O0007000700834O0005000700024O000500056O00030005000200062O0003003202013O0004763O003202012O000C010300013O001272000400843O001272000500854O00E9000300054O009E00035O002E4B00860069020100870004763O006902012O000C0103000E3O0006F70003006902013O0004763O006902012O000C010300103O0006F70003006902013O0004763O006902012O000C01036O0008010400013O00122O000500883O00122O000600896O0004000600024O00030003000400202O0003000300094O00030002000200062O0003006902013O0004763O006902012O000C010300023O0020AA00030003008A4O00045O00202O00040004007E00122O0005008B6O0003000500024O000400113O00062O00030069020100040004763O006902012O000C010300123O0006F70003006902013O0004763O006902012O000C010300023O00201B00030003008C4O00045O00202O0004000400834O000500136O0006000F6O000700083O00202O0007000700154O00095O00202O0009000900834O0007000900022O00C3000700074O0003000800096O000A000A3O00202O000A000A008D4O0003000A000200062O00030064020100010004763O00640201002EC5008E00070001008F0004763O006902012O000C010300013O001272000400903O001272000500914O00E9000300054O009E00035O001272000200203O0004763O00F42O010004763O00C92O0100261A012O00DE0201006F0004763O00DE02012O000C2O016O0008010200013O00122O000300923O00122O000400936O0002000400024O00010001000200202O0001000100094O00010002000200062O000100A702013O0004763O00A702012O000C2O0100063O00204E00010001000F2O00F5000100020002000E40001300A7020100010004763O00A702012O000C2O016O0008010200013O00122O000300943O00122O000400956O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001008E02013O0004763O008E02012O000C2O0100023O0020FD00010001000D4O000200036O000300046O00010003000200062O00010094020100010004763O009402012O000C2O0100023O00201D2O010001000E2O000C010200054O00F5000100020002000EAE000200A7020100010004763O00A702012O000C2O0100074O000201025O00202O0002000200144O000300083O00202O0003000300154O00055O00202O0005000500144O0003000500024O000300036O00010003000200062O000100A2020100010004763O00A20201002E4B009600A7020100970004763O00A702012O000C2O0100013O001272000200983O001272000300994O00E9000100034O009E00016O000C2O016O0008010200013O00122O0003009A3O00122O0004009B6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100C102013O0004763O00C102012O000C2O0100074O002O01025O00202O0002000200764O000300083O00202O00030003001D00122O000500106O0003000500024O000300036O00010003000200062O000100C102013O0004763O00C102012O000C2O0100013O0012720002009C3O0012720003009D4O00E9000100034O009E00016O000C2O016O009F000200013O00122O0003009E3O00122O0004009F6O0002000400024O00010001000200202O0001000100094O00010002000200062O000100CD020100010004763O00CD0201002E4B00A0002E040100A10004763O002E04012O000C2O0100074O002O01025O00202O0002000200554O000300083O00202O00030003001D00122O000500106O0003000500024O000300036O00010003000200062O0001002E04013O0004763O002E04012O000C2O0100013O00120A010200A23O00122O000300A36O000100036O00015O00044O002E040100261A012O0097030100130004763O00970301001272000100013O002653000100E5020100200004763O00E50201002E4B00A50007030100A40004763O000703012O000C01026O0008010300013O00122O000400A63O00122O000500A76O0003000500024O00020002000300202O00020002003A4O00020002000200062O0002000503013O0004763O000503012O000C0102000C4O00CB00020001000200268500020005030100010004763O000503012O000C010200074O005E00035O00202O0003000300554O000400083O00202O00040004001D00122O000600106O0004000600024O000400046O00020004000200062O00022O00030100010004764O000301002E4B00A80005030100030004763O000503012O000C010200013O001272000300A93O001272000400AA4O00E9000200044O009E00025O0012723O00703O0004763O0097030100261A2O0100E1020100010004763O00E102012O000C01026O009F000300013O00122O000400AB3O00122O000500AC6O0003000500024O00020002000300202O0002000200094O00020002000200062O00020015030100010004763O00150301002E4B00AE0026030100AD0004763O002603012O000C010200074O00C200035O00202O0003000300AF4O000400083O00202O0004000400154O00065O00202O0006000600AF4O0004000600024O000400046O00020004000200062O0002002603013O0004763O002603012O000C010200013O001272000300B03O001272000400B14O00E9000200044O009E00025O00120E000200B24O00F2000300013O00122O000400B33O00122O000500B46O00030005000200062O0002002F030100030004763O002F0301002E4B00B6004A030100B50004763O004A03012O000C01026O0008010300013O00122O000400B73O00122O000500B86O0003000500024O00020002000300202O00020002003A4O00020002000200062O0002009503013O0004763O009503012O000C010200074O002O0103000A3O00202O00030003003D4O000400083O00202O00040004001D00122O0006003E6O0004000600024O000400046O00020004000200062O0002009503013O0004763O009503012O000C010200013O00120A010300B93O00122O000400BA6O000200046O00025O00044O0095030100120E000200B24O0050000300013O00122O000400BB3O00122O000500BC6O00030005000200062O0002006B030100030004763O006B0301002ED500BE0095030100BD0004763O009503012O000C01026O0008010300013O00122O000400BF3O00122O000500C06O0003000500024O00020002000300202O00020002003A4O00020002000200062O0002009503013O0004763O00950301002EC500C10038000100C10004763O009503012O000C010200074O000C0103000A3O00201D0103000300462O00F50002000200020006F70002009503013O0004763O009503012O000C010200013O00120A010300C23O00122O000400C36O000200046O00025O00044O00950301002E4B00C50075030100C40004763O0075030100120E000200B24O00F2000300013O00122O000400C63O00122O000500C76O00030005000200062O00020075030100030004763O007503010004763O009503012O000C01026O0008010300013O00122O000400C83O00122O000500C96O0003000500024O00020002000300202O00020002003A4O00020002000200062O0002009503013O0004763O009503012O000C0102000B3O00204E00020002004D2O00F50002000200020006F70002009503013O0004763O009503012O000C010200063O00204E00020002004E2O000C0104000B4O00E40002000400020006F70002009503013O0004763O009503012O000C010200074O000C0103000A3O00201D0103000300462O00F50002000200020006F70002009503013O0004763O009503012O000C010200013O001272000300CA3O001272000400CB4O00E9000200044O009E00025O001272000100203O0004763O00E10201002E4B00CD0001000100CC0004763O0001000100261A012O0001000100010004763O00010001001272000100014O00F9000200023O00261A2O01009D030100010004763O009D0301001272000200013O00261A010200F5030100010004763O00F503012O000C010300143O0006F7000300C003013O0004763O00C00301001272000300014O00F9000400053O002653000300AB030100200004763O00AB0301002E4B00CF00BA030100CE0004763O00BA0301002653000400AF030100010004763O00AF0301002ED500D100AB030100D00004763O00AB03012O000C010600154O00CB0006000100022O008E000500063O00061B010500B6030100010004763O00B60301002ED500D200C0030100D30004763O00C003012O003C000500023O0004763O00C003010004763O00AB03010004763O00C0030100261A010300A7030100010004763O00A70301001272000400014O00F9000500053O001272000300203O0004763O00A70301002EC500D40034000100D40004763O00F403012O000C01036O0008010400013O00122O000500D53O00122O000600D66O0004000600024O00030003000400202O0003000300094O00030002000200062O000300F403013O0004763O00F403012O000C010300063O0020740003000300114O00055O00202O0005000500D74O00030005000200062O000300E4030100010004763O00E403012O000C010300063O0020740003000300114O00055O00202O0005000500124O00030005000200062O000300E4030100010004763O00E403012O000C01036O009F000400013O00122O000500D83O00122O000600D96O0004000600024O00030003000400202O00030003000C4O00030002000200062O000300F4030100010004763O00F403012O000C010300074O002O01045O00202O00040004001C4O000500083O00202O00050005001D00122O000700106O0005000700024O000500056O00030005000200062O000300F403013O0004763O00F403012O000C010300013O001272000400DA3O001272000500DB4O00E9000300054O009E00035O001272000200203O002E4B00DC00A0030100DD0004763O00A0030100261A010200A0030100200004763O00A003012O000C01036O0008010400013O00122O000500DE3O00122O000600DF6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002804013O0004763O0028040100120E0003000F3O000E4000130028040100030004763O002804012O000C010300024O00CE000400013O00122O000500E03O00122O000600E16O0004000600024O0003000300044O000400163O00062O00040028040100030004763O002804012O000C010300023O00204600030003000E4O000400036O0003000200024O000400043O00062O00030028040100040004763O002804012O000C010300074O005E00045O00202O00040004001C4O000500083O00202O00050005001D00122O000700106O0005000700024O000500056O00030005000200062O00030023040100010004763O00230401002E4B00E30028040100E20004763O002804012O000C010300013O001272000400E43O001272000500E54O00E9000300054O009E00035O0012723O00203O0004763O000100010004763O00A003010004763O000100010004763O009D03010004763O000100012O0018012O00017O007B3O00028O00026O000840025O002C9140025O0092B240025O0007B340025O001CB340030A3O0058FE2O3F3DA148F8253A03063O00C41C9749565303073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030F3O00446976696E65546F2O6C466F637573031C3O00F70A3F198C5D2762FC0F25508157177AF70C3E1EBD501D77FF0A271703083O001693634970E2387803093O00907AEEECBEB07AE1FE03053O00EDD815829503103O004865616C746850657263656E74616765025O00B2A240025O00809940030E3O00486F6C7953686F636B466F637573031B3O008A4153468FDA568D4D541FB3C6518E4A5048BEF656874F5356BECE03073O003EE22E2O3FD0A9025O00DCA24003133O00C71550900C042159EA1F66821C1F2658EC1A5003083O003E857935E37F6D4F03043O004755494403183O00426C652O73696E676F66536163726966696365466F63757303263O00121837E6C5A7AC172B3DF3E9BDA313063BF3DFADA750173DFADAAAAD071A0DFDD3AFAE191A3503073O00C270745295B6CE027O0040025O00C09840025O00DAA140025O0032A040030E3O0060EB58834DE0568674E74B9457EB03043O00E0228E3903133O00426561636F6E6F66566972747565466F63757303213O00DCA2C4DE7CFF6201D898D3D461E5480B9EA4CAD27FF55219D098CDD872FD5400D903083O006EBEC7A5BD13913D03083O00FEEA6EEA99C2DBE003063O00A7BA8B1788EB031A3O00467269656E646C79556E6974735769746842752O66436F756E7403123O00476C692O6D65726F664C6967687442752O66030E3O004D616E6150657263656E74616765025O009CA640025O00DEA54003083O00446179627265616B03193O001EB4910F08B089065AB6870216B1871A148A80081BB981031D03043O006D7AD5E8026O00F03F025O00EC9340025O002AAC40026O006E40025O00989240030E3O00C6F6AC34E1F18639F8FEAC39FAEE03043O00508E97C2030E3O0048616E646F66446976696E697479031C3O0007CF61450DC348580CCA7B0C00C9784007C960423CCE724D0FCF794B03043O002C63A617025O00D88340025O00A2A140025O00A49E40025O00B08040030B3O0071B4E722692F43B5F0315D03063O004E30C1954324030A3O0049734361737461626C65025O00806840025O009EA740030B3O00417572614D617374657279031D3O00310B92197E3D1F930C442207C01B4E3F128417563E21881D403C178E1F03053O0021507EE078030D3O00CDBE06CA5BE5A604F34EEDBC0B03053O003C8CC863A403063O0042752O66557003113O004176656E67696E67577261746842752O66026O00A040025O00CEA740030D3O004176656E67696E675772617468031F3O0086E20128A58EFA0319B595F5102EE284FB0B2AA688E30A19AA82F5082FAC8003053O00C2E7946446030F3O007255D3B0D2CD4A45D7A6E4C9484FC403063O00A8262CA1C396025O00B07940025O0034A740025O00809440025O00D2A540030F3O005479727344656C69766572616E636503213O0094E590650FECB31A89EA876431E6B513C0FF8D793CECB9018EC38A7331E4BF188703083O0076E09CE2165088D6025O00E8A040025O0098AA4003063O0045786973747303093O004973496E52616E6765026O004440025O00E09040025O00CCA640030A3O006A7B4D013D6E7B5A0A2003053O0053261A346E030F3O004C61796F6E48616E6473466F637573025O00C4AA40025O00D49B40031D3O0054163E795719184E59192355181428495413285156282F43591B2E485F03043O002638774703083O00DDE04C961157FDE403063O0036938F38B64503143O00F48DFA5ACCDF8FF846D9E693F05DDAD595F646D103053O00BFB6E19F29030D3O00556E697447726F7570526F6C6503043O001F33067E03073O00A24B724835EBE7025O0018B140025O00CCAF4003193O00426C652O73696E676F6650726F74656374696F6E466F63757303273O008E3041F1400B823B7BED553D9C2E4BF6560198354BEC1301833348E65C1582034CE7520E85324303063O0062EC5C24823303063O0094150DA340BA03083O0050C4796CDA25C8D5025O00288940025O0042B04003143O00227F076C580784077C044F59019E05701676440003073O00EA6013621F2B6E025O0028B340031A3O00426C652O73696E676F6650726F74656374696F6E706C6179657203273O00041357D4BF7B8501205DC1936299090B57C4B87B84085F51C8A37E8F09085CF8A4778A0A165CC003073O00EB667F32A7CC122O00022O0012723O00014O00F9000100013O00261A012O0002000100010004763O00020001001272000100013O000E9500020009000100010004763O00090001002E4B00040073000100030004763O00730001002E4B0005002A000100060004763O002A00012O000C01026O0008010300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002002A00013O0004763O002A00012O000C010200023O0020C900020002000A4O000300036O000400046O00020004000200062O0002002A00013O0004763O002A00012O000C010200053O0006F70002002A00013O0004763O002A00012O000C010200064O000C010300073O00201D01030003000B2O00F50002000200020006F70002002A00013O0004763O002A00012O000C010200013O0012720003000C3O0012720004000D4O00E9000200044O009E00026O000C01026O0008010300013O00122O0004000E3O00122O0005000F6O0003000500024O00020002000300202O0002000200094O00020002000200062O0002003D00013O0004763O003D00012O000C010200083O00204E0002000200102O00F50002000200022O000C010300093O0006670002003D000100030004763O003D00012O000C0102000A3O00061B0102003F000100010004763O003F0001002E4B0011004A000100120004763O004A00012O000C010200064O000C010300073O00201D0103000300132O00F50002000200020006F70002004A00013O0004763O004A00012O000C010200013O001272000300143O001272000400154O00E9000200044O009E00025O002EC5001600B52O0100160004763O00FF2O012O000C01026O0008010300013O00122O000400173O00122O000500186O0003000500024O00020002000300202O0002000200094O00020002000200062O000200FF2O013O0004763O00FF2O012O000C010200083O00203F0002000200194O0002000200024O0003000B3O00202O0003000300194O00030002000200062O000200FF2O0100030004763O00FF2O012O000C010200083O00204E0002000200102O00F50002000200022O000C0103000C3O000667000200FF2O0100030004763O00FF2O012O000C0102000D3O0006F7000200FF2O013O0004763O00FF2O012O000C010200064O000C010300073O00201D01030003001A2O00F50002000200020006F7000200FF2O013O0004763O00FF2O012O000C010200013O00120A0103001B3O00122O0004001C6O000200046O00025O00044O00FF2O0100261A2O0100F50001001D0004763O00F50001001272000200013O002EC5001E00570001001E0004763O00CD000100261A010200CD000100010004763O00CD0001002ED50020009B0001001F0004763O009B00012O000C01036O0008010400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009B00013O0004763O009B00012O000C010300023O0020C900030003000A4O0004000E6O0005000F6O00030005000200062O0003009B00013O0004763O009B00012O000C010300103O0006F70003009B00013O0004763O009B00012O000C010300064O000C010400073O00201D0104000400232O00F50003000200020006F70003009B00013O0004763O009B00012O000C010300013O001272000400243O001272000500254O00E9000300054O009E00036O000C01036O0008010400013O00122O000500263O00122O000600276O0004000600024O00030003000400202O0003000300094O00030002000200062O000300BF00013O0004763O00BF00012O000C010300023O0020D20003000300284O00045O00202O0004000400294O00058O00068O0003000600024O000400113O00062O000400BF000100030004763O00BF00012O000C010300023O0020FD00030003000A4O000400126O000500136O00030005000200062O000300BC000100010004763O00BC00012O000C0103000B3O00204E00030003002A2O00F50003000200022O000C010400143O000667000300BF000100040004763O00BF00012O000C010300153O00061B010300C1000100010004763O00C10001002ED5002B00CC0001002C0004763O00CC00012O000C010300064O000C01045O00201D01040004002D2O00F50003000200020006F7000300CC00013O0004763O00CC00012O000C010300013O0012720004002E3O0012720005002F4O00E9000300054O009E00035O001272000200303O002653000200D1000100300004763O00D10001002ED500320076000100310004763O00760001002ED5003300F2000100340004763O00F200012O000C01036O0008010400013O00122O000500353O00122O000600366O0004000600024O00030003000400202O0003000300094O00030002000200062O000300F200013O0004763O00F200012O000C010300023O0020C900030003000A4O000400166O000500176O00030005000200062O000300F200013O0004763O00F200012O000C010300183O0006F7000300F200013O0004763O00F200012O000C010300064O000C01045O00201D0104000400372O00F50003000200020006F7000300F200013O0004763O00F200012O000C010300013O001272000400383O001272000500394O00E9000300054O009E00035O001272000100023O0004763O00F500010004763O0076000100261A2O0100702O0100300004763O00702O01001272000200013O002653000200FC000100010004763O00FC0001002ED5003B00482O01003A0004763O00482O01002ED5003D001F2O01003C0004763O001F2O012O000C01036O0008010400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300404O00030002000200062O0003001F2O013O0004763O001F2O012O000C010300023O0020C900030003000A4O000400196O0005001A6O00030005000200062O0003001F2O013O0004763O001F2O012O000C0103001B3O0006F70003001F2O013O0004763O001F2O01002E4B0041001F2O0100420004763O001F2O012O000C010300064O000C01045O00201D0104000400432O00F50003000200020006F70003001F2O013O0004763O001F2O012O000C010300013O001272000400443O001272000500454O00E9000300054O009E00036O000C01036O0008010400013O00122O000500463O00122O000600476O0004000600024O00030003000400202O0003000300404O00030002000200062O000300472O013O0004763O00472O012O000C0103000B3O0020740003000300484O00055O00202O0005000500494O00030005000200062O000300472O0100010004763O00472O012O000C010300023O0020C900030003000A4O0004001C6O0005001D6O00030005000200062O000300472O013O0004763O00472O012O000C0103001E3O0006F7000300472O013O0004763O00472O01002E4B004A00472O01004B0004763O00472O012O000C010300064O000C01045O00201D01040004004C2O00F50003000200020006F7000300472O013O0004763O00472O012O000C010300013O0012720004004D3O0012720005004E4O00E9000300054O009E00035O001272000200303O000ECF003000F8000100020004763O00F800012O000C01036O0008010400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O0003000300404O00030002000200062O0003005E2O013O0004763O005E2O012O000C0103001F3O0006F70003005E2O013O0004763O005E2O012O000C010300023O0020FD00030003000A4O000400206O000500216O00030005000200062O000300602O0100010004763O00602O01002E4B0052006D2O0100510004763O006D2O01002E4B0053006D2O0100540004763O006D2O012O000C010300064O000C01045O00201D0104000400552O00F50003000200020006F70003006D2O013O0004763O006D2O012O000C010300013O001272000400563O001272000500574O00E9000300054O009E00035O0012720001001D3O0004763O00702O010004763O00F80001002653000100742O0100010004763O00742O01002E4B00590005000100580004763O000500012O000C010200083O0006F7000200822O013O0004763O00822O012O000C010200083O00204E00020002005A2O00F50002000200020006F7000200822O013O0004763O00822O012O000C010200083O00204E00020002005B0012720004005C4O00E400020004000200061B010200832O0100010004763O00832O012O0018012O00013O002E4B005D00A52O01005E0004763O00A52O012O000C01026O0008010300013O00122O0004005F3O00122O000500606O0003000500024O00020002000300202O0002000200404O00020002000200062O000200A52O013O0004763O00A52O012O000C010200083O00204E0002000200102O00F50002000200022O000C010300223O000667000200A52O0100030004763O00A52O012O000C010200233O0006F7000200A52O013O0004763O00A52O012O000C010200064O000C010300073O00201D0103000300612O00F500020002000200061B010200A02O0100010004763O00A02O01002E4B006200A52O0100630004763O00A52O012O000C010200013O001272000300643O001272000400654O00E9000200044O009E00026O000C010200244O0050000300013O00122O000400663O00122O000500676O00030005000200062O000200D52O0100030004763O00D52O012O000C01026O0008010300013O00122O000400683O00122O000500696O0003000500024O00020002000300202O0002000200404O00020002000200062O000200C72O013O0004763O00C72O012O000C010200083O00204E0002000200102O00F50002000200022O000C010300253O000667000200C72O0100030004763O00C72O012O000C010200023O0020B100020002006A4O000300086O0002000200024O000200026O000300013O00122O0004006B3O00122O0005006C6O00030005000200062O000200C92O0100030004763O00C92O01002E4B006D00FB2O01006E0004763O00FB2O012O000C010200064O000C010300073O00201D01030003006F2O00F50002000200020006F7000200FB2O013O0004763O00FB2O012O000C010200013O00120A010300703O00122O000400716O000200046O00025O00044O00FB2O012O000C010200244O00F2000300013O00122O000400723O00122O000500736O00030005000200062O000200DE2O0100030004763O00DE2O01002ED5007500FB2O0100740004763O00FB2O012O000C01026O0008010300013O00122O000400763O00122O000500776O0003000500024O00020002000300202O0002000200404O00020002000200062O000200FB2O013O0004763O00FB2O012O000C0102000B3O00204E0002000200102O00F50002000200022O000C010300253O000667000200FB2O0100030004763O00FB2O01002EC50078000D000100780004763O00FB2O012O000C010200064O000C010300073O00201D0103000300792O00F50002000200020006F7000200FB2O013O0004763O00FB2O012O000C010200013O0012720003007A3O0012720004007B4O00E9000200044O009E00025O001272000100303O0004763O000500010004763O00FF2O010004763O000200012O0018012O00017O00883O00028O00027O0040025O00BAA340025O0023B240030B3O001319BEE53EF6F02819BEF803073O00B74476CC81519003073O004973526561647903093O00486F6C79506F776572026O00084003103O004865616C746850657263656E74616765030D3O00557365576F644F66476C6F727903273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403103O00576F72646F66476C6F7279466F637573025O001EAF40025O00F8914003193O0019A262E0348D089277E8049017ED71EB0EBD06A871E8028C0903063O00E26ECD10846B03103O00C7CAE7D155E4C5F4D144C6C2F2CD58F903053O00218BA380B903133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D6172747972025O00C4AF40025O0097B04003153O004C696768746F667468654D6172747972466F637573031B3O005F5708C7684B0CD1545344DD585708DA584F0AE15F5D05D25E562O03043O00BE373864026O00F03F025O00989640025O00088140025O00408340025O00E06840030B3O002OE8BCDCFCD9C0A2D7E1C603053O0093BF87CEB803063O0042752O66557003113O00556E656E64696E674C6967687442752O66025O0020B140025O00D0A14003193O009327B4C5E75CB4BB2FAACECA4AF28527A3FED056B38821A8C603073O00D2E448C6A1B833025O00D4B140025O00B08240030B3O001A40F41867C1306DF2077D03063O00AE5629937013031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030B3O004C696768746F664461776E03193O0057098A0331301EAD64048C1C2B4F10A45E3F850E240318A55C03083O00CB3B60ED6B456F71030E3O001BAD4D1BCFEC013F9E450AD4F70B03073O006E59C82C78A08203133O00426561636F6E6F66566972747565466F637573031C3O00A9C64A454C440442ADFC5D4F515E2E48EBC244437C423E4CA7CA454103083O002DCBA32B26232A5B025O0046AD40030B3O00E58ACE2788AF73DE8ACE3A03073O0034B2E5BC43E7C903123O00456D70797265616E4C656761637942752O66025O0062AE40025O009EB24003193O00364E4200C853251E465C0BE54563204E553BFF59222D485E2O03073O004341213064973C025O0088A440025O0040A340025O00FAA840025O006EA740030D3O00546172676574497356616C6964025O00C08D40025O00C05140025O0056A240025O00707A40025O0085B340025O00A7B240025O000AAA40025O0068AC40030C3O0075A0320D16E0E157BB35111D03073O009336CF5C7E7383030A3O0049734361737461626C65030A3O002A3E397908703D30217503063O001E6D51551D6D030B3O004973417661696C61626C65030C3O00436F6E736563726174696F6E030E3O004973496E4D656C2O6552616E6765026O00144003183O00FC7E5AA533DDEEFE655DB9389EFDF0746BBE33DFF0F67F5303073O009C9F1134D656BE025O00F4AC40025O00B2A24003083O0084FAB9BBA3EAB3A803043O00DCCE8FDD030F3O00AC682910D5C9DC92722B3BD1CBDA9203073O00B2E61D4D77B8AC030A3O00446562752O66446F776E03153O004A7564676D656E746F664C69676874446562752O6603083O004A7564676D656E74030E3O0049735370652O6C496E52616E676503143O00FFAB0E1C7AFDFBAA4A1A78FDCAB60F1A7BF1FBB903063O009895DE6A7B17025O00709B40025O003EAD40025O004CA440025O0028A940031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O00ED2AF75AB0CF03053O00D5BD469623030C3O00635C73005B465C094258711A03043O00682F3514025O0062B340025O00B8AC4003123O004C696768747348612O6D6572506C61796572026O002040025O0016AB40025O007AA94003183O00AF458614A81C9C448011B10AB10C910EB500B1459505FC5903063O006FC32CE17CDC025O00D49640025O000AA24003063O00FB531260A4B903063O00CBB8266013CB030C3O00157A7E49DA2A5B784CC33C6103053O00AE59131921025O003DB240025O00F07F4003123O004C696768747348612O6D6572637572736F72025O007EB040025O00309D4003183O00231B5546E3943427135F43F2954B3F005B41E58E1F36520403073O006B4F72322E97E703123O001CA8B024937982CE3DA3A769A92CA5D336B403083O00A059C6D549EA59D7030C3O006478B3F6D15B59B5F3C84D6303053O00A52811D49E03063O0045786973747303093O0043616E412O7461636B025O0024A840025O0080594003183O00E9D00F3B32F6E600322BE8DC1A7336F7D007212FF1C0486503053O004685B96853002F022O0012723O00014O00F9000100013O000ECF0001000200013O0004763O00020001001272000100013O00265300010009000100020004763O00090001002ED500040055000100030004763O005500012O000C01026O0008010300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002003400013O0004763O003400012O000C010200023O00204E0002000200082O00F5000200020002000E4000090034000100020004763O003400012O000C010200033O00204E00020002000A2O00F50002000200022O000C010300043O00066700020034000100030004763O0034000100120E0002000B3O0006F70002003400013O0004763O003400012O000C010200053O00201D01020002000C2O000C010300044O00F50002000200020026D000020034000100090004763O003400012O000C010200064O000C010300073O00201D01030003000D2O00F500020002000200061B0102002F000100010004763O002F0001002ED5000E00340001000F0004763O003400012O000C010200013O001272000300103O001272000400114O00E9000200044O009E00026O000C01026O0008010300013O00122O000400123O00122O000500136O0003000500024O00020002000300202O0002000200074O00020002000200062O0002005400013O0004763O005400012O000C010200033O00204E00020002000A2O00F500020002000200120E000300143O00066700020054000100030004763O0054000100120E000200153O0006F70002005400013O0004763O00540001002ED500160054000100170004763O005400012O000C010200064O000C010300073O00201D0103000300182O00F50002000200020006F70002005400013O0004763O005400012O000C010200013O001272000300193O0012720004001A4O00E9000200044O009E00025O001272000100093O002653000100590001001B0004763O00590001002ED5001C00B90001001D0004763O00B90001001272000200013O0026530002005E000100010004763O005E0001002EC5001E00580001001F0004763O00B400012O000C01036O0008010400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007D00013O0004763O007D00012O000C010300023O00204E0003000300082O00F5000300020002000E400009007D000100030004763O007D00012O000C010300023O0020100103000300224O00055O00202O0005000500234O00030005000200062O0003007D00013O0004763O007D00012O000C010300033O00204E00030003000A2O00F50003000200022O000C010400043O0006670003007D000100040004763O007D00012O000C010300083O00061B0103007F000100010004763O007F0001002E4B0024008A000100250004763O008A00012O000C010300064O000C010400073O00201D01040004000D2O00F50003000200020006F70003008A00013O0004763O008A00012O000C010300013O001272000400263O001272000500274O00E9000300054O009E00035O002ED5002900B3000100280004763O00B300012O000C01036O0008010400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O0003000300074O00030002000200062O000300B300013O0004763O00B300012O000C010300023O00204E0003000300082O00F5000300020002000E40000900B3000100030004763O00B300012O000C010300053O0020FD00030003002C4O000400096O0005000A6O00030005000200062O000300A8000100010004763O00A800012O000C010300053O00201D01030003000C2O000C010400044O00F5000300020002000EAE000200B3000100030004763O00B300012O000C010300064O000C01045O00201D01040004002D2O00F50003000200020006F7000300B300013O0004763O00B300012O000C010300013O0012720004002E3O0012720005002F4O00E9000300054O009E00035O0012720002001B3O00261A0102005A0001001B0004763O005A0001001272000100023O0004763O00B900010004763O005A0001000ECF0001002A2O0100010004763O002A2O01001272000200014O00F9000300033O00261A010200BD000100010004763O00BD0001001272000300013O00261A010300212O0100010004763O00212O01001272000400013O00261A0104001A2O0100010004763O001A2O012O000C01056O0008010600013O00122O000700303O00122O000800316O0006000800024O00050005000600202O0005000500074O00050002000200062O000500E400013O0004763O00E400012O000C010500053O0020C900050005002C4O0006000B6O0007000C6O00050007000200062O000500E400013O0004763O00E400012O000C0105000D3O0006F7000500E400013O0004763O00E400012O000C010500064O000C010600073O00201D0106000600322O00F50005000200020006F7000500E400013O0004763O00E400012O000C010500013O001272000600333O001272000700344O00E9000500074O009E00055O002EC500350035000100350004763O00192O012O000C01056O0008010600013O00122O000700363O00122O000800376O0006000800024O00050005000600202O0005000500074O00050002000200062O000500192O013O0004763O00192O012O000C010500023O00204E0005000500082O00F5000500020002000E40000900192O0100050004763O00192O012O000C010500023O0020100105000500224O00075O00202O0007000700384O00050007000200062O000500192O013O0004763O00192O012O000C010500033O00204E00050005000A2O00F50005000200022O000C010600043O000667000500052O0100060004763O00052O012O000C010500083O00061B0105000C2O0100010004763O000C2O012O000C010500053O0020C900050005002C4O000600096O0007000A6O00050007000200062O000500192O013O0004763O00192O01002ED5003900192O01003A0004763O00192O012O000C010500064O000C010600073O00201D01060006000D2O00F50005000200020006F7000500192O013O0004763O00192O012O000C010500013O0012720006003B3O0012720007003C4O00E9000500074O009E00055O0012720004001B3O002ED5003E00C30001003D0004763O00C3000100261A010400C30001001B0004763O00C300010012720003001B3O0004763O00212O010004763O00C30001002653000300252O01001B0004763O00252O01002E4B003F00C0000100400004763O00C000010012720001001B3O0004763O002A2O010004763O00C000010004763O002A2O010004763O00BD000100261A2O010005000100090004763O000500012O000C010200053O00201D0102000200412O00CB00020001000200061B010200332O0100010004763O00332O01002E4B0042002E020100430004763O002E0201001272000200014O00F9000300033O002E4B004500352O0100440004763O00352O0100261A010200352O0100010004763O00352O01001272000300013O00261A010300A72O0100010004763O00A72O01001272000400013O00261A010400412O01001B0004763O00412O010012720003001B3O0004763O00A72O01002E4B0047003D2O0100460004763O003D2O0100261A0104003D2O0100010004763O003D2O01001272000500013O00261A0105004A2O01001B0004763O004A2O010012720004001B3O0004763O003D2O0100261A010500462O0100010004763O00462O01002ED5004800762O0100490004763O00762O012O000C01066O0008010700013O00122O0008004A3O00122O0009004B6O0007000900024O00060006000700202O00060006004C4O00060002000200062O000600762O013O0004763O00762O012O000C01066O0008010700013O00122O0008004D3O00122O0009004E6O0007000900024O00060006000700202O00060006004F4O00060002000200062O000600762O013O0004763O00762O012O000C0106000E4O00CB000600010002002685000600762O0100010004763O00762O012O000C010600064O002O01075O00202O0007000700504O0008000F3O00202O00080008005100122O000A00526O0008000A00024O000800086O00060008000200062O000600762O013O0004763O00762O012O000C010600013O001272000700533O001272000800544O00E9000600084O009E00065O002E4B005600A42O0100550004763O00A42O012O000C01066O0008010700013O00122O000800573O00122O000900586O0007000900024O00060006000700202O0006000600074O00060002000200062O000600A42O013O0004763O00A42O012O000C01066O0008010700013O00122O000800593O00122O0009005A6O0007000900024O00060006000700202O00060006004F4O00060002000200062O000600A42O013O0004763O00A42O012O000C0106000F3O00201001060006005B4O00085O00202O00080008005C4O00060008000200062O000600A42O013O0004763O00A42O012O000C010600064O00C200075O00202O00070007005D4O0008000F3O00202O00080008005E4O000A5O00202O000A000A005D4O0008000A00024O000800086O00060008000200062O000600A42O013O0004763O00A42O012O000C010600013O0012720007005F3O001272000800604O00E9000600084O009E00065O0012720005001B3O0004763O00462O010004763O003D2O0100261A0103003A2O01001B0004763O003A2O01002ED50061002E020100620004763O002E02012O000C010400053O0020C900040004002C4O000500106O000600116O00040006000200062O0004002E02013O0004763O002E0201002E4B006300DA2O0100640004763O00DA2O0100120E000400654O0050000500013O00122O000600663O00122O000700676O00050007000200062O000400DA2O0100050004763O00DA2O012O000C01046O009F000500013O00122O000600683O00122O000700696O0005000700024O00040004000500202O00040004004C4O00040002000200062O000400C72O0100010004763O00C72O01002E4B006A002E0201006B0004763O002E02012O000C010400064O005E000500073O00202O00050005006C4O0006000F3O00202O00060006005100122O0008006D6O0006000800024O000600066O00040006000200062O000400D42O0100010004763O00D42O01002ED5006E002E0201006F0004763O002E02012O000C010400013O00120A010500703O00122O000600716O000400066O00045O00044O002E0201002E4B007200FD2O0100730004763O00FD2O0100120E000400654O0050000500013O00122O000600743O00122O000700756O00050007000200062O000400FD2O0100050004763O00FD2O012O000C01046O009F000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O00040004004C4O00040002000200062O000400EF2O0100010004763O00EF2O01002ED50078002E020100790004763O002E02012O000C010400064O000C010500073O00201D01050005007A2O00F500040002000200061B010400F72O0100010004763O00F72O01002E4B007B002E0201007C0004763O002E02012O000C010400013O00120A0105007D3O00122O0006007E6O000400066O00045O00044O002E020100120E000400654O0050000500013O00122O0006007F3O00122O000700806O00050007000200062O0004002E020100050004763O002E02012O000C01046O0008010500013O00122O000600813O00122O000700826O0005000700024O00040004000500202O00040004004C4O00040002000200062O0004002E02013O0004763O002E02012O000C010400123O00204E0004000400832O00F50004000200020006F70004002E02013O0004763O002E02012O000C010400023O00204E0004000400842O000C010600124O00E40004000600020006F70004002E02013O0004763O002E0201002E4B0086002E020100850004763O002E02012O000C010400064O000C010500073O00201D01050005007A2O00F50004000200020006F70004002E02013O0004763O002E02012O000C010400013O00120A010500873O00122O000600886O000400066O00045O00044O002E02010004763O003A2O010004763O002E02010004763O00352O010004763O002E02010004763O000500010004763O002E02010004763O000200012O0018012O00017O00873O00028O00025O0039B040025O00C49740027O0040026O00F03F025O00206F40025O00C05640026O00084003103O00CB33EC78F335ED64EF3FC671F52EF26203043O0010875A8B03073O004973526561647903103O004865616C746850657263656E7461676503133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D6172747972025O0004B240025O003C9C40025O00C88340025O0066B14003153O004C696768746F667468654D6172747972466F637573031B3O005C7B0A2A7147705B770D734D5B7758700924406B7051750A3A405303073O0018341466532E34030E3O00E62E333606C13D2E2229C526352C03053O006FA44F4144030A3O0049734361737461626C6503103O0042612O726965726F664661697468485003113O0055736542612O726965726F664661697468030E3O0042612O726965726F664661697468031B3O00C4D891CC27EFD4E68CD811ECC7D097D66EF9D2E68BDB2FE6CFD78403063O008AA6B9E3BE4E025O0030A240025O00907740025O005EA940025O00709540025O002AAF40025O0080AD40025O00A89C40030B3O002756D5F20D5AE5FA1550D103043O009B633FA3030B3O00446976696E654661766F72025O00109440025O002EAF4003173O0086D8B784B781BDD7A09BB6962OC2B5B2B18183DDA883BE03063O00E4E2B1C1EDD9030C3O0012BC22F53CBF25CA3DB72BF203043O008654D043025O005BB040025O00D2A940025O000C914003113O00466C6173686F664C69676874466F63757303193O0015A0874F1B93895A2CA08F5B1BB8C64F07938E5912A08F521403043O003C73CCE6025O008CAD40025O0016AE40025O00288540025O00B49240030C3O00ED78C4245A2C1FE77DC23F4603073O0079AB14A557324303063O0042752O66557003133O00496E667573696F6E6F664C6967687442752O66025O00DCAE4003193O00C034B825B13DC93E863AB005CE2CF925AD3DCE3DB83AB00CC103063O0062A658D956D9025O00F0B240025O00A0614003093O00DEF97518B6CEFFE57403063O00BC2O961961E6025O00A4AB40025O003EAE40030F3O00486F6C79507269736D506C61796572031E3O00D286531B33FDC8804C0F4CE2D4C94C0700EB9A994D0B03FFD39D46425EBB03063O008DBAE93F626C025O00C4AD40025O00B8A840026O001040025O00FAA340025O0052A440025O001CA240025O00E8904003093O00D9E520AF09F8ED24A203053O0045918A4CD6030E3O00486F6C794C69676874466F63757303153O0078C08590801A79C8819DFF0564F0818CBE1A79C18E03063O007610AF2OE9DF031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O00AAA940025O00F2AA4003063O00BB8834A2EB9903073O001DEBE455DB8EEB025O00688040025O00149540030C3O0011DDBDD5635D0F5330D9BFCF03083O00325DB4DABD172E47025O003AB04003123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O00D2AD5C4450CF77D6A5562O41CE08CEB6524356D55CC7E40D03073O0028BEC43B2C24BC03063O001F50CEA7F56F03073O006D5C25BCD49A1D025O00EEA240030C3O0028E6A3CB25492CEEA9CE344803063O003A648FC4A35103123O004C696768747348612O6D6572637572736F7203183O00164B24AB2B5ADA061B4F2EA62D09F51C134D31AA2B50A55803083O006E7A2243C35F298503123O0050BF5E47CF3584554ED367F1785FC466BE4903053O00B615D13B2A030C3O009B5EC21535AD9F56C81024AC03063O00DED737A57D4103063O0045786973747303093O0043616E412O7461636B025O0068B240025O00CAAD4003183O0020D8C112E62OD2422DDCCB1FE081FD5825DED413E6D8AD1C03083O002A4CB1A67A92A18D025O00206340025O001EA040025O0030A440030B3O00334A562EC602624825DB1D03053O00A96425244A03093O00486F6C79506F776572025O006C9B40025O00A8854003103O00576F72646F66476C6F7279466F63757303183O001788B0543F88A46F078BAD4219C7B1443F8FA7510C8EAC5703043O003060E7C2025O002OAA4003093O00E05502342AD0A080C303083O00E3A83A6E4D79B8CF030E3O00486F6C7953686F636B466F63757303153O007333B3598EC879AA7837FF53A5E479A07A30B64EB603083O00C51B5CDF20D1BB11025O00EFB140025O00E8A7400010022O0012723O00014O00F9000100013O00261A012O0002000100010004763O00020001001272000100013O002ED500030056000100020004763O0056000100261A2O010056000100040004763O00560001001272000200013O000E950005000E000100020004763O000E0001002ED500060010000100070004763O00100001001272000100083O0004763O0056000100261A0102000A000100010004763O000A00012O000C01036O0008010400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003002500013O0004763O002500012O000C010300023O00204E00030003000C2O00F500030002000200120E0004000D3O00066700030025000100040004763O0025000100120E0003000E3O00061B01030027000100010004763O00270001002EC5000F000F000100100004763O00340001002E4B00110034000100120004763O003400012O000C010300034O000C010400043O00201D0104000400132O00F50003000200020006F70003003400013O0004763O003400012O000C010300013O001272000400143O001272000500154O00E9000300054O009E00036O000C01036O0008010400013O00122O000500163O00122O000600176O0004000600024O00030003000400202O0003000300184O00030002000200062O0003005400013O0004763O005400012O000C010300023O00204E00030003000C2O00F500030002000200120E000400193O00066700030054000100040004763O0054000100120E0003001A3O0006F70003005400013O0004763O005400012O000C010300034O00E0000400043O00202O00040004001B4O000500056O000600016O00030006000200062O0003005400013O0004763O005400012O000C010300013O0012720004001C3O0012720005001D4O00E9000300054O009E00035O001272000200053O0004763O000A000100261A2O0100B5000100050004763O00B50001001272000200013O00261A0102005D000100050004763O005D0001001272000100043O0004763O00B50001000E9500010061000100020004763O00610001002ED5001E00590001001F0004763O00590001001272000300013O002EC500200006000100200004763O00680001000ECF00050068000100030004763O00680001001272000200053O0004763O00590001002ED500210062000100220004763O00620001000ECF00010062000100030004763O00620001002E4B0024008E000100230004763O008E00012O000C01046O0008010500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004008E00013O0004763O008E00012O000C010400023O00204E00040004000C2O00F50004000200022O000C010500053O0006670004008E000100050004763O008E00012O000C010400063O0006F70004008E00013O0004763O008E00012O000C010400034O000C01055O00201D0105000500272O00F500040002000200061B01040089000100010004763O00890001002E4B0029008E000100280004763O008E00012O000C010400013O0012720005002A3O0012720006002B4O00E9000400064O009E00046O000C01046O0008010500013O00122O0006002C3O00122O0007002D6O0005000700024O00040004000500202O0004000400184O00040002000200062O000400A100013O0004763O00A100012O000C010400023O00204E00040004000C2O00F50004000200022O000C010500073O000667000400A1000100050004763O00A100012O000C010400083O00061B010400A3000100010004763O00A30001002E4B002E00B20001002F0004763O00B20001002EC50030000F000100300004763O00B200012O000C010400034O00E0000500043O00202O0005000500314O000600066O000700016O00040007000200062O000400B200013O0004763O00B200012O000C010400013O001272000500323O001272000600334O00E9000400064O009E00045O001272000300053O0004763O006200010004763O00590001002ED5003400172O0100350004763O00172O0100261A2O0100172O0100080004763O00172O01001272000200014O00F9000300033O00261A010200BB000100010004763O00BB0001001272000300013O002E4B0036000E2O0100370004763O000E2O0100261A0103000E2O0100010004763O000E2O012O000C01046O0008010500013O00122O000600383O00122O000700396O0005000700024O00040004000500202O0004000400184O00040002000200062O000400EB00013O0004763O00EB00012O000C010400093O00201001040004003A4O00065O00202O00060006003B4O00040006000200062O000400EB00013O0004763O00EB00012O000C010400023O00204E00040004000C2O00F50004000200022O000C0105000A3O000667000400EB000100050004763O00EB00012O000C010400083O0006F7000400EB00013O0004763O00EB0001002EC5003C000F0001003C0004763O00EB00012O000C010400034O00E0000500043O00202O0005000500314O000600066O000700016O00040007000200062O000400EB00013O0004763O00EB00012O000C010400013O0012720005003D3O0012720006003E4O00E9000400064O009E00045O002E4B0040000D2O01003F0004763O000D2O012O000C01046O0008010500013O00122O000600413O00122O000700426O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004000D2O013O0004763O000D2O012O000C010400023O00204E00040004000C2O00F50004000200022O000C0105000B3O0006670004000D2O0100050004763O000D2O012O000C0104000C3O0006F70004000D2O013O0004763O000D2O01002ED50043000D2O0100440004763O000D2O012O000C010400034O000C010500043O00201D0105000500452O00F50004000200020006F70004000D2O013O0004763O000D2O012O000C010400013O001272000500463O001272000600474O00E9000400064O009E00045O001272000300053O002ED5004900BE000100480004763O00BE000100261A010300BE000100050004763O00BE00010012720001004A3O0004763O00172O010004763O00BE00010004763O00172O010004763O00BB0001002E4B004B00B62O01004C0004763O00B62O0100261A2O0100B62O01004A0004763O00B62O01002ED5004E003D2O01004D0004763O003D2O012O000C01026O0008010300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200184O00020002000200062O0002003D2O013O0004763O003D2O012O000C010200023O00204E00020002000C2O00F50002000200022O000C010300053O0006670002003D2O0100030004763O003D2O012O000C010200063O0006F70002003D2O013O0004763O003D2O012O000C010200034O00E0000300043O00202O0003000300514O000400046O000500016O00020005000200062O0002003D2O013O0004763O003D2O012O000C010200013O001272000300523O001272000400534O00E9000200044O009E00026O000C0102000D3O0020FD0002000200544O0003000E6O0004000F6O00020004000200062O000200462O0100010004763O00462O01002E4B0056000F020100550004763O000F02012O000C010200104O00F2000300013O00122O000400573O00122O000500586O00030005000200062O0002004F2O0100030004763O004F2O01002ED5005A006C2O0100590004763O006C2O012O000C01026O009F000300013O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O0002000200184O00020002000200062O0002005B2O0100010004763O005B2O01002E4B005D000F020100480004763O000F02012O000C010200034O002O010300043O00202O00030003005E4O000400113O00202O00040004005F00122O000600606O0004000600024O000400046O00020004000200062O0002000F02013O0004763O000F02012O000C010200013O00120A010300613O00122O000400626O000200046O00025O00044O000F02012O000C010200104O0050000300013O00122O000400633O00122O000500646O00030005000200062O0002008B2O0100030004763O008B2O01002EC50065009C000100650004763O000F02012O000C01026O0008010300013O00122O000400663O00122O000500676O0003000500024O00020002000300202O0002000200184O00020002000200062O0002000F02013O0004763O000F02012O000C010200034O000C010300043O00201D0103000300682O00F50002000200020006F70002000F02013O0004763O000F02012O000C010200013O00120A010300693O00122O0004006A6O000200046O00025O00044O000F02012O000C010200104O00F2000300013O00122O0004006B3O00122O0005006C6O00030005000200062O000200932O0100030004763O00932O010004763O000F02012O000C01026O0008010300013O00122O0004006D3O00122O0005006E6O0003000500024O00020002000300202O0002000200184O00020002000200062O0002000F02013O0004763O000F02012O000C010200123O00204E00020002006F2O00F50002000200020006F70002000F02013O0004763O000F02012O000C010200093O00204E0002000200702O000C010400124O00E40002000400020006F70002000F02013O0004763O000F0201002E4B0072000F020100710004763O000F02012O000C010200034O000C010300043O00201D0103000300682O00F50002000200020006F70002000F02013O0004763O000F02012O000C010200013O00120A010300733O00122O000400746O000200046O00025O00044O000F0201000E95000100BA2O0100010004763O00BA2O01002EC50075004DFE2O00760004763O00050001001272000200013O002653000200BF2O0100010004763O00BF2O01002EC500770048000100200004763O000502012O000C01036O0008010400013O00122O000500783O00122O000600796O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300D72O013O0004763O00D72O012O000C010300093O00204E00030003007A2O00F5000300020002000E40000800D72O0100030004763O00D72O012O000C010300023O00204E00030003000C2O00F50003000200022O000C010400133O000667000300D72O0100040004763O00D72O012O000C010300143O00061B010300D92O0100010004763O00D92O01002E4B007B00E42O01007C0004763O00E42O012O000C010300034O000C010400043O00201D01040004007D2O00F50003000200020006F7000300E42O013O0004763O00E42O012O000C010300013O0012720004007E3O0012720005007F4O00E9000300054O009E00035O002EC500800020000100800004763O000402012O000C01036O0008010400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003000402013O0004763O000402012O000C010300023O00204E00030003000C2O00F50003000200022O000C010400153O00066700030004020100040004763O000402012O000C010300163O0006F70003000402013O0004763O000402012O000C010300034O000C010400043O00201D0104000400832O00F50003000200020006F70003000402013O0004763O000402012O000C010300013O001272000400843O001272000500854O00E9000300054O009E00035O001272000200053O00265300020009020100050004763O00090201002E4B008600BB2O0100870004763O00BB2O01001272000100053O0004763O000500010004763O00BB2O010004763O000500010004763O000F02010004763O000200012O0018012O00017O000E3O00028O00026O00F03F025O00B8A940025O00EC9640027O0040025O00689540026O008340025O007AA840025O00389A40025O0071B240025O0038944003063O0045786973747303093O004973496E52616E6765026O00444000393O0012723O00014O00F9000100023O00261A012O0007000100010004763O00070001001272000100014O00F9000200023O0012723O00023O0026533O000B000100020004763O000B0001002ED500030002000100040004763O0002000100261A2O010013000100050004763O0013000100061B01020011000100010004763O00110001002EC500060029000100070004763O003800012O003C000200023O0004763O00380001002E4B00090020000100080004763O0020000100261A2O010020000100020004763O00200001002ED5000B001C0001000A0004763O001C00010006F70002001C00013O0004763O001C00012O003C000200024O000C01036O00CB0003000100022O008E000200033O001272000100053O00261A2O01000B000100010004763O000B00012O000C010300013O0006F70003003000013O0004763O003000012O000C010300013O00204E00030003000C2O00F50003000200020006F70003003000013O0004763O003000012O000C010300013O00204E00030003000D0012720005000E4O00E400030005000200061B01030031000100010004763O003100012O0018012O00014O000C010300024O00CB0003000100022O008E000200033O001272000100023O0004763O000B00010004763O003800010004763O000200012O0018012O00017O00AA3O00028O00026O00F03F026O001840025O003EA540025O00207540026O001C40025O00AEA140025O00F0B04003043O0027A2337603043O001369CD5D025O00109240025O00107840030D3O008B0DDF8230A707D8AD36AE00CA03053O005FC968BEE1030A3O0049734361737461626C6503093O004E616D6564556E6974026O004440026O003E400003083O0042752O66446F776E030D3O00426561636F6E6F664C6967687403123O00426561636F6E6F664C696768744D6163726F025O009C9B40025O000CB04003163O00ADCEC0CDA0C5FEC1A9F4CDC7A8C3D58EACC42OCCAEDF03043O00AECFABA103043O00C3F103F603063O00B78D9E6D9398030D3O000E0CE70F2307E92O0A08EF182403043O006C4C6986030D3O00426561636F6E6F66466169746803123O00426561636F6E6F6646616974684D6163726F03163O00E9C0B0E2C1E5FABEE7F1EDC4B8F5C6ABC6BEECCCEAD103053O00AE8BA5D181027O0040030D3O0048616E646C654368726F6D696503073O00436C65616E736503103O00436C65616E73654D6F7573656F766572025O0078A840025O0042AD4003093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F766572026O000840025O00FAB240025O004EB340025O00C49940025O0018A440025O0048B140025O0020A940030F3O0047657443617374696E67456E656D7903143O00426C61636B6F757442612O72656C446562752O6603113O00878600DD6A7FAB8D0AC85F64A08F01C17403063O0016C5EA65AE1903073O0049735265616479025O00709840025O006CAC40025O0014A340025O00CCAF40026O00AF40025O00F0904003123O00466F637573537065636966696564556E697403163O00476574556E697473546172676574467269656E646C79025O0029B040025O003C9C40030A3O00556E69744973556E697403023O004944025O00B07B40025O00D0964003163O00426C652O73696E676F6646722O65646F6D466F637573025O0026A540025O00E06F40031A3O002F38A0CF65A6D981123BA3E370BDD283293BA89C75A0DA842C2003083O00E64D54C5BC16CFB7031B3O00466F637573556E697457697468446562752O6646726F6D4C69737403073O00C915CAFD88A8FE03083O00559974A69CECC19003113O0046722O65646F6D446562752O664C697374026O003440025O001CAF40025O00F4B240026O002040025O0041B240025O00DEA640025O00B6A740026O002240025O0053B140025O00A49E40030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572026O001040025O0058AB40025O00B88340025O00C89C40025O00E8AE4003113O0086EC48A0F709AAE742B5C212A1E549BCE903063O0060C4802DD38403153O00556E6974486173446562752O6646726F6D4C69737403073O00058C775ED6A6BA03083O00B855ED1B3FB2CFD4025O0096A040025O00689740031A3O000A550C4C1B50075837560F600E4B0C5A0C56041F0B56045D094D03043O003F683969025O00EC9E40025O00109E40025O00408A40025O00FCB040025O00E7B140025O0093B140025O007DB040025O0042B040025O0034A640025O00E3B240030F3O0048616E646C65412O666C696374656403093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572025O00549640025O0006AE40025O008AA440025O00CAA740025O00EEAA40025O00B2A640025O0002A640025O00088040030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F766572025O00E08640025O00ECA340025O0022A840025O00806440030D3O00546172676574497356616C6964025O00BC9640025O00E4AE40025O00C06240025O00F2A840025O009CAD40025O00F07C40025O0046AB40025O00EAA340025O0018A040025O002EAF40025O00CCA840025O00A8A940025O00249C40026O001440025O007BB040025O00CDB040025O0060AD40025O00206E40025O00D89840025O00B08F40025O00149040025O0070A14003113O0048616E646C65496E636F72706F7265616C03083O005475726E4576696C03113O005475726E4576696C4D6F7573656F766572025O00CC9C40025O0050B040030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F766572025O00688540025O0075B240025O00B4A84003083O00446562752O66557003093O00456E74616E676C656403113O00298BA157188EAA43048182560E82A04B0603043O00246BE7C403173O00426C652O73696E676F6646722O65646F6D506C61796572031A3O005FB9A7944EBCAC8062BAA4B85B2OA78259BAAFC75EBAAF855CA103043O00E73DD5C20017032O0012723O00014O00F9000100033O00261A012O0010030100020004763O001003012O00F9000300033O00261A2O010009030100020004763O00090301000ECF0003008C000100020004763O008C0001001272000400014O00F9000500053O0026530004000F000100010004763O000F0001002EC5000400FEFF2O00050004763O000B0001001272000500013O00261A01050017000100020004763O001700012O000C01066O00CB0006000100022O008E000300063O001272000200063O0004763O008C0001002E4B00070010000100080004763O0010000100261A01050010000100010004763O00100001001272000600013O00261A01060084000100010004763O008400012O000C010700014O0050000800023O00122O000900093O00122O000A000A6O0008000A000200062O00070027000100080004763O00270001002E4B000B00520001000C0004763O005200012O000C010700034O0008010800023O00122O0009000D3O00122O000A000E6O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007005200013O0004763O005200012O000C010700043O00207E00070007001000122O000800116O000900013O00122O000A00126O0007000A000200262O00070052000100130004763O005200012O000C010700043O00207700070007001000122O000800116O000900013O00122O000A00126O0007000A000200202O0007000700144O000900033O00202O0009000900154O00070009000200062O0007005200013O0004763O005200012O000C010700054O000C010800063O00201D0108000800162O00F500070002000200061B0107004D000100010004763O004D0001002ED500180052000100170004763O005200012O000C010700023O001272000800193O0012720009001A4O00E9000700094O009E00076O000C010700074O0050000800023O00122O0009001B3O00122O000A001C6O0008000A000200062O0007005A000100080004763O005A00010004763O008300012O000C010700034O0008010800023O00122O0009001D3O00122O000A001E6O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007008300013O0004763O008300012O000C010700043O00207E00070007001000122O000800116O000900073O00122O000A00126O0007000A000200262O00070083000100130004763O008300012O000C010700043O00207700070007001000122O000800116O000900073O00122O000A00126O0007000A000200202O0007000700144O000900033O00202O00090009001F4O00070009000200062O0007008300013O0004763O008300012O000C010700054O000C010800063O00201D0108000800202O00F50007000200020006F70007008300013O0004763O008300012O000C010700023O001272000800213O001272000900224O00E9000700094O009E00075O001272000600023O00261A0106001C000100020004763O001C0001001272000500023O0004763O001000010004763O001C00010004763O001000010004763O008C00010004763O000B000100261A010200A6000100230004763O00A600012O000C010400043O0020560004000400244O000500033O00202O0005000500254O000600063O00202O00060006002600122O000700116O0004000700024O000300043O002E2O0027009C000100280004763O009C00010006F70003009C00013O0004763O009C00012O003C000300024O000C010400043O0020360004000400244O000500033O00202O0005000500294O000600063O00202O00060006002A00122O000700116O0004000700024O000300043O00122O0002002B3O002653000200AA000100010004763O00AA0001002EC5002C007D0001002D0004763O00252O01001272000400013O002E4B002E00B40001002F0004763O00B4000100261A010400B4000100020004763O00B400010006F7000300B200013O0004763O00B200012O003C000300023O001272000200023O0004763O00252O01002653000400B8000100010004763O00B80001002E4B003000AB000100310004763O00AB00012O000C010500043O0020B60005000500324O000600033O00202O0006000600334O00050002000200062O000500162O013O0004763O00162O012O000C010500034O0008010600023O00122O000700343O00122O000800356O0006000800024O00050005000600202O0005000500364O00050002000200062O000500162O013O0004763O00162O01001272000500014O00F9000600073O002653000500CF000100010004763O00CF0001002ED5003800D2000100370004763O00D20001001272000600014O00F9000700073O001272000500023O002ED5003900CB0001003A0004763O00CB000100261A010500CB000100020004763O00CB0001000E95000100DA000100060004763O00DA0001002E4B003B00EB0001003C0004763O00EB00012O000C010800043O0020B900080008003D4O000900043O00202O00090009003E4O000A00043O00202O000A000A00324O000B00033O00202O000B000B00334O000A000B6O00093O000200122O000A00116O0008000A00024O000700083O00062O000700EA00013O0004763O00EA00012O003C000700023O001272000600023O002653000600EF000100020004763O00EF0001002ED5003F00D6000100400004763O00D600012O000C010800083O0006F7000800032O013O0004763O00032O0100120E000800414O00FB000900083O00202O0009000900424O0009000200024O000A00043O00202O000A000A003E4O000B00043O00202O000B000B00324O000C00033O00202O000C000C00334O000B000C6O000A3O000200202O000A000A00424O000A000B6O00083O000200062O000800052O0100010004763O00052O01002E4B004400162O0100430004763O00162O012O000C010800054O000C010900063O00201D0109000900452O00F500080002000200061B0108000D2O0100010004763O000D2O01002ED5004600162O0100470004763O00162O012O000C010800023O00120A010900483O00122O000A00496O0008000A6O00085O00044O00162O010004763O00D600010004763O00162O010004763O00CB00012O000C010500043O0020A700050005004A4O000600096O000700023O00122O0008004B3O00122O0009004C6O0007000900024O00060006000700202O00060006004D00122O000700113O00122O0008004E4O00E40005000800022O008E000300053O001272000400023O0004763O00AB0001002E4B004F003F2O0100500004763O003F2O0100261A0102003F2O0100510004763O003F2O01001272000400013O002EC50052000B000100520004763O00352O0100261A010400352O0100010004763O00352O012O000C0105000A4O00CB0005000100022O008E000300053O0006F7000300342O013O0004763O00342O012O003C000300023O001272000400023O002ED50053002A2O0100540004763O002A2O0100261A0104002A2O0100020004763O002A2O012O000C0105000B4O00CB0005000100022O008E000300053O001272000200553O0004763O003F2O010004763O002A2O0100261A010200532O01002B0004763O00532O01002E4B005700462O0100560004763O00462O010006F7000300462O013O0004763O00462O012O003C000300024O000C010400043O00206B0004000400244O000500033O00202O0005000500584O000600063O00202O00060006005900122O000700116O0004000700024O000300043O00062O000300522O013O0004763O00522O012O003C000300023O0012720002005A3O00261A0102002A020100020004763O002A0201001272000400014O00F9000500053O0026530004005B2O0100010004763O005B2O01002E4B005B00572O01005C0004763O00572O01001272000500013O002ED5005D009F2O01005E0004763O009F2O01000ECF0001009F2O0100050004763O009F2O012O000C010600034O0008010700023O00122O0008005F3O00122O000900606O0007000900024O00060006000700202O0006000600364O00060002000200062O000600842O013O0004763O00842O012O000C010600043O0020160106000600614O000700086O000800096O000900023O00122O000A00623O00122O000B00636O0009000B00024O00080008000900202O00080008004D4O00060008000200062O000600842O013O0004763O00842O01002E4B006500842O0100640004763O00842O012O000C010600054O000C010700063O00201D0107000700452O00F50006000200020006F7000600842O013O0004763O00842O012O000C010600023O001272000700663O001272000800674O00E9000600084O009E00066O000C0106000C3O00061B010600892O0100010004763O00892O01002EC500680017000100690004763O009E2O01001272000600014O00F9000700073O0026530006008F2O0100010004763O008F2O01002ED5006B008B2O01006A0004763O008B2O01001272000700013O002ED5006D00902O01006C0004763O00902O0100261A010700902O0100010004763O00902O012O000C0108000D4O00CB0008000100022O008E000300083O0006F70003009E2O013O0004763O009E2O012O003C000300023O0004763O009E2O010004763O00902O010004763O009E2O010004763O008B2O01001272000500023O00261A0105005C2O0100020004763O005C2O01002ED5006F00250201006E0004763O002502012O000C0106000E3O0006F70006002502013O0004763O00250201001272000600014O00F9000700073O00261A010600A82O0100010004763O00A82O01001272000700013O002ED5007000BC2O0100710004763O00BC2O0100261A010700BC2O0100010004763O00BC2O012O000C010800043O00206B0008000800724O000900033O00202O0009000900254O000A00063O00202O000A000A002600122O000B00116O0008000B00024O000300083O00062O000300BB2O013O0004763O00BB2O012O003C000300023O001272000700023O00261A010700CB2O01005A0004763O00CB2O012O000C010800043O00206B0008000800724O000900033O00202O0009000900734O000A00063O00202O000A000A007400122O000B00116O0008000B00024O000300083O00062O0003002502013O0004763O002502012O003C000300023O0004763O00250201000ECF000200EE2O0100070004763O00EE2O01001272000800013O00261A010800D22O0100020004763O00D22O01001272000700233O0004763O00EE2O0100261A010800CE2O0100010004763O00CE2O01001272000900013O002653000900D92O0100020004763O00D92O01002E4B007600DB2O0100750004763O00DB2O01001272000800023O0004763O00CE2O01002653000900DF2O0100010004763O00DF2O01002ED5007800D52O0100770004763O00D52O012O000C010A00043O00206B000A000A00724O000B00033O00202O000B000B00294O000C00063O00202O000C000C002A00122O000D00116O000A000D00024O0003000A3O00062O000300EB2O013O0004763O00EB2O012O003C000300023O001272000900023O0004763O00D52O010004763O00CE2O0100261A0107000B0201002B0004763O000B0201001272000800013O002E4B007A00F72O0100790004763O00F72O01000ECF000200F72O0100080004763O00F72O010012720007005A3O0004763O000B0201002653000800FB2O0100010004763O00FB2O01002ED5007B00F12O01007C0004763O00F12O012O000C010900043O0020180009000900724O000A00033O00202O000A000A007D4O000B00063O00202O000B000B007E00122O000C00116O0009000C00024O000300093O00062O00030008020100010004763O00080201002E4B008000090201007F0004763O000902012O003C000300023O001272000800023O0004763O00F12O0100261A010700AB2O0100230004763O00AB2O01001272000800013O00261A0108001D020100010004763O001D02012O000C010900043O00206B0009000900724O000A00033O00202O000A000A00584O000B00063O00202O000B000B005900122O000C00116O0009000C00024O000300093O00062O0003001C02013O0004763O001C02012O003C000300023O001272000800023O00261A0108000E020100020004763O000E02010012720007002B3O0004763O00AB2O010004763O000E02010004763O00AB2O010004763O002502010004763O00A82O01001272000200233O0004763O002A02010004763O005C2O010004763O002A02010004763O00572O01002ED500820061020100810004763O00610201000ECF00550061020100020004763O006102010006F70003003102013O0004763O003102012O003C000300024O000C010400043O00201D0104000400832O00CB0004000100020006F70004001603013O0004763O00160301001272000400014O00F9000500053O00261A01040038020100010004763O00380201001272000500013O002E4B00840052020100850004763O0052020100261A01050052020100010004763O00520201001272000600013O00261A01060044020100020004763O00440201001272000500023O0004763O00520201002EC5008600FCFF2O00860004763O00400201000ECF00010040020100060004763O004002012O000C0107000F4O00CB0007000100022O008E000300073O002E4B00870050020100880004763O005002010006F70003005002013O0004763O005002012O003C000300023O001272000600023O0004763O0040020100261A0105003B020100020004763O003B02012O000C010600104O00CB0006000100022O008E000300063O00061B0103005B020100010004763O005B0201002EC5008900BD0001008A0004763O001603012O003C000300023O0004763O001603010004763O003B02010004763O001603010004763O003802010004763O00160301002E4B008C008D0201008B0004763O008D020100261A0102008D0201005A0004763O008D0201001272000400014O00F9000500053O002E4B008E00670201008D0004763O0067020100261A01040067020100010004763O00670201001272000500013O00261A0105007D020100010004763O007D02012O000C010600043O0020180006000600244O000700033O00202O00070007007D4O000800063O00202O00080008007E00122O000900116O0006000900024O000300063O00062O0003007B020100010004763O007B0201002E4B008F007C020100900004763O007C02012O003C000300023O001272000500023O00261A0105006C020100020004763O006C02012O000C010600043O0020360006000600244O000700033O00202O0007000700734O000800063O00202O00080008007400122O000900116O0006000900024O000300063O00122O000200913O0004763O008D02010004763O006C02010004763O008D02010004763O00670201000ECF000600A3020100020004763O00A30201001272000400013O00261A01040099020100010004763O009902010006F70003009502013O0004763O009502012O003C000300024O000C010500114O00CB0005000100022O008E000300053O001272000400023O00261A01040090020100020004763O00900201002E4B009200A0020100930004763O00A002010006F7000300A002013O0004763O00A002012O003C000300023O001272000200513O0004763O00A302010004763O00900201002653000200A7020100910004763O00A70201002ED500940007000100950004763O00070001001272000400013O00261A010400DF020100010004763O00DF02010006F7000300AD02013O0004763O00AD02012O003C000300024O000C010500123O00061B010500B2020100010004763O00B20201002E4B009600DE020100970004763O00DE0201001272000500014O00F9000600063O00261A010500B4020100010004763O00B40201001272000600013O002653000600BB020100020004763O00BB0201002E4B009900C9020100980004763O00C902012O000C010700043O0020EA00070007009A4O000800033O00202O00080008009B4O000900063O00202O00090009009C00122O000A00126O000B00016O0007000B00024O000300073O00062O000300DE02013O0004763O00DE02012O003C000300023O0004763O00DE0201002653000600CD020100010004763O00CD0201002E4B009E00B70201009D0004763O00B702012O000C010700043O0020EA00070007009A4O000800033O00202O00080008009F4O000900063O00202O0009000900A000122O000A00126O000B00016O0007000B00024O000300073O00062O000300DA02013O0004763O00DA02012O003C000300023O001272000600023O0004763O00B702010004763O00DE02010004763O00B40201001272000400023O00261A010400A8020100020004763O00A802012O000C010500133O00061B010500E6020100010004763O00E60201002ED500A20004030100A10004763O00040301002EC500A3001E000100A30004763O000403012O000C010500143O0020100105000500A44O000700033O00202O0007000700A54O00050007000200062O0005000403013O0004763O000403012O000C010500034O0008010600023O00122O000700A63O00122O000800A76O0006000800024O00050005000600202O0005000500364O00050002000200062O0005000403013O0004763O000403012O000C010500054O000C010600063O00201D0106000600A82O00F50005000200020006F70005000403013O0004763O000403012O000C010500023O001272000600A93O001272000700AA4O00E9000500074O009E00055O001272000200033O0004763O000700010004763O00A802010004763O000700010004763O0016030100261A2O010005000100010004763O00050001001272000200014O00F9000300033O001272000100023O0004763O000500010004763O0016030100261A012O0002000100010004763O00020001001272000100014O00F9000200023O0012723O00023O0004763O000200012O0018012O00017O00713O00028O00025O0063B040025O005EA940025O0062AD40025O006EA040030C3O0053686F756C6452657475726E025O0074B040025O00805840025O00708440025O0002A740027O0040025O0084A240025O00CCB140030F3O0048616E646C65412O666C6963746564030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572026O004440026O00F03F026O000840025O006CA340025O009CAA40026O001040025O00108040025O000EA240030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F766572025O0044A440025O00BC964003093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572025O00C1B140025O0098B040025O006C9A4003073O00436C65616E736503103O00436C65616E73654D6F7573656F766572025O00D88740025O002FB04003093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F766572025O001C9340025O001AA740025O00AAA340030D3O0048616E646C654368726F6D6965025O00788540025O0015B040025O00407240025O00889C40025O00AEB040025O009C984003113O0048616E646C65496E636F72706F7265616C030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F766572026O003E4003083O005475726E4576696C03113O005475726E4576696C4D6F7573656F766572025O00789F40025O00405F40025O004DB040025O00349D4003083O00446562752O66557003093O00456E74616E676C656403113O0081BFE7D2D50A7E7FACB5C4D3C3067477AE03083O0018C3D382A1A6631003073O004973526561647903173O00426C652O73696E676F6646722O65646F6D506C6179657203213O00440FEC3F401F4804D62355294011EC2957194B43E63947564905A92F5C1B4402FD03063O00762663894C33025O00D07740025O00F8AD4003043O00D3290B1703063O00409D46657269030D3O0062ADA6E01F4EA7A1CF1947A0B303053O007020C8C783030A3O0049734361737461626C6503093O004E616D6564556E69740003083O0042752O66446F776E030D3O00426561636F6E6F664C69676874025O00E0A940025O0012A940025O00489240026O002O4003123O00426561636F6E6F664C696768744D6163726F03163O002E555DBBCCA51D235663B4CAAC2A38105FB7CEA9233803073O00424C303CD8A3CB03043O00948977F603073O0044DAE619933FAE025O0050AA40025O00808740025O0034AE40030D3O008F2F524FB9A325556AB7A43E5B03053O00D6CD4A332C030D3O00426561636F6E6F66466169746803123O00426561636F6E6F6646616974684D6163726F03163O00F849E3FF78F473EDFA48FC4DEBE87FBA4FEDF175FB5803053O00179A2C829C025O00989640025O00D2AD40030C3O0035A3BBA1221A1EA88CBB241203063O007371C6CDCE56030C3O004465766F74696F6E41757261030D3O008052E855905EF154BB56EB488503043O003AE4379E030D3O00546172676574497356616C6964025O008AA240025O004CB140025O00C07F40025O001CB240025O00B09440025O00107A40025O0059B040025O00307C40025O0060A2400044023O000C016O0006F73O001A00013O0004763O001A00010012723O00014O00F9000100013O0026533O0009000100010004763O00090001002EC5000200FEFF2O00030004763O00050001001272000100013O0026530001000E000100010004763O000E0001002ED50004000A000100050004763O000A00012O000C010200014O00CB00020001000200122D000200063O00120E000200063O0006F70002001A00013O0004763O001A000100120E000200064O003C000200023O0004763O001A00010004763O000A00010004763O001A00010004763O000500012O000C012O00023O0006F73O00C600013O0004763O00C600010012723O00014O00F9000100013O0026533O0023000100010004763O00230001002E4B0007001F000100080004763O001F0001001272000100013O002ED5000900470001000A0004763O0047000100261A2O0100470001000B0004763O00470001001272000200014O00F9000300033O0026530002002E000100010004763O002E0001002EC5000C00FEFF2O000D0004763O002A0001001272000300013O000ECF00010040000100030004763O004000012O000C010400033O00201200040004000E4O000500043O00202O00050005000F4O000600053O00202O00060006001000122O000700116O00040007000200122O000400063O00122O000400063O00062O0004003F00013O0004763O003F000100120E000400064O003C000400023O001272000300123O00261A0103002F000100120004763O002F0001001272000100133O0004763O004700010004763O002F00010004763O004700010004763O002A000100261A2O010064000100130004763O00640001001272000200013O002E4B00140050000100150004763O0050000100261A01020050000100120004763O00500001001272000100163O0004763O0064000100265300020054000100010004763O00540001002E4B0018004A000100170004763O004A00012O000C010300033O00201200030003000E4O000400043O00202O0004000400194O000500053O00202O00050005001A00122O000600116O00030006000200122O000300063O00122O000300063O00062O0003006200013O0004763O0062000100120E000300064O003C000300023O001272000200123O0004763O004A0001002ED5001C00790001001B0004763O0079000100261A2O010079000100160004763O007900012O000C010200033O00201C00020002000E4O000300043O00202O00030003001D4O000400053O00202O00040004001E00122O000500116O00020005000200122O000200063O002E2O002000C60001001F0004763O00C6000100120E000200063O0006F7000200C600013O0004763O00C6000100120E000200064O003C000200023O0004763O00C60001002EC500210025000100210004763O009E000100261A2O01009E000100010004763O009E0001001272000200013O00261A01020099000100010004763O00990001001272000300013O00261A01030092000100010004763O009200012O000C010400033O00201200040004000E4O000500043O00202O0005000500224O000600053O00202O00060006002300122O000700116O00040007000200122O000400063O00122O000400063O00062O0004009100013O0004763O0091000100120E000400064O003C000400023O001272000300123O00265300030096000100120004763O00960001002ED500250081000100240004763O00810001001272000200123O0004763O009900010004763O0081000100261A0102007E000100120004763O007E0001001272000100123O0004763O009E00010004763O007E000100261A2O010024000100120004763O00240001001272000200013O000ECF000100BC000100020004763O00BC0001001272000300013O00261A010300B5000100010004763O00B500012O000C010400033O00201200040004000E4O000500043O00202O0005000500264O000600053O00202O00060006002700122O000700116O00040007000200122O000400063O00122O000400063O00062O000400B400013O0004763O00B4000100120E000400064O003C000400023O001272000300123O002EC5002800EFFF2O00280004763O00A4000100261A010300A4000100120004763O00A40001001272000200123O0004763O00BC00010004763O00A40001002653000200C0000100120004763O00C00001002ED5002900A10001002A0004763O00A100010012720001000B3O0004763O002400010004763O00A100010004763O002400010004763O00C600010004763O001F00012O000C012O00033O0020125O002B4O000100043O00202O0001000100224O000200053O00202O00020002002300122O000300118O0003000200124O00063O00124O00063O00064O00D400013O0004763O00D4000100120E3O00064O003C3O00024O000C012O00033O0020125O002B4O000100043O00202O0001000100264O000200053O00202O00020002002700122O000300118O0003000200124O00063O00124O00063O00064O00E200013O0004763O00E2000100120E3O00064O003C3O00024O000C012O00033O0020125O002B4O000100043O00202O00010001000F4O000200053O00202O00020002001000122O000300118O0003000200124O00063O00124O00063O00064O00F000013O0004763O00F0000100120E3O00064O003C3O00024O000C012O00033O00201C5O002B4O000100043O00202O0001000100194O000200053O00202O00020002001A00122O000300118O0003000200124O00063O002E2O002C2O002O01002D0004764O002O0100120E3O00063O0006F74O002O013O0004764O002O0100120E3O00064O003C3O00024O000C012O00033O0020125O002B4O000100043O00202O00010001001D4O000200053O00202O00020002001E00122O000300118O0003000200124O00063O00124O00063O00064O000E2O013O0004763O000E2O0100120E3O00064O003C3O00023O002EC5002E00390001002E0004763O00472O012O000C012O00063O0006F73O00472O013O0004763O00472O010012723O00013O002EC5002F001E0001002F0004763O00322O0100261A012O00322O0100010004763O00322O01001272000100013O002ED50031001F2O0100300004763O001F2O0100261A2O01001F2O0100120004763O001F2O010012723O00123O0004763O00322O0100261A2O0100192O0100010004763O00192O012O000C010200033O0020A90002000200324O000300043O00202O0003000300334O000400053O00202O00040004003400122O000500356O000600016O00020006000200122O000200063O00122O000200063O0006F7000200302O013O0004763O00302O0100120E000200064O003C000200023O001272000100123O0004763O00192O01000ECF001200142O013O0004763O00142O012O000C2O0100033O00206F0001000100324O000200043O00202O0002000200364O000300053O00202O00030003003700122O000400356O000500016O00010005000200122O000100063O002E2O003900472O0100380004763O00472O0100120E000100063O0006F7000100472O013O0004763O00472O0100120E000100064O003C000100023O0004763O00472O010004763O00142O012O000C012O00073O0006F73O00682O013O0004763O00682O01002E4B003B00682O01003A0004763O00682O012O000C012O00083O002010014O003C4O000200043O00202O00020002003D6O0002000200064O00682O013O0004763O00682O012O000C012O00044O00082O0100093O00122O0002003E3O00122O0003003F6O0001000300028O000100206O00406O0002000200064O00682O013O0004763O00682O012O000C012O000A4O000C2O0100053O00201D2O01000100412O00F53O000200020006F73O00682O013O0004763O00682O012O000C012O00093O001272000100423O001272000200434O00E93O00024O009E8O000C012O000B3O0006F73O00F12O013O0004763O00F12O010012723O00014O00F9000100023O00261A012O00722O0100010004763O00722O01001272000100014O00F9000200023O0012723O00123O000ECF0012006D2O013O0004763O006D2O01002653000100782O0100010004763O00782O01002E4B004500E32O0100440004763O00E32O012O000C0103000C4O0050000400093O00122O000500463O00122O000600476O00040006000200062O000300802O0100040004763O00802O010004763O00AD2O012O000C010300044O0008010400093O00122O000500483O00122O000600496O0004000600024O00030003000400202O00030003004A4O00030002000200062O0003009E2O013O0004763O009E2O012O000C010300033O00207E00030003004B00122O000400116O0005000C3O00122O000600356O00030006000200262O0003009E2O01004C0004763O009E2O012O000C010300033O0020EC00030003004B00122O000400116O0005000C3O00122O000600356O00030006000200202O00030003004D4O000500043O00202O00050005004E4O00030005000200062O000300A02O0100010004763O00A02O01002E4B004F00AD2O0100500004763O00AD2O01002E4B005200AD2O0100510004763O00AD2O012O000C0103000A4O000C010400053O00201D0104000400532O00F50003000200020006F7000300AD2O013O0004763O00AD2O012O000C010300093O001272000400543O001272000500554O00E9000300054O009E00036O000C0103000D4O00F2000400093O00122O000500563O00122O000600576O00040006000200062O000300E22O0100040004763O00E22O01002E4B005800B72O0100590004763O00B72O010004763O00E22O01002EC5005A002B0001005A0004763O00E22O012O000C010300044O0008010400093O00122O0005005B3O00122O0006005C6O0004000600024O00030003000400202O00030003004A4O00030002000200062O000300E22O013O0004763O00E22O012O000C010300033O00207E00030003004B00122O000400116O0005000D3O00122O000600356O00030006000200262O000300E22O01004C0004763O00E22O012O000C010300033O00207700030003004B00122O000400116O0005000D3O00122O000600356O00030006000200202O00030003004D4O000500043O00202O00050005005D4O00030005000200062O000300E22O013O0004763O00E22O012O000C0103000A4O000C010400053O00201D01040004005E2O00F50003000200020006F7000300E22O013O0004763O00E22O012O000C010300093O0012720004005F3O001272000500604O00E9000300054O009E00035O001272000100123O00261A2O0100742O0100120004763O00742O012O000C0103000E4O00CB0003000100022O008E000200033O00061B010200EC2O0100010004763O00EC2O01002EC500610007000100620004763O00F12O012O003C000200023O0004763O00F12O010004763O00742O010004763O00F12O010004763O006D2O012O000C012O00044O00082O0100093O00122O000200633O00122O000300646O0001000300028O000100206O004A6O0002000200064O000D02013O0004763O000D02012O000C012O00083O002010014O004D4O000200043O00202O0002000200656O0002000200064O000D02013O0004763O000D02012O000C012O000A4O000C2O0100043O00201D2O01000100652O00F53O000200020006F73O000D02013O0004763O000D02012O000C012O00093O001272000100663O001272000200674O00E93O00024O009E8O000C012O00033O00201D014O00682O00CB3O0001000200061B012O0014020100010004763O00140201002E4B006A0043020100690004763O004302010012723O00014O00F9000100033O000ECF0001001B02013O0004763O001B0201001272000100014O00F9000200023O0012723O00123O00261A012O0016020100120004763O001602012O00F9000300033O002ED5006B00310201006C0004763O0031020100261A2O010031020100120004763O00310201002EC5006D3O0001006D0004763O0022020100261A01020022020100010004763O002202012O000C0104000F4O00CB0004000100022O008E000300043O002ED5006E00430201006F0004763O004302010006F70003004302013O0004763O004302012O003C000300023O0004763O004302010004763O002202010004763O0043020100261A2O01001E020100010004763O001E0201001272000400013O000ECF00010039020100040004763O00390201001272000200014O00F9000300033O001272000400123O002E4B00700034020100710004763O00340201000ECF00120034020100040004763O00340201001272000100123O0004763O001E02010004763O003402010004763O001E02010004763O004302010004763O001602012O0018012O00017O00EA3O00028O00025O00349540025O009EA540025O00D09640025O0064AA40026O000840025O00F8AA40025O0078AB40026O00F03F025O0052AE40025O00889D40030C3O004570696353652O74696E677303083O008AB6B30B81FDF7AA03073O0090D9D3C77FE89303123O00D1212A2DC7571754EC1B363AD0560A4BF42B03083O0024984F5E48B5256203083O00E4DD532BDED6402C03043O005FB7B827030E3O00802CE20E51810EA137F4325B8E0703073O0062D55F874634E0025O00C0A140025O0098AC4003083O00CDA6DD635DF0A4DA03053O00349EC3A917030D3O0052B93378923D689F75B2375CB603083O00EB1ADC5214E6551B03083O00BBA4FDD67D86A6FA03053O0014E8C189A2031B3O0017CCC087F18919762BD1C291F58D03790DD9C3A3E99F1E6727D3DC03083O001142BFA5C687EC77027O004003083O003CAABA07F6E6EBC203083O00B16FCFCE739F888C03183O00309A1530DD59560B8C241BD84370038F151AC7464900850903073O003F65E97074B42F026O001040026O00204003083O00CC361D1E3BF6F82003063O00989F53696A52030C3O00B4D554DAC65098F559FDCA5703063O003CE1A63192A903083O001C1B3B3E0809280D03063O00674F7E4F4A61030B3O009270DF6A6D12B57CD85B6E03063O007ADA1FB3133E025O00DCA740025O00089E4003083O008BD86216BB5A7F3503083O0046D8BD1662D2341803103O00F2DEAD832ODFFAAD93D2D4D8AF8E2ODD03053O00B3BABFC3E703083O00CA3A0C2OF0311FF703043O0084995F7803113O0098BC1A28E5C8B5A1A63924E3D293A5A70003073O00C0D1D26E4D97BA025O005DB040025O00BCA34003083O00D30636FDF6CAE71003063O00A4806342899F03163O002987FDBB129BFCAE14A6E7B219BEE1B7148CE5B7139D03043O00DE60E98903083O0041EDD0B7024D7E6103073O00191288A4C36B23030F3O00C02CA74B7EB9E0BEEE21A04C66B9C503083O00D8884DC92F12DCA103083O001EE93FCE01D2853E03073O00E24D8C4BBA68BC03113O0091CFDE3B43BCE7DE3C40ABDEDF2D4AB8C203053O002FD9AEB05F025O008C9340025O0044974003083O00BFDD02CDB15E8BCB03063O0030ECB876B9D803113O00D0AE5211C133E0B15E33E931E4A95F35DD03063O005485DD3750AF03083O008EE230B2CE52BAF403063O003CDD8744C6A7030E3O00DBAEFDA14DDDF79CF68771D6FBB103063O00B98EDD98E32203083O0090A3DBDE34298AB803083O00CBC3C6AFAA5D47ED030B3O000A422DC5541DDE3B4D38C603073O009C4E2B5EB53171025O00F08440025O00AC9B4003083O006BC043EE4A3DF04B03073O009738A5379A2353030D3O008D4C13EBAD460BFA844609EFB903043O008EC0236503083O00E5703DB7EE82AB0503083O0076B61549C387ECCC030D3O002C3509502O01D90D3E0F46021E03073O009D685C7A20646D025O00CC9640025O00907440026O001C4003083O00CCE5A6AD0130F8F303063O005E9F80D2D968030E3O0065EA039E4A6DF85751EA12BA4D6603083O001A309966DF3F1F9903083O003145F9E70B4EEAE003043O009362208D030E3O003956F1CB2B57580C46F1D30E7E7B03073O002B782383AA6636025O00BCA640025O0060914003083O00278891232E57139E03063O003974EDE5574703153O0088BDE8F464E749AD9EEBD476ED55A3B72OE472C67703073O0027CAD18D87178E025O00188240025O00FCB14003083O00670393A2ACBE834703073O00E43466E7D6C5D003103O003FF567CBC78A0AC21BF26CEDF8840CC603083O00B67E8015AA8AEB7903083O00B8DF21F28F1D371503083O0066EBBA5586E6735003163O00621F3B7D7ED131440530585DD211560F2C5674DD215203073O0042376C5E3F12B4025O00F89F40025O007AB04003083O00F03EF906F138C42803063O0056A35B8D729803173O006618715B355F12477B3550005B753C5605677A2C56076D03053O005A336B141303083O00BEF591FB3483F79603053O005DED90E58F03113O0020E5F531044A0CC5F816084D36EFF3150E03063O0026759690796B025O0070A340025O0050894003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D030D3O0039E1F8A47015DDF3A07002F6EE03053O00116C929DE8026O001440025O00BAB240025O00D8AB40025O00507040025O0020614003083O001EBEFA2E24B5E92903043O005A4DDB8E03113O00D3172411430B63D50C2E3A472068E9113103073O001A866441592C6703083O00C2E62437ADFFE42303053O00C49183504303173O002BA3032017E407830E071BE32CB5001A1DFB169F08040103063O00887ED0666878025O00688440025O008C9A40025O00ACA340025O00D4A740025O00C7B240025O0020664003083O001D86045220D4299003063O00BA4EE370264903153O00C944F8655C6DF945CA5A417EDA58EF415A6EE953F803063O001A9C379D3533025O009EAC40025O00F88A4003083O001F7CF04C2577E34B03043O00384C198403113O0076C4AA2AC650C69B29DB57CEA508CE53C403053O00AF3EA1CB46034O0003083O000FD8D7073C32DAD003053O00555CBDA373030F3O0001A9313420A2370826B8393727840003043O005849CC5003083O00878CC43A35A332A703073O0055D4E9B04E5CCD030A3O007F4B8DD04B5B81E3464B03043O00822A38E803083O00D9B030F74931EDA603063O005F8AD544832003103O001F3BA46B732B24A84D711A27B54A792403053O00164A48C123025O0064AF40025O0052B240025O00807840025O00B8A040025O00B3B140025O0042A840025O002EAE4003083O0075CEE7FD75E141D803063O008F26AB93891C03123O00F48BAFFA0DE6E4C28DADF600F7DDDF8C91C303073O00B4B0E2D993638303083O00E0BC3B13DAB7281403043O0067B3D94F030F3O007FA419F1489AAA44B22FDD4889AF4E03073O00C32AD77CB521EC025O0006A940025O001AA14003083O003E5C232A2CF60A4A03063O00986D39575E45030E3O00DDDE1CAAB0D767A0F0D206A796E203083O00C899B76AC3DEB234026O001840025O00E88E40025O0095B04003083O0078C600F926A64CD003063O00C82BA3748D4F030C3O00933724ACBEDCE2B1322EAB8003073O0083DF565DE3D09403083O00D0402OA214BBE45603063O00D583252OD67D03133O001338209BE830222BBAD1342431BAE232222AB103053O0081464B45DF026O002E40025O00607840025O00E2A340025O00D49A4003083O0001E69C29405435F003063O003A5283E85D29030E3O00B644D522522D8778D6325130914E03063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B030E3O00C62A5FEBD6F70241E0CBE82165DF03053O00B991452D8F03083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C03123O006D2CE6A00E4534E4991B4D2EEB891B432FF303053O00692C5A83CE03083O00B91A0DB2D584180A03053O00BCEA7F79C603103O000D2116A22E371D84313C14B42A33078B03043O00E358527303083O00701AAEB30B7D440C03063O0013237FDAC762030F3O003DED0FEC1BF204E52BE90BF614D33A03043O00827C9B6A002C032O0012723O00014O00F9000100013O002ED500020002000100030004763O0002000100261A012O0002000100010004763O00020001001272000100013O002ED50004006F000100050004763O006F000100261A2O01006F000100060004763O006F0001001272000200013O00265300020010000100010004763O00100001002ED500080036000100070004763O00360001001272000300013O00261A01030015000100090004763O00150001001272000200093O0004763O00360001000E9500010019000100030004763O00190001002ED5000A00110001000B0004763O0011000100120E0004000C4O003E000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500062O00040027000100010004763O00270001001272000400014O006100045O0012DC0004000C6O000500013O00122O000600113O00122O000700126O0005000700024O0004000400054O000500013O00122O000600133O00122O000700146O0005000700024O0004000400054O000400023O00122O000300093O00044O001100010026530002003A000100090004763O003A0001002E4B0016005E000100150004763O005E0001001272000300013O00261A01030059000100010004763O0059000100120E0004000C4O003E000500013O00122O000600173O00122O000700186O0005000700024O0004000400054O000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500062O0004004B000100010004763O004B0001001272000400014O0061000400033O0012170104000C6O000500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000500013O00122O0006001D3O00122O0007001E6O0005000700024O0004000400054O000400043O00122O000300093O00261A0103003B000100090004763O003B00010012720002001F3O0004763O005E00010004763O003B000100261A0102000C0001001F0004763O000C000100120E0003000C4O0001000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000300053O00122O000100243O00044O006F00010004763O000C000100261A2O01008D000100250004763O008D000100120E0002000C4O00CD000300013O00122O000400263O00122O000500276O0003000500024O0002000200034O000300013O00122O000400283O00122O000500296O0003000500024O0002000200034O000200063O00122O0002000C6O000300013O00122O0004002A3O00122O0005002B6O0003000500024O0002000200034O000300013O00122O0004002C3O00122O0005002D6O0003000500024O00020002000300062O0002008B000100010004763O008B0001001272000200014O0061000200073O0004763O002B030100261A2O0100E30001001F0004763O00E30001001272000200013O000E9500090094000100020004763O00940001002E4B002E00AD0001002F0004763O00AD000100120E0003000C4O00E2000400013O00122O000500303O00122O000600316O0004000600024O0003000300044O000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000300083O00122O0003000C6O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000300093O00122O0002001F3O002653000200B10001001F0004763O00B10001002ED5003800BF000100390004763O00BF000100120E0003000C4O0001000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O0003000A3O00122O000100063O00044O00E3000100261A01020090000100010004763O00900001001272000300013O00261A010300C6000100090004763O00C60001001272000200093O0004763O0090000100261A010300C2000100010004763O00C2000100120E0004000C4O00E2000500013O00122O0006003E3O00122O0007003F6O0005000700024O0004000400054O000500013O00122O000600403O00122O000700416O0005000700024O0004000400054O0004000B3O00122O0004000C6O000500013O00122O000600423O00122O000700436O0005000700024O0004000400054O000500013O00122O000600443O00122O000700456O0005000700024O0004000400054O0004000C3O00122O000300093O0004763O00C200010004763O00900001000ECF0009003A2O0100010004763O003A2O01001272000200014O00F9000300033O00261A010200E7000100010004763O00E70001001272000300013O002653000300EE000100010004763O00EE0001002ED5004700072O0100460004763O00072O0100120E0004000C4O00E2000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O000500013O00122O0006004A3O00122O0007004B6O0005000700024O0004000400054O0004000D3O00122O0004000C6O000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O0004000E3O00122O000300093O00261A010300172O01001F0004763O00172O0100120E0004000C4O0001000500013O00122O000600503O00122O000700516O0005000700024O0004000400054O000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O0004000F3O00122O0001001F3O00044O003A2O010026530003001B2O0100090004763O001B2O01002EC5005400D1FF2O00550004763O00EA000100120E0004000C4O003E000500013O00122O000600563O00122O000700576O0005000700024O0004000400054O000500013O00122O000600583O00122O000700596O0005000700024O00040004000500062O000400292O0100010004763O00292O01001272000400014O0061000400103O0012DC0004000C6O000500013O00122O0006005A3O00122O0007005B6O0005000700024O0004000400054O000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000400113O00122O0003001F3O00044O00EA00010004763O003A2O010004763O00E70001002E4B005F00992O01005E0004763O00992O01000ECF006000992O0100010004763O00992O01001272000200014O00F9000300033O00261A010200402O0100010004763O00402O01001272000300013O00261A010300612O0100010004763O00612O0100120E0004000C4O00CD000500013O00122O000600613O00122O000700626O0005000700024O0004000400054O000500013O00122O000600633O00122O000700646O0005000700024O0004000400054O000400123O00122O0004000C6O000500013O00122O000600653O00122O000700666O0005000700024O0004000400054O000500013O00122O000600673O00122O000700686O0005000700024O00040004000500062O0004005F2O0100010004763O005F2O01001272000400014O0061000400133O001272000300093O002ED5006A00762O0100690004763O00762O01000ECF001F00762O0100030004763O00762O0100120E0004000C4O003E000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500062O000400732O0100010004763O00732O01001272000400014O0061000400143O001272000100253O0004763O00992O01002ED5006F00432O0100700004763O00432O0100261A010300432O0100090004763O00432O0100120E0004000C4O003E000500013O00122O000600713O00122O000700726O0005000700024O0004000400054O000500013O00122O000600733O00122O000700746O0005000700024O00040004000500062O000400882O0100010004763O00882O01001272000400014O0061000400153O0012DC0004000C6O000500013O00122O000600753O00122O000700766O0005000700024O0004000400054O000500013O00122O000600773O00122O000700786O0005000700024O0004000400054O000400163O00122O0003001F3O00044O00432O010004763O00992O010004763O00402O0100261A2O012O00020100240004764O000201001272000200013O00261A010200C12O0100010004763O00C12O01001272000300013O002E4B007900BC2O01007A0004763O00BC2O0100261A010300BC2O0100010004763O00BC2O0100120E0004000C4O00E2000500013O00122O0006007B3O00122O0007007C6O0005000700024O0004000400054O000500013O00122O0006007D3O00122O0007007E6O0005000700024O0004000400054O000400173O00122O0004000C6O000500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O0004000400054O000400183O00122O000300093O00261A0103009F2O0100090004763O009F2O01001272000200093O0004763O00C12O010004763O009F2O01002ED5008400D32O0100830004763O00D32O0100261A010200D32O01001F0004763O00D32O0100120E0003000C4O0001000400013O00122O000500853O00122O000600866O0004000600024O0003000300044O000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000300193O00122O000100893O00045O000201002E4B008B009C2O01008A0004763O009C2O0100261A0102009C2O0100090004763O009C2O01001272000300013O002653000300DC2O0100010004763O00DC2O01002E4B008C00F82O01008D0004763O00F82O0100120E0004000C4O003E000500013O00122O0006008E3O00122O0007008F6O0005000700024O0004000400054O000500013O00122O000600903O00122O000700916O0005000700024O00040004000500062O000400EA2O0100010004763O00EA2O01001272000400014O00610004001A3O0012170104000C6O000500013O00122O000600923O00122O000700936O0005000700024O0004000400054O000500013O00122O000600943O00122O000700956O0005000700024O0004000400054O0004001B3O00122O000300093O002653000300FC2O0100090004763O00FC2O01002E4B009700D82O0100960004763O00D82O010012720002001F3O0004763O009C2O010004763O00D82O010004763O009C2O01002E4B00980066020100990004763O00660201000ECF00010066020100010004763O00660201001272000200014O00F9000300033O002ED5009B00060201009A0004763O00060201000ECF00010006020100020004763O00060201001272000300013O00261A0103001B0201001F0004763O001B020100120E0004000C4O0001000500013O00122O0006009C3O00122O0007009D6O0005000700024O0004000400054O000500013O00122O0006009E3O00122O0007009F6O0005000700024O0004000400054O0004001C3O00122O000100093O00044O00660201002E4B00A1003E020100A00004763O003E020100261A0103003E020100090004763O003E020100120E0004000C4O003E000500013O00122O000600A23O00122O000700A36O0005000700024O0004000400054O000500013O00122O000600A43O00122O000700A56O0005000700024O00040004000500062O0004002D020100010004763O002D0201001272000400A64O00610004001D3O0012D10004000C6O000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O000500013O00122O000600A93O00122O000700AA6O0005000700024O00040004000500062O0004003C020100010004763O003C0201001272000400014O00610004001E3O0012720003001F3O00261A0103000B020100010004763O000B0201001272000400013O00261A0104005C020100010004763O005C020100120E0005000C4O00E2000600013O00122O000700AB3O00122O000800AC6O0006000800024O0005000500064O000600013O00122O000700AD3O00122O000800AE6O0006000800024O0005000500064O0005001F3O00122O0005000C6O000600013O00122O000700AF3O00122O000800B06O0006000800024O0005000500064O000600013O00122O000700B13O00122O000800B26O0006000800024O0005000500064O000500203O00122O000400093O002E4B00B30041020100B40004763O0041020100261A01040041020100090004763O00410201001272000300093O0004763O000B02010004763O004102010004763O000B02010004763O006602010004763O000602010026530001006A020100890004763O006A0201002ED500B600C9020100B50004763O00C90201001272000200014O00F9000300033O00265300020070020100010004763O00700201002E4B00B7006C020100B80004763O006C0201001272000300013O002EC500B90020000100B90004763O0091020100261A01030091020100090004763O0091020100120E0004000C4O003E000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O000500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500062O00040083020100010004763O00830201001272000400014O0061000400213O0012170104000C6O000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000500013O00122O000600C03O00122O000700C16O0005000700024O0004000400054O000400223O00122O0003001F3O002ED500C300A6020100C20004763O00A6020100261A010300A60201001F0004763O00A6020100120E0004000C4O003E000500013O00122O000600C43O00122O000700C56O0005000700024O0004000400054O000500013O00122O000600C63O00122O000700C76O0005000700024O00040004000500062O000400A3020100010004763O00A30201001272000400014O0061000400233O001272000100C83O0004763O00C90201002ED500C90071020100CA0004763O0071020100261A01030071020100010004763O0071020100120E0004000C4O003E000500013O00122O000600CB3O00122O000700CC6O0005000700024O0004000400054O000500013O00122O000600CD3O00122O000700CE6O0005000700024O00040004000500062O000400B8020100010004763O00B80201001272000400014O0061000400243O0012DC0004000C6O000500013O00122O000600CF3O00122O000700D06O0005000700024O0004000400054O000500013O00122O000600D13O00122O000700D26O0005000700024O0004000400054O000400253O00122O000300093O00044O007102010004763O00C902010004763O006C020100261A2O010007000100C80004763O00070001001272000200013O00261A010200F6020100010004763O00F60201001272000300013O002E4B00D300D5020100D40004763O00D5020100261A010300D5020100090004763O00D50201001272000200093O0004763O00F60201002E4B00D600CF020100D50004763O00CF020100261A010300CF020100010004763O00CF020100120E0004000C4O00CD000500013O00122O000600D73O00122O000700D86O0005000700024O0004000400054O000500013O00122O000600D93O00122O000700DA6O0005000700024O0004000400054O000400263O00122O0004000C6O000500013O00122O000600DB3O00122O000700DC6O0005000700024O0004000400054O000500013O00122O000600DD3O00122O000700DE6O0005000700024O00040004000500062O000400F3020100010004763O00F30201001272000400014O0061000400273O001272000300093O0004763O00CF020100261A010200090301001F0004763O0009030100120E0003000C4O003E000400013O00122O000500DF3O00122O000600E06O0004000600024O0003000300044O000400013O00122O000500E13O00122O000600E26O0004000600024O00030003000400062O00030006030100010004763O00060301001272000300014O0061000300283O001272000100603O0004763O0007000100261A010200CC020100090004763O00CC020100120E0003000C4O00CD000400013O00122O000500E33O00122O000600E46O0004000600024O0003000300044O000400013O00122O000500E53O00122O000600E66O0004000600024O0003000300044O000300293O00122O0003000C6O000400013O00122O000500E73O00122O000600E86O0004000600024O0003000300044O000400013O00122O000500E93O00122O000600EA6O0004000600024O00030003000400062O00030025030100010004763O00250301001272000300014O00610003002A3O0012720002001F3O0004763O00CC02010004763O000700010004763O002B03010004763O000200012O0018012O00017O00CC3O00028O00025O001BB240025O00805D40025O00289340025O0040A940025O006EAD40025O00108640030C3O004570696353652O74696E677303083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C1030F3O00C22948FF247AAAFF154BF5217CB1E303073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C8772030E3O000ED75C9146502EF75485466B00EB03063O001F48BB3DE22E026O00F03F027O004003083O00F08CD09588DBC49A03063O00B5A3E9A42OE1030B3O007884326E7C82397F44A30E03043O001730EB5E03083O00F00357C64E7023D003073O0044A36623B2271E03163O00987CDBD40B9A853DB777D2D32ABB8504AD79D5C92B8503083O0071DE10BAA763D5E303083O001D0BEFE22700FCE503043O00964E6E9B030C3O00B0D622C9AB12A66C8CC22FF503083O0020E5A54781C47EDF026O000840025O00B8A940025O000C974003083O0089E70EF2ECB4E50903053O0085DA827A8603113O0010F6E4CCC8B0103DF2EEC1CE962B3DF8E603073O00585C9F83A4BCC3034O00026O001040025O00A5B240025O00FC944003083O0029182A0C3CFF230903073O00447A7D5E785591030F3O003315D957C6DC8E1810C379DAD6AF0703073O00DA777CAF3EA8B903083O0096F55CD0ACFE4FD703043O00A4C59028030C3O00B6E3AFA3D2BA9AC0B882CEBB03063O00D6E390CAEBBD025O005C9B40025O00E0974003083O00DEA0936F19BD542F03083O005C8DC5E71B70D33303173O00D3EC8F8BDEEAE6BAB1D8F5F22OA5D7E3F199AAC7E3F39303053O00B1869FEAC303083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC0030B3O00F68473261234D79872171203063O0046BEEB1F5F42025O00688D40025O00ABB040026O001840025O00D89740025O00C0934003083O000E153AECD5313A2O03063O005F5D704E98BC03133O00E9F48B11CBB8F6C8E38C1BEDAACBE6E78A00F403073O00B2A195E57584DE026O001C4003083O0024369D1C1E3D8E1B03043O00687753E903113O00C0EB220A42FBFC082467FCEE2E2C4A2OE103053O00239598474203083O002AED56A43317EF5103053O005A798822D003103O00EF0F5B1AE8087117D1075B17D3177D2E03043O007EA76E35025O0048AB40025O00208E40025O004CA540025O00E2B14003083O002DC4B4F0B47C19D203063O00127EA1C084DD03113O006B31BC17725A24A712534D29A00753771803053O00363F48CE6403083O00FB5C516EEC75CF4A03063O001BA839251A8503143O0019B36EBBF328A675BED23FAB72ABD20AB873BDC703053O00B74DCA1CC803083O004FDFCC495E3DD56F03073O00B21CBAB83D3753030E3O00F1DE420BFD1CF1EBCB6030FD1CEC03073O0095A4AD275C926E03083O00C022040B1315F43403063O007B9347707F7A030D3O00FBC2907569CAEA8E7E54D5E5B203053O0026ACADE21103083O007E1438FB441F2BFC03043O008F2D714C03113O008DAB191EBDB91F33B6971A0AB1AA0829BD03043O005C2OD87C03083O006837B854F45535BF03053O009D3B52CC2003103O001A3BE2F9E6E4FCB70E37F1EEFCEFFB8103083O00D1585E839A898AB303083O001BA4D068172D363103083O004248C1A41C7E435103133O00C529A95B2978C82A9E513462F2298F4A2963F703063O0016874CC83846025O000FB240025O00E09B4003083O00BE35EC3054EF8A2303063O0081ED5098443D030E3O0064BB01DF151050458702D71D005603073O003831C864937C7703083O00FF3BABE4C530B8E303043O0090AC5EDF030E3O000806A54F3020A4632518AC4F0C3F03043O0027446FC2025O00108140025O00BC904003083O00E5A3F3D370B9D1B503063O00D7B6C687A71903103O00A140ED409966EC6C8C5EE46F9F46FF5803043O0028ED298A03083O00F471EEEC43C973E903053O002AA7149A98030D3O007FEDA766783743F0A7767E2D4603063O00412A9EC22211025O00FEB240025O0072AC4003083O002922461824E31CFD03083O008E7A47326C4D8D7B030C3O0031ABE911351096F014373D9203053O005B75C29F78025O0044A640025O00288F40026O001440025O0054B040025O0096B140025O00A06240025O00E88B4003083O0079DF02C6DE0FB95903073O00DE2ABA76B2B761030C3O0079ED5D884FE9458170ED4A8B03043O00EA3D8C2403083O0012D8AE66062FDAA903053O006F41BDDA12030A3O00674A02371959AE48632B03073O00CF232B7B556B3C025O00349040025O00489B4003083O00E4EDB638DEE6A53F03043O004CB788C203123O004FF5E00C495D075EE3E931464A067BE8E63D03073O00741A868558302F025O0034AD40025O00D8AC4003083O0043AFB4FE707EADB303053O001910CAC08A030E3O00D9CAB4E0BBF1FCC085C5BBFBE8DB03063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B1030D3O00A919034F9F1D1B46AA0A15589D03043O002DED787A03083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C603113O00BE3DB0023A10FD822BA70F3D24EE823ABD03073O008FEB4ED5405B6203083O00BE4D90FD79B88A5B03063O00D6ED28E4891003103O00A7E2FDCB0AA397CCE9FF02AF91EBC7E903063O00C6E5838FB96303083O006289BC675882AF6003043O001331ECC803123O00DC32F7B4EBB4D131DABEE3B2EA02E5B6E3BF03063O00DA9E5796D78403083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203123O00C7A3BBC487E2CAA09CC681F8ED93A9C68FE903063O008C85C6DAA7E8025O00DCAD40025O00B8894003083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B030E3O0002F58D1ED53DD48B1BCC2BEEA22603053O00A14E9CEA7603083O0094B2DDC8AEB9CECF03043O00BCC7D7A903113O00D0005873FCEF215E76E5F91B7869E7E91903053O00889C693F1B03083O0028896D2012827E2703043O00547BEC1903193O00D287AF04BFBCFE8C85119CA7FF9FAF14B8BCFF859F04ADB2F503063O00D590EBCA77CC03083O00101DCA3E212D4A3003073O002D4378BE4A484303143O00022EE8B6EA81E0EE0F24DDB7F69CEBEA342BE2AB03083O008940428DC599E88E03083O0030D536B2810DD73103053O00E863B042C6030B3O00D9322D227A94FB3EE9202303083O004C8C4148661BED9900BF022O0012723O00014O00F9000100013O0026533O0006000100010004763O00060001002EC5000200FEFF2O00030004763O00020001001272000100013O002ED50004005E000100050004763O005E0001000ECF0001005E000100010004763O005E0001001272000200013O002ED50007002C000100060004763O002C000100261A0102002C000100010004763O002C000100120E000300084O00CD000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O00035O00122O000300086O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O000400013O00122O0005000F3O00122O000600106O0004000600024O00030003000400062O0003002A000100010004763O002A0001001272000300014O0061000300023O001272000200113O00261A0102003F000100120004763O003F000100120E000300084O003E000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O00030003000400062O0003003C000100010004763O003C0001001272000300014O0061000300033O001272000100113O0004763O005E000100261A0102000C000100110004763O000C000100120E000300084O003E000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000400013O00122O000500193O00122O0006001A6O0004000600024O00030003000400062O0003004F000100010004763O004F0001001272000300014O0061000300043O0012DC000300086O000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000400013O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000300053O00122O000200123O00044O000C0001000ECF001F00B7000100010004763O00B70001001272000200013O002E4B00210076000100200004763O0076000100261A01020076000100120004763O0076000100120E000300084O003E000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000400013O00122O000500243O00122O000600256O0004000600024O00030003000400062O00030073000100010004763O00730001001272000300264O0061000300063O001272000100273O0004763O00B700010026530002007A000100010004763O007A0001002ED500280096000100290004763O0096000100120E000300084O003E000400013O00122O0005002A3O00122O0006002B6O0004000600024O0003000300044O000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400062O00030088000100010004763O00880001001272000300014O0061000300073O001217010300086O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000400013O00122O000500303O00122O000600316O0004000600024O0003000300044O000300083O00122O000200113O0026530002009A000100110004763O009A0001002ED500320061000100330004763O0061000100120E000300084O00CD000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000300093O00122O000300086O000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O000400013O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400062O000300B4000100010004763O00B40001001272000300014O00610003000A3O001272000200123O0004763O00610001002ED5003C00232O01003D0004763O00232O0100261A2O0100232O01003E0004763O00232O01001272000200014O00F9000300033O00261A010200BD000100010004763O00BD0001001272000300013O002E4B004000D50001003F0004763O00D5000100261A010300D5000100120004763O00D5000100120E000400084O003E000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O000500013O00122O000600433O00122O000700446O0005000700024O00040004000500062O000400D2000100010004763O00D20001001272000400014O00610004000B3O001272000100453O0004763O00232O01000ECF001100F3000100030004763O00F3000100120E000400084O00CD000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O0004000400054O0004000C3O00122O000400086O000500013O00122O0006004A3O00122O0007004B6O0005000700024O0004000400054O000500013O00122O0006004C3O00122O0007004D6O0005000700024O00040004000500062O000400F1000100010004763O00F10001001272000400014O00610004000D3O001272000300123O002653000300F7000100010004763O00F70001002E4B004E00C00001004F0004763O00C00001001272000400013O00261A010400FC000100110004763O00FC0001001272000300113O0004763O00C0000100265300042O002O0100010004764O002O01002EC5005000FAFF2O00510004763O00F8000100120E000500084O003E000600013O00122O000700523O00122O000800536O0006000800024O0005000500064O000600013O00122O000700543O00122O000800556O0006000800024O00050005000600062O0005000E2O0100010004763O000E2O01001272000500014O00610005000E3O0012D1000500086O000600013O00122O000700563O00122O000800576O0006000800024O0005000500064O000600013O00122O000700583O00122O000800596O0006000800024O00050005000600062O0005001D2O0100010004763O001D2O01001272000500014O00610005000F3O001272000400113O0004763O00F800010004763O00C000010004763O00232O010004763O00BD000100261A2O01006B2O0100110004763O006B2O0100120E000200084O00CD000300013O00122O0004005A3O00122O0005005B6O0003000500024O0002000200034O000300013O00122O0004005C3O00122O0005005D6O0003000500024O0002000200034O000200103O00122O000200086O000300013O00122O0004005E3O00122O0005005F6O0003000500024O0002000200034O000300013O00122O000400603O00122O000500616O0003000500024O00020002000300062O0002003F2O0100010004763O003F2O01001272000200014O0061000200113O001269000200086O000300013O00122O000400623O00122O000500636O0003000500024O0002000200034O000300013O00122O000400643O00122O000500656O0003000500024O0002000200034O000200123O00122O000200086O000300013O00122O000400663O00122O000500676O0003000500024O0002000200034O000300013O00122O000400683O00122O000500696O0003000500024O00020002000300062O0002005A2O0100010004763O005A2O01001272000200014O0061000200133O0012D1000200086O000300013O00122O0004006A3O00122O0005006B6O0003000500024O0002000200034O000300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300062O000200692O0100010004763O00692O01001272000200014O0061000200143O001272000100123O0026530001006F2O0100120004763O006F2O01002EC5006E00570001006F0004763O00C42O01001272000200013O00261A0102008E2O0100010004763O008E2O0100120E000300084O00CD000400013O00122O000500703O00122O000600716O0004000600024O0003000300044O000400013O00122O000500723O00122O000600736O0004000600024O0003000300044O000300153O00122O000300086O000400013O00122O000500743O00122O000600756O0004000600024O0003000300044O000400013O00122O000500763O00122O000600776O0004000600024O00030003000400062O0003008C2O0100010004763O008C2O01001272000300014O0061000300163O001272000200113O002E4B007800AE2O0100790004763O00AE2O0100261A010200AE2O0100110004763O00AE2O0100120E000300084O003E000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000400013O00122O0005007C3O00122O0006007D6O0004000600024O00030003000400062O000300A02O0100010004763O00A02O01001272000300014O0061000300173O001217010300086O000400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300044O000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000300183O00122O000200123O000E95001200B22O0100020004763O00B22O01002E4B008200702O0100830004763O00702O0100120E000300084O003E000400013O00122O000500843O00122O000600856O0004000600024O0003000300044O000400013O00122O000500863O00122O000600876O0004000600024O00030003000400062O000300C02O0100010004763O00C02O01001272000300014O0061000300193O0012720001001F3O0004763O00C42O010004763O00702O01002ED500890032020100880004763O0032020100261A2O0100320201008A0004763O00320201001272000200014O00F9000300033O002E4B008B00CA2O01008C0004763O00CA2O0100261A010200CA2O0100010004763O00CA2O01001272000300013O002653000300D32O0100010004763O00D32O01002EC5008D00210001008E0004763O00F22O0100120E000400084O003E000500013O00122O0006008F3O00122O000700906O0005000700024O0004000400054O000500013O00122O000600913O00122O000700926O0005000700024O00040004000500062O000400E12O0100010004763O00E12O01001272000400014O00610004001A3O0012D1000400086O000500013O00122O000600933O00122O000700946O0005000700024O0004000400054O000500013O00122O000600953O00122O000700966O0005000700024O00040004000500062O000400F02O0100010004763O00F02O01001272000400014O00610004001B3O001272000300113O002ED500970004020100980004763O0004020100261A01030004020100120004763O0004020100120E000400084O0001000500013O00122O000600993O00122O0007009A6O0005000700024O0004000400054O000500013O00122O0006009B3O00122O0007009C6O0005000700024O0004000400054O0004001C3O00122O0001003E3O00044O00320201002E4B009E00CF2O01009D0004763O00CF2O0100261A010300CF2O0100110004763O00CF2O01001272000400013O00261A0104002A020100010004763O002A020100120E000500084O003E000600013O00122O0007009F3O00122O000800A06O0006000800024O0005000500064O000600013O00122O000700A13O00122O000800A26O0006000800024O00050005000600062O00050019020100010004763O00190201001272000500014O00610005001D3O0012D1000500086O000600013O00122O000700A33O00122O000800A46O0006000800024O0005000500064O000600013O00122O000700A53O00122O000800A66O0006000800024O00050005000600062O00050028020100010004763O00280201001272000500014O00610005001E3O001272000400113O00261A01040009020100110004763O00090201001272000300123O0004763O00CF2O010004763O000902010004763O00CF2O010004763O003202010004763O00CA2O0100261A2O01006E020100450004763O006E020100120E000200084O00CD000300013O00122O000400A73O00122O000500A86O0003000500024O0002000200034O000300013O00122O000400A93O00122O000500AA6O0003000500024O0002000200034O0002001F3O00122O000200086O000300013O00122O000400AB3O00122O000500AC6O0003000500024O0002000200034O000300013O00122O000400AD3O00122O000500AE6O0003000500024O00020002000300062O0002004E020100010004763O004E0201001272000200014O0061000200203O0012D1000200086O000300013O00122O000400AF3O00122O000500B06O0003000500024O0002000200034O000300013O00122O000400B13O00122O000500B26O0003000500024O00020002000300062O0002005D020100010004763O005D0201001272000200264O0061000200213O0012D1000200086O000300013O00122O000400B33O00122O000500B46O0003000500024O0002000200034O000300013O00122O000400B53O00122O000500B66O0003000500024O00020002000300062O0002006C020100010004763O006C0201001272000200264O0061000200223O0004763O00BE020100265300010072020100270004763O00720201002ED500B70007000100B80004763O0007000100120E000200084O003E000300013O00122O000400B93O00122O000500BA6O0003000500024O0002000200034O000300013O00122O000400BB3O00122O000500BC6O0003000500024O00020002000300062O00020080020100010004763O00800201001272000200014O0061000200233O0012D1000200086O000300013O00122O000400BD3O00122O000500BE6O0003000500024O0002000200034O000300013O00122O000400BF3O00122O000500C06O0003000500024O00020002000300062O0002008F020100010004763O008F0201001272000200014O0061000200243O0012D1000200086O000300013O00122O000400C13O00122O000500C26O0003000500024O0002000200034O000300013O00122O000400C33O00122O000500C46O0003000500024O00020002000300062O0002009E020100010004763O009E0201001272000200264O0061000200253O0012D1000200086O000300013O00122O000400C53O00122O000500C66O0003000500024O0002000200034O000300013O00122O000400C73O00122O000500C86O0003000500024O00020002000300062O000200AD020100010004763O00AD0201001272000200014O0061000200263O0012DC000200086O000300013O00122O000400C93O00122O000500CA6O0003000500024O0002000200034O000300013O00122O000400CB3O00122O000500CC6O0003000500024O0002000200034O000200273O00122O0001008A3O00044O000700010004763O00BE02010004763O000200012O0018012O00017O00663O00028O00026O00F03F025O0062B340025O0094A840025O00B07D40025O0032B040030C3O004570696353652O74696E677303073O0064E5FFCF4D55F903053O0021308A98A803063O00761F2341C43B03063O005712765031A103073O007811DDA7BC490D03053O00D02C7EBAC003063O00E40AB6C315F803083O002E977AC4A6749CA9027O0040025O00405E40025O0020604003073O00D1E2411DF7E0FE03053O009B858D267A03053O002633AF4D4A03073O00C5454ACC212F1F03093O0049734D6F756E746564025O0014A040025O005EB340025O007C9B40025O00BFB140025O00607640025O004C9F4003073O008121B37A88B03D03053O00E4D54ED41D2O033O008843B503053O008BE72CD66503073O00EDE001591CB42203083O0076B98F663E70D1512O033O005F743A03083O00583C104986C5757C026O000840025O0080A240030D3O004973446561644F7247686F737403063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B025O008AA540026O00AF40025O00608940025O00389D4003163O0044656164467269656E646C79556E697473436F756E74025O0062AE40030F3O00412O66656374696E67436F6D626174030C3O00D9414E82E24C5F94E346558903043O00E7902F3A030A3O0049734361737461626C65025O000C9640025O00A8A240030C3O00496E74657263652O73696F6E030C3O00BBD6CE700A3ECA2AA1D1D57B03083O0059D2B8BA15785DAF030A3O004162736F6C7574696F6E030A3O00B0516FDA752FA55A73DB03063O005AD1331CB519025O00A3B240030A3O00526564656D7074696F6E03093O004973496E52616E6765026O004440030A3O00C27E53EBB2C06F5EE1B103053O00DFB01B378E025O00805840025O0052A240025O00C9B040025O006C9340025O00E06440025O006CB140025O00C8AD40025O0012A84003073O0007B7CBB42AA8CB03043O00D544DBAE03073O004973526561647903093O00466F637573556E6974026O003440025O0036AC40025O0011B340025O0016A140025O00D2AD40025O00C07A40025O00C88E4003163O00476574456E656D696573496E4D656C2O6552616E6765026O002040025O0010A740025O00F88F40025O00508140025O0034AB402O033O00414F45030C3O0049734368612O6E656C696E67025O00805240025O009AAB40025O00E49940025O00EEA940025O00409940025O00588F40025O00B0AC40025O00F88A4000BC012O0012723O00013O0026533O0005000100020004763O00050001002EC500030044000100040004763O00470001001272000100013O0026530001000A000100010004763O000A0001002ED500060023000100050004763O0023000100120E000200074O00E2000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O00025O00122O000200076O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000200023O00122O000100023O000ECF00100027000100010004763O002700010012723O00103O0004763O00470001000ECF00020006000100010004763O00060001001272000200013O00261A0102002E000100020004763O002E0001001272000100103O0004763O00060001000E9500010032000100020004763O00320001002E4B0012002A000100110004763O002A000100120E000300074O0023000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O0003000300042O0061000300034O000C010300043O00204E0003000300172O00F50003000200020006F70003004400013O0004763O004400012O0018012O00013O001272000200023O0004763O002A00010004763O00060001000ECF0001008300013O0004763O00830001001272000100013O0026530001004E000100010004763O004E0001002ED50019005F000100180004763O005F0001001272000200013O002EC5001A00060001001A0004763O0055000100261A01020055000100020004763O00550001001272000100023O0004763O005F0001000E9500010059000100020004763O00590001002EC5001B00F8FF2O001C0004763O004F00012O000C010300054O00990003000100014O000300066O00030001000100122O000200023O00044O004F0001002EC5001D001D0001001D0004763O007C000100261A2O01007C000100020004763O007C000100120E000200074O00E2000300013O00122O0004001E3O00122O0005001F6O0003000500024O0002000200034O000300013O00122O000400203O00122O000500216O0003000500024O0002000200034O000200073O00122O000200076O000300013O00122O000400223O00122O000500236O0003000500024O0002000200034O000300013O00122O000400243O00122O000500256O0003000500024O0002000200034O000200083O00122O000100103O00265300010080000100100004763O00800001002EC5002600CCFF2O00270004763O004A00010012723O00023O0004763O008300010004763O004A000100261A012O00552O0100100004763O00552O012O000C2O0100043O00204E0001000100282O00F50001000200020006F70001008B00013O0004763O008B00012O0018012O00014O000C2O0100093O0006F7000100A300013O0004763O00A300012O000C2O0100093O00204E0001000100292O00F50001000200020006F7000100A300013O0004763O00A300012O000C2O0100093O00204E00010001002A2O00F50001000200020006F7000100A300013O0004763O00A300012O000C2O0100093O00204E0001000100282O00F50001000200020006F7000100A300013O0004763O00A300012O000C2O0100043O00204E00010001002B2O000C010300094O00E40001000300020006F7000100A500013O0004763O00A50001002ED5002D00F50001002C0004763O00F50001001272000100014O00F9000200023O002E4B002E00A70001002F0004763O00A70001000ECF000100A7000100010004763O00A700012O000C0103000A3O00201D0103000300302O00CB0003000100022O008E000200033O002EC500310021000100310004763O00D000012O000C010300043O00204E0003000300322O00F50003000200020006F7000300D000013O0004763O00D000012O000C0103000B4O0008010400013O00122O000500333O00122O000600346O0004000600024O00030003000400202O0003000300354O00030002000200062O000300F500013O0004763O00F50001002ED5003600F5000100370004763O00F500012O000C0103000C4O00E00004000B3O00202O0004000400384O000500056O000600016O00030006000200062O000300F500013O0004763O00F500012O000C010300013O00120A010400393O00122O0005003A6O000300056O00035O00044O00F50001000EAE000200E0000100020004763O00E000012O000C0103000C4O00E00004000B3O00202O00040004003B4O000500056O000600016O00030006000200062O000300F500013O0004763O00F500012O000C010300013O00120A0104003C3O00122O0005003D6O000300056O00035O00044O00F50001002EC5003E00150001003E0004763O00F500012O000C0103000C4O00970004000B3O00202O00040004003F4O000500093O00202O00050005004000122O000700416O0005000700024O000500056O000600016O00030006000200062O000300F500013O0004763O00F500012O000C010300013O00120A010400423O00122O000500436O000300056O00035O00044O00F500010004763O00A700012O000C2O0100043O00204E0001000100322O00F500010002000200061B2O0100022O0100010004763O00022O012O000C2O01000D3O0006F700012O002O013O0004764O002O012O000C2O015O00061B2O0100022O0100010004763O00022O01002E4B0045004F2O0100440004763O004F2O01001272000100014O00F9000200043O002ED50047003F2O0100460004763O003F2O0100261A2O01003F2O0100020004763O003F2O012O00F9000400043O002E4B004800332O0100490004763O00332O0100261A010200332O0100010004763O00332O01001272000500013O002653000500122O0100020004763O00122O01002ED5004A00142O01004B0004763O00142O01001272000200023O0004763O00332O0100261A0105000E2O0100010004763O000E2O01001272000600013O00261A0106002D2O0100010004763O002D2O012O000C0107000D3O00060F000300252O0100070004763O00252O012O000C0107000B4O00C1000800013O00122O0009004C3O00122O000A004D6O0008000A00024O00070007000800202O00070007004E4O0007000200024O000300074O000C0107000A3O00206300070007004F4O000800036O0009000E3O00122O000A00506O0007000A00024O000400073O00122O000600023O000ECF000200172O0100060004763O00172O01001272000500023O0004763O000E2O010004763O00172O010004763O000E2O01002653000200372O0100020004763O00372O01002ED5005200092O0100510004763O00092O01002ED50053004F2O0100540004763O004F2O010006F70004004F2O013O0004763O004F2O012O003C000400023O0004763O004F2O010004763O00092O010004763O004F2O01002E4B005500042O0100560004763O00042O01000ECF000100042O0100010004763O00042O01001272000500013O00261A010500492O0100010004763O00492O01001272000200014O00F9000300033O001272000500023O000ECF000200442O0100050004763O00442O01001272000100023O0004763O00042O010004763O00442O010004763O00042O012O000C2O0100043O002O2000010001005700122O000300586O0001000300024O0001000F3O00124O00263O002E4B005A0001000100590004763O00010001000ECF0026000100013O0004763O00010001002E4B005B00622O01005C0004763O00622O0100120E0001005D3O0006F7000100622O013O0004763O00622O012O000C2O01000F4O008A000100014O0061000100103O0004763O00642O01001272000100024O0061000100104O000C2O0100043O00204E00010001005E2O00F500010002000200061B2O0100BB2O0100010004763O00BB2O012O000C2O0100073O00061B2O0100712O0100010004763O00712O012O000C2O0100043O00204E0001000100322O00F50001000200020006F7000100BB2O013O0004763O00BB2O012O000C2O0100043O00204E0001000100322O00F50001000200020006F7000100982O013O0004763O00982O01001272000100014O00F9000200033O00261A2O0100872O0100020004763O00872O0100261A0102007A2O0100010004763O007A2O012O000C010400114O00CB0004000100022O008E000300043O002E4B005F00BB2O0100600004763O00BB2O010006F7000300BB2O013O0004763O00BB2O012O003C000300023O0004763O00BB2O010004763O007A2O010004763O00BB2O01000ECF000100782O0100010004763O00782O01001272000400013O002ED5006100902O0100620004763O00902O01000ECF000200902O0100040004763O00902O01001272000100023O0004763O00782O0100261A0104008A2O0100010004763O008A2O01001272000200014O00F9000300033O001272000400023O0004763O008A2O010004763O00782O010004763O00BB2O01001272000100014O00F9000200033O000E950001009E2O0100010004763O009E2O01002EC50063000D000100640004763O00A92O01001272000400013O00261A010400A42O0100010004763O00A42O01001272000200014O00F9000300033O001272000400023O00261A0104009F2O0100020004763O009F2O01001272000100023O0004763O00A92O010004763O009F2O0100261A2O01009A2O0100020004763O009A2O0100261A010200AB2O0100010004763O00AB2O012O000C010400124O00CB0004000100022O008E000300043O00061B010300B42O0100010004763O00B42O01002E4B006500BB2O0100660004763O00BB2O012O003C000300023O0004763O00BB2O010004763O00AB2O010004763O00BB2O010004763O009A2O010004763O00BB2O010004763O000100012O0018012O00017O001B3O00028O00026O00F03F025O00208340025O00E89040025O00BCA040025O00409A40025O0068874003053O005072696E7403153O0023EF2FFE6AF53E730AE42AE96AC7263F2EF02AE46403083O001F6B8043874AA55F03123O00FCE1EF5D44BDD4E9FE414495DDEAE94B47A203063O00D1B8889C2D2103173O0023C16618BD0BC4740AB402E5740FB104EC700AAD01CE6603053O00D867A81568025O00709F40025O00A06A4003123O005CA450B47DA14FA57AA146807DAF56A27EBE03043O00C418CD23030A3O004D657267655461626C6503123O0044697370652O6C61626C65446562752O667303193O0044697370652O6C61626C6544697365617365446562752O6673030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E031F3O000684EF1F6EBBE20A2F8FEA086E9DA3577EC5B1487EDAA32437CBC1092186C803043O00664EEB83025O00A4B140025O004CA24000593O0012723O00014O00F9000100023O00261A012O0050000100020004763O00500001002ED500030004000100040004763O00040001000ECF00010004000100010004763O00040001001272000200013O002EC50005002A000100050004763O0033000100261A01020033000100010004763O00330001001272000300013O00265300030012000100020004763O00120001002ED500060014000100070004763O00140001001272000200023O0004763O0033000100261A0103000E000100010004763O000E0001001272000400013O000ECF0001002D000100040004763O002D00012O000C01055O0020AF0005000500084O000600013O00122O000700093O00122O0008000A6O000600086O00053O00014O000500026O000600013O00122O0007000B3O00122O0008000C6O0006000800024O000700026O000800013O00122O0009000D3O00122O000A000E6O0008000A00024O0007000700084O00050006000700122O000400023O00261A01040017000100020004763O00170001001272000300023O0004763O000E00010004763O001700010004763O000E000100265300020037000100020004763O00370001002ED5000F0009000100100004763O000900012O000C010300024O0068000400013O00122O000500113O00122O000600126O0004000600024O000500033O00202O0005000500134O000600023O00202O0006000600144O000700023O00202O0007000700154O0005000700024O00030004000500122O000300163O00202O0003000300174O000400013O00122O000500183O00122O000600196O000400066O00033O000100044O005800010004763O000900010004763O005800010004763O000400010004763O00580001002E4B001B00020001001A0004763O0002000100261A012O0002000100010004763O00020001001272000100014O00F9000200023O0012723O00023O0004763O000200012O0018012O00017O00", GetFEnv(), ...);

