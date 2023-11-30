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
				if (Enum <= 171) then
					if (Enum <= 85) then
						if (Enum <= 42) then
							if (Enum <= 20) then
								if (Enum <= 9) then
									if (Enum <= 4) then
										if (Enum <= 1) then
											if (Enum == 0) then
												local A;
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Upvalues[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
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
										elseif (Enum <= 2) then
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
										elseif (Enum == 3) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 6) then
										if (Enum == 5) then
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
									elseif (Enum <= 7) then
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
									elseif (Enum == 8) then
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
												if (Mvm[1] == 149) then
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 12) then
										local A = Inst[2];
										do
											return Unpack(Stk, A, Top);
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
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
									end
								elseif (Enum <= 17) then
									if (Enum <= 15) then
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
									elseif (Enum == 16) then
										Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									elseif ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum <= 18) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 31) then
								if (Enum <= 25) then
									if (Enum <= 22) then
										if (Enum == 21) then
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
										end
									elseif (Enum <= 23) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
									elseif (Enum > 24) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 28) then
									if (Enum <= 26) then
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
									elseif (Enum == 27) then
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
									end
								elseif (Enum <= 29) then
									if (Inst[2] < Inst[4]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 36) then
								if (Enum <= 33) then
									if (Enum == 32) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
								elseif (Enum <= 34) then
									Stk[Inst[2]] = Inst[3] ~= 0;
								elseif (Enum == 35) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] * Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 39) then
								if (Enum <= 37) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 38) then
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
							elseif (Enum <= 40) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 41) then
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
						elseif (Enum <= 63) then
							if (Enum <= 52) then
								if (Enum <= 47) then
									if (Enum <= 44) then
										if (Enum > 43) then
											local A;
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
									elseif (Enum <= 45) then
										if (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 46) then
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
										if (Stk[Inst[2]] < Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
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
								elseif (Enum <= 49) then
									if (Enum == 48) then
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
								elseif (Enum <= 50) then
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
								elseif (Enum == 51) then
									local A;
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
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
							elseif (Enum <= 57) then
								if (Enum <= 54) then
									if (Enum > 53) then
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
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
									end
								elseif (Enum <= 55) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 56) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 60) then
								if (Enum <= 58) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum > 59) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 61) then
								Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
							elseif (Enum == 62) then
								Stk[Inst[2]]();
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
								if (Stk[Inst[2]] <= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 74) then
							if (Enum <= 68) then
								if (Enum <= 65) then
									if (Enum == 64) then
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
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 66) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 67) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] < Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 71) then
								if (Enum <= 69) then
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
								elseif (Enum == 70) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 72) then
								local A;
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum > 73) then
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = #Stk[Inst[3]];
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
								VIP = Inst[3];
							end
						elseif (Enum <= 79) then
							if (Enum <= 76) then
								if (Enum > 75) then
									local A = Inst[2];
									Stk[A] = Stk[A]();
								elseif (Stk[Inst[2]] < Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 77) then
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
							elseif (Enum > 78) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 82) then
							if (Enum <= 80) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Enum > 81) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
							elseif (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						elseif (Enum <= 83) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 84) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						end
					elseif (Enum <= 128) then
						if (Enum <= 106) then
							if (Enum <= 95) then
								if (Enum <= 90) then
									if (Enum <= 87) then
										if (Enum > 86) then
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
										elseif (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 88) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
									elseif (Enum > 89) then
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
								elseif (Enum <= 92) then
									if (Enum == 91) then
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
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
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 93) then
									local A = Inst[2];
									Top = (A + Varargsz) - 1;
									for Idx = A, Top do
										local VA = Vararg[Idx - A];
										Stk[Idx] = VA;
									end
								elseif (Enum > 94) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = not Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								elseif (Inst[2] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 100) then
								if (Enum <= 97) then
									if (Enum == 96) then
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
									else
										do
											return;
										end
									end
								elseif (Enum <= 98) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								elseif (Enum == 99) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								end
							elseif (Enum <= 103) then
								if (Enum <= 101) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 102) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 104) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 105) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								do
									return Stk[Inst[2]];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum <= 117) then
							if (Enum <= 111) then
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
										if (Stk[Inst[2]] > Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = VIP + Inst[3];
										end
									end
								elseif (Enum <= 109) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 110) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 114) then
								if (Enum <= 112) then
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
								elseif (Enum > 113) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 115) then
								do
									return Stk[Inst[2]];
								end
							elseif (Enum == 116) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Inst[2] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 122) then
							if (Enum <= 119) then
								if (Enum == 118) then
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
							elseif (Enum <= 120) then
								Stk[Inst[2]] = Stk[Inst[3]] + Stk[Inst[4]];
							elseif (Enum == 121) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
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
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 125) then
							if (Enum <= 123) then
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
							elseif (Enum == 124) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 126) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 127) then
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
					elseif (Enum <= 149) then
						if (Enum <= 138) then
							if (Enum <= 133) then
								if (Enum <= 130) then
									if (Enum == 129) then
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
								elseif (Enum <= 131) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								elseif (Enum == 132) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 135) then
								if (Enum > 134) then
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
							elseif (Enum <= 136) then
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
							elseif (Enum > 137) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
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
						elseif (Enum <= 143) then
							if (Enum <= 140) then
								if (Enum == 139) then
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
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 141) then
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
							elseif (Enum == 142) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 144) then
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
							elseif (Enum == 145) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum <= 147) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						elseif (Enum > 148) then
							Stk[Inst[2]] = Stk[Inst[3]];
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
					elseif (Enum <= 160) then
						if (Enum <= 154) then
							if (Enum <= 151) then
								if (Enum > 150) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum <= 152) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum > 153) then
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
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 157) then
							if (Enum <= 155) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 156) then
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
								local A = Inst[2];
								local Results = {Stk[A](Stk[A + 1])};
								local Edx = 0;
								for Idx = A, Inst[4] do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							end
						elseif (Enum <= 158) then
							if (Inst[2] < Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 159) then
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
					elseif (Enum <= 165) then
						if (Enum <= 162) then
							if (Enum > 161) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 163) then
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
						elseif (Enum == 164) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							do
								return Unpack(Stk, A, A + Inst[3]);
							end
						end
					elseif (Enum <= 168) then
						if (Enum <= 166) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 167) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 169) then
						if (Stk[Inst[2]] < Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 170) then
						local B;
						local A;
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 257) then
					if (Enum <= 214) then
						if (Enum <= 192) then
							if (Enum <= 181) then
								if (Enum <= 176) then
									if (Enum <= 173) then
										if (Enum == 172) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
											A = Inst[2];
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
											if (Stk[Inst[2]] <= Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 174) then
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
									elseif (Enum == 175) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] + Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
									end
								elseif (Enum <= 178) then
									if (Enum == 177) then
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
									VIP = Inst[3];
								elseif (Enum == 180) then
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
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum <= 183) then
									if (Enum == 182) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
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
								elseif (Enum <= 184) then
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
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
							elseif (Enum <= 189) then
								if (Enum <= 187) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
								elseif (Enum > 188) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 190) then
								if (Stk[Inst[2]] <= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 191) then
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
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 203) then
							if (Enum <= 197) then
								if (Enum <= 194) then
									if (Enum == 193) then
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
								elseif (Enum <= 195) then
									if (Stk[Inst[2]] ~= Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum > 196) then
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
								end
							elseif (Enum <= 200) then
								if (Enum <= 198) then
									do
										return Stk[Inst[2]]();
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
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 201) then
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							elseif (Enum == 202) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 208) then
							if (Enum <= 205) then
								if (Enum == 204) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 206) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum == 207) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] < Inst[4]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							end
						elseif (Enum <= 211) then
							if (Enum <= 209) then
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
							elseif (Enum > 210) then
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
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 213) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 235) then
						if (Enum <= 224) then
							if (Enum <= 219) then
								if (Enum <= 216) then
									if (Enum > 215) then
										Stk[Inst[2]] = #Stk[Inst[3]];
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 217) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = Inst[3];
									else
										VIP = VIP + 1;
									end
								elseif (Enum == 218) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
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
							elseif (Enum <= 221) then
								if (Enum == 220) then
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
									local A = Inst[2];
									local B = Inst[3];
									for Idx = A, B do
										Stk[Idx] = Vararg[Idx - A];
									end
								end
							elseif (Enum <= 222) then
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							if (Enum <= 226) then
								if (Enum == 225) then
									local A = Inst[2];
									Stk[A](Stk[A + 1]);
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 228) then
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
						elseif (Enum <= 232) then
							if (Enum <= 230) then
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
							elseif (Enum == 231) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
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
						elseif (Enum <= 233) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 234) then
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
					elseif (Enum <= 246) then
						if (Enum <= 240) then
							if (Enum <= 237) then
								if (Enum == 236) then
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
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 238) then
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
							elseif (Enum > 239) then
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
						elseif (Enum <= 243) then
							if (Enum <= 241) then
								Stk[Inst[2]] = Inst[3] * Stk[Inst[4]];
							elseif (Enum > 242) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							end
						elseif (Enum <= 244) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 245) then
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 251) then
						if (Enum <= 248) then
							if (Enum > 247) then
								VIP = Inst[3];
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
						elseif (Enum <= 249) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
						elseif (Enum > 250) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						end
					elseif (Enum <= 254) then
						if (Enum <= 252) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						elseif (Enum == 253) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							local B = Stk[Inst[4]];
							if B then
								VIP = VIP + 1;
							else
								Stk[Inst[2]] = B;
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 255) then
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
					elseif (Enum > 256) then
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
				elseif (Enum <= 300) then
					if (Enum <= 278) then
						if (Enum <= 267) then
							if (Enum <= 262) then
								if (Enum <= 259) then
									if (Enum == 258) then
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
									end
								elseif (Enum <= 260) then
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
									Upvalues[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if (Inst[2] <= Inst[4]) then
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
							elseif (Enum <= 264) then
								if (Enum > 263) then
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
									Stk[Inst[2]]();
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
									Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 265) then
								local A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
							elseif (Enum == 266) then
								if (Stk[Inst[2]] > Inst[4]) then
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
								if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
									Stk[Inst[2]] = Env;
								else
									Stk[Inst[2]] = Env[Inst[3]];
								end
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
								if (Inst[2] < Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 272) then
							if (Enum <= 269) then
								if (Enum > 268) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
									if (Stk[Inst[2]] <= Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 270) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum == 271) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 275) then
							if (Enum <= 273) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							elseif (Enum > 274) then
								Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
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
							end
						elseif (Enum <= 276) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 277) then
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 289) then
						if (Enum <= 283) then
							if (Enum <= 280) then
								if (Enum > 279) then
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
									VIP = Inst[3];
								end
							elseif (Enum <= 281) then
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
								if (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum == 282) then
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
						elseif (Enum <= 286) then
							if (Enum <= 284) then
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
							elseif (Enum == 285) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
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
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Top));
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
						elseif (Enum == 288) then
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
							Stk[Inst[2]] = Inst[3];
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
							do
								return;
							end
						end
					elseif (Enum <= 294) then
						if (Enum <= 291) then
							if (Enum == 290) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
							end
						elseif (Enum <= 292) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum == 293) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 297) then
						if (Enum <= 295) then
							Stk[Inst[2]] = Stk[Inst[3]] / Stk[Inst[4]];
						elseif (Enum > 296) then
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
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Inst[3] ~= 0;
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3] ~= 0;
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
					elseif (Enum <= 298) then
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
					elseif (Enum == 299) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if (Stk[Inst[2]] <= Inst[4]) then
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
				elseif (Enum <= 322) then
					if (Enum <= 311) then
						if (Enum <= 305) then
							if (Enum <= 302) then
								if (Enum == 301) then
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
									if (Stk[Inst[2]] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Stk[Inst[2]] > Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = VIP + Inst[3];
								end
							elseif (Enum <= 303) then
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 304) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum <= 308) then
							if (Enum <= 306) then
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
							elseif (Enum == 307) then
								if (Stk[Inst[2]] == Inst[4]) then
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
						elseif (Enum <= 309) then
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
						elseif (Enum > 310) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = not Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
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
					elseif (Enum <= 316) then
						if (Enum <= 313) then
							if (Enum > 312) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 314) then
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
						elseif (Enum == 315) then
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
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 319) then
						if (Enum <= 317) then
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
						elseif (Enum > 318) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 320) then
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
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
					elseif (Enum == 321) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
				elseif (Enum <= 333) then
					if (Enum <= 327) then
						if (Enum <= 324) then
							if (Enum == 323) then
								local A = Inst[2];
								do
									return Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Stk[Inst[4]]];
							end
						elseif (Enum <= 325) then
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
							if (Stk[Inst[2]] <= Stk[Inst[4]]) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 330) then
						if (Enum <= 328) then
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
						elseif (Enum == 329) then
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
							if (Stk[Inst[2]] > Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = VIP + Inst[3];
							end
						end
					elseif (Enum <= 331) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 332) then
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
				elseif (Enum <= 338) then
					if (Enum <= 335) then
						if (Enum == 334) then
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
							Stk[Inst[2]] = not Stk[Inst[3]];
						end
					elseif (Enum <= 336) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = Inst[3];
						else
							VIP = VIP + 1;
						end
					elseif (Enum > 337) then
						local A = Inst[2];
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
						if (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 341) then
					if (Enum <= 339) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum == 340) then
						Stk[Inst[2]] = Stk[Inst[3]] - Stk[Inst[4]];
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
				elseif (Enum <= 342) then
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
					Stk[Inst[2]] = Upvalues[Inst[3]];
				elseif (Enum == 343) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O007265717569726503163O00F4D3D23DD98BD517D4D0CF1AD5B3C61ADED49529F3BA03083O007EB1A3BB4586DBA703163O001DAF0B10078F10013DAC16370BB7030C37A84C042DBE03043O006858DF62002E3O0012703O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004F83O000A0001001211000300063O002011010400030007001211000500083O002011010500050009001211000600083O00201101060006000A00060A00073O000100062O00953O00064O00958O00953O00044O00953O00014O00953O00024O00953O00053O00201101080003000B00201101090003000C2O00BF000A5O001211000B000D3O00060A000C0001000100022O00953O000A4O00953O000B4O0095000D00073O00120C010E000E3O00120C010F000F4O00CE000D000F000200060A000E0002000100032O00953O00074O00953O00094O00953O00084O000F000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O009000025O00122O000300016O00045O00122O000500013O00042O0003002100012O009300076O008B000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004B10003000500012O0093000300054O0095000400024O0043010300044O000C00036O00613O00017O000B3O00028O00026O00F03F025O00C88340025O00A8A940025O007BB040025O0076A140025O00B07640025O00D89840025O000AA840025O000BB040025O0014904001463O00120C010200014O0083000300053O00263301020007000100010004F83O0007000100120C010300014O0083000400043O00120C010200023O00263301020002000100020004F83O000200012O0083000500053O0026330103003D000100020004F83O003D000100120C010600013O0026C300060011000100010004F83O00110001002E1D0004000D000100030004F83O000D000100263301040017000100020004F83O001700012O0095000700054O005D00086O001E01076O000C00075O002E5E000500F5FF2O00050004F83O000C00010026330104000C000100010004F83O000C000100120C010700014O0083000800083O0026C300070021000100010004F83O00210001002EC20006001D000100070004F83O001D000100120C010800013O002E1D00080032000100090004F83O0032000100263301080032000100010004F83O003200012O009300096O00FA000500093O00064A0005002C00013O0004F83O002C0001002EC2000A00310001000B0004F83O003100012O0093000900014O0095000A6O005D000B6O001E01096O000C00095O00120C010800023O00263301080022000100020004F83O0022000100120C010400023O0004F83O000C00010004F83O002200010004F83O000C00010004F83O001D00010004F83O000C00010004F83O000D00010004F83O000C00010004F83O004500010026330103000A000100010004F83O000A000100120C010400014O0083000500053O00120C010300023O0004F83O000A00010004F83O004500010004F83O000200012O00613O00017O005D3O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E3076427203063O009F25023176B103073O009BCB44705613C52O033O0076D82203083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703093O008572693B165BEC46BA03083O0023C81D1C4873149A03053O002AAFD4D38103073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O00644303374603043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O0032A88E24CA03053O00B962DAEB57030B3O00FB2E22F5CD89DE2E34E9CC03063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D903043O006D6174682O033O00CA5D7E03063O007EA7341074D9028O0003063O00F83C2985A70D03073O009CA84E40E0D47903063O0034E6A4CA08F903043O00AE678EC503063O00663A563D364A03073O009836483F58453E03063O00E7CCEF58DBD303043O003CB4A48E03063O00684C0C2C34F903073O0072383E6549478D03063O008BE1DAC0B7FE03043O00A4D889BB03073O00F1E93CBFA9F01803073O006BB28651D2C69E03083O001D1887D4B337008703053O00CA586EE2A6024O0080B3C540030A3O00EE068CF3C8C60186F2D803053O00AAA36FE297030B3O004973417661696C61626C65030A3O003C39BC3C4C32271535A003073O00497150D2582E57030B3O00B224CC16E8962AC417E98503053O0087E14CAD7203103O005265676973746572466F724576656E7403143O002AC1992O898F9828C89F953O8234CC9A9C899903073O00C77A8DD8D0CCDD03243O00F53C33FA8059B9E43326EA934EB9E72F22F09F5DAAFD2526E79F53A8EB3C2FF2985BA3F003073O00E6B47F67B3D61C030E3O009E489CAC1F9E479AA812835F9CA403053O0053CD18D9E003143O00CAE0EC0FC8E0E902D5F5E811CAFAE413D9F1EC1F03043O005D86A5AD03143O00740552CE74657C1F40CC7F6C741F5AD26574790203063O00203840139C3A030B3O0069C0E45255E5A348C9F65E03073O00E03AA885363A9203163O005265676973746572496E466C69676874452O66656374024O0050120941030B3O006A5E4AF97A91A41958454303083O006B39362B9D15E6E703103O005265676973746572496E466C69676874030F3O006FD6AE430E6F42DDBF7C177C4CC6BD03063O001D2BB3D82C7B03133O005265676973746572504D756C7469706C69657203153O004465766F7572696E67506C61677565446562752O6603063O0053657441504C025O00207040009E023O00DD000100033O001211000300014O001C00045O00122O000500023O00122O000600036O0004000600024O000300030004001211000400043O001211000500054O001C00065O00122O000700063O00122O000800076O0006000800024O0006000400062O001C00075O00122O000800083O00122O000900096O0007000900024O0007000600072O001C00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600082O001C00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600092O001C000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A2O001C000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0006000B2O001C000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C2O001C000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D001211000E00044O001C000F5O00122O001000163O00122O001100176O000F001100024O000F000E000F2O001C00105O00122O001100183O00122O001200196O0010001200024O0010000E00102O001C00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000E00112O001C00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000E00122O001C00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000E00132O001C00145O00122O001500203O00122O001600216O0014001600024O0013001300142O001C00145O00122O001500223O00122O001600236O0014001600024O0013001300142O001C00145O00122O001500243O00122O001600256O0014001600024O0014000E00142O001C00155O00122O001600263O00122O001700276O0015001700024O0014001400152O001C00155O00122O001600283O00122O001700296O0015001700024O0014001400150012110015002A4O001C00165O00122O0017002B3O00122O0018002C6O0016001800024O00150015001600120D0016002D6O00178O00188O00198O001A8O001B00494O001C004A5O00122O004B002E3O00122O004C002F6O004A004C00024O004A000C004A2O001C004B5O00122O004C00303O00122O004D00316O004B004D00024O004A004A004B2O001C004B5O00122O004C00323O00122O004D00336O004B004D00024O004B000D004B2O001C004C5O00122O004D00343O00122O004E00356O004C004E00024O004B004B004C2O001C004C5O00122O004D00363O00122O004E00376O004C004E00024O004C000F004C2O001C004D5O00122O004E00383O00122O004F00396O004D004F00024O004C004C004D2O00BF004D6O0083004E00524O001C00535O00122O0054003A3O00122O0055003B6O0053005500024O0053000E00532O001C00545O00122O0055003C3O00122O0056003D6O0054005600024O0053005300542O00F5005400543O00122O0055003E3O00122O0056003E6O00578O00585O00122O0059002D6O005A8O005B8O005C8O005D6O0022005E6O0003005F5O00122O0060003F3O00122O006100406O005F006100024O005F004A005F00202O005F005F00414O005F0002000200062O005F00B500013O0004F83O00B500012O0093005F5O00121F006000423O00122O006100436O005F006100024O005F004A005F00062O005F00BA000100010004F83O00BA00012O0093005F5O00120C016000443O00120C016100454O00CE005F006100022O00FA005F004A005F2O002200605O00120C0161002D4O002200626O0083006300653O00203B00660004004600060A00683O0001000E2O00953O005D4O00953O005E4O00953O005B4O00953O005C4O00953O00594O00953O005A4O00953O00574O00953O00584O00953O00554O00953O00564O00953O00604O00953O00614O00953O00624O00953O00634O00A300695O00122O006A00473O00122O006B00486O0069006B6O00663O000100060A00660001000100022O00953O00534O00937O00203B00670004004600060A00690002000100012O00953O00664O00FF006A5O00122O006B00493O00122O006C004A6O006A006C6O00673O000100202O00670004004600060A00690003000100032O00953O005F4O00953O004A4O00938O00B2006A5O00122O006B004B3O00122O006C004C6O006A006C00024O006B5O00122O006C004D3O00122O006D004E6O006B006D6O00673O000100202O00670004004600060A00690004000100022O00953O004A4O00938O0017006A5O00122O006B004F3O00122O006C00506O006A006C6O00673O00014O00675O00122O006800513O00122O006900526O0067006900024O0067004A006700202O00670067005300122O006900546O0067006900014O00675O00122O006800553O00122O006900566O0067006900024O0067004A006700202O0067006700574O00670002000100060A00670005000100032O00953O00074O00953O004A4O00938O001C00685O00122O006900583O00122O006A00596O0068006A00024O0068004A006800203B00680068005A002011016A004A005B2O0095006B00674O00520168006B000100060A00680006000100012O00953O004A3O00060A00690007000100022O00953O00134O00953O004A3O00060A006A0008000100012O00953O004A3O0002C4006B00093O00060A006C000A000100012O00953O004A3O00060A006D000B000100032O00953O004A4O00938O00953O005C3O00060A006E000C000100052O00953O004A4O00938O00953O00524O00953O00654O00953O00073O00060A006F000D000100032O00953O004A4O00953O00654O00937O00060A0070000E000100062O00953O004A4O00938O00933O00014O00953O00654O00933O00024O00953O00613O00060A0071000F000100032O00953O00684O00953O004A4O00937O00060A00720010000100022O00953O004A4O00953O00073O00060A00730011000100052O00953O005F4O00953O004A4O00938O00953O00604O00953O00073O00060A00740012000100022O00953O00074O00953O004A3O0002C4007500133O00060A00760014000100052O00953O004A4O00953O00614O00953O00604O00938O00953O00523O00060A00770015000100012O00953O004A3O00060A00780016000100012O00953O004A3O00060A00790017000100022O00953O004A4O00953O005B3O00060A007A0018000100042O00953O004A4O00938O00953O005C4O00953O005B3O00060A007B0019000100012O00953O00683O00060A007C001A0001000A2O00953O004A4O00938O00953O00114O00953O00084O00953O00634O00953O00184O00953O00074O00953O00474O00953O000B4O00953O004C3O00060A007D001B000100082O00953O00574O00953O00684O00953O00084O00953O004A4O00938O00953O00584O00953O005E4O00953O00073O00060A007E001C0001000F2O00953O00594O00953O00154O00953O00524O00953O00494O00953O005A4O00953O00694O00953O00504O00953O005D4O00933O00014O00953O004A4O00938O00953O00134O00953O005C4O00933O00024O00953O005B3O00060A007F001D000100062O00953O00074O00953O004A4O00953O00564O00953O00544O00953O00534O00953O004D3O00060A0080001E0001000D2O00953O004A4O00938O00953O00084O00953O00474O00953O00114O00953O000B4O00953O00074O00953O004C4O00953O00104O00953O005F4O00953O00184O00953O00544O00953O007F3O00060A0081001F000100162O00953O004A4O00938O00953O00114O00953O00084O00953O00644O00953O00474O00953O000B4O00953O00074O00953O004C4O00953O00534O00953O004F4O00953O00754O00953O00774O00953O006C4O00953O00744O00953O000A4O00953O003C4O00953O00394O00953O003A4O00953O003B4O00953O00604O00953O006B3O00060A00820020000100102O00953O004A4O00938O00953O00074O00953O00604O00953O005F4O00953O00524O00953O00114O00953O00184O00953O00544O00953O007F4O00953O004B4O00953O00654O00953O004C4O00953O000A4O00953O00044O00953O00563O00060A008300210001001F2O00953O005F4O00953O00574O00953O00564O00953O00084O00953O004A4O00938O00953O00654O00953O00114O00953O00534O00953O004F4O00953O006E4O00953O007D4O00953O00184O00953O005C4O00953O00524O00953O00544O00953O00824O00953O00764O00953O004C4O00953O00074O00953O00604O00953O00614O00953O00704O00953O00784O00953O00814O00953O006C4O00953O006D4O00933O00014O00933O00024O00953O00474O00953O000B3O00060A00840022000100062O00953O004A4O00938O00953O00084O00953O00074O00953O00114O00953O00683O00060A00850023000100232O00953O00644O00953O00074O00953O004A4O00953O00574O00938O00953O00114O00953O00084O00953O005B4O00953O005C4O00953O00524O00933O00014O00933O00024O00953O00544O00953O00844O00953O00534O00953O004F4O00953O007B4O00953O004C4O00953O00814O00953O007E4O00953O00594O00953O005D4O00953O00794O00953O00474O00953O000B4O00953O00184O00953O00564O00953O00824O00953O005E4O00953O006F4O00953O007A4O00953O00604O00953O005F4O00953O00654O00953O00613O00060A008600240001001D2O00953O004A4O00938O00953O00074O00953O002B4O00953O002A4O00953O00114O00953O00534O00953O00084O00953O00444O00953O00454O00953O00464O00953O002E4O00953O002F4O00953O002C4O00953O002D4O00953O001A4O00953O003E4O00953O003D4O00953O004C4O00953O00404O00953O003F4O00953O00424O00953O00414O00953O004B4O00953O00304O00953O00314O00953O001C4O00953O001E4O00953O001D3O00060A00870025000100092O00953O00164O00953O00224O00953O004A4O00938O00953O00214O00953O00074O00953O00114O00953O004C4O00953O00203O00060A00880026000100062O00953O004A4O00938O00953O00194O00953O00534O00953O00114O00953O004C3O00060A00890027000100302O00953O002F4O00938O00953O00304O00953O00314O00953O00324O00953O002D4O00953O002E4O00953O001D4O00953O001E4O00953O001B4O00953O001C4O00953O001F4O00953O00204O00953O00454O00953O00464O00953O00474O00953O00484O00953O00494O00953O00234O00953O00244O00953O00254O00953O00264O00953O00214O00953O00224O00953O00394O00953O003A4O00953O003D4O00953O003E4O00953O003B4O00953O003C4O00953O00354O00953O00364O00953O00374O00953O00384O00953O00334O00953O00344O00953O00434O00953O00444O00953O00414O00953O00424O00953O003F4O00953O00404O00953O00294O00953O002A4O00953O002B4O00953O002C4O00953O00274O00953O00283O00060A008A0028000100312O00953O00074O00953O00234O00953O00544O00953O004A4O00938O00953O00534O00953O00164O00953O00114O00953O00174O00953O007C4O00953O00834O00953O005E4O00953O00634O00953O00084O00953O00264O00953O004C4O00953O005C4O00953O00624O00953O00684O00953O00804O00953O000A4O00953O00884O00953O00194O00953O00244O00953O00524O00953O00514O00953O00854O00953O000B4O00953O00254O00953O00864O00953O00434O00953O001F4O00953O00874O00953O00644O00953O00654O00933O00014O00933O00024O00953O00614O00953O005F4O00953O00564O00953O00044O00953O00504O00953O00604O00953O00554O00953O004E4O00953O004F4O00953O00184O00953O00894O00953O001A3O00060A008B0029000100042O00953O00664O00953O004A4O00938O00953O000E3O002012008C000E005C00122O008D005D6O008E008A6O008F008B6O008C008F00016O00013O002A3O001B3O00028O00027O0040025O00CC9C40025O0048AE40025O006BB240025O00189240026O000840025O00149F40026O00F03F025O00B4A840025O0007B040025O005EA940025O0030B140025O0062AD40025O0072A540025O00208840025O0050B04003113O005661724D696E64536561724375746F2O66030D3O00566172502O6F6C416D6F756E74026O004E40025O009CA540025O00708440025O00DBB240025O0084A240025O006CA340025O0046A640024O0080B3C540007E3O00120C012O00014O0083000100013O002633012O0002000100010004F83O0002000100120C2O0100013O0026C300010009000100020004F83O00090001002E5E00030022000100040004F83O0029000100120C010200014O0083000300033O0026330102000B000100010004F83O000B000100120C010300013O002EC200060014000100050004F83O0014000100263301030014000100020004F83O0014000100120C2O0100073O0004F83O00290001002E5E00080009000100080004F83O001D00010026330103001D000100090004F83O001D00012O002200046O00B700046O002200046O00B7000400013O00120C010300023O0026C300030021000100010004F83O00210001002E5E000A00EFFF2O000B0004F83O000E00012O002200046O002E000400026O00048O000400033O00122O000300093O00044O000E00010004F83O002900010004F83O000B00010026332O010055000100090004F83O0055000100120C010200014O0083000300033O0026330102002D000100010004F83O002D000100120C010300013O0026C300030034000100020004F83O00340001002E5E000C00040001000D0004F83O0036000100120C2O0100023O0004F83O00550001000E5600010049000100030004F83O0049000100120C010400013O002E1D000F003F0001000E0004F83O003F00010026330104003F000100090004F83O003F000100120C010300093O0004F83O00490001002E1D00100039000100110004F83O0039000100263301040039000100010004F83O0039000100120C010500023O0012CD000500123O00122O000500143O00122O000500133O00122O000400093O00044O00390001002EC200160030000100150004F83O0030000100263301030030000100090004F83O0030000100120C010400014O002E000400046O00048O000400053O00122O000300023O00044O003000010004F83O005500010004F83O002D0001000EF000010059000100010004F83O00590001002E5E00170018000100180004F83O006F000100120C010200013O000E5600090061000100020004F83O006100012O002200036O00B7000300064O002200036O00B7000300073O00120C010200023O000E5600020065000100020004F83O0065000100120C2O0100093O0004F83O006F00010026C300020069000100010004F83O00690001002E1D001A005A000100190004F83O005A000100120C0103001B4O0038010300083O00122O0003001B6O000300093O00122O000200093O00044O005A00010026332O010005000100070004F83O000500012O002200026O00810002000A3O00122O000200016O0002000B6O00028O0002000C6O000200026O0002000D3O00044O007D00010004F83O000500010004F83O007D00010004F83O000200012O00613O00017O00043O0003123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD70901803193O00018DAC5C01841D112788BA680D9B141136819B49069D17163603083O007045E4DF2C64E871000D4O0021019O000100013O00122O000200013O00122O000300026O0001000300024O00028O000300013O00122O000400033O00122O000500046O0003000500024O0002000200036O000100026O00019O003O00034O00938O003E3O000100012O00613O00017O00073O00030A3O00A10C5142E644EE88004D03073O0080EC653F268421030B3O004973417661696C61626C65030A3O0081A01F40B4EEC1A8AC2O03073O00AFCCC97124D68B030B3O0074C434D80B50CA3CD90A4303053O006427AC55BC001A4O007F3O00016O000100023O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004F83O001200012O00933O00014O001C000100023O00122O000200043O00122O000300056O0001000300028O00010006893O0018000100010004F83O001800012O00933O00014O001C000100023O00122O000200063O00122O000300076O0001000300028O00012O00B78O00613O00017O000A3O00028O00025O0020AF40025O00749940030B3O008DFAC0C635D9916CBFE1C903083O001EDE92A1A25AAED203163O005265676973746572496E466C69676874452O66656374024O0050120941030B3O00D646710EEA595318E45D7803043O006A852E1003103O005265676973746572496E466C69676874001F3O00120C012O00014O0083000100013O002633012O0002000100010004F83O0002000100120C2O0100013O0026C300010009000100010004F83O00090001002E5E000200FEFF2O00030004F83O000500012O009300026O008E000300013O00122O000400043O00122O000500056O0003000500024O00020002000300202O00020002000600122O000400076O0002000400014O00028O000300013O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000100044O001E00010004F83O000500010004F83O001E00010004F83O000200012O00613O00017O00323O00028O00026O00F03F025O0052A340025O005EAA40025O0016B340025O00CC9E40027O0040025O0044A440025O00589640025O00CDB240025O00C1B14003063O0042752O66557003123O004461726B4576616E67656C69736D42752O6603093O0042752O66537461636B022O00AE47E17A843F03103O004465766F757265644665617242752O6603113O004465766F75726564507269646542752O66025O0033B340025O001DB34002CD5OCCF03F025O002FB040025O001C9340025O00ACAA40026O00084003103O00FF8202E1B6CEDBDE8F23F0B8D0C6CF9203073O00AFBBEB7195D9BC030B3O004973417661696C61626C65026O33F33F025O00207C40025O00AAA34003103O004D696E644465766F7572657242752O66025O0076A140025O00F88C4003113O004461726B417363656E73696F6E42752O66025O0032A040025O0015B040026O00F43F025O008EA740025O003AB240025O003C9040025O00AEB040025O00405F40025O0042A040025O00349D40025O0024B340030B3O000AA08848F7766D3FA7844803073O00185CCFE12C8319025O00C49B40025O00E0A94002F6285C8FC2F5F03F00BC3O00120C012O00014O0083000100023O002633012O0007000100010004F83O0007000100120C2O0100014O0083000200023O00120C012O00023O002633012O0002000100020004F83O0002000100120C010300013O0026C30003000E000100010004F83O000E0001002E1D00040072000100030004F83O00720001000EF000020012000100010004F83O00120001002E5E00050037000100060004F83O0047000100120C010400013O00263301040017000100020004F83O0017000100120C2O0100073O0004F83O004700010026C30004001B000100010004F83O001B0001002EC200080013000100090004F83O0013000100120C010500013O002E1D000B00410001000A0004F83O0041000100263301050041000100010004F83O004100012O009300065O0020A000060006000C4O000800013O00202O00080008000D4O00060008000200062O0006002F00013O0004F83O002F00012O009300065O0020AF00060006000E4O000800013O00202O00080008000D4O00060008000200102O0006000F000600102O0006000200064O0002000200062O009300065O0020BD00060006000C4O000800013O00202O0008000800104O00060008000200062O0006003F000100010004F83O003F00012O009300065O0020BD00060006000C4O000800013O00202O0008000800114O00060008000200062O0006003F000100010004F83O003F0001002E1D00120040000100130004F83O0040000100201000020002001400120C010500023O0026330105001C000100020004F83O001C000100120C010400023O0004F83O001300010004F83O001C00010004F83O00130001002E5E0015002A000100150004F83O007100010026332O010071000100070004F83O0071000100120C010400014O0083000500053O0026330104004D000100010004F83O004D000100120C010500013O002E1D00160056000100170004F83O0056000100263301050056000100020004F83O0056000100120C2O0100183O0004F83O0071000100263301050050000100010004F83O005000012O0093000600014O0003000700023O00122O000800193O00122O0009001A6O0007000900024O00060006000700202O00060006001B4O00060002000200062O0006006300013O0004F83O0063000100201000020002001C002E1D001D006D0001001E0004F83O006D00012O009300065O0020A000060006000C4O000800013O00202O00080008001F4O00060008000200062O0006006D00013O0004F83O006D000100201000020002001C00120C010500023O0004F83O005000010004F83O007100010004F83O004D000100120C010300023O0026330103000A000100020004F83O000A0001002E5E00200022000100200004F83O009600010026332O010096000100010004F83O0096000100120C010400014O0083000500053O002EC20021007A0001001E0004F83O007A00010026330104007A000100010004F83O007A000100120C010500013O0026330105008D000100010004F83O008D000100120C010200024O007A00065O00202O00060006000C4O000800013O00202O0008000800224O00060008000200062O0006008B000100010004F83O008B0001002E1D0024008C000100230004F83O008C000100201000020002002500120C010500023O000EF000020091000100050004F83O00910001002E1D0027007F000100260004F83O007F000100120C2O0100023O0004F83O009600010004F83O007F00010004F83O009600010004F83O007A0001002E1D00280009000100290004F83O00090001000E5600180009000100010004F83O0009000100120C010400014O0083000500053O002E1D002A009C0001002B0004F83O009C0001000E560001009C000100040004F83O009C000100120C010500013O0026C3000500A5000100010004F83O00A50001002E5E002C00FEFF2O002D0004F83O00A100012O0093000600014O0052000700023O00122O0008002E3O00122O0009002F6O0007000900024O00060006000700202O00060006001B4O00060002000200062O000600B1000100010004F83O00B10001002EC2003100B2000100300004F83O00B200010020100002000200322O0073000200023O0004F83O00A100010004F83O000900010004F83O009C00010004F83O000900010004F83O000A00010004F83O000900010004F83O00BB00010004F83O000200012O00613O00017O00043O0003083O00446562752O66557003143O00536861646F77576F72645061696E446562752O6603133O0056616D7069726963546F756368446562752O6603153O004465766F7572696E67506C61677565446562752O6602203O00064A0001001400013O0004F83O0014000100203B00023O00012O009300045O0020110104000400022O00CE00020004000200064A0002001200013O0004F83O0012000100203B00023O00012O009300045O0020110104000400032O00CE00020004000200064A0002001200013O0004F83O0012000100203B00023O00012O009300045O0020110104000400042O00CE0002000400022O0073000200023O0004F83O001F000100203B00023O00012O009300045O0020110104000400022O00CE00020004000200064A0002001E00013O0004F83O001E000100203B00023O00012O009300045O0020110104000400032O00CE0002000400022O0073000200024O00613O00017O001F3O00028O00026O00F03F025O00489240025O00A49D40025O00C08B40025O00808740027O0040025O0022A840025O006EAF40025O00F2B240025O0098964003053O007061697273025O0040A840025O00E88F4003093O0054696D65546F446965025O00C09840025O004CB14003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66025O00B09440025O00209E40025O0015B240025O00BEA640025O007AAE40025O00B07740025O00349540025O00C49540025O00A07640025O00D09640025O0078AB40025O0040954002903O00120C010200014O0083000300053O0026C300020006000100020004F83O00060001002E1D00040087000100030004F83O008700012O0083000500053O00120C010600013O002EC200060010000100050004F83O0010000100263301060010000100020004F83O0010000100263301030007000100070004F83O000700012O0073000500023O0004F83O0007000100263301060008000100010004F83O0008000100120C010700013O0026C300070017000100020004F83O00170001002E1D00090019000100080004F83O0019000100120C010600023O0004F83O00080001000E5600010013000100070004F83O00130001000E560002006E000100030004F83O006E000100120C010800013O00263301080067000100010004F83O0067000100120C010900013O0026C300090025000100010004F83O00250001002E5E000A003D0001000B0004F83O006000012O0083000500053O001211000A000C4O0095000B6O009D000A0002000C0004F83O005D000100120C010F00014O0083001000103O0026C3000F0030000100010004F83O00300001002E5E000D00FEFF2O000E0004F83O002C000100203B0011000E000F2O00090111000200022O0095001000113O002E1D0010004A000100110004F83O004A000100064A0001004A00013O0004F83O004A00012O009300115O0020260012000E00124O001400013O00202O0014001400134O001200146O00113O00024O00110010001100062O0004005D000100110004F83O005D000100120C011100013O002E1D00140041000100150004F83O0041000100263301110041000100010004F83O004100012O0095000400104O00950005000E3O0004F83O005D00010004F83O004100010004F83O005D000100064B0004005D000100100004F83O005D000100120C011100014O0083001200123O000E560001004E000100110004F83O004E000100120C011200013O002E5E00163O000100160004F83O0051000100263301120051000100010004F83O005100012O0095000400104O00950005000E3O0004F83O005D00010004F83O005100010004F83O005D00010004F83O004E00010004F83O005D00010004F83O002C0001000616010A002A000100020004F83O002A000100120C010900023O002E1D00170021000100180004F83O0021000100263301090021000100020004F83O0021000100120C010800023O0004F83O006700010004F83O00210001002E1D0019001E0001001A0004F83O001E00010026330108001E000100020004F83O001E000100120C010300073O0004F83O006E00010004F83O001E00010026C300030072000100010004F83O00720001002EC2001B00820001001C0004F83O0082000100120C010800013O000E560001007B000100080004F83O007B00010006893O0079000100010004F83O007900012O0083000900094O0073000900023O00120C010400013O00120C010800023O002E5E001D00F8FF2O001D0004F83O0073000100263301080073000100020004F83O0073000100120C010300023O0004F83O008200010004F83O0073000100120C010700023O0004F83O001300010004F83O000800010004F83O000700010004F83O008F00010026C30002008B000100010004F83O008B0001002EC2001E00020001001F0004F83O0002000100120C010300014O0083000400043O00120C010200023O0004F83O000200012O00613O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O00206A00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00013O0003093O0054696D65546F44696501043O00203B00013O00012O00092O01000200022O0073000100024O00613O00017O00023O00030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6601063O00206A00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O000E3O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O002840030B3O008ED12148B2CE035EBCCA2803043O002CDDB940030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E73030B3O0032EF495B7C16C45A5E600903053O00136187283F03083O00496E466C6967687403113O0099543A283F34BC553D3C1C39AF583C2C3C03063O0051CE3C535B4F030B3O004973417661696C61626C6501333O0020A000013O00014O00035O00202O0003000300024O00010003000200062O0001003100013O0004F83O0031000100203B00013O00032O00092O0100020002000E2D0004002F000100010004F83O002F00012O009300016O0003010200013O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200203F00023O00084O00045O00202O0004000400024O00020004000200062O00020022000100010004F83O002200012O009300016O0003000200013O00122O000300093O00122O0004000A6O0002000400024O00010001000200202O00010001000B4O00010002000200062O0001003000013O0004F83O003000012O0093000100023O00068900010031000100010004F83O003100012O009300016O0003010200013O00122O0003000C3O00122O0004000D6O0002000400024O00010001000200202O00010001000E4O0001000200022O004F2O0100013O0004F83O003100012O006000016O0022000100014O0073000100024O00613O00017O00083O0003103O006AA2C36620D159A14A99D57323CA59BD03083O00C42ECBB0124FA32D030B3O004973417661696C61626C65026O00F03F030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66030F3O00496E73616E69747944656669636974026O003040011D4O007F00018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200062O0001001A00013O0004F83O001A00012O0093000100023O0026C30001001A000100040004F83O001A000100203B00013O00052O001600035O00202O0003000300064O0001000300024O000200033O00062O00010007000100020004F83O001A00012O0093000100043O00203B0001000100072O00092O010002000200260A2O01001A000100080004F83O001A00012O006000016O0022000100014O0073000100024O00613O00017O00053O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603103O009C2B6D0A2BE9FBBD264C1B25F7E6AC3B03073O008FD8421E7E449B030B3O004973417661696C61626C6501153O00204A2O013O00014O00035O00202O0003000300024O0001000300024O000200013O00062O0001000C000100020004F83O001200012O009300016O0003010200023O00122O000300033O00122O000400046O0002000400024O00010001000200202O0001000100054O0001000200022O004F2O0100013O0004F83O001300012O006000016O0022000100014O0073000100024O00613O00017O000C3O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O0087C103CFE7AFD6F2BE03083O0081CAA86DABA5C3B7030B3O004578656375746554696D6503093O000F5139DCFC18E7314C03073O0086423857B8BE7403103O0046752O6C526563686172676554696D6503093O00113807BF3BE720262803083O00555C5169DB798B4103093O00D0BA5E415ED3FCA04403063O00BF9DD330251C014D3O00203B00013O00012O009300035O0020110103000300022O00CE0001000300022O001A01028O000300013O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002002F000100010004F83O002F00012O009300016O0003010200013O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O0001000200022O0093000200024O0093000300034O009300046O001C000500013O00122O000600093O00122O0007000A6O0005000700024O0004000400050020300104000400054O000400056O00023O00024O000300046O000400036O00056O001C000600013O00122O000700093O00122O0008000A6O0006000800024O0005000500060020190105000500054O000500066O00033O00024O00020002000300062O0001001C000100020004F83O004A00012O0093000100054O0036010200026O00038O000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O0003000300054O0003000200024O000400036O0002000400024O000300046O00048O000500013O00122O0006000B3O00122O0007000C6O0005000700024O00040004000500202O0004000400054O0004000200024O000500036O0003000500024O00020002000300062O00010002000100020004F83O004A00012O006000016O0022000100014O0073000100024O00613O00017O00053O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O6603093O00F216FA183DDE12F10F03053O005ABF7F947C03083O004361737454696D6501184O00B600018O00028O000300016O00010003000200062O0001001600013O0004F83O0016000100203B00013O00012O0093000300013O0020110103000300022O00CE0001000300022O0093000200014O0003010300023O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062E01020002000100010004F83O001500012O006000016O0022000100014O0073000100024O00613O00017O00063O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O66030D3O00446562752O6652656D61696E7303093O0054696D65546F44696503083O0042752O66446F776E030C3O00566F6964666F726D42752O6601183O0020BD00013O00014O00035O00202O0003000300024O00010003000200062O00010016000100010004F83O0016000100203B00013O00032O00B800035O00202O0003000300024O00010003000200202O00023O00044O00020002000200062O00010014000100020004F83O001400012O0093000100013O0020B30001000100054O00035O00202O0003000300064O00010003000200044O001600012O006000016O0022000100014O0073000100024O00613O00017O000B3O0003103O004865616C746850657263656E74616765026O003440030F3O00432O6F6C646F776E52656D61696E73026O00244003123O0051892B047B863E167A8B2B2377952312769303043O007718E74E030B3O004973417661696C61626C6503123O00AB23A059DF4101832FA94FE84F038F28AB5E03073O0071E24DC52ABC2003063O0042752O66557003103O004465617468737065616B657242752O66012A3O00203B00013O00012O00092O01000200020026A900010013000100020004F83O001300012O009300015O00203B0001000100032O00092O0100020002000EA800040027000100010004F83O002700012O0093000100014O0003000200023O00122O000300053O00122O000400066O0002000400024O00010001000200202O0001000100074O00010002000200062O0001002700013O0004F83O002700012O0093000100033O00064A0001002000013O0004F83O002000012O0093000100014O0052000200023O00122O000300083O00122O000400096O0002000400024O00010001000200202O0001000100074O00010002000200062O00010028000100010004F83O002800012O0093000100043O0020B300010001000A4O000300013O00202O00030003000B4O00010003000200044O002800012O006000016O0022000100014O0073000100024O00613O00017O00073O0003103O004865616C746850657263656E74616765026O00344003063O0042752O66557003103O004465617468737065616B657242752O6603073O0048617354696572026O003F40027O004001153O00203B00013O00012O00092O010002000200265100010012000100020004F83O001200012O009300015O0020BD0001000100034O000300013O00202O0003000300044O00010003000200062O00010013000100010004F83O001300012O009300015O0020A700010001000500122O000300063O00122O000400076O00010004000200044O001300012O006000016O0022000100014O0073000100024O00613O00017O00023O0003103O004865616C746850657263656E74616765026O00344001083O00203B00013O00012O00092O010002000200265100010005000100020004F83O000500012O006000016O0022000100014O0073000100024O00613O00017O00073O0003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O66027O004003123O001318F1A63917E4B4381AF1813504F9B0340203043O00D55A7694030B3O004973417661696C61626C65026O001C40011D3O0020A000013O00014O00035O00202O0003000300024O00010003000200062O0001001B00013O0004F83O001B00012O0093000100013O0026BE00010019000100030004F83O001900012O0093000100023O00064A0001001B00013O0004F83O001B00012O009300016O0003000200033O00122O000300043O00122O000400056O0002000400024O00010001000200202O0001000100064O00010002000200062O0001001B00013O0004F83O001B00012O0093000100043O00260A2O01001A000100070004F83O001A00012O006000016O0022000100014O0073000100024O00613O00017O00023O00030D3O00446562752O6652656D61696E7303143O00536861646F77576F72645061696E446562752O6601063O00206A00013O00014O00035O00202O0003000300024O0001000300024O000100028O00017O00033O00030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66026O000440010A3O00207500013O00014O00035O00202O0003000300024O000100030002000E2O00030007000100010004F83O000700012O006000016O0022000100014O0073000100024O00613O00017O00053O0003113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603093O0054696D65546F446965026O00324003083O00446562752O66557001173O0020A000013O00014O00035O00202O0003000300024O00010003000200062O0001001500013O0004F83O0015000100203B00013O00032O00092O0100020002000E2D00040013000100010004F83O0013000100203B00013O00052O009300035O0020110103000300022O00CE00010003000200068900010015000100010004F83O001500012O0093000100014O004F2O0100013O0004F83O001500012O006000016O0022000100014O0073000100024O00613O00017O00093O00030B3O006826B552424C0DA6575E5303053O002D3B4ED436030F3O00432O6F6C646F776E52656D61696E73030D3O00446562752O6652656D61696E7303133O0056616D7069726963546F756368446562752O6603113O00446562752O665265667265736861626C6503093O0054696D65546F446965026O00324003083O00446562752O665570012A4O003600018O000200013O00122O000300013O00122O000400026O0002000400024O00010001000200202O0001000100034O00010002000200202O00023O00044O00045O00202O0004000400054O00020004000200062O00020004000100010004F83O001100012O0093000100023O00064A0001002700013O0004F83O0027000100203B00013O00062O009300035O0020110103000300052O00CE00010003000200064A0001002600013O0004F83O0026000100203B00013O00072O00092O0100020002000E2D00080024000100010004F83O0024000100203B00013O00092O009300035O0020110103000300052O00CE00010003000200068900010026000100010004F83O002600012O0093000100034O004F2O0100013O0004F83O002600012O006000016O0022000100014O0073000100024O0083000100014O0073000100024O00613O00019O002O0001064O001D2O018O00028O00038O0001000300024O000100028O00017O00543O00028O00026O00F03F025O00889D40025O00C05E40027O0040025O004C9A40025O0002A840030D3O0037330B2A54133B050E5214310E03053O003D6152665A030A3O0049734361737461626C65030B3O009F26AA4FC8403D1BAD3DA303083O0069CC4ECB2BA7377E030B3O004973417661696C61626C65030B3O0096A2221A1C13E443A4B92B03083O0031C5CA437E7364A7030C3O00432O6F6C646F776E446F776E030B3O000453DE2D8F417D255ACC2103073O003E573BBF49E03603083O00496E466C69676874025O00089E40025O00DAA440030D3O0056616D7069726963546F756368030E3O0049735370652O6C496E52616E6765031B3O00F103F7D9EE10F3CAD816F5DCE40ABAD9F507F9C6EA00FBDDA753AE03043O00A987629A030E3O00F87F2550F224FFC4652064FC3AC603073O00A8AB1744349D5303063O00D978E6A8373403073O00E7941195CD454D030E3O00536861646F77576F72645061696E025O00406040025O00A0A940031D3O0093AFC6FF58E8BFB0C8E953C090A6CEF517EF92A2C4F45AFD81B387AA0103063O009FE0C7A79B37025O0042B340025O005DB04003043O0047554944025O003C9240025O00449740030D3O003144808A882B99FF024486859203083O00907036E3EBE64ECD025O00B0AF40025O00F08440030D3O00417263616E65546F2O72656E74031A3O00B23A0CFDDE5E8C3C00EEC25EBD3C4FECC25EB02702FED14FF37E03063O003BD3486F9CB0025O00907440025O00E07C4003093O004973496E506172747903083O004973496E52616964025O00A6A940025O00F49040030B3O007D8FE2294190C03F4F94EB03043O004D2EE78303073O00995BB846B346BB03043O0020DA34D6030B3O00536861646F77437261736803093O004973496E52616E6765026O004440025O00B88740025O0018B04003183O005D1F30ACFEA77A595C1622A0B1A0575F4D183CAAF0A4050203083O003A2E7751C891D02503123O000E8235A1B0FD03258835BEE99E23399F3FBE03073O00564BEC50CCC9DD025O00406940025O00EEA74003063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F72025O000C9940025O00FCB14003183O0061497681F19C4D426584ED8332516580FD847F437691BED303063O00EB122117E59E03093O0071AE819845A8D2B44203043O00DB30DAA1025O0040A440025O00E89840025O0026A140025O0084B34003183O00F7797D4DD458DFE7637D5AD30FF0F6747F46D64DE1F0312403073O008084111C29BB2F025O00108D40025O00508940002E012O00120C012O00014O0083000100023O0026C33O0006000100020004F83O00060001002EC2000300252O0100040004F83O00252O010026C30001000A000100050004F83O000A0001002EC200070070000100060004F83O007000012O009300036O0003000400013O00122O000500083O00122O000600096O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003003400013O0004F83O003400012O009300036O0003000400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003003600013O0004F83O003600012O009300036O0003000400013O00122O0005000E3O00122O0006000F6O0004000600024O00030003000400202O0003000300104O00030002000200062O0003003200013O0004F83O003200012O009300036O0003000400013O00122O000500113O00122O000600126O0004000600024O00030003000400202O0003000300134O00030002000200062O0003003600013O0004F83O0036000100068900020036000100010004F83O00360001002EC200150048000100140004F83O004800012O0093000300024O000801045O00202O0004000400164O000500033O00202O0005000500174O00075O00202O0007000700164O0005000700024O000500056O000600016O00030006000200062O0003004800013O0004F83O004800012O0093000300013O00120C010400183O00120C010500194O0043010300054O000C00036O009300036O0003000400013O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O00030003000A4O00030002000200062O0003002D2O013O0004F83O002D2O012O009300036O0052000400013O00122O0005001C3O00122O0006001D6O0004000600024O00030003000400202O00030003000D4O00030002000200062O0003002D2O0100010004F83O002D2O012O0093000300024O005700045O00202O00040004001E4O000500033O00202O0005000500174O00075O00202O00070007001E4O0005000700024O000500056O00030005000200062O0003006A000100010004F83O006A0001002E5E001F00C5000100200004F83O002D2O012O0093000300013O001218010400213O00122O000500226O000300056O00035O00044O002D2O010026332O0100A5000100010004F83O00A5000100120C010300013O0026C300030077000100010004F83O00770001002EC20023009E000100240004F83O009E00012O0093000400033O00203B0004000400252O00090104000200022O00B7000400043O002E1D0026009D000100270004F83O009D00012O009300046O0003000500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O00040004000A4O00040002000200062O0004009D00013O0004F83O009D00012O0093000400053O00064A0004009D00013O0004F83O009D0001002EC2002B009D0001002A0004F83O009D00012O0093000400024O005501055O00202O00050005002C4O000600033O00202O0006000600174O00085O00202O00080008002C4O0006000800024O000600066O00040006000200062O0004009D00013O0004F83O009D00012O0093000400013O00120C0105002D3O00120C0106002E4O0043010400064O000C00045O00120C010300023O002E1D002F0073000100300004F83O0073000100263301030073000100020004F83O0073000100120C2O0100023O0004F83O00A500010004F83O007300010026332O010006000100020004F83O0006000100120C010300013O002633010300AC000100020004F83O00AC000100120C2O0100053O0004F83O00060001002633010300A8000100010004F83O00A800012O0093000400063O00203B0004000400312O00090104000200020006FE000200B7000100040004F83O00B700012O0093000400063O00203B0004000400322O00090104000200022O004F010200043O002E1D003400212O0100330004F83O00212O012O009300046O0003000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400212O013O0004F83O00212O01000689000200212O0100010004F83O00212O012O0093000400074O0077000500013O00122O000600373O00122O000700386O00050007000200062O000400DF000100050004F83O00DF00012O0093000400024O003200055O00202O0005000500394O000600033O00202O00060006003A00122O0008003B6O0006000800024O000600066O00040006000200062O000400D9000100010004F83O00D90001002E1D003D00212O01003C0004F83O00212O012O0093000400013O0012180105003E3O00122O0006003F6O000400066O00045O00044O00212O012O0093000400074O0077000500013O00122O000600403O00122O000700416O00050007000200062O000400062O0100050004F83O00062O01002E1D004200212O0100430004F83O00212O012O0093000400083O00203B0004000400442O000901040002000200064A000400212O013O0004F83O00212O012O0093000400063O00203B0004000400452O0093000600084O00CE00040006000200064A000400212O013O0004F83O00212O012O0093000400024O0032000500093O00202O0005000500464O000600033O00202O00060006003A00122O0008003B6O0006000800024O000600066O00040006000200062O00042O002O0100010004F84O002O01002E1D004800212O0100470004F83O00212O012O0093000400013O001218010500493O00122O0006004A6O000400066O00045O00044O00212O012O0093000400074O0062000500013O00122O0006004B3O00122O0007004C6O00050007000200062O0004000F2O0100050004F83O000F2O01002EC2004D00212O01004E0004F83O00212O012O0093000400024O0032000500093O00202O0005000500464O000600033O00202O00060006003A00122O0008003B6O0006000800024O000600066O00040006000200062O0004001C2O0100010004F83O001C2O01002EC2005000212O01004F0004F83O00212O012O0093000400013O00120C010500513O00120C010600524O0043010400064O000C00045O00120C010300023O0004F83O00A800010004F83O000600010004F83O002D2O01000EF0000100292O013O0004F83O00292O01002EC200530002000100540004F83O0002000100120C2O0100014O0083000200023O00120C012O00023O0004F83O000200012O00613O00017O00253O00028O00025O00BAB240025O0014A540025O00588140025O00388140030B3O00C4FB3DD6F8E41FC0F6E03403043O00B297935C03083O00496E466C6967687403113O00BBF5452102496885F34B011A4D7E83EA5F03073O001AEC9D2C52722C030B3O004973417661696C61626C65026O00F03F025O00507040025O003AAE40025O00E07440025O00D4A740030C3O001C21DC5F0F3CC04B3E27DA5503043O003B4A4EB5030F3O00432O6F6C646F776E52656D61696E732O033O00474344026O000840030C3O0013DE535E9637C44A4EBA2ADF03053O00D345B12O3A030D3O0093E46BFEC8D8B4E077E6E0C4B903063O00ABD785199589030A3O00432O6F6C646F776E5570030D3O00C5C920F1CE23FF47EFDB3BF5E103083O002281A8529A8F509C030B3O00B3BD3A0F7C419B97B73D1F03073O00E9E5D2536B282E030B3O00F1512BD50DC8411EDF0BCA03053O0065A12252B6030B3O00DE0250FAEFED903CED034D03083O004E886D399EBB82E2026O00104003083O0042752O66446F776E030C3O00566F6964666F726D42752O6600983O00120C012O00014O0083000100013O000E560001000200013O0004F83O0002000100120C2O0100013O000E560001003C000100010004F83O003C000100120C010200013O0026C30002000C000100010004F83O000C0001002E1D00020035000100030004F83O0035000100120C010300013O000EF000010011000100030004F83O00110001002EC200040030000100050004F83O003000012O0093000400014O0093000500024O002200066O00CE00040006000200068900040029000100010004F83O002900012O0093000400034O0003000500043O00122O000600063O00122O000700076O0005000700024O00040004000500202O0004000400084O00040002000200062O0004002900013O0004F83O002900012O0093000400034O0003010500043O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O0004000200022O00B700046O003F010400016O000500026O000600016O0004000600024O000400053O00122O0003000C3O0026330103000D0001000C0004F83O000D000100120C0102000C3O0004F83O003500010004F83O000D0001002E1D000D00080001000E0004F83O00080001002633010200080001000C0004F83O0008000100120C2O01000C3O0004F83O003C00010004F83O000800010026C3000100400001000C0004F83O00400001002E1D001000050001000F0004F83O000500012O0093000200034O0003010300043O00122O000400113O00122O000500126O0003000500024O00020002000300202O0002000200134O0002000200022O00AD000300073O00202O0003000300144O00030002000200202O00030003001500062O00020058000100030004F83O005800012O0093000200034O0052000300043O00122O000400163O00122O000500176O0003000500024O00020002000300202O00020002000B4O00020002000200062O00020092000100010004F83O009200012O0093000200034O0003000300043O00122O000400183O00122O000500196O0003000500024O00020002000300202O00020002001A4O00020002000200062O0002006C00013O0004F83O006C00012O0093000200034O0052000300043O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O00020002000B4O00020002000200062O00020092000100010004F83O009200012O0093000200034O0003000300043O00122O0004001D3O00122O0005001E6O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009200013O0004F83O009200012O0093000200034O0003000300043O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O00020002000B4O00020002000200062O0002009200013O0004F83O009200012O0093000200034O004E000300043O00122O000400213O00122O000500226O0003000500024O00020002000300202O0002000200134O00020002000200262O00020090000100230004F83O009000012O0093000200073O0020B30002000200244O000400033O00202O0004000400254O00020004000200044O009200012O006000026O0022000200014O00B7000200063O0004F83O009700010004F83O000500010004F83O009700010004F83O000200012O00613O00017O00333O00028O00026O00F03F025O008AAC40025O00C7B240025O004CAA40025O004EAC40025O0010B240025O00049E40025O0050A040025O00789F40025O00C2A940025O0052B240025O00807840025O00B8A940027O0040025O00C05D40025O00B3B14003093O0054696D65546F446965026O003240025O0056A340025O002EAE40025O001AA140025O00F49A40026O00084003133O00078371AC389075BF058D69BF39A679BE24847A03043O00DC51E21C030F3O0041757261416374697665436F756E74026O002040025O00D49A40025O009AAA40025O00805D40025O00609D40025O0040A940025O0008914003133O00083EF4E1372DF0F20A30ECF2361BFCF32B39FF03043O00915E5F99030B3O00CEC515D141A0DEDF15C64603063O00D79DAD74B52E03083O00496E466C6967687403113O0002BC82E1CA30A682FCDD06BC8AF6D522A703053O00BA55D4EB92030B3O004973417661696C61626C6503113O00F5891FED29EB4ACB8F11CD31EF5CCD960503073O0038A2E1769E598E03133O006A04CDBF2BCA5506F4A037DB5421C5AD37DE5A03063O00B83C65A0CF42026O001040025O0032A940025O00D09C40025O0044A540025O00A5B240000D012O00120C012O00014O0083000100033O002633012O00042O0100020004F83O00042O012O0083000300033O002EC20003000C000100040004F83O000C00010026332O01000C000100010004F83O000C000100120C010200014O0083000300033O00120C2O0100023O002EC200050005000100060004F83O000500010026332O010005000100020004F83O000500010026C300020014000100010004F83O00140001002E5E0007001A000100080004F83O002C000100120C010400014O0083000500053O00263301040016000100010004F83O0016000100120C010500013O0026C30005001D000100020004F83O001D0001002E1D0009001F0001000A0004F83O001F000100120C010200023O0004F83O002C000100263301050019000100010004F83O001900012O0093000600014O0033000700026O000800036O0006000800024O00068O00068O000600043O00122O000500023O00044O001900010004F83O002C00010004F83O001600010026C300020030000100020004F83O00300001002E1D000C00560001000B0004F83O0056000100120C010400013O002EC2000D00370001000E0004F83O0037000100263301040037000100020004F83O0037000100120C0102000F3O0004F83O005600010026C30004003B000100010004F83O003B0001002EC200110031000100100004F83O0031000100120C010500013O0026330105004E000100010004F83O004E00012O0093000600054O002C000700066O000800016O0006000800024O000300063O00062O0003004900013O0004F83O0049000100203B0006000300122O0009010600020002000EA80013004B000100060004F83O004B0001002E1D0015004D000100140004F83O004D00012O0022000600014O00B7000600043O00120C010500023O002EC20017003C000100160004F83O003C00010026330105003C000100020004F83O003C000100120C010400023O0004F83O003100010004F83O003C00010004F83O00310001000E5600180081000100020004F83O008100012O0093000400084O0093000500094O00030106000A3O00122O000700193O00122O0008001A6O0006000800024O00050005000600202O00050005001B4O0005000200022O005F0006000B6O0007000C6O000700076O00060002000200102O0006001C00064O0004000600024O0005000D6O000600094O00030107000A3O00122O000800193O00122O0009001A6O0007000900024O00060006000700202O00060006001B4O0006000200022O00370107000B6O0008000C6O000800086O00070002000200102O0007001C00074O0005000700024O0004000400054O00055O00062O00050005000100040004F83O007E00012O0093000400044O004F010400043O0004F83O007F00012O006000046O0022000400014O00B7000400073O0004F83O000C2O01002E1D001D00100001001E0004F83O00100001002633010200100001000F0004F83O0010000100120C010400013O0026C30004008A000100010004F83O008A0001002E5E001F0073000100200004F83O00FB000100120C010500013O002E1D002200F4000100210004F83O00F40001002633010500F4000100010004F83O00F400012O0093000600084O00F6000700096O0008000A3O00122O000900233O00122O000A00246O0008000A00024O00070007000800202O00070007001B4O0007000200024O0008000B6O000900096O000A000A3O00122O000B00253O00122O000C00266O000A000C00024O00090009000A00202O0009000900274O00090002000200062O000900AB00013O0004F83O00AB00012O0093000900094O0003010A000A3O00122O000B00283O00122O000C00296O000A000C00024O00090009000A00202O00090009002A4O0009000200022O00090108000200020010AA0008001C00084O0006000800024O0007000D6O000800096O0009000A3O00122O000A00233O00122O000B00246O0009000B00024O00080008000900202O00080008001B4O0008000200024O0009000B6O000A00096O000B000A3O00122O000C00253O00122O000D00266O000B000D00024O000A000A000B00202O000A000A00274O000A0002000200062O000A00CA00013O0004F83O00CA00012O0093000A00094O0003010B000A3O00122O000C00283O00122O000D00296O000B000D00024O000A000A000B00202O000A000A002A4O000A000200022O00090109000200020010480009001C00094O0007000900024O0006000600074O00075O00062O00070005000100060004F83O00D500012O0093000600044O004F010600063O0004F83O00D600012O006000066O0022000600014O00B70006000E4O00930006000C3O00064A000600F300013O0004F83O00F300012O0093000600094O00030007000A3O00122O0008002B3O00122O0009002C6O0007000900024O00060006000700202O00060006002A4O00060002000200062O000600F300013O0004F83O00F300012O009300066O00D0000700096O0008000A3O00122O0009002D3O00122O000A002E6O0008000A00024O00070007000800202O00070007001B4O0007000200024O00060006000700262O000600F10001002F0004F83O00F100012O006000066O0022000600014O00B70006000C3O00120C010500023O002E1D0031008B000100300004F83O008B00010026330105008B000100020004F83O008B000100120C010400023O0004F83O00FB00010004F83O008B000100263301040086000100020004F83O0086000100120C010200183O0004F83O001000010004F83O008600010004F83O001000010004F83O000C2O010004F83O000500010004F83O000C2O01000EF0000100082O013O0004F83O00082O01002EC200330002000100320004F83O0002000100120C2O0100014O0083000200023O00120C012O00023O0004F83O000200012O00613O00017O00183O0003063O0042752O665570030C3O00566F6964666F726D42752O6603113O00506F776572496E667573696F6E42752O6603113O004461726B417363656E73696F6E42752O66026O003440028O00025O005C9B40025O00F07740026O00F03F03133O0048616E646C65426F2O746F6D5472696E6B65742O033O00434473026O004440025O00C09340025O0083B040025O00208E40025O00F5B140025O004CA540025O00D4B040025O000FB240025O0092A140025O0010814003103O0048616E646C65546F705472696E6B6574025O0020A540025O0072AC40005F4O007A7O00206O00014O000200013O00202O0002000200026O0002000200064O0018000100010004F83O001800012O00937O0020BD5O00014O000200013O00202O0002000200036O0002000200064O0018000100010004F83O001800012O00937O0020BD5O00014O000200013O00202O0002000200046O0002000200064O0018000100010004F83O001800012O00933O00023O0026A93O005E000100050004F83O005E000100120C012O00064O0083000100013O002E1D0008001A000100070004F83O001A0001002633012O001A000100060004F83O001A000100120C2O0100063O0026332O010031000100090004F83O003100012O0093000200043O00200B01020002000A4O000300053O00122O0004000B3O00122O0005000C6O000600066O0002000600024O000200033O002E2O000D005E0001000E0004F83O005E00012O0093000200033O00064A0002005E00013O0004F83O005E00012O0093000200034O0073000200023O0004F83O005E0001002E5E000F00EEFF2O000F0004F83O001F00010026332O01001F000100060004F83O001F000100120C010200063O0026C30002003A000100060004F83O003A0001002E5E0010001C000100110004F83O0054000100120C010300063O0026C30003003F000100090004F83O003F0001002E5E00120004000100130004F83O0041000100120C010200093O0004F83O00540001002E1D0015003B000100140004F83O003B00010026330103003B000100060004F83O003B00012O0093000400043O0020DB0004000400164O000500053O00122O0006000B3O00122O0007000C6O000800086O0004000800024O000400036O000400033O00062O0004005200013O0004F83O005200012O0093000400034O0073000400023O00120C010300093O0004F83O003B0001002EC200170036000100180004F83O0036000100263301020036000100090004F83O0036000100120C2O0100093O0004F83O001F00010004F83O003600010004F83O001F00010004F83O005E00010004F83O001A00012O00613O00017O007B3O00028O00030B3O0020DD83FFE5D030C783E8E203063O00A773B5E29B8A030A3O0049734361737461626C65030A3O00446562752O66446F776E03133O0056616D7069726963546F756368446562752O66025O00B5B040025O00D0954003073O00C12DE95A7263CB03073O00A68242873C1B11030B3O00536861646F77437261736803093O004973496E52616E6765026O00444003153O005742CF713F5375CD673157428E7A204144CB67701603053O0050242AAE1503123O006B1E3277575002744A15253A6D052569410203043O001A2E705703063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203153O00AA2BAA70B0A87AB7AB22B87CFFB055B1B726B934ED03083O00D4D943CB142ODF2503093O009B99E8F1AF9FBBDDA803043O00B2DAEDC803153O00A5BDE7D4B9A2D9D3A4B4F5D8F6BAF6D5B8B0F490E403043O00B0D6D586030D3O00C2ACBBC4A14450F799B9C1AB5E03073O003994CDD6B4C836030B3O0021F534307905DE2735651A03053O0016729D5554030C3O00432O6F6C646F776E446F776E030B3O00F7C312C052E18BD6CA00CC03073O00C8A4AB73A43D96030B3O004973417661696C61626C65030D3O0056616D7069726963546F756368030E3O0049735370652O6C496E52616E676503173O00A8F50E558AACFD007A97B1E1004DC3B1E4064B86ACB45003053O00E3DE946325026O00F03F025O0054B040025O00E07640025O00A06240025O0086B14003133O003E5B5CF2FB365C56F3EB735D42F3F7364012A203053O0099532O3296025O00308440025O00349040027O004003083O00C57EFF083245FF6503063O002A9311966C7003083O00566F6964426F6C7403133O0019A9247BD8EA00AA393FE8F80AA8286DA7B95903063O00886FC64D1F87030F3O00260CB159A8F61EA70539AB57BAF11203083O00C96269C736DD847703073O0049735265616479030F3O004465766F7572696E67506C61677565031A3O00BD09952E1727A5B70BBC310E34ABAC09C32E1230A2BC1EC3705A03073O00CCD96CE3416255026O000840025O001CAC40025O0034AD4003093O0073CAFBE10ECC5FD0E103063O00A03EA395854C025O00B88940025O00988C4003093O004D696E64426C617374025O0062B340025O000DB14003143O00DBA9032BFCD4AC0C3CD796AF1D2ACDD3B24D7D9303053O00A3B6C06D4F03093O00192F0EC4C6242F0BC503053O0095544660A0025O00188440025O0044974003093O004D696E645370696B6503143O00350F03E907151DE433034DE2282O03E82A465FBF03043O008D58666D03083O009E5AC4743C3154D803083O00A1D333AA107A5D3503083O004D696E64466C6179025O00B07D40025O004FB04003133O00F6A7BC2CC4A8BE29E2EEBD38FEA0B73ABBFCE603043O00489BCED2030D3O007977611752B84E587860157CA503073O002D3D16137C13CB025O00C4A540025O00405E40025O00A09D40025O00FEA540030D3O004461726B417363656E73696F6E03173O00C5131FFE3D71AAC21703E60B7FB7812O1DF00C75AB814403073O00D9A1726D956210030C3O00242F3178996607302C75B37A03063O00147240581CDC030F3O000209D3B0F7C78A3E13D690FDD1A93903073O00DD5161B2D498B003123O00E4E918E819CCF71CF916C8D312E917C8E90903053O007AAD877D9B03083O005072657647434450030F3O00B7C901BD3026FF8BD3049D3A30DC8C03073O00A8E4A160D95F5103113O0054696D6553696E63654C61737443617374026O003440025O0014A040025O0058A240030F3O00536861646F77576F72644465617468031A3O00C8D92F582040E4C6214E2B68DFD42F482717D4C12B522A459B8903063O0037BBB14E3C4F03094O00C751EF64C3813EDA03073O00E04DAE3F8B26AF03143O008948562ABB43542F975518219444562B9601097E03043O004EE42138025O0092AB40025O007C9B40030C3O00F871BB07A0DC6BA2178CC17003053O00E5AE1ED263030C3O00566F69644572757074696F6E03173O000DE28F55D2382B0EFD9258E2337914FD835FE82F794ABF03073O00597B8DE6318D5D025O00607640025O00649D40002A022O00120C012O00014O0083000100013O002633012O0002000100010004F83O0002000100120C2O0100013O0026332O0100C2000100010004F83O00C2000100120C010200013O002633010200A7000100010004F83O00A700012O009300036O0003000400013O00122O000500023O00122O000600036O0004000600024O00030003000400202O0003000300044O00030002000200062O0003001B00013O0004F83O001B00012O0093000300023O0020BD0003000300054O00055O00202O0005000500064O00030005000200062O0003001D000100010004F83O001D0001002EC20007006F000100080004F83O006F00012O0093000300034O0077000400013O00122O000500093O00122O0006000A6O00040006000200062O00030035000100040004F83O003500012O0093000300044O005900045O00202O00040004000B4O000500023O00202O00050005000C00122O0007000D6O0005000700024O000500056O00030005000200062O0003006F00013O0004F83O006F00012O0093000300013O0012180104000E3O00122O0005000F6O000300056O00035O00044O006F00012O0093000300034O0077000400013O00122O000500103O00122O000600116O00040006000200062O00030058000100040004F83O005800012O0093000300053O00203B0003000300122O000901030002000200064A0003006F00013O0004F83O006F00012O0093000300063O00203B0003000300132O0093000500054O00CE00030005000200064A0003006F00013O0004F83O006F00012O0093000300044O0059000400073O00202O0004000400144O000500023O00202O00050005000C00122O0007000D6O0005000700024O000500056O00030005000200062O0003006F00013O0004F83O006F00012O0093000300013O001218010400153O00122O000500166O000300056O00035O00044O006F00012O0093000300034O0077000400013O00122O000500173O00122O000600186O00040006000200062O0003006F000100040004F83O006F00012O0093000300044O0059000400073O00202O0004000400144O000500023O00202O00050005000C00122O0007000D6O0005000700024O000500056O00030005000200062O0003006F00013O0004F83O006F00012O0093000300013O00120C010400193O00120C0105001A4O0043010300054O000C00036O009300036O0003000400013O00122O0005001B3O00122O0006001C6O0004000600024O00030003000400202O0003000300044O00030002000200062O000300A600013O0004F83O00A600012O0093000300023O0020A00003000300054O00055O00202O0005000500064O00030005000200062O000300A600013O0004F83O00A600012O009300036O0052000400013O00122O0005001D3O00122O0006001E6O0004000600024O00030003000400202O00030003001F4O00030002000200062O00030094000100010004F83O009400012O009300036O0052000400013O00122O000500203O00122O000600216O0004000600024O00030003000400202O0003000300224O00030002000200062O000300A6000100010004F83O00A600012O0093000300084O00B000045O00202O0004000400234O000500066O000700023O00202O0007000700244O00095O00202O0009000900234O0007000900024O000700076O00030007000200064A000300A600013O0004F83O00A600012O0093000300013O00120C010400253O00120C010500264O0043010300054O000C00035O00120C010200273O000E5600270008000100020004F83O000800012O0093000300093O00203B0003000300042O000901030002000200064A000300B100013O0004F83O00B100012O00930003000A3O000689000300B3000100010004F83O00B30001002EC2002800BF000100290004F83O00BF00012O0093000300044O0093000400094O0009010300020002000689000300BA000100010004F83O00BA0001002EC2002B00BF0001002A0004F83O00BF00012O0093000300013O00120C0104002C3O00120C0105002D4O0043010300054O000C00035O00120C2O0100273O0004F83O00C200010004F83O00080001002E1D002E00092O01002F0004F83O00092O010026332O0100092O0100300004F83O00092O0100120C010200013O002633010200E9000100010004F83O00E900012O00930003000B3O00064A000300CE00013O0004F83O00CE00012O00930003000B4O0073000300024O009300036O0003000400013O00122O000500313O00122O000600326O0004000600024O00030003000400202O0003000300044O00030002000200062O000300E800013O0004F83O00E800012O0093000300044O005900045O00202O0004000400334O000500023O00202O00050005000C00122O0007000D6O0005000700024O000500056O00030005000200062O000300E800013O0004F83O00E800012O0093000300013O00120C010400343O00120C010500354O0043010300054O000C00035O00120C010200273O002633010200C7000100270004F83O00C700012O009300036O0003000400013O00122O000500363O00122O000600376O0004000600024O00030003000400202O0003000300384O00030002000200062O000300062O013O0004F83O00062O012O0093000300044O005501045O00202O0004000400394O000500023O00202O0005000500244O00075O00202O0007000700394O0005000700024O000500056O00030005000200062O000300062O013O0004F83O00062O012O0093000300013O00120C0104003A3O00120C0105003B4O0043010300054O000C00035O00120C2O01003C3O0004F83O00092O010004F83O00C70001002EC2003D006A2O01003E0004F83O006A2O010026332O01006A2O01003C0004F83O006A2O012O009300026O0052000300013O00122O0004003F3O00122O000500406O0003000500024O00020002000300202O0002000200044O00020002000200062O000200192O0100010004F83O00192O01002EC20042002D2O0100410004F83O002D2O012O0093000200044O008D00035O00202O0003000300434O000400023O00202O0004000400244O00065O00202O0006000600434O0004000600024O000400046O000500016O00020005000200062O000200282O0100010004F83O00282O01002EC20044002D2O0100450004F83O002D2O012O0093000200013O00120C010300463O00120C010400474O0043010200044O000C00026O009300026O0052000300013O00122O000400483O00122O000500496O0003000500024O00020002000300202O0002000200044O00020002000200062O000200392O0100010004F83O00392O01002EC2004B004B2O01004A0004F83O004B2O012O0093000200044O000801035O00202O00030003004C4O000400023O00202O0004000400244O00065O00202O00060006004C4O0004000600024O000400046O000500016O00020005000200062O0002004B2O013O0004F83O004B2O012O0093000200013O00120C0103004D3O00120C0104004E4O0043010200044O000C00026O009300026O0003000300013O00122O0004004F3O00122O000500506O0003000500024O00020002000300202O0002000200044O00020002000200062O0002002902013O0004F83O002902012O0093000200044O008D00035O00202O0003000300514O000400023O00202O0004000400244O00065O00202O0006000600514O0004000600024O000400046O000500016O00020005000200062O000200642O0100010004F83O00642O01002E5E005200C7000100530004F83O002902012O0093000200013O001218010300543O00122O000400556O000200046O00025O00044O002902010026332O010005000100270004F83O0005000100120C010200013O0026330102001E020100010004F83O001E02012O009300036O0052000400013O00122O000500563O00122O000600576O0004000600024O00030003000400202O0003000300044O00030002000200062O0003007B2O0100010004F83O007B2O01002E1D005800882O0100590004F83O00882O01002EC2005A00882O01005B0004F83O00882O012O0093000300044O009300045O00201101040004005C2O000901030002000200064A000300882O013O0004F83O00882O012O0093000300013O00120C0104005D3O00120C0105005E4O0043010300054O000C00036O009300036O0003000400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O0003000300224O00030002000200062O0003001D02013O0004F83O001D020100120C010300014O0083000400053O00263301030015020100270004F83O00150201002633010400962O0100010004F83O00962O0100120C010500013O002633010500F12O0100010004F83O00F12O012O009300066O0003000700013O00122O000800613O00122O000900626O0007000900024O00060006000700202O0006000600044O00060002000200062O000600C12O013O0004F83O00C12O012O009300066O0003000700013O00122O000800633O00122O000900646O0007000900024O00060006000700202O0006000600224O00060002000200062O000600C12O013O0004F83O00C12O012O0093000600063O00204901060006006500122O000800276O00095O00202O0009000900434O00060009000200062O000600C12O013O0004F83O00C12O012O009300066O0003010700013O00122O000800663O00122O000900676O0007000900024O00060006000700202O0006000600684O000600020002000ED9006900C32O0100060004F83O00C32O01002E5E006A00130001006B0004F83O00D42O012O0093000600044O005501075O00202O00070007006C4O000800023O00202O0008000800244O000A5O00202O000A000A006C4O0008000A00024O000800086O00060008000200062O000600D42O013O0004F83O00D42O012O0093000600013O00120C0107006D3O00120C0108006E4O0043010600084O000C00066O009300066O0003000700013O00122O0008006F3O00122O000900706O0007000900024O00060006000700202O0006000600044O00060002000200062O000600F02O013O0004F83O00F02O012O0093000600044O000801075O00202O0007000700434O000800023O00202O0008000800244O000A5O00202O000A000A00434O0008000A00024O000800086O000900016O00060009000200062O000600F02O013O0004F83O00F02O012O0093000600013O00120C010700713O00120C010800724O0043010600084O000C00065O00120C010500273O0026C3000500F52O0100270004F83O00F52O01002EC2007300992O0100740004F83O00992O012O009300066O0003000700013O00122O000800753O00122O000900766O0007000900024O00060006000700202O0006000600044O00060002000200062O0006001D02013O0004F83O001D02012O0093000600044O00C000075O00202O0007000700774O000800023O00202O00080008000C00122O000A000D6O0008000A00024O000800086O000900016O00060009000200062O0006001D02013O0004F83O001D02012O0093000600013O001218010700783O00122O000800796O000600086O00065O00044O001D02010004F83O00992O010004F83O001D02010004F83O00962O010004F83O001D02010026C300030019020100010004F83O00190201002E5E007A007DFF2O007B0004F83O00942O0100120C010400014O0083000500053O00120C010300273O0004F83O00942O0100120C010200273O0026330102006D2O0100270004F83O006D2O012O00930003000C4O004C0003000100022O00B70003000B3O00120C2O0100303O0004F83O000500010004F83O006D2O010004F83O000500010004F83O002902010004F83O000200012O00613O00017O00983O00028O00026O00F03F025O004C9F40025O00A6A540027O0040025O004EA440025O0080A24003093O00C3FEAC34DDE7AB3BEB03043O00508E97C2030A3O0049734361737461626C6503093O004D696E645370696B65030E3O0049735370652O6C496E52616E676503143O000ECF79483CD5674508C3374A0ACA7B491186261A03043O002C63A61703133O0071FE27320CA270F6307635AD70FB2C2473F52403063O00C41C97495653025O008AA540025O0054A040025O00B08640025O003C9840025O00A8A240025O00689E40030B3O00C00B28148D4F3B64F2102103083O001693634970E2387803073O009B7AECF384AA7803053O00EDD8158295025O00A3B240025O0050A940030B3O00536861646F77437261736803093O004973496E52616E6765026O004440025O00689D40025O0080584003163O0091465E5BBFDE61815C5E4CB889588B42535AA2890CD203073O003EE22E2O3FD0A9025O00CAB040025O00C9B04003123O00C017508E064D1A50E11C47C33C183D4DEA0B03083O003E857935E37F6D4F03063O0045786973747303093O0043616E412O7461636B03113O00536861646F774372617368437572736F7203163O00031C33F1D9B99D130633E6DEEEA419183EF0C4EEF04003073O00C270745295B6CE03093O0018BC0C3BD5F01D36BA03073O006E59C82C78A082025O0034A140025O0068B34003163O00B8CB4A424C5D044EB9C2584E034C3241A7C65906111A03083O002DCBA32B26232A5B025O00407840025O00E06440030F3O00E18DDD2788BE63DD97D80782A840DA03073O0034B2E5BC43E7C903073O004973526561647903093O00436173744379636C65030F3O00536861646F77576F7264446561746803183O00536861646F77576F726444656174684D6F7573656F766572031B3O0032495100F84B1C364E4200C8582620555844F1552F2D444244A50E03073O004341213064973C025O00788440025O0002A940026O000840025O0036AC40025O00F08D40030F3O00ECEFAFDCFCC8D0A1CAF7FBE2AFCCFB03053O0093BF87CEB803083O0049734D6F76696E67025O0046AC4003243O009720A7C5D7448D9327B4C5E757B7853CAE81D55CA48125A3CFCC13B48D24AAC4CA13E0D203073O00D2E448C6A1B833025O00D2AD40025O009C9E40030E3O000541F2147CD90146E11443CF3F4703063O00AE5629937013030C3O00436173745461726765744966030E3O00536861646F77576F72645061696E2O033O0056098303083O00CB3B60ED6B456F71025O0010A740025O00AEAD40031A3O00371EADE53EE7E83319BEE50EE0D62D18ECE738FCDB2104ECB36903073O00B74476CC815190026O006640025O00E49940025O00409940025O00ECAF40025O00B4A440025O00A09840025O00D07340025O00E0AC4003113O00A1354AE66012853741CB5D118D324DF64A03063O0062EC5C248233025O0070AA4003113O004D696E645370696B65496E73616E697479031C3O00A91002BE7ABBA539AF1C33B34BBBB43EAD0D15FA43A1B93CA10B4CEC03083O0050C4796CDA25C8D503083O002D7A0C7B6D028B1903073O00EA6013621F2B6E03063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O66025O001EAD40025O00BCA04003123O000B165CC3937487070612C1A57E87030D129F03073O00EB667F32A7CC12030D3O00707B591E3A5473573A3C53795C03053O0053261A346E03153O00556E6675726C696E674461726B6E652O7342752O66030D3O0056616D7069726963546F7563682O033O00551E2903043O002638774703173O00E5EE55C62C44FAEC67C22A43F0E718D02C5AFFEA4A967703063O0036938F38B645030F3O00E589FE4DD0C1B6F05BDBF284FE5DD703053O00BFB6E19F29031A3O00381A29518490FD3C1D3A51B483C72A0620158D8ECE27173A15DF03073O00A24B724835EBE7030A3O0066E74F894CEB6A9443FC03043O00E0228E3903103O004865616C746850657263656E74616765030C3O00446976696E6553746172485003103O00446976696E6553746172506C61796572026O003E4003103O00DAAED3D47DF4621DCAA6D79D7BF45C0203083O006EBEC7A5BD13913D03043O00F2EA7BE703063O00A7BA8B1788EB030D3O00546172676574497356616C6964031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503043O0048616C6F03093O0012B484025ABD8D0C1603043O006D7AD5E803093O007DA8FB27432F5DA4E603063O004E30C195432403093O004D696E6467616D657303133O003D178E1C463113850B0136178C1444225ED14803053O0021507EE078025O00409A40025O002EA440030F3O00DFA002C053FB9F0CD658C8AD02D05403053O003C8CC863A403123O00AEFA0135A186E40524AE82C00B34AF82FA1003053O00C2E7946446030B3O004973417661696C61626C65025O00709F40025O00E0A0402O033O004B45CF03063O00A8262CA1C396031B3O0093F483723FFF89018FEE864934EDB70288BC847F3CE4B304C0ADD003083O0076E09CE2165088D6025O004CA240025O00D6AC4000A4022O00120C012O00014O0083000100023O0026C33O0006000100020004F83O00060001002E5E00030097020100040004F83O009B02010026332O010006000100010004F83O0006000100120C010200013O002633010200E7000100050004F83O00E7000100120C010300014O0083000400043O000E560001000D000100030004F83O000D000100120C010400013O0026C300040014000100010004F83O00140001002E1D00060050000100070004F83O0050000100120C010500013O00263301050049000100010004F83O004900012O009300066O0003000700013O00122O000800083O00122O000900096O0007000900024O00060006000700202O00060006000A4O00060002000200062O0006003300013O0004F83O003300012O0093000600024O000801075O00202O00070007000B4O000800033O00202O00080008000C4O000A5O00202O000A000A000B4O0008000A00024O000800086O000900016O00060009000200062O0006003300013O0004F83O003300012O0093000600013O00120C0107000D3O00120C0108000E4O0043010600084O000C00066O0093000600043O00203B00060006000A2O000901060002000200064A0006004800013O0004F83O004800012O0093000600024O0006010700046O000800033O00202O00080008000C4O000A00046O0008000A00024O000800086O000900016O00060009000200062O0006004800013O0004F83O004800012O0093000600013O00120C0107000F3O00120C010800104O0043010600084O000C00065O00120C010500023O002EC200120015000100110004F83O0015000100263301050015000100020004F83O0015000100120C010400023O0004F83O005000010004F83O00150001002E1D001300DE000100140004F83O00DE0001002633010400DE000100020004F83O00DE0001002EC2001600BA000100150004F83O00BA00012O009300056O0003000600013O00122O000700173O00122O000800186O0006000800024O00050005000600202O00050005000A4O00050002000200062O000500BA00013O0004F83O00BA00012O0093000500054O0062000600013O00122O000700193O00122O0008001A6O00060008000200062O00050069000100060004F83O00690001002E5E001B00150001001C0004F83O007C00012O0093000500024O003200065O00202O00060006001D4O000700033O00202O00070007001E00122O0009001F6O0007000900024O000700076O00050007000200062O00050076000100010004F83O00760001002EC2002000BA000100210004F83O00BA00012O0093000500013O001218010600223O00122O000700236O000500076O00055O00044O00BA0001002E1D002500A1000100240004F83O00A100012O0093000500054O0077000600013O00122O000700263O00122O000800276O00060008000200062O000500A1000100060004F83O00A100012O0093000500063O00203B0005000500282O000901050002000200064A000500BA00013O0004F83O00BA00012O0093000500073O00203B0005000500292O0093000700064O00CE00050007000200064A000500BA00013O0004F83O00BA00012O0093000500024O0059000600083O00202O00060006002A4O000700033O00202O00070007001E00122O0009001F6O0007000900024O000700076O00050007000200062O000500BA00013O0004F83O00BA00012O0093000500013O0012180106002B3O00122O0007002C6O000500076O00055O00044O00BA00012O0093000500054O0077000600013O00122O0007002D3O00122O0008002E6O00060008000200062O000500BA000100060004F83O00BA0001002E1D002F00BA000100300004F83O00BA00012O0093000500024O0059000600083O00202O00060006002A4O000700033O00202O00070007001E00122O0009001F6O0007000900024O000700076O00050007000200062O000500BA00013O0004F83O00BA00012O0093000500013O00120C010600313O00120C010700324O0043010500074O000C00055O002EC2003400DD000100330004F83O00DD00012O009300056O0003000600013O00122O000700353O00122O000800366O0006000800024O00050005000600202O0005000500374O00050002000200062O000500DD00013O0004F83O00DD00012O0093000500093O0020180005000500384O00065O00202O0006000600394O0007000A6O0008000B6O000900033O00202O00090009000C4O000B5O00202O000B000B00394O0009000B00024O000900096O000A000B6O000C00083O00202O000C000C003A4O0005000C000200062O000500DD00013O0004F83O00DD00012O0093000500013O00120C0106003B3O00120C0107003C4O0043010500074O000C00055O00120C010400053O0026C3000400E2000100050004F83O00E20001002E5E003D0030FF2O003E0004F83O0010000100120C0102003F3O0004F83O00E700010004F83O001000010004F83O00E700010004F83O000D00010026330102003A2O01003F0004F83O003A2O01002EC20041000D2O0100400004F83O000D2O012O009300036O0003000400013O00122O000500423O00122O000600436O0004000600024O00030003000400202O0003000300374O00030002000200062O0003000D2O013O0004F83O000D2O012O0093000300073O00203B0003000300442O000901030002000200064A0003000D2O013O0004F83O000D2O01002E5E00450013000100450004F83O000D2O012O0093000300024O005501045O00202O0004000400394O000500033O00202O00050005000C4O00075O00202O0007000700394O0005000700024O000500056O00030005000200062O0003000D2O013O0004F83O000D2O012O0093000300013O00120C010400463O00120C010500474O0043010300054O000C00035O002EC2004900A3020100480004F83O00A302012O009300036O0003000400013O00122O0005004A3O00122O0006004B6O0004000600024O00030003000400202O0003000300374O00030002000200062O000300A302013O0004F83O00A302012O0093000300073O00203B0003000300442O000901030002000200064A000300A302013O0004F83O00A302012O0093000300093O0020EE00030003004C4O00045O00202O00040004004D4O0005000A6O000600013O00122O0007004E3O00122O0008004F6O0006000800024O0007000C6O000800084O0093000900033O00202601090009000C4O000B5O00202O000B000B004D4O0009000B00024O000900096O00030009000200062O000300342O0100010004F83O00342O01002E1D005100A3020100500004F83O00A302012O0093000300013O001218010400523O00122O000500536O000300056O00035O00044O00A30201002EC2005400E82O0100550004F83O00E82O01000E56000100E82O0100020004F83O00E82O0100120C010300013O000EF0000500432O0100030004F83O00432O01002EC2005700452O0100560004F83O00452O0100120C010200023O0004F83O00E82O01002EC2005900972O0100580004F83O00972O01002633010300972O0100020004F83O00972O0100120C010400013O000E56000100922O0100040004F83O00922O01002E1D005A006C2O01005B0004F83O006C2O012O009300056O0003000600013O00122O0007005C3O00122O0008005D6O0006000800024O00050005000600202O0005000500374O00050002000200062O0005006C2O013O0004F83O006C2O01002E5E005E00140001005E0004F83O006C2O012O0093000500024O000801065O00202O00060006005F4O000700033O00202O00070007000C4O00095O00202O00090009005F4O0007000900024O000700076O000800016O00050008000200062O0005006C2O013O0004F83O006C2O012O0093000500013O00120C010600603O00120C010700614O0043010500074O000C00056O009300056O0003000600013O00122O000700623O00122O000800636O0006000800024O00050005000600202O00050005000A4O00050002000200062O0005007D2O013O0004F83O007D2O012O0093000500073O0020BD0005000500644O00075O00202O0007000700654O00050007000200062O0005007F2O0100010004F83O007F2O01002E1D006600912O0100670004F83O00912O012O0093000500024O000801065O00202O00060006000B4O000700033O00202O00070007000C4O00095O00202O00090009000B4O0007000900024O000700076O000800016O00050008000200062O000500912O013O0004F83O00912O012O0093000500013O00120C010600683O00120C010700694O0043010500074O000C00055O00120C010400023O0026330104004A2O0100020004F83O004A2O0100120C010300053O0004F83O00972O010004F83O004A2O010026330103003F2O0100010004F83O003F2O012O009300046O0003000500013O00122O0006006A3O00122O0007006B6O0005000700024O00040004000500202O00040004000A4O00040002000200062O000400C52O013O0004F83O00C52O012O0093000400073O0020A00004000400644O00065O00202O00060006006C4O00040006000200062O000400C52O013O0004F83O00C52O012O0093000400093O0020EE00040004004C4O00055O00202O00050005006D4O0006000A6O000700013O00122O0008006E3O00122O0009006F6O0007000900024O0008000D6O000900094O0093000A00033O002039010A000A000C4O000C5O00202O000C000C006D4O000A000C00024O000A000A6O000B000D6O000E00016O0004000E000200062O000400C52O013O0004F83O00C52O012O0093000400013O00120C010500703O00120C010600714O0043010400064O000C00046O009300046O0003000500013O00122O000600723O00122O000700736O0005000700024O00040004000500202O0004000400374O00040002000200062O000400E62O013O0004F83O00E62O012O0093000400093O0020180004000400384O00055O00202O0005000500394O0006000A6O0007000E6O000800033O00202O00080008000C4O000A5O00202O000A000A00394O0008000A00024O000800086O0009000A6O000B00083O00202O000B000B003A4O0004000B000200062O000400E62O013O0004F83O00E62O012O0093000400013O00120C010500743O00120C010600754O0043010400064O000C00045O00120C010300023O0004F83O003F2O0100263301020009000100020004F83O0009000100120C010300013O0026330103003D020100020004F83O003D02012O009300046O0003000500013O00122O000600763O00122O000700776O0005000700024O00040004000500202O0004000400374O00040002000200062O0004001002013O0004F83O001002012O00930004000F3O00203B0004000400782O0009010400020002001211000500793O00064B00040010020100050004F83O001002012O0093000400103O00064A0004001002013O0004F83O001002012O0093000400024O0059000500083O00202O00050005007A4O0006000F3O00202O00060006001E00122O0008007B6O0006000800024O000600066O00040006000200062O0004001002013O0004F83O001002012O0093000400013O00120C0105007C3O00120C0106007D4O0043010400064O000C00046O009300046O0003000500013O00122O0006007E3O00122O0007007F6O0005000700024O00040004000500202O0004000400374O00040002000200062O0004003C02013O0004F83O003C02012O0093000400093O0020110104000400802O004C00040001000200064A0004003C02013O0004F83O003C02012O0093000400033O00203B00040004001E00120C0106007B4O00CE00040006000200064A0004003C02013O0004F83O003C02012O0093000400113O00064A0004003C02013O0004F83O003C02012O0093000400093O0020DC0004000400814O000500126O000600136O00040006000200062O0004003C02013O0004F83O003C02012O0093000400024O004C01055O00202O0005000500824O000600066O000700016O00040007000200062O0004003C02013O0004F83O003C02012O0093000400013O00120C010500833O00120C010600844O0043010400064O000C00045O00120C010300053O000E5600010092020100030004F83O009202012O009300046O0003000500013O00122O000600853O00122O000700866O0005000700024O00040004000500202O0004000400374O00040002000200062O0004005A02013O0004F83O005A02012O0093000400024O00C000055O00202O0005000500874O000600033O00202O00060006001E00122O0008001F6O0006000800024O000600066O000700016O00040007000200062O0004005A02013O0004F83O005A02012O0093000400013O00120C010500883O00120C010600894O0043010400064O000C00045O002E1D008A00910201008B0004F83O009102012O009300046O0003000500013O00122O0006008C3O00122O0007008D6O0005000700024O00040004000500202O0004000400374O00040002000200062O0004009102013O0004F83O009102012O009300046O0003000500013O00122O0006008E3O00122O0007008F6O0005000700024O00040004000500202O0004000400904O00040002000200062O0004009102013O0004F83O009102012O0093000400143O00064A0004009102013O0004F83O00910201002E1D00910091020100920004F83O009102012O0093000400093O0020A200040004004C4O00055O00202O0005000500394O0006000A6O000700013O00122O000800933O00122O000900946O0007000900024O000800156O000900096O000A00033O00202O000A000A000C4O000C5O00202O000C000C00394O000A000C00024O000A000A6O000B000C6O000D00083O00202O000D000D003A4O0004000D000200062O0004009102013O0004F83O009102012O0093000400013O00120C010500953O00120C010600964O0043010400064O000C00045O00120C010300023O002633010300EB2O0100050004F83O00EB2O0100120C010200053O0004F83O000900010004F83O00EB2O010004F83O000900010004F83O00A302010004F83O000600010004F83O00A302010026C33O009F020100010004F83O009F0201002E5E00970065FD2O00980004F83O0002000100120C2O0100014O0083000200023O00120C012O00023O0004F83O000200012O00613O00017O00693O00028O00026O000840030D3O00C1D81A3807F6DA0D3D35ECD60603053O004685B96853030A3O0049734361737461626C6503093O00497343617374696E67030D3O004461726B417363656E73696F6E030F3O00432O6F6C646F776E52656D61696E73026O001040030A3O00294C4A2ECB014B402FDB03053O00A96425244A030B3O004973417661696C61626C65030C3O00432O6F6C646F776E446F776E027O004003123O002989A7430386B251028BA7640F95AF550E9303043O003060E7C2025O002OB240025O00C06D4003153O00CC5B1C2O26D9BC80CD541D2416D6EF80CC494E7F4B03083O00E3A83A6E4D79B8CF025O00F4AA40025O00D3B140025O00607040025O002OA840025O00A0A240025O00E4AF40026O00F03F025O0022AE40025O00EEA040025O0056B140025O00289E40025O00608A40025O00C07140030A3O00D1B71C1279FDC6AA0B0903063O009895DE6A7B1703073O004973526561647903163O00FF23FA4CA7CF23FA4CA6C92EF370A0D325F74FB9D83403053O00D5BD469623030A3O004973457175692O70656403163O006D5078075D477104404660004A6661064C5478044A4703043O00682F3514025O005C9140025O0070934003103O00446976696E6553746172506C6179657203093O004973496E52616E6765026O003E4003123O00A7459715B20A9C5F951DAE4FA048925CED5903063O006FC32CE17CDC030C3O00EE4909778EB9CD56147AA4A503063O00CBB8266013CB030A3O00147A7745CC3C2O7D44DC03053O00AE5913192103123O00061C575DF4861B2E105E4BC3881922175C5A03073O006B4F72322E97E703093O0014AFBB2DA835B6D32D03083O00A059C6D549EA59D703073O0043686172676573030A3O00436F6D62617454696D65026O002E40025O0004AF40025O0032A240025O00949240025O009AA740030C3O00566F69644572757074696F6E03143O005E7EBD2OFA4D63A1EED1417EBABEC64C62F4AC9503053O00A52811D49E025O0048B040025O005EAC40025O00C8A640025O0076AF40025O00909840025O00D6AF4003093O0028A462E1098E01A27403063O00E26ECD10846B03063O0042752O66557003113O00506F776572496E667573696F6E42752O66026O00204003093O0046697265626C2O6F64030F3O00EDCAF2DC43E7CCEFDD01E8C7F3991503053O00218BA380B9030A3O00755D16CD524A0FD7595F03043O00BE373864026O002840025O00489C40026O00B340025O00E49740025O00A8B140030A3O004265727365726B696E6703103O0054AA2E0D16F1F85FA13B5E10E7E016F903073O009336CF5C7E7383025O00F09E40025O00049640025O0022A04003093O002F3D3A72095818232C03063O001E6D51551D6D03093O00426C2O6F644675727903103O00FD7D5BB932E1FAEA634DF635DAEFBF2903073O009C9F1134D656BE030D3O008FE1BEB9BDFBAFBDA2CCBCB0A203043O00DCCE8FDD030D3O00416E6365737472616C43612O6C025O00209A40025O00E8B14003153O0087732E12CBD8C087711214D9C0DEC67E2904989D8203073O00B2E61D4D77B8AC00A5012O00120C012O00014O0083000100013O002633012O0002000100010004F83O0002000100120C2O0100013O0026332O010064000100020004F83O006400012O009300026O0003000300013O00122O000400033O00122O000500046O0003000500024O00020002000300202O0002000200054O00020002000200062O0002004900013O0004F83O004900012O0093000200023O0020BD0002000200064O00045O00202O0004000400074O00020004000200062O00020049000100010004F83O004900012O0093000200033O00064A0002002000013O0004F83O002000012O0093000200043O00203B0002000200082O0009010200020002000EA80009003C000100020004F83O003C00012O009300026O0052000300013O00122O0004000A3O00122O0005000B6O0003000500024O00020002000300202O00020002000C4O00020002000200062O0002002F000100010004F83O002F00012O0093000200043O00203B00020002000D2O00090102000200020006890002003C000100010004F83O003C00012O0093000200053O000E9E000E0049000100020004F83O004900012O009300026O0052000300013O00122O0004000F3O00122O000500106O0003000500024O00020002000300202O00020002000C4O00020002000200062O00020049000100010004F83O004900012O0093000200064O009300035O0020110103000300072O000901020002000200068900020044000100010004F83O00440001002EC200110049000100120004F83O004900012O0093000200013O00120C010300133O00120C010400144O0043010200044O000C00025O002EC2001500A42O0100160004F83O00A42O012O0093000200073O00064A000200A42O013O0004F83O00A42O0100120C010200014O0083000300033O00263301020050000100010004F83O0050000100120C010300013O002EC200170053000100180004F83O0053000100263301030053000100010004F83O005300012O0093000400094O004C0004000100022O00B7000400084O0093000400083O00064A000400A42O013O0004F83O00A42O012O0093000400084O0073000400023O0004F83O00A42O010004F83O005300010004F83O00A42O010004F83O005000010004F83O00A42O01002E1D0019003O01001A0004F83O003O010026332O01003O01000E0004F83O003O0100120C010200013O0026C30002006D0001001B0004F83O006D0001002E1D001C006F0001001D0004F83O006F000100120C2O0100023O0004F83O003O010026C300020073000100010004F83O00730001002E5E001E00F8FF2O001F0004F83O0069000100120C010300013O0026C300030078000100010004F83O00780001002E1D002000F9000100210004F83O00F900012O009300046O0003000500013O00122O000600223O00122O000700236O0005000700024O00040004000500202O0004000400244O00040002000200062O000400AC00013O0004F83O00AC00012O0093000400053O000E9E001B00AC000100040004F83O00AC00012O00930004000A4O0003000500013O00122O000600253O00122O000700266O0005000700024O00040004000500202O0004000400274O00040002000200062O000400AC00013O0004F83O00AC00012O00930004000A4O0003010500013O00122O000600283O00122O000700296O0005000700024O00040004000500202O0004000400084O0004000200022O00930005000B3O0006C1000400AC000100050004F83O00AC0001002EC2002A00AC0001002B0004F83O00AC00012O0093000400064O00590005000C3O00202O00050005002C4O0006000D3O00202O00060006002D00122O0008002E6O0006000800024O000600066O00040006000200062O000400AC00013O0004F83O00AC00012O0093000400013O00120C0105002F3O00120C010600304O0043010400064O000C00046O009300046O0003000500013O00122O000600313O00122O000700326O0005000700024O00040004000500202O0004000400054O00040002000200062O000400E900013O0004F83O00E900012O0093000400043O00203B00040004000D2O000901040002000200064A000400E900013O0004F83O00E900012O0093000400033O00064A000400C300013O0004F83O00C300012O0093000400043O00203B0004000400082O0009010400020002000EA8000900DA000100040004F83O00DA00012O009300046O0003000500013O00122O000600333O00122O000700346O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400DA00013O0004F83O00DA00012O0093000400053O000E9E000E00E9000100040004F83O00E900012O009300046O0052000500013O00122O000600353O00122O000700366O0005000700024O00040004000500202O00040004000C4O00040002000200062O000400E9000100010004F83O00E900012O009300046O0003010500013O00122O000600373O00122O000700386O0005000700024O00040004000500202O0004000400394O0004000200020026C3000400EB000100010004F83O00EB00012O00930004000E3O00201101040004003A2O004C000400010002000ED9003B00EB000100040004F83O00EB0001002EC2003C00F80001003D0004F83O00F80001002E1D003E00F80001003F0004F83O00F800012O0093000400064O009300055O0020110105000500402O000901040002000200064A000400F800013O0004F83O00F800012O0093000400013O00120C010500413O00120C010600424O0043010400064O000C00045O00120C0103001B3O002E1D00440074000100430004F83O00740001002633010300740001001B0004F83O0074000100120C0102001B3O0004F83O006900010004F83O007400010004F83O00690001000E56000100542O0100010004F83O00542O0100120C010200013O002EC20045004D2O0100460004F83O004D2O01000E560001004D2O0100020004F83O004D2O01002EC2004700292O0100480004F83O00292O012O009300036O0003000400013O00122O000500493O00122O0006004A6O0004000600024O00030003000400202O0003000300054O00030002000200062O000300292O013O0004F83O00292O012O0093000300023O0020BD00030003004B4O00055O00202O00050005004C4O00030005000200062O0003001E2O0100010004F83O001E2O012O00930003000F3O0026BE000300292O01004D0004F83O00292O012O0093000300064O009300045O00201101040004004E2O000901030002000200064A000300292O013O0004F83O00292O012O0093000300013O00120C0104004F3O00120C010500504O0043010300054O000C00036O009300036O0003000400013O00122O000500513O00122O000600526O0004000600024O00030003000400202O0003000300054O00030002000200062O0003003D2O013O0004F83O003D2O012O0093000300023O0020BD00030003004B4O00055O00202O00050005004C4O00030005000200062O0003003F2O0100010004F83O003F2O012O00930003000F3O00260A0103003F2O0100530004F83O003F2O01002E1D0055004C2O0100540004F83O004C2O01002E1D0056004C2O0100570004F83O004C2O012O0093000300064O009300045O0020110104000400582O000901030002000200064A0003004C2O013O0004F83O004C2O012O0093000300013O00120C010400593O00120C0105005A4O0043010300054O000C00035O00120C0102001B3O000EF0001B00512O0100020004F83O00512O01002E5E005B00B5FF2O005C0004F83O00042O0100120C2O01001B3O0004F83O00542O010004F83O00042O010026332O0100050001001B0004F83O0005000100120C010200013O000E560001009C2O0100020004F83O009C2O01002E5E005D00210001005D0004F83O007A2O012O009300036O0003000400013O00122O0005005E3O00122O0006005F6O0004000600024O00030003000400202O0003000300054O00030002000200062O0003007A2O013O0004F83O007A2O012O0093000300023O0020BD00030003004B4O00055O00202O00050005004C4O00030005000200062O0003006F2O0100010004F83O006F2O012O00930003000F3O0026BE0003007A2O01003B0004F83O007A2O012O0093000300064O009300045O0020110104000400602O000901030002000200064A0003007A2O013O0004F83O007A2O012O0093000300013O00120C010400613O00120C010500624O0043010300054O000C00036O009300036O0003000400013O00122O000500633O00122O000600646O0004000600024O00030003000400202O0003000300054O00030002000200062O0003009B2O013O0004F83O009B2O012O0093000300023O0020BD00030003004B4O00055O00202O00050005004C4O00030005000200062O0003008E2O0100010004F83O008E2O012O00930003000F3O0026BE0003009B2O01003B0004F83O009B2O012O0093000300064O009300045O0020110104000400652O0009010300020002000689000300962O0100010004F83O00962O01002EC20067009B2O0100660004F83O009B2O012O0093000300013O00120C010400683O00120C010500694O0043010300054O000C00035O00120C0102001B3O002633010200572O01001B0004F83O00572O0100120C2O01000E3O0004F83O000500010004F83O00572O010004F83O000500010004F83O00A42O010004F83O000200012O00613O00017O00DE3O00028O00027O0040026O00F03F030A3O0049734361737461626C65026O003E4003093O0054696D65546F446965026O002E40030D3O005F3DAD4B90C872A0752FB64FBF03083O00C51B5CDF20D1BB11030B3O004973417661696C61626C65030D3O00275ED1F0224CC0FE0D4CCAF40D03043O009B633FA3030F3O00432O6F6C646F776E52656D61696E73025O00B49340025O007C904003113O008FD8AF89BB818CD5A49FF98983D8AFCDEB03063O00E4E2B1C1EDD9030F3O0010B535E921A22AE833802FE733A52603043O008654D04303073O004973526561647903093O00436173744379636C65030F3O004465766F7572696E67506C61677565030E3O0049735370652O6C496E52616E676503173O0017A9905306BE8F521493965012AB935953A187551DECD203043O003C73CCE6025O00788440025O00E07F40025O0030B040025O0012A240025O0050A340025O006AA940025O00509840025O00F0A840025O00A7B240025O00D09640025O00B07F40025O00ECAA40030F3O00E9815E0603FAED864D0628E8DB9D5703063O008DBAE93F626C030F3O00536861646F77576F7264446561746803183O00536861646F77576F726444656174684D6F7573656F766572025O0098A940025O001EA14003193O002OE22DB22AE6D53BB937F5D528B324E5E26CBB24F8E46CE77503053O0045918A4CD603083O0046C0808D9D197CDB03063O007610AF2OE9DF025O00E2AA40025O0080AA40025O00388D40025O00608D4003083O00566F6964426F6C7403093O004973496E52616E6765026O00444003113O009D8B3CBFD18972879075B6EF8273CBD56703073O001DEBE455DB8EEB025O00149740025O0092A340030F3O00D432EA74E82DDC7FF53ECF75E62EE303043O0010875A8B03073O0048617354696572026O003F40026O00104003123O007D7A03204D556855760A367A5B6A5971082703073O0018341466532E3403083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O66025O0002B040025O00B6A040025O0080584003183O00D7272O2000D310362B1DC01025210ED02761290ECD21617203053O006FA44F414403093O00EBD08DDA0CE6C7CA9703063O008AA6B9E3BE4E03123O00E27AC024512209CA76C932662C0BC671CB2303073O0079AB14A557324303093O00EB31B7329B0EC72BAD03063O0062A658D956D9030B3O004578656375746554696D65026O001C40025O004AA040025O0032A340025O00807D40025O005EA04003093O004D696E64426C61737403123O004D696E64426C6173744D6F7573656F76657203113O00FBFF7705B9DEFAF76A15C6D1F7FF7741DE03063O00BC2O961961E6025O0034A940025O00BCAB40030B3O00B258F75EB058EC488159EA03043O003AE4379E030B3O00566F6964546F2O72656E7403143O00566F6964546F2O72656E744D6F7573656F766572025O00207840025O00888C4003143O00A286D92A03B93AA69BD52028ED38B580DE2O6EF503073O0055D4E9B04E5CCD026O000840025O00BBB240025O003C9140030F3O003AA53C7706BA0A7C1BA9197608B93503043O001369CD5D03093O0042752O66537461636B03113O00446561746873546F726D656E7442752O66026O002240030B3O009A00DF8530BE2BCC802CA103053O005FC968BEE1025O0014B340025O0040B240025O00B9B140025O006AA74003193O00BCC3C0CAA0DCFED9A0D9C5F1ABCEC0DAA78BCCCFA6C5819CFD03043O00AECFABA1030F3O00DEF60C2OF7C0DAF11FF7DCD2ECEA0503063O00B78D9E6D939803123O000507E31F2F08F60D2E05E338231BEB09221D03043O006C4C6986030C3O00C2CBA2E8CAE2CAA4F2E7F9C003053O00AE8BA5D181030F3O008AB7EDCDE9054977A4B4D1C0D40C7E03083O0018C3D382A1A6631003063O0042752O66557003103O004465617468737065616B657242752O66025O00608A40025O00E6B14003193O00550BE8285C017914E63E57294206E8385B564B02E02213441203063O00762663894C33025O00C2B240025O0095B240025O00A2B140030D3O00CB2708020032F425311D1C23F503063O00409D46657269025O005EB140025O006CB140030C3O00436173745461726765744966030D3O0056616D7069726963546F7563682O033O004DA1A903053O007020C8C78303163O003A2O51A8CAB92B2F6F48B7D6A82A6C2O5DB1CDEB707A03073O00424C303CD8A3CB025O0058824003093O00978F77F77DC225A99203073O0044DAE619933FAE03083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O009B255A4893BF3F4358BFA22403053O00D6CD4A332C030A3O00432O6F6C646F776E5570030C3O00CC43EBF852E859F2E87EF54203053O00179A2C829C025O00507D40025O00C06C4003123O001CAFA3AA09111DA7BEBA761E10AFA3EE644503063O007371C6CDCE56025O00C2A340025O00FAA840025O00405140025O0022A640025O00F0A140025O007CB140030F3O0019D1ACD2625C2E5C3AE4B6DC705B2203083O00325DB4DABD172E4703153O00FAA14D4351CE41D0A36B4045DB5DDB805E4E51DA4E03073O0028BEC43B2C24BC030C3O00426173654475726174696F6E03183O003840CABBEF6F043242E3A4F67C0A29409CB9FB74037C148803073O006D5C25BCD49A1D030F3O0020EAB2CC24480DE1A3F33D5B03FAA103063O003A648FC4A351030F3O00496E73616E69747944656669636974026O003440030C3O00566F6964666F726D42752O6603083O002C4D2AA71D46E91A03083O006E7A2243C35F2985030B3O0042752O6652656D61696E7303083O0043BE524EF47ABD4F03053O00B615D13B2A030B3O00504D756C7469706C69657202345O33F33F025O005AAF40025O0040AA4003183O004465766F7572696E67506C616775654D6F7573656F766572025O00809540025O0010B24003183O00B352D31234ACBE59C22231B2B650D01861B3B65ECB5D70E803063O00DED737A57D41030F3O001FD9C71EFDD6DA453ED5E21FF3D5E503083O002A4CB1A67A92A18D025O00F07340025O00889A4003193O00B68204CA76619A9D0ADC7D49A18F04DA7136A88B0CC03927FD03063O0016C5EA65AE19030B3O001E3CA4D879B8F4942C27AD03083O00E64D54C5BC16CFB703113O00446562752O665265667265736861626C6503133O0056616D7069726963546F756368446562752O6603073O00DA1BC8FA85B3FD03083O00559974A69CECC190030B3O00536861646F774372617368025O0036B240025O0087B34003143O00B7E84CB7EB179BE35FB2F708E4ED4CBAEA40F6B003063O0060C4802DD38403123O0010837E52CBEF81D63188691FF1BAA6CB3A9F03083O00B855ED1B3FB2CFD403063O0045786973747303093O0043616E412O7461636B025O006AAE40025O0054A840025O0031B240025O0078904003113O00536861646F774372617368437572736F7203143O001B51085B074E365C1A581A574854085606195B0F03043O003F68396903093O002A93E4671E95B74B1903043O00246BE7C4025O00808640025O00E8A040025O00E8824003143O004EBDA38352A29D844FB4B18F1DB8A38E53F5F0D703043O00E73DD5C200E5032O00120C012O00013O000E560001008F00013O0004F83O008F000100120C2O0100013O0026332O010008000100020004F83O0008000100120C012O00033O0004F83O008F00010026332O01005D000100030004F83O005D00012O009300025O00203B0002000200042O000901020002000200064A0002003E00013O0004F83O003E00012O0093000200013O00064A0002003E00013O0004F83O003E00012O0093000200023O0026510002001A000100050004F83O001A00012O0093000200033O00203B0002000200062O0009010200020002000E9E0007003E000100020004F83O003E00012O0093000200044O0003000300053O00122O000400083O00122O000500096O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002003200013O0004F83O003200012O0093000200044O0003010300053O00122O0004000B3O00122O0005000C6O0003000500024O00020002000300202O00020002000D4O0002000200022O0093000300063O00065001020032000100030004F83O003200012O0093000200023O0026A90002003E000100070004F83O003E00012O0093000200074O009300036O000901020002000200068900020039000100010004F83O00390001002E1D000E003E0001000F0004F83O003E00012O0093000200053O00120C010300103O00120C010400114O0043010200044O000C00026O0093000200044O0003000300053O00122O000400123O00122O000500136O0003000500024O00020002000300202O0002000200144O00020002000200062O0002005C00013O0004F83O005C00012O0093000200083O0020760002000200154O000300043O00202O0003000300164O000400096O0005000A6O000600033O00202O0006000600174O000800043O00202O0008000800164O0006000800022O004F010600064O00CE00020006000200064A0002005C00013O0004F83O005C00012O0093000200053O00120C010300183O00120C010400194O0043010200044O000C00025O00120C2O0100023O0026332O010004000100010004F83O000400012O00930002000B4O003E0002000100012O00930002000C3O00064A0002007200013O0004F83O007200012O0093000200023O00265100020074000100050004F83O007400012O0093000200033O00203B0002000200062O0009010200020002000E9E00070072000100020004F83O007200012O00930002000D3O00064A0002007400013O0004F83O007400012O00930002000E3O000ED900020074000100020004F83O00740001002EC2001A008D0001001B0004F83O008D000100120C010200014O0083000300033O002EC2001D00760001001C0004F83O00760001000E5600010076000100020004F83O0076000100120C010300013O002EC2001E007B0001001F0004F83O007B00010026330103007B000100010004F83O007B00012O0093000400104O004C0004000100022O00B70004000F3O002E1D0020008D000100210004F83O008D00012O00930004000F3O00064A0004008D00013O0004F83O008D00012O00930004000F4O0073000400023O0004F83O008D00010004F83O007B00010004F83O008D00010004F83O0076000100120C2O0100033O0004F83O000400010026C33O0093000100030004F83O00930001002E1D002200692O0100230004F83O00692O0100120C2O0100013O0026332O010098000100020004F83O0098000100120C012O00023O0004F83O00692O010026C30001009C000100030004F83O009C0001002EC2002500E1000100240004F83O00E100012O0093000200044O0003000300053O00122O000400263O00122O000500276O0003000500024O00020002000300202O0002000200144O00020002000200062O000200BF00013O0004F83O00BF00012O0093000200083O0020760002000200154O000300043O00202O0003000300284O000400096O000500116O000600033O00202O0006000600174O000800043O00202O0008000800284O0006000800022O004F010600064O00F7000700086O000900123O00202O0009000900294O00020009000200062O000200BA000100010004F83O00BA0001002E1D002A00BF0001002B0004F83O00BF00012O0093000200053O00120C0103002C3O00120C0104002D4O0043010200044O000C00026O0093000200044O0003000300053O00122O0004002E3O00122O0005002F6O0003000500024O00020002000300202O0002000200044O00020002000200062O000200CC00013O0004F83O00CC00012O0093000200013O000689000200CE000100010004F83O00CE0001002EC2003000E0000100310004F83O00E00001002E1D003200E0000100330004F83O00E000012O0093000200074O0059000300043O00202O0003000300344O000400033O00202O00040004003500122O000600366O0004000600024O000400046O00020004000200062O000200E000013O0004F83O00E000012O0093000200053O00120C010300373O00120C010400384O0043010200044O000C00025O00120C2O0100023O002E1D003900940001003A0004F83O009400010026332O010094000100010004F83O009400012O0093000200044O0003000300053O00122O0004003B3O00122O0005003C6O0003000500024O00020002000300202O0002000200144O00020002000200062O000200112O013O0004F83O00112O012O0093000200133O0020C700020002003D00122O0004003E3O00122O0005003F6O00020005000200062O0002000A2O0100010004F83O000A2O012O0093000200143O00064A000200112O013O0004F83O00112O012O0093000200044O0003000300053O00122O000400403O00122O000500416O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200112O013O0004F83O00112O012O0093000200133O00203E01020002003D00122O0004003E3O00122O000500026O00020005000200062O000200112O013O0004F83O00112O012O0093000200033O0020BD0002000200424O000400043O00202O0004000400434O00020004000200062O000200132O0100010004F83O00132O01002E1D004400262O0100450004F83O00262O01002E5E00460013000100460004F83O00262O012O0093000200074O0055010300043O00202O0003000300284O000400033O00202O0004000400174O000600043O00202O0006000600284O0004000600024O000400046O00020004000200062O000200262O013O0004F83O00262O012O0093000200053O00120C010300473O00120C010400484O0043010200044O000C00026O0093000200044O0003000300053O00122O000400493O00122O0005004A6O0003000500024O00020002000300202O0002000200044O00020002000200062O0002004B2O013O0004F83O004B2O012O0093000200143O00064A0002004B2O013O0004F83O004B2O012O0093000200044O0003000300053O00122O0004004B3O00122O0005004C6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002004B2O013O0004F83O004B2O012O0093000200154O001A010300046O000400053O00122O0005004D3O00122O0006004E6O0004000600024O00030003000400202O00030003004F4O00030002000200062O0003004B2O0100020004F83O004B2O012O00930002000E3O00260A0102004D2O0100500004F83O004D2O01002E5E0051001C000100520004F83O00672O01002E1D005300672O0100540004F83O00672O012O0093000200083O0020070002000200154O000300043O00202O0003000300554O000400096O000500166O000600033O00202O0006000600174O000800043O00202O0008000800554O0006000800024O000600066O000700086O000900123O00202O0009000900564O000A00016O0002000A000200062O000200672O013O0004F83O00672O012O0093000200053O00120C010300573O00120C010400584O0043010200044O000C00025O00120C2O0100033O0004F83O00940001000E56003F009D2O013O0004F83O009D2O01002E1D005900942O01005A0004F83O00942O012O0093000100044O0003000200053O00122O0003005B3O00122O0004005C6O0002000400024O00010001000200202O0001000100044O00010002000200062O000100942O013O0004F83O00942O012O00930001000D3O000689000100942O0100010004F83O00942O012O0093000100083O0020E50001000100154O000200043O00202O00020002005D4O000300096O000400176O000500033O00202O0005000500174O000700043O00202O00070007005D4O0005000700024O000500056O000600076O000800123O00202O00080008005E4O000900016O00010009000200062O0001008F2O0100010004F83O008F2O01002E1D006000942O01005F0004F83O00942O012O0093000100053O00120C010200613O00120C010300624O00432O0100034O000C00016O0093000100184O004C0001000100022O00B70001000F4O00930001000F3O00064A000100E403013O0004F83O00E403012O00930001000F4O0073000100023O0004F83O00E403010026C33O00A12O0100630004F83O00A12O01002E1D0064009C020100650004F83O009C020100120C2O0100013O0026332O01002E020100010004F83O002E02012O0093000200044O0003000300053O00122O000400663O00122O000500676O0003000500024O00020002000300202O0002000200144O00020002000200062O000200C92O013O0004F83O00C92O012O0093000200133O0020220102000200684O000400043O00202O0004000400694O000200040002000E2O006A00C92O0100020004F83O00C92O012O0093000200133O00203E01020002003D00122O0004003E3O00122O0005003F6O00020005000200062O000200C92O013O0004F83O00C92O012O00930002000D3O00064A000200CB2O013O0004F83O00CB2O012O0093000200044O0003000300053O00122O0004006B3O00122O0005006C6O0003000500024O00020002000300202O00020002000A4O00020002000200062O000200CB2O013O0004F83O00CB2O01002EC2006D00DE2O01006E0004F83O00DE2O01002EC2007000DE2O01006F0004F83O00DE2O012O0093000200074O0055010300043O00202O0003000300284O000400033O00202O0004000400174O000600043O00202O0006000600284O0004000600024O000400046O00020004000200062O000200DE2O013O0004F83O00DE2O012O0093000200053O00120C010300713O00120C010400724O0043010200044O000C00026O0093000200044O0003000300053O00122O000400733O00122O000500746O0003000500024O00020002000300202O0002000200144O00020002000200062O0002002D02013O0004F83O002D02012O0093000200013O00064A0002002D02013O0004F83O002D02012O0093000200044O0003000300053O00122O000400753O00122O000500766O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002002D02013O0004F83O002D02012O0093000200143O00064A0002002D02013O0004F83O002D02012O0093000200044O0052000300053O00122O000400773O00122O000500786O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002000C020100010004F83O000C02012O0093000200044O0003000300053O00122O000400793O00122O0005007A6O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002001302013O0004F83O001302012O0093000200133O0020A000020002007B4O000400043O00202O00040004007C4O00020004000200062O0002002D02013O0004F83O002D02012O0093000200133O0020C700020002003D00122O0004003E3O00122O000500026O00020005000200062O0002002D020100010004F83O002D02012O0093000200074O0057000300043O00202O0003000300284O000400033O00202O0004000400174O000600043O00202O0006000600284O0004000600024O000400046O00020004000200062O00020028020100010004F83O00280201002EC2007E002D0201007D0004F83O002D02012O0093000200053O00120C0103007F3O00120C010400804O0043010200044O000C00025O00120C2O0100033O002E5E00810067000100810004F83O00950201000E5600030095020100010004F83O00950201002EC200830059020100820004F83O005902012O0093000200044O0003000300053O00122O000400843O00122O000500856O0003000500024O00020002000300202O0002000200044O00020002000200062O0002005902013O0004F83O00590201002EC200860059020100870004F83O005902012O0093000200083O00205A0002000200884O000300043O00202O0003000300894O000400096O000500053O00122O0006008A3O00122O0007008B6O0005000700024O000600196O0007001A6O000800033O00202O0008000800174O000A00043O00202O000A000A00894O0008000A00024O000800086O00020008000200062O0002005902013O0004F83O005902012O0093000200053O00120C0103008C3O00120C0104008D4O0043010200044O000C00025O002EC2008E00940201007D0004F83O009402012O0093000200044O0003000300053O00122O0004008F3O00122O000500906O0003000500024O00020002000300202O0002000200044O00020002000200062O0002009402013O0004F83O009402012O0093000200133O0020BD0002000200914O000400043O00202O0004000400924O00020004000200062O00020080020100010004F83O008002012O0093000200044O0003000300053O00122O000400933O00122O000500946O0003000500024O00020002000300202O0002000200954O00020002000200062O0002009402013O0004F83O009402012O0093000200044O0003000300053O00122O000400963O00122O000500976O0003000500024O00020002000300202O00020002000A4O00020002000200062O0002009402013O0004F83O00940201002EC200990094020100980004F83O009402012O0093000200074O0008010300043O00202O0003000300554O000400033O00202O0004000400174O000600043O00202O0006000600554O0004000600024O000400046O000500016O00020005000200062O0002009402013O0004F83O009402012O0093000200053O00120C0103009A3O00120C0104009B4O0043010200044O000C00025O00120C2O0100023O002E1D009C00A22O01009D0004F83O00A22O010026332O0100A22O0100020004F83O00A22O0100120C012O003F3O0004F83O009C02010004F83O00A22O010026C33O00A0020100020004F83O00A00201002EC2009F00010001009E0004F83O00010001002E1D00A000D7020100A10004F83O00D702012O0093000100044O0003000200053O00122O000300A23O00122O000400A36O0002000400024O00010001000200202O0001000100144O00010002000200062O000100D702013O0004F83O00D702012O0093000100024O004F0002001B6O000300046O000400053O00122O000500A43O00122O000600A56O0004000600024O00030003000400202O0003000300A64O00030002000200122O0004003F6O0002000400024O0003001C6O000400046O000500053O00122O000600A43O00122O000700A56O0005000700024O00040004000500202O0004000400A64O00040002000200122O0005003F6O0003000500024O00020002000300062O000100D7020100020004F83O00D702012O0093000100074O0055010200043O00202O0002000200164O000300033O00202O0003000300174O000500043O00202O0005000500164O0003000500024O000300036O00010003000200062O000100D702013O0004F83O00D702012O0093000100053O00120C010200A73O00120C010300A84O00432O0100034O000C00016O0093000100044O0003000200053O00122O000300A93O00122O000400AA6O0002000400024O00010001000200202O0001000100144O00010002000200062O0001002503013O0004F83O002503012O0093000100133O00203B0001000100AB2O00092O010002000200260A2O010027030100AC0004F83O002703012O0093000100133O0020A000010001007B4O000300043O00202O0003000300AD4O00010003000200062O0001001703013O0004F83O001703012O0093000100044O0003010200053O00122O000300AE3O00122O000400AF6O0002000400024O00010001000200202O00010001000D4O0001000200022O0005000200133O00202O0002000200B04O000400043O00202O0004000400AD4O00020004000200062O00020017030100010004F83O001703012O0093000100044O0003010200053O00122O000300B13O00122O000400B26O0002000400024O00010001000200202O00010001000D4O0001000200022O00300002001B6O000300133O00202O0003000300B04O000500043O00202O0005000500AD4O00030005000200122O000400026O0002000400024O0003001C6O000400133O00203B0004000400B02O002O010600043O00202O0006000600AD4O00040006000200122O000500026O0003000500024O00020002000300062O00010011000100020004F83O002703012O0093000100133O0020A000010001007B4O000300043O00202O0003000300924O00010003000200062O0001002503013O0004F83O002503012O0093000100133O00203C2O01000100B34O000300043O00202O0003000300164O00010003000200262O00010027030100B40004F83O00270301002E1D00B50040030100B60004F83O004003012O0093000100083O0020760001000100154O000200043O00202O0002000200164O000300096O0004000A6O000500033O00202O0005000500174O000700043O00202O0007000700164O0005000700022O004F010500054O00F7000600076O000800123O00202O0008000800B74O00010008000200062O0001003B030100010004F83O003B0301002EC200B90040030100B80004F83O004003012O0093000100053O00120C010200BA3O00120C010300BB4O00432O0100034O000C00016O0093000100044O0003000200053O00122O000300BC3O00122O000400BD6O0002000400024O00010001000200202O0001000100144O00010002000200062O0001006403013O0004F83O006403012O0093000100133O00203E2O010001003D00122O0003003E3O00122O000400026O00010004000200062O0001006403013O0004F83O00640301002EC200BE0064030100BF0004F83O006403012O0093000100074O0055010200043O00202O0002000200284O000300033O00202O0003000300174O000500043O00202O0005000500284O0003000500024O000300036O00010003000200062O0001006403013O0004F83O006403012O0093000100053O00120C010200C03O00120C010300C14O00432O0100034O000C00016O0093000100044O0003000200053O00122O000300C23O00122O000400C36O0002000400024O00010001000200202O0001000100044O00010002000200062O000100E203013O0004F83O00E203012O00930001000D3O000689000100E2030100010004F83O00E203012O0093000100033O0020BD0001000100C44O000300043O00202O0003000300C54O00010003000200062O00010086030100010004F83O008603012O0093000100133O0020222O01000100684O000300043O00202O0003000300694O000100030002000E2O006A00E2030100010004F83O00E203012O0093000100133O00203E2O010001003D00122O0003003E3O00122O0004003F6O00010004000200062O000100E203013O0004F83O00E203012O00930001001D4O0077000200053O00122O000300C63O00122O000400C76O00020004000200062O000100A0030100020004F83O00A003012O0093000100074O0032000200043O00202O0002000200C84O000300033O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O0001009A030100010004F83O009A0301002E1D00CA00E2030100C90004F83O00E203012O0093000100053O001218010200CB3O00122O000300CC6O000100036O00015O00044O00E203012O00930001001D4O0077000200053O00122O000300CD3O00122O000400CE6O00020004000200062O000100C7030100020004F83O00C703012O00930001001E3O00203B0001000100CF2O00092O010002000200064A000100B203013O0004F83O00B203012O0093000100133O00203B0001000100D02O00930003001E4O00CE000100030002000689000100B4030100010004F83O00B40301002EC200D100E2030100D20004F83O00E20301002EC200D400E2030100D30004F83O00E203012O0093000100074O0059000200123O00202O0002000200D54O000300033O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O000100E203013O0004F83O00E203012O0093000100053O001218010200D63O00122O000300D76O000100036O00015O00044O00E203012O00930001001D4O0062000200053O00122O000300D83O00122O000400D96O00020004000200062O000100D0030100020004F83O00D00301002EC200DB00E2030100DA0004F83O00E20301002E1D00DC00E2030100440004F83O00E203012O0093000100074O0059000200123O00202O0002000200D54O000300033O00202O00030003003500122O000500366O0003000500024O000300036O00010003000200062O000100E203013O0004F83O00E203012O0093000100053O00120C010200DD3O00120C010300DE4O00432O0100034O000C00015O00120C012O00633O0004F83O000100012O00613O00017O003E3O00028O00025O00107540025O001C9C40026O00F03F030F3O0018D8D51C202ED4CD140530DCC4063003053O00555CBDA37303073O0049735265616479030D3O00446562752O6652656D61696E7303153O004465766F7572696E67506C61677565446562752O66026O001040030B3O001FA3393C1DA3222A2CA22403043O005849CC50030F3O00432O6F6C646F776E52656D61696E732O033O00474344027O0040030F3O004465766F7572696E67506C61677565030E3O0049735370652O6C496E52616E6765031D3O002A8606493CC8278D177939D62F84054369CA22BC04493BC82B8D04067F03063O00BA4EE370264903093O00D15EF3517176FD44E903063O001A9C379D3533030A3O0049734361737461626C6503073O005072657647434403093O004D696E64426C617374025O00A49040025O0008A24003173O0081D118DD875280D905CDF84080E702D6AA4289D60299E003063O0030ECB876B9D8025O004C9540025O002BB040030B3O00D3B25E34FB3BF7AF523EDB03063O005485DD3750AF03063O0042752O665570030C3O00566F6964666F726D42752O66025O00FAA040025O00A88F40030B3O00566F6964546F2O72656E74025O00DAB040025O00408040031A3O00ABE82DA2F848B2F536A3C948FDF72899D353AFF521A8D31CECB703063O003CDD8744C6A7025O00049A40025O0060AF40025O00089140025O0044A940025O00B4A04003083O007C5781E6685784F603043O00822A38E803083O00566F6964426F6C7403093O004973496E52616E6765026O00444003163O00FCBA2DE77F3DE5B930A35033D5A12BF1523AE4A164B103063O005F8AD5448320030D3O001C29AC537F3821A277793F2BA903053O00164A48C12303133O0056616D7069726963546F756368446562752O66026O001840030B3O001A76ED5C1876F64A2977F003043O00384C1984030D3O0056616D7069726963546F756368031B3O0048C0A636C64CC8A819DB51D4A82E8F4ECD9432C04CD3AE28DB1E9503053O00AF3EA1CB460002012O00120C012O00014O0083000100013O002E1D00020002000100030004F83O00020001002633012O0002000100010004F83O0002000100120C2O0100013O000E5600040068000100010004F83O0068000100120C010200013O00263301020063000100010004F83O006300012O009300036O0003000400013O00122O000500053O00122O000600066O0004000600024O00030003000400202O0003000300074O00030002000200062O0003003C00013O0004F83O003C00012O0093000300023O0020910003000300084O00055O00202O0005000500094O00030005000200262O0003003C0001000A0004F83O003C00012O009300036O0003010400013O00122O0005000B3O00122O0006000C6O0004000600024O00030003000400202O00030003000D4O0003000200022O0025000400033O00202O00040004000E4O00040002000200202O00040004000F00062O0003003C000100040004F83O003C00012O0093000300044O005501045O00202O0004000400104O000500023O00202O0005000500114O00075O00202O0007000700104O0005000700024O000500056O00030005000200062O0003003C00013O0004F83O003C00012O0093000300013O00120C010400123O00120C010500134O0043010300054O000C00036O009300036O0003000400013O00122O000500143O00122O000600156O0004000600024O00030003000400202O0003000300164O00030002000200062O0003006200013O0004F83O006200012O0093000300033O00201B00030003001700122O000500046O00065O00202O0006000600184O00030006000200062O00030062000100010004F83O00620001002E1D001900620001001A0004F83O006200012O0093000300044O000801045O00202O0004000400184O000500023O00202O0005000500114O00075O00202O0007000700184O0005000700024O000500056O000600016O00030006000200062O0003006200013O0004F83O006200012O0093000300013O00120C0104001B3O00120C0105001C4O0043010300054O000C00035O00120C010200043O0026330102000A000100040004F83O000A000100120C2O01000F3O0004F83O006800010004F83O000A0001002E1D001D009A0001001E0004F83O009A00010026332O01009A0001000F0004F83O009A00012O009300026O0003000300013O00122O0004001F3O00122O000500206O0003000500024O00020002000300202O0002000200164O00020002000200062O0002008300013O0004F83O008300012O0093000200054O0093000300024O002200046O00CE00020004000200068900020085000100010004F83O008500012O0093000200033O0020BD0002000200214O00045O00202O0004000400224O00020004000200062O00020085000100010004F83O00850001002E1D0023003O0100240004F83O003O012O0093000200044O008D00035O00202O0003000300254O000400023O00202O0004000400114O00065O00202O0006000600254O0004000600024O000400046O000500016O00020005000200062O00020094000100010004F83O00940001002EC20026003O0100270004F83O003O012O0093000200013O001218010300283O00122O000400296O000200046O00025O00044O003O010026332O010007000100010004F83O0007000100120C010200013O002EC2002A00F90001002B0004F83O00F90001002633010200F9000100010004F83O00F9000100120C010300013O000EF0000100A6000100030004F83O00A60001002E1D002D00F40001002C0004F83O00F40001002E5E002E001C0001002E0004F83O00C200012O009300046O0003000500013O00122O0006002F3O00122O000700306O0005000700024O00040004000500202O0004000400164O00040002000200062O000400C200013O0004F83O00C200012O0093000400044O005900055O00202O0005000500314O000600023O00202O00060006003200122O000800336O0006000800024O000600066O00040006000200062O000400C200013O0004F83O00C200012O0093000400013O00120C010500343O00120C010600354O0043010400064O000C00046O009300046O0003000500013O00122O000600363O00122O000700376O0005000700024O00040004000500202O0004000400164O00040002000200062O000400F300013O0004F83O00F300012O0093000400023O0020910004000400084O00065O00202O0006000600384O00040006000200262O000400F3000100390004F83O00F300012O009300046O0003010500013O00122O0006003A3O00122O0007003B6O0005000700024O00040004000500202O00040004000D4O0004000200022O0025000500033O00202O00050005000E4O00050002000200202O00050005000F00062O000400F3000100050004F83O00F300012O0093000400044O000801055O00202O00050005003C4O000600023O00202O0006000600114O00085O00202O00080008003C4O0006000800024O000600066O000700016O00040007000200062O000400F300013O0004F83O00F300012O0093000400013O00120C0105003D3O00120C0106003E4O0043010400064O000C00045O00120C010300043O002633010300A2000100040004F83O00A2000100120C010200043O0004F83O00F900010004F83O00A200010026330102009D000100040004F83O009D000100120C2O0100043O0004F83O000700010004F83O009D00010004F83O000700010004F83O003O010004F83O000200012O00613O00017O00ED3O00028O00026O000840030A3O0049734361737461626C6503063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603093O001FEA86396B5633F09C03063O003A5283E85D2903103O0046752O6C526563686172676554696D652O033O00474344030B3O00AA53DF197239A043D8005303063O005FE337B0753D030B3O004973417661696C61626C65030B3O002E712A4F9F176C314EA50C03053O00CB781E432B030C3O00432O6F6C646F776E446F776E030B3O00C72A44EBEDFE375FEAD7E503053O00B991452D8F025O0026A140025O00A2A340030E3O0049735370652O6C496E52616E676503103O00871617A2E38C1318BF9C8B101CE68ED803053O00BCEA7F79C6025O00A6A740025O00BAB04003093O00153B1D871A3E12902C03043O00E358527303083O0042752O66446F776E03103O004D696E644465766F7572657242752O66030C3O007510B3A32761560F2OAE0D7D03063O0013237FDAC762030A3O00432O6F6C646F776E5570030C3O002AF403E639E91FF208F205EC03043O00827C9B6A03093O004D696E64426C617374025O0006AA40025O00509D4003113O00D8C2F8AB9CF470BEC6DFB6AEACF33CED8103083O00DFB5AB96CFC3961C030B3O007A35EAAA3D4328F1AB075803053O00692C5A83CE030B3O00CFF3ABBA0037FCCCBBB72O03063O005E9F80D2D968030B3O0066F60FBB6B70EB6855F71203083O001A309966DF3F1F99030F3O00432O6F6C646F776E52656D61696E7303133O003441E0E30B52E4F0364FF8F00A64E8F11746EB03043O009362208D030F3O0041757261416374697665436F756E74026O00F83F03083O00496E73616E697479026O00494003083O00446562752O66557003153O004465766F7572696E67506C61677565446562752O6603103O004461726B526576657269657342752O66030C3O00566F6964666F726D42752O6603113O004461726B417363656E73696F6E42752O66025O00BCA740025O00D4A940030B3O002E4CEACE322O590A46EDDE03073O002B782383AA6636030B3O0064159EB5ADB987780F89BD03073O00E43466E7D6C5D003093O00436173744379636C65030B3O00566F6964546F2O72656E7403143O00566F6964546F2O72656E744D6F7573656F766572025O00C09440025O0018824003133O0008EF7CCED59F16C40CE57BDEAA8A16D35EB22303083O00B67E8015AA8AEB79026O001040025O00406E40025O00249C40025O003CA540025O0088B240030B3O00A2DE3AEAA915131283CF3B03083O0066EBBA5586E6735003103O005A05305B4DD22E56157E5E7DD162055403073O0042376C5E3F12B4025O00088240025O005EA340030D3O00D8BCF5934BCBE7BECC8C57DAE603063O00B98EDD98E322030B3O006BCD56FE4C24D44AC444F203073O009738A5379A235303083O00496E466C6967687403113O00974B0CFDB04617E7AE4436E6A1470AF9B303043O008EC02365030D3O0056616D7069726963546F75636803163O0056616D7069726963546F7563684D6F7573656F76657203143O00C07424B3EE9EA515E96126B6E484EC17D97069F103083O0076B61549C387ECCC030B3O003B341B440B1ADE1A3D094803073O009D685C7A20646D025O00689F40025O0082AD4003073O0080A9C1CC34358003083O00CBC3C6AFAA5D47ED025O0068A440025O00488A40030B3O00536861646F77437261736803093O004973496E52616E6765026O00444003123O003D433FD15E06C32D593FC65951FD214E7E8103073O009C4E2B5EB5317103123O0057E6C1AE12034C7CECC1B14B606C60FBCBB103073O00191288A4C36B23025O000CA140025O00E0994003063O0045786973747303093O0043616E412O7461636B025O00588540025O00B0A04003113O00536861646F774372617368437572736F72025O001CB240025O0072A44003123O00FB25A84B7DABFEBBFA2CBA4732BDCEBDA87903083O00D8884DC92F12DCA103093O000CF86BF91DCE9122FE03073O00E24D8C4BBA68BC025O007FB240026O003840025O00F88440025O00A8A34003123O00AAC6D13B40AEF1D32D4EAAC6903E40BC8E8403053O002FD9AEB05F025O00F88340026O003E4003093O0054696D65546F446965026O002E40027O0040025O0069B340025O008AA440025O00C08040025O00BEB040026O00F03F025O008AAB40026O007040025O00DEA540030F3O00770E627C2F41027A740A5F0A73663F03053O005A336B141303073O0049735265616479030F3O00496E73616E69747944656669636974026O00344003083O00BBFF8CEB1F82FC9103053O005DED90E58F030B3O0042752O6652656D61696E7303083O00232OF91D294919E203063O0026759690796B030F3O004465766F7572696E67506C6167756503183O004465766F7572696E67506C616775654D6F7573656F76657203173O0029BEF83538A9E7342A84FE362CBCFB3F6DBAE13F6DEABA03043O005A4DDB8E030D3O00D0052C29451573E5302E2C4F0F03073O001A866441592C67030B3O00C2EB3127ABE6C02O22B7F903053O00C49183504303113O0029B80F1B08ED0CB9080F2BE01FB4091F0B03063O00887ED0666878025O00588240025O0096AB4003153O006E8BC353A6403452479EC156AC5A7D50778F8E12F903083O003118EAAE23CF325D030F3O003FFAFC8C7E1BC5F29A7528F7FC9C7903053O00116C929DE803123O0062CD11FE2CA95BC216E12A9C44D119E821BC03063O00C82BA3748D4F030C3O0096382E8AB4FDECAA251491B503073O0083DF565DE3D094030F3O00CA41B9BA32B3DA4A2OB12EB4F14AB803063O00D583252OD67D03103O004465617468737065616B657242752O66025O00F88040025O00F0B240030F3O00536861646F77576F7264446561746803183O00352324BBEE311432B0F3221421BAE0322365BEEE236B74E703053O0081464B45DF026O006540025O00BCA34003113O006BC2FDED4FFF4FC0F6C072FC47C5FAFD6503063O008F26AB93891C03093O00FD8BB7F721EFD5C39603073O00B4B0E2D9936383030B3O00FABD200BFCBF0C13DBAC2103043O0067B3D94F030B3O007CB815D17583B158B212C103073O00C32AD77CB521EC030B3O003B563E3A11F71F4B32303103063O00986D39575E4503113O004D696E645370696B65496E73616E697479031A3O00F4DE04A781C144A1F2D235AAB0C155A6F0C313E3BFDD51E8AB8703083O00C899B76AC3DEB234025O00F07540025O0004A84003143O00536861646F77576F72645061696E446562752O66030B3O008BD57706BD435B34B9CE7E03083O0046D8BD1662D2341803113O00EDD7AA94C3DFCDAA89D4E9D7A283DCCDCC03053O00B3BABFC3E7030D3O00DD3E0AEFD82C1BE1F72C11EBF703043O0084995F78030D3O0095B31C26D6C9A3B4BC1D24F8D403073O00C0D1D26E4D97BA03103O00ED0A2CEDFDC1EE0727FBBFC5EF0662BF03063O00A4806342899F03093O002D80E7BA2285E8AD1403043O00DE60E98903093O0094BAA91BAAFFF1AAA703073O0090D9D3C77FE89303093O00D526302CF7490357EC03083O0024984F5E48B5256203083O004361737454696D6503093O00FAD1493BF5D4462CC303043O005FB7B82703123O009C31E235578112B43DEB23608F10B83AE93203073O0062D55F874634E003093O00D3AAC77376F2A2DA6303053O00349EC3A917026O001C40025O007EAB40025O00F0A94003103O0077B53C70B937778A69A8727589303BD303083O00EB1ADC5214E6551B025O00789840025O00BAA340030F3O00BBA9E8C67B9F96E6D070ACA4E8D67C03053O0014E8C189A203123O000BD1C0B5E48D077020D3C092E89E1A742CCB03083O001142BFA5C687EC77025O0016A140025O0078934003183O001CA7AF17F0FFD3C600BDAA2CFB2OEDC507EFAF1CFAA8BD8103083O00B16FCFCE739F888C03083O0033861910F640531103073O003F65E97074B42F03083O00566F6964426F6C7403103O00D534E416C734CC37F952F939C67BBC4003063O0056A35B8D7298007E042O00120C012O00013O000E56000200292O013O0004F83O00292O012O009300015O00203B0001000100032O00092O010002000200064A0001003E00013O0004F83O003E00012O0093000100013O0020A00001000100044O000300023O00202O0003000300054O00010003000200062O0001003E00013O0004F83O003E00012O0093000100033O00064A0001003E00013O0004F83O003E00012O0093000100024O0003010200043O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O0001000200022O00AD000200013O00202O0002000200094O00020002000200202O00020002000200062O0002003E000100010004F83O003E00012O0093000100024O0003000200043O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001003E00013O0004F83O003E00012O0093000100024O0052000200043O00122O0003000D3O00122O0004000E6O0002000400024O00010001000200202O00010001000F4O00010002000200062O00010040000100010004F83O004000012O0093000100024O0003000200043O00122O000300103O00122O000400116O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001004000013O0004F83O00400001002E1D00130050000100120004F83O005000012O0093000100054O000601028O000300063O00202O0003000300144O00058O0003000500024O000300036O000400016O00010004000200062O0001005000013O0004F83O005000012O0093000100043O00120C010200153O00120C010300164O00432O0100034O000C00015O002E1D0017008E000100180004F83O008E00012O0093000100024O0003000200043O00122O000300193O00122O0004001A6O0002000400024O00010001000200202O0001000100034O00010002000200062O0001008E00013O0004F83O008E00012O0093000100073O00064A0001008E00013O0004F83O008E00012O0093000100013O0020BD00010001001B4O000300023O00202O00030003001C4O00010003000200062O0001007A000100010004F83O007A00012O0093000100024O0003000200043O00122O0003001D3O00122O0004001E6O0002000400024O00010001000200202O00010001001F4O00010002000200062O0001008E00013O0004F83O008E00012O0093000100024O0003000200043O00122O000300203O00122O000400216O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001008E00013O0004F83O008E00012O0093000100054O008D000200023O00202O0002000200224O000300063O00202O0003000300144O000500023O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O00010089000100010004F83O00890001002EC20023008E000100240004F83O008E00012O0093000100043O00120C010200253O00120C010300264O00432O0100034O000C00016O0093000100024O0003000200043O00122O000300273O00122O000400286O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100F800013O0004F83O00F800012O0093000100024O0003000200043O00122O000300293O00122O0004002A6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100F800013O0004F83O00F800012O0093000100024O004E000200043O00122O0003002B3O00122O0004002C6O0002000400024O00010001000200202O00010001002D4O00010002000200262O000100F8000100020004F83O00F800012O0093000100083O00064A000100CA00013O0004F83O00CA00012O0093000100094O00930002000A4O0093000300024O0003010400043O00122O0005002E3O00122O0006002F6O0004000600024O00030003000400202O0003000300304O0003000200022O0093000400094O00CE0002000400022O00930003000B4O0093000400024O0003010500043O00122O0006002E3O00122O0007002F6O0005000700024O00040004000500202O0004000400304O0004000200022O0044000500096O0003000500024O0002000200034O00010001000200262O000100F8000100310004F83O00F800012O0093000100013O00203B0001000100322O00092O0100020002000EA8003300EB000100010004F83O00EB00012O0093000100063O0020BD0001000100344O000300023O00202O0003000300354O00010003000200062O000100EB000100010004F83O00EB00012O0093000100013O0020BD0001000100044O000300023O00202O0003000300364O00010003000200062O000100EB000100010004F83O00EB00012O0093000100013O0020BD0001000100044O000300023O00202O0003000300374O00010003000200062O000100EB000100010004F83O00EB00012O0093000100013O0020A00001000100044O000300023O00202O0003000300384O00010003000200062O000100F800013O0004F83O00F8000100120C2O0100013O0026332O0100EC000100010004F83O00EC00012O00930002000D4O004C0002000100022O00B70002000C4O00930002000C3O00064A000200F800013O0004F83O00F800012O00930002000C4O0073000200023O0004F83O00F800010004F83O00EC0001002E1D003900282O01003A0004F83O00282O012O0093000100024O0003000200043O00122O0003003B3O00122O0004003C6O0002000400024O00010001000200202O0001000100034O00010002000200062O000100282O013O0004F83O00282O012O0093000100024O0052000200043O00122O0003003D3O00122O0004003E6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100282O0100010004F83O00282O012O00930001000E3O0020E500010001003F4O000200023O00202O0002000200404O0003000F6O000400106O000500063O00202O0005000500144O000700023O00202O0007000700404O0005000700024O000500056O000600076O000800113O00202O0008000800414O000900016O00010009000200062O000100232O0100010004F83O00232O01002E1D004200282O0100430004F83O00282O012O0093000100043O00120C010200443O00120C010300454O00432O0100034O000C00015O00120C012O00463O0026C33O002D2O0100460004F83O002D2O01002E1D0048005E2O0100470004F83O005E2O01002EC2004900552O01004A0004F83O00552O012O009300015O00203B0001000100032O00092O010002000200064A000100552O013O0004F83O00552O012O0093000100013O0020A00001000100044O000300023O00202O0003000300054O00010003000200062O000100552O013O0004F83O00552O012O0093000100024O0003000200043O00122O0003004B3O00122O0004004C6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100552O013O0004F83O00552O012O0093000100054O000601028O000300063O00202O0003000300144O00058O0003000500024O000300036O000400016O00010004000200062O000100552O013O0004F83O00552O012O0093000100043O00120C0102004D3O00120C0103004E4O00432O0100034O000C00016O0093000100124O004C0001000100022O00B70001000C4O00930001000C3O00064A0001007D04013O0004F83O007D04012O00930001000C4O0073000100023O0004F83O007D0401002EC2004F0033020100500004F83O00330201000E560001003302013O0004F83O003302012O0093000100134O003E0001000100012O007F000100026O000200043O00122O000300513O00122O000400526O0002000400024O00010001000200202O0001000100034O00010002000200062O000100A02O013O0004F83O00A02O012O0093000100143O000E9E0001007E2O0100010004F83O007E2O012O0093000100153O0006890001007E2O0100010004F83O007E2O012O0093000100024O0003000200043O00122O000300533O00122O000400546O0002000400024O00010001000200202O0001000100554O00010002000200062O000100882O013O0004F83O00882O012O0093000100024O0052000200043O00122O000300563O00122O000400576O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100A02O0100010004F83O00A02O012O00930001000E3O00200700010001003F4O000200023O00202O0002000200584O0003000F6O000400166O000500063O00202O0005000500144O000700023O00202O0007000700584O0005000700024O000500056O000600076O000800113O00202O0008000800594O000900016O00010009000200062O000100A02O013O0004F83O00A02O012O0093000100043O00120C0102005A3O00120C0103005B4O00432O0100034O000C00016O0093000100024O0003000200043O00122O0003005C3O00122O0004005D6O0002000400024O00010001000200202O0001000100034O00010002000200062O000100AD2O013O0004F83O00AD2O012O0093000100083O00064A000100AF2O013O0004F83O00AF2O01002EC2005F000E0201005E0004F83O000E02012O0093000100174O0077000200043O00122O000300603O00122O000400616O00020004000200062O000100C92O0100020004F83O00C92O01002E1D0063000E020100620004F83O000E02012O0093000100054O0059000200023O00202O0002000200644O000300063O00202O00030003006500122O000500666O0003000500024O000300036O00010003000200062O0001000E02013O0004F83O000E02012O0093000100043O001218010200673O00122O000300686O000100036O00015O00044O000E02012O0093000100174O0062000200043O00122O000300693O00122O0004006A6O00020004000200062O000100D22O0100020004F83O00D22O01002E1D006B00F22O01006C0004F83O00F22O012O0093000100183O00203B00010001006D2O00092O010002000200064A000100DD2O013O0004F83O00DD2O012O0093000100013O00203B00010001006E2O0093000300184O00CE000100030002000689000100DF2O0100010004F83O00DF2O01002E5E006F0031000100700004F83O000E02012O0093000100054O0032000200113O00202O0002000200714O000300063O00202O00030003006500122O000500666O0003000500024O000300036O00010003000200062O000100EC2O0100010004F83O00EC2O01002EC20072000E020100730004F83O000E02012O0093000100043O001218010200743O00122O000300756O000100036O00015O00044O000E02012O0093000100174O0077000200043O00122O000300763O00122O000400776O00020004000200062O0001000E020100020004F83O000E0201002E5E00780003000100790004F83O00FC2O010004F83O000E0201002E1D007A000E0201007B0004F83O000E02012O0093000100054O0059000200113O00202O0002000200714O000300063O00202O00030003006500122O000500666O0003000500024O000300036O00010003000200062O0001000E02013O0004F83O000E02012O0093000100043O00120C0102007C3O00120C0103007D4O00432O0100034O000C00015O002E5E007E00240001007E0004F83O003202012O0093000100193O00064A0001003202013O0004F83O003202012O00930001001A3O002651000100210201007F0004F83O002102012O0093000100063O00203B0001000100802O00092O0100020002000E9E00810032020100010004F83O003202012O0093000100083O00064A0001002102013O0004F83O002102012O0093000100093O000E9E00820032020100010004F83O0032020100120C2O0100013O000EF000010026020100010004F83O00260201002E1D00830022020100840004F83O002202012O00930002001B4O004C0002000100022O00B70002000C4O00930002000C3O0006890002002E020100010004F83O002E0201002EC200860032020100850004F83O003202012O00930002000C4O0073000200023O0004F83O003202010004F83O0022020100120C012O00873O002E1D00890063030100880004F83O00630301002633012O0063030100820004F83O00630301002E5E008A005C0001008A0004F83O009302012O0093000100024O0003000200043O00122O0003008B3O00122O0004008C6O0002000400024O00010001000200202O00010001008D4O00010002000200062O0001009302013O0004F83O009302012O00930001001C3O00064A0001007C02013O0004F83O007C02012O0093000100013O00203B00010001008E2O00092O010002000200260A2O01007C0201008F0004F83O007C02012O0093000100013O0020A00001000100044O000300023O00202O0003000300374O00010003000200062O0001009302013O0004F83O009302012O0093000100024O0003010200043O00122O000300903O00122O000400916O0002000400024O00010001000200202O00010001002D4O0001000200022O0005000200013O00202O0002000200924O000400023O00202O0004000400374O00020004000200062O00020093020100010004F83O009302012O0093000100024O0003010200043O00122O000300933O00122O000400946O0002000400024O00010001000200202O00010001002D4O0001000200022O00300002000A6O000300013O00202O0003000300924O000500023O00202O0005000500374O00030005000200122O000400826O0002000400024O0003000B6O000400013O00203B0004000400922O0042000600023O00202O0006000600374O00040006000200122O000500826O0003000500024O00020002000300062O00010093020100020004F83O009302012O00930001000E3O00201800010001003F4O000200023O00202O0002000200954O0003000F6O0004001D6O000500063O00202O0005000500144O000700023O00202O0007000700954O0005000700024O000500056O000600076O000800113O00202O0008000800964O00010008000200062O0001009302013O0004F83O009302012O0093000100043O00120C010200973O00120C010300984O00432O0100034O000C00016O0093000100024O0003000200043O00122O000300993O00122O0004009A6O0002000400024O00010001000200202O0001000100034O00010002000200062O000100CE02013O0004F83O00CE02012O0093000100143O000E9E000100AA020100010004F83O00AA02012O0093000100024O0003000200043O00122O0003009B3O00122O0004009C6O0002000400024O00010001000200202O0001000100554O00010002000200062O000100B402013O0004F83O00B402012O0093000100024O0052000200043O00122O0003009D3O00122O0004009E6O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100CE020100010004F83O00CE02012O00930001000E3O0020E500010001003F4O000200023O00202O0002000200584O0003000F6O0004001E6O000500063O00202O0005000500144O000700023O00202O0007000700584O0005000700024O000500056O000600076O000800113O00202O0008000800594O000900016O00010009000200062O000100C9020100010004F83O00C90201002E1D00A000CE0201009F0004F83O00CE02012O0093000100043O00120C010200A13O00120C010300A24O00432O0100034O000C00016O0093000100024O0003000200043O00122O000300A33O00122O000400A46O0002000400024O00010001000200202O00010001008D4O00010002000200062O0001002O03013O0004F83O002O03012O0093000100073O00064A0001002O03013O0004F83O002O03012O0093000100024O0003000200043O00122O000300A53O00122O000400A66O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001002O03013O0004F83O002O03012O00930001001F3O00064A0001002O03013O0004F83O002O03012O0093000100024O0052000200043O00122O000300A73O00122O000400A86O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100FC020100010004F83O00FC02012O0093000100024O0003000200043O00122O000300A93O00122O000400AA6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001000503013O0004F83O000503012O0093000100013O0020BD0001000100044O000300023O00202O0003000300AB4O00010003000200062O00010005030100010004F83O00050301002E5E00AC0013000100AD0004F83O001603012O0093000100054O0055010200023O00202O0002000200AE4O000300063O00202O0003000300144O000500023O00202O0005000500AE4O0003000500024O000300036O00010003000200062O0001001603013O0004F83O001603012O0093000100043O00120C010200AF3O00120C010300B04O00432O0100034O000C00015O002E1D00B10062030100B20004F83O006203012O0093000100024O0003000200043O00122O000300B33O00122O000400B46O0002000400024O00010001000200202O00010001008D4O00010002000200062O0001006203013O0004F83O006203012O0093000100033O00064A0001006203013O0004F83O006203012O0093000100024O0003010200043O00122O000300B53O00122O000400B66O0002000400024O00010001000200202O0001000100084O0001000200022O00AD000200013O00202O0002000200094O00020002000200202O00020002000200062O00020062030100010004F83O006203012O0093000100024O0003000200043O00122O000300B73O00122O000400B86O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001006203013O0004F83O006203012O0093000100024O0052000200043O00122O000300B93O00122O000400BA6O0002000400024O00010001000200202O00010001000F4O00010002000200062O00010051030100010004F83O005103012O0093000100024O0052000200043O00122O000300BB3O00122O000400BC6O0002000400024O00010001000200202O00010001000C4O00010002000200062O00010062030100010004F83O006203012O0093000100054O00C0000200023O00202O0002000200BD4O000300063O00202O00030003006500122O000500666O0003000500024O000300036O000400016O00010004000200062O0001006203013O0004F83O006203012O0093000100043O00120C010200BE3O00120C010300BF4O00432O0100034O000C00015O00120C012O00023O002633012O0001000100870004F83O00010001002EC200C000B4030100C10004F83O00B403012O0093000100203O00203B0001000100032O00092O010002000200064A000100B403013O0004F83O00B403012O0093000100063O0020A00001000100344O000300023O00202O0003000300C24O00010003000200062O0001007603013O0004F83O007603012O0093000100073O0006890001008A030100010004F83O008A03012O0093000100024O0003000200043O00122O000300C33O00122O000400C46O0002000400024O00010001000200202O0001000100554O00010002000200062O000100B403013O0004F83O00B403012O0093000100024O0003000200043O00122O000300C53O00122O000400C66O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100B403013O0004F83O00B403012O00930001001A3O002651000100920301007F0004F83O009203012O0093000100063O00203B0001000100802O00092O0100020002000E9E008100B4030100010004F83O00B403012O0093000100024O0003000200043O00122O000300C73O00122O000400C86O0002000400024O00010001000200202O00010001000C4O00010002000200062O000100AA03013O0004F83O00AA03012O0093000100024O0003010200043O00122O000300C93O00122O000400CA6O0002000400024O00010001000200202O00010001002D4O0001000200022O0093000200213O0006502O0100AA030100020004F83O00AA03012O00930001001A3O0026A9000100B4030100810004F83O00B403012O0093000100054O0093000200204O00092O010002000200064A000100B403013O0004F83O00B403012O0093000100043O00120C010200CB3O00120C010300CC4O00432O0100034O000C00016O0093000100024O0003000200043O00122O000300CD3O00122O000400CE6O0002000400024O00010001000200202O0001000100034O00010002000200062O0001002F04013O0004F83O002F04012O0093000100024O0003010200043O00122O000300CF3O00122O000400D06O0002000400024O00010001000200202O0001000100084O0001000200022O00930002000A4O0093000300214O0093000400024O001C000500043O00122O000600D13O00122O000700D26O0005000700024O0004000400050020300104000400D34O000400056O00023O00024O0003000B6O000400216O000500024O001C000600043O00122O000700D13O00122O000800D26O0006000800024O0005000500060020190105000500D34O000500066O00033O00024O00020002000300062O0001001B000100020004F83O00F903012O0093000100224O00820002000A6O000300026O000400043O00122O000500D43O00122O000600D56O0004000600024O00030003000400202O0003000300D34O0003000200024O000400216O0002000400024O0003000B6O000400026O000500043O00122O000600D43O00122O000700D56O0005000700024O00040004000500202O0004000400D34O0004000200024O000500216O0003000500024O00020002000300062O0001002F040100020004F83O002F04012O00930001001F3O00064A0001002F04013O0004F83O002F04012O0093000100024O0003000200043O00122O000300D63O00122O000400D76O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001002F04013O0004F83O002F04012O0093000100224O001A010200026O000300043O00122O000400D83O00122O000500D96O0003000500024O00020002000300202O0002000200D34O00020002000200062O0002002F040100010004F83O002F04012O0093000100093O0026BE0001002F040100DA0004F83O002F04012O0093000100013O0020A000010001001B4O000300023O00202O00030003001C4O00010003000200062O0001002F04013O0004F83O002F04012O0093000100054O008D000200023O00202O0002000200224O000300063O00202O0003000300144O000500023O00202O0005000500224O0003000500024O000300036O000400016O00010004000200062O0001002A040100010004F83O002A0401002EC200DB002F040100DC0004F83O002F04012O0093000100043O00120C010200DD3O00120C010300DE4O00432O0100034O000C00015O002E1D00DF0061040100E00004F83O006104012O0093000100024O0003000200043O00122O000300E13O00122O000400E26O0002000400024O00010001000200202O00010001008D4O00010002000200062O0001006104013O0004F83O006104012O0093000100223O0026BE00010061040100820004F83O006104012O00930001001F3O00064A0001006104013O0004F83O006104012O0093000100024O0003000200043O00122O000300E33O00122O000400E46O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001006104013O0004F83O006104012O0093000100093O0026BE00010061040100DA0004F83O006104012O0093000100054O0057000200023O00202O0002000200AE4O000300063O00202O0003000300144O000500023O00202O0005000500AE4O0003000500024O000300036O00010003000200062O0001005C040100010004F83O005C0401002E1D00E50061040100E60004F83O006104012O0093000100043O00120C010200E73O00120C010300E84O00432O0100034O000C00016O0093000100024O0003000200043O00122O000300E93O00122O000400EA6O0002000400024O00010001000200202O0001000100034O00010002000200062O0001007B04013O0004F83O007B04012O0093000100054O0059000200023O00202O0002000200EB4O000300063O00202O00030003006500122O000500666O0003000500024O000300036O00010003000200062O0001007B04013O0004F83O007B04012O0093000100043O00120C010200EC3O00120C010300ED4O00432O0100034O000C00015O00120C012O00823O0004F83O000100012O00613O00017O00653O00028O00025O0030AE40025O00C07C40026O00F03F025O00F09940025O00149040027O0040025O00C0AA40025O00405640025O00508940025O0095B140030F3O000B1B3C3A04152E0A2A1A1306361B3D03063O00674F7E4F4A61030A3O0049734361737461626C6503103O004865616C746850657263656E74616765030F3O00446573706572617465507261796572026O002A40025O00E06B40031A3O00BE7AC0635B08BB6BD64C4E08BB66D6612O1EBF79D67D4D13AC7A03063O007ADA1FB3133E030F3O0085D7C0D1C0B34CB0F3C0C3DBA046B603073O0025D3B6ADA1A9C103073O0049735265616479030D3O00546172676574497356616C696403093O004973496E52616E6765026O003E40031D3O00417265556E69747342656C6F774865616C746850657263656E74616765025O001CA440025O0094A740030F3O0056616D7069726963456D6272616365031A3O00E13B40C92169B0F40548D42A69B8F43F0DDD2D7DBCF92944CF2D03073O00D9975A2DB9481B03043O00328C813203063O003974EDE55747025O00807340025O00A0724003043O0046616465025O00A06940025O004FB040030E3O00ACB0E9E237EA42ACB4E3F47EF84203073O0027CAD18D87178E030A3O00DB3A2O1A37EAEC3A060403063O00989F53696A52030A3O0044697370657273696F6E03143O0085CF42E2CC4E92CF5EFC895884C054FCDA5597C303063O003CE1A63192A9025O005C9C40025O00F49940026O000840025O00E07240025O00F6A540025O00809D40025O00D88240025O00BBB240025O00A9B240025O0019B34003093O00E570E6015EEB79E61E03053O0036A31C8772025O0024AA40025O00309640025O00E4A240025O008EA140030F3O00466C6173684865616C506C6179657203143O002ED75C91464020DE5C8E0E7B2DDD588C5D763EDE03063O001F48BB3DE22E025O00BEAA40025O00E6A74003053O00F1034DD75003073O0044A36623B2271E030B3O0052656E6577506C61796572030F3O00AC75D4C214F58714B8752OD40AA38603083O0071DE10BAA763D5E3025O0092A440025O00489140030F3O001E01ECF33C39F4E42A3DF3FF2B02FF03043O00964E6E9B03153O00506F776572576F7264536869656C64506C61796572031B3O0095CA30E4B621A84F97C118F2AC17BA4C818523E4A21BB1538CD32203083O0020E5A54781C47EDF030B3O00EB8CC58D95DDD09DCB8F8403063O00B5A3E9A42OE1025O0030AF40025O00A0AA40030B3O004865616C746873746F6E65025O00AAAB40025O008EA04003173O00588E3F7B44832D635F853B37548E38725E98376155CB6D03043O001730EB5E025O00D07E40025O00F6AC4003193O004EDFDE4F5220DA75D4DF1D7F36D370D3D65A1703DD68D3D75303073O00B21CBAB83D3753025O00CDB140025O0058A74003173O00F6C8412EF71DFDCDC34014F70FF9CDC3400CFD1AFCCBC303073O0095A4AD275C926E03173O0052656672657368696E674865616C696E67506F74696F6E025O0012A640025O0076A84003253O00E122160D1F08FB2E1E185A13F6261C16141CB3371F0B1314FD67141A1C1EFD3419091F5BA703063O007B9347707F7A00B9012O00120C012O00014O0083000100023O000EF00001000600013O0004F83O00060001002E5E00020005000100030004F83O0009000100120C2O0100014O0083000200023O00120C012O00043O000EF00004000D00013O0004F83O000D0001002E1D00050002000100060004F83O000200010026332O01000D000100010004F83O000D000100120C010200013O00263301020075000100040004F83O0075000100120C010300013O00263301030017000100040004F83O0017000100120C010200073O0004F83O0075000100263301030013000100010004F83O0013000100120C010400013O0026C30004001E000100040004F83O001E0001002E1D00080020000100090004F83O0020000100120C010300043O0004F83O001300010026330104001A000100010004F83O001A0001002EC2000A00440001000B0004F83O004400012O009300056O0003000600013O00122O0007000C3O00122O0008000D6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005004400013O0004F83O004400012O0093000500023O00203B00050005000F2O00090105000200022O0093000600033O0006C100050044000100060004F83O004400012O0093000500043O00064A0005004400013O0004F83O004400012O0093000500054O009300065O0020110106000600102O00090105000200020006890005003F000100010004F83O003F0001002EC200120044000100110004F83O004400012O0093000500013O00120C010600133O00120C010700144O0043010500074O000C00056O009300056O0003000600013O00122O000700153O00122O000800166O0006000800024O00050005000600202O0005000500174O00050002000200062O0005006300013O0004F83O006300012O0093000500063O0020110105000500182O004C00050001000200064A0005006300013O0004F83O006300012O0093000500073O00203B00050005001900120C0107001A4O00CE00050007000200064A0005006300013O0004F83O006300012O0093000500083O00064A0005006300013O0004F83O006300012O0093000500063O00207B00050005001B4O000600096O0007000A6O00050007000200062O00050065000100010004F83O00650001002E5E001C000F0001001D0004F83O007200012O0093000500054O004C01065O00202O00060006001E4O000700076O000800016O00050008000200062O0005007200013O0004F83O007200012O0093000500013O00120C0106001F3O00120C010700204O0043010500074O000C00055O00120C010400043O0004F83O001A00010004F83O00130001002633010200BA000100010004F83O00BA00012O009300036O0003000400013O00122O000500213O00122O000600226O0004000600024O00030003000400202O0003000300174O00030002000200062O0003008A00013O0004F83O008A00012O00930003000B3O00064A0003008A00013O0004F83O008A00012O0093000300023O00203B00030003000F2O00090103000200022O00930004000C3O00062E01030003000100040004F83O008C0001002E1D0023009B000100240004F83O009B00012O0093000300054O004801045O00202O0004000400254O000500066O000700016O00030007000200062O00030096000100010004F83O00960001002E1D0027009B000100260004F83O009B00012O0093000300013O00120C010400283O00120C010500294O0043010300054O000C00036O009300036O0003000400013O00122O0005002A3O00122O0006002B6O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300B900013O0004F83O00B900012O0093000300023O00203B00030003000F2O00090103000200022O00930004000D3O00064B000300B9000100040004F83O00B900012O00930003000E3O00064A000300B900013O0004F83O00B900012O0093000300054O009300045O00201101040004002C2O000901030002000200064A000300B900013O0004F83O00B900012O0093000300013O00120C0104002D3O00120C0105002E4O0043010300054O000C00035O00120C010200043O0026C3000200BE000100070004F83O00BE0001002E5E002F00C6000100300004F83O00822O0100120C010300014O0083000400043O002633010300C0000100010004F83O00C0000100120C010400013O000E56000400C7000100040004F83O00C7000100120C010200313O0004F83O00822O010026C3000400CB000100010004F83O00CB0001002E1D003300C3000100320004F83O00C300012O00930005000F3O00064A0005005A2O013O0004F83O005A2O0100120C010500014O0083000600063O002EC2003500D0000100340004F83O00D00001002633010500D0000100010004F83O00D0000100120C010600013O002E5E0036005F000100360004F83O00342O01002633010600342O0100010004F83O00342O0100120C010700014O0083000800083O002633010700DB000100010004F83O00DB000100120C010800013O002633010800E2000100040004F83O00E2000100120C010600043O0004F83O00342O01000E56000100DE000100080004F83O00DE000100120C010900013O0026C3000900E9000100010004F83O00E90001002E1D0038002C2O0100370004F83O002C2O012O0093000A6O0003000B00013O00122O000C00393O00122O000D003A6O000B000D00024O000A000A000B00202O000A000A000E4O000A0002000200062O000A00FC00013O0004F83O00FC00012O0093000A00023O00203B000A000A000F2O0009010A000200022O0093000B00103O0006C1000A00FC0001000B0004F83O00FC00012O0093000A00113O000689000A00FE000100010004F83O00FE0001002E1D003B000B2O01003C0004F83O000B2O01002EC2003E000B2O01003D0004F83O000B2O012O0093000A00054O0093000B00123O002011010B000B003F2O0009010A0002000200064A000A000B2O013O0004F83O000B2O012O0093000A00013O00120C010B00403O00120C010C00414O0043010A000C4O000C000A5O002EC20043002B2O0100420004F83O002B2O012O0093000A6O0003000B00013O00122O000C00443O00122O000D00456O000B000D00024O000A000A000B00202O000A000A000E4O000A0002000200062O000A002B2O013O0004F83O002B2O012O0093000A00023O00203B000A000A000F2O0009010A000200022O0093000B00133O0006C1000A002B2O01000B0004F83O002B2O012O0093000A00143O00064A000A002B2O013O0004F83O002B2O012O0093000A00054O0093000B00123O002011010B000B00462O0009010A0002000200064A000A002B2O013O0004F83O002B2O012O0093000A00013O00120C010B00473O00120C010C00484O0043010A000C4O000C000A5O00120C010900043O002633010900E5000100040004F83O00E5000100120C010800043O0004F83O00DE00010004F83O00E500010004F83O00DE00010004F83O00342O010004F83O00DB0001002EC2004A00D5000100490004F83O00D50001002633010600D5000100040004F83O00D500012O009300076O0003000800013O00122O0009004B3O00122O000A004C6O0008000A00024O00070007000800202O00070007000E4O00070002000200062O0007005A2O013O0004F83O005A2O012O0093000700023O00203B00070007000F2O00090107000200022O0093000800153O0006C10007005A2O0100080004F83O005A2O012O0093000700163O00064A0007005A2O013O0004F83O005A2O012O0093000700054O0093000800123O00201101080008004D2O000901070002000200064A0007005A2O013O0004F83O005A2O012O0093000700013O0012180108004E3O00122O0009004F6O000700096O00075O00044O005A2O010004F83O00D500010004F83O005A2O010004F83O00D000012O0093000500174O0003000600013O00122O000700503O00122O000800516O0006000800024O00050005000600202O0005000500174O00050002000200062O0005006D2O013O0004F83O006D2O012O0093000500183O00064A0005006D2O013O0004F83O006D2O012O0093000500023O00203B00050005000F2O00090105000200022O0093000600193O00062E01050003000100060004F83O006F2O01002E1D0052007E2O0100530004F83O007E2O012O0093000500054O0048010600123O00202O0006000600544O000700086O000900016O00050009000200062O000500792O0100010004F83O00792O01002E1D0055007E2O0100560004F83O007E2O012O0093000500013O00120C010600573O00120C010700584O0043010500074O000C00055O00120C010400043O0004F83O00C300010004F83O00822O010004F83O00C000010026C3000200862O0100310004F83O00862O01002E1D005A0010000100590004F83O001000012O00930003001A3O00064A000300B82O013O0004F83O00B82O012O0093000300023O00203B00030003000F2O00090103000200022O00930004001B3O0006C1000300B82O0100040004F83O00B82O012O00930003001C4O0062000400013O00122O0005005B3O00122O0006005C6O00040006000200062O000300972O0100040004F83O00972O010004F83O00B82O01002EC2005E00B82O01005D0004F83O00B82O012O0093000300174O0003000400013O00122O0005005F3O00122O000600606O0004000600024O00030003000400202O0003000300174O00030002000200062O000300B82O013O0004F83O00B82O012O0093000300054O0048010400123O00202O0004000400614O000500066O000700016O00030007000200062O000300AD2O0100010004F83O00AD2O01002E5E0062000D000100630004F83O00B82O012O0093000300013O001218010400643O00122O000500656O000300056O00035O00044O00B82O010004F83O001000010004F83O00B82O010004F83O000D00010004F83O00B82O010004F83O000200012O00613O00017O00193O0003073O0047657454696D65028O00025O00ECAC40025O00709340025O00749040025O00709F40030B3O00EEC2866847C2C9B17E53C003053O0026ACADE211030B3O004973417661696C61626C65030F3O007D1E3BEA5F2623FD492224E6481D2803043O008F2D714C03073O004973526561647903083O0042752O66446F776E03123O00416E67656C69634665617468657242752O66030F3O00426F6479616E64536F756C42752O6603153O00506F776572576F7264536869656C64506C61796572031D3O00A8B70B39AA870B33AABC232FB0B11930BC870C30B9A1192EF8B5132ABD03043O005C2OD87C030E3O007A3CAB45F152318A45FC4F3AA95203053O009D3B52CC20025O0065B140025O0063B34003143O00416E67656C696346656174686572506C61796572031B3O003930E4FFE5E3D08E3E3BE2EEE1EFC18E2832E2E3ECF893BC3728E603083O00D1585E839A898AB300703O00122F3O00018O000100024O00019O003O00014O000100013O00062O0001006F00013O0004F83O006F000100120C012O00023O002E1D00040008000100030004F83O00080001002633012O0008000100020004F83O00080001002EC20005003E000100060004F83O003E00012O0093000100024O0003000200033O00122O000300073O00122O000400086O0002000400024O00010001000200202O0001000100094O00010002000200062O0001003E00013O0004F83O003E00012O0093000100024O0003000200033O00122O0003000A3O00122O0004000B6O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001003E00013O0004F83O003E00012O0093000100043O00064A0001003E00013O0004F83O003E00012O0093000100053O0020A000010001000D4O000300023O00202O00030003000E4O00010003000200062O0001003E00013O0004F83O003E00012O0093000100053O0020A000010001000D4O000300023O00202O00030003000F4O00010003000200062O0001003E00013O0004F83O003E00012O0093000100064O0093000200073O0020110102000200102O00092O010002000200064A0001003E00013O0004F83O003E00012O0093000100033O00120C010200113O00120C010300124O00432O0100034O000C00016O0093000100024O0003000200033O00122O000300133O00122O000400146O0002000400024O00010001000200202O00010001000C4O00010002000200062O0001006000013O0004F83O006000012O0093000100083O00064A0001006000013O0004F83O006000012O0093000100053O0020A000010001000D4O000300023O00202O00030003000E4O00010003000200062O0001006000013O0004F83O006000012O0093000100053O0020A000010001000D4O000300023O00202O00030003000F4O00010003000200062O0001006000013O0004F83O006000012O0093000100053O0020BD00010001000D4O000300023O00202O00030003000E4O00010003000200062O00010062000100010004F83O00620001002EC20016006F000100150004F83O006F00012O0093000100064O0093000200073O0020110102000200172O00092O010002000200064A0001006F00013O0004F83O006F00012O0093000100033O001218010200183O00122O000300196O000100036O00015O00044O006F00010004F83O000800012O00613O00017O000B3O00030D3O0018B4D675183A152B3BA4C56F1B03083O004248C1A41C7E435103073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974025O0080AE40025O00D1B24003123O0050757269667944697365617365466F637573025O00DC9540025O0034984003153O00F739BA51206FD828A14B2377F429E85C2F65F729A403063O0016874CC8384600224O007F9O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001200013O0004F83O001200012O00933O00023O00064A3O001200013O0004F83O001200012O00933O00033O002011014O00042O004C3O000100020006893O0014000100010004F83O00140001002E5E0005000F000100060004F83O002100012O00933O00044O0093000100053O0020112O01000100072O0009012O000200020006893O001C000100010004F83O001C0001002E1D00090021000100080004F83O002100012O00933O00013O00120C2O01000A3O00120C0102000B4O0043012O00024O000C8O00613O00017O00EC3O00028O00025O0048AE40026O000840026O00F03F030C3O004570696353652O74696E677303083O002DC4B4F0B47C19D203063O00127EA1C084DD03063O007929AA017E6F03053O00363F48CE6403083O00FB5C516EEC75CF4A03063O001BA839251A85030E3O0018B97980D22CA668A0C439A572AD03053O00B74DCA1CC8027O0040026O00104003083O0024369D1C1E3D8E1B03043O00687753E9030D3O00DDFD262E57FDEB332D4DF0D01703053O00239598474203083O002AED56A43317EF5103053O005A798822D003123O00F701421BD5275B18D21D5C11C93B461FC00B03043O007EA76E35034O0003083O0010D1603DD8F824C703063O009643B41449B1030D3O00B80B1F69840B0A489F0B13428303043O002DED787A03083O00E4EDB638DEE6A53F03043O004CB788C203073O004FF5E01E514B1103073O00741A868558302F025O00E49140025O00B0A140025O00A2AB40025O00E5B14003083O00E5A3F3D370B9D1B503063O00D7B6C687A71903113O00A54CEB448447ED78825DE3478367EB458803043O0028ED298A03083O00F471EEEC43C973E903053O002AA7149A98030F3O0062FBA34E782F4DCEAD56782E44D69203063O00412A9EC2221103083O00BE35EC3054EF8A2303063O0081ED5098443D030A3O0064BB01C11D145150A41703073O003831C864937C7703083O00FF3BABE4C530B8E303043O0090AC5EDF03103O00111CA76F210EAE4E2A0892483006AD4903043O0027446FC203083O002922461824E31CFD03083O008E7A47326C4D8D7B03153O0020B1FA283402A7ED2F3407A6D9172901ABEB0D3F1003053O005B75C29F7803083O0029182A0C3CFF230903073O00447A7D5E78559103113O00220FCA7FC6DEBF1B15CC78CDD8AE1F19DD03073O00DA777CAF3EA8B9026O001C4003083O00CD7711CBF77C02CC03043O00BF9E126503113O00F3C28AA7A6D7CA8492A2C7D186B4AAEDF303053O00CFA5A3E7D703083O00F5FCED422D7EC1EA03063O0010A62O99364403143O00E4B2CD563D33F0D196CD442620FAD794D249213103073O0099B2D3A026544103083O00B10E4E3F8B055D3803043O004BE26B3A03103O006BD6107E1ED5EE4ADF027224D1CC5FDB03073O00AD38BE711A71A203083O00F8DB3911FEC5D93E03053O0097ABBE4D6503123O00F32EF5B9F16F02C61BF7BCFB753ED62EFFAC03073O006BA54F98C9981D03083O00644BFCDF5D71505D03063O001F372E88AB3403103O00E729D1E4D83AD5F7E527C9F7D905DDEC03043O0094B148BC03083O008EEE2BB4C0B3EC2C03053O00A9DD8B5FC0030D3O00FA826C2F272AFA8E7D2A2420CD03063O0046BEEB1F5F4203083O0089E70EF2ECB4E50903053O0085DA827A86030B3O0018F6F0D4D9AF1A29F9E5D703073O00585C9F83A4BCC3025O0035B040025O00E07F4003083O00B32BAB5FDEE5DA9303073O00BDE04EDF2BB78B030F3O0006FD8412CD2BDD8C10CD27FF9E13C503053O00A14E9CEA7603083O0094B2DDC8AEB9CECF03043O00BCC7D7A903113O00D408517FE4F9205178E7EE195069EDFD0503053O00889C693F1B026O009740025O0048AB40025O00406040025O00B49D4003083O0096F55CD0ACFE4FD703043O00A4C59028030E3O00B6E3AFA9D2B29AD1A48FEEB996FC03063O00D6E390CAEBBD03083O00DEA0936F19BD542F03083O005C8DC5E71B70D333030D3O00CBF09CA6DCE3F19E87D4EAFE9303053O00B1869FEAC3026O001440025O0004A440025O006AAD40026O00184003083O002OEA124A19BF360503083O0076B98F663E70D15103073O0069632CCEA4191303083O00583C104986C5757C03083O0063EFECDC485EEDEB03053O0021308A98A803063O005A173C5EE90703063O005712765031A103083O00C34A4E93F9415D9403043O00E7902F3A030C3O0087CBDF53143CDC319ADDDB7903083O0059D2B8BA15785DAF03083O00825668C17034B64003063O005AD1331CB519030B3O00F67756FDB7F87E56E297E003053O00DFB01B378E025O002C9A40025O0050734003083O007F1BCEB4B94219C903053O00D02C7EBAC003093O00DF1BA8C933EEC65BE703083O002E977AC4A6749CA903083O00D6E8520EF2EBEA5503053O009B858D267A030D3O001039A9654669AC2B2F9F554E6D03073O00C5454ACC212F1F025O00B2A640025O00308E40025O0094A140025O00889840025O0046A540025O00AEA040025O002O704003083O00BE4D90FD79B88A5B03063O00D6ED28E4891003123O00B5ECF8DC118F8BE5FACA0AA98BC4FDD616B603063O00C6E5838FB96303083O006289BC675882AF6003043O001331ECC803073O00CE1ED8B6E9BFAF03063O00DA9E5796D784025O00909F4003083O00C81BCDF63F2CCAE803073O00AD9B7EB982564203073O00D58F94C685E9B703063O008C85C6DAA7E803083O00862BA0698DBB29A703053O00E4D54ED41D03073O00B7659804E6821F03053O008BE72CD665025O00606540025O003C904003083O000E153AECD5313A2O03063O005F5D704E98BC03133O00F1FA9210F697DCC7E0961CEBB0E6C0E78210F003073O00B2A195E57584DE03083O00BBDEC9B8A818A13003083O0043E8BBBDCCC176C6030F3O00BB21A225292BE18D3BA629340CC7BB03073O008FEB4ED5405B62025O0054A340025O0078A14003083O002EAC9EBF2A771ABA03063O00197DC9EACB43030D3O004CE71D301C261776E31E0C062A03073O007319947863744703083O003F38AD3048023AAA03053O00216C5DD94403123O00EE58A49BDA46B1A4C942A288D649B3ACD84E03043O00CDBB2BC1026O00A340025O0048924003083O004BA857B071A344B703043O00C418CD2303123O001B98E636219CE6141984F1021D83EA03228F03043O00664EEB8303083O00C92B20504E37B02703083O00549A4E54242759D703113O00CDEE415D17CAEE445C36F5E8535401D5D103053O00659D81363803083O0017BEDAA12DB5C9A603043O00D544DBAE03083O003EF326D52FCB3A6803083O001F6B8043874AA55F03083O00EBEDE85948BFDFFB03063O00D1B8889C2D2103073O0035CD7B0DAF2FF803053O00D867A81568025O00B49040025O0098B240025O00B9B240025O00A4A94003083O0030D536B2810DD73103053O00E863B042C603123O00C52F3C03699FEC3CF81520147E9EF123E02503083O004C8C4148661BED9903083O0079DF02C6DE0FB95903073O00DE2ABA76B2B76103123O0068FF41AE58FF548F4FED508F6DFE459358FE03043O00EA3D8C24025O003EB340025O00B88040025O00A49B40025O00A7B24003083O0012D8AE66062FDAA903053O006F41BDDA1203113O00674E08250E4EAE574E2B270A45AA51632B03073O00CF232B7B556B3C03083O0043AFB4FE707EADB303053O001910CAC08A030C3O00D9C2BEF2ACE6EEC2A2EC81C403063O00949DABCD82C903083O0028896D2012827E2703043O00547BEC1903113O00D985BE12BEA7E59BBE20A5A1F8B8BE02A203063O00D590EBCA77CC03083O00101DCA3E212D4A3003073O002D4378BE4A484303163O00092CF9A0EB9AFBF9340DE3A9E0BFE6E03427E1ACEA9C03083O008940428DC599E88E025O0074B2400076032O00120C012O00014O0083000100013O002E5E00023O000100020004F83O00020001002633012O0002000100010004F83O0002000100120C2O0100013O000E5600030069000100010004F83O0069000100120C010200013O000E5600040028000100020004F83O00280001001211000300056O000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O00030003000400062O0003001A000100010004F83O001A000100120C010300014O00B700035O001211000300054O001C000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300042O001C000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300042O00B7000300023O00120C0102000E3O0026330102002C000100030004F83O002C000100120C2O01000F3O0004F83O006900010026330102004D0001000E0004F83O004D0001001211000300056O000400013O00122O000500103O00122O000600116O0004000600024O0003000300044O000400013O00122O000500123O00122O000600136O0004000600024O00030003000400062O0003003C000100010004F83O003C000100120C010300014O00B7000300033O00127D000300056O000400013O00122O000500143O00122O000600156O0004000600024O0003000300044O000400013O00122O000500163O00122O000600176O0004000600024O00030003000400062O0003004B000100010004F83O004B000100120C010300184O00B7000300043O00120C010200033O000E560001000A000100020004F83O000A0001001211000300054O0031010400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000300053O00122O000300056O000400013O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000400013O00122O0005001F3O00122O000600206O0004000600024O0003000300044O000300063O00122O000200043O0004F83O000A00010026C30001006D000100010004F83O006D0001002E1D002200D2000100210004F83O00D2000100120C010200014O0083000300033O0026330102006F000100010004F83O006F000100120C010300013O0026C300030076000100040004F83O00760001002E1D00240095000100230004F83O00950001001211000400056O000500013O00122O000600253O00122O000700266O0005000700024O0004000400054O000500013O00122O000600273O00122O000700286O0005000700024O00040004000500062O00040084000100010004F83O0084000100120C010400184O00B7000400073O00127D000400056O000500013O00122O000600293O00122O0007002A6O0005000700024O0004000400054O000500013O00122O0006002B3O00122O0007002C6O0005000700024O00040004000500062O00040093000100010004F83O0093000100120C010400014O00B7000400083O00120C0103000E3O002633010300B0000100010004F83O00B00001001211000400054O0031010500013O00122O0006002D3O00122O0007002E6O0005000700024O0004000400054O000500013O00122O0006002F3O00122O000700306O0005000700024O0004000400054O000400093O00122O000400056O000500013O00122O000600313O00122O000700326O0005000700024O0004000400054O000500013O00122O000600333O00122O000700346O0005000700024O0004000400054O0004000A3O00122O000300043O000E56000E00CB000100030004F83O00CB0001001211000400054O0031010500013O00122O000600353O00122O000700366O0005000700024O0004000400054O000500013O00122O000600373O00122O000700386O0005000700024O0004000400054O0004000B3O00122O000400056O000500013O00122O000600393O00122O0007003A6O0005000700024O0004000400054O000500013O00122O0006003B3O00122O0007003C6O0005000700024O0004000400054O0004000C3O00122O000300033O00263301030072000100030004F83O0072000100120C2O0100043O0004F83O00D200010004F83O007200010004F83O00D200010004F83O006F00010026332O0100202O01003D0004F83O00202O01001211000200056O000300013O00122O0004003E3O00122O0005003F6O0003000500024O0002000200034O000300013O00122O000400403O00122O000500416O0003000500024O00020002000300062O000200E2000100010004F83O00E2000100120C010200014O00B70002000D3O00127D000200056O000300013O00122O000400423O00122O000500436O0003000500024O0002000200034O000300013O00122O000400443O00122O000500456O0003000500024O00020002000300062O000200F1000100010004F83O00F1000100120C010200014O00B70002000E3O00127D000200056O000300013O00122O000400463O00122O000500476O0003000500024O0002000200034O000300013O00122O000400483O00122O000500496O0003000500024O00020002000300062O00022O002O0100010004F84O002O0100120C010200184O00B70002000F3O00127D000200056O000300013O00122O0004004A3O00122O0005004B6O0003000500024O0002000200034O000300013O00122O0004004C3O00122O0005004D6O0003000500024O00020002000300062O0002000F2O0100010004F83O000F2O0100120C010200184O00B7000200103O00127D000200056O000300013O00122O0004004E3O00122O0005004F6O0003000500024O0002000200034O000300013O00122O000400503O00122O000500516O0003000500024O00020002000300062O0002001E2O0100010004F83O001E2O0100120C010200014O00B7000200113O0004F83O007503010026332O0100922O0100040004F83O00922O0100120C010200013O002633010200462O0100040004F83O00462O0100120C010300013O002633010300412O0100010004F83O00412O01001211000400054O0031010500013O00122O000600523O00122O000700536O0005000700024O0004000400054O000500013O00122O000600543O00122O000700556O0005000700024O0004000400054O000400123O00122O000400056O000500013O00122O000600563O00122O000700576O0005000700024O0004000400054O000500013O00122O000600583O00122O000700596O0005000700024O0004000400054O000400133O00122O000300043O002633010300262O0100040004F83O00262O0100120C0102000E3O0004F83O00462O010004F83O00262O010026330102006D2O01000E0004F83O006D2O0100120C010300013O002EC2005B00662O01005A0004F83O00662O01002633010300662O0100010004F83O00662O01001211000400054O0031010500013O00122O0006005C3O00122O0007005D6O0005000700024O0004000400054O000500013O00122O0006005E3O00122O0007005F6O0005000700024O0004000400054O000400143O00122O000400056O000500013O00122O000600603O00122O000700616O0005000700024O0004000400054O000500013O00122O000600623O00122O000700636O0005000700024O0004000400054O000400153O00122O000300043O0026C30003006A2O0100040004F83O006A2O01002EC2006500492O0100640004F83O00492O0100120C010200033O0004F83O006D2O010004F83O00492O010026C3000200712O0100030004F83O00712O01002EC2006700732O0100660004F83O00732O0100120C2O01000E3O0004F83O00922O01002633010200232O0100010004F83O00232O01001211000300054O0068000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000300163O00122O000300056O000400013O00122O0005006C3O00122O0006006D6O0004000600024O0003000300044O000400013O00122O0005006E3O00122O0006006F6O0004000600024O00030003000400062O0003008F2O0100010004F83O008F2O0100120C010300014O00B7000300173O00120C010200043O0004F83O00232O010026C3000100962O0100700004F83O00962O01002EC20072002O020100710004F83O002O020100120C010200013O0026330102009B2O0100030004F83O009B2O0100120C2O0100733O0004F83O002O0201002633010200B92O0100010004F83O00B92O01001211000300054O0068000400013O00122O000500743O00122O000600756O0004000600024O0003000300044O000400013O00122O000500763O00122O000600776O0004000600024O0003000300044O000300183O00122O000300056O000400013O00122O000500783O00122O000600796O0004000600024O0003000300044O000400013O00122O0005007A3O00122O0006007B6O0004000600024O00030003000400062O000300B72O0100010004F83O00B72O0100120C010300014O00B7000300193O00120C010200043O002633010200D72O01000E0004F83O00D72O01001211000300054O0068000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000400013O00122O0005007E3O00122O0006007F6O0004000600024O0003000300044O0003001A3O00122O000300056O000400013O00122O000500803O00122O000600816O0004000600024O0003000300044O000400013O00122O000500823O00122O000600836O0004000600024O00030003000400062O000300D52O0100010004F83O00D52O0100120C010300014O00B70003001B3O00120C010200033O0026C3000200DB2O0100040004F83O00DB2O01002E1D008400972O0100850004F83O00972O0100120C010300013O002633010300FA2O0100010004F83O00FA2O01001211000400056O000500013O00122O000600863O00122O000700876O0005000700024O0004000400054O000500013O00122O000600883O00122O000700896O0005000700024O00040004000500062O000400EC2O0100010004F83O00EC2O0100120C010400014O00B70004001C3O001211000400054O001C000500013O00122O0006008A3O00122O0007008B6O0005000700024O0004000400052O001C000500013O00122O0006008C3O00122O0007008D6O0005000700024O0004000400052O00B70004001D3O00120C010300043O002EC2008F00DC2O01008E0004F83O00DC2O01002633010300DC2O0100040004F83O00DC2O0100120C0102000E3O0004F83O00972O010004F83O00DC2O010004F83O00972O010026332O01008D0201000F0004F83O008D020100120C010200014O0083000300033O002E1D00910006020100900004F83O0006020100263301020006020100010004F83O0006020100120C010300013O000E5600040038020100030004F83O0038020100120C010400013O002E5E00920006000100920004F83O0014020100263301040014020100040004F83O0014020100120C0103000E3O0004F83O003802010026C300040018020100010004F83O00180201002EC20093000E020100940004F83O000E0201001211000500056O000600013O00122O000700953O00122O000800966O0006000800024O0005000500064O000600013O00122O000700973O00122O000800986O0006000800024O00050005000600062O00050026020100010004F83O0026020100120C010500014O00B70005001E3O00127D000500056O000600013O00122O000700993O00122O0008009A6O0006000800024O0005000500064O000600013O00122O0007009B3O00122O0008009C6O0006000800024O00050005000600062O00050035020100010004F83O0035020100120C010500184O00B70005001F3O00120C010400043O0004F83O000E02010026330103003C020100030004F83O003C020100120C2O0100703O0004F83O008D0201002E5E009D002D0001009D0004F83O00690201002633010300690201000E0004F83O0069020100120C010400013O00263301040062020100010004F83O00620201001211000500056O000600013O00122O0007009E3O00122O0008009F6O0006000800024O0005000500064O000600013O00122O000700A03O00122O000800A16O0006000800024O00050005000600062O00050051020100010004F83O0051020100120C010500184O00B7000500203O00127D000500056O000600013O00122O000700A23O00122O000800A36O0006000800024O0005000500064O000600013O00122O000700A43O00122O000800A56O0006000800024O00050005000600062O00050060020100010004F83O0060020100120C010500184O00B7000500213O00120C010400043O0026C300040066020100040004F83O00660201002E1D00A70041020100A60004F83O0041020100120C010300033O0004F83O006902010004F83O004102010026330103000B020100010004F83O000B0201001211000400056O000500013O00122O000600A83O00122O000700A96O0005000700024O0004000400054O000500013O00122O000600AA3O00122O000700AB6O0005000700024O00040004000500062O00040079020100010004F83O0079020100120C010400184O00B7000400223O00127D000400056O000500013O00122O000600AC3O00122O000700AD6O0005000700024O0004000400054O000500013O00122O000600AE3O00122O000700AF6O0005000700024O00040004000500062O00040088020100010004F83O0088020100120C010400014O00B7000400233O00120C010300043O0004F83O000B02010004F83O008D02010004F83O000602010026C300010091020100730004F83O00910201002EC200B000F8020100B10004F83O00F8020100120C010200013O002633010200AD0201000E0004F83O00AD0201001211000300054O0031010400013O00122O000500B23O00122O000600B36O0004000600024O0003000300044O000400013O00122O000500B43O00122O000600B56O0004000600024O0003000300044O000300243O00122O000300056O000400013O00122O000500B63O00122O000600B76O0004000600024O0003000300044O000400013O00122O000500B83O00122O000600B96O0004000600024O0003000300044O000300253O00122O000200033O0026C3000200B1020100040004F83O00B10201002E1D00BA00D5020100BB0004F83O00D5020100120C010300013O002633010300B6020100040004F83O00B6020100120C0102000E3O0004F83O00D50201000E56000100B2020100030004F83O00B20201001211000400054O0068000500013O00122O000600BC3O00122O000700BD6O0005000700024O0004000400054O000500013O00122O000600BE3O00122O000700BF6O0005000700024O0004000400054O000400263O00122O000400056O000500013O00122O000600C03O00122O000700C16O0005000700024O0004000400054O000500013O00122O000600C23O00122O000700C36O0005000700024O00040004000500062O000400D2020100010004F83O00D2020100120C010400014O00B7000400273O00120C010300043O0004F83O00B20201002633010200F3020100010004F83O00F30201001211000300054O0068000400013O00122O000500C43O00122O000600C56O0004000600024O0003000300044O000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000300283O00122O000300056O000400013O00122O000500C83O00122O000600C96O0004000600024O0003000300044O000400013O00122O000500CA3O00122O000600CB6O0004000600024O00030003000400062O000300F1020100010004F83O00F1020100120C010300014O00B7000300293O00120C010200043O00263301020092020100030004F83O0092020100120C2O01003D3O0004F83O00F802010004F83O009202010026332O0100070001000E0004F83O0007000100120C010200014O0083000300033O002E1D00CC00FC020100CD0004F83O00FC0201000E56000100FC020100020004F83O00FC020100120C010300013O0026330103002B030100040004F83O002B030100120C010400013O002E1D00CF0024030100CE0004F83O0024030100263301040024030100010004F83O00240301001211000500056O000600013O00122O000700D03O00122O000800D16O0006000800024O0005000500064O000600013O00122O000700D23O00122O000800D36O0006000800024O00050005000600062O00050016030100010004F83O0016030100120C010500014O00B70005002A3O001211000500054O001C000600013O00122O000700D43O00122O000800D56O0006000800024O0005000500062O001C000600013O00122O000700D63O00122O000800D76O0006000800024O0005000500062O00B70005002B3O00120C010400043O002E1D00D90004030100D80004F83O00040301000E5600040004030100040004F83O0004030100120C0103000E3O0004F83O002B03010004F83O00040301000EF0000E002F030100030004F83O002F0301002E5E00DA0021000100DB0004F83O004E0301001211000400056O000500013O00122O000600DC3O00122O000700DD6O0005000700024O0004000400054O000500013O00122O000600DE3O00122O000700DF6O0005000700024O00040004000500062O0004003D030100010004F83O003D030100120C010400014O00B70004002C3O00127D000400056O000500013O00122O000600E03O00122O000700E16O0005000700024O0004000400054O000500013O00122O000600E23O00122O000700E36O0005000700024O00040004000500062O0004004C030100010004F83O004C030100120C010400014O00B70004002D3O00120C010300033O00263301030069030100010004F83O00690301001211000400054O0031010500013O00122O000600E43O00122O000700E56O0005000700024O0004000400054O000500013O00122O000600E63O00122O000700E76O0005000700024O0004000400054O0004002E3O00122O000400056O000500013O00122O000600E83O00122O000700E96O0005000700024O0004000400054O000500013O00122O000600EA3O00122O000700EB6O0005000700024O0004000400054O0004002F3O00122O000300043O002E5E00EC0098FF2O00EC0004F83O0001030100263301030001030100030004F83O0001030100120C2O0100033O0004F83O000700010004F83O000103010004F83O000700010004F83O00FC02010004F83O000700010004F83O007503010004F83O000200012O00613O00017O0049012O00028O00025O002CA540025O00D08040026O000840025O00908D40025O00DFB240025O00888540026O00F03F030F3O00412O66656374696E67436F6D626174025O00108B40025O0090A640025O0064AE4003063O00C81DD754C4E103053O00A29868A53D03073O004973526561647903093O00466F637573556E6974025O00C88040025O0060A740026O001040025O00ACAF40025O00806040025O009C9840025O0046A240030D3O004973446561644F7247686F737403083O0049734D6F76696E6703073O0047657454696D65026O001440025O0076A340025O009C9F40030D3O00546172676574497356616C696403043O00502O6F6C025O00A2AC40025O0026AE40030F3O00B656FA8B2O3C8EDEC674F48E2O72C803083O00ACE63995E71C5AE1025O00D8AD40025O00EAA940025O00D07B40025O0034A840025O00708940025O00A4A840025O001EAB40025O00CCB140025O0074B240025O00E6A840025O00A1B240025O00FCAB40025O00789C40025O00709B40025O00EC9640025O0010A240025O0070AD40030C3O00C315C5F482192CCEE113C3FE03083O00BE957AAC90C76B59030F3O00432O6F6C646F776E52656D61696E732O033O00474344030C3O00040AF8FADB2010E1EAF73D0B03053O009E5265919E030B3O004973417661696C61626C65030D3O0054FF101D6563FD07185779F10C03053O0024109E6276030A3O00432O6F6C646F776E5570030D3O00E417D1F079FB24E0CE05CAF45603083O0085A076A39B388847030B3O00C0AD78F68210A7E4A77FE603073O00D596C21192D67F030B3O002BBABDD74EADA11A12A7AF03083O00567BC9C4B426C4C2030B3O00C1E7D0ABC3E7CBBDF2E6CD03043O00CF9788B903083O0042752O66446F776E030C3O00566F6964666F726D42752O6600025O00E8B140025O0091B04003043O0047554944027O0040025O00DC9A40025O00049C40025O0060A240025O0030B240025O0032A140025O00B4B240025O00A08340025O00C07440025O0044A840025O00909A40025O00489440025O0044A04003113O0048616E646C65496E636F72706F7265616C030D3O00536861636B6C65556E6465616403163O00536861636B6C65556E646561644D6F7573656F766572026O003E40025O0020A840025O0094A140025O00F5B240025O00C08C40025O00749040025O0075B240025O00F6A140025O00C08A40030C3O00446F6D696E6174654D696E6403153O00446F6D696E6174654D696E644D6F7573656F766572025O00B09540026O005B400100025O004DB040025O008CA340025O00988A40025O004CA540025O0010AB40025O00206D40025O00A07840025O00806F40025O00CEAC40025O0048874003113O00988C278E342O7EBAC30792717674BACB6103073O0011C8E348E21418025O0048A740025O00ECA340025O00608A40025O00B2AA40025O00A88340025O0092AD40025O004EA540025O00AEA240025O001EAF40025O009C9440025O00BC9840025O00ACAA40030B3O00944808C7CCFDC2FEB7481803083O009FD0217BB7A9918F03093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66030B3O0044697370656C4D61676963030E3O0049735370652O6C496E52616E676503133O00F6532B26F756073BF35D3135B25E393BF35D3D03043O0056923A58026O006C40025O00DAA840025O005EAD40025O006C9440030E3O0068D0E5CCEEEF39E818FE2OE5E6A003083O009A38BF8AA0CE8956025O00409440025O00C09B40025O00409340025O0072A940025O000C9140025O00FAA240025O00389740025O00B8AE40025O00208440025O00A08440025O00309240025O009C9040025O00CEB140025O00F07F40025O003CA840026O005F4003093O00496E74652O7275707403073O0053696C656E6365025O0060A140025O00207F40025O00B88440025O00FEA64003113O00496E74652O72757074576974685374756E030D3O005073796368696353637265616D026O002040025O005CA040025O0008A240025O00249240025O0028824003103O0053696C656E63654D6F7573656F766572025O00EAAF40025O00C49540025O00E5B140025O00E6AC40030F3O0048616E646C65412O666C6963746564030D3O005075726966794469736561736503163O00507572696679446973656173654D6F7573656F766572026O004440025O00B08840025O00BAAF40025O00308540025O00B07140025O0024B340025O00E2A240025O00609740025O008BB240025O001EA740025O0050A040025O00BAA640025O005C9E40025O00D07440025O00B2A140025O00A09040025O00BAAC40025O0038B04003063O0045786973747303093O00497341506C6179657203093O0043616E412O7461636B030C3O00526573752O72656374696F6E030C3O0098E6A5200C98E6B5211785ED03053O007EEA83D655025O008C9340025O002CA440025O00F6A840025O0063B140025O000DB240026O002A40025O006CA640026O00994003123O00EC50DBB43D2CE8F3D879C3A33B12F3F4D85A03083O0081BC3FACD14F7B87030A3O0049734361737461626C6503163O00506F776572576F7264466F7274697475646542752O6603103O0047726F757042752O664D692O73696E67025O0087B040025O0088924003183O00506F776572576F7264466F72746974756465506C6179657203143O0050EBF1C852DBF1C252E0D9CB4FF6F2C454F1E2C803043O00AD208486030A3O007D1309EBA126CB41090503073O00AD2E7B688FCE51030E3O00536861646F77666F726D42752O66025O00BEAD40025O00188340030A3O00536861646F77666F726D030A3O00A715238E4A9407BB0F2F03073O0061D47D42EA25E303123O00FD20A57862D2C23DB65B7FF7D926A66874E003063O0085AD4FD21D10025O0030A840025O0049B24003143O009D73FA2E9F43FA249F78D22D826EF9229969E92E03043O004BED1C8D025O00149A40025O00649840025O0020AF40025O00D49540025O00D8AF40025O007CA540025O00A2A840025O00406D40025O00A07C40025O00DEB140025O00888440025O001EA940025O00D49140025O00D09840025O0008AD40025O00207940025O00BAA340025O003AB240025O0034914003063O0042752O66557003143O004D696E64466C6179496E73616E69747942752O6603103O00A9DC475E6988D450734197D447535B9D03053O002FE4B5293A03083O008BF5D73F253C1EBF03073O007FC69CB95B6350026O00D03F03113O0054696D6553696E63654C61737443617374026O002E40025O0062A840025O00FAA040025O0066AB40025O00D0A740025O00E49E40025O0026A340025O0022A240025O00107940024O0080B3C540025O005AAD40025O0096A240030C3O00466967687452656D61696E73025O00408B40025O006C9A40025O0016AB40025O0028A34003103O00426F2O73466967687452656D61696E73025O00C07040025O0044B3402O033O00414F45025O00A49740025O00C89D40025O0058A840025O00F3B240031C3O00476574456E656D696573496E53706C61736852616E6765436F756E74026O002440025O0096B140025O005EAC40025O00405F40025O0052AE40025O0033B240025O00F8904003113O00476574456E656D696573496E52616E676503173O00476574456E656D696573496E53706C61736852616E6765025O00C06040025O007CAA40025O00EC9C40030C3O004570696353652O74696E677303073O00F2AC1C8E2OC3B003053O00AFA6C37BE92O033O00ECC64E03053O00908FA23D29025O0014AD40025O001AA440025O0079B14003073O0092B950D4AAB34403043O00B3C6D6372O033O00FF037103063O00B3906C121625025O00209140025O00D89B40025O0072A240025O00B8984003073O00D4DC1A577E822003073O005380B37D3012E703063O0059BEE0CD421203063O007E3DD793BD2703073O004CF01A4274FA0E03043O0025189F7D03043O00D2A3744E03043O0022BAC615025O004CA740025O0085B0400049062O00120C012O00014O0083000100013O002633012O0002000100010004F83O0002000100120C2O0100013O002E1D0003006D000100020004F83O006D00010026332O01006D000100040004F83O006D000100120C010200014O0083000300033O0026C30002000F000100010004F83O000F0001002EC20006000B000100050004F83O000B000100120C010300013O002E5E00070045000100070004F83O0055000100263301030055000100080004F83O005500012O009300045O00203B0004000400092O00090104000200020006890004001E000100010004F83O001E00012O0093000400013O0006890004001E000100010004F83O001E0001002E5E000A00370001000B0004F83O0053000100120C010400014O0083000500063O002E5E000C002B0001000C0004F83O004B00010026330104004B000100080004F83O004B00010026330105002C000100080004F83O002C00012O0093000700023O00064A0007005300013O0004F83O005300012O0093000700024O0073000700023O0004F83O0053000100263301050024000100010004F83O0024000100120C010700013O00263301070033000100080004F83O0033000100120C010500083O0004F83O002400010026330107002F000100010004F83O002F00012O0093000800013O0006FE00060041000100080004F83O004100012O0093000800034O0003010900043O00122O000A000D3O00122O000B000E6O0009000B00024O00080008000900202O00080008000F4O0008000200022O0095000600084O0093000800053O0020D30008000800104O000900066O000A000C6O0008000C00024O000800023O00122O000700083O00044O002F00010004F83O002400010004F83O005300010026C30004004F000100010004F83O004F0001002E1D00120020000100110004F83O0020000100120C010500014O0083000600063O00120C010400083O0004F83O0020000100120C2O0100133O0004F83O006D00010026C300030059000100010004F83O00590001002E1D00140010000100150004F83O00100001002EC200160061000100170004F83O006100012O009300045O00203B0004000400182O000901040002000200064A0004006100013O0004F83O006100012O00613O00014O009300045O00203B0004000400192O000901040002000200068900040069000100010004F83O006900010012110004001A4O004C0004000100022O00B7000400063O00120C010300083O0004F83O001000010004F83O006D00010004F83O000B00010026332O01006D0301001B0004F83O006D0301002E1D001D00480601001C0004F83O004806012O0093000200053O00201101020002001E2O004C00020001000200064A0002004806013O0004F83O0048060100120C010200013O00263301020087000100080004F83O008700012O0093000300074O0093000400033O00201101040004001F2O000901030002000200068900030081000100010004F83O00810001002E1D00210048060100200004F83O004806012O0093000300043O001218010400223O00122O000500236O000300056O00035O00044O004806010026C30002008B000100010004F83O008B0001002EC200240077000100250004F83O007700012O009300035O00203B0003000300092O0009010300020002000689000300B7000100010004F83O00B700012O0093000300083O00064A000300B700013O0004F83O00B7000100120C010300014O0083000400053O0026C300030099000100080004F83O00990001002E1D002700AF000100260004F83O00AF000100263301040099000100010004F83O0099000100120C010500013O0026C3000500A0000100010004F83O00A00001002E5E002800FEFF2O00290004F83O009C00012O0093000600094O004C0006000100022O00B7000600024O0093000600023O000689000600A8000100010004F83O00A80001002EC2002B00B70001002A0004F83O00B700012O0093000600024O0073000600023O0004F83O00B700010004F83O009C00010004F83O00B700010004F83O009900010004F83O00B70001002E5E002C00E6FF2O002C0004F83O0095000100263301030095000100010004F83O0095000100120C010400014O0083000500053O00120C010300083O0004F83O009500012O009300035O00203B0003000300092O0009010300020002000689000300BF000100010004F83O00BF00012O0093000300083O00064A0003006A03013O0004F83O006A030100120C010300014O0083000400043O0026C3000300C5000100010004F83O00C50001002E5E002D00FEFF2O002E0004F83O00C1000100120C010400013O002633010400D3000100040004F83O00D300012O00930005000A4O004C0005000100022O00B7000500024O0093000500023O000689000500D0000100010004F83O00D00001002E1D002F006A030100300004F83O006A03012O0093000500024O0073000500023O0004F83O006A0301002E1D003200AA2O0100310004F83O00AA2O01002633010400AA2O0100080004F83O00AA2O0100120C010500013O0026C3000500DC000100080004F83O00DC0001002EC20034003A2O0100330004F83O003A2O012O0093000600034O0003010700043O00122O000800353O00122O000900366O0007000900024O00060006000700202O0006000600374O0006000200022O00AD00075O00202O0007000700384O00070002000200202O00070007000400062O000600F4000100070004F83O00F400012O0093000600034O0052000700043O00122O000800393O00122O0009003A6O0007000900024O00060006000700202O00060006003B4O00060002000200062O0006002E2O0100010004F83O002E2O012O0093000600034O0003000700043O00122O0008003C3O00122O0009003D6O0007000900024O00060006000700202O00060006003E4O00060002000200062O000600082O013O0004F83O00082O012O0093000600034O0052000700043O00122O0008003F3O00122O000900406O0007000900024O00060006000700202O00060006003B4O00060002000200062O0006002E2O0100010004F83O002E2O012O0093000600034O0003000700043O00122O000800413O00122O000900426O0007000900024O00060006000700202O00060006003B4O00060002000200062O0006002E2O013O0004F83O002E2O012O0093000600034O0003000700043O00122O000800433O00122O000900446O0007000900024O00060006000700202O00060006003B4O00060002000200062O0006002E2O013O0004F83O002E2O012O0093000600034O004E000700043O00122O000800453O00122O000900466O0007000900024O00060006000700202O0006000600374O00060002000200262O0006002C2O0100130004F83O002C2O012O009300065O0020B30006000600474O000800033O00202O0008000800484O00060008000200044O002E2O012O006000066O0022000600014O00B70006000B4O00930006000C3O002633010600392O0100490004F83O00392O01002EC2004A00352O01004B0004F83O00352O010004F83O00392O012O00930006000D3O00203B00060006004C2O00090106000200022O00B70006000C3O00120C0105004D3O0026C30005003E2O01004D0004F83O003E2O01002E1D004F00402O01004E0004F83O00402O0100120C0104004D3O0004F83O00AA2O01002633010500D8000100010004F83O00D8000100120C010600013O0026C3000600472O0100080004F83O00472O01002E5E00500004000100510004F83O00492O0100120C010500083O0004F83O00D800010026C30006004D2O0100010004F83O004D2O01002EC2005300432O0100520004F83O00432O012O00930007000E3O00064A000700A52O013O0004F83O00A52O0100120C010700014O0083000800093O002E5E00540007000100540004F83O00592O01002633010700592O0100010004F83O00592O0100120C010800014O0083000900093O00120C010700083O002EC2005500522O0100560004F83O00522O01002633010700522O0100080004F83O00522O010026C3000800612O0100010004F83O00612O01002E1D0057005D2O0100580004F83O005D2O0100120C010900013O002E5E00590016000100590004F83O00782O01002633010900782O0100080004F83O00782O012O0093000A00053O0020EC000A000A005A4O000B00033O00202O000B000B005B4O000C000F3O00202O000C000C005C00122O000D005D6O000E00016O000A000E00024O000A00023O002E2O005F00A52O01005E0004F83O00A52O012O0093000A00023O00064A000A00A52O013O0004F83O00A52O012O0093000A00024O0073000A00023O0004F83O00A52O01002633010900622O0100010004F83O00622O0100120C010A00014O0083000B000B3O000EF0000100802O01000A0004F83O00802O01002E1D0060007C2O0100610004F83O007C2O0100120C010B00013O002E1D006200872O0100630004F83O00872O01002633010B00872O0100080004F83O00872O0100120C010900083O0004F83O00622O010026C3000B008B2O0100010004F83O008B2O01002E1D006400812O0100650004F83O00812O012O0093000C00053O0020C8000C000C005A4O000D00033O00202O000D000D00664O000E000F3O00202O000E000E006700122O000F005D6O001000016O000C001000024O000C00026O000C00023O00062O000C009A2O0100010004F83O009A2O01002E5E00680004000100690004F83O009C2O012O0093000C00024O0073000C00023O00120C010B00083O0004F83O00812O010004F83O00622O010004F83O007C2O010004F83O00622O010004F83O00A52O010004F83O005D2O010004F83O00A52O010004F83O00522O012O002200076O00B7000700103O00120C010600083O0004F83O00432O010004F83O00D80001002633010400A40201004D0004F83O00A4020100120C010500014O0083000600063O002633010500AE2O0100010004F83O00AE2O0100120C010600013O00263301060026020100010004F83O002602012O0093000700113O002633010700F92O01006A0004F83O00F92O012O0093000700083O00064A000700F92O013O0004F83O00F92O012O00930007000D3O00203B00070007004C2O00090107000200022O00930008000C3O00062F010700F92O0100080004F83O00F92O012O0093000700124O00930008000D4O0022000900014O00CE000700090002000689000700F92O0100010004F83O00F92O0100120C010700014O0083000800083O000E56000100C72O0100070004F83O00C72O0100120C010800013O002633010800E32O0100010004F83O00E32O0100120C010900013O002E1D006C00D32O01006B0004F83O00D32O01000E56000800D32O0100090004F83O00D32O0100120C010800083O0004F83O00E32O01000EF0000100D72O0100090004F83O00D72O01002EC2006E00CD2O01006D0004F83O00CD2O012O0093000A00134O004C000A000100022O00B7000A00024O0093000A00023O000689000A00DF2O0100010004F83O00DF2O01002E1D006F00E12O0100700004F83O00E12O012O0093000A00024O0073000A00023O00120C010900083O0004F83O00CD2O010026C3000800E72O0100080004F83O00E72O01002E1D007100CA2O0100720004F83O00CA2O012O0093000900074O0093000A00033O002011010A000A001F2O0009010900020002000689000900EF2O0100010004F83O00EF2O01002E5E0073000E000100740004F83O00FB2O012O0093000900043O001218010A00753O00122O000B00766O0009000B6O00095O00044O00FB2O010004F83O00CA2O010004F83O00FB2O010004F83O00C72O010004F83O00FB2O012O0022000700014O00B7000700114O0093000700143O00068900072O00020100010004F84O000201002EC200770025020100780004F83O002502012O0093000700013O00064A0007002502013O0004F83O0025020100120C010700014O0083000800093O0026330107000A020100010004F83O000A020100120C010800014O0083000900093O00120C010700083O002EC2007900050201007A0004F83O0005020100263301070005020100080004F83O00050201002EC2007B000E0201007C0004F83O000E02010026330108000E020100010004F83O000E020100120C010900013O00263301090013020100010004F83O001302012O0093000A00154O004C000A000100022O00B7000A00023O002EC2007E00250201007D0004F83O002502012O0093000A00023O00064A000A002502013O0004F83O002502012O0093000A00024O0073000A00023O0004F83O002502010004F83O001302010004F83O002502010004F83O000E02010004F83O002502010004F83O0005020100120C010600083O0026C30006002A0201004D0004F83O002A0201002E5E007F0004000100800004F83O002C020100120C010400043O0004F83O00A40201002E1D008100B12O0100820004F83O00B12O01002633010600B12O0100080004F83O00B12O012O0093000700034O0003000800043O00122O000900833O00122O000A00846O0008000A00024O00070007000800202O00070007000F4O00070002000200062O0007006102013O0004F83O006102012O0093000700163O00064A0007006102013O0004F83O006102012O0093000700173O00064A0007006102013O0004F83O006102012O009300075O00203B0007000700852O000901070002000200068900070061020100010004F83O006102012O009300075O00203B0007000700862O000901070002000200068900070061020100010004F83O006102012O0093000700053O0020110107000700872O00930008000D4O000901070002000200064A0007006102013O0004F83O006102012O0093000700074O0055010800033O00202O0008000800884O0009000D3O00202O0009000900894O000B00033O00202O000B000B00884O0009000B00024O000900096O00070009000200062O0007006102013O0004F83O006102012O0093000700043O00120C0108008A3O00120C0109008B4O0043010700094O000C00076O0093000700183O000ED9004D0067020100070004F83O006702012O0093000700193O000E9E000400A0020100070004F83O00A0020100120C010700014O0083000800083O002EC2008C00690201008D0004F83O0069020100263301070069020100010004F83O0069020100120C010800013O002E1D008F007E0201008E0004F83O007E02010026330108007E020100080004F83O007E02012O0093000900074O0093000A00033O002011010A000A001F2O000901090002000200064A000900A002013O0004F83O00A002012O0093000900043O001218010A00903O00122O000B00916O0009000B6O00095O00044O00A002010026C300080082020100010004F83O00820201002EC20093006E020100920004F83O006E020100120C010900014O0083000A000A3O00263301090084020100010004F83O0084020100120C010A00013O0026C3000A008B020100080004F83O008B0201002EC20095008D020100940004F83O008D020100120C010800083O0004F83O006E0201002633010A0087020100010004F83O008702012O0093000B001A4O004C000B000100022O00B7000B00023O002E1D00960099020100970004F83O009902012O0093000B00023O00064A000B009902013O0004F83O009902012O0093000B00024O0073000B00023O00120C010A00083O0004F83O008702010004F83O006E02010004F83O008402010004F83O006E02010004F83O00A002010004F83O0069020100120C0106004D3O0004F83O00B12O010004F83O00A402010004F83O00AE2O01002633010400C6000100010004F83O00C6000100120C010500013O002E1D009800AD020100990004F83O00AD0201002633010500AD0201004D0004F83O00AD020100120C010400083O0004F83O00C60001002E1D009A004F0301009B0004F83O004F03010026330105004F030100080004F83O004F030100120C010600013O000E5600010048030100060004F83O004803012O009300075O00203B0007000700852O0009010700020002000689000700BE020100010004F83O00BE02012O009300075O00203B0007000700862O000901070002000200064A000700C002013O0004F83O00C00201002E1D009C001E0301009D0004F83O001E030100120C010700014O0083000800083O002EC2009F00C20201009E0004F83O00C20201002633010700C2020100010004F83O00C2020100120C010800013O002633010800E3020100010004F83O00E3020100120C010900013O0026C3000900CE020100010004F83O00CE0201002E1D00A000DC020100A10004F83O00DC02012O0093000A00053O00204D010A000A00A24O000B00033O00202O000B000B00A300122O000C005D6O000D00016O000A000D00024O000A00026O000A00023O00062O000A00DB02013O0004F83O00DB02012O0093000A00024O0073000A00023O00120C010900083O002E1D00A500CA020100A40004F83O00CA0201002633010900CA020100080004F83O00CA020100120C010800083O0004F83O00E302010004F83O00CA0201002EC200A600F4020100A70004F83O00F40201002633010800F40201004D0004F83O00F402012O0093000900053O0020B40009000900A84O000A00033O00202O000A000A00A900122O000B00AA6O0009000B00024O000900026O000900023O00062O0009001E03013O0004F83O001E03012O0093000900024O0073000900023O0004F83O001E03010026C3000800F8020100080004F83O00F80201002E1D00AC00C7020100AB0004F83O00C7020100120C010900014O0083000A000A3O002633010900FA020100010004F83O00FA020100120C010A00013O002EC200AE0012030100AD0004F83O00120301002633010A0012030100010004F83O001203012O0093000B00053O002034010B000B00A24O000C00033O00202O000C000C00A300122O000D005D6O000E00016O000F001B6O0010000F3O00202O0010001000AF4O000B001000024O000B00026O000B00023O00062O000B001103013O0004F83O001103012O0093000B00024O0073000B00023O00120C010A00083O0026C3000A0016030100080004F83O00160301002E1D00B000FD020100B10004F83O00FD020100120C0108004D3O0004F83O00C702010004F83O00FD02010004F83O00C702010004F83O00FA02010004F83O00C702010004F83O001E03010004F83O00C202012O00930007001C3O00064A0007004703013O0004F83O0047030100120C010700014O0083000800093O00263301070028030100010004F83O0028030100120C010800014O0083000900093O00120C010700083O00263301070023030100080004F83O00230301000EF00001002E030100080004F83O002E0301002EC200B2002A030100B30004F83O002A030100120C010900013O000E560001002F030100090004F83O002F03012O0093000A00053O002004010A000A00B44O000B00033O00202O000B000B00B54O000C000F3O00202O000C000C00B600122O000D00B76O000A000D00024O000A00023O002E2O00B80047030100B90004F83O004703012O0093000A00023O00064A000A004703013O0004F83O004703012O0093000A00024O0073000A00023O0004F83O004703010004F83O002F03010004F83O004703010004F83O002A03010004F83O004703010004F83O0023030100120C010600083O0026C30006004C030100080004F83O004C0301002EC200BA00B2020100BB0004F83O00B2020100120C0105004D3O0004F83O004F03010004F83O00B202010026C300050053030100010004F83O00530301002EC200BC00A7020100BD0004F83O00A7020100120C010600013O002EC200BE005A030100BF0004F83O005A03010026330106005A030100080004F83O005A030100120C010500083O0004F83O00A7020100263301060054030100010004F83O005403012O00930007001D4O004C0007000100022O00B7000700024O0093000700023O00064A0007006403013O0004F83O006403012O0093000700024O0073000700023O00120C010600083O0004F83O005403010004F83O00A702010004F83O00C600010004F83O006A03010004F83O00C1000100120C010200083O0004F83O007700010004F83O004806010026C300010071030100130004F83O00710301002E5E00C000F52O0100C10004F83O0064050100120C010200014O0083000300033O002EC200C30073030100C20004F83O0073030100263301020073030100010004F83O0073030100120C010300013O000E560001009D040100030004F83O009D0401002E5E00C400FE000100C40004F83O007804012O009300045O00203B0004000400092O000901040002000200068900040078040100010004F83O007804012O0093000400083O00064A0004007804013O0004F83O0078040100120C010400014O0083000500053O0026C30004008A030100010004F83O008A0301002EC200C50086030100C60004F83O0086030100120C010500013O002633010500B50301004D0004F83O00B50301002EC200C70078040100C80004F83O007804012O00930006000D3O00064A0006007804013O0004F83O007804012O00930006000D3O00203B0006000600C92O000901060002000200064A0006007804013O0004F83O007804012O00930006000D3O00203B0006000600CA2O000901060002000200064A0006007804013O0004F83O007804012O00930006000D3O00203B0006000600182O000901060002000200064A0006007804013O0004F83O007804012O009300065O00203B0006000600CB2O00930008000D4O00CE00060008000200068900060078040100010004F83O007804012O0093000600074O004C010700033O00202O0007000700CC4O000800086O000900016O00060009000200062O0006007804013O0004F83O007804012O0093000600043O001218010700CD3O00122O000800CE6O000600086O00065O00044O00780401002E1D00CF0017040100D00004F83O0017040100263301050017040100080004F83O0017040100120C010600013O0026C3000600BE030100010004F83O00BE0301002E1D00D20012040100D10004F83O0012040100120C010700013O0026C3000700C3030100080004F83O00C30301002E5E00D30004000100D40004F83O00C5030100120C010600083O0004F83O001204010026C3000700C9030100010004F83O00C90301002E5E00D500F8FF2O00D60004F83O00BF03012O0093000800034O0003000900043O00122O000A00D73O00122O000B00D86O0009000B00024O00080008000900202O0008000800D94O00080002000200062O000800E203013O0004F83O00E203012O009300085O0020EF0008000800474O000A00033O00202O000A000A00DA4O000B00016O0008000B000200062O000800E4030100010004F83O00E403012O0093000800053O0020E60008000800DB4O000900033O00202O0009000900DA4O00080002000200062O000800E4030100010004F83O00E40301002E1D00DC00EF030100DD0004F83O00EF03012O0093000800074O00930009000F3O0020110109000900DE2O000901080002000200064A000800EF03013O0004F83O00EF03012O0093000800043O00120C010900DF3O00120C010A00E04O00430108000A4O000C00086O0093000800034O0003000900043O00122O000A00E13O00122O000B00E26O0009000B00024O00080008000900202O0008000800D94O00080002000200062O0008000304013O0004F83O000304012O009300085O0020A00008000800474O000A00033O00202O000A000A00E34O0008000A000200062O0008000304013O0004F83O000304012O00930008001E3O00068900080005040100010004F83O00050401002E1D00E40010040100E50004F83O001004012O0093000800074O0093000900033O0020110109000900E62O000901080002000200064A0008001004013O0004F83O001004012O0093000800043O00120C010900E73O00120C010A00E84O00430108000A4O000C00085O00120C010700083O0004F83O00BF0301002633010600BA030100080004F83O00BA030100120C0105004D3O0004F83O001704010004F83O00BA03010026330105008B030100010004F83O008B030100120C010600014O0083000700073O0026330106001B040100010004F83O001B040100120C010700013O0026330107006C040100010004F83O006C04012O0093000800034O0003000900043O00122O000A00E93O00122O000B00EA6O0009000B00024O00080008000900202O0008000800D94O00080002000200062O0008004904013O0004F83O004904012O00930008001F3O00064A0008004904013O0004F83O004904012O009300085O0020EF0008000800474O000A00033O00202O000A000A00DA4O000B00016O0008000B000200062O0008003C040100010004F83O003C04012O0093000800053O00204D0008000800DB4O000900033O00202O0009000900DA4O00080002000200062O0008004904013O0004F83O00490401002E1D00EB0049040100EC0004F83O004904012O0093000800074O00930009000F3O0020110109000900DE2O000901080002000200064A0008004904013O0004F83O004904012O0093000800043O00120C010900ED3O00120C010A00EE4O00430108000A4O000C00085O002E1D00F0006B040100EF0004F83O006B04012O00930008001C3O00064A0008006B04013O0004F83O006B040100120C010800014O0083000900093O000EF000010054040100080004F83O00540401002E1D00F10050040100170004F83O0050040100120C010900013O00263301090055040100010004F83O005504012O0093000A00053O002064000A000A00B44O000B00033O00202O000B000B00B54O000C000F3O00202O000C000C00B600122O000D00B76O000A000D00024O000A00023O002E2O00F2006B040100F30004F83O006B04012O0093000A00023O00064A000A006B04013O0004F83O006B04012O0093000A00024O0073000A00023O0004F83O006B04010004F83O005504010004F83O006B04010004F83O0050040100120C010700083O002E1D00F4001E040100F50004F83O001E04010026330107001E040100080004F83O001E040100120C010500083O0004F83O008B03010004F83O001E04010004F83O008B03010004F83O001B04010004F83O008B03010004F83O007804010004F83O008603012O009300045O00203B0004000400192O000901040002000200064A0004008504013O0004F83O008504012O009300045O00203B0004000400092O000901040002000200068900040087040100010004F83O008704012O0093000400083O00068900040087040100010004F83O00870401002E5E00F60017000100F70004F83O009C040100120C010400014O0083000500053O002EC200F90089040100F80004F83O00890401000E5600010089040100040004F83O0089040100120C010500013O0026330105008E040100010004F83O008E04012O0093000600204O004C0006000100022O00B7000600024O0093000600023O00064A0006009C04013O0004F83O009C04012O0093000600024O0073000600023O0004F83O009C04010004F83O008E04010004F83O009C04010004F83O0089040100120C010300083O000EF0000800A1040100030004F83O00A10401002E1D00FA0078030100FB0004F83O007803012O0093000400053O00201101040004001E2O004C000400010002000689000400AD040100010004F83O00AD04012O009300045O00203B0004000400092O0009010400020002000689000400AD040100010004F83O00AD0401002E5E00FC00B4000100FD0004F83O005F050100120C010400014O0083000500063O002633010400B4040100010004F83O00B4040100120C010500014O0083000600063O00120C010400083O0026C3000400B8040100080004F83O00B80401002E1D00FF00AF040100FE0004F83O00AF04010026C3000500BD040100010004F83O00BD040100120C0107002O012O000E2D2O0001B8040100070004F83O00B8040100120C010600013O00120C010700043O00062F010600E8040100070004F83O00E804012O009300075O00122001090002015O0007000700094O000900033O00122O000A0003015O00090009000A4O00070009000200062O000700D204013O0004F83O00D204012O0093000700034O001C000800043O00122O00090004012O00122O000A0005015O0008000A00024O000700070008000689000700D8040100010004F83O00D804012O0093000700034O001C000800043O00122O00090006012O00122O000A0007015O0008000A00024O0007000700082O00B7000700214O0040010700236O00085O00202O0008000800384O00080002000200122O00090008015O0007000900024O000800246O00095O00202O0009000900384O00090002000200120C010A0008013O00CE0008000A00022O00780007000700082O00B7000700223O0004F83O005F050100120C0107004D3O00062F01060008050100070004F83O0008050100120C010700013O00120C010800013O00062F010700FE040100080004F83O00FE04012O0093000800263O00120D010A0009015O00080008000A4O00080002000200122O0009000A015O0008000900084O000800256O000800253O00122O000900013O00062O000900FB040100080004F83O00FB04010004F83O00FD040100120C010800014O00B7000800253O00120C010700083O00120C010800083O0006E20008002O050100070004F83O002O050100120C0108000B012O00120C0109000C012O0006C1000800EC040100090004F83O00EC040100120C010600043O0004F83O000805010004F83O00EC040100120C0107000D012O00120C0108000E012O00064B0008004D050100070004F83O004D050100120C010700083O00062F0106004D050100070004F83O004D050100120C010700013O00120C010800013O0006E200080017050100070004F83O0017050100120C0108000F012O00120C01090010012O0006C100090043050100080004F83O0043050100120C010800013O00120C010900013O0006E20008001F050100090004F83O001F050100120C01090011012O00120C010A0012012O0006C1000900390501000A0004F83O003905012O0093000900273O00120C010A0013012O0006E2000900270501000A0004F83O0027050100120C01090014012O00120C010A0015012O00064B0009002E0501000A0004F83O002E05012O0093000900283O001257010A0016015O00090009000A4O000A00296O000B8O0009000B00024O000900274O0093000900263O0012F2000B0009015O00090009000B4O00090002000200122O000A000A012O00062O000900020001000A0004F83O003605012O006000096O0022000900014O00B70009002A3O00120C010800083O00120C010900083O0006E200080040050100090004F83O0040050100120C01090017012O00120C010A0018012O00064B000A0018050100090004F83O0018050100120C010700083O0004F83O004305010004F83O0018050100120C010800083O0006E20007004A050100080004F83O004A050100120C01080019012O00120C0109001A012O00064B00080010050100090004F83O0010050100120C0106004D3O0004F83O004D05010004F83O0010050100120C010700013O00062F010600BE040100070004F83O00BE04012O0093000700283O00125C0008001B015O0007000700084O000800086O000900016O0007000900024O0007002B6O0007002B6O000700273O00122O000600083O00044O00BE04010004F83O005F05010004F83O00B804010004F83O005F05010004F83O00AF040100120C2O01001B3O0004F83O006405010004F83O007803010004F83O006405010004F83O0073030100120C0102004D3O00062F2O0100C1050100020004F83O00C1050100120C010200013O00120C010300083O0006E20002006F050100030004F83O006F050100120C0103001C012O00120C0104001D012O00064B000400AC050100030004F83O00AC05010012110003001E012O00068900030076050100010004F83O0076050100120C0103001F012O00120C01040020012O0006C100040091050100030004F83O0091050100120C010300014O0083000400043O00120C010500013O00062F01030078050100050004F83O0078050100120C010400013O00120C01050021012O00120C01060022012O0006C10005007C050100060004F83O007C050100120C010500013O00062F0104007C050100050004F83O007C05012O00930005002C4O0049000500056O000500196O0005000D3O00122O00070023015O00050005000700122O00070024015O0005000700024O000500183O00044O00AA05010004F83O007C05010004F83O00AA05010004F83O007805010004F83O00AA050100120C010300014O0083000400043O00120C010500013O0006E20003009A050100050004F83O009A050100120C01050025012O00120C01060026012O00062F01050093050100060004F83O0093050100120C010400013O00120C010500013O0006E2000400A2050100050004F83O00A2050100120C01050027012O00120C01060028012O0006C10006009B050100050004F83O009B050100120C010500084O00B7000500193O00120C010500084O00B7000500183O0004F83O00AA05010004F83O009B05010004F83O00AA05010004F83O0093050100120C2O0100043O0004F83O00C1050100120C010300013O0006E2000200B3050100030004F83O00B3050100120C01030029012O00120C0104002A012O00062F01030068050100040004F83O006805012O009300035O0012100105002B015O00030003000500122O000500B76O0003000500024O0003002D6O0003000D3O00122O0005002C015O00030003000500122O00050024015O0003000500022O00B7000300293O00120C010200083O0004F83O0068050100120C010200013O0006E2000100C8050100020004F83O00C8050100120C0102002D012O00120C010300BD3O0006C100030003060100020004F83O0003060100120C010200013O00120C010300083O0006E2000200D0050100030004F83O00D0050100120C0103002E012O00120C0104002F012O00064B000300DE050100040004F83O00DE050100121100030030013O001C000400043O00122O00050031012O00122O00060032015O0004000600024O0003000300042O001C000400043O00122O00050033012O00122O00060034015O0004000600024O0003000300042O00B70003002E3O00120C2O0100083O0004F83O0003060100120C01030035012O00120C01040036012O0006C1000400C9050100030004F83O00C9050100120C010300013O00062F010200C9050100030004F83O00C9050100120C010300013O00120C010400083O00062F010300EB050100040004F83O00EB050100120C010200083O0004F83O00C9050100120C010400013O0006E2000300F2050100040004F83O00F2050100120C01040037012O00120C010500253O0006C1000400E6050100050004F83O00E605012O00930004002F4O003E00040001000100121100040030013O001C000500043O00122O00060038012O00122O00070039015O0005000700024O0004000400052O001C000500043O00122O0006003A012O00122O0007003B015O0005000700024O0004000400052O00B7000400083O00120C010300083O0004F83O00E605010004F83O00C9050100120C0102003C012O00120C0103003D012O0006C100020005000100030004F83O0005000100120C010200083O00062F2O010005000100020004F83O0005000100120C010200013O00120C0103003E012O00120C0104003F012O00064B0004001A060100030004F83O001A060100120C010300083O00062F0102001A060100030004F83O001A06012O009300035O0012C90005002B015O00030003000500122O0005005D6O0003000500024O0003002C3O00122O0001004D3O00044O0005000100120C010300013O00062F0102000B060100030004F83O000B060100120C010300013O00120C010400013O00062F0103003A060100040004F83O003A060100121100040030013O0031010500043O00122O00060040012O00122O00070041015O0005000700024O0004000400054O000500043O00122O00060042012O00122O00070043015O0005000700024O0004000400054O000400163O00122O00040030015O000500043O00122O00060044012O00122O00070045015O0005000700024O0004000400054O000500043O00122O00060046012O00122O00070047015O0005000700024O0004000400054O000400303O00122O000300083O00120C010400083O0006E200030041060100040004F83O0041060100120C01040048012O00120C01050049012O0006C10005001E060100040004F83O001E060100120C010200083O0004F83O000B06010004F83O001E06010004F83O000B06010004F83O000500010004F83O004806010004F83O000200012O00613O00017O00143O00028O00025O006AA040026O00F03F025O00D6AA40025O0019B140025O00709440025O007FB040025O00A6A04003133O0034AB8BC221C90BA9B2DD3DD80A8E83D03DDD0403063O00BB62CAE6B24803143O00526567697374657241757261547261636B696E67025O00B8AC40025O00C8A14003053O005072696E74031B3O0012E9A5344536A194224324F2B0704838A181204322A1863F452CCA03053O002A4181C450030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03223O0031425CDE181042DE104358C903473AAE140A0C8A59554CBE520A7FC357250DE10F6103083O008E622A3DBA77676200423O00120C012O00014O0083000100023O002E5E00020007000100020004F83O00090001002633012O0009000100010004F83O0009000100120C2O0100014O0083000200023O00120C012O00033O002633012O0002000100030004F83O00020001002E5E00043O000100040004F83O000B00010026332O01000B000100010004F83O000B000100120C010200013O000E5600010029000100020004F83O0029000100120C010300013O002E1D00060019000100050004F83O0019000100263301030019000100030004F83O0019000100120C010200033O0004F83O00290001002E1D00080013000100070004F83O0013000100263301030013000100010004F83O001300012O009300046O00070104000100014O000400016O000500023O00122O000600093O00122O0007000A6O0005000700024O00040004000500202O00040004000B4O00040002000100122O000300033O00044O00130001002E1D000D00100001000C0004F83O0010000100263301020010000100030004F83O001000012O0093000300033O00201201030003000E4O000400023O00122O0005000F3O00122O000600106O000400066O00033O000100122O000300113O00202O0003000300124O000400023O00122O000500133O00122O000600146O000400066O00033O000100044O004100010004F83O001000010004F83O004100010004F83O000B00010004F83O004100010004F83O000200012O00613O00017O00", GetFEnv(), ...);

