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
		if ((v5 == 1) or (3677 <= 2768)) then
			return v6(...);
		end
		if ((v5 == 0) or (277 > 3338)) then
			v6 = v0[v4];
			if ((2610 > 2560) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\213\23\212\208\207\26\206\180\203\7\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\210\53\233\83", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\152\120\104", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\124\86\9\41\90", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\50\168\142\36\202", "\185\98\218\235\87")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205\137\222\46\52\233\204", "\202\171\92\71\134\190")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\25\211\41\155\58\231\35\139\60\210", "\232\73\161\76")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\139\203\71\78\13\150\214\87\78\27\180\207\71\79", "\126\219\185\34\61")];
	local v27 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\60\220\91\97\109\71\255\230\21\203\76", "\135\108\174\62\18\30\23\147")];
	local v28 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\148\224\36\207", "\167\214\137\74\171\120\206\83")];
	local v29 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\166\241\49\79\247", "\199\235\144\82\61\152")];
	local v30 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\59\45", "\156\168\78\64\224\212\121")];
	local v31 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\36\225\168\195\8\224\182", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\62\90\42\60\81\246\83", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\203\225\80", "\60\180\164\142")];
	local v32 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\94\81\23\36\38\249", "\114\56\62\101\73\71\141")];
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = 0;
	local v38 = false;
	local v39 = false;
	local v40 = 0;
	local v41 = false;
	local v42 = false;
	local v43 = 0;
	local v44 = 0;
	local v45 = false;
	local v46 = 0;
	local v47 = 0;
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
	local v98 = 0;
	local v99 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\136\251\210\193\171\253", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\233\61\171", "\107\178\134\81\210\198\158")];
	local v100 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\8\28\139\195\185\44", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\0\142\238", "\170\163\111\226\151")];
	local v101 = v29[LUAOBFUSACTOR_DECRYPT_STR_0("\33\34\187\61\93\35", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\35\193\11", "\135\225\76\173\114")];
	local v102 = {};
	local v103;
	local v104, v105, v106;
	local v107;
	local v108;
	local v109 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\57\226\181\189\163\179\180", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\203\21\226\97\249\163\216", "\150\205\189\112\144\24")];
	local function v110()
		if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\12\137\175\94\11\158\20\20\21\145\173\69\2\145", "\112\69\228\223\44\100\232\113")]:IsAvailable() or (1194 > 3083)) then
			v109[LUAOBFUSACTOR_DECRYPT_STR_0("\240\22\20\195\179\112\138\213\29\11\214\146\121\132\193\25\1\192", "\230\180\127\103\179\214\28")] = v20.MergeTable(v109.DispellableMagicDebuffs, v109.DispellableDiseaseDebuffs);
		else
			v109[LUAOBFUSACTOR_DECRYPT_STR_0("\168\12\76\86\225\77\236\141\7\83\67\192\68\226\153\3\89\85", "\128\236\101\63\38\132\33")] = v109[LUAOBFUSACTOR_DECRYPT_STR_0("\136\160\2\84\179\231\195\173\171\29\65\155\234\200\165\170\53\65\180\254\201\170\186", "\175\204\201\113\36\214\139")];
		end
	end
	v10:RegisterForEvent(function()
		v110();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\102\239\1\245\50\98\243\5\240\37\126\233\7\227\55\119\233\22\245\37\107\229\15\253\48\110\227\27\227\39\111\237\27\251\33\99", "\100\39\172\85\188"));
	local function v111(v125)
		return v125:DebuffRefreshable(v99.ShadowWordPain) and (v125:TimeToDie() >= 12);
	end
	local function v112()
		if ((916 >= 747) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\157\109\171\137\53\180", "\83\205\24\217\224")]:IsReady() and v36 and v109.DispellableFriendlyUnit()) then
			if (v23(v101.PurifyFocus) or (2444 > 2954)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\246\208\223\52\224\220\141\57\239\214\221\56\234", "\93\134\165\173");
			end
		end
	end
	local function v113()
		local v126 = 0;
		while true do
			if ((2892 < 3514) and (v126 == 1)) then
				if ((533 == 533) and v100[LUAOBFUSACTOR_DECRYPT_STR_0("\113\83\74\241\97\142\148\31\86\88\78", "\107\57\54\43\157\21\230\231")]:IsReady() and v82 and (v13:HealthPercentage() <= v83)) then
					if ((595 <= 3413) and v23(v101.Healthstone, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\142\16\249\173\212\220\207\132\31\240\249\216\202\221\142\31\230\176\202\202\155\216", "\175\187\235\113\149\217\188");
					end
				end
				if ((3078 >= 2591) and v89 and (v13:HealthPercentage() <= v91)) then
					if ((3199 < 4030) and (v90 == LUAOBFUSACTOR_DECRYPT_STR_0("\14\170\135\94\230\106\112\53\161\134\12\203\124\121\48\166\143\75\163\73\119\40\166\142\66", "\24\92\207\225\44\131\25"))) then
						if ((777 < 2078) and v100[LUAOBFUSACTOR_DECRYPT_STR_0("\121\214\190\94\30\110\67\218\182\75\51\120\74\223\177\66\28\77\68\199\177\67\21", "\29\43\179\216\44\123")]:IsReady()) then
							if ((1696 <= 2282) and v23(v101.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\175\220\38\94\184\202\40\69\179\222\96\68\184\216\44\69\179\222\96\92\178\205\41\67\179\153\36\73\187\220\46\95\180\207\37\12\233", "\44\221\185\64");
							end
						end
					end
				end
				break;
			end
			if ((v126 == 0) or (1761 >= 2462)) then
				if ((4551 > 2328) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\152\243\197\199", "\30\222\146\161\162\90\174\210")]:IsReady() and v94 and (v13:HealthPercentage() <= v95)) then
					if ((3825 >= 467) and v23(v99.Fade, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\79\116\15\165\74\117\12\224\64\99\3\243\75", "\106\133\46\16");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\124\37\96\236\95\82\89\52\118\204\72\65\65\37\97", "\32\56\64\19\156\58")]:IsCastable() and v93 and (v13:HealthPercentage() <= v37)) or (2890 == 557)) then
					if (v23(v99.DesperatePrayer) or (4770 == 2904)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\205\246\70\95\224\129\78\205\218\70\72\243\153\95\218\165\82\95\244\133\84\219\236\64\95", "\224\58\168\133\54\58\146");
					end
				end
				v126 = 1;
			end
		end
	end
	local function v114()
		local v127 = 0;
		while true do
			if ((v127 == 1) or (3903 == 4536)) then
				v103 = v109.HandleBottomTrinket(v102, v35 and v13:BuffUp(v99.PowerInfusionBuff), 40, nil);
				if ((4093 <= 4845) and v103) then
					return v103;
				end
				break;
			end
			if ((1569 <= 3647) and (v127 == 0)) then
				v103 = v109.HandleTopTrinket(v102, v35 and v13:BuffUp(v99.PowerInfusionBuff), 40, nil);
				if (v103 or (4046 >= 4927)) then
					return v103;
				end
				v127 = 1;
			end
		end
	end
	local function v115()
		if ((4623 >= 2787) and ((GetTime() - v98) > v40)) then
			local v141 = 0;
			while true do
				if ((2234 >= 1230) and (v141 == 0)) then
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\35\232\76\70\114\15\227\123\80\102\13", "\19\97\135\40\63")]:IsAvailable() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\158\83\36\62\61\6\161\78\55\8\39\56\171\80\55", "\81\206\60\83\91\79")]:IsReady() and v39 and v13:BuffDown(v99.AngelicFeatherBuff) and v13:BuffDown(v99.BodyandSoulBuff)) or (343 == 1786)) then
						if ((2570 > 2409) and v23(v101.PowerWordShieldPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\94\164\199\119\61\252\90\171\92\175\239\97\39\202\72\168\74\148\192\126\46\218\72\182\14\166\223\100\42", "\196\46\203\176\18\79\163\45");
						end
					end
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\153\44\121\27\40\242\236\158\39\127\10\44\254\253", "\143\216\66\30\126\68\155")]:IsReady() and v38 and v13:BuffDown(v99.AngelicFeatherBuff) and v13:BuffDown(v99.BodyandSoulBuff) and v13:BuffDown(v99.AngelicFeatherBuff)) or (2609 >= 3234)) then
						if (v23(v101.AngelicFeatherPlayer) or (3033 >= 4031)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\171\198\10\206\201\170\212\222\172\205\12\223\205\166\197\222\186\196\12\210\192\177\151\236\165\222\8", "\129\202\168\109\171\165\195\183");
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v128 = 0;
		while true do
			if ((v128 == 0) or (1401 == 4668)) then
				if ((2776 >= 1321) and (v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\3\86\46\215\208\17", "\134\66\56\87\184\190\116"))) then
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\27\36\8\169\29\226\32\59\15\33\0\169\16\255", "\85\92\81\105\219\121\139\65")]:IsReady() and (v15:HealthPercentage() <= v80)) or (487 > 2303)) then
						if (v23(v101.GuardianSpiritFocus, nil, nil, true) or (4503 == 3462)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\250\166\81\87\120\214\252\189\111\86\108\214\239\186\68\5\116\218\252\191\111\70\115\208\241\183\95\82\114", "\191\157\211\48\37\28");
						end
					end
				elseif ((553 <= 1543) and (v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\235\30\250\23\122\240\17\248\5", "\90\191\127\148\124"))) then
					if ((2015 == 2015) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\95\146\47\5\124\142\47\25\75\151\39\5\113\147", "\119\24\231\78")]:IsReady() and (v15:HealthPercentage() <= v80) and (Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\182\12\139\97", "\113\226\77\197\42\188\32"))) then
						if (v23(v101.GuardianSpiritFocus, nil, nil, true) or (4241 <= 2332)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\61\3\245\167\62\31\245\187\5\5\228\188\40\31\224\245\50\19\245\185\5\21\251\186\54\18\251\162\52", "\213\90\118\148");
						end
					end
				elseif ((v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\111\47\186\93\13\90\32\176\22\126\94\34\178", "\45\59\78\212\54")) or (2364 < 1157)) then
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\55\67\130\153\130\39\172\254\35\70\138\153\143\58", "\144\112\54\227\235\230\78\205")]:IsReady() and (v15:HealthPercentage() <= v80) and ((Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\135\9\33\215", "\59\211\72\111\156\176")) or (Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\102\162\194\1\107\181", "\77\46\231\131")))) or (1167 > 1278)) then
						if (v23(v101.GuardianSpiritFocus, nil, nil, true) or (1145 <= 1082)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\189\65\183\82\190\93\183\78\133\71\166\73\168\93\162\0\178\81\183\76\133\87\185\79\182\80\185\87\180", "\32\218\52\214");
						end
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\102\24\61\177\198\191\87\94\125\22\61\190\240\164\76\85\64", "\58\46\119\81\200\145\208\37")]:IsReady() and v70 and v109.AreUnitsBelowHealthPercentage(v71, v72)) or (3105 == 4881)) then
					if (v23(v99.HolyWordSalvation, nil, true) or (1887 > 4878)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\131\60\181\150\170\57\57\136\15\191\168\177\32\42\152\57\163\167\253\62\46\141\60\147\170\178\57\39\136\63\187\167", "\86\75\236\80\204\201\221");
					end
				end
				v128 = 1;
			end
			if ((v128 == 1) or (4087 > 4116)) then
				if ((1106 <= 1266) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\86\72\97\140\240\142\90\88\122\139", "\235\18\33\23\229\158")]:IsReady() and v52 and v109.AreUnitsBelowHealthPercentage(v53, v54)) then
					if ((3155 < 4650) and v23(v99.DivineHymn, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\179\215\178\94\191\254\179\73\183\207\251\88\191\192\183\111\185\206\180\92\190\206\172\94", "\219\48\218\161");
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v129 = 0;
		while true do
			if ((3774 >= 1839) and (v129 == 0)) then
				if ((2811 == 2811) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\212\126\107\76\201\120\239\246\117\80\64\221\74", "\128\132\17\28\41\187\47")]:IsReady() and v66 and (v15:HealthPercentage() < v67)) then
					if ((2146 > 1122) and v23(v101.PowerWordLifeFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\17\61\17\63\79\62\37\9\40\89\62\62\15\60\88\65\58\3\59\81", "\61\97\82\102\90");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\156\60\170\82\194\69\17\15\129\43\165\79\206\89\25", "\105\204\78\203\43\167\55\126")]:IsReady() and v64 and v15:BuffRefreshable(v99.PrayerofMending) and (v15:HealthPercentage() <= v65)) or (56 == 3616)) then
					if (v23(v101.PrayerofMendingFocus) or (2421 < 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\184\34\7\22\22\248\94\163\149\46\27\29\0\206\95\162\234\43\27\18\8", "\49\197\202\67\126\115\100\167");
					end
				end
				if ((1009 <= 1130) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\31\84\211\48\183\89\76\51\104\222\39\131\66\87\49\66", "\62\87\59\191\73\224\54")]:IsReady() and v73 and v109.AreUnitsBelowHealthPercentage(v74, v75) and v16 and v16:IsAPlayer() and not v13:CanAttack(v16)) then
					if ((2758 < 2980) and v23(v101.HolyWordSanctifyCursor)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\13\246\208\216\21\245\219\227\61\233\200\233\1\238\192\225\27\186\193\226\3\246", "\169\135\98\154");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\227\120\40\77\202\60\218\207\68\33\70\248\61\193\223\110", "\168\171\23\68\52\157\83")]:IsReady() and v68 and (v15:HealthPercentage() <= v69)) or (86 >= 3626)) then
					if ((2395 == 2395) and v23(v101.HolyWordSerenityFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\126\249\180\26\58\136\230\117\202\190\32\63\130\250\120\225\180\101\37\130\245\125", "\231\148\17\149\205\69\77");
					end
				end
				v129 = 1;
			end
			if ((3780 > 2709) and (v129 == 1)) then
				if ((v109.AreUnitsBelowHealthPercentage(v43, v44) and v42) or (237 >= 2273)) then
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\161\183\200\239\95\250\143\180\206\232", "\159\224\199\167\155\55")]:IsReady() and v35 and v13:AffectingCombat() and ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\223\252\48\203\192\252\46\214\196\242\50\209\227\250\58\203", "\178\151\147\92")]:CooldownDown() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\164\242\64\43\37\67\104\136\206\73\32\23\66\115\152\228", "\26\236\157\44\82\114\44")]:CooldownDown()) or (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\2\33\217\66\29\33\199\95\25\43\199\94\36\39\193\66", "\59\74\78\181")]:CooldownDown() and (v15:HealthPercentage() <= v69)) or (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\13\222\86\67\132\42\195\94\105\178\43\210\78\83\181\60", "\211\69\177\58\58")]:CooldownDown() and v109.AreUnitsBelowHealthPercentage(v74, v75)))) or (2040 <= 703)) then
						if ((3279 <= 3967) and v23(v99.Apotheosis)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\182\245\118\225\225\206\184\246\112\230\169\195\178\228\117", "\171\215\133\25\149\137");
						end
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\194\193\32\249\227\53\243\68\201\205\51\246\230\62\251", "\34\129\168\82\154\143\80\156")]:IsReady() and v45 and v109.AreUnitsBelowHealthPercentage(v46, v47)) or (1988 == 877)) then
					if ((4291 > 1912) and v23(v101.CircleofHealingFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\187\33\8\68\75\182\138\180\12\3\77\79\133\140\188\52\75\64\75\136\137", "\233\229\210\83\107\40\46");
					end
				end
				if ((2003 < 2339) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\229\75\36\223\11\196\113\38\215\23", "\101\161\34\82\182")]:IsReady() and (v15:HealthPercentage() < v56) and v55) then
					if ((432 == 432) and v23(v101.DivineStarPlayer, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\4\79\247\213\231\189\61\252\12\75\190\211\231\131\34", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\22\62\245\254", "\145\94\95\153")]:IsReady() and v59 and v109.AreUnitsBelowHealthPercentage(v60, v61)) or (1145 >= 1253)) then
					if ((3418 > 2118) and v23(v101.HaloPlayer, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\204\24\218\14\191\248\204\24", "\215\157\173\116\181\46");
					end
				end
				v129 = 2;
			end
			if ((3066 <= 3890) and (v129 == 2)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\5\166\138\235\223\39\187\141\218\223\52\184\130\252\221", "\186\85\212\235\146")]:IsReady() and v76 and v13:BuffUp(v99.PrayerCircleBuff) and v109.AreUnitsBelowHealthPercentage(v77, v78)) or (2998 >= 3281)) then
					if (v23(v101.PrayerofHealingFocus, nil, true) or (4649 <= 2632)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\147\23\231\60\252\103\205\135\41\246\60\239\84\203\143\17\190\49\235\89\206", "\56\162\225\118\158\89\142");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\122\9\193\188\42\240\89\4\204", "\184\60\101\160\207\66")]:IsReady() and v57 and ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\29\139\123\180\37\149\121\189\39\135\110", "\220\81\226\28")]:IsAvailable() and (v13:BuffDown(v99.LightweaverBuff) or (v13:BuffStack(v99.LightweaverBuff) < 2))) or v13:BuffUp(v99.SurgeofLight) or (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\63\220\133\243\254\208\22\212\148\254\248", "\167\115\181\226\155\138")]:IsAvailable() and (v13:ManaPercentage() > 40)))) or (3860 > 4872)) then
					if ((v15:HealthPercentage() <= v58) or (v15:HealthPercentage() <= v63) or (3998 == 2298)) then
						if (v23(v101.FlashHealFocus, nil, v108) or (8 >= 2739)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\228\46\230\79\115\78\206\231\35\235\28\115\116\199\238", "\166\130\66\135\60\27\17");
						end
					end
				end
				if ((2590 == 2590) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\108\79\207\121", "\80\36\42\174\21")]:IsReady() and v62 and (v15:HealthPercentage() <= v63)) then
					if (v23(v101.HealFocus, nil, true) or (82 >= 1870)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\21\54\118\14\24\50\123\66", "\26\46\112\87");
					end
				end
				if ((2624 < 4557) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\138\58\166\118\176\179\74\178\145\44\187\113", "\212\217\67\203\20\223\223\37")]:IsReady() and v41 and v35 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\158\136\187\194\191\159\169\198\191\189\186\211\163\136\186", "\178\218\237\200")]:CooldownDown()) then
					if (v23(v99.SymbolofHope, nil, true) or (3131 > 3542)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\172\235\210\185\185\217\223\176\138\238\223\166\176\166\216\179\180\234", "\176\214\213\134");
					end
				end
				v129 = 3;
			end
			if ((2577 >= 1578) and (v129 == 3)) then
				if ((4103 <= 4571) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\198\168\184\209\191", "\57\148\205\214\180\200\54")]:IsReady() and v96 and v15:BuffDown(v99.Renew) and (v15:HealthPercentage() <= v97)) then
					if (v23(v101.RenewFocus, nil, true) or (1495 == 4787)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\248\59\49\97\82\245\48\53\122", "\22\114\157\85\84");
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (310 > 4434)) then
				v103 = v109.InterruptWithStun(v99.PsychicScream, 8);
				if ((2168 <= 4360) and v103) then
					return v103;
				end
				if ((994 == 994) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\224\194\0\212\88\250\133\197\204\26\199", "\200\164\171\115\164\61\150")]:IsReady() and v36 and v84 and not v13:IsCasting() and not v13:IsChanneling() and v109.UnitHasMagicBuff(v14)) then
					if ((1655 > 401) and v23(v99.DispelMagic, not v14:IsSpellInRange(v99.DispelMagic))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\253\16\85\134\178\203\14\68\132\183\247\67\65\130\179\245\4\64", "\227\222\148\99\37");
					end
				end
				if ((3063 <= 3426) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\0\90\83\242\246\36\84\91\243\247\55", "\153\83\50\50\150")]:IsReady() and v35 and (v13:ManaPercentage() <= 95)) then
					if ((1459 > 764) and v23(v99.Shadowfiend)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\126\114\24\124\188\75\84\115\125\24\51\175\76\80\119\116\25", "\45\61\22\19\124\19\203");
					end
				end
				v130 = 1;
			end
			if ((v130 == 2) or (641 > 4334)) then
				if ((3399 >= 2260) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\9\199\73\226\72\202\179\57\207\77", "\224\77\174\63\139\38\175")]:IsReady() and not v14:IsFacingBlacklisted()) then
					if (v23(v101.DivineStarPlayer, not v14:IsInRange(30)) or (393 >= 4242)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\72\78\39\138\68\103\61\144\64\74\110\128\64\85\47\131\68", "\78\228\33\56");
					end
				end
				if ((989 < 4859) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\230\127\190\12", "\229\174\30\210\99")]:IsReady() and v59) then
					if (v23(v101.HaloPlayer, not v14:IsInRange(30), true) or (4795 < 949)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\236\138\94\173\57\56\22\236\129\84", "\89\123\141\230\49\141\93");
					end
				end
				if ((3842 == 3842) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\219\126\250\21\62\69\229\112", "\42\147\17\150\108\112")]:IsReady() and (v13:BuffStack(v99.RhapsodyBuff) == 20)) then
					if ((1747 <= 3601) and v23(v99.HolyNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\169\33\102\216\230\0\176\44\64\245\224\14\182\62\112\227\241\79\162\44\114\230\239\10", "\136\111\198\77\31\135");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\42\6\171\79\138\235\5\173\33\1\166\69\169\237\4\172", "\201\98\105\199\54\221\132\119")]:IsReady() and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\145\3\143\56\44\58\186\184", "\204\217\108\227\65\98\85")]:IsAvailable() or (v105 < 5))) or (804 > 4359)) then
					if ((4670 >= 3623) and v23(v99.HolyWordChastise, not v14:IsSpellInRange(v99.HolyWordChastise))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\204\249\252\19\215\81\209\241\218\47\200\95\208\225\236\63\197\30\199\244\232\45\199\91", "\160\62\163\149\133\76");
					end
				end
				v130 = 3;
			end
			if ((2065 < 2544) and (v130 == 1)) then
				if ((1311 <= 3359) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\224\0\14\244\12\117\141\206\0\31\240\12\100", "\217\161\114\109\149\98\16")]:IsReady() and v85 and v35 and (v13:ManaPercentage() <= 95)) then
					if ((2717 <= 3156) and v23(v99.ArcaneTorrent)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\50\59\125\178\113\45\52\55\110\174\113\28\52\120\120\189\121\19\39\61", "\20\114\64\88\28\220");
					end
				end
				if ((1081 < 4524) and v86 and v35 and v13:BuffUp(v99.PowerInfusionBuff)) then
					local v173 = 0;
					while true do
						if ((440 >= 71) and (v173 == 0)) then
							v103 = v114();
							if ((4934 > 2607) and v103) then
								return v103;
							end
							break;
						end
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\2\9\211\176\247\199\138\62\19\214\144\253\209\169\57", "\221\81\97\178\212\152\176")]:IsCastable() and (v14:HealthPercentage() <= 20)) or (1400 > 3116)) then
					if ((525 < 1662) and v23(v99.ShadowWordDeath, not v14:IsSpellInRange(v99.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\239\28\255\21\218\216\10\244\8\201\216\25\254\27\217\239\93\255\27\192\230\26\254", "\122\173\135\125\155");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\183\201\1\189\48\38\255\139\211\4\157\58\48\220\140", "\168\228\161\96\217\95\81")]:IsCastable() and v16 and (v16:HealthPercentage() <= 20)) or (876 > 2550)) then
					if ((219 <= 2456) and v23(v101.ShadowWordDeathMouseover, not v16:IsSpellInRange(v99.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\217\47\88\32\64\228\198\33\78\43\104\223\212\47\72\39\104\214\222\59\79\42\88\205\212\60\28\43\86\214\208\41\89", "\55\187\177\78\60\79");
					end
				end
				v130 = 2;
			end
			if ((v130 == 5) or (4219 == 1150)) then
				if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\237\170\204\201\118", "\110\190\199\165\189\19\145\61")]:IsReady() or (2989 <= 222)) then
					if ((2258 > 1241) and v23(v99.Smite, not v14:IsSpellInRange(v99.Smite), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\230\126\252\142\135\222\234\122\233\140\194", "\167\186\139\23\136\235");
					end
				end
				if ((41 < 4259) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\41\189\137\9\21\162\191\2\8\177\184\12\19\187", "\109\122\213\232")]:IsReady()) then
					if (v23(v99.ShadowWordPain, not v14:IsSpellInRange(v99.ShadowWordPain)) or (1930 < 56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\255\163\52\225\224\157\39\225\229\166\15\254\246\171\62\209\250\173\38\235\250\167\62\250\183\166\49\227\246\165\53", "\80\142\151\194");
					end
				end
				break;
			end
			if ((3333 == 3333) and (v130 == 4)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\24\17\140\1\111\63\8\129", "\33\80\126\224\120")]:IsReady() and (v105 > 4)) or (2225 == 20)) then
					if (v23(v99.HolyNova) or (872 >= 3092)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\167\15\221\99\226\167\21\197\99\237\167\6\132\88\237\165\2\195\89", "\60\140\200\99\164");
					end
				end
				if ((4404 >= 3252) and v13:IsMoving()) then
					local v174 = 0;
					while true do
						if ((1107 > 796) and (v174 == 0)) then
							v103 = v115();
							if ((959 == 959) and v103) then
								return v103;
							end
							break;
						end
					end
				end
				if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\180\252\5\34\173\144\195\11\52\166\183\245\13\40", "\194\231\148\100\70")]:IsReady() or (245 >= 2204)) then
					if ((3162 >= 2069) and v109.CastCycle(v99.ShadowWordPain, v106, v111, not v14:IsSpellInRange(v99.ShadowWordPain), nil, nil, v101.ShadowWordPainMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\68\192\167\249\223\121\91\206\177\242\247\86\77\200\173\201\203\95\79\205\166\182\204\71\65\192\164\243", "\168\38\44\161\195\150");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\168\243\142\111\30\231\160\23", "\118\224\156\226\22\80\136\214")]:IsReady() and (v105 >= 2)) or (306 > 3081)) then
					if (v23(v99.HolyNova) or (3513 < 2706)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\225\85\153\125\224\86\150\67\174\93\129\79\239\94\133", "\224\34\142\57");
					end
				end
				v130 = 5;
			end
			if ((2978 < 3639) and (v130 == 3)) then
				if ((3682 >= 2888) and v109.AreUnitsBelowHealthPercentage(v43, v44) and v42) then
					if ((149 < 479) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\247\176\2\59\203\211\175\30\38\208", "\163\182\192\109\79")]:IsReady() and v35 and v13:AffectingCombat() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\28\41\12\217\194\59\52\4\243\244\58\37\20\201\243\45", "\149\84\70\96\160")]:CooldownDown() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\16\9\1\244\15\9\31\233\11\3\31\232\54\15\25\244", "\141\88\102\109")]:CooldownDown() and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\155\92\198\105\45\50\71\197\144\91\203\99\14\52\70\196", "\161\211\51\170\16\122\93\53")]:CooldownRemains() > ((v13:GCD() + 0.15) * 3)) and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\211\161\190\49\213\161\164\41", "\72\155\206\210")]:IsAvailable() or (v105 < 5))) then
						if ((1020 >= 567) and v23(v99.Apotheosis)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\71\106\91\26\59\67\117\71\7\32\6\126\85\3\50\65\127", "\83\38\26\52\110");
						end
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\112\24\43\95\126\30\53\67", "\38\56\119\71")]:IsReady() and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\219\224\84\207\11\89\229\238", "\54\147\143\56\182\69")]:IsAvailable() or (v105 < 5))) or (733 > 2469)) then
					if ((2497 == 2497) and v23(v99.HolyFire, not v14:IsSpellInRange(v99.HolyFire), v107)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\142\243\80\224\208\136\237\76\159\210\128\242\72\216\211", "\191\182\225\159\41");
					end
				end
				if ((3901 == 3901) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\14\31\56\76\153\130\195\39\48\36\84\145\130", "\162\75\114\72\53\235\231")]:IsReady() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\164\51\72\251\117\11\158\57", "\98\236\92\36\130\51")]:CooldownDown() and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\140\22\0\163\107\167\163\49", "\80\196\121\108\218\37\200\213")]:IsAvailable() or (v105 < 5))) then
					if ((201 < 415) and v23(v99.EmpyrealBlaze, not v14:IsSpellInRange(v99.HolyFire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\126\18\102\89\11\139\12\76\0\115\74\20\143\64\119\3\114\74\9\143", "\234\96\19\98\31\43\110");
					end
				end
				if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\43\22\92\195\171\115\134\3\12", "\235\102\127\50\167\204\18")]:IsReady() or (133 == 1784)) then
					if (v23(v99.Mindgames, not v14:IsInRange(40), true) or (7 >= 310)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\168\251\39\67\47\93\164\230\99\64\47\93\160\242\38", "\78\48\193\149\67\36");
					end
				end
				v130 = 4;
			end
		end
	end
	local function v119()
		local v131 = 0;
		while true do
			if ((4992 > 286) and (v131 == 2)) then
				if (v109.TargetIsValid() or (2561 == 3893)) then
					local v175 = 0;
					while true do
						if ((4362 >= 1421) and (0 == v175)) then
							v103 = v118();
							if ((75 <= 3546) and v103) then
								return v103;
							end
							break;
						end
					end
				elseif ((2680 <= 3418) and v13:IsMoving()) then
					local v185 = 0;
					while true do
						if ((v185 == 0) or (4288 < 2876)) then
							v103 = v115();
							if ((2462 >= 1147) and v103) then
								return v103;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == 1) or (4914 < 2480)) then
				if (v87 or (1559 == 1240)) then
					local v176 = 0;
					while true do
						if ((566 == 566) and (v176 == 0)) then
							v103 = v109.HandleAfflicted(v99.Purify, v101.PurifyMouseover, 40);
							if ((3921 >= 3009) and v103) then
								return v103;
							end
							v176 = 1;
						end
						if ((2063 >= 1648) and (v176 == 1)) then
							v103 = v109.HandleAfflicted(v99.PowerWordLife, v101.PowerWordLifeMouseover, 40);
							if ((1066 >= 452) and v103) then
								return v103;
							end
							v176 = 2;
						end
						if ((4974 >= 2655) and (v176 == 2)) then
							v103 = v109.HandleAfflicted(v99.HolyWordSerenity, v101.HolyWordSerenityMouseover, 40);
							if (v103 or (2721 <= 907)) then
								return v103;
							end
							v176 = 3;
						end
						if ((4437 >= 3031) and (v176 == 3)) then
							v103 = v109.HandleAfflicted(v99.FlashHeal, v101.FlashHealMouseover, 40, true);
							if (v103 or (4470 < 2949)) then
								return v103;
							end
							break;
						end
					end
				end
				if (v15 or (1580 == 2426)) then
					local v177 = 0;
					while true do
						if ((v177 == 4) or (3711 == 503)) then
							if (v103 or (420 == 4318)) then
								return v103;
							end
							break;
						end
						if ((v177 == 0) or (4158 <= 33)) then
							if (v81 or (99 > 4744)) then
								local v188 = 0;
								while true do
									if ((4341 == 4341) and (v188 == 0)) then
										v103 = v112();
										if ((255 <= 1596) and v103) then
											return v103;
										end
										break;
									end
								end
							end
							if (v35 or (4433 < 1635)) then
								local v189 = 0;
								while true do
									if ((v189 == 0) or (4300 < 3244)) then
										v103 = v116();
										if (v103 or (3534 > 4677)) then
											return v103;
										end
										break;
									end
								end
							end
							v177 = 1;
						end
						if ((v177 == 1) or (4859 < 2999)) then
							v103 = v109.HandleChromie(v99.HolyWordSerenity, v101.HolyWordSerenityMouseover, 40);
							if ((4726 > 2407) and v103) then
								return v103;
							end
							v177 = 2;
						end
						if ((v177 == 3) or (1284 > 3669)) then
							if ((1117 < 2549) and v88) then
								local v190 = 0;
								while true do
									if ((v190 == 1) or (2851 > 4774)) then
										v103 = v109.HandleIncorporeal(v99.ShackleUndead, v101.ShackleUndeadMouseover, 30, true);
										if ((1031 < 3848) and v103) then
											return v103;
										end
										break;
									end
									if ((1854 > 903) and (v190 == 0)) then
										v103 = v109.HandleIncorporeal(v99.DominateMind, v101.DominateMindMouseover, 30, true);
										if ((4663 > 1860) and v103) then
											return v103;
										end
										v190 = 1;
									end
								end
							end
							v103 = v117();
							v177 = 4;
						end
						if ((2 == v177) or (3053 <= 469)) then
							v103 = v109.HandleChromie(v99.FlashHeal, v101.FlashHealMouseover, 40, true);
							if (v103 or (540 >= 1869)) then
								return v103;
							end
							v177 = 3;
						end
					end
				end
				v131 = 2;
			end
			if ((3292 == 3292) and (0 == v131)) then
				v103 = v113();
				if ((1038 <= 2645) and v103) then
					return v103;
				end
				v131 = 1;
			end
		end
	end
	local function v120()
		local v132 = 0;
		while true do
			if ((v132 == 2) or (3230 < 2525)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\195\12\62\21\144\111\23\100\247\37\38\2\150\81\12\99\247\6", "\22\147\99\73\112\226\56\120")]:IsCastable() and v92 and (v13:BuffDown(v99.PowerWordFortitudeBuff, true) or v109.GroupBuffMissing(v99.PowerWordFortitudeBuff))) or (2400 > 4083)) then
					if (v23(v101.PowerWordFortitudePlayer) or (2745 > 4359)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\122\245\240\159\135\98\237\231\137\135\115\237\231\153\177\97\247\241\136", "\237\216\21\130\149");
					end
				end
				break;
			end
			if ((172 <= 1810) and (v132 == 1)) then
				if (v13:IsMoving() or (492 >= 4959)) then
					local v178 = 0;
					while true do
						if ((v178 == 0) or (756 == 2072)) then
							v103 = v115();
							if ((1605 <= 4664) and v103) then
								return v103;
							end
							break;
						end
					end
				end
				if ((1816 == 1816) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					local v179 = 0;
					local v180;
					while true do
						if ((v179 == 0) or (621 > 3100)) then
							v180 = v109.DeadFriendlyUnitsCount();
							if ((v180 > 1) or (1157 >= 4225)) then
								if (v23(v99.MassResurrection, nil, true) or (4986 == 4138)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\14\199\100\95\60\212\114\95\22\212\101\73\0\210\126\67\13", "\44\99\166\23");
								end
							elseif (v23(v99.Resurrection, nil, true) or (2033 <= 224)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\110\242\58\35\33\182\121\244\61\63\60\170", "\196\28\151\73\86\83");
							end
							break;
						end
					end
				end
				v132 = 2;
			end
			if ((v132 == 0) or (1223 == 2011)) then
				if ((4827 > 4695) and v87) then
					local v181 = 0;
					while true do
						if ((3710 > 3065) and (v181 == 2)) then
							v103 = v109.HandleAfflicted(v99.HolyWordSerenity, v101.HolyWordSerenityMouseover, 40);
							if ((2135 <= 2696) and v103) then
								return v103;
							end
							v181 = 3;
						end
						if ((v181 == 0) or (1742 > 4397)) then
							v103 = v109.HandleAfflicted(v99.Purify, v101.PurifyMouseover, 40);
							if ((3900 >= 1904) and v103) then
								return v103;
							end
							v181 = 1;
						end
						if ((v181 == 3) or (1724 == 909)) then
							v103 = v109.HandleAfflicted(v99.FlashHeal, v101.FlashHealMouseover, 40, true);
							if ((1282 < 1421) and v103) then
								return v103;
							end
							break;
						end
						if ((4876 >= 4337) and (v181 == 1)) then
							v103 = v109.HandleAfflicted(v99.PowerWordLife, v101.PowerWordLifeMouseover, 40);
							if ((4005 >= 3005) and v103) then
								return v103;
							end
							v181 = 2;
						end
					end
				end
				if (v15 or (4781 <= 4448)) then
					local v182 = 0;
					while true do
						if ((1317 > 172) and (0 == v182)) then
							if ((4791 == 4791) and v81) then
								local v191 = 0;
								while true do
									if ((3988 > 1261) and (0 == v191)) then
										v103 = v112();
										if ((2240 <= 3616) and v103) then
											return v103;
										end
										break;
									end
								end
							end
							if (v33 or (3988 < 3947)) then
								local v192 = 0;
								while true do
									if ((4644 == 4644) and (v192 == 0)) then
										v103 = v117();
										if ((1323 > 1271) and v103) then
											return v103;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v132 = 1;
			end
		end
	end
	local function v121()
		local v133 = 0;
		while true do
			if ((1619 > 1457) and (v133 == 1)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\68\68\16\254\82\36\50", "\67\65\33\48\100\151\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\232\184\221\254\218\233\186\252\246\211\230\183", "\147\191\135\206\184")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\178\213\209\93\181\151", "\210\228\72\198\161\184\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\90\246\35\106\195\52\70\255\63\117\230\57\89\246", "\174\86\41\147\112\19")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\153\31\44\1\22\184", "\203\59\96\237\107\69\111\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\5\169\192\33\255\195\44\19\163\242\56\227", "\183\68\118\204\129\81\144")];
				v133 = 2;
			end
			if ((v133 == 4) or (2860 < 1808)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\20\103\162\165\223\85", "\203\184\38\96\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\90\87\64\195\60\34", "\174\89\19\25\33")] or "";
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\23\70\90\254\137\12\60", "\107\79\114\50\46\151\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\143\155\40\135\60\229", "\160\89\198\213\73\234\89\215")] or "";
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\116\160\234\204\70\118\167", "\165\40\17\212\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\240\38\50\43\224\138", "\70\133\185\104\83")] or "";
				v133 = 5;
			end
			if ((2 == v133) or (739 >= 1809)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\168\100\240\2\140\9\190", "\226\110\205\16\132\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\211\239\205\73\238\204\243\208\82\195\243", "\33\139\163\128\185")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\93\16\202\94\86\3\205", "\190\55\56\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\119\191\51\10\27\230\252\69\166\47\57\1\236\230\70", "\147\54\207\92\126\115\131")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\52\33\105\4\112\10\34", "\30\109\81\85\29\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\98\81\149\63\204\255\243\116\123\176\30\219\253\243\120\90\177", "\156\159\17\52\214\86\190")];
				v133 = 3;
			end
			if ((1539 <= 4148) and (v133 == 6)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\191\131\120\26\186\143\82\22\159\146\93\1", "\60\115\204\230")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\125\16\58\64\81\75\64\117\20\27\126", "\24\52\20\102\83\46\52")] or 0;
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\202\134\248\34\235\213\209\171\219\47\230", "\138\166\185\227\190\78")];
				v133 = 7;
			end
			if ((v133 == 8) or (434 > 3050)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\213\182\210\80\92\40\71\45", "\50\93\180\218\189\23\46\71")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\86\217\156\255\124\1", "\109\92\37\188\212\154\29")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\71\34\175\23\121", "\110\122\34\67\195\95\41\133")] or 0;
				break;
			end
			if ((v133 == 5) or (3054 < 1683)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\80\62\192\10\66\87", "\169\100\37\36\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\148\167\116\9\145\171\94\5\175\187\93\14", "\48\96\231\194")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\95\26\57\16\214\168\144", "\227\168\58\110\77\121\184\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\53\169\73\191\222\89\188\118\50\151\112", "\197\27\92\223\32\209\187\17")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\216\183\132\183\129\170\200\172\131\158\150\141\196\177", "\228\226\177\193\237\217")] or 0;
				v133 = 6;
			end
			if ((47 < 2706) and (v133 == 3)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\169\168\167\225\186\175", "\220\206\143\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\116\63\20\212\201\253\128\85\40\22\212\197\220\129\85\29", "\178\230\29\77\119\184\172")] or 0;
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\30\15\126\246\242\173", "\152\149\222\106\123\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\47\228\64\185\216\9\240\107\176\220\42\255\77\178\250\52\249\86\165", "\213\189\70\150\35")] or 0;
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\80\96\28\70\91\115\27", "\104\47\53\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\67\150\25\174\38\173\74\148\15\181\0\173\121\146\29\187\10", "\111\195\44\225\124\220")] or "";
				v133 = 4;
			end
			if ((1519 >= 580) and (v133 == 7)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\52\184\37\177\42\195\57\181\30\137", "\98\166\88\217\86\217")] or 0;
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\154\90\42\13\225\213", "\141\186\233\63\98\108")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\206\133\134\151\38", "\118\16\175\233\233\223")] or 0;
				v133 = 8;
			end
			if ((0 == v133) or (3110 == 4177)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\75\75\75\185\199\89\145", "\62\226\46\63\63\208\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\28\70\147\26\31\46\74\224\41\71\130\6\8\61\118\213", "\62\133\121\53\227\127\109\79")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\17\38\225\223\160\165\3", "\194\112\116\82\149\182\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\187\73\57\206\229\11\53\161\79\62\197\227\26\49\173\94", "\110\89\200\44\120\160\130")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\152\198\95\82\74\68\60\94", "\45\203\163\43\38\35\42\91")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\150\217\1\136\173\77\243\139\216\16\136\188\88", "\52\178\229\188\67\231\201")];
				v133 = 1;
			end
		end
	end
	local function v122()
		local v134 = 0;
		while true do
			if ((4200 > 2076) and (v134 == 4)) then
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\27\200\194\1\49\53\220\205\32\37\53\207\202\7\29\12", "\85\92\189\163\115")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\10\138\3\86\44\214\10\134\18\83\47\220\61", "\186\78\227\112\38\73")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\203\19\241\189\81\128\204\30\202\172\95\130\221", "\48\236\184\118\185\216")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\149\226\37\170\211\84\174\243\43\168\194\116\141", "\60\221\135\68\198\167")] or 0;
				v134 = 5;
			end
			if ((2 == v134) or (601 >= 2346)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\188\238\216\241\12\98\124\144\178\238\215\199\23\121\119\173\148\240\206\211\19", "\24\195\211\130\161\166\99\16")] or 0;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\53\0\58\6\44\228\17\10\0\13\19\252\40\6\6\0\38\228", "\64\157\70\101\114\105")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\95\80\161\244\164\48\40\99\93\182\192\191\43\42\73\116\136", "\66\76\48\60\216\163\203")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\37\95\85\129\162\56\87\127\183\163\41\71\69\176\180\13\65\67\163\189", "\214\205\74\51\44")] or 0;
				v134 = 3;
			end
			if ((3970 <= 4354) and (v134 == 1)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\148\161\108\4\139\189\115\4\149\160\119\14\149\161\74\2\147\189", "\36\107\231\196")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\162\49\106\62\162\47\119\58\168\47\118\7\164\41\106\33\157", "\19\105\205\93")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\216\196\230\160\199\216\249\160\217\197\253\174\199\215\207\187\194\206\192", "\174\207\171\161")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\6\234\21\27\6\244\8\31\8\234\26\45\29\239\3\34\33\214", "\108\76\105\134")] or 0;
				v134 = 2;
			end
			if ((v134 == 3) or (1542 < 208)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\181\168\158\36\18\8\163\191\129\48\59\20\167\161\167\56\20", "\115\113\198\205\206\86")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\155\209\55\57\191\26\178\161\213\47\48\164\59\179\161\224", "\85\212\233\176\78\92\205")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\218\167\37\250\69\45\197\179\12\230\65\51\227\187\35\196\82\48\255\165", "\95\138\213\68\131\32")] or 0;
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\108\229\74\40\112\229\86\31\105\237\74\37\109\209\75\45\126\225", "\56\76\25\132")] or "";
				v134 = 4;
			end
			if ((1612 <= 2926) and (v134 == 5)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\204\68\234\70\63\213\77\195\81\233", "\151\56\165\55\154\35\83")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\102\44\145\230\143\165\23\218\102", "\118\182\21\73\195\135\236\204")];
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\181\202\254\47\46\131\160\166\178\220", "\203\195\198\175\170\93\71\237")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\90\233\202\167\7\70\88\116\238\200\170\8\87\124\118", "\25\18\136\164\195\107\35")];
				v134 = 6;
			end
			if ((v134 == 6) or (2006 <= 540)) then
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\237\37\222\4\217\171\35\239\36\200\24\211\144\40\237\39", "\226\77\140\75\186\104\188")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\206\115\42\183\85\116\47\182\218\70\13\166\93\119\40", "\70\216\189\22\98\210\52\24")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\58\25\232\240\49\31\212\246\43\17\235\247\17\25\233\252", "\132\153\95\120")] or "";
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\6\35\229\246\202\231\51\45\253\246\203\238\43\18", "\164\128\99\66\137\159")] or 0;
				v134 = 7;
			end
			if ((v134 == 0) or (2412 == 4677)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\130\68\192\45\51\191\174\82\215\50\39\147\178\89\193\20\47\185", "\222\215\55\165\125\65")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\149\152\4\215\124\100\138\140\40\203\119\114\172\132\2\230\73", "\22\197\234\101\174\25")] or 0;
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\7\195\204\131\182\245\39\206\27\212\248\160\168\246\48", "\85\153\116\166\156\236\193\144")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\130\108\90\192\152\187\202\49\161\114\89\215\135\132", "\184\85\237\27\63\178\207\212")] or 0;
				v134 = 1;
			end
			if ((v134 == 7) or (4897 <= 1972)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\160\162\47\135\228\245\171\132\168\13\140\213\255\171\167\174\11\157\247\245", "\144\217\211\199\127\232\147")];
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\203\66\27\210\203\87\58\197\217\83\58\231\202\70\38\210\202", "\95\183\184\39")];
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\176\204\81\85\250\166", "\52\158\195\169\23")] or 0;
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\160\237\199\92\184", "\20\232\193\137\162")] or 0;
				v134 = 8;
			end
			if ((3101 <= 3584) and (v134 == 8)) then
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\188\171\33\250\230\233\198", "\177\111\207\206\115\159\136\140")];
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\62\227\23\239\30\243", "\86\163\91\141\114\152")] or 0;
				break;
			end
		end
	end
	local function v123()
		local v135 = 0;
		while true do
			if ((v135 == 3) or (1568 >= 4543)) then
				if ((4258 >= 1841) and v34) then
					v105 = #v104;
				else
					v105 = 1;
				end
				v107 = v13:BuffDown(v99.EmpyrealBlazeBuff);
				v108 = v13:BuffDown(v99.SurgeofLight);
				if (not v13:IsChanneling() or (3052 >= 3554)) then
					if (v13:AffectingCombat() or (2098 > 3885)) then
						local v186 = 0;
						while true do
							if ((v186 == 0) or (2970 == 1172)) then
								v103 = v119();
								if ((3913 > 3881) and v103) then
									return v103;
								end
								break;
							end
						end
					elseif ((4932 >= 1750) and v33) then
						local v187 = 0;
						while true do
							if ((v187 == 1) or (135 == 1669)) then
								v103 = v118();
								if ((4802 >= 109) and v103) then
									return v103;
								end
								break;
							end
							if ((v187 == 0) or (3911 > 4952)) then
								v103 = v120();
								if (v103 or (265 > 4194)) then
									return v103;
								end
								v187 = 1;
							end
						end
					end
				end
				break;
			end
			if ((2655 <= 2908) and (v135 == 2)) then
				if ((963 > 651) and not v13:IsMoving()) then
					v98 = GetTime();
				end
				if (v13:AffectingCombat() or v81 or (3503 <= 195)) then
					local v183 = 0;
					local v184;
					while true do
						if ((1382 <= 4404) and (v183 == 0)) then
							v184 = v81 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\60\231\239\129\119\21", "\17\108\146\157\232")]:IsReady() and v36;
							if ((v109.IsTankBelowHealthPercentage(v80) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\108\214\21\255\43\161\74\205\39\253\38\186\66\215", "\200\43\163\116\141\79")]:IsReady() and ((v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\139\55\51\136\240\219\237\179\47", "\131\223\86\93\227\208\148")) or (v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\215\68\184\189\93\180\237\65\246\133\24\185\229", "\213\131\37\214\214\125")))) or (4857 <= 767)) then
								local v193 = 0;
								while true do
									if ((v193 == 0) or (4018 > 4021)) then
										v103 = v109.FocusUnit(v184, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\18\10\11\148", "\129\70\75\69\223"), 20);
										if (v103 or (2270 == 1932)) then
											return v103;
										end
										break;
									end
								end
							elseif (((v13:HealthPercentage() < v80) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\97\222\242\251\120\230\71\197\192\249\117\253\79\223", "\143\38\171\147\137\28")]:IsReady() and (v79 == LUAOBFUSACTOR_DECRYPT_STR_0("\228\131\183\248\67\226\218\212\194\138\246\15\229", "\180\176\226\217\147\99\131"))) or (3430 <= 1176)) then
								local v194 = 0;
								while true do
									if ((v194 == 0) or (1198 >= 3717)) then
										v103 = v109.FocusUnit(v184, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\251\156\14\43\246\139", "\103\179\217\79"), 20);
										if ((3730 >= 1333) and v103) then
											return v103;
										end
										break;
									end
								end
							else
								local v195 = 0;
								while true do
									if ((v195 == 0) or (2152 == 2797)) then
										v103 = v109.FocusUnit(v184, nil, nil, nil, 20);
										if (v103 or (1709 < 588)) then
											return v103;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v106 = v13:GetEnemiesInRange(40);
				v104 = v13:GetEnemiesInMeleeRange(12);
				v135 = 3;
			end
			if ((v135 == 1) or (3575 <= 3202)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\210\11\38\62\64\2\105", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\231\35", "\196\145\131\80\67")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\191\1\15\20\237\13", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\131\221\83\170\94", "\49\24\234\174\35\207\50\93")];
				if (v13:IsDeadOrGhost() or (4397 < 3715)) then
					return;
				end
				if (v13:IsMounted() or (4075 <= 2245)) then
					return;
				end
				v135 = 2;
			end
			if ((v135 == 0) or (3966 > 4788)) then
				v121();
				v122();
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\4\115\116\54\86\24", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\130\255\134", "\93\237\144\229\143")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\249\247\30\7\67\6", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\180\235", "\90\77\219\142")];
				v135 = 1;
			end
		end
	end
	local function v124()
		local v136 = 0;
		while true do
			if ((3826 > 588) and (v136 == 1)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\37\86\59\39\101\200\31\80\50\45\49\184\53\25\33\126\116\168\67\11\121\110\117\184\47\64\119\28\42\247\0\114", "\152\109\57\87\94\69"));
				break;
			end
			if ((694 <= 1507) and (v136 == 0)) then
				v110();
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\98\184\16\204\1\188\177\67\178\15\193\1\142\186\10\146\12\220\66\204\129\69\184\17\254", "\195\42\215\124\181\33\236"));
				v136 = 1;
			end
		end
	end
	v21.SetAPL(257, v123, v124);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\220\199\3\187\129\226\70\161\252\196\30\156\150\221\88\177\183\219\31\162", "\200\153\183\106\195\222\178\52")]();

