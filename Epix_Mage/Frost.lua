local obf_stringchar = string.char;
local obf_stringbyte = string.byte;
local obf_stringsub = string.sub;
local obf_bitlib = bit32 or bit;
local obf_XOR = obf_bitlib.bxor;
local obf_tableconcat = table.concat;
local obf_tableinsert = table.insert;
local function LUAOBFUSACTOR_DECRYPT_STR_0(LUAOBFUSACTOR_STR, LUAOBFUSACTOR_KEY)
	local result = {};
	for i = 1, #LUAOBFUSACTOR_STR do
		obf_tableinsert(result, obf_stringchar(obf_XOR(obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_STR, i, i + 1)), obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_KEY, 1 + (i % #LUAOBFUSACTOR_KEY), 1 + (i % #LUAOBFUSACTOR_KEY) + 1))) % 256));
	end
	return obf_tableconcat(result);
end
local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((4922 > 481) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (1240 > 1559)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((566 == 566) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\150\198\25\212\252\253\55\233\168\211\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\218\88\164\83\239", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\133\114\105\59\22\91\236\70\186", "\35\200\29\28\72\115\20\154")];
	local v18 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\41\186\197", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\136\70\204\172\54", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\100\87\12\49\64\113\16\32\69\78", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\149\215\210\7", "\75\220\163\183\106\98")];
	local v22 = EpicLib;
	local v23 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35", "\185\98\218\235\87")];
	local v24 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\25\211\41\155\58\226\57\154\58\206\62", "\232\73\161\76")];
	local v26 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\150\216\65\79\17", "\126\219\185\34\61")];
	local v27 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\46\199\80\118", "\135\108\174\62\18\30\23\147")];
	local v28 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\3\180", "\75\103\118\217")];
	local v29 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\225\170\194", "\174\103\142\197")];
	local v30 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\91\41\71", "\152\54\72\63\88\69\62")];
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36;
	local v37;
	local v38;
	local v39;
	local v40;
	local v41;
	local v42;
	local v43;
	local v44;
	local v45;
	local v46;
	local v47;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local v63;
	local v64;
	local v65;
	local v66;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\249\197\233\89", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\76\10\58\51", "\114\56\62\101\73\71\141")];
	local v99 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\149\232\220\193", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\244\62\161\178", "\107\178\134\81\210\198\158")];
	local v100 = v26[LUAOBFUSACTOR_DECRYPT_STR_0("\21\15\133\195", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\29\141\228\222", "\170\163\111\226\151")];
	local v101 = {};
	local v102, v103;
	local v104;
	local v105;
	local v106 = 0;
	local v107 = 0;
	local v108 = 15;
	local v109 = 11111;
	local v110 = 11111;
	local v111;
	local v112 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\50\63\191\53\65\57\58", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\58\200\0\254\142\34\200", "\135\225\76\173\114")];
	local function v113()
		if ((3921 >= 3009) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\232\181\191\186\184\132\15\255\171\181", "\199\122\141\216\208\204\221")]:IsAvailable()) then
			v112[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\210\168\223\5\246\126\229", "\150\205\189\112\144\24")] = v112[LUAOBFUSACTOR_DECRYPT_STR_0("\1\141\172\92\1\132\29\17\39\136\186\111\17\154\2\21\1\129\189\89\2\142\2", "\112\69\228\223\44\100\232\113")];
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\245\60\51\250\128\89\185\228\51\38\234\147\78\185\231\47\34\240\159\93\170\253\37\38\231\159\83\168\235\60\47\242\152\91\163\240", "\230\180\127\103\179\214\28"));
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\170\23\80\92\225\79\207\158\7", "\128\236\101\63\38\132\33")]:RegisterInFlightEffect(84721);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\138\187\30\94\179\229\224\190\171", "\175\204\201\113\36\214\139")]:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\222\58\198\1\73\227\39\222", "\100\39\172\85\188")]:RegisterInFlight();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\129\93\152\178\29\136\92\134\179\3\136\84\149\191\26\131\71\141\161\17", "\83\205\24\217\224"));
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\215\194\46\242\199\194\49\242", "\93\134\165\173")]:RegisterInFlightEffect(228597);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\152\224\206\209\46\204\189\114\170", "\30\222\146\161\162\90\174\210")]:RegisterInFlight();
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\195\66\101\24\247\87", "\106\133\46\16")]:RegisterInFlightEffect(228354);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\44\102\238\72\89", "\32\56\64\19\156\58")]:RegisterInFlight();
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\115\203\224\122\91\252\131\95", "\224\58\168\133\54\58\146")]:RegisterInFlightEffect(228598);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\112\85\78\209\116\136\132\14", "\107\57\54\43\157\21\230\231")]:RegisterInFlight();
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\252\135\16\246\176\221\195\232\155\24\254\188", "\175\187\235\113\149\217\188")]:RegisterInFlightEffect(228600);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\163\128\79\234\120\116\15\191\136\71\230", "\24\92\207\225\44\131\25")]:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v132 = 0;
		while true do
			if ((2063 >= 1648) and (1 == v132)) then
				v106 = 0;
				break;
			end
			if ((1066 >= 452) and (v132 == 0)) then
				v109 = 11111;
				v110 = 11111;
				v132 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\123\255\153\117\62\79\116\225\157\107\62\83\116\246\150\109\57\81\110\247", "\29\43\179\216\44\123"));
	local function v114(v133)
		local v134 = 0;
		while true do
			if ((4974 >= 2655) and (v134 == 0)) then
				if ((v133 == nil) or (2721 <= 907)) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < 73);
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v135)
		local v136 = 0;
		local v137;
		while true do
			if ((4437 >= 3031) and (v136 == 1)) then
				for v211, v212 in pairs(v135) do
					v137 = v137 + v212:DebuffStack(v98.WintersChillDebuff);
				end
				return v137;
			end
			if ((v136 == 0) or (4470 < 2949)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\138\208\46\88\184\203\51\111\181\208\44\64\153\220\34\89\187\223", "\44\221\185\64")]:AuraActiveCount() == 0) or (1580 == 2426)) then
					return 0;
				end
				v137 = 0;
				v136 = 1;
			end
		end
	end
	local function v117(v138)
		return (v138:DebuffStack(v98.WintersChillDebuff));
	end
	local function v118(v139)
		return (v139:DebuffDown(v98.WintersChillDebuff));
	end
	local function v119()
		local v140 = 0;
		while true do
			if ((2 == v140) or (3711 == 503)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\85\142\60\5\119\149\7\26\121\128\43", "\119\24\231\78")]:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or (420 == 4318)) then
					if (v24(v98.MirrorImage) or (4158 <= 33)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\36\183\88\211\82\46\139\32\164\77\217\0\21\135\43\160\68\207\73\7\135\109\240", "\113\226\77\197\42\188\32");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\29\4\241\180\46\19\230\156\52\0\253\166\51\20\253\185\51\2\237", "\213\90\118\148")]:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or (99 > 4744)) then
					if ((4341 == 4341) and v24(v98.GreaterInvisibility)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\60\177\87\89\94\60\139\95\67\77\39\167\95\79\82\34\189\66\84\27\42\177\80\72\85\61\189\64\72\27\120", "\45\59\78\212\54");
					end
				end
				v140 = 3;
			end
			if ((255 <= 1596) and (v140 == 3)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\49\90\151\142\148\26\164\253\21", "\144\112\54\227\235\230\78\205")]:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or (4433 < 1635)) then
					if (v24(v98.AlterTime) or (4300 < 3244)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\36\27\249\194\100\167\33\2\249\144\95\182\46\10\242\195\82\165\45\79\171", "\59\211\72\111\156\176");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\102\130\226\33\90\143\240\57\65\137\230", "\77\46\231\131")]:IsReady() and v85 and (v14:HealthPercentage() <= v87)) or (3534 > 4677)) then
					if (v24(v100.Healthstone) or (4859 < 2999)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\81\183\76\174\92\165\84\181\90\179\0\190\81\176\69\180\71\191\86\191", "\32\218\52\214");
					end
				end
				v140 = 4;
			end
			if ((4726 > 2407) and (v140 == 1)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\131\203\8\232\202\175\211\213\171\196\8\197\209", "\129\202\168\109\171\165\195\183")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\91\50\251\209\24\226\3\90\62\212\215\0\255", "\134\66\56\87\184\190\116")]:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or (1284 > 3669)) then
					if ((1117 < 2549) and v24(v98.IceColdAbility)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\50\12\132\26\228\45\49\124\53\12\189\28\229\50\60\42\52\73\232", "\85\92\81\105\219\121\139\65");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\176\85\103\112\208\254\184", "\191\157\211\48\37\28")]:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or (2851 > 4774)) then
					if ((1031 < 3848) and v24(v98.IceBlock)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\28\241\35\56\211\16\247\23\122\219\26\242\25\52\204\22\226\25\122\139", "\90\191\127\148\124");
					end
				end
				v140 = 2;
			end
			if ((1854 > 903) and (v140 == 0)) then
				if ((4663 > 1860) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\228\77\125\114\19\245\65\90\97", "\19\97\135\40\63")]:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) then
					if (v24(v98.IceBarrier) or (3053 <= 469)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\95\54\4\45\48\188\78\58\62\61\113\170\89\53\62\33\34\167\74\54\123\126", "\81\206\60\83\91\79");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\99\170\195\97\13\194\95\182\71\174\194", "\196\46\203\176\18\79\163\45")]:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 2)) or (540 >= 1869)) then
					if ((3292 == 3292) and v24(v98.MassBarrier)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\35\109\13\27\249\238\170\48\119\27\54\187\235\189\36\123\16\55\242\249\189\98\44", "\143\216\66\30\126\68\155");
					end
				end
				v140 = 1;
			end
			if ((1038 <= 2645) and (v140 == 4)) then
				if ((v84 and (v14:HealthPercentage() <= v86)) or (3230 < 2525)) then
					local v213 = 0;
					while true do
						if ((v213 == 0) or (2400 > 4083)) then
							if ((v88 == LUAOBFUSACTOR_DECRYPT_STR_0("\124\18\55\186\244\163\77\83\64\16\113\128\244\177\73\83\64\16\113\152\254\164\76\85\64", "\58\46\119\81\200\145\208\37")) or (2745 > 4359)) then
								if ((172 <= 1810) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\25\137\54\190\172\174\62\34\130\55\132\172\188\58\34\130\55\156\166\169\63\36\130", "\86\75\236\80\204\201\221")]:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or (492 >= 4959)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\96\68\113\151\251\152\122\72\121\130\190\131\119\64\123\140\240\140\50\81\120\145\247\132\124\1\115\128\248\142\124\82\126\147\251", "\235\18\33\23\229\158");
									end
								end
							end
							if ((v88 == "Dreamwalker's Healing Potion") or (756 == 2072)) then
								if ((1605 <= 4664) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\116\168\196\186\93\173\192\183\91\191\211\168\120\191\192\183\89\180\198\139\95\174\200\180\94", "\219\48\218\161")]:IsReady()) then
									if ((1816 == 1816) and v24(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\224\99\121\72\214\88\225\232\122\121\91\200\15\232\225\112\112\64\213\72\160\244\126\104\64\212\65\160\224\116\122\76\213\92\233\242\116", "\128\132\17\28\41\187\47");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v120()
		if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\51\55\11\53\75\4\17\19\40\78\4", "\61\97\82\102\90")]:IsReady() and v35 and v112.DispellableFriendlyUnit(20)) or (621 > 3100)) then
			if (v24(v100.RemoveCurseFocus) or (1157 >= 4225)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\190\43\166\68\209\82\33\10\185\60\184\78\135\83\23\26\188\43\167", "\105\204\78\203\43\167\55\126");
			end
		end
	end
	local function v121()
		local v141 = 0;
		while true do
			if ((v141 == 1) or (4986 == 4138)) then
				v31 = v112.HandleBottomTrinket(v101, v34, 40, nil);
				if (v31 or (2033 <= 224)) then
					return v31;
				end
				break;
			end
			if ((v141 == 0) or (1223 == 2011)) then
				v31 = v112.HandleTopTrinket(v101, v34, 40, nil);
				if ((4827 > 4695) and v31) then
					return v31;
				end
				v141 = 1;
			end
		end
	end
	local function v122()
		if ((3710 > 3065) and v112.TargetIsValid()) then
			local v155 = 0;
			while true do
				if ((2135 <= 2696) and (v155 == 0)) then
					if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\163\49\12\28\22\238\92\164\173\38", "\49\197\202\67\126\115\100\167")]:IsCastable() and v68 and v96) or (1742 > 4397)) then
						if ((3900 >= 1904) and v24(v98.MirrorImage)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\58\82\205\59\143\68\97\62\86\222\46\133\22\78\37\94\220\38\141\84\95\35\27\141", "\62\87\59\191\73\224\54");
						end
					end
					if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\193\16\245\218\243\0\245\197\243", "\169\135\98\154")]:IsCastable() and not v14:IsCasting(v98.Frostbolt)) or (1724 == 909)) then
						if ((1282 < 1421) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\205\101\43\71\233\49\199\199\99\100\68\239\54\203\196\122\38\85\233\115\156", "\168\171\23\68\52\157\83");
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v142 = 0;
		local v143;
		while true do
			if ((4876 >= 4337) and (v142 == 2)) then
				if ((4005 >= 3005) and (v83 < v110)) then
					if ((v90 and ((v34 and v91) or not v91)) or (4781 <= 4448)) then
						local v225 = 0;
						while true do
							if ((1317 > 172) and (v225 == 0)) then
								v31 = v121();
								if ((4791 == 4791) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((3988 > 1261) and v89 and ((v92 and v34) or not v92) and (v83 < v110)) then
					local v214 = 0;
					while true do
						if ((2240 <= 3616) and (v214 == 2)) then
							if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\20\186\136\247\201\33\166\138\254\249\52\184\135", "\186\85\212\235\146")]:IsCastable() or (3988 < 3947)) then
								if ((4644 == 4644) and v24(v98.AncestralCall)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\195\143\21\251\42\250\74\195\141\41\253\56\226\84\130\130\18\190\104\182", "\56\162\225\118\158\89\142");
								end
							end
							break;
						end
						if ((1323 > 1271) and (v214 == 1)) then
							if ((1619 > 1457) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\237\75\53\222\17\210\104\39\210\2\204\71\60\194", "\101\161\34\82\182")]:IsCastable()) then
								if (v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment)) or (2860 < 1808)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\228\4\94\246\207\241\189\36\253\9\94\243\222\236\150\110\235\9\25\175\143", "\78\136\109\57\158\187\130\226");
								end
							end
							if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\24\54\235\244\60\51\246\254\58", "\145\94\95\153")]:IsCastable() or (739 >= 1809)) then
								if ((1539 <= 4148) and v24(v98.Fireblood)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\251\196\6\208\76\187\242\194\16\149\77\179\189\156\66", "\215\157\173\116\181\46");
								end
							end
							v214 = 2;
						end
						if ((v214 == 0) or (434 > 3050)) then
							if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\7\221\85\85\183\3\196\72\67", "\211\69\177\58\58")]:IsCastable() or (3054 < 1683)) then
								if ((47 < 2706) and v24(v98.BloodFury)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\181\233\118\250\237\244\177\240\107\236\169\200\179\165\40\165", "\171\215\133\25\149\137");
								end
							end
							if ((1519 >= 580) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\195\205\32\233\234\34\247\75\239\207", "\34\129\168\82\154\143\80\156")]:IsCastable()) then
								if (v24(v98.Berserking) or (3110 == 4177)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\135\183\33\24\77\92\130\140\188\52\75\75\74\201\212\224", "\233\229\210\83\107\40\46");
								end
							end
							v214 = 1;
						end
					end
				end
				break;
			end
			if ((4200 > 2076) and (v142 == 1)) then
				if (v143 or (601 >= 2346)) then
					return v143;
				end
				if ((3970 <= 4354) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\254\85\4\23\69\116\159", "\26\236\157\44\82\114\44")]:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
					if (v24(v98.IcyVeins) or (1542 < 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\45\204\100\60\43\220\85\57\110\214\95\106\120", "\59\74\78\181");
					end
				end
				v142 = 2;
			end
			if ((1612 <= 2926) and (0 == v142)) then
				if ((v95 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\120\248\168\18\44\149\228", "\231\148\17\149\205\69\77")]:IsCastable() and v14:BloodlustExhaustUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\162\202\235\88\237\129\171\240\250\69\239", "\159\224\199\167\155\55")]:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1, v98.IcyVeins)) or (2006 <= 540)) then
					if (v24(v98.TimeWarp, not v15:IsInRange(40)) or (2412 == 4677)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\250\49\215\200\228\61\192\231\179\63\214\183\161", "\178\151\147\92");
					end
				end
				v143 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v142 = 1;
			end
		end
	end
	local function v124()
		local v144 = 0;
		while true do
			if ((v144 == 1) or (4897 <= 1972)) then
				if ((3101 <= 3584) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\88\205\116\62\65\111\214\101\60\75\89\199\122\62", "\80\36\42\174\21")]:IsCastable() and v36 and (v14:ManaPercentage() > 30) and (v103 >= 2)) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(30)) or (1568 >= 4543)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\2\52\123\64\21\8\127\86\0\59\117\93\25\56\116\14\29\56\108\75\29\50\116\90", "\26\46\112\87");
					end
				end
				if ((4258 >= 1841) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\42\185\113\157\179\68\167\173", "\212\217\67\203\20\223\223\37")]:IsCastable() and UseFireblast) then
					if (v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast)) or (3052 >= 3554)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\132\186\215\133\143\164\211\169\153\232\223\181\155\173\223\191\131\188", "\178\218\237\200");
					end
				end
				v144 = 2;
			end
			if ((v144 == 0) or (2098 > 3885)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\197\137\46\215\89\22", "\184\60\101\160\207\66")]:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or (2970 == 1172)) then
					if ((3913 > 3881) and v24(v98.IceFloes)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\129\121\131\55\142\115\185\34\194\113\179\39\135\113\185\63\150", "\220\81\226\28");
					end
				end
				if ((4932 >= 1750) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\58\214\135\213\229\209\18", "\167\115\181\226\155\138")]:IsCastable() and v48) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or (135 == 1669)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\226\99\117\126\208\227\98\234\83\109\116\203\231\44\243", "\166\130\66\135\60\27\17");
					end
				end
				v144 = 1;
			end
			if ((4802 >= 109) and (2 == v144)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\182\227\252\183\187\229\213", "\176\214\213\134")]:IsCastable() and v47) or (3911 > 4952)) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or (265 > 4194)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\174\179\235\164\87\87\247\168\246\217\167\64\92\249\168\184\192", "\57\148\205\214\180\200\54");
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v145 = 0;
		while true do
			if ((2655 <= 2908) and (4 == v145)) then
				if ((963 > 651) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\158\103\237\230\153\186\122\238\225", "\237\216\21\130\149")]:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or (3503 <= 195)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\92\80\76\164\203\81\142\90\31\94\191\204\30\209\28", "\62\226\46\63\63\208\169");
					end
				end
				if ((1382 <= 4404) and v14:IsMoving() and v94) then
					local v215 = 0;
					local v216;
					while true do
						if ((v215 == 0) or (4857 <= 767)) then
							v216 = v124();
							if (v216 or (4018 > 4021)) then
								return v216;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v145 == 0) or (2270 == 1932)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\49\242\59\49\121\20\222\58\56\114", "\22\114\157\85\84")]:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\231\196\31\192\88\229\188\247\197\18\212", "\200\164\171\115\164\61\150")]:IsAvailable() and (v14:PrevGCDP(1, v98.CometStorm) or (v14:PrevGCDP(1, v98.FrozenOrb) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\251\14\64\151\141\224\12\87\142", "\227\222\148\99\37")]:IsAvailable()))) or (3430 <= 1176)) then
					if (v24(v98.ConeofCold) or (1198 >= 3717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\93\92\243\198\60\84\109\245\246\63\86\18\247\246\54\18\0", "\153\83\50\50\150");
					end
				end
				if ((3730 >= 1333) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\123\100\124\6\118\165\98\79\116", "\45\61\22\19\124\19\203")]:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1, v98.GlacialSpike) or not v114())) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(40)) or (2152 == 2797)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\0\2\239\7\126\134\206\0\15\181\3\127\188\129\70", "\217\161\114\109\149\98\16");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\48\44\49\102\166\117\0\36", "\20\114\64\88\28\220")]:IsCastable() and v38 and (not v14:PrevGCDP(1, v98.GlacialSpike) or not v114())) or (1709 < 588)) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(40)) or (3575 <= 3202)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\51\13\219\174\226\209\175\53\65\211\187\253\144\235", "\221\81\97\178\212\152\176");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\232\16\254\14\254\243\18\233\23", "\122\173\135\125\155")]:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(1, v98.GlacialSpike) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\206\12\189\58\34\220\183\207\1\169", "\168\228\161\96\217\95\81")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\248\222\32\89\32\81\248\222\34\88", "\55\187\177\78\60\79")]:CooldownUp() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\220\80\241\67\193\175\63\204", "\224\77\174\63\139\38\175")]:CooldownRemains() > 25)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\78\86\43\139\71\123\33\136\69", "\78\228\33\56")]:CooldownRemains() > 20))) or (4397 < 3715)) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or (4075 <= 2245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\113\191\6\145\241\109\166\12\151\195\62\179\12\128\142\38", "\229\174\30\210\99");
					end
				end
				v145 = 1;
			end
			if ((v145 == 1) or (3966 > 4788)) then
				if ((3826 > 588) and v18:IsActive() and v44 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\255\131\84\247\56", "\89\123\141\230\49\141\93")]:IsReady() and v114() and (v115() == 0) and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\125\247\15\25\75\255\66\230\5\27\79", "\42\147\17\150\108\112")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\168\34\104\244\252\0\180\32", "\136\111\198\77\31\135")]:IsAvailable()) or v14:PrevGCDP(1, v98.GlacialSpike) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\33\6\169\83\178\226\52\166\14\13", "\201\98\105\199\54\221\132\119")]:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) then
					if ((694 <= 1507) and v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\30\134\36\24\48\236\184\3\134\97\83\101", "\204\217\108\227\65\98\85");
					end
				end
				if ((3900 >= 1116) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\119\192\240\203\35\214\95", "\160\62\163\149\133\76")]:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1, v98.Freeze) and (v14:PrevGCDP(1, v98.GlacialSpike) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\245\175\3\42\204\208\131\2\35\199", "\163\182\192\109\79")]:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < 1)))) then
					if ((4907 > 3311) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\37\5\255\251\59\48\1\128\244\59\35\64\145\164", "\149\84\70\96\160");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\20\2\254\44\40\2\251\57", "\141\88\102\109")]:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1, v98.Freeze) and ((v14:PrevGCDP(1, v98.GlacialSpike) and (v106 == 0)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\144\92\196\117\21\59\118\206\191\87", "\161\211\51\170\16\122\93\53")]:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < 1)))) or (3408 <= 2617)) then
					if ((3201 == 3201) and v24(v98.FrostNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\188\189\59\239\145\188\39\237\175\242\41\244\171\242\121\169", "\72\155\206\210");
					end
				end
				if ((2195 == 2195) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\117\90\11\60\64\89\91\2\55", "\83\38\26\52\110")]:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) then
					if (v24(v98.ConeofCold) or (3025 > 3506)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\24\41\67\103\24\33\121\91\24\43\66\24\22\40\67\24\70\115", "\38\56\119\71");
					end
				end
				v145 = 2;
			end
			if ((v145 == 2) or (736 < 356)) then
				if ((1171 <= 2774) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\231\81\208\49\95\253\232\104\217\50\83\225", "\54\147\143\56\182\69")]:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) then
					if ((4108 >= 312) and v24(v98.ShiftingPower, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\137\246\79\203\223\143\248\118\207\217\150\250\91\159\215\142\250\9\142\128", "\191\182\225\159\41");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\30\41\86\130\134\206\24\2\33\94\142", "\162\75\114\72\53\235\231")]:IsReady() and v45 and (v107 == 5) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\48\77\248\73\3\158\56", "\98\236\92\36\130\51")]:CooldownRemains() > v111)) or (679 > 2893)) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (876 < 200)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\21\13\185\76\169\185\15\183\9\5\177\64\232\180\63\161\89\93\226", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\127\23\109\89\23", "\234\96\19\98\31\43\110")]:IsCastable() and v43 and not v114() and (v106 == 0) and (v14:PrevGCDP(1, v98.GlacialSpike) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\32\19\71\213\190\107", "\235\102\127\50\167\204\18")]:ChargesFractional() > 1.8))) or (2325 > 3562)) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or (3661 > 4704)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\173\224\49\86\55\16\160\250\38\4\124\0", "\78\48\193\149\67\36");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\22\18\149\10\83\41", "\33\80\126\224\120")]:IsCastable() and v43 and (v106 == 0) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) or (4133 <= 1928)) then
					if ((4418 >= 1433) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\164\22\214\78\245\232\2\203\89\172\250\82", "\60\140\200\99\164");
					end
				end
				v145 = 3;
			end
			if ((v145 == 3) or (4123 >= 4123)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\247\1\10\163\137\247\1", "\194\231\148\100\70")]:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\79\196\143\247\198\69\73", "\168\38\44\161\195\150")]:TravelTime()) or v29(v106))) or (205 >= 2345)) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or (537 == 1004)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\255\135\73\60\233\184\21\133\188\131\121\53\168\228\68", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\237\92\174\77\248\88", "\224\34\142\57")]:IsCastable() and v48 and (v102 >= 4) and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\237\169\202\202\96\229\82\28\211", "\110\190\199\165\189\19\145\61")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\253\231\118\235\130\198\214\216\103\225\128\194", "\167\186\139\23\136\235")]:IsAvailable()) or not v114())) or (2345 < 545)) then
					if ((1649 > 243) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\182\141\50\20\186\158\12\90\180\135\8\90\231\219", "\109\122\213\232");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\202\229\163\55\225\249\177\18\252\242\163\36\230", "\80\142\151\194")]:IsCastable() and v39 and (v103 >= 7)) or (3910 <= 3193)) then
					if ((2005 == 2005) and v24(v98.DragonsBreath)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\212\118\75\12\200\100\115\1\212\114\77\23\206\55\77\12\195\55\30\85", "\44\99\166\23");
					end
				end
				if ((4688 > 4572) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\93\229\42\55\61\161\89\239\57\58\60\183\117\248\39", "\196\28\151\73\86\83")]:IsCastable() and v36 and (v14:ManaPercentage() > 30) and (v103 >= 7)) then
					if ((1567 < 3260) and v24(v98.ArcaneExplosion, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\17\42\17\140\93\39\115\235\19\37\31\145\81\23\120\179\2\38\21\194\10\64", "\22\147\99\73\112\226\56\120");
					end
				end
				v145 = 4;
			end
		end
	end
	local function v126()
		local v146 = 0;
		while true do
			if ((2 == v146) or (3761 == 621)) then
				if ((4755 > 3454) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\90\122\13\64\83\87\7\67\81", "\104\47\53\20")]:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\67\141\24\185\28\183\127\143\29\172", "\111\195\44\225\124\220")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\251\73\13\118\191\152\204\73\18\126", "\203\184\38\96\19\203")]:CooldownRemains() > 10) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\97\118\91\203\55\92\107\67", "\174\89\19\25\33")]:CooldownRemains() > 10) and (v106 == 0) and (v103 >= 3)) then
					if ((4819 >= 1607) and v24(v98.ConeofCold, not v15:IsSpellInRange(v98.ConeofCold))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\29\92\75\200\136\13\16\17\93\66\243\199\8\35\23\83\88\242\199\90\123", "\107\79\114\50\46\151\231");
					end
				end
				if ((4546 >= 1896) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\170\188\51\144\56\165\196", "\160\89\198\213\73\234\89\215")]:IsCastable() and v38 and (v103 >= 2) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\114\177\221\196\68\125\177\236", "\165\40\17\212\158")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\195\203\13\54\60\236\215\15\1\39\236\215", "\70\133\185\104\83")]:IsAvailable() and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\85\72\35\199\16\64\86\35\199\3\102\75\38\205", "\169\100\37\36\74")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\50\134\187\95\6\161\176\95\19\147", "\48\96\231\194")]:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= 3))) then
					if ((3546 > 933) and v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\86\7\55\3\217\189\135\136\89\2\40\24\206\170\195\153\12", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\72\52\182\70\165\210\127\162\75\51\168\69\163", "\197\27\92\223\32\209\187\17")]:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\37\77\204\225\6\81\236\233\1", "\155\99\63\163")]:CooldownRemains() > 10) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\222\172\136\173\183\150\222\179\128", "\228\226\177\193\237\217")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\23\191\46\227\32\131\55\233\38\189", "\134\84\208\67")]:CooldownRemains() > 10)) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\33\173\159\83\21\138\148\83\0\184", "\60\115\204\230")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\59\242\127\225\28\249\127\244\46", "\16\135\90\139")]:CooldownRemains() > 10))) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\119\31\5\75\93\118\71", "\24\52\20\102\83\46\52")]:CooldownRemains() < 20))) or (3985 <= 3160)) then
					if ((1987 == 1987) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\39\40\34\27\205\33\38\27\31\203\56\36\54\79\199\35\36\37\25\193\111\112\124", "\111\164\79\65\68");
					end
				end
				v146 = 3;
			end
			if ((994 <= 4540) and (v146 == 0)) then
				if ((4917 == 4917) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\22\88\134\11\62\59\81\247\20", "\62\133\121\53\227\127\109\79")]:IsCastable() and (v14:PrevGCDP(1, v98.Flurry) or v14:PrevGCDP(1, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or (324 > 4896)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\27\63\240\194\145\177\4\27\32\248\150\173\174\21\21\36\240\150\252", "\194\112\116\82\149\182\206");
					end
				end
				if ((772 < 4670) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\164\89\10\210\251", "\110\89\200\44\120\160\130")]:IsCastable() and v43 and ((v14:PrevGCDP(1, v98.Frostbolt) and (v107 >= 3)) or v14:PrevGCDP(1, v98.GlacialSpike) or ((v107 >= 3) and (v107 < 5) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\207\94\84\81\83", "\45\203\163\43\38\35\42\91")]:ChargesFractional() == 2)))) then
					if ((3172 >= 2578) and v112.CastTargetIf(v98.Flurry, v105, LUAOBFUSACTOR_DECRYPT_STR_0("\223\140\210", "\52\178\229\188\67\231\201"), v117, nil, not v15:IsSpellInRange(v98.Flurry))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\77\69\22\229\69\99\34\77\85\5\225\89\99\117", "\67\65\33\48\100\151\60");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\246\228\171\244\242\209\228\171", "\147\191\135\206\184")]:IsReady() and v47 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\163\36\167\194\209\82\190\183\56\175\202\221", "\210\228\72\198\161\184\51")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\64\253\4\118\220\37\106\251\25\127\194\18\76\241\5\117\200", "\174\86\41\147\112\19")]:AuraActiveCount() == 0) and (v107 == 4) and v14:BuffUp(v98.FingersofFrostBuff)) or (721 == 834)) then
					if ((1312 < 2654) and v112.CastTargetIf(v98.IceLance, v105, LUAOBFUSACTOR_DECRYPT_STR_0("\86\1\149", "\203\59\96\237\107\69\111\113"), v118, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\21\169\222\61\241\217\39\19\236\226\61\245\214\50\19\236\183", "\183\68\118\204\129\81\144");
					end
				end
				v146 = 1;
			end
			if ((3213 >= 1613) and (v146 == 3)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\213\130\221\39\235\202\234\147\215\37\239", "\138\166\185\227\190\78")]:IsReady() and v45 and (v107 == 5)) or (3786 > 4196)) then
					if ((4218 == 4218) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\120\196\52\91\34\21\244\103\213\62\89\38\89\200\120\192\54\68\38\89\153\36", "\121\171\20\165\87\50\67");
					end
				end
				if ((1517 < 4050) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\239\59\188\26\184\12\197\61", "\98\166\88\217\86\217")]:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(1, v98.GlacialSpike)) or (v106 > 0))) then
					if ((4390 == 4390) and v112.CastTargetIf(v98.IceLance, v105, LUAOBFUSACTOR_DECRYPT_STR_0("\251\247\97", "\188\150\150\25\97\230"), v117, nil, not v15:IsSpellInRange(v98.IceLance))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\138\90\61\0\236\212\138\90\66\15\225\223\136\73\7\76\191\136", "\141\186\233\63\98\108");
					end
				end
				if ((1919 > 289) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\216\233\41\152\42\231\235", "\69\145\138\76\214")]:IsCastable() and v48 and (v103 >= 4)) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or (1205 < 751)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\121\204\140\182\177\25\102\206\201\138\179\19\113\217\140\201\237\66", "\118\16\175\233\233\223");
					end
				end
				v146 = 4;
			end
			if ((1 == v146) or (2561 <= 1717)) then
				if ((1723 <= 3600) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\172\105\235\13\164\28\162\99\240", "\226\110\205\16\132\107")]:IsCastable() and (v106 == 1) and v49) then
					if ((3271 >= 1633) and v112.CastTargetIf(v98.RayofFrost, v105, LUAOBFUSACTOR_DECRYPT_STR_0("\230\194\248", "\33\139\163\128\185"), v117, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\89\29\225\88\94\59\216\69\87\23\202\23\91\8\219\86\78\1\158\15", "\190\55\56\100");
					end
				end
				if ((3103 >= 2873) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\163\61\29\26\226\255\101\191\53\21\22", "\147\54\207\92\126\115\131")]:IsReady() and v45 and (v107 == 5) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\43\61\32\111\31\103", "\30\109\81\85\29\109")]:CooldownUp() or (v106 > 0))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (3603 == 725)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\125\85\181\63\223\240\192\98\68\191\61\219\188\252\125\81\183\32\219\188\174\33", "\156\159\17\52\214\86\190");
					end
				end
				if ((2843 == 2843) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\253\178\166\171\225\146\174\172", "\220\206\143\221")]:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < 2) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\124\52\24\222\234\192\137\110\57", "\178\230\29\77\119\184\172")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\191\19\20\113\222\231\177\25\15", "\152\149\222\106\123\23")]:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb)) or (174 >= 2515)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\52\249\89\176\211\25\249\81\183\157\37\250\70\180\203\35\182\18\231", "\213\189\70\150\35");
					end
				end
				v146 = 2;
			end
			if ((4411 >= 2020) and (v146 == 4)) then
				if ((1347 == 1347) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\173\150\58\168\250\137\114\135\144", "\29\235\228\85\219\142\235")]:IsCastable() and v41) then
					if ((4461 == 4461) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\198\181\206\99\76\40\94\41\148\185\209\114\79\49\87\125\134\236", "\50\93\180\218\189\23\46\71");
					end
				end
				if ((v14:IsMoving() and v94) or (4340 == 2872)) then
					local v217 = 0;
					local v218;
					while true do
						if ((568 <= 2207) and (v217 == 0)) then
							v218 = v124();
							if (v218 or (3789 <= 863)) then
								return v218;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		local v147 = 0;
		while true do
			if ((238 < 4997) and (3 == v147)) then
				if ((4285 > 3803) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\143\17\69\32\219\34\176\0\79\34\223", "\186\78\227\112\38\73")]:IsReady() and v45 and (v107 == 5)) then
					if ((2672 < 4910) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\91\252\86\90\123\240\104\238\69\90\113\249\23\238\92\93\125\240\82\189\7\3", "\26\156\55\157\53\51");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\219\19\245\185\94\143\221", "\48\236\184\118\185\216")]:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1, v98.GlacialSpike) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\177\86\51\198\53\233\142\71\57\196\49", "\84\133\221\55\80\175")]:InFlight()) or v29(v106))) or (2956 > 4353)) then
					if ((3534 > 2097) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\228\33\153\203\93\179\228\33\230\212\85\179\224\40\163\135\14\239", "\60\221\135\68\198\167");
					end
				end
				if ((3255 >= 534) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\190\253\173\77\207\239", "\185\142\221\152\227\34")]:IsCastable() and v48 and (v103 >= 4)) then
					if ((4254 < 4460) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\198\82\197\77\60\225\89\133\68\243\77\52\251\93\133\5\174", "\151\56\165\55\154\35\83");
					end
				end
				v147 = 4;
			end
			if ((v147 == 0) or (4661 <= 4405)) then
				if ((4575 >= 1943) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\253\171\86\73\80\239\92\209\182\86", "\40\190\196\59\44\36\188")]:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1, v98.Flurry) or v14:PrevGCDP(1, v98.ConeofCold))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or (326 > 1137)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\74\209\177\238\66\30\40\74\206\185\186\110\4\50\66\208\177\186\47", "\109\92\37\188\212\154\29");
					end
				end
				if ((1284 == 1284) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\34\227\177\209\35\67", "\58\100\143\196\163\81")]:IsCastable() and (v106 == 0) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(1, v98.Frostbolt) and (v107 >= 3)) or (v14:PrevGCDP(1, v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1, v98.GlacialSpike) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\78\34\160\54\72\233\61\10\75\40\166", "\110\122\34\67\195\95\41\133")]:IsAvailable() and (v107 == 4) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or (3072 >= 3426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\189\78\88\196\108\241\72\67\216\114\189\94\10\130", "\182\21\209\59\42");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\158\84\192\49\32\176\180\82", "\222\215\55\165\125\65")]:IsReady() and v47 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\221\199\25\251\192\225\121\60\216\205\31", "\42\76\177\166\122\146\161\141")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\134\4\205\112\119\169\185\21\199\114\115", "\22\197\234\101\174\25")]:InFlight() and (v106 == 0) and (v107 == 4) and v14:BuffUp(v98.FingersofFrostBuff)) or (4036 > 4375)) then
					if ((3928 == 3928) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\55\160\227\122\174\217\133\40\116\182\213\120\168\219\131\109\98", "\230\77\84\197\188\22\207\183");
					end
				end
				v147 = 1;
			end
			if ((4 == v147) or (2629 >= 3005)) then
				if ((v89 and ((v92 and v34) or not v92)) or (2620 <= 422)) then
					if ((1896 > 1857) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\66\2\225\166\119\23\231\163\72\22", "\142\192\35\101")]:IsCastable()) then
						if ((1466 >= 492) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\212\116\46\156\232\138\147\2\196\124\42\168\244\204\175\18\150\33\121", "\118\182\21\73\195\135\236\204");
						end
					end
				end
				if ((868 < 3853) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\46\46\21\83\16\15\242\4\40", "\157\104\92\122\32\100\109")]:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or (1815 > 4717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\180\192\217\41\37\130\167\183\230\220\195\51\32\129\174\227\244\153", "\203\195\198\175\170\93\71\237");
					end
				end
				if ((3671 == 3671) and v14:IsMoving() and v94) then
					local v219 = 0;
					local v220;
					while true do
						if ((216 <= 284) and (v219 == 0)) then
							v220 = v124();
							if ((3257 > 2207) and v220) then
								return v220;
							end
							break;
						end
					end
				end
				break;
			end
			if ((2 == v147) or (2087 < 137)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\202\191\228\193\237\230\190\237\202", "\174\139\165\209\129")]:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\188\238\197\195\16\100\75\173\178\242", "\24\195\211\130\161\166\99\16")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\12\228\41\71\37\82\12\251\33", "\118\38\99\137\76\51")]:CooldownRemains() > 10) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\52\10\8\12\46\210\52\7", "\64\157\70\101\114\105")]:CooldownRemains() > 10) and (v106 == 0) and (v102 >= 3)) or (3923 >= 4763)) then
					if ((1744 == 1744) and v24(v98.ConeofCold)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\167\169\230\47\79\174\152\224\31\76\172\231\240\25\78\175\171\230\80\17\252", "\112\32\200\199\131");
					end
				end
				if ((248 <= 1150) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\14\92\85\162\217\170\48\40", "\66\76\48\60\216\163\203")]:IsCastable() and v38 and (v102 >= 2) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\147\133\124\208\94\194\40\191\148", "\68\218\230\25\147\63\174")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\56\86\73\172\164\36\84\126\183\164\36", "\214\205\74\51\44")]:IsAvailable() and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\92\238\245\121\238\73\240\245\121\253\111\237\240\115", "\23\154\44\130\156")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\167\180\161\48\53\3\169\190\186", "\115\113\198\205\206\86")]:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= 3))) then
					if ((3994 >= 294) and v24(v100.BlizzardCursor, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\91\247\64\158\86\236\94\196\68\247\84\131\91\251\26\213\1", "\58\228\55\158");
					end
				end
				if ((1641 > 693) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\135\129\217\40\40\164\59\179\185\223\57\57\191", "\85\212\233\176\78\92\205")]:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == 0) and (((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\74\135\248\79\86\167\240\72", "\130\42\56\232")]:CooldownRemains() > 10) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\186\41\230\84\12\254\186\54\238", "\95\138\213\68\131\32")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\39\172\70\98\25\60\174\81\123", "\22\74\72\193\35")]:CooldownRemains() > 10)) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\120\253\87\42\95\246\87\63\109", "\56\76\25\132")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\192\178\41\201\120\211\164\53\219", "\175\62\161\203\70")]:CooldownRemains() > 10))) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\222\218\37\48\53\211\208", "\85\92\189\163\115")]:CooldownRemains() < 20))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(40)) or (4519 < 2235)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\164\57\62\61\165\62\63\22\188\63\47\44\190\112\43\32\162\55\52\44\236\97\96", "\88\73\204\80");
					end
				end
				v147 = 3;
			end
			if ((892 < 1213) and (v147 == 1)) then
				if ((3313 <= 4655) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\21\223\243\138\135\226\58\234\0", "\85\153\116\166\156\236\193\144")]:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\150\225\84\188\226\38\182\239\94\167", "\96\196\128\45\211\132")]:CastTime()) and (v106 == 1)) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or (3956 < 2705)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\140\98\96\221\169\139\222\39\130\104\75\146\188\189\214\50\129\126\31\138", "\184\85\237\27\63\178\207\212");
					end
				end
				if ((1959 < 3037) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\47\85\8\92\1\88\5\108\24\80\2\90", "\63\104\57\105")]:IsReady() and v45 and (v107 == 5) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\139\177\86\25\158", "\36\107\231\196")]:Charges() >= 1) or ((v106 > 0) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\185\163\132\84\180\174\180\77\188\169\130", "\231\61\213\194")]:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or (1241 > 2213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\161\60\112\0\172\49\76\26\189\52\120\12\237\46\122\7\170\49\118\73\252\109", "\19\105\205\93");
					end
				end
				if ((4905 < 4974) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\143\26\209\155\58\167\39\204\131", "\95\201\104\190\225")]:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == 0) and (v14:BuffStackP(v98.FingersofFrostBuff) < 2) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\202\216\193\169\237\211\193\188\223", "\174\207\171\161")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\255\20\252\254\241\255\241\30\231", "\183\141\158\109\147\152")]:CooldownDown())) then
					if ((3557 == 3557) and v24(v100.FrozenOrbCast, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\27\233\22\41\7\217\3\62\11\166\31\37\7\225\0\41\73\183\94", "\108\76\105\134");
					end
				end
				v147 = 2;
			end
		end
	end
	local function v128()
		local v148 = 0;
		while true do
			if ((369 == 369) and (10 == v148)) then
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\189\8\40\177\182\27\47", "\92\216\216\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\78\33\169\115\237\94\62\160\115\233\94\51\160\116\252\73\53\169\84", "\157\59\82\204\32")];
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\59\247\238\224\228\212\162", "\209\88\94\131\154\137\138\179")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\178\193\79\14\38\61\46\59\150\204\117\18\38\28\45\62\168\202\123", "\66\72\193\164\28\126\67\81")];
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\41\188\76\47\120\224\63", "\22\135\76\200\56\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\35\253\16\84\236\136\7\249\54\77\214\132\36\240\16\92\237\136\62\236", "\129\237\80\152\68\61")];
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\173\16\231\21\25\95\66", "\56\49\200\100\147\124\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\55\173\226\195\44\150\253\205\57\186\210\201\56\176\226\201\14\170\252\192", "\144\172\94\223")];
				v148 = 11;
			end
			if ((9 == v148) or (3589 < 2987)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\51\245\173\16\184\83", "\32\229\165\71\129\196\126\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\155\193\128\149\208\209\160\202\151\136\198\202\139\205\141\136\193\218\161\244", "\181\163\233\164\225\225")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\142\42\99\89\133\57\100", "\23\48\235\94")][LUAOBFUSACTOR_DECRYPT_STR_0("\117\217\221\127\91\60\209\119\242\232", "\178\28\186\184\61\55\83")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\200\83\40\251\0\242\215", "\149\164\173\39\92\146\110")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\46\2\13\21\9\218\42\17\24\31\51\195", "\123\147\71\112\127\122")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\200\150\101\79\194\202\145", "\38\172\173\226\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\64\16\63\252\111\16\62\253\68\20\62\199\125", "\143\45\113\76")] or 0;
				v148 = 10;
			end
			if ((4378 > 2853) and (v148 == 11)) then
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\10\182\83\45\1\165\84", "\39\68\111\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\181\226\245\124\186\217\176\226\228\108\165\197\163\208\206\109\191\247\160\225\203\112\180\194\163\227", "\215\182\198\135\167\25")];
				break;
			end
			if ((v148 == 0) or (1712 > 3602)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\103\251\193\130\25\64\120\124\237\225\187\27\79\118\97\225\203\173", "\25\18\136\164\195\107\35")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\255\46\251\26\223\131\35\233\2\212\28\217\142\33\233\40\206", "\226\77\140\75\186\104\188")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\206\115\32\190\93\98\60\185\207\114", "\70\216\189\22\98\210\52\24")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\44\29\192\235\62\31\235\247\44\58\246\252\62\12\236", "\132\153\95\120")];
				v148 = 1;
			end
			if ((4539 >= 2733) and (v148 == 3)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\168\235\19\46\190\192\53\59\186", "\90\77\219\142")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\240\53\17\165\232\204\54\5\182\254\240\36", "\196\145\131\80\67")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\153\203\96\160\71\51\69\125\152\221\83\170\94\49", "\49\24\234\174\35\207\50\93")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\94\208\17\207\35\169\88\215\35\236\57\173", "\200\43\163\116\141\79")];
				v148 = 4;
			end
			if ((v148 == 8) or (2599 <= 515)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\122\199\103\87\20\189\108", "\122\218\31\179\19\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\197\200\236\192\179\87\188\196\228\204\200\166\64", "\37\211\182\173\161\169\193")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\63\89\205\33\117\190\228", "\217\151\90\45\185\72\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\112\243\23\68\247\117\234\23\126\243", "\54\163\28\135\114")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\222\73\150\71\113\47\200", "\31\72\187\61\226\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\5\70\240\70\108\54\202\3\81\250\119", "\68\163\102\35\178\39\30")] or 0;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\117\206\211\10\187\132\2", "\113\222\16\186\167\99\213\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\13\254\213\33\2\255\222\30", "\150\78\110\155")] or 0;
				v148 = 9;
			end
			if ((v148 == 5) or (3754 < 810)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\240\141\14\65\83\52\247\129\51\78\106\61\244\141\47", "\58\82\131\232\93\41")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\125\58\125\174\17\112\48\124\162\12\118\0\111", "\203\120\30\67\43")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\13\22\188\217\132\48\11\164\235\131\11\17\133\248", "\188\234\127\121\198")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\64\16\183\162\22\64\87\16\168\170\53\122\87\23\153\131", "\19\35\127\218\199\98")];
				v148 = 6;
			end
			if ((1633 <= 1977) and (4 == v148)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\86\179\159\30\172\213\64\191\184\14", "\213\131\37\214\214\125")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\216\246\207\110\224\92\206\253\198\110\237", "\143\38\171\147\137\28")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\170\42\36\220\180\42\19\224\173\32\21\222", "\103\179\217\79")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\74\50\29\42\246\8\118\49\29\42\244\9", "\152\109\57\87\94\69")];
				v148 = 5;
			end
			if ((4528 >= 3619) and (v148 == 6)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\196\248\170\140\240\95\176\217\207\193\166\183\254\95\155", "\223\181\171\150\207\195\150\28")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\232\187\191\28\55\241\231\130\182\31\59\237\215\187\173\0\29\219", "\94\159\128\210\217\104")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\83\232\210\14\84\232\225\54\73\224\246", "\147\98\32\141")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\70\247\222\15\88\76\11", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\65\21\130\159\166\181\166\85\20\149\191\160\162", "\228\52\102\231\214\197\208")];
				v148 = 7;
			end
			if ((2 == v148) or (172 >= 2092)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\178\236\228\102\141\164\243\199\68\141\181", "\20\232\193\137\162")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\188\171\52\243\233\239\216\14\163\157\3\246\227\233", "\177\111\207\206\115\159\136\140")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\40\232\59\251\51\229\55\226\23\235", "\86\163\91\141\114\152")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\227\128\198\62\136\220\132\225\62\136", "\93\237\144\229\143")];
				v148 = 3;
			end
			if ((2120 == 2120) and (v148 == 1)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\16\39\207\246\214\229\33\46\232\236\208", "\164\128\99\66\137\159")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\160\162\57\154\252\227\173\177\168\19\156", "\144\217\211\199\127\232\147")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\203\66\25\197\215\84\43\249\215\81\62", "\95\183\184\39")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\176\204\81\88\235\177\219\110", "\52\158\195\169\23")];
				v148 = 2;
			end
			if ((7 == v148) or (2398 == 358)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\229\97\222\227\133\30\197", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\201\48\193\148\22\49\18\142\200\28\232\144\26\35\15\137\211\57\239\146\10", "\102\235\186\85\134\230\115\80")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\9\42\75\123\218\37\68", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\1\158\128\30\36\92\54\129\138\52\44", "\57\116\237\229\87\71")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\180\249\243\126\224\64\185", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\32\12\35\49\253\220\60\5\14", "\152\159\83\105\106\82")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\195\69\230\192\82\134\213", "\60\225\166\49\146\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\13\42\7\0\20\60\60\46\56\19\14\42\12", "\103\79\126\79\74\97")];
				v148 = 8;
			end
		end
	end
	local function v129()
		local v149 = 0;
		while true do
			if ((2387 < 4637) and (v149 == 0)) then
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\76\254\92\132\71\237\91", "\40\237\41\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\125\253\240\94\245\113\247\249\67\201\103\217\240\79\196\127", "\42\167\20\154\152")] or 0;
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\251\182\86\120\47\77\237", "\65\42\158\194\34\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\41\70\9\63\255\14\254\14\16\91\24\37\222\15\251\20", "\142\122\71\50\108\77\141\123")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\167\235\12\50\27\165\236", "\91\117\194\159\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\19\42\29\39\227\49\10\9\17\22\57\232\19\18\20\42\29\57\248\55\14", "\68\122\125\94\120\85\145")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\219\74\193\215\189\4", "\218\119\124\175\62\168\185")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\254\92\193\183\226\93\212\177\196\64\214\160\227\64\203\169\244", "\164\197\144\40")];
				v149 = 1;
			end
			if ((1265 < 2775) and (v149 == 4)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\29\14\89\132\22\29\94", "\45\237\120\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\233\172\40\219\237\139\34\212\231\176\60\216\250\167\45\219", "\76\183\136\194")];
				break;
			end
			if ((3 == v149) or (4430 < 51)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\36\60\18\114\131\254\63", "\76\140\65\72\102\27\237\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\223\23\222\195\9\173\94\213\24\215\255\49", "\222\42\186\118\178\183\97")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\233\80\158\84\226\67\153", "\234\61\140\36")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\187\126\6\47\218\138\125\27\40\210\180\90\63", "\111\65\189\218\18")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\78\15\33\2\82\168\80", "\207\35\43\123\85\107\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\175\161\230\112\126\173\144\229\109\121\165\174\196\120\125\175", "\25\16\202\192\138")] or "";
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\206\185\246\160\250\250\216", "\148\157\171\205\130\201")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\213\122\45\221\243\2\210\114\37\216\245\55\209\112", "\150\67\180\20\73\177")];
				v149 = 4;
			end
			if ((1871 <= 1998) and (v149 == 2)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\249\158\2\200\32\251\153", "\161\78\156\234\118")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\165\192\210\172\178\221\207\144\190\221\212\132\147", "\188\199\215\169")];
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\12\75\111\225\242\14\76", "\136\156\105\63\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\141\122\61\26\128\106\3\18\152\113\23\63", "\84\123\236\25")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\142\190\3\165\187\247\152", "\213\144\235\202\119\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\54\11\219\2\45\34\65\55\16\205\62\39\45\72", "\45\67\120\190\74\72\67")];
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\19\39\249\177\240\134\233\250", "\137\64\66\141\197\153\232\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\195\39\142\141\2\220\43\168\143\51\223\54\175\135\13", "\232\99\176\66\198")];
				v149 = 3;
			end
			if ((v149 == 1) or (2083 >= 3954)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\245\190\159\212\184\132\227", "\214\227\144\202\235\189")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\172\148\107\21\191\119\57\239\176\129\125\3", "\92\141\197\231\27\112\211\51")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\250\158\183\216\232\248\153", "\177\134\159\234\195")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\226\44\176\204\177\201\42\166\207\174", "\169\221\139\95\192")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\142\107\43\43\40\217\152", "\70\190\235\31\95\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\241\31\210\247\179\236\17\227\241\169", "\133\218\130\122\134")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\250\247\208\213\173\63\47", "\88\92\159\131\164\188\195")][LUAOBFUSACTOR_DECRYPT_STR_0("\149\61\186\121\214\232\212\129\34\172", "\189\224\78\223\43\183\139")];
				v149 = 2;
			end
		end
	end
	local function v130()
		local v150 = 0;
		while true do
			if ((1857 > 59) and (v150 == 1)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\165\123\175\219\40\185", "\183\77\202\28\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\55\154", "\104\119\83\233")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\193\247\32\37\79\240\235", "\35\149\152\71\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\225\81\160\63\21", "\90\121\136\34\208")];
				if (v14:IsDeadOrGhost() or (1232 == 3045)) then
					return;
				end
				v105 = v15:GetEnemiesInSplashRange(5);
				v150 = 2;
			end
			if ((104 == 104) and (v150 == 2)) then
				Enemies40yRange = v14:GetEnemiesInRange(40);
				if ((4534 > 2967) and v33) then
					local v221 = 0;
					while true do
						if ((v221 == 0) or (3449 <= 2368)) then
							v102 = v30(v15:GetEnemiesInSplashRangeCount(5), #Enemies40yRange);
							v103 = v30(v15:GetEnemiesInSplashRangeCount(5), #Enemies40yRange);
							break;
						end
					end
				else
					local v222 = 0;
					while true do
						if ((4733 >= 3548) and (v222 == 0)) then
							v104 = 1;
							v102 = 1;
							v222 = 1;
						end
						if ((v222 == 1) or (2005 > 4687)) then
							v103 = 1;
							break;
						end
					end
				end
				if (not v14:AffectingCombat() or (1767 <= 916)) then
					if ((3589 < 3682) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\28\86\31\201\11\124\16\211\11\89\18\194\13\65", "\126\167\110\53")]:IsCastable() and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) then
						if (v24(v98.ArcaneIntellect) or (75 >= 430)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\60\2\45\249\210\58\2\25\32\236\217\51\49\21\45\236", "\95\93\112\78\152\188");
						end
					end
				end
				if (v112.TargetIsValid() or v14:AffectingCombat() or (4157 <= 3219)) then
					local v223 = 0;
					while true do
						if ((1823 < 2782) and (v223 == 1)) then
							if ((3434 >= 1764) and (v110 == 11111)) then
								v110 = v10.FightRemains(Enemies40yRange, false);
							end
							v106 = v15:DebuffStack(v98.WintersChillDebuff);
							v223 = 2;
						end
						if ((4040 > 1820) and (2 == v223)) then
							v107 = v14:BuffStackP(v98.IciclesBuff);
							v111 = v14:GCD();
							break;
						end
						if ((4192 >= 2529) and (v223 == 0)) then
							v109 = v10.BossFightRemains(nil, true);
							v110 = v109;
							v223 = 1;
						end
					end
				end
				v150 = 3;
			end
			if ((1554 < 2325) and (v150 == 3)) then
				if ((1108 < 4525) and v112.TargetIsValid()) then
					local v224 = 0;
					while true do
						if ((v224 == 4) or (4367 <= 3332)) then
							if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or (2896 > 4641)) then
								local v226 = 0;
								while true do
									if ((882 > 21) and (2 == v226)) then
										if ((2373 <= 4789) and v31) then
											return v31;
										end
										if (v24(v98.Pool) or (1839 < 1136)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\235\17\214\238\118\36\194\233\94\234\214\126\107", "\173\155\126\185\130\86\66");
										end
										v226 = 3;
									end
									if ((3430 == 3430) and (v226 == 1)) then
										if ((748 <= 2288) and v33 and (v103 == 2)) then
											local v233 = 0;
											while true do
												if ((891 < 4473) and (v233 == 0)) then
													v31 = v126();
													if (v31 or (3071 <= 2647)) then
														return v31;
													end
													v233 = 1;
												end
												if ((v233 == 1) or (633 > 1640)) then
													if ((3764 > 2404) and v24(v98.Pool)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\238\56\249\187\164\188\241\37\182\148\232\191\255\33\243\255\173", "\218\158\87\150\215\132");
													end
													break;
												end
											end
										end
										v31 = v127();
										v226 = 2;
									end
									if ((3 == v226) or (3811 >= 4158)) then
										if ((743 > 47) and v94) then
											local v234 = 0;
											while true do
												if ((3599 >= 1059) and (v234 == 0)) then
													v31 = v124();
													if ((1371 <= 2507) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v226 == 0) or (3607 == 2536)) then
										if ((1126 < 3675) and v34) then
											local v235 = 0;
											while true do
												if ((v235 == 0) or (3344 >= 3615)) then
													v31 = v123();
													if (v31 or (4776 <= 210)) then
														return v31;
													end
													break;
												end
											end
										end
										if ((v33 and (((v103 >= 7) and not v14:HasTier(30, 2)) or ((v103 >= 3) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\172\224\234\250\2\170\137\230\253", "\198\229\131\143\185\99")]:IsAvailable()))) or (2613 > 2752)) then
											local v236 = 0;
											while true do
												if ((4542 > 2119) and (0 == v236)) then
													v31 = v125();
													if (v31 or (1039 == 338)) then
														return v31;
													end
													v236 = 1;
												end
												if ((v236 == 1) or (4131 > 4610)) then
													if ((4129 >= 672) and v24(v98.Pool)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\65\131\167\127\17\138\167\97\17\173\167\118\25\197", "\19\49\236\200");
													end
													break;
												end
											end
										end
										v226 = 1;
									end
								end
							end
							break;
						end
						if ((1019 < 3466) and (v224 == 0)) then
							if ((290 <= 855) and v16) then
								if ((4601 > 4446) and v77) then
									local v231 = 0;
									while true do
										if ((v231 == 0) or (995 >= 2099)) then
											v31 = v120();
											if ((961 < 4006) and v31) then
												return v31;
											end
											break;
										end
									end
								end
							end
							if ((2694 < 4854) and not v14:AffectingCombat() and v32) then
								local v227 = 0;
								while true do
									if ((v227 == 0) or (4174 <= 3733)) then
										v31 = v122();
										if (v31 or (2626 <= 648)) then
											return v31;
										end
										break;
									end
								end
							end
							v224 = 1;
						end
						if ((1595 <= 2078) and (v224 == 3)) then
							if ((1635 > 653) and v79) then
								local v228 = 0;
								while true do
									if ((3738 == 3738) and (v228 == 0)) then
										v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 30, true);
										if (v31 or (3963 > 4742)) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\187\203\216\160\173\5\178\38\137\215", "\67\232\187\189\204\193\118\198")]:IsAvailable() and v93 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\184\62\176\44\55\17\251\142\47\185", "\143\235\78\213\64\91\98")]:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) or (4072 > 4695)) then
								if (v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal)) or (2220 > 2889)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\158\88\129\229\124\165\153\77\133\229\48\178\140\69\133\238\117", "\214\237\40\228\137\16");
								end
							end
							v224 = 4;
						end
						if ((v224 == 2) or (4914 < 4399)) then
							if ((3660 == 3660) and (v14:AffectingCombat() or v77)) then
								local v229 = 0;
								local v230;
								while true do
									if ((2915 >= 196) and (v229 == 1)) then
										if (v31 or (4638 < 3902)) then
											return v31;
										end
										break;
									end
									if ((v229 == 0) or (1100 >= 1292)) then
										v230 = v77 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\243\240\136\26\242\187\241\212\231\150\16", "\178\161\149\229\117\132\222")]:IsReady() and v35;
										v31 = v112.FocusUnit(v230, v100, 20, nil, 20);
										v229 = 1;
									end
								end
							end
							if (v78 or (547 > 3511)) then
								if (v97 or (314 > 2132)) then
									local v232 = 0;
									while true do
										if ((932 == 932) and (v232 == 0)) then
											v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 30);
											if (v31 or (2939 == 4366)) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v224 = 3;
						end
						if ((v224 == 1) or (3969 <= 3657)) then
							v31 = v119();
							if (v31 or (1379 == 1462)) then
								return v31;
							end
							v224 = 2;
						end
					end
				end
				break;
			end
			if ((v150 == 0) or (4606 <= 3927)) then
				v128();
				v129();
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\78\233\226\63\92\74\7", "\116\26\134\133\88\48\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\206\163", "\18\126\161\192\132\221")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\39\169\3\90\90\59", "\54\63\72\206\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\86\64", "\27\168\57\37\26\133")];
				v150 = 1;
			end
		end
	end
	local function v131()
		local v151 = 0;
		while true do
			if ((v151 == 0) or (1578 <= 1012)) then
				v113();
				v22.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\195\180\181\212\156\172\200\167\189\194\200\254\234\178\187\211\129\227\235\230\184\222\200\201\245\175\185\137\200\223\240\182\170\200\154\248\224\162\250\197\145\172\253\141\187\201\141\248\234\232", "\140\133\198\218\167\232"));
				break;
			end
		end
	end
	v22.SetAPL(64, v130, v131);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\144\62\189\101\187\152\47\179\120\187\147\60\187\110\144\251\34\161\124", "\228\213\78\212\29")]();

