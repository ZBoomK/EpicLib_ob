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
				if (Enum <= 151) then
					if (Enum <= 75) then
						if (Enum <= 37) then
							if (Enum <= 18) then
								if (Enum <= 8) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum > 0) then
												local A;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
										elseif (Enum > 2) then
											if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
												Stk[Inst[2]] = Env;
											else
												Stk[Inst[2]] = Env[Inst[3]];
											end
										else
											Stk[Inst[2]]();
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
									elseif (Enum <= 6) then
										if (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 7) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
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
											for Idx = Inst[2], Inst[3] do
												Stk[Idx] = nil;
											end
										end
									elseif (Enum <= 11) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 12) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 15) then
									if (Enum > 14) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								elseif (Enum == 17) then
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
								end
							elseif (Enum <= 27) then
								if (Enum <= 22) then
									if (Enum <= 20) then
										if (Enum == 19) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum == 21) then
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
									elseif (Stk[Inst[2]] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 24) then
									if (Enum == 23) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Stk[Inst[3]];
									end
								elseif (Enum <= 25) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 26) then
									Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
							elseif (Enum <= 32) then
								if (Enum <= 29) then
									if (Enum == 28) then
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
										local B = Stk[Inst[4]];
										if not B then
											VIP = VIP + 1;
										else
											Stk[Inst[2]] = B;
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 30) then
									VIP = Inst[3];
								elseif (Enum == 31) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 34) then
								if (Enum > 33) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 35) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum == 36) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 56) then
							if (Enum <= 46) then
								if (Enum <= 41) then
									if (Enum <= 39) then
										if (Enum > 38) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 40) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
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
								elseif (Enum <= 43) then
									if (Enum > 42) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = {};
									end
								elseif (Enum <= 44) then
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
								elseif (Enum > 45) then
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
									local B;
									local A;
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
							elseif (Enum <= 51) then
								if (Enum <= 48) then
									if (Enum > 47) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 49) then
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 50) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 53) then
								if (Enum == 52) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 54) then
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
							elseif (Enum == 55) then
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
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 65) then
							if (Enum <= 60) then
								if (Enum <= 58) then
									if (Enum == 57) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 59) then
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
							elseif (Enum <= 62) then
								if (Enum > 61) then
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
							elseif (Enum <= 63) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 64) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
						elseif (Enum <= 70) then
							if (Enum <= 67) then
								if (Enum > 66) then
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
							elseif (Enum <= 68) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 69) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 72) then
							if (Enum == 71) then
								if (Inst[2] ~= Stk[Inst[4]]) then
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
						elseif (Enum <= 73) then
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
						elseif (Enum == 74) then
							local B;
							local A;
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 113) then
						if (Enum <= 94) then
							if (Enum <= 84) then
								if (Enum <= 79) then
									if (Enum <= 77) then
										if (Enum > 76) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 81) then
									if (Enum == 80) then
										if (Stk[Inst[2]] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
									end
								elseif (Enum <= 82) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 83) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 89) then
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
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 87) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 88) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
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
								if (Enum == 90) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 92) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							elseif (Enum == 93) then
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 103) then
							if (Enum <= 98) then
								if (Enum <= 96) then
									if (Enum == 95) then
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
								elseif (Enum > 97) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 100) then
								if (Enum == 99) then
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
							elseif (Enum <= 101) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 102) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 108) then
							if (Enum <= 105) then
								if (Enum > 104) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 106) then
								local B;
								local A;
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
								A = Inst[2];
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
							elseif (Enum > 107) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							else
								local A;
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
						elseif (Enum <= 110) then
							if (Enum > 109) then
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
						elseif (Enum <= 111) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 112) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						else
							local Edx;
							local Results, Limit;
							local A;
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 132) then
						if (Enum <= 122) then
							if (Enum <= 117) then
								if (Enum <= 115) then
									if (Enum > 114) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum == 116) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 119) then
								if (Enum > 118) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 120) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum == 121) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 127) then
							if (Enum <= 124) then
								if (Enum > 123) then
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
							elseif (Enum <= 125) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 126) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 129) then
							if (Enum > 128) then
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							end
						elseif (Enum <= 130) then
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
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 131) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 136) then
							if (Enum <= 134) then
								if (Enum > 133) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum == 135) then
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
						elseif (Enum <= 138) then
							if (Enum == 137) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 139) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						elseif (Enum == 140) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 146) then
						if (Enum <= 143) then
							if (Enum > 142) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 144) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 145) then
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
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 149) then
						local A = Inst[2];
						do
							return Unpack(Stk, A, Top);
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					if (Enum <= 189) then
						if (Enum <= 170) then
							if (Enum <= 160) then
								if (Enum <= 155) then
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
										elseif (Inst[2] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 154) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									if (Enum > 156) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 158) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								elseif (Enum == 159) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 165) then
								if (Enum <= 162) then
									if (Enum == 161) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
										Stk[A] = Stk[A]();
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
								elseif (Enum <= 163) then
									local B;
									local A;
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 164) then
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
								elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 167) then
								if (Enum == 166) then
									local B;
									local Edx;
									local Results, Limit;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum == 169) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
								end
							end
						elseif (Enum <= 179) then
							if (Enum <= 174) then
								if (Enum <= 172) then
									if (Enum == 171) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Inst[2] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 173) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 176) then
								if (Enum == 175) then
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
							elseif (Enum <= 177) then
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							elseif (Enum > 178) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 184) then
							if (Enum <= 181) then
								if (Enum > 180) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 182) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
							elseif (Enum > 183) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 186) then
							if (Enum > 185) then
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
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
							end
						elseif (Enum <= 187) then
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
						elseif (Enum > 188) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[A] = B[Inst[4]];
						end
					elseif (Enum <= 208) then
						if (Enum <= 198) then
							if (Enum <= 193) then
								if (Enum <= 191) then
									if (Enum == 190) then
										if (Inst[2] > Stk[Inst[4]]) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									end
								elseif (Enum == 192) then
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
							elseif (Enum <= 195) then
								if (Enum == 194) then
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum == 197) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 203) then
							if (Enum <= 200) then
								if (Enum == 199) then
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Enum <= 201) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 202) then
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
						elseif (Enum <= 205) then
							if (Enum == 204) then
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							end
						elseif (Enum <= 206) then
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
							Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 207) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 217) then
						if (Enum <= 212) then
							if (Enum <= 210) then
								if (Enum > 209) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 211) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 214) then
							if (Enum > 213) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							else
								local A;
								A = Inst[2];
								Stk[A] = Stk[A]();
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
							end
						elseif (Enum <= 215) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 216) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 222) then
						if (Enum <= 219) then
							if (Enum > 218) then
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
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
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum <= 220) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 221) then
							Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
						else
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 224) then
						if (Enum == 223) then
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						else
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 225) then
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
						if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						do
							return Stk[Inst[2]];
						end
					end
				elseif (Enum <= 265) then
					if (Enum <= 246) then
						if (Enum <= 236) then
							if (Enum <= 231) then
								if (Enum <= 229) then
									if (Enum == 228) then
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
								elseif (Enum == 230) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 233) then
								if (Enum == 232) then
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
								end
							elseif (Enum <= 234) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 235) then
								local B;
								local A;
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 241) then
							if (Enum <= 238) then
								if (Enum > 237) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								else
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
								end
							elseif (Enum <= 239) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum > 240) then
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 243) then
							if (Enum > 242) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 244) then
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 245) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, A + Inst[3]);
							end
						else
							Env[Inst[3]] = Stk[Inst[2]];
						end
					elseif (Enum <= 255) then
						if (Enum <= 250) then
							if (Enum <= 248) then
								if (Enum == 247) then
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
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 252) then
							if (Enum == 251) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							end
						elseif (Enum <= 253) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 254) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
								if (Mvm[1] == 24) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						end
					elseif (Enum <= 260) then
						if (Enum <= 257) then
							if (Enum > 256) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 258) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum == 259) then
							do
								return Stk[Inst[2]]();
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 262) then
						if (Enum > 261) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 263) then
						local B;
						local A;
						A = Inst[2];
						Stk[A] = Stk[A]();
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
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 264) then
						Stk[Inst[2]] = Inst[3] ~= 0;
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 284) then
					if (Enum <= 274) then
						if (Enum <= 269) then
							if (Enum <= 267) then
								if (Enum == 266) then
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
							elseif (Enum == 268) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 271) then
							if (Enum == 270) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
						elseif (Enum <= 272) then
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
						elseif (Enum > 273) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						end
					elseif (Enum <= 279) then
						if (Enum <= 276) then
							if (Enum == 275) then
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
						elseif (Enum <= 277) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 278) then
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
						else
							local A;
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A]();
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 281) then
						if (Enum > 280) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 282) then
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
						Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum == 283) then
						if (Inst[2] == Inst[4]) then
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
				elseif (Enum <= 293) then
					if (Enum <= 288) then
						if (Enum <= 286) then
							if (Enum > 285) then
								local B;
								local A;
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
						elseif (Enum == 287) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 290) then
						if (Enum == 289) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						else
							local B = Inst[3];
							local K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
						end
					elseif (Enum <= 291) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 292) then
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
				elseif (Enum <= 298) then
					if (Enum <= 295) then
						if (Enum == 294) then
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
							do
								return;
							end
						end
					elseif (Enum <= 296) then
						local A = Inst[2];
						Stk[A] = Stk[A]();
					elseif (Enum == 297) then
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
						A = Inst[2];
						Stk[A] = Stk[A]();
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 300) then
					if (Enum == 299) then
						local Edx;
						local Results, Limit;
						local A;
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
				elseif (Enum <= 301) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 302) then
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD99ED111DAC6C91AC2BED11FC2D7DA31EFB4C950DDD6DA03083O007EB1A3BB4586DBA7031B3O00A647D90D621A9558DB104F00A752C6144E2B8243D91A53718F42D103063O005FE337B0753D002E3O0012F73O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A0001000100041E3O000A0001001203000300063O00202F000400030007001203000500083O00202F000500050009001203000600083O00202F00060006000A0006FE00073O000100062O00183O00064O00188O00183O00044O00183O00014O00183O00024O00183O00053O00202F00080003000B00202F00090003000C2O002A000A5O001203000B000D3O0006FE000C0001000100022O00183O000A4O00183O000B4O0018000D00073O001231000E000E3O001231000F000F4O0093000D000F00020006FE000E0002000100032O00183O00074O00183O00094O00183O00084O008A000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O001C01025O00122O000300016O00045O00122O000500013O00042O0003002100012O00AE00076O0037000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004E70003000500012O00AE000300054O0018000400024O006C000300044O009500036O0027012O00017O000F3O00028O00026O00F03F025O0020AC40025O00EC9A40025O008EA940025O00849940025O003EA840025O0072A640025O0026AC40025O00A88640025O0036A640025O00C06540025O00A6A340025O003BB140025O00909F4001503O001231000200014O00D6000300053O002616000200470001000200041E3O004700012O00D6000500053O0026160003003E0001000200041E3O003E0001001231000600014O00D6000700073O002616000600090001000100041E3O00090001001231000700013O00260D000700100001000100041E3O00100001002E990003000C0001000400041E3O000C0001002616000400300001000100041E3O00300001001231000800014O00D6000900093O002E99000600140001000500041E3O00140001002616000800140001000100041E3O00140001001231000900013O002616000900270001000100041E3O002700012O00AE000A6O00800005000A3O002E99000800260001000700041E3O002600010006C0000500260001000100041E3O002600012O00AE000A00014O0018000B6O00AA000C6O0023000A6O0095000A5O001231000900023O00260D0009002B0001000200041E3O002B0001002E1B010900F0FF2O000A00041E3O00190001001231000400023O00041E3O0030000100041E3O0019000100041E3O0030000100041E3O00140001002E1B010B00D7FF2O000B00041E3O00070001002616000400070001000200041E3O000700012O0018000800054O00AA00096O002300086O009500085O00041E3O0007000100041E3O000C000100041E3O0007000100041E3O0009000100041E3O0007000100041E3O004F000100260D000300420001000100041E3O00420001002E99000D00050001000C00041E3O00050001001231000400014O00D6000500053O001231000300023O00041E3O0005000100041E3O004F0001002E99000F00020001000E00041E3O00020001002616000200020001000100041E3O00020001001231000300014O00D6000400043O001231000200023O00041E3O000200012O0027012O00017O005B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C2018852O033O00CC52B303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C03043O009857DAB403083O00A1DB36A9C05A3050030B3O006A431331794D0F29404C0703043O0045292260030D3O009FC2C41E2325B2CCC30B162EB803063O004BDCA3B76A62030D3O0021BB9823EA17BD8C32CA16BF8F03053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03063O0029D851797B6503083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC503043O006D6174682O033O005B294703073O009836483F58453E03063O00F1D2E157D1D603043O003CB4A48E030B3O007C5B132834F9134C570A2703073O0072383E6549478D03063O009DFFD4CFBDFB03043O00A4D889BB030B3O00F6E327B3B5EA0AC6EF3EBC03073O006BB28651D2C69E03063O001D188DCDAF2A03053O00CA586EE2A6030B3O00E70A94F6D9D70E96FEC5CD03053O00AAA36FE29703073O00323FBF3541393A03073O00497150D2582E5703083O00A43AC800FE8E22C803053O0087E14CAD72030C3O0047657445717569706D656E74026O002A40028O00026O002C4003113O003FFEABB5A2BEA23BF9ACA5A2B8AA1FE3AC03073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65027O0040026O00F03F026O001040030C3O008FD111E36CD0B8CF1EF17BF303063O0096CDBD709018030A3O0054616C656E7452616E6B024O0080B3C54003103O005265676973746572466F724576656E7403183O009D5498B9169F479CB106844894A51D99479AA812835F9CA403053O0053CD18D9E0030E3O00D67E5526C97D4F29CD6F5E2DC06A03043O006A852E1003143O00740552CE74657C1F40CC7F6C741F5AD26574790203063O00203840139C3A03143O00697A6AC450B4B8397C716ED34AA3A92A7B7A6ED903083O006B39362B9D15E6E703063O0053657441504C025O00EC964000F4013O00262O0100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O0012BB000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O0012BB0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O0012BB000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O001231000D00123O001231000E00134O0093000C000E00022O0080000C0004000C001211010D00046O000E5O00122O000F00143O00122O001000156O000E001000024O000E000D000E4O000F5O00122O001000163O00122O001100176O000F001100022O005D000F000D000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000D00104O00115O00122O0012001A3O00122O0013001B6O0011001300022O005D0011000D00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000D00124O00135O00122O0014001E3O00122O0015001F6O0013001500022O00800013000D00132O00AE00145O001231001500203O001231001600214O00930014001600022O00800014000D00142O00AE00155O001216011600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0015000D00154O00165O00122O001700263O00122O001800276O0016001800024O0015001500164O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B6O0016001800024O0016000D00164O00175O00122O0018002C3O00122O0019002D6O0017001900024O0016001600174O00175O00122O0018002E3O00122O0019002F6O0017001900024O00160016001700122O001700306O00185O00122O001900313O00122O001A00326O0018001A00024O0017001700184O00185O00122O001900333O00122O001A00346O0018001A00024O0018000B00184O00195O00122O001A00353O00122O001B00366O0019001B00024O0018001800194O00195O00122O001A00373O00122O001B00386O0019001B00024O0019000C00194O001A5O00122O001B00393O00122O001C003A6O001A001C00024O00190019001A4O001A5O00122O001B003B3O00122O001C003C6O001A001C00024O001A0013001A4O001B5O00122O001C003D3O00122O001D003E6O001B001D00024O001A001A001B4O001B8O001C5O00122O001D003F3O00122O001E00406O001C001E00024O001C000D001C4O001D5O00122O001E00413O00122O001F00426O001D001F00022O0080001C001C001D2O006A001D8O001E8O001F8O00208O00218O0022003C3O00202O003D000700434O003D0002000200202O003E003D004400062O003E00B200013O00041E3O00B200012O0018003E000C3O00202F003F003D00442O00C7003E000200020006C0003E00B50001000100041E3O00B500012O0018003E000C3O001231003F00454O00C7003E0002000200202F003F003D0046000638003F00BD00013O00041E3O00BD00012O0018003F000C3O00202F0040003D00462O00C7003F000200020006C0003F00C00001000100041E3O00C000012O0018003F000C3O001231004000454O00C7003F000200022O00D6004000424O006700435O00122O004400473O00122O004500486O0043004500024O00430018004300202O0043004300494O00430002000200062O004300CD00013O00041E3O00CD00010012310043004A3O0006C0004300CE0001000100041E3O00CE00010012310043004B3O0012310044004A4O00090045004A3O00122O004B004C3O00122O004C00446O004D5O00122O004E004D3O00122O004F004E6O004D004F00024O004D0018004D00202O004D004D004F4O004D000200024O004E004F3O00122O005000503O00122O005100506O005200533O00122O005400453O00122O005500453O00122O0056004B3O00122O0057004B6O005800583O0006FE00593O000100022O00AE8O00183O00063O0020BC005A000400510006FE005C0001000100052O00183O003F4O00183O003D4O00183O000C4O00183O00074O00183O003E4O001F015D5O00122O005E00523O00122O005F00536O005D005F6O005A3O000100202O005A000400510006FE005C0002000100042O00183O00434O00183O00184O00AE8O00183O004D4O00AE005D5O001231005E00543O001231005F00554O0093005D005F00022O001F015E5O00122O005F00563O00122O006000576O005E00606O005A3O000100202O005A000400510006FE005C0003000100042O00183O00504O00183O00514O00183O00144O00AE8O0064005D5O00122O005E00583O00122O005F00596O005D005F6O005A3O00010006FE005A0004000100042O00183O00184O00AE8O00183O00144O00183O00083O0006FE005B00050001000E2O00183O004F4O00183O004E4O00183O00184O00AE8O00183O00124O00183O00084O00183O00534O00183O003B4O00183O00094O00183O00584O00183O000E4O00183O001A4O00183O001C4O00183O003C3O0006FE005C0006000100102O00183O00184O00AE8O00183O00074O00183O00374O00183O00364O00183O00124O00183O00194O00183O002C4O00183O002D4O00183O001A4O00183O00354O00183O00344O00183O000E4O00183O00264O00183O00284O00183O00273O0006FE005D00070001000C2O00183O00494O00183O00424O00183O00074O00183O00184O00183O004A4O00183O00154O00AE8O00183O00524O00183O00514O00183O001C4O00183O001B4O00183O001F3O0006FE005E00080001000D2O00183O00564O00183O00544O00183O00124O00183O00184O00183O00084O00AE8O00183O00424O00183O00154O00183O004A4O00183O004E4O00183O00494O00AE3O00014O00AE3O00023O0006FE005F00090001000B2O00183O00184O00AE8O00183O00084O00183O00104O00183O00554O00183O00494O00183O00424O00183O004A4O00183O004E4O00183O005A4O00183O00573O0006FE0060000A000100142O00183O00184O00AE8O00183O001F4O00183O00494O00183O001C4O00183O00124O00183O001A4O00183O00084O00183O00074O00183O00434O00183O00534O00183O00424O00183O005A4O00183O00514O00183O00154O00183O00484O00183O004B4O00183O004F4O00183O005F4O00183O005E3O0006FE0061000B000100162O00183O00184O00AE8O00183O005A4O00183O00074O00183O00424O00183O00124O00183O00084O00183O00494O00183O004A4O00183O00434O00183O00524O00183O00534O00183O001F4O00183O00514O00183O001C4O00183O001A4O00183O00484O00183O004C4O00183O004F4O00183O005F4O00183O005E4O00183O00153O0006FE0062000C0001000A2O00183O00224O00AE8O00183O00184O00183O00074O00183O00244O00183O000E4O00183O001A4O00183O00094O00183O00234O00183O00253O0006FE0063000D000100082O00183O00184O00AE8O00183O00334O00183O001C4O00183O00084O00183O00124O00183O00094O00183O001A3O0006FE0064000E0001001C2O00183O00324O00AE8O00183O00334O00183O00344O00183O00354O00183O00224O00183O00234O00183O00244O00183O00254O00183O002E4O00183O002F4O00183O00304O00183O00314O00183O00284O00183O00294O00183O00264O00183O00274O00183O00384O00183O00394O00183O00364O00183O00374O00183O003A4O00183O003B4O00183O003C4O00183O002A4O00183O002B4O00183O002C4O00183O002D3O0006FE0065000F000100352O00183O00644O00183O001D4O00AE8O00183O001E4O00183O001F4O00183O00204O00183O00214O00183O00074O00183O002A4O00183O00184O00183O001C4O00183O001A4O00183O00594O00183O00094O00183O00584O00183O003B4O00183O00224O00183O00234O00183O005C4O00183O000E4O00183O003C4O00183O002E4O00183O002F4O00183O00624O00183O00384O00183O00394O00183O00124O00183O005D4O00183O00424O00183O00604O00183O00614O00183O00484O00183O00174O00183O00524O00183O00084O00183O002B4O00183O00634O00183O004E4O00183O00514O00183O00044O00183O00404O00183O00504O00AE3O00014O00AE3O00024O00183O00574O00183O00564O00183O00534O00183O00414O00183O00294O00183O004F4O00183O00494O00183O004A4O00183O005B3O0006FE00660010000100032O00183O001C4O00AE8O00183O000D3O0020CF0067000D005A00122O0068005B6O006900656O006A00666O0067006A00016O00013O00113O00203O00028O00025O000C9540026O00F03F025O006DB140027O0040025O00F4B040025O0070A64003053O00706169727303063O0045786973747303163O00556E697447726F7570526F6C6573412O7369676E656403063O006FE914F0217503053O006427AC55BC025O00C08140025O003EA140025O009AAD40025O00F88A40025O00C06D40025O0085B340025O00BDB040025O00B6AD40030A3O00556E6974496E5261696403063O003588BE55019A03083O007045E4DF2C64E87103043O00E61E0ED703073O00E6B47F67B3D61C030B3O00556E6974496E506172747903063O009C095E5FE15303073O0080EC653F26842103053O009CA80350AF03073O00AFCCC97124D68B025O00E0A440025O002EB340007B3O0012313O00014O00D6000100033O002E1B010200720001000200041E3O007400010026163O00740001000300041E3O007400012O00D6000300033O000EAC0003002B0001000100041E3O002B0001001231000400013O002E1B010400060001000400041E3O00100001002616000400100001000300041E3O00100001001231000100053O00041E3O002B000100260D000400140001000100041E3O00140001002E1B010600F8FF2O000700041E3O000A00012O00D6000300033O001203000500084O0018000600024O00DD00050002000700041E3O002700010020BC000A000900092O00C7000A00020002000638000A002700013O00041E3O00270001001203000A000A4O0018000B00084O00C7000A000200022O003B000B5O00122O000C000B3O00122O000D000C6O000B000D000200062O000A00270001000B00041E3O002700012O0018000300093O000605000500190001000200041E3O00190001001231000400033O00041E3O000A0001002E99000D00300001000E00041E3O00300001002616000100300001000500041E3O003000012O00E3000300023O00260D000100340001000100041E3O00340001002E99000F00070001001000041E3O00070001001231000400014O00D6000500053O002616000400360001000100041E3O00360001001231000500013O002E060011006B0001001200041E3O006B00010026160005006B0001000100041E3O006B0001001231000600013O002616000600640001000100041E3O006400012O00D6000200023O002E06001400520001001300041E3O00520001001203000700154O00E800085O00122O000900163O00122O000A00176O0008000A6O00073O000200062O0007005200013O00041E3O005200012O00AE000700014O004600085O00122O000900183O00122O000A00196O0008000A00024O00020007000800044O006300010012030007001A4O00E800085O00122O0009001B3O00122O000A001C6O0008000A6O00073O000200062O0007006100013O00041E3O006100012O00AE000700014O004600085O00122O0009001D3O00122O000A001E6O0008000A00024O00020007000800044O006300012O000901076O00E3000700023O001231000600033O002E06001F003E0001002000041E3O003E00010026160006003E0001000300041E3O003E0001001231000500033O00041E3O006B000100041E3O003E0001002616000500390001000300041E3O00390001001231000100033O00041E3O0007000100041E3O0039000100041E3O0007000100041E3O0036000100041E3O0007000100041E3O007A00010026163O00020001000100041E3O00020001001231000100014O00D6000200023O0012313O00033O00041E3O000200012O0027012O00017O00073O00028O00026O00F03F026O002C40025O0018A740025O0001B140030C3O0047657445717569706D656E74026O002A4000393O0012313O00014O00D6000100013O0026163O00020001000100041E3O00020001001231000100013O002616000100160001000200041E3O001600012O00AE000200013O00202F0002000200030006380002001100013O00041E3O001100012O00AE000200024O00AE000300013O00202F0003000300032O00C70002000200020006C0000200140001000100041E3O001400012O00AE000200023O001231000300014O00C70002000200022O001000025O00041E3O0038000100260D0001001A0001000100041E3O001A0001002E06000500050001000400041E3O00050001001231000200013O0026160002001F0001000200041E3O001F0001001231000100023O00041E3O000500010026160002001B0001000100041E3O001B00012O00AE000300033O0020110003000300064O0003000200024O000300016O000300013O00202O00030003000700062O0003002F00013O00041E3O002F00012O00AE000300024O00AE000400013O00202F0004000400072O00C70003000200020006C0000300320001000100041E3O003200012O00AE000300023O001231000400014O00C70003000200022O0010000300043O001231000200023O00041E3O001B000100041E3O0005000100041E3O0038000100041E3O000200012O0027012O00017O00083O0003113O00C3D6DE38E8C6C81CF2D1D833E32OC833F203043O005D86A5AD030B3O004973417661696C61626C65027O0040026O00F03F030C3O009CFEC0D12EE8A76CB0F3C2C703083O001EDE92A1A25AAED2030A3O0054616C656E7452616E6B00194O000F3O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O000D00013O00041E3O000D00010012313O00043O0006C03O000E0001000100041E3O000E00010012313O00054O00108O0004012O00016O000100023O00122O000200063O00122O000300076O0001000300028O000100206O00086O000200026O00038O00017O00103O00028O00025O009CAB40025O0062A040025O006EA940025O00B08040024O0080B3C540026O00F03F025O009EB040025O006CB140025O0035B240025O0035B14003053O00706169727303103O004669726573746F726D547261636B657203103O007CC1F75349E68F48C5D1445BF18B5FDA03073O00E03AA885363A922O00333O0012313O00013O002E06000300200001000200041E3O002000010026163O00200001000100041E3O00200001001231000100013O002E99000500190001000400041E3O00190001000EAC000100190001000100041E3O00190001001231000200013O002616000200120001000100041E3O00120001001231000300064O001000035O001231000300064O0010000300013O001231000200073O002E060008000B0001000900041E3O000B00010026160002000B0001000700041E3O000B0001001231000100073O00041E3O0019000100041E3O000B0001000E470007001D0001000100041E3O001D0001002E99000A00060001000B00041E3O000600010012313O00073O00041E3O0020000100041E3O00060001000EAC0007000100013O00041E3O000100010012030001000C4O00AE000200023O00202F00020002000D2O00DD00010002000300041E3O002E00012O00AE000500024O000E010600033O00122O0007000E3O00122O0008000F6O0006000800024O00050005000600202O000500040010000605000100270001000100041E3O0027000100041E3O0032000100041E3O000100012O0027012O00017O00123O00028O00026O00F03F025O00DFB140025O005C9E4003093O00FD8203F0AAC8C0C98603073O00AFBBEB7195D9BC03113O0054696D6553696E63654C61737443617374026O00284003103O001AA69349F06D772EA2B55EE27A7339BD03073O00185CCFE12C831903043O0047554944025O00607440025O00C4914003103O006DDAAA49086944C1B578097C48D8BD5E03063O001D2BB3D82C7B03073O0047657454696D65026O000440025O0010944000423O0012313O00013O0026163O00050001000200041E3O000500012O00092O016O00E3000100023O000EAC0001000100013O00041E3O00010001001231000100013O002616000100390001000100041E3O00390001002E99000400180001000300041E3O001800012O00AE00026O0078000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O000200020002000E2O000800180001000200041E3O001800012O000901026O00E3000200024O00AE000200024O002O010300013O00122O000400093O00122O0005000A6O0003000500024O0002000200034O000300033O00202O00030003000B4O0003000200024O00020002000300062O000200260001000100041E3O00260001002E06000D00380001000C00041E3O003800012O00AE000200024O002A010300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000300033O00202O00030003000B4O0003000200024O00020002000300122O000300106O00030001000200202O00030003001100062O000200360001000300041E3O0036000100041E3O003800012O0009010200014O00E3000200023O001231000100023O002E1B011200CFFF2O001200041E3O00080001002616000100080001000200041E3O000800010012313O00023O00041E3O0001000100041E3O0008000100041E3O000100012O0027012O00017O00403O00028O00026O00A840025O00C4AA40026O00F03F025O0088AF40025O0017B140027O0040025O00B0AE4003093O00045125DDCD00E9305503073O0086423857B8BE74030A3O0049734361737461626C6503093O004669726573746F726D03093O004973496E52616E6765026O00394003133O003A381BBE0AFF2E27317119A91CE82E383E301D03083O00555C5169DB798B41025O008AA440025O007AA740030B3O00D1BA464C72D8DBBF51487903063O00BF9DD330251C03093O00F916E61929CB10E61103053O005ABF7F947C030B3O004973417661696C61626C65025O0078A440025O00607A40030B3O004C6976696E67466C616D6503163O00748E381E76802O117486231238973C127B882315799303043O007718E74E025O00A09D40025O00049D40030B3O00A337B058D973059024AE4F03073O0071E24DC52ABC20030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E676503163O003B0CE1A73F29E7A1281FFFB07A06E6B03919F9B73B0203043O00D55A7694025O00E89640025O00C07E4003043O009CCC344303043O002CDDB940030D3O0032E85D4D7004E84E2O7206EE4B03053O00136187283F03043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C0724003123O00536F757263656F664D61676963466F63757303193O00BD5326292C34915335042230A955307B3F23AB5F3C362D30BA03063O0051CE3C535B4F03083O007DAEDC772CD748A003083O00C42ECBB0124FA32D025O00208B40025O001AAE4003093O004E616D6564556E6974030D3O008B2D6B0C27FEE0BE0F7F192DF803073O008FD8421E7E449B03113O00536F757263656F664D616769634E616D65025O005C9C40025O006DB24003193O00B9C718D9C6A6E8EEACF700CAC2AAD4A1BADA08C8CAAED5E0BE03083O0081CAA86DABA5C3B7025O00AEAC40026O006B40025O00C071400017012O0012313O00014O00D6000100013O00260D3O00060001000100041E3O00060001002E99000300020001000200041E3O00020001001231000100013O00260D0001000B0001000400041E3O000B0001002E060006003A0001000500041E3O003A0001001231000200014O00D6000300033O0026160002000D0001000100041E3O000D0001001231000300013O002616000300140001000400041E3O00140001001231000100073O00041E3O003A0001002616000300100001000100041E3O001000012O00AE000400013O0010EE0004000400042O001000045O002E1B0108001D0001000800041E3O003600012O00AE000400024O0067000500033O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000200062O0004003600013O00041E3O003600012O00AE000400044O0063000500023O00202O00050005000C4O000600053O00202O00060006000D00122O0008000E6O0006000800024O000600066O000700066O00040007000200062O0004003600013O00041E3O003600012O00AE000400033O0012310005000F3O001231000600104O006C000400064O009500045O001231000300043O00041E3O0010000100041E3O003A000100041E3O000D000100260D0001003E0001000700041E3O003E0001002E99001200830001001100041E3O008300012O00AE000200024O0067000300033O00122O000400133O00122O000500146O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005200013O00041E3O005200012O00AE000200024O0067000300033O00122O000400153O00122O000500166O0003000500024O00020002000300202O0002000200174O00020002000200062O0002005400013O00041E3O00540001002E99001800650001001900041E3O006500012O00AE000200044O0063000300023O00202O00030003001A4O000400053O00202O00040004000D00122O0006000E6O0004000600024O000400046O000500066O00020005000200062O0002006500013O00041E3O006500012O00AE000200033O0012310003001B3O0012310004001C4O006C000200044O009500025O002E06001E00162O01001D00041E3O00162O012O00AE000200024O0067000300033O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200162O013O00041E3O00162O012O00AE000200044O0043000300023O00202O0003000300214O000400053O00202O0004000400224O000600023O00202O0006000600214O0004000600024O000400046O00020004000200062O000200162O013O00041E3O00162O012O00AE000200033O001200010300233O00122O000400246O000200046O00025O00044O00162O01002616000100070001000100041E3O00070001001231000200013O0026160002008A0001000400041E3O008A0001001231000100043O00041E3O00070001002E99002600860001002500041E3O00860001002616000200860001000100041E3O008600012O00AE000300074O00C5000400033O00122O000500273O00122O000600286O00040006000200062O000300960001000400041E3O0096000100041E3O00BE00012O00AE000300024O0067000400033O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300BE00013O00041E3O00BE00012O00AE000300083O0020BC00030003000D0012310005000E4O0093000300050002000638000300BE00013O00041E3O00BE00012O00AE000300094O00AE000400083O0020BC00040004002B2O00C70004000200020006A5000300BE0001000400041E3O00BE00012O00AE000300083O00203200030003002C4O000500023O00202O00050005002D4O00030005000200262O000300BE0001002E00041E3O00BE00012O00AE0003000A4O00AE0004000B3O00202F00040004002F2O00C7000300020002000638000300BE00013O00041E3O00BE00012O00AE000300033O001231000400303O001231000500314O006C000300054O009500036O00AE000300074O003B000400033O00122O000500323O00122O000600336O00040006000200062O000300112O01000400041E3O00112O01001231000300014O00D6000400063O002616000300CC0001000100041E3O00CC0001001231000400014O00D6000500053O001231000300043O002616000300C70001000400041E3O00C700012O00D6000600063O002E06003400FD0001003500041E3O00FD0001002616000400FD0001000400041E3O00FD0001002616000500D30001000100041E3O00D300012O00AE0007000C3O0020A400070007003600122O0008000E6O0009000D6O0007000900024O000600073O00062O000600112O013O00041E3O00112O012O00AE000700024O0067000800033O00122O000900373O00122O000A00386O0008000A00024O00070007000800202O00070007000B4O00070002000200062O000700112O013O00041E3O00112O010020BC00070006002C2O00AE000900023O00202F00090009002D2O0093000700090002002644000700112O01002E00041E3O00112O012O00AE0007000A4O00AE0008000B3O00202F0008000800392O00C70007000200020006C0000700F50001000100041E3O00F50001002E06003B00112O01003A00041E3O00112O012O00AE000700033O0012000108003C3O00122O0009003D6O000700096O00075O00044O00112O0100041E3O00D3000100041E3O00112O01002616000400CF0001000100041E3O00CF0001001231000700013O002E1B013E00070001003E00041E3O00072O01002616000700072O01000100041E3O00072O01001231000500014O00D6000600063O001231000700043O002E99003F2O002O01004000041E4O002O0100261600072O002O01000400041E4O002O01001231000400043O00041E3O00CF000100041E4O002O0100041E3O00CF000100041E3O00112O0100041E3O00C70001001231000200043O00041E3O0086000100041E3O0007000100041E3O00162O0100041E3O000200012O0027012O00017O002B3O00028O00026O00F03F025O0072A940025O003EA140030E3O00742CA75F49522FBA654E5A22B14503053O002D3B4ED436030A3O0049734361737461626C6503083O0042752O66446F776E030E3O004F6273696469616E5363616C657303103O004865616C746850657263656E74616765025O004EA040025O00206140025O00A6AE40025O009BB240031A3O001F54902O8227ACFE2F45802O8A2BBEB01453858E883DA4E6154503083O00907036E3EBE64ECD025O00409B40030B3O009B2D0EF0C453A03C00F2D503063O003BD3486F9CB003073O0049735265616479030B3O004865616C746873746F6E6503173O004682E2215A8FF0394189E66D4A82E5284094EA3B4BC7B003043O004D2EE783026O006F40025O00F89140025O0034AF40025O00607240030D3O008851B845AD5DB8479858B75ABF03043O0020DA34D6030D3O0052656E6577696E67426C617A6503143O007C123FADE6B94B5D6C1B30B2F4F0485B471971FE03083O003A2E7751C891D02503193O00198936BEACAE3E228237EC81B83727853EABE98D393F853FA203073O00564BEC50CCC9DD025O00A49940025O00A8854003173O0040447197FB987A487982D68E734D7E8BF9BB7D557E8AF003063O00EB122117E59E03173O0052656672657368696E674865616C696E67506F74696F6E03253O0042BFC7A955A9C9B25EBD81B355BBCDB25EBD81AB5FAEC8B45EFAC5BE56BFCFA859ACC4FB0403043O00DB30DAA1025O00A7B140025O0076A14000B43O0012313O00014O00D6000100023O0026163O00AB0001000200041E3O00AB0001002616000100040001000100041E3O00040001001231000200013O002E06000400570001000300041E3O00570001002616000200570001000100041E3O005700012O00AE00036O0067000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003002500013O00041E3O002500012O00AE000300023O0020C80003000300084O00055O00202O0005000500094O00030005000200062O0003002500013O00041E3O002500012O00AE000300023O0020BC00030003000A2O00C70003000200022O00AE000400033O0006DC000300250001000400041E3O002500012O00AE000300043O0006C0000300270001000100041E3O00270001002E06000B00340001000C00041E3O003400012O00AE000300054O00AE00045O00202F0004000400092O00C70003000200020006C00003002F0001000100041E3O002F0001002E99000E00340001000D00041E3O003400012O00AE000300013O0012310004000F3O001231000500104O006C000300054O009500035O002E1B011100220001001100041E3O005600012O00AE000300064O0067000400013O00122O000500123O00122O000600136O0004000600024O00030003000400202O0003000300144O00030002000200062O0003005600013O00041E3O005600012O00AE000300073O0006380003005600013O00041E3O005600012O00AE000300023O0020BC00030003000A2O00C70003000200022O00AE000400083O00065F000300560001000400041E3O005600012O00AE000300054O0024010400093O00202O0004000400154O000500066O000700016O00030007000200062O0003005600013O00041E3O005600012O00AE000300013O001231000400163O001231000500174O006C000300054O009500035O001231000200023O002E99001800070001001900041E3O00070001002616000200070001000200041E3O00070001002E99001B007C0001001A00041E3O007C00012O00AE00036O0067000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007C00013O00041E3O007C00012O00AE000300023O0020BC00030003000A2O00C70003000200022O00AE0004000A3O0006DC0003007C0001000400041E3O007C00012O00AE0003000B3O0006380003007C00013O00041E3O007C00012O00AE0003000C4O00E500045O00202O00040004001E4O000500066O00030006000200062O0003007C00013O00041E3O007C00012O00AE000300013O0012310004001F3O001231000500204O006C000300054O009500036O00AE0003000D3O000638000300B300013O00041E3O00B300012O00AE000300023O0020BC00030003000A2O00C70003000200022O00AE0004000E3O00065F000300B30001000400041E3O00B300012O00AE0003000F4O00C5000400013O00122O000500213O00122O000600226O00040006000200062O0003008D0001000400041E3O008D000100041E3O00B30001002E06002400B30001002300041E3O00B300012O00AE000300064O0067000400013O00122O000500253O00122O000600266O0004000600024O00030003000400202O0003000300144O00030002000200062O000300B300013O00041E3O00B300012O00AE000300054O0024010400093O00202O0004000400274O000500066O000700016O00030007000200062O000300B300013O00041E3O00B300012O00AE000300013O001200010400283O00122O000500296O000300056O00035O00044O00B3000100041E3O0007000100041E3O00B3000100041E3O0004000100041E3O00B3000100260D3O00AF0001000100041E3O00AF0001002E06002A00020001002B00041E3O00020001001231000100014O00D6000200023O0012313O00023O00041E3O000200012O0027012O00017O001C3O00025O00E08B40025O00F49240026O00084003083O0042752O66446F776E03153O0053706F696C736F664E656C74686172757356657273030D3O00C165795BD546F4FD42695BDC4A03073O008084111C29BB2F030F3O00432O6F6C646F776E52656D61696E73027O0040030A3O00273B143F7F1337072E5503053O003D6152665A026O001040026O003240026O003440028O00025O00E2A940025O002FB240026O00F03F025O00E8AE40025O0022A540030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O009C9E40025O00BAA74003103O0048616E646C65546F705472696E6B6574025O00649340025O004AA14000693O002E06000100680001000200041E3O006800012O00AE7O0006383O003500013O00041E3O003500012O00AE3O00013O000EBE0003003800013O00041E3O003800012O00AE3O00023O0020565O00044O000200033O00202O0002000200056O0002000200064O00380001000100041E3O003800012O00AE3O00044O0073000100056O000200036O000300063O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O0002000200024O000300073O00202O0003000300094O000400056O000500036O000600063O00122O0007000A3O00122O0008000B6O0006000800024O00050005000600202O0005000500084O0005000200024O000600073O00202O00060006000900062O000500020001000600041E3O002900012O005900056O0009010500014O00C70004000200022O0041000300030004000628000200020001000300041E3O002F00012O005900026O0009010200014O00C70001000200020010EE0001000C00012O00415O000100264B3O00380001000D00041E3O003800012O00AE3O00083O0026503O00680001000E00041E3O006800010012313O000F4O00D6000100013O002E990010003A0001001100041E3O003A00010026163O003A0001000F00041E3O003A00010012310001000F3O00260D000100430001001200041E3O00430001002E06001300510001001400041E3O005100012O00AE000200093O0020FC0002000200164O0003000A6O0004000B3O00122O000500176O000600066O00020006000200122O000200153O00122O000200153O00062O0002006800013O00041E3O00680001001203000200154O00E3000200023O00041E3O00680001002E060018003F0001001900041E3O003F0001000EAC000F003F0001000100041E3O003F00012O00AE000200093O00206E00020002001A4O0003000A6O0004000B3O00122O000500176O000600066O00020006000200122O000200153O00122O000200153O00062O000200620001000100041E3O00620001002E06001C00640001001B00041E3O00640001001203000200154O00E3000200023O001231000100123O00041E3O003F000100041E3O0068000100041E3O003A00012O0027012O00017O002A3O00028O00026O00F03F025O0029B340025O006EB340030D3O00457465726E697479537572676503093O004973496E52616E6765026O003E4003173O00F2E739C0F9FA28CBC8E029C0F0F67CD7FAE333C5F2E17C03043O00B297935C025O00CAAB40025O00107740030D3O00893AAE59C95E0A109F3BB94CC203083O0069CC4ECB2BA7377E030C3O00432O6F6C646F776E446F776E030D3O0080BE260C1D0DD348B699331F1D03083O0031C5CA437E7364A7030B3O004973417661696C61626C65026O00FC3F026O001440030D3O00124FDA3B8E5F4A2E48EC39815803073O003E573BBF49E036026O001840030D3O00C216FFDBE90BEED0F431EAC8E903043O00A987629A026O002040027O0040030D3O00EE632146F33ADCD2641744FC3D03073O00A8AB1744349D53026O000440025O000AAC40025O0056A740025O001AB140025O004AA640026O000840030D3O00D165F0BF2B2493ED62C6BD242303073O00E7941195CD454D030B3O00A6A8C9EF58F9ADA6C0F25403063O009FE0C7A79B37026O000A40026O001040025O00C09A40025O0024AC4000F43O0012313O00014O00D6000100023O0026163O00070001000100041E3O00070001001231000100014O00D6000200023O0012313O00023O0026163O00020001000200041E3O00020001002616000100090001000100041E3O00090001001231000200013O002E06000300260001000400041E3O00260001002616000200260001000200041E3O002600012O00AE000300014O001900038O000300026O000400033O00202O0004000400054O000500043O00202O00050005000600122O000700076O0005000700024O000500056O000600016O00030006000200062O000300F300013O00041E3O00F300012O00AE000300053O0012E1000400083O00122O000500096O0003000500024O000400016O0003000300044O000300023O00044O00F300010026160002000C0001000100041E3O000C0001001231000300014O00D6000400043O0026160003002A0001000100041E3O002A0001001231000400013O002E1B010A00B80001000A00041E3O00E50001002616000400E50001000100041E3O00E50001002E1B010B000E0001000B00041E3O003F00012O00AE000500034O0067000600053O00122O0007000C3O00122O0008000D6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005003F00013O00041E3O003F00012O00D6000500054O00E3000500024O00AE000500064O0008000600076O000700036O000800053O00122O0009000F3O00122O000A00106O0008000A00024O00070007000800202O0007000700114O000700086O00063O000200102O00060002000600062O0005002B0001000600041E3O007700012O00AE000500084O00AE000600093O0010EE0006001200060006DC000500570001000600041E3O005700012O00AE000500084O00AE000600093O0010EE000600020006000628000600210001000500041E3O007700012O00AE0005000A3O0006380005007A00013O00041E3O007A00012O00AE000500063O00260D000500770001001300041E3O007700012O00AE000500034O0085000600053O00122O000700143O00122O000800156O0006000800024O00050005000600202O0005000500114O00050002000200062O0005006A0001000100041E3O006A00012O00AE000500063O000EBE001600770001000500041E3O007700012O00AE000500034O0067000600053O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500114O00050002000200062O0005007A00013O00041E3O007A00012O00AE000500063O000ECB0019007A0001000500041E3O007A0001001231000500024O0010000500013O00041E3O00E400012O00AE000500064O00F10006000B3O00122O0007001A6O000800076O000900036O000A00053O00122O000B001B3O00122O000C001C6O000A000C00024O00090009000A00202O0009000900114O0009000A6O00083O000200102O0008001A00084O0006000800024O0007000C3O00122O0008001A6O000900076O000A00036O000B00053O00122O000C001B3O00122O000D001C6O000B000D00024O000A000A000B00202O000A000A00114O000A000B6O00093O000200102O0009001A00094O0007000900024O00060006000700062O0005000D0001000600041E3O00A600012O00AE000500084O00AE000600093O0010EE0006001D00060006DC000500A40001000600041E3O00A400012O00AE000500084O00AE000600093O0010EE000600120006000628000600030001000500041E3O00A60001002E06001E00A90001001F00041E3O00A900010012310005001A4O0010000500013O00041E3O00E40001002E06002100E20001002000041E3O00E200012O00AE000500064O00F10006000B3O00122O000700226O000800076O000900036O000A00053O00122O000B00233O00122O000C00246O000A000C00024O00090009000A00202O0009000900114O0009000A6O00083O000200102O0008002200084O0006000800024O0007000C3O00122O000800226O000900076O000A00036O000B00053O00122O000C00233O00122O000D00246O000B000D00024O000A000A000B00202O000A000A00114O000A000B6O00093O000200102O0009002200094O0007000900024O00060006000700062O000500150001000600041E3O00DF00012O00AE000500034O0067000600053O00122O000700253O00122O000800266O0006000800024O00050005000600202O0005000500114O00050002000200062O000500DF00013O00041E3O00DF00012O00AE000500084O00AE000600093O0010EE00060027000600065F000500E20001000600041E3O00E200012O00AE000500084O00AE000600093O0010EE0006001D000600065F000600E20001000500041E3O00E20001001231000500224O0010000500013O00041E3O00E40001001231000500284O0010000500013O001231000400023O000E47000200E90001000400041E3O00E90001002E06002A002D0001002900041E3O002D0001001231000200023O00041E3O000C000100041E3O002D000100041E3O000C000100041E3O002A000100041E3O000C000100041E3O00F3000100041E3O0009000100041E3O00F3000100041E3O000200012O0027012O00017O002E3O00028O00026O00F03F025O00BBB140025O005AA540030A3O00AAF45E37305E7F8DE94403073O001AEC9D2C52722C030C3O00432O6F6C646F776E446F776E030D3O00446562752O6652656D61696E73030A3O0046697265427265617468025O004EA440025O00188040027O004003013O003103093O004973496E52616E6765026O003E4003143O00C74B20D33AC35037D711C90237DB15CE5537C44503053O0065A12252B603083O00A80058F7D5A2D37C03083O004E886D399EBB82E2025O0054AD40025O00508940025O00849940025O00E49E40025O00B0B140025O0046AC4003103O000F38D049283BC7552320D27D262FD85E03043O003B4A4EB5030B3O004973417661696C61626C65026O00FC3F03104O00C75F48B130C35453BD22F7565BBE2003053O00D345B12O3A026O00084003103O0092F37CE7EBDEA5EB70FBEEEDBBE474F003063O00ABD785199589026O000440030B3O002OC73CEEE036D143E6C13103083O002281A8529A8F509C03103O00A0A436194A5B9B8BBB3D0C6E422O88B703073O00E9E5D2536B282E026O000A40025O00806540025O0058A040026O001040025O0090A040025O00BCA240025O0060764000E83O0012313O00014O00D6000100023O0026163O00D50001000200041E3O00D50001002E99000400250001000300041E3O00250001002616000100250001000100041E3O00250001001231000300013O0026160003001E0001000100041E3O001E00012O00AE00046O0067000500013O00122O000600053O00122O000700066O0005000700024O00040004000500202O0004000400074O00040002000200062O0004001700013O00041E3O001700012O00D6000400044O00E3000400024O00AE000400023O0020680004000400084O00065O00202O0006000600094O0004000600024O000200043O00122O000300023O00260D000300220001000200041E3O00220001002E99000A00090001000B00041E3O00090001001231000100023O00041E3O0025000100041E3O00090001000EAC000C00410001000100041E3O004100012O00AE000300034O00ED00045O00202O0004000400094O00055O00122O0006000D6O000700023O00202O00070007000E00122O0009000F6O0007000900024O000700076O000800086O00030008000200062O000300E700013O00041E3O00E700012O00AE000300013O002O12000400103O00122O000500116O0003000500024O000400046O000500013O00122O000600123O00122O000700136O0005000700024O0003000300054O000300023O00044O00E7000100260D000100450001000200041E3O00450001002E06001400040001001500041E3O00040001001231000300013O0026160003004A0001000200041E3O004A00010012310001000C3O00041E3O00040001002616000300460001000100041E3O00460001001231000400013O002E99001600530001001700041E3O00530001002616000400530001000200041E3O00530001001231000300023O00041E3O00460001002E990019004D0001001800041E3O004D00010026160004004D0001000100041E3O004D00012O00AE000500053O0006380005005D00013O00041E3O005D00012O00AE000500063O00264B000500740001000C00041E3O007400012O00AE000500063O0026160005006A0001000200041E3O006A00012O00AE00056O0067000600013O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005007400013O00041E3O007400012O00AE000500074O00AE000600083O0010EE0006001D00060006DC000500770001000600041E3O007700012O00AE000500074O00AE000600083O0010EE00060002000600065F000600770001000500041E3O00770001001231000500024O0010000500043O00041E3O00CE00012O00AE000500094O00280105000100020006C0000500880001000100041E3O008800012O00AE00056O0067000600013O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005008800013O00041E3O008800012O00AE000500063O00264B0005009F0001002000041E3O009F00012O00AE000500063O002616000500950001000C00041E3O009500012O00AE00056O0067000600013O00122O000700213O00122O000800226O0006000800024O00050005000600202O00050005001C4O00050002000200062O0005009F00013O00041E3O009F00012O00AE000500074O00AE000600083O0010EE0006002300060006DC000500A20001000600041E3O00A200012O00AE000500074O00AE000600083O0010EE0006001D000600065F000600A20001000500041E3O00A200010012310005000C4O0010000500043O00041E3O00CE00012O00AE00056O0067000600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500C900013O00041E3O00C900012O00AE000500094O0028010500010002000638000500BD00013O00041E3O00BD00012O00AE00056O0067000600013O00122O000700263O00122O000800276O0006000800024O00050005000600202O00050005001C4O00050002000200062O000500BD00013O00041E3O00BD00012O00AE000500063O00264B000500C90001002000041E3O00C900012O00AE000500074O00AE000600083O0010EE00060028000600065F000500C70001000600041E3O00C700012O00AE000500074O00AE000600083O0010EE000600230006000628000600030001000500041E3O00C90001002E99002A00CC0001002900041E3O00CC0001001231000500204O0010000500043O00041E3O00CE00010012310005002B4O0010000500044O00AE000500044O00100005000A3O001231000400023O00041E3O004D000100041E3O0046000100041E3O0004000100041E3O00E700010026163O00020001000100041E3O00020001001231000300013O002E1B012C00070001002C00041E3O00DF0001002616000300DF0001000100041E3O00DF0001001231000100014O00D6000200023O001231000300023O000E47000200E30001000300041E3O00E30001002E1B012D00F7FF2O002E00041E3O00D800010012313O00023O00041E3O0002000100041E3O00D8000100041E3O000200012O0027012O00017O00943O00028O00026O00F03F025O00A6A240025O001DB240027O0040025O00C49340025O00AEA540030A3O009D26AE649DAD40B5AD2B03083O00D4D943CB142ODF25030A3O0049734361737461626C6503113O0054617267657449734D6F7573656F766572025O004EB140025O0080494003103O00442O6570427265617468437572736F7203093O004973496E52616E6765026O00494003113O00BE88ADC2858FBAD7BB99A092BB82AD92EC03043O00B2DAEDC8030E3O0085BDE7C4A2B0F4D9B8B2D5C4B7A703043O00B0D6D58603093O0042752O66537461636B03103O00452O73656E6365427572737442752O66030B3O00D5BFB5D5A6536FFDAAB9C603073O003994CDD6B4C836030B3O004973417661696C61626C65030E3O005368612O746572696E6753746172030E3O0049735370652O6C496E52616E676503153O0001F534206217EF3C3A712DEE21356452FC3A31364A03053O0016729D555403093O00E2C201C14EE2A7D6C603073O00C8A4AB73A43D9603093O004669726573746F726D026O00394003103O00B8FD114090AAFB1148C3BFFB0605D2EE03053O00E3DE946325025O003C9D40025O00389F4003043O00034B40F303053O0099532O329603073O0049735265616479030A3O006B797F1D67A24154626A03073O002D3D16137C13CB026O00084003043O0050797265030B3O00D10B1FF04271B6C4525CA703073O00D9A1726D956210030B3O003E292E75B273342C3971B903063O00147240581CDC03063O0042752O665570030B3O004275726E6F757442752O6603113O004C656170696E67466C616D657342752O6603083O0042752O66446F776E03073O00452O73656E6365030A3O00452O73656E63654D6178025O0046A040025O00E4AE40025O00049D40025O00804D40030B3O004C6976696E67466C616D6503133O003D08C4BDF6D782370DD3B9FD90BC3E0492E5AC03073O00DD5161B2D498B003043O00FDFE0FFE03053O007AAD877D9B030D3O00B6C007B03136E18AC705AB313E03073O00A8E4A160D95F5103103O0043686172676564426C61737442752O66026O002E40026O001040030B3O00CBC83C596F562OD46E0D7903063O0037BBB14E3C4F030C3O0009C74CE248DB852ADC5EFF4303073O00E04DAE3F8B26AF025O00409340025O00CAA740026O005A40030C3O00446973696E7465677261746503133O0080484B278A555D2996404C2BC440572BC4130803043O004EE42138025O00B6B140025O002EA740030B3O00E277A40A8BC958BE0288CB03053O00E5AE1ED26303083O0028E38741EB342B1E03073O00597B8DE6318D5D03133O00FF78E0051E4DCC77FA0D1D4FB370F9095018A103063O002A9311966C70025O00F2AA40025O0080A240025O007DB240025O00B8AB40030A3O001A2DF8F62O31EBF0393A03043O00915E5F992O033O0043647303093O0054696D65546F446965026O002O40026O003E40025O00549F40025O004FB240030A3O00447261676F6E7261676503103O00F9DF15D241B9EFCC13D00EB6F2C8548703063O00D79DAD74B52E030C3O0001BD9BC6D2308788F3D630A703053O00BA55D4EB92030D3O00E79513EC37E74CDB9225EE38E003073O0038A2E1769E598E030A3O007A0CD2AA00CA5904D4A703063O00B83C65A0CF42030C3O00432O6F6C646F776E446F776E030C3O005469705468655363616C6573025O009C9B40025O00A08C4003143O00258B6C83258A798322817DB034913CBD3E873CE803043O00DC51E21C025O000AAC40025O00C4AC40030A3O0037C783FCE5C901D485FE03063O00A773B5E29B8A03093O00C32CEE517462CFF63B03073O00A68242873C1B11030B3O0042752O6652656D61696E7303113O00426C617A696E6753686172647342752O66026O002040025O00C05240025O00E07A40030A3O006058CF723F4A58CF723503053O0050242AAE15030A3O006A02367D411E257B491503043O001A2E7057030F3O00432O6F6C646F776E52656D61696E73025O003DB040025O0026A940025O007C9C40025O00BCA540025O00D4AA40025O00909B40025O0090AF40025O00709C40025O0060B040025O00C2A340025O00489840025O002AA240030B3O002EBC386DE2DB1BB42474E203063O00886FC64D1F87025O00509140025O00ADB140030B3O00417A757265537472696B6503133O000313B244B8DB04BD1000AC53FDE518AC425BF303083O00C96269C736DD847700AC022O0012313O00014O00D6000100013O000EAC0001000200013O00041E3O00020001001231000100013O002616000100B00001000200041E3O00B00001001231000200013O002E060003000E0001000400041E3O000E00010026160002000E0001000500041E3O000E0001001231000100053O00041E3O00B00001002E06000600670001000700041E3O00670001002616000200670001000100041E3O006700012O00AE00036O0067000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002700013O00041E3O002700012O00AE000300023O0006380003002700013O00041E3O002700012O00AE000300033O0006C0000300270001000100041E3O002700012O00AE000300043O00202F00030003000B2O00280103000100020006C0000300290001000100041E3O00290001002E06000C00390001000D00041E3O003900012O00AE000300054O00D1000400063O00202O00040004000E4O000500073O00202O00050005000F00122O000700106O0005000700024O000500056O00030005000200062O0003003900013O00041E3O003900012O00AE000300013O001231000400113O001231000500124O006C000300054O009500036O00AE00036O0067000400013O00122O000500133O00122O000600146O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006600013O00041E3O006600012O00AE000300083O0020650003000300154O00055O00202O0005000500164O0003000500024O000400093O00062O000300550001000400041E3O005500012O00AE00036O0085000400013O00122O000500173O00122O000600186O0004000600024O00030003000400202O0003000300194O00030002000200062O000300660001000100041E3O006600012O00AE000300054O004300045O00202O00040004001A4O000500073O00202O00050005001B4O00075O00202O00070007001A4O0005000700024O000500056O00030005000200062O0003006600013O00041E3O006600012O00AE000300013O0012310004001C3O0012310005001D4O006C000300054O009500035O001231000200023O002616000200080001000200041E3O000800012O00AE00036O0067000400013O00122O0005001E3O00122O0006001F6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003008400013O00041E3O008400012O00AE000300054O006300045O00202O0004000400204O000500073O00202O00050005000F00122O000700216O0005000700024O000500056O0006000A6O00030006000200062O0003008400013O00041E3O008400012O00AE000300013O001231000400223O001231000500234O006C000300054O009500035O002E99002400AE0001002500041E3O00AE00012O00AE00036O0067000400013O00122O000500263O00122O000600276O0004000600024O00030003000400202O0003000300284O00030002000200062O000300AE00013O00041E3O00AE00012O00AE00036O0067000400013O00122O000500293O00122O0006002A6O0004000600024O00030003000400202O0003000300194O00030002000200062O000300AE00013O00041E3O00AE00012O00AE0003000B3O000ECB002B00AE0001000300041E3O00AE00012O00AE000300054O004300045O00202O00040004002C4O000500073O00202O00050005001B4O00075O00202O00070007002C4O0005000700024O000500056O00030005000200062O000300AE00013O00041E3O00AE00012O00AE000300013O0012310004002D3O0012310005002E4O006C000300054O009500035O001231000200053O00041E3O00080001002616000100812O01000500041E3O00812O01001231000200013O0026160002002A2O01000100041E3O002A2O012O00AE00036O0067000400013O00122O0005002F3O00122O000600306O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300DD00013O00041E3O00DD00012O00AE000300083O0020C80003000300314O00055O00202O0005000500324O00030005000200062O000300DD00013O00041E3O00DD00012O00AE000300083O0020C80003000300314O00055O00202O0005000500334O00030005000200062O000300DD00013O00041E3O00DD00012O00AE000300083O0020C80003000300344O00055O00202O0005000500164O00030005000200062O000300DD00013O00041E3O00DD00012O00AE000300083O0020CE0003000300354O0003000200024O000400083O00202O0004000400364O00040002000200202O00040004000200062O000300DF0001000400041E3O00DF0001002E99003800F30001003700041E3O00F30001002E06003A00F30001003900041E3O00F300012O00AE000300054O001001045O00202O00040004003B4O000500073O00202O00050005001B4O00075O00202O00070007003B4O0005000700024O000500056O0006000A6O00030006000200062O000300F300013O00041E3O00F300012O00AE000300013O0012310004003C3O0012310005003D4O006C000300054O009500036O00AE00036O0067000400013O00122O0005003E3O00122O0006003F6O0004000600024O00030003000400202O0003000300284O00030002000200062O000300292O013O00041E3O00292O012O00AE00036O0067000400013O00122O000500403O00122O000600416O0004000600024O00030003000400202O0003000300194O00030002000200062O0003000B2O013O00041E3O000B2O012O00AE0003000C4O00280103000100020006C0000300182O01000100041E3O00182O012O00AE0003000B3O002616000300152O01002B00041E3O00152O012O00AE000300083O00207E0003000300154O00055O00202O0005000500424O000300050002000E2O004300182O01000300041E3O00182O012O00AE0003000B3O000ECB004400292O01000300041E3O00292O012O00AE000300054O004300045O00202O00040004002C4O000500073O00202O00050005001B4O00075O00202O00070007002C4O0005000700024O000500056O00030005000200062O000300292O013O00041E3O00292O012O00AE000300013O001231000400453O001231000500464O006C000300054O009500035O001231000200023O0026160002002E2O01000500041E3O002E2O010012310001002B3O00041E3O00812O01002616000200B30001000200041E3O00B300012O00AE00036O0085000400013O00122O000500473O00122O000600486O0004000600024O00030003000400202O0003000300284O00030002000200062O0003003C2O01000100041E3O003C2O01002E1B014900160001004A00041E3O00502O01002E1B014B00140001004B00041E3O00502O012O00AE000300054O001001045O00202O00040004004C4O000500073O00202O00050005001B4O00075O00202O00070007004C4O0005000700024O000500056O0006000A6O00030006000200062O000300502O013O00041E3O00502O012O00AE000300013O0012310004004D3O0012310005004E4O006C000300054O009500035O002E060050007F2O01004F00041E3O007F2O012O00AE00036O0067000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003007F2O013O00041E3O007F2O012O00AE00036O0067000400013O00122O000500533O00122O000600546O0004000600024O00030003000400202O0003000300194O00030002000200062O0003007F2O013O00041E3O007F2O012O00AE000300083O0020C80003000300314O00055O00202O0005000500324O00030005000200062O0003007F2O013O00041E3O007F2O012O00AE000300054O001001045O00202O00040004003B4O000500073O00202O00050005001B4O00075O00202O00070007003B4O0005000700024O000500056O0006000A6O00030006000200062O0003007F2O013O00041E3O007F2O012O00AE000300013O001231000400553O001231000500564O006C000300054O009500035O001231000200053O00041E3O00B30001002616000100840201000100041E3O00840201001231000200013O00260D000200882O01000100041E3O00882O01002E99005700EB2O01005800041E3O00EB2O01001231000300013O002E99005A008F2O01005900041E3O008F2O01000EAC0002008F2O01000300041E3O008F2O01001231000200023O00041E3O00EB2O01002616000300892O01000100041E3O00892O012O00AE00046O0067000500013O00122O0006005B3O00122O0007005C6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400A62O013O00041E3O00A62O010012030004005D3O000638000400A62O013O00041E3O00A62O012O00AE000400073O0020BC00040004005E2O00C7000400020002000EBE005F00A82O01000400041E3O00A82O012O00AE0004000D3O0026DB000400A82O01006000041E3O00A82O01002E06006200B32O01006100041E3O00B32O012O00AE000400054O00AE00055O00202F0005000500632O00C7000400020002000638000400B32O013O00041E3O00B32O012O00AE000400013O001231000500643O001231000600654O006C000400064O009500046O00AE00046O0067000500013O00122O000600663O00122O000700676O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400E92O013O00041E3O00E92O012O00AE000400023O000638000400E92O013O00041E3O00E92O012O00AE000400033O000638000400E92O013O00041E3O00E92O012O00AE0004000B4O00BF0005000E6O00068O000700013O00122O000800683O00122O000900696O0007000900024O00060006000700202O0006000600194O000600076O00053O000200102O0005002B000500102O0005002B000500062O0004000B0001000500041E3O00DC2O012O00AE00046O0067000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004006C4O00040002000200062O000400E92O013O00041E3O00E92O012O00AE000400054O00AE00055O00202F00050005006D2O00C70004000200020006C0000400E42O01000100041E3O00E42O01002E99006E00E92O01006F00041E3O00E92O012O00AE000400013O001231000500703O001231000600714O006C000400064O009500045O001231000300023O00041E3O00892O01000EAC0002007F0201000200041E3O007F0201002E06007200310201007300041E3O003102012O00AE00036O0067000400013O00122O000500743O00122O000600756O0004000600024O00030003000400202O0003000300194O00030002000200062O0003000702013O00041E3O000702012O00AE0003000F4O00AE000400103O0006F0000400070201000300041E3O000702012O00AE00036O0085000400013O00122O000500763O00122O000600776O0004000600024O00030003000400202O0003000300194O00030002000200062O000300310201000100041E3O003102012O00AE000300083O0020650003000300784O00055O00202O0005000500794O0003000500024O000400113O00062O000300120201000400041E3O001202012O00AE000300033O0006380003003102013O00041E3O003102012O00AE000300073O0020BC00030003005E2O00C7000300020002000EBE007A001A0201000300041E3O001A02012O00AE0003000D3O002644000300310201006000041E3O00310201001231000300014O00D6000400053O00260D000300200201000200041E3O00200201002E99007C002B0201007B00041E3O002B0201000EAC000100200201000400041E3O002002012O00AE000600124O00280106000100022O0018000500063O0006380005003102013O00041E3O003102012O00E3000500023O00041E3O0031020100041E3O0020020100041E3O00310201000EAC0001001C0201000300041E3O001C0201001231000400014O00D6000500053O001231000300023O00041E3O001C02012O00AE000300033O0006C00003005B0201000100041E3O005B02012O00AE00036O0067000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400202O0003000300194O00030002000200062O0003005B02013O00041E3O005B02012O00AE00036O0094000400013O00122O0005007F3O00122O000600806O0004000600024O00030003000400202O0003000300814O0003000200024O000400103O00062O000400590201000300041E3O005902012O00AE000300083O0020890003000300784O00055O00202O0005000500794O0003000500024O000400113O00062O000300590201000400041E3O005902012O00AE000300073O0020BC00030003005E2O00C7000300020002000EBE007A005B0201000300041E3O005B02012O00AE0003000D3O0026DB0003005B0201006000041E3O005B0201002E990082007E0201008300041E3O007E0201001231000300014O00D6000400053O000EAC0002006C0201000300041E3O006C0201002E060084005F0201008500041E3O005F02010026160004005F0201000100041E3O005F02012O00AE000600134O00280106000100022O0018000500063O0006380005007E02013O00041E3O007E02012O00E3000500023O00041E3O007E020100041E3O005F020100041E3O007E0201002E990087005D0201008600041E3O005D02010026160003005D0201000100041E3O005D0201001231000600013O002E06008900780201008800041E3O00780201002616000600780201000100041E3O00780201001231000400014O00D6000500053O001231000600023O002616000600710201000200041E3O00710201001231000300023O00041E3O005D020100041E3O0071020100041E3O005D0201001231000200053O002616000200842O01000500041E3O00842O01001231000100023O00041E3O0084020100041E3O00842O01002E99008B00050001008A00041E3O00050001002616000100050001002B00041E3O00050001002E06008C00AB0201008D00041E3O00AB02012O00AE00026O0067000300013O00122O0004008E3O00122O0005008F6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200AB02013O00041E3O00AB0201002E06009000AB0201009100041E3O00AB02012O00AE000200054O004300035O00202O0003000300924O000400073O00202O00040004001B4O00065O00202O0006000600924O0004000600024O000400046O00020004000200062O000200AB02013O00041E3O00AB02012O00AE000200013O001200010300933O00122O000400946O000200046O00025O00044O00AB020100041E3O0005000100041E3O00AB020100041E3O000200012O0027012O00017O00C73O00028O00026O000840026O00F03F03043O00D500478603083O003E857935E37F6D4F03073O0049735265616479030D3O00221535FCD8A98B1E1237E7D8A103073O00C270745295B6CE030B3O004973417661696C61626C6503093O0042752O66537461636B03103O0043686172676564426C61737442752O66026O003440027O0040025O000FB140025O0008AA4003043O0050797265030E3O0049735370652O6C496E52616E6765030A3O0029B15E1D80F11A79FA1E03073O006E59C82C78A082026O001040030B3O005DED3C24369768E5203D3603063O00C41C97495653030A3O0049734361737461626C6503103O00452O73656E6365427572737442752O66030B3O00417A757265537472696B6503123O00F2193C0287670B62E10A2215C24B0C36A25B03083O001693634970E23878030B3O00947CF4FC83BF53EEF480BD03053O00EDD815829503063O0042752O665570030B3O004275726E6F757442752O6603113O004C656170696E67466C616D657342752O6603083O0042752O66446F776E03073O00452O73656E6365030A3O00452O73656E63654D6178025O00A0A640025O0021B240025O00908B40026O003540030B3O004C6976696E67466C616D6503123O008E474956BECE6184425E52B5894D960E0D0F03073O003EE22E2O3FD0A9025O008AA240025O00B5B24003093O009F0591241121A3AB0103073O00CCD96CE3416255030C3O00536E61706669726542752O66025O00BC9C40025O00C09140025O00CCAA4003093O004669726573746F726D03093O004973496E52616E6765026O003940030E3O0058CAE7E03FD451D1F8A53FD41E9703063O00A03EA395854C025O00608740025O00E0A140030A3O00F2B20C28CCD8B20C28C603053O00A3B6C06D4F030A3O00122F12C5D7262301D4FD03053O0095544660A0030F3O00432O6F6C646F776E52656D61696E73030D3O001D1208FF360F19F40B131FEA3D03043O008D58666D026O003E40030A3O00447261676F6E72616765030F3O00B741CB77153347C0B4568A630E7D2O03083O00A1D333AA107A5D35025O00D88B40025O0079B140030C3O00CFA7A21CF3AB812BFAA2B73B03043O00489BCED2030D3O00636E511C3D4F6E4D3D26547D5103053O0053261A346E030A3O00432O6F6C646F776E5570030A3O007E1E35437A0522474C1F03043O0026387747030C3O00432O6F6C646F776E446F776E03103O00D6F95DC427432OE151D82270FFEE55D303063O0036938F38B64503103O00F397FA5BDDC393F1402OD1A7F348D2D303053O00BFB6E19F29030A3O000D1B3A50A995C72A062003073O00A24B724835EBE7025O00FEA740025O00AEA440030C3O005469705468655363616C657303133O00983554DD470A890357E1520E892F04F14742D403063O0062EC5C248233030C3O008FCA584F4D5E3E4AB9C25F4303083O002DCBA32B26232A5B030C3O00446973696E74656772617465025O00C88340025O00A0994003123O00D68CCF2A89BD51D597DD3782E947C6C58E7703073O0034B2E5BC43E7C9025O0068AD40025O00C8A24003093O0007484201E4482C334C03073O004341213064973C030A3O00446562752O66446F776E030E3O005368612O746572696E6753746172025O00C6AD40025O003EB040030F3O00D9EEBCDDE0CBE8BCD5B3CCF3EE8AA503053O0093BF87CEB8025O00388740025O00804740030A3O00A02DA3D1FA41B7853CAE03073O00D2E448C6A1B83303113O0054617267657449734D6F7573656F76657203103O00442O6570427265617468437572736F72026O00494003113O00324CF6004CCC244CF2047B8E255DB3422B03063O00AE5629937013026O001440025O001EAC40025O008C9040030A3O00800B0DBD4AA6A731A31C03083O0050C4796CDA25C8D503093O00217D0B72441D83146A03073O00EA6013621F2B6E030B3O0042752O6652656D61696E7303113O00426C617A696E6753686172647342752O6603093O0054696D65546F446965026O002040025O006C9540025O0096A340030E3O00351753D3B877990F1155F4B8739903073O00EB667F32A7CC12030B3O0071B3F6224A2B66A8F22C5603063O004E30C1954324025O002EAC40025O00D0A34003153O002316810C55350C8916460F0D941953700D9458106003053O0021507EE078025O00989140025O00B6AC40030A3O00C8BA02C353E2BA02C35903053O003C8CC863A403093O00A6FA0D2BAD94FD103F03053O00C2E7946446025O0020AA40025O003EAC40025O00A8B240025O00406A40025O006AA440025O0080A540025O00BEB140025O008EA040025O003C9040025O00207540025O0023B040025O0002B24003093O006742C8AEF9DB4F58D803063O00A8262CA1C396030A3O00A6F5907312FAB31794F403083O0076E09CE2165088D603043O00502O6F6C03113O0075EF509402E8569202C87BC051FA19D11003043O00E0228E39025O0021B040026O00854003093O00FFA9CCD07CE2541AC703083O006EBEC7A5BD13913D030D3O002OFF72FA852OCEF244FD99C0DF03063O00A7BA8B1788EB025O00D88F40025O0014AB4003113O002DB481195AB3871F5A90BB4D09A1C85C4E03043O006D7AD5E8025O00207240025O00B88A40030B3O00C2FEB439E0F0843CEFFAA703043O00508E97C203123O000FCF61450DC1484A0FC77A4943D5630C529003043O002C63A617025O00F9B140025O005EB140030A3O007F05881B071D14AA4F0803083O00CB3B60ED6B456F7103133O000D1BA1E83FF5D93032A9F225E2C22702A5EE3F03073O00B74476CC815190025O00188F40025O0066A04003113O000AA875F434801CA871F003C21DB930B75B03063O00E26ECD10846B025O00088E40025O004CAF40030B3O00C7CAF6D04FECE5ECD84CEE03053O00218BA380B903123O005B5112D7595F3BD85B5909DB174B109E040A03043O00BE373864030B3O0077B5290C16D0E744A6371B03073O009336CF5C7E7383025O000CA540025O00F6B24003123O000C2B206F08411E252774067B4D22213D5E2A03063O001E6D51551D6D0007042O0012313O00013O0026163O00BE0001000200041E3O00BE0001001231000100014O00D6000200023O002616000100050001000100041E3O00050001001231000200013O000EAC000300410001000200041E3O004100012O00AE00036O0067000400013O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O00030002000200062O0003002C00013O00041E3O002C00012O00AE000300024O00280103000100020006380003002C00013O00041E3O002C00012O00AE00036O0067000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O00030002000200062O0003002C00013O00041E3O002C00012O00AE000300033O00202301030003000A4O00055O00202O00050005000B4O00030005000200262O0003002C0001000C00041E3O002C00012O00AE000300043O000EBE000D002E0001000300041E3O002E0001002E99000E003F0001000F00041E3O003F00012O00AE000300054O004300045O00202O0004000400104O000500063O00202O0005000500114O00075O00202O0007000700104O0005000700024O000500056O00030005000200062O0003003F00013O00041E3O003F00012O00AE000300013O001231000400123O001231000500134O006C000300054O009500035O0012313O00143O00041E3O00BE0001002616000200080001000100041E3O000800012O00AE00036O0067000400013O00122O000500153O00122O000600166O0004000600024O00030003000400202O0003000300174O00030002000200062O0003006D00013O00041E3O006D00012O00AE000300073O0006380003006D00013O00041E3O006D00012O00AE000300084O002B000400096O000500033O00202O00050005000A4O00075O00202O0007000700184O0005000700024O0004000400054O0005000A6O00040004000500062O0003006D0001000400041E3O006D00012O00AE000300054O004300045O00202O0004000400194O000500063O00202O0005000500114O00075O00202O0007000700194O0005000700024O000500056O00030005000200062O0003006D00013O00041E3O006D00012O00AE000300013O0012310004001A3O0012310005001B4O006C000300054O009500036O00AE00036O0067000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O0003000300174O00030002000200062O000300A400013O00041E3O00A400012O00AE000300033O0020C800030003001E4O00055O00202O00050005001F4O00030005000200062O000300A400013O00041E3O00A400012O00AE000300033O0020C800030003001E4O00055O00202O0005000500204O00030005000200062O0003008C00013O00041E3O008C00012O00AE000300033O0020560003000300214O00055O00202O0005000500184O00030005000200062O0003009B0001000100041E3O009B00012O00AE000300033O0020C80003000300214O00055O00202O0005000500204O00030005000200062O000300A400013O00041E3O00A400012O00AE000300033O00208900030003000A4O00055O00202O0005000500184O0003000500024O000400093O00062O000300A40001000400041E3O00A400012O00AE000300033O0020CE0003000300224O0003000200024O000400033O00202O0004000400234O00040002000200202O00040004000300062O000300A60001000400041E3O00A60001002E06002500BA0001002400041E3O00BA0001002E06002700BA0001002600041E3O00BA00012O00AE000300054O001001045O00202O0004000400284O000500063O00202O0005000500114O00075O00202O0007000700284O0005000700024O000500056O0006000B6O00030006000200062O000300BA00013O00041E3O00BA00012O00AE000300013O001231000400293O0012310005002A4O006C000300054O009500035O001231000200033O00041E3O0008000100041E3O00BE000100041E3O00050001000EAC0001007E2O013O00041E3O007E2O01001231000100013O000EAC000100282O01000100041E3O00282O01001231000200013O002616000200C80001000300041E3O00C80001001231000100033O00041E3O00282O01002E99002B00C40001002C00041E3O00C40001000EAC000100C40001000200041E3O00C400012O00AE00036O0067000400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O0003000300174O00030002000200062O000300DD00013O00041E3O00DD00012O00AE000300033O00205600030003001E4O00055O00202O00050005002F4O00030005000200062O000300DF0001000100041E3O00DF0001002E06003000F20001003100041E3O00F20001002E1B013200130001003200041E3O00F200012O00AE000300054O006300045O00202O0004000400334O000500063O00202O00050005003400122O000700356O0005000700024O000500056O0006000B6O00030006000200062O000300F200013O00041E3O00F200012O00AE000300013O001231000400363O001231000500374O006C000300054O009500035O002E99003800262O01003900041E3O00262O012O00AE00036O0067000400013O00122O0005003A3O00122O0006003B6O0004000600024O00030003000400202O0003000300174O00030002000200062O000300262O013O00041E3O00262O012O00AE0003000C3O000638000300262O013O00041E3O00262O012O00AE00036O0094000400013O00122O0005003C3O00122O0006003D6O0004000600024O00030003000400202O00030003003E4O0003000200024O0004000A3O00062O000300182O01000400041E3O00182O012O00AE00036O0084000400013O00122O0005003F3O00122O000600406O0004000600024O00030003000400202O00030003003E4O0003000200024O0004000A3O00102O0004000D000400062O0003001B2O01000400041E3O001B2O012O00AE0003000D3O002644000300262O01004100041E3O00262O012O00AE000300054O00AE00045O00202F0004000400422O00C7000300020002000638000300262O013O00041E3O00262O012O00AE000300013O001231000400433O001231000500444O006C000300054O009500035O001231000200033O00041E3O00C40001002E06004500C10001004600041E3O00C10001002616000100C10001000300041E3O00C100012O00AE00026O0067000300013O00122O000400473O00122O000500486O0003000500024O00020002000300202O0002000200174O00020002000200062O0002006E2O013O00041E3O006E2O012O00AE0002000C3O0006380002006E2O013O00041E3O006E2O012O00AE000200073O0006380002005A2O013O00041E3O005A2O012O00AE00026O0067000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300202O00020002004B4O00020002000200062O0002005A2O013O00041E3O005A2O012O00AE00026O0067000300013O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O00020002004E4O00020002000200062O0002005A2O013O00041E3O005A2O012O00AE00026O0067000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200094O00020002000200062O000200702O013O00041E3O00702O012O00AE00026O0067000300013O00122O000400513O00122O000500526O0003000500024O00020002000300202O0002000200094O00020002000200062O0002006E2O013O00041E3O006E2O012O00AE00026O0085000300013O00122O000400533O00122O000500546O0003000500024O00020002000300202O00020002004B4O00020002000200062O000200702O01000100041E3O00702O01002E990055007B2O01005600041E3O007B2O012O00AE000200054O00AE00035O00202F0003000300572O00C70002000200020006380002007B2O013O00041E3O007B2O012O00AE000200013O001231000300583O001231000400594O006C000200044O009500025O0012313O00033O00041E3O007E2O0100041E3O00C100010026163O00FA2O01001400041E3O00FA2O01001231000100013O002616000100CB2O01000100041E3O00CB2O012O00AE00026O0067000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O0002000200064O00020002000200062O000200A12O013O00041E3O00A12O012O00AE000200054O00B000035O00202O00030003005C4O000400063O00202O0004000400114O00065O00202O00060006005C4O0004000600024O000400046O0005000B6O00020005000200062O0002009C2O01000100041E3O009C2O01002E06005E00A12O01005D00041E3O00A12O012O00AE000200013O0012310003005F3O001231000400604O006C000200044O009500025O002E06006200CA2O01006100041E3O00CA2O012O00AE00026O0067000300013O00122O000400633O00122O000500646O0003000500024O00020002000300202O0002000200174O00020002000200062O000200CA2O013O00041E3O00CA2O012O00AE000200073O0006C0000200CA2O01000100041E3O00CA2O012O00AE000200063O0020C80002000200654O00045O00202O0004000400664O00020004000200062O000200CA2O013O00041E3O00CA2O012O00AE000200054O00BA00035O00202O0003000300334O000400063O00202O00040004003400122O000600356O0004000600024O000400046O0005000B6O00020005000200062O000200C52O01000100041E3O00C52O01002E99006800CA2O01006700041E3O00CA2O012O00AE000200013O001231000300693O0012310004006A4O006C000200044O009500025O001231000100033O002E06006C00812O01006B00041E3O00812O01002616000100812O01000300041E3O00812O012O00AE00026O0067000300013O00122O0004006D3O00122O0005006E6O0003000500024O00020002000300202O0002000200174O00020002000200062O000200F72O013O00041E3O00F72O012O00AE0002000C3O000638000200F72O013O00041E3O00F72O012O00AE000200073O0006C0000200F72O01000100041E3O00F72O012O00AE000200043O000ECB000D00F72O01000200041E3O00F72O012O00AE0002000E3O00202F00020002006F2O0028010200010002000638000200F72O013O00041E3O00F72O012O00AE000200054O00D10003000F3O00202O0003000300704O000400063O00202O00040004003400122O000600716O0004000600024O000400046O00020004000200062O000200F72O013O00041E3O00F72O012O00AE000200013O001231000300723O001231000400734O006C000200044O009500025O0012313O00743O00041E3O00FA2O0100041E3O00812O010026163O00D00201000300041E3O00D00201001231000100014O00D6000200023O002616000100FE2O01000100041E3O00FE2O01001231000200013O002E99007600770201007500041E3O00770201002616000200770201000100041E3O007702012O00AE00036O0067000400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O0003000300094O00030002000200062O0003001D02013O00041E3O001D02012O00AE000300104O00AE000400113O0006F00004001D0201000300041E3O001D02012O00AE00036O0085000400013O00122O000500793O00122O0006007A6O0004000600024O00030003000400202O0003000300094O00030002000200062O000300470201000100041E3O004702012O00AE000300033O00206500030003007B4O00055O00202O00050005007C4O0003000500024O000400123O00062O000300280201000400041E3O002802012O00AE000300073O0006380003004702013O00041E3O004702012O00AE000300063O0020BC00030003007D2O00C7000300020002000EBE007E00300201000300041E3O003002012O00AE0003000D3O002644000300470201004100041E3O00470201001231000300014O00D6000400053O000EAC000300410201000300041E3O00410201002616000400340201000100041E3O003402012O00AE000600134O00280106000100022O0018000500063O002E99007F00470201008000041E3O004702010006380005004702013O00041E3O004702012O00E3000500023O00041E3O0047020100041E3O0034020100041E3O00470201002616000300320201000100041E3O00320201001231000400014O00D6000500053O001231000300033O00041E3O003202012O00AE00036O0067000400013O00122O000500813O00122O000600826O0004000600024O00030003000400202O0003000300174O00030002000200062O0003007602013O00041E3O007602012O00AE000300033O00206500030003000A4O00055O00202O0005000500184O0003000500024O000400093O00062O000300630201000400041E3O006302012O00AE00036O0085000400013O00122O000500833O00122O000600846O0004000600024O00030003000400202O0003000300094O00030002000200062O000300760201000100041E3O007602012O00AE000300054O004900045O00202O0004000400664O000500063O00202O0005000500114O00075O00202O0007000700664O0005000700024O000500056O00030005000200062O000300710201000100041E3O00710201002E1B018500070001008600041E3O007602012O00AE000300013O001231000400873O001231000500884O006C000300054O009500035O001231000200033O002E06008900010201008A00041E3O00010201002616000200010201000300041E3O000102012O00AE00036O0067000400013O00122O0005008B3O00122O0006008C6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009302013O00041E3O009302012O00AE000300104O00AE000400113O0006F0000400930201000300041E3O009302012O00AE00036O0085000400013O00122O0005008D3O00122O0006008E6O0004000600024O00030003000400202O0003000300094O00030002000200062O000300A60201000100041E3O00A602012O00AE000300033O00206500030003007B4O00055O00202O00050005007C4O0003000500024O000400123O00062O0003009E0201000400041E3O009E02012O00AE000300073O000638000300A602013O00041E3O00A602012O00AE000300063O0020BC00030003007D2O00C7000300020002000EBE007E00A80201000300041E3O00A802012O00AE0003000D3O0026DB000300A80201004100041E3O00A80201002E99009000CB0201008F00041E3O00CB0201001231000300014O00D6000400053O000EAC000300B90201000300041E3O00B9020100260D000400B00201000100041E3O00B00201002E99009100AC0201009200041E3O00AC02012O00AE000600144O00280106000100022O0018000500063O000638000500CB02013O00041E3O00CB02012O00E3000500023O00041E3O00CB020100041E3O00AC020100041E3O00CB020100260D000300BD0201000100041E3O00BD0201002E06009400AA0201009300041E3O00AA0201001231000600013O002E06009600C40201009500041E3O00C40201002616000600C40201000300041E3O00C40201001231000300033O00041E3O00AA0201002616000600BE0201000100041E3O00BE0201001231000400014O00D6000500053O001231000600033O00041E3O00BE020100041E3O00AA02010012313O000D3O00041E3O00D0020100041E3O0001020100041E3O00D0020100041E3O00FE2O0100260D3O00D40201000D00041E3O00D40201002E1B019700BB0001009800041E3O008D0301001231000100013O00260D000100D90201000100041E3O00D90201002E06009A00540301009900041E3O00540301001231000200013O002616000200DE0201000300041E3O00DE0201001231000100033O00041E3O00540301002616000200DA0201000100041E3O00DA02012O00AE00036O0067000400013O00122O0005009B3O00122O0006009C6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003001B03013O00041E3O001B03012O00AE000300073O0006380003001B03013O00041E3O001B03012O00AE000300084O00DA0004000A6O000500126O000600156O000700033O00202O0007000700214O00095O00202O0009000900574O000700096O00063O00024O0005000500064O00040004000500062O0003001B0301000400041E3O001B03012O00AE000300084O00A000048O000500013O00122O0006009D3O00122O0007009E6O0005000700024O00040004000500202O00040004003E4O0004000200024O0003000300044O000400126O000500156O000600033O00202O0006000600214O00085O00202O0008000800574O000600086O00053O00024O00040004000500062O0004001B0301000300041E3O001B03012O00AE000300054O00AE00045O00202F00040004009F2O00C70003000200020006380003001B03013O00041E3O001B03012O00AE000300013O001231000400A03O001231000500A14O006C000300054O009500035O002E9900A30052030100A200041E3O005203012O00AE00036O0067000400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400202O0003000300094O00030002000200062O0003005203013O00041E3O005203012O00AE000300073O0006380003005203013O00041E3O005203012O00AE000300084O00AE0004000A4O00AE000500124O00410004000400050006DC000300520301000400041E3O005203012O00AE000300084O008100048O000500013O00122O000600A63O00122O000700A76O0005000700024O00040004000500202O00040004003E4O0004000200024O0003000300044O000400124O00AE000500154O00AD000600033O00202O0006000600214O00085O00202O0008000800574O000600086O00053O00024O00040004000500062O000400520301000300041E3O00520301002E0600A80052030100A900041E3O005203012O00AE000300054O00AE00045O00202F00040004009F2O00C70003000200020006380003005203013O00041E3O005203012O00AE000300013O001231000400AA3O001231000500AB4O006C000300054O009500035O001231000200033O00041E3O00DA0201002E9900AC00D5020100AD00041E3O00D50201002616000100D50201000300041E3O00D502012O00AE00026O0067000300013O00122O000400AE3O00122O000500AF6O0003000500024O00020002000300202O0002000200174O00020002000200062O0002008A03013O00041E3O008A03012O00AE000200073O0006380002008A03013O00041E3O008A03012O00AE000200084O002B000300096O000400033O00202O00040004000A4O00065O00202O0006000600184O0004000600024O0003000300044O0004000A6O00030003000400062O0002008A0301000300041E3O008A03012O00AE000200033O0020C800020002001E4O00045O00202O00040004001F4O00020004000200062O0002008A03013O00041E3O008A03012O00AE000200054O001001035O00202O0003000300284O000400063O00202O0004000400114O00065O00202O0006000600284O0004000600024O000400046O0005000B6O00020005000200062O0002008A03013O00041E3O008A03012O00AE000200013O001231000300B03O001231000400B14O006C000200044O009500025O0012313O00023O00041E3O008D030100041E3O00D50201002E0600B30001000100B200041E3O000100010026163O00010001007400041E3O000100012O00AE00016O0067000200013O00122O000300B43O00122O000400B56O0002000400024O00010001000200202O0001000100174O00010002000200062O000100B703013O00041E3O00B703012O00AE0001000C3O000638000100B703013O00041E3O00B703012O00AE000100073O0006C0000100B70301000100041E3O00B703012O00AE00016O0067000200013O00122O000300B63O00122O000400B76O0002000400024O00010001000200202O0001000100094O00010002000200062O000100B703013O00041E3O00B703012O00AE000100063O0020C80001000100654O00035O00202O0003000300664O00010003000200062O000100B703013O00041E3O00B703012O00AE0001000E3O00202F00010001006F2O00282O01000100020006C0000100B90301000100041E3O00B90301002E9900B900C9030100B800041E3O00C903012O00AE000100054O00D10002000F3O00202O0002000200704O000300063O00202O00030003003400122O000500716O0003000500024O000300036O00010003000200062O000100C903013O00041E3O00C903012O00AE000100013O001231000200BA3O001231000300BB4O006C000100034O009500015O002E0600BC00E7030100BD00041E3O00E703012O00AE00016O0067000200013O00122O000300BE3O00122O000400BF6O0002000400024O00010001000200202O0001000100174O00010002000200062O000100E703013O00041E3O00E703012O00AE000100054O001001025O00202O0002000200284O000300063O00202O0003000300114O00055O00202O0005000500284O0003000500024O000300036O0004000B6O00010004000200062O000100E703013O00041E3O00E703012O00AE000100013O001231000200C03O001231000300C14O006C000100034O009500016O00AE00016O0067000200013O00122O000300C23O00122O000400C36O0002000400024O00010001000200202O0001000100174O00010002000200062O0001000604013O00041E3O00060401002E0600C40006040100C500041E3O000604012O00AE000100054O004300025O00202O0002000200194O000300063O00202O0003000300114O00055O00202O0005000500194O0003000500024O000300036O00010003000200062O0001000604013O00041E3O000604012O00AE000100013O001200010200C63O00122O000300C76O000100036O00015O00044O0006040100041E3O000100012O0027012O00017O00383O00028O00025O004EB040025O002AAD40025O0084A440025O00408440025O00EC9840025O003CA040026O00F03F030B3O00CF7D55AF33CCBCD07F58AF03073O009C9F1134D656BE025O008C9940025O00688440030E3O0098EAAFB8AFE1A999A3EDAFBDADEA03043O00DCCE8FDD03073O004973526561647903103O004865616C746850657263656E74616765025O0034AD4003143O0056657264616E74456D6272616365506C6179657203173O0090783F13D9C2C6B9782015CACDD1833D2016D1C292D22D03073O00B2E61D4D77B8AC03083O00D0A80F096EF7FBBB03063O009895DE6A7B1703083O00F329E20381DC28FD03053O00D5BD469623030E3O007950660C4E5B602D425766094C5003043O00682F3514025O00F6AE40025O0086B24003133O0056657264616E74456D6272616365466F63757303173O00B5499318BD01B7738411BE1DA24F845CB10EAA42C148EC03063O006FC32CE17CDC025O00D0AF40025O0057B240030B3O00E84A016AAEB998690E7FB203063O00CBB8266013CB025O0058A140025O0092A640030E3O001C7E7C53CF35775B4DC12A60764C03053O00AE59131921025O0032B340025O002FB140025O0098AC4003143O00456D6572616C64426C6F2O736F6D506C6179657203173O002A1F575CF68B0F2O105E41E4940422525F4FFE894B7B4003073O006B4F72322E97E7025O00C6A640025O0080684003083O001C2OB03B9336B9C503083O00A059C6D549EA59D7030E3O006D7CB1ECC4447596F2CA5B62BBF303053O00A52811D49E025O001EB240025O007CAE4003133O00456D6572616C64426C6F2O736F6D466F63757303173O00E0D40D2127E9DD37312AEACA1B3C2BA5D4093A28A58D5A03053O004685B9685300C93O0012313O00014O00D6000100013O00260D3O00060001000100041E3O00060001002E99000200020001000300041E3O00020001001231000100013O002616000100700001000100041E3O00700001001231000200014O00D6000300033O00260D0002000F0001000100041E3O000F0001002E990004000B0001000500041E3O000B0001001231000300013O002E99000600160001000700041E3O00160001002616000300160001000800041E3O00160001001231000100083O00041E3O00700001002616000300100001000100041E3O001000012O00AE00046O00C5000500013O00122O000600093O00122O0007000A6O00050007000200062O000400200001000500041E3O0020000100041E3O00400001002E06000C00400001000B00041E3O004000012O00AE000400024O0067000500013O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004004000013O00041E3O004000012O00AE000400033O0020BC0004000400102O00C70004000200022O00AE000500043O0006DC000400400001000500041E3O00400001002E1B0111000E0001001100041E3O004000012O00AE000400054O00E5000500063O00202O0005000500124O000600066O00040006000200062O0004004000013O00041E3O004000012O00AE000400013O001231000500133O001231000600144O006C000400064O009500046O00AE00046O00C5000500013O00122O000600153O00122O000700166O00050007000200062O0004004E0001000500041E3O004E00012O00AE00046O003B000500013O00122O000600173O00122O000700186O00050007000200062O0004006C0001000500041E3O006C00012O00AE000400024O0067000500013O00122O000600193O00122O0007001A6O0005000700024O00040004000500202O00040004000F4O00040002000200062O0004005E00013O00041E3O005E00012O00AE000400073O0020BC0004000400102O00C70004000200022O00AE000500043O0006F0000400600001000500041E3O00600001002E06001C006C0001001B00041E3O006C00012O00AE000400054O00E5000500063O00202O00050005001D4O000600066O00040006000200062O0004006C00013O00041E3O006C00012O00AE000400013O0012310005001E3O0012310006001F4O006C000400064O009500045O001231000300083O00041E3O0010000100041E3O0070000100041E3O000B000100260D000100740001000800041E3O00740001002E06002100070001002000041E3O000700012O00AE000200084O00C5000300013O00122O000400223O00122O000500236O00030005000200062O0002007D0001000300041E3O007D0001002E060025009D0001002400041E3O009D00012O00AE000200024O0067000300013O00122O000400263O00122O000500276O0003000500024O00020002000300202O00020002000F4O00020002000200062O0002008D00013O00041E3O008D00012O00AE000200033O0020BC0002000200102O00C70002000200022O00AE000300093O0006F00002008F0001000300041E3O008F0001002E060028009D0001002900041E3O009D0001002E1B012A000E0001002A00041E3O009D00012O00AE000200054O00E5000300063O00202O00030003002B4O000400046O00020004000200062O0002009D00013O00041E3O009D00012O00AE000200013O0012310003002C3O0012310004002D4O006C000200044O009500025O002E99002F00C80001002E00041E3O00C800012O00AE000200084O003B000300013O00122O000400303O00122O000500316O00030005000200062O000200C80001000300041E3O00C800012O00AE000200024O0067000300013O00122O000400323O00122O000500336O0003000500024O00020002000300202O00020002000F4O00020002000200062O000200B600013O00041E3O00B600012O00AE000200073O0020BC0002000200102O00C70002000200022O00AE000300093O0006F0000200B80001000300041E3O00B80001002E06003400C80001003500041E3O00C800012O00AE000200054O00E5000300063O00202O0003000300364O000400046O00020004000200062O000200C800013O00041E3O00C800012O00AE000200013O001200010300373O00122O000400386O000200046O00025O00044O00C8000100041E3O0007000100041E3O00C8000100041E3O000200012O0027012O00017O00193O00028O00026O00F03F025O00309140025O00309440030E3O00E74A1E3F1CCBBC8AC65D3C2218CA03083O00E3A83A6E4D79B8CF03073O004973526561647903113O00556E6974486173456E7261676542752O66025O00188140025O006EAB40030E3O004F2O7072652O73696E67526F617203163O00542CAF52B4C862AC753BFF72BEDA63E57F35AC50B4D703083O00C51B5CDF20D1BB11025O00A07340025O00A8A04003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E697403073O00215D543FC7034003053O00A96425244A03133O00556E6974486173506F69736F6E446562752O66030C3O00457870756E6765466F637573030E3O00259FB2450E80A710048EB140058B03043O003060E7C2006A3O0012313O00014O00D6000100013O0026163O00020001000100041E3O00020001001231000100013O00260D000100090001000200041E3O00090001002E990004002A0001000300041E3O002A00012O00AE00026O0067000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001C00013O00041E3O001C00012O00AE000200023O0006380002001C00013O00041E3O001C00012O00AE000200033O00202F0002000200082O00AE000300044O00C70002000200020006C00002001E0001000100041E3O001E0001002E06000A00690001000900041E3O006900012O00AE000200054O00AE00035O00202F00030003000B2O00C70002000200020006380002006900013O00041E3O006900012O00AE000200013O0012000103000C3O00122O0004000D6O000200046O00025O00044O0069000100260D0001002E0001000100041E3O002E0001002E06000F00050001000E00041E3O00050001001231000200013O002616000200330001000200041E3O00330001001231000100023O00041E3O00050001000EAC0001002F0001000200041E3O002F00012O00AE000300063O0006380003004800013O00041E3O004800012O00AE000300063O0020BC0003000300102O00C70003000200020006380003004800013O00041E3O004800012O00AE000300063O0020BC000300030011001231000500124O00930003000500020006380003004800013O00041E3O004800012O00AE000300033O00202F0003000300132O00280103000100020006C0000300490001000100041E3O004900012O0027012O00014O00AE00036O0067000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300074O00030002000200062O0003006400013O00041E3O006400012O00AE000300033O00202F0003000300162O00AE000400064O00C70003000200020006380003006400013O00041E3O006400012O00AE000300054O00AE000400073O00202F0004000400172O00C70003000200020006380003006400013O00041E3O006400012O00AE000300013O001231000400183O001231000500194O006C000300054O009500035O001231000200023O00041E3O002F000100041E3O0005000100041E3O0069000100041E3O000200012O0027012O00017O008D3O00028O00025O00208D40026O00F03F025O00F6A640025O000EB140026O001040025O0002AF40025O0092AC40025O008C9540025O00D89640030C3O004570696353652O74696E677303083O009A0DCA9536A70FCD03053O005FC968BEE103123O0086C5D5CBBDD9D4DEBBFFC9DCAAD8C9C1A3CF03043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803113O00191AE3233C19F4093F1AEF022B3BE90D3E03043O006C4C6986027O0040025O00FEB140025O002OAE40026O001440025O00A89840025O00A08F4003083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103103O0096A0E7F3C30D756FAABDE5E3CA026A7D03083O0018C3D382A1A6631003083O007506FD385A18411003063O00762663894C33030F3O00CF230B171E29F321271E083AF80E3503063O00409D46657269025O00BEA240025O0074AA4003083O00305AD7EF0A51C4E803043O009B633FA303133O00B4D4B389B88A96F4AC8FAB8581D4949EB8838703063O00E4E2B1C1EDD9034O0003083O0007B537F23DBE24F503043O008654D04303133O0036A1834E12A0827E1FA3954F1CA1B34F12AB8303043O003C73CCE603083O00D43FFF64EE34EC6303043O0010875A8B03103O00627114374F5A6C717904214F577D7C4403073O0018341466532E3403083O00F72A353006CA283203053O006FA44F414403103O00E3D486CC2FE6C2FB8FD13DF9C9D4ABEE03063O008AA6B9E3BE4E026O00084003083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB7030F3O00D115C8F880A4D133FF18CFFF98A4F403083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD38403113O001D8C755BDEAA9DD63682694FDDBDB1D93903083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F68396903113O002289B0411995B1541FB0AD5003B4B0510503043O00246BE7C403083O006EB0B69354BBA59403043O00E73DD5C203163O0020A329761BBF28631D82337F109A357A1DA8317A1AB903043O001369CD5D03083O00C2EF38A22CFFED3F03053O0045918A4CD6030F3O0058CA8885B61877FF869DB6197EE7B903063O007610AF2OE9DF03083O00B88121AFE7857A9803073O001DEBE455DB8EEB03163O0008C7BFFF7B4B344134DABDF2717A2F571FC6B5D36D4B03083O00325DB4DABD172E47025O0028AB40025O005DB24003083O00F871D1235B2D1ED803073O0079AB14A557324303103O00F32BBC1EBC03CA31B731890DD231B63803063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E603113O00F28C5E0E05E3DDB9501605E2D4A75E0F0903063O008DBAE93F626C025O0016B140025O0022AD40025O004AB340025O00B4944003083O00C949F6E87EF44BF103053O00179A2C829C03083O0024B5A886390514B403063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E03093O009C86C62B2E993CB98C03073O0055D4E9B04E5CCD026O001840025O00E4A640025O002EB04003083O0073ADB3F7194EAFB403053O007020C8C78303113O0019435997C1B82B28595DB6F0A82320554F03073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE03103O0082284045B2A42B5D7FB5AC26565F9E9D03053O00D6CD4A332C025O00388240025O00A0604003083O00795D9CF643568FF103043O00822A38E8030E3O00C6B42AE75333E3B121D6533EEDB003063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C12303123O001F76F14A2F7CCB5E0178E3512F4CF7592B7C03043O00384C198403083O006DC4BF32C650C6B803053O00AF3EA1CB4603113O000FD2D6013639F2C53E343BD4C03D3431D803053O00555CBDA373026O007B4003083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC030D3O00184CCFA4FF71293947C9B2FC6E03073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A351030B3O003E4B30B33A45C71B1C443003083O006E7A2243C35F298503083O0046B44F5EDF7BB64803053O00B615D13B2A030E3O008244C03524BFBB43CD0E35B1B95203063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D030D3O008D8F04C26D7EB69E0AC07C5E9503063O0016C5EA65AE1900D0012O0012313O00014O00D6000100023O002E1B010200C72O01000200041E3O00C92O010026163O00C92O01000300041E3O00C92O0100260D0001000A0001000100041E3O000A0001002E1B010400FEFF2O000500041E3O00060001001231000200013O000E470006000F0001000200041E3O000F0001002E99000700570001000800041E3O00570001001231000300013O00260D000300140001000100041E3O00140001002E1B0109001E0001000A00041E3O003000010012030004000B4O0015010500013O00122O0006000C3O00122O0007000D6O0005000700024O0004000400054O000500013O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500062O000400220001000100041E3O00220001001231000400014O001000045O0012150004000B6O000500013O00122O000600103O00122O000700116O0005000700024O0004000400054O000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000400023O00122O000300033O00260D000300340001001400041E3O00340001002E99001500360001001600041E3O00360001001231000200173O00041E3O0057000100260D0003003A0001000300041E3O003A0001002E99001800100001001900041E3O001000010012030004000B4O0002010500013O00122O0006001A3O00122O0007001B6O0005000700024O0004000400054O000500013O00122O0006001C3O00122O0007001D6O0005000700024O0004000400054O000400033O00122O0004000B6O000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O00040004000500062O000400540001000100041E3O00540001001231000400014O0010000400043O001231000300143O00041E3O0010000100260D0002005B0001000100041E3O005B0001002E06002300980001002200041E3O009800010012030003000B4O0015010400013O00122O000500243O00122O000600256O0004000600024O0003000300044O000400013O00122O000500263O00122O000600276O0004000600024O00030003000400062O000300690001000100041E3O00690001001231000300284O0010000300053O0012250103000B6O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400062O000300780001000100041E3O00780001001231000300284O0010000300063O0012250103000B6O000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300044O000400013O00122O0005002F3O00122O000600306O0004000600024O00030003000400062O000300870001000100041E3O00870001001231000300014O0010000300073O0012250103000B6O000400013O00122O000500313O00122O000600326O0004000600024O0003000300044O000400013O00122O000500333O00122O000600346O0004000600024O00030003000400062O000300960001000100041E3O00960001001231000300014O0010000300083O001231000200033O002616000200CB0001003500041E3O00CB00010012030003000B4O008B000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O0003000300042O0010000300093O0012110103000B6O000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600022O00800003000300042O00100003000A3O0012030003000B4O007F000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000400013O00122O000500403O00122O000600416O0004000600024O0003000300044O0003000B3O00122O0003000B6O000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O0003000300044O0003000C3O00122O000200063O002616000200132O01000300041E3O00132O01001231000300013O002616000300EC0001000300041E3O00EC00010012030004000B4O0015010500013O00122O000600463O00122O000700476O0005000700024O0004000400054O000500013O00122O000600483O00122O000700496O0005000700024O00040004000500062O000400DE0001000100041E3O00DE0001001231000400014O00100004000D3O0012150004000B6O000500013O00122O0006004A3O00122O0007004B6O0005000700024O0004000400054O000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O0004000E3O00122O000300143O00260D000300F00001000100041E3O00F00001002E06004F000C2O01004E00041E3O000C2O010012030004000B4O0002010500013O00122O000600503O00122O000700516O0005000700024O0004000400054O000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O0004000F3O00122O0004000B6O000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O000500013O00122O000600563O00122O000700576O0005000700024O00040004000500062O0004000A2O01000100041E3O000A2O01001231000400284O0010000400103O001231000300033O00260D000300102O01001400041E3O00102O01002E99005800CE0001005900041E3O00CE0001001231000200143O00041E3O00132O0100041E3O00CE00010026160002005B2O01001700041E3O005B2O01001231000300013O00260D0003001A2O01000300041E3O001A2O01002E99005A00362O01005B00041E3O00362O010012030004000B4O0002010500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000400113O00122O0004000B6O000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O00040004000500062O000400342O01000100041E3O00342O01001231000400014O0010000400123O001231000300143O0026160003003A2O01001400041E3O003A2O01001231000200643O00041E3O005B2O0100260D0003003E2O01000100041E3O003E2O01002E06006600162O01006500041E3O00162O010012030004000B4O0002010500013O00122O000600673O00122O000700686O0005000700024O0004000400054O000500013O00122O000600693O00122O0007006A6O0005000700024O0004000400054O000400133O00122O0004000B6O000500013O00122O0006006B3O00122O0007006C6O0005000700024O0004000400054O000500013O00122O0006006D3O00122O0007006E6O0005000700024O00040004000500062O000400582O01000100041E3O00582O01001231000400014O0010000400143O001231000300033O00041E3O00162O01002E990070008D2O01006F00041E3O008D2O010026160002008D2O01006400041E3O008D2O010012030003000B4O0015010400013O00122O000500713O00122O000600726O0004000600024O0003000300044O000400013O00122O000500733O00122O000600746O0004000600024O00030003000400062O0003006D2O01000100041E3O006D2O01001231000300284O0010000300153O0012250103000B6O000400013O00122O000500753O00122O000600766O0004000600024O0003000300044O000400013O00122O000500773O00122O000600786O0004000600024O00030003000400062O0003007C2O01000100041E3O007C2O01001231000300284O0010000300163O0012250103000B6O000400013O00122O000500793O00122O0006007A6O0004000600024O0003000300044O000400013O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400062O0003008B2O01000100041E3O008B2O01001231000300284O0010000300173O00041E3O00CF2O01002E1B017D007EFE2O007D00041E3O000B0001000EAC0014000B0001000200041E3O000B00010012030003000B4O0018010400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300044O000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000300183O00122O0003000B6O000400013O00122O000500823O00122O000600836O0004000600024O0003000300044O000400013O00122O000500843O00122O000600856O0004000600024O0003000300044O000300193O00122O0003000B6O000400013O00122O000500863O00122O000600876O0004000600024O0003000300044O000400013O00122O000500883O00122O000600896O0004000600024O0003000300044O0003001A3O00122O0003000B6O000400013O00122O0005008A3O00122O0006008B6O0004000600024O0003000300044O000400013O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400062O000300C32O01000100041E3O00C32O01001231000300014O00100003001B3O001231000200353O00041E3O000B000100041E3O00CF2O0100041E3O0006000100041E3O00CF2O010026163O00020001000100041E3O00020001001231000100014O00D6000200023O0012313O00033O00041E3O000200012O0027012O00017O0083012O00028O00025O00C09640025O0080B040025O00889A40025O00A0A240030C3O004570696353652O74696E677303073O001DA3373F25A92303043O005849CC502O033O00218C1303063O00BA4EE3702649026O00F03F03073O00C858FA525F7FEF03063O001A9C379D35332O033O008DD71303063O0030ECB876B9D8025O002EA540025O00C8AD4003073O00D1B25037C331F603063O005485DD3750AF2O033O00BEE33703063O003CDD8744C6A703073O00DAB2FF844EDCFD03063O00B98EDD98E32203043O0050C056F603073O009738A5379A2353025O00508740025O0046A24003073O00944C02E9AC461603043O008EC0236503063O00D27C3AB3E28003083O0076B61549C387ECCC027O0040025O0074A740025O00F08B40025O00809540025O00209040030D3O004973446561644F7247686F737403073O002D240A552O0AF803073O009D685C7A20646D03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974025O00F6A240025O0046AB40025O0082AA40025O005AAE40025O00D8B04003093O00466F637573556E6974026O003E40025O002OA040025O00689B40025O00E8B140025O0090A940030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O004C9040025O00CCAB40025O00C05140025O00D2A54003043O004755494403043O0082B3DBC503083O00CBC3C6AFAA5D47ED030D3O001D442BC75214F328663FD2581203073O009C4E2B5EB53171030A3O0049734361737461626C65025O00888140025O00788C40030C3O0053686F756C6452657475726E03123O00466F637573537065636966696564556E6974026O003940025O00288540025O002FB04003083O0057FEC1B1124C2O7703073O00191288A4C36B23030E3O00DE28BB4B73B2D59DE52FBB4E71B903083O00D8884DC92F12DCA103083O0008FA2EC811D38C2803073O00E24D8C4BBA68BC030E3O009CC3D52D4EB5CAF23340AADDDF3203053O002FD9AEB05F025O0046B140025O00E8A140025O0074AA40025O00F8A34003083O0096D262428655762D03083O0046D8BD1662D23418030E3O00ECDAB183D2D4CB868AD1C8DEA08203053O00B3BABFC3E7025O0044B340025O00308C40025O00707F40025O00449640025O0007B34003103O004865616C746850657263656E74616765025O00A6A340025O00D0A14003063O00C82603C5DAF603063O00A4806342899F025O0080A74003073O0024A8C49F27ACDB03043O00DE60E989025O00707240025O00388840025O00DCB240025O0096A740030C3O00476574466F637573556E697403063O00D11A39C8DC0D03043O0084995F7803073O009593230CD0FF9203073O00C0D1D26E4D97BA025O001AA240025O00CCA040025O0098A840025O00188740025O00E0B140025O003AB240025O0006AE40025O00ACA74003083O0049734D6F76696E6703123O004C61737453746174696F6E61727954696D6503073O0047657454696D65026O000840026O002040025O00B4A340025O00C09840030F3O00412O66656374696E67436F6D626174025O005AA940025O006AB140025O0014A740025O0040A040025O00307D40026O004D40025O00508340025O00D88B40025O008EAC40025O00BFB040025O004CAC4003043O002DE7E98703053O00116C929DE8026O004140025O0012A440030D3O0078CC01FF2CAD44C539EC28A14803063O00C82BA3748D4F03093O004973496E52616E676503123O00536F757263656F664D61676963466F637573025O0078A640025O00AC944003193O00AC392891B3F1DCB030028EB1F3EABC762D91B5F7ECB2343C9703073O0083DF565DE3D094025O00B89F4003083O00D040BAB31EA1E64103063O00D583252OD67D025O00E09F40025O00508540025O00D07040025O009CA24003093O004E616D6564556E6974030D3O00152430ADE223242392E021222603053O0081464B45DF03113O00536F757263656F664D616769634E616D6503193O0055C4E6FB7FEA79C4F5D671EE41C2F0A96CFD43C8FCE47EEE5203063O008F26AB93891C030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003133O0049726964657363656E6365426C756542752O66025O00208A40025O0024B040025O005AA740025O009C9040025O00CCA240025O002AA940025O00DEAB40025O006BB140025O00109D40025O0022A040025O0096A040025O001EB340030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O0046AC40025O00A8A040025O000EAA40025O007DB140025O0022AC40025O002CAB40025O00688240025O00109B40025O0040604003113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572025O00188B40025O001EA940025O00C88440025O00BDB140025O00049140025O00FEAA40025O0084AB40025O00C4A040025O0074A94003053O0036BF100D0A03063O00887ED066687803053O00486F766572030C3O007085D846BD12305071848E1103083O003118EAAE23CF325D025O0061B140025O0078AC40025O00206340025O007C9D40025O00949B40026O008440026O006940025O00B6AF40025O0014A940025O00E09540025O00909540025O002EAE40025O00E06640025O001AAA4003043O00502O6F6C030E3O00E08DB6FF43E5DB2OC298FC06AB9D03073O00B4B0E2D9936383025O00A07A40025O0098A940025O0010AC40025O00F8AF4003093O00497343617374696E67030C3O0049734368612O6E656C696E67025O0068AA4003093O00496E74652O7275707403053O005175652O6C026O002440025O00E9B240025O00F5B140025O00F4AE4003113O00496E74652O72757074576974685374756E03093O005461696C5377697065025O00E2A740025O006AA04003093O004D6F7573656F766572030E3O005175652O6C4D6F7573656F766572030A3O00A9E284E83283E284E83803053O005DED90E58F030F3O00432O6F6C646F776E52656D61696E73030D3O0030E2F50B054F01EFC30C19411003063O0026759690796B030A3O000BB2FC3F0FA9EB3B39B303043O005A4DDB8E03073O00D30A33385A027603073O001A866441592C67030B3O00456E656D794162736F7262025O0012AF40025O0050B24003073O00556E726176656C030E3O0049735370652O6C496E52616E6765025O00308840025O00707C40030E3O00E4ED2O22B2F4EF702EA5F8ED707703053O00C491835043026O008A40025O0056A240025O00389E40025O00B2A540025O00E08240025O003DB240025O0050A040025O00B6A240025O00209F40025O0074A440025O00ECA940025O00207A40025O00C6AF40025O00D2A340030D3O00E3B6200B93BF2015938A1B4F9A03043O0067B3D94F026O001440025O0049B040025O00B8AF40030A3O005370652O6C4861737465026O001840025O00805540025O00F08240030D3O00546172676574497356616C6964025O002AA340024O0080B3C540030C3O00466967687452656D61696E73025O00E8A440025O0083B040025O00B07140025O000EA64003103O00426F2O73466967687452656D61696E732O033O00474344026O00D03F025O0092B040025O00E07640025O0068B240030A3O0046697265427265617468025O0060A740025O00289740025O00D09640025O00606540025O0053B240025O00FAA040025O00E8B240025O0058AE40025O0008954003093O00436173745374617274025O0040AA40030F3O00456D706F7765724361737454696D65025O00E89040026O00A640025O00ECAD40025O00E8B040030D3O009CA3AE1CBBF6E4ADBAA9189BC003073O0090D9D3C77FE893030A3O00DE262C2DF7570745EC2703083O0024984F5E48B5256203083O00E5DD532AC5D66E1B03043O005FB7B82703143O00862BE83644890CB27FC12F468542972DE227408803073O0062D55F874634E0025O002C9140025O0092B240025O001CB340030D3O00457465726E6974795375726765025O00B2A240025O00809940025O00DCA240030D3O00DBB3C07467FBB7DD7E5AF9B0FA03053O00349EC3A917030D3O005FA83766883C6F9249A920738303083O00EB1ADC5214E6551B03083O00BAA4FDD7668688CD03053O0014E8C189A203163O0011CBCAB6F785197662FAD1A3F5821E653BECD0B4E08903083O001142BFA5C687EC77025O00DAA140025O0032A040025O009CA640025O00DEA54003093O00486F76657242752O66026O001040025O00EC9340025O002AAC40026O006E40025O00989240031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O00D88340025O00A2A14003113O00476574456E656D696573496E52616E676503173O00476574456E656D696573496E53706C61736852616E6765025O00A49E40025O00B0804003133O002DA3AB00ECE1E2D600A9BA1BFACAFEDE01B5AB03083O00B16FCFCE739F888C03083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E67025O00806840025O009EA74003133O00426C652O73696E676F6674686542726F6E7A6503203O0007851507C7465102B61F12EB5B5700B61206DB414500C90006D14C50088B110003073O003F65E97074B42F026O001C40026O00A040025O00CEA740030A3O00447261676F6E72616765025O00B07940025O0034A740025O00809440025O00E8A040025O0098AA40025O00E09040025O00CCA640025O00C4AA40025O00D49B40025O0018B140025O00CCAF40025O00288940025O0042B040025O0028B34003053O00EB34FB17EA03063O0056A35B8D7298030C3O005B046276281306757A34135903053O005A336B14130003082O0012313O00014O00D6000100013O002E99000200020001000300041E3O000200010026163O00020001000100041E3O00020001001231000100013O00260D0001000B0001000100041E3O000B0001002E990005002E0001000400041E3O002E0001001231000200013O0026160002001D0001000100041E3O001D00012O00AE00036O0002000300010001001215000300066O000400023O00122O000500073O00122O000600086O0004000600024O0003000300044O000400023O00122O000500093O00122O0006000A6O0004000600024O0003000300044O000300013O00122O0002000B3O0026160002000C0001000B00041E3O000C0001001203000300064O000C000400023O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000400023O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000300033O00122O0001000B3O00044O002E000100041E3O000C0001002616000100610001000B00041E3O00610001001231000200013O002E060010004E0001001100041E3O004E0001000EAC0001004E0001000200041E3O004E0001001203000300064O007F000400023O00122O000500123O00122O000600136O0004000600024O0003000300044O000400023O00122O000500143O00122O000600156O0004000600024O0003000300044O000300043O00122O000300066O000400023O00122O000500163O00122O000600176O0004000600024O0003000300044O000400023O00122O000500183O00122O000600196O0004000600024O0003000300044O000300053O00122O0002000B3O00260D000200520001000B00041E3O00520001002E99001B00310001001A00041E3O00310001001203000300064O000C000400023O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400023O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000300063O00122O000100203O00044O0061000100041E3O00310001002E99002200080201002100041E3O00080201002616000100080201002000041E3O00080201001231000200013O000E470001006A0001000200041E3O006A0001002E99002300F92O01002400041E3O00F92O012O00AE000300073O0020BC0003000300252O00C70003000200020006380003007000013O00041E3O007000012O0027012O00014O00AE000300083O000638000300C600013O00041E3O00C600012O00AE000300094O0067000400023O00122O000500263O00122O000600276O0004000600024O00030003000400202O0003000300284O00030002000200062O000300C600013O00041E3O00C600012O00AE0003000A3O00202F0003000300292O0028010300010002000638000300C600013O00041E3O00C60001001231000300014O00D6000400073O002616000300890001000100041E3O00890001001231000400014O00D6000500053O0012310003000B3O002616000300BE0001002000041E3O00BE0001002E1B012A00070001002A00041E3O00920001002616000400920001000100041E3O00920001001231000500014O00D6000600063O0012310004000B3O002E06002C008B0001002B00041E3O008B00010026160004008B0001000B00041E3O008B00012O00D6000700073O00260D0005009B0001000100041E3O009B0001002E06002E00B40001002D00041E3O00B40001001231000800014O00D6000900093O000EAC0001009D0001000800041E3O009D0001001231000900013O000EAC000100AB0001000900041E3O00AB00012O00AE000600084O0006010A000A3O00202O000A000A002F4O000B00066O000C000B3O00122O000D00306O000A000D00024O0007000A3O00122O0009000B3O00260D000900AF0001000B00041E3O00AF0001002E06003100A00001003200041E3O00A000010012310005000B3O00041E3O00B4000100041E3O00A0000100041E3O00B4000100041E3O009D0001002616000500970001000B00041E3O00970001000638000700F82O013O00041E3O00F82O012O00E3000700023O00041E3O00F82O0100041E3O0097000100041E3O00F82O0100041E3O008B000100041E3O00F82O01000E47000B00C20001000300041E3O00C20001002E99003300840001003400041E3O008400012O00D6000600073O001231000300203O00041E3O0084000100041E3O00F82O012O00AE0003000C4O0028010300010002000638000300232O013O00041E3O00232O012O00AE0003000D3O0020320003000300354O000500093O00202O0005000500364O00030005000200262O000300232O01003700041E3O00232O01001231000300014O00D6000400053O002E99003800DA0001003900041E3O00DA0001002616000300DA0001000100041E3O00DA0001001231000400014O00D6000500053O0012310003000B3O000EAC000B00D30001000300041E3O00D30001002E1B013A3O0001003A00041E3O00DC0001000EAC000100DC0001000400041E3O00DC0001001231000500013O002E1B013B3O0001003B00041E3O00E10001002616000500E10001000100041E3O00E100012O00AE0006000C4O001F00060001000200202O00060006003C4O0006000200024O0006000E6O0006000F6O000700023O00122O0008003D3O00122O0009003E6O00070009000200062O000600F82O01000700041E3O00F82O012O00AE0006000C4O00280106000100020020320006000600354O000800093O00202O0008000800364O00060008000200262O000600F82O01003700041E3O00F82O012O00AE000600094O0067000700023O00122O0008003F3O00122O000900406O0007000900024O00060006000700202O0006000600414O00060002000200062O000600F82O013O00041E3O00F82O01001231000600014O00D6000700073O00260D000600092O01000100041E3O00092O01002E06004300052O01004200041E3O00052O01001231000700013O0026160007000A2O01000100041E3O000A2O012O00AE0008000A3O0020A20008000800454O0009000C6O00090001000200122O000A00466O0008000A000200122O000800443O00122O000800443O00062O000800F82O013O00041E3O00F82O01001203000800444O00E3000800023O00041E3O00F82O0100041E3O000A2O0100041E3O00F82O0100041E3O00052O0100041E3O00F82O0100041E3O00E1000100041E3O00F82O0100041E3O00DC000100041E3O00F82O0100041E3O00D3000100041E3O00F82O012O00AE000300053O0006C0000300282O01000100041E3O00282O01002E99004800F82O01004700041E3O00F82O012O00AE000300104O003B000400023O00122O000500493O00122O0006004A6O00040006000200062O000300392O01000400041E3O00392O012O00AE000300094O0085000400023O00122O0005004B3O00122O0006004C6O0004000600024O00030003000400202O0003000300284O00030002000200062O0003004A2O01000100041E3O004A2O012O00AE000300114O003B000400023O00122O0005004D3O00122O0006004E6O00040006000200062O000300652O01000400041E3O00652O012O00AE000300094O0067000400023O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O0003000300284O00030002000200062O000300652O013O00041E3O00652O01001231000300014O00D6000400043O002E060052004C2O01005100041E3O004C2O010026160003004C2O01000100041E3O004C2O01001231000400013O00260D000400552O01000100041E3O00552O01002E99005300512O01005400041E3O00512O012O00AE0005000A3O00200100050005002F4O00068O000700096O00050009000200122O000500443O00122O000500443O00062O000500F82O013O00041E3O00F82O01001203000500444O00E3000500023O00041E3O00F82O0100041E3O00512O0100041E3O00F82O0100041E3O004C2O0100041E3O00F82O012O00AE000300104O003B000400023O00122O000500553O00122O000600566O00040006000200062O000300F82O01000400041E3O00F82O012O00AE000300094O0067000400023O00122O000500573O00122O000600586O0004000600024O00030003000400202O0003000300284O00030002000200062O000300F82O013O00041E3O00F82O01001231000300014O00D6000400063O000E47000B007C2O01000300041E3O007C2O01002E06005900E42O01005A00041E3O00E42O012O00D6000600063O00260D000400812O01000B00041E3O00812O01002E99005C00C52O01005B00041E3O00C52O01002E1B015D001E0001005D00041E3O009F2O010020BC00070005005E2O00C70007000200020020BC00080006005E2O00C70008000200020006DC0007009F2O01000800041E3O009F2O01001231000700013O002E060060008A2O01005F00041E3O008A2O010026160007008A2O01000100041E3O008A2O012O00AE0008000A3O00202B01080008002F4O00098O000A000B6O000C00023O00122O000D00613O00122O000E00626O000C000E6O00083O000200122O000800443O00122O000800443O00062O0008009F2O013O00041E3O009F2O01001203000800444O00E3000800023O00041E3O009F2O0100041E3O008A2O010020BC00070006005E2O00C70007000200020020BC00080005005E2O00C700080002000200065F000800A62O01000700041E3O00A62O0100041E3O00F82O01001231000700014O00D6000800083O002616000700A82O01000100041E3O00A82O01001231000800013O002E1B01633O0001006300041E3O00AB2O01002616000800AB2O01000100041E3O00AB2O012O00AE0009000A3O00207000090009002F4O000A8O000B000C6O000D00023O00122O000E00643O00122O000F00656O000D000F6O00093O000200122O000900443O002E2O006600F82O01006700041E3O00F82O01001203000900443O000638000900F82O013O00041E3O00F82O01001203000900444O00E3000900023O00041E3O00F82O0100041E3O00AB2O0100041E3O00F82O0100041E3O00A82O0100041E3O00F82O0100260D000400C92O01000100041E3O00C92O01002E990068007D2O01006900041E3O007D2O012O00AE0007000A3O0020A600070007006A4O00088O000900096O000A00023O00122O000B006B3O00122O000C006C6O000A000C6O00073O000200062O000500D52O01000700041E3O00D52O012O00AE000500074O00AE0007000A3O0020A600070007006A4O00088O000900096O000A00023O00122O000B006D3O00122O000C006E6O000A000C6O00073O000200062O000600E12O01000700041E3O00E12O012O00AE000600073O0012310004000B3O00041E3O007D2O0100041E3O00F82O01002E99007000782O01006F00041E3O00782O01002616000300782O01000100041E3O00782O01001231000700013O00260D000700ED2O01000100041E3O00ED2O01002E1B017100050001007200041E3O00F02O01001231000400014O00D6000500053O0012310007000B3O002E06007300E92O01007400041E3O00E92O01002616000700E92O01000B00041E3O00E92O010012310003000B3O00041E3O00782O0100041E3O00E92O0100041E3O00782O010012310002000B3O00260D000200FD2O01000B00041E3O00FD2O01002E1B0175006BFE2O007600041E3O006600012O00AE000300073O0020BC0003000300772O00C70003000200020006C0000300050201000100041E3O00050201001203000300794O00280103000100020012F6000300783O0012310001007A3O00041E3O0008020100041E3O00660001002616000100EA0401007B00041E3O00EA0401002E06007D002C0201007C00041E3O002C02012O00AE000200073O0020BC00020002007E2O00C70002000200020006380002002C02013O00041E3O002C0201001231000200014O00D6000300043O002616000200180201000100041E3O00180201001231000300014O00D6000400043O0012310002000B3O002E1B017F00FBFF2O007F00041E3O00130201002616000200130201000B00041E3O0013020100260D000300200201000100041E3O00200201002E990080001C0201008100041E3O001C02012O00AE000500124O00280105000100022O0018000400053O0006C0000400270201000100041E3O00270201002E990082002C0201008300041E3O002C02012O00E3000400023O00041E3O002C020100041E3O001C020100041E3O002C020100041E3O00130201002E06008400DA0401008500041E3O00DA04012O00AE000200073O0020BC00020002007E2O00C70002000200020006C0000200360201000100041E3O003602012O00AE000200013O000638000200DA04013O00041E3O00DA0401001231000200014O00D6000300063O0026160002003D0201000100041E3O003D0201001231000300014O00D6000400043O0012310002000B3O000E47002000410201000200041E3O00410201002E06008700D00401008600041E3O00D0040100260D000300450201000B00041E3O00450201002E06008800C40401008900041E3O00C404012O00D6000600063O002616000400D40201002000041E3O00D402012O00AE0007000F4O003B000800023O00122O0009008A3O00122O000A008B6O0008000A000200062O0007007B0201000800041E3O007B0201002E99008C007B0201008D00041E3O007B02012O00AE000700094O0067000800023O00122O0009008E3O00122O000A008F6O0008000A00024O00070007000800202O0007000700414O00070002000200062O0007007B02013O00041E3O007B02012O00AE0007000D3O0020BC000700070090001231000900464O00930007000900020006380007007B02013O00041E3O007B02012O00AE0007000E4O00AE0008000D3O0020BC00080008003C2O00C70008000200020006A50007007B0201000800041E3O007B02012O00AE0007000D3O0020320007000700354O000900093O00202O0009000900364O00070009000200262O0007007B0201003700041E3O007B02012O00AE000700134O00AE0008000B3O00202F0008000800912O00C70007000200020006C0000700760201000100041E3O00760201002E1B019200070001009300041E3O007B02012O00AE000700023O001231000800943O001231000900954O006C000700094O009500075O002E1B0196000A0001009600041E3O008502012O00AE0007000F4O00C5000800023O00122O000900973O00122O000A00986O0008000A000200062O000700850201000800041E3O0085020100041E3O00C50201001231000700014O00D60008000A3O00260D0007008B0201000B00041E3O008B0201002E1B019900360001009A00041E3O00BF02012O00D6000A000A3O002616000800910201000100041E3O00910201001231000900014O00D6000A000A3O0012310008000B3O0026160008008C0201000B00041E3O008C020100260D000900970201000100041E3O00970201002E06009C00930201009B00041E3O009302012O00AE000B000A3O0020A4000B000B009D00122O000C00466O000D00146O000B000D00024O000A000B3O00062O000A00C502013O00041E3O00C502012O00AE000B00094O0067000C00023O00122O000D009E3O00122O000E009F6O000C000E00024O000B000B000C00202O000B000B00414O000B0002000200062O000B00C502013O00041E3O00C502010020BC000B000A00352O00AE000D00093O00202F000D000D00362O0093000B000D0002002644000B00C50201003700041E3O00C502012O00AE000B00134O00AE000C000B3O00202F000C000C00A02O00C7000B00020002000638000B00C502013O00041E3O00C502012O00AE000B00023O001200010C00A13O00122O000D00A26O000B000D6O000B5O00044O00C5020100041E3O0093020100041E3O00C5020100041E3O008C020100041E3O00C50201002616000700870201000100041E3O00870201001231000800014O00D6000900093O0012310007000B3O00041E3O008702012O00AE0007000A3O0020F40007000700A34O000800073O00202O0008000800A44O000A00093O00202O000A000A00A54O0008000A6O00073O00024O000500073O002E2O00A600D3020100A700041E3O00D30201000638000500D302013O00041E3O00D302012O00E3000500023O0012310004007A3O002E9900A90085030100A800041E3O00850301002616000400850301000B00041E3O00850301001231000700014O00D6000800083O002E9900AA00DA020100AB00041E3O00DA0201002616000700DA0201000100041E3O00DA0201001231000800013O000EAC002000E30201000800041E3O00E30201001231000400203O00041E3O00850301002616000800380301000100041E3O00380301002E0600AC0007030100AD00041E3O000703012O00AE000900153O0006380009000703013O00041E3O00070301001231000900014O00D6000A000A3O000E47000100F00201000900041E3O00F00201002E9900AF00EC020100AE00041E3O00EC0201001231000A00013O00260D000A00F50201000100041E3O00F50201002E9900B100F1020100B000041E3O00F102012O00AE000B000A3O002082000B000B00B24O000C00093O00202O000C000C00B34O000D000B3O00202O000D000D00B400122O000E00B56O000B000E00024O0006000B3O002E2O00B60009000100B600041E3O000703010006380006000703013O00041E3O000703012O00E3000600023O00041E3O0007030100041E3O00F1020100041E3O0007030100041E3O00EC0201002E0600B70037030100B800041E3O003703012O00AE000900163O0006380009003703013O00041E3O00370301001231000900014O00D6000A000B3O000E47000B00120301000900041E3O00120301002E9900B9002F030100BA00041E3O002F030100260D000A00160301000100041E3O00160301002E1B01BB00FEFF2O00BC00041E3O00120301001231000B00013O002E9900BE0017030100BD00041E3O00170301002616000B00170301000100041E3O001703012O00AE000C000A3O002008010C000C00BF4O000D00093O00202O000D000D00C04O000E000B3O00202O000E000E00C100122O000F00306O001000016O000C001000024O0006000C3O00062O000600290301000100041E3O00290301002E0600C30037030100C200041E3O003703012O00E3000600023O00041E3O0037030100041E3O0017030100041E3O0037030100041E3O0012030100041E3O00370301002E9900C4000E030100C500041E3O000E03010026160009000E0301000100041E3O000E0301001231000A00014O00D6000B000B3O0012310009000B3O00041E3O000E03010012310008000B3O002616000800DF0201000B00041E3O00DF02012O00AE000900053O0006380009005B03013O00041E3O005B03012O00AE000900073O0020BC00090009007E2O00C70009000200020006380009005B03013O00041E3O005B0301001231000900014O00D6000A000B3O000EAC000100490301000900041E3O00490301001231000A00014O00D6000B000B3O0012310009000B3O002E9900C60044030100C700041E3O00440301002616000900440301000B00041E3O00440301002616000A004D0301000100041E3O004D03012O00AE000C00174O0028010C000100022O0018000B000C3O0006C0000B00560301000100041E3O00560301002E0600C8005B030100C900041E3O005B03012O00E3000B00023O00041E3O005B030100041E3O004D030100041E3O005B030100041E3O004403012O00AE000900183O0006380009006303013O00041E3O006303012O00AE000900073O0020BC00090009007E2O00C70009000200020006C0000900650301000100041E3O00650301002E99002B0081030100CA00041E3O00810301001203000900794O00D500090001000200122O000A00786O00090009000A4O000A00193O00062O000A00810301000900041E3O008103012O00AE000900094O0067000A00023O00122O000B00CB3O00122O000C00CC6O000A000C00024O00090009000A00202O0009000900284O00090002000200062O0009008103013O00041E3O008103012O00AE0009001A4O00AE000A00093O00202F000A000A00CD2O00C70009000200020006380009008103013O00041E3O008103012O00AE000900023O001231000A00CE3O001231000B00CF4O006C0009000B4O009500095O001231000800203O00041E3O00DF020100041E3O0085030100041E3O00DA0201000E47007A00890301000400041E3O00890301002E0600D000FB030100D100041E3O00FB03012O00AE000700043O0006C00007008E0301000100041E3O008E0301002E9900D300AD030100D200041E3O00AD0301001231000700014O00D6000800093O0026160007009D0301000B00041E3O009D0301002616000800920301000100041E3O009203012O00AE000A001B4O0028010A000100022O00180009000A3O000638000900AD03013O00041E3O00AD03012O00E3000900023O00041E3O00AD030100041E3O0092030100041E3O00AD0301002616000700900301000100041E3O00900301001231000A00013O002616000A00A50301000100041E3O00A50301001231000800014O00D6000900093O001231000A000B3O002E0600D500A0030100D400041E3O00A00301002616000A00A00301000B00041E3O00A003010012310007000B3O00041E3O0090030100041E3O00A0030100041E3O00900301002E0600D600B3030100D700041E3O00B303012O00AE0007001C3O002644000700B30301007A00041E3O00B3030100041E3O00F20301001231000700014O00D6000800093O002616000700E40301000B00041E3O00E4030100260D000800BB0301000100041E3O00BB0301002E9900D800D4030100D900041E3O00D40301001231000A00014O00D6000B000B3O002616000A00BD0301000100041E3O00BD0301001231000B00013O002616000B00CB0301000100041E3O00CB03012O00AE000C001D4O0028010C000100022O00180009000C3O002E0600DA00CA030100DB00041E3O00CA0301000638000900CA03013O00041E3O00CA03012O00E3000900023O001231000B000B3O002E9900DC00C0030100DD00041E3O00C00301002616000B00C00301000B00041E3O00C003010012310008000B3O00041E3O00D4030100041E3O00C0030100041E3O00D4030100041E3O00BD0301002616000800B70301000B00041E3O00B703012O00AE000A001A4O00AE000B00093O00202F000B000B00DE2O00C7000A00020002000638000A00F203013O00041E3O00F203012O00AE000A00023O001200010B00DF3O00122O000C00E06O000A000C6O000A5O00044O00F2030100041E3O00B7030100041E3O00F20301002616000700B50301000100041E3O00B50301001231000A00013O000EAC000B00EB0301000A00041E3O00EB03010012310007000B3O00041E3O00B50301002616000A00E70301000100041E3O00E70301001231000800014O00D6000900093O001231000A000B3O00041E3O00E7030100041E3O00B503012O00AE0007001E4O00280107000100022O0018000600073O0006C0000600F90301000100041E3O00F90301002E0600E200DA040100E100041E3O00DA04012O00E3000600023O00041E3O00DA040100260D000400FF0301000100041E3O00FF0301002E1B01E30049FE2O00E400041E3O004602012O00AE000700073O0020BC0007000700E52O00C70007000200020006C0000700400401000100041E3O004004012O00AE000700073O0020BC0007000700E62O00C70007000200020006C0000700400401000100041E3O00400401001231000700014O00D6000800083O002E1B01E70012000100E700041E3O001D04010026160007001D0401000100041E3O001D04012O00AE0009000A3O0020290109000900E84O000A00093O00202O000A000A00E900122O000B00EA6O000C00016O0009000C00024O000800093O002E2O00EC001C040100EB00041E3O001C04010006380008001C04013O00041E3O001C04012O00E3000800023O0012310007000B3O002E1B01ED000F000100ED00041E3O002C04010026160007002C0401000B00041E3O002C04012O00AE0009000A3O002O200009000900EE4O000A00093O00202O000A000A00EF00122O000B007B6O0009000B00024O000800093O00062O0008002B04013O00041E3O002B04012O00E3000800023O001231000700203O000E47002000300401000700041E3O00300401002E9900F0000B040100F100041E3O000B04012O00AE0009000A3O0020B90009000900E84O000A00093O00202O000A000A00E900122O000B00EA6O000C00013O00122O000D00F26O000E000B3O00202O000E000E00F34O0009000E00024O000800093O0006380008004004013O00041E3O004004012O00E3000800023O00041E3O0040040100041E3O000B04012O00AE000700204O00B4000800096O000900023O00122O000A00F43O00122O000B00F56O0009000B00024O00080008000900202O0008000800F64O0008000200024O000900096O000A00023O00122O000B00F73O00122O000C00F86O000A000C00024O00090009000A00202O0009000900F64O0009000200024O000A00213O00102O000A0020000A4O00090009000A4O000A00096O000B00023O00122O000C00F93O00122O000D00FA6O000B000D00024O000A000A000B00202O000A000A00F64O000A000200024O000B00216O000A000A000B4O0007000A00024O0007001F6O000700096O000800023O00122O000900FB3O00122O000A00FC6O0008000A00024O00070007000800202O0007000700284O00070002000200062O0007006F04013O00041E3O006F04012O00AE000700223O0020BC0007000700FD2O00C70007000200020006C0000700710401000100041E3O00710401002E9900FF0087040100FE00041E3O008704012O00AE0007001A4O00C2000800093O00202O000800082O00013O000900223O00122O000B002O015O00090009000B4O000B00093O00202O000B000B2O00013O0009000B00024O000900096O00070009000200062O000700820401000100041E3O0082040100123100070002012O00123100080003012O0006DC000700870401000800041E3O008704012O00AE000700023O00123100080004012O00123100090005013O006C000700094O009500076O00AE000700233O0006C0000700910401000100041E3O009104012O00AE000700083O0006C0000700910401000100041E3O0091040100123100070006012O00123100080007012O0006A5000700C10401000800041E3O00C10401001231000700014O00D60008000A3O001231000B00013O0006A5000700990401000B00041E3O00990401001231000800014O00D6000900093O0012310007000B3O001231000B000B3O0006F8000700A00401000B00041E3O00A00401001231000B0008012O001231000C0009012O0006A5000B00930401000C00041E3O009304012O00D6000A000A3O001231000B00013O0006F8000800A80401000B00041E3O00A80401001231000B000A012O001231000C000B012O0006A5000B00AB0401000C00041E3O00AB0401001231000900014O00D6000A000A3O0012310008000B3O001231000B000B3O0006F8000800B20401000B00041E3O00B20401001231000B000C012O001231000C000D012O0006DC000C00A10401000B00041E3O00A10401001231000B00013O0006A5000B00B20401000900041E3O00B204012O00AE000B00244O0028010B000100022O0018000A000B3O000638000A00C104013O00041E3O00C104012O00E3000A00023O00041E3O00C1040100041E3O00B2040100041E3O00C1040100041E3O00A1040100041E3O00C1040100041E3O009304010012310004000B3O00041E3O0046020100041E3O00DA04010012310007000E012O0012310008000F012O00065F000700410201000800041E3O00410201001231000700013O0006A5000300410201000700041E3O00410201001231000400014O00D6000500053O0012310003000B3O00041E3O0041020100041E3O00DA04010012310007000B3O0006F8000200D70401000700041E3O00D7040100123100070010012O00123100080011012O0006A5000700380201000800041E3O003802012O00D6000500063O001231000200203O00041E3O003802012O00AE0002001A4O00AE000300093O00202F0003000300DE2O00C70002000200020006C0000200E40401000100041E3O00E4040100123100020012012O00123100030013012O00065F000200020801000300041E3O000208012O00AE000200023O00120001030014012O00122O00040015015O000200046O00025O00044O0002080100123100020016012O0006A50002007D0501000100041E3O007D0501001231000200014O00D6000300033O001231000400013O0006F8000400F60401000200041E3O00F6040100123100040017012O00123100050018012O00065F000400EF0401000500041E3O00EF0401001231000300013O0012310004000B3O0006A5000300010501000400041E3O000105012O00AE000400073O0012EF00060019015O0004000400064O0004000200024O000400253O00122O0001001A012O00044O007D0501001231000400013O0006A5000300F70401000400041E3O00F70401001231000400013O001231000500013O0006F80004000C0501000500041E3O000C05010012310005001B012O0012310006001C012O00065F000600740501000500041E3O007405012O00AE0005000A3O0012310006001D013O00800005000500062O00280105000100020006C0000500170501000100041E3O001705012O00AE000500073O0020BC00050005007E2O00C70005000200020006380005006305013O00041E3O00630501001231000500014O00D6000600063O001231000700013O0006A5000700190501000500041E3O00190501001231000600013O0012310007000B3O0006F8000600240501000700041E3O00240501001231000700D23O0012310008001E012O00065F000800300501000700041E3O003005012O00AE000700263O0012310008001F012O0006A5000700630501000800041E3O006305012O00AE000700273O00127700080020015O0007000700084O000800286O00098O0007000900024O000700263O00044O00630501001231000700013O0006F8000600370501000700041E3O0037050100123100070021012O00123100080022012O00065F0008001D0501000700041E3O001D0501001231000700014O00D6000800083O001231000900013O0006A5000900390501000700041E3O00390501001231000800013O001231000900013O0006F8000900440501000800041E3O0044050100123100090023012O001231000A0024012O00065F000A00580501000900041E3O00580501001231000900013O001231000A00013O0006A5000900520501000A00041E3O005205012O00AE000A00273O00126B000B0025015O000A000A000B4O000B000B6O000C00016O000A000C00024O000A00296O000A00296O000A00263O00122O0009000B3O001231000A000B3O0006A5000900450501000A00041E3O004505010012310008000B3O00041E3O0058050100041E3O004505010012310009000B3O0006A50008003D0501000900041E3O003D05010012310006000B3O00041E3O001D050100041E3O003D050100041E3O001D050100041E3O0039050100041E3O001D050100041E3O0063050100041E3O001905012O00AE0005002A4O00EB000600073O00122O00080026015O0006000600084O00060002000200122O00070027015O0005000700024O0006002B6O000700073O00122O00090026015O0007000700094O00070002000200122O00080027015O0006000800024O0005000500064O000500213O00122O0004000B3O0012310005000B3O0006A50004002O0501000500041E3O002O05010012310003000B3O00041E3O00F7040100041E3O002O050100041E3O00F7040100041E3O007D050100041E3O00EF040100123100020028012O00123100030029012O0006DC000300980601000200041E3O009806010012310002007A3O0006A5000100980601000200041E3O00980601001231000200014O00D6000300033O001231000400013O0006A5000200860501000400041E3O00860501001231000300013O001231000400013O0006A5000300800601000400041E3O008006010012310004002A012O0012310005002A012O0006A50004001B0601000500041E3O001B06012O00AE000400073O00203A0004000400E64O000600093O00122O0007002B015O0006000600074O00040006000200062O0004001B06013O00041E3O001B0601001231000400014O00D6000500073O001231000800B83O0012310009002C012O00065F000900100601000800041E3O001006010012310008000B3O0006A5000800100601000400041E3O001006012O00D6000700073O0012310008002D012O0012310009002E012O00065F000900BB0501000800041E3O00BB0501001231000800013O0006A5000800BB0501000500041E3O00BB0501001231000800013O0012310009000B3O0006F8000800B20501000900041E3O00B205010012310009002F012O001231000A0030012O00065F000A00B40501000900041E3O00B405010012310005000B3O00041E3O00BB0501001231000900013O0006A5000800AB0501000900041E3O00AB0501001231000600014O00D6000700073O0012310008000B3O00041E3O00AB05010012310008000B3O0006F8000500C20501000800041E3O00C2050100123100080031012O00123100090032012O0006DC000900A30501000800041E3O00A30501001231000800013O0006F8000600C90501000800041E3O00C9050100123100080033012O00123100090034012O0006DC000800C20501000900041E3O00C20501001203000800794O00070108000100024O000900073O00122O000B0035015O00090009000B4O0009000200024O00070008000900122O00080036012O00122O00090036012O00062O000800DC0501000900041E3O00DC05012O00AE000800073O001269000A0037015O00080008000A4O000A002C6O0008000A000200062O000700DC0501000800041E3O00DC050100041E3O001B0601001231000800014O00D6000900093O001231000A0038012O001231000B0039012O00065F000A00DE0501000B00041E3O00DE0501001231000A00013O0006A5000800DE0501000A00041E3O00DE0501001231000900013O001231000A00013O0006A5000900E60501000A00041E3O00E60501001231000A00013O001231000B00013O0006F8000A00F10501000B00041E3O00F10501001231000B003A012O001231000C003B012O00065F000C00EA0501000B00041E3O00EA05012O00AE000B00274O0014010C00023O00122O000D003C012O00122O000E003D015O000C000E00024O000D00096O000E00023O00122O000F003E012O00122O0010003F015O000E001000024O000D000D000E4O000E00023O00122O000F0040012O00122O00100041015O000E001000024O000D000D000E4O000B000C000D4O000B00023O00122O000C0042012O00122O000D0043015O000B000D6O000B5O00044O00EA050100041E3O00E6050100041E3O001B060100041E3O00DE050100041E3O001B060100041E3O00C2050100041E3O001B060100041E3O00A3050100041E3O001B0601001231000800013O0006F8000400170601000800041E3O0017060100123100080044012O00123100090045012O00065F0009009B0501000800041E3O009B0501001231000500014O00D6000600063O0012310004000B3O00041E3O009B05010012310004005D3O00123100050046012O00065F0004007F0601000500041E3O007F06012O00AE000400073O00203A0004000400E64O000600093O00122O00070047015O0006000600074O00040006000200062O0004007F06013O00041E3O007F0601001231000400014O00D6000500063O0012310007000B3O0006A5000400740601000700041E3O00740601001231000700013O0006A50005002C0601000700041E3O002C0601001203000700794O000D0107000100024O000800073O00122O000A0035015O00080008000A4O0008000200024O0006000700084O000700073O00122O00090037015O0007000700094O0009002D6O00070009000200062O0006003E0601000700041E3O003E060100041E3O007F0601001231000700014O00D6000800083O001231000900013O0006F8000700470601000900041E3O0047060100123100090048012O001231000A0049012O00065F000900400601000A00041E3O00400601001231000800013O0012310009004A012O001231000A004A012O0006A5000900480601000A00041E3O00480601001231000900013O0006A5000800480601000900041E3O00480601001231000900013O001231000A007D3O001231000B007D3O0006A5000A00500601000B00041E3O00500601001231000A00013O0006A5000900500601000A00041E3O005006012O00AE000A00274O0014010B00023O00122O000C004B012O00122O000D004C015O000B000D00024O000C00096O000D00023O00122O000E004D012O00122O000F004E015O000D000F00024O000C000C000D4O000D00023O00122O000E004F012O00122O000F0050015O000D000F00024O000C000C000D4O000A000B000C4O000A00023O00122O000B0051012O00122O000C0052015O000A000C6O000A5O00044O0050060100041E3O0048060100041E3O007F060100041E3O0040060100041E3O007F060100041E3O002C060100041E3O007F060100123100070053012O00123100080054012O0006DC000800290601000700041E3O00290601001231000700013O0006A5000400290601000700041E3O00290601001231000500014O00D6000600063O0012310004000B3O00041E3O002906010012310003000B3O0012310004000B3O0006F8000300870601000400041E3O0087060100123100040055012O00123100050056012O0006DC0004008A0501000500041E3O008A05012O00AE000400073O00204A0004000400354O000600093O00122O00070057015O0006000600074O00040006000200122O000500203O00062O000400910601000500041E3O009106012O005900046O0009010400014O00100004002E3O00123100010058012O00041E3O0098060100041E3O008A050100041E3O0098060100041E3O0086050100123100020058012O0006F80001009F0601000200041E3O009F060100123100020059012O0012310003005A012O0006DC000300CA0601000200041E3O00CA0601001231000200013O0012310003000B3O0006A5000200B50601000300041E3O00B506010012310003005B012O0012310004005C012O0006DC000300B10601000400041E3O00B106012O00AE000300033O000638000300B106013O00041E3O00B106012O00AE000300223O0012710005005D015O00030003000500122O0005007B6O0003000500024O0003001C3O00044O00B306010012310003000B4O00100003001C3O00123100010016012O00041E3O00CA0601001231000300013O0006F8000300BC0601000200041E3O00BC06010012310003005E012O0012310004005F012O0006DC000400A00601000300041E3O00A006012O00AE000300073O0012EC00050060015O00030003000500122O000500466O0003000500024O000300286O000300223O00122O00050061015O00030003000500122O0005007B6O0003000500024O0003002F3O00122O0002000B3O00044O00A006010012310002001A012O0006A50001004F0701000200041E3O004F0701001231000200014O00D6000300033O00123100040062012O00123100050063012O0006DC000500CF0601000400041E3O00CF0601001231000400013O0006A5000200CF0601000400041E3O00CF0601001231000300013O0012310004000B3O0006A5000400110701000300041E3O001107012O00AE000400073O0020BC00040004007E2O00C70004000200020006C00004000F0701000100041E3O000F07012O00AE000400303O0006380004000F07013O00041E3O000F07012O00AE000400094O0067000500023O00122O00060064012O00122O00070065015O0005000700024O00040004000500202O0004000400414O00040002000200062O0004000F07013O00041E3O000F07012O00AE000400073O00121400060066015O0004000400064O000600093O00122O00070067015O0006000600074O000700016O00040007000200062O000400FF0601000100041E3O00FF06012O00AE0004000A3O00123100050068013O00800004000400052O00E9000500093O00122O00060067015O0005000500064O00040002000200062O0004000F07013O00041E3O000F070100123100040069012O0012310005006A012O00065F0004000F0701000500041E3O000F07012O00AE0004001A4O00E9000500093O00122O0006006B015O0005000500064O00040002000200062O0004000F07013O00041E3O000F07012O00AE000400023O0012310005006C012O0012310006006D013O006C000400064O009500045O0012310001006E012O00041E3O004F0701001231000400013O0006A5000300D70601000400041E3O00D706012O00AE000400253O0012170105000B6O0004000500044O000400316O0004000A3O00122O0005001D015O0004000400054O00040001000200062O0004002107013O00041E3O002107012O00AE000400013O0006C0000400260701000100041E3O002607012O00AE000400073O0020BC00040004007E2O00C70004000200020006380004004B07013O00041E3O004B0701001231000400014O00D6000500053O0012310006006F012O00123100070070012O00065F000600280701000700041E3O00280701001231000600013O0006A5000400280701000600041E3O00280701001231000500013O001231000600013O0006A5000500300701000600041E3O003007012O00AE000600073O00202D0006000600A44O000800093O00122O00090071015O0008000800094O0006000800024O000600326O000600323O00062O0006004507013O00041E3O004507012O00AE000600073O0020A30006000600354O000800093O00122O00090071015O0008000800094O00060008000200062O000600460701000100041E3O00460701001231000600014O0010000600333O00041E3O004B070100041E3O0030070100041E3O004B070100041E3O002807010012310003000B3O00041E3O00D7060100041E3O004F070100041E3O00CF06010012310002006E012O0006F8000100560701000200041E3O0056070100123100020072012O00123100030073012O00065F000300070001000200041E3O00070001001231000200013O00123100030074012O0012310004003B3O00065F000300A70701000400041E3O00A707010012310003000B3O0006A5000200A70701000300041E3O00A707012O00AE000300073O0020BC00030003007E2O00C70003000200020006C0000300A50701000100041E3O00A507012O00AE000300013O000638000300A507013O00041E3O00A507012O00AE000300073O0020BC0003000300E52O00C70003000200020006C0000300A50701000100041E3O00A50701001231000300014O00D6000400063O001231000700013O0006A5000300730701000700041E3O00730701001231000400014O00D6000500053O0012310003000B3O0012310007000B3O0006F80003007A0701000700041E3O007A070100123100070075012O00123100080076012O00065F0008006D0701000700041E3O006D07012O00D6000600063O001231000700013O0006A50004008B0701000700041E3O008B0701001231000700013O001231000800013O0006A5000700850701000800041E3O00850701001231000500014O00D6000600063O0012310007000B3O0012310008000B3O0006A50007007F0701000800041E3O007F07010012310004000B3O00041E3O008B070100041E3O007F070100123100070077012O00123100080078012O00065F0007007B0701000800041E3O007B07010012310007000B3O0006A50004007B0701000700041E3O007B0701001231000700013O0006A5000700920701000500041E3O009207012O00AE000700344O00280107000100022O0018000600073O0006C00006009E0701000100041E3O009E070100123100070079012O0012310008007A012O00065F000700A50701000800041E3O00A507012O00E3000600023O00041E3O00A5070100041E3O0092070100041E3O00A5070100041E3O007B070100041E3O00A5070100041E3O006D07010012310001007B3O00041E3O00070001001231000300013O0006F8000200AE0701000300041E3O00AE07010012310003007B012O0012310004007C012O00065F000300570701000400041E3O005707012O00AE000300053O000638000300C607013O00041E3O00C607012O00AE000300013O000638000300C607013O00041E3O00C607012O00AE000300073O0020BC00030003007E2O00C70003000200020006C0000300C60701000100041E3O00C60701001231000300014O00D6000400043O001231000500013O0006A5000300BB0701000500041E3O00BB07012O00AE000500174O00280105000100022O0018000400053O000638000400C607013O00041E3O00C607012O00E3000400023O00041E3O00C6070100041E3O00BB07012O00AE000300183O000638000300D107013O00041E3O00D107012O00AE000300013O0006C0000300D50701000100041E3O00D507012O00AE000300073O0020BC00030003007E2O00C70003000200020006C0000300D50701000100041E3O00D507010012310003007D012O0012310004007E012O0006DC000400FD0701000300041E3O00FD0701001203000300794O00D500030001000200122O000400786O0003000300044O000400193O00062O000400FD0701000300041E3O00FD07010012310003007F012O0012310004007F012O0006A5000300FD0701000400041E3O00FD07012O00AE000300094O0067000400023O00122O00050080012O00122O00060081015O0004000600024O00030003000400202O0003000300284O00030002000200062O000300FD07013O00041E3O00FD07012O00AE000300073O00127B00050066015O0003000300054O000500093O00202O0005000500CD4O00030005000200062O000300FD07013O00041E3O00FD07012O00AE0003001A4O00AE000400093O00202F0004000400CD2O00C7000300020002000638000300FD07013O00041E3O00FD07012O00AE000300023O00123100040082012O00123100050083013O006C000300054O009500035O0012310002000B3O00041E3O0057070100041E3O0007000100041E3O0002080100041E3O000200012O0027012O00017O00173O00028O00025O00BAA340025O0023B240025O001EAF40025O00F89140025O00C4AF40025O0097B04003123O006EBE0FC54480AF4BB510D06589A15FB11AC603073O00C32AD77CB521EC03183O002950242E20F40158353220C8025024312BDC085B223823EB03063O00986D39575E4503053O005072696E7403213O00DDD21CA2ADC655BCF0D804E39BC45BA3FCC54AA1A79271B8F0D44A81B1DD5983B703083O00C899B76AC3DEB234026O00F03F025O00989640025O00088140025O00408340025O00E06840030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03253O0016E69E3C5A4E33F78132471A17F587364C4872F5C86C191460ADD86F09782BA3AA3246571903063O003A5283E85D29003B3O0012313O00014O00D6000100013O000E470001000600013O00041E3O00060001002E06000300020001000200041E3O00020001001231000100013O000E470001000B0001000100041E3O000B0001002E060004002B0001000500041E3O002B0001001231000200013O002E06000600240001000700041E3O00240001000EAC000100240001000200041E3O002400012O00AE00036O0012010400013O00122O000500083O00122O000600096O0004000600024O00058O000600013O00122O0007000A3O00122O0008000B6O0006000800024O0005000500064O0003000400054O000300023O00202O00030003000C4O000400013O00122O0005000D3O00122O0006000E6O000400066O00033O000100122O0002000F3O000E47000F00280001000200041E3O00280001002E060010000C0001001100041E3O000C00010012310001000F3O00041E3O002B000100041E3O000C000100260D0001002F0001000F00041E3O002F0001002E1B011200DAFF2O001300041E3O00070001001203000200143O0020070002000200154O000300013O00122O000400163O00122O000500176O000300056O00023O000100044O003A000100041E3O0007000100041E3O003A000100041E3O000200012O0027012O00017O00", GetFEnv(), ...);

