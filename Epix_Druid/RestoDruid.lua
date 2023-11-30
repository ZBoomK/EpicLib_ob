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
		if ((628 < 3999) and (v5 == 0)) then
			v6 = v0[v4];
			if ((3208 >= 56) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((4313 > 3373) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\213\11\216\199\228\23\227\168\211\17\245\209\206\44\226\245\203\11\208", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local v17 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\142\114\127\61\0", "\35\200\29\28\72\115\20\154")];
	local v18 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\52\176\196\204\136\3\34\28\173", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\136\70\204\172\54", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\100\87\12\49\64\113\16\32\69\78", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\149\215\210\7", "\75\220\163\183\106\98")];
	local v22 = EpicLib;
	local v23 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35", "\185\98\218\235\87")];
	local v24 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\4\192\47\154\38", "\232\73\161\76")];
	local v26 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v27 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v28 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\206\33\50\141\181\13", "\156\168\78\64\224\212\121")];
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v98 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\36\225\168\195\8\224\182", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\62\90\42\60\81\246\83", "\152\54\72\63\88\69\62")];
	local v99 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\240\214\251\85\208", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\91\22\61\40\255\19\76\87\10\39", "\114\56\62\101\73\71\141")];
	local v100 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\156\251\206\205\188", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\227\34\166\169\236\10\198\239\62\188", "\107\178\134\81\210\198\158")];
	local v101 = {};
	local v102 = v25[LUAOBFUSACTOR_DECRYPT_STR_0("\28\28\151\207\174", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\10\145\227\197\209\14\150\254\197\205", "\170\163\111\226\151")];
	local v103 = 0;
	local v104, v105;
	local v106 = 11111;
	local v107 = 11111;
	local v108 = false;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = false;
	local v113 = false;
	local v114 = false;
	local v115 = v14:GetEquipment();
	local v116 = (v115[13] and v21(v115[13])) or v21(0);
	local v117 = (v115[14] and v21(v115[14])) or v21(0);
	v10:RegisterForEvent(function()
		local v144 = 0;
		while true do
			if ((v144 == 1) or (4493 == 2225)) then
				v117 = (v115[14] and v21(v115[14])) or v21(0);
				break;
			end
			if ((3104 >= 3092) and (v144 == 0)) then
				v115 = v14:GetEquipment();
				v116 = (v115[13] and v21(v115[13])) or v21(0);
				v144 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\33\28\147\1\107\5\22\52\1\135\17\126\26\12\63\4\141\27\102\22\7\54\21\150", "\73\113\80\210\88\46\87"));
	v10:RegisterForEvent(function()
		local v145 = 0;
		while true do
			if ((3548 > 3098) and (v145 == 0)) then
				v106 = 11111;
				v107 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\177\0\236\43\194\179\19\255\55\192\164\2\242\55\201\160\14\225\55\195", "\135\225\76\173\114"));
	local function v118()
		if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\51\224\168\162\163\171\162\30\195\185\164\185\175\162\9\206\173\162\169", "\199\122\141\216\208\204\221")]:IsAvailable() or (3252 == 503)) then
			local v170 = 0;
			while true do
				if ((4733 > 2066) and (v170 == 0)) then
					v98[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\210\168\223\5\246\126\229", "\150\205\189\112\144\24")] = v12.MergeTable(v98.DispellableMagicDebuffs, v98.DispellableDiseaseDebuffs);
					v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\141\172\92\1\132\29\17\39\136\186\104\1\138\4\22\35\151", "\112\69\228\223\44\100\232\113")] = v12.MergeTable(v98.DispellableDebuffs, v98.DispellableCurseDebuffs);
					break;
				end
			end
		else
			v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\22\20\195\179\112\138\213\29\11\214\146\121\132\193\25\1\192", "\230\180\127\103\179\214\28")] = v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\12\76\86\225\77\236\141\7\83\67\201\64\231\133\6\123\67\230\84\230\138\22", "\128\236\101\63\38\132\33")];
		end
	end
	v10:RegisterForEvent(function()
		v118();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\141\138\37\109\128\206\240\156\133\48\125\147\217\240\159\153\52\103\159\202\227\133\147\48\112\159\196\225\147\138\57\101\152\204\234\136", "\175\204\201\113\36\214\139"));
	local function v119()
		return (v14:StealthUp(true, true) and 1.6) or 1;
	end
	v99[LUAOBFUSACTOR_DECRYPT_STR_0("\117\205\62\217", "\100\39\172\85\188")]:RegisterPMultiplier(v99.RakeDebuff, v119);
	local function v120()
		local v146 = 0;
		while true do
			if ((3549 >= 916) and (v146 == 3)) then
				v114 = not v108 and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\111\50\114\232\82", "\32\56\64\19\156\58")]:Count() > 0) and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\105\220\228\68\92\251\146\95", "\224\58\168\133\54\58\146")]:Count() > 0);
				break;
			end
			if ((2 == v146) or (2189 <= 245)) then
				v112 = (not v108 and (((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\158\108\184\146\53\164\106\188", "\83\205\24\217\224")]:Count() == 0) and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\209\215\204\41\238", "\93\134\165\173")]:Count() > 0)) or v14:IsCasting(v99.Wrath))) or v111;
				v113 = (not v108 and (((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\137\224\192\214\50", "\30\222\146\161\162\90\174\210")]:Count() == 0) and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\214\90\113\24\227\71\98\15", "\106\133\46\16")]:Count() > 0)) or v14:IsCasting(v99.Starfire))) or v110;
				v146 = 3;
			end
			if ((v146 == 0) or (1389 > 3925)) then
				v108 = v14:BuffUp(v99.EclipseSolar) or v14:BuffUp(v99.EclipseLunar);
				v109 = v14:BuffUp(v99.EclipseSolar) and v14:BuffUp(v99.EclipseLunar);
				v146 = 1;
			end
			if ((4169 >= 3081) and (1 == v146)) then
				v110 = v14:BuffUp(v99.EclipseLunar) and v14:BuffDown(v99.EclipseSolar);
				v111 = v14:BuffUp(v99.EclipseSolar) and v14:BuffDown(v99.EclipseLunar);
				v146 = 2;
			end
		end
	end
	local function v121(v147)
		return v147:DebuffRefreshable(v99.SunfireDebuff) and (v107 > 5);
	end
	local function v122(v148)
		return (v148:DebuffRefreshable(v99.MoonfireDebuff) and (v107 > 12) and ((((v105 <= 4) or (v14:Energy() < 50)) and v14:BuffDown(v99.HeartOfTheWild)) or (((v105 <= 4) or (v14:Energy() < 50)) and v14:BuffUp(v99.HeartOfTheWild))) and v148:DebuffDown(v99.MoonfireDebuff)) or (v14:PrevGCD(1, v99.Sunfire) and ((v148:DebuffUp(v99.MoonfireDebuff) and (v148:DebuffRemains(v99.MoonfireDebuff) < (v148:DebuffDuration(v99.MoonfireDebuff) * 0.8))) or v148:DebuffDown(v99.MoonfireDebuff)) and (v105 == 1));
	end
	local function v123(v149)
		return v149:DebuffRefreshable(v99.MoonfireDebuff) and (v149:TimeToDie() > 5);
	end
	local function v124(v150)
		return ((v150:DebuffRefreshable(v99.Rip) or ((v14:Energy() > 90) and (v150:DebuffRemains(v99.Rip) <= 10))) and (((v14:ComboPoints() == 5) and (v150:TimeToDie() > (v150:DebuffRemains(v99.Rip) + 24))) or (((v150:DebuffRemains(v99.Rip) + (v14:ComboPoints() * 4)) < v150:TimeToDie()) and ((v150:DebuffRemains(v99.Rip) + 4 + (v14:ComboPoints() * 4)) > v150:TimeToDie())))) or (v150:DebuffDown(v99.Rip) and (v14:ComboPoints() > (2 + (v105 * 2))));
	end
	local function v125(v151)
		return (v151:DebuffDown(v99.RakeDebuff) or v151:DebuffRefreshable(v99.RakeDebuff)) and (v151:TimeToDie() > 10) and (v14:ComboPoints() < 5);
	end
	local function v126(v152)
		return (v152:DebuffUp(v99.AdaptiveSwarmDebuff));
	end
	local function v127()
		return v98.FriendlyUnitsWithBuffCount(v99.Rejuvenation) + v98.FriendlyUnitsWithBuffCount(v99.Regrowth) + v98.FriendlyUnitsWithBuffCount(v99.Wildgrowth);
	end
	local function v128()
		return v98.FriendlyUnitsWithoutBuffCount(v99.Rejuvenation);
	end
	local function v129(v153)
		return v153:BuffUp(v99.Rejuvenation) or v153:BuffUp(v99.Regrowth) or v153:BuffUp(v99.Wildgrowth);
	end
	local function v130()
		local v154 = 0;
		while true do
			if ((349 <= 894) and (0 == v154)) then
				ShouldReturn = v98.HandleTopTrinket(v101, v31 and (v14:BuffUp(v99.HeartOfTheWild) or v14:BuffUp(v99.IncarnationBuff)), 40, nil);
				if ((731 <= 2978) and ShouldReturn) then
					return ShouldReturn;
				end
				v154 = 1;
			end
			if ((v154 == 1) or (892 > 3892)) then
				ShouldReturn = v98.HandleBottomTrinket(v101, v31 and (v14:BuffUp(v99.HeartOfTheWild) or v14:BuffUp(v99.IncarnationBuff)), 40, nil);
				if (ShouldReturn or (4466 == 900)) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v131()
		local v155 = 0;
		while true do
			if ((v155 == 2) or (2084 >= 2888)) then
				if ((479 < 1863) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\35\66\130\153\149\59\191\247\21", "\144\112\54\227\235\230\78\205")]:IsReady() and (v14:BuffDown(v99.CatForm))) then
					if (v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge)) or (2428 >= 4038)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\60\14\238\195\78\161\47\10\188\211\90\167\104\93\170", "\59\211\72\111\156\176");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\102\130\226\63\90\168\229\25\70\130\212\36\66\131", "\77\46\231\131")]:IsCastable() and v31 and ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\153\91\184\86\181\95\179\116\178\81\133\80\179\70\191\84\169", "\32\218\52\214")]:CooldownRemains() < 30) or not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\109\24\63\190\254\187\64\110\70\18\2\184\248\162\76\78\93", "\58\46\119\81\200\145\208\37")]:IsAvailable()) and v14:BuffDown(v99.HeartOfTheWild) and v16:DebuffUp(v99.SunfireDebuff) and (v16:DebuffUp(v99.MoonfireDebuff) or (v105 > 4))) or (2878 > 2897)) then
					if (v24(v99.HeartOfTheWild) or (2469 > 3676)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\137\49\190\189\130\57\45\179\36\164\172\130\33\34\128\52\236\170\188\34\107\222\102", "\86\75\236\80\204\201\221");
					end
				end
				if ((233 < 487) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\81\64\99\163\241\153\127", "\235\18\33\23\229\158")]:IsReady() and v14:BuffDown(v99.CatForm) and (v14:Energy() >= 30) and v35) then
					if ((2473 >= 201) and v24(v99.CatForm)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\187\213\132\86\181\211\182\16\185\192\175\16\232\153", "\219\48\218\161");
					end
				end
				if ((4120 >= 133) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\194\116\110\70\216\70\239\241\98\94\64\207\74", "\128\132\17\28\41\187\47")]:IsReady() and (((v14:ComboPoints() > 3) and (v16:TimeToDie() < 10)) or ((v14:ComboPoints() == 5) and (v14:Energy() >= 25) and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\51\59\22", "\61\97\82\102\90")]:IsAvailable() or (v16:DebuffRemains(v99.Rip) > 5))))) then
					if ((3080 >= 1986) and v24(v99.FerociousBite, not v16:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\43\185\68\196\94\17\28\191\17\169\66\211\82\94\10\173\58\235\24\149", "\105\204\78\203\43\167\55\126");
					end
				end
				v155 = 3;
			end
			if ((1 == v155) or (1439 > 3538)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\139\55\112\24\45\233\234", "\143\216\66\30\126\68\155")]:IsReady() and v14:BuffDown(v99.CatForm) and (v16:TimeToDie() > 5) and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\152\193\29", "\129\202\168\109\171\165\195\183")]:IsAvailable() or v16:DebuffUp(v99.Rip) or (v14:Energy() < 30))) or (419 < 7)) then
					if ((2820 == 2820) and v98.CastCycle(v99.Sunfire, v104, v121, not v16:IsSpellInRange(v99.Sunfire), nil, nil, v102.SunfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\77\57\222\215\6\227\98\91\54\204\158\70\182", "\134\66\56\87\184\190\116");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\17\62\6\181\31\226\51\48", "\85\92\81\105\219\121\139\65")]:IsReady() and v14:BuffDown(v99.CatForm) and (v16:TimeToDie() > 5) and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\207\186\64", "\191\157\211\48\37\28")]:IsAvailable() or v16:DebuffUp(v99.Rip) or (v14:Energy() < 30))) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v98.CastCycle(v99.Moonfire, v104, v122, not v16:IsSpellInRange(v99.Moonfire), nil, nil, v102.MoonfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\16\251\18\60\214\13\241\92\57\222\11\180\78\104", "\90\191\127\148\124");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\75\146\32\17\113\149\43", "\119\24\231\78")]:IsReady() and v16:DebuffDown(v99.SunfireDebuff) and (v16:TimeToDie() > 5)) or (1482 >= 4288)) then
					if (v24(v99.Sunfire, not v16:IsSpellInRange(v99.Sunfire)) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\145\56\171\76\213\82\20\194\46\164\94\156\18\69", "\113\226\77\197\42\188\32");
					end
				end
				if ((4774 == 4774) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\23\25\251\187\60\31\230\176", "\213\90\118\148")]:IsReady() and v14:BuffDown(v99.CatForm) and v16:DebuffDown(v99.MoonfireDebuff) and (v16:TimeToDie() > 5)) then
					if ((566 <= 960) and v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\33\187\88\75\82\60\177\22\78\90\58\244\4\25", "\45\59\78\212\54");
					end
				end
				v155 = 2;
			end
			if ((v155 == 4) or (2910 <= 1930)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\22\198\83\74\182", "\211\69\177\58\58")]:IsReady() and (v105 >= 2)) or (19 > 452)) then
					if (v24(v99.Swipe, not v16:IsInMeleeRange(8)) or (907 > 3152)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\242\112\229\236\139\180\228\109\181\186\147", "\171\215\133\25\149\137");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\210\192\32\255\235", "\34\129\168\82\154\143\80\156")]:IsReady() and ((v14:ComboPoints() < 5) or (v14:Energy() > 90))) or (2505 > 4470)) then
					if (v24(v99.Shred, not v16:IsInMeleeRange(5)) or (3711 > 4062)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\186\33\14\76\14\138\132\166\115\95\26", "\233\229\210\83\107\40\46");
					end
				end
				break;
			end
			if ((420 == 420) and (0 == v155)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\107\87\64\248", "\107\57\54\43\157\21\230\231")]:IsReady() and (v14:StealthUp(false, true))) or (33 >= 3494)) then
					if (v24(v99.Rake, not v16:IsInMeleeRange(10)) or (1267 == 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\138\26\240\249\223\206\207\203\67", "\175\187\235\113\149\217\188");
					end
				end
				if ((2428 < 3778) and UseTrinkets and not v14:StealthUp(false, true)) then
					local v212 = 0;
					local v213;
					while true do
						if ((v212 == 0) or (2946 <= 1596)) then
							v213 = v130();
							if ((4433 > 3127) and v213) then
								return v213;
							end
							break;
						end
					end
				end
				if ((4300 >= 2733) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\29\171\128\92\247\112\110\57\156\150\77\241\116", "\24\92\207\225\44\131\25")]:IsCastable()) then
					if ((4829 == 4829) and v24(v99.AdaptiveSwarm, not v16:IsSpellInRange(v99.AdaptiveSwarm))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\215\185\92\15\116\93\214\135\95\12\124\89\222\248\79\26\105", "\29\43\179\216\44\123");
					end
				end
				if ((1683 <= 4726) and v51 and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\158\214\46\90\178\210\37\120\181\220\19\92\180\203\41\88\174", "\44\221\185\64")]:IsCastable()) then
					if ((4835 >= 3669) and v14:BuffUp(v99.CatForm)) then
						if ((2851 > 1859) and (v14:BuffUp(v99.HeartOfTheWild) or (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\41\226\73\77\103\46\225\124\87\118\54\238\68\91", "\19\97\135\40\63")]:CooldownRemains() > 60) or not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\134\89\50\41\59\30\168\104\59\62\24\56\162\88", "\81\206\60\83\91\79")]:IsAvailable()) and (v14:Energy() < 50) and (((v14:ComboPoints() < 5) and (v16:DebuffRemains(v99.Rip) > 5)) or (v105 > 1))) then
							if ((3848 > 2323) and v24(v99.ConvokeTheSpirits, not v16:IsInRange(30))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\77\164\222\100\32\200\72\155\90\163\213\77\60\211\68\182\71\191\195\50\44\194\89\228\31\243", "\196\46\203\176\18\79\163\45");
							end
						end
					end
				end
				v155 = 1;
			end
			if ((2836 > 469) and (v155 == 3)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\151\163\51", "\49\197\202\67\126\115\100\167")]:IsAvailable() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\5\82\207", "\62\87\59\191\73\224\54")]:IsReady() and (v105 < 11) and v124(v16)) or (2096 <= 540)) then
					if (v24(v99.Rip, not v16:IsInMeleeRange(5)) or (3183 < 2645)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\11\234\137\228\3\238\137\180\86", "\169\135\98\154");
					end
				end
				if ((3230 <= 3760) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\255\127\54\85\238\59", "\168\171\23\68\52\157\83")]:IsReady() and (v105 >= 2) and v16:DebuffRefreshable(v99.ThrashDebuff)) then
					if ((3828 == 3828) and v24(v99.Thrash, not v16:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\224\121\231\172\54\37\199\247\112\225", "\231\148\17\149\205\69\77");
					end
				end
				if ((554 == 554) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\178\166\204\254", "\159\224\199\167\155\55")]:IsReady() and v125(v16)) then
					if (v24(v99.Rake, not v16:IsInMeleeRange(5)) or (2563 == 172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\242\55\215\183\240\61\198\183\160\106", "\178\151\147\92");
					end
				end
				if ((3889 >= 131) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\190\252\71\55", "\26\236\157\44\82\114\44")]:IsReady() and ((v14:ComboPoints() < 5) or (v14:Energy() > 90)) and (v16:PMultiplier(v99.Rake) <= v14:PMultiplier(v99.Rake)) and v126(v16)) then
					if (v24(v99.Rake, not v16:IsInMeleeRange(5)) or (492 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\47\222\94\106\45\212\79\106\122\133", "\59\74\78\181");
					end
				end
				v155 = 4;
			end
		end
	end
	local function v132()
		local v156 = 0;
		while true do
			if ((v156 == 2) or (4112 < 1816)) then
				if ((4525 >= 1223) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\125\5\57\124\71\2\50", "\26\46\112\87")]:IsReady()) then
					if ((1090 <= 4827) and v98.CastCycle(v99.Sunfire, v104, v121, not v16:IsSpellInRange(v99.Sunfire), nil, nil, v102.SunfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\54\165\114\182\173\64\244\182\52\167\52\238\237", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((v51 and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\153\130\166\196\181\134\173\230\178\136\155\194\179\159\161\198\169", "\178\218\237\200")]:IsCastable()) or (239 > 1345)) then
					if (v14:BuffUp(v99.MoonkinForm) or (3710 >= 3738)) then
						if (v24(v99.ConvokeTheSpirits, not v16:IsInRange(30)) or (3838 < 2061)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\181\186\232\198\185\190\227\239\162\189\227\239\165\165\239\194\191\161\245\144\187\186\233\222\189\188\232\144\231\237", "\176\214\213\134");
						end
					end
				end
				v156 = 3;
			end
			if ((v156 == 3) or (690 > 1172)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\195\191\183\192\160", "\57\148\205\214\180\200\54")]:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(8)) and ((v111 and (v105 == 1)) or v112 or (v114 and (v105 > 1)))) or (1592 > 2599)) then
					if ((3574 <= 4397) and v24(v99.Wrath, not v16:IsSpellInRange(v99.Wrath), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\239\52\32\126\82\242\34\56\54\67\169", "\22\114\157\85\84");
					end
				end
				if ((3135 > 1330) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\247\223\18\214\91\255\186\193", "\200\164\171\115\164\61\150")]:IsReady()) then
					if (v24(v99.Starfire, not v16:IsSpellInRange(v99.Starfire), true) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\224\2\87\133\183\230\6\5\140\169\248\67\20\213", "\227\222\148\99\37");
					end
				end
				break;
			end
			if ((1724 == 1724) and (1 == v156)) then
				if ((455 <= 1282) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\2\150\125\174\34\151\110\187\52", "\220\81\226\28")]:IsReady() and ((v105 < 6) or (not v110 and (v105 < 8))) and v35) then
					if ((4606 < 4876) and v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\193\131\233\249\210\1\210\135\187\229\208\31\149\218", "\167\115\181\226\155\138");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\207\45\232\82\125\120\212\231", "\166\130\66\135\60\27\17")]:IsReady() and ((v105 < 5) or (not v110 and (v105 < 7)))) or (1442 > 2640)) then
					if ((136 < 3668) and v98.CastCycle(v99.Moonfire, v104, v123, not v16:IsSpellInRange(v99.Moonfire), nil, nil, v102.MoonfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\69\193\123\54\77\88\203\53\63\83\70\142\36\96", "\80\36\42\174\21");
					end
				end
				v156 = 2;
			end
			if ((v156 == 0) or (1784 > 4781)) then
				if ((4585 > 3298) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\233\71\51\196\17\238\68\6\222\0\246\75\62\210", "\101\161\34\82\182")]:IsCastable() and v31 and ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains() < 30) or (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\29\48\247\231\49\52\252\197\54\58\202\225\55\45\240\229\45", "\145\94\95\153")]:CooldownRemains() > 90) or not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:IsAvailable()) and v14:BuffDown(v99.HeartOfTheWild)) then
					if (v24(v99.HeartOfTheWild) or (1664 > 1698)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\177\138\224\206\10\187\141\205\206\61\177\180\229\211\57\176\203\253\205\57\244\217", "\186\85\212\235\146");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\239\142\25\240\50\231\86\228\142\4\243", "\56\162\225\118\158\89\142")]:IsReady() and (v14:BuffDown(v99.MoonkinForm)) and v35) or (3427 < 2849)) then
					if ((3616 <= 4429) and v24(v99.MoonkinForm)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\10\207\161\41\209\82\58\198\160\48\213\28\10\215\163\98\140", "\184\60\101\160\207\66");
					end
				end
				v156 = 1;
			end
		end
	end
	local function v133()
		local v157 = 0;
		local v158;
		while true do
			if ((3988 >= 66) and (v157 == 1)) then
				if (ShouldReturn or (862 > 4644)) then
					return ShouldReturn;
				end
				v120();
				v158 = 0;
				if ((1221 == 1221) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\1\91\66", "\153\83\50\50\150")]:IsAvailable()) then
					v158 = v158 + 1;
				end
				v157 = 2;
			end
			if ((v157 == 2) or (45 > 1271)) then
				if ((3877 > 1530) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\120\25", "\45\61\22\19\124\19\203")]:IsAvailable()) then
					v158 = v158 + 1;
				end
				if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\245\26\31\244\17\120", "\217\161\114\109\149\98\16")]:IsAvailable() or (4798 == 1255)) then
					v158 = v158 + 1;
				end
				if (((v158 >= 2) and v16:IsInMeleeRange(8)) or (2541 > 2860)) then
					local v214 = 0;
					local v215;
					while true do
						if ((0 == v214) or (2902 > 3629)) then
							v215 = v131();
							if ((427 < 3468) and v215) then
								return v215;
							end
							break;
						end
					end
				end
				if ((4190 >= 2804) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\51\36\57\108\168\125\4\37\11\107\189\102\31", "\20\114\64\88\28\220")]:IsCastable()) then
					if ((2086 == 2086) and v24(v99.AdaptiveSwarm, not v16:IsSpellInRange(v99.AdaptiveSwarm))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\5\211\164\236\217\171\52\62\193\163\249\194\176\113\12\211\189\246", "\221\81\97\178\212\152\176");
					end
				end
				v157 = 3;
			end
			if ((4148 > 2733) and (4 == v157)) then
				if ((3054 >= 1605) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\192\101\247\30\22\67\225\116", "\42\147\17\150\108\112")]:IsReady() and (v105 > 2)) then
					if ((1044 < 1519) and v24(v99.Starfire, not v16:IsSpellInRange(v99.Starfire), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\178\44\109\225\225\29\163\109\112\240\228\79\247\123", "\136\111\198\77\31\135");
					end
				end
				if ((1707 <= 4200) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\53\27\166\66\181", "\201\98\105\199\54\221\132\119")]:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(8))) then
					if ((580 == 580) and v24(v99.Wrath, not v16:IsSpellInRange(v99.Wrath), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\30\130\53\10\117\161\184\5\141\97\81\101", "\204\217\108\227\65\98\85");
					end
				end
				if ((601 <= 999) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\115\204\250\235\42\201\76\198", "\160\62\163\149\133\76")]:IsReady() and (v14:BuffDown(v99.CatForm) or not v16:IsInMeleeRange(8))) then
					if ((3970 == 3970) and v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\175\2\33\197\223\178\8\111\206\215\169\3\111\144\132", "\163\182\192\109\79");
					end
				end
				if (true or (98 == 208)) then
					if ((2006 <= 3914) and v24(v99.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v157 == 0) or (3101 <= 2971)) then
				ShouldReturn = v98.InterruptWithStun(v99.IncapacitatingRoar, 8);
				if (ShouldReturn or (2073 <= 671)) then
					return ShouldReturn;
				end
				if ((3305 > 95) and v14:BuffUp(v99.CatForm) and (v14:ComboPoints() > 0)) then
					local v216 = 0;
					while true do
						if ((2727 == 2727) and (v216 == 0)) then
							ShouldReturn = v98.InterruptWithStun(v99.Maim, 8);
							if (ShouldReturn or (2970 >= 4072)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				ShouldReturn = v98.InterruptWithStun(v99.MightyBash, 8);
				v157 = 1;
			end
			if ((3881 > 814) and (v157 == 3)) then
				if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\224\232\18\245\17\196\233\59\244\8\192", "\122\173\135\125\155")]:IsAvailable() or (4932 < 4868)) then
					local v217 = 0;
					local v218;
					while true do
						if ((3667 <= 4802) and (v217 == 0)) then
							v218 = v132();
							if ((1260 >= 858) and v218) then
								return v218;
							end
							break;
						end
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\183\212\14\191\54\35\205", "\168\228\161\96\217\95\81")]:IsReady() and (v16:DebuffRefreshable(v99.SunfireDebuff))) or (3911 == 4700)) then
					if ((3000 < 4194) and v24(v99.Sunfire, not v16:IsSpellInRange(v99.Sunfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\196\32\90\38\69\222\145\35\93\38\89\155\131\122", "\55\187\177\78\60\79");
					end
				end
				if ((651 < 4442) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\0\193\80\229\64\198\146\40", "\224\77\174\63\139\38\175")]:IsReady() and (v16:DebuffRefreshable(v99.MoonfireDebuff))) then
					if (v24(v99.Moonfire, not v16:IsSpellInRange(v99.Moonfire)) or (195 >= 1804)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\78\87\32\130\72\74\43\196\76\89\39\138\1\10\120", "\78\228\33\56");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\253\106\179\17\150\219\108\181\6", "\229\174\30\210\99")]:IsReady() and (v14:BuffDown(v99.CatForm))) or (1382 > 2216)) then
					if (v24(v99.Starsurge, not v16:IsSpellInRange(v99.Starsurge)) or (2861 == 2459)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\249\135\67\254\40\43\28\232\198\92\236\52\55\91\191\222", "\89\123\141\230\49\141\93");
					end
				end
				v157 = 4;
			end
		end
	end
	local function v134()
		if ((1903 < 4021) and v17 and v98.DispellableFriendlyUnit() and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\26\39\20\213\231\49\53\35\213\231\49", "\149\84\70\96\160")]:IsReady()) then
			if (v24(v102.NaturesCureFocus) or (2270 >= 4130)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\54\7\25\248\42\3\30\210\59\19\31\232\120\2\4\254\40\3\1\173\106", "\141\88\102\109");
			end
		end
	end
	local function v135()
		local v159 = 0;
		while true do
			if ((2593 <= 3958) and (v159 == 1)) then
				if ((1176 == 1176) and v100[LUAOBFUSACTOR_DECRYPT_STR_0("\219\234\89\218\49\94\224\251\87\216\32", "\54\147\143\56\182\69")]:IsReady() and v44 and (v14:HealthPercentage() <= v45)) then
					if (v24(v102.Healthstone, nil, nil, true) or (3062 == 1818)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\132\254\69\203\222\146\235\70\209\211\193\251\76\217\211\143\236\64\201\211\193\172", "\191\182\225\159\41");
					end
				end
				if ((v38 and (v14:HealthPercentage() <= v40)) or (3717 < 3149)) then
					if ((3195 < 3730) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\25\23\46\71\142\148\202\34\28\47\21\163\130\195\39\27\38\82\203\183\205\63\27\39\91", "\162\75\114\72\53\235\231"))) then
						if ((2797 <= 3980) and v100[LUAOBFUSACTOR_DECRYPT_STR_0("\190\57\66\240\86\17\132\53\74\229\123\7\141\48\77\236\84\50\131\40\77\237\93", "\98\236\92\36\130\51")]:IsReady()) then
							if ((1944 <= 2368) and v24(v102.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\182\28\10\168\64\187\189\57\170\30\76\178\64\169\185\57\170\30\76\170\74\188\188\63\170\89\8\191\67\173\187\35\173\15\9\250\17", "\80\196\121\108\218\37\200\213");
							end
						end
					end
				end
				break;
			end
			if ((1709 < 4248) and (v159 == 0)) then
				if (((v14:HealthPercentage() <= v94) and v95 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\145\82\216\123\9\54\92\207", "\161\211\51\170\16\122\93\53")]:IsReady()) or (3970 == 3202)) then
					if (v24(v99.Barkskin, nil, nil, true) or (3918 >= 4397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\175\160\35\232\165\187\38\187\170\183\46\254\160\161\33\237\171\242\122", "\72\155\206\210");
					end
				end
				if (((v14:HealthPercentage() <= v96) and v97 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\116\127\90\11\36\71\118", "\83\38\26\52\110")]:IsReady()) or (780 == 3185)) then
					if (v24(v99.Renewal, nil, nil, true) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\18\41\67\79\22\43\6\92\18\33\67\86\4\46\80\93\87\117", "\38\56\119\71");
					end
				end
				v159 = 1;
			end
		end
	end
	local function v136()
		local v160 = 0;
		while true do
			if ((64 == 64) and (v160 == 2)) then
				if ((2202 >= 694) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\111\66\207\166\228\222\71\88\196", "\168\38\44\161\195\150")]:IsReady() and v14:BuffDown(v99.Innervate)) then
					if ((3706 <= 3900) and v24(v102.InnervatePlayer, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\242\140\115\34\254\183\2\133\188\144\119\61\248", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((2890 > 2617) and v14:BuffUp(v99.Innervate) and (v128() > 0) and v18 and v18:Exists() and v18:BuffRefreshable(v99.Rejuvenation)) then
					if (v24(v102.RejuvenationMouseover) or (3355 > 4385)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\235\83\149\84\235\87\129\86\231\86\142\125\237\64\131\78\235\25\146\67\227\73", "\224\34\142\57");
					end
				end
				break;
			end
			if ((0 == v160) or (3067 <= 2195)) then
				if ((3025 >= 2813) and (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(40))) then
					return;
				end
				if ((2412 >= 356) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\51\100\11\121\95\3\143\14\119", "\234\96\19\98\31\43\110")]:IsReady() and not v129(v17) and v14:BuffDown(v99.SoulOfTheForestBuff)) then
					if ((2070 > 1171) and v24(v102.RejuvenationFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\26\88\210\186\119\133\7\11\91\200\162\50\153\7\18\66", "\235\102\127\50\167\204\18");
					end
				end
				v160 = 1;
			end
			if ((1 == v160) or (4108 < 3934)) then
				if ((3499 >= 3439) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\99\182\252\37\80\35\85\175\241", "\78\48\193\149\67\36")]:IsReady() and v129(v17)) then
					if ((876 < 3303) and v24(v102.SwiftmendFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\9\137\30\85\61\27\142\28\1\34\31\141\8", "\33\80\126\224\120");
					end
				end
				if ((2922 <= 3562) and v14:BuffUp(v99.SoulOfTheForestBuff) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\219\161\15\192\91\254\167\20\208\84", "\60\140\200\99\164")]:IsReady()) then
					if ((2619 >= 1322) and v24(v102.WildgrowthFocus, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\144\253\8\34\165\149\251\19\50\170\199\230\5\43\178", "\194\231\148\100\70");
					end
				end
				v160 = 2;
			end
		end
	end
	local function v137()
		local v161 = 0;
		while true do
			if ((4133 >= 2404) and (v161 == 0)) then
				if (not v17 or not v17:Exists() or v17:IsDeadOrGhost() or not v17:IsInRange(40) or (1433 == 2686)) then
					return;
				end
				if (v36 or (4123 == 4457)) then
					local v219 = 0;
					while true do
						if ((v219 == 0) or (3972 <= 205)) then
							if (UseTrinkets or (3766 < 1004)) then
								local v244 = 0;
								local v245;
								while true do
									if ((1784 < 2184) and (v244 == 0)) then
										v245 = v130();
										if (v245 or (1649 > 4231)) then
											return v245;
										end
										break;
									end
								end
							end
							if ((3193 == 3193) and v52 and v31 and v14:AffectingCombat() and (v127() > 3) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\240\166\209\200\97\244\78\56\215\160\204\209", "\110\190\199\165\189\19\145\61")]:IsReady()) then
								if (v24(v99.NaturesVigil, nil, nil, true) or (3495 > 4306)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\212\234\99\253\153\194\201\212\97\225\140\206\214\171\127\237\138\203\211\229\112", "\167\186\139\23\136\235");
								end
							end
							if ((4001 > 3798) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\41\162\129\11\14\184\141\3\30", "\109\122\213\232")]:IsReady() and v80 and v14:BuffDown(v99.SoulOfTheForestBuff) and v129(v17) and (v17:HealthPercentage() <= v81)) then
								if (v24(v102.SwiftmendFocus) or (4688 <= 4499)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\253\224\171\54\250\250\167\62\234\183\170\53\239\251\171\62\233", "\80\142\151\194");
								end
							end
							if ((v14:BuffUp(v99.SoulOfTheForestBuff) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\52\207\123\72\4\212\120\91\23\206", "\44\99\166\23")]:IsReady() and v98.AreUnitsBelowHealthPercentage(v89, v90)) or (1567 <= 319)) then
								if (v24(v102.WildgrowthFocus, nil, true) or (4583 == 3761)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\107\254\37\50\52\182\115\224\61\62\12\183\115\227\47\118\59\161\125\251\32\56\52", "\196\28\151\73\86\83");
								end
							end
							v219 = 1;
						end
						if ((3454 > 1580) and (v219 == 2)) then
							if ((v14:AffectingCombat() and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\252\232\160\206\252\212\226\154\208\246\236\247\167\202\250\203\244", "\147\191\135\206\184")]:IsReady() and v98.AreUnitsBelowHealthPercentage(v61, v62)) or (1607 == 20)) then
								if (v24(v99.ConvokeTheSpirits) or (962 >= 4666)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\135\39\168\215\215\88\183\187\60\174\196\231\64\162\141\58\175\213\203\19\186\129\41\170\200\214\84", "\210\228\72\198\161\184\51");
								end
							end
							if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\21\76\253\17\97\199\57\71\196\17\97\202", "\174\86\41\147\112\19")]:IsReady() and v58 and (v17:HealthPercentage() <= v59)) or (1896 == 1708)) then
								if ((3985 >= 1284) and v24(v102.CenarionWardFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\88\5\131\10\55\6\30\165\100\23\140\25\33\79\25\174\90\12\132\5\34", "\203\59\96\237\107\69\111\113");
								end
							end
							if ((v14:BuffUp(v99.NaturesSwiftness) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\22\19\171\243\62\231\195\44", "\183\68\118\204\129\81\144")]:IsCastable()) or (1987 == 545)) then
								if (v24(v102.RegrowthFocus) or (4896 < 1261)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\28\168\119\246\4\149\26\165\79\247\28\139\8\185\126\225\24\145\78\165\117\229\7\139\0\170", "\226\110\205\16\132\107");
								end
							end
							if ((23 < 3610) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\197\194\244\204\83\238\208\211\206\72\237\215\238\220\82\248", "\33\139\163\128\185")]:IsReady() and v72 and (v17:HealthPercentage() <= v73)) then
								if (v24(v99.NaturesSwiftness) or (3911 < 2578)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\89\16\203\69\93\23\225\68\79\13\216\67\86\1\205\68\24\12\219\86\84\13\208\80", "\190\55\56\100");
								end
							end
							v219 = 3;
						end
						if ((v219 == 1) or (4238 < 87)) then
							if ((2538 == 2538) and v55 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\212\17\38\6\135\127\13\119\225\7\32\17\140\75", "\22\147\99\73\112\226\56\120")]:IsReady() and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\159\103\237\227\136\159\96\227\231\137\177\116\236\230", "\237\216\21\130\149")]:TimeSinceLastCast() > 5) and v98.AreUnitsBelowHealthPercentage(v56, v57)) then
								if ((4122 == 4122) and v24(v102.GroveGuardiansFocus, nil, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\133\92\80\73\181\246\89\151\79\77\91\185\200\80\145\14\87\90\177\197\87\140\73", "\62\226\46\63\63\208\169");
								end
							end
							if ((v14:AffectingCombat() and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\195\21\90\150\13\4\60\86", "\62\133\121\53\227\127\109\79")]:IsReady() and v14:BuffDown(v99.Flourish) and (v127() > 4) and v98.AreUnitsBelowHealthPercentage(v64, v65)) or (2371 > 2654)) then
								if (v24(v99.Flourish, nil, nil, true) or (3466 > 4520)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\22\24\61\224\196\167\177\24\84\58\240\215\162\171\30\19", "\194\112\116\82\149\182\206");
								end
							end
							if ((v14:AffectingCombat() and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\13\186\77\22\209\247\7\53\161\88\1", "\110\89\200\44\120\160\130")]:IsReady() and v98.AreUnitsBelowHealthPercentage(v83, v84)) or (951 >= 1027)) then
								if (v24(v99.Tranquility, nil, true) or (1369 > 2250)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\191\209\74\72\82\95\50\65\162\215\82\6\75\79\58\65\162\205\76", "\45\203\163\43\38\35\42\91");
								end
							end
							if ((v14:AffectingCombat() and v31 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\230\151\221\45\150\188\93\222\140\200\58", "\52\178\229\188\67\231\201")]:IsReady() and v14:BuffUp(v99.IncarnationBuff) and v98.AreUnitsBelowHealthPercentage(v86, v87)) or (937 > 3786)) then
								if (v24(v99.Tranquility, nil, true) or (901 > 4218)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\53\83\81\10\230\73\42\45\72\68\29\200\72\49\36\68\16\12\242\93\47\40\79\87", "\67\65\33\48\100\151\60");
								end
							end
							v219 = 2;
						end
						if ((4779 > 4047) and (v219 == 3)) then
							if ((4050 > 1373) and (v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\119\161\37\17\29\230", "\147\54\207\92\126\115\131"))) then
								if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\36\35\58\115\47\127\31\58", "\30\109\81\85\29\109")]:IsReady() and (v17:HealthPercentage() <= v67)) or (1037 > 4390)) then
									if ((1407 <= 1919) and v24(v102.IronBarkFocus)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\246\99\91\184\9\220\253\237\122\20\190\51\223\240\246\127\83", "\156\159\17\52\214\86\190");
									end
								end
							elseif ((2526 >= 1717) and (v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\154\238\179\183\238\192\179\176\183", "\220\206\143\221"))) then
								if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\175\111\34\25\250\205\192\141", "\178\230\29\77\119\184\172")]:IsReady() and (v17:HealthPercentage() <= v67) and (Commons.UnitGroupRole(v17) == LUAOBFUSACTOR_DECRYPT_STR_0("\193\159\36\48", "\152\149\222\106\123\23"))) or (3620 <= 2094)) then
									if (v24(v102.IronBarkFocus) or (1723 >= 2447)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\212\52\249\77\138\223\39\228\72\245\213\35\247\79\188\211\33", "\213\189\70\150\35");
									end
								end
							elseif ((v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\123\84\122\3\15\84\122\12\15\102\113\4\73", "\104\47\53\20")) or (1199 > 3543)) then
								if ((1617 < 3271) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\138\94\142\18\158\14\177\71", "\111\195\44\225\124\220")]:IsReady() and (v17:HealthPercentage() <= v67) and ((Commons.UnitGroupRole(v17) == LUAOBFUSACTOR_DECRYPT_STR_0("\236\103\46\88", "\203\184\38\96\19\203")) or (Commons.UnitGroupRole(v17) == LUAOBFUSACTOR_DECRYPT_STR_0("\17\86\88\109\235\11", "\174\89\19\25\33")))) then
									if ((3085 > 1166) and v24(v102.IronBarkFocus)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\38\0\93\64\200\133\10\61\25\18\70\242\134\7\38\28\85", "\107\79\114\50\46\151\231");
									end
								end
							end
							if ((4493 >= 3603) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\24\162\180\57\158\48\161\197\10\177\180\59\135", "\160\89\198\213\73\234\89\215")]:IsCastable() and v14:AffectingCombat()) then
								if ((2843 <= 2975) and v24(v102.AdaptiveSwarmFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\73\117\181\238\209\65\103\177\193\214\95\112\166\243\133\64\116\181\242\204\70\118", "\165\40\17\212\158");
								end
							end
							if ((v14:AffectingCombat() and v68 and (v98.UnitGroupRole(v17) == LUAOBFUSACTOR_DECRYPT_STR_0("\209\248\38\24", "\70\133\185\104\83")) and (v98.FriendlyUnitsWithBuffCount(v99.Lifebloom, true, false) < 1) and (v17:HealthPercentage() <= (v69 - (v26(v14:BuffUp(v99.CatForm)) * 15))) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\40\76\66\47\203\8\74\75\39", "\169\100\37\36\74")]:IsCastable() and v17:BuffRefreshable(v99.Lifebloom)) or (1989 <= 174)) then
								if (v24(v102.LifebloomFocus) or (209 > 2153)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\12\142\164\85\2\139\173\95\13\199\170\85\1\139\171\94\7", "\48\96\231\194");
								end
							end
							if ((v14:AffectingCombat() and v70 and (v98.UnitGroupRole(v17) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\252\123\32\6", "\227\168\58\110\77\121\184\207")) and (v98.FriendlyUnitsWithBuffCount(v99.Lifebloom, false, true) < 1) and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\78\50\187\69\163\220\99\170\108\40\183", "\197\27\92\223\32\209\187\17")]:IsAvailable() or v98.IsSoloMode()) and (v17:HealthPercentage() <= (v71 - (v26(v14:BuffUp(v99.CatForm)) * 15))) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\47\86\197\254\1\83\204\244\14", "\155\99\63\163")]:IsCastable() and v17:BuffRefreshable(v99.Lifebloom)) or (2020 == 1974)) then
								if (v24(v102.LifebloomFocus) or (1347 == 1360)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\142\216\167\136\187\136\141\222\172\205\177\129\131\221\168\131\190", "\228\226\177\193\237\217");
								end
							end
							v219 = 4;
						end
						if ((v219 == 5) or (4461 == 3572)) then
							if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\54\234\174\214\39\95\10\238\176\202\62\84", "\58\100\143\196\163\81")]:IsCastable() and v78 and v17:BuffRefreshable(v99.Rejuvenation) and (v17:HealthPercentage() <= v79)) or (2872 == 318)) then
								if ((568 == 568) and v24(v102.RejuvenationFocus)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\8\71\41\182\41\76\235\15\14\75\44\173\127\65\224\15\22\75\45\164", "\110\122\34\67\195\95\41\133");
								end
							end
							if ((4200 == 4200) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\71\180\92\88\217\98\165\83", "\182\21\209\59\42")]:IsCastable() and v76 and v17:BuffUp(v99.Rejuvenation) and (v17:HealthPercentage() <= v77)) then
								if (v24(v102.RegrowthFocus, nil, true) or (4285 < 1369)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\165\82\194\15\46\169\163\95\133\21\36\191\187\94\203\26", "\222\215\55\165\125\65");
								end
							end
							break;
						end
						if ((v219 == 4) or (3520 > 4910)) then
							if ((2842 <= 4353) and (v53 == LUAOBFUSACTOR_DECRYPT_STR_0("\4\188\34\255\49\162", "\134\84\208\67"))) then
								if ((v14:AffectingCombat() and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\54\170\128\80\28\190\131\79\16\169\136\95\22", "\60\115\204\230")]:TimeSinceLastCast() > 15)) or (3751 < 1643)) then
									if (v24(v102.EfflorescencePlayer) or (4911 == 3534)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\226\60\237\124\232\40\238\99\228\63\229\115\226\122\227\117\230\54\226\126\224\122\251\124\230\35\238\98", "\16\135\90\139");
									end
								end
							elseif ((3001 > 16) and (v53 == LUAOBFUSACTOR_DECRYPT_STR_0("\119\97\20\32\65\70", "\24\52\20\102\83\46\52"))) then
								if ((2875 <= 3255) and v14:AffectingCombat() and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\225\41\39\40\0\214\42\50\39\10\202\44\36", "\111\164\79\65\68")]:TimeSinceLastCast() > 15)) then
									if ((368 < 4254) and v24(v102.EfflorescenceCursor)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\195\223\133\210\33\248\195\202\128\219\32\233\195\153\139\219\47\230\207\215\132\158\45\255\212\202\140\204", "\138\166\185\227\190\78");
									end
								end
							elseif ((v53 == LUAOBFUSACTOR_DECRYPT_STR_0("\232\123\203\49\91\49\20\202\96\204\56\92", "\121\171\20\165\87\50\67")) or (4841 <= 2203)) then
								if ((4661 > 616) and v14:AffectingCombat() and (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\227\62\191\58\182\16\195\43\186\51\183\1\195", "\98\166\88\217\86\217")]:TimeSinceLastCast() > 15)) then
									if (v24(v99.Efflorescence) or (1943 == 2712)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\243\240\127\13\137\206\243\229\122\4\136\223\243\182\113\4\135\208\255\248\126\65\133\211\248\240\112\19\139\221\226\255\118\15", "\188\150\150\25\97\230");
									end
								end
							end
							if ((4219 >= 39) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\237\128\83\6\11\255\213\158\75\10", "\141\186\233\63\98\108")]:IsReady() and v91 and v98.AreUnitsBelowHealthPercentage(v92, v93) and (not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\194\253\37\176\49\252\239\34\178", "\69\145\138\76\214")]:IsAvailable() or not v99[LUAOBFUSACTOR_DECRYPT_STR_0("\67\216\128\143\171\27\117\193\141", "\118\16\175\233\233\223")]:IsReady())) then
								if ((3967 > 2289) and v24(v102.WildgrowthFocus, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\156\141\57\191\233\153\114\156\144\61\251\230\142\124\135\141\59\188", "\29\235\228\85\219\142\235");
								end
							end
							if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\15\209\189\207\120\89\51\90", "\50\93\180\218\189\23\46\71")]:IsCastable() and v74 and (v17:HealthPercentage() <= v75)) or (851 > 2987)) then
								if ((4893 >= 135) and v24(v102.RegrowthFocus, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\204\161\92\94\75\203\92\214\228\83\73\69\208\65\208\163", "\40\190\196\59\44\36\188");
								end
							end
							if ((v14:BuffUp(v99.Innervate) and (v128() > 0) and v18 and v18:Exists() and v18:BuffRefreshable(v99.Rejuvenation)) or (3084 > 3214)) then
								if (v24(v102.RejuvenationMouseover) or (3426 < 2647)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\46\64\214\161\236\120\3\61\81\213\187\244\66\14\37\70\208\177\186\117\8\61\73\213\186\253", "\109\92\37\188\212\154\29");
								end
							end
							v219 = 5;
						end
					end
				end
				break;
			end
		end
	end
	local function v138()
		local v162 = 0;
		local v163;
		while true do
			if ((v162 == 3) or (1576 == 4375)) then
				if (v163 or (2920 < 2592)) then
					return v163;
				end
				if ((v98.TargetIsValid() and v34) or (1110 >= 2819)) then
					local v220 = 0;
					while true do
						if ((1824 <= 2843) and (v220 == 0)) then
							v163 = v133();
							if ((3062 == 3062) and v163) then
								return v163;
							end
							break;
						end
					end
				end
				break;
			end
			if ((716 <= 4334) and (v162 == 2)) then
				if ((1001 < 3034) and v33) then
					local v221 = 0;
					while true do
						if ((v221 == 0) or (977 > 1857)) then
							v163 = v136();
							if (v163 or (868 > 897)) then
								return v163;
							end
							break;
						end
					end
				end
				v163 = v137();
				v162 = 3;
			end
			if ((1 == v162) or (1115 == 4717)) then
				v163 = v135();
				if ((2740 < 4107) and v163) then
					return v163;
				end
				v162 = 2;
			end
			if ((284 < 700) and (v162 == 0)) then
				if ((386 >= 137) and v46) then
					local v222 = 0;
					while true do
						if ((923 == 923) and (v222 == 0)) then
							v163 = v98.HandleAfflicted(v99.NaturesCure, v102.NaturesCureMouseover, 40);
							if (v163 or (4173 == 359)) then
								return v163;
							end
							v222 = 1;
						end
						if ((1722 == 1722) and (v222 == 2)) then
							v163 = v98.HandleAfflicted(v99.Regrowth, v102.RegrowthMouseover, 40, true);
							if (v163 or (3994 <= 3820)) then
								return v163;
							end
							v222 = 3;
						end
						if ((1488 < 1641) and (4 == v222)) then
							v163 = v98.HandleAfflicted(v99.Wildgrowth, v102.WildgrowthMouseover, 40, true);
							if ((433 <= 2235) and v163) then
								return v163;
							end
							break;
						end
						if ((1 == v222) or (1838 > 2471)) then
							v163 = v98.HandleAfflicted(v99.Rejuvenation, v102.RejuvenationMouseover, 40);
							if ((2444 < 3313) and v163) then
								return v163;
							end
							v222 = 2;
						end
						if ((v222 == 3) or (3685 <= 185)) then
							v163 = v98.HandleAfflicted(v99.Swiftmend, v102.SwiftmendMouseover, 40);
							if ((738 <= 1959) and v163) then
								return v163;
							end
							v222 = 4;
						end
					end
				end
				if (((v43 or v42) and v32) or (1317 == 3093)) then
					local v223 = 0;
					local v224;
					while true do
						if ((v223 == 0) or (2611 >= 4435)) then
							v224 = v134();
							if (v224 or (117 > 4925)) then
								return v224;
							end
							break;
						end
					end
				end
				v162 = 1;
			end
		end
	end
	local function v139()
		local v164 = 0;
		while true do
			if ((107 <= 4905) and (v164 == 0)) then
				if (v46 or (1004 > 4035)) then
					local v225 = 0;
					while true do
						if ((v225 == 3) or (2802 < 369)) then
							ShouldReturn = v98.HandleAfflicted(v99.Swiftmend, v102.SwiftmendMouseover, 40);
							if ((1497 <= 2561) and ShouldReturn) then
								return ShouldReturn;
							end
							v225 = 4;
						end
						if ((v225 == 2) or (816 > 1712)) then
							ShouldReturn = v98.HandleAfflicted(v99.Regrowth, v102.RegrowthMouseover, 40, true);
							if (ShouldReturn or (2733 == 2971)) then
								return ShouldReturn;
							end
							v225 = 3;
						end
						if ((2599 < 4050) and (v225 == 0)) then
							ShouldReturn = v98.HandleAfflicted(v99.NaturesCure, v102.NaturesCureMouseover, 40);
							if ((2034 == 2034) and ShouldReturn) then
								return ShouldReturn;
							end
							v225 = 1;
						end
						if ((3040 < 4528) and (v225 == 1)) then
							ShouldReturn = v98.HandleAfflicted(v99.Rejuvenation, v102.RejuvenationMouseover, 40);
							if (ShouldReturn or (2092 <= 2053)) then
								return ShouldReturn;
							end
							v225 = 2;
						end
						if ((2120 < 4799) and (v225 == 4)) then
							ShouldReturn = v98.HandleAfflicted(v99.Wildgrowth, v102.WildgrowthMouseover, 40, true);
							if (ShouldReturn or (4538 <= 389)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((270 <= 1590) and v47) then
					local v226 = 0;
					while true do
						if ((1625 > 1265) and (v226 == 0)) then
							ShouldReturn = v98.HandleIncorporeal(v99.Hibernate, v102.HibernateMouseover, 30, true);
							if (ShouldReturn or (51 >= 920)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v164 = 1;
			end
			if ((v164 == 2) or (2968 <= 1998)) then
				if ((v41 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\1\208\212\17\221\199\217\66\41\230\207\22\246", "\42\76\177\166\122\146\161\141")]:IsCastable() and (v14:BuffDown(v99.MarkOfTheWild, true) or v98.GroupBuffMissing(v99.MarkOfTheWild))) or (3085 <= 2742)) then
					if (v24(v102.MarkOfTheWildPlayer) or (376 >= 2083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\139\23\197\70\121\163\181\17\198\124\73\178\131\9\202", "\22\197\234\101\174\25");
					end
				end
				if ((4191 > 1232) and v98.TargetIsValid()) then
					if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\31\53\174\217", "\230\77\84\197\188\22\207\183")]:IsReady() and (v14:StealthUp(false, true))) or (1505 > 4873)) then
						if ((3880 < 4534) and v24(v99.Rake, not v16:IsInMeleeRange(10))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\235\21\205\249", "\85\153\116\166\156\236\193\144");
						end
					end
				end
				v164 = 3;
			end
			if ((3 == v164) or (2368 >= 2541)) then
				if ((v98.TargetIsValid() and v34) or (4733 <= 4103)) then
					local v227 = 0;
					while true do
						if ((v227 == 0) or (1207 == 4273)) then
							ShouldReturn = v133();
							if (ShouldReturn or (2005 == 2529)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
			if ((986 < 3589) and (v164 == 1)) then
				if (((v43 or v42) and v32) or (3119 == 430)) then
					local v228 = 0;
					local v229;
					while true do
						if ((2409 <= 3219) and (v228 == 0)) then
							v229 = v134();
							if (v229 or (898 > 2782)) then
								return v229;
							end
							break;
						end
					end
				end
				if ((v29 and v36) or (2250 <= 1764)) then
					local v230 = 0;
					local v231;
					while true do
						if ((693 == 693) and (v230 == 0)) then
							v231 = v137();
							if (v231 or (2529 == 438)) then
								return v231;
							end
							break;
						end
					end
				end
				v164 = 2;
			end
		end
	end
	local function v140()
		local v165 = 0;
		while true do
			if ((1751 > 1411) and (v165 == 6)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\41\226\28\218\55\209\48\197\34", "\86\163\91\141\114\152")] or 0;
				break;
			end
			if ((4182 == 4182) and (v165 == 5)) then
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\188\169\9\135\248\245\141\187\162\44\152\250\226\176\167\180\56\154\252\229\169", "\144\217\211\199\127\232\147")] or 0;
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\203\66\25\219\215\82\45\222\203\79", "\95\183\184\39")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\175\198\98\70\247\176\193\95\100", "\52\158\195\169\23")] or 0;
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\173\230\215\102\129\178\225\229\102\135\180\249", "\20\232\193\137\162")] or 0;
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\189\161\29\221\233\254\218\58\188\175\20\250", "\177\111\207\206\115\159\136\140")] or "";
				v165 = 6;
			end
			if ((v165 == 0) or (4666 <= 611)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\158\126\109\211\172\189\217\57\158", "\184\85\237\27\63\178\207\212")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\148\161\108\14\134\168\77\5\128\148\75\31\142\171\74", "\36\107\231\196")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\168\60\127\0\163\58\67\6\185\52\124\7\131\60\126\12", "\19\105\205\93")] or "";
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\206\192\194\166\197\198\254\160\223\200\193\161\227\241", "\174\207\171\161")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\26\227\33\45\27\237\35\42\61\238\9\27\0\234\8", "\108\76\105\134")];
				v165 = 1;
			end
			if ((v165 == 4) or (4737 <= 4525)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\250\203\181\14\100\108\115\250\192\170\10\77\106\85\250\203\182\27", "\25\18\136\164\195\107\35")] or 0;
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\255\46\249\13\210\131\63\229\36\212\63\221\144\41", "\226\77\140\75\186\104\188")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\155\216\120\3\160\93\119\40\143\220\100\6\154\100", "\70\216\189\22\98\210\52\24")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\199\246\49\14\235\242\58\44\236\252\12\8\237\235\54\12\247", "\132\153\95\120")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\12\44\255\240\207\229\55\42\236\204\212\233\17\43\253\236\236\208", "\164\128\99\66\137\159")] or 0;
				v165 = 5;
			end
			if ((4367 >= 3735) and (v165 == 2)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\136\222\42\48\168\28\186\138\223\60\44\162\39\177\136\220", "\85\212\233\176\78\92\205")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\187\48\230\82\45\255\165\48\212\73\43\226\134\48\246\78", "\95\138\213\68\131\32")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\119\240\93\62\107\241\72\56\86\234\84\53\78\236\81\56\124\232\81\63\109", "\56\76\25\132")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\211\215\22\39\46\200\211\7\1\52\207\198\0\61\51\209\199", "\85\92\189\163\115")] or 0;
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\27\144\21\98\40\215\47\132\21\101\38\212\56\140\27\67\29\210\43\176\0\79\59\211\58\144", "\186\78\227\112\38\73")];
				v165 = 3;
			end
			if ((2426 == 2426) and (v165 == 3)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\203\19\253\185\93\141\223\19\247\185\68\153\202\19\202\142\89\139\209\26", "\48\236\184\118\185\216")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\225\34\170\200\78\184\244\39\163\201\95\184\210\55\167\192\89", "\60\221\135\68\198\167")] or "";
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\195\81\246\76\33\242\75\198\82\244\64\54\223\104", "\151\56\165\55\154\35\83")] or 0;
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\102\44\132\245\131\186\19\241\96\40\177\227\133\173\24\197", "\118\182\21\73\195\135\236\204")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\180\192\220\56\0\152\170\177\162\198\203\51\52\165\155", "\203\195\198\175\170\93\71\237")] or 0;
				v165 = 4;
			end
			if ((21 < 1971) and (v165 == 1)) then
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\186\241\209\195\15\84\125\161\166\228\199\213", "\24\195\211\130\161\166\99\16")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\47\22\2\12\44\223\51\3\20\26", "\64\157\70\101\114\105")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\67\89\144\198\170\46\56\88\79\172\204\165\39", "\66\76\48\60\216\163\203")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\47\82\64\162\165\57\71\67\184\168\2\99", "\214\205\74\51\44")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\167\163\170\58\22\48\160\171\162\63\16\5\163\169", "\115\113\198\205\206\86")];
				v165 = 2;
			end
		end
	end
	local function v141()
		local v166 = 0;
		while true do
			if ((v166 == 5) or (2922 <= 441)) then
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\54\82\236\253\19\85\228\255\11\84\244\219\50", "\147\98\32\141")] or 0;
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\70\247\222\15\88\76\11", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\96\20\134\184\180\165\141\88\15\147\175\130\162\139\65\22", "\228\52\102\231\214\197\208")] or 0;
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\229\97\222\227\133\30\197", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\190\201\48\210\148\18\62\23\158\211\57\239\146\10\4\20\142\223", "\102\235\186\85\134\230\115\80")];
				v166 = 6;
			end
			if ((3624 >= 1136) and (v166 == 9)) then
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\200\83\40\251\0\242\215", "\149\164\173\39\92\146\110")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\52\21\61\27\9\248\52\27\22\20", "\123\147\71\112\127\122")];
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\200\150\101\79\194\202\145", "\38\172\173\226\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\20\34\234\90\16\32\199\125", "\143\45\113\76")] or 0;
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\189\8\40\177\182\27\47", "\92\216\216\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\33\169\114\248\85\55\187\65\241", "\157\59\82\204\32")];
				break;
			end
			if ((2043 < 2647) and (v166 == 2)) then
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\216\246\219\121\232\84\196\228\253\116", "\143\38\171\147\137\28")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\188\40\21\220\174\59\15\251\137", "\103\179\217\79")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\74\50\12\32\255\31\86\32\42\45\202\8\95\37\59\54\240", "\152\109\57\87\94\69")];
				v166 = 3;
			end
			if ((v166 == 8) or (354 >= 1534)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\117\206\211\10\187\132\2", "\113\222\16\186\167\99\213\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\7\247\242\41\28\244\225\58\6\211\198", "\150\78\110\155")] or 0;
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\51\245\173\16\184\83", "\32\229\165\71\129\196\126\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\128\200\133\134\199\204\158\208\137\166\199\204\156\212", "\181\163\233\164\225\225")] or 0;
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\142\42\99\89\133\57\100", "\23\48\235\94")][LUAOBFUSACTOR_DECRYPT_STR_0("\94\219\202\86\68\56\219\114\242\232", "\178\28\186\184\61\55\83")] or 0;
				v166 = 9;
			end
			if ((v166 == 6) or (3764 >= 4876)) then
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\9\42\75\123\218\37\68", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\159\132\57\54\76\29\129\140\35\62\109\6\136\128\31\23", "\57\116\237\229\87\71")] or 0;
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\180\249\243\126\224\64\185", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\33\8\4\35\237\246\63\0\30\43\204\237\54\12\45\32\247\234\35", "\152\159\83\105\106\82")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\195\69\230\192\82\134\213", "\60\225\166\49\146\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\13\42\29\8\11\43\25\61\37\22\19\39\45\32\62\39", "\103\79\126\79\74\97")];
				v166 = 7;
			end
			if ((3676 >= 703) and (v166 == 4)) then
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\12\191\148\21\122\69\11\183\162\12\119", "\19\35\127\218\199\98")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\220\255\169\183\251\121\177\209\227\198", "\223\181\171\150\207\195\150\28")] or 0;
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\243\183\141\26\63\241\241\167\176\4\55\235\249", "\94\159\128\210\217\104")];
				v166 = 5;
			end
			if ((3811 > 319) and (0 == v166)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\227\128\195\52\139\245\135\227\50\130\253\177\238\51\134", "\93\237\144\229\143")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\1\178\232\63\47\183\225\53\32\143\239\52\38\147\222", "\90\77\219\142")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\240\53\15\173\247\230\50\47\171\254\238", "\196\145\131\80\67")];
				v166 = 1;
			end
			if ((47 < 1090) and (v166 == 1)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\131\200\70\173\94\50\94\117\162\254", "\49\24\234\174\35\207\50\93")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\208\17\195\46\188\94\209\17\254\28\191\66\197\0\227\42\187\88", "\200\43\163\116\141\79")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\68\162\163\15\176\240\118\161\191\27\161\237\64\165\165\53\133", "\213\131\37\214\214\125")] or 0;
				v166 = 2;
			end
			if ((7 == v166) or (1371 >= 2900)) then
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\122\199\103\87\20\189\108", "\122\218\31\179\19\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\223\193\197\206\179\74\164\194\197\242\198\181\99\155\230", "\37\211\182\173\161\169\193")] or 0;
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\63\89\205\33\117\190\228", "\217\151\90\45\185\72\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\117\235\22\81\209\115\240\6\94\240\115\243\52\113\209\115\242\2", "\54\163\28\135\114")] or 0;
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\222\73\150\71\113\47\200", "\31\72\187\61\226\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\21\70\229\78\114\32\196\20\76\197\83\118", "\68\163\102\35\178\39\30")];
				v166 = 8;
			end
			if ((v166 == 3) or (1126 <= 504)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\230\143\47\70\77\38\235\186\56\79\72\55\240\128\21\121", "\58\82\131\232\93\41")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\109\38\121\174\18\107\53\78\165\25\106\42\68\165", "\203\120\30\67\43")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\26\19\179\202\143\17\24\178\213\133\17\49\150", "\188\234\127\121\198")] or 0;
				v166 = 4;
			end
		end
	end
	local function v142()
		local v167 = 0;
		while true do
			if ((v167 == 3) or (3732 == 193)) then
				if ((3344 >= 3305) and v14:IsMounted()) then
					return;
				end
				if (v14:IsMoving() or (2885 < 1925)) then
					v103 = GetTime();
				end
				if (v14:BuffUp(v99.TravelForm) or v14:BuffUp(v99.BearForm) or v14:BuffUp(v99.CatForm) or (4542 <= 1594)) then
					if ((338 <= 3505) and ((GetTime() - v103) < 1)) then
						return;
					end
				end
				if ((69 == 69) and v30) then
					local v232 = 0;
					while true do
						if ((v232 == 0) or (672 == 368)) then
							v104 = v16:GetEnemiesInSplashRange(8);
							v105 = #v104;
							break;
						end
					end
				else
					local v233 = 0;
					while true do
						if ((1019 == 1019) and (0 == v233)) then
							v104 = {};
							v105 = 1;
							break;
						end
					end
				end
				v167 = 4;
			end
			if ((0 == v167) or (290 > 2746)) then
				v140();
				v141();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\12\49\228\253\229\239\192", "\209\88\94\131\154\137\138\179")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\174\199", "\66\72\193\164\28\126\67\81")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\35\175\95\42\115\244", "\22\135\76\200\56\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\63\253", "\129\237\80\152\68\61")];
				v167 = 1;
			end
			if ((1923 < 4601) and (v167 == 4)) then
				if (v98.TargetIsValid() or v14:AffectingCombat() or (3957 == 2099)) then
					local v234 = 0;
					while true do
						if ((4006 > 741) and (v234 == 1)) then
							if ((2359 <= 3733) and (v107 == 11111)) then
								v107 = v10.FightRemains(v104, false);
							end
							break;
						end
						if ((v234 == 0) or (4596 <= 2402)) then
							v106 = v10.BossFightRemains(nil, true);
							v107 = v106;
							v234 = 1;
						end
					end
				end
				if ((2078 > 163) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16) and not v14:AffectingCombat() and v29) then
					local v235 = 0;
					local v236;
					while true do
						if ((4116 > 737) and (v235 == 0)) then
							v236 = v98.DeadFriendlyUnitsCount();
							if (v14:AffectingCombat() or (1175 > 4074)) then
								if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\28\249\136\31\211\58\244", "\161\78\156\234\118")]:IsReady() or (1361 == 4742)) then
									if (v24(v99.Rebirth, nil, true) or (4012 >= 4072)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\181\178\203\213\181\163\193", "\188\199\215\169");
									end
								end
							elseif ((3807 >= 1276) and (v236 > 1)) then
								if ((2220 <= 4361) and v24(v99.Revitalize, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\238\12\73\114\252\253\5\86\97\237", "\136\156\105\63\27");
								end
							elseif ((228 == 228) and v24(v99.Revive, not v16:IsInRange(40), true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\9\137\111\61\13\137", "\84\123\236\25");
							end
							break;
						end
					end
				end
				if (v36 or (4118 <= 3578)) then
					local v237 = 0;
					while true do
						if ((v237 == 0) or (2915 < 1909)) then
							DebugMessage = v136();
							if ((634 <= 2275) and DebugMessage) then
								return DebugMessage;
							end
							v237 = 1;
						end
						if ((1091 <= 2785) and (v237 == 1)) then
							DebugMessage = v137();
							if ((4638 >= 2840) and DebugMessage) then
								return DebugMessage;
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or (1292 > 4414)) then
					if ((3511 == 3511) and v14:AffectingCombat()) then
						local v240 = 0;
						local v241;
						while true do
							if ((2132 == 2132) and (v240 == 0)) then
								v241 = v138();
								if ((932 <= 3972) and v241) then
									return v241;
								end
								break;
							end
						end
					elseif (v29 or (4560 <= 2694)) then
						local v242 = 0;
						local v243;
						while true do
							if ((v242 == 0) or (2531 >= 3969)) then
								v243 = v139();
								if (v243 or (738 > 2193)) then
									return v243;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((4606 >= 3398) and (v167 == 1)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\101\167\3\244\16\18\75", "\56\49\200\100\147\124\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\58\172", "\144\172\94\223")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\0\165\64\40\10\177", "\39\68\111\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\175\244\215\124\187", "\215\182\198\135\167\25")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\70\237\79\129\76\249", "\40\237\41\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\117\247\232", "\42\167\20\154\152")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\241\165\69\125\36\89", "\65\42\158\194\34\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\55\65", "\142\122\71\50\108\77\141\123")];
				v167 = 2;
			end
			if ((1853 > 1742) and (2 == v167)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\173\248\31\55\16\177", "\91\117\194\159\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\13\45\30\58\227\41", "\68\122\125\94\120\85\145")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\19\200\89\196\220\169", "\218\119\124\175\62\168\185")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\245\73\200\172\254\79", "\164\197\144\40")];
				if (v14:IsDeadOrGhost() or (2442 > 2564)) then
					return;
				end
				if ((4374 >= 4168) and (v14:AffectingCombat() or v42)) then
					local v238 = 0;
					local v239;
					while true do
						if ((v238 == 0) or (4576 > 4938)) then
							v239 = v42 and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\173\241\190\158\207\179\144\211\191\153\216", "\214\227\144\202\235\189")]:IsReady() and v32;
							if ((2930 > 649) and v98.IsTankBelowHealthPercentage(v67) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\196\183\136\117\50\178\65\55", "\92\141\197\231\27\112\211\51")]:IsReady() and ((v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\210\254\132\168\145\201\241\134\186", "\177\134\159\234\195")) or (v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\137\234\49\171\137\188\229\59\224\250\184\231\57", "\169\221\139\95\192")))) then
								local v246 = 0;
								while true do
									if ((v246 == 0) or (1394 < 133)) then
										ShouldReturn = v98.FocusUnit(v239, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\234\170\81\20", "\70\190\235\31\95\66"), 20);
										if (ShouldReturn or (432 == 495)) then
											return ShouldReturn;
										end
										break;
									end
								end
							elseif ((66 < 1456) and (v14:HealthPercentage() < v67) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\147\240\21\232\199\187\240\17", "\133\218\130\122\134")]:IsReady() and (v66 == LUAOBFUSACTOR_DECRYPT_STR_0("\8\254\237\207\156\162\54\56\191\208\193\208\165", "\88\92\159\131\164\188\195"))) then
								local v247 = 0;
								while true do
									if ((0 == v247) or (878 >= 3222)) then
										ShouldReturn = v98.FocusUnit(v239, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\168\11\158\103\242\217", "\189\224\78\223\43\183\139"), 20);
										if (ShouldReturn or (254 >= 3289)) then
											return ShouldReturn;
										end
										break;
									end
								end
							else
								local v248 = 0;
								while true do
									if ((0 == v248) or (2711 <= 705)) then
										ShouldReturn = v98.FocusUnit(v239, nil, nil, nil, 20);
										if (ShouldReturn or (2506 >= 3366)) then
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
				v167 = 3;
			end
		end
	end
	local function v143()
		local v168 = 0;
		while true do
			if ((v168 == 1) or (123 > 746)) then
				v118();
				break;
			end
			if ((v168 == 0) or (4444 <= 894)) then
				v22.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\194\142\185\3\163\167\241\159\163\24\162\245\212\153\191\30\168\245\194\132\190\22\184\188\255\133\234\21\181\245\213\155\163\20\226", "\213\144\235\202\119\204"));
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\17\29\205\62\39\49\76\55\17\209\36\104\7\95\54\17\218\106\16\99\91\99\73\142\100\122\109\29\115\88\252\51\104\1\66\44\21\245", "\45\67\120\190\74\72\67"));
				v168 = 1;
			end
		end
	end
	v22.SetAPL(105, v142, v143);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\5\50\228\189\198\172\252\252\41\38\210\151\252\155\250\230\4\48\248\172\253\198\226\252\33", "\137\64\66\141\197\153\232\142")]();

