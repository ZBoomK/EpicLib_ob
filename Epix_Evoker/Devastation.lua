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
				if (Enum <= 163) then
					if (Enum <= 81) then
						if (Enum <= 40) then
							if (Enum <= 19) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum > 0) then
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
											else
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
										elseif (Enum == 3) then
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
									elseif (Enum <= 6) then
										if (Enum > 5) then
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
										elseif (Inst[2] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									elseif (Enum <= 7) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, Top);
										end
									elseif (Enum == 8) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
											return Unpack(Stk, A, A + Inst[3]);
										end
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum > 10) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
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
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum <= 12) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum == 13) then
										local B;
										local A;
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
									else
										local A = Inst[2];
										Stk[A] = Stk[A]();
									end
								elseif (Enum <= 16) then
									if (Enum == 15) then
										do
											return Stk[Inst[2]];
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
								elseif (Enum <= 17) then
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
								elseif (Enum > 18) then
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
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
									Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
								end
							elseif (Enum <= 29) then
								if (Enum <= 24) then
									if (Enum <= 21) then
										if (Enum == 20) then
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
									elseif (Enum <= 22) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									end
								elseif (Enum <= 26) then
									if (Enum > 25) then
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
								elseif (Enum <= 27) then
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
								elseif (Enum == 28) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 34) then
								if (Enum <= 31) then
									if (Enum > 30) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
								elseif (Enum == 33) then
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
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 37) then
								if (Enum <= 35) then
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
									if (Inst[2] > Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								end
							elseif (Enum <= 38) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 39) then
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
							end
						elseif (Enum <= 60) then
							if (Enum <= 50) then
								if (Enum <= 45) then
									if (Enum <= 42) then
										if (Enum > 41) then
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
									elseif (Enum <= 43) then
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
									elseif (Enum == 44) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 47) then
									if (Enum > 46) then
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
								elseif (Enum <= 48) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 49) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 55) then
								if (Enum <= 52) then
									if (Enum > 51) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 53) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum > 54) then
									local B = Stk[Inst[4]];
									if not B then
										VIP = VIP + 1;
									else
										Stk[Inst[2]] = B;
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
							elseif (Enum <= 57) then
								if (Enum > 56) then
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
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
									if (Stk[Inst[2]] > Inst[4]) then
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
							elseif (Enum <= 58) then
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
							elseif (Enum > 59) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 70) then
							if (Enum <= 65) then
								if (Enum <= 62) then
									if (Enum > 61) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									end
								elseif (Enum <= 63) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 67) then
								if (Enum == 66) then
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
								if (Stk[Inst[2]] > Inst[4]) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							end
						elseif (Enum <= 75) then
							if (Enum <= 72) then
								if (Enum > 71) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 73) then
								Stk[Inst[2]][Stk[Inst[3]]] = Inst[4];
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
						elseif (Enum <= 78) then
							if (Enum <= 76) then
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
							elseif (Enum == 77) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 79) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 80) then
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 122) then
						if (Enum <= 101) then
							if (Enum <= 91) then
								if (Enum <= 86) then
									if (Enum <= 83) then
										if (Enum > 82) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
										end
									elseif (Enum <= 84) then
										local B;
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
										A = Inst[2];
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
										Stk[Inst[2]] = Inst[3];
									elseif (Enum == 85) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 88) then
									if (Enum > 87) then
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum <= 89) then
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
								elseif (Enum > 90) then
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
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
								end
							elseif (Enum <= 96) then
								if (Enum <= 93) then
									if (Enum == 92) then
										Stk[Inst[2]] = Stk[Inst[3]] - Inst[4];
									else
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
									end
								elseif (Enum <= 94) then
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
								elseif (Enum > 95) then
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
								else
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
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 98) then
								if (Enum > 97) then
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
							elseif (Enum <= 99) then
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 100) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 111) then
							if (Enum <= 106) then
								if (Enum <= 103) then
									if (Enum == 102) then
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
								elseif (Enum <= 104) then
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 105) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 108) then
								if (Enum > 107) then
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
							elseif (Enum <= 109) then
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
							elseif (Enum == 110) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
								end
							else
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 116) then
							if (Enum <= 113) then
								if (Enum == 112) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 114) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 115) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
							end
						elseif (Enum <= 119) then
							if (Enum <= 117) then
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
							elseif (Enum > 118) then
								Stk[Inst[2]] = {};
							elseif (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 120) then
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
							if (Inst[2] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 121) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						end
					elseif (Enum <= 142) then
						if (Enum <= 132) then
							if (Enum <= 127) then
								if (Enum <= 124) then
									if (Enum == 123) then
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
									end
								elseif (Enum <= 125) then
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
								elseif (Enum == 126) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 129) then
								if (Enum == 128) then
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
							elseif (Enum <= 130) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 137) then
							if (Enum <= 134) then
								if (Enum == 133) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 135) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 136) then
								local B;
								local A;
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
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
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
						elseif (Enum <= 139) then
							if (Enum > 138) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 152) then
						if (Enum <= 147) then
							if (Enum <= 144) then
								if (Enum == 143) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 146) then
								Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
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
							end
						elseif (Enum <= 149) then
							if (Enum == 148) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							end
						elseif (Enum <= 150) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 151) then
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
							if (Inst[2] == Inst[4]) then
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
					elseif (Enum <= 157) then
						if (Enum <= 154) then
							if (Enum > 153) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 155) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 156) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 160) then
						if (Enum <= 158) then
							do
								return;
							end
						elseif (Enum > 159) then
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
					elseif (Enum <= 161) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 162) then
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
				elseif (Enum <= 245) then
					if (Enum <= 204) then
						if (Enum <= 183) then
							if (Enum <= 173) then
								if (Enum <= 168) then
									if (Enum <= 165) then
										if (Enum == 164) then
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
									elseif (Enum <= 166) then
										if (Stk[Inst[2]] ~= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 167) then
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
								elseif (Enum <= 170) then
									if (Enum == 169) then
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
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 171) then
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 172) then
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
								elseif not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 178) then
								if (Enum <= 175) then
									if (Enum > 174) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 176) then
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
									if (Inst[2] <= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 177) then
									Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
							elseif (Enum <= 180) then
								if (Enum > 179) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								else
									local Edx;
									local Results;
									local A;
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
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									VIP = Inst[3];
								end
							elseif (Enum <= 181) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 182) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 193) then
							if (Enum <= 188) then
								if (Enum <= 185) then
									if (Enum == 184) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 186) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 187) then
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
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 190) then
								if (Enum == 189) then
									Stk[Inst[2]]();
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
									VIP = Inst[3];
								end
							elseif (Enum <= 191) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 192) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Inst[2] > Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 198) then
							if (Enum <= 195) then
								if (Enum == 194) then
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
								elseif Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 197) then
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
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							end
						elseif (Enum <= 201) then
							if (Enum <= 199) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 200) then
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
						elseif (Enum <= 202) then
							local B;
							local A;
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
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Stk[Inst[4]]];
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
						elseif (Enum == 203) then
							if (Inst[2] ~= Inst[4]) then
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
					elseif (Enum <= 224) then
						if (Enum <= 214) then
							if (Enum <= 209) then
								if (Enum <= 206) then
									if (Enum > 205) then
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
										Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
									end
								elseif (Enum <= 207) then
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
								elseif (Enum > 208) then
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
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 211) then
								if (Enum == 210) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								end
							elseif (Enum <= 212) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 213) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 219) then
							if (Enum <= 216) then
								if (Enum == 215) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum == 218) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 221) then
							if (Enum == 220) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 222) then
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
						elseif (Enum == 223) then
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
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 234) then
						if (Enum <= 229) then
							if (Enum <= 226) then
								if (Enum > 225) then
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
							elseif (Enum <= 227) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 228) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 231) then
							if (Enum == 230) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 233) then
							Stk[Inst[2]] = Inst[3] ~= 0;
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
					elseif (Enum <= 239) then
						if (Enum <= 236) then
							if (Enum == 235) then
								local A = Inst[2];
								Top = (A + Varargsz) - 1;
								for Idx = A, Top do
									local VA = Vararg[Idx - A];
									Stk[Idx] = VA;
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
						end
					elseif (Enum <= 242) then
						if (Enum <= 240) then
							Env[Inst[3]] = Stk[Inst[2]];
						elseif (Enum > 241) then
							local B;
							local A;
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
						elseif (Inst[2] > Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 243) then
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
					elseif (Enum > 244) then
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
						Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
					end
				elseif (Enum <= 286) then
					if (Enum <= 265) then
						if (Enum <= 255) then
							if (Enum <= 250) then
								if (Enum <= 247) then
									if (Enum > 246) then
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
										if (Stk[Inst[2]] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 248) then
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
								elseif (Enum > 249) then
									Stk[Inst[2]] = #Stk[Inst[3]];
								else
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
								end
							elseif (Enum <= 252) then
								if (Enum == 251) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 253) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 254) then
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
						elseif (Enum <= 260) then
							if (Enum <= 257) then
								if (Enum > 256) then
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
								end
							elseif (Enum <= 258) then
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
							elseif (Enum > 259) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							end
						elseif (Enum <= 262) then
							if (Enum > 261) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 263) then
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 275) then
						if (Enum <= 270) then
							if (Enum <= 267) then
								if (Enum == 266) then
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
							elseif (Enum <= 268) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 269) then
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
						elseif (Enum <= 272) then
							if (Enum > 271) then
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
							else
								local Edx;
								local Results, Limit;
								local B;
								local A;
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
							end
						elseif (Enum <= 273) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 274) then
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						else
							do
								return Stk[Inst[2]]();
							end
						end
					elseif (Enum <= 280) then
						if (Enum <= 277) then
							if (Enum > 276) then
								Stk[Inst[2]] = Inst[3] ~= 0;
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
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 278) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 279) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 283) then
						if (Enum <= 281) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 282) then
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
						elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 284) then
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
					elseif (Enum == 285) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					end
				elseif (Enum <= 307) then
					if (Enum <= 296) then
						if (Enum <= 291) then
							if (Enum <= 288) then
								if (Enum == 287) then
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
							elseif (Enum <= 289) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 290) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 293) then
							if (Enum == 292) then
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
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
						elseif (Enum <= 294) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 295) then
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						else
							local A = Inst[2];
							local B = Inst[3];
							for Idx = A, B do
								Stk[Idx] = Vararg[Idx - A];
							end
						end
					elseif (Enum <= 301) then
						if (Enum <= 298) then
							if (Enum == 297) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 299) then
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
						elseif (Enum > 300) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
						end
					elseif (Enum <= 304) then
						if (Enum <= 302) then
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 305) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 306) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 317) then
					if (Enum <= 312) then
						if (Enum <= 309) then
							if (Enum > 308) then
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
						elseif (Enum <= 310) then
							local B = Inst[3];
							local K = Stk[B];
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
						elseif (Enum > 311) then
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						end
					elseif (Enum <= 314) then
						if (Enum > 313) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 315) then
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
					elseif (Enum == 316) then
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
				elseif (Enum <= 322) then
					if (Enum <= 319) then
						if (Enum == 318) then
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
						end
					elseif (Enum <= 320) then
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
					elseif (Enum > 321) then
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
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
				elseif (Enum <= 325) then
					if (Enum <= 323) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 324) then
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
				elseif (Enum <= 326) then
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
				elseif (Enum == 327) then
					local B;
					local A;
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Upvalues[Inst[3]];
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
						VIP = Inst[3];
					else
						VIP = VIP + 1;
					end
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD99ED111DAC6C91AC2BED11FC2D7DA31EFB4C950DDD6DA03083O007EB1A3BB4586DBA7031B3O00692AEAB636692CECA50C5E05C7AB1F4D29F7AF1D4535EDE005593B03053O00692C5A83CE002E3O0012D53O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A00010001000408012O000A00010012FB000300063O0020D70004000300070012FB000500083O0020D70005000500090012FB000600083O0020D700060006000A00060100073O000100062O007B3O00064O007B8O007B3O00044O007B3O00014O007B3O00024O007B3O00053O0020D700080003000B0020D700090003000C2O0077000A5O0012FB000B000D3O000601000C0001000100022O007B3O000A4O007B3O000B4O007B000D00073O00129D000E000E3O00129D000F000F4O002F000D000F0002000601000E0002000100032O007B3O00074O007B3O00094O007B3O00084O0059000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O009900025O00122O000300016O00045O00122O000500013O00042O0003002100012O002A01076O0075000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004320003000500012O002A010300054O007B000400024O00C6000300044O000700036O009E3O00017O00183O00028O00025O00108740025O009C9E40026O00F03F025O008CAD40025O002O9440025O002AA840025O0066A440025O0053B140025O002CA640025O0060A540025O00405D40025O003DB340025O0086AC40025O00C05A40025O0029B340025O00989540025O00288540025O00608F40025O0086AF40025O00E4A540025O00107740025O00649740025O0002A44001543O00129D000200014O004E000300053O002EA80002000900010003000408012O000900010026140002000900010001000408012O0009000100129D000300014O004E000400043O00129D000200043O002E33000500F9FF2O0005000408012O000200010026140002000200010004000408012O000200012O004E000500053O0026A60003001200010004000408012O00120001002E330006003900010007000408012O0049000100129D000600014O004E000700073O0026A60006001A00010001000408012O001A0001002EC00009001A00010008000408012O001A0001002E2A000A00140001000B000408012O0014000100129D000700013O0026A60007001F00010001000408012O001F0001002E2A000D001B0001000C000408012O001B0001002E33000E000A0001000E000408012O00290001002EA8000F002900010010000408012O00290001000E140104002900010004000408012O002900012O007B000800054O00EB00096O006E00086O000700085O002E2A0012001200010011000408012O00120001000EFC0001002F00010004000408012O002F0001002E2A0014001200010013000408012O0012000100129D000800013O000E140104003400010008000408012O0034000100129D000400043O000408012O001200010026A60008003800010001000408012O00380001002E2A0015003000010016000408012O003000012O002A01096O0028010500093O0006AD0005004100010001000408012O004100012O002A010900014O007B000A6O00EB000B6O006E00096O000700095O00129D000800043O000408012O00300001000408012O00120001000408012O001B0001000408012O00120001000408012O00140001000408012O00120001000408012O00530001002EA80017000E00010018000408012O000E00010026140003000E00010001000408012O000E000100129D000400014O004E000500053O00129D000300043O000408012O000E0001000408012O00530001000408012O000200012O009E3O00017O005B3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C2018852O033O00CC52B303043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A03043O0030ABD4D203073O005479DFB1BFED4C03043O009857DAB403083O00A1DB36A9C05A3050030B3O006A431331794D0F29404C0703043O0045292260030D3O009FC2C41E2325B2CCC30B162EB803063O004BDCA3B76A62030D3O0021BB9823EA17BD8C32CA16BF8F03053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03063O0029D851797B6503083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D982O033O000903B403043O004B6776D903073O00E45B7D19B610D403063O007EA7341074D903083O00ED382592AD16F2CD03073O009CA84E40E0D47903043O0005E1AAC203043O00AE678EC503043O006D6174682O033O005B294703073O009836483F58453E03063O00F1D2E157D1D603043O003CB4A48E030B3O007C5B132834F9134C570A2703073O0072383E6549478D03063O009DFFD4CFBDFB03043O00A4D889BB030B3O00F6E327B3B5EA0AC6EF3EBC03073O006BB28651D2C69E03063O001D188DCDAF2A03053O00CA586EE2A6030B3O00E70A94F6D9D70E96FEC5CD03053O00AAA36FE29703073O00323FBF3541393A03073O00497150D2582E5703083O00A43AC800FE8E22C803053O0087E14CAD72030C3O0047657445717569706D656E74026O002A40028O00026O002C4003113O003FFEABB5A2BEA23BF9ACA5A2B8AA1FE3AC03073O00C77A8DD8D0CCDD030B3O004973417661696C61626C65027O0040026O00F03F026O001040030C3O008FD111E36CD0B8CF1EF17BF303063O0096CDBD709018030A3O0054616C656E7452616E6B024O0080B3C54003103O005265676973746572466F724576656E7403183O009D5498B9169F479CB106844894A51D99479AA812835F9CA403053O0053CD18D9E0030E3O00D67E5526C97D4F29CD6F5E2DC06A03043O006A852E1003143O00740552CE74657C1F40CC7F6C741F5AD26574790203063O00203840139C3A03143O00697A6AC450B4B8397C716ED34AA3A92A7B7A6ED903083O006B39362B9D15E6E703063O0053657441504C025O00EC964000FB013O001F000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O0012C2000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O0012C20009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O0012C2000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00129D000D00123O00129D000E00134O002F000C000E00022O0028010C0004000C001206000D00046O000E5O00122O000F00143O00122O001000156O000E001000024O000E000D000E4O000F5O00122O001000163O00122O001100176O000F001100022O003A000F000D000F4O00105O00122O001100183O00122O001200196O0010001200024O0010000D00104O00115O00122O0012001A3O00122O0013001B6O0011001300022O003A0011000D00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000D00124O00135O00122O0014001E3O00122O0015001F6O0013001500022O00280113000D00132O002A01145O00129D001500203O00129D001600214O002F0014001600022O00280114000D00142O002A01155O0012C8001600223O00122O001700236O0015001700024O0014001400154O00155O00122O001600243O00122O001700256O0015001700024O0015000D00154O00165O00122O001700263O00122O001800276O0016001800024O0015001500164O00165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B6O0016001800024O0016000D00164O00175O00122O0018002C3O00122O0019002D6O0017001900024O0016001600174O00175O00122O0018002E3O00122O0019002F6O0017001900024O00160016001700122O001700306O00185O00122O001900313O00122O001A00326O0018001A00024O0017001700184O00185O00122O001900333O00122O001A00346O0018001A00024O0018000B00184O00195O00122O001A00353O00122O001B00366O0019001B00024O0018001800194O00195O00122O001A00373O00122O001B00386O0019001B00024O0019000C00194O001A5O00122O001B00393O00122O001C003A6O001A001C00024O00190019001A4O001A5O00122O001B003B3O00122O001C003C6O001A001C00024O001A0013001A4O001B5O00122O001C003D3O00122O001D003E6O001B001D00024O001A001A001B4O001B8O001C5O00122O001D003F3O00122O001E00406O001C001E00024O001C000D001C4O001D5O00122O001E00413O00122O001F00426O001D001F00022O0028011C001C001D2O0010011D8O001E8O001F8O00208O00218O0022003C3O00202O003D000700434O003D0002000200202O003E003D004400062O003E00B200013O000408012O00B200012O007B003E000C3O0020D7003F003D00442O00E0003E000200020006AD003E00B500010001000408012O00B500012O007B003E000C3O00129D003F00454O00E0003E000200020020D7003F003D00460006C3003F00BD00013O000408012O00BD00012O007B003F000C3O0020D70040003D00462O00E0003F000200020006AD003F00C000010001000408012O00C000012O007B003F000C3O00129D004000454O00E0003F000200022O004E004000424O003400435O00122O004400473O00122O004500486O0043004500024O00430018004300202O0043004300494O00430002000200062O004300CD00013O000408012O00CD000100129D0043004A3O0006AD004300CE00010001000408012O00CE000100129D0043004B3O00129D0044004A4O00B70045004A3O00122O004B004C3O00122O004C00446O004D5O00122O004E004D3O00122O004F004E6O004D004F00024O004D0018004D00202O004D004D004F4O004D000200022O004E004E004F4O001501505O00122O005100503O00122O005200506O005300543O00122O005500453O00122O005600453O00122O0057004B3O00122O0058004B6O005900593O000601005A3O000100022O002A017O007B3O00063O00200D015B00040051000601005D0001000100052O007B3O003F4O007B3O003D4O007B3O000C4O007B3O00074O007B3O003E4O002O015E5O00122O005F00523O00122O006000536O005E00606O005B3O000100202O005B00040051000601005D0002000100042O007B3O00434O007B3O00184O002A017O007B3O004D4O008B005E5O00122O005F00543O00122O006000556O005E006000024O005F5O00122O006000563O00122O006100576O005F00616O005B3O000100202O005B00040051000601005D0003000100042O007B3O00524O007B3O00144O002A017O007B3O00514O00F3005E5O00122O005F00583O00122O006000596O005E00606O005B3O0001000601005B0004000100042O007B3O00184O002A017O007B3O00144O007B3O00083O000601005C00050001000E2O007B3O003B4O002A017O007B3O00184O007B3O00094O007B3O00594O007B3O000E4O007B3O001A4O007B3O001C4O007B3O003C4O007B3O00124O007B3O00084O007B3O00544O007B3O004F4O007B3O004E3O000601005D0006000100102O007B3O00184O002A017O007B3O00074O007B3O00374O007B3O00364O007B3O00124O007B3O00194O007B3O002C4O007B3O002D4O007B3O001A4O007B3O00354O007B3O00344O007B3O000E4O007B3O00264O007B3O00284O007B3O00273O000601005E00070001000E2O007B3O00494O007B3O00424O007B3O00074O007B3O00184O002A012O00014O007B3O004A4O007B3O00154O002A017O007B3O00534O002A012O00024O007B3O00524O007B3O001C4O007B3O001B4O007B3O001F3O000601005F00080001000D2O007B3O00574O007B3O00554O007B3O00124O007B3O00184O007B3O00084O002A017O007B3O00424O002A012O00014O007B3O00154O002A012O00024O007B3O004A4O007B3O004E4O007B3O00493O000601006000090001000B2O007B3O00184O002A017O007B3O00084O007B3O00104O007B3O00564O007B3O00494O007B3O00424O007B3O004A4O007B3O004E4O007B3O005B4O007B3O00583O0006010061000A000100152O007B3O00494O007B3O00184O002A017O007B3O004B4O007B3O00074O007B3O004F4O007B3O00424O007B3O00084O007B3O00524O007B3O005F4O007B3O001F4O007B3O001C4O007B3O00124O007B3O001A4O007B3O00434O002A012O00014O007B3O00154O002A012O00024O007B3O00484O007B3O00604O007B3O00543O0006010062000B000100192O007B3O00184O002A017O007B3O00124O007B3O00084O007B3O00484O007B3O004C4O007B3O00074O007B3O004F4O007B3O00494O007B3O00524O007B3O00604O007B3O004A4O007B3O000E4O007B3O00434O007B3O00544O007B3O001F4O007B3O00534O007B3O005F4O002A012O00014O007B3O00154O002A012O00024O007B3O005B4O007B3O00424O007B3O001C4O007B3O001A3O0006010063000C0001000A2O007B3O00234O002A017O007B3O00184O007B3O00074O007B3O00254O007B3O000E4O007B3O001A4O007B3O00094O007B3O00224O007B3O00243O0006010064000D000100082O007B3O00094O007B3O001C4O007B3O00184O002A017O007B3O00124O007B3O001A4O007B3O00334O007B3O00083O0006010065000E0001001C2O007B3O00364O002A017O007B3O00374O007B3O00384O007B3O00394O007B3O00344O007B3O00354O007B3O00324O007B3O00334O007B3O002C4O007B3O002D4O007B3O002A4O007B3O002B4O007B3O003A4O007B3O003B4O007B3O003C4O007B3O002E4O007B3O002F4O007B3O00304O007B3O00314O007B3O00284O007B3O00294O007B3O00264O007B3O00274O007B3O00244O007B3O00254O007B3O00224O007B3O00233O0006010066000F000100352O007B3O00074O007B3O005D4O007B3O001D4O007B3O001C4O007B3O00184O007B3O001A4O007B3O00484O007B3O00174O002A017O007B3O00534O007B3O00084O007B3O00124O007B3O002B4O007B3O002A4O007B3O00644O007B3O001F4O007B3O005E4O007B3O00424O007B3O00614O007B3O00624O007B3O002E4O007B3O002F4O007B3O00204O007B3O00634O007B3O00384O007B3O00394O007B3O003B4O007B3O00094O007B3O00594O007B3O000E4O007B3O003C4O007B3O00574O007B3O00044O007B3O00544O007B3O00584O007B3O00294O007B3O005C4O002A012O00014O002A012O00024O007B3O004E4O007B3O004F4O007B3O00494O007B3O004A4O007B3O005A4O007B3O00224O007B3O00234O007B3O00214O007B3O00404O007B3O00414O007B3O001E4O007B3O00514O007B3O00524O007B3O00653O00060100670010000100032O002A017O007B3O001C4O007B3O000D3O0020210068000D005A00122O0069005B6O006A00666O006B00676O0068006B00016O00013O00113O00233O00028O00025O00388C40025O003EA540027O0040025O00808940025O00C09A40026O00F03F025O00C2A040025O0067B24003053O00706169727303063O0045786973747303163O00556E697447726F7570526F6C6573412O7369676E656403063O006FE914F0217503053O006427AC55BC025O005AA540025O0036A740025O004EA440025O00A4AF40025O00F0B240025O00DDB040025O00C89F40025O00C0A740025O00B0B140030A3O00556E6974496E5261696403063O003588BE55019A03083O007045E4DF2C64E87103043O00E61E0ED703073O00E6B47F67B3D61C030B3O00556E6974496E506172747903063O009C095E5FE15303073O0080EC653F26842103053O009CA80350AF03073O00AFCCC97124D68B025O0058A040025O000AA040005D3O00129D3O00014O004E000100023O002E2A0002000900010003000408012O000900010026A63O000800010004000408012O00080001002E2A0006000900010005000408012O000900012O000F000200023O0026A63O000D00010007000408012O000D0001002E2A0009002500010008000408012O002500012O004E000200023O0012FB0003000A4O007B000400014O0013000300020005000408012O0022000100200D01080007000B2O00E00008000200020006C30008001F00013O000408012O001F00010012FB0008000C4O007B000900064O00E00008000200022O001701095O00122O000A000D3O00122O000B000E6O0009000B000200062O0008002100010009000408012O00210001002E33000F000300010010000408012O002200012O007B000200073O00063D0103001200010002000408012O0012000100129D3O00043O002E2A0011002900010012000408012O00290001000EFC0001002B00013O000408012O002B0001002EA80013000200010014000408012O0002000100129D000300013O002E330015002800010015000408012O00540001000E142O01005400010003000408012O005400012O004E000100013O002E2A0016004200010017000408012O004200010012FB000400184O005B00055O00122O000600193O00122O0007001A6O000500076O00043O000200062O0004004200013O000408012O004200012O002A010400014O005300055O00122O0006001B3O00122O0007001C6O0005000700024O00010004000500044O005300010012FB0004001D4O005B00055O00122O0006001E3O00122O0007001F6O000500076O00043O000200062O0004005100013O000408012O005100012O002A010400014O005300055O00122O000600203O00122O000700216O0005000700024O00010004000500044O005300012O00EA00046O000F000400023O00129D000300073O0026A60003005800010007000408012O00580001002EA80022002C00010023000408012O002C000100129D3O00073O000408012O00020001000408012O002C0001000408012O000200012O009E3O00017O000B3O00028O00025O0090A040025O00BFB240026O00F03F026O002C40025O00088440025O00BBB240025O00BAB140025O00507840030C3O0047657445717569706D656E74026O002A40002F3O00129D3O00013O002E2A0002001400010003000408012O001400010026143O001400010004000408012O001400012O002A2O0100013O0020D70001000100050006C30001000F00013O000408012O000F00012O002A2O0100024O002A010200013O0020D70002000200052O00E00001000200020006AD0001001200010001000408012O001200012O002A2O0100023O00129D000200014O00E00001000200022O007300015O000408012O002E0001002E2A0006000100010007000408012O000100010026A63O001A00010001000408012O001A0001002EA80008000100010009000408012O000100012O002A2O0100033O0020A200010001000A4O0001000200024O000100016O000100013O00202O00010001000B00062O0001002800013O000408012O002800012O002A2O0100024O002A010200013O0020D700020002000B2O00E00001000200020006AD0001002B00010001000408012O002B00012O002A2O0100023O00129D000200014O00E00001000200022O0073000100043O00129D3O00043O000408012O000100012O009E3O00017O000D3O00028O00025O00E07040025O00D89840025O00649940025O00C4934003113O00C3D6DE38E8C6C81CF2D1D833E32OC833F203043O005D86A5AD030B3O004973417661696C61626C65027O0040026O00F03F030C3O009CFEC0D12EE8A76CB0F3C2C703083O001EDE92A1A25AAED2030A3O0054616C656E7452616E6B00283O00129D3O00014O004E000100013O002EA80002000200010003000408012O000200010026143O000200010001000408012O0002000100129D000100013O002E2A0005000700010004000408012O000700010026140001000700010001000408012O000700012O002A010200014O0034000300023O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002001800013O000408012O0018000100129D000200093O0006AD0002001900010001000408012O0019000100129D0002000A4O007300026O00BE000200016O000300023O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O0002000200024O000200033O00044O00270001000408012O00070001000408012O00270001000408012O000200012O009E3O00017O001B3O00028O00026O00F03F025O00804940025O00C08C40025O0030A740025O00389F40025O00A4AB40025O00809240025O001AA840025O006CA540025O00C4AD40025O00A7B240024O0080B3C54003053O00706169727303103O004669726573746F726D547261636B657203103O007CC1F75349E68F48C5D1445BF18B5FDA03073O00E03AA885363A9200025O00807740025O0046A040025O0092AA40025O004EA140025O00FAA340025O005FB040025O00409340025O001CA240025O003C9E40004C3O00129D3O00014O004E000100033O0026A63O000600010002000408012O00060001002EA80004004300010003000408012O004300012O004E000300033O0026A60001000D00010002000408012O000D0001002EC00005000D00010006000408012O000D0001002EA80007003A00010008000408012O003A00010026A60002001300010002000408012O00130001002EC0000900130001000A000408012O00130001002E2A000C00240001000B000408012O0024000100129D0004000D4O00B300045O00122O0004000E6O000500013O00202O00050005000F4O00040002000600044O002100012O002A010800014O0012000900023O00122O000A00103O00122O000B00116O0009000B00024O00080008000900202O00080007001200063D0104001A00010001000408012O001A0001000408012O004B00010026140002000D00010001000408012O000D000100129D000400013O0026A60004002D00010002000408012O002D0001002EC00014002D00010013000408012O002D0001002EA80015002F00010016000408012O002F000100129D000200023O000408012O000D0001002E33001700F8FF2O0017000408012O002700010026140004002700010001000408012O002700012O00EA00035O00129D0005000D4O0073000500033O00129D000400023O000408012O00270001000408012O000D0001000408012O004B0001002E2A0019000700010018000408012O000700010026140001000700010001000408012O0007000100129D000200014O004E000300033O00129D000100023O000408012O00070001000408012O004B00010026A63O004700010001000408012O00470001002EA8001A00020001001B000408012O0002000100129D000100014O004E000200023O00129D3O00023O000408012O000200012O009E3O00017O00183O00028O00025O00F2AA40025O00849740025O0009B340025O0050AE40025O00B6B14003093O00FD8203F0AAC8C0C98603073O00AFBBEB7195D9BC03113O0054696D6553696E63654C61737443617374026O00284003103O001AA69349F06D772EA2B55EE27A7339BD03073O00185CCFE12C831903043O004755494403103O006DDAAA49086944C1B578097C48D8BD5E03063O001D2BB3D82C7B03073O0047657454696D65026O000440025O0080A240025O00DAA340025O00149540025O00409540026O00F03F025O007DB240025O0007B040004E3O00129D3O00014O004E000100013O002E3300023O00010002000408012O000200010026A63O000800010001000408012O00080001002E2A0004000200010003000408012O0002000100129D000100013O0026140001004600010001000408012O0046000100129D000200013O000E142O01003F00010002000408012O003F0001002E2A0005001C00010006000408012O001C00012O002A01036O008D000400013O00122O000500073O00122O000600086O0004000600024O00030003000400202O0003000300094O000300020002000E2O000A001C00010003000408012O001C00012O00EA00036O000F000300024O002A010300024O0029010400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400033O00202O00040004000D4O0004000200024O00030003000400062O0003003E00013O000408012O003E00012O002A010300024O0037010400013O00122O0005000E3O00122O0006000F6O0004000600024O0003000300044O000400033O00202O00040004000D4O0004000200024O00030003000400122O000400106O00040001000200202O00040004001100062O0003000800010004000408012O003E0001002EC00013003E00010012000408012O003E0001002EA80015003C00010014000408012O003C0001000408012O003E00012O00EA000300014O000F000300023O00129D000200163O0026A60002004300010016000408012O00430001002EA80017000C00010018000408012O000C000100129D000100163O000408012O00460001000408012O000C00010026140001000900010016000408012O000900012O00EA00026O000F000200023O000408012O00090001000408012O004D0001000408012O000200012O009E3O00017O00693O00028O00025O00C4AD40025O00588840025O00DC9240025O00B1B040025O00EEA240025O00BC9140025O00549F40025O00C2A340025O00D08E40025O000AAC4003043O009CCC344303043O002CDDB940030D3O0032E85D4D7004E84E2O7206EE4B03053O00136187283F030A3O0049734361737461626C6503093O004973496E52616E6765026O00394003043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O005EA840025O00E07A40025O0068B240026O00A740025O00D2A240025O0026A94003123O00536F757263656F664D61676963466F637573025O00EAB140025O001EA04003193O00BD5326292C34915335042230A955307B3F23AB5F3C362D30BA03063O0051CE3C535B4F03083O007DAEDC772CD748A003083O00C42ECBB0124FA32D025O005EA940026O00F03F025O00108C40025O00BCA540025O008C9B40025O006C9B40025O0094A140025O00909B40025O00C6AA40025O00CEA04003093O004E616D6564556E6974025O00A88540030D3O008B2D6B0C27FEE0BE0F7F192DF803073O008FD8421E7E449B03113O00536F757263656F664D616769634E616D65025O00607B40025O00EAAD40025O00E8A74003193O00B9C718D9C6A6E8EEACF700CAC2AAD4A1BADA08C8CAAED5E0BE03083O0081CAA86DABA5C3B7025O005C9B40025O000C9640025O0056B040025O00406F40025O00307740025O003AB240025O00188340025O0016B140025O00689540027O0040025O007EAB40025O007AA840030B3O00D1BA464C72D8DBBF51487903063O00BF9DD330251C03093O00F916E61929CB10E61103053O005ABF7F947C030B3O004973417661696C61626C65025O0081B240025O00ADB140025O0084B340025O0071B240030B3O004C6976696E67466C616D6503163O00748E381E76802O117486231238973C127B882315799303043O007718E74E025O000FB140025O002EAD40030B3O00A337B058D973059024AE4F03073O0071E24DC52ABC20030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E676503163O003B0CE1A73F29E7A1281FFFB07A06E6B03919F9B73B0203043O00D55A7694025O006EAF40025O003EA540025O00F4A240025O00606E40025O00A4B140025O003EAD40025O00389D4003093O00045125DDCD00E9305503073O0086423857B8BE74026O003540025O00CC9E4003093O004669726573746F726D03133O003A381BBE0AFF2E27317119A91CE82E383E301D03083O00555C5169DB798B41025O00A07240025O00ECA940025O00D4A640025O00907B40003D012O00129D3O00014O004E000100013O002EA80003000200010002000408012O000200010026A63O000800010001000408012O00080001002E33000400FCFF2O0005000408012O0002000100129D000100013O000E142O0100B500010001000408012O00B5000100129D000200013O0026A60002001000010001000408012O00100001002E33000600A000010007000408012O00AE000100129D000300013O000EFC0001001500010003000408012O00150001002E330008009200010009000408012O00A50001002E2A000A004E0001000B000408012O004E00012O002A01046O0005010500013O00122O0006000C3O00122O0007000D6O00050007000200062O0004004E00010005000408012O004E00012O002A010400024O0034000500013O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004003B00013O000408012O003B00012O002A010400033O00200D01040004001100129D000600124O002F0004000600020006C30004003B00013O000408012O003B00012O002A010400044O002A010500033O00200D0105000500132O00E00005000200020006AB0004003B00010005000408012O003B00012O002A010400033O0020350004000400144O000600023O00202O0006000600154O00040006000200262O0004003F00010016000408012O003F0001002ECB0017003F00010018000408012O003F0001002EA80019004E0001001A000408012O004E0001002EA8001B00470001001C000408012O004700012O002A010400054O002A010500063O0020D700050005001D2O00E00004000200020006AD0004004900010001000408012O00490001002EA8001E004E0001001F000408012O004E00012O002A010400013O00129D000500203O00129D000600214O00C6000400064O000700046O002A01046O0005010500013O00122O000600223O00122O000700236O00050007000200062O000400A400010005000408012O00A40001002EA8000B005800010024000408012O00580001000408012O00A4000100129D000400014O004E000500073O0026140004009C00010025000408012O009C00012O004E000700073O000EFC0001006300010005000408012O00630001002E050027006300010026000408012O00630001002E2A0028006600010029000408012O0066000100129D000600014O004E000700073O00129D000500253O0026A60005006C00010025000408012O006C0001002EC0002A006C0001002B000408012O006C0001002E2A002C005D0001002D000408012O005D00010026140006006C00010001000408012O006C00012O002A010800073O00209800080008002E00122O000900126O000A00086O0008000A00024O000700083O002E2O002F00300001002F000408012O00A400010006C3000700A400013O000408012O00A400012O002A010800024O0034000900013O00122O000A00303O00122O000B00316O0009000B00024O00080008000900202O0008000800104O00080002000200062O000800A400013O000408012O00A4000100200D0108000700142O002A010A00023O0020D7000A000A00152O002F0008000A000200262D010800A400010016000408012O00A400012O002A010800054O002A010900063O0020D70009000900322O00E00008000200020006AD0008009200010001000408012O00920001002ECB0009009200010033000408012O00920001002E330034001400010035000408012O00A400012O002A010800013O001280000900363O00122O000A00376O0008000A6O00085O00044O00A40001000408012O006C0001000408012O00A40001000408012O005D0001000408012O00A40001002E2A0039005A00010038000408012O005A00010026140004005A00010001000408012O005A000100129D000500014O004E000600063O00129D000400253O000408012O005A000100129D000300253O002E33003A00040001003A000408012O00A900010026A6000300AB00010025000408012O00AB0001002E33003B0068FF2O003C000408012O0011000100129D000200253O000408012O00AE0001000408012O001100010026A6000200B200010025000408012O00B20001002EA8003D000C0001003E000408012O000C000100129D000100253O000408012O00B50001000408012O000C0001002E2A004000022O01003F000408012O00022O01002614000100022O010041000408012O00022O01002E2A004300E400010042000408012O00E400012O002A010200024O0034000300013O00122O000400443O00122O000500456O0003000500024O00020002000300202O0002000200104O00020002000200062O000200CF00013O000408012O00CF00012O002A010200024O0034000300013O00122O000400463O00122O000500476O0003000500024O00020002000300202O0002000200484O00020002000200062O000200D100013O000408012O00D10001002EA8004900E40001004A000408012O00E40001002E2A004C00E40001004B000408012O00E400012O002A010200094O00AC000300023O00202O00030003004D4O0004000A3O00202O00040004001100122O000600126O0004000600024O000400046O0005000B6O00020005000200062O000200E400013O000408012O00E400012O002A010200013O00129D0003004E3O00129D0004004F4O00C6000200044O000700025O002EA80051003C2O010050000408012O003C2O012O002A010200024O0034000300013O00122O000400523O00122O000500536O0003000500024O00020002000300202O0002000200104O00020002000200062O0002003C2O013O000408012O003C2O012O002A010200094O0046010300023O00202O0003000300544O0004000A3O00202O0004000400554O000600023O00202O0006000600544O0004000600024O000400046O00020004000200062O0002003C2O013O000408012O003C2O012O002A010200013O001280000300563O00122O000400576O000200046O00025O00044O003C2O01002EA80059000900010058000408012O00090001002E33005A0005FF2O005A000408012O00090001000E140125000900010001000408012O0009000100129D000200013O002EA8005B00302O01005C000408012O00302O01002614000200302O010001000408012O00302O012O002A0103000D3O00105D0003002500032O00730003000C3O002EA8005E002F2O01005D000408012O002F2O012O002A010300024O0034000400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O0003000300104O00030002000200062O0003002F2O013O000408012O002F2O01002E2A0061002F2O010062000408012O002F2O012O002A010300094O00AC000400023O00202O0004000400634O0005000A3O00202O00050005001100122O000700126O0005000700024O000500056O0006000B6O00030006000200062O0003002F2O013O000408012O002F2O012O002A010300013O00129D000400643O00129D000500654O00C6000300054O000700035O00129D000200253O002EA8006600092O010067000408012O00092O010026A6000200362O010025000408012O00362O01002EA8006800092O010069000408012O00092O0100129D000100413O000408012O00090001000408012O00092O01000408012O00090001000408012O003C2O01000408012O000200012O009E3O00017O00463O00028O00025O00109240025O0040A940025O0050AC40025O00C09140025O00488840025O00C4A340025O00EC9F40025O00AEA440026O00F03F025O00207640025O00F89740025O0042AD40025O0036A540025O0068AD40025O000CB340025O00B8AC40025O00F88540025O004EB340025O00CC9A40025O00C6AD40025O00F07340030E3O00742CA75F49522FBA654E5A22B14503053O002D3B4ED436030A3O0049734361737461626C6503083O0042752O66446F776E030E3O004F6273696469616E5363616C657303103O004865616C746850657263656E74616765025O003EA740025O0048B140025O00804740025O00089140031A3O001F54902O8227ACFE2F45802O8A2BBEB01453858E883DA4E6154503083O00907036E3EBE64ECD025O00A4A640025O00F09040030B3O009B2D0EF0C453A03C00F2D503063O003BD3486F9CB003073O0049735265616479030B3O004865616C746873746F6E65025O00C05940025O00EEAF4003173O004682E2215A8FF0394189E66D4A82E5284094EA3B4BC7B003043O004D2EE783025O00B8A740025O002CA440030D3O008851B845AD5DB8479858B75ABF03043O0020DA34D6025O006C9540025O00A8A640025O00E06F40026O008340030D3O0052656E6577696E67426C617A65025O00989140025O00807F40025O001CAF40025O00F8A64003143O007C123FADE6B94B5D6C1B30B2F4F0485B471971FE03083O003A2E7751C891D02503193O00198936BEACAE3E228237EC81B83727853EABE98D393F853FA203073O00564BEC50CCC9DD03173O0040447197FB987A487982D68E734D7E8BF9BB7D557E8AF003063O00EB122117E59E025O009EAD40025O004CB24003173O0052656672657368696E674865616C696E67506F74696F6E025O0028AD40025O0020684003253O0042BFC7A955A9C9B25EBD81B355BBCDB25EBD81AB5FAEC8B45EFAC5BE56BFCFA859ACC4FB0403043O00DB30DAA100D43O00129D3O00014O004E000100013O002E2A0002000200010003000408012O00020001002EA80005000200010004000408012O000200010026143O000200010001000408012O0002000100129D000100013O002E2A0006007900010007000408012O00790001002E2A0008007900010009000408012O007900010026140001007900010001000408012O0079000100129D000200013O0026A6000200140001000A000408012O00140001002EA8000C00160001000B000408012O0016000100129D0001000A3O000408012O00790001002EA8000E00100001000D000408012O001000010026140002001000010001000408012O0010000100129D000300013O000EFC000A001F00010003000408012O001F0001002EA8001000210001000F000408012O0021000100129D0002000A3O000408012O00100001002EA80012002500010011000408012O002500010026A60003002700010001000408012O00270001002E33001300F6FF2O0014000408012O001B0001002E2A0016004300010015000408012O004300012O002A01046O0034000500013O00122O000600173O00122O000700186O0005000700024O00040004000500202O0004000400194O00040002000200062O0004004300013O000408012O004300012O002A010400023O00204701040004001A4O00065O00202O00060006001B4O00040006000200062O0004004300013O000408012O004300012O002A010400023O00200D01040004001C2O00E00004000200022O002A010500033O0006630004004300010005000408012O004300012O002A010400043O0006AD0004004500010001000408012O00450001002E2A001E00520001001D000408012O00520001002E2A001F005200010020000408012O005200012O002A010400054O002A01055O0020D700050005001B2O00E00004000200020006C30004005200013O000408012O005200012O002A010400013O00129D000500213O00129D000600224O00C6000400064O000700045O002EA80024007600010023000408012O007600012O002A010400064O0034000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O0004000400274O00040002000200062O0004007600013O000408012O007600012O002A010400073O0006C30004007600013O000408012O007600012O002A010400023O00200D01040004001C2O00E00004000200022O002A010500083O00063E0104007600010005000408012O007600012O002A010400054O0085000500093O00202O0005000500284O000600076O000800016O00040008000200062O0004007100010001000408012O00710001002E33002900070001002A000408012O007600012O002A010400013O00129D0005002B3O00129D0006002C4O00C6000400064O000700045O00129D0003000A3O000408012O001B0001000408012O00100001002E2A002E00090001002D000408012O00090001002614000100090001000A000408012O000900012O002A01026O0034000300013O00122O0004002F3O00122O000500306O0003000500024O00020002000300202O0002000200194O00020002000200062O0002009000013O000408012O009000012O002A010200023O00200D01020002001C2O00E00002000200022O002A0103000A3O0006630002009000010003000408012O009000012O002A0102000B3O0006AD0002009400010001000408012O00940001002EC00032009400010031000408012O00940001002E2A003400A400010033000408012O00A400012O002A0102000C4O002700035O00202O0003000300354O000400056O00020005000200062O0002009F00010001000408012O009F0001002EC00036009F00010037000408012O009F0001002EA8003800A400010039000408012O00A400012O002A010200013O00129D0003003A3O00129D0004003B4O00C6000200044O000700026O002A0102000D3O0006C3000200D300013O000408012O00D300012O002A010200023O00200D01020002001C2O00E00002000200022O002A0103000E3O00063E010200D300010003000408012O00D300012O002A0102000F4O0005010300013O00122O0004003C3O00122O0005003D6O00030005000200062O000200D300010003000408012O00D300012O002A010200064O00D2000300013O00122O0004003E3O00122O0005003F6O0003000500024O00020002000300202O0002000200274O00020002000200062O000200C000010001000408012O00C00001002E2A004100D300010040000408012O00D300012O002A010200054O0085000300093O00202O0003000300424O000400056O000600016O00020006000200062O000200CA00010001000408012O00CA0001002E330043000B00010044000408012O00D300012O002A010200013O001280000300453O00122O000400466O000200046O00025O00044O00D30001000408012O00090001000408012O00D30001000408012O000200012O009E3O00017O00213O00026O00084003083O0042752O66446F776E03153O0053706F696C736F664E656C74686172757356657273030D3O00C165795BD546F4FD42695BDC4A03073O008084111C29BB2F030F3O00432O6F6C646F776E52656D61696E73027O0040030A3O00273B143F7F1337072E5503053O003D6152665A026O001040026O003240026O003440025O00DEA640025O00388E40028O00025O0020AA40025O00D2A940026O00F03F030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O008AA640025O00149E40025O00BEB140025O00E89840025O00B88340025O00E2A640025O00207540025O0062AB40025O0040514003103O0048616E646C65546F705472696E6B6574025O00507540025O00E8AE4000A64O002A016O0006C33O005A00013O000408012O005A00012O002A012O00013O000EF10001005F00013O000408012O005F00012O002A012O00023O00201D014O00024O000200033O00202O0002000200036O0002000200064O005F00010001000408012O005F00012O002A012O00044O00222O0100056O000200066O000300036O000400073O00122O000500043O00122O000600056O0004000600024O00030003000400202O0003000300064O0003000200024O000400083O00202O0004000400074O000500066O000600036O000700073O00122O000800083O00122O000900096O0007000900024O00060006000700202O0006000600064O0006000200024O000700083O00202O00070007000700062O0006000200010007000408012O002800012O002C01066O00EA000600014O00E00005000200022O003D0004000400050006240103000200010004000408012O002E00012O002C01036O00EA000300014O00DE00020002000200102O0002000A00026O000200024O000100096O000200056O000300066O000400036O000500073O00122O000600043O00122O000700056O0005000700024O00040004000500202O0004000400064O0004000200024O000500083O00202O0005000500074O000600066O000700036O000800073O00122O000900083O00122O000A00096O0008000A00024O00070007000800202O0007000700064O0007000200024O000800083O00202O00080008000700062O0007000200010008000408012O004D00012O002C01076O00EA000700014O00E00006000200022O003D0005000500060006240104000200010005000408012O005300012O002C01046O00EA000400014O003900030002000200102O0003000A00034O0001000300028O000100264O005F0001000B000408012O005F00012O002A012O000A3O0026443O005F0001000C000408012O005F0001002EA8000D00A50001000E000408012O00A5000100129D3O000F4O004E000100013O0026143O00610001000F000408012O0061000100129D0001000F3O002EA80011007600010010000408012O007600010026140001007600010012000408012O007600012O002A0102000B3O0020C90002000200144O0003000C6O0004000D3O00122O000500156O000600066O00020006000200122O000200133O00122O000200133O00062O000200A500013O000408012O00A500010012FB000200134O000F000200023O000408012O00A50001002614000100640001000F000408012O0064000100129D0002000F3O0026A60002007D00010012000408012O007D0001002E2A0016007F00010017000408012O007F000100129D000100123O000408012O00640001000EFC000F008500010002000408012O00850001002EC00018008500010019000408012O00850001002E2A001B00790001001A000408012O0079000100129D0003000F3O002EA8001C008C0001001D000408012O008C00010026140003008C00010012000408012O008C000100129D000200123O000408012O00790001002E33001E00FAFF2O001E000408012O00860001002614000300860001000F000408012O008600012O002A0104000B3O00200200040004001F4O0005000C6O0006000D3O00122O000700156O000800086O00040008000200122O000400133O00122O000400133O00062O0004009D00010001000408012O009D0001002E2A0021009F00010020000408012O009F00010012FB000400134O000F000400023O00129D000300123O000408012O00860001000408012O00790001000408012O00640001000408012O00A50001000408012O006100012O009E3O00017O002D3O00028O00026O00F03F025O00EAB240025O00689740030D3O00457465726E697479537572676503093O004973496E52616E6765026O003E4003173O00F2E739C0F9FA28CBC8E029C0F0F67CD7FAE333C5F2E17C03043O00B297935C025O00809440025O0056B340025O00408A40025O00EC9240025O0093B140025O00C09840030D3O00893AAE59C95E0A109F3BB94CC203083O0069CC4ECB2BA7377E030C3O00432O6F6C646F776E446F776E026O008540026O007740030D3O0080BE260C1D0DD348B699331F1D03083O0031C5CA437E7364A7030B3O004973417661696C61626C65026O00FC3F026O001440030D3O00124FDA3B8E5F4A2E48EC39815803073O003E573BBF49E036026O001840030D3O00C216FFDBE90BEED0F431EAC8E903043O00A987629A026O002040025O00D88F40027O0040030D3O00EE632146F33ADCD2641744FC3D03073O00A8AB1744349D53026O000440025O00F8AC40025O007DB040026O000840030D3O00D165F0BF2B2493ED62C6BD242303073O00E7941195CD454D030B3O00A6A8C9EF58F9ADA6C0F25403063O009FE0C7A79B37026O000A40026O00104000F73O00129D3O00013O0026A63O000500010002000408012O00050001002EA80003001B00010004000408012O001B00012O002A2O0100014O009500018O000100026O000200033O00202O0002000200054O000300043O00202O00030003000600122O000500076O0003000500024O000300036O000400016O00010004000200062O000100F600013O000408012O00F600012O002A2O0100053O00121A010200083O00122O000300096O0001000300024O000200016O0001000100024O000100023O00044O00F600010026A63O001F00010001000408012O001F0001002E2A000B00010001000A000408012O0001000100129D000100014O004E000200023O0026A60001002500010001000408012O00250001002E33000C00FEFF2O000D000408012O0021000100129D000200013O0026140002002A00010002000408012O002A000100129D3O00023O000408012O000100010026140002002600010001000408012O00260001002E2A000F003C0001000E000408012O003C00012O002A010300034O00D2000400053O00122O000500103O00122O000600116O0004000600024O00030003000400202O0003000300124O00030002000200062O0003003A00010001000408012O003A0001002E330013000400010014000408012O003C00012O004E000300034O000F000300024O002A010300064O00BC000400073O00122O000500026O000600086O000700036O000800053O00122O000900153O00122O000A00166O0008000A00024O00070007000800202O0007000700174O000700086O00068O00043O00024O000500093O00122O000600026O000700086O000800036O000900053O00122O000A00153O00122O000B00166O0009000B00024O00080008000900202O0008000800174O000800096O00078O00053O00024O00040004000500062O0003002B00010004000408012O008400012O002A0103000A4O002A0104000B3O00105D0004001800040006630003006400010004000408012O006400012O002A0103000A4O002A0104000B3O00105D0004000200040006240104002100010003000408012O008400012O002A0103000C3O0006C30003008700013O000408012O008700012O002A010300063O0026A60003008400010019000408012O008400012O002A010300034O00D2000400053O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O0003000300174O00030002000200062O0003007700010001000408012O007700012O002A010300063O000EF1001C008400010003000408012O008400012O002A010300034O0034000400053O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O0003000300174O00030002000200062O0003008700013O000408012O008700012O002A010300063O000E35011F008700010003000408012O0087000100129D000300024O0073000300013O000408012O00F10001002E330020002F00010020000408012O00B600012O002A010300064O001F010400073O00122O000500216O000600086O000700036O000800053O00122O000900223O00122O000A00236O0008000A00024O00070007000800202O0007000700174O000700086O00063O000200102O0006002100064O0004000600024O000500093O00122O000600216O000700086O000800036O000900053O00122O000A00223O00122O000B00236O0009000B00024O00080008000900202O0008000800174O000800096O00073O000200102O0007002100074O0005000700024O00040004000500062O0003000B00010004000408012O00B300012O002A0103000A4O002A0104000B3O00105D000400240004000663000300B600010004000408012O00B600012O002A0103000A4O002A0104000B3O00105D00040018000400063E010400B600010003000408012O00B6000100129D000300214O0073000300013O000408012O00F10001002EA8002500EF00010026000408012O00EF00012O002A010300064O001F010400073O00122O000500276O000600086O000700036O000800053O00122O000900283O00122O000A00296O0008000A00024O00070007000800202O0007000700174O000700086O00063O000200102O0006002700064O0004000600024O000500093O00122O000600276O000700086O000800036O000900053O00122O000A00283O00122O000B00296O0009000B00024O00080008000900202O0008000800174O000800096O00073O000200102O0007002700074O0005000700024O00040004000500062O0003001500010004000408012O00EC00012O002A010300034O0034000400053O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O0003000300174O00030002000200062O000300EC00013O000408012O00EC00012O002A0103000A4O002A0104000B3O00105D0004002C000400063E010300EF00010004000408012O00EF00012O002A0103000A4O002A0104000B3O00105D00040024000400063E010400EF00010003000408012O00EF000100129D000300274O0073000300013O000408012O00F1000100129D0003002D4O0073000300013O00129D000200023O000408012O00260001000408012O00010001000408012O00210001000408012O000100012O009E3O00017O00483O00028O00026O00F03F025O00207240025O0074A540025O000C9E40025O00F9B140025O00C0AC40025O00307E40025O00549640025O00F2A840025O00EAAE40025O0066A040025O008AA440025O00707E40025O004CAF40025O00288740025O006EA240025O002AAD40025O0014B140025O00B2A640025O00B89140025O00088040030A3O00AAF45E37305E7F8DE94403073O001AEC9D2C52722C030C3O00432O6F6C646F776E446F776E025O00F4B140025O00C4A240030D3O00446562752O6652656D61696E73030A3O0046697265427265617468025O003CA040025O00606440027O0040025O00D2AA40025O00ECA340025O00707940025O00349F40025O0014B040025O0008874003013O003103093O004973496E52616E6765026O003E4003143O00C74B20D33AC35037D711C90237DB15CE5537C44503053O0065A12252B603083O00A80058F7D5A2D37C03083O004E886D399EBB82E2025O00BC9640025O0032A040025O0022AB40025O00E2B140025O00AEA34003103O000F38D049283BC7552320D27D262FD85E03043O003B4A4EB5030B3O004973417661696C61626C65026O00FC3F03104O00C75F48B130C35453BD22F7565BBE2003053O00D345B12O3A026O00084003103O0092F37CE7EBDEA5EB70FBEEEDBBE474F003063O00ABD785199589026O000440030B3O002OC73CEEE036D143E6C13103083O002281A8529A8F509C03103O00A0A436194A5B9B8BBB3D0C6E422O88B703073O00E9E5D2536B282E026O000A40026O001040025O005C9240025O00D4AF40025O00F07C40025O0049B340025O00449540025O0086B2402O00012O00129D3O00014O004E000100023O0026A63O000600010002000408012O00060001002E2A000400F700010003000408012O00F70001002E2A0005000A00010006000408012O000A00010026A60001000C00010001000408012O000C0001002EA80007003D00010008000408012O003D000100129D000300014O004E000400043O002EA80009000E0001000A000408012O000E00010026A60003001400010001000408012O00140001002E33000B00FCFF2O000C000408012O000E000100129D000400013O002E2A000E001D0001000D000408012O001D0001002E2A0010001D0001000F000408012O001D00010026140004001D00010002000408012O001D000100129D000100023O000408012O003D0001002EA80011002100010012000408012O002100010026A60004002300010001000408012O00230001002E2A0013001500010014000408012O00150001002E2A0016003300010015000408012O003300012O002A01056O00D2000600013O00122O000700173O00122O000800186O0006000800024O00050005000600202O0005000500194O00050002000200062O0005003100010001000408012O00310001002EA8001A00330001001B000408012O003300012O004E000500054O000F000500024O002A010500023O00203C00050005001C4O00075O00202O00070007001D4O0005000700024O000200053O00122O000400023O00044O00150001000408012O003D0001000408012O000E0001002E2A001F00410001001E000408012O00410001000EFC0020004300010001000408012O00430001002E330021002000010022000408012O00610001002EA8002300FF00010024000408012O00FF0001002E2A002600FF00010025000408012O00FF00012O002A010300034O00F800045O00202O00040004001D4O00055O00122O000600276O000700023O00202O00070007002800122O000900296O0007000900024O000700076O000800086O00030008000200062O000300FF00013O000408012O00FF00012O002A010300013O0012930004002A3O00122O0005002B6O0003000500024O000400046O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0003000300054O000300023O000408012O00FF00010026A60001006500010002000408012O00650001002EA8002F00060001002E000408012O0006000100129D000300013O002614000300EC00010001000408012O00EC000100129D000400013O0026140004006D00010002000408012O006D000100129D000300023O000408012O00EC00010026A60004007100010001000408012O00710001002E2A0031006900010030000408012O00690001002E2A003200930001000A000408012O009300012O002A010500053O0006C30005007900013O000408012O007900012O002A010500063O0026440005009000010020000408012O009000012O002A010500063O0026140005008600010002000408012O008600012O002A01056O0034000600013O00122O000700333O00122O000800346O0006000800024O00050005000600202O0005000500354O00050002000200062O0005009000013O000408012O009000012O002A010500074O002A010600083O00105D0006003600060006630005009300010006000408012O009300012O002A010500074O002A010600083O00105D00060002000600063E0106009300010005000408012O0093000100129D000500024O0073000500043O000408012O00E800012O002A010500094O000E0005000100020006AD000500A400010001000408012O00A400012O002A01056O0034000600013O00122O000700373O00122O000800386O0006000800024O00050005000600202O0005000500354O00050002000200062O000500A400013O000408012O00A400012O002A010500063O002644000500BB00010039000408012O00BB00012O002A010500063O002614000500B100010020000408012O00B100012O002A01056O0034000600013O00122O0007003A3O00122O0008003B6O0006000800024O00050005000600202O0005000500354O00050002000200062O000500BB00013O000408012O00BB00012O002A010500074O002A010600083O00105D0006003C0006000663000500BE00010006000408012O00BE00012O002A010500074O002A010600083O00105D00060036000600063E010600BE00010005000408012O00BE000100129D000500204O0073000500043O000408012O00E800012O002A01056O0034000600013O00122O0007003D3O00122O0008003E6O0006000800024O00050005000600202O0005000500354O00050002000200062O000500E300013O000408012O00E300012O002A010500094O000E0005000100020006C3000500D900013O000408012O00D900012O002A01056O0034000600013O00122O0007003F3O00122O000800406O0006000800024O00050005000600202O0005000500354O00050002000200062O000500D900013O000408012O00D900012O002A010500063O002644000500E300010039000408012O00E300012O002A010500074O002A010600083O00105D00060041000600063E010500E600010006000408012O00E600012O002A010500074O002A010600083O00105D0006003C000600063E010600E600010005000408012O00E6000100129D000500394O0073000500043O000408012O00E8000100129D000500424O0073000500044O002A010500044O00730005000A3O00129D000400023O000408012O006900010026A6000300F200010002000408012O00F20001002E05004400F200010043000408012O00F20001002EA80046006600010045000408012O0066000100129D000100203O000408012O00060001000408012O00660001000408012O00060001000408012O00FF00010026A63O00FB00010001000408012O00FB0001002E3300470009FF2O0048000408012O0002000100129D000100014O004E000200023O00129D3O00023O000408012O000200012O009E3O00017O00D13O00028O00026O00F03F025O0058AF40025O00D0AF40025O002EAF40025O005CAD40025O00BEAD40025O00F09340030A3O006A02367D411E257B491503043O001A2E7057030B3O004973417661696C61626C65030A3O009D31AA73B0B157B5BE2603083O00D4D943CB142ODF25030F3O00432O6F6C646F776E52656D61696E73030B3O0042752O6652656D61696E73030E3O00506F7765725377652O6C42752O66030A3O008C82A4D3AE84A4DBAE9403043O00B2DAEDC8026O00084003113O00426C617A696E6753686172647342752O6603093O0054696D65546F446965026O002040026O003E40025O0023B140025O00F8A140025O0058A140025O0009B140025O00806C40025O0016B040025O00F4AB40025O00C6A640025O00D49D40025O00CDB040025O00C8A440025O00D89840025O000AA840025O00D08340025O00C6A140030A3O0092B0E3C094A7E3D1A2BD03043O00B0D6D586030A3O0049734361737461626C65030E3O00452O73656E63654465666963697403113O0054617267657449734D6F7573656F76657203103O00442O6570427265617468437572736F7203093O004973496E52616E6765025O000BB040025O0014904003113O00F0A8B3C497544BF1ACA2DCE85756F1EDE003073O003994CDD6B4C836025O000C9140025O00C2A540030E3O0021F534206217EF3C3A7121E9342603053O0016729D555403093O0042752O66537461636B03103O00452O73656E6365427572737442752O66030B3O00E5D910C553F39ECDCC1CD603073O00C8A4AB73A43D96025O00CC9C40025O0048AE40025O006BB240025O00189240030E3O005368612O746572696E6753746172030E3O0049735370652O6C496E52616E676503153O00ADFC025197BBE60A4B8481E7174491FEF50C40C3E603053O00E3DE946325027O0040025O001EB240025O0030A640025O00309440025O003EB140025O00149F40025O006EAB40030A3O001A2DF8F62O31EBF0393A03043O00915E5F992O033O00436473026O002O40030A3O00447261676F6E7261676503103O00F9DF15D241B9EFCC13D00EB6F2C8548703063O00D79DAD74B52E030C3O0001BD9BC6D2308788F3D630A703053O00BA55D4EB92030D3O00E79513EC37E74CDB9225EE38E003073O0038A2E1769E598E030A3O007A0CD2AA00CA5904D4A703063O00B83C65A0CF42030C3O00432O6F6C646F776E446F776E025O00B4A840025O0007B040025O00A8A040030C3O005469705468655363616C6573025O005EA940025O0030B14003143O00258B6C83258A798322817DB034913CBD3E873CE803043O00DC51E21C025O00208D40025O0008AF40025O0062AD40025O0072A540030A3O0037C783FCE5C901D485FE03063O00A773B5E29B8A03093O00C32CEE517462CFF63B03073O00A68242873C1B11030A3O007245C274244D46C7612903053O0050242AAE15025O00D0B140025O000CA540025O00208840025O0050B040025O009CA540025O00708440025O00C6A340025O0002AF40025O00108740025O0022A140025O00FEB140025O008CAA40025O00F49C40025O00389B40025O00DBB240025O0084A240025O006CA340025O0046A640025O0014A340025O0008A440025O0020AF40025O0074994003093O00155B40F3EA275D40FB03053O0099532O3296025O0016B140025O0048B04003093O004669726573746F726D026O003940025O0052A340025O005EAA4003103O005B7F611960BF424F7B331D7CAE0D0C2603073O002D3D16137C13CB03043O00F10B1FF003073O00D9A1726D95621003073O0049735265616479026O001440026O00104003083O0042752O66446F776E03133O0049726964657363656E6365426C756542752O66030D3O0037343D6EB27D06392B4FAC751C03063O00147240581CDC030A3O00070EDEB5ECD9B13815CB03073O00DD5161B2D498B0030A3O00FBE811FA0EC4EB14EF2O03053O007AAD877D9B030C3O00A7C901AB3834CCA6CD01AA2B03073O00A8E4A160D95F51030A3O00EDDE225D3B5ED7D83A4503063O0037BBB14E3C4F030C3O000EC65EF941CA840FC25EF85203073O00E04DAE3F8B26AF03063O0042752O66557003123O0049726964657363656E636552656442752O6603103O0043686172676564426C61737442752O66026O002E40025O0016B340025O00CC9E4003043O0050797265025O00E0B140025O004AB340025O0044A440025O00589640030B3O0094584A2BC440572BC4100C03043O004EE42138025O00CDB240025O00C1B140030B3O00E277A40A8BC958BE0288CB03053O00E5AE1ED263030B3O004275726E6F757442752O6603113O004C656170696E67466C616D657342752O6603073O00452O73656E6365030A3O00452O73656E63654D6178025O0033B340025O001DB340030B3O004C6976696E67466C616D6503133O0017E49058E33A061DE1875CE87D3814E8C600B903073O00597B8DE6318D5D025O00E4A640025O00488440025O002FB040030C3O00D778E5051E5EF676E40D044F03063O002A9311966C70025O00C89540025O00A06040025O001C9340025O00ACAA40030C3O00446973696E7465677261746503133O000BAF3E76E9FC0AA13F7EF3ED4FA7227AA7BA5F03063O00886FC64D1F87030B3O002E00B15FB3E331A50304A203083O00C96269C736DD847703083O008A028231043CBEBC03073O00CCD96CE341625503133O0052CAE3EC22C761C5F9E421C51EC2FAE06C920C03063O00A03EA395854C025O00207C40025O00AAA340030B3O00F7BA183DC6E5B41F26C8D303053O00A3B6C06D4F026O007B40025O00F07E40025O0076A140030B3O00417A757265537472696B6503133O00353C15D2F00B3514D2FC3F2340C1FA3166529403053O0095544660A0005A032O00129D3O00013O0026A63O000500010002000408012O00050001002EA8000400D900010003000408012O00D9000100129D000100014O004E000200023O0026A60001000B00010001000408012O000B0001002EA80005000700010006000408012O0007000100129D000200013O0026140002009F00010001000408012O009F0001002EA80008004D00010007000408012O004D00012O002A01035O0006AD0003004F00010001000408012O004F00012O002A010300014O0034000400023O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003004F00013O000408012O004F00012O002A010300014O001E000400023O00122O0005000C3O00122O0006000D6O0004000600024O00030003000400202O00030003000E4O0003000200024O000400033O00062O0004004D00010003000408012O004D00012O002A010300043O0020EC00030003000F4O000500013O00202O0005000500104O0003000500024O000400053O00062O0003003D00010004000408012O003D00012O002A010300014O00D2000400023O00122O000500113O00122O000600126O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003004D00010001000408012O004D00012O002A010300063O0026140003004D00010013000408012O004D00012O002A010300043O0020B100030003000F4O000500013O00202O0005000500144O0003000500024O000400053O00062O0003004D00010004000408012O004D00012O002A010300073O00200D0103000300152O00E0000300020002000EF10016004F00010003000408012O004F00012O002A010300083O00262E0103004F00010017000408012O004F0001002EA80018006E00010019000408012O006E000100129D000300014O004E000400053O002EA8001A00580001001B000408012O005800010026140003005800010001000408012O0058000100129D000400014O004E000500053O00129D000300023O002E33001C00F9FF2O001C000408012O005100010026140003005100010002000408012O005100010026A60004006000010001000408012O00600001002EA8001D005C0001001E000408012O005C00012O002A010600094O000E0006000100022O007B000500063O0006AD0005006900010001000408012O00690001002E05001F006900010020000408012O00690001002E330021000700010022000408012O006E00012O000F000500023O000408012O006E0001000408012O005C0001000408012O006E0001000408012O00510001002EA80023009E00010024000408012O009E0001002EA80025009E00010026000408012O009E00012O002A010300014O0034000400023O00122O000500273O00122O000600286O0004000600024O00030003000400202O0003000300294O00030002000200062O0003009E00013O000408012O009E00012O002A0103000A3O0006C30003009E00013O000408012O009E00012O002A01035O0006AD0003009E00010001000408012O009E00012O002A010300043O00200D01030003002A2O00E0000300020002000E760013009E00010003000408012O009E00012O002A0103000B3O0020D700030003002B2O000E0003000100020006C30003009E00013O000408012O009E00012O002A0103000C4O00CE0004000D3O00202O00040004002C4O000500073O00202O00050005002D00122O000700176O0005000700024O000500056O00030005000200062O0003009900010001000408012O00990001002EA8002E009E0001002F000408012O009E00012O002A010300023O00129D000400303O00129D000500314O00C6000300054O000700035O00129D000200023O002EA80032000C00010033000408012O000C00010026140002000C00010002000408012O000C00012O002A010300014O0034000400023O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300294O00030002000200062O000300BF00013O000408012O00BF00012O002A010300043O0020EC0003000300364O000500013O00202O0005000500374O0003000500024O0004000E3O00062O000300C100010004000408012O00C100012O002A010300014O0034000400023O00122O000500383O00122O000600396O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300C100013O000408012O00C10001002E33003A00150001003B000408012O00D40001002EA8003D00D40001003C000408012O00D400012O002A0103000C4O0046010400013O00202O00040004003E4O000500073O00202O00050005003F4O000700013O00202O00070007003E4O0005000700024O000500056O00030005000200062O000300D400013O000408012O00D400012O002A010300023O00129D000400403O00129D000500414O00C6000300054O000700035O00129D3O00423O000408012O00D90001000408012O000C0001000408012O00D90001000408012O000700010026143O00D82O010001000408012O00D82O0100129D000100014O004E000200023O002EA8004400DD00010043000408012O00DD0001002614000100DD00010001000408012O00DD000100129D000200013O0026A6000200E600010001000408012O00E60001002E2A0046005E2O010045000408012O005E2O0100129D000300013O002E330047000600010047000408012O00ED0001002614000300ED00010002000408012O00ED000100129D000200023O000408012O005E2O01002614000300E700010001000408012O00E70001002E330048002200010048000408012O00112O012O002A010400014O0034000500023O00122O000600493O00122O0007004A6O0005000700024O00040004000500202O0004000400294O00040002000200062O000400112O013O000408012O00112O010012FB0004004B3O0006C3000400112O013O000408012O00112O012O002A010400073O00200D0104000400152O00E0000400020002000EF1004C00062O010004000408012O00062O012O002A010400083O00262D010400112O010017000408012O00112O012O002A0104000C4O002A010500013O0020D700050005004D2O00E00004000200020006C3000400112O013O000408012O00112O012O002A010400023O00129D0005004E3O00129D0006004F4O00C6000400064O000700046O002A010400014O0034000500023O00122O000600503O00122O000700516O0005000700024O00040004000500202O0004000400294O00040002000200062O0004004B2O013O000408012O004B2O012O002A0104000A3O0006C30004004B2O013O000408012O004B2O012O002A01045O0006C30004004B2O013O000408012O004B2O012O002A010400064O001F0105000F3O00122O000600136O000700106O000800016O000900023O00122O000A00523O00122O000B00536O0009000B00024O00080008000900202O00080008000B4O000800096O00073O000200102O0007001300074O0005000700024O000600113O00122O000700136O000800106O000900016O000A00023O00122O000B00523O00122O000C00536O000A000C00024O00090009000A00202O00090009000B4O0009000A6O00083O000200102O0008001300084O0006000800024O00050005000600062O0004000D00010005000408012O004D2O012O002A010400014O00D2000500023O00122O000600543O00122O000700556O0005000700024O00040004000500202O0004000400564O00040002000200062O0004004D2O010001000408012O004D2O01002E330057001100010058000408012O005C2O01002E330059000800010059000408012O00552O012O002A0104000C4O002A010500013O0020D700050005005A2O00E00004000200020006AD000400572O010001000408012O00572O01002E33005B00070001005C000408012O005C2O012O002A010400023O00129D0005005D3O00129D0006005E4O00C6000400064O000700045O00129D000300023O000408012O00E70001002EA8005F00E200010060000408012O00E20001002614000200E200010002000408012O00E20001002E2A006200D32O010061000408012O00D32O012O002A010300014O0034000400023O00122O000500633O00122O000600646O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003007C2O013O000408012O007C2O012O002A010300124O002A010400033O0006DB0004007C2O010003000408012O007C2O012O002A010300014O00D2000400023O00122O000500653O00122O000600666O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300D32O010001000408012O00D32O012O002A010300043O0020EC00030003000F4O000500013O00202O0005000500104O0003000500024O000400053O00062O000300912O010004000408012O00912O012O002A010300014O00D2000400023O00122O000500673O00122O000600686O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300992O010001000408012O00992O012O002A010300063O002614000300992O010013000408012O00992O012O002A010300043O0020EC00030003000F4O000500013O00202O0005000500144O0003000500024O000400053O00062O0003009C2O010004000408012O009C2O012O002A01035O0006C3000300D32O013O000408012O00D32O012O002A010300073O00200D0103000300152O00E0000300020002000EF1001600A42O010003000408012O00A42O012O002A010300083O00262D010300D32O010017000408012O00D32O0100129D000300014O004E000400063O000EFC000200AA2O010003000408012O00AA2O01002EA8006900C92O01006A000408012O00C92O012O004E000600063O002E2A006B00C02O01006C000408012O00C02O01002614000400C02O010002000408012O00C02O01002EA8006E00AF2O01006D000408012O00AF2O010026A6000500B52O010001000408012O00B52O01002EA8007000AF2O01006F000408012O00AF2O012O002A010700134O000E0007000100022O007B000600073O0006AD000600BC2O010001000408012O00BC2O01002E2A007200D32O010071000408012O00D32O012O000F000600023O000408012O00D32O01000408012O00AF2O01000408012O00D32O01002EA8007400AB2O010073000408012O00AB2O01002614000400AB2O010001000408012O00AB2O0100129D000500014O004E000600063O00129D000400023O000408012O00AB2O01000408012O00D32O01002E2A007600CD2O010075000408012O00CD2O010026A6000300CF2O010001000408012O00CF2O01002E33007700D9FF2O0078000408012O00A62O0100129D000400014O004E000500053O00129D000300023O000408012O00A62O0100129D3O00023O000408012O00D82O01000408012O00E20001000408012O00D82O01000408012O00DD00010026A63O00DC2O010042000408012O00DC2O01002E2A007A00E302010079000408012O00E3020100129D000100013O0026A6000100E32O010001000408012O00E32O01002E05007C00E32O01007B000408012O00E32O01002E33007D00BF0001007E000408012O00A002012O002A010200014O0034000300023O00122O0004007F3O00122O000500806O0003000500024O00020002000300202O0002000200294O00020002000200062O0002002O02013O000408012O002O0201002EA8008200FB2O010081000408012O00FB2O012O002A0102000C4O00A9000300013O00202O0003000300834O000400073O00202O00040004002D00122O000600846O0004000600024O000400046O000500146O00020005000200062O000200FD2O010001000408012O00FD2O01002E2A0086002O02010085000408012O002O02012O002A010200023O00129D000300873O00129D000400884O00C6000200044O000700026O002A010200014O0034000300023O00122O000400893O00122O0005008A6O0003000500024O00020002000300202O00020002008B4O00020002000200062O0002008802013O000408012O008802012O002A010200063O000EF1008C008A02010002000408012O008A02012O002A010200063O000E35018D002A02010002000408012O002A02012O002A010200043O00204701020002008E4O000400013O00202O0004000400374O00020004000200062O0002002002013O000408012O002002012O002A010200043O00201D01020002008E4O000400013O00202O00040004008F4O00020004000200062O0002008A02010001000408012O008A02012O002A010200014O0034000300023O00122O000400903O00122O000500916O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008A02013O000408012O008A02012O002A010200063O000E35018D003702010002000408012O003702012O002A010200014O00D2000300023O00122O000400923O00122O000500936O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008A02010001000408012O008A02012O002A010200063O000E350113005C02010002000408012O005C02012O002A010200014O0034000300023O00122O000400943O00122O000500956O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005C02013O000408012O005C02012O002A010200014O0034000300023O00122O000400963O00122O000500976O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002005C02013O000408012O005C02012O002A010200043O00204701020002008E4O000400013O00202O0004000400374O00020004000200062O0002005C02013O000408012O005C02012O002A010200043O00201D01020002008E4O000400013O00202O00040004008F4O00020004000200062O0002008A02010001000408012O008A02012O002A010200063O000E350113008102010002000408012O008102012O002A010200014O0034000300023O00122O000400983O00122O000500996O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008102013O000408012O008102012O002A010200014O00D2000300023O00122O0004009A3O00122O0005009B6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002008102010001000408012O008102012O002A010200043O00201D01020002009C4O000400013O00202O00040004009D4O00020004000200062O0002008A02010001000408012O008A02012O002A010200043O00201D01020002008E4O000400013O00202O0004000400374O00020004000200062O0002008A02010001000408012O008A02012O002A010200043O0020250002000200364O000400013O00202O00040004009E4O000200040002000E2O009F008A02010002000408012O008A0201002E3300A00017000100A1000408012O009F02012O002A0102000C4O0051000300013O00202O0003000300A24O000400073O00202O00040004003F4O000600013O00202O0006000600A24O0004000600024O000400046O00020004000200062O0002009A02010001000408012O009A0201002E0500A4009A020100A3000408012O009A0201002EA800A5009F020100A6000408012O009F02012O002A010200023O00129D000300A73O00129D000400A84O00C6000200044O000700025O00129D000100023O002E2A00AA00DD2O0100A9000408012O00DD2O01002614000100DD2O010002000408012O00DD2O012O002A010200014O0034000300023O00122O000400AB3O00122O000500AC6O0003000500024O00020002000300202O0002000200294O00020002000200062O000200CC02013O000408012O00CC02012O002A010200043O00204701020002009C4O000400013O00202O0004000400AD4O00020004000200062O000200CC02013O000408012O00CC02012O002A010200043O00204701020002009C4O000400013O00202O0004000400AE4O00020004000200062O000200CC02013O000408012O00CC02012O002A010200043O00204701020002008E4O000400013O00202O0004000400374O00020004000200062O000200CC02013O000408012O00CC02012O002A010200043O00207C0002000200AF4O0002000200024O000300043O00202O0003000300B04O00030002000200202O00030003000200062O000200CE02010003000408012O00CE0201002E2A00B100E0020100B2000408012O00E002012O002A0102000C4O002D000300013O00202O0003000300B34O000400073O00202O00040004003F4O000600013O00202O0006000600B34O0004000600024O000400046O000500146O00020005000200062O000200E002013O000408012O00E002012O002A010200023O00129D000300B43O00129D000400B54O00C6000200044O000700025O00129D3O00133O000408012O00E30201000408012O00DD2O01002E2A00B70001000100B6000408012O000100010026143O000100010013000408012O00010001002E3300B80022000100B8000408012O000903012O002A2O0100014O00D2000200023O00122O000300B93O00122O000400BA6O0002000400024O00010001000200202O00010001008B4O00010002000200062O000100F502010001000408012O00F50201002E2A00BB0009030100BC000408012O00090301002E2A00BD0009030100BE000408012O000903012O002A2O01000C4O002D000200013O00202O0002000200BF4O000300073O00202O00030003003F4O000500013O00202O0005000500BF4O0003000500024O000300036O000400146O00010004000200062O0001000903013O000408012O000903012O002A2O0100023O00129D000200C03O00129D000300C14O00C6000100034O000700016O002A2O0100014O0034000200023O00122O000300C23O00122O000400C36O0002000400024O00010001000200202O0001000100294O00010002000200062O0001003603013O000408012O003603012O002A2O0100014O0034000200023O00122O000300C43O00122O000400C56O0002000400024O00010001000200202O00010001000B4O00010002000200062O0001003603013O000408012O003603012O002A2O0100043O0020472O010001009C4O000300013O00202O0003000300AD4O00010003000200062O0001003603013O000408012O003603012O002A2O01000C4O002D000200013O00202O0002000200B34O000300073O00202O00030003003F4O000500013O00202O0005000500B34O0003000500024O000300036O000400146O00010004000200062O0001003603013O000408012O003603012O002A2O0100023O00129D000200C63O00129D000300C74O00C6000100034O000700015O002E2A00C80059030100C9000408012O005903012O002A2O0100014O00D2000200023O00122O000300CA3O00122O000400CB6O0002000400024O00010001000200202O0001000100294O00010002000200062O0001004403010001000408012O00440301002E3300CC0017000100CD000408012O00590301002E3300CE0015000100CE000408012O005903012O002A2O01000C4O0046010200013O00202O0002000200CF4O000300073O00202O00030003003F4O000500013O00202O0005000500CF4O0003000500024O000300036O00010003000200062O0001005903013O000408012O005903012O002A2O0100023O001280000200D03O00122O000300D16O000100036O00015O00044O00590301000408012O000100012O009E3O00017O00F93O00028O00026O001840025O00F88C40025O00AAA340025O00805040025O00C09640030B3O008256940EB93CB75E8817B903063O006FC32CE17CDC030A3O0049734361737461626C65030B3O00417A757265537472696B65030E3O0049735370652O6C496E52616E6765025O00708B40025O002CA94003123O00D95C1561AE94CB52127AA0AE98551433F8FF03063O00CBB8266013CB026O00F03F025O00C06F40025O00B2A940025O0032A040025O0015B040030A3O00140C811F4E3E0C811F4403053O0021507EE078030B3O004973417661696C61626C6503093O00CDA60AC953FFA117DD03053O003C8CC863A4030B3O0042752O6652656D61696E7303113O00426C617A696E6753686172647342752O6603093O0054696D65546F446965026O002040026O003E40025O002EA540025O00088640025O008EA740025O003AB240025O0094A340025O004CAA40025O003C9040025O00AEB040025O00405F40025O0042A040030C3O00A3FD172FAC93F10334A393F103053O00C2E794644603073O0049735265616479026O003340030A3O006045D3A6D4DA434DD5AB03063O00A8262CA1C396030F3O00432O6F6C646F776E52656D61696E73026O003C40030D3O00A5E5877936C1B81089F28B622903083O0076E09CE2165088D603073O0048617354696572027O0040025O00C05E40025O00508740030C3O00446973696E74656772617465025O00349D40025O0024B34003113O0046E74A894CFA5C8750EF4D8502FD4DC01B03043O00E0228E39030E3O00EDAFC4C967F44F07D0A0F6C972E303083O006EBEC7A5BD13913D03093O0042752O66537461636B03103O00452O73656E6365427572737442752O66030B3O00FBF974E985C2ECE270E79903063O00A7BA8B1788EB025O005CB140025O00F08B40025O00C49B40025O00E0A940030E3O005368612O746572696E6753746172025O00489240025O00A49D4003153O0009BD89190EB09A0414B2B71E0EB49A4D09A1C85C4A03043O006D7AD5E8025O00C08B40025O00808740025O00809540025O0038824003093O001E0F1FE82B1202FF3503043O008D58666D03063O0042752O665570030C3O00536E61706669726542752O66025O0022A840025O006EAF4003093O004669726573746F726D03093O004973496E52616E6765026O003940030E3O00B55AD87509295AD3BE13D9645A6903083O00A1D333AA107A5D35030A3O00DFBCB32FF42OA029FCAB03043O00489BCED2030A3O006073460B11547F551A3B03053O0053261A346E030D3O007D032254561E335F6B0235415D03043O0026387747025O00F2B240025O00989640030A3O00447261676F6E72616765025O00F6A240025O002EA340030F3O00F7FD59D12A58E1EE5FD36545E7AF0E03063O0036938F38B645025O0082AA40025O0052A540030C3O00E288EF7DD7D3B2FC482OD39203053O00BFB6E19F29030D3O000E062D47858ED632213D478C8203073O00A24B724835EBE7030A3O00432O6F6C646F776E5570030A3O00AA3556E77110893D50EA03063O0062EC5C248233030C3O00432O6F6C646F776E446F776E03103O00810F09A847BDA73EAD170B9C49A9B83503083O0050C4796CDA25C8D503103O002565076D491B980E7A0C786D028B0D7603073O00EA6013621F2B6E030A3O00201640C28E608E070B5A03073O00EB667F32A7CC12025O004FB040030C3O005469705468655363616C657303133O0044A8E51C5026559EE620452255B2B530506E0803063O004E30C1954324030A3O00CAE5A337E1F9B031E9F203043O00508E97C203093O0022C87E410CD57E581A03043O002C63A617025O00E8B140025O00789D40025O004C9040025O00D0A140025O0040A840025O00E88F40025O00D88440025O00C05140025O00C09840025O004CB14003093O005DF9203B3CB775E33003063O00C41C9749565303083O0042752O66446F776E030A3O00D50A3B15A04A1D77E70B03083O001693634970E23878025O00B09440025O00209E4003043O00502O6F6C03113O008F74EBE1CDBE7AF0B5AB9A35F1E1CDE92703053O00EDD8158295025O0015B24003093O00A3405652BFDA57965703073O003EE22E2O3FD0A9030D3O00C00D509111043B47D60C47841A03083O003E857935E37F6D4F025O00BEA640025O007AAE4003113O0027153BE196A8AD025417C696BDB650456603073O00C270745295B6CE026O000840025O00B07740025O00349540026O00104003043O000650E11503063O00AE5629937013030D3O0069018A022B0838A55D059F052A03083O00CB3B60ED6B456F7103103O0043686172676564426C61737442752O66026O00344003043O0050797265025O0082B140025O00D2A540030A3O00340FBEE471E3C36444FE03073O00B74476CC815190025O00888140025O00A7B140030C3O002AA463ED05960BAA62E51F8703063O00E26ECD10846B025O00C49540025O00A0764003123O00EFCAF3D04FFFC6E7CB40FFC6A0CA55AB91B403053O00218BA380B9025O00D0964003093O00715116DB444C0BCC5A03043O00BE373864030A3O00446562752O66446F776E025O00288540025O00689640025O0016A640030F3O0050A62E1B00F7FC44A27C0D07A3A10003073O009336CF5C7E7383026O001440025O0078AB40025O00409540030B3O0015A15A11CEE52835A9411D03073O006E59C82C78A082030B3O004275726E6F757442752O66025O00F8A340030B3O004C6976696E67466C616D65025O00889D4003123O00A7CA5D4F2O4D044BA7C2464303592F0DFA9503083O002DCBA32B26232A5B030B3O00F39FC931829A40C08CD72603073O0034B2E5BC43E7C9025O0044A840025O0044B340025O004C9A40025O0002A840025O00049340025O00707F4003123O00205B4516F263303553590FF21C30352O015C03073O004341213064973C030B3O00F3EEB8D1FDD8C1A2D9FEDA03053O0093BF87CEB803113O004C656170696E67466C616D657342752O6603073O00452O73656E6365030A3O00452O73656E63654D6178025O00907B40025O0007B340025O00089E40025O00DAA44003123O008821B0C8D6548D8224A7CCDD13A19068F49103073O00D2E448C6A1B833025O004EAD40025O00D88640030A3O002934306D2F6C0830217503063O001E6D51551D6D03113O0054617267657449734D6F7573656F766572025O00406040025O00A0A94003103O00442O6570427265617468437572736F7203113O00FB7451A609DCEEFA7040BE76CDE8BF230C03073O009C9F1134D656BE030A3O008AEAB8AC8CFDB8BDBAE703043O00DCCE8FDD03133O00AF70201ED6C9DC92592804CCDEC785692418D603073O00B2E61D4D77B8AC025O0042B340025O005DB04003113O00F1BB0F0B48FAE7BB0B0F7FB8E6AA4A482703063O009895DE6A7B17025O003C9240025O00449740030B3O00F12FE04ABBDA00FA42B8D803053O00D5BD469623025O00A6A340025O00309C40025O00B0AF40025O00F08440025O0080A740025O00109E4003123O00435C620141524B0E4354790D0F4660481C0703043O00682F3514003E042O00129D3O00014O004E000100013O0026143O000200010001000408012O0002000100129D000100013O0026140001002900010002000408012O00290001002EA80003003D04010004000408012O003D0401002E2A0005003D04010006000408012O003D04012O002A01026O0034000300013O00122O000400073O00122O000500086O0003000500024O00020002000300202O0002000200094O00020002000200062O0002003D04013O000408012O003D04012O002A010200024O005100035O00202O00030003000A4O000400033O00202O00040004000B4O00065O00202O00060006000A4O0004000600024O000400046O00020004000200062O0002002300010001000408012O00230001002EA8000D003D0401000C000408012O003D04012O002A010200013O0012800003000E3O00122O0004000F6O000200046O00025O00044O003D04010026A60001002F00010010000408012O002F0001002EC00012002F00010011000408012O002F0001002E2A001400EB00010013000408012O00EB00012O002A01026O0034000300013O00122O000400153O00122O000500166O0003000500024O00020002000300202O0002000200174O00020002000200062O0002004700013O000408012O004700012O002A010200044O002A010300053O0006DB0003004700010002000408012O004700012O002A01026O00D2000300013O00122O000400183O00122O000500196O0003000500024O00020002000300202O0002000200174O00020002000200062O0002005A00010001000408012O005A00012O002A010200063O0020EC00020002001A4O00045O00202O00040004001B4O0002000400024O000300073O00062O0002005200010003000408012O005200012O002A010200083O0006C30002005A00013O000408012O005A00012O002A010200033O00200D01020002001C2O00E0000200020002000EF1001D005C00010002000408012O005C00012O002A010200093O00262E0102005C0001001E000408012O005C0001002EA8001F007700010020000408012O0077000100129D000200014O004E000300043O0026140002006300010001000408012O0063000100129D000300014O004E000400043O00129D000200103O0026A60002006700010010000408012O00670001002E2A0022005E00010021000408012O005E00010026A60003006B00010001000408012O006B0001002EA80024006700010023000408012O006700012O002A0105000A4O000E0005000100022O007B000400053O002E2A0025007700010026000408012O007700010006C30004007700013O000408012O007700012O000F000400023O000408012O00770001000408012O00670001000408012O00770001000408012O005E0001002E2A002700B700010028000408012O00B700012O002A01026O0034000300013O00122O000400293O00122O0005002A6O0003000500024O00020002000300202O00020002002B4O00020002000200062O000200A100013O000408012O00A100012O002A0102000B3O000E76002C00A100010002000408012O00A100012O002A01026O008D000300013O00122O0004002D3O00122O0005002E6O0003000500024O00020002000300202O00020002002F4O000200020002000E2O003000A100010002000408012O00A100012O002A01026O0034000300013O00122O000400313O00122O000500326O0003000500024O00020002000300202O0002000200174O00020002000200062O000200A100013O000408012O00A100012O002A010200063O002O2000020002003300122O0004001E3O00122O000500346O00020005000200062O000200A300010001000408012O00A30001002E2A003600B700010035000408012O00B700012O002A0102000C4O001C01035O00202O0003000300374O000400056O000600033O00202O00060006000B4O00085O00202O0008000800374O0006000800024O000600066O0002000600020006AD000200B200010001000408012O00B20001002E330038000700010039000408012O00B700012O002A010200013O00129D0003003A3O00129D0004003B4O00C6000200044O000700026O002A01026O0034000300013O00122O0004003C3O00122O0005003D6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200D300013O000408012O00D300012O002A010200063O0020EC00020002003E4O00045O00202O00040004003F4O0002000400024O0003000D3O00062O000200D700010003000408012O00D700012O002A01026O0034000300013O00122O000400403O00122O000500416O0003000500024O00020002000300202O0002000200174O00020002000200062O000200D700013O000408012O00D70001002EC0004200D700010043000408012O00D70001002EA8004500EA00010044000408012O00EA00012O002A010200024O005100035O00202O0003000300464O000400033O00202O00040004000B4O00065O00202O0006000600464O0004000600024O000400046O00020004000200062O000200E500010001000408012O00E50001002E2A004800EA00010047000408012O00EA00012O002A010200013O00129D000300493O00129D0004004A4O00C6000200044O000700025O00129D000100343O002EA8004C009D2O01004B000408012O009D2O01002E2A004E009D2O01004D000408012O009D2O010026140001009D2O010001000408012O009D2O012O002A01026O0034000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200094O00020002000200062O000200022O013O000408012O00022O012O002A010200063O00201D0102000200514O00045O00202O0004000400524O00020004000200062O000200042O010001000408012O00042O01002E2A005400152O010053000408012O00152O012O002A010200024O00AC00035O00202O0003000300554O000400033O00202O00040004005600122O000600576O0004000600024O000400046O0005000E6O00020005000200062O000200152O013O000408012O00152O012O002A010200013O00129D000300583O00129D000400594O00C6000200044O000700026O002A01026O0034000300013O00122O0004005A3O00122O0005005B6O0003000500024O00020002000300202O0002000200094O00020002000200062O0002003C2O013O000408012O003C2O012O002A0102000F3O0006C30002003C2O013O000408012O003C2O012O002A01026O001E000300013O00122O0004005C3O00122O0005005D6O0003000500024O00020002000300202O00020002002F4O0002000200024O000300103O00062O000200392O010003000408012O00392O012O002A01026O0082000300013O00122O0004005E3O00122O0005005F6O0003000500024O00020002000300202O00020002002F4O0002000200024O000300103O00102O00030034000300062O0002003E2O010003000408012O003E2O012O002A010200093O00262E0102003E2O01001E000408012O003E2O01002E330060000F00010061000408012O004B2O012O002A010200024O002A01035O0020D70003000300622O00E00002000200020006AD000200462O010001000408012O00462O01002E330063000700010064000408012O004B2O012O002A010200013O00129D000300653O00129D000400664O00C6000200044O000700025O002EA80068009C2O010067000408012O009C2O012O002A01026O0034000300013O00122O000400693O00122O0005006A6O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009C2O013O000408012O009C2O012O002A0102000F3O0006C30002009C2O013O000408012O009C2O012O002A010200083O0006C30002007B2O013O000408012O007B2O012O002A01026O0034000300013O00122O0004006B3O00122O0005006C6O0003000500024O00020002000300202O00020002006D4O00020002000200062O0002007B2O013O000408012O007B2O012O002A01026O0034000300013O00122O0004006E3O00122O0005006F6O0003000500024O00020002000300202O0002000200704O00020002000200062O0002007B2O013O000408012O007B2O012O002A01026O0034000300013O00122O000400713O00122O000500726O0003000500024O00020002000300202O0002000200174O00020002000200062O0002008F2O013O000408012O008F2O012O002A01026O0034000300013O00122O000400733O00122O000500746O0003000500024O00020002000300202O0002000200174O00020002000200062O0002009C2O013O000408012O009C2O012O002A01026O0034000300013O00122O000400753O00122O000500766O0003000500024O00020002000300202O00020002006D4O00020002000200062O0002009C2O013O000408012O009C2O01002E330077000D00010077000408012O009C2O012O002A010200024O002A01035O0020D70003000300782O00E00002000200020006C30002009C2O013O000408012O009C2O012O002A010200013O00129D000300793O00129D0004007A4O00C6000200044O000700025O00129D000100103O0026140001007202010034000408012O007202012O002A01026O0034000300013O00122O0004007B3O00122O0005007C6O0003000500024O00020002000300202O0002000200174O00020002000200062O000200B72O013O000408012O00B72O012O002A010200044O002A010300053O0006DB000300B72O010002000408012O00B72O012O002A01026O00D2000300013O00122O0004007D3O00122O0005007E6O0003000500024O00020002000300202O0002000200174O00020002000200062O000200E72O010001000408012O00E72O012O002A010200063O0020EC00020002001A4O00045O00202O00040004001B4O0002000400024O000300073O00062O000200C22O010003000408012O00C22O012O002A010200083O0006C3000200E72O013O000408012O00E72O012O002A010200033O00200D01020002001C2O00E0000200020002000EF1001D00CA2O010002000408012O00CA2O012O002A010200093O00262D010200E72O01001E000408012O00E72O0100129D000200014O004E000300043O002614000200DF2O010010000408012O00DF2O01002E2A008000CE2O01007F000408012O00CE2O01000E142O0100CE2O010003000408012O00CE2O012O002A010500114O000E0005000100022O007B000400053O0006AD000400DB2O010001000408012O00DB2O01002EC0008200DB2O010081000408012O00DB2O01002E330083000E00010084000408012O00E72O012O000F000400023O000408012O00E72O01000408012O00CE2O01000408012O00E72O010026A6000200E32O010001000408012O00E32O01002E2A008500CC2O010086000408012O00CC2O0100129D000300014O004E000400043O00129D000200103O000408012O00CC2O01002E2A0087003402010088000408012O003402012O002A01026O0034000300013O00122O000400893O00122O0005008A6O0003000500024O00020002000300202O0002000200174O00020002000200062O0002003402013O000408012O003402012O002A010200083O0006C30002003402013O000408012O003402012O002A0102000B4O00E9000300126O000400106O000500076O000600136O000700063O00202O00070007008B4O00095O00202O0009000900784O000700096O00063O00022O002C0005000500062O000F0103000500024O000400146O000500106O000600076O000700136O000800063O00202O00080008008B4O000A5O00202O000A000A00784O0008000A4O005800073O00022O002C0006000600072O002F0004000600022O003D0003000300040006630002003402010003000408012O003402012O002A0102000B4O006600038O000400013O00122O0005008C3O00122O0006008D6O0004000600024O00030003000400202O00030003002F4O0003000200024O0002000200034O000300076O000400136O000500063O00202O00050005008B4O00075O00202O0007000700784O000500076O00043O00024O00030003000400062O0003003402010002000408012O00340201002E2A008E00340201008F000408012O003402012O002A010200024O002A01035O0020D70003000300902O00E00002000200020006C30002003402013O000408012O003402012O002A010200013O00129D000300913O00129D000400924O00C6000200044O000700025O002E330093003D00010093000408012O007102012O002A01026O0034000300013O00122O000400943O00122O000500956O0003000500024O00020002000300202O0002000200174O00020002000200062O0002007102013O000408012O007102012O002A010200083O0006C30002007102013O000408012O007102012O002A0102000B4O005F000300126O000400106O000500076O0003000500024O000400146O000500106O000600076O0004000600024O00030003000400062O0002007102010003000408012O007102012O002A0102000B4O00D100038O000400013O00122O000500963O00122O000600976O0004000600024O00030003000400202O00030003002F4O0003000200024O0002000200034O000300074O002A010400134O0011000500063O00202O00050005008B4O00075O00202O0007000700784O000500076O00043O00024O00030003000400062O0003007102010002000408012O00710201002E2A0098007102010099000408012O007102012O002A010200024O002A01035O0020D70003000300902O00E00002000200020006C30002007102013O000408012O007102012O002A010200013O00129D0003009A3O00129D0004009B4O00C6000200044O000700025O00129D0001009C3O002E2A009D00F70201009E000408012O00F70201000E14019F00F702010001000408012O00F702012O002A01026O0034000300013O00122O000400A03O00122O000500A16O0003000500024O00020002000300202O00020002002B4O00020002000200062O000200AB02013O000408012O00AB02012O002A010200154O000E0002000100020006C3000200AB02013O000408012O00AB02012O002A01026O0034000300013O00122O000400A23O00122O000500A36O0003000500024O00020002000300202O0002000200174O00020002000200062O000200AB02013O000408012O00AB02012O002A010200063O00208700020002003E4O00045O00202O0004000400A44O00020004000200262O000200AB020100A5000408012O00AB02012O002A010200163O000E35013400AB02010002000408012O00AB02012O002A010200024O005100035O00202O0003000300A64O000400033O00202O00040004000B4O00065O00202O0006000600A64O0004000600024O000400046O00020004000200062O000200A602010001000408012O00A60201002E2A00A700AB020100A8000408012O00AB02012O002A010200013O00129D000300A93O00129D000400AA4O00C6000200044O000700025O002E2A00AB00CB020100AC000408012O00CB02012O002A01026O0034000300013O00122O000400AD3O00122O000500AE6O0003000500024O00020002000300202O00020002002B4O00020002000200062O000200CB02013O000408012O00CB02012O002A010200024O004200035O00202O0003000300374O000400033O00202O00040004000B4O00065O00202O0006000600374O0004000600024O000400046O0005000E6O00020005000200062O000200C602010001000408012O00C60201002EA800AF00CB020100B0000408012O00CB02012O002A010200013O00129D000300B13O00129D000400B24O00C6000200044O000700025O002E3300B3002B000100B3000408012O00F602012O002A01026O0034000300013O00122O000400B43O00122O000500B56O0003000500024O00020002000300202O0002000200094O00020002000200062O000200E102013O000408012O00E102012O002A010200083O0006AD000200E102010001000408012O00E102012O002A010200033O00201D0102000200B64O00045O00202O0004000400464O00020004000200062O000200E302010001000408012O00E30201002E3300B70015000100B8000408012O00F60201002E3300B90013000100B9000408012O00F602012O002A010200024O00AC00035O00202O0003000300554O000400033O00202O00040004005600122O000600576O0004000600024O000400046O0005000E6O00020005000200062O000200F602013O000408012O00F602012O002A010200013O00129D000300BA3O00129D000400BB4O00C6000200044O000700025O00129D000100BC3O0026A6000100FB0201009C000408012O00FB0201002EA800BD00AF030100BE000408012O00AF03012O002A01026O0034000300013O00122O000400BF3O00122O000500C06O0003000500024O00020002000300202O0002000200094O00020002000200062O0002003103013O000408012O003103012O002A010200083O0006C30002003103013O000408012O003103012O002A0102000B4O003F0103000D6O000400063O00202O00040004003E4O00065O00202O00060006003F4O0004000600024O0003000300044O000400106O00030003000400062O0002003103010003000408012O003103012O002A010200063O0020470102000200514O00045O00202O0004000400C14O00020004000200062O0002003103013O000408012O00310301002E3300C2000F000100C2000408012O002A03012O002A010200024O004200035O00202O0003000300C34O000400033O00202O00040004000B4O00065O00202O0006000600C34O0004000600024O000400046O0005000E6O00020005000200062O0002002C03010001000408012O002C0301002EA800C4003103010035000408012O003103012O002A010200013O00129D000300C53O00129D000400C64O00C6000200044O000700026O002A01026O0034000300013O00122O000400C73O00122O000500C86O0003000500024O00020002000300202O0002000200094O00020002000200062O0002004A03013O000408012O004A03012O002A010200083O0006C30002004A03013O000408012O004A03012O002A0102000B4O00480103000D6O000400063O00202O00040004003E4O00065O00202O00060006003F4O0004000600024O0003000300044O000400106O00030003000400062O0002004E03010003000408012O004E0301002EC000CA004E030100C9000408012O004E0301002EA800CC0061030100CB000408012O006103012O002A010200024O005100035O00202O00030003000A4O000400033O00202O00040004000B4O00065O00202O00060006000A4O0004000600024O000400046O00020004000200062O0002005C03010001000408012O005C0301002EA800CD0061030100CE000408012O006103012O002A010200013O00129D000300CF3O00129D000400D04O00C6000200044O000700026O002A01026O0034000300013O00122O000400D13O00122O000500D26O0003000500024O00020002000300202O0002000200094O00020002000200062O0002009803013O000408012O009803012O002A010200063O0020470102000200514O00045O00202O0004000400C14O00020004000200062O0002009803013O000408012O009803012O002A010200063O0020470102000200514O00045O00202O0004000400D34O00020004000200062O0002008003013O000408012O008003012O002A010200063O00201D01020002008B4O00045O00202O00040004003F4O00020004000200062O0002008F03010001000408012O008F03012O002A010200063O00204701020002008B4O00045O00202O0004000400D34O00020004000200062O0002009803013O000408012O009803012O002A010200063O0020B100020002003E4O00045O00202O00040004003F4O0002000400024O0003000D3O00062O0002009803010003000408012O009803012O002A010200063O00207C0002000200D44O0002000200024O000300063O00202O0003000300D54O00030002000200202O00030003001000062O0002009C03010003000408012O009C0301002EC000D7009C030100D6000408012O009C0301002EA800D900AE030100D8000408012O00AE03012O002A010200024O002D00035O00202O0003000300C34O000400033O00202O00040004000B4O00065O00202O0006000600C34O0004000600024O000400046O0005000E6O00020005000200062O000200AE03013O000408012O00AE03012O002A010200013O00129D000300DA3O00129D000400DB4O00C6000200044O000700025O00129D0001009F3O002E2A00DD0005000100DC000408012O0005000100261400010005000100BC000408012O000500012O002A01026O0034000300013O00122O000400DE3O00122O000500DF6O0003000500024O00020002000300202O0002000200094O00020002000200062O000200CB03013O000408012O00CB03012O002A0102000F3O0006C3000200CB03013O000408012O00CB03012O002A010200083O0006AD000200CB03010001000408012O00CB03012O002A010200163O000E35013400CB03010002000408012O00CB03012O002A010200173O0020D70002000200E02O000E0002000100020006AD000200CD03010001000408012O00CD0301002E3300E10012000100E2000408012O00DD03012O002A010200024O006D000300183O00202O0003000300E34O000400033O00202O00040004005600122O0006001E6O0004000600024O000400046O00020004000200062O000200DD03013O000408012O00DD03012O002A010200013O00129D000300E43O00129D000400E54O00C6000200044O000700026O002A01026O0034000300013O00122O000400E63O00122O000500E76O0003000500024O00020002000300202O0002000200094O00020002000200062O0002000304013O000408012O000304012O002A0102000F3O0006C30002000304013O000408012O000304012O002A010200083O0006AD0002000304010001000408012O000304012O002A01026O0034000300013O00122O000400E83O00122O000500E96O0003000500024O00020002000300202O0002000200174O00020002000200062O0002000304013O000408012O000304012O002A010200033O0020470102000200B64O00045O00202O0004000400464O00020004000200062O0002000304013O000408012O000304012O002A010200173O0020D70002000200E02O000E0002000100020006AD0002000504010001000408012O00050401002EA800EA0015040100EB000408012O001504012O002A010200024O006D000300183O00202O0003000300E34O000400033O00202O00040004005600122O0006001E6O0004000600024O000400046O00020004000200062O0002001504013O000408012O001504012O002A010200013O00129D000300EC3O00129D000400ED4O00C6000200044O000700025O002E2A00EE0039040100EF000408012O003904012O002A01026O00D2000300013O00122O000400F03O00122O000500F16O0003000500024O00020002000300202O0002000200094O00020002000200062O0002002304010001000408012O00230401002E2A00F20039040100F3000408012O00390401002EA800F50039040100F4000408012O00390401002E2A00F70039040100F6000408012O003904012O002A010200024O002D00035O00202O0003000300C34O000400033O00202O00040004000B4O00065O00202O0006000600C34O0004000600024O000400046O0005000E6O00020005000200062O0002003904013O000408012O003904012O002A010200013O00129D000300F83O00129D000400F94O00C6000200044O000700025O00129D000100023O000408012O00050001000408012O003D0401000408012O000200012O009E3O00017O00473O00028O00026O00F03F025O00907440025O00E07C40030B3O00F8560F341CCAEFACC6561703083O00E3A83A6E4D79B8CF025O00A6A940025O00F49040030E3O005E31BA52B0D775877733AC53BED603083O00C51B5CDF20D1BB1103073O004973526561647903103O004865616C746850657263656E74616765025O0070724003143O00456D6572616C64426C6F2O736F6D506C6179657203173O000652C6E90253C7C40153CCE81050CEBB0E5ECAF5430B9103043O009B633FA3025O00DCB240025O00F49A4003083O00A7C7A49FA08B8CD403063O00E4E2B1C1EDD9025O00B88740025O0018B040025O00406940025O00EEA740030E3O0011BD26F435BC27C438BF30F53BBD03043O008654D043025O0069B040025O00CCA04003133O00456D6572616C64426C6F2O736F6D466F637573025O0008A840025O003AB240025O000C9940025O00FCB14003173O0016A1834E12A0826311A0894F00A38B1C1EAD8F5253F8D403043O003C73CCE6025O00AC9F40025O00ACA740025O0040A440025O00E89840025O005AA940025O00DCAB40025O0026A140025O0084B340030B3O00097F7858CB2B33564FC22003053O00AE59131921030E3O001917404AF6891F0A1F505CF6840E03073O006B4F72322E97E7025O0086A440025O00D07740025O00B07140025O00C0B14003143O0056657264616E74456D6272616365506C6179657203173O002FA3A72D8B37A3FF3CABB73B8B3AB28034A7BC27CA6DE703083O00A059C6D549EA59D7025O00508340025O00D8AD4003083O006D67B1ECDC477FB103053O00A52811D49E03083O00CBD61C7312E4D72O03053O004685B96853030E3O003240562EC80A516127CB1644472F03053O00A96425244A025O00108D40025O00508940025O00BFB040026O005F4003133O0056657264616E74456D6272616365466F63757303173O001682B0540189B66F058AA0420184A7100D86AB5E40D3F203043O003060E7C2025O0012A440025O009CAE4000D33O00129D3O00014O004E000100013O0026143O000200010001000408012O0002000100129D000100013O0026140001006200010002000408012O00620001002E2A0003001100010004000408012O001100012O002A01026O0017010300013O00122O000400053O00122O000500066O00030005000200062O0002001100010003000408012O00110001000408012O00310001002E2A0008003100010007000408012O003100012O002A010200024O0034000300013O00122O000400093O00122O0005000A6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002003100013O000408012O003100012O002A010200033O00200D01020002000C2O00E00002000200022O002A010300043O0006630002003100010003000408012O00310001002E33000D000E0001000D000408012O003100012O002A010200054O0023000300063O00202O00030003000E4O000400046O00020004000200062O0002003100013O000408012O003100012O002A010200013O00129D0003000F3O00129D000400104O00C6000200044O000700025O002EA80012003A00010011000408012O003A00012O002A01026O0005010300013O00122O000400133O00122O000500146O00030005000200062O000200D200010003000408012O00D20001002E2A0016003D00010015000408012O003D0001000408012O00D20001002E2A001700D200010018000408012O00D200012O002A010200024O0034000300013O00122O000400193O00122O0005001A6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002004F00013O000408012O004F00012O002A010200073O00200D01020002000C2O00E00002000200022O002A010300043O0006DB0002005100010003000408012O00510001002E2A001B00D20001001C000408012O00D200012O002A010200054O0027000300063O00202O00030003001D4O000400046O00020004000200062O0002005C00010001000408012O005C0001002EC0001F005C0001001E000408012O005C0001002E2A002100D200010020000408012O00D200012O002A010200013O001280000300223O00122O000400236O000200046O00025O00044O00D20001000EFC0001006800010001000408012O00680001002EC00025006800010024000408012O00680001002EA80026000500010027000408012O0005000100129D000200013O002EA80028006D00010029000408012O006D00010026A60002006F00010001000408012O006F0001002EA8002B00C80001002A000408012O00C800012O002A010300084O0017010400013O00122O0005002C3O00122O0006002D6O00040006000200062O0003007700010004000408012O00770001000408012O009700012O002A010300024O0034000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O00030003000B4O00030002000200062O0003008700013O000408012O008700012O002A010300033O00200D01030003000C2O00E00003000200022O002A010400093O0006DB0003008900010004000408012O00890001002EA80030009700010031000408012O00970001002E2A0032009700010033000408012O009700012O002A010300054O0023000400063O00202O0004000400344O000500056O00030005000200062O0003009700013O000408012O009700012O002A010300013O00129D000400353O00129D000500364O00C6000300054O000700035O002E2A003700C700010038000408012O00C700012O002A010300084O0017010400013O00122O000500393O00122O0006003A6O00040006000200062O000300A700010004000408012O00A700012O002A010300084O0005010400013O00122O0005003B3O00122O0006003C6O00040006000200062O000300C700010004000408012O00C700012O002A010300024O0034000400013O00122O0005003D3O00122O0006003E6O0004000600024O00030003000400202O00030003000B4O00030002000200062O000300B700013O000408012O00B700012O002A010300073O00200D01030003000C2O00E00003000200022O002A010400093O0006DB000300B900010004000408012O00B90001002EA8003F00C700010040000408012O00C70001002EA8004200C700010041000408012O00C700012O002A010300054O0023000400063O00202O0004000400434O000500056O00030005000200062O000300C700013O000408012O00C700012O002A010300013O00129D000400443O00129D000500454O00C6000300054O000700035O00129D000200023O002EA80046006900010047000408012O006900010026140002006900010002000408012O0069000100129D000100023O000408012O00050001000408012O00690001000408012O00050001000408012O00D20001000408012O000200012O009E3O00017O00213O00028O00025O00A4A840025O00B89F4003063O0045786973747303093O004973496E52616E6765026O003E4003173O0044697370652O6C61626C65467269656E646C79556E6974025O00BAB240025O0014A54003073O00C222FB65E93DEE03043O0010875A8B03073O004973526561647903133O00556E6974486173506F69736F6E446562752O66030C3O00457870756E6765466F637573030E3O00716C162640537D14700F205E517403073O0018341466532E34026O00F03F025O00588140025O00388140025O0062AD40025O00508540025O00507040025O003AAE40025O002OA040025O00208A40030E3O00EB3F31360AD73C282A08F62O203603053O006FA44F414403113O00556E6974486173456E7261676542752O66030E3O004F2O7072652O73696E67526F6172025O00E07440025O00D4A74003163O00E9C993CC2BF9D5D08DD96ED8C9D8919E2AE3D5C986D203063O008AA6B9E3BE4E00783O00129D3O00014O004E000100013O0026143O000200010001000408012O0002000100129D000100013O000E142O01004B00010001000408012O004B000100129D000200014O004E000300033O0026140002000900010001000408012O0009000100129D000300013O000EFC0001001000010003000408012O00100001002EA80002004200010003000408012O004200012O002A01045O0006C30004002500013O000408012O002500012O002A01045O00200D0104000400042O00E00004000200020006C30004002500013O000408012O002500012O002A01045O00200D01040004000500129D000600064O002F0004000600020006C30004002500013O000408012O002500012O002A010400013O0020D70004000400072O000E0004000100020006C30004002500013O000408012O00250001002E2A0008002600010009000408012O002600012O009E3O00014O002A010400024O0034000500033O00122O0006000A3O00122O0007000B6O0005000700024O00040004000500202O00040004000C4O00040002000200062O0004004100013O000408012O004100012O002A010400013O0020D700040004000D2O002A01056O00E00004000200020006C30004004100013O000408012O004100012O002A010400044O002A010500053O0020D700050005000E2O00E00004000200020006C30004004100013O000408012O004100012O002A010400033O00129D0005000F3O00129D000600104O00C6000400064O000700045O00129D000300113O0026A60003004600010011000408012O00460001002EA80012000C00010013000408012O000C000100129D000100113O000408012O004B0001000408012O000C0001000408012O004B0001000408012O000900010026A60001004F00010011000408012O004F0001002EA80014000500010015000408012O00050001002E2A0016007700010017000408012O00770001002E2A0019007700010018000408012O007700012O002A010200024O0034000300033O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002007700013O000408012O007700012O002A010200063O0006C30002007700013O000408012O007700012O002A010200013O0020D700020002001C2O002A010300074O00E00002000200020006C30002007700013O000408012O007700012O002A010200044O002A010300023O0020D700030003001D2O00E00002000200020006AD0002006E00010001000408012O006E0001002E2A001F00770001001E000408012O007700012O002A010200033O001280000300203O00122O000400216O000200046O00025O00044O00770001000408012O00050001000408012O00770001000408012O000200012O009E3O00017O00B63O00028O00026O001440026O00F03F025O0072A240025O009C9040025O00F89B40025O002AA940030C3O004570696353652O74696E677303083O00795D9CF643568FF103043O00822A38E803113O00DFA621CC422CE3B12DE24E0CE9B428E65303063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C12303103O00037BF7512870E5561F7AE554296ACC6803043O00384C1984025O006BB140025O0016AE40027O0040026O001840025O0032A740025O00109D4003083O006DC4BF32C650C6B803053O00AF3EA1CB4603083O0009CEC63B3A2AD8D103053O00555CBDA37303083O001AA9242C20A2372B03043O005849CC5003093O00068C06433BEE278E1503063O00BA4EE3702649025O008AAC40025O00C7B240026O001040025O0096A040025O00804340025O004CAA40025O004EAC4003083O00C949F6E87EF44BF103053O00179A2C829C03103O0024B5A89C331D14B1A4A02O311DA7B7AB03063O007371C6CDCE5603083O00B752EA4E8D59F94903043O003AE4379E030F3O00868CDE2O2BA43BB3ABDC2F26A81D8403073O0055D4E9B04E5CCD03083O0073ADB3F7194EAFB403053O007020C8C78303123O00055E48BDD1B9373C4468B0D1AE31245F50BC03073O00424C303CD8A3CB03083O0089836DE756C023A903073O0044DAE619933FAE03113O0098395663A6BD38565FA5A424547EB9AC3803053O00D6CD4A332C025O00A8A040025O00206940025O0010B240025O00049E40025O00F2B040025O007DB140025O0050A040025O00789F40025O00C2A940025O0052B240026O000840025O00109B40025O00B2AB40025O00807840025O00B8A940025O00949140026O00504003083O003B5C1D4B01570E4C03043O003F683969030E3O003E94A16C0E86A8500394B04B058203043O00246BE7C403083O006EB0B69354BBA59403043O00E73DD5C2030D3O0021A83C7F1DA52E6706A3385B3903043O001369CD5D03083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB7030D3O00DD1DD5EC89ADD430FB01C0FA9F03083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD384030B3O001184684FD7A396CD338B6803083O00B855ED1B3FB2CFD403083O00CF52E9415A74FB4403063O001A9C379D3533030E3O00A0D918DDAB5C85DC13ECAB518BDD03063O0030ECB876B9D8034O0003083O00D6B84324C63AE2AE03063O005485DD3750AF03123O008EE831B4C45992E109A7C055BED237A7C05903063O003CDD8744C6A703083O00DDB8EC974BD7E9AE03063O00B98EDD98E32203113O006BCA42E84036D85EE856FD4A30D959C85203073O009738A5379A2353025O00C05D40025O00B3B140025O0056A340025O002EAE40025O001AA140025O00F49A4003083O009A0DCA9536A70FCD03053O005FC968BEE1030F3O0087CACFCAA3CEE0C8A9C7C8CDBBCEC503043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803113O000408E808200CCF022F06F41C231BE30D2003043O006C4C6986025O00D49A40025O009AAA40025O001EA940025O004AAF4003083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103113O008ABDF6C4D4116568B784EBD5CE30646DAD03083O0018C3D382A1A6631003083O007506FD385A18411003063O00762663894C3303163O00D42811171B32E836113D072CE4110D1B1D25F12F160603063O00409D46657269025O00805D40025O00609D40025O0040A940025O00089140025O00DEA240025O00C88440025O0032A940025O00D09C40025O00049140025O003AA14003083O0046B44F5EDF7BB64803053O00B615D13B2A030F3O009F52C411282OB067CA0928B1B97FF503063O00DED737A57D4103083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03163O00909900EC7573B6990CC07E59A3BE0DCB5B64AA841FCB03063O0016C5EA65AE19025O00C4A040025O00A08340025O00AEAA40025O0061B140025O0044A540025O00A5B24003083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC03103O000956D99CFF7C01354BDB84F56904334B03073O006D5C25BCD49A1D03083O0037EAB0D7385403FC03063O003A648FC4A35103113O00324722AF3647E23E15562AAC3167E4031F03083O006E7A2243C35F2985025O005C9B40025O00F07740025O00949B40025O00D6B04003083O00C2EF38A22CFFED3F03053O0045918A4CD603103O0046CA9B8DBE1864EA848BAD1773CAA1B903063O007610AF2OE9DF03083O00B88121AFE7857A9803073O001DEBE455DB8EEB03103O0018D9BFCF7642237031DBA9CE78430F6203083O00325DB4DABD172E47025O00C09340025O0083B04003083O00F871D1235B2D1ED803073O0079AB14A557324303133O00F03DAB32B80CD21DB434AB03C53D8C25B805C303063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E603133O00FF845A100DE1DEAB530D1FFED5846A110DEADF03063O008DBAE93F626C025O00208E40025O00508C40026O006940003C022O00129D3O00014O004E000100013O0026143O000200010001000408012O0002000100129D000100013O0026140001005900010002000408012O0059000100129D000200013O000E142O01003200010002000408012O0032000100129D000300013O0026A60003000F00010003000408012O000F0001002EA80004001100010005000408012O0011000100129D000200033O000408012O003200010026A60003001500010001000408012O00150001002EA80007000B00010006000408012O000B00010012FB000400084O007F000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400054O000500013O00122O0006000B3O00122O0007000C6O0005000700024O0004000400054O00045O00122O000400086O000500013O00122O0006000D3O00122O0007000E6O0005000700024O0004000400054O000500013O00122O0006000F3O00122O000700106O0005000700024O00040004000500062O0004002F00010001000408012O002F000100129D000400014O0073000400023O00129D000300033O000408012O000B0001002EA80012003800010011000408012O003800010026140002003800010013000408012O0038000100129D000100143O000408012O005900010026A60002003C00010003000408012O003C0001002EA80015000800010016000408012O000800010012FB000300084O007F000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000300033O00122O000300086O000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000400013O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400062O0003005600010001000408012O0056000100129D000300014O0073000300043O00129D000200133O000408012O00080001002EA8001F00A300010020000408012O00A300010026A60001005F00010021000408012O005F0001002E330022004600010023000408012O00A3000100129D000200013O0026140002006400010013000408012O0064000100129D000100023O000408012O00A30001002EA80024008400010025000408012O008400010026140002008400010003000408012O008400010012FB000300084O007F000400013O00122O000500263O00122O000600276O0004000600024O0003000300044O000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000300053O00122O000300086O000400013O00122O0005002A3O00122O0006002B6O0004000600024O0003000300044O000400013O00122O0005002C3O00122O0006002D6O0004000600024O00030003000400062O0003008200010001000408012O0082000100129D000300014O0073000300063O00129D000200133O000E142O01006000010002000408012O006000010012FB000300084O00D0000400013O00122O0005002E3O00122O0006002F6O0004000600024O0003000300044O000400013O00122O000500303O00122O000600316O0004000600024O00030003000400062O0003009400010001000408012O0094000100129D000300014O0073000300073O00128E000300086O000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300083O00122O000200033O00044O006000010026A6000100A900010013000408012O00A90001002EC0003600A900010037000408012O00A90001002E330038005B00010039000408012O00022O0100129D000200014O004E000300033O0026A6000200B100010001000408012O00B10001002EC0003B00B10001003A000408012O00B10001002E2A003C00AB0001003D000408012O00AB000100129D000300013O000EFC001300B600010003000408012O00B60001002E2A003F00B80001003E000408012O00B8000100129D000100403O000408012O00022O010026A6000300BC00010003000408012O00BC0001002EA8004200E400010041000408012O00E4000100129D000400013O002EA8004300C500010044000408012O00C50001002EA8004600C500010045000408012O00C50001002614000400C500010003000408012O00C5000100129D000300133O000408012O00E40001002614000400BD00010001000408012O00BD00010012FB000500084O007F000600013O00122O000700473O00122O000800486O0006000800024O0005000500064O000600013O00122O000700493O00122O0008004A6O0006000800024O0005000500064O000500093O00122O000500086O000600013O00122O0007004B3O00122O0008004C6O0006000800024O0005000500064O000600013O00122O0007004D3O00122O0008004E6O0006000800024O00050005000600062O000500E100010001000408012O00E1000100129D000500014O00730005000A3O00129D000400033O000408012O00BD0001002614000300B200010001000408012O00B200010012FB000400084O00EF000500013O00122O0006004F3O00122O000700506O0005000700024O0004000400054O000500013O00122O000600513O00122O000700526O0005000700024O0004000400054O0004000B3O00122O000400086O000500013O00122O000600533O00122O000700546O0005000700024O0004000400054O000500013O00122O000600553O00122O000700566O0005000700024O0004000400054O0004000C3O00122O000300033O000408012O00B20001000408012O00022O01000408012O00AB0001002614000100322O010014000408012O00322O010012FB000200084O00D0000300013O00122O000400573O00122O000500586O0003000500024O0002000200034O000300013O00122O000400593O00122O0005005A6O0003000500024O00020002000300062O000200122O010001000408012O00122O0100129D0002005B4O00730002000D3O001240010200086O000300013O00122O0004005C3O00122O0005005D6O0003000500024O0002000200034O000300013O00122O0004005E3O00122O0005005F6O0003000500024O00020002000300062O000200212O010001000408012O00212O0100129D0002005B4O00730002000E3O001240010200086O000300013O00122O000400603O00122O000500616O0003000500024O0002000200034O000300013O00122O000400623O00122O000500636O0003000500024O00020002000300062O000200302O010001000408012O00302O0100129D0002005B4O00730002000F3O000408012O003B02010026A6000100362O010040000408012O00362O01002EA80065008A2O010064000408012O008A2O0100129D000200014O004E000300033O002614000200382O010001000408012O00382O0100129D000300013O0026A60003003F2O010001000408012O003F2O01002E2A006700622O010066000408012O00622O0100129D000400013O002614000400442O010003000408012O00442O0100129D000300033O000408012O00622O01002EA8006900402O010068000408012O00402O01000E142O0100402O010004000408012O00402O010012FB000500084O00EF000600013O00122O0007006A3O00122O0008006B6O0006000800024O0005000500064O000600013O00122O0007006C3O00122O0008006D6O0006000800024O0005000500064O000500103O00122O000500086O000600013O00122O0007006E3O00122O0008006F6O0006000800024O0005000500064O000600013O00122O000700703O00122O000800716O0006000800024O0005000500064O000500113O00122O000400033O000408012O00402O01002E2A007200812O010073000408012O00812O010026A6000300682O010003000408012O00682O01002E2A007500812O010074000408012O00812O010012FB000400084O00EF000500013O00122O000600763O00122O000700776O0005000700024O0004000400054O000500013O00122O000600783O00122O000700796O0005000700024O0004000400054O000400123O00122O000400086O000500013O00122O0006007A3O00122O0007007B6O0005000700024O0004000400054O000500013O00122O0006007C3O00122O0007007D6O0005000700024O0004000400054O000400133O00122O000300133O0026A6000300852O010013000408012O00852O01002E33007E00B8FF2O007F000408012O003B2O0100129D000100213O000408012O008A2O01000408012O003B2O01000408012O008A2O01000408012O00382O01002E2A008100E42O010080000408012O00E42O01002E2A008300E42O010082000408012O00E42O01002614000100E42O010003000408012O00E42O0100129D000200013O002E2A008500BD2O010084000408012O00BD2O01002614000200BD2O010003000408012O00BD2O0100129D000300013O000EFC0001009A2O010003000408012O009A2O01002E2A008700B62O010086000408012O00B62O010012FB000400084O00D0000500013O00122O000600883O00122O000700896O0005000700024O0004000400054O000500013O00122O0006008A3O00122O0007008B6O0005000700024O00040004000500062O000400A82O010001000408012O00A82O0100129D000400014O0073000400143O001206000400086O000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400054O000500013O00122O0006008E3O00122O0007008F6O0005000700022O00280104000400052O0073000400153O00129D000300033O0026A6000300BA2O010003000408012O00BA2O01002EA8009000962O010091000408012O00962O0100129D000200133O000408012O00BD2O01000408012O00962O010026A6000200C32O010013000408012O00C32O01002EC0009300C32O010092000408012O00C32O01002EA8009500C52O010094000408012O00C52O0100129D000100133O000408012O00E42O01002614000200912O010001000408012O00912O010012FB000300084O007F000400013O00122O000500963O00122O000600976O0004000600024O0003000300044O000400013O00122O000500983O00122O000600996O0004000600024O0003000300044O000300163O00122O000300086O000400013O00122O0005009A3O00122O0006009B6O0004000600024O0003000300044O000400013O00122O0005009C3O00122O0006009D6O0004000600024O00030003000400062O000300E12O010001000408012O00E12O0100129D0003005B4O0073000300173O00129D000200033O000408012O00912O01002E2A009F00050001009E000408012O000500010026140001000500010001000408012O0005000100129D000200013O0026A6000200ED2O010003000408012O00ED2O01002E2A00A1000C020100A0000408012O000C02010012FB000300084O00D0000400013O00122O000500A23O00122O000600A36O0004000600024O0003000300044O000400013O00122O000500A43O00122O000600A56O0004000600024O00030003000400062O000300FB2O010001000408012O00FB2O0100129D000300014O0073000300183O001240010300086O000400013O00122O000500A63O00122O000600A76O0004000600024O0003000300044O000400013O00122O000500A83O00122O000600A96O0004000600024O00030003000400062O0003000A02010001000408012O000A020100129D000300014O0073000300193O00129D000200133O002E2A00AA002F020100AB000408012O002F02010026140002002F02010001000408012O002F02010012FB000300084O00D0000400013O00122O000500AC3O00122O000600AD6O0004000600024O0003000300044O000400013O00122O000500AE3O00122O000600AF6O0004000600024O00030003000400062O0003001E02010001000408012O001E020100129D0003005B4O00730003001A3O001240010300086O000400013O00122O000500B03O00122O000600B16O0004000600024O0003000300044O000400013O00122O000500B23O00122O000600B36O0004000600024O00030003000400062O0003002D02010001000408012O002D020100129D0003005B4O00730003001B3O00129D000200033O002E3300B400BAFF2O00B4000408012O00E92O01002E2A00B600E92O0100B5000408012O00E92O01002614000200E92O010013000408012O00E92O0100129D000100033O000408012O00050001000408012O00E92O01000408012O00050001000408012O003B0201000408012O000200012O009E3O00017O0015022O00028O00026O00F03F025O00F5B140025O004CA540026O001840030F3O00412O66656374696E67436F6D626174025O00D4B040025O000FB240026O00A840025O00AAA040025O0092A140025O00108140025O00408C40025O00E09540025O00708640025O002EAE40025O0020A540025O0072AC40027O0040025O0066A340025O005EA140025O00F49540025O00E88940025O00B5B040025O00D09540025O001AAA40025O0054B040025O00E07640026O00AE40025O00408F4003093O00497343617374696E67030C3O0049734368612O6E656C696E6703113O00496E74652O72757074576974685374756E03093O005461696C5377697065026O00204003093O00496E74652O7275707403053O005175652O6C026O00244003093O004D6F7573656F766572030E3O005175652O6C4D6F7573656F766572025O00C8A440025O00D09D40025O00A06240025O0086B140025O00E0A140025O009EA340025O00308440025O00349040025O0010AC40025O0039B140025O00E9B240025O005EA740030A3O006FD115EA20A659C213E803063O00C82BA3748D4F030F3O00432O6F6C646F776E52656D61696E73030D3O009A223891BEFDF7A6052891B7F103073O0083DF565DE3D094030A3O00C54CA4B33FA7E644A2BE03063O00D583252OD67D025O001CAC40025O0034AD40025O005EA640025O00D8A340025O00E2A740025O00D6B24003073O00132537BEF7232703053O0081464B45DF03073O0049735265616479030B3O00456E656D794162736F726203073O00556E726176656C030E3O0049735370652O6C496E52616E6765025O00B88940025O00988C40030E3O0053C5E1E86AEA4A8BFEE875E1069F03063O008F26AB93891C025O0050B240025O00449740025O0062B340025O000DB140025O00188440026O008A40025O00A2B240025O00B07D40025O004FB040025O00C4A540025O00405E40025O00389E40025O00A09D40025O00FEA540025O00ACB140025O0074A440025O0014A040025O0058A240026O000840025O0046B040025O0049B040025O0092AB40025O007C9B40025O001AAD40025O00805540025O00206340025O00607640025O00649D40025O00609C40025O00EAA140025O000EA640025O001AA940025O004C9F40025O00A6A54003043O00502O6F6C030E3O00C12A42E399F72A5FAFF8FE2005A603053O00B991452D8F025O005EB240025O004EA440025O0080A240025O000EAA40025O0002A940025O008AA540025O0054A040025O00B08640025O003C9840025O00A8A240025O00689E40025O0026AA40025O00D09640025O00A3B240025O0050A940025O0053B240025O0013B140025O00689D40025O00805840025O00CAB040025O00C9B040025O0034A140025O0068B340030F3O0048616E646C65412O666C696374656403073O00457870756E676503103O00457870756E67654D6F7573656F766572026O004440025O00407840025O00E06440025O00208340025O00788440025O00E8B240025O004AB04003113O0048616E646C65496E636F72706F7265616C03093O00536C2O657077616C6B03123O00536C2O657077616C6B4D6F7573656F766572026O003E40025O00089540025O0036AC40025O00F08D40025O0098A740025O007EA540025O0046AC40025O00D2AD40025O009C9E40025O0010A740025O00AEAD40026O006640025O00E49940025O00E0AD40025O00A6AC4003073O0047657454696D6503123O004C61737453746174696F6E61727954696D6503053O00F88DAFF61103073O00B4B0E2D9936383025O00D0A740025O00ECAD40025O00409940025O00ECAF40025O00B4A440025O00A0984003053O00486F766572030C3O00DBB63902C1F92206DAB76F5503043O0067B3D94F025O00D07340025O00E0AC40025O008AA040025O00689040025O0070AA40025O001EAD40025O00BCA040025O00409A40025O002EA44003043O006BA208DA03073O00C32AD77CB521EC030D3O003E56222C26FD025F1A3F22F10E03063O00986D39575E45030A3O0049734361737461626C6503093O004973496E52616E6765026O00394003043O0047554944030B3O0042752O6652656D61696E7303113O00536F757263656F664D6167696342752O66025O00C07240025O00709F40025O00E0A04003123O00536F757263656F664D61676963466F637573025O002C9140025O00489C4003193O00EAD81FB1BDD76BA7FFE807A2B9DB57E8E9C50FA0B1DF56A9ED03083O00C899B76AC3DEB23403083O0001E684384A4E37E703063O003A5283E85D29025O001CB340025O00F8AC40025O004CA240025O00D6AC40025O002OB240025O00C06D4003093O004E616D6564556E6974025O00B2A240025O00488340030D3O00B058C5075E3A8C51FD145A368003063O005FE337B0753D03113O00536F757263656F664D616769634E616D6503193O000B713659A81D412C4D94157F2442A8586E314EA81773214ABF03053O00CB781E432B025O00209540025O00DCA240030F3O0048616E646C65445053506F74696F6E03063O0042752O66557003133O0049726964657363656E6365426C756542752O66025O00F4AA40025O00D3B140025O00607040025O002OA840030D3O00BA1016AA9C8C100BE6EFBE575003053O00BCEA7F79C6025O00C09840025O00D6A140025O00A0A240025O00E4AF40025O0032A040025O003AA640025O009CA640025O00BAA940030D3O00457465726E6974795375726765025O00EC9340025O00708D40025O0022AE40025O00EEA040025O00989240025O000CB040025O0056B140025O00289E4003093O00436173745374617274025O00C8A240025O0056A340030F3O00456D706F7765724361737454696D65025O00608A40025O00C07140025O005C9140025O00709340025O0068A040025O00D88340025O002EA740025O00806840025O0051B240025O00CEA740025O0004AF40025O0032A240030D3O00A8E08CEC0E88E491E6338AE3B603053O005DED90E58F030D3O0030E2F50B054F01EFC30C19411003063O0026759690796B03083O001FBEFA2F3FB5C71E03043O005A4DDB8E03163O00D5102E295C0E74E144042D491574EF10380A59157DE303073O001A866441592C6703093O00486F76657242752O6603083O0049734D6F76696E67030A3O0046697265427265617468025O00949240025O009AA740025O00607A40025O00B07940025O0048B040025O005EAC40025O0058A340025O002OA640025O00C8A640025O0076AF40025O00809440025O005EAB40025O0098AA40030D3O002ABFA710CCEDF8C506A1A900CC03083O00B16FCFCE739F888C030A3O0023800211F65D5A049D1803073O003F65E97074B42F03083O00F13EF907EA38EA1F03063O0056A35B8D729803143O00601F7B632A5A0573331C5A19713318410E75673203053O005A336B1413025O00D8A140025O00A4B040025O00909840025O00D6AF40025O00F08340025O00E09040026O00B340026O00144003133O00D3EF3530B7F8ED372CA2E5EB3501B6FEED2A2603053O00C49183504303083O0042752O66446F776E03173O00426C652O73696E676F6674686542726F6E7A6542752O6603103O0047726F757042752O664D692O73696E67025O0010A340025O002DB04003133O00426C652O73696E676F6674686542726F6E7A6503203O001CBC031B0BE110B739071ED70AB803371AFA11BE1C0D58F80CB5050715EA1FA403063O00887ED0666878025O00E49740025O00A8B140025O00F09E40025O00049640025O0022A040025O00209A40025O00E8B140025O00B49340025O007C9040025O00E07F40025O0030B040025O0012A240025O0050A340025O006AA940025O00509840025O00F0A84003053O005085D846BD03083O003118EAAE23CF325D025O00A7B240030C3O0004FDEB8D634CFFFC817F4CA003053O00116C929DE8025O00B07F40025O00ECAA40025O0018B140025O001EA740025O0098A940025O001EA140025O00E2AA40025O0080AA40025O00388D40025O00608D40025O00109A40026O001040025O003CAA40025O0028B340025O00149740025O0092A340025O0002B040025O00B6A0402O033O00474344026O00D03F030A3O005370652O6C4861737465025O008AA640025O0078A640030D3O00546172676574497356616C6964025O004AA040025O0032A340025O00807D40025O005EA040030A3O00447261676F6E72616765025O00BAA340025O001AA740025O0034A940025O00BCAB40030D3O004973446561644F7247686F7374025O00207840025O00888C40025O001EAF40025O0048844003073O00FFC7B3922ODDDA03053O00B3BABFC3E703173O0044697370652O6C61626C65467269656E646C79556E697403093O00466F637573556E6974025O00BBB240025O003C9140025O0014B340025O0040B240025O00F09D40025O0097B040025O0016AD40025O00989640025O0072A740025O00B9B140025O006AA740025O0068AA40025O00E06840025O00589740025O00D4B14003043O00D82A0CEB03043O0084995F78030D3O0082BD1B3FF4DFAFB79F0F2AFED903073O00C0D1D26E4D97BA025O00E6B140025O00C2B240025O00A0B040025O00507D40030C3O0053686F756C6452657475726E03123O00466F637573537065636966696564556E6974025O00C0554003083O00C51527FBE6CBEE0603063O00A4806342899F030E3O00368CFBBA0187FD9B0D8BFBBF038C03043O00DE60E98903083O009CA5A20D91FCFEBC03073O0090D9D3C77FE893030E3O00DD223B3AD4490666F4202D3BDA4803083O0024984F5E48B52562025O00088340025O0062AE40025O0095B240025O00A2B140025O0088A440025O00FEA040025O006EA74003083O00F9D7537FE3D9493403043O005FB7B827030E3O00833AF522558E169032E53455830703073O0062D55F874634E0025O005EB140025O006CB140025O00588240025O0030A740025O00C05140030C3O00476574466F637573556E697403063O00D686E85B71CC03053O00349EC3A91703073O005E9D1F55A1104903083O00EB1ADC5214E6551B025O00C06C40025O00CAAA40025O0010AB40025O00C2A340025O00FAA84003103O004865616C746850657263656E74616765025O0042A240025O00707A40025O00405140025O0022A640025O00F0A140025O007CB140025O0058864003063O00A084C8EE51BA03053O0014E8C189A2025O0068AC40025O006C9C40025O005AAF40025O0040AA40025O00349140025O00809540025O0010B24003073O0006FEE887C0A92503083O001142BFA5C687EC77025O00F07340025O00889A40025O000C9540025O003EAD40025O0038A240030C3O004570696353652O74696E677303073O00DC22AE487EB9D203083O00D8884DC92F12DCA103043O0025E92AD603073O00E24D8C4BBA68BC03073O008DC1D73843BCDD03053O002FD9AEB05F03063O00BCD46512B75803083O0046D8BD1662D23418025O0036B240025O0087B340025O0028A940025O007CB240025O006AAE40025O0054A840025O0031B240025O00789040025O0082B14003113O00476574456E656D696573496E52616E676503173O00476574456E656D696573496E53706C61736852616E6765025O0016AB40025O00FCA240031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74025O00708040025O00F07F40025O00808640025O00E8A040025O00E88240025O00A4A040025O00309D40025O00107540025O001C9C40025O0046A040025O0036AE40025O00A49040025O0008A240025O0024A840025O0028AC4003103O00426F2O73466967687452656D61696E73025O004C9540025O002BB040025O0054AA40025O0039B040025O0024B040024O0080B3C540025O00C05640025O0078A540030C3O00466967687452656D61696E73025O003C9C40025O00F49A40025O00C88340025O0054A440025O0090774003073O00944C02E9AC461603043O008EC023652O033O00D97A2A03083O0076B61549C387ECCC025O0004B340025O00809040025O00FAA040025O00A88F40025O00709540025O00C88740025O00DAB040025O0040804003073O003C331D472O08EE03073O009D685C7A20646D2O033O00A2A9CA03083O00CBC3C6AFAA5D47ED03073O001A4439D25D14EF03073O009C4E2B5EB531712O033O0071ECD703073O00191288A4C36B230029092O00129D3O00014O004E000100023O0026A63O000600010002000408012O00060001002E330003001D09010004000408012O002109010026140001000600010001000408012O0006000100129D000200013O0026140002002203010005000408012O002203012O002A01035O00200D0103000300062O00E00003000200020006C30003003700013O000408012O0037000100129D000300014O004E000400053O0026A60003001600010002000408012O00160001002E330007000F00010008000408012O00230001000EFC0001001A00010004000408012O001A0001002EA8000900160001000A000408012O001600012O002A010600014O000E0006000100022O007B000500063O0006C30005003700013O000408012O003700012O000F000500023O000408012O00370001000408012O00160001000408012O00370001002E2A000C00120001000B000408012O00120001002EA8000D00120001000E000408012O001200010026140003001200010001000408012O0012000100129D000600013O0026140006002E00010002000408012O002E000100129D000300023O000408012O001200010026A60006003200010001000408012O00320001002E2A0010002A0001000F000408012O002A000100129D000400014O004E000500053O00129D000600023O000408012O002A0001000408012O001200012O002A01035O00200D0103000300062O00E00003000200020006AD0003003F00010001000408012O003F00012O002A010300023O0006C30003001403013O000408012O0014030100129D000300014O004E000400073O002EA80011004700010012000408012O004700010026140003004700010002000408012O004700012O004E000600073O00129D000300133O0026140003000E03010013000408012O000E0301000EFC0002004D00010004000408012O004D0001002E33001400BC02010015000408012O000703012O004E000700073O002EA80017005200010016000408012O005200010026A60005005400010001000408012O00540001002EA80018003B2O010019000408012O003B2O0100129D000800013O0026140008005900010013000408012O0059000100129D000500023O000408012O003B2O01002E2A001A005D00010010000408012O005D00010026A60008005F00010001000408012O005F0001002EA8001B00D80001001C000408012O00D80001002E2A001E00B70001001D000408012O00B700012O002A01095O00200D01090009001F2O00E00009000200020006AD000900B700010001000408012O00B700012O002A01095O00200D0109000900202O00E00009000200020006AD000900B700010001000408012O00B7000100129D000900014O004E000A000B3O002614000900AF00010002000408012O00AF0001002614000A007C00010002000408012O007C00012O002A010C00033O002083000C000C00214O000D00043O00202O000D000D002200122O000E00236O000C000E00024O000B000C3O00062O000B007B00013O000408012O007B00012O000F000B00023O00129D000A00133O002614000A008D00010013000408012O008D00012O002A010C00033O002022000C000C00244O000D00043O00202O000D000D002500122O000E00266O000F00013O00122O001000276O001100053O00202O0011001100284O000C001100024O000B000C3O00062O000B00B700013O000408012O00B700012O000F000B00023O000408012O00B70001000EFC000100930001000A000408012O00930001002E05002900930001002A000408012O00930001002EA8002C006F0001002B000408012O006F000100129D000C00013O0026A6000C009800010001000408012O00980001002E2A002E00A60001002D000408012O00A600012O002A010D00033O0020FE000D000D00244O000E00043O00202O000E000E002500122O000F00266O001000016O000D001000024O000B000D3O002E2O002F00A500010030000408012O00A500010006C3000B00A500013O000408012O00A500012O000F000B00023O00129D000C00023O0026A6000C00AA00010002000408012O00AA0001002EA80032009400010031000408012O0094000100129D000A00023O000408012O006F0001000408012O00940001000408012O006F0001000408012O00B70001000EFC000100B300010009000408012O00B30001002E2A0033006D00010034000408012O006D000100129D000A00014O004E000B000B3O00129D000900023O000408012O006D00012O002A010900074O0003010A00046O000B00083O00122O000C00353O00122O000D00366O000B000D00024O000A000A000B00202O000A000A00374O000A000200024O000B00046O000C00083O00129D000D00383O001217000E00396O000C000E00024O000B000B000C00202O000B000B00374O000B000200024O000C00093O00102O000C0013000C4O000B000B000C4O000C00046O000D00083O00129D000E003A3O001254000F003B6O000D000F00024O000C000C000D00202O000C000C00374O000C000200024O000D00096O000C000C000D4O0009000C00024O000900063O00122O000800023O002EA8003C00550001003D000408012O005500010026A6000800DE00010002000408012O00DE0001002EA8003E00550001003F000408012O00550001002EA8004000022O010041000408012O00022O012O002A010900044O0034000A00083O00122O000B00423O00122O000C00436O000A000C00024O00090009000A00202O0009000900444O00090002000200062O000900022O013O000408012O00022O012O002A0109000A3O00200D0109000900452O00E00009000200020006C3000900022O013O000408012O00022O012O002A0109000B4O0051000A00043O00202O000A000A00464O000B000A3O00202O000B000B00474O000D00043O00202O000D000D00464O000B000D00024O000B000B6O0009000B000200062O000900FD00010001000408012O00FD0001002EA8004900022O010048000408012O00022O012O002A010900083O00129D000A004A3O00129D000B004B4O00C60009000B4O000700096O002A0109000C3O0006AD0009000C2O010001000408012O000C2O012O002A0109000D3O0006AD0009000C2O010001000408012O000C2O01002E05004C000C2O01004D000408012O000C2O01002EA8004E00392O01004F000408012O00392O0100129D000900014O004E000A000B3O0026A6000900122O010001000408012O00122O01002EA8004D00232O010050000408012O00232O0100129D000C00013O0026A6000C00192O010002000408012O00192O01002EC0005200192O010051000408012O00192O01002E330053000400010054000408012O001B2O0100129D000900023O000408012O00232O010026A6000C001F2O010001000408012O001F2O01002E2A005500132O010056000408012O00132O0100129D000A00014O004E000B000B3O00129D000C00023O000408012O00132O01002E33005700EBFF2O0057000408012O000E2O010026140009000E2O010002000408012O000E2O01002EA8005800272O010059000408012O00272O01002614000A00272O010001000408012O00272O012O002A010C000E4O000E000C000100022O007B000B000C3O0006AD000B00342O010001000408012O00342O01002EC0005A00342O01005B000408012O00342O01002E33005C00070001005D000408012O00392O012O000F000B00023O000408012O00392O01000408012O00272O01000408012O00392O01000408012O000E2O0100129D000800133O000408012O00550001002614000500C12O01005E000408012O00C12O012O002A0108000F3O0006C30008005F2O013O000408012O005F2O0100129D000800014O004E0009000A3O0026A6000800482O010001000408012O00482O01002EC0006000482O01005F000408012O00482O01002EA80061004B2O010062000408012O004B2O0100129D000900014O004E000A000A3O00129D000800023O0026A60008004F2O010002000408012O004F2O01002E2A006300422O010064000408012O00422O010026A6000900532O010001000408012O00532O01002EA80041004F2O010065000408012O004F2O012O002A010B00104O000E000B000100022O007B000A000B3O0006AD000A005A2O010001000408012O005A2O01002E330066000700010067000408012O005F2O012O000F000A00023O000408012O005F2O01000408012O004F2O01000408012O005F2O01000408012O00422O012O002A010800113O00262E010800BA2O01005E000408012O00BA2O01002E2A006900652O010068000408012O00652O01000408012O00BA2O0100129D000800014O004E0009000A3O0026A60008006D2O010002000408012O006D2O01002EC0006B006D2O01006A000408012O006D2O01002E33006C00390001006D000408012O00A42O010026140009007B2O010002000408012O007B2O012O002A010B000B4O002A010C00043O0020D7000C000C006E2O00E0000B000200020006C3000B00BA2O013O000408012O00BA2O012O002A010B00083O001280000C006F3O00122O000D00706O000B000D6O000B5O00044O00BA2O01002E2A000A007F2O010071000408012O007F2O010026A6000900812O010001000408012O00812O01002E2A0072006D2O010073000408012O006D2O0100129D000B00013O0026A6000B00862O010002000408012O00862O01002EA8007400882O010075000408012O00882O0100129D000900023O000408012O006D2O01002EA8007700822O010076000408012O00822O01002614000B00822O010001000408012O00822O0100129D000C00013O002E2A007800932O010079000408012O00932O01002614000C00932O010002000408012O00932O0100129D000B00023O000408012O00822O01002614000C008D2O010001000408012O008D2O012O002A010D00124O000E000D000100022O007B000A000D3O002EA8007B009F2O01007A000408012O009F2O010006AD000A009E2O010001000408012O009E2O01002E2A007C009F2O01007D000408012O009F2O012O000F000A00023O00129D000C00023O000408012O008D2O01000408012O00822O01000408012O006D2O01000408012O00BA2O010026A6000800A82O010001000408012O00A82O01002E33007E00C1FF2O007F000408012O00672O0100129D000B00013O000EFC000200AF2O01000B000408012O00AF2O01002E05008000AF2O010081000408012O00AF2O01002EA8008200B12O010083000408012O00B12O0100129D000800023O000408012O00672O01002E2A008500A92O010084000408012O00A92O01002614000B00A92O010001000408012O00A92O0100129D000900014O004E000A000A3O00129D000B00023O000408012O00A92O01000408012O00672O012O002A010800134O000E0008000100022O007B000700083O0006C30007001403013O000408012O001403012O000F000700023O000408012O00140301000E140102006302010005000408012O0063020100129D000800013O002614000800C82O010013000408012O00C82O0100129D000500133O000408012O00630201002E2A0086000402010087000408012O000402010026140008000402010001000408012O000402012O002A010900143O0006C3000900E42O013O000408012O00E42O0100129D000900013O000E142O0100D02O010009000408012O00D02O012O002A010A00033O00202B010A000A00884O000B00043O00202O000B000B00894O000C00053O00202O000C000C008A00122O000D008B6O000A000D00024O0007000A3O002E2O008D00E42O01008C000408012O00E42O01002E33008E00070001008E000408012O00E42O010006C3000700E42O013O000408012O00E42O012O000F000700023O000408012O00E42O01000408012O00D02O012O002A010900153O0006C30009000302013O000408012O0003020100129D000900014O004E000A000A3O0026A6000900ED2O010001000408012O00ED2O01002E33008F00FEFF2O0075000408012O00E92O0100129D000A00013O0026A6000A00F22O010001000408012O00F22O01002EA8009000EE2O010091000408012O00EE2O012O002A010B00033O0020CF000B000B00924O000C00043O00202O000C000C00934O000D00053O00202O000D000D009400122O000E00956O000F00016O000B000F00024O0007000B3O00062O0007000302013O000408012O000302012O000F000700023O000408012O00030201000408012O00EE2O01000408012O00030201000408012O00E92O0100129D000800023O002E33009600C0FF2O0096000408012O00C42O01002614000800C42O010002000408012O00C42O0100129D000900013O002EA80098005902010097000408012O005902010026140009005902010001000408012O005902012O002A010A00163O0006C3000A001502013O000408012O001502012O002A010A5O00200D010A000A00062O00E0000A000200020006AD000A001702010001000408012O00170201002EA8009900270201009A000408012O0027020100129D000A00014O004E000B000B3O002E33009B3O0001009B000408012O00190201002614000A001902010001000408012O001902012O002A010C00174O000E000C000100022O007B000B000C3O002EA8009D00270201009C000408012O002702010006C3000B002702013O000408012O002702012O000F000B00023O000408012O00270201000408012O001902012O002A010A00183O0006C3000A002F02013O000408012O002F02012O002A010A5O00200D010A000A00062O00E0000A000200020006AD000A003102010001000408012O00310201002E2A009F00580201009E000408012O00580201002EA800A0003D020100A1000408012O003D0201002E2A00A3003D020100A2000408012O003D02010012FB000A00A44O000E010A0001000200122O000B00A56O000A000A000B4O000B00193O00062O000A003D0201000B000408012O003D0201000408012O005802012O002A010A00044O00D2000B00083O00122O000C00A63O00122O000D00A76O000B000D00024O000A000A000B00202O000A000A00444O000A0002000200062O000A004B02010001000408012O004B0201002E0500A9004B020100A8000408012O004B0201002EA800AB0058020100AA000408012O00580201002EA800AD0058020100AC000408012O005802012O002A010A000B4O002A010B00043O0020D7000B000B00AE2O00E0000A000200020006C3000A005802013O000408012O005802012O002A010A00083O00129D000B00AF3O00129D000C00B04O00C6000A000C4O0007000A5O00129D000900023O002E2A00B10009020100B2000408012O000902010026A60009005F02010002000408012O005F0201002E2A00B30009020100B4000408012O0009020100129D000800133O000408012O00C42O01000408012O00090201000408012O00C42O01002E3300B500EBFD2O00B5000408012O004E0001000E140113004E00010005000408012O004E000100129D000800013O0026A60008006C02010001000408012O006C0201002E2A00B600ED020100B7000408012O00ED0201002E2A00B80076020100B9000408012O007602012O002A0109001A4O0017010A00083O00122O000B00BA3O00122O000C00BB6O000A000C000200062O000900760201000A000408012O00760201000408012O00A202012O002A010900044O0034000A00083O00122O000B00BC3O00122O000C00BD6O000A000C00024O00090009000A00202O0009000900BE4O00090002000200062O000900A202013O000408012O00A202012O002A0109001B3O00200D0109000900BF00129D000B00C04O002F0009000B00020006C3000900A202013O000408012O00A202012O002A0109001C4O002A010A001B3O00200D010A000A00C12O00E0000A000200020006AB000900A20201000A000408012O00A202012O002A0109001B3O0020380009000900C24O000B00043O00202O000B000B00C34O0009000B000200262O000900A2020100C4000408012O00A20201002E2A00C500A2020100C6000408012O00A202012O002A0109001D4O002A010A00053O0020D7000A000A00C72O00E00009000200020006AD0009009D02010001000408012O009D0201002E3300C80007000100C9000408012O00A202012O002A010900083O00129D000A00CA3O00129D000B00CB4O00C60009000B4O000700096O002A0109001A4O0017010A00083O00122O000B00CC3O00122O000C00CD6O000A000C000200062O000900AA0201000A000408012O00AA0201000408012O00EC020100129D000900014O004E000A000B3O002614000900BD02010001000408012O00BD020100129D000C00013O0026A6000C00B302010002000408012O00B30201002E3300CE0004000100CF000408012O00B5020100129D000900023O000408012O00BD02010026A6000C00B902010001000408012O00B90201002E3300D000F8FF2O00D1000408012O00AF020100129D000A00014O004E000B000B3O00129D000C00023O000408012O00AF02010026A6000900C102010002000408012O00C10201002EA800D200AC020100D3000408012O00AC0201002614000A00C102010001000408012O00C102012O002A010C00033O002078000C000C00D400122O000D00C06O000E001E6O000C000E00024O000B000C3O002E2O00D600EC020100D5000408012O00EC02010006C3000B00EC02013O000408012O00EC02012O002A010C00044O0034000D00083O00122O000E00D73O00122O000F00D86O000D000F00024O000C000C000D00202O000C000C00BE4O000C0002000200062O000C00EC02013O000408012O00EC020100200D010C000B00C22O002A010E00043O0020D7000E000E00C32O002F000C000E000200262D010C00EC020100C4000408012O00EC02012O002A010C001D4O002A010D00053O0020D7000D000D00D92O00E0000C000200020006C3000C00EC02013O000408012O00EC02012O002A010C00083O001280000D00DA3O00122O000E00DB6O000C000E6O000C5O00044O00EC0201000408012O00C10201000408012O00EC0201000408012O00AC020100129D000800023O000E14011300F102010008000408012O00F1020100129D0005005E3O000408012O004E00010026A6000800F502010002000408012O00F50201002E2A00DD0068020100DC000408012O006802012O002A010900033O0020680009000900DE4O000A5O00202O000A000A00DF4O000C00043O00202O000C000C00E04O000A000C6O00093O00024O000600093O002E2O00E1002O030100E2000408012O002O03010006C30006002O03013O000408012O002O03012O000F000600023O00129D000800133O000408012O00680201000408012O004E0001000408012O00140301000E142O01004900010004000408012O0049000100129D000500014O004E000600063O00129D000400023O000408012O00490001000408012O001403010026140003004100010001000408012O0041000100129D000400014O004E000500053O00129D000300023O000408012O00410001002EA800E30028090100E4000408012O002809012O002A0103000B4O002A010400043O0020D700040004006E2O00E00003000200020006C30003002809013O000408012O002809012O002A010300083O001280000400E53O00122O000500E66O000300056O00035O00044O002809010026140002004904010013000408012O0049040100129D000300013O0026140003002903010013000408012O0029030100129D0002005E3O000408012O00490401002614000300B703010002000408012O00B7030100129D000400013O0026A60004003003010002000408012O00300301002E3300E70004000100E8000408012O0032030100129D000300133O000408012O00B70301002E2A00E9002C030100EA000408012O002C0301002E2A00EB002C030100EC000408012O002C03010026140004002C03010001000408012O002C0301002EA800ED00A9030100EE000408012O00A903012O002A01055O0020470105000500204O000700043O00202O0007000700EF4O00050007000200062O000500A903013O000408012O00A9030100129D000500014O004E000600073O002E2A00F1004A030100F0000408012O004A03010026140005004A03010001000408012O004A030100129D000600014O004E000700073O00129D000500023O0026A60005004E03010002000408012O004E0301002E2A00F20043030100F3000408012O00430301002E2A00F40052030100F5000408012O005203010026A60006005403010001000408012O00540301002E3300F600FCFF2O00F7000408012O004E03010012FB000800A44O00B00008000100024O00095O00202O0009000900F84O0009000200024O000700080009002E2O00F90063030100FA000408012O006303012O002A01085O00200D0108000800FB2O002A010A001F4O002F0008000A00020006630007006303010008000408012O00630301000408012O00A9030100129D000800014O004E0009000A3O0026140008006A03010001000408012O006A030100129D000900014O004E000A000A3O00129D000800023O0026A60008006E03010002000408012O006E0301002E2A00FC0065030100FD000408012O00650301002EA800FE006E030100FF000408012O006E03010026A60009007503010001000408012O0075030100129D000B002O012O000E350100016E0301000B000408012O006E030100129D000A00013O00129D000B0002012O00129D000C0003012O000663000C00760301000B000408012O0076030100129D000B00013O0006AB000A00760301000B000408012O0076030100129D000B00013O00129D000C00013O00061B010B00890301000C000408012O0089030100129D000C0004012O00129D000D0005012O0006DB000C00890301000D000408012O0089030100129D000C0006012O00129D000D0007012O00063E010C007E0301000D000408012O007E03012O002A010C00204O0070000D00083O00122O000E0008012O00122O000F0009015O000D000F00024O000E00046O000F00083O00122O0010000A012O00122O0011000B015O000F001100024O000E000E000F4O000F00083O00122O0010000C012O00122O0011000D015O000F001100024O000E000E000F4O000C000D000E4O000C00083O00122O000D000E012O00122O000E000F015O000C000E6O000C5O00044O007E0301000408012O00760301000408012O00A90301000408012O006E0301000408012O00A90301000408012O00650301000408012O00A90301000408012O004E0301000408012O00A90301000408012O004303012O002A01055O0020240005000500C24O000700043O00122O00080010015O0007000700084O00050007000200122O000600133O00062O000500B303010006000408012O00B303012O002C01056O00EA000500014O0073000500213O00129D000400023O000408012O002C030100129D000400013O0006AB0004002503010003000408012O002503012O002A01045O00129D00060011013O004D0004000400062O00E00004000200020006AD000400C303010001000408012O00C303010012FB000400A44O000E0004000100020012F0000400A54O002A01045O0020F20004000400204O000600043O00122O00070012015O0006000600074O00040006000200062O0004004704013O000408012O0047040100129D000400014O004E000500063O00129D00070013012O00129D00080014012O0006630007002604010008000408012O0026040100129D000700023O0006AB0007002604010004000408012O0026040100129D000700013O00061B010500DB03010007000408012O00DB030100129D00070015012O00129D00080016012O00063E010700D403010008000408012O00D403010012FB000700A44O00380107000100024O00085O00202O0008000800F84O0008000200024O00060007000800122O00070017012O00122O00080018012O00062O000800F003010007000408012O00F003012O002A01075O00200D0107000700FB2O002A010900224O002F0007000900020006DB0006004704010007000408012O0047040100129D00070019012O00129D0008001A012O000663000800F003010007000408012O00F00301000408012O0047040100129D000700014O004E000800083O00129D000900013O0006AB000700F203010009000408012O00F2030100129D000800013O00129D0009001B012O00129D000A001C012O00063E010900F60301000A000408012O00F6030100129D0009001D012O00129D000A001D012O0006AB000900F60301000A000408012O00F6030100129D000900013O0006AB000800F603010009000408012O00F6030100129D000900013O00129D000A00013O00061B010900090401000A000408012O0009040100129D000A001E012O00129D000B001F012O0006AB000A00020401000B000408012O000204012O002A010A00204O0070000B00083O00122O000C0020012O00122O000D0021015O000B000D00024O000C00046O000D00083O00122O000E0022012O00122O000F0023015O000D000F00024O000C000C000D4O000D00083O00122O000E0024012O00122O000F0025015O000D000F00024O000C000C000D4O000A000B000C4O000A00083O00122O000B0026012O00122O000C0027015O000A000C6O000A5O00044O00020401000408012O00F60301000408012O00470401000408012O00F20301000408012O00470401000408012O00D40301000408012O0047040100129D00070028012O00129D00080029012O000663000700CD03010008000408012O00CD030100129D000700013O0006AB000400CD03010007000408012O00CD030100129D000700013O00129D0008002A012O00129D0009002B012O00063E0108003804010009000408012O0038040100129D000800013O0006AB0007003804010008000408012O0038040100129D000500014O004E000600063O00129D000700023O00129D0008002C012O00129D0009002D012O00063E0108003F04010009000408012O003F040100129D000800023O00061B0107004304010008000408012O0043040100129D000800C93O00129D0009002E012O0006630009002E04010008000408012O002E040100129D000400023O000408012O00CD0301000408012O002E0401000408012O00CD030100129D000300023O000408012O0025030100129D0003002F012O0006AB0002004705010003000408012O0047050100129D000300013O00129D000400013O0006AB000300AA04010004000408012O00AA04012O002A01045O00200D0104000400062O00E00004000200020006AD0004008504010001000408012O008504012O002A010400233O0006C30004007504013O000408012O007504012O002A010400044O0034000500083O00122O00060030012O00122O00070031015O0005000700024O00040004000500202O0004000400BE4O00040002000200062O0004007504013O000408012O007504012O002A01045O00124B00060032015O0004000400064O000600043O00122O00070033015O0006000600074O000700016O00040007000200062O0004007904010001000408012O007904012O002A010400033O0012F900050034015O0004000400054O000500043O00122O00060033015O0005000500064O00040002000200062O0004007904010001000408012O0079040100129D00040035012O00129D00050036012O0006AB0004008504010005000408012O008504012O002A0104000B4O003C010500043O00122O00060037015O0005000500064O00040002000200062O0004008504013O000408012O008504012O002A010400083O00129D00050038012O00129D00060039013O00C6000400064O000700045O00129D0004003A012O00129D0005003B012O000663000400A904010005000408012O00A904012O002A010400163O0006C3000400A904013O000408012O00A904012O002A010400023O0006C3000400A904013O000408012O00A904012O002A01045O00200D0104000400062O00E00004000200020006AD000400A904010001000408012O00A9040100129D000400014O004E000500053O00129D000600013O00061B0104009D04010006000408012O009D040100129D0006003C012O00129D0007003D012O0006AB0006009604010007000408012O009604012O002A010600174O00F70006000100024O000500063O00122O0006003E012O00122O0007003E012O00062O000600A904010007000408012O00A904010006C3000500A904013O000408012O00A904012O000F000500023O000408012O00A90401000408012O0096040100129D000300023O00129D000400023O00061B010300B104010004000408012O00B1040100129D0004003F012O00129D00050040012O00063E0105003D05010004000408012O003D050100129D000400013O00129D000500023O00061B010400B904010005000408012O00B9040100129D00050041012O00129D00060042012O000663000500BB04010006000408012O00BB040100129D000300133O000408012O003D050100129D000500013O00061B010400C204010005000408012O00C2040100129D0005008F3O00129D00060043012O00063E010500B204010006000408012O00B2040100129D00050044012O00129D00060045012O00063E0106000205010005000408012O000205012O002A010500183O0006C30005000205013O000408012O000205012O002A010500023O0006AD000500D104010001000408012O00D104012O002A01055O00200D0105000500062O00E00005000200020006C30005000205013O000408012O0002050100129D00050046012O00129D00060047012O00063E010500DD04010006000408012O00DD04010012FB000500A44O000E01050001000200122O000600A56O0005000500064O000600193O00062O000500DD04010006000408012O00DD0401000408012O0002050100129D00050048012O00129D00060049012O0006630005000205010006000408012O000205012O002A010500044O0034000600083O00122O0007004A012O00122O0008004B015O0006000800024O00050005000600202O0005000500444O00050002000200062O0005000205013O000408012O000205012O002A01055O00124C00070032015O0005000500074O000700043O00202O0007000700AE4O00050007000200062O0005000205013O000408012O000205012O002A0105000B4O002A010600043O0020D70006000600AE2O00E00005000200020006AD000500FD04010001000408012O00FD040100129D0005004C012O00129D0006007D3O0006630005000205010006000408012O000205012O002A010500083O00129D0006004D012O00129D0007004E013O00C6000500074O000700056O002A01055O00200D0105000500062O00E00005000200020006AD0005000F05010001000408012O000F05012O002A010500023O0006C30005000F05013O000408012O000F05012O002A01055O00200D01050005001F2O00E00005000200020006C30005001305013O000408012O0013050100129D0005004F012O00129D00060050012O00063E0106003B05010005000408012O003B050100129D000500014O004E000600073O00129D00080051012O00129D00090052012O0006630009001F05010008000408012O001F050100129D000800013O0006AB0005001F05010008000408012O001F050100129D000600014O004E000700073O00129D000500023O00129D000800023O00061B0108002605010005000408012O0026050100129D00080053012O00129D00090054012O0006630008001505010009000408012O0015050100129D000800013O00061B0106002D05010008000408012O002D050100129D00080055012O00129D00090056012O00063E0108002605010009000408012O002605012O002A010800244O00020108000100024O000700083O00122O00080057012O00122O00090058012O00062O0008003B05010009000408012O003B05010006C30007003B05013O000408012O003B05012O000F000700023O000408012O003B0501000408012O00260501000408012O003B0501000408012O0015050100129D000400023O000408012O00B2040100129D00040059012O00129D00050059012O0006AB0004004D04010005000408012O004D040100129D000400133O0006AB0003004D04010004000408012O004D040100129D000200053O000408012O00470501000408012O004D040100129D0003005A012O00061B0102004E05010003000408012O004E050100129D0003005B012O00129D0004005C012O00063E010400DD05010003000408012O00DD050100129D000300014O004E000400043O00129D000500013O0006AB0003005005010005000408012O0050050100129D000400013O00129D0005005D012O00129D0006005E012O0006630005005D05010006000408012O005D050100129D000500133O0006AB0004005D05010005000408012O005D050100129D0002002F012O000408012O00DD050100129D000500013O00061B0105006405010004000408012O0064050100129D0005005F012O00129D00060060012O0006630005007A05010006000408012O007A05012O002A010500254O00E300065O00122O00080061015O0006000600084O00060002000200122O00070062015O0005000700024O000600266O00075O00122O00090061015O0007000700094O00070002000200122O00080062015O0006000800024O0005000500064O000500096O00055O00122O00070063015O0005000500074O0005000200024O000500273O00122O000400023O00129D000500833O00129D000600833O0006AB0005005405010006000408012O0054050100129D00050064012O00129D00060065012O0006630006005405010005000408012O0054050100129D000500023O0006AB0004005405010005000408012O0054050100129D000500013O00129D000600013O0006AB000500D005010006000408012O00D005012O002A010600273O001257000700026O0006000700064O000600286O000600033O00122O00070066015O0006000600074O00060001000200062O0006009605013O000408012O009605012O002A010600023O0006AD0006009F05010001000408012O009F05012O002A01065O00200D0106000600062O00E00006000200020006AD0006009F05010001000408012O009F050100129D00060067012O00129D00070068012O0006AB000600CF05010007000408012O00CF050100129D000600014O004E000700083O00129D00090069012O00129D000A006A012O000663000900AB0501000A000408012O00AB050100129D000900013O0006AB000600AB05010009000408012O00AB050100129D000700014O004E000800083O00129D000600023O00129D000900023O0006AB000600A105010009000408012O00A1050100129D000900013O0006AB000700AE05010009000408012O00AE050100129D000800013O00129D000900013O0006AB000800B205010009000408012O00B205012O002A01095O00200D0009000900DF4O000B00043O00122O000C006B015O000B000B000C4O0009000B00024O000900296O000900293O00062O000900C705013O000408012O00C705012O002A01095O0020DD0009000900C24O000B00043O00122O000C006B015O000B000B000C4O0009000B000200062O000900C805010001000408012O00C8050100129D000900014O00730009002A3O000408012O00CF0501000408012O00B20501000408012O00CF0501000408012O00AE0501000408012O00CF0501000408012O00A1050100129D000500023O00129D000600023O00061B010500D705010006000408012O00D7050100129D0006006C012O00129D0007006D012O0006AB0006008605010007000408012O0086050100129D000400133O000408012O00540501000408012O00860501000408012O00540501000408012O00DD0501000408012O0050050100129D000300023O0006AB0002002O08010003000408012O002O080100129D000300013O00129D0004006E012O00129D0005006F012O000663000400DE07010005000408012O00DE070100129D000400023O0006AB000300DE07010004000408012O00DE07012O002A01045O00129D00060070013O004D0004000400062O00E00004000200020006AD000400F205010001000408012O00F2050100129D00040071012O00129D00050072012O000663000500F305010004000408012O00F305012O009E3O00013O00129D00040073012O00129D00050074012O0006630005002606010004000408012O002606012O002A0104000D3O0006C30004002606013O000408012O002606012O002A010400044O0034000500083O00122O00060075012O00122O00070076015O0005000700024O00040004000500202O0004000400444O00040002000200062O0004002606013O000408012O002606012O002A010400033O00129D00050077013O00280104000400052O000E0004000100020006C30004002606013O000408012O0026060100129D000400014O004E000500063O00129D000700013O0006AB0004001906010007000408012O001906012O002A0105000D4O00DC000700033O00122O00080078015O0007000700084O000800056O000900053O00122O000A00956O0007000A00024O000600073O00122O000400023O00129D000700023O0006AB0004000C06010007000408012O000C06010006AD0006002206010001000408012O0022060100129D00070079012O00129D0008007A012O000663000700DD07010008000408012O00DD07012O000F000600023O000408012O00DD0701000408012O000C0601000408012O00DD07012O002A0104002B4O000E0004000100020006C30004003206013O000408012O003206012O002A0104001B3O0020B40004000400C24O000600043O00202O0006000600C34O00040006000200122O000500C43O00062O0004003606010005000408012O0036060100129D0004007B012O00129D0005007C012O00063E010400AC06010005000408012O00AC060100129D000400014O004E000500063O00129D0007007D012O00129D0008007D012O0006AB0007004206010008000408012O0042060100129D000700013O0006AB0004004206010007000408012O0042060100129D000500014O004E000600063O00129D000400023O00129D0007007E012O00129D0008007F012O00063E0108003806010007000408012O0038060100129D000700023O0006AB0004003806010007000408012O0038060100129D00070080012O00129D00080081012O0006630007004906010008000408012O0049060100129D000700013O0006AB0005004906010007000408012O0049060100129D000600013O00129D00070082012O00129D00080083012O00063E0108005106010007000408012O0051060100129D000700013O00061B0106005C06010007000408012O005C060100129D00070084012O00129D00080085012O0006630007005106010008000408012O005106012O002A0107002B4O001101070001000200202O0007000700C14O0007000200024O0007001C3O00122O00070086012O00122O00080087012O00062O0007007F06010008000408012O007F06012O002A0107001A4O0005010800083O00122O00090088012O00122O000A0089015O0008000A000200062O0007007F06010008000408012O007F06012O002A0107002B4O001901070001000200202O0007000700C24O000900043O00202O0009000900C34O00070009000200122O000800C43O00062O0007007F06010008000408012O007F06012O002A010700044O00D2000800083O00122O0009008A012O00122O000A008B015O0008000A00024O00070007000800202O0007000700BE4O00070002000200062O0007008306010001000408012O0083060100129D000700FC3O00129D0008008C012O00063E010800DD07010007000408012O00DD070100129D000700014O004E000800083O00129D0009008D012O00129D000A008D012O0006AB000900850601000A000408012O0085060100129D000900013O0006AB0007008506010009000408012O0085060100129D000800013O00129D0009008E012O00129D000A008F012O000663000A008D06010009000408012O008D060100129D000900013O0006AB0008008D06010009000408012O008D06012O002A010900033O0012A3000A0091015O00090009000A4O000A002B6O000A0001000200122O000B00C06O0009000B000200122O00090090012O00122O00090090012O00062O000900DD07013O000408012O00DD07010012FB00090090013O000F000900023O000408012O00DD0701000408012O008D0601000408012O00DD0701000408012O00850601000408012O00DD0701000408012O00510601000408012O00DD0701000408012O00490601000408012O00DD0701000408012O00380601000408012O00DD07012O002A010400163O0006AD000400B306010001000408012O00B3060100129D000400B63O00129D00050092012O000663000400DD07010005000408012O00DD07012O002A0104002C4O0005010500083O00122O00060093012O00122O00070094015O00050007000200062O000400C406010005000408012O00C406012O002A010400044O00D2000500083O00122O00060095012O00122O00070096015O0005000700024O00040004000500202O0004000400444O00040002000200062O000400D506010001000408012O00D506012O002A0104002D4O0005010500083O00122O00060097012O00122O00070098015O00050007000200062O000400FB06010005000408012O00FB06012O002A010400044O0034000500083O00122O00060099012O00122O0007009A015O0005000700024O00040004000500202O0004000400444O00040002000200062O000400FB06013O000408012O00FB060100129D000400014O004E000500053O00129D0006009B012O00129D0007009C012O00063E010600D706010007000408012O00D7060100129D000600013O0006AB000400D706010006000408012O00D7060100129D000500013O00129D0006009D012O00129D0007009E012O00063E010700DF06010006000408012O00DF060100129D000600013O00061B010500EA06010006000408012O00EA060100129D0006009F012O00129D000700A0012O000663000600DF06010007000408012O00DF06012O002A010600033O00126000070078015O0006000600074O00078O0008000A6O0006000A000200122O00060090012O00122O00060090012O00062O000600DD07013O000408012O00DD07010012FB00060090013O000F000600023O000408012O00DD0701000408012O00DF0601000408012O00DD0701000408012O00D70601000408012O00DD070100129D000400A1012O00129D000500A1012O0006AB000400DD07010005000408012O00DD07012O002A0104002C4O0005010500083O00122O000600A2012O00122O000700A3015O00050007000200062O000400DD07010005000408012O00DD07012O002A010400044O0034000500083O00122O000600A4012O00122O000700A5015O0005000700024O00040004000500202O0004000400444O00040002000200062O000400DD07013O000408012O00DD070100129D000400014O004E000500073O00129D000800013O0006AB0004001807010008000408012O0018070100129D000500014O004E000600063O00129D000400023O00129D000800023O0006AB0008001207010004000408012O001207012O004E000700073O00129D000800013O0006AB0008005F07010005000408012O005F070100129D000800014O004E000900093O00129D000A00A6012O00129D000B00A7012O00063E010A00210701000B000408012O0021070100129D000A00013O0006AB000800210701000A000408012O0021070100129D000900013O00129D000A00FC3O00129D000B00A8012O00063E010B004F0701000A000408012O004F070100129D000A00013O00061B010A003407010009000408012O0034070100129D000A00A9012O00129D000B00AA012O0006AB000A004F0701000B000408012O004F07012O002A010A00033O001269000B00AB015O000A000A000B4O000B8O000C000C6O000D00083O00122O000E00AC012O00122O000F00AD015O000D000F6O000A3O000200062O000600410701000A000408012O004107012O002A01066O002A010A00033O001269000B00AB015O000A000A000B4O000B8O000C000C6O000D00083O00122O000E00AE012O00122O000F00AF015O000D000F6O000A3O000200062O0007004E0701000A000408012O004E07012O002A01075O00129D000900023O00129D000A008F012O00129D000B00B0012O00063E010B00290701000A000408012O0029070100129D000A00B1012O00129D000B00B2012O000663000A00290701000B000408012O0029070100129D000A00023O0006AB000900290701000A000408012O0029070100129D000500023O000408012O005F0701000408012O00290701000408012O005F0701000408012O0021070100129D000800B3012O00129D000900B4012O0006630008001C07010009000408012O001C070100129D000800023O0006AB0005001C07010008000408012O001C070100129D000A00B5013O008900080006000A4O00080002000200122O000B00B5015O00090007000B4O00090002000200062O0008007207010009000408012O0072070100129D000800B6012O00129D000900B7012O00063E010800AE07010009000408012O00AE070100129D000800014O004E0009000A3O00129D000B00023O0006AB000800A30701000B000408012O00A3070100129D000B00013O00061B0109007E0701000B000408012O007E070100129D000B00B8012O00129D000C00B9012O00063E010C00770701000B000408012O0077070100129D000A00013O00129D000B00BA012O00129D000C00BB012O000663000B007F0701000C000408012O007F070100129D000B00013O00061B010B008A0701000A000408012O008A070100129D000B004C012O00129D000C00BC012O0006AB000B007F0701000C000408012O007F07012O002A010B00033O00123F000C0078015O000B000B000C4O000C8O000D000E6O000F00083O00122O001000BD012O00122O001100BE015O000F00116O000B3O000200122O000B0090012O00122O000B00BF012O00122O000C00C0012O00062O000C00AE0701000B000408012O00AE07010012FB000B0090012O0006C3000B00AE07013O000408012O00AE07010012FB000B0090013O000F000B00023O000408012O00AE0701000408012O007F0701000408012O00AE0701000408012O00770701000408012O00AE070100129D000B00013O00061B010800AA0701000B000408012O00AA070100129D000B00C1012O00129D000C00C2012O000663000B00740701000C000408012O0074070100129D000900014O004E000A000A3O00129D000800023O000408012O0074070100129D000A00B5013O00CA00080007000A4O00080002000200122O000B00B5015O00090006000B4O00090002000200062O000900B707010008000408012O00B70701000408012O00DD070100129D000800013O00129D000900013O00061B010800C307010009000408012O00C3070100129D000900C3012O00129D000A00D53O000624010A000500010009000408012O00C3070100129D000900C4012O00129D000A00C5012O00063E010A00B807010009000408012O00B807012O002A010900033O00123F000A0078015O00090009000A4O000A8O000B000C6O000D00083O00122O000E00C6012O00122O000F00C7015O000D000F6O00093O000200122O00090090012O00122O000900C8012O00122O000A00C9012O00062O000900DD0701000A000408012O00DD07010012FB00090090012O0006C3000900DD07013O000408012O00DD07010012FB00090090013O000F000900023O000408012O00DD0701000408012O00B80701000408012O00DD0701000408012O001C0701000408012O00DD0701000408012O0012070100129D000300133O00129D000400CA012O00129D000500CA012O0006AB000400E707010005000408012O00E7070100129D000400133O0006AB000300E707010004000408012O00E7070100129D000200133O000408012O002O080100129D000400CB012O00129D000500CC012O000663000500E105010004000408012O00E1050100129D000400013O0006AB000300E105010004000408012O00E105010012FB000400CD013O00EF000500083O00122O000600CE012O00122O000700CF015O0005000700024O0004000400054O000500083O00122O000600D0012O00122O000700D1015O0005000700024O0004000400054O000400163O00122O000400CD015O000500083O00122O000600D2012O00122O000700D3015O0005000700024O0004000400054O000500083O00122O000600D4012O00122O000700D5015O0005000700024O0004000400054O0004002E3O00122O000300023O000408012O00E1050100129D0003005E3O00061B0102000F08010003000408012O000F080100129D000300D6012O00129D000400D7012O000663000400BF08010003000408012O00BF080100129D000300013O00129D000400D8012O00129D000500D9012O00063E0104001708010005000408012O0017080100129D000400133O00061B0103001B08010004000408012O001B080100129D000400DA012O00129D000500DB012O00063E0104001D08010005000408012O001D080100129D0002005A012O000408012O00BF080100129D000400DC012O00129D000500DD012O00063E0105003508010004000408012O0035080100129D000400013O00061B0103002808010004000408012O0028080100129D000400DE012O00129D0005004E3O00063E0105003508010004000408012O003508012O002A01045O001245010600DF015O00040004000600122O000600C06O0004000600024O0004002F6O0004000A3O00122O000600E0015O00040004000600122O000600236O0004000600024O000400303O00122O000300023O00129D000400023O0006AB0003001008010004000408012O0010080100129D000400E1012O00129D000500E2012O00063E0105004608010004000408012O004608012O002A010400313O0006C30004004608013O000408012O004608012O002A0104000A3O001228000600E3015O00040004000600122O000600236O0004000600024O000400113O00044O0048080100129D000400024O0073000400113O00129D000400E4012O00129D000500E5012O0006630005005708010004000408012O005708012O002A010400033O00129D00050066013O00280104000400052O000E0004000100020006AD0004005B08010001000408012O005B08012O002A01045O00200D0104000400062O00E00004000200020006AD0004005B08010001000408012O005B080100129D000400E6012O00129D000500E7012O00063E010500BD08010004000408012O00BD080100129D000400014O004E000500053O00129D000600E8012O00129D0007005F012O0006630006005D08010007000408012O005D080100129D000600013O00061B0104006808010006000408012O0068080100129D000600E9012O00129D000700EA012O0006AB0006005D08010007000408012O005D080100129D000500013O00129D000600EB012O00129D000700EC012O000663000600A208010007000408012O00A2080100129D000600013O0006AB000500A208010006000408012O00A2080100129D000600013O00129D000700013O00061B0106007808010007000408012O0078080100129D000700ED012O00129D000800EE012O0006630008009C08010007000408012O009C080100129D000700013O00129D000800EF012O00129D000900F0012O0006630008008E08010009000408012O008E080100129D000800013O00061B0107008408010008000408012O0084080100129D000800F1012O00129D000900F2012O00063E0109008E08010008000408012O008E08012O002A010800203O00127D000900F3015O0008000800094O000900096O000A00016O0008000A00024O000800326O000800326O000800333O00122O000700023O00129D000800F4012O00129D000900F5012O0006630008007908010009000408012O0079080100129D000800F6012O00129D000900F7012O0006630008007908010009000408012O0079080100129D000800023O0006AB0007007908010008000408012O0079080100129D000600023O000408012O009C0801000408012O0079080100129D000700023O0006AB0006007108010007000408012O0071080100129D000500023O000408012O00A20801000408012O0071080100129D000600F8012O00129D000700F8012O0006AB0006006908010007000408012O0069080100129D000600023O0006AB0005006908010006000408012O006908012O002A010600333O00129D000700F9012O0006AB000600BD08010007000408012O00BD080100129D000600FA012O00129D000700FB012O00063E010700B208010006000408012O00B20801000408012O00BD08012O002A010600203O00122O000700FC015O0006000600074O0007002F6O00088O0006000800024O000600333O00044O00BD0801000408012O00690801000408012O00BD0801000408012O005D080100129D000300133O000408012O0010080100129D000300FD012O00129D000400FE012O00063E0104000900010003000408012O0009000100129D000300013O0006AB0002000900010003000408012O0009000100129D000300013O00129D000400013O00061B010400CE08010003000408012O00CE080100129D000400FF012O00129D00052O00022O00063E010500F308010004000408012O00F3080100129D000400013O00129D000500013O00061B010500D608010004000408012O00D6080100129D00050001022O00129D000600DC012O00063E010600E508010005000408012O00E508012O002A010500344O00B600050001000100122O000500CD015O000600083O00122O0007002O022O00122O00080003025O0006000800024O0005000500064O000600083O00122O00070004022O00122O00080005025O0006000800024O0005000500064O000500023O00122O000400023O00129D00050006022O00129D00060007022O000663000600EC08010005000408012O00EC080100129D000500023O00061B010400F008010005000408012O00F0080100129D00050008022O00129D00060009022O000663000500CF08010006000408012O00CF080100129D000300023O000408012O00F30801000408012O00CF080100129D000400133O00061B010300FA08010004000408012O00FA080100129D0004000A022O00129D0005000B022O000663000400FC08010005000408012O00FC080100129D000200023O000408012O0009000100129D000400023O00061B0103000309010004000408012O0003090100129D0004000C022O00129D0005000D022O00063E010400C708010005000408012O00C708010012FB000400CD013O00EF000500083O00122O0006000E022O00122O0007000F025O0005000700024O0004000400054O000500083O00122O00060010022O00122O00070011025O0005000700024O0004000400054O000400313O00122O000400CD015O000500083O00122O00060012022O00122O00070013025O0005000700024O0004000400054O000500083O00122O00060014022O00122O00070015025O0005000700024O0004000400054O0004000F3O00122O000300133O000408012O00C70801000408012O00090001000408012O00280901000408012O00060001000408012O0028090100129D000300013O0006AB3O000200010003000408012O0002000100129D000100014O004E000200023O00129D3O00023O000408012O000200012O009E3O00017O001D3O00028O00025O00049A40025O0060AF40026O00F03F025O0080AD40025O00DCA940025O00089140025O0044A940025O00B4A040025O002EAF40030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03273O00F1CEE0AEB0E27DABDCC4F8EF86E073B4D0D9B697E3E03CEE2O85A4E1F3A63C9DCC8BD4A0ACFB5703083O00DFB5AB96CFC3961C025O0026A140025O00A2A340025O00A6A740025O00BAB040025O00A4AB40025O00D2A940025O00349240025O000C914003123O001C3B00933D3E1F823A3E16A73D3006853E2103043O00E358527303183O006716A9B7077F4F1EB8AB07434C16A9A80C57461DAFA1046003063O0013237FDAC76203053O005072696E7403213O0038FE1CE30FEF0BF615F404A239ED05E919E94AE005BB2FF215F84AC013F407C95203043O00827C9B6A004C3O00129D3O00014O004E000100023O002EA80002000900010003000408012O000900010026143O000900010001000408012O0009000100129D000100014O004E000200023O00129D3O00043O0026A63O000F00010004000408012O000F0001002E050005000F00010006000408012O000F0001002E2A0008000200010007000408012O000200010026140001000F00010001000408012O000F000100129D000200013O002E330009000E00010009000408012O00200001002E33000A000C0001000A000408012O002000010026140002002000010004000408012O002000010012FB0003000B3O00209700030003000C4O00045O00122O0005000D3O00122O0006000E6O000400066O00033O000100044O004B00010026A60002002400010001000408012O00240001002E2A001000120001000F000408012O0012000100129D000300013O002E2A0011002D00010012000408012O002D0001002EA80014002D00010013000408012O002D0001000E140104002D00010003000408012O002D000100129D000200043O000408012O00120001000EFC0001003100010003000408012O00310001002E2A0015002500010016000408012O002500012O002A010400014O00E600055O00122O000600173O00122O000700186O0005000700024O000600016O00075O00122O000800193O00122O0009001A6O0007000900024O0006000600074O0004000500064O000400023O00202O00040004001B4O00055O00122O0006001C3O00122O0007001D6O000500076O00043O000100122O000300043O00044O00250001000408012O00120001000408012O004B0001000408012O000F0001000408012O004B0001000408012O000200012O009E3O00017O00", GetFEnv(), ...);

