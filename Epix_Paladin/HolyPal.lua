local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1822 - (221 + 925)) >= (2687 - (1019 + 26)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_HolyPal.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Utils;
	local v12 = v9.Unit;
	local v13 = v12.Focus;
	local v14 = v12.Player;
	local v15 = v12.MouseOver;
	local v16 = v12.Target;
	local v17 = v12.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Press;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = math.floor;
	local v27 = string.format;
	local v28 = GetTotemInfo;
	local v29 = GetTime;
	local v30 = v18.Paladin.Holy;
	local v31 = v19.Paladin.Holy;
	local v32 = v22.Paladin.Holy;
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
	local v67;
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
	local v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111;
	local v112;
	local v113;
	local v114;
	local v115;
	local v116;
	local v117 = false;
	local v118 = false;
	local v119 = false;
	local v120 = false;
	local v121 = false;
	local v122 = false;
	local v123 = {};
	local v124;
	local v125;
	local v126 = v20.Commons.Everyone;
	local function v127(v148)
		return v148:DebuffRefreshable(v30.JudgmentDebuff);
	end
	local function v128()
		for v191 = 1 + 0, 3 + 1 do
			local v192 = 0 - 0;
			local v193;
			local v194;
			local v195;
			local v196;
			while true do
				if (((4561 - (360 + 65)) > (2241 + 156)) and (v192 == (254 - (79 + 175)))) then
					v193, v194, v195, v196 = v28(v191);
					if ((v194 == v30.Consecration:Name()) or ((6833 - 2499) == (3313 + 932))) then
						return (v26(((v195 + v196) - v29()) + (0.5 - 0))) or (0 - 0);
					end
					break;
				end
			end
		end
		return 899 - (503 + 396);
	end
	local function v129(v149)
		return v149:DebuffRefreshable(v30.GlimmerofLightBuff) or not v60;
	end
	local function v130()
		if ((v30.BlessingofSummer:IsCastable() and v14:IsInParty() and not v14:IsInRaid()) or ((4457 - (92 + 89)) <= (5879 - 2848))) then
			if ((v13 and v13:Exists() and (v126.UnitGroupRole(v13) == "DAMAGER")) or ((2453 + 2329) <= (710 + 489))) then
				if (v23(v32.BlessingofSummerFocus) or ((19047 - 14183) < (261 + 1641))) then
					return "blessing_of_summer";
				end
			end
		end
		local v150 = {v30.BlessingofSpring,v30.BlessingofSummer,v30.BlessingofAutumn,v30.BlessingofWinter};
		for v197, v198 in pairs(v150) do
			if (((604 + 4235) >= (5642 - 1942)) and v198:IsCastable()) then
				if (v23(v32.BlessingofSummerPlayer) or ((2319 - (485 + 759)) > (4437 - 2519))) then
					return "blessing_of_the_seasons";
				end
			end
		end
	end
	local function v131()
		local v151 = 1189 - (442 + 747);
		while true do
			if (((1531 - (832 + 303)) <= (4750 - (88 + 858))) and (v151 == (1 + 0))) then
				ShouldReturn = v126.HandleBottomTrinket(v123, v118, 34 + 6, nil);
				if (ShouldReturn or ((172 + 3997) == (2976 - (766 + 23)))) then
					return ShouldReturn;
				end
				break;
			end
			if (((6941 - 5535) == (1922 - 516)) and (v151 == (0 - 0))) then
				ShouldReturn = v126.HandleTopTrinket(v123, v118, 135 - 95, nil);
				if (((2604 - (1036 + 37)) < (3029 + 1242)) and ShouldReturn) then
					return ShouldReturn;
				end
				v151 = 1 - 0;
			end
		end
	end
	local function v132()
		if (((500 + 135) == (2115 - (641 + 839))) and not v14:IsCasting() and not v14:IsChanneling()) then
			local v199 = 913 - (910 + 3);
			local v200;
			while true do
				if (((8598 - 5225) <= (5240 - (1466 + 218))) and (v199 == (1 + 0))) then
					v200 = v126.InterruptWithStun(v30.HammerofJustice, 1156 - (556 + 592));
					if (v200 or ((1171 + 2120) < (4088 - (329 + 479)))) then
						return v200;
					end
					break;
				end
				if (((5240 - (174 + 680)) >= (2999 - 2126)) and (v199 == (0 - 0))) then
					v200 = v126.Interrupt(v30.Rebuke, 4 + 1, true);
					if (((1660 - (396 + 343)) <= (98 + 1004)) and v200) then
						return v200;
					end
					v199 = 1478 - (29 + 1448);
				end
			end
		end
	end
	local function v133()
		if (((6095 - (135 + 1254)) >= (3627 - 2664)) and (not v13 or not v13:Exists() or not v13:IsInRange(186 - 146) or not v126.DispellableFriendlyUnit())) then
			return;
		end
		if (v30.Cleanse:IsReady() or ((640 + 320) <= (2403 - (389 + 1138)))) then
			if (v23(v32.CleanseFocus) or ((2640 - (102 + 472)) == (880 + 52))) then
				return "cleanse dispel";
			end
		end
	end
	local function v134()
		local v152 = 0 + 0;
		while true do
			if (((4499 + 326) < (6388 - (320 + 1225))) and (v152 == (0 - 0))) then
				if ((v30.Consecration:IsCastable() and v16:IsInMeleeRange(4 + 1)) or ((5341 - (157 + 1307)) >= (6396 - (821 + 1038)))) then
					if (v23(v30.Consecration) or ((10765 - 6450) < (189 + 1537))) then
						return "consecrate precombat 4";
					end
				end
				if (v30.Judgment:IsReady() or ((6534 - 2855) < (233 + 392))) then
					if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((11463 - 6838) < (1658 - (834 + 192)))) then
						return "judgment precombat 6";
					end
				end
				break;
			end
		end
	end
	local function v135()
		if (((v14:HealthPercentage() <= v62) and v61 and v30.LayonHands:IsCastable()) or ((6 + 77) > (457 + 1323))) then
			if (((12 + 534) <= (1667 - 590)) and v23(v32.LayonHandsPlayer)) then
				return "lay_on_hands defensive";
			end
		end
		if ((v30.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v66) and v65) or ((1300 - (300 + 4)) > (1149 + 3152))) then
			if (((10654 - 6584) > (1049 - (112 + 250))) and v23(v30.DivineProtection)) then
				return "divine protection";
			end
		end
		if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (2 + 1)) and (v14:HealthPercentage() <= v84) and v67 and not v14:HealingAbsorbed()) or ((1643 - 987) >= (1908 + 1422))) then
			if (v23(v32.WordofGloryPlayer) or ((1289 + 1203) <= (251 + 84))) then
				return "WOG self";
			end
		end
		if (((2143 + 2179) >= (1904 + 658)) and v31.Healthstone:IsReady() and v53 and (v14:HealthPercentage() <= v54)) then
			if (v23(v32.Healthstone, nil, nil, true) or ((5051 - (1001 + 413)) >= (8407 - 4637))) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v14:HealthPercentage() <= v36)) or ((3261 - (244 + 638)) > (5271 - (627 + 66)))) then
			if ((v35 == "Refreshing Healing Potion") or ((1438 - 955) > (1345 - (512 + 90)))) then
				if (((4360 - (1665 + 241)) > (1295 - (373 + 344))) and v31.RefreshingHealingPotion:IsReady()) then
					if (((420 + 510) < (1180 + 3278)) and v23(v32.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v136()
		local v153 = 0 - 0;
		local v154;
		while true do
			if (((1119 - 457) <= (2071 - (35 + 1064))) and (v153 == (2 + 0))) then
				if (((9349 - 4979) == (18 + 4352)) and v30.HolyAvenger:IsCastable()) then
					if (v23(v30.HolyAvenger) or ((5998 - (298 + 938)) <= (2120 - (233 + 1026)))) then
						return "holy_avenger cooldowns 16";
					end
				end
				v154 = v126.HandleTopTrinket(v123, v118, 1706 - (636 + 1030), nil);
				if (v154 or ((722 + 690) == (4165 + 99))) then
					return v154;
				end
				v153 = 1 + 2;
			end
			if (((1 + 2) == v153) or ((3389 - (55 + 166)) < (418 + 1735))) then
				v154 = v126.HandleBottomTrinket(v123, v118, 5 + 35, nil);
				if (v154 or ((19003 - 14027) < (1629 - (36 + 261)))) then
					return v154;
				end
				if (((8093 - 3465) == (5996 - (34 + 1334))) and v30.Seraphim:IsReady()) then
					if (v23(v30.Seraphim) or ((21 + 33) == (307 + 88))) then
						return "seraphim cooldowns 18";
					end
				end
				break;
			end
			if (((1365 - (1035 + 248)) == (103 - (20 + 1))) and (v153 == (1 + 0))) then
				if ((v56 and v118 and v30.DivineToll:IsCastable() and v14:BuffUp(v30.AvengingWrathBuff)) or ((900 - (134 + 185)) < (1415 - (549 + 584)))) then
					if (v23(v30.DivineToll) or ((5294 - (314 + 371)) < (8565 - 6070))) then
						return "divine_toll cooldowns 8";
					end
				end
				if (((2120 - (478 + 490)) == (611 + 541)) and v30.BloodFury:IsCastable()) then
					if (((3068 - (786 + 386)) <= (11083 - 7661)) and v23(v30.BloodFury)) then
						return "blood_fury cooldowns 12";
					end
				end
				if (v30.Berserking:IsCastable() or ((2369 - (1055 + 324)) > (2960 - (1093 + 247)))) then
					if (v23(v30.Berserking) or ((780 + 97) > (494 + 4201))) then
						return "berserking cooldowns 14";
					end
				end
				v153 = 7 - 5;
			end
			if (((9132 - 6441) >= (5266 - 3415)) and (v153 == (0 - 0))) then
				if ((v55 and v118 and v30.AvengingWrath:IsReady() and not v14:BuffUp(v30.AvengingWrathBuff)) or ((1062 + 1923) >= (18707 - 13851))) then
					if (((14738 - 10462) >= (902 + 293)) and v23(v30.AvengingWrath)) then
						return "avenging_wrath cooldowns 4";
					end
				end
				v154 = v130();
				if (((8265 - 5033) <= (5378 - (364 + 324))) and v154) then
					return v154;
				end
				v153 = 2 - 1;
			end
		end
	end
	local function v137()
		local v155 = 0 - 0;
		while true do
			if ((v155 == (1 + 0)) or ((3748 - 2852) >= (5038 - 1892))) then
				if (((9296 - 6235) >= (4226 - (1249 + 19))) and (LightsHammerLightsHammerUsage == "Player")) then
					if (((2877 + 310) >= (2506 - 1862)) and v30.LightsHammer:IsCastable() and (v125 >= (1088 - (686 + 400)))) then
						if (((506 + 138) <= (933 - (73 + 156))) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(1 + 7))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((1769 - (721 + 90)) > (11 + 936)) and (LightsHammerLightsHammerUsage == "Cursor")) then
					if (((14584 - 10092) >= (3124 - (224 + 246))) and v30.LightsHammer:IsCastable()) then
						if (((5575 - 2133) >= (2766 - 1263)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammerLightsHammerUsage == "Enemy Under Cursor") or ((576 + 2594) <= (35 + 1429))) then
					if ((v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) or ((3524 + 1273) == (8723 - 4335))) then
						if (((1833 - 1282) <= (1194 - (203 + 310))) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				end
				if (((5270 - (1238 + 755)) > (29 + 378)) and v30.Consecration:IsCastable() and (v125 >= (1536 - (709 + 825))) and (v128() <= (0 - 0))) then
					if (((6838 - 2143) >= (2279 - (196 + 668))) and v23(v30.Consecration, not v16:IsInMeleeRange(19 - 14))) then
						return "consecration priority 8";
					end
				end
				if ((v30.LightofDawn:IsReady() and v122 and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or ((v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (3 - 1)) and ((v14:HolyPower() >= (838 - (171 + 662))) or (v14:BuffUp(v30.HolyAvenger) and (v14:HolyPower() >= (96 - (4 + 89)))))))) or ((11257 - 8045) <= (344 + 600))) then
					if (v23(v30.LightofDawn) or ((13598 - 10502) <= (706 + 1092))) then
						return "light_of_dawn priority 10";
					end
				end
				if (((5023 - (35 + 1451)) == (4990 - (28 + 1425))) and v30.ShieldoftheRighteousHoly:IsReady() and (v125 > (1996 - (941 + 1052)))) then
					if (((3680 + 157) >= (3084 - (822 + 692))) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(6 - 1))) then
						return "shield_of_the_righteous priority 12";
					end
				end
				v155 = 1 + 1;
			end
			if ((v155 == (300 - (45 + 252))) or ((2919 + 31) == (1312 + 2500))) then
				if (((11494 - 6771) >= (2751 - (114 + 319))) and v57 and v30.HolyShock:IsReady() and v16:DebuffDown(v30.GlimmerofLightBuff) and (not v30.GlimmerofLight:IsAvailable() or v129(v16))) then
					if (v23(v30.HolyShock, not v16:IsSpellInRange(v30.HolyShock)) or ((2910 - 883) > (3654 - 802))) then
						return "holy_shock damage";
					end
				end
				if ((v57 and v58 and v30.HolyShock:IsReady() and (v126.EnemiesWithDebuffCount(v30.GlimmerofLightBuff, 26 + 14) < v59) and v121) or ((1692 - 556) > (9045 - 4728))) then
					if (((6711 - (556 + 1407)) == (5954 - (741 + 465))) and v126.CastCycle(v30.HolyShock, v124, v129, not v16:IsSpellInRange(v30.HolyShock), nil, nil, v32.HolyShockMouseover)) then
						return "holy_shock_cycle damage";
					end
				end
				if (((4201 - (170 + 295)) <= (2498 + 2242)) and v30.CrusaderStrike:IsReady() and (v30.CrusaderStrike:Charges() == (2 + 0))) then
					if (v23(v30.CrusaderStrike, not v16:IsInMeleeRange(12 - 7)) or ((2811 + 579) <= (1963 + 1097))) then
						return "crusader_strike priority 24";
					end
				end
				if ((v30.HolyPrism:IsReady() and (v125 >= (2 + 0)) and v95) or ((2229 - (957 + 273)) > (721 + 1972))) then
					if (((186 + 277) < (2290 - 1689)) and v23(v32.HolyPrismPlayer)) then
						return "holy_prism on self priority 26";
					end
				end
				v155 = 10 - 6;
			end
			if (((5 - 3) == v155) or ((10809 - 8626) < (2467 - (389 + 1391)))) then
				if (((2855 + 1694) == (474 + 4075)) and v30.HammerofWrath:IsReady()) then
					if (((10635 - 5963) == (5623 - (783 + 168))) and v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath))) then
						return "hammer_of_wrath priority 14";
					end
				end
				if (v30.Judgment:IsReady() or ((12310 - 8642) < (389 + 6))) then
					if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((4477 - (309 + 2)) == (1397 - 942))) then
						return "judgment priority 16";
					end
				end
				if ((LightsHammer == "Player") or ((5661 - (1090 + 122)) == (864 + 1799))) then
					if (v30.LightsHammer:IsCastable() or ((14364 - 10087) < (2046 + 943))) then
						if (v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(1126 - (628 + 490))) or ((157 + 713) >= (10272 - 6123))) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((10108 - 7896) < (3957 - (431 + 343))) and (LightsHammer == "Cursor")) then
					if (((9382 - 4736) > (8655 - 5663)) and v30.LightsHammer:IsCastable()) then
						if (((1133 + 301) < (398 + 2708)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((2481 - (556 + 1139)) < (3038 - (6 + 9))) and (LightsHammer == "Enemy Under Cursor")) then
					if ((v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) or ((448 + 1994) < (38 + 36))) then
						if (((4704 - (28 + 141)) == (1757 + 2778)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				end
				if ((v30.Consecration:IsCastable() and (v128() <= (0 - 0))) or ((2132 + 877) <= (3422 - (486 + 831)))) then
					if (((4762 - 2932) < (12916 - 9247)) and v23(v30.Consecration, not v16:IsInMeleeRange(1 + 4))) then
						return "consecration priority 20";
					end
				end
				v155 = 9 - 6;
			end
			if ((v155 == (1263 - (668 + 595))) or ((1287 + 143) >= (729 + 2883))) then
				if (((7316 - 4633) >= (2750 - (23 + 267))) and v118) then
					local v225 = 1944 - (1129 + 815);
					local v226;
					while true do
						if (((387 - (371 + 16)) == v225) or ((3554 - (1326 + 424)) >= (6202 - 2927))) then
							v226 = v136();
							if (v226 or ((5178 - 3761) > (3747 - (88 + 30)))) then
								return v226;
							end
							break;
						end
					end
				end
				if (((5566 - (720 + 51)) > (894 - 492)) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:BuffUp(v30.AvengingWrathBuff) or v14:BuffUp(v30.HolyAvenger) or not v30.Awakening:IsAvailable())) then
					if (((6589 - (421 + 1355)) > (5881 - 2316)) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(3 + 2))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((4995 - (286 + 797)) == (14300 - 10388)) and v30.ShieldoftheRighteousHoly:IsReady() and (v14:HolyPower() >= (4 - 1)) and (v126.FriendlyUnitsBelowHealthPercentageCount(v89) < v90)) then
					if (((3260 - (397 + 42)) <= (1507 + 3317)) and v23(v30.ShieldoftheRighteousHoly, not v16:IsInMeleeRange(805 - (24 + 776)))) then
						return "shield_of_the_righteous priority 2";
					end
				end
				if (((2677 - 939) <= (2980 - (222 + 563))) and v30.HammerofWrath:IsReady() and (v14:HolyPower() < (11 - 6)) and (v125 == (2 + 0))) then
					if (((231 - (23 + 167)) <= (4816 - (690 + 1108))) and v23(v30.HammerofWrath, not v16:IsSpellInRange(v30.HammerofWrath))) then
						return "hammer_of_wrath priority 4";
					end
				end
				v155 = 1 + 0;
			end
			if (((1770 + 375) <= (4952 - (40 + 808))) and (v155 == (1 + 4))) then
				if (((10282 - 7593) < (4631 + 214)) and v30.Consecration:IsReady()) then
					if (v23(v30.Consecration, not v16:IsInMeleeRange(3 + 2)) or ((1274 + 1048) > (3193 - (47 + 524)))) then
						return "consecration priority 36";
					end
				end
				break;
			end
			if ((v155 == (3 + 1)) or ((12393 - 7859) == (3112 - 1030))) then
				if ((v30.HolyPrism:IsReady() and v95) or ((3582 - 2011) > (3593 - (1165 + 561)))) then
					if (v23(v30.HolyPrism, not v16:IsSpellInRange(v30.HolyPrism)) or ((79 + 2575) >= (9279 - 6283))) then
						return "holy_prism priority 28";
					end
				end
				if (((1518 + 2460) > (2583 - (341 + 138))) and v30.ArcaneTorrent:IsCastable()) then
					if (((809 + 2186) > (3180 - 1639)) and v23(v30.ArcaneTorrent)) then
						return "arcane_torrent priority 30";
					end
				end
				if (((3575 - (89 + 237)) > (3065 - 2112)) and v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (6 - 3)) and ((v30.Awakening:IsAvailable() and v126.AreUnitsBelowHealthPercentage(v89, v90)) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (883 - (581 + 300))))) then
					if (v23(v30.LightofDawn, not v16:IsSpellInRange(v30.LightofDawn)) or ((4493 - (855 + 365)) > (10861 - 6288))) then
						return "light_of_dawn priority 32";
					end
				end
				if (v30.CrusaderStrike:IsReady() or ((1029 + 2122) < (2519 - (1030 + 205)))) then
					if (v23(v30.CrusaderStrike, not v16:IsInMeleeRange(5 + 0)) or ((1721 + 129) == (1815 - (156 + 130)))) then
						return "crusader_strike priority 34";
					end
				end
				v155 = 11 - 6;
			end
		end
	end
	local function v138()
		local v156 = 0 - 0;
		while true do
			if (((1681 - 860) < (560 + 1563)) and (v156 == (2 + 0))) then
				if (((971 - (10 + 59)) < (658 + 1667)) and v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) then
					if (((4225 - 3367) <= (4125 - (671 + 492))) and v23(v32.BeaconofVirtueFocus)) then
						return "beacon_of_virtue cooldown_healing";
					end
				end
				if ((v30.Daybreak:IsReady() and (v126.FriendlyUnitsWithBuffCount(v30.GlimmerofLightBuff, false, false) > v106) and (v126.AreUnitsBelowHealthPercentage(v104, v105) or (v14:ManaPercentage() <= v103)) and v102) or ((3142 + 804) < (2503 - (369 + 846)))) then
					if (v23(v30.Daybreak) or ((859 + 2383) == (484 + 83))) then
						return "daybreak cooldown_healing";
					end
				end
				if ((v30.HandofDivinity:IsReady() and v126.AreUnitsBelowHealthPercentage(v111, v112) and v110) or ((2792 - (1036 + 909)) >= (1005 + 258))) then
					if (v23(v30.HandofDivinity) or ((3782 - 1529) == (2054 - (11 + 192)))) then
						return "divine_toll cooldown_healing";
					end
				end
				v156 = 2 + 1;
			end
			if ((v156 == (176 - (135 + 40))) or ((5056 - 2969) > (1430 + 942))) then
				if ((v30.AuraMastery:IsCastable() and v126.AreUnitsBelowHealthPercentage(v73, v74) and v72) or ((9792 - 5347) < (6219 - 2070))) then
					if (v23(v30.AuraMastery) or ((1994 - (50 + 126)) == (236 - 151))) then
						return "aura_mastery cooldown_healing";
					end
				end
				if (((140 + 490) < (3540 - (1233 + 180))) and v30.AvengingWrath:IsCastable() and not v14:BuffUp(v30.AvengingWrathBuff) and v126.AreUnitsBelowHealthPercentage(v70, v71) and v69) then
					if (v23(v30.AvengingWrath) or ((2907 - (522 + 447)) == (3935 - (107 + 1314)))) then
						return "avenging_wrath cooldown_healing";
					end
				end
				if (((1975 + 2280) >= (167 - 112)) and v30.TyrsDeliverance:IsCastable() and v107 and v126.AreUnitsBelowHealthPercentage(v108, v109)) then
					if (((1274 + 1725) > (2295 - 1139)) and v23(v30.TyrsDeliverance)) then
						return "tyrs_deliverance cooldown_healing";
					end
				end
				v156 = 7 - 5;
			end
			if (((4260 - (716 + 1194)) > (20 + 1135)) and (v156 == (0 + 0))) then
				if (((4532 - (74 + 429)) <= (9361 - 4508)) and (not v13 or not v13:Exists() or not v13:IsInRange(20 + 20))) then
					return;
				end
				if ((v30.LayonHands:IsCastable() and (v13:HealthPercentage() <= v62) and v61) or ((1180 - 664) > (2430 + 1004))) then
					if (((12473 - 8427) >= (7499 - 4466)) and v23(v32.LayonHandsFocus)) then
						return "lay_on_hands cooldown_healing";
					end
				end
				if ((v100 == "Not Tank") or ((3152 - (279 + 154)) <= (2225 - (454 + 324)))) then
					if ((v30.BlessingofProtection:IsCastable() and (v13:HealthPercentage() <= v101) and (not v126.UnitGroupRole(v13) == "TANK")) or ((3253 + 881) < (3943 - (12 + 5)))) then
						if (v23(v32.BlessingofProtectionFocus) or ((89 + 75) >= (7096 - 4311))) then
							return "blessing_of_protection cooldown_healing";
						end
					end
				elseif ((v100 == "Player") or ((195 + 330) == (3202 - (277 + 816)))) then
					if (((140 - 107) == (1216 - (1058 + 125))) and v30.BlessingofProtection:IsCastable() and (v14:HealthPercentage() <= v101)) then
						if (((573 + 2481) <= (4990 - (815 + 160))) and v23(v32.BlessingofProtectionplayer)) then
							return "blessing_of_protection cooldown_healing";
						end
					end
				end
				v156 = 4 - 3;
			end
			if (((4441 - 2570) < (807 + 2575)) and (v156 == (8 - 5))) then
				if (((3191 - (41 + 1857)) <= (4059 - (1222 + 671))) and v30.DivineToll:IsReady() and v126.AreUnitsBelowHealthPercentage(v92, v93) and v91) then
					if (v23(v32.DivineTollFocus) or ((6665 - 4086) < (175 - 52))) then
						return "divine_toll cooldown_healing";
					end
				end
				if ((v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) or ((2028 - (229 + 953)) >= (4142 - (1111 + 663)))) then
					if (v23(v32.HolyShockFocus) or ((5591 - (874 + 705)) <= (471 + 2887))) then
						return "holy_shock cooldown_healing";
					end
				end
				if (((1020 + 474) <= (6246 - 3241)) and v30.BlessingofSacrifice:IsReady() and (v13:GUID() ~= v14:GUID()) and (v13:HealthPercentage() <= v76) and v75) then
					if (v23(v32.BlessingofSacrificeFocus) or ((88 + 3023) == (2813 - (642 + 37)))) then
						return "blessing_of_sacrifice cooldown_healing";
					end
				end
				break;
			end
		end
	end
	local function v139()
		if (((537 + 1818) == (377 + 1978)) and v30.BeaconofVirtue:IsReady() and v126.AreUnitsBelowHealthPercentage(v86, v87) and v85) then
			if (v23(v32.BeaconofVirtueFocus) or ((1475 - 887) <= (886 - (233 + 221)))) then
				return "beacon_of_virtue aoe_healing";
			end
		end
		if (((11092 - 6295) >= (3429 + 466)) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (1544 - (718 + 823))) and v14:BuffUp(v30.EmpyreanLegacyBuff) and (((v13:HealthPercentage() <= v84) and v67) or v126.AreUnitsBelowHealthPercentage(v89, v90))) then
			if (((2251 + 1326) == (4382 - (266 + 539))) and v23(v32.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if (((10741 - 6947) > (4918 - (636 + 589))) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (6 - 3)) and v14:BuffUp(v30.UnendingLightBuff) and (v13:HealthPercentage() <= v84) and v67) then
			if (v23(v32.WordofGloryFocus) or ((2629 - 1354) == (3250 + 850))) then
				return "word_of_glory aoe_healing";
			end
		end
		if ((v30.LightofDawn:IsReady() and v122 and (v14:HolyPower() >= (2 + 1)) and (v126.AreUnitsBelowHealthPercentage(v89, v90) or (v126.FriendlyUnitsBelowHealthPercentageCount(v84) > (1017 - (657 + 358))))) or ((4212 - 2621) >= (8156 - 4576))) then
			if (((2170 - (1151 + 36)) <= (1746 + 62)) and v23(v30.LightofDawn)) then
				return "light_of_dawn aoe_healing";
			end
		end
		if ((v30.WordofGlory:IsReady() and (v14:HolyPower() >= (1 + 2)) and (v13:HealthPercentage() <= v84) and UseWodOfGlory and (v126.FriendlyUnitsBelowHealthPercentageCount(v84) < (8 - 5))) or ((3982 - (1552 + 280)) <= (2031 - (64 + 770)))) then
			if (((2559 + 1210) >= (2662 - 1489)) and v23(v32.WordofGloryFocus)) then
				return "word_of_glory aoe_healing";
			end
		end
		if (((264 + 1221) == (2728 - (157 + 1086))) and v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
			if (v23(v32.LightoftheMartyrFocus) or ((6635 - 3320) <= (12184 - 9402))) then
				return "holy_shock cooldown_healing";
			end
		end
		if (v126.TargetIsValid() or ((1343 - 467) >= (4045 - 1081))) then
			if ((v30.Consecration:IsCastable() and v30.GoldenPath:IsAvailable() and (v128() <= (819 - (599 + 220)))) or ((4444 - 2212) > (4428 - (1813 + 118)))) then
				if (v23(v30.Consecration, not v16:IsInMeleeRange(4 + 1)) or ((3327 - (841 + 376)) <= (464 - 132))) then
					return "consecration aoe_healing";
				end
			end
			if (((857 + 2829) > (8657 - 5485)) and v30.Judgment:IsReady() and v30.JudgmentofLight:IsAvailable() and v16:DebuffDown(v30.JudgmentofLightDebuff)) then
				if (v23(v30.Judgment, not v16:IsSpellInRange(v30.Judgment)) or ((5333 - (464 + 395)) < (2104 - 1284))) then
					return "judgment aoe_healing";
				end
			end
			if (((2055 + 2224) >= (3719 - (467 + 370))) and v126.AreUnitsBelowHealthPercentage(v98, v99)) then
				if ((LightsHammerLightsHammerUsage == "Player") or ((4192 - 2163) >= (2585 + 936))) then
					if (v30.LightsHammer:IsCastable() or ((6982 - 4945) >= (725 + 3917))) then
						if (((4001 - 2281) < (4978 - (150 + 370))) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(1290 - (74 + 1208)))) then
							return "lights_hammer priority 6";
						end
					end
				elseif ((LightsHammerLightsHammerUsage == "Cursor") or ((1072 - 636) > (14327 - 11306))) then
					if (((508 + 205) <= (1237 - (14 + 376))) and v30.LightsHammer:IsCastable()) then
						if (((3735 - 1581) <= (2609 + 1422)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				elseif (((4055 + 560) == (4402 + 213)) and (LightsHammerLightsHammerUsage == "Enemy Under Cursor")) then
					if ((v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) or ((11105 - 7315) == (377 + 123))) then
						if (((167 - (23 + 55)) < (523 - 302)) and v23(v32.LightsHammercursor)) then
							return "lights_hammer priority 6";
						end
					end
				end
			end
		end
	end
	local function v140()
		local v157 = 0 + 0;
		while true do
			if (((1845 + 209) >= (2203 - 782)) and (v157 == (1 + 1))) then
				if (((1593 - (652 + 249)) < (8183 - 5125)) and v30.LightoftheMartyr:IsReady() and (v13:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (v23(v32.LightoftheMartyrFocus) or ((5122 - (708 + 1160)) == (4492 - 2837))) then
						return "holy_shock cooldown_healing";
					end
				end
				if ((v30.BarrierofFaith:IsCastable() and (v13:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) or ((2362 - 1066) == (4937 - (10 + 17)))) then
					if (((757 + 2611) == (5100 - (1400 + 332))) and v23(v32.BarrierofFaith, nil, true)) then
						return "barrier_of_faith st_healing";
					end
				end
				v157 = 5 - 2;
			end
			if (((4551 - (242 + 1666)) < (1633 + 2182)) and (v157 == (0 + 0))) then
				if (((1631 + 282) > (1433 - (850 + 90))) and v30.WordofGlory:IsReady() and (v14:HolyPower() >= (4 - 1)) and (v13:HealthPercentage() <= v84) and v67) then
					if (((6145 - (360 + 1030)) > (3034 + 394)) and v23(v32.WordofGloryFocus)) then
						return "word_of_glory st_healing";
					end
				end
				if (((3897 - 2516) <= (3258 - 889)) and v30.HolyShock:IsReady() and (v13:HealthPercentage() <= v78) and v77) then
					if (v23(v32.HolyShockFocus) or ((6504 - (909 + 752)) == (5307 - (109 + 1114)))) then
						return "holy_shock st_healing";
					end
				end
				v157 = 1 - 0;
			end
			if (((1818 + 2851) > (605 - (6 + 236))) and (v157 == (1 + 0))) then
				if ((v30.DivineFavor:IsReady() and (v13:HealthPercentage() <= v83) and v82) or ((1511 + 366) >= (7400 - 4262))) then
					if (((8282 - 3540) >= (4759 - (1076 + 57))) and v23(v30.DivineFavor)) then
						return "divine_favor st_healing";
					end
				end
				if ((v30.FlashofLight:IsCastable() and (v13:HealthPercentage() <= v80) and v79) or ((747 + 3793) == (1605 - (579 + 110)))) then
					if (v23(v32.FlashofLightFocus, nil, true) or ((92 + 1064) > (3842 + 503))) then
						return "flash_of_light st_healing";
					end
				end
				v157 = 2 + 0;
			end
			if (((2644 - (174 + 233)) < (11868 - 7619)) and (v157 == (6 - 2))) then
				if ((v30.HolyLight:IsCastable() and (v13:HealthPercentage() <= v83) and v82) or ((1194 + 1489) < (1197 - (663 + 511)))) then
					if (((622 + 75) <= (180 + 646)) and v23(v32.HolyLightFocus, nil, true)) then
						return "holy_light st_healing";
					end
				end
				if (((3406 - 2301) <= (713 + 463)) and v126.AreUnitsBelowHealthPercentage(v98, v99)) then
					if (((7954 - 4575) <= (9227 - 5415)) and (v97 == "Player")) then
						if (v30.LightsHammer:IsCastable() or ((377 + 411) >= (3145 - 1529))) then
							if (((1322 + 532) <= (309 + 3070)) and v23(v32.LightsHammerPlayer, not v16:IsInMeleeRange(730 - (478 + 244)))) then
								return "lights_hammer priority 6";
							end
						end
					elseif (((5066 - (440 + 77)) == (2069 + 2480)) and (v97 == "Cursor")) then
						if (v30.LightsHammer:IsCastable() or ((11060 - 8038) >= (4580 - (655 + 901)))) then
							if (((894 + 3926) > (1683 + 515)) and v23(v32.LightsHammercursor)) then
								return "lights_hammer priority 6";
							end
						end
					elseif ((v97 == "Enemy Under Cursor") or ((717 + 344) >= (19704 - 14813))) then
						if (((2809 - (695 + 750)) <= (15273 - 10800)) and v30.LightsHammer:IsCastable() and v15:Exists() and v14:CanAttack(v15)) then
							if (v23(v32.LightsHammercursor) or ((5547 - 1952) <= (11 - 8))) then
								return "lights_hammer priority 6";
							end
						end
					end
				end
				break;
			end
			if ((v157 == (354 - (285 + 66))) or ((10890 - 6218) == (5162 - (682 + 628)))) then
				if (((252 + 1307) == (1858 - (176 + 123))) and v30.FlashofLight:IsCastable() and v14:BuffUp(v30.InfusionofLightBuff) and (v13:HealthPercentage() <= v81) and v79) then
					if (v23(v32.FlashofLightFocus, nil, true) or ((733 + 1019) <= (572 + 216))) then
						return "flash_of_light st_healing";
					end
				end
				if ((v30.HolyPrism:IsReady() and (v13:HealthPercentage() <= v96) and v94) or ((4176 - (239 + 30)) == (49 + 128))) then
					if (((3336 + 134) > (981 - 426)) and v23(v32.HolyPrismPlayer)) then
						return "holy_prism on self priority 26";
					end
				end
				v157 = 12 - 8;
			end
		end
	end
	local function v141()
		local v158 = 315 - (306 + 9);
		local v159;
		while true do
			if ((v158 == (3 - 2)) or ((170 + 802) == (396 + 249))) then
				if (((1532 + 1650) >= (6048 - 3933)) and v159) then
					return v159;
				end
				v159 = v140();
				v158 = 1377 - (1140 + 235);
			end
			if (((2478 + 1415) < (4062 + 367)) and ((0 + 0) == v158)) then
				if (not v13 or not v13:Exists() or not v13:IsInRange(92 - (33 + 19)) or ((1036 + 1831) < (5709 - 3804))) then
					return;
				end
				v159 = v139();
				v158 = 1 + 0;
			end
			if (((3 - 1) == v158) or ((1685 + 111) >= (4740 - (586 + 103)))) then
				if (((148 + 1471) <= (11563 - 7807)) and v159) then
					return v159;
				end
				break;
			end
		end
	end
	local function v142()
		local v160 = 1488 - (1309 + 179);
		local v161;
		while true do
			if (((1089 - 485) == (263 + 341)) and (v160 == (5 - 3))) then
				v161 = v135();
				if (v161 or ((3387 + 1097) == (1912 - 1012))) then
					return v161;
				end
				v161 = v138();
				if (v161 or ((8884 - 4425) <= (1722 - (295 + 314)))) then
					return v161;
				end
				v160 = 6 - 3;
			end
			if (((5594 - (1300 + 662)) > (10670 - 7272)) and (v160 == (1755 - (1178 + 577)))) then
				if (((2120 + 1962) <= (14535 - 9618)) and v126.GetCastingEnemy(v30.BlackoutBarrelDebuff) and v30.BlessingofFreedom:IsReady()) then
					local v227 = 1405 - (851 + 554);
					local v228;
					while true do
						if (((4273 + 559) >= (3843 - 2457)) and ((0 - 0) == v227)) then
							v228 = v126.FocusSpecifiedUnit(v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)), 342 - (115 + 187));
							if (((105 + 32) == (130 + 7)) and v228) then
								return v228;
							end
							v227 = 3 - 2;
						end
						if ((v227 == (1162 - (160 + 1001))) or ((1374 + 196) >= (2989 + 1343))) then
							if ((v13 and UnitIsUnit(v13:ID(), v126.GetUnitsTargetFriendly(v126.GetCastingEnemy(v30.BlackoutBarrelDebuff)):ID())) or ((8319 - 4255) <= (2177 - (237 + 121)))) then
								if (v23(v32.BlessingofFreedomFocus) or ((5883 - (525 + 372)) < (2983 - 1409))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				v161 = v126.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 131 - 91, 162 - (96 + 46));
				if (((5203 - (643 + 134)) > (63 + 109)) and v161) then
					return v161;
				end
				if (((1404 - 818) > (1689 - 1234)) and v30.BlessingofFreedom:IsReady() and v126.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
					if (((793 + 33) == (1620 - 794)) and v23(v32.BlessingofFreedomFocus)) then
						return "blessing_of_freedom combat";
					end
				end
				v160 = 1 - 0;
			end
			if (((723 - (316 + 403)) == v160) or ((2672 + 1347) > (12209 - 7768))) then
				if (((729 + 1288) < (10730 - 6469)) and v126.TargetIsValid()) then
					v161 = v136();
					if (((3342 + 1374) > (26 + 54)) and v161) then
						return v161;
					end
					v161 = v137();
					if (v161 or ((12151 - 8644) == (15626 - 12354))) then
						return v161;
					end
				end
				break;
			end
			if ((v160 == (5 - 2)) or ((51 + 825) >= (6053 - 2978))) then
				v161 = v132();
				if (((213 + 4139) > (7514 - 4960)) and v161) then
					return v161;
				end
				v161 = v141();
				if (v161 or ((4423 - (12 + 5)) < (15703 - 11660))) then
					return v161;
				end
				v160 = 8 - 4;
			end
			if ((v160 == (1 - 0)) or ((4684 - 2795) >= (687 + 2696))) then
				if (((3865 - (1656 + 317)) <= (2437 + 297)) and v41) then
					v161 = v133();
					if (((1541 + 382) < (5897 - 3679)) and v161) then
						return v161;
					end
				end
				if (((10694 - 8521) > (733 - (5 + 349))) and v45) then
					if ((v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) or ((12306 - 9715) == (4680 - (266 + 1005)))) then
						if (((2975 + 1539) > (11341 - 8017)) and v23(v32.BlessingofFreedomPlayer)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if ((v115 ~= "None") or ((273 - 65) >= (6524 - (561 + 1135)))) then
					if ((v30.BeaconofLight:IsCastable() and (v126.NamedUnit(52 - 12, v115, 98 - 68) ~= nil) and v126.NamedUnit(1106 - (507 + 559), v115, 75 - 45):BuffDown(v30.BeaconofLight)) or ((4895 - 3312) > (3955 - (212 + 176)))) then
						if (v23(v32.BeaconofLightMacro) or ((2218 - (250 + 655)) == (2165 - 1371))) then
							return "beacon_of_light combat";
						end
					end
				end
				if (((5545 - 2371) > (4540 - 1638)) and (v116 ~= "None")) then
					if (((6076 - (1869 + 87)) <= (14775 - 10515)) and v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(1941 - (484 + 1417), v116, 64 - 34) ~= nil) and v126.NamedUnit(67 - 27, v116, 803 - (48 + 725)):BuffDown(v30.BeaconofFaith)) then
						if (v23(v32.BeaconofFaithMacro) or ((1442 - 559) > (12818 - 8040))) then
							return "beacon_of_faith combat";
						end
					end
				end
				v160 = 2 + 0;
			end
		end
	end
	local function v143()
		if (v41 or ((9674 - 6054) >= (1369 + 3522))) then
			ShouldReturn = v133();
			if (((1241 + 3017) > (1790 - (152 + 701))) and ShouldReturn) then
				return ShouldReturn;
			end
		end
		if (v45 or ((6180 - (430 + 881)) < (347 + 559))) then
			if ((v14:DebuffUp(v30.Entangled) and v30.BlessingofFreedom:IsReady()) or ((2120 - (557 + 338)) > (1250 + 2978))) then
				if (((9378 - 6050) > (7836 - 5598)) and v23(v32.BlessingofFreedomPlayer)) then
					return "blessing_of_freedom out of combat";
				end
			end
		end
		if (((10199 - 6360) > (3027 - 1622)) and v117) then
			local v201 = 801 - (499 + 302);
			local v202;
			while true do
				if ((v201 == (866 - (39 + 827))) or ((3568 - 2275) <= (1132 - 625))) then
					if ((v115 ~= "None") or ((11502 - 8606) < (1235 - 430))) then
						if (((199 + 2117) == (6778 - 4462)) and v30.BeaconofLight:IsCastable() and (v126.NamedUnit(7 + 33, v115, 47 - 17) ~= nil) and v126.NamedUnit(144 - (103 + 1), v115, 584 - (475 + 79)):BuffDown(v30.BeaconofLight)) then
							if (v23(v32.BeaconofLightMacro) or ((5555 - 2985) == (4905 - 3372))) then
								return "beacon_of_light combat";
							end
						end
					end
					if ((v116 ~= "None") or ((115 + 768) == (1285 + 175))) then
						if ((v30.BeaconofFaith:IsCastable() and (v126.NamedUnit(1543 - (1395 + 108), v116, 87 - 57) ~= nil) and v126.NamedUnit(1244 - (7 + 1197), v116, 14 + 16):BuffDown(v30.BeaconofFaith)) or ((1612 + 3007) <= (1318 - (27 + 292)))) then
							if (v23(v32.BeaconofFaithMacro) or ((9992 - 6582) > (5248 - 1132))) then
								return "beacon_of_faith combat";
							end
						end
					end
					v201 = 4 - 3;
				end
				if ((v201 == (1 - 0)) or ((1719 - 816) >= (3198 - (43 + 96)))) then
					v202 = v141();
					if (v202 or ((16218 - 12242) < (6458 - 3601))) then
						return v202;
					end
					break;
				end
			end
		end
		if (((4091 + 839) > (652 + 1655)) and v30.DevotionAura:IsCastable() and v14:BuffDown(v30.DevotionAura)) then
			if (v23(v30.DevotionAura) or ((7996 - 3950) < (495 + 796))) then
				return "devotion_aura";
			end
		end
		if (v126.TargetIsValid() or ((7947 - 3706) == (1117 + 2428))) then
			local v203 = v134();
			if (v203 or ((297 + 3751) > (5983 - (1414 + 337)))) then
				return v203;
			end
		end
	end
	local function v144()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (1940 - (1642 + 298));
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['HandleCharredTreant'];
		v44 = EpicSettings.Settings['HandleCharredBrambles'];
		v45 = EpicSettings.Settings['HandleEntangling'];
		v46 = EpicSettings.Settings['InterruptWithStun'];
		v47 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v48 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v53 = EpicSettings.Settings['UseHealthstone'];
		v54 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v55 = EpicSettings.Settings['UseAvengingWrathOffensively'];
		v56 = EpicSettings.Settings['UseDivineTollOffensively'];
		v57 = EpicSettings.Settings['UseHolyShockOffensively'];
		v58 = EpicSettings.Settings['UseHolyShockCycle'];
		v59 = EpicSettings.Settings['UseHolyShockGroup'] or (0 + 0);
		v60 = EpicSettings.Settings['UseHolyShockRefreshOnly'];
		v61 = EpicSettings.Settings['UseLayOnHands'];
		v62 = EpicSettings.Settings['LayOnHandsHP'] or (0 + 0);
		v63 = EpicSettings.Settings['UseDivineProtection'];
		v64 = EpicSettings.Settings['DivineProtectionHP'] or (972 - (357 + 615));
		v65 = EpicSettings.Settings['UseDivineShield'];
		v66 = EpicSettings.Settings['DivineShieldHP'] or (0 + 0);
		v67 = EpicSettings.Settings['UseWordOfGlory'];
		v68 = EpicSettings.Settings['WordofGlorydHP'] or (0 - 0);
		v69 = EpicSettings.Settings['UseAvengingWrath'];
		v70 = EpicSettings.Settings['AvengingWrathHP'] or (0 + 0);
		v71 = EpicSettings.Settings['AvengingWrathGroup'] or (0 - 0);
		v72 = EpicSettings.Settings['UseAuraMastery'];
		v73 = EpicSettings.Settings['AuraMasteryhHP'] or (0 + 0);
		v74 = EpicSettings.Settings['AuraMasteryGroup'] or (0 + 0);
		v75 = EpicSettings.Settings['UseBlessingOfSacrifice'];
		v76 = EpicSettings.Settings['BlessingOfSacrificeHP'] or (0 + 0);
		v77 = EpicSettings.Settings['UseHolyShock'];
		v78 = EpicSettings.Settings['HolyShockHP'] or (1301 - (384 + 917));
	end
	local function v145()
		local v188 = 697 - (128 + 569);
		while true do
			if ((v188 == (1549 - (1407 + 136))) or ((3637 - (687 + 1200)) >= (5183 - (556 + 1154)))) then
				v114 = EpicSettings.Settings['BarrierOfFaithHP'] or (0 - 0);
				v115 = EpicSettings.Settings['BeaconOfLightUsage'] or "";
				v116 = EpicSettings.Settings['BeaconOfFaithUsage'] or "";
				break;
			end
			if (((3261 - (9 + 86)) == (3587 - (275 + 146))) and (v188 == (1 + 4))) then
				v108 = EpicSettings.Settings['TyrsDeliveranceHP'] or (64 - (29 + 35));
				v109 = EpicSettings.Settings['TyrsDeliveranceGroup'] or (0 - 0);
				v110 = EpicSettings.Settings['UseHandOfDivinity'];
				v111 = EpicSettings.Settings['HandOfDivinityHP'] or (0 - 0);
				v112 = EpicSettings.Settings['HandOfDivinityGroup'] or (0 - 0);
				v113 = EpicSettings.Settings['UseBarrierOfFaith'];
				v188 = 4 + 2;
			end
			if (((2775 - (53 + 959)) < (4132 - (312 + 96))) and (v188 == (1 - 0))) then
				v84 = EpicSettings.Settings['WordOfGloryHP'] or (285 - (147 + 138));
				v85 = EpicSettings.Settings['UseBeaconOfVirtue'];
				v86 = EpicSettings.Settings['BeaconOfVirtueHP'] or (899 - (813 + 86));
				v87 = EpicSettings.Settings['BeaconOfVirtueGroup'] or (0 + 0);
				v88 = EpicSettings.Settings['UseLightOfDawn'];
				v89 = EpicSettings.Settings['LightOfDawnhHP'] or (0 - 0);
				v188 = 494 - (18 + 474);
			end
			if (((20 + 37) <= (8887 - 6164)) and (v188 == (1089 - (860 + 226)))) then
				v96 = EpicSettings.Settings['HolyPrismHP'] or (303 - (121 + 182));
				v97 = EpicSettings.Settings['LightsHammerUsage'] or "";
				v98 = EpicSettings.Settings['LightsHammerHP'] or (0 + 0);
				v99 = EpicSettings.Settings['LightsHammerGroup'] or (1240 - (988 + 252));
				v100 = EpicSettings.Settings['BlessingOfProtectionUsage'] or "";
				v101 = EpicSettings.Settings['BlessingOfProtection'] or (0 + 0);
				v188 = 2 + 2;
			end
			if (((1974 - (49 + 1921)) == v188) or ((2960 - (223 + 667)) == (495 - (51 + 1)))) then
				v102 = EpicSettings.Settings['UseDaybreak'];
				v103 = EpicSettings.Settings['DaybreakMana'] or (0 - 0);
				v104 = EpicSettings.Settings['DaybreakHP'] or (0 - 0);
				v105 = EpicSettings.Settings['DaybreakHGroup'] or (1125 - (146 + 979));
				v106 = EpicSettings.Settings['DaybreakGroup'] or (0 + 0);
				v107 = EpicSettings.Settings['UseTyrsDeliverance'];
				v188 = 610 - (311 + 294);
			end
			if (((5 - 3) == v188) or ((1146 + 1559) == (2836 - (496 + 947)))) then
				v90 = EpicSettings.Settings['LightOfDawnGroup'] or (1358 - (1233 + 125));
				v91 = EpicSettings.Settings['UseDivineToll'];
				v92 = EpicSettings.Settings['DivineTollHP'] or (0 + 0);
				v93 = EpicSettings.Settings['DivineTollGroup'] or (0 + 0);
				v94 = EpicSettings.Settings['UseHolyPrism'];
				v95 = EpicSettings.Settings['UseHolyPrismOffensively'];
				v188 = 1 + 2;
			end
			if ((v188 == (1645 - (963 + 682))) or ((3840 + 761) < (1565 - (504 + 1000)))) then
				v79 = EpicSettings.Settings['UseFlashOfLight'];
				v80 = EpicSettings.Settings['FlashOfLightHP'] or (0 + 0);
				v81 = EpicSettings.Settings['FlashOfLightInfusionHP'] or (0 + 0);
				v82 = EpicSettings.Settings['UseHolyLight'];
				v83 = EpicSettings.Settings['HolyLightHP'] or (0 + 0);
				v67 = EpicSettings.Settings['UseWordOfGlory'];
				v188 = 1 - 0;
			end
		end
	end
	local function v146()
		local v189 = 0 + 0;
		while true do
			if ((v189 == (3 + 1)) or ((1572 - (156 + 26)) >= (2733 + 2011))) then
				if (not v14:IsChanneling() or ((3132 - 1129) > (3998 - (149 + 15)))) then
					if (v117 or v14:AffectingCombat() or ((1116 - (890 + 70)) > (4030 - (39 + 78)))) then
						if (((677 - (14 + 468)) == (428 - 233)) and v14:AffectingCombat()) then
							local v235 = v142();
							if (((8678 - 5573) >= (927 + 869)) and v235) then
								return v235;
							end
						else
							local v236 = v143();
							if (((2630 + 1749) >= (453 + 1678)) and v236) then
								return v236;
							end
						end
					end
				end
				break;
			end
			if (((1737 + 2107) >= (536 + 1507)) and (v189 == (3 - 1))) then
				if (v14:IsMounted() or ((3195 + 37) <= (9596 - 6865))) then
					return;
				end
				if (((124 + 4781) == (4956 - (12 + 39))) and v14:IsDeadOrGhost()) then
					return;
				end
				if (v43 or ((3848 + 288) >= (13653 - 9242))) then
					local v229 = 0 - 0;
					while true do
						if ((v229 == (1 + 2)) or ((1558 + 1400) == (10185 - 6168))) then
							ShouldReturn = v126.HandleCharredTreant(v30.HolyLight, v32.HolyLightMouseover, 27 + 13);
							if (((5934 - 4706) >= (2523 - (1596 + 114))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v229 == (4 - 2)) or ((4168 - (164 + 549)) > (5488 - (1059 + 379)))) then
							ShouldReturn = v126.HandleCharredTreant(v30.FlashofLight, v32.FlashofLightMouseover, 49 - 9);
							if (((126 + 117) == (41 + 202)) and ShouldReturn) then
								return ShouldReturn;
							end
							v229 = 395 - (145 + 247);
						end
						if ((v229 == (0 + 0)) or ((126 + 145) > (4660 - 3088))) then
							ShouldReturn = v126.HandleCharredTreant(v30.HolyShock, v32.HolyShockMouseover, 8 + 32);
							if (((2360 + 379) < (5346 - 2053)) and ShouldReturn) then
								return ShouldReturn;
							end
							v229 = 721 - (254 + 466);
						end
						if ((v229 == (561 - (544 + 16))) or ((12527 - 8585) < (1762 - (294 + 334)))) then
							ShouldReturn = v126.HandleCharredTreant(v30.WordofGlory, v32.WordofGloryMouseover, 293 - (236 + 17));
							if (ShouldReturn or ((1161 + 1532) == (3872 + 1101))) then
								return ShouldReturn;
							end
							v229 = 7 - 5;
						end
					end
				end
				if (((10160 - 8014) == (1105 + 1041)) and v44) then
					local v230 = 0 + 0;
					while true do
						if (((794 - (413 + 381)) == v230) or ((95 + 2149) == (6856 - 3632))) then
							ShouldReturn = v126.HandleCharredBrambles(v30.HolyShock, v32.HolyShockMouseover, 103 - 63);
							if (ShouldReturn or ((6874 - (582 + 1388)) <= (3263 - 1347))) then
								return ShouldReturn;
							end
							v230 = 1 + 0;
						end
						if (((454 - (326 + 38)) <= (3150 - 2085)) and (v230 == (3 - 0))) then
							ShouldReturn = v126.HandleCharredBrambles(v30.HolyLight, v32.HolyLightMouseover, 660 - (47 + 573));
							if (((1693 + 3109) == (20394 - 15592)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v230 == (2 - 0)) or ((3944 - (1269 + 395)) <= (1003 - (76 + 416)))) then
							ShouldReturn = v126.HandleCharredBrambles(v30.FlashofLight, v32.FlashofLightMouseover, 483 - (319 + 124));
							if (ShouldReturn or ((3830 - 2154) <= (1470 - (564 + 443)))) then
								return ShouldReturn;
							end
							v230 = 7 - 4;
						end
						if (((4327 - (337 + 121)) == (11336 - 7467)) and (v230 == (3 - 2))) then
							ShouldReturn = v126.HandleCharredBrambles(v30.WordofGlory, v32.WordofGloryMouseover, 1951 - (1261 + 650));
							if (((490 + 668) <= (4163 - 1550)) and ShouldReturn) then
								return ShouldReturn;
							end
							v230 = 1819 - (772 + 1045);
						end
					end
				end
				v189 = 1 + 2;
			end
			if ((v189 == (147 - (102 + 42))) or ((4208 - (1524 + 320)) <= (3269 - (1049 + 221)))) then
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((5078 - (18 + 138)) < (474 - 280))) then
					local v231 = 1102 - (67 + 1035);
					local v232;
					while true do
						if ((v231 == (348 - (136 + 212))) or ((8885 - 6794) < (25 + 6))) then
							v232 = v126.DeadFriendlyUnitsCount();
							if (v14:AffectingCombat() or ((2241 + 189) >= (6476 - (240 + 1364)))) then
								if (v30.Intercession:IsCastable() or ((5852 - (1050 + 32)) < (6194 - 4459))) then
									if (v23(v30.Intercession, nil, true) or ((2626 + 1813) <= (3405 - (331 + 724)))) then
										return "intercession";
									end
								end
							elseif ((v232 > (1 + 0)) or ((5123 - (269 + 375)) < (5191 - (267 + 458)))) then
								if (((793 + 1754) > (2355 - 1130)) and v23(v30.Absolution, nil, true)) then
									return "absolution";
								end
							elseif (((5489 - (667 + 151)) > (4171 - (1410 + 87))) and v23(v30.Redemption, not v16:IsInRange(1937 - (1504 + 393)), true)) then
								return "redemption";
							end
							break;
						end
					end
				end
				if (v14:AffectingCombat() or (v41 and v119) or ((9990 - 6294) < (8631 - 5304))) then
					local v233 = v41 and v30.Cleanse:IsReady();
					local v234 = v126.FocusUnit(v233, v32, 816 - (461 + 335));
					if (v234 or ((581 + 3961) == (4731 - (1730 + 31)))) then
						return v234;
					end
				end
				v124 = v14:GetEnemiesInMeleeRange(1675 - (728 + 939));
				if (((892 - 640) <= (4010 - 2033)) and AOE) then
					v125 = #v124;
				else
					v125 = 2 - 1;
				end
				v189 = 1072 - (138 + 930);
			end
			if ((v189 == (0 + 0)) or ((1123 + 313) == (3236 + 539))) then
				v144();
				v145();
				v117 = EpicSettings.Toggles['ooc'];
				v118 = EpicSettings.Toggles['cds'];
				v189 = 4 - 3;
			end
			if ((v189 == (1767 - (459 + 1307))) or ((3488 - (474 + 1396)) < (1623 - 693))) then
				v119 = EpicSettings.Toggles['dispel'];
				v120 = EpicSettings.Toggles['spread'];
				v121 = EpicSettings.Toggles['cycle'];
				v122 = EpicSettings.Toggles['lod'];
				v189 = 2 + 0;
			end
		end
	end
	local function v147()
		local v190 = 0 + 0;
		while true do
			if (((13528 - 8805) > (527 + 3626)) and (v190 == (3 - 2))) then
				v126.DispellableDebuffs = v11.MergeTable(v126.DispellableDebuffs, v126.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion("Holy Paladin X v 10.2.01 By BoomK");
				break;
			end
			if ((v190 == (0 - 0)) or ((4245 - (562 + 29)) >= (3968 + 686))) then
				v20.Print("Holy Paladin by Epic.");
				v126.DispellableDebuffs = v126.DispellableMagicDebuffs;
				v190 = 1420 - (374 + 1045);
			end
		end
	end
	v20.SetAPL(52 + 13, v146, v147);
end;
return v0["Epix_Paladin_HolyPal.lua"]();

