local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1716 + 1564) == (6316 - 3036)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = GetNumGroupMembers;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v111 = 12010 - (503 + 396);
	local v112 = 11292 - (92 + 89);
	local v113;
	local v114 = v17.Monk.Mistweaver;
	local v115 = v19.Monk.Mistweaver;
	local v116 = v24.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = v21.Commons.Everyone;
	local v121 = v21.Commons.Monk;
	local function v122()
		if (v114.ImprovedDetox:IsAvailable() or ((3805 - 1843) >= (1286 + 1221))) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if ((v114.DampenHarm:IsCastable() and v12:BuffDown(v114.FortifyingBrew) and (v12:HealthPercentage() <= v42) and v41) or ((163 + 111) == (14027 - 10445))) then
			if (v23(v114.DampenHarm, nil) or ((263 + 1655) == (2451 - 1376))) then
				return "dampen_harm defensives 1";
			end
		end
		if (((346 + 50) <= (1817 + 1987)) and v114.FortifyingBrew:IsCastable() and v12:BuffDown(v114.DampenHarmBuff) and (v12:HealthPercentage() <= v40) and v39) then
			if (v23(v114.FortifyingBrew, nil) or ((12697 - 8528) == (273 + 1914))) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((2143 - 737) == (2650 - (485 + 759))) and v114.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v55) and v54 and v12:BuffUp(v114.ChiHarmonyBuff)) then
			if (((3542 - 2011) < (5460 - (442 + 747))) and v23(v114.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if (((1770 - (832 + 303)) == (1581 - (88 + 858))) and v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v12:HealthPercentage() <= v85)) then
			if (((1029 + 2344) <= (2943 + 613)) and v23(v116.Healthstone)) then
				return "healthstone defensive 4";
			end
		end
		if ((v86 and (v12:HealthPercentage() <= v87)) or ((136 + 3155) < (4069 - (766 + 23)))) then
			local v156 = 0 - 0;
			while true do
				if (((5997 - 1611) >= (2299 - 1426)) and (v156 == (0 - 0))) then
					if (((1994 - (1036 + 37)) <= (782 + 320)) and (v88 == "Refreshing Healing Potion")) then
						if (((9164 - 4458) >= (758 + 205)) and v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) then
							if (v23(v116.RefreshingHealingPotion) or ((2440 - (641 + 839)) <= (1789 - (910 + 3)))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((5266 - 3200) == (2616 - (1466 + 218)))) then
						if (((2218 + 2607) < (5991 - (556 + 592))) and v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) then
							if (v23(v116.RefreshingHealingPotion) or ((1379 + 2498) >= (5345 - (329 + 479)))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v124()
		if (v102 or ((5169 - (174 + 680)) < (5930 - 4204))) then
			v28 = v120.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 62 - 32, true);
			if (v28 or ((2627 + 1052) < (1364 - (396 + 343)))) then
				return v28;
			end
		end
		if (v101 or ((410 + 4215) < (2109 - (29 + 1448)))) then
			v28 = v120.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 1419 - (135 + 1254));
			if (v28 or ((312 - 229) > (8311 - 6531))) then
				return v28;
			end
			if (((364 + 182) <= (2604 - (389 + 1138))) and v114.Detox:CooldownRemains()) then
				v28 = v120.HandleAfflicted(v114.Vivify, v116.VivifyMouseover, 604 - (102 + 472));
				if (v28 or ((940 + 56) > (2386 + 1915))) then
					return v28;
				end
			end
		end
		if (((3795 + 275) > (2232 - (320 + 1225))) and v103) then
			local v157 = 0 - 0;
			while true do
				if ((v157 == (0 + 0)) or ((2120 - (157 + 1307)) >= (5189 - (821 + 1038)))) then
					v28 = v120.HandleChromie(v114.Riptide, v116.RiptideMouseover, 99 - 59);
					if (v28 or ((273 + 2219) <= (594 - 259))) then
						return v28;
					end
					v157 = 1 + 0;
				end
				if (((10712 - 6390) >= (3588 - (834 + 192))) and (v157 == (1 + 0))) then
					v28 = v120.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 11 + 29);
					if (v28 or ((79 + 3558) >= (5840 - 2070))) then
						return v28;
					end
					break;
				end
			end
		end
		if (v104 or ((2683 - (300 + 4)) > (1223 + 3355))) then
			v28 = v120.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 104 - 64);
			if (v28 or ((845 - (112 + 250)) > (297 + 446))) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 100 - 60);
			if (((1406 + 1048) > (299 + 279)) and v28) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 30 + 10);
			if (((462 + 468) < (3312 + 1146)) and v28) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 1454 - (1001 + 413));
			if (((1476 - 814) <= (1854 - (244 + 638))) and v28) then
				return v28;
			end
		end
		if (((5063 - (627 + 66)) == (13021 - 8651)) and v105) then
			local v158 = 602 - (512 + 90);
			while true do
				if ((v158 == (1908 - (1665 + 241))) or ((5479 - (373 + 344)) <= (389 + 472))) then
					v28 = v120.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 11 + 29);
					if (v28 or ((3724 - 2312) == (7215 - 2951))) then
						return v28;
					end
					v158 = 1102 - (35 + 1064);
				end
				if ((v158 == (0 + 0)) or ((6777 - 3609) < (9 + 2144))) then
					v28 = v120.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 1276 - (298 + 938));
					if (v28 or ((6235 - (233 + 1026)) < (2998 - (636 + 1030)))) then
						return v28;
					end
					v158 = 1 + 0;
				end
				if (((4521 + 107) == (1375 + 3253)) and (v158 == (1 + 2))) then
					v28 = v120.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 261 - (55 + 166));
					if (v28 or ((11 + 43) == (40 + 355))) then
						return v28;
					end
					break;
				end
				if (((312 - 230) == (379 - (36 + 261))) and ((1 - 0) == v158)) then
					v28 = v120.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 1408 - (34 + 1334));
					if (v28 or ((224 + 357) < (220 + 62))) then
						return v28;
					end
					v158 = 1285 - (1035 + 248);
				end
			end
		end
		if (v106 or ((4630 - (20 + 1)) < (1300 + 1195))) then
			v28 = v120.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 359 - (134 + 185));
			if (((2285 - (549 + 584)) == (1837 - (314 + 371))) and v28) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 137 - 97);
			if (((2864 - (478 + 490)) <= (1813 + 1609)) and v28) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 1212 - (786 + 386));
			if (v28 or ((3206 - 2216) > (2999 - (1055 + 324)))) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 1380 - (1093 + 247));
			if (v28 or ((780 + 97) > (494 + 4201))) then
				return v28;
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if (((9132 - 6441) >= (5266 - 3415)) and ((2 - 1) == v138)) then
				if ((v114.TigerPalm:IsCastable() and v48) or ((1062 + 1923) >= (18707 - 13851))) then
					if (((14738 - 10462) >= (902 + 293)) and v23(v114.TigerPalm, not v14:IsInMeleeRange(12 - 7))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if (((3920 - (364 + 324)) <= (12856 - 8166)) and (v138 == (0 - 0))) then
				if ((v114.ChiBurst:IsCastable() and v50) or ((297 + 599) >= (13163 - 10017))) then
					if (((4901 - 1840) >= (8983 - 6025)) and v23(v114.ChiBurst, not v14:IsInRange(1308 - (1249 + 19)))) then
						return "chi_burst precombat 4";
					end
				end
				if (((2877 + 310) >= (2506 - 1862)) and v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (1088 - (686 + 400)))) then
					if (((506 + 138) <= (933 - (73 + 156))) and v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(1 + 7))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v138 = 812 - (721 + 90);
			end
		end
	end
	local function v126()
		if (((11 + 947) > (3074 - 2127)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (473 - (224 + 246))) and v44) then
			if (((7276 - 2784) >= (4886 - 2232)) and (v43 == "Player")) then
				if (((625 + 2817) >= (36 + 1467)) and v23(v116.SummonWhiteTigerStatuePlayer, not v14:IsInRange(30 + 10))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v43 == "Cursor") or ((6302 - 3132) <= (4871 - 3407))) then
				if (v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(553 - (203 + 310))) or ((6790 - (1238 + 755)) == (307 + 4081))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((2085 - (709 + 825)) <= (1254 - 573)) and (v43 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
				if (((4773 - 1496) > (1271 - (196 + 668))) and v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(157 - 117))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((9725 - 5030) >= (2248 - (171 + 662))) and (v43 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
				if (v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(133 - (4 + 89))) or ((11257 - 8045) <= (344 + 600))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif ((v43 == "Confirmation") or ((13598 - 10502) <= (706 + 1092))) then
				if (((5023 - (35 + 1451)) == (4990 - (28 + 1425))) and v23(v116.SummonWhiteTigerStatue, not v14:IsInRange(2033 - (941 + 1052)))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((3680 + 157) >= (3084 - (822 + 692))) and v114.TouchofDeath:IsCastable() and v51) then
			if (v23(v114.TouchofDeath, not v14:IsInMeleeRange(6 - 1)) or ((1390 + 1560) == (4109 - (45 + 252)))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((4674 + 49) >= (798 + 1520)) and v114.JadefireStomp:IsReady() and v49) then
			if (v23(v114.JadefireStomp, not v14:IsInMeleeRange(19 - 11)) or ((2460 - (114 + 319)) > (4094 - 1242))) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v114.ChiBurst:IsCastable() and v50) or ((1455 - 319) > (2753 + 1564))) then
			if (((7073 - 2325) == (9948 - 5200)) and v23(v114.ChiBurst, not v14:IsInRange(2003 - (556 + 1407)))) then
				return "chi_burst aoe 4";
			end
		end
		if (((4942 - (741 + 465)) <= (5205 - (170 + 295))) and v114.SpinningCraneKick:IsCastable() and v46 and (v14:DebuffDown(v114.MysticTouchDebuff) or (v120.EnemiesWithDebuffCount(v114.MysticTouchDebuff) <= (v119 - (1 + 0)))) and v114.MysticTouch:IsAvailable()) then
			if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(8 + 0)) or ((8346 - 4956) <= (2537 + 523))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if ((v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v12:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (2 + 1))) or ((566 + 433) > (3923 - (957 + 273)))) then
			if (((124 + 339) < (241 + 360)) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(19 - 14))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v114.BlackoutKick:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (5 - 3)) and v45) or ((6667 - 4484) < (3401 - 2714))) then
			if (((6329 - (389 + 1391)) == (2855 + 1694)) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(1 + 4))) then
				return "blackout_kick aoe 8";
			end
		end
		if (((10635 - 5963) == (5623 - (783 + 168))) and v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (0 - 0)) and v48 and (v119 >= (3 + 0))) then
			if (v23(v114.TigerPalm, not v14:IsInMeleeRange(316 - (309 + 2))) or ((11264 - 7596) < (1607 - (1090 + 122)))) then
				return "tiger_palm aoe 7";
			end
		end
		if ((v114.SpinningCraneKick:IsCastable() and v46) or ((1351 + 2815) == (1527 - 1072))) then
			if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(6 + 2)) or ((5567 - (628 + 490)) == (478 + 2185))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (9 - 7)) or ((5051 - (431 + 343)) < (6036 - 3047))) then
				if ((v114.BlackoutKick:IsCastable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (8 - 5)) and (v114.RisingSunKick:CooldownRemains() > v12:GCD()) and v45) or ((688 + 182) >= (531 + 3618))) then
					if (((3907 - (556 + 1139)) < (3198 - (6 + 9))) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(1 + 4))) then
						return "blackout_kick st 5";
					end
				end
				if (((2381 + 2265) > (3161 - (28 + 141))) and v114.TigerPalm:IsCastable() and ((v12:BuffStack(v114.TeachingsoftheMonasteryBuff) < (2 + 1)) or (v12:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (2 - 0))) and v114.TeachingsoftheMonastery:IsAvailable() and v48) then
					if (((1016 + 418) < (4423 - (486 + 831))) and v23(v114.TigerPalm, not v14:IsInMeleeRange(12 - 7))) then
						return "tiger_palm st 6";
					end
				end
				v139 = 10 - 7;
			end
			if (((149 + 637) < (9558 - 6535)) and (v139 == (1264 - (668 + 595)))) then
				if ((v114.RisingSunKick:IsReady() and v47) or ((2198 + 244) < (15 + 59))) then
					if (((12367 - 7832) == (4825 - (23 + 267))) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(1949 - (1129 + 815)))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v114.ChiBurst:IsCastable() and v50) or ((3396 - (371 + 16)) <= (3855 - (1326 + 424)))) then
					if (((3465 - 1635) < (13407 - 9738)) and v23(v114.ChiBurst, not v14:IsInRange(158 - (88 + 30)))) then
						return "chi_burst st 4";
					end
				end
				v139 = 773 - (720 + 51);
			end
			if ((v139 == (6 - 3)) or ((3206 - (421 + 1355)) >= (5958 - 2346))) then
				if (((1318 + 1365) >= (3543 - (286 + 797))) and v114.BlackoutKick:IsCastable() and not v114.TeachingsoftheMonastery:IsAvailable() and v45) then
					if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(18 - 13)) or ((2987 - 1183) >= (3714 - (397 + 42)))) then
						return "blackout_kick st 7";
					end
				end
				if ((v114.TigerPalm:IsCastable() and v48) or ((443 + 974) > (4429 - (24 + 776)))) then
					if (((7387 - 2592) > (1187 - (222 + 563))) and v23(v114.TigerPalm, not v14:IsInMeleeRange(11 - 6))) then
						return "tiger_palm st 8";
					end
				end
				break;
			end
			if (((3466 + 1347) > (3755 - (23 + 167))) and (v139 == (1798 - (690 + 1108)))) then
				if (((1412 + 2500) == (3227 + 685)) and v114.TouchofDeath:IsCastable() and v51) then
					if (((3669 - (40 + 808)) <= (795 + 4029)) and v23(v114.TouchofDeath, not v14:IsInMeleeRange(19 - 14))) then
						return "touch_of_death st 1";
					end
				end
				if (((1662 + 76) <= (1162 + 1033)) and v114.JadefireStomp:IsReady() and v49) then
					if (((23 + 18) <= (3589 - (47 + 524))) and v23(v114.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v139 = 1 + 0;
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if (((3207 - 1062) <= (9359 - 5255)) and (v140 == (1727 - (1165 + 561)))) then
				if (((80 + 2609) < (15005 - 10160)) and v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff)) then
					if ((v16:HealthPercentage() <= v53) or ((886 + 1436) > (3101 - (341 + 138)))) then
						if (v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist)) or ((1224 + 3310) == (4296 - 2214))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v114.Vivify:IsReady() and v12:BuffUp(v114.VivaciousVivificationBuff)) or ((1897 - (89 + 237)) > (6006 - 4139))) then
					if ((v16:HealthPercentage() <= v57) or ((5587 - 2933) >= (3877 - (581 + 300)))) then
						if (((5198 - (855 + 365)) > (4997 - 2893)) and v23(v116.VivifyFocus, not v16:IsSpellInRange(v114.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v140 = 1 + 1;
			end
			if (((4230 - (1030 + 205)) > (1447 + 94)) and (v140 == (2 + 0))) then
				if (((3535 - (156 + 130)) > (2165 - 1212)) and v60 and v114.SoothingMist:IsReady() and v16:BuffDown(v114.SoothingMist)) then
					if ((v16:HealthPercentage() <= v61) or ((5516 - 2243) > (9365 - 4792))) then
						if (v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist)) or ((831 + 2320) < (749 + 535))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if ((v140 == (69 - (10 + 59))) or ((524 + 1326) == (7529 - 6000))) then
				if (((1984 - (671 + 492)) < (1691 + 432)) and v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (1216.8 - (369 + 846)))) then
					if (((239 + 663) < (1985 + 340)) and (v16:HealthPercentage() <= v53)) then
						if (((2803 - (1036 + 909)) <= (2356 + 606)) and v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 41 - 16) > (204 - (11 + 192)))) or ((1995 + 1951) < (1463 - (135 + 40)))) then
					if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(11 - 6)) or ((1955 + 1287) == (1249 - 682))) then
						return "RisingSunKick healing st";
					end
				end
				v140 = 1 - 0;
			end
		end
	end
	local function v129()
		local v141 = 176 - (50 + 126);
		while true do
			if ((v141 == (2 - 1)) or ((188 + 659) >= (2676 - (1233 + 180)))) then
				if ((v67 and v114.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) or ((3222 - (522 + 447)) == (3272 - (107 + 1314)))) then
					if (v23(v116.ZenPulseFocus, not v16:IsSpellInRange(v114.ZenPulse)) or ((969 + 1118) > (7227 - 4855))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) or ((1888 + 2557) < (8238 - 4089))) then
					if (v23(v114.SheilunsGift, nil) or ((7193 - 5375) == (1995 - (716 + 1194)))) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((11 + 619) < (228 + 1899)) and (v141 == (503 - (74 + 429)))) then
				if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 48 - 23) > (1 + 0))) or ((4436 - 2498) == (1779 + 735))) then
					if (((13117 - 8862) >= (135 - 80)) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(438 - (279 + 154)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (((3777 - (454 + 324)) > (910 + 246)) and v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) then
					if (((2367 - (12 + 5)) > (623 + 532)) and v36 and (v12:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable()) then
						if (((10265 - 6236) <= (1794 + 3059)) and v23(v114.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v12:GCD())) or ((1609 - (277 + 816)) > (14673 - 11239))) then
						if (((5229 - (1058 + 125)) >= (569 + 2464)) and v23(v114.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if ((v62 and v114.EssenceFont:IsReady() and (v12:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (983 - (815 + 160))))) or ((11666 - 8947) <= (3434 - 1987))) then
						if (v23(v114.EssenceFont, nil) or ((987 + 3147) < (11476 - 7550))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.EssenceFontBuff)) or ((2062 - (41 + 1857)) >= (4678 - (1222 + 671)))) then
						if (v23(v114.EssenceFont, nil) or ((1356 - 831) == (3030 - 921))) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v141 = 1183 - (229 + 953);
			end
		end
	end
	local function v130()
		local v142 = 1774 - (1111 + 663);
		while true do
			if (((1612 - (874 + 705)) == (5 + 28)) and (v142 == (0 + 0))) then
				if (((6347 - 3293) <= (113 + 3902)) and v58 and v114.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 704 - (642 + 37)) < (1 + 2))) then
					local v241 = 0 + 0;
					while true do
						if (((4697 - 2826) < (3836 - (233 + 221))) and (v241 == (2 - 1))) then
							if (((1139 + 154) <= (3707 - (718 + 823))) and v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
						if ((v241 == (0 + 0)) or ((3384 - (266 + 539)) < (347 - 224))) then
							v28 = v120.FocusUnitRefreshableBuff(v114.EnvelopingMist, 1227 - (636 + 589), 94 - 54, nil, false, 51 - 26, v114.EnvelopingMist);
							if (v28 or ((671 + 175) >= (861 + 1507))) then
								return v28;
							end
							v241 = 1016 - (657 + 358);
						end
					end
				end
				if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 66 - 41) > (4 - 2))) or ((5199 - (1151 + 36)) <= (3243 + 115))) then
					if (((393 + 1101) <= (8974 - 5969)) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(1837 - (1552 + 280)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v142 = 835 - (64 + 770);
			end
			if ((v142 == (1 + 0)) or ((7061 - 3950) == (379 + 1755))) then
				if (((3598 - (157 + 1086)) == (4713 - 2358)) and v60 and v114.SoothingMist:IsReady() and v16:BuffUp(v114.ChiHarmonyBuff) and v16:BuffDown(v114.SoothingMist)) then
					if (v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist)) or ((2575 - 1987) <= (662 - 230))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v131()
		if (((6547 - 1750) >= (4714 - (599 + 220))) and v45 and v114.BlackoutKick:IsReady() and (v12:BuffStack(v114.TeachingsoftheMonastery) >= (5 - 2))) then
			if (((5508 - (1813 + 118)) == (2615 + 962)) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(1222 - (841 + 376)))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((5316 - 1522) > (858 + 2835)) and v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) == (8 - 5))) then
			if ((v16:HealthPercentage() <= v59) or ((2134 - (464 + 395)) == (10522 - 6422))) then
				if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((765 + 826) >= (4417 - (467 + 370)))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((2030 - 1047) <= (1328 + 480)) and v47 and v114.RisingSunKick:IsReady()) then
			if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(17 - 12)) or ((336 + 1814) <= (2784 - 1587))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((4289 - (150 + 370)) >= (2455 - (74 + 1208))) and v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) >= (4 - 2))) then
			if (((7042 - 5557) == (1057 + 428)) and (v16:HealthPercentage() <= v59)) then
				if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((3705 - (14 + 376)) <= (4825 - 2043))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.AncientTeachings)) or ((567 + 309) >= (2604 + 360))) then
			if (v23(v114.EssenceFont, nil) or ((2129 + 103) > (7316 - 4819))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v132()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (80 - (23 + 55))) or ((5000 - 2890) <= (222 + 110))) then
				if (((3311 + 375) > (4917 - 1745)) and (v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (8 + 17))) then
					v28 = v130();
					if (v28 or ((5375 - (652 + 249)) < (2194 - 1374))) then
						return v28;
					end
				end
				if (((6147 - (708 + 1160)) >= (7822 - 4940)) and v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and (v120.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist) or v35)) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (27 - (10 + 17))) or ((456 + 1573) >= (5253 - (1400 + 332)))) then
							if ((v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1 - 0))) or ((3945 - (242 + 1666)) >= (1987 + 2655))) then
								local v248 = 0 + 0;
								while true do
									if (((1466 + 254) < (5398 - (850 + 90))) and (v248 == (1 - 0))) then
										if (v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist)) or ((1826 - (360 + 1030)) > (2674 + 347))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
									if (((2011 - 1298) <= (1165 - 318)) and (v248 == (1661 - (909 + 752)))) then
										v28 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 1229 - (109 + 1114), 73 - 33, nil, false, 10 + 15, v114.EnvelopingMist);
										if (((2396 - (6 + 236)) <= (2540 + 1491)) and v28) then
											return v28;
										end
										v248 = 1 + 0;
									end
								end
							end
							if (((10884 - 6269) == (8061 - 3446)) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (1153 - (1076 + 57)))) then
								if (v23(v114.SheilunsGift, nil) or ((624 + 3166) == (1189 - (579 + 110)))) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v242 = 1 + 0;
						end
						if (((79 + 10) < (118 + 103)) and (v242 == (408 - (174 + 233)))) then
							if (((5737 - 3683) >= (2493 - 1072)) and v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v114.AncientTeachings) and (v12:BuffStack(v114.TeachingsoftheMonastery) == (1177 - (663 + 511))) and (v114.SheilunsGift:TimeSinceLastCast() < ((4 + 0) * v12:GCD()))) then
								if (((151 + 541) < (9427 - 6369)) and v23(v114.InvokeChiJiTheRedCrane, nil)) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v143 = 2 + 1;
			end
			if ((v143 == (0 - 0)) or ((7876 - 4622) == (790 + 865))) then
				if ((v79 and v114.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v80)) or ((2522 - 1226) == (3500 + 1410))) then
					if (((308 + 3060) == (4090 - (478 + 244))) and v23(v116.LifeCocoonFocus, not v16:IsSpellInRange(v114.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if (((3160 - (440 + 77)) < (1735 + 2080)) and v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
					if (((7001 - 5088) > (2049 - (655 + 901))) and v23(v114.Revival, nil)) then
						return "Revival CD";
					end
				end
				v143 = 1 + 0;
			end
			if (((3641 + 1114) > (2315 + 1113)) and (v143 == (11 - 8))) then
				if (((2826 - (695 + 750)) <= (8089 - 5720)) and (v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (38 - 13))) then
					local v243 = 0 - 0;
					while true do
						if ((v243 == (351 - (285 + 66))) or ((11289 - 6446) == (5394 - (682 + 628)))) then
							v28 = v131();
							if (((753 + 3916) > (662 - (176 + 123))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v143 == (1 + 0)) or ((1362 + 515) >= (3407 - (239 + 30)))) then
				if (((1290 + 3452) >= (3486 + 140)) and v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
					if (v23(v114.Restoral, nil) or ((8035 - 3495) == (2857 - 1941))) then
						return "Restoral CD";
					end
				end
				if ((v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and (v120.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist) or v35)) or ((1471 - (306 + 9)) > (15162 - 10817))) then
					local v244 = 0 + 0;
					while true do
						if (((1373 + 864) < (2046 + 2203)) and (v244 == (0 - 0))) then
							if ((v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1376 - (1140 + 235)))) or ((1708 + 975) < (22 + 1))) then
								local v249 = 0 + 0;
								while true do
									if (((749 - (33 + 19)) <= (299 + 527)) and (v249 == (0 - 0))) then
										v28 = v120.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 3 + 3, 78 - 38, nil, false, 24 + 1, v114.EnvelopingMist);
										if (((1794 - (586 + 103)) <= (108 + 1068)) and v28) then
											return v28;
										end
										v249 = 2 - 1;
									end
									if (((4867 - (1309 + 179)) <= (6881 - 3069)) and (v249 == (1 + 0))) then
										if (v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist)) or ((2116 - 1328) >= (1221 + 395))) then
											return "Renewing Mist YuLon prep";
										end
										break;
									end
								end
							end
							if (((3938 - 2084) <= (6732 - 3353)) and v36 and v114.ManaTea:IsCastable() and (v12:BuffStack(v114.ManaTeaCharges) >= (612 - (295 + 314))) and v12:BuffDown(v114.ManaTeaBuff)) then
								if (((11172 - 6623) == (6511 - (1300 + 662))) and v23(v114.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v244 = 3 - 2;
						end
						if ((v244 == (1756 - (1178 + 577))) or ((1570 + 1452) >= (8939 - 5915))) then
							if (((6225 - (851 + 554)) > (1944 + 254)) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (55 - 35))) then
								if (v23(v114.SheilunsGift, nil) or ((2304 - 1243) >= (5193 - (115 + 187)))) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if (((1045 + 319) <= (4235 + 238)) and v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (3 - 2)) and v12:BuffUp(v114.ManaTeaBuff) and (v114.SheilunsGift:TimeSinceLastCast() < ((1165 - (160 + 1001)) * v12:GCD()))) then
								if (v23(v114.InvokeYulonTheJadeSerpent, nil) or ((3146 + 449) <= (3 + 0))) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
					end
				end
				v143 = 3 - 1;
			end
		end
	end
	local function v133()
		local v144 = 358 - (237 + 121);
		while true do
			if ((v144 == (901 - (525 + 372))) or ((8857 - 4185) == (12655 - 8803))) then
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v144 = 147 - (96 + 46);
			end
			if (((2336 - (643 + 134)) == (563 + 996)) and (v144 == (0 - 0))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v144 = 3 - 2;
			end
			if (((6 + 0) == v144) or ((3438 - 1686) <= (1610 - 822))) then
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if ((v144 == (722 - (316 + 403))) or ((2597 + 1310) == (486 - 309))) then
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v144 = 2 + 2;
			end
			if (((8738 - 5268) > (394 + 161)) and (v144 == (2 + 3))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v144 = 20 - 14;
			end
			if ((v144 == (9 - 7)) or ((2018 - 1046) == (37 + 608))) then
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v144 = 5 - 2;
			end
			if (((156 + 3026) >= (6222 - 4107)) and (v144 == (18 - (12 + 5)))) then
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v144 = 7 - 5;
			end
		end
	end
	local function v134()
		local v145 = 0 - 0;
		while true do
			if (((8275 - 4382) < (10983 - 6554)) and (v145 == (2 + 4))) then
				v105 = EpicSettings.Settings['HandleCharredBrambles'];
				v104 = EpicSettings.Settings['HandleCharredTreant'];
				v106 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v145 = 1980 - (1656 + 317);
			end
			if ((v145 == (4 + 0)) or ((2298 + 569) < (5065 - 3160))) then
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v145 = 24 - 19;
			end
			if ((v145 == (359 - (5 + 349))) or ((8530 - 6734) >= (5322 - (266 + 1005)))) then
				v94 = EpicSettings.Settings['useLegSweep'];
				v101 = EpicSettings.Settings['handleAfflicted'];
				v102 = EpicSettings.Settings['HandleIncorporeal'];
				v103 = EpicSettings.Settings['HandleChromie'];
				v145 = 4 + 2;
			end
			if (((5524 - 3905) <= (4944 - 1188)) and (v145 == (1704 - (561 + 1135)))) then
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v81 = EpicSettings.Settings['UseRevival'];
				v145 = 11 - 2;
			end
			if (((1985 - 1381) == (1670 - (507 + 559))) and (v145 == (22 - 13))) then
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if ((v145 == (21 - 14)) or ((4872 - (212 + 176)) == (1805 - (250 + 655)))) then
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v145 = 21 - 13;
			end
			if (((0 - 0) == v145) or ((6975 - 2516) <= (3069 - (1869 + 87)))) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v145 = 3 - 2;
			end
			if (((5533 - (484 + 1417)) > (7283 - 3885)) and (v145 == (1 - 0))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v100 = EpicSettings.Settings['useWeapon'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v145 = 775 - (48 + 725);
			end
			if (((6668 - 2586) <= (13191 - 8274)) and (v145 == (2 + 0))) then
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v145 = 7 - 4;
			end
			if (((1353 + 3479) >= (404 + 982)) and (v145 == (856 - (152 + 701)))) then
				v107 = EpicSettings.Settings['useManaPotion'];
				v108 = EpicSettings.Settings['manaPotionSlider'];
				v109 = EpicSettings.Settings['RevivalBurstingGroup'];
				v110 = EpicSettings.Settings['RevivalBurstingStacks'];
				v145 = 1315 - (430 + 881);
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		v133();
		v134();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		v35 = EpicSettings.Toggles['ramp'];
		if (((1032 - (557 + 338)) == (41 + 96)) and v12:IsDeadOrGhost()) then
			return;
		end
		v118 = v12:GetEnemiesInMeleeRange(22 - 14);
		if (v30 or ((5497 - 3927) >= (11508 - 7176))) then
			v119 = #v118;
		else
			v119 = 2 - 1;
		end
		if (v120.TargetIsValid() or v12:AffectingCombat() or ((4865 - (499 + 302)) <= (2685 - (39 + 827)))) then
			local v159 = 0 - 0;
			while true do
				if ((v159 == (0 - 0)) or ((19803 - 14817) < (2416 - 842))) then
					v113 = v12:GetEnemiesInRange(4 + 36);
					v111 = v9.BossFightRemains(nil, true);
					v159 = 2 - 1;
				end
				if (((709 + 3717) > (271 - 99)) and (v159 == (105 - (103 + 1)))) then
					v112 = v111;
					if (((1140 - (475 + 79)) > (983 - 528)) and (v112 == (35555 - 24444))) then
						v112 = v9.FightRemains(v113, false);
					end
					break;
				end
			end
		end
		v28 = v124();
		if (((107 + 719) == (727 + 99)) and v28) then
			return v28;
		end
		if (v12:AffectingCombat() or v29 or ((5522 - (1395 + 108)) > (12923 - 8482))) then
			local v160 = 1204 - (7 + 1197);
			local v161;
			while true do
				if (((880 + 1137) < (1487 + 2774)) and (v160 == (320 - (27 + 292)))) then
					if (((13819 - 9103) > (102 - 22)) and v28) then
						return v28;
					end
					if ((v32 and v89) or ((14707 - 11200) == (6452 - 3180))) then
						if ((v16 and v16:Exists() and v16:IsAPlayer() and (v120.UnitHasDispellableDebuffByPlayer(v16) or v120.DispellableFriendlyUnit(47 - 22))) or ((1015 - (43 + 96)) >= (12543 - 9468))) then
							if (((9838 - 5486) > (2120 + 434)) and v114.Detox:IsCastable()) then
								if ((v135 == (0 + 0)) or ((8708 - 4302) < (1550 + 2493))) then
									v135 = GetTime();
								end
								if (v120.Wait(937 - 437, v135) or ((595 + 1294) >= (249 + 3134))) then
									if (((3643 - (1414 + 337)) <= (4674 - (1642 + 298))) and v23(v116.DetoxFocus, not v16:IsSpellInRange(v114.Detox))) then
										return "detox dispel focus";
									end
									v135 = 0 - 0;
								end
							end
						end
						if (((5531 - 3608) < (6581 - 4363)) and v15 and v15:Exists() and not v12:CanAttack(v15) and v120.UnitHasDispellableDebuffByPlayer(v15)) then
							if (((716 + 1457) > (295 + 84)) and v114.Detox:IsCastable()) then
								if (v23(v116.DetoxMouseover, not v15:IsSpellInRange(v114.Detox)) or ((3563 - (357 + 615)) == (2393 + 1016))) then
									return "detox dispel mouseover";
								end
							end
						end
					end
					break;
				end
				if (((11075 - 6561) > (2849 + 475)) and (v160 == (0 - 0))) then
					v161 = v89 and v114.Detox:IsReady() and v32;
					v28 = v120.FocusUnit(v161, nil, 32 + 8, nil, 2 + 23, v114.EnvelopingMist);
					v160 = 1 + 0;
				end
			end
		end
		if (not v12:AffectingCombat() or ((1509 - (384 + 917)) >= (5525 - (128 + 569)))) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((3126 - (1407 + 136)) > (5454 - (687 + 1200)))) then
				local v239 = 1710 - (556 + 1154);
				local v240;
				while true do
					if (((0 - 0) == v239) or ((1408 - (9 + 86)) == (1215 - (275 + 146)))) then
						v240 = v120.DeadFriendlyUnitsCount();
						if (((517 + 2657) > (2966 - (29 + 35))) and (v240 > (4 - 3))) then
							if (((12306 - 8186) <= (18805 - 14545)) and v23(v114.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v23(v116.ResuscitateMouseover, not v14:IsInRange(27 + 13)) or ((1895 - (53 + 959)) > (5186 - (312 + 96)))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if ((not v12:AffectingCombat() and v29) or ((6283 - 2663) >= (5176 - (147 + 138)))) then
			v28 = v125();
			if (((5157 - (813 + 86)) > (847 + 90)) and v28) then
				return v28;
			end
		end
		if (v29 or v12:AffectingCombat() or ((9020 - 4151) < (1398 - (18 + 474)))) then
			local v162 = 0 + 0;
			while true do
				if ((v162 == (6 - 4)) or ((2311 - (860 + 226)) > (4531 - (121 + 182)))) then
					if (((410 + 2918) > (3478 - (988 + 252))) and v32 and v89) then
						if (((434 + 3405) > (441 + 964)) and v114.TigersLust:IsReady() and v120.UnitHasDebuffFromList(v12, v120.DispellableRootDebuffs) and v12:CanAttack(v14)) then
							if (v23(v114.TigersLust, nil) or ((3263 - (49 + 1921)) <= (1397 - (223 + 667)))) then
								return "Tigers Lust Roots";
							end
						end
					end
					if (v33 or ((2948 - (51 + 1)) < (1385 - 580))) then
						local v245 = 0 - 0;
						while true do
							if (((3441 - (146 + 979)) == (654 + 1662)) and (v245 == (606 - (311 + 294)))) then
								if ((v60 and v114.SoothingMist:IsReady() and v14:BuffDown(v114.SoothingMist) and not v12:CanAttack(v14)) or ((7166 - 4596) == (650 + 883))) then
									if ((v14:HealthPercentage() <= v61) or ((2326 - (496 + 947)) == (2818 - (1233 + 125)))) then
										if (v23(v114.SoothingMist, not v14:IsSpellInRange(v114.SoothingMist)) or ((1875 + 2744) <= (897 + 102))) then
											return "SoothingMist main";
										end
									end
								end
								if ((v36 and (v12:BuffStack(v114.ManaTeaCharges) >= (4 + 14)) and v114.ManaTea:IsCastable()) or ((5055 - (963 + 682)) > (3435 + 681))) then
									if (v23(v114.ManaTea, nil) or ((2407 - (504 + 1000)) >= (2061 + 998))) then
										return "Mana Tea main avoid overcap";
									end
								end
								v245 = 2 + 0;
							end
							if ((v245 == (1 + 1)) or ((5862 - 1886) < (2441 + 416))) then
								if (((2868 + 2062) > (2489 - (156 + 26))) and (v112 > v99) and v31 and v12:AffectingCombat()) then
									v28 = v132();
									if (v28 or ((2331 + 1715) < (2019 - 728))) then
										return v28;
									end
								end
								if (v30 or ((4405 - (149 + 15)) == (4505 - (890 + 70)))) then
									local v250 = 117 - (39 + 78);
									while true do
										if ((v250 == (482 - (14 + 468))) or ((8901 - 4853) > (11828 - 7596))) then
											v28 = v129();
											if (v28 or ((903 + 847) >= (2086 + 1387))) then
												return v28;
											end
											break;
										end
									end
								end
								v245 = 1 + 2;
							end
							if (((1430 + 1736) == (830 + 2336)) and (v245 == (5 - 2))) then
								v28 = v128();
								if (((1743 + 20) < (13085 - 9361)) and v28) then
									return v28;
								end
								break;
							end
							if (((2 + 55) <= (2774 - (12 + 39))) and (v245 == (0 + 0))) then
								if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (278 - 188)) and v66) or ((7372 - 5302) == (132 + 311))) then
									if ((v65 == "Player") or ((1424 + 1281) == (3532 - 2139))) then
										if (v23(v116.SummonJadeSerpentStatuePlayer, not v14:IsInRange(27 + 13)) or ((22235 - 17634) < (1771 - (1596 + 114)))) then
											return "jade serpent main player";
										end
									elseif ((v65 == "Cursor") or ((3629 - 2239) >= (5457 - (164 + 549)))) then
										if (v23(v116.SummonJadeSerpentStatueCursor, not v14:IsInRange(1478 - (1059 + 379))) or ((2486 - 483) > (1988 + 1846))) then
											return "jade serpent main cursor";
										end
									elseif ((v65 == "Confirmation") or ((27 + 129) > (4305 - (145 + 247)))) then
										if (((161 + 34) == (91 + 104)) and v23(v114.SummonJadeSerpentStatue, not v14:IsInRange(118 - 78))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if (((596 + 2509) >= (1548 + 248)) and v52 and v114.RenewingMist:IsReady() and v14:BuffDown(v114.RenewingMistBuff) and not v12:CanAttack(v14)) then
									if (((7109 - 2730) >= (2851 - (254 + 466))) and (v14:HealthPercentage() <= v53)) then
										if (((4404 - (544 + 16)) >= (6492 - 4449)) and v23(v114.RenewingMist, not v14:IsSpellInRange(v114.RenewingMist))) then
											return "RenewingMist main";
										end
									end
								end
								v245 = 629 - (294 + 334);
							end
						end
					end
					break;
				end
				if ((v162 == (254 - (236 + 17))) or ((1394 + 1838) <= (2126 + 605))) then
					if (((18472 - 13567) == (23222 - 18317)) and (v12:DebuffStack(v114.Bursting) > (3 + 2))) then
						if ((v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) or ((3407 + 729) >= (5205 - (413 + 381)))) then
							if (v23(v114.DiffuseMagic, nil) or ((125 + 2833) == (8543 - 4526))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					if (((3189 - 1961) >= (2783 - (582 + 1388))) and (v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) then
						if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) or ((5886 - 2431) > (2900 + 1150))) then
							if (((607 - (326 + 38)) == (718 - 475)) and v23(v114.Revival, nil)) then
								return "Revival Bursting";
							end
						end
					end
					v162 = 2 - 0;
				end
				if (((620 - (47 + 573)) == v162) or ((96 + 175) > (6676 - 5104))) then
					if (((4444 - 1705) < (4957 - (1269 + 395))) and v31 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) then
						if (v23(v116.UseWeapon, nil) or ((4434 - (76 + 416)) < (1577 - (319 + 124)))) then
							return "Using Weapon Macro";
						end
					end
					if ((v107 and v115.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v108)) or ((6155 - 3462) == (5980 - (564 + 443)))) then
						if (((5940 - 3794) == (2604 - (337 + 121))) and v23(v116.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					v162 = 2 - 1;
				end
			end
		end
		if (((v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14) and not v14:IsDeadOrGhost()) or ((7475 - 5231) == (5135 - (1261 + 650)))) then
			local v163 = 0 + 0;
			while true do
				if ((v163 == (0 - 0)) or ((6721 - (772 + 1045)) <= (271 + 1645))) then
					v28 = v123();
					if (((234 - (102 + 42)) <= (2909 - (1524 + 320))) and v28) then
						return v28;
					end
					v163 = 1271 - (1049 + 221);
				end
				if (((4958 - (18 + 138)) == (11753 - 6951)) and ((1103 - (67 + 1035)) == v163)) then
					if ((v97 and ((v31 and v98) or not v98)) or ((2628 - (136 + 212)) <= (2171 - 1660))) then
						local v246 = 0 + 0;
						while true do
							if ((v246 == (1 + 0)) or ((3280 - (240 + 1364)) <= (1545 - (1050 + 32)))) then
								v28 = v120.HandleBottomTrinket(v117, v31, 142 - 102, nil);
								if (((2289 + 1580) == (4924 - (331 + 724))) and v28) then
									return v28;
								end
								break;
							end
							if (((94 + 1064) <= (3257 - (269 + 375))) and (v246 == (725 - (267 + 458)))) then
								v28 = v120.HandleTopTrinket(v117, v31, 13 + 27, nil);
								if (v28 or ((4545 - 2181) <= (2817 - (667 + 151)))) then
									return v28;
								end
								v246 = 1498 - (1410 + 87);
							end
						end
					end
					if (v34 or ((6819 - (1504 + 393)) < (524 - 330))) then
						local v247 = 0 - 0;
						while true do
							if ((v247 == (796 - (461 + 335))) or ((268 + 1823) < (1792 - (1730 + 31)))) then
								if ((v95 and ((v31 and v96) or not v96) and (v112 < (1685 - (728 + 939)))) or ((8606 - 6176) >= (9882 - 5010))) then
									if (v114.BloodFury:IsCastable() or ((10929 - 6159) < (2803 - (138 + 930)))) then
										if (v23(v114.BloodFury, nil) or ((4057 + 382) <= (1838 + 512))) then
											return "blood_fury main 4";
										end
									end
									if (v114.Berserking:IsCastable() or ((3839 + 640) < (18235 - 13769))) then
										if (((4313 - (459 + 1307)) > (3095 - (474 + 1396))) and v23(v114.Berserking, nil)) then
											return "berserking main 6";
										end
									end
									if (((8156 - 3485) > (2507 + 167)) and v114.LightsJudgment:IsCastable()) then
										if (v23(v114.LightsJudgment, not v14:IsInRange(1 + 39)) or ((10586 - 6890) < (422 + 2905))) then
											return "lights_judgment main 8";
										end
									end
									if (v114.Fireblood:IsCastable() or ((15162 - 10620) == (12952 - 9982))) then
										if (((843 - (562 + 29)) <= (1686 + 291)) and v23(v114.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (v114.AncestralCall:IsCastable() or ((2855 - (374 + 1045)) == (2988 + 787))) then
										if (v23(v114.AncestralCall, nil) or ((5024 - 3406) < (1568 - (448 + 190)))) then
											return "ancestral_call main 12";
										end
									end
									if (((1525 + 3198) > (1875 + 2278)) and v114.BagofTricks:IsCastable()) then
										if (v23(v114.BagofTricks, not v14:IsInRange(27 + 13)) or ((14048 - 10394) >= (14461 - 9807))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if (((2445 - (1307 + 187)) <= (5932 - 4436)) and v38 and v114.ThunderFocusTea:IsReady() and (not v114.EssenceFont:IsAvailable() or not v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) and (v114.RisingSunKick:CooldownRemains() < v12:GCD())) then
									if (v23(v114.ThunderFocusTea, nil) or ((4064 - 2328) == (1750 - 1179))) then
										return "ThunderFocusTea main 16";
									end
								end
								v247 = 684 - (232 + 451);
							end
							if ((v247 == (1 + 0)) or ((792 + 104) > (5333 - (510 + 54)))) then
								if (((v119 >= (5 - 2)) and v30) or ((1081 - (13 + 23)) <= (1988 - 968))) then
									v28 = v126();
									if (v28 or ((1666 - 506) <= (595 - 267))) then
										return v28;
									end
								end
								if (((4896 - (830 + 258)) > (10314 - 7390)) and (v119 < (2 + 1))) then
									v28 = v127();
									if (((3311 + 580) < (6360 - (860 + 581))) and v28) then
										return v28;
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
	end
	local function v137()
		v122();
		v114.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(995 - 725, v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

