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
		if ((v5 == 1) or (2258 <= 1875)) then
			return v6(...);
		end
		if ((1173 > 41) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (56 >= 3208)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\213\23\212\208\207\26\194\178\212\29\216\211\215\44\232\190\137\18\196\194", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\32\179\133\51", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\4\192\47\154\38", "\232\73\161\76")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v27 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v28 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\206\33\50\141\181\13", "\156\168\78\64\224\212\121")];
	local v29;
	local v30;
	local v31;
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
	local v94;
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = 0;
	local v101 = 0;
	local v102 = false;
	RampRaptureTimes = {};
	RampRaptureTimes[2683] = {70,170,270};
	RampEvangelismTimes = {};
	RampEvangelismTimes[2683] = {135,225,397};
	RampBothTimes = {};
	RampBothTimes[2680] = {15,145,250};
	RampBothTimes[2682] = {15,120,195,285};
	RampBothTimes[2684] = {15,185,350};
	RampBothTimes[2687] = {5,115,205,295};
	RampBothTimes[2688] = {45,140,230};
	RampBothTimes[2689] = {105,205,305};
	RampBothTimes[2693] = {15,125,185,245};
	RampBothTimes[2685] = {78,175,269,358};
	local v113 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\55\252\172\203\20\250", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\114\33\76\59\44\78\244\95\38\90", "\152\54\72\63\88\69\62")];
	local v114 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\228\214\231\89\199\208", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\87\22\42\46\253\30\81\80\0", "\114\56\62\101\73\71\141")];
	local v115 = v25[LUAOBFUSACTOR_DECRYPT_STR_0("\136\251\210\193\171\253", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\239\34\177\175\238\7\219\232\52", "\107\178\134\81\210\198\158")];
	local v116 = {};
	local v117;
	local v118, v119;
	local v120, v121;
	local v122, v123;
	local v124, v125;
	local v126, v127, v128, v129, v130, v131;
	local v132, v133, v134;
	local v135 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\27\1\143\203\165\54\29", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\25\135\229\211\204\1\135", "\170\163\111\226\151")];
	local function v136()
		if ((4313 > 3373) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\56\61\162\42\65\33\44\21\0\167\42\71\49\48", "\73\113\80\210\88\46\87")]:IsAvailable()) then
			v135[LUAOBFUSACTOR_DECRYPT_STR_0("\165\37\222\2\226\141\32\204\16\235\132\8\200\16\242\135\42\222", "\135\225\76\173\114")] = v20.MergeTable(v135.DispellableMagicDebuffs, v135.DispellableDiseaseDebuffs);
		else
			v135[LUAOBFUSACTOR_DECRYPT_STR_0("\62\228\171\160\169\177\171\27\239\180\181\136\184\165\15\235\190\163", "\199\122\141\216\208\204\221")] = v135[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\219\172\218\25\243\92\243\175\200\22\246\107", "\150\205\189\112\144\24")];
		end
	end
	v10:RegisterForEvent(function()
		v136();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\4\167\139\101\50\173\46\32\9\165\134\105\54\183\34\32\0\167\150\109\40\161\43\49\17\173\144\98\59\171\57\49\11\163\154\104", "\112\69\228\223\44\100\232\113"));
	local function v137(v157)
		return v157:DebuffRefreshable(v113.ShadowWordPain) and (v157:TimeToDie() >= 12);
	end
	local function v138()
		return false;
	end
	local function v139()
		if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\228\10\21\218\176\101", "\230\180\127\103\179\214\28")]:IsReady() and v97 and v135.DispellableFriendlyUnit()) or (4493 == 2225)) then
			if ((3104 >= 3092) and v24(v115.PurifyFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\156\16\77\79\226\88\160\136\12\76\86\225\77", "\128\236\101\63\38\132\33");
			end
		end
	end
	local function v140()
		local v158 = 0;
		while true do
			if ((3548 > 3098) and (v158 == 1)) then
				if ((v114[LUAOBFUSACTOR_DECRYPT_STR_0("\150\247\192\206\46\198\161\106\177\252\196", "\30\222\146\161\162\90\174\210")]:IsReady() and v48 and (v13:HealthPercentage() <= v49)) or (3252 == 503)) then
					if ((4733 > 2066) and v24(v115.Healthstone, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\75\113\6\241\70\99\30\234\64\117\74\225\75\118\15\235\93\121\28\224\14\35", "\106\133\46\16");
					end
				end
				if ((3549 >= 916) and v30 and (v13:HealthPercentage() <= v32)) then
					if ((v31 == LUAOBFUSACTOR_DECRYPT_STR_0("\106\37\117\238\95\83\80\41\125\251\26\104\93\33\127\245\84\71\24\16\124\232\83\79\86", "\32\56\64\19\156\58")) or (2189 <= 245)) then
						if (v114[LUAOBFUSACTOR_DECRYPT_STR_0("\104\205\227\68\95\225\136\83\198\226\126\95\243\140\83\198\226\102\85\230\137\85\198", "\224\58\168\133\54\58\146")]:IsReady() or (1389 > 3925)) then
							if ((4169 >= 3081) and v24(v115.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\75\83\77\239\112\149\143\2\87\81\11\245\112\135\139\2\87\81\11\237\122\146\142\4\87\22\79\248\115\131\137\24\80\64\78\189\33", "\107\57\54\43\157\21\230\231");
							end
						end
					end
				end
				break;
			end
			if ((349 <= 894) and (v158 == 0)) then
				if ((731 <= 2978) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\138\168\21\65", "\175\204\201\113\36\214\139")]:IsReady() and v46 and (v13:HealthPercentage() <= v47)) then
					if (v24(v113.Fade, nil, nil, true) or (892 > 3892)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\205\49\217\68\67\201\51\217\10\84\197\35\217", "\100\39\172\85\188");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\137\125\170\144\54\191\121\173\133\3\191\121\160\133\33", "\83\205\24\217\224")]:IsReady() and v44 and (v13:HealthPercentage() <= v45)) or (4466 == 900)) then
					if (v24(v113.DesperatePrayer) or (2084 >= 2888)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\192\222\45\227\215\204\41\227\250\221\47\231\220\200\47\166\193\200\59\227\203\222\52\240\192", "\93\134\165\173");
					end
				end
				v158 = 1;
			end
		end
	end
	local function v141()
		local v159 = 0;
		while true do
			if ((479 < 1863) and (v159 == 1)) then
				ShouldReturn = v135.HandleBottomTrinket(v116, v96, 40, nil);
				if (ShouldReturn or (2428 >= 4038)) then
					return ShouldReturn;
				end
				break;
			end
			if ((v159 == 0) or (2878 > 2897)) then
				ShouldReturn = v135.HandleTopTrinket(v116, v96, 40, nil);
				if (ShouldReturn or (2469 > 3676)) then
					return ShouldReturn;
				end
				v159 = 1;
			end
		end
	end
	local function v142()
		if ((233 < 487) and ((GetTime() - v100) > v36)) then
			local v186 = 0;
			while true do
				if ((2473 >= 201) and (v186 == 0)) then
					if ((4120 >= 133) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\249\132\21\236\184\210\203\232\132\4\249", "\175\187\235\113\149\217\188")]:IsAvailable() and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\12\160\150\73\241\78\119\46\171\178\68\234\124\116\56", "\24\92\207\225\44\131\25")]:IsReady() and v35 and v13:BuffDown(v113.AngelicFeatherBuff) and v13:BuffDown(v113.BodyandSoulBuff)) then
						if ((3080 >= 1986) and v24(v115.PowerWordShieldPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\91\220\175\73\9\66\92\220\170\72\36\110\67\218\189\64\31\66\91\223\185\85\30\111\11\222\183\90\30", "\29\43\179\216\44\123");
						end
					end
					if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\156\215\39\73\177\208\35\106\184\216\52\68\184\203", "\44\221\185\64")]:IsReady() and v34 and v13:BuffDown(v113.AngelicFeatherBuff) and v13:BuffDown(v113.BodyandSoulBuff) and v13:BuffDown(v113.AngelicFeatherBuff)) or (1439 > 3538)) then
						if (v24(v115.AngelicFeatherPlayer) or (419 < 7)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\0\233\79\90\127\8\228\119\89\118\0\243\64\90\97\62\247\68\94\106\4\245\8\82\124\23\226", "\19\97\135\40\63");
						end
					end
					break;
				end
			end
		end
	end
	local function v143(v160)
		if ((2820 == 2820) and v132:IsReady()) then
			local v187 = 0;
			while true do
				if ((0 == v187) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v15 and (v15:HealthPercentage() <= v61)) then
						if (v13:BuffUp(v113.ShadowCovenantBuff) or (1482 >= 4288)) then
							if (v24(v115.DarkReprimandFocus) or (2462 > 4426)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\170\93\33\48\16\35\171\76\33\50\34\48\160\88\12\61\32\50\187\79\115\43\42\63\175\82\48\62", "\81\206\60\83\91\79");
							end
						elseif ((4774 == 4774) and v24(v115.PenanceFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\94\174\222\115\33\192\72\155\72\164\211\103\60\131\93\161\64\170\222\113\42", "\196\46\203\176\18\79\163\45");
						end
					end
					if ((566 <= 960) and not v160 and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v62, false, false) <= v63)) then
						if (v24(v132, not v14:IsSpellInRange(v132)) or (2910 <= 1930)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\168\39\112\31\42\248\234\248\50\123\16\37\245\236\189", "\143\216\66\30\126\68\155");
						end
					end
					break;
				end
			end
		end
	end
	local function v144()
		local v161 = 0;
		while true do
			if ((v161 == 0) or (19 > 452)) then
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\154\199\26\206\215\148\216\243\174\250\12\207\204\162\217\226\175", "\129\202\168\109\171\165\195\183")]:IsReady() and v64 and v135.AreUnitsBelowHealthPercentage(v65, v66) and v13:BuffUp(v113.RadiantProvidenceBuff)) or (907 > 3152)) then
					if (v24(v115.PowerWordRadianceFocus, nil, v124) or (2505 > 4470)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\87\32\221\204\43\241\45\74\51\231\204\21\226\43\89\57\219\219\43\239\44\75\35\217\208\0\166\42\93\54\212\225\23\233\45\84\51\215\201\26", "\134\66\56\87\184\190\116");
					end
				end
				if ((v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\29\63\16\180\23\238", "\85\92\81\105\219\121\139\65")) or (3711 > 4062)) then
					if ((420 == 420) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\205\178\89\75\79\202\237\163\66\64\111\204\244\188\94", "\191\157\211\48\37\28")]:IsReady() and v15:BuffDown(v113.PainSuppression) and v67 and (v15:HealthPercentage() <= v68)) then
						if (v24(v115.PainSuppressionFocus, nil, nil, true) or (33 >= 3494)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\207\30\253\18\5\204\10\228\12\40\218\12\231\21\53\209\95\252\25\59\211\32\247\19\53\211\27\251\11\52", "\90\191\127\148\124");
						end
					end
				elseif ((v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\76\134\32\28\56\168\32\27\97", "\119\24\231\78")) or (1267 == 4744)) then
					if ((2428 < 3778) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\178\44\172\68\239\85\1\146\63\160\89\207\73\30\140", "\113\226\77\197\42\188\32")]:IsReady() and v15:BuffDown(v113.PainSuppression) and v67 and (v15:HealthPercentage() <= v68) and (Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\14\55\218\158", "\213\90\118\148"))) then
						if (v24(v115.PainSuppressionFocus, nil, nil, true) or (2946 <= 1596)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\75\47\189\88\114\72\59\164\70\95\94\61\167\95\66\85\110\188\83\76\87\17\183\89\66\87\42\187\65\67", "\45\59\78\212\54");
						end
					end
				elseif ((4433 > 3127) and (v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\36\87\141\128\198\47\163\244\80\101\134\135\128", "\144\112\54\227\235\230\78\205"))) then
					if ((4300 >= 2733) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\131\41\6\242\227\78\163\56\29\249\195\72\186\39\1", "\59\211\72\111\156\176")]:IsReady() and v15:BuffDown(v113.PainSuppression) and v67 and (v15:HealthPercentage() <= v68) and ((Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\122\166\205\6", "\77\46\231\131")) or (Commons.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\146\113\151\108\159\102", "\32\218\52\214")))) then
						if ((4829 == 4829) and v24(v115.PainSuppressionFocus, nil, nil, true)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\94\22\56\166\206\163\80\74\94\5\52\187\226\185\74\84\14\31\52\169\253\143\70\85\65\27\53\167\230\190", "\58\46\119\81\200\145\208\37");
						end
					end
				end
				v161 = 1;
			end
			if ((1683 <= 4726) and (v161 == 1)) then
				if ((4835 >= 3669) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\27\131\39\169\187\138\57\57\136\28\165\175\184", "\86\75\236\80\204\201\221")]:IsReady() and v70 and (v15:HealthPercentage() <= v71) and v15:Exists()) then
					if ((2851 > 1859) and v24(v115.PowerWordLifeFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\98\78\96\128\236\180\101\78\101\129\193\135\123\71\114\197\246\142\115\77\72\134\241\132\126\69\120\146\240", "\235\18\33\23\229\158");
					end
				end
				if ((3848 > 2323) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\124\175\204\178\94\181\212\168\114\187\211\169\89\191\211", "\219\48\218\161")]:IsReady() and v72 and v135.AreUnitsBelowHealthPercentage(v73, v74)) then
					if ((2836 > 469) and v24(v113.LuminousBarrier)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\100\113\64\213\64\245\247\78\126\72\201\93\233\225\99\60\65\222\78\236\219\114\115\70\215\75\239\243\127", "\128\132\17\28\41\187\47");
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v162 = 0;
		while true do
			if ((v162 == 3) or (2096 <= 540)) then
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\216\2\78\251\201\213\141\60\236\62\81\247\222\238\134", "\78\136\109\57\158\187\130\226")]:IsReady() and (v135.UnitGroupRole(v15) == LUAOBFUSACTOR_DECRYPT_STR_0("\10\30\215\218", "\145\94\95\153")) and (v15:HealthPercentage() < v86) and (v15:BuffDown(v113.AtonementBuff) or v15:BuffDown(v113.PowerWordShield)) and v15:Exists()) or (3183 < 2645)) then
					if ((3230 <= 3760) and v24(v115.PowerWordShieldFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\194\3\208\92\136\234\194\6\209\113\164\245\196\17\217\74\136\233\204\26\222\14\191\248\204\24", "\215\157\173\116\181\46");
					end
				end
				if ((3828 == 3828) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\19\184\138\225\210\29\177\138\254", "\186\85\212\235\146")]:IsReady() and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\224\136\24\250\48\224\95\234\132\23\242\42", "\56\162\225\118\158\89\142")]:IsAvailable() and (v15:GUID() ~= v13:GUID()) and v15:BuffDown(v113.AtonementBuff) and v13:BuffDown(v113.AtonementBuff) and (v15:HealthPercentage() < v80) and v15:Exists()) then
					if ((554 == 554) and v24(v115.FlashHealFocus, nil, v125)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\9\193\188\42\231\84\0\193\163\98\208\89\4\204", "\184\60\101\160\207\66");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\1\141\107\185\35\181\115\174\53\177\116\181\52\142\120", "\220\81\226\28")]:IsReady() and (v15:HealthPercentage() < v85) and v15:BuffDown(v113.AtonementBuff) and v15:Exists()) or (2563 == 172)) then
					if ((3889 >= 131) and v24(v115.PowerWordShieldFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\218\149\254\248\248\4\218\144\255\213\212\27\220\135\247\238\135\27\208\131\247", "\167\115\181\226\155\138");
					end
				end
				v162 = 4;
			end
			if ((v162 == 0) or (492 == 4578)) then
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\49\61\17\63\79\54\61\20\62\111\0\54\15\59\83\2\55", "\61\97\82\102\90")]:IsReady() and v64 and v135.AreUnitsBelowHealthPercentage(v65, v66) and v13:BuffUp(v113.RadiantProvidenceBuff) and v15:Exists()) or (4112 < 1816)) then
					if ((4525 >= 1223) and v24(v115.PowerWordRadianceFocus, nil, v124)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\33\188\78\213\104\9\6\190\42\148\89\198\83\23\8\162\45\174\116\206\89\13\29\173\32\191\11\207\82\31\5\147\45\164\68\203\83\17\30\162", "\105\204\78\203\43\167\55\126");
					end
				end
				if ((1090 <= 4827) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\149\165\52\27\1\51\200\67\161\134\42\24\22", "\49\197\202\67\126\115\100\167")]:IsReady() and v70 and (v15:HealthPercentage() <= v71) and v15:Exists()) then
					if (v24(v115.PowerWordLifeFocus) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\84\200\44\146\105\73\56\73\219\22\140\95\88\50\27\215\44\129\90\97\52\84\208\37\132\89\73\57", "\62\87\59\191\73\224\54");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\215\13\237\204\245\53\245\219\227\48\251\205\238\3\244\202\226", "\169\135\98\154")]:IsReady() and v64 and v135.AreUnitsBelowHealthPercentage(v65, v66) and v15:BuffDown(v113.AtonementBuff) and v15:Exists()) or (3710 >= 3738)) then
					if (v24(v115.PowerWordRadianceFocus, nil, v124) or (3838 < 2061)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\120\51\81\239\12\223\196\101\32\107\239\50\204\194\118\42\87\248\115\154\139\127\33\85\241", "\168\171\23\68\52\157\83");
					end
				end
				v162 = 1;
			end
			if ((v162 == 2) or (690 > 1172)) then
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\15\56\212\85\45\43\217\82\57\35", "\59\74\78\181")]:IsReady() and v96 and v75 and v13:AffectingCombat() and (v135.FriendlyUnitsBelowHealthPercentageCount(v76) > v77) and not v13:IsInRaid() and v13:IsInParty() and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v62, false, false) <= v63)) or (1592 > 2599)) then
					if ((3574 <= 4397) and v24(v113.Evangelism)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\199\91\84\180\32\221\83\73\190\101\217\95\91\191", "\211\69\177\58\58");
					end
				end
				if ((3135 > 1330) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\145\233\120\230\225\227\178\228\117", "\171\215\133\25\149\137")]:IsReady() and (v15:BuffDown(v113.AtonementBuff) or (v15:BuffDown(v113.PowerWordShield) and v15:BuffDown(v113.Renew))) and (v15:HealthPercentage() < v79) and v13:BuffUp(v113.SurgeofLight) and v15:Exists()) then
					if (v24(v115.FlashHealFocus, nil, v125) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\196\51\233\231\15\244\71\224\196\13\243\225\35\232\67\239\220\114\242\234\49\240", "\34\129\168\82\154\143\80\156");
					end
				end
				if ((1724 == 1724) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\183\179\35\31\93\92\140", "\233\229\210\83\107\40\46")]:IsReady() and not v13:IsInRaid() and v13:IsInParty() and v81 and v96 and v13:AffectingCombat() and (v15:HealthPercentage() < v82) and (v135.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v113.AtonementBuff, v62, false, false) >= v83) and v15:BuffDown(v113.AtonementBuff) and v15:Exists()) then
					if ((455 <= 1282) and v24(v115.RaptureFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\67\34\194\16\211\71\114\222\0\192\78", "\101\161\34\82\182");
					end
				end
				v162 = 3;
			end
			if ((4606 < 4876) and (v162 == 1)) then
				if ((v134:IsReady() and v135.TargetIsValid() and v14:IsInRange(30) and v57 and v135.AreUnitsBelowHealthPercentage(v58, v59)) or (1442 > 2640)) then
					if ((136 < 3668) and v24(v115.HaloPlayer, not v15:IsInRange(30), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\112\249\162\101\37\130\245\125", "\231\148\17\149\205\69\77");
					end
				end
				if ((v133:IsReady() and v135.TargetIsValid() and v14:IsInRange(30) and v60 and not v15:IsFacingBlacklisted()) or (1784 > 4781)) then
					if ((4585 > 3298) and v24(v115.DivineStarPlayer)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\174\209\242\89\250\191\180\211\250\69\191\136\162\198\247", "\159\224\199\167\155\55");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\194\255\40\219\250\242\40\215\199\246\50\219\227\246\50\209\242", "\178\151\147\92")]:IsReady() and v96 and v13:AffectingCombat() and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v91, false, false) >= v92)) or (1664 > 1698)) then
					if (v24(v113.UltimatePenitence) or (3427 < 2849)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\153\241\88\59\31\77\110\137\194\92\55\28\69\110\137\243\79\55\82\68\127\141\241", "\26\236\157\44\82\114\44");
					end
				end
				v162 = 2;
			end
			if ((3616 <= 4429) and (v162 == 4)) then
				if ((3988 >= 66) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\208\39\233\89\108", "\166\130\66\135\60\27\17")]:IsReady() and (v15:HealthPercentage() < v84) and v15:BuffDown(v113.AtonementBuff) and v15:BuffDown(v113.Renew) and v15:Exists()) then
					if (v24(v115.RenewFocus) or (862 > 4644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\79\192\112\39\4\66\203\116\60", "\80\36\42\174\21");
					end
				end
				if ((1221 == 1221) and v132:IsReady() and v95 and (not v13:AffectingCombat() or not v135.TargetIsValid()) and (v15:HealthPercentage() < v61) and v15:Exists()) then
					local v217 = 0;
					while true do
						if ((v217 == 0) or (45 > 1271)) then
							ShouldReturn = v143(true);
							if ((3877 > 1530) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\104\28\54\105\70\56\50\123\66", "\26\46\112\87")]:IsReady() and v95 and (not v13:AffectingCombat() or not v135.TargetIsValid()) and (v15:HealthPercentage() < v78) and v15:Exists()) or (4798 == 1255)) then
					if (v24(v115.FlashHealFocus, nil, true) or (2541 > 2860)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\47\170\103\183\128\77\177\184\47\148\123\176\188\5\188\188\34\167", "\212\217\67\203\20\223\223\37");
					end
				end
				break;
			end
		end
	end
	local function v146()
		local v163 = 0;
		while true do
			if ((v163 == 7) or (2902 > 3629)) then
				if ((427 < 3468) and v13:IsMoving()) then
					local v218 = 0;
					while true do
						if ((4190 >= 2804) and (v218 == 0)) then
							ShouldReturn = v142();
							if ((2086 == 2086) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((4148 > 2733) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\51\211\101\75\6\242\127\73\52\207\116\71\6\194", "\44\99\166\23")]:IsReady() and v14:DebuffRefreshable(v113.PurgeTheWickedDebuff)) then
					if ((3054 >= 1605) and v24(v113.PurgeTheWicked, not v14:IsSpellInRange(v113.PurgeTheWicked))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\108\226\59\49\54\155\104\255\44\9\36\173\127\252\44\50\12\169\115\225\44\59\54\170\104\183\45\55\62\165\123\242", "\196\28\151\73\86\83");
					end
				end
				if ((1044 < 1519) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\192\11\40\20\141\79\47\121\225\7\25\17\139\86", "\22\147\99\73\112\226\56\120")]:IsReady()) then
					if ((1707 <= 4200) and v24(v113.ShadowWordPain, not v14:IsSpellInRange(v113.ShadowWordPain))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\125\227\241\130\175\74\245\250\159\188\74\242\244\132\182\74\239\250\155\189\120\231\251\153\248\113\227\248\140\191\112", "\237\216\21\130\149");
					end
				end
				break;
			end
			if ((580 == 580) and (v163 == 5)) then
				if ((601 <= 999) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\6\27\38\81\140\134\207\46\1", "\162\75\114\72\53\235\231")]:IsReady() and ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\161\53\74\230\81\7\130\56\65\240", "\98\236\92\36\130\51")]:CooldownRemains() > v113[LUAOBFUSACTOR_DECRYPT_STR_0("\137\16\2\190\66\169\184\53\183", "\80\196\121\108\218\37\200\213")]:Cooldown()) or (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\51\123\3\123\68\25\172\9\118\12\123", "\234\96\19\98\31\43\110")]:CooldownRemains() > v113[LUAOBFUSACTOR_DECRYPT_STR_0("\43\22\92\195\171\115\134\3\12", "\235\102\127\50\167\204\18")]:Cooldown())) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\99\169\244\55\80\43\66\164\241\19\65\60\83\164\229\55\77\33\94\178", "\78\48\193\149\67\36")]:IsAvailable()) then
					if ((3970 == 3970) and v24(v113.Mindgames, not v14:IsSpellInRange(v113.Mindgames), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\23\142\28\70\49\19\133\11\1\97\94\132\25\76\49\25\133", "\33\80\126\224\120");
					end
				end
				if ((v134:IsReady() and v135.TargetIsValid() and v14:IsInRange(30)) or (98 == 208)) then
					if ((2006 <= 3914) and v24(v115.HaloPlayer, not v14:IsInRange(30), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\169\15\203\28\232\169\14\197\91\233", "\60\140\200\99\164");
					end
				end
				if ((v133:IsReady() and v135.TargetIsValid() and v14:IsInRange(30) and not v14:IsFacingBlacklisted()) or (3101 <= 2971)) then
					if (v24(v115.DivineStarPlayer, not v14:IsInRange(30)) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\253\18\47\172\130\203\23\50\163\149\180\0\39\175\134\243\1", "\194\231\148\100\70");
					end
				end
				v163 = 6;
			end
			if ((3305 > 95) and (v163 == 0)) then
				ShouldReturn = v135.InterruptWithStun(v113.PsychicScream, 8);
				if ((2727 == 2727) and ShouldReturn) then
					return ShouldReturn;
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\158\132\187\194\191\129\133\211\189\132\171", "\178\218\237\200")]:IsReady() and v97 and v38 and not v13:IsCasting() and not v13:IsChanneling() and v135.UnitHasMagicBuff(v14)) or (2970 >= 4072)) then
					if ((3881 > 814) and v24(v113.DispelMagic, not v14:IsSpellInRange(v113.DispelMagic))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\188\245\192\179\185\217\221\183\178\239\211\246\177\231\221\183\178\227", "\176\214\213\134");
					end
				end
				v163 = 1;
			end
			if ((v163 == 4) or (4932 < 4868)) then
				if ((3667 <= 4802) and v132:IsReady() and (v135.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v113.AtonementBuff, v62, false, false) < v63)) then
					if ((1260 >= 858) and v24(v132, not v14:IsSpellInRange(v132))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\198\251\228\34\195\91\131\241\228\33\193\89\198", "\160\62\163\149\133\76");
					end
				end
				if ((((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\251\169\3\43\193\211\174\9\42\209", "\163\182\192\109\79")]:CooldownRemains() > v132:Cooldown()) or (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\7\46\1\196\250\35\32\9\197\251\48", "\149\84\70\96\160")]:CooldownRemains() > v132:Cooldown())) and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v93, false, false) >= v94)) or (3911 == 4700)) then
					local v219 = 0;
					while true do
						if ((3000 < 4194) and (v219 == 0)) then
							ShouldReturn = v143();
							if ((651 < 4442) and ShouldReturn) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\40\3\3\236\54\5\8\173\60\7\0\236\63\3", "\141\88\102\109");
							end
							break;
						end
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\158\90\196\116\56\49\84\210\167", "\161\211\51\170\16\122\93\53")]:IsReady() and ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\214\167\188\44\249\171\188\44\254\188", "\72\155\206\210")]:CooldownRemains() > v113[LUAOBFUSACTOR_DECRYPT_STR_0("\107\115\90\10\17\74\123\71\26", "\83\38\26\52\110")]:Cooldown()) or (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\107\31\38\66\87\0\33\79\93\25\35", "\38\56\119\71")]:CooldownRemains() > v113[LUAOBFUSACTOR_DECRYPT_STR_0("\222\230\86\210\7\90\242\252\76", "\54\147\143\56\182\69")]:Cooldown()))) or (195 >= 1804)) then
					if (v24(v113.MindBlast, not v14:IsSpellInRange(v113.MindBlast), true) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\136\241\77\224\212\141\254\90\203\150\133\254\68\222\209\132", "\191\182\225\159\41");
					end
				end
				v163 = 5;
			end
			if ((v163 == 6) or (2861 == 2459)) then
				if ((1903 < 4021) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\117\68\192\167\249\223\113\67\211\167\210\205\71\88\201", "\168\38\44\161\195\150")]:IsReady() and (v14:TimeToX(20) > (0.5 * v113[LUAOBFUSACTOR_DECRYPT_STR_0("\179\244\131\114\63\255\129\25\146\248\166\115\49\252\190", "\118\224\156\226\22\80\136\214")]:Cooldown()))) then
					if (v24(v113.ShadowWordDeath, not v14:IsSpellInRange(v113.ShadowWordDeath)) or (2270 >= 4130)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\230\88\132\77\249\102\151\77\252\93\191\70\235\88\148\74\174\10\192\70\239\84\129\69\235", "\224\34\142\57");
					end
				end
				if ((2593 <= 3958) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\246\168\201\196\93\254\75\15", "\110\190\199\165\189\19\145\61")]:IsReady() and (v13:BuffStack(v113.RhapsodyBuff) == 20)) then
					if ((1176 == 1176) and v24(v113.HolyNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\228\123\241\180\201\213\253\118\168\218\135\222\234\122\233\140\194", "\167\186\139\23\136\235");
					end
				end
				if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\41\184\129\25\31", "\109\122\213\232")]:IsReady() or (3062 == 1818)) then
					if (v24(v113.Smite, not v14:IsSpellInRange(v113.Smite), true) or (3717 < 3149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\250\171\36\235\183\166\49\227\246\165\53", "\80\142\151\194");
					end
				end
				v163 = 7;
			end
			if ((3195 < 3730) and (v163 == 1)) then
				if ((2797 <= 3980) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\213\191\181\213\166\83\109\251\191\164\209\166\66", "\57\148\205\214\180\200\54")]:IsReady() and v29 and v96 and (v13:ManaPercentage() <= 85)) then
					if ((1944 <= 2368) and v24(v113.ArcaneTorrent)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\239\54\53\120\23\194\33\59\100\0\248\59\32\54\22\252\56\53\113\23", "\22\114\157\85\84");
					end
				end
				if ((1709 < 4248) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\247\195\18\192\82\225\174\205\206\29\192", "\200\164\171\115\164\61\150")]:IsReady() and v96 and (v13:ManaPercentage() < 90) and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\147\253\13\65\129\187\250\7\64\145", "\227\222\148\99\37")]:IsAvailable() and not v13:BuffUp(v113.ShadowCovenantBuff) and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v93, false, false) >= v94)) then
					if (v24(v113.Shadowfiend) or (3970 == 3202)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\90\83\242\246\36\84\91\243\247\55\18\86\247\244\50\85\87", "\153\83\50\50\150");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\112\127\125\24\113\174\67\89\115\97", "\45\61\22\19\124\19\203")]:IsReady() and v96 and not v13:BuffUp(v113.ShadowCovenantBuff) and (v135.FriendlyUnitsWithBuffBelowHealthPercentageCount(v113.AtonementBuff, v93, false, false) >= v94)) or (3918 >= 4397)) then
					if (v24(v113.Mindbender) or (780 == 3185)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\27\3\241\0\117\183\197\23\31\181\6\113\180\192\21\8", "\217\161\114\109\149\98\16");
					end
				end
				v163 = 2;
			end
			if ((v163 == 3) or (3202 >= 4075)) then
				if ((64 == 64) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\235\196\60\91\42\99\211\212\25\85\44\92\222\213", "\55\187\177\78\60\79")]:IsReady() and (v14:TimeToDie() > (0.3 * v113[LUAOBFUSACTOR_DECRYPT_STR_0("\29\219\77\236\67\251\136\40\249\86\232\77\202\132", "\224\77\174\63\139\38\175")]:BaseDuration())) and v14:DebuffRefreshable(v113.PurgeTheWickedDebuff)) then
					if ((2202 >= 694) and v24(v113.PurgeTheWicked, not v14:IsSpellInRange(v113.PurgeTheWicked))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\84\74\41\129\126\76\38\129\126\79\39\135\74\93\42\196\69\89\35\133\70\93", "\78\228\33\56");
					end
				end
				if ((3706 <= 3900) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\253\118\179\7\138\217\73\189\17\129\254\127\187\13", "\229\174\30\210\99")]:IsReady() and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\43\248\148\86\232\9\49\30\218\143\82\230\56\61", "\89\123\141\230\49\141\93")]:IsAvailable() and (v14:TimeToDie() > (0.3 * v113[LUAOBFUSACTOR_DECRYPT_STR_0("\192\121\247\8\31\93\196\126\228\8\32\75\250\127", "\42\147\17\150\108\112")]:BaseDuration())) and v14:DebuffRefreshable(v113.ShadowWordPain)) then
					if ((2890 > 2617) and v24(v113.ShadowWordPain, not v14:IsSpellInRange(v113.ShadowWordPain))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\174\44\123\232\255\48\177\34\109\227\215\31\167\36\113\167\236\14\171\44\120\226", "\136\111\198\77\31\135");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\49\1\166\82\178\243\32\166\16\13\131\83\188\240\31", "\201\98\105\199\54\221\132\119")]:IsReady() and (v14:HealthPercentage() < 20)) or (3355 > 4385)) then
					if (v24(v113.ShadowWordDeath, not v14:IsSpellInRange(v113.ShadowWordDeath)) or (3067 <= 2195)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\4\130\37\13\34\147\174\3\145\37\61\49\169\184\24\139\97\83\117\168\184\1\130\38\7", "\204\217\108\227\65\98\85");
					end
				end
				v163 = 4;
			end
			if ((3025 >= 2813) and (v163 == 2)) then
				if ((2412 >= 356) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\63\41\54\120\158\120\19\51\44", "\20\114\64\88\28\220")]:IsReady()) then
					if ((2070 > 1171) and v24(v113.MindBlast, not v14:IsSpellInRange(v113.MindBlast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\8\220\176\199\210\177\48\18\198\244\169\128\253\61\14\220\179\199\195\190\62\23", "\221\81\97\178\212\152\176");
					end
				end
				if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\254\239\28\255\21\218\208\18\233\30\233\226\28\239\18", "\122\173\135\125\155")]:IsReady() and ((v14:HealthPercentage() < 20) or v13:BuffUp(v113.ShadowCovenantBuff))) or (4108 < 3934)) then
					if ((3499 >= 3439) and v24(v113.ShadowWordDeath, not v14:IsSpellInRange(v113.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\201\1\189\48\38\247\147\206\18\189\0\53\205\133\213\8\249\110\113\196\139\207\7\134\44\50\199\146", "\168\228\161\96\217\95\81");
					end
				end
				if ((876 < 3303) and v96 and v13:BuffUp(v113.PowerInfusionBuff)) then
					local v220 = 0;
					while true do
						if ((2922 <= 3562) and (v220 == 0)) then
							ShouldReturn = v141();
							if ((2619 >= 1322) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v163 = 3;
			end
		end
	end
	local function v147()
		local v164 = 0;
		while true do
			if ((4133 >= 2404) and (v164 == 0)) then
				ShouldReturn = v140();
				if (ShouldReturn or (1433 == 2686)) then
					return ShouldReturn;
				end
				v164 = 1;
			end
			if ((1 == v164) or (4123 == 4457)) then
				if (v15 or (3972 <= 205)) then
					local v221 = 0;
					while true do
						if ((1 == v221) or (3766 < 1004)) then
							ShouldReturn = v145();
							if ((1784 < 2184) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v221 == 0) or (1649 > 4231)) then
							if ((3193 == 3193) and v37) then
								local v251 = 0;
								while true do
									if ((v251 == 0) or (3495 > 4306)) then
										ShouldReturn = v139();
										if ((4001 > 3798) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							if (v96 or (4688 <= 4499)) then
								local v252 = 0;
								while true do
									if ((v252 == 0) or (1567 <= 319)) then
										ShouldReturn = v144();
										if (ShouldReturn or (4583 == 3761)) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							v221 = 1;
						end
					end
				end
				if ((3454 > 1580) and v135.TargetIsValid()) then
					local v222 = 0;
					while true do
						if ((v222 == 0) or (1607 == 20)) then
							ShouldReturn = v146();
							if (ShouldReturn or (962 >= 4666)) then
								return ShouldReturn;
							end
							break;
						end
					end
				elseif (v13:IsMoving() or (1896 == 1708)) then
					local v240 = 0;
					while true do
						if ((3985 >= 1284) and (v240 == 0)) then
							ShouldReturn = v142();
							if (ShouldReturn or (1987 == 545)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v148()
		local v165 = 0;
		while true do
			if ((v165 == 0) or (4896 < 1261)) then
				if ((23 < 3610) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\178\65\72\90\162\254\81\144\74\121\80\162\221\87\150\91\91\90", "\62\226\46\63\63\208\169")]:IsReady() and v33 and (v13:BuffDown(v113.PowerWordFortitudeBuff, true) or v135.GroupBuffMissing(v113.PowerWordFortitudeBuff))) then
					if (v24(v115.PowerWordFortitudePlayer) or (3911 < 2578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\22\66\134\13\50\56\81\247\29\106\133\16\31\59\87\241\12\81\134", "\62\133\121\53\227\127\109\79");
					end
				end
				if (v15 or (4238 < 87)) then
					local v223 = 0;
					while true do
						if ((2538 == 2538) and (v223 == 0)) then
							if ((4122 == 4122) and v37) then
								local v253 = 0;
								while true do
									if ((0 == v253) or (2371 > 2654)) then
										ShouldReturn = v139();
										if (ShouldReturn or (3466 > 4520)) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							if (v95 or (951 >= 1027)) then
								local v254 = 0;
								while true do
									if ((0 == v254) or (1369 > 2250)) then
										ShouldReturn = v145();
										if (ShouldReturn or (937 > 3786)) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v165 = 1;
			end
			if ((v165 == 2) or (901 > 4218)) then
				if ((4779 > 4047) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\155\204\92\67\81\125\52\95\175\229\68\84\87\67\47\88\175\198", "\45\203\163\43\38\35\42\91")]:IsReady() and (v13:BuffDown(v113.PowerWordFortitudeBuff, true) or v135.GroupBuffMissing(v113.PowerWordFortitudeBuff))) then
					if ((4050 > 1373) and v24(v115.PowerWordFortitudePlayer)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\138\203\38\149\150\67\221\151\216\28\129\166\70\198\140\200\54\131\172", "\52\178\229\188\67\231\201");
					end
				end
				break;
			end
			if ((v165 == 1) or (1037 > 4390)) then
				if ((1407 <= 1919) and v13:IsMoving()) then
					local v224 = 0;
					while true do
						if ((2526 >= 1717) and (v224 == 0)) then
							ShouldReturn = v142();
							if (ShouldReturn or (3620 <= 2094)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or (1723 >= 2447)) then
					local v225 = 0;
					local v226;
					while true do
						if ((0 == v225) or (1199 > 3543)) then
							v226 = v135.DeadFriendlyUnitsCount();
							if ((1617 < 3271) and (v226 > 1)) then
								if ((3085 > 1166) and v24(v113.MassResurrection, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\29\21\33\230\233\188\167\3\1\32\231\211\173\182\25\27\60", "\194\112\116\82\149\182\206");
								end
							elseif ((4493 >= 3603) and v24(v113.Resurrection, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\43\173\95\13\210\240\11\58\188\69\23\206", "\110\89\200\44\120\160\130");
							end
							break;
						end
					end
				end
				v165 = 2;
			end
		end
	end
	local function v149()
		local v166 = 0;
		while true do
			if ((2843 <= 2975) and (v166 == 0)) then
				ShouldReturn = v135.FocusUnitRefreshableBuff(v113.AtonementBuff, v87, nil, nil, 20);
				if (ShouldReturn or (1989 <= 174)) then
					return ShouldReturn;
				end
				v166 = 1;
			end
			if ((v166 == 1) or (209 > 2153)) then
				if (v15:BuffDown(v113.AtonementBuff) or (v15:BuffRemains(v113.AtonementBuff) < v87) or (2020 == 1974)) then
					if (v13:BuffUp(v113.Rapture) or (1347 == 1360)) then
						if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\17\78\71\1\229\107\44\51\69\99\12\254\89\47\37", "\67\65\33\48\100\151\60")]:IsReady() or (4461 == 3572)) then
							if (v24(v115.PowerWordShieldFocus) or (2872 == 318)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\207\232\185\221\225\224\240\161\202\247\224\244\166\209\246\211\227\238\208\246\222\235", "\147\191\135\206\184");
							end
						end
					elseif ((568 == 568) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\182\45\168\196\207", "\210\228\72\198\161\184\51")]:IsReady()) then
						if ((4200 == 4200) and v24(v115.RenewFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\36\76\253\21\100\142\62\76\242\28", "\174\86\41\147\112\19");
						end
					end
				end
				break;
			end
		end
	end
	local function v150()
		local v167 = 0;
		local v168;
		while true do
			if ((3 == v167) or (4285 < 1369)) then
				if (v15:BuffDown(v113.AtonementBuff) or (v15:BuffRemains(v113.AtonementBuff) < 6) or (3520 > 4910)) then
					local v227 = 0;
					while true do
						if ((2842 <= 4353) and (v227 == 0)) then
							if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\103\87\19\219\69\111\11\204\83\107\12\215\82\84\0", "\190\55\56\100")]:IsReady() or (3751 < 1643)) then
								if (v24(v115.PowerWordShieldFocus) or (4911 == 3534)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\70\160\43\27\1\220\228\89\189\56\33\0\235\250\83\163\56\94\27\230\242\90", "\147\54\207\92\126\115\131");
								end
							end
							if ((3001 > 16) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\63\48\37\105\24\108\8", "\30\109\81\85\29\109")]:IsReady()) then
								if ((2875 <= 3255) and v24(v115.RaptureFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\237\112\68\162\35\204\249\191\121\81\183\58", "\156\159\17\52\214\86\190");
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((368 < 4254) and (v167 == 0)) then
				v168 = GetTime() - v101;
				if ((v168 > 20) or (4841 <= 2203)) then
					local v228 = 0;
					while true do
						if ((4661 > 616) and (v228 == 0)) then
							ShouldRaptureRamp = false;
							v101 = 0;
							break;
						end
					end
				end
				v167 = 1;
			end
			if ((2 == v167) or (1943 == 2712)) then
				if ((4219 >= 39) and ShouldReturn) then
					return ShouldReturn;
				end
				if ((3967 > 2289) and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\22\23\188\245\36\226\210", "\183\68\118\204\129\81\144")]:IsReady() and v13:BuffDown(v113.Rapture)) then
					if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\62\162\103\225\25\181\1\191\116\214\10\134\7\172\126\231\14", "\226\110\205\16\132\107")]:IsReady() or (851 > 2987)) then
						if ((4893 >= 135) and v24(v115.PowerWordRadianceFocus, nil, v124)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\251\204\247\220\83\212\212\239\203\69\212\209\225\221\72\234\205\227\220\126\226\205\243\205\64\229\215\160\209\68\234\207\223\218\78\228\207\228\214\86\229", "\33\139\163\128\185");
						end
					end
				end
				v167 = 3;
			end
			if ((v167 == 1) or (3084 > 3214)) then
				v126 = not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\115\1\159\24\45\43\24\184\88\9\157\7\44\1\20", "\203\59\96\237\107\69\111\113")]:IsAvailable() or (v13:BuffStack(v113.HarshDisciplineBuff) == 3);
				ShouldReturn = v135.FocusUnitRefreshableBuff(v113.AtonementBuff, 6, nil, nil, 20);
				v167 = 2;
			end
		end
	end
	local function v151()
		local v169 = 0;
		local v170;
		while true do
			if ((v169 == 0) or (3426 < 2647)) then
				v170 = GetTime() - v101;
				if ((v170 > 20) or (1576 == 4375)) then
					local v229 = 0;
					while true do
						if ((v229 == 0) or (2920 < 2592)) then
							ShouldEvangelismRamp = false;
							v101 = 0;
							break;
						end
					end
				end
				v169 = 1;
			end
			if ((v169 == 1) or (1110 >= 2819)) then
				v126 = not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\134\238\175\175\166\203\180\175\173\230\173\176\167\225\184", "\220\206\143\221")]:IsAvailable() or (v13:BuffStack(v113.HarshDisciplineBuff) == 3);
				ShouldReturn = v135.FocusUnitRefreshableBuff(v113.AtonementBuff, 6, nil, nil, 20);
				v169 = 2;
			end
			if ((1824 <= 2843) and (v169 == 2)) then
				if ((3062 == 3062) and ShouldReturn) then
					return ShouldReturn;
				end
				if ((716 <= 4334) and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\163\107\44\25\223\201\222\143\110\32", "\178\230\29\77\119\184\172")]:IsReady()) then
					local v230 = 0;
					while true do
						if ((1001 < 3034) and (v230 == 0)) then
							ShouldReturn = v146();
							if (ShouldReturn or (977 > 1857)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v169 = 3;
			end
			if ((v169 == 3) or (868 > 897)) then
				if (v15:BuffDown(v113.AtonementBuff) or (v15:BuffRemains(v113.AtonementBuff) < 6) or (1115 == 4717)) then
					local v231 = 0;
					while true do
						if ((2740 < 4107) and (v231 == 0)) then
							if ((284 < 700) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\197\177\29\30\101\207\250\172\14\40\127\241\240\178\14", "\152\149\222\106\123\23")]:IsReady()) then
								if ((386 >= 137) and v24(v115.PowerWordShieldFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\205\41\225\70\167\226\49\249\81\177\226\53\254\74\176\209\34\182\75\176\220\42", "\213\189\70\150\35");
								end
							end
							if ((923 == 923) and (v170 > 7)) then
								if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\127\90\99\13\93\98\123\26\75\103\117\12\70\84\122\11\74", "\104\47\53\20")]:IsReady() or (4173 == 359)) then
									if ((1722 == 1722) and v24(v115.PowerWordRadianceFocus, nil, v124)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\179\67\150\25\174\48\180\67\147\24\131\29\162\72\136\29\178\12\166\115\136\18\175\27\162\66\149\92\180\10\162\64\190\31\179\0\175\72\142\11\178", "\111\195\44\225\124\220");
									end
								elseif (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\253\80\1\125\172\174\212\79\19\126", "\203\184\38\96\19\203")]:IsReady() or (3994 <= 3820)) then
									if ((1488 < 1641) and v24(v113.Evangelism)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\60\101\120\79\201\60\127\112\82\195\121\123\124\64\194", "\174\89\19\25\33");
									end
								end
							end
							v231 = 1;
						end
						if ((433 <= 2235) and (1 == v231)) then
							if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\29\23\92\75\224", "\107\79\114\50\46\151\231")]:IsReady() or (1838 > 2471)) then
								if ((2444 < 3313) and v24(v115.RenewFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\43\163\187\44\157\121\191\197\56\170", "\160\89\198\213\73\234\89\215");
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
	local function v152()
		local v171 = 0;
		local v172;
		while true do
			if ((v171 == 3) or (3685 <= 185)) then
				if ((738 <= 1959) and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\54\68\84\62\220\22\64", "\169\100\37\36\74")]:IsReady() and v13:BuffDown(v113.Rapture)) then
					local v232 = 0;
					while true do
						if ((v232 == 0) or (1317 == 3093)) then
							if ((v172 > 10) or (2611 >= 4435)) then
								if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\48\136\181\85\18\176\173\66\4\181\163\84\9\134\172\83\5", "\48\96\231\194")]:IsReady() or (117 > 4925)) then
									if ((107 <= 4905) and v24(v115.PowerWordRadianceFocus, nil, v124)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\216\85\25\40\11\231\184\140\218\94\49\63\24\220\166\130\198\89\11\18\16\214\188\151\201\84\26\109\17\221\174\143\247\89\1\34\21\220\160\148\198", "\227\168\58\110\77\121\184\207");
									end
								elseif (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\94\42\190\78\182\222\125\172\104\49", "\197\27\92\223\32\209\187\17")]:IsReady() or (1004 > 4035)) then
									if (v24(v113.Evangelism) or (2802 < 369)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\6\73\194\245\4\90\207\242\16\82\131\243\6\94\207", "\155\99\63\163");
									end
								end
							end
							if ((1497 <= 2561) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\176\212\175\136\174", "\228\226\177\193\237\217")]:IsReady()) then
								if (v24(v115.RenewFocus) or (816 > 1712)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\38\181\45\227\35\240\43\227\53\188", "\134\84\208\67");
								end
							end
							break;
						end
					end
				end
				if (v15:BuffDown(v113.AtonementBuff) or (v15:BuffRemains(v113.AtonementBuff) < 6) or (2733 == 2971)) then
					local v233 = 0;
					while true do
						if ((2599 < 4050) and (v233 == 0)) then
							if ((2034 == 2034) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\35\163\145\89\1\155\137\78\23\159\142\85\22\160\130", "\60\115\204\230")]:IsReady()) then
								if ((3040 < 4528) and v24(v115.PowerWordShieldFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\247\53\252\117\245\5\252\127\245\62\212\99\239\51\238\124\227\122\227\117\230\54", "\16\135\90\139");
								end
							end
							if (v113[LUAOBFUSACTOR_DECRYPT_STR_0("\102\117\22\39\91\70\125", "\24\52\20\102\83\46\52")]:IsReady() or (2092 <= 2053)) then
								if ((2120 < 4799) and v24(v115.RaptureFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\214\46\49\48\26\214\42\97\44\10\197\35", "\111\164\79\65\68");
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v171 == 2) or (4538 <= 389)) then
				if ((270 <= 1590) and ShouldReturn) then
					return ShouldReturn;
				end
				if ((1625 > 1265) and not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\192\207\9\61\33\224\213\1\32\43", "\70\133\185\104\83")]:IsReady()) then
					local v234 = 0;
					while true do
						if ((v234 == 0) or (51 >= 920)) then
							ShouldReturn = v146();
							if (ShouldReturn or (2968 <= 1998)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v171 = 3;
			end
			if ((0 == v171) or (3085 <= 2742)) then
				v172 = GetTime() - v101;
				if ((v172 > 25) or (376 >= 2083)) then
					local v235 = 0;
					while true do
						if ((4191 > 1232) and (v235 == 0)) then
							ShouldBothRamp = false;
							v101 = 0;
							break;
						end
					end
				end
				v171 = 1;
			end
			if ((v171 == 1) or (1505 > 4873)) then
				v126 = not v113[LUAOBFUSACTOR_DECRYPT_STR_0("\96\112\166\237\205\108\120\167\253\204\88\125\189\240\192", "\165\40\17\212\158")]:IsAvailable() or (v13:BuffStack(v113.HarshDisciplineBuff) == 3);
				ShouldReturn = v135.FocusUnitRefreshableBuff(v113.AtonementBuff, 6, nil, nil, 20);
				v171 = 2;
			end
		end
	end
	local function v153()
		local v173 = 0;
		while true do
			if ((3880 < 4534) and (v173 == 3)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\58\168\41\103\0\163\58\96", "\19\105\205\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\6\202\132\45\187\29\206\149\8\160\28\214\178\43\188\6", "\95\201\104\190\225")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\156\206\213\218\166\197\198\221", "\174\207\171\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\240\25\246\234\197\248\238\25\220\246\219\244\201\5\250\236\210\225\247\30\231", "\183\141\158\109\147\152")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\12\242\24\37\7\225\31", "\108\76\105\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\203\165\228\220\249\208\161\245\250\227\215\180\242\198\228\201\181", "\174\139\165\209\129")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\182\246\213\207\13\119\107", "\24\195\211\130\161\166\99\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\16\236\8\86\5\86\6\251\45\71\19\118\17\232\53\86\4", "\118\38\99\137\76\51")];
				v173 = 4;
			end
			if ((5 == v173) or (2368 >= 2541)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\140\196\58\53\163\50\167", "\85\212\233\176\78\92\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\93\137\238\94\80\155\246\69\86\141\202\122", "\130\42\56\232")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\217\176\48\247\73\49\237\166", "\95\138\213\68\131\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\39\182\70\100\3\38\167\86\101\35\39\175\118\101\43\47\164", "\22\74\72\193\35")] or "";
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\124\240\76\37\119\227\75", "\56\76\25\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\206\188\35\221\119\207\173\51\220\87\206\165\18\206\76\198\174\50", "\175\62\161\203\70")] or "";
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\216\215\7\60\50\218\208", "\85\92\189\163\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\163\39\61\59\133\62\62\60\191\57\55\39\132\0", "\88\73\204\80")] or 0;
				v173 = 6;
			end
			if ((v173 == 2) or (4733 <= 4103)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\143\17\218\112\120\162\153", "\22\197\234\101\174\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\61\182\204\115\163\243\131\47\33\163\218\101", "\230\77\84\197\188\22\207\183")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\17\210\232\133\175\247\38", "\85\153\116\166\156\236\193\144")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\233\94\163\225\12\134\245\75\181\247", "\96\196\128\45\211\132")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\6\136\111\75\219\161\179\203", "\184\85\237\27\63\178\207\212")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\88\7\91\4\92\40\89\14\85\0\92\28\92\13", "\63\104\57\105")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\130\176\80\2\137\163\87", "\36\107\231\196")][LUAOBFUSACTOR_DECRYPT_STR_0("\117\180\172\131\81\176\139\137\94\186\176\151\82\167\167\134\81", "\231\61\213\194")];
				v173 = 3;
			end
			if ((1 == v173) or (1207 == 4273)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\209\174\201\126\64\32\65", "\50\93\180\218\189\23\46\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\183\94\124\75\203\77\204\147\84\94\64\250\71\204\176\82\88\81\216\77", "\40\190\196\59\44\36\188")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\64\200\160\243\115\10\47", "\109\92\37\188\212\154\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\252\161\226\63\93\1\227\173\192\23\95\5\251\172\198\35", "\58\100\143\196\163\81")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\71\55\183\54\71\226\29", "\110\122\34\67\195\95\41\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\64\162\94\104\217\113\168\122\68\210\70\190\78\70", "\182\21\209\59\42")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\132\82\209\9\40\176\176\68", "\222\215\55\165\125\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\1\222\208\31\255\196\227\94\8\212\202\27\235", "\42\76\177\166\122\146\161\141")] or 0;
				v173 = 2;
			end
			if ((v173 == 4) or (2005 == 2529)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\35\17\6\0\46\250\53", "\64\157\70\101\114\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\100\173\180\243\21\82\169\179\230\32\82\169\190\230\2\104\152", "\112\32\200\199\131")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\85\72\172\202\165\37\63", "\66\76\48\60\216\163\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\149\124\213\94\202\33", "\68\218\230\25\147\63\174")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\47\71\88\191\163\45\64", "\214\205\74\51\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\220\77\230\249\95\202", "\23\154\44\130\156")] or 0;
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\163\185\186\63\29\22\181", "\115\113\198\205\206\86")][LUAOBFUSACTOR_DECRYPT_STR_0("\177\68\251\114\129\86\242\78\140\68\234\85\138\82", "\58\228\55\158")];
				v173 = 5;
			end
			if ((986 < 3589) and (v173 == 0)) then
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\220\151\202\39\228\193\202", "\138\166\185\227\190\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\103\192\5\83\32\16\202\120\214", "\121\171\20\165\87\50\67")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\61\173\34\176\12\193\43", "\98\166\88\217\86\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\229\124\41\131\221\250\255\119\6\182\211\226\255\118\15", "\188\150\150\25\97\230")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\140\75\22\5\227\221\154", "\141\186\233\63\98\108")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\239\45\186\44\255\237\28\185\49\248\229\34\152\36\252\239", "\69\145\138\76\214")] or "";
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\202\157\157\182\24\119\220", "\118\16\175\233\233\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\163\129\52\183\231\133\122\187\139\33\178\225\133\85\187", "\29\235\228\85\219\142\235")] or 0;
				v173 = 1;
			end
			if ((v173 == 6) or (3119 == 430)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\134\4\82\32\212\41\144", "\186\78\227\112\38\73")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\88\234\80\65\83\242\81\232\70\90\117\242\112\239\90\70\106", "\26\156\55\157\53\51")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\221\2\205\177\94\139\203", "\48\236\184\118\185\216")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\148\121\49\194\49\180", "\84\133\221\55\80\175")] or "";
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\226\48\178\206\82\186\244", "\60\221\135\68\198\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\148\214\130\79\220\188", "\185\142\221\152\227\34")] or "";
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\192\67\238\74\61\240\75", "\151\56\165\55\154\35\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\106\43\239\173\70\86", "\142\192\35\101")] or "";
				break;
			end
		end
	end
	local function v154()
		local v174 = 0;
		while true do
			if ((2409 <= 3219) and (3 == v174)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\36\55\173\255\228\35", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\54\177\10\7\48\216", "\136\126\208\102\104\120")] or 0;
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\243\241\135\86\30\253\232\152", "\17\108\146\157\232")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\37\56\167\185\226\234\177\51\14\151\177\230", "\131\223\86\93\227\208\148")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\19\56\32\154\247\39\37\34\186\237\47\56\40", "\129\70\75\69\223")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\148\184\253\4\230\216\217\145\180\219\51", "\180\176\226\217\147\99\131")] or 0;
				v174 = 4;
			end
			if ((v174 == 5) or (898 > 2782)) then
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\46\250\26\246\9\233\15\202\44", "\130\124\155\106")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\59\243\186\28\94\63\196\188\6\89\42", "\105\44\90\131\206")] or 0;
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\252\8\186\72\87\201", "\26\48\153\102\223\63\31\153")] or 0;
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\69\249\231\11\78\234\224", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\76\244\207\20\97\68\10\71\208\194\15\83\71\28\107\211", "\43\120\35\131\170\102\54")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\3\147\162\172\190\131\71", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\46\239\98\207\248\188\22\196\26\211\125\195\239\135\29\226\31\238\126\226\218", "\182\126\128\21\170\138\235\121")] or 0;
				v174 = 6;
			end
			if ((v174 == 0) or (2250 <= 1764)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\61\183\238\130\171\5", "\118\182\21\73\195\135\236\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\57\20\65\10\14\248\32\12", "\157\104\92\122\32\100\109")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\219\222\52\41\138\184", "\203\195\198\175\170\93\71\237")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\95\49\219\84\28\249\32\95\22\229", "\156\78\43\94\181\49\113")] or 0;
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\208\183\2\77\126\97", "\25\18\136\164\195\107\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\57\166\65\119\177\196\182\252\10\187\64\103\172", "\216\136\77\201\47\18\220\161")] or 0;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\233\63\206\1\210\133\62", "\226\77\140\75\186\104\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\221\213\15\64\174\203\194\8\64\171\202\226\62\75\176\207\222\60\74", "\47\217\174\176\95")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\216\98\22\187\90\127\53", "\70\216\189\22\98\210\52\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\208\180\130\193\237\208\177\131\225\219\219\170\134\221\217\218\139\183", "\179\186\191\195\231")] or 0;
				v174 = 1;
			end
			if ((693 == 693) and (v174 == 1)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\58\12\240\240\49\31\247", "\132\153\95\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\129\189\25\40\229\237\175\163\182\60\44\243\211\161\191\177\11\10\229\213\181\161", "\192\209\210\110\77\151\186")] or 0;
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\6\54\253\246\202\231\16", "\164\128\99\66\137\159")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\154\236\142\1\128\231\141\21\153\249\172\5\154\250\183\15\135", "\222\96\233\137")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\182\179\11\129\253\247\170", "\144\217\211\199\127\232\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\46\55\38\230\80\18\84\234\42\45\59\220\74\12\108\200", "\36\152\79\94\72\181\37\98")] or 0;
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\221\83\43\222\214\64\44", "\95\183\184\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\62\238\40\103\149\18\165\45\226\53\71\137\13\187\10\244\39\83\133", "\98\213\95\135\70\52\224")] or "";
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\221\99\93\240\164\218", "\52\158\195\169\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\79\175\55\68\137\34\126\153\77\179\32\112\170\60\125\142", "\235\26\220\82\20\230\85\27")];
				v174 = 2;
			end
			if ((v174 == 2) or (2529 == 438)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\164\253\214\125\134\166\250", "\20\232\193\137\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\208\210\163\245\187\24\99\38\243\204\160\226\164\39", "\17\66\191\165\198\135\236\119")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\170\186\7\246\230\235\194", "\177\111\207\206\115\159\136\140")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\154\21\56\193\66\86\11\134\5\7\246\78\77\23\128\21\6", "\63\101\233\112\116\180\47")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\62\249\6\241\56\196\40", "\86\163\91\141\114\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\30\121\122\52\92\30\103\81\59\65\25\125\118\40\123\59", "\90\51\107\20\19")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\245\145\251\52\131\247\150", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\227\253\16\5\73\0\229\210\24\25\84\28\243\226\62\25\73\0\230", "\38\117\150\144\121\107")] or 0;
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\190\250\46\36\181\233\41", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\23\36\17\77\11\117", "\26\134\100\65\89\44\103")];
				v174 = 3;
			end
			if ((1751 > 1411) and (v174 == 6)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\223\33\242\143\29\55\21", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\24\49\81\119\217\39\89\24\13\79\96\209\35\83\62\59\89\96\209\49\95", "\66\55\108\94\63\18\180")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\39\136\145\35\46\87\19\158", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\165\226\233\114\227\66\164\165\222\247\101\235\70\174\129\236\245\99\247\96\184\190\248\247", "\39\202\209\141\135\23\142")] or 0;
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\54\29\30\59\246\248\32", "\152\159\83\105\106\82")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\210\94\252\204\81\132\200\69\193\217\78\132\199\85\192\200\85\133\225\67\253\220\76", "\60\225\166\49\146\169")] or 0;
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\108\214\70\82\14\179\114\210\103\91\42\191\113\218\103\91\20\185\122", "\122\218\31\179\19\62")];
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\211\217\213\192\175\66\160", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\54\89\208\37\122\173\242\10\72\215\33\111\188\249\57\72\241\24", "\217\151\90\45\185\72\27")] or 0;
				v174 = 7;
			end
			if ((4182 == 4182) and (v174 == 7)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\121\243\6\95\205\123\244", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\215\73\139\67\126\60\222\109\135\64\118\60\222\83\129\75\88\58\212\72\146", "\31\72\187\61\226\46")] or 0;
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\87\198\78\112\35\208", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\121\212\195\1\176\141\21\187\98\242\247", "\113\222\16\186\167\99\213\227")] or 0;
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\11\239\226\39\0\252\229", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\168\204\41\229\166\27\177\68\128\215\0\243\171\11\175", "\32\229\165\71\129\196\126\223")] or 0;
				break;
			end
			if ((v174 == 4) or (4666 <= 611)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\161\29\219\70\137\175\67\164\17\242\83\131\182\90", "\195\42\215\124\181\33\236")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\219\11\176\182\250\81\169\245\255\58", "\200\153\183\106\195\222\178\52")] or 0;
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\91\209\6\85\23\134\86\220\38\72\45\132\82\248\37", "\95\227\55\176\117\61")] or 0;
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\41\76\252\209\217\32\76\227\251\248\43\73\230\215\246\13\125", "\185\145\69\45\143")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\33\22\177\57\34\7\150\42\55", "\227\88\82\115")];
				v174 = 5;
			end
		end
	end
	local function v155()
		local v175 = 0;
		local v176;
		local v177;
		local v178;
		local v179;
		local v180;
		while true do
			if ((v175 == 6) or (4737 <= 4525)) then
				v125 = v13:BuffDown(v113.SurgeofLight);
				if ((4367 >= 3735) and not v13:IsChanneling()) then
					if ((2426 == 2426) and v13:AffectingCombat()) then
						local v241 = 0;
						while true do
							if ((21 < 1971) and (v241 == 1)) then
								if (v178 or (2922 <= 441)) then
									local v267 = 0;
									while true do
										if ((3624 >= 1136) and (v267 == 0)) then
											ShouldReturn = v151();
											if ((2043 < 2647) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								if (v179 or (354 >= 1534)) then
									local v268 = 0;
									while true do
										if ((v268 == 0) or (3764 >= 4876)) then
											ShouldReturn = v152();
											if ((3676 >= 703) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								v241 = 2;
							end
							if ((3811 > 319) and (v241 == 0)) then
								if ((47 < 1090) and v176) then
									local v269 = 0;
									while true do
										if ((0 == v269) or (1371 >= 2900)) then
											ShouldReturn = v149();
											if (ShouldReturn or (1126 <= 504)) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								if (v177 or (3732 == 193)) then
									local v270 = 0;
									while true do
										if ((3344 >= 3305) and (v270 == 0)) then
											ShouldReturn = v150();
											if (ShouldReturn or (2885 < 1925)) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								v241 = 1;
							end
							if ((v241 == 2) or (4542 <= 1594)) then
								ShouldReturn = v147();
								if ((338 <= 3505) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					elseif ((69 == 69) and v95) then
						local v244 = 0;
						while true do
							if ((v244 == 0) or (672 == 368)) then
								if ((1019 == 1019) and v176) then
									local v274 = 0;
									while true do
										if ((0 == v274) or (290 > 2746)) then
											ShouldReturn = v149();
											if ((1923 < 4601) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								ShouldReturn = v148();
								v244 = 1;
							end
							if ((v244 == 2) or (3957 == 2099)) then
								if ((4006 > 741) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
							if ((2359 <= 3733) and (1 == v244)) then
								if (ShouldReturn or (4596 <= 2402)) then
									return ShouldReturn;
								end
								ShouldReturn = v146();
								v244 = 2;
							end
						end
					end
				end
				break;
			end
			if ((2078 > 163) and (0 == v175)) then
				v153();
				v154();
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\134\195\134\141\208\208", "\181\163\233\164\225\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\132\61", "\23\48\235\94")];
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\72\213\223\90\91\54\193", "\178\28\186\184\61\55\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\201\84", "\149\164\173\39\92\146\110")];
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\199\40\23\24\22\30\224", "\123\147\71\112\127\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\196\145\97\67\192", "\38\172\173\226\17")];
				v175 = 1;
			end
			if ((4116 > 737) and (v175 == 5)) then
				if (true or (1175 > 4074)) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (1361 == 4742)) then
							v119 = #v118;
							v121 = #v120;
							break;
						end
					end
				else
					local v237 = 0;
					while true do
						if ((v237 == 0) or (4012 >= 4072)) then
							v121 = 1;
							v119 = 1;
							break;
						end
					end
				end
				v132 = ((v13:BuffUp(v113.ShadowCovenantBuff)) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\51\29\221\85\250\220\170\5\21\194\95\198\221", "\218\119\124\175\62\168\185")]) or v113[LUAOBFUSACTOR_DECRYPT_STR_0("\149\245\70\197\171\243\77", "\164\197\144\40")];
				v133 = ((v13:BuffUp(v113.ShadowCovenantBuff)) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\167\249\188\130\211\179\176\228\171\153\238\190\130\244\165\156", "\214\227\144\202\235\189")]) or v113[LUAOBFUSACTOR_DECRYPT_STR_0("\201\172\145\114\30\182\96\40\236\183", "\92\141\197\231\27\112\211\51")];
				v134 = ((v13:BuffUp(v113.ShadowCovenantBuff)) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\206\254\134\172\226\238\254\142\172\198", "\177\134\159\234\195")]) or v113[LUAOBFUSACTOR_DECRYPT_STR_0("\149\234\51\175", "\169\221\139\95\192")];
				v124 = v13:BuffDown(v113.RadiantProvidenceBuff);
				v175 = 6;
			end
			if ((3807 >= 1276) and (v175 == 2)) then
				v179 = false;
				v102 = false;
				if ((2220 <= 4361) and v98) then
					local v238 = 0;
					while true do
						if ((228 == 228) and (1 == v238)) then
							for v245, v246 in pairs(RampBothTimes) do
								for v255, v256 in pairs(v246) do
									if ((((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\191\49\232\48\72\243\136", "\129\237\80\152\68\61")]:CooldownRemains() + v10.CombatTime()) < v256) and ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\116\190\5\253\27\18\84\88\187\9", "\56\49\200\100\147\124\119")]:CooldownRemains() + v10.CombatTime()) < v256)) or (4118 <= 3578)) then
										if ((((v256 - v10.CombatTime()) < 22) and ((v256 - v10.CombatTime()) > 0)) or (2915 < 1909)) then
											v102 = true;
										end
									end
								end
							end
							break;
						end
						if ((634 <= 2275) and (v238 == 0)) then
							for v247, v248 in pairs(RampRaptureTimes) do
								for v257, v258 in pairs(v248) do
									if ((1091 <= 2785) and ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\26\160\212\104\11\49\52", "\66\72\193\164\28\126\67\81")]:CooldownRemains() + v10.CombatTime()) < v258)) then
										if ((4638 >= 2840) and ((v258 - v10.CombatTime()) < 22) and ((v258 - v10.CombatTime()) > 0)) then
											v102 = true;
										end
									end
								end
							end
							for v249, v250 in pairs(RampEvangelismTimes) do
								for v259, v260 in pairs(v250) do
									if (((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\194\58\169\86\33\115\235\37\187\85", "\22\135\76\200\56\70")]:CooldownRemains() + v10.CombatTime()) < v260) or (1292 > 4414)) then
										if ((3511 == 3511) and ((v260 - v10.CombatTime()) < 22) and ((v260 - v10.CombatTime()) > 0)) then
											v102 = true;
										end
									end
								end
							end
							v238 = 1;
						end
					end
				end
				v180 = v89;
				if ((2132 == 2132) and not v13:IsInRaid() and v13:IsInParty()) then
					v180 = v88;
				end
				v175 = 3;
			end
			if ((932 <= 3972) and (v175 == 3)) then
				if ((not v13:IsInRaid() and not v13:IsInParty()) or (4560 <= 2694)) then
					v180 = 1;
				end
				if ((v176 and (v135.FriendlyUnitsWithBuffCount(v113.AtonementBuff, false, false) >= v180)) or (2531 >= 3969)) then
					v176 = false;
				end
				if (v98 or (738 > 2193)) then
					local v239 = 0;
					while true do
						if ((4606 >= 3398) and (v239 == 1)) then
							if ((1853 > 1742) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\168\95\235\70\138\76\230\65\158\68", "\40\237\41\138")]:IsReady() and not v178) then
								for v261, v262 in pairs(RampEvangelismTimes) do
									if (v135.IsItTimeToRamp(v261, v262, 5) or (2442 > 2564)) then
										local v271 = 0;
										while true do
											if ((4374 >= 4168) and (v271 == 1)) then
												v101 = v10.CombatTime();
												break;
											end
											if ((v271 == 0) or (4576 > 4938)) then
												v178 = true;
												SetCVar(LUAOBFUSACTOR_DECRYPT_STR_0("\245\117\247\232\105\241\117\232", "\42\167\20\154\152"), 2);
												v271 = 1;
											end
										end
									end
								end
							end
							if ((2930 > 649) and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\111\232\163\76\118\36\70\247\177\79", "\65\42\158\194\34\17")]:IsReady() and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\40\38\66\24\56\255\30", "\142\122\71\50\108\77\141\123")]:IsReady() and not v179) then
								for v263, v264 in pairs(RampBothTimes) do
									if (v135.IsItTimeToRamp(v263, v264, 5) or (1394 < 133)) then
										local v272 = 0;
										while true do
											if ((1 == v272) or (432 == 495)) then
												v101 = v10.CombatTime();
												break;
											end
											if ((66 < 1456) and (v272 == 0)) then
												v179 = true;
												SetCVar(LUAOBFUSACTOR_DECRYPT_STR_0("\39\163\242\8\24\35\163\237", "\91\117\194\159\120"), 3);
												v272 = 1;
											end
										end
									end
								end
							end
							break;
						end
						if ((v239 == 0) or (878 >= 3222)) then
							SetCVar(LUAOBFUSACTOR_DECRYPT_STR_0("\254\63\178\224\239\8\190\226", "\144\172\94\223"), 0);
							if ((v113[LUAOBFUSACTOR_DECRYPT_STR_0("\22\14\178\83\49\29\167", "\39\68\111\194")]:IsReady() and not v177) or (254 >= 3289)) then
								for v265, v266 in pairs(RampRaptureTimes) do
									if (v135.IsItTimeToRamp(v265, v266, 5) or (2711 <= 705)) then
										local v273 = 0;
										while true do
											if ((1 == v273) or (2506 >= 3366)) then
												v101 = v10.CombatTime();
												break;
											end
											if ((v273 == 0) or (123 > 746)) then
												v177 = true;
												SetCVar(LUAOBFUSACTOR_DECRYPT_STR_0("\228\167\234\215\90\129\215\180", "\215\182\198\135\167\25"), 1);
												v273 = 1;
											end
										end
									end
								end
							end
							v239 = 1;
						end
					end
				end
				if (v13:IsDeadOrGhost() or (4444 <= 894)) then
					return;
				end
				if ((1376 > 583) and v13:IsMounted()) then
					return;
				end
				v175 = 4;
			end
			if ((v175 == 1) or (2427 == 2455)) then
				v98 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\30\43\232\65\20\63", "\143\45\113\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\185\17\44", "\92\216\216\124")];
				v99 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\111\61\171\71\241\94\33", "\157\59\82\204\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\46\241\255\232\238", "\209\88\94\131\154\137\138\179")];
				v176 = v99;
				v177 = false;
				v178 = false;
				v175 = 2;
			end
			if ((3393 >= 2729) and (v175 == 4)) then
				if ((4175 == 4175) and not v13:IsMoving()) then
					v100 = GetTime();
				end
				if ((4584 > 1886) and not v176) then
					if (v13:AffectingCombat() or v95 or v37 or (1043 >= 2280)) then
						local v242 = 0;
						local v243;
						while true do
							if ((v242 == 0) or (667 < 71)) then
								v243 = v37 and v113[LUAOBFUSACTOR_DECRYPT_STR_0("\42\8\44\17\51\232", "\68\122\125\94\120\85\145")]:IsReady();
								ShouldReturn = v135.FocusUnit(v243, nil, nil, nil, 20);
								v242 = 1;
							end
							if ((v242 == 1) or (4482 < 2793)) then
								if ((561 < 4519) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				Enemies40y = v13:GetEnemiesInRange(40);
				v118 = v13:GetEnemiesInMeleeRange(12);
				v120 = v13:GetEnemiesInMeleeRange(24);
				v175 = 5;
			end
		end
	end
	local function v156()
		local v181 = 0;
		while true do
			if ((v181 == 1) or (677 == 1434)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\158\235\9\229\236\170\238\19\232\224\250\210\8\239\224\169\246\90\222\165\172\162\75\182\171\232\172\74\182\165\152\251\90\196\234\181\239\49", "\133\218\130\122\134"));
				break;
			end
			if ((2827 == 2827) and (0 == v181)) then
				v136();
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\250\130\108\60\43\54\210\130\113\58\98\22\204\130\122\44\54\102\220\146\63\26\50\47\221\203\93\48\45\43\245", "\70\190\235\31\95\66"));
				v181 = 1;
			end
		end
	end
	v21.SetAPL(256, v155, v156);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\25\239\234\220\227\147\42\53\250\240\208\227\135\49\47\252\234\212\208\170\54\57\177\239\209\221", "\88\92\159\131\164\188\195")]();

