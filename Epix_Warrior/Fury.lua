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
				if (Enum <= 130) then
					if (Enum <= 64) then
						if (Enum <= 31) then
							if (Enum <= 15) then
								if (Enum <= 7) then
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
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Enum == 2) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Upvalues[Inst[3]];
									end
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
										end
									elseif (Enum > 10) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 13) then
									if (Enum > 12) then
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
								elseif (Enum == 14) then
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
								end
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum > 16) then
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
										elseif (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 18) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 21) then
									if (Enum == 20) then
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
								elseif (Enum > 22) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum > 24) then
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
								elseif (Enum == 26) then
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
							elseif (Enum <= 29) then
								if (Enum > 28) then
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
								elseif Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 30) then
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
						elseif (Enum <= 47) then
							if (Enum <= 39) then
								if (Enum <= 35) then
									if (Enum <= 33) then
										if (Enum == 32) then
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
									elseif (Enum == 34) then
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
								elseif (Enum <= 37) then
									if (Enum == 36) then
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
								elseif (Enum > 38) then
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
							elseif (Enum <= 43) then
								if (Enum <= 41) then
									if (Enum > 40) then
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
								end
							elseif (Enum <= 45) then
								if (Enum == 44) then
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
							elseif (Enum > 46) then
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
							end
						elseif (Enum <= 55) then
							if (Enum <= 51) then
								if (Enum <= 49) then
									if (Enum == 48) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
									end
								elseif (Enum == 50) then
									if (Inst[2] <= Stk[Inst[4]]) then
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
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 54) then
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 59) then
							if (Enum <= 57) then
								if (Enum > 56) then
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
							elseif (Enum == 58) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								do
									return;
								end
							end
						elseif (Enum <= 61) then
							if (Enum == 60) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 63) then
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
					elseif (Enum <= 97) then
						if (Enum <= 80) then
							if (Enum <= 72) then
								if (Enum <= 68) then
									if (Enum <= 66) then
										if (Enum > 65) then
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
									elseif (Enum > 67) then
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
								elseif (Enum <= 70) then
									if (Enum == 69) then
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
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 71) then
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
							elseif (Enum <= 76) then
								if (Enum <= 74) then
									if (Enum == 73) then
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
								elseif (Enum == 75) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 78) then
								if (Enum == 77) then
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
								end
							elseif (Enum > 79) then
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
								do
									return Unpack(Stk, A, A + Inst[3]);
								end
							end
						elseif (Enum <= 88) then
							if (Enum <= 84) then
								if (Enum <= 82) then
									if (Enum > 81) then
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
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
										end
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
							elseif (Enum <= 86) then
								if (Enum > 85) then
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
							elseif (Enum > 87) then
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
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							end
						elseif (Enum <= 92) then
							if (Enum <= 90) then
								if (Enum == 89) then
									if (Stk[Inst[2]] == Inst[4]) then
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum > 91) then
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
						elseif (Enum <= 94) then
							if (Enum == 93) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum <= 95) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 96) then
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
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 113) then
						if (Enum <= 105) then
							if (Enum <= 101) then
								if (Enum <= 99) then
									if (Enum > 98) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 100) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 103) then
								if (Enum == 102) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 104) then
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
						elseif (Enum <= 109) then
							if (Enum <= 107) then
								if (Enum == 106) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								end
							elseif (Enum > 108) then
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 111) then
							if (Enum > 110) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
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
						elseif (Enum == 112) then
							do
								return Stk[Inst[2]];
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
					elseif (Enum <= 121) then
						if (Enum <= 117) then
							if (Enum <= 115) then
								if (Enum > 114) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								end
							elseif (Enum == 116) then
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
								VIP = Inst[3];
							end
						elseif (Enum <= 119) then
							if (Enum > 118) then
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
						elseif (Enum > 120) then
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
					elseif (Enum <= 125) then
						if (Enum <= 123) then
							if (Enum > 122) then
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
						elseif (Enum > 124) then
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
					elseif (Enum <= 127) then
						if (Enum == 126) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
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
						end
					elseif (Enum <= 128) then
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
					elseif (Enum > 129) then
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
				elseif (Enum <= 196) then
					if (Enum <= 163) then
						if (Enum <= 146) then
							if (Enum <= 138) then
								if (Enum <= 134) then
									if (Enum <= 132) then
										if (Enum == 131) then
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
									elseif (Enum > 133) then
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
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum <= 136) then
									if (Enum == 135) then
										local A = Inst[2];
										Stk[A] = Stk[A]();
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
								elseif (Enum > 137) then
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
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 142) then
								if (Enum <= 140) then
									if (Enum == 139) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 141) then
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
							elseif (Enum <= 144) then
								if (Enum > 143) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								end
							elseif (Enum > 145) then
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
							elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum <= 154) then
							if (Enum <= 150) then
								if (Enum <= 148) then
									if (Enum == 147) then
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
								elseif (Enum == 149) then
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
							elseif (Enum <= 152) then
								if (Enum > 151) then
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
							elseif (Enum == 153) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum <= 156) then
								if (Enum > 155) then
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
							elseif (Enum == 157) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 160) then
							if (Enum == 159) then
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
									if (Mvm[1] == 177) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 161) then
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
						elseif (Enum > 162) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 179) then
						if (Enum <= 171) then
							if (Enum <= 167) then
								if (Enum <= 165) then
									if (Enum == 164) then
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
									end
								elseif (Enum == 166) then
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
							elseif (Enum <= 169) then
								if (Enum > 168) then
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
							elseif (Enum == 170) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 175) then
							if (Enum <= 173) then
								if (Enum == 172) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 174) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 177) then
							if (Enum > 176) then
								Stk[Inst[2]] = Stk[Inst[3]];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
							end
						elseif (Enum > 178) then
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
						end
					elseif (Enum <= 187) then
						if (Enum <= 183) then
							if (Enum <= 181) then
								if (Enum == 180) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								elseif (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 182) then
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
						elseif (Enum <= 185) then
							if (Enum > 184) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum == 186) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 191) then
						if (Enum <= 189) then
							if (Enum == 188) then
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
						elseif (Enum > 190) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 193) then
						if (Enum == 192) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 194) then
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
					elseif (Enum > 195) then
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
				elseif (Enum <= 229) then
					if (Enum <= 212) then
						if (Enum <= 204) then
							if (Enum <= 200) then
								if (Enum <= 198) then
									if (Enum > 197) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 199) then
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
									Stk[Inst[2]]();
								end
							elseif (Enum <= 202) then
								if (Enum > 201) then
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
							elseif (Enum > 203) then
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
						elseif (Enum <= 208) then
							if (Enum <= 206) then
								if (Enum > 205) then
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
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 207) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 210) then
							if (Enum > 209) then
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
						elseif (Enum == 211) then
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
					elseif (Enum <= 220) then
						if (Enum <= 216) then
							if (Enum <= 214) then
								if (Enum > 213) then
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum > 215) then
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
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 218) then
							if (Enum == 217) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 219) then
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
					elseif (Enum <= 224) then
						if (Enum <= 222) then
							if (Enum == 221) then
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
						elseif (Enum == 223) then
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
							if Stk[Inst[2]] then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 227) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
						end
					elseif (Enum > 228) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 245) then
					if (Enum <= 237) then
						if (Enum <= 233) then
							if (Enum <= 231) then
								if (Enum == 230) then
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
							elseif (Enum == 232) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 235) then
							if (Enum == 234) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 236) then
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
					elseif (Enum <= 241) then
						if (Enum <= 239) then
							if (Enum > 238) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 240) then
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
					elseif (Enum <= 243) then
						if (Enum == 242) then
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
						else
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum == 244) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
				elseif (Enum <= 253) then
					if (Enum <= 249) then
						if (Enum <= 247) then
							if (Enum == 246) then
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
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 251) then
						if (Enum == 250) then
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
					elseif (Enum == 252) then
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
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
					end
				elseif (Enum <= 257) then
					if (Enum <= 255) then
						if (Enum > 254) then
							local B;
							local A;
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
					elseif (Enum == 256) then
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
				elseif (Enum <= 259) then
					if (Enum == 258) then
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
				elseif (Enum <= 260) then
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
				elseif (Enum == 261) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!283O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403053O005574696C7303063O00506C6179657203063O00546172676574030C3O0054617267657454617267657403053O00466F63757303053O005370652O6C03043O004974656D03043O0042696E6403043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C026O00144003073O0057612O72696F7203043O0046757279030F3O005370652O6C5265666C656374494473024O0080B3C54003103O005265676973746572466F724576656E7403143O009D5498B9169F478BA514885686A51D8C5A95A51703053O0053CD18D9E003063O0053657441504C026O0052400050012O0012663O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100048F3O000A0001001291000300063O002072000400030007001291000500083O002072000500050009001291000600083O00207200060006000A0006A000073O000100062O00B13O00064O00B18O00B13O00044O00B13O00014O00B13O00024O00B13O00054O00950008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000D001100202O0010000D001200202O0011000D00130020720012000D00140020DF0013000B001500202O0014000B001600122O0015000D3O00202O00160015001700202O00170015001800202O00180015001900202O00190015001A00202O001A0015001B00202O001A001A001C00202O001A001A001D002072001B0015001B0020F2001B001B001C00202O001B001B001E00122O001C001F6O001D001D6O001E8O001F8O00208O0021005C3O00202O005D0015001B00202O005D005D001C002072005E001300200020FF005E005E002100202O005F0014002000202O005F005F002100202O00600018002000202O00600060002100202O0061005D00224O00625O00122O006300233O00122O006400233O00202O0065000B00240006A000670001000100022O00B13O00634O00B13O00644O0056006800073O00122O006900253O00122O006A00266O0068006A6O00653O00014O006500673O0006A000680002000100012O00B13O00103O0006A000690003000100052O00B13O000E4O00B13O00614O00B13O00104O00B13O00114O00B13O000F3O0006A0006A00040001001C2O00B13O005F4O00B13O00474O00B13O000F4O00B13O00514O00B13O00194O00B13O00604O00B13O00074O00B13O00484O00B13O00524O00B13O00584O00B13O005E4O00B13O00464O00B13O00504O00B13O00534O00B13O00694O00B13O00414O00B13O004A4O00B13O00444O00B13O004D4O00B13O005D4O00B13O004E4O00B13O00454O00B13O00124O00B13O004F4O00B13O00424O00B13O004B4O00B13O00434O00B13O004C3O0006A0006B0005000100042O00B13O001D4O00B13O005D4O00B13O00624O00B13O00203O0006A0006C00060001000E2O00B13O005E4O00B13O00244O00B13O00674O00B13O00194O00B13O00074O00B13O00254O00B13O00104O00B13O00214O00B13O00364O00B13O00204O00B13O005C4O00B13O00644O00B13O002E4O00B13O00393O0006A0006D00070001001A2O00B13O005E4O00B13O00324O00B13O00664O00B13O000F4O00B13O00194O00B13O00104O00B13O001C4O00B13O00074O00B13O00274O00B13O00674O00B13O00294O00B13O00374O00B13O00204O00B13O005C4O00B13O00644O00B13O002C4O00B13O002A4O00B13O00264O00B13O00244O00B13O002B4O00B13O00234O00B13O001A4O00B13O00314O00B13O003B4O00B13O002F4O00B13O001F3O0006A0006E00080001001B2O00B13O005E4O00B13O00234O00B13O00194O00B13O00674O00B13O00074O00B13O002B4O00B13O00264O00B13O000F4O00B13O00244O00B13O00324O00B13O00104O00B13O001C4O00B13O00274O00B13O003B4O00B13O00204O00B13O00314O00B13O005C4O00B13O00644O00B13O00374O00B13O00294O00B13O00664O00B13O002C4O00B13O002F4O00B13O00394O00B13O002E4O00B13O002A4O00B13O001A3O0006A0006F00090001002A2O00B13O00574O00B13O001D4O00B13O005D4O00B13O005E4O00B13O00604O00B13O00334O00B13O00104O00B13O00684O00B13O00194O00B13O00074O00B13O001F4O00B13O00664O00B13O006E4O00B13O006D4O00B13O00154O00B13O005C4O00B13O00644O00B13O00354O00B13O00204O00B13O003D4O00B13O006B4O00B13O00344O00B13O003C4O00B13O00674O00B13O000F4O00B13O00174O00B13O002E4O00B13O00394O00B13O000B4O00B13O00554O00B13O002D4O00B13O00384O00B13O00564O00B13O00304O00B13O003A4O00B13O00214O00B13O00364O00B13O00284O00B13O00254O00B13O00544O00B13O00494O00B13O006A3O0006A00070000A000100092O00B13O000F4O00B13O005E4O00B13O00194O00B13O00074O00B13O00224O00B13O005D4O00B13O001E4O00B13O001D4O00B13O006C3O0006A00071000B0001001A2O00B13O00224O00B13O00074O00B13O00234O00B13O00244O00B13O00254O00B13O00374O00B13O00384O00B13O00394O00B13O003A4O00B13O002B4O00B13O002C4O00B13O002F4O00B13O00324O00B13O003B4O00B13O00334O00B13O00214O00B13O00294O00B13O002D4O00B13O002E4O00B13O00304O00B13O00314O00B13O00364O00B13O00264O00B13O00274O00B13O00284O00B13O002A3O0006A00072000C000100162O00B13O00414O00B13O00074O00B13O00424O00B13O00434O00B13O003E4O00B13O003F4O00B13O00404O00B13O00444O00B13O00454O00B13O00464O00B13O00544O00B13O00554O00B13O00564O00B13O004C4O00B13O004D4O00B13O004E4O00B13O004F4O00B13O00504O00B13O00534O00B13O00494O00B13O004A4O00B13O004B3O0006A00073000D0001000F2O00B13O00584O00B13O00074O00B13O00574O00B13O00474O00B13O00484O00B13O00514O00B13O00524O00B13O00354O00B13O00344O00B13O003D4O00B13O003C4O00B13O005C4O00B13O00594O00B13O005A4O00B13O005B3O0006A00074000E000100152O00B13O00724O00B13O00714O00B13O00734O00B13O001E4O00B13O00074O00B13O001F4O00B13O00204O00B13O000F4O00B13O005E4O00B13O001C4O00B13O00654O00B13O00664O00B13O00674O00B13O00104O00B13O005D4O00B13O00644O00B13O000B4O00B13O00634O00B13O001D4O00B13O006F4O00B13O00703O0006A00075000F000100022O00B13O00154O00B13O00073O0020D100760015002700122O007700286O007800746O007900756O0076007900016O00013O00103O00023O00026O00F03F026O00704002264O007800025O00122O000300016O00045O00122O000500013O00042O0003002100012O000600076O0055000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004FC0003000500012O0006000300054O00B1000400024O006B000300044O00E300036O003B3O00017O00023O00028O00024O0080B3C540000A3O0012B73O00013O0026593O00010001000100048F3O000100010012B7000100024O005D00015O0012B7000100024O005D000100013O00048F3O0009000100048F3O000100012O003B3O00017O00023O00028O0003133O00556E6974476574546F74616C4162736F72627300123O0012B73O00014O00A1000100013O0026593O00020001000100048F3O00020001001291000200024O000600036O00B40002000200022O00B1000100023O000E130001000D0001000100048F3O000D00012O0031000200014O0070000200023O00048F3O001100012O003100026O0070000200023O00048F3O0011000100048F3O000200012O003B3O00017O00053O00030E3O0056616C75654973496E412O726179030B3O00436173745370652O6C494403063O00457869737473030A3O00556E69744973556E697403023O00494400184O00BD7O00206O00014O000100016O000200023O00202O0002000200024O000200039O00000200064O001600013O00048F3O001600012O00063O00033O0020F35O00032O00B43O0002000200061C3O001600013O00048F3O001600010012913O00044O000F000100033O00202O0001000100054O0001000200024O000200043O00202O0002000200054O000200039O0000022O00703O00024O003B3O00017O00323O00028O00026O001040030B3O004865616C746873746F6E6503073O004973526561647903103O004865616C746850657263656E7461676503173O00EEC0CC31F2CDDE29E9CBC87DE2C0CB38E8D6C42BE3859E03043O005D86A5AD03193O008CF7C7D03FDDBA77B0F581EA3FCFBE77B0F581F235DABB71B003083O001EDE92A1A25AAED203173O0052656672657368696E674865616C696E67506F74696F6E03253O00F74B7618E05D7803EB493002E04F7C03EB49301AEA5A7905EB0E740FE34B7E19EC58754AB103043O006A852E10031C3O00447265616D77616C6B65722773204865616C696E6720506F74696F6E03193O00447265616D77616C6B6572734865616C696E67506F74696F6E03253O005C3276FD2O57592C78F94853182876FD5649562733EC5554512F7DBC5E455E257DEF53565D03063O00203840139C3A026O000840030F3O00446566656E736976655374616E6365030A3O0049734361737461626C6503083O0042752O66446F776E031A3O005ECDE35354E1894CCDDA454EF38E59CDA5525FF48554DBEC405F03073O00E03AA885363A92030F3O004265727365726B65725374616E636503313O005B5359EE70948C0E4B6958E97488840E19574DE97094C70F5C504EF3668F910E19455FFC7B85824B5D534DF87B958E1D5C03083O006B39362B9D15E6E7030F3O005370652O6C5265666C656374696F6E031A3O00C89B14F9B5E3DDDE8D1DF0BAC8C6D48551F1BCDACAD59818E3BC03073O00AFBBEB7195D9BC030E3O0042692O746572492O6D756E69747903193O003EA69558E66B4735A28C59ED706C25EF8549E57C762FA6974903073O00185CCFE12C8319026O00F03F027O0040030B3O0052612O6C79696E6743727903103O00417370656374734661766F7242752O66030A3O004973536F6C6F4D6F6465031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503163O0059D2B440027445D4874F09640BD7BD4A1E7358DAAE4903063O001D2BB3D82C7B03093O00496E74657276656E6503083O00556E69744E616D65030E3O00496E74657276656E65466F63757303133O00B4D73449AFCF2542B8992449BBDC2E5FB4CF2503043O002CDDB94003133O00456E7261676564526567656E65726174696F6E031E3O0004E95A5E7404E3774D7606E2465A6100F341507D41E34D59760FF441497603053O00136187283F030A3O0049676E6F72655061696E03153O00A75B3D343D34914C2O322171AA59353E2122A74A3603063O0051CE3C535B4F0065012O0012B73O00013O0026593O00580001000200048F3O005800012O000600015O0020720001000100030020F30001000100042O00B400010002000200061C0001001D00013O00048F3O001D00012O0006000100013O00061C0001001D00013O00048F3O001D00012O0006000100023O0020F30001000100052O00B40001000200022O0006000200033O0006AB0001001D0001000200048F3O001D00012O0006000100044O0006000200053O0020720002000200032O00B400010002000200061C0001001D00013O00048F3O001D00012O0006000100063O0012B7000200063O0012B7000300074O006B000100034O00E300016O0006000100073O00061C000100642O013O00048F3O00642O012O0006000100023O0020F30001000100052O00B40001000200022O0006000200083O0006AB000100642O01000200048F3O00642O010012B7000100013O002659000100270001000100048F3O002700012O0006000200094O005F000300063O00122O000400083O00122O000500096O00030005000200062O000200410001000300048F3O004100012O000600025O00207200020002000A0020F30002000200042O00B400020002000200061C0002004100013O00048F3O004100012O0006000200044O0006000300053O00207200030003000A2O00B400020002000200061C0002004100013O00048F3O004100012O0006000200063O0012B70003000B3O0012B70004000C4O006B000200044O00E300026O0006000200093O002659000200642O01000D00048F3O00642O012O000600025O00207200020002000E0020F30002000200042O00B400020002000200061C000200642O013O00048F3O00642O012O0006000200044O0006000300053O00207200030003000A2O00B400020002000200061C000200642O013O00048F3O00642O012O0006000200063O0012C40003000F3O00122O000400106O000200046O00025O00044O00642O0100048F3O0027000100048F3O00642O010026593O009F0001001100048F3O009F00012O00060001000A3O0020720001000100120020F30001000100132O00B400010002000200061C0001007C00013O00048F3O007C00012O00060001000B3O00061C0001007C00013O00048F3O007C00012O0006000100023O0020F30001000100052O00B40001000200022O00060002000C3O0006AB0001007C0001000200048F3O007C00012O0006000100023O0020C00001000100144O0003000A3O00202O0003000300124O000400016O00010004000200062O0001007C00013O00048F3O007C00012O0006000100044O00060002000A3O0020720002000200122O00B400010002000200061C0001007C00013O00048F3O007C00012O0006000100063O0012B7000200153O0012B7000300164O006B000100034O00E300016O00060001000A3O0020720001000100170020F30001000100132O00B400010002000200061C0001009E00013O00048F3O009E00012O00060001000B3O00061C0001009E00013O00048F3O009E00012O0006000100023O0020F30001000100052O00B40001000200022O00060002000D3O0006600002009E0001000100048F3O009E00012O0006000100023O0020C00001000100144O0003000A3O00202O0003000300174O000400016O00010004000200062O0001009E00013O00048F3O009E00012O0006000100044O00060002000A3O0020720002000200172O00B400010002000200061C0001009E00013O00048F3O009E00012O0006000100063O0012B7000200183O0012B7000300194O006B000100034O00E300015O0012B73O00023O0026593O00D10001000100048F3O00D100012O00060001000A3O00207200010001001A0020F30001000100042O00B400010002000200061C000100B600013O00048F3O00B600012O00060001000E4O008700010001000200061C000100B600013O00048F3O00B600012O0006000100044O00060002000A3O00207200020002001A2O00B400010002000200061C000100B600013O00048F3O00B600012O0006000100063O0012B70002001B3O0012B70003001C4O006B000100034O00E300016O00060001000A3O00207200010001001D0020F30001000100042O00B400010002000200061C000100D000013O00048F3O00D000012O00060001000F3O00061C000100D000013O00048F3O00D000012O0006000100023O0020F30001000100052O00B40001000200022O0006000200103O0006AB000100D00001000200048F3O00D000012O0006000100044O00060002000A3O00207200020002001D2O00B400010002000200061C000100D000013O00048F3O00D000012O0006000100063O0012B70002001E3O0012B70003001F4O006B000100034O00E300015O0012B73O00203O000E100021002A2O013O00048F3O002A2O012O00060001000A3O0020720001000100220020F30001000100132O00B400010002000200061C000100072O013O00048F3O00072O012O0006000100113O00061C000100072O013O00048F3O00072O012O0006000100023O00208C0001000100144O0003000A3O00202O0003000300234O00010003000200062O000100072O013O00048F3O00072O012O0006000100023O00208C0001000100144O0003000A3O00202O0003000300224O00010003000200062O000100072O013O00048F3O00072O012O0006000100023O0020F30001000100052O00B40001000200022O0006000200123O0006AB000100F50001000200048F3O00F500012O0006000100133O0020720001000100242O0087000100010002000683000100FC0001000100048F3O00FC00012O0006000100133O0020F60001000100254O000200126O000300146O00010003000200062O000100072O013O00048F3O00072O012O0006000100044O00060002000A3O0020720002000200222O00B400010002000200061C000100072O013O00048F3O00072O012O0006000100063O0012B7000200263O0012B7000300274O006B000100034O00E300016O00060001000A3O0020720001000100280020F30001000100132O00B400010002000200061C000100292O013O00048F3O00292O012O0006000100153O00061C000100292O013O00048F3O00292O012O0006000100163O0020F30001000100052O00B40001000200022O0006000200173O0006AB000100292O01000200048F3O00292O012O0006000100163O0020C60001000100294O0001000200024O000200023O00202O0002000200294O00020002000200062O000100292O01000200048F3O00292O012O0006000100044O0006000200053O00207200020002002A2O00B400010002000200061C000100292O013O00048F3O00292O012O0006000100063O0012B70002002B3O0012B70003002C4O006B000100034O00E300015O0012B73O00113O0026593O00010001002000048F3O000100012O00060001000A3O00207200010001002D0020F30001000100132O00B400010002000200061C000100462O013O00048F3O00462O012O0006000100183O00061C000100462O013O00048F3O00462O012O0006000100023O0020F30001000100052O00B40001000200022O0006000200193O0006AB000100462O01000200048F3O00462O012O0006000100044O00060002000A3O00207200020002002D2O00B400010002000200061C000100462O013O00048F3O00462O012O0006000100063O0012B70002002E3O0012B70003002F4O006B000100034O00E300016O00060001000A3O0020720001000100300020F30001000100132O00B400010002000200061C000100622O013O00048F3O00622O012O00060001001A3O00061C000100622O013O00048F3O00622O012O0006000100023O0020F30001000100052O00B40001000200022O00060002001B3O0006AB000100622O01000200048F3O00622O012O0006000100044O004A0002000A3O00202O0002000200304O000300046O000500016O00010005000200062O000100622O013O00048F3O00622O012O0006000100063O0012B7000200313O0012B7000300324O006B000100034O00E300015O0012B73O00213O00048F3O000100012O003B3O00017O00053O00028O0003103O0048616E646C65546F705472696E6B6574026O004440026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B657400233O0012B73O00013O0026593O00110001000100048F3O001100012O0006000100013O0020520001000100024O000200026O000300033O00122O000400036O000500056O0001000500024O00018O00015O00062O0001001000013O00048F3O001000012O000600016O0070000100023O0012B73O00043O0026593O00010001000400048F3O000100012O0006000100013O0020520001000100054O000200026O000300033O00122O000400036O000500056O0001000500024O00018O00015O00062O0001002200013O00048F3O002200012O000600016O0070000100023O00048F3O0022000100048F3O000100012O003B3O00017O00143O00028O00026O00F03F030B3O00426C2O6F64746869727374030A3O0049734361737461626C6503183O004CA7DF7D2BD745AD5CB8C4323FD148A741A6D2733B831CF403083O00C42ECBB0124FA32D03063O0043686172676503073O0049735265616479030E3O0049735370652O6C496E52616E676503133O00BB2A7F0C23FEAFA8307B1D2BF6EDB9363E4F7603073O008FD8421E7E449B03063O00417661746172030D3O00546974616E73546F726D656E74030B3O004973417661696C61626C6503123O00ABDE0CDFC4B197F1B8CD0EC4C8A1D6F5EA9E03083O0081CAA86DABA5C3B7030C3O005265636B6C652O736E652O73030F3O005265636B6C652O734162616E646F6E03183O00305D34D3D211F5315632CBCD54F6305D34D7D316E736186F03073O0086423857B8BE7400913O0012B73O00013O000E100002003A00013O00048F3O003A00012O000600015O0020720001000100030020F30001000100042O00B400010002000200061C0001001C00013O00048F3O001C00012O0006000100013O00061C0001001C00013O00048F3O001C00012O0006000100023O00061C0001001C00013O00048F3O001C00012O0006000100034O004800025O00202O0002000200034O000300026O000300036O00010003000200062O0001001C00013O00048F3O001C00012O0006000100043O0012B7000200053O0012B7000300064O006B000100034O00E300016O0006000100053O00061C0001009000013O00048F3O009000012O000600015O0020720001000100070020F30001000100082O00B400010002000200061C0001009000013O00048F3O009000012O0006000100023O000683000100900001000100048F3O009000012O0006000100034O00A400025O00202O0002000200074O000300063O00202O0003000300094O00055O00202O0005000500074O0003000500024O000300036O00010003000200062O0001009000013O00048F3O009000012O0006000100043O0012C40002000A3O00122O0003000B6O000100036O00015O00044O009000010026593O00010001000100048F3O000100012O0006000100073O00061C0001006500013O00048F3O006500012O0006000100083O00061C0001004500013O00048F3O004500012O0006000100093O000683000100480001000100048F3O004800012O0006000100083O000683000100650001000100048F3O006500012O00060001000A4O00060002000B3O000660000100650001000200048F3O006500012O000600015O00207200010001000C0020F30001000100042O00B400010002000200061C0001006500013O00048F3O006500012O000600015O00207200010001000D0020F300010001000E2O00B4000100020002000683000100650001000100048F3O006500012O0006000100034O004800025O00202O00020002000C4O000300026O000300036O00010003000200062O0001006500013O00048F3O006500012O0006000100043O0012B70002000F3O0012B7000300104O006B000100034O00E300016O00060001000C3O00061C0001008E00013O00048F3O008E00012O00060001000D3O00061C0001006E00013O00048F3O006E00012O0006000100093O000683000100710001000100048F3O007100012O00060001000D3O0006830001008E0001000100048F3O008E00012O00060001000A4O00060002000B3O0006600001008E0001000200048F3O008E00012O000600015O0020720001000100110020F30001000100042O00B400010002000200061C0001008E00013O00048F3O008E00012O000600015O0020720001000100120020F300010001000E2O00B40001000200020006830001008E0001000100048F3O008E00012O0006000100034O004800025O00202O0002000200114O000300026O000300036O00010003000200062O0001008E00013O00048F3O008E00012O0006000100043O0012B7000200133O0012B7000300144O006B000100034O00E300015O0012B73O00023O00048F3O000100012O003B3O00017O00793O00028O0003093O00576869726C77696E64030A3O0049734361737461626C65026O00F03F03103O00496D70726F7665645768696C77696E64030B3O004973417661696C61626C6503083O0042752O66446F776E030F3O004D656174436C656176657242752O66030E3O004973496E4D656C2O6552616E676503193O002B3900A915FC283B38711AB217EC2D30032508A91EEE35756E03083O00555C5169DB798B4103073O004578656375746503073O004973526561647903063O0042752O66557003133O00417368656E4A752O6765726E61757442752O66030B3O0042752O6652656D61696E732O033O0047434403173O00F8AB554669CBF8F3434C72D8F1B66F517DCDFAB644052803063O00BF9DD330251C03093O004F64796E7346757279030A3O00456E7261676542752O66030D3O0044616E63696E67426C6164657303113O0044616E63696E67426C6164657342752O66026O001440031A3O00D01BED1229E019E10E239F0CFD123DD31ACB083BCD18F1087A8903053O005ABF7F947C03073O0052616D70616765030F3O00416E6765724D616E6167656D656E7403103O005265636B6C652O736E652O7342752O66030E3O005261676550657263656E74616765025O0040554003173O006A86230779802B576B8E201074821103799529126CC77603043O007718E74E027O004003093O004F6E736C617567687403093O0054656E646572697A65031A3O008D23B646DD55168A39E559D54E168E289A5EDD52168739E51B8403073O0071E24DC52ABC20030C3O004372757368696E67426C6F77030C3O005772617468616E644675727903163O00467572696F7573426C2O6F6474686972737442752O66031E3O003904E1A6321FFAB20514F8BA2D56E7BC3411F8B00502F5A73D13E0F5684603043O00D55A7694030F3O0053752O64656E446561746842752O6603103O004865616C746850657263656E74616765025O0080414003083O004D612O7361637265026O00344003183O005E36B155584F2BF445445529B853724F2FA651484F6EE60403053O002D3B4ED436030F3O005265636B6C652O734162616E646F6E03183O0002578E9B8729A8B0035F8D8C8A2B92E41144848E926EFFA403083O00907036E3EBE64ECD026O000840026O00104003183O00A12902ECD15CB6681CF5DE5CBF2D30E8D149B42D1BBC830903063O003BD3486F9CB0030B3O00426C2O6F64746869727374030B3O00412O6E6968696C61746F72031C3O004C8BEC224A93EB245C94F76D5D8EED2A4282DC394F95E4285AC7B07903043O004D2EE783030A3O00526167696E67426C6F7703073O0043686172676573031C3O00A855B149B4538942B65BA100A95DB847B6518954BB46B145AE14E51603043O0020DA34D6031E3O004D0524BBF9B94B5D71153DA7E6F0565340103DADCEA44448491225E8A2E803083O003A2E7751C891D02503183O002E9435AFBCA9336B9F39A2AEB133149831BEAEB8226BDE6603073O00564BEC50CCC9DD03183O0060407A95FF8C7701648CF08C7E444891FF99754463C5ACD303063O00EB122117E59E03183O0055A2C4B845AEC4FB43B3CFBC5CBFFEAF51A8C6BE44FA93E203043O00DB30DAA103093O00426C2O6F6462617468031A3O00E67D7346DF4DE1F0793C5AD241E7E874435DDA5DE7E1653C1A8B03073O008084111C29BB2F030D3O00437269744368616E636550637403093O0042752O66537461636B03143O004D657263696C652O73412O7361756C7442752O66026O002440030E3O00426C2O6F646372617A6542752O66026O002E40025O00C0574003113O00436F6C6453742O656C486F74426C2O6F6403073O0048617354696572026O003E40031A3O00033E093559033312321D123B083D51040D123B4F0637127A0C5103053O003D6152665A031C3O00AE22A444C3431600BE3DBF0BD45E100EA02B945FC645190CB86EFA1903083O0069CC4ECB2BA7377E026O003F40031A3O00A7A62C111706C645ADEA30171D03CB549ABE220C1401D311F4FE03083O0031C5CA437E7364A7030E3O005468756E6465726F7573526F617203203O002353CA2784534C384ECC1692595F251BCC208E51523264CB2892515B231B8E7F03073O003E573BBF49E036026O00184003183O00F503F7D9E605FF89F40BF4CEEB07C5DDE610FDCCF342AE9E03043O00A987629A03043O00536C616D03153O00D87B2559BD20C1C5702851C227C9D9702140BD679003073O00A8AB1744349D53031A3O00F67DFAA2212F86E079B5BE2C2380F874CAB9243F80F165B5F87503073O00E7941195CD454D031C3O0092A6C0F259F8BFA5CBF440BF93AEC9FC5BFABFB3C6E950FA94E792A903063O009FE0C7A79B37026O001C40031E3O00F4E129C1FFFA32D5C8F130DDE0B32FDBF9F430D7C8E73DC0F0F62892A2A703043O00B297935C031C3O008EF1433D16587285EF5F26525F7382FA40372D587B9EFA492652192C03073O001AEC9D2C52722C031A3O003D26DC492639DC552E6EC6522429D95E153AD4492D2BC11B7F7603043O003B4A4EB5031A3O0027DD2O55B727D04E52F336D8545DBF20EE4E5BA122D44E1AE77503053O00D345B12O3A031E3O00B4F76CE6E1C2B9E246F7E5C4A0A56AFCE7CCBBE046E1E8D9B0E06DB5BD9903063O00ABD785199589031C3O00E3C43DF5EB24F44BF3DB26BAFC39F245EDCD0D2OEE22FB47F58866AE03083O002281A8529A8F509C031C3O0097B334024649B687BE3C1C085D808BB53F0E775A8897B5361F081ADF03073O00E9E5D2536B282E0094042O0012B73O00014O00A1000100013O0026593O00C70001000100048F3O00C700012O000600025O0020720002000200020020F30002000200032O00B400020002000200061C0002002D00013O00048F3O002D00012O0006000200013O00061C0002002D00013O00048F3O002D00012O0006000200023O000E130004002D0001000200048F3O002D00012O000600025O0020720002000200050020F30002000200062O00B400020002000200061C0002002D00013O00048F3O002D00012O0006000200033O00208C0002000200074O00045O00202O0004000400084O00020004000200062O0002002D00013O00048F3O002D00012O0006000200044O00C300035O00202O0003000300024O000400053O00202O0004000400094O000600066O0004000600024O000400046O00020004000200062O0002002D00013O00048F3O002D00012O0006000200073O0012B70003000A3O0012B70004000B4O006B000200044O00E300026O000600025O00207200020002000C0020F300020002000D2O00B400020002000200061C0002005400013O00048F3O005400012O0006000200083O00061C0002005400013O00048F3O005400012O0006000200033O00208C00020002000E4O00045O00202O00040004000F4O00020004000200062O0002005400013O00048F3O005400012O0006000200033O0020DE0002000200104O00045O00202O00040004000F4O0002000400024O000300033O00202O0003000300114O00030002000200062O000200540001000300048F3O005400012O0006000200044O004800035O00202O00030003000C4O000400096O000400046O00020004000200062O0002005400013O00048F3O005400012O0006000200073O0012B7000300123O0012B7000400134O006B000200044O00E300026O00060002000A3O00061C0002009400013O00048F3O009400012O00060002000B3O00061C0002005D00013O00048F3O005D00012O00060002000C3O000683000200600001000100048F3O006000012O00060002000B3O000683000200940001000100048F3O009400012O000600025O0020720002000200140020F30002000200032O00B400020002000200061C0002009400013O00048F3O009400012O00060002000D4O00060003000E3O000660000200940001000300048F3O009400012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O0002009400013O00048F3O009400012O000600025O0020720002000200160020F30002000200062O00B400020002000200061C0002007E00013O00048F3O007E00012O0006000200033O0020D50002000200104O00045O00202O0004000400174O00020004000200262O000200840001001800048F3O008400012O000600025O0020720002000200160020F30002000200062O00B4000200020002000683000200940001000100048F3O009400012O0006000200044O00C300035O00202O0003000300144O000400053O00202O0004000400094O000600066O0004000600024O000400046O00020004000200062O0002009400013O00048F3O009400012O0006000200073O0012B7000300193O0012B70004001A4O006B000200044O00E300026O000600025O00207200020002001B0020F300020002000D2O00B400020002000200061C000200C600013O00048F3O00C600012O00060002000F3O00061C000200C600013O00048F3O00C600012O000600025O00207200020002001C0020F30002000200062O00B400020002000200061C000200C600013O00048F3O00C600012O0006000200033O00203A00020002000E4O00045O00202O00040004001D4O00020004000200062O000200B90001000100048F3O00B900012O0006000200033O0020340002000200104O00045O00202O0004000400154O0002000400024O000300033O00202O0003000300114O00030002000200062O000200B90001000300048F3O00B900012O0006000200033O0020F300020002001E2O00B4000200020002000E13001F00C60001000200048F3O00C600012O0006000200044O004800035O00202O00030003001B4O000400096O000400046O00020004000200062O000200C600013O00048F3O00C600012O0006000200073O0012B7000300203O0012B7000400214O006B000200044O00E300025O0012B73O00043O0026593O008E2O01002200048F3O008E2O012O000600025O0020720002000200230020F300020002000D2O00B400020002000200061C000200EC00013O00048F3O00EC00012O0006000200103O00061C000200EC00013O00048F3O00EC00012O0006000200033O00203A00020002000E4O00045O00202O0004000400154O00020004000200062O000200DF0001000100048F3O00DF00012O000600025O0020720002000200240020F30002000200062O00B400020002000200061C000200EC00013O00048F3O00EC00012O0006000200044O004800035O00202O0003000300234O000400096O000400046O00020004000200062O000200EC00013O00048F3O00EC00012O0006000200073O0012B7000300253O0012B7000400264O006B000200044O00E300026O000600025O0020720002000200270020F30002000200032O00B400020002000200061C000200162O013O00048F3O00162O012O0006000200113O00061C000200162O013O00048F3O00162O012O000600025O0020720002000200280020F30002000200062O00B400020002000200061C000200162O013O00048F3O00162O012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O000200162O013O00048F3O00162O012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O000200162O013O00048F3O00162O012O0006000200044O004800035O00202O0003000300274O000400096O000400046O00020004000200062O000200162O013O00048F3O00162O012O0006000200073O0012B70003002A3O0012B70004002B4O006B000200044O00E300026O000600025O00207200020002000C0020F300020002000D2O00B400020002000200061C0002005B2O013O00048F3O005B2O012O0006000200083O00061C0002005B2O013O00048F3O005B2O012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O000200342O013O00048F3O00342O012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O000200342O013O00048F3O00342O012O0006000200033O00203A00020002000E4O00045O00202O00040004000F4O00020004000200062O0002004E2O01000100048F3O004E2O012O0006000200033O0020ED0002000200104O00045O00202O00040004002C4O0002000400024O000300033O00202O0003000300114O00030002000200062O0002005B2O01000300048F3O005B2O012O0006000200053O0020F300020002002D2O00B4000200020002000E13002E00492O01000200048F3O00492O012O000600025O00207200020002002F0020F30002000200062O00B40002000200020006830002004E2O01000100048F3O004E2O012O0006000200053O0020F300020002002D2O00B4000200020002000E130030005B2O01000200048F3O005B2O012O0006000200044O004800035O00202O00030003000C4O000400096O000400046O00020004000200062O0002005B2O013O00048F3O005B2O012O0006000200073O0012B7000300313O0012B7000400324O006B000200044O00E300026O000600025O00207200020002001B0020F300020002000D2O00B400020002000200061C0002008D2O013O00048F3O008D2O012O00060002000F3O00061C0002008D2O013O00048F3O008D2O012O000600025O0020720002000200330020F30002000200062O00B400020002000200061C0002008D2O013O00048F3O008D2O012O0006000200033O00203A00020002000E4O00045O00202O00040004001D4O00020004000200062O000200802O01000100048F3O00802O012O0006000200033O0020340002000200104O00045O00202O0004000400154O0002000400024O000300033O00202O0003000300114O00030002000200062O000200802O01000300048F3O00802O012O0006000200033O0020F300020002001E2O00B4000200020002000E13001F008D2O01000200048F3O008D2O012O0006000200044O004800035O00202O00030003001B4O000400096O000400046O00020004000200062O0002008D2O013O00048F3O008D2O012O0006000200073O0012B7000300343O0012B7000400354O006B000200044O00E300025O0012B73O00363O0026593O002E0201003700048F3O002E02012O000600025O00207200020002001B0020F300020002000D2O00B400020002000200061C000200B12O013O00048F3O00B12O012O00060002000F3O00061C000200B12O013O00048F3O00B12O012O0006000200053O0020F300020002002D2O00B400020002000200262F000200B12O01002E00048F3O00B12O012O000600025O00207200020002002F0020F30002000200062O00B400020002000200061C000200B12O013O00048F3O00B12O012O0006000200044O004800035O00202O00030003001B4O000400096O000400046O00020004000200062O000200B12O013O00048F3O00B12O012O0006000200073O0012B7000300383O0012B7000400394O006B000200044O00E300026O000600025O00207200020002003A0020F30002000200032O00B400020002000200061C000200E22O013O00048F3O00E22O012O0006000200123O00061C000200E22O013O00048F3O00E22O012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O000200CE2O013O00048F3O00CE2O012O000600025O00207200020002003B0020F30002000200062O00B400020002000200061C000200E22O013O00048F3O00E22O012O0006000200033O00208C0002000200074O00045O00202O00040004001D4O00020004000200062O000200E22O013O00048F3O00E22O012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O000200E22O013O00048F3O00E22O012O0006000200044O004800035O00202O00030003003A4O000400096O000400046O00020004000200062O000200E22O013O00048F3O00E22O012O0006000200073O0012B70003003C3O0012B70004003D4O006B000200044O00E300026O000600025O00207200020002003E0020F30002000200032O00B400020002000200061C0002000402013O00048F3O000402012O0006000200133O00061C0002000402013O00048F3O000402012O000600025O00207200020002003E0020F300020002003F2O00B4000200020002000E13000400040201000200048F3O000402012O000600025O0020720002000200280020F30002000200062O00B400020002000200061C0002000402013O00048F3O000402012O0006000200044O004800035O00202O00030003003E4O000400096O000400046O00020004000200062O0002000402013O00048F3O000402012O0006000200073O0012B7000300403O0012B7000400414O006B000200044O00E300026O000600025O0020720002000200270020F30002000200032O00B400020002000200061C0002002D02013O00048F3O002D02012O0006000200113O00061C0002002D02013O00048F3O002D02012O000600025O0020720002000200270020F300020002003F2O00B4000200020002000E130004002D0201000200048F3O002D02012O000600025O0020720002000200280020F30002000200062O00B400020002000200061C0002002D02013O00048F3O002D02012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O0002002D02013O00048F3O002D02012O0006000200044O004800035O00202O0003000300274O000400096O000400046O00020004000200062O0002002D02013O00048F3O002D02012O0006000200073O0012B7000300423O0012B7000400434O006B000200044O00E300025O0012B73O00183O000E10003600A902013O00048F3O00A902012O000600025O00207200020002000C0020F300020002000D2O00B400020002000200061C0002004D02013O00048F3O004D02012O0006000200083O00061C0002004D02013O00048F3O004D02012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O0002004D02013O00048F3O004D02012O0006000200044O004800035O00202O00030003000C4O000400096O000400046O00020004000200062O0002004D02013O00048F3O004D02012O0006000200073O0012B7000300443O0012B7000400454O006B000200044O00E300026O000600025O00207200020002001B0020F300020002000D2O00B400020002000200061C0002006902013O00048F3O006902012O00060002000F3O00061C0002006902013O00048F3O006902012O000600025O00207200020002001C0020F30002000200062O00B400020002000200061C0002006902013O00048F3O006902012O0006000200044O004800035O00202O00030003001B4O000400096O000400046O00020004000200062O0002006902013O00048F3O006902012O0006000200073O0012B7000300463O0012B7000400474O006B000200044O00E300026O000600025O00207200020002000C0020F300020002000D2O00B400020002000200061C0002007F02013O00048F3O007F02012O0006000200083O00061C0002007F02013O00048F3O007F02012O0006000200044O004800035O00202O00030003000C4O000400096O000400046O00020004000200062O0002007F02013O00048F3O007F02012O0006000200073O0012B7000300483O0012B7000400494O006B000200044O00E300026O000600025O00207200020002004A0020F30002000200032O00B400020002000200061C000200A802013O00048F3O00A802012O0006000200143O00061C000200A802013O00048F3O00A802012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O000200A802013O00048F3O00A802012O000600025O0020720002000200330020F30002000200062O00B400020002000200061C000200A802013O00048F3O00A802012O000600025O0020720002000200280020F30002000200062O00B4000200020002000683000200A80201000100048F3O00A802012O0006000200044O004800035O00202O00030003004A4O000400096O000400046O00020004000200062O000200A802013O00048F3O00A802012O0006000200073O0012B70003004B3O0012B70004004C4O006B000200044O00E300025O0012B73O00373O0026593O00500301000400048F3O005003012O0006000200033O00206500020002004D4O0002000200024O000300156O000400033O00202O00040004000E4O00065O00202O00060006001D4O000400066O00033O000200202O0003000300304O0002000200034O000300033O00202O00030003004E4O00055O00202O00050005004F4O00030005000200202O0003000300504O0002000200034O000300033O00202O00030003004E4O00055O00202O0005000500514O00030005000200202O0003000300524O000100020003000E2O005300D40201000100048F3O00D402012O000600025O0020720002000200540020F30002000200062O00B4000200020002000683000200050301000100048F3O000503012O0006000200033O0020CF00020002005500122O000400563O00122O000500376O00020005000200062O0002000503013O00048F3O000503010012B7000200013O002659000200D50201000100048F3O00D502012O000600035O00207200030003004A0020F30003000300032O00B400030002000200061C000300ED02013O00048F3O00ED02012O0006000300143O00061C000300ED02013O00048F3O00ED02012O0006000300044O004800045O00202O00040004004A4O000500096O000500056O00030005000200062O000300ED02013O00048F3O00ED02012O0006000300073O0012B7000400573O0012B7000500584O006B000300054O00E300036O000600035O00207200030003003A0020F30003000300032O00B400030002000200061C0003000503013O00048F3O000503012O0006000300123O00061C0003000503013O00048F3O000503012O0006000300044O004800045O00202O00040004003A4O000500096O000500056O00030005000200062O0003000503013O00048F3O000503012O0006000300073O0012C4000400593O00122O0005005A6O000300056O00035O00044O0005030100048F3O00D502012O000600025O00207200020002004A0020F30002000200032O00B400020002000200061C0002002203013O00048F3O002203012O0006000200143O00061C0002002203013O00048F3O002203012O0006000200033O0020CF00020002005500122O0004005B3O00122O000500226O00020005000200062O0002002203013O00048F3O002203012O0006000200044O004800035O00202O00030003004A4O000400096O000400046O00020004000200062O0002002203013O00048F3O002203012O0006000200073O0012B70003005C3O0012B70004005D4O006B000200044O00E300026O0006000200163O00061C0002004F03013O00048F3O004F03012O0006000200173O00061C0002002B03013O00048F3O002B03012O00060002000C3O0006830002002E0301000100048F3O002E03012O0006000200173O0006830002004F0301000100048F3O004F03012O00060002000D4O00060003000E3O0006600002004F0301000300048F3O004F03012O000600025O00207200020002005E0020F30002000200032O00B400020002000200061C0002004F03013O00048F3O004F03012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O0002004F03013O00048F3O004F03012O0006000200044O00C300035O00202O00030003005E4O000400053O00202O0004000400094O000600066O0004000600024O000400046O00020004000200062O0002004F03013O00048F3O004F03012O0006000200073O0012B70003005F3O0012B7000400604O006B000200044O00E300025O0012B73O00223O0026593O00B10301006100048F3O00B103012O000600025O00207200020002001B0020F300020002000D2O00B400020002000200061C0002006803013O00048F3O006803012O00060002000F3O00061C0002006803013O00048F3O006803012O0006000200044O004800035O00202O00030003001B4O000400096O000400046O00020004000200062O0002006803013O00048F3O006803012O0006000200073O0012B7000300623O0012B7000400634O006B000200044O00E300026O000600025O0020720002000200640020F300020002000D2O00B400020002000200061C0002008403013O00048F3O008403012O0006000200183O00061C0002008403013O00048F3O008403012O000600025O00207200020002003B0020F30002000200062O00B400020002000200061C0002008403013O00048F3O008403012O0006000200044O004800035O00202O0003000300644O000400096O000400046O00020004000200062O0002008403013O00048F3O008403012O0006000200073O0012B7000300653O0012B7000400664O006B000200044O00E300026O000600025O00207200020002004A0020F30002000200032O00B400020002000200061C0002009A03013O00048F3O009A03012O0006000200143O00061C0002009A03013O00048F3O009A03012O0006000200044O004800035O00202O00030003004A4O000400096O000400046O00020004000200062O0002009A03013O00048F3O009A03012O0006000200073O0012B7000300673O0012B7000400684O006B000200044O00E300026O000600025O00207200020002003E0020F30002000200032O00B400020002000200061C000200B003013O00048F3O00B003012O0006000200133O00061C000200B003013O00048F3O00B003012O0006000200044O004800035O00202O00030003003E4O000400096O000400046O00020004000200062O000200B003013O00048F3O00B003012O0006000200073O0012B7000300693O0012B70004006A4O006B000200044O00E300025O0012B73O006B3O0026593O00030401006B00048F3O000304012O000600025O0020720002000200270020F30002000200032O00B400020002000200061C000200D003013O00048F3O00D003012O0006000200113O00061C000200D003013O00048F3O00D003012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O000200D003013O00048F3O00D003012O0006000200044O004800035O00202O0003000300274O000400096O000400046O00020004000200062O000200D003013O00048F3O00D003012O0006000200073O0012B70003006C3O0012B70004006D4O006B000200044O00E300026O000600025O00207200020002003A0020F30002000200032O00B400020002000200061C000200E603013O00048F3O00E603012O0006000200123O00061C000200E603013O00048F3O00E603012O0006000200044O004800035O00202O00030003003A4O000400096O000400046O00020004000200062O000200E603013O00048F3O00E603012O0006000200073O0012B70003006E3O0012B70004006F4O006B000200044O00E300026O0006000200193O00061C0002009304013O00048F3O009304012O000600025O0020720002000200020020F30002000200032O00B400020002000200061C0002009304013O00048F3O009304012O0006000200013O00061C0002009304013O00048F3O009304012O0006000200044O00C300035O00202O0003000300024O000400053O00202O0004000400094O000600066O0004000600024O000400046O00020004000200062O0002009304013O00048F3O009304012O0006000200073O0012C4000300703O00122O000400716O000200046O00025O00044O009304010026593O00020001001800048F3O000200012O000600025O00207200020002004A0020F30002000200032O00B400020002000200061C0002002804013O00048F3O002804012O0006000200143O00061C0002002804013O00048F3O002804012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O0002001B04013O00048F3O001B04012O000600025O0020720002000200280020F30002000200062O00B4000200020002000683000200280401000100048F3O002804012O0006000200044O004800035O00202O00030003004A4O000400096O000400046O00020004000200062O0002002804013O00048F3O002804012O0006000200073O0012B7000300723O0012B7000400734O006B000200044O00E300026O000600025O0020720002000200270020F30002000200032O00B400020002000200061C0002005204013O00048F3O005204012O0006000200113O00061C0002005204013O00048F3O005204012O0006000200033O00208C00020002000E4O00045O00202O0004000400154O00020004000200062O0002005204013O00048F3O005204012O000600025O0020720002000200330020F30002000200062O00B400020002000200061C0002005204013O00048F3O005204012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O0002005204013O00048F3O005204012O0006000200044O004800035O00202O0003000300274O000400096O000400046O00020004000200062O0002005204013O00048F3O005204012O0006000200073O0012B7000300743O0012B7000400754O006B000200044O00E300026O000600025O00207200020002003A0020F30002000200032O00B400020002000200061C0002007504013O00048F3O007504012O0006000200123O00061C0002007504013O00048F3O007504012O000600025O0020720002000200280020F30002000200062O00B4000200020002000683000200750401000100048F3O007504012O0006000200033O00208C0002000200074O00045O00202O0004000400294O00020004000200062O0002007504013O00048F3O007504012O0006000200044O004800035O00202O00030003003A4O000400096O000400046O00020004000200062O0002007504013O00048F3O007504012O0006000200073O0012B7000300763O0012B7000400774O006B000200044O00E300026O000600025O00207200020002003E0020F30002000200032O00B400020002000200061C0002009104013O00048F3O009104012O0006000200133O00061C0002009104013O00048F3O009104012O000600025O00207200020002003E0020F300020002003F2O00B4000200020002000E13000400910401000200048F3O009104012O0006000200044O004800035O00202O00030003003E4O000400096O000400046O00020004000200062O0002009104013O00048F3O009104012O0006000200073O0012B7000300783O0012B7000400794O006B000200044O00E300025O0012B73O00613O00048F3O000200012O003B3O00017O00713O00028O00026O00204003093O00426C2O6F6462617468030A3O0049734361737461626C6503193O00C34E3DD901C34326DE45CC573EC20CFE5633C402C45672825303053O0065A12252B6030A3O00526167696E67426C6F77031B3O00FA0C5EF7D5E5BD2CE4024EBED6F78E3AE1324DFFC9E5873AA8590103083O004E886D399EBB82E2030C3O004372757368696E67426C6F77031D3O003D2DECE22O36F7F6013DF5FE297FF4E4322BF0CE2A3EEBF63B2BB9A46E03043O00915E5F99026O002240026O00184003063O0042752O665570030A3O00456E7261676542752O66030C3O005772617468616E6446757279030B3O004973417661696C61626C6503193O00FFC11BDA4AB5FCD91C9543A2F1D91DEA5AB6EFCA11C10EE4A903063O00D79DAD74B52E030F3O005265636B6C652O734162616E646F6E031D3O0036A69EE1D23CBA8CCDD839BB9CB2D720B89FFBE521B599F5DF21F4D8A403053O00BA55D4EB92030B3O00426C2O6F64746869727374031B3O00C08D19F13DFA50CB9305EA79E34DCE951FC12DEF4AC58402BE6AB603073O0038A2E1769E598E026O001C4003093O00576869726C77696E64030E3O004973496E4D656C2O6552616E676503193O004B0DC9BD2ECF550BC4EF2FCD5011C99036D94E02C5BB628D0E03063O00B83C65A0CF42026O00F03F03073O004578656375746503073O004973526561647903133O00417368656E4A752O6765726E61757442752O66030B3O0042752O6652656D61696E732O033O0047434403163O00349A79BF249679FC3C9770A838BD68BD238579A871DA03043O00DC51E21C030E3O005468756E6465726F7573526F6172031F3O0007DD97F5EEC201DA97E82OD51CD490BBE7D21FC18BC4FEC601D287EFAA964303063O00A773B5E29B8A03093O004F64796E7346757279031A3O00ED26FE52684EC0F730FE1C7664CAF62BD8487A63C1E736A70D2903073O00A68242873C1B11027O004003073O0043686172676573031B3O00564BC97C3E4375CC793F530AC3603C5043F16131564DCB6170101A03053O0050242AAE1503073O0052616D7061676503173O005C113A6A4F17323A43053B6E472F237B5C17326E0E446503043O001A2E705703043O00536C616D030B3O00412O6E6968696C61746F7203143O00AA2FAA79FFB250B8AD2A9460BEAD42B1AD63FF2003083O00D4D943CB142ODF25030C3O005265636B6C652O736E652O73026O002840031B3O00A888ABD9B688BBC1B488BBC1FA80BDDEAE8497C6BB9FAFD7AECDFA03043O00B2DAEDC8030B3O00546974616E69635261676503083O0042752O66446F776E030F3O004D656174436C656176657242752O66030A3O0041766174617242752O6603103O005265636B6C652O736E652O7342752O6603193O00B9B1FFDEA58AE0C5A4ACA6DDA3B9F2D989A1E7C2B1B0F290E203043O00B0D6D58603103O00496D70726F7665645768696C77696E6403183O00E3A5BFC6A44150FAA9F6D9BD5A4DFD92A2D5BA515CE0EDE003073O003994CDD6B4C836026O00144003093O004F6E736C617567687403093O0054656E646572697A6503193O001DF326387707FA3D20361FE839207F2DE934267117E975662E03053O0016729D5554031B3O00D6CA14CD53F197C6C71CD31DFBBDC8DF1AFB49F7BAC3CE07840EA603073O00C8A4AB73A43D96031D3O00BDE616568BB7FA047A81B2FB14058EABF8174CBCAAF5114286AAB4501703053O00E3DE946325026O00104003173O00364A57F5EC275712FBEC3F465BC9ED324055F3ED732O0003053O0099532O329603193O005F7A7C1377A94C497E331166A7595449671D61AC484936214803073O002D3D16137C13CB031B3O00C31E02FA0664B1C8001EE1427DACCD0604CA1671ABC61719B5502603073O00D9A1726D956210030D3O00437269744368616E6365506374026O00344003093O0042752O66537461636B03143O004D657263696C652O73412O7361756C7442752O66026O002440030E3O00426C2O6F646372617A6542752O66026O002E40025O00C0574003073O0048617354696572026O003E4003193O00102C3773B8761334303CB1611E343143A87500273D68FC254603063O00147240581CDC031B3O00330DDDBBFCC4B53813C1A0B8DDA83D15DB8BECD1AF3604C6F4A98603073O00DD5161B2D498B0031D3O00CEF508E812C4E91AC418C1E80ABB17D8EB09F225D9E60FFC1FD9A74CAF03053O007AAD877D9B026O00084003173O0081D905BA2A25CDC4CC15B52B38F790C012BE3A2588D59703073O00A8E4A160D95F51031A3O00D4D537523C68DDC43C456F5ACEDD3A551043DAC329593B178A8903063O0037BBB14E3C4F03043O0052616765025O00805B4003103O004F7665727768656C6D696E6752616765026O00544003173O003FCF52FB47C8856DC34AE752C6BF39CF4DEC43DBC07F9E03073O00E04DAE3F8B26AF001B042O0012B73O00014O00A1000100013O0026593O00470001000200048F3O004700012O000600025O0020720002000200030020F30002000200042O00B400020002000200061C0002001A00013O00048F3O001A00012O0006000200013O00061C0002001A00013O00048F3O001A00012O0006000200024O004800035O00202O0003000300034O000400036O000400046O00020004000200062O0002001A00013O00048F3O001A00012O0006000200043O0012B7000300053O0012B7000400064O006B000200044O00E300026O000600025O0020720002000200070020F30002000200042O00B400020002000200061C0002003000013O00048F3O003000012O0006000200053O00061C0002003000013O00048F3O003000012O0006000200024O004800035O00202O0003000300074O000400036O000400046O00020004000200062O0002003000013O00048F3O003000012O0006000200043O0012B7000300083O0012B7000400094O006B000200044O00E300026O000600025O00207200020002000A0020F30002000200042O00B400020002000200061C0002004600013O00048F3O004600012O0006000200063O00061C0002004600013O00048F3O004600012O0006000200024O004800035O00202O00030003000A4O000400036O000400046O00020004000200062O0002004600013O00048F3O004600012O0006000200043O0012B70003000B3O0012B70004000C4O006B000200044O00E300025O0012B73O000D3O0026593O00AC0001000E00048F3O00AC00012O000600025O0020720002000200030020F30002000200042O00B400020002000200061C0002006C00013O00048F3O006C00012O0006000200013O00061C0002006C00013O00048F3O006C00012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002005F00013O00048F3O005F00012O000600025O0020720002000200110020F30002000200122O00B40002000200020006830002006C0001000100048F3O006C00012O0006000200024O004800035O00202O0003000300034O000400036O000400046O00020004000200062O0002006C00013O00048F3O006C00012O0006000200043O0012B7000300133O0012B7000400144O006B000200044O00E300026O000600025O00207200020002000A0020F30002000200042O00B400020002000200061C0002008F00013O00048F3O008F00012O0006000200063O00061C0002008F00013O00048F3O008F00012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002008F00013O00048F3O008F00012O000600025O0020720002000200150020F30002000200122O00B400020002000200061C0002008F00013O00048F3O008F00012O0006000200024O004800035O00202O00030003000A4O000400036O000400046O00020004000200062O0002008F00013O00048F3O008F00012O0006000200043O0012B7000300163O0012B7000400174O006B000200044O00E300026O000600025O0020720002000200180020F30002000200042O00B400020002000200061C000200AB00013O00048F3O00AB00012O0006000200083O00061C000200AB00013O00048F3O00AB00012O000600025O0020720002000200110020F30002000200122O00B4000200020002000683000200AB0001000100048F3O00AB00012O0006000200024O004800035O00202O0003000300184O000400036O000400046O00020004000200062O000200AB00013O00048F3O00AB00012O0006000200043O0012B7000300193O0012B70004001A4O006B000200044O00E300025O0012B73O001B3O0026593O00C80001000D00048F3O00C800012O000600025O00207200020002001C0020F30002000200042O00B400020002000200061C0002001A04013O00048F3O001A04012O0006000200093O00061C0002001A04013O00048F3O001A04012O0006000200024O00C300035O00202O00030003001C4O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O0002001A04013O00048F3O001A04012O0006000200043O0012C40003001E3O00122O0004001F6O000200046O00025O00044O001A04010026593O004F2O01002000048F3O004F2O012O000600025O0020720002000200210020F30002000200222O00B400020002000200061C000200F100013O00048F3O00F100012O00060002000C3O00061C000200F100013O00048F3O00F100012O0006000200073O00208C00020002000F4O00045O00202O0004000400234O00020004000200062O000200F100013O00048F3O00F100012O0006000200073O0020DE0002000200244O00045O00202O0004000400234O0002000400024O000300073O00202O0003000300254O00030002000200062O000200F10001000300048F3O00F100012O0006000200024O004800035O00202O0003000300214O000400036O000400046O00020004000200062O000200F100013O00048F3O00F100012O0006000200043O0012B7000300263O0012B7000400274O006B000200044O00E300026O000600025O0020720002000200280020F30002000200042O00B400020002000200061C0002001E2O013O00048F3O001E2O012O00060002000D3O00061C000200FD00013O00048F3O00FD00012O00060002000E3O00068300022O002O01000100048F4O002O012O00060002000D3O0006830002001E2O01000100048F3O001E2O012O00060002000F3O00061C0002001E2O013O00048F3O001E2O012O0006000200104O0006000300113O0006600002001E2O01000300048F3O001E2O012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002001E2O013O00048F3O001E2O012O0006000200024O00C300035O00202O0003000300284O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O0002001E2O013O00048F3O001E2O012O0006000200043O0012B7000300293O0012B70004002A4O006B000200044O00E300026O000600025O00207200020002002B0020F30002000200042O00B400020002000200061C0002004E2O013O00048F3O004E2O012O0006000200123O00061C0002002A2O013O00048F3O002A2O012O00060002000E3O0006830002002D2O01000100048F3O002D2O012O0006000200123O0006830002004E2O01000100048F3O004E2O012O0006000200133O00061C0002004E2O013O00048F3O004E2O012O0006000200104O0006000300113O0006600002004E2O01000300048F3O004E2O012O0006000200143O000E130020004E2O01000200048F3O004E2O012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002004E2O013O00048F3O004E2O012O0006000200024O00C300035O00202O00030003002B4O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O0002004E2O013O00048F3O004E2O012O0006000200043O0012B70003002C3O0012B70004002D4O006B000200044O00E300025O0012B73O002E3O0026593O00A02O01001B00048F3O00A02O012O000600025O0020720002000200070020F30002000200042O00B400020002000200061C0002006D2O013O00048F3O006D2O012O0006000200053O00061C0002006D2O013O00048F3O006D2O012O000600025O0020720002000200070020F300020002002F2O00B4000200020002000E130020006D2O01000200048F3O006D2O012O0006000200024O004800035O00202O0003000300074O000400036O000400046O00020004000200062O0002006D2O013O00048F3O006D2O012O0006000200043O0012B7000300303O0012B7000400314O006B000200044O00E300026O000600025O0020720002000200320020F30002000200222O00B400020002000200061C000200832O013O00048F3O00832O012O0006000200153O00061C000200832O013O00048F3O00832O012O0006000200024O004800035O00202O0003000300324O000400036O000400046O00020004000200062O000200832O013O00048F3O00832O012O0006000200043O0012B7000300333O0012B7000400344O006B000200044O00E300026O000600025O0020720002000200350020F30002000200222O00B400020002000200061C0002009F2O013O00048F3O009F2O012O0006000200163O00061C0002009F2O013O00048F3O009F2O012O000600025O0020720002000200360020F30002000200122O00B400020002000200061C0002009F2O013O00048F3O009F2O012O0006000200024O004800035O00202O0003000300354O000400036O000400046O00020004000200062O0002009F2O013O00048F3O009F2O012O0006000200043O0012B7000300373O0012B7000400384O006B000200044O00E300025O0012B73O00023O0026593O00390201000100048F3O003902012O000600025O0020720002000200390020F30002000200042O00B400020002000200061C000200CB2O013O00048F3O00CB2O012O0006000200173O00061C000200AE2O013O00048F3O00AE2O012O00060002000E3O000683000200B12O01000100048F3O00B12O012O0006000200173O000683000200CB2O01000100048F3O00CB2O012O0006000200183O00061C000200CB2O013O00048F3O00CB2O012O0006000200104O0006000300113O000660000200CB2O01000300048F3O00CB2O012O0006000200143O000EEF002000BE2O01000200048F3O00BE2O012O0006000200113O00262F000200CB2O01003A00048F3O00CB2O012O0006000200024O004800035O00202O0003000300394O000400036O000400046O00020004000200062O000200CB2O013O00048F3O00CB2O012O0006000200043O0012B70003003B3O0012B70004003C4O006B000200044O00E300026O000600025O00207200020002002B0020F30002000200042O00B400020002000200061C0002000F02013O00048F3O000F02012O0006000200123O00061C000200D72O013O00048F3O00D72O012O00060002000E3O000683000200DA2O01000100048F3O00DA2O012O0006000200123O0006830002000F0201000100048F3O000F02012O0006000200133O00061C0002000F02013O00048F3O000F02012O0006000200104O0006000300113O0006600002000F0201000300048F3O000F02012O0006000200143O000E130020000F0201000200048F3O000F02012O000600025O00207200020002003D0020F30002000200122O00B400020002000200061C0002000F02013O00048F3O000F02012O0006000200073O00203A00020002003E4O00045O00202O00040004003F4O00020004000200062O000200FF2O01000100048F3O00FF2O012O0006000200073O00203A00020002000F4O00045O00202O0004000400404O00020004000200062O000200FF2O01000100048F3O00FF2O012O0006000200073O00208C00020002000F4O00045O00202O0004000400414O00020004000200062O0002000F02013O00048F3O000F02012O0006000200024O00C300035O00202O00030003002B4O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O0002000F02013O00048F3O000F02012O0006000200043O0012B7000300423O0012B7000400434O006B000200044O00E300026O000600025O00207200020002001C0020F30002000200042O00B400020002000200061C0002003802013O00048F3O003802012O0006000200093O00061C0002003802013O00048F3O003802012O0006000200143O000E13002000380201000200048F3O003802012O000600025O0020720002000200440020F30002000200122O00B400020002000200061C0002003802013O00048F3O003802012O0006000200073O00208C00020002003E4O00045O00202O00040004003F4O00020004000200062O0002003802013O00048F3O003802012O0006000200024O00C300035O00202O00030003001C4O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O0002003802013O00048F3O003802012O0006000200043O0012B7000300453O0012B7000400464O006B000200044O00E300025O0012B73O00203O0026593O00A90201004700048F3O00A902012O000600025O0020720002000200480020F30002000200222O00B400020002000200061C0002006402013O00048F3O006402012O0006000200193O00061C0002006402013O00048F3O006402012O000600025O0020720002000200360020F30002000200122O00B4000200020002000683000200510201000100048F3O005102012O0006000200073O00203A00020002000F4O00045O00202O0004000400104O00020004000200062O000200570201000100048F3O005702012O000600025O0020720002000200490020F30002000200122O00B400020002000200061C0002006402013O00048F3O006402012O0006000200024O004800035O00202O0003000300484O000400036O000400046O00020004000200062O0002006402013O00048F3O006402012O0006000200043O0012B70003004A3O0012B70004004B4O006B000200044O00E300026O000600025O0020720002000200070020F30002000200042O00B400020002000200061C0002008602013O00048F3O008602012O0006000200053O00061C0002008602013O00048F3O008602012O000600025O0020720002000200070020F300020002002F2O00B4000200020002000E13002000860201000200048F3O008602012O000600025O0020720002000200110020F30002000200122O00B400020002000200061C0002008602013O00048F3O008602012O0006000200024O004800035O00202O0003000300074O000400036O000400046O00020004000200062O0002008602013O00048F3O008602012O0006000200043O0012B70003004C3O0012B70004004D4O006B000200044O00E300026O000600025O00207200020002000A0020F30002000200042O00B400020002000200061C000200A802013O00048F3O00A802012O0006000200063O00061C000200A802013O00048F3O00A802012O000600025O00207200020002000A0020F300020002002F2O00B4000200020002000E13002000A80201000200048F3O00A802012O000600025O0020720002000200110020F30002000200122O00B400020002000200061C000200A802013O00048F3O00A802012O0006000200024O004800035O00202O00030003000A4O000400036O000400046O00020004000200062O000200A802013O00048F3O00A802012O0006000200043O0012B70003004E3O0012B70004004F4O006B000200044O00E300025O0012B73O000E3O0026593O00150301005000048F3O001503012O000600025O0020720002000200210020F30002000200222O00B400020002000200061C000200C102013O00048F3O00C102012O00060002000C3O00061C000200C102013O00048F3O00C102012O0006000200024O004800035O00202O0003000300214O000400036O000400046O00020004000200062O000200C102013O00048F3O00C102012O0006000200043O0012B7000300513O0012B7000400524O006B000200044O00E300026O000600025O0020720002000200030020F30002000200042O00B400020002000200061C000200EA02013O00048F3O00EA02012O0006000200013O00061C000200EA02013O00048F3O00EA02012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O000200EA02013O00048F3O00EA02012O000600025O0020720002000200150020F30002000200122O00B400020002000200061C000200EA02013O00048F3O00EA02012O000600025O0020720002000200110020F30002000200122O00B4000200020002000683000200EA0201000100048F3O00EA02012O0006000200024O004800035O00202O0003000300034O000400036O000400046O00020004000200062O000200EA02013O00048F3O00EA02012O0006000200043O0012B7000300533O0012B7000400544O006B000200044O00E300026O000600025O0020720002000200180020F30002000200042O00B400020002000200061C0002001403013O00048F3O001403012O0006000200083O00061C0002001403013O00048F3O001403012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002000703013O00048F3O000703012O000600025O0020720002000200360020F30002000200122O00B400020002000200061C0002001403013O00048F3O001403012O0006000200073O00208C00020002003E4O00045O00202O0004000400414O00020004000200062O0002001403013O00048F3O001403012O0006000200024O004800035O00202O0003000300184O000400036O000400046O00020004000200062O0002001403013O00048F3O001403012O0006000200043O0012B7000300553O0012B7000400564O006B000200044O00E300025O0012B73O00473O0026593O008F0301002E00048F3O008F03012O0006000200073O0020B00002000200574O0002000200024O0003001A6O000400073O00202O00040004000F4O00065O00202O0006000600414O000400066O00033O000200202O0003000300582O001A0002000200032O00B8000300073O00202O0003000300594O00055O00202O00050005005A4O00030005000200202O00030003005B4O0002000200034O000300073O00202O0003000300594O00055O00207200050005005C2O007E00030005000200205700030003005D2O001A000100020003000E32005E006B0301000100048F3O006B03012O0006000200073O0020CF00020002005F00122O000400603O00122O000500506O00020005000200062O0002006B03013O00048F3O006B03010012B7000200013O0026590002003B0301000100048F3O003B03012O000600035O0020720003000300030020F30003000300042O00B400030002000200061C0003005303013O00048F3O005303012O0006000300013O00061C0003005303013O00048F3O005303012O0006000300024O004800045O00202O0004000400034O000500036O000500056O00030005000200062O0003005303013O00048F3O005303012O0006000300043O0012B7000400613O0012B7000500624O006B000300054O00E300036O000600035O0020720003000300180020F30003000300042O00B400030002000200061C0003006B03013O00048F3O006B03012O0006000300083O00061C0003006B03013O00048F3O006B03012O0006000300024O004800045O00202O0004000400184O000500036O000500056O00030005000200062O0003006B03013O00048F3O006B03012O0006000300043O0012C4000400633O00122O000500646O000300056O00035O00044O006B030100048F3O003B03012O000600025O00207200020002000A0020F30002000200042O00B400020002000200061C0002008E03013O00048F3O008E03012O000600025O0020720002000200110020F30002000200122O00B400020002000200061C0002008E03013O00048F3O008E03012O0006000200063O00061C0002008E03013O00048F3O008E03012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O0002008E03013O00048F3O008E03012O0006000200024O004800035O00202O00030003000A4O000400036O000400046O00020004000200062O0002008E03013O00048F3O008E03012O0006000200043O0012B7000300653O0012B7000400664O006B000200044O00E300025O0012B73O00673O0026593O00020001006700048F3O000200012O000600025O0020720002000200210020F30002000200222O00B400020002000200061C000200AE03013O00048F3O00AE03012O00060002000C3O00061C000200AE03013O00048F3O00AE03012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O000200AE03013O00048F3O00AE03012O0006000200024O004800035O00202O0003000300214O000400036O000400046O00020004000200062O000200AE03013O00048F3O00AE03012O0006000200043O0012B7000300683O0012B7000400694O006B000200044O00E300026O000600025O00207200020002002B0020F30002000200042O00B400020002000200061C000200DB03013O00048F3O00DB03012O0006000200123O00061C000200BA03013O00048F3O00BA03012O00060002000E3O000683000200BD0301000100048F3O00BD03012O0006000200123O000683000200DB0301000100048F3O00DB03012O0006000200133O00061C000200DB03013O00048F3O00DB03012O0006000200104O0006000300113O000660000200DB0301000300048F3O00DB03012O0006000200073O00208C00020002000F4O00045O00202O0004000400104O00020004000200062O000200DB03013O00048F3O00DB03012O0006000200024O00C300035O00202O00030003002B4O0004000A3O00202O00040004001D4O0006000B6O0004000600024O000400046O00020004000200062O000200DB03013O00048F3O00DB03012O0006000200043O0012B70003006A3O0012B70004006B4O006B000200044O00E300026O000600025O0020720002000200320020F30002000200222O00B400020002000200061C0002001804013O00048F3O001804012O0006000200153O00061C0002001804013O00048F3O001804012O0006000200073O00203A00020002000F4O00045O00202O0004000400414O00020004000200062O0002000B0401000100048F3O000B04012O0006000200073O0020340002000200244O00045O00202O0004000400104O0002000400024O000300073O00202O0003000300254O00030002000200062O0002000B0401000300048F3O000B04012O0006000200073O0020F300020002006C2O00B4000200020002000E13006D2O000401000200048F4O0004012O000600025O00207200020002006E0020F30002000200122O00B40002000200020006830002000B0401000100048F3O000B04012O0006000200073O0020F300020002006C2O00B4000200020002000E13006F00180401000200048F3O001804012O000600025O00207200020002006E0020F30002000200122O00B4000200020002000683000200180401000100048F3O001804012O0006000200024O004800035O00202O0003000300324O000400036O000400046O00020004000200062O0002001804013O00048F3O001804012O0006000200043O0012B7000300703O0012B7000400714O006B000200044O00E300025O0012B73O00503O00048F3O000200012O003B3O00017O00693O00028O00026O00F03F03113O0048616E646C65496E636F72706F7265616C03093O0053746F726D426F6C7403123O0053746F726D426F6C744D6F7573656F766572026O00344003113O00496E74696D69646174696E6753686F7574031A3O00496E74696D69646174696E6753686F75744D6F7573656F766572026O002040030D3O00546172676574497356616C6964027O0040030D3O00577265636B696E675468726F77030A3O0049734361737461626C65030F3O00412O66656374696E67436F6D62617403093O004973496E52616E6765026O003E4003133O0093535D2D8F485629BB55503C8B56182385485603043O004EE42138026O000840030D3O0043617374412O6E6F746174656403043O00502O6F6C03043O00F95F9B3703053O00E5AE1ED26303133O00576169742F502O6F6C205265736F757263657303093O00426C2O6F644675727903123O0019E1895EE9023F0EFF9F11E03C3015ADD72O03073O00597B8DE6318D5D030A3O004265727365726B696E6703063O0042752O66557003103O005265636B6C652O736E652O7342752O6603123O00F174E41F1558F878F80B5047F278F84C411E03063O002A9311966C70030E3O004C69676874734A7564676D656E7403083O0042752O66446F776E030E3O0049735370652O6C496E52616E676503173O0003AF2A77F3FB30AC387BE0E50AA8393FEAE906A86D2EB103063O00886FC64D1F8703093O0046697265626C2O6F6403113O000400B553BFE818A60649AA57B4EA57F85A03083O00C96269C736DD8477030D3O00416E6365737472616C43612O6C03163O00B80280241121BEB800BC220339A0F90182280C75FEE903073O00CCD96CE3416255030B3O004261676F66547269636B73030A3O00456E7261676542752O6603153O005CC2F2DA23C661D7E7EC2FCB4D83F8E425CE1E91A703063O00A03EA395854C030C3O005265636B6C652O736E652O73030B3O00412O6E6968696C61746F72030B3O004973417661696C61626C65030C3O00466967687452656D61696E73026O00284003143O00C4A50E24CFD3B31E21C6C5B34D22C2DFAE4D7D9403053O00A3B6C06D4F03073O005261766167657203063O00242A01D9F02603053O0095544660A003063O00417661746172030F3O00432O6F6C646F776E52656D61696E73026O002440030D3O0052617661676572506C61796572030F3O002A071BEC3F031FAD350704E378545503043O008D58666D03063O00B046D863152F03083O00A1D333AA107A5D35030D3O0052617661676572437572736F72030F3O00E9AFA429FCABA068F6AFBB26BBFCEA03043O00489BCED2030E3O0053706561726F6642617374696F6E03063O0056765517365403053O0053261A346E030A3O0041766174617242752O66030D3O00546974616E73546F726D656E7403073O0048617354696572026O003F4003143O0053706561724F6642617374696F6E506C6179657203183O004B0722474A2O2840671526554C1E2848181A264F5657741603043O002638774703063O00F0FA4AC52A4403063O0036938F38B64503143O0053706561724F6642617374696F6E437572736F7203183O00C591FA48CDE98EF976DDD792EB40D0D8C1F248D6D8C1AC1803053O00BFB6E19F2903093O004F64796E734675727903113O004265727365726B657273546F726D656E74030E3O002A0429418A95822613215BCBD59603073O00A24B724835EBE7026O00444003143O009E3947E95F079F2F4AE74011CC3145EB5D42DE6A03063O0062EC5C248233030B3O004865726F69635468726F7703113O00AC1C1EB54CAB8A24AC0B03AD05A5B439AA03083O0050C4796CDA25C8D503063O00436861726765030D3O00037B036D4C0BCA0D720B710B5C03073O00EA6013621F2B6E030F3O0048616E646C65445053506F74696F6E03103O004865616C746850657263656E74616765030B3O00566963746F72795275736803073O004973526561647903113O00101651D3A36092390D47D4A43283031E5E03073O00EB667F32A7CC1203103O00496D70656E64696E67566963746F727903163O0059ACE5264A2A59AFF21C522753B5FA315D6E58A4F42F03063O004E30C195432400C4032O0012B73O00013O0026593O00B70301000200048F3O00B703012O000600015O00061C0001002C00013O00048F3O002C00010012B7000100013O002659000100190001000100048F3O001900012O0006000200023O0020690002000200034O000300033O00202O0003000300044O000400043O00202O00040004000500122O000500066O000600016O0002000600024O000200016O000200013O00062O0002001800013O00048F3O001800012O0006000200014O0070000200023O0012B7000100023O002659000100070001000200048F3O000700012O0006000200023O0020690002000200034O000300033O00202O0003000300074O000400043O00202O00040004000800122O000500096O000600016O0002000600024O000200016O000200013O00062O0002002C00013O00048F3O002C00012O0006000200014O0070000200023O00048F3O002C000100048F3O000700012O0006000100023O00207200010001000A2O008700010001000200061C000100C303013O00048F3O00C303010012B7000100014O00A1000200023O002659000100730001000B00048F3O007300012O0006000300033O00207200030003000C0020F300030003000D2O00B400030002000200061C0003005700013O00048F3O005700012O0006000300053O00061C0003005700013O00048F3O005700012O0006000300063O0020F300030003000E2O00B400030002000200061C0003005700013O00048F3O005700012O0006000300074O008700030001000200061C0003005700013O00048F3O005700012O0006000300084O00DC000400033O00202O00040004000C4O000500063O00202O00050005000F00122O000700106O0005000700024O000500056O00030005000200062O0003005700013O00048F3O005700012O0006000300093O0012B7000400113O0012B7000500124O006B000300054O00E300036O00060003000A3O00061C0003006A00013O00048F3O006A00012O00060003000B3O000E13000B006A0001000300048F3O006A00010012B7000300013O0026590003005E0001000100048F3O005E00012O00060004000C4O00870004000100022O005D000400014O0006000400013O00061C0004006A00013O00048F3O006A00012O0006000400014O0070000400023O00048F3O006A000100048F3O005E00012O00060003000D4O00870003000100022O005D000300014O0006000300013O00061C0003007200013O00048F3O007200012O0006000300014O0070000300023O0012B7000100133O002659000100840001001300048F3O008400012O00060003000E3O00201F0003000300144O000400033O00202O0004000400154O00058O000600093O00122O000700163O00122O000800176O000600086O00033O000200062O000300C303013O00048F3O00C303010012B7000300184O0070000300023O00048F3O00C30301002659000100550301000200048F3O005503012O00060003000F4O0006000400103O000660000300A30001000400048F3O00A300012O0006000300113O00061C000300A300013O00048F3O00A300012O0006000300123O00061C0003009300013O00048F3O009300012O0006000300133O000683000300960001000100048F3O009600012O0006000300133O000683000300A30001000100048F3O00A300010012B7000300013O002659000300970001000100048F3O009700012O0006000400144O00870004000100022O005D000400014O0006000400013O00061C000400A300013O00048F3O00A300012O0006000400014O0070000400023O00048F3O00A3000100048F3O009700012O00060003000F4O0006000400103O000660000300542O01000400048F3O00542O012O0006000300153O00061C000300542O013O00048F3O00542O012O0006000300163O00061C000300B000013O00048F3O00B000012O0006000300123O000683000300B30001000100048F3O00B300012O0006000300163O000683000300542O01000100048F3O00542O010012B7000300013O002659000300E40001000100048F3O00E400012O0006000400033O0020720004000400190020F300040004000D2O00B400040002000200061C000400C900013O00048F3O00C900012O0006000400084O0048000500033O00202O0005000500194O000600176O000600066O00040006000200062O000400C900013O00048F3O00C900012O0006000400093O0012B70005001A3O0012B70006001B4O006B000400064O00E300046O0006000400033O00207200040004001C0020F300040004000D2O00B400040002000200061C000400E300013O00048F3O00E300012O0006000400183O00208C00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400E300013O00048F3O00E300012O0006000400084O0048000500033O00202O00050005001C4O000600176O000600066O00040006000200062O000400E300013O00048F3O00E300012O0006000400093O0012B70005001F3O0012B7000600204O006B000400064O00E300045O0012B7000300023O002659000300182O01000200048F3O00182O012O0006000400033O0020720004000400210020F300040004000D2O00B400040002000200061C000400042O013O00048F3O00042O012O0006000400183O00208C0004000400224O000600033O00202O00060006001E4O00040006000200062O000400042O013O00048F3O00042O012O0006000400084O00A4000500033O00202O0005000500214O000600063O00202O0006000600234O000800033O00202O0008000800214O0006000800024O000600066O00040006000200062O000400042O013O00048F3O00042O012O0006000400093O0012B7000500243O0012B7000600254O006B000400064O00E300046O0006000400033O0020720004000400260020F300040004000D2O00B400040002000200061C000400172O013O00048F3O00172O012O0006000400084O0048000500033O00202O0005000500264O000600176O000600066O00040006000200062O000400172O013O00048F3O00172O012O0006000400093O0012B7000500273O0012B7000600284O006B000400064O00E300045O0012B70003000B3O002659000300B40001000B00048F3O00B400012O0006000400033O0020720004000400290020F300040004000D2O00B400040002000200061C0004002D2O013O00048F3O002D2O012O0006000400084O0048000500033O00202O0005000500294O000600176O000600066O00040006000200062O0004002D2O013O00048F3O002D2O012O0006000400093O0012B70005002A3O0012B70006002B4O006B000400064O00E300046O0006000400033O00207200040004002C0020F300040004000D2O00B400040002000200061C000400542O013O00048F3O00542O012O0006000400183O00208C0004000400224O000600033O00202O00060006001E4O00040006000200062O000400542O013O00048F3O00542O012O0006000400183O00208C00040004001D4O000600033O00202O00060006002D4O00040006000200062O000400542O013O00048F3O00542O012O0006000400194O00A4000500033O00202O00050005002C4O000600063O00202O0006000600234O000800033O00202O00080008002C4O0006000800024O000600066O00040006000200062O000400542O013O00048F3O00542O012O0006000400093O0012C40005002E3O00122O0006002F6O000400066O00045O00044O00542O0100048F3O00B400012O00060003000F4O0006000400103O000660000300350301000400048F3O003503010012B7000300013O002659000300BC2O01000200048F3O00BC2O012O0006000400033O0020720004000400300020F300040004000D2O00B400040002000200061C000400852O013O00048F3O00852O012O00060004001A3O00061C000400852O013O00048F3O00852O012O00060004001B3O00061C0004006A2O013O00048F3O006A2O012O0006000400123O0006830004006D2O01000100048F3O006D2O012O00060004001B3O000683000400852O01000100048F3O00852O012O0006000400033O0020720004000400310020F30004000400322O00B400040002000200061C000400782O013O00048F3O00782O012O00060004001C3O0020720004000400332O008700040001000200262F000400852O01003400048F3O00852O012O0006000400084O0048000500033O00202O0005000500304O000600176O000600066O00040006000200062O000400852O013O00048F3O00852O012O0006000400093O0012B7000500353O0012B7000600364O006B000400064O00E300046O0006000400033O0020720004000400370020F300040004000D2O00B400040002000200061C000400BB2O013O00048F3O00BB2O012O00060004001D4O005F000500093O00122O000600383O00122O000700396O00050007000200062O000400BB2O01000500048F3O00BB2O012O00060004001E3O00061C000400BB2O013O00048F3O00BB2O012O00060004001F3O00061C0004009B2O013O00048F3O009B2O012O0006000400123O0006830004009E2O01000100048F3O009E2O012O00060004001F3O000683000400BB2O01000100048F3O00BB2O012O0006000400033O00207200040004003A0020F300040004003B2O00B4000400020002002649000400AE2O01001300048F3O00AE2O012O0006000400183O00203A00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400AE2O01000100048F3O00AE2O012O0006000400103O00262F000400BB2O01003C00048F3O00BB2O012O0006000400084O0048000500043O00202O00050005003D4O000600176O000600066O00040006000200062O000400BB2O013O00048F3O00BB2O012O0006000400093O0012B70005003E3O0012B70006003F4O006B000400064O00E300045O0012B70003000B3O002659000300430201000B00048F3O004302012O0006000400033O0020720004000400370020F300040004000D2O00B400040002000200061C000400F42O013O00048F3O00F42O012O00060004001D4O005F000500093O00122O000600403O00122O000700416O00050007000200062O000400F42O01000500048F3O00F42O012O00060004001E3O00061C000400F42O013O00048F3O00F42O012O00060004001F3O00061C000400D42O013O00048F3O00D42O012O0006000400123O000683000400D72O01000100048F3O00D72O012O00060004001F3O000683000400F42O01000100048F3O00F42O012O0006000400033O00207200040004003A0020F300040004003B2O00B4000400020002002649000400E72O01001300048F3O00E72O012O0006000400183O00203A00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400E72O01000100048F3O00E72O012O0006000400103O00262F000400F42O01003C00048F3O00F42O012O0006000400084O0048000500043O00202O0005000500424O000600176O000600066O00040006000200062O000400F42O013O00048F3O00F42O012O0006000400093O0012B7000500433O0012B7000600444O006B000400064O00E300046O0006000400033O0020720004000400450020F300040004000D2O00B400040002000200061C0004004202013O00048F3O004202012O0006000400204O005F000500093O00122O000600463O00122O000700476O00050007000200062O000400420201000500048F3O004202012O0006000400213O00061C0004004202013O00048F3O004202012O0006000400223O00061C0004000A02013O00048F3O000A02012O0006000400123O0006830004000D0201000100048F3O000D02012O0006000400223O000683000400420201000100048F3O004202012O0006000400183O00208C00040004001D4O000600033O00202O00060006002D4O00040006000200062O0004004202013O00048F3O004202012O0006000400183O00203A00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400350201000100048F3O003502012O0006000400183O00203A00040004001D4O000600033O00202O0006000600484O00040006000200062O000400350201000100048F3O003502012O0006000400103O002649000400350201000600048F3O003502012O00060004000B3O000EEF000200350201000400048F3O003502012O0006000400033O0020720004000400490020F30004000400322O00B400040002000200061C0004003502013O00048F3O003502012O0006000400183O00209E00040004004A00122O0006004B3O00122O0007000B6O00040007000200062O000400420201000100048F3O004202012O0006000400084O0048000500043O00202O00050005004C4O000600176O000600066O00040006000200062O0004004202013O00048F3O004202012O0006000400093O0012B70005004D3O0012B70006004E4O006B000400064O00E300045O0012B7000300133O002659000300940201001300048F3O009402012O0006000400033O0020720004000400450020F300040004000D2O00B400040002000200061C0004003503013O00048F3O003503012O0006000400204O005F000500093O00122O0006004F3O00122O000700506O00050007000200062O000400350301000500048F3O003503012O0006000400213O00061C0004003503013O00048F3O003503012O0006000400223O00061C0004005B02013O00048F3O005B02012O0006000400123O0006830004005E0201000100048F3O005E02012O0006000400223O000683000400350301000100048F3O003503012O0006000400183O00208C00040004001D4O000600033O00202O00060006002D4O00040006000200062O0004003503013O00048F3O003503012O0006000400183O00203A00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400860201000100048F3O008602012O0006000400183O00203A00040004001D4O000600033O00202O0006000600484O00040006000200062O000400860201000100048F3O008602012O0006000400103O002649000400860201000600048F3O008602012O00060004000B3O000EEF000200860201000400048F3O008602012O0006000400033O0020720004000400490020F30004000400322O00B400040002000200061C0004008602013O00048F3O008602012O0006000400183O00209E00040004004A00122O0006004B3O00122O0007000B6O00040007000200062O000400350301000100048F3O003503012O0006000400084O0048000500043O00202O0005000500514O000600176O000600066O00040006000200062O0004003503013O00048F3O003503012O0006000400093O0012C4000500523O00122O000600536O000400066O00045O00044O00350301002659000300592O01000100048F3O00592O012O0006000400033O00207200040004003A0020F300040004000D2O00B400040002000200061C000400F902013O00048F3O00F902012O0006000400233O00061C000400F902013O00048F3O00F902012O0006000400243O00061C000400A502013O00048F3O00A502012O0006000400123O000683000400A80201000100048F3O00A802012O0006000400243O000683000400F90201000100048F3O00F902012O0006000400033O0020720004000400490020F30004000400322O00B400040002000200061C000400C202013O00048F3O00C202012O0006000400183O00208C00040004001D4O000600033O00202O00060006002D4O00040006000200062O000400C202013O00048F3O00C202012O0006000400183O00208C0004000400224O000600033O00202O0006000600484O00040006000200062O000400C202013O00048F3O00C202012O0006000400033O0020720004000400540020F300040004003B2O00B4000400020002000EEF000100EC0201000400048F3O00EC02012O0006000400033O0020720004000400550020F30004000400322O00B400040002000200061C000400D602013O00048F3O00D602012O0006000400183O00208C00040004001D4O000600033O00202O00060006002D4O00040006000200062O000400D602013O00048F3O00D602012O0006000400183O00203A0004000400224O000600033O00202O0006000600484O00040006000200062O000400EC0201000100048F3O00EC02012O0006000400033O0020720004000400490020F30004000400322O00B4000400020002000683000400F90201000100048F3O00F902012O0006000400033O0020720004000400550020F30004000400322O00B4000400020002000683000400F90201000100048F3O00F902012O0006000400183O00203A00040004001D4O000600033O00202O00060006001E4O00040006000200062O000400EC0201000100048F3O00EC02012O0006000400103O00262F000400F90201000600048F3O00F902012O0006000400084O0048000500033O00202O00050005003A4O000600176O000600066O00040006000200062O000400F902013O00048F3O00F902012O0006000400093O0012B7000500563O0012B7000600574O006B000400064O00E300046O0006000400033O0020720004000400300020F300040004000D2O00B400040002000200061C0004003303013O00048F3O003303012O00060004001A3O00061C0004003303013O00048F3O003303012O00060004001B3O00061C0004000803013O00048F3O000803012O0006000400123O0006830004000B0301000100048F3O000B03012O00060004001B3O000683000400330301000100048F3O003303012O0006000400033O0020720004000400310020F30004000400322O00B400040002000200061C0004001703013O00048F3O001703012O0006000400033O00207200040004003A0020F300040004003B2O00B4000400020002002649000400260301000200048F3O002603012O0006000400033O00207200040004003A0020F300040004003B2O00B4000400020002000EEF005800260301000400048F3O002603012O0006000400033O00207200040004003A0020F30004000400322O00B400040002000200061C0004002603013O00048F3O002603012O0006000400103O00262F000400330301003400048F3O003303012O0006000400084O0048000500033O00202O0005000500304O000600176O000600066O00040006000200062O0004003303013O00048F3O003303012O0006000400093O0012B7000500593O0012B70006005A4O006B000400064O00E300045O0012B7000300023O00048F3O00592O012O0006000300253O00061C0003005403013O00048F3O005403012O0006000300033O00207200030003005B0020F300030003000D2O00B400030002000200061C0003005403013O00048F3O005403012O0006000300063O0020F300030003000F0012B7000500104O007E000300050002000683000300540301000100048F3O005403012O0006000300084O00DC000400033O00202O00040004005B4O000500063O00202O00050005000F00122O000700106O0005000700024O000500056O00030005000200062O0003005403013O00048F3O005403012O0006000300093O0012B70004005C3O0012B70005005D4O006B000300054O00E300035O0012B70001000B3O000E10000100330001000100048F3O003300012O0006000300263O00061C0003007103013O00048F3O007103012O0006000300033O00207200030003005E0020F300030003000D2O00B400030002000200061C0003007103013O00048F3O007103012O0006000300084O00A4000400033O00202O00040004005E4O000500063O00202O0005000500234O000700033O00202O00070007005E4O0005000700024O000500056O00030005000200062O0003007103013O00048F3O007103012O0006000300093O0012B70004005F3O0012B7000500604O006B000300054O00E300036O0006000300023O00207F0003000300614O000400063O00202O00040004001D4O000600033O00202O00060006001E4O000400066O00033O00024O000200033O00062O0002007D03013O00048F3O007D03012O0070000200024O0006000300183O0020F30003000300622O00B40003000200022O0006000400273O000660000300B40301000400048F3O00B403010012B7000300013O000E10000100840301000300048F3O008403012O0006000400033O0020720004000400630020F30004000400642O00B400040002000200061C0004009C03013O00048F3O009C03012O0006000400283O00061C0004009C03013O00048F3O009C03012O0006000400084O0048000500033O00202O0005000500634O000600176O000600066O00040006000200062O0004009C03013O00048F3O009C03012O0006000400093O0012B7000500653O0012B7000600664O006B000400064O00E300046O0006000400033O0020720004000400670020F30004000400642O00B400040002000200061C000400B403013O00048F3O00B403012O0006000400283O00061C000400B403013O00048F3O00B403012O0006000400084O0048000500033O00202O0005000500674O000600176O000600066O00040006000200062O000400B403013O00048F3O00B403012O0006000400093O0012C4000500683O00122O000600696O000400066O00045O00044O00B4030100048F3O008403010012B7000100023O00048F3O0033000100048F3O00C303010026593O00010001000100048F3O000100012O0006000100294O00870001000100022O005D000100014O0006000100013O00061C000100C103013O00048F3O00C103012O0006000100014O0070000100023O0012B73O00023O00048F3O000100012O003B3O00017O000D3O00028O00030F3O00412O66656374696E67436F6D626174030F3O004265727365726B65725374616E6365030A3O0049734361737461626C6503083O0042752O66446F776E03103O00321B920B442215850A7E230A8116423503053O0021507EE078030B3O0042612O746C6553686F7574030F3O0042612O746C6553686F757442752O6603103O0047726F757042752O664D692O73696E6703163O00EEA917D050E99710CC53F9BC43D44EE9AB0CC95EEDBC03053O003C8CC863A4030D3O00546172676574497356616C696400663O0012B73O00013O0026593O00010001000100048F3O000100012O000600015O0020F30001000100022O00B4000100020002000683000100490001000100048F3O004900010012B7000100013O002659000100090001000100048F3O000900012O0006000200013O0020720002000200030020F30002000200042O00B400020002000200061C0002002400013O00048F3O002400012O000600025O0020C00002000200054O000400013O00202O0004000400034O000500016O00020005000200062O0002002400013O00048F3O002400012O0006000200024O0006000300013O0020720003000300032O00B400020002000200061C0002002400013O00048F3O002400012O0006000200033O0012B7000300063O0012B7000400074O006B000200044O00E300026O0006000200013O0020720002000200080020F30002000200042O00B400020002000200061C0002004900013O00048F3O004900012O0006000200043O00061C0002004900013O00048F3O004900012O000600025O00202A0002000200054O000400013O00202O0004000400094O000500016O00020005000200062O0002003C0001000100048F3O003C00012O0006000200053O00207A00020002000A4O000300013O00202O0003000300094O00020002000200062O0002004900013O00048F3O004900012O0006000200024O0006000300013O0020720003000300082O00B400020002000200061C0002004900013O00048F3O004900012O0006000200033O0012C40003000B3O00122O0004000C6O000200046O00025O00044O0049000100048F3O000900012O0006000100053O00207200010001000D2O008700010001000200061C0001006500013O00048F3O006500012O0006000100063O00061C0001006500013O00048F3O006500012O000600015O0020F30001000100022O00B4000100020002000683000100650001000100048F3O006500010012B7000100013O002659000100570001000100048F3O005700012O0006000200084O00870002000100022O005D000200074O0006000200073O00061C0002006500013O00048F3O006500012O0006000200074O0070000200023O00048F3O0065000100048F3O0057000100048F3O0065000100048F3O000100012O003B3O00017O003B3O00028O00030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O0092E70104A393E00823918FFB113203053O00C2E7946446030C3O00535FC481FAC74948C3A2E2C003063O00A8262CA1C396030E3O0095EF87543CE7B91294F48B6423FC03083O0076E09CE2165088D603093O0057FD5CA34AEF4B874703043O00E0228E39026O00F03F026O001440030E3O00D1A3DCD355E44F17E9AED1D550D503083O006EBEC7A5BD13913D030D3O00C8EA61E98CC2C8DC7EFC83E4FE03063O00A7BA8B1788EB03123O0008B08B0616B09B1E14B09B1E2DBC9C05399103043O006D7AD5E803143O00FDE7A731FCD8A412EFE4B639E1F99539FAFF811403043O00508E97C2026O001840027O0040030D3O0016D5727E02C17E4204E47B431403043O002C63A617030A3O0069E42C0432A96CF62E3303063O00C41C9749565303073O00E6102C238E591503083O001693634970E23878030C3O00AD66E7C285B167EEE284B67103053O00EDD8158295026O00084003143O0096464A51B4CC4C8D5B4C6DBFC84CB5474B5793ED03073O003EE22E2O3FD0A903103O00F00A50B40D082C55EC1752B7171F204903083O003E857935E37F6D4F03093O00050737D4C0AFB6110603073O00C270745295B6CE030C3O002CBB4937C4FB002A8E590AD903073O006E59C82C78A082030A3O00BED04E74425C3A4AAED103083O002DCBA32B26232A5B026O001040030F3O00C796D91182AA5FDE80CF3089AC47C103073O0034B2E5BC43E7C903113O0034525537E75922336E5626F64F37284E5E03073O004341213064973C03113O00CAF4ABECFBCAE9AADDE1D0F2BDEAFCDEF503053O0093BF87CEB8030C3O00853EA7D5D941858D3CAEE2FC03073O00D2E448C6A1B833030F3O00235AF63361DB2541FA1E74EC3A46E403063O00AE5629937013030A3O004E13882E3D0A12BE4F0503083O00CB3B60ED6B456F71030E3O003105A9C934E2D82D1598E923FFC003073O00B74476CC815190030C3O001BBE75CB059102AC65E3039603063O00E26ECD10846B00E03O0012B73O00013O0026593O00240001000100048F3O00240001001291000100023O00209A0001000100034O000200013O00122O000300043O00122O000400056O0002000400024O0001000100024O00015O00122O000100023O00202O0001000100034O000200013O00122O000300063O00122O000400076O0002000400024O0001000100024O000100023O00122O000100023O00202O0001000100034O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100033O00122O000100023O00202O0001000100034O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100043O00124O000C3O0026593O00470001000D00048F3O00470001001291000100023O00209A0001000100034O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00122O000100023O00202O0001000100034O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100023O00202O0001000100034O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00124O00163O000E100017006A00013O00048F3O006A0001001291000100023O00209A0001000100034O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00122O000100023O00202O0001000100034O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00122O000100023O00202O0001000100034O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100023O00202O0001000100034O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00124O00203O0026593O00750001001600048F3O00750001001291000100023O00200E0001000100034O000200013O00122O000300213O00122O000400226O0002000400024O0001000100024O0001000D3O00044O00DF00010026593O00980001002000048F3O00980001001291000100023O00209A0001000100034O000200013O00122O000300233O00122O000400246O0002000400024O0001000100024O0001000E3O00122O000100023O00202O0001000100034O000200013O00122O000300253O00122O000400266O0002000400024O0001000100024O0001000F3O00122O000100023O00202O0001000100034O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O000100103O00122O000100023O00202O0001000100034O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O000100113O00124O002B3O000E10002B00BB00013O00048F3O00BB0001001291000100023O00209A0001000100034O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100123O00122O000100023O00202O0001000100034O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000100133O00122O000100023O00202O0001000100034O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100143O00122O000100023O00202O0001000100034O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100153O00124O000D3O0026593O00010001000C00048F3O00010001001291000100023O00209A0001000100034O000200013O00122O000300343O00122O000400356O0002000400024O0001000100024O000100163O00122O000100023O00202O0001000100034O000200013O00122O000300363O00122O000400376O0002000400024O0001000100024O000100173O00122O000100023O00202O0001000100034O000200013O00122O000300383O00122O000400396O0002000400024O0001000100024O000100183O00122O000100023O00202O0001000100034O000200013O00122O0003003A3O00122O0004003B6O0002000400024O0001000100024O000100193O00124O00173O00048F3O000100012O003B3O00017O00373O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E677303113O00FED0E5FB48FFD7E5CB68E6CEF5D748FFDA03053O00218BA380B903163O00424B01FB594A05D9525C36DB505D0ADB455910D7585603043O00BE373864030D3O0043BC393714EDFC44AA0C1F1AED03073O009336CF5C7E7383027O004003093O001822304D187300343903063O001E6D51551D6D030C3O00EA62518522D1EEF2535BBA2203073O009C9F1134D656BE03143O00BBFCB895A0FBB4B1A7EBBCA8A7E1BA8FA6E02OA803043O00DCCE8FDD030E3O00936E2825D9C0DE9F742310FBDECB03073O00B2E61D4D77B8AC030C3O00E0AD0F3279ECF0AC1C1E79FD03063O009895DE6A7B1703123O00C835F367B0DB23F850BCCB23C557B4D325F303053O00D5BD469623026O000840026O001840030D3O00595C771C40476D3A5A467C207F03043O00682F3514030E3O00B14D971DBB0AB17F8408A806AD4B03063O006FC32CE17CDC03063O00C84A016AAEB903063O00CBB8266013CB030C3O002A637C40DC0A766D55C7377403053O00AE5913192103063O003F1E5357F29503073O006B4F72322E97E7026O001040030C3O0030A1BB26983C87C130A89D1903083O00A059C6D549EA59D7030D3O005A70B8F2DC417FB3DDD751598403053O00A52811D49E03103O00F7D8042O3FECD70F1034FCFE1A3C33F503053O004685B96853026O001440030B3O000D4B502FDB12404A2FE13403053O00A96425244A03113O000482A4550E94AB4605B4B6510E84A7783003043O003060E7C2030A3O00DD541D3918D6AC86E06A03083O00E3A83A6E4D79B8CF030E3O006E2FBA76B8D865AA69258D55A2D303083O00C51B5CDF20D1BB1103103O000156D7EF064DEAF60E4ACDF21746EBCB03043O009B633FA303153O0087DFB38CBE8186E3A48ABC8A87C3A099B08B8CF99103063O00E4E2B1C1EDD900E73O0012B73O00013O0026593O001C0001000200048F3O001C0001001291000100033O0020F50001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00124O000B3O000E100001003700013O00048F3O00370001001291000100033O0020F50001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O000100063O00124O00023O0026593O00520001000B00048F3O00520001001291000100033O0020F50001000100044O000200013O00122O000300123O00122O000400136O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100093O00124O00183O0026593O007C0001001900048F3O007C0001001291000100033O0020BB0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O0001005E0001000100048F3O005E00010012B7000100014O005D0001000A3O0012E1000100033O00202O0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O00010001000200062O0001006C0001000100048F3O006C00012O0006000100013O0012B70002001E3O0012B70003001F4O007E0001000300022O005D0001000B3O0012E1000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O00010001000200062O0001007A0001000100048F3O007A00012O0006000100013O0012B7000200223O0012B7000300234O007E0001000300022O005D0001000C3O00048F3O00E600010026593O00A00001002400048F3O00A00001001291000100033O0020BB0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O000100880001000100048F3O008800010012B7000100014O005D0001000D3O0012E1000100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O00010001000200062O000100930001000100048F3O009300010012B7000100014O005D0001000E3O0012E1000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O00010001000200062O0001009E0001000100048F3O009E00010012B7000100014O005D0001000F3O0012B73O002B3O0026593O00C40001002B00048F3O00C40001001291000100033O0020BB0001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O00010001000200062O000100AC0001000100048F3O00AC00010012B7000100014O005D000100103O0012E1000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100B70001000100048F3O00B700010012B7000100014O005D000100113O0012E1000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O00010001000200062O000100C20001000100048F3O00C200010012B7000100014O005D000100123O0012B73O00193O0026593O00010001001800048F3O00010001001291000100033O00204C0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300343O00122O000400356O0002000400024O00010001000200062O000100D80001000100048F3O00D800010012B7000100014O005D000100143O0012E1000100033O00202O0001000100044O000200013O00122O000300363O00122O000400376O0002000400024O00010001000200062O000100E30001000100048F3O00E300010012B7000100014O005D000100153O0012B73O00243O00048F3O000100012O003B3O00017O00233O00028O00026O000840030C3O004570696353652O74696E677303083O0053652O74696E677303113O001CB522EA3DBE24D63BA42AE93A9E22EB3103043O008654D043034O0003113O003BAD88581FA9AF5210A3944C1CBE835D1F03043O003C73CCE6027O0040030E3O00F229EE58E23BE764EF29FF7FE93F03043O0010875A8B03103O004167031B4B55745D7A01034140715B7A03073O0018341466532E34030D3O00CC2A20281BCC3C352B01C1071103053O006FA44F4144030F3O00CEDC82D227E4C1E98CCA27E5C8F1B303063O008AA6B9E3BE4E026O00F03F030B3O00DE67C003402A17C071D12403073O0079AB14A5573243030A3O00D32BBC04B801CF39B52503063O0062A658D956D9030E3O00E2E4700F8DD9E2E54E0892D4D5D203063O00BC2O961961E6030D3O00C8885C0B0DE1C9BE561604CEFE03063O008DBAE93F626C03113O00F7E32BBE31C3EF21B72CFFF90FBE20F2E103053O0045918A4CD603113O0059C19D8CAD0465DF9DBEB60278FC9D9CB103063O007610AF2OE9DF03163O00A28A21BEFC99689B901AB5E2924A838D21BEE2826E9F03073O001DEBE455DB8EEB03123O0014DAAED8655C324229E0B2CF725D2F5D31D003083O00325DB4DABD172E47008B3O0012B73O00013O0026593O00170001000200048F3O00170001001291000100033O0020BB0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D0001000100048F3O000D00010012B7000100074O005D00015O001275000100033O00202O0001000100044O000200013O00122O000300083O00122O000400096O0002000400024O0001000100024O000100023O00044O008A00010026593O00400001000A00048F3O00400001001291000100033O0020BF0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O00010001000200062O000100330001000100048F3O003300010012B7000100014O005D000100053O0012E1000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200062O0001003E0001000100048F3O003E00010012B7000100014O005D000100063O0012B73O00023O000E100013006300013O00048F3O00630001001291000100033O00209A0001000100044O000200013O00122O000300143O00122O000400156O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300163O00122O000400176O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300183O00122O000400196O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O0001000100024O0001000A3O00124O000A3O0026593O00010001000100048F3O00010001001291000100033O0020BB0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O00010001000200062O0001006F0001000100048F3O006F00010012B7000100014O005D0001000B3O0012F1000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000D3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000E3O00124O00133O00044O000100012O003B3O00017O00183O00028O00030C3O004570696353652O74696E677303073O00546F2O676C65732O033O00D1AB5803073O0028BEC43B2C24BC026O00F03F2O033O003D4AD903073O006D5C25BCD49A1D2O033O0007EBB703063O003A648FC4A351030D3O004973446561644F7247686F737403113O00496E74696D69646174696E6753686F7574030B3O004973417661696C61626C65026O002040027O004003163O00476574456E656D696573496E4D656C2O6552616E6765030E3O004973496E4D656C2O6552616E6765026O001440030D3O00546172676574497356616C6964030F3O00412O66656374696E67436F6D626174024O0080B3C540030C3O00466967687452656D61696E7303103O00426F2O73466967687452656D61696E73030C3O0049734368612O6E656C696E6700983O0012B73O00013O0026593O00120001000100048F3O001200012O000600016O005A0001000100014O000100016O0001000100014O000100026O00010001000100122O000100023O00202O0001000100034O000200043O00122O000300043O00122O000400056O0002000400024O0001000100024O000100033O00124O00063O0026593O00330001000600048F3O00330001001291000100023O0020FB0001000100034O000200043O00122O000300073O00122O000400086O0002000400024O0001000100024O000100053O00122O000100023O00202O0001000100034O000200043O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100066O000100073O00202O00010001000B4O00010002000200062O0001002A00013O00048F3O002A00012O003B3O00014O0006000100083O00207200010001000C0020F300010001000D2O00B400010002000200061C0001003200013O00048F3O003200010012B70001000E4O005D000100093O0012B73O000F3O000E10000F000100013O00048F3O000100012O0006000100053O00061C0001004600013O00048F3O004600010012B7000100013O002659000100390001000100048F3O003900012O0006000200073O00202E0002000200104O000400096O0002000400024O0002000A6O0002000A6O000200026O0002000B3O00044O0048000100048F3O0039000100048F3O004800010012B7000100064O005D0001000B4O00060001000D3O00206300010001001100122O000300126O0001000300024O0001000C6O0001000E3O00202O0001000100134O00010001000200062O000100570001000100048F3O005700012O0006000100073O0020F30001000100142O00B400010002000200061C0001007000013O00048F3O007000010012B7000100013O000E10000600640001000100048F3O006400012O00060002000F3O002659000200700001001500048F3O007000012O0006000200103O0020760002000200164O0003000A6O00048O0002000400024O0002000F3O00044O00700001002659000100580001000100048F3O005800012O0006000200103O00204E0002000200174O000300036O000400016O0002000400024O000200116O000200116O0002000F3O00122O000100063O00044O005800012O0006000100073O0020F30001000100182O00B4000100020002000683000100970001000100048F3O009700012O0006000100073O0020F30001000100142O00B400010002000200061C0001008800013O00048F3O008800010012B7000100013O0026590001007B0001000100048F3O007B00012O0006000200134O00870002000100022O005D000200124O0006000200123O00061C0002009700013O00048F3O009700012O0006000200124O0070000200023O00048F3O0097000100048F3O007B000100048F3O009700010012B7000100013O002659000100890001000100048F3O008900012O0006000200144O00870002000100022O005D000200124O0006000200123O00061C0002009700013O00048F3O009700012O0006000200124O0070000200023O00048F3O0097000100048F3O0089000100048F3O0097000100048F3O000100012O003B3O00017O00033O0003053O005072696E74032B3O003C5731BA7F7EE41C084B2CB17F4BFC4E3F522AA07109D61B0A522CB12B4CE14E185B63BB1448EB0B0E4D6D03083O006E7A2243C35F298500084O00C97O00206O00014O000100013O00122O000200023O00122O000300036O000100039O0000016O00017O00", GetFEnv(), ...);
