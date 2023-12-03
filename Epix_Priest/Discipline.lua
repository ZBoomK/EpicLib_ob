local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((155 + 3981) > (8705 - 6308)) and not v5) then
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
	local v99 = 0 + 0;
	local v100 = 0 + 0;
	local v101 = false;
	RampRaptureTimes = {};
	RampRaptureTimes[7961 - 5278] = {(128 - 58),(95 + 75),(227 + 43)};
	RampEvangelismTimes = {};
	RampEvangelismTimes[2626 + 57] = {(389 - 254),(89 + 136),(361 + 36)};
	RampBothTimes = {};
	RampBothTimes[1942 + 738] = {(10 + 5),(104 + 41),(1299 - (572 + 477))};
	RampBothTimes[362 + 2320] = {(2 + 13),(197 - 77),(1037 - (497 + 345)),(49 + 236)};
	RampBothTimes[4017 - (605 + 728)] = {(33 - 18),(683 - 498),(969 - 619)};
	RampBothTimes[2029 + 658] = {(3 + 2),(109 + 6),(725 - 520),(1091 - (588 + 208))};
	RampBothTimes[7244 - 4556] = {(94 - 49),(793 - (232 + 421)),(57 + 173)};
	RampBothTimes[511 + 2178] = {(710 - (316 + 289)),(10 + 195),(730 - (360 + 65))};
	RampBothTimes[2517 + 176] = {(23 - 8),(382 - 257),(1084 - (503 + 396)),(474 - 229)};
	RampBothTimes[1377 + 1308] = {(305 - 227),(399 - 224),(129 + 140),(45 + 313)};
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
		if (v112.ImprovedPurify:IsAvailable() or ((6608 - 2274) == (5489 - (485 + 759)))) then
			v134.DispellableDebuffs = v19.MergeTable(v134.DispellableMagicDebuffs, v134.DispellableDiseaseDebuffs);
		else
			v134.DispellableDebuffs = v134.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v135();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v136(v156)
		return v156:DebuffRefreshable(v112.ShadowWordPain) and (v156:TimeToDie() >= (27 - 15));
	end
	local function v137()
		return false;
	end
	local function v138()
		if ((v112.Purify:IsReady() and v96 and v134.DispellableFriendlyUnit()) or ((5465 - (442 + 747)) <= (4166 - (832 + 303)))) then
			if (v23(v114.PurifyFocus) or ((5728 - (88 + 858)) <= (366 + 833))) then
				return "purify dispel";
			end
		end
	end
	local function v139()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (1 + 0)) or ((5653 - (766 + 23)) < (9389 - 7487))) then
				if (((6617 - 1778) >= (9748 - 6048)) and v113.Healthstone:IsReady() and v47 and (v12:HealthPercentage() <= v48)) then
					if (v23(v114.Healthstone, nil, nil, true) or ((3648 - 2573) > (2991 - (1036 + 37)))) then
						return "healthstone defensive 3";
					end
				end
				if (((281 + 115) <= (7407 - 3603)) and v29 and (v12:HealthPercentage() <= v31)) then
					if ((v30 == "Refreshing Healing Potion") or ((3280 + 889) == (3667 - (641 + 839)))) then
						if (((2319 - (910 + 3)) == (3584 - 2178)) and v113.RefreshingHealingPotion:IsReady()) then
							if (((3215 - (1466 + 218)) < (1963 + 2308)) and v23(v114.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((1783 - (556 + 592)) == (226 + 409)) and (v157 == (808 - (329 + 479)))) then
				if (((4227 - (174 + 680)) <= (12218 - 8662)) and v112.Fade:IsReady() and v45 and (v12:HealthPercentage() <= v46)) then
					if (v23(v112.Fade, nil, nil, true) or ((6821 - 3530) < (2342 + 938))) then
						return "fade defensive";
					end
				end
				if (((5125 - (396 + 343)) >= (78 + 795)) and v112.DesperatePrayer:IsReady() and v43 and (v12:HealthPercentage() <= v44)) then
					if (((2398 - (29 + 1448)) <= (2491 - (135 + 1254))) and v23(v112.DesperatePrayer)) then
						return "desperate_prayer defensive";
					end
				end
				v157 = 3 - 2;
			end
		end
	end
	local function v140()
		local v158 = 0 - 0;
		while true do
			if (((3137 + 1569) >= (2490 - (389 + 1138))) and (v158 == (575 - (102 + 472)))) then
				ShouldReturn = v134.HandleBottomTrinket(v115, v95, 38 + 2, nil);
				if (ShouldReturn or ((533 + 427) <= (817 + 59))) then
					return ShouldReturn;
				end
				break;
			end
			if ((v158 == (1545 - (320 + 1225))) or ((3677 - 1611) == (571 + 361))) then
				ShouldReturn = v134.HandleTopTrinket(v115, v95, 1504 - (157 + 1307), nil);
				if (((6684 - (821 + 1038)) < (12083 - 7240)) and ShouldReturn) then
					return ShouldReturn;
				end
				v158 = 1 + 0;
			end
		end
	end
	local function v141()
		if (((GetTime() - v99) > v35) or ((6886 - 3009) >= (1689 + 2848))) then
			local v202 = 0 - 0;
			while true do
				if ((v202 == (1026 - (834 + 192))) or ((275 + 4040) < (444 + 1282))) then
					if ((v112.BodyandSoul:IsAvailable() and v112.PowerWordShield:IsReady() and v34 and v12:BuffDown(v112.AngelicFeatherBuff) and v12:BuffDown(v112.BodyandSoulBuff)) or ((79 + 3600) < (968 - 343))) then
						if (v23(v114.PowerWordShieldPlayer) or ((4929 - (300 + 4)) < (169 + 463))) then
							return "power_word_shield_player move";
						end
					end
					if ((v112.AngelicFeather:IsReady() and v33 and v12:BuffDown(v112.AngelicFeatherBuff) and v12:BuffDown(v112.BodyandSoulBuff) and v12:BuffDown(v112.AngelicFeatherBuff)) or ((217 - 134) > (2142 - (112 + 250)))) then
						if (((218 + 328) <= (2697 - 1620)) and v23(v114.AngelicFeatherPlayer)) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v142(v159)
		if (v131:IsReady() or ((571 + 425) > (2225 + 2076))) then
			if (((3044 + 1026) > (341 + 346)) and v14 and (v14:HealthPercentage() <= v60)) then
				if (v12:BuffUp(v112.ShadowCovenantBuff) or ((488 + 168) >= (4744 - (1001 + 413)))) then
					if (v23(v114.DarkReprimandFocus) or ((5556 - 3064) <= (1217 - (244 + 638)))) then
						return "dark_reprimand_focus penance";
					end
				elseif (((5015 - (627 + 66)) >= (7633 - 5071)) and v23(v114.PenanceFocus)) then
					return "penance_focus penance";
				end
			end
			if ((not v159 and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) <= v62)) or ((4239 - (512 + 90)) >= (5676 - (1665 + 241)))) then
				if (v23(v131, not v13:IsSpellInRange(v131)) or ((3096 - (373 + 344)) > (2065 + 2513))) then
					return "penance penance";
				end
			end
		end
	end
	local function v143()
		if ((v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v12:BuffUp(v112.RadiantProvidenceBuff)) or ((128 + 355) > (1959 - 1216))) then
			if (((4152 - 1698) > (1677 - (35 + 1064))) and v23(v114.PowerWordRadianceFocus, nil, v123)) then
				return "power_word_radiance_instant heal_cooldown";
			end
		end
		if (((677 + 253) < (9537 - 5079)) and (v68 == "Anyone")) then
			if (((3 + 659) <= (2208 - (298 + 938))) and v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67)) then
				if (((5629 - (233 + 1026)) == (6036 - (636 + 1030))) and v23(v114.PainSuppressionFocus, nil, nil, true)) then
					return "pain_suppression heal_cooldown";
				end
			end
		elseif ((v68 == "Tank Only") or ((2435 + 2327) <= (841 + 20))) then
			if ((v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67) and (Commons.UnitGroupRole(v14) == "TANK")) or ((420 + 992) == (289 + 3975))) then
				if (v23(v114.PainSuppressionFocus, nil, nil, true) or ((3389 - (55 + 166)) < (418 + 1735))) then
					return "pain_suppression heal_cooldown";
				end
			end
		elseif ((v68 == "Tank and Self") or ((501 + 4475) < (5086 - 3754))) then
			if (((4925 - (36 + 261)) == (8093 - 3465)) and v112.PainSuppression:IsReady() and v14:BuffDown(v112.PainSuppression) and v66 and (v14:HealthPercentage() <= v67) and ((Commons.UnitGroupRole(v14) == "TANK") or (Commons.UnitGroupRole(v14) == "HEALER"))) then
				if (v23(v114.PainSuppressionFocus, nil, nil, true) or ((1422 - (34 + 1334)) == (152 + 243))) then
					return "pain_suppression heal_cooldown";
				end
			end
		end
		if (((64 + 18) == (1365 - (1035 + 248))) and v112.PowerWordLife:IsReady() and v69 and (v14:HealthPercentage() <= v70) and v14:Exists()) then
			if (v23(v114.PowerWordLifeFocus) or ((602 - (20 + 1)) < (147 + 135))) then
				return "power_word_life heal_cooldown";
			end
		end
		if ((v112.LuminousBarrier:IsReady() and v71 and v134.AreUnitsBelowHealthPercentage(v72, v73)) or ((4928 - (134 + 185)) < (3628 - (549 + 584)))) then
			if (((1837 - (314 + 371)) == (3954 - 2802)) and v23(v112.LuminousBarrier)) then
				return "luminous_barrier heal_cooldown";
			end
		end
	end
	local function v144()
		local v160 = 968 - (478 + 490);
		while true do
			if (((1005 + 891) <= (4594 - (786 + 386))) and ((9 - 6) == v160)) then
				if ((v112.PowerWordShield:IsReady() and (v134.UnitGroupRole(v14) == "TANK") and (v14:HealthPercentage() < v85) and (v14:BuffDown(v112.AtonementBuff) or v14:BuffDown(v112.PowerWordShield)) and v14:Exists()) or ((2369 - (1055 + 324)) > (2960 - (1093 + 247)))) then
					if (v23(v114.PowerWordShieldFocus) or ((780 + 97) > (494 + 4201))) then
						return "power_word_shield_tank heal";
					end
				end
				if (((10683 - 7992) >= (6281 - 4430)) and v112.FlashHeal:IsReady() and v112.BindingHeals:IsAvailable() and (v14:GUID() ~= v12:GUID()) and v14:BuffDown(v112.AtonementBuff) and v12:BuffDown(v112.AtonementBuff) and (v14:HealthPercentage() < v79) and v14:Exists()) then
					if (v23(v114.FlashHealFocus, nil, v124) or ((8493 - 5508) >= (12202 - 7346))) then
						return "flash_heal heal";
					end
				end
				if (((1522 + 2754) >= (4603 - 3408)) and v112.PowerWordShield:IsReady() and (v14:HealthPercentage() < v84) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) then
					if (((11139 - 7907) <= (3537 + 1153)) and v23(v114.PowerWordShieldFocus)) then
						return "power_word_shield heal";
					end
				end
				v160 = 9 - 5;
			end
			if ((v160 == (692 - (364 + 324))) or ((2455 - 1559) >= (7548 - 4402))) then
				if (((1015 + 2046) >= (12377 - 9419)) and v112.Renew:IsReady() and (v14:HealthPercentage() < v83) and v14:BuffDown(v112.AtonementBuff) and v14:BuffDown(v112.Renew) and v14:Exists()) then
					if (((5103 - 1916) >= (1955 - 1311)) and v23(v114.RenewFocus)) then
						return "renew heal";
					end
				end
				if (((1912 - (1249 + 19)) <= (636 + 68)) and v131:IsReady() and v94 and (not v12:AffectingCombat() or not v134.TargetIsValid()) and (v14:HealthPercentage() < v60) and v14:Exists()) then
					ShouldReturn = v142(true);
					if (((3728 - 2770) > (2033 - (686 + 400))) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				if (((3525 + 967) >= (2883 - (73 + 156))) and v112.FlashHeal:IsReady() and v94 and (not v12:AffectingCombat() or not v134.TargetIsValid()) and (v14:HealthPercentage() < v77) and v14:Exists()) then
					if (((17 + 3425) >= (2314 - (721 + 90))) and v23(v114.FlashHealFocus, nil, true)) then
						return "flash_heal_ooc heal";
					end
				end
				break;
			end
			if ((v160 == (1 + 1)) or ((10292 - 7122) <= (1934 - (224 + 246)))) then
				if ((v112.Evangelism:IsReady() and v95 and v74 and v12:AffectingCombat() and (v134.FriendlyUnitsBelowHealthPercentageCount(v75) > v76) and not v12:IsInRaid() and v12:IsInParty() and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) <= v62)) or ((7770 - 2973) == (8078 - 3690))) then
					if (((100 + 451) <= (17 + 664)) and v23(v112.Evangelism)) then
						return "evangelism heal";
					end
				end
				if (((2407 + 870) > (808 - 401)) and v112.FlashHeal:IsReady() and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffDown(v112.PowerWordShield) and v14:BuffDown(v112.Renew))) and (v14:HealthPercentage() < v78) and v12:BuffUp(v112.SurgeofLight) and v14:Exists()) then
					if (((15624 - 10929) >= (1928 - (203 + 310))) and v23(v114.FlashHealFocus, nil, v124)) then
						return "flash_heal_instant heal";
					end
				end
				if ((v112.Rapture:IsReady() and not v12:IsInRaid() and v12:IsInParty() and v80 and v95 and v12:AffectingCombat() and (v14:HealthPercentage() < v81) and (v134.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) >= v82) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) or ((5205 - (1238 + 755)) <= (66 + 878))) then
					if (v23(v114.RaptureFocus) or ((4630 - (709 + 825)) <= (3312 - 1514))) then
						return "rapture heal";
					end
				end
				v160 = 3 - 0;
			end
			if (((4401 - (196 + 668)) == (13964 - 10427)) and (v160 == (0 - 0))) then
				if (((4670 - (171 + 662)) >= (1663 - (4 + 89))) and v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v12:BuffUp(v112.RadiantProvidenceBuff) and v14:Exists()) then
					if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((10339 - 7389) == (1389 + 2423))) then
						return "power_word_radiance_instant heal_cooldown";
					end
				end
				if (((20744 - 16021) >= (910 + 1408)) and v112.PowerWordLife:IsReady() and v69 and (v14:HealthPercentage() <= v70) and v14:Exists()) then
					if (v23(v114.PowerWordLifeFocus) or ((3513 - (35 + 1451)) > (4305 - (28 + 1425)))) then
						return "power_word_life heal_cooldown";
					end
				end
				if ((v112.PowerWordRadiance:IsReady() and v63 and v134.AreUnitsBelowHealthPercentage(v64, v65) and v14:BuffDown(v112.AtonementBuff) and v14:Exists()) or ((3129 - (941 + 1052)) > (4140 + 177))) then
					if (((6262 - (822 + 692)) == (6778 - 2030)) and v23(v114.PowerWordRadianceFocus, nil, v123)) then
						return "power_word_radiance 2 heal";
					end
				end
				v160 = 1 + 0;
			end
			if (((4033 - (45 + 252)) <= (4690 + 50)) and (v160 == (1 + 0))) then
				if ((v133:IsReady() and v134.TargetIsValid() and v13:IsInRange(73 - 43) and v56 and v134.AreUnitsBelowHealthPercentage(v57, v58)) or ((3823 - (114 + 319)) <= (4393 - 1333))) then
					if (v23(v114.HaloPlayer, not v14:IsInRange(38 - 8), true) or ((637 + 362) > (4012 - 1319))) then
						return "halo heal";
					end
				end
				if (((969 - 506) < (2564 - (556 + 1407))) and v132:IsReady() and v134.TargetIsValid() and v13:IsInRange(1236 - (741 + 465)) and v59 and not v14:IsFacingBlacklisted()) then
					if (v23(v114.DivineStarPlayer) or ((2648 - (170 + 295)) < (362 + 325))) then
						return "divine_star heal";
					end
				end
				if (((4179 + 370) == (11199 - 6650)) and v112.UltimatePenitence:IsReady() and v95 and v12:AffectingCombat() and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v90, false, false) >= v91)) then
					if (((3873 + 799) == (2997 + 1675)) and v23(v112.UltimatePenitence)) then
						return "ultimate_penitence heal";
					end
				end
				v160 = 2 + 0;
			end
		end
	end
	local function v145()
		ShouldReturn = v134.InterruptWithStun(v112.PsychicScream, 1238 - (957 + 273));
		if (ShouldReturn or ((982 + 2686) < (159 + 236))) then
			return ShouldReturn;
		end
		if ((v112.DispelMagic:IsReady() and v96 and v37 and not v12:IsCasting() and not v12:IsChanneling() and v134.UnitHasMagicBuff(v13)) or ((15874 - 11708) == (1199 - 744))) then
			if (v23(v112.DispelMagic, not v13:IsSpellInRange(v112.DispelMagic)) or ((13589 - 9140) == (13186 - 10523))) then
				return "dispel_magic damage";
			end
		end
		if ((v112.ArcaneTorrent:IsReady() and v28 and v95 and (v12:ManaPercentage() <= (1865 - (389 + 1391)))) or ((2684 + 1593) < (312 + 2677))) then
			if (v23(v112.ArcaneTorrent) or ((1980 - 1110) >= (5100 - (783 + 168)))) then
				return "arcane_torrent damage";
			end
		end
		if (((7423 - 5211) < (3131 + 52)) and v112.Shadowfiend:IsReady() and v95 and (v12:ManaPercentage() < (401 - (309 + 2))) and not v112.Mindbender:IsAvailable() and not v12:BuffUp(v112.ShadowCovenantBuff) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) then
			if (((14267 - 9621) > (4204 - (1090 + 122))) and v23(v112.Shadowfiend)) then
				return "shadowfiend damage";
			end
		end
		if (((465 + 969) < (10431 - 7325)) and v112.Mindbender:IsReady() and v95 and not v12:BuffUp(v112.ShadowCovenantBuff) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) then
			if (((538 + 248) < (4141 - (628 + 490))) and v23(v112.Mindbender)) then
				return "mindbender damage";
			end
		end
		if (v112.MindBlast:IsReady() or ((438 + 2004) < (182 - 108))) then
			if (((20724 - 16189) == (5309 - (431 + 343))) and v23(v112.MindBlast, not v13:IsSpellInRange(v112.MindBlast), true)) then
				return "mind_blast 10 long_scov";
			end
		end
		if ((v112.ShadowWordDeath:IsReady() and ((v13:HealthPercentage() < (40 - 20)) or v12:BuffUp(v112.ShadowCovenantBuff))) or ((8704 - 5695) <= (1663 + 442))) then
			if (((235 + 1595) < (5364 - (556 + 1139))) and v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath))) then
				return "shadow_word_death 1 long_scov";
			end
		end
		if ((v95 and v12:BuffUp(v112.PowerInfusionBuff)) or ((1445 - (6 + 9)) >= (662 + 2950))) then
			ShouldReturn = v140();
			if (((1375 + 1308) >= (2629 - (28 + 141))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if ((v112.PurgeTheWicked:IsReady() and (v13:TimeToDie() > ((0.3 + 0) * v112.PurgeTheWicked:BaseDuration())) and v13:DebuffRefreshable(v112.PurgeTheWickedDebuff)) or ((2225 - 421) >= (2320 + 955))) then
			if (v23(v112.PurgeTheWicked, not v13:IsSpellInRange(v112.PurgeTheWicked)) or ((2734 - (486 + 831)) > (9443 - 5814))) then
				return "purge_the_wicked damage";
			end
		end
		if (((16881 - 12086) > (76 + 326)) and v112.ShadowWordPain:IsReady() and not v112.PurgeTheWicked:IsAvailable() and (v13:TimeToDie() > ((0.3 - 0) * v112.ShadowWordPain:BaseDuration())) and v13:DebuffRefreshable(v112.ShadowWordPain)) then
			if (((6076 - (668 + 595)) > (3208 + 357)) and v23(v112.ShadowWordPain, not v13:IsSpellInRange(v112.ShadowWordPain))) then
				return "shadow_word_pain damage";
			end
		end
		if (((789 + 3123) == (10668 - 6756)) and v112.ShadowWordDeath:IsReady() and (v13:HealthPercentage() < (310 - (23 + 267)))) then
			if (((4765 - (1129 + 815)) <= (5211 - (371 + 16))) and v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath))) then
				return "shadow_word_death 1 damage";
			end
		end
		if (((3488 - (1326 + 424)) <= (4156 - 1961)) and v131:IsReady() and (v134.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(v112.AtonementBuff, v61, false, false) < v62)) then
			if (((149 - 108) <= (3136 - (88 + 30))) and v23(v131, not v13:IsSpellInRange(v131))) then
				return "penance damage";
			end
		end
		if (((2916 - (720 + 51)) <= (9129 - 5025)) and ((v112.Mindbender:CooldownRemains() > v131:Cooldown()) or (v112.Shadowfiend:CooldownRemains() > v131:Cooldown())) and (v134.FriendlyUnitsWithBuffBelowHealthPercentageCount(v112.AtonementBuff, v92, false, false) >= v93)) then
			local v203 = 1776 - (421 + 1355);
			while true do
				if (((4435 - 1746) < (2380 + 2465)) and (v203 == (1083 - (286 + 797)))) then
					ShouldReturn = v142();
					if (ShouldReturn or ((8488 - 6166) > (4342 - 1720))) then
						return "penance damage";
					end
					break;
				end
			end
		end
		if ((v112.MindBlast:IsReady() and ((v112.Mindbender:CooldownRemains() > v112.MindBlast:Cooldown()) or (v112.Shadowfiend:CooldownRemains() > v112.MindBlast:Cooldown()))) or ((4973 - (397 + 42)) == (651 + 1431))) then
			if (v23(v112.MindBlast, not v13:IsSpellInRange(v112.MindBlast), true) or ((2371 - (24 + 776)) > (2875 - 1008))) then
				return "mind_blast damage";
			end
		end
		if ((v112.Mindgames:IsReady() and ((v112.Mindbender:CooldownRemains() > v112.Mindgames:Cooldown()) or (v112.ShadowFiend:CooldownRemains() > v112.Mindgames:Cooldown())) and v112.ShatteredPerceptions:IsAvailable()) or ((3439 - (222 + 563)) >= (6600 - 3604))) then
			if (((2865 + 1113) > (2294 - (23 + 167))) and v23(v112.Mindgames, not v13:IsSpellInRange(v112.Mindgames), true)) then
				return "mindgames 1 damage";
			end
		end
		if (((4793 - (690 + 1108)) > (556 + 985)) and v133:IsReady() and v134.TargetIsValid() and v13:IsInRange(25 + 5)) then
			if (((4097 - (40 + 808)) > (157 + 796)) and v23(v114.HaloPlayer, not v13:IsInRange(114 - 84), true)) then
				return "halo damage";
			end
		end
		if ((v132:IsReady() and v134.TargetIsValid() and v13:IsInRange(29 + 1) and not v13:IsFacingBlacklisted()) or ((1732 + 1541) > (2508 + 2065))) then
			if (v23(v114.DivineStarPlayer, not v13:IsInRange(601 - (47 + 524))) or ((2045 + 1106) < (3509 - 2225))) then
				return "divine_star damage";
			end
		end
		if ((v112.ShadowWordDeath:IsReady() and (v13:TimeToX(29 - 9) > ((0.5 - 0) * v112.ShadowWordDeath:Cooldown()))) or ((3576 - (1165 + 561)) == (46 + 1483))) then
			if (((2542 - 1721) < (811 + 1312)) and v23(v112.ShadowWordDeath, not v13:IsSpellInRange(v112.ShadowWordDeath))) then
				return "shadow_word_death 3 damage";
			end
		end
		if (((1381 - (341 + 138)) < (628 + 1697)) and v112.HolyNova:IsReady() and (v12:BuffStack(v112.RhapsodyBuff) == (41 - 21))) then
			if (((1184 - (89 + 237)) <= (9528 - 6566)) and v23(v112.HolyNova)) then
				return "holy_nova 1 damage";
			end
		end
		if (v112.Smite:IsReady() or ((8307 - 4361) < (2169 - (581 + 300)))) then
			if (v23(v112.Smite, not v13:IsSpellInRange(v112.Smite), true) or ((4462 - (855 + 365)) == (1346 - 779))) then
				return "smite damage";
			end
		end
		if (v12:IsMoving() or ((277 + 570) >= (2498 - (1030 + 205)))) then
			local v204 = 0 + 0;
			while true do
				if ((v204 == (0 + 0)) or ((2539 - (156 + 130)) == (4205 - 2354))) then
					ShouldReturn = v141();
					if (ShouldReturn or ((3516 - 1429) > (4857 - 2485))) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if ((v112.PurgeTheWicked:IsReady() and v13:DebuffRefreshable(v112.PurgeTheWickedDebuff)) or ((1172 + 3273) < (2420 + 1729))) then
			if (v23(v112.PurgeTheWicked, not v13:IsSpellInRange(v112.PurgeTheWicked)) or ((1887 - (10 + 59)) == (25 + 60))) then
				return "purge_the_wicked_movement damage";
			end
		end
		if (((3102 - 2472) < (3290 - (671 + 492))) and v112.ShadowWordPain:IsReady()) then
			if (v23(v112.ShadowWordPain, not v13:IsSpellInRange(v112.ShadowWordPain)) or ((1543 + 395) == (3729 - (369 + 846)))) then
				return "shadow_word_pain_movement damage";
			end
		end
	end
	local function v146()
		local v161 = 0 + 0;
		while true do
			if (((3632 + 623) >= (2000 - (1036 + 909))) and (v161 == (1 + 0))) then
				if (((5034 - 2035) > (1359 - (11 + 192))) and v14) then
					local v213 = 0 + 0;
					while true do
						if (((2525 - (135 + 40)) > (2798 - 1643)) and (v213 == (0 + 0))) then
							if (((8875 - 4846) <= (7274 - 2421)) and v36) then
								local v241 = 176 - (50 + 126);
								while true do
									if ((v241 == (0 - 0)) or ((115 + 401) > (4847 - (1233 + 180)))) then
										ShouldReturn = v138();
										if (((5015 - (522 + 447)) >= (4454 - (107 + 1314))) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							if (v95 or ((1262 + 1457) <= (4408 - 2961))) then
								local v242 = 0 + 0;
								while true do
									if ((v242 == (0 - 0)) or ((16356 - 12222) < (5836 - (716 + 1194)))) then
										ShouldReturn = v143();
										if (ShouldReturn or ((3 + 161) >= (299 + 2486))) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							v213 = 504 - (74 + 429);
						end
						if (((1 - 0) == v213) or ((261 + 264) == (4827 - 2718))) then
							ShouldReturn = v144();
							if (((24 + 9) == (101 - 68)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((7550 - 4496) <= (4448 - (279 + 154))) and v134.TargetIsValid()) then
					local v214 = 778 - (454 + 324);
					while true do
						if (((1473 + 398) < (3399 - (12 + 5))) and (v214 == (0 + 0))) then
							ShouldReturn = v145();
							if (((3294 - 2001) <= (801 + 1365)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				elseif (v12:IsMoving() or ((3672 - (277 + 816)) < (525 - 402))) then
					local v227 = 1183 - (1058 + 125);
					while true do
						if ((v227 == (0 + 0)) or ((1821 - (815 + 160)) >= (10160 - 7792))) then
							ShouldReturn = v141();
							if (ShouldReturn or ((9523 - 5511) <= (802 + 2556))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4367 - 2873) <= (4903 - (41 + 1857))) and (v161 == (1893 - (1222 + 671)))) then
				ShouldReturn = v139();
				if (ShouldReturn or ((8040 - 4929) == (3067 - 933))) then
					return ShouldReturn;
				end
				v161 = 1183 - (229 + 953);
			end
		end
	end
	local function v147()
		if (((4129 - (1111 + 663)) == (3934 - (874 + 705))) and v112.PowerWordFortitude:IsReady() and v32 and (v12:BuffDown(v112.PowerWordFortitudeBuff, true) or v134.GroupBuffMissing(v112.PowerWordFortitudeBuff))) then
			if (v23(v114.PowerWordFortitudePlayer) or ((83 + 505) <= (295 + 137))) then
				return "power_word_fortitude";
			end
		end
		if (((9970 - 5173) >= (110 + 3785)) and v14) then
			local v205 = 679 - (642 + 37);
			while true do
				if (((816 + 2761) == (573 + 3004)) and (v205 == (0 - 0))) then
					if (((4248 - (233 + 221)) > (8539 - 4846)) and v36) then
						local v228 = 0 + 0;
						while true do
							if ((v228 == (1541 - (718 + 823))) or ((803 + 472) == (4905 - (266 + 539)))) then
								ShouldReturn = v138();
								if (ShouldReturn or ((4504 - 2913) >= (4805 - (636 + 589)))) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
					if (((2333 - 1350) <= (3728 - 1920)) and v94) then
						ShouldReturn = v144();
						if (ShouldReturn or ((1704 + 446) <= (435 + 762))) then
							return ShouldReturn;
						end
					end
					break;
				end
			end
		end
		if (((4784 - (657 + 358)) >= (3105 - 1932)) and v12:IsMoving()) then
			ShouldReturn = v141();
			if (((3383 - 1898) == (2672 - (1151 + 36))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if ((v13 and v13:Exists() and v13:IsAPlayer() and v13:IsDeadOrGhost() and not v12:CanAttack(v13)) or ((3202 + 113) <= (732 + 2050))) then
			local v206 = 0 - 0;
			local v207;
			while true do
				if ((v206 == (1832 - (1552 + 280))) or ((1710 - (64 + 770)) >= (2013 + 951))) then
					v207 = v134.DeadFriendlyUnitsCount();
					if ((v207 > (2 - 1)) or ((397 + 1835) > (3740 - (157 + 1086)))) then
						if (v23(v112.MassResurrection, nil, true) or ((4223 - 2113) <= (1453 - 1121))) then
							return "mass_resurrection";
						end
					elseif (((5653 - 1967) > (4328 - 1156)) and v23(v112.Resurrection, nil, true)) then
						return "resurrection";
					end
					break;
				end
			end
		end
		if ((v112.PowerWordFortitude:IsReady() and (v12:BuffDown(v112.PowerWordFortitudeBuff, true) or v134.GroupBuffMissing(v112.PowerWordFortitudeBuff))) or ((5293 - (599 + 220)) < (1632 - 812))) then
			if (((6210 - (1813 + 118)) >= (2107 + 775)) and v23(v114.PowerWordFortitudePlayer)) then
				return "power_word_fortitude";
			end
		end
	end
	local function v148()
		local v162 = 1217 - (841 + 376);
		while true do
			if ((v162 == (1 - 0)) or ((472 + 1557) >= (9610 - 6089))) then
				if (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < v86) or ((2896 - (464 + 395)) >= (11913 - 7271))) then
					if (((827 + 893) < (5295 - (467 + 370))) and v12:BuffUp(v112.Rapture)) then
						if (v112.PowerWordShield:IsReady() or ((900 - 464) > (2218 + 803))) then
							if (((2444 - 1731) <= (133 + 714)) and v23(v114.PowerWordShieldFocus)) then
								return "power_word_shield heal";
							end
						end
					elseif (((5010 - 2856) <= (4551 - (150 + 370))) and v112.Renew:IsReady()) then
						if (((5897 - (74 + 1208)) == (11351 - 6736)) and v23(v114.RenewFocus)) then
							return "renew heal";
						end
					end
				end
				break;
			end
			if ((v162 == (0 - 0)) or ((2697 + 1093) == (890 - (14 + 376)))) then
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, v86, nil, nil, 34 - 14);
				if (((58 + 31) < (195 + 26)) and ShouldReturn) then
					return ShouldReturn;
				end
				v162 = 1 + 0;
			end
		end
	end
	local function v149()
		local v163 = 0 - 0;
		local v164;
		while true do
			if (((1546 + 508) >= (1499 - (23 + 55))) and (v163 == (2 - 1))) then
				v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (3 + 0));
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 6 + 0, nil, nil, 31 - 11);
				v163 = 1 + 1;
			end
			if (((1593 - (652 + 249)) < (8183 - 5125)) and (v163 == (1871 - (708 + 1160)))) then
				if (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (16 - 10)) or ((5932 - 2678) == (1682 - (10 + 17)))) then
					local v215 = 0 + 0;
					while true do
						if (((1732 - (1400 + 332)) == v215) or ((2485 - 1189) == (6818 - (242 + 1666)))) then
							if (((1442 + 1926) == (1235 + 2133)) and v112.PowerWordShield:IsReady()) then
								if (((2253 + 390) < (4755 - (850 + 90))) and v23(v114.PowerWordShieldFocus)) then
									return "power_word_shield heal";
								end
							end
							if (((3349 - 1436) > (1883 - (360 + 1030))) and v112.Rapture:IsReady()) then
								if (((4209 + 546) > (9675 - 6247)) and v23(v114.RaptureFocus)) then
									return "rapture heal";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1899 - 518) <= (4030 - (909 + 752))) and (v163 == (1223 - (109 + 1114)))) then
				v164 = GetTime() - v100;
				if ((v164 > (36 - 16)) or ((1886 + 2957) == (4326 - (6 + 236)))) then
					ShouldRaptureRamp = false;
					v100 = 0 + 0;
				end
				v163 = 1 + 0;
			end
			if (((11010 - 6341) > (633 - 270)) and (v163 == (1135 - (1076 + 57)))) then
				if (ShouldReturn or ((309 + 1568) >= (3827 - (579 + 110)))) then
					return ShouldReturn;
				end
				if (((375 + 4367) >= (3206 + 420)) and not v112.Rapture:IsReady() and v12:BuffDown(v112.Rapture)) then
					if (v112.PowerWordRadiance:IsReady() or ((2410 + 2130) == (1323 - (174 + 233)))) then
						if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((3228 - 2072) > (7626 - 3281))) then
							return "power_word_radiance_instant heal_cooldown";
						end
					end
				end
				v163 = 2 + 1;
			end
		end
	end
	local function v150()
		local v165 = 1174 - (663 + 511);
		local v166;
		while true do
			if (((1996 + 241) < (923 + 3326)) and (v165 == (0 - 0))) then
				v166 = GetTime() - v100;
				if ((v166 > (13 + 7)) or ((6316 - 3633) < (55 - 32))) then
					local v216 = 0 + 0;
					while true do
						if (((1356 - 659) <= (589 + 237)) and (v216 == (0 + 0))) then
							ShouldEvangelismRamp = false;
							v100 = 722 - (478 + 244);
							break;
						end
					end
				end
				v165 = 518 - (440 + 77);
			end
			if (((503 + 602) <= (4303 - 3127)) and (v165 == (1557 - (655 + 901)))) then
				v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (1 + 2));
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 5 + 1, nil, nil, 14 + 6);
				v165 = 7 - 5;
			end
			if (((4824 - (695 + 750)) <= (13016 - 9204)) and ((2 - 0) == v165)) then
				if (ShouldReturn or ((3168 - 2380) >= (1967 - (285 + 66)))) then
					return ShouldReturn;
				end
				if (((4321 - 2467) <= (4689 - (682 + 628))) and not v112.Evangelism:IsReady()) then
					local v217 = 0 + 0;
					while true do
						if (((4848 - (176 + 123)) == (1903 + 2646)) and (v217 == (0 + 0))) then
							ShouldReturn = v145();
							if (ShouldReturn or ((3291 - (239 + 30)) >= (823 + 2201))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v165 = 3 + 0;
			end
			if (((8531 - 3711) > (6857 - 4659)) and (v165 == (318 - (306 + 9)))) then
				if (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (20 - 14)) or ((185 + 876) >= (3001 + 1890))) then
					if (((657 + 707) <= (12790 - 8317)) and v112.PowerWordShield:IsReady()) then
						if (v23(v114.PowerWordShieldFocus) or ((4970 - (1140 + 235)) <= (2 + 1))) then
							return "power_word_shield heal";
						end
					end
					if ((v166 > (7 + 0)) or ((1200 + 3472) == (3904 - (33 + 19)))) then
						if (((563 + 996) == (4672 - 3113)) and v112.PowerWordRadiance:IsReady()) then
							if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((772 + 980) <= (1545 - 757))) then
								return "power_word_radiance_instant heal_cooldown";
							end
						elseif (v112.Evangelism:IsReady() or ((3664 + 243) == (866 - (586 + 103)))) then
							if (((316 + 3154) > (1708 - 1153)) and v23(v112.Evangelism)) then
								return "evangelism heal";
							end
						end
					end
					if (v112.Renew:IsReady() or ((2460 - (1309 + 179)) == (1164 - 519))) then
						if (((1385 + 1797) >= (5679 - 3564)) and v23(v114.RenewFocus)) then
							return "renew heal";
						end
					end
				end
				break;
			end
		end
	end
	local function v151()
		local v167 = 0 + 0;
		local v168;
		while true do
			if (((8270 - 4377) < (8824 - 4395)) and (v167 == (609 - (295 + 314)))) then
				v168 = GetTime() - v100;
				if ((v168 > (61 - 36)) or ((4829 - (1300 + 662)) < (5981 - 4076))) then
					ShouldBothRamp = false;
					v100 = 1755 - (1178 + 577);
				end
				v167 = 1 + 0;
			end
			if ((v167 == (5 - 3)) or ((3201 - (851 + 554)) >= (3583 + 468))) then
				if (((4489 - 2870) <= (8157 - 4401)) and ShouldReturn) then
					return ShouldReturn;
				end
				if (((906 - (115 + 187)) == (463 + 141)) and not v112.Evangelism:IsReady()) then
					local v218 = 0 + 0;
					while true do
						if (((0 - 0) == v218) or ((5645 - (160 + 1001)) == (788 + 112))) then
							ShouldReturn = v145();
							if (ShouldReturn or ((3077 + 1382) <= (2278 - 1165))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v167 = 361 - (237 + 121);
			end
			if (((4529 - (525 + 372)) > (6441 - 3043)) and ((9 - 6) == v167)) then
				if (((4224 - (96 + 46)) <= (5694 - (643 + 134))) and not v112.Rapture:IsReady() and v12:BuffDown(v112.Rapture)) then
					if (((1745 + 3087) >= (3323 - 1937)) and (v168 > (37 - 27))) then
						if (((132 + 5) == (268 - 131)) and v112.PowerWordRadiance:IsReady()) then
							if (v23(v114.PowerWordRadianceFocus, nil, v123) or ((3209 - 1639) >= (5051 - (316 + 403)))) then
								return "power_word_radiance_instant heal_cooldown";
							end
						elseif (v112.Evangelism:IsReady() or ((2702 + 1362) <= (5001 - 3182))) then
							if (v23(v112.Evangelism) or ((1802 + 3184) < (3963 - 2389))) then
								return "evangelism heal";
							end
						end
					end
					if (((3137 + 1289) > (56 + 116)) and v112.Renew:IsReady()) then
						if (((2030 - 1444) > (2173 - 1718)) and v23(v114.RenewFocus)) then
							return "renew heal";
						end
					end
				end
				if (((1715 - 889) == (48 + 778)) and (v14:BuffDown(v112.AtonementBuff) or (v14:BuffRemains(v112.AtonementBuff) < (11 - 5)))) then
					if (v112.PowerWordShield:IsReady() or ((197 + 3822) > (13065 - 8624))) then
						if (((2034 - (12 + 5)) < (16549 - 12288)) and v23(v114.PowerWordShieldFocus)) then
							return "power_word_shield heal";
						end
					end
					if (((10061 - 5345) > (170 - 90)) and v112.Rapture:IsReady()) then
						if (v23(v114.RaptureFocus) or ((8696 - 5189) == (665 + 2607))) then
							return "rapture heal";
						end
					end
				end
				break;
			end
			if (((1974 - (1656 + 317)) == v167) or ((781 + 95) >= (2465 + 610))) then
				v125 = not v112.HarshDiscipline:IsAvailable() or (v12:BuffStack(v112.HarshDisciplineBuff) == (7 - 4));
				ShouldReturn = v134.FocusUnitRefreshableBuff(v112.AtonementBuff, 29 - 23, nil, nil, 374 - (5 + 349));
				v167 = 9 - 7;
			end
		end
	end
	local function v152()
		v28 = EpicSettings.Settings['UseRacials'];
		v29 = EpicSettings.Settings['UseHealingPotion'];
		v30 = EpicSettings.Settings['HealingPotionName'] or "";
		v31 = EpicSettings.Settings['HealingPotionHP'] or (1271 - (266 + 1005));
		v32 = EpicSettings.Settings['UsePowerWordFortitude'];
		v33 = EpicSettings.Settings['UseAngelicFeather'];
		v34 = EpicSettings.Settings['UseBodyAndSoul'];
		v35 = EpicSettings.Settings['MovementDelay'] or (0 + 0);
		v36 = EpicSettings.Settings['DispelDebuffs'];
		v37 = EpicSettings.Settings['DispelBuffs'];
		v38 = EpicSettings.Settings['HandleAfflicted'];
		v39 = EpicSettings.Settings['HandleIncorporeal'];
		v40 = EpicSettings.Settings['InterruptWithStun'];
		v41 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v42 = EpicSettings.Settings['InterruptThreshold'];
		v43 = EpicSettings.Settings['UseDesperatePrayer'];
		v44 = EpicSettings.Settings['DesperatePrayerHP'] or (0 - 0);
		v45 = EpicSettings.Settings['UseFade'];
		v46 = EpicSettings.Settings['FadeHP'] or (0 - 0);
		v47 = EpicSettings.Settings['UseHealthstone'];
		v48 = EpicSettings.Settings['HealthstoneHP'] or (1696 - (561 + 1135));
		v49 = EpicSettings.Settings['PowerInfusionUsage'] or "";
		v50 = EpicSettings.Settings['PowerInfusionTarget'] or "";
		v51 = EpicSettings.Settings['PowerInfusionHP'] or (0 - 0);
		v52 = EpicSettings.Settings['PowerInfusionGroup'] or (0 - 0);
		v53 = EpicSettings.Settings['PIName1'] or "";
		v54 = EpicSettings.Settings['PIName2'] or "";
		v55 = EpicSettings.Settings['PIName3'] or "";
	end
	local function v153()
		v60 = EpicSettings.Settings['PenanceHP'] or (1066 - (507 + 559));
		v61 = EpicSettings.Settings['AtonementHP'] or (0 - 0);
		v62 = EpicSettings.Settings['AtonementGroup'] or (0 - 0);
		v63 = EpicSettings.Settings['UsePowerWordRadiance'];
		v64 = EpicSettings.Settings['PowerWordRadianceHP'] or (388 - (212 + 176));
		v65 = EpicSettings.Settings['PowerWordRadianceGroup'] or (905 - (250 + 655));
		v66 = EpicSettings.Settings['UsePainSuppression'];
		v67 = EpicSettings.Settings['PainSuppressionHP'] or (0 - 0);
		v68 = EpicSettings.Settings['PainSuppressionUsage'] or "";
		v69 = EpicSettings.Settings['UsePowerWordLife'];
		v70 = EpicSettings.Settings['PowerWordLifeHP'] or (0 - 0);
		v71 = EpicSettings.Settings['UseLuminousBarrier'];
		v72 = EpicSettings.Settings['LuminousBarrierHP'] or (0 - 0);
		v73 = EpicSettings.Settings['LuminousBarrierGroup'] or (1956 - (1869 + 87));
		v56 = EpicSettings.Settings['UseHalo'];
		v57 = EpicSettings.Settings['HaloHP'] or (0 - 0);
		v58 = EpicSettings.Settings['HaloGroup'] or (1901 - (484 + 1417));
		v59 = EpicSettings.Settings['UseDivineStar'];
		v74 = EpicSettings.Settings['UseEvangelism'];
		v75 = EpicSettings.Settings['EvangelismHP'] or (0 - 0);
		v76 = EpicSettings.Settings['EvangelismGroup'] or (0 - 0);
		v77 = EpicSettings.Settings['FlashHealHP'] or (773 - (48 + 725));
		v78 = EpicSettings.Settings['FlashHealSurgeHP'] or (0 - 0);
		v79 = EpicSettings.Settings['FlashHealBindingHP'] or (0 - 0);
		v80 = EpicSettings.Settings['UseRapture'];
		v81 = EpicSettings.Settings['RaptureHP'] or (0 + 0);
		v82 = EpicSettings.Settings['RaptureGroup'] or (0 - 0);
		v83 = EpicSettings.Settings['RenewHP'] or (0 + 0);
		v84 = EpicSettings.Settings['PowerWordShieldHP'] or (0 + 0);
		v85 = EpicSettings.Settings['PowerWordShieldTankHP'] or (853 - (152 + 701));
		v86 = EpicSettings.Settings['AtonementSpreadRefresh'] or (1311 - (430 + 881));
		v87 = EpicSettings.Settings['AtonementSpreadPartyGroup'] or (0 + 0);
		v88 = EpicSettings.Settings['AtonementSpreadRaidGroup'] or (895 - (557 + 338));
		v89 = EpicSettings.Settings['UseUltimatePenitence'];
		v90 = EpicSettings.Settings['UltimatePenitenceHP'] or (0 + 0);
		v91 = EpicSettings.Settings['UltimatePenitenceGroup'] or (0 - 0);
		v92 = EpicSettings.Settings['MindbenderHP'] or (0 - 0);
		v93 = EpicSettings.Settings['MindbenderGroup'] or (0 - 0);
	end
	local function v154()
		local v193 = 0 - 0;
		local v194;
		local v195;
		local v196;
		local v197;
		local v198;
		while true do
			if (((5153 - (499 + 302)) > (3420 - (39 + 827))) and (v193 == (10 - 6))) then
				v119 = v12:GetEnemiesInMeleeRange(53 - 29);
				if (true or ((17499 - 13093) < (6206 - 2163))) then
					local v219 = 0 + 0;
					while true do
						if (((0 - 0) == v219) or ((303 + 1586) >= (5353 - 1970))) then
							v118 = #v117;
							v120 = #v119;
							break;
						end
					end
				else
					v120 = 105 - (103 + 1);
					v118 = 555 - (475 + 79);
				end
				v131 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.DarkReprimand) or v112.Penance;
				v132 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.DivineStarShadow) or v112.DivineStar;
				v133 = ((v12:BuffUp(v112.ShadowCovenantBuff)) and v112.HaloShadow) or v112.Halo;
				v123 = v12:BuffDown(v112.RadiantProvidenceBuff);
				v193 = 10 - 5;
			end
			if (((6054 - 4162) <= (354 + 2380)) and (v193 == (2 + 0))) then
				if (((3426 - (1395 + 108)) < (6454 - 4236)) and v97) then
					for v221, v222 in pairs(RampRaptureTimes) do
						for v229, v230 in pairs(v222) do
							if (((3377 - (7 + 1197)) > (166 + 213)) and ((v112.Rapture:CooldownRemains() + v9.CombatTime()) < v230)) then
								if ((((v230 - v9.CombatTime()) < (8 + 14)) and ((v230 - v9.CombatTime()) > (319 - (27 + 292)))) or ((7592 - 5001) == (4346 - 937))) then
									v101 = true;
								end
							end
						end
					end
					for v223, v224 in pairs(RampEvangelismTimes) do
						for v231, v232 in pairs(v224) do
							if (((18930 - 14416) > (6555 - 3231)) and ((v112.Evangelism:CooldownRemains() + v9.CombatTime()) < v232)) then
								if ((((v232 - v9.CombatTime()) < (41 - 19)) and ((v232 - v9.CombatTime()) > (139 - (43 + 96)))) or ((848 - 640) >= (10915 - 6087))) then
									v101 = true;
								end
							end
						end
					end
					for v225, v226 in pairs(RampBothTimes) do
						for v233, v234 in pairs(v226) do
							if ((((v112.Rapture:CooldownRemains() + v9.CombatTime()) < v234) and ((v112.Evangelism:CooldownRemains() + v9.CombatTime()) < v234)) or ((1314 + 269) > (1008 + 2559))) then
								if ((((v234 - v9.CombatTime()) < (42 - 20)) and ((v234 - v9.CombatTime()) > (0 + 0))) or ((2460 - 1147) == (250 + 544))) then
									v101 = true;
								end
							end
						end
					end
				end
				v198 = v88;
				if (((233 + 2941) > (4653 - (1414 + 337))) and not v12:IsInRaid() and v12:IsInParty()) then
					v198 = v87;
				end
				if (((6060 - (1642 + 298)) <= (11105 - 6845)) and not v12:IsInRaid() and not v12:IsInParty()) then
					v198 = 2 - 1;
				end
				if ((v194 and (v134.FriendlyUnitsWithBuffCount(v112.AtonementBuff, false, false) >= v198)) or ((2620 - 1737) > (1573 + 3205))) then
					v194 = false;
				end
				if (v97 or ((2817 + 803) >= (5863 - (357 + 615)))) then
					local v220 = 0 + 0;
					while true do
						if (((10447 - 6189) > (803 + 134)) and (v220 == (0 - 0))) then
							SetCVar("RampCVar", 0 + 0);
							if ((v112.Rapture:IsReady() and not v195) or ((331 + 4538) < (570 + 336))) then
								for v243, v244 in pairs(RampRaptureTimes) do
									if (v134.IsItTimeToRamp(v243, v244, 1306 - (384 + 917)) or ((1922 - (128 + 569)) > (5771 - (1407 + 136)))) then
										local v250 = 1887 - (687 + 1200);
										while true do
											if (((5038 - (556 + 1154)) > (7873 - 5635)) and (v250 == (95 - (9 + 86)))) then
												v195 = true;
												SetCVar("RampCVar", 422 - (275 + 146));
												v250 = 1 + 0;
											end
											if (((3903 - (29 + 35)) > (6226 - 4821)) and (v250 == (2 - 1))) then
												v100 = v9.CombatTime();
												break;
											end
										end
									end
								end
							end
							v220 = 4 - 3;
						end
						if ((v220 == (1 + 0)) or ((2305 - (53 + 959)) <= (915 - (312 + 96)))) then
							if ((v112.Evangelism:IsReady() and not v196) or ((5026 - 2130) < (1090 - (147 + 138)))) then
								for v245, v246 in pairs(RampEvangelismTimes) do
									if (((3215 - (813 + 86)) == (2093 + 223)) and v134.IsItTimeToRamp(v245, v246, 8 - 3)) then
										v196 = true;
										SetCVar("RampCVar", 494 - (18 + 474));
										v100 = v9.CombatTime();
									end
								end
							end
							if ((v112.Evangelism:IsReady() and v112.Rapture:IsReady() and not v197) or ((868 + 1702) == (5003 - 3470))) then
								for v247, v248 in pairs(RampBothTimes) do
									if (v134.IsItTimeToRamp(v247, v248, 1091 - (860 + 226)) or ((1186 - (121 + 182)) == (180 + 1280))) then
										v197 = true;
										SetCVar("RampCVar", 1243 - (988 + 252));
										v100 = v9.CombatTime();
									end
								end
							end
							break;
						end
					end
				end
				v193 = 1 + 2;
			end
			if ((v193 == (1 + 2)) or ((6589 - (49 + 1921)) <= (1889 - (223 + 667)))) then
				if (v12:IsDeadOrGhost() or ((3462 - (51 + 1)) > (7084 - 2968))) then
					return;
				end
				if (v12:IsMounted() or ((1933 - 1030) >= (4184 - (146 + 979)))) then
					return;
				end
				if (not v12:IsMoving() or ((1123 + 2853) < (3462 - (311 + 294)))) then
					v99 = GetTime();
				end
				if (((13748 - 8818) > (978 + 1329)) and not v194) then
					if (v12:AffectingCombat() or v94 or v36 or ((5489 - (496 + 947)) < (2649 - (1233 + 125)))) then
						local v235 = 0 + 0;
						local v236;
						while true do
							if ((v235 == (1 + 0)) or ((806 + 3435) == (5190 - (963 + 682)))) then
								if (ShouldReturn or ((3379 + 669) > (5736 - (504 + 1000)))) then
									return ShouldReturn;
								end
								break;
							end
							if ((v235 == (0 + 0)) or ((1594 + 156) >= (328 + 3145))) then
								v236 = v36 and v112.Purify:IsReady();
								ShouldReturn = v134.FocusUnit(v236, nil, nil, nil, 29 - 9);
								v235 = 1 + 0;
							end
						end
					end
				end
				Enemies40y = v12:GetEnemiesInRange(24 + 16);
				v117 = v12:GetEnemiesInMeleeRange(194 - (156 + 26));
				v193 = 3 + 1;
			end
			if (((4952 - 1786) == (3330 - (149 + 15))) and (v193 == (960 - (890 + 70)))) then
				v152();
				v153();
				v94 = EpicSettings.Toggles['ooc'];
				v95 = EpicSettings.Toggles['cds'];
				v96 = EpicSettings.Toggles['dispel'];
				v97 = EpicSettings.Toggles['ramp'];
				v193 = 118 - (39 + 78);
			end
			if (((2245 - (14 + 468)) < (8188 - 4464)) and (v193 == (13 - 8))) then
				v124 = v12:BuffDown(v112.SurgeofLight);
				if (((30 + 27) <= (1636 + 1087)) and not v12:IsChanneling()) then
					if (v12:AffectingCombat() or ((440 + 1630) == (201 + 242))) then
						if (v194 or ((709 + 1996) == (2665 - 1272))) then
							local v237 = 0 + 0;
							while true do
								if (((0 - 0) == v237) or ((117 + 4484) < (112 - (12 + 39)))) then
									ShouldReturn = v148();
									if (ShouldReturn or ((1294 + 96) >= (14684 - 9940))) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						if (v195 or ((7133 - 5130) > (1137 + 2697))) then
							local v238 = 0 + 0;
							while true do
								if ((v238 == (0 - 0)) or ((104 + 52) > (18910 - 14997))) then
									ShouldReturn = v149();
									if (((1905 - (1596 + 114)) == (508 - 313)) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						if (((3818 - (164 + 549)) >= (3234 - (1059 + 379))) and v196) then
							local v239 = 0 - 0;
							while true do
								if (((2270 + 2109) >= (360 + 1771)) and (v239 == (392 - (145 + 247)))) then
									ShouldReturn = v150();
									if (((3155 + 689) >= (945 + 1098)) and ShouldReturn) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						if (v197 or ((9581 - 6349) <= (524 + 2207))) then
							local v240 = 0 + 0;
							while true do
								if (((7964 - 3059) == (5625 - (254 + 466))) and (v240 == (560 - (544 + 16)))) then
									ShouldReturn = v151();
									if (ShouldReturn or ((13144 - 9008) >= (5039 - (294 + 334)))) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						ShouldReturn = v146();
						if (ShouldReturn or ((3211 - (236 + 17)) == (1732 + 2285))) then
							return ShouldReturn;
						end
					elseif (((956 + 272) >= (3061 - 2248)) and v94) then
						if (v194 or ((16357 - 12902) > (2086 + 1964))) then
							local v249 = 0 + 0;
							while true do
								if (((1037 - (413 + 381)) == (11 + 232)) and (v249 == (0 - 0))) then
									ShouldReturn = v148();
									if (ShouldReturn or ((703 - 432) > (3542 - (582 + 1388)))) then
										return ShouldReturn;
									end
									break;
								end
							end
						end
						ShouldReturn = v147();
						if (((4666 - 1927) < (2358 + 935)) and ShouldReturn) then
							return ShouldReturn;
						end
						ShouldReturn = v145();
						if (ShouldReturn or ((4306 - (326 + 38)) < (3354 - 2220))) then
							return ShouldReturn;
						end
					end
				end
				break;
			end
			if (((1 - 0) == v193) or ((3313 - (47 + 573)) == (1753 + 3220))) then
				v98 = EpicSettings.Toggles['spread'];
				v194 = v98;
				v195 = false;
				v196 = false;
				v197 = false;
				v101 = false;
				v193 = 8 - 6;
			end
		end
	end
	local function v155()
		v135();
		v20.Print("Discipline Priest by Epic BoomK");
		EpicSettings.SetupVersion("Discipline Priest X v 10.2.00 By BoomK");
	end
	v20.SetAPL(415 - 159, v154, v155);
end;
return v0["Epix_Priest_Discipline.lua"]();

