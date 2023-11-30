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
		if ((v5 == 0) or (3228 >= 3575)) then
			v6 = v0[v4];
			if ((4397 >= 3918) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (780 == 3185)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\195\202\212\55\217\154\213\19\194\141\215\48\231", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67\147\71\238\80\162\82", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\142\114\127\61\0", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = 5;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32;
	local v33;
	local v34;
	local v35;
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
	local v94 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")];
	local v95 = v14:GetEquipment();
	local v96 = (v95[13] and v19(v95[13])) or v19(0);
	local v97 = (v95[14] and v19(v95[14])) or v19(0);
	local v98 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\48\239\183\220\14\225\183", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\119\58\82\43", "\152\54\72\63\88\69\62")];
	local v99 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\227\197\252\78\221\203\252", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\76\8\58", "\114\56\62\101\73\71\141")];
	local v100 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\143\232\201\214\177\230\201", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\244\60\161", "\107\178\134\81\210\198\158")];
	local v101 = {};
	local v102;
	local v103 = 11111;
	local v104 = 11111;
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((0 == v124) or (3202 >= 4075)) then
				v103 = 11111;
				v104 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\8\34\163\255\143\10\49\176\227\141\29\32\189\227\132\25\44\174\227\142", "\202\88\110\226\166"));
	v10:RegisterForEvent(function()
		local v125 = 0;
		while true do
			if ((64 == 64) and (v125 == 1)) then
				v97 = (v95[14] and v19(v95[14])) or v19(0);
				break;
			end
			if ((2202 >= 694) and (v125 == 0)) then
				v95 = v14:GetEquipment();
				v96 = (v95[13] and v19(v95[13])) or v19(0);
				v125 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\243\35\163\206\239\241\48\167\198\255\234\63\175\210\228\247\48\161\223\235\237\40\167\211", "\170\163\111\226\151"));
	local v105;
	local v106;
	local function v107()
		local v126 = 0;
		local v127;
		while true do
			if ((3706 <= 3900) and (v126 == 0)) then
				v127 = UnitGetTotalAbsorbs(v15);
				if ((2890 > 2617) and (v127 > 0)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v108(v128)
		return (v128:HealthPercentage() > 20) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\49\161\43\79\52\59\20", "\73\113\80\210\88\46\87")]:IsAvailable() and (v128:HealthPercentage() < 35));
	end
	local function v109(v129)
		return (v129:DebuffStack(v98.ExecutionersPrecisionDebuff) == 2) or (v129:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\62\200\19\227\143\45\216\21\239\149", "\135\225\76\173\114")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\236\172\164\160\184\171\21\255\188", "\199\122\141\216\208\204\221")]:IsAvailable() and (v106 <= 2));
	end
	local function v110(v130)
		return v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= 2) and ((v130:HealthPercentage() < 20) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\220\3\227\121\245\191\216", "\150\205\189\112\144\24")]:IsAvailable() and (v130:HealthPercentage() < 35)))) or v14:BuffUp(v98.SweepingStrikes);
	end
	local function v111()
		local v131 = 0;
		while true do
			if ((v131 == 4) or (3355 > 4385)) then
				if ((v71 and (v14:HealthPercentage() <= v81)) or (3067 <= 2195)) then
					local v194 = 0;
					while true do
						if ((3025 >= 2813) and (v194 == 0)) then
							if ((2412 >= 356) and (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\51\226\78\77\118\18\239\65\81\116\65\207\77\94\127\8\233\79\31\67\14\243\65\80\125", "\19\97\135\40\63"))) then
								if ((2070 > 1171) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\156\89\53\41\42\34\166\85\61\60\7\52\175\80\58\53\40\1\161\72\58\52\33", "\81\206\60\83\91\79")]:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or (4108 < 3934)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\92\174\214\96\42\208\69\173\64\172\144\122\42\194\65\173\64\172\144\98\32\215\68\171\64\235\212\119\41\198\67\183\71\189\213\50\123", "\196\46\203\176\18\79\163\45");
									end
								end
							end
							if ((3499 >= 3439) and (v87 == "Dreamwalker's Healing Potion")) then
								if ((876 < 3303) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\156\48\123\31\41\236\238\180\41\123\12\55\211\234\185\46\119\16\35\203\224\172\43\113\16", "\143\216\66\30\126\68\155")]:IsReady()) then
									if ((2922 <= 3562) and v24(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\174\218\8\202\200\180\214\237\161\205\31\216\133\171\210\224\166\193\3\204\133\179\216\245\163\199\3\139\193\166\209\228\164\219\4\221\192", "\129\202\168\109\171\165\195\183");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((2619 >= 1322) and (2 == v131)) then
				if ((4133 >= 2404) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\64\100\15\247\88\117\4\224", "\106\133\46\16")]:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:UnitName() ~= v14:UnitName())) then
					if (v24(v100.InterveneFocus) or (1433 == 2686)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\46\103\249\72\86\93\46\118\188\94\69\94\37\125\239\83\86\93", "\32\56\64\19\156\58");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\205\227\83\84\225\137\76\205\214\66\91\252\131\95", "\224\58\168\133\54\58\146")]:IsCastable() and v14:BuffDown(v98.DefensiveStance, true) and v69 and (v14:HealthPercentage() <= v79)) or (4123 == 4457)) then
					if (v24(v98.DefensiveStance) or (3972 <= 205)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\83\77\248\123\149\142\29\92\105\88\233\116\136\132\14\25\82\78\251\112\136\148\2\79\83", "\107\57\54\43\157\21\230\231");
					end
				end
				v131 = 3;
			end
			if ((v131 == 3) or (3766 < 1004)) then
				if ((1784 < 2184) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\249\138\5\225\181\217\252\207\138\31\246\188", "\175\187\235\113\149\217\188")]:IsCastable() and v14:BuffDown(v98.BattleStance, true) and v69 and (v14:HealthPercentage() > v82)) then
					if (v24(v98.BattleStance) or (1649 > 4231)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\174\149\88\239\124\71\47\187\128\66\224\124\56\61\169\149\73\241\57\124\57\169\132\66\240\112\110\57\239\146\88\226\119\123\57\239\133\73\229\124\118\47\166\151\73", "\24\92\207\225\44\131\25");
					end
				end
				if ((3193 == 3193) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\99\214\185\64\15\117\88\199\183\66\30", "\29\43\179\216\44\123")]:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
					if (v24(v100.Healthstone) or (3495 > 4306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\220\33\64\169\209\51\88\178\215\37\12\185\220\38\73\179\202\41\90\184\153\115", "\44\221\185\64");
					end
				end
				v131 = 4;
			end
			if ((4001 > 3798) and (v131 == 0)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\7\141\171\88\1\154\56\29\40\145\177\69\16\145", "\112\69\228\223\44\100\232\113")]:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or (4688 <= 4499)) then
					if (v24(v98.BitterImmunity) or (1567 <= 319)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\22\19\199\179\110\185\221\18\10\198\184\117\146\205\95\3\214\176\121\136\199\22\17\214", "\230\180\127\103\179\214\28");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\12\90\100\253\117\232\137\54\72\73\246\69", "\128\236\101\63\38\132\33")]:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or (4583 == 3761)) then
					if ((3454 > 1580) and v24(v98.DieByTheSword)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\160\20\123\180\242\240\184\161\20\123\165\252\192\190\173\81\64\179\237\202\162\186\24\82\179", "\175\204\201\113\36\214\139");
					end
				end
				v131 = 1;
			end
			if ((v131 == 1) or (1607 == 20)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\110\203\59\211\22\66\252\52\213\10", "\100\39\172\85\188")]:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or (962 >= 4666)) then
					if (v24(v98.IgnorePain, nil, nil, true) or (1896 == 1708)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\127\183\143\33\168\71\169\129\58\163\56\189\133\53\168\118\170\137\37\168", "\83\205\24\217\224");
					end
				end
				if ((3985 >= 1284) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\196\193\49\255\204\195\58\197\215\212", "\93\134\165\173")]:IsCastable() and v67 and v14:BuffDown(v98.AspectsFavorBuff) and v14:BuffDown(v98.RallyingCry) and (((v14:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77))) then
					if (v24(v98.RallyingCry) or (1987 == 545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\243\205\206\35\199\188\121\129\241\211\219\122\202\183\120\187\252\210\203\44\203", "\30\222\146\161\162\90\174\210");
					end
				end
				v131 = 2;
			end
		end
	end
	local function v112()
		local v132 = 0;
		while true do
			if ((v132 == 1) or (4896 < 1261)) then
				v28 = v94.HandleBottomTrinket(v101, v31, 40, nil);
				if ((23 < 3610) and v28) then
					return v28;
				end
				break;
			end
			if ((v132 == 0) or (3911 < 2578)) then
				v28 = v94.HandleTopTrinket(v101, v31, 40, nil);
				if (v28 or (4238 < 87)) then
					return v28;
				end
				v132 = 1;
			end
		end
	end
	local function v113()
		local v133 = 0;
		while true do
			if ((2538 == 2538) and (v133 == 0)) then
				if ((4122 == 4122) and v102) then
					local v195 = 0;
					while true do
						if ((v195 == 0) or (2371 > 2654)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\83\34\212\210\7\246\46\81\35\204\219\6", "\134\66\56\87\184\190\116")]:IsCastable() and v45) or (3466 > 4520)) then
								if (v24(v98.Skullsplitter) or (951 >= 1027)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\47\58\28\183\21\248\49\57\53\37\29\190\11\171\49\39\57\50\6\182\27\234\53", "\85\92\81\105\219\121\139\65");
								end
							end
							if (((v91 < v104) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\188\92\74\111\204\232\160\99\72\125\204\245", "\191\157\211\48\37\28")]:IsCastable() and v37 and ((v55 and v31) or not v55)) or (1369 > 2250)) then
								if (v24(v98.ColossusSmash) or (937 > 3786)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\220\16\248\19\41\204\10\231\35\41\210\30\231\20\122\207\13\241\31\53\210\29\245\8", "\90\191\127\148\124");
								end
							end
							v195 = 1;
						end
						if ((v195 == 1) or (901 > 4218)) then
							if ((4779 > 4047) and (v91 < v104) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\79\134\60\21\106\130\47\28\125\149", "\119\24\231\78")]:IsCastable() and v50 and ((v58 and v31) or not v58)) then
								if ((4050 > 1373) and v24(v98.Warbreaker)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\149\44\183\72\206\69\16\137\40\183\10\204\82\20\129\34\168\72\221\84", "\113\226\77\197\42\188\32");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\0\241\167\42\25\227\176\40", "\213\90\118\148")]:IsCastable() and v41) or (1037 > 4390)) then
								if ((1407 <= 1919) and v24(v98.Overpower)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\84\56\177\68\93\84\57\177\68\13\75\60\177\85\66\86\44\181\66", "\45\59\78\212\54");
								end
							end
							break;
						end
					end
				end
				if ((2526 >= 1717) and v35 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\51\94\130\153\129\43", "\144\112\54\227\235\230\78\205")]:IsCastable()) then
					if (v24(v98.Charge) or (3620 <= 2094)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\32\14\238\215\94\243\56\29\249\211\84\190\42\14\232", "\59\211\72\111\156\176");
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v134 = 0;
		while true do
			if ((v134 == 4) or (1723 >= 2447)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\54\226\148\69\236\49\10\15\255\143\90\232", "\89\123\141\230\49\141\93")]:IsReady() and v40 and v14:BuffUp(v98.SweepingStrikes) and (v14:BuffStack(v98.CrushingAdvanceBuff) == 3)) or (1199 > 3543)) then
					if ((1617 < 3271) and v24(v98.MortalStrike, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\126\228\24\17\70\204\98\226\30\25\65\246\49\254\13\19\10\171\32\184\89", "\42\147\17\150\108\112");
					end
				end
				if ((3085 > 1166) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\32\176\40\109\247\231\24\163\63", "\136\111\198\77\31\135")]:IsCastable() and v41 and v14:BuffUp(v98.SweepingStrikes) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\27\162\87\185\234\22\188\5\1\179", "\201\98\105\199\54\221\132\119")]:IsAvailable()) then
					if ((4493 >= 3603) and v24(v98.Overpower, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\26\134\51\18\58\187\188\30\195\41\3\54\236\225\94", "\204\217\108\227\65\98\85");
					end
				end
				if ((2843 <= 2975) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\115\204\231\241\45\204\109\215\231\236\39\197", "\160\62\163\149\133\76")]:IsReady() and v40) then
					if (v94.CastCycle(v98.MortalStrike, v105, v109, not v102) or (1989 <= 174)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\175\31\59\194\218\159\30\59\209\223\171\8\111\203\215\163\77\119\144", "\163\182\192\109\79");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\62\5\195\224\32\35", "\149\84\70\96\160")]:IsReady() and v38 and (v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= 2) and ((v15:HealthPercentage() < 20) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\7\30\254\57\5\31\232", "\141\88\102\109")]:IsAvailable() and (v15:HealthPercentage() < 35)))) or v14:BuffUp(v98.SweepingStrikes))) or (209 > 2153)) then
					if (v94.CastCycle(v98.Execute, v105, v110, not v102) or (2020 == 1974)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\75\207\115\15\41\80\129\187\82\201\48\66\105", "\161\211\51\170\16\122\93\53");
					end
				end
				v134 = 5;
			end
			if ((v134 == 3) or (1347 == 1360)) then
				if (((v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\199\18\192\88\229\188\203\217\30", "\200\164\171\115\164\61\150")]:IsCastable() and (((v106 > 1) and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\138\241\16\81\140\184\217\10\66\139\170", "\227\222\148\99\37")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((v106 > 1) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)))) or (4461 == 3572)) then
					if (v24(v98.Bladestorm, not v102) or (2872 == 318)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\94\83\242\252\32\70\93\228\244\115\90\83\245\185\100\10", "\153\83\50\50\150");
					end
				end
				if ((568 == 568) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\122\118\29\101\174", "\45\61\22\19\124\19\203")]:IsReady() and v36 and ((v106 > 2) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\19\25\225\14\117\181\206\0\9", "\217\161\114\109\149\98\16")]:IsAvailable() and v14:BuffUp(v98.MercilessBonegrinderBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\47\42\104\189\120\33\52\42\117\183\113", "\20\114\64\88\28\220")]:CooldownRemains() > v14:GCD())))) then
					if ((4200 == 4200) and v24(v98.Cleave, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\13\215\181\238\213\253\57\0\209\244\175\137", "\221\81\97\178\212\152\176");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\250\239\20\233\22\218\238\19\255", "\122\173\135\125\155")]:IsReady() and v51 and ((v106 > 2) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\183\213\15\171\50\62\206\183\214\15\171\59\34", "\168\228\161\96\217\95\81")]:IsAvailable() and (v14:BuffUp(v98.MercilessBonegrinderBuff) or v14:BuffUp(v98.HurricaneBuff))))) or (4285 < 1369)) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(v27)) or (3520 > 4910)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\217\39\78\35\64\210\223\42\28\39\86\216\145\118\12", "\55\187\177\78\60\79");
					end
				end
				if ((2842 <= 4353) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\197\74\231\74\220\144\33\199\75\255\67\221", "\224\77\174\63\139\38\175")]:IsCastable() and v45 and ((v14:Rage() < 40) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\176\72\92\43\139\71\122\34\139\78\92", "\78\228\33\56")]:IsAvailable() and (v15:DebuffRemains(v98.RendDebuff) > 0) and ((v14:BuffUp(v98.SweepingStrikes) and (v106 > 2)) or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))))) then
					if (v24(v98.Skullsplitter, not v15:IsInMeleeRange(v27)) or (3751 < 1643)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\221\105\183\6\149\199\112\181\60\150\218\108\187\8\128\221\62\183\27\128\205\107\166\6\197\150\47", "\229\174\30\210\99");
					end
				end
				v134 = 4;
			end
			if ((v134 == 7) or (4911 == 3534)) then
				if ((3001 > 16) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\181\70\86\77\188\222\87\140\74", "\62\226\46\63\63\208\169")]:IsReady() and v51 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\214\13\90\145\18\2\41\109\242\22\71\135\12", "\62\133\121\53\227\127\109\79")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\54\17\32\227\217\188\173\22\54\51\225\194\162\167", "\194\112\116\82\149\182\206")]:IsAvailable() and (v106 > 1)))) then
					if ((2875 <= 3255) and v24(v98.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\160\69\10\204\245\7\55\172\12\16\193\225\78\96\251", "\110\89\200\44\120\160\130");
					end
				end
				if ((368 < 4254) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\207\78\71\85\79", "\45\203\163\43\38\35\42\91")]:IsReady() and v36 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\241\151\201\48\143\160\90\213\163\211\49\132\172", "\52\178\229\188\67\231\201")]:IsAvailable()) then
					if (v24(v98.Cleave, not v102) or (4841 <= 2203)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\77\85\5\225\89\99\41\64\83\68\174\8", "\67\65\33\48\100\151\60");
					end
				end
				if ((4661 > 616) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\246\224\160\215\225\218\215\175\209\253", "\147\191\135\206\184")]:IsReady() and v66 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\166\41\178\213\212\86\190\139\58\162", "\210\228\72\198\161\184\51")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\23\71\244\21\97\227\55\71\242\23\118\195\51\71\231", "\174\86\41\147\112\19")]:IsAvailable() and (v14:Rage() > 30) and ((v15:HealthPercentage() < 20) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\1\158\24\36\12\3\174", "\203\59\96\237\107\69\111\113")]:IsAvailable() and (v15:HealthPercentage() < 35)))) then
					if (v24(v98.IgnorePain, not v102) or (1943 == 2712)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\17\162\238\35\245\232\52\23\165\239\113\248\214\39\86\245\180", "\183\68\118\204\129\81\144");
					end
				end
				if ((4219 >= 39) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\161\113\233", "\226\110\205\16\132\107")]:IsReady() and v46 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\209\245\202\73\226\205\231\255\78\249\192\229", "\33\139\163\128\185")]:IsAvailable() and (v14:Rage() > 30) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\93\22\200\88\74\11\216\117\89\16\202\91\93", "\190\55\56\100")]:IsAvailable() and (v106 == 1)) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\112\170\46\8\28\241\252\80\141\61\10\7\239\246", "\147\54\207\92\126\115\131")]:IsAvailable())) then
					if ((3967 > 2289) and v24(v98.Slam, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\61\52\112\77\118\12\50\117\36\91", "\30\109\81\85\29\109");
					end
				end
				v134 = 8;
			end
			if ((2 == v134) or (851 > 2987)) then
				if ((4893 >= 135) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\55\236\255\58\58\235\254\43\44\203\254\63\45", "\145\94\95\153")]:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\200\7\193\65\177\208\196\19\221\90", "\215\157\173\116\181\46")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((v106 > 1) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (3084 > 3214)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\188\158\252\222\48\166\132\231\201\10\166\132\243\200\117\188\138\241\154\98\225", "\186\85\212\235\146");
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\210\141\23\231\60\252", "\56\162\225\118\158\89\142")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\21\197\174\48\215\90\39\193\188\54\209\83\11", "\184\60\101\160\207\66")]:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\5\135\111\168\62\132\81\181\54\138\104", "\220\81\226\28")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (3426 < 2647)) then
					if (v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion)) or (1576 == 4375)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\197\135\250\248\248\28\211\189\249\235\212\7\220\141\245\170\207\18\214\194\172\188", "\167\115\181\226\155\138");
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\225\55\245\79\116\99", "\166\130\66\135\60\27\17")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\119\90\203\116\34\75\76\236\116\35\80\67\193\123", "\80\36\42\174\21")]:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\21\36\110\65\22\26\115\73\24\35", "\26\46\112\87")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (2920 < 2592)) then
					if (v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion)) or (1110 >= 2819)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\51\174\117\173\128\74\178\134\33\170\103\171\182\74\186\249\43\170\119\255\232\19", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((1824 <= 2843) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\152\129\169\214\191\158\188\221\168\128", "\178\218\237\200")]:IsCastable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\131\187\238\217\184\178\227\212", "\176\214\213\134")]:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\168\165\192\167\80\116\253\170\190\192", "\57\148\205\214\180\200\54")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if ((3062 == 3062) and v24(v98.Bladestorm, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\241\52\48\115\1\233\58\38\123\82\245\52\55\54\69\170", "\22\114\157\85\84");
					end
				end
				v134 = 3;
			end
			if ((716 <= 4334) and (5 == v134)) then
				if ((1001 < 3034) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\207\166\167\38\255\171\160\39\238\189\128\39\250\188", "\72\155\206\210")]:IsCastable()) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (977 > 1857)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\114\65\0\55\67\104\91\27\32\121\104\91\15\33\6\114\85\13\115\30\47", "\83\38\26\52\110");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\31\40\69\83\0\38\80\93", "\38\56\119\71")]:IsCastable() and v44 and (v106 > 2) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\224\86\223\38\116\252\224\85", "\54\147\143\56\182\69")]:IsAvailable() or v15:IsCasting())) or (868 > 897)) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(v27)) or (1115 == 4717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\137\240\74\212\193\128\233\76\159\222\128\252\9\135\128", "\191\182\225\159\41");
					end
				end
				if ((2740 < 4107) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\4\45\71\155\136\213\46\0", "\162\75\114\72\53\235\231")]:IsCastable() and v41 and (v106 == 1) and (((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\163\42\65\240\67\13\155\57\86", "\98\236\92\36\130\51")]:Charges() == 2) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\24\24\174\73\173\185\63\182\29", "\80\196\121\108\218\37\200\213")]:IsAvailable() and (v15:Debuffdown(v98.ColossusSmashDebuff) or (v14:RagePercentage() < 25))) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\34\114\22\107\71\11\134\15\97\6", "\234\96\19\98\31\43\110")]:IsAvailable())) then
					if ((284 < 700) and v24(v98.Overpower, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\9\87\213\188\125\156\3\13\18\207\173\113\203\94\72", "\235\102\127\50\167\204\18");
					end
				end
				if ((386 >= 137) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\99\173\244\46", "\78\48\193\149\67\36")]:IsReady() and v46 and (v106 == 1) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\31\148\12\77\53\18\143\10\69", "\33\80\126\224\120")]:IsAvailable() and (v14:RagePercentage() > 70)) then
					if ((923 == 923) and v24(v98.Slam, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\164\2\201\28\228\169\0\132\4\180", "\60\140\200\99\164");
					end
				end
				v134 = 6;
			end
			if ((v134 == 1) or (4173 == 359)) then
				if ((1722 == 1722) and (v91 < v104) and v32 and ((v53 and v31) or not v53) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\173\235\77\38\19\94", "\26\236\157\44\82\114\44")]:IsCastable()) then
					if (v24(v98.Avatar, not v102) or (3994 <= 3820)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\56\212\79\43\60\149\83\43\45\149\12\123", "\59\74\78\181");
					end
				end
				if ((1488 < 1641) and (v91 < v104) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\208\72\88\161\32\208\81\95\161", "\211\69\177\58\58")]:IsCastable() and v50 and ((v58 and v31) or not v58) and (v106 > 1)) then
					if ((433 <= 2235) and v24(v98.Warbreaker, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\228\107\247\251\206\182\238\124\231\169\195\182\230\57\162\187", "\171\215\133\25\149\137");
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\199\62\245\252\35\233\81\210\197\51\233\231", "\34\129\168\82\154\143\80\156")]:IsCastable()) or (1838 > 2471)) then
					if ((2444 < 3313) and v94.CastCycle(v98.ColossusSmash, v105, v108, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\189\63\4\91\93\156\150\141\32\6\73\93\129\197\186\50\8\8\25\218", "\233\229\210\83\107\40\46");
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\226\77\62\217\22\210\87\33\229\8\192\81\58", "\101\161\34\82\182")]:IsCastable()) or (3685 <= 185)) then
					if ((738 <= 1959) and v24(v98.ColossusSmash, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\2\85\241\200\241\151\61\215\30\84\255\200\234\194\38\233\14\25\169\143", "\78\136\109\57\158\187\130\226");
					end
				end
				v134 = 2;
			end
			if ((v134 == 6) or (1317 == 3093)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\226\1\52\178\136\227\1\52", "\194\231\148\100\70")]:IsCastable() and v41 and (((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\105\90\196\177\230\199\81\73\211", "\168\38\44\161\195\150")]:Charges() == 2) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\249\145\98\63\238\155\31\135\244\150", "\118\224\156\226\22\80\136\214")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\235\74\148\77\232\116\137\69\230\77", "\224\34\142\57")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\252\166\209\201\127\244\81\1\204\163", "\110\190\199\165\189\19\145\61")]:IsAvailable())) or (v14:Rage() < 70))) or (2611 >= 4435)) then
					if (v24(v98.Overpower, not v102) or (117 > 4925)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\253\114\250\155\200\205\238\101\168\131\198\217\171\47\177", "\167\186\139\23\136\235");
					end
				end
				if ((107 <= 4905) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\46\189\157\3\30\176\154\46\22\180\152", "\109\122\213\232")]:IsReady() and v48 and (v106 > 2)) then
					if (v24(v98.ThunderClap, not v102) or (1004 > 4035)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\255\183\62\234\242\176\15\237\251\163\32\174\255\163\51\174\174\242", "\80\142\151\194");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\46\201\101\88\2\202\68\88\17\207\124\73", "\44\99\166\23")]:IsReady() and v40) or (2802 < 369)) then
					if ((1497 <= 2561) and v24(v98.MortalStrike, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\113\248\59\34\50\168\67\228\61\36\58\175\121\183\33\55\48\228\37\166", "\196\28\151\73\86\83");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\193\6\39\20", "\22\147\99\73\112\226\56\120")]:IsReady() and v42 and (v106 == 1) and v15:DebuffRefreshable(v98.RendDebuff)) or (816 > 1712)) then
					if (v24(v98.Rend, not v102) or (2733 == 2971)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\112\236\241\205\176\116\225\181\212\234", "\237\216\21\130\149");
					end
				end
				v134 = 7;
			end
			if ((2599 < 4050) and (v134 == 0)) then
				if ((2034 == 2034) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\159\230\46\91\147\230", "\77\46\231\131")]:IsReady() and v38 and v14:BuffUp(v98.JuggernautBuff) and (v14:BuffRemains(v98.JuggernautBuff) < v14:GCD())) then
					if ((3040 < 4528) and v24(v98.Execute, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\76\179\67\175\64\179\0\178\85\181\0\236\3", "\32\218\52\214");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\31\36\166\245\181\87\121\66\22\33", "\58\46\119\81\200\145\208\37")]:IsReady() and v48 and (v106 > 2) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\128\63\163\173\188\56\47\184\56\185\167\185\51\57", "\86\75\236\80\204\201\221")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\64\68\121\129", "\235\18\33\23\229\158")]:IsAvailable() and v15:DebuffRefreshable(v98.RendDebuff)) or (2092 <= 2053)) then
					if ((2120 < 4799) and v24(v98.ThunderClap, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\178\212\181\84\191\211\132\83\182\192\171\16\178\192\184\16\236\153", "\219\48\218\161");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\215\102\121\76\203\70\238\227\66\104\91\210\68\229\247", "\128\132\17\28\41\187\47")]:IsCastable() and v47 and (v106 >= 2) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\62\7\62\88\18\38\9\40\80", "\61\97\82\102\90")]:CooldownRemains() > 15) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\142\34\170\79\194\68\10\6\190\35", "\105\204\78\203\43\167\55\126")]:IsAvailable())) or (4538 <= 389)) then
					if ((270 <= 1590) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\189\38\27\3\13\201\86\154\185\55\12\26\15\194\66\229\162\34\29\83\82\159", "\49\197\202\67\126\115\100\167");
					end
				end
				if ((1625 > 1265) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\5\94\209\45", "\62\87\59\191\73\224\54")]:IsReady() and v42 and (v106 == 1) and ((v15:HealthPercentage() > 20) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\202\3\233\218\230\1\232\204", "\169\135\98\154")]:IsAvailable() and (v15:HealthPercentage() < 35)))) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\126\32\81\242\53\234\199\120\43\80", "\168\171\23\68\52\157\83")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\122\224\161\41\62\151\248\120\225\185\32\63", "\231\148\17\149\205\69\77")]:CooldownRemains() <= v14:GCD()) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\163\168\203\244\68\236\149\180\244\246\86\236\136", "\159\224\199\167\155\55")]:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (21 * 0.85))))) then
					if (v24(v98.Rend, not v102) or (51 >= 920)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\246\50\214\183\251\61\209\183\164\108", "\178\151\147\92");
					end
				end
				v134 = 1;
			end
			if ((v134 == 8) or (2968 <= 1998)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\121\91\181\61\201\253\233\116", "\156\159\17\52\214\86\190")]:IsCastable() and v44 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\224\179\181\173\205\178\179\163", "\220\206\143\221")]:IsAvailable())) or (3085 <= 2742)) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(v27)) or (376 >= 2083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\149\117\34\20\211\219\211\144\120\109\31\217\207\146\223\42", "\178\230\29\77\119\184\172");
					end
				end
				if ((4191 > 1232) and v31 and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\215\178\11\31\114\235\225\177\24\22", "\152\149\222\106\123\23")]:IsCastable()) then
					if (v24(v98.Bladestorm, not v102) or (1505 > 4873)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\42\247\71\176\206\50\249\81\184\157\46\247\64\245\132\126", "\213\189\70\150\35");
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v135 = 0;
		while true do
			if ((3880 < 4534) and (v135 == 1)) then
				if (((v91 < v104) and v50 and ((v58 and v31) or not v58) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\52\94\209\249\17\90\194\240\6\77", "\155\99\63\163")]:IsCastable()) or (2368 >= 2541)) then
					if (v24(v98.Warbreaker, not v102) or (4733 <= 4103)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\149\208\179\143\171\129\131\218\164\159\249\129\154\212\162\152\173\129\194\132\245", "\228\226\177\193\237\217");
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\23\191\47\233\39\163\54\245\7\189\34\245\60", "\134\84\208\67")]:IsCastable()) or (1207 == 4273)) then
					if (v24(v98.ColossusSmash, not v102) or (2005 == 2529)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\163\138\83\0\191\147\79\44\191\139\93\0\164\198\89\11\169\133\73\7\169\198\9\70", "\60\115\204\230");
					end
				end
				if ((986 < 3589) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\34\238\115\242\46\238", "\16\135\90\139")]:IsReady() and v38 and v14:BuffUp(v98.SuddenDeathBuff) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)) then
					if (v24(v98.Execute, not v102) or (3119 == 430)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\108\3\48\91\64\125\20\113\30\54\77\65\108\81\52\83\101", "\24\52\20\102\83\46\52");
					end
				end
				v135 = 2;
			end
			if ((2409 <= 3219) and (v135 == 2)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\36\52\40\3\215\63\45\45\27\208\42\51", "\111\164\79\65\68")]:IsCastable() and v45 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\242\220\144\202\33\236\235\208\132\214\58", "\138\166\185\227\190\78")]:IsAvailable() and (v14:RagePercentage() <= 30)) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\113\214\35\93\37\52\194\115\205\35", "\121\171\20\165\87\50\67")]:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\229\55\181\57\170\17\211\43\138\59\184\17\206", "\98\166\88\217\86\217")]:CooldownRemains() > 5)) and (v14:RagePercentage() <= 30)))) or (898 > 2782)) then
					if (v24(v98.Skullsplitter, not v15:IsInMeleeRange(v27)) or (2250 <= 1764)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\253\108\13\138\207\230\250\112\21\146\217\228\182\124\25\131\223\227\226\124\65\211\139", "\188\150\150\25\97\230");
					end
				end
				if ((693 == 693) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\129\74\12\8\232\200\134\74\17\62\226\219\155", "\141\186\233\63\98\108")]:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\239\63\162\42\247\199\37\177\45\229", "\69\145\138\76\214")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (2529 == 438)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\100\199\156\135\187\19\98\192\156\154\128\4\127\206\155\201\186\14\117\204\156\157\186\86\37\152", "\118\16\175\233\233\223");
					end
				end
				if ((1751 > 1411) and (v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\155\136\52\162\235\153", "\29\235\228\85\219\142\235")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\14\196\191\220\101\65\33\112\60\199\174\212\120\64", "\50\93\180\218\189\23\46\71")]:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) then
					if ((4182 == 4182) and v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\180\94\77\86\227\71\216\155\89\77\87\200\65\209\170\27\73\92\217\75\203\176\94\12\17\139", "\40\190\196\59\44\36\188");
					end
				end
				v135 = 3;
			end
			if ((v135 == 0) or (4666 <= 611)) then
				if (((v91 < v104) and v47 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\66\113\13\95\92\122\15\124\65\102\1\68\80\103", "\104\47\53\20")]:IsCastable() and (v106 > 1)) or (4737 <= 4525)) then
					if ((4367 >= 3735) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\91\132\25\172\6\173\75\190\15\168\29\170\71\132\15\252\10\187\73\130\9\168\10\227\25\208", "\111\195\44\225\124\220");
					end
				end
				if ((2426 == 2426) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\234\67\14\119", "\203\184\38\96\19\203")]:IsReady() and v42 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\127\118\78\202\53\118\109\85\199\55\116", "\174\89\19\25\33")]:IsAvailable() and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\24\19\64\76\229\130\10\36\23\64", "\107\79\114\50\46\151\231")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\185\38\153\42\162\211\10\171\180\58\130", "\160\89\198\213\73\234\89\215")]:CooldownRemains() < 4)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\127\112\166\252\215\77\112\191\251\215", "\165\40\17\212\158")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\210\216\26\49\52\224\216\3\54\52", "\70\133\185\104\83")]:CooldownRemains() < 4))) and (v15:TimeToDie() > 12)) then
					if ((21 < 1971) and v24(v98.Rend, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\64\74\46\137\1\93\65\41\220\16\64\4\127\155", "\169\100\37\36\74");
					end
				end
				if (((v91 < v104) and v32 and ((v53 and v31) or not v53) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\33\145\163\68\1\149", "\48\96\231\194")]:IsCastable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\235\85\2\34\10\203\186\144\251\87\15\62\17", "\227\168\58\110\77\121\184\207")]:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or (v104 < 20))) or (2922 <= 441)) then
					if ((3624 >= 1136) and v24(v98.Avatar, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\122\42\190\84\176\201\49\160\99\57\188\85\165\222\49\240\40", "\197\27\92\223\32\209\187\17");
					end
				end
				v135 = 1;
			end
			if ((2043 < 2647) and (v135 == 4)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\2\34\160\206\102\160\192\131\63", "\230\77\84\197\188\22\207\183")]:IsCastable() and v41 and (v14:Rage() < 40) and (v14:BuffStack(v98.MartialProwessBuff) < 2)) or (354 >= 1534)) then
					if (v24(v98.Overpower, not v102) or (3764 >= 4876)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\2\195\238\156\174\231\48\235\84\195\228\137\162\229\33\252\84\144\172", "\85\153\116\166\156\236\193\144");
					end
				end
				if ((3676 >= 703) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\129\248\72\176\241\20\161", "\96\196\128\45\211\132")]:IsReady() and v38) then
					if ((3811 > 319) and v24(v98.Execute, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\149\126\92\199\187\177\152\48\149\126\92\199\187\177\152\99\223", "\184\85\237\27\63\178\207\212");
					end
				end
				if ((47 < 1090) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\81\6\92\3\78\8\73\13", "\63\104\57\105")]:IsCastable() and v44 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\136\170\77\8\165\171\75\6", "\36\107\231\196")]:IsAvailable() or v15:IsCasting())) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(v27)) or (1371 >= 2900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\189\173\132\86\162\163\145\88\245\167\159\88\182\183\147\88\245\244\212", "\231\61\213\194");
					end
				end
				v135 = 5;
			end
			if ((v135 == 3) or (1126 <= 504)) then
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\63\80\206\167\245\111", "\109\92\37\188\212\154\29")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\255\161\194\35\85\2\205\165\208\37\83\11\225", "\58\100\143\196\163\81")]:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (3732 == 193)) then
					if ((3344 >= 3305) and v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\82\38\162\45\118\234\8\37\64\34\176\43\64\234\0\90\71\59\166\60\92\241\11\90\23\116", "\110\122\34\67\195\95\41\133");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\86\189\94\75\192\112", "\182\21\209\59\42")]:IsReady() and v36 and (v106 > 2) and (v15:DebuffRemains(v98.DeepWoundsDebuff) < v14:GCD())) or (2885 < 1925)) then
					if (v24(v98.Cleave, not v102) or (4542 <= 1594)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\91\192\28\55\187\247\82\221\24\34\171\163\82\133\72\121", "\222\215\55\165\125\65");
					end
				end
				if ((338 <= 3505) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\222\212\14\243\205\222\94\62\216\205\31", "\42\76\177\166\122\146\161\141")]:IsReady() and v40 and ((v15:DebuffStack(v98.ExecutionersPrecisionDebuff) == 2) or (v15:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()))) then
					if ((69 == 69) and v24(v98.MortalStrike, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\133\23\218\120\122\154\153\17\220\112\125\160\202\0\214\124\117\176\158\0\142\44\47", "\22\197\234\101\174\25");
					end
				end
				v135 = 4;
			end
			if ((v135 == 5) or (672 == 368)) then
				if ((1019 == 1019) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\187\56\97\25\162\42\118\27", "\19\105\205\93")]:IsCastable() and v41) then
					if (v24(v98.Overpower, not v102) or (290 > 2746)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\30\219\147\47\166\31\219\147\127\172\16\219\130\42\189\13\158\215\107", "\95\201\104\190\225");
					end
				end
				if ((1923 < 4601) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\199\192\202\170\216\213\193\189\198", "\174\207\171\161")]:IsCastable()) then
					if (v24(v98.Bladestorm, not v102) or (3957 == 2099)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\242\12\247\253\196\249\241\31\254\184\210\245\251\14\230\236\210\173\168\88", "\183\141\158\109\147\152");
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v136 = 0;
		while true do
			if ((4006 > 741) and (v136 == 0)) then
				if ((2359 <= 3733) and (v91 < v104) and v47 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\30\227\9\60\0\232\11\31\29\244\5\39\12\245", "\108\76\105\134")]:IsCastable() and (v106 > 1)) then
					if (v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27)) or (4596 <= 2402)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\210\180\228\222\226\203\182\222\221\255\215\184\234\203\248\133\162\232\192\236\201\180\222\218\234\215\182\228\218\171\156\230", "\174\139\165\209\129");
					end
				end
				if ((2078 > 163) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\171\231\194\211\23\117", "\24\195\211\130\161\166\99\16")]:IsReady() and (v14:BuffUp(v98.SuddenDeathBuff))) then
					if ((4116 > 737) and v24(v98.Execute, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\27\236\47\70\2\67\67\250\37\93\17\74\6\214\56\82\4\65\6\253\108\10\78", "\118\38\99\137\76\51");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\208\41\23\6\8\44\206\50\23\27\2\37", "\64\157\70\101\114\105")]:IsReady() and v40) or (1175 > 4074)) then
					if (v24(v98.MortalStrike, not v102) or (1361 == 4742)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\167\181\247\17\76\151\180\247\2\73\163\162\163\3\73\166\160\239\21\127\188\166\241\23\69\188\231\186\73", "\112\32\200\199\131");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\85\82\188", "\66\76\48\60\216\163\203")]:IsReady() and v42 and ((v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\142\143\125\246\80\200\6\182\137\118\247", "\68\218\230\25\147\63\174")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\158\33\70\64\186\190\58\95\69\162\185\47\65", "\214\205\74\51\44")]:CooldownRemains() <= v14:GCD()) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\217\67\238\243\100\233\89\241\207\122\251\95\234", "\23\154\44\130\156")]:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\163\163\170\18\22\19\179\171\168", "\115\113\198\205\206\86")]:BaseDuration() * 0.85))))) or (4012 >= 4072)) then
					if ((3807 >= 1276) and v24(v98.Rend, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\82\240\94\196\68\247\84\131\91\251\101\144\86\236\93\129\67\190\11\212\7", "\58\228\55\158");
					end
				end
				v136 = 1;
			end
			if ((2220 <= 4361) and (v136 == 4)) then
				if ((228 == 228) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\41\184\15\26\20\255\23\190\2", "\136\126\208\102\104\120")]:IsReady() and v51 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\75\158\193\81\162\93\59\98\111\133\220\71\188", "\49\24\234\174\35\207\50\93")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\247\238\156\126\10\223\244\143\121\24", "\17\108\146\157\232")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\104\204\24\226\60\187\94\208\39\224\46\187\67", "\200\43\163\116\141\79")]:CooldownRemains() > (v14:GCD() * 7))) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(v27)) or (4118 <= 3578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\62\52\145\188\227\234\177\50\125\144\185\250\228\179\51\2\151\177\230\228\186\34\125\210\225\167", "\131\223\86\93\227\208\148");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\83\179\164\13\186\244\64\164", "\213\131\37\214\214\125")]:IsCastable() and v41 and (((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\61\32\173\241\41\60\32\173", "\129\70\75\69\223")]:Charges() == 2) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\100\202\231\253\112\234\74\196\225\237", "\143\38\171\147\137\28")]:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v14:RagePercentage() < 25))) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\242\131\173\231\15\230\216\223\144\189", "\180\176\226\217\147\99\131")]:IsAvailable())) or (2915 < 1909)) then
					if ((634 <= 2275) and v24(v98.Overpower, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\175\42\21\195\182\56\2\193\249\60\14\221\190\35\2\236\173\46\21\212\188\59\71\130\232\123", "\103\179\217\79");
					end
				end
				if ((1091 <= 2785) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\121\187\29\216", "\195\42\215\124\181\33\236")]:IsReady() and v46 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\46\75\34\45\45\241\3\94\17\49\55\251\8", "\152\109\57\87\94\69")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:Rage() >= 60) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\210\25\183\177\212\121\161\254\223\30", "\200\153\183\106\195\222\178\52")]:IsAvailable()) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\238\152\47\70\76\55\231\187\49\72\87", "\58\82\131\232\93\41")]:IsAvailable()) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\82\194\3\82\45\140\81\242\20\73\43\143\82", "\95\227\55\176\117\61")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\62\123\49\93\164\10\113\37\105\170\12\106\47\78", "\203\120\30\67\43")]:IsAvailable() and (v106 == 1)))) then
					if ((4638 >= 2840) and v24(v98.Slam, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\41\76\226\153\226\44\67\232\213\244\26\89\238\203\246\32\89\175\136\160\112", "\185\145\69\45\143");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\189\23\16\180\208\157\22\23\162", "\188\234\127\121\198")]:IsReady() and v51 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\38\28\145\53\61\21\176\47\61\1\135\43", "\227\88\82\115")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\26\168\177\13\97\76\25\152\166\22\103\79\26", "\19\35\127\218\199\98")]:IsAvailable() and (v106 > 1)))) or (1292 > 4414)) then
					if ((3511 == 3511) and v24(v98.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\243\3\240\16\236\3\236\24\187\25\235\18\252\6\231\35\239\11\240\27\254\30\162\77\170\92", "\130\124\155\106");
					end
				end
				v136 = 5;
			end
			if ((2132 == 2132) and (v136 == 3)) then
				if ((932 <= 3972) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\207\39\55\58\217\82\11\74\252", "\36\152\79\94\72\181\37\98")]:IsReady() and v51 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\228\204\72\45\218\215\65\12\192\215\85\59\196", "\95\183\184\39")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\129\58\244\50\91\134\47\188\56\239\50", "\98\213\95\135\70\52\224")]:IsAvailable() and (v14:RagePercentage() > 80) and v15:DebuffUp(v98.ColossusSmashDebuff)) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(v27)) or (4560 <= 2694)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\171\192\101\88\233\170\199\115\20\237\170\199\112\88\251\156\221\118\70\249\166\221\55\5\174\251", "\52\158\195\169\23");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\78\180\39\122\130\48\105\168\118\189\34", "\235\26\220\82\20\230\85\27")]:IsReady() and v48 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\188\168\237\199\123\142\131\229\205\123\140", "\20\232\193\137\162")]:IsAvailable()) or (2531 >= 3969)) then
					if (v24(v98.ThunderClap, not v102) or (738 > 2193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\215\208\168\227\137\5\78\33\211\196\182\167\159\30\127\37\211\192\153\243\141\5\118\39\203\133\247\183\213", "\17\66\191\165\198\135\236\119");
					end
				end
				if ((4606 >= 3398) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\163\175\23\250\251\248\222\29\162", "\177\111\207\206\115\159\136\140")]:IsCastable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\156\2\6\221\76\94\11\140", "\63\101\233\112\116\180\47")]:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\62\254\6\247\48\238\50\234\26\236", "\86\163\91\141\114\152")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\102\5\124\122\52\84\14\112", "\90\51\107\20\19")]:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\185\245\150\251\50\139\221\140\232\53\153", "\93\237\144\229\143")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))))) then
					if ((1853 > 1742) and v24(v98.Bladestorm, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\250\241\29\14\85\1\249\226\20\75\85\28\248\247\21\14\121\1\247\226\30\14\82\85\167\161\73", "\38\117\150\144\121\107");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\179\225\57\38\172\239\44\40", "\90\77\219\142")]:IsCastable() and v44 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\11\47\48\79\37\117\233\9", "\26\134\100\65\89\44\103")]:IsAvailable() or v15:IsCasting())) or (2442 > 2564)) then
					if ((4374 >= 4168) and v24(v98.Shockwave, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\235\63\32\175\230\226\38\38\228\226\234\62\36\168\244\220\36\34\182\246\230\36\99\245\160\178", "\196\145\131\80\67");
					end
				end
				v136 = 4;
			end
			if ((v136 == 1) or (4576 > 4938)) then
				if ((2930 > 649) and (v91 < v104) and v32 and ((v53 and v31) or not v53) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\149\159\209\58\61\191", "\85\212\233\176\78\92\205")]:IsCastable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\89\154\238\69\74\140\241\126\87\154\239\79\86\156", "\130\42\56\232")]:IsAvailable() and (v14:RagePercentage() < 33) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\186\40\236\83\44\255\166\23\238\65\44\226", "\95\138\213\68\131\32")]:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\29\41\179\79\121\56\44\178\119\121\56\37\164\77\98", "\22\74\72\193\35")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\232\87\63\106\241\75\31\116\229\75\36", "\56\76\25\132")]:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff))))) then
					if (v24(v98.Avatar, not v102) or (1394 < 133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\215\170\50\206\76\129\184\47\193\89\205\174\25\219\95\211\172\35\219\30\144\251\119", "\175\62\161\203\70");
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\44\209\194\10\48\46", "\85\92\189\163\115")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\26\188\53\57\59\163\54\26\40\191\36\49\38\162", "\88\73\204\80")]:IsCastable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\13\140\28\73\58\201\59\144\35\75\40\201\38", "\186\78\227\112\38\73")]:CooldownRemains() <= v14:GCD()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\86\239\87\65\127\253\92\248\71", "\26\156\55\157\53\51")]:CooldownRemains() <= v14:GCD()))) or (432 == 495)) then
					if ((66 < 1456) and v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\200\19\216\170\111\131\222\41\219\185\67\152\209\25\215\248\67\133\214\17\213\189\111\152\217\4\222\189\68\204\137\70\139", "\48\236\184\118\185\216");
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\230\168\69\35\192\38", "\84\133\221\55\80\175")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\142\247\33\167\213\83\187\197\37\181\211\85\178\233", "\60\221\135\68\198\167")]:IsCastable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\178\244\140\81\202\251\174\203\142\67\202\230", "\185\142\221\152\227\34")]:CooldownRemains() <= v14:GCD()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\196\69\248\81\54\246\83\192\69", "\151\56\165\55\154\35\83")]:CooldownRemains() <= v14:GCD()))) or (878 >= 3222)) then
					if (v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion)) or (254 >= 3289)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\83\0\239\178\124\10\232\159\65\4\253\180\74\10\224\224\80\12\224\167\79\0\209\180\66\23\233\165\87\69\191\240\17", "\142\192\35\101");
					end
				end
				if (((v91 < v104) and v50 and ((v58 and v31) or not v58) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\116\59\161\245\137\173\29\211\103", "\118\182\21\73\195\135\236\204")]:IsCastable()) or (2711 <= 705)) then
					if (v24(v98.Warbreaker, not v15:IsInRange(8)) or (2506 >= 3366)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\61\8\66\22\8\252\3\57\8\0\23\4\243\15\48\31\127\16\12\239\15\57\14\0\85\93\174", "\157\104\92\122\32\100\109");
					end
				end
				v136 = 2;
			end
			if ((v136 == 5) or (123 > 746)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\199\247\162", "\223\181\171\150\207\195\150\28")]:IsReady() and v46 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\40\246\189\1\69\52\228\136\6\94\57\230", "\105\44\90\131\206")]:IsAvailable() or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\242\167\170\0\55\241\231\148\182\26\61\250", "\94\159\128\210\217\104")]:IsAvailable() and (v14:Rage() >= 30))) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\252\20\169\80\109\246\124\114\248\18\171\83\122", "\26\48\153\102\223\63\31\153")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\36\69\255\229\13\82\226\245\32\65\249\231\14\69", "\147\98\32\141")]:IsAvailable() and (v106 == 1)))) or (4444 <= 894)) then
					if ((1376 > 583) and v24(v98.Slam, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\79\226\199\70\69\66\22\68\239\207\57\66\74\10\68\230\222\70\7\26\79", "\43\120\35\131\170\102\54");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\146\184\161\181\150\119\10\134\166", "\228\52\102\231\214\197\208")]:IsReady() and v48 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\225\97\222\230\142\21\217\12\228", "\182\126\128\21\170\138\235\121")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\169\214\58\233\130\18\62\2\191\210\32\232\130\22\34", "\102\235\186\85\134\230\115\80")]:IsAvailable()) or (2427 == 2455)) then
					if ((3393 >= 2729) and v24(v98.ThunderClap, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\4\43\81\118\209\48\104\15\50\94\98\148\49\94\2\57\83\119\235\54\86\30\57\90\102\148\115\6\84", "\66\55\108\94\63\18\180");
					end
				end
				if ((4175 == 4175) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\155\128\37\55\86\3\136\151", "\57\116\237\229\87\71")]:IsCastable() and v41 and ((v15:DebuffDown(v98.ColossusSmashDebuff) and (v14:RagePercentage() < 50) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\176\249\243\123\235\75\165\163\233", "\39\202\209\141\135\23\142")]:IsAvailable()) or (v14:RagePercentage() < 25))) then
					if ((4584 > 1886) and v24(v98.Overpower, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\37\12\24\34\247\232\54\27\74\33\241\241\52\5\15\13\236\254\33\14\15\38\184\174\98\80", "\152\159\83\105\106\82");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\182\206\88\224\197\75\136\200\85", "\60\225\166\49\146\169")]:IsReady() and v51 and v14:BuffUp(v98.MercilessBonegrinderBuff)) or (1043 >= 2280)) then
					if (v24(v98.Whirlwind, not v15:IsInRange(8)) or (667 < 71)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\22\38\56\13\16\38\16\43\106\18\14\33\25\35\47\62\19\46\12\40\47\21\71\126\76\127", "\103\79\126\79\74\97");
					end
				end
				v136 = 6;
			end
			if ((6 == v136) or (4482 < 2793)) then
				if ((561 < 4519) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\153\115\214\114\72\31", "\122\218\31\179\19\62")]:IsReady() and v36 and v14:HasTier(29, 2) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\144\196\216\210\193\168\75\180\240\194\211\202\164", "\37\211\182\173\161\169\193")]:IsAvailable()) then
					if (v24(v98.Cleave, not v102) or (677 == 1434)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\54\72\216\62\126\249\228\51\67\222\36\126\134\227\59\95\222\45\111\249\166\104\28", "\217\151\90\45\185\72\27");
					end
				end
				if ((2827 == 2827) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\112\230\22\83\208\104\232\0\91", "\54\163\28\135\114")]:IsCastable()) then
					if ((2556 == 2556) and v24(v98.Bladestorm, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\215\92\134\75\108\60\212\79\143\14\108\33\213\90\142\75\64\60\218\79\133\75\107\104\138\15\208", "\31\72\187\61\226\46");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\10\70\211\81\123", "\68\163\102\35\178\39\30")]:IsReady() and v36) or (3106 >= 4932)) then
					if (v24(v98.Cleave, not v102) or (1217 <= 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\124\223\198\21\176\195\2\183\126\221\203\6\138\151\16\172\119\223\211\67\228\209\66", "\113\222\16\186\167\99\213\227");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\11\245\242", "\150\78\110\155")]:IsReady() and v42 and v15:DebuffRefreshable(v98.RendDebuff) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\166\215\50\242\172\23\177\71\163\202\53\226\161", "\32\229\165\71\129\196\126\223")]:IsAvailable()) or (441 >= 4871)) then
					if ((3751 > 731) and v24(v98.Rend, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\140\202\133\193\198\202\135\195\141\132\234\215\136\214\134\132\193\131\216\150\213", "\181\163\233\164\225\225");
					end
				end
				break;
			end
			if ((v136 == 2) or (2515 < 1804)) then
				if ((3008 > 1924) and (v91 < v104) and v37 and ((v55 and v31) or not v55) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\169\195\197\46\52\152\184\144\171\206\217\53", "\203\195\198\175\170\93\71\237")]:IsCastable()) then
					if ((295 == 295) and v24(v98.ColossusSmash, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\68\50\218\66\2\233\61\116\45\216\80\2\244\110\88\55\219\86\29\249\17\95\63\199\86\20\232\110\26\110\129", "\156\78\43\94\181\49\113");
					end
				end
				if ((4828 >= 1725) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\65\227\209\175\7\80\105\126\225\208\183\14\81", "\25\18\136\164\195\107\35")]:IsCastable() and v45 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\40\186\91\125\186\236\177\239\37\189", "\216\136\77\201\47\18\220\161")]:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0) and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\14\227\39\213\27\207\151\62\223\38\219\27\212", "\226\77\140\75\186\104\188")]:CooldownRemains() > 3))) then
					if (v24(v98.Skullsplitter, not v102) or (4201 < 2150)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\197\197\51\67\170\222\220\54\91\173\203\194\127\92\176\192\215\51\74\134\218\209\45\72\188\218\144\110\31\236", "\47\217\174\176\95");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\214\99\14\190\71\104\42\177\201\98\7\160", "\70\216\189\22\98\210\52\24")]:IsCastable() and v45 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\218\176\147\220\220\242\170\128\219\206", "\179\186\191\195\231")]:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)) or (3076 >= 4666)) then
					if (v24(v98.Skullsplitter, not v102) or (2027 >= 3030)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\52\13\232\245\44\8\232\240\43\12\225\235\127\11\237\247\56\20\225\198\43\25\246\254\58\12\164\168\111\78", "\132\153\95\120");
					end
				end
				if ((3245 <= 3566) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\133\186\27\35\243\223\178\190\167\29\31\248\219\178", "\192\209\210\110\77\151\186")]:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\6\49\253\240\194\205\10\37\225\235", "\164\128\99\66\137\159")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:RagePercentage() < 33)) or (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\52\140\250\170\15\143\196\183\7\129\253", "\222\96\233\137")]:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (2627 <= 381)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\187\178\17\140\246\226\182\166\180\32\154\252\241\171\243\180\22\134\244\252\188\140\179\30\154\244\245\173\243\246\79\223", "\144\217\211\199\127\232\147");
					end
				end
				v136 = 3;
			end
		end
	end
	local function v117()
		local v137 = 0;
		while true do
			if ((283 < 4544) and (v137 == 0)) then
				if ((618 < 3820) and not v14:AffectingCombat()) then
					local v196 = 0;
					while true do
						if ((4287 >= 124) and (v196 == 0)) then
							if ((2569 <= 3918) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\114\138\42\99\92\142\13\99\81\133\61\114", "\23\48\235\94")]:IsCastable() and v14:BuffDown(v98.BattleStance, true)) then
								if (v24(v98.BattleStance) or (3154 <= 2030)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\126\219\204\73\91\54\237\111\206\217\83\84\54", "\178\28\186\184\61\55\83");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\204\83\40\254\11\198\204\194\82\40", "\149\164\173\39\92\146\110")]:IsCastable() and v33 and (v14:BuffDown(v98.BattleShoutBuff, true) or v94.GroupBuffMissing(v98.BattleShoutBuff))) or (3761 <= 682)) then
								if ((2128 > 836) and v24(v98.BattleShout)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\241\38\4\11\22\30\204\52\24\16\15\15\179\55\2\26\25\20\254\37\17\11", "\123\147\71\112\127\122");
								end
							end
							break;
						end
					end
				end
				if ((v94.TargetIsValid() and v29) or (2361 <= 1063)) then
					if (not v14:AffectingCombat() or (1790 >= 3221)) then
						local v202 = 0;
						while true do
							if ((4459 >= 3851) and (v202 == 0)) then
								v28 = v113();
								if (v28 or (2969 <= 1860)) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v138 = 0;
		while true do
			if ((v138 == 0) or (2123 == 39)) then
				v28 = v111();
				if (v28 or (2132 <= 201)) then
					return v28;
				end
				v138 = 1;
			end
			if ((v138 == 1) or (4338 >= 4477)) then
				if (v86 or (1732 >= 3545)) then
					local v197 = 0;
					while true do
						if ((1125 >= 64) and (v197 == 1)) then
							v28 = v94.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 8, true);
							if (v28 or (3215 > 4005)) then
								return v28;
							end
							break;
						end
						if ((2415 > 665) and (v197 == 0)) then
							v28 = v94.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 20, true);
							if (v28 or (1089 > 2205)) then
								return v28;
							end
							v197 = 1;
						end
					end
				end
				if (v94.TargetIsValid() or (2146 <= 628)) then
					local v198 = 0;
					local v199;
					while true do
						if ((v198 == 0) or (3415 >= 4449)) then
							if ((v35 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\239\197\131\99\65\201", "\38\172\173\226\17")]:IsCastable() and not v102) or (1765 > 4310)) then
								if ((906 > 200) and v24(v98.Charge, not v15:IsSpellInRange(v98.Charge))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\78\25\45\253\74\20\108\226\76\24\34\175\30\69", "\143\45\113\76");
								end
							end
							v199 = v94.HandleDPSPotion(v15:DebuffUp(v98.ColossusSmashDebuff));
							if (v199 or (3072 <= 2133)) then
								return v199;
							end
							v198 = 1;
						end
						if ((904 <= 1400) and (v198 == 3)) then
							v28 = v116();
							if (v28 or (718 > 3863)) then
								return v28;
							end
							if (v20.CastAnnotated(v98.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\233\170\86\11", "\70\190\235\31\95\66")) or (2483 == 2223)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((1405 >= 829) and (v198 == 1)) then
							if ((3341 < 3863) and v102 and v92 and ((v60 and v31) or not v60) and (v91 < v104)) then
								local v205 = 0;
								while true do
									if ((3840 > 1000) and (v205 == 2)) then
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\171\64\248\77\143\69\229\71\137", "\40\237\41\138")]:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) or (2660 < 1908)) then
											if (v24(v98.Fireblood) or (2288 > 2511)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\193\125\232\253\72\203\123\245\252\10\202\117\243\246\10\147\39", "\42\167\20\154\152");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\240\161\71\98\53\88\255\174\97\112\45\70", "\65\42\158\194\34\17")]:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) or (3592 >= 4409)) then
											if (v24(v98.AncestralCall) or (4841 < 2991)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\27\41\81\9\62\249\9\239\22\24\81\13\33\225\91\227\27\46\92\76\121\185", "\142\122\71\50\108\77\141\123");
											end
										end
										v205 = 3;
									end
									if ((v205 == 1) or (2863 <= 2540)) then
										if ((3057 <= 4822) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\62\171\89\40\115\211\35\186\74\35\120\243", "\22\135\76\200\56\70")]:IsCastable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\160\63\234\48\92\237\190\36\234\45\86\228", "\129\237\80\152\68\61")]:CooldownRemains() > 1.5) and (v14:Rage() < 50)) then
											if (v24(v98.ArcaneTorrent, not v15:IsInRange(8)) or (4688 < 1489)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\80\186\7\242\18\18\103\69\167\22\225\25\25\76\17\165\5\250\18\87\12\0", "\56\49\200\100\147\124\119");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\55\184\248\216\45\149\229\200\57\178\245\194\42", "\144\172\94\223")]:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\0\176\83\37\3\145\83\54\6\169\66", "\39\68\111\194")]:CooldownUp()) or (832 >= 4770)) then
											if ((1934 == 1934) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\218\175\224\207\109\164\233\172\242\195\126\186\211\168\243\135\116\182\223\168\167\147\43", "\215\182\198\135\167\25");
											end
										end
										v205 = 2;
									end
									if ((v205 == 0) or (4524 <= 2618)) then
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\154\180\19\51\188\158\9\46\161", "\92\216\216\124")]:IsCastable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or (4166 >= 4169)) then
											if (v24(v98.BloodFury) or (3725 < 86)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\89\62\163\79\249\100\52\185\82\228\27\63\173\73\243\27\97\245", "\157\59\82\204\32");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\26\59\241\233\236\248\216\184\54\57", "\209\88\94\131\154\137\138\179")]:IsCastable() and (v15:DebuffRemains(v98.ColossusSmashDebuff) > 6)) or (4822 <= 153)) then
											if (v24(v98.Berserking) or (1816 > 2293)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\42\164\214\111\27\49\58\43\38\166\132\113\31\42\63\98\124\241", "\66\72\193\164\28\126\67\81");
											end
										end
										v205 = 1;
									end
									if ((v205 == 3) or (2823 >= 3213)) then
										if ((4702 > 2133) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\163\248\23\61\33\176\246\27\48\6", "\91\117\194\159\120")]:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\18\44\12\52\253\23\14\15\55\19\48", "\68\122\125\94\120\85\145")]:CooldownUp()) then
											if (v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks)) or (3335 <= 3201)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\21\29\200\97\199\223\133\3\14\198\93\195\202\250\26\29\198\80\136\136\234", "\218\119\124\175\62\168\185");
											end
										end
										break;
									end
								end
							end
							if ((v91 < v104) or (3347 < 1460)) then
								if ((v93 and ((v31 and v59) or not v59)) or (4691 < 4371)) then
									local v208 = 0;
									while true do
										if ((612 == 612) and (v208 == 0)) then
											v28 = v112();
											if (v28 or (4840 <= 4170)) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if ((1346 == 1346) and v39 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\245\90\203\172\243\124\204\183\255\95", "\164\197\144\40")]:IsCastable() and not v15:IsInRange(30)) then
								if (v24(v98.HeroicThrow, not v15:IsInRange(30)) or (3020 <= 2751)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\139\245\184\132\212\181\188\228\162\153\210\161\195\253\171\130\211", "\214\227\144\202\235\189");
								end
							end
							v198 = 2;
						end
						if ((3824 > 3667) and (v198 == 2)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\218\183\130\120\27\186\93\59\217\173\149\116\7", "\92\141\197\231\27\112\211\51")]:IsCastable() and v52 and v15:AffectingCombat() and v107()) or (3048 > 3830)) then
								if (v24(v98.WreckingThrow, not v15:IsInRange(30)) or (2117 < 1050)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\241\237\143\160\218\239\241\141\156\197\238\237\133\180\145\235\254\131\173", "\177\134\159\234\195");
								end
							end
							if ((v30 and (v106 > 2)) or (1099 == 1810)) then
								local v206 = 0;
								while true do
									if ((v206 == 0) or (4892 == 3708)) then
										v28 = v114();
										if ((2393 > 617) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\144\234\44\179\200\190\249\58", "\169\221\139\95\192")]:IsAvailable() and (v15:HealthPercentage() < 35)) or (v15:HealthPercentage() < 20) or (1352 > 2414)) then
								local v207 = 0;
								while true do
									if ((v207 == 0) or (1584 == 2283)) then
										v28 = v115();
										if ((2073 < 2845) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							v198 = 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v139 = 0;
		while true do
			if ((2894 <= 3293) and (5 == v139)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\160\105\141\187\41\167", "\228\213\78\212\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\95\179\50\234\149\78\164\0\234\140\73\164", "\139\231\44\214\101")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\234\234\18\74\25\191\54\5", "\118\185\143\102\62\112\209\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\93\102\40\242\164\7\43\49\72\120\10\194", "\88\60\16\73\134\197\117\124")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\239\236\220\72\94\237\235", "\33\48\138\152\168")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\49\85\196\36\102\25\34\92\246\62\102\30\19\117", "\87\18\118\80\49\161")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\27\206\180\185\66\25\201", "\208\44\126\186\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\21\168\201\7\239\220\93\196\23\165\213\28\203\192\90\255\57\128", "\46\151\122\196\166\116\156\169")];
				v139 = 6;
			end
			if ((1275 > 942) and (v139 == 6)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\232\82\14\242\235\234\85", "\155\133\141\38\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\54\58\169\64\93\80\163\7\43\191\85\70\112\171\18\35\184\73\108\91", "\197\69\74\204\33\47\31")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\74\78\147\249\65\93\148", "\231\144\47\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\208\207\123\28\56\221\54\167\203\232\122\25\47\248\48\166\208\249\81", "\89\210\184\186\21\120\93\175")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\86\104\193\112\52\182\64", "\90\209\51\28\181\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\122\69\236\173\213\122\92\235\173\231\114\67\230\156\244", "\223\176\27\55\142")];
				break;
			end
			if ((1190 < 4108) and (v139 == 0)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\236\230\230\221\183\44\48\250\208\204\211\182\44", "\88\92\159\131\164\188\195")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\239\143\53\201\47\238\141\19", "\161\78\156\234\118")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\26\90\88\228\249\8\73\126", "\136\156\105\63\27")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\137\109\32\18\130\126\39", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\152\175\50\180\176\243\158\190\18", "\213\144\235\202\119\204")];
				v139 = 1;
			end
			if ((2404 <= 2475) and (v139 == 1)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\49\232\141\252\154\225\224\35\22\229\183\246\159", "\137\64\66\141\197\153\232\142")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\213\54\178\129\13\215\49", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\249\50\45\43\116\159\237\45\224\18\60\20\114\134\252", "\76\140\65\72\102\27\237\153")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\223\2\198\222\15\185\89", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\255\65\165\75\233\86\154\82\251\65\152", "\234\61\140\36")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\88\30\7\14\82\171", "\207\35\43\123\85\107\60")];
				v139 = 2;
			end
			if ((v139 == 2) or (2100 <= 635)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\216\168\209\161\251\254\192\186\227\191\241", "\148\157\171\205\130\201")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\11\31\126\134\13\22\65\158\8\22\68\153\12\31\95", "\45\237\120\122")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\245\224\11\92\78\25", "\116\26\134\133\88\48\47")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\74\59\171\55\65\90\45\190\13\88\88\27\186\22\95\84\45\189", "\54\63\72\206\100")];
				v139 = 3;
			end
			if ((2967 > 196) and (3 == v139)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\92\81\110\236\117\207\74", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\185\121\156\223\56\164\120\173\197\14\166\125\184", "\183\77\202\28\200")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\54\157\28\30\61\142\27", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\235\34\21\75\252\234\43\53\74\251\252", "\35\149\152\71\66")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\237\86\164\51\23\239\81", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\29\80\41\213\11\86\21\206\0\82\42\207\28\90\9", "\126\167\110\53")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\58\236\213\49\58\3", "\95\93\112\78\152\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\230\128\52\242\191\198\192\231", "\178\161\149\229\117\132\222")];
				v139 = 4;
			end
			if ((v139 == 4) or (4689 < 3047)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\222\201\184\168\24\161\48", "\67\232\187\189\204\193\118\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\61\176\2\55\3\235\142\61\161\47\41\15", "\143\235\78\213\64\91\98")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\77\144\253\121\184\138\91", "\214\237\40\228\137\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\240\234\250\12\170\138\240\252\204\16\149\136\226\252\209", "\198\229\131\143\185\99")];
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\137\188\103\88\130\175\96", "\19\49\236\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\36\243\132\244\191\255\37\217\177\198\187\237\35\255\184\234", "\218\158\87\150\215\132")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\205\246\63\44\202\232", "\173\155\126\185\130\86\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\181\191\243\128\249\235\162\191\213\135\249\246\148\181\198\154", "\140\133\198\218\167\232")];
				v139 = 5;
			end
		end
	end
	local function v120()
		local v140 = 0;
		while true do
			if ((v140 == 4) or (422 <= 411)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\121\249\63\132\114\234\56", "\75\237\28\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\94\192\189\54\18\233\230\255\77\213\150\61\20\242\241", "\129\188\63\172\209\79\123\135")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\225\242\217\73\234\225\222", "\173\32\132\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\92\26\4\227\183\56\195\73\56\26\246\134\1", "\173\46\123\104\143\206\81")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\24\54\158\76\141\6\167", "\97\212\125\66\234\37\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\234\181\33\17\152\250\132\32\13\130\203\134", "\126\234\131\214\85")] or 0;
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\208\93\78\70\138\210\90", "\47\228\181\41\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\181\236\220\58\17\3\26\178\232\208\53\4", "\127\198\156\185\91\99\80")] or LUAOBFUSACTOR_DECRYPT_STR_0("\229\22\205\233\162\25", "\190\149\122\172\144\199\107\89");
				break;
			end
			if ((v140 == 1) or (2476 > 2899)) then
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\46\172\158\191\42\119\26\186", "\25\125\201\234\203\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\231\29\39\17\33\22\119\231\17\21\17\20\7\120\250\27\6", "\115\25\148\120\99\116\71")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\56\173\48\72\2\58\170", "\33\108\93\217\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\88\164\137\210\78\131\180\239\67\164\158\204\68\179\169", "\205\187\43\193")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\119\17\203\247\124\2\204", "\191\158\18\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\208\130\158\168\203\204\149\178\159\196\202\137", "\207\165\163\231\215")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\252\237\66\45\126\193\234", "\16\166\153\153\54\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\160\197\111\58\53\252\192\165\197\72\49", "\153\178\211\160\38\84\65")];
				v140 = 2;
			end
			if ((1312 == 1312) and (3 == v140)) then
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\166\15\157\198\200\164\8", "\175\166\195\123\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\204\78\93\241\225\193\88\97\192", "\144\143\162\61\41")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\214\9\68\123\137\52\243", "\83\128\179\125\48\18\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\190\246\255\94\42\85\178\192\202\72\12\89\159\195", "\126\61\215\147\189\39")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\250\9\81\113\241\26\86", "\37\24\159\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\161\123\77\200\163\69\67\211\168\93\114", "\34\186\198\21")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\13\209\73\203\246\15\214", "\162\152\104\165\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\33\166\120\98\243\200\33\183\85\64", "\133\173\79\210\29\16")] or 0;
				v140 = 4;
			end
			if ((v140 == 0) or (3503 == 3404)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\190\218\161\45\181\201\166", "\213\68\219\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\243\38\215\63\200\50\122\7", "\31\107\128\67\135\74\165\95")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\237\232\89\72\191\223\251", "\209\184\136\156\45\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\219\112\59\172\8\218\120\42\183\11\220", "\216\103\168\21\104")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\168\87\176\113\163\68\183", "\196\24\205\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\152\230\47\32\159\234\11\39\143\226\18\39\133\228\53\38\132\246\18", "\102\78\235\131")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\43\32\80\78\55\176\39", "\84\154\78\84\36\39\89\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\242\83\122\12\233\245\83\74\44\240\236\67\86\12\233\248", "\101\157\129\54\56")];
				v140 = 1;
			end
			if ((2284 < 4260) and (v140 == 2)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\14\78\63\139\5\93\56", "\75\226\107\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\205\20\72\16\206\193\65\215\31\125\50\208\212", "\173\56\190\113\26\113\162")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\219\57\17\254\197\217\62", "\151\171\190\77\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\60\253\159\241\126\31\202\61\225\155\237\110\3", "\107\165\79\152\201\152\29")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\75\252\223\93\113\80\93", "\31\55\46\136\171\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\33\200\224\212\58\245\249\220\61\210\253\197\49\244\196", "\148\177\72\188")] or 0;
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\149\179\67\199\175\184\80\192", "\179\198\214\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\9\116\115\75\192\249\26\119\69\81\210\254\15\119\94\117", "\179\144\108\18\22\37")] or 0;
				v140 = 3;
			end
		end
	end
	local function v121()
		local v141 = 0;
		while true do
			if ((638 <= 1080) and (v141 == 0)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\0\229\234\247\60\2\226", "\158\82\101\145\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\247\5\30\80\66\251\15\23\77\126\237\33\30\65\115\245", "\36\16\158\98\118")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\243\19\215\239\81\230\32\246", "\133\160\118\163\155\56\136\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\172\101\247\164\13\160\230\182\70\251\162\23\134\226\183\127", "\213\150\194\17\146\214\127")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\172\176\192\79\170\165\37", "\86\123\201\196\180\38\196\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\230\205\170\229\250\204\191\227\199\215\163\238\223\209\166\227\237\213\166\228\252", "\207\151\136\185")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\155\134\60\150\125\118\118\187", "\17\200\227\72\226\20\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\79\15\210\219\227\250\239\164\117\19\197\204\226\231\240\188\69", "\159\208\33\123\183\169\145\143")];
				v141 = 1;
			end
			if ((v141 == 3) or (2440 == 4141)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\70\180\27\22\123\126\245", "\134\154\35\192\111\127\21\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\35\8\6\41\220\191\22\6\30\41\221\182\8\8\7\37", "\178\216\70\105\106\64")] or "";
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\12\46\110\226\192\219\211\147", "\224\95\75\26\150\169\181\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\219\214\44\72\169\95\5\217\215\58\84\163\100\14\219\212", "\22\107\186\184\72\36\204")];
				break;
			end
			if ((4376 > 2959) and (v141 == 2)) then
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\127\214\25\141\116\197\30", "\109\228\26\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\75\246\248\80\229\231\82\241\245\107\244\233\80\224", "\134\62\133\157\24\128")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\160\14\205\38\191\209\20", "\182\103\197\122\185\79\209")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\148\228\95\5\73\255\142\239\112\48\71\231\142\238\121", "\40\147\231\129\23\96")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\253\152\81\178\162\219\102", "\188\21\152\236\37\219\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\236\54\0\84\225\36\24\79\231\50\36\112", "\108\32\137\87")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\237\20\178\38\247\76\74", "\57\202\136\96\198\79\153\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\163\38\171\171\132\169\255\155\44\190\174\130\169\208\155", "\152\203\67\202\199\237\199")] or 0;
				v141 = 3;
			end
			if ((1668 == 1668) and (v141 == 1)) then
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\193\95\44\34\251\84\63\37", "\86\146\58\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\204\239\244\188\224\56\241\93\203\249", "\154\56\191\138\160\206\137\86")];
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\181\92\225\147\117\52\134\223", "\172\230\57\149\231\28\90\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\185\131\224\41\216\11\171\138\193", "\187\98\202\230\178\72")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\228\176\36\67\47\230\183", "\42\65\129\196\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\88\84\212\28\2\22\253\53\67\73\210\52\35", "\142\98\42\61\186\119\103\98")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\186\22\28\49\177\5\27", "\104\88\223\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\246\225\199\3\225\87\192\235\218\10\206\96", "\141\36\151\130\174\98")];
				v141 = 2;
			end
		end
	end
	local function v122()
		local v142 = 0;
		while true do
			if ((1 == v142) or (3358 >= 4904)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\36\191\16\81\254\56", "\61\155\75\216\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\164\183", "\189\100\203\210\92\56\105")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\94\250\47\35\84\238", "\72\79\49\157")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\180\34", "\220\232\208\81")];
				if ((2885 > 2876) and v14:IsDeadOrGhost()) then
					return;
				end
				if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\176\241\57\33\83\165\244\170\236\62\43\105\169\250\171\241", "\193\149\222\133\80\76\58")]:IsAvailable() or (2525 == 2957)) then
					v27 = 8;
				end
				v142 = 2;
			end
			if ((3983 > 649) and (v142 == 2)) then
				if ((1916 == 1916) and v30) then
					local v200 = 0;
					while true do
						if ((4247 >= 3723) and (v200 == 0)) then
							v105 = v14:GetEnemiesInMeleeRange(v27);
							v106 = #v105;
							break;
						end
					end
				else
					v106 = 1;
				end
				v102 = v15:IsInMeleeRange(v27);
				if ((1446 < 3001) and (v94.TargetIsValid() or v14:AffectingCombat())) then
					local v201 = 0;
					while true do
						if ((v201 == 1) or (3380 < 199)) then
							if ((1494 <= 4564) and (v104 == 11111)) then
								v104 = v10.FightRemains(v105, false);
							end
							break;
						end
						if ((4256 > 469) and (v201 == 0)) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v201 = 1;
						end
					end
				end
				if (not v14:IsChanneling() or (3727 < 87)) then
					if ((609 <= 3889) and v14:AffectingCombat()) then
						local v203 = 0;
						while true do
							if ((0 == v203) or (2628 < 2175)) then
								v28 = v118();
								if ((2999 == 2999) and v28) then
									return v28;
								end
								break;
							end
						end
					else
						local v204 = 0;
						while true do
							if ((v204 == 0) or (2968 == 71)) then
								v28 = v117();
								if ((3429 < 3464) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v142 == 0) or (2337 <= 423)) then
				v120();
				v119();
				v121();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\178\35\73\2\226\174", "\110\135\221\68\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\57\15", "\91\131\86\108\139\174\211")];
				v142 = 1;
			end
		end
	end
	local function v123()
		v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\231\79\66\193\134\106\78\192\212\84\64\192\134\95\86\146\227\77\70\209\136\29\124\199\214\77\64\192\210\88\75\146\196\68\15\202\237\92\65\215\210\82\1", "\178\166\61\47"));
	end
	v20.SetAPL(71, v122, v123);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\222\90\225\98\245\9\250\88\250\115\197\44\196\107\250\119\217\112\247\95\233", "\94\155\42\136\26\170")]();

