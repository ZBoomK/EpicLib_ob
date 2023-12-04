local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((8869 - 6096) == (2704 + 69)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Priest_Discipline.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Focus;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = v9.Utils;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Press;
	local v24 = v20.Macro;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = string.format;
	local v28;
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
	local v94 = false;
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = 0 - 0;
	local v100 = 0 - 0;
	local v101 = false;
	RampRaptureTimes = {};
	RampRaptureTimes[3756 - (1036 + 37)] = {(136 - 66),(1650 - (641 + 839)),(688 - 418)};
	RampEvangelismTimes = {};
	RampEvangelismTimes[4367 - (1466 + 218)] = {(1283 - (556 + 592)),(1033 - (329 + 479)),(1363 - 966)};
	RampBothTimes = {};
	RampBothTimes[5554 - 2874] = {(754 - (396 + 343)),(1622 - (29 + 1448)),(941 - 691)};
	RampBothTimes[12522 - 9840] = {(1542 - (389 + 1138)),(114 + 6),(182 + 13),(507 - 222)};
	RampBothTimes[1643 + 1041] = {(1874 - (821 + 1038)),(21 + 164),(131 + 219)};
	RampBothTimes[6659 - 3972] = {(1 + 4),(3 + 112),(509 - (300 + 4)),(772 - 477)};
	RampBothTimes[3050 - (112 + 250)] = {(112 - 67),(73 + 67),(115 + 115)};
	RampBothTimes[1998 + 691] = {(234 - 129),(898 - (627 + 66)),(907 - (512 + 90))};
	RampBothTimes[4599 - (1665 + 241)] = {(7 + 8),(329 - 204),(1284 - (35 + 1064)),(524 - 279)};
	RampBothTimes[11 + 2674] = {(1337 - (233 + 1026)),(90 + 85),(80 + 189),(579 - (55 + 166))};
	local v112 = v17.Priest.Discipline;
	local v113 = v18.Priest.Discipline;
	local v114 = v24.Priest.Discipline;
	local v115 = {};
	local v116;
	local v117, v118;
	local v119, v120;
	local v121, v122;
	local v123, v124;
	local v125, v126, v127, v128, v129, v130;
	local v131, v132, v133;
	local v134 = v20.Commons.Everyone;
	local function v135()
		if (((224 + 931) <= (169 + 1504)) and v112.ImprovedPurify:IsAvailable()) then
			v134.DispellableDebuffs = v19.MergeTable(v134.DispellableMagicDebuffs, v134.DispellableDiseaseDebuffs);
		else
			v134.DispellableDebuffs = v134.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v135();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v136(v156)
		return v156:DebuffRefreshable(v112.ShadowWordPain) and (v156:TimeToDie() >= (45 - 33));
	end
	local function v137()
		return false;
	end
	local function v138()
		if ((v112.Purify:IsReady() and v96 and v134.DispellableFriendlyUnit()) or ((2621 - (36 + 261)) <= (1010 - 432))) then
			if (((5135 - (34 + 1334)) == (1449 + 2318)) and v23(v114.PurifyFocus)) then
				return "purify dispel";
			end
		end
	end
	local function v139()
		local v157 = 0 + 0;
		while true do
			if (((5372 - (1035 + 248)) == (4110 - (20 + 1))) and (v157 == (1 + 0))) then
				if (((4777 - (134 + 185)) >= (2807 - (549 + 584))) and v113.Healthstone:IsReady() and v47 and (v12:HealthPercentage() <= v48)) then
					if (((1657 - (314 + 371)) <= (4867 - 3449)) and v23(v114.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				if ((v29 and (v12:HealthPercentage() <= v31)) or ((5906 - (478 + 490)) < (2523 + 2239))) then
					if ((v30 == "Refreshing Healing Potion") or ((3676 - (786 + 386)) > (13811 - 9547))) then
						if (((3532 - (1055 + 324)) == (3493 - (1093 + 247))) and v113.RefreshingHealingPotion:IsReady()) then
							if (v23(v114.RefreshingHealingPotion, nil, nil, true) or ((451 + 56) >= (273 + 2318))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((17790 - 13309) == (15207 - 10726)) and (v157 == (0 - 0))) then
				if ((v112.Fade:IsReady() and v45 and (v12:HealthPercentage() <= v46)) or ((5849 - 3521) < (247 + 446))) then
					if (((16673 - 12345) == (14917 - 10589)) and v23(v112.Fade, nil, nil, true)) then
						return "fade defensive";
					end
				end
				if (((1198 + 390) >= (3406 - 2074)) and v112.DesperatePrayer:IsReady() and v43 and (v12:HealthPercentage() <= v44)) then
					if (v23(v112.DesperatePrayer) or ((4862 - (364 + 324)) > (11645 - 7397))) then
						return "desperate_prayer defensive";
					end
				end
				v157 = 2 - 1;
			end
		end
	end
	local function v140()
		local v158 = 0 + 0;
		while true do
			if ((v158 == (0 - 0)) or ((7344 - 2758) <= (248 - 166))) then
				ShouldReturn = v134.HandleTopTrinket(v115, v95, 1308 - (1249 + 19), nil);
				if (((3487 + 376) == (15036 - 11173)) and ShouldReturn) then
					return ShouldReturn;
				end
				v158 = 1087 - (686 + 400);
			end
			if ((v158 == (1 + 0)) or ((511 - (73 + 156)) <= (1 + 41))) then
				ShouldReturn = v134.HandleBottomTrinket(v115, v95, 851 - (721 + 90), nil);
				if (((52 + 4557) >= (2486 - 1720)) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v141()
		if (((GetTime() - v99) > v35) or ((1622 - (224 + 246)) == (4030 - 1542))) then
			local v180 = 0 - 0;
			while true do
				if (((621 + 2801) > (80 + 3270)) and (v180 == (0 + 0))) then
					if (((1742 - 865) > (1251 - 875)) and v112.BodyandSoul:IsAvailable() and v112.PowerWordShield:IsReady() and v34 and v12:BuffDown(v112.AngelicFeatherBuff) and v12:BuffDown(v112.BodyandSoulBuff)) then
						if (v23(v114.PowerWordShieldPlayer) or ((3631 - (203 + 310)) <= (3844 - (1238 + 755)))) then
							return "power_word_shield_player move";
						end
					end
					if ((v112.AngelicFeather:IsReady() and v33 and v12:BuffDown(v112.AngelicFeatherBuff) and v12:BuffDown(v112.BodyandSoulBuff) and v12:BuffDown(v112.AngelicFeatherBuff)) or ((12 + 153) >= (5026 - (709 + 825)))) then
						if (((7276 - 3327) < (7073 - 2217)) and v23(v114.AngelicFeatherPlayer)) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v142(v159)
		if (v131:IsReady() or ((5140 - (196 + 668)) < (11907 - 8891))) then
			local v181 = 0 - 0;
			while true do
				if (((5523 - (171 + 662)) > (4218 - (4 + 89))) and (v181 == (0 - 0))) then
					if ((v14 and (v14:HealthPercentage() <= v60)) or ((19 + 31) >= (3935 - 3039))) then
						if (v12:BuffUp(v112.ShadowCovenantBuff) or ((673 + 1041) >= (4444 - (35 + 1451)))) then
							if (v23(v114.DarkReprimandFocus) or ((2944 - (28 + 1425)) < (2637 - (941 + 1052)))) then
								return "dark_reprimand_focus penance";
							end
						elseif (((676 + 28) < (2501 - (822 + 692))) and v23(v114.PenanceFocus)) then
							return "penance_focus penance";
						end
					end
					if (((5307 - 1589) > (898 + 1008)) and not v159 and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) <= v62)) then
						if (v23(v131, not v13:IsSpellInRange(v131)) or ((1255 - (45 + 252)) > (3597 + 38))) then
							return "penance penance";
						end
					end
					break;
				end
			end
		end
	end
	local function v143()
		local v160 = 0 + 0;
		while true do
			if (((8520 - 5019) <= (4925 - (114 + 319))) and (v160 == (1 - 0))) then
				if ((v112.PowerWordLife:IsReady() and v69 and (v14:HealthPercentage() <= v70) and v14:Exists()) or ((4410 - 968) < (1625 + 923))) then
					if (((4283 - 1408) >= (3067 - 1603)) and v23(v114.PowerWordLifeFocus)) then
						return "power_word_life heal_cooldown";
					end
				end
				if ((v112.LuminousBarrier:IsReady() and v71 and v134.AreUnitsBelowHealthPercentage(v72, v73)) or ((6760 - (556 + 1407)) >= (6099 - (741 + 465)))) then
					if (v23(v112.LuminousBarrier) or ((1016 - (170 + 295)) > (1090 + 978))) then
						return "luminous_barrier heal_cooldown";
					end
				end
				break;
			end
			if (((1942 + 172) > (2324 - 1380)) and (v160 == (0 + 0))) then
				if ((v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v12:BuffUp(v112.RadiantProvidenceBuff)) or ((1451 + 811) >= (1754 + 1342))) then
					if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((3485 - (957 + 273)) >= (946 + 2591))) then
						return "power_word_radiance_instant heal_cooldown";
					end
				end
				if ((v68 == "Anyone") or ((1537 + 2300) < (4976 - 3670))) then
					if (((7773 - 4823) == (9010 - 6060)) and v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67)) then
						if (v23(v114.PainSuppressionFocus, nil, nil, true) or ((23386 - 18663) < (5078 - (389 + 1391)))) then
							return "pain_suppression heal_cooldown";
						end
					end
				elseif (((713 + 423) >= (17 + 137)) and (v68 == "Tank Only")) then
					if ((v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67) and (Commons.UnitGroupRole(v14) == "TANK")) or ((616 - 345) > (5699 - (783 + 168)))) then
						if (((15908 - 11168) >= (3101 + 51)) and v23(v114.PainSuppressionFocus, nil, nil, true)) then
							return "pain_suppression heal_cooldown";
						end
					end
				elseif ((v68 == "Tank and Self") or ((2889 - (309 + 2)) >= (10410 - 7020))) then
					if (((1253 - (1090 + 122)) <= (539 + 1122)) and v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67) and ((Commons.UnitGroupRole(v14) == "TANK") or (Commons.UnitGroupRole(v14) == "HEALER"))) then
						if (((2018 - 1417) < (2437 + 1123)) and v23(v114.PainSuppressionFocus, nil, nil, true)) then
							return "pain_suppression heal_cooldown";
						end
					end
				end
				v160 = 1119 - (628 + 490);
			end
		end
	end
	local function v144()
		if (((43 + 192) < (1700 - 1013)) and v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v12:BuffUp(v112.RadiantProvidenceBuff) and v14:Exists()) then
			if (((20788 - 16239) > (1927 - (431 + 343))) and v23(v114.PowerWordRadianceFocus, nil, v123)) then
				return "power_word_radiance_instant heal_cooldown";
			end
		end
		if ((v112.PowerWordLife:IsReady() and v69 and (v14:HealthPercentage() <= v70) and v14:Exists()) or ((9439 - 4765) < (13515 - 8843))) then
			if (((2898 + 770) < (584 + 3977)) and v23(v114.PowerWordLifeFocus)) then
				return "power_word_life heal_cooldown";
			end
		end
		if ((v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) or ((2150 - (556 + 1139)) == (3620 - (6 + 9)))) then
			if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((488 + 2175) == (1697 + 1615))) then
				return "power_word_radiance 2 heal";
			end
		end
		if (((4446 - (28 + 141)) <= (1734 + 2741)) and v133:IsReady() and v134.TargetIsValid() and v13:IsInRange(37 - 7) and v56 and v134.AreUnitsBelowHealthPercentage(v57, v58)) then
			if (v23(v114.HaloPlayer, not v14:IsInRange(22 + 8), true) or ((2187 - (486 + 831)) == (3093 - 1904))) then
				return "halo heal";
			end
		end
		if (((5467 - 3914) <= (593 + 2540)) and v132:IsReady() and v134.TargetIsValid() and v13:IsInRange(94 - 64) and v59 and not v14:IsFacingBlacklisted()) then
			if (v23(v114.DivineStarPlayer) or ((3500 - (668 + 595)) >= (3160 + 351))) then
				return "divine_star heal";
			end
		end
		if ((v112.UltimatePenitence:IsReady() and v95 and v12:AffectingCombat() and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v90, false, false) >= v91)) or ((267 + 1057) > (8235 - 5215))) then
			if (v23(v112.UltimatePenitence) or ((3282 - (23 + 267)) == (3825 - (1129 + 815)))) then
				return "ultimate_penitence heal";
			end
		end
		if (((3493 - (371 + 16)) > (3276 - (1326 + 424))) and v112.Evangelism:IsReady() and v95 and v74 and v12:AffectingCombat() and (v134.FriendlyUnitsBelowHealthPercentageCount(v75) > v76) and not v12:IsInRaid() and v12:IsInParty() and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) <= v62)) then
			if (((5724 - 2701) < (14141 - 10271)) and v23(v112.Evangelism)) then
				return "evangelism heal";
			end
		end
		if (((261 - (88 + 30)) > (845 - (720 + 51))) and v112.FlashHeal:IsReady() and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffDown(v112.PowerWordShield) and v14:BuffDown(v112.Renew))) and (v14:HealthPercentage() < v78) and v12:BuffUp(v112.SurgeofLight) and v14:Exists()) then
			if (((39 - 21) < (3888 - (421 + 1355))) and v23(v114.FlashHealFocus, nil, v124)) then
				return "flash_heal_instant heal";
			end
		end
		if (((1809 - 712) <= (800 + 828)) and v112.Rapture:IsReady() and not v12:IsInRaid() and v12:IsInParty() and v80 and v95 and v12:AffectingCombat() and (v14:HealthPercentage() < v81) and (v134.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) >= v82) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) then
			if (((5713 - (286 + 797)) == (16925 - 12295)) and v23(v114.RaptureFocus)) then
				return "rapture heal";
			end
		end
		if (((5863 - 2323) > (3122 - (397 + 42))) and v112.PowerWordShield:IsReady() and (v134.UnitGroupRole(v14) == "TANK") and (v14:HealthPercentage() < v85) and (v14:BuffDown(v112.AtonementBuff) or v14:BuffDown(v112.PowerWordShield)) and v14:Exists()) then
			if (((1498 + 3296) >= (4075 - (24 + 776))) and v23(v114.PowerWordShieldFocus)) then
				return "power_word_shield_tank heal";
			end
		end
		if (((2285 - 801) == (2269 - (222 + 563))) and v112.FlashHeal:IsReady() and v112.BindingHeals:IsAvailable() and (v14:GUID() ~= v12:GUID()) and v14:BuffDown(v112.AtonementBuff) and v12:BuffDown(v112.AtonementBuff) and (v14:HealthPercentage() < v79) and v14:Exists()) then
			if (((3154 - 1722) < (2560 + 995)) and v23(v114.FlashHealFocus, nil, v124)) then
				return "flash_heal heal";
			end
		end
		if ((v112.PowerWordShield:IsReady() and (v14:HealthPercentage() < v84) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) or ((1255 - (23 + 167)) > (5376 - (690 + 1108)))) then
			if (v23(v114.PowerWordShieldFocus) or ((1731 + 3064) < (1161 + 246))) then
				return "power_word_shield heal";
			end
		end
		if (((2701 - (40 + 808)) < (793 + 4020)) and v112.Renew:IsReady() and (v14:HealthPercentage() < v83) and v14:BuffDown(v112.AtonementBuff) and v14:BuffDown(v112.Renew) and v14:Exists()) then
			if (v23(v114.RenewFocus) or ((10787 - 7966) < (2324 + 107))) then
				return "renew heal";
			end
		end
		if ((v131:IsReady() and v94 and (not v12:AffectingCombat() or not v134.TargetIsValid()) and (v14:HealthPercentage() < v60) and v14:Exists()) or ((1521 + 1353) < (1197 + 984))) then
			local v182 = 571 - (47 + 524);
			while true do
				if ((v182 == (0 + 0)) or ((7350 - 4661) <= (512 - 169))) then
					ShouldReturn = v142(true);
					if (ShouldReturn or ((4262 - 2393) == (3735 - (1165 + 561)))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if ((v112.FlashHeal:IsReady() and v94 and (not v12:AffectingCombat() or not v134.TargetIsValid()) and (v14:HealthPercentage() < v77) and v14:Exists()) or ((106 + 3440) < (7191 - 4869))) then
			if (v23(v114.FlashHealFocus, nil, true) or ((795 + 1287) == (5252 - (341 + 138)))) then
				return "flash_heal_ooc heal";
			end
		end
	end
	local function v145()
		local v161 = 0 + 0;
		while true do
			if (((6694 - 3450) > (1381 - (89 + 237))) and (v161 == (3 - 2))) then
				if ((v112.Shadowfiend:IsReady() and v95 and (v12:ManaPercentage() < (189 - 99)) and not v112.Mindbender:IsAvailable() and not v12:BuffUp(v112.ShadowCovenantBuff) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) or ((4194 - (581 + 300)) <= (2998 - (855 + 365)))) then
					if (v23(v112.Shadowfiend) or ((3375 - 1954) >= (687 + 1417))) then
						return "shadowfiend damage";
					end
				end
				if (((3047 - (1030 + 205)) <= (3051 + 198)) and v112.Mindbender:IsReady() and v95 and not v12:BuffUp(v112.ShadowCovenantBuff) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) then
					if (((1510 + 113) <= (2243 - (156 + 130))) and v23(v112.Mindbender)) then
						return "mindbender damage";
					end
				end
				if (((10024 - 5612) == (7435 - 3023)) and v112.MindBlast:IsReady()) then
					if (((3584 - 1834) >= (222 + 620)) and v23(v112.MindBlast, not v13:IsSpellInRange(v112.MindBlast), true)) then
						return "mind_blast 10 long_scov";
					end
				end
				if (((2550 + 1822) > (1919 - (10 + 59))) and v112.ShadowWordDeath:IsReady() and ((v13:HealthPercentage() < (6 + 14)) or v12:BuffUp(v112.ShadowCovenantBuff))) then
					if (((1142 - 910) < (1984 - (671 + 492))) and v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath))) then
						return "shadow_word_death 1 long_scov";
					end
				end
				v161 = 2 + 0;
			end
			if (((1733 - (369 + 846)) < (239 + 663)) and (v161 == (3 + 0))) then
				if (((4939 - (1036 + 909)) > (683 + 175)) and v131:IsReady() and (v134.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) < v62)) then
					if (v23(v131, not v13:IsSpellInRange(v131)) or ((6304 - 2549) <= (1118 - (11 + 192)))) then
						return "penance damage";
					end
				end
				if (((1995 + 1951) > (3918 - (135 + 40))) and ((v112.Mindbender:CooldownRemains() > v131:Cooldown()) or (v112.Shadowfiend:CooldownRemains() > v131:Cooldown())) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) then
					local v219 = 0 - 0;
					while true do
						if ((v219 == (0 + 0)) or ((2940 - 1605) >= (4955 - 1649))) then
							ShouldReturn = v142();
							if (((5020 - (50 + 126)) > (6273 - 4020)) and ShouldReturn) then
								return "penance damage";
							end
							break;
						end
					end
				end
				if (((101 + 351) == (1865 - (1233 + 180))) and v112.MindBlast:IsReady() and ((v112.Mindbender:CooldownRemains() > v112.MindBlast:Cooldown()) or (v112.Shadowfiend:CooldownRemains() > v112.MindBlast:Cooldown()))) then
					if (v23(v112.MindBlast, not v13:IsSpellInRange(v112.MindBlast), true) or ((5526 - (522 + 447)) < (3508 - (107 + 1314)))) then
						return "mind_blast damage";
					end
				end
				if (((1798 + 2076) == (11804 - 7930)) and v112.Mindgames:IsReady() and ((v112.Mindbender:CooldownRemains() > v112.Mindgames:Cooldown()) or (v112.ShadowFiend:CooldownRemains() > v112.Mindgames:Cooldown())) and v112.ShatteredPerceptions:IsAvailable()) then
					if (v23(v112.Mindgames, not v13:IsSpellInRange(v112.Mindgames), true) or ((824 + 1114) > (9799 - 4864))) then
						return "mindgames 1 damage";
					end
				end
				v161 = 15 - 11;
			end
			if ((v161 == (1914 - (716 + 1194))) or ((73 + 4182) < (367 + 3056))) then
				if (((1957 - (74 + 429)) <= (4805 - 2314)) and v133:IsReady() and v134.TargetIsValid() and v13:IsInRange(15 + 15)) then
					if (v23(v114.HaloPlayer, not v13:IsInRange(68 - 38), true) or ((2941 + 1216) <= (8641 - 5838))) then
						return "halo damage";
					end
				end
				if (((11999 - 7146) >= (3415 - (279 + 154))) and v132:IsReady() and v134.TargetIsValid() and v13:IsInRange(808 - (454 + 324)) and not v13:IsFacingBlacklisted()) then
					if (((3253 + 881) > (3374 - (12 + 5))) and v23(v114.DivineStarPlayer, not v13:IsInRange(17 + 13))) then
						return "divine_star damage";
					end
				end
				if ((v112.ShadowWordDeath:IsReady() and (v13:TimeToX(50 - 30) > ((0.5 + 0) * v112.ShadowWordDeath:Cooldown()))) or ((4510 - (277 + 816)) < (10827 - 8293))) then
					if (v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath)) or ((3905 - (1058 + 125)) <= (31 + 133))) then
						return "shadow_word_death 3 damage";
					end
				end
				if ((v112.HolyNova:IsReady() and (v12:BuffStack(v112.RhapsodyBuff) == (995 - (815 + 160)))) or ((10331 - 7923) < (5006 - 2897))) then
					if (v23(v112.HolyNova) or ((8 + 25) == (4253 - 2798))) then
						return "holy_nova 1 damage";
					end
				end
				v161 = 1903 - (41 + 1857);
			end
			if ((v161 == (1895 - (1222 + 671))) or ((1144 - 701) >= (5770 - 1755))) then
				if (((4564 - (229 + 953)) > (1940 - (1111 + 663))) and v95 and v12:BuffUp(v112.PowerInfusionBuff)) then
					local v220 = 1579 - (874 + 705);
					while true do
						if ((v220 == (0 + 0)) or ((192 + 88) == (6358 - 3299))) then
							ShouldReturn = v140();
							if (((53 + 1828) > (1972 - (642 + 37))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((538 + 1819) == (378 + 1979)) and v112.PurgeTheWicked:IsReady() and (v13:TimeToDie() > ((0.3 - 0) * v112.PurgeTheWicked:BaseDuration())) and v13:DebuffRefreshable(v112.PurgeTheWickedDebuff)) then
					if (((577 - (233 + 221)) == (284 - 161)) and v23(v112.PurgeTheWicked, not v13:IsSpellInRange(v112.PurgeTheWicked))) then
						return "purge_the_wicked damage";
					end
				end
				if ((v112.ShadowWordPain:IsReady() and not v112.PurgeTheWicked:IsAvailable() and (v13:TimeToDie() > ((0.3 + 0) * v112.ShadowWordPain:BaseDuration())) and v13:DebuffRefreshable(v112.ShadowWordPain)) or ((2597 - (718 + 823)) >= (2135 + 1257))) then
					if (v23(v112.ShadowWordPain, not v13:IsSpellInRange(v112.ShadowWordPain)) or ((1886 - (266 + 539)) < (3043 - 1968))) then
						return "shadow_word_pain damage";
					end
				end
				if ((v112.ShadowWordDeath:IsReady() and (v13:HealthPercentage() < (1245 - (636 + 589)))) or ((2489 - 1440) >= (9140 - 4708))) then
					if (v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath)) or ((3779 + 989) <= (308 + 538))) then
						return "shadow_word_death 1 damage";
					end
				end
				v161 = 1018 - (657 + 358);
			end
			if ((v161 == (13 - 8)) or ((7650 - 4292) <= (2607 - (1151 + 36)))) then
				if (v112.Smite:IsReady() or ((3611 + 128) <= (791 + 2214))) then
					if (v23(v112.Smite, not v13:IsSpellInRange(v112.Smite), true) or ((4954 - 3295) >= (3966 - (1552 + 280)))) then
						return "smite damage";
					end
				end
				if (v12:IsMoving() or ((4094 - (64 + 770)) < (1599 + 756))) then
					ShouldReturn = v141();
					if (ShouldReturn or ((1518 - 849) == (750 + 3473))) then
						return ShouldReturn;
					end
				end
				if ((v112.PurgeTheWicked:IsReady() and v13:DebuffRefreshable(v112.PurgeTheWickedDebuff)) or ((2935 - (157 + 1086)) < (1176 - 588))) then
					if (v23(v112.PurgeTheWicked, not v13:IsSpellInRange(v112.PurgeTheWicked)) or ((21009 - 16212) < (5600 - 1949))) then
						return "purge_the_wicked_movement damage";
					end
				end
				if (v112.ShadowWordPain:IsReady() or ((5701 - 1524) > (5669 - (599 + 220)))) then
					if (v23(v112.ShadowWordPain, not v13:IsSpellInRange(v112.ShadowWordPain)) or ((796 - 396) > (3042 - (1813 + 118)))) then
						return "shadow_word_pain_movement damage";
					end
				end
				break;
			end
			if (((2231 + 820) > (2222 - (841 + 376))) and (v161 == (0 - 0))) then
				ShouldReturn = v134.InterruptWithStun(v112.PsychicScream, 2 + 6);
				if (((10080 - 6387) <= (5241 - (464 + 395))) and ShouldReturn) then
					return ShouldReturn;
				end
				if ((v112.DispelMagic:IsReady() and v96 and v37 and not v12:IsCasting() and not v12:IsChanneling() and v134.UnitHasMagicBuff(v13)) or ((8422 - 5140) > (1969 + 2131))) then
					if (v23(v112.DispelMagic, not v13:IsSpellInRange(v112.DispelMagic)) or ((4417 - (467 + 370)) < (5877 - 3033))) then
						return "dispel_magic damage";
					end
				end
				if (((66 + 23) < (15391 - 10901)) and v112.ArcaneTorrent:IsReady() and v28 and v95 and (v12:ManaPercentage() <= (14 + 71))) then
					if (v23(v112.ArcaneTorrent) or ((11592 - 6609) < (2328 - (150 + 370)))) then
						return "arcane_torrent damage";
					end
				end
				v161 = 1283 - (74 + 1208);
			end
		end
	end
	local function v146()
		local v162 = 0 - 0;
		while true do
			if (((18159 - 14330) > (2682 + 1087)) and (v162 == (391 - (14 + 376)))) then
				if (((2575 - 1090) <= (1880 + 1024)) and v14) then
					local v221 = 0 + 0;
					while true do
						if (((4072 + 197) == (12508 - 8239)) and (v221 == (0 + 0))) then
							if (((465 - (23 + 55)) <= (6592 - 3810)) and v36) then
								local v242 = 0 + 0;
								while true do
									if ((v242 == (0 + 0)) or ((2943 - 1044) <= (289 + 628))) then
										ShouldReturn = v138();
										if (ShouldReturn or ((5213 - (652 + 249)) <= (2344 - 1468))) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							if (((4100 - (708 + 1160)) <= (7046 - 4450)) and v95) then
								local v243 = 0 - 0;
								while true do
									if (((2122 - (10 + 17)) < (828 + 2858)) and (v243 == (1732 - (1400 + 332)))) then
										ShouldReturn = v143();
										if (ShouldReturn or ((3059 - 1464) >= (6382 - (242 + 1666)))) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							v221 = 1 + 0;
						end
						if ((v221 == (1 + 0)) or ((3937 + 682) < (3822 - (850 + 90)))) then
							ShouldReturn = v144();
							if (ShouldReturn or ((514 - 220) >= (6221 - (360 + 1030)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((1796 + 233) <= (8704 - 5620)) and v134.TargetIsValid()) then
					local v222 = 0 - 0;
					while true do
						if ((v222 == (1661 - (909 + 752))) or ((3260 - (109 + 1114)) == (4430 - 2010))) then
							ShouldReturn = v145();
							if (((1736 + 2722) > (4146 - (6 + 236))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				elseif (((275 + 161) >= (100 + 23)) and v12:IsMoving()) then
					local v228 = 0 - 0;
					while true do
						if (((873 - 373) < (2949 - (1076 + 57))) and (v228 == (0 + 0))) then
							ShouldReturn = v141();
							if (((4263 - (579 + 110)) == (283 + 3291)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
			if (((196 + 25) < (207 + 183)) and ((407 - (174 + 233)) == v162)) then
				ShouldReturn = v139();
				if (ShouldReturn or ((6181 - 3968) <= (2493 - 1072))) then
					return ShouldReturn;
				end
				v162 = 1 + 0;
			end
		end
	end
	local function v147()
		if (((4232 - (663 + 511)) < (4336 + 524)) and v112.PowerWordFortitude:IsReady() and v32 and (v12:BuffDown(v112.PowerWordFortitudeBuff, true) or v134.GroupBuffMissing(v112.PowerWordFortitudeBuff))) then
			if (v23(v114.PowerWordFortitudePlayer) or ((282 + 1014) >= (13706 - 9260))) then
				return "power_word_fortitude";
			end
		end
		if (v14 or ((844 + 549) > (10568 - 6079))) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (0 + 0)) or ((8610 - 4186) < (20 + 7))) then
					if (v36 or ((183 + 1814) > (4537 - (478 + 244)))) then
						ShouldReturn = v138();
						if (((3982 - (440 + 77)) > (870 + 1043)) and ShouldReturn) then
							return ShouldReturn;
						end
					end
					if (((2682 - 1949) < (3375 - (655 + 901))) and v94) then
						local v229 = 0 + 0;
						while true do
							if ((v229 == (0 + 0)) or ((2968 + 1427) == (19156 - 14401))) then
								ShouldReturn = v144();
								if (ShouldReturn or ((5238 - (695 + 750)) < (8089 - 5720))) then
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
		if (v12:IsMoving() or ((6302 - 2218) == (1065 - 800))) then
			local v184 = 351 - (285 + 66);
			while true do
				if (((10158 - 5800) == (5668 - (682 + 628))) and (v184 == (0 + 0))) then
					ShouldReturn = v141();
					if (ShouldReturn or ((3437 - (176 + 123)) < (416 + 577))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if (((2416 + 914) > (2592 - (239 + 30))) and v13 and v13:Exists() and v13:IsAPlayer() and v13:IsDeadOrGhost() and not v12:CanAttack(v13)) then
			local v185 = 0 + 0;
			local v186;
			while true do
				if ((v185 == (0 + 0)) or ((6417 - 2791) == (12444 - 8455))) then
					v186 = v134.DeadFriendlyUnitsCount();
					if ((v186 > (316 - (306 + 9))) or ((3196 - 2280) == (465 + 2206))) then
						if (((167 + 105) == (131 + 141)) and v23(v112.MassResurrection, nil, true)) then
							return "mass_resurrection";
						end
					elseif (((12150 - 7901) <= (6214 - (1140 + 235))) and v23(v112.Resurrection, nil, true)) then
						return "resurrection";
					end
					break;
				end
			end
		end
		if (((1768 + 1009) < (2935 + 265)) and v112.PowerWordFortitude:IsReady() and (v12:BuffDown(v112.PowerWordFortitudeBuff, true) or v134.GroupBuffMissing(v112.PowerWordFortitudeBuff))) then
			if (((25 + 70) < (2009 - (33 + 19))) and v23(v114.PowerWordFortitudePlayer)) then
				return "power_word_fortitude";
			end
		end
	end
	local function v148()
		local v163 = 0 + 0;
		while true do
			if (((2475 - 1649) < (757 + 960)) and (v163 == (1 - 0))) then
				if (((1338 + 88) >= (1794 - (586 + 103))) and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < v86))) then
					if (((251 + 2503) <= (10402 - 7023)) and v12:BuffUp(v112.Rapture)) then
						if (v112.PowerWordShield:IsReady() or ((5415 - (1309 + 179)) == (2550 - 1137))) then
							if (v23(v114.PowerWordShieldFocus) or ((503 + 651) <= (2116 - 1328))) then
								return "power_word_shield heal";
							end
						end
					elseif (v112.Renew:IsReady() or ((1242 + 401) > (7178 - 3799))) then
						if (v23(v114.RenewFocus) or ((5585 - 2782) > (5158 - (295 + 314)))) then
							return "renew heal";
						end
					end
				end
				break;
			end
			if ((v163 == (0 - 0)) or ((2182 - (1300 + 662)) >= (9489 - 6467))) then
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, v86, nil, nil, 1775 - (1178 + 577));
				if (((1466 + 1356) == (8342 - 5520)) and ShouldReturn) then
					return ShouldReturn;
				end
				v163 = 1406 - (851 + 554);
			end
		end
	end
	local function v149()
		local v164 = GetTime() - v100;
		if ((v164 > (18 + 2)) or ((2942 - 1881) == (4032 - 2175))) then
			ShouldRaptureRamp = false;
			v100 = 302 - (115 + 187);
		end
		v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (3 + 0));
		ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 6 + 0, nil, nil, 78 - 58);
		if (((3921 - (160 + 1001)) > (1194 + 170)) and ShouldReturn) then
			return ShouldReturn;
		end
		if ((not v112.Rapture:IsReady() and v12:BuffDown(v112.Rapture)) or ((3383 + 1519) <= (7359 - 3764))) then
			if (v112.PowerWordRadiance:IsReady() or ((4210 - (237 + 121)) == (1190 - (525 + 372)))) then
				if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((2955 - 1396) == (15074 - 10486))) then
					return "power_word_radiance_instant heal_cooldown";
				end
			end
		end
		if (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (148 - (96 + 46))) or ((5261 - (643 + 134)) == (285 + 503))) then
			local v187 = 0 - 0;
			while true do
				if (((16959 - 12391) >= (3747 + 160)) and (v187 == (0 - 0))) then
					if (((2546 - 1300) < (4189 - (316 + 403))) and v112.PowerWordShield:IsReady()) then
						if (((2704 + 1364) >= (2672 - 1700)) and v23(v114.PowerWordShieldFocus)) then
							return "power_word_shield heal";
						end
					end
					if (((179 + 314) < (9803 - 5910)) and v112.Rapture:IsReady()) then
						if (v23(v114.RaptureFocus) or ((1044 + 429) >= (1074 + 2258))) then
							return "rapture heal";
						end
					end
					break;
				end
			end
		end
	end
	local function v150()
		local v165 = 0 - 0;
		local v166;
		while true do
			if ((v165 == (0 - 0)) or ((8415 - 4364) <= (67 + 1090))) then
				v166 = GetTime() - v100;
				if (((1188 - 584) < (141 + 2740)) and (v166 > (58 - 38))) then
					local v223 = 17 - (12 + 5);
					while true do
						if ((v223 == (0 - 0)) or ((1920 - 1020) == (7178 - 3801))) then
							ShouldEvangelismRamp = false;
							v100 = 0 - 0;
							break;
						end
					end
				end
				v165 = 1 + 0;
			end
			if (((6432 - (1656 + 317)) > (527 + 64)) and (v165 == (3 + 0))) then
				if (((9035 - 5637) >= (11787 - 9392)) and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (360 - (5 + 349))))) then
					if (v112.PowerWordShield:IsReady() or ((10368 - 8185) >= (4095 - (266 + 1005)))) then
						if (((1276 + 660) == (6605 - 4669)) and v23(v114.PowerWordShieldFocus)) then
							return "power_word_shield heal";
						end
					end
					if ((v166 > (8 - 1)) or ((6528 - (561 + 1135)) < (5619 - 1306))) then
						if (((13437 - 9349) > (4940 - (507 + 559))) and v112.PowerWordRadiance:IsReady()) then
							if (((10870 - 6538) == (13397 - 9065)) and v23(v114.PowerWordRadianceFocus, nil, v123)) then
								return "power_word_radiance_instant heal_cooldown";
							end
						elseif (((4387 - (212 + 176)) >= (3805 - (250 + 655))) and v112.Evangelism:IsReady()) then
							if (v23(v112.Evangelism) or ((6885 - 4360) > (7100 - 3036))) then
								return "evangelism heal";
							end
						end
					end
					if (((6838 - 2467) == (6327 - (1869 + 87))) and v112.Renew:IsReady()) then
						if (v23(v114.RenewFocus) or ((922 - 656) > (6887 - (484 + 1417)))) then
							return "renew heal";
						end
					end
				end
				break;
			end
			if (((4267 - 2276) >= (1549 - 624)) and ((775 - (48 + 725)) == v165)) then
				if (((743 - 288) < (5507 - 3454)) and ShouldReturn) then
					return ShouldReturn;
				end
				if (not v112.Evangelism:IsReady() or ((481 + 345) == (12963 - 8112))) then
					ShouldReturn = v145();
					if (((52 + 131) == (54 + 129)) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				v165 = 856 - (152 + 701);
			end
			if (((2470 - (430 + 881)) <= (685 + 1103)) and (v165 == (896 - (557 + 338)))) then
				v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (1 + 2));
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 16 - 10, nil, nil, 70 - 50);
				v165 = 4 - 2;
			end
		end
	end
	local function v151()
		local v167 = GetTime() - v100;
		if ((v167 > (53 - 28)) or ((4308 - (499 + 302)) > (5184 - (39 + 827)))) then
			ShouldBothRamp = false;
			v100 = 0 - 0;
		end
		v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (6 - 3));
		ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 23 - 17, nil, nil, 30 - 10);
		if (ShouldReturn or ((264 + 2811) <= (8678 - 5713))) then
			return ShouldReturn;
		end
		if (((219 + 1146) <= (3181 - 1170)) and not v112.Evangelism:IsReady()) then
			local v188 = 104 - (103 + 1);
			while true do
				if ((v188 == (554 - (475 + 79))) or ((6001 - 3225) > (11440 - 7865))) then
					ShouldReturn = v145();
					if (ShouldReturn or ((331 + 2223) == (4228 + 576))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if (((4080 - (1395 + 108)) == (7498 - 4921)) and not v112.Rapture:IsReady() and v12:BuffDown(v112.Rapture)) then
			if ((v167 > (1214 - (7 + 1197))) or ((3 + 3) >= (660 + 1229))) then
				if (((825 - (27 + 292)) <= (5543 - 3651)) and v112.PowerWordRadiance:IsReady()) then
					if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((2560 - 552) > (9301 - 7083))) then
						return "power_word_radiance_instant heal_cooldown";
					end
				elseif (((746 - 367) <= (7897 - 3750)) and v112.Evangelism:IsReady()) then
					if (v23(v112.Evangelism) or ((4653 - (43 + 96)) <= (4115 - 3106))) then
						return "evangelism heal";
					end
				end
			end
			if (v112.Renew:IsReady() or ((7903 - 4407) == (990 + 202))) then
				if (v23(v114.RenewFocus) or ((59 + 149) == (5848 - 2889))) then
					return "renew heal";
				end
			end
		end
		if (((1640 + 2637) >= (2460 - 1147)) and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (2 + 4)))) then
			local v189 = 0 + 0;
			while true do
				if (((4338 - (1414 + 337)) < (5114 - (1642 + 298))) and (v189 == (0 - 0))) then
					if (v112.PowerWordShield:IsReady() or ((11852 - 7732) <= (6522 - 4324))) then
						if (v23(v114.PowerWordShieldFocus) or ((526 + 1070) == (668 + 190))) then
							return "power_word_shield heal";
						end
					end
					if (((4192 - (357 + 615)) == (2261 + 959)) and v112.Rapture:IsReady()) then
						if (v23(v114.RaptureFocus) or ((3439 - 2037) > (3102 + 518))) then
							return "rapture heal";
						end
					end
					break;
				end
			end
		end
	end
	local function v152()
		local v168 = 0 - 0;
		while true do
			if (((2059 + 515) == (175 + 2399)) and (v168 == (4 + 1))) then
				v48 = EpicSettings.Settings['HealthstoneHP'] or (1301 - (384 + 917));
				v49 = EpicSettings.Settings['PowerInfusionUsage'] or "";
				v50 = EpicSettings.Settings['PowerInfusionTarget'] or "";
				v51 = EpicSettings.Settings['PowerInfusionHP'] or (697 - (128 + 569));
				v168 = 1549 - (1407 + 136);
			end
			if (((3685 - (687 + 1200)) < (4467 - (556 + 1154))) and ((10 - 7) == v168)) then
				v40 = EpicSettings.Settings['InterruptWithStun'];
				v41 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v42 = EpicSettings.Settings['InterruptThreshold'];
				v43 = EpicSettings.Settings['UseDesperatePrayer'];
				v168 = 99 - (9 + 86);
			end
			if ((v168 == (421 - (275 + 146))) or ((62 + 315) > (2668 - (29 + 35)))) then
				v28 = EpicSettings.Settings['UseRacials'];
				v29 = EpicSettings.Settings['UseHealingPotion'];
				v30 = EpicSettings.Settings['HealingPotionName'] or "";
				v31 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v168 = 2 - 1;
			end
			if (((2507 - 1939) < (594 + 317)) and (v168 == (1016 - (53 + 959)))) then
				v44 = EpicSettings.Settings['DesperatePrayerHP'] or (408 - (312 + 96));
				v45 = EpicSettings.Settings['UseFade'];
				v46 = EpicSettings.Settings['FadeHP'] or (0 - 0);
				v47 = EpicSettings.Settings['UseHealthstone'];
				v168 = 290 - (147 + 138);
			end
			if (((4184 - (813 + 86)) < (3821 + 407)) and (v168 == (3 - 1))) then
				v36 = EpicSettings.Settings['DispelDebuffs'];
				v37 = EpicSettings.Settings['DispelBuffs'];
				v38 = EpicSettings.Settings['HandleCharredTreant'];
				v39 = EpicSettings.Settings['HandleCharredBrambles'];
				v168 = 495 - (18 + 474);
			end
			if (((1322 + 2594) > (10862 - 7534)) and (v168 == (1087 - (860 + 226)))) then
				v32 = EpicSettings.Settings['UsePowerWordFortitude'];
				v33 = EpicSettings.Settings['UseAngelicFeather'];
				v34 = EpicSettings.Settings['UseBodyAndSoul'];
				v35 = EpicSettings.Settings['MovementDelay'] or (303 - (121 + 182));
				v168 = 1 + 1;
			end
			if (((3740 - (988 + 252)) < (434 + 3405)) and (v168 == (2 + 4))) then
				v52 = EpicSettings.Settings['PowerInfusionGroup'] or (1970 - (49 + 1921));
				v53 = EpicSettings.Settings['PIName1'] or "";
				v54 = EpicSettings.Settings['PIName2'] or "";
				v55 = EpicSettings.Settings['PIName3'] or "";
				break;
			end
		end
	end
	local function v153()
		local v169 = 890 - (223 + 667);
		while true do
			if (((559 - (51 + 1)) == (872 - 365)) and ((10 - 5) == v169)) then
				v81 = EpicSettings.Settings['RaptureHP'] or (1125 - (146 + 979));
				v82 = EpicSettings.Settings['RaptureGroup'] or (0 + 0);
				v83 = EpicSettings.Settings['RenewHP'] or (605 - (311 + 294));
				v84 = EpicSettings.Settings['PowerWordShieldHP'] or (0 - 0);
				v85 = EpicSettings.Settings['PowerWordShieldTankHP'] or (0 + 0);
				v169 = 1449 - (496 + 947);
			end
			if (((1598 - (1233 + 125)) <= (1285 + 1880)) and ((6 + 0) == v169)) then
				v86 = EpicSettings.Settings['AtonementSpreadRefresh'] or (0 + 0);
				v87 = EpicSettings.Settings['AtonementSpreadPartyGroup'] or (1645 - (963 + 682));
				v88 = EpicSettings.Settings['AtonementSpreadRaidGroup'] or (0 + 0);
				v89 = EpicSettings.Settings['UseUltimatePenitence'];
				v90 = EpicSettings.Settings['UltimatePenitenceHP'] or (1504 - (504 + 1000));
				v169 = 5 + 2;
			end
			if (((760 + 74) >= (76 + 729)) and (v169 == (0 - 0))) then
				v60 = EpicSettings.Settings['PenanceHP'] or (0 + 0);
				v61 = EpicSettings.Settings['AtonementHP'] or (0 + 0);
				v62 = EpicSettings.Settings['AtonementGroup'] or (182 - (156 + 26));
				v63 = EpicSettings.Settings['UsePowerWordRadiance'];
				v64 = EpicSettings.Settings['PowerWordRadianceHP'] or (0 + 0);
				v169 = 1 - 0;
			end
			if ((v169 == (167 - (149 + 15))) or ((4772 - (890 + 70)) < (2433 - (39 + 78)))) then
				v57 = EpicSettings.Settings['HaloHP'] or (482 - (14 + 468));
				v58 = EpicSettings.Settings['HaloGroup'] or (0 - 0);
				v59 = EpicSettings.Settings['UseDivineStar'];
				v74 = EpicSettings.Settings['UseEvangelism'];
				v75 = EpicSettings.Settings['EvangelismHP'] or (0 - 0);
				v169 = 3 + 1;
			end
			if ((v169 == (2 + 0)) or ((564 + 2088) <= (693 + 840))) then
				v70 = EpicSettings.Settings['PowerWordLifeHP'] or (0 + 0);
				v71 = EpicSettings.Settings['UseLuminousBarrier'];
				v72 = EpicSettings.Settings['LuminousBarrierHP'] or (0 - 0);
				v73 = EpicSettings.Settings['LuminousBarrierGroup'] or (0 + 0);
				v56 = EpicSettings.Settings['UseHalo'];
				v169 = 10 - 7;
			end
			if (((1 + 6) == v169) or ((3649 - (12 + 39)) < (1359 + 101))) then
				v91 = EpicSettings.Settings['UltimatePenitenceGroup'] or (0 - 0);
				v92 = EpicSettings.Settings['MindbenderHP'] or (0 - 0);
				v93 = EpicSettings.Settings['MindbenderGroup'] or (0 + 0);
				break;
			end
			if ((v169 == (1 + 0)) or ((10437 - 6321) < (794 + 398))) then
				v65 = EpicSettings.Settings['PowerWordRadianceGroup'] or (0 - 0);
				v66 = EpicSettings.Settings['UsePainSuppression'];
				v67 = EpicSettings.Settings['PainSuppressionHP'] or (1710 - (1596 + 114));
				v68 = EpicSettings.Settings['PainSuppressionUsage'] or "";
				v69 = EpicSettings.Settings['UsePowerWordLife'];
				v169 = 4 - 2;
			end
			if (((717 - (164 + 549)) == v169) or ((4815 - (1059 + 379)) <= (1120 - 217))) then
				v76 = EpicSettings.Settings['EvangelismGroup'] or (0 + 0);
				v77 = EpicSettings.Settings['FlashHealHP'] or (0 + 0);
				v78 = EpicSettings.Settings['FlashHealSurgeHP'] or (392 - (145 + 247));
				v79 = EpicSettings.Settings['FlashHealBindingHP'] or (0 + 0);
				v80 = EpicSettings.Settings['UseRapture'];
				v169 = 3 + 2;
			end
		end
	end
	local function v154()
		local v170 = 0 - 0;
		local v171;
		local v172;
		local v173;
		local v174;
		local v175;
		while true do
			if (((763 + 3213) >= (379 + 60)) and ((1 - 0) == v170)) then
				v97 = EpicSettings.Toggles['ramp'];
				v98 = EpicSettings.Toggles['spread'];
				v171 = v98;
				v172 = false;
				v173 = false;
				v170 = 722 - (254 + 466);
			end
			if (((4312 - (544 + 16)) == (11923 - 8171)) and (v170 == (633 - (294 + 334)))) then
				if (((4299 - (236 + 17)) > (1162 + 1533)) and true) then
					v118 = #v117;
					v120 = #v119;
				else
					local v224 = 0 + 0;
					while true do
						if ((v224 == (0 - 0)) or ((16783 - 13238) == (1647 + 1550))) then
							v120 = 1 + 0;
							v118 = 795 - (413 + 381);
							break;
						end
					end
				end
				v131 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.DarkReprimand) or v112.Penance;
				v132 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.DivineStarShadow) or v112.DivineStar;
				v133 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.HaloShadow) or v112.Halo;
				v123 = v12:BuffDown(v112.RadiantProvidenceBuff);
				v170 = 1 + 5;
			end
			if (((5091 - 2697) > (968 - 595)) and (v170 == (1970 - (582 + 1388)))) then
				v152();
				v153();
				v94 = EpicSettings.Toggles['ooc'];
				v95 = EpicSettings.Toggles['cds'];
				v96 = EpicSettings.Toggles['dispel'];
				v170 = 1 - 0;
			end
			if (((2975 + 1180) <= (4596 - (326 + 38))) and (v170 == (5 - 3))) then
				v174 = false;
				v101 = false;
				if (v97 or ((5111 - 1530) == (4093 - (47 + 573)))) then
					local v225 = 0 + 0;
					while true do
						if (((21214 - 16219) > (5433 - 2085)) and ((1665 - (1269 + 395)) == v225)) then
							for v232, v233 in pairs(RampBothTimes) do
								for v244, v245 in pairs(v233) do
									if ((((v112.Rapture:CooldownRemains() + v9.CombatTime()) < v245) and ((v112.Evangelism:CooldownRemains() + v9.CombatTime()) < v245)) or ((1246 - (76 + 416)) > (4167 - (319 + 124)))) then
										if (((495 - 278) >= (1064 - (564 + 443))) and ((v245 - v9.CombatTime()) < (60 - 38)) and ((v245 - v9.CombatTime()) > (458 - (337 + 121)))) then
											v101 = true;
										end
									end
								end
							end
							break;
						end
						if ((v225 == (0 - 0)) or ((6895 - 4825) >= (5948 - (1261 + 650)))) then
							for v234, v235 in pairs(RampRaptureTimes) do
								for v246, v247 in pairs(v235) do
									if (((1145 + 1560) == (4310 - 1605)) and ((v112.Rapture:CooldownRemains() + v9.CombatTime()) < v247)) then
										if (((1878 - (772 + 1045)) == (9 + 52)) and ((v247 - v9.CombatTime()) < (166 - (102 + 42))) and ((v247 - v9.CombatTime()) > (1844 - (1524 + 320)))) then
											v101 = true;
										end
									end
								end
							end
							for v236, v237 in pairs(RampEvangelismTimes) do
								for v248, v249 in pairs(v237) do
									if (((v112.Evangelism:CooldownRemains() + v9.CombatTime()) < v249) or ((1969 - (1049 + 221)) >= (1452 - (18 + 138)))) then
										if ((((v249 - v9.CombatTime()) < (53 - 31)) and ((v249 - v9.CombatTime()) > (1102 - (67 + 1035)))) or ((2131 - (136 + 212)) >= (15365 - 11749))) then
											v101 = true;
										end
									end
								end
							end
							v225 = 1 + 0;
						end
					end
				end
				v175 = v88;
				if ((not v12:IsInRaid() and v12:IsInParty()) or ((3608 + 305) > (6131 - (240 + 1364)))) then
					v175 = v87;
				end
				v170 = 1085 - (1050 + 32);
			end
			if (((15624 - 11248) > (484 + 333)) and ((1058 - (331 + 724)) == v170)) then
				if (((393 + 4468) > (1468 - (269 + 375))) and not v12:IsInRaid() and not v12:IsInParty()) then
					v175 = 726 - (267 + 458);
				end
				if ((v171 and (v134.FriendlyUnitsWithBuffCount(v112.AtonementBuff, false, false) >= v175)) or ((431 + 952) >= (4097 - 1966))) then
					v171 = false;
				end
				if (v97 or ((2694 - (667 + 151)) >= (4038 - (1410 + 87)))) then
					local v226 = 1897 - (1504 + 393);
					while true do
						if (((4816 - 3034) <= (9785 - 6013)) and (v226 == (796 - (461 + 335)))) then
							SetCVar("RampCVar", 0 + 0);
							if ((v112.Rapture:IsReady() and not v172) or ((6461 - (1730 + 31)) < (2480 - (728 + 939)))) then
								for v250, v251 in pairs(RampRaptureTimes) do
									if (((11329 - 8130) < (8215 - 4165)) and v134.IsItTimeToRamp(v250, v251, 11 - 6)) then
										v172 = true;
										SetCVar("RampCVar", 1069 - (138 + 930));
										v100 = v9.CombatTime();
									end
								end
							end
							v226 = 1 + 0;
						end
						if ((v226 == (1 + 0)) or ((4244 + 707) < (18088 - 13658))) then
							if (((1862 - (459 + 1307)) == (1966 - (474 + 1396))) and v112.Evangelism:IsReady() and not v173) then
								for v252, v253 in pairs(RampEvangelismTimes) do
									if (v134.IsItTimeToRamp(v252, v253, 8 - 3) or ((2567 + 172) > (14 + 3994))) then
										v173 = true;
										SetCVar("RampCVar", 5 - 3);
										v100 = v9.CombatTime();
									end
								end
							end
							if ((v112.Evangelism:IsReady() and v112.Rapture:IsReady() and not v174) or ((3 + 20) == (3785 - 2651))) then
								for v254, v255 in pairs(RampBothTimes) do
									if (v134.IsItTimeToRamp(v254, v255, 21 - 16) or ((3284 - (562 + 29)) >= (3505 + 606))) then
										v174 = true;
										SetCVar("RampCVar", 1422 - (374 + 1045));
										v100 = v9.CombatTime();
									end
								end
							end
							break;
						end
					end
				end
				if (v12:IsDeadOrGhost() or ((3416 + 900) <= (6663 - 4517))) then
					return;
				end
				if (v12:IsMounted() or ((4184 - (448 + 190)) <= (907 + 1902))) then
					return;
				end
				v170 = 2 + 2;
			end
			if (((3196 + 1708) > (8327 - 6161)) and (v170 == (12 - 8))) then
				if (((1603 - (1307 + 187)) >= (356 - 266)) and not v12:IsMoving()) then
					v99 = GetTime();
				end
				if (((11655 - 6677) > (8907 - 6002)) and not v171) then
					if (v12:AffectingCombat() or v94 or v36 or ((3709 - (232 + 451)) <= (2178 + 102))) then
						local v230 = 0 + 0;
						local v231;
						while true do
							if ((v230 == (565 - (510 + 54))) or ((3330 - 1677) <= (1144 - (13 + 23)))) then
								if (((5670 - 2761) > (3748 - 1139)) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
							if (((1375 - 618) > (1282 - (830 + 258))) and (v230 == (0 - 0))) then
								v231 = v36 and v112.Purify:IsReady();
								ShouldReturn = v134.FocusUnit(v231, nil, nil, nil, 13 + 7);
								v230 = 1 + 0;
							end
						end
					end
				end
				Enemies40y = v12:GetEnemiesInRange(1481 - (860 + 581));
				v117 = v12:GetEnemiesInMeleeRange(44 - 32);
				v119 = v12:GetEnemiesInMeleeRange(20 + 4);
				v170 = 246 - (237 + 4);
			end
			if ((v170 == (13 - 7)) or ((78 - 47) >= (2650 - 1252))) then
				v124 = v12:BuffDown(v112.SurgeofLight);
				if (((2616 + 580) <= (2799 + 2073)) and v38) then
					local v227 = 0 - 0;
					while true do
						if (((1428 + 1898) == (1810 + 1516)) and (v227 == (1427 - (85 + 1341)))) then
							ShouldReturn = v134.HandleCharredTreant(v112.FlashHeal, v114.FlashHealMouseover, 68 - 28, true);
							if (((4046 - 2613) <= (4250 - (45 + 327))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v227 == (0 - 0)) or ((2085 - (444 + 58)) == (754 + 981))) then
							ShouldReturn = v134.HandleCharredTreant(v112.Renew, v114.RenewMouseover, 7 + 33);
							if (ShouldReturn or ((1458 + 1523) == (6810 - 4460))) then
								return ShouldReturn;
							end
							v227 = 1733 - (64 + 1668);
						end
					end
				end
				if (v39 or ((6439 - (1227 + 746)) <= (1515 - 1022))) then
					ShouldReturn = v134.HandleCharredBrambles(v112.Renew, v114.RenewMouseover, 74 - 34);
					if (ShouldReturn or ((3041 - (415 + 79)) <= (52 + 1935))) then
						return ShouldReturn;
					end
					ShouldReturn = v134.HandleCharredBrambles(v112.FlashHeal, v114.FlashHealMouseover, 531 - (142 + 349), true);
					if (((1269 + 1692) > (3767 - 1027)) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				if (((1837 + 1859) >= (2545 + 1067)) and not v12:IsChanneling()) then
					if (v12:AffectingCombat() or ((8088 - 5118) == (3742 - (1710 + 154)))) then
						if (v171 or ((4011 - (200 + 118)) < (784 + 1193))) then
							local v238 = 0 - 0;
							while true do
								if ((v238 == (0 - 0)) or ((827 + 103) > (2079 + 22))) then
									ShouldReturn = v148();
									if (((2229 + 1924) > (493 + 2593)) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						if (v172 or ((10082 - 5428) <= (5300 - (363 + 887)))) then
							ShouldReturn = v149();
							if (ShouldReturn or ((4542 - 1940) < (7120 - 5624))) then
								return ShouldReturn;
							end
						end
						if (v173 or ((158 + 862) > (5353 - 3065))) then
							local v239 = 0 + 0;
							while true do
								if (((1992 - (674 + 990)) == (95 + 233)) and (v239 == (0 + 0))) then
									ShouldReturn = v150();
									if (((2394 - 883) < (4863 - (507 + 548))) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						if (v174 or ((3347 - (289 + 548)) > (6737 - (821 + 997)))) then
							local v240 = 255 - (195 + 60);
							while true do
								if (((1281 + 3482) == (6264 - (251 + 1250))) and (v240 == (0 - 0))) then
									ShouldReturn = v151();
									if (((2843 + 1294) > (2880 - (809 + 223))) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						ShouldReturn = v146();
						if (((3554 - 1118) <= (9411 - 6277)) and ShouldReturn) then
							return ShouldReturn;
						end
					elseif (((12309 - 8586) == (2742 + 981)) and v94) then
						local v241 = 0 + 0;
						while true do
							if ((v241 == (619 - (14 + 603))) or ((4175 - (118 + 11)) >= (699 + 3617))) then
								if (ShouldReturn or ((1673 + 335) < (5621 - 3692))) then
									return ShouldReturn;
								end
								break;
							end
							if (((3333 - (551 + 398)) > (1122 + 653)) and (v241 == (0 + 0))) then
								if (v171 or ((3693 + 850) <= (16274 - 11898))) then
									local v256 = 0 - 0;
									while true do
										if (((236 + 492) == (2890 - 2162)) and (v256 == (0 + 0))) then
											ShouldReturn = v148();
											if (ShouldReturn or ((1165 - (40 + 49)) > (17787 - 13116))) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								ShouldReturn = v147();
								v241 = 491 - (99 + 391);
							end
							if (((1532 + 319) >= (1661 - 1283)) and (v241 == (2 - 1))) then
								if (ShouldReturn or ((1898 + 50) >= (9146 - 5670))) then
									return ShouldReturn;
								end
								ShouldReturn = v145();
								v241 = 1606 - (1032 + 572);
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v155()
		local v176 = 417 - (203 + 214);
		while true do
			if (((6611 - (568 + 1249)) >= (652 + 181)) and (v176 == (0 - 0))) then
				v135();
				v20.Print("Discipline Priest by Epic BoomK");
				v176 = 3 - 2;
			end
			if (((5396 - (913 + 393)) == (11549 - 7459)) and (v176 == (1 - 0))) then
				EpicSettings.SetupVersion("Discipline Priest X v 10.2.01 By BoomK");
				break;
			end
		end
	end
	v20.SetAPL(666 - (269 + 141), v154, v155);
end;
return v0["Epix_Priest_Discipline.lua"]();

