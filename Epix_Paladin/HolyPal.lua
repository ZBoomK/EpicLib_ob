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
				if (Enum <= 132) then
					if (Enum <= 65) then
						if (Enum <= 32) then
							if (Enum <= 15) then
								if (Enum <= 7) then
									if (Enum <= 3) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
										elseif (Enum > 2) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum <= 5) then
										if (Enum > 4) then
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
									elseif (Enum == 6) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum == 8) then
											local A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
										else
											Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
										end
									elseif (Enum > 10) then
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
								elseif (Enum <= 13) then
									if (Enum == 12) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 14) then
									local B;
									local T;
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 23) then
								if (Enum <= 19) then
									if (Enum <= 17) then
										if (Enum == 16) then
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
									elseif (Enum == 18) then
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
								elseif (Enum <= 21) then
									if (Enum > 20) then
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
								elseif (Enum == 22) then
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
							elseif (Enum <= 27) then
								if (Enum <= 25) then
									if (Enum > 24) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
								elseif (Enum > 26) then
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
							elseif (Enum <= 29) then
								if (Enum == 28) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 30) then
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
							elseif (Enum == 31) then
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
						elseif (Enum <= 48) then
							if (Enum <= 40) then
								if (Enum <= 36) then
									if (Enum <= 34) then
										if (Enum == 33) then
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
									elseif (Enum > 35) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum <= 38) then
									if (Enum > 37) then
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
									elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 39) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 44) then
								if (Enum <= 42) then
									if (Enum > 41) then
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
									end
								elseif (Enum == 43) then
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
							elseif (Enum <= 46) then
								if (Enum == 45) then
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
							elseif (Enum == 47) then
								local A;
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 56) then
							if (Enum <= 52) then
								if (Enum <= 50) then
									if (Enum == 49) then
										Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum > 51) then
									do
										return Stk[Inst[2]];
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
							elseif (Enum <= 54) then
								if (Enum > 53) then
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
								elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 55) then
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
						elseif (Enum <= 60) then
							if (Enum <= 58) then
								if (Enum == 57) then
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
							elseif (Enum == 59) then
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
						elseif (Enum <= 62) then
							if (Enum == 61) then
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							end
						elseif (Enum <= 63) then
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
						elseif (Enum > 64) then
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
					elseif (Enum <= 98) then
						if (Enum <= 81) then
							if (Enum <= 73) then
								if (Enum <= 69) then
									if (Enum <= 67) then
										if (Enum == 66) then
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
									elseif (Enum == 68) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 71) then
									if (Enum == 70) then
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
								elseif (Enum == 72) then
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
							elseif (Enum <= 77) then
								if (Enum <= 75) then
									if (Enum > 74) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									elseif (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 76) then
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
							elseif (Enum <= 79) then
								if (Enum > 78) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum == 80) then
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
						elseif (Enum <= 89) then
							if (Enum <= 85) then
								if (Enum <= 83) then
									if (Enum == 82) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 84) then
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
							elseif (Enum <= 87) then
								if (Enum > 86) then
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
								elseif (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 88) then
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
						elseif (Enum <= 93) then
							if (Enum <= 91) then
								if (Enum == 90) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 92) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 95) then
							if (Enum == 94) then
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
						elseif (Enum <= 96) then
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
						elseif (Enum == 97) then
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
					elseif (Enum <= 115) then
						if (Enum <= 106) then
							if (Enum <= 102) then
								if (Enum <= 100) then
									if (Enum == 99) then
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
								elseif (Enum > 101) then
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
										if (Mvm[1] == 123) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								end
							elseif (Enum <= 104) then
								if (Enum == 103) then
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
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum == 105) then
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
						elseif (Enum <= 110) then
							if (Enum <= 108) then
								if (Enum == 107) then
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
							elseif (Enum > 109) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 112) then
							if (Enum == 111) then
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
						elseif (Enum <= 113) then
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
						elseif (Enum > 114) then
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
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 123) then
						if (Enum <= 119) then
							if (Enum <= 117) then
								if (Enum > 116) then
									if (Inst[2] == Stk[Inst[4]]) then
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
							elseif (Enum == 118) then
								local A = Inst[2];
								do
									return Unpack(Stk, A, A + Inst[3]);
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
						elseif (Enum == 122) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 127) then
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
								Stk[Inst[2]]();
							end
						elseif (Enum == 126) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
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
					elseif (Enum <= 129) then
						if (Enum == 128) then
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
					elseif (Enum <= 130) then
						if (Inst[2] < Stk[Inst[4]]) then
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
					elseif (Stk[Inst[2]] <= Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 198) then
					if (Enum <= 165) then
						if (Enum <= 148) then
							if (Enum <= 140) then
								if (Enum <= 136) then
									if (Enum <= 134) then
										if (Enum == 133) then
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
									elseif (Enum > 135) then
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
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									end
								elseif (Enum <= 138) then
									if (Enum > 137) then
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
								elseif (Enum > 139) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 144) then
								if (Enum <= 142) then
									if (Enum > 141) then
										local A = Inst[2];
										local B = Stk[Inst[3]];
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
								elseif (Enum == 143) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 146) then
								if (Enum > 145) then
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
							elseif (Enum == 147) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 156) then
							if (Enum <= 152) then
								if (Enum <= 150) then
									if (Enum > 149) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 151) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 154) then
								if (Enum > 153) then
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
							elseif (Enum > 155) then
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
						elseif (Enum <= 160) then
							if (Enum <= 158) then
								if (Enum == 157) then
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
									Stk[Inst[2]] = Inst[3];
								else
									Stk[Inst[2]] = Upvalues[Inst[3]];
								end
							elseif (Enum == 159) then
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 162) then
							if (Enum > 161) then
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
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							end
						elseif (Enum <= 163) then
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
						elseif (Enum == 164) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 181) then
						if (Enum <= 173) then
							if (Enum <= 169) then
								if (Enum <= 167) then
									if (Enum == 166) then
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
								elseif (Enum > 168) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								if (Enum > 170) then
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
							elseif (Enum > 172) then
								local A = Inst[2];
								local B = Inst[3];
								for Idx = A, B do
									Stk[Idx] = Vararg[Idx - A];
								end
							else
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 177) then
							if (Enum <= 175) then
								if (Enum == 174) then
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
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum == 176) then
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
						elseif (Enum <= 179) then
							if (Enum == 178) then
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
						elseif (Enum > 180) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 189) then
						if (Enum <= 185) then
							if (Enum <= 183) then
								if (Enum > 182) then
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 184) then
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							else
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 187) then
							if (Enum == 186) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum > 188) then
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
							local A = Inst[2];
							local Results = {Stk[A](Stk[A + 1])};
							local Edx = 0;
							for Idx = A, Inst[4] do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum <= 193) then
						if (Enum <= 191) then
							if (Enum > 190) then
								Env[Inst[3]] = Stk[Inst[2]];
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
						elseif (Enum == 192) then
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
						elseif (Inst[2] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 195) then
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
					elseif (Enum <= 196) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 197) then
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
				elseif (Enum <= 231) then
					if (Enum <= 214) then
						if (Enum <= 206) then
							if (Enum <= 202) then
								if (Enum <= 200) then
									if (Enum == 199) then
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
								elseif (Enum == 201) then
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 204) then
								if (Enum == 203) then
									do
										return;
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
							elseif (Enum > 205) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 210) then
							if (Enum <= 208) then
								if (Enum == 207) then
									Stk[Inst[2]] = {};
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
									A = Inst[2];
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
								end
							elseif (Enum > 209) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 212) then
							if (Enum == 211) then
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
						elseif (Enum == 213) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 222) then
						if (Enum <= 218) then
							if (Enum <= 216) then
								if (Enum == 215) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 217) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 220) then
							if (Enum > 219) then
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum > 221) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 226) then
						if (Enum <= 224) then
							if (Enum > 223) then
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
						elseif (Enum == 225) then
							local A = Inst[2];
							do
								return Unpack(Stk, A, Top);
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
					elseif (Enum <= 228) then
						if (Enum == 227) then
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
					elseif (Enum <= 229) then
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
					elseif (Enum > 230) then
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
					end
				elseif (Enum <= 248) then
					if (Enum <= 239) then
						if (Enum <= 235) then
							if (Enum <= 233) then
								if (Enum > 232) then
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
							elseif (Enum == 234) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 237) then
							if (Enum > 236) then
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
						elseif (Enum == 238) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
					elseif (Enum <= 243) then
						if (Enum <= 241) then
							if (Enum > 240) then
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
						elseif (Enum == 242) then
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						elseif (Inst[2] <= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 245) then
						if (Enum == 244) then
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
						else
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						end
					elseif (Enum <= 246) then
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
					elseif (Enum > 247) then
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
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 256) then
					if (Enum <= 252) then
						if (Enum <= 250) then
							if (Enum > 249) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 251) then
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						end
					elseif (Enum <= 254) then
						if (Enum > 253) then
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
					elseif (Enum > 255) then
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
						Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
					end
				elseif (Enum <= 260) then
					if (Enum <= 258) then
						if (Enum > 257) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 259) then
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
				elseif (Enum <= 262) then
					if (Enum > 261) then
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
				elseif (Enum <= 263) then
					local A = Inst[2];
					Stk[A](Unpack(Stk, A + 1, Top));
				elseif (Enum > 264) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!273O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503053O005574696C7303043O00556E697403053O00466F63757303063O00506C6179657203093O004D6F7573654F76657203063O005461726765742O033O0050657403053O005370652O6C03043O004974656D03043O004361737403053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03043O006D61746803053O00666C2O6F7203063O00666F726D6174030C3O00476574546F74656D496E666F03073O0047657454696D6503073O0050616C6164696E03043O00486F6C7903063O0053657441504C025O004050400091012O00120C3O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004B43O000A000100120B000300063O00208F00040003000700120B000500083O00208F00050005000900120B000600083O00208F00060006000A00066500073O000100062O007B3O00064O007B8O007B3O00044O007B3O00014O007B3O00024O007B3O00054O00E60008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000B001000202O000F000E001100202O0010000E001200202O0011000E001300208F0012000E001400203B0013000E001500202O0014000B001600202O0015000B001700122O0016000D3O00202O00170016001800202O00180016001900202O00190016001A00202O001A0016001B00202O001A001A001C00202O001A001A001D00208F001B0016001B002058001B001B001C00202O001B001B001E00122O001C001F3O00202O001C001C002000122O001D00013O00202O001D001D002100122O001E00223O00122O001F00233O00202O00200014002400202O00200020002500208F0021001500240020FC00210021002500202O00220018002400202O0022002200254O002300776O00788O00798O007A8O007B8O007C8O007D6O00CA007E007F3O00208F00800016001B00208F00800080001C00066500810001000100012O007B3O00203O00066500820002000100042O007B3O001E4O007B3O00204O007B3O001C4O007B3O001F3O00066500830003000100022O007B3O00204O007B3O003E3O00066500840004000100072O007B3O00194O007B3O00224O007B3O00074O007B3O00204O007B3O00104O007B3O000F4O007B3O00803O00066500850005000100032O007B3O00804O007B3O007D4O007B3O00793O00066500860006000100032O007B3O00104O007B3O00804O007B3O00203O00066500870007000100062O007B3O000F4O007B3O00804O007B3O00204O007B3O00194O007B3O00224O007B3O00073O00066500880008000100042O007B3O00204O007B3O00124O007B3O00194O007B3O00073O00066500890009000100112O007B3O00244O007B3O00104O007B3O00264O007B3O00254O007B3O00074O007B3O00214O007B3O00194O007B3O00224O007B3O00404O007B3O003F4O007B3O00204O007B3O00444O007B3O00434O007B3O00574O007B3O00564O007B3O00374O007B3O00383O000665008A000A0001000A2O007B3O00394O007B3O00794O007B3O00204O007B3O00104O007B3O00194O007B3O00074O007B3O00844O007B3O00804O007B3O007D4O007B3O003A3O000665008B000B000100172O007B3O00204O007B3O00194O007B3O00124O007B3O00074O007B3O00224O007B3O00114O007B3O00104O007B3O00824O007B3O00624O007B3O00804O007B3O005C4O007B3O005D4O007B3O00574O007B3O003B4O007B3O00834O007B3O003C4O007B3O003D4O007B3O007C4O007B3O007E4O007B3O007F4O007B3O00794O007B3O008A4O007B3O00463O000665008C000C000100262O007B3O00204O007B3O00104O007B3O00804O007B3O00484O007B3O00494O007B3O00474O007B3O00194O007B3O00074O007B3O006E4O007B3O006F4O007B3O00704O007B3O00594O007B3O005A4O007B3O00584O007B3O00224O007B3O006D4O007B3O006B4O007B3O006C4O007B3O006A4O007B3O00694O007B3O000F4O007B3O00404O007B3O003F4O007B3O00674O007B3O00684O007B3O004B4O007B3O004C4O007B3O004A4O007B3O00724O007B3O00734O007B3O00714O007B3O005F4O007B3O00604O007B3O005E4O007B3O00504O007B3O004F4O007B3O004E4O007B3O004D3O000665008D000D000100132O007B3O00204O007B3O00104O007B3O000F4O007B3O00574O007B3O00564O007B3O00194O007B3O00224O007B3O00074O007B3O00804O007B3O005C4O007B3O005D4O007B3O00594O007B3O005A4O007B3O00584O007B3O00654O007B3O00664O007B3O00124O007B3O00114O007B3O00823O000665008E000E000100172O007B3O00204O007B3O00104O007B3O000F4O007B3O00574O007B3O00564O007B3O00194O007B3O00224O007B3O00074O007B3O00504O007B3O004F4O007B3O00554O007B3O00544O007B3O00524O007B3O00514O007B3O00804O007B3O00654O007B3O00664O007B3O00644O007B3O00124O007B3O00114O007B3O00534O007B3O00634O007B3O00613O000665008F000F000100032O007B3O000F4O007B3O008D4O007B3O008E3O00066500900010000100152O007B3O00764O007B3O00074O007B3O00204O007B3O00804O007B3O00194O007B3O00224O007B3O00774O007B3O00894O007B3O002E4O007B3O002F4O007B3O00104O007B3O00864O007B3O008F4O007B3O008B4O007B3O008A4O007B3O008C4O007B3O000F4O007B3O00144O007B3O002B4O007B3O00874O007B3O002D3O00066500910011000100102O007B3O00804O007B3O00204O007B3O00224O007B3O002B4O007B3O00874O007B3O002D4O007B3O002E4O007B3O002F4O007B3O00104O007B3O00194O007B3O00074O007B3O00784O007B3O008F4O007B3O00764O007B3O00774O007B3O00883O000665009200120001002B2O007B3O00374O007B3O00074O007B3O00384O007B3O00394O007B3O003A4O007B3O003F4O007B3O00404O007B3O00414O007B3O00424O007B3O002B4O007B3O002C4O007B3O002D4O007B3O002E4O007B3O004B4O007B3O004C4O007B3O004D4O007B3O004E4O007B3O002F4O007B3O00304O007B3O00314O007B3O00324O007B3O00474O007B3O00484O007B3O00494O007B3O004A4O007B3O00434O007B3O00444O007B3O00564O007B3O00464O007B3O00274O007B3O00284O007B3O00294O007B3O002A4O007B3O004F4O007B3O00504O007B3O003B4O007B3O003C4O007B3O003D4O007B3O003E4O007B3O00234O007B3O00244O007B3O00254O007B3O00263O00066500930013000100282O007B3O00564O007B3O00074O007B3O00574O007B3O00584O007B3O00594O007B3O005A4O007B3O006F4O007B3O00704O007B3O00714O007B3O00724O007B3O00734O007B3O00514O007B3O00524O007B3O00534O007B3O00544O007B3O00554O007B3O005B4O007B3O005C4O007B3O005D4O007B3O005E4O007B3O005F4O007B3O00744O007B3O00754O007B3O00764O007B3O00774O007B3O006A4O007B3O006B4O007B3O006C4O007B3O006D4O007B3O006E4O007B3O00654O007B3O00664O007B3O00674O007B3O00684O007B3O00694O007B3O00604O007B3O00614O007B3O00624O007B3O00634O007B3O00643O00066500940014000100132O007B3O00794O007B3O00074O007B3O007A4O007B3O007B4O007B3O007F4O007B3O007E4O007B3O00104O007B3O00784O007B3O00904O007B3O00914O007B3O007C4O007B3O00124O007B3O00804O007B3O00204O007B3O00194O007B3O002B4O007B3O00224O007B3O00924O007B3O00933O00066500950015000100042O007B3O00804O007B3O000D4O007B3O00074O007B3O00163O00203900960016002600122O009700276O009800946O009900956O0096009900016O00013O00163O00023O00026O00F03F026O00704002264O000501025O00122O000300016O00045O00122O000500013O00042O0003002100012O009E00076O0003000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004D90003000500012O009E000300054O007B000400024O00AC000300044O00E100036O00CB3O00017O00023O0003113O00446562752O665265667265736861626C65030E3O004A7564676D656E74446562752O6601063O00201800013O00014O00035O00202O0003000300024O000100036O00019O0000017O00063O00028O00026O00F03F026O001040030C3O00436F6E736563726174696F6E03043O004E616D65026O00E03F002A3O0012213O00013O0026563O0001000100010004B43O00010001001221000100023O001221000200033O001221000300023O000433000100260001001221000500014O00CA000600093O00265600050009000100010004B43O000900012O009E000A6O0007000B00046O000A0002000D4O0009000D6O0008000C6O0007000B6O0006000A6O000A00013O00202O000A000A000400202O000A000A00054O000A0002000200062O000700250001000A0004B43O002500012O009E000A00024O002F000B000800094O000C00036O000C000100024O000B000B000C00202O000B000B00064O000A0002000200062O000A0022000100010004B43O00220001001221000A00014O0034000A00023O0004B43O002500010004B43O000900010004D9000100070001001221000100014O0034000100023O0004B43O000100012O00CB3O00017O00023O0003113O00446562752O665265667265736861626C6503123O00476C692O6D65726F664C6967687442752O66010A3O00203C00013O00014O00035O00202O0003000300024O00010003000200062O00010008000100010004B43O000800012O009E000100014O00B8000100014O0034000100024O00CB3O00017O00143O00028O00026O00F03F03053O007061697273030A3O0049734361737461626C6503163O00426C652O73696E676F6653752O6D6572506C6179657203173O00F9A3E4B9DB2DF5A8DEA5CE1BEFA7E495DB21FABCEEA4DB03063O00449BCF81CAA803103O00426C652O73696E676F6653752O6D657203093O004973496E506172747903083O004973496E5261696403063O00457869737473030D3O00556E697447726F7570526F6C6503073O00E182FAF0C1EEF703063O00ABA5C3B7B18603153O00426C652O73696E676F6653752O6D6572466F63757303123O0035D4DB074B3ED6D92B5731E7CD01553ADDCC03053O003857B8BE7403103O00426C652O73696E676F66537072696E6703103O00426C652O73696E676F66417574756D6E03103O00426C652O73696E676F6657696E74657200573O0012213O00014O00CA000100013O0026563O001A000100020004B43O001A000100120B000200034O007B000300014O00BC0002000200040004B43O0017000100208E0007000600042O00080007000200020006FB0007001700013O0004B43O001700012O009E00076O009E000800013O00208F0008000800052O00080007000200020006FB0007001700013O0004B43O001700012O009E000700023O001221000800063O001221000900074O00AC000700094O00E100075O00066C00020008000100020004B43O000800010004B43O005600010026563O0002000100010004B43O000200012O009E000200033O00208F00020002000800208E0002000200042O00080002000200020006FB0002004900013O0004B43O004900012O009E000200043O00208E0002000200092O00080002000200020006FB0002004900013O0004B43O004900012O009E000200043O00208E00020002000A2O000800020002000200065000020049000100010004B43O004900012O009E000200053O0006FB0002004900013O0004B43O004900012O009E000200053O00208E00020002000B2O00080002000200020006FB0002004900013O0004B43O004900012O009E000200063O00202700020002000C4O000300056O0002000200024O000300023O00122O0004000D3O00122O0005000E6O00030005000200062O00020049000100030004B43O004900012O009E00026O009E000300013O00208F00030003000F2O00080002000200020006FB0002004900013O0004B43O004900012O009E000200023O001221000300103O001221000400114O00AC000200044O00E100026O00CF000200044O000E000300033O00202O0003000300124O000400033O00202O0004000400084O000500033O00202O0005000500134O000600033O00202O0006000600144O0002000400012O007B000100023O0012213O00023O0004B43O000200012O00CB3O00017O00063O00028O00030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574026O004440026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B657400233O0012213O00013O0026563O0011000100010004B43O001100012O009E00015O0020DC0001000100034O000200016O000300023O00122O000400046O000500056O00010005000200122O000100023O00122O000100023O00062O0001001000013O0004B43O0010000100120B000100024O0034000100023O0012213O00053O0026563O0001000100050004B43O000100012O009E00015O0020DC0001000100064O000200016O000300023O00122O000400046O000500056O00010005000200122O000100023O00122O000100023O00062O0001002200013O0004B43O0022000100120B000100024O0034000100023O0004B43O002200010004B43O000100012O00CB3O00017O000A3O0003093O00497343617374696E67030C3O0049734368612O6E656C696E67028O0003093O00496E74652O7275707403063O00526562756B65026O001440026O00F03F03113O00496E74652O72757074576974685374756E030F3O0048612O6D65726F664A757374696365026O00204000294O009E7O00208E5O00012O00083O000200020006503O0028000100010004B43O002800012O009E7O00208E5O00022O00083O000200020006503O0028000100010004B43O002800010012213O00034O00CA000100013O0026563O001A000100030004B43O001A00012O009E000200013O0020900002000200044O000300023O00202O00030003000500122O000400066O000500016O0002000500024O000100023O00062O0001001900013O0004B43O001900012O0034000100023O0012213O00073O0026563O000C000100070004B43O000C00012O009E000200013O0020EC0002000200084O000300023O00202O00030003000900122O0004000A6O0002000400024O000100023O00062O0001002800013O0004B43O002800012O0034000100023O0004B43O002800010004B43O000C00012O00CB3O00017O000A3O00028O0003063O0045786973747303093O004973496E52616E6765026O00444003173O0044697370652O6C61626C65467269656E646C79556E697403073O00436C65616E736503073O0049735265616479030C3O00436C65616E7365466F637573030E3O003F3D0CBA17F824752O381AAB1CE703083O00555C5169DB798B41002B3O0012213O00013O000E750001000100013O0004B43O000100012O009E00015O0006FB0001001600013O0004B43O001600012O009E00015O00208E0001000100022O00080001000200020006FB0001001600013O0004B43O001600012O009E00015O00208E000100010003001221000300044O004F0001000300020006FB0001001600013O0004B43O001600012O009E000100013O00208F0001000100052O008A00010001000200065000010017000100010004B43O001700012O00CB3O00014O009E000100023O00208F00010001000600208E0001000100072O00080001000200020006FB0001002A00013O0004B43O002A00012O009E000100034O009E000200043O00208F0002000200082O00080001000200020006FB0001002A00013O0004B43O002A00012O009E000100053O001211000200093O00122O0003000A6O000100036O00015O00044O002A00010004B43O000100012O00CB3O00017O000C3O00028O00030C3O00436F6E736563726174696F6E030A3O0049734361737461626C65030E3O004973496E4D656C2O6552616E6765026O00144003163O00FEBC5E5679DCEFB244403CCFEFB6534A71DDFCA7101103063O00BF9DD330251C03083O004A7564676D656E7403073O0049735265616479030E3O0049735370652O6C496E52616E676503143O00D50AF01B37DA11E05C2ACD1AF71337DD1EE05C6C03053O005ABF7F947C00343O0012213O00013O0026563O0001000100010004B43O000100012O009E00015O00208F00010001000200208E0001000100032O00080001000200020006FB0001001A00013O0004B43O001A00012O009E000100013O00208E000100010004001221000300054O004F0001000300020006FB0001001A00013O0004B43O001A00012O009E000100024O009E00025O00208F0002000200022O00080001000200020006FB0001001A00013O0004B43O001A00012O009E000100033O001221000200063O001221000300074O00AC000100034O00E100016O009E00015O00208F00010001000800208E0001000100092O00080001000200020006FB0001003300013O0004B43O003300012O009E000100024O00B300025O00202O0002000200084O000300013O00202O00030003000A4O00055O00202O0005000500084O0003000500024O000300036O00010003000200062O0001003300013O0004B43O003300012O009E000100033O0012110002000B3O00122O0003000C6O000100036O00015O00044O003300010004B43O000100012O00CB3O00017O001C3O00028O00027O004003103O004865616C746850657263656E7461676503193O004A8228057D94261E76806E3F7D86221E76806E27779327187603043O007718E74E03173O0052656672657368696E674865616C696E67506F74696F6E03073O004973526561647903253O009028A358D953198B23A20AD445108E24AB4D9C501E9624AA449C44148428AB59D55614C27903073O0071E24DC52ABC20030A3O004C61796F6E48616E6473030A3O0049734361737461626C6503103O004C61796F6E48616E6473506C6179657203163O003617ED8A3518CBBD3B18F0A67A12F1B33F18E7BC2C1303043O00D55A769403103O00446976696E6550726F74656374696F6E03113O005F27A25F435E6EA444424F2BB74244542003053O002D3B4ED436026O00F03F030B3O00576F72646F66476C6F727903093O00486F6C79506F776572026O000840030F3O004865616C696E674162736F7262656403113O00576F72646F66476C6F7279506C6179657203083O002779A4CB952BA1F603083O00907036E3EBE64ECD030B3O004865616C746873746F6E6503173O00BB2D0EF0C453A03C00F2D51BB72D09F9DE48BA3E0ABC8303063O003BD3486F9CB000A33O0012213O00013O0026563O0027000100020004B43O002700012O009E00015O0006FB000100A200013O0004B43O00A200012O009E000100013O00208E0001000100032O00080001000200022O009E000200023O0006FE000100A2000100020004B43O00A200012O009E000100034O00A9000200043O00122O000300043O00122O000400056O00020004000200062O000100A2000100020004B43O00A200012O009E000100053O00208F00010001000600208E0001000100072O00080001000200020006FB000100A200013O0004B43O00A200012O009E000100064O0016000200073O00202O0002000200064O000300046O000500016O00010005000200062O000100A200013O0004B43O00A200012O009E000100043O001211000200083O00122O000300096O000100036O00015O00044O00A20001000E750001005E00013O0004B43O005E00012O009E000100013O00208E0001000100032O00080001000200022O009E000200083O0006FE00010043000100020004B43O004300012O009E000100093O0006FB0001004300013O0004B43O004300012O009E0001000A3O00208F00010001000A00208E00010001000B2O00080001000200020006FB0001004300013O0004B43O004300012O009E000100064O009E000200073O00208F00020002000C2O00080001000200020006FB0001004300013O0004B43O004300012O009E000100043O0012210002000D3O0012210003000E4O00AC000100034O00E100016O009E0001000A3O00208F00010001000F00208E00010001000B2O00080001000200020006FB0001005D00013O0004B43O005D00012O009E000100013O00208E0001000100032O00080001000200022O009E0002000B3O0006FE0001005D000100020004B43O005D00012O009E0001000C3O0006FB0001005D00013O0004B43O005D00012O009E000100064O009E0002000A3O00208F00020002000F2O00080001000200020006FB0001005D00013O0004B43O005D00012O009E000100043O001221000200103O001221000300114O00AC000100034O00E100015O0012213O00123O0026563O0001000100120004B43O000100012O009E0001000A3O00208F00010001001300208E0001000100072O00080001000200020006FB0001008400013O0004B43O008400012O009E000100013O00208E0001000100142O0008000100020002000EF300150084000100010004B43O008400012O009E000100013O00208E0001000100032O00080001000200022O009E0002000D3O0006FE00010084000100020004B43O008400012O009E0001000E3O0006FB0001008400013O0004B43O008400012O009E000100013O00208E0001000100162O000800010002000200065000010084000100010004B43O008400012O009E000100064O009E000200073O00208F0002000200172O00080001000200020006FB0001008400013O0004B43O008400012O009E000100043O001221000200183O001221000300194O00AC000100034O00E100016O009E000100053O00208F00010001001A00208E0001000100072O00080001000200020006FB000100A000013O0004B43O00A000012O009E0001000F3O0006FB000100A000013O0004B43O00A000012O009E000100013O00208E0001000100032O00080001000200022O009E000200103O0006FE000100A0000100020004B43O00A000012O009E000100064O0016000200073O00202O00020002001A4O000300046O000500016O00010005000200062O000100A000013O0004B43O00A000012O009E000100043O0012210002001B3O0012210003001C4O00AC000100034O00E100015O0012213O00023O0004B43O000100012O00CB3O00017O001D3O00028O00030D3O004176656E67696E67577261746803073O004973526561647903063O0042752O66557003113O004176656E67696E67577261746842752O66031A3O004F91E623498EED2A7190F12C5A8FA32E4188EF294190ED3E0ED303043O004D2EE783026O00F03F027O0040030B3O00486F6C794176656E676572030A3O0049734361737461626C6503193O00B25BBA598555A045B453B352FA57B94FB650B957B447F611EC03043O0020DA34D603103O0048616E646C65546F705472696E6B6574026O004440026O00084003133O0048616E646C65426F2O746F6D5472696E6B657403083O00536572617068696D03153O005D1223A9E1B84C570E143EA7FDB44A4D400471F9A903083O003A2E7751C891D025030A3O00446976696E65546F2O6C03173O002F8526A5A7B8093F833CA0E9BE39248034A3BEB3256BD403073O00564BEC50CCC9DD03093O00426C2O6F644675727903173O00704D788AFAB47454659CBE887D4E7B81F19C7C5237D4AC03063O00EB122117E59E030A3O004265727365726B696E6703173O0052BFD3A855A8CAB25EBD81B85FB5CDBF5FADCFA810EB9503043O00DB30DAA100AC3O0012213O00014O00CA000100013O000E750001002900013O0004B43O002900012O009E00025O0006FB0002002200013O0004B43O002200012O009E000200013O0006FB0002002200013O0004B43O002200012O009E000200023O00208F00020002000200208E0002000200032O00080002000200020006FB0002002200013O0004B43O002200012O009E000200033O00203C0002000200044O000400023O00202O0004000400054O00020004000200062O00020022000100010004B43O002200012O009E000200044O009E000300023O00208F0003000300022O00080002000200020006FB0002002200013O0004B43O002200012O009E000200053O001221000300063O001221000400074O00AC000200044O00E100026O009E000200064O008A0002000100022O007B000100023O0006FB0001002800013O0004B43O002800012O0034000100023O0012213O00083O000E750009004800013O0004B43O004800012O009E000200023O00208F00020002000A00208E00020002000B2O00080002000200020006FB0002003C00013O0004B43O003C00012O009E000200044O009E000300023O00208F00030003000A2O00080002000200020006FB0002003C00013O0004B43O003C00012O009E000200053O0012210003000C3O0012210004000D4O00AC000200044O00E100026O009E000200073O0020F400020002000E4O000300086O000400013O00122O0005000F6O000600066O0002000600024O000100023O00062O0001004700013O0004B43O004700012O0034000100023O0012213O00103O0026563O0067000100100004B43O006700012O009E000200073O0020F40002000200114O000300086O000400013O00122O0005000F6O000600066O0002000600024O000100023O00062O0001005500013O0004B43O005500012O0034000100024O009E000200023O00208F00020002001200208E0002000200032O00080002000200020006FB000200AB00013O0004B43O00AB00012O009E000200044O009E000300023O00208F0003000300122O00080002000200020006FB000200AB00013O0004B43O00AB00012O009E000200053O001211000300133O00122O000400146O000200046O00025O00044O00AB00010026563O0002000100080004B43O000200012O009E000200093O0006FB0002008700013O0004B43O008700012O009E000200013O0006FB0002008700013O0004B43O008700012O009E000200023O00208F00020002001500208E00020002000B2O00080002000200020006FB0002008700013O0004B43O008700012O009E000200033O0020C40002000200044O000400023O00202O0004000400054O00020004000200062O0002008700013O0004B43O008700012O009E000200044O009E000300023O00208F0003000300152O00080002000200020006FB0002008700013O0004B43O008700012O009E000200053O001221000300163O001221000400174O00AC000200044O00E100026O009E000200023O00208F00020002001800208E00020002000B2O00080002000200020006FB0002009800013O0004B43O009800012O009E000200044O009E000300023O00208F0003000300182O00080002000200020006FB0002009800013O0004B43O009800012O009E000200053O001221000300193O0012210004001A4O00AC000200044O00E100026O009E000200023O00208F00020002001B00208E00020002000B2O00080002000200020006FB000200A900013O0004B43O00A900012O009E000200044O009E000300023O00208F00030003001B2O00080002000200020006FB000200A900013O0004B43O00A900012O009E000200053O0012210003001C3O0012210004001D4O00AC000200044O00E100025O0012213O00093O0004B43O000200012O00CB3O00017O00683O00028O00027O0040030D3O0048612O6D65726F66577261746803073O0049735265616479030E3O0049735370652O6C496E52616E6765031B3O00EC707144DE5DDFEB77435EC94EF4EC316C5BD240F2ED2O65098A1B03073O008084111C29BB2F03083O004A7564676D656E7403143O000B27023D50043C127A4D133B092854152B466B0B03053O003D6152665A030C3O004C696768747348612O6D657203063O009C22AA52C24503083O0069CC4ECB2BA7377E030A3O0049734361737461626C6503123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O00A9A324160717F859A4A72E1B0144D743ACA53117071D870703083O0031C5CA437E7364A703063O00144ECD3A8F4403073O003E573BBF49E03603123O004C696768747348612O6D6572637572736F7203183O00EB0BFDC1F311C5C1E60FF7CCF542EADBEE0DE8C0F31BBA9F03043O00A987629A03123O00EE792159E473FDC5732146BD10DDD9642B4603073O00A8AB1744349D5303063O0045786973747303093O0043616E412O7461636B03183O00F878F2A5313EB8FC70F8A0203FC7E463FCA2372493ED31A303073O00E7941195CD454D030C3O00436F6E736563726174696F6E026O00144003183O0083A8C9E852FC92A6D3F258F1C0B7D5F258ED89B3DEBB05AF03063O009FE0C7A79B37026O000840026O00104003093O00486F6C79507269736D03163O00FFFC30CBC8E32EDBE4FE7CC2E5FA33C0FEE72592A5AB03043O00B297935C030D3O00417263616E65546F2O72656E74031A3O008DEF4F331C494598F25E2017426ECCED5E3B1D5E7398E40C614203073O001AEC9D2C52722C030B3O004C696768746F664461776E03093O00486F6C79506F77657203093O004177616B656E696E67030B3O004973417661696C61626C65031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403193O002627D2533E11DA5D152AD44C246EC5492321C7523E3795087803043O003B4A4EB5030E3O004372757361646572537472696B65031B3O0026C34F49B221D44865A031C35351B665C14853BC37D84E43F3768503053O00D345B12O3A03093O00486F6C7953686F636B030A3O00446562752O66446F776E03123O00476C692O6D65726F664C6967687442752O66030E3O00476C692O6D65726F664C6967687403113O00BFEA75ECD6D8BFEA7AFEA9CFB6E878F2EC03063O00ABD78519958903163O00456E656D69657357697468446562752O66436F756E74026O00444003093O00436173744379636C6503123O00486F6C7953686F636B4D6F7573656F76657203173O00E9C73EE3D023F44DE2C30DF9F633F047A1CC33F7EE37F903083O002281A8529A8F509C03073O0043686172676573031B3O0086A02618494A8C978D201F5A478280F223192O419B8CA62A4B2O1A03073O00E9E5D2536B282E030F3O00486F6C79507269736D506C61796572031E3O00C94D3ECF3AD1503BC508814D3C9616C44E349615D34B3DC40CD55B72845303053O0065A12252B6026O00F03F031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O00D80158E7DEF003083O004E886D399EBB82E203183O003236FEF92A2CC6F93F322OF42C7FE9E33730EBF82A26B9A703043O00915E5F9903063O00DED806C641A503063O00D79DAD74B52E03183O0039BD8CFACE268B83F3D738B199B2CA27BD84E0D321ADCBA403053O00BA55D4EB9203123O00E78F13F320AE6DCC8513EC79CD4DD09219EC03073O0038A2E1769E598E03183O00500CC7A736CB630DC1A22FDD4E45D0BD2BD74E0CD4B6628E03063O00B83C65A0CF4203173O00328D72AF34816EBD258B73B271926EB53E9075A828C22403043O00DC51E21C03063O0042752O665570030B3O00486F6C794176656E67657203193O001FDC85F3FEF81CD3BDFFEBD01D9592E9E3C801DC96E2AA964303063O00A773B5E29B8A03183O00536869656C646F667468655269676874656F7573486F6C7903233O00F12AEE597775F9ED24D8487374F9F02BE0546F74C9F731A74C6978C9F02BF3453B209403073O00A68242873C1B1103183O004745C066354758CF61394B448E65224D45DC7C245D0A9D2303053O0050242AAE1503113O004176656E67696E67577261746842752O6603223O005D183E7F42140875482F23724B2F25734918237F4105243A5E023E755C1923630E4203043O001A2E705703103O004865616C746850657263656E7461676503223O00AA2BA271B3BB7ABBBF1CBF7CBA8057BDBE2BBF71B0AA56F4A931A27BADB651ADF97103083O00D4D943CB142ODF25031A3O00B28CA5DFBF9F97DDBCB2BFC0BB99A092AA9FA1DDA884BCCBFAD903043O00B2DAEDC80016032O0012213O00013O0026563O00A6000100020004B43O00A600012O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB0001001A00013O0004B43O001A00012O009E000100014O00B300025O00202O0002000200034O000300023O00202O0003000300054O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001001A00013O0004B43O001A00012O009E000100033O001221000200063O001221000300074O00AC000100034O00E100016O009E00015O00208F00010001000800208E0001000100042O00080001000200020006FB0001003100013O0004B43O003100012O009E000100014O00B300025O00202O0002000200084O000300023O00202O0003000300054O00055O00202O0005000500084O0003000500024O000300036O00010003000200062O0001003100013O0004B43O003100012O009E000100033O001221000200093O0012210003000A4O00AC000100034O00E100015O00120B0001000B4O00A9000200033O00122O0003000C3O00122O0004000D6O00020004000200062O0001004F000100020004B43O004F00012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100014O00C8000200043O00202O00020002000F4O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001008B00013O0004B43O008B00012O009E000100033O001211000200123O00122O000300136O000100036O00015O00044O008B000100120B0001000B4O00A9000200033O00122O000300143O00122O000400156O00020004000200062O00010068000100020004B43O006800012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100014O009E000200043O00208F0002000200162O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100033O001211000200173O00122O000300186O000100036O00015O00044O008B000100120B0001000B4O00A9000200033O00122O000300193O00122O0004001A6O00020004000200062O0001008B000100020004B43O008B00012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100053O00208E00010001001B2O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100063O00208E00010001001C2O009E000300054O004F0001000300020006FB0001008B00013O0004B43O008B00012O009E000100014O009E000200043O00208F0002000200162O00080001000200020006FB0001008B00013O0004B43O008B00012O009E000100033O0012210002001D3O0012210003001E4O00AC000100034O00E100016O009E00015O00208F00010001001F00208E00010001000E2O00080001000200020006FB000100A500013O0004B43O00A500012O009E000100074O008A000100010002002684000100A5000100010004B43O00A500012O009E000100014O00C800025O00202O00020002001F4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O000100A500013O0004B43O00A500012O009E000100033O001221000200213O001221000300224O00AC000100034O00E100015O0012213O00233O0026563O00192O0100240004B43O00192O012O009E00015O00208F00010001002500208E0001000100042O00080001000200020006FB000100C200013O0004B43O00C200012O009E000100083O0006FB000100C200013O0004B43O00C200012O009E000100014O00B300025O00202O0002000200254O000300023O00202O0003000300054O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100C200013O0004B43O00C200012O009E000100033O001221000200263O001221000300274O00AC000100034O00E100016O009E00015O00208F00010001002800208E00010001000E2O00080001000200020006FB000100D300013O0004B43O00D300012O009E000100014O009E00025O00208F0002000200282O00080001000200020006FB000100D300013O0004B43O00D300012O009E000100033O001221000200293O0012210003002A4O00AC000100034O00E100016O009E00015O00208F00010001002B00208E0001000100042O00080001000200020006FB000100022O013O0004B43O00022O012O009E000100063O00208E00010001002C2O0008000100020002000EF3002300022O0100010004B43O00022O012O009E00015O00208F00010001002D00208E00010001002E2O00080001000200020006FB000100EB00013O0004B43O00EB00012O009E000100093O00201300010001002F4O0002000A6O0003000B6O00010003000200062O000100F1000100010004B43O00F100012O009E000100093O00208F0001000100302O009E0002000C4O0008000100020002000E82000200022O0100010004B43O00022O012O009E000100014O00B300025O00202O00020002002B4O000300023O00202O0003000300054O00055O00202O00050005002B4O0003000500024O000300036O00010003000200062O000100022O013O0004B43O00022O012O009E000100033O001221000200313O001221000300324O00AC000100034O00E100016O009E00015O00208F00010001003300208E0001000100042O00080001000200020006FB000100182O013O0004B43O00182O012O009E000100014O00C800025O00202O0002000200334O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O000100182O013O0004B43O00182O012O009E000100033O001221000200343O001221000300354O00AC000100034O00E100015O0012213O00203O0026563O00AA2O0100230004B43O00AA2O012O009E0001000D3O0006FB000100472O013O0004B43O00472O012O009E00015O00208F00010001003600208E0001000100042O00080001000200020006FB000100472O013O0004B43O00472O012O009E000100023O0020C40001000100374O00035O00202O0003000300384O00010003000200062O000100472O013O0004B43O00472O012O009E00015O00208F00010001003900208E00010001002E2O00080001000200020006FB000100362O013O0004B43O00362O012O009E0001000E4O009E000200024O00080001000200020006FB000100472O013O0004B43O00472O012O009E000100014O00B300025O00202O0002000200364O000300023O00202O0003000300054O00055O00202O0005000500364O0003000500024O000300036O00010003000200062O000100472O013O0004B43O00472O012O009E000100033O0012210002003A3O0012210003003B4O00AC000100034O00E100016O009E0001000D3O0006FB000100762O013O0004B43O00762O012O009E0001000F3O0006FB000100762O013O0004B43O00762O012O009E00015O00208F00010001003600208E0001000100042O00080001000200020006FB000100762O013O0004B43O00762O012O009E000100093O00204400010001003C4O00025O00202O00020002003800122O0003003D6O0001000300024O000200103O00062O000100762O0100020004B43O00762O012O009E000100113O0006FB000100762O013O0004B43O00762O012O009E000100093O00207300010001003E4O00025O00202O0002000200364O000300126O0004000E6O000500023O00202O0005000500054O00075O00202O0007000700364O0005000700024O000500056O000600076O000800043O00202O00080008003F4O00010008000200062O000100762O013O0004B43O00762O012O009E000100033O001221000200403O001221000300414O00AC000100034O00E100016O009E00015O00208F00010001003300208E0001000100042O00080001000200020006FB000100922O013O0004B43O00922O012O009E00015O00208F00010001003300208E0001000100422O0008000100020002002656000100922O0100020004B43O00922O012O009E000100014O00C800025O00202O0002000200334O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O000100922O013O0004B43O00922O012O009E000100033O001221000200433O001221000300444O00AC000100034O00E100016O009E00015O00208F00010001002500208E0001000100042O00080001000200020006FB000100A92O013O0004B43O00A92O012O009E000100133O000EF3000200A92O0100010004B43O00A92O012O009E000100083O0006FB000100A92O013O0004B43O00A92O012O009E000100014O009E000200043O00208F0002000200452O00080001000200020006FB000100A92O013O0004B43O00A92O012O009E000100033O001221000200463O001221000300474O00AC000100034O00E100015O0012213O00243O0026563O007B020100480004B43O007B020100120B000100494O00A9000200033O00122O0003004A3O00122O0004004B6O00020004000200062O000100CD2O0100020004B43O00CD2O012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001000902013O0004B43O000902012O009E000100133O000EF300020009020100010004B43O000902012O009E000100014O00C8000200043O00202O00020002000F4O000300023O00202O00030003001000122O000500116O0003000500024O000300036O00010003000200062O0001000902013O0004B43O000902012O009E000100033O0012110002004C3O00122O0003004D6O000100036O00015O00044O0009020100120B000100494O00A9000200033O00122O0003004E3O00122O0004004F6O00020004000200062O000100E62O0100020004B43O00E62O012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001000902013O0004B43O000902012O009E000100014O009E000200043O00208F0002000200162O00080001000200020006FB0001000902013O0004B43O000902012O009E000100033O001211000200503O00122O000300516O000100036O00015O00044O0009020100120B000100494O00A9000200033O00122O000300523O00122O000400536O00020004000200062O00010009020100020004B43O000902012O009E00015O00208F00010001000B00208E00010001000E2O00080001000200020006FB0001000902013O0004B43O000902012O009E000100053O00208E00010001001B2O00080001000200020006FB0001000902013O0004B43O000902012O009E000100063O00208E00010001001C2O009E000300054O004F0001000300020006FB0001000902013O0004B43O000902012O009E000100014O009E000200043O00208F0002000200162O00080001000200020006FB0001000902013O0004B43O000902012O009E000100033O001221000200543O001221000300554O00AC000100034O00E100016O009E00015O00208F00010001001F00208E00010001000E2O00080001000200020006FB0001002602013O0004B43O002602012O009E000100133O000EF300020026020100010004B43O002602012O009E000100074O008A00010001000200268400010026020100010004B43O002602012O009E000100014O00C800025O00202O00020002001F4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O0001002602013O0004B43O002602012O009E000100033O001221000200563O001221000300574O00AC000100034O00E100016O009E00015O00208F00010001002B00208E0001000100042O00080001000200020006FB0001006102013O0004B43O006102012O009E00015O00208F00010001002D00208E00010001002E2O00080001000200020006FB0001003902013O0004B43O003902012O009E000100093O00201300010001002F4O0002000A6O0003000B6O00010003000200062O00010050020100010004B43O005002012O009E000100093O00208F0001000100302O009E0002000C4O0008000100020002000E8200020061020100010004B43O006102012O009E000100063O00208E00010001002C2O0008000100020002000EC100200050020100010004B43O005002012O009E000100063O0020C40001000100584O00035O00202O0003000300594O00010003000200062O0001006102013O0004B43O006102012O009E000100063O00208E00010001002C2O0008000100020002000EF300230061020100010004B43O006102012O009E000100014O00B300025O00202O00020002002B4O000300023O00202O0003000300054O00055O00202O00050005002B4O0003000500024O000300036O00010003000200062O0001006102013O0004B43O006102012O009E000100033O0012210002005A3O0012210003005B4O00AC000100034O00E100016O009E00015O00208F00010001005C00208E0001000100042O00080001000200020006FB0001007A02013O0004B43O007A02012O009E000100133O000E820023007A020100010004B43O007A02012O009E000100014O00C800025O00202O00020002005C4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O0001007A02013O0004B43O007A02012O009E000100033O0012210002005D3O0012210003005E4O00AC000100034O00E100015O0012213O00023O0026563O0094020100200004B43O009402012O009E00015O00208F00010001001F00208E0001000100042O00080001000200020006FB0001001503013O0004B43O001503012O009E000100014O00C800025O00202O00020002001F4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O0001001503013O0004B43O001503012O009E000100033O0012110002005F3O00122O000300606O000100036O00015O00044O001503010026563O0001000100010004B43O000100012O009E000100143O0006FB000100A502013O0004B43O00A50201001221000100014O00CA000200023O0026560001009B020100010004B43O009B02012O009E000300154O008A0003000100022O007B000200033O0006FB000200A502013O0004B43O00A502012O0034000200023O0004B43O00A502010004B43O009B02012O009E00015O00208F00010001005C00208E0001000100042O00080001000200020006FB000100CF02013O0004B43O00CF02012O009E000100063O00203C0001000100584O00035O00202O0003000300614O00010003000200062O000100BF020100010004B43O00BF02012O009E000100063O00203C0001000100584O00035O00202O0003000300594O00010003000200062O000100BF020100010004B43O00BF02012O009E00015O00208F00010001002D00208E00010001002E2O0008000100020002000650000100CF020100010004B43O00CF02012O009E000100014O00C800025O00202O00020002005C4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O000100CF02013O0004B43O00CF02012O009E000100033O001221000200623O001221000300634O00AC000100034O00E100016O009E00015O00208F00010001005C00208E0001000100042O00080001000200020006FB000100F402013O0004B43O00F4020100120B0001002C3O000EF3002300F4020100010004B43O00F402012O009E000100093O00208F0001000100642O009E000200163O000625000200F4020100010004B43O00F402012O009E000100093O0020630001000100304O0002000A6O0001000200024O0002000B3O00062O000100F4020100020004B43O00F402012O009E000100014O00C800025O00202O00020002005C4O000300023O00202O00030003001000122O000500206O0003000500024O000300036O00010003000200062O000100F402013O0004B43O00F402012O009E000100033O001221000200653O001221000300664O00AC000100034O00E100016O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB0001001303013O0004B43O001303012O009E000100063O00208E00010001002C2O000800010002000200261500010013030100200004B43O001303012O009E000100133O00265600010013030100020004B43O001303012O009E000100014O00B300025O00202O0002000200034O000300023O00202O0003000300054O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001001303013O0004B43O001303012O009E000100033O001221000200673O001221000300684O00AC000100034O00E100015O0012213O00483O0004B43O000100012O00CB3O00017O00413O00028O00026O00F03F030D3O004176656E67696E675772617468030A3O0049734361737461626C6503063O0042752O66557003113O004176656E67696E67577261746842752O66031D3O00417265556E69747342656C6F774865616C746850657263656E74616765031F3O00B7A3E3DEB1BCE8D789A2F4D1A2BDA6D3B9BAEAD4B9A2E8EFBEB0E7DCBFBBE103043O00B0D6D586030F3O005479727344656C69766572616E636503213O00E0B4A4C797525CF8A4A0D1BA2O57F7A8F6D7A75955F0A2A1DA975E5CF5A1BFDAAF03073O003994CDD6B4C836030E3O00426561636F6E6F6656697274756503073O004973526561647903133O00426561636F6E6F66566972747565466F63757303213O0010F83437791CC23A324904F427206317BD363B791EF93A23782DF530357A1BF33203053O0016729D555403083O00446179627265616B031A3O00467269656E646C79556E6974735769746842752O66436F756E7403123O00476C692O6D65726F664C6967687442752O66030E3O004D616E6150657263656E7461676503193O00C0CA0AC64FF3A9CF8B10CB52FAACCBDC1DFB55F3A9C8C21DC303073O00C8A4AB73A43D96027O004003063O0045786973747303093O004973496E52616E6765026O004440030A3O004C61796F6E48616E647303103O004865616C746850657263656E74616765030F3O004C61796F6E48616E6473466F637573031D3O00B2F51A7A8CB0CB0B448DBAE743468CB1F8074A94B0CB0B4082B2FD0D4203053O00E3DE94632503083O001D5D46B6CD325C5903053O0099532O329603143O00426C652O73696E676F6650726F74656374696F6E030D3O00556E697447726F7570526F6C6503043O0069575D3703073O002D3D16137C13CB03193O00426C652O73696E676F6650726F74656374696F6E466F63757303273O00C31E08E61179B7C62D02F33D60ABCE0608F61679B6CF520EFA0D7CBDCE0503CA0A75B8CD1B03F203073O00D9A1726D95621003063O00222C3965B96603063O00147240581CDC031A3O00426C652O73696E676F6650726F74656374696F6E706C6179657203273O00330DD7A7EBD9B3363EDDB2C7C0AF3E15D7B7ECD9B23F41D1BBF7DCB93E16DC8BF0D5BC3D08DCB303073O00DD5161B2D498B0030B3O00417572614D617374657279031D3O00CCF20FFA25C0E60EEF1FDFFE5DF815C2EB19F40DC3D815FE1BC1EE13FC03053O007AAD877D9B030E3O0048616E646F66446976696E697479031C3O0080C816B03134F790CE0CB57F32C78BCD04B6283FF78CC401B5363FCF03073O00A8E4A160D95F51030A3O00446976696E65546F2O6C030F3O00446976696E65546F2O6C466F637573031C3O00DFD838552152E4C521502317D8DE21502B58CCDF11542A56D7D8205B03063O0037BBB14E3C4F03093O00486F6C7953686F636B030E3O00486F6C7953686F636B466F637573031B3O0025C153F279DC8822CD54AB45C08F21CA50FC48F08828CF53E248C803073O00E04DAE3F8B26AF03133O00426C652O73696E676F6653616372696669636503043O004755494403183O00426C652O73696E676F66536163726966696365466F63757303263O00864D5D3D97485629BB4E5E1197405B3C8D47512D81015B218B4D5C21934F6726814054278A4603043O004EE42138008D012O0012213O00013O0026563O0087000100020004B43O008700012O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB0001002500013O0004B43O002500012O009E000100013O00203C0001000100054O00035O00202O0003000300064O00010003000200062O00010025000100010004B43O002500012O009E000100023O00205B0001000100074O000200036O000300046O00010003000200062O0001002500013O0004B43O002500012O009E000100053O0006FB0001002500013O0004B43O002500012O009E000100064O009E00025O00208F0002000200032O00080001000200020006FB0001002500013O0004B43O002500012O009E000100073O001221000200083O001221000300094O00AC000100034O00E100016O009E00015O00208F00010001000A00208E0001000100042O00080001000200020006FB0001004000013O0004B43O004000012O009E000100083O0006FB0001004000013O0004B43O004000012O009E000100023O00205B0001000100074O000200096O0003000A6O00010003000200062O0001004000013O0004B43O004000012O009E000100064O009E00025O00208F00020002000A2O00080001000200020006FB0001004000013O0004B43O004000012O009E000100073O0012210002000B3O0012210003000C4O00AC000100034O00E100016O009E00015O00208F00010001000D00208E00010001000E2O00080001000200020006FB0001005B00013O0004B43O005B00012O009E000100023O00205B0001000100074O0002000B6O0003000C6O00010003000200062O0001005B00013O0004B43O005B00012O009E0001000D3O0006FB0001005B00013O0004B43O005B00012O009E000100064O009E0002000E3O00208F00020002000F2O00080001000200020006FB0001005B00013O0004B43O005B00012O009E000100073O001221000200103O001221000300114O00AC000100034O00E100016O009E00015O00208F00010001001200208E00010001000E2O00080001000200020006FB0001008600013O0004B43O008600012O009E000100023O0020C70001000100134O00025O00202O0002000200144O00038O00048O0001000400024O0002000F3O00062O00020086000100010004B43O008600012O009E000100023O0020130001000100074O000200106O000300116O00010003000200062O00010078000100010004B43O007800012O009E000100013O00208E0001000100152O00080001000200022O009E000200123O0006FE00010086000100020004B43O008600012O009E000100133O0006FB0001008600013O0004B43O008600012O009E000100064O009E00025O00208F0002000200122O00080001000200020006FB0001008600013O0004B43O008600012O009E000100073O001221000200163O001221000300174O00AC000100034O00E100015O0012213O00183O000E75000100162O013O0004B43O00162O012O009E000100143O0006FB0001009700013O0004B43O009700012O009E000100143O00208E0001000100192O00080001000200020006FB0001009700013O0004B43O009700012O009E000100143O00208E00010001001A0012210003001B4O004F00010003000200065000010098000100010004B43O009800012O00CB3O00014O009E00015O00208F00010001001C00208E0001000100042O00080001000200020006FB000100B200013O0004B43O00B200012O009E000100143O00208E00010001001D2O00080001000200022O009E000200153O0006FE000100B2000100020004B43O00B200012O009E000100163O0006FB000100B200013O0004B43O00B200012O009E000100064O009E0002000E3O00208F00020002001E2O00080001000200020006FB000100B200013O0004B43O00B200012O009E000100073O0012210002001F3O001221000300204O00AC000100034O00E100016O009E000100174O00A9000200073O00122O000300213O00122O000400226O00020004000200062O000100DC000100020004B43O00DC00012O009E00015O00208F00010001002300208E0001000100042O00080001000200020006FB000100FA00013O0004B43O00FA00012O009E000100143O00208E00010001001D2O00080001000200022O009E000200183O0006FE000100FA000100020004B43O00FA00012O009E000100023O0020B60001000100244O000200146O0001000200024O000100016O000200073O00122O000300253O00122O000400266O00020004000200062O000100FA000100020004B43O00FA00012O009E000100064O009E0002000E3O00208F0002000200272O00080001000200020006FB000100FA00013O0004B43O00FA00012O009E000100073O001211000200283O00122O000300296O000100036O00015O00044O00FA00012O009E000100174O00A9000200073O00122O0003002A3O00122O0004002B6O00020004000200062O000100FA000100020004B43O00FA00012O009E00015O00208F00010001002300208E0001000100042O00080001000200020006FB000100FA00013O0004B43O00FA00012O009E000100013O00208E00010001001D2O00080001000200022O009E000200183O0006FE000100FA000100020004B43O00FA00012O009E000100064O009E0002000E3O00208F00020002002C2O00080001000200020006FB000100FA00013O0004B43O00FA00012O009E000100073O0012210002002D3O0012210003002E4O00AC000100034O00E100016O009E00015O00208F00010001002F00208E0001000100042O00080001000200020006FB000100152O013O0004B43O00152O012O009E000100023O00205B0001000100074O000200196O0003001A6O00010003000200062O000100152O013O0004B43O00152O012O009E0001001B3O0006FB000100152O013O0004B43O00152O012O009E000100064O009E00025O00208F00020002002F2O00080001000200020006FB000100152O013O0004B43O00152O012O009E000100073O001221000200303O001221000300314O00AC000100034O00E100015O0012213O00023O000E750018000100013O0004B43O000100012O009E00015O00208F00010001003200208E00010001000E2O00080001000200020006FB000100332O013O0004B43O00332O012O009E000100023O00205B0001000100074O0002001C6O0003001D6O00010003000200062O000100332O013O0004B43O00332O012O009E0001001E3O0006FB000100332O013O0004B43O00332O012O009E000100064O009E00025O00208F0002000200322O00080001000200020006FB000100332O013O0004B43O00332O012O009E000100073O001221000200333O001221000300344O00AC000100034O00E100016O009E00015O00208F00010001003500208E00010001000E2O00080001000200020006FB0001004E2O013O0004B43O004E2O012O009E000100023O00205B0001000100074O0002001F6O000300206O00010003000200062O0001004E2O013O0004B43O004E2O012O009E000100213O0006FB0001004E2O013O0004B43O004E2O012O009E000100064O009E0002000E3O00208F0002000200362O00080001000200020006FB0001004E2O013O0004B43O004E2O012O009E000100073O001221000200373O001221000300384O00AC000100034O00E100016O009E00015O00208F00010001003900208E00010001000E2O00080001000200020006FB000100682O013O0004B43O00682O012O009E000100143O00208E00010001001D2O00080001000200022O009E000200223O0006FE000100682O0100020004B43O00682O012O009E000100233O0006FB000100682O013O0004B43O00682O012O009E000100064O009E0002000E3O00208F00020002003A2O00080001000200020006FB000100682O013O0004B43O00682O012O009E000100073O0012210002003B3O0012210003003C4O00AC000100034O00E100016O009E00015O00208F00010001003D00208E00010001000E2O00080001000200020006FB0001008C2O013O0004B43O008C2O012O009E000100143O0020D000010001003E4O0001000200024O000200013O00202O00020002003E4O00020002000200062O0001008C2O0100020004B43O008C2O012O009E000100143O00208E00010001001D2O00080001000200022O009E000200243O0006FE0001008C2O0100020004B43O008C2O012O009E000100253O0006FB0001008C2O013O0004B43O008C2O012O009E000100064O009E0002000E3O00208F00020002003F2O00080001000200020006FB0001008C2O013O0004B43O008C2O012O009E000100073O001211000200403O00122O000300416O000100036O00015O00044O008C2O010004B43O000100012O00CB3O00017O00453O00028O00026O00F03F030B3O00576F72646F66476C6F727903073O004973526561647903093O00486F6C79506F776572026O00084003063O0042752O66557003113O00556E656E64696E674C6967687442752O6603103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F63757303193O00D971A007BAC1788D0489C16CAB4384C17B8D0B80CF72BB0D8203053O00E5AE1ED263030B3O004C696768746F664461776E031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E74027O004003193O0017E48159F902361DD28250FA33791AE2836EE52O3817E4885603073O00597B8DE6318D5D030E3O00426561636F6E6F6656697274756503133O00426561636F6E6F66566972747565466F637573031C3O00F174F70F1F44CC7EF0330643E165E309504BFC74C904154BFF78F80B03063O002A9311966C7003123O00456D70797265616E4C656761637942752O6603193O0018A93F7BD8E709992A73E8FA16E62C70E2D707A32C73EEE60803063O00886FC64D1F87030D3O00557365576F644F66476C6F727903193O001506B55282EB11962O05A8442OA416A60736AF53BCE81EA70503083O00C96269C736DD847703103O004C696768746F667468654D617274797203133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D617274797203153O004C696768746F667468654D6172747972466F637573031B3O00B1038F383D26A4B60F8861013AA3B5088C360C0AA4BC0D8F280C3203073O00CCD96CE3416255030D3O00546172676574497356616C6964031D3O004C696768747348612O6D65724C696768747348612O6D6572557361676503063O006ECFF4FC29D203063O00A03EA395854C030C3O004C696768747348612O6D6572030A3O0049734361737461626C6503123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O00DAA90A27D7C59F052ECEDBA51F6FD3C4A9023DCAC2B94D7903053O00A3B6C06D4F03063O00173312D3FA2603053O0095544660A003123O004C696768747348612O6D6572637572736F7203183O00340F0AE52C1532E5390B00E82A461DFF31091FE42C1F4DBB03043O008D58666D03123O00965DCF7D037D60CFB756D830392847D2BC4103083O00A1D333AA107A5D3503063O0045786973747303093O0043616E412O7461636B03183O00F7A7B520EFBD8D20FAA3BF2DE9EEA23AF2A1A021EFB7F27E03043O00489BCED2030C3O00436F6E736563726174696F6E030A3O00476F6C64656E50617468030B3O004973417661696C61626C65026O00144003183O0045755A1D364568551A3A4974140F3C43455C0B324A735A0903053O0053261A346E03083O004A7564676D656E74030F3O004A7564676D656E746F664C69676874030A3O00446562752O66446F776E03153O004A7564676D656E746F664C69676874446562752O66030E3O0049735370652O6C496E52616E676503143O00520223415512295218162843671F2247541E294103043O00263877470091012O0012213O00013O0026563O004D000100020004B43O004D00012O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB0001002900013O0004B43O002900012O009E000100013O00208E0001000100052O0008000100020002000EF300060029000100010004B43O002900012O009E000100013O0020C40001000100074O00035O00202O0003000300084O00010003000200062O0001002900013O0004B43O002900012O009E000100023O00208E0001000100092O00080001000200022O009E000200033O0006FE00010029000100020004B43O002900012O009E000100043O0006FB0001002900013O0004B43O002900012O009E000100054O009E000200063O00208F00020002000A2O00080001000200020006FB0001002900013O0004B43O002900012O009E000100073O0012210002000B3O0012210003000C4O00AC000100034O00E100016O009E00015O00208F00010001000D00208E0001000100042O00080001000200020006FB0001004C00013O0004B43O004C00012O009E000100013O00208E0001000100052O0008000100020002000EF30006004C000100010004B43O004C00012O009E000100083O00201300010001000E4O000200096O0003000A6O00010003000200062O00010041000100010004B43O004100012O009E000100083O00208F00010001000F2O009E000200034O0008000100020002000E820010004C000100010004B43O004C00012O009E000100054O009E00025O00208F00020002000D2O00080001000200020006FB0001004C00013O0004B43O004C00012O009E000100073O001221000200113O001221000300124O00AC000100034O00E100015O0012213O00103O0026563O0098000100010004B43O009800012O009E00015O00208F00010001001300208E0001000100042O00080001000200020006FB0001006A00013O0004B43O006A00012O009E000100083O00205B00010001000E4O0002000B6O0003000C6O00010003000200062O0001006A00013O0004B43O006A00012O009E0001000D3O0006FB0001006A00013O0004B43O006A00012O009E000100054O009E000200063O00208F0002000200142O00080001000200020006FB0001006A00013O0004B43O006A00012O009E000100073O001221000200153O001221000300164O00AC000100034O00E100016O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB0001009700013O0004B43O009700012O009E000100013O00208E0001000100052O0008000100020002000EF300060097000100010004B43O009700012O009E000100013O0020C40001000100074O00035O00202O0003000300174O00010003000200062O0001009700013O0004B43O009700012O009E000100023O00208E0001000100092O00080001000200022O009E000200033O0006FE00010085000100020004B43O008500012O009E000100043O0006500001008C000100010004B43O008C00012O009E000100083O00205B00010001000E4O000200096O0003000A6O00010003000200062O0001009700013O0004B43O009700012O009E000100054O009E000200063O00208F00020002000A2O00080001000200020006FB0001009700013O0004B43O009700012O009E000100073O001221000200183O001221000300194O00AC000100034O00E100015O0012213O00023O0026563O00DA000100100004B43O00DA00012O009E00015O00208F00010001000300208E0001000100042O00080001000200020006FB000100BF00013O0004B43O00BF00012O009E000100013O00208E0001000100052O0008000100020002000EF3000600BF000100010004B43O00BF00012O009E000100023O00208E0001000100092O00080001000200022O009E000200033O0006FE000100BF000100020004B43O00BF000100120B0001001A3O0006FB000100BF00013O0004B43O00BF00012O009E000100083O00208F00010001000F2O009E000200034O0008000100020002002615000100BF000100060004B43O00BF00012O009E000100054O009E000200063O00208F00020002000A2O00080001000200020006FB000100BF00013O0004B43O00BF00012O009E000100073O0012210002001B3O0012210003001C4O00AC000100034O00E100016O009E00015O00208F00010001001D00208E0001000100042O00080001000200020006FB000100D900013O0004B43O00D900012O009E000100023O00208E0001000100092O000800010002000200120B0002001E3O0006FE000100D9000100020004B43O00D9000100120B0001001F3O0006FB000100D900013O0004B43O00D900012O009E000100054O009E000200063O00208F0002000200202O00080001000200020006FB000100D900013O0004B43O00D900012O009E000100073O001221000200213O001221000300224O00AC000100034O00E100015O0012213O00063O0026563O0001000100060004B43O000100012O009E000100083O00208F0001000100232O008A0001000100020006FB000100902O013O0004B43O00902O01001221000100013O002656000100462O0100020004B43O00462O012O009E000200083O00205B00020002000E4O0003000E6O0004000F6O00020004000200062O000200902O013O0004B43O00902O0100120B000200244O00A9000300073O00122O000400253O00122O000500266O00030005000200062O000200092O0100030004B43O00092O012O009E00025O00208F00020002002700208E0002000200282O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200054O00C8000300063O00202O0003000300294O000400103O00202O00040004002A00122O0006002B6O0004000600024O000400046O00020004000200062O000200902O013O0004B43O00902O012O009E000200073O0012110003002C3O00122O0004002D6O000200046O00025O00044O00902O0100120B000200244O00A9000300073O00122O0004002E3O00122O0005002F6O00030005000200062O000200222O0100030004B43O00222O012O009E00025O00208F00020002002700208E0002000200282O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200054O009E000300063O00208F0003000300302O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200073O001211000300313O00122O000400326O000200046O00025O00044O00902O0100120B000200244O00A9000300073O00122O000400333O00122O000500346O00030005000200062O000200902O0100030004B43O00902O012O009E00025O00208F00020002002700208E0002000200282O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200113O00208E0002000200352O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200013O00208E0002000200362O009E000400114O004F0002000400020006FB000200902O013O0004B43O00902O012O009E000200054O009E000300063O00208F0003000300302O00080002000200020006FB000200902O013O0004B43O00902O012O009E000200073O001211000300373O00122O000400386O000200046O00025O00044O00902O01002656000100E2000100010004B43O00E200012O009E00025O00208F00020002003900208E0002000200282O00080002000200020006FB000200682O013O0004B43O00682O012O009E00025O00208F00020002003A00208E00020002003B2O00080002000200020006FB000200682O013O0004B43O00682O012O009E000200124O008A000200010002002684000200682O0100010004B43O00682O012O009E000200054O00C800035O00202O0003000300394O000400103O00202O00040004002A00122O0006003C6O0004000600024O000400046O00020004000200062O000200682O013O0004B43O00682O012O009E000200073O0012210003003D3O0012210004003E4O00AC000200044O00E100026O009E00025O00208F00020002003F00208E0002000200042O00080002000200020006FB0002008C2O013O0004B43O008C2O012O009E00025O00208F00020002004000208E00020002003B2O00080002000200020006FB0002008C2O013O0004B43O008C2O012O009E000200103O0020C40002000200414O00045O00202O0004000400424O00020004000200062O0002008C2O013O0004B43O008C2O012O009E000200054O00B300035O00202O00030003003F4O000400103O00202O0004000400434O00065O00202O00060006003F4O0004000600024O000400046O00020004000200062O0002008C2O013O0004B43O008C2O012O009E000200073O001221000300443O001221000400454O00AC000200044O00E100025O001221000100023O0004B43O00E200010004B43O00902O010004B43O000100012O00CB3O00017O00433O00028O00030B3O00576F72646F66476C6F727903073O004973526561647903093O00486F6C79506F776572026O00084003103O004865616C746850657263656E7461676503103O00576F72646F66476C6F7279466F63757303183O00E4E04AD21A59F5D05FDA2A44EAAF4BC21A5EF6EE54DF2B5103063O0036938F38B64503093O00486F6C7953686F636B030E3O00486F6C7953686F636B466F63757303153O00DE8EF350E0C589F04AD49692EB76D7D380F3402OD103053O00BFB6E19F29026O00F03F030B3O00446976696E654661766F7203173O002F1B3E5C8582FD2D133E5A99C7D13F2D20508A8BCB251503073O00A24B724835EBE7030C3O00466C6173686F664C69676874030A3O0049734361737461626C6503113O00466C6173686F664C69676874466F63757303193O008A3045F15B3D833A7BEE5A05842804F1473D843945EE5A0C8B03063O0062EC5C248233027O0040026O00104003093O00486F6C794C69676874030E3O00486F6C794C69676874466F63757303153O00AC1600A37AA4BC37AC0D4CA95197BD35A51505B44203083O0050C4796CDA25C8D5031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503063O00307F03664E1C03073O00EA6013621F2B6E030C3O004C696768747348612O6D657203123O004C696768747348612O6D6572506C61796572030E3O004973496E4D656C2O6552616E6765026O00204003183O000A1655CFB861B40E1E5FCAA960CB160D5BC8BE7B9F1F5F0403073O00EB667F32A7CC1203063O0073B4E7304B3C03063O004E30C195432403123O004C696768747348612O6D6572637572736F7203183O003C17871055232188194C3D1B92585122178F0A482407C04E03053O0021507EE07803123O00C9A606C945AC9D0DC059FEE820D14EFFA71103053O003C8CC863A403063O0045786973747303093O0043616E412O7461636B03183O008BFD032EB694CB0C27AF8AF11666B295FD0B34AB93ED447003053O00C2E794644603063O0042752O66557003133O00496E667573696F6E6F664C6967687442752O6603193O002O40C0B0FEF7494AFEAFFFCF4E5881B0E2F74E49C0AFFFC64103063O00A8262CA1C39603093O00486F6C79507269736D030F3O00486F6C79507269736D506C61796572031E3O0088F38E6F0FF8A41F93F1C2793EA8A5138CFAC26622E1B90489E89B3662BE03083O0076E09CE2165088D603103O004C696768746F667468654D617274797203133O004C696768746F667468654D61727479726B485003133O005573654C696768746F667468654D617274797203153O004C696768746F667468654D6172747972466F637573031B3O004AE155997DFD518F41E519834DE155844DF957BF4AEB588C4BE05E03043O00E0228E39030E3O0042612O726965726F66466169746803103O0042612O726965726F664661697468485003113O0055736542612O726965726F664661697468031B3O00DCA6D7CF7AF44F31D1A1FADB72F849069EB4D1E27BF45C02D7A9C203083O006EBEC7A5BD13913D0071012O0012213O00013O000E750001003D00013O0004B43O003D00012O009E00015O00208F00010001000200208E0001000100032O00080001000200020006FB0001002200013O0004B43O002200012O009E000100013O00208E0001000100042O0008000100020002000EF300050022000100010004B43O002200012O009E000100023O00208E0001000100062O00080001000200022O009E000200033O0006FE00010022000100020004B43O002200012O009E000100043O0006FB0001002200013O0004B43O002200012O009E000100054O009E000200063O00208F0002000200072O00080001000200020006FB0001002200013O0004B43O002200012O009E000100073O001221000200083O001221000300094O00AC000100034O00E100016O009E00015O00208F00010001000A00208E0001000100032O00080001000200020006FB0001003C00013O0004B43O003C00012O009E000100023O00208E0001000100062O00080001000200022O009E000200083O0006FE0001003C000100020004B43O003C00012O009E000100093O0006FB0001003C00013O0004B43O003C00012O009E000100054O009E000200063O00208F00020002000B2O00080001000200020006FB0001003C00013O0004B43O003C00012O009E000100073O0012210002000C3O0012210003000D4O00AC000100034O00E100015O0012213O000E3O000E75000E007600013O0004B43O007600012O009E00015O00208F00010001000F00208E0001000100032O00080001000200020006FB0001005900013O0004B43O005900012O009E000100023O00208E0001000100062O00080001000200022O009E0002000A3O0006FE00010059000100020004B43O005900012O009E0001000B3O0006FB0001005900013O0004B43O005900012O009E000100054O009E00025O00208F00020002000F2O00080001000200020006FB0001005900013O0004B43O005900012O009E000100073O001221000200103O001221000300114O00AC000100034O00E100016O009E00015O00208F00010001001200208E0001000100132O00080001000200020006FB0001007500013O0004B43O007500012O009E000100023O00208E0001000100062O00080001000200022O009E0002000C3O0006FE00010075000100020004B43O007500012O009E0001000D3O0006FB0001007500013O0004B43O007500012O009E000100054O0016000200063O00202O0002000200144O000300036O000400016O00010004000200062O0001007500013O0004B43O007500012O009E000100073O001221000200153O001221000300164O00AC000100034O00E100015O0012213O00173O0026563O00F6000100180004B43O00F600012O009E00015O00208F00010001001900208E0001000100132O00080001000200020006FB0001009400013O0004B43O009400012O009E000100023O00208E0001000100062O00080001000200022O009E0002000A3O0006FE00010094000100020004B43O009400012O009E0001000B3O0006FB0001009400013O0004B43O009400012O009E000100054O0016000200063O00202O00020002001A4O000300036O000400016O00010004000200062O0001009400013O0004B43O009400012O009E000100073O0012210002001B3O0012210003001C4O00AC000100034O00E100016O009E0001000E3O00205B00010001001D4O0002000F6O000300106O00010003000200062O000100702O013O0004B43O00702O012O009E000100114O00A9000200073O00122O0003001E3O00122O0004001F6O00020004000200062O000100B9000100020004B43O00B900012O009E00015O00208F00010001002000208E0001000100132O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100054O00C8000200063O00202O0002000200214O000300123O00202O00030003002200122O000500236O0003000500024O000300036O00010003000200062O000100702O013O0004B43O00702O012O009E000100073O001211000200243O00122O000300256O000100036O00015O00044O00702O012O009E000100114O00A9000200073O00122O000300263O00122O000400276O00020004000200062O000100D2000100020004B43O00D200012O009E00015O00208F00010001002000208E0001000100132O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100054O009E000200063O00208F0002000200282O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100073O001211000200293O00122O0003002A6O000100036O00015O00044O00702O012O009E000100114O00A9000200073O00122O0003002B3O00122O0004002C6O00020004000200062O000100702O0100020004B43O00702O012O009E00015O00208F00010001002000208E0001000100132O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100133O00208E00010001002D2O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100013O00208E00010001002E2O009E000300134O004F0001000300020006FB000100702O013O0004B43O00702O012O009E000100054O009E000200063O00208F0002000200282O00080001000200020006FB000100702O013O0004B43O00702O012O009E000100073O0012110002002F3O00122O000300306O000100036O00015O00044O00702O010026563O00362O0100050004B43O00362O012O009E00015O00208F00010001001200208E0001000100132O00080001000200020006FB0001001B2O013O0004B43O001B2O012O009E000100013O0020C40001000100314O00035O00202O0003000300324O00010003000200062O0001001B2O013O0004B43O001B2O012O009E000100023O00208E0001000100062O00080001000200022O009E000200143O0006FE0001001B2O0100020004B43O001B2O012O009E0001000D3O0006FB0001001B2O013O0004B43O001B2O012O009E000100054O0016000200063O00202O0002000200144O000300036O000400016O00010004000200062O0001001B2O013O0004B43O001B2O012O009E000100073O001221000200333O001221000300344O00AC000100034O00E100016O009E00015O00208F00010001003500208E0001000100032O00080001000200020006FB000100352O013O0004B43O00352O012O009E000100023O00208E0001000100062O00080001000200022O009E000200153O0006FE000100352O0100020004B43O00352O012O009E000100163O0006FB000100352O013O0004B43O00352O012O009E000100054O009E000200063O00208F0002000200362O00080001000200020006FB000100352O013O0004B43O00352O012O009E000100073O001221000200373O001221000300384O00AC000100034O00E100015O0012213O00183O0026563O0001000100170004B43O000100012O009E00015O00208F00010001003900208E0001000100032O00080001000200020006FB000100522O013O0004B43O00522O012O009E000100023O00208E0001000100062O000800010002000200120B0002003A3O0006FE000100522O0100020004B43O00522O0100120B0001003B3O0006FB000100522O013O0004B43O00522O012O009E000100054O009E000200063O00208F00020002003C2O00080001000200020006FB000100522O013O0004B43O00522O012O009E000100073O0012210002003D3O0012210003003E4O00AC000100034O00E100016O009E00015O00208F00010001003F00208E0001000100132O00080001000200020006FB0001006E2O013O0004B43O006E2O012O009E000100023O00208E0001000100062O000800010002000200120B000200403O0006FE0001006E2O0100020004B43O006E2O0100120B000100413O0006FB0001006E2O013O0004B43O006E2O012O009E000100054O0016000200063O00202O00020002003F4O000300036O000400016O00010004000200062O0001006E2O013O0004B43O006E2O012O009E000100073O001221000200423O001221000300434O00AC000100034O00E100015O0012213O00053O0004B43O000100012O00CB3O00017O00063O00028O00027O004003063O0045786973747303093O004973496E52616E6765026O004440026O00F03F00283O0012213O00014O00CA000100013O000E750002000800013O0004B43O000800010006FB0001002700013O0004B43O002700012O0034000100023O0004B43O00270001000E750001001D00013O0004B43O001D00012O009E00025O0006FB0002001800013O0004B43O001800012O009E00025O00208E0002000200032O00080002000200020006FB0002001800013O0004B43O001800012O009E00025O00208E000200020004001221000400054O004F00020004000200065000020019000100010004B43O001900012O00CB3O00014O009E000200014O008A0002000100022O007B000100023O0012213O00063O0026563O0002000100060004B43O000200010006FB0001002200013O0004B43O002200012O0034000100024O009E000200024O008A0002000100022O007B000100023O0012213O00023O0004B43O000200012O00CB3O00017O00453O00028O00026O00184003043O00F4E479ED03063O00A7BA8B1788EB030D3O00426561636F6E6F664C69676874030A3O0049734361737461626C6503093O004E616D6564556E6974026O004440026O003E400003083O0042752O66446F776E03123O00426561636F6E6F664C696768744D6163726F03163O0018B0890E15BBB7021C8A84041DBD9C4D19BA850F1BA103043O006D7AD5E803043O00C0F8AC3503043O00508E97C2030D3O00426561636F6E6F66466169746803123O00426561636F6E6F6646616974684D6163726F03163O0001C3764F0CC8484305F9714D0AD27F0C00C97A4E02D203043O002C63A617026O001C40026O001040030D3O0048616E646C654368726F6D6965030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F76657203093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572026O001440026O00F03F03113O0048616E646C65496E636F72706F7265616C03083O005475726E4576696C03113O005475726E4576696C4D6F7573656F766572030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F76657203083O00446562752O66557003093O00456E74616E676C656403113O00426C652O73696E676F6646722O65646F6D03073O004973526561647903173O00426C652O73696E676F6646722O65646F6D506C61796572031A3O007EFB2C2520AD72F01639359B7AE52C3337AB71B72A393EA67DE303063O00C41C97495653026O002040026O002240030D3O00546172676574497356616C6964030F3O0047657443617374696E67456E656D7903143O00426C61636B6F757442612O72656C446562752O6603123O00466F637573537065636966696564556E697403163O00476574556E697473546172676574467269656E646C79030A3O00556E69744973556E697403023O00494403163O00426C652O73696E676F6646722O65646F6D466F637573031A3O00F10F2C0391511671CC0C2O2F844A1D73F70C245081571574F21703083O001693634970E23878031B3O00466F637573556E697457697468446562752O6646726F6D4C69737403073O0050616C6164696E03113O0046722O65646F6D446562752O664C697374026O00344003153O00556E6974486173446562752O6646726F6D4C697374031A3O00BA79E7E69EB17BE5CA82BE4AE4E788BD71EDF8CDBB7AEFF78CAC03053O00EDD8158295030F3O0048616E646C65412O666C696374656403093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F766572027O004003073O00436C65616E736503103O00436C65616E73654D6F7573656F766572026O000840030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F76657200F0012O0012213O00014O00CA000100013O0026563O0060000100020004B43O006000012O009E00026O00A0000300013O00122O000400033O00122O000500046O00030005000200062O00020030000100030004B43O003000012O009E000200023O00208F00020002000500208E0002000200062O00080002000200020006FB0002003000013O0004B43O003000012O009E000200033O0020AA00020002000700122O000300086O00045O00122O000500096O00020005000200262O000200300001000A0004B43O003000012O009E000200033O002O2000020002000700122O000300086O00045O00122O000500096O00020005000200202O00020002000B4O000400023O00202O0004000400054O00020004000200062O0002003000013O0004B43O003000012O009E000200044O009E000300053O00208F00030003000C2O00080002000200020006FB0002003000013O0004B43O003000012O009E000200013O0012210003000D3O0012210004000E4O00AC000200044O00E100026O009E000200064O00A0000300013O00122O0004000F3O00122O000500106O00030005000200062O0002005C000100030004B43O005C00012O009E000200023O00208F00020002001100208E0002000200062O00080002000200020006FB0002005C00013O0004B43O005C00012O009E000200033O0020AA00020002000700122O000300086O000400063O00122O000500096O00020005000200262O0002005C0001000A0004B43O005C00012O009E000200033O002O2000020002000700122O000300086O000400063O00122O000500096O00020005000200202O00020002000B4O000400023O00202O0004000400114O00020004000200062O0002005C00013O0004B43O005C00012O009E000200044O009E000300053O00208F0003000300122O00080002000200020006FB0002005C00013O0004B43O005C00012O009E000200013O001221000300133O001221000400144O00AC000200044O00E100026O009E000200074O008A0002000100022O007B000100023O0012213O00153O0026563O0078000100160004B43O007800012O009E000200033O00206B0002000200174O000300023O00202O0003000300184O000400053O00202O00040004001900122O000500086O0002000500024O000100023O00062O0001006E00013O0004B43O006E00012O0034000100024O009E000200033O0020A30002000200174O000300023O00202O00030003001A4O000400053O00202O00040004001B00122O000500086O0002000500024O000100023O00124O001C3O0026563O00BE0001001C0004B43O00BE00010006FB0001007D00013O0004B43O007D00012O0034000100024O009E000200083O0006FB000200A200013O0004B43O00A20001001221000200013O002656000200910001001D0004B43O009100012O009E000300033O0020F000030003001E4O000400023O00202O00040004001F4O000500053O00202O00050005002000122O000600096O000700016O0003000700024O000100033O00062O000100A200013O0004B43O00A200012O0034000100023O0004B43O00A2000100265600020081000100010004B43O008100012O009E000300033O0020F000030003001E4O000400023O00202O0004000400214O000500053O00202O00050005002200122O000600096O000700016O0003000700024O000100033O00062O000100A000013O0004B43O00A000012O0034000100023O0012210002001D3O0004B43O008100012O009E000200093O0006FB000200BD00013O0004B43O00BD00012O009E0002000A3O0020C40002000200234O000400023O00202O0004000400244O00020004000200062O000200BD00013O0004B43O00BD00012O009E000200023O00208F00020002002500208E0002000200262O00080002000200020006FB000200BD00013O0004B43O00BD00012O009E000200044O009E000300053O00208F0003000300272O00080002000200020006FB000200BD00013O0004B43O00BD00012O009E000200013O001221000300283O001221000400294O00AC000200044O00E100025O0012213O00023O0026563O00CA0001002A0004B43O00CA00012O009E0002000B4O008A0002000100022O007B000100023O0006FB000100C600013O0004B43O00C600012O0034000100024O009E0002000C4O008A0002000100022O007B000100023O0012213O002B3O0026563O00E90001002B0004B43O00E900010006FB000100CF00013O0004B43O00CF00012O0034000100024O009E000200033O00208F00020002002C2O008A0002000100020006FB000200EF2O013O0004B43O00EF2O01001221000200013O002656000200DE0001001D0004B43O00DE00012O009E0003000D4O008A0003000100022O007B000100033O0006FB000100EF2O013O0004B43O00EF2O012O0034000100023O0004B43O00EF2O01002656000200D5000100010004B43O00D500012O009E0003000E4O008A0003000100022O007B000100033O0006FB000100E600013O0004B43O00E600012O0034000100023O0012210002001D3O0004B43O00D500010004B43O00EF2O010026563O00F5000100150004B43O00F500010006FB000100EE00013O0004B43O00EE00012O0034000100024O009E0002000F4O008A0002000100022O007B000100023O0006FB000100F400013O0004B43O00F400012O0034000100023O0012213O002A3O000E75000100492O013O0004B43O00492O012O009E000200033O00200401020002002D4O000300023O00202O00030003002E4O00020002000200062O0002003C2O013O0004B43O003C2O012O009E000200023O00208F00020002002500208E0002000200262O00080002000200020006FB0002003C2O013O0004B43O003C2O01001221000200014O00CA000300033O002656000200192O0100010004B43O00192O012O009E000400033O00205100040004002F4O000500033O00202O0005000500304O000600033O00202O00060006002D4O000700023O00202O00070007002E4O000600076O00053O000200122O000600086O0004000600024O000300043O00062O000300182O013O0004B43O00182O012O0034000300023O0012210002001D3O002656000200062O01001D0004B43O00062O012O009E000400103O0006FB0004003C2O013O0004B43O003C2O0100120B000400314O00B5000500103O00202O0005000500324O0005000200024O000600033O00202O0006000600304O000700033O00202O00070007002D4O000800023O00202O00080008002E4O000700086O00063O000200202O0006000600324O000600076O00043O000200062O0004003C2O013O0004B43O003C2O012O009E000400044O009E000500053O00208F0005000500332O00080004000200020006FB0004003C2O013O0004B43O003C2O012O009E000400013O001211000500343O00122O000600356O000400066O00045O00044O003C2O010004B43O00062O012O009E000200033O00204D0002000200364O000300113O00202O00030003003700202O00030003003800122O000400083O00122O000500396O0002000500024O000100023O00062O000100482O013O0004B43O00482O012O0034000100023O0012213O001D3O0026563O00C42O01001D0004B43O00C42O012O009E000200023O00208F00020002002500208E0002000200262O00080002000200020006FB000200652O013O0004B43O00652O012O009E000200033O0020EE00020002003A4O000300106O000400113O00202O00040004003700202O0004000400384O00020004000200062O000200652O013O0004B43O00652O012O009E000200044O009E000300053O00208F0003000300332O00080002000200020006FB000200652O013O0004B43O00652O012O009E000200013O0012210003003B3O0012210004003C4O00AC000200044O00E100026O009E000200123O0006FB000200732O013O0004B43O00732O01001221000200013O002656000200692O0100010004B43O00692O012O009E000300134O008A0003000100022O007B000100033O0006FB000100732O013O0004B43O00732O012O0034000100023O0004B43O00732O010004B43O00692O012O009E000200143O0006FB000200C32O013O0004B43O00C32O01001221000200013O002656000200862O01001D0004B43O00862O012O009E000300033O00206B00030003003D4O000400023O00202O00040004003E4O000500053O00202O00050005003F00122O000600086O0003000600024O000100033O00062O000100852O013O0004B43O00852O012O0034000100023O001221000200403O002656000200952O0100010004B43O00952O012O009E000300033O00206B00030003003D4O000400023O00202O0004000400414O000500053O00202O00050005004200122O000600086O0003000600024O000100033O00062O000100942O013O0004B43O00942O012O0034000100023O0012210002001D3O002656000200A42O0100160004B43O00A42O012O009E000300033O00206B00030003003D4O000400023O00202O00040004001A4O000500053O00202O00050005001B00122O000600086O0003000600024O000100033O00062O000100C32O013O0004B43O00C32O012O0034000100023O0004B43O00C32O01002656000200B32O0100430004B43O00B32O012O009E000300033O00206B00030003003D4O000400023O00202O0004000400184O000500053O00202O00050005001900122O000600086O0003000600024O000100033O00062O000100B22O013O0004B43O00B22O012O0034000100023O001221000200163O002656000200772O0100400004B43O00772O012O009E000300033O00206B00030003003D4O000400023O00202O0004000400444O000500053O00202O00050005004500122O000600086O0003000600024O000100033O00062O000100C12O013O0004B43O00C12O012O0034000100023O001221000200433O0004B43O00772O010012213O00403O0026563O00DC2O0100400004B43O00DC2O012O009E000200033O00206B0002000200174O000300023O00202O0003000300414O000400053O00202O00040004004200122O000500086O0002000500024O000100023O00062O000100D22O013O0004B43O00D22O012O0034000100024O009E000200033O0020A30002000200174O000300023O00202O00030003003E4O000400053O00202O00040004003F00122O000500086O0002000500024O000100023O00124O00433O0026563O0002000100430004B43O000200010006FB000100E12O013O0004B43O00E12O012O0034000100024O009E000200033O00206B0002000200174O000300023O00202O0003000300444O000400053O00202O00040004004500122O000500086O0002000500024O000100023O00062O000100ED2O013O0004B43O00ED2O012O0034000100023O0012213O00163O0004B43O000200012O00CB3O00017O00353O00028O00027O0040030C3O0053686F756C6452657475726E030D3O0048616E646C654368726F6D6965030B3O00576F72646F66476C6F727903143O00576F72646F66476C6F72794D6F7573656F766572026O004440030C3O00466C6173686F664C6967687403153O00466C6173686F664C696768744D6F7573656F766572026O000840026O001040030F3O0048616E646C65412O666C696374656403093O00486F6C794C6967687403123O00486F6C794C696768744D6F7573656F766572026O00F03F03093O00486F6C7953686F636B03123O00486F6C7953686F636B4D6F7573656F76657203073O00436C65616E736503103O00436C65616E73654D6F7573656F76657203113O0048616E646C65496E636F72706F7265616C030A3O00526570656E74616E636503133O00526570656E74616E63654D6F7573656F766572026O003E4003083O005475726E4576696C03113O005475726E4576696C4D6F7573656F76657203083O00446562752O66557003093O00456E74616E676C656403113O00426C652O73696E676F6646722O65646F6D03073O004973526561647903173O00426C652O73696E676F6646722O65646F6D506C6179657203213O0080425A4CA3C050857150598FCF4C874B5B50BD8951975A1F50B6895D8D435D5EA403073O003EE22E2O3FD0A903043O00CB165B8603083O003E857935E37F6D4F030D3O00426561636F6E6F664C69676874030A3O0049734361737461626C6503093O004E616D6564556E69740003083O0042752O66446F776E03123O00426561636F6E6F664C696768744D6163726F03163O00121133F6D9A09D1F120DF9DFA9AA045431FADBACA30403073O00C270745295B6CE03043O0017A7421D03073O006E59C82C78A082030D3O00426561636F6E6F66466169746803123O00426561636F6E6F6646616974684D6163726F03163O00A9C64A454C440442ADFC4D474A5E330DA8CC4644425E03083O002DCBA32B26232A5B026O001440030C3O004465766F74696F6E41757261030D3O00D680CA2C93A05BDCBADD3695A803073O0034B2E5BC43E7C9030D3O00546172676574497356616C6964009C012O0012213O00013O0026563O001B000100020004B43O001B00012O009E00015O00207F0001000100044O000200013O00202O0002000200054O000300023O00202O00030003000600122O000400076O00010004000200122O000100033O00122O000100033O00062O0001001100013O0004B43O0011000100120B000100034O0034000100024O009E00015O00201F0001000100044O000200013O00202O0002000200084O000300023O00202O00030003000900122O000400076O00010004000200122O000100033O00124O000A3O0026563O0091000100010004B43O009100012O009E000100033O0006FB0001002D00013O0004B43O002D0001001221000100013O00265600010021000100010004B43O002100012O009E000200044O008A0002000100020012BF000200033O00120B000200033O0006FB0002002D00013O0004B43O002D000100120B000200034O0034000200023O0004B43O002D00010004B43O002100012O009E000100053O0006FB0001008700013O0004B43O00870001001221000100013O000E75000B0042000100010004B43O004200012O009E00025O00207F00020002000C4O000300013O00202O00030003000D4O000400023O00202O00040004000E00122O000500076O00020005000200122O000200033O00122O000200033O00062O0002008700013O0004B43O0087000100120B000200034O0034000200023O0004B43O00870001002656000100530001000A0004B43O005300012O009E00025O00207F00020002000C4O000300013O00202O0003000300084O000400023O00202O00040004000900122O000500076O00020005000200122O000200033O00122O000200033O00062O0002005200013O0004B43O0052000100120B000200034O0034000200023O0012210001000B3O002656000100640001000F0004B43O006400012O009E00025O00207F00020002000C4O000300013O00202O0003000300104O000400023O00202O00040004001100122O000500076O00020005000200122O000200033O00122O000200033O00062O0002006300013O0004B43O0063000100120B000200034O0034000200023O001221000100023O00265600010075000100020004B43O007500012O009E00025O00207F00020002000C4O000300013O00202O0003000300054O000400023O00202O00040004000600122O000500076O00020005000200122O000200033O00122O000200033O00062O0002007400013O0004B43O0074000100120B000200034O0034000200023O0012210001000A3O00265600010031000100010004B43O003100012O009E00025O00207F00020002000C4O000300013O00202O0003000300124O000400023O00202O00040004001300122O000500076O00020005000200122O000200033O00122O000200033O00062O0002008500013O0004B43O0085000100120B000200034O0034000200023O0012210001000F3O0004B43O003100012O009E00015O00201F0001000100044O000200013O00202O0002000200124O000300023O00202O00030003001300122O000400076O00010004000200122O000100033O00124O000F3O0026563O00422O01000B0004B43O00422O012O009E000100063O0006FB000100BC00013O0004B43O00BC0001001221000100013O002656000100A9000100010004B43O00A900012O009E00025O0020030102000200144O000300013O00202O0003000300154O000400023O00202O00040004001600122O000500176O000600016O00020006000200122O000200033O00122O000200033O00062O000200A800013O0004B43O00A8000100120B000200034O0034000200023O0012210001000F3O002656000100970001000F0004B43O009700012O009E00025O0020030102000200144O000300013O00202O0003000300184O000400023O00202O00040004001900122O000500176O000600016O00020006000200122O000200033O00122O000200033O00062O000200BC00013O0004B43O00BC000100120B000200034O0034000200023O0004B43O00BC00010004B43O009700012O009E000100073O0006FB000100D700013O0004B43O00D700012O009E000100083O0020C400010001001A4O000300013O00202O00030003001B4O00010003000200062O000100D700013O0004B43O00D700012O009E000100013O00208F00010001001C00208E00010001001D2O00080001000200020006FB000100D700013O0004B43O00D700012O009E000100094O009E000200023O00208F00020002001E2O00080001000200020006FB000100D700013O0004B43O00D700012O009E0001000A3O0012210002001F3O001221000300204O00AC000100034O00E100016O009E0001000B3O0006FB000100412O013O0004B43O00412O01001221000100014O00CA000200023O002656000100E50001000F0004B43O00E500012O009E0003000C4O008A0003000100022O007B000200033O0006FB000200412O013O0004B43O00412O012O0034000200023O0004B43O00412O01002656000100DC000100010004B43O00DC00012O009E0003000D4O00A00004000A3O00122O000500213O00122O000600226O00040006000200062O000300132O0100040004B43O00132O012O009E000300013O00208F00030003002300208E0003000300242O00080003000200020006FB000300132O013O0004B43O00132O012O009E00035O0020AA00030003002500122O000400076O0005000D3O00122O000600176O00030006000200262O000300132O0100260004B43O00132O012O009E00035O002O2000030003002500122O000400076O0005000D3O00122O000600176O00030006000200202O0003000300274O000500013O00202O0005000500234O00030005000200062O000300132O013O0004B43O00132O012O009E000300094O009E000400023O00208F0004000400282O00080003000200020006FB000300132O013O0004B43O00132O012O009E0003000A3O001221000400293O0012210005002A4O00AC000300054O00E100036O009E0003000E4O00A00004000A3O00122O0005002B3O00122O0006002C6O00040006000200062O0003003F2O0100040004B43O003F2O012O009E000300013O00208F00030003002D00208E0003000300242O00080003000200020006FB0003003F2O013O0004B43O003F2O012O009E00035O0020AA00030003002500122O000400076O0005000E3O00122O000600176O00030006000200262O0003003F2O0100260004B43O003F2O012O009E00035O002O2000030003002500122O000400076O0005000E3O00122O000600176O00030006000200202O0003000300274O000500013O00202O00050005002D4O00030005000200062O0003003F2O013O0004B43O003F2O012O009E000300094O009E000400023O00208F00040004002E2O00080003000200020006FB0003003F2O013O0004B43O003F2O012O009E0003000A3O0012210004002F3O001221000500304O00AC000300054O00E100035O0012210001000F3O0004B43O00DC00010012213O00313O0026563O00582O01000F0004B43O00582O0100120B000100033O0006FB000100492O013O0004B43O00492O0100120B000100034O0034000100024O009E00015O00207F0001000100044O000200013O00202O0002000200104O000300023O00202O00030003001100122O000400076O00010004000200122O000100033O00122O000100033O00062O000100572O013O0004B43O00572O0100120B000100034O0034000100023O0012213O00023O000E75000A006E2O013O0004B43O006E2O0100120B000100033O0006FB0001005F2O013O0004B43O005F2O0100120B000100034O0034000100024O009E00015O00207F0001000100044O000200013O00202O00020002000D4O000300023O00202O00030003000E00122O000400076O00010004000200122O000100033O00122O000100033O00062O0001006D2O013O0004B43O006D2O0100120B000100034O0034000100023O0012213O000B3O0026563O0001000100310004B43O000100012O009E000100013O00208F00010001003200208E0001000100242O00080001000200020006FB000100882O013O0004B43O00882O012O009E000100083O0020C40001000100274O000300013O00202O0003000300324O00010003000200062O000100882O013O0004B43O00882O012O009E000100094O009E000200013O00208F0002000200322O00080001000200020006FB000100882O013O0004B43O00882O012O009E0001000A3O001221000200333O001221000300344O00AC000100034O00E100016O009E00015O00208F0001000100352O008A0001000100020006FB0001009B2O013O0004B43O009B2O01001221000100014O00CA000200023O0026560001008F2O0100010004B43O008F2O012O009E0003000F4O008A0003000100022O007B000200033O0006FB0002009B2O013O0004B43O009B2O012O0034000200023O0004B43O009B2O010004B43O008F2O010004B43O009B2O010004B43O000100012O00CB3O00017O00623O00028O00026O001040030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O001452552CF25D2F35494310F8522603073O004341213064973C030D3O00F7E2AFD4E7D7F4BAD7FDDACF9E03053O0093BF87CEB8031B3O00B13BA3E0CE56BC8321A8C6EF41B3902089C7DE56BC9721B0C4D44A03073O00D2E448C6A1B83303183O00035AF6347AD83F47F6247CC23A66F51676C02540E5157FD703063O00AE5629937013026O001440026O001840030D3O006E13882724163EA57301830F3603083O00CB3B60ED6B456F71030C3O000817B5CE3FD8D62A12BFC90103073O00B74476CC81519003133O003BBE75C0029407A375D4198D1AA873F0028D0003063O00E26ECD10846B03123O00CFCAF6D04FEEF3F2D655EEC0F4D04EE5EBD003053O00218BA380B9026O001C40027O0040030D3O00735117CE525420DB554D02D84403043O00BE373864030B3O0072A62F0E16EFD143A93A0D03073O009336CF5C7E7383030F3O0025303B79017B2C373371047D19343103063O001E6D51551D6D03113O00D7705AB23ADBD5F1725BA426D1EEFA705803073O009C9F1134D656BE026O000840026O002240030E3O008FFAAFBD83EEAEA8ABFDA4B486DF03043O00DCCE8FDD03103O00A7683F16F5CDC192783F0EFFDEDD936D03073O00B2E61D4D77B8AC03163O00C0AD0F397BFDE6AD031570D7F38D0B1865F1F3B7091E03063O009895DE6A7B1703153O00FF2AF350A6D428F16CB3EE27F551BCDB2FF5469DED03053O00D5BD469623026O00244003103O0067547A0C435051065B547A0F435C7A0F03043O00682F351403113O008A429519AE1DB65C952BB51BAB7F9509B203063O006FC32CE17CDC03163O00F14814762OB9CD56145CA5A7C171087ABFAED44F136703063O00CBB8266013CB03123O00107D6D44DC2B666955FA31617C52C6367F7D03053O00AE59131921026O00204003103O001A01576FE18205281B5C49C0950A3B1A03073O006B4F72322E97E7030F3O00182OB0278D30B9C70E2OB43D82118703083O00A059C6D549EA59D703123O006967B1F0C2417FB3C9D74965BCD9D74764A403053O00A52811D49E030E3O00D0CA0D1233F7D8253235F1DC1A2A03053O004685B96853030F3O003156410EC0124C4A2FFA0C4C4126CD03053O00A96425244A030E3O00248EB4590E8291580982AE5428B703043O003060E7C2030E3O00FD490B1A16CAABACCE7D02220BC103083O00E3A83A6E4D79B8CF030E3O004C33AD44BEDD56A9742EA64499EB03083O00C51B5CDF20D1BB11026O00F03F03153O00364CC6CB0C48C6E93450D1FF2550D1EF0A4BD6FF0603043O009B633FA303113O00B7C2A4ACB78387DDA88E9F8183C5A988AB03063O00E4E2B1C1EDD9030E3O0001A326C43BB43AC73AB410E921BC03043O008654D043030D3O003EA390591EA9884837A98A5D0A03043O003C73CCE6030C3O00D229EE58E836F243EF35E87B03043O0010875A8B030B3O007C7B0A2A7D5C77577F2E2O03073O0018341466532E3403173O00F13C240C00C836122C00C7240E2209C121322D19C1233803053O006FA44F414403113O00F3CA86F621E6DFEA8BD12DE1E5C080D22B03063O008AA6B9E3BE4E03113O00FE67C01F5D2F00F87CCA3459040BC461D503073O0079AB14A557324303173O00F32BBC1EB60EDF0BB139BA09F43DBF24BC11CE17B73AA003063O0062A658D956D9030A3O00C3E57C3387DFFFF7751203063O00BC2O961961E603103O00EF9A5A2A09ECD68051053CE2CE80500C03063O008DBAE93F626C03113O00D9EF2DBA2CFFED1CB931F8E5229824FCEF03053O0045918A4CD6034O00030F3O0058CA8885B61877FF869DB6197EE7B903063O007610AF2OE9DF00A4012O0012213O00013O0026563O0027000100020004B43O0027000100120B000100033O00206F0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O00010001000200062O00010015000100010004B43O00150001001221000100014O007E000100023O00129D000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O0001000100024O000100043O00124O000D3O0026563O00500001000E0004B43O0050000100120B000100033O00206F0001000100044O000200013O00122O0003000F3O00122O000400106O0002000400024O0001000100024O000100053O00122O000100033O00202O0001000100044O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200062O0001003B000100010004B43O003B0001001221000100014O007E000100063O0012062O0100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O0001000100024O000100073O00122O000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O00010001000200062O0001004E000100010004B43O004E0001001221000100014O007E000100083O0012213O00173O0026563O0073000100180004B43O0073000100120B000100033O00208C0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O0001000100024O000100093O00122O000100033O00202O0001000100044O000200013O00122O0003001B3O00122O0004001C6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O0003001D3O00122O0004001E6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001F3O00122O000400206O0002000400024O0001000100024O0001000C3O00124O00213O0026563O009F000100220004B43O009F000100120B000100033O0020710001000100044O000200013O00122O000300233O00122O000400246O0002000400024O00010001000200062O0001007F000100010004B43O007F0001001221000100014O007E0001000D3O0012CC000100033O00202O0001000100044O000200013O00122O000300253O00122O000400266O0002000400024O00010001000200062O0001008A000100010004B43O008A0001001221000100014O007E0001000E3O0012062O0100033O00202O0001000100044O000200013O00122O000300273O00122O000400286O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O00010001000200062O0001009D000100010004B43O009D0001001221000100014O007E000100103O0012213O002B3O0026563O00C5000100210004B43O00C5000100120B000100033O0020E20001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O0001000100024O000100123O00122O000100033O00202O0001000100044O000200013O00122O000300303O00122O000400316O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O000300323O00122O000400336O0002000400024O00010001000200062O000100C3000100010004B43O00C30001001221000100014O007E000100143O0012213O00023O000E75003400EE00013O0004B43O00EE000100120B000100033O00206F0001000100044O000200013O00122O000300353O00122O000400366O0002000400024O0001000100024O000100153O00122O000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100D9000100010004B43O00D90001001221000100014O007E000100163O0012CC000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100E4000100010004B43O00E40001001221000100014O007E000100173O0012CE000100033O00202O0001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100183O00124O00223O0026563O00172O0100170004B43O00172O0100120B000100033O00206F0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O0001000100024O000100193O00122O000100033O00202O0001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O000100022O0100010004B43O00022O01001221000100014O007E0001001A3O0012062O0100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O0001000100024O0001001B3O00122O000100033O00202O0001000100044O000200013O00122O000300433O00122O000400446O0002000400024O00010001000200062O000100152O0100010004B43O00152O01001221000100014O007E0001001C3O0012213O00343O0026563O003D2O0100450004B43O003D2O0100120B000100033O0020E20001000100044O000200013O00122O000300463O00122O000400476O0002000400024O0001000100024O0001001D3O00122O000100033O00202O0001000100044O000200013O00122O000300483O00122O000400496O0002000400024O0001000100024O0001001E3O00122O000100033O00202O0001000100044O000200013O00122O0003004A3O00122O0004004B6O0002000400024O0001000100024O0001001F3O00122O000100033O00202O0001000100044O000200013O00122O0003004C3O00122O0004004D6O0002000400024O00010001000200062O0001003B2O0100010004B43O003B2O01001221000100014O007E000100203O0012213O00183O0026563O00532O01002B0004B43O00532O0100120B000100033O00206F0001000100044O000200013O00122O0003004E3O00122O0004004F6O0002000400024O0001000100024O000100213O00122O000100033O00202O0001000100044O000200013O00122O000300503O00122O000400516O0002000400024O00010001000200062O000100512O0100010004B43O00512O01001221000100014O007E000100223O0004B43O00A32O010026563O00792O01000D0004B43O00792O0100120B000100033O0020530001000100044O000200013O00122O000300523O00122O000400536O0002000400024O0001000100024O000100233O00122O000100033O00202O0001000100044O000200013O00122O000300543O00122O000400556O0002000400024O0001000100024O000100243O00122O000100033O00202O0001000100044O000200013O00122O000300563O00122O000400576O0002000400024O00010001000200062O0001006F2O0100010004B43O006F2O01001221000100014O007E000100253O0012CE000100033O00202O0001000100044O000200013O00122O000300583O00122O000400596O0002000400024O0001000100024O000100263O00124O000E3O000E750001000100013O0004B43O0001000100120B000100033O0020530001000100044O000200013O00122O0003005A3O00122O0004005B6O0002000400024O0001000100024O000100273O00122O000100033O00202O0001000100044O000200013O00122O0003005C3O00122O0004005D6O0002000400024O0001000100024O000100283O00122O000100033O00202O0001000100044O000200013O00122O0003005E3O00122O0004005F6O0002000400024O00010001000200062O000100952O0100010004B43O00952O01001221000100604O007E000100293O0012CC000100033O00202O0001000100044O000200013O00122O000300613O00122O000400626O0002000400024O00010001000200062O000100A02O0100010004B43O00A02O01001221000100014O007E0001002A3O0012213O00453O0004B43O000100012O00CB3O00017O00593O00028O00026O00F03F030C3O004570696353652O74696E677303083O0053652O74696E6773030E3O00BE97308CE19979A48212B7E1996403073O001DEBE455DB8EEB030D3O000ADBA8D95848005E32C6A3F54703083O00325DB4DABD172E4703113O00EBB75E6E41DD4BD1AA744A72D55ACAB15E03073O0028BEC43B2C24BC03103O001E40DDB7F573223A73D5A6EE6808147503073O006D5C25BCD49A1D03133O0026EAA5C03E542BE992CA234E11EA83D13E4F1403063O003A648FC4A351027O0040026O00184003113O002E5B31B01B4CE9070C4731A2314AE0262A03083O006E7A2243C35F298503143O0041A84959F270BD525CD367B05549D352A3545FC603053O00B615D13B2A03113O008244C03520B0B378C33928A8BE59CC093803063O00DED737A57D4103103O0004D0C81EDDC7C9433AD8C813E6D8C57A03083O002A4CB1A67A92A18D03133O008D8B0BCA5670818313C7777FB19322DC7663B503063O0016C5EA65AE19026O001C40030F3O001827A0FA7AAEC48E023289D571A7C303083O00E64D54C5BC16CFB7030E3O00DF18C7EF848EF619F013CEE8A49103083O00559974A69CECC19003163O0082EC4CA0EC2FA2CC44B4EC148DEE4BA6F709ABEE658303063O0060C4802DD384030C4O009E7E77DDA3ADF43C8A734B03083O00B855ED1B3FB2CFD4030B3O002056054624500E571C713903043O003F683969030E3O003E94A1680280AC50248180451C8903043O00246BE7C4030E3O0071BCA58F499AA4A35CA2AC8F758503043O00E73DD5C203103O0025A43A7B1D823B5708BA33541BA2286303043O001369CD5D030D3O009C1BDBA536BF01D0840BA604D203053O005FC968BEE1030C3O008BC2D7C7A1CEF5C1A3C7E9FE03043O00AECFABA1026O00084003113O00D8ED08D1F9C5FFF708E1D7D1CBFF04E7F003063O00B78D9E6D939803103O000E08F41E250CF4232A2FE7053801CE3C03043O006C4C698603123O00C9C0B0E2C1E5EAB7CDC7ECCDA5D4DDEAC2B403053O00AE8BA5D181034O0003123O0081B6E3C2C90D5F7E85B2EBD5CE366379A4B603083O0018C3D382A1A66310026O001440030C3O006202F02E41134708C42D5D1703063O00762663894C33030A3O00D9271C101B25FC2O2D2203063O00409D46657269030E3O0064A9BEE10245A9ACCB3752A7B2F303053O007020C8C783030D3O00085145BAD1AE2327774EB7D6BB03073O00424C303CD8A3CB03123O008F957CC746DC379E8375FA49CB36BB887AF603073O0044DAE619933FAE026O001040030E3O0081235444A2BE025241BBA8387B7C03053O00D6CD4A332C03113O00D645E5F463E964E3F17AFF5EC5EE78EF5C03053O00179A2C829C03193O0033AAA8BD251A1FA182A806011EB2A8AD221A1EA898BD372O1403063O007371C6CDCE5603143O00A65BFB49975EF05DAB51CE488B43FB59905EF15403043O003AE4379E030B3O00819AD50A3DB437A68CD12503073O0055D4E9B04E5CCD030F3O006E519EEB445DBCED4654AFF0454D9803043O00822A38E8030C3O00DFA621CB4F33F38536EA533203063O005F8AD544832003173O001F3BA46B79263191517F39258E45702F26B24A602F24B803053O00164A48C123030B3O000476E8411C6BED4B2151D403043O00384C198403113O0072C8AC2EDB4DE9AA2BC25BD39E35CE59C403053O00AF3EA1CB4600A4012O0012213O00013O0026563O0035000100020004B43O0035000100120B000100033O00206F0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O00010001000200062O00010015000100010004B43O00150001001221000100014O007E000100023O0012062O0100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000B3O00122O0004000C6O0002000400024O00010001000200062O00010028000100010004B43O00280001001221000100014O007E000100043O0012CC000100033O00202O0001000100044O000200013O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200062O00010033000100010004B43O00330001001221000100014O007E000100053O0012213O000F3O0026563O006C000100100004B43O006C000100120B000100033O0020710001000100044O000200013O00122O000300113O00122O000400126O0002000400024O00010001000200062O00010041000100010004B43O00410001001221000100014O007E000100063O0012CC000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O00010001000200062O0001004C000100010004B43O004C0001001221000100014O007E000100073O0012062O0100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300173O00122O000400186O0002000400024O00010001000200062O0001005F000100010004B43O005F0001001221000100014O007E000100093O0012CC000100033O00202O0001000100044O000200013O00122O000300193O00122O0004001A6O0002000400024O00010001000200062O0001006A000100010004B43O006A0001001221000100014O007E0001000A3O0012213O001B3O0026563O00A0000100010004B43O00A0000100120B000100033O00206F0001000100044O000200013O00122O0003001C3O00122O0004001D6O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O00010001000200062O00010080000100010004B43O00800001001221000100014O007E0001000C3O0012CC000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O00010001000200062O0001008B000100010004B43O008B0001001221000100014O007E0001000D3O0012062O0100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000E3O00122O000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O00010001000200062O0001009E000100010004B43O009E0001001221000100014O007E0001000F3O0012213O00023O0026563O00D40001000F0004B43O00D4000100120B000100033O00206F0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O000300283O00122O000400296O0002000400024O00010001000200062O000100B4000100010004B43O00B40001001221000100014O007E000100113O0012CC000100033O00202O0001000100044O000200013O00122O0003002A3O00122O0004002B6O0002000400024O00010001000200062O000100BF000100010004B43O00BF0001001221000100014O007E000100123O0012062O0100033O00202O0001000100044O000200013O00122O0003002C3O00122O0004002D6O0002000400024O0001000100024O000100133O00122O000100033O00202O0001000100044O000200013O00122O0003002E3O00122O0004002F6O0002000400024O00010001000200062O000100D2000100010004B43O00D20001001221000100014O007E000100143O0012213O00303O0026564O002O01001B0004B44O002O0100120B000100033O00206F0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100153O00122O000100033O00202O0001000100044O000200013O00122O000300333O00122O000400346O0002000400024O00010001000200062O000100E8000100010004B43O00E80001001221000100014O007E000100163O0012CC000100033O00202O0001000100044O000200013O00122O000300353O00122O000400366O0002000400024O00010001000200062O000100F3000100010004B43O00F30001001221000100374O007E000100173O0012CC000100033O00202O0001000100044O000200013O00122O000300383O00122O000400396O0002000400024O00010001000200062O000100FE000100010004B43O00FE0001001221000100374O007E000100183O0004B43O00A32O010026563O00372O01003A0004B43O00372O0100120B000100033O0020710001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200062O0001000C2O0100010004B43O000C2O01001221000100014O007E000100193O0012CC000100033O00202O0001000100044O000200013O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200062O000100172O0100010004B43O00172O01001221000100014O007E0001001A3O0012CC000100033O00202O0001000100044O000200013O00122O0003003F3O00122O000400406O0002000400024O00010001000200062O000100222O0100010004B43O00222O01001221000100014O007E0001001B3O0012CC000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001002D2O0100010004B43O002D2O01001221000100014O007E0001001C3O0012CE000100033O00202O0001000100044O000200013O00122O000300433O00122O000400446O0002000400024O0001000100024O0001001D3O00124O00103O000E750045006E2O013O0004B43O006E2O0100120B000100033O0020710001000100044O000200013O00122O000300463O00122O000400476O0002000400024O00010001000200062O000100432O0100010004B43O00432O01001221000100014O007E0001001E3O0012CC000100033O00202O0001000100044O000200013O00122O000300483O00122O000400496O0002000400024O00010001000200062O0001004E2O0100010004B43O004E2O01001221000100014O007E0001001F3O0012CC000100033O00202O0001000100044O000200013O00122O0003004A3O00122O0004004B6O0002000400024O00010001000200062O000100592O0100010004B43O00592O01001221000100374O007E000100203O0012CC000100033O00202O0001000100044O000200013O00122O0003004C3O00122O0004004D6O0002000400024O00010001000200062O000100642O0100010004B43O00642O01001221000100014O007E000100213O0012CE000100033O00202O0001000100044O000200013O00122O0003004E3O00122O0004004F6O0002000400024O0001000100024O000100223O00124O003A3O0026563O0001000100300004B43O0001000100120B000100033O0020710001000100044O000200013O00122O000300503O00122O000400516O0002000400024O00010001000200062O0001007A2O0100010004B43O007A2O01001221000100014O007E000100233O001292000100033O00202O0001000100044O000200013O00122O000300523O00122O000400536O0002000400024O0001000100024O000100243O00122O000100033O00202O0001000100044O000200013O00122O000300543O00122O000400556O0002000400024O0001000100024O000100253O00122O000100033O00202O0001000100044O000200013O00122O000300563O00122O000400576O0002000400024O00010001000200062O000100952O0100010004B43O00952O01001221000100014O007E000100263O0012CC000100033O00202O0001000100044O000200013O00122O000300583O00122O000400596O0002000400024O00010001000200062O000100A02O0100010004B43O00A02O01001221000100374O007E000100273O0012213O00453O0004B43O000100012O00CB3O00017O002C3O00028O00026O00F03F030C3O004570696353652O74696E677303073O00546F2O676C65732O033O003FD9D003053O00555CBDA37303063O002DA523282CA003043O005849CC5003063O003D93024328DE03063O00BA4EE3702649027O0040026O0010402O033O00414F45030C3O0049734368612O6E656C696E67030F3O00412O66656374696E67436F6D62617403053O00FF4EFE595603063O001A9C379D353303093O0049734D6F756E746564030D3O004973446561644F7247686F7374026O00084003063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B03163O0044656164467269656E646C79556E697473436F756E74030C3O00496E74657263652O73696F6E030A3O0049734361737461626C65030C3O0085D602DCAA5389CB05D0B75E03063O0030ECB876B9D8030A3O004162736F6C7574696F6E030A3O00E4BF443FC321F1B4583E03063O005485DD3750AF030A3O00526564656D7074696F6E03093O004973496E52616E6765026O004440030A3O00AFE220A3CA4CA9EE2BA803063O003CDD8744C6A703073O00436C65616E736503073O004973526561647903093O00466F637573556E6974026O00344003163O00476574456E656D696573496E4D656C2O6552616E6765026O0020402O033O00E1B2FB03063O00B98EDD98E3220005012O0012213O00013O000E750002001C00013O0004B43O001C000100120B000100033O00201E0001000100044O000200013O00122O000300053O00122O000400066O0002000400024O0001000100024O00015O00122O000100033O00202O0001000100044O000200013O00122O000300073O00122O000400086O0002000400024O0001000100024O000100023O00122O000100033O00202O0001000100044O000200013O00122O000300093O00122O0004000A6O0002000400024O0001000100024O000100033O00124O000B3O0026563O00530001000C0004B43O0053000100120B0001000D3O0006FB0001002500013O0004B43O002500012O009E000100054O003E000100014O007E000100043O0004B43O00270001001221000100024O007E000100044O009E000100063O00208E00010001000E2O0008000100020002000650000100042O0100010004B43O00042O012O009E000100073O00065000010034000100010004B43O003400012O009E000100063O00208E00010001000F2O00080001000200020006FB000100042O013O0004B43O00042O012O009E000100063O00208E00010001000F2O00080001000200020006FB0001004600013O0004B43O00460001001221000100014O00CA000200023O0026560001003B000100010004B43O003B00012O009E000300084O008A0003000100022O007B000200033O0006FB000200042O013O0004B43O00042O012O0034000200023O0004B43O00042O010004B43O003B00010004B43O00042O01001221000100014O00CA000200023O000E7500010048000100010004B43O004800012O009E000300094O008A0003000100022O007B000200033O0006FB000200042O013O0004B43O00042O012O0034000200023O0004B43O00042O010004B43O004800010004B43O00042O010026563O006A0001000B0004B43O006A000100120B000100033O00209A0001000100044O000200013O00122O000300103O00122O000400116O0002000400024O0001000100024O0001000A6O000100063O00202O0001000100124O00010002000200062O0001006300013O0004B43O006300012O00CB3O00014O009E000100063O00208E0001000100132O00080001000200020006FB0001006900013O0004B43O006900012O00CB3O00013O0012213O00143O0026563O00F4000100140004B43O00F400012O009E0001000B3O0006FB000100C800013O0004B43O00C800012O009E0001000B3O00208E0001000100152O00080001000200020006FB000100C800013O0004B43O00C800012O009E0001000B3O00208E0001000100162O00080001000200020006FB000100C800013O0004B43O00C800012O009E0001000B3O00208E0001000100132O00080001000200020006FB000100C800013O0004B43O00C800012O009E000100063O00208E0001000100172O009E0003000B4O004F000100030002000650000100C8000100010004B43O00C80001001221000100014O00CA000200023O00265600010086000100010004B43O008600012O009E0003000C3O0020A70003000300184O0003000100024O000200036O000300063O00202O00030003000F4O00030002000200062O000300A500013O0004B43O00A500012O009E0003000D3O00208F00030003001900208E00030003001A2O00080003000200020006FB000300C800013O0004B43O00C800012O009E0003000E4O00160004000D3O00202O0004000400194O000500056O000600016O00030006000200062O000300C800013O0004B43O00C800012O009E000300013O0012110004001B3O00122O0005001C6O000300056O00035O00044O00C80001000E82000200B5000100020004B43O00B500012O009E0003000E4O00160004000D3O00202O00040004001D4O000500056O000600016O00030006000200062O000300C800013O0004B43O00C800012O009E000300013O0012110004001E3O00122O0005001F6O000300056O00035O00044O00C800012O009E0003000E4O00790004000D3O00202O0004000400204O0005000B3O00202O00050005002100122O000700226O0005000700024O000500056O000600016O00030006000200062O000300C800013O0004B43O00C800012O009E000300013O001211000400233O00122O000500246O000300056O00035O00044O00C800010004B43O008600012O009E000100063O00208E00010001000F2O0008000100020002000650000100D3000100010004B43O00D300012O009E0001000F3O0006FB000100EE00013O0004B43O00EE00012O009E000100023O0006FB000100EE00013O0004B43O00EE0001001221000100014O00CA000200033O002656000100DB000100020004B43O00DB00010006FB000300EE00013O0004B43O00EE00012O0034000300023O0004B43O00EE0001002656000100D5000100010004B43O00D500012O009E0004000F3O00064C000200E5000100040004B43O00E500012O009E0004000D3O00208F00040004002500208E0004000400262O00080004000200022O007B000200044O009E0004000C3O0020300004000400274O000500026O000600103O00122O000700286O0004000700024O000300043O00122O000100023O00044O00D500012O009E000100063O0020FA00010001002900122O0003002A6O0001000300024O000100053O00124O000C3O000E750001000100013O0004B43O000100012O009E000100114O00940001000100014O000100126O00010001000100122O000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100073O00124O00023O00044O000100012O00CB3O00017O000D3O00028O00026O00F03F03123O0044697370652O6C61626C65446562752O6673030A3O004D657267655461626C6503193O0044697370652O6C61626C6544697365617365446562752O6673030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E031F3O0070CA5BE32O03F654C453F34D73E1189407B4117DA7098575E30311F857C87C03073O009738A5379A235303053O005072696E7403153O00884C09F7E07304E2A1470C2OE0411CAE85530CEDEE03043O008EC0236503173O0044697370652O6C61626C654D61676963446562752O667300243O0012213O00013O000E750002001400013O0004B43O001400012O009E00016O001B000200013O00202O0002000200044O00035O00202O0003000300034O00045O00202O0004000400054O00020004000200102O00010003000200122O000100063O00202O0001000100074O000200023O00122O000300083O00122O000400096O000200046O00013O000100044O002300010026563O0001000100010004B43O000100012O009E000100033O00203200010001000A4O000200023O00122O0003000B3O00122O0004000C6O000200046O00013O00014O00018O00025O00202O00020002000D00102O00010003000200124O00023O00044O000100012O00CB3O00017O00", GetFEnv(), ...);
