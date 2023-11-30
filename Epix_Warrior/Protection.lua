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
		if ((v5 == 1) or (3780 <= 1368)) then
			return v6(...);
		end
		if ((v5 == 0) or (3169 == 2273)) then
			v6 = v0[v4];
			if ((2481 <= 3279) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\195\202\212\55\217\139\213\17\197\198\216\49\239\180\201\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v13 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v14 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v15 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67\147\71\238\80\162\82", "\38\156\55\199")];
	local v16 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\142\114\127\61\0", "\35\200\29\28\72\115\20\154")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v19 = EpicLib;
	local v20 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v21 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v22 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v23 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v24 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v25 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v26 = UnitIsUnit;
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\193\88\127\27\171", "\126\167\52\16\116\217")];
	local v28 = 5;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
	local v94 = 11111;
	local v95 = 11111;
	local v96;
	local v97 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\45\141\187\23\239", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\160\220\30\225\171\203", "\174\103\142\197")];
	local v98 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\97\41\77\42\44\81\234", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\214\225\72\209\199\250\85\219\202", "\60\180\164\142")];
	local v99 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\111\95\23\59\46\226\0", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\251\212\208\189\234\207\205\183\231", "\164\216\137\187")];
	local v100 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\229\231\35\160\175\241\25", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\28\141\210\175\59\26\139\201\164", "\202\88\110\226\166")];
	local v101 = {};
	local v102;
	local v103;
	local v104;
	local function v105()
		local v123 = 0;
		local v124;
		while true do
			if ((v123 == 0) or (1063 <= 877)) then
				v124 = UnitGetTotalAbsorbs(v14);
				if ((2314 == 2314) and (v124 > 0)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v106()
		return v13:IsTankingAoE(16) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v107()
		if ((924 >= 477) and v13:BuffUp(v98.IgnorePain)) then
			local v141 = 0;
			local v142;
			local v143;
			local v144;
			while true do
				if ((1813 <= 3778) and (v141 == 1)) then
					v144 = v143[LUAOBFUSACTOR_DECRYPT_STR_0("\211\0\139\249\222\208", "\170\163\111\226\151")][1];
					return v144 < v142;
				end
				if ((4150 == 4150) and (0 == v141)) then
					v142 = v13:AttackPowerDamageMod() * 3.5 * (1 + (v13:VersatilityDmgPct() / 100));
					v143 = v13:AuraInfo(v98.IgnorePain, nil, true);
					v141 = 1;
				end
			end
		else
			return true;
		end
	end
	local function v108()
		if ((432 <= 3007) and v13:BuffUp(v98.IgnorePain)) then
			local v145 = 0;
			local v146;
			while true do
				if ((v145 == 0) or (408 > 2721)) then
					v146 = v13:BuffInfo(v98.IgnorePain, nil, true);
					return v146[LUAOBFUSACTOR_DECRYPT_STR_0("\1\63\187\54\90\36", "\73\113\80\210\88\46\87")][1];
				end
			end
		else
			return 0;
		end
	end
	local function v109()
		return v106() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\178\36\196\23\235\133\14\193\29\228\138", "\135\225\76\173\114")]:IsReady() and (((v13:BuffRemains(v98.ShieldBlockBuff) <= 18) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\227\188\165\190\180\169\29\201\189\182\169\179\180\31\254", "\199\122\141\216\208\204\221")]:IsAvailable()) or (v13:BuffRemains(v98.ShieldBlockBuff) <= 12));
	end
	local function v110(v125)
		local v126 = 0;
		local v127;
		local v128;
		local v129;
		while true do
			if ((2 == v126) or (3418 < 2497)) then
				if ((1735 < 2169) and v129 and (((v13:Rage() + v125) >= v127) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\137\216\29\255\106\247\161\212\10\249\118\241\158\213\31\229\108", "\150\205\189\112\144\24")]:IsReady())) then
					v128 = true;
				end
				if ((3890 >= 3262) and v128) then
					if ((v106() and v107()) or (4356 >= 4649)) then
						if ((3904 == 3904) and v23(v98.IgnorePain, nil, nil, true)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\44\131\177\67\22\141\46\0\36\141\177\12\22\137\22\21\101\135\190\92\20\141\21", "\112\69\228\223\44\100\232\113");
						end
					elseif (v23(v98.Revenge, not v102) or (2860 >= 3789)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\26\17\214\184\123\131\148\13\6\212\179\60\133\213\15\23\214\178", "\230\180\127\103\179\214\28");
					end
				end
				break;
			end
			if ((v126 == 1) or (1086 > 4449)) then
				v128 = false;
				v129 = (v13:Rage() >= 35) and not v109();
				v126 = 2;
			end
			if ((4981 > 546) and (v126 == 0)) then
				v127 = 80;
				if ((v127 < 35) or (v13:Rage() < 35) or (2366 <= 8)) then
					return false;
				end
				v126 = 1;
			end
		end
	end
	local function v111()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (2590 == 2864)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\12\75\82\225\83\201\129\8\74\72\237\85\249", "\128\236\101\63\38\132\33")]:IsReady() and v62 and (v13:HealthPercentage() <= v73)) or (2624 > 4149)) then
					if (v23(v98.BitterImmunity) or (2618 >= 4495)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\160\5\80\179\249\240\165\164\28\81\184\226\219\181\233\21\65\176\238\193\191\160\7\65", "\175\204\201\113\36\214\139");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\205\38\200\55\83\205\59\216", "\100\39\172\85\188")]:IsCastable() and v65 and ((v13:HealthPercentage() <= v76) or v13:ActiveMitigationNeeded())) or (2485 >= 3131)) then
					if (v23(v98.LastStand) or (2804 <= 2785)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\121\170\148\12\190\108\184\142\55\237\124\188\134\54\163\107\176\150\54", "\83\205\24\217\224");
					end
				end
				v130 = 1;
			end
			if ((v130 == 3) or (4571 == 3415)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\99\214\185\64\15\117\88\199\183\66\30", "\29\43\179\216\44\123")]:IsReady() and v70 and (v13:HealthPercentage() <= v82)) or (4441 > 4787)) then
					if ((1920 == 1920) and v23(v100.Healthstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\220\33\64\169\209\51\88\178\215\37\12\185\220\38\73\179\202\41\90\184\153\115", "\44\221\185\64");
					end
				end
				if ((v71 and (v13:HealthPercentage() <= v83)) or (647 == 4477)) then
					local v195 = 0;
					while true do
						if ((3819 == 3819) and (v195 == 0)) then
							if ((v89 == LUAOBFUSACTOR_DECRYPT_STR_0("\51\226\78\77\118\18\239\65\81\116\65\207\77\94\127\8\233\79\31\67\14\243\65\80\125", "\19\97\135\40\63")) or (1466 > 4360)) then
								if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\156\89\53\41\42\34\166\85\61\60\7\52\175\80\58\53\40\1\161\72\58\52\33", "\81\206\60\83\91\79")]:IsReady() or (14 > 994)) then
									if ((401 <= 734) and v23(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\92\174\214\96\42\208\69\173\64\172\144\122\42\194\65\173\64\172\144\98\32\215\68\171\64\235\212\119\41\198\67\183\71\189\213\50\123", "\196\46\203\176\18\79\163\45");
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or (2167 >= 3426)) then
								if ((764 < 3285) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\156\48\123\31\41\236\238\180\41\123\12\55\211\234\185\46\119\16\35\203\224\172\43\113\16", "\143\216\66\30\126\68\155")]:IsReady()) then
									if ((2499 == 2499) and v23(v100.RefreshingHealingPotion)) then
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
			if ((v130 == 2) or (692 >= 4933)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\115\198\241\83\72\228\133\84\205", "\224\58\168\133\54\58\146")]:IsReady() and v68 and (v16:HealthPercentage() <= v80) and (v16:UnitName() ~= v13:UnitName())) or (3154 <= 2260)) then
					if (v23(v100.InterveneFocus) or (2637 > 3149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\88\95\248\103\144\130\5\92\22\79\248\115\131\137\24\80\64\78", "\107\57\54\43\157\21\230\231");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\232\131\24\240\181\216\248\218\135\29", "\175\187\235\113\149\217\188")]:IsCastable() and v63 and v13:BuffDown(v98.ShieldWallBuff) and ((v13:HealthPercentage() <= v74) or v13:ActiveMitigationNeeded())) or (3992 < 2407)) then
					if (v23(v98.ShieldWall) or (2902 > 4859)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\167\136\73\239\125\71\43\174\141\64\163\125\125\58\170\143\95\234\111\125", "\24\92\207\225\44\131\25");
					end
				end
				v130 = 3;
			end
			if ((1679 < 4359) and (v130 == 1)) then
				if ((1913 < 4670) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\207\194\195\50\244\192\253\60\239\203", "\93\134\165\173")]:IsReady() and v66 and (v13:HealthPercentage() <= v77) and v107()) then
					if (v23(v98.IgnorePain, nil, nil, true) or (2846 < 879)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\245\207\205\40\203\141\110\191\251\207\130\62\203\180\123\176\225\200\212\63", "\30\222\146\161\162\90\174\210");
					end
				end
				if ((4588 == 4588) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\215\79\124\6\252\71\126\13\198\92\105", "\106\133\46\16")]:IsReady() and v67 and v13:BuffDown(v98.AspectsFavorBuff) and v13:BuffDown(v98.RallyingCry) and (((v13:HealthPercentage() <= v78) and v97.IsSoloMode()) or v97.AreUnitsBelowHealthPercentage(v78, v79))) then
					if (v23(v98.RallyingCry) or (347 == 2065)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\33\127\240\67\73\86\39\76\255\72\89\24\36\118\250\95\78\75\41\101\249", "\32\56\64\19\156\58");
					end
				end
				v130 = 2;
			end
		end
	end
	local function v112()
		local v131 = 0;
		while true do
			if ((v131 == 1) or (1311 > 2697)) then
				v29 = v97.HandleBottomTrinket(v101, v32, 40, nil);
				if (v29 or (2717 > 3795)) then
					return v29;
				end
				break;
			end
			if ((v131 == 0) or (1081 < 391)) then
				v29 = v97.HandleTopTrinket(v101, v32, 40, nil);
				if (v29 or (121 > 3438)) then
					return v29;
				end
				v131 = 1;
			end
		end
	end
	local function v113()
		if ((71 < 1949) and v14:IsInMeleeRange(v28)) then
			if ((4254 == 4254) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\22\80\34\214\218\17\244\1\84\54\200", "\134\66\56\87\184\190\116")]:IsCastable() and v47) then
				if ((3196 >= 2550) and v23(v98.ThunderClap)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\40\57\28\181\29\238\51\10\63\61\8\171\89\251\51\48\63\62\4\185\24\255", "\85\92\81\105\219\121\139\65");
				end
			end
		elseif ((2456 < 4176) and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\187\81\87\123\218", "\191\157\211\48\37\28")]:IsCastable() and not v14:IsInRange(8)) then
			if (v23(v98.Charge, not v14:IsSpellInRange(v98.Charge)) or (1150 == 3452)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\220\23\245\14\61\218\95\228\14\63\220\16\249\30\59\203", "\90\191\127\148\124");
			end
		end
	end
	local function v114()
		local v132 = 0;
		while true do
			if ((1875 < 2258) and (v132 == 0)) then
				if ((1173 > 41) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\76\143\59\25\124\130\60\52\116\134\62", "\119\24\231\78")]:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= 1)) then
					local v196 = 0;
					while true do
						if ((v196 == 0) or (56 >= 3208)) then
							v110(5);
							if ((4313 > 3373) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\150\37\176\68\216\69\3\189\46\169\75\204\0\16\141\40\229\24", "\113\226\77\197\42\188\32");
							end
							break;
						end
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\30\253\176\54\18\199\185\59\27", "\213\90\118\148")]:IsCastable() and v44 and ((v13:HasTier(30, 2) and (v104 <= 7)) or v13:BuffUp(v98.EarthenTenacityBuff))) or (4493 == 2225)) then
					if ((3104 >= 3092) and v23(v98.ShieldSlam, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\38\189\83\65\95\17\167\90\76\86\110\181\89\72\27\125", "\45\59\78\212\54");
					end
				end
				v132 = 1;
			end
			if ((3548 > 3098) and (v132 == 2)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\65\73\126\128\242\143\65\77\118\136", "\235\18\33\23\229\158")]:IsCastable() and v44 and ((v13:Rage() <= 60) or (v13:BuffUp(v98.ViolentOutburstBuff) and (v104 <= 7)))) or (3252 == 503)) then
					local v197 = 0;
					while true do
						if ((4733 > 2066) and (v197 == 0)) then
							v110(20);
							if ((3549 >= 916) and v23(v98.ShieldSlam, not v102)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\67\178\200\190\92\190\254\168\92\187\204\251\81\181\196\251\8", "\219\48\218\161");
							end
							break;
						end
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\208\121\105\71\223\74\242\199\125\125\89", "\128\132\17\28\41\187\47")]:IsCastable() and v47) or (2189 <= 245)) then
					local v198 = 0;
					while true do
						if ((v198 == 0) or (1389 > 3925)) then
							v110(5);
							if ((4169 >= 3081) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\21\58\19\52\89\4\32\57\57\81\0\34\70\59\82\4\114\87\106", "\61\97\82\102\90");
							end
							break;
						end
					end
				end
				v132 = 3;
			end
			if ((349 <= 894) and (v132 == 1)) then
				if ((731 <= 2978) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\36\94\150\133\130\43\191\211\28\87\147", "\144\112\54\227\235\230\78\205")]:IsCastable() and v47 and v13:BuffUp(v98.ViolentOutburstBuff) and (v104 > 5) and v13:BuffUp(v98.AvatarBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\38\28\232\223\75\163\41\13\240\213\125\188\58\12\249", "\59\211\72\111\156\176")]:IsAvailable()) then
					local v199 = 0;
					while true do
						if ((v199 == 0) or (892 > 3892)) then
							v110(5);
							if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or (4466 == 900)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\90\143\246\35\74\130\241\18\77\139\226\61\14\134\236\40\14\211", "\77\46\231\131");
							end
							break;
						end
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\81\160\69\180\83\179", "\32\218\52\214")]:IsReady() and v42 and (v13:Rage() >= 70) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\18\56\187\252\185\70\104\75\1\52\186\243\181\87\91\90\30\62\166", "\58\46\119\81\200\145\208\37")]:IsAvailable() and (v104 >= 3)) or (2084 >= 2888)) then
					if ((479 < 1863) and v23(v98.Revenge, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\137\38\169\167\186\51\107\141\63\169\233\235", "\86\75\236\80\204\201\221");
					end
				end
				v132 = 2;
			end
			if ((v132 == 3) or (2428 >= 4038)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\158\43\189\78\201\80\27", "\105\204\78\203\43\167\55\126")]:IsReady() and v42 and ((v13:Rage() >= 30) or ((v13:Rage() >= 40) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\135\171\49\28\18\22\206\82\145\184\34\23\29\13\201\86", "\49\197\202\67\126\115\100\167")]:IsAvailable()))) or (2878 > 2897)) then
					if (v23(v98.Revenge, not v102) or (2469 > 3676)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\94\201\44\142\81\91\119\90\208\44\192\7\12", "\62\87\59\191\73\224\54");
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v133 = 0;
		while true do
			if ((233 < 487) and (v133 == 3)) then
				if ((2473 >= 201) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\189\243\222\178\176\244\243\186\180\246", "\176\214\213\134")]:IsCastable() and v47 and ((v104 >= 1) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\165\191\209\164\82\106\248\172\187", "\57\148\205\214\180\200\54")]:CooldownDown() and v13:BuffUp(v98.ViolentOutburstBuff)))) then
					local v200 = 0;
					while true do
						if ((4120 >= 133) and (v200 == 0)) then
							v110(5);
							if ((3080 >= 1986) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\6\245\32\58\114\23\239\10\55\122\19\237\117\51\115\28\248\39\61\117\82\175\101", "\22\114\157\85\84");
							end
							break;
						end
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\206\5\197\78\226\169\208\206", "\200\164\171\115\164\61\150")]:IsCastable() and v38) or (1439 > 3538)) then
					if (v23(v98.Devastate, not v102) or (419 < 7)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\241\21\68\144\170\245\23\64\195\185\241\13\64\145\183\247\67\23\209", "\227\222\148\99\37");
					end
				end
				break;
			end
			if ((2820 == 2820) and (v133 == 2)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\132\0\251\55\233\93", "\56\162\225\118\158\89\142")]:IsReady() and v42 and (((v13:Rage() >= 60) and (v14:HealthPercentage() > 20)) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= 20) and (v13:Rage() <= 18) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\13\201\170\46\220\111\9\193\162", "\184\60\101\160\207\66")]:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > 20)) or ((((v13:Rage() >= 60) and (v14:HealthPercentage() > 35)) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= 35) and (v13:Rage() <= 18) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\2\138\117\185\61\134\79\176\48\143", "\220\81\226\28")]:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > 35))) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\62\212\145\232\235\196\1\208", "\167\115\181\226\155\138")]:IsAvailable()))) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v23(v98.Revenge, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\39\241\89\117\118\195\162\37\226\82\126\99\207\225\98\182\8", "\166\130\66\135\60\27\17");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\82\203\118\37\80\79", "\80\36\42\174\21")]:IsReady() and v39 and (v104 == 1)) or (1482 >= 4288)) then
					if (v23(v98.Execute, not v102) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\8\50\121\91\4\50\58\73\21\57\127\92\25\52\58\31\70", "\26\46\112\87");
					end
				end
				if ((4774 == 4774) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\38\189\113\177\184\64", "\212\217\67\203\20\223\223\37")]:IsReady() and v42 and (v14:HealthPercentage() > 20)) then
					if ((566 <= 960) and v23(v98.Revenge, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\136\190\215\180\138\173\146\189\136\166\215\168\132\171\146\235\213", "\178\218\237\200");
					end
				end
				v133 = 3;
			end
			if ((v133 == 1) or (2910 <= 1930)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\0\201\95\89\166\49\212", "\211\69\177\58\58")]:IsReady() and v39 and (v104 == 1) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\154\228\106\230\232\200\165\224", "\171\215\133\25\149\137")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\221\53\253\234\34\242\67\244\220", "\34\129\168\82\154\143\80\156")]:IsAvailable()) and (v13:Rage() >= 50)) or (19 > 452)) then
					if (v23(v98.Execute, not v102) or (907 > 3152)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\170\54\8\93\90\140\197\181\54\5\77\92\128\134\242\101", "\233\229\210\83\107\40\46");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\228\90\55\213\16\213\71", "\101\161\34\82\182")]:IsReady() and v39 and (v104 == 1) and (v13:Rage() >= 50)) or (2505 > 4470)) then
					if (v23(v98.Execute, not v102) or (3711 > 4062)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\21\92\253\206\246\135\110\239\8\87\251\201\235\129\110\185\93", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((420 == 420) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\55\236\255\58\58\235\210\50\62\233", "\145\94\95\153")]:IsCastable() and v47 and ((v104 > 1) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\206\197\29\208\66\179\206\193\21\216", "\215\157\173\116\181\46")]:CooldownDown() and not v13:BuffUp(v98.ViolentOutburstBuff)))) then
					local v201 = 0;
					while true do
						if ((v201 == 0) or (33 >= 3494)) then
							v110(5);
							if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or (1267 == 4744)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\33\188\158\252\222\48\166\180\241\214\52\164\203\245\223\59\177\153\251\217\117\229\217", "\186\85\212\235\146");
							end
							break;
						end
					end
				end
				v133 = 2;
			end
			if ((2428 < 3778) and (v133 == 0)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\10\243\204\235\6\201\197\230\15", "\169\135\98\154")]:IsCastable() and v44) or (2946 <= 1596)) then
					local v202 = 0;
					while true do
						if ((4433 > 3127) and (v202 == 0)) then
							v110(20);
							if ((4300 >= 2733) and v23(v98.ShieldSlam, not v102)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\216\127\45\81\241\55\247\216\123\37\89\189\52\205\197\114\54\93\254\115\154", "\168\171\23\68\52\157\83");
							end
							break;
						end
					end
				end
				if ((4829 == 4829) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\121\224\163\33\40\149\215\125\244\189", "\231\148\17\149\205\69\77")]:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= 1) and v13:BuffDown(v98.ViolentOutburstBuff)) then
					local v203 = 0;
					while true do
						if ((1683 <= 4726) and (v203 == 0)) then
							v110(5);
							if ((4835 >= 3669) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\148\175\210\245\83\250\146\152\196\247\86\239\192\160\194\245\82\237\137\164\135\175", "\159\224\199\167\155\55");
							end
							break;
						end
					end
				end
				if ((2851 > 1859) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\210\235\57\209\226\231\57", "\178\151\147\92")]:IsReady() and v39 and v13:BuffUp(v98.SuddenDeathBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\191\232\72\54\23\66\94\137\252\88\58", "\26\236\157\44\82\114\44")]:IsAvailable()) then
					if ((3848 > 2323) and v23(v98.Execute, not v102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\54\208\88\63\58\208\27\45\43\219\94\56\39\214\27\124", "\59\74\78\181");
					end
				end
				v133 = 1;
			end
		end
	end
	local function v116()
		local v134 = 0;
		while true do
			if ((2836 > 469) and (v134 == 0)) then
				if (not v13:AffectingCombat() or (2096 <= 540)) then
					local v204 = 0;
					while true do
						if ((v204 == 0) or (3183 < 2645)) then
							if ((3230 <= 3760) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\83\70\226\245\54\97\90\249\236\39", "\153\83\50\50\150")]:IsCastable() and v35 and (v13:BuffDown(v98.BattleShoutBuff, true) or v97.GroupBuffMissing(v98.BattleShoutBuff))) then
								if ((3828 == 3828) and v23(v98.BattleShout)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\95\119\103\8\127\174\114\78\126\124\9\103\235\93\79\115\112\19\126\169\76\73", "\45\61\22\19\124\19\203");
								end
							end
							if ((554 == 554) and v96 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\19\25\225\14\117\138\213\19\3\246\7", "\217\161\114\109\149\98\16")]:IsCastable() and not v13:BuffUp(v98.BattleStance)) then
								if (v23(v98.BattleStance) or (2563 == 172)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\16\33\44\104\176\113\45\51\44\125\178\119\23\96\40\110\185\119\29\45\58\125\168", "\20\114\64\88\28\220");
								end
							end
							break;
						end
					end
				end
				if ((3889 >= 131) and v97.TargetIsValid() and v30) then
					if (not v13:AffectingCombat() or (492 == 4578)) then
						local v210 = 0;
						while true do
							if ((v210 == 0) or (4112 < 1816)) then
								v29 = v113();
								if ((4525 >= 1223) and v29) then
									return v29;
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
	local function v117()
		local v135 = 0;
		while true do
			if ((1090 <= 4827) and (0 == v135)) then
				v29 = v111();
				if (v29 or (239 > 1345)) then
					return v29;
				end
				v135 = 1;
			end
			if ((v135 == 1) or (3710 >= 3738)) then
				if (v88 or (3838 < 2061)) then
					local v205 = 0;
					while true do
						if ((v205 == 0) or (690 > 1172)) then
							v29 = v97.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 20, true);
							if (v29 or (1592 > 2599)) then
								return v29;
							end
							v205 = 1;
						end
						if ((3574 <= 4397) and (v205 == 1)) then
							v29 = v97.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 8, true);
							if ((3135 > 1330) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v97.TargetIsValid() or (3900 <= 3641)) then
					local v206 = 0;
					local v207;
					while true do
						if ((1724 == 1724) and (v206 == 0)) then
							if ((455 <= 1282) and v96 and (v13:HealthPercentage() <= v81)) then
								if ((4606 < 4876) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\4\212\177\246\195\180\39\4\225\160\249\222\190\52", "\221\81\97\178\212\152\176")]:IsCastable() and not v13:BuffUp(v98.DefensiveStance)) then
									if (v23(v98.DefensiveStance) or (1442 > 2640)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\201\226\27\254\20\222\238\11\254\37\222\243\28\245\25\200\167\10\243\19\193\226\93\239\27\195\236\20\245\29", "\122\173\135\125\155");
									end
								end
							end
							if ((136 < 3668) and v96 and (v13:HealthPercentage() > v81)) then
								if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\166\192\20\173\51\52\251\144\192\14\186\58", "\168\228\161\96\217\95\81")]:IsCastable() and not v13:BuffUp(v98.BattleStance)) or (1784 > 4781)) then
									if ((4585 > 3298) and v23(v98.BattleStance)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\217\208\58\72\35\82\228\194\58\93\33\84\222\145\57\84\38\91\222\145\32\83\59\23\207\208\32\87\38\89\220", "\55\187\177\78\60\79");
									end
								end
							end
							if ((v43 and ((v54 and v32) or not v54) and (v93 < v95) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\198\86\238\74\203\163\37\207\77\236\67", "\224\77\174\63\139\38\175")]:IsCastable() and not v102) or (1664 > 1698)) then
								if (v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge)) or (3427 < 2849)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\151\73\81\43\136\69\103\45\140\64\74\41\129\1\85\47\141\79\24\125\208", "\78\228\33\56");
								end
							end
							if ((3616 <= 4429) and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\237\118\179\17\130\203", "\229\174\30\210\99")]:IsCastable() and not v102) then
								if ((3988 >= 66) and v23(v98.Charge, not v14:IsSpellInRange(v98.Charge))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\24\229\135\67\234\56\121\22\236\143\95\173\110\109", "\89\123\141\230\49\141\93");
								end
							end
							v206 = 1;
						end
						if ((v206 == 1) or (862 > 4644)) then
							if ((1221 == 1221) and (v93 < v95)) then
								if ((v50 and ((v32 and v57) or not v57)) or (45 > 1271)) then
									local v221 = 0;
									while true do
										if ((3877 > 1530) and (v221 == 0)) then
											v29 = v112();
											if (v29 or (4798 == 1255)) then
												return v29;
											end
											break;
										end
									end
								end
							end
							if ((v40 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\116\228\3\25\73\199\121\228\3\7", "\42\147\17\150\108\112")]:IsCastable() and not v14:IsInRange(30)) or (2541 > 2860)) then
								if (v23(v98.HeroicThrow, not v14:IsInRange(30)) or (2902 > 3629)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\7\163\63\112\238\235\48\178\37\109\232\255\79\171\44\118\233", "\136\111\198\77\31\135");
								end
							end
							if ((427 < 3468) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\53\27\162\85\182\237\25\174\54\1\181\89\170", "\201\98\105\199\54\221\132\119")]:IsCastable() and v49 and v14:AffectingCombat() and v105()) then
								if ((4190 >= 2804) and v23(v98.WreckingThrow, not v14:IsInRange(30))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\174\30\134\34\9\60\162\190\51\151\41\16\58\187\249\1\130\40\12", "\204\217\108\227\65\98\85");
								end
							end
							if ((2086 == 2086) and (v93 < v95) and v34 and ((v52 and v32) or not v52) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\127\213\244\241\45\210", "\160\62\163\149\133\76")]:IsCastable()) then
								if ((4148 > 2733) and v23(v98.Avatar)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\215\182\12\59\194\196\224\0\46\202\216\224\95", "\163\182\192\109\79");
								end
							end
							v206 = 2;
						end
						if ((3054 >= 1605) and (v206 == 3)) then
							if ((1044 < 1519) and v106() and v65 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\8\23\191\245\2\228\214\42\18", "\183\68\118\204\129\81\144")]:IsCastable() and v13:BuffDown(v98.ShieldWallBuff) and (((v14:HealthPercentage() >= 90) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\163\126\225\25\148\7\163\119\194\4\129\27\190", "\226\110\205\16\132\107")]:IsAvailable()) or ((v14:HealthPercentage() <= 20) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\205\238\220\83\253\202\238\222\103\228\192\245\202", "\33\139\163\128\185")]:IsAvailable()) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\117\87\8\205\67\93\22", "\190\55\56\100")]:IsAvailable() or v13:HasTier(30, 2))) then
								if ((1707 <= 4200) and v23(v98.LastStand)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\90\174\47\10\44\240\231\87\161\56\94\23\230\245\83\161\47\23\5\230", "\147\54\207\92\126\115\131");
								end
							end
							if ((580 == 580) and (v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == LUAOBFUSACTOR_DECRYPT_STR_0("\29\61\52\100\8\108", "\30\109\81\85\29\109")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\112\66\183\49\219\238", "\156\159\17\52\214\86\190")]:IsCastable()) then
								local v213 = 0;
								while true do
									if ((601 <= 999) and (v213 == 0)) then
										v110(10);
										if ((3970 == 3970) and v23(v100.RavagerPlayer, not v102)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\188\238\171\189\169\234\175\252\163\238\180\178\238\189\233", "\220\206\143\221");
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == LUAOBFUSACTOR_DECRYPT_STR_0("\133\104\63\4\215\222", "\178\230\29\77\119\184\172")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\191\28\26\112\253\231", "\152\149\222\106\123\23")]:IsCastable()) or (98 == 208)) then
								local v214 = 0;
								while true do
									if ((2006 <= 3914) and (v214 == 0)) then
										v110(10);
										if (v23(v100.RavagerCursor, not v102) or (3101 <= 2971)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\207\39\224\66\178\216\52\182\78\180\212\40\182\17\225", "\213\189\70\150\35");
										end
										break;
									end
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\80\121\7\93\84\120\1\85\92\122\15\124\93\123\29\91", "\104\47\53\20")]:IsCastable() and v37 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\129\67\142\17\181\1\164\122\142\21\191\10", "\111\195\44\225\124\220")]:IsAvailable()) or (2073 <= 671)) then
								local v215 = 0;
								while true do
									if ((3305 > 95) and (v215 == 0)) then
										v110(30);
										if ((2727 == 2727) and v23(v98.DemoralizingShout, not v102)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\220\67\13\124\185\170\212\79\26\122\165\172\231\85\8\124\190\191\152\75\1\122\165\235\138\30", "\203\184\38\96\19\203");
										end
										break;
									end
								end
							end
							v206 = 4;
						end
						if ((v206 == 5) or (2970 >= 4072)) then
							if ((3881 > 814) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\177\217\174\142\178\147\131\199\164", "\228\226\177\193\237\217")]:IsCastable() and v45 and v13:BuffUp(v98.AvatarBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\190\48\242\59\160\51\231\54\188\38\192\59\162\32\227", "\134\84\208\67")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\33\185\139\94\31\165\136\91\54\173\148\72\27", "\60\115\204\230")]:IsAvailable()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\53\229\121\228\24\228\127\234", "\16\135\90\139")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\102\97\11\49\66\93\118\83\81\7\33\90\92", "\24\52\20\102\83\46\52")]:IsAvailable() and (v104 >= 3) and v14:IsCasting()))) then
								local v216 = 0;
								while true do
									if ((v216 == 0) or (4932 < 4868)) then
										v110(10);
										if ((3667 <= 4802) and v23(v98.Shockwave, not v14:IsInMeleeRange(v28))) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\215\39\46\39\4\211\46\55\33\79\201\46\40\42\79\151\125", "\111\164\79\65\68");
										end
										break;
									end
								end
							end
							if ((1260 >= 858) and (v93 < v95) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\245\209\138\219\34\238\229\209\130\204\41\239", "\138\166\185\227\190\78")]:IsCastable() and v43 and ((v54 and v32) or not v54)) then
								if (v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge)) or (3911 == 4700)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\216\124\204\50\94\39\38\200\124\196\37\85\38\89\198\117\204\57\18\112\77", "\121\171\20\165\87\50\67");
								end
							end
							if ((3000 < 4194) and v109() and v64) then
								if ((651 < 4442) and v23(v98.ShieldBlock)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\213\48\176\51\181\6\249\58\181\57\186\9\134\53\184\63\183\66\149\96", "\98\166\88\217\86\217");
								end
							end
							if ((v104 > 3) or (195 >= 1804)) then
								local v217 = 0;
								while true do
									if ((0 == v217) or (1382 > 2216)) then
										v29 = v114();
										if (v29 or (2861 == 2459)) then
											return v29;
										end
										v217 = 1;
									end
									if ((1903 < 4021) and (v217 == 1)) then
										if (v19.CastAnnotated(v98.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\193\215\80\53", "\188\150\150\25\97\230")) or (2270 >= 4130)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\234\134\80\14\76\235\213\155\31\35\3\232\146\192", "\141\186\233\63\98\108");
										end
										break;
									end
								end
							end
							v206 = 6;
						end
						if ((2593 <= 3958) and (v206 == 6)) then
							v29 = v115();
							if ((1176 == 1176) and v29) then
								return v29;
							end
							if (v19.CastAnnotated(v98.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\198\203\5\130", "\69\145\138\76\214")) or (3062 == 1818)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v206 == 4) or (3717 < 3149)) then
							if ((3195 < 3730) and (v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\41\127\120\88\203\43", "\174\89\19\25\33")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\2\87\79\229\136\13\13\19\65\90\254\136\5", "\107\79\114\50\46\151\231")]:IsCastable()) then
								local v218 = 0;
								while true do
									if ((2797 <= 3980) and (v218 == 0)) then
										v110(20);
										if ((1944 <= 2368) and v23(v100.SpearOfBastionPlayer, not v102)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\42\182\176\40\152\6\184\198\6\164\180\58\158\48\184\206\121\171\180\32\132\121\229\152", "\160\89\198\213\73\234\89\215");
										end
										break;
									end
								end
							end
							if ((1709 < 4248) and (v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\75\100\166\237\202\90", "\165\40\17\212\158")) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\214\201\13\50\52\234\223\42\50\53\241\208\7\61", "\70\133\185\104\83")]:IsCastable()) then
								local v219 = 0;
								while true do
									if ((v219 == 0) or (3970 == 3202)) then
										v110(20);
										if (v23(v100.SpearOfBastionCursor, not v102) or (3918 >= 4397)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\23\85\65\43\219\59\74\66\21\203\5\86\80\35\198\10\5\73\43\192\10\5\22\114", "\169\100\37\36\74");
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v48 and ((v56 and v32) or not v56) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\52\143\183\94\4\130\176\95\21\148\144\95\1\149", "\48\96\231\194")]:IsCastable()) or (780 == 3185)) then
								if (v23(v98.ThunderousRoar, not v14:IsInMeleeRange(v28)) or (3202 >= 4075)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\220\82\27\35\29\221\189\140\221\73\49\63\22\217\189\195\197\91\7\35\89\139\255", "\227\168\58\110\77\121\184\207");
								end
							end
							if ((64 == 64) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\72\52\182\69\189\223\66\169\122\49", "\197\27\92\223\32\209\187\17")]:IsCastable() and v44 and v13:BuffUp(v98.FervidBuff)) then
								if ((2202 >= 694) and v23(v98.ShieldSlam, not v102)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\16\87\202\254\15\91\252\232\15\94\206\187\14\94\202\245\67\12\146", "\155\99\63\163");
								end
							end
							v206 = 5;
						end
						if ((3706 <= 3900) and (2 == v206)) then
							if ((2890 > 2617) and (v93 < v95) and v51 and ((v58 and v32) or not v58)) then
								local v220 = 0;
								while true do
									if ((v220 == 0) or (3355 > 4385)) then
										if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\22\42\15\207\241\18\51\18\217", "\149\84\70\96\160")]:IsCastable() or (3067 <= 2195)) then
											if ((3025 >= 2813) and v23(v98.BloodFury)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\58\10\2\226\60\57\11\248\42\31\77\224\57\15\3\173\108", "\141\88\102\109");
											end
										end
										if ((2412 >= 356) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\145\86\216\99\31\47\94\200\189\84", "\161\211\51\170\16\122\93\53")]:IsCastable()) then
											if ((2070 > 1171) and v23(v98.Berserking)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\249\171\160\59\254\188\185\33\245\169\242\37\250\167\188\104\173", "\72\155\206\210");
											end
										end
										v220 = 1;
									end
									if ((v220 == 1) or (4108 < 3934)) then
										if ((3499 >= 3439) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\103\104\87\15\61\67\78\91\28\33\67\116\64", "\83\38\26\52\110")]:IsCastable()) then
											if ((876 < 3303) and v23(v98.ArcaneTorrent)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\89\5\36\71\86\18\24\82\87\5\53\67\86\3\103\75\89\30\41\6\0", "\38\56\119\71");
											end
										end
										if ((2922 <= 3562) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\230\95\222\49\69\217\250\92\209\40\83\253\251", "\54\147\143\56\182\69")]:IsCastable()) then
											if ((2619 >= 1322) and v23(v98.LightsJudgment)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\218\136\248\65\203\197\190\245\92\219\209\140\250\71\203\150\140\254\64\209\150\208\175", "\191\182\225\159\41");
											end
										end
										v220 = 2;
									end
									if ((4133 >= 2404) and (v220 == 3)) then
										if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\36\30\85\200\170\70\153\15\28\89\212", "\235\102\127\50\167\204\18")]:IsCastable() or (1433 == 2686)) then
											if (v23(v98.BagofTricks) or (4123 == 4457)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\81\175\246\38\87\58\66\160\249\28\71\47\92\173\181\46\69\39\94\225\164\117", "\78\48\193\149\67\36");
											end
										end
										break;
									end
									if ((v220 == 2) or (3972 <= 205)) then
										if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\13\27\58\80\137\139\205\36\22", "\162\75\114\72\53\235\231")]:IsCastable() or (3766 < 1004)) then
											if ((1784 < 2184) and v23(v98.Fireblood)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\138\53\86\231\81\14\131\51\64\162\94\3\133\50\4\179\1", "\98\236\92\36\130\51");
											end
										end
										if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\133\23\15\191\86\188\167\49\168\58\13\182\73", "\80\196\121\108\218\37\200\213")]:IsCastable() or (1649 > 4231)) then
											if ((3193 == 3193) and v23(v98.AncestralCall)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\1\125\1\122\88\26\152\1\127\61\124\74\2\134\64\126\3\118\69\78\219\84", "\234\96\19\98\31\43\110");
											end
										end
										v220 = 3;
									end
								end
							end
							v207 = v97.HandleDPSPotion(v14:BuffUp(v98.AvatarBuff));
							if (v207 or (3495 > 4306)) then
								return v207;
							end
							if ((4001 > 3798) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\25\25\142\23\83\53\46\129\17\79", "\33\80\126\224\120")]:IsReady() and v66 and v107() and (v14:HealthPercentage() >= 20) and (((v13:RageDeficit() <= 15) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\160\10\193\80\232\155\15\197\81", "\60\140\200\99\164")]:CooldownUp()) or ((v13:RageDeficit() <= 40) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\252\13\35\174\131\215\12\39\176\128\241", "\194\231\148\100\70")]:CooldownUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\68\192\174\230\193\73\66\210\129\227\196\81\77\211\168", "\168\38\44\161\195\150")]:IsAvailable()) or ((v13:RageDeficit() <= 20) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\179\244\139\115\60\236\149\30\129\238\133\115", "\118\224\156\226\22\80\136\214")]:CooldownUp()) or ((v13:RageDeficit() <= 30) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\102\235\84\143\80\239\85\137\88\231\87\135\113\230\86\149\86", "\224\34\142\57")]:CooldownUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\252\168\202\208\122\255\90\56\209\174\198\216", "\110\190\199\165\189\19\145\61")]:IsAvailable()) or ((v13:RageDeficit() <= 20) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\251\253\118\252\138\213", "\167\186\139\23\136\235")]:CooldownUp()) or ((v13:RageDeficit() <= 45) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\62\176\133\2\8\180\132\4\0\188\134\10\41\189\135\24\14", "\109\122\213\232")]:CooldownUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\248\173\61\231\249\165\6\225\254\161\53", "\80\142\151\194")]:IsAvailable() and v13:BuffUp(v98.LastStandBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\54\200\121\73\17\208\126\66\4\224\120\79\22\213", "\44\99\166\23")]:IsAvailable()) or ((v13:RageDeficit() <= 30) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\93\225\40\34\50\182", "\196\28\151\73\86\83")]:CooldownUp() and v13:BuffUp(v98.LastStandBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\13\39\21\144\78\17\120\244\37\38\19\151\75", "\22\147\99\73\112\226\56\120")]:IsAvailable()) or (v13:RageDeficit() <= 20) or ((v13:RageDeficit() <= 40) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\125\235\240\129\188\70\238\244\128", "\237\216\21\130\149")]:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\170\75\94\73\169\251\91\146\75\77\92\165\218\77\139\65\81\76", "\62\226\46\63\63\208\169")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\20\69\134\17\8\59\76\228\27\89\134\40\12\35\82", "\62\133\121\53\227\127\109\79")]:IsAvailable()) or ((v13:RageDeficit() <= 55) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\28\59\240\218\170\145\28\21\63", "\194\112\116\82\149\182\206")]:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v13:BuffUp(v98.LastStandBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\166\66\29\210\244\7\55\175\106\23\195\247\29", "\110\89\200\44\120\160\130")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\131\198\74\80\90\120\62\93\174\209\72\83\80\89\50\66\165\208", "\45\203\163\43\38\35\42\91")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\251\136\204\38\137\172\64\192\132\222\47\130\158\85\222\137", "\52\178\229\188\67\231\201")]:IsAvailable()) or ((v13:RageDeficit() <= 17) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\73\89\1\251\88\16\45\64\93", "\67\65\33\48\100\151\60")]:CooldownUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\226\175\206\234\237\226\190\221\225\220\242\189\203\250\208\233\189", "\147\191\135\206\184")]:IsAvailable()) or ((v13:RageDeficit() <= 18) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\183\32\175\196\212\87\129\136\41\171", "\210\228\72\198\161\184\51")]:CooldownUp() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\68\227\21\125\203\34\91\242\18\127\203\1\72\255\28", "\174\86\41\147\112\19")]:IsAvailable()))) then
								if (v23(v98.IgnorePain, nil, nil, true) or (4688 <= 4499)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\82\7\131\4\55\10\46\187\90\9\131\75\40\14\24\165\27\82\221", "\203\59\96\237\107\69\111\113");
								end
							end
							v206 = 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v136 = 0;
		while true do
			if ((v136 == 5) or (1567 <= 319)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\47\71\88\191\163\45\64", "\214\205\74\51\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\95\231\200\127\239\66\230\249\101\245\89\241\206\120\251\94", "\23\154\44\130\156")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\163\185\186\63\29\22\181", "\115\113\198\205\206\86")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\65\255\78\133\69\201\83\144\95\221\126", "\58\228\55\158")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\140\196\58\53\163\50\167", "\85\212\233\176\78\92\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\89\158\227\77\93\154\213\67\76\128\193\110", "\130\42\56\232")];
				v136 = 6;
			end
			if ((v136 == 4) or (4583 == 3761)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\182\246\213\207\13\119\107", "\24\195\211\130\161\166\99\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\16\236\30\82\0\71\4\236\62", "\118\38\99\137\76\51")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\35\17\6\0\46\250\53", "\64\157\70\101\114\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\187\162\208\24\73\173\171\231\51\72\169\181\228\21", "\112\32\200\199\131")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\85\72\172\202\165\37\63", "\66\76\48\60\216\163\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\149\124\192\79\203\37\168\169\127\209\94\221\48\179\137\119", "\68\218\230\25\147\63\174")];
				v136 = 5;
			end
			if ((3454 > 1580) and (v136 == 6)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\217\176\48\247\73\49\237\166", "\95\138\213\68\131\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\32\168\70\122\46\11\169\66\100\45\45\150\74\98\34\11\133", "\22\74\72\193\35")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\124\240\76\37\119\227\75", "\56\76\25\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\209\174\39\221\113\199\137\39\220\74\200\164\40\248\87\213\163\5\235", "\175\62\161\203\70")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\216\215\7\60\50\218\208", "\85\92\189\163\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\164\37\54\45\169\34\55\60\191\2\55\40\190\7\49\61\164\19\28", "\88\73\204\80")];
				break;
			end
			if ((3 == v136) or (1607 == 20)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\58\168\41\103\0\163\58\96", "\19\105\205\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\188\27\219\181\55\188\6\218\132\45\138\4\223\145", "\95\201\104\190\225")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\156\206\213\218\166\197\198\221", "\174\207\171\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\248\237\8\196\234\210\238\245\4\253\255\227\229\236\2\228", "\183\141\158\109\147\152")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\12\242\24\37\7\225\31", "\108\76\105\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\214\180\192\216\234\209\176\243", "\174\139\165\209\129")];
				v136 = 4;
			end
			if ((2 == v136) or (962 >= 4666)) then
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\17\210\232\133\175\247\38", "\85\153\116\166\156\236\193\144")][LUAOBFUSACTOR_DECRYPT_STR_0("\177\243\72\129\225\22\161\238\74\182", "\96\196\128\45\211\132")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\6\136\111\75\219\161\179\203", "\184\85\237\27\63\178\207\212")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\74\12\108\0\80\12\83\12\106\5\94\5", "\63\104\57\105")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\130\176\80\2\137\163\87", "\36\107\231\196")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\166\167\180\85\186\161\140\74\180\180\130", "\231\61\213\194")];
				v136 = 3;
			end
			if ((v136 == 1) or (1896 == 1708)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\71\55\183\54\71\226\29", "\110\122\34\67\195\95\41\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\96\162\94\110\211\99\176\72\94\215\97\180", "\182\21\209\59\42")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\132\82\209\9\40\176\176\68", "\222\215\55\165\125\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\194\195\63\234\196\238\95\56\212", "\42\76\177\166\122\146\161\141")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\143\17\218\112\120\162\153", "\22\197\234\101\174\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\39\160\244\115\189\216\143\46\0\173\206\121\184", "\230\77\84\197\188\22\207\183")];
				v136 = 2;
			end
			if ((3985 >= 1284) and (v136 == 0)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\202\157\157\182\24\119\220", "\118\16\175\233\233\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\151\48\153\239\159\105\135\129\6\179\225\158\105", "\29\235\228\85\219\142\235")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\209\174\201\126\64\32\65", "\50\93\180\218\189\23\46\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\183\94\111\76\221\90\217\161", "\40\190\196\59\44\36\188")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\64\200\160\243\115\10\47", "\109\92\37\188\212\154\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\252\161\231\52\87\11\253\165\207\56\64\13\225\163\240\57\85\17\251", "\58\100\143\196\163\81")];
				v136 = 1;
			end
		end
	end
	local function v119()
		local v137 = 0;
		while true do
			if ((v137 == 2) or (1987 == 545)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\216\98\22\187\90\127\53", "\70\216\189\22\98\210\52\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\204\166\180\219\211\218\175\131\241\214\208\160\140", "\179\186\191\195\231")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\58\12\240\240\49\31\247", "\132\153\95\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\161\11\30\255\211\165\189\182\57\44\251\214", "\192\209\210\110\77\151\186")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\6\54\253\246\202\231\16", "\164\128\99\66\137\159")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\154\236\136\9\138\253\177\18\144\219\171\19\129", "\222\96\233\137")];
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\182\179\11\129\253\247\170", "\144\217\211\199\127\232\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\60\59\11\221\68\12\67\253\28\42\41\219\70\7", "\36\152\79\94\72\181\37\98")];
				v137 = 3;
			end
			if ((v137 == 0) or (4896 < 1261)) then
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\134\4\82\32\212\41\144", "\186\78\227\112\38\73")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\68\248\101\70\119\241\82\241", "\26\156\55\157\53\51")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\221\2\205\177\94\139\203", "\48\236\184\118\185\216")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\174\82\3\219\59\247\176\117\63\195\32", "\84\133\221\55\80\175")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\226\48\178\206\82\186\244", "\60\221\135\68\198\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\174\253\170\76\205\231\176\241\135\67\205\231\179\255\176\74\214\251\169", "\185\142\221\152\227\34")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\192\67\238\74\61\240\75", "\151\56\165\55\154\35\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\181\80\0\204\169\87\17\235\178\106\8\227\181\77\12\250\185", "\142\192\35\101")];
				v137 = 1;
			end
			if ((23 < 3610) and (v137 == 3)) then
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\221\83\43\222\214\64\44", "\95\183\184\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\54\243\50\81\146\43\184\50\242\40\93\148\27\157\15", "\98\213\95\135\70\52\224")] or 0;
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\221\99\93\240\164\218", "\52\158\195\169\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\187\60\123\148\48\75\138\115\178\26\68", "\235\26\220\82\20\230\85\27")] or 0;
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\164\253\214\125\134\166\250", "\20\232\193\137\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\209\209\163\245\154\18\127\39\247\245", "\17\66\191\165\198\135\236\119")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\170\186\7\246\230\235\194", "\177\111\207\206\115\159\136\140")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\136\3\0\231\91\94\11\141\56\36", "\63\101\233\112\116\180\47")] or 0;
				v137 = 4;
			end
			if ((v137 == 1) or (3911 < 2578)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\61\183\238\130\171\5", "\118\182\21\73\195\135\236\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\47\31\105\3\3\242\26\57\42\65\13\3", "\157\104\92\122\32\100\109")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\219\222\52\41\138\184", "\203\195\198\175\170\93\71\237")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\88\59\252\95\5\249\60\93\59\219\84", "\156\78\43\94\181\49\113")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\208\183\2\77\126\97", "\25\18\136\164\195\107\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\62\172\99\115\175\213\139\252\44\167\75", "\216\136\77\201\47\18\220\161")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\233\63\206\1\210\133\62", "\226\77\140\75\186\104\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\221\213\13\78\181\194\201\54\65\190\237\194\38", "\47\217\174\176\95")];
				v137 = 2;
			end
			if ((v137 == 5) or (4238 < 87)) then
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\251\254\156\126\30\235\207\157\98\4\218\205", "\17\108\146\157\232")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\187\51\59\134\190\231\234\169\51\14\151\177\250\224\186\30\13", "\131\223\86\93\227\208\148")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\42\51\190\230\35\57\22\186\245\50\34\43\184", "\129\70\75\69\223")] or "";
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\146\188\242\17\208\209\196\150\176\253\4", "\180\176\226\217\147\99\131")] or "";
				break;
			end
			if ((2538 == 2538) and (v137 == 4)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\62\249\6\241\56\196\40", "\86\163\91\141\114\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\65\10\120\127\35\90\5\115\80\40\74\44\102\124\47\67", "\90\51\107\20\19")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\245\145\251\52\131\247\150", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\247\252\21\18\79\27\241\211\11\18\110\37", "\38\117\150\144\121\107")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\190\250\46\36\181\233\41", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\12\40\60\64\3\88\234\11\34\50\100\55", "\26\134\100\65\89\44\103")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\36\55\173\255\228\35", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\184\15\13\20\236\41\177\10\4\48\216", "\136\126\208\102\104\120")] or 0;
				v137 = 5;
			end
		end
	end
	local function v120()
		local v138 = 0;
		while true do
			if ((4122 == 4122) and (v138 == 2)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\40\234\160\2\73\46\240\153\0\88\50\192\138", "\105\44\90\131\206")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\248\5\182\94\115\234\77\89\237\14\156\123", "\26\48\153\102\223\63\31\153")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\69\249\231\11\78\234\224", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\80\230\226\3\87\71\12\75\240\222\9\88\78", "\43\120\35\131\170\102\54")];
				v138 = 3;
			end
			if ((v138 == 1) or (2371 > 2654)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\43\89\234\203\227\48\93\251\237\249\55\72\252\209\254\41\73", "\185\145\69\45\143")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\33\22\183\42\59\29\136\61\38\0", "\227\88\82\115")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\232\15\208\29\248\3\227\16\232", "\130\124\155\106")];
				v138 = 2;
			end
			if ((v138 == 4) or (3466 > 4520)) then
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\54\29\30\59\246\248\32", "\152\159\83\105\106\82")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\195\80\254\192\82\134\246\94\230\192\83\143\232\80\255\204", "\60\225\166\49\146\169")] or "";
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\126\221\119\82\31\147\113\208\124\76\10\181\109\214\114\82", "\122\218\31\179\19\62")];
				break;
			end
			if ((v138 == 3) or (951 >= 1027)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\3\147\162\172\190\131\71", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\243\112\226\239\138\21\223\16\231\69\197\254\130\22\216", "\182\126\128\21\170\138\235\121")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\223\33\242\143\29\55\21", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\9\63\83\102\220\49\67\3\48\90\90\228", "\66\55\108\94\63\18\180")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\39\136\145\35\46\87\19\158", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\162\180\236\235\126\224\64\154\190\249\238\120\224\111\154", "\39\202\209\141\135\23\142")] or 0;
				v138 = 4;
			end
			if ((v138 == 0) or (1369 > 2250)) then
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\76\190\27\221\85\190\166\71\182\21\219\82\175\171\79\180\23", "\195\42\215\124\181\33\236")] or 0;
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\217\30\166\172\192\65\184\237\224\3\183\182\225\64\189\247", "\200\153\183\106\195\222\178\52")];
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\89\196\16\79\45\150\71\196\58\83\51\154\96\216\28\73\58\143\94\195\1", "\95\227\55\176\117\61")];
				v138 = 1;
			end
		end
	end
	local function v121()
		local v139 = 0;
		while true do
			if ((1 == v139) or (937 > 3786)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\217\202\198\197\164\86", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\248\53\78", "\217\151\90\45\185\72\27")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\115\224\21\90\198\111", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\212\88", "\31\72\187\61\226\46")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\9\68\213\75\123\55", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\189\116\201", "\113\222\16\186\167\99\213\227")];
				v139 = 2;
			end
			if ((v139 == 4) or (901 > 4218)) then
				if ((4779 > 4047) and not v13:IsChanneling()) then
					if ((4050 > 1373) and v13:AffectingCombat()) then
						local v211 = 0;
						while true do
							if ((v211 == 0) or (1037 > 4390)) then
								v29 = v117();
								if ((1407 <= 1919) and v29) then
									return v29;
								end
								break;
							end
						end
					else
						local v212 = 0;
						while true do
							if ((2526 >= 1717) and (0 == v212)) then
								v29 = v116();
								if (v29 or (3620 <= 2094)) then
									return v29;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v139 == 3) or (1723 >= 2447)) then
				if (v31 or (1199 > 3543)) then
					local v208 = 0;
					while true do
						if ((1617 < 3271) and (v208 == 0)) then
							v103 = v13:GetEnemiesInMeleeRange(v28);
							v104 = #v103;
							break;
						end
					end
				else
					v104 = 1;
				end
				v102 = v14:IsInMeleeRange(v28);
				if ((3085 > 1166) and (v97.TargetIsValid() or v13:AffectingCombat())) then
					local v209 = 0;
					while true do
						if ((4493 >= 3603) and (v209 == 0)) then
							v94 = v10.BossFightRemains(nil, true);
							v95 = v94;
							v209 = 1;
						end
						if ((2843 <= 2975) and (v209 == 1)) then
							if ((v95 == 11111) or (1989 <= 174)) then
								v95 = v10.FightRemains(v103, false);
							end
							break;
						end
					end
				end
				v139 = 4;
			end
			if ((v139 == 0) or (209 > 2153)) then
				v119();
				v118();
				v120();
				v139 = 1;
			end
			if ((2 == v139) or (2020 == 1974)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\1\252\241\34\11\232", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\142\204\36\234", "\32\229\165\71\129\196\126\223")];
				if (v13:IsDeadOrGhost() or (1347 == 1360)) then
					return;
				end
				if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\234\135\208\136\140\220\199\136\208\136\143\210\240\129\203\148\149", "\181\163\233\164\225\225")]:IsAvailable() or (4461 == 3572)) then
					v28 = 8;
				end
				v139 = 3;
			end
		end
	end
	local function v122()
		v19.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\96\153\49\99\85\136\42\126\95\133\126\64\81\153\44\126\95\153\126\117\73\203\27\103\89\136\112\55\99\158\46\103\95\153\42\114\84\203\60\110\16\147\21\118\94\142\42\120\30", "\23\48\235\94"));
	end
	v19.SetAPL(73, v121, v122);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\89\202\209\69\104\4\211\110\200\209\82\69\12\226\110\213\204\88\84\39\219\115\212\150\81\66\50", "\178\28\186\184\61\55\83")]();

