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
		if ((3716 == 3716) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3352 == 4722)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (740 < 160)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\198\18\208\199\210\43\217\139\213\17\197\198\216\49\239\180\201\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\19\35\96", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\118\209\55\229\69\106", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\156\124\110\47\22\96", "\35\200\29\28\72\115\20\154")];
	local v18 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\41\186\197", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\136\70\204\172\54", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\32\179\133\51", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\230\61\36\244\209", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\25\211\41\155\58", "\232\73\161\76")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v27 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v28 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\206\33\50\141\181\13", "\156\168\78\64\224\212\121")];
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
	local v94;
	local v95;
	local v96 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\55\239\169\207\3\231\171", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\102\58\80\44\32\93\236\95\39\81", "\152\54\72\63\88\69\62")];
	local v97 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\228\197\226\93\208\205\224", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\76\10\61\34\238\6\81\81\11", "\114\56\62\101\73\71\141")];
	local v98 = v24[LUAOBFUSACTOR_DECRYPT_STR_0("\136\232\215\197\188\224\213", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\244\62\166\163\253\31\219\233\63", "\107\178\134\81\210\198\158")];
	local v99 = {};
	local v100;
	local v101;
	local v102, v103;
	local v104, v105;
	local v106 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\27\1\143\203\165\54\29", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\25\135\229\211\204\1\135", "\170\163\111\226\151")];
	local function v107()
		if (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\50\60\183\57\64\36\44\37\63\170\49\64\36", "\73\113\80\210\88\46\87")]:IsAvailable() or (3658 > 3664)) then
			v106[LUAOBFUSACTOR_DECRYPT_STR_0("\165\37\222\2\226\141\32\204\16\235\132\8\200\16\242\135\42\222", "\135\225\76\173\114")] = v13.MergeTable(v106.DispellableDiseaseDebuffs, v106.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\59\206\140\153\154\152\152\42\193\153\137\137\143\152\41\221\157\147\133\156\139\51\215\153\132\133\146\137\37\206\144\145\130\154\130\62", "\199\122\141\216\208\204\221"));
	local function v108(v123)
		return v123:DebuffRemains(v96.JudgmentDebuff);
	end
	local function v109()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v110()
		if ((3805 >= 1031) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\142\209\21\241\118\229\168\233\31\232\113\248\190", "\150\205\189\112\144\24")]:IsReady() and v33 and v106.DispellableFriendlyUnit(25)) then
			if ((3194 > 3007) and v25(v98.CleanseToxinsFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\38\136\186\77\10\155\20\47\54\148\182\94\13\156\81\20\44\151\175\73\8", "\112\69\228\223\44\100\232\113");
			end
		end
	end
	local function v111()
		if ((v94 and (v15:HealthPercentage() <= v95)) or (2136 >= 2946)) then
			if ((2165 <= 2521) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\242\19\6\192\190\115\128\248\22\0\219\162", "\230\180\127\103\179\214\28")]:IsReady()) then
				if ((2861 > 661) and v25(v96.FlashofLight)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\138\9\94\85\236\126\239\138\58\83\79\227\73\244\204\13\90\71\232\1\239\131\6", "\128\236\101\63\38\132\33");
				end
			end
		end
	end
	local function v112()
		local v124 = 0;
		while true do
			if ((4525 > 4519) and (v124 == 1)) then
				v29 = v106.HandleBottomTrinket(v99, v32, 40, nil);
				if ((3178 > 972) and v29) then
					return v29;
				end
				break;
			end
			if ((4766 == 4766) and (v124 == 0)) then
				v29 = v106.HandleTopTrinket(v99, v32, 40, nil);
				if (v29 or (2745 > 3128)) then
					return v29;
				end
				v124 = 1;
			end
		end
	end
	local function v113()
		local v125 = 0;
		while true do
			if ((v125 == 2) or (1144 >= 4606)) then
				if ((3338 >= 277) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\110\89\89\249\122\128\160\7\86\68\82", "\107\57\54\43\157\21\230\231")]:IsReady() and (v15:HealthPercentage() <= v69) and v59 and not v15:HealingAbsorbed()) then
					if ((2610 > 2560) and ((v15:BuffRemains(v96.ShieldoftheRighteousBuff) >= 5) or v15:BuffUp(v96.DivinePurposeBuff) or v15:BuffUp(v96.ShiningLightFreeBuff))) then
						if (v25(v98.WordofGloryPlayer) or (1194 > 3083)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\204\132\3\241\134\211\201\228\140\29\250\171\197\143\223\142\23\240\183\207\198\205\142\81\173", "\175\187\235\113\149\217\188");
						end
					end
				end
				if ((916 >= 747) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\15\167\136\73\239\125\119\58\187\137\73\209\112\127\52\187\132\67\246\106", "\24\92\207\225\44\131\25")]:IsCastable() and (v15:HolyPower() > 2) and v15:BuffRefreshable(v96.ShieldoftheRighteousBuff) and v60 and (v100 or (v15:HealthPercentage() <= v70))) then
					if (v25(v96.ShieldoftheRighteous) or (2444 > 2954)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\219\177\73\23\121\116\220\190\115\15\117\78\236\170\69\28\117\95\214\183\89\8\61\79\214\190\73\21\110\66\197\189\12\74\47", "\29\43\179\216\44\123");
					end
				end
				v125 = 3;
			end
			if ((2892 < 3514) and (v125 == 1)) then
				if ((533 == 533) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\153\231\192\208\62\199\179\112\177\244\224\204\57\199\183\112\170\217\200\204\61\221", "\30\222\146\161\162\90\174\210")]:IsCastable() and (v15:HealthPercentage() <= v67) and v57 and v15:BuffDown(v96.ArdentDefenderBuff)) then
					if ((595 <= 3413) and v25(v96.GuardianofAncientKings)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\91\113\24\225\71\113\4\218\65\118\53\228\64\115\3\224\64\100\53\238\71\126\13\246\14\116\15\227\75\126\25\236\88\117\74\177", "\106\133\46\16");
					end
				end
				if ((3078 >= 2591) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\121\50\119\249\84\84\124\37\117\249\84\68\93\50", "\32\56\64\19\156\58")]:IsCastable() and (v15:HealthPercentage() <= v65) and v55 and v15:BuffDown(v96.GuardianofAncientKingsBuff)) then
					if ((3199 < 4030) and v25(v96.ArdentDefender)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\218\225\83\84\230\191\94\205\227\83\84\246\133\72\136\225\83\92\247\142\73\193\243\83\26\164", "\224\58\168\133\54\58\146");
					end
				end
				v125 = 2;
			end
			if ((777 < 2078) and (v125 == 3)) then
				if ((1696 <= 2282) and v97[LUAOBFUSACTOR_DECRYPT_STR_0("\149\220\33\64\169\209\51\88\178\215\37", "\44\221\185\64")]:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
					if (v25(v98.Healthstone) or (1761 >= 2462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\226\73\83\103\9\244\92\80\125\4\167\76\90\117\4\233\91\86\101\4", "\19\97\135\40\63");
					end
				end
				if ((4551 > 2328) and v89 and (v15:HealthPercentage() <= v91)) then
					local v200 = 0;
					while true do
						if ((3825 >= 467) and (v200 == 0)) then
							if ((v93 == LUAOBFUSACTOR_DECRYPT_STR_0("\156\89\53\41\42\34\166\85\61\60\111\25\171\93\63\50\33\54\238\108\60\47\38\62\160", "\81\206\60\83\91\79")) or (2890 == 557)) then
								if (v97[LUAOBFUSACTOR_DECRYPT_STR_0("\124\174\214\96\42\208\69\173\64\172\248\119\46\207\68\170\73\155\223\102\38\204\67", "\196\46\203\176\18\79\163\45")]:IsReady() or (4770 == 2904)) then
									if (v25(v98.RefreshingHealingPotion) or (3903 == 4536)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\170\39\120\12\33\232\231\177\44\121\94\44\254\238\180\43\112\25\100\235\224\172\43\113\16\100\255\234\190\39\112\13\45\237\234", "\143\216\66\30\126\68\155");
									end
								end
							end
							if ((4093 <= 4845) and (v93 == "Dreamwalker's Healing Potion")) then
								if ((1569 <= 3647) and v97[LUAOBFUSACTOR_DECRYPT_STR_0("\142\218\8\202\200\180\214\237\161\205\31\216\237\166\214\237\163\198\10\251\202\183\222\238\164", "\129\202\168\109\171\165\195\183")]:IsReady()) then
									if (v25(v98.RefreshingHealingPotion) or (4046 >= 4927)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\38\74\50\217\211\3\231\46\83\50\202\205\84\238\39\89\59\209\208\19\166\50\87\35\209\209\26\166\38\93\49\221\208\7\239\52\93", "\134\66\56\87\184\190\116");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((4623 >= 2787) and (v125 == 0)) then
				if ((2234 >= 1230) and (v15:HealthPercentage() <= v66) and v56 and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\136\160\7\77\184\238\252\164\160\20\72\178", "\175\204\201\113\36\214\139")]:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
					if (v25(v96.DivineShield) or (343 == 1786)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\197\35\213\10\66\243\38\212\13\66\192\49\156\0\66\202\48\210\23\78\218\48", "\100\39\172\85\188");
					end
				end
				if ((2570 > 2409) and (v15:HealthPercentage() <= v68) and v58 and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\129\121\160\143\61\133\121\183\132\32", "\83\205\24\217\224")]:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
					if (v25(v98.LayonHandsPlayer) or (2609 >= 3234)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\196\212\2\233\203\242\53\231\203\201\46\166\193\200\59\227\203\222\52\240\192\141\111", "\93\134\165\173");
					end
				end
				v125 = 1;
			end
		end
	end
	local function v114()
		local v126 = 0;
		while true do
			if ((v126 == 0) or (3033 >= 4031)) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(30) or (1401 == 4668)) then
					return;
				end
				if ((2776 >= 1321) and v14) then
					local v201 = 0;
					while true do
						if ((1 == v201) or (487 > 2303)) then
							if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\160\33\160\89\207\73\31\133\34\163\121\221\67\3\139\43\172\73\217", "\113\226\77\197\42\188\32")]:IsCastable() and v64 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or (4503 == 3462)) then
								if ((553 <= 1543) and v25(v98.BlessingofSacrificeFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\56\26\241\166\41\31\250\178\5\25\242\138\41\23\247\167\51\16\253\182\63\86\240\176\60\19\250\166\51\0\241\245\60\25\247\160\41", "\213\90\118\148");
								end
							end
							if ((2015 == 2015) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\121\34\177\69\94\82\32\179\89\75\107\60\187\66\72\88\58\189\89\67", "\45\59\78\212\54")]:IsCastable() and v63 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
								if (v25(v98.BlessingofProtectionFocus) or (4241 <= 2332)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\18\90\134\152\149\39\163\247\47\89\133\180\150\60\162\228\21\85\151\130\137\32\237\244\21\80\134\133\149\39\187\245\80\80\140\136\147\61", "\144\112\54\227\235\230\78\205");
								end
							end
							break;
						end
						if ((0 == v201) or (2364 < 1157)) then
							if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\11\62\27\191\22\237\6\57\51\35\16", "\85\92\81\105\219\121\139\65")]:IsReady() and v62 and v15:BuffUp(v96.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v72)) or (1167 > 1278)) then
								if (v25(v98.WordofGloryFocus) or (1145 <= 1082)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\234\188\66\65\67\208\251\140\87\73\115\205\228\243\84\64\122\218\243\160\89\83\121\159\251\188\83\80\111", "\191\157\211\48\37\28");
								end
							end
							if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\243\30\237\19\52\247\30\250\24\41", "\90\191\127\148\124")]:IsCastable() and v61 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) or (3105 == 4881)) then
								if (v25(v98.LayonHandsFocus) or (1887 > 4878)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\116\134\55\40\119\137\17\31\121\137\42\4\56\131\43\17\125\137\61\30\110\130\110\17\119\132\59\4", "\119\24\231\78");
								end
							end
							v201 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v127 = 0;
		while true do
			if ((v127 == 0) or (4087 > 4116)) then
				if ((1106 <= 1266) and (v84 < FightRemains) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\159\33\8\244\196\72\153\61\11\251\221\94\189\60", "\59\211\72\111\156\176")]:IsCastable() and v87 and ((v88 and v32) or not v88)) then
					if ((3155 < 4650) and v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\142\228\37\90\148\220\39\91\131\228\32\75\137\247\109\94\149\230\46\65\138\225\44\90\199\183", "\77\46\231\131");
					end
				end
				if ((3774 >= 1839) and (v84 < FightRemains) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\155\70\181\65\180\81\130\79\168\70\179\78\174", "\32\218\52\214")]:IsCastable() and v87 and ((v88 and v32) or not v88) and (HolyPower < 5)) then
					if ((2811 == 2811) and v25(v96.ArcaneTorrent, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\5\50\169\255\181\122\78\65\5\35\173\255\164\5\74\92\18\50\167\252\178\68\78\14\65", "\58\46\119\81\200\145\208\37");
					end
				end
				v127 = 1;
			end
			if ((2146 > 1122) and (v127 == 1)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\8\131\62\191\172\190\36\42\152\57\163\167", "\86\75\236\80\204\201\221")]:IsCastable() and v36) or (56 == 3616)) then
					if (v25(v96.Consecration, not v17:IsInRange(8)) or (2421 < 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\113\78\121\150\251\136\96\64\99\140\241\133", "\235\18\33\23\229\158");
					end
				end
				if ((1009 <= 1130) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\113\172\196\181\87\191\211\168\99\178\200\190\92\190", "\219\48\218\161")]:IsCastable() and v34) then
					if ((2758 < 2980) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\103\121\71\220\74\242\247\78\111\65\210\74\236\224\49\108\91\222\76\239\233\115\125\93\155\30\176", "\128\132\17\28\41\187\47");
					end
				end
				v127 = 2;
			end
			if ((v127 == 2) or (86 >= 3626)) then
				if ((2395 == 2395) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\43\39\2\61\80\4\60\18", "\61\97\82\102\90")]:IsReady() and v40) then
					if ((3780 > 2709) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\59\175\76\202\82\16\29\236\62\185\78\196\88\19\11\173\58\235\26\149", "\105\204\78\203\43\167\55\126");
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v128 = 0;
		local v129;
		while true do
			if ((v128 == 2) or (237 >= 2273)) then
				v129 = v106.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff));
				if (v129 or (2040 <= 703)) then
					return v129;
				end
				v128 = 3;
			end
			if ((3279 <= 3967) and (0 == v128)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\132\188\38\16\20\1\213\66\150\162\42\27\31\0", "\49\197\202\67\126\115\100\167")]:IsCastable() and v34 and (v10.CombatTime() < 2) and v15:HasTier(29, 2)) or (1988 == 877)) then
					if ((4291 > 1912) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\77\218\39\135\83\76\36\100\204\33\137\83\82\51\27\220\38\143\90\90\56\76\209\58\192\4", "\62\87\59\191\73\224\54");
					end
				end
				if ((2003 < 2339) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\203\11\253\193\243\17\208\220\227\5\247\204\233\22", "\169\135\98\154")]:IsCastable() and v87 and ((v88 and v32) or not v88) and (v105 >= 2)) then
					if ((432 == 432) and v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\126\35\92\233\32\247\193\98\32\83\240\54\198\223\55\39\91\242\63\204\196\96\42\71\189\103", "\168\171\23\68\52\157\83");
					end
				end
				v128 = 1;
			end
			if ((v128 == 1) or (1145 >= 1253)) then
				if ((3418 > 2118) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\213\103\240\163\34\36\137\243\70\231\172\49\37", "\231\148\17\149\205\69\77")]:IsCastable() and v41 and ((v47 and v32) or not v47)) then
					if ((3066 <= 3890) and v25(v96.AvengingWrath, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\177\194\245\80\246\142\160\248\236\69\254\148\175\135\248\88\240\140\163\200\236\89\236\192\241", "\159\224\199\167\155\55");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\196\246\50\198\254\253\57\222", "\178\151\147\92")]:IsCastable() and v46 and ((v52 and v32) or not v52)) or (2998 >= 3281)) then
					if (v25(v96.Sentinel, not v17:IsInRange(8)) or (4649 <= 2632)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\248\66\38\27\66\127\128\189\79\61\29\64\126\131\234\66\33\82\20", "\26\236\157\44\82\114\44");
					end
				end
				v128 = 2;
			end
			if ((3 == v128) or (3860 > 4872)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\7\33\216\94\36\58\218\93\13\34\218\73\51", "\59\74\78\181")]:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v96.SentinelBuff) < 15) or (((v10.CombatTime() > 10) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\22\212\84\78\186\43\212\86", "\211\69\177\58\58")]:CooldownRemains() > 15) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\150\243\124\251\238\194\185\226\78\231\232\223\191", "\171\215\133\25\149\137")]:CooldownRemains() > 15)) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\192\222\55\244\232\53\238\81\210\192\59\255\227\52", "\34\129\168\82\154\143\80\156")]:CooldownRemains() > 0) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\175\167\55\12\69\75\135\145", "\233\229\210\83\107\40\46")]:CooldownRemains() > 0) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\233\67\63\219\0\211\77\52\225\23\192\86\58", "\101\161\34\82\182")]:CooldownRemains() > 0)))) or (3998 == 2298)) then
					if (v25(v96.MomentofGlory, not v17:IsInRange(8)) or (8 >= 2739)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\2\84\251\213\246\189\33\238\50\94\242\212\240\155\110\235\2\86\242\223\237\149\32\251\77\8\174", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((2590 == 2590) and v43 and ((v49 and v32) or not v49) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\26\54\239\248\48\58\205\254\50\51", "\145\94\95\153")]:IsReady() and (v104 >= 3)) then
					if (v25(v96.DivineToll, not v17:IsInRange(30)) or (82 >= 1870)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\196\2\220\64\178\194\217\27\217\66\247\254\194\27\217\74\184\234\195\7\149\31\229", "\215\157\173\116\181\46");
					end
				end
				v128 = 4;
			end
			if ((2624 < 4557) and (v128 == 4)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\23\181\152\230\211\58\186\132\244\246\60\179\131\230", "\186\85\212\235\146")]:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v96.AvengingWrathBuff) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\227\151\19\240\62\231\86\197\182\4\255\45\230", "\56\162\225\118\158\89\142")]:CooldownRemains() <= 30))) or (3131 > 3542)) then
					if ((2577 >= 1578) and v25(v96.BastionofLight, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\4\211\187\43\215\82\58\207\169\29\212\85\2\200\187\98\219\83\10\204\171\45\207\82\22\128\254\118", "\184\60\101\160\207\66");
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v130 = 0;
		while true do
			if ((4103 <= 4571) and (v130 == 3)) then
				if (((v84 < FightRemains) and v44 and ((v50 and v32) or not v50) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\39\16\162\89\187\208\14\187", "\201\98\105\199\54\221\132\119")]:IsCastable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\144\2\142\46\17\33\128\176\11\139\53", "\204\217\108\227\65\98\85")]:IsAvailable() and (v104 >= 3)) or (1495 == 4787)) then
					if (v25(v96.EyeofTyr, not v17:IsInRange(8)) or (310 > 4434)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\218\240\218\35\198\97\215\236\247\108\211\74\194\251\225\45\210\90\131\167\179", "\160\62\163\149\133\76");
					end
				end
				if ((2168 <= 4360) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\244\172\8\60\208\211\164\37\46\206\219\165\31", "\163\182\192\109\79")]:IsCastable() and v35) then
					if ((994 == 994) and v25(v96.BlessedHammer, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\42\5\211\230\49\34\63\200\244\57\43\5\210\181\39\50\1\206\241\53\52\4\128\167\108", "\149\84\70\96\160");
					end
				end
				if ((1655 > 401) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\16\7\0\224\61\20\2\235\44\14\8\223\49\1\5\249\61\9\24\254", "\141\88\102\109")]:IsCastable() and v38) then
					if ((3063 <= 3426) and v25(v96.HammeroftheRighteous, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\82\199\125\31\47\106\206\181\108\222\120\31\2\71\200\180\91\222\117\21\40\70\129\160\71\203\126\30\60\71\197\243\0\154", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((1459 > 764) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\216\188\167\59\250\170\183\58\200\186\160\33\240\171", "\72\155\206\210")]:IsCastable() and v37) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or (641 > 4334)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\104\65\29\50\66\127\70\49\32\82\104\93\5\54\6\105\64\15\61\66\123\70\10\115\21\40", "\83\38\26\52\110");
					end
				end
				v130 = 4;
			end
			if ((3399 >= 2260) and (v130 == 2)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\165\215\5\183\56\52\218\151\242\8\176\58\61\204", "\168\228\161\96\217\95\81")]:IsCastable() and v34) or (393 >= 4242)) then
					if ((989 < 4859) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\199\43\82\40\82\201\194\17\79\39\94\222\221\42\28\60\67\218\223\42\93\61\83\155\128\118", "\55\187\177\78\60\79");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\5\207\82\230\67\221\143\43\249\77\234\82\199", "\224\77\174\63\139\38\175")]:IsReady() and v39) or (4795 < 949)) then
					if ((3842 == 3842) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\140\64\85\35\129\83\103\33\130\126\79\60\133\85\80\110\151\85\89\32\128\64\74\42\196\19\8", "\78\228\33\56");
					end
				end
				if ((1747 <= 3601) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\228\107\182\4\136\203\112\166", "\229\174\30\210\99")]:IsReady() and v40) then
					if (v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment)) or (804 > 4359)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\17\248\130\86\224\56\55\15\173\149\69\236\51\61\26\255\130\17\191\111", "\89\123\141\230\49\141\93");
					end
				end
				if ((4670 >= 3623) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\208\126\248\31\21\73\225\112\226\5\31\68", "\42\147\17\150\108\112")]:IsCastable() and v36 and v15:BuffDown(v96.ConsecrationBuff) and ((v15:BuffStack(v96.SanctificationBuff) < 5) or not v15:HasTier(31, 2))) then
					if ((2065 < 2544) and v25(v96.Consecration, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\169\35\108\226\235\29\167\57\118\232\230\79\181\57\126\233\236\14\180\41\63\181\188", "\136\111\198\77\31\135");
					end
				end
				v130 = 3;
			end
			if ((1311 <= 3359) and (0 == v130)) then
				if ((2717 <= 3156) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\18\141\114\175\52\129\110\189\37\139\115\178", "\220\81\226\28")]:IsCastable() and v36 and (v15:BuffStack(v96.SanctificationBuff) == 5)) then
					if ((1081 < 4524) and v25(v96.Consecration, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\218\140\232\239\196\1\212\150\242\229\201\83\198\150\250\228\195\18\199\134\187\184", "\167\115\181\226\155\138");
					end
				end
				if ((440 >= 71) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\209\42\238\89\119\117\201\228\54\239\89\73\120\193\234\54\226\83\110\98", "\166\130\66\135\60\27\17")]:IsCastable() and v60 and ((v15:HolyPower() > 2) or v15:BuffUp(v96.BastionofLightBuff) or v15:BuffUp(v96.DivinePurposeBuff)) and (v15:BuffDown(v96.SanctificationBuff) or (v15:BuffStack(v96.SanctificationBuff) < 5))) then
					if ((4934 > 2607) and v25(v96.ShieldoftheRighteous)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\66\199\112\60\64\117\193\115\15\80\66\203\74\34\77\77\198\97\53\75\95\221\53\35\80\75\192\113\49\86\78\142\33", "\80\36\42\174\21");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\100\5\51\125\67\21\57\110", "\26\46\112\87")]:IsReady() and v40 and (v104 > 3) and (v15:BuffStack(v96.BulwarkofRighteousFuryBuff) >= 3) and (v15:HolyPower() < 3)) or (1400 > 3116)) then
					if ((525 < 1662) and v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\54\175\115\178\186\75\160\249\48\191\117\177\187\68\166\189\99\253", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\144\152\172\213\183\136\166\198", "\178\218\237\200")]:IsReady() and v40 and v15:BuffDown(v96.SanctificationEmpowerBuff) and v15:HasTier(31, 2)) or (876 > 2550)) then
					if ((219 <= 2456) and v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\160\226\215\187\176\232\196\246\166\242\209\184\177\231\194\178\245\190", "\176\214\213\134");
					end
				end
				v130 = 1;
			end
			if ((4 == v130) or (4219 == 1150)) then
				if (((v84 < FightRemains) and v44 and ((v50 and v32) or not v50) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\125\14\34\73\94\35\62\84", "\38\56\119\71")]:IsCastable() and not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\218\225\85\217\54\66\223\230\95\222\49", "\54\147\143\56\182\69")]:IsAvailable()) or (2989 <= 222)) then
					if ((2258 > 1241) and v25(v96.EyeofTyr, not v17:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\152\250\118\208\208\190\235\80\205\150\146\235\72\209\210\128\237\77\159\133\213", "\191\182\225\159\41");
					end
				end
				if ((41 < 4259) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\10\0\43\84\133\130\246\36\0\58\80\133\147", "\162\75\114\72\53\235\231")]:IsCastable() and v87 and ((v88 and v32) or not v88) and (HolyPower < 5)) then
					if (v25(v96.ArcaneTorrent, not v17:IsInRange(8)) or (1930 < 56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\141\46\71\227\93\7\179\40\75\240\65\7\130\40\4\241\71\3\130\56\69\240\87\66\223\106", "\98\236\92\36\130\51");
					end
				end
				if ((3333 == 3333) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\135\22\2\169\64\171\167\49\176\16\3\180", "\80\196\121\108\218\37\200\213")]:IsCastable() and v36 and (v15:BuffDown(v96.SanctificationEmpowerBuff))) then
					if (v25(v96.Consecration, not v17:IsInRange(8)) or (2225 == 20)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\124\12\108\78\13\152\1\103\11\112\69\78\153\20\114\12\123\74\28\142\64\32\90", "\234\96\19\98\31\43\110");
					end
				end
				break;
			end
			if ((v130 == 1) or (872 >= 3092)) then
				if ((4404 >= 3252) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\220\172\187\217\173\68\86\242\154\164\213\188\94", "\57\148\205\214\180\200\54")]:IsReady() and v39) then
					if ((1107 > 796) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\252\56\57\115\0\194\58\50\73\5\239\52\32\126\82\238\33\53\120\22\252\39\48\54\67\173", "\22\114\157\85\84");
					end
				end
				if ((959 == 959) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\238\222\23\195\80\243\166\208", "\200\164\171\115\164\61\150")]:IsReady() and v40 and ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\148\225\7\66\142\187\250\23", "\227\222\148\99\37")]:Charges() >= 2) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\25\71\86\241\244\54\92\70", "\153\83\50\50\150")]:FullRechargeTime() <= v15:GCD()))) then
					if (v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment)) or (245 >= 2204)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\99\119\27\126\174\67\73\54\96\8\114\165\73\92\100\119\92\34\249", "\45\61\22\19\124\19\203");
					end
				end
				if ((3162 >= 2069) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\224\4\8\251\5\117\171\210\33\5\252\7\124\189", "\217\161\114\109\149\98\16")]:IsCastable() and v34 and ((v105 > 2) or v15:BuffUp(v96.MomentofGloryBuff))) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or (306 > 3081)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\54\61\114\187\113\0\51\7\111\180\125\23\44\60\60\175\96\19\46\60\125\174\112\82\113\108", "\20\114\64\88\28\220");
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\21\8\196\189\246\213\137\62\13\222", "\221\81\97\178\212\152\176")]:IsReady()) or (3513 < 2706)) then
					if ((2978 < 3639) and v25(v96.DivineToll, not v17:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\238\11\242\20\200\216\9\244\22\193\167\14\239\27\195\227\28\233\30\141\182\75", "\122\173\135\125\155");
					end
				end
				v130 = 2;
			end
		end
	end
	local function v118()
		local v131 = 0;
		while true do
			if ((3682 >= 2888) and (6 == v131)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\30\15\126\246\242\173", "\152\149\222\106\123\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\35\248\87\188\211\35\250\116\188\201\46\213\103", "\213\189\70\150\35")];
				break;
			end
			if ((149 < 479) and (3 == v131)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\17\38\225\223\160\165\3", "\194\112\116\82\149\182\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\187\73\60\201\244\7\55\173\120\23\204\238", "\110\89\200\44\120\160\130")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\152\198\95\82\74\68\60\94", "\45\203\163\43\38\35\42\91")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\150\217\6\158\172\91\212\177\197\49", "\52\178\229\188\67\231\201")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\68\68\16\254\82\36\50", "\67\65\33\48\100\151\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\244\171\245\252\210\226\160\204\220\217\192\162\215\225\198", "\147\191\135\206\184")];
				v131 = 4;
			end
			if ((1020 >= 567) and (v131 == 5)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\93\16\202\94\86\3\205", "\190\55\56\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\166\42\23\29\230\199\89\163\48\41\26\247\251\117\139", "\147\54\207\92\126\115\131")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\52\33\105\4\112\10\34", "\30\109\81\85\29\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\104\81\185\48\234\229\237\70\93\162\62\253\216", "\156\159\17\52\214\86\190")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\169\168\167\225\186\175", "\220\206\143\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\114\32\18\214\216\221\128\90\33\24\202\213\229\143\105\37\52\252", "\178\230\29\77\119\184\172")];
				v131 = 6;
			end
			if ((1 == v131) or (733 > 2469)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\249\150\98\57\230\177\5", "\118\224\156\226\22\80\136\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\87\253\92\163\80\251\74\129\70\235\75\179\86\252\80\139\71", "\224\34\142\57")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\162\209\201\122\255\90\29", "\110\190\199\165\189\19\145\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\248\114\192\138\202\215\238\101\231\141\211\210\238\69\225\140\207\206\238\120\253\152", "\167\186\139\23\136\235")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\176\156\25\19\187\143\30", "\109\122\213\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\228\167\24\239\250\175\53\252\248\164\7\252\246\182\56", "\80\142\151\194")];
				v131 = 2;
			end
			if ((2497 == 2497) and (v131 == 2)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\195\99\88\10\200\112\95", "\44\99\166\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\228\44\28\38\160\123\250\44\56\39", "\196\28\151\73\86\83")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\6\61\4\139\86\31\101", "\22\147\99\73\112\226\56\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\102\231\212\155\189\123\229\252\131\191\66\240\244\153\176", "\237\216\21\130\149")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\75\75\75\185\199\89\145", "\62\226\46\63\63\208\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\10\80\161\30\30\59\87\234\23\90\133\51\4\40\86\241", "\62\133\121\53\227\127\109\79")];
				v131 = 3;
			end
			if ((3901 == 3901) and (v131 == 0)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\53\26\70\211\165\124\140\21", "\235\102\127\50\167\204\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\178\240\2\82\43\94\166\240\49\87\29\88\168\240\47\64", "\78\48\193\149\67\36")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\3\27\148\12\72\62\25\147", "\33\80\126\224\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\249\187\6\230\80\233\187\16\193\88\196\169\14\201\89\254", "\60\140\200\99\164")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\180\241\16\50\171\137\243\23", "\194\231\148\100\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\95\196\128\249\198\85\73\194\177\247\220\79\67\207", "\168\38\44\161\195\150")];
				v131 = 1;
			end
			if ((201 < 415) and (v131 == 4)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\178\213\209\93\181\151", "\210\228\72\198\161\184\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\90\246\35\118\192\34\64\253\21\127", "\174\86\41\147\112\19")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\153\31\44\1\22\184", "\203\59\96\237\107\69\111\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\0\169\239\54\249\217\35\33\190\224\37\248\224\45\2\164\194\21", "\183\68\118\204\129\81\144")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\168\100\240\2\140\9\190", "\226\110\205\16\132\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\194\243\205\72\228\205\239\223\109\226\196\232\205\118\226\215\232\250\101", "\33\139\163\128\185")];
				v131 = 5;
			end
		end
	end
	local function v119()
		local v132 = 0;
		while true do
			if ((v132 == 6) or (133 == 1784)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\21\223\211\130\137\241\59\253\7\224\243\143\180\227\29\201", "\85\153\116\166\156\236\193\144")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\130\105\91\221\169\147\212\58\159\98\121\221\172\161\203\29\189", "\184\85\237\27\63\178\207\212")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\139\161\87\24\142\170\67\4\129\148\86\4\147\161\71\31\142\171\74\45\136\167\81\24\175\148", "\36\107\231\196")];
				v132 = 7;
			end
			if ((v132 == 5) or (7 >= 310)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\67\58\172\49\97\228\0\30\81\11\147", "\110\122\34\67\195\95\41\133")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\88\215\25\46\184\144\91\202\15\56\150\135", "\222\215\55\165\125\65")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\130\12\203\117\114\170\140\17\198\124\68\172\141\13\218\124\121\176\153\45\254", "\22\197\234\101\174\25")];
				v132 = 6;
			end
			if ((4992 > 286) and (v132 == 1)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\116\160\234\204\70\118\167", "\165\40\17\212\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\202\13\23\47\243\208\6\54\21\237\208\13\63\34", "\70\133\185\104\83")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\80\62\192\10\66\87", "\169\100\37\36\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\148\167\119\21\134\176\84\9\134\172\95\6\166\172\83\9\130\172\68\43\142\172\87\19", "\48\96\231\194")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\95\26\57\16\214\168\144", "\227\168\58\110\77\121\184\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\47\186\108\176\194\94\171\83\61\177\68\162", "\197\27\92\223\32\209\187\17")];
				v132 = 2;
			end
			if ((v132 == 3) or (2561 == 3893)) then
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\202\134\233\33\248\194\214\133\249\34\229\212\192\165\209\45\255\213", "\138\166\185\227\190\78")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\43\188\20\181\7\213\43\176\56\190\45\192\8\171\57\173\7\197\44\176\57\183\36\201\59\172\37", "\98\166\88\217\86\217")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\154\90\32\0\232\201\154\86\12\11\194\220\186\94\1\30\228\220\128\92\7\42\226\217\156\76", "\141\186\233\63\98\108")];
				v132 = 4;
			end
			if ((4362 >= 1421) and (v132 == 2)) then
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\194\164\186\182\150\134\222\167\170\181\139\144\200\145\129\184\157\135\195", "\228\226\177\193\237\217")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\191\131\111\27\165\131\80\23\163\128\72\27\169\180\85\20\164\146\89\28\185\149", "\60\115\204\230")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\65\103\3\31\79\77\87\90\92\7\61\74\71\94\91\119\19\32", "\24\52\20\102\83\46\52")];
				v132 = 3;
			end
			if ((75 <= 3546) and (v132 == 7)) then
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\161\56\96\26\164\51\116\6\171\14\114\10\191\52\117\0\174\56\85\6\174\40\96\33\157", "\19\105\205\93")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\186\216\196\237\163\206\192\192\188\206\245\193\183\194\207\221\152\194\213\198\142\205\199\194\166\200\213\203\171", "\174\207\171\161")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\26\227\59\35\27\226\3\42\46\234\3\62\16\209\5\56\1\199\10\42\5\239\15\56\12\226", "\108\76\105\134")];
				break;
			end
			if ((2680 <= 3418) and (v132 == 0)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\80\96\28\70\91\115\27", "\104\47\53\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\95\132\46\185\13\182\71\132", "\111\195\44\225\124\220")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\20\103\162\165\223\85", "\203\184\38\96\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\96\124\105\207\52\126\124\83\193\63\89\108\82\218\48\112\124", "\174\89\19\25\33")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\23\70\90\254\137\12\60", "\107\79\114\50\46\151\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\181\176\8\152\61\178\206\45\130\176\47\143\55\179\197\43", "\160\89\198\213\73\234\89\215")];
				v132 = 1;
			end
			if ((v132 == 4) or (4288 < 2876)) then
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\113\221\141\140\177\2\84\202\143\140\177\18\117\221\161\185", "\118\16\175\233\233\223")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\221\172\212\121\75\20\90\52\209\182\217\95\126", "\50\93\180\218\189\23\46\71")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\80\221\166\254\116\12\50\74\218\149\244\126\4\57\75\200\159\243\115\10\47\109\236", "\109\92\37\188\212\154\29")];
				v132 = 5;
			end
		end
	end
	local function v120()
		local v133 = 0;
		while true do
			if ((2462 >= 1147) and (v133 == 4)) then
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\237\37\222\4\217\171\35\239\36\200\24\211\144\40\237\39", "\226\77\140\75\186\104\188")];
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\216\119\14\157\123\91", "\70\216\189\22\98\210\52\24")];
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\58\25\232\214\16\59\204\201", "\132\153\95\120")] or 0;
				break;
			end
			if ((v133 == 3) or (4914 < 2480)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\80\192\86\246\87\59\228\76\202\89\255\107\3", "\151\56\165\55\154\35\83")] or 0;
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\112\40\175\238\130\171\38\217\97\32\172\233\164\156", "\118\182\21\73\195\135\236\204")] or 0;
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\163\206\198\52\41\138\155\172\178\198\197\51\9\140\166\166", "\203\195\198\175\170\93\71\237")] or "";
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\122\233\202\167\7\70\88\116\238\200\170\8\87\124\118", "\25\18\136\164\195\107\35")];
				v133 = 4;
			end
			if ((v133 == 2) or (1559 == 1240)) then
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\207\202\29\62\57\201\208\36\60\40\213\224\55", "\85\92\189\163\115")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\130\19\79\40\214\61\180\25\82\33\249\10", "\186\78\227\112\38\73")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\203\19\241\189\81\128\204\30\202\172\95\130\221", "\48\236\184\118\185\216")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\168\244\33\142\194\93\177\238\42\161\247\83\169\238\43\168", "\60\221\135\68\198\167")];
				v133 = 3;
			end
			if ((566 == 566) and (v133 == 0)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\186\229\201\210\49\117\117\162\186\236\210\229\11\117\123\168", "\24\195\211\130\161\166\99\16")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\40\17\23\27\50\232\54\17\37\0\52\245\21\17\7\7", "\64\157\70\101\114\105")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\94\72\189\209\185\55\60\68\115\182\207\178\21\36\89\72\189\207\162\49\56", "\66\76\48\60\216\163\203")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\36\71\73\164\191\63\67\88\130\165\56\86\95\190\162\38\87", "\214\205\74\51\44")];
				v133 = 1;
			end
			if ((3921 >= 3009) and (v133 == 1)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\175\190\190\51\31\53\163\175\187\48\21\2", "\115\113\198\205\206\86")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\128\195\62\57\161\23\161\143\214\61", "\85\212\233\176\78\92\205")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\166\33\215\82\54\228\190\33\247\83", "\95\138\213\68\131\32")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\106\225\106\45\122\237\89\32\106", "\56\76\25\132")];
				v133 = 2;
			end
		end
	end
	local function v121()
		local v134 = 0;
		local v135;
		while true do
			if ((2063 >= 1648) and (2 == v134)) then
				v101 = v15:IsTankingAoE(8) or v15:IsTanking(v17);
				if ((1066 >= 452) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((4974 >= 2655) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\89\174\39\103\135\49\126\153\91\169\32\117", "\235\26\220\82\20\230\85\27")]:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
						if (v25(v96.CrusaderAura) or (2721 <= 907)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\139\179\252\209\117\140\164\251\253\117\157\179\232", "\20\232\193\137\162");
						end
					end
				end
				if ((4437 >= 3031) and (v15:AffectingCombat() or v78)) then
					local v202 = 0;
					local v203;
					while true do
						if ((v202 == 1) or (4470 < 2949)) then
							if (v135 or (1580 == 2426)) then
								return v135;
							end
							break;
						end
						if ((v202 == 0) or (3711 == 503)) then
							v203 = v78 and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\1\211\192\167\233\159\18\69\45\199\204\168\244", "\17\66\191\165\198\135\236\119")]:IsReady() and v33;
							v135 = v106.FocusUnit(v203, v98, 20, nil, 25);
							v202 = 1;
						end
					end
				end
				v135 = v106.FocusUnitWithDebuffFromList(v19[LUAOBFUSACTOR_DECRYPT_STR_0("\63\174\162\18\251\225\226", "\177\111\207\206\115\159\136\140")].FreedomDebuffList, 40, 25);
				if (v135 or (420 == 4318)) then
					return v135;
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\39\133\21\7\199\70\81\2\134\22\50\198\74\90\1\134\29", "\63\101\233\112\116\180\47")]:IsReady() and v106.UnitHasDebuffFromList(v14, v19[LUAOBFUSACTOR_DECRYPT_STR_0("\243\58\225\19\252\63\205", "\86\163\91\141\114\152")].FreedomDebuffList)) or (4158 <= 33)) then
					if (v25(v98.BlessingofFreedomFocus) or (99 > 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\7\113\96\41\90\5\115\76\53\85\52\114\97\63\86\15\123\126\122\80\4\121\113\59\71", "\90\51\107\20\19");
					end
				end
				v134 = 3;
			end
			if ((4341 == 4341) and (v134 == 0)) then
				v119();
				v118();
				v120();
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\133\189\9\42\251\223\179", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\12\33", "\164\128\99\66\137\159")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\134\238\185\12\140\250", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\188\162", "\144\217\211\199\127\232\147")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\32\57\47\217\64\17", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\220\84", "\95\183\184\39")];
				v134 = 1;
			end
			if ((255 <= 1596) and (4 == v134)) then
				if (v14 or (4433 < 1635)) then
					if (v78 or (4300 < 3244)) then
						local v211 = 0;
						while true do
							if ((v211 == 0) or (3534 > 4677)) then
								v135 = v110();
								if (v135 or (4859 < 2999)) then
									return v135;
								end
								break;
							end
						end
					end
				end
				v135 = v114();
				if ((4726 > 2407) and v135) then
					return v135;
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\31\190\234\63\32\171\250\51\34\181", "\90\77\219\142")]:IsCastable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\212\1\37\60\65\23\110\239\11\47", "\26\134\100\65\89\44\103")]:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or (1284 > 3669)) then
					if ((1117 < 2549) and v25(v98.RedemptionMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\230\52\38\169\225\247\57\44\170\177\238\63\54\183\244\236\38\38\182", "\196\145\131\80\67");
					end
				end
				if (v15:AffectingCombat() or (2851 > 4774)) then
					if ((1031 < 3848) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\55\190\18\13\10\235\27\163\21\1\23\230", "\136\126\208\102\104\120")]:IsCastable() and (v15:HolyPower() >= 3) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\81\132\218\70\189\81\56\66\107\131\193\77", "\49\24\234\174\35\207\50\93")]:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if ((1854 > 903) and v25(v98.IntercessionMouseover)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\37\252\233\141\99\15\247\238\155\120\3\252", "\17\108\146\157\232");
						end
					end
				end
				if ((4663 > 1860) and v106.TargetIsValid() and not v15:AffectingCombat() and v30) then
					local v204 = 0;
					while true do
						if ((v204 == 0) or (3053 <= 469)) then
							v135 = v115();
							if (v135 or (540 >= 1869)) then
								return v135;
							end
							break;
						end
					end
				end
				v134 = 5;
			end
			if ((3292 == 3292) and (v134 == 1)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\129\48\224\33\88\133\17", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\170\218\103\81\242", "\52\158\195\169\23")];
				if ((1038 <= 2645) and v15:IsDeadOrGhost()) then
					return;
				end
				v102 = v15:GetEnemiesInMeleeRange(10);
				v103 = v15:GetEnemiesInRange(30);
				if (v31 or (3230 < 2525)) then
					local v205 = 0;
					while true do
						if ((v205 == 0) or (2400 > 4083)) then
							v104 = #v102;
							v105 = #v103;
							break;
						end
					end
				else
					local v206 = 0;
					while true do
						if ((v206 == 0) or (2745 > 4359)) then
							v104 = 1;
							v105 = 1;
							break;
						end
					end
				end
				v100 = v15:ActiveMitigationNeeded();
				v134 = 2;
			end
			if ((172 <= 1810) and (v134 == 5)) then
				if (v106.TargetIsValid() or (492 >= 4959)) then
					local v207 = 0;
					while true do
						if ((v207 == 0) or (756 == 2072)) then
							if ((1605 <= 4664) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
								if ((1816 == 1816) and v15:AffectingCombat()) then
									if (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\98\205\0\232\61\171\78\208\7\228\32\166", "\200\43\163\116\141\79")]:IsCastable() or (621 > 3100)) then
										if (v25(v96.Intercession, not v17:IsInRange(30), true) or (1157 >= 4225)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\182\56\41\134\162\247\230\172\37\52\140\190", "\131\223\86\93\227\208\148");
										end
									end
								elseif (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\209\64\178\179\16\165\247\76\185\184", "\213\131\37\214\214\125")]:IsCastable() or (4986 == 4138)) then
									if (v25(v96.Redemption, not v17:IsInRange(30), true) or (2033 <= 224)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\52\46\33\186\236\54\63\44\176\239", "\129\70\75\69\223");
									end
								end
							end
							if ((v106.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) or (1223 == 2011)) then
								local v212 = 0;
								while true do
									if ((4827 > 4695) and (1 == v212)) then
										if ((3710 > 3065) and v85 and ((v32 and v86) or not v86) and v17:IsInRange(8)) then
											local v215 = 0;
											while true do
												if ((2135 <= 2696) and (0 == v215)) then
													v135 = v112();
													if (v135 or (1742 > 4397)) then
														return v135;
													end
													break;
												end
											end
										end
										v135 = v117();
										v212 = 2;
									end
									if ((3900 >= 1904) and (v212 == 0)) then
										if (v101 or (1724 == 909)) then
											local v216 = 0;
											while true do
												if ((1282 < 1421) and (0 == v216)) then
													v135 = v113();
													if ((4876 >= 4337) and v135) then
														return v135;
													end
													break;
												end
											end
										end
										if ((4005 >= 3005) and (v84 < FightRemains)) then
											local v217 = 0;
											while true do
												if ((v217 == 0) or (4781 <= 4448)) then
													v135 = v116();
													if ((1317 > 172) and v135) then
														return v135;
													end
													break;
												end
											end
										end
										v212 = 1;
									end
									if ((4791 == 4791) and (v212 == 2)) then
										if ((3988 > 1261) and v135) then
											return v135;
										end
										if ((2240 <= 3616) and v25(v96.Pool)) then
											return "Wait/Pool Resources";
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v134 == 3) or (3988 < 3947)) then
				if ((4644 == 4644) and (v106.TargetIsValid() or v15:AffectingCombat())) then
					local v208 = 0;
					while true do
						if ((1323 > 1271) and (1 == v208)) then
							if ((1619 > 1457) and (FightRemains == 11111)) then
								FightRemains = v10.FightRemains(v102, false);
							end
							break;
						end
						if ((0 == v208) or (2860 < 1808)) then
							BossFightRemains = v10.BossFightRemains(nil, true);
							FightRemains = BossFightRemains;
							v208 = 1;
						end
					end
				end
				if (not v15:AffectingCombat() or (739 >= 1809)) then
					if ((1539 <= 4148) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\169\245\147\224\41\132\255\139\206\40\159\241", "\93\237\144\229\143")]:IsCastable() and (v109())) then
						if (v25(v96.DevotionAura) or (434 > 3050)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\17\243\230\22\31\79\26\248\207\24\30\84\20", "\38\117\150\144\121\107");
						end
					end
				end
				if (v79 or (3054 < 1683)) then
					local v209 = 0;
					while true do
						if ((47 < 2706) and (v209 == 0)) then
							if ((1519 >= 580) and v75) then
								local v213 = 0;
								while true do
									if ((v213 == 0) or (3110 == 4177)) then
										v135 = v106.HandleAfflicted(v96.CleanseToxins, v98.CleanseToxinsMouseover, 40);
										if ((4200 > 2076) and v135) then
											return v135;
										end
										break;
									end
								end
							end
							if ((v15:BuffUp(v96.ShiningLightFreeBuff) and v76) or (601 >= 2346)) then
								local v214 = 0;
								while true do
									if ((3970 <= 4354) and (v214 == 0)) then
										v135 = v106.HandleAfflicted(v96.WordofGlory, v98.WordofGloryMouseover, 40, true);
										if (v135 or (1542 < 208)) then
											return v135;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if ((1612 <= 2926) and v80) then
					local v210 = 0;
					while true do
						if ((0 == v210) or (2006 <= 540)) then
							v135 = v106.HandleIncorporeal(v96.Repentance, v98.RepentanceMouseOver, 30, true);
							if (v135 or (2412 == 4677)) then
								return v135;
							end
							v210 = 1;
						end
						if ((v210 == 1) or (4897 <= 1972)) then
							v135 = v106.HandleIncorporeal(v96.TurnEvil, v98.TurnEvilMouseOver, 30, true);
							if ((3101 <= 3584) and v135) then
								return v135;
							end
							break;
						end
					end
				end
				v135 = v111();
				if (v135 or (1568 >= 4543)) then
					return v135;
				end
				v134 = 4;
			end
		end
	end
	local function v122()
		local v136 = 0;
		while true do
			if ((4258 >= 1841) and (v136 == 0)) then
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\118\217\252\253\121\236\82\194\252\231\60\223\71\199\242\237\117\225\6\201\234\169\89\255\79\200\189\169\79\250\86\219\252\251\104\234\66\139\241\240\60\247\109\202\253\236\104\224", "\143\38\171\147\137\28"));
				v107();
				break;
			end
		end
	end
	v21.SetAPL(66, v121, v122);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\245\146\176\235\60\211\213\220\131\189\250\13\220\228\194\141\173\246\0\247\221\223\140\247\255\22\226", "\180\176\226\217\147\99\131")]();

