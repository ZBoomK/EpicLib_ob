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
				if (Enum <= 147) then
					if (Enum <= 73) then
						if (Enum <= 36) then
							if (Enum <= 17) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local B;
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
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
												Upvalues[Inst[3]] = Stk[Inst[2]];
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
												Stk[Inst[2]] = Inst[3];
											end
										elseif (Enum > 2) then
											Stk[Inst[2]]();
										else
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										end
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
										end
									elseif (Enum <= 6) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 7) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 12) then
									if (Enum <= 10) then
										if (Enum == 9) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											Stk[Inst[2]] = #Stk[Inst[3]];
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
									elseif (Enum == 11) then
										Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								elseif (Enum <= 14) then
									if (Enum == 13) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 15) then
									Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
								elseif (Enum > 16) then
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
							elseif (Enum <= 26) then
								if (Enum <= 21) then
									if (Enum <= 19) then
										if (Enum == 18) then
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
									elseif (Enum > 20) then
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
									end
								elseif (Enum <= 23) then
									if (Enum == 22) then
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
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum <= 24) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 25) then
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
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum > 27) then
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
								elseif (Enum <= 29) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum > 30) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 33) then
								if (Enum > 32) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 34) then
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
							elseif (Enum == 35) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 54) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum > 37) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum == 39) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Inst[2] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 42) then
									if (Enum == 41) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum <= 43) then
									Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
								elseif (Enum == 44) then
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
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
							elseif (Enum <= 49) then
								if (Enum <= 47) then
									if (Enum > 46) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 48) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
								end
							elseif (Enum <= 51) then
								if (Enum == 50) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 53) then
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum <= 63) then
							if (Enum <= 58) then
								if (Enum <= 56) then
									if (Enum == 55) then
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
									elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
									end
								elseif (Enum > 57) then
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 60) then
								if (Enum == 59) then
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
							elseif (Enum <= 61) then
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
							elseif (Enum == 62) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 68) then
							if (Enum <= 65) then
								if (Enum > 64) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 66) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 67) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 70) then
							if (Enum == 69) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 71) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 72) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local T;
							local A;
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							T = Stk[A];
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 110) then
						if (Enum <= 91) then
							if (Enum <= 82) then
								if (Enum <= 77) then
									if (Enum <= 75) then
										if (Enum == 74) then
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
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
											if (Stk[Inst[2]] < Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 76) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
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
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 79) then
									if (Enum == 78) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 80) then
									if (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 81) then
									Stk[Inst[2]] = {};
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
							elseif (Enum <= 86) then
								if (Enum <= 84) then
									if (Enum == 83) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 85) then
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
							elseif (Enum <= 88) then
								if (Enum == 87) then
									if (Inst[2] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = #Stk[Inst[3]];
								end
							elseif (Enum <= 89) then
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
							elseif (Enum > 90) then
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
						elseif (Enum <= 100) then
							if (Enum <= 95) then
								if (Enum <= 93) then
									if (Enum > 92) then
										Stk[Inst[2]] = not Stk[Inst[3]];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum > 94) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 97) then
								if (Enum == 96) then
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
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
							elseif (Enum <= 98) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 99) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 105) then
							if (Enum <= 102) then
								if (Enum > 101) then
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 103) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 104) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 107) then
							if (Enum > 106) then
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
						elseif (Enum <= 108) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 109) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 128) then
						if (Enum <= 119) then
							if (Enum <= 114) then
								if (Enum <= 112) then
									if (Enum > 111) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 113) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
						elseif (Enum <= 123) then
							if (Enum <= 121) then
								if (Enum > 120) then
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
							elseif (Enum == 122) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 125) then
							if (Enum > 124) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 127) then
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
					elseif (Enum <= 137) then
						if (Enum <= 132) then
							if (Enum <= 130) then
								if (Enum == 129) then
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
						elseif (Enum <= 134) then
							if (Enum > 133) then
								local B;
								local T;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
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
						elseif (Enum == 136) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 142) then
						if (Enum <= 139) then
							if (Enum == 138) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
						elseif (Enum <= 140) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 141) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 144) then
						if (Enum == 143) then
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
					elseif (Enum <= 145) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 221) then
					if (Enum <= 184) then
						if (Enum <= 165) then
							if (Enum <= 156) then
								if (Enum <= 151) then
									if (Enum <= 149) then
										if (Enum > 148) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 150) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									else
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 153) then
									if (Enum > 152) then
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
										local B = Stk[Inst[4]];
										if B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 154) then
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 155) then
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum <= 160) then
								if (Enum <= 158) then
									if (Enum == 157) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, A + Inst[3]);
										end
									else
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
										end
									end
								elseif (Enum == 159) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 162) then
								if (Enum > 161) then
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
								elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 163) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 164) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A]());
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A]());
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 174) then
							if (Enum <= 169) then
								if (Enum <= 167) then
									if (Enum == 166) then
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
										if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
								elseif (Enum > 168) then
									if (Stk[Inst[2]] ~= Inst[4]) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 171) then
								if (Enum == 170) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 173) then
								if (Inst[2] < Stk[Inst[4]]) then
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
						elseif (Enum <= 179) then
							if (Enum <= 176) then
								if (Enum == 175) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 177) then
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
							elseif (Enum == 178) then
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 181) then
							if (Enum > 180) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A]());
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 182) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						elseif (Enum > 183) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 202) then
						if (Enum <= 193) then
							if (Enum <= 188) then
								if (Enum <= 186) then
									if (Enum > 185) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 187) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A]());
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 190) then
								if (Enum > 189) then
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
							elseif (Enum <= 191) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							elseif (Enum == 192) then
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							if (Enum <= 195) then
								if (Enum == 194) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum == 196) then
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
							elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum <= 199) then
							if (Enum > 198) then
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
						elseif (Enum <= 200) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 201) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 211) then
						if (Enum <= 206) then
							if (Enum <= 204) then
								if (Enum == 203) then
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
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 205) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Results, Limit = _R(Stk[A]());
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A]());
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 208) then
							if (Enum == 207) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 209) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 210) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 216) then
						if (Enum <= 213) then
							if (Enum == 212) then
								local B;
								local T;
								local A;
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 214) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						elseif (Enum == 215) then
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
					elseif (Enum <= 218) then
						if (Enum > 217) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 219) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 220) then
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
				elseif (Enum <= 258) then
					if (Enum <= 239) then
						if (Enum <= 230) then
							if (Enum <= 225) then
								if (Enum <= 223) then
									if (Enum > 222) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										local T;
										local A;
										Stk[Inst[2]] = {};
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
										Stk[Inst[2]] = {};
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
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum == 224) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
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
									Stk[Inst[2]] = {};
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
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 227) then
								if (Enum > 226) then
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 228) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 229) then
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
									if (Mvm[1] == 217) then
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
						elseif (Enum <= 234) then
							if (Enum <= 232) then
								if (Enum == 231) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 233) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 236) then
							if (Enum > 235) then
								if (Stk[Inst[2]] < Inst[4]) then
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
						elseif (Enum <= 237) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
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
					elseif (Enum <= 248) then
						if (Enum <= 243) then
							if (Enum <= 241) then
								if (Enum > 240) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									local T;
									local A;
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum == 242) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								VIP = Inst[3];
							end
						elseif (Enum <= 245) then
							if (Enum > 244) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 246) then
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 247) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 253) then
						if (Enum <= 250) then
							if (Enum > 249) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
						elseif (Enum == 252) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 255) then
						if (Enum == 254) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 256) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum > 257) then
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
				elseif (Enum <= 276) then
					if (Enum <= 267) then
						if (Enum <= 262) then
							if (Enum <= 260) then
								if (Enum > 259) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 261) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Env[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local A = Inst[2];
								local Results, Limit = _R(Stk[A]());
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 264) then
							if (Enum > 263) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 265) then
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
						elseif (Enum > 266) then
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
					elseif (Enum <= 271) then
						if (Enum <= 269) then
							if (Enum == 268) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum > 270) then
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
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
					elseif (Enum <= 273) then
						if (Enum == 272) then
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
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 275) then
						do
							return Stk[Inst[2]];
						end
					else
						local A = Inst[2];
						Top = (A + Varargsz) - 1;
						for Idx = A, Top do
							local VA = Vararg[Idx - A];
							Stk[Idx] = VA;
						end
					end
				elseif (Enum <= 285) then
					if (Enum <= 280) then
						if (Enum <= 278) then
							if (Enum > 277) then
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
						elseif (Enum > 279) then
							Env[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum <= 282) then
						if (Enum == 281) then
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
						end
					elseif (Enum <= 283) then
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
					elseif (Enum == 284) then
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
					if (Enum <= 287) then
						if (Enum == 286) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
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
					elseif (Enum <= 288) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 289) then
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
				elseif (Enum <= 292) then
					if (Enum > 291) then
						if (Inst[2] == Stk[Inst[4]]) then
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
				elseif (Enum <= 293) then
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
				elseif (Enum > 294) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031A3O00F4D3D23DD98BD517D4D0CF1AC2B2D41DD8D3D72CE8BE8912C4C203083O007EB1A3BB4586DBA7031A3O0019EFEADCE3932A35FAF0D0E387312FFCEAD4D0AA3639B1EFD1DD03073O00585C9F83A4BCC3002E3O00126D3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004F33O000A00010012C5000300063O00201C0004000300070012C5000500083O00201C0005000500090012C5000600083O00201C00060006000A0006E500073O000100062O00D93O00064O00D98O00D93O00044O00D93O00014O00D93O00024O00D93O00053O00201C00080003000B00201C00090003000C2O0052000A5O0012C5000B000D3O0006E5000C0001000100022O00D93O000A4O00D93O000B4O00D9000D00073O0012A0000E000E3O0012A0000F000F4O00EA000D000F00020006E5000E0002000100032O00D93O00074O00D93O00094O00D93O00084O00F4000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001101025O00122O000300016O00045O00122O000500013O00042O0003002100012O009F00076O00A7000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004560003000500012O009F000300054O00D9000400024O001D000300044O001E01036O0003012O00017O000D3O00028O00026O00F03F025O00809540025O00388240025O00F6A240025O002EA340025O0082AA40025O0052A540025O004FB040025O00E8B140025O00789D40025O004C9040025O00D0A14001483O0012A0000200014O00BE000300053O0026200102003F000100020004F33O003F00012O00BE000500053O0026200103000A000100010004F33O000A00010012A0000400014O00BE000500053O0012A0000300023O002E1601040005000100030004F33O0005000100262001030005000100020004F33O000500010012A0000600014O00BE000700073O00262001060010000100010004F33O001000010012A0000700013O00262001070013000100010004F33O001300010026A900040019000100020004F33O00190001002E5000050006000100060004F33O001D00012O00D9000800054O001401096O009E00086O001E01085O002ED00008000E000100070004F33O000E00010026200104000E000100010004F33O000E00010012A0000800013O002E5000090006000100090004F33O0028000100262001080028000100020004F33O002800010012A0000400023O0004F33O000E000100262001080022000100010004F33O002200012O009F00096O003F000500093O002E16010B00350001000A0004F33O0035000100067200050035000100010004F33O003500012O009F000900014O00D9000A6O0014010B6O009E00096O001E01095O0012A0000800023O0004F33O002200010004F33O000E00010004F33O001300010004F33O000E00010004F33O001000010004F33O000E00010004F33O004700010004F33O000500010004F33O004700010026A900020043000100010004F33O00430001002ED0000D00020001000C0004F33O000200010012A0000300014O00BE000400043O0012A0000200023O0004F33O000200012O0003012O00017O006D3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O007C5609295A03043O004529226003043O009FC2C41E03063O004BDCA3B76A6203043O0020B3853303053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D479028O0003103O0052616D705261707475726554696D6573025O00F6A440025O00805140025O00406540025O00E0704003133O0052616D704576616E67656C69736D54696D6573025O00E06040025O00206C40025O00D07840030D3O0052616D70426F746854696D6573025O00F0A440026O002E40025O00206240025O00406F40025O00F4A440026O005E40025O00606840025O00D07140025O00F8A440025O00206740025O00E07540025O00FEA440026O001440025O00C05C40025O00A06940025O00707240026O00A540025O00804640025O00806140025O00C06C40025O0002A540025O00405A40025O00107340025O000AA540025O00405F40025O00A06E40025O00FAA440025O00805340025O00E06540025O00D07040025O0060764003063O0037FCACCB14FA03043O00AE678EC5030A3O0072214C3B2C4EF45F265A03073O009836483F58453E03063O00E4D6E759C7D003043O003CB4A48E030A3O007C57162A2EFD1E51500003073O0072383E6549478D03063O0088FBD2C1ABFD03043O00A4D889BB030A3O00F6EF22B1AFEE07DBE83403073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703103O005265676973746572466F724576656E7403243O0004A78B6532AD2E2009A5866936B7222000A7966D28A12B3111AD90623BAB39310BA39A6803083O007045E4DF2C64E87103063O0053657441504C026O0070400045023O00CB000100033O0012C5000300014O003100045O00122O000500023O00122O000600036O0004000600024O0003000300040012C5000400043O0012C5000500054O003100065O00122O000700063O00122O000800076O0006000800024O0006000400062O003100075O00122O000800083O00122O000900096O0007000900024O0007000600072O003100085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600082O003100095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600092O0031000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A2O0031000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B2O0031000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C2O0031000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D2O0031000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E0012C5000F00044O003100105O00122O001100183O00122O001200196O0010001200024O0010000F00102O003100115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00112O003100125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00122O003100135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00132O003100145O00122O001500203O00122O001600216O0014001600024O0014000F00142O003100155O00122O001600223O00122O001700236O0015001700024O0014001400152O003100155O00122O001600243O00122O001700256O0015001700024O0014001400152O003100155O00122O001600263O00122O001700276O0015001700024O0015000F00152O003100165O00122O001700283O00122O001800296O0016001800024O0015001500162O003100165O00122O0017002A3O00122O0018002B6O0016001800024O0015001500160012C50016002C4O003100175O00122O0018002D3O00122O0019002E6O0017001900024O0016001600172O00FA001700586O00598O005A8O005B8O005C8O005D5O00122O005E002F3O00122O005F002F6O00606O00DE00615O00122O006100303O00122O006100306O006200033O00122O006300323O00122O006400333O00122O006500346O0062000300010010020061003100622O00DE00615O00122O006100353O00122O006100356O006200033O00122O006300363O00122O006400373O00122O006500386O0062000300010010020061003100622O00DE00615O00122O006100393O00122O006100396O006200033O00122O0063003B3O00122O0064003C3O00122O0065003D6O0062000300010010020061003A00620012F0006100396O006200043O00122O0063003B3O00122O0064003F3O00122O006500403O00122O006600416O0062000400010010020061003E0062001286006100396O006200033O00122O0063003B3O00122O006400433O00122O006500446O0062000300010010020061004200620012F0006100396O006200043O00122O006300463O00122O006400473O00122O006500483O00122O006600496O006200040001001002006100450062001286006100396O006200033O00122O0063004B3O00122O0064004C3O00122O0065004D6O0062000300010010020061004A0062001286006100396O006200033O00122O0063004F3O00122O006400483O00122O006500506O0062000300010010020061004E00620012F0006100396O006200043O00122O0063003B3O00122O006400523O00122O006500433O00122O006600536O0062000400010010020061005100620012F0006100396O006200043O00122O006300553O00122O006400563O00122O006500573O00122O006600586O0062000400010010020061005400622O00D500615O00122O006200593O00122O0063005A6O0061006300024O0061000C00614O00625O00122O0063005B3O00122O0064005C6O0062006400024O0061006100624O00625O00122O0063005D3O00122O0064005E6O0062006400024O0062000D00624O00635O00122O0064005F3O00122O006500606O0063006500024O0062006200634O00635O00122O006400613O00122O006500626O0063006500024O0063001300634O00645O00122O006500633O00122O006600646O0064006600024O0063006300644O00648O006500766O00775O00122O007800653O00122O007900666O0077007900024O0077000F00774O00785O00122O007900673O00122O007A00686O0078007A00024O0077007700780006E500783O000100042O00D93O00614O009F8O00D93O00774O00D93O000E3O0020600079000400690006E5007B0001000100012O00D93O00784O00AD007C5O00122O007D006A3O00122O007E006B6O007C007E6O00793O00010006E500790002000100012O00D93O00613O00020F007A00033O0006E5007B0004000100062O00D93O00614O009F8O00D93O005B4O00D93O00774O00D93O00124O00D93O00633O0006E5007C00050001000F2O00D93O00624O009F8O00D93O002A4O00D93O00074O00D93O002B4O00D93O00124O00D93O00634O00D93O00184O00D93O001A4O00D93O00194O00D93O00614O00D93O00284O00D93O00294O00D93O00264O00D93O00273O0006E5007D0006000100032O00D93O00774O00D93O00644O00D93O005A3O0006E5007E0007000100092O00D93O005E4O00D93O001E4O00D93O00614O009F8O00D93O001D4O00D93O00074O00D93O00124O00D93O00634O00D93O001C3O0006E5007F00080001000C2O00D93O00744O00D93O00094O00D93O00374O00D93O00074O00D93O00614O00D93O00124O00D93O00634O009F8O00D93O00774O00D93O00384O00D93O00394O00D93O00083O0006E500800009000100132O00D93O00614O009F8O00D93O003A4O00D93O00774O00D93O003B4O00D93O003C4O00D93O00074O00D93O00124O00D93O00634O00D93O006C4O00D93O003F4O00D93O00094O00D93O003D4O00D93O003E4O00D93O00404O00D93O00414O00D93O00424O00D93O00434O00D93O00443O0006E50081000A0001002A2O00D93O00614O009F8O00D93O005A4O00D93O00074O00D93O00774O00D93O00554O00D93O00564O00D93O00124O00D93O00764O00D93O00084O00D93O00334O00D93O00344O00D93O00354O00D93O00634O00D93O00094O00D93O00754O00D93O00364O00D93O00504O00D93O004A4O00D93O006D4O00D93O004F4O00D93O003A4O00D93O003B4O00D93O003C4O00D93O006C4O00D93O00404O00D93O00414O00D93O00454O00D93O00464O00D93O00474O00D93O00384O00D93O00394O00D93O00494O00D93O004B4O00D93O004C4O00D93O004D4O00D93O004E4O00D93O00744O00D93O00594O00D93O00374O00D93O007F4O00D93O00483O0006E50082000B000100152O00D93O00614O009F8O00D93O00124O00D93O00084O00D93O00074O00D93O005A4O00D93O007D4O00D93O005B4O00D93O00204O00D93O00774O00D93O00744O00D93O00384O00D93O00394O00D93O00574O00D93O00584O00D93O007F4O00D93O00764O00D93O00634O00D93O00754O00D93O00174O00D93O007E3O0006E50083000C0001000B2O00D93O00094O00D93O001F4O00D93O007B4O00D93O005A4O00D93O00804O00D93O00814O00D93O00774O00D93O00824O00D93O00074O00D93O007E4O00D93O007C3O0006E50084000D0001000E2O00D93O00074O00D93O007E4O00D93O00084O00D93O00774O00D93O00124O00D93O00614O009F8O00D93O001B4O00D93O00634O00D93O00094O00D93O001F4O00D93O007B4O00D93O00594O00D93O00813O0006E50085000E000100082O00D93O00094O00D93O00614O00D93O00514O00D93O00074O009F8O00D93O00124O00D93O00634O00D93O00773O0006E50086000F0001000A2O00D93O00614O009F8O00D93O00074O00D93O00124O00D93O00634O00D93O006C4O00D93O00094O00D93O005F4O00D93O006E4O00D93O00773O0006E5008700100001000B2O00D93O00094O00D93O00614O009F8O00D93O00124O00D93O00634O00D93O006C4O00D93O006E4O00D93O00074O00D93O00774O00D93O005F4O00D93O00823O0006E5008800110001000B2O00D93O00614O009F8O00D93O00074O00D93O00124O00D93O00634O00D93O006C4O00D93O00094O00D93O00824O00D93O005F4O00D93O006E4O00D93O00773O0006E5008900120001001D2O00D93O001F4O009F8O00D93O00204O00D93O00214O00D93O00224O00D93O00274O00D93O00284O00D93O00294O00D93O002A4O00D93O002F4O00D93O00304O00D93O00314O00D93O00324O00D93O002B4O00D93O002C4O00D93O002D4O00D93O002E4O00D93O001B4O00D93O001C4O00D93O001D4O00D93O001E4O00D93O00254O00D93O00264O00D93O00234O00D93O00244O00D93O00174O00D93O00184O00D93O00194O00D93O001A3O0006E5008A0013000100272O00D93O00374O009F8O00D93O00384O00D93O00394O00D93O003A4O00D93O00454O00D93O00464O00D93O00354O00D93O00364O00D93O00534O00D93O00544O00D93O00554O00D93O00564O00D93O00474O00D93O00484O00D93O00494O00D93O004A4O00D93O00574O00D93O00584O00D93O004B4O00D93O004C4O00D93O004D4O00D93O004E4O00D93O004F4O00D93O00504O00D93O00514O00D93O00524O00D93O003F4O00D93O00404O00D93O00414O00D93O00424O00D93O00334O00D93O00344O00D93O00434O00D93O00444O00D93O003B4O00D93O003C4O00D93O003D4O00D93O003E3O0006E5008B0014000100242O00D93O006D4O00D93O00074O00D93O00614O00D93O00854O00D93O00864O00D93O00834O00D93O00874O00D93O00884O00D93O00594O00D93O00844O00D93O00824O00D93O00524O00D93O00604O00D93O005C4O009F3O00014O009F8O00D93O00044O009F3O00024O00D93O00534O00D93O00894O00D93O008A4O00D93O005A4O00D93O005B4O00D93O00774O00D93O005F4O00D93O005D4O00D93O00754O00D93O00764O00D93O00674O00D93O00664O00D93O00694O00D93O00684O00D93O00744O00D93O006C4O00D93O005E4O00D93O001F3O0006E5008C0015000100032O009F8O00D93O00784O00D93O000F3O002035008D000F006C00122O008E006D6O008F008B6O0090008C6O008D009000016O00013O00163O000E3O00030E3O00383DA22A41212C1500A72A47313003073O00497150D2582E57030B3O004973417661696C61626C65025O00D88440025O00C0514003123O00A525DE02E28D20CC10EB8408C810F2872ADE03053O0087E14CAD72030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303123O003EE4ABA0A9B1AB1BEFB4B588B8A50FEBBEA303073O00C77A8DD8D0CCDD03173O0089D403E07DFAA1DC12FC7DDBACDA19F35CF3AFC816F66B03063O0096CDBD70901800274O009F8O0082000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000C000100010004F33O000C0001002E160104001A000100050004F33O001A00012O009F3O00024O0020000100013O00122O000200063O00122O000300076O0001000300024O000200033O00202O0002000200084O000300023O00202O0003000300094O000400023O00202O00040004000A4O0002000400026O0001000200044O002600012O009F3O00024O0044000100013O00122O0002000B3O00122O0003000C6O0001000300024O000200026O000300013O00122O0004000D3O00122O0005000E6O0003000500024O0002000200036O000100022O0003012O00019O003O00034O009F8O00033O000100012O0003012O00017O00043O0003113O00446562752O665265667265736861626C65030E3O00536861646F77576F72645061696E03093O0054696D65546F446965026O002840010E3O00208C00013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004F33O000C000100206000013O00032O00E4000100020002000E570004000B000100010004F33O000B00012O00AB00016O00D6000100014O00132O0100024O0003012O00019O003O00034O00D68O0013012O00024O0003012O00017O000B3O0003063O00E40A15DAB06503073O00E6B47F67B3D61C03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974025O0082B140025O00D2A540025O00888140025O00A7B140030B3O00507572696679466F637573030D3O009C104D4FE258A0880C4C56E14D03073O0080EC653F26842100224O00CA9O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004F33O001200012O009F3O00023O0006623O001200013O0004F33O001200012O009F3O00033O00201C5O00042O00E93O000100020006723O0014000100010004F33O00140001002E1601050021000100060004F33O00210001002E1601070021000100080004F33O002100012O009F3O00044O009F000100053O00201C0001000100092O00E43O000200020006623O002100013O0004F33O002100012O009F3O00013O0012A00001000A3O0012A00002000B4O001D3O00024O001E017O0003012O00017O00203O00028O00026O00F03F030B3O0096F7C0CE2EC6A16AB1FCC403083O001EDE92A1A25AAED203073O004973526561647903103O004865616C746850657263656E74616765025O00288540025O00689640030B3O004865616C746873746F6E6503173O00ED4B7106F146631EEA40754AE14B760FEB5D791CE00E2303043O006A852E1003193O006A2575EE5F5350297DFB1A685D217FF5544718107CE8534F5603063O00203840139C3A03173O0068CDE3445FE18853C6E27E5FF38C53C6E26655E68955C603073O00E03AA885363A9203173O0052656672657368696E674865616C696E67506F74696F6E03253O004B534DEF70958F0257510BF570878B0257510BED7A928E0457164FF87383891850404EBD2103083O006B39362B9D15E6E7025O0016A640025O00F8A34003043O008AA8154103073O00AFCCC97124D68B03043O0046616465030E3O0041CD31D94443C933D90A54C523D903053O006427AC55BC030F3O00897DAA9036BF79AD8503BF79A0852103053O0053CD18D9E0025O0044A840025O0044B340030F3O00446573706572617465507261796572031A3O00E2C0DE2DE3D7CC29E3FADD2FE7DCC82FA6C1C83BE3CBDE34F0C003043O005D86A5AD00B43O0012A03O00014O00BE000100023O002620012O0007000100010004F33O000700010012A0000100014O00BE000200023O0012A03O00023O000E240102000200013O0004F33O000200010026202O010009000100010004F33O000900010012A0000200013O00262001020059000100020004F33O005900012O009F00036O00FC000400013O00122O000500033O00122O000600046O0004000600024O00030003000400202O0003000300054O00030002000200062O0003002100013O0004F33O002100012O009F000300023O0006620003002100013O0004F33O002100012O009F000300033O0020600003000300062O00E40003000200022O009F000400043O00063800030003000100040004F33O00230001002E500007000F000100080004F33O003000012O009F000300054O003C000400063O00202O0004000400094O000500066O000700016O00030007000200062O0003003000013O0004F33O003000012O009F000300013O0012A00004000A3O0012A00005000B4O001D000300054O001E01036O009F000300073O000662000300B300013O0004F33O00B300012O009F000300033O0020600003000300062O00E40003000200022O009F000400083O0006A1000300B3000100040004F33O00B300012O009F000300094O00E7000400013O00122O0005000C3O00122O0006000D6O00040006000200062O00030041000100040004F33O004100010004F33O00B300012O009F00036O00FC000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300B300013O0004F33O00B300012O009F000300054O003C000400063O00202O0004000400104O000500066O000700016O00030007000200062O000300B300013O0004F33O00B300012O009F000300013O00123A000400113O00122O000500126O000300056O00035O00044O00B30001002E50001300B3FF2O00130004F33O000C00010026200102000C000100010004F33O000C00010012A0000300014O00BE000400043O002E5000143O000100140004F33O005F00010026200103005F000100010004F33O005F00010012A0000400013O002620010400A7000100010004F33O00A700012O009F0005000A4O00FC000600013O00122O000700153O00122O000800166O0006000800024O00050005000600202O0005000500054O00050002000200062O0005008600013O0004F33O008600012O009F0005000B3O0006620005008600013O0004F33O008600012O009F000500033O0020600005000500062O00E40005000200022O009F0006000C3O0006A100050086000100060004F33O008600012O009F000500054O003C0006000A3O00202O0006000600174O000700086O000900016O00050009000200062O0005008600013O0004F33O008600012O009F000500013O0012A0000600183O0012A0000700194O001D000500074O001E01056O009F0005000A4O00FC000600013O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O0005000500054O00050002000200062O0005009900013O0004F33O009900012O009F0005000D3O0006620005009900013O0004F33O009900012O009F000500033O0020600005000500062O00E40005000200022O009F0006000E3O00063800050003000100060004F33O009B0001002ED0001D00A60001001C0004F33O00A600012O009F000500054O009F0006000A3O00201C00060006001E2O00E4000500020002000662000500A600013O0004F33O00A600012O009F000500013O0012A00006001F3O0012A0000700204O001D000500074O001E01055O0012A0000400023O00262001040064000100020004F33O006400010012A0000200023O0004F33O000C00010004F33O006400010004F33O000C00010004F33O005F00010004F33O000C00010004F33O00B300010004F33O000900010004F33O00B300010004F33O000200012O0003012O00017O00103O00028O00025O00049340025O00707F40025O00907B40025O0007B340025O004EAD40025O00D88640026O00F03F025O00A6A340025O00309C40030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574026O004440025O0080A740025O00109E4003133O0048616E646C65426F2O746F6D5472696E6B6574003B3O0012A03O00013O0026A93O0005000100010004F33O00050001002ED000020027000100030004F33O002700010012A0000100014O00BE000200023O0026A90001000B000100010004F33O000B0001002ED000050007000100040004F33O000700010012A0000200013O002E1601070012000100060004F33O0012000100262001020012000100080004F33O001200010012A03O00083O0004F33O00270001000E2800010016000100020004F33O00160001002E160109000C0001000A0004F33O000C00012O009F00035O00206B00030003000C4O000400016O000500023O00122O0006000D6O000700076O00030007000200122O0003000B3O00122O0003000B3O00062O0003002300013O0004F33O002300010012C50003000B4O0013010300023O0012A0000200083O0004F33O000C00010004F33O002700010004F33O00070001002E16010F00010001000E0004F33O00010001002620012O0001000100080004F33O000100012O009F00015O00206B0001000100104O000200016O000300023O00122O0004000D6O000500056O00010005000200122O0001000B3O00122O0001000B3O00062O0001003A00013O0004F33O003A00010012C50001000B4O00132O0100023O0004F33O003A00010004F33O000100012O0003012O00017O001B3O00025O0070724003073O0047657454696D65028O00026O00F03F025O00DCB240025O00F49A40030B3O00F98415ECB8D2CBE88404F903073O00AFBBEB7195D9BC030B3O004973417661696C61626C65030F3O000CA09649F14E772EABB244EA7C743803073O00185CCFE12C831903073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O66025O0069B040025O00CCA04003153O00506F776572576F7264536869656C64506C61796572031D3O005BDCAF4909425CDCAA48246E43DABD401F425BDFB9551E6F0BDEB75A1E03063O001D2BB3D82C7B030E3O009CD72749B1D0236AB8D83444B8CB03043O002CDDB94003143O00416E67656C696346656174686572506C61796572031B4O00E94F5A7F08E477597600F3405A613EF7445E6A04F508527C17E203053O00136187283F025O0008A840025O003AB24000813O002E5000010080000100010004F33O008000010012C53O00024O001C012O000100024O00019O003O00014O000100013O00062O0001008000013O0004F33O008000010012A03O00034O00BE000100023O002620012O0078000100040004F33O007800010026202O01000D000100030004F33O000D00010012A0000200033O002ED000060010000100050004F33O0010000100262001020010000100030004F33O001000012O009F000300024O00FC000400033O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003003900013O0004F33O003900012O009F000300024O00FC000400033O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003003900013O0004F33O003900012O009F000300043O0006620003003900013O0004F33O003900012O009F000300053O00208C00030003000D4O000500023O00202O00050005000E4O00030005000200062O0003003900013O0004F33O003900012O009F000300053O00205A00030003000D4O000500023O00202O00050005000F4O00030005000200062O0003003B000100010004F33O003B0001002E1601100046000100110004F33O004600012O009F000300064O009F000400073O00201C0004000400122O00E40003000200020006620003004600013O0004F33O004600012O009F000300033O0012A0000400133O0012A0000500144O001D000300054O001E01036O009F000300024O00FC000400033O00122O000500153O00122O000600166O0004000600024O00030003000400202O00030003000C4O00030002000200062O0003008000013O0004F33O008000012O009F000300083O0006620003008000013O0004F33O008000012O009F000300053O00208C00030003000D4O000500023O00202O00050005000E4O00030005000200062O0003008000013O0004F33O008000012O009F000300053O00208C00030003000D4O000500023O00202O00050005000F4O00030005000200062O0003008000013O0004F33O008000012O009F000300053O00208C00030003000D4O000500023O00202O00050005000E4O00030005000200062O0003008000013O0004F33O008000012O009F000300064O009F000400073O00201C0004000400172O00E40003000200020006620003008000013O0004F33O008000012O009F000300033O00123A000400183O00122O000500196O000300056O00035O00044O008000010004F33O001000010004F33O008000010004F33O000D00010004F33O008000010026A93O007C000100030004F33O007C0001002ED0001B000B0001001A0004F33O000B00010012A0000100034O00BE000200023O0012A03O00043O0004F33O000B00012O0003012O00017O00183O0003073O0049735265616479025O00AC9F40025O00ACA740028O00025O005AA940025O00DCAB4003103O004865616C746850657263656E7461676503063O0042752O66557003123O00536861646F77436F76656E616E7442752O6603123O004461726B52657072696D616E64466F637573031C3O00AA5D21301023AB4C21322230A0580C3D2032BB4F732B2A3FAF52303E03063O0051CE3C535B4F030C3O0050656E616E6365466F637573025O0086A440025O00D0774003153O005EAEDE7321C0489B48A4D3673C835DA140AADE712A03083O00C42ECBB0124FA32D032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66025O00B07140025O00C0B140030E3O0049735370652O6C496E52616E6765030F3O00A827701F2AF8EAF8327B1025F5ECBD03073O008FD8421E7E449B015C4O009F00015O0020600001000100012O00E400010002000200067200010007000100010004F33O00070001002ED00003005B000100020004F33O005B00010012A0000100044O00BE000200023O0026202O010009000100040004F33O000900010012A0000200043O0026200102000C000100040004F33O000C0001002ED000050039000100060004F33O003900012O009F000300013O0006620003003900013O0004F33O003900012O009F000300013O0020600003000300072O00E40003000200022O009F000400023O0006A100030039000100040004F33O003900012O009F000300033O00208C0003000300084O000500043O00202O0005000500094O00030005000200062O0003002C00013O0004F33O002C00012O009F000300054O009F000400063O00201C00040004000A2O00E40003000200020006620003003900013O0004F33O003900012O009F000300073O00123A0004000B3O00122O0005000C6O000300056O00035O00044O003900012O009F000300054O009F000400063O00201C00040004000D2O00E400030002000200067200030034000100010004F33O00340001002ED0000E00390001000F0004F33O003900012O009F000300073O0012A0000400103O0012A0000500114O001D000300054O001E01035O0006723O005B000100010004F33O005B00012O009F000300083O0020F60003000300124O000400043O00202O0004000400134O000500096O00068O00078O0003000700024O0004000A3O00062O0003005B000100040004F33O005B0001002E160114005B000100150004F33O005B00012O009F000300054O009900048O0005000B3O00202O0005000500164O00078O0005000700024O000500056O00030005000200062O0003005B00013O0004F33O005B00012O009F000300073O00123A000400173O00122O000500186O000300056O00035O00044O005B00010004F33O000C00010004F33O005B00010004F33O000900012O0003012O00017O004E3O00028O00025O00508340025O00D8AD40026O00F03F025O00BFB040026O005F40025O0012A440025O009CAE40025O00A4A840025O00B89F4003113O009AC71ACED794D8F3AEFA0CCFCCA2D9E2AF03083O0081CAA86DABA5C3B703073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503063O0042752O66557003153O0052616469616E7450726F766964656E636542752O6603163O00506F776572576F726452616469616E6365466F63757303293O00325720DDCC2BF12D4A33E7CC15E22B59392ODB2BEF2C4B23D9D000A62A5D36D4E117E92D5433D7C91A03073O0086423857B8BE7403063O001D3F10B417EE03083O00555C5169DB798B41025O0062AD40025O00508540030F3O00CDB2594B4FCAEDA342406FCCF4BC5E03063O00BF9DD330251C03083O0042752O66446F776E030F3O005061696E53752O7072652O73696F6E03103O004865616C746850657263656E74616765025O002OA040025O00208A4003143O005061696E53752O7072652O73696F6E466F637573031E3O00CF1EFD1205CC0AE40C28DA0CE71535D15FFC193BD320F71335D31BFB0B3403053O005ABF7F947C03093O004C86201C38A8201B6103043O007718E74E025O0072A240025O009C9040030F3O00B22CAC44EF5501923FA059CF491E8C03073O0071E24DC52ABC2003073O00436F2O6D6F6E73030D3O00556E697447726F7570526F6C6503043O000E37DA9E03043O00D55A7694025O00F89B40025O002AA940031E3O004B2FBD5872483BA4465F5E3DA75F42556EBC534C5711B75942572ABB414303053O002D3B4ED436025O006BB140025O0016AE40030D3O0024578D80C62FA3F4506586878003083O00907036E3EBE64ECD030F3O00832906F2E34EA3381DF9C348BA270103063O003BD3486F9CB003043O007AA6CD0603043O004D2EE78303063O009271976C9F6603043O0020DA34D6025O0032A740025O00109D40025O0096A040025O00804340031E3O005E1638A6CEA3504A5E0534BBE2B94A540E1F34A9FD8F4655411B35A7E6BE03083O003A2E7751C891D025030D3O001B8327A9BB8A2O39881CA5AFB803073O00564BEC50CCC9DD03063O0045786973747303123O00506F776572576F72644C696665466F637573031D3O00624E6080ECB4654E6581C1877B4772C5F68E734D4886F1847E457892F003063O00EB122117E59E030F3O007CAFCCB25EB5D4A872BBD3A959BFD303043O00DB30DAA1025O00A8A040025O00206940030F3O004C756D696E6F757342612O72696572025O00F2B040025O007DB140031E3O00E8647140D540F5F74E7E48C95DE9E1633C41DE4EECDB727346D74BEFF37F03073O008084111C29BB2F0055012O0012A03O00014O00BE000100023O002E160102004E2O0100030004F33O004E2O01002620012O004E2O0100040004F33O004E2O01002ED000060006000100050004F33O000600010026202O010006000100010004F33O000600010012A0000200013O002ED00007003O0100080004F33O003O01000E242O01003O0100020004F33O003O010012A0000300014O00BE000400043O0026A900030015000100010004F33O00150001002ED0000900110001000A0004F33O001100010012A0000400013O000E242O0100FA000100040004F33O00FA00012O009F00056O00FC000600013O00122O0007000B3O00122O0008000C6O0006000800024O00050005000600202O00050005000D4O00050002000200062O0005004000013O0004F33O004000012O009F000500023O0006620005004000013O0004F33O004000012O009F000500033O00203300050005000E4O000600046O000700056O00050007000200062O0005004000013O0004F33O004000012O009F000500063O00208C00050005000F4O00075O00202O0007000700104O00050007000200062O0005004000013O0004F33O004000012O009F000500074O008D000600083O00202O0006000600114O000700076O000800096O00050008000200062O0005004000013O0004F33O004000012O009F000500013O0012A0000600123O0012A0000700134O001D000500074O001E01056O009F0005000A4O00E7000600013O00122O000700143O00122O000800156O00060008000200062O00050049000100060004F33O00490001002ED000160073000100170004F33O007300012O009F00056O00FC000600013O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500F900013O0004F33O00F900012O009F0005000B3O00208C00050005001A4O00075O00202O00070007001B4O00050007000200062O000500F900013O0004F33O00F900012O009F0005000C3O000662000500F900013O0004F33O00F900012O009F0005000B3O00206000050005001C2O00E40005000200022O009F0006000D3O0006A1000500F9000100060004F33O00F90001002E16011E00F90001001D0004F33O00F900012O009F000500074O003C000600083O00202O00060006001F4O000700086O000900016O00050009000200062O000500F900013O0004F33O00F900012O009F000500013O00123A000600203O00122O000700216O000500076O00055O00044O00F900012O009F0005000A4O00E7000600013O00122O000700223O00122O000800236O00060008000200062O0005007C000100060004F33O007C0001002ED0002400B0000100250004F33O00B000012O009F00056O00FC000600013O00122O000700263O00122O000800276O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500F900013O0004F33O00F900012O009F0005000B3O00208C00050005001A4O00075O00202O00070007001B4O00050007000200062O000500F900013O0004F33O00F900012O009F0005000C3O000662000500F900013O0004F33O00F900012O009F0005000B3O00206000050005001C2O00E40005000200022O009F0006000D3O0006A1000500F9000100060004F33O00F900010012C5000500283O00200A0105000500294O0006000B6O0005000200024O000600013O00122O0007002A3O00122O0008002B6O00060008000200062O000500F9000100060004F33O00F900012O009F000500074O00BD000600083O00202O00060006001F4O000700086O000900016O00050009000200062O000500AA000100010004F33O00AA0001002ED0002D00F90001002C0004F33O00F900012O009F000500013O00123A0006002E3O00122O0007002F6O000500076O00055O00044O00F90001002ED0003100BA000100300004F33O00BA00012O009F0005000A4O00E7000600013O00122O000700323O00122O000800336O00060008000200062O000500BA000100060004F33O00BA00010004F33O00F900012O009F00056O00FC000600013O00122O000700343O00122O000800356O0006000800024O00050005000600202O00050005000D4O00050002000200062O000500E800013O0004F33O00E800012O009F0005000B3O00208C00050005001A4O00075O00202O00070007001B4O00050007000200062O000500E800013O0004F33O00E800012O009F0005000C3O000662000500E800013O0004F33O00E800012O009F0005000B3O00206000050005001C2O00E40005000200022O009F0006000D3O0006A1000500E8000100060004F33O00E800010012C5000500283O0020550005000500294O0006000B6O0005000200024O000600013O00122O000700363O00122O000800376O00060008000200062O000500EA000100060004F33O00EA00010012C5000500283O0020550005000500294O0006000B6O0005000200024O000600013O00122O000700383O00122O000800396O00060008000200062O000500EA000100060004F33O00EA0001002ED0003A00F90001003B0004F33O00F900012O009F000500074O00BD000600083O00202O00060006001F4O000700086O000900016O00050009000200062O000500F4000100010004F33O00F40001002E50003C00070001003D0004F33O00F900012O009F000500013O0012A00006003E3O0012A00007003F4O001D000500074O001E01055O0012A0000400043O00262001040016000100040004F33O001600010012A0000200043O0004F33O003O010004F33O001600010004F33O003O010004F33O001100010026200102000B000100040004F33O000B00012O009F00036O00FC000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300262O013O0004F33O00262O012O009F0003000E3O000662000300262O013O0004F33O00262O012O009F0003000B3O00206000030003001C2O00E40003000200022O009F0004000F3O0006A1000300262O0100040004F33O00262O012O009F0003000B3O0020600003000300422O00E4000300020002000662000300262O013O0004F33O00262O012O009F000300074O009F000400083O00201C0004000400432O00E4000300020002000662000300262O013O0004F33O00262O012O009F000300013O0012A0000400443O0012A0000500454O001D000300054O001E01036O009F00036O00FC000400013O00122O000500463O00122O000600476O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003003A2O013O0004F33O003A2O012O009F000300103O0006620003003A2O013O0004F33O003A2O012O009F000300033O00209000030003000E4O000400116O000500126O00030005000200062O0003003C2O0100010004F33O003C2O01002ED0004800542O0100490004F33O00542O012O009F000300074O009F00045O00201C00040004004A2O00E4000300020002000672000300442O0100010004F33O00442O01002ED0004C00542O01004B0004F33O00542O012O009F000300013O00123A0004004D3O00122O0005004E6O000300056O00035O00044O00542O010004F33O000B00010004F33O00542O010004F33O000600010004F33O00542O01002620012O0002000100010004F33O000200010012A0000100014O00BE000200023O0012A03O00043O0004F33O000200012O0003012O00017O00943O00028O00025O00109B40025O00B2AB40025O00949140026O005040026O00F03F025O001EA940025O004AAF40025O00DEA240025O00C8844003113O00C2FF28DBFAF228D7C7F632DBE3F632D1F203043O00B297935C03073O0049735265616479030F3O00412O66656374696E67436F6D626174032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O6603113O00556C74696D61746550656E6974656E6365025O00049140025O003AA14003173O0099F1583B1F4D6E89C25C371C456E89F34F3752447F8DF103073O001AEC9D2C52722C027O0040030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030A3O0048616C6F506C61796572025O00C4A040025O00A0834003093O00FC70F9A2652582F57D03073O00E7941195CD454D03133O004973466163696E67426C61636B6C6973746564025O00AEAA40025O0061B14003103O00446976696E6553746172506C61796572025O00949B40025O00D6B04003103O0084AED1F259FABFB4D3FA45BF88A2C6F703063O009FE0C7A79B37025O00508C40026O006940026O000840026O00A840025O00AAA040030F3O00D8024EFBC9D58D3CEC3E51F7DEEE8603083O004E886D399EBB82E2030D3O00556E697447726F7570526F6C6503043O000A1ED7DA03043O00915E5F9903103O004865616C746850657263656E7461676503083O0042752O66446F776E030F3O00506F776572576F7264536869656C6403063O00457869737473025O00408C40025O00E0954003143O00506F776572576F7264536869656C64466F637573031B3O00EDC203D05C88EAC206D171A4F5C411D94A88E9CC1ADE0EBFF8CC1803063O00D79DAD74B52E03093O0013B88AE1D21DB18AFE03053O00BA55D4EB92030C3O00E08818FA30E05FEA8417F22A03073O0038A2E1769E598E030B3O004973417661696C61626C6503043O0047554944030E3O00466C6173684865616C466F637573025O00708640025O002EAE40030F3O005A09C1BC2AE75400C1A362D05904CC03063O00B83C65A0CF42025O0066A340025O005EA140030F3O00018D6BB923B573AE35B174B5348E7803043O00DC51E21C03163O0003DA95FE2OF804DA90FFD5D41BDC87F7EE871BD083F703063O00A773B5E29B8A026O001040025O00F49540025O00E8894003113O00313D113F4F363D143E6F00360F3B53023703053O003D6152665A03063O0042752O66557003153O0052616469616E7450726F766964656E636542752O66025O001AAA4003163O00506F776572576F726452616469616E6365466F63757303293O00BC21BC4ED5680906BE2A9459C6531708A22DAE74CE590D1DAD20BF0BCF521F05932DA444CB53111EA203083O0069CC4ECB2BA7377E026O00AE40025O00408F40030D3O0095A5341B0133C843A1862A181603083O0031C5CA437E7364A703123O00506F776572576F72644C696665466F637573025O00C8A440025O00D09D40031D3O002754C82C9269493849DB168C5F58321BD72C815A613454D0258459493903073O003E573BBF49E03603113O00D70DEDCCF535F5DBE330FBCDEE03F4CAE203043O00A987629A025O00E0A140025O009EA340025O0010AC40025O0039B140031A3O00DB783351EF0CDFC465206BEF32CCC2762A57F8739A8B7F2155F103073O00A8AB1744349D53030A3O000F38D4552D2BD952392303043O003B4A4EB503273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403083O004973496E5261696403093O004973496E5061727479025O00E9B240025O005EA740030A3O004576616E67656C69736D025O005EA640025O00D8A340030F3O0020C75B54B420DD5349BE65D95F5BBF03053O00D345B12O3A025O00E2A740025O00D6B24003093O0091E978E6E1E3B2E47503063O00ABD78519958903053O0052656E6577030C3O0053757267656F664C69676874025O0050B240025O0044974003173O00E7C433E9E70FF447E0C40DF3E123E843EFDC72F2EA31F003083O002281A8529A8F509C03073O00B7B3231F5D5C8C03073O00E9E5D2536B282E03323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74026O008A40025O00A2B240030C3O0052617074757265466F637573030C3O00D34322C210D34772DE00C04E03053O0065A12252B603053O00D027E9596C03073O00A68242873C1B11025O00389E40030A3O0052656E6577466F637573030A3O00564FC070270442CB743C03053O0050242AAE15030C3O0053686F756C6452657475726E025O00ACB140025O0074A440025O0046B040025O0049B04003093O00681C36694638327B4203043O001A2E705703133O00BF2FAA67B7804DB1B82F947BB0BC052OBC22A703083O00D4D943CB142ODF250052032O0012A03O00014O00BE000100013O0026A93O0006000100010004F33O00060001002ED000030002000100020004F33O000200010012A0000100013O002ED000050096000100040004F33O009600010026202O010096000100060004F33O009600010012A0000200013O0026A900020010000100060004F33O00100001002E160108003E000100070004F33O003E0001002E16010A003C000100090004F33O003C00012O009F00036O00FC000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003003C00013O0004F33O003C00012O009F000300023O0006620003003C00013O0004F33O003C00012O009F000300033O00206000030003000E2O00E40003000200020006620003003C00013O0004F33O003C00012O009F000300043O0020F600030003000F4O00045O00202O0004000400104O000500056O00068O00078O0003000700024O000400063O00062O0004003C000100030004F33O003C00012O009F000300074O009F00045O00201C0004000400112O00E400030002000200067200030037000100010004F33O00370001002E160113003C000100120004F33O003C00012O009F000300013O0012A0000400143O0012A0000500154O001D000300054O001E01035O0012A0000100163O0004F33O009600010026200102000C000100010004F33O000C00012O009F000300083O00206000030003000D2O00E40003000200020006620003006D00013O0004F33O006D00012O009F000300043O00201C0003000300172O00E90003000100020006620003006D00013O0004F33O006D00012O009F000300093O0020600003000300180012A0000500194O00EA0003000500020006620003006D00013O0004F33O006D00012O009F0003000A3O0006620003006D00013O0004F33O006D00012O009F000300043O00203300030003001A4O0004000B6O0005000C6O00030005000200062O0003006D00013O0004F33O006D00012O009F000300074O005B0004000D3O00202O00040004001B4O0005000E3O00202O00050005001800122O000700196O0005000700024O000500056O000600016O00030006000200062O00030068000100010004F33O00680001002ED0001C006D0001001D0004F33O006D00012O009F000300013O0012A00004001E3O0012A00005001F4O001D000300054O001E01036O009F0003000F3O00206000030003000D2O00E40003000200020006620003008500013O0004F33O008500012O009F000300043O00201C0003000300172O00E90003000100020006620003008500013O0004F33O008500012O009F000300093O0020600003000300180012A0000500194O00EA0003000500020006620003008500013O0004F33O008500012O009F000300103O0006620003008500013O0004F33O008500012O009F0003000E3O0020600003000300202O00E40003000200020006620003008700013O0004F33O00870001002ED000220094000100210004F33O009400012O009F000300074O009F0004000D3O00201C0004000400232O00E40003000200020006720003008F000100010004F33O008F0001002E1601250094000100240004F33O009400012O009F000300013O0012A0000400263O0012A0000500274O001D000300054O001E01035O0012A0000200063O0004F33O000C0001002E160129004C2O0100280004F33O004C2O010026202O01004C2O01002A0004F33O004C2O010012A0000200013O0026A90002009F000100010004F33O009F0001002ED0002B001E2O01002C0004F33O001E2O012O009F00036O00FC000400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300D900013O0004F33O00D900012O009F000300043O00200A01030003002F4O0004000E6O0003000200024O000400013O00122O000500303O00122O000600316O00040006000200062O000300D9000100040004F33O00D900012O009F0003000E3O0020600003000300322O00E40003000200022O009F000400113O000639000300D9000100040004F33O00D900012O009F0003000E3O00205A0003000300334O00055O00202O0005000500104O00030005000200062O000300C7000100010004F33O00C700012O009F0003000E3O00208C0003000300334O00055O00202O0005000500344O00030005000200062O000300D900013O0004F33O00D900012O009F0003000E3O0020600003000300352O00E4000300020002000662000300D900013O0004F33O00D90001002ED0003600D9000100370004F33O00D900012O009F000300074O009F0004000D3O00201C0004000400382O00E4000300020002000662000300D900013O0004F33O00D900012O009F000300013O0012A0000400393O0012A00005003A4O001D000300054O001E01036O009F00036O00FC000400013O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003001D2O013O0004F33O001D2O012O009F00036O00FC000400013O00122O0005003D3O00122O0006003E6O0004000600024O00030003000400202O00030003003F4O00030002000200062O0003001D2O013O0004F33O001D2O012O009F0003000E3O0020660003000300404O0003000200024O000400033O00202O0004000400404O00040002000200062O0003001D2O0100040004F33O001D2O012O009F0003000E3O00208C0003000300334O00055O00202O0005000500104O00030005000200062O0003001D2O013O0004F33O001D2O012O009F000300033O00208C0003000300334O00055O00202O0005000500104O00030005000200062O0003001D2O013O0004F33O001D2O012O009F0003000E3O0020600003000300322O00E40003000200022O009F000400123O0006390003001D2O0100040004F33O001D2O012O009F0003000E3O0020600003000300352O00E40003000200020006620003001D2O013O0004F33O001D2O012O009F000300074O00690004000D3O00202O0004000400414O000500056O000600136O00030006000200062O000300182O0100010004F33O00182O01002E160143001D2O0100420004F33O001D2O012O009F000300013O0012A0000400443O0012A0000500454O001D000300054O001E01035O0012A0000200063O0026A9000200222O0100060004F33O00222O01002E500046007BFF2O00470004F33O009B00012O009F00036O00FC000400013O00122O000500483O00122O000600496O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300492O013O0004F33O00492O012O009F0003000E3O0020600003000300322O00E40003000200022O009F000400143O000639000300492O0100040004F33O00492O012O009F0003000E3O00208C0003000300334O00055O00202O0005000500104O00030005000200062O000300492O013O0004F33O00492O012O009F0003000E3O0020600003000300352O00E4000300020002000662000300492O013O0004F33O00492O012O009F000300074O009F0004000D3O00201C0004000400382O00E4000300020002000662000300492O013O0004F33O00492O012O009F000300013O0012A00004004A3O0012A00005004B4O001D000300054O001E01035O0012A00001004C3O0004F33O004C2O010004F33O009B00010026202O0100E02O0100010004F33O00E02O010012A0000200013O002620010200AA2O0100010004F33O00AA2O01002ED0004E00822O01004D0004F33O00822O012O009F00036O00FC000400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300822O013O0004F33O00822O012O009F000300153O000662000300822O013O0004F33O00822O012O009F000300043O00203300030003001A4O000400166O000500176O00030005000200062O000300822O013O0004F33O00822O012O009F000300033O00208C0003000300514O00055O00202O0005000500524O00030005000200062O000300822O013O0004F33O00822O012O009F0003000E3O0020600003000300352O00E4000300020002000662000300822O013O0004F33O00822O01002E16015300822O0100430004F33O00822O012O009F000300074O008D0004000D3O00202O0004000400544O000500056O000600186O00030006000200062O000300822O013O0004F33O00822O012O009F000300013O0012A0000400553O0012A0000500564O001D000300054O001E01035O002E16015800A92O0100570004F33O00A92O012O009F00036O00FC000400013O00122O000500593O00122O0006005A6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300A92O013O0004F33O00A92O012O009F000300193O000662000300A92O013O0004F33O00A92O012O009F0003000E3O0020600003000300322O00E40003000200022O009F0004001A3O0006A1000300A92O0100040004F33O00A92O012O009F0003000E3O0020600003000300352O00E4000300020002000662000300A92O013O0004F33O00A92O012O009F000300074O009F0004000D3O00201C00040004005B2O00E4000300020002000672000300A42O0100010004F33O00A42O01002E16015C00A92O01005D0004F33O00A92O012O009F000300013O0012A00004005E3O0012A00005005F4O001D000300054O001E01035O0012A0000200063O0026200102004F2O0100060004F33O004F2O012O009F00036O00FC000400013O00122O000500603O00122O000600616O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300CC2O013O0004F33O00CC2O012O009F000300153O000662000300CC2O013O0004F33O00CC2O012O009F000300043O00203300030003001A4O000400166O000500176O00030005000200062O000300CC2O013O0004F33O00CC2O012O009F0003000E3O00208C0003000300334O00055O00202O0005000500104O00030005000200062O000300CC2O013O0004F33O00CC2O012O009F0003000E3O0020600003000300352O00E4000300020002000672000300CE2O0100010004F33O00CE2O01002E16016300DD2O0100620004F33O00DD2O012O009F000300074O00690004000D3O00202O0004000400544O000500056O000600186O00030006000200062O000300D82O0100010004F33O00D82O01002ED0006500DD2O0100640004F33O00DD2O012O009F000300013O0012A0000400663O0012A0000500674O001D000300054O001E01035O0012A0000100063O0004F33O00E02O010004F33O004F2O01000E24011600AE020100010004F33O00AE02012O009F00026O00FC000300013O00122O000400683O00122O000500696O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002001302013O0004F33O001302012O009F000200023O0006620002001302013O0004F33O001302012O009F0002001B3O0006620002001302013O0004F33O001302012O009F000200033O00206000020002000E2O00E40002000200020006620002001302013O0004F33O001302012O009F000200043O00208100020002006A4O0003001C6O0002000200024O0003001D3O00062O00030013020100020004F33O001302012O009F000200033O00206000020002006B2O00E400020002000200067200020013020100010004F33O001302012O009F000200033O00206000020002006C2O00E40002000200020006620002001302013O0004F33O001302012O009F000200043O00202C00020002000F4O00035O00202O0003000300104O0004001E6O00058O00068O0002000600024O0003001F3O00062O00020003000100030004F33O00150201002E16016D00220201006E0004F33O002202012O009F000200074O009F00035O00201C00030003006F2O00E40002000200020006720002001D020100010004F33O001D0201002ED000700022020100710004F33O002202012O009F000200013O0012A0000300723O0012A0000400734O001D000200044O001E01025O002ED000740064020100750004F33O006402012O009F00026O00FC000300013O00122O000400763O00122O000500776O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002006402013O0004F33O006402012O009F0002000E3O00205A0002000200334O00045O00202O0004000400104O00020004000200062O00020043020100010004F33O004302012O009F0002000E3O00208C0002000200334O00045O00202O0004000400344O00020004000200062O0002006402013O0004F33O006402012O009F0002000E3O00208C0002000200334O00045O00202O0004000400784O00020004000200062O0002006402013O0004F33O006402012O009F0002000E3O0020600002000200322O00E40002000200022O009F000300203O00063900020064020100030004F33O006402012O009F000200033O00208C0002000200514O00045O00202O0004000400794O00020004000200062O0002006402013O0004F33O006402012O009F0002000E3O0020600002000200352O00E40002000200020006620002006402013O0004F33O006402012O009F000200074O00690003000D3O00202O0003000300414O000400046O000500136O00020005000200062O0002005F020100010004F33O005F0201002E16017A00640201007B0004F33O006402012O009F000200013O0012A00003007C3O0012A00004007D4O001D000200044O001E01026O009F00026O00FC000300013O00122O0004007E3O00122O0005007F6O0003000500024O00020002000300202O00020002000D4O00020002000200062O000200A002013O0004F33O00A002012O009F000200033O00206000020002006B2O00E4000200020002000672000200A0020100010004F33O00A002012O009F000200033O00206000020002006C2O00E4000200020002000662000200A002013O0004F33O00A002012O009F000200213O000662000200A002013O0004F33O00A002012O009F000200023O000662000200A002013O0004F33O00A002012O009F000200033O00206000020002000E2O00E4000200020002000662000200A002013O0004F33O00A002012O009F0002000E3O0020600002000200322O00E40002000200022O009F000300223O000639000200A0020100030004F33O00A002012O009F000200043O0020F60002000200804O00035O00202O0003000300104O0004001E6O00058O00068O0002000600024O000300233O00062O000300A0020100020004F33O00A002012O009F0002000E3O00208C0002000200334O00045O00202O0004000400104O00020004000200062O000200A002013O0004F33O00A002012O009F0002000E3O0020600002000200352O00E4000200020002000672000200A2020100010004F33O00A20201002ED0008200AD020100810004F33O00AD02012O009F000200074O009F0003000D3O00201C0003000300832O00E4000200020002000662000200AD02013O0004F33O00AD02012O009F000200013O0012A0000300843O0012A0000400854O001D000200044O001E01025O0012A00001002A3O0026202O0100070001004C0004F33O000700012O009F00026O00FC000300013O00122O000400863O00122O000500876O0003000500024O00020002000300202O00020002000D4O00020002000200062O000200E002013O0004F33O00E002012O009F0002000E3O0020600002000200322O00E40002000200022O009F000300243O000639000200E0020100030004F33O00E002012O009F0002000E3O00208C0002000200334O00045O00202O0004000400104O00020004000200062O000200E002013O0004F33O00E002012O009F0002000E3O00208C0002000200334O00045O00202O0004000400784O00020004000200062O000200E002013O0004F33O00E002012O009F0002000E3O0020600002000200352O00E4000200020002000662000200E002013O0004F33O00E00201002E500088000D000100880004F33O00E002012O009F000200074O009F0003000D3O00201C0003000300892O00E4000200020002000662000200E002013O0004F33O00E002012O009F000200013O0012A00003008A3O0012A00004008B4O001D000200044O001E01026O009F000200253O00206000020002000D2O00E40002000200020006620002001E03013O0004F33O001E03012O009F000200263O0006620002001E03013O0004F33O001E03012O009F000200033O00206000020002000E2O00E4000200020002000662000200F202013O0004F33O00F202012O009F000200043O00201C0002000200172O00E90002000100020006720002001E030100010004F33O001E03012O009F0002000E3O0020600002000200322O00E40002000200022O009F000300273O0006390002001E030100030004F33O001E03012O009F0002000E3O0020600002000200352O00E40002000200020006620002001E03013O0004F33O001E03010012A0000200014O00BE000300043O00262001020016030100060004F33O0016030100262001030001030100010004F33O000103010012A0000400013O00262001040004030100010004F33O000403012O009F000500284O0017000600016O00050002000200122O0005008C3O00122O0005008C3O00062O0005000F030100010004F33O000F0301002ED0008D001E0301008E0004F33O001E03010012C50005008C4O0013010500023O0004F33O001E03010004F33O000403010004F33O001E03010004F33O000103010004F33O001E0301000E280001001A030100020004F33O001A0301002ED0009000FF0201008F0004F33O00FF02010012A0000300014O00BE000400043O0012A0000200063O0004F33O00FF02012O009F00026O00FC000300013O00122O000400913O00122O000500926O0003000500024O00020002000300202O00020002000D4O00020002000200062O0002005103013O0004F33O005103012O009F000200263O0006620002005103013O0004F33O005103012O009F000200033O00206000020002000E2O00E40002000200020006620002003503013O0004F33O003503012O009F000200043O00201C0002000200172O00E900020001000200067200020051030100010004F33O005103012O009F0002000E3O0020600002000200322O00E40002000200022O009F000300293O00063900020051030100030004F33O005103012O009F0002000E3O0020600002000200352O00E40002000200020006620002005103013O0004F33O005103012O009F000200074O003C0003000D3O00202O0003000300414O000400046O000500016O00020005000200062O0002005103013O0004F33O005103012O009F000200013O00123A000300933O00122O000400946O000200046O00025O00044O005103010004F33O000700010004F33O005103010004F33O000200012O0003012O00017O00F73O00028O00026O00F03F025O001AAD40025O00805540026O001840025O00D6B240025O0020634003053O0029B881191F03043O006D7AD5E803073O0049735265616479025O00609C40025O00EAA14003053O00536D697465030E3O0049735370652O6C496E52616E6765025O000EA640025O001AA940030C3O00FDFAAB24EBB7A631E3F6A53503043O00508E97C2026O001C40025O005EB240025O00AAA040030F3O007544C0A7F9DF7143D3A7D2CD4758C903063O00A8262CA1C39603073O0054696D65546F58026O003440030F3O00B3F483723FFF811992F8A67331FCBE03083O0076E09CE2165088D603083O00432O6F6C646F776E026O00E03F030F3O00536861646F77576F72644465617468025O000EAA40025O0002A940031A3O0051E658844DF966974DFC5DBF46EB58944AAE0AC046EF548145EB03043O00E0228E3903083O00F6A8C9C45DFE4B0F03083O006EBEC7A5BD13913D03093O0042752O66537461636B030C3O0052686170736F647942752O6603083O00486F6C794E6F766103123O00D2E47BF1B4C9D5FD76A8DA87DEEA7AE98CC203063O00A7BA8B1788EB027O0040025O0026AA40025O00D0964003093O003F2936789E7813332C03063O00147240581CDC025O0053B240025O0013B140025O0020834003093O004D696E64426C61737403173O003C08DCB0C7D2B13012C6F4A980FD3D0EDCB3C7C3BE3E1703073O00DD5161B2D498B0030F3O00FEEF1CFF15DAD012E91EE9E21CEF1203053O007AAD877D9B03103O004865616C746850657263656E7461676503063O0042752O66557003123O00536861646F77436F76656E616E7442752O66025O00E8B240025O004AB040025O00089540031D3O0097C901BD3026F793CE12BD0035CD85D508F96E71C48BCF07862C32C79203073O00A8E4A160D95F5103113O00506F776572496E667573696F6E42752O66025O0098A740025O007EA540025O00E0AD40025O00A6AC40030C3O0053686F756C6452657475726E026O000840025O00D0A740025O00ECAD40025O008AA040025O00689040025O002C9140025O00489C40030B3O009E84BBC2BF8185D3BD84AB03043O00B2DAEDC803093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66025O001CB340025O00F8AC40025O00B2A240025O00488340030B3O0044697370656C4D6167696303133O00B2BCF5C0B3B9D9DDB7B2EFD3F6B1E7DDB7B2E303043O00B0D6D586025O00209540025O00DCA240025O00C09840025O00D6A140025O0032A040025O003AA64003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040026O001040025O009CA640025O00BAA94003323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66025O00EC9340025O00708D40030E3O004EC6FBE422C35B83F1E421C159C603063O00A03EA395854C030A3O00FBA9032BC1D3AE092AD103053O00A3B6C06D4F030F3O00432O6F6C646F776E52656D61696E73030B3O00072E01C4FA232009C5FB3003053O0095544660A0032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74025O00989240025O000CB040025O00C8A240025O0056A340030E3O00282O03EC360508AD3C0700EC3F2O03043O008D58666D03093O009E5AC474383154D2A703083O00A1D333AA107A5D35030A3O00D6A7BC2CF9ABBC2CFEBC03043O00489BCED203093O006B735A0A114A7B471A03053O0053261A346E030B3O006B1F26425700214F5D192303043O002638774703093O00DEE656D2075AF2FC4C03063O0036938F38B645025O0068A040025O00D88340025O002EA740025O0080684003113O00DB88F14DE0D48DFE5ACB9685FE44DED18403053O00BFB6E19F29026O001440025O0051B240025O00CEA740025O00607A40025O00B07940025O0058A340025O002OA640025O00809440030E3O00EBC43C5B2A63D3D419552C5CDED503063O0037BBB14E3C4F03093O0054696D65546F446965030E3O001DDB4DEC43FB8828F956E84DCA8403073O00E04DAE3F8B26AF030C3O00426173654475726174696F6E026O33D33F03113O00446562752O665265667265736861626C6503143O0050757267655468655769636B6564446562752O66030E3O0050757267655468655769636B6564025O005EAB40025O0098AA4003173O0094544A29817E4C26817E4F27874A5D2AC445592385465D03043O004EE42138030E3O00FD76B3078AD949BD1181FE7FBB0D03053O00E5AE1ED263030E3O002BF89456E809311EDA8F52E6383D03073O00597B8DE6318D5D030B3O004973417661696C61626C65030E3O00C079F7081F5DC47EE408204BFA7F03063O002A9311966C70030E3O00536861646F77576F72645061696E025O00D8A140025O00A4B04003173O001CAE2C7BE8FF30B1226DE3D71FA72471A7EC0EAB2C78E203063O00886FC64D1F87025O00F08340025O00E09040030F3O003101A652B2F320A6100D8353BCF01F03083O00C96269C736DD8477025O0010A340025O002DB040031A3O00AA0482250D2293AE0391253D31A9B8188B615375A8B80182260703073O00CCD96CE341625503093O00061B26518C86CF2E0103073O00A24B724835EBE7030A3O00A1354AE65107823841F003063O0062EC5C24823303093O00891002BE42A9B835B703083O0050C4796CDA25C8D5030B3O00337B037B4419AC09760C7B03073O00EA6013621F2B6E03093O002B165CC3AB7386030C03073O00EB667F32A7CC1203143O0063A9F437502B42A4F113413C53A4E5374D215EB203063O004E30C195432403093O004D696E6467616D657303123O003D178E1C463113850B01615E84194C31198503053O0021507EE078030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40025O0018B140025O001EA740030A3O0048616C6F506C61796572030B3O00E4A90FCB1CE8A90EC55BE903053O003C8CC863A403133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C6179657203123O0083FD122FAC82CB1732A395B40027AF86F30103053O00C2E7946446030D3O00D5BFB5D5A6536DFBBFA4D1A64203073O003994CDD6B4C836030E3O004D616E6150657263656E74616765025O00405540030D3O00417263616E65546F2O72656E7403153O0013EF36357817C2213B6400F83B203616FC3835711703053O0016729D5554025O00109A40030B3O00F7C312C052E1AECDCE1DC003073O00C8A4AB73A43D96025O00805640030A3O0093FD0D4181BBFA07409103053O00E3DE946325030B3O00536861646F776669656E64025O003CAA40025O0028B34003123O00205A53F2F624545BF3F7371256F7F432555703053O0099532O3296025O008AA640025O0078A640030A3O00707F7D1871AE4359736103073O002D3D16137C13CB030A3O004D696E6462656E64657203113O00CC1B03F10075B7C5171FB50671B4C0150803073O00D9A1726D956210025O00BAA340025O001AA74003083O0049734D6F76696E67025O001EAF40025O00488440025O00F09D40025O0097B040025O0016AD40025O00989640025O0072A740030E3O0033D3654B06F27F4934CF744706C203043O002C63A61703203O006CE23B31369B68FF2C0924AD7FFC2C320CA973E12C3B36AA68B72D373EA57BF203063O00C41C97495653030E3O00C00B28148D4F2F79E10719118B5603083O001693634970E23878025O0068AA40025O00E0684003203O00AB7DE3F182AF4AF5FA9FBC4AF2F484B64AEFFA9BBD78E7FB99F871E3F88CBF7003053O00EDD8158295005B042O0012A03O00014O00BE000100023O002620012O0054040100020004F33O005404010026A900010008000100010004F33O00080001002E1601030004000100040004F33O000400010012A0000200013O00262001020086000100050004F33O008600010012A0000300014O00BE000400043O0026200103000D000100010004F33O000D00010012A0000400013O0026A900040014000100020004F33O00140001002ED000060036000100070004F33O003600012O009F00056O0082000600013O00122O000700083O00122O000800096O0006000800024O00050005000600202O00050005000A4O00050002000200062O00050020000100010004F33O00200001002E16010C00340001000B0004F33O003400012O009F000500024O000500065O00202O00060006000D4O000700033O00202O00070007000E4O00095O00202O00090009000D4O0007000900024O000700076O000800016O0005000800020006720005002F000100010004F33O002F0001002ED0001000340001000F0004F33O003400012O009F000500013O0012A0000600113O0012A0000700124O001D000500074O001E01055O0012A0000200133O0004F33O0086000100262001040010000100010004F33O00100001002E1601150066000100140004F33O006600012O009F00056O00FC000600013O00122O000700163O00122O000800176O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005006600013O0004F33O006600012O009F000500033O0020600005000500180012A0000700194O00EA0005000700022O009F00066O0031000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700206000060006001C2O00E40006000200020010300006001D000600063900060066000100050004F33O006600012O009F000500024O00B100065O00202O00060006001E4O000700033O00202O00070007000E4O00095O00202O00090009001E4O0007000900024O000700076O00050007000200062O00050061000100010004F33O00610001002ED0001F0066000100200004F33O006600012O009F000500013O0012A0000600213O0012A0000700224O001D000500074O001E01056O009F00056O00FC000600013O00122O000700233O00122O000800246O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005008200013O0004F33O008200012O009F000500043O0020090005000500254O00075O00202O0007000700264O00050007000200262O00050082000100190004F33O008200012O009F000500024O009F00065O00201C0006000600272O00E40005000200020006620005008200013O0004F33O008200012O009F000500013O0012A0000600283O0012A0000700294O001D000500074O001E01055O0012A0000400023O0004F33O001000010004F33O008600010004F33O000D00010026A90002008A0001002A0004F33O008A0001002E16012B00F70001002C0004F33O00F700012O009F00036O0082000400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O00030003000A4O00030002000200062O00030096000100010004F33O00960001002E16012F00AA000100300004F33O00AA0001002E5000310014000100310004F33O00AA00012O009F000300024O003700045O00202O0004000400324O000500033O00202O00050005000E4O00075O00202O0007000700324O0005000700024O000500056O000600016O00030006000200062O000300AA00013O0004F33O00AA00012O009F000300013O0012A0000400333O0012A0000500344O001D000300054O001E01036O009F00036O00FC000400013O00122O000500353O00122O000600366O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300C000013O0004F33O00C000012O009F000300033O0020600003000300372O00E400030002000200269B000300C2000100190004F33O00C200012O009F000300043O00205A0003000300384O00055O00202O0005000500394O00030005000200062O000300C2000100010004F33O00C20001002ED0003A00D50001003B0004F33O00D50001002E50003C00130001003C0004F33O00D500012O009F000300024O001100045O00202O00040004001E4O000500033O00202O00050005000E4O00075O00202O00070007001E4O0005000700024O000500056O00030005000200062O000300D500013O0004F33O00D500012O009F000300013O0012A00004003D3O0012A00005003E4O001D000300054O001E01036O009F000300053O000662000300DF00013O0004F33O00DF00012O009F000300043O00205A0003000300384O00055O00202O00050005003F4O00030005000200062O000300E1000100010004F33O00E10001002ED0004000F6000100410004F33O00F600010012A0000300014O00BE000400043O002E16014300E3000100420004F33O00E30001002620010300E3000100010004F33O00E300010012A0000400013O002620010400E8000100010004F33O00E800012O009F000500064O00E9000500010002001218010500443O0012C5000500443O000662000500F600013O0004F33O00F600010012C5000500444O0013010500023O0004F33O00F600010004F33O00E800010004F33O00F600010004F33O00E300010012A0000200453O0026A9000200FB000100010004F33O00FB0001002E160147005D2O0100460004F33O005D2O010012A0000300014O00BE000400043O000E280001003O0100030004F33O003O01002E16014800FD000100490004F33O00FD00010012A0000400013O0026A9000400062O0100020004F33O00062O01002E50004A00390001004B0004F33O003D2O012O009F00056O00FC000600013O00122O0007004C3O00122O0008004D6O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500262O013O0004F33O00262O012O009F000500073O000662000500262O013O0004F33O00262O012O009F000500083O000662000500262O013O0004F33O00262O012O009F000500043O00206000050005004E2O00E4000500020002000672000500262O0100010004F33O00262O012O009F000500043O00206000050005004F2O00E4000500020002000672000500262O0100010004F33O00262O012O009F000500093O00201C0005000500502O009F000600034O00E4000500020002000672000500282O0100010004F33O00282O01002E5000510015000100520004F33O003B2O01002E160154003B2O0100530004F33O003B2O012O009F000500024O001100065O00202O0006000600554O000700033O00202O00070007000E4O00095O00202O0009000900554O0007000900024O000700076O00050007000200062O0005003B2O013O0004F33O003B2O012O009F000500013O0012A0000600563O0012A0000700574O001D000500074O001E01055O0012A0000200023O0004F33O005D2O010026A9000400412O0100010004F33O00412O01002E16015900022O0100580004F33O00022O010012A0000500013O0026A9000500462O0100020004F33O00462O01002E50005A00040001005B0004F33O00482O010012A0000400023O0004F33O00022O01002E16015C00422O01005D0004F33O00422O01000E242O0100422O0100050004F33O00422O012O009F000600093O00203D00060006005E4O00075O00202O00070007005F00122O000800606O00060008000200122O000600443O00122O000600443O00062O000600582O013O0004F33O00582O010012C5000600444O0013010600023O0012A0000500023O0004F33O00422O010004F33O00022O010004F33O005D2O010004F33O00FD000100262001020017020100610004F33O001702010012A0000300013O002ED0006200CE2O0100630004F33O00CE2O01002620010300CE2O0100010004F33O00CE2O012O009F0004000A3O00206000040004000A2O00E4000400020002000662000400852O013O0004F33O00852O012O009F000400093O00208F0004000400644O00055O00202O0005000500654O0006000B6O00078O00088O0004000800024O0005000C3O00062O000400852O0100050004F33O00852O01002E16016700852O0100660004F33O00852O012O009F000400024O00990005000A6O000600033O00202O00060006000E4O0008000A6O0006000800024O000600066O00040006000200062O000400852O013O0004F33O00852O012O009F000400013O0012A0000500683O0012A0000600694O001D000400064O001E01046O009F00046O0076000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004006C4O0004000200024O0005000A3O00202O00050005001C4O00050002000200062O0005009F2O0100040004F33O009F2O012O009F00046O0031000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500201201040004006C4O0004000200024O0005000A3O00202O00050005001C4O00050002000200062O000500CD2O0100040004F33O00CD2O012O009F000400093O0020F600040004006F4O00055O00202O0005000500654O0006000D6O00078O00088O0004000800024O0005000E3O00062O000500CD2O0100040004F33O00CD2O010012A0000400014O00BE000500063O002E16017000B32O0100710004F33O00B32O01002620010400B32O0100010004F33O00B32O010012A0000500014O00BE000600063O0012A0000400023O002ED0007200AC2O0100730004F33O00AC2O01002620010400AC2O0100020004F33O00AC2O01002620010500B72O0100010004F33O00B72O010012A0000600013O002620010600BA2O0100010004F33O00BA2O012O009F0007000F4O00E9000700010002001218010700443O0012C5000700443O000662000700CD2O013O0004F33O00CD2O012O009F000700013O00123A000800743O00122O000900756O000700096O00075O00044O00CD2O010004F33O00BA2O010004F33O00CD2O010004F33O00B72O010004F33O00CD2O010004F33O00AC2O010012A0000300023O002620010300602O0100020004F33O00602O012O009F00046O00FC000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400FE2O013O0004F33O00FE2O012O009F00046O0031000500013O00122O000600783O00122O000700796O0005000700024O00040004000500206000040004006C2O00E40004000200022O009F00056O0031000600013O00122O0007007A3O00122O0008007B6O0006000800024O00050005000600206000050005001C2O00E400050002000200060400052O00020100040004F34O0002012O009F00046O0031000500013O00122O0006007C3O00122O0007007D6O0005000700024O00040004000500206000040004006C2O00E40004000200022O009F00056O0031000600013O00122O0007007E3O00122O0008007F6O0006000800024O00050005000600206000050005001C2O00E400050002000200060400052O00020100040004F34O000201002ED000800014020100810004F33O00140201002E1601830014020100820004F33O001402012O009F000400024O003700055O00202O0005000500324O000600033O00202O00060006000E4O00085O00202O0008000800324O0006000800024O000600066O000700016O00040007000200062O0004001402013O0004F33O001402012O009F000400013O0012A0000500843O0012A0000600854O001D000400064O001E01045O0012A0000200863O0004F33O001702010004F33O00602O010026A90002001B020100450004F33O001B0201002E16018700C2020100880004F33O00C202010012A0000300014O00BE000400043O000E2800010021020100030004F33O00210201002ED00089001D0201008A0004F33O001D02010012A0000400013O0026A900040026020100010004F33O00260201002E16018C00970201008B0004F33O00970201002E50008D00340001008D0004F33O005A02012O009F00056O00FC000600013O00122O0007008E3O00122O0008008F6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005A02013O0004F33O005A02012O009F000500033O0020B40005000500904O0005000200024O00068O000700013O00122O000800913O00122O000900926O0007000900024O00060006000700202O0006000600934O00060002000200102O00060094000600062O0006005A020100050004F33O005A02012O009F000500033O00208C0005000500954O00075O00202O0007000700964O00050007000200062O0005005A02013O0004F33O005A02012O009F000500024O00B100065O00202O0006000600974O000700033O00202O00070007000E4O00095O00202O0009000900974O0007000900024O000700076O00050007000200062O00050055020100010004F33O00550201002E5000980007000100990004F33O005A02012O009F000500013O0012A00006009A3O0012A00007009B4O001D000500074O001E01056O009F00056O00FC000600013O00122O0007009C3O00122O0008009D6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005009602013O0004F33O009602012O009F00056O0082000600013O00122O0007009E3O00122O0008009F6O0006000800024O00050005000600202O0005000500A04O00050002000200062O00050096020100010004F33O009602012O009F000500033O0020B40005000500904O0005000200024O00068O000700013O00122O000800A13O00122O000900A26O0007000900024O00060006000700202O0006000600934O00060002000200102O00060094000600062O00060096020100050004F33O009602012O009F000500033O00208C0005000500954O00075O00202O0007000700A34O00050007000200062O0005009602013O0004F33O00960201002E1601A40096020100A50004F33O009602012O009F000500024O001100065O00202O0006000600A34O000700033O00202O00070007000E4O00095O00202O0009000900A34O0007000900024O000700076O00050007000200062O0005009602013O0004F33O009602012O009F000500013O0012A0000600A63O0012A0000700A74O001D000500074O001E01055O0012A0000400023O002ED000A80022020100A90004F33O0022020100262001040022020100020004F33O002202012O009F00056O00FC000600013O00122O000700AA3O00122O000800AB6O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500AA02013O0004F33O00AA02012O009F000500033O0020600005000500372O00E400050002000200269B000500AC020100190004F33O00AC0201002E5000AC0013000100AD0004F33O00BD02012O009F000500024O001100065O00202O00060006001E4O000700033O00202O00070007000E4O00095O00202O00090009001E4O0007000900024O000700076O00050007000200062O000500BD02013O0004F33O00BD02012O009F000500013O0012A0000600AE3O0012A0000700AF4O001D000500074O001E01055O0012A0000200613O0004F33O00C202010004F33O002202010004F33O00C202010004F33O001D020100262001020057030100860004F33O005703012O009F00036O00FC000400013O00122O000500B03O00122O000600B16O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003000E03013O0004F33O000E03012O009F00036O0031000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400206000030003006C2O00E40003000200022O009F00046O0031000500013O00122O000600B43O00122O000700B56O0005000700024O00040004000500206000040004001C2O00E4000400020002000604000400F2020100030004F33O00F202012O009F00036O0031000400013O00122O000500B63O00122O000600B76O0004000600024O00030003000400206000030003006C2O00E40003000200022O009F00046O0031000500013O00122O000600B83O00122O000700B96O0005000700024O00040004000500206000040004001C2O00E40004000200020006390004000E030100030004F33O000E03012O009F00036O00FC000400013O00122O000500BA3O00122O000600BB6O0004000600024O00030003000400202O0003000300A04O00030002000200062O0003000E03013O0004F33O000E03012O009F000300024O003700045O00202O0004000400BC4O000500033O00202O00050005000E4O00075O00202O0007000700BC4O0005000700024O000500056O000600016O00030006000200062O0003000E03013O0004F33O000E03012O009F000300013O0012A0000400BD3O0012A0000500BE4O001D000300054O001E01036O009F000300103O00206000030003000A2O00E40003000200020006620003003103013O0004F33O003103012O009F000300093O00201C0003000300BF2O00E90003000100020006620003003103013O0004F33O003103012O009F000300033O0020600003000300C00012A0000500C14O00EA0003000500020006620003003103013O0004F33O00310301002E1601C30031030100C20004F33O003103012O009F000300024O007F000400113O00202O0004000400C44O000500033O00202O0005000500C000122O000700C16O0005000700024O000500056O000600016O00030006000200062O0003003103013O0004F33O003103012O009F000300013O0012A0000400C53O0012A0000500C64O001D000300054O001E01036O009F000300123O00206000030003000A2O00E40003000200020006620003005603013O0004F33O005603012O009F000300093O00201C0003000300BF2O00E90003000100020006620003005603013O0004F33O005603012O009F000300033O0020600003000300C00012A0000500C14O00EA0003000500020006620003005603013O0004F33O005603012O009F000300033O0020600003000300C72O00E400030002000200067200030056030100010004F33O005603012O009F000300024O000E010400113O00202O0004000400C84O000500033O00202O0005000500C000122O000700C16O0005000700024O000500056O00030005000200062O0003005603013O0004F33O005603012O009F000300013O0012A0000400C93O0012A0000500CA4O001D000300054O001E01035O0012A0000200053O002620010200E3030100020004F33O00E303012O009F00036O00FC000400013O00122O000500CB3O00122O000600CC6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003007903013O0004F33O007903012O009F000300133O0006620003007903013O0004F33O007903012O009F000300053O0006620003007903013O0004F33O007903012O009F000300043O0020600003000300CD2O00E400030002000200267E00030079030100CE0004F33O007903012O009F000300024O009F00045O00201C0004000400CF2O00E40003000200020006620003007903013O0004F33O007903012O009F000300013O0012A0000400D03O0012A0000500D14O001D000300054O001E01035O002E5000D2003D000100D20004F33O00B603012O009F00036O00FC000400013O00122O000500D33O00122O000600D46O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B603013O0004F33O00B603012O009F000300053O000662000300B603013O0004F33O00B603012O009F000300043O0020600003000300CD2O00E40003000200020026EC000300B6030100D50004F33O00B603012O009F00036O0082000400013O00122O000500D63O00122O000600D76O0004000600024O00030003000400202O0003000300A04O00030002000200062O000300B6030100010004F33O00B603012O009F000300043O00205A0003000300384O00055O00202O0005000500394O00030005000200062O000300B6030100010004F33O00B603012O009F000300093O0020F600030003006F4O00045O00202O0004000400654O0005000D6O00068O00078O0003000700024O0004000E3O00062O000400B6030100030004F33O00B603012O009F000300024O009F00045O00201C0004000400D82O00E4000300020002000672000300B1030100010004F33O00B10301002ED000DA00B6030100D90004F33O00B603012O009F000300013O0012A0000400DB3O0012A0000500DC4O001D000300054O001E01035O002E1601DE00E2030100DD0004F33O00E203012O009F00036O00FC000400013O00122O000500DF3O00122O000600E06O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300E203013O0004F33O00E203012O009F000300053O000662000300E203013O0004F33O00E203012O009F000300043O00205A0003000300384O00055O00202O0005000500394O00030005000200062O000300E2030100010004F33O00E203012O009F000300093O0020F600030003006F4O00045O00202O0004000400654O0005000D6O00068O00078O0003000700024O0004000E3O00062O000400E2030100030004F33O00E203012O009F000300024O009F00045O00201C0004000400E12O00E4000300020002000662000300E203013O0004F33O00E203012O009F000300013O0012A0000400E23O0012A0000500E34O001D000300054O001E01035O0012A00002002A3O000E28001300E7030100020004F33O00E70301002E5000E40024FC2O00E50004F33O000900012O009F000300043O0020600003000300E62O00E40003000200020006620003001004013O0004F33O001004010012A0000300014O00BE000400053O00262001030008040100020004F33O00080401002E1601E800F0030100E70004F33O00F00301002620010400F0030100010004F33O00F003010012A0000500013O002E5000E93O000100E90004F33O00F50301002620010500F5030100010004F33O00F503012O009F000600144O00E9000600010002001218010600443O002ED000EB0010040100EA0004F33O001004010012C5000600443O0006620006001004013O0004F33O001004010012C5000600444O0013010600023O0004F33O001004010004F33O00F503010004F33O001004010004F33O00F003010004F33O00100401002E1601EC00EE030100ED0004F33O00EE0301002620010300EE030100010004F33O00EE03010012A0000400014O00BE000500053O0012A0000300023O0004F33O00EE03012O009F00036O00FC000400013O00122O000500EE3O00122O000600EF6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003204013O0004F33O003204012O009F000300033O00208C0003000300954O00055O00202O0005000500964O00030005000200062O0003003204013O0004F33O003204012O009F000300024O001100045O00202O0004000400974O000500033O00202O00050005000E4O00075O00202O0007000700974O0005000700024O000500056O00030005000200062O0003003204013O0004F33O003204012O009F000300013O0012A0000400F03O0012A0000500F14O001D000300054O001E01036O009F00036O0082000400013O00122O000500F23O00122O000600F36O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003E040100010004F33O003E0401002E1601F4005A040100F50004F33O005A04012O009F000300024O001100045O00202O0004000400A34O000500033O00202O00050005000E4O00075O00202O0007000700A34O0005000700024O000500056O00030005000200062O0003005A04013O0004F33O005A04012O009F000300013O00123A000400F63O00122O000500F76O000300056O00035O00044O005A04010004F33O000900010004F33O005A04010004F33O000400010004F33O005A0401002620012O0002000100010004F33O000200010012A0000100014O00BE000200023O0012A03O00023O0004F33O000200012O0003012O00017O001F3O00028O00026O00F03F025O00589740025O00D4B140025O00A0B040025O00507D40025O001EAD40025O00C05540025O00088340025O0062AE40030C3O0053686F756C6452657475726E025O0088A440025O00FEA040025O006EA740025O0030A740025O00C05140025O00CAAA40025O0010AB40030D3O00546172676574497356616C6964025O0042A240025O00707A4003083O0049734D6F76696E67025O00A7B240025O00588640025O0068AC40025O006C9C40025O00349140025O00B2A240025O000C9540025O003EAD40025O0038A24000C73O0012A03O00014O00BE000100013O000E242O01000200013O0004F33O000200010012A0000100013O000E24010200A6000100010004F33O00A60001002ED000030072000100040004F33O007200012O009F00025O0006620002007200013O0004F33O007200010012A0000200014O00BE000300033O0026200102000E000100010004F33O000E00010012A0000300013O00262001030064000100010004F33O006400010012A0000400014O00BE000500053O002E1601060015000100050004F33O0015000100262001040015000100010004F33O001500010012A0000500013O000E242O01005B000100050004F33O005B00010012A0000600013O00262001060056000100010004F33O005600012O009F000700013O00067200070024000100010004F33O00240001002E160107003B000100080004F33O003B00010012A0000700014O00BE000800083O00262001070026000100010004F33O002600010012A0000800013O002ED0000900290001000A0004F33O0029000100262001080029000100010004F33O002900012O009F000900024O00E90009000100020012180109000B3O0012C50009000B3O00067200090035000100010004F33O00350001002E16010C003B0001000D0004F33O003B00010012C50009000B4O0013010900023O0004F33O003B00010004F33O002900010004F33O003B00010004F33O002600012O009F000700033O0006620007005500013O0004F33O005500010012A0000700014O00BE000800083O000E242O010040000100070004F33O004000010012A0000800013O002E50000E3O0001000E0004F33O00430001000E242O010043000100080004F33O004300012O009F000900044O00E90009000100020012180109000B3O0012C50009000B3O0006720009004F000100010004F33O004F0001002E50000F0008000100100004F33O005500010012C50009000B4O0013010900023O0004F33O005500010004F33O004300010004F33O005500010004F33O004000010012A0000600023O0026200106001D000100020004F33O001D00010012A0000500023O0004F33O005B00010004F33O001D0001002E160111001A000100120004F33O001A00010026200105001A000100020004F33O001A00010012A0000300023O0004F33O006400010004F33O001A00010004F33O006400010004F33O0015000100262001030011000100020004F33O001100012O009F000400054O00E90004000100020012180104000B3O0012C50004000B3O0006620004007200013O0004F33O007200010012C50004000B4O0013010400023O0004F33O007200010004F33O001100010004F33O007200010004F33O000E00012O009F000200063O00201C0002000200132O00E90002000100020006620002008700013O0004F33O008700010012A0000200013O00262001020078000100010004F33O007800012O009F000300074O00E90003000100020012180103000B3O0012C50003000B3O00067200030082000100010004F33O00820001002ED0001400C6000100150004F33O00C600010012C50003000B4O0013010300023O0004F33O00C600010004F33O007800010004F33O00C600012O009F000200083O0020600002000200162O00E40002000200020006720002008E000100010004F33O008E0001002E500017003A000100180004F33O00C600010012A0000200014O00BE000300033O002ED0001A0090000100190004F33O0090000100262001020090000100010004F33O009000010012A0000300013O00262001030095000100010004F33O009500012O009F000400094O00E90004000100020012180104000B3O0012C50004000B3O0006720004009F000100010004F33O009F0001002ED0001C00C60001001B0004F33O00C600010012C50004000B4O0013010400023O0004F33O00C600010004F33O009500010004F33O00C600010004F33O009000010004F33O00C600010026202O010005000100010004F33O000500010012A0000200014O00BE000300033O002E50001D3O0001001D0004F33O00AA0001002620010200AA000100010004F33O00AA00010012A0000300013O000E24010200B3000100030004F33O00B300010012A0000100023O0004F33O00050001002620010300AF000100010004F33O00AF00012O009F0004000A4O00E90004000100020012180104000B3O002E16011F00BF0001001E0004F33O00BF00010012C50004000B3O000662000400BF00013O0004F33O00BF00010012C50004000B4O0013010400023O0012A0000300023O0004F33O00AF00010004F33O000500010004F33O00AA00010004F33O000500010004F33O00C600010004F33O000200012O0003012O00017O00423O00028O00025O0028A940025O007CB240026O00F03F03083O0049734D6F76696E67025O0082B140025O0062B340030C3O0053686F756C6452657475726E025O0016AB40025O00FCA240025O00708040025O00F07F4003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B03163O0044656164467269656E646C79556E697473436F756E74025O00A4A040025O00309D4003103O004D612O73526573752O72656374696F6E025O0046A040025O0036AE4003113O001D1521E6E9BCA7030120E7D3ADB6191B3C03073O00C270745295B6CE030C3O00526573752O72656374696F6E025O0024A840025O0028AC40030C3O002BAD5F0DD2F00B3ABC4517CE03073O006E59C82C78A082027O0040025O0054AA40025O0039B040025O0024B04003123O00B241485AA2FE51904A7950A2DD57962O5B5A03073O003EE22E2O3FD0A903073O004973526561647903083O0042752O66446F776E03163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E6703183O00506F776572576F7264466F72746974756465506C61796572025O00C05640025O0078A54003143O00F51642860D323851F71D6A85101F3B57F10C518603083O003E857935E37F6D4F025O003C9C40025O00F49A40025O00C88340025O0054A440025O00907740025O0031B240025O0004B340025O00809040025O00709540025O00C88740025O0080AD40025O00DCA940025O002EAF40025O00A4AB40025O00D2A94003123O009BCC5C43517D345FAFE5445457432F58AFC603083O002DCBA32B26232A5B025O00349240025O000C9140025O008CAD4003143O00C28ACB26959643DD97D81C81A646C68CC83683AC03073O0034B2E5BC43E7C9002A012O0012A03O00014O00BE000100013O002ED000020002000100030004F33O00020001002620012O0002000100010004F33O000200010012A0000100013O0026202O010067000100040004F33O006700012O009F00025O0020600002000200052O00E400020002000200067200020010000100010004F33O00100001002ED00007001F000100060004F33O001F00010012A0000200013O00262001020011000100010004F33O001100012O009F000300014O00E9000300010002001218010300083O002ED0000A001F000100090004F33O001F00010012C5000300083O0006620003001F00013O0004F33O001F00010012C5000300084O0013010300023O0004F33O001F00010004F33O00110001002E16010C00660001000B0004F33O006600012O009F000200023O0006620002006600013O0004F33O006600012O009F000200023O00206000020002000D2O00E40002000200020006620002006600013O0004F33O006600012O009F000200023O00206000020002000E2O00E40002000200020006620002006600013O0004F33O006600012O009F000200023O00206000020002000F2O00E40002000200020006620002006600013O0004F33O006600012O009F00025O0020600002000200102O009F000400024O00EA00020004000200067200020066000100010004F33O006600010012A0000200014O00BE000300033O000E242O01003B000100020004F33O003B00012O009F000400033O00201C0004000400112O00E90004000100022O00D9000300043O000E6500040045000100030004F33O00450001002E5000120012000100130004F33O005500012O009F000400044O00BD000500053O00202O0005000500144O000600066O000700016O00040007000200062O0004004F000100010004F33O004F0001002E1601160066000100150004F33O006600012O009F000400063O00123A000500173O00122O000600186O000400066O00045O00044O006600012O009F000400044O00BD000500053O00202O0005000500194O000600066O000700016O00040007000200062O0004005F000100010004F33O005F0001002ED0001B00660001001A0004F33O006600012O009F000400063O00123A0005001C3O00122O0006001D6O000400066O00045O00044O006600010004F33O003B00010012A00001001E3O0026202O0100FB000100010004F33O00FB00010012A0000200013O000E240104006E000100020004F33O006E00010012A0000100043O0004F33O00FB0001002E16011F006A000100200004F33O006A00010026200102006A000100010004F33O006A0001002E500021002B000100210004F33O009D00012O009F000300054O00FC000400063O00122O000500223O00122O000600236O0004000600024O00030003000400202O0003000300244O00030002000200062O0003009D00013O0004F33O009D00012O009F000300073O0006620003009D00013O0004F33O009D00012O009F00035O00204C0003000300254O000500053O00202O0005000500264O000600016O00030006000200062O00030090000100010004F33O009000012O009F000300033O0020940003000300274O000400053O00202O0004000400264O00030002000200062O0003009D00013O0004F33O009D00012O009F000300044O009F000400083O00201C0004000400282O00E400030002000200067200030098000100010004F33O00980001002ED0002A009D000100290004F33O009D00012O009F000300063O0012A00004002B3O0012A00005002C4O001D000300054O001E01035O002ED0002E00F90001002D0004F33O00F900012O009F000300093O000662000300F900013O0004F33O00F900010012A0000300014O00BE000400053O002620010300F3000100040004F33O00F300010026A9000400AA000100010004F33O00AA0001002ED0003000A60001002F0004F33O00A600010012A0000500013O0026A9000500AF000100010004F33O00AF0001002ED0003200AB000100310004F33O00AB00012O009F0006000A3O000662000600C900013O0004F33O00C900010012A0000600014O00BE000700073O002E16013400B4000100330004F33O00B40001002620010600B4000100010004F33O00B400010012A0000700013O0026A9000700BD000100010004F33O00BD0001002E16013500B9000100360004F33O00B900012O009F0008000B4O00E9000800010002001218010800083O0012C5000800083O000662000800C900013O0004F33O00C900010012C5000800084O0013010800023O0004F33O00C900010004F33O00B900010004F33O00C900010004F33O00B400012O009F0006000C3O000672000600CE000100010004F33O00CE0001002E16013700F9000100380004F33O00F900010012A0000600014O00BE000700083O002620010600D5000100010004F33O00D500010012A0000700014O00BE000800083O0012A0000600043O002620010600D0000100040004F33O00D00001002E5000393O000100390004F33O00D70001000E242O0100D7000100070004F33O00D700010012A0000800013O002ED0003B00DC0001003A0004F33O00DC0001002620010800DC000100010004F33O00DC00012O009F0009000D4O00E9000900010002001218010900083O0012C5000900083O000662000900F900013O0004F33O00F900010012C5000900084O0013010900023O0004F33O00F900010004F33O00DC00010004F33O00F900010004F33O00D700010004F33O00F900010004F33O00D000010004F33O00F900010004F33O00AB00010004F33O00F900010004F33O00A600010004F33O00F90001002620010300A4000100010004F33O00A400010012A0000400014O00BE000500053O0012A0000300043O0004F33O00A400010012A0000200043O0004F33O006A00010026202O0100070001001E0004F33O000700012O009F000200054O00FC000300063O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O0002000200244O00020002000200062O000200162O013O0004F33O00162O012O009F00025O00204C0002000200254O000400053O00202O0004000400264O000500016O00020005000200062O000200182O0100010004F33O00182O012O009F000200033O0020340002000200274O000300053O00202O0003000300264O00020002000200062O000200182O0100010004F33O00182O01002E16013E00292O01003F0004F33O00292O01002E5000400011000100400004F33O00292O012O009F000200044O009F000300083O00201C0003000300282O00E4000200020002000662000200292O013O0004F33O00292O012O009F000200063O00123A000300413O00122O000400426O000200046O00025O00044O00292O010004F33O000700010004F33O00292O010004F33O000200012O0003012O00017O00293O00028O00026O00F03F025O002CA640025O0060A540025O0086AC40025O00989540025O0028854003083O0042752O66446F776E030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73025O00388C40025O003EA54003063O0042752O66557003073O0052617074757265030F3O00114E4701E56B2C3345630CFE592F2503073O004341213064973C03073O0049735265616479025O00C2A040025O0067B24003143O00506F776572576F7264536869656C64466F637573025O00F0B240025O00DDB04003163O00CFE8B9DDE1E0F0A1CAF7E0F4A6D1F6D3E3EED0F6DEEB03053O0093BF87CEB803053O00B62DA8C4CF03073O00D2E448C6A1B833030A3O0052656E6577466F637573030A3O00244CFD15648E3E4CF21C03063O00AE5629937013025O00088440025O00BBB240025O00A4AB40025O00809240025O00C4AD40025O00A7B240025O0092AA40025O004EA140030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66026O003440025O00FAA34000933O0012A03O00014O00BE000100023O002620012O0007000100010004F33O000700010012A0000100014O00BE000200023O0012A03O00023O0026A93O000B000100020004F33O000B0001002E1601030002000100040004F33O00020001000E242O01000B000100010004F33O000B00010012A0000200013O002E500005004E000100050004F33O005C00010026200102005C000100020004F33O005C0001002E1601070092000100060004F33O009200012O009F00035O00205A0003000300084O000500013O00202O0005000500094O00030005000200062O00030023000100010004F33O002300012O009F00035O00205C00030003000A4O000500013O00202O0005000500094O0003000500024O000400023O00062O00030092000100040004F33O00920001002E16010B00460001000C0004F33O004600012O009F000300033O00208C00030003000D4O000500013O00202O00050005000E4O00030005000200062O0003004600013O0004F33O004600012O009F000300014O0082000400043O00122O0005000F3O00122O000600106O0004000600024O00030003000400202O0003000300114O00030002000200062O00030038000100010004F33O00380001002E1601130092000100120004F33O009200012O009F000300054O009F000400063O00201C0004000400142O00E400030002000200067200030040000100010004F33O00400001002ED000150092000100160004F33O009200012O009F000300043O00123A000400173O00122O000500186O000300056O00035O00044O009200012O009F000300014O00FC000400043O00122O000500193O00122O0006001A6O0004000600024O00030003000400202O0003000300114O00030002000200062O0003009200013O0004F33O009200012O009F000300054O009F000400063O00201C00040004001B2O00E40003000200020006620003009200013O0004F33O009200012O009F000300043O00123A0004001C3O00122O0005001D6O000300056O00035O00044O00920001002E16011E000E0001001F0004F33O000E00010026200102000E000100010004F33O000E00010012A0000300014O00BE000400043O0026A900030066000100010004F33O00660001002ED000200062000100210004F33O006200010012A0000400013O00262001040084000100010004F33O008400010012A0000500013O0026A90005006E000100020004F33O006E0001002E1601230070000100220004F33O007000010012A0000400023O0004F33O008400010026A900050074000100010004F33O00740001002ED00024006A000100250004F33O006A00012O009F000600073O00203B0006000600274O000700013O00202O0007000700094O000800026O0009000A3O00122O000B00286O0006000B000200122O000600263O00122O000600263O00062O0006008200013O0004F33O008200010012C5000600264O0013010600023O0012A0000500023O0004F33O006A0001002E50002900E3FF2O00290004F33O0067000100262001040067000100020004F33O006700010012A0000200023O0004F33O000E00010004F33O006700010004F33O000E00010004F33O006200010004F33O000E00010004F33O009200010004F33O000B00010004F33O009200010004F33O000200012O0003012O00017O00303O00028O00026O00F03F027O0040025O001CA240025O003C9E40026O000840030C3O0053686F756C6452657475726E03073O001617BCF524E2D203073O00B74476CC81519003073O004973526561647903083O0042752O66446F776E03073O0052617074757265025O00F2AA4003113O003EA267E119B501BF74D60A8607AC7EE70E03063O00E26ECD10846B03163O00506F776572576F726452616469616E6365466F63757303293O00FBCCF7DC532OD4EFCB45D4D1E1DD48EACDE3DC7EE2CDF3CD40E5D7A0D144EACFDFDA4EE4CFE4D656E503053O00218BA380B9030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840025O00149540025O00409540025O00C4AD40025O00588840030F3O00675713DB456F0BCC536B0CD752540003043O00BE37386403143O00506F776572576F7264536869656C64466F63757303163O0046A02B1B01DCE459BD382100EBFA53A3385E1BE6F25A03073O009336CF5C7E738303073O003F302569186C0803063O001E6D51551D6D030C3O0052617074757265466F637573030C3O00ED7044A223CCF9BF7951B73A03073O009C9F1134D656BE025O00EEA240025O00BC914003073O0047657454696D65026O00344003113O0053686F756C645261707475726552616D70030F3O0073019F182D2B18B858099D072C011403083O00CB3B60ED6B456F71030B3O004973417661696C61626C6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O6603183O00466F637573556E69745265667265736861626C6542752O66025O0068B240026O00A74000EF3O0012A03O00014O00BE000100023O002620012O00DE000100020004F33O00DE00010026202O010040000100030004F33O004000010012A0000300013O0026A90003000B000100020004F33O000B0001002ED00004000D000100050004F33O000D00010012A0000100063O0004F33O0040000100262001030007000100010004F33O000700010012C5000400073O0006620004001400013O0004F33O001400010012C5000400074O0013010400024O009F00046O0082000500013O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004003E000100010004F33O003E00012O009F000400023O00208C00040004000B4O00065O00202O00060006000C4O00040006000200062O0004003E00013O0004F33O003E0001002E50000D00190001000D0004F33O003E00012O009F00046O00FC000500013O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004003E00013O0004F33O003E00012O009F000400034O008D000500043O00202O0005000500104O000600066O000700056O00040007000200062O0004003E00013O0004F33O003E00012O009F000400013O0012A0000500113O0012A0000600124O001D000400064O001E01045O0012A0000300023O0004F33O00070001000E2401060093000100010004F33O009300012O009F000300063O00205A00030003000B4O00055O00202O0005000500134O00030005000200062O00030052000100010004F33O005200012O009F000300063O00207D0003000300144O00055O00202O0005000500134O00030005000200262O00030052000100150004F33O00520001002ED0001700EE000100160004F33O00EE00010012A0000300014O00BE000400053O00262001030059000100010004F33O005900010012A0000400014O00BE000500053O0012A0000300023O00262001030054000100020004F33O00540001002ED00019005B000100180004F33O005B00010026200104005B000100010004F33O005B00010012A0000500013O00262001050060000100010004F33O006000012O009F00066O00FC000700013O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006007700013O0004F33O007700012O009F000600034O009F000700043O00201C00070007001C2O00E40006000200020006620006007700013O0004F33O007700012O009F000600013O0012A00007001D3O0012A00008001E4O001D000600084O001E01066O009F00066O00FC000700013O00122O0008001F3O00122O000900206O0007000900024O00060006000700202O00060006000A4O00060002000200062O000600EE00013O0004F33O00EE00012O009F000600034O009F000700043O00201C0007000700212O00E4000600020002000662000600EE00013O0004F33O00EE00012O009F000600013O00123A000700223O00122O000800236O000600086O00065O00044O00EE00010004F33O006000010004F33O00EE00010004F33O005B00010004F33O00EE00010004F33O005400010004F33O00EE00010026A900010097000100010004F33O00970001002E5000240019000100250004F33O00AE00010012C5000300264O00E90003000100022O009F000400074O00DC00020003000400267E0002009E000100270004F33O009E00010004F33O00AD00010012A0000300014O00BE000400043O002620010300A0000100010004F33O00A000010012A0000400013O000E242O0100A3000100040004F33O00A300012O00D600055O001218010500283O0012A0000500014O0036000500073O0004F33O00AD00010004F33O00A300010004F33O00AD00010004F33O00A000010012A0000100023O000E2401020004000100010004F33O000400010012A0000300014O00BE000400043O002620010300B2000100010004F33O00B200010012A0000400013O002620010400B9000100020004F33O00B900010012A0000100033O0004F33O00040001002620010400B5000100010004F33O00B500012O009F00056O00FC000600013O00122O000700293O00122O0008002A6O0006000800024O00050005000600202O00050005002B4O00050002000200062O000500CD00013O0004F33O00CD00012O009F000500023O00201800050005002C4O00075O00202O00070007002D4O00050007000200262O000500CD000100060004F33O00CD00012O00AB00056O00D6000500014O0005010500086O000500093O00202O00050005002E4O00065O00202O00060006001300122O000700156O000800093O00122O000A00276O0005000A000200122O000500073O00122O000400023O0004F33O00B500010004F33O000400010004F33O00B200010004F33O000400010004F33O00EE0001002620012O0002000100010004F33O000200010012A0000300013O002620010300E5000100020004F33O00E500010012A03O00023O0004F33O000200010026A9000300E9000100010004F33O00E90001002ED0002F00E1000100300004F33O00E100010012A0000100014O00BE000200023O0012A0000300023O0004F33O00E100010004F33O000200012O0003012O00017O00563O00028O00026O00F03F026O00084003083O0042752O66446F776E030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840025O00EAB140025O001EA040025O000AAC40025O005EA940025O008C9B40025O006C9B40030F3O00C5B11D1E65CFFAAC0E287FF1F0B20E03063O009895DE6A7B1703073O0049735265616479025O00C6AA40025O00CEA04003143O00506F776572576F7264536869656C64466F63757303163O00CD29E146A7E231F951B1E235FE4AB0D122B64BB0DC2A03053O00D5BD469623026O001C40025O00EAAD40025O00E8A74003113O007F5A630D5D627B1A4B67750C46547A0B4A03043O00682F3514025O00406F40025O00307740025O0016B140025O0068954003163O00506F776572576F726452616469616E6365466F63757303293O00B3439619AE30B4439318831DA248881DB20CA6738812AF1BA242955CB40AA240BE1FB300AF488E0BB203063O006FC32CE17CDC030A3O00FD50017DACAED44F137E03063O00CBB8266013CB030A3O004576616E67656C69736D030F3O003C65784FC93C7F7052C3797B7C40C203053O00AE5913192103053O001D175C4BE003073O006B4F72322E97E7025O007EAB40025O007AA840030A3O0052656E6577466F637573030A3O002BA3BB2C9D79BFC538AA03083O00A059C6D549EA59D7025O0084B340025O0071B240030F3O0086EE2OAFA6CBB4AFADE6ADB0A7E1B803043O00DCCE8FDD030B3O004973417661696C61626C6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66026O003440025O006EAF40025O003EA540027O0040025O00606E40025O00A4B140025O003EAD40025O00389D40025O00A07240025O00ECA94003073O0047657454696D65025O00109240025O0040A94003143O0053686F756C644576616E67656C69736D52616D70025O00488840025O00C4A340025O0042AD40025O0036A540025O004EB340025O00CC9A40030A3O00A36B2C19DFC9DE8F6E2003073O00B2E61D4D77B8AC025O003EA740025O0048B140025O00A4A640025O00F09040025O00C05940025O00EEAF40025O00B8A740025O002CA440025O00E06F40026O008340004F012O0012A03O00014O00BE000100023O002620012O0007000100010004F33O000700010012A0000100014O00BE000200023O0012A03O00023O002620012O0002000100020004F33O000200010026202O0100A2000100030004F33O00A200012O009F00035O00205A0003000300044O000500013O00202O0005000500054O00030005000200062O0003001B000100010004F33O001B00012O009F00035O00207D0003000300064O000500013O00202O0005000500054O00030005000200262O0003001B000100070004F33O001B0001002ED00008004E2O0100090004F33O004E2O010012A0000300014O00BE000400053O0026200103009B000100020004F33O009B0001000E242O01001F000100040004F33O001F00010012A0000500013O000E2800010026000100050004F33O00260001002ED0000A007D0001000B0004F33O007D00010012A0000600013O0026A90006002B000100010004F33O002B0001002E16010C00780001000D0004F33O007800012O009F000700014O0082000800023O00122O0009000E3O00122O000A000F6O0008000A00024O00070007000800202O0007000700104O00070002000200062O00070037000100010004F33O00370001002E1601110042000100120004F33O004200012O009F000700034O009F000800043O00201C0008000800132O00E40007000200020006620007004200013O0004F33O004200012O009F000700023O0012A0000800143O0012A0000900154O001D000700094O001E01075O000E6500160046000100020004F33O00460001002E5000170033000100180004F33O007700012O009F000700014O0082000800023O00122O000900193O00122O000A001A6O0008000A00024O00070007000800202O0007000700104O00070002000200062O00070052000100010004F33O00520001002E50001B00120001001C0004F33O00620001002E16011E00770001001D0004F33O007700012O009F000700034O008D000800043O00202O00080008001F4O000900096O000A00056O0007000A000200062O0007007700013O0004F33O007700012O009F000700023O00123A000800203O00122O000900216O000700096O00075O00044O007700012O009F000700014O00FC000800023O00122O000900223O00122O000A00236O0008000A00024O00070007000800202O0007000700104O00070002000200062O0007007700013O0004F33O007700012O009F000700034O009F000800013O00201C0008000800242O00E40007000200020006620007007700013O0004F33O007700012O009F000700023O0012A0000800253O0012A0000900264O001D000700094O001E01075O0012A0000600023O00262001060027000100020004F33O002700010012A0000500023O0004F33O007D00010004F33O00270001000E2401020022000100050004F33O002200012O009F000600014O00FC000700023O00122O000800273O00122O000900286O0007000900024O00060006000700202O0006000600104O00060002000200062O0006004E2O013O0004F33O004E2O01002E16012A004E2O0100290004F33O004E2O012O009F000600034O009F000700043O00201C00070007002B2O00E40006000200020006620006004E2O013O0004F33O004E2O012O009F000600023O00123A0007002C3O00122O0008002D6O000600086O00065O00044O004E2O010004F33O002200010004F33O004E2O010004F33O001F00010004F33O004E2O010026200103001D000100010004F33O001D00010012A0000400014O00BE000500053O0012A0000300023O0004F33O001D00010004F33O004E2O010026202O0100D4000100020004F33O00D400010012A0000300014O00BE000400043O002620010300A6000100010004F33O00A600010012A0000400013O002E16012F00CB0001002E0004F33O00CB0001002620010400CB000100010004F33O00CB00012O009F000500014O00FC000600023O00122O000700303O00122O000800316O0006000800024O00050005000600202O0005000500324O00050002000200062O000500BF00013O0004F33O00BF00012O009F000500073O0020180005000500334O000700013O00202O0007000700344O00050007000200262O000500BF000100030004F33O00BF00012O00AB00056O00D6000500014O0005010500066O000500083O00202O0005000500364O000600013O00202O00060006000500122O000700076O000800093O00122O000A00376O0005000A000200122O000500353O00122O000400023O002ED0003900A9000100380004F33O00A90001002620010400A9000100020004F33O00A900010012A00001003A3O0004F33O00D400010004F33O00A900010004F33O00D400010004F33O00A600010026202O0100FF000100010004F33O00FF00010012A0000300013O002ED0003B00DD0001003C0004F33O00DD0001002620010300DD000100020004F33O00DD00010012A0000100023O0004F33O00FF0001002ED0003E00D70001003D0004F33O00D70001000E242O0100D7000100030004F33O00D700010012A0000400013O002620010400E6000100020004F33O00E600010012A0000300023O0004F33O00D70001002ED0003F00E2000100400004F33O00E20001002620010400E2000100010004F33O00E200010012C5000500414O00E90005000100022O009F000600094O00DC00020005000600267E000200F1000100370004F33O00F100010004F33O00FC00010012A0000500013O002E16014200F2000100430004F33O00F20001002620010500F2000100010004F33O00F200012O00D600065O001218010600443O0012A0000600014O0036000600093O0004F33O00FC00010004F33O00F200010012A0000400023O0004F33O00E200010004F33O00D700010026202O0100090001003A0004F33O000900010012A0000300014O00BE000400043O002E16014500032O0100460004F33O00032O01002620010300032O0100010004F33O00032O010012A0000400013O0026200104000C2O0100020004F33O000C2O010012A0000100033O0004F33O00090001002ED0004800082O0100470004F33O00082O01002620010400082O0100010004F33O00082O010012C5000500353O000672000500152O0100010004F33O00152O01002E50004900040001004A0004F33O00172O010012C5000500354O0013010500024O009F000500014O00FC000600023O00122O0007004B3O00122O0008004C6O0006000800024O00050005000600202O0005000500104O00050002000200062O000500232O013O0004F33O00232O01002E16014E00472O01004D0004F33O00472O010012A0000500014O00BE000600073O002ED00050003F2O01004F0004F33O003F2O010026200105003F2O0100020004F33O003F2O01000E280001002D2O0100060004F33O002D2O01002E50005100FEFF2O00520004F33O00292O010012A0000700013O0026200107002E2O0100010004F33O002E2O012O009F0008000A4O00E9000800010002001218010800353O002E16015400472O0100530004F33O00472O010012C5000800353O000662000800472O013O0004F33O00472O010012C5000800354O0013010800023O0004F33O00472O010004F33O002E2O010004F33O00472O010004F33O00292O010004F33O00472O010026A9000500432O0100010004F33O00432O01002E16015600252O0100550004F33O00252O010012A0000600014O00BE000700073O0012A0000500023O0004F33O00252O010012A0000400023O0004F33O00082O010004F33O000900010004F33O00032O010004F33O000900010004F33O004E2O010004F33O000200012O0003012O00017O005E3O00028O00026O00F03F026O000840025O001CAF40025O00F8A64003073O003644543EDC164003053O00A96425244A03073O004973526561647903083O0042752O66446F776E03073O0052617074757265025O009EAD40025O004CB240025O00DEA640025O00388E40026O00244003113O003088B55512B0AD4204B5A3540986AC530503043O003060E7C2025O00B88340025O00E2A64003163O00506F776572576F726452616469616E6365466F637573025O00507540025O00E8AE4003293O00D85519280BE7B88CDA5E313F18DCA682C6590B1210D6BC97C9541A6D11DDAE8FF759012215DCA094C603083O00E3A83A6E4D79B8CF030A3O005E2ABE4EB6DE7DAC683103083O00C51B5CDF20D1BB11025O00EAB240025O00689740030A3O004576616E67656C69736D030F3O000649C2F5045ACFF2105283F3065ECF03043O009B633FA303053O00B0D4AF88AE03063O00E4E2B1C1EDD9025O00809440025O0056B340030A3O0052656E6577466F637573025O00408A40025O00EC9240030A3O0026B52DE323F02BE335BC03043O008654D043025O0093B140025O00C09840030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840025O00F8AC40025O007DB040030F3O0023A39159019B894E179F8E5516A08203043O003C73CCE6025O00C0AC40025O00307E40025O00549640025O00F2A84003143O00506F776572576F7264536869656C64466F63757303163O00F735FC75F505FC7FF53ED463EF33EE7CE37AE375E63603043O0010875A8B025O008AA440025O00707E4003073O00667516275B467D03073O0018341466532E34030C3O0052617074757265466F637573030C3O00D62E31301AD62A612C0AC52303053O006FA44F4144027O0040025O0014B140025O00B2A640025O00B89140025O00088040030C3O0053686F756C6452657475726E025O00D2AA40025O00ECA340030A3O00C0CF093D21E0D501202B03053O004685B96853025O00707940025O00349F40025O00BC9640025O0032A040025O0022AB40025O00E2B140025O00AEA340025O00F07C40025O0049B34003073O0047657454696D65026O003940025O002EAF40025O005CAD40030E3O0053686F756C64426F746852616D70030F3O006070A6EDCD6C78A7FDCC587DBDF0C003053O00A52811D49E030B3O004973417661696C61626C6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O6603183O00466F637573556E69745265667265736861626C6542752O66026O0034400067012O0012A03O00014O00BE000100033O002620012O00602O0100020004F33O00602O012O00BE000300033O0026202O01000A000100010004F33O000A00010012A0000200014O00BE000300033O0012A0000100023O0026202O010005000100020004F33O000500010026A900020010000100030004F33O00100001002ED0000400CD000100050004F33O00CD00012O009F00046O0082000500013O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400084O00040002000200062O00040021000100010004F33O002100012O009F000400023O00205A0004000400094O00065O00202O00060006000A4O00040006000200062O00040023000100010004F33O00230001002E16010C007F0001000B0004F33O007F00010012A0000400014O00BE000500053O00262001040025000100010004F33O002500010012A0000500013O0026A90005002C000100010004F33O002C0001002ED0000D00280001000E0004F33O0028000100267E0003002F0001000F0004F33O002F00010004F33O006200012O009F00066O0082000700013O00122O000800103O00122O000900116O0007000900024O00060006000700202O0006000600084O00060002000200062O0006003B000100010004F33O003B0001002E160113004B000100120004F33O004B00012O009F000600034O0069000700043O00202O0007000700144O000800086O000900056O00060009000200062O00060045000100010004F33O00450001002E1601160062000100150004F33O006200012O009F000600013O00123A000700173O00122O000800186O000600086O00065O00044O006200012O009F00066O0082000700013O00122O000800193O00122O0009001A6O0007000900024O00060006000700202O0006000600084O00060002000200062O00060057000100010004F33O00570001002ED0001B00620001001C0004F33O006200012O009F000600034O009F00075O00201C00070007001D2O00E40006000200020006620006006200013O0004F33O006200012O009F000600013O0012A00007001E3O0012A00008001F4O001D000600084O001E01066O009F00066O0082000700013O00122O000800203O00122O000900216O0007000900024O00060006000700202O0006000600084O00060002000200062O0006006E000100010004F33O006E0001002E160123007F000100220004F33O007F00012O009F000600034O009F000700043O00201C0007000700242O00E400060002000200067200060076000100010004F33O00760001002E500025000B000100260004F33O007F00012O009F000600013O00123A000700273O00122O000800286O000600086O00065O00044O007F00010004F33O002800010004F33O007F00010004F33O00250001002E16012A00662O0100290004F33O00662O012O009F000400063O00205A0004000400094O00065O00202O00060006002B4O00040006000200062O0004008F000100010004F33O008F00012O009F000400063O00204B00040004002C4O00065O00202O00060006002B4O00040006000200262O000400662O01002D0004F33O00662O010012A0000400014O00BE000500053O002ED0002E00910001002F0004F33O00910001000E242O010091000100040004F33O009100010012A0000500013O00262001050096000100010004F33O009600012O009F00066O0082000700013O00122O000800303O00122O000900316O0007000900024O00060006000700202O0006000600084O00060002000200062O000600A4000100010004F33O00A40001002ED0003200B1000100330004F33O00B10001002ED0003400B1000100350004F33O00B100012O009F000600034O009F000700043O00201C0007000700362O00E4000600020002000662000600B100013O0004F33O00B100012O009F000600013O0012A0000700373O0012A0000800384O001D000600084O001E01065O002E16013A00662O0100390004F33O00662O012O009F00066O00FC000700013O00122O0008003B3O00122O0009003C6O0007000900024O00060006000700202O0006000600084O00060002000200062O000600662O013O0004F33O00662O012O009F000600034O009F000700043O00201C00070007003D2O00E4000600020002000662000600662O013O0004F33O00662O012O009F000600013O00123A0007003E3O00122O0008003F6O000600086O00065O00044O00662O010004F33O009600010004F33O00662O010004F33O009100010004F33O00662O010026A9000200D1000100400004F33O00D10001002E16014100042O0100420004F33O00042O010012A0000400013O000E24010200D6000100040004F33O00D600010012A0000200033O0004F33O00042O01002E16014400D2000100430004F33O00D20001002620010400D2000100010004F33O00D200010012C5000500453O000672000500DF000100010004F33O00DF0001002E5000460004000100470004F33O00E100010012C5000500454O0013010500024O009F00056O0082000600013O00122O000700483O00122O000800496O0006000800024O00050005000600202O0005000500084O00050002000200062O000500022O0100010004F33O00022O010012A0000500014O00BE000600063O002ED0004A00ED0001004B0004F33O00ED0001000E242O0100ED000100050004F33O00ED00010012A0000600013O0026A9000600F6000100010004F33O00F60001002ED0004D00F20001004C0004F33O00F200012O009F000700074O00E9000700010002001218010700453O0012C5000700453O000662000700022O013O0004F33O00022O010012C5000700454O0013010700023O0004F33O00022O010004F33O00F200010004F33O00022O010004F33O00ED00010012A0000400023O0004F33O00D20001000E28000100082O0100020004F33O00082O01002E16014F002E2O01004E0004F33O002E2O010012A0000400013O002E160150000F2O0100350004F33O000F2O010026200104000F2O0100020004F33O000F2O010012A0000200023O0004F33O002E2O01002620010400092O0100010004F33O00092O010012A0000500013O002620010500162O0100020004F33O00162O010012A0000400023O0004F33O00092O010026A90005001A2O0100010004F33O001A2O01002ED0005200122O0100510004F33O00122O010012C5000600534O00E90006000100022O009F000700084O00DC000300060007000E65005400222O0100030004F33O00222O01002ED00055002B2O0100560004F33O002B2O010012A0000600013O002620010600232O0100010004F33O00232O012O00D600075O001218010700573O0012A0000700014O0036000700083O0004F33O002B2O010004F33O00232O010012A0000500023O0004F33O00122O010004F33O00092O010026200102000C000100020004F33O000C00010012A0000400014O00BE000500053O002620010400322O0100010004F33O00322O010012A0000500013O002620010500552O0100010004F33O00552O012O009F00066O00FC000700013O00122O000800583O00122O000900596O0007000900024O00060006000700202O00060006005A4O00060002000200062O000600492O013O0004F33O00492O012O009F000600023O00201800060006005B4O00085O00202O00080008005C4O00060008000200262O000600492O0100030004F33O00492O012O00AB00066O00D6000600014O0005010600096O0006000A3O00202O00060006005D4O00075O00202O00070007002B00122O0008002D6O0009000A3O00122O000B005E6O0006000B000200122O000600453O00122O000500023O002620010500352O0100020004F33O00352O010012A0000200403O0004F33O000C00010004F33O00352O010004F33O000C00010004F33O00322O010004F33O000C00010004F33O00662O010004F33O000500010004F33O00662O01002620012O0002000100010004F33O000200010012A0000100014O00BE000200023O0012A03O00023O0004F33O000200012O0003012O00017O00903O00028O00025O0023B140025O00F8A140027O0040026O000840030C3O004570696353652O74696E677303083O00968F11DA7078A29903063O0016C5EA65AE19030D3O00093DB6CC73A3F3832F21A3DA6503083O00E64D54C5BC16CFB703083O00CA11D2E885AFF72603083O00559974A69CECC190030B3O0080E95EA3E10C86F54BB5F703063O0060C4802DD384026O00F03F025O00CDB040025O00C8A44003083O0006886F4BDBA1B3CB03083O00B855ED1B3FB2CFD4030F3O002058075B045C28590E55005C1C5C0D03043O003F68396903083O003882B0500289A35703043O00246BE7C403113O0075B4AC8351B08B895EBAB097522OA7865103043O00E73DD5C2025O00D89840025O000AA840026O001040026O001440025O000BB040025O0014904003083O00CE231106002EFA3503063O00409D4665726903113O0064ADB4F31552A9B3E62052A9BEE602689803053O007020C8C78303083O001F5548ACCAA5253F03073O00424C303CD8A3CB03073O008F957CD55ECA2103073O0044DAE619933FAE03083O009E2F4758BFA32D4003053O00D6CD4A332C03063O00DC4DE6F95FCA03053O00179A2C829C03083O0022A3B9BA3F1D16B503063O007371C6CDCE56030E3O00B144FB728156F24E8C44EA558A5203043O003AE4379E026O001840025O00CC9C40025O0048AE4003083O001D86045220D4299003063O00BA4EE370264903123O00CC58EA504153F251E8465A75F270EF5A466A03063O001A9C379D353303083O00BFDD02CDB15E8BCB03063O0030ECB876B9D803073O00D5947931C231B403063O005485DD3750AF034O0003083O008EE230B2CE52BAF403063O003CDD8744C6A703073O00DE94D6824FDCBC03063O00B98EDD98E32203083O006BC043EE4A3DF04B03073O009738A5379A235303073O00906A2BEFAD465603043O008EC02365025O006BB240025O0018924003083O00878CC43A35A332A703073O0055D4E9B04E5CCD030D3O00625D89EE5E509BF645568DCA7A03043O00822A38E803083O00D9B030F74931EDA603063O005F8AD544832003123O001A27B646640326A756652327AF76652B2FA403053O00164A48C123025O00149F4003083O001F7CF04C2577E34B03043O00384C198403133O006ECEBC23DD77CFAD33DC57CEA512CE4CC6AE3203053O00AF3EA1CB4603083O000FD8D7073C32DAD003053O00555CBDA373030F3O0019A3273D3B852O3E3CBF393727840003043O005849CC5003083O000ED1AEC97E40204103083O00325DB4DABD172E4703153O00EBB75E7C4BCB4DCC93545E40FA47CCB0525851D84D03073O0028BEC43B2C24BC03083O000F40C8A0F3730A2F03073O006D5C25BCD49A1D03113O0031FCA1E23F5D01E3ADC0175F05FBACC62303063O003A648FC4A35103083O00294737B73647E21D03083O006E7A2243C35F2985030E3O0040A25E68D971A87A44D246BE4E4603053O00B615D13B2A03083O008452D109282OB04403063O00DED737A57D41030D3O0001DED01FFFC4E35E08D4CA1BEB03083O002A4CB1A67A92A18D025O00B4A840025O0007B04003083O001F0CF2182507E11F03043O006C4C698603123O00C2CBA5E4DCF9D0A1F5FAE3D7B4F2C6E4C9B503053O00AE8BA5D18103083O0090B6F6D5CF0D776B03083O0018C3D382A1A6631003123O007310EC0856055606FB2D47137611E835560403063O00762663894C3303083O003AA8296700A33A6003043O001369CD5D03113O008006CA842DBB1DCE9508A01CD6B22BBC0603053O005FC968BEE103083O009CCED5DAA6C5C6DD03043O00AECFABA103163O00C4F019F6EAC5F8EE19DCF6DBF4C905FAECD2E1F71EE703063O00B78D9E6D9398025O005EA940025O0030B140025O0062AD40025O0072A540025O00208840025O0050B04003083O00F5DC97CA27E4C1CA03063O008AA6B9E3BE4E030A3O00FE67C005532010CA78D603073O0079AB14A557324303083O00F53DAD22B00CC12B03063O0062A658D956D903103O00C3E57C2983DDFAFF7706B6D3E2FF760F03063O00BC2O961961E6025O009CA540025O0070844003083O00E98C4B1605E3DD9A03063O008DBAE93F626C03113O00D9EF2DBA2CFFED1CB931F8E5229824FCEF03053O0045918A4CD603083O0043CA2O9DB61877DC03063O007610AF2OE9DF030F3O00A38134B7E7857ABB8B21B2E18555BB03073O001DEBE455DB8EEB002O022O0012A03O00014O00BE000100013O0026A93O0006000100010004F33O00060001002ED000020002000100030004F33O000200010012A0000100013O0026202O01004F000100040004F33O004F00010012A0000200013O000E240104000E000100020004F33O000E00010012A0000100053O0004F33O004F000100262001020029000100010004F33O002900010012C5000300064O0031000400013O00122O000500073O00122O000600086O0004000600024O0003000300042O0031000400013O00122O000500093O00122O0006000A6O0004000600024O0003000300042O003600035O0012C4000300066O000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O0003000300044O000300023O00122O0002000F3O0026200102000A0001000F0004F33O000A00010012A0000300013O002620010300300001000F0004F33O003000010012A0000200043O0004F33O000A00010026A900030034000100010004F33O00340001002E50001000FAFF2O00110004F33O002C00010012C5000400064O0021000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000500013O00122O000600143O00122O000700156O0005000700024O0004000400054O000400033O00122O000400066O000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000400043O00122O0003000F3O00044O002C00010004F33O000A0001002ED0001A00970001001B0004F33O009700010026202O0100970001001C0004F33O009700010012A0000200013O00262001020058000100040004F33O005800010012A00001001D3O0004F33O00970001000E280001005C000100020004F33O005C0001002ED0001E00780001001F0004F33O007800010012C5000300064O000C000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000400013O00122O000500223O00122O000600236O0004000600024O00030003000400062O0003006A000100010004F33O006A00010012A0000300014O0036000300053O0012C4000300066O000400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000400013O00122O000500263O00122O000600276O0004000600024O0003000300044O000300063O00122O0002000F3O002620010200540001000F0004F33O005400010012C5000300064O000C000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400062O00030088000100010004F33O008800010012A0000300014O0036000300073O0012C4000300066O000400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000300083O00122O000200043O0004F33O005400010026A90001009B000100300004F33O009B0001002E500031003F000100320004F33O00D800010012C5000200064O000C000300013O00122O000400333O00122O000500346O0003000500024O0002000200034O000300013O00122O000400353O00122O000500366O0003000500024O00020002000300062O000200A9000100010004F33O00A900010012A0000200014O0036000200093O001219010200066O000300013O00122O000400373O00122O000500386O0003000500024O0002000200034O000300013O00122O000400393O00122O0005003A6O0003000500024O00020002000300062O000200B8000100010004F33O00B800010012A00002003B4O00360002000A3O001219010200066O000300013O00122O0004003C3O00122O0005003D6O0003000500024O0002000200034O000300013O00122O0004003E3O00122O0005003F6O0003000500024O00020002000300062O000200C7000100010004F33O00C700010012A00002003B4O00360002000B3O001219010200066O000300013O00122O000400403O00122O000500416O0003000500024O0002000200034O000300013O00122O000400423O00122O000500436O0003000500024O00020002000300062O000200D6000100010004F33O00D600010012A00002003B4O00360002000C3O0004F33O00010201002ED00045002C2O0100440004F33O002C2O010026202O01002C2O01001D0004F33O002C2O010012A0000200014O00BE000300033O002620010200DE000100010004F33O00DE00010012A0000300013O000E24010400E5000100030004F33O00E500010012A0000100303O0004F33O002C2O01002620010300062O0100010004F33O00062O010012C5000400064O000C000500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O00040004000500062O000400F5000100010004F33O00F500010012A0000400014O00360004000D3O001219010400066O000500013O00122O0006004A3O00122O0007004B6O0005000700024O0004000400054O000500013O00122O0006004C3O00122O0007004D6O0005000700024O00040004000500062O000400042O0100010004F33O00042O010012A00004003B4O00360004000E3O0012A00003000F3O002E50004E00DBFF2O004E0004F33O00E10001002620010300E10001000F0004F33O00E100010012C5000400064O000C000500013O00122O0006004F3O00122O000700506O0005000700024O0004000400054O000500013O00122O000600513O00122O000700526O0005000700024O00040004000500062O000400182O0100010004F33O00182O010012A00004003B4O00360004000F3O001219010400066O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O000500013O00122O000600553O00122O000700566O0005000700024O00040004000500062O000400272O0100010004F33O00272O010012A0000400014O0036000400103O0012A0000300043O0004F33O00E100010004F33O002C2O010004F33O00DE00010026202O0100622O01000F0004F33O00622O010012C5000200064O0031000300013O00122O000400573O00122O000500586O0003000500024O0002000200032O0031000300013O00122O000400593O00122O0005005A6O0003000500024O0002000200032O0036000200113O0012C5000200064O0031000300013O00122O0004005B3O00122O0005005C6O0003000500024O0002000200032O0031000300013O00122O0004005D3O00122O0005005E6O0003000500024O0002000200032O0036000200123O0012D8000200066O000300013O00122O0004005F3O00122O000500606O0003000500024O0002000200034O000300013O00122O000400613O00122O000500626O0003000500024O0002000200034O000200133O00122O000200066O000300013O00122O000400633O00122O000500646O0003000500024O0002000200034O000300013O00122O000400653O00122O000500666O0003000500024O00020002000300062O000200602O0100010004F33O00602O010012A0000200014O0036000200143O0012A0000100043O000E28000500662O0100010004F33O00662O01002E500067003E000100680004F33O00A22O010012A0000200013O002620010200822O01000F0004F33O00822O010012C5000300064O0031000400013O00122O000500693O00122O0006006A6O0004000600024O0003000300042O0031000400013O00122O0005006B3O00122O0006006C6O0004000600024O0003000300042O0036000300153O0012C4000300066O000400013O00122O0005006D3O00122O0006006E6O0004000600024O0003000300044O000400013O00122O0005006F3O00122O000600706O0004000600024O0003000300044O000300163O00122O000200043O002620010200862O0100040004F33O00862O010012A00001001C3O0004F33O00A22O01002620010200672O0100010004F33O00672O010012C5000300064O0021000400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O0003000300044O000300173O00122O000300066O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000400013O00122O000500773O00122O000600786O0004000600024O0003000300044O000300183O00122O0002000F3O00044O00672O010026A9000100A62O0100010004F33O00A62O01002E5000790063FE2O007A0004F33O000700010012A0000200013O002E16017C00CE2O01007B0004F33O00CE2O01002620010200CE2O0100010004F33O00CE2O010012A0000300013O002E16017D00B22O01007E0004F33O00B22O01000E24010F00B22O0100030004F33O00B22O010012A00002000F3O0004F33O00CE2O01000E242O0100AC2O0100030004F33O00AC2O010012C5000400064O0021000500013O00122O0006007F3O00122O000700806O0005000700024O0004000400054O000500013O00122O000600813O00122O000700826O0005000700024O0004000400054O000400193O00122O000400066O000500013O00122O000600833O00122O000700846O0005000700024O0004000400054O000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O0004001A3O00122O0003000F3O00044O00AC2O01000E24010400D22O0100020004F33O00D22O010012A00001000F3O0004F33O00070001002ED0008800A72O0100870004F33O00A72O01002620010200A72O01000F0004F33O00A72O010012A0000300013O002620010300F82O0100010004F33O00F82O010012C5000400064O000C000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400054O000500013O00122O0006008B3O00122O0007008C6O0005000700024O00040004000500062O000400E72O0100010004F33O00E72O010012A00004003B4O00360004001B3O001219010400066O000500013O00122O0006008D3O00122O0007008E6O0005000700024O0004000400054O000500013O00122O0006008F3O00122O000700906O0005000700024O00040004000500062O000400F62O0100010004F33O00F62O010012A0000400014O00360004001C3O0012A00003000F3O000E24010F00D72O0100030004F33O00D72O010012A0000200043O0004F33O00A72O010004F33O00D72O010004F33O00A72O010004F33O000700010004F33O000102010004F33O000200012O0003012O00017O00D63O00028O00026O00F03F030C3O004570696353652O74696E677303083O00E5703DB7EE82AB0503083O0076B61549C387ECCC03093O00383914410A0EF8200C03073O009D685C7A20646D03083O0090A3DBDE34298AB803083O00CBC3C6AFAA5D47ED030B3O000F5F31DB541CF9205F16E503073O009C4E2B5EB5317103083O0041EDD0B7024D7E6103073O00191288A4C36B23030E3O00C939A64177B1C4B6FC0ABB4067AC03083O00D8884DC92F12DCA103083O001EE93FCE01D2853E03073O00E24D8C4BBA68BC03143O008CDDD50F40AECBC20840ABCAE23E4BB0CFDE3C4A03053O002FD9AEB05F026O001040025O00DBB240025O0084A24003083O00D0402OA214BBE45603063O00D583252OD67D030D3O001338209AF7272522BAED2F382803053O0081464B45DF03083O0075CEE7FD75E141D803063O008F26AB93891C030C3O00F594B8FD04E6D8D991B4DB3303073O00B4B0E2D9936383027O0040026O00144003083O004B8FDA57A65C3A4203083O003118EAAE23CF325D03093O0024F3F187561EFDE89803053O00116C929DE803083O0078C600F926A64CD003063O00C82BA3748D4F030D3O008A2538A7B9E2EAB1330E97B1E603073O0083DF565DE3D094026O002040025O006CA340025O0046A64003083O00CC361D1E3BF6F82003063O00989F53696A5203183O00A0D25EFCCC5184C845C1D94E84C755C0C85585E143FDDC4C03063O003CE1A63192A903083O001C1B3B3E0809280D03063O00674F7E4F4A6103143O008F6CD646520EB372D2675B2ABF71DA675B14B97A03063O007ADA1FB3133E025O0020AF40025O0074994003083O0080D3D9D5C0AF42A003073O0025D3B6ADA1A9C103133O00C23659D0257AADF20A48D7216FBCF93948F11803073O00D9975A2DB9481B03083O00F079F3065FCD7BF403053O0036A31C877203163O001DD7498B437E3CDE6D8740763CDE53814B583AD4489203063O001F48BB3DE22E025O0052A340025O005EAA40026O002240025O0016B340025O00CC9E4003083O00E0BC3B13DAB7281403043O0067B3D94F030F3O006FA11DDB4689AF43A411F25383B65A03073O00C32AD77CB521EC03083O003E5C232A2CF60A4A03063O00986D39575E45030B3O00DFDB0BB0B6FA51A9F5FF3A03083O00C899B76AC3DEB234026O001840025O0044A440025O00589640025O00CDB240025O00C1B14003083O0001E69C29405435F003063O003A5283E85D2903103O00A55BD10655178656DC26482D8452F82503063O005FE337B0753D03083O002B7B375FA216793003053O00CB781E432B03123O00D7294CFCD1D9204CE3FBF82B49E6D7F60D7D03053O00B991452D8F025O0033B340025O001DB34003083O00F00357C64E7023D003073O0044A36623B2271E030C3O009379D4C301B08D15BB62F2F703083O0071DE10BAA763D5E303083O001D0BEFE22700FCE503043O00964E6E9B030F3O00A8CC29E5A61BB14480D700F3AB0BAF03083O0020E5A54781C47EDF025O002FB040026O001C40025O001C9340025O00ACAA4003083O00B91A0DB2D584180A03053O00BCEA7F79C6030A3O000D2116B1392207962A3703043O00E358527303083O00701AAEB30B7D440C03063O0013237FDAC76203093O002EFA1AF609E90FCA2C03043O00827C9B6A025O00207C40025O00AAA34003083O00E6CEE2BBAAF87BAC03083O00DFB5AB96CFC3961C030C3O007E3BF3BA1C5E3FC4BC06592A03053O00692C5A83CE03083O00CCE5A6AD0130F8F303063O005E9F80D2D96803073O0062FC08BA4857C903083O001A309966DF3F1F99025O0076A140025O00F88C4003083O003145F9E70B4EEAE003043O009362208D03113O00284CF4CF1461440A47D0C20F53471C6BD303073O002B782383AA663603083O00670393A2ACBE834703073O00E43466E7D6C5D003153O002EEF62CFF8BC16C41AD37DC3EF871DE21FEE7EE2DA03083O00B67E8015AA8AEB79025O0032A040025O0015B04003083O00B8DF21F28F1D371503083O0066EBBA5586E6735003163O007618315177D92759180D4F60D123533E3B5960D1315F03073O0042376C5E3F12B403083O00278891232E57139E03063O003974EDE5574703193O008BA5E2E972E342A4A5DEF765EB46AE81ECF563F760B8BEF8F703073O0027CAD18D87178E025O008EA740025O003AB240025O003C9040025O00AEB040025O00405F40025O0042A040025O00349D40025O0024B34003083O00E4DD532BDED6402C03043O005FB7B82703143O00853EEE28679512A52DE23547890DBB0AF427538503073O0062D55F874634E0034O0003083O00CDA6DD635DF0A4DA03053O00349EC3A91703103O004FAF374489227E994DB32070AA3C7D8E03083O00EB1ADC5214E6551B025O00C49B40025O00E0A940025O00489240025O00A49D4003083O00BBA4FDD67D86A6FA03053O0014E8C189A2030F3O0012D0D2A3F5BB186326F3CCA0E2A42703083O001142BFA5C687EC7703083O003CAABA07F6E6EBC203083O00B16FCFCE739F888C03123O00309A1538C142560B860507F64E4D1780150603073O003F65E97074B42F025O00C08B40025O00808740026O000840025O0022A840025O006EAF40025O00F2B240025O0098964003083O001EBEFA2E24B5E92903043O005A4DDB8E03073O00D31724114D0B7503073O001A866441592C6703083O00C2E62437ADFFE42303053O00C49183504303063O0036B10A0730D803063O00887ED0666878025O0040A840025O00E88F4003083O00F03EF906F138C42803063O0056A35B8D729803113O007F1E797A345C1E67513B41197D76287B3B03053O005A336B141303083O00BEF591FB3483F79603053O005DED90E58F03143O0039E3FD10054900E5D21819541CF3E23E194900E603063O0026759690796B025O00C09840025O004CB140025O00B09440025O00209E4003083O008BD86216BB5A7F3503083O0046D8BD1662D2341803133O00EAD0B482C1EDD0B183E12ODBAA86DDD9DA8BB703053O00B3BABFC3E703083O00CA3A0C2OF0311FF703043O0084995F7803163O0081BD1928E5EDAFA3B63C2CF3D3A1BFB10B0AE5D5B5A103073O00C0D1D26E4D97BA03083O00D30636FDF6CAE71003063O00A4806342899F03123O00359AEC8E0180E78D1599F9AC059AFAB70F8703043O00DE60E98903083O008AB6B30B81FDF7AA03073O0090D9D3C77FE89303113O00C82E3726E6501254EA2A2D3BDC4A0C6CC803083O0024984F5E48B52562025O0015B2400006032O0012A03O00014O00BE000100023O000E24010200FD02013O0004F33O00FD02010026202O010004000100010004F33O000400010012A0000200013O00262001020043000100010004F33O004300010012C5000300034O000C000400013O00122O000500043O00122O000600056O0004000600024O0003000300044O000400013O00122O000500063O00122O000600076O0004000600024O00030003000400062O00030017000100010004F33O001700010012A0000300014O003600035O001219010300036O000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O000400013O00122O0005000A3O00122O0006000B6O0004000600024O00030003000400062O00030026000100010004F33O002600010012A0000300014O0036000300023O001219010300036O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400062O00030035000100010004F33O003500010012A0000300014O0036000300033O0012C4000300036O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000400013O00122O000500123O00122O000600136O0004000600024O0003000300044O000300043O00122O000200023O00262001020089000100140004F33O008900010012A0000300013O000E280002004A000100030004F33O004A0001002E500015001E000100160004F33O006600010012C5000400034O0031000500013O00122O000600173O00122O000700186O0005000700024O0004000400052O0031000500013O00122O000600193O00122O0007001A6O0005000700024O0004000400052O0036000400053O001219010400036O000500013O00122O0006001B3O00122O0007001C6O0005000700024O0004000400054O000500013O00122O0006001D3O00122O0007001E6O0005000700024O00040004000500062O00040064000100010004F33O006400010012A0000400014O0036000400063O0012A00003001F3O000E24011F006A000100030004F33O006A00010012A0000200203O0004F33O00890001000E242O010046000100030004F33O004600010012C5000400034O000C000500013O00122O000600213O00122O000700226O0005000700024O0004000400054O000500013O00122O000600233O00122O000700246O0005000700024O00040004000500062O0004007A000100010004F33O007A00010012A0000400014O0036000400073O0012C4000400036O000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O000500013O00122O000600273O00122O000700286O0005000700024O0004000400054O000400083O00122O000300023O0004F33O00460001002620010200D6000100290004F33O00D600010012A0000300013O0026A900030090000100010004F33O00900001002E16012B00AC0001002A0004F33O00AC00010012C5000400034O000C000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000500013O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500062O0004009E000100010004F33O009E00010012A0000400014O0036000400093O0012C4000400036O000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O0004000A3O00122O000300023O0026A9000300B0000100020004F33O00B00001002E5000340021000100350004F33O00CF00010012C5000400034O000C000500013O00122O000600363O00122O000700376O0005000700024O0004000400054O000500013O00122O000600383O00122O000700396O0005000700024O00040004000500062O000400BE000100010004F33O00BE00010012A0000400014O00360004000B3O001219010400036O000500013O00122O0006003A3O00122O0007003B6O0005000700024O0004000400054O000500013O00122O0006003C3O00122O0007003D6O0005000700024O00040004000500062O000400CD000100010004F33O00CD00010012A0000400014O00360004000C3O0012A00003001F3O0026A9000300D30001001F0004F33O00D30001002E16013F008C0001003E0004F33O008C00010012A0000200403O0004F33O00D600010004F33O008C0001002620010200302O0100200004F33O00302O010012A0000300013O0026A9000300DD000100010004F33O00DD0001002E5000410021000100420004F33O00FC00010012C5000400034O000C000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O00040004000500062O000400EB000100010004F33O00EB00010012A0000400014O00360004000D3O001219010400036O000500013O00122O000600473O00122O000700486O0005000700024O0004000400054O000500013O00122O000600493O00122O0007004A6O0005000700024O00040004000500062O000400FA000100010004F33O00FA00010012A0000400014O00360004000E3O0012A0000300023O00262001032O002O01001F0004F34O002O010012A00002004B3O0004F33O00302O010026A9000300042O0100020004F33O00042O01002ED0004C00D90001004D0004F33O00D900010012A0000400013O002E16014F00282O01004E0004F33O00282O01000E242O0100282O0100040004F33O00282O010012C5000500034O000C000600013O00122O000700503O00122O000800516O0006000800024O0005000500064O000600013O00122O000700523O00122O000800536O0006000800024O00050005000600062O000500172O0100010004F33O00172O010012A0000500014O00360005000F3O001219010500036O000600013O00122O000700543O00122O000800556O0006000800024O0005000500064O000600013O00122O000700563O00122O000800576O0006000800024O00050005000600062O000500262O0100010004F33O00262O010012A0000500014O0036000500103O0012A0000400023O0026A90004002C2O0100020004F33O002C2O01002E16015800052O0100590004F33O00052O010012A00003001F3O0004F33O00D900010004F33O00052O010004F33O00D90001002620010200512O0100400004F33O00512O010012C5000300034O000C000400013O00122O0005005A3O00122O0006005B6O0004000600024O0003000300044O000400013O00122O0005005C3O00122O0006005D6O0004000600024O00030003000400062O000300402O0100010004F33O00402O010012A0000300014O0036000300113O001219010300036O000400013O00122O0005005E3O00122O0006005F6O0004000600024O0003000300044O000400013O00122O000500603O00122O000600616O0004000600024O00030003000400062O0003004F2O0100010004F33O004F2O010012A0000300014O0036000300123O0004F33O000503010026200102009E2O01004B0004F33O009E2O010012A0000300013O002E5000620006000100620004F33O005A2O010026200103005A2O01001F0004F33O005A2O010012A0000200633O0004F33O009E2O01002E160164007A2O0100650004F33O007A2O010026200103007A2O0100010004F33O007A2O010012C5000400034O0031000500013O00122O000600663O00122O000700676O0005000700024O0004000400052O0031000500013O00122O000600683O00122O000700696O0005000700024O0004000400052O0036000400133O001219010400036O000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000500013O00122O0006006C3O00122O0007006D6O0005000700024O00040004000500062O000400782O0100010004F33O00782O010012A0000400014O0036000400143O0012A0000300023O002E16016E00542O01006F0004F33O00542O01000E24010200542O0100030004F33O00542O010012C5000400034O000C000500013O00122O000600703O00122O000700716O0005000700024O0004000400054O000500013O00122O000600723O00122O000700736O0005000700024O00040004000500062O0004008C2O0100010004F33O008C2O010012A0000400014O0036000400153O001219010400036O000500013O00122O000600743O00122O000700756O0005000700024O0004000400054O000500013O00122O000600763O00122O000700776O0005000700024O00040004000500062O0004009B2O0100010004F33O009B2O010012A0000400014O0036000400163O0012A00003001F3O0004F33O00542O01000E24016300FC2O0100020004F33O00FC2O010012A0000300014O00BE000400043O002E5000783O000100780004F33O00A22O01002620010300A22O0100010004F33O00A22O010012A0000400013O002620010400D22O0100010004F33O00D22O010012A0000500013O002ED0007900CD2O01006F0004F33O00CD2O01002620010500CD2O0100010004F33O00CD2O010012C5000600034O000C000700013O00122O0008007A3O00122O0009007B6O0007000900024O0006000600074O000700013O00122O0008007C3O00122O0009007D6O0007000900024O00060006000700062O000600BC2O0100010004F33O00BC2O010012A0000600014O0036000600173O001219010600036O000700013O00122O0008007E3O00122O0009007F6O0007000900024O0006000600074O000700013O00122O000800803O00122O000900816O0007000900024O00060006000700062O000600CB2O0100010004F33O00CB2O010012A0000600014O0036000600183O0012A0000500023O002620010500AA2O0100020004F33O00AA2O010012A0000400023O0004F33O00D22O010004F33O00AA2O01000E24011F00D62O0100040004F33O00D62O010012A0000200293O0004F33O00FC2O01000E28000200DA2O0100040004F33O00DA2O01002E16018300A72O0100820004F33O00A72O010012C5000500034O000C000600013O00122O000700843O00122O000800856O0006000800024O0005000500064O000600013O00122O000700863O00122O000800876O0006000800024O00050005000600062O000500E82O0100010004F33O00E82O010012A0000500014O0036000500193O001219010500036O000600013O00122O000700883O00122O000800896O0006000800024O0005000500064O000600013O00122O0007008A3O00122O0008008B6O0006000800024O00050005000600062O000500F72O0100010004F33O00F72O010012A0000500014O00360005001A3O0012A00004001F3O0004F33O00A72O010004F33O00FC2O010004F33O00A22O010026A900022O000201001F0004F34O000201002E16018D00640201008C0004F33O006402010012A0000300014O00BE000400043O002E16018E002O0201008F0004F33O002O0201000E242O01002O020100030004F33O002O02010012A0000400013O002E1601900033020100910004F33O0033020100262001040033020100010004F33O003302010012A0000500013O0026A900050010020100010004F33O00100201002E500092001E000100930004F33O002C02010012C5000600034O000C000700013O00122O000800943O00122O000900956O0007000900024O0006000600074O000700013O00122O000800963O00122O000900976O0007000900024O00060006000700062O0006001E020100010004F33O001E02010012A0000600984O00360006001B3O0012C4000600036O000700013O00122O000800993O00122O0009009A6O0007000900024O0006000600074O000700013O00122O0008009B3O00122O0009009C6O0007000900024O0006000600074O0006001C3O00122O000500023O0026A900050030020100020004F33O00300201002ED0009E000C0201009D0004F33O000C02010012A0000400023O0004F33O003302010004F33O000C02010026A900040037020100020004F33O00370201002E1601A0005D0201009F0004F33O005D02010012A0000500013O000E242O010056020100050004F33O005602010012C5000600034O000C000700013O00122O000800A13O00122O000900A26O0007000900024O0006000600074O000700013O00122O000800A33O00122O000900A46O0007000900024O00060006000700062O00060048020100010004F33O004802010012A0000600014O00360006001D3O0012C4000600036O000700013O00122O000800A53O00122O000900A66O0007000900024O0006000600074O000700013O00122O000800A73O00122O000900A86O0007000900024O0006000600074O0006001E3O00122O000500023O002ED000AA0038020100A90004F33O0038020100262001050038020100020004F33O003802010012A00004001F3O0004F33O005D02010004F33O00380201002620010400070201001F0004F33O000702010012A0000200AB3O0004F33O006402010004F33O000702010004F33O006402010004F33O002O02010026A900020068020100AB0004F33O00680201002E1601AD00BB020100AC0004F33O00BB02010012A0000300013O00262001030091020100020004F33O009102010012A0000400013O000E2800010070020100040004F33O00700201002E5000AE001E000100AF0004F33O008C02010012C5000500034O0031000600013O00122O000700B03O00122O000800B16O0006000800024O0005000500062O0031000600013O00122O000700B23O00122O000800B36O0006000800024O0005000500062O00360005001F3O001219010500036O000600013O00122O000700B43O00122O000800B56O0006000800024O0005000500064O000600013O00122O000700B63O00122O000800B76O0006000800024O00050005000600062O0005008A020100010004F33O008A02010012A0000500014O0036000500203O0012A0000400023O000E240102006C020100040004F33O006C02010012A00003001F3O0004F33O009102010004F33O006C02010026A900030095020100010004F33O00950201002E5000B80021000100B90004F33O00B402010012C5000400034O000C000500013O00122O000600BA3O00122O000700BB6O0005000700024O0004000400054O000500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500062O000400A3020100010004F33O00A302010012A0000400014O0036000400213O001219010400036O000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000500013O00122O000600C03O00122O000700C16O0005000700024O00040004000500062O000400B2020100010004F33O00B202010012A0000400014O0036000400223O0012A0000300023O002E1601C20069020100C30004F33O00690201000E24011F0069020100030004F33O006902010012A0000200143O0004F33O00BB02010004F33O00690201002E1601C40007000100C50004F33O0007000100262001020007000100020004F33O000700010012C5000300034O000C000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000400013O00122O000500C83O00122O000600C96O0004000600024O00030003000400062O000300CD020100010004F33O00CD02010012A0000300014O0036000300233O001219010300036O000400013O00122O000500CA3O00122O000600CB6O0004000600024O0003000300044O000400013O00122O000500CC3O00122O000600CD6O0004000600024O00030003000400062O000300DC020100010004F33O00DC02010012A0000300014O0036000300243O0012D8000300036O000400013O00122O000500CE3O00122O000600CF6O0004000600024O0003000300044O000400013O00122O000500D03O00122O000600D16O0004000600024O0003000300044O000300253O00122O000300036O000400013O00122O000500D23O00122O000600D36O0004000600024O0003000300044O000400013O00122O000500D43O00122O000600D56O0004000600024O00030003000400062O000300F7020100010004F33O00F702010012A0000300014O0036000300263O0012A00002001F3O0004F33O000700010004F33O000503010004F33O000400010004F33O00050301002E5000D60005FD2O00D60004F33O00020001000E242O01000200013O0004F33O000200010012A0000100014O00BE000200023O0012A03O00023O0004F33O000200012O0003012O00017O00E33O00028O00025O00BEA640025O007AAE40026O00F03F027O0040026O000840025O00B07740025O00349540026O00184003083O0042752O66446F776E030C3O0053757267656F664C69676874030C3O0049734368612O6E656C696E67030F3O00412O66656374696E67436F6D626174025O00C49540025O00A07640025O00D09640025O0078AB40025O00409540030C3O0053686F756C6452657475726E025O00889D40025O00C05E40025O004C9A40025O0002A840025O00089E40025O00DAA440025O00406040025O00A0A940025O0042B340025O005DB040025O003C9240025O00449740025O00B0AF40025O00F08440025O00907440025O00E07C40025O00A6A940025O00F49040025O00B88740025O0018B040025O00406940025O00EEA740025O000C9940025O00FCB140025O0040A440025O00E89840025O0026A140025O0084B340025O00108D40025O00508940025O00BAB240025O0014A540025O00588140025O0038814003083O004973496E5261696403093O004973496E5061727479025O00507040025O003AAE40025O00E07440025O00D4A740025O008AAC40025O00C7B24003053O00706169727303103O0052616D705261707475726554696D6573025O004CAA40025O004EAC4003073O001AA0D4680B313403083O004248C1A41C7E4351030F3O00432O6F6C646F776E52656D61696E73030A3O00436F6D62617454696D65026O003640025O0010B240025O00049E4003133O0052616D704576616E67656C69736D54696D6573030A3O00C23AA9562173EB25BB5503063O0016874CC83846030D3O0052616D70426F746854696D657303073O00BF31E83048F38803063O0081ED5098443D030A3O0074BE05FD1B125458BB0903073O003831C864937C77025O0050A040025O00789F40025O00C2A940025O0052B240030C3O004570696353652O74696E677303073O00F786C3868D2OD003063O00B5A3E9A42OE12O033O005F843D03043O001730EB5E03073O0048D5DF5A5B36C103073O00B21CBAB83D37532O033O00C7C95403073O0095A4AD275C926E03073O00C7281718161EE003063O007B9347707F7A03063O00C8C4916143C003053O0026ACADE211025O00807840025O00B8A940031A3O00467269656E646C79556E6974735769746842752O66436F756E74030D3O0041746F6E656D656E7442752O66025O00C05D40025O00B3B14003093O0049734D6F756E746564025O0056A340025O002EAE40026O001040025O001AA140025O00F49A40030A3O00A85FEB468A4CE6419E4403043O0028ED298A03073O0049735265616479025O00D49A40025O009AAA40030E3O004973497454696D65546F52616D70026O001440025O00805D40025O00609D40025O0040A940025O00089140025O0032A940025O00D09C4003073O005365744356617203083O00F575F7E869F175E803053O002AA7149A98025O0044A540025O00A5B240025O005C9B40025O00F07740030A3O006FE8A34C762446F7B14F03063O00412A9EC2221103073O002826421838FF1E03083O008E7A47326C4D8D7B025O00C09340025O0083B04003083O0027A3F2081823A3ED03053O005B75C29F78025O00208E40025O00F5B140025O004CA54003083O00FE3FB2E0EF08BEE203043O0090AC5EDF03073O00160EB253311DA703043O0027446FC2025O00D4B040025O000FB240025O0092A140025O0010814003083O00E4A7EAD75A81D7B403063O00D7B6C687A719025O0020A540025O0072AC40030D3O004973446561644F7247686F7374025O00B5B040025O00D09540025O0054B040025O00E07640025O00A06240025O0086B140025O00308440025O0034904003073O00791E2BE841143F03043O008F2D714C03043O00AAB9112C03043O005C2OD87C03073O006F3DAB47F15E2103053O009D3B52CC2003063O002B2EF1FFE8EE03083O00D1585E839A898AB3025O001CAC40025O0034AD40025O00B88940025O00988C40025O0062B340025O000DB140025O0018844003063O0042752O66557003123O00536861646F77436F76656E616E7442752O6603103O00A7F9BC82D3B3B0E4AB99EEBE82F4A59C03063O00D6E390CAEBBD030A3O00C9AC91721EB66028ECB703083O005C8DC5E71B70D333030A3O00CEFE86ACE2EEFE8EACC603053O00B1869FEAC303043O0095EA33AF03053O00A9DD8B5FC0025O00B07D40025O004FB040025O00C4A540025O00405E40025O00A09D40025O00FEA540025O0014A040025O0058A240025O0092AB40025O007C9B40030D3O00331DDD55FADCAA0515C25FC6DD03073O00DA777CAF3EA8B903073O0095F546C5ABF34D03043O00A4C5902803153O0052616469616E7450726F766964656E636542752O66025O00607640025O00649D40025O004C9F40025O00A6A540030A3O00456E656D69657334307903113O00476574456E656D696573496E52616E6765026O00444003163O00476574456E656D696573496E4D656C2O6552616E6765026O00284003083O0049734D6F76696E67025O004EA440025O0080A24003073O0047657454696D65025O008AA540025O0054A040025O00B08640025O003C984003063O002A082C1133E803073O00447A7D5E78559103093O00466F637573556E6974026O003440025O00A8A240025O00689E40025O00A3B240025O0050A940026O00384000A3042O0012A03O00014O00BE000100063O002E1601020008000100030004F33O00080001000E240104000800013O0004F33O000800012O00BE000300043O0012A03O00053O002620012O0098040100060004F33O00980401002E16010700F2000100080004F33O00F200010026202O0100F2000100090004F33O00F200012O009F000700013O00202A00070007000A4O000900023O00202O00090009000B4O0007000900024O00078O000700013O00202O00070007000C4O00070002000200062O000700A2040100010004F33O00A204012O009F000700013O00206000070007000D2O00E400070002000200067200070020000100010004F33O00200001002ED0000E00A40001000F0004F33O00A400010012A0000700013O00262001070060000100010004F33O006000010012A0000800013O000E242O010059000100080004F33O005900010006620002003F00013O0004F33O003F00010012A0000900014O00BE000A000A3O002E5000103O000100100004F33O002A00010026200109002A000100010004F33O002A00010012A0000A00013O0026A9000A0033000100010004F33O00330001002ED00011002F000100120004F33O002F00012O009F000B00034O00E9000B00010002001218010B00133O0012C5000B00133O000662000B003F00013O0004F33O003F00010012C5000B00134O0013010B00023O0004F33O003F00010004F33O002F00010004F33O003F00010004F33O002A000100067200030043000100010004F33O00430001002ED000140058000100150004F33O005800010012A0000900014O00BE000A000A3O00262001090045000100010004F33O004500010012A0000A00013O0026A9000A004C000100010004F33O004C0001002ED000170048000100160004F33O004800012O009F000B00044O00E9000B00010002001218010B00133O0012C5000B00133O000662000B005800013O0004F33O005800010012C5000B00134O0013010B00023O0004F33O005800010004F33O004800010004F33O005800010004F33O004500010012A0000800043O0026A90008005D000100040004F33O005D0001002ED000190024000100180004F33O002400010012A0000700043O0004F33O006000010004F33O002400010026A900070064000100050004F33O00640001002E50001A000B0001001B0004F33O006D00012O009F000800054O00E9000800010002001218010800133O0012C5000800133O000662000800A204013O0004F33O00A204010012C5000800134O0013010800023O0004F33O00A20401000E2401040021000100070004F33O002100010006620004008600013O0004F33O008600010012A0000800014O00BE000900093O000E242O010073000100080004F33O007300010012A0000900013O00262001090076000100010004F33O007600012O009F000A00064O00E9000A00010002001218010A00133O0012C5000A00133O000672000A0080000100010004F33O00800001002ED0001C00860001001D0004F33O008600010012C5000A00134O0013010A00023O0004F33O008600010004F33O007600010004F33O008600010004F33O00730001002E16011E00A10001001F0004F33O00A10001000662000500A100013O0004F33O00A100010012A0000800014O00BE000900093O002ED00021008C000100200004F33O008C0001000E242O01008C000100080004F33O008C00010012A0000900013O000E242O010091000100090004F33O009100012O009F000A00074O00E9000A00010002001218010A00133O002E16012200A1000100230004F33O00A100010012C5000A00133O000662000A00A100013O0004F33O00A100010012C5000A00134O0013010A00023O0004F33O00A100010004F33O009100010004F33O00A100010004F33O008C00010012A0000700053O0004F33O002100010004F33O00A20401002E16012500A2040100240004F33O00A204012O009F000700083O000662000700A204013O0004F33O00A204010012A0000700013O0026A9000700AE000100010004F33O00AE0001002E16012700C7000100260004F33O00C70001002E16012800C3000100290004F33O00C30001000662000200C300013O0004F33O00C300010012A0000800013O0026A9000800B7000100010004F33O00B70001002E16012B00B30001002A0004F33O00B300012O009F000900034O00E9000900010002001218010900133O0012C5000900133O000672000900BF000100010004F33O00BF0001002ED0002C00C30001002D0004F33O00C300010012C5000900134O0013010900023O0004F33O00C300010004F33O00B300012O009F000800094O00E9000800010002001218010800133O0012A0000700043O000E28000500CB000100070004F33O00CB0001002ED0002F00D30001002E0004F33O00D300010012C5000800133O000672000800D0000100010004F33O00D00001002ED0003000A2040100310004F33O00A204010012C5000800134O0013010800023O0004F33O00A20401002620010700AA000100040004F33O00AA00010012A0000800014O00BE000900093O002620010800D7000100010004F33O00D700010012A0000900013O0026A9000900DE000100040004F33O00DE0001002E16013200E0000100330004F33O00E000010012A0000700053O0004F33O00AA0001000E28000100E4000100090004F33O00E40001002ED0003400DA000100350004F33O00DA00010012C5000A00133O000662000A00E900013O0004F33O00E900010012C5000A00134O0013010A00024O009F000A000A4O00E9000A00010002001218010A00133O0012A0000900043O0004F33O00DA00010004F33O00AA00010004F33O00D700010004F33O00AA00010004F33O00A204010026202O0100F72O0100050004F33O00F72O010012A0000700013O002620010700042O0100050004F33O00042O012O009F000800013O0020600008000800362O00E4000800020002000672000800022O0100010004F33O00022O012O009F000800013O0020600008000800372O00E4000800020002000662000800022O013O0004F33O00022O012O009F0006000B3O0012A0000100063O0004F33O00F72O010026200107000A2O0100010004F33O000A2O012O00D600056O00D600086O00360008000C3O0012A0000700043O002620010700F5000100040004F33O00F500012O009F0008000D3O000662000800F42O013O0004F33O00F42O010012A0000800014O00BE000900093O002E16013800112O0100390004F33O00112O01002620010800112O0100010004F33O00112O010012A0000900013O0026A90009001A2O0100010004F33O001A2O01002E16013B00982O01003A0004F33O00982O010012A0000A00013O002620010A001F2O0100040004F33O001F2O010012A0000900043O0004F33O00982O01002ED0003C001B2O01003D0004F33O001B2O01002620010A001B2O0100010004F33O001B2O010012C5000B003E3O0012C5000C003F4O000F010B0002000D0004F33O005D2O010012C50010003E4O00D90011000F4O000F0110000200120004F33O005B2O01002ED00040004B2O0100410004F33O004B2O012O009F0015000E4O00CE001600026O0017000F3O00122O001800423O00122O001900436O0017001900024O00160016001700202O0016001600444O0016000200024O001700103O00202O0017001700454O001700016O00153O00024O001600116O001700026O0018000F3O00122O001900423O00122O001A00436O0018001A00024O00170017001800202O0017001700444O0017000200024O001800103O00202O0018001800454O001800016O00163O00024O00150015001600062O0014004B2O0100150004F33O004B2O010004F33O005B2O012O009F001500103O00201C0015001500452O00E90015000100022O00DC0015001400150026EC001500572O0100460004F33O00572O012O009F001500103O00201C0015001500452O00E90015000100022O00DC001500140015000E65000100592O0100150004F33O00592O01002E5000470004000100480004F33O005B2O012O00D6001500014O00360015000C3O00061F0010002B2O0100020004F33O002B2O0100061F000B00272O0100020004F33O00272O010012C5000B003E3O0012C5000C00494O000F010B0002000D0004F33O00942O010012C50010003E4O00D90011000F4O000F0110000200120004F33O00922O012O009F0015000E4O00A4001600026O0017000F3O00122O0018004A3O00122O0019004B6O0017001900024O00160016001700202O0016001600444O0016000200024O001700103O00202O0017001700454O001700016O00153O00024O001600116O001700026O0018000F3O00122O0019004A3O00122O001A004B6O0018001A00024O00170017001800202O0017001700444O0017000200024O001800103O00202O0018001800454O001800016O00163O00024O00150015001600062O001500922O0100140004F33O00922O012O009F001500103O00201C0015001500452O00E90015000100022O00DC0015001400150026EC001500922O0100460004F33O00922O012O009F001500103O00201C0015001500452O00E90015000100022O00DC001500140015000EAE000100922O0100150004F33O00922O012O00D6001500014O00360015000C3O00061F001000672O0100020004F33O00672O0100061F000B00632O0100020004F33O00632O010012A0000A00043O0004F33O001B2O01002620010900162O0100040004F33O00162O010012C5000A003E3O0012C5000B004C4O000F010A0002000C0004F33O00EE2O010012C5000F003E4O00D90010000E4O000F010F000200110004F33O00EC2O012O009F0014000E4O00A4001500026O0016000F3O00122O0017004D3O00122O0018004E6O0016001800024O00150015001600202O0015001500444O0015000200024O001600103O00202O0016001600454O001600016O00143O00024O001500116O001600026O0017000F3O00122O0018004D3O00122O0019004E6O0017001900024O00160016001700202O0016001600444O0016000200024O001700103O00202O0017001700454O001700016O00153O00024O00140014001500062O001400DC2O0100130004F33O00DC2O012O009F0014000E4O009F001500024O00310016000F3O00122O0017004F3O00122O001800506O0016001800024O0015001500160020B50015001500444O0015000200024O001600103O00202O0016001600454O001600016O00143O00024O001500116O001600024O00310017000F3O00122O0018004F3O00122O001900506O0017001900024O0016001600170020BB0016001600444O0016000200024O001700103O00202O0017001700454O001700016O00153O00024O00140014001500062O001400DE2O0100130004F33O00DE2O01002E16015100EC2O0100520004F33O00EC2O012O009F001400103O00201C0014001400452O00E90014000100022O00DC0014001300140026EC001400EC2O0100460004F33O00EC2O012O009F001400103O00201C0014001400452O00E90014000100022O00DC001400130014000EAE000100EC2O0100140004F33O00EC2O012O00D6001400014O00360014000C3O00061F000F00A22O0100020004F33O00A22O0100061F000A009E2O0100020004F33O009E2O010004F33O00F42O010004F33O00162O010004F33O00F42O010004F33O00112O012O009F000600123O0012A0000700053O0004F33O00F500010026A9000100FB2O0100010004F33O00FB2O01002E1601540024020100530004F33O002402012O009F000700134O00030007000100012O009F000700144O00030007000100010012C5000700554O00310008000F3O00122O000900563O00122O000A00576O0008000A00024O0007000700082O00310008000F3O00122O000900583O00122O000A00596O0008000A00024O0007000700082O0036000700083O0012C5000700554O00310008000F3O00122O0009005A3O00122O000A005B6O0008000A00024O0007000700082O00310008000F3O00122O0009005C3O00122O000A005D6O0008000A00024O0007000700082O0036000700153O0012C4000700556O0008000F3O00122O0009005E3O00122O000A005F6O0008000A00024O0007000700084O0008000F3O00122O000900603O00122O000A00616O0008000A00024O0007000700084O000700163O00122O000100043O0026202O01003F030100060004F33O003F03010012A0000700013O00262001070043020100010004F33O004302012O009F000800013O0020600008000800362O00E400080002000200067200080034020100010004F33O003402012O009F000800013O0020600008000800372O00E400080002000200067200080034020100010004F33O003402010012A0000600043O002ED000620042020100630004F33O004202010006620002004202013O0004F33O004202012O009F000800173O0020FE0008000800644O000900023O00202O0009000900654O000A8O000B8O0008000B000200062O00060042020100080004F33O004202012O00D600025O0012A0000700043O0026A900070047020100050004F33O00470201002ED000670051020100660004F33O005102012O009F000800013O0020600008000800682O00E40008000200020006720008004E020100010004F33O004E0201002E16016A004F020100690004F33O004F02012O0003012O00013O0012A00001006B3O0004F33O003F0301002ED0006D00270201006C0004F33O0027020100262001070027020100040004F33O002702012O009F0008000D3O0006620008003703013O0004F33O003703010012A0000800013O002620010800EE020100040004F33O00EE02012O009F000900024O00FC000A000F3O00122O000B006E3O00122O000C006F6O000A000C00024O00090009000A00202O0009000900704O00090002000200062O000900B102013O0004F33O00B10201000672000400B1020100010004F33O00B102010012C50009003E3O0012C5000A00494O000F01090002000B0004F33O00AF0201002E16017100AF020100720004F33O00AF02012O009F000E00173O0020E3000E000E00734O000F000C6O0010000D3O00122O001100746O000E0011000200062O000E00AF02013O0004F33O00AF02010012A0000E00014O00BE000F000F3O0026A9000E007B020100010004F33O007B0201002E50007500FEFF2O00760004F33O007702010012A0000F00013O002E16017800A3020100770004F33O00A30201002620010F00A3020100010004F33O00A302010012A0001000014O00BE001100113O00262001100082020100010004F33O008202010012A0001100013O002E16017A009C020100790004F33O009C0201000E242O01009C020100110004F33O009C02010012A0001200013O000E242O010095020100120004F33O009502012O00D6000400013O00124A0013007B6O0014000F3O00122O0015007C3O00122O0016007D6O00140016000200122O001500056O00130015000100122O001200043O0026A900120099020100040004F33O00990201002ED0007F008A0201007E0004F33O008A02010012A0001100043O0004F33O009C02010004F33O008A0201000E2401040085020100110004F33O008502010012A0000F00043O0004F33O00A302010004F33O008502010004F33O00A302010004F33O00820201002E160181007C020100800004F33O007C0201002620010F007C020100040004F33O007C02012O009F001000103O00201C0010001000452O00E90010000100022O0036001000183O0004F33O00AF02010004F33O007C02010004F33O00AF02010004F33O0077020100061F0009006B020100020004F33O006B02012O009F000900024O00FC000A000F3O00122O000B00823O00122O000C00836O000A000C00024O00090009000A00202O0009000900704O00090002000200062O0009003703013O0004F33O003703012O009F000900024O00FC000A000F3O00122O000B00843O00122O000C00856O000A000C00024O00090009000A00202O0009000900704O00090002000200062O0009003703013O0004F33O0037030100067200050037030100010004F33O003703010012C50009003E3O0012C5000A004C4O000F01090002000B0004F33O00EB02012O009F000E00173O0020E3000E000E00734O000F000C6O0010000D3O00122O001100746O000E0011000200062O000E00EB02013O0004F33O00EB02010012A0000E00013O002E16018600E1020100870004F33O00E10201002620010E00E1020100010004F33O00E102012O00D6000500013O00124A000F007B6O0010000F3O00122O001100883O00122O001200896O00100012000200122O001100066O000F0011000100122O000E00043O002E50008A00F3FF2O008A0004F33O00D40201002620010E00D4020100040004F33O00D402012O009F000F00103O00201C000F000F00452O00E9000F000100022O0036000F00183O0004F33O00EB02010004F33O00D4020100061F000900CB020100020004F33O00CB02010004F33O003703010026A9000800F2020100010004F33O00F20201002E50008B0069FF2O008C0004F33O005902010012C50009007B4O0023000A000F3O00122O000B008D3O00122O000C008E6O000A000C000200122O000B00016O0009000B00012O00CA000900026O000A000F3O00122O000B008F3O00122O000C00906O000A000C00024O00090009000A00202O0009000900704O00090002000200062O0009003503013O0004F33O0035030100067200030035030100010004F33O003503010012C50009003E3O0012C5000A003F4O000F01090002000B0004F33O003303012O009F000E00173O00205F000E000E00734O000F000C6O0010000D3O00122O001100746O000E0011000200062O000E0013030100010004F33O00130301002E5000910022000100920004F33O003303010012A0000E00013O002E160194002B030100930004F33O002B0301002620010E002B030100010004F33O002B03010012A0000F00013O002620010F0024030100010004F33O002403012O00D6000300013O00124A0010007B6O0011000F3O00122O001200953O00122O001300966O00110013000200122O001200046O00100012000100122O000F00043O002ED000970019030100980004F33O00190301002620010F0019030100040004F33O001903010012A0000E00043O0004F33O002B03010004F33O00190301002620010E0014030100040004F33O001403012O009F000F00103O00201C000F000F00452O00E9000F000100022O0036000F00183O0004F33O003303010004F33O0014030100061F00090009030100020004F33O000903010012A0000800043O0004F33O005902012O009F000800013O0020600008000800992O00E40008000200020006620008003D03013O0004F33O003D03012O0003012O00013O0012A0000700053O0004F33O002702010026A900010043030100040004F33O00430301002ED0009A00800301009B0004F33O008003010012A0000700014O00BE000800083O0026A900070049030100010004F33O00490301002ED0009C00450301009D0004F33O004503010012A0000800013O000E280005004E030100080004F33O004E0301002ED0009F00510301009E0004F33O005103012O00D600045O0012A0000100053O0004F33O0080030100262001080056030100040004F33O005603012O009F000200194O00D600035O0012A0000800053O0026200108004A030100010004F33O004A03010012A0000900013O002E1601A00076030100A10004F33O00760301000E242O010076030100090004F33O007603010012C5000A00554O0031000B000F3O00122O000C00A23O00122O000D00A36O000B000D00024O000A000A000B2O0031000B000F3O00122O000C00A43O00122O000D00A56O000B000D00024O000A000A000B2O0036000A000D3O0012C4000A00556O000B000F3O00122O000C00A63O00122O000D00A76O000B000D00024O000A000A000B4O000B000F3O00122O000C00A83O00122O000D00A96O000B000D00024O000A000A000B4O000A00193O00122O000900043O002ED000AA0059030100AB0004F33O0059030100262001090059030100040004F33O005903010012A0000800043O0004F33O004A03010004F33O005903010004F33O004A03010004F33O008003010004F33O004503010026A900010084030100740004F33O00840301002ED000AD002F040100AC0004F33O002F04010012A0000700014O00BE000800083O0026A90007008A030100010004F33O008A0301002ED000AE0086030100AF0004F33O008603010012A0000800013O0026A90008008F030100040004F33O008F0301002ED0001F00C4030100B00004F33O00C403010012A0000900013O000E242O0100BF030100090004F33O00BF03012O009F000A00013O00208C000A000A00B14O000C00023O00202O000C000C00B24O000A000C000200062O000A00A103013O0004F33O00A103012O009F000A00024O0031000B000F3O00122O000C00B33O00122O000D00B46O000B000D00024O000A000A000B000672000A00A7030100010004F33O00A703012O009F000A00024O0031000B000F3O00122O000C00B53O00122O000D00B66O000B000D00024O000A000A000B2O0036000A001A4O009F000A00013O00208C000A000A00B14O000C00023O00202O000C000C00B24O000A000C000200062O000A00B703013O0004F33O00B703012O009F000A00024O0031000B000F3O00122O000C00B73O00122O000D00B86O000B000D00024O000A000A000B000672000A00BD030100010004F33O00BD03012O009F000A00024O0031000B000F3O00122O000C00B93O00122O000D00BA6O000B000D00024O000A000A000B2O0036000A001B3O0012A0000900043O00262001090090030100040004F33O009003010012A0000800053O0004F33O00C403010004F33O0090030100262001080022040100010004F33O002204010012A0000900013O0026A9000900CB030100040004F33O00CB0301002E5000BB0004000100BC0004F33O00CD03010012A0000800043O0004F33O00220401002620010900C7030100010004F33O00C703010012A0000A00014O00BE000B000C3O0026A9000A00D5030100010004F33O00D50301002E1601BD00D8030100BE0004F33O00D803010012A0000B00014O00BE000C000C3O0012A0000A00043O002620010A00D1030100040004F33O00D10301002ED000BF00DA030100C00004F33O00DA0301002620010B00DA030100010004F33O00DA03010012A0000C00013O002620010C00DF030100010004F33O00DF03012O009F000D001D4O000A000D000D6O000D001C6O000D001F6O000D000D6O000D001E3O00044O000A04010004F33O00DF03010004F33O000A04010004F33O00DA03010004F33O000A04010004F33O00D103010004F33O000A04010012A0000A00014O00BE000B000C3O002620010A002O040100040004F33O002O04010026A9000B00F6030100010004F33O00F60301002E5000C100FEFF2O00C20004F33O00F203010012A0000C00013O0026A9000C00FB030100010004F33O00FB0301002ED000C300F7030100C40004F33O00F703010012A0000D00044O0036000D001E3O0012A0000D00044O0036000D001C3O0004F33O000A04010004F33O00F703010004F33O000A04010004F33O00F203010004F33O000A0401000E242O0100F00301000A0004F33O00F003010012A0000B00014O00BE000C000C3O0012A0000A00043O0004F33O00F003012O009F000A00013O00208C000A000A00B14O000C00023O00202O000C000C00B24O000A000C000200062O000A001904013O0004F33O001904012O009F000A00024O0031000B000F3O00122O000C00C53O00122O000D00C66O000B000D00024O000A000A000B000672000A001F040100010004F33O001F04012O009F000A00024O0031000B000F3O00122O000C00C73O00122O000D00C86O000B000D00024O000A000A000B2O0036000A00203O0012A0000900043O0004F33O00C703010026200108008B030100050004F33O008B03012O009F000900013O00205E00090009000A4O000B00023O00202O000B000B00C94O0009000B00024O000900213O00122O000100093O00044O002F04010004F33O008B03010004F33O002F04010004F33O00860301000E24016B000A000100010004F33O000A00010012A0000700014O00BE000800083O000E2800010037040100070004F33O00370401002E5000CA00FEFF2O00CB0004F33O003304010012A0000800013O0026A90008003C040100040004F33O003C0401002E5000CC000D000100CD0004F33O004704012O009F000900013O0020E80009000900CF00122O000B00D06O0009000B000200122O000900CE6O000900013O00202O0009000900D100122O000B00D26O0009000B00024O0009001D3O00122O000800053O00262001080088040100010004F33O008804012O009F000900013O0020600009000900D32O00E40009000200020006620009005004013O0004F33O00500401002E1601D40053040100D50004F33O005304010012C5000900D64O00E90009000100022O0036000900223O002ED000D80087040100D70004F33O0087040100067200020087040100010004F33O008704012O009F000900013O00206000090009000D2O00E400090002000200067200090062040100010004F33O006204012O009F000900083O00067200090062040100010004F33O006204012O009F000900233O0006620009008704013O0004F33O008704010012A0000900014O00BE000A000A3O002E1601D9007C040100DA0004F33O007C04010026200109007C040100010004F33O007C04012O009F000B00233O000698000A00740401000B0004F33O007404012O009F000B00024O0083000C000F3O00122O000D00DB3O00122O000E00DC6O000C000E00024O000B000B000C00202O000B000B00704O000B000200024O000A000B4O009F000B00173O002022010B000B00DD4O000C000A6O000D000F3O00122O001000DE6O000B0010000200122O000B00133O00122O000900043O002ED000E00064040100DF0004F33O0064040100262001090064040100040004F33O006404010012C5000B00133O000662000B008704013O0004F33O008704010012C5000B00134O0013010B00023O0004F33O008704010004F33O006404010012A0000800043O0026A90008008C040100050004F33O008C0401002E5000E100AEFF2O00E20004F33O003804012O009F000900013O0020100109000900D100122O000B00E36O0009000B00024O0009001F3O00122O000100743O00044O000A00010004F33O003804010004F33O000A00010004F33O003304010004F33O000A00010004F33O00A20401002620012O009C040100050004F33O009C04012O00BE000500063O0012A03O00063O002620012O0002000100010004F33O000200010012A0000100014O00BE000200023O0012A03O00043O0004F33O000200012O0003012O00017O000F3O00028O00025O00689D40025O00805840025O00CAB040025O00C9B040026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03263O009EEB09E5ECAAEE13E8E0FAD208EFE0A9F65ADEA5ACA24BB6ABE8AC4AB6A598FB5AC4EAB5EF3103053O0085DA827A86025O0034A140025O0068B34003053O005072696E74031F3O00FA826C3C2B36D282713A6216CC827A2C3666DC923F1A322FDDCB5D302D2BF503063O0046BEEB1F5F4200253O0012A03O00014O00BE000100013O0026A93O0006000100010004F33O00060001002ED000020002000100030004F33O000200010012A0000100013O002E1601050013000100040004F33O001300010026202O010013000100060004F33O001300010012C5000200073O00201A0102000200084O00035O00122O000400093O00122O0005000A6O000300056O00023O000100044O00240001002E16010B00070001000C0004F33O000700010026202O010007000100010004F33O000700012O009F000200014O00A80002000100014O000200023O00202O00020002000D4O00035O00122O0004000E3O00122O0005000F6O000300056O00023O000100122O000100063O00044O000700010004F33O002400010004F33O000200012O0003012O00017O00", GetFEnv(), ...);

