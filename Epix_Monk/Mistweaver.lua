local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((16733 - 12207) <= (2545 + 277))) then
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
	local v110 = 30784 - 19673;
	local v111 = 8390 + 2721;
	local v112;
	local v113 = v17.Monk.Mistweaver;
	local v114 = v19.Monk.Mistweaver;
	local v115 = v24.Monk.Mistweaver;
	local v116 = {};
	local v117;
	local v118;
	local v119 = v21.Commons.Everyone;
	local v120 = v21.Commons.Monk;
	local function v121()
		if (v113.ImprovedDetox:IsAvailable() or ((5120 - (457 + 32)) == (869 + 1179))) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellablePoisonDebuffs, v119.DispellableDiseaseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		local v137 = 1402 - (832 + 570);
		while true do
			if ((v137 == (2 + 0)) or ((1021 + 2893) == (7696 - 5521))) then
				if ((v85 and (v12:HealthPercentage() <= v86)) or ((2304 + 2478) < (1995 - (588 + 208)))) then
					if ((v87 == "Refreshing Healing Potion") or ((13109 - 8245) < (3702 - (884 + 916)))) then
						if (((10130 - 5291) >= (2146 + 1554)) and v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) then
							if (v23(v115.RefreshingHealingPotion) or ((1728 - (232 + 421)) > (3807 - (1569 + 320)))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((98 + 298) <= (723 + 3081)) and (v87 == "Dreamwalker's Healing Potion")) then
						if ((v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) or ((14048 - 9879) == (2792 - (316 + 289)))) then
							if (((3680 - 2274) == (65 + 1341)) and v23(v115.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
				end
				break;
			end
			if (((2984 - (666 + 787)) < (4696 - (360 + 65))) and (v137 == (0 + 0))) then
				if (((889 - (79 + 175)) == (1001 - 366)) and v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
					if (((2633 + 740) <= (10899 - 7343)) and v23(v113.DampenHarm, nil)) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((6337 - 3046) < (4179 - (503 + 396)))) then
					if (((4567 - (92 + 89)) >= (1692 - 819)) and v23(v113.FortifyingBrew, nil)) then
						return "fortifying_brew defensives 2";
					end
				end
				v137 = 1 + 0;
			end
			if (((546 + 375) <= (4315 - 3213)) and (v137 == (1 + 0))) then
				if (((10730 - 6024) >= (841 + 122)) and v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) then
					if (v23(v113.ExpelHarm, nil) or ((459 + 501) <= (2667 - 1791))) then
						return "expel_harm defensives 3";
					end
				end
				if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) or ((258 + 1808) == (1420 - 488))) then
					if (((6069 - (485 + 759)) < (11205 - 6362)) and v23(v115.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v137 = 1191 - (442 + 747);
			end
		end
	end
	local function v123()
		if (v101 or ((5012 - (832 + 303)) >= (5483 - (88 + 858)))) then
			v28 = v119.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 10 + 20, true);
			if (v28 or ((3572 + 743) < (72 + 1654))) then
				return v28;
			end
		end
		if (v100 or ((4468 - (766 + 23)) < (3085 - 2460))) then
			local v152 = 0 - 0;
			while true do
				if ((v152 == (0 - 0)) or ((15697 - 11072) < (1705 - (1036 + 37)))) then
					v28 = v119.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 22 + 8);
					if (v28 or ((161 - 78) > (1401 + 379))) then
						return v28;
					end
					v152 = 1481 - (641 + 839);
				end
				if (((1459 - (910 + 3)) <= (2745 - 1668)) and (v152 == (1685 - (1466 + 218)))) then
					if (v113.Detox:CooldownRemains() or ((458 + 538) > (5449 - (556 + 592)))) then
						local v244 = 0 + 0;
						while true do
							if (((4878 - (329 + 479)) > (1541 - (174 + 680))) and (v244 == (0 - 0))) then
								v28 = v119.HandleAfflicted(v113.Vivify, v115.VivifyMouseover, 62 - 32);
								if (v28 or ((469 + 187) >= (4069 - (396 + 343)))) then
									return v28;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (v102 or ((221 + 2271) <= (1812 - (29 + 1448)))) then
			local v153 = 1389 - (135 + 1254);
			while true do
				if (((16281 - 11959) >= (11962 - 9400)) and (v153 == (0 + 0))) then
					v28 = v119.HandleChromie(v113.Riptide, v115.RiptideMouseover, 1567 - (389 + 1138));
					if (v28 or ((4211 - (102 + 472)) >= (3558 + 212))) then
						return v28;
					end
					v153 = 1 + 0;
				end
				if ((v153 == (1 + 0)) or ((3924 - (320 + 1225)) > (8149 - 3571))) then
					v28 = v119.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 25 + 15);
					if (v28 or ((1947 - (157 + 1307)) > (2602 - (821 + 1038)))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((6122 - 3668) > (64 + 514)) and v103) then
			local v154 = 0 - 0;
			while true do
				if (((347 + 583) < (11049 - 6591)) and (v154 == (1028 - (834 + 192)))) then
					v28 = v119.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 3 + 37);
					if (((170 + 492) <= (21 + 951)) and v28) then
						return v28;
					end
					v154 = 4 - 1;
				end
				if (((4674 - (300 + 4)) == (1168 + 3202)) and ((2 - 1) == v154)) then
					v28 = v119.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 402 - (112 + 250));
					if (v28 or ((1899 + 2863) <= (2156 - 1295))) then
						return v28;
					end
					v154 = 2 + 0;
				end
				if ((v154 == (0 + 0)) or ((1057 + 355) == (2115 + 2149))) then
					v28 = v119.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 30 + 10);
					if (v28 or ((4582 - (1001 + 413)) < (4800 - 2647))) then
						return v28;
					end
					v154 = 883 - (244 + 638);
				end
				if ((v154 == (696 - (627 + 66))) or ((14826 - 9850) < (1934 - (512 + 90)))) then
					v28 = v119.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1946 - (1665 + 241));
					if (((5345 - (373 + 344)) == (2088 + 2540)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (v104 or ((15 + 39) == (1041 - 646))) then
			local v155 = 0 - 0;
			while true do
				if (((1181 - (35 + 1064)) == (60 + 22)) and (v155 == (2 - 1))) then
					v28 = v119.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 1 + 39);
					if (v28 or ((1817 - (298 + 938)) < (1541 - (233 + 1026)))) then
						return v28;
					end
					v155 = 1668 - (636 + 1030);
				end
				if ((v155 == (2 + 0)) or ((4502 + 107) < (742 + 1753))) then
					v28 = v119.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 3 + 37);
					if (((1373 - (55 + 166)) == (224 + 928)) and v28) then
						return v28;
					end
					v155 = 1 + 2;
				end
				if (((7240 - 5344) <= (3719 - (36 + 261))) and ((0 - 0) == v155)) then
					v28 = v119.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 1408 - (34 + 1334));
					if (v28 or ((381 + 609) > (1259 + 361))) then
						return v28;
					end
					v155 = 1284 - (1035 + 248);
				end
				if ((v155 == (24 - (20 + 1))) or ((457 + 420) > (5014 - (134 + 185)))) then
					v28 = v119.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1173 - (549 + 584));
					if (((3376 - (314 + 371)) >= (6354 - 4503)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (v105 or ((3953 - (478 + 490)) >= (2573 + 2283))) then
			local v156 = 1172 - (786 + 386);
			while true do
				if (((13849 - 9573) >= (2574 - (1055 + 324))) and (v156 == (1342 - (1093 + 247)))) then
					v28 = v119.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 36 + 4);
					if (((340 + 2892) <= (18620 - 13930)) and v28) then
						return v28;
					end
					v156 = 9 - 6;
				end
				if ((v156 == (2 - 1)) or ((2251 - 1355) >= (1120 + 2026))) then
					v28 = v119.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 154 - 114);
					if (((10550 - 7489) >= (2231 + 727)) and v28) then
						return v28;
					end
					v156 = 4 - 2;
				end
				if (((3875 - (364 + 324)) >= (1765 - 1121)) and (v156 == (0 - 0))) then
					v28 = v119.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 14 + 26);
					if (((2694 - 2050) <= (1126 - 422)) and v28) then
						return v28;
					end
					v156 = 2 - 1;
				end
				if (((2226 - (1249 + 19)) > (855 + 92)) and (v156 == (11 - 8))) then
					v28 = v119.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1126 - (686 + 400));
					if (((3525 + 967) >= (2883 - (73 + 156))) and v28) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v124()
		local v138 = 0 + 0;
		while true do
			if (((4253 - (721 + 90)) >= (17 + 1486)) and (v138 == (3 - 2))) then
				if ((v113.TigerPalm:IsCastable() and v47) or ((3640 - (224 + 246)) <= (2371 - 907))) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(9 - 4)) or ((871 + 3926) == (105 + 4283))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if (((405 + 146) <= (1353 - 672)) and (v138 == (0 - 0))) then
				if (((3790 - (203 + 310)) > (2400 - (1238 + 755))) and v113.ChiBurst:IsCastable() and v49) then
					if (((329 + 4366) >= (2949 - (709 + 825))) and v23(v113.ChiBurst, not v14:IsInRange(73 - 33))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (2 - 0))) or ((4076 - (196 + 668)) <= (3726 - 2782))) then
					if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(16 - 8)) or ((3929 - (171 + 662)) <= (1891 - (4 + 89)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v138 = 3 - 2;
			end
		end
	end
	local function v125()
		if (((1288 + 2249) == (15535 - 11998)) and v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (2 + 1)) and v43) then
			if (((5323 - (35 + 1451)) >= (3023 - (28 + 1425))) and (v42 == "Player")) then
				if (v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(2033 - (941 + 1052))) or ((2829 + 121) == (5326 - (822 + 692)))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif (((6742 - 2019) >= (1092 + 1226)) and (v42 == "Cursor")) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(337 - (45 + 252))) or ((2006 + 21) > (982 + 1870))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((2764 - 1628) > (4750 - (114 + 319)))) then
				if (((6816 - 2068) == (6083 - 1335)) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(26 + 14))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((5565 - 1829) <= (9931 - 5191)) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(2003 - (556 + 1407))) or ((4596 - (741 + 465)) <= (3525 - (170 + 295)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif ((v42 == "Confirmation") or ((527 + 472) > (2474 + 219))) then
				if (((1139 - 676) < (499 + 102)) and v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(26 + 14))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if ((v113.TouchofDeath:IsCastable() and v50) or ((1237 + 946) < (1917 - (957 + 273)))) then
			if (((1217 + 3332) == (1822 + 2727)) and v23(v113.TouchofDeath, not v14:IsInMeleeRange(19 - 14))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((12311 - 7639) == (14270 - 9598)) and v113.JadefireStomp:IsReady() and v48) then
			if (v23(v113.JadefireStomp, not v14:IsInMeleeRange(39 - 31)) or ((5448 - (389 + 1391)) < (248 + 147))) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v113.ChiBurst:IsCastable() and v49) or ((434 + 3732) == (1035 - 580))) then
			if (v23(v113.ChiBurst, not v14:IsInRange(991 - (783 + 168))) or ((14931 - 10482) == (2620 + 43))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45 and (v14:DebuffDown(v113.MysticTouchDebuff) or (v119.EnemiesWithDebuffCount(v113.MysticTouchDebuff) <= (v118 - (312 - (309 + 2))))) and v113.MysticTouch:IsAvailable()) or ((13133 - 8856) < (4201 - (1090 + 122)))) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(3 + 5)) or ((2921 - 2051) >= (2840 + 1309))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((3330 - (628 + 490)) < (571 + 2612)) and v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (7 - 4))) then
			if (((21232 - 16586) > (3766 - (431 + 343))) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(10 - 5))) then
				return "blackout_kick aoe 6";
			end
		end
		if (((4148 - 2714) < (2454 + 652)) and v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (0 + 0)) and v47 and (v118 >= (1698 - (556 + 1139)))) then
			if (((801 - (6 + 9)) < (554 + 2469)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(3 + 2))) then
				return "tiger_palm aoe 7";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45) or ((2611 - (28 + 141)) < (29 + 45))) then
			if (((5597 - 1062) == (3212 + 1323)) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(1325 - (486 + 831)))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v126()
		if ((v113.TouchofDeath:IsCastable() and v50) or ((7829 - 4820) <= (7410 - 5305))) then
			if (((346 + 1484) < (11601 - 7932)) and v23(v113.TouchofDeath, not v14:IsInMeleeRange(1268 - (668 + 595)))) then
				return "touch_of_death st 1";
			end
		end
		if ((v113.JadefireStomp:IsReady() and v48) or ((1287 + 143) >= (729 + 2883))) then
			if (((7316 - 4633) >= (2750 - (23 + 267))) and v23(v113.JadefireStomp, nil)) then
				return "JadefireStomp st 2";
			end
		end
		if ((v113.RisingSunKick:IsReady() and v46) or ((3748 - (1129 + 815)) >= (3662 - (371 + 16)))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1755 - (1326 + 424))) or ((2683 - 1266) > (13261 - 9632))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((4913 - (88 + 30)) > (1173 - (720 + 51))) and v113.ChiBurst:IsCastable() and v49) then
			if (((10706 - 5893) > (5341 - (421 + 1355))) and v23(v113.ChiBurst, not v14:IsInRange(65 - 25))) then
				return "chi_burst st 4";
			end
		end
		if (((1922 + 1990) == (4995 - (286 + 797))) and v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (10 - 7)) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
			if (((4672 - 1851) <= (5263 - (397 + 42))) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(2 + 3))) then
				return "blackout_kick st 5";
			end
		end
		if (((2538 - (24 + 776)) <= (3381 - 1186)) and v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (788 - (222 + 563))) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (3 - 1))) and v47) then
			if (((30 + 11) <= (3208 - (23 + 167))) and v23(v113.TigerPalm, not v14:IsInMeleeRange(1803 - (690 + 1108)))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v127()
		if (((774 + 1371) <= (3386 + 718)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (849.8 - (40 + 808)))) then
			if (((443 + 2246) < (18527 - 13682)) and (v16:HealthPercentage() <= v52)) then
				if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((2220 + 102) > (1388 + 1234))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 14 + 11) > (572 - (47 + 524)))) or ((2943 + 1591) == (5691 - 3609))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(7 - 2)) or ((3582 - 2011) > (3593 - (1165 + 561)))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) or ((79 + 2575) >= (9279 - 6283))) then
			if (((1518 + 2460) > (2583 - (341 + 138))) and (v16:HealthPercentage() <= v52)) then
				if (((809 + 2186) > (3180 - 1639)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((3575 - (89 + 237)) > (3065 - 2112)) and v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) then
			if ((v16:HealthPercentage() <= v56) or ((6890 - 3617) > (5454 - (581 + 300)))) then
				if (v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify)) or ((4371 - (855 + 365)) < (3049 - 1765))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) or ((605 + 1245) == (2764 - (1030 + 205)))) then
			if (((771 + 50) < (1975 + 148)) and (v16:HealthPercentage() <= v60)) then
				if (((1188 - (156 + 130)) < (5282 - 2957)) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v128()
		if (((1445 - 587) <= (6065 - 3103)) and v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 7 + 18) > (1 + 0))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(74 - (10 + 59))) or ((1117 + 2829) < (6343 - 5055))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (v119.AreUnitsBelowHealthPercentage(v63, v62, v113.EnvelopingMist) or ((4405 - (671 + 492)) == (452 + 115))) then
			local v157 = 1215 - (369 + 846);
			while true do
				if ((v157 == (0 + 0)) or ((723 + 124) >= (3208 - (1036 + 909)))) then
					if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((1792 + 461) == (3107 - 1256))) then
						if (v23(v113.ManaTea, nil) or ((2290 - (11 + 192)) > (1199 + 1173))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) or ((4620 - (135 + 40)) < (10052 - 5903))) then
						if (v23(v113.ThunderFocusTea, nil) or ((1096 + 722) == (187 - 102))) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v157 = 1 - 0;
				end
				if (((806 - (50 + 126)) < (5922 - 3795)) and (v157 == (1 + 0))) then
					if ((v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (1421 - (1233 + 180))))) or ((2907 - (522 + 447)) == (3935 - (107 + 1314)))) then
						if (((1975 + 2280) >= (167 - 112)) and v23(v113.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((1274 + 1725) > (2295 - 1139)) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) then
						if (((9298 - 6948) > (3065 - (716 + 1194))) and v23(v113.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
			end
		end
		if (((69 + 3960) <= (520 + 4333)) and v66 and v113.ZenPulse:IsReady() and v119.AreUnitsBelowHealthPercentage(v68, v67, v113.EnvelopingMist)) then
			if (v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse)) or ((1019 - (74 + 429)) > (6623 - 3189))) then
				return "ZenPulse healing aoe";
			end
		end
		if (((2006 + 2040) >= (6942 - 3909)) and v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v119.AreUnitsBelowHealthPercentage(v71, v70, v113.EnvelopingMist)) then
			if (v23(v113.SheilunsGift, nil) or ((1924 + 795) <= (4460 - 3013))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v129()
		if ((v57 and v113.EnvelopingMist:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 61 - 36) < (436 - (279 + 154)))) or ((4912 - (454 + 324)) < (3089 + 837))) then
			v28 = v119.FocusUnitRefreshableBuff(v113.EnvelopingMist, 19 - (12 + 5), 22 + 18, nil, false, 63 - 38, v113.EnvelopingMist);
			if (v28 or ((61 + 103) >= (3878 - (277 + 816)))) then
				return v28;
			end
			if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((2243 - 1718) == (3292 - (1058 + 125)))) then
				return "Enveloping Mist YuLon";
			end
		end
		if (((7 + 26) == (1008 - (815 + 160))) and v46 and v113.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 107 - 82) > (4 - 2))) then
			if (((729 + 2325) <= (11736 - 7721)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(1903 - (41 + 1857)))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((3764 - (1222 + 671)) < (8740 - 5358)) and v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) then
			if (((1857 - 564) <= (3348 - (229 + 953))) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v130()
		if ((v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (1777 - (1111 + 663)))) or ((4158 - (874 + 705)) < (18 + 105))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(4 + 1)) or ((1758 - 912) >= (67 + 2301))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (682 - (642 + 37)))) or ((915 + 3097) <= (538 + 2820))) then
			if (((3750 - 2256) <= (3459 - (233 + 221))) and (v16:HealthPercentage() <= v58)) then
				if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((7193 - 4082) == (1879 + 255))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((3896 - (718 + 823)) == (1482 + 873)) and v46 and v113.RisingSunKick:IsReady()) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(810 - (266 + 539))) or ((1664 - 1076) <= (1657 - (636 + 589)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((11386 - 6589) >= (8033 - 4138)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (2 + 0))) then
			if (((1300 + 2277) == (4592 - (657 + 358))) and (v16:HealthPercentage() <= v58)) then
				if (((10045 - 6251) > (8413 - 4720)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) or ((2462 - (1151 + 36)) == (3960 + 140))) then
			if (v23(v113.EssenceFont, nil) or ((419 + 1172) >= (10691 - 7111))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v131()
		local v139 = 1832 - (1552 + 280);
		while true do
			if (((1817 - (64 + 770)) <= (1228 + 580)) and (v139 == (2 - 1))) then
				if ((v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) or ((382 + 1768) <= (2440 - (157 + 1086)))) then
					if (((7543 - 3774) >= (5137 - 3964)) and v23(v113.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((2277 - 792) == (2026 - 541)) and v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v119.AreUnitsBelowHealthPercentage(v74, v73, v113.EnvelopingMist)) then
					if ((v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (820 - (599 + 220)))) or ((6601 - 3286) <= (4713 - (1813 + 118)))) then
						local v245 = 0 + 0;
						while true do
							if ((v245 == (1218 - (841 + 376))) or ((1226 - 350) >= (689 + 2275))) then
								if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((6092 - 3860) > (3356 - (464 + 395)))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if ((v245 == (0 - 0)) or ((1014 + 1096) <= (1169 - (467 + 370)))) then
								v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 11 - 5, 30 + 10, nil, false, 85 - 60, v113.EnvelopingMist);
								if (((576 + 3110) > (7379 - 4207)) and v28) then
									return v28;
								end
								v245 = 521 - (150 + 370);
							end
						end
					end
					if ((v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (1285 - (74 + 1208))) and v12:BuffDown(v113.ManaTeaBuff)) or ((11003 - 6529) < (3888 - 3068))) then
						if (((3045 + 1234) >= (3272 - (14 + 376))) and v23(v113.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (34 - 14))) or ((1313 + 716) >= (3094 + 427))) then
						if (v23(v113.SheilunsGift, nil) or ((1943 + 94) >= (13601 - 8959))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if (((1294 + 426) < (4536 - (23 + 55))) and v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (2 - 1)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((3 + 1) * v12:GCD()))) then
						if (v23(v113.InvokeYulonTheJadeSerpent, nil) or ((392 + 44) > (4683 - 1662))) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v139 = 1 + 1;
			end
			if (((1614 - (652 + 249)) <= (2266 - 1419)) and (v139 == (1870 - (708 + 1160)))) then
				if (((5846 - 3692) <= (7349 - 3318)) and (v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (52 - (10 + 17)))) then
					local v240 = 0 + 0;
					while true do
						if (((6347 - (1400 + 332)) == (8851 - 4236)) and (v240 == (1908 - (242 + 1666)))) then
							v28 = v129();
							if (v28 or ((1622 + 2168) == (184 + 316))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((76 + 13) < (1161 - (850 + 90))) and v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v77, v76, v113.EnvelopingMist)) then
					local v241 = 0 - 0;
					while true do
						if (((3444 - (360 + 1030)) >= (1258 + 163)) and (v241 == (0 - 0))) then
							if (((951 - 259) < (4719 - (909 + 752))) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1224 - (109 + 1114)))) then
								local v246 = 0 - 0;
								while true do
									if (((1 + 0) == v246) or ((3496 - (6 + 236)) == (1043 + 612))) then
										if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((1044 + 252) == (11579 - 6669))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
									if (((5882 - 2514) == (4501 - (1076 + 57))) and (v246 == (0 + 0))) then
										v28 = v119.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 695 - (579 + 110), 4 + 36, nil, false, 23 + 2, v113.EnvelopingMist);
										if (((1403 + 1240) < (4222 - (174 + 233))) and v28) then
											return v28;
										end
										v246 = 2 - 1;
									end
								end
							end
							if (((3357 - 1444) > (220 + 273)) and v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (1194 - (663 + 511)))) then
								if (((4243 + 512) > (745 + 2683)) and v23(v113.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v241 = 2 - 1;
						end
						if (((837 + 544) <= (5577 - 3208)) and (v241 == (2 - 1))) then
							if ((v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (5 - 2)) and (v113.SheilunsGift:TimeSinceLastCast() < ((3 + 1) * v12:GCD()))) or ((443 + 4400) == (4806 - (478 + 244)))) then
								if (((5186 - (440 + 77)) > (166 + 197)) and v23(v113.InvokeChiJiTheRedCrane, nil)) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v139 = 10 - 7;
			end
			if ((v139 == (1556 - (655 + 901))) or ((349 + 1528) >= (2403 + 735))) then
				if (((3202 + 1540) >= (14607 - 10981)) and v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) then
					if (v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon)) or ((5985 - (695 + 750)) == (3127 - 2211))) then
						return "Life Cocoon CD";
					end
				end
				if ((v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) or ((1783 - 627) > (17474 - 13129))) then
					if (((2588 - (285 + 66)) < (9904 - 5655)) and v23(v113.Revival, nil)) then
						return "Revival CD";
					end
				end
				v139 = 1311 - (682 + 628);
			end
			if (((1 + 2) == v139) or ((2982 - (176 + 123)) < (10 + 13))) then
				if (((506 + 191) <= (1095 - (239 + 30))) and (v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (7 + 18))) then
					local v242 = 0 + 0;
					while true do
						if (((1955 - 850) <= (3668 - 2492)) and ((315 - (306 + 9)) == v242)) then
							v28 = v130();
							if (((11791 - 8412) <= (663 + 3149)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (1 + 0)) or ((2253 - 1465) >= (2991 - (1140 + 235)))) then
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v140 = 2 + 0;
			end
			if (((1701 + 153) <= (868 + 2511)) and (v140 == (55 - (33 + 19)))) then
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v140 = 2 + 2;
			end
			if (((13634 - 9085) == (2004 + 2545)) and ((0 - 0) == v140)) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v140 = 1 + 0;
			end
			if ((v140 == (693 - (586 + 103))) or ((276 + 2746) >= (9309 - 6285))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v140 = 1493 - (1309 + 179);
			end
			if (((8701 - 3881) > (957 + 1241)) and (v140 == (13 - 8))) then
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v140 = 5 + 1;
			end
			if ((v140 == (3 - 1)) or ((2114 - 1053) >= (5500 - (295 + 314)))) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v140 = 6 - 3;
			end
			if (((3326 - (1300 + 662)) <= (14045 - 9572)) and (v140 == (1761 - (1178 + 577)))) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
		end
	end
	local function v133()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (8 - 5)) or ((5000 - (851 + 554)) <= (3 + 0))) then
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleChromie'];
				v141 = 10 - 6;
			end
			if (((3 - 1) == v141) or ((4974 - (115 + 187)) == (2950 + 902))) then
				v106 = EpicSettings.Settings['useManaPotion'];
				v107 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['RevivalBurstingGroup'];
				v109 = EpicSettings.Settings['RevivalBurstingStacks'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v141 = 3 + 0;
			end
			if (((6143 - 4584) == (2720 - (160 + 1001))) and (v141 == (0 + 0))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v99 = EpicSettings.Settings['useWeapon'];
				v141 = 1 + 0;
			end
			if ((v141 == (7 - 3)) or ((2110 - (237 + 121)) <= (1685 - (525 + 372)))) then
				v104 = EpicSettings.Settings['HandleCharredBrambles'];
				v103 = EpicSettings.Settings['HandleCharredTreant'];
				v105 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v141 = 9 - 4;
			end
			if ((v141 == (16 - 11)) or ((4049 - (96 + 46)) == (954 - (643 + 134)))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v141 = 3 + 3;
			end
			if (((8320 - 4850) > (2060 - 1505)) and (v141 == (6 + 0))) then
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if ((v141 == (1 - 0)) or ((1986 - 1014) == (1364 - (316 + 403)))) then
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v141 = 2 + 0;
			end
		end
	end
	local v134 = 0 - 0;
	local function v135()
		v132();
		v133();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		if (((1150 + 2032) >= (5326 - 3211)) and v12:IsDeadOrGhost()) then
			return;
		end
		v117 = v12:GetEnemiesInMeleeRange(6 + 2);
		if (((1255 + 2638) < (15346 - 10917)) and v30) then
			v118 = #v117;
		else
			v118 = 4 - 3;
		end
		if (v119.TargetIsValid() or v12:AffectingCombat() or ((5955 - 3088) < (110 + 1795))) then
			local v158 = 0 - 0;
			while true do
				if ((v158 == (1 + 0)) or ((5283 - 3487) >= (4068 - (12 + 5)))) then
					v111 = v110;
					if (((6288 - 4669) <= (8013 - 4257)) and (v111 == (23618 - 12507))) then
						v111 = v9.FightRemains(v112, false);
					end
					break;
				end
				if (((1497 - 893) == (123 + 481)) and (v158 == (1973 - (1656 + 317)))) then
					v112 = v12:GetEnemiesInRange(36 + 4);
					v110 = v9.BossFightRemains(nil, true);
					v158 = 1 + 0;
				end
			end
		end
		v28 = v123();
		if (v28 or ((11922 - 7438) == (4429 - 3529))) then
			return v28;
		end
		if (v12:AffectingCombat() or v29 or ((4813 - (5 + 349)) <= (5286 - 4173))) then
			local v159 = v88 and v113.Detox:IsReady() and v32;
			v28 = v119.FocusUnit(v159, nil, 1311 - (266 + 1005), nil, 17 + 8, v113.EnvelopingMist);
			if (((12392 - 8760) > (4473 - 1075)) and v28) then
				return v28;
			end
			if (((5778 - (561 + 1135)) <= (6407 - 1490)) and v32 and v88) then
				local v235 = 0 - 0;
				while true do
					if (((5898 - (507 + 559)) >= (3477 - 2091)) and (v235 == (0 - 0))) then
						if (((525 - (212 + 176)) == (1042 - (250 + 655))) and v16 and v16:Exists() and v16:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v16)) then
							if (v113.Detox:IsCastable() or ((4281 - 2711) >= (7568 - 3236))) then
								if ((v134 == (0 - 0)) or ((6020 - (1869 + 87)) <= (6308 - 4489))) then
									v134 = GetTime();
								end
								if (v119.Wait(2401 - (484 + 1417), v134) or ((10686 - 5700) < (2637 - 1063))) then
									if (((5199 - (48 + 725)) > (280 - 108)) and v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox))) then
										return "detox dispel focus";
									end
									v134 = 0 - 0;
								end
							end
						end
						if (((341 + 245) > (1215 - 760)) and v15 and v15:Exists() and v15:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v15)) then
							if (((232 + 594) == (241 + 585)) and v113.Detox:IsCastable()) then
								if (v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox)) or ((4872 - (152 + 701)) > (5752 - (430 + 881)))) then
									return "detox dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
		end
		if (((773 + 1244) < (5156 - (557 + 338))) and not v12:AffectingCombat()) then
			if (((1394 + 3322) > (225 - 145)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v236 = 0 - 0;
				local v237;
				while true do
					if ((v236 == (0 - 0)) or ((7558 - 4051) == (4073 - (499 + 302)))) then
						v237 = v119.DeadFriendlyUnitsCount();
						if ((v237 > (867 - (39 + 827))) or ((2417 - 1541) >= (6867 - 3792))) then
							if (((17285 - 12933) > (3920 - 1366)) and v23(v113.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v23(v115.ResuscitateMouseover, not v14:IsInRange(4 + 36)) or ((12895 - 8489) < (647 + 3396))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if ((not v12:AffectingCombat() and v29) or ((2988 - 1099) >= (3487 - (103 + 1)))) then
			v28 = v124();
			if (((2446 - (475 + 79)) <= (5910 - 3176)) and v28) then
				return v28;
			end
		end
		if (((6153 - 4230) < (287 + 1931)) and (v29 or v12:AffectingCombat())) then
			if (((1913 + 260) > (1882 - (1395 + 108))) and v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) then
				if (v23(v115.UseWeapon, nil) or ((7539 - 4948) == (4613 - (7 + 1197)))) then
					return "Using Weapon Macro";
				end
			end
			if (((1969 + 2545) > (1160 + 2164)) and v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) then
				if (v23(v115.ManaPotion, nil) or ((527 - (27 + 292)) >= (14147 - 9319))) then
					return "Mana Potion main";
				end
			end
			if ((v12:DebuffStack(v113.Bursting) > (6 - 1)) or ((6638 - 5055) > (7034 - 3467))) then
				if ((v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) or ((2500 - 1187) == (933 - (43 + 96)))) then
					if (((12946 - 9772) > (6560 - 3658)) and v23(v113.DiffuseMagic, nil)) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((3419 + 701) <= (1203 + 3057)) and (v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) then
				if ((v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) or ((1745 - 862) > (1832 + 2946))) then
					if (v23(v113.Revival, nil) or ((6784 - 3164) >= (1540 + 3351))) then
						return "Revival Bursting";
					end
				end
			end
			if (((313 + 3945) > (2688 - (1414 + 337))) and v33) then
				local v238 = 1940 - (1642 + 298);
				while true do
					if ((v238 == (7 - 4)) or ((14007 - 9138) < (2688 - 1782))) then
						v28 = v127();
						if (v28 or ((404 + 821) > (3290 + 938))) then
							return v28;
						end
						break;
					end
					if (((4300 - (357 + 615)) > (1571 + 667)) and (v238 == (2 - 1))) then
						if (((3290 + 549) > (3010 - 1605)) and v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) then
							if ((v14:HealthPercentage() <= v60) or ((1035 + 258) <= (35 + 472))) then
								if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((1821 + 1075) < (2106 - (384 + 917)))) then
									return "SoothingMist main";
								end
							end
						end
						if (((3013 - (128 + 569)) == (3859 - (1407 + 136))) and v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (1905 - (687 + 1200))) and v113.ManaTea:IsCastable()) then
							if (v23(v113.ManaTea, nil) or ((4280 - (556 + 1154)) == (5393 - 3860))) then
								return "Mana Tea main avoid overcap";
							end
						end
						v238 = 97 - (9 + 86);
					end
					if ((v238 == (421 - (275 + 146))) or ((144 + 739) == (1524 - (29 + 35)))) then
						if ((v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (398 - 308)) and v65) or ((13796 - 9177) <= (4409 - 3410))) then
							if ((v64 == "Player") or ((2222 + 1188) > (5128 - (53 + 959)))) then
								if (v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(448 - (312 + 96))) or ((1566 - 663) >= (3344 - (147 + 138)))) then
									return "jade serpent main player";
								end
							elseif ((v64 == "Cursor") or ((4875 - (813 + 86)) < (2582 + 275))) then
								if (((9134 - 4204) > (2799 - (18 + 474))) and v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(14 + 26))) then
									return "jade serpent main cursor";
								end
							elseif ((v64 == "Confirmation") or ((13205 - 9159) < (2377 - (860 + 226)))) then
								if (v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(343 - (121 + 182))) or ((523 + 3718) == (4785 - (988 + 252)))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if ((v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) or ((458 + 3590) > (1326 + 2906))) then
							if ((v14:HealthPercentage() <= v52) or ((3720 - (49 + 1921)) >= (4363 - (223 + 667)))) then
								if (((3218 - (51 + 1)) == (5448 - 2282)) and v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist))) then
									return "RenewingMist main";
								end
							end
						end
						v238 = 1 - 0;
					end
					if (((2888 - (146 + 979)) < (1052 + 2672)) and (v238 == (607 - (311 + 294)))) then
						if (((158 - 101) <= (1154 + 1569)) and (v111 > v98) and v31 and v12:AffectingCombat()) then
							v28 = v131();
							if (v28 or ((3513 - (496 + 947)) == (1801 - (1233 + 125)))) then
								return v28;
							end
						end
						if (v30 or ((1098 + 1607) == (1250 + 143))) then
							v28 = v128();
							if (v28 or ((875 + 3726) < (1706 - (963 + 682)))) then
								return v28;
							end
						end
						v238 = 3 + 0;
					end
				end
			end
		end
		if (((v29 or v12:AffectingCombat()) and v119.TargetIsValid() and v12:CanAttack(v14)) or ((2894 - (504 + 1000)) >= (3195 + 1549))) then
			v28 = v122();
			if (v28 or ((1825 + 178) > (362 + 3472))) then
				return v28;
			end
			if ((v96 and ((v31 and v97) or not v97)) or ((229 - 73) > (3344 + 569))) then
				local v239 = 0 + 0;
				while true do
					if (((377 - (156 + 26)) == (113 + 82)) and (v239 == (0 - 0))) then
						v28 = v119.HandleTopTrinket(v116, v31, 204 - (149 + 15), nil);
						if (((4065 - (890 + 70)) >= (1913 - (39 + 78))) and v28) then
							return v28;
						end
						v239 = 483 - (14 + 468);
					end
					if (((9629 - 5250) >= (5956 - 3825)) and (v239 == (1 + 0))) then
						v28 = v119.HandleBottomTrinket(v116, v31, 25 + 15, nil);
						if (((817 + 3027) >= (923 + 1120)) and v28) then
							return v28;
						end
						break;
					end
				end
			end
			if (v34 or ((847 + 2385) <= (5227 - 2496))) then
				if (((4848 + 57) == (17236 - 12331)) and v94 and ((v31 and v95) or not v95) and (v111 < (1 + 17))) then
					local v243 = 51 - (12 + 39);
					while true do
						if ((v243 == (1 + 0)) or ((12802 - 8666) >= (15709 - 11298))) then
							if (v113.LightsJudgment:IsCastable() or ((877 + 2081) == (2115 + 1902))) then
								if (((3113 - 1885) >= (542 + 271)) and v23(v113.LightsJudgment, not v14:IsInRange(193 - 153))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((5165 - (1596 + 114)) > (10574 - 6524))) then
								if (((956 - (164 + 549)) == (1681 - (1059 + 379))) and v23(v113.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							v243 = 2 - 0;
						end
						if (((2 + 0) == v243) or ((46 + 225) > (1964 - (145 + 247)))) then
							if (((2248 + 491) < (1522 + 1771)) and v113.AncestralCall:IsCastable()) then
								if (v23(v113.AncestralCall, nil) or ((11686 - 7744) < (218 + 916))) then
									return "ancestral_call main 12";
								end
							end
							if (v113.BagofTricks:IsCastable() or ((2320 + 373) == (8074 - 3101))) then
								if (((2866 - (254 + 466)) == (2706 - (544 + 16))) and v23(v113.BagofTricks, not v14:IsInRange(127 - 87))) then
									return "bag_of_tricks main 14";
								end
							end
							break;
						end
						if ((v243 == (628 - (294 + 334))) or ((2497 - (236 + 17)) == (1390 + 1834))) then
							if (v113.BloodFury:IsCastable() or ((3818 + 1086) <= (7215 - 5299))) then
								if (((426 - 336) <= (549 + 516)) and v23(v113.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (((3955 + 847) == (5596 - (413 + 381))) and v113.Berserking:IsCastable()) then
								if (v23(v113.Berserking, nil) or ((96 + 2184) <= (1086 - 575))) then
									return "berserking main 6";
								end
							end
							v243 = 2 - 1;
						end
					end
				end
				if ((v37 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) or ((3646 - (582 + 1388)) <= (788 - 325))) then
					if (((2770 + 1099) == (4233 - (326 + 38))) and v23(v113.ThunderFocusTea, nil)) then
						return "ThunderFocusTea main 16";
					end
				end
				if (((3425 - 2267) <= (3729 - 1116)) and (v118 >= (623 - (47 + 573))) and v30) then
					v28 = v125();
					if (v28 or ((834 + 1530) <= (8489 - 6490))) then
						return v28;
					end
				end
				if ((v118 < (4 - 1)) or ((6586 - (1269 + 395)) < (686 - (76 + 416)))) then
					v28 = v126();
					if (v28 or ((2534 - (319 + 124)) < (70 - 39))) then
						return v28;
					end
				end
			end
		end
	end
	local function v136()
		local v148 = 1007 - (564 + 443);
		while true do
			if ((v148 == (2 - 1)) or ((2888 - (337 + 121)) >= (14275 - 9403))) then
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
			if ((v148 == (0 - 0)) or ((6681 - (1261 + 650)) < (735 + 1000))) then
				v121();
				v113.Bursting:RegisterAuraTracking();
				v148 = 1 - 0;
			end
		end
	end
	v21.SetAPL(2087 - (772 + 1045), v135, v136);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

