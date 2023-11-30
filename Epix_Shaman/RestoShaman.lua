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
				if (Enum <= 135) then
					if (Enum <= 67) then
						if (Enum <= 33) then
							if (Enum <= 16) then
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
												Stk[Inst[2]] = #Stk[Inst[3]];
											end
										elseif (Enum == 2) then
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
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
									elseif (Enum <= 5) then
										if (Enum == 4) then
											local A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
									elseif (Enum > 6) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 11) then
									if (Enum <= 9) then
										if (Enum > 8) then
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
									elseif (Enum > 10) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
									if (Enum > 12) then
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
									elseif (Inst[2] == Inst[4]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum <= 14) then
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
										if (Mvm[1] == 234) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								elseif (Enum > 15) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
									VIP = VIP + 1;
								end
							elseif (Enum <= 24) then
								if (Enum <= 20) then
									if (Enum <= 18) then
										if (Enum == 17) then
											local B;
											local A;
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
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
									elseif (Enum == 19) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum <= 22) then
									if (Enum > 21) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 23) then
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
							elseif (Enum <= 28) then
								if (Enum <= 26) then
									if (Enum == 25) then
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
										if (Inst[2] <= Inst[4]) then
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
								elseif (Enum == 27) then
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
								elseif (Inst[2] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 30) then
								if (Enum > 29) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								end
							elseif (Enum <= 31) then
								Stk[Inst[2]] = Stk[Inst[3]] % Inst[4];
							elseif (Enum == 32) then
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
							end
						elseif (Enum <= 50) then
							if (Enum <= 41) then
								if (Enum <= 37) then
									if (Enum <= 35) then
										if (Enum > 34) then
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
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
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
									elseif (Enum > 36) then
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
										Upvalues[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 39) then
									if (Enum > 38) then
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
								elseif (Enum > 40) then
									if (Stk[Inst[2]] == Inst[4]) then
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
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
									end
								end
							elseif (Enum <= 45) then
								if (Enum <= 43) then
									if (Enum > 42) then
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
										local A = Inst[2];
										local B = Inst[3];
										for Idx = A, B do
											Stk[Idx] = Vararg[Idx - A];
										end
									end
								elseif (Enum > 44) then
									if (Stk[Inst[2]] < Inst[4]) then
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
							elseif (Enum <= 47) then
								if (Enum > 46) then
									if (Inst[2] < Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
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
									Stk[Inst[2]] = Inst[3] ~= 0;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Upvalues[Inst[3]] = Stk[Inst[2]];
								end
							elseif (Enum <= 48) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Enum > 49) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							elseif (Stk[Inst[2]] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 58) then
							if (Enum <= 54) then
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
								elseif (Enum > 53) then
									do
										return;
									end
								elseif (Inst[2] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 56) then
								if (Enum > 55) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum > 57) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 62) then
							if (Enum <= 60) then
								if (Enum > 59) then
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
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
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
							elseif (Enum > 61) then
								Stk[Inst[2]] = {};
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
						elseif (Enum <= 64) then
							if (Enum > 63) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 65) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							VIP = Inst[3];
						elseif (Enum > 66) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 101) then
						if (Enum <= 84) then
							if (Enum <= 75) then
								if (Enum <= 71) then
									if (Enum <= 69) then
										if (Enum > 68) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
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
										elseif (Inst[2] < Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 70) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
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
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 73) then
									if (Enum == 72) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
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
										VIP = Inst[3];
									end
								elseif (Enum > 74) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
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
							elseif (Enum <= 79) then
								if (Enum <= 77) then
									if (Enum == 76) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum > 78) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 81) then
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
								if (Stk[Inst[2]] == Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum == 83) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
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
						elseif (Enum <= 92) then
							if (Enum <= 88) then
								if (Enum <= 86) then
									if (Enum == 85) then
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
								elseif (Enum == 87) then
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
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 90) then
								if (Enum == 89) then
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
							elseif (Enum == 91) then
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
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 96) then
							if (Enum <= 94) then
								if (Enum > 93) then
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
								else
									do
										return Stk[Inst[2]];
									end
								end
							elseif (Enum == 95) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 100) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 118) then
						if (Enum <= 109) then
							if (Enum <= 105) then
								if (Enum <= 103) then
									if (Enum > 102) then
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
										if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum == 104) then
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
									local A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
								end
							elseif (Enum <= 107) then
								if (Enum == 106) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
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
								elseif (Inst[2] < Stk[Inst[4]]) then
									VIP = Inst[3];
								else
									VIP = VIP + 1;
								end
							elseif (Enum == 108) then
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
						elseif (Enum <= 113) then
							if (Enum <= 111) then
								if (Enum == 110) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									Stk[Inst[2]] = Stk[Inst[3]] % Stk[Inst[4]];
								end
							elseif (Enum > 112) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
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
							end
						elseif (Enum <= 115) then
							if (Enum > 114) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 116) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						elseif (Enum == 117) then
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
					elseif (Enum <= 126) then
						if (Enum <= 122) then
							if (Enum <= 120) then
								if (Enum > 119) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
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
						elseif (Enum <= 124) then
							if (Enum == 123) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
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
							end
						elseif (Enum > 125) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
					elseif (Enum <= 130) then
						if (Enum <= 128) then
							if (Enum > 127) then
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
						elseif (Enum == 129) then
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
					elseif (Enum <= 132) then
						if (Enum == 131) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 133) then
						if (Stk[Inst[2]] < Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 134) then
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
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
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
				elseif (Enum <= 203) then
					if (Enum <= 169) then
						if (Enum <= 152) then
							if (Enum <= 143) then
								if (Enum <= 139) then
									if (Enum <= 137) then
										if (Enum == 136) then
											if (Stk[Inst[2]] > Stk[Inst[4]]) then
												VIP = VIP + 1;
											else
												VIP = VIP + Inst[3];
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
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
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
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum == 138) then
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
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
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
								elseif (Enum <= 141) then
									if (Enum == 140) then
										local A = Inst[2];
										do
											return Stk[A](Unpack(Stk, A + 1, Top));
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
								elseif (Enum == 142) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
								if (Enum <= 145) then
									if (Enum > 144) then
										local B;
										local A;
										Stk[Inst[2]] = Upvalues[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
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
								elseif (Enum == 146) then
									local A = Inst[2];
									local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Top)));
									Top = (Limit + A) - 1;
									local Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum <= 149) then
								if (Enum == 148) then
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
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum <= 150) then
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							elseif (Enum == 151) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 160) then
							if (Enum <= 156) then
								if (Enum <= 154) then
									if (Enum > 153) then
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
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
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
									end
								elseif (Enum > 155) then
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
							elseif (Enum <= 158) then
								if (Enum == 157) then
									if (Inst[2] <= Inst[4]) then
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
							elseif (Enum > 159) then
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
						elseif (Enum <= 164) then
							if (Enum <= 162) then
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
							elseif (Enum == 163) then
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
						elseif (Enum <= 166) then
							if (Enum > 165) then
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
								local B = Stk[Inst[4]];
								if B then
									VIP = VIP + 1;
								else
									Stk[Inst[2]] = B;
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 167) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 186) then
						if (Enum <= 177) then
							if (Enum <= 173) then
								if (Enum <= 171) then
									if (Enum == 170) then
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
								elseif (Enum == 172) then
									Env[Inst[3]] = Stk[Inst[2]];
								else
									Stk[Inst[2]] = Inst[3] ~= 0;
								end
							elseif (Enum <= 175) then
								if (Enum > 174) then
									Stk[Inst[2]] = Stk[Inst[3]] + Inst[4];
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
							elseif (Enum > 176) then
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
						elseif (Enum <= 181) then
							if (Enum <= 179) then
								if (Enum > 178) then
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
							elseif (Enum > 180) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 183) then
							if (Enum == 182) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
							end
						elseif (Enum <= 184) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 185) then
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
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							elseif (Enum == 189) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 192) then
							if (Enum > 191) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								if (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 193) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 198) then
						if (Enum <= 196) then
							if (Enum == 195) then
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
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
						elseif (Enum > 197) then
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
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
					elseif (Enum <= 200) then
						if (Enum > 199) then
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
							do
								return Stk[Inst[2]]();
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
						if Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 202) then
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
				elseif (Enum <= 237) then
					if (Enum <= 220) then
						if (Enum <= 211) then
							if (Enum <= 207) then
								if (Enum <= 205) then
									if (Enum == 204) then
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
								elseif (Enum > 206) then
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
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
								end
							elseif (Enum <= 209) then
								if (Enum > 208) then
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
									if ((Inst[3] == "_ENV") or (Inst[3] == "getfenv")) then
										Stk[Inst[2]] = Env;
									else
										Stk[Inst[2]] = Env[Inst[3]];
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
							elseif (Enum > 210) then
								local A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
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
						elseif (Enum <= 215) then
							if (Enum <= 213) then
								if (Enum == 212) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 214) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 217) then
							if (Enum == 216) then
								local B;
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
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
						elseif (Enum <= 218) then
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
						elseif (Enum > 219) then
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
					elseif (Enum <= 228) then
						if (Enum <= 224) then
							if (Enum <= 222) then
								if (Enum == 221) then
									local A = Inst[2];
									Stk[A] = Stk[A]();
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
							elseif (Enum > 223) then
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
								Stk[Inst[2]] = Inst[3];
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
							if (Enum == 225) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum > 227) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
							Env[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Inst[2] <= Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						end
					elseif (Enum <= 232) then
						if (Enum <= 230) then
							if (Enum > 229) then
								local A;
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
							end
						elseif (Enum == 231) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum <= 234) then
						if (Enum == 233) then
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
							Stk[Inst[2]] = Stk[Inst[3]];
						end
					elseif (Enum <= 235) then
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
					elseif (Enum > 236) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
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
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
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
				elseif (Enum <= 254) then
					if (Enum <= 245) then
						if (Enum <= 241) then
							if (Enum <= 239) then
								if (Enum == 238) then
									local B;
									local A;
									Stk[Inst[2]] = Upvalues[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
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
							elseif (Enum == 240) then
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
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum <= 243) then
							if (Enum == 242) then
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
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
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
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum == 244) then
							local B;
							local A;
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
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
						if (Enum <= 247) then
							if (Enum > 246) then
								Stk[Inst[2]] = Inst[3];
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
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if (Stk[Inst[2]] ~= Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum > 248) then
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
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Upvalues[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
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
					elseif (Enum <= 251) then
						if (Enum > 250) then
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
							Stk[Inst[2]] = #Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if (Stk[Inst[2]] < Inst[4]) then
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						else
							Stk[Inst[2]][Stk[Inst[3]]] = Stk[Inst[4]];
						end
					elseif (Enum <= 252) then
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
					elseif (Enum > 253) then
						local B;
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
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
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
				elseif (Enum <= 263) then
					if (Enum <= 258) then
						if (Enum <= 256) then
							if (Enum == 255) then
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
								Stk[Inst[2]] = Inst[3];
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
						elseif (Enum == 257) then
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
							Upvalues[Inst[3]] = Stk[Inst[2]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
						end
					elseif (Enum <= 260) then
						if (Enum == 259) then
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
					elseif (Enum <= 261) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					elseif (Enum > 262) then
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
					elseif (Stk[Inst[2]] ~= Inst[4]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 267) then
					if (Enum <= 265) then
						if (Enum == 264) then
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
							do
								return Unpack(Stk, A, A + Inst[3]);
							end
						end
					elseif (Enum > 266) then
						local B;
						local A;
						A = Inst[2];
						B = Stk[Inst[3]];
						Stk[A + 1] = B;
						Stk[A] = B[Inst[4]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
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
					end
				elseif (Enum <= 269) then
					if (Enum > 268) then
						local A;
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
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
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					end
				elseif (Enum <= 270) then
					local B;
					local A;
					Stk[Inst[2]] = Upvalues[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]][Stk[Inst[4]]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A] = Stk[A](Stk[A + 1]);
					VIP = VIP + 1;
					Inst = Instr[VIP];
					if Stk[Inst[2]] then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum > 271) then
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
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
VMCall("LOL!113O0003063O00737472696E6703043O006368617203043O00627974652O033O0073756203053O0062697433322O033O0062697403043O0062786F7203053O007461626C6503063O00636F6E63617403063O00696E736572742O033O00626F7203043O0062616E6403073O0072657175697265031B3O00F4D3D23DD988CF1FDCC2D51AD4BED40ADEF0D324EBBAC950DDD6DA03083O007EB1A3BB4586DBA7031B3O001D2EEAE2D6D9DBB0353FEDC5DBEFC0A5370DEBFBE4EBDDFF342BE203083O00D1585E839A898AB3002C3O0012543O00013O00206O000200122O000100013O00202O00010001000300122O000200013O00202O00020002000400122O000300053O00062O0003000A000100010004493O000A0001001259000300063O002078000400030007001259000500083O002078000500050009001259000600083O00207800060006000A00060E00073O000100062O00EA3O00064O00EA8O00EA3O00044O00EA3O00014O00EA3O00024O00EA3O00053O00207800080003000B00207800090003000C2O003E000A5O001259000B000D3O00060E000C0001000100022O00EA3O000A4O00EA3O000B4O00EA000D00073O0012F7000E000E3O0012F7000F000F4O0042000D000F000200060E000E0002000100012O00EA3O00074O0027000A000D000E4O000D00073O00122O000E00103O00122O000F00116O000D000F00024O000D000A000D4O000D00016O000D9O0000013O00033O00023O00026O00F03F026O00704002264O00DC00025O00122O000300016O00045O00122O000500013O00042O0003002100012O00E500076O00D0000800026O000900016O000A00026O000B00036O000C00046O000D8O000E00063O00202O000F000600014O000C000F6O000B3O00024O000C00036O000D00046O000E00016O000F00016O000F0006000F00102O000F0001000F4O001000016O00100006001000102O00100001001000202O0010001000014O000D00106O000C8O000A3O000200202O000A000A00024O0009000A6O00073O00010004680003000500012O00E5000300054O00EA000400024O009B000300044O00B300036O00363O00017O00163O00028O00026O00F03F025O0014AB40025O00A8B140025O00B88D40025O000C9040025O00649540025O0094A140025O00488D40025O0094AD40025O00288C40025O007AB040025O00ABB240025O009EAF40025O00A4AF40025O00749540025O00349040025O0026B140025O00FC9540025O00FC9D40025O00BCA340025O00D49A4001603O0012F7000200014O00C3000300053O00260601020006000100020004493O00060001002E4400040057000100030004493O005700012O00C3000500053O00262900030018000100010004493O001800010012F7000600013O0026060106000E000100020004493O000E0001002E9D00060010000100050004493O001000010012F7000300023O0004493O0018000100260601060014000100010004493O00140001002E440008000A000100070004493O000A00010012F7000400014O00C3000500053O0012F7000600023O0004493O000A000100262900030007000100020004493O000700010012F7000600013O0026290006001B000100010004493O001B000100260601040021000100020004493O00210001002E44000A0025000100090004493O002500012O00EA000700054O00B100086O008C00076O00B300075O000E1C0001001A000100040004493O001A00010012F7000700014O00C3000800083O0026060107002D000100010004493O002D0001002E44000C00290001000B0004493O002900010012F7000800013O002E44000E00340001000D0004493O0034000100262900080034000100020004493O003400010012F7000400023O0004493O001A0001002E440010002E0001000F0004493O002E0001000E1C0001002E000100080004493O002E00010012F7000900013O0026060109003D000100020004493O003D0001002E440012003F000100110004493O003F00010012F7000800023O0004493O002E0001002E9D00130039000100140004493O0039000100262900090039000100010004493O003900012O00E5000A6O001D0005000A3O00067D0005004C000100010004493O004C00012O00E5000A00014O00EA000B6O00B1000C6O008C000A6O00B3000A5O0012F7000900023O0004493O003900010004493O002E00010004493O001A00010004493O002900010004493O001A00010004493O001B00010004493O001A00010004493O005F00010004493O000700010004493O005F0001002E9D00160002000100150004493O0002000100262900020002000100010004493O000200010012F7000300014O00C3000400043O0012F7000200023O0004493O000200012O00363O00017O00483O0003073O00457069634442432O033O0007EF0903053O009C43AD4AA503073O00457069634C696203093O0045706963436163686503043O0001B9400203073O002654D72976DC4603063O00601A230BFB4203053O009E307642722O033O009B210403073O009BCB44705613C503063O0072DC24FB456C03083O009826BD569C20188503053O00DA58A453EF03043O00269C37C703053O009B6D79241F03083O0023C81D1C4873149A030A3O0034AADDCB841F241CB3DD03073O005479DFB1BFED4C03043O009242CCAD03083O00A1DB36A9C05A305003053O007C5609295A03043O004529226003043O009FC2C41E03063O004BDCA3B76A6203053O0032A88E24CA03053O00B962DAEB5703053O00E63D24F4D103063O00CAAB5C4786BE03073O000ACE218526CF3F03043O00E849A14C03083O009ECF474F07B4D74703053O007EDBB9223D2O033O0002DB5303083O00876CAE3E121E179303073O0095E627C617A02003083O00A7D6894AAB78CE5303083O00AEE6374FE1A885F503063O00C7EB90523D9803043O000519B62703043O004B6776D903043O006D6174682O033O00CA5D7E03063O007EA7341074D9024O0080B3C54003103O005265676973746572466F724576656E7403143O00F80201B9912BC3FA0B07A59A26D9E60F02AC913D03073O009CA84E40E0D47903063O0034E6A4C306E003043O00AE678EC5030B3O00642D4C2C2A4CF94221503603073O009836483F58453E03063O00E7CCEF51D5CA03043O003CB4A48E030B3O006A5B163D28FF134C570A2703073O0072383E6549478D03063O008BE1DAC9B9E703043O00A4D889BB030B3O00E0E322A6A9EC0AC6EF3EBC03073O006BB28651D2C69E03073O001B018FCBA5361D03053O00CA586EE2A603083O00E61987E5D3CC018703053O00AAA36FE29703073O00323FBF3541393A03073O00497150D2582E5703063O00B224CC1FE68F03053O0087E14CAD7203243O00AD266B6FD264DFBC297E7FC173DFBF357A65CD60CCA53F7E72CD6ECEB3267767CA66C5A803073O0080EC653F26842103063O0053657441504C025O0080704000AB013O0061000100033O00122O000300016O00045O00122O000500023O00122O000600036O0004000600024O00030003000400122O000400043O00122O000500056O00065O00122O000700063O00122O000800076O0006000800024O0006000400064O00075O00122O000800083O00122O000900096O0007000900024O0007000600074O00085O00122O0009000A3O00122O000A000B6O0008000A00024O0008000600084O00095O00122O000A000C3O00122O000B000D6O0009000B00024O0009000600094O000A5O00122O000B000E3O00122O000C000F6O000A000C00024O000A0006000A4O000B5O00122O000C00103O00122O000D00116O000B000D00024O000B0004000B4O000C5O00122O000D00123O00122O000E00136O000C000E00024O000C0004000C4O000D5O00122O000E00143O00122O000F00156O000D000F00024O000D0004000D4O000E5O00122O000F00163O00122O001000176O000E001000024O000E0004000E00122O000F00046O00105O00122O001100183O00122O001200196O0010001200024O0010000F00104O00115O00122O0012001A3O00122O0013001B6O0011001300024O0011000F00114O00125O00122O0013001C3O00122O0014001D6O0012001400024O0012000F00124O00135O00122O0014001E3O00122O0015001F6O0013001500024O0013000F00134O00145O00122O001500203O00122O001600216O0014001600024O0013001300142O001500145O00122O001500223O00122O001600236O0014001600024O0013001300144O00145O00122O001500243O00122O001600256O0014001600024O0014000F00142O001500155O00122O001600263O00122O001700276O0015001700024O0014001400154O00155O00122O001600283O00122O001700296O0015001700024O0014001400150012590015002A4O00E500165O0012B40017002B3O00122O0018002C6O0016001800024O0015001500164O00168O00178O00188O00198O001A8O001B00623O0012F70063002D3O0012F70064002D3O00209300650004002E00060E00673O000100022O00EA3O00634O00EA3O00644O00CC00685O00122O0069002F3O00122O006A00306O0068006A6O00653O00012O001500655O00122O006600313O00122O006700326O0065006700024O0065000B00654O00665O00122O006700333O00122O006800346O0066006800024O0065006500662O001500665O00122O006700353O00122O006800366O0066006800024O0066001200664O00675O00122O006800373O00122O006900386O0067006900024O0066006600672O001500675O00122O006800393O00122O0069003A6O0067006900024O0067000D00674O00685O00122O0069003B3O00122O006A003C6O0068006A00024O0067006700682O003E00686O001500695O00122O006A003D3O00122O006B003E6O0069006B00024O0069000F00694O006A5O00122O006B003F3O00122O006C00406O006A006C00024O00690069006A2O0015006A5O00122O006B00413O00122O006C00426O006A006C00024O006A000F006A4O006B5O00122O006C00433O00122O006D00446O006B006D00024O006A006A006B00060E006B0001000100042O00EA3O00654O00E58O00EA3O00694O00EA3O000E3O002093006C0004002E00060E006E0002000100012O00EA3O006B4O00CC006F5O00122O007000453O00122O007100466O006F00716O006C3O000100060E006C0003000100022O00EA3O00654O00EA3O00643O00060E006D0004000100112O00EA3O005B4O00EA3O00654O00E58O00EA3O00074O00EA3O005C4O00EA3O00114O00EA3O005D4O00EA3O005E4O00EA3O00694O00EA3O005F4O00EA3O00674O00EA3O001C4O00EA3O001D4O00EA3O00664O00EA3O001E4O00EA3O001F4O00EA3O00203O00060E006E0005000100052O00EA3O00694O00EA3O00654O00EA3O00664O00EA3O00214O00EA3O00223O00060E006F0006000100202O00EA3O00594O00EA3O00074O00EA3O005A4O00EA3O00654O00E58O00EA3O00114O00EA3O001B4O00EA3O00284O00EA3O000A4O00EA3O00694O00EA3O00664O00EA3O00294O00EA3O002A4O00EA3O002B4O00EA3O003F4O00EA3O00404O00EA3O003E4O00EA3O00094O00EA3O00684O00EA3O00174O00EA3O00414O00EA3O00424O00EA3O00434O00EA3O004B4O00EA3O004C4O00EA3O004A4O00EA3O00534O00EA3O00544O00EA3O00554O00EA3O00564O00EA3O00574O00EA3O00583O00060E00700007000100262O00EA3O00694O00EA3O00454O00EA3O00464O00EA3O00654O00E58O00EA3O00444O00EA3O00114O00EA3O00664O00EA3O00074O00EA3O00094O00EA3O00484O00EA3O00494O00EA3O00474O00EA3O004D4O00EA3O004E4O00EA3O004F4O00EA3O00504O00EA3O00514O00EA3O00524O00EA3O00354O00EA3O00364O00EA3O00374O00EA3O00384O00EA3O00394O00EA3O003A4O00EA3O003B4O00EA3O003C4O00EA3O003D4O00EA3O00304O00EA3O000A4O00EA3O00314O00EA3O00324O00EA3O00334O00EA3O00344O00EA3O00284O00EA3O00294O00EA3O002A4O00EA3O002B3O00060E007100080001000F2O00EA3O00694O00EA3O00654O00E58O00EA3O00074O00EA3O00114O00EA3O002E4O00EA3O000A4O00EA3O002F4O00EA3O00664O00EA3O00284O00EA3O00294O00EA3O002A4O00EA3O002B4O00EA3O002C4O00EA3O002D3O00060E00720009000100072O00EA3O00654O00E58O00EA3O00114O00EA3O00074O00EA3O00694O00EA3O006C4O00EA3O00093O00060E0073000A000100332O00EA3O00284O00E58O00EA3O00294O00EA3O002A4O00EA3O002B4O00EA3O003E4O00EA3O003F4O00EA3O003C4O00EA3O003D4O00EA3O00324O00EA3O00334O00EA3O00304O00EA3O00314O00EA3O00384O00EA3O00394O00EA3O003A4O00EA3O003B4O00EA3O00444O00EA3O00454O00EA3O00464O00EA3O00474O00EA3O00204O00EA3O00214O00EA3O00224O00EA3O00234O00EA3O00344O00EA3O00354O00EA3O00364O00EA3O00374O00EA3O00264O00EA3O00274O00EA3O00244O00EA3O00254O00EA3O004A4O00EA3O004B4O00EA3O00484O00EA3O00494O00EA3O002C4O00EA3O002D4O00EA3O002E4O00EA3O002F4O00EA3O004C4O00EA3O004D4O00EA3O00404O00EA3O00414O00EA3O00424O00EA3O00434O00EA3O001E4O00EA3O001F4O00EA3O001C4O00EA3O001D3O00060E0074000B000100172O00EA3O001B4O00E58O00EA3O00604O00EA3O00614O00EA3O00564O00EA3O00544O00EA3O00554O00EA3O00514O00EA3O00524O00EA3O00534O00EA3O005F4O00EA3O005D4O00EA3O005E4O00EA3O00624O00EA3O00574O00EA3O00584O00EA3O00594O00EA3O004E4O00EA3O004F4O00EA3O00504O00EA3O005A4O00EA3O005B4O00EA3O005C3O00060E0075000C0001001E2O00EA3O00164O00EA3O00074O00EA3O00194O00EA3O00704O00EA3O00714O00EA3O001A4O00EA3O00694O00EA3O00724O00EA3O00184O00EA3O000A4O00EA3O00234O00EA3O00654O00E58O00EA3O00114O00EA3O00664O00EA3O00244O00EA3O00094O00EA3O006E4O00EA3O00284O00EA3O00634O00EA3O00044O00EA3O00644O00EA3O006D4O00EA3O006F4O00EA3O00604O00EA3O00174O00EA3O00614O00EA3O00624O00EA3O00734O00EA3O00743O00060E0076000D000100032O00EA3O006B4O00EA3O000F4O00E57O0020AA0077000F004700122O007800486O007900756O007A00766O0077007A00016O00013O000E3O00093O00028O00026O00F03F025O0048AC40025O005CA040025O00EC9A40025O001EA340025O00BC9240025O00AEAB40024O0080B3C540001F3O0012F73O00014O00C3000100023O002606012O0006000100020004493O00060001002E9D00030018000100040004493O001800010026062O01000A000100010004493O000A0001002E9D00060006000100050004493O000600010012F7000200013O0026060102000F000100010004493O000F0001002E440008000B000100070004493O000B00010012F7000300094O007400035O0012F7000300094O0074000300013O0004493O001E00010004493O000B00010004493O001E00010004493O000600010004493O001E00010026293O0002000100010004493O000200010012F7000100014O00C3000200023O0012F73O00023O0004493O000200012O00363O00017O000C3O0003143O0033E0A8A2A3ABA21EDDADA2A5BBBE29FDB1A2A5A903073O00C77A8DD8D0CCDD030B3O004973417661696C61626C6503123O0089D403E07DFAA1DC12FC7DD2A8DF05F67EE503063O0096CDBD709018030A3O004D657267655461626C6503173O0044697370652O6C61626C654D61676963446562752O667303173O0044697370652O6C61626C654375727365446562752O667303123O00018DAC5C01841D112788BA68018A0416239703083O007045E4DF2C64E87103173O00F01614C3B3708AD51D0BD69B7D81DD1C23D6B46980D20C03073O00E6B47F67B3D61C00254O00609O00000100013O00122O000200013O00122O000300026O0001000300028O000100206O00036O0002000200064O001800013O0004493O001800012O00E53O00024O00D9000100013O00122O000200043O00122O000300056O0001000300024O000200033O00202O0002000200064O000300023O00202O0003000300074O000400023O00202O0004000400084O0002000400026O0001000200044O002400012O00E53O00024O0039000100013O00122O000200093O00122O0003000A6O0001000300024O000200026O000300013O00122O0004000B3O00122O0005000C6O0003000500024O0002000200036O000100022O00363O00019O003O00034O00E58O00813O000100012O00363O00017O00033O0003113O00446562752O665265667265736861626C6503103O00466C616D6553686F636B446562752O66026O001440010D3O00207F00013O00014O00035O00202O0003000300024O00010003000200062O0001000B00013O0004493O000B00012O00E5000100013O000E6B0003000A000100010004493O000A00012O000F00016O00AD000100014O005D000100024O00363O00017O00273O00028O00025O00449940025O008EA940026O00F03F025O001AA840025O00389240030B3O008DBA0556B7E7FCA4A0175003073O00AFCCC97124D68B03073O004973526561647903103O004865616C746850657263656E74616765025O008DB140025O0026AC40030B3O0041737472616C536869667403173O0046DF21CE054BF326D40D41D875D80141C93BCF0D51C92603053O006427AC55BC030E3O008879AB943B8874BC8D36A36CB88C03053O0053CD18D9E0025O0036A640025O003EA740031B3O00497354616E6B42656C6F774865616C746850657263656E74616765030E3O004561727468456C656D656E74616C031A3O00E3C4DF29EEFAC831E32OC833F2C4C17DE2C0CB38E8D6C42BE3D603043O005D86A5AD025O00149F40025O00C06540030B3O0096F7C0CE2EC6A16AB1FCC403083O001EDE92A1A25AAED2030B3O004865616C746873746F6E65025O00206A40025O00D2A04003173O00ED4B7106F146631EEA40754AE14B760FEB5D791CE00E2303043O006A852E1003193O006A2575EE5F5350297DFB1A685D217FF5544718107CE8534F5603063O00203840139C3A03173O0068CDE3445FE18853C6E27E5FF38C53C6E26655E68955C603073O00E03AA885363A9203173O0052656672657368696E674865616C696E67506F74696F6E03253O004B534DEF70958F0257510BF570878B0257510BED7A928E0457164FF87383891850404EBD2103083O006B39362B9D15E6E700BF3O0012F73O00014O00C3000100023O002E4400020009000100030004493O000900010026293O0009000100010004493O000900010012F7000100014O00C3000200023O0012F73O00043O0026293O0002000100040004493O000200010026290001000B000100010004493O000B00010012F7000200013O002E440006006A000100050004493O006A00010026290002006A000100010004493O006A00010012F7000300013O00262900030017000100040004493O001700010012F7000200043O0004493O006A0001000E1C00010013000100030004493O001300010012F7000400013O0026290004001E000100040004493O001E00010012F7000300043O0004493O001300010026290004001A000100010004493O001A00012O00E500055O00065C0005004100013O0004493O004100012O00E5000500014O00DB000600023O00122O000700073O00122O000800086O0006000800024O00050005000600202O0005000500094O00050002000200062O0005004100013O0004493O004100012O00E5000500033O00209300050005000A2O00690005000200022O00E5000600043O00068500060034000100050004493O003400010004493O00410001002E9D000C00410001000B0004493O004100012O00E5000500054O00E5000600013O00207800060006000D2O006900050002000200065C0005004100013O0004493O004100012O00E5000500023O0012F70006000E3O0012F70007000F4O009B000500074O00B300056O00E5000500063O00065C0005006700013O0004493O006700012O00E5000500014O00DB000600023O00122O000700103O00122O000800116O0006000800024O00050005000600202O0005000500094O00050002000200062O0005006700013O0004493O00670001002E9D00120067000100130004493O006700012O00E5000500033O00209300050005000A2O00690005000200022O00E5000600073O00068800050007000100060004493O005C00012O00E5000500083O0020780005000500142O00E5000600094O006900050002000200065C0005006700013O0004493O006700012O00E5000500054O00E5000600013O0020780006000600152O006900050002000200065C0005006700013O0004493O006700012O00E5000500023O0012F7000600163O0012F7000700174O009B000500074O00B300055O0012F7000400043O0004493O001A00010004493O001300010026060102006E000100040004493O006E0001002E9D0018000E000100190004493O000E00012O00E50003000A4O00DB000400023O00122O0005001A3O00122O0006001B6O0004000600024O00030003000400202O0003000300094O00030002000200062O0003009000013O0004493O009000012O00E50003000B3O00065C0003009000013O0004493O009000012O00E5000300033O00209300030003000A2O00690003000200022O00E50004000C3O00061200030090000100040004493O009000012O00E5000300054O00170004000D3O00202O00040004001C4O000500066O000700016O00030007000200062O0003008B000100010004493O008B0001002E44001E00900001001D0004493O009000012O00E5000300023O0012F70004001F3O0012F7000500204O009B000300054O00B300036O00E50003000E3O00065C000300BE00013O0004493O00BE00012O00E5000300033O00209300030003000A2O00690003000200022O00E50004000F3O000612000300BE000100040004493O00BE00012O00E5000300104O0063000400023O00122O000500213O00122O000600226O00040006000200062O000300A1000100040004493O00A100010004493O00BE00012O00E50003000A4O00DB000400023O00122O000500233O00122O000600246O0004000600024O00030003000400202O0003000300094O00030002000200062O000300BE00013O0004493O00BE00012O00E5000300054O00260004000D3O00202O0004000400254O000500066O000700016O00030007000200062O000300BE00013O0004493O00BE00012O00E5000300023O0012F2000400263O00122O000500276O000300056O00035O00044O00BE00010004493O000E00010004493O00BE00010004493O000B00010004493O00BE00010004493O000200012O00363O00017O00443O00028O00025O00909F40025O00D89E40026O00F03F025O000C9540025O00409540030C3O0053686F756C6452657475726E030D3O0048616E646C654368726F6D6965030C3O004865616C696E67537572676503153O004865616C696E6753757267654D6F7573656F766572026O004440025O006DB140025O00E8AB40027O0040025O0070A640025O00E07340025O00C08140025O0068B040030F3O0048616E646C65412O666C6963746564030C3O0050757269667953706972697403153O005075726966795370697269744D6F7573656F766572025O00BDB040025O00649540025O0080AB40025O002EB340025O0034A640025O0001B140025O004EAD40025O00AC994003073O005269707469646503103O00526970746964654D6F7573656F766572025O002FB340025O009CAB40026O000840025O0072A740026O003040025O0076A640025O006EA940026O007740025O009EB040025O00E9B240025O0036A140025O0035B240025O00408340025O005C9E40025O0030A540026O001040030B3O004865616C696E675761766503143O004865616C696E67576176654D6F7573656F766572025O007BB040025O00804340025O00FEAE40025O00E2A14003143O00506F69736F6E436C65616E73696E67546F74656D025O00988A40025O0056A740025O001DB340025O00E06040025O0018A840025O001CA940025O00C4AA40025O00AEA44003113O0048616E646C65496E636F72706F7265616C2O033O00486578030C3O004865784D6F7573654F766572026O003E40025O00A09840025O0017B140001A012O0012F73O00014O00C3000100013O000E350001000600013O0004493O00060001002E0C000200FEFF2O00030004493O000200010012F7000100013O0026062O01000B000100040004493O000B0001002E0C0005001B000100060004493O002400010012F7000200013O000E1C0001001D000100020004493O001D0001001259000300073O00065C0003001300013O0004493O00130001001259000300074O005D000300024O00E500035O00209E0003000300084O000400013O00202O0004000400094O000500023O00202O00050005000A00122O0006000B6O00030006000200122O000300073O00122O000200043O000E3500040021000100020004493O00210001002E0C000C00EDFF2O000D0004493O000C00010012F70001000E3O0004493O002400010004493O000C0001002629000100D7000100010004493O00D700012O00E5000200033O00067D0002002B000100010004493O002B0001002E0C000F00A4000100100004493O00CD00010012F7000200014O00C3000300033O002E0C00113O000100110004493O002D0001000E1C0001002D000100020004493O002D00010012F7000300013O00262900030051000100040004493O005100010012F7000400013O002E0C00120015000100120004493O004A00010026290004004A000100010004493O004A00012O00E500055O00206D0005000500134O000600013O00202O0006000600144O000700023O00202O00070007001500122O0008000B6O00050008000200122O000500073O00122O000500073O00062O00050047000100010004493O00470001002E4400160049000100170004493O00490001001259000500074O005D000500023O0012F7000400043O0026060104004E000100040004493O004E0001002E4400190035000100180004493O003500010012F70003000E3O0004493O005100010004493O00350001002E9D001A00700001001B0004493O00700001000E1C000E0070000100030004493O007000010012F7000400013O0026060104005A000100010004493O005A0001002E44001C006B0001001D0004493O006B00012O00E500055O00206D0005000500134O000600013O00202O00060006001E4O000700023O00202O00070007001F00122O0008000B6O00050008000200122O000500073O00122O000500073O00062O00050068000100010004493O00680001002E0C00200004000100210004493O006A0001001259000500074O005D000500023O0012F7000400043O00262900040056000100040004493O005600010012F7000300223O0004493O007000010004493O00560001002E440024009D000100230004493O009D00010026290003009D000100220004493O009D00010012F7000400013O002E9D00250096000100260004493O0096000100262900040096000100010004493O009600010012F7000500013O002E4400270080000100280004493O0080000100262900050080000100040004493O008000010012F7000400043O0004493O0096000100260601050084000100010004493O00840001002E9D0029007A0001002A0004493O007A00012O00E500065O0020C50006000600134O000700013O00202O0007000700094O000800023O00202O00080008000A00122O0009000B6O00060009000200122O000600073O002E2O002C00940001002B0004493O00940001001259000600073O00065C0006009400013O0004493O00940001001259000600074O005D000600023O0012F7000500043O0004493O007A00010026060104009A000100040004493O009A0001002E0C002D00DDFF2O002E0004493O007500010012F70003002F3O0004493O009D00010004493O00750001002629000300B00001002F0004493O00B000012O00E500045O0020E30004000400134O000500013O00202O0005000500304O000600023O00202O00060006003100122O0007000B6O00040007000200122O000400073O002E2O003300CD000100320004493O00CD0001001259000400073O00065C000400CD00013O0004493O00CD0001001259000400074O005D000400023O0004493O00CD000100262900030032000100010004493O003200010012F7000400013O002E44003500C5000100340004493O00C50001002629000400C5000100010004493O00C500012O00E500055O0020E00005000500134O000600013O00202O0006000600364O000700073O00122O0008000B6O00050008000200122O000500073O00122O000500073O00062O000500C400013O0004493O00C40001001259000500074O005D000500023O0012F7000400043O002629000400B3000100040004493O00B300010012F7000300043O0004493O003200010004493O00B300010004493O003200010004493O00CD00010004493O002D00012O00E500025O00209E0002000200084O000300013O00202O00030003001E4O000400023O00202O00040004001F00122O0005000B6O00020005000200122O000200073O00122O000100043O0026062O0100DB0001000E0004493O00DB0001002E44003800EC000100370004493O00EC0001002E9D003A00E2000100390004493O00E20001001259000200073O00065C000200E200013O0004493O00E20001001259000200074O005D000200024O00E500025O00209E0002000200084O000300013O00202O0003000300304O000400023O00202O00040004003100122O0005000B6O00020005000200122O000200073O00122O000100223O00262900010007000100220004493O00070001001259000200073O00067D000200F3000100010004493O00F30001002E44003C00F50001003B0004493O00F50001001259000200074O005D000200024O00E5000200043O00065C000200192O013O0004493O00192O010012F7000200014O00C3000300033O002629000200FA000100010004493O00FA00010012F7000300013O0026060103003O0100010004493O003O01002E44003D00FD0001003E0004493O00FD00012O00E500045O00206D00040004003F4O000500013O00202O0005000500404O000600023O00202O00060006004100122O000700426O00040007000200122O000400073O00122O000400073O00062O0004000F2O0100010004493O000F2O01002E0C0043000C000100440004493O00192O01001259000400074O005D000400023O0004493O00192O010004493O00FD00010004493O00192O010004493O00FA00010004493O00192O010004493O000700010004493O00192O010004493O000200012O00363O00017O00B63O00028O00025O00D0A640025O0040A440026O00084003043O004D616E61030D3O0088AB2D1F270DC35491A5371B1E03083O0031C5CA437E7364A703073O0049735265616479025O00589140025O0006A640025O00809C40025O0036A640030D3O004D616E6154696465546F74656D03193O003A5AD128BF4257335EE03D8F425B3A1BDC268F2O5A384CD13A03073O003E573BBF49E036025O00ECA740025O00608640025O00EEB040026O00F03F025O00488F40025O00B4A740025O00888E40025O00049D40025O00208B40025O00088C40030D3O00C60CF9CCF416E8C8EB21FBC5EB03043O00A987629A025O006C9140025O006DB240025O0068A540025O000BB040030D3O00416E6365737472616C43612O6C03173O00EA792751EE27DACA7B0755F13F88C8782B58F93CDFC56403073O00A8AB1744349D53025O00C07140025O00E08540030B3O00D670F2A2231995FD72FEBE03073O00E7941195CD454D030B3O004261676F66547269636B7303153O00A2A6C0F451CB92AEC4F044BF83A8C8F753F097A9D403063O009FE0C7A79B37025O00207840025O00206140025O00D88C40025O004DB040025O00707640027O0040025O00E89A40030A3O00D5F62EC1F2E137DBF9F403043O00B297935C030A3O004265727365726B696E67025O0034AF40025O00D8AD4003143O00AEF85E21175E7185F34B7211437580F943251C5F03073O001AEC9D2C52722C025O00409740025O00A4994003093O000822DA542E08C0493303043O003B4A4EB5025O00107B40025O0076A14003093O00426C2O6F644675727903133O0007DD2O55B703C44843F326DE5556B72AC6544903053O00D345B12O3A025O00B89C40025O004EA34003093O0091EC6BF0EBC7B8EA7D03063O00ABD78519958903093O0046697265626C2O6F6403133O00C7C120FFED3CF34DE58831F5E03CF84DF6C62103083O002281A8529A8F509C025O0018A340025O00E2A940025O00CAAC40025O00206740025O00108740025O009C9E40030B3O00FE8A03E1B1EFC7D28E1DF103073O00AFBBEB7195D9BC03063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O004440030D3O00556E697447726F7570526F6C6503043O00088EAF6703073O00185CCFE12C831903083O0042752O66446F776E030B3O004561727468536869656C64025O002O9440025O002AA84003103O004561727468536869656C64466F637573025O0066A440025O0053B140031B3O004ED2AA58134258DBB149177974C7B942103D43D6B94012734CC0AC03063O001D2BB3D82C7B03073O008FD03058B4DD2503043O002CDDB94003073O005269707469646503103O004865616C746850657263656E74616765030C3O0052697074696465466F63757303123O0013EE584B7A05E208577600EB41517400E84D03053O00136187283F03073O009C55232F2635AB03063O0051CE3C535B4F03043O007A8AFE5903083O00C42ECBB0124FA32D03123O00AA2B6E0A2DFFEAF82A7B1F28F2E1BF23711B03073O008FD8421E7E449B031D3O00417265556E69747342656C6F774865616C746850657263656E74616765030F3O0099D804D9CCB7FBE8A4C339C4D1A6DA03083O0081CAA86DABA5C3B703063O00125436C1DB0603073O0086423857B8BE74025O00405D40025O003DB340025O00C05A40025O0029B34003153O005370697269744C696E6B546F74656D506C61796572031B3O002F2100A910FF1E39353F02840DE4353031710AB416E7253A2B3F1A03083O00555C5169DB798B4103153O00DBA1594072DBF1AA105072DBF8A1106669CDEEBC4203063O00BF9DD330251C03093O004D6F7573656F76657203093O0043616E412O7461636B03153O005370697269744C696E6B546F74656D437572736F72031B3O00CC0FFD0E33CB20F81534D420E0132EDA12B41F35D013F0132DD10C03053O005ABF7F947C030C3O005B882011719523166C8E211903043O007718E74E025O00608F40025O0086AF40030F3O005370697269744C696E6B546F74656D031B3O00913DAC58D5542E8E24AB41E3541E9628A80ADF4F1E8E29AA5DD25303073O0071E24DC52ABC20025O00E4A540025O00107740025O00649740025O0002A440030C3O0053686F756C6452657475726E03103O0048616E646C65546F705472696E6B6574025O00808940025O00C09A4003133O0048616E646C65426F2O746F6D5472696E6B657403103O001213F5B93318F3813312F1813502F1B803043O00D55A769403103O004865616C696E6754696465546F74656D031C3O00532BB55A4455298B42445F2B8B2O424F2BB9164E5421B852424C20A703053O002D3B4ED43603183O003158808E953ABFF11C669184922BAEE419598DBF893AA8FD03083O00907036E3EBE64ECD025O005AA540025O0036A74003063O0083240EE5D54903063O003BD3486F9CB0031E3O00416E6365737472616C50726F74656374696F6E546F74656D506C6179657203223O006F89E0285D93F12C42B7F1225A82E0394788ED194193E6200E84EC224283EC3A409403043O004D2EE783025O004EA440025O00A4AF4003153O009C46BF45B450BA59FA41B844BF46F663AF46A54FA803043O0020DA34D6031E3O00416E6365737472616C50726F74656374696F6E546F74656D437572736F7203223O006F1932ADE2A4575B422723A7E5B5464E47183F9CFEA440570E143EA7FDB44A4D400403083O003A2E7751C891D025025O00C89F40030C3O0008833EAAA0AF3B2A9839A3A703073O00564BEC50CCC9DD03183O00416E6365737472616C50726F74656374696F6E546F74656D03223O00534F7480ED9F60407BB5EC8466447491F7847C757891FB863242788AF28F7D56799603063O00EB122117E59E025O00C0A740025O00B0B14003113O0071B4C2BE43AED3BA5C9DD4B254BBCFB85503043O00DB30DAA103113O00416E6365737472616C47756964616E6365031C3O00E52O7F4CC85BF2E57D434ECE46E4E52O7F4C9B4CEFEB7D7846CC41F303073O008084111C29BB2F030A3O002021053F53053308395803053O003D6152665A030A3O00417363656E64616E636503143O00AD3DA84EC9531F07AF2BEB48C858120DA339A55803083O0069CC4ECB2BA7377E00E1022O0012F73O00014O00C3000100013O002606012O0006000100010004493O00060001002E4400020002000100030004493O000200010012F7000100013O002629000100E8000100040004493O00E800012O00E500025O00065C0002001C00013O0004493O001C00012O00E5000200013O0020930002000200052O00690002000200022O00E5000300023O0006120002001C000100030004493O001C00012O00E5000200034O0053000300043O00122O000400063O00122O000500076O0003000500024O00020002000300202O0002000200084O00020002000200062O0002001E000100010004493O001E0001002E9D000A002B000100090004493O002B0001002E9D000B002B0001000C0004493O002B00012O00E5000200054O00E5000300033O00207800030003000D2O006900020002000200065C0002002B00013O0004493O002B00012O00E5000200043O0012F70003000E3O0012F70004000F4O009B000200044O00B300025O002E0C001000B5020100100004493O00E002012O00E5000200063O00065C000200E002013O0004493O00E002010012F7000200014O00C3000300043O002E9D00110039000100120004493O0039000100262900020039000100010004493O003900010012F7000300014O00C3000400043O0012F7000200133O002E4400140032000100150004493O0032000100262900020032000100130004493O003200010026290003003D000100010004493O003D00010012F7000400013O00260601040044000100010004493O00440001002E440017007F000100160004493O007F00010012F7000500013O00260601050049000100010004493O00490001002E440019007A000100180004493O007A00012O00E5000600034O0053000700043O00122O0008001A3O00122O0009001B6O0007000900024O00060006000700202O0006000600084O00060002000200062O00060055000100010004493O00550001002E0C001C000F0001001D0004493O00620001002E44001E00620001001F0004493O006200012O00E5000600054O00E5000700033O0020780007000700202O006900060002000200065C0006006200013O0004493O006200012O00E5000600043O0012F7000700213O0012F7000800224O009B000600084O00B300065O002E4400230079000100240004493O007900012O00E5000600034O00DB000700043O00122O000800253O00122O000900266O0007000900024O00060006000700202O0006000600084O00060002000200062O0006007900013O0004493O007900012O00E5000600054O00E5000700033O0020780007000700272O006900060002000200065C0006007900013O0004493O007900012O00E5000600043O0012F7000700283O0012F7000800294O009B000600084O00B300065O0012F7000500133O00262900050045000100130004493O004500010012F7000400133O0004493O007F00010004493O00450001002E9D002B00C80001002A0004493O00C80001002629000400C8000100130004493O00C800010012F7000500014O00C3000600063O002E0C002C3O0001002C0004493O00850001000E1C00010085000100050004493O008500010012F7000600013O0026060106008E000100130004493O008E0001002E0C002D00040001002E0004493O009000010012F70004002F3O0004493O00C80001002E0C003000FAFF2O00300004493O008A00010026290006008A000100010004493O008A00012O00E5000700034O00DB000800043O00122O000900313O00122O000A00326O0008000A00024O00070007000800202O0007000700084O00070002000200062O000700AB00013O0004493O00AB00012O00E5000700054O00E5000800033O0020780008000800332O006900070002000200067D000700A6000100010004493O00A60001002E9D003400AB000100350004493O00AB00012O00E5000700043O0012F7000800363O0012F7000900374O009B000700094O00B300075O002E44003800C4000100390004493O00C400012O00E5000700034O00DB000800043O00122O0009003A3O00122O000A003B6O0008000A00024O00070007000800202O0007000700084O00070002000200062O000700C400013O0004493O00C40001002E9D003C00C40001003D0004493O00C400012O00E5000700054O00E5000800033O00207800080008003E2O006900070002000200065C000700C400013O0004493O00C400012O00E5000700043O0012F70008003F3O0012F7000900404O009B000700094O00B300075O0012F7000600133O0004493O008A00010004493O00C800010004493O00850001000E35002F00CC000100040004493O00CC0001002E4400420040000100410004493O004000012O00E5000500034O00DB000600043O00122O000700433O00122O000800446O0006000800024O00050005000600202O0005000500084O00050002000200062O000500E002013O0004493O00E002012O00E5000500054O00E5000600033O0020780006000600452O006900050002000200065C000500E002013O0004493O00E002012O00E5000500043O0012F2000600463O00122O000700476O000500076O00055O00044O00E002010004493O004000010004493O00E002010004493O003D00010004493O00E002010004493O003200010004493O00E00201002E44004800ED2O0100490004493O00ED2O01002629000100ED2O0100130004493O00ED2O010012F7000200013O002606010200F10001002F0004493O00F10001002E9D004A00F30001004B0004493O00F300010012F70001002F3O0004493O00ED2O01002E9D004C005B2O01004D0004493O005B2O010026290002005B2O0100010004493O005B2O012O00E5000300034O00DB000400043O00122O0005004E3O00122O0006004F6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300252O013O0004493O00252O012O00E5000300073O00065C000300252O013O0004493O00252O012O00E5000300083O0020930003000300502O006900030002000200065C000300252O013O0004493O00252O012O00E5000300083O0020930003000300512O006900030002000200067D000300252O0100010004493O00252O012O00E5000300083O0020930003000300520012F7000500534O004200030005000200065C000300252O013O0004493O00252O012O00E5000300093O0020940003000300544O000400086O0003000200024O000400043O00122O000500553O00122O000600566O00040006000200062O000300252O0100040004493O00252O012O00E5000300083O0020BB0003000300574O000500033O00202O0005000500584O00030005000200062O000300272O0100010004493O00272O01002E0C0059000F0001005A0004493O00342O012O00E5000300054O00E50004000A3O00207800040004005B2O006900030002000200067D0003002F2O0100010004493O002F2O01002E9D005D00342O01005C0004493O00342O012O00E5000300043O0012F70004005E3O0012F70005005F4O009B000300054O00B300036O00E50003000B3O00065C0003005A2O013O0004493O005A2O012O00E5000300034O00DB000400043O00122O000500603O00122O000600616O0004000600024O00030003000400202O0003000300084O00030002000200062O0003005A2O013O0004493O005A2O012O00E5000300083O00207F0003000300574O000500033O00202O0005000500624O00030005000200062O0003005A2O013O0004493O005A2O012O00E5000300083O0020930003000300632O00690003000200022O00E50004000C3O0006850004004F2O0100030004493O004F2O010004493O005A2O012O00E5000300054O00E50004000A3O0020780004000400642O006900030002000200065C0003005A2O013O0004493O005A2O012O00E5000300043O0012F7000400653O0012F7000500664O009B000300054O00B300035O0012F7000200133O002629000200ED000100130004493O00ED00012O00E50003000B3O00065C0003008C2O013O0004493O008C2O012O00E5000300034O00DB000400043O00122O000500673O00122O000600686O0004000600024O00030003000400202O0003000300084O00030002000200062O0003008C2O013O0004493O008C2O012O00E5000300083O00207F0003000300574O000500033O00202O0005000500624O00030005000200062O0003008C2O013O0004493O008C2O012O00E5000300083O0020930003000300632O00690003000200022O00E50004000D3O0006120003008C2O0100040004493O008C2O012O00E5000300093O0020940003000300544O000400086O0003000200024O000400043O00122O000500693O00122O0006006A6O00040006000200062O0003008C2O0100040004493O008C2O012O00E5000300054O00E50004000A3O0020780004000400642O006900030002000200065C0003008C2O013O0004493O008C2O012O00E5000300043O0012F70004006B3O0012F70005006C4O009B000300054O00B300036O00E5000300093O00209F00030003006D4O0004000E6O0005000F6O00030005000200062O000300EB2O013O0004493O00EB2O012O00E5000300034O00DB000400043O00122O0005006E3O00122O0006006F6O0004000600024O00030003000400202O0003000300084O00030002000200062O000300EB2O013O0004493O00EB2O012O00E5000300104O0063000400043O00122O000500703O00122O000600716O00040006000200062O000300A62O0100040004493O00A62O01002E44007300B42O0100720004493O00B42O01002E9D007400EB2O0100750004493O00EB2O012O00E5000300054O00E50004000A3O0020780004000400762O006900030002000200065C000300EB2O013O0004493O00EB2O012O00E5000300043O0012F2000400773O00122O000500786O000300056O00035O00044O00EB2O012O00E5000300104O000D010400043O00122O000500793O00122O0006007A6O00040006000200062O000300D72O0100040004493O00D72O010012590003007B3O0020930003000300502O006900030002000200065C000300EB2O013O0004493O00EB2O012O00E5000300013O00209300030003007C0012590005007B4O004200030005000200067D000300EB2O0100010004493O00EB2O012O00E5000300054O00A20004000A3O00202O00040004007D4O000500113O00202O00050005005200122O000700536O0005000700024O000500056O00030005000200062O000300EB2O013O0004493O00EB2O012O00E5000300043O0012F20004007E3O00122O0005007F6O000300056O00035O00044O00EB2O012O00E5000300104O0063000400043O00122O000500803O00122O000600816O00040006000200062O000300E02O0100040004493O00E02O01002E44008300EB2O0100820004493O00EB2O012O00E5000300054O00E5000400033O0020780004000400842O006900030002000200065C000300EB2O013O0004493O00EB2O012O00E5000300043O0012F7000400853O0012F7000500864O009B000300054O00B300035O0012F70002002F3O0004493O00ED00010026062O0100F12O0100010004493O00F12O01002E440087001B020100880004493O001B02010012F7000200013O002E9D008900F82O01008A0004493O00F82O01002629000200F82O01002F0004493O00F82O010012F7000100133O0004493O001B0201000E1C00010008020100020004493O000802012O00E5000300093O0020CD00030003008C4O000400126O000500133O00122O000600536O000700076O00030007000200122O0003008B3O00122O0003008B3O00062O0003000702013O0004493O000702010012590003008B4O005D000300023O0012F7000200133O0026060102000C020100130004493O000C0201002E44008E00F22O01008D0004493O00F22O012O00E5000300093O0020CD00030003008F4O000400126O000500133O00122O000600536O000700076O00030007000200122O0003008B3O00122O0003008B3O00062O0003001902013O0004493O001902010012590003008B4O005D000300023O0012F70002002F3O0004493O00F22O01002629000100070001002F0004493O000700012O00E5000200143O00065C0002003C02013O0004493O003C02012O00E5000200093O00209F00020002006D4O000300156O000400166O00020004000200062O0002003C02013O0004493O003C02012O00E5000200034O00DB000300043O00122O000400903O00122O000500916O0003000500024O00020002000300202O0002000200084O00020002000200062O0002003C02013O0004493O003C02012O00E5000200054O00E5000300033O0020780003000300922O006900020002000200065C0002003C02013O0004493O003C02012O00E5000200043O0012F7000300933O0012F7000400944O009B000200044O00B300026O00E5000200093O00209F00020002006D4O000300176O000400186O00020004000200062O0002004D02013O0004493O004D02012O00E5000200034O0053000300043O00122O000400953O00122O000500966O0003000500024O00020002000300202O0002000200084O00020002000200062O0002004F020100010004493O004F0201002E0C0097004F000100980004493O009C02012O00E5000200194O000D010300043O00122O000400993O00122O0005009A6O00030005000200062O00020062020100030004493O006202012O00E5000200054O00E50003000A3O00207800030003009B2O006900020002000200065C0002009C02013O0004493O009C02012O00E5000200043O0012F20003009C3O00122O0004009D6O000200046O00025O00044O009C0201002E44009E00870201009F0004493O008702012O00E5000200194O000D010300043O00122O000400A03O00122O000500A16O00030005000200062O00020087020100030004493O008702010012590002007B3O0020930002000200502O006900020002000200065C0002009C02013O0004493O009C02012O00E5000200013O00209300020002007C0012590004007B4O004200020004000200067D0002009C020100010004493O009C02012O00E5000200054O00A20003000A3O00202O0003000300A24O000400113O00202O00040004005200122O000600536O0004000600024O000400046O00020004000200062O0002009C02013O0004493O009C02012O00E5000200043O0012F2000300A33O00122O000400A46O000200046O00025O00044O009C0201002E0C00A5000A000100A50004493O009102012O00E5000200194O0063000300043O00122O000400A63O00122O000500A76O00030005000200062O00020091020100030004493O009102010004493O009C02012O00E5000200054O00E5000300033O0020780003000300A82O006900020002000200065C0002009C02013O0004493O009C02012O00E5000200043O0012F7000300A93O0012F7000400AA4O009B000200044O00B300025O002E4400AB00BD020100AC0004493O00BD02012O00E50002001A3O00065C000200BD02013O0004493O00BD02012O00E5000200093O00209F00020002006D4O0003001B6O0004001C6O00020004000200062O000200BD02013O0004493O00BD02012O00E5000200034O00DB000300043O00122O000400AD3O00122O000500AE6O0003000500024O00020002000300202O0002000200084O00020002000200062O000200BD02013O0004493O00BD02012O00E5000200054O00E5000300033O0020780003000300AF2O006900020002000200065C000200BD02013O0004493O00BD02012O00E5000200043O0012F7000300B03O0012F7000400B14O009B000200044O00B300026O00E50002001D3O00065C000200DC02013O0004493O00DC02012O00E5000200093O00209F00020002006D4O0003001E6O0004001F6O00020004000200062O000200DC02013O0004493O00DC02012O00E5000200034O00DB000300043O00122O000400B23O00122O000500B36O0003000500024O00020002000300202O0002000200084O00020002000200062O000200DC02013O0004493O00DC02012O00E5000200054O00E5000300033O0020780003000300B42O006900020002000200065C000200DC02013O0004493O00DC02012O00E5000200043O0012F7000300B53O0012F7000400B64O009B000200044O00B300025O0012F7000100043O0004493O000700010004493O00E002010004493O000200012O00363O00017O00AF3O00028O00027O0040025O0058A040025O000AA040031D3O00417265556E69747342656C6F774865616C746850657263656E7461676503103O00E4131FE10A75B7F61301F9367FADC41F03073O00D9A1726D95621003073O004973526561647903063O00222C3965B96603063O00147240581CDC025O0090A040025O00BFB24003163O004561727468656E57612O6C546F74656D506C61796572031D3O003400C0A0F0D5B30E16D3B8F4EFA93E15D7B9B8D8B8300DDBBAFFD1B23403073O00DD5161B2D498B003153O00EBF514FE14C9EB04BB0FC3E318E95AEEF20FE815DF03053O007AAD877D9B025O00BAB140025O0050784003093O004D6F7573656F76657203063O0045786973747303093O0043616E412O7461636B03163O004561727468656E57612O6C546F74656D437572736F7203093O004973496E52616E6765026O004440031D3O0081C012AD3734C6BBD601B5330EDC8BD505B47F39CD85CD09B73830C78103073O00A8E4A160D95F51030C3O00F8DE205A2645D6D03A55205903063O0037BBB14E3C4F025O00E07040025O00D8984003103O004561727468656E57612O6C546F74656D031D3O0028CF4DFF4ECA8E12D95EE74AF09422DA5AE606C7852CC256E541CE8F2803073O00E04DAE3F8B26AF03083O00A04E4F20944E4D3C03043O004EE4213803063O00FE72B31A80DC03053O00E5AE1ED263025O00649940025O00C49340030E3O00446F776E706F7572506C6179657203083O0042752O66446F776E03163O0053706972697477616C6B657273477261636542752O6603133O001FE2915FFD322C09AD8E54EC313015EA875EE803073O00597B8DE6318D5D03153O00D563FF091E4EFF68B6191E4EF663B62F0558E07EE403063O002A9311966C70025O00804940025O00C08C40030E3O00446F776E706F7572437572736F7203133O000BA93A71F7E71AB46D77E2E903AF2378E6E70A03063O00886FC64D1F87030C3O002106A950B4F61AA81600A85803083O00C96269C736DD847703083O00446F776E706F757203133O00BD03942F123AB9AB4C8B240339A5B70B822E0703073O00CCD96CE3416255030F3O007DCFFAF028C24BD1E6F118CF4AC6F803063O00A03EA395854C025O0030A740025O00389F40030F3O00436C6F75646275727374546F74656D031A3O00D5AC023AC1C3B21E3BFCC2AF192ACE96A8082ECFDFAE0A2ECCD303053O00A3B6C06D4F026O000840030A3O0003230CCCE6243409CEF203053O0095544660A0030A3O0057652O6C737072696E6703153O002F0301E12B161FE436014DE53D0701E436010CE23D03043O008D58666D03093O00905BCB79141550C0BF03083O00A1D333AA107A5D35030E3O00436861696E4865616C466F637573025O001AA840025O006CA54003153O00F8A6B321F591BA2DFAA2F220FEAFBE21F5A9B327FE03043O00489BCED203083O0049734D6F76696E6703123O00756A5D1C3A526D550238436847292147795103053O0053261A346E03123O0053706972697477616C6B6572734772616365031E3O004B072E5451033047541C22544B282054591422065012264A51192047571203043O0026387747026O00104003123O00DBEA59DA2C58F4DC4CC42057FEDB57C2205B03063O0036938F38B64503123O004865616C696E6753747265616D546F74656D031F3O00DE84FE45D6D886C05ACBC484FE44E0C28EEB4CD29689FA48D3DF8FF848D0D303053O00BFB6E19F29026O00F03F025O00807740025O0046A040030B3O00048C70B93091749038847903043O00DC51E21C03103O004865616C746850657263656E74616765030B3O00556E6C656173684C69666503173O0006DB8EFEEBD41BEA8EF2ECC253DD87FAE6CE1DD283F4EF03063O00A773B5E29B8A025O005FB040025O0040934003063O00C137F54F746303073O00A68242873C1B11030B3O006C4FCF79394A4DFC74394A03053O0050242AAE1503113O004865616C696E675261696E437572736F72025O00849740025O0009B34003173O0046153676471E30455C113E740E18327B4219397D4F1F3203043O001A2E7057025O0050AE40025O00B6B140030B3O009126AA78B6B14286B82AA503083O00D4D943CB142ODF2503063O008A81A9CBBF9F03043O00B2DAEDC8025O0080A240025O00DAA34003113O004865616C696E675261696E506C61796572025O007DB240025O0007B04003173O00BEB0E7DCBFBBE1EFA4B4EFDEF6BDE3D1BABCE8D7B7BAE303043O00B0D6D58603153O00D22OBFD1A652552OEDA3DAAC534BB48EA3C6BB594B03073O003994CDD6B4C836025O00DC9240025O00B1B040025O00549F40025O00C2A34003173O001AF834387F1CFA0A26771BF3753C7313F13C3A7113F23003053O0016729D555403123O00E1C516C944B6BDCACF16D61DD5BDD6D81CD603073O00C8A4AB73A43D96025O00D08E40025O000AAC4003173O00B6F102498AB0F33C5782B7FA434D86BFF80A4B84BFFB0603053O00E3DE946325030C3O00105D5C2OF0215F53E2F03C5C03053O0099532O3296025O005EA840025O00E07A40025O00D2A240025O0026A940030B3O004865616C696E675261696E03173O00557372107AA54A626472157DEB4558777F157DAC4C527303073O002D3D16137C13CB030B3O00A0B3211F407D818CB73F0F03073O00E9E5D2536B282E030D3O004973446561644F7247686F7374030D3O00556E697447726F7570526F6C6503043O00F5631CFD03053O0065A12252B6030B3O004561727468536869656C64025O00108C40025O00BCA54003103O004561727468536869656C64466F637573025O0094A140025O00909B40031B3O00ED0C4BEAD3DD9126E10855FAE4F68320E34D51FBDAEE8B20EF1E4D03083O004E886D399EBB82E203073O000C36E9E5373BFC03043O00915E5F9903073O0052697074696465025O00A88540030C3O0052697074696465466F637573025O00607B4003123O00EFC404C147B3F88D1CD04FBBF4C313D441B203063O00D79DAD74B52E025O005C9B40025O000C964003073O0007BD9BE6D331B103053O00BA55D4EB9203043O00F6A038D503073O0038A2E1769E598E03123O004E0CD0BB2BDC5945C8AA23D4550BC7AE2DDD03063O00B83C65A0CF420016032O0012F73O00013O000E350002000500013O0004493O00050001002E9D000300F5000100040004493O00F500012O00E500015O00209F0001000100054O000200016O000300026O00010003000200062O0001006400013O0004493O006400012O00E5000100034O00DB000200043O00122O000300063O00122O000400076O0002000400024O00010001000200202O0001000100084O00010002000200062O0001006400013O0004493O006400012O00E5000100054O000D010200043O00122O000300093O00122O0004000A6O00020004000200062O0001002B000100020004493O002B0001002E44000B00640001000C0004493O006400012O00E5000100064O00E5000200073O00207800020002000D2O006900010002000200065C0001006400013O0004493O006400012O00E5000100043O0012F20002000E3O00122O0003000F6O000100036O00015O00044O006400012O00E5000100054O0063000200043O00122O000300103O00122O000400116O00020004000200062O00010034000100020004493O00340001002E9D00120050000100130004493O00500001001259000100143O0020930001000100152O006900010002000200065C0001006400013O0004493O006400012O00E5000100083O002093000100010016001259000300144O004200010003000200067D00010064000100010004493O006400012O00E5000100064O00A2000200073O00202O0002000200174O000300093O00202O00030003001800122O000500196O0003000500024O000300036O00010003000200062O0001006400013O0004493O006400012O00E5000100043O0012F20002001A3O00122O0003001B6O000100036O00015O00044O006400012O00E5000100054O000D010200043O00122O0003001C3O00122O0004001D6O00020004000200062O00010064000100020004493O00640001002E9D001E00640001001F0004493O006400012O00E5000100064O00E5000200033O0020780002000200202O006900010002000200065C0001006400013O0004493O006400012O00E5000100043O0012F7000200213O0012F7000300224O009B000100034O00B300016O00E500015O00209F0001000100054O0002000A6O0003000B6O00010003000200062O000100D300013O0004493O00D300012O00E5000100034O00DB000200043O00122O000300233O00122O000400246O0002000400024O00010001000200202O0001000100084O00010002000200062O000100D300013O0004493O00D300012O00E50001000C4O000D010200043O00122O000300253O00122O000400266O00020004000200062O00010090000100020004493O00900001002E44002800D3000100270004493O00D300012O00E5000100064O000A010200073O00202O0002000200294O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O000100D300013O0004493O00D300012O00E5000100043O0012F20002002C3O00122O0003002D6O000100036O00015O00044O00D300012O00E50001000C4O000D010200043O00122O0003002E3O00122O0004002F6O00020004000200062O000100BA000100020004493O00BA0001001259000100143O0020930001000100152O006900010002000200065C000100A200013O0004493O00A200012O00E5000100083O002093000100010016001259000300144O004200010003000200065C000100A400013O0004493O00A40001002E9D003100D3000100300004493O00D300012O00E5000100064O00F3000200073O00202O0002000200324O000300093O00202O00030003001800122O000500196O0003000500024O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O000100D300013O0004493O00D300012O00E5000100043O0012F2000200333O00122O000300346O000100036O00015O00044O00D300012O00E50001000C4O0063000200043O00122O000300353O00122O000400366O00020004000200062O000100C2000100020004493O00C200010004493O00D300012O00E5000100064O000A010200033O00202O0002000200374O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O000100D300013O0004493O00D300012O00E5000100043O0012F7000200383O0012F7000300394O009B000100034O00B300016O00E50001000D3O00065C000100E700013O0004493O00E700012O00E500015O00209F0001000100054O0002000E6O0003000F6O00010003000200062O000100E700013O0004493O00E700012O00E5000100034O0053000200043O00122O0003003A3O00122O0004003B6O0002000400024O00010001000200202O0001000100084O00010002000200062O000100E9000100010004493O00E90001002E9D003C00F40001003D0004493O00F400012O00E5000100064O00E5000200033O00207800020002003E2O006900010002000200065C000100F400013O0004493O00F400012O00E5000100043O0012F70002003F3O0012F7000300404O009B000100034O00B300015O0012F73O00413O000E1C004100682O013O0004493O00682O012O00E5000100103O00065C0001001C2O013O0004493O001C2O012O00E500015O00209F0001000100054O000200116O000300126O00010003000200062O0001001C2O013O0004493O001C2O012O00E5000100034O00DB000200043O00122O000300423O00122O000400436O0002000400024O00010001000200202O0001000100084O00010002000200062O0001001C2O013O0004493O001C2O012O00E5000100064O000A010200033O00202O0002000200444O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O0001001C2O013O0004493O001C2O012O00E5000100043O0012F7000200453O0012F7000300464O009B000100034O00B300016O00E5000100133O00065C000100432O013O0004493O00432O012O00E500015O00209F0001000100054O000200146O000300156O00010003000200062O000100432O013O0004493O00432O012O00E5000100034O00DB000200043O00122O000300473O00122O000400486O0002000400024O00010001000200202O0001000100084O00010002000200062O000100432O013O0004493O00432O012O00E5000100064O002O010200073O00202O0002000200494O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O0001003E2O0100010004493O003E2O01002E9D004A00432O01004B0004493O00432O012O00E5000100043O0012F70002004C3O0012F70003004D4O009B000100034O00B300016O00E5000100163O00065C000100672O013O0004493O00672O012O00E5000100083O00209300010001004E2O006900010002000200065C000100672O013O0004493O00672O012O00E500015O00209F0001000100054O000200176O000300186O00010003000200062O000100672O013O0004493O00672O012O00E5000100034O00DB000200043O00122O0003004F3O00122O000400506O0002000400024O00010001000200202O0001000100084O00010002000200062O000100672O013O0004493O00672O012O00E5000100064O00E5000200033O0020780002000200512O006900010002000200065C000100672O013O0004493O00672O012O00E5000100043O0012F7000200523O0012F7000300534O009B000100034O00B300015O0012F73O00543O0026293O008A2O0100540004493O008A2O012O00E5000100193O00065C0001001503013O0004493O001503012O00E500015O00209F0001000100054O0002001A6O0003001B6O00010003000200062O0001001503013O0004493O001503012O00E5000100034O00DB000200043O00122O000300553O00122O000400566O0002000400024O00010001000200202O0001000100084O00010002000200062O0001001503013O0004493O001503012O00E5000100064O00E5000200033O0020780002000200572O006900010002000200065C0001001503013O0004493O001503012O00E5000100043O0012F2000200583O00122O000300596O000100036O00015O00044O00150301002606012O008E2O01005A0004493O008E2O01002E9D005C00790201005B0004493O007902012O00E50001001C3O00065C000100AC2O013O0004493O00AC2O012O00E5000100034O00DB000200043O00122O0003005D3O00122O0004005E6O0002000400024O00010001000200202O0001000100084O00010002000200062O000100AC2O013O0004493O00AC2O012O00E50001001D3O00209300010001005F2O00690001000200022O00E50002001E3O000612000100AC2O0100020004493O00AC2O012O00E5000100064O00E5000200033O0020780002000200602O006900010002000200065C000100AC2O013O0004493O00AC2O012O00E5000100043O0012F7000200613O0012F7000300624O009B000100034O00B300015O002E44006400D62O0100630004493O00D62O012O00E50001001F4O000D010200043O00122O000300653O00122O000400666O00020004000200062O000100D62O0100020004493O00D62O012O00E5000100034O00DB000200043O00122O000300673O00122O000400686O0002000400024O00010001000200202O0001000100084O00010002000200062O000100D62O013O0004493O00D62O012O00E5000100064O0087000200073O00202O0002000200694O000300093O00202O00030003001800122O000500196O0003000500024O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O000100D12O0100010004493O00D12O01002E44006B00D62O01006A0004493O00D62O012O00E5000100043O0012F70002006C3O0012F70003006D4O009B000100034O00B300015O002E44006E00780201006F0004493O007802012O00E500015O00209F0001000100054O000200206O000300216O00010003000200062O0001007802013O0004493O007802012O00E5000100034O00DB000200043O00122O000300703O00122O000400716O0002000400024O00010001000200202O0001000100084O00010002000200062O0001007802013O0004493O007802012O00E50001001F4O0063000200043O00122O000300723O00122O000400736O00020004000200062O000100F22O0100020004493O00F22O01002E9D00750006020100740004493O000602012O00E5000100064O002O010200073O00202O0002000200764O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O00012O00020100010004494O000201002E9D00770078020100780004493O007802012O00E5000100043O0012F2000200793O00122O0003007A6O000100036O00015O00044O007802012O00E50001001F4O0063000200043O00122O0003007B3O00122O0004007C6O00020004000200062O0001000F020100020004493O000F0201002E0C007D00250001007E0004493O00320201001259000100143O0020930001000100152O006900010002000200065C0001007802013O0004493O007802012O00E5000100083O002093000100010016001259000300144O004200010003000200067D00010078020100010004493O007802012O00E5000100064O0087000200073O00202O0002000200694O000300093O00202O00030003001800122O000500196O0003000500024O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O0001002C020100010004493O002C0201002E0C007F004E000100800004493O007802012O00E5000100043O0012F2000200813O00122O000300826O000100036O00015O00044O007802012O00E50001001F4O000D010200043O00122O000300833O00122O000400846O00020004000200062O0001005C020100020004493O005C0201002E4400850078020100860004493O00780201001259000100143O0020930001000100152O006900010002000200065C0001007802013O0004493O007802012O00E5000100083O002093000100010016001259000300144O004200010003000200065C0001007802013O0004493O007802012O00E5000100064O00F3000200073O00202O0002000200694O000300093O00202O00030003001800122O000500196O0003000500024O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O0001007802013O0004493O007802012O00E5000100043O0012F2000200873O00122O000300886O000100036O00015O00044O007802012O00E50001001F4O0063000200043O00122O000300893O00122O0004008A6O00020004000200062O00010065020100020004493O00650201002E0C008B00150001008C0004493O00780201002E9D008D00780201008E0004493O007802012O00E5000100064O000A010200033O00202O00020002008F4O000300036O000400083O00202O00040004002A4O000600033O00202O00060006002B4O000400066O00013O000200062O0001007802013O0004493O007802012O00E5000100043O0012F7000200903O0012F7000300914O009B000100034O00B300015O0012F73O00023O0026293O0001000100010004493O000100012O00E5000100034O00DB000200043O00122O000300923O00122O000400936O0002000400024O00010001000200202O0001000100084O00010002000200062O000100A902013O0004493O00A902012O00E5000100223O00065C000100A902013O0004493O00A902012O00E50001001D3O0020930001000100152O006900010002000200065C000100A902013O0004493O00A902012O00E50001001D3O0020930001000100942O006900010002000200067D000100A9020100010004493O00A902012O00E50001001D3O0020930001000100180012F7000300194O004200010003000200065C000100A902013O0004493O00A902012O00E500015O0020940001000100954O0002001D6O0001000200024O000200043O00122O000300963O00122O000400976O00020004000200062O000100A9020100020004493O00A902012O00E50001001D3O0020BB00010001002A4O000300033O00202O0003000300984O00010003000200062O000100AB020100010004493O00AB0201002E44009A00B8020100990004493O00B802012O00E5000100064O00E5000200073O00207800020002009B2O006900010002000200067D000100B3020100010004493O00B30201002E9D009C00B80201009D0004493O00B802012O00E5000100043O0012F70002009E3O0012F70003009F4O009B000100034O00B300016O00E5000100233O00065C000100E202013O0004493O00E202012O00E5000100034O00DB000200043O00122O000300A03O00122O000400A16O0002000400024O00010001000200202O0001000100084O00010002000200062O000100E202013O0004493O00E202012O00E50001001D3O00207F00010001002A4O000300033O00202O0003000300A24O00010003000200062O000100E202013O0004493O00E20201002E0C00A30009000100A30004493O00D502012O00E50001001D3O00209300010001005F2O00690001000200022O00E5000200243O000685000200D5020100010004493O00D502010004493O00E202012O00E5000100064O00E5000200073O0020780002000200A42O006900010002000200067D000100DD020100010004493O00DD0201002E0C00800007000100A50004493O00E202012O00E5000100043O0012F7000200A63O0012F7000300A74O009B000100034O00B300015O002E4400A90013030100A80004493O001303012O00E5000100233O00065C0001001303013O0004493O001303012O00E5000100034O00DB000200043O00122O000300AA3O00122O000400AB6O0002000400024O00010001000200202O0001000100084O00010002000200062O0001001303013O0004493O001303012O00E50001001D3O00207F00010001002A4O000300033O00202O0003000300A24O00010003000200062O0001001303013O0004493O001303012O00E50001001D3O00209300010001005F2O00690001000200022O00E5000200253O00061200010013030100020004493O001303012O00E500015O0020940001000100954O0002001D6O0001000200024O000200043O00122O000300AC3O00122O000400AD6O00020004000200062O00010013030100020004493O001303012O00E5000100064O00E5000200073O0020780002000200A42O006900010002000200065C0001001303013O0004493O001303012O00E5000100043O0012F7000200AE3O0012F7000300AF4O009B000100034O00B300015O0012F73O005A3O0004493O000100012O00363O00017O005A3O00028O00025O0056B040027O0040025O003AB240025O00188340025O0081B240025O00ADB140025O000FB140025O002EAD40026O00F03F030A3O004973536F6C6F4D6F6465030F3O00ACF5857E24E6BF1887CF8A7F35E4B203083O0076E09CE2165088D603073O004973526561647903083O0042752O66446F776E030F3O004C696768746E696E67536869656C64031A3O004EE75E8856E0508E45D14A884BEB558402E65C814EE7578751FA03043O00E0228E39030B3O00E9A6D1D861C25507DBABC103083O006EBEC7A5BD13913D030B3O005761746572536869656C6403163O00CDEA63ED99F8C9E37EED87C39AE372E987CED4EC64FC03063O00A7BA8B1788EB030C3O0032B0890113BB8F3E0FA78F0803043O006D7AD5E8025O00F4A24003103O004865616C746850657263656E7461676503113O004865616C696E675375726765466F63757303163O0053706972697477616C6B657273477261636542752O6603173O00E6F2A33CE7F9A50FFDE2B037EBB7AA35EFFBAB3EE9E4B603043O00508E97C2026O003540025O00CC9E40026O000840025O00D4A640025O00907B40025O0050AC40025O00C09140025O00EC9F40025O00AEA440030B3O000E133A4183B4CA2217245103073O00A24B724835EBE703063O00457869737473030D3O004973446561644F7247686F737403093O004973496E52616E6765026O004440030D3O00556E697447726F7570526F6C6503043O00B81D6AC903063O0062EC5C248233030B3O004561727468536869656C6403103O004561727468536869656C64466F637573031B3O00A1181EAE4D97A638AD1C00BE7ABCB43EAF5904BF44A4BC3EA30A1803083O0050C4796CDA25C8D503073O00327A126B420A8F03073O00EA6013621F2B6E03073O0052697074696465025O00207640025O00F89740030C3O0052697074696465466F637573025O0068AD40025O000CB34003123O00141642D3A5768E461757C6A07B85011E5DC203073O00EB667F32A7CC1203073O0062A8E5374D2A5503063O004E30C195432403043O00043FAE3303053O0021507EE078025O00B8AC40025O00F8854003123O00FEA113D055E8AD43CC59EDA40ACA5BEDA70603053O003C8CC863A4025O00C6AD40025O00F0734003073O00B5FD1432AB83F103053O00C2E7946446025O00804740025O0008914003123O005445D1B7FFCC430CC9A6F7C44F42C6A2F9CD03063O00A8262CA1C396025O006C9540025O00A8A640030B3O002BC376400AC8707B02D07203043O002C63A617025O00989140025O00807F40025O0028AD40025O0020684003103O004865616C696E6757617665466F63757303163O0074F2282O3AAA7BC83E3725A13CFF2C373FAD72F03A2203063O00C41C9749565300A6012O0012F73O00014O00C3000100013O002E0C00023O000100020004493O00020001000E1C0001000200013O0004493O000200010012F7000100013O0026290001008D000100030004493O008D00010012F7000200014O00C3000300033O000E350001000F000100020004493O000F0001002E9D0004000B000100050004493O000B00010012F7000300013O00260601030014000100010004493O00140001002E9D00060084000100070004493O008400010012F7000400013O002E9D0009001B000100080004493O001B00010026290004001B0001000A0004493O001B00010012F70003000A3O0004493O0084000100262900040015000100010004493O001500012O00E500055O00207800050005000B2O00DD00050001000200065C0005003F00013O0004493O003F00012O00E5000500014O00DB000600023O00122O0007000C3O00122O0008000D6O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005005B00013O0004493O005B00012O00E5000500033O00207F00050005000F4O000700013O00202O0007000700104O00050007000200062O0005005B00013O0004493O005B00012O00E5000500044O00E5000600013O0020780006000600102O006900050002000200065C0005005B00013O0004493O005B00012O00E5000500023O0012F2000600113O00122O000700126O000500076O00055O00044O005B00012O00E5000500014O00DB000600023O00122O000700133O00122O000800146O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005005B00013O0004493O005B00012O00E5000500033O00207F00050005000F4O000700013O00202O0007000700154O00050007000200062O0005005B00013O0004493O005B00012O00E5000500044O00E5000600013O0020780006000600152O006900050002000200065C0005005B00013O0004493O005B00012O00E5000500023O0012F7000600163O0012F7000700174O009B000500074O00B300056O00E5000500053O00065C0005008200013O0004493O008200012O00E5000500014O00DB000600023O00122O000700183O00122O000800196O0006000800024O00050005000600202O00050005000E4O00050002000200062O0005008200013O0004493O00820001002E0C001A00090001001A0004493O007100012O00E5000500063O00209300050005001B2O00690005000200022O00E5000600073O00068500060071000100050004493O007100010004493O008200012O00E5000500044O000A010600083O00202O00060006001C4O000700076O000800033O00202O00080008000F4O000A00013O00202O000A000A001D4O0008000A6O00053O000200062O0005008200013O0004493O008200012O00E5000500023O0012F70006001E3O0012F70007001F4O009B000500074O00B300055O0012F70004000A3O0004493O00150001002E4400200010000100210004493O00100001002629000300100001000A0004493O001000010012F7000100223O0004493O008D00010004493O001000010004493O008D00010004493O000B0001002629000100092O0100010004493O00092O010012F7000200013O002629000200940001000A0004493O009400010012F70001000A3O0004493O00092O0100260601020098000100010004493O00980001002E9D00230090000100240004493O009000010012F7000300013O002E9D0026009F000100250004493O009F00010026290003009F0001000A0004493O009F00010012F70002000A3O0004493O0090000100262900030099000100010004493O00990001002E44002700DC000100280004493O00DC00012O00E5000400014O00DB000500023O00122O000600293O00122O0007002A6O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400DC00013O0004493O00DC00012O00E5000400093O00065C000400DC00013O0004493O00DC00012O00E5000400063O00209300040004002B2O006900040002000200065C000400DC00013O0004493O00DC00012O00E5000400063O00209300040004002C2O006900040002000200067D000400DC000100010004493O00DC00012O00E5000400063O00209300040004002D0012F70006002E4O004200040006000200065C000400DC00013O0004493O00DC00012O00E500045O00209400040004002F4O000500066O0004000200024O000500023O00122O000600303O00122O000700316O00050007000200062O000400DC000100050004493O00DC00012O00E5000400063O00207F00040004000F4O000600013O00202O0006000600324O00040006000200062O000400DC00013O0004493O00DC00012O00E5000400044O00E5000500083O0020780005000500332O006900040002000200065C000400DC00013O0004493O00DC00012O00E5000400023O0012F7000500343O0012F7000600354O009B000400064O00B300046O00E50004000A3O00065C000400F000013O0004493O00F000012O00E5000400014O00DB000500023O00122O000600363O00122O000700376O0005000700024O00040004000500202O00040004000E4O00040002000200062O000400F000013O0004493O00F000012O00E5000400063O0020BB00040004000F4O000600013O00202O0006000600384O00040006000200062O000400F2000100010004493O00F20001002E9D003A00062O0100390004493O00062O012O00E5000400063O00209300040004001B2O00690004000200022O00E50005000B3O000685000500F9000100040004493O00F900010004493O00062O012O00E5000400044O00E5000500083O00207800050005003B2O006900040002000200067D0004003O0100010004493O003O01002E9D003D00062O01003C0004493O00062O012O00E5000400023O0012F70005003E3O0012F70006003F4O009B000400064O00B300045O0012F70003000A3O0004493O009900010004493O00900001002629000100742O01000A0004493O00742O010012F7000200013O002629000200102O01000A0004493O00102O010012F7000100033O0004493O00742O010026290002000C2O0100010004493O000C2O012O00E50003000A3O00065C000300432O013O0004493O00432O012O00E5000300014O00DB000400023O00122O000500403O00122O000600416O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300432O013O0004493O00432O012O00E5000300063O00207F00030003000F4O000500013O00202O0005000500384O00030005000200062O000300432O013O0004493O00432O012O00E5000300063O00209300030003001B2O00690003000200022O00E50004000C3O000612000300432O0100040004493O00432O012O00E500035O00209400030003002F4O000400066O0003000200024O000400023O00122O000500423O00122O000600436O00040006000200062O000300432O0100040004493O00432O01002E9D004500432O0100440004493O00432O012O00E5000300044O00E5000400083O00207800040004003B2O006900030002000200065C000300432O013O0004493O00432O012O00E5000300023O0012F7000400463O0012F7000500474O009B000300054O00B300035O002E44004900722O0100480004493O00722O012O00E50003000A3O00065C000300722O013O0004493O00722O012O00E5000300014O00DB000400023O00122O0005004A3O00122O0006004B6O0004000600024O00030003000400202O00030003000E4O00030002000200062O000300722O013O0004493O00722O012O00E5000300063O00207F00030003000F4O000500013O00202O0005000500384O00030005000200062O000300722O013O0004493O00722O01002E44004C00722O01004D0004493O00722O012O00E5000300063O00209300030003001B2O00690003000200022O00E50004000B3O00068800030007000100040004493O00672O012O00E5000300063O00209300030003001B2O00690003000200022O00E50004000B3O000612000300722O0100040004493O00722O012O00E5000300044O00E5000400083O00207800040004003B2O006900030002000200065C000300722O013O0004493O00722O012O00E5000300023O0012F70004004E3O0012F70005004F4O009B000300054O00B300035O0012F70002000A3O0004493O000C2O010026062O0100782O0100220004493O00782O01002E9D00510007000100500004493O000700012O00E50002000D3O00065C000200852O013O0004493O00852O012O00E5000200014O0053000300023O00122O000400523O00122O000500536O0003000500024O00020002000300202O00020002000E4O00020002000200062O000200872O0100010004493O00872O01002E9D005400A52O0100550004493O00A52O012O00E5000200063O00209300020002001B2O00690002000200022O00E50003000E3O000655000300A52O0100020004493O00A52O01002E0C00560003000100570004493O00902O010004493O00A52O012O00E5000200044O000A010300083O00202O0003000300584O000400046O000500033O00202O00050005000F4O000700013O00202O00070007001D4O000500076O00023O000200062O000200A52O013O0004493O00A52O012O00E5000200023O0012F2000300593O00122O0004005A6O000200046O00025O00044O00A52O010004493O000700010004493O00A52O010004493O000200012O00363O00017O00313O00028O00025O0020AA40025O00D2A940026O00F03F030B3O0023003DE7DBA5A7150437E703073O00C270745295B6CE03073O0049735265616479030B3O0053746F726D6B2O65706572025O008AA640025O00149E4003123O002ABC430ACDE90B3CB8490A80E60F34A94B1D03073O006E59C82C78A08203113O00476574456E656D696573496E52616E6765026O004440026O000840025O00BEB140025O00E89840030D3O0087CA4C4E57443243ACE1444A5703083O002DCBA32B26232A5B030D3O004C696768746E696E67426F6C7403083O0042752O66446F776E03163O0053706972697477616C6B657273477261636542752O6603153O00DE8CDB2B93A75DDC82E32188A5409281DD2E86AE5103073O0034B2E5BC43E7C9025O00207540025O0062AB40030E3O000249510DF9702A2649440AFE522403073O004341213064973C030E3O00436861696E4C696768746E696E6703163O00DCEFAFD1FDE0EBA7DFFBCBE9A7D6F49FE3AFD5F2D8E203053O0093BF87CEB8025O00405140030A3O00D50F281D876B1079F00803083O001693634970E2387803093O00436173744379636C65030A3O00466C616D6553686F636B030E3O0049735370652O6C496E52616E6765026O008540026O00774003183O00BE79E3F8888766EAFA8EB34AE1EC8EB470A2F18CB574E5F003053O00EDD8158295025O00D88F4003093O00AE4F495E92DC4C915A03073O003EE22E2O3FD0A903093O004C6176614275727374025O00207240025O0074A54003113O00E9184382200F3A4CF60D15871E002E59E003083O003E857935E37F6D4F00AF3O0012F73O00014O00C3000100013O002E9D00030002000100020004493O000200010026293O0002000100010004493O000200010012F7000100013O00262900010063000100040004493O006300012O00E500026O00DB000300013O00122O000400053O00122O000500066O0003000500024O00020002000300202O0002000200074O00020002000200062O0002002000013O0004493O002000012O00E5000200024O00E500035O0020780003000300082O006900020002000200067D0002001B000100010004493O001B0001002E44000900200001000A0004493O002000012O00E5000200013O0012F70003000B3O0012F70004000C4O009B000200044O00B300026O00E5000200033O0020FB00020002000D00122O0004000E6O0002000400024O000200023O00262O000200290001000F0004493O00290001002E9D00100045000100110004493O004500012O00E500026O00DB000300013O00122O000400123O00122O000500136O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AE00013O0004493O00AE00012O00E5000200024O000A01035O00202O0003000300144O000400046O000500033O00202O0005000500154O00075O00202O0007000700164O000500076O00023O000200062O000200AE00013O0004493O00AE00012O00E5000200013O0012F2000300173O00122O000400186O000200046O00025O00044O00AE0001002E9D001900AE0001001A0004493O00AE00012O00E500026O00DB000300013O00122O0004001B3O00122O0005001C6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AE00013O0004493O00AE00012O00E5000200024O000A01035O00202O00030003001D4O000400046O000500033O00202O0005000500154O00075O00202O0007000700164O000500076O00023O000200062O000200AE00013O0004493O00AE00012O00E5000200013O0012F20003001E3O00122O0004001F6O000200046O00025O00044O00AE000100262900010007000100010004493O00070001002E0C00200026000100200004493O008B00012O00E500026O00DB000300013O00122O000400213O00122O000500226O0003000500024O00020002000300202O0002000200074O00020002000200062O0002008B00013O0004493O008B00012O00E5000200043O0020250002000200234O00035O00202O0003000300244O000400033O00202O00040004000D00122O0006000E6O0004000600024O000500056O000600063O00202O0006000600254O00085O00202O0008000800244O0006000800024O000600066O0007000A6O0002000A000200062O00020086000100010004493O00860001002E0C00260007000100270004493O008B00012O00E5000200013O0012F7000300283O0012F7000400294O009B000200044O00B300025O002E0C002A001F0001002A0004493O00AA00012O00E500026O00DB000300013O00122O0004002B3O00122O0005002C6O0003000500024O00020002000300202O0002000200074O00020002000200062O000200AA00013O0004493O00AA00012O00E5000200024O002O01035O00202O00030003002D4O000400046O000500033O00202O0005000500154O00075O00202O0007000700164O000500076O00023O000200062O000200A5000100010004493O00A50001002E44002F00AA0001002E0004493O00AA00012O00E5000200013O0012F7000300303O0012F7000400314O009B000200044O00B300025O0012F7000100043O0004493O000700010004493O00AE00010004493O000200012O00363O00017O00FD3O00028O00026O000840030C3O004570696353652O74696E677303083O00FB5F1A3910D6A89003083O00E3A83A6E4D79B8CF030E3O004E2FBA65B0C965AD4834B645BDDF03083O00C51B5CDF20D1BB1103083O00305AD7EF0A51C4E803043O009B633FA3030A3O00B7C2A4BFB09496D8A58803063O00E4E2B1C1EDD903083O0007B537F23DBE24F503043O008654D04303093O0021A596481AA883742303043O003C73CCE603083O00D43FFF64EE34EC6303043O0010875A8B030D3O00667D162747507D60750838666403073O0018341466532E34026O001040026O002040025O000C9E40025O00F9B140026O00F03F03083O0089836DE756C023A903073O0044DAE619933FAE03143O009E3A5A5EBFB9065A42BD99254749BB9839524BB303053O00D6CD4A332C03083O00C949F6E87EF44BF103053O00179A2C829C03113O0022B6A4BC3F073DAFA3A5021C05A3A0860603063O007371C6CDCE56027O0040025O00EAAE40025O0066A040026O002240025O004CAF40025O0028874003083O007506FD385A18411003063O00762663894C3303143O00D523041E002EFA1511000C21F0120A060C2DD51603063O00409D4665726903083O0073ADB3F7194EAFB403053O007020C8C78303173O0004555DB4CAA5251F444EBDC2A616234459B5E4B92D394003073O00424C303CD8A3CB026O001440025O006EA240025O002AAD4003083O0037EAB0D7385403FC03063O003A648FC4A35103103O00324722AF3647E23C1B4B2D962C48E20B03083O006E7A2243C35F298503083O0046B44F5EDF7BB64803053O00B615D13B2A030D3O009F52C411282OB065C4142F968703063O00DED737A57D4103083O00B88121AFE7857A9803073O001DEBE455DB8EEB030E3O0008C7BFE8794222532EDC96D4714B03083O00325DB4DABD172E4703083O00EDA14F584DD24FCD03073O0028BEC43B2C24BC030D3O00094BD0B1FB6E05104CDAB1D24D03073O006D5C25BCD49A1D026O001840026O001C40025O00F4B140025O00C4A24003083O006EB0B69354BBA59403043O00E73DD5C203153O003CBE384019A42F7A1DBA3C7F02A82F602EBF3C700C03043O001369CD5D03083O009A0DCA9536A70FCD03053O005FC968BEE103143O009CDBC8DCA6DFD6CFA3C0C4DCBCECD3CFACCEE9FE03043O00AECFABA103083O00DEFB19E7F1D9EAED03063O00B78D9E6D939803173O001F19EF1E251DF10D2002E31E3F2EF40D2F0CC11E231CF603043O006C4C698603083O00D8C0A5F5C7E5C2A203053O00AE8BA5D18103153O0096A0E7E9C3027C71ADB4D1D5D406717597BCF6C4CB03083O0018C3D382A1A66310025O003CA040025O00606440026O002440025O0014B040025O00088740026O00264003083O001AA9242C20A2372B03043O005849CC5003153O000B82025221DF20B4114A25EE2197154B1CC92F841503063O00BA4EE370264903083O00CF52E9415A74FB4403063O001A9C379D353303123O00A9D904CDB05582EF17D5B46483CC13D4906003063O0030ECB876B9D803083O00D6B84324C63AE2AE03063O005485DD3750AF03153O0098E636B2CF59B3D025AACB68B2F321ABE04EB2F23403063O003CDD8744C6A703083O00DDB8EC974BD7E9AE03063O00B98EDD98E322030D3O007CCA40F4533CE24AF044FB443603073O009738A5379A235303083O003E34216904700A2203063O001E6D51551D6D03113O00D77455BA3FD0FBCF7E40BF39D0D2FE7C5103073O009C9F1134D656BE03083O009DEAA9A8A7E1BAAF03043O00DCCE8FDD030F3O00AE7C2313D4C9F3807B211EDBD8D78203073O00B2E61D4D77B8AC025O005C9240025O00D4AF4003083O00C6BB1E0F7EF6F2AD03063O009895DE6A7B1703113O00F527F847B9D80FF840BACF36F951B0DC2A03053O00D5BD46962303083O007C50601C465B731B03043O00682F3514030D3O008745920CB90387498309BA09B003063O006FC32CE17CDC025O00449540025O0086B240025O0058AF40025O00D0AF40025O00BEAD40025O00F0934003083O001FD4D20EFBCFEA5903083O002A4CB1A67A92A18D03103O008D8F04C27078A2B804C77751B78510DE03063O0016C5EA65AE1903083O001E31B1C87FA1D09503083O00E64D54C5BC16CFB7030C3O00CC07C3DF84A0F93BD111C7F003083O00559974A69CECC19003083O0097E559A7ED0EA3F303063O0060C4802DD384030B3O0016857A56DC87B1D939A54B03083O00B855ED1B3FB2CFD403083O003B5C1D4B01570E4C03043O003F683969030E3O00288FA54D05AFA14507A0B64B1E9703043O00246BE7C403083O007B74A0EACC4676A703053O00A52811D49E03163O00CCD71C3634F7CC182709EBD511042EECCD0D3F2FF6CD03053O004685B9685303083O003740503EC00A425703053O00A96425244A03123O002989B6551295B74014B3AA420594AA5F0C8303043O003060E7C203083O00EB431467A2A5DF5503063O00CBB8266013CB030B3O001D7A6A51CB35516C47C82A03053O00AE5913192103083O001C17465AFE890C3C03073O006B4F72322E97E703113O0010A8A12C982BA2D02D91BC3D820AA3D53703083O00A059C6D549EA59D7025O0058A140025O0009B140025O00806C4003083O001D4E2AC1581FFB3D03073O009C4E2B5EB53171031D3O0053E6C7A618576B73E4F4B104577C71FCCDAC05777666EDC99618427E7703073O00191288A4C36B2303083O00DB28BD5B7BB2C6AB03083O00D8884DC92F12DCA1031A3O000CE228DF1BC8902CE01BC807C8872EF822D506E88D39E926F23803073O00E24D8C4BBA68BC03083O00934611FAA94D02FD03043O008EC02365030A3O00F27A3EADF783B904FE4503083O0076B61549C387ECCC03083O003B390E540D03FA1B03073O009D685C7A20646D030D3O0087A9D8C42D2898B984B4C0DF2D03083O00CBC3C6AFAA5D47ED025O0016B040025O00F4AB40026O002840025O00C6A640025O00D49D40025O00D08340025O00C6A14003083O00F72A353006CA283203053O006FA44F4144030E3O00F3CA86F62BEBCAD08DD919EBD0DC03063O008AA6B9E3BE4E03083O00F871D1235B2D1ED803073O0079AB14A5573243030D3O00EE3DB83AB00CC10FB820BC2AF603063O0062A658D956D903083O00C5F36D158FD2F1E503063O00BC2O961961E6030F3O00EF9A5A2A09ECD68051053FF8C88E5A03063O008DBAE93F626C03083O00C2EF38A22CFFED3F03053O0045918A4CD6030E3O0058CA8885B61877FC9C9BB81358FF03063O007610AF2OE9DF025O000C9140025O00C2A540025O001EB240025O0030A64003083O008ACBC42B46B7C9C303053O002FD9AEB05F031D3O0099D37507A1406A27B4ED640DA6517B32B1D27836BD407D2B9FCF7917A203083O0046D8BD1662D2341803083O00E9DAB793DAD4D8B003053O00B3BABFC3E703123O00CC2C1DC7F5300DE0FB2A0AF7ED0B17F0FC3203043O0084995F78025O00309440025O003EB14003083O00B752EA4E8D59F94903043O003AE4379E03143O008799D93C35B919BD87DB1A33B930B9AEC22129BD03073O0055D4E9B04E5CCD03083O00795D9CF643568FF103043O00822A38E803133O00DFA621CB453EE6BC2AE47436EEB010EC543AE703063O005F8AD544832003083O00192DB5577F242FB203053O00164A48C12303123O00047CE5542577E36C257DE16C236DE155044903043O00384C198403083O006DC4BF32C650C6B803053O00AF3EA1CB4603153O0014D8C21F3C32DAF71A3139E9CC073031FAD11C202C03053O00555CBDA373025O006EAB4003083O003DA864F0028C09BE03063O00E26ECD10846B03103O00DED0E5F144EACFE9D746DBCCF4D04EE503053O00218BA380B903083O00645D10CA5E5603CD03043O00BE373864030F3O007EAA3D121AEDF466A028171CEDDB6603073O009336CF5C7E7383025O00A8A04003083O00B72DB2D5D15DB59703073O00D2E448C6A1B833030E3O00035AF63876CF3A5DFB0367C1384C03063O00AE562993701303083O006805991F2C0116B803083O00CB3B60ED6B456F71030D3O000C13ADED25F8C43019A2E419C003073O00B74476CC8151900020032O0012F73O00014O00C3000100013O0026293O0002000100010004493O000200010012F7000100013O00262900010038000100020004493O00380001001259000200034O00FD000300013O00122O000400043O00122O000500056O0003000500024O0002000200034O000300013O00122O000400063O00122O000500076O0003000500024O0002000200034O00025O00122O000200036O000300013O00122O000400083O00122O000500096O0003000500024O0002000200034O000300013O00122O0004000A3O00122O0005000B6O0003000500024O0002000200034O000200023O00122O000200036O000300013O00122O0004000C3O00122O0005000D6O0003000500024O0002000200034O000300013O00122O0004000E3O00122O0005000F6O0003000500024O0002000200034O000200033O00122O000200036O000300013O00122O000400103O00122O000500116O0003000500024O0002000200034O000300013O00122O000400123O00122O000500136O0003000500024O0002000200034O000200043O00122O000100143O0026290001007C000100150004493O007C00010012F7000200013O002E4400160058000100170004493O0058000100262900020058000100180004493O00580001001259000300034O00B6000400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000400013O00122O0005001B3O00122O0006001C6O0004000600024O0003000300044O000300053O00122O000300036O000400013O00122O0005001D3O00122O0006001E6O0004000600024O0003000300044O000400013O00122O0005001F3O00122O000600206O0004000600024O0003000300044O000300063O00122O000200213O0026060102005C000100210004493O005C0001002E0C00220004000100230004493O005E00010012F7000100243O0004493O007C0001002E440026003B000100250004493O003B00010026290002003B000100010004493O003B0001001259000300034O00B6000400013O00122O000500273O00122O000600286O0004000600024O0003000300044O000400013O00122O000500293O00122O0006002A6O0004000600024O0003000300044O000300073O00122O000300036O000400013O00122O0005002B3O00122O0006002C6O0004000600024O0003000300044O000400013O00122O0005002D3O00122O0006002E6O0004000600024O0003000300044O000300083O00122O000200183O0004493O003B0001002629000100BC0001002F0004493O00BC00010012F7000200013O002E9D0030009C000100310004493O009C00010026290002009C000100180004493O009C0001001259000300034O00B6000400013O00122O000500323O00122O000600336O0004000600024O0003000300044O000400013O00122O000500343O00122O000600356O0004000600024O0003000300044O000300093O00122O000300036O000400013O00122O000500363O00122O000600376O0004000600024O0003000300044O000400013O00122O000500383O00122O000600396O0004000600024O0003000300044O0003000A3O00122O000200213O002629000200B7000100010004493O00B70001001259000300034O00B6000400013O00122O0005003A3O00122O0006003B6O0004000600024O0003000300044O000400013O00122O0005003C3O00122O0006003D6O0004000600024O0003000300044O0003000B3O00122O000300036O000400013O00122O0005003E3O00122O0006003F6O0004000600024O0003000300044O000400013O00122O000500403O00122O000600416O0004000600024O0003000300044O0003000C3O00122O000200183O0026290002007F000100210004493O007F00010012F7000100423O0004493O00BC00010004493O007F00010026062O0100C0000100430004493O00C00001002E9D004400F1000100450004493O00F10001001259000200034O00FD000300013O00122O000400463O00122O000500476O0003000500024O0002000200034O000300013O00122O000400483O00122O000500496O0003000500024O0002000200034O0002000D3O00122O000200036O000300013O00122O0004004A3O00122O0005004B6O0003000500024O0002000200034O000300013O00122O0004004C3O00122O0005004D6O0003000500024O0002000200034O0002000E3O00122O000200036O000300013O00122O0004004E3O00122O0005004F6O0003000500024O0002000200034O000300013O00122O000400503O00122O000500516O0003000500024O0002000200034O0002000F3O00122O000200036O000300013O00122O000400523O00122O000500536O0003000500024O0002000200034O000300013O00122O000400543O00122O000500556O0003000500024O0002000200034O000200103O00122O000100153O002E44005700332O0100560004493O00332O01002629000100332O0100580004493O00332O010012F7000200013O002E44005A00FC000100590004493O00FC0001002629000200FC000100210004493O00FC00010012F70001005B3O0004493O00332O01002629000200172O0100010004493O00172O01001259000300034O00B6000400013O00122O0005005C3O00122O0006005D6O0004000600024O0003000300044O000400013O00122O0005005E3O00122O0006005F6O0004000600024O0003000300044O000300113O00122O000300036O000400013O00122O000500603O00122O000600616O0004000600024O0003000300044O000400013O00122O000500623O00122O000600636O0004000600024O0003000300044O000300123O00122O000200183O002629000200F6000100180004493O00F60001001259000300034O00B6000400013O00122O000500643O00122O000600656O0004000600024O0003000300044O000400013O00122O000500663O00122O000600676O0004000600024O0003000300044O000300133O00122O000300036O000400013O00122O000500683O00122O000600696O0004000600024O0003000300044O000400013O00122O0005006A3O00122O0006006B6O0004000600024O0003000300044O000300143O00122O000200213O0004493O00F60001000E1C001800752O0100010004493O00752O010012F7000200013O002629000200512O0100010004493O00512O01001259000300034O00B6000400013O00122O0005006C3O00122O0006006D6O0004000600024O0003000300044O000400013O00122O0005006E3O00122O0006006F6O0004000600024O0003000300044O000300153O00122O000300036O000400013O00122O000500703O00122O000600716O0004000600024O0003000300044O000400013O00122O000500723O00122O000600736O0004000600024O0003000300044O000300163O00122O000200183O000E35001800552O0100020004493O00552O01002E440075006E2O0100740004493O006E2O01001259000300034O00B6000400013O00122O000500763O00122O000600776O0004000600024O0003000300044O000400013O00122O000500783O00122O000600796O0004000600024O0003000300044O000300173O00122O000300036O000400013O00122O0005007A3O00122O0006007B6O0004000600024O0003000300044O000400013O00122O0005007C3O00122O0006007D6O0004000600024O0003000300044O000300183O00122O000200213O002606010200722O0100210004493O00722O01002E0C007E00C6FF2O007F0004493O00362O010012F7000100213O0004493O00752O010004493O00362O01000E35004200792O0100010004493O00792O01002E9D008100B72O0100800004493O00B72O010012F7000200013O002E9D008300802O0100820004493O00802O01000E1C002100802O0100020004493O00802O010012F7000100433O0004493O00B72O010026290002009B2O0100010004493O009B2O01001259000300034O00B6000400013O00122O000500843O00122O000600856O0004000600024O0003000300044O000400013O00122O000500863O00122O000600876O0004000600024O0003000300044O000300193O00122O000300036O000400013O00122O000500883O00122O000600896O0004000600024O0003000300044O000400013O00122O0005008A3O00122O0006008B6O0004000600024O0003000300044O0003001A3O00122O000200183O0026290002007A2O0100180004493O007A2O01001259000300034O00B6000400013O00122O0005008C3O00122O0006008D6O0004000600024O0003000300044O000400013O00122O0005008E3O00122O0006008F6O0004000600024O0003000300044O0003001B3O00122O000300036O000400013O00122O000500903O00122O000600916O0004000600024O0003000300044O000400013O00122O000500923O00122O000600936O0004000600024O0003000300044O0003001C3O00122O000200213O0004493O007A2O01002629000100F52O0100210004493O00F52O010012F7000200013O002629000200BE2O0100210004493O00BE2O010012F7000100023O0004493O00F52O01002629000200D92O0100180004493O00D92O01001259000300034O00B6000400013O00122O000500943O00122O000600956O0004000600024O0003000300044O000400013O00122O000500963O00122O000600976O0004000600024O0003000300044O0003001D3O00122O000300036O000400013O00122O000500983O00122O000600996O0004000600024O0003000300044O000400013O00122O0005009A3O00122O0006009B6O0004000600024O0003000300044O0003001E3O00122O000200213O000E1C000100BA2O0100020004493O00BA2O01001259000300034O00B6000400013O00122O0005009C3O00122O0006009D6O0004000600024O0003000300044O000400013O00122O0005009E3O00122O0006009F6O0004000600024O0003000300044O0003001F3O00122O000300036O000400013O00122O000500A03O00122O000600A16O0004000600024O0003000300044O000400013O00122O000500A23O00122O000600A36O0004000600024O0003000300044O000300203O00122O000200183O0004493O00BA2O01002E9D00A40039020100A50004493O00390201002629000100390201005B0004493O003902010012F7000200013O002E0C00A6001D000100A60004493O0017020100262900020017020100180004493O00170201001259000300034O00B6000400013O00122O000500A73O00122O000600A86O0004000600024O0003000300044O000400013O00122O000500A93O00122O000600AA6O0004000600024O0003000300044O000300213O00122O000300036O000400013O00122O000500AB3O00122O000600AC6O0004000600024O0003000300044O000400013O00122O000500AD3O00122O000600AE6O0004000600024O0003000300044O000300223O00122O000200213O000E1C00010032020100020004493O00320201001259000300034O00B6000400013O00122O000500AF3O00122O000600B06O0004000600024O0003000300044O000400013O00122O000500B13O00122O000600B26O0004000600024O0003000300044O000300233O00122O000300036O000400013O00122O000500B33O00122O000600B46O0004000600024O0003000300044O000400013O00122O000500B53O00122O000600B66O0004000600024O0003000300044O000300243O00122O000200183O00260601020036020100210004493O00360201002E9D00B700FA2O0100B80004493O00FA2O010012F7000100B93O0004493O003902010004493O00FA2O010026062O01003D020100140004493O003D0201002E4400BA007D020100BB0004493O007D02010012F7000200013O002E9D00BC005B020100BD0004493O005B02010026290002005B020100010004493O005B0201001259000300034O00B6000400013O00122O000500BE3O00122O000600BF6O0004000600024O0003000300044O000400013O00122O000500C03O00122O000600C16O0004000600024O0003000300044O000300253O00122O000300036O000400013O00122O000500C23O00122O000600C36O0004000600024O0003000300044O000400013O00122O000500C43O00122O000600C56O0004000600024O0003000300044O000300263O00122O000200183O00262900020076020100180004493O00760201001259000300034O00B6000400013O00122O000500C63O00122O000600C76O0004000600024O0003000300044O000400013O00122O000500C83O00122O000600C96O0004000600024O0003000300044O000300273O00122O000300036O000400013O00122O000500CA3O00122O000600CB6O0004000600024O0003000300044O000400013O00122O000500CC3O00122O000600CD6O0004000600024O0003000300044O000300283O00122O000200213O002E9D00CE003E020100CF0004493O003E02010026290002003E020100210004493O003E02010012F70001002F3O0004493O007D02010004493O003E0201002E9D00D1009A020100D00004493O009A0201000E1C00B9009A020100010004493O009A0201001259000200034O0041000300013O00122O000400D23O00122O000500D36O0003000500024O0002000200034O000300013O00122O000400D43O00122O000500D56O0003000500024O0002000200034O000200293O00122O000200036O000300013O00122O000400D63O00122O000500D76O0003000500024O0002000200034O000300013O00122O000400D83O00122O000500D96O0003000500024O0002000200034O0002002A3O00044O001F03010026062O01009E020100240004493O009E0201002E4400DB00DC020100DA0004493O00DC02010012F7000200013O002629000200BA020100010004493O00BA0201001259000300034O00B6000400013O00122O000500DC3O00122O000600DD6O0004000600024O0003000300044O000400013O00122O000500DE3O00122O000600DF6O0004000600024O0003000300044O0003002B3O00122O000300036O000400013O00122O000500E03O00122O000600E16O0004000600024O0003000300044O000400013O00122O000500E23O00122O000600E36O0004000600024O0003000300044O0003002C3O00122O000200183O002629000200D5020100180004493O00D50201001259000300034O00B6000400013O00122O000500E43O00122O000600E56O0004000600024O0003000300044O000400013O00122O000500E63O00122O000600E76O0004000600024O0003000300044O0003002D3O00122O000300036O000400013O00122O000500E83O00122O000600E96O0004000600024O0003000300044O000400013O00122O000500EA3O00122O000600EB6O0004000600024O0003000300044O0003002E3O00122O000200213O002E0C00EC00CAFF2O00EC0004493O009F02010026290002009F020100210004493O009F02010012F7000100583O0004493O00DC02010004493O009F020100262900010005000100010004493O000500010012F7000200013O002629000200E3020100210004493O00E302010012F7000100183O0004493O00050001002629000200FE020100180004493O00FE0201001259000300034O00B6000400013O00122O000500ED3O00122O000600EE6O0004000600024O0003000300044O000400013O00122O000500EF3O00122O000600F06O0004000600024O0003000300044O0003002F3O00122O000300036O000400013O00122O000500F13O00122O000600F26O0004000600024O0003000300044O000400013O00122O000500F33O00122O000600F46O0004000600024O0003000300044O000300303O00122O000200213O002E0C00F500E1FF2O00F50004493O00DF0201000E1C000100DF020100020004493O00DF0201001259000300034O00B6000400013O00122O000500F63O00122O000600F76O0004000600024O0003000300044O000400013O00122O000500F83O00122O000600F96O0004000600024O0003000300044O000300313O00122O000300036O000400013O00122O000500FA3O00122O000600FB6O0004000600024O0003000300044O000400013O00122O000500FC3O00122O000600FD6O0004000600024O0003000300044O000300323O00122O000200183O0004493O00DF02010004493O000500010004493O001F03010004493O000200012O00363O00017O00853O00028O00025O00208D40025O0008AF40026O001840030C3O004570696353652O74696E677303083O00C22059FBD0FF225E03053O00B991452D8F030A3O00BF0C1C94DD891618AACF03053O00BCEA7F79C603083O000B370797313C149003043O00E3585273031B3O00730DB3AA0D614716BBAB3572551A89A614766010B5AB067C5411A903063O0013237FDAC762026O00F03F03083O002FFE1EF615F50DF103043O00827C9B6A03133O00E5D9FFA2ACE478B6D4C7C1AEB5F349ACD4CCF303083O00DFB5AB96CFC3961C026O001C40027O0040025O00D0B140025O000CA54003083O0026F3E40D024812E503063O0026759690796B030D3O0018A8EB1B3EB8EB3429BAE0392803043O005A4DDB8E026O00084003083O00368C0400DD41581603073O003F65E97074B42F03133O00E235EE17EB22D13AE135ED3FC73AE311FD1EF303063O0056A35B8D729803083O00600E6067335D0C6703053O005A336B141303163O00ACFE86EA2E99E284E31A98F981EE338EF5A2FD3298E003053O005DED90E58F025O00C6A340025O0002AF40025O00108740025O0022A14003083O00863AF3325D8E05A603073O0062D55F874634E0030C3O00C9A6C57B47EEB1C07953D69303053O00349EC3A91703083O0049B926608F3B7C9803083O00EB1ADC5214E6551B030F3O00BFA4E5CE6798B3E0CC73AFB3E6D76403053O0014E8C189A203083O0011DAD1B2EE82106203083O001142BFA5C687EC7703143O003ABCAB32F1EBE9C21BBDAF1FD8FDE5D50EA1AD1603083O00B16FCFCE739F888C026O001440025O00FEB140025O008CAA4003083O00B052C4015431844403063O005FE337B0753D03143O003D7F315FA33D722646AE166A22479F197028639B03053O00CB781E432B025O00F49C40025O00389B40025O0014A340025O0008A44003083O0079B208C14882A45903073O00C32AD77CB521EC03113O00384A321B24EA1951123220F50857233F2903063O00986D39575E4503083O00CAD21E2OB7DC53BB03083O00C899B76AC3DEB23403103O0017E29A29417F3EE68538474E33EFA00D03063O003A5283E85D29025O0016B140025O0048B04003083O007F3FF7BA00423DF003053O00692C5A83CE03103O00CFF2BBB4072CFBE9B3B52O3FE9E59A8903063O005E9F80D2D968025O00E0B140025O004AB34003083O00D501352D45097DF503073O001A866441592C67030C3O00D0F03326AAF5E23E20A1D9D303053O00C49183504303083O002DB5121C11E619A303063O00887ED0666878030F3O005999CD46A1563C5F7B8FE951A0472D03083O003118EAAE23CF325D025O00E4A640025O0048844003083O003FF7E99C7802F5EE03053O00116C929DE803103O007ED011C02EA64AF71DE92A9C44D711E003063O00C82BA3748D4F026O001040025O00C89540025O00A06040026O007B40025O00F07E40025O00805040025O00C0964003083O0082B71A39FED4A7A203073O00C0D1D26E4D97BA03113O00C30F2DFCFBC6F51131FD2OCBF4062FC1CF03063O00A4806342899F03083O00338CFDAA0987EEAD03043O00DE60E98903143O009ABFA80A8CF1E5ABA0B32B87E7F5B494B5109DE303073O0090D9D3C77FE89303083O00CB2O2A3CDC4B055703083O0024984F5E48B52562030D3O00E2CB4208D2D44B2CC7CA4E31D003043O005FB7B827025O00708B40025O002CA940025O00C06F40025O00B2A940025O002EA540025O00088640025O0094A340025O004CAA4003083O008C332997B9FAE4AC03073O0083DF565DE3D09403113O00CE44B8B729BCE74082B909B0EE68B7B81C03063O00D583252OD67D03083O00152E31ABE8282C3603053O0081464B45DF030E3O0073D8F6C86FFB54CAFFDA74E640DF03063O008F26AB93891C025O00C05E40025O0050874003083O00E387ADE70AEDD3C303073O00B4B0E2D9936383030D3O00F2AA3B15D2B51C0FDABF3B2FE303043O0067B3D94F00A7012O0012F73O00014O00C3000100013O0026293O0002000100010004493O000200010012F7000100013O002E9D00020036000100030004493O0036000100262900010036000100040004493O003600010012F7000200013O00262900020025000100010004493O00250001001259000300054O00B6000400013O00122O000500063O00122O000600076O0004000600024O0003000300044O000400013O00122O000500083O00122O000600096O0004000600024O0003000300044O00035O00122O000300056O000400013O00122O0005000A3O00122O0006000B6O0004000600024O0003000300044O000400013O00122O0005000C3O00122O0006000D6O0004000600024O0003000300044O000300023O00122O0002000E3O0026290002000A0001000E0004493O000A0001001259000300054O00A1000400013O00122O0005000F3O00122O000600106O0004000600024O0003000300044O000400013O00122O000500113O00122O000600126O0004000600024O0003000300044O000300033O00122O000100133O00044O003600010004493O000A00010026062O01003A000100140004493O003A0001002E9D00150067000100160004493O006700010012F7000200013O0026290002004B0001000E0004493O004B0001001259000300054O00A1000400013O00122O000500173O00122O000600186O0004000600024O0003000300044O000400013O00122O000500193O00122O0006001A6O0004000600024O0003000300044O000300043O00122O0001001B3O00044O00670001000E1C0001003B000100020004493O003B0001001259000300054O00B6000400013O00122O0005001C3O00122O0006001D6O0004000600024O0003000300044O000400013O00122O0005001E3O00122O0006001F6O0004000600024O0003000300044O000300053O00122O000300056O000400013O00122O000500203O00122O000600216O0004000600024O0003000300044O000400013O00122O000500223O00122O000600236O0004000600024O0003000300044O000300063O00122O0002000E3O0004493O003B0001002629000100A00001000E0004493O00A000010012F7000200014O00C3000300033O0026060102006F000100010004493O006F0001002E9D0025006B000100240004493O006B00010012F7000300013O00260601030074000100010004493O00740001002E440027008D000100260004493O008D0001001259000400054O00B6000500013O00122O000600283O00122O000700296O0005000700024O0004000400054O000500013O00122O0006002A3O00122O0007002B6O0005000700024O0004000400054O000400073O00122O000400056O000500013O00122O0006002C3O00122O0007002D6O0005000700024O0004000400054O000500013O00122O0006002E3O00122O0007002F6O0005000700024O0004000400054O000400083O00122O0003000E3O002629000300700001000E0004493O00700001001259000400054O00A1000500013O00122O000600303O00122O000700316O0005000700024O0004000400054O000500013O00122O000600323O00122O000700336O0005000700024O0004000400054O000400093O00122O000100143O00044O00A000010004493O007000010004493O00A000010004493O006B0001002629000100DD000100340004493O00DD00010012F7000200013O002E9D003600B5000100350004493O00B50001002629000200B50001000E0004493O00B50001001259000300054O00A1000400013O00122O000500373O00122O000600386O0004000600024O0003000300044O000400013O00122O000500393O00122O0006003A6O0004000600024O0003000300044O0003000A3O00122O000100043O00044O00DD0001002629000200A3000100010004493O00A300010012F7000300013O002E44003C00BE0001003B0004493O00BE0001002629000300BE0001000E0004493O00BE00010012F70002000E3O0004493O00A30001002606010300C2000100010004493O00C20001002E44003E00B80001003D0004493O00B80001001259000400054O00B6000500013O00122O0006003F3O00122O000700406O0005000700024O0004000400054O000500013O00122O000600413O00122O000700426O0005000700024O0004000400054O0004000B3O00122O000400056O000500013O00122O000600433O00122O000700446O0005000700024O0004000400054O000500013O00122O000600453O00122O000700466O0005000700024O0004000400054O0004000C3O00122O0003000E3O0004493O00B800010004493O00A30001002E9D004800EE000100470004493O00EE0001002629000100EE000100130004493O00EE0001001259000200054O0077000300013O00122O000400493O00122O0005004A6O0003000500024O0002000200034O000300013O00122O0004004B3O00122O0005004C6O0003000500024O0002000200034O0002000D3O00044O00A62O01002629000100212O01001B0004493O00212O010012F7000200013O002606010200F5000100010004493O00F50001002E44004E000E2O01004D0004493O000E2O01001259000300054O00B6000400013O00122O0005004F3O00122O000600506O0004000600024O0003000300044O000400013O00122O000500513O00122O000600526O0004000600024O0003000300044O0003000E3O00122O000300056O000400013O00122O000500533O00122O000600546O0004000600024O0003000300044O000400013O00122O000500553O00122O000600566O0004000600024O0003000300044O0003000F3O00122O0002000E3O002E44005800F1000100570004493O00F10001002629000200F10001000E0004493O00F10001001259000300054O00A1000400013O00122O000500593O00122O0006005A6O0004000600024O0003000300044O000400013O00122O0005005B3O00122O0006005C6O0004000600024O0003000300044O000300103O00122O0001005D3O00044O00212O010004493O00F100010026062O0100252O0100010004493O00252O01002E44005E005C2O01005F0004493O005C2O010012F7000200014O00C3000300033O0026060102002B2O0100010004493O002B2O01002E0C006000FEFF2O00610004493O00272O010012F7000300013O002E44006200492O0100630004493O00492O01002629000300492O0100010004493O00492O01001259000400054O00B6000500013O00122O000600643O00122O000700656O0005000700024O0004000400054O000500013O00122O000600663O00122O000700676O0005000700024O0004000400054O000400113O00122O000400056O000500013O00122O000600683O00122O000700696O0005000700024O0004000400054O000500013O00122O0006006A3O00122O0007006B6O0005000700024O0004000400054O000400123O00122O0003000E3O0026290003002C2O01000E0004493O002C2O01001259000400054O00A1000500013O00122O0006006C3O00122O0007006D6O0005000700024O0004000400054O000500013O00122O0006006E3O00122O0007006F6O0005000700024O0004000400054O000400133O00122O0001000E3O00044O005C2O010004493O002C2O010004493O005C2O010004493O00272O010026062O0100602O01005D0004493O00602O01002E9D00710005000100700004493O000500010012F7000200014O00C3000300033O002606010200662O0100010004493O00662O01002E9D007300622O0100720004493O00622O010012F7000300013O0026060103006B2O0100010004493O006B2O01002E9D0074008E2O0100750004493O008E2O010012F7000400013O002606010400702O0100010004493O00702O01002E9D007700892O0100760004493O00892O01001259000500054O00B6000600013O00122O000700783O00122O000800796O0006000800024O0005000500064O000600013O00122O0007007A3O00122O0008007B6O0006000800024O0005000500064O000500143O00122O000500056O000600013O00122O0007007C3O00122O0008007D6O0006000800024O0005000500064O000600013O00122O0007007E3O00122O0008007F6O0006000800024O0005000500064O000500153O00122O0004000E3O0026290004006C2O01000E0004493O006C2O010012F70003000E3O0004493O008E2O010004493O006C2O01002606010300922O01000E0004493O00922O01002E44008100672O0100800004493O00672O01001259000400054O00A1000500013O00122O000600823O00122O000700836O0005000700024O0004000400054O000500013O00122O000600843O00122O000700856O0005000700024O0004000400054O000400163O00122O000100343O00044O000500010004493O00672O010004493O000500010004493O00622O010004493O000500010004493O00A62O010004493O000200012O00363O00017O00C63O00028O00025O005CB140025O00F08B40026O00F03F026O000840030F3O00412O66656374696E67436F6D626174025O00809540025O00388240025O00F6A240025O002EA340027O0040025O0082AA40025O0052A540025O004FB040025O00E8B140025O00789D40025O004C9040025O00D0A140025O00D88440025O00C05140030D3O00546172676574497356616C6964025O0082B140025O00D2A540025O00888140025O00A7B140025O00288540025O00689640025O0016A640025O00F8A340030C3O00F4D85535F417C6D4C45535E603073O0095A4AD275C926E03073O004973526561647903173O0044697370652O6C61626C65467269656E646C79556E6974030C3O0050757269667953706972697403143O00E33202161C02CC3400160812E7671416090BF62B03063O007B9347707F7A03053O00FCD890764303053O0026ACADE21103093O00497343617374696E67030C3O0049734368612O6E656C696E6703103O00556E69744861734D6167696342752O66025O0044A840025O0044B34003053O005075726765030E3O0049735370652O6C496E52616E6765030C3O005D043EE8485128E65E0129E303043O008F2D714C025O00049340025O00707F40025O00907B40025O0007B340025O004EAD40025O00D88640025O00A6A340025O00309C40025O0080A740025O00109E40030C3O00B1D343FBCF45B2D658E0C04803063O003CE1A63192A9025O00707240030B3O000A1F3D3E093427172A260503063O00674F7E4F4A61025O00DCB240025O00F49A40025O0069B040025O00CCA040030C3O0053686F756C6452657475726E03183O00466F637573556E69745265667265736861626C6542752O66030B3O004561727468536869656C64026O002E40026O00444003043O008E5EFD5803063O007ADA1FB3133E030F3O0042752O665265667265736861626C65030D3O00556E697447726F7570526F6C6503043O0087F7E3EA03073O0025D3B6ADA1A9C1025O0008A840025O003AB240025O00AC9F40025O00ACA74003093O00466F637573556E6974025O005AA940025O00DCAB40025O0086A440025O00D07740025O00B07140025O00C0B140025O00508340025O00D8AD4003063O0045786973747303093O00497341506C61796572030D3O004973446561644F7247686F737403093O0043616E412O7461636B025O00BFB040026O005F4003163O0044656164467269656E646C79556E697473436F756E74025O0012A440025O009CAE40030F3O00416E6365737472616C566973696F6E03083O0042752O66446F776E03163O0053706972697477616C6B657273477261636542752O66025O00A4A840025O00B89F4003103O00F6344EDC3B6FABF63672CF2168B0F83403073O00D9975A2DB9481B030F3O00416E6365737472616C53706972697403093O004973496E52616E6765025O0062AD40025O0050854003103O00C272E41745D76EE61E69D06CEE005FD703053O0036A31C8772025O002OA040025O00208A40025O0072A240025O009C904003103O00426F2O73466967687452656D61696E73024O0080B3C540025O00F89B40025O002AA940030C3O00466967687452656D61696E7303103O00456E656D69657331307953706C61736803093O00496E74652O7275707403093O0057696E645368656172026O003E40025O006BB140025O0016AE40030F3O00496E74652O72757074437572736F7203123O0057696E6453686561724D6F7573656F76657203093O004D6F7573656F76657203173O00496E74652O72757074576974685374756E437572736F72030E3O00436170616369746F72546F74656D03143O00436170616369746F72546F74656D437572736F72025O0032A740025O00109D40025O0096A040025O0080434003043O000AD4498A03063O001F48BB3DE22E03093O00E70345D7496D2DD52O03073O0044A36623B2271E03103O004865616C746850657263656E74616765025O00A8A040025O00206940030E3O008E62D3CA0CA78718BF7CEDC615B003083O0071DE10BAA763D5E303133O005072696D6F726469616C57617665466F637573025O00F2B040025O007DB14003143O003E1CF2FB211C2OFF2F02C4E12F18FEB6230FF2F803043O00964E6E9B03043O00A7CA33E903083O0020E5A54781C47EDF03093O00EC8FC2848FC6CA9FC103063O00B5A3E9A42OE1025O00109B40025O00B2AB40025O00949140026O00504003113O00446562752O665265667265736861626C65030A3O00466C616D6553686F636B026O002440030E3O006099377A5F993A7E51870976468E03043O001730EB5E025O001EA940025O004AAF40030E3O005072696D6F726469616C5761766503143O006CC8D1505821D675DBD4624032C4799AD55C5E3D03073O00B21CBAB83D3753025O00DEA240025O00C88440030C3O004570696353652O74696E677303073O0064F601B8537AEA03083O001A309966DF3F1F992O033O000D4FEE03043O009362208D03073O002C4CE4CD0A535803073O002B782383AA66362O033O0057029403073O00E43466E7D6C5D0025O00049140025O003AA140025O00C4A040025O00A0834003073O009EBEEAE07BEB5403073O0027CAD18D87178E2O033O00FB231A03063O00989F53696A52025O00AEAA40025O0061B14003073O002AEF72CDE68E0A03083O00B67E8015AA8AEB7903063O008FD326F6831F03083O0066EBBA5586E6735003073O00630339587ED13103073O0042376C5E3F12B403073O001C88843B2E571303063O003974EDE55747006B032O0012F73O00014O00C3000100023O000E350001000600013O0004493O00060001002E9D00020009000100030004493O000900010012F7000100014O00C3000200023O0012F73O00043O0026293O0002000100040004493O000200010026290001000A2O0100050004493O000A2O012O00E500035O00067D00030015000100010004493O001500012O00E5000300013O0020930003000300062O006900030002000200065C0003006A03013O0004493O006A03010012F7000300014O00C3000400053O002E440008003O0100070004493O003O010026290003003O0100040004493O003O010026060104001F000100010004493O001F0001002E0C000900FEFF2O000A0004493O001B00010012F7000500013O00262900050063000100040004493O006300010012F7000600014O00C3000700073O00262900060024000100010004493O002400010012F7000700013O0026290007002B000100040004493O002B00010012F70005000B3O0004493O0063000100262900070027000100010004493O002700010012F7000800013O00262900080032000100040004493O003200010012F7000700043O0004493O00270001002E9D000D002E0001000C0004493O002E00010026290008002E000100010004493O002E000100065C0002003900013O0004493O003900012O005D000200024O00E5000900023O00065C0009005E00013O0004493O005E00010012F7000900013O00262900090052000100010004493O005200010012F7000A00013O002629000A0044000100040004493O004400010012F7000900043O0004493O00520001002E0C000E00FCFF2O000E0004493O00400001000E1C000100400001000A0004493O004000012O00E5000B00034O00DD000B000100022O00EA0002000B3O002E44001000500001000F0004493O0050000100065C0002005000013O0004493O005000012O005D000200023O0012F7000A00043O0004493O0040000100260601090056000100040004493O00560001002E9D0012003D000100110004493O003D00012O00E5000A00044O00DD000A000100022O00EA0002000A3O00065C0002005E00013O0004493O005E00012O005D000200023O0004493O005E00010004493O003D00010012F7000800043O0004493O002E00010004493O002700010004493O006300010004493O00240001002606010500670001000B0004493O00670001002E4400130087000100140004493O008700012O00E5000600053O00065C0006006A03013O0004493O006A03012O00E5000600063O0020780006000600152O00DD00060001000200067D00060071000100010004493O00710001002E440016006A030100170004493O006A03010012F7000600014O00C3000700073O000E1C00010073000100060004493O007300010012F7000700013O002E4400180076000100190004493O0076000100262900070076000100010004493O007600012O00E5000800074O00DD0008000100022O00EA000200083O00067D00020081000100010004493O00810001002E0C001A00EB0201001B0004493O006A03012O005D000200023O0004493O006A03010004493O007600010004493O006A03010004493O007300010004493O006A030100262900050020000100010004493O002000010012F7000600014O00C3000700073O0026290006008B000100010004493O008B00010012F7000700013O00262900070092000100040004493O009200010012F7000500043O0004493O002000010026290007008E000100010004493O008E00012O00E5000800083O00065C000800F600013O0004493O00F600010012F7000800014O00C3000900093O002E0C001C3O0001001C0004493O0099000100262900080099000100010004493O009900010012F7000900013O002E0C001D3O0001001D0004493O009E0001000E1C0001009E000100090004493O009E00012O00E5000A00093O00065C000A00C200013O0004493O00C200012O00E5000A000A3O00065C000A00C200013O0004493O00C200012O00E5000A000B4O00DB000B000C3O00122O000C001E3O00122O000D001F6O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000A00C200013O0004493O00C200012O00E5000A00063O002078000A000A00212O00DD000A0001000200065C000A00C200013O0004493O00C200012O00E5000A000D4O00E5000B000E3O002078000B000B00222O0069000A0002000200065C000A00C200013O0004493O00C200012O00E5000A000C3O0012F7000B00233O0012F7000C00244O009B000A000C4O00B3000A6O00E5000A000F3O00065C000A00F600013O0004493O00F600012O00E5000A000B4O00DB000B000C3O00122O000C00253O00122O000D00266O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000A00DF00013O0004493O00DF00012O00E5000A00013O002093000A000A00272O0069000A0002000200067D000A00DF000100010004493O00DF00012O00E5000A00013O002093000A000A00282O0069000A0002000200067D000A00DF000100010004493O00DF00012O00E5000A00063O002078000A000A00292O00E5000B00104O0069000A0002000200067D000A00E1000100010004493O00E10001002E9D002B00F60001002A0004493O00F600012O00E5000A000D4O00CA000B000B3O00202O000B000B002C4O000C00103O00202O000C000C002D4O000E000B3O00202O000E000E002C4O000C000E00024O000C000C6O000A000C000200062O000A00F600013O0004493O00F600012O00E5000A000C3O0012F2000B002E3O00122O000C002F6O000A000C6O000A5O00044O00F600010004493O009E00010004493O00F600010004493O009900012O00E5000800114O00DD0008000100022O00EA000200083O0012F7000700043O0004493O008E00010004493O002000010004493O008B00010004493O002000010004493O006A03010004493O001B00010004493O006A0301002606010300052O0100010004493O00052O01002E9D00300017000100310004493O001700010012F7000400014O00C3000500053O0012F7000300043O0004493O001700010004493O006A03010026062O01000E2O01000B0004493O000E2O01002E9D00330008030100320004493O000803012O00E5000300013O0020930003000300062O006900030002000200067D000300162O0100010004493O00162O012O00E500035O00065C000300D02O013O0004493O00D02O010012F7000300014O00C3000400063O002E440035001F2O0100340004493O001F2O01000E1C0001001F2O0100030004493O001F2O010012F7000400014O00C3000500053O0012F7000300043O002629000300182O0100040004493O00182O012O00C3000600063O002606010400262O0100040004493O00262O01002E44003600BC2O0100370004493O00BC2O01002E44003900872O0100380004493O00872O01002629000500872O0100010004493O00872O010012F7000700014O00C3000800083O0026290007002C2O0100010004493O002C2O010012F7000800013O002629000800802O0100010004493O00802O010012F7000900013O0026290009007B2O0100010004493O007B2O012O00E5000A000A3O0006A5000600422O01000A0004493O00422O012O00E5000A000B4O0099000B000C3O00122O000C003A3O00122O000D003B6O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000600422O01000A0004493O00422O012O00E5000600083O002E0C003C00380001003C0004493O007A2O012O00E5000A000B4O00DB000B000C3O00122O000C003D3O00122O000D003E6O000B000D00024O000A000A000B00202O000A000A00204O000A0002000200062O000A007A2O013O0004493O007A2O012O00E5000A00123O00065C000A007A2O013O0004493O007A2O010012F7000A00014O00C3000B000C3O002E9D0040005A2O01003F0004493O005A2O01002629000A005A2O0100010004493O005A2O010012F7000B00014O00C3000C000C3O0012F7000A00043O002606010A005E2O0100040004493O005E2O01002E44004100532O0100420004493O00532O01002629000B005E2O0100010004493O005E2O010012F7000C00013O002629000C00612O0100010004493O00612O012O00E5000D00063O00207C000D000D00444O000E000B3O00202O000E000E004500122O000F00463O00122O001000476O0011000C3O00122O001200483O00122O001300496O001100136O000D3O000200122O000D00433O00122O000D00433O00062O000D007A2O013O0004493O007A2O01001259000D00434O005D000D00023O0004493O007A2O010004493O00612O010004493O007A2O010004493O005E2O010004493O007A2O010004493O00532O010012F7000900043O002629000900322O0100040004493O00322O010012F7000800043O0004493O00802O010004493O00322O010026290008002F2O0100040004493O002F2O010012F7000500043O0004493O00872O010004493O002F2O010004493O00872O010004493O002C2O01002629000500262O0100040004493O00262O012O00E5000700093O00207F00070007004A4O0009000B3O00202O0009000900454O00070009000200062O0007009F2O013O0004493O009F2O012O00E5000700063O00209400070007004B4O000800096O0007000200024O0008000C3O00122O0009004C3O00122O000A004D6O0008000A000200062O0007009F2O0100080004493O009F2O012O00E5000700123O00065C0007009F2O013O0004493O009F2O01002E9D004F00D02O01004E0004493O00D02O010012F7000700014O00C3000800083O002606010700A52O0100010004493O00A52O01002E9D005100A12O0100500004493O00A12O010012F7000800013O002629000800A62O0100010004493O00A62O012O00E5000900063O0020A00009000900524O000A00066O000B000D6O0009000D000200122O000900433O002E2O005300D02O0100540004493O00D02O01001259000900433O00065C000900D02O013O0004493O00D02O01001259000900434O005D000900023O0004493O00D02O010004493O00A62O010004493O00D02O010004493O00A12O010004493O00D02O010004493O00262O010004493O00D02O01002606010400C02O0100010004493O00C02O01002E9D005500222O0100560004493O00222O010012F7000700013O002E44005700C82O0100580004493O00C82O01000E1C000100C82O0100070004493O00C82O010012F7000500014O00C3000600063O0012F7000700043O002629000700C12O0100040004493O00C12O010012F7000400043O0004493O00222O010004493O00C12O010004493O00222O010004493O00D02O010004493O00182O012O00C3000200023O002E440059003E0201005A0004493O003E02012O00E5000300013O0020930003000300062O006900030002000200067D0003003E020100010004493O003E02012O00E500035O00065C0003003E02013O0004493O003E02012O00E5000300103O00065C0003003E02013O0004493O003E02012O00E5000300103O00209300030003005B2O006900030002000200065C0003003E02013O0004493O003E02012O00E5000300103O00209300030003005C2O006900030002000200065C0003003E02013O0004493O003E02012O00E5000300103O00209300030003005D2O006900030002000200065C0003003E02013O0004493O003E02012O00E5000300013O00209300030003005E2O00E5000500104O004200030005000200067D0003003E020100010004493O003E02010012F7000300014O00C3000400053O002E9D006000360201005F0004493O0036020100262900030036020100040004493O00360201002629000400F92O0100010004493O00F92O012O00E5000600063O0020070106000600614O0006000100024O000500066O000600013O00202O0006000600064O00060002000200062O0006003E02013O0004493O003E0201002E9D0062001C020100630004493O001C0201000E2F0004001C020100050004493O001C02012O00E50006000D4O002O0107000B3O00202O0007000700644O000800086O000900013O00202O0009000900654O000B000B3O00202O000B000B00664O0009000B6O00063O000200062O00060016020100010004493O00160201002E9D0067003E020100680004493O003E02012O00E50006000C3O0012F2000700693O00122O0008006A6O000600086O00065O00044O003E02012O00E50006000D4O00870007000B3O00202O00070007006B4O000800103O00202O00080008006C00122O000A00476O0008000A00024O000800086O000900013O00202O0009000900654O000B000B3O00202O000B000B00664O0009000B6O00063O000200062O0006002E020100010004493O002E0201002E9D006D003E0201006E0004493O003E02012O00E50006000C3O0012F20007006F3O00122O000800706O000600086O00065O00044O003E02010004493O00F92O010004493O003E0201002E44007200F52O0100710004493O00F52O01002629000300F52O0100010004493O00F52O010012F7000400014O00C3000500053O0012F7000300043O0004493O00F52O012O00E5000300013O0020930003000300062O006900030002000200065C0003004802013O0004493O004802012O00E5000300063O0020780003000300152O00DD00030001000200067D0003004A020100010004493O004A0201002E9D00730007030100740004493O000703012O00E5000300143O0020F60003000300754O000400046O000500016O0003000500024O000300136O000300136O000300156O000300153O00262O00030057020100760004493O00570201002E9D0078005D020100770004493O005D02012O00E5000300143O00202E00030003007900122O0004007A6O00058O0003000500024O000300154O00E5000300063O00201900030003007B4O0004000B3O00202O00040004007C00122O0005007D6O000600016O000300060002002E2O007F00690201007E0004493O0069020100065C0003006902013O0004493O006902012O005D000300024O00E5000400063O0020D10004000400804O0005000B3O00202O00050005007C4O0006000E3O00202O00060006008100122O0007007D6O000800013O00122O000900826O0004000900024O000300043O00062O0003007702013O0004493O007702012O005D000300024O00E5000400063O00203C0004000400834O0005000B3O00202O0005000500844O0006000E3O00202O00060006008500122O0007007D6O000800083O00122O000900826O0004000900024O000300043O00062O0003008502013O0004493O008502012O005D000300024O00E5000400164O00DD0004000100022O00EA000200043O00065C0002008B02013O0004493O008B02012O005D000200024O00E5000400174O00DD0004000100022O00EA000200043O00065C0002009102013O0004493O009102012O005D000200024O00E5000400183O00065C0004009702013O0004493O009702012O00E5000400193O00065C0004000703013O0004493O000703010012F7000400014O00C3000500053O0026060104009D020100010004493O009D0201002E9D00860099020100870004493O009902010012F7000500013O000E35000100A2020100050004493O00A20201002E0C008800FEFF2O00890004493O009E02012O00E50006001A4O00630007000C3O00122O0008008A3O00122O0009008B6O00070009000200062O000600B0020100070004493O00B002012O00E50006001A4O000D0107000C3O00122O0008008C3O00122O0009008D6O00070009000200062O000600D0020100070004493O00D002012O00E5000600093O00209300060006008E2O00690006000200022O00E50007001B3O0006880007001B000100060004493O00D00201002E9D008F00B9020100900004493O00B902010004493O00D002012O00E50006000B4O00DB0007000C3O00122O000800913O00122O000900926O0007000900024O00060006000700202O0006000600204O00060002000200062O000600D002013O0004493O00D002012O00E50006000D4O00E50007000E3O0020780007000700932O006900060002000200067D000600CB020100010004493O00CB0201002E9D009500D0020100940004493O00D002012O00E50006000C3O0012F7000700963O0012F7000800974O009B000600084O00B300066O00E50006001A4O00630007000C3O00122O000800983O00122O000900996O00070009000200062O000600E0020100070004493O00E002012O00E50006001A4O00630007000C3O00122O0008009A3O00122O0009009B6O00070009000200062O000600E0020100070004493O00E00201002E9D009D00070301009C0004493O00070301002E9D009F00070301009E0004493O000703012O00E5000600103O00207F0006000600A04O0008000B3O00202O0008000800A14O00060008000200062O0006000703013O0004493O000703012O00E5000600153O000E2F00A20007030100060004493O000703012O00E50006000B4O00530007000C3O00122O000800A33O00122O000900A46O0007000900024O00060006000700202O0006000600204O00060002000200062O000600F8020100010004493O00F80201002E4400A60007030100A50004493O000703012O00E50006000D4O00E50007000B3O0020780007000700A72O006900060002000200065C0006000703013O0004493O000703012O00E50006000C3O0012F2000700A83O00122O000800A96O000600086O00065O00044O000703010004493O009E02010004493O000703010004493O009902010012F7000100053O002E4400AB0029030100AA0004493O00290301000E1C00010029030100010004493O002903012O00E50003001C4O00100103000100014O0003001D6O00030001000100122O000300AC6O0004000C3O00122O000500AD3O00122O000600AE6O0004000600024O0003000300044O0004000C3O00122O000500AF3O00122O000600B06O0004000600024O0003000300044O00035O00122O000300AC6O0004000C3O00122O000500B13O00122O000600B26O0004000600024O0003000300044O0004000C3O00122O000500B33O00122O000600B46O0004000600024O0003000300044O000300193O00122O000100043O0026062O01002D030100040004493O002D0301002E4400B6000B000100B50004493O000B00010012F7000300013O00260601030032030100040004493O00320301002E9D00B70047030100B80004493O00470301001259000400AC4O006E0005000C3O00122O000600B93O00122O000700BA6O0005000700024O0004000400054O0005000C3O00122O000600BB3O00122O000700BC6O0005000700024O0004000400054O000400056O000400013O00202O00040004005D4O00040002000200062O00040045030100010004493O00450301002E9D00BE0046030100BD0004493O004603012O00363O00013O0012F70003000B3O000E1C000B004B030100030004493O004B03010012F70001000B3O0004493O000B00010026290003002E030100010004493O002E0301001259000400AC4O00B60005000C3O00122O000600BF3O00122O000700C06O0005000700024O0004000400054O0005000C3O00122O000600C13O00122O000700C26O0005000700024O0004000400054O000400083O00122O000400AC6O0005000C3O00122O000600C33O00122O000700C46O0005000700024O0004000400054O0005000C3O00122O000600C53O00122O000700C66O0005000700024O0004000400054O000400023O00122O000300043O0004493O002E03010004493O000B00010004493O006A03010004493O000200012O00363O00017O000F3O00028O00026O00F03F025O00949B40025O00D6B040025O00508C40026O00694003053O005072696E7403243O008ABD0F28B7AA1D28B1B7127C8BB01D31B9B65C2EB7AC1D28B1B7127CBAA15C19A8B11F7203043O005C2OD87C026O00A840025O00AAA040030C3O004570696353652O74696E6773030C3O00536574757056657273696F6E03273O006937BF54F24933B849F255729F48FC5633A200C51B24EC11AD1560E210AD1B10B500DF543DA16B03053O009D3B52CC2000363O0012F73O00014O00C3000100023O0026293O002F000100020004493O002F000100262900010004000100010004493O000400010012F7000200013O0026060102000B000100010004493O000B0001002E4400040021000100030004493O002100010012F7000300013O002E440006001A000100050004493O001A00010026290003001A000100010004493O001A00012O00E500046O005E0004000100014O000400013O00202O0004000400074O000500023O00122O000600083O00122O000700096O000500076O00043O000100122O000300023O0026060103001E000100020004493O001E0001002E9D000A000C0001000B0004493O000C00010012F7000200023O0004493O002100010004493O000C000100262900020007000100020004493O000700010012590003000C3O00204A00030003000D4O000400023O00122O0005000E3O00122O0006000F6O000400066O00033O000100044O003500010004493O000700010004493O003500010004493O000400010004493O003500010026293O0002000100010004493O000200010012F7000100014O00C3000200023O0012F73O00023O0004493O000200012O00363O00017O00", GetFEnv(), ...);

