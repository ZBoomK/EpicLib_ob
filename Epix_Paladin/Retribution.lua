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
		if ((2624 < 4557) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3131 > 3542)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((2577 >= 1578) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\198\18\208\199\210\43\217\137\194\10\195\202\217\48\242\178\200\16\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v28 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\197\39\46", "\156\168\78\64\224\212\121")];
	local v29 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\10\239\189", "\174\103\142\197")];
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v95 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\117\39\82\53\42\80\235", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\210\235\78\205\203\224\89", "\60\180\164\142")];
	local v96 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\104\95\9\40\35\228\28", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\236\207\214\177\235\206\208\177\230\213", "\164\216\137\187")];
	local v97 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\226\231\61\179\162\247\5", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\10\11\150\212\163\58\27\150\207\165\54", "\202\88\110\226\166")];
	local v98 = {};
	local function v99()
		if ((4103 <= 4571) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\224\3\135\246\196\208\10\182\248\210\202\1\145", "\170\163\111\226\151")]:IsAvailable()) then
			v95[LUAOBFUSACTOR_DECRYPT_STR_0("\53\57\161\40\75\59\37\16\50\190\61\106\50\43\4\54\180\43", "\73\113\80\210\88\46\87")] = v13.MergeTable(v95.DispellableDiseaseDebuffs, v95.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v99();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\160\15\249\59\209\164\19\253\62\198\184\9\255\45\212\177\9\238\59\198\173\5\247\51\211\168\3\227\45\196\169\13\227\53\194\165", "\135\225\76\173\114"));
	local v100 = v24[LUAOBFUSACTOR_DECRYPT_STR_0("\42\236\180\177\168\180\169", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\216\4\226\113\244\184\201\25\255\118", "\150\205\189\112\144\24")];
	local v101;
	local v102;
	local v103 = 11111;
	local v104 = 11111;
	local v105;
	local v106 = 0;
	local v107 = 0;
	local v108;
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((v124 == 0) or (1495 == 4787)) then
				v103 = 11111;
				v104 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\21\168\158\117\33\186\46\34\0\163\154\98\59\173\63\49\7\168\154\104", "\112\69\228\223\44\100\232\113"));
	local function v109()
		local v125 = 0;
		local v126;
		local v127;
		while true do
			if ((v125 == 0) or (310 > 4434)) then
				v126 = v15:GCDRemains();
				v127 = v28(v96[LUAOBFUSACTOR_DECRYPT_STR_0("\247\13\18\192\183\120\131\198\44\19\193\191\119\131", "\230\180\127\103\179\214\28")]:CooldownRemains(), v96[LUAOBFUSACTOR_DECRYPT_STR_0("\174\9\94\66\225\78\230\166\16\76\82\237\66\229", "\128\236\101\63\38\132\33")]:CooldownRemains(), v96[LUAOBFUSACTOR_DECRYPT_STR_0("\134\188\21\67\187\238\193\184", "\175\204\201\113\36\214\139")]:CooldownRemains(), (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\111\205\56\209\1\85\195\51\235\22\70\216\61", "\100\39\172\85\188")]:IsUsable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\133\121\180\141\54\191\119\191\183\33\172\108\177", "\83\205\24\217\224")]:CooldownRemains()) or 10, v96[LUAOBFUSACTOR_DECRYPT_STR_0("\209\196\198\56\233\195\236\46\238\192\222", "\93\134\165\173")]:CooldownRemains());
				v125 = 1;
			end
			if ((2168 <= 4360) and (1 == v125)) then
				if ((994 == 994) and (v126 > v127)) then
					return v126;
				end
				return v127;
			end
		end
	end
	local function v110()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v111()
		if ((1655 > 401) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\157\254\196\195\52\221\183\74\177\234\200\204\41", "\30\222\146\161\162\90\174\210")]:IsReady() and v34 and v95.DispellableFriendlyUnit(25)) then
			if ((3063 <= 3426) and v25(v100.CleanseToxinsFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\230\66\117\11\235\93\117\53\246\94\121\24\236\90\48\14\236\93\96\15\233", "\106\133\46\16");
			end
		end
	end
	local function v112()
		if ((1459 > 764) and v92 and (v15:HealthPercentage() <= v93)) then
			if (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\126\44\114\239\82\79\94\12\122\251\82\84", "\32\56\64\19\156\58")]:IsReady() or (641 > 4334)) then
				if ((3399 >= 2260) and v25(v96.FlashofLight)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\92\196\228\69\82\205\143\92\247\233\95\93\250\148\26\192\224\87\86\178\143\85\203", "\224\58\168\133\54\58\146");
				end
			end
		end
	end
	local function v113()
		local v128 = 0;
		while true do
			if ((v128 == 0) or (393 >= 4242)) then
				if ((989 < 4859) and (not v14 or not v14:Exists() or not v14:IsInRange(30))) then
					return;
				end
				if (v14 or (4795 < 949)) then
					local v194 = 0;
					while true do
						if ((3842 == 3842) and (1 == v194)) then
							if ((1747 <= 3601) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\159\213\37\95\174\208\46\75\178\223\19\77\190\203\41\74\180\218\37", "\44\221\185\64")]:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v72)) then
								if (v25(v100.BlessingofSacrificeFocus) or (804 > 4359)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\3\235\77\76\96\8\233\79\96\124\7\216\91\94\112\19\238\78\86\112\4\167\76\90\117\4\233\91\86\101\4\167\78\80\112\20\244", "\19\97\135\40\63");
								end
							end
							if ((4670 >= 3623) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\140\80\54\40\60\56\160\91\60\61\31\35\161\72\54\56\59\56\161\82", "\81\206\60\83\91\79")]:IsCastable() and v64 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) then
								if ((2065 < 2544) and v25(v100.BlessingofProtectionFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\76\167\213\97\60\202\67\163\113\164\214\77\63\209\66\176\75\168\196\123\32\205\13\160\75\173\213\124\60\202\91\161\14\173\223\113\58\208", "\196\46\203\176\18\79\163\45");
								end
							end
							break;
						end
						if ((1311 <= 3359) and (v194 == 0)) then
							if ((2717 <= 3156) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\110\89\89\249\122\128\160\7\86\68\82", "\107\57\54\43\157\21\230\231")]:IsReady() and v63 and (v14:HealthPercentage() <= v70)) then
								if ((1081 < 4524) and v25(v100.WordofGloryFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\204\132\3\241\134\211\201\228\140\29\250\171\197\143\223\142\23\240\183\207\198\205\142\81\243\182\223\218\200", "\175\187\235\113\149\217\188");
								end
							end
							if ((440 >= 71) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\16\174\152\67\237\81\121\50\171\146", "\24\92\207\225\44\131\25")]:IsCastable() and v62 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v69)) then
								if ((4934 > 2607) and v25(v100.LayonHandsFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\71\210\161\115\20\115\116\219\185\66\31\110\11\215\189\74\30\115\88\218\174\73\91\123\68\208\173\95", "\29\43\179\216\44\123");
								end
							end
							v194 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v129 = 0;
		while true do
			if ((v129 == 0) or (1400 > 3116)) then
				v30 = v95.HandleTopTrinket(v98, v33, 40, nil);
				if ((525 < 1662) and v30) then
					return v30;
				end
				v129 = 1;
			end
			if ((v129 == 1) or (876 > 2550)) then
				v30 = v95.HandleBottomTrinket(v98, v33, 40, nil);
				if ((219 <= 2456) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v115()
		local v130 = 0;
		while true do
			if ((v130 == 1) or (4219 == 1150)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\249\22\250\29\54\233\26\230\24\51\220\11", "\90\191\127\148\124")]:IsAvailable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\94\142\32\22\116\177\43\5\124\142\45\3", "\119\24\231\78")]:IsReady() and v48 and (v106 >= 4)) or (2989 <= 222)) then
					if ((2258 > 1241) and v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\36\171\75\208\0\7\135\63\161\67\223\84\81\146\63\160\73\211\77\19\131\57\229\25", "\113\226\77\197\42\188\32");
					end
				end
				if ((41 < 4259) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\14\19\249\165\54\23\230\166\12\19\230\177\51\21\224", "\213\90\118\148")]:IsReady() and v48 and (v106 >= 4)) then
					if (v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict)) or (1930 < 56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\43\185\70\65\90\60\167\22\91\94\60\176\95\78\79\110\164\68\72\88\33\185\84\76\79\110\224", "\45\59\78\212\54");
					end
				end
				v130 = 2;
			end
			if ((3333 == 3333) and (v130 == 2)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\50\90\130\143\131\33\171\218\5\69\151\130\133\43", "\144\112\54\227\235\230\78\205")]:IsCastable() and v35) or (2225 == 20)) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (872 >= 3092)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\36\14\248\213\100\188\46\48\246\197\72\167\33\12\249\144\75\161\45\12\243\221\89\178\60\79\169", "\59\211\72\111\156\176");
					end
				end
				if ((4404 >= 3252) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\100\146\231\42\67\130\237\57", "\77\46\231\131")]:IsCastable() and v43) then
					if ((1107 > 796) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\65\178\71\183\81\184\84\250\68\164\69\185\91\187\66\187\64\246\22", "\32\218\52\214");
					end
				end
				v130 = 3;
			end
			if ((959 == 959) and (v130 == 0)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\139\42\119\27\40\255\224\190\20\123\16\35\254\238\182\33\123", "\143\216\66\30\126\68\155")]:IsCastable() and v52 and ((v33 and v56) or not v56)) or (245 >= 2204)) then
					if ((3162 >= 2069) and v25(v96.ShieldofVengeance)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\185\192\4\206\201\167\232\238\172\247\27\206\203\164\210\224\164\203\8\139\213\177\210\226\165\197\15\202\209\227\134", "\129\202\168\109\171\165\195\183");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\8\77\36\204\215\23\231\48\75\1\221\208\19\227\35\86\52\221", "\134\66\56\87\184\190\116")]:IsAvailable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\22\36\26\175\16\232\32\39\47\7\12\181\30\238\32\59\63\52", "\85\92\81\105\219\121\139\65")]:IsReady() and v44 and (v106 >= 4)) or (306 > 3081)) then
					if (v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance)) or (3513 < 2706)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\166\67\70\104\214\254\178\66\86\60\201\248\189\87\64\125\209\254\182\16\85\110\218\254\188\93\71\125\203\189\225", "\191\157\211\48\37\28");
					end
				end
				v130 = 1;
			end
			if ((2978 < 3639) and (v130 == 3)) then
				if ((3682 >= 2888) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\102\22\60\165\244\162\74\92\121\5\48\188\249", "\58\46\119\81\200\145\208\37")]:IsReady() and v42) then
					if ((149 < 479) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\141\61\161\172\175\9\36\138\15\187\187\188\34\35\204\32\190\172\190\57\38\142\49\184\233\234", "\86\75\236\80\204\201\221");
					end
				end
				if ((1020 >= 567) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\81\83\98\150\255\143\119\83\68\145\236\130\121\68", "\235\18\33\23\229\158")]:IsCastable() and v37) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or (733 > 2469)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\168\212\168\81\190\196\169\111\169\213\169\89\177\196\251\64\168\196\184\95\183\195\186\68\250\144\227\0", "\219\48\218\161");
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v131 = 0;
		local v132;
		while true do
			if ((2497 == 2497) and (0 == v131)) then
				v132 = v95.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15.BuffStack(v96.Crusade) == 10)) or (v104 < 25));
				if ((3901 == 3901) and v132) then
					return v132;
				end
				v131 = 1;
			end
			if ((201 < 415) and (v131 == 1)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\200\120\123\65\207\92\202\241\117\123\68\222\65\244", "\128\132\17\28\41\187\47")]:IsCastable() and v85 and ((v86 and v33) or not v86)) or (133 == 1784)) then
					if (v25(v96.LightsJudgment, not v17:IsInRange(40)) or (7 >= 310)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\59\1\50\73\18\13\12\47\89\6\63\3\52\73\65\49\9\53\81\5\61\17\52\78\65\102", "\61\97\82\102\90");
					end
				end
				if ((4992 > 286) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\138\39\185\78\197\91\17\6\168", "\105\204\78\203\43\167\55\126")]:IsCastable() and v85 and ((v86 and v33) or not v86) and (v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) == 10)))) then
					if (v25(v96.Fireblood, not v17:IsInRange(10)) or (2561 == 3893)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\163\49\27\17\8\200\94\161\234\32\17\28\8\195\94\178\164\48\94\69", "\49\197\202\67\126\115\100\167");
					end
				end
				v131 = 2;
			end
			if ((4362 >= 1421) and (v131 == 2)) then
				if ((75 <= 3546) and v83 and ((v33 and v84) or not v84) and v17:IsInRange(8)) then
					local v195 = 0;
					while true do
						if ((2680 <= 3418) and (v195 == 0)) then
							v30 = v114();
							if (v30 or (4288 < 2876)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((2462 >= 1147) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\4\83\214\44\140\82\81\49\109\218\39\135\83\95\57\88\218", "\62\87\59\191\73\224\54")]:IsCastable() and v52 and ((v33 and v56) or not v56) and (v104 > 15) and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\194\26\255\202\242\22\243\198\233\49\255\199\243\7\244\202\226", "\169\135\98\154")]:IsAvailable() or v17:DebuffDown(v96.ExecutionSentence))) then
					if (v25(v96.ShieldofVengeance) or (4914 < 2480)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\127\45\81\241\55\247\196\113\27\66\248\61\207\206\118\42\87\248\115\203\196\120\40\80\242\36\198\216\55\117\4", "\168\171\23\68\52\157\83");
					end
				end
				v131 = 3;
			end
			if ((v131 == 4) or (1559 == 1240)) then
				if ((566 == 566) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\222\223\1\198\79\179\248", "\215\157\173\116\181\46")]:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() >= 5)))) then
					if ((3921 >= 3009) and v25(v96.Crusade, not v17:IsInRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\166\158\225\219\49\177\203\241\213\58\184\143\253\205\59\167\203\163\142", "\186\85\212\235\146");
					end
				end
				if ((2063 >= 1648) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\228\136\24\255\53\220\93\193\138\25\240\48\224\95", "\56\162\225\118\158\89\142")]:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v106 >= 4) and (v10.CombatTime() < 8)) or ((v106 >= 3) and (v10.CombatTime() >= 8)) or ((v106 >= 2) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\120\12\214\166\44\221\125\16\216\166\46\209\93\23\217", "\184\60\101\160\207\66")]:IsAvailable())) and ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\16\148\121\178\54\139\114\187\6\144\125\168\57", "\220\81\226\28")]:CooldownRemains() > 10) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\48\199\151\232\235\195\22", "\167\115\181\226\155\138")]:CooldownDown() and (v15:BuffDown(v96.CrusadeBuff) or (v15:BuffStack(v96.CrusadeBuff) >= 10)))) and ((v105 > 0) or (v106 == 5) or ((v106 >= 2) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\198\43\241\85\117\116\231\247\58\238\80\114\112\212\251", "\166\130\66\135\60\27\17")]:IsAvailable()))) then
					local v196 = 0;
					while true do
						if ((1066 >= 452) and (v196 == 0)) then
							if ((4974 >= 2655) and (v94 == LUAOBFUSACTOR_DECRYPT_STR_0("\84\70\207\108\53\86", "\80\36\42\174\21"))) then
								if (v25(v100.FinalReckoningPlayer, not v17:IsInRange(10)) or (2721 <= 907)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\72\25\57\123\66\47\37\127\77\27\56\116\71\30\48\58\77\31\56\118\74\31\32\116\93\80\102\34", "\26\46\112\87");
								end
							end
							if ((4437 >= 3031) and (v94 == LUAOBFUSACTOR_DECRYPT_STR_0("\186\54\185\103\176\173", "\212\217\67\203\20\223\223\37"))) then
								if (v25(v100.FinalReckoningCursor, not v17:IsInRange(20)) or (4470 < 2949)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\188\132\166\211\182\178\186\215\185\134\167\220\179\131\175\146\185\130\167\222\190\130\191\220\169\205\249\138", "\178\218\237\200");
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == 3) or (1580 == 2426)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\209\105\240\174\48\57\142\251\127\198\168\43\57\130\250\114\240", "\231\148\17\149\205\69\77")]:IsCastable() and v41 and ((v15:BuffDown(v96.CrusadeBuff) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\163\181\210\232\86\251\133", "\159\224\199\167\155\55")]:CooldownRemains() > 15)) or (v15:BuffStack(v96.CrusadeBuff) == 10) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\214\229\57\220\240\250\50\213\192\225\61\198\255", "\178\151\147\92")]:CooldownRemains() < 0.75) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\173\235\73\60\21\69\116\139\202\94\51\6\68", "\26\236\157\44\82\114\44")]:CooldownRemains() > 15)) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() > 5)) or ((v106 >= 2) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\14\39\195\82\36\43\244\78\50\39\217\82\43\60\204", "\59\74\78\181")]:IsAvailable())) and (((v104 > 8) and not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\0\201\95\89\166\49\216\85\84\182\55\194\109\83\191\41", "\211\69\177\58\58")]:IsAvailable()) or (v104 > 12))) or (3711 == 503)) then
					if (v25(v96.ExecutionSentence, not v17:IsSpellInRange(v96.ExecutionSentence)) or (420 == 4318)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\253\124\246\252\223\190\234\119\202\250\206\185\241\124\251\234\206\247\230\118\250\229\207\184\242\119\230\169\154\225", "\171\215\133\25\149\137");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\192\222\55\244\232\57\242\69\214\218\51\238\231", "\34\129\168\82\154\143\80\156")]:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() > 5)) or ((v106 >= 2) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\161\187\37\2\70\75\168\144\170\58\7\65\79\155\156", "\233\229\210\83\107\40\46")]:IsAvailable() and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\228\90\55\213\16\213\75\61\216\54\196\76\38\211\11\194\71", "\101\161\34\82\182")]:CooldownUp() or v96[LUAOBFUSACTOR_DECRYPT_STR_0("\206\4\87\255\215\208\135\45\227\2\87\247\213\229", "\78\136\109\57\158\187\130\226")]:CooldownUp())))) or (4158 <= 33)) then
					if (v25(v96.AvengingWrath, not v17:IsInRange(10)) or (99 > 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\41\252\255\57\54\247\246\1\40\235\240\42\55\185\242\49\48\245\245\49\40\247\226\126\110\171", "\145\94\95\153");
					end
				end
				v131 = 4;
			end
		end
	end
	local function v117()
		local v133 = 0;
		while true do
			if ((4341 == 4341) and (v133 == 0)) then
				v108 = ((v102 >= 3) or ((v102 >= 2) and not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\146\188\240\217\184\176\199\194\180\188\242\213\164", "\176\214\213\134")]:IsAvailable()) or v15:BuffUp(v96.EmpyreanPowerBuff)) and v15:BuffDown(v96.EmpyreanLegacyBuff) and not (v15:BuffUp(v96.DivineArbiterBuff) and (v15:BuffStack(v96.DivineArbiterBuff) > 24));
				if ((255 <= 1596) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\208\164\160\221\166\83\106\224\162\164\217", "\57\148\205\214\180\200\54")]:IsReady() and v39 and v108 and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\49\239\32\39\119\22\248", "\22\114\157\85\84")]:IsAvailable() or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\231\217\6\215\92\242\173", "\200\164\171\115\164\61\150")]:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) then
					if (v25(v96.DivineStorm, not v17:IsInRange(10)) or (4433 < 1635)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\253\21\76\141\187\203\16\81\140\172\249\67\67\138\176\253\16\77\134\172\231\67\23", "\227\222\148\99\37");
					end
				end
				v133 = 1;
			end
			if ((v133 == 1) or (4300 < 3244)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\25\71\65\226\240\48\83\64\229\207\54\92\85\243\248\61\81\87", "\153\83\50\50\150")]:IsReady() and v44 and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\126\100\102\15\114\175\72", "\45\61\22\19\124\19\203")]:IsAvailable() or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\226\0\24\230\3\116\188", "\217\161\114\109\149\98\16")]:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) or (3534 > 4677)) then
					if (v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance)) or (4859 < 2999)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\53\43\104\181\119\19\50\43\67\170\113\28\39\61\125\178\119\23\96\62\117\178\125\1\40\61\110\175\52\70", "\20\114\64\88\28\220");
					end
				end
				if ((4726 > 2407) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\23\8\220\181\244\230\184\35\5\219\183\236", "\221\81\97\178\212\152\176")]:IsAvailable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\235\238\19\250\22\251\226\15\255\19\206\243", "\122\173\135\125\155")]:IsCastable() and v48 and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\167\211\21\170\62\53\205", "\168\228\161\96\217\95\81")]:IsAvailable() or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\248\195\59\79\46\83\222", "\55\187\177\78\60\79")]:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) then
					if (v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict)) or (1284 > 3669)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\199\81\234\74\143\150\40\220\91\226\69\219\192\43\199\81\226\85\199\133\63\221\31\189", "\224\77\174\63\139\38\175");
					end
				end
				v133 = 2;
			end
			if ((1117 < 2549) and (v133 == 2)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\176\68\85\62\136\64\74\61\178\68\74\42\141\66\76", "\78\228\33\56")]:IsReady() and v48 and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\237\108\167\16\132\202\123", "\229\174\30\210\99")]:IsAvailable() or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\56\255\147\66\236\57\60", "\89\123\141\230\49\141\93")]:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) or (2851 > 4774)) then
					if ((1031 < 3848) and v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\116\251\28\28\75\225\98\182\26\21\88\247\120\245\24\80\76\250\127\255\31\24\79\225\98\182\84", "\42\147\17\150\108\112");
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v134 = 0;
		while true do
			if ((1854 > 903) and (3 == v134)) then
				if ((4663 > 1860) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\58\1\54\242\219\171\172\4", "\194\112\116\82\149\182\206")]:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= 3) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\27\167\89\22\196\238\11\42\187\102\13\196\229\3\60\166\88", "\110\89\200\44\120\160\130")]:IsAvailable())) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (3053 <= 469)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\214\79\65\78\79\53\89\235\196\78\72\70\88\58\89\164\209\88\6\17\26", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((v17:HealthPercentage() <= 20) or v15:BuffUp(v96.AvengingWrathBuff) or v15:BuffUp(v96.CrusadeBuff) or v15:BuffUp(v96.EmpyreanPowerBuff) or (540 >= 1869)) then
					local v197 = 0;
					while true do
						if ((3292 == 3292) and (v197 == 0)) then
							v30 = v117();
							if ((1038 <= 2645) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\241\138\210\48\130\170\70\211\145\213\44\137", "\52\178\229\188\67\231\201")]:IsCastable() and v36 and v17:DebuffDown(v96.ConsecrationDebuff) and (v102 >= 2)) or (3230 < 2525)) then
					if (v25(v96.Consecration, not v17:IsInRange(10)) or (2400 > 4083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\78\94\23\242\95\49\32\85\89\11\249\28\36\36\79\85\22\246\72\44\51\82\16\86\165", "\67\65\33\48\100\151\60");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\251\238\184\209\253\218\207\175\213\254\218\245", "\147\191\135\206\184")]:IsCastable() and v38 and (v102 >= 2)) or (2745 > 4359)) then
					if ((172 <= 1810) and v25(v96.DivineHammer, not v17:IsInRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\33\176\200\214\86\141\140\41\171\204\221\65\242\131\45\168\196\202\82\166\139\58\181\129\138\7", "\210\228\72\198\161\184\51");
					end
				end
				v134 = 4;
			end
			if ((v134 == 2) or (492 >= 4959)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\110\77\204\174\243\218\73\74\246\177\247\220\78", "\168\38\44\161\195\150")]:IsReady() and v42 and ((v102 < 2) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\162\240\135\101\35\237\178\53\136\253\143\102\57\231\184", "\118\224\156\226\22\80\136\214")]:IsAvailable() or v15:HasTier(30, 4)) and ((v106 <= 3) or (v17:HealthPercentage() > 20) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\116\239\87\135\87\239\75\132\81\195\86\141\71\224\77\149\79", "\224\34\142\57")]:IsAvailable())) or (756 == 2072)) then
					if ((1605 <= 4664) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\166\200\208\118\227\98\1\216\152\210\207\114\229\85\78\217\162\203\216\97\240\73\1\204\180\133\140\33", "\110\190\199\165\189\19\145\61");
					end
				end
				if ((1816 == 1816) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\238\238\122\248\135\198\200\216\123\233\152\207", "\167\186\139\23\136\235")]:IsReady() and v45 and ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\46\176\133\29\22\180\154\62\14\167\129\6\31", "\109\122\213\232")]:TimeSinceLastCast() + v107) < 4)) then
					if (v25(v96.TemplarSlash, not v17:IsSpellInRange(v96.TemplarSlash)) or (621 > 3100)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\242\175\32\226\246\176\15\253\251\163\35\230\183\165\53\224\242\176\49\250\248\176\35\174\166\246", "\80\142\151\194");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\41\211\115\75\14\195\121\88", "\44\99\166\23")]:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= 3) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\94\248\60\56\55\168\121\228\58\28\38\160\123\250\44\56\39", "\196\28\151\73\86\83")]:IsAvailable())) or (1157 >= 4225)) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (4986 == 4138)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\22\45\23\143\93\22\98\179\4\44\30\135\74\25\98\252\17\58\80\211\14", "\22\147\99\73\112\226\56\120");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\154\121\227\241\136\183\115\200\224\158\172\124\225\240", "\237\216\21\130\149")]:IsCastable() and v35 and ((v106 <= 3) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\170\65\83\70\146\197\95\134\75", "\62\226\46\63\63\208\169")]:IsAvailable())) or (2033 <= 224)) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (1223 == 2011)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\21\84\135\26\50\32\88\218\19\64\144\11\4\44\91\165\30\80\141\26\31\46\74\234\11\70\195\78\85", "\62\133\121\53\227\127\109\79");
					end
				end
				v134 = 3;
			end
			if ((4827 > 4695) and (v134 == 1)) then
				if ((3710 > 3065) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\1\7\44\82\134\130\204\63", "\162\75\114\72\53\235\231")]:IsReady() and v43 and v17:DebuffUp(v96.ExpurgationDebuff) and v15:BuffDown(v96.EchoesofWrathBuff) and v15:HasTier(31, 2)) then
					if ((2135 <= 2696) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\41\64\229\94\7\130\40\4\229\86\12\137\46\69\246\92\16\159\124\19", "\98\236\92\36\130\51");
					end
				end
				if (((v106 >= 3) and v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)) or (1742 > 4397)) then
					local v198 = 0;
					while true do
						if ((3900 >= 1904) and (v198 == 0)) then
							v30 = v117();
							if (v30 or (1724 == 909)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((1282 < 1421) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\144\28\1\170\73\169\167\3\168\24\31\178", "\80\196\121\108\218\37\200\213")]:IsReady() and v45 and ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\52\118\15\111\71\15\152\51\103\16\118\64\11", "\234\96\19\98\31\43\110")]:TimeSinceLastCast() + v107) < 4) and (v102 >= 2)) then
					if ((4876 >= 4337) and v25(v96.TemplarSlash, not v17:IsInRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\26\95\215\160\115\153\57\12\94\198\191\122\203\1\26\92\194\190\115\159\9\13\65\135\244", "\235\102\127\50\167\204\18");
					end
				end
				if ((4005 >= 3005) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\114\173\244\39\65\33\86\139\224\48\80\39\83\164", "\78\48\193\149\67\36")]:IsCastable() and v35 and ((v106 <= 3) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\24\17\140\1\99\60\31\132\29", "\33\80\126\224\120")]:IsAvailable()) and (((v102 >= 2) and not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\207\186\22\215\93\232\161\13\195\111\248\186\10\207\89\255", "\60\140\200\99\164")]:IsAvailable()) or (v102 >= 4))) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (4781 <= 4448)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\248\5\34\167\184\251\2\25\168\146\231\16\47\161\130\180\3\35\172\130\230\5\50\173\149\231\68\119\242", "\194\231\148\100\70");
					end
				end
				v134 = 2;
			end
			if ((1317 > 172) and (v134 == 6)) then
				if ((4791 == 4791) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\24\180\182\40\132\60\131\207\43\180\176\39\158", "\160\89\198\213\73\234\89\215")]:IsCastable() and ((v86 and v33) or not v86) and v85 and (v106 < 5) and (v82 < v104)) then
					if ((3988 > 1261) and v25(v96.ArcaneTorrent, not v17:IsInRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\99\183\255\203\77\78\160\241\215\90\116\186\234\133\79\116\186\251\215\73\101\187\236\214\8\35\236", "\165\40\17\212\158");
					end
				end
				if ((2240 <= 3616) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\198\214\6\32\35\230\203\9\39\47\234\215", "\70\133\185\104\83")]:IsCastable() and v36) then
					if (v25(v96.Consecration, not v17:IsInRange(10)) or (3988 < 3947)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\74\74\57\204\7\87\69\62\192\11\75\4\45\204\10\64\86\43\221\11\87\87\106\154\84", "\169\100\37\36\74");
					end
				end
				if ((4644 == 4644) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\36\142\180\89\14\130\138\81\13\138\167\66", "\48\96\231\194")]:IsCastable() and v38) then
					if ((1323 > 1271) and v25(v96.DivineHammer, not v17:IsInRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\83\24\36\23\221\144\139\201\87\3\40\11\152\168\134\198\95\28\44\13\215\189\144\136\9\92", "\227\168\58\110\77\121\184\207");
					end
				end
				break;
			end
			if ((1619 > 1457) and (v134 == 0)) then
				if ((v106 >= 5) or (v15:BuffUp(v96.EchoesofWrathBuff) and v15:HasTier(31, 4) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\44\180\56\108\230\236\6\168\42\76\243\250\6\173\40\108", "\136\111\198\77\31\135")]:IsAvailable()) or ((v17:DebuffUp(v96.JudgmentDebuff) or (v106 == 4)) and v15:BuffUp(v96.DivineResonanceBuff) and not v15:HasTier(31, 2)) or (2860 < 1808)) then
					local v199 = 0;
					while true do
						if ((0 == v199) or (739 >= 1809)) then
							v30 = v117();
							if ((1539 <= 4148) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\53\8\172\83\178\226\54\186\10\12\180", "\201\98\105\199\54\221\132\119")]:IsCastable() and v47 and (v106 <= 2) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\152\26\134\47\5\60\162\190\59\145\32\22\61", "\204\217\108\227\65\98\85")]:CooldownDown() or v96[LUAOBFUSACTOR_DECRYPT_STR_0("\125\209\224\246\45\196\91", "\160\62\163\149\133\76")]:CooldownDown()) and (not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\243\184\8\44\214\194\169\2\33\240\211\174\25\42\205\213\165", "\163\182\192\109\79")]:IsAvailable() or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\17\62\5\195\224\32\47\15\206\198\49\40\20\197\251\55\35", "\149\84\70\96\160")]:CooldownRemains() > 4) or (v104 < 8))) or (434 > 3050)) then
					if (v25(v96.WakeofAshes, not v17:IsInRange(10)) or (3054 < 1683)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\7\6\232\7\9\11\210\57\21\5\232\43\70\10\232\54\3\31\236\44\9\31\254\120\84", "\141\88\102\109");
					end
				end
				if ((47 < 2706) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\145\95\203\116\31\50\83\235\166\64\222\121\25\56", "\161\211\51\170\16\122\93\53")]:IsCastable() and v35 and not v17:DebuffUp(v96.ExpurgationDebuff) and (v106 <= 3) and v15:HasTier(31, 2)) then
					if ((1519 >= 580) and v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\162\179\44\254\145\189\46\196\164\167\59\239\167\177\45\187\169\183\38\254\188\179\60\244\188\161\104\175", "\72\155\206\210");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\98\115\66\7\61\67\78\91\2\63", "\83\38\26\52\110")]:IsCastable() and v40 and (v106 <= 2) and ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\121\1\34\72\95\30\41\65\111\5\38\82\80", "\38\56\119\71")]:CooldownRemains() > 15) or (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\208\253\77\197\36\82\246", "\54\147\143\56\182\69")]:CooldownRemains() > 15) or (v104 < 8))) or (3110 == 4177)) then
					if ((4200 > 2076) and v25(v96.DivineToll, not v17:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\136\233\64\209\211\190\235\70\211\218\193\248\76\209\211\147\254\93\208\196\146\191\31", "\191\182\225\159\41");
					end
				end
				v134 = 1;
			end
			if ((4 == v134) or (601 >= 2346)) then
				if ((3970 <= 4354) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\21\91\230\3\114\202\51\91\192\4\97\199\61\76", "\174\86\41\147\112\19")]:IsCastable() and v37 and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\120\18\152\24\36\11\20\185\104\20\159\2\46\10", "\203\59\96\237\107\69\111\113")]:ChargesFractional() >= 1.75) and ((v106 <= 2) or ((v106 <= 3) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\6\26\173\229\52\255\209\14\3\191\245\56\243\210", "\183\68\118\204\129\81\144")]:CooldownRemains() > (v107 * 2))) or ((v106 == 4) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\44\161\113\224\14\141\8\135\101\247\31\139\13\168", "\226\110\205\16\132\107")]:CooldownRemains() > (v107 * 2)) and (v96[LUAOBFUSACTOR_DECRYPT_STR_0("\193\214\228\222\76\238\205\244", "\33\139\163\128\185")]:CooldownRemains() > (v107 * 2))))) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or (1542 < 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\74\17\205\86\92\1\204\104\75\16\204\94\83\1\158\80\93\10\219\69\89\16\209\69\75\68\140\1", "\190\55\56\100");
					end
				end
				v30 = v117();
				if ((1612 <= 2926) and v30) then
					return v30;
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\98\170\49\14\31\226\225\101\163\61\13\27", "\147\54\207\92\126\115\131")]:IsReady() and v45) or (2006 <= 540)) then
					if (v25(v96.TemplarSlash, not v17:IsInRange(10)) or (2412 == 4677)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\52\56\109\1\127\31\14\38\113\12\109\5\113\50\120\3\123\31\48\33\114\31\109\77\99\109", "\30\109\81\85\29\109");
					end
				end
				v134 = 5;
			end
			if ((v134 == 5) or (4897 <= 1972)) then
				if ((3101 <= 3584) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\203\116\89\166\58\223\238\204\101\70\191\61\219", "\156\159\17\52\214\86\190")]:IsReady() and v46) then
					if (v25(v96.TemplarStrike, not v17:IsInRange(10)) or (1568 >= 4543)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\234\176\172\162\238\175\131\189\251\175\181\165\234\253\187\171\225\184\174\175\251\178\174\189\175\238\236", "\220\206\143\221");
					end
				end
				if ((4258 >= 1841) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\172\104\41\16\213\201\220\146", "\178\230\29\77\119\184\172")]:IsReady() and v43 and ((v106 <= 3) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\215\177\31\21\115\244\240\173\25\49\98\252\242\179\15\21\99", "\152\149\222\106\123\23")]:IsAvailable())) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (3052 >= 3554)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\51\242\68\184\216\40\226\3\178\216\40\243\81\180\201\41\228\80\245\142\116", "\213\189\70\150\35");
					end
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\103\84\121\5\74\71\123\14\120\71\117\28\71", "\104\47\53\20")]:IsReady() and v42 and ((v106 <= 3) or (v17:HealthPercentage() > 20) or not v96[LUAOBFUSACTOR_DECRYPT_STR_0("\149\77\143\27\169\14\177\72\146\49\179\2\166\66\149\9\177", "\111\195\44\225\124\220")]:IsAvailable())) or (2098 > 3885)) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or (2970 == 1172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\71\13\126\174\185\231\73\6\76\188\185\217\82\8\51\172\174\214\67\18\114\191\164\202\85\64\32\255", "\203\184\38\96\19\203");
					end
				end
				if ((3913 > 3881) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\26\97\108\82\207\61\118\107\114\218\43\122\114\68", "\174\89\19\25\33")]:IsCastable() and v37) then
					if ((4932 >= 1750) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\0\71\93\246\131\14\61\45\65\90\229\142\0\42\82\85\75\249\130\25\46\6\93\92\228\199\89\121", "\107\79\114\50\46\151\231");
					end
				end
				v134 = 6;
			end
		end
	end
	local function v119()
		local v135 = 0;
		while true do
			if ((v135 == 6) or (135 == 1669)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\12\242\24\37\7\225\31", "\108\76\105\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\211\180\239\201\226\203\182\214\220\234\209\185\214\199\255\205\146\197", "\174\139\165\209\129")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\182\246\213\207\13\119\107", "\24\195\211\130\161\166\99\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\17\252\63\82\18\67\52\224\56\91\53\98", "\118\38\99\137\76\51")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\35\17\6\0\46\250\53", "\64\157\70\101\114\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\70\161\169\226\28\114\173\164\232\31\78\161\169\228\39\73\188\175\192\52", "\112\32\200\199\131")];
				v135 = 7;
			end
			if ((4802 >= 109) and (v135 == 7)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\85\72\172\202\165\37\63", "\66\76\48\60\216\163\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\142\112\246\83\202\43\188\176\124\253\88\203\37\180\133\124\196\86\218\44\153\162", "\68\218\230\25\147\63\174")];
				break;
			end
			if ((v135 == 2) or (3911 > 4952)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\140\75\22\5\227\221\154", "\141\186\233\63\98\108")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\249\41\147\61\244\233\57\162\44\254\228\31\179\43\229\239\34\181\32", "\69\145\138\76\214")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\202\157\157\182\24\119\220", "\118\16\175\233\233\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\151\48\147\239\134\112\142\150\58\189\217\153\124\159\140", "\29\235\228\85\219\142\235")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\209\174\201\126\64\32\65", "\50\93\180\218\189\23\46\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\183\94\102\81\216\79\211\161\85\88", "\40\190\196\59\44\36\188")];
				v135 = 3;
			end
			if ((v135 == 0) or (265 > 4194)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\72\57\171\84\184\213\118\182", "\197\27\92\223\32\209\187\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\76\198\217\15\94\199\254\12\89\233\238\16\75\202\248\6", "\155\99\63\163")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\212\181\153\176\138\133\194", "\228\226\177\193\237\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\163\38\197\59\190\48\227\55\162\34\242\61\191\45", "\134\84\208\67")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\32\169\146\72\26\162\129\79", "\60\115\204\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\41\238\83\245\47\248\113\227\63\249\67\243\40\226\123\226", "\16\135\90\139")];
				v135 = 1;
			end
			if ((2655 <= 2908) and (v135 == 1)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\113\18\39\71\90\127\71", "\24\52\20\102\83\46\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\60\36\0\6\210\38\47\33\39\197\34\44\33\29", "\111\164\79\65\68")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\220\151\202\39\228\193\202", "\138\166\185\227\190\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\103\192\19\91\53\16\197\113\246\35\93\49\20", "\121\171\20\165\87\50\67")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\61\173\34\176\12\193\43", "\98\166\88\217\86\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\229\124\37\143\202\255\248\124\53\137\208\250", "\188\150\150\25\97\230")];
				v135 = 2;
			end
			if ((963 > 651) and (4 == v135)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\143\17\218\112\120\162\153", "\22\197\234\101\174\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\39\160\235\119\164\210\137\43\21\182\212\115\188", "\230\77\84\197\188\22\207\183")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\17\210\232\133\175\247\38", "\85\153\116\166\156\236\193\144")][LUAOBFUSACTOR_DECRYPT_STR_0("\177\243\72\133\225\18\160\233\78\167", "\96\196\128\45\211\132")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\6\136\111\75\219\161\179\203", "\184\85\237\27\63\178\207\212")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\74\12\126\30\92\7\88\1\87\14\104\26\88\29\87", "\63\104\57\105")];
				v135 = 5;
			end
			if ((v135 == 5) or (3503 <= 195)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\130\176\80\2\137\163\87", "\36\107\231\196")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\166\167\164\79\160\177\134\89\176", "\231\61\213\194")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\58\168\41\103\0\163\58\96", "\19\105\205\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\188\27\219\167\54\167\9\210\179\58\170\3\209\143\54\167\15", "\95\201\104\190\225")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\156\206\213\218\166\197\198\221", "\174\207\171\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\248\237\8\192\240\222\232\242\9\252\254\225\232\240\10\246\249\217\238\251", "\183\141\158\109\147\152")];
				v135 = 6;
			end
			if ((1382 <= 4404) and (v135 == 3)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\64\200\160\243\115\10\47", "\109\92\37\188\212\154\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\252\161\233\36\73\16\230\167\194\35\73\50\234\170\196\52\91\10\236\161", "\58\100\143\196\163\81")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\71\55\183\54\71\226\29", "\110\122\34\67\195\95\41\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\96\162\94\126\211\120\161\87\75\196\70\189\90\89\222", "\182\21\209\59\42")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\132\82\209\9\40\176\176\68", "\222\215\55\165\125\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\194\195\46\247\204\253\70\45\195\245\14\224\200\230\79", "\42\76\177\166\122\146\161\141")];
				v135 = 4;
			end
		end
	end
	local function v120()
		local v136 = 0;
		while true do
			if ((v136 == 5) or (4857 <= 767)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\58\12\240\240\49\31\247", "\132\153\95\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\190\11\62\228\211\174\182\189\8\30\246\217\178\184\180\7\46\242\252\175\178\167\29\5\199", "\192\209\210\110\77\151\186")] or 0;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\6\54\253\246\202\231\16", "\164\128\99\66\137\159")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\154\236\157\12\140\232\176\19\140\221\177\24\128\231\173\55\128\253\182\33\143\239\178\9\138\253\187\4", "\222\96\233\137")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\182\179\11\129\253\247\170", "\144\217\211\199\127\232\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\60\59\31\218\87\6\75\254\8\50\39\199\92\53\77\236\39\31\46\211\73\11\71\236\42\58", "\36\152\79\94\72\181\37\98")];
				v136 = 6;
			end
			if ((v136 == 2) or (4018 > 4021)) then
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\134\4\82\32\212\41\144", "\186\78\227\112\38\73")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\68\248\98\92\104\248\88\251\114\95\117\238\78\219\90\80\111\239", "\26\156\55\157\53\51")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\221\2\205\177\94\139\203", "\48\236\184\118\185\216")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\174\82\18\195\49\246\174\94\62\200\27\227\141\69\63\219\49\230\169\94\63\193\18\234\190\66\35", "\84\133\221\55\80\175")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\226\48\178\206\82\186\244", "\60\221\135\68\198\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\174\253\161\78\220\253\174\241\141\69\246\232\142\249\128\80\208\232\180\251\134\100\214\237\168\235", "\185\142\221\152\227\34")];
				v136 = 3;
			end
			if ((1 == v136) or (2270 == 1932)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\217\176\48\247\73\49\237\166", "\95\138\213\68\131\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\59\164\103\127\60\33\175\70\69\34\33\164\79\114", "\22\74\72\193\35")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\124\240\76\37\119\227\75", "\56\76\25\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\75\210\174\10\206\71\206\165\14\206\80\197\184", "\175\62\161\203\70")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\216\215\7\60\50\218\208", "\85\92\189\163\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\191\53\20\40\181\63\54\1\173\62\60\58\138\63\59\60\191", "\88\73\204\80")];
				v136 = 2;
			end
			if ((v136 == 3) or (3430 <= 1176)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\192\67\238\74\61\240\75", "\151\56\165\55\154\35\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\74\19\231\174\70\53\252\175\87\0\237\180\74\10\224\136\115", "\142\192\35\101")] or 0;
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\61\183\238\130\171\5", "\118\182\21\73\195\135\236\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\53\12\73\10\8\206\0\53\31\76\0\37\205", "\157\104\92\122\32\100\109")] or 0;
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\219\222\52\41\138\184", "\203\195\198\175\170\93\71\237")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\74\39\218\95\57\253\32\79\45\253\97", "\156\78\43\94\181\49\113")] or 0;
				v136 = 4;
			end
			if ((v136 == 4) or (1198 >= 3717)) then
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\208\183\2\77\126\97", "\25\18\136\164\195\107\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\44\176\64\124\148\192\182\236\62\143\64\113\169\210\144\216", "\216\136\77\201\47\18\220\161")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\233\63\206\1\210\133\62", "\226\77\140\75\186\104\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\193\194\59\64\191\233\220\48\93\160\232\223\60\90\170\230\224", "\47\217\174\176\95")] or 0;
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\216\98\22\187\90\127\53", "\70\216\189\22\98\210\52\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\211\166\148\192\211\209\164\136\213\234\205\172\147\214\217\203\170\136\221\252\208\160\146\192\242\239", "\179\186\191\195\231")] or 0;
				v136 = 5;
			end
			if ((3730 >= 1333) and (v136 == 6)) then
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\221\83\43\222\214\64\44", "\95\183\184\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\54\233\39\88\178\7\182\52\232\40\93\142\5\134\58\243\50\93\142\5", "\98\213\95\135\70\52\224")] or "";
				break;
			end
			if ((v136 == 0) or (2152 == 2797)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\47\71\88\191\163\45\64", "\214\205\74\51\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\95\231\206\114\248\89\233\249", "\23\154\44\130\156")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\163\185\186\63\29\22\181", "\115\113\198\205\206\86")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\68\251\114\133\90\243\95\150\88\248\112\145\68\234\83\135\82", "\58\228\55\158")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\140\196\58\53\163\50\167", "\85\212\233\176\78\92\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\75\141\198\67\78\129\236\79\104\154\237\94\93\139\246\67\87\134", "\130\42\56\232")];
				v136 = 1;
			end
		end
	end
	local function v121()
		local v137 = 0;
		while true do
			if ((v137 == 1) or (1709 < 588)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\245\145\251\52\131\247\150", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\255\227\9\14\74\49\243\242\12\13\64\6", "\38\117\150\144\121\107")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\190\250\46\36\181\233\41", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\13\50\41\73\11\88\243\2\39\42", "\26\134\100\65\89\44\103")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\36\55\173\255\228\35", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\163\3\60\10\225\16\187\3\28\11", "\136\126\208\102\104\120")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\225\248\186\112\15\251\252\132\98", "\17\108\146\157\232")];
				v137 = 2;
			end
			if ((3 == v137) or (3575 <= 3202)) then
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\210\11\175\170\218\71\188\246\217\15\139\142", "\200\153\183\106\195\222\178\52")] or 0;
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\82\209\25\84\49\132\103\223\1\84\48\141\127\224", "\95\227\55\176\117\61")] or 0;
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\32\76\227\208\255\34\125\224\205\248\42\67\193\216\252\32", "\185\145\69\45\143")] or "";
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\51\29\135\52\55\50\133\62\62\26\128\44\55\23", "\227\88\82\115")];
				v137 = 4;
			end
			if ((v137 == 2) or (4397 < 3715)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\171\36\52\141\187\241\247\172\1\52\151\184\215\199", "\131\223\86\93\227\208\148")];
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\42\38\182\224\42\56\18\182\245\46\8\1", "\129\70\75\69\223")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\145\188\219\6\226\216\196\138\170\231\12\237\209", "\180\176\226\217\147\99\131")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\164\25\253\68\141\175\67\185\27\229\78\152\170\69\185", "\195\42\215\124\181\33\236")];
				v137 = 3;
			end
			if ((v137 == 4) or (4075 <= 2245)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\250\4\230\16\254\35\236\31\244\24\242\19\233\15\227\16", "\130\124\155\106")];
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\100\63\226\162\38\99\25", "\105\44\90\131\206")];
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\252\7\179\112\80\218\82\96", "\26\48\153\102\223\63\31\153")] or 0;
				break;
			end
			if ((v137 == 0) or (3966 > 4788)) then
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\221\99\93\240\164\218", "\52\158\195\169\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\181\53\124\146\7\126\134\123\181\60\103\165\61\126\136\113", "\235\26\220\82\20\230\85\27")] or 0;
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\164\253\214\125\134\166\250", "\20\232\193\137\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\209\209\163\245\158\2\97\54\232\204\178\239\191\3\100\44", "\17\66\191\165\198\135\236\119")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\170\186\7\246\230\235\194", "\177\111\207\206\115\159\136\140")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\135\4\17\198\93\74\21\157\63\26\216\86\104\13\128\4\17\216\70\76\17", "\63\101\233\112\116\180\47")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\62\249\6\241\56\196\40", "\86\163\91\141\114\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\122\5\96\118\40\65\30\100\103\14\91\25\113\96\50\92\7\112", "\90\51\107\20\19")];
				v137 = 1;
			end
		end
	end
	local function v122()
		local v138 = 0;
		local v139;
		while true do
			if ((3826 > 588) and (v138 == 1)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\79\234\244\14\69\254", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\76\224", "\43\120\35\131\170\102\54")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\9\128\177\169\181\151", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\239\112", "\182\126\128\21\170\138\235\121")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\213\50\225\138\22\35", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\8\45", "\66\55\108\94\63\18\180")];
				v138 = 2;
			end
			if ((694 <= 1507) and (v138 == 3)) then
				if ((3900 >= 1116) and v32) then
					v102 = #v101;
				else
					local v200 = 0;
					while true do
						if ((4907 > 3311) and (v200 == 0)) then
							v101 = {};
							v102 = 1;
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or (3408 <= 2617)) then
					if ((3201 == 3201) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\220\33\28\25\51\252\250\33\40\31\32\249", "\152\159\83\105\106\82")]:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
						if ((2195 == 2195) and v25(v96.CrusaderAura)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\130\212\68\225\200\88\132\212\110\243\220\78\128", "\60\225\166\49\146\169");
						end
					end
				end
				if (v15:AffectingCombat() or v76 or (3025 > 3506)) then
					local v201 = 0;
					local v202;
					while true do
						if ((v201 == 1) or (736 < 356)) then
							if ((1171 <= 2774) and v139) then
								return v139;
							end
							break;
						end
						if ((4108 >= 312) and (v201 == 0)) then
							v202 = v76 and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\12\18\42\43\15\20\42\42\32\50\8\9\60", "\103\79\126\79\74\97")]:IsReady() and v34;
							v139 = v95.FocusUnit(v202, v100, 20, nil, 25);
							v201 = 1;
						end
					end
				end
				v138 = 4;
			end
			if ((v138 == 4) or (679 > 2893)) then
				v139 = v95.FocusUnitWithDebuffFromList(v19[LUAOBFUSACTOR_DECRYPT_STR_0("\138\126\223\114\90\19\180", "\122\218\31\179\19\62")].FreedomDebuffList, 40, 25);
				if (v139 or (876 < 200)) then
					return v139;
				end
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\145\218\200\210\218\168\75\180\217\203\231\219\164\64\183\217\192", "\37\211\182\173\161\169\193")]:IsReady() and v95.UnitHasDebuffFromList(v14, v19[LUAOBFUSACTOR_DECRYPT_STR_0("\199\59\65\216\44\114\183", "\217\151\90\45\185\72\27")].FreedomDebuffList)) or (2325 > 3562)) then
					if (v25(v100.BlessingofFreedomFocus) or (3661 > 4704)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\112\226\1\69\202\114\224\45\89\197\67\225\0\83\198\120\232\31\22\192\115\234\16\87\215", "\54\163\28\135\114");
					end
				end
				v138 = 5;
			end
			if ((v138 == 5) or (4133 <= 1928)) then
				v105 = v109();
				if ((4418 >= 1433) and not v15:AffectingCombat()) then
					if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\26\222\73\144\71\125\61\207\84\141\64\94\61\201\92", "\31\72\187\61\226\46")]:IsCastable() and (v110())) or (4123 >= 4123)) then
						if (v25(v96.RetributionAura) or (205 >= 2345)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\209\3\87\192\78\124\49\215\15\76\220\120\127\49\209\7", "\68\163\102\35\178\39\30");
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or (537 == 1004)) then
					if (v15:AffectingCombat() or (2345 < 545)) then
						if ((1649 > 243) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\151\126\206\194\17\182\134\2\173\121\213\201", "\113\222\16\186\167\99\213\227")]:IsCastable()) then
							if (v25(v96.Intercession, not v17:IsInRange(30), true) or (3910 <= 3193)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\39\0\239\243\60\13\254\229\61\7\244\248\110\26\250\228\41\11\239", "\150\78\110\155");
							end
						end
					elseif ((2005 == 2005) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\183\192\35\228\169\14\171\73\138\203", "\32\229\165\71\129\196\126\223")]:IsCastable()) then
						if ((4688 > 4572) and v25(v96.Redemption, not v17:IsInRange(30), true)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\209\140\192\132\140\197\215\128\203\143\193\193\194\155\195\132\149", "\181\163\233\164\225\225");
						end
					end
				end
				v138 = 6;
			end
			if ((1567 < 3260) and (v138 == 0)) then
				v120();
				v119();
				v121();
				v138 = 1;
			end
			if ((v138 == 7) or (3761 == 621)) then
				if ((4755 > 3454) and v77) then
					local v203 = 0;
					while true do
						if ((4819 >= 1607) and (0 == v203)) then
							if ((4546 >= 1896) and v73) then
								local v209 = 0;
								while true do
									if ((3546 > 933) and (v209 == 0)) then
										v139 = v95.HandleAfflicted(v96.CleanseToxins, v100.CleanseToxinsMouseover, 40);
										if (v139 or (3985 <= 3160)) then
											return v139;
										end
										break;
									end
								end
							end
							if ((1987 == 1987) and v74 and (v106 > 2)) then
								local v210 = 0;
								while true do
									if ((994 <= 4540) and (v210 == 0)) then
										v139 = v95.HandleAfflicted(v96.WordofGlory, v100.WordofGloryMouseover, 40, true);
										if ((4917 == 4917) and v139) then
											return v139;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v78 or (324 > 4896)) then
					local v204 = 0;
					while true do
						if ((772 < 4670) and (v204 == 0)) then
							v139 = v95.HandleIncorporeal(v96.Repentance, v100.RepentanceMouseOver, 30, true);
							if ((3172 >= 2578) and v139) then
								return v139;
							end
							v204 = 1;
						end
						if ((v204 == 1) or (721 == 834)) then
							v139 = v95.HandleIncorporeal(v96.TurnEvil, v100.TurnEvilMouseOver, 30, true);
							if ((1312 < 2654) and v139) then
								return v139;
							end
							break;
						end
					end
				end
				v139 = v112();
				v138 = 8;
			end
			if ((3213 >= 1613) and (v138 == 8)) then
				if (v139 or (3786 > 4196)) then
					return v139;
				end
				if ((4218 == 4218) and v14) then
					if ((1517 < 4050) and v76) then
						local v208 = 0;
						while true do
							if ((4390 == 4390) and (v208 == 0)) then
								v139 = v111();
								if ((1919 > 289) and v139) then
									return v139;
								end
								break;
							end
						end
					end
				end
				v139 = v113();
				v138 = 9;
			end
			if ((v138 == 6) or (1205 < 751)) then
				if ((v96[LUAOBFUSACTOR_DECRYPT_STR_0("\98\142\58\114\93\155\42\126\95\133", "\23\48\235\94")]:IsCastable() and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\78\223\220\88\90\35\198\117\213\214", "\178\28\186\184\61\55\83")]:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or (2561 <= 1717)) then
					if ((1723 <= 3600) and v25(v100.RedemptionMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\200\67\57\255\30\225\205\194\73\124\255\1\224\215\200\72\42\247\28", "\149\164\173\39\92\146\110");
					end
				end
				if ((3271 >= 1633) and v15:AffectingCombat()) then
					if ((3103 >= 2873) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\218\41\4\26\8\24\246\52\3\22\21\21", "\123\147\71\112\127\122")]:IsCastable() and (v15:HolyPower() >= 3) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\229\195\150\116\84\207\200\145\98\79\195\195", "\38\172\173\226\17")]:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v100.IntercessionMouseover) or (3603 == 725)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\100\31\56\234\95\18\41\252\94\24\35\225\13\28\35\250\94\20\35\249\72\3", "\143\45\113\76");
						end
					end
				end
				if ((2843 == 2843) and (v95.TargetIsValid() or v15:AffectingCombat())) then
					local v205 = 0;
					while true do
						if ((v205 == 2) or (174 >= 2515)) then
							v106 = v15:HolyPower();
							break;
						end
						if ((4411 >= 2020) and (v205 == 0)) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v205 = 1;
						end
						if ((1347 == 1347) and (v205 == 1)) then
							if ((4461 == 4461) and (v104 == 11111)) then
								v104 = v10.FightRemains(v101, false);
							end
							v107 = v15:GCD();
							v205 = 2;
						end
					end
				end
				v138 = 7;
			end
			if ((v138 == 9) or (4340 == 2872)) then
				if ((568 <= 2207) and v139) then
					return v139;
				end
				if ((not v15:AffectingCombat() and v31 and v95.TargetIsValid()) or (3789 <= 863)) then
					local v206 = 0;
					while true do
						if ((238 < 4997) and (v206 == 0)) then
							v139 = v115();
							if ((4285 > 3803) and v139) then
								return v139;
							end
							break;
						end
					end
				end
				if ((2672 < 4910) and v15:AffectingCombat() and v95.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
					local v207 = 0;
					while true do
						if ((v207 == 0) or (2956 > 4353)) then
							if ((3534 > 2097) and UseLayOnHands and (v15:HealthPercentage() <= v68) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\148\185\5\51\182\144\29\50\188\171", "\92\216\216\124")]:IsReady() and v15:DebuffDown(v96.ForbearanceDebuff)) then
								if ((3255 >= 534) and v25(v96.LayonHands)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\87\51\181\127\242\85\13\164\65\243\95\33\147\80\241\90\43\169\82\189\95\55\170\69\243\72\59\186\69", "\157\59\82\204\32");
								end
							end
							if ((4254 < 4460) and v60 and (v15:HealthPercentage() <= v67) and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\28\55\245\243\231\239\224\185\49\59\239\254", "\209\88\94\131\154\137\138\179")]:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
								if (v25(v96.DivineShield) or (4661 <= 4405)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\44\168\210\117\16\38\14\49\32\168\193\112\26\99\53\39\46\164\202\111\23\53\52", "\66\72\193\164\28\126\67\81");
								end
							end
							v207 = 1;
						end
						if ((4575 >= 1943) and (v207 == 2)) then
							if ((v87 and (v15:HealthPercentage() <= v89)) or (326 > 1137)) then
								local v211 = 0;
								while true do
									if ((1284 == 1284) and (v211 == 0)) then
										if ((v91 == LUAOBFUSACTOR_DECRYPT_STR_0("\22\10\164\85\33\28\170\78\42\8\226\111\33\14\174\78\42\8\226\119\43\27\171\72\42", "\39\68\111\194")) or (3072 >= 3426)) then
											if (v97[LUAOBFUSACTOR_DECRYPT_STR_0("\228\163\225\213\124\164\222\175\233\192\81\178\215\170\238\201\126\135\217\178\238\200\119", "\215\182\198\135\167\25")]:IsReady() or (4036 > 4375)) then
												if ((3928 == 3928) and v25(v100.RefreshingHealingPotion)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\159\76\236\90\136\90\226\65\131\78\170\64\136\72\230\65\131\78\170\88\130\93\227\71\131\9\238\77\139\76\228\91\132\95\239", "\40\237\41\138");
												end
											end
										end
										if ((v91 == "Dreamwalker's Healing Potion") or (2629 >= 3005)) then
											if (v97[LUAOBFUSACTOR_DECRYPT_STR_0("\227\102\255\249\71\208\117\246\243\79\213\103\210\253\75\203\125\244\255\122\200\96\243\247\68", "\42\167\20\154\152")]:IsReady() or (2620 <= 422)) then
												if ((1896 > 1857) and v25(v100.RefreshingHealingPotion)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\78\236\167\67\124\54\75\242\169\71\99\50\10\246\167\67\125\40\68\249\226\82\126\53\67\241\172\2\117\36\76\251\172\81\120\55\79", "\65\42\158\194\34\17");
												end
											end
										end
										break;
									end
								end
							end
							if ((1466 >= 492) and (v82 < v104)) then
								local v212 = 0;
								while true do
									if ((868 < 3853) and (v212 == 0)) then
										v139 = v116();
										if (v139 or (1815 > 4717)) then
											return v139;
										end
										break;
									end
								end
							end
							v207 = 3;
						end
						if ((3671 == 3671) and (v207 == 3)) then
							v139 = v118();
							if ((216 <= 284) and v139) then
								return v139;
							end
							v207 = 4;
						end
						if ((3257 > 2207) and (v207 == 4)) then
							if (v25(v96.Pool) or (2087 < 137)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v207 == 1) or (3923 >= 4763)) then
							if ((1744 == 1744) and v59 and v96[LUAOBFUSACTOR_DECRYPT_STR_0("\195\37\190\81\40\115\215\62\167\76\35\117\243\37\167\86", "\22\135\76\200\56\70")]:IsCastable() and (v15:HealthPercentage() <= v66)) then
								if ((248 <= 1150) and v25(v96.DivineProtection)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\137\57\238\45\83\228\178\32\234\43\73\228\142\36\241\43\83\161\137\53\254\33\83\242\132\38\253", "\129\237\80\152\68\61");
								end
							end
							if ((3994 >= 294) and v97[LUAOBFUSACTOR_DECRYPT_STR_0("\121\173\5\255\8\31\75\69\167\10\246", "\56\49\200\100\147\124\119")]:IsReady() and v88 and (v15:HealthPercentage() <= v90)) then
								if ((1641 > 693) and v25(v100.Healthstone)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\196\59\190\252\216\54\172\228\195\48\186\176\200\59\185\245\194\45\182\230\201", "\144\172\94\223");
								end
							end
							v207 = 2;
						end
					end
				end
				break;
			end
			if ((2 == v138) or (4519 < 2235)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\32\130\130\48\43\92\7", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\184\254\247\114\226", "\39\202\209\141\135\23\142")];
				if ((892 < 1213) and v15:IsDeadOrGhost()) then
					return;
				end
				v101 = v15:GetEnemiesInMeleeRange(10);
				v138 = 3;
			end
		end
	end
	local function v123()
		local v140 = 0;
		while true do
			if ((3313 <= 4655) and (v140 == 0)) then
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\40\34\70\30\36\239\14\250\19\40\92\76\29\236\23\239\30\46\92\76\47\244\91\203\10\46\81\66\109\222\14\254\10\40\64\24\40\233\91\236\3\103\74\39\44\227\30\250\21\105", "\142\122\71\50\108\77\141\123"));
				v99();
				break;
			end
		end
	end
	v21.SetAPL(70, v122, OnInit);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\48\178\246\0\4\37\163\243\25\63\28\172\192\42\62\1\176\246\26\46\1\171\240\22\117\25\183\254", "\91\117\194\159\120")]();

