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
				if (Enum <= 149) then
					if (Enum <= 74) then
						if (Enum <= 36) then
							if (Enum <= 17) then
								if (Enum <= 8) then
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
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if Stk[Inst[2]] then
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
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
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
									elseif (Enum <= 6) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 7) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, A + Inst[3]);
										end
									else
										local Step;
										local Index;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
											if (Stk[Inst[2]] < Stk[Inst[4]]) then
												VIP = Inst[3];
											else
												VIP = VIP + 1;
											end
										end
									elseif (Enum == 11) then
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
								elseif (Enum <= 14) then
									if (Enum == 13) then
										Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 15) then
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
								elseif (Enum > 16) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 20) then
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
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 23) then
									if (Enum == 22) then
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
										Stk[Inst[2]] = Inst[3];
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
										Stk[Inst[2]] = {};
									end
								elseif (Enum <= 24) then
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
								elseif (Enum == 25) then
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
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								end
							elseif (Enum <= 31) then
								if (Enum <= 28) then
									if (Enum == 27) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 29) then
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
								elseif (Enum == 30) then
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
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 33) then
								if (Enum > 32) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 34) then
								Stk[Inst[2]] = Inst[3] ~= 0;
							elseif (Enum == 35) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 55) then
							if (Enum <= 45) then
								if (Enum <= 40) then
									if (Enum <= 38) then
										if (Enum > 37) then
											Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum > 39) then
										VIP = Inst[3];
									else
										local Edx;
										local Results, Limit;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 42) then
									if (Enum > 41) then
										do
											return;
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
								elseif (Enum <= 43) then
									local Edx;
									local Results, Limit;
									local B;
									local A;
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
									Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 44) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 50) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									end
								elseif (Enum <= 48) then
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 49) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 52) then
								if (Enum == 51) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
								end
							elseif (Enum <= 53) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
							elseif (Enum == 54) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 64) then
							if (Enum <= 59) then
								if (Enum <= 57) then
									if (Enum > 56) then
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
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum > 58) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 61) then
								if (Enum > 60) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 63) then
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum <= 69) then
							if (Enum <= 66) then
								if (Enum == 65) then
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
									Stk[Inst[2]] = Stk[Inst[3]];
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
							elseif (Enum <= 67) then
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
							elseif (Enum == 68) then
								local A = Inst[2];
								do
									return Stk[A], Stk[A + 1];
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
						elseif (Enum <= 71) then
							if (Enum > 70) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 72) then
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum > 73) then
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
					elseif (Enum <= 111) then
						if (Enum <= 92) then
							if (Enum <= 83) then
								if (Enum <= 78) then
									if (Enum <= 76) then
										if (Enum > 75) then
											local A = Inst[2];
											local B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
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
									elseif (Enum == 77) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 80) then
									if (Enum == 79) then
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
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum <= 81) then
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
								elseif (Enum > 82) then
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
							elseif (Enum <= 87) then
								if (Enum <= 85) then
									if (Enum > 84) then
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
										Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
									elseif not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 86) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 89) then
								if (Enum == 88) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
							elseif (Enum <= 90) then
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
							elseif (Enum == 91) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 101) then
							if (Enum <= 96) then
								if (Enum <= 94) then
									if (Enum == 93) then
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
								elseif (Enum == 95) then
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
							elseif (Enum <= 98) then
								if (Enum == 97) then
									Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
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
							elseif (Enum <= 99) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 100) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
						elseif (Enum <= 106) then
							if (Enum <= 103) then
								if (Enum > 102) then
									Stk[Inst[2]]();
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 104) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 105) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 108) then
							if (Enum == 107) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 109) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum > 110) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
					elseif (Enum <= 130) then
						if (Enum <= 120) then
							if (Enum <= 115) then
								if (Enum <= 113) then
									if (Enum == 112) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									end
								elseif (Enum > 114) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
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
							elseif (Enum <= 117) then
								if (Enum > 116) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 118) then
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
								A = Inst[2];
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
							elseif (Enum == 119) then
								local B;
								local Edx;
								local Results;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 125) then
							if (Enum <= 122) then
								if (Enum == 121) then
									local B;
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
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 123) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 124) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 127) then
							if (Enum == 126) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								do
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 128) then
							local Edx;
							local Results, Limit;
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum == 129) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
						end
					elseif (Enum <= 139) then
						if (Enum <= 134) then
							if (Enum <= 132) then
								if (Enum == 131) then
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
						elseif (Enum <= 136) then
							if (Enum == 135) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 137) then
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 138) then
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
					elseif (Enum <= 144) then
						if (Enum <= 141) then
							if (Enum == 140) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]] / Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 142) then
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
						elseif (Enum > 143) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] > Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 148) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 224) then
					if (Enum <= 186) then
						if (Enum <= 167) then
							if (Enum <= 158) then
								if (Enum <= 153) then
									if (Enum <= 151) then
										if (Enum > 150) then
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
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 152) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									else
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									end
								elseif (Enum <= 155) then
									if (Enum > 154) then
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
								elseif (Enum <= 156) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 157) then
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
							elseif (Enum <= 162) then
								if (Enum <= 160) then
									if (Enum > 159) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 161) then
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
							elseif (Enum <= 164) then
								if (Enum == 163) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 165) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 166) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									return Stk[Inst[2]];
								end
							end
						elseif (Enum <= 176) then
							if (Enum <= 171) then
								if (Enum <= 169) then
									if (Enum > 168) then
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
								elseif (Enum > 170) then
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
									Stk[Inst[2]] = Inst[3];
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
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 173) then
								if (Enum == 172) then
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
							elseif (Enum <= 174) then
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 175) then
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
								A = Inst[2];
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
								Stk[A] = Stk[A]();
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
						elseif (Enum <= 181) then
							if (Enum <= 178) then
								if (Enum == 177) then
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 180) then
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
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Enum > 182) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 184) then
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 185) then
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
							local A = Inst[2];
							local T = Stk[A];
							local B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
						end
					elseif (Enum <= 205) then
						if (Enum <= 195) then
							if (Enum <= 190) then
								if (Enum <= 188) then
									if (Enum > 187) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum > 189) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 192) then
								if (Enum == 191) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = #Stk[Inst[3]];
							elseif (Enum > 194) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 200) then
							if (Enum <= 197) then
								if (Enum > 196) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 198) then
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
							elseif (Enum == 199) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							end
						elseif (Enum <= 202) then
							if (Enum > 201) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 203) then
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 204) then
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
					elseif (Enum <= 214) then
						if (Enum <= 209) then
							if (Enum <= 207) then
								if (Enum > 206) then
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
										if (Mvm[1] == 64) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum == 208) then
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
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 211) then
							if (Enum > 210) then
								local B;
								local T;
								local A;
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							end
						elseif (Enum <= 212) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 213) then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 219) then
						if (Enum <= 216) then
							if (Enum == 215) then
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
						elseif (Enum <= 217) then
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
						elseif (Enum > 218) then
							Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
					elseif (Enum <= 221) then
						if (Enum > 220) then
							local A = Inst[2];
							local B = Inst[3];
							for Idx = A, B do
								Stk[Idx] = Vararg[Idx - A];
							end
						else
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 222) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 223) then
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
				elseif (Enum <= 261) then
					if (Enum <= 242) then
						if (Enum <= 233) then
							if (Enum <= 228) then
								if (Enum <= 226) then
									if (Enum > 225) then
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
									end
								elseif (Enum == 227) then
									local A = Inst[2];
									local T = Stk[A];
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
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
								if (Enum > 229) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum <= 231) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 232) then
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 237) then
							if (Enum <= 235) then
								if (Enum > 234) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 236) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = not Stk[Inst[3]];
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
						elseif (Enum <= 239) then
							if (Enum > 238) then
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
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3] - Stk[Inst[4]];
							end
						elseif (Enum <= 240) then
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
						elseif (Enum > 241) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 251) then
						if (Enum <= 246) then
							if (Enum <= 244) then
								if (Enum > 243) then
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
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 245) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 248) then
							if (Enum > 247) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 249) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 250) then
							if (Stk[Inst[2]] > Inst[4]) then
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 256) then
						if (Enum <= 253) then
							if (Enum > 252) then
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
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
						elseif (Enum <= 254) then
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
						elseif (Enum > 255) then
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
					elseif (Enum <= 258) then
						if (Enum > 257) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 259) then
						if (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 260) then
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 280) then
					if (Enum <= 270) then
						if (Enum <= 265) then
							if (Enum <= 263) then
								if (Enum > 262) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 264) then
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
							end
						elseif (Enum <= 267) then
							if (Enum == 266) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							else
								local A = Inst[2];
								Stk[A] = Stk[A]();
							end
						elseif (Enum <= 268) then
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
						elseif (Enum == 269) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 275) then
						if (Enum <= 272) then
							if (Enum > 271) then
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
						elseif (Enum <= 273) then
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
						elseif (Enum == 274) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 277) then
						if (Enum == 276) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 278) then
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
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 279) then
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
				elseif (Enum <= 289) then
					if (Enum <= 284) then
						if (Enum <= 282) then
							if (Enum == 281) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 283) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 286) then
						if (Enum == 285) then
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
					elseif (Enum <= 287) then
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
					elseif (Enum == 288) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					end
				elseif (Enum <= 294) then
					if (Enum <= 291) then
						if (Enum > 290) then
							local A = Inst[2];
							do
								return Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 292) then
						local A;
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum > 293) then
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
						Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 296) then
					if (Enum > 295) then
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
						do
							return Stk[Inst[2]];
						end
						VIP = VIP + 1;
						Inst = Instr[VIP];
						do
							return;
						end
					end
				elseif (Enum <= 297) then
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
				elseif (Enum > 298) then
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
					Stk[Inst[2]] = Inst[3];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!3E3O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E7365727403073O00457069634442432O033O0044424303073O00457069634C696203093O0045706963436163686503043O00556E697403063O00506C6179657203093O004D6F7573654F7665722O033O0050657403063O0054617267657403053O005370652O6C030A3O004D756C74695370652O6C03043O004974656D03043O0043617374030B3O0043617374502O6F6C696E6703053O004D6163726F03053O005072652O7303073O00436F2O6D6F6E7303083O0045766572796F6E652O033O006E756D03043O00622O6F6C03053O00447275696403053O00466572616C024O0080B3C540030B3O00496E6361726E6174696F6E030B3O004973417661696C61626C6503073O004265727365726B03103O005265676973746572466F724576656E74030E3O00F8F586FBFDD532E8ED82F9F6C32903073O006DABA5C3B7B18603143O001BFDFF267612FCE1276812F4F22B7119E7EA357A03053O003857B8BE7403143O000C1D28823CD91E0719162C9526CE0F141E1D2C9F03083O00555C5169DB798B4103143O00D196717752FAD98C637559F3D18C796B43EBDC9103063O00BF9DD330251C030D3O004164617074697665537761726D03163O005265676973746572496E466C69676874452O66656374024O0044EB174103103O005265676973746572496E466C6967687403043O0052616B6503133O005265676973746572504D756C7469706C696572030A3O0052616B65446562752O6603053O00536872656403153O00526567697374657244616D616765466F726D756C6103063O00546872617368030A3O004C494D2O6F6E66697265030B3O0042727574616C536C61736803053O005377697065030B3O00466572616C4672656E7A7903153O00436F756E7441637469766542745472692O6765727303063O0053657441504C025O00C0594000C9012O0012D13O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004283O000A0001001259000300063O0020C8000400030007001259000500083O0020C8000500050009001259000600083O0020C800060006000A0006CF00073O000100062O00403O00064O00408O00403O00044O00403O00014O00403O00024O00403O00054O008B0008000A3O00122O000A000B3O00202O000A000A000C00122O000B000D3O00122O000C000E3O00202O000D000B000F00202O000E000D001000202O000F000D001100202O0010000D001200202O0011000D00130020C80012000B00140020E10013000B001500202O0014000B001600122O0015000D3O00202O00160015001700202O00170015001800202O00180015001900202O00190015001A00202O001A0015001B00202O001A001A001C00202O001A001A001D0020C8001B0015001B002052001B001B001C00202O001B001B001E4O001C8O001D8O001E8O001F5O00202O00200015001B00202O00200020001C00202O00210012001F00202O0021002100200020C800220014001F0020320022002200204O00238O0024003E3O00202O003F0018001F00202O003F003F00204O004000483O00122O004900213O00122O004A00216O004B004E3O00202O004F0021002200204C004F004F00232O0022014F00020002000683004F004800013O0004283O004800010020C8004F00210022000654004F0049000100010004283O004900010020C8004F0021002400204C0050000B00250006CF00520001000100022O00403O004F4O00403O00214O0088005300073O00122O005400263O00122O005500276O0053005500024O005400073O00122O005500283O00122O005600296O005400566O00503O000100202O0050000B00250006CF00520002000100022O00403O00494O00403O004A4O000F015300073O00122O0054002A3O00122O0055002B6O005300556O00503O000100202O0050000B00250006CF00520003000100012O00403O00214O00CA005300073O00122O0054002C3O00122O0055002D6O005300556O00503O000100202O00500021002E00202O00500050002F00122O005200306O00500052000100202O00500021002E00204C0050005000312O000A0150000200010006CF00500004000100012O00403O000E3O00201B01510021003200202O00510051003300202O0053002100344O005400506O00510054000100202O00510021003500202O0051005100360006CF00530005000100012O00403O000E4O006F0051005300010020C800510021003700204C0051005100360006CF00530006000100012O00403O000E4O00D30051005300014O005100073O00202O00520021003200202O00530021003800202O00540021003700202O00550021003900202O00560021003A00202O00570021003500202O00580021003B4O00510007000100020D005200073O0006CF00530008000100012O00403O00213O0006CF00540009000100012O00403O00213O0006CF0055000A000100012O00403O00543O0006CF0056000B000100022O00403O00514O00403O00543O0012E90056003C3O0006CF0056000C000100032O00403O00214O00403O00474O00403O00113O00020D0057000D3O0006CF0058000E000100022O00403O00114O00403O00213O0006CF0059000F000100022O00403O001A4O00403O00213O0006CF005A0010000100032O00403O001A4O00403O000E4O00403O00213O0006CF005B0011000100022O00403O00564O00403O00213O00020D005C00123O0006CF005D0013000100012O00403O00213O0006CF005E0014000100012O00403O00213O0006CF005F0015000100052O00403O00214O00403O00554O00403O000E4O00403O004F4O00403O00403O0006CF00600016000100092O00403O000B4O00403O004A4O00403O001A4O00403O00214O00403O000E4O00403O00474O00403O004F4O00403O00424O00403O004E3O0006CF00610017000100012O00403O00213O0006CF00620018000100022O00403O00564O00403O00213O0006CF00630019000100022O00403O00214O00403O004E3O0006CF0064001A000100032O00403O000E4O00403O00214O00403O00113O0006CF0065001B000100032O00403O00214O00403O000E4O00403O00553O0006CF0066001C000100012O00403O00213O0006CF0067001D000100032O00403O00214O00403O000E4O00403O004E3O0006CF0068001E000100012O00403O00213O0006CF0069001F000100022O00403O000E4O00403O00213O0006CF006A0020000100022O00403O000E4O00403O00213O0006CF006B0021000100022O00403O000E4O00403O00213O0006CF006C0022000100012O00403O00213O0006CF006D0023000100012O00403O00213O0006CF006E0024000100082O00403O00214O00403O00194O00403O00114O00403O00074O00403O00324O00403O00334O00403O00344O00403O00353O0006CF006F00250001000C2O00403O00414O00403O004E4O00403O00424O00403O004A4O00403O00214O00403O00434O00403O004F4O00403O00444O00403O00404O00403O000E4O00403O00454O00403O00463O0006CF00700026000100052O00403O00214O00403O004E4O00403O00194O00403O00114O00403O00073O0006CF007100270001000B2O00403O00214O00403O00114O00403O000E4O00403O00194O00403O00074O00403O00704O00403O00204O00403O004D4O00403O00684O00403O003F4O00403O004E3O0006CF00720028000100152O00403O00214O00403O00194O00403O00114O00403O00074O00403O00204O00403O004D4O00403O00594O00403O00614O00403O004E4O00403O000E4O00403O00464O00403O004B4O00403O005C4O00403O00534O00403O005B4O00403O00644O00403O00694O00403O003F4O00403O005E4O00403O006D4O00403O00523O0006CF00730029000100152O00403O00214O00403O00554O00403O004E4O00403O00204O00403O004D4O00403O00074O00403O00594O00403O00114O00403O00194O00403O004C4O00403O000E4O00403O00464O00403O004B4O00403O005C4O00403O005F4O00403O005B4O00403O00654O00403O006A4O00403O003F4O00403O00524O00403O005A3O0006CF0074002A0001000D2O00403O00214O00403O00114O00403O004E4O00403O00194O00403O00074O00403O00204O00403O004B4O00403O006C4O00403O003F4O00403O000E4O00403O004F4O00403O00174O00403O005C3O0006CF0075002B000100142O00403O00214O00403O00194O00403O00114O00403O00074O00403O00474O00403O00444O00403O004E4O00403O00204O00403O004B4O00403O005C4O00403O00664O00403O000E4O00403O00744O00403O00734O00403O00544O00403O00554O00403O00404O00403O004D4O00403O00684O00403O003F3O0006CF0076002C000100112O00403O00574O00403O004D4O00403O00214O00403O001E4O00403O004A4O00403O00194O00403O00114O00403O00074O00403O00204O00403O00234O00403O000E4O00403O00224O00403O003F4O00403O00434O00403O00424O00403O00414O00403O004F3O0006CF0077002D0001001C2O00403O00334O00403O00074O00403O00344O00403O00354O00403O00364O00403O00374O00403O00384O00403O00394O00403O003A4O00403O003B4O00403O002E4O00403O002F4O00403O00304O00403O00314O00403O00324O00403O00294O00403O002A4O00403O002B4O00403O002C4O00403O002D4O00403O00244O00403O00254O00403O00264O00403O00274O00403O00284O00403O003C4O00403O003D4O00403O003E3O0006CF0078002E000100392O00403O002D4O00403O00204O00403O00214O00403O003F4O00403O002E4O00403O000E4O00403O001C4O00403O00284O00403O00194O00403O00074O00403O00114O00403O006E4O00403O003C4O00403O003E4O00403O00374O00403O00364O00403O00394O00403O00384O00403O003B4O00403O003A4O00403O00224O00403O002B4O00403O002C4O00403O00254O00403O00274O00403O00264O00403O003D4O00403O000F4O00403O006F4O00403O004A4O00403O00474O00403O004E4O00403O00744O00403O00404O00403O004F4O00403O00734O00403O00724O00403O00714O00403O000B4O00403O004B4O00403O005C4O00403O00634O00403O00754O00403O002A4O00403O001F4O00403O006B4O00403O004D4O00403O00674O00403O00584O00403O005D4O00403O001E4O00403O00764O00403O00484O00403O00494O00403O00774O00403O001D4O00403O004C3O0006CF0079002F000100032O00403O00214O00403O00154O00403O00073O002018007A0015003D00122O007B003E6O007C00786O007D00796O007A007D00016O00013O00303O00023O00026O00F03F026O00704002264O000201025O00122O000300016O00045O00122O000500013O00042O0003002100012O006A00076O001E010800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004290003000500012O006A000300054O0040000400024O0023010300044O002000036O002A3O00017O00033O00030B3O00496E6361726E6174696F6E030B3O004973417661696C61626C6503073O004265727365726B000E4O00423O00013O00206O000100206O00026O0002000200064O000A00013O0004283O000A00012O006A3O00013O0020C85O00010006543O000C000100010004283O000C00012O006A3O00013O0020C85O00032O002D8O002A3O00017O00023O00028O00024O0080B3C540000A3O0012DC3O00013O0026DE3O0001000100010004283O000100010012DC000100024O002D00015O0012DC000100024O002D000100013O0004283O000900010004283O000100012O002A3O00017O00053O00028O00030D3O004164617074697665537761726D03163O005265676973746572496E466C69676874452O66656374024O0044EB174103103O005265676973746572496E466C69676874000F3O0012DC3O00013O0026DE3O0001000100010004283O000100012O006A00015O00209B00010001000200202O00010001000300122O000300046O0001000300014O00015O00202O00010001000200202O0001000100054O00010002000100044O000E00010004283O000100012O002A3O00017O00033O0003093O00537465616C74685570029A5O99F93F026O00F03F000D4O003E7O00206O00014O000200016O000300018O0003000200064O000A00013O0004283O000A00010012DC3O00023O0006543O000B000100010004283O000B00010012DC3O00034O00A63O00024O002A3O00017O00073O0003143O00412O7461636B506F77657244616D6167654D6F640266F7E461A1D6E83F03093O00537465616C74685570029A5O99F93F026O00F03F03113O00566572736174696C697479446D67506374026O00594000174O0026016O00206O00016O0002000200206O00024O00015O00202O0001000100034O000300016O00010003000200062O0001000D00013O0004283O000D00010012DC000100043O0006540001000E000100010004283O000E00010012DC000100054O00FD5O00012O005500015O00202O0001000100064O00010002000200202O00010001000700102O0001000500018O00016O00028O00017O00033O0003143O00412O7461636B506F77657244616D6167654D6F6402B98D06F01648C03F02C1CAA145B6F3D93F000B4O007F7O00206O00016O0002000200206O00024O00015O00202O0001000100014O00010002000200202O0001000100038O00016O00024O002A3O00017O00033O00028O0003053O00706169727303113O00446562752O665265667265736861626C6502143O0012DC000200013O0026DE00020001000100010004283O00010001001259000300024O004000046O00030003000200050004283O000E000100204C0008000700032O0040000A00014O00070108000A00020006830008000E00013O0004283O000E00012O0022000800014O00A6000800023O00062501030007000100020004283O000700012O002200036O00A6000300023O0004283O000100012O002A3O00017O00053O00028O0003053O007061697273030B3O00504D756C7469706C69657203043O0052616B65026O00F03F01213O0012DC000100014O001A000200023O000E390001001C000100010004283O001C00012O001A000200023O001259000300024O004000046O00030003000200050004283O001900010012DC000800014O001A000900093O0026DE0008000B000100010004283O000B000100204C000A000700032O0025000C5O00202O000C000C00044O000A000C00024O0009000A3O00062O0002001600013O0004283O0016000100066600090019000100020004283O001900012O0040000200093O0004283O001900010004283O000B000100062501030009000100020004283O000900010012DC000100053O0026DE00010002000100050004283O000200012O00A6000200023O0004283O000200012O002A3O00017O00093O00028O00030B3O00426C2O6F6474616C6F6E73030B3O004973417661696C61626C6503113O0054696D6553696E63654C6173744361737403043O006D6174682O033O006D696E026O001440030F3O00426C2O6F6474616C6F6E7342752O66031C3O0054696D6553696E63654C617374412O706C6965644F6E506C61796572011C3O0012DC000100013O0026DE00010001000100010004283O000100012O006A00025O0020C800020002000200204C0002000200032O00220102000200020006540002000B000100010004283O000B00012O002200026O00A6000200023O00204C00023O00042O008000020002000200122O000300053O00202O00030003000600122O000400076O00055O00202O00050005000800202O0005000500094O000500066O00033O000200062O00020018000100030004283O001800012O001100026O0022000200014O00A6000200023O0004283O000100012O002A3O00019O002O0001064O00ED00018O00028O0001000200024O000100016O000100028O00017O00023O00028O00026O00F03F00193O0012DC3O00014O001A000100013O0026DE3O0014000100010004283O001400010012DC000100013O001207000200026O00038O000300033O00122O000400023O00042O0002001300012O006A000600014O006A00076O00150107000700052O00220106000200020006830006001200013O0004283O001200010020260006000100020020260001000600010004290002000A00010012DC3O00023O000E390002000200013O0004283O000200012O00A6000100023O0004283O000200012O002A3O00017O000C3O00028O00027O0040030D3O00446562752O6652656D61696E73026O000840026O00F03F2O033O00526970026O00104002345O333F4003083O005469636B54696D65030C3O00426173654475726174696F6E030B3O004D61784475726174696F6E03113O00446562752O665469636B7352656D61696E024F3O0012DC000200014O001A0003000A3O0026DE0002000D000100020004283O000D000100204C000B000100032O0024010D8O000B000D00024O0007000B6O00080003000700062O0004000C000100080004283O000C00012O0040000800043O0012DC000200043O000E390005003A000100020004283O003A00010012DC000500014O006A000B5O0020C8000B000B00060006A93O00240001000B0004283O002400010012DC000B00013O0026DE000B001C000100010004283O001C00012O006A000C00013O002098000C000C000700108200030007000C0012DC000400083O0012DC000B00053O0026DE000B0015000100050004283O0015000100204C000C3O00092O0022010C000200022O00400005000C3O0004283O003500010004283O001500010004283O003500010012DC000B00013O0026DE000B002B000100050004283O002B000100204C000C3O00092O0022010C000200022O00400005000C3O0004283O003500010026DE000B0025000100010004283O0025000100204C000C3O000A2O0048000C000200024O0003000C3O00202O000C3O000B4O000C000200024O0004000C3O00122O000B00053O00044O0025000100204C000B0001000C2O0040000D6O0007010B000D00022O00400006000B3O0012DC000200023O0026DE00020042000100010004283O004200010006540001003F000100010004283O003F00012O006A000100023O0012DC000300013O0012DC000400013O0012DC000200053O0026DE0002004A000100040004283O004A00012O002E00090008000500065400060048000100010004283O004800010012DC000600014O0074000A000900060012DC000200073O0026DE00020002000100070004283O000200012O00A6000A00023O0004283O000200012O002A3O00017O00053O00028O00026O00F03F03053O00706169727303093O0054696D65546F446965027O0040012D3O0012DC000100014O001A000200033O0026DE0001001E000100020004283O001E00012O001A000300033O001259000400034O004000056O00030004000200060004283O001B00010012DC000900014O001A000A000A3O0026DE0009000B000100010004283O000B000100204C000B000800042O0022010B000200022O0040000A000B3O0006660002001B0001000A0004283O001B00010012DC000B00013O0026DE000B0013000100010004283O001300012O00400002000A4O0040000300083O0004283O001B00010004283O001300010004283O001B00010004283O000B000100062501040009000100020004283O000900010012DC000100053O0026DE00010023000100050004283O002300012O0040000400024O0040000500034O0044000400033O0026DE00010002000100010004283O000200010006543O0029000100010004283O002900010012DC000400014O00A6000400023O0012DC000200013O0012DC000100023O0004283O000200012O002A3O00017O00053O00030B3O00446562752O66537461636B03133O004164617074697665537761726D446562752O66026O00F03F03093O0054696D65546F446965026O00084001154O004F00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200102O0001000300014O00025O00202O0002000200014O000400013O00202O0004000400024O0002000400024O00010001000200202O00023O00044O00020002000200102O00020005000200062O00010012000100020004283O001200012O001100016O0022000100014O00A6000100024O002A3O00017O00043O0003113O00446562752O665265667265736861626C6503103O004C494D2O6F6E66697265446562752O66026O00084003083O00446562752O66557001104O00D000015O00202O00023O00014O000400013O00202O0004000400024O000200046O00013O000200102O0001000300014O00025O00202O00033O00044O000500013O00202O0005000500024O000300056O00023O00024O0001000100024O000100028O00017O00053O00030B3O00504D756C7469706C69657203043O0052616B65026O003940030D3O00446562752O6652656D61696E73030A3O0052616B65446562752O6601174O000A00018O000200013O00202O0002000200014O000400023O00202O0004000400024O00020004000200202O00033O00014O000500023O00202O0005000500024O00030005000200062O0002000D000100030004283O000D00012O001100026O0022000200014O000500010002000200102O00010003000100202O00023O00044O000400023O00202O0004000400054O0002000400024O0001000100024O000100028O00017O00013O00030A3O0052616B65446562752O6601074O004100018O000200013O00202O0002000200014O00038O0001000300024O000100028O00017O00013O0003093O0054696D65546F44696501043O00204C00013O00012O00222O01000200022O00A6000100024O002A3O00017O00033O00030B3O00446562752O66537461636B03133O004164617074697665537761726D446562752O66026O000840010A3O002O202O013O00014O00035O00202O0003000300024O00010003000200262O00010007000100030004283O000700012O001100016O0022000100014O00A6000100024O002A3O00017O00053O00030B3O0042727574616C536C61736803103O0046752O6C526563686172676554696D65026O00104003093O0054696D65546F446965026O001440010E4O00F400015O00202O00010001000100202O0001000100024O00010002000200262O0001000B000100030004283O000B000100204C00013O00042O00222O01000200020026E50001000B000100050004283O000B00012O001100016O0022000100014O00A6000100024O002A3O00017O00063O00030B3O0042727574616C536C61736803103O0046752O6C526563686172676554696D65026O00104003093O0054696D65546F446965026O00144003063O0042752O665570011C4O00F400015O00202O00010001000100202O0001000100024O00010002000200262O0001000A000100030004283O000A000100204C00013O00042O00222O01000200020026032O010018000100050004283O001800012O006A000100014O006A00025O0020C80002000200012O00222O01000200020006830001001A00013O0004283O001A00012O006A000100023O00204C0001000100062O006A000300034O00072O01000300020006540001001A000100010004283O001A00012O006A000100043O0004283O001A00012O001100016O0022000100014O00A6000100024O002A3O00017O00123O00028O00030A3O00436F6D62617454696D6503093O0054696D65546F44696503113O00417368616D616E657347756964616E6365030B3O004973417661696C61626C65026O001440030D3O00446562752O6652656D61696E7303093O00526970446562752O6603063O0042752O665570030A3O0054696765727346757279027O0040026O000840026O002440025O00C07240030C3O00446972654669786174696F6E03083O00446562752O66557003123O00446972654669786174696F6E446562752O66026O00F03F015D3O0012DC000100014O001A000200023O0026DE00010002000100010004283O000200012O006A00035O0020760003000300024O0003000100024O000200033O00202O00033O00034O0003000200024O000400013O00062O00030018000100040004283O0018000100204C00033O00032O002B0003000200024O000400026O000500033O00202O00050005000400202O0005000500054O000500066O00043O000200102O00040006000400062O0004001D000100030004283O001D000100204C00033O00032O00220103000200022O006A000400013O0006A900030058000100040004283O005800012O006A000300013O0026E500030039000100060004283O0039000100204C00033O00072O006A000500033O0020C80005000500082O0007010300050002000E0B00060058000100030004283O005800012O006A000300043O0020020003000300094O000500033O00202O00050005000A4O00030005000200062O0003005A00013O0004283O005A00012O006A000300053O0026E5000300390001000B0004283O003900012O006A000300043O00204C0003000300092O006A000500064O00070103000500020006830003005A00013O0004283O005A00012O006A000300053O0026CB000300580001000C0004283O005800012O006A000300073O0006830003004300013O0004283O004300012O006A000300014O008900030002000300202O00030003000D00202O00030003000E00202O00040002000E00062O00040058000100030004283O005800012O006A000300033O0020C800030003000F00204C0003000300052O00220103000200020006830003004F00013O0004283O004F000100204C00033O00102O006A000500033O0020C80005000500112O00070103000500020006540003005A000100010004283O005A00012O006A000300033O0020C800030003000F00204C0003000300052O00220103000200020006830003005900013O0004283O005900012O006A000300083O000E7500120059000100030004283O005900012O001100036O0022000300014O00A6000300023O0004283O000200012O002A3O00017O00023O0003113O00446562752O665265667265736861626C6503103O004C494D2O6F6E66697265446562752O6601063O00200100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00013O0003103O004C494D2O6F6E66697265446562752O6601074O004100018O000200013O00202O0002000200014O00038O0001000300024O000100028O00017O00053O00030C3O00446972654669786174696F6E030B3O004973417661696C61626C6503083O00446562752O66557003123O00446972654669786174696F6E446562752O66026O00F03F01194O004200015O00202O00010001000100202O0001000100024O00010002000200062O0001000C00013O0004283O000C000100204C00013O00032O006A00035O0020C80003000300042O00072O010003000200065400010017000100010004283O001700012O006A00015O0020C800010001000100204C0001000100022O00222O01000200020006830001001600013O0004283O001600012O006A000100013O000E7500050016000100010004283O001600012O001100016O0022000100014O00A6000100024O002A3O00017O00023O00030B3O00504D756C7469706C69657203043O0052616B6501104O00B600015O00202O0001000100014O000300013O00202O0003000300024O0001000300024O000200023O00202O0002000200014O000400013O00202O0004000400024O00020004000200062O0002000D000100010004283O000D00012O001100016O0022000100014O00A6000100024O002A3O00017O00063O0003113O00446562752O665265667265736861626C65030A3O0052616B65446562752O6603063O0042752O66557003103O0053752O64656E416D6275736842752O66030B3O00504D756C7469706C69657203043O0052616B6501213O00204D00013O00014O00035O00202O0003000300024O00010003000200062O00010018000100010004283O001800012O006A000100013O0020020001000100034O00035O00202O0003000300044O00010003000200062O0001001F00013O0004283O001F00012O006A000100013O00206C0001000100054O00035O00202O0003000300064O00010003000200202O00023O00054O00045O00202O0004000400064O00020004000200062O0002001D000100010004283O001D00012O006A000100024O006A00025O0020C80002000200062O00222O01000200020004283O001F00012O001100016O0022000100014O00A6000100024O002A3O00017O00033O00030D3O00446562752O6652656D61696E732O033O00526970026O001440010A3O0020122O013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004283O000700012O001100016O0022000100014O00A6000100024O002A3O00017O000F3O00030A3O00446562752O66446F776E03133O004164617074697665537761726D446562752O66030D3O00446562752O6652656D61696E73027O0040030B3O00446562752O66537461636B026O00084003093O0042752O66537461636B03113O004164617074697665537761726D4865616C026O00F03F030D3O004164617074697665537761726D03083O00496E466C6967687403093O0054696D65546F446965026O00144003063O00456E65726779025O0080414001393O00204D00013O00014O00035O00202O0003000300024O00010003000200062O0001000C000100010004283O000C000100204C00013O00032O006A00035O0020C80003000300022O00072O01000300020026032O010023000100040004283O0023000100204C00013O00052O006A00035O0020C80003000300022O00072O01000300020026E500010019000100060004283O001900012O006A000100013O00201C2O01000100074O00035O00202O0003000300084O00010003000200262O00010023000100090004283O002300012O006A00015O0020C800010001000A00204C00010001000B2O00222O010002000200065400010023000100010004283O0023000100204C00013O000C2O00222O0100020002000E75000D0036000100010004283O003600012O006A000100023O000E0B00040035000100010004283O0035000100204C00013O00012O006A00035O0020C80003000300022O00072O01000300020006830001003700013O0004283O003700012O006A000100013O00204C00010001000E2O00222O01000200020026032O0100350001000F0004283O0035000100204C00013O000C2O00222O0100020002000E75000D0036000100010004283O003600012O001100016O0022000100014O00A6000100024O002A3O00017O00023O0003113O00446562752O665265667265736861626C6503103O004C494D2O6F6E66697265446562752O6601063O00200100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00063O0003063O0042752O66557003103O0053752O64656E416D6275736842752O66030B3O00504D756C7469706C69657203043O0052616B6503113O00446562752O665265667265736861626C65030A3O0052616B65446562752O66011B4O004E00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001001200013O0004283O001200012O006A00015O00200D2O01000100034O000300013O00202O0003000300044O00010003000200202O00023O00034O000400013O00202O0004000400044O00020004000200062O00020018000100010004283O0018000100204C00013O00052O006A000300013O0020C80003000300062O00072O01000300020004283O001900012O001100016O0022000100014O00A6000100024O002A3O00017O00043O0003063O0042752O66557003103O0053752O64656E416D6275736842752O66030B3O00504D756C7469706C69657203043O0052616B6501164O004E00015O00202O0001000100014O000300013O00202O0003000300024O00010003000200062O0001001400013O0004283O001400012O006A00015O00200D2O01000100034O000300013O00202O0003000300044O00010003000200202O00023O00034O000400013O00202O0004000400044O00020004000200062O00020013000100010004283O001300012O001100016O0022000100014O00A6000100024O002A3O00017O00023O00030B3O00504D756C7469706C69657203043O0052616B65010F4O006A00015O00200D2O01000100014O000300013O00202O0003000300024O00010003000200202O00023O00014O000400013O00202O0004000400024O00020004000200062O0002000C000100010004283O000C00012O001100016O0022000100014O00A6000100024O002A3O00017O00023O0003113O00446562752O665265667265736861626C652O033O0052697001063O00200100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00023O0003113O00446562752O665265667265736861626C65030C3O00546872617368446562752O6601063O00200100013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O001E3O00028O00027O004003043O0052616B6503073O0049735265616479030E3O004973496E4D656C2O6552616E6765026O00204003103O00CD1EFF197ACF0DF11F35D21DF5087A8703053O005ABF7F947C03073O00436174466F726D030A3O0049734361737461626C6503143O007B863A287E883C1A38973C127B88231579936E4503043O007718E74E030E3O0048656172744F6654686557696C64031D3O008A28A458C87F1E8412B142D97F068B21A10ACC52148122A848DD5451D603073O0071E24DC52ABC20026O00F03F03053O0050726F776C03063O001B1AE3B4230503043O00D55A769403113O004B3CBB2O411B3EA6534E5423B657591B7A03053O002D3B4ED43603083O00345F909F8720AEF503083O00907036E3EBE64ECD03093O004973496E52616E676503113O00A33A00EBDC1BA33A0AFFDF56B1291BBC8403063O003BD3486F9CB0030A3O0057696C64436861726765026O003C4003173O00598EEF297184EB2C5C80E66D5E95E62E418AE12C5AC7B503043O004D2EE783009D3O0012DC3O00013O0026DE3O001A000100020004283O001A00012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001009C00013O0004283O009C00012O006A000100014O00FC00025O00202O0002000200034O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O0001009C00013O0004283O009C00012O006A000100033O001278000200073O00122O000300086O000100036O00015O00044O009C00010026DE3O0042000100010004283O004200012O006A00015O0020C800010001000900204C00010001000A2O00222O01000200020006830001003000013O0004283O003000012O006A000100043O0006830001003000013O0004283O003000012O006A000100014O006A00025O0020C80002000200092O00222O01000200020006830001003000013O0004283O003000012O006A000100033O0012DC0002000B3O0012DC0003000C4O00232O0100034O002000016O006A00015O0020C800010001000D00204C00010001000A2O00222O01000200020006830001004100013O0004283O004100012O006A000100014O006A00025O0020C800020002000D2O00222O01000200020006830001004100013O0004283O004100012O006A000100033O0012DC0002000E3O0012DC0003000F4O00232O0100034O002000015O0012DC3O00103O0026DE3O0001000100100004283O000100012O006A00015O0020C800010001001100204C00010001000A2O00222O01000200020006830001005D00013O0004283O005D00012O006A000100054O00D4000200033O00122O000300123O00122O000400136O00020004000200062O0001005D000100020004283O005D00012O006A000100014O006A00025O0020C80002000200112O00222O01000200020006830001007B00013O0004283O007B00012O006A000100033O001278000200143O00122O000300156O000100036O00015O00044O007B00012O006A00015O0020C800010001001100204C00010001000A2O00222O01000200020006830001007B00013O0004283O007B00012O006A000100054O00D4000200033O00122O000300163O00122O000400176O00020004000200062O0001007B000100020004283O007B00012O006A000100023O00204C0001000100182O006A000300064O00072O01000300020006830001007B00013O0004283O007B00012O006A000100014O006A00025O0020C80002000200112O00222O01000200020006830001007B00013O0004283O007B00012O006A000100033O0012DC000200193O0012DC0003001A4O00232O0100034O002000016O006A000100073O0006830001009A00013O0004283O009A00012O006A00015O0020C800010001001B00204C00010001000A2O00222O01000200020006830001009A00013O0004283O009A00012O006A000100023O00204C0001000100180012DC000300064O00072O01000300020006540001009A000100010004283O009A00012O006A000100014O00FC00025O00202O00020002001B4O000300023O00202O00030003001800122O0005001C6O0003000500024O000300036O00010003000200062O0001009A00013O0004283O009A00012O006A000100033O0012DC0002001D3O0012DC0003001E4O00232O0100034O002000015O0012DC3O00023O0004283O000100012O002A3O00017O00153O00028O00026O00F03F03113O00436F6E766F6B6554686553706972697473030F3O00432O6F6C646F776E52656D61696E73026O00084003113O00417368616D616E657347756964616E6365030B3O004973417661696C61626C65026O004E40026O002840027O0040029A5O99F93F026O003E4003153O004265727365726B48656172746F667468654C696F6E02985O99F93F025O00805640025O00806640030B3O00426C2O6F6474616C6F6E7303093O0042752O66537461636B030F3O00426C2O6F6474616C6F6E7342752O6603093O004973496E506172747903083O004973496E5261696400843O0012DC3O00014O001A000100013O0026DE3O0034000100020004283O003400012O006A000200013O0026DE00020009000100020004283O000900012O0034000200013O0004283O000B00012O001100026O0022000200014O002D00026O0065000200036O000300043O00202O00030003000300202O0003000300044O00030002000200202O00030003000500062O00030030000100020004283O003000012O006A000200043O0020C800020002000600204C0002000200072O00220102000200020006830002002200013O0004283O002200012O006A000200034O0021010300043O00202O00030003000300202O0003000300044O00030002000200202O00030003000800062O00020031000100030004283O003100012O006A000200043O0020C800020002000600204C0002000200072O002201020002000200065400020030000100010004283O003000012O006A000200034O0021010300043O00202O00030003000300202O0003000300044O00030002000200202O00030003000900062O00020031000100030004283O003100012O001100026O0022000200014O002D000200023O0012DC3O000A3O0026DE3O005F0001000A0004283O005F00012O006A000200034O008D000300063O00202O0003000300044O00030002000200202O00030003000B00102O0003000C000300062O00030059000100020004283O005900012O006A000200043O0020C800020002000D00204C0002000200072O00220102000200020006830002004C00013O0004283O004C00012O006A000200034O0019000300063O00202O0003000300044O00030002000200202O00030003000E00102O0003000F000300062O0002005A000100030004283O005A00012O006A000200043O0020C800020002000D00204C0002000200072O002201020002000200065400020059000100010004283O005900012O006A000200034O00EB000300063O00202O0003000300044O00030002000200102O00030010000300062O0002005A000100030004283O005A00012O001100026O0022000200014O002D000200054O0022000200014O002D000200073O0012DC3O00053O0026DE3O007B000100010004283O007B00012O006A000200043O0020C800020002001100204C0002000200072O00220102000200020006830002007000013O0004283O007000012O006A000200093O0020930002000200124O000400043O00202O0004000400134O00020004000200262O0002006F000100020004283O006F00012O001100026O0022000200014O002D000200084O006A000200093O00204C0002000200142O002201020002000200061C0001007A000100020004283O007A00012O006A000200093O00204C0002000200152O00220102000200022O0034000100023O0012DC3O00023O0026DE3O0002000100050004283O000200012O0022000200014O002D0002000A4O0022000200014O002D0002000B3O0004283O008300010004283O000200012O002A3O00017O00173O00028O00026O00F03F030B3O0042727574616C536C61736803073O0049735265616479027O0040030E3O004973496E4D656C2O6552616E6765026O002040031B3O00B846A354BB588953B655A548FA57BA45BB46B541A940BF4EBD14E003043O0020DA34D603053O00536872656403143O005D1F23ADF5F046564B1623ABF0A35153401071F003083O003A2E7751C891D02503063O0054687261736803113O00446562752O665265667265736861626C65030C3O00546872617368446562752O66030E3O00546872617368696E67436C617773030B3O004973417661696C61626C65026O00264003153O003F8422ADBAB576288035ADBBBE37389839A2AEFD6403073O00564BEC50CCC9DD03053O00537769706503143O0061567E95FBCB714D7284EC887352638CF08C321503063O00EB122117E59E00743O0012DC3O00013O000E390002003300013O0004283O003300012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001001C00013O0004283O001C00012O006A000100013O000E0B0005001C000100010004283O001C00012O006A000100024O00FC00025O00202O0002000200034O000300033O00202O00030003000600122O000500076O0003000500024O000300036O00010003000200062O0001001C00013O0004283O001C00012O006A000100043O0012DC000200083O0012DC000300094O00232O0100034O002000016O006A00015O0020C800010001000A00204C0001000100042O00222O01000200020006830001007300013O0004283O007300012O006A000100024O00FC00025O00202O00020002000A4O000300033O00202O00030003000600122O000500076O0003000500024O000300036O00010003000200062O0001007300013O0004283O007300012O006A000100043O0012780002000B3O00122O0003000C6O000100036O00015O00044O007300010026DE3O0001000100010004283O000100012O006A00015O0020C800010001000D00204C0001000100042O00222O01000200020006830001005800013O0004283O005800012O006A000100033O00200200010001000E4O00035O00202O00030003000F4O00010003000200062O0001005800013O0004283O005800012O006A00015O0020C800010001001000204C0001000100112O00222O010002000200065400010058000100010004283O005800012O006A000100024O00FC00025O00202O00020002000D4O000300033O00202O00030003000600122O000500126O0003000500024O000300036O00010003000200062O0001005800013O0004283O005800012O006A000100043O0012DC000200133O0012DC000300144O00232O0100034O002000016O006A00015O0020C800010001001500204C0001000100042O00222O01000200020006830001007100013O0004283O007100012O006A000100013O000E0B00020071000100010004283O007100012O006A000100024O00FC00025O00202O0002000200154O000300033O00202O00030003000600122O000500126O0003000500024O000300036O00010003000200062O0001007100013O0004283O007100012O006A000100043O0012DC000200163O0012DC000300174O00232O0100034O002000015O0012DC3O00023O0004283O000100012O002A3O00017O003B3O00028O00026O00F03F03043O0052616B6503073O004973526561647903113O00446562752O665265667265736861626C65030A3O0052616B65446562752O6603063O0042752O66557003103O0053752O64656E416D6275736842752O66030B3O00504D756C7469706C696572030E3O004973496E4D656C2O6552616E6765026O002040030E3O0042BBCABE10B8D4B25CBEC4A910EC03043O00DB30DAA1030C3O00436C65617263617374696E6703043O00502O6F6C03153O00D47E73459B49EFF6315F45DE4EF2E7706F5DD241E703073O008084111C29BB2F030A3O004C494D2O6F6E6669726503093O00436173744379636C65030E3O0049735370652O6C496E52616E676503113O004D2O6F6E666972654D6F7573656F76657203163O000C3D09345B082003055E0026463848083E023F4F416A03053O003D6152665A03063O00546872617368030A3O0049734361737461626C65030C3O00546872617368446562752O66030E3O00546872617368696E67436C617773030B3O004973417661696C61626C65026O00264003113O00B826B94AD45F5E0BB927A74FC2455E58FC03083O0069CC4ECB2BA7377E027O004003153O0095A52C125302C843E5892F1B1216C450B6BE2A101403083O0031C5CA437E7364A7030B3O0042727574616C536C61736803103O0046752O6C526563686172676554696D65026O00104003163O003549CA3D815A612457DE3A88165C2252D32D85441E6503073O003E573BBF49E036030D3O00446562752O6652656D61696E73026O00184003083O0042752O66446F776E031A3O00D70DF5C5A704F5DBA730FBC2E242F3C7A720EFC0EB06FFDBAF4B03043O00A987629A030A3O00536861646F776D656C64026O66F63F03053O0050726F776C03183O00417065785072656461746F727343726176696E6742752O6603143O00D87F2550F224C5CE7B2014FF26C1C7732146BD6703073O00A8AB1744349D5303173O00F663E0B92421B8E77DF4BE2D6D85E178F9A9203FC7A52303073O00E7941195CD454D03053O005377697065030B3O0057696C64536C617368657303103O0093B0CEEB52BF82B2CEF753FA92E796AF03063O009FE0C7A79B3703053O00536872656403103O00E4FB2ED7F3B33EC7FEFF38D7E5B36D8403043O00B297935C0098012O0012DC3O00013O0026DE3O0095000100020004283O009500012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001003300013O0004283O003300012O006A000100013O00204D0001000100054O00035O00202O0003000300064O00010003000200062O00010023000100010004283O002300012O006A000100023O0020020001000100074O00035O00202O0003000300084O00010003000200062O0001003300013O0004283O003300012O006A000100023O0020A00001000100094O00035O00202O0003000300034O0001000300024O000200013O00202O0002000200094O00045O00202O0004000400034O00020004000200062O00020033000100010004283O003300012O006A000100034O00FC00025O00202O0002000200034O000300013O00202O00030003000A00122O0005000B6O0003000500024O000300036O00010003000200062O0001003300013O0004283O003300012O006A000100043O0012DC0002000C3O0012DC0003000D4O00232O0100034O002000016O006A000100023O0020020001000100074O00035O00202O00030003000E4O00010003000200062O0001005400013O0004283O005400010012DC000100014O001A000200023O0026DE0001004A000100020004283O004A00012O006A000300034O006A00045O0020C800040004000F2O00220103000200020006830003005400013O0004283O005400012O006A000300043O001278000400103O00122O000500116O000300056O00035O00044O005400010026DE0001003C000100010004283O003C00012O006A000300054O000B0103000100022O0040000200033O0006830002005200013O0004283O005200012O00A6000200023O0012DC000100023O0004283O003C00012O006A00015O0020C800010001001200204C0001000100042O00222O01000200020006830001007100013O0004283O007100012O006A000100063O00201D0001000100134O00025O00202O0002000200124O000300076O000400086O000500013O00202O0005000500144O00075O00202O0007000700124O0005000700024O000500056O000600076O000800093O00202O0008000800154O00010008000200062O0001007100013O0004283O007100012O006A000100043O0012DC000200163O0012DC000300174O00232O0100034O002000016O006A00015O0020C800010001001800204C0001000100192O00222O01000200020006830001009400013O0004283O009400012O006A000100013O0020020001000100054O00035O00202O00030003001A4O00010003000200062O0001009400013O0004283O009400012O006A00015O0020C800010001001B00204C00010001001C2O00222O010002000200065400010094000100010004283O009400012O006A000100034O00FC00025O00202O0002000200184O000300013O00202O00030003000A00122O0005001D6O0003000500024O000300036O00010003000200062O0001009400013O0004283O009400012O006A000100043O0012DC0002001E3O0012DC0003001F4O00232O0100034O002000015O0012DC3O00203O000E39000100482O013O0004283O00482O012O006A000100023O0020020001000100074O00035O00202O00030003000E4O00010003000200062O000100B800013O0004283O00B800010012DC000100014O001A000200023O0026DE000100A9000100010004283O00A900012O006A000300054O000B0103000100022O0040000200033O000683000200A800013O0004283O00A800012O00A6000200023O0012DC000100023O0026DE000100A0000100020004283O00A000012O006A000300034O006A00045O0020C800040004000F2O0022010300020002000683000300B800013O0004283O00B800012O006A000300043O001278000400213O00122O000500226O000300056O00035O00044O00B800010004283O00A000012O006A00015O0020C800010001002300204C0001000100042O00222O0100020002000683000100D400013O0004283O00D400012O006A00015O0020C800010001002300204C0001000100242O00222O01000200020026032O0100D4000100250004283O00D400012O006A000100034O00FC00025O00202O0002000200234O000300013O00202O00030003000A00122O0005001D6O0003000500024O000300036O00010003000200062O000100D400013O0004283O00D400012O006A000100043O0012DC000200263O0012DC000300274O00232O0100034O002000016O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006540001000D2O0100010004283O000D2O012O006A000100013O00204D0001000100054O00035O00202O0003000300064O00010003000200062O000100FB000100010004283O00FB00012O006A000100023O0020020001000100074O00035O00202O0003000300084O00010003000200062O0001000D2O013O0004283O000D2O012O006A000100023O0020A00001000100094O00035O00202O0003000300034O0001000300024O000200013O00202O0002000200094O00045O00202O0004000400034O00020004000200062O0002000D2O0100010004283O000D2O012O006A000100013O0020F30001000100284O00035O00202O0003000300064O000100030002000E2O0029000D2O0100010004283O000D2O012O006A000100023O00200200010001002A4O00035O00202O00030003000E4O00010003000200062O0001000D2O013O0004283O000D2O012O006A000100034O006A00025O0020C800020002000F2O00222O01000200020006830001000D2O013O0004283O000D2O012O006A000100043O0012DC0002002B3O0012DC0003002C4O00232O0100034O002000016O006A00015O0020C800010001002D00204C0001000100192O00222O0100020002000683000100472O013O0004283O00472O012O006A00015O0020C800010001000300204C0001000100042O00222O0100020002000683000100472O013O0004283O00472O012O006A000100023O00200200010001002A4O00035O00202O0003000300084O00010003000200062O000100472O013O0004283O00472O012O006A000100013O00204D0001000100054O00035O00202O0003000300064O00010003000200062O0001002E2O0100010004283O002E2O012O006A000100013O00207E0001000100094O00035O00202O0003000300034O00010003000200262O000100472O01002E0004283O00472O012O006A000100023O00200200010001002A4O00035O00202O00030003002F4O00010003000200062O000100472O013O0004283O00472O012O006A000100023O00200200010001002A4O00035O00202O0003000300304O00010003000200062O000100472O013O0004283O00472O012O006A000100034O006A00025O0020C800020002002D2O00222O0100020002000683000100472O013O0004283O00472O012O006A000100043O0012DC000200313O0012DC000300324O00232O0100034O002000015O0012DC3O00023O0026DE3O0001000100200004283O000100012O006A00015O0020C800010001002300204C0001000100042O00222O0100020002000683000100602O013O0004283O00602O012O006A000100034O00FC00025O00202O0002000200234O000300013O00202O00030003000A00122O0005001D6O0003000500024O000300036O00010003000200062O000100602O013O0004283O00602O012O006A000100043O0012DC000200333O0012DC000300344O00232O0100034O002000016O006A00015O0020C800010001003500204C0001000100042O00222O01000200020006830001007F2O013O0004283O007F2O012O006A0001000A3O000E750002006F2O0100010004283O006F2O012O006A00015O0020C800010001003600204C00010001001C2O00222O01000200020006830001007F2O013O0004283O007F2O012O006A000100034O00FC00025O00202O0002000200354O000300013O00202O00030003000A00122O0005001D6O0003000500024O000300036O00010003000200062O0001007F2O013O0004283O007F2O012O006A000100043O0012DC000200373O0012DC000300384O00232O0100034O002000016O006A00015O0020C800010001003900204C0001000100042O00222O0100020002000683000100972O013O0004283O00972O012O006A000100034O00FC00025O00202O0002000200394O000300013O00202O00030003000A00122O0005000B6O0003000500024O000300036O00010003000200062O000100972O013O0004283O00972O012O006A000100043O0012780002003A3O00122O0003003B6O000100036O00015O00044O00972O010004283O000100012O002A3O00017O00493O00028O00026O00104003063O0054687261736803073O0049735265616479030E3O004973496E4D656C2O6552616E6765026O00264003153O0098F55E3301443A8DF2490D10597380F94920521E2C03073O001AEC9D2C52722C026O00084003053O00537769706503143O002O39DC4B2F6ED4542F11D74E2322D15E386E870B03043O003B4A4EB5030A3O004C494D2O6F6E66697265030C3O004361737454617267657449662O033O0028D04203053O00D345B12O3A030E3O0049735370652O6C496E52616E6765031C3O00BAEA76FBEFC2A5E046F6E8DFF7E476F0D6C9A2EC75F1ECD9A4A52BA703063O00ABD78519958903053O005368726564030C3O00446972654669786174696F6E030B3O004973417661696C61626C6503083O0042752O66446F776E03103O0053752O64656E416D6275736842752O66030B3O0057696C64536C61736865732O033O00ECC92A03083O002281A8529A8F509C026O00204003143O0096BA210E4C0E888AB70C095D478581B7214B2O1A03073O00E9E5D2536B282E026O00F03F030A3O00536861646F776D656C6403043O0052616B6502005O66F63F03053O0050726F776C03183O00417065785072656461746F727343726176696E6742752O6603183O00D24A33D20AD64F37DA0181433DD33AC3573BDA01C450728E03053O0065A12252B603063O0042752O6655702O033O00E50C4103083O004E886D399EBB82E203133O002C3EF2F47E3EF6F4013DECF8323BFCE37E6EA903043O00915E5F9903093O00436173744379636C65030D3O0052616B654D6F7573656F76657203133O00EFCC1FD00EB6F2C82BD75BBEF1C911C70EE6AF03063O00D79DAD74B52E027O004003113O00446562752O665265667265736861626C65030C3O00546872617368446562752O6603153O0021BC99F3C93DF48AFDDF0AB69EFBD631B199B28B6103053O00BA55D4EB92030B3O0042727574616C536C617368031B3O00C09303EA38E267D18D17ED31AE59CD8429FC2CE754C68404BE68B803073O0038A2E1769E598E026O0014402O033O005104D803063O00B83C65A0CF42031C3O003C8D73B2378B6EB90E817DA8718373B90E8069B53D8679AE22C22DE403043O00DC51E21C2O033O001EDC8C03063O00A773B5E29B8A031A3O00E030F2487A7DF9F12EE64F7331C7ED27D85E6E78CAE627F51C2903073O00A68242873C1B11030C3O00436C65617263617374696E67026O00244003103O00446F75626C65436C6177656452616B65030E3O00546872617368696E67436C61777303143O005042DC74234C0ACF7A357B48DB7C3C404FDC356403053O0050242AAE15030A3O0052616B65446562752O6603183O005D18367E41073A7F4214777B411508785B193B7E4B02772C03043O001A2E705700E3012O0012DC3O00013O0026DE3O001A000100020004283O001A00012O006A00015O0020C800010001000300204C0001000100042O00222O0100020002000683000100E22O013O0004283O00E22O012O006A000100014O00FC00025O00202O0002000200034O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O000100E22O013O0004283O00E22O012O006A000100033O001278000200073O00122O000300086O000100036O00015O00044O00E22O010026DE3O0089000100090004283O008900012O006A00015O0020C800010001000A00204C0001000100042O00222O01000200020006830001003200013O0004283O003200012O006A000100014O00FC00025O00202O00020002000A4O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O0001003200013O0004283O003200012O006A000100033O0012DC0002000B3O0012DC0003000C4O00232O0100034O002000016O006A00015O0020C800010001000D00204C0001000100042O00222O01000200020006830001005100013O0004283O005100012O006A000100043O0020F700010001000E4O00025O00202O00020002000D4O000300056O000400033O00122O0005000F3O00122O000600106O0004000600024O000500066O000600076O000700023O00202O0007000700114O00095O00202O00090009000D4O0007000900024O000700076O00010007000200062O0001005100013O0004283O005100012O006A000100033O0012DC000200123O0012DC000300134O00232O0100034O002000016O006A00015O0020C800010001001400204C0001000100042O00222O01000200020006830001008800013O0004283O008800012O006A000100083O0026E500010060000100020004283O006000012O006A00015O0020C800010001001500204C0001000100162O00222O01000200020006830001008800013O0004283O008800012O006A000100093O0020020001000100174O00035O00202O0003000300184O00010003000200062O0001008800013O0004283O008800012O006A0001000A3O0006830001007000013O0004283O007000012O006A00015O0020C800010001001900204C0001000100162O00222O010002000200065400010088000100010004283O008800012O006A000100043O0020AB00010001000E4O00025O00202O0002000200144O0003000B6O000400033O00122O0005001A3O00122O0006001B6O0004000600024O0005000C6O000600066O000700023O00202O00070007000500122O0009001C6O0007000900024O000700076O00010007000200062O0001008800013O0004283O008800012O006A000100033O0012DC0002001D3O0012DC0003001E4O00232O0100034O002000015O0012DC3O00023O0026DE3O00FE0001001F0004283O00FE00012O006A00015O0020C800010001002000204C0001000100042O00222O0100020002000683000100BC00013O0004283O00BC00012O006A00015O0020C800010001002100204C0001000100042O00222O0100020002000683000100BC00013O0004283O00BC00012O006A000100093O0020020001000100174O00035O00202O0003000300184O00010003000200062O000100BC00013O0004283O00BC00012O006A0001000D4O006A000200054O00222O01000200020026032O0100BC000100220004283O00BC00012O006A000100093O0020020001000100174O00035O00202O0003000300234O00010003000200062O000100BC00013O0004283O00BC00012O006A000100093O0020020001000100174O00035O00202O0003000300244O00010003000200062O000100BC00013O0004283O00BC00012O006A000100014O006A00025O0020C80002000200202O00222O0100020002000683000100BC00013O0004283O00BC00012O006A000100033O0012DC000200253O0012DC000300264O00232O0100034O002000016O006A00015O0020C800010001002100204C0001000100042O00222O0100020002000683000100E100013O0004283O00E100012O006A000100093O0020020001000100274O00035O00202O0003000300184O00010003000200062O000100E100013O0004283O00E100012O006A000100043O0020C200010001000E4O00025O00202O0002000200214O0003000B6O000400033O00122O000500283O00122O000600296O0004000600024O0005000E6O0006000F6O000700023O00202O00070007000500122O0009001C6O0007000900024O000700076O00010007000200062O000100E100013O0004283O00E100012O006A000100033O0012DC0002002A3O0012DC0003002B4O00232O0100034O002000016O006A00015O0020C800010001002100204C0001000100042O00222O0100020002000683000100FD00013O0004283O00FD00012O006A000100043O00203C00010001002C4O00025O00202O0002000200214O0003000B6O000400106O000500023O00202O00050005000500122O0007001C6O0005000700024O000500056O000600076O000800113O00202O00080008002D4O00010008000200062O000100FD00013O0004283O00FD00012O006A000100033O0012DC0002002E3O0012DC0003002F4O00232O0100034O002000015O0012DC3O00303O0026DE3O00562O0100300004283O00562O012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001001D2O013O0004283O001D2O012O006A000100023O0020020001000100314O00035O00202O0003000300324O00010003000200062O0001001D2O013O0004283O001D2O012O006A000100014O00FC00025O00202O0002000200034O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O0001001D2O013O0004283O001D2O012O006A000100033O0012DC000200333O0012DC000300344O00232O0100034O002000016O006A00015O0020C800010001003500204C0001000100042O00222O0100020002000683000100332O013O0004283O00332O012O006A000100014O00FC00025O00202O0002000200354O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O000100332O013O0004283O00332O012O006A000100033O0012DC000200363O0012DC000300374O00232O0100034O002000016O006A00015O0020C800010001000D00204C0001000100042O00222O0100020002000683000100552O013O0004283O00552O012O006A000100083O0026032O0100552O0100380004283O00552O012O006A000100043O0020F700010001000E4O00025O00202O00020002000D4O000300056O000400033O00122O000500393O00122O0006003A6O0004000600024O000500066O000600076O000700023O00202O0007000700114O00095O00202O00090009000D4O0007000900024O000700076O00010007000200062O000100552O013O0004283O00552O012O006A000100033O0012DC0002003B3O0012DC0003003C4O00232O0100034O002000015O0012DC3O00093O000E390001000100013O0004283O000100012O006A00015O0020C800010001003500204C0001000100042O00222O0100020002000683000100762O013O0004283O00762O012O006A000100043O0020C200010001000E4O00025O00202O0002000200354O000300056O000400033O00122O0005003D3O00122O0006003E6O0004000600024O0005000C6O000600126O000700023O00202O00070007000500122O000900066O0007000900024O000700076O00010007000200062O000100762O013O0004283O00762O012O006A000100033O0012DC0002003F3O0012DC000300404O00232O0100034O002000016O006A00015O0020C800010001000300204C0001000100042O00222O0100020002000683000100A82O013O0004283O00A82O012O006A000100093O00204D0001000100274O00035O00202O0003000300414O00010003000200062O000100952O0100010004283O00952O012O006A000100083O000E750042008F2O0100010004283O008F2O012O006A000100083O000E0B003800A82O0100010004283O00A82O012O006A00015O0020C800010001004300204C0001000100162O00222O0100020002000654000100A82O0100010004283O00A82O012O006A00015O0020C800010001004400204C0001000100162O00222O0100020002000654000100A82O0100010004283O00A82O012O006A000100043O0020B000010001002C4O00025O00202O0002000200034O000300056O000400136O000500023O00202O00050005000500122O000700066O0005000700024O000500056O00010005000200062O000100A82O013O0004283O00A82O012O006A000100033O0012DC000200453O0012DC000300464O00232O0100034O002000016O006A00015O0020C800010001002000204C0001000100042O00222O0100020002000683000100E02O013O0004283O00E02O012O006A00015O0020C800010001002100204C0001000100042O00222O0100020002000683000100E02O013O0004283O00E02O012O006A000100093O0020020001000100174O00035O00202O0003000300184O00010003000200062O000100E02O013O0004283O00E02O012O006A000100144O00B8000200056O00035O00202O0003000300474O00010003000200062O000100C72O0100010004283O00C72O012O006A0001000D4O006A000200054O00222O01000200020026032O0100E02O0100220004283O00E02O012O006A000100093O0020020001000100174O00035O00202O0003000300234O00010003000200062O000100E02O013O0004283O00E02O012O006A000100093O0020020001000100174O00035O00202O0003000300244O00010003000200062O000100E02O013O0004283O00E02O012O006A000100014O006A00025O0020C80002000200202O00222O0100020002000683000100E02O013O0004283O00E02O012O006A000100033O0012DC000200483O0012DC000300494O00232O0100034O002000015O0012DC3O001F3O0004283O000100012O002A3O00017O00593O00028O00026O000840030A3O004C494D2O6F6E6669726503073O0049735265616479026O001440030C3O004361737454617267657449662O033O00B422B303083O00D4D943CB142ODF25030E3O0049735370652O6C496E52616E6765031B3O00B782A7DCBC84BAD7858EA9C6FA8FA4DDB589BCD3B682A6C1FADCF003043O00B2DAEDC803053O005377697065030E3O004973496E4D656C2O6552616E6765026O00204003143O00A5A2EFC0B3F5E4DCB9BAE2C4B7B9E9DEA5F5B48803043O00B0D6D5862O033O00F9ACAE03073O003994CDD6B4C836031B3O001FF22O3A701BEF300B7513E975367A1DF23120771EF23B273641AD03053O0016729D555403053O005368726564030C3O00446972654669786174696F6E030B3O004973417661696C61626C6503083O0042752O66446F776E03103O0053752O64656E416D6275736842752O66030B3O0057696C64536C61736865732O033O00C9CA0B03073O00C8A4AB73A43D9603143O00ADFC114087FEF60F4A8CBAE002498CB0E74316D103053O00E3DE946325026O001040030B3O0042727574616C536C6173682O033O003E5B5C03053O0099532O3296026O002640031A3O005F64660872A7724E7A720F7BEB4F51797C1867AA415278605C2103073O002D3D16137C13CB03053O0050726F776C03043O0052616B6503113O00446562752O665265667265736861626C65030A3O0052616B65446562752O66030B3O00504D756C7469706C696572026O66F63F030A3O00536861646F776D656C6403183O00417065785072656461746F727343726176696E6742752O6603133O00D10002E20E30BBCD1D02F11671B5CE1C1EB55603073O00D9A1726D956210030B3O00466572616C4672656E7A79030F3O00432O6F6C646F776E52656D61696E73026O00464003183O0001283978B3631F253478FC761E2F3778A8751E2F366FFC2203063O00147240581CDC2O033O003C00CA03073O00DD5161B2D498B003093O004973496E52616E676503123O00DFE616FE5ACFEB12F41ED9E611F414DEA74503053O007AAD877D9B026O00F03F03093O00436173744379636C65030D3O0052616B654D6F7573656F76657203133O0096C00BBC7F33C48BCE04AD3E3DC78AD240E86F03073O00A8E4A160D95F5103063O0042752O665570030C3O00436C65617263617374696E6703143O00C8D93C592B17D9DD21532B43DADD21523C178A8303063O0037BBB14E3C4F03063O00546872617368030C3O00546872617368446562752O66030E3O00546872617368696E67436C61777303153O0039C64DEA55C7C02FC250E442DB8121C151F8069ED403073O00E04DAE3F8B26AF031B3O0086534D3A854D673D88404B26C44354218B454C2F884E563DC4100E03043O004EE42138027O004003153O00DA76A00296C63EB00F8AC17AA60289C170A143D69A03053O00E5AE1ED2632O033O0016E48803073O00597B8DE6318D5D03133O00E170FD095048FF7EF908044BFF7EF81F5019A503063O002A9311966C7003103O004C494D2O6F6E66697265446562752O66031B3O0002A922712OE11DA3127CE6FC4FA42170E8EC1BA72170E9FB4FF77503063O00886FC64D1F8703153O001601B557AEEC57AB0E06A852A9E51BA60C1AE704ED03083O00C96269C736DD847703143O00AA0491240675AEB5038C251634A0B6029061506703073O00CCD96CE341625503143O004DD4FCF529805CCFFAEA28D45FCFFAEB3F800C9703063O00A03EA395854C0007032O0012DC3O00013O0026DE3O00AA000100020004283O00AA00012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001002B00013O0004283O002B00012O006A000100014O006A00025O0020C80002000200032O00222O01000200020006830001002B00013O0004283O002B00012O006A000100023O0026032O01002B000100050004283O002B00012O006A000100033O00200E0001000100064O00025O00202O0002000200034O000300046O000400053O00122O000500073O00122O000600086O0004000600024O000500066O000600066O000700073O00202O0007000700094O00095O00202O0009000900034O0007000900024O000700076O00010007000200062O0001002B00013O0004283O002B00012O006A000100053O0012DC0002000A3O0012DC0003000B4O00232O0100034O002000016O006A00015O0020C800010001000C00204C0001000100042O00222O01000200020006830001004700013O0004283O004700012O006A000100014O006A00025O0020C800020002000C2O00222O01000200020006830001004700013O0004283O004700012O006A000100084O00FC00025O00202O00020002000C4O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O0001004700013O0004283O004700012O006A000100053O0012DC0002000F3O0012DC000300104O00232O0100034O002000016O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001006C00013O0004283O006C00012O006A000100014O006A00025O0020C80002000200032O00222O01000200020006830001006C00013O0004283O006C00012O006A000100033O00200E0001000100064O00025O00202O0002000200034O000300046O000400053O00122O000500113O00122O000600126O0004000600024O000500066O000600066O000700073O00202O0007000700094O00095O00202O0009000900034O0007000900024O000700076O00010007000200062O0001006C00013O0004283O006C00012O006A000100053O0012DC000200133O0012DC000300144O00232O0100034O002000016O006A00015O0020C800010001001500204C0001000100042O00222O0100020002000683000100A900013O0004283O00A900012O006A000100093O000E750005007B000100010004283O007B00012O006A00015O0020C800010001001600204C0001000100172O00222O0100020002000683000100A900013O0004283O00A900012O006A000100014O006A00025O0020C80002000200152O00222O0100020002000683000100A900013O0004283O00A900012O006A0001000A3O0020020001000100184O00035O00202O0003000300194O00010003000200062O000100A900013O0004283O00A900012O006A0001000B3O0006830001009100013O0004283O009100012O006A00015O0020C800010001001A00204C0001000100172O00222O0100020002000654000100A9000100010004283O00A900012O006A000100033O0020AB0001000100064O00025O00202O0002000200154O0003000C6O000400053O00122O0005001B3O00122O0006001C6O0004000600024O0005000D6O000600066O000700073O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O000100A900013O0004283O00A900012O006A000100053O0012DC0002001D3O0012DC0003001E4O00232O0100034O002000015O0012DC3O001F3O0026DE3O007C2O0100010004283O007C2O012O006A00015O0020C800010001002000204C0001000100042O00222O0100020002000683000100CA00013O0004283O00CA00012O006A000100033O0020C20001000100064O00025O00202O0002000200204O000300046O000400053O00122O000500213O00122O000600226O0004000600024O0005000D6O0006000E6O000700073O00202O00070007000D00122O000900236O0007000900024O000700076O00010007000200062O000100CA00013O0004283O00CA00012O006A000100053O0012DC000200243O0012DC000300254O00232O0100034O002000016O006A00015O0020C800010001002600204C0001000100042O00222O0100020002000683000100112O013O0004283O00112O012O006A00015O0020C800010001002700204C0001000100042O00222O0100020002000683000100112O013O0004283O00112O012O006A0001000A3O0020020001000100184O00035O00202O0003000300194O00010003000200062O000100112O013O0004283O00112O012O006A000100073O00204D0001000100284O00035O00202O0003000300294O00010003000200062O000100EB000100010004283O00EB00012O006A000100073O00207E00010001002A4O00035O00202O0003000300274O00010003000200262O000100112O01002B0004283O00112O012O006A0001000A3O0020020001000100184O00035O00202O00030003002C4O00010003000200062O000100112O013O0004283O00112O012O006A000100014O006A00025O0020C80002000200272O00222O0100020002000683000100112O013O0004283O00112O012O006A0001000A3O0020020001000100184O00035O00202O0003000300264O00010003000200062O000100112O013O0004283O00112O012O006A0001000A3O0020020001000100184O00035O00202O00030003002D4O00010003000200062O000100112O013O0004283O00112O012O006A000100084O006A00025O0020C80002000200262O00222O0100020002000683000100112O013O0004283O00112O012O006A000100053O0012DC0002002E3O0012DC0003002F4O00232O0100034O002000016O006A00015O0020C800010001002C00204C0001000100042O00222O0100020002000683000100572O013O0004283O00572O012O006A00015O0020C800010001002700204C0001000100042O00222O0100020002000683000100572O013O0004283O00572O012O006A0001000A3O0020020001000100184O00035O00202O0003000300194O00010003000200062O000100572O013O0004283O00572O012O006A000100073O00204D0001000100284O00035O00202O0003000300294O00010003000200062O000100322O0100010004283O00322O012O006A000100073O00207E00010001002A4O00035O00202O0003000300274O00010003000200262O000100572O01002B0004283O00572O012O006A0001000A3O0020020001000100184O00035O00202O0003000300264O00010003000200062O000100572O013O0004283O00572O012O006A000100014O006A00025O0020C80002000200272O00222O0100020002000683000100572O013O0004283O00572O012O006A00015O0020C800010001003000204C0001000100312O00222O01000200020026032O0100572O0100320004283O00572O012O006A0001000A3O0020020001000100184O00035O00202O00030003002D4O00010003000200062O000100572O013O0004283O00572O012O006A000100084O006A00025O0020C800020002002C2O00222O0100020002000683000100572O013O0004283O00572O012O006A000100053O0012DC000200333O0012DC000300344O00232O0100034O002000016O006A00015O0020C800010001002700204C0001000100042O00222O01000200020006830001007B2O013O0004283O007B2O012O006A000100014O006A00025O0020C80002000200272O00222O01000200020006830001007B2O013O0004283O007B2O012O006A000100033O0020C20001000100064O00025O00202O0002000200274O0003000C6O000400053O00122O000500353O00122O000600366O0004000600024O0005000F6O000600106O000700073O00202O00070007003700122O0009000E6O0007000900024O000700076O00010007000200062O0001007B2O013O0004283O007B2O012O006A000100053O0012DC000200383O0012DC000300394O00232O0100034O002000015O0012DC3O003A3O0026DE3O00160201003A0004283O001602012O006A00015O0020C800010001002700204C0001000100042O00222O0100020002000683000100A02O013O0004283O00A02O012O006A000100014O006A00025O0020C80002000200272O00222O0100020002000683000100A02O013O0004283O00A02O012O006A000100033O00203C00010001003B4O00025O00202O0002000200274O0003000C6O000400116O000500073O00202O00050005000D00122O0007000E6O0005000700024O000500056O000600076O000800123O00202O00080008003C4O00010008000200062O000100A02O013O0004283O00A02O012O006A000100053O0012DC0002003D3O0012DC0003003E4O00232O0100034O002000016O006A00015O0020C800010001001500204C0001000100042O00222O0100020002000683000100C62O013O0004283O00C62O012O006A000100014O006A00025O0020C80002000200152O00222O0100020002000683000100C62O013O0004283O00C62O012O006A0001000A3O00200200010001003F4O00035O00202O0003000300404O00010003000200062O000100C62O013O0004283O00C62O012O006A000100023O0026DE000100C62O01003A0004283O00C62O012O006A000100084O00FC00025O00202O0002000200154O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O000100C62O013O0004283O00C62O012O006A000100053O0012DC000200413O0012DC000300424O00232O0100034O002000016O006A00015O0020C800010001004300204C0001000100042O00222O0100020002000683000100F92O013O0004283O00F92O012O006A000100134O0095000200046O00035O00202O0003000300444O00010003000200062O000100F92O013O0004283O00F92O012O006A000100014O006A00025O0020C80002000200432O00222O0100020002000683000100F92O013O0004283O00F92O012O006A0001000A3O00200200010001003F4O00035O00202O0003000300404O00010003000200062O000100F92O013O0004283O00F92O012O006A000100023O0026DE000100F92O01003A0004283O00F92O012O006A00015O0020C800010001004500204C0001000100172O00222O0100020002000654000100F92O0100010004283O00F92O012O006A000100084O00FC00025O00202O0002000200434O000300073O00202O00030003000D00122O000500236O0003000500024O000300036O00010003000200062O000100F92O013O0004283O00F92O012O006A000100053O0012DC000200463O0012DC000300474O00232O0100034O002000016O006A00015O0020C800010001002000204C0001000100042O00222O01000200020006830001001502013O0004283O001502012O006A000100014O006A00025O0020C80002000200202O00222O01000200020006830001001502013O0004283O001502012O006A000100084O00FC00025O00202O0002000200204O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O0001001502013O0004283O001502012O006A000100053O0012DC000200483O0012DC000300494O00232O0100034O002000015O0012DC3O004A3O0026DE3O006B0201001F0004283O006B02012O006A00015O0020C800010001004300204C0001000100042O00222O01000200020006830001003402013O0004283O003402012O006A000100014O006A00025O0020C80002000200432O00222O01000200020006830001003402013O0004283O003402012O006A000100084O00FC00025O00202O0002000200434O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O0001003402013O0004283O003402012O006A000100053O0012DC0002004B3O0012DC0003004C4O00232O0100034O002000016O006A00015O0020C800010001002700204C0001000100042O00222O01000200020006830001000603013O0004283O000603012O006A000100014O006A00025O0020C80002000200272O00222O01000200020006830001000603013O0004283O000603012O006A000100023O000E0B001F0049020100010004283O004902012O006A00015O0020C800010001001600204C0001000100172O00222O01000200020006830001005202013O0004283O005202012O006A00015O0020C800010001001A00204C0001000100172O00222O01000200020006830001000603013O0004283O000603012O006A0001000B3O0006830001000603013O0004283O000603012O006A000100033O0020AB0001000100064O00025O00202O0002000200274O000300096O000400053O00122O0005004D3O00122O0006004E6O0004000600024O000500146O000600066O000700073O00202O00070007000D00122O0009000E6O0007000900024O000700076O00010007000200062O0001000603013O0004283O000603012O006A000100053O0012780002004F3O00122O000300506O000100036O00015O00044O000603010026DE3O00010001004A0004283O000100012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001009402013O0004283O009402012O006A000100073O0020020001000100284O00035O00202O0003000300514O00010003000200062O0001009402013O0004283O009402012O006A000100014O006A00025O0020C80002000200032O00222O01000200020006830001009402013O0004283O009402012O006A000100023O0026DE000100940201003A0004283O009402012O006A000100084O00C600025O00202O0002000200034O000300073O00202O0003000300094O00055O00202O0005000500034O0003000500024O000300036O00010003000200062O0001009402013O0004283O009402012O006A000100053O0012DC000200523O0012DC000300534O00232O0100034O002000016O006A00015O0020C800010001004300204C0001000100042O00222O0100020002000683000100BD02013O0004283O00BD02012O006A000100134O0095000200046O00035O00202O0003000300444O00010003000200062O000100BD02013O0004283O00BD02012O006A000100014O006A00025O0020C80002000200432O00222O0100020002000683000100BD02013O0004283O00BD02012O006A00015O0020C800010001004500204C0001000100172O00222O0100020002000654000100BD020100010004283O00BD02012O006A000100084O00FC00025O00202O0002000200434O000300073O00202O00030003000D00122O000500236O0003000500024O000300036O00010003000200062O000100BD02013O0004283O00BD02012O006A000100053O0012DC000200543O0012DC000300554O00232O0100034O002000016O006A00015O0020C800010001001500204C0001000100042O00222O0100020002000683000100E202013O0004283O00E202012O006A000100014O006A00025O0020C80002000200152O00222O0100020002000683000100E202013O0004283O00E202012O006A000100023O0026DE000100E20201003A0004283O00E202012O006A00015O0020C800010001001A00204C0001000100172O00222O0100020002000654000100E2020100010004283O00E202012O006A000100084O00FC00025O00202O0002000200154O000300073O00202O00030003000D00122O0005000E6O0003000500024O000300036O00010003000200062O000100E202013O0004283O00E202012O006A000100053O0012DC000200563O0012DC000300574O00232O0100034O002000016O006A00015O0020C800010001000C00204C0001000100042O00222O01000200020006830001000403013O0004283O000403012O006A000100014O006A00025O0020C800020002000C2O00222O01000200020006830001000403013O0004283O000403012O006A00015O0020C800010001001A00204C0001000100172O00222O01000200020006830001000403013O0004283O000403012O006A000100084O00FC00025O00202O00020002000C4O000300073O00202O00030003000D00122O000500236O0003000500024O000300036O00010003000200062O0001000403013O0004283O000403012O006A000100053O0012DC000200583O0012DC000300594O00232O0100034O002000015O0012DC3O00023O0004283O000100012O002A3O00017O00293O00028O00030B3O005072696D616C577261746803073O004973526561647903113O00446562752O665265667265736861626C6503143O00436972636C656F664C696665616E644465617468030B3O004973417661696C61626C65030D3O00446562752O6652656D61696E73026O001840030E3O00546561724F70656E576F756E6473026O00F03F030E3O004973496E4D656C2O6552616E6765026O00264003173O00C6B20422C2DA9F1A3D2OC2A84D29CAD8A91E27C6C4E05F03053O00A3B6C06D4F2O033O0052697003093O00436173744379636C6503093O004973496E52616E6765026O002040030C3O005269704D6F7573656F766572030E3O00262F1080F33D2809D3FD3134409403053O0095544660A0030D3O004665726F63696F75734269746503083O0042752O66446F776E03183O00417065785072656461746F727343726176696E6742752O6603063O0042752O665570030F3O00536F756C6F66746865466F72657374030A3O0054696765727346757279030D3O00456E6572677954696D65546F58026O00494003193O003E031FE23B0F02F82B390FE42C034DEB310804FE30031FAD6E03043O008D58666D03063O00456E65726779030C3O004361737454617267657449662O033O00BE52D203083O00A1D333AA107A5D3503193O00FDABA027F8A7BD3DE891B021EFABF22EF2A0BB3BF3ABA068A303043O00489BCED22O033O004B7B4C03053O0053261A346E031A3O005E1235495B1E28534B28254F4C12674051192E5550123506094703043O002638774700E83O0012DC3O00013O0026DE3O0059000100010004283O005900012O006A00015O0020C800010001000200204C0001000100032O00222O01000200020006830001003C00013O0004283O003C00012O006A000100013O0020020001000100044O00035O00202O0003000300024O00010003000200062O0001001600013O0004283O001600012O006A00015O0020C800010001000500204C0001000100062O00222O01000200020006830001002300013O0004283O002300012O006A000100013O002O202O01000100074O00035O00202O0003000300024O00010003000200262O00010023000100080004283O002300012O006A00015O0020C800010001000900204C0001000100062O00222O01000200020006830001003C00013O0004283O003C00012O006A000100023O000E0B000A003C000100010004283O003C00012O006A00015O0020C800010001000200204C0001000100062O00222O01000200020006830001003C00013O0004283O003C00012O006A000100034O00FC00025O00202O0002000200024O000300013O00202O00030003000B00122O0005000C6O0003000500024O000300036O00010003000200062O0001003C00013O0004283O003C00012O006A000100043O0012DC0002000D3O0012DC0003000E4O00232O0100034O002000016O006A00015O0020C800010001000F00204C0001000100032O00222O01000200020006830001005800013O0004283O005800012O006A000100053O00203C0001000100104O00025O00202O00020002000F4O000300066O000400076O000500013O00202O00050005001100122O000700126O0005000700024O000500056O000600076O000800083O00202O0008000800134O00010008000200062O0001005800013O0004283O005800012O006A000100043O0012DC000200143O0012DC000300154O00232O0100034O002000015O0012DC3O000A3O0026DE3O00010001000A0004283O000100012O006A00015O0020C800010001001600204C0001000100032O00222O0100020002000683000100B400013O0004283O00B400012O006A000100093O0020020001000100174O00035O00202O0003000300184O00010003000200062O000100B400013O0004283O00B400012O006A000100093O00204C0001000100172O006A0003000A4O00072O01000300020006540001007A000100010004283O007A00012O006A000100093O00204C0001000100192O006A0003000A4O00072O0100030002000683000100B400013O0004283O00B400012O006A00015O0020C800010001001A00204C0001000100062O00222O0100020002000654000100B4000100010004283O00B400012O006A00015O0020C800010001001B00204C0001000100032O00222O010002000200065400010097000100010004283O009700012O006A000100093O0020020001000100174O00035O00202O0003000300184O00010003000200062O0001009700013O0004283O009700012O006A0001000B4O003D00025O00202O0002000200164O000300093O00202O00030003001C00122O0005001D6O000300056O00013O000200062O000100B400013O0004283O00B400012O006A000100043O0012780002001E3O00122O0003001F6O000100036O00015O00044O00B400012O006A000100093O00204C0001000100202O00222O0100020002000E5D001D00B4000100010004283O00B400012O006A000100053O0020AB0001000100214O00025O00202O0002000200164O000300066O000400043O00122O000500223O00122O000600236O0004000600024O0005000C6O000600066O000700013O00202O00070007000B00122O000900126O0007000900024O000700076O00010007000200062O000100B400013O0004283O00B400012O006A000100043O0012DC000200243O0012DC000300254O00232O0100034O002000016O006A00015O0020C800010001001600204C0001000100032O00222O0100020002000683000100E700013O0004283O00E700012O006A000100093O00204C0001000100192O006A0003000A4O00072O0100030002000683000100C600013O0004283O00C600012O006A00015O0020C800010001001A00204C0001000100062O00222O0100020002000654000100CD000100010004283O00CD00012O006A000100093O0020020001000100194O00035O00202O0003000300184O00010003000200062O000100E700013O0004283O00E700012O006A000100053O0020AB0001000100214O00025O00202O0002000200164O000300066O000400043O00122O000500263O00122O000600276O0004000600024O0005000C6O000600066O000700013O00202O00070007000B00122O000900126O0007000900024O000700076O00010007000200062O000100E700013O0004283O00E700012O006A000100043O001278000200283O00122O000300296O000100036O00015O00044O00E700010004283O000100012O002A3O00017O00453O00028O00026O00084003053O00536872656403073O0049735265616479030E3O004973496E4D656C2O6552616E6765026O00204003103O00E0E74AD32116F1EA4AC52044F8AF0A8403063O0036938F38B645030D3O004665726F63696F757342697465026O001440026O00F03F030C3O004361737454617267657449662O033O00DB80E703053O00BFB6E19F2903183O002D173A5A888ECD3E0117578293C76B102D479882D020527A03073O00A24B724835EBE703093O0042752O66537461636B03143O004F766572666C6F77696E67506F77657242752O6603153O00436F756E7441637469766542745472692O67657273027O0040030F3O00426C2O6F6474616C6F6E7342752O6603053O0050726F776C03043O0052616B6503083O0042752O66446F776E03103O0053752O64656E416D6275736842752O6603113O00446562752O665265667265736861626C65030A3O0052616B65446562752O66030B3O00504D756C7469706C6965720200684O66F63F030A3O00536861646F776D656C64030B3O00466572616C4672656E7A79030F3O00432O6F6C646F776E52656D61696E73026O00464003183O00417065785072656461746F727343726176696E6742752O66030F3O009C2E4BF55F428E3956F15610877C1003063O0062EC5C248233030A3O004C494D2O6F6E66697265030E3O0049735370652O6C496E52616E676503173O00A91603B443A1A7359B1A0DAE05AAB022B71C1EB105F9E103083O0050C4796CDA25C8D503063O00546872617368030E3O00546872617368696E67436C617773030B3O004973417661696C61626C65030C3O00546872617368446562752O66030B3O0042727574616C536C617368026O00264003113O00147B107E5806CA0276106C4E1C8140225403073O00EA6013621F2B6E03093O00436173744379636C6503113O004D2O6F6E666972654D6F7573656F76657203173O000B105DC9AA7B99032051C6B83289030D41C2BE79CB574703073O00EB667F32A7CC1203073O004368617267657303173O0052B3E03745226FB2F922572610A3F031572B42AAB5711403063O004E30C1954324030A3O0049734361737461626C6502005O66F63F03143O002316811C4E2713851445701C850A52350C8B581703053O0021507EE07803063O0042752O665570030E3O00FEA908C11CEEAD11D759FEA3439C03053O003C8CC863A4030C3O00446972654669786174696F6E030A3O00446562752O66446F776E03123O00446972654669786174696F6E446562752O6603103O0094FC1623A6C7F60134B182E60F66F3D703053O00C2E794644603173O00445ED4B7F7C4795FCDA2E5C0064EC4B1E5CD544781F2A403063O00A8262CA1C3960021022O0012DC3O00013O0026DE3O001A000100020004283O001A00012O006A00015O0020C800010001000300204C0001000100042O00222O01000200020006830001002002013O0004283O002002012O006A000100014O00FC00025O00202O0002000200034O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O0001002002013O0004283O002002012O006A000100033O001278000200073O00122O000300086O000100036O00015O00044O002002010026DE3O00BE000100010004283O00BE00012O006A00015O0020C800010001000900204C0001000100042O00222O01000200020006830001004300013O0004283O004300012O006A000100043O0026DE000100430001000A0004283O004300012O006A000100053O0006830001004300013O0004283O004300012O006A000100063O000E0B000B0043000100010004283O004300012O006A000100073O0020C200010001000C4O00025O00202O0002000200094O000300086O000400033O00122O0005000D3O00122O0006000E6O0004000600024O000500096O0006000A6O000700023O00202O00070007000500122O000900066O0007000900024O000700076O00010007000200062O0001004300013O0004283O004300012O006A000100033O0012DC0002000F3O0012DC000300104O00232O0100034O002000016O006A000100043O0026DE000100640001000A0004283O006400012O006A0001000B3O00201C2O01000100114O00035O00202O0003000300124O00010003000200262O000100580001000B0004283O00580001001259000100134O000B2O01000100020026DE00010058000100140004283O005800012O006A0001000B3O0020930001000100114O00035O00202O0003000300154O00010003000200262O000100640001000B0004283O006400010012DC000100014O001A000200023O0026DE0001005A000100010004283O005A00012O006A0003000C4O000B0103000100022O0040000200033O0006830002006400013O0004283O006400012O00A6000200023O0004283O006400010004283O005A00012O006A000100063O000E0B000B0073000100010004283O007300010012DC000100014O001A000200023O0026DE00010069000100010004283O006900012O006A0003000D4O000B0103000100022O0040000200033O0006830002007300013O0004283O007300012O00A6000200023O0004283O007300010004283O006900012O006A00015O0020C800010001001600204C0001000100042O00222O0100020002000683000100BD00013O0004283O00BD00012O006A0001000E4O006A00025O0020C80002000200172O00222O01000200020006830001008300013O0004283O00830001001259000100134O000B2O0100010002002612000100BD000100140004283O00BD00012O006A00015O0020C800010001001700204C0001000100042O00222O0100020002000683000100BD00013O0004283O00BD00012O006A0001000B3O0020020001000100184O00035O00202O0003000300194O00010003000200062O000100BD00013O0004283O00BD00012O006A000100023O00204D00010001001A4O00035O00202O00030003001B4O00010003000200062O0001009E000100010004283O009E00012O006A000100023O00207E00010001001C4O00035O00202O0003000300174O00010003000200262O000100BD0001001D0004283O00BD00012O006A0001000B3O0020020001000100184O00035O00202O00030003001E4O00010003000200062O000100BD00013O0004283O00BD00012O006A00015O0020C800010001001F00204C0001000100202O00222O01000200020026032O0100BD000100210004283O00BD00012O006A0001000B3O0020020001000100184O00035O00202O0003000300224O00010003000200062O000100BD00013O0004283O00BD00012O006A000100014O006A00025O0020C80002000200162O00222O0100020002000683000100BD00013O0004283O00BD00012O006A000100033O0012DC000200233O0012DC000300244O00232O0100034O002000015O0012DC3O000B3O000E39001400512O013O0004283O00512O012O006A00015O0020C800010001002500204C0001000100042O00222O0100020002000683000100E100013O0004283O00E10001001259000100134O000B2O01000100020026DE000100E1000100140004283O00E100012O006A0001000F4O006A00025O0020C80002000200252O00222O0100020002000683000100E100013O0004283O00E100012O006A000100014O00C600025O00202O0002000200254O000300023O00202O0003000300264O00055O00202O0005000500254O0003000500024O000300036O00010003000200062O000100E100013O0004283O00E100012O006A000100033O0012DC000200273O0012DC000300284O00232O0100034O002000016O006A00015O0020C800010001002900204C0001000100042O00222O0100020002000683000100172O013O0004283O00172O01001259000100134O000B2O01000100020026DE000100172O0100140004283O00172O012O006A0001000F4O006A00025O0020C80002000200292O00222O0100020002000683000100172O013O0004283O00172O012O006A00015O0020C800010001002A00204C00010001002B2O00222O0100020002000654000100172O0100010004283O00172O012O006A000100103O000683000100172O013O0004283O00172O012O006A000100023O00204D00010001001A4O00035O00202O00030003002C4O00010003000200062O000100072O0100010004283O00072O012O006A00015O0020C800010001002D00204C00010001002B2O00222O0100020002000683000100172O013O0004283O00172O012O006A000100014O00FC00025O00202O0002000200294O000300023O00202O00030003000500122O0005002E6O0003000500024O000300036O00010003000200062O000100172O013O0004283O00172O012O006A000100033O0012DC0002002F3O0012DC000300304O00232O0100034O002000016O006A00015O0020C800010001002500204C0001000100042O00222O0100020002000683000100342O013O0004283O00342O012O006A000100073O00201D0001000100314O00025O00202O0002000200254O000300116O000400126O000500023O00202O0005000500264O00075O00202O0007000700254O0005000700024O000500056O000600076O000800133O00202O0008000800324O00010008000200062O000100342O013O0004283O00342O012O006A000100033O0012DC000200333O0012DC000300344O00232O0100034O002000016O006A00015O0020C800010001002D00204C0001000100042O00222O0100020002000683000100502O013O0004283O00502O012O006A00015O0020C800010001002D00204C0001000100352O00222O0100020002000E0B000B00502O0100010004283O00502O012O006A000100014O00FC00025O00202O00020002002D4O000300023O00202O00030003000500122O0005002E6O0003000500024O000300036O00010003000200062O000100502O013O0004283O00502O012O006A000100033O0012DC000200363O0012DC000300374O00232O0100034O002000015O0012DC3O00023O0026DE3O00010001000B0004283O000100012O006A00015O0020C800010001001E00204C0001000100382O00222O0100020002000683000100972O013O0004283O00972O012O006A0001000E4O006A00025O0020C80002000200172O00222O0100020002000683000100632O013O0004283O00632O01001259000100134O000B2O0100010002002612000100972O0100140004283O00972O012O006A00015O0020C800010001001700204C0001000100042O00222O0100020002000683000100972O013O0004283O00972O012O006A0001000B3O0020020001000100184O00035O00202O0003000300194O00010003000200062O000100972O013O0004283O00972O012O006A000100023O00204D00010001001A4O00035O00202O00030003001B4O00010003000200062O0001007E2O0100010004283O007E2O012O006A000100023O00207E00010001001C4O00035O00202O0003000300174O00010003000200262O000100972O0100390004283O00972O012O006A0001000B3O0020020001000100184O00035O00202O0003000300164O00010003000200062O000100972O013O0004283O00972O012O006A0001000B3O0020020001000100184O00035O00202O0003000300224O00010003000200062O000100972O013O0004283O00972O012O006A000100014O006A00025O0020C800020002001E2O00222O0100020002000683000100972O013O0004283O00972O012O006A000100033O0012DC0002003A3O0012DC0003003B4O00232O0100034O002000016O006A00015O0020C800010001001700204C0001000100042O00222O0100020002000683000100D12O013O0004283O00D12O012O006A0001000E4O006A00025O0020C80002000200172O00222O0100020002000683000100A72O013O0004283O00A72O01001259000100134O000B2O0100010002002612000100D12O0100140004283O00D12O012O006A000100023O00204D00010001001A4O00035O00202O00030003001B4O00010003000200062O000100C12O0100010004283O00C12O012O006A0001000B3O00200200010001003C4O00035O00202O0003000300194O00010003000200062O000100D12O013O0004283O00D12O012O006A0001000B3O0020A000010001001C4O00035O00202O0003000300174O0001000300024O000200023O00202O00020002001C4O00045O00202O0004000400174O00020004000200062O000200D12O0100010004283O00D12O012O006A000100014O00FC00025O00202O0002000200174O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O000100D12O013O0004283O00D12O012O006A000100033O0012DC0002003D3O0012DC0003003E4O00232O0100034O002000016O006A00015O0020C800010001000300204C0001000100042O00222O0100020002000683000100FE2O013O0004283O00FE2O01001259000100134O000B2O0100010002002612000100E82O0100140004283O00E82O012O006A00015O0020C800010001003F00204C00010001002B2O00222O0100020002000683000100FE2O013O0004283O00FE2O012O006A000100023O0020020001000100404O00035O00202O0003000300414O00010003000200062O000100FE2O013O0004283O00FE2O012O006A0001000F4O006A00025O0020C80002000200032O00222O0100020002000683000100FE2O013O0004283O00FE2O012O006A000100014O00FC00025O00202O0002000200034O000300023O00202O00030003000500122O000500066O0003000500024O000300036O00010003000200062O000100FE2O013O0004283O00FE2O012O006A000100033O0012DC000200423O0012DC000300434O00232O0100034O002000016O006A00015O0020C800010001002D00204C0001000100042O00222O01000200020006830001001E02013O0004283O001E0201001259000100134O000B2O01000100020026DE0001001E020100140004283O001E02012O006A0001000F4O006A00025O0020C800020002002D2O00222O01000200020006830001001E02013O0004283O001E02012O006A000100014O00FC00025O00202O00020002002D4O000300023O00202O00030003000500122O0005002E6O0003000500024O000300036O00010003000200062O0001001E02013O0004283O001E02012O006A000100033O0012DC000200443O0012DC000300454O00232O0100034O002000015O0012DC3O00143O0004283O000100012O002A3O00017O00253O00028O00030B3O00496E6361726E6174696F6E03073O0049735265616479026O003940030E3O004973496E4D656C2O6552616E6765026O00204003163O0089F2817722E6B70289F38C3633E7B91A84F3957870BE03083O0076E09CE2165088D6026O00F03F026O000840030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B657403063O0042752O665570030E3O0048656172744F6654686557696C64030B3O00426C2O6F646C7573745570026O004440026O00104003073O00446A61722O756E03123O004973457175692O706564416E64526561647903283O0046E4589257FB57BF52E7558C43FC668F44D14D8847D15C8C46EB4BBF44E2588D47AE54814BE019D403043O00E0228E39027O004003113O00436F6E766F6B6554686553706972697473031F3O00DDA82OCB7CFA5831CAAFC0E260E1541CD7B3D69D70FE5202DAA8D2D333A00B03083O006EBEC7A5BD13913D03103O0048616E646C65546F705472696E6B657403073O004265727365726B026O003240026O003740030F3O00432O6F6C646F776E52656D61696E73026O00244003123O00D8EE65FB8ED5D1AB74E784CBDEE460E6CB9F03063O00A7BA8B1788EB030A3O004265727365726B696E67030A3O0049734361737461626C6503163O0018B09A1E1FA7830414B2C80E15BA840915A2864D4BE703043O006D7AD5E80003012O0012DC3O00014O001A000100023O0026DE3O002B000100010004283O002B00012O006A00036O0077000400016O0003000200044O000200046O000100036O000300023O00202O00030003000200202O0003000300034O00030002000200062O0003002A00013O0004283O002A00012O006A000300033O0006830003002A00013O0004283O002A00012O006A000300043O00066600010017000100030004283O00170001000E750004001A000100010004283O001A00012O006A000300043O0006A90001002A000100030004283O002A00012O006A000300054O00FC000400023O00202O0004000400024O000500063O00202O00050005000500122O000700066O0005000700024O000500056O00030005000200062O0003002A00013O0004283O002A00012O006A000300073O0012DC000400073O0012DC000500084O0023010300054O002000035O0012DC3O00093O0026DE3O004E0001000A0004283O004E00010012590003000B3O0006830003003200013O0004283O003200010012590003000B4O00A6000300024O006A000300083O0020C800030003000C2O006A000400094O006A000500033O0006830005004900013O0004283O004900012O006A0005000A3O00204D00050005000D4O000700023O00202O00070007000E4O00050007000200062O00050049000100010004283O004900012O006A0005000A3O00204D00050005000D4O000700023O00202O0007000700024O00050007000200062O00050049000100010004283O004900012O006A0005000A3O00204C00050005000F2O00220105000200020012DC000600104O001A000700074O00070103000700020012E90003000B3O0012DC3O00113O0026DE3O006F000100110004283O006F00010012590003000B3O0006830003005500013O0004283O005500010012590003000B4O00A6000300024O006A000300033O000683000300022O013O0004283O00022O012O006A0003000B3O0020C800030003001200204C0003000300132O0022010300020002000683000300022O013O0004283O00022O012O006A000300054O00FC0004000C3O00202O0004000400124O000500063O00202O00050005000500122O000700066O0005000700024O000500056O00030005000200062O000300022O013O0004283O00022O012O006A000300073O001278000400143O00122O000500156O000300056O00035O00044O00022O010026DE3O00A6000100160004283O00A600012O006A000300023O0020C800030003001700204C0003000300032O00220103000200020006830003008A00013O0004283O008A00012O006A000300033O0006830003008A00013O0004283O008A00012O006A000300054O00FC000400023O00202O0004000400174O000500063O00202O00050005000500122O000700066O0005000700024O000500056O00030005000200062O0003008A00013O0004283O008A00012O006A000300073O0012DC000400183O0012DC000500194O0023010300054O002000036O006A000300083O0020C800030003001A2O006A000400094O006A000500033O000683000500A100013O0004283O00A100012O006A0005000A3O00204D00050005000D4O000700023O00202O00070007000E4O00050007000200062O000500A1000100010004283O00A100012O006A0005000A3O00204D00050005000D4O000700023O00202O0007000700024O00050007000200062O000500A1000100010004283O00A100012O006A0005000A3O00204C00050005000F2O00220105000200020012DC000600104O001A000700074O00070103000700020012E90003000B3O0012DC3O000A3O000E390009000200013O0004283O000200012O006A000300023O0020C800030003001B00204C0003000300032O0022010300020002000683000300DE00013O0004283O00DE00012O006A000300033O000683000300DE00013O0004283O00DE00012O006A000300043O000666000100B6000100030004283O00B60001000E75001C00B9000100010004283O00B900012O006A000300043O0006A9000100DE000100030004283O00DE00012O006A0003000D3O000683000300CE00013O0004283O00CE00012O006A000300043O0026E5000300CE0001001D0004283O00CE00012O006A0003000D3O000683000300C500013O0004283O00C500012O006A0003000E3O000683000300CE00013O0004283O00CE00012O006A0003000E3O000683000300DE00013O0004283O00DE00012O006A000300023O0020C800030003001700204C00030003001E2O0022010300020002002603010300DE0001001F0004283O00DE00012O006A000300054O00FC000400023O00202O00040004001B4O000500063O00202O00050005000500122O000700066O0005000700024O000500056O00030005000200062O000300DE00013O0004283O00DE00012O006A000300073O0012DC000400203O0012DC000500214O0023010300054O002000036O006A000300023O0020C800030003002200204C0003000300232O002201030002000200068300032O002O013O0004284O002O012O006A000300033O00068300032O002O013O0004284O002O012O006A0003000F3O000683000300F000013O0004283O00F000012O006A0003000A3O00204C00030003000D2O006A000500104O000701030005000200068300032O002O013O0004284O002O012O006A000300054O00FC000400023O00202O0004000400224O000500063O00202O00050005000500122O000700066O0005000700024O000500056O00030005000200062O00032O002O013O0004284O002O012O006A000300073O0012DC000400243O0012DC000500254O0023010300054O002000035O0012DC3O00163O0004283O000200012O002A3O00017O004C3O00028O00026O000840030C3O004570696353652O74696E677303083O0053652O74696E6773030D3O00DBE4A337EBC7B03FF9FB8D1FCD03043O00508E97C2034O00030A3O0033D4785B0FF4764204C303043O002C63A617030D3O0049E42C013AA878D4213721A37903063O00C41C97495653030B3O00C6102C32834A1365F80A2703083O001693634970E23878030A3O009A74F0FE9EB37CECDDBD03053O00EDD8158295026O001040030F3O00B75D5A71B1DD4B904B4C69B9CE578E03073O003EE22E2O3FD0A9030E3O00CB1841960D083C68EC1E5C8F373D03083O003E857935E37F6D4F030A3O00250737C7D3A0A707153E03073O00C270745295B6CE03093O000BAD421DD7E302119803073O006E59C82C78A08203163O004672656E7A696564526567656E65726174696F6E485003163O008DD14E4859433E4999C64C434D4F294CBFCA44486B7A03083O002DCBA32B26232A5B026O001440027O004003113O00FA84D2278BAC7DDC86D33197A646D784D003073O0034B2E5BC43E7C903113O00084F4401E54E363155670DE3541035545E03073O004341213064973C03163O00F6E9BADDE1CDF2BECCDCD1EBB7EFFBD6F3ABD4FACCF303053O0093BF87CEB803123O00AD26B2C4CA41A7943C92C9CA56A18C27AAC503073O00D2E448C6A1B833030D3O00035AF63372DA1046E11D5CE11503063O00AE5629937013026O00F03F030D3O007F099E1B200335AE59158B0D3603083O00CB3B60ED6B456F71030B4O001FBFF134FCF53110AAF203073O00B74476CC815190030E3O003BBE75CC0E8302B978F71F8D00A803063O00E26ECD10846B030D3O00C3C6E1D555E3D0F4D64FEEEBD003053O00218BA380B9030F3O007F590ADA5B5D25D851540DDD435D0003043O00BE373864030A3O0063BC392C12E0FA57A32F03073O009336CF5C7E738303103O0038223055087F01383B7A3D7119383A7303063O001E6D51551D6D03113O00D77455BA3FD0FBCF7E40BF39D0D2FE7C5103073O009C9F1134D656BE030F3O0086EABCB0A7E1BA8CA1FBB4B3A0C78D03043O00DCCE8FDD03103O00B36E283AD9DED9A97B191FDDFBDB8A7903073O00B2E61D4D77B8AC03173O005573654672656E7A696564526567656E65726174696F6E03173O00C0AD0F3D65FDFBA4031E73CAF0B90F1572EAF4AA03147903063O009895DE6A7B1703133O00537572766976616C496E7374696E637473485003133O00EE33E455BCCB27FA6ABBCE32FF4DB6C935DE7303053O00D5BD46962303143O00557365537572766976616C496E7374696E63747303143O007A46713B5A47620159547821414660014156601B03043O00682F3514030B3O00965F842EB908B1439608B403063O006FC32CE17CDC03143O00ED550541AEACCA491767A386D7531376A4BDDD5403063O00CBB8266013CB026O001840030A3O000B767E53C12E677169FE03053O00AE591319210037012O0012DC3O00013O0026DE3O0035000100020004283O00350001001259000100033O0020C00001000100044O000200013O00122O000300053O00122O000400066O0002000400024O00010001000200062O0001000D000100010004283O000D00010012DC000100074O002D00015O001253000100033O00202O0001000100044O000200013O00122O000300083O00122O000400096O0002000400024O00010001000200062O00010018000100010004283O001800010012DC000100014O002D000100023O0012292O0100033O00202O0001000100044O000200013O00122O0003000A3O00122O0004000B6O0002000400024O0001000100024O000100033O00122O000100033O00202O0001000100044O000200013O00122O0003000C3O00122O0004000D6O0002000400024O0001000100024O000100043O00122O000100033O00202O0001000100044O000200013O00122O0003000E3O00122O0004000F6O0002000400024O00010001000200062O00010033000100010004283O003300010012DC000100014O002D000100053O0012DC3O00103O0026DE3O0069000100100004283O00690001001259000100033O0020970001000100044O000200013O00122O000300113O00122O000400126O0002000400024O0001000100024O000100063O00122O000100033O00202O0001000100044O000200013O00122O000300133O00122O000400146O0002000400024O00010001000200062O00010049000100010004283O004900010012DC000100014O002D000100073O001285000100033O00202O0001000100044O000200013O00122O000300153O00122O000400166O0002000400024O0001000100024O000100083O00122O000100033O00202O0001000100044O000200013O00122O000300173O00122O000400186O0002000400024O00010001000200062O0001005C000100010004283O005C00010012DC000100014O002D000100093O001253000100033O00202O0001000100044O000200013O00122O0003001A3O00122O0004001B6O0002000400024O00010001000200062O00010067000100010004283O006700010012DC000100013O0012E9000100193O0012DC3O001C3O0026DE3O00970001001D0004283O00970001001259000100033O0020F80001000100044O000200013O00122O0003001E3O00122O0004001F6O0002000400024O0001000100024O0001000A3O00122O000100033O00202O0001000100044O000200013O00122O000300203O00122O000400216O0002000400024O0001000100024O0001000B3O00122O000100033O00202O0001000100044O000200013O00122O000300223O00122O000400236O0002000400024O0001000100024O0001000C3O00122O000100033O00202O0001000100044O000200013O00122O000300243O00122O000400256O0002000400024O00010001000200062O0001008D000100010004283O008D00010012DC000100014O002D0001000D3O001233000100033O00202O0001000100044O000200013O00122O000300263O00122O000400276O0002000400024O0001000100024O0001000E3O00124O00023O0026DE3O00C5000100280004283O00C50001001259000100033O0020F80001000100044O000200013O00122O000300293O00122O0004002A6O0002000400024O0001000100024O0001000F3O00122O000100033O00202O0001000100044O000200013O00122O0003002B3O00122O0004002C6O0002000400024O0001000100024O000100103O00122O000100033O00202O0001000100044O000200013O00122O0003002D3O00122O0004002E6O0002000400024O0001000100024O000100113O00122O000100033O00202O0001000100044O000200013O00122O0003002F3O00122O000400306O0002000400024O00010001000200062O000100BB000100010004283O00BB00010012DC000100014O002D000100123O001233000100033O00202O0001000100044O000200013O00122O000300313O00122O000400326O0002000400024O0001000100024O000100133O00124O001D3O000E39000100F900013O0004283O00F90001001259000100033O0020970001000100044O000200013O00122O000300333O00122O000400346O0002000400024O0001000100024O000100143O00122O000100033O00202O0001000100044O000200013O00122O000300353O00122O000400366O0002000400024O00010001000200062O000100D9000100010004283O00D900010012DC000100014O002D000100153O001253000100033O00202O0001000100044O000200013O00122O000300373O00122O000400386O0002000400024O00010001000200062O000100E4000100010004283O00E400010012DC000100074O002D000100163O001253000100033O00202O0001000100044O000200013O00122O000300393O00122O0004003A6O0002000400024O00010001000200062O000100EF000100010004283O00EF00010012DC000100014O002D000100173O001233000100033O00202O0001000100044O000200013O00122O0003003B3O00122O0004003C6O0002000400024O0001000100024O000100183O00124O00283O000E39001C00272O013O0004283O00272O01001259000100033O0020D70001000100044O000200013O00122O0003003E3O00122O0004003F6O0002000400024O00010001000200122O0001003D3O00122O000100033O00202O0001000100044O000200013O00122O000300413O00122O000400426O0002000400024O00010001000200062O0001000D2O0100010004283O000D2O010012DC000100013O0012E9000100403O001204000100033O00202O0001000100044O000200013O00122O000300443O00122O000400456O0002000400024O00010001000200122O000100433O00122O000100033O00202O0001000100044O000200013O00122O000300463O00122O000400476O0002000400024O0001000100024O000100193O00122O000100033O00202O0001000100044O000200013O00122O000300483O00122O000400496O0002000400024O0001000100024O0001001A3O00124O004A3O0026DE3O00010001004A0004283O00010001001259000100033O0020C00001000100044O000200013O00122O0003004B3O00122O0004004C6O0002000400024O00010001000200062O000100332O0100010004283O00332O010012DC000100014O002D0001001B3O0004283O00362O010004283O000100012O002A3O00017O00A83O00028O00026O000840030C3O0053686F756C6452657475726E030F3O0048616E646C65412O666C696374656403103O0052656D6F7665436F2O72757074696F6E03193O0052656D6F7665436F2O72757074696F6E4D6F7573656F766572026O00444003113O0048616E646C65496E636F72706F7265616C03093O0048696265726E61746503123O0048696265726E6174654D6F7573656F766572026O003E40030F3O00412O66656374696E67436F6D626174030D3O004D61726B4F6654686557696C64030A3O0049734361737461626C6503083O0042752O66446F776E03103O0047726F757042752O664D692O73696E6703133O004D61726B4F6654686557696C64506C6179657203103O0022134045C8880D10065A4BC89002231603073O006B4F72322E97E703073O00436174466F726D030C3O003AA7A1168C36A5CD79A9BA2A03083O00A059C6D549EA59D7030D3O00546172676574497356616C696403093O004973496E52616E6765026O002640026O00F03F03043O00502O6F6C030B3O00787EBBF2856D7FB1ECC25103053O00A52811D49E03103O004865616C746850657263656E7461676503163O004672656E7A696564526567656E65726174696F6E485003173O005573654672656E7A696564526567656E65726174696F6E03143O004672656E7A696564526567656E65726174696F6E03073O004973526561647903203O00C3CB0D3D3CECDC0C0123E2DC063634E4CD013C28A5DD0D3523EBCA012523A58B03053O004685B9685303133O00537572766976616C496E7374696E637473485003143O00557365537572766976616C496E7374696E63747303113O00537572766976616C496E7374696E637473031D3O003750563CC012444803C717514D24CA1056042ECC02404A39C01240047803053O00A96425244A027O004003083O00526567726F77746803063O0042752O66557003163O005072656461746F727953776966746E652O7342752O66030E3O00526567726F777468506C6179657203143O001282A5420F90B6584083A7560589B1591682E20403043O003060E7C203083O004261726B736B696E03143O00CA5B1C260AD3A68D885E0B2B1CD6BC8ADE5F4E7B03083O00E3A83A6E4D79B8CF030C3O004E617475726573566967696C03193O00753DAB55A3DE629A6D35B849BD9B75A07D39B153B8CD74E52903083O00C51B5CDF20D1BB1103073O0052656E6577616C03133O00115ACDFE145ECFBB075AC5FE0D4CCAED061F9103043O009B633FA3030B3O004865616C746873746F6E6503173O008AD4A081AD8C91C5AE83BCC486D4A788B7978BC7A4CDEA03063O00E4E2B1C1EDD903193O0006B525F431A32BEF3AB763CE31B12FEF3AB763D63BA42AE93A03043O008654D04303173O0052656672657368696E674865616C696E67506F74696F6E03253O0001A9804E16BF8E551DABC65416AD8A551DABC64C1CB88F531DEC825915A9884F1ABA831C4703043O003C73CCE603093O004973496E506172747903083O004973496E5261696403063O00457869737473030D3O004973446561644F7247686F737403093O0043616E412O7461636B03113O00526567726F7774684D6F7573656F76657203123O00F53FEC62E82DFF78D837E465F43FE466E22803043O0010875A8B030A3O005469676572734675727903113O00436F6E766F6B6554686553706972697473030B3O004973417661696C61626C65030D3O00456E6572677944656669636974025O00405040026O002E4003083O005072656461746F72030E3O004973496E4D656C2O6552616E6765026O00204003123O00407D01365C2O475261142A0E59795D7A466503073O0018341466532E34026O00104003093O0042752O66537461636B030F3O00426C2O6F6474616C6F6E7342752O6603153O00436F756E7441637469766542745472692O67657273026O001440030B3O005072696D616C5772617468030B3O00466572616C4672656E7A79030A3O00436F6D62617454696D65026O002440030C3O004361737454617267657449662O033O00C92E3903053O006FA44F414403143O00C0DC91DF22D5C0CB86D034F386D482D720AA948903063O008AA6B9E3BE4E030D3O004665726F63696F75734269746503183O00417065785072656461746F727343726176696E6742752O66030E3O005361626572742O6F746842752O662O033O00C675DD03073O0079AB14A557324303163O00C03DAB39BA0BC92DAA09BB0BD23DF93BB80BC878E86003063O0062A658D956D903143O005072656461746F7252657665616C656442752O6603133O00C1F77015C6DAF9E439278FD2FFE571042O94BF03063O00BC2O961961E603093O00497343617374696E67030C3O0049734368612O6E656C696E67030B3O00436F6D626F506F696E747303113O00496E74652O72757074576974685374756E03043O004D61696D030A3O004D69676874794261736803093O00496E74652O7275707403093O00536B752O6C4261736803123O00536B752O6C426173684D6F7573656F76657203123O00496E636170616369746174696E67526F617203063O00532O6F74686503113O00556E6974486173456E7261676542752O6603063O00DE804C1209E103063O008DBAE93F626C03053O0050726F776C030C3O00E1F823A129B1E72DBF2BB1B803053O0045918A4CD6030F3O0073CE9DB6B91962C2C984BE1F7E8FDD03063O007610AF2OE9DF03043O0052616B6503093O00537465616C7468557003093O00436173744379636C65030D3O0052616B654D6F7573656F766572030C3O0099853EBEAE867C828A75EABE03073O001DEBE455DB8EEB030D3O004164617074697665537761726D030E3O00556E627269646C6564537761726D030E3O0049735370652O6C496E52616E676503163O004164617074697665537761726D4D6F7573656F76657203163O003CD0BBCD6347315702C7ADDC6543675F3CDDB49D261C03083O00325DB4DABD172E472O033O00D3A54303073O0028BEC43B2C24BC03163O003D41DDA4EE741B397ACFA3FB6F007C48DDBDF43D5C6F03073O006D5C25BCD49A1D03123O00436F6D626F506F696E74734465666963697403103O00426F2O73466967687452656D61696E73024O0080B3C540030C3O00466967687452656D61696E7303093O00497341506C6179657203073O005265626972746803103O00526562697274684D6F7573656F76657203073O0016EAA6CA234E0C03063O003A648FC4A351030F3O005265766976654D6F7573656F76657203063O00084735AA294C03083O006E7A2243C35F2985030C3O004570696353652O74696E677303073O00546F2O676C65732O033O007ABE5803053O00B615D13B2A2O033O00B658C003063O00DED737A57D412O033O002F2OD503083O002A4CB1A67A92A18D03063O00A18316DE7C7A03063O0016C5EA65AE19030A3O0054726176656C466F726D03093O0049734D6F756E74656403163O00476574456E656D696573496E4D656C2O6552616E67650050052O0012DC3O00013O0026DE3O007B040100020004283O007B04012O006A00015O0006830001001900013O0004283O001900010012DC000100013O0026DE00010007000100010004283O000700012O006A000200013O0020A20002000200044O000300023O00202O0003000300054O000400033O00202O00040004000600122O000500076O00020005000200122O000200033O00122O000200033O00062O0002001900013O0004283O00190001001259000200034O00A6000200023O0004283O001900010004283O000700012O006A000100043O0006830001003000013O0004283O003000010012DC000100013O000E390001001D000100010004283O001D00012O006A000200013O00201F0102000200084O000300023O00202O0003000300094O000400033O00202O00040004000A00122O0005000B6O000600016O00020006000200122O000200033O00122O000200033O00062O0002003000013O0004283O00300001001259000200034O00A6000200023O0004283O003000010004283O001D00012O006A000100053O00204C00010001000C2O00222O010002000200065400010071000100010004283O007100012O006A000100063O0006830001007100013O0004283O007100010012DC000100013O0026DE00010039000100010004283O003900012O006A000200073O0006830002005E00013O0004283O005E00012O006A000200023O0020C800020002000D00204C00020002000E2O00220102000200020006830002005E00013O0004283O005E00012O006A000200053O0020D800020002000F4O000400023O00202O00040004000D4O000500016O00020005000200062O00020053000100010004283O005300012O006A000200013O0020600002000200104O000300023O00202O00030003000D4O00020002000200062O0002005E00013O0004283O005E00012O006A000200084O006A000300033O0020C80003000300112O00220102000200020006830002005E00013O0004283O005E00012O006A000200093O0012DC000300123O0012DC000400134O0023010200044O002000026O006A000200023O0020C800020002001400204C00020002000E2O00220102000200020006830002007100013O0004283O007100012O006A000200084O006A000300023O0020C80003000300142O00220102000200020006830002007100013O0004283O007100012O006A000200093O001278000300153O00122O000400166O000200046O00025O00044O007100010004283O003900012O006A000100013O0020C80001000100172O000B2O01000100020006830001004F05013O0004283O004F05012O006A0001000A3O00204C0001000100180012DC000300194O00072O01000300020006830001004F05013O0004283O004F05010012DC000100013O0026DE0001008B0001001A0004283O008B00012O006A000200084O006A000300023O0020C800030003001B2O00220102000200020006830002004F05013O0004283O004F05012O006A000200093O0012780003001C3O00122O0004001D6O000200046O00025O00044O004F05010026DE0001007D000100010004283O007D00012O006A000200053O00204C00020002000C2O0022010200020002000654000200A1000100010004283O00A100012O006A000200063O000683000200A100013O0004283O00A100010012DC000200014O001A000300033O0026DE00020097000100010004283O009700012O006A0004000B4O000B0104000100022O0040000300043O000683000300A100013O0004283O00A100012O00A6000300023O0004283O00A100010004283O009700012O006A000200053O00204C00020002000C2O0022010200020002000654000200A9000100010004283O00A900012O006A000200063O0006830002007804013O0004283O007804010012DC000200013O0026DE000200290201001A0004283O002902012O006A000300053O00204C00030003000C2O0022010300020002000683000300AB2O013O0004283O00AB2O010012DC000300013O0026DE000300ED0001001A0004283O00ED00012O006A000400053O00204C00040004001E2O00220104000200020012590005001F3O0006AE000400D0000100050004283O00D00001001259000400203O000683000400D000013O0004283O00D000012O006A000400023O0020C800040004002100204C0004000400222O0022010400020002000683000400D000013O0004283O00D000012O006A000400084O009F000500023O00202O0005000500214O000600076O000800016O00040008000200062O000400D000013O0004283O00D000012O006A000400093O0012DC000500233O0012DC000600244O0023010400064O002000046O006A000400053O00204C00040004001E2O0022010400020002001259000500253O0006AE000400EC000100050004283O00EC0001001259000400263O000683000400EC00013O0004283O00EC00012O006A000400023O0020C800040004002700204C0004000400222O0022010400020002000683000400EC00013O0004283O00EC00012O006A000400084O009F000500023O00202O0005000500274O000600076O000800016O00040008000200062O000400EC00013O0004283O00EC00012O006A000400093O0012DC000500283O0012DC000600294O0023010400064O002000045O0012DC0003002A3O0026DE0003002D2O01002A0004283O002D2O012O006A000400023O0020C800040004002B00204C00040004000E2O0022010400020002000683000400102O013O0004283O00102O012O006A0004000C3O000683000400102O013O0004283O00102O012O006A000400053O00200200040004002C4O000600023O00202O00060006002D4O00040006000200062O000400102O013O0004283O00102O012O006A000400053O00204C00040004001E2O00220104000200022O006A0005000D3O0006AE000400102O0100050004283O00102O012O006A000400084O006A000500033O0020C800050005002E2O0022010400020002000683000400102O013O0004283O00102O012O006A000400093O0012DC0005002F3O0012DC000600304O0023010400064O002000046O006A000400053O00204C00040004001E2O00220104000200022O006A0005000E3O0006AE0004002C2O0100050004283O002C2O012O006A0004000F3O0006830004002C2O013O0004283O002C2O012O006A000400023O0020C800040004003100204C0004000400222O00220104000200020006830004002C2O013O0004283O002C2O012O006A000400084O009F000500023O00202O0005000500314O000600076O000800016O00040008000200062O0004002C2O013O0004283O002C2O012O006A000400093O0012DC000500323O0012DC000600334O0023010400064O002000045O0012DC000300023O0026DE000300682O0100010004283O00682O012O006A000400053O00204C00040004001E2O00220104000200022O006A000500103O0006AE0004004B2O0100050004283O004B2O012O006A000400113O0006830004004B2O013O0004283O004B2O012O006A000400023O0020C800040004003400204C0004000400222O00220104000200020006830004004B2O013O0004283O004B2O012O006A000400084O009F000500023O00202O0005000500344O000600076O000800016O00040008000200062O0004004B2O013O0004283O004B2O012O006A000400093O0012DC000500353O0012DC000600364O0023010400064O002000046O006A000400053O00204C00040004001E2O00220104000200022O006A000500123O0006AE000400672O0100050004283O00672O012O006A000400133O000683000400672O013O0004283O00672O012O006A000400023O0020C800040004003700204C0004000400222O0022010400020002000683000400672O013O0004283O00672O012O006A000400084O009F000500023O00202O0005000500374O000600076O000800016O00040008000200062O000400672O013O0004283O00672O012O006A000400093O0012DC000500383O0012DC000600394O0023010400064O002000045O0012DC0003001A3O0026DE000300B2000100020004283O00B200012O006A000400143O0020C800040004003A00204C0004000400222O0022010400020002000683000400862O013O0004283O00862O012O006A000400153O000683000400862O013O0004283O00862O012O006A000400053O00204C00040004001E2O00220104000200022O006A000500163O0006AE000400862O0100050004283O00862O012O006A000400084O009F000500033O00202O00050005003A4O000600076O000800016O00040008000200062O000400862O013O0004283O00862O012O006A000400093O0012DC0005003B3O0012DC0006003C4O0023010400064O002000046O006A000400173O000683000400AB2O013O0004283O00AB2O012O006A000400053O00204C00040004001E2O00220104000200022O006A000500183O0006AE000400AB2O0100050004283O00AB2O012O006A000400194O00D4000500093O00122O0006003D3O00122O0007003E6O00050007000200062O000400AB2O0100050004283O00AB2O012O006A000400143O0020C800040004003F00204C0004000400222O0022010400020002000683000400AB2O013O0004283O00AB2O012O006A000400084O009F000500033O00202O00050005003F4O000600076O000800016O00040008000200062O000400AB2O013O0004283O00AB2O012O006A000400093O001278000500403O00122O000600416O000400066O00045O00044O00AB2O010004283O00B200012O006A0003001A3O000683000300EF2O013O0004283O00EF2O012O006A000300023O0020C800030003002B00204C0003000300222O0022010300020002000683000300EF2O013O0004283O00EF2O012O006A000300053O00200200030003002C4O000500023O00202O00050005002D4O00030005000200062O000300EF2O013O0004283O00EF2O012O006A000300053O00204C00030003001E2O00220103000200022O006A0004000D3O000666000400EF2O0100030004283O00EF2O012O006A000300053O00204C0003000300422O0022010300020002000683000300EF2O013O0004283O00EF2O012O006A000300053O00204C0003000300432O0022010300020002000654000300EF2O0100010004283O00EF2O012O006A0003001B3O000683000300EF2O013O0004283O00EF2O012O006A0003001B3O00204C0003000300442O0022010300020002000683000300EF2O013O0004283O00EF2O012O006A0003001B3O00204C00030003001E2O00220103000200022O006A0004000D3O0006AE000300EF2O0100040004283O00EF2O012O006A0003001B3O00204C0003000300452O0022010300020002000654000300EF2O0100010004283O00EF2O012O006A000300053O00204C0003000300462O006A0005001B4O0007010300050002000654000300EF2O0100010004283O00EF2O012O006A000300084O006A000400033O0020C80004000400472O0022010300020002000683000300EF2O013O0004283O00EF2O012O006A000300093O0012DC000400483O0012DC000500494O0023010300054O002000036O006A0003001C4O00790003000100014O000300023O00202O00030003004A00202O00030003000E4O00030002000200062O0003002802013O0004283O002802012O006A000300023O0020C800030003004B00204C00030003004C2O002201030002000200065400030018020100010004283O001802012O006A000300023O0020C800030003004B00204C00030003004C2O00220103000200020006540003000F020100010004283O000F02012O006A000300053O00204D00030003000F4O000500023O00202O00050005004A4O00030005000200062O00030018020100010004283O001802012O006A000300053O00204C00030003004D2O0022010300020002000E75004E0018020100030004283O001802012O006A0003001D3O002603010300280201004F0004283O002802012O006A000300023O0020C800030003005000204C00030003004C2O00220103000200020006830003002802013O0004283O002802012O006A000300084O00FC000400023O00202O00040004004A4O0005000A3O00202O00050005005100122O000700526O0005000700024O000500056O00030005000200062O0003002802013O0004283O002802012O006A000300093O0012DC000400533O0012DC000500544O0023010300054O002000035O0012DC0002002A3O0026DE0002008E020100550004283O008E02012O006A0003001E3O000E5D0055004B020100030004283O004B02012O006A0003001E3O0026DE0003003F020100550004283O003F02012O006A000300053O00201C0103000300564O000500023O00202O0005000500574O00030005000200262O0003003F0201001A0004283O003F0201001259000300584O000B0103000100020026DE0003003F0201002A0004283O003F02012O006A0003001F3O0026120003004B0201001A0004283O004B02010012DC000300014O001A000400043O0026DE00030041020100010004283O004102012O006A000500204O000B0105000100022O0040000400053O0006830004004B02013O0004283O004B02012O00A6000400023O0004283O004B02010004283O004102012O006A000300213O0006830003006302013O0004283O006302012O006A000300053O00204C00030003000F2O006A000500224O00070103000500020006830003006302013O0004283O006302012O006A0003001E3O00260301030063020100590004283O006302010012DC000300014O001A000400043O000E3900010059020100030004283O005902012O006A000500234O000B0105000100022O0040000400053O0006830004006302013O0004283O006302012O00A6000400023O0004283O006302010004283O005902012O006A0003001F3O000E0B001A0078020100030004283O007802012O006A000300023O0020C800030003005A00204C00030003004C2O00220103000200020006830003007802013O0004283O007802010012DC000300014O001A000400043O0026DE0003006E020100010004283O006E02012O006A000500244O000B0105000100022O0040000400053O0006830004007802013O0004283O007802012O00A6000400023O0004283O007802010004283O006E02012O006A000300053O00204C00030003000F2O006A000500224O00070103000500020006830003007804013O0004283O007804012O006A0003001E3O00260301030078040100590004283O007804010012DC000300014O001A000400043O000E3900010083020100030004283O008302012O006A000500254O000B0105000100022O0040000400053O0006830004007804013O0004283O007804012O00A6000400023O0004283O007804010004283O008302010004283O007804010026DE0002002B030100020004283O002B03012O006A000300023O0020C800030003005B00204C0003000300222O0022010300020002000683000300BF02013O0004283O00BF02012O006A0003001E3O0026E5000300A70201002A0004283O00A702012O006A0003001E3O002603010300A2020100020004283O00A202012O006A000300053O00204C00030003002C2O006A000500224O0007010300050002000654000300A7020100010004283O00A702012O006A000300263O0020C800030003005C2O000B010300010002002603010300BF0201005D0004283O00BF02012O006A000300013O0020C200030003005E4O000400023O00202O00040004005B4O000500276O000600093O00122O0007005F3O00122O000800606O0006000800024O000700286O000800296O0009000A3O00202O00090009005100122O000B00526O0009000B00024O000900096O00030009000200062O000300BF02013O0004283O00BF02012O006A000300093O0012DC000400613O0012DC000500624O0023010300054O002000036O006A000300023O0020C800030003006300204C0003000300222O0022010300020002000683000300FB02013O0004283O00FB02012O006A000300053O00200200030003002C4O000500023O00202O0005000500644O00030005000200062O000300FB02013O0004283O00FB02012O006A0003001F3O002612000300DC0201001A0004283O00DC02012O006A000300023O0020C800030003005A00204C00030003004C2O0022010300020002000683000300DC02013O0004283O00DC02012O006A000300053O00200200030003000F4O000500023O00202O0005000500654O00030005000200062O000300FB02013O0004283O00FB02012O006A000300213O000683000300E302013O0004283O00E30201001259000300584O000B010300010002002612000300FB0201002A0004283O00FB02012O006A000300013O0020AB00030003005E4O000400023O00202O0004000400634O000500276O000600093O00122O000700663O00122O000800676O0006000800024O000700286O000800086O0009000A3O00202O00090009005100122O000B00526O0009000B00024O000900096O00030009000200062O000300FB02013O0004283O00FB02012O006A000300093O0012DC000400683O0012DC000500694O0023010300054O002000036O006A000300053O00204C00030003002C2O006A000500224O00070103000500020006830003000D03013O0004283O000D03010012DC000300014O001A000400043O000E390001002O030100030004283O002O03012O006A0005002A4O000B0105000100022O0040000400053O0006830004000D03013O0004283O000D03012O00A6000400023O0004283O000D03010004283O002O03012O006A0003001E3O0026DE0003002A030100550004283O002A03012O006A000300053O00200200030003002C4O000500023O00202O00050005006A4O00030005000200062O0003002A03013O0004283O002A03012O006A000300053O00204C00030003004D2O0022010300020002000E0B0007002A030100030004283O002A03012O006A0003001F3O0026DE0003002A0301001A0004283O002A03012O006A000300084O006A000400023O0020C800040004001B2O00220103000200020006830003002A03013O0004283O002A03012O006A000300093O0012DC0004006B3O0012DC0005006C4O0023010300054O002000035O0012DC000200553O0026DE000200E6030100010004283O00E603012O006A000300053O00204C00030003006D2O002201030002000200065400030091030100010004283O009103012O006A000300053O00204C00030003006E2O002201030002000200065400030091030100010004283O009103010012DC000300014O001A000400043O0026DE00030057030100550004283O005703012O006A000500053O00200200050005002C4O000700023O00202O0007000700144O00050007000200062O0005009103013O0004283O009103012O006A000500053O00204C00050005006F2O0022010500020002000E0B00010091030100050004283O009103010012DC000500013O000E3900010048030100050004283O004803012O006A000600013O0020870006000600704O000700023O00202O00070007007100122O000800526O0006000800024O000400063O00062O0004009103013O0004283O009103012O00A6000400023O0004283O009103010004283O004803010004283O009103010026DE000300640301002A0004283O006403012O006A000500013O0020870005000500704O000600023O00202O00060006007200122O000700526O0005000700024O000400053O00062O0004006303013O0004283O006303012O00A6000400023O0012DC000300023O0026DE000300750301001A0004283O007503012O006A000500013O00201D0105000500734O000600023O00202O00060006007400122O0007005D6O000800016O0009001B6O000A00033O00202O000A000A00754O0005000A00024O000400053O00062O0004007403013O0004283O007403012O00A6000400023O0012DC0003002A3O0026DE00030083030100010004283O008303012O006A000500013O00202B0105000500734O000600023O00202O00060006007400122O0007005D6O000800016O0005000800024O000400053O00062O0004008203013O0004283O008203012O00A6000400023O0012DC0003001A3O0026DE00030039030100020004283O003903012O006A000500013O0020870005000500704O000600023O00202O00060006007600122O000700526O0005000700024O000400053O00062O0004008F03013O0004283O008F03012O00A6000400023O0012DC000300553O0004283O003903012O006A0003002B3O000683000300BD03013O0004283O00BD03012O006A0003002C3O000683000300BD03013O0004283O00BD03012O006A000300023O0020C800030003007700204C0003000300222O0022010300020002000683000300BD03013O0004283O00BD03012O006A000300053O00204C00030003006D2O0022010300020002000654000300BD030100010004283O00BD03012O006A000300053O00204C00030003006E2O0022010300020002000654000300BD030100010004283O00BD03012O006A000300013O0020C80003000300782O006A0004000A4O0022010300020002000683000300BD03013O0004283O00BD03012O006A000300084O00FC000400023O00202O0004000400774O0005000A3O00202O00050005005100122O000700526O0005000700024O000500056O00030005000200062O000300BD03013O0004283O00BD03012O006A000300093O0012DC000400793O0012DC0005007A4O0023010300054O002000036O006A000300023O0020C800030003007B00204C00030003000E2O0022010300020002000683000300D403013O0004283O00D403012O006A000300053O00204C00030003000F2O006A000500224O0007010300050002000683000300D403013O0004283O00D403012O006A000300084O006A000400023O0020C800040004007B2O0022010300020002000683000300D403013O0004283O00D403012O006A000300093O0012DC0004007C3O0012DC0005007D4O0023010300054O002000036O006A000300023O0020C800030003001400204C00030003000E2O0022010300020002000683000300E503013O0004283O00E503012O006A000300084O006A000400023O0020C80004000400142O0022010300020002000683000300E503013O0004283O00E503012O006A000300093O0012DC0004007E3O0012DC0005007F4O0023010300054O002000035O0012DC0002001A3O0026DE000200AA0001002A0004283O00AA00012O006A000300023O0020C800030003008000204C0003000300222O00220103000200020006830003000B04013O0004283O000B04012O006A000300053O0020100103000300814O00058O000600016O00030006000200062O0003000B04013O0004283O000B04012O006A000300013O00203C0003000300824O000400023O00202O0004000400804O000500276O0006002D6O0007000A3O00202O00070007005100122O000900526O0007000900024O000700076O000800096O000A00033O00202O000A000A00834O0003000A000200062O0003000B04013O0004283O000B04012O006A000300093O0012DC000400843O0012DC000500854O0023010300054O002000036O006A000300023O0020C800030003008600204C0003000300222O00220103000200020006830003003804013O0004283O003804012O006A000300213O0006830003001804013O0004283O00180401001259000300584O000B010300010002002612000300380401002A0004283O003804012O006A000300023O0020C800030003008700204C00030003004C2O00220103000200020006830003002104013O0004283O002104012O006A0003001F3O0026DE000300380401001A0004283O003804012O006A000300013O00201D0003000300824O000400023O00202O0004000400864O0005002E6O0006002F6O0007000A3O00202O0007000700884O000900023O00202O0009000900864O0007000900024O000700076O000800096O000A00033O00202O000A000A00894O0003000A000200062O0003003804013O0004283O003804012O006A000300093O0012DC0004008A3O0012DC0005008B4O0023010300054O002000036O006A000300023O0020C800030003008600204C0003000300222O00220103000200020006830003006704013O0004283O006704012O006A000300023O0020C800030003008700204C00030003004C2O00220103000200020006830003006704013O0004283O006704012O006A0003001F3O000E0B001A0067040100030004283O006704012O006A000300213O0006830003004E04013O0004283O004E0401001259000300584O000B010300010002002612000300670401002A0004283O006704012O006A000300013O0020F700030003005E4O000400023O00202O0004000400864O0005002E6O000600093O00122O0007008C3O00122O0008008D6O0006000800024O000700306O000800316O0009000A3O00202O0009000900884O000B00023O00202O000B000B00864O0009000B00024O000900096O00030009000200062O0003006704013O0004283O006704012O006A000300093O0012DC0004008E3O0012DC0005008F4O0023010300054O002000036O006A000300323O0006830003007604013O0004283O007604010012DC000300014O001A000400043O0026DE0003006C040100010004283O006C04012O006A000500334O000B0105000100022O0040000400053O0006830004007604013O0004283O007604012O00A6000400023O0004283O007604010004283O006C04010012DC000200023O0004283O00AA00010012DC0001001A3O0004283O007D00010004283O004F05010026DE3O00E70401002A0004283O00E704012O006A000100053O0020AF00010001006F4O0001000200024O0001001E6O000100053O00202O0001000100904O0001000200024O000100346O000100013O00202O0001000100174O00010001000200062O0001008F040100010004283O008F04012O006A000100053O00204C00010001000C2O00222O0100020002000683000100A804013O0004283O00A804010012DC000100013O0026DE0001009B040100010004283O009B04012O006A000200263O00207D0002000200914O000300036O000400016O0002000400024O000200356O000200356O0002001D3O00122O0001001A3O000E39001A0090040100010004283O009004012O006A0002001D3O0026DE000200A8040100920004283O00A804012O006A000200263O0020F00002000200934O0003002E6O00048O0002000400024O0002001D3O00044O00A804010004283O009004012O006A0001001B3O000683000100E604013O0004283O00E604012O006A0001001B3O00204C0001000100442O00222O0100020002000683000100E604013O0004283O00E604012O006A0001001B3O00204C0001000100942O00222O0100020002000683000100E604013O0004283O00E604012O006A0001001B3O00204C0001000100452O00222O0100020002000683000100E604013O0004283O00E604012O006A000100053O00204C0001000100462O006A0003001B4O00072O0100030002000654000100E6040100010004283O00E604012O006A000100053O00204C00010001000C2O00222O0100020002000683000100D904013O0004283O00D904012O006A000100023O0020C800010001009500204C0001000100222O00222O0100020002000683000100E604013O0004283O00E604012O006A000100084O009F000200033O00202O0002000200964O000300036O000400016O00010004000200062O000100E604013O0004283O00E604012O006A000100093O001278000200973O00122O000300986O000100036O00015O00044O00E604012O006A000100084O009F000200033O00202O0002000200994O000300036O000400016O00010004000200062O000100E604013O0004283O00E604012O006A000100093O0012DC0002009A3O0012DC0003009B4O00232O0100034O002000015O0012DC3O00023O0026DE3O0004050100010004283O000405012O006A000100364O00082O010001000100122O0001009C3O00202O00010001009D4O000200093O00122O0003009E3O00122O0004009F6O0002000400024O0001000100024O000100063O00122O0001009C3O0020C800010001009D2O00BB000200093O00122O000300A03O00122O000400A16O0002000400024O0001000100024O000100373O0012330001009C3O00202O00010001009D4O000200093O00122O000300A23O00122O000400A36O0002000400024O0001000100024O000100323O00124O001A3O000E39001A000100013O0004283O000100010012590001009C3O00204B00010001009D4O000200093O00122O000300A43O00122O000400A56O0002000400024O0001000100024O0001002C6O000100053O00202O0001000100454O00010002000200062O0001001405013O0004283O001405012O002A3O00014O006A000100053O00204D00010001002C4O000300023O00202O0003000300A64O00010003000200062O00010020050100010004283O002005012O006A000100053O00204C0001000100A72O00222O01000200020006830001002105013O0004283O002105012O002A3O00014O006A000100373O0006830001003D05013O0004283O003D05010012DC000100013O000E39001A002E050100010004283O002E05012O006A000200274O0014000200026O000200386O0002002E6O000200026O0002001F3O00044O004D05010026DE00010025050100010004283O002505012O006A000200053O00202A0102000200A800122O000400526O0002000400024O000200276O000200053O00202O0002000200A800122O000400196O0002000400024O0002002E3O00122O0001001A3O0004283O002505010004283O004D05010012DC000100013O0026DE00010045050100010004283O004505012O001700026O002D000200274O001700026O002D0002002E3O0012DC0001001A3O0026DE0001003E0501001A0004283O003E05010012DC0002001A4O002D000200383O0012DC0002001A4O002D0002001F3O0004283O004D05010004283O003E05010012DC3O002A3O0004283O000100012O002A3O00017O000B3O00028O002O033O0052697003143O00526567697374657241757261547261636B696E6703053O005072696E7403193O000B31B7DD7AEFF394383DA19C74B697A32O3DA69C54A0D88B0603083O00E64D54C5BC16CFB7026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E031E3O00DF11D4FD80E1D427EC1DC2BC9AE1A165B74688ACDCE1D22CB936C9F3818A03083O00559974A69CECC190001B3O0012DC3O00013O0026DE3O000F000100010004283O000F00012O006A00015O00202700010001000200202O0001000100034O0001000200014O000100013O00202O0001000100044O000200023O00122O000300053O00122O000400066O000200046O00013O00010012DC3O00073O000E390007000100013O0004283O00010001001259000100083O00206E0001000100094O000200023O00122O0003000A3O00122O0004000B6O000200046O00013O000100044O001A00010004283O000100012O002A3O00017O00", GetFEnv(), ...);
