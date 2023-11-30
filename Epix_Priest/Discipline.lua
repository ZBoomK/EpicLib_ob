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
				if (Enum <= 170) then
					if (Enum <= 84) then
						if (Enum <= 41) then
							if (Enum <= 20) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
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
												A = Inst[2];
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
												VIP = Inst[3];
											end
										elseif (Enum <= 2) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 3) then
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
											Stk[Inst[2]] = not Stk[Inst[3]];
										end
									elseif (Enum <= 6) then
										if (Enum > 5) then
											local Edx;
											local Results, Limit;
											local A;
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
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
										end
									elseif (Enum <= 7) then
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
											if (Mvm[1] == 317) then
												Indexes[Idx - 1] = {Stk,Mvm[3]};
											else
												Indexes[Idx - 1] = {Upvalues,Mvm[3]};
											end
											Lupvals[#Lupvals + 1] = Indexes;
										end
										Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
									elseif (Enum > 8) then
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									end
								elseif (Enum <= 14) then
									if (Enum <= 11) then
										if (Enum == 10) then
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
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 12) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 13) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										A = Inst[2];
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
								elseif (Enum <= 17) then
									if (Enum <= 15) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									elseif (Enum > 16) then
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 18) then
									local A = Inst[2];
									do
										return Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum == 19) then
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
									Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
								end
							elseif (Enum <= 30) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum > 21) then
											local A;
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Inst[2] <= Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 23) then
										if (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 24) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 27) then
									if (Enum > 26) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										Env[Inst[3]] = Stk[Inst[2]];
									end
								elseif (Enum <= 28) then
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
								elseif (Enum > 29) then
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
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum <= 35) then
								if (Enum <= 32) then
									if (Enum > 31) then
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 33) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Enum > 34) then
									local A = Inst[2];
									local T = Stk[A];
									local B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
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
							elseif (Enum <= 38) then
								if (Enum <= 36) then
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
								elseif (Enum > 37) then
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
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
							elseif (Enum <= 39) then
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
							elseif (Enum == 40) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 62) then
							if (Enum <= 51) then
								if (Enum <= 46) then
									if (Enum <= 43) then
										if (Enum > 42) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 44) then
										if (Stk[Inst[2]] < Inst[4]) then
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
								elseif (Enum <= 48) then
									if (Enum == 47) then
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
										Stk[Inst[2]] = not Stk[Inst[3]];
									end
								elseif (Enum <= 49) then
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
								elseif (Enum > 50) then
									Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
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
							elseif (Enum <= 56) then
								if (Enum <= 53) then
									if (Enum > 52) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 54) then
									Stk[Inst[2]]();
								elseif (Enum > 55) then
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
								if (Enum <= 57) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
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
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 60) then
								local Edx;
								local Results, Limit;
								local A;
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
							elseif (Enum == 61) then
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
								if not Stk[Inst[2]] then
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
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							end
						elseif (Enum <= 73) then
							if (Enum <= 67) then
								if (Enum <= 64) then
									if (Enum == 63) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 65) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum == 66) then
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
							elseif (Enum <= 70) then
								if (Enum <= 68) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 69) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 71) then
								VIP = Inst[3];
							elseif (Enum == 72) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 78) then
							if (Enum <= 75) then
								if (Enum > 74) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
							elseif (Enum <= 76) then
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
							elseif (Enum > 77) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 81) then
							if (Enum <= 79) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A]());
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							elseif (Enum > 80) then
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
								if (Inst[2] < Inst[4]) then
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 83) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
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
							if (Inst[2] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 127) then
						if (Enum <= 105) then
							if (Enum <= 94) then
								if (Enum <= 89) then
									if (Enum <= 86) then
										if (Enum > 85) then
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
									elseif (Enum <= 87) then
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
									elseif (Enum > 88) then
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
								elseif (Enum <= 91) then
									if (Enum == 90) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum <= 92) then
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
								elseif (Enum == 93) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 99) then
								if (Enum <= 96) then
									if (Enum == 95) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 98) then
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
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 102) then
								if (Enum <= 100) then
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
								elseif (Enum > 101) then
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
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
							elseif (Enum <= 103) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 104) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
						elseif (Enum <= 116) then
							if (Enum <= 110) then
								if (Enum <= 107) then
									if (Enum == 106) then
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
								elseif (Enum <= 108) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 109) then
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
									Stk[Inst[2]] = not Stk[Inst[3]];
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
								end
							elseif (Enum <= 113) then
								if (Enum <= 111) then
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
								elseif (Enum == 112) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
								else
									local A = Inst[2];
									do
										return Unpack(Stk, A, Top);
									end
								end
							elseif (Enum <= 114) then
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
							elseif (Enum == 115) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 121) then
							if (Enum <= 118) then
								if (Enum > 117) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum <= 119) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 120) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 124) then
							if (Enum <= 122) then
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
							elseif (Enum > 123) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 125) then
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
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 126) then
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
						end
					elseif (Enum <= 148) then
						if (Enum <= 137) then
							if (Enum <= 132) then
								if (Enum <= 129) then
									if (Enum == 128) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 131) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 134) then
								if (Enum > 133) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 135) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum > 136) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 142) then
							if (Enum <= 139) then
								if (Enum > 138) then
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
								A = Inst[2];
								Stk[A] = Stk[A]();
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
						elseif (Enum <= 145) then
							if (Enum <= 143) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 144) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 146) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 147) then
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
					elseif (Enum <= 159) then
						if (Enum <= 153) then
							if (Enum <= 150) then
								if (Enum == 149) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 151) then
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
							elseif (Enum == 152) then
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
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 156) then
							if (Enum <= 154) then
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
								Stk[Inst[2]] = Inst[3];
							elseif (Enum > 155) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 157) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
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
						elseif (Enum > 158) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							VIP = Inst[3];
						end
					elseif (Enum <= 164) then
						if (Enum <= 161) then
							if (Enum == 160) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 162) then
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
						elseif (Enum == 163) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 167) then
						if (Enum <= 165) then
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
						elseif (Enum == 166) then
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
					elseif (Enum <= 168) then
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
					elseif (Enum > 169) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
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
				elseif (Enum <= 255) then
					if (Enum <= 212) then
						if (Enum <= 191) then
							if (Enum <= 180) then
								if (Enum <= 175) then
									if (Enum <= 172) then
										if (Enum == 171) then
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
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										end
									elseif (Enum <= 173) then
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 174) then
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									elseif (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 177) then
									if (Enum > 176) then
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
								elseif (Enum <= 178) then
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 179) then
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
							elseif (Enum <= 185) then
								if (Enum <= 182) then
									if (Enum == 181) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 188) then
								if (Enum <= 186) then
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
								elseif (Enum > 187) then
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
							elseif (Enum <= 189) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							elseif (Enum > 190) then
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
								Stk[Inst[2]] = not Stk[Inst[3]];
							end
						elseif (Enum <= 201) then
							if (Enum <= 196) then
								if (Enum <= 193) then
									if (Enum > 192) then
										if (Stk[Inst[2]] < Inst[4]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									end
								elseif (Enum <= 194) then
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								elseif (Enum > 195) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 198) then
								if (Enum > 197) then
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
							elseif (Enum <= 199) then
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
							elseif (Enum == 200) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 206) then
							if (Enum <= 203) then
								if (Enum > 202) then
									local A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
							elseif (Enum <= 204) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 205) then
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
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 209) then
							if (Enum <= 207) then
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
							elseif (Enum == 208) then
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
						elseif (Enum <= 210) then
							do
								return;
							end
						elseif (Enum > 211) then
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
					elseif (Enum <= 233) then
						if (Enum <= 222) then
							if (Enum <= 217) then
								if (Enum <= 214) then
									if (Enum > 213) then
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 216) then
									Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
								else
									do
										return Stk[Inst[2]]();
									end
								end
							elseif (Enum <= 219) then
								if (Enum == 218) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
								end
							elseif (Enum <= 220) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 221) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 227) then
							if (Enum <= 224) then
								if (Enum == 223) then
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								end
							elseif (Enum <= 225) then
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
							elseif (Enum == 226) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 230) then
							if (Enum <= 228) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 231) then
							local A;
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
							Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 232) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
					elseif (Enum <= 244) then
						if (Enum <= 238) then
							if (Enum <= 235) then
								if (Enum == 234) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 236) then
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
							elseif (Enum > 237) then
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
								local B;
								local A;
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 241) then
							if (Enum <= 239) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 242) then
							if (Inst[2] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 243) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 249) then
						if (Enum <= 246) then
							if (Enum > 245) then
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
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum <= 247) then
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
						elseif (Enum > 248) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 252) then
						if (Enum <= 250) then
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
						elseif (Enum == 251) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Top));
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
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
				elseif (Enum <= 298) then
					if (Enum <= 276) then
						if (Enum <= 265) then
							if (Enum <= 260) then
								if (Enum <= 257) then
									if (Enum > 256) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = Inst[3];
										else
											VIP = VIP + 1;
										end
									end
								elseif (Enum <= 258) then
									local A = Inst[2];
									do
										return Unpack(Stk, A, A + Inst[3]);
									end
								elseif (Enum > 259) then
									Upvalues[Inst[3]] = Stk[Inst[2]];
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
							elseif (Enum <= 262) then
								if (Enum == 261) then
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
							elseif (Enum <= 263) then
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
						elseif (Enum <= 270) then
							if (Enum <= 267) then
								if (Enum > 266) then
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
							elseif (Enum <= 268) then
								if (Inst[2] == Inst[4]) then
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
							end
						elseif (Enum <= 273) then
							if (Enum <= 271) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 272) then
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 274) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum > 275) then
							local A = Inst[2];
							local B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Stk[Inst[4]]];
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
					elseif (Enum <= 287) then
						if (Enum <= 281) then
							if (Enum <= 278) then
								if (Enum > 277) then
									if (Stk[Inst[2]] <= Inst[4]) then
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
							elseif (Enum <= 279) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
							end
						elseif (Enum <= 284) then
							if (Enum <= 282) then
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum > 283) then
								local A = Inst[2];
								Stk[A] = Stk[A]();
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum <= 285) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
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
							A = Inst[2];
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
					elseif (Enum <= 292) then
						if (Enum <= 289) then
							if (Enum > 288) then
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
							elseif (Stk[Inst[2]] <= Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 290) then
							if (Stk[Inst[2]] < Stk[Inst[4]]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum > 291) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 295) then
						if (Enum <= 293) then
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
						elseif (Enum == 294) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 296) then
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
					elseif (Enum > 297) then
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
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Stk[A + 1]));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					end
				elseif (Enum <= 319) then
					if (Enum <= 308) then
						if (Enum <= 303) then
							if (Enum <= 300) then
								if (Enum == 299) then
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
									if (Stk[Inst[2]] > Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = VIP + Inst[3];
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
							elseif (Enum <= 301) then
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
							elseif (Enum == 302) then
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
								Upvalues[Inst[3]] = Stk[Inst[2]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
							end
						elseif (Enum <= 305) then
							if (Enum == 304) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 306) then
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
						elseif (Enum > 307) then
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
					elseif (Enum <= 313) then
						if (Enum <= 310) then
							if (Enum == 309) then
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 311) then
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
						elseif (Enum == 312) then
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
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 316) then
						if (Enum <= 314) then
							if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
								Stk[Inst[2]] = Env;
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum == 315) then
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
					elseif (Enum <= 317) then
						Stk[Inst[2]] = Stk[Inst[3]];
					elseif (Enum == 318) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					else
						local A = Inst[2];
						do
							return Stk[A](Unpack(Stk, A + 1, Top));
						end
					end
				elseif (Enum <= 330) then
					if (Enum <= 324) then
						if (Enum <= 321) then
							if (Enum > 320) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 322) then
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						elseif (Enum > 323) then
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
					elseif (Enum <= 327) then
						if (Enum <= 325) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 326) then
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
					elseif (Enum <= 328) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
						if (Inst[2] <= Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 329) then
						Stk[Inst[2]] = #Stk[Inst[3]];
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
				elseif (Enum <= 335) then
					if (Enum <= 332) then
						if (Enum > 331) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 333) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
					elseif (Enum > 334) then
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
				elseif (Enum <= 338) then
					if (Enum <= 336) then
						Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
					elseif (Enum == 337) then
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
				elseif (Enum <= 339) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 340) then
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
					Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031A3O00F4D3D23DD98BD517D4D0CF1AC2B2D41DD8D3D72CE8BE8912C4C203083O007EB1A3BB4586DBA7031A3O000C6EC8FBCA9A92207BD2F7CA8E893A7DC8F3F9A38E2C30CDF6F403073O00E0491EA18395CA002E3O00122C012O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004473O000A000100123A010300063O00204B00040003000700123A010500083O00204B00050005000900123A010600083O00204B00060006000A00060700073O000100062O003D012O00064O003D017O003D012O00044O003D012O00014O003D012O00024O003D012O00053O00204B00080003000B00204B00090003000C2O0010010A5O00123A010B000D3O000607000C0001000100022O003D012O000A4O003D012O000B4O003D010D00073O00121F000E000E3O00121F000F000F4O00DF000D000F0002000607000E0002000100032O003D012O00074O003D012O00094O003D012O00084O0056000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00A300025O00122O000300016O00045O00122O000500013O00042O0003002100012O007600076O00FE000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00022O0076000C00034O005B000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00104O00B4000C6O00DB000A3O0002002033000A000A00022O00290109000A4O00FB00073O00010004220003000500012O0076000300054O003D010400024O0012000300044O007100036O00D23O00017O000A3O00028O00026O00F03F025O00F89F40025O002AA540025O0026A140025O0084B340025O00108D40025O00508940025O00BAB240025O0014A54001343O00121F000200014O00AA000300043O0026BB0002002D000100020004473O002D000100121F000500013O0026AB00050009000100010004473O00090001002EC800040005000100030004473O000500010026AB0003000D000100020004473O000D0001002EC800060011000100050004473O001100012O003D010600044O006600076O003F01066O007100065O0026BB00030004000100010004473O0004000100121F000600013O0026AB00060018000100010004473O00180001002E1500070022000100080004473O002200012O007600076O00AE000400073O0006B200040021000100010004473O002100012O0076000700014O003D01086O006600096O003F01076O007100075O00121F000600023O0026AB00060026000100020004473O00260001002EC8000900140001000A0004473O0014000100121F000300023O0004473O000400010004473O001400010004473O000400010004473O000500010004473O000400010004473O00330001000E1700010002000100020004473O0002000100121F000300014O00AA000400043O00121F000200023O0004473O000200012O00D23O00017O006D3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C503053O0060D235E95303083O009826BD569C20188503093O00D158B255F978B143EE03043O00269C37C72O033O0098786803083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O007C5609295A03043O004529226003043O009FC2C41E03063O004BDCA3B76A6203043O0020B3853303053O00B962DAEB5703053O00FB2E22F5CD03063O00CAAB5C4786BE03053O0004C02F9A2603043O00E849A14C03073O0098D64F5011B5CA03053O007EDBB9223D03083O0029D85B606778FDE203083O00876CAE3E121E17932O033O00B8FC2703083O00A7D6894AAB78CE5303073O00A8FF3F50F7A99803063O00C7EB90523D9803083O002200BC391E19B72E03043O004B6776D903043O00C55B7F1803063O007EA7341074D903063O00737472696E6703063O00CE21328DB50D03073O009CA84E40E0D479028O0003103O0052616D705261707475726554696D6573025O00F6A440025O00805140025O00406540025O00E0704003133O0052616D704576616E67656C69736D54696D6573025O00E06040025O00206C40025O00D07840030D3O0052616D70426F746854696D6573025O00F0A440026O002E40025O00206240025O00406F40025O00F4A440026O005E40025O00606840025O00D07140025O00F8A440025O00206740025O00E07540025O00FEA440026O001440025O00C05C40025O00A06940025O00707240026O00A540025O00804640025O00806140025O00C06C40025O0002A540025O00405A40025O00107340025O000AA540025O00405F40025O00A06E40025O00FAA440025O00805340025O00E06540025O00D07040025O0060764003063O0037FCACCB14FA03043O00AE678EC5030A3O0072214C3B2C4EF45F265A03073O009836483F58453E03063O00E4D6E759C7D003043O003CB4A48E030A3O007C57162A2EFD1E51500003073O0072383E6549478D03063O0088FBD2C1ABFD03043O00A4D889BB030A3O00F6EF22B1AFEE07DBE83403073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703103O005265676973746572466F724576656E7403243O0004A78B6532AD2E2009A5866936B7222000A7966D28A12B3111AD90623BAB39310BA39A6803083O007045E4DF2C64E87103063O0053657441504C026O0070400089023O006E000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00128B000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00128B0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00128B000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B4O000C5O00128B000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00121F000F00163O00121F001000174O00DF000E001000022O00AE000E0004000E00123A010F00044O008700105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00112O008700125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00132O008700145O00122O001500203O00122O001600216O0014001600024O0014000F00144O00155O00122O001600223O00122O001700236O0015001700024O0014001400152O008700155O00122O001600243O00122O001700256O0015001700024O0014001400154O00155O00122O001600263O00122O001700276O0015001700024O0015000F00152O008700165O00122O001700283O00122O001800296O0016001800024O0015001500164O00165O00122O0017002A3O00122O0018002B6O0016001800024O00150015001600123A0116002C4O00DC00175O00122O0018002D3O00122O0019002E6O0017001900024O0016001600172O00AA001700534O00FC00546O00FC00556O00FC00566O00FC00576O00FC00585O00121F0059002F3O00121F005A002F4O00FC005B6O0010015C5O00121A005C00303O001234015C00306O005D00033O00122O005E00323O00122O005F00333O00122O006000346O005D000300010010F5005C0031005D2O0010015C5O00121A005C00353O001234015C00356O005D00033O00122O005E00363O00122O005F00373O00122O006000386O005D000300010010F5005C0031005D2O0010015C5O00121A005C00393O001234015C00396O005D00033O00122O005E003B3O00122O005F003C3O00122O0060003D6O005D000300010010F5005C003A005D001227015C00396O005D00043O00122O005E003B3O00122O005F003F3O00122O006000403O00122O006100416O005D000400010010F5005C003E005D001234015C00396O005D00033O00122O005E003B3O00122O005F00433O00122O006000446O005D000300010010F5005C0042005D001227015C00396O005D00043O00122O005E00463O00122O005F00473O00122O006000483O00122O006100496O005D000400010010F5005C0045005D001234015C00396O005D00033O00122O005E004B3O00122O005F004C3O00122O0060004D6O005D000300010010F5005C004A005D001234015C00396O005D00033O00122O005E004F3O00122O005F00483O00122O006000506O005D000300010010F5005C004E005D001227015C00396O005D00043O00122O005E003B3O00122O005F00523O00122O006000433O00122O006100536O005D000400010010F5005C0051005D001227015C00396O005D00043O00122O005E00553O00122O005F00563O00122O006000573O00122O006100586O005D000400010010F5005C0054005D2O0088005C5O00122O005D00593O00122O005E005A6O005C005E00024O005C000C005C4O005D5O00122O005E005B3O00122O005F005C6O005D005F00024O005C005C005D4O005D5O00122O005E005D3O00122O005F005E6O005D005F00024O005D000D005D4O005E5O00122O005F005F3O00122O006000606O005E006000024O005D005D005E4O005E5O00122O005F00613O00122O006000626O005E006000024O005E0013005E4O005F5O00122O006000633O00122O006100646O005F006100024O005E005E005F4O005F8O006000726O00735O00122O007400653O00122O007500666O0073007500024O0073000F00734O00745O00122O007500673O00122O007600686O0074007600024O00730073007400060700743O000100042O003D012O005C4O00768O003D012O00734O003D012O000E3O00205300750004006900060700770001000100012O003D012O00744O003201785O00122O0079006A3O00122O007A006B6O0078007A6O00753O000100060700750002000100012O003D012O005C3O00060700760003000100032O003D012O005C4O00768O003D012O00073O00060700770004000100062O003D012O005C4O00768O003D012O00564O003D012O00734O003D012O00124O003D012O005E3O000607007800050001000F2O003D012O005C4O00768O003D012O00284O003D012O00074O003D012O00294O003D012O00124O003D012O00264O003D012O00274O003D012O005D4O003D012O002A4O003D012O002B4O003D012O005E4O003D012O00184O003D012O001A4O003D012O00193O00060700790006000100032O003D012O00734O003D012O005F4O003D012O00553O000607007A0007000100092O003D012O00594O003D012O001E4O003D012O005C4O00768O003D012O001D4O003D012O00074O003D012O00124O003D012O005E4O003D012O001C3O000607007B00080001000C2O003D012O00704O003D012O00094O003D012O00374O003D012O00074O003D012O005C4O003D012O00124O003D012O005E4O00768O003D012O00734O003D012O00384O003D012O00394O003D012O00083O000607007C0009000100132O003D012O005C4O00768O003D012O003A4O003D012O00734O003D012O003B4O003D012O003C4O003D012O00074O003D012O00124O003D012O005E4O003D012O00674O003D012O003F4O003D012O00094O003D012O003D4O003D012O003E4O003D012O00404O003D012O00414O003D012O00424O003D012O00434O003D012O00443O000607007D000A000100282O003D012O005C4O00768O003D012O00094O003D012O004F4O003D012O00124O003D012O005E4O003D012O004E4O003D012O00734O003D012O00504O003D012O00074O003D012O004A4O003D012O00684O003D012O00704O003D012O00544O003D012O00374O003D012O007B4O003D012O00484O003D012O00714O003D012O00084O003D012O00364O003D012O00554O003D012O00454O003D012O00464O003D012O00474O003D012O00384O003D012O00394O003D012O00494O003D012O004B4O003D012O004C4O003D012O004D4O003D012O003A4O003D012O003B4O003D012O003C4O003D012O00674O003D012O00404O003D012O00414O003D012O00724O003D012O00334O003D012O00344O003D012O00353O000607007E000B000100052O003D012O005C4O00768O003D012O00084O003D012O00124O003D012O00693O000607007F000C000100102O003D012O005C4O00768O003D012O00124O003D012O00084O003D012O00074O003D012O00624O003D012O00094O003D012O00724O003D012O00734O003D012O005E4O003D012O00714O003D012O00644O003D012O00704O003D012O00384O003D012O00394O003D012O007B3O0006070080000D000100132O003D012O00724O003D012O00734O003D012O00084O003D012O00764O003D012O006B4O003D012O00124O003D012O005E4O00768O003D012O00714O003D012O005C4O003D012O00074O003D012O006C4O003D012O00644O003D012O00704O003D012O00384O003D012O00394O003D012O007B4O003D012O00624O003D012O00093O0006070081000E000100202O003D012O005C4O00768O003D012O00074O003D012O00624O003D012O00124O003D012O00084O003D012O00094O003D012O007A4O003D012O00704O003D012O00734O003D012O00384O003D012O00394O003D012O007B4O003D012O00564O003D012O00204O003D012O00174O003D012O00554O003D012O006A4O003D012O00714O003D012O005E4O003D012O00724O003D012O005B4O003D012O00694O003D012O006E4O003D012O007E4O003D012O006F4O003D012O00794O003D012O007F4O003D012O006D4O003D012O00804O003D012O006C4O003D012O006B3O0006070082000F0001000F2O003D012O00784O003D012O00734O003D012O00814O003D012O00074O003D012O007A4O003D012O00214O003D012O005C4O003D012O005E4O003D012O00094O003D012O00224O003D012O001F4O003D012O00774O003D012O00554O003D012O007C4O003D012O007D3O000607008300100001000F2O003D012O00094O003D012O001F4O003D012O00774O003D012O00544O003D012O007D4O003D012O00074O003D012O007A4O003D012O005C4O00768O003D012O001B4O003D012O00734O003D012O00124O003D012O005E4O003D012O00214O003D012O00083O00060700840011000100082O003D012O00734O003D012O005C4O003D012O00514O003D012O00094O003D012O00074O00768O003D012O00124O003D012O005E3O000607008500120001000F2O003D012O005A4O003D012O006D4O003D012O005C4O00768O003D012O006E4O003D012O00694O003D012O00074O003D012O006F4O003D012O00734O003D012O00804O003D012O00124O003D012O005E4O003D012O00674O003D012O007F4O003D012O00093O000607008600130001000F2O003D012O00694O003D012O005C4O00768O003D012O00074O003D012O006F4O003D012O006D4O003D012O006E4O003D012O005A4O003D012O007F4O003D012O00804O003D012O00094O003D012O00124O003D012O005E4O003D012O00674O003D012O00733O000607008700140001000F2O003D012O006D4O003D012O005C4O00768O003D012O006E4O003D012O005A4O003D012O00694O003D012O00074O003D012O006F4O003D012O00734O003D012O007F4O003D012O00804O003D012O00124O003D012O005E4O003D012O00674O003D012O00093O000607008800150001001D2O003D012O002B4O00768O003D012O00294O003D012O002A4O003D012O00284O003D012O00264O003D012O00274O003D012O001D4O003D012O001E4O003D012O001F4O003D012O00224O003D012O00204O003D012O00214O003D012O00234O003D012O00244O003D012O00254O003D012O002C4O003D012O002D4O003D012O002E4O003D012O00324O003D012O00194O003D012O00174O003D012O00184O003D012O001A4O003D012O001B4O003D012O001C4O003D012O002F4O003D012O00304O003D012O00313O00060700890016000100222O003D012O00394O00768O003D012O003A4O003D012O00374O003D012O00384O003D012O004B4O003D012O004C4O003D012O004D4O003D012O004E4O003D012O003D4O003D012O003E4O003D012O003B4O003D012O003C4O003D012O00534O003D012O00474O003D012O00484O003D012O00494O003D012O004A4O003D012O00514O003D012O00524O003D012O004F4O003D012O00504O003D012O00434O003D012O00444O003D012O00334O003D012O00344O003D012O00414O003D012O00424O003D012O003F4O003D012O00404O003D012O00354O003D012O00364O003D012O00454O003D012O00463O000607008A0017000100242O003D012O00884O003D012O00894O003D012O00544O00768O003D012O00554O003D012O00564O003D012O00574O003D012O00584O003D012O005B4O003D012O00684O003D012O00074O003D012O005C4O003D012O00844O003D012O00854O003D012O00824O003D012O00864O003D012O00874O003D012O00834O003D012O00814O003D012O00724O003D012O00674O003D012O00704O003D012O00714O003D012O00634O003D012O00624O003D012O00614O003D012O00644O003D012O00524O003D012O00044O00763O00014O00763O00024O003D012O00534O003D012O00734O003D012O005A4O003D012O00594O003D012O001F3O000607008B0018000100032O003D012O00744O003D012O000F4O00767O002027008C000F006C00122O008D006D6O008E008A6O008F008B6O008C008F00016O00013O00193O000E3O00030E3O00383DA22A41212C1500A72A47313003073O00497150D2582E57030B3O004973417661696C61626C65025O00588140025O0038814003123O00A525DE02E28D20CC10EB8408C810F2872ADE03053O0087E14CAD72030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303193O0044697370652O6C61626C6544697365617365446562752O667303123O003EE4ABA0A9B1AB1BEFB4B588B8A50FEBBEA303073O00C77A8DD8D0CCDD03173O0089D403E07DFAA1DC12FC7DDBACDA19F35CF3AFC816F66B03063O0096CDBD70901800274O00768O00CC000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O000200020006B23O000C000100010004473O000C0001002E150004001A000100050004473O001A00012O00763O00024O003E2O0100013O00122O000200063O00122O000300076O0001000300024O000200033O00202O0002000200084O000300023O00202O0003000300094O000400023O00202O00040004000A2O00DF0002000400022O0050012O000100020004473O002600012O00763O00024O0005000100013O00122O0002000B3O00122O0003000C6O0001000300024O000200026O000300013O00122O0004000D3O00122O0005000E6O0003000500024O0002000200032O0050012O000100022O00D23O00019O003O00034O00768O00363O000100012O00D23O00017O00043O0003113O00446562752O665265667265736861626C65030E3O00536861646F77576F72645061696E03093O0054696D65546F446965026O002840010E3O0020392O013O00014O00035O00202O0003000300024O00010003000200062O0001000C00013O0004473O000C000100205300013O00032O00422O0100020002000EF20004000B000100010004473O000B00012O002400016O00FC000100014O0075000100024O00D23O00017O000B3O00028O00025O00507040025O003AAE4003133O00E0080EDFBF7B8EC03A16C6BF708FD60D0EC6BB03073O00E6B47F67B3D61C030B3O004973417661696C61626C65030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O6603053O00BF085652E103073O0080EC653F268421030B3O004578656375746554696D6500293O00121F3O00013O0026BB3O0001000100010004473O0001000100121F000100013O0026BB00010004000100010004473O00040001002EC800020024000100030004473O002400012O007600026O0053010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002002400013O0004473O002400012O0076000200023O0020B80002000200074O00045O00202O0004000400084O0002000400024O00036O00CC000400013O00122O000500093O00122O0006000A6O0004000600024O00030003000400202O00030003000B4O00030002000200062201030022000100020004473O002200012O002400026O00FC000200014O0075000200024O00FC00026O0075000200023O0004473O000400010004473O000100012O00D23O00017O00093O0003063O009CBC034DB0F203073O00AFCCC97124D68B03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974025O00E07440025O00D4A740030B3O00507572696679466F637573030D3O0057D927D5025E8C31D51757C93903053O006427AC55BC00204O00768O00532O0100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004473O001200012O00763O00023O0006993O001200013O0004473O001200012O00763O00033O00204B5O00042O001C012O000100020006B23O0014000100010004473O00140001002EC80006001F000100050004473O001F00012O00763O00044O0076000100053O00204B0001000100072O0042012O000200020006993O001F00013O0004473O001F00012O00763O00013O00121F000100083O00121F000200094O00123O00024O00718O00D23O00017O00313O00028O00025O008AAC40025O00C7B240026O00F03F025O004CAA40025O004EAC40025O0010B240025O00049E40025O0050A040025O00789F4003043O008B79BD8503053O0053CD18D9E003073O004973526561647903103O004865616C746850657263656E7461676503043O0046616465030E3O00E0C4C938A6C1C83BE3CBDE34F0C003043O005D86A5AD030F3O009AF72OD23FDCB36ABBC2D3C323CBA003083O001EDE92A1A25AAED2030A3O0049734361737461626C65030F3O00446573706572617465507261796572031A3O00E14B631AE05C711EE0716018E4577518A54A750CE0406303F34B03043O006A852E10025O00C2A940025O0052B240025O00807840025O00B8A940030B3O00702572F04E484B347CF25F03063O00203840139C3A030B3O004865616C746873746F6E65025O00C05D40025O00B3B14003173O0052CDE45A4EFA934EC7EB531AF6855CCDEB4553E4851A9B03073O00E03AA885363A92025O0056A340025O002EAE40025O001AA140025O00F49A4003193O006B534DEF70958F0257510BD570878B0257510BCD7A928E045703083O006B39362B9D15E6E7025O00D49A40025O009AAA4003173O00E98E17E7BCCFC7D28516DDBCDDC3D28516C5B6C8C6D48503073O00AFBBEB7195D9BC03173O0052656672657368696E674865616C696E67506F74696F6E025O00805D40025O00609D4003253O002EAA875EE66A7035A1860CEB7C7930A68F4BA3697728A68E42A32O7D3AAA8F5FEA6F7D7CFB03073O00185CCFE12C831900BB3O00121F3O00014O00AA000100023O002E15000200B4000100030004473O00B400010026BB3O00B4000100040004473O00B40001000E1700010006000100010004473O0006000100121F000200013O002E1500050058000100060004473O005800010026BB00020058000100010004473O0058000100121F000300013O0026AB00030012000100040004473O00120001002E0C01070004000100080004473O0014000100121F000200043O0004473O005800010026AB00030018000100010004473O00180001002EC80009000E0001000A0004473O000E00012O007600046O0053010500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000D4O00040002000200062O0004003800013O0004473O003800012O0076000400023O0006990004003800013O0004473O003800012O0076000400033O00205300040004000E2O00420104000200022O0076000500043O00062001040038000100050004473O003800012O0076000400054O009B00055O00202O00050005000F4O000600076O000800016O00040008000200062O0004003800013O0004473O003800012O0076000400013O00121F000500103O00121F000600114O0012000400064O007100046O007600046O0053010500013O00122O000600123O00122O000700136O0005000700024O00040004000500202O0004000400144O00040002000200062O0004005600013O0004473O005600012O0076000400063O0006990004005600013O0004473O005600012O0076000400033O00205300040004000E2O00420104000200022O0076000500073O00062001040056000100050004473O005600012O0076000400054O007600055O00204B0005000500152O00420104000200020006990004005600013O0004473O005600012O0076000400013O00121F000500163O00121F000600174O0012000400064O007100045O00121F000300043O0004473O000E0001000E620004005C000100020004473O005C0001002EC800190009000100180004473O00090001002E15001A00800001001B0004473O008000012O0076000300084O0053010400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003008000013O0004473O008000012O0076000300093O0006990003008000013O0004473O008000012O0076000300033O00205300030003000E2O00420103000200022O00760004000A3O00062001030080000100040004473O008000012O0076000300054O00370004000B3O00202O00040004001E4O000500066O000700016O00030007000200062O0003007B000100010004473O007B0001002E15002000800001001F0004473O008000012O0076000300013O00121F000400213O00121F000500224O0012000300054O007100036O00760003000C3O0006990003008900013O0004473O008900012O0076000300033O00205300030003000E2O00420103000200022O00760004000D3O00061D00030003000100040004473O008B0001002EC8002400BA000100230004473O00BA0001002E15002600BA000100250004473O00BA00012O00760003000E4O0030010400013O00122O000500273O00122O000600286O00040006000200062O000300BA000100040004473O00BA0001002EC8002900BA0001002A0004473O00BA00012O0076000300084O0053010400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O000300BA00013O0004473O00BA00012O0076000300054O00370004000B3O00202O00040004002D4O000500066O000700016O00030007000200062O000300AA000100010004473O00AA0001002E0C012E00120001002F0004473O00BA00012O0076000300013O001240010400303O00122O000500316O000300056O00035O00044O00BA00010004473O000900010004473O00BA00010004473O000600010004473O00BA00010026BB3O0002000100010004473O0002000100121F000100014O00AA000200023O00121F3O00043O0004473O000200012O00D23O00017O00113O00028O00025O0040A940025O00089140026O00F03F025O0032A940025O00D09C40025O0044A540025O00A5B240025O005C9B40025O00F07740030C3O0053686F756C6452657475726E03133O0048616E646C65426F2O746F6D5472696E6B6574026O004440025O00C09340025O0083B04003103O0048616E646C65546F705472696E6B6574025O00208E4000463O00121F3O00014O00AA000100023O002EC800030009000100020004473O000900010026BB3O0009000100010004473O0009000100121F000100014O00AA000200023O00121F3O00043O002EC800060002000100050004473O000200010026BB3O0002000100040004473O00020001000E6200010011000100010004473O00110001002E150008000D000100070004473O000D000100121F000200013O002EC8000A0024000100090004473O002400010026BB00020024000100040004473O002400012O007600035O00209700030003000C4O000400016O000500023O00122O0006000D6O000700076O00030007000200122O0003000B3O00122O0003000B3O00062O0003004500013O0004473O0045000100123A0103000B4O0075000300023O0004473O004500010026BB00020012000100010004473O0012000100121F000300013O0026BB0003002B000100040004473O002B000100121F000200043O0004473O00120001002EC8000E00270001000F0004473O00270001000E1700010027000100030004473O002700012O007600045O0020540004000400104O000500016O000600023O00122O0007000D6O000800086O00040008000200122O0004000B3O002E2O00110007000100110004473O003E000100123A0104000B3O0006990004003E00013O0004473O003E000100123A0104000B4O0075000400023O00121F000300043O0004473O002700010004473O001200010004473O004500010004473O000D00010004473O004500010004473O000200012O00D23O00017O001C3O0003073O0047657454696D65028O00026O00F03F025O00F5B140025O004CA540025O00D4B040025O000FB240030B3O0069DCBC551A734FE0B7591703063O001D2BB3D82C7B030B3O004973417661696C61626C65030F3O008DD63749AFEE2F5EB9EA2845B8D52403043O002CDDB94003073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O66025O0092A140025O0010814003153O00506F776572576F7264536869656C64506C61796572031D3O0011E85F5A613EF0474D773EF44056760DE3774F7F00FE2O4D330CE85E5A03053O00136187283F025O0020A540025O0072AC40030E3O008F52343E2338AD7A363A3B39AB4E03063O0051CE3C535B4F03143O00416E67656C696346656174686572506C61796572031B3O004FA5D77723CA4E9B48AED16627C65F9B5EA7D16B2AD10DA941BDD503083O00C42ECBB0124FA32D00823O0012163O00018O000100024O00019O003O00014O000100013O00064O0008000100010004473O000800010004473O0081000100121F3O00024O00AA000100023O0026BB3O000F000100020004473O000F000100121F000100024O00AA000200023O00121F3O00033O000E620003001300013O0004473O00130001002E0C010400F9FF2O00050004473O000A00010026AB00010017000100020004473O00170001002E0C010600FEFF2O00070004473O0013000100121F000200023O0026BB00020018000100020004473O001800012O0076000300024O0053010400033O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003004C00013O0004473O004C00012O0076000300024O0053010400033O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003004C00013O0004473O004C00012O0076000300043O0006990003004C00013O0004473O004C00012O0076000300053O00203901030003000E4O000500023O00202O00050005000F4O00030005000200062O0003004C00013O0004473O004C00012O0076000300053O00203901030003000E4O000500023O00202O0005000500104O00030005000200062O0003004C00013O0004473O004C0001002EC80012004C000100110004473O004C00012O0076000300064O0076000400073O00204B0004000400132O00420103000200020006990003004C00013O0004473O004C00012O0076000300033O00121F000400143O00121F000500154O0012000300054O007100035O002E1500160081000100170004473O008100012O0076000300024O0053010400033O00122O000500183O00122O000600196O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003008100013O0004473O008100012O0076000300083O0006990003008100013O0004473O008100012O0076000300053O00203901030003000E4O000500023O00202O00050005000F4O00030005000200062O0003008100013O0004473O008100012O0076000300053O00203901030003000E4O000500023O00202O0005000500104O00030005000200062O0003008100013O0004473O008100012O0076000300053O00203901030003000E4O000500023O00202O00050005000F4O00030005000200062O0003008100013O0004473O008100012O0076000300064O0076000400073O00204B00040004001A2O00420103000200020006990003008100013O0004473O008100012O0076000300033O0012400104001B3O00122O0005001C6O000300056O00035O00044O008100010004473O001800010004473O008100010004473O001300010004473O008100010004473O000A00012O00D23O00017O00173O0003073O004973526561647903103O004865616C746850657263656E74616765025O00B5B040025O00D0954003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66025O0054B040025O00E0764003123O004461726B52657072696D616E64466F637573031C3O00BC236C151BE9EAA830771325F5EB8724711D31E8AFA827701F2AF8EA03073O008FD8421E7E449B030C3O0050656E616E6365466F637573025O00A06240025O0086B14003153O00BACD03CACBA0D2DEACC70EDED6E3C7E4A4C903C8C003083O0081CAA86DABA5C3B7025O00308440025O00349040032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66030E3O0049735370652O6C496E52616E6765030F3O00325D39D9D017E3624832D6DF1AE52703073O0086423857B8BE7401514O007600015O0020530001000100012O00422O01000200020006990001005000013O0004473O005000012O0076000100013O0006990001000E00013O0004473O000E00012O0076000100013O0020530001000100022O00422O01000200022O0076000200023O00061D00010003000100020004473O00100001002E1500030032000100040004473O003200012O0076000100033O00208D0001000100054O000300043O00202O0003000300064O00010003000200062O00010019000100010004473O00190001002E1500070025000100080004473O002500012O0076000100054O0076000200063O00204B0002000200092O00422O01000200020006990001003200013O0004473O003200012O0076000100073O0012400102000A3O00122O0003000B6O000100036O00015O00044O003200012O0076000100054O0076000200063O00204B00020002000C2O00422O01000200020006B20001002D000100010004473O002D0001002E15000E00320001000D0004473O003200012O0076000100073O00121F0002000F3O00121F000300104O0012000100034O007100015O002EC800110050000100120004473O005000010006B23O0050000100010004473O005000012O0076000100083O0020242O01000100134O000200043O00202O0002000200144O000300096O00048O00058O0001000500024O0002000A3O00062O00010050000100020004473O005000012O0076000100054O000900028O0003000B3O00202O0003000300154O00058O0003000500024O000300036O00010003000200062O0001005000013O0004473O005000012O0076000100073O00121F000200163O00121F000300174O0012000100034O007100016O00D23O00017O00503O00028O00025O001CAC40025O0034AD40025O00B88940025O00988C40026O00F03F025O0062B340025O000DB14003113O000C3E1EBE0BDC2E27380308BF10EA2F363903083O00555C5169DB798B4103073O0049735265616479031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503063O0042752O66557003153O0052616469616E7450726F766964656E636542752O6603163O00506F776572576F726452616469616E6365466F637573025O00188440025O0044974003293O00EDBC47406EE0EABC424143CDFCB7594472DCF88C594B6FCBFCBD440574DAFCBF6F4673D0F1B75F527203063O00BF9DD330251C03063O00FE11ED1334DA03053O005ABF7F947C030F3O00488627194B923E076A823D0471882003043O007718E74E03083O0042752O66446F776E030F3O005061696E53752O7072652O73696F6E03103O004865616C746850657263656E7461676503143O005061696E53752O7072652O73696F6E466F637573025O00B07D40025O004FB040031E3O00922CAC44E35304923DB74FCF53188D23E542D9411DBD2EAA45D0441E952303073O0071E24DC52ABC2003093O000E17FABE7A39FAB92303043O00D55A7694025O00C4A540025O00405E40030F3O006B2FBD587E4E3EA4442O483DBD594303053O002D3B4ED43603073O00436F2O6D6F6E73030D3O00556E697447726F7570526F6C6503043O002477ADA003083O00907036E3EBE64ECD031E3O00A32906F2EF48A6381FEED548A02100F29053B62903C3D354BC240BF3C75503063O003BD3486F9CB0025O00A09D40025O00FEA540030D3O007A86ED260E86ED290EB4E6214803043O004D2EE783030F3O008A55BF4E8941A650A851A553B35BB803043O0020DA34D603043O007A361F8303083O003A2E7751C891D02503063O0003A911808C8F03073O00564BEC50CCC9DD025O0014A040025O0058A240025O0092AB40025O007C9B40031E3O0062407E8BC19867516797FB986148788BBE8377407BBAFD847D4D738AE98503063O00EB122117E59E025O00607640025O00649D40025O004C9F40025O00A6A540030D3O0060B5D6BE428DCEA95496C8BD5503043O00DB30DAA103063O0045786973747303123O00506F776572576F72644C696665466F637573025O004EA440025O0080A240031D3O00F47E6B4CC970F7EB637876D746E6E131744CDA43DFE77E7345DF40F7EA03073O008084111C29BB2F025O008AA540025O0054A040030F3O002D270B33530E2715185C13200F3F4F03053O003D6152665A025O00B08640025O003C9840030F3O004C756D696E6F757342612O72696572031E3O00A03BA642C9580B1A932CAA59D55E2O1BEC26AE4ACB681D06A322AF44D05903083O0069CC4ECB2BA7377E0056012O00121F3O00014O00AA000100013O002E1500020002000100030004473O000200010026BB3O0002000100010004473O0002000100121F000100013O0026BB000100052O0100010004473O00052O0100121F000200014O00AA000300033O0026AB0002000F000100010004473O000F0001002E150005000B000100040004473O000B000100121F000300013O0026BB000300FC000100010004473O00FC000100121F000400013O0026BB00040017000100060004473O0017000100121F000300063O0004473O00FC00010026AB0004001B000100010004473O001B0001002E1500070013000100080004473O001300012O007600056O0053010600013O00122O000700093O00122O0008000A6O0006000800024O00050005000600202O00050005000B4O00050002000200062O0005004500013O0004473O004500012O0076000500023O0006990005004500013O0004473O004500012O0076000500033O0020FF00050005000C4O000600046O000700056O00050007000200062O0005004500013O0004473O004500012O0076000500063O00203901050005000D4O00075O00202O00070007000E4O00050007000200062O0005004500013O0004473O004500012O0076000500074O0029000600083O00202O00060006000F4O000700076O000800096O00050008000200062O00050040000100010004473O00400001002E1500110045000100100004473O004500012O0076000500013O00121F000600123O00121F000700134O0012000500074O007100056O00760005000A4O0030010600013O00122O000700143O00122O000800156O00060008000200062O00050076000100060004473O007600012O007600056O0053010600013O00122O000700163O00122O000800176O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500FA00013O0004473O00FA00012O00760005000B3O0020390105000500184O00075O00202O0007000700194O00050007000200062O000500FA00013O0004473O00FA00012O00760005000C3O000699000500FA00013O0004473O00FA00012O00760005000B3O00205300050005001A2O00420105000200022O00760006000D3O000620010500FA000100060004473O00FA00012O0076000500074O0037000600083O00202O00060006001B4O000700086O000900016O00050009000200062O00050070000100010004473O00700001002E0C011C008C0001001D0004473O00FA00012O0076000500013O0012400106001E3O00122O0007001F6O000500076O00055O00044O00FA00012O00760005000A4O0045010600013O00122O000700203O00122O000800216O00060008000200062O0005007F000100060004473O007F0001002EC8002200B1000100230004473O00B100012O007600056O0053010600013O00122O000700243O00122O000800256O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500FA00013O0004473O00FA00012O00760005000B3O0020390105000500184O00075O00202O0007000700194O00050007000200062O000500FA00013O0004473O00FA00012O00760005000C3O000699000500FA00013O0004473O00FA00012O00760005000B3O00205300050005001A2O00420105000200022O00760006000D3O000620010500FA000100060004473O00FA000100123A010500263O0020570005000500274O0006000B6O0005000200024O000600013O00122O000700283O00122O000800296O00060008000200062O000500FA000100060004473O00FA00012O0076000500074O009B000600083O00202O00060006001B4O000700086O000900016O00050009000200062O000500FA00013O0004473O00FA00012O0076000500013O0012400106002A3O00122O0007002B6O000500076O00055O00044O00FA0001002E15002C00BB0001002D0004473O00BB00012O00760005000A4O0045010600013O00122O0007002E3O00122O0008002F6O00060008000200062O000500BB000100060004473O00BB00010004473O00FA00012O007600056O0053010600013O00122O000700303O00122O000800316O0006000800024O00050005000600202O00050005000B4O00050002000200062O000500E900013O0004473O00E900012O00760005000B3O0020390105000500184O00075O00202O0007000700194O00050007000200062O000500E900013O0004473O00E900012O00760005000C3O000699000500E900013O0004473O00E900012O00760005000B3O00205300050005001A2O00420105000200022O00760006000D3O000620010500E9000100060004473O00E9000100123A010500263O00207B0005000500274O0006000B6O0005000200024O000600013O00122O000700323O00122O000800336O00060008000200062O000500EB000100060004473O00EB000100123A010500263O00207B0005000500274O0006000B6O0005000200024O000600013O00122O000700343O00122O000800356O00060008000200062O000500EB000100060004473O00EB0001002E0C01360011000100370004473O00FA00012O0076000500074O0037000600083O00202O00060006001B4O000700086O000900016O00050009000200062O000500F5000100010004473O00F50001002E15003800FA000100390004473O00FA00012O0076000500013O00121F0006003A3O00121F0007003B4O0012000500074O007100055O00121F000400063O0004473O00130001000E6200062O002O0100030004474O002O01002E0C013C0012FF2O003D0004473O0010000100121F000100063O0004473O00052O010004473O001000010004473O00052O010004473O000B00010026AB000100092O0100060004473O00092O01002E0C013E2O00FF2O003F0004473O000700012O007600026O0053010300013O00122O000400403O00122O000500416O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002002E2O013O0004473O002E2O012O00760002000E3O0006990002002E2O013O0004473O002E2O012O00760002000B3O00205300020002001A2O00420102000200022O00760003000F3O0006200102002E2O0100030004473O002E2O012O00760002000B3O0020530002000200422O00420102000200020006990002002E2O013O0004473O002E2O012O0076000200074O0076000300083O00204B0003000300432O00420102000200020006B2000200292O0100010004473O00292O01002EC80044002E2O0100450004473O002E2O012O0076000200013O00121F000300463O00121F000400474O0012000200044O007100025O002E15004900552O0100480004473O00552O012O007600026O0053010300013O00122O0004004A3O00122O0005004B6O0003000500024O00020002000300202O00020002000B4O00020002000200062O000200552O013O0004473O00552O012O0076000200103O000699000200552O013O0004473O00552O012O0076000200033O0020FF00020002000C4O000300116O000400126O00020004000200062O000200552O013O0004473O00552O01002EC8004C00552O01004D0004473O00552O012O0076000200074O007600035O00204B00030003004E2O0042010200020002000699000200552O013O0004473O00552O012O0076000200013O0012400103004F3O00122O000400506O000200046O00025O00044O00552O010004473O000700010004473O00552O010004473O000200012O00D23O00017O00923O00028O00027O0040026O00F03F030F3O0023DA95FEF8F01CC786C8E2CE16D98603063O00A773B5E29B8A03073O004973526561647903103O004865616C746850657263656E7461676503083O0042752O66446F776E030D3O0041746F6E656D656E7442752O6603063O00457869737473025O00A8A240025O00689E4003143O00506F776572576F7264536869656C64466F63757303163O00F22DF059694ED1ED30E3636879CFE72EE31C7374C7EE03073O00A68242873C1B1103053O00764FC0702703053O0050242AAE1503053O0052656E6577025O00A3B240025O0050A940030A3O0052656E6577466F637573030A3O005C15397F59503F7F4F1C03043O001A2E7057025O00689D40025O00805840030F3O000E30EEF42C08F6E33A0CF1F83B33FD03043O00915E5F99030D3O00556E697447726F7570526F6C6503043O00C9EC3AFE03063O00D79DAD74B52E030F3O00506F776572576F7264536869656C64025O00CAB040025O00C9B040031B3O0025BB9CF7C80AA384E0DE0AA783FBDF39B0B4E6DB3BBFCBFADF34B803053O00BA55D4EB9203093O00E48D17ED31C65DC38D03073O0038A2E1769E598E030C3O007E0CCEAB2BD65B2DC5AE2ECB03063O00B83C65A0CF42030B3O004973417661696C61626C6503043O0047554944030E3O00466C6173684865616C466F637573030F3O00378E7DAF39BD74B9308E3CB434837003043O00DC51E21C025O0034A140025O0068B340026O000840025O00407840025O00E06440030F3O00412O66656374696E67436F6D626174030D3O00546172676574497356616C6964025O00788440025O0002A940025O0036AC40025O00F08D40030C3O0053686F756C6452657475726E025O0046AC4003093O009F2FAA67B797402OB503083O00D4D943CB142ODF25025O00D2AD40025O009C9E4003133O00BC81A9C12OB2A0D7BB8197DDB58EE8DABF8CA403043O00B2DAEDC8025O0010A740025O00AEAD40026O006640025O00E4994003093O004973496E52616E6765026O003E4003133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C61796572025O00409940025O00ECAF4003103O002E27C352242BEA483E2FC71B222BD45703043O003B4A4EB5030A4O00C75B54B420DD5349BE03053O00D345B12O3A03273O00467269656E646C79556E69747342656C6F774865616C746850657263656E74616765436F756E7403083O004973496E5261696403093O004973496E5061727479032F3O00467269656E646C79556E6974735769746842752O6642656C6F774865616C746850657263656E74616765436F756E74025O00B4A440025O00A09840030A3O004576616E67656C69736D030F3O00B2F378FBEECEBBEC6AF8A9C3B2E47503063O00ABD785199589025O00D07340025O00E0AC4003093O00C7C433E9E718F943ED03083O002281A8529A8F509C03063O0042752O665570030C3O0053757267656F664C69676874025O0070AA4003173O0083BE321840718180B33F3441409A91B33D1F08468C84BE03073O00E9E5D2536B282E03073O00F34322C210D34703053O0065A12252B603323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74025O001EAD40025O00BCA040025O00409A40025O002EA440030C3O0052617074757265466F637573030C3O00FA0C49EACEF0876EE00858F203083O004E886D399EBB82E2025O00709F40025O00E0A040025O004CA240025O00D6AC40025O002OB240025O00C06D40025O00F4AA40025O00D3B14003113O0095A5341B0133C843A198222O1A05C952A003083O0031C5CA437E7364A7031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503153O0052616469616E7450726F766964656E636542752O66025O00607040025O002OA84003163O00506F776572576F726452616469616E6365466F63757303293O002754C82C9269493849DB1692575A3E5AD12A8569573948CB288E421E3F5EDE25BF55513857DB26975803073O003E573BBF49E036030D3O00D70DEDCCF535F5DBE32EF3CFE203043O00A987629A03123O00506F776572576F72644C696665466F637573031D3O00DB783351EF0CDFC465206BF13A2OCE372C51FC3FF7C8782B58F93CDFC503073O00A8AB1744349D53025O00A0A240025O00E4AF40025O0022AE40025O00EEA04003113O00C47EE2A8371A88E675C7AC212486FA72F003073O00E7941195CD454D030E3O00B3AFC6FF58E8A3A8D1FE59FE8EB303063O009FE0C7A79B37030C3O00432O6F6C646F776E446F776E031A3O00E7FC2BD7E5CC2BDDE5F703C0F6F735D3F9F03992A5B334D7F6FF03043O00B297935C025O0056B140025O00289E40030A3O0048616C6F506C61796572026O00384003093O0084FC403D52447F8DF103073O001AEC9D2C52722C025O00608A40025O00C071400049032O00121F3O00013O0026BB3O00E8000100020004473O00E8000100121F000100013O0026BB00010060000100030004473O006000012O007600026O0053010300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O0002000200064O00020002000200062O0002002F00013O0004473O002F00012O0076000200023O0020530002000200072O00420102000200022O0076000300033O00063A0002002F000100030004473O002F00012O0076000200023O0020390102000200084O00045O00202O0004000400094O00020004000200062O0002002F00013O0004473O002F00012O0076000200023O00205300020002000A2O00420102000200020006990002002F00013O0004473O002F0001002E15000C002F0001000B0004473O002F00012O0076000200044O0076000300053O00204B00030003000D2O00420102000200020006990002002F00013O0004473O002F00012O0076000200013O00121F0003000E3O00121F0004000F4O0012000200044O007100026O007600026O0053010300013O00122O000400103O00122O000500116O0003000500024O00020002000300202O0002000200064O00020002000200062O0002005200013O0004473O005200012O0076000200023O0020530002000200072O00420102000200022O0076000300063O00063A00020052000100030004473O005200012O0076000200023O0020390102000200084O00045O00202O0004000400094O00020004000200062O0002005200013O0004473O005200012O0076000200023O0020390102000200084O00045O00202O0004000400124O00020004000200062O0002005200013O0004473O005200012O0076000200023O00205300020002000A2O00420102000200020006B200020054000100010004473O00540001002E0C0113000D000100140004473O005F00012O0076000200044O0076000300053O00204B0003000300152O00420102000200020006990002005F00013O0004473O005F00012O0076000200013O00121F000300163O00121F000400174O0012000200044O007100025O00121F000100023O0026AB00010064000100010004473O00640001002E15001800E1000100190004473O00E100012O007600026O0053010300013O00122O0004001A3O00122O0005001B6O0003000500024O00020002000300202O0002000200064O00020002000200062O0002009E00013O0004473O009E00012O0076000200073O00205700020002001C4O000300026O0002000200024O000300013O00122O0004001D3O00122O0005001E6O00030005000200062O0002009E000100030004473O009E00012O0076000200023O0020530002000200072O00420102000200022O0076000300083O00063A0002009E000100030004473O009E00012O0076000200023O00208D0002000200084O00045O00202O0004000400094O00020004000200062O0002008C000100010004473O008C00012O0076000200023O0020390102000200084O00045O00202O00040004001F4O00020004000200062O0002009E00013O0004473O009E00012O0076000200023O00205300020002000A2O00420102000200020006990002009E00013O0004473O009E0001002EC80021009E000100200004473O009E00012O0076000200044O0076000300053O00204B00030003000D2O00420102000200020006990002009E00013O0004473O009E00012O0076000200013O00121F000300223O00121F000400234O0012000200044O007100026O007600026O0053010300013O00122O000400243O00122O000500256O0003000500024O00020002000300202O0002000200064O00020002000200062O000200E000013O0004473O00E000012O007600026O0053010300013O00122O000400263O00122O000500276O0003000500024O00020002000300202O0002000200284O00020002000200062O000200E000013O0004473O00E000012O0076000200023O00200D0002000200294O0002000200024O000300093O00202O0003000300294O00030002000200062O000200E0000100030004473O00E000012O0076000200023O0020390102000200084O00045O00202O0004000400094O00020004000200062O000200E000013O0004473O00E000012O0076000200093O0020390102000200084O00045O00202O0004000400094O00020004000200062O000200E000013O0004473O00E000012O0076000200023O0020530002000200072O00420102000200022O00760003000A3O00063A000200E0000100030004473O00E000012O0076000200023O00205300020002000A2O0042010200020002000699000200E000013O0004473O00E000012O0076000200044O0044010300053O00202O00030003002A4O000400046O0005000B6O00020005000200062O000200E000013O0004473O00E000012O0076000200013O00121F0003002B3O00121F0004002C4O0012000200044O007100025O00121F000100033O002EC8002D00040001002E0004473O000400010026BB00010004000100020004473O0004000100121F3O002F3O0004473O00E800010004473O000400010026BB3O00552O01002F0004473O00552O01002E15003100232O0100300004473O00232O012O00760001000C3O0020530001000100062O00422O0100020002000699000100232O013O0004473O00232O012O00760001000D3O000699000100232O013O0004473O00232O012O0076000100093O0020530001000100322O00422O0100020002000699000100FE00013O0004473O00FE00012O0076000100073O00204B0001000100332O001C2O01000100020006B2000100232O0100010004473O00232O012O0076000100023O0020530001000100072O00422O01000200022O00760002000E3O00063A000100232O0100020004473O00232O012O0076000100023O00205300010001000A2O00422O0100020002000699000100232O013O0004473O00232O0100121F000100014O00AA000200023O0026AB0001000F2O0100010004473O000F2O01002E0C013400FEFF2O00350004473O000B2O0100121F000200013O002E15003700102O0100360004473O00102O010026BB000200102O0100010004473O00102O012O00760003000F4O00FC000400014O004201030002000200121A000300383O002E0C0139000B000100390004473O00232O0100123A010300383O000699000300232O013O0004473O00232O0100123A010300384O0075000300023O0004473O00232O010004473O00102O010004473O00232O010004473O000B2O012O007600016O0053010200013O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200202O0001000100064O00010002000200062O0001004803013O0004473O004803012O00760001000D3O0006990001004803013O0004473O004803012O0076000100093O0020530001000100322O00422O01000200020006990001003A2O013O0004473O003A2O012O0076000100073O00204B0001000100332O001C2O01000100020006B200010048030100010004473O004803012O0076000100023O0020530001000100072O00422O01000200022O0076000200103O00063A00010048030100020004473O004803012O0076000100023O00205300010001000A2O00422O01000200020006990001004803013O0004473O00480301002E15003D00480301003C0004473O004803012O0076000100044O009B000200053O00202O00020002002A4O000300036O000400016O00010004000200062O0001004803013O0004473O004803012O0076000100013O0012400102003E3O00122O0003003F6O000100036O00015O00044O004803010026AB3O00592O0100030004473O00592O01002EC80041005F020100400004473O005F020100121F000100013O002E15004200C22O0100430004473O00C22O010026BB000100C22O0100010004473O00C22O012O0076000200113O0020530002000200062O0042010200020002000699000200832O013O0004473O00832O012O0076000200073O00204B0002000200332O001C010200010002000699000200832O013O0004473O00832O012O0076000200123O00205300020002004400121F000400454O00DF000200040002000699000200832O013O0004473O00832O012O0076000200133O000699000200832O013O0004473O00832O012O0076000200023O0020530002000200462O00420102000200020006B2000200832O0100010004473O00832O012O0076000200044O0076000300053O00204B0003000300472O00420102000200020006B20002007E2O0100010004473O007E2O01002E15004900832O0100480004473O00832O012O0076000200013O00121F0003004A3O00121F0004004B4O0012000200044O007100026O007600026O0053010300013O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300202O0002000200064O00020002000200062O000200C12O013O0004473O00C12O012O0076000200143O000699000200C12O013O0004473O00C12O012O0076000200153O000699000200C12O013O0004473O00C12O012O0076000200093O0020530002000200322O0042010200020002000699000200C12O013O0004473O00C12O012O0076000200073O00200A00020002004E4O000300166O0002000200024O000300173O00062O000300C12O0100020004473O00C12O012O0076000200093O00205300020002004F2O00420102000200020006B2000200C12O0100010004473O00C12O012O0076000200093O0020530002000200502O0042010200020002000699000200C12O013O0004473O00C12O012O0076000200073O0020240102000200514O00035O00202O0003000300094O000400186O00058O00068O0002000600024O000300193O00062O000200C12O0100030004473O00C12O01002E15005300C12O0100520004473O00C12O012O0076000200044O007600035O00204B0003000300542O0042010200020002000699000200C12O013O0004473O00C12O012O0076000200013O00121F000300553O00121F000400564O0012000200044O007100025O00121F000100033O0026BB0001005A020100030004473O005A020100121F000200013O0026BB00020055020100010004473O00550201002EC800570009020100580004473O000902012O007600036O0053010400013O00122O000500593O00122O0006005A6O0004000600024O00030003000400202O0003000300064O00030002000200062O0003000902013O0004473O000902012O0076000300023O00208D0003000300084O00055O00202O0005000500094O00030005000200062O000300E82O0100010004473O00E82O012O0076000300023O0020390103000300084O00055O00202O00050005001F4O00030005000200062O0003000902013O0004473O000902012O0076000300023O0020390103000300084O00055O00202O0005000500124O00030005000200062O0003000902013O0004473O000902012O0076000300023O0020530003000300072O00420103000200022O00760004001A3O00063A00030009020100040004473O000902012O0076000300093O00203901030003005B4O00055O00202O00050005005C4O00030005000200062O0003000902013O0004473O000902012O0076000300023O00205300030003000A2O00420103000200020006990003000902013O0004473O00090201002E0C015D000F0001005D0004473O000902012O0076000300044O0044010400053O00202O00040004002A4O000500056O0006000B6O00030006000200062O0003000902013O0004473O000902012O0076000300013O00121F0004005E3O00121F0005005F4O0012000300054O007100036O007600036O0053010400013O00122O000500603O00122O000600616O0004000600024O00030003000400202O0003000300064O00030002000200062O0003004502013O0004473O004502012O0076000300093O00205300030003004F2O00420103000200020006B200030045020100010004473O004502012O0076000300093O0020530003000300502O00420103000200020006990003004502013O0004473O004502012O00760003001B3O0006990003004502013O0004473O004502012O0076000300143O0006990003004502013O0004473O004502012O0076000300093O0020530003000300322O00420103000200020006990003004502013O0004473O004502012O0076000300023O0020530003000300072O00420103000200022O00760004001C3O00063A00030045020100040004473O004502012O0076000300073O0020240103000300624O00045O00202O0004000400094O000500186O00068O00078O0003000700024O0004001D3O00062O00040045020100030004473O004502012O0076000300023O0020390103000300084O00055O00202O0005000500094O00030005000200062O0003004502013O0004473O004502012O0076000300023O00205300030003000A2O00420103000200020006B200030047020100010004473O00470201002EC800630054020100640004473O00540201002EC800650054020100660004473O005402012O0076000300044O0076000400053O00204B0004000400672O00420103000200020006990003005402013O0004473O005402012O0076000300013O00121F000400683O00121F000500694O0012000300054O007100035O00121F000200033O000E17000300C52O0100020004473O00C52O0100121F000100023O0004473O005A02010004473O00C52O010026BB0001005A2O0100020004473O005A2O0100121F3O00023O0004473O005F02010004473O005A2O01002EC8006A00010001006B0004473O000100010026BB3O0001000100010004473O0001000100121F000100014O00AA000200023O000E1700010065020100010004473O0065020100121F000200013O0026AB0002006C020100010004473O006C0201002E0C016C00610001006D0004473O00CB020100121F000300013O0026BB00030071020100030004473O0071020100121F000200033O0004473O00CB02010026AB00030075020100010004473O00750201002E15006E006D0201006F0004473O006D0201002E15007000A6020100710004473O00A602012O007600046O0053010500013O00122O000600723O00122O000700736O0005000700024O00040004000500202O0004000400064O00040002000200062O000400A602013O0004473O00A602012O00760004001E3O000699000400A602013O0004473O00A602012O0076000400073O0020FF0004000400744O0005001F6O000600206O00040006000200062O000400A602013O0004473O00A602012O0076000400093O00203901040004005B4O00065O00202O0006000600754O00040006000200062O000400A602013O0004473O00A602012O0076000400023O00205300040004000A2O0042010400020002000699000400A602013O0004473O00A60201002E15007600A6020100770004473O00A602012O0076000400044O0044010500053O00202O0005000500784O000600066O000700216O00040007000200062O000400A602013O0004473O00A602012O0076000400013O00121F000500793O00121F0006007A4O0012000400064O007100046O007600046O0053010500013O00122O0006007B3O00122O0007007C6O0005000700024O00040004000500202O0004000400064O00040002000200062O000400C902013O0004473O00C902012O0076000400223O000699000400C902013O0004473O00C902012O0076000400023O0020530004000400072O00420104000200022O0076000500233O000620010400C9020100050004473O00C902012O0076000400023O00205300040004000A2O0042010400020002000699000400C902013O0004473O00C902012O0076000400044O0076000500053O00204B00050005007D2O0042010400020002000699000400C902013O0004473O00C902012O0076000400013O00121F0005007E3O00121F0006007F4O0012000400064O007100045O00121F000300033O0004473O006D0201002EC8008000D1020100810004473O00D102010026BB000200D1020100020004473O00D1020100121F3O00033O0004473O000100010026AB000200D5020100030004473O00D50201002EC800820068020100830004473O0068020100121F000300013O0026BB0003003D030100010004473O003D03012O007600046O0053010500013O00122O000600843O00122O000700856O0005000700024O00040004000500202O0004000400064O00040002000200062O0004000F03013O0004473O000F03012O00760004001E3O0006990004000F03013O0004473O000F03012O0076000400073O0020FF0004000400744O0005001F6O000600206O00040006000200062O0004000F03013O0004473O000F03012O0076000400023O00208D0004000400084O00065O00202O0006000600094O00040006000200062O000400FD020100010004473O00FD02012O007600046O0053010500013O00122O000600863O00122O000700876O0005000700024O00040004000500202O0004000400884O00040002000200062O0004000F03013O0004473O000F03012O0076000400023O00205300040004000A2O00420104000200020006990004000F03013O0004473O000F03012O0076000400044O0044010500053O00202O0005000500784O000600066O000700216O00040007000200062O0004000F03013O0004473O000F03012O0076000400013O00121F000500893O00121F0006008A4O0012000400064O007100046O0076000400243O0020530004000400062O00420104000200020006990004002903013O0004473O002903012O0076000400073O00204B0004000400332O001C0104000100020006990004002903013O0004473O002903012O0076000400123O00205300040004004400121F000600454O00DF0004000600020006990004002903013O0004473O002903012O0076000400253O0006990004002903013O0004473O002903012O0076000400073O0020420004000400744O000500266O000600276O00040006000200062O0004002B030100010004473O002B0301002E0C018B00130001008C0004473O003C03012O0076000400044O000A010500053O00202O00050005008D4O000600023O00202O00060006004400122O0008008E6O0006000800024O000600066O000700016O00040007000200062O0004003C03013O0004473O003C03012O0076000400013O00121F0005008F3O00121F000600904O0012000400064O007100045O00121F000300033O000E6200030041030100030004473O00410301002EC8009100D6020100920004473O00D6020100121F000200023O0004473O006802010004473O00D602010004473O006802010004473O000100010004473O006502010004473O000100012O00D23O00017O002E3O00025O005C9140025O00709340030E3O0086A0F4D7B381EED581BCE5DBB3B103043O00B0D6D58603073O0049735265616479030A3O00446562752O66446F776E03143O0050757267655468655769636B6564446562752O6603093O0054696D65546F44696503143O00C4B8A4D3AD6251F19ABFD7A3535DD0A8B4C1AE5003073O003994CDD6B4C836030C3O00426173654475726174696F6E026O33D33F030E3O0050757267655468655769636B6564030E3O0049735370652O6C496E52616E6765031A3O0002E82733732DE93D314905F4363F7316BD25267302C22637790403053O0016729D555403093O00E9C21DC07FFAA9D7DF03073O00C8A4AB73A43D9603093O004D696E64426C617374025O0004AF40025O0032A24003143O00B3FD0D412OBCF8025697FEE411409381E7004A9503053O00E3DE946325030F3O00035D45F3EB045D40F2CA3C5E53F5FC03053O0099532O3296025O00949240025O009AA740030F3O00506F776572576F7264536F6C616365031B3O004D79641961945A5264772360A4415C75765C63B9484D49601F7CBD03073O002D3D16137C13CB025O0048B040025O005EAC4003053O00F21F04E10703073O00D9A1726D956210030A3O0049734361737461626C6503053O00536D697465030F3O00012D3168B93402323D6C8367112F2E03063O00147240581CDC025O00C8A640025O0076AF40030E3O000114C0B3FDE4B53436DBB7F3D5B903073O00DD5161B2D498B003143O00FDF20FFC1FF9EF18CC13CEEC18FF3EC8E508FD1C03053O007AAD877D9B031C3O0094D412BE3A0EDC8CC43FAE3632C381C540A92D34D8BBD203B629719A03073O00A8E4A160D95F5100C03O002E1500010032000100020004473O003200012O00768O00532O0100013O00122O000200033O00122O000300046O0001000300028O000100206O00056O0002000200064O003200013O0004473O003200012O00763O00023O002039014O00064O00025O00202O0002000200076O0002000200064O003200013O0004473O003200012O00763O00023O00201F014O00086O000200024O00018O000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O00010001000B4O00010002000200102O0001000C000100062O0001003200013O0004473O003200012O00763O00034O003C2O015O00202O00010001000D4O000200023O00202O00020002000E4O00045O00202O00040004000D4O0002000400024O000200028O0002000200064O003200013O0004473O003200012O00763O00013O00121F0001000F3O00121F000200104O00123O00024O00718O00768O00532O0100013O00122O000200113O00122O000300126O0001000300028O000100206O00056O0002000200064O005300013O0004473O005300012O00763O00043O0006B23O0053000100010004473O005300012O00763O00034O006A00015O00202O0001000100134O000200023O00202O00020002000E4O00045O00202O0004000400134O0002000400024O000200026O000300018O0003000200064O004E000100010004473O004E0001002E1500140053000100150004473O005300012O00763O00013O00121F000100163O00121F000200174O00123O00024O00718O00768O00532O0100013O00122O000200183O00122O000300196O0001000300028O000100206O00056O0002000200064O007300013O0004473O007300012O00763O00043O0006B23O0073000100010004473O00730001002EC8001A00730001001B0004473O007300012O00763O00034O003C2O015O00202O00010001001C4O000200023O00202O00020002000E4O00045O00202O00040004001C4O0002000400024O000200028O0002000200064O007300013O0004473O007300012O00763O00013O00121F0001001D3O00121F0002001E4O00123O00024O00717O002EC8002000940001001F0004473O009400012O00768O00532O0100013O00122O000200213O00122O000300226O0001000300028O000100206O00236O0002000200064O009400013O0004473O009400012O00763O00043O0006B23O0094000100010004473O009400012O00763O00034O009000015O00202O0001000100244O000200023O00202O00020002000E4O00045O00202O0004000400244O0002000400024O000200026O000300018O0003000200064O009400013O0004473O009400012O00763O00013O00121F000100253O00121F000200264O00123O00024O00717O002E15002700BF000100280004473O00BF00012O00768O00532O0100013O00122O000200293O00122O0003002A6O0001000300028O000100206O00056O0002000200064O00BF00013O0004473O00BF00012O00763O00023O00201F014O00086O000200024O00018O000200013O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200202O00010001000B4O00010002000200102O0001000C000100062O000100BF00013O0004473O00BF00012O00763O00034O003C2O015O00202O00010001000D4O000200023O00202O00020002000E4O00045O00202O00040004000D4O0002000400024O000200028O0002000200064O00BF00013O0004473O00BF00012O00763O00013O00121F0001002D3O00121F0002002E4O00123O00024O00718O00D23O00017O00BA3O00028O00025O00909840025O00D6AF40026O001440030B3O002FCF704417D5405E02D27F03043O002C63A61703073O0049735265616479025O00489C40026O00B340025O00E49740025O00A8B140030B3O004C69676874735772617468030E3O0049735370652O6C496E52616E676503173O0070FE2E3E27B743E03B3727AC3CE4213921B043E42A392503063O00C41C97495653030F3O00C30C3E15906F1764F730261C835B1D03083O001693634970E23878025O00F09E40025O00049640025O0022A040030F3O00506F776572576F7264536F6C616365031C3O00A87AF5F09F8762EDE7898766EDF98CBB70A2E685B767F6CA9EBB7AF403053O00EDD815829503083O00AA4153469EC6488303073O003EE22E2O3FD0A903093O0042752O66537461636B030C3O0052686170736F647942752O66026O003440027O0040025O00209A40025O00E8B14003083O00486F6C794E6F766103093O004973496E52616E6765026O002840025O00B49340025O007C904003143O00ED16599A20032048E459468B101F3B61F61A5A9503083O003E857935E37F6D4F03053O0023193BE1D303073O00C270745295B6CE025O00788440025O00E07F40025O0030B040025O0012A24003053O00536D69746503103O002AA5450CC5A21D31A75E0CFFF10D36BE03073O006E59C82C78A082026O000840026O00F03F030F3O0063A9F4274B3967AEE727602B51B5FD03063O004E30C195432403093O00150690114024178F1603053O0021507EE078030B3O004973417661696C61626C6503073O0054696D65546F58030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O66025O0050A340025O006AA940030F3O00536861646F77576F72644465617468031E3O00FFA002C053FB9714CB4EE89707C15DF8A043971CFFA00CD648D3BB00CB4A03053O003C8CC863A4025O00509840025O00F0A84003093O00AAFD0A22A586F9013503053O00C2E794644603093O004D696E6467616D6573025O00A7B240025O00D0964003163O004B45CFA7F1C94B49D2E3A4885544CEB1E2F7554FCEB503063O00A8262CA1C39603093O00FB88F14DFDDA80EC5D03053O00BFB6E19F2903093O000E0A385C8A93CB241C03073O00A24B724835EBE703093O004D696E64426C61737403173O0081354AE66C00803D57F61353CC2F4CED4116B32F47ED4503063O0062EC5C24823303093O00891002BE42A9B835B703083O0050C4796CDA25C8D503143O00337B036B5F0B980577327A590D8F10670B70451D03073O00EA6013621F2B6E03163O000B165CC3AB7386030C1296EC6183090D46F8BF71841003073O00EB667F32A7CC12026O001040030D3O00546172676574497356616C6964026O003E40030A3O0048616C6F506C61796572026O00384003113O0088FD8E7970BBF60588F390620FFBB5199603083O0076E09CE2165088D603093O006FE7578460E258935603043O00E0228E39025O00B07F40025O00ECAA4003173O00D3AECBD94CF3510FCDB3858F33E25501CCB3FACE70FE4B03083O006EBEC7A5BD13913D03133O004973466163696E67426C61636B6C6973746564025O0098A940025O001EA14003103O00446976696E6553746172506C6179657203183O00DEE261E185C2E5F863E9998789AB64E084D5CED464EB84D103063O00A7BA8B1788EB030F3O0029BD890915A2BF0208B1AC081BA18003043O006D7AD5E8025O00E2AA40025O0080AA40031E3O00FDFFA334E1E09D27E1E5A60FEAF2A324E6B7F670FDFFAD22FAC8B1332OE103043O00508E97C2025O00388D40025O00608D40025O00149740025O0092A340030E3O00E8D92F582040F8DE38592156D5C503063O0037BBB14E3C4F03133O00536861646F77436F76656E616E74466F637573031A3O003EC65EEF49D8BF2EC149EE48CE8E398E4CE349DD9412DD5CE45003073O00E04DAE3F8B26AF03063O00B7425027974C03043O004EE42138025O0002B040025O00B6A040025O0080584003063O0053636869736D031A3O00DD76B3078AD941B10C93CB70B30D918E6DBA0C97DA41A1008AD803053O00E5AE1ED263025O004AA040025O0032A340025O00807D40025O005EA04003113O0013EC8A5EAD6C7908E58943F9022A18E29003073O00597B8DE6318D5D025O0034A940025O00BCAB40025O00207840025O00888C4003183O00F778E0051E4FCC62E20D020AA231E5041F58E74EE50F1F5C03063O002A9311966C70025O00BBB240025O003C9140030E3O003FB33F78E2DC07A31A76E4E30AA203063O00886FC64D1F8703113O00446562752O665265667265736861626C6503143O0050757267655468655769636B6564446562752O6603093O0054696D65546F44696503143O00321CB551B8D01FAC3500A45DB8E033AC001CA15003083O00C96269C736DD8477030C3O00426173654475726174696F6E026O33D33F025O0014B340025O0040B240025O00B9B140025O006AA740030E3O0050757267655468655769636B6564031B3O00A9199126070AB8B109BC360B36A7BC08C3320A3ABEAD3390220D2303073O00CCD96CE3416255030F3O006DCBF4E123D769CCE7E108C55FD7FD03063O00A03EA395854C03103O004865616C746850657263656E7461676503093O00F3B81D262OC2A9022103053O00A3B6C06D4F031E3O00272E01C4FA231917CFE7301904C5F4202E4091B5272E0FD2E10B3503CFE303053O0095544660A003323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66025O00608A40025O00E6B14003123O00282O03EC360508AD2B0E02FF2C391EEE371003043O008D58666D030C3O0053686F756C6452657475726E025O00C2B240025O0095B240025O00A2B14003123O00A356C471143E5081A05BC5620E0246C2BC4503083O00A1D333AA107A5D35025O005EB140025O006CB14003113O00F3AFBE27BBFCF23BF3A1A03CC4BDB127ED03043O00489BCED203183O00427342073D4345471A32543A064E204E75461A0C55795B1803053O0053261A346E030F3O006B1F2642570010494A13034359032F03043O0026387747025O00588240031E3O00E0E759D22A41CCF857C42169F7EA59C22D16A1AF4BDE2A44E7D04BD52A4003063O0036938F38B645007F032O00121F3O00014O00AA000100013O0026BB3O0002000100010004473O0002000100121F000100013O002E150002009A000100030004473O009A00010026BB0001009A000100040004473O009A00012O007600026O00CC000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O0002000200020006B200020015000100010004473O00150001002EC800090029000100080004473O00290001002EC8000A00290001000B0004473O002900012O0076000200024O009000035O00202O00030003000C4O000400033O00202O00040004000D4O00065O00202O00060006000C4O0004000600024O000400046O000500016O00020005000200062O0002002900013O0004473O002900012O0076000200013O00121F0003000E3O00121F0004000F4O0012000200044O007100026O007600026O00CC000300013O00122O000400103O00122O000500116O0003000500024O00020002000300202O0002000200074O0002000200020006B200020035000100010004473O00350001002E0C01120015000100130004473O00480001002E0C01140013000100140004473O004800012O0076000200024O003C01035O00202O0003000300154O000400033O00202O00040004000D4O00065O00202O0006000600154O0004000600024O000400046O00020004000200062O0002004800013O0004473O004800012O0076000200013O00121F000300163O00121F000400174O0012000200044O007100026O007600026O0053010300013O00122O000400183O00122O000500196O0003000500024O00020002000300202O0002000200074O00020002000200062O0002005C00013O0004473O005C00012O0076000200043O00209500020002001A4O00045O00202O00040004001B4O00020004000200262O0002005C0001001C0004473O005C00012O0076000200053O000E4F011D005E000100020004473O005E0001002E15001F00790001001E0004473O007900012O0076000200024O004E01035O00202O0003000300204O000400033O00202O00040004002100122O000600226O00040006000200062O0004006D000100010004473O006D00012O0076000400063O00207D00040004002100122O000600226O0004000600024O000400043O00044O006F00012O002400046O00FC000400014O00DF0002000400020006B200020074000100010004473O00740001002EC800230079000100240004473O007900012O0076000200013O00121F000300253O00121F000400264O0012000200044O007100026O007600026O00CC000300013O00122O000400273O00122O000500286O0003000500024O00020002000300202O0002000200074O0002000200020006B200020085000100010004473O00850001002E150029007E0301002A0004473O007E0301002E15002C007E0301002B0004473O007E03012O0076000200024O009000035O00202O00030003002D4O000400033O00202O00040004000D4O00065O00202O00060006002D4O0004000600024O000400046O000500016O00020005000200062O0002007E03013O0004473O007E03012O0076000200013O0012400103002E3O00122O0004002F6O000200046O00025O00044O007E03010026BB000100462O0100300004473O00462O0100121F000200013O0026BB000200F2000100310004473O00F200012O007600036O0053010400013O00122O000500323O00122O000600336O0004000600024O00030003000400202O0003000300074O00030002000200062O000300D100013O0004473O00D100012O007600036O0053010400013O00122O000500343O00122O000600356O0004000600024O00030003000400202O0003000300364O00030002000200062O000300D100013O0004473O00D100012O0076000300033O0020E900030003003700122O0005001C6O0003000500024O000400043O00202O0004000400384O00065O00202O0006000600394O00040006000200062O000400D1000100030004473O00D10001002E15003A00D10001003B0004473O00D100012O0076000300024O003C01045O00202O00040004003C4O000500033O00202O00050005000D4O00075O00202O00070007003C4O0005000700024O000500056O00030005000200062O000300D100013O0004473O00D100012O0076000300013O00121F0004003D3O00121F0005003E4O0012000300054O007100035O002EC8003F00F1000100400004473O00F100012O007600036O0053010400013O00122O000500413O00122O000600426O0004000600024O00030003000400202O0003000300074O00030002000200062O000300F100013O0004473O00F100012O0076000300024O006A00045O00202O0004000400434O000500033O00202O00050005000D4O00075O00202O0007000700434O0005000700024O000500056O000600016O00030006000200062O000300EC000100010004473O00EC0001002EC8004400F1000100450004473O00F100012O0076000300013O00121F000400463O00121F000500474O0012000300054O007100035O00121F0002001D3O000E17000100412O0100020004473O00412O012O007600036O0053010400013O00122O000500483O00122O000600496O0004000600024O00030003000400202O0003000300074O00030002000200062O0003001A2O013O0004473O001A2O012O007600036O0053010400013O00122O0005004A3O00122O0006004B6O0004000600024O00030003000400202O0003000300364O00030002000200062O0003001A2O013O0004473O001A2O012O0076000300024O009000045O00202O00040004004C4O000500033O00202O00050005000D4O00075O00202O00070007004C4O0005000700024O000500056O000600016O00030006000200062O0003001A2O013O0004473O001A2O012O0076000300013O00121F0004004D3O00121F0005004E4O0012000300054O007100036O007600036O0053010400013O00122O0005004F3O00122O000600506O0004000600024O00030003000400202O0003000300074O00030002000200062O000300402O013O0004473O00402O012O007600036O0053010400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300364O00030002000200062O000300402O013O0004473O00402O012O0076000300024O009000045O00202O0004000400434O000500033O00202O00050005000D4O00075O00202O0007000700434O0005000700024O000500056O000600016O00030006000200062O000300402O013O0004473O00402O012O0076000300013O00121F000400533O00121F000500544O0012000300054O007100035O00121F000200313O0026BB0002009D0001001D0004473O009D000100121F000100553O0004473O00462O010004473O009D00010026BB000100D72O0100550004473O00D72O012O0076000200073O0020530002000200072O0042010200020002000699000200692O013O0004473O00692O012O0076000200083O00204B0002000200562O001C010200010002000699000200692O013O0004473O00692O012O0076000200033O00205300020002002100121F000400574O00DF000200040002000699000200692O013O0004473O00692O012O0076000200024O000A010300093O00202O0003000300584O000400033O00202O00040004002100122O000600596O0004000600024O000400046O000500016O00020005000200062O000200692O013O0004473O00692O012O0076000200013O00121F0003005A3O00121F0004005B4O0012000200044O007100026O007600026O00CC000300013O00122O0004005C3O00122O0005005D6O0003000500024O00020002000300202O0002000200074O0002000200020006B2000200752O0100010004473O00752O01002E15005F00872O01005E0004473O00872O012O0076000200024O009000035O00202O00030003004C4O000400033O00202O00040004000D4O00065O00202O00060006004C4O0004000600024O000400046O000500016O00020005000200062O000200872O013O0004473O00872O012O0076000200013O00121F000300603O00121F000400614O0012000200044O007100026O00760002000A3O0020530002000200072O00420102000200020006990002009C2O013O0004473O009C2O012O0076000200083O00204B0002000200562O001C0102000100020006990002009C2O013O0004473O009C2O012O0076000200033O00205300020002002100121F000400574O00DF0002000400020006990002009C2O013O0004473O009C2O012O0076000200033O0020530002000200622O00420102000200020006990002009E2O013O0004473O009E2O01002EC8006300AE2O0100640004473O00AE2O012O0076000200024O0085000300093O00202O0003000300654O000400033O00202O00040004002100122O000600596O0004000600024O000400046O00020004000200062O000200AE2O013O0004473O00AE2O012O0076000200013O00121F000300663O00121F000400674O0012000200044O007100026O007600026O0053010300013O00122O000400683O00122O000500696O0003000500024O00020002000300202O0002000200074O00020002000200062O000200C32O013O0004473O00C32O012O0076000200033O00200001020002003700122O0004001C6O0002000400024O000300043O00202O0003000300384O00055O00202O0005000500394O00030005000200062O000300C52O0100020004473O00C52O01002E15006A00D62O01006B0004473O00D62O012O0076000200024O003C01035O00202O00030003003C4O000400033O00202O00040004000D4O00065O00202O00060006003C4O0004000600024O000400046O00020004000200062O000200D62O013O0004473O00D62O012O0076000200013O00121F0003006C3O00121F0004006D4O0012000200044O007100025O00121F000100043O0026BB00010075020100010004473O0075020100121F000200013O002EC8006E00E02O01006F0004473O00E02O010026BB000200E02O01001D0004473O00E02O0100121F000100313O0004473O007502010026BB0002001D020100010004473O001D0201002EC8007000FC2O0100710004473O00FC2O012O007600036O0053010400013O00122O000500723O00122O000600736O0004000600024O00030003000400202O0003000300074O00030002000200062O000300FC2O013O0004473O00FC2O012O0076000300063O000699000300FC2O013O0004473O00FC2O012O0076000300024O0076000400093O00204B0004000400742O0042010300020002000699000300FC2O013O0004473O00FC2O012O0076000300013O00121F000400753O00121F000500764O0012000300054O007100036O007600036O00CC000400013O00122O000500773O00122O000600786O0004000600024O00030003000400202O0003000300074O0003000200020006B200030008020100010004473O00080201002EC80079001C0201007A0004473O001C0201002E0C017B00140001007B0004473O001C02012O0076000300024O009000045O00202O00040004007C4O000500033O00202O00050005000D4O00075O00202O00070007007C4O0005000700024O000500056O000600016O00030006000200062O0003001C02013O0004473O001C02012O0076000300013O00121F0004007D3O00121F0005007E4O0012000300054O007100035O00121F000200313O000E17003100DA2O0100020004473O00DA2O012O0076000300073O0020530003000300072O00420103000200020006990003003202013O0004473O003202012O0076000300083O00204B0003000300562O001C0103000100020006990003003202013O0004473O003202012O0076000300033O00205300030003002100121F000500574O00DF0003000500020006990003003202013O0004473O003202012O00760003000B3O000EF200310034020100030004473O00340201002E0C017F0015000100800004473O00470201002EC800810047020100820004473O004702012O0076000300024O000A010400093O00202O0004000400584O000500033O00202O00050005002100122O000700596O0005000700024O000500056O000600016O00030006000200062O0003004702013O0004473O004702012O0076000300013O00121F000400833O00121F000500844O0012000300054O007100035O002EC800850073020100860004473O007302012O00760003000A3O0020530003000300072O00420103000200020006990003007302013O0004473O007302012O0076000300083O00204B0003000300562O001C0103000100020006990003007302013O0004473O007302012O0076000300033O00205300030003002100121F000500574O00DF0003000500020006990003007302013O0004473O007302012O0076000300033O0020530003000300622O00420103000200020006B200030073020100010004473O007302012O00760003000B3O000ED400310073020100030004473O007302012O0076000300024O006B000400093O00202O0004000400654O000500033O00202O00050005002100122O000700596O0005000700024O000500056O00030005000200062O0003006E020100010004473O006E0201002EC800880073020100870004473O007302012O0076000300013O00121F000400893O00121F0005008A4O0012000300054O007100035O00121F0002001D3O0004473O00DA2O010026AB00010079020100310004473O00790201002EC8008B00FC0201008C0004473O00FC02012O007600026O0053010300013O00122O0004008D3O00122O0005008E6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002009802013O0004473O009802012O0076000200033O00203901020002008F4O00045O00202O0004000400904O00020004000200062O0002009802013O0004473O009802012O0076000200033O0020530002000200912O00420102000200022O007600036O00CC000400013O00122O000500923O00122O000600936O0004000600024O00030003000400202O0003000300944O0003000200020010D80003009500030006220103009A020100020004473O009A0201002E15009600AD020100970004473O00AD0201002E15009900AD020100980004473O00AD02012O0076000200024O003C01035O00202O00030003009A4O000400033O00202O00040004000D4O00065O00202O00060006009A4O0004000600024O000400046O00020004000200062O000200AD02013O0004473O00AD02012O0076000200013O00121F0003009B3O00121F0004009C4O0012000200044O007100026O007600026O0053010300013O00122O0004009D3O00122O0005009E6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200D702013O0004473O00D702012O0076000200033O00205300020002009F2O004201020002000200262C000200D70201001C0004473O00D702012O007600026O0053010300013O00122O000400A03O00122O000500A16O0003000500024O00020002000300202O0002000200364O00020002000200062O000200D702013O0004473O00D702012O0076000200024O003C01035O00202O00030003003C4O000400033O00202O00040004000D4O00065O00202O00060006003C4O0004000600024O000400046O00020004000200062O000200D702013O0004473O00D702012O0076000200013O00121F000300A23O00121F000400A34O0012000200044O007100026O00760002000C3O0020530002000200072O0042010200020002000699000200F802013O0004473O00F802012O0076000200083O00202A0102000200A44O00035O00202O0003000300A54O0004000D6O00058O00068O0002000600024O0003000E3O00062O000200F8020100030004473O00F802012O0076000200024O00BC0003000C6O000400033O00202O00040004000D4O0006000C6O0004000600024O000400046O00020004000200062O000200F3020100010004473O00F30201002E1500A700F8020100A60004473O00F802012O0076000200013O00121F000300A83O00121F000400A94O0012000200044O007100026O00760002000F4O001C01020001000200121A000200AA3O00121F0001001D3O002E0C01AB0009FD2O00AB0004473O000500010026BB000100050001001D0004473O00050001002E1500AD000A030100AC0004473O000A030100123A010200AA3O0006990002000A03013O0004473O000A03012O0076000200013O00121F000300AE3O00121F000400AF4O0012000200044O007100025O002E1500B00030030100B10004473O003003012O0076000200073O0020530002000200072O00420102000200020006990002003003013O0004473O003003012O0076000200083O00204B0002000200562O001C0102000100020006990002003003013O0004473O003003012O0076000200033O00205300020002002100121F000400574O00DF0002000400020006990002003003013O0004473O003003012O00760002000B3O000ED400310030030100020004473O003003012O0076000200024O000A010300093O00202O0003000300584O000400033O00202O00040004002100122O000600596O0004000600024O000400046O000500016O00020005000200062O0002003003013O0004473O003003012O0076000200013O00121F000300B23O00121F000400B34O0012000200044O007100026O00760002000A3O0020530002000200072O00420102000200020006990002005803013O0004473O005803012O0076000200083O00204B0002000200562O001C0102000100020006990002005803013O0004473O005803012O0076000200033O00205300020002002100121F000400574O00DF0002000400020006990002005803013O0004473O005803012O0076000200033O0020530002000200622O00420102000200020006B200020058030100010004473O005803012O00760002000B3O000ED400310058030100020004473O005803012O0076000200024O0085000300093O00202O0003000300654O000400033O00202O00040004002100122O000600596O0004000600024O000400046O00020004000200062O0002005803013O0004473O005803012O0076000200013O00121F000300B43O00121F000400B54O0012000200044O007100026O007600026O0053010300013O00122O000400B63O00122O000500B76O0003000500024O00020002000300202O0002000200074O00020002000200062O0002007A03013O0004473O007A03012O0076000200033O00205300020002009F2O004201020002000200262C0002007A0301001C0004473O007A0301002E1500B8007A030100A60004473O007A03012O0076000200024O003C01035O00202O00030003003C4O000400033O00202O00040004000D4O00065O00202O00060006003C4O0004000600024O000400046O00020004000200062O0002007A03013O0004473O007A03012O0076000200013O00121F000300B93O00121F000400BA4O0012000200044O007100025O00121F000100303O0004473O000500010004473O007E03010004473O000200012O00D23O00017O00EA3O00028O00025O00507D40025O00C06C40025O00C2A340025O00FAA840026O00104003073O0049735265616479030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40025O00405140025O0022A640030A3O0048616C6F506C61796572026O00384003103O008AD0AD82F9D7C2DDAE83BEBB91D2AE9B03063O00E4E2B1C1EDD9025O00F0A140025O007CB14003133O004973466163696E67426C61636B6C697374656403103O00446976696E6553746172506C6179657203173O0030B935EF3AB51CF520B131A667F02FE93AB71CF537BF3503043O008654D043030F3O0020A487581CBBB15301A8A25912B88E03043O003C73CCE603073O0054696D65546F58026O003440030B3O0042752O6652656D61696E7303123O00536861646F77436F76656E616E7442752O66025O005AAF40025O0040AA40030F3O00536861646F77576F72644465617468030E3O0049735370652O6C496E52616E6765025O00809540025O0010B240031D3O00F432EA74E82DD467E828EF4FE33FEA64EF7ABF30EB35E577D829E87FF103043O0010875A8B025O00F07340025O00889A40030B3O00787D013B5A474F4675123B03073O0018341466532E34030B3O004C69676874735772617468025O0036B240025O0087B34003163O00C82O262C1BD7102O360ED027612800CA281E370CCB3903053O006FA44F4144026O001440026O001C40025O006AAE40025O0054A840030F3O00294A22A7305ED201084607A63E5DED03083O006E7A2243C35F2985025O0031B240025O00789040031D3O0066B95A4ED9628E4C45C4718E5F4FD761B91B199679BE554DE966B2545C03053O00B615D13B2A025O00808640025O00E8A040025O00E88240025O0002B04003173O00B35ED3142FBB8844D11C33FEE317C9122FB98844C6123703063O00DED737A57D41025O00107540025O001C9C4003103O0024D0CA15B295AD4623DFC125E1C2E25C03083O002A4CB1A67A92A18D030F3O00958512CB6B41AA9801FD767AA4890003063O0016C5EA65AE19030F3O00506F776572576F7264536F6C616365031D3O003D3BB2D96490C0893F309ACF79A3D6852874F79C7AA0D9811227A6D36003083O00E64D54C5BC16CFB7026O002040027O0040025O00A49040025O0008A240026O00F03F025O004C9540025O002BB04003103O00A6EEB1B3EEBDFDB0A1E1BA83BDECB2AA03043O00DCCE8FDD025O00FAA040025O00A88F4003173O0082743B1ED6C9ED95692C05989E928A722310E7DFD1896B03073O00B2E61D4D77B8AC030F3O00C6B60B1F78EFC2B1181F53FDF4AA0203063O009895DE6A7B1703103O004865616C746850657263656E74616765031D3O00CE2EF747BACA19E14CA7D919F246B4C92EB611F5D129F8448ACE25F95503053O00D5BD46962303093O00625C7A0C6D59751B5B03043O00682F351403093O0086549115BD1BAA438F03063O006FC32CE17CDC030B3O004973417661696C61626C6503093O004D696E64426C61737403163O00D54F0E7794A9D4471367EBFA984A0F7DAC94CB450F6503063O00CBB8266013CB026O000840030E3O006B159F0C203B19AE6C098E00200B03083O00CB3B60ED6B456F7103113O00446562752O665265667265736861626C6503143O0050757267655468655769636B6564446562752O6603093O0054696D65546F44696503143O001403BEE634C4DF2O21A5E23AF5D30013AEF437F603073O00B74476CC815190030C3O00426173654475726174696F6E026O33D33F025O00DAB040025O00408040030E3O0050757267655468655769636B6564031A3O001EB862E30EBD1AA575DB1C8B0DA675E04B8E01A377DB188101BB03063O00E26ECD10846B025O00049A40025O0060AF40030F3O00D8CBE1DD4EFCF4EFCB45CFC6E1CD4903053O00218BA380B903093O00724014D7564C0DD15903043O00BE373864031D3O0045A73D1A1CF4CC41A02E1A2CE7F657BB345E42A3FF59A13B2100E0FC4003073O009336CF5C7E738303323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66025O00089140025O0044A94003123O001D343B7C037D08712675026C190E267E026803063O001E6D51551D6D03063O0042752O665570030F3O0048617273684469736369706C696E65030C3O0053686F756C6452657475726E025O00B4A04003133O00EF745AB738DDF9BF2014BA39D0FBC06257B92003073O009C9F1134D656BE026O001840025O0026A140025O00A2A34003053O00E98456160903063O008DBAE93F626C025O00A6A740025O00BAB04003053O00536D69746503113O00E2E725A220B1BB6CBA2AFFED13A526FEFC03053O0045918A4CD603083O0058C08590911966CE03063O007610AF2OE9DF03093O0042752O66537461636B030C3O0052686170736F647942752O6603083O00486F6C794E6F7661026O00284003153O00838B39A2D185729D8575EAAE877285830AA8ED846B03073O001DEBE455DB8EEB03093O0010DDB4D9704F2A572E03083O00325DB4DABD172E4703093O004D696E6467616D657303153O00D3AD554843DD45DBB71B1F04D047D0A3645F47D35E03073O0028BEC43B2C24BC03093O00114CD2B0D8710C2F5103073O006D5C25BCD49A1D025O0006AA40025O00509D4003163O0009E6AAC70E5808EEB7D7710844E3ABCD366517ECABD503063O003A648FC4A351025O00BCA740025O00D4A940030E3O0098CB4A424C5D1842BDC645474D5E03083O002DCBA32B26232A5B03133O00536861646F77436F76656E616E74466F637573025O00C09440025O0018824003193O00C18DDD2788BE6BD18ACA2689A85AC6C5D02C89AE6BC186D33503073O0034B2E5BC43E7C903063O001242580DE45103073O004341213064973C025O00406E40025O00249C4003063O0053636869736D03193O00CCEFAFDCFCC8D8ADD7E5DAE9AFD6E79FEBA1D6F4E0F4ADD7E503053O0093BF87CEB8025O003CA540025O0088B24003103O008C29AACE9802F28827A8C6E740B18B3E03073O00D2E448C6A1B833025O00088240025O005EA34003173O003240E5197DCB095AE711618E6709FF1F7DC9095AF01F6503063O00AE562993701303083O00D11BCAE5A2AEE63403083O00559974A69CECC19003153O00ACEF41AADB0EABF64CF3B640A8EF43B4DB13A7EF5B03063O0060C4802DD38403053O000680724BD703083O00B855ED1B3FB2CFD4025O00689F40025O0082AD40025O0068A440025O00488A4003113O001B54004B0D195B1F04560758374A0A501E03043O003F683969025O000CA140025O00E0994003093O00147A7745C9387E7C5203053O00AE5913192103143O001C1A535AE382192A16624BE5840E3F065B41F99403073O006B4F72322E97E7025O00588540025O00B0A04003153O0034AFBB2D8D38BAC52AE6E4698636B9C706B5B6269C03083O00A059C6D549EA59D7030F3O007B79B5FACA5F46BBECC16C74B5EACD03053O00A52811D49E03093O00C0C1183A27F1D0073D03053O004685B96853025O001CB240025O0072A440025O007FB240031D3O00174D452EC6137A5325DB007A402FC8104D047989082O4A2DF617464B3C03053O00A96425244A025O00F88440025O00A8A34003093O002D8EAC540786AF551303043O003060E7C203153O00C55300291ED9A286DB1A5C6D15D7A184F7490D220F03083O00E3A83A6E4D79B8CF03093O005635B14493D770B66F03083O00C51B5CDF20D1BB1103163O000E56CDFF3C5DCFFA104B83A94353CCF50460D0F80C4903043O009B633FA303133O00E6F3770088DFF3B62B418AD3F8F1461285D3E003063O00BC2O961961E6030F3O00F6D694DB3CDDC9CB87ED21E6C7DA8603063O008AA6B9E3BE4E031D3O00DB7BD232401C0EC466C108412C15CA77C077036315C47AC208412016DD03073O0079AB14A5573243025O00F8834003123O00D63DB737B701C378AA3EB610D207AA35B61403063O0062A658D956D900A5052O00121F3O00014O00AA000100013O002E1500030002000100020004473O000200010026BB3O0002000100010004473O0002000100121F000100013O002EC8000400CC000100050004473O00CC00010026BB000100CC000100060004473O00CC00012O007600025O0020530002000200072O00420102000200020006990002002600013O0004473O002600012O0076000200013O00204B0002000200082O001C0102000100020006990002002600013O0004473O002600012O0076000200023O00205300020002000900121F0004000A4O00DF0002000400020006990002002600013O0004473O002600012O0076000200034O001C0102000100020006990002002800013O0004473O002800012O0076000200034O001C0102000100020006990002002600013O0004473O002600012O0076000200043O0006B200020028000100010004473O00280001002E15000C00390001000B0004473O003900012O0076000200054O000A010300063O00202O00030003000D4O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O000500016O00020005000200062O0002003900013O0004473O003900012O0076000200073O00121F0003000F3O00121F000400104O0012000200044O007100025O002EC80011006B000100120004473O006B00012O0076000200083O0020530002000200072O00420102000200020006990002006B00013O0004473O006B00012O0076000200013O00204B0002000200082O001C0102000100020006990002006B00013O0004473O006B00012O0076000200023O00205300020002000900121F0004000A4O00DF0002000400020006990002006B00013O0004473O006B00012O0076000200023O0020530002000200132O00420102000200020006B20002006B000100010004473O006B00012O0076000200034O001C0102000100020006990002005B00013O0004473O005B00012O0076000200034O001C0102000100020006990002006B00013O0004473O006B00012O0076000200043O0006990002006B00013O0004473O006B00012O0076000200054O0085000300063O00202O0003000300144O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O00020004000200062O0002006B00013O0004473O006B00012O0076000200073O00121F000300153O00121F000400164O0012000200044O007100026O0076000200094O0053010300073O00122O000400173O00122O000500186O0003000500024O00020002000300202O0002000200074O00020002000200062O0002008B00013O0004473O008B00012O0076000200034O001C0102000100020006990002008000013O0004473O008000012O0076000200034O001C0102000100020006990002008B00013O0004473O008B00012O0076000200043O0006990002008B00013O0004473O008B00012O0076000200023O00200001020002001900122O0004001A6O0002000400024O0003000A3O00202O00030003001B4O000500093O00202O00050005001C4O00030005000200062O0003008D000100020004473O008D0001002EC8001D00A00001001E0004473O00A000012O0076000200054O0096000300093O00202O00030003001F4O000400023O00202O0004000400204O000600093O00202O00060006001F4O0004000600024O000400046O00020004000200062O0002009B000100010004473O009B0001002E15002200A0000100210004473O00A000012O0076000200073O00121F000300233O00121F000400244O0012000200044O007100025O002E15002500CB000100260004473O00CB00012O0076000200094O0053010300073O00122O000400273O00122O000500286O0003000500024O00020002000300202O0002000200074O00020002000200062O000200CB00013O0004473O00CB00012O0076000200034O001C010200010002000699000200B700013O0004473O00B700012O0076000200034O001C010200010002000699000200CB00013O0004473O00CB00012O00760002000B3O000699000200CB00013O0004473O00CB00012O0076000200054O006A000300093O00202O0003000300294O000400023O00202O0004000400204O000600093O00202O0006000600294O0004000600024O000400046O000500016O00020005000200062O000200C6000100010004473O00C60001002EC8002B00CB0001002A0004473O00CB00012O0076000200073O00121F0003002C3O00121F0004002D4O0012000200044O007100025O00121F0001002E3O000E62002F00D0000100010004473O00D00001002E15003000552O0100310004473O00552O012O0076000200094O0053010300073O00122O000400323O00122O000500336O0003000500024O00020002000300202O0002000200074O00020002000200062O000200ED00013O0004473O00ED0001002E15003500ED000100340004473O00ED00012O0076000200054O003C010300093O00202O00030003001F4O000400023O00202O0004000400204O000600093O00202O00060006001F4O0004000600024O000400046O00020004000200062O000200ED00013O0004473O00ED00012O0076000200073O00121F000300363O00121F000400374O0012000200044O007100026O0076000200083O0020530002000200072O0042010200020002000699000200022O013O0004473O00022O012O0076000200013O00204B0002000200082O001C010200010002000699000200022O013O0004473O00022O012O0076000200023O00205300020002000900121F0004000A4O00DF000200040002000699000200022O013O0004473O00022O012O0076000200023O0020530002000200132O0042010200020002000699000200042O013O0004473O00042O01002E15003900162O0100380004473O00162O01002EC8003A00162O01003B0004473O00162O012O0076000200054O0085000300063O00202O0003000300144O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O00020004000200062O000200162O013O0004473O00162O012O0076000200073O00121F0003003C3O00121F0004003D4O0012000200044O007100026O007600025O0020530002000200072O0042010200020002000699000200392O013O0004473O00392O012O0076000200013O00204B0002000200082O001C010200010002000699000200392O013O0004473O00392O012O0076000200023O00205300020002000900121F0004000A4O00DF000200040002000699000200392O013O0004473O00392O01002EC8003E00392O01003F0004473O00392O012O0076000200054O000A010300063O00202O00030003000D4O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O000500016O00020005000200062O000200392O013O0004473O00392O012O0076000200073O00121F000300403O00121F000400414O0012000200044O007100026O0076000200094O0053010300073O00122O000400423O00122O000500436O0003000500024O00020002000300202O0002000200074O00020002000200062O000200542O013O0004473O00542O012O0076000200054O003C010300093O00202O0003000300444O000400023O00202O0004000400204O000600093O00202O0006000600444O0004000600024O000400046O00020004000200062O000200542O013O0004473O00542O012O0076000200073O00121F000300453O00121F000400464O0012000200044O007100025O00121F000100473O0026BB0001001C020100480004473O001C0201002EC80049008A2O01004A0004473O008A2O012O007600025O0020530002000200072O00420102000200020006990002008A2O013O0004473O008A2O012O0076000200013O00204B0002000200082O001C0102000100020006990002008A2O013O0004473O008A2O012O0076000200023O00205300020002000900121F0004000A4O00DF0002000400020006990002008A2O013O0004473O008A2O012O0076000200034O001C010200010002000699000200742O013O0004473O00742O012O0076000200034O001C0102000100020006990002008A2O013O0004473O008A2O012O0076000200043O0006990002008A2O013O0004473O008A2O012O00760002000C3O000ED4004B008A2O0100020004473O008A2O01002EC8004C008A2O01004D0004473O008A2O012O0076000200054O000A010300063O00202O00030003000D4O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O000500016O00020005000200062O0002008A2O013O0004473O008A2O012O0076000200073O00121F0003004E3O00121F0004004F4O0012000200044O007100026O0076000200083O0020530002000200072O0042010200020002000699000200BF2O013O0004473O00BF2O012O0076000200013O00204B0002000200082O001C010200010002000699000200BF2O013O0004473O00BF2O012O0076000200023O00205300020002000900121F0004000A4O00DF000200040002000699000200BF2O013O0004473O00BF2O012O0076000200023O0020530002000200132O00420102000200020006B2000200BF2O0100010004473O00BF2O012O0076000200034O001C010200010002000699000200AA2O013O0004473O00AA2O012O0076000200034O001C010200010002000699000200BF2O013O0004473O00BF2O012O0076000200043O000699000200BF2O013O0004473O00BF2O012O00760002000C3O000ED4004B00BF2O0100020004473O00BF2O012O0076000200054O006B000300063O00202O0003000300144O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O00020004000200062O000200BA2O0100010004473O00BA2O01002EC8005000BF2O0100510004473O00BF2O012O0076000200073O00121F000300523O00121F000400534O0012000200044O007100026O0076000200094O0053010300073O00122O000400543O00122O000500556O0003000500024O00020002000300202O0002000200074O00020002000200062O000200EA2O013O0004473O00EA2O012O0076000200023O0020530002000200562O004201020002000200262C000200EA2O01001A0004473O00EA2O012O0076000200034O001C010200010002000699000200D92O013O0004473O00D92O012O0076000200034O001C010200010002000699000200EA2O013O0004473O00EA2O012O0076000200043O000699000200EA2O013O0004473O00EA2O012O0076000200054O003C010300093O00202O00030003001F4O000400023O00202O0004000400204O000600093O00202O00060006001F4O0004000600024O000400046O00020004000200062O000200EA2O013O0004473O00EA2O012O0076000200073O00121F000300573O00121F000400584O0012000200044O007100026O0076000200094O0053010300073O00122O000400593O00122O0005005A6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001B02013O0004473O001B02012O0076000200094O0053010300073O00122O0004005B3O00122O0005005C6O0003000500024O00020002000300202O00020002005D4O00020002000200062O0002001B02013O0004473O001B02012O0076000200034O001C0102000100020006990002000902013O0004473O000902012O0076000200034O001C0102000100020006990002001B02013O0004473O001B02012O0076000200043O0006990002001B02013O0004473O001B02012O0076000200054O0090000300093O00202O00030003005E4O000400023O00202O0004000400204O000600093O00202O00060006005E4O0004000600024O000400046O000500016O00020005000200062O0002001B02013O0004473O001B02012O0076000200073O00121F0003005F3O00121F000400604O0012000200044O007100025O00121F000100613O0026BB000100E70201004B0004473O00E702012O0076000200094O0053010300073O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004802013O0004473O004802012O0076000200034O001C0102000100020006990002003302013O0004473O003302012O0076000200034O001C0102000100020006990002004802013O0004473O004802012O00760002000B3O0006990002004802013O0004473O004802012O0076000200023O0020390102000200644O000400093O00202O0004000400654O00020004000200062O0002004802013O0004473O004802012O0076000200023O0020530002000200662O00420102000200022O0076000300094O00CC000400073O00122O000500673O00122O000600686O0004000600024O00030003000400202O0003000300694O0003000200020010D80003006A00030006220103004A020100020004473O004A0201002E15006B005B0201006C0004473O005B02012O0076000200054O003C010300093O00202O00030003006D4O000400023O00202O0004000400204O000600093O00202O00060006006D4O0004000600024O000400046O00020004000200062O0002005B02013O0004473O005B02012O0076000200073O00121F0003006E3O00121F0004006F4O0012000200044O007100025O002E1500700092020100710004473O009202012O0076000200094O0053010300073O00122O000400723O00122O000500736O0003000500024O00020002000300202O0002000200074O00020002000200062O0002009202013O0004473O009202012O0076000200023O0020530002000200562O004201020002000200262C000200920201001A0004473O009202012O0076000200094O0053010300073O00122O000400743O00122O000500756O0003000500024O00020002000300202O00020002005D4O00020002000200062O0002009202013O0004473O009202012O0076000200034O001C0102000100020006990002008102013O0004473O008102012O0076000200034O001C0102000100020006990002009202013O0004473O009202012O0076000200043O0006990002009202013O0004473O009202012O0076000200054O003C010300093O00202O00030003001F4O000400023O00202O0004000400204O000600093O00202O00060006001F4O0004000600024O000400046O00020004000200062O0002009202013O0004473O009202012O0076000200073O00121F000300763O00121F000400774O0012000200044O007100026O00760002000D3O0020530002000200072O0042010200020002000699000200B302013O0004473O00B302012O0076000200013O00202A0102000200784O000300093O00202O0003000300794O0004000E6O00058O00068O0002000600024O0003000F3O00062O000200B3020100030004473O00B302012O0076000200054O00BC0003000D6O000400023O00202O0004000400204O0006000D6O0004000600024O000400046O00020004000200062O000200AE020100010004473O00AE0201002EC8007B00B30201007A0004473O00B302012O0076000200073O00121F0003007C3O00121F0004007D4O0012000200044O007100026O0076000200034O001C010200010002000699000200BE02013O0004473O00BE02012O0076000200034O001C010200010002000699000200E602013O0004473O00E602012O0076000200043O000699000200E602013O0004473O00E602012O00760002000A3O00203901020002007E4O000400093O00202O00040004007F4O00020004000200062O000200E602013O0004473O00E6020100121F000200014O00AA000300043O0026BB000200CC020100010004473O00CC020100121F000300014O00AA000400043O00121F0002004B3O0026BB000200C70201004B0004473O00C70201000E17000100CE020100030004473O00CE020100121F000400013O0026BB000400D1020100010004473O00D102012O0076000500104O001C01050001000200121A000500803O002E0C01810010000100810004473O00E6020100123A010500803O000699000500E602013O0004473O00E602012O0076000500073O001240010600823O00122O000700836O000500076O00055O00044O00E602010004473O00D102010004473O00E602010004473O00CE02010004473O00E602010004473O00C7020100121F000100483O000E62008400EB020100010004473O00EB0201002EC800860087030100850004473O008703012O0076000200094O0053010300073O00122O000400873O00122O000500886O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001403013O0004473O001403012O0076000200034O001C01020001000200069900022O0003013O0004474O0003012O0076000200034O001C0102000100020006990002001403013O0004473O001403012O00760002000B3O0006990002001403013O0004473O00140301002EC8008900140301008A0004473O001403012O0076000200054O0090000300093O00202O00030003008B4O000400023O00202O0004000400204O000600093O00202O00060006008B4O0004000600024O000400046O000500016O00020005000200062O0002001403013O0004473O001403012O0076000200073O00121F0003008C3O00121F0004008D4O0012000200044O007100026O0076000200094O0053010300073O00122O0004008E3O00122O0005008F6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004C03013O0004473O004C03012O0076000200034O001C0102000100020006990002002903013O0004473O002903012O0076000200034O001C0102000100020006990002004C03013O0004473O004C03012O00760002000B3O0006990002004C03013O0004473O004C03012O00760002000A3O0020950002000200904O000400093O00202O0004000400914O00020004000200262O0002004C0301001A0004473O004C03012O0076000200113O000EAF0048004C030100020004473O004C03012O0076000200054O004E010300093O00202O0003000300924O000400023O00202O00040004000900122O000600936O00040006000200062O00040042030100010004473O004203012O0076000400123O00207D00040004000900122O000600936O0004000600024O000400043O00044O004403012O002400046O00FC000400014O00DF0002000400020006990002004C03013O0004473O004C03012O0076000200073O00121F000300943O00121F000400954O0012000200044O007100026O0076000200094O0053010300073O00122O000400963O00122O000500976O0003000500024O00020002000300202O0002000200074O00020002000200062O0002006803013O0004473O006803012O0076000200054O0090000300093O00202O0003000300984O000400023O00202O0004000400204O000600093O00202O0006000600984O0004000600024O000400046O000500016O00020005000200062O0002006803013O0004473O006803012O0076000200073O00121F000300993O00121F0004009A4O0012000200044O007100026O0076000200094O00CC000300073O00122O0004009B3O00122O0005009C6O0003000500024O00020002000300202O0002000200074O0002000200020006B200020074030100010004473O00740301002E15009D00860301009E0004473O008603012O0076000200054O0090000300093O00202O00030003005E4O000400023O00202O0004000400204O000600093O00202O00060006005E4O0004000600024O000400046O000500016O00020005000200062O0002008603013O0004473O008603012O0076000200073O00121F0003009F3O00121F000400A04O0012000200044O007100025O00121F0001002F3O002EC800A1002A040100A20004473O002A04010026BB0001002A040100010004473O002A04012O0076000200094O0053010300073O00122O000400A33O00122O000500A46O0003000500024O00020002000300202O0002000200074O00020002000200062O000200A503013O0004473O00A503012O0076000200123O000699000200A503013O0004473O00A503012O0076000200054O0076000300063O00204B0003000300A52O00420102000200020006B2000200A0030100010004473O00A00301002EC800A600A5030100A70004473O00A503012O0076000200073O00121F000300A83O00121F000400A94O0012000200044O007100026O0076000200094O00CC000300073O00122O000400AA3O00122O000500AB6O0003000500024O00020002000300202O0002000200074O0002000200020006B2000200B1030100010004473O00B10301002EC800AD00C3030100AC0004473O00C303012O0076000200054O0090000300093O00202O0003000300AE4O000400023O00202O0004000400204O000600093O00202O0006000600AE4O0004000600024O000400046O000500016O00020005000200062O000200C303013O0004473O00C303012O0076000200073O00121F000300AF3O00121F000400B04O0012000200044O007100026O007600025O0020530002000200072O0042010200020002000699000200F403013O0004473O00F403012O0076000200013O00204B0002000200082O001C010200010002000699000200F403013O0004473O00F403012O0076000200023O00205300020002000900121F0004000A4O00DF000200040002000699000200F403013O0004473O00F403012O0076000200034O001C010200010002000699000200DE03013O0004473O00DE03012O0076000200034O001C010200010002000699000200F403013O0004473O00F403012O0076000200043O000699000200F403013O0004473O00F403012O00760002000C3O000ED4004B00F4030100020004473O00F40301002E1500B100F4030100B20004473O00F403012O0076000200054O000A010300063O00202O00030003000D4O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O000500016O00020005000200062O000200F403013O0004473O00F403012O0076000200073O00121F000300B33O00121F000400B44O0012000200044O007100026O0076000200083O0020530002000200072O00420102000200020006990002002904013O0004473O002904012O0076000200013O00204B0002000200082O001C0102000100020006990002002904013O0004473O002904012O0076000200023O00205300020002000900121F0004000A4O00DF0002000400020006990002002904013O0004473O002904012O0076000200023O0020530002000200132O00420102000200020006B200020029040100010004473O002904012O0076000200034O001C0102000100020006990002001404013O0004473O001404012O0076000200034O001C0102000100020006990002002904013O0004473O002904012O0076000200043O0006990002002904013O0004473O002904012O00760002000C3O000ED4004B0029040100020004473O00290401002E1500B50029040100B60004473O002904012O0076000200054O0085000300063O00202O0003000300144O000400023O00202O00040004000900122O0006000E6O0004000600024O000400046O00020004000200062O0002002904013O0004473O002904012O0076000200073O00121F000300B73O00121F000400B84O0012000200044O007100025O00121F0001004B3O0026BB0001007A040100470004473O007A04012O0076000200094O0053010300073O00122O000400B93O00122O000500BA6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002005904013O0004473O005904012O00760002000A3O0020950002000200904O000400093O00202O0004000400914O00020004000200262O000200590401001A0004473O005904012O0076000200113O000EAF00480059040100020004473O005904012O0076000200054O004E010300093O00202O0003000300924O000400023O00202O00040004000900122O000600936O00040006000200062O0004004F040100010004473O004F04012O0076000400123O00207D00040004000900122O000600936O0004000600024O000400043O00044O005104012O002400046O00FC000400014O00DF0002000400020006990002005904013O0004473O005904012O0076000200073O00121F000300BB3O00121F000400BC4O0012000200044O007100026O0076000200094O00CC000300073O00122O000400BD3O00122O000500BE6O0003000500024O00020002000300202O0002000200074O0002000200020006B200020065040100010004473O00650401002E1500C000A4050100BF0004473O00A40501002EC800C200A4050100C10004473O00A405012O0076000200054O0090000300093O00202O00030003008B4O000400023O00202O0004000400204O000600093O00202O00060006008B4O0004000600024O000400046O000500016O00020005000200062O000200A405013O0004473O00A405012O0076000200073O001240010300C33O00122O000400C46O000200046O00025O00044O00A40501000E620061007E040100010004473O007E0401002EC800C50041050100C60004473O004105012O0076000200094O0053010300073O00122O000400C73O00122O000500C86O0003000500024O00020002000300202O0002000200074O00020002000200062O0002009D04013O0004473O009D04012O0076000200094O0053010300073O00122O000400C93O00122O000500CA6O0003000500024O00020002000300202O00020002005D4O00020002000200062O0002009D04013O0004473O009D04012O0076000200034O001C0102000100020006990002009F04013O0004473O009F04012O0076000200034O001C0102000100020006990002009D04013O0004473O009D04012O0076000200043O0006B20002009F040100010004473O009F0401002E0C01CB0014000100CC0004473O00B104012O0076000200054O0090000300093O00202O0003000300984O000400023O00202O0004000400204O000600093O00202O0006000600984O0004000600024O000400046O000500016O00020005000200062O000200B104013O0004473O00B104012O0076000200073O00121F000300CD3O00121F000400CE4O0012000200044O007100026O0076000200094O0053010300073O00122O000400CF3O00122O000500D06O0003000500024O00020002000300202O0002000200074O00020002000200062O000200DB04013O0004473O00DB04012O0076000200094O0053010300073O00122O000400D13O00122O000500D26O0003000500024O00020002000300202O00020002005D4O00020002000200062O000200DB04013O0004473O00DB04012O0076000200034O001C010200010002000699000200D004013O0004473O00D004012O0076000200034O001C010200010002000699000200DB04013O0004473O00DB04012O0076000200043O000699000200DB04013O0004473O00DB04012O0076000200023O00200001020002001900122O0004001A6O0002000400024O0003000A3O00202O00030003001B4O000500093O00202O00050005001C4O00030005000200062O000300DD040100020004473O00DD0401002E1500D300F0040100D40004473O00F004012O0076000200054O0096000300093O00202O00030003001F4O000400023O00202O0004000400204O000600093O00202O00060006001F4O0004000600024O000400046O00020004000200062O000200EB040100010004473O00EB0401002E0C01D500070001000E0004473O00F004012O0076000200073O00121F000300D63O00121F000400D74O0012000200044O007100025O002EC800D80019050100D90004473O001905012O0076000200094O0053010300073O00122O000400DA3O00122O000500DB6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002001905013O0004473O001905012O0076000200034O001C0102000100020006990002000705013O0004473O000705012O0076000200034O001C0102000100020006990002001905013O0004473O001905012O0076000200043O0006990002001905013O0004473O001905012O0076000200054O0090000300093O00202O0003000300984O000400023O00202O0004000400204O000600093O00202O0006000600984O0004000600024O000400046O000500016O00020005000200062O0002001905013O0004473O001905012O0076000200073O00121F000300DC3O00121F000400DD4O0012000200044O007100026O0076000200094O0053010300073O00122O000400DE3O00122O000500DF6O0003000500024O00020002000300202O0002000200074O00020002000200062O0002004005013O0004473O004005012O0076000200034O001C0102000100020006990002002E05013O0004473O002E05012O0076000200034O001C0102000100020006990002004005013O0004473O004005012O0076000200043O0006990002004005013O0004473O004005012O0076000200054O0090000300093O00202O00030003005E4O000400023O00202O0004000400204O000600093O00202O00060006005E4O0004000600024O000400046O000500016O00020005000200062O0002004005013O0004473O004005012O0076000200073O00121F000300E03O00121F000400E14O0012000200044O007100025O00121F000100063O0026BB000100070001002E0004473O0007000100121F000200013O0026BB000200520501004B0004473O005205012O0076000300104O001C01030001000200121A000300803O00123A010300803O0006990003005105013O0004473O005105012O0076000300073O00121F000400E23O00121F000500E34O0012000300054O007100035O00121F000200483O0026BB00020056050100480004473O0056050100121F000100843O0004473O000700010026BB00020044050100010004473O004405012O0076000300094O0053010400073O00122O000500E43O00122O000600E56O0004000600024O00030003000400202O0003000300074O00030002000200062O0003007E05013O0004473O007E05012O0076000300034O001C0103000100020006990003006D05013O0004473O006D05012O0076000300034O001C0103000100020006990003007E05013O0004473O007E05012O00760003000B3O0006990003007E05013O0004473O007E05012O0076000300054O003C010400093O00202O0004000400444O000500023O00202O0005000500204O000700093O00202O0007000700444O0005000700024O000500056O00030005000200062O0003007E05013O0004473O007E05012O0076000300073O00121F000400E63O00121F000500E74O0012000300054O007100035O002E0C01E80021000100E80004473O009F05012O00760003000D3O0020530003000300072O00420103000200020006990003009F05013O0004473O009F05012O0076000300013O00202A0103000300784O000400093O00202O0004000400794O0005000E6O00068O00078O0003000700024O0004000F3O00062O0003009F050100040004473O009F05012O0076000300054O00090004000D6O000500023O00202O0005000500204O0007000D6O0005000700024O000500056O00030005000200062O0003009F05013O0004473O009F05012O0076000300073O00121F000400E93O00121F000500EA4O0012000300054O007100035O00121F0002004B3O0004473O004405010004473O000700010004473O00A405010004473O000200012O00D23O00017O0076012O00028O00026O001840025O0069B340025O008AA440026O00F03F025O00C08040025O00BEB04003083O006B10B6BE2C7C551E03063O0013237FDAC76203073O004973526561647903093O0042752O66537461636B030C3O0052686170736F647942752O66026O003440027O0040025O008AAB40026O00704003083O00486F6C794E6F766103093O004973496E52616E6765026O00284003123O0014F406FB23F505F41DBB5BA218FA07E31BFE03043O00827C9B6A025O00DEA54003053O00E6C6FFBBA603083O00DFB5AB96CFC3961C030A3O0049734361737461626C6503053O00536D697465030E3O0049735370652O6C496E52616E6765030C3O005F37EABA2O0C3EE2A3084B3F03053O00692C5A83CE025O00588240025O0096AB40030F3O003D56203B37CF024B330D2AF40C5A3203063O00986D39575E45025O00F88040025O00F0B240026O006540025O00BCA340030F3O00506F776572576F7264536F6C61636503183O00E9D81DA6ACED43A7EBD335B0B1DE55ABFC970EA2B3D353AD03083O00C899B76AC3DEB234025O00F07540025O0004A840030F3O0001EB8939464D05EC9A396D5F33F78003063O003A5283E85D29030E3O00B05FD1115228A058C610533E8D4303063O005FE337B0753D030B3O004973417661696C61626C65030E3O002B76224FA40F5D2C5DAE167F2D5F03053O00CB781E432B030F3O00432O6F6C646F776E52656D61696E73030F3O00C22D4CEBD6E61242FDDDD5204CFBD103053O00B991452D8F03083O00432O6F6C646F776E03073O0054696D65546F58030F3O00B91718A2D39D2816B4D8AE1A18B2D403053O00BCEA7F79C6026O00E03F030F3O00536861646F77576F72644465617468025O007EAB40025O00F0A940031A3O002B3A128737252C94372017BC3C371297307240C33C331E823F3703043O00E3585273025O00789840025O00BAA34003083O0049734D6F76696E67025O0016A140025O00789340030C3O0053686F756C6452657475726E025O0030AE40025O00C07C40026O001C40026O001040025O00F09940025O00149040030F3O00E57D28A7E82O9B19C4710DA6E698A403083O0076B61549C387ECCC030E3O003B341B440B1ADE072A1F4E0503E903073O009D685C7A20646D030E3O0090AE2OCE3230AEA4B5A3C1CB2O3303083O00CBC3C6AFAA5D47ED030F3O001D433FD15E06CB21593AF15410E82603073O009C4E2B5EB5317103103O004865616C746850657263656E74616765025O00C0AA40025O00405640031A3O0061E0C5A704544665E7D6A734477C73FCCCE35A037D73E5C5A40E03073O00191288A4C36B23025O00508940025O0095B14003323O00467269656E646C79556E697473576974686F757442752O6642656C6F774865616C746850657263656E74616765436F756E74030D3O0041746F6E656D656E7442752O66026O002A40025O00E06B4003123O00F828A74E7CBFC4F8FB25A65D6683D2BBE73B03083O00D8884DC92F12DCA1030E3O001EE42ADE07CBA122FA2ED409D29603073O00E24D8C4BBA68BC030E3O008AC6D13B40AEEDDF294AB7CFDE2B03053O002FD9AEB05F025O001CA440025O0094A740025O00807340025O00A07240030E3O00A8D87803BC577D66BCDC7B03B55103083O0046D8BD1662D23418025O00A06940025O004FB040030B3O00F6D6A48FC7C9E8B186C7D203053O00B3BABFC3E7030E3O00CE2D19F0F10A16E8FC3E0BECFC3B03043O0084995F78025O005C9C40025O00F49940030B3O004C6967687473577261746803133O00BDBB0925E3C99FA6A00F39FF9AA4B0BF0F2AF203073O00C0D1D26E4D97BA03093O00CD0A2CEDDDC8E1103603063O00A4806342899F030E3O003381E8BA0F9ECAB1168CE7BF0E9D03043O00DE60E989030E3O008ABBA61B87E4D3B6A5A21189FDE403073O0090D9D3C77FE89303093O00D526302CF7490357EC03083O0024984F5E48B5256203093O004D696E64426C617374025O00E07240025O00F6A54003113O00DAD1493BE8DA4B3EC4CC073BD6D54638D203043O005FB7B827026O001440025O00809D40025O00D88240025O00BBB240030B3O002F8EB7540E8B89450C8EA703043O00246BE7C403093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66025O00A9B240025O0019B340030B3O0044697370656C4D6167696303133O0059BCB19758B99D8A5CB2AB841DB1A38A5CB2A703043O00E73DD5C2030D3O0028BF3E7207A8097C1BBF387D1D03043O001369CD5D030E3O004D616E6150657263656E74616765025O00405540030D3O00417263616E65546F2O72656E74025O0024AA40025O0030964003153O00A81ADD8031AC37CA8E2DBB0DD0957FAD09D38038AC03053O005FC968BEE1025O00E4A240025O008EA140025O00BEAA40025O00E6A74003083O0042752O66446F776E030A3O005445486F6C7942752O66030C3O005445536861646F7742752O66025O0092A440025O0048914003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040025O0030AF40025O00A0AA40025O00AAAB40025O008EA040025O00D07E40025O00F6AC40025O00CDB140025O0058A740030D3O00546172676574497356616C6964026O003E4003133O004973466163696E67426C61636B6C6973746564030E3O0075C3F2ED73F865C4E5EC72EE48DF03063O008F26AB93891C030E3O00E38AB8F70CF4F7DF94BCFD02EDC003073O00B4B0E2D9936383030A3O00F7B0390EDDBC1C13D2AB03043O0067B3D94F03103O00446976696E6553746172506C61796572026O00384003123O004EBE0ADC4F899C59A31DC70188A247B61BD003073O00C32AD77CB521EC025O0012A640025O0076A84003093O00DCEA3E27A3F0EE353003053O00C491835043030E3O002DB8070C17FF3DBF100D16E910A403063O00887ED0666878030E3O004B82CF47A0451E5E6E8FC042A14603083O003118EAAE23CF325D03093O0021FBF38C760DFFF89B03053O00116C929DE803143O0078CB15F93BAD59C610DD2ABA48C604F926A745D003063O00C82BA3748D4F025O00ECAC40025O0070934003093O004D696E6467616D657303123O00B23F3387B7F5EEBA257DD12OF0E2B2373A8603073O0083DF565DE3D094025O00749040025O00709F40030E3O00D04DB7B212A2C04AA0B313B4ED5103063O00D583252OD67D030A3O0048616C6F506C61796572030B3O002E2A29B0A1222A28BEE62303053O0081464B45DF025O0065B140025O0063B340025O0080AE40025O00D1B24003093O009836E92253810FB02C03073O0062D55F874634E0030E3O00CDABC8735BE980C66151F0A2C76303053O00349EC3A917030E3O0049B43370892258846CB93C75882103083O00EB1ADC5214E6551B03093O00A5A8E7C67389ACECD103053O0014E8C189A203143O0011D7C4B2F389057426EFC0B4E48907652BD0CBB503083O001142BFA5C687EC77025O00DC9540025O0034984003123O0002A6A017F8E9E1D41CEFFF53FBE9E1D008AA03083O00B16FCFCE739F888C030F3O0036811110DB58680A9B1430D14E4B0D03073O003F65E97074B42F030E3O00F033EC16F721E034FB17F637CD2F03063O0056A35B8D7298030E3O00600375773544287B653F5D0A7A6703053O005A336B1413030F3O00BEF884EB329AC78AFD39A9F584FB3503053O005DED90E58F03093O0030EEE0100A521CF9FE03063O0026759690796B030F3O001EB3EF3E22ACD9353FBFCA3F2CAFE603043O005A4DDB8E025O0048AE40031A3O00F50C203D431045F10B333D73037FE71029791E477EE709203E4903073O001A866441592C67025O00E49140025O00B0A140030E3O00C944E3F878ED6FEDEA72F44DECE803053O00179A2C829C030A3O00432O6F6C646F776E5570030E3O0021B3BFA9332719A39AA7351814A203063O007371C6CDCE56030D3O00446562752O6652656D61696E7303143O0050757267655468655769636B6564446562752O66030E3O00B442EC5D8163F65FB35EFD51815303043O003AE4379E030E3O00536861646F77576F72645061696E026O000840025O00A2AB40025O00E5B140030E3O00750BE8285C01650CFF295D17481703063O00762663894C3303063O0042752O66557003123O00536861646F77436F76656E616E7442752O66030B3O00CE2E04160637FB2F001C0D03063O00409D46657269025O00805640030A3O006DA1A9E71245A6A3E60203053O007020C8C783025O0035B040025O00E07F40030B3O00536861646F776669656E6403123O003F585DBCCCBC24255552BC83AF2321515BBD03073O00424C303CD8A3CB030A3O00978F77F75DCB2ABE836B03073O0044DAE619933FAE030A3O004D696E6462656E646572026O009740025O0048AB4003113O00A0235D48B4A8245749A4ED2E5241B7AA2F03053O00D6CD4A332C03113O00506F776572496E667573696F6E42752O66025O00406040025O00B49D40025O0004A440025O006AAD40025O002C9A40025O00507340025O00B2A640025O00308E40030E3O00849CC22939993DB1BED92D37A83103073O0055D4E9B04E5CCD03093O0054696D65546F446965030E3O007A4D9AE54F6C80E77D518BE94F5C03043O00822A38E8030C3O00426173654475726174696F6E026O33D33F03113O00446562752O665265667265736861626C6503113O00DAB42DED462AE68531ED492CE2B821ED5403063O005F8AD544832003113O001A29A84D703F24915678233BA94E73243C03053O00164A48C12303073O001C7CEA59227AE103043O00384C1984030E3O0050757267655468655769636B656403173O004ED4B921CA61D5A323F049C8A82DCA5A81AF27C25FC6AE03053O00AF3EA1CB46030E3O000FD5C2173A2BEACC01310CDCCA1D03053O00555CBDA373030E3O0019B9223F2C98383D1EA52O332CA803043O005849CC50030E3O001D8B114226CD198C024219DB278D03063O00BA4EE370264903113O00CC56F45B556FF067E85B5A69F45AF85B4703063O001A9C379D353303113O00BCD91FD7BE4580E803D7B14384D513D7AC03063O0030ECB876B9D803073O00D5B85931C137E003063O005485DD3750AF03173O00AEEF25A2C84B82F02BB4C363ADE62DA88758BCEA25A1C203063O003CDD8744C6A7025O0094A140025O00889840025O0046A540025O00AEA040025O002O7040025O00909F40025O00606540025O003C9040025O0054A340025O0078A140026O00A340025O00489240025O00B49040025O0098B24003063O00DDBEF08A51D403063O00B98EDD98E322030E3O006BCD56FE4C24D457D352F4423DE303073O009738A5379A2353025O00B9B240025O00A4A94003063O0053636869736D03163O00B34B04EAAF543AEDAF5500E0A14D11AEA44208EFA74603043O008EC02365025O003EB340025O00B88040025O00A49B40025O00A7B240030F3O008BB2F0D2CE27796BA0BAF2CDCF0D7503083O0018C3D382A1A6631003133O0048617273684469736369706C696E6542752O66030E3O009CC3C0CAA0DCE2C1B9CE2OCFA1DF03043O00AECFABA1030D3O00C8F30FE1F9D4E8CD05F2FCD8FA03063O00B78D9E6D9398030E3O001F01E708231EC5033A0CE80D221D03043O006C4C6986030D3O00CEC8B3F3CFE8C082E9CFEFCAA603053O00AE8BA5D181025O0074B24003083O00D7EFBEA02631E9E103063O005E9F80D2D968025O002CA540025O00D0804003123O0058F60AA66071F66C51B954FF5B7EF47B57FC03083O001A309966DF3F1F99030E3O003255FFF40774E5F63549EEF8074403043O009362208D025O00908D40025O00DFB24003203O000856F1CD03695F1046DCDD0F55401D47DCC709404E1546EDDE46524A1542E4CF03073O002B782383AA6636025O00888540030E3O00670E86B2AAA7B35B148386A4B98A03073O00E43466E7D6C5D003203O000DE874CEE59C26C111F271F5FA8A10D821ED7ADCEF861CD80AA071CBE78A1ED303083O00B67E8015AA8AEB790005072O00121F3O00014O00AA000100013O0026BB3O0002000100010004473O0002000100121F000100013O000E6200020009000100010004473O00090001002EC8000300E7000100040004473O00E7000100121F000200013O0026AB0002000E000100050004473O000E0001002E150007005C000100060004473O005C00012O007600036O0053010400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003D00013O0004473O003D00012O0076000300023O00209500030003000B4O00055O00202O00050005000C4O00030005000200262O0003003D0001000D0004473O003D00012O0076000300033O000EAF000E003D000100030004473O003D0001002EC80010003D0001000F0004473O003D00012O0076000300044O004E01045O00202O0004000400114O000500053O00202O00050005001200122O000700136O00050007000200062O00050033000100010004473O003300012O0076000500063O00207D00050005001200122O000700136O0005000700024O000500053O00044O003500012O002400056O00FC000500014O00DF0003000500020006990003003D00013O0004473O003D00012O0076000300013O00121F000400143O00121F000500154O0012000300054O007100035O002E0C0116001E000100160004473O005B00012O007600036O0053010400013O00122O000500173O00122O000600186O0004000600024O00030003000400202O0003000300194O00030002000200062O0003005B00013O0004473O005B00012O0076000300044O009000045O00202O00040004001A4O000500053O00202O00050005001B4O00075O00202O00070007001A4O0005000700024O000500056O000600016O00030006000200062O0003005B00013O0004473O005B00012O0076000300013O00121F0004001C3O00121F0005001D4O0012000300054O007100035O00121F0002000E3O0026AB00020060000100010004473O00600001002EC8001F00CA0001001E0004473O00CA00012O007600036O00CC000400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O00030003000A4O0003000200020006B20003006C000100010004473O006C0001002E0C01220015000100230004473O007F0001002EC80024007F000100250004473O007F00012O0076000300044O003C01045O00202O0004000400264O000500053O00202O00050005001B4O00075O00202O0007000700264O0005000700024O000500056O00030005000200062O0003007F00013O0004473O007F00012O0076000300013O00121F000400273O00121F000500284O0012000300054O007100035O002E15002900C90001002A0004473O00C900012O007600036O0053010400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300C900013O0004473O00C900012O007600036O0053010400013O00122O0005002D3O00122O0006002E6O0004000600024O00030003000400202O00030003002F4O00030002000200062O000300A700013O0004473O00A700012O007600036O00DA000400013O00122O000500303O00122O000600316O0004000600024O00030003000400202O0003000300324O0003000200024O00048O000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O0004000400354O00040002000200062O000400C9000100030004473O00C900012O0076000300053O00205300030003003600121F0005000D4O00DF0003000500022O007600046O00CC000500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400354O0004000200020010D800040039000400063A000400C9000100030004473O00C900012O0076000300044O009600045O00202O00040004003A4O000500053O00202O00050005001B4O00075O00202O00070007003A4O0005000700024O000500056O00030005000200062O000300C4000100010004473O00C40001002E15003B00C90001003C0004473O00C900012O0076000300013O00121F0004003D3O00121F0005003E4O0012000300054O007100035O00121F000200053O0026BB0002000A0001000E0004473O000A0001002EC8003F00E4000100400004473O00E400012O0076000300023O0020530003000300412O0042010300020002000699000300E400013O0004473O00E4000100121F000300013O0026AB000300D8000100010004473O00D80001002EC8004200D4000100430004473O00D400012O0076000400074O001C01040001000200121A000400443O00123A010400443O0006B2000400E0000100010004473O00E00001002E0C01450006000100460004473O00E4000100123A010400444O0075000400023O0004473O00E400010004473O00D4000100121F000100473O0004473O00E700010004473O000A00010026AB000100EB000100480004473O00EB0001002EC8004900EB2O01004A0004473O00EB2O012O007600026O0053010300013O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200162O013O0004473O00162O012O007600026O0053010300013O00122O0004004D3O00122O0005004E6O0003000500024O00020002000300202O00020002002F4O00020002000200062O000200112O013O0004473O00112O012O007600026O00DA000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200324O0002000200024O00038O000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300354O00030002000200062O000300162O0100020004473O00162O012O0076000200053O0020530002000200532O00420102000200020026C1000200182O01000D0004473O00182O01002EC8005400292O0100550004473O00292O012O0076000200044O003C01035O00202O00030003003A4O000400053O00202O00040004001B4O00065O00202O00060006003A4O0004000600024O000400046O00020004000200062O000200292O013O0004473O00292O012O0076000200013O00121F000300563O00121F000400574O0012000200044O007100025O002E150058004C2O0100590004473O004C2O012O0076000200083O00205300020002000A2O00420102000200020006990002004C2O013O0004473O004C2O012O0076000200093O00202A01020002005A4O00035O00202O00030003005B4O0004000A6O00058O00068O0002000600024O0003000B3O00062O0002004C2O0100030004473O004C2O012O0076000200044O00BC000300086O000400053O00202O00040004001B4O000600086O0004000600024O000400046O00020004000200062O000200472O0100010004473O00472O01002E15005D004C2O01005C0004473O004C2O012O0076000200013O00121F0003005E3O00121F0004005F4O0012000200044O007100026O007600026O0053010300013O00122O000400603O00122O000500616O0003000500024O00020002000300202O00020002002F4O00020002000200062O000200632O013O0004473O00632O012O007600026O00CC000300013O00122O000400623O00122O000500636O0003000500024O00020002000300202O0002000200324O0002000200022O0076000300083O0020530003000300352O004201030002000200063A000300882O0100020004473O00882O0100121F000200014O00AA000300043O0026BB000200802O0100050004473O00802O010026AB0003006B2O0100010004473O006B2O01002E0C016400FEFF2O00650004473O00672O0100121F000400013O0026AB000400702O0100010004473O00702O01002EC80066006C2O0100670004473O006C2O012O00760005000C4O001C01050001000200121A000500443O00123A010500443O000699000500882O013O0004473O00882O012O0076000500013O001240010600683O00122O000700696O000500076O00055O00044O00882O010004473O006C2O010004473O00882O010004473O00672O010004473O00882O010026AB000200842O0100010004473O00842O01002EC8006B00652O01006A0004473O00652O0100121F000300014O00AA000400043O00121F000200053O0004473O00652O012O007600026O0053010300013O00122O0004006C3O00122O0005006D6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002009C2O013O0004473O009C2O012O007600026O00CC000300013O00122O0004006E3O00122O0005006F6O0003000500024O00020002000300202O00020002002F4O0002000200020006B20002009E2O0100010004473O009E2O01002E0C01700014000100710004473O00B02O012O0076000200044O009000035O00202O0003000300724O000400053O00202O00040004001B4O00065O00202O0006000600724O0004000600024O000400046O000500016O00020005000200062O000200B02O013O0004473O00B02O012O0076000200013O00121F000300733O00121F000400744O0012000200044O007100026O007600026O0053010300013O00122O000400753O00122O000500766O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200EA2O013O0004473O00EA2O012O007600026O0053010300013O00122O000400773O00122O000500786O0003000500024O00020002000300202O00020002002F4O00020002000200062O000200D62O013O0004473O00D62O012O007600026O00DA000300013O00122O000400793O00122O0005007A6O0003000500024O00020002000300202O0002000200324O0002000200024O00038O000400013O00122O0005007B3O00122O0006007C6O0004000600024O00030003000400202O0003000300354O00030002000200062O000300EA2O0100020004473O00EA2O012O0076000200044O006A00035O00202O00030003007D4O000400053O00202O00040004001B4O00065O00202O00060006007D4O0004000600024O000400046O000500016O00020005000200062O000200E52O0100010004473O00E52O01002EC8007F00EA2O01007E0004473O00EA2O012O0076000200013O00121F000300803O00121F000400814O0012000200044O007100025O00121F000100823O002E1500840081020100830004473O00810201000E1700010081020100010004473O0081020100121F000200014O00AA000300033O002E0C01853O000100850004473O00F12O010026BB000200F12O0100010004473O00F12O0100121F000300013O0026BB00030058020100050004473O0058020100121F000400013O0026BB00040051020100010004473O005102012O007600056O0053010600013O00122O000700863O00122O000800876O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005001B02013O0004473O001B02012O00760005000D3O0006990005001B02013O0004473O001B02012O00760005000E3O0006990005001B02013O0004473O001B02012O0076000500023O0020530005000500882O00420105000200020006B20005001B020100010004473O001B02012O0076000500023O0020530005000500892O00420105000200020006B20005001B020100010004473O001B02012O0076000500093O00204B00050005008A2O0076000600054O00420105000200020006B20005001D020100010004473O001D0201002EC8008C002E0201008B0004473O002E02012O0076000500044O003C01065O00202O00060006008D4O000700053O00202O00070007001B4O00095O00202O00090009008D4O0007000900024O000700076O00050007000200062O0005002E02013O0004473O002E02012O0076000500013O00121F0006008E3O00121F0007008F4O0012000500074O007100056O007600056O0053010600013O00122O000700903O00122O000800916O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005002013O0004473O005002012O00760005000F3O0006990005005002013O0004473O005002012O0076000500103O0006990005005002013O0004473O005002012O0076000500023O0020530005000500922O004201050002000200261601050050020100930004473O005002012O0076000500044O007600065O00204B0006000600942O00420105000200020006B20005004B020100010004473O004B0201002EC800950050020100960004473O005002012O0076000500013O00121F000600973O00121F000700984O0012000500074O007100055O00121F000400053O002E15009A00F92O0100990004473O00F92O010026BB000400F92O0100050004473O00F92O0100121F0003000E3O0004473O005802010004473O00F92O01002E15009C006B0201009B0004473O006B02010026BB0003006B0201000E0004473O006B02012O0076000400023O00203901040004009D4O00065O00202O00060006009E4O00040006000200062O0004006802013O0004473O006802012O0076000400023O00205300040004009D2O007600065O00204B00060006009F2O00DF0004000600022O0004010400113O00121F000100053O0004473O00810201002E1500A100F62O0100A00004473O00F62O010026BB000300F62O0100010004473O00F62O012O0076000400093O00203D0004000400A24O00055O00202O0005000500A300122O000600A46O00040006000200122O000400443O00122O000400443O00062O0004007B020100010004473O007B0201002EC800A5007D020100A60004473O007D020100123A010400444O0075000400023O00121F000300053O0004473O00F62O010004473O008102010004473O00F12O010026AB00010085020100820004473O00850201002EC800A700F1030100A80004473O00F1030100121F000200014O00AA000300033O0026AB0002008B020100010004473O008B0201002EC800AA0087020100A90004473O0087020100121F000300013O0026BB000300D30201000E0004473O00D30201002E1500AC00D1020100AB0004473O00D102012O0076000400123O00205300040004000A2O0042010400020002000699000400D102013O0004473O00D102012O0076000400093O00204B0004000400AD2O001C010400010002000699000400D102013O0004473O00D102012O0076000400053O00205300040004001200121F000600AE4O00DF000400060002000699000400D102013O0004473O00D102012O0076000400053O0020530004000400AF2O00420104000200020006B2000400D1020100010004473O00D102012O007600046O0053010500013O00122O000600B03O00122O000700B16O0005000700024O00040004000500202O00040004002F4O00040002000200062O000400C102013O0004473O00C102012O007600046O00DA000500013O00122O000600B23O00122O000700B36O0005000700024O00040004000500202O0004000400324O0004000200024O00058O000600013O00122O000700B43O00122O000800B56O0006000800024O00050005000600202O0005000500354O00050002000200062O000500D1020100040004473O00D102012O0076000400044O0085000500133O00202O0005000500B64O000600053O00202O00060006001200122O000800B76O0006000800024O000600066O00040006000200062O000400D102013O0004473O00D102012O0076000400013O00121F000500B83O00121F000600B94O0012000400064O007100045O00121F000100023O0004473O00F103010026AB000300D7020100050004473O00D70201002E0C01BA0074000100BB0004473O004903012O007600046O0053010500013O00122O000600BC3O00122O000700BD6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001B03013O0004473O001B03012O007600046O0053010500013O00122O000600BE3O00122O000700BF6O0005000700024O00040004000500202O00040004002F4O00040002000200062O000400FD02013O0004473O00FD02012O007600046O00DA000500013O00122O000600C03O00122O000700C16O0005000700024O00040004000500202O0004000400324O0004000200024O00058O000600013O00122O000700C23O00122O000800C36O0006000800024O00050005000600202O0005000500354O00050002000200062O0005001B030100040004473O001B03012O007600046O00CC000500013O00122O000600C43O00122O000700C56O0005000700024O00040004000500202O00040004002F4O0004000200020006B20004001B030100010004473O001B0301002EC800C7001B030100C60004473O001B03012O0076000400044O009000055O00202O0005000500C84O000600053O00202O00060006001B4O00085O00202O0008000800C84O0006000800024O000600066O000700016O00040007000200062O0004001B03013O0004473O001B03012O0076000400013O00121F000500C93O00121F000600CA4O0012000400064O007100045O002E1500CB0048030100CC0004473O004803012O0076000400143O00205300040004000A2O00420104000200020006990004004803013O0004473O004803012O0076000400093O00204B0004000400AD2O001C0104000100020006990004004803013O0004473O004803012O0076000400053O00205300040004001200121F000600AE4O00DF0004000600020006990004004803013O0004473O004803012O007600046O00CC000500013O00122O000600CD3O00122O000700CE6O0005000700024O00040004000500202O00040004002F4O0004000200020006B200040048030100010004473O004803012O0076000400044O000A010500133O00202O0005000500CF4O000600053O00202O00060006001200122O000800B76O0006000800024O000600066O000700016O00040007000200062O0004004803013O0004473O004803012O0076000400013O00121F000500D03O00121F000600D14O0012000400064O007100045O00121F0003000E3O0026BB0003008C020100010004473O008C020100121F000400013O000E6200050050030100040004473O00500301002E1500D30052030100D20004473O0052030100121F000300053O0004473O008C02010026AB00040056030100010004473O00560301002E0C01D400F8FF2O00D50004473O004C03012O007600056O0053010600013O00122O000700D63O00122O000800D76O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005008603013O0004473O008603012O007600056O0053010600013O00122O000700D83O00122O000800D96O0006000800024O00050005000600202O00050005002F4O00050002000200062O0005007C03013O0004473O007C03012O007600056O00DA000600013O00122O000700DA3O00122O000800DB6O0006000800024O00050005000600202O0005000500324O0005000200024O00068O000700013O00122O000800DC3O00122O000900DD6O0007000900024O00060006000700202O0006000600354O00060002000200062O00060086030100050004473O008603012O007600056O00CC000600013O00122O000700DE3O00122O000800DF6O0006000800024O00050005000600202O00050005002F4O0005000200020006B200050088030100010004473O00880301002EC800E1009A030100E00004473O009A03012O0076000500044O009000065O00202O0006000600C84O000700053O00202O00070007001B4O00095O00202O0009000900C84O0007000900024O000700076O000800016O00050008000200062O0005009A03013O0004473O009A03012O0076000500013O00121F000600E23O00121F000700E34O0012000500074O007100056O007600056O0053010600013O00122O000700E43O00122O000800E56O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500EC03013O0004473O00EC03012O007600056O0053010600013O00122O000700E63O00122O000800E76O0006000800024O00050005000600202O00050005002F4O00050002000200062O000500C003013O0004473O00C003012O007600056O00DA000600013O00122O000700E83O00122O000800E96O0006000800024O00050005000600202O0005000500324O0005000200024O00068O000700013O00122O000800EA3O00122O000900EB6O0007000900024O00060006000700202O0006000600354O00060002000200062O000600EC030100050004473O00EC03012O007600056O0053010600013O00122O000700EC3O00122O000800ED6O0006000800024O00050005000600202O00050005002F4O00050002000200062O000500EC03013O0004473O00EC03012O0076000500053O00205300050005003600121F0007000D4O00DF0005000700022O007600066O00CC000700013O00122O000800EE3O00122O000900EF6O0007000900024O00060006000700202O0006000600354O0006000200020010D800060039000600063A000600EC030100050004473O00EC0301002E0C01F00013000100F00004473O00EC03012O0076000500044O003C01065O00202O00060006003A4O000700053O00202O00070007001B4O00095O00202O00090009003A4O0007000900024O000700076O00050007000200062O000500EC03013O0004473O00EC03012O0076000500013O00121F000600F13O00121F000700F24O0012000500074O007100055O00121F000400053O0004473O004C03010004473O008C02010004473O00F103010004473O008702010026BB000100D50401000E0004473O00D5040100121F000200013O0026AB000200F80301000E0004473O00F80301002EC800F40037040100F30004473O003704012O007600036O0053010400013O00122O000500F53O00122O000600F66O0004000600024O00030003000400202O0003000300F74O00030002000200062O0003003504013O0004473O003504012O0076000300153O0006B200030035040100010004473O003504012O0076000300163O0006990003002D04013O0004473O002D04012O0076000300173O0006990003003504013O0004473O003504012O007600036O0053010400013O00122O000500F83O00122O000600F96O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003001C04013O0004473O001C04012O0076000300053O0020920003000300FA4O00055O00202O0005000500FB4O00030005000200262O0003002D0401000D0004473O002D04012O007600036O00CC000400013O00122O000500FC3O00122O000600FD6O0004000600024O00030003000400202O00030003002F4O0003000200020006B200030035040100010004473O003504012O0076000300053O0020A40003000300FA4O00055O00202O0005000500FE4O00030005000200262O000300350401000D0004473O003504012O0076000300184O001C01030001000200121A000300443O00123A010300443O0006990003003504013O0004473O0035040100123A010300444O0075000300023O00121F000100FF3O0004473O00D504010026AB0002003C040100010004473O003C040100121F0003002O012O00262C0003008804012O000104473O008804012O007600036O0053010400013O00122O00050002012O00122O00060003015O0004000600024O00030003000400202O0003000300F74O00030002000200062O0003004904013O0004473O004904012O0076000300163O0006B200030050040100010004473O005004012O0076000300023O00122O00050004015O0003000300054O00055O00122O00060005015O0005000500064O0003000500022O0004010300194O007600036O0053010400013O00122O00050006012O00122O00060007015O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003008704013O0004473O008704012O0076000300103O0006990003008704013O0004473O008704012O0076000300023O0020530003000300922O004201030002000200121F00040008012O00063A00030087040100040004473O008704012O007600036O00CC000400013O00122O00050009012O00122O0006000A015O0004000600024O00030003000400202O00030003002F4O0003000200020006B200030087040100010004473O008704012O0076000300023O0012D600050004015O0003000300054O00055O00122O00060005015O0005000500064O00030005000200062O00030087040100010004473O0087040100121F0003000B012O00121F0004000C012O00062001040087040100030004473O008704012O0076000300044O003B01045O00122O0005000D015O0004000400054O00030002000200062O0003008704013O0004473O008704012O0076000300013O00121F0004000E012O00121F0005000F013O0012000300054O007100035O00121F000200053O00121F000300053O0006E5000300F4030100020004473O00F403012O007600036O0053010400013O00122O00050010012O00122O00060011015O0004000600024O00030003000400202O00030003000A4O00030002000200062O000300B104013O0004473O00B104012O0076000300103O000699000300B104013O0004473O00B104012O0076000300023O0012D600050004015O0003000300054O00055O00122O00060005015O0005000500064O00030005000200062O000300B1040100010004473O00B104012O0076000300044O00EC00045O00122O00050012015O0004000400054O00030002000200062O000300AC040100010004473O00AC040100121F00030013012O00121F00040014012O000620010400B1040100030004473O00B104012O0076000300013O00121F00040015012O00121F00050016013O0012000300054O007100036O0076000300103O000699000300BD04013O0004473O00BD04012O0076000300023O0012D600050004015O0003000300054O00055O00122O00060017015O0005000500064O00030005000200062O000300C1040100010004473O00C1040100121F00030018012O00121F00040019012O000620010400D3040100030004473O00D3040100121F000300013O00121F000400013O0006AD000300C9040100040004473O00C9040100121F0004001A012O00121F0005001B012O000620010500C2040100040004473O00C204012O00760004001A4O001C01040001000200121A000400443O00123A010400443O000699000400D304013O0004473O00D3040100123A010400444O0075000400023O0004473O00D304010004473O00C2040100121F0002000E3O0004473O00F4030100121F000200FF3O0006E500010031060100020004473O0031060100121F000200013O00121F000300053O0006AD000200E0040100030004473O00E0040100121F0003001C012O00121F0004001D012O00063A0003009F050100040004473O009F050100121F0003001E012O00121F0004001F012O0006200104003D050100030004473O003D05012O007600036O0053010400013O00122O00050020012O00122O00060021015O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003D05013O0004473O003D05012O0076000300053O00125501050022015O0003000300054O0003000200024O00048O000500013O00122O00060023012O00122O00070024015O0005000700024O00040004000500122O00060025013O00140104000400062O004201040002000200121F00050026013O001400040005000400063A0004003D050100030004473O003D05012O0076000300053O00123200050027015O0003000300054O00055O00202O0005000500FB4O00030005000200062O0003003D05013O0004473O003D05012O007600036O0053010400013O00122O00050028012O00122O00060029015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003002A05013O0004473O002A05012O007600036O0053010400013O00122O0005002A012O00122O0006002B015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003003D05013O0004473O003D05012O0076000300053O00200F0003000300FA4O00055O00202O0005000500FB4O0003000500024O00048O000500013O00122O0006002C012O00122O0007002D015O0005000700024O00040004000500202O0004000400324O00040002000200062O0003003D050100040004473O003D05012O0076000300044O006D00045O00122O0005002E015O0004000400054O000500053O00202O00050005001B4O00075O00122O0008002E015O0007000700084O0005000700024O000500054O00DF0003000500020006990003003D05013O0004473O003D05012O0076000300013O00121F0004002F012O00121F00050030013O0012000300054O007100036O007600036O0053010400013O00122O00050031012O00122O00060032015O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003009E05013O0004473O009E05012O007600036O00CC000400013O00122O00050033012O00122O00060034015O0004000600024O00030003000400202O00030003002F4O0003000200020006B20003009E050100010004473O009E05012O0076000300053O00125501050022015O0003000300054O0003000200024O00048O000500013O00122O00060035012O00122O00070036015O0005000700024O00040004000500122O00060025013O00140104000400062O004201040002000200121F00050026013O001400040005000400063A0004009E050100030004473O009E05012O0076000300053O00123200050027015O0003000300054O00055O00202O0005000500FE4O00030005000200062O0003009E05013O0004473O009E05012O007600036O0053010400013O00122O00050037012O00122O00060038015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003008D05013O0004473O008D05012O007600036O0053010400013O00122O00050039012O00122O0006003A015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003009E05013O0004473O009E05012O0076000300053O00200F0003000300FA4O00055O00202O0005000500FE4O0003000500024O00048O000500013O00122O0006003B012O00122O0007003C015O0005000700024O00040004000500202O0004000400324O00040002000200062O0003009E050100040004473O009E05012O0076000300044O003C01045O00202O0004000400FE4O000500053O00202O00050005001B4O00075O00202O0007000700FE4O0005000700024O000500056O00030005000200062O0003009E05013O0004473O009E05012O0076000300013O00121F0004003D012O00121F0005003E013O0012000300054O007100035O00121F0002000E3O00121F0003003F012O00121F00040040012O00063A000400FB050100030004473O00FB050100121F000300013O0006E5000200FB050100030004473O00FB050100121F00030041012O00121F00040041012O0006E5000300D0050100040004473O00D005012O0076000300173O000699000300D005013O0004473O00D005012O0076000300193O000699000300D005013O0004473O00D005012O0076000300153O0006B2000300D0050100010004473O00D0050100121F000300014O00AA000400043O00121F000500013O0006AD000300BC050100050004473O00BC050100121F00050042012O00121F00060043012O000620010500B5050100060004473O00B5050100121F000400013O00121F000500013O0006E5000400BD050100050004473O00BD05012O00760005001B4O008E00050001000200122O000500443O00122O00050044012O00122O00060044012O00062O000500D0050100060004473O00D0050100123A010500443O000699000500D005013O0004473O00D0050100123A010500444O0075000500023O0004473O00D005010004473O00BD05010004473O00D005010004473O00B505012O00760003001C3O000699000300FA05013O0004473O00FA05012O0076000300193O000699000300FA05013O0004473O00FA05012O0076000300153O0006B2000300FA050100010004473O00FA050100121F000300014O00AA000400043O00121F000500013O0006AD000300E2050100050004473O00E2050100121F00050045012O00121F00060046012O00063A000600DB050100050004473O00DB050100121F000400013O00121F000500013O0006AD000400EA050100050004473O00EA050100121F00050047012O00121F00060048012O000620010500E3050100060004473O00E305012O00760005001D4O001C01050001000200121A000500443O00123A010500443O0006B2000500F4050100010004473O00F4050100121F00050049012O00121F0006004A012O00063A000500FA050100060004473O00FA050100123A010500444O0075000500023O0004473O00FA05010004473O00E305010004473O00FA05010004473O00DB050100121F000200053O00121F0003004B012O00121F0004004C012O00063A000300D9040100040004473O00D9040100121F0003000E3O0006E5000200D9040100030004473O00D904012O007600036O0053010400013O00122O0005004D012O00122O0006004E015O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002E06013O0004473O002E06012O007600036O00CC000400013O00122O0005004F012O00122O00060050015O0004000600024O00030003000400202O00030003002F4O0003000200020006B20003002E060100010004473O002E060100121F00030051012O00121F00040052012O00063A0004002E060100030004473O002E06012O0076000300044O006D00045O00122O00050053015O0004000400054O000500053O00202O00050005001B4O00075O00122O00080053015O0007000700084O0005000700024O000500054O00FC000600014O00DF0003000600020006990003002E06013O0004473O002E06012O0076000300013O00121F00040054012O00121F00050055013O0012000300054O007100035O00121F000100483O0004473O003106010004473O00D9040100121F00020056012O00121F00030057012O00063A000300A0060100020004473O00A0060100121F000200053O0006E5000100A0060100020004473O00A0060100121F000200013O00121F0003000E3O0006AD00020040060100030004473O0040060100121F00030058012O00121F00040059012O0006E500030058060100040004473O005806012O007600036O0053010400013O00122O0005005A012O00122O0006005B015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003005406013O0004473O005406012O0076000300023O0020ED00030003000B4O00055O00122O0006005C015O0005000500064O00030005000200122O000400FF3O00062O00030054060100040004473O005406012O002400036O00FC000300014O0004010300163O00121F0001000E3O0004473O00A0060100121F000300053O0006E500020083060100030004473O008306012O007600036O0053010400013O00122O0005005D012O00122O0006005E015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003006D06013O0004473O006D06012O007600036O00CC000400013O00122O0005005F012O00122O00060060015O0004000600024O00030003000400202O00030003002F4O0003000200022O00040103001C4O007600036O0053010400013O00122O00050061012O00122O00060062015O0004000600024O00030003000400202O00030003002F4O00030002000200062O0003008106013O0004473O008106012O007600036O00CC000400013O00122O00050063012O00122O00060064015O0004000600024O00030003000400202O00030003002F4O0003000200022O0003000300034O0004010300173O00121F0002000E3O00121F00030065012O00121F00040065012O0006E500030039060100040004473O0039060100121F000300013O0006E500020039060100030004473O003906012O0076000300023O00122000050004015O0003000300054O00055O00202O00050005009E4O00030005000200062O00030093060100010004473O009306012O0076000300114O00040103001E4O0036010300023O00122O00050004015O0003000300054O00055O00202O00050005009F4O00030005000200062O0003009D060100010004473O009D06012O0076000300114O00040103001F3O00121F000200053O0004473O0039060100121F000200473O0006E500010005000100020004473O000500012O007600026O0053010300013O00122O00040066012O00122O00050067015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200C006013O0004473O00C006012O0076000200033O00121F0003000E3O00063A000300C0060100020004473O00C0060100121F00020068012O00121F00030069012O00063A000300C0060100020004473O00C006012O0076000200044O007600035O00204B0003000300112O0042010200020002000699000200C006013O0004473O00C006012O0076000200013O00121F0003006A012O00121F0004006B013O0012000200044O007100026O007600026O0053010300013O00122O0004006C012O00122O0005006D015O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200E106013O0004473O00E106012O0076000200044O006D00035O00122O0004002E015O0003000300044O000400053O00202O00040004001B4O00065O00122O0007002E015O0006000600074O0004000600024O000400044O00DF0002000400020006B2000200DC060100010004473O00DC060100121F0002006E012O00121F0003006F012O000620010300E1060100020004473O00E106012O0076000200013O00121F00030070012O00121F00040071013O0012000200044O007100025O00121F00020072012O00121F00030072012O0006E500020004070100030004473O000407012O007600026O0053010300013O00122O00040073012O00122O00050074015O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002000407013O0004473O000407012O0076000200044O003C01035O00202O0003000300FE4O000400053O00202O00040004001B4O00065O00202O0006000600FE4O0004000600024O000400046O00020004000200062O0002000407013O0004473O000407012O0076000200013O00124001030075012O00122O00040076015O000200046O00025O00044O000407010004473O000500010004473O000407010004473O000200012O00D23O00017O006F3O00028O00025O00108B40025O0090A640026O00F03F025O0064AE40030C3O0053686F756C6452657475726E025O00C88040025O0060A740027O0040030D3O00546172676574497356616C6964025O00ACAF40025O00806040025O009C9840025O0046A240025O0076A340025O009C9F4003083O0049734D6F76696E67025O00A2AC40025O0026AE40025O00D8AD40025O00EAA940025O00D07B40025O0034A840025O00708940025O00A4A840030F3O0048616E646C65412O666C696374656403063O00507572696679030F3O005075726966794D6F7573656F766572026O004440025O001EAB40025O00CCB140025O0074B240026O000840025O00E6A840025O00A1B240025O00FCAB40025O00789C40026O001040025O00709B40025O00EC9640030D3O004461726B52657072696D616E6403163O004461726B52657072696D616E644D6F7573656F766572025O0010A240025O0070AD4003093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572025O00E8B140025O0091B04003073O0050656E616E636503103O0050656E616E63654D6F7573656F766572025O00DC9A40025O00049C40025O0060A240025O0030B240025O0032A140025O00B4B240025O00A08340030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572025O00C07440025O0044A840025O00909A40025O00489440025O0044A040025O0020A840025O0094A14003113O0048616E646C65496E636F72706F7265616C030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572026O003E40025O00F5B240025O00C08C40025O00749040025O0075B240025O00F6A140025O00C08A40025O00B09540026O005B40025O004DB040025O008CA340030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572025O00988A40025O004CA540025O0010AB40025O00206D40030D3O0048616E646C654368726F6D6965025O00A07840025O00806F40025O00CEAC40025O00488740025O0048A740025O00ECA340025O00608A40025O00B2AA40025O00A88340025O0092AD40025O004EA540025O00AEA240025O001EAF40025O009C9440025O00BC9840025O00ACAA40026O006C40025O00DAA840025O005EAD40025O006C9440025O00409440025O00C09B40025O00409340025O0072A9400034022O00121F3O00014O00AA000100013O000E170001000200013O0004473O0002000100121F000100013O0026AB00010009000100010004473O00090001002E0C0102001F000100030004473O0026000100121F000200013O0026BB0002000E000100040004473O000E000100121F000100043O0004473O00260001002E0C010500FCFF2O00050004473O000A00010026BB0002000A000100010004473O000A000100121F000300013O0026BB00030017000100040004473O0017000100121F000200043O0004473O000A00010026BB00030013000100010004473O001300012O007600046O001C01040001000200121A000400063O00123A010400063O0006B200040021000100010004473O00210001002EC800080023000100070004473O0023000100123A010400064O0075000400023O00121F000300043O0004473O001300010004473O000A00010026BB0001005C000100090004473O005C00012O0076000200013O00204B00020002000A2O001C0102000100020006B20002002F000100010004473O002F0001002EC8000B00470001000C0004473O0047000100121F000200014O00AA000300033O002E15000D00310001000E0004473O003100010026BB00020031000100010004473O0031000100121F000300013O0026BB00030036000100010004473O003600012O0076000400024O001C01040001000200121A000400063O002EC8001000330201000F0004473O0033020100123A010400063O0006990004003302013O0004473O0033020100123A010400064O0075000400023O0004473O003302010004473O003600010004473O003302010004473O003100010004473O003302012O0076000200033O0020530002000200112O00420102000200020006990002003302013O0004473O0033020100121F000200013O0026BB0002004D000100010004473O004D00012O0076000300044O001C01030001000200121A000300063O00123A010300063O0006B200030057000100010004473O00570001002EC800130033020100120004473O0033020100123A010300064O0075000300023O0004473O003302010004473O004D00010004473O003302010026AB00010060000100040004473O00600001002E1500140005000100150004473O0005000100121F000200013O0026BB00020065000100040004473O0065000100121F000100093O0004473O000500010026BB00020061000100010004473O0061000100121F000300013O0026BB0003002A020100010004473O002A02012O0076000400053O000699000400232O013O0004473O00232O0100121F000400014O00AA000500053O0026BB0004006F000100010004473O006F000100121F000500013O0026AB00050076000100010004473O00760001002EC80017009B000100160004473O009B000100121F000600013O0026AB0006007B000100010004473O007B0001002E0C0118001B000100190004473O0094000100121F000700013O0026BB0007008F000100010004473O008F00012O0076000800013O00202501080008001A4O000900063O00202O00090009001B4O000A00073O00202O000A000A001C00122O000B001D6O0008000B000200122O000800063O00122O000800063O00062O0008008C000100010004473O008C0001002E15001F008E0001001E0004473O008E000100123A010800064O0075000800023O00121F000700043O0026BB0007007C000100040004473O007C000100121F000600043O0004473O009400010004473O007C0001002E0C012000E3FF2O00200004473O007700010026BB00060077000100040004473O0077000100121F000500043O0004473O009B00010004473O007700010026AB0005009F000100210004473O009F0001002E0C01220027000100230004473O00C4000100121F000600013O0026AB000600A4000100040004473O00A40001002EC8002400A6000100250004473O00A6000100121F000500263O0004473O00C40001002EC8002800A0000100270004473O00A000010026BB000600A0000100010004473O00A0000100121F000700013O000E17000400AF000100070004473O00AF000100121F000600043O0004473O00A000010026BB000700AB000100010004473O00AB00012O0076000800013O00202501080008001A4O000900063O00202O0009000900294O000A00073O00202O000A000A002A00122O000B001D6O0008000B000200122O000800063O00122O000800063O00062O000800BF000100010004473O00BF0001002E15002C00C10001002B0004473O00C1000100123A010800064O0075000800023O00121F000700043O0004473O00AB00010004473O00A000010026BB000500D8000100260004473O00D800012O0076000600013O00200400060006001A4O000700063O00202O00070007002D4O000800073O00202O00080008002E00122O0009001D6O000A00016O0006000A000200122O000600063O00122O000600063O00062O000600D5000100010004473O00D50001002E15002F00232O0100300004473O00232O0100123A010600064O0075000600023O0004473O00232O010026BB000500FB000100090004473O00FB000100121F000600014O00AA000700073O0026BB000600DC000100010004473O00DC000100121F000700013O000E17000100F2000100070004473O00F200012O0076000800013O00202501080008001A4O000900063O00202O0009000900314O000A00073O00202O000A000A003200122O000B001D6O0008000B000200122O000800063O00122O000800063O00062O000800EF000100010004473O00EF0001002EC8003400F1000100330004473O00F1000100123A010800064O0075000800023O00121F000700043O0026AB000700F6000100040004473O00F60001002E0C013500EBFF2O00360004473O00DF000100121F000500213O0004473O00FB00010004473O00DF00010004473O00FB00010004473O00DC00010026AB000500FF000100040004473O00FF0001002E1500380072000100370004473O0072000100121F000600013O000E17000400042O0100060004473O00042O0100121F000500093O0004473O00720001002E0C013900FCFF2O00390004474O002O010026BB00062O002O0100010004474O002O0100121F000700013O0026BB0007001A2O0100010004473O001A2O012O0076000800013O0020B000080008001A4O000900063O00202O00090009003A4O000A00073O00202O000A000A003B00122O000B001D6O0008000B000200122O000800063O00122O000800063O00062O000800192O013O0004473O00192O0100123A010800064O0075000800023O00121F000700043O000E17000400092O0100070004473O00092O0100121F000600043O0004474O002O010004473O00092O010004474O002O010004473O007200010004473O00232O010004473O006F0001002E15003C00290201003D0004473O002902012O0076000400083O0006990004002902013O0004473O0029020100121F000400013O0026BB000400A62O0100090004473O00A62O0100121F000500014O00AA000600063O0026AB000500312O0100010004473O00312O01002EC8003E002D2O01003F0004473O002D2O0100121F000600013O002E0C01400051000100400004473O00832O01000E17000400832O0100060004473O00832O01002E15004200812O0100410004473O00812O012O0076000700093O000699000700812O013O0004473O00812O0100121F000700014O00AA000800083O0026BB0007003D2O0100010004473O003D2O0100121F000800013O0026BB000800542O0100040004473O00542O012O0076000900013O0020040009000900434O000A00063O00202O000A000A00444O000B00073O00202O000B000B004500122O000C00466O000D00016O0009000D000200122O000900063O00122O000900063O00062O000900512O0100010004473O00512O01002EC8004700812O0100480004473O00812O0100123A010900064O0075000900023O0004473O00812O01002EC8004900402O01004A0004473O00402O010026BB000800402O0100010004473O00402O0100121F000900013O0026AB0009005D2O0100040004473O005D2O01002EC8004B005F2O01004C0004473O005F2O0100121F000800043O0004473O00402O010026AB000900632O0100010004473O00632O01002E0C014D00F8FF2O004E0004473O00592O0100121F000A00013O002EC8005000782O01004F0004473O00782O010026BB000A00782O0100010004473O00782O012O0076000B00013O002072000B000B00434O000C00063O00202O000C000C00514O000D00073O00202O000D000D005200122O000E00466O000F00016O000B000F000200122O000B00063O00122O000B00063O00062O000B00772O013O0004473O00772O0100123A010B00064O0075000B00023O00121F000A00043O0026BB000A00642O0100040004473O00642O0100121F000900043O0004473O00592O010004473O00642O010004473O00592O010004473O00402O010004473O00812O010004473O003D2O0100121F000400213O0004473O00A62O010026AB000600872O0100010004473O00872O01002E15005400322O0100530004473O00322O0100121F000700013O0026AB0007008C2O0100010004473O008C2O01002EC80055009E2O0100560004473O009E2O012O0076000800013O0020040008000800574O000900063O00202O00090009002D4O000A00073O00202O000A000A002E00122O000B001D6O000C00016O0008000C000200122O000800063O00122O000800063O00062O0008009B2O0100010004473O009B2O01002EC80058009D2O0100590004473O009D2O0100123A010800064O0075000800023O00121F000700043O000E17000400882O0100070004473O00882O0100121F000600043O0004473O00322O010004473O00882O010004473O00322O010004473O00A62O010004473O002D2O010026BB00040001020100010004473O0001020100121F000500013O000E62000400AD2O0100050004473O00AD2O01002E0C015A000D0001005B0004473O00B82O012O0076000600013O0020370106000600574O000700063O00202O0007000700314O000800073O00202O00080008003200122O0009001D6O00060009000200122O000600063O00122O000400043O00044O000102010026BB000500A92O0100010004473O00A92O0100121F000600013O0026AB000600BF2O0100040004473O00BF2O01002E15005C00C12O01005D0004473O00C12O0100121F000500043O0004473O00A92O010026BB000600BB2O0100010004473O00BB2O01002E15005E00EA2O01005F0004473O00EA2O012O00760007000A3O000699000700EA2O013O0004473O00EA2O0100121F000700014O00AA000800093O002E15006000D12O0100610004473O00D12O010026BB000700D12O0100010004473O00D12O0100121F000800014O00AA000900093O00121F000700043O0026BB000700CA2O0100040004473O00CA2O010026BB000800D32O0100010004473O00D32O0100121F000900013O002E15006300D62O0100620004473O00D62O010026BB000900D62O0100010004473O00D62O012O0076000A000B4O001C010A0001000200121A000A00063O00123A010A00063O0006B2000A00E22O0100010004473O00E22O01002E0C0164000A000100650004473O00EA2O0100123A010A00064O0075000A00023O0004473O00EA2O010004473O00D62O010004473O00EA2O010004473O00D32O010004473O00EA2O010004473O00CA2O01002EC8006600FE2O0100670004473O00FE2O012O00760007000C3O000699000700FE2O013O0004473O00FE2O0100121F000700013O0026BB000700F02O0100010004473O00F02O012O00760008000D4O001C01080001000200121A000800063O002E15006800FE2O0100690004473O00FE2O0100123A010800063O000699000800FE2O013O0004473O00FE2O0100123A010800064O0075000800023O0004473O00FE2O010004473O00F02O0100121F000600043O0004473O00BB2O010004473O00A92O01002EC8006B000E0201006A0004473O000E02010026BB0004000E020100210004473O000E02012O00760005000E4O001C01050001000200121A000500063O00123A010500063O0006990005002902013O0004473O0029020100123A010500064O0075000500023O0004473O002902010026BB000400292O0100040004473O00292O0100123A010500063O0006B200050015020100010004473O00150201002E15006D00170201006C0004473O0017020100123A010500064O0075000500024O0076000500013O0020250105000500574O000600063O00202O0006000600294O000700073O00202O00070007002A00122O0008001D6O00050008000200122O000500063O00122O000500063O00062O00050025020100010004473O00250201002E15006F00270201006E0004473O0027020100123A010500064O0075000500023O00121F000400093O0004473O00292O0100121F000300043O0026BB00030068000100040004473O0068000100121F000200043O0004473O006100010004473O006800010004473O006100010004473O000500010004473O003302010004473O000200012O00D23O00017O00603O00028O00025O000C9140025O00FAA240026O00F03F025O00389740025O00B8AE40030C3O0053686F756C6452657475726E025O00208440025O00A0844003083O0049734D6F76696E67027O0040025O00309240025O009C9040025O00CEB140025O00F07F40025O003CA840026O005F40025O0060A140025O00207F4003123O00BBD522E394243F148FFC3AF4921A24138FDF03083O0066EBBA5586E67350030A3O0049734361737461626C6503083O0042752O66446F776E03163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E6703183O00506F776572576F7264466F72746974756465506C6179657203143O004703295A60EB35581E3A6074DB3043052A4A76D103073O0042376C5E3F12B4025O00B88440025O00FEA640025O005CA040025O0008A240025O00249240025O00288240025O00EAAF40025O00C49540030F3O0048616E646C65412O666C6963746564030D3O00506F776572576F72644C69666503163O00506F776572576F72644C6966654D6F7573656F766572026O004440025O00E5B140025O00E6AC40025O00B08840025O00BAAF40025O00308540025O00B0714003063O00507572696679030F3O005075726966794D6F7573656F766572025O0024B340025O00E2A240026O000840030D3O004461726B52657072696D616E6403163O004461726B52657072696D616E644D6F7573656F766572025O00609740025O008BB240026O00104003093O00466C6173684865616C03123O00466C6173684865616C4D6F7573656F766572025O001EA740025O0050A040025O00BAA640025O005C9E40025O00D0744003073O0050656E616E636503103O0050656E616E63654D6F7573656F766572025O00B2A140025O00A09040025O00BAAC40025O0038B040025O008C9340025O002CA44003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O00F6A840025O0063B14003163O0044656164467269656E646C79556E697473436F756E74025O000DB240026O002A4003103O004D612O73526573752O72656374696F6E03113O00198C9624184B119E9025355C17998C382903063O003974EDE55747030C3O00526573752O72656374696F6E025O006CA640026O009940030C3O00B8B4FEF265FC42A9A5E4E87903073O0027CAD18D87178E03123O00CF3C1E0F20CFF0210D2C3DEAEB3A1D1F36FD03063O00989F53696A52025O0087B040025O00889240025O00BEAD40025O0018834003143O0091C946F7DB6396C9432OF65A8ED445FBDD4985C303063O003CE1A63192A900B0012O00121F3O00014O00AA000100013O0026BB3O0002000100010004473O0002000100121F000100013O002EC80002005A000100030004473O005A00010026BB0001005A000100040004473O005A0001002EC800050041000100060004473O004100012O007600025O0006990002004100013O0004473O0041000100121F000200014O00AA000300033O0026BB00020010000100010004473O0010000100121F000300013O0026BB00030013000100010004473O001300012O0076000400013O0006990004002500013O0004473O0025000100121F000400013O000E1700010019000100040004473O001900012O0076000500024O001C01050001000200121A000500073O00123A010500073O0006990005002500013O0004473O0025000100123A010500074O0075000500023O0004473O002500010004473O001900012O0076000400033O0006990004004100013O0004473O0041000100121F000400014O00AA000500053O002EC80008002A000100090004473O002A00010026BB0004002A000100010004473O002A000100121F000500013O0026BB0005002F000100010004473O002F00012O0076000600044O001C01060001000200121A000600073O00123A010600073O0006990006004100013O0004473O0041000100123A010600074O0075000600023O0004473O004100010004473O002F00010004473O004100010004473O002A00010004473O004100010004473O001300010004473O004100010004473O001000012O0076000200053O00205300020002000A2O00420102000200020006990002005900013O0004473O0059000100121F000200014O00AA000300033O000E1700010048000100020004473O0048000100121F000300013O0026BB0003004B000100010004473O004B00012O0076000400064O001C01040001000200121A000400073O00123A010400073O0006990004005900013O0004473O0059000100123A010400074O0075000400023O0004473O005900010004473O004B00010004473O005900010004473O0048000100121F0001000B3O0026AB0001005E000100010004473O005E0001002EC8000C00312O01000D0004473O00312O0100121F000200013O002E15000F00650001000E0004473O006500010026BB00020065000100040004473O0065000100121F000100043O0004473O00312O010026AB00020069000100010004473O00690001002EC80010005F000100110004473O005F0001002EC800130092000100120004473O009200012O0076000300074O0053010400083O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300164O00030002000200062O0003009200013O0004473O009200012O0076000300093O0006990003009200013O0004473O009200012O0076000300053O00203B0003000300174O000500073O00202O0005000500184O000600016O00030006000200062O00030087000100010004473O008700012O00760003000A3O0020630003000300194O000400073O00202O0004000400184O00030002000200062O0003009200013O0004473O009200012O00760003000B4O00760004000C3O00204B00040004001A2O00420103000200020006990003009200013O0004473O009200012O0076000300083O00121F0004001B3O00121F0005001C4O0012000300054O007100036O00760003000D3O0006990003002F2O013O0004473O002F2O0100121F000300014O00AA000400043O0026BB00030097000100010004473O0097000100121F000400013O002E15001D00C70001001E0004473O00C700010026BB000400C7000100040004473O00C7000100121F000500013O0026AB000500A3000100010004473O00A30001002EC8002000C00001001F0004473O00C0000100121F000600013O002E15002200AA000100210004473O00AA00010026BB000600AA000100040004473O00AA000100121F000500043O0004473O00C000010026AB000600AE000100010004473O00AE0001002EC8002300A4000100240004473O00A400012O00760007000A3O0020250107000700254O000800073O00202O0008000800264O0009000C3O00202O00090009002700122O000A00286O0007000A000200122O000700073O00122O000700073O00062O000700BC000100010004473O00BC0001002E15002900BE0001002A0004473O00BE000100123A010700074O0075000700023O00121F000600043O0004473O00A40001002E15002B009F0001002C0004473O009F00010026BB0005009F000100040004473O009F000100121F0004000B3O0004473O00C700010004473O009F00010026AB000400CB000100010004473O00CB0001002E15002D00DC0001002E0004473O00DC00012O00760005000A3O0020250105000500254O000600073O00202O00060006002F4O0007000C3O00202O00070007003000122O000800286O00050008000200122O000500073O00122O000500073O00062O000500D9000100010004473O00D90001002E15003100DB000100320004473O00DB000100123A010500074O0075000500023O00121F000400043O000E17003300EF000100040004473O00EF00012O00760005000A3O0020380005000500254O000600073O00202O0006000600344O0007000C3O00202O00070007003500122O000800286O00050008000200122O000500073O002E2O003600EE000100370004473O00EE000100123A010500073O000699000500EE00013O0004473O00EE000100123A010500074O0075000500023O00121F000400383O0026BB000400032O0100380004473O00032O012O00760005000A3O0020040005000500254O000600073O00202O0006000600394O0007000C3O00202O00070007003A00122O000800286O000900016O00050009000200122O000500073O00122O000500073O00062O00052O002O0100010004474O002O01002E0C013B00310001003C0004473O002F2O0100123A010500074O0075000500023O0004473O002F2O01002E15003E009A0001003D0004473O009A0001000E17000B009A000100040004473O009A000100121F000500013O002E0C013F001D0001003F0004473O00252O010026BB000500252O0100010004473O00252O0100121F000600013O0026BB000600202O0100010004473O00202O012O00760007000A3O0020250107000700254O000800073O00202O0008000800404O0009000C3O00202O00090009004100122O000A00286O0007000A000200122O000700073O00122O000700073O00062O0007001D2O0100010004473O001D2O01002E150042001F2O0100430004473O001F2O0100123A010700074O0075000700023O00121F000600043O0026BB0006000D2O0100040004473O000D2O0100121F000500043O0004473O00252O010004473O000D2O01002E15004400082O0100450004473O00082O010026BB000500082O0100040004473O00082O0100121F000400333O0004473O009A00010004473O00082O010004473O009A00010004473O002F2O010004473O0097000100121F000200043O0004473O005F00010026BB000100050001000B0004473O00050001002EC8004600832O0100470004473O00832O012O00760002000E3O000699000200832O013O0004473O00832O012O00760002000E3O0020530002000200482O0042010200020002000699000200832O013O0004473O00832O012O00760002000E3O0020530002000200492O0042010200020002000699000200832O013O0004473O00832O012O00760002000E3O00205300020002004A2O0042010200020002000699000200832O013O0004473O00832O012O0076000200053O00205300020002004B2O00760004000E4O00DF0002000400020006B2000200832O0100010004473O00832O0100121F000200014O00AA000300043O0026AB000200532O0100040004473O00532O01002EC8004D007D2O01004C0004473O007D2O010026BB000300532O0100010004473O00532O012O00760005000A3O00204B00050005004E2O001C0105000100022O003D010400053O000E4F0104005D2O0100040004473O005D2O01002E0C014F0010000100500004473O006B2O012O00760005000B4O009B000600073O00202O0006000600514O000700076O000800016O00050008000200062O000500832O013O0004473O00832O012O0076000500083O001240010600523O00122O000700536O000500076O00055O00044O00832O012O00760005000B4O0037000600073O00202O0006000600544O000700076O000800016O00050008000200062O000500752O0100010004473O00752O01002E0C01550010000100560004473O00832O012O0076000500083O001240010600573O00122O000700586O000500076O00055O00044O00832O010004473O00532O010004473O00832O010026BB0002004F2O0100010004473O004F2O0100121F000300014O00AA000400043O00121F000200043O0004473O004F2O012O0076000200074O0053010300083O00122O000400593O00122O0005005A6O0003000500024O00020002000300202O0002000200164O00020002000200062O0002009C2O013O0004473O009C2O012O0076000200053O00203B0002000200174O000400073O00202O0004000400184O000500016O00020005000200062O0002009E2O0100010004473O009E2O012O00760002000A3O0020DD0002000200194O000300073O00202O0003000300184O00020002000200062O0002009E2O0100010004473O009E2O01002EC8005B00AF2O01005C0004473O00AF2O012O00760002000B4O00760003000C3O00204B00030003001A2O00420102000200020006B2000200A62O0100010004473O00A62O01002EC8005D00AF2O01005E0004473O00AF2O012O0076000200083O0012400103005F3O00122O000400606O000200046O00025O00044O00AF2O010004473O000500010004473O00AF2O010004473O000200012O00D23O00017O001F3O00028O00025O0030A840025O0049B240025O00149A40025O00649840026O00F03F030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66030D3O0041746F6E656D656E7442752O66026O00344003083O0042752O66446F776E030B3O0042752O6652656D61696E73025O0020AF40025O0046A240025O00D49540025O00D8AF4003063O0042752O66557003073O0052617074757265025O007CA540025O00A2A840030F3O001F11382F1330200C2B19090E2A122B03063O00674F7E4F4A6103073O004973526561647903143O00506F776572576F7264536869656C64466F63757303163O00AA70C4764C25AD70C1776109B276D67F2O5AB27AD27F03063O007ADA1FB3133E03053O0081D3C3C4DE03073O0025D3B6ADA1A9C1030A3O0052656E6577466F637573030A3O00E53F43DC3F3BB1F23B4103073O00D9975A2DB9481B00703O00121F3O00014O00AA000100013O002EC800020002000100030004473O000200010026BB3O0002000100010004473O0002000100121F000100013O002EC800050022000100040004473O00220001000E1700010022000100010004473O0022000100121F000200013O0026BB00020010000100060004473O0010000100121F000100063O0004473O002200010026BB0002000C000100010004473O000C00012O007600035O0020F60003000300084O000400013O00202O0004000400094O000500026O000600073O00122O0008000A6O00030008000200122O000300073O00122O000300073O00062O0003002000013O0004473O0020000100123A010300074O0075000300023O00121F000200063O0004473O000C00010026BB00010007000100060004473O000700012O0076000200033O00208D00020002000B4O000400013O00202O0004000400094O00020004000200062O00020035000100010004473O003500012O0076000200033O0020B800020002000C4O000400013O00202O0004000400094O0002000400024O000300023O00062201020035000100030004473O00350001002EC8000D006F0001000E0004473O006F0001002EC8000F0056000100100004473O005600012O0076000200043O0020390102000200114O000400013O00202O0004000400124O00020004000200062O0002005600013O0004473O00560001002EC80013006F000100140004473O006F00012O0076000200014O0053010300053O00122O000400153O00122O000500166O0003000500024O00020002000300202O0002000200174O00020002000200062O0002006F00013O0004473O006F00012O0076000200064O0076000300073O00204B0003000300182O00420102000200020006990002006F00013O0004473O006F00012O0076000200053O001240010300193O00122O0004001A6O000200046O00025O00044O006F00012O0076000200014O0053010300053O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O0002000200174O00020002000200062O0002006F00013O0004473O006F00012O0076000200064O0076000300073O00204B00030003001D2O00420102000200020006990002006F00013O0004473O006F00012O0076000200053O0012400103001E3O00122O0004001F6O000200046O00025O00044O006F00010004473O000700010004473O006F00010004473O000200012O00D23O00017O006F3O00028O00026O00F03F025O00406D40025O00A07C40025O00DEB140025O00888440025O001EA940025O00D49140025O00D09840025O0008AD4003073O0047657454696D65026O00344003113O0053686F756C645261707475726552616D70025O00207940025O00BAA340025O003AB240025O00349140027O0040025O0062A840025O00FAA040030E3O00F074E61659D45FE80453CD7DE90603053O0036A31C8772030B3O004973417661696C61626C65030D3O000DD65F904F7C2DE855834A703F03063O001F48BB3DE22E030E3O00F00E42D6486907CC1046DC46703003073O0044A36623B2271E030D3O009B7DD8D502B68622B671DEC81403083O0071DE10BAA763D5E3025O0066AB40025O00D0A740026O000840025O00E49E40025O0026A340030F3O00060FE9E5262AF2E52D07EBFA2700FE03043O00964E6E9B03093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66030E3O00B6CD26E5AB099C4F93C029E0AA0A03083O0020E5A54781C47EDF030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66025O0022A240025O00107940030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66030D3O0041746F6E656D656E7442752O66026O001840025O005AAD40025O0096A240025O00408B40025O006C9A40026O001040025O0016AB40025O0028A34003073O00F188D49594C7C603063O00B5A3E9A42OE103073O004973526561647903083O0042752O66446F776E03073O0052617074757265025O00C07040025O0044B340025O00A49740025O00C89D40025O0058A840025O00F3B240025O0096B140025O005EAC40025O00405F40025O0052AE4003113O006084297242BC316554B93F73598A30745503043O001730EB5E03163O00506F776572576F726452616469616E6365466F637573025O0033B240025O00F8904003293O006CD5CF58450CC573C8DC624532D675DBD65E520CDB72C9CC5C59279274DFD9516830DD73D6DC52403D03073O00B21CBAB83D3753025O00C06040025O00E2A240025O007CAA40025O00EC9C40025O0014AD40025O001AA440030B3O0042752O6652656D61696E73025O0079B140025O00EAA940025O00209140025O00D89B40025O0072A240025O00B89840030F3O00F4C25039E039FAD6C97434FB0BF9C003073O0095A4AD275C926E025O004CA740025O0085B040025O006AA04003143O00506F776572576F7264536869656C64466F63757303163O00E328071A0824E428021B2508FB2E15131E5BFB22111303063O007B9347707F7A025O00D6AA4003073O00FECC926553DEC803053O0026ACADE211030C3O0052617074757265466F637573030C3O005F103CFB580329AF45142DE303043O008F2D714C025O0019B140025O00709440025O007FB040025O00A6A040025O00B8AC40025O00C8A14000BE012O00121F3O00014O00AA000100023O0026AB3O0006000100020004473O00060001002E0C010300A72O0100040004473O00AB2O01002E150006002F000100050004473O002F00010026BB0001002F000100010004473O002F000100121F000300014O00AA000400043O0026AB00030010000100010004473O00100001002EC80007000C000100080004473O000C000100121F000400013O0026AB00040015000100010004473O00150001002E0C010900130001000A0004473O0026000100123A0105000B4O001C0105000100022O007600066O00C20002000500060026160102001C0001000C0004473O001C00010004473O0025000100121F000500013O0026BB0005001D000100010004473O001D00012O00FC00065O00121A0006000D3O00121F000600014O000401065O0004473O002500010004473O001D000100121F000400023O0026AB0004002A000100020004473O002A0001002EC8000F00110001000E0004473O0011000100121F000100023O0004473O002F00010004473O001100010004473O002F00010004473O000C00010026AB00010033000100020004473O00330001002E1500100065000100110004473O0065000100121F000300013O0026BB00030038000100020004473O0038000100121F000100123O0004473O006500010026AB0003003C000100010004473O003C0001002E1500130034000100140004473O003400012O0076000400024O0053010500033O00122O000600153O00122O000700166O0005000700024O00040004000500202O0004000400174O00040002000200062O0004004E00013O0004473O004E00012O0076000400024O00CC000500033O00122O000600183O00122O000700196O0005000700024O00040004000500202O0004000400174O0004000200022O0004010400014O0076000400024O0053010500033O00122O0006001A3O00122O0007001B6O0005000700024O00040004000500202O0004000400174O00040002000200062O0004006200013O0004473O006200012O0076000400024O00CC000500033O00122O0006001C3O00122O0007001D6O0005000700024O00040004000500202O0004000400174O0004000200022O0003000400044O0004010400043O00121F000300023O0004473O003400010026BB000100A3000100120004473O00A3000100121F000300013O002EC8001F006E0001001E0004473O006E00010026BB0003006E000100020004473O006E000100121F000100203O0004473O00A300010026BB00030068000100010004473O0068000100121F000400013O000E1700020075000100040004473O0075000100121F000300023O0004473O006800010026AB00040079000100010004473O00790001002E1500220071000100210004473O007100012O0076000500024O0053010600033O00122O000700233O00122O000800246O0006000800024O00050005000600202O0005000500174O00050002000200062O0005008B00013O0004473O008B00012O0076000500063O00204D0005000500254O000700023O00202O0007000700264O00050007000200262O0005008B000100200004473O008B00012O002400056O00FC000500014O0077000500056O000500026O000600033O00122O000700273O00122O000800286O0006000800024O00050005000600202O0005000500294O00050002000200062O0005009A00013O0004473O009A00012O0076000500053O0006B20005009F000100010004473O009F00012O0076000500063O00205300050005002A2O0076000700023O00204B00070007002B2O00DF0005000700022O0004010500073O00121F000400023O0004473O007100010004473O006800010026BB000100C8000100200004473O00C8000100121F000300014O00AA000400043O0026AB000300AB000100010004473O00AB0001002E15002C00A70001002D0004473O00A7000100121F000400013O0026BB000400BF000100010004473O00BF00012O0076000500083O0020C600050005002F4O000600023O00202O00060006003000122O000700316O000800093O00122O000A000C6O0005000A000200122O0005002E3O00122O0005002E3O00062O000500BC000100010004473O00BC0001002EC8003200BE000100330004473O00BE000100123A0105002E4O0075000500023O00121F000400023O0026AB000400C3000100020004473O00C30001002EC8003500AC000100340004473O00AC000100121F000100363O0004473O00C800010004473O00AC00010004473O00C800010004473O00A700010026AB000100CC000100360004473O00CC0001002EC800370006000100380004473O000600012O0076000300024O00CC000400033O00122O000500393O00122O0006003A6O0004000600024O00030003000400202O00030003003B4O0003000200020006B20003004C2O0100010004473O004C2O012O0076000300063O00203901030003003C4O000500023O00202O00050005003D4O00030005000200062O0003004C2O013O0004473O004C2O0100121F000300014O00AA000400043O0026AB000300E3000100010004473O00E30001002EC8003F00DF0001003E0004473O00DF000100121F000400013O0026BB00042O002O0100020004474O002O012O0076000500013O000699000500EC00013O0004473O00EC00012O0076000500073O0006B2000500EE000100010004473O00EE0001002E150041004C2O0100400004473O004C2O0100121F000500013O002E15004200EF000100430004473O00EF00010026BB000500EF000100010004473O00EF00012O0076000600094O001C01060001000200121A0006002E3O00123A0106002E3O0006B2000600FB000100010004473O00FB0001002E0C01440053000100450004473O004C2O0100123A0106002E4O0075000600023O0004473O004C2O010004473O00EF00010004473O004C2O010026BB000400E4000100010004473O00E4000100121F000500014O00AA000600063O0026BB000500042O0100010004473O00042O0100121F000600013O0026BB0006000B2O0100020004473O000B2O0100121F000400023O0004473O00E400010026AB0006000F2O0100010004473O000F2O01002E15004700072O0100460004473O00072O012O0076000700024O0053010800033O00122O000900483O00122O000A00496O0008000A00024O00070007000800202O00070007003B4O00070002000200062O000700282O013O0004473O00282O012O00760007000A4O00290008000B3O00202O00080008004A4O000900096O000A000C6O0007000A000200062O000700232O0100010004473O00232O01002E0C014B00070001004C0004473O00282O012O0076000700033O00121F0008004D3O00121F0009004E4O0012000700094O007100076O0076000700043O0006990007002E2O013O0004473O002E2O012O0076000700073O0006B2000700302O0100010004473O00302O01002E15005000452O01004F0004473O00452O0100121F000700014O00AA000800083O000E17000100322O0100070004473O00322O0100121F000800013O0026AB000800392O0100010004473O00392O01002EC8005100352O0100520004473O00352O012O00760009000D4O001C01090001000200121A0009002E3O00123A0109002E3O000699000900452O013O0004473O00452O0100123A0109002E4O0075000900023O0004473O00452O010004473O00352O010004473O00452O010004473O00322O0100121F000600023O0004473O00072O010004473O00E400010004473O00042O010004473O00E400010004473O004C2O010004473O00DF0001002E15005400BD2O0100530004473O00BD2O012O00760003000E3O00208D00030003003C4O000500023O00202O0005000500304O00030005000200062O0003005C2O0100010004473O005C2O012O00760003000E3O0020A40003000300554O000500023O00202O0005000500304O00030005000200262O000300BD2O0100310004473O00BD2O0100121F000300014O00AA000400053O0026AB000300622O0100020004473O00622O01002E15005600A02O0100570004473O00A02O01002E15005800622O0100590004473O00622O01000E17000100622O0100040004473O00622O0100121F000500013O002EC8005B00672O01005A0004473O00672O010026BB000500672O0100010004473O00672O012O0076000600024O00CC000700033O00122O0008005C3O00122O0009005D6O0007000900024O00060006000700202O00060006003B4O0006000200020006B2000600772O0100010004473O00772O01002E15005F00842O01005E0004473O00842O01002E0C0160000D000100600004473O00842O012O00760006000A4O00760007000B3O00204B0007000700612O0042010600020002000699000600842O013O0004473O00842O012O0076000600033O00121F000700623O00121F000800634O0012000600084O007100065O002E0C01640039000100640004473O00BD2O012O0076000600024O0053010700033O00122O000800653O00122O000900666O0007000900024O00060006000700202O00060006003B4O00060002000200062O000600BD2O013O0004473O00BD2O012O00760006000A4O00760007000B3O00204B0007000700672O0042010600020002000699000600BD2O013O0004473O00BD2O012O0076000600033O001240010700683O00122O000800696O000600086O00065O00044O00BD2O010004473O00672O010004473O00BD2O010004473O00622O010004473O00BD2O01002EC8006B005E2O01006A0004473O005E2O01000E170001005E2O0100030004473O005E2O0100121F000400014O00AA000500053O00121F000300023O0004473O005E2O010004473O00BD2O010004473O000600010004473O00BD2O01002EC8006D00020001006C0004473O000200010026BB3O0002000100010004473O0002000100121F000300013O002EC8006F00B72O01006E0004473O00B72O010026BB000300B72O0100010004473O00B72O0100121F000100014O00AA000200023O00121F000300023O0026BB000300B02O0100020004473O00B02O0100121F3O00023O0004473O000200010004473O00B02O010004473O000200012O00D23O00017O007A3O00028O00026O00F03F025O00B89240025O0077B240027O0040025O0020AA40025O0066B240030F3O00CF2DBA4B2E52EE3FAB51367AEE22AD03063O0016874CC83846030B3O004973417661696C61626C6503093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66026O000840030E3O00BE38F92052F6AE3FEE2153E0832403063O0081ED5098443D030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66025O0099B240025O00907D40025O00FDB040025O0022AC40025O000EA740030E3O008BB01D38B7AF3F33AEBD123DB6AC03043O005C2OD87C030D3O007E3FAE52FC58379F48FC5F3DBB03053O009D3B52CC20030E3O000B36E2FEE6FDF0BE2E3BEDFBE7FE03083O00D1585E839A898AB3030D3O000DACC66E1F20341120A0C0730903083O004248C1A41C7E4351025O0040A040025O0014B040025O00688940025O00606A40025O00508F40025O00B49740025O00B2AF4003073O0047657454696D65026O003440025O00ACAB40025O006FB240025O0063B240025O00B0AB4003143O0053686F756C644576616E67656C69736D52616D70025O008EA040025O00FAAE40026O001040025O0072B340025O0050A440030A3O0074BE05FD1B125458BB0903073O003831C864937C7703073O0049735265616479025O00809C40025O00709940025O0060AB40025O00B6B040025O0010B240025O00849240025O00207F40025O005BB340025O00BC9340026O007D40025O00C2A840025O0084B040025O0028A040030C3O0053686F756C6452657475726E025O00A89140025O0064B340025O00B08340025O00C4A740025O0024A340025O0096B24003083O0042752O66446F776E030D3O0041746F6E656D656E7442752O66030B3O0042752O6652656D61696E73026O001840025O006CA340025O0023B340025O00E9B140025O00A09D40025O00F89340025O0028844003053O0028225C093A03083O008E7A47326C4D8D7B030A3O0052656E6577466F637573030A3O0007A7F11D2C55AAFA193703053O005B75C29F78025O00F6A840025O00804B40030F3O00FC31A8F5DE09B0E2C80DB7F9C932BB03043O0090AC5EDF03143O00506F776572576F7264536869656C64466F63757303163O003400B5423630B548360B9D542C06A74B204FAA42252O03043O0027446FC2025O002AA940026O001C40025O008CA240025O00E8A64003113O00E6A9F0C26B80D9B4E3F578B3DFA7E9C47C03063O00D7B6C687A71903163O00506F776572576F726452616469616E6365466F637573025O0024994003293O009D46FD4D9F76FD479F4DD55A8C4DE349834AEF778447F95C8C47FE08854CEB44B24AE547814DE55F8303043O0028ED298A025O00CAB240030A3O00E262FBF64DC278F3EB4703053O002AA7149A98030A3O004576616E67656C69736D025O0082AA40025O00D4B040030F3O004FE8A34C762446F7B14F31294FFFAE03063O00412A9EC22211025O007C9140025O00E88240025O000EA640025O0062B04003183O00466F637573556E69745265667265736861626C6542752O66025O00309640025O00888340025O008EA940025O0023B04000F5012O00121F3O00014O00AA000100023O0026BB3O00EE2O0100020004473O00EE2O01002EC80003003C000100040004473O003C00010026BB0001003C000100050004473O003C000100121F000300013O002EC800060035000100070004473O003500010026BB00030035000100010004473O003500012O0076000400014O0053010500023O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004001F00013O0004473O001F00012O0076000400033O00204D00040004000B4O000600013O00202O00060006000C4O00040006000200262O0004001F0001000D0004473O001F00012O002400046O00FC000400014O007700048O000400016O000500023O00122O0006000E3O00122O0007000F6O0005000700024O00040004000500202O0004000400104O00040002000200062O0004002E00013O0004473O002E00012O007600045O0006B200040033000100010004473O003300012O0076000400033O0020530004000400112O0076000600013O00204B0006000600122O00DF0004000600022O0004010400043O00121F000300023O002E0C011300D4FF2O00130004473O000900010026BB00030009000100020004473O0009000100121F0001000D3O0004473O003C00010004473O000900010026BB0001007A000100020004473O007A000100121F000300014O00AA000400043O0026AB00030044000100010004473O00440001002EC800150040000100140004473O0040000100121F000400013O002EC800170071000100160004473O007100010026BB00040071000100010004473O007100012O0076000500014O0053010600023O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005005B00013O0004473O005B00012O0076000500014O00CC000600023O00122O0007001A3O00122O0008001B6O0006000800024O00050005000600202O00050005000A4O0005000200022O0004010500054O0076000500014O0053010600023O00122O0007001C3O00122O0008001D6O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005006F00013O0004473O006F00012O0076000500014O00CC000600023O00122O0007001E3O00122O0008001F6O0006000800024O00050005000600202O00050005000A4O0005000200022O0003000500054O0004010500063O00121F000400023O002E1500200045000100210004473O00450001000E1700020045000100040004473O0045000100121F000100053O0004473O007A00010004473O004500010004473O007A00010004473O004000010026AB0001007E000100010004473O007E0001002E15002200B4000100230004473O00B4000100121F000300014O00AA000400043O000E1700010080000100030004473O0080000100121F000400013O0026BB00040087000100020004473O0087000100121F000100023O0004473O00B40001002E0C012400FCFF2O00240004473O008300010026BB00040083000100010004473O0083000100121F000500013O0026AB00050090000100010004473O00900001002EC8002600AA000100250004473O00AA000100123A010600274O001C0106000100022O0076000700074O00C2000200060007000EAF002800A9000100020004473O00A9000100121F000600014O00AA000700073O002EC8002900980001002A0004473O009800010026BB00060098000100010004473O0098000100121F000700013O0026AB000700A1000100010004473O00A10001002E15002B009D0001002C0004473O009D00012O00FC00085O00121A0008002D3O00121F000800014O0004010800073O0004473O00A900010004473O009D00010004473O00A900010004473O0098000100121F000500023O0026AB000500AE000100020004473O00AE0001002EC8002F008C0001002E0004473O008C000100121F000400023O0004473O008300010004473O008C00010004473O008300010004473O00B400010004473O008000010026AB000100B8000100300004473O00B80001002EC8003100BD2O0100320004473O00BD2O012O0076000300014O0053010400023O00122O000500333O00122O000600346O0004000600024O00030003000400202O0003000300354O00030002000200062O000300C400013O0004473O00C40001002E0C0136005F000100370004473O00212O0100121F000300014O00AA000400053O002EC8003800CD000100390004473O00CD00010026BB000300CD000100010004473O00CD000100121F000400014O00AA000500053O00121F000300023O002E15001500C60001003A0004473O00C600010026BB000300C6000100020004473O00C600010026AB000400D5000100010004473O00D50001002E15003B00D10001003C0004473O00D1000100121F000500013O0026AB000500DA000100010004473O00DA0001002E15003D00D60001003E0004473O00D600012O0076000600063O000699000600E000013O0004473O00E000012O0076000600043O0006B2000600E2000100010004473O00E20001002E0C013F0022000100400004473O00022O0100121F000600014O00AA000700083O002E0C01410007000100410004473O00EB0001000E17000100EB000100060004473O00EB000100121F000700014O00AA000800083O00121F000600023O0026BB000600E4000100020004473O00E400010026BB000700ED000100010004473O00ED000100121F000800013O002E0C01423O000100420004473O00F000010026BB000800F0000100010004473O00F000012O0076000900084O001C01090001000200121A000900433O00123A010900433O000699000900022O013O0004473O00022O0100123A010900434O0075000900023O0004473O00022O010004473O00F000010004473O00022O010004473O00ED00010004473O00022O010004473O00E400012O0076000600053O000699000600082O013O0004473O00082O012O0076000600043O0006B20006000A2O0100010004473O000A2O01002E0C01440019000100450004473O00212O0100121F000600013O002EC80046000B2O0100470004473O000B2O010026BB0006000B2O0100010004473O000B2O012O0076000700094O001C01070001000200121A000700433O00123A010700433O0006B2000700172O0100010004473O00172O01002E0C0148000C000100490004473O00212O0100123A010700434O0075000700023O0004473O00212O010004473O000B2O010004473O00212O010004473O00D600010004473O00212O010004473O00D100010004473O00212O010004473O00C600012O00760003000A3O00208D00030003004A4O000500013O00202O00050005004B4O00030005000200062O000300312O0100010004473O00312O012O00760003000A3O00209200030003004C4O000500013O00202O00050005004B4O00030005000200262O000300312O01004D0004473O00312O01002E15004F00F42O01004E0004473O00F42O0100121F000300014O00AA000400053O000E17000100382O0100030004473O00382O0100121F000400014O00AA000500053O00121F000300023O002E15005100332O0100500004473O00332O010026BB000300332O0100020004473O00332O01002EC80053003C2O0100520004473O003C2O010026BB0004003C2O0100010004473O003C2O0100121F000500013O0026BB0005005B2O0100020004473O005B2O01002E0C013D00B10001003D0004473O00F42O012O0076000600014O0053010700023O00122O000800543O00122O000900556O0007000900024O00060006000700202O0006000600354O00060002000200062O000600F42O013O0004473O00F42O012O00760006000B4O00760007000C3O00204B0007000700562O0042010600020002000699000600F42O013O0004473O00F42O012O0076000600023O001240010700573O00122O000800586O000600086O00065O00044O00F42O01000E620001005F2O0100050004473O005F2O01002EC8005900412O01005A0004473O00412O0100121F000600013O000E17000200642O0100060004473O00642O0100121F000500023O0004473O00412O010026BB000600602O0100010004473O00602O012O0076000700014O0053010800023O00122O0009005B3O00122O000A005C6O0008000A00024O00070007000800202O0007000700354O00070002000200062O0007007B2O013O0004473O007B2O012O00760007000B4O00760008000C3O00204B00080008005D2O00420107000200020006990007007B2O013O0004473O007B2O012O0076000700023O00121F0008005E3O00121F0009005F4O0012000700094O007100075O002E0C01600005000100600004473O00802O01002616010200802O0100610004473O00802O010004473O00B52O01002EC80062009C2O0100630004473O009C2O012O0076000700014O0053010800023O00122O000900643O00122O000A00656O0008000A00024O00070007000800202O0007000700354O00070002000200062O0007009C2O013O0004473O009C2O012O00760007000B4O00290008000C3O00202O0008000800664O000900096O000A000D6O0007000A000200062O000700962O0100010004473O00962O01002E15003900B52O0100670004473O00B52O012O0076000700023O001240010800683O00122O000900696O000700096O00075O00044O00B52O01002E0C016A00190001006A0004473O00B52O012O0076000700014O0053010800023O00122O0009006B3O00122O000A006C6O0008000A00024O00070007000800202O0007000700354O00070002000200062O000700B52O013O0004473O00B52O012O00760007000B4O0076000800013O00204B00080008006D2O00420107000200020006B2000700B02O0100010004473O00B02O01002EC8006F00B52O01006E0004473O00B52O012O0076000700023O00121F000800703O00121F000900714O0012000700094O007100075O00121F000600023O0004473O00602O010004473O00412O010004473O00F42O010004473O003C2O010004473O00F42O010004473O00332O010004473O00F42O010026BB000100040001000D0004473O0004000100121F000300014O00AA000400043O002EC8007300C12O0100720004473O00C12O010026BB000300C12O0100010004473O00C12O0100121F000400013O002E15007400E32O0100750004473O00E32O010026BB000400E32O0100010004473O00E32O0100121F000500013O0026BB000500DE2O0100010004473O00DE2O012O00760006000E3O0020510006000600764O000700013O00202O00070007004B00122O0008004D6O0009000A3O00122O000B00286O0006000B000200122O000600433O002E2O007800DD2O0100770004473O00DD2O0100123A010600433O000699000600DD2O013O0004473O00DD2O0100123A010600434O0075000600023O00121F000500023O0026BB000500CB2O0100020004473O00CB2O0100121F000400023O0004473O00E32O010004473O00CB2O01002EC8007900C62O01007A0004473O00C62O010026BB000400C62O0100020004473O00C62O0100121F000100303O0004473O000400010004473O00C62O010004473O000400010004473O00C12O010004473O000400010004473O00F42O010026BB3O0002000100010004473O0002000100121F000100014O00AA000200023O00121F3O00023O0004473O000200012O00D23O00017O006B3O00028O00026O00F03F025O0026AA40025O0014AC40027O0040025O00208440025O00F49840030E3O0029153F1C3AE607150B3B1634FF3003073O00447A7D5E785591030B3O004973417661696C61626C65030D3O003211CD4CC9DABF2414CE5AC7CE03073O00DA777CAF3EA8B9030E3O0096F849C0AAE76BCBB3F546C5ABE403043O00A4C59028030D3O00A6FDA899DCB586C3A28AD9B99403063O00D6E390CAEBBD03073O0047657454696D65025O00C49640025O00BEA040026O003940030E3O0053686F756C64426F746852616D70025O00D49540025O004C9640030F3O00C5A4956818975A2FEEAC977719BD5603083O005C8DC5E71B70D33303093O0042752O66537461636B03133O0048617273684469736369706C696E6542752O66026O000840030E3O00D5F78BA7DEF1DC85B5D4E8FE84B703053O00B1869FEAC3030A3O00432O6F6C646F776E557003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66030D3O0041746F6E656D656E7442752O66026O001840026O003440025O00F4A340025O0004AD40025O00C09640025O00608C40030A3O0098FD3EAECEB8E736B3C403053O00A9DD8B5FC003073O0049735265616479025O0046A840025O00907340025O0006B040025O00E88240025O00449040025O00B09240025O00B88E40025O001AA240025O00BC9940025O002O9040025O00188140025O00209E40025O006DB34003073O00EC8A6F2B3734DB03063O0046BEEB1F5F4203083O0042752O66446F776E03073O0052617074757265025O0061B240025O00B88F40026O002440025O0088AA40025O00A88040025O0066A440025O00A0874003113O008AED0DE3F78DED08E2D7BBE613E7EBB9E703053O0085DA827A8603163O00506F776572576F726452616469616E6365466F63757303293O002CF0F4C1CE9C2F33EDE7FBCEA23C35FEEDC7D99C3132ECF7C5D2B77834FAE2C8E3A03733F3E72OCBAD03073O00585C9F83A4BCC3026O006440025O00BC9040030A3O00A538BE45D0EED1893DB203073O00BDE04EDF2BB78B030A3O004576616E67656C69736D030F3O002BEA8B18C62BF08305CC6EF48F17CD03053O00A14E9CEA76025O00C1B140025O00406D4003053O0095B2C7D9B003043O00BCC7D7A9030A3O0052656E6577466F637573025O00D4A540025O00088D40030A3O00EE0C517EFFBC015A7AE403053O00889C693F1B030B3O0042752O6652656D61696E73025O004C9540026O007840025O00ABB040025O00C9B240030F3O002B836E3109BB76261FBF713D1E807D03043O00547BEC1903143O00506F776572576F7264536869656C64466F63757303163O00E084BD12BE8AE784B81393A6F882AF1BA8F5F88EAB1B03063O00D590EBCA77CC025O0018AB40025O0018AF4003073O001119CE3E3D314803073O002D4378BE4A4843030C3O0052617074757265466F637573030C3O003223FDB1EC9AEBA92827ECA903083O008940428DC599E88E009E012O00121F3O00014O00AA000100023O0026BB3O008F2O0100020004473O008F2O01002E150003004E000100040004473O004E00010026BB0001004E000100010004473O004E000100121F000300013O0026BB0003000D000100050004473O000D000100121F000100023O0004473O004E0001002EC800060039000100070004473O003900010026BB00030039000100020004473O003900012O0076000400014O0053010500023O00122O000600083O00122O000700096O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004002300013O0004473O002300012O0076000400014O00CC000500023O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O00040004000A4O0004000200022O000401046O0076000400014O0053010500023O00122O0006000D3O00122O0007000E6O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004003700013O0004473O003700012O0076000400014O00CC000500023O00122O0006000F3O00122O000700106O0005000700024O00040004000500202O00040004000A4O0004000200022O0003000400044O0004010400033O00121F000300053O0026BB00030009000100010004473O0009000100123A010400114O001C0104000100022O0076000500044O00C2000200040005002EC80012004C000100130004473O004C0001000EAF0014004C000100020004473O004C000100121F000400013O0026BB00040044000100010004473O004400012O00FC00055O00121A000500153O00121F000500014O0004010500043O0004473O004C00010004473O0044000100121F000300023O0004473O000900010026AB00010052000100020004473O00520001002E0C0116003A000100170004473O008A00012O0076000300014O0053010400023O00122O000500183O00122O000600196O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003006400013O0004473O006400012O0076000300063O00204D00030003001A4O000500013O00202O00050005001B4O00030005000200262O000300640001001C0004473O006400012O002400036O00FC000300014O0077000300056O000300016O000400023O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O00030003001F4O00030002000200062O0003007300013O0004473O007300012O0076000300053O0006B200030078000100010004473O007800012O0076000300063O0020530003000300202O0076000500013O00204B0005000500212O00DF0003000500022O0004010300074O0076000300083O0020510003000300234O000400013O00202O00040004002400122O000500256O000600073O00122O000800266O00030008000200122O000300223O002E2O00270089000100280004473O0089000100123A010300223O0006990003008900013O0004473O0089000100123A010300224O0075000300023O00121F000100053O002E15002A0004000100290004473O000400010026BB00010004000100050004473O000400012O0076000300014O0053010400023O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400202O00030003002D4O00030002000200062O0003009A00013O0004473O009A0001002EC8002E00DD0001002F0004473O00DD000100121F000300014O00AA000400043O0026BB0003009C000100010004473O009C000100121F000400013O002EC80031009F000100300004473O009F0001000E170001009F000100040004473O009F0001002EC8003200C0000100330004473O00C000012O0076000500033O000699000500C000013O0004473O00C000012O0076000500073O000699000500C000013O0004473O00C0000100121F000500014O00AA000600063O0026BB000500AD000100010004473O00AD000100121F000600013O002E0C01343O000100340004473O00B000010026BB000600B0000100010004473O00B000012O0076000700094O001C01070001000200121A000700223O00123A010700223O000699000700C000013O0004473O00C0000100123A010700224O0075000700023O0004473O00C000010004473O00B000010004473O00C000010004473O00AD00012O007600055O000699000500C600013O0004473O00C600012O0076000500073O0006B2000500C8000100010004473O00C80001002E0C01350017000100360004473O00DD000100121F000500013O002E15003800C9000100370004473O00C900010026BB000500C9000100010004473O00C900012O00760006000A4O001C01060001000200121A000600223O002EC8003900DD0001003A0004473O00DD000100123A010600223O000699000600DD00013O0004473O00DD000100123A010600224O0075000600023O0004473O00DD00010004473O00C900010004473O00DD00010004473O009F00010004473O00DD00010004473O009C00012O0076000300014O00CC000400023O00122O0005003B3O00122O0006003C6O0004000600024O00030003000400202O00030003002D4O0003000200020006B2000300432O0100010004473O00432O012O0076000300063O00203901030003003D4O000500013O00202O00050005003E4O00030005000200062O000300432O013O0004473O00432O0100121F000300013O002E15004000EF0001003F0004473O00EF00010026BB000300EF000100010004473O00EF0001000E4F014100F7000100020004473O00F70001002EC8004200282O0100430004473O00282O01002E15004500112O0100440004473O00112O012O0076000400014O0053010500023O00122O000600463O00122O000700476O0005000700024O00040004000500202O00040004002D4O00040002000200062O000400112O013O0004473O00112O012O00760004000B4O00440105000C3O00202O0005000500484O000600066O0007000D6O00040007000200062O000400282O013O0004473O00282O012O0076000400023O001240010500493O00122O0006004A6O000400066O00045O00044O00282O01002EC8004B00282O01004C0004473O00282O012O0076000400014O0053010500023O00122O0006004D3O00122O0007004E6O0005000700024O00040004000500202O00040004002D4O00040002000200062O000400282O013O0004473O00282O012O00760004000B4O0076000500013O00204B00050005004F2O0042010400020002000699000400282O013O0004473O00282O012O0076000400023O00121F000500503O00121F000600514O0012000400064O007100045O002EC8005300432O0100520004473O00432O012O0076000400014O0053010500023O00122O000600543O00122O000700556O0005000700024O00040004000500202O00040004002D4O00040002000200062O000400432O013O0004473O00432O012O00760004000B4O00760005000C3O00204B0005000500562O00420104000200020006B20004003C2O0100010004473O003C2O01002EC8005700432O0100580004473O00432O012O0076000400023O001240010500593O00122O0006005A6O000400066O00045O00044O00432O010004473O00EF00012O00760003000E3O00208D00030003003D4O000500013O00202O0005000500244O00030005000200062O000300512O0100010004473O00512O012O00760003000E3O0020A400030003005B4O000500013O00202O0005000500244O00030005000200262O0003009D2O0100250004473O009D2O0100121F000300014O00AA000400043O0026AB000300572O0100010004473O00572O01002EC8005C00532O01005D0004473O00532O0100121F000400013O000E620001005C2O0100040004473O005C2O01002E0C015E00FEFF2O005F0004473O00582O012O0076000500014O0053010600023O00122O000700603O00122O000800616O0006000800024O00050005000600202O00050005002D4O00050002000200062O000500712O013O0004473O00712O012O00760005000B4O00760006000C3O00204B0006000600622O0042010500020002000699000500712O013O0004473O00712O012O0076000500023O00121F000600633O00121F000700644O0012000500074O007100055O002E150065009D2O0100660004473O009D2O012O0076000500014O0053010600023O00122O000700673O00122O000800686O0006000800024O00050005000600202O00050005002D4O00050002000200062O0005009D2O013O0004473O009D2O012O00760005000B4O00760006000C3O00204B0006000600692O00420105000200020006990005009D2O013O0004473O009D2O012O0076000500023O0012400106006A3O00122O0007006B6O000500076O00055O00044O009D2O010004473O00582O010004473O009D2O010004473O00532O010004473O009D2O010004473O000400010004473O009D2O010026BB3O0002000100010004473O0002000100121F000300013O0026BB000300962O0100020004473O00962O0100121F3O00023O0004473O000200010026BB000300922O0100010004473O00922O0100121F000100014O00AA000200023O00121F000300023O0004473O00922O010004473O000200012O00D23O00017O00AD3O00028O00025O00808E40025O0046B340025O0078AB40025O00606840026O001840026O00F03F025O00E88740025O00AC9D40030C3O004570696353652O74696E677303083O00C34A4E93F9415D9403043O00E7902F3A030D3O009ADDDB790C35DC2DBDD6DF5D2803083O0059D2B8BA15785DAF026O001C40025O00808540025O0024AD4003083O007F1BCEB4B94219C903053O00D02C7EBAC003063O00D11BA0C33CCC03083O002E977AC4A6749CA903083O00D6E8520EF2EBEA5503053O009B858D267A030E3O001039A9694A7EA93122BF554071A003073O00C5454ACC212F1F025O00D6AE40025O00889740026O001440025O00709E40025O00E2A54003083O0063EFECDC485EEDEB03053O0021308A98A803073O0047053577C0337703063O005712765031A1025O00A4AF40025O00609F4003083O00862BA0698DBB29A703053O00E4D54ED41D03123O00B25FB321EE945CB317EA93498617EA9E49A403053O008BE72CD66503083O002OEA124A19BF360503083O0076B98F663E70D15103113O0078753AF6A0071D2C59403BE7BC100E106C03083O00583C104986C5757C027O0040025O00D2AF40025O00F08040025O00307840025O0060A84003083O002DC4B4F0B47C19D203063O00127EA1C084DD030E3O006A3BAB26595B318F0A526C27BB0803053O00363F48CE6403083O00FB5C516EEC75CF4A03063O001BA839251A85030D4O00A56AADDA28A4688CD221AB6503053O00B74DCA1CC8025O00A08540025O00A4A04003083O0024369D1C1E3D8E1B03043O00687753E9030D3O00D1F1343246F9DC222056F3FE3403053O002395984742026O000840025O00807A40025O0088A940025O00AC9140025O009EAC4003083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C603113O00A32FBB243707C6852DBA322B0DFD8E2FB903073O008FEB4ED5405B62026O001040025O000AB340025O0010834003083O002AED56A43317EF5103053O005A798822D0030B3O00E307460EC202770BC1084603043O007EA76E3503083O000E153AECD5313A2O03063O005F5D704E98BC030F3O00E9F48B11E8BBF3C7F3891CE7AAD7C503073O00B2A195E57584DE025O001CAC40025O0062A940025O00E5B140025O0028A640025O00188E40025O00C07140025O0032B140025O00B8AB4003083O00BE4D90FD79B88A5B03063O00D6ED28E4891003113O00ACEDFBDC11B490F3FBEE0AB28DD0FBCC0D03063O00C6E5838FB96303083O006289BC675882AF6003043O001331ECC803163O00D739E2B2F6A8EB27E298EAB6E700FEBEF0BFF23EE5A303063O00DA9E5796D784025O00088940025O0086AC4003083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203123O00CCA8AEC29AFEF0B6AEF380FEE0B5B2C884E803063O008C85C6DAA7E8025O0078AD40025O00F08D4003083O00825668C17034B64003063O005AD1331CB51903123O00E07440EBADF97551FBACD97459DBACD17C5203053O00DFB01B378E034O0003083O0017BEDAA12DB5C9A603043O00D544DBAE03133O003BEF34E238EC31791EF32AE824F13E6D0CE53703083O001F6B8043874AA55F03083O00EBEDE85948BFDFFB03063O00D1B8889C2D21030F3O0037C7620DAA2EC6731DAB0EC77B208803053O00D867A81568026O002040025O00A4AB40025O009CAC40026O00224003083O003F38AD3048023AAA03053O00216C5DD94403073O00EB628FACD64EF203043O00CDBB2BC103083O0012D8AE66062FDAA903053O006F41BDDA1203113O006B4E1A390252A873440F3C04528142461E03073O00CF232B7B556B3C03083O0030D536B2810DD73103053O00E863B042C6030A3O00D9322D347A8EF02DE03203083O004C8C4148661BED9903083O0079DF02C6DE0FB95903073O00DE2ABA76B2B76103103O0068FF41A258ED488353EB748549E54B8403043O00EA3D8C24025O0052AE40025O00508140025O00A06940025O0002A540025O00AAA04003083O0043AFB4FE707EADB303053O001910CAC08A030F3O00D5CEACEEA02OFAFBA2F6A0FBF3E39D03063O00949DABCD82C903083O0010D1603DD8F824C703063O009643B41449B103153O00B80B1F7D820F1F5FBA170849AB170859840C0F498803043O002DED787A025O001AA540025O0056AF4003083O00E4EDB638DEE6A53F03043O004CB788C203113O004FF5E0195E481176EFE61E554E0072E3F703073O00741A868558302F025O00907D40025O00E6A64003083O004BA857B071A344B703043O00C418CD2303123O001E84F4033CA2ED003B98EA0920ACF1093B9B03043O00664EEB8303083O00C92B20504E37B02703083O00549A4E54242759D703073O00CDC8785908F8B003053O00659D81363803083O002EAC9EBF2A771ABA03063O00197DC9EACB4303073O0049DD360219224103073O0073199478637447002C022O00121F3O00014O00AA000100013O002E1500020002000100030004473O00020001000E170001000200013O0004473O0002000100121F000100013O002E150005004C000100040004473O004C00010026BB0001004C000100060004473O004C000100121F000200013O0026AB00020010000100070004473O00100001002EC800090021000100080004473O0021000100123A0103000A4O00CE000400013O00122O0005000B3O00122O0006000C6O0004000600024O0003000300044O000400013O00122O0005000D3O00122O0006000E6O0004000600024O00030003000400062O0003001E000100010004473O001E000100121F000300014O000401035O00121F0001000F3O0004473O004C00010026BB0002000C000100010004473O000C000100121F000300013O0026AB00030028000100010004473O00280001002E0C0110001E000100110004473O0044000100123A0104000A4O00CE000500013O00122O000600123O00122O000700136O0005000700024O0004000400054O000500013O00122O000600143O00122O000700156O0005000700024O00040004000500062O00040036000100010004473O0036000100121F000400014O0004010400023O00122F0004000A6O000500013O00122O000600163O00122O000700176O0005000700024O0004000400054O000500013O00122O000600183O00122O000700196O0005000700024O0004000400054O000400033O00122O000300073O002EC8001B00240001001A0004473O00240001000E1700070024000100030004473O0024000100121F000200073O0004473O000C00010004473O002400010004473O000C00010026AB000100500001001C0004473O00500001002EC8001E00820001001D0004473O0082000100121F000200013O0026BB00020061000100070004473O0061000100123A0103000A4O00B9000400013O00122O0005001F3O00122O000600206O0004000600024O0003000300044O000400013O00122O000500213O00122O000600226O0004000600024O0003000300044O000300043O00122O000100063O00044O00820001002EC800240051000100230004473O005100010026BB00020051000100010004473O0051000100123A0103000A4O00B3000400013O00122O000500253O00122O000600266O0004000600024O0003000300044O000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000300053O00122O0003000A6O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000400013O00122O0005002B3O00122O0006002C6O0004000600024O00030003000400062O0003007F000100010004473O007F000100121F000300014O0004010300063O00121F000200073O0004473O005100010026AB000100860001002D0004473O00860001002E15002E00BA0001002F0004473O00BA000100121F000200013O002EC8003000A7000100310004473O00A700010026BB000200A7000100010004473O00A7000100123A0103000A4O00B3000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300073O00122O0003000A6O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O00030003000400062O000300A5000100010004473O00A5000100121F000300014O0004010300083O00121F000200073O0026AB000200AB000100070004473O00AB0001002E15003B00870001003A0004473O0087000100123A0103000A4O00B9000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000300093O00122O000100403O00044O00BA00010004473O008700010026AB000100BE000100400004473O00BE0001002EC8004200F7000100410004473O00F7000100121F000200013O002EC8004300D1000100440004473O00D100010026BB000200D1000100070004473O00D1000100123A0103000A4O00B9000400013O00122O000500453O00122O000600466O0004000600024O0003000300044O000400013O00122O000500473O00122O000600486O0004000600024O0003000300044O0003000A3O00122O000100493O00044O00F70001000E17000100BF000100020004473O00BF000100121F000300013O0026AB000300D8000100010004473O00D80001002EC8004A00F10001004B0004473O00F1000100123A0104000A4O0049000500013O00122O0006004C3O00122O0007004D6O0005000700024O0004000400054O000500013O00122O0006004E3O00122O0007004F6O0005000700024O0004000400054O0004000B3O00122O0004000A6O000500013O00122O000600503O00122O000700516O0005000700024O0004000400054O000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O0004000C3O00122O000300073O0026BB000300D4000100070004473O00D4000100121F000200073O0004473O00BF00010004473O00D400010004473O00BF0001002EC80055003E2O0100540004473O003E2O010026BB0001003E2O0100490004473O003E2O0100121F000200014O00AA000300033O000E620001003O0100020004473O003O01002EC8005600FD000100570004473O00FD000100121F000300013O0026AB000300062O0100010004473O00062O01002E0C01580025000100590004473O00292O0100121F000400013O0026AB0004000B2O0100070004473O000B2O01002E0C015A00040001005B0004473O000D2O0100121F000300073O0004473O00292O010026BB000400072O0100010004473O00072O0100123A0105000A4O00F4000600013O00122O0007005C3O00122O0008005D6O0006000800024O0005000500064O000600013O00122O0007005E3O00122O0008005F6O0006000800024O0005000500064O0005000D3O00122O0005000A6O000600013O00122O000700603O00122O000800616O0006000800024O0005000500064O000600013O00122O000700623O00122O000800636O0006000800024O0005000500064O0005000E3O00122O000400073O00044O00072O010026AB0003002D2O0100070004473O002D2O01002E0C016400D7FF2O00650004473O00022O0100123A0104000A4O00B9000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O000500013O00122O000600683O00122O000700696O0005000700024O0004000400054O0004000F3O00122O0001001C3O00044O003E2O010004473O00022O010004473O003E2O010004473O00FD0001002EC8006B00702O01006A0004473O00702O01000E17000F00702O0100010004473O00702O0100123A0102000A4O00CE000300013O00122O0004006C3O00122O0005006D6O0003000500024O0002000200034O000300013O00122O0004006E3O00122O0005006F6O0003000500024O00020002000300062O000200502O0100010004473O00502O0100121F000200704O0004010200103O0012130102000A6O000300013O00122O000400713O00122O000500726O0003000500024O0002000200034O000300013O00122O000400733O00122O000500746O0003000500024O00020002000300062O0002005F2O0100010004473O005F2O0100121F000200704O0004010200113O0012130102000A6O000300013O00122O000400753O00122O000500766O0003000500024O0002000200034O000300013O00122O000400773O00122O000500786O0003000500024O00020002000300062O0002006E2O0100010004473O006E2O0100121F000200014O0004010200123O00121F000100793O002E15007A00842O01007B0004473O00842O010026BB000100842O01007C0004473O00842O0100123A0102000A4O00CE000300013O00122O0004007D3O00122O0005007E6O0003000500024O0002000200034O000300013O00122O0004007F3O00122O000500806O0003000500024O00020002000300062O000200822O0100010004473O00822O0100121F000200704O0004010200133O0004473O002B02010026BB000100B62O0100010004473O00B62O0100121F000200013O0026BB0002009A2O0100070004473O009A2O0100123A0103000A4O00CE000400013O00122O000500813O00122O000600826O0004000600024O0003000300044O000400013O00122O000500833O00122O000600846O0004000600024O00030003000400062O000300972O0100010004473O00972O0100121F000300704O0004010300143O00121F000100073O0004473O00B62O010026BB000200872O0100010004473O00872O0100123A0103000A4O00F4000400013O00122O000500853O00122O000600866O0004000600024O0003000300044O000400013O00122O000500873O00122O000600886O0004000600024O0003000300044O000300153O00122O0003000A6O000400013O00122O000500893O00122O0006008A6O0004000600024O0003000300044O000400013O00122O0005008B3O00122O0006008C6O0004000600024O0003000300044O000300163O00122O000200073O00044O00872O010026AB000100BA2O0100070004473O00BA2O01002EC8008D00F62O01008E0004473O00F62O0100121F000200014O00AA000300033O002E0C018F3O0001008F0004473O00BC2O010026BB000200BC2O0100010004473O00BC2O0100121F000300013O002E15009100E12O0100900004473O00E12O010026BB000300E12O0100010004473O00E12O0100123A0104000A4O00CE000500013O00122O000600923O00122O000700936O0005000700024O0004000400054O000500013O00122O000600943O00122O000700956O0005000700024O00040004000500062O000400D32O0100010004473O00D32O0100121F000400014O0004010400173O00122F0004000A6O000500013O00122O000600963O00122O000700976O0005000700024O0004000400054O000500013O00122O000600983O00122O000700996O0005000700024O0004000400054O000400183O00122O000300073O002E15009A00C12O01009B0004473O00C12O010026BB000300C12O0100070004473O00C12O0100123A0104000A4O00B9000500013O00122O0006009C3O00122O0007009D6O0005000700024O0004000400054O000500013O00122O0006009E3O00122O0007009F6O0005000700024O0004000400054O000400193O00122O0001002D3O00044O00F62O010004473O00C12O010004473O00F62O010004473O00BC2O01002EC800A00007000100A10004473O000700010026BB00010007000100790004473O0007000100123A0102000A4O00CE000300013O00122O000400A23O00122O000500A36O0003000500024O0002000200034O000300013O00122O000400A43O00122O000500A56O0003000500024O00020002000300062O00020008020100010004473O0008020100121F000200014O00040102001A3O0012130102000A6O000300013O00122O000400A63O00122O000500A76O0003000500024O0002000200034O000300013O00122O000400A83O00122O000500A96O0003000500024O00020002000300062O00020017020100010004473O0017020100121F000200704O00040102001B3O0012130102000A6O000300013O00122O000400AA3O00122O000500AB6O0003000500024O0002000200034O000300013O00122O000400AC3O00122O000500AD6O0003000500024O00020002000300062O00020026020100010004473O0026020100121F000200704O00040102001C3O00121F0001007C3O0004473O000700010004473O002B02010004473O000200012O00D23O00017O00BC3O00028O00025O00E49440025O0078A440026O00F03F030C3O004570696353652O74696E677303083O00B10E4E3F8B055D3803043O004BE26B3A030E3O0079CA1E7414CFC856CA36681ED7DD03073O00AD38BE711A71A203083O00F8DB3911FEC5D93E03053O0097ABBE4D6503143O00F03CFD99F76A0ED718F7BBFC4F0AC126F9A7FB7803073O006BA54F98C9981D027O004003083O00CD7711CBF77C02CC03043O00BF9E126503093O00F5C689B6A12OC6AF8703053O00CFA5A3E7D703083O00F5FCED422D7EC1EA03063O0010A62O993644030B3O00F3A7CF48312CFCDCA7E87603073O0099B2D3A0265441025O00DC9840025O00C3B140025O00804B40026O001840026O001C40025O0028A340025O0090874003083O00C082F5630946F49403063O002893E7811760030A3O0040EB8977BABCC860EA8903073O00BC1598EC25DBCC03083O0073EC231849E7301F03043O006C20895703093O0098E910B23AEB4E719A03083O0039CA8860C64F992B025O00249B40025O004EB24003083O009826BEB384A9FFB803073O0098CB43CAC7EDC7030C3O00C842B01B0A677CC1E84CB51F03083O00869A23C06F7F151903083O008B231D1E29DCBF3503063O00B2D846696A4003073O000D2E74F3DEFDE403083O00E05F4B1A96A9B5B4026O004E40025O00ECA84003083O00F5A60F9DC6C8A40803053O00AFA6C37BE903123O00DAD15879F1E6CC6E5CE0FFD0585AE3E6CD5303053O00908FA23D2903083O00D3D609447B8934F303073O005380B37D3012E703113O006DB6FAD3740B4DA7E1D8540D54B8FDF57703063O007E3DD793BD27025O0068AB40025O00F08240025O0030A440025O0074B34003083O00644BFCDF5D71505D03063O001F372E88AB3403133O00E127CBF1C31FD3E6D51ADDF0D829D2F7D400EC03043O0094B148BC03083O0095B343C7AFB850C003043O00B3C6D63703163O00C003657357E4FF1E762O44D7F90D7C7540F4E203676603063O00B3906C121625026O00204003083O00F5585BC6CF5348C103043O00B2A63D2F03183O00DA5EE774CF33FE44FC49DA2CFE4BEC48CB37FF6DFA75DF2E03063O005E9B2A881AAA026O001440025O00EC9040025O00B8B040025O00C08E40025O00F09740025O00049D40025O00AAA44003083O0031AF92C621D505B903063O00BB62CAE6B248030F3O0004F7A53E4D24EDAD234706F3AB255A03053O002A4181C45003083O00314F49CE1E0905FD03083O008E622A3DBA776762030B3O001EB3031B3097070934973203043O006858DF62025O001AB240025O0018804003083O0077F2F6DA0BE343E403063O008D249782AE6203103O00A276C31E8C52C70C8849D71F837FEA3D03043O006DE41AA203083O006DE0E96CE9E859F603063O00863E859D188003123O0021A91BCA2799D306A938D021B5DF09A232E903073O00B667C57AB94FD1025O001C9140025O00FCA74003083O0037AEA6285107DA1703073O00BD64CBD25C386903163O000E45F2262A5CF8263B62ED3A2A50F91A2A57EF2D3C5903043O00484F319D03083O00BBB525A881BE36AF03043O00DCE8D05103193O00D4AAEA3E2957A4FBAAD6203E5FA0F18EE422384386E7B1F02003073O00C195DE85504C3A03083O0038DFCC3C4DA2711803073O00166BBAB84824CC03113O00D7B2334B1CD0B2364A3DEFB421420ACF8D03053O006E87DD442E03083O00D03318FFC7BD3CF003073O005B83566C8BAED303153O00CB24AF124FCC24AA136EF322BD1B59CF2AB61C75CB03053O003D9B4BD877026O000840025O00ACAF40025O00A89E40025O00B88240025O00D0954003083O008718369E4C8D06A703073O0061D47D42EA25E303113O00A6F6BB3C1085F6A5171F98F1BF300CA2D303053O007EEA83D65503083O00B7D05D4E468AD25A03053O002FE4B5293A03143O008AE9D4320D3F0AB5DED82911391AB4DBCB34162003073O007FC69CB95B6350025O00C6A340025O0054AF4003083O00C61FD8E4AE053ECD03083O00BE957AAC90C76B5903073O000716F4D6FF3E0A03053O009E5265919E03083O0043FB16024D7EF91103053O0024109E627603063O00E817CFF470D803083O0085A076A39B388847025O00DAB240025O00DCAA40025O0046AE40025O000C9840026O001040025O0030AC40025O002FB340025O0020AB40025O00C0554003083O00BE79F93F8472EA3803043O004BED1C8D030F3O00EC50DBB43D2CE8F3D873C5B72A33D703083O0081BC3FACD14F7B8703083O0073E1F2D949EAE1DE03043O00AD20848603123O007B080DC3BB3CC440141DFC8C30DF5C120DFD03073O00AD2E7B688FCE51025O002C9F40025O00B8984003083O004BFA095171F11A5603043O0025189F7D03143O00EAA77C4CE9B36552C8A36651D3A97B77C9A7724703043O0022BAC615034O0003083O00CB0DD149CBF60FD603053O00A29868A53D03103O00F83CB74D7FF2C83D8572622OE126B47803063O0085AD4FD21D1003083O00C5A765E6BF11B2E503073O00D596C21192D67F03093O00332OA8DB61B6AD230B03083O00567BC9C4B426C4C203083O00C4EDCDBBFEE6DEBC03043O00CF9788B9030D3O009D902DA67D6E78A6861B96756A03073O0011C8E348E21418025O001CA840025O0080544003083O0083440FC3C0FFE8EC03083O009FD0217BB7A9918F030D3O00C7493D13E45B3631F7563125FF03043O0056923A5803083O006BDAFED4A7E731E903083O009A38BF8AA0CE8956030C3O00A34FF4897B3F8DC59554DDB703083O00ACE63995E71C5AE1025O0009B240025O008C924000B3022O00121F3O00014O00AA000100013O0026BB3O0002000100010004473O0002000100121F000100013O0026AB00010009000100010004473O00090001002EC800030050000100020004473O0050000100121F000200013O0026BB00020028000100040004473O0028000100123A010300054O00CE000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O00030003000400062O0003001A000100010004473O001A000100121F000300014O000401035O00122F000300056O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000300023O00122O0002000E3O0026BB00020049000100010004473O0049000100123A010300054O00CE000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600024O00030003000400062O00030038000100010004473O0038000100121F000300014O0004010300033O001213010300056O000400013O00122O000500133O00122O000600146O0004000600024O0003000300044O000400013O00122O000500153O00122O000600166O0004000600024O00030003000400062O00030047000100010004473O0047000100121F000300014O0004010300043O00121F000200043O0026AB0002004D0001000E0004473O004D0001002E0C011700BFFF2O00180004473O000A000100121F000100043O0004473O005000010004473O000A0001002E0C01190055000100190004473O00A500010026BB000100A50001001A0004473O00A5000100121F000200013O0026BB000200590001000E0004473O0059000100121F0001001B3O0004473O00A500010026BB00020081000100010004473O0081000100121F000300013O000E6200010060000100030004473O00600001002EC8001C007C0001001D0004473O007C000100123A010400054O00B3000500013O00122O0006001E3O00122O0007001F6O0005000700024O0004000400054O000500013O00122O000600203O00122O000700216O0005000700024O0004000400054O000400053O00122O000400056O000500013O00122O000600223O00122O000700236O0005000700024O0004000400054O000500013O00122O000600243O00122O000700256O0005000700024O00040004000500062O0004007A000100010004473O007A000100121F000400014O0004010400063O00121F000300043O0026BB0003005C000100040004473O005C000100121F000200043O0004473O008100010004473O005C00010026AB00020085000100040004473O00850001002EC800270055000100260004473O0055000100123A010300054O00CE000400013O00122O000500283O00122O000600296O0004000600024O0003000300044O000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400062O00030093000100010004473O0093000100121F000300014O0004010300073O001213010300056O000400013O00122O0005002C3O00122O0006002D6O0004000600024O0003000300044O000400013O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400062O000300A2000100010004473O00A2000100121F000300014O0004010300083O00121F0002000E3O0004473O005500010026AB000100A9000100040004473O00A90001002EC8003100F2000100300004473O00F2000100121F000200013O000E17000400C8000100020004473O00C8000100123A010300054O00B3000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300093O00122O000300056O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O00030003000400062O000300C6000100010004473O00C6000100121F000300014O00040103000A3O00121F0002000E3O002EC8003B00CE0001003A0004473O00CE00010026BB000200CE0001000E0004473O00CE000100121F0001000E3O0004473O00F20001002E15003C00AA0001003D0004473O00AA00010026BB000200AA000100010004473O00AA000100123A010300054O00CE000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000400013O00122O000500403O00122O000600416O0004000600024O00030003000400062O000300E0000100010004473O00E0000100121F000300014O00040103000B3O001213010300056O000400013O00122O000500423O00122O000600436O0004000600024O0003000300044O000400013O00122O000500443O00122O000600456O0004000600024O00030003000400062O000300EF000100010004473O00EF000100121F000300014O00040103000C3O00121F000200043O0004473O00AA0001000E17004600042O0100010004473O00042O0100123A010200054O00CE000300013O00122O000400473O00122O000500486O0003000500024O0002000200034O000300013O00122O000400493O00122O0005004A6O0003000500024O00020002000300062O000200022O0100010004473O00022O0100121F000200014O00040102000D3O0004473O00B202010026AB000100082O01004B0004473O00082O01002E15004D005E2O01004C0004473O005E2O0100121F000200014O00AA000300033O002EC8004E000A2O01004F0004473O000A2O010026BB0002000A2O0100010004473O000A2O0100121F000300013O000E62000100132O0100030004473O00132O01002E15005100322O0100500004473O00322O0100123A010400054O00CE000500013O00122O000600523O00122O000700536O0005000700024O0004000400054O000500013O00122O000600543O00122O000700556O0005000700024O00040004000500062O000400212O0100010004473O00212O0100121F000400014O00040104000E3O001213010400056O000500013O00122O000600563O00122O000700576O0005000700024O0004000400054O000500013O00122O000600583O00122O000700596O0005000700024O00040004000500062O000400302O0100010004473O00302O0100121F000400014O00040104000F3O00121F000300043O0026AB000300362O0100040004473O00362O01002EC8005A00552O01005B0004473O00552O0100123A010400054O00CE000500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O00040004000500062O000400442O0100010004473O00442O0100121F000400014O0004010400103O001213010400056O000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O00040004000500062O000400532O0100010004473O00532O0100121F000400014O0004010400113O00121F0003000E3O002EC80064000F2O0100650004473O000F2O010026BB0003000F2O01000E0004473O000F2O0100121F0001001A3O0004473O005E2O010004473O000F2O010004473O005E2O010004473O000A2O010026BB000100A82O01001B0004473O00A82O0100121F000200013O0026BB000200652O01000E0004473O00652O0100121F000100463O0004473O00A82O010026BB000200862O0100040004473O00862O0100123A010300054O00CE000400013O00122O000500663O00122O000600676O0004000600024O0003000300044O000400013O00122O000500683O00122O000600696O0004000600024O00030003000400062O000300752O0100010004473O00752O0100121F000300014O0004010300123O001213010300056O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000400013O00122O0005006C3O00122O0006006D6O0004000600024O00030003000400062O000300842O0100010004473O00842O0100121F000300014O0004010300133O00121F0002000E3O0026BB000200612O0100010004473O00612O0100123A010300054O00CE000400013O00122O0005006E3O00122O0006006F6O0004000600024O0003000300044O000400013O00122O000500703O00122O000600716O0004000600024O00030003000400062O000300962O0100010004473O00962O0100121F000300014O0004010300143O001213010300056O000400013O00122O000500723O00122O000600736O0004000600024O0003000300044O000400013O00122O000500743O00122O000600756O0004000600024O00030003000400062O000300A52O0100010004473O00A52O0100121F000300014O0004010300153O00121F000200043O0004473O00612O010026AB000100AC2O0100760004473O00AC2O01002E0C01770057000100780004473O0001020100121F000200013O002EC8007900D02O01007A0004473O00D02O010026BB000200D02O0100010004473O00D02O0100123A010300054O00CE000400013O00122O0005007B3O00122O0006007C6O0004000600024O0003000300044O000400013O00122O0005007D3O00122O0006007E6O0004000600024O00030003000400062O000300BF2O0100010004473O00BF2O0100121F000300014O0004010300163O001213010300056O000400013O00122O0005007F3O00122O000600806O0004000600024O0003000300044O000400013O00122O000500813O00122O000600826O0004000600024O00030003000400062O000300CE2O0100010004473O00CE2O0100121F000300014O0004010300173O00121F000200043O0026BB000200FA2O0100040004473O00FA2O0100121F000300013O002E15008300F32O0100840004473O00F32O010026BB000300F32O0100010004473O00F32O0100123A010400054O00B3000500013O00122O000600853O00122O000700866O0005000700024O0004000400054O000500013O00122O000600873O00122O000700886O0005000700024O0004000400054O000400183O00122O000400056O000500013O00122O000600893O00122O0007008A6O0005000700024O0004000400054O000500013O00122O0006008B3O00122O0007008C6O0005000700024O00040004000500062O000400F12O0100010004473O00F12O0100121F000400014O0004010400193O00121F000300043O0026AB000300F72O0100040004473O00F72O01002E15008D00D32O01008E0004473O00D32O0100121F0002000E3O0004473O00FA2O010004473O00D32O01002EC8009000AD2O01008F0004473O00AD2O010026BB000200AD2O01000E0004473O00AD2O0100121F000100913O0004473O000102010004473O00AD2O010026AB000100050201000E0004473O00050201002EC800930059020100920004473O0059020100121F000200014O00AA000300033O000E1700010007020100020004473O0007020100121F000300013O0026BB0003000E0201000E0004473O000E020100121F000100763O0004473O005902010026BB00030036020100040004473O0036020100121F000400013O000E1700040015020100040004473O0015020100121F0003000E3O0004473O003602010026AB00040019020100010004473O00190201002E1500940011020100950004473O0011020100123A010500054O00CE000600013O00122O000700963O00122O000800976O0006000800024O0005000500064O000600013O00122O000700983O00122O000800996O0006000800024O00050005000600062O00050027020100010004473O0027020100121F000500014O00040105001A3O00122F000500056O000600013O00122O0007009A3O00122O0008009B6O0006000800024O0005000500064O000600013O00122O0007009C3O00122O0008009D6O0006000800024O0005000500064O0005001B3O00122O000400043O0004473O001102010026AB0003003A020100010004473O003A0201002EC8009E000A0201009F0004473O000A020100123A010400054O00CE000500013O00122O000600A03O00122O000700A16O0005000700024O0004000400054O000500013O00122O000600A23O00122O000700A36O0005000700024O00040004000500062O00040048020100010004473O0048020100121F000400A44O00040104001C3O00122F000400056O000500013O00122O000600A53O00122O000700A66O0005000700024O0004000400054O000500013O00122O000600A73O00122O000700A86O0005000700024O0004000400054O0004001D3O00122O000300043O0004473O000A02010004473O005902010004473O000702010026BB00010005000100910004473O0005000100121F000200014O00AA000300033O0026BB0002005D020100010004473O005D020100121F000300013O0026BB00030086020100010004473O0086020100121F000400013O000E1700010081020100040004473O0081020100123A010500054O00CE000600013O00122O000700A93O00122O000800AA6O0006000800024O0005000500064O000600013O00122O000700AB3O00122O000800AC6O0006000800024O00050005000600062O00050073020100010004473O0073020100121F000500014O00040105001E3O00122F000500056O000600013O00122O000700AD3O00122O000800AE6O0006000800024O0005000500064O000600013O00122O000700AF3O00122O000800B06O0006000800024O0005000500064O0005001F3O00122O000400043O0026BB00040063020100040004473O0063020100121F000300043O0004473O008602010004473O00630201002EC800B200A6020100B10004473O00A602010026BB000300A6020100040004473O00A6020100123A010400054O00B3000500013O00122O000600B33O00122O000700B46O0005000700024O0004000400054O000500013O00122O000600B53O00122O000700B66O0005000700024O0004000400054O000400203O00122O000400056O000500013O00122O000600B73O00122O000700B86O0005000700024O0004000400054O000500013O00122O000600B93O00122O000700BA6O0005000700024O00040004000500062O000400A4020100010004473O00A4020100121F000400014O0004010400213O00121F0003000E3O0026AB000300AA0201000E0004473O00AA0201002E1500BB0060020100BC0004473O0060020100121F0001004B3O0004473O000500010004473O006002010004473O000500010004473O005D02010004473O000500010004473O00B202010004473O000200012O00D23O00017O00DD3O00028O00030C3O004570696353652O74696E677303073O00B03021B2883A3503043O00D5E45F462O033O0025B4C103053O00174ADBA2E403073O000DE941A8373CF503053O005B598626CF2O033O0047EADB03073O0047248EA85673B003073O00EBAE75B80FBB4503083O0029BFC112DF63DE3603063O00AF2FD43AAFA703053O00CACB46A74A03073O00180EDB347D291203053O00114C61BC5303043O009726D42703083O00C3E547B95750E32B026O00F03F025O005CB140026O000840025O00608C40025O00BC9440027O004003073O00D4F30757E3E5EF03053O008F809C603003063O00ABC1E21716BC03053O0077D8B19072025O002CA340025O00F09440025O003EB240025O00E49F40026O00144003083O0042752O66446F776E030C3O0053757267656F664C69676874025O00FC9840025O007AB340030C3O0049734368612O6E656C696E67025O00DCAB40025O00E3B040030F3O00412O66656374696E67436F6D626174030C3O0053686F756C6452657475726E025O00808C40025O00B2A040025O0095B240025O0057B040025O0042A840025O00ECA540025O0008B340025O00F8A040025O00EAA140025O002EAB40025O00609440025O0016A540025O00E88740025O00188940025O00D88840025O00589C40025O00C2AB40025O004C9340025O00DAAB40025O00405140025O00A8A040025O00A08840025O00EC9B40025O00909240025O00509840025O00AAA840025O00F2AD40025O00F49340025O00088740025O00C05840026O007E40025O00E09940025O00849040025O00649440026O001040025O0018A040025O00D6A640025O0035B240025O0040794003063O0042752O66557003123O00536861646F77436F76656E616E7442752O66030A3O000C0934D2EF5CD4F72B1F03083O0093446858BDBC34B503043O00328987DF03043O00B07AE8EB03153O0052616469616E7450726F766964656E636542752O66030D3O0023F1F6A172CE17E2EDA741C52O03063O00AB679084CA2003073O00202AE70D1E2CEC03043O006C704F8903103O001BCB6221A304DA213ED04720AC05E62203083O00555FA21448CD6189030A3O00D3F43CD503FDFEE3FC3803073O00AD979D4ABC6D98025O001CAE40025O003CB14003163O00476574456E656D696573496E4D656C2O6552616E6765026O003840026O004540025O009EA040025O0091B240025O00C89640025O00089840025O00C2A340025O00F8A940025O0026B340025O00607E40025O00349340025O007AA240025O0020874003083O004973496E5261696403093O004973496E5061727479025O001CA640025O00B09040025O00B4AE40025O00F08E40025O00E08040025O0046B240025O00CAA54003053O00706169727303103O0052616D705261707475726554696D657303073O00FB28E956DC3BFC03043O0022A94999030F3O00432O6F6C646F776E52656D61696E73030A3O00436F6D62617454696D65025O00888140025O00E0A840026O00364003133O0052616D704576616E67656C69736D54696D6573030A3O008FFA0A85ADE90782B9E103043O00EBCA8C6B025O0062A640025O008C9B40025O00CAA640025O0055B040025O00349240025O007CAC40030D3O0052616D70426F746854696D6573025O0028A24003073O003E7524BCFC35F203083O00A56C1454C8894797030A3O005FA22A867DB1278169B903043O00E81AD44B025O00189440025O001AAE40025O0082AD40025O0056AF40031A3O00467269656E646C79556E6974735769746842752O66436F756E74030D3O0041746F6E656D656E7442752O66025O00A7B040025O00FAA740025O00FEAA40025O00E88D4003073O005365744356617203083O0005487FF8D401486003053O00975729128803073O0069AEDAC4EB49AA03053O009E3BCFAAB003073O0049735265616479030E3O004973497454696D65546F52616D70025O0021B24003083O007D5F3E59AF795F2103053O00EC2F3E5329025O00088940025O00207A40025O00BEA040025O007AA840025O0008AA40025O00249D40030A3O00DFBF2135AD87F6A0333603063O00E29AC9405BCA025O00C4B240025O00808340025O00288640025O00C8AF40025O00608440026O008440025O00249940025O000FB34003083O00F3481008698AC05B03063O00DCA1297D782A025O0088AD40025O00709D40030A3O009967A100BB74AC07AF7C03043O006EDC11C003073O004678240EFE25F403083O00C71419547A8B5791025O005FB140025O00F6AF4003083O007508D0BE38DC461B03063O008A2769BDCE7B025O00F8A540025O0029B140025O0086AB40025O00149B40025O00805A40025O007CA340025O00A06C40030D3O004973446561644F7247686F737403093O0049734D6F756E746564025O00FAAA40026O003740025O00E8A540025O006DB14003083O0049734D6F76696E67025O00405640025O00307A4003073O0047657454696D65025O0031B040025O00B4934003063O002F129B24F5E003083O009F7F67E94D9399AF03093O00466F637573556E6974026O003440025O00088140030A3O00456E656D69657334307903113O00476574456E656D696573496E52616E6765026O004440026O00284000BB042O00121F3O00014O00AA000100053O0026BB3O0039000100010004473O003900012O007600066O00C00006000100014O000600016O00060001000100122O000600026O000700033O00122O000800033O00122O000900046O0007000900024O0006000600074O000700033O00122O000800053O00122O000900066O0007000900024O0006000600074O000600023O00122O000600026O000700033O00122O000800073O00122O000900086O0007000900024O0006000600074O000700033O00122O000800093O00122O0009000A6O0007000900024O0006000600074O000600043O00122O000600026O000700033O00122O0008000B3O00122O0009000C6O0007000900024O0006000600074O000700033O00122O0008000D3O00122O0009000E6O0007000900024O0006000600074O000600053O00122O000600026O000700033O00122O0008000F3O00122O000900106O0007000900024O0006000600074O000700033O00122O000800113O00122O000900126O0007000900024O0006000600074O000600063O00124O00133O0026BB3O0072000100130004473O0072000100121F000600014O00AA000700073O002E0C01143O000100140004473O003D00010026BB0006003D000100010004473O003D000100121F000700013O0026AB00070046000100150004473O00460001002EC800170048000100160004473O0048000100121F3O00183O0004473O00720001000E1700010058000100070004473O0058000100123A010800024O00A0000900033O00122O000A00193O00122O000B001A6O0009000B00024O0008000800094O000900033O00122O000A001B3O00122O000B001C6O0009000B00024O0008000800094O000800076O000100073O00122O000700133O002E15001E006A0001001D0004473O006A00010026BB0007006A000100180004473O006A000100121F000800013O0026BB00080063000100010004473O006300012O00FC00046O00FC00096O0004010900083O00121F000800133O0026AB00080067000100130004473O00670001002E15001F005D000100200004473O005D000100121F000700153O0004473O006A00010004473O005D00010026BB00070042000100130004473O004200012O00FC00026O00FC00035O00121F000700183O0004473O004200010004473O007200010004473O003D00010026BB3O007B2O0100210004473O007B2O012O00760006000A3O0020480106000600224O0008000B3O00202O0008000800234O0006000800024O000600093O002E2O002400BA040100250004473O00BA04012O00760006000A3O0020530006000600262O00420106000200020006B2000600BA040100010004473O00BA0401002E15002700082O0100280004473O00082O012O00760006000A3O0020530006000600292O0042010600020002000699000600082O013O0004473O00082O0100121F000600014O00AA000700073O0026BB0006008A000100010004473O008A000100121F000700013O000E17000100B8000100070004473O00B8000100121F000800013O0026BB00080094000100130004473O0094000100121F000700133O0004473O00B800010026BB00080090000100010004473O00900001000699000100A500013O0004473O00A5000100121F000900013O0026BB00090099000100010004473O009900012O0076000A000C4O001C010A0001000200121A000A002A3O00123A010A002A3O000699000A00A500013O0004473O00A5000100123A010A002A4O0075000A00023O0004473O00A500010004473O00990001000699000200B600013O0004473O00B6000100121F000900013O000E17000100A8000100090004473O00A800012O0076000A000D4O001C010A0001000200121A000A002A3O002E15002B00B60001002C0004473O00B6000100123A010A002A3O000699000A00B600013O0004473O00B6000100123A010A002A4O0075000A00023O0004473O00B600010004473O00A8000100121F000800133O0004473O009000010026AB000700BC000100180004473O00BC0001002EC8002D00C70001002E0004473O00C700012O00760008000E4O001C01080001000200121A0008002A3O00123A0108002A3O0006B2000800C4000100010004473O00C40001002EC8002F00BA040100300004473O00BA040100123A0108002A4O0075000800023O0004473O00BA0401000E170013008D000100070004473O008D000100121F000800013O0026BB000800CE000100130004473O00CE000100121F000700183O0004473O008D00010026BB000800CA000100010004473O00CA0001000699000300E900013O0004473O00E9000100121F000900014O00AA000A000A3O0026BB000900D4000100010004473O00D4000100121F000A00013O0026AB000A00DB000100010004473O00DB0001002E15003100D7000100320004473O00D700012O0076000B000F4O001C010B0001000200121A000B002A3O002E15003300E9000100340004473O00E9000100123A010B002A3O000699000B00E900013O0004473O00E9000100123A010B002A4O0075000B00023O0004473O00E900010004473O00D700010004473O00E900010004473O00D400010006B2000400ED000100010004473O00ED0001002EC8003600022O0100350004473O00022O0100121F000900014O00AA000A000A3O0026BB000900EF000100010004473O00EF000100121F000A00013O000E17000100F20001000A0004473O00F200012O0076000B00104O001C010B0001000200121A000B002A3O00123A010B002A3O0006B2000B00FC000100010004473O00FC0001002EC8003800022O0100370004473O00022O0100123A010B002A4O0075000B00023O0004473O00022O010004473O00F200010004473O00022O010004473O00EF000100121F000800133O0004473O00CA00010004473O008D00010004473O00BA04010004473O008A00010004473O00BA04012O0076000600023O000699000600BA04013O0004473O00BA040100121F000600014O00AA000700083O0026AB000600112O0100010004473O00112O01002E15003A00142O0100390004473O00142O0100121F000700014O00AA000800083O00121F000600133O0026BB0006000D2O0100130004473O000D2O010026BB000700162O0100010004473O00162O0100121F000800013O000E17000100402O0100080004473O00402O0100121F000900014O00AA000A000A3O0026BB0009001D2O0100010004473O001D2O0100121F000A00013O0026AB000A00242O0100130004473O00242O01002E15003B00262O01003C0004473O00262O0100121F000800133O0004473O00402O010026BB000A00202O0100010004473O00202O010006B20001002C2O0100010004473O002C2O01002E0C013D000F0001003E0004473O00392O0100121F000B00013O0026BB000B002D2O0100010004473O002D2O012O0076000C000C4O001C010C0001000200121A000C002A3O00123A010C002A3O000699000C00392O013O0004473O00392O0100123A010C002A4O0075000C00023O0004473O00392O010004473O002D2O012O0076000B00114O001C010B0001000200121A000B002A3O00121F000A00133O0004473O00202O010004473O00402O010004473O001D2O010026AB000800442O0100130004473O00442O01002E15003F006B2O0100400004473O006B2O0100121F000900014O00AA000A000A3O0026BB000900462O0100010004473O00462O0100121F000A00013O0026BB000A00622O0100010004473O00622O0100121F000B00013O002EC8004200522O0100410004473O00522O01000E17001300522O01000B0004473O00522O0100121F000A00133O0004473O00622O01002EC80043004C2O0100440004473O004C2O010026BB000B004C2O0100010004473O004C2O01002E150046005D2O0100450004473O005D2O0100123A010C002A3O000699000C005D2O013O0004473O005D2O0100123A010C002A4O0075000C00024O0076000C00124O001C010C0001000200121A000C002A3O00121F000B00133O0004473O004C2O01002EC8004800492O0100470004473O00492O010026BB000A00492O0100130004473O00492O0100121F000800183O0004473O006B2O010004473O00492O010004473O006B2O010004473O00462O010026AB0008006F2O0100180004473O006F2O01002EC8004A00192O0100490004473O00192O0100123A0109002A3O000699000900BA04013O0004473O00BA040100123A0109002A4O0075000900023O0004473O00BA04010004473O00192O010004473O00BA04010004473O00162O010004473O00BA04010004473O000D2O010004473O00BA0401002EC8004B00180201004C0004473O001802010026BB3O00180201004D0004473O0018020100121F000600014O00AA000700073O0026BB000600812O0100010004473O00812O0100121F000700013O002EC8004E008A2O01004F0004473O008A2O010026BB0007008A2O0100150004473O008A2O0100121F3O00213O0004473O001802010026AB0007008E2O0100180004473O008E2O01002EC8005000B32O0100510004473O00B32O0100121F000800013O000E17001300932O0100080004473O00932O0100121F000700153O0004473O00B32O010026BB0008008F2O0100010004473O008F2O012O00760009000A3O0020390109000900524O000B000B3O00202O000B000B00534O0009000B000200062O000900A42O013O0004473O00A42O012O00760009000B4O0017010A00033O00122O000B00543O00122O000C00556O000A000C00024O00090009000A00062O000900AA2O0100010004473O00AA2O012O00760009000B4O00DC000A00033O00122O000B00563O00122O000C00576O000A000C00024O00090009000A2O0004010900134O002E0109000A3O00202O0009000900224O000B000B3O00202O000B000B00584O0009000B00024O000900143O00122O000800133O00044O008F2O01000E17001300E22O0100070004473O00E22O012O00760008000A3O0020390108000800524O000A000B3O00202O000A000A00534O0008000A000200062O000800C42O013O0004473O00C42O012O00760008000B4O0017010900033O00122O000A00593O00122O000B005A6O0009000B00024O00080008000900062O000800CA2O0100010004473O00CA2O012O00760008000B4O00DC000900033O00122O000A005B3O00122O000B005C6O0009000B00024O0008000800092O0004010800154O00510108000A3O00202O0008000800524O000A000B3O00202O000A000A00534O0008000A000200062O000800DA2O013O0004473O00DA2O012O00760008000B4O0017010900033O00122O000A005D3O00122O000B005E6O0009000B00024O00080008000900062O000800E02O0100010004473O00E02O012O00760008000B4O00DC000900033O00122O000A005F3O00122O000B00606O0009000B00024O0008000800092O0004010800163O00121F000700183O0026AB000700E62O0100010004473O00E62O01002EC8006200842O0100610004473O00842O012O00760008000A3O0020DE00080008006300122O000A00646O0008000A00024O000800173O00122O000800016O000900093O0026AB000800F12O0100010004473O00F12O01002E0C016500FEFF2O00660004473O00ED2O0100121F000900013O002EC8006800F22O0100670004473O00F22O010026BB000900F22O0100010004473O00F22O012O0076000A00194O0052010A000A6O000A00186O000A00176O000A000A6O000A001A3O00044O001402010004473O00F22O010004473O001402010004473O00ED2O010004473O0014020100121F000800014O00AA000900093O0026AB00080007020100010004473O00070201002E0C016900FEFF2O006A0004473O0003020100121F000900013O0026AB0009000C020100010004473O000C0201002E0C016B00FEFF2O006C0004473O0008020100121F000A00134O0004010A001A3O00121F000A00134O0004010A00183O0004473O001402010004473O000802010004473O001402010004473O0003020100121F000700133O0004473O00842O010004473O001802010004473O00812O010026BB3O004E040100180004473O004E040100121F000600014O00AA000700073O002E15006D001C0201006E0004473O001C02010026BB0006001C020100010004473O001C020100121F000700013O000E6200130025020100070004473O00250201002E15006F0040020100700004473O004002012O00760008000A3O0020530008000800712O00420108000200020006B20008002F020100010004473O002F02012O00760008000A3O0020530008000800722O00420108000200020006B200080031020100010004473O00310201002EC800730032020100740004473O003202012O00760005001B3O002E0C0175000D000100750004473O003F02012O00760008000A3O0020530008000800712O00420108000200020006B20008003F020100010004473O003F02012O00760008000A3O0020530008000800722O00420108000200020006B20008003F020100010004473O003F020100121F000500133O00121F000700183O0026AB00070044020100010004473O00440201002E0C017600F7000100770004473O003903012O0076000800063O0006990008003703013O0004473O0037030100121F000800014O00AA0009000A3O0026BB00080031030100130004473O003103010026BB0009004B020100010004473O004B020100121F000A00013O0026BB000A00D0020100010004473O00D0020100121F000B00014O00AA000C000C3O0026BB000B0052020100010004473O0052020100121F000C00013O0026BB000C0059020100130004473O0059020100121F000A00133O0004473O00D00201000E17000100550201000C0004473O0055020100121F000D00013O002E1500790062020100780004473O006202010026BB000D0062020100130004473O0062020100121F000C00133O0004473O005502010026BB000D005C020100010004473O005C020100123A010E007A3O00123A010F007B4O0026000E000200100004473O008D020100123A0113007A4O003D011400124O00260013000200150004473O008B02012O00760018000B4O00CC001900033O00122O001A007C3O00122O001B007D6O0019001B00024O00180018001900202O00180018007E4O0018000200022O00E70019001C3O00202O00190019007F4O0019000100024O00180018001900062O0017007B020100180004473O007B02010004473O008B0201002EC80080008B020100810004473O008B02012O00760018001C3O00204B00180018007F2O001C0118000100022O00C200180017001800262C0018008B020100820004473O008B02012O00760018001C3O00204B00180018007F2O001C0118000100022O00C2001800170018000EAF0001008B020100180004473O008B02012O00FC001800014O0004011800083O0006130013006C020100020004473O006C0201000613000E0068020100020004473O0068020100123A010E007A3O00123A010F00834O0026000E000200100004473O00C9020100123A0113007A4O003D011400124O00260013000200150004473O00C702012O00760018001D4O001A0119000B6O001A00033O00122O001B00843O00122O001C00856O001A001C00024O00190019001A00202O00190019007E4O0019000200024O001A001C3O00202O001A001A007F4O001A00016O00183O00024O0019001E6O001A000B6O001B00033O00122O001C00843O00122O001D00856O001B001D00024O001A001A001B00202O001A001A007E4O001A000200024O001B001C3O00202O001B001B007F4O001B00016O00193O00024O00180018001900062O00170014000100180004473O00C70201002EC8008600B7020100870004473O00B702010004473O00C70201002EC8008800C7020100890004473O00C702012O00760018001C3O00204B00180018007F2O001C0118000100022O00C200180017001800262C001800C7020100820004473O00C702012O00760018001C3O00204B00180018007F2O001C0118000100022O00C2001800170018000EAF000100C7020100180004473O00C702012O00FC001800014O0004011800083O00061300130097020100020004473O00970201000613000E0093020100020004473O0093020100121F000D00133O0004473O005C02010004473O005502010004473O00D002010004473O005202010026AB000A00D4020100130004473O00D40201002EC8008B004E0201008A0004473O004E020100123A010B007A3O00123A010C008C4O0026000B0002000D0004473O002A030100123A0110007A4O003D0111000F4O00260010000200120004473O00280301002E0C018D004C0001008D0004473O002803012O00760015001D4O00760016000B4O00CC001700033O00122O0018008E3O00122O0019008F6O0017001900024O00160016001700202O00160016007E4O0016000200022O00060017001C3O00202O00170017007F4O001700016O00153O00024O0016001E6O0017000B4O00CC001800033O00122O0019008E3O00122O001A008F6O0018001A00024O00170017001800202O00170017007E4O0017000200022O00E00018001C3O00202O00180018007F4O001800016O00163O00024O00150015001600062O00150028030100140004473O002803012O00760015001D4O00760016000B4O00CC001700033O00122O001800903O00122O001900916O0017001900024O00160016001700202O00160016007E4O0016000200022O00060017001C3O00202O00170017007F4O001700016O00153O00024O0016001E6O0017000B4O00CC001800033O00122O001900903O00122O001A00916O0018001A00024O00170017001800202O00170017007E4O0017000200022O00E00018001C3O00202O00180018007F4O001800016O00163O00024O00150015001600062O00150028030100140004473O002803012O00760015001C3O00204B00150015007F2O001C0115000100022O00C200150014001500262C00150024030100820004473O002403012O00760015001C3O00204B00150015007F2O001C0115000100022O00C2001500140015000E4F2O010026030100150004473O00260301002E1500930028030100920004473O002803012O00FC001500014O0004011500083O000613001000DC020100020004473O00DC0201000613000B00D8020100020004473O00D802010004473O003703010004473O004E02010004473O003703010004473O004B02010004473O003703010026BB00080049020100010004473O0049020100121F000900014O00AA000A000A3O00121F000800133O0004473O004902012O00760005001F3O00121F000700133O002E1500940045040100950004473O004504010026BB00070045040100180004473O004504010006990001004803013O0004473O004803012O0076000800203O00202B0108000800964O0009000B3O00202O0009000900974O000A8O000B8O0008000B000200062O00050003000100080004473O004A0301002E150098004B030100990004473O004B03012O00FC00016O0076000800063O0006B200080050030100010004473O00500301002E15009A00440401009B0004473O0044040100121F000800013O000E17000100A5030100080004473O00A5030100121F000900013O0026BB000900A0030100010004473O00A0030100121F000A00013O0026BB000A009B030100010004473O009B030100123A010B009C4O00F1000C00033O00122O000D009D3O00122O000E009E6O000C000E000200122O000D00016O000B000D00014O000B000B6O000C00033O00122O000D009F3O00122O000E00A06O000C000E00024O000B000B000C00202O000B000B00A14O000B0002000200062O000B009A03013O0004473O009A03010006B20002009A030100010004473O009A030100123A010B007A3O00123A010C007B4O0026000B0002000D0004473O009803012O0076001000203O00200B0110001000A24O0011000E6O0012000F3O00122O001300216O00100013000200062O0010009803013O0004473O0098030100121F001000013O0026BB0010008E030100010004473O008E030100121F001100013O002E0C01A30006000100A30004473O008203010026BB00110082030100130004473O0082030100121F001000133O0004473O008E0301000E170001007C030100110004473O007C03012O00FC000200013O00127E0012009C6O001300033O00122O001400A43O00122O001500A56O00130015000200122O001400136O00120014000100122O001100133O0004473O007C0301000E6200130092030100100004473O00920301002EC800A60079030100A70004473O007903012O00760011001C3O00204B00110011007F2O001C0111000100022O0004011100213O0004473O009803010004473O00790301000613000B0070030100020004473O0070030100121F000A00133O0026BB000A0057030100130004473O0057030100121F000900133O0004473O00A003010004473O005703010026BB00090054030100130004473O0054030100121F000800133O0004473O00A503010004473O00540301002E1500A80051030100A90004473O005103010026BB00080051030100130004473O00510301002E1500AB2O00040100AA0004474O0004012O00760009000B4O0053010A00033O00122O000B00AC3O00122O000C00AD6O000A000C00024O00090009000A00202O0009000900A14O00090002000200062O00092O0004013O0004474O0004010006B200032O00040100010004474O00040100123A0109007A3O00123A010A00834O002600090002000B0004473O00FE0301002EC800AF00FE030100AE0004473O00FE03012O0076000E00203O00200B010E000E00A24O000F000C6O0010000D3O00122O001100216O000E0011000200062O000E00FE03013O0004473O00FE030100121F000E00014O00AA000F00103O000E62001300CB0301000E0004473O00CB0301002EC800B100F6030100B00004473O00F603010026AB000F00CF030100010004473O00CF0301002E1500B200CB030100B30004473O00CB030100121F001000013O0026BB001000D7030100130004473O00D703012O00760011001C3O00204B00110011007F2O001C0111000100022O0004011100213O0004473O00FE03010026BB001000D0030100010004473O00D0030100121F001100014O00AA001200123O0026BB001100DB030100010004473O00DB030100121F001200013O0026AB001200E2030100010004473O00E20301002E0C01B4000B000100B50004473O00EB03012O00FC000300013O00127E0013009C6O001400033O00122O001500B63O00122O001600B76O00140016000200122O001500186O00130015000100122O001200133O0026BB001200DE030100130004473O00DE030100121F001000133O0004473O00D003010004473O00DE03010004473O00D003010004473O00DB03010004473O00D003010004473O00FE03010004473O00CB03010004473O00FE03010026AB000E00FA030100010004473O00FA0301002E1500B800C7030100B90004473O00C7030100121F000F00014O00AA001000103O00121F000E00133O0004473O00C70301000613000900BB030100020004473O00BB03012O00760009000B4O0053010A00033O00122O000B00BA3O00122O000C00BB6O000A000C00024O00090009000A00202O0009000900A14O00090002000200062O0009004404013O0004473O004404012O00760009000B4O0053010A00033O00122O000B00BC3O00122O000C00BD6O000A000C00024O00090009000A00202O0009000900A14O00090002000200062O0009004404013O0004473O004404010006B200040044040100010004473O0044040100123A0109007A3O00123A010A008C4O002600090002000B0004473O004004012O0076000E00203O00200B010E000E00A24O000F000C6O0010000D3O00122O001100216O000E0011000200062O000E004004013O0004473O0040040100121F000E00014O00AA000F000F3O0026BB000E0024040100010004473O0024040100121F000F00013O002EC800BF0034040100BE0004473O003404010026BB000F0034040100010004473O003404012O00FC000400013O00127E0010009C6O001100033O00122O001200C03O00122O001300C16O00110013000200122O001200156O00100012000100122O000F00133O002EC800C20027040100C30004473O002704010026BB000F0027040100130004473O002704012O00760010001C3O00204B00100010007F2O001C0110000100022O0004011000213O0004473O004004010004473O002704010004473O004004010004473O002404010006130009001A040100020004473O001A04010004473O004404010004473O0051030100121F000700153O0026AB00070049040100150004473O00490401002E1500C400210201008A0004473O0021020100121F3O00153O0004473O004E04010004473O002102010004473O004E04010004473O001C0201002E1500C60002000100C50004473O000200010026BB3O0002000100150004473O0002000100121F000600013O0026AB00060057040100010004473O00570401002E0C01C70011000100C80004473O006604012O00760007000A3O0020530007000700C92O00420107000200020006990007005D04013O0004473O005D04012O00D23O00014O00760007000A3O0020530007000700CA2O00420107000200020006B200070064040100010004473O00640401002E1500CB0065040100CC0004473O006504012O00D23O00013O00121F000600133O000E620013006A040100060004473O006A0401002E1500CE00A7040100CD0004473O00A704012O00760007000A3O0020530007000700CF2O00420107000200020006990007007104013O0004473O00710401002E0C01D00005000100D10004473O0074040100123A010700D24O001C0107000100022O0004010700223O0006B2000100A6040100010004473O00A604012O00760007000A3O0020530007000700292O00420107000200020006B200070083040100010004473O008304012O0076000700023O0006B200070083040100010004473O008304012O0076000700233O0006B200070083040100010004473O00830401002EC800D300A6040100D40004473O00A6040100121F000700014O00AA000800083O0026BB0007009B040100010004473O009B04012O0076000900233O00061101080093040100090004473O009304012O00760009000B4O00CC000A00033O00122O000B00D53O00122O000C00D66O000A000C00024O00090009000A00202O0009000900A14O0009000200022O003D010800094O0076000900203O00206F0009000900D74O000A00086O000B000D3O00122O000E00D86O0009000E000200122O0009002A3O00122O000700133O0026BB00070085040100130004473O00850401002E0C01D90009000100D90004473O00A6040100123A0109002A3O000699000900A604013O0004473O00A6040100123A0109002A4O0075000900023O0004473O00A604010004473O0085040100121F000600183O0026BB000600AB040100150004473O00AB040100121F3O004D3O0004473O000200010026BB00060053040100180004473O005304012O00760007000A3O0020100007000700DB00122O000900DC6O00070009000200122O000700DA6O0007000A3O00202O00070007006300122O000900DD6O0007000900024O000700193O00122O000600153O00044O005304010004473O000200012O00D23O00017O000B3O00028O00025O0006AD40026O00284003053O005072696E74031F3O00A47C294CE790793341EBC0452846EB93617A4DF7C0502A46EDC0573540E3AB03053O008EE0155A2F026O00F03F030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03243O0050DD3455AD9B897DDA221694998C71C73316B2CBD4249A7518F4D9C556CD6774AB84885F03073O00E514B44736C4EB001B3O00121F3O00013O002E150003000F000100020004473O000F0001000E170001000F00013O0004473O000F00012O007600016O00640001000100014O000100013O00202O0001000100044O000200023O00122O000300053O00122O000400066O000200046O00013O000100124O00073O0026BB3O0001000100070004473O0001000100123A2O0100083O0020CD0001000100094O000200023O00122O0003000A3O00122O0004000B6O000200046O00013O000100044O001A00010004473O000100012O00D23O00017O00", GetFEnv(), ...);

