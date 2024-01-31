local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (88 - (36 + 51))) or ((14337 - 11012) > (8176 - 4705))) then
			return v6(...);
		end
		if (((1713 + 1520) == (660 + 2573)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((339 + 1125) <= (1455 + 2922)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Monk_Mistweaver.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Utils;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.Macro;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = GetNumGroupMembers;
	local v29;
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
	local v106 = 12207 - (709 + 387);
	local v107 = 12969 - (673 + 1185);
	local v108;
	local v109 = v18.Monk.Mistweaver;
	local v110 = v20.Monk.Mistweaver;
	local v111 = v25.Monk.Mistweaver;
	local v112 = {};
	local v113;
	local v114;
	local v115 = {{v109.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v109.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v116 = v22.Commons.Everyone;
	local v117 = v22.Commons.Monk;
	local function v118()
		if (((5278 - 2589) < (6603 - (446 + 1434))) and v109.ImprovedDetox:IsAvailable()) then
			v116.DispellableDebuffs = v21.MergeTable(v116.DispellableMagicDebuffs, v116.DispellablePoisonDebuffs, v116.DispellableDiseaseDebuffs);
		else
			v116.DispellableDebuffs = v116.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v118();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v119()
		if (((5419 - (1040 + 243)) >= (7154 - 4757)) and v109.DampenHarm:IsCastable() and v13:BuffDown(v109.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) then
			if (v24(v109.DampenHarm, nil) or ((6181 - (559 + 1288)) == (6176 - (609 + 1322)))) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v109.FortifyingBrew:IsCastable() and v13:BuffDown(v109.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((4730 - (13 + 441)) <= (11326 - 8295))) then
			if (v24(v109.FortifyingBrew, nil) or ((12525 - 7743) <= (5971 - 4772))) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v109.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v109.ChiHarmonyBuff)) or ((182 + 4682) < (6907 - 5005))) then
			if (((1719 + 3120) >= (1622 + 2078)) and v24(v109.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if ((v110.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v85)) or ((3190 - 2115) > (1050 + 868))) then
			if (((727 - 331) <= (2515 + 1289)) and v24(v111.Healthstone)) then
				return "healthstone defensive 4";
			end
		end
		if ((v86 and (v13:HealthPercentage() <= v87)) or ((2319 + 1850) == (1572 + 615))) then
			if (((1181 + 225) == (1376 + 30)) and (v88 == "Refreshing Healing Potion")) then
				if (((1964 - (153 + 280)) < (12332 - 8061)) and v110.RefreshingHealingPotion:IsReady()) then
					if (((571 + 64) == (251 + 384)) and v24(v111.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if (((1766 + 1607) <= (3227 + 329)) and (v88 == "Dreamwalker's Healing Potion")) then
				if (v110.DreamwalkersHealingPotion:IsReady() or ((2385 + 906) < (4994 - 1714))) then
					if (((2711 + 1675) >= (1540 - (89 + 578))) and v24(v111.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v120()
		local v134 = 0 + 0;
		while true do
			if (((1914 - 993) <= (2151 - (572 + 477))) and (v134 == (0 + 0))) then
				if (((2825 + 1881) >= (115 + 848)) and v101) then
					local v226 = 86 - (84 + 2);
					while true do
						if ((v226 == (0 - 0)) or ((692 + 268) <= (1718 - (497 + 345)))) then
							v29 = v116.HandleIncorporeal(v109.Paralysis, v111.ParalysisMouseover, 1 + 29, true);
							if (v29 or ((350 + 1716) == (2265 - (605 + 728)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((3443 + 1382) < (10767 - 5924)) and v100) then
					local v227 = 0 + 0;
					while true do
						if ((v227 == (0 - 0)) or ((3496 + 381) >= (12570 - 8033))) then
							v29 = v116.HandleAfflicted(v109.Detox, v111.DetoxMouseover, 23 + 7);
							if (v29 or ((4804 - (457 + 32)) < (733 + 993))) then
								return v29;
							end
							break;
						end
					end
				end
				v134 = 1403 - (832 + 570);
			end
			if ((v134 == (1 + 0)) or ((960 + 2719) < (2211 - 1586))) then
				if (v102 or ((2228 + 2397) < (1428 - (588 + 208)))) then
					local v228 = 0 - 0;
					while true do
						if ((v228 == (1800 - (884 + 916))) or ((173 - 90) > (1033 + 747))) then
							v29 = v116.HandleChromie(v109.Riptide, v111.RiptideMouseover, 693 - (232 + 421));
							if (((2435 - (1569 + 320)) <= (265 + 812)) and v29) then
								return v29;
							end
							v228 = 1 + 0;
						end
						if ((v228 == (3 - 2)) or ((1601 - (316 + 289)) > (11258 - 6957))) then
							v29 = v116.HandleChromie(v109.HealingSurge, v111.HealingSurgeMouseover, 2 + 38);
							if (((5523 - (666 + 787)) > (1112 - (360 + 65))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v103 or ((614 + 42) >= (3584 - (79 + 175)))) then
					local v229 = 0 - 0;
					while true do
						if ((v229 == (2 + 0)) or ((7638 - 5146) <= (645 - 310))) then
							v29 = v116.HandleCharredTreant(v109.Vivify, v111.VivifyMouseover, 939 - (503 + 396));
							if (((4503 - (92 + 89)) >= (4969 - 2407)) and v29) then
								return v29;
							end
							v229 = 2 + 1;
						end
						if ((v229 == (0 + 0)) or ((14242 - 10605) >= (516 + 3254))) then
							v29 = v116.HandleCharredTreant(v109.RenewingMist, v111.RenewingMistMouseover, 91 - 51);
							if (v29 or ((2076 + 303) > (2187 + 2391))) then
								return v29;
							end
							v229 = 2 - 1;
						end
						if ((v229 == (1 + 2)) or ((736 - 253) > (1987 - (485 + 759)))) then
							v29 = v116.HandleCharredTreant(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 92 - 52);
							if (((3643 - (442 + 747)) > (1713 - (832 + 303))) and v29) then
								return v29;
							end
							break;
						end
						if (((1876 - (88 + 858)) < (1359 + 3099)) and (v229 == (1 + 0))) then
							v29 = v116.HandleCharredTreant(v109.SoothingMist, v111.SoothingMistMouseover, 2 + 38);
							if (((1451 - (766 + 23)) <= (4798 - 3826)) and v29) then
								return v29;
							end
							v229 = 2 - 0;
						end
					end
				end
				v134 = 4 - 2;
			end
			if (((14831 - 10461) == (5443 - (1036 + 37))) and (v134 == (2 + 0))) then
				if (v104 or ((9273 - 4511) <= (678 + 183))) then
					local v230 = 1480 - (641 + 839);
					while true do
						if ((v230 == (914 - (910 + 3))) or ((3599 - 2187) == (5948 - (1466 + 218)))) then
							v29 = v116.HandleCharredBrambles(v109.SoothingMist, v111.SoothingMistMouseover, 19 + 21);
							if (v29 or ((4316 - (556 + 592)) < (766 + 1387))) then
								return v29;
							end
							v230 = 810 - (329 + 479);
						end
						if ((v230 == (856 - (174 + 680))) or ((17098 - 12122) < (2760 - 1428))) then
							v29 = v116.HandleCharredBrambles(v109.Vivify, v111.VivifyMouseover, 29 + 11);
							if (((5367 - (396 + 343)) == (410 + 4218)) and v29) then
								return v29;
							end
							v230 = 1480 - (29 + 1448);
						end
						if ((v230 == (1392 - (135 + 1254))) or ((203 - 149) == (1844 - 1449))) then
							v29 = v116.HandleCharredBrambles(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 27 + 13);
							if (((1609 - (389 + 1138)) == (656 - (102 + 472))) and v29) then
								return v29;
							end
							break;
						end
						if ((v230 == (0 + 0)) or ((323 + 258) < (263 + 19))) then
							v29 = v116.HandleCharredBrambles(v109.RenewingMist, v111.RenewingMistMouseover, 1585 - (320 + 1225));
							if (v29 or ((8204 - 3595) < (1527 + 968))) then
								return v29;
							end
							v230 = 1465 - (157 + 1307);
						end
					end
				end
				if (((3011 - (821 + 1038)) == (2873 - 1721)) and v105) then
					v29 = v116.HandleFyrakkNPC(v109.RenewingMist, v111.RenewingMistMouseover, 5 + 35);
					if (((3367 - 1471) <= (1274 + 2148)) and v29) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.SoothingMist, v111.SoothingMistMouseover, 99 - 59);
					if (v29 or ((2016 - (834 + 192)) > (103 + 1517))) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.Vivify, v111.VivifyMouseover, 11 + 29);
					if (v29 or ((19 + 858) > (7273 - 2578))) then
						return v29;
					end
					v29 = v116.HandleFyrakkNPC(v109.EnvelopingMist, v111.EnvelopingMistMouseover, 344 - (300 + 4));
					if (((719 + 1972) >= (4845 - 2994)) and v29) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v135 = 362 - (112 + 250);
		while true do
			if ((v135 == (0 + 0)) or ((7478 - 4493) >= (2782 + 2074))) then
				if (((2212 + 2064) >= (894 + 301)) and v109.ChiBurst:IsCastable() and v50) then
					if (((1603 + 1629) <= (3485 + 1205)) and v24(v109.ChiBurst, not v15:IsInRange(1454 - (1001 + 413)))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v109.SpinningCraneKick:IsCastable() and v46 and (v114 >= (4 - 2))) or ((1778 - (244 + 638)) >= (3839 - (627 + 66)))) then
					if (((9120 - 6059) >= (3560 - (512 + 90))) and v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(1914 - (1665 + 241)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v135 = 718 - (373 + 344);
			end
			if (((1438 + 1749) >= (171 + 473)) and (v135 == (2 - 1))) then
				if (((1089 - 445) <= (1803 - (35 + 1064))) and v109.TigerPalm:IsCastable() and v48) then
					if (((698 + 260) > (2025 - 1078)) and v24(v109.TigerPalm, not v15:IsInMeleeRange(1 + 4))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v136 = 1236 - (298 + 938);
		while true do
			if (((5751 - (233 + 1026)) >= (4320 - (636 + 1030))) and (v136 == (2 + 1))) then
				if (((3363 + 79) >= (447 + 1056)) and v109.TigerPalm:IsCastable() and v109.TeachingsoftheMonastery:IsAvailable() and (v109.BlackoutKick:CooldownRemains() > (0 + 0)) and v48 and (v114 >= (224 - (55 + 166)))) then
					if (v24(v109.TigerPalm, not v15:IsInMeleeRange(1 + 4)) or ((319 + 2851) <= (5591 - 4127))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v109.SpinningCraneKick:IsCastable() and v46) or ((5094 - (36 + 261)) == (7673 - 3285))) then
					if (((1919 - (34 + 1334)) <= (262 + 419)) and v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(7 + 1))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((4560 - (1035 + 248)) > (428 - (20 + 1))) and (v136 == (2 + 0))) then
				if (((5014 - (134 + 185)) >= (2548 - (549 + 584))) and v109.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v109.MysticTouchDebuff) and v109.MysticTouch:IsAvailable()) then
					if (v24(v109.SpinningCraneKick, not v15:IsInMeleeRange(693 - (314 + 371))) or ((11026 - 7814) <= (1912 - (478 + 490)))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v109.BlackoutKick:IsCastable() and v109.AncientConcordance:IsAvailable() and v13:BuffUp(v109.JadefireStomp) and v45 and (v114 >= (2 + 1))) or ((4268 - (786 + 386)) <= (5823 - 4025))) then
					if (((4916 - (1055 + 324)) == (4877 - (1093 + 247))) and v24(v109.BlackoutKick, not v15:IsInMeleeRange(5 + 0))) then
						return "blackout_kick aoe 6";
					end
				end
				v136 = 1 + 2;
			end
			if (((15233 - 11396) >= (5328 - 3758)) and (v136 == (0 - 0))) then
				if ((v109.SummonWhiteTigerStatue:IsReady() and (v114 >= (7 - 4)) and v44) or ((1050 + 1900) == (14685 - 10873))) then
					if (((16278 - 11555) >= (1748 + 570)) and (v43 == "Player")) then
						if (v24(v111.SummonWhiteTigerStatuePlayer, not v15:IsInRange(102 - 62)) or ((2715 - (364 + 324)) > (7818 - 4966))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v43 == "Cursor") or ((2725 - 1589) > (1431 + 2886))) then
						if (((19867 - 15119) == (7603 - 2855)) and v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(121 - 81))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((5004 - (1249 + 19)) <= (4279 + 461)) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(155 - 115)) or ((4476 - (686 + 400)) <= (2401 + 659))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) or ((1228 - (73 + 156)) > (13 + 2680))) then
						if (((1274 - (721 + 90)) < (7 + 594)) and v24(v111.SummonWhiteTigerStatueCursor, not v15:IsInRange(129 - 89))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((2653 - (224 + 246)) < (1112 - 425))) then
						if (((8375 - 3826) == (826 + 3723)) and v24(v111.SummonWhiteTigerStatue, not v15:IsInRange(1 + 39))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((3432 + 1240) == (9288 - 4616)) and v109.TouchofDeath:IsCastable() and v51) then
					if (v24(v109.TouchofDeath, not v15:IsInMeleeRange(16 - 11)) or ((4181 - (203 + 310)) < (2388 - (1238 + 755)))) then
						return "touch_of_death aoe 2";
					end
				end
				v136 = 1 + 0;
			end
			if ((v136 == (1535 - (709 + 825))) or ((7676 - 3510) == (662 - 207))) then
				if ((v109.JadefireStomp:IsReady() and v49) or ((5313 - (196 + 668)) == (10514 - 7851))) then
					if (v24(v109.JadefireStomp, nil) or ((8859 - 4582) < (3822 - (171 + 662)))) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v109.ChiBurst:IsCastable() and v50) or ((963 - (4 + 89)) >= (14541 - 10392))) then
					if (((806 + 1406) < (13980 - 10797)) and v24(v109.ChiBurst, not v15:IsInRange(16 + 24))) then
						return "chi_burst aoe 4";
					end
				end
				v136 = 1488 - (35 + 1451);
			end
		end
	end
	local function v123()
		local v137 = 1453 - (28 + 1425);
		while true do
			if (((6639 - (941 + 1052)) > (2869 + 123)) and (v137 == (1514 - (822 + 692)))) then
				if (((2047 - 613) < (1463 + 1643)) and v109.TouchofDeath:IsCastable() and v51) then
					if (((1083 - (45 + 252)) < (2992 + 31)) and v24(v109.TouchofDeath, not v15:IsInMeleeRange(2 + 3))) then
						return "touch_of_death st 1";
					end
				end
				if ((v109.JadefireStomp:IsReady() and v49) or ((5942 - 3500) < (507 - (114 + 319)))) then
					if (((6510 - 1975) == (5811 - 1276)) and v24(v109.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (2 - 0)) or ((6304 - 3295) <= (4068 - (556 + 1407)))) then
				if (((3036 - (741 + 465)) < (4134 - (170 + 295))) and v109.BlackoutKick:IsCastable() and (v13:BuffStack(v109.TeachingsoftheMonasteryBuff) == (2 + 1)) and (v109.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) then
					if (v24(v109.BlackoutKick, not v15:IsInMeleeRange(5 + 0)) or ((3520 - 2090) >= (2995 + 617))) then
						return "blackout_kick st 5";
					end
				end
				if (((1721 + 962) >= (1394 + 1066)) and v109.TigerPalm:IsCastable() and ((v13:BuffStack(v109.TeachingsoftheMonasteryBuff) < (1233 - (957 + 273))) or (v13:BuffRemains(v109.TeachingsoftheMonasteryBuff) < (1 + 1))) and v48) then
					if (v24(v109.TigerPalm, not v15:IsInMeleeRange(3 + 2)) or ((6874 - 5070) >= (8630 - 5355))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if ((v137 == (2 - 1)) or ((7016 - 5599) > (5409 - (389 + 1391)))) then
				if (((3009 + 1786) > (42 + 360)) and v109.RisingSunKick:IsReady() and v47) then
					if (((10957 - 6144) > (4516 - (783 + 168))) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(16 - 11))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((3848 + 64) == (4223 - (309 + 2))) and v109.ChiBurst:IsCastable() and v50) then
					if (((8662 - 5841) <= (6036 - (1090 + 122))) and v24(v109.ChiBurst, not v15:IsInRange(13 + 27))) then
						return "chi_burst st 4";
					end
				end
				v137 = 6 - 4;
			end
		end
	end
	local function v124()
		if (((1190 + 548) <= (3313 - (628 + 490))) and v52 and v109.RenewingMist:IsReady() and v17:BuffDown(v109.RenewingMistBuff) and (v109.RenewingMist:ChargesFractional() >= (1.8 + 0))) then
			if (((101 - 60) <= (13792 - 10774)) and (v17:HealthPercentage() <= v53)) then
				if (((2919 - (431 + 343)) <= (8288 - 4184)) and v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((7778 - 5089) < (3828 + 1017)) and v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.RenewingMistBuff, false, false, 4 + 21) > (1696 - (556 + 1139)))) then
			if (v24(v109.RisingSunKick, not v15:IsInMeleeRange(20 - (6 + 9))) or ((426 + 1896) > (1344 + 1278))) then
				return "RisingSunKick healing st";
			end
		end
		if ((v52 and v109.RenewingMist:IsReady() and v17:BuffDown(v109.RenewingMistBuff)) or ((4703 - (28 + 141)) == (807 + 1275))) then
			if ((v17:HealthPercentage() <= v53) or ((1938 - 367) > (1323 + 544))) then
				if (v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist)) or ((3971 - (486 + 831)) >= (7796 - 4800))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((14004 - 10026) > (398 + 1706)) and v56 and v109.Vivify:IsReady() and v13:BuffUp(v109.VivaciousVivificationBuff)) then
			if (((9469 - 6474) > (2804 - (668 + 595))) and (v17:HealthPercentage() <= v57)) then
				if (((2924 + 325) > (193 + 760)) and v24(v111.VivifyFocus, not v17:IsSpellInRange(v109.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v60 and v109.SoothingMist:IsReady() and v17:BuffDown(v109.SoothingMist)) or ((8925 - 5652) > (4863 - (23 + 267)))) then
			if ((v17:HealthPercentage() <= v61) or ((5095 - (1129 + 815)) < (1671 - (371 + 16)))) then
				if (v24(v111.SoothingMistFocus, not v17:IsSpellInRange(v109.SoothingMist)) or ((3600 - (1326 + 424)) == (2895 - 1366))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if (((939 - (88 + 30)) < (2894 - (720 + 51))) and (v138 == (0 - 0))) then
				if (((2678 - (421 + 1355)) < (3835 - 1510)) and v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.RenewingMistBuff, false, false, 13 + 12) > (1084 - (286 + 797)))) then
					if (((3136 - 2278) <= (4905 - 1943)) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(444 - (397 + 42)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v116.AreUnitsBelowHealthPercentage(v64, v63) or ((1233 + 2713) < (2088 - (24 + 776)))) then
					if ((v36 and (v13:BuffStack(v109.ManaTeaCharges) > v37) and v109.EssenceFont:IsReady() and v109.ManaTea:IsCastable()) or ((4993 - 1751) == (1352 - (222 + 563)))) then
						if (v24(v109.ManaTea, nil) or ((1865 - 1018) >= (910 + 353))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v38 and v109.ThunderFocusTea:IsReady() and (v109.EssenceFont:CooldownRemains() < v13:GCD())) or ((2443 - (23 + 167)) == (3649 - (690 + 1108)))) then
						if (v24(v109.ThunderFocusTea, nil) or ((753 + 1334) > (1957 + 415))) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if ((v62 and v109.EssenceFont:IsReady() and (v13:BuffUp(v109.ThunderFocusTea) or (v109.ThunderFocusTea:CooldownRemains() > (856 - (40 + 808))))) or ((732 + 3713) < (15865 - 11716))) then
						if (v24(v109.EssenceFont, nil) or ((1738 + 80) == (45 + 40))) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((1201 - (47 + 524)) < (1381 + 746)) and (v138 == (5 - 3))) then
				if ((v70 and v109.SheilunsGift:IsReady() and v109.SheilunsGift:IsCastable() and v116.AreUnitsBelowHealthPercentage(v72, v71)) or ((2897 - 959) == (5733 - 3219))) then
					if (((5981 - (1165 + 561)) >= (2 + 53)) and v24(v109.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((9288 - 6289) > (442 + 714)) and ((480 - (341 + 138)) == v138)) then
				if (((635 + 1715) > (2383 - 1228)) and v62 and v109.EssenceFont:IsReady() and v109.AncientTeachings:IsAvailable() and v13:BuffDown(v109.EssenceFontBuff)) then
					if (((4355 - (89 + 237)) <= (15611 - 10758)) and v24(v109.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v67 and v109.ZenPulse:IsReady() and v116.AreUnitsBelowHealthPercentage(v69, v68)) or ((1086 - 570) > (4315 - (581 + 300)))) then
					if (((5266 - (855 + 365)) >= (7203 - 4170)) and v24(v111.ZenPulseFocus, not v17:IsSpellInRange(v109.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				v138 = 1 + 1;
			end
		end
	end
	local function v126()
		if ((v58 and v109.EnvelopingMist:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.EnvelopingMist, false, false, 1260 - (1030 + 205)) < (3 + 0))) or ((2530 + 189) <= (1733 - (156 + 130)))) then
			local v221 = 0 - 0;
			while true do
				if ((v221 == (0 - 0)) or ((8466 - 4332) < (1035 + 2891))) then
					v29 = v116.FocusUnitRefreshableBuff(v109.EnvelopingMist, 2 + 0, 109 - (10 + 59), nil, false, 8 + 17);
					if (v29 or ((807 - 643) >= (3948 - (671 + 492)))) then
						return v29;
					end
					v221 = 1 + 0;
				end
				if ((v221 == (1216 - (369 + 846))) or ((139 + 386) == (1800 + 309))) then
					if (((1978 - (1036 + 909)) == (27 + 6)) and v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
			end
		end
		if (((5126 - 2072) <= (4218 - (11 + 192))) and v47 and v109.RisingSunKick:IsReady() and (v116.FriendlyUnitsWithBuffCount(v109.EnvelopingMist, false, false, 13 + 12) > (177 - (135 + 40)))) then
			if (((4533 - 2662) < (2039 + 1343)) and v24(v109.RisingSunKick, not v15:IsInMeleeRange(10 - 5))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((1938 - 645) <= (2342 - (50 + 126))) and v60 and v109.SoothingMist:IsReady() and v17:BuffUp(v109.ChiHarmonyBuff) and v17:BuffDown(v109.SoothingMist)) then
			if (v24(v111.SoothingMistFocus, not v17:IsSpellInRange(v109.SoothingMist)) or ((7181 - 4602) < (28 + 95))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v127()
		local v139 = 1413 - (1233 + 180);
		while true do
			if (((971 - (522 + 447)) == v139) or ((2267 - (107 + 1314)) >= (1099 + 1269))) then
				if ((v62 and v109.EssenceFont:IsReady() and v109.AncientTeachings:IsAvailable() and v13:BuffDown(v109.AncientTeachings)) or ((12224 - 8212) <= (1427 + 1931))) then
					if (((2966 - 1472) <= (11889 - 8884)) and v24(v109.EssenceFont, nil)) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if ((v139 == (1911 - (716 + 1194))) or ((54 + 3057) == (229 + 1905))) then
				if (((2858 - (74 + 429)) == (4543 - 2188)) and v47 and v109.RisingSunKick:IsReady()) then
					if (v24(v109.RisingSunKick, not v15:IsInMeleeRange(3 + 2)) or ((1345 - 757) <= (306 + 126))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((14788 - 9991) >= (9630 - 5735)) and v58 and v109.EnvelopingMist:IsReady() and (v13:BuffStack(v109.InvokeChiJiBuff) >= (435 - (279 + 154)))) then
					if (((4355 - (454 + 324)) == (2815 + 762)) and (v17:HealthPercentage() <= v59)) then
						if (((3811 - (12 + 5)) > (1992 + 1701)) and v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v139 = 4 - 2;
			end
			if ((v139 == (0 + 0)) or ((2368 - (277 + 816)) == (17519 - 13419))) then
				if ((v45 and v109.BlackoutKick:IsReady() and (v13:BuffStack(v109.TeachingsoftheMonastery) >= (1186 - (1058 + 125)))) or ((299 + 1292) >= (4555 - (815 + 160)))) then
					if (((4217 - 3234) <= (4291 - 2483)) and v24(v109.BlackoutKick, not v15:IsInMeleeRange(2 + 3))) then
						return "Blackout Kick ChiJi";
					end
				end
				if ((v58 and v109.EnvelopingMist:IsReady() and (v13:BuffStack(v109.InvokeChiJiBuff) == (8 - 5))) or ((4048 - (41 + 1857)) <= (3090 - (1222 + 671)))) then
					if (((9741 - 5972) >= (1685 - 512)) and (v17:HealthPercentage() <= v59)) then
						if (((2667 - (229 + 953)) == (3259 - (1111 + 663))) and v24(v111.EnvelopingMistFocus, not v17:IsSpellInRange(v109.EnvelopingMist))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v139 = 1580 - (874 + 705);
			end
		end
	end
	local function v128()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (2 + 0)) or ((6890 - 3575) <= (79 + 2703))) then
				if ((v109.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (704 - (642 + 37))) or ((200 + 676) >= (475 + 2489))) then
					v29 = v126();
					if (v29 or ((5603 - 3371) > (2951 - (233 + 221)))) then
						return v29;
					end
				end
				if ((v76 and v109.InvokeChiJiTheRedCrane:IsReady() and v109.InvokeChiJiTheRedCrane:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v78, v77)) or ((4879 - 2769) <= (293 + 39))) then
					local v231 = 1541 - (718 + 823);
					while true do
						if (((2320 + 1366) > (3977 - (266 + 539))) and (v231 == (2 - 1))) then
							if ((v109.InvokeChiJiTheRedCrane:IsReady() and (v109.RenewingMist:ChargesFractional() < (1226 - (636 + 589))) and v13:BuffUp(v109.AncientTeachings) and (v13:BuffStack(v109.TeachingsoftheMonastery) == (6 - 3)) and (v109.SheilunsGift:TimeSinceLastCast() < ((8 - 4) * v13:GCD()))) or ((3546 + 928) < (298 + 522))) then
								if (((5294 - (657 + 358)) >= (7630 - 4748)) and v24(v109.InvokeChiJiTheRedCrane, nil)) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
						if ((v231 == (0 - 0)) or ((3216 - (1151 + 36)) >= (3401 + 120))) then
							if ((v52 and v109.RenewingMist:IsReady() and (v109.RenewingMist:ChargesFractional() >= (1 + 0))) or ((6083 - 4046) >= (6474 - (1552 + 280)))) then
								local v238 = 834 - (64 + 770);
								while true do
									if (((1168 + 552) < (10119 - 5661)) and (v238 == (1 + 0))) then
										if (v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist)) or ((1679 - (157 + 1086)) > (6046 - 3025))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
									if (((3122 - 2409) <= (1299 - 452)) and (v238 == (0 - 0))) then
										v29 = v116.FocusUnitRefreshableBuff(v109.RenewingMistBuff, 825 - (599 + 220), 79 - 39, nil, false, 1956 - (1813 + 118));
										if (((1575 + 579) <= (5248 - (841 + 376))) and v29) then
											return v29;
										end
										v238 = 1 - 0;
									end
								end
							end
							if (((1073 + 3542) == (12596 - 7981)) and v70 and v109.SheilunsGift:IsReady() and (v109.SheilunsGift:TimeSinceLastCast() > (879 - (464 + 395)))) then
								if (v24(v109.SheilunsGift, nil) or ((9726 - 5936) == (241 + 259))) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v231 = 838 - (467 + 370);
						end
					end
				end
				v140 = 5 - 2;
			end
			if (((66 + 23) < (757 - 536)) and (v140 == (0 + 0))) then
				if (((4778 - 2724) >= (1941 - (150 + 370))) and v79 and v109.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) then
					if (((1974 - (74 + 1208)) < (7521 - 4463)) and v24(v111.LifeCocoonFocus, not v17:IsSpellInRange(v109.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if ((v81 and v109.Revival:IsReady() and v109.Revival:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v83, v82)) or ((15432 - 12178) == (1178 + 477))) then
					if (v24(v109.Revival, nil) or ((1686 - (14 + 376)) == (8516 - 3606))) then
						return "Revival CD";
					end
				end
				v140 = 1 + 0;
			end
			if (((2959 + 409) == (3213 + 155)) and ((2 - 1) == v140)) then
				if (((1989 + 654) < (3893 - (23 + 55))) and v81 and v109.Restoral:IsReady() and v109.Restoral:IsAvailable() and v116.AreUnitsBelowHealthPercentage(v83, v82)) then
					if (((4533 - 2620) > (329 + 164)) and v24(v109.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((4270 + 485) > (5314 - 1886)) and v73 and v109.InvokeYulonTheJadeSerpent:IsAvailable() and v109.InvokeYulonTheJadeSerpent:IsReady() and v116.AreUnitsBelowHealthPercentage(v75, v74)) then
					local v232 = 0 + 0;
					while true do
						if (((2282 - (652 + 249)) <= (6339 - 3970)) and (v232 == (1868 - (708 + 1160)))) then
							if ((v52 and v109.RenewingMist:IsReady() and (v109.RenewingMist:ChargesFractional() >= (2 - 1))) or ((8829 - 3986) == (4111 - (10 + 17)))) then
								local v239 = 0 + 0;
								while true do
									if (((6401 - (1400 + 332)) > (696 - 333)) and (v239 == (1909 - (242 + 1666)))) then
										if (v24(v111.RenewingMistFocus, not v17:IsSpellInRange(v109.RenewingMist)) or ((804 + 1073) >= (1151 + 1987))) then
											return "Renewing Mist YuLon prep";
										end
										break;
									end
									if (((4042 + 700) >= (4566 - (850 + 90))) and (v239 == (0 - 0))) then
										v29 = v116.FocusUnitRefreshableBuff(v109.RenewingMistBuff, 1396 - (360 + 1030), 36 + 4, nil, false, 70 - 45);
										if (v29 or ((6246 - 1706) == (2577 - (909 + 752)))) then
											return v29;
										end
										v239 = 1224 - (109 + 1114);
									end
								end
							end
							if ((v36 and v109.ManaTea:IsCastable() and (v13:BuffStack(v109.ManaTeaCharges) >= (5 - 2)) and v13:BuffDown(v109.ManaTeaBuff)) or ((450 + 706) > (4587 - (6 + 236)))) then
								if (((1410 + 827) < (3421 + 828)) and v24(v109.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v232 = 2 - 1;
						end
						if ((v232 == (1 - 0)) or ((3816 - (1076 + 57)) < (4 + 19))) then
							if (((1386 - (579 + 110)) <= (66 + 760)) and v70 and v109.SheilunsGift:IsReady() and (v109.SheilunsGift:TimeSinceLastCast() > (18 + 2))) then
								if (((587 + 518) <= (1583 - (174 + 233))) and v24(v109.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if (((9438 - 6059) <= (6690 - 2878)) and v109.InvokeYulonTheJadeSerpent:IsReady() and (v109.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v109.ManaTeaBuff) and (v109.SheilunsGift:TimeSinceLastCast() < ((1178 - (663 + 511)) * v13:GCD()))) then
								if (v24(v109.InvokeYulonTheJadeSerpent, nil) or ((703 + 85) >= (351 + 1265))) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
					end
				end
				v140 = 5 - 3;
			end
			if (((1123 + 731) <= (7954 - 4575)) and (v140 == (7 - 4))) then
				if (((2171 + 2378) == (8853 - 4304)) and (v109.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (18 + 7))) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (722 - (478 + 244))) or ((3539 - (440 + 77)) >= (1375 + 1649))) then
							v29 = v127();
							if (((17641 - 12821) > (3754 - (655 + 901))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v129()
		v36 = EpicSettings.Settings['UseManaTea'];
		v37 = EpicSettings.Settings['ManaTeaStacks'];
		v38 = EpicSettings.Settings['UseThunderFocusTea'];
		v39 = EpicSettings.Settings['UseFortifyingBrew'];
		v40 = EpicSettings.Settings['FortifyingBrewHP'];
		v41 = EpicSettings.Settings['UseDampenHarm'];
		v42 = EpicSettings.Settings['DampenHarmHP'];
		v43 = EpicSettings.Settings['WhiteTigerUsage'];
		v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
		v45 = EpicSettings.Settings['UseBlackoutKick'];
		v46 = EpicSettings.Settings['UseSpinningCraneKick'];
		v47 = EpicSettings.Settings['UseRisingSunKick'];
		v48 = EpicSettings.Settings['UseTigerPalm'];
		v49 = EpicSettings.Settings['UseJadefireStomp'];
		v50 = EpicSettings.Settings['UseChiBurst'];
		v51 = EpicSettings.Settings['UseTouchOfDeath'];
		v52 = EpicSettings.Settings['UseRenewingMist'];
		v53 = EpicSettings.Settings['RenewingMistHP'];
		v54 = EpicSettings.Settings['UseExpelHarm'];
		v55 = EpicSettings.Settings['ExpelHarmHP'];
		v56 = EpicSettings.Settings['UseVivify'];
		v57 = EpicSettings.Settings['VivifyHP'];
		v58 = EpicSettings.Settings['UseEnvelopingMist'];
		v59 = EpicSettings.Settings['EnvelopingMistHP'];
		v60 = EpicSettings.Settings['UseSoothingMist'];
		v61 = EpicSettings.Settings['SoothingMistHP'];
		v62 = EpicSettings.Settings['UseEssenceFont'];
		v64 = EpicSettings.Settings['EssenceFontHP'];
		v63 = EpicSettings.Settings['EssenceFontGroup'];
		v66 = EpicSettings.Settings['UseJadeSerpent'];
		v65 = EpicSettings.Settings['JadeSerpentUsage'];
		v67 = EpicSettings.Settings['UseZenPulse'];
		v69 = EpicSettings.Settings['ZenPulseHP'];
		v68 = EpicSettings.Settings['ZenPulseGroup'];
		v70 = EpicSettings.Settings['UseSheilunsGift'];
		v72 = EpicSettings.Settings['SheilunsGiftHP'];
		v71 = EpicSettings.Settings['SheilunsGiftGroup'];
	end
	local function v130()
		v96 = EpicSettings.Settings['racialsWithCD'];
		v95 = EpicSettings.Settings['useRacials'];
		v98 = EpicSettings.Settings['trinketsWithCD'];
		v97 = EpicSettings.Settings['useTrinkets'];
		v99 = EpicSettings.Settings['fightRemainsCheck'];
		v89 = EpicSettings.Settings['dispelDebuffs'];
		v86 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healingPotionHP'];
		v88 = EpicSettings.Settings['HealingPotionName'];
		v84 = EpicSettings.Settings['useHealthstone'];
		v85 = EpicSettings.Settings['healthstoneHP'];
		v92 = EpicSettings.Settings['InterruptThreshold'];
		v90 = EpicSettings.Settings['InterruptWithStun'];
		v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v93 = EpicSettings.Settings['useSpearHandStrike'];
		v94 = EpicSettings.Settings['useLegSweep'];
		v100 = EpicSettings.Settings['handleAfflicted'];
		v101 = EpicSettings.Settings['HandleIncorporeal'];
		v102 = EpicSettings.Settings['HandleChromie'];
		v104 = EpicSettings.Settings['HandleCharredBrambles'];
		v103 = EpicSettings.Settings['HandleCharredTreant'];
		v105 = EpicSettings.Settings['HandleFyrakkNPC'];
		v73 = EpicSettings.Settings['UseInvokeYulon'];
		v75 = EpicSettings.Settings['InvokeYulonHP'];
		v74 = EpicSettings.Settings['InvokeYulonGroup'];
		v76 = EpicSettings.Settings['UseInvokeChiJi'];
		v78 = EpicSettings.Settings['InvokeChiJiHP'];
		v77 = EpicSettings.Settings['InvokeChiJiGroup'];
		v79 = EpicSettings.Settings['UseLifeCocoon'];
		v80 = EpicSettings.Settings['LifeCocoonHP'];
		v81 = EpicSettings.Settings['UseRevival'];
		v83 = EpicSettings.Settings['RevivalHP'];
		v82 = EpicSettings.Settings['RevivalGroup'];
	end
	local v131 = 0 + 0;
	local function v132()
		v129();
		v130();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		if (v13:IsDeadOrGhost() or ((813 + 248) >= (3303 + 1588))) then
			return;
		end
		v113 = v13:GetEnemiesInMeleeRange(32 - 24);
		if (((2809 - (695 + 750)) <= (15273 - 10800)) and v31) then
			v114 = #v113;
		else
			v114 = 1 - 0;
		end
		if (v116.TargetIsValid() or v13:AffectingCombat() or ((14458 - 10863) <= (354 - (285 + 66)))) then
			v108 = v13:GetEnemiesInRange(93 - 53);
			v106 = v10.BossFightRemains(nil, true);
			v107 = v106;
			if ((v107 == (12421 - (682 + 628))) or ((754 + 3918) == (4151 - (176 + 123)))) then
				v107 = v10.FightRemains(v108, false);
			end
		end
		v29 = v120();
		if (((653 + 906) == (1131 + 428)) and v29) then
			return v29;
		end
		if (v13:AffectingCombat() or v30 or ((2021 - (239 + 30)) <= (215 + 573))) then
			local v222 = v89 and v109.Detox:IsReady() and v33;
			v29 = v116.FocusUnit(v222, nil, nil, nil);
			if (v29 or ((3756 + 151) == (313 - 136))) then
				return v29;
			end
			if (((10826 - 7356) > (870 - (306 + 9))) and v33 and v89) then
				if (v17 or ((3391 - 2419) == (113 + 532))) then
					if (((1953 + 1229) >= (1019 + 1096)) and v109.Detox:IsCastable() and v116.DispellableFriendlyUnit(71 - 46)) then
						local v237 = 1375 - (1140 + 235);
						while true do
							if (((2478 + 1415) < (4062 + 367)) and (v237 == (0 + 0))) then
								if ((v131 == (52 - (33 + 19))) or ((1036 + 1831) < (5709 - 3804))) then
									v131 = GetTime();
								end
								if (v116.Wait(221 + 279, v131) or ((3521 - 1725) >= (3799 + 252))) then
									local v242 = 689 - (586 + 103);
									while true do
										if (((148 + 1471) <= (11563 - 7807)) and (v242 == (1488 - (1309 + 179)))) then
											if (((1089 - 485) == (263 + 341)) and v24(v111.DetoxFocus, not v17:IsSpellInRange(v109.Detox))) then
												return "detox dispel focus";
											end
											v131 = 0 - 0;
											break;
										end
									end
								end
								break;
							end
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v116.UnitHasDispellableDebuffByPlayer(v16)) or ((3387 + 1097) == (1912 - 1012))) then
					if (v109.Detox:IsCastable() or ((8884 - 4425) <= (1722 - (295 + 314)))) then
						if (((8920 - 5288) > (5360 - (1300 + 662))) and v24(v111.DetoxMouseover, not v16:IsSpellInRange(v109.Detox))) then
							return "detox dispel mouseover";
						end
					end
				end
			end
		end
		if (((12817 - 8735) <= (6672 - (1178 + 577))) and not v13:AffectingCombat()) then
			if (((2510 + 2322) >= (4097 - 2711)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v225 = v116.DeadFriendlyUnitsCount();
				if (((1542 - (851 + 554)) == (122 + 15)) and (v225 > (2 - 1))) then
					if (v24(v109.Reawaken, nil) or ((3409 - 1839) >= (4634 - (115 + 187)))) then
						return "reawaken";
					end
				elseif (v24(v111.ResuscitateMouseover, not v15:IsInRange(31 + 9)) or ((3848 + 216) <= (7167 - 5348))) then
					return "resuscitate";
				end
			end
		end
		if ((not v13:AffectingCombat() and v30) or ((6147 - (160 + 1001)) < (1378 + 196))) then
			local v223 = 0 + 0;
			while true do
				if (((9060 - 4634) > (530 - (237 + 121))) and (v223 == (897 - (525 + 372)))) then
					v29 = v121();
					if (((1110 - 524) > (1494 - 1039)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((968 - (96 + 46)) == (1603 - (643 + 134))) and (v30 or v13:AffectingCombat())) then
			if (v34 or ((1451 + 2568) > (10648 - 6207))) then
				if (((7488 - 5471) < (4087 + 174)) and v109.SummonJadeSerpentStatue:IsReady() and v109.SummonJadeSerpentStatue:IsAvailable() and (v109.SummonJadeSerpentStatue:TimeSinceLastCast() > (176 - 86)) and v66) then
					if (((9639 - 4923) > (799 - (316 + 403))) and (v65 == "Player")) then
						if (v24(v111.SummonJadeSerpentStatuePlayer, not v15:IsInRange(27 + 13)) or ((9642 - 6135) == (1183 + 2089))) then
							return "jade serpent main player";
						end
					elseif ((v65 == "Cursor") or ((2205 - 1329) >= (2180 + 895))) then
						if (((1403 + 2949) > (8849 - 6295)) and v24(v111.SummonJadeSerpentStatueCursor, not v15:IsInRange(191 - 151))) then
							return "jade serpent main cursor";
						end
					elseif ((v65 == "Confirmation") or ((9153 - 4747) < (232 + 3811))) then
						if (v24(v109.SummonJadeSerpentStatue, not v15:IsInRange(78 - 38)) or ((93 + 1796) >= (9953 - 6570))) then
							return "jade serpent main confirmation";
						end
					end
				end
				if (((1909 - (12 + 5)) <= (10618 - 7884)) and v36 and (v13:BuffStack(v109.ManaTeaCharges) >= (38 - 20)) and v109.ManaTea:IsCastable()) then
					if (((4087 - 2164) < (5500 - 3282)) and v24(v109.ManaTea, nil)) then
						return "Mana Tea main avoid overcap";
					end
				end
				if (((442 + 1731) > (2352 - (1656 + 317))) and (v107 > v99) and v32) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (0 + 0)) or ((6889 - 4298) == (16777 - 13368))) then
							v29 = v128();
							if (((4868 - (5 + 349)) > (15788 - 12464)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (v31 or ((1479 - (266 + 1005)) >= (3182 + 1646))) then
					local v235 = 0 - 0;
					while true do
						if ((v235 == (0 - 0)) or ((3279 - (561 + 1135)) > (4648 - 1081))) then
							v29 = v125();
							if (v29 or ((4315 - 3002) == (1860 - (507 + 559)))) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v124();
				if (((7964 - 4790) > (8974 - 6072)) and v29) then
					return v29;
				end
			end
		end
		if (((4508 - (212 + 176)) <= (5165 - (250 + 655))) and (v30 or v13:AffectingCombat()) and v116.TargetIsValid() and v13:CanAttack(v15)) then
			local v224 = 0 - 0;
			while true do
				if ((v224 == (0 - 0)) or ((1381 - 498) > (6734 - (1869 + 87)))) then
					v29 = v119();
					if (v29 or ((12555 - 8935) >= (6792 - (484 + 1417)))) then
						return v29;
					end
					v224 = 2 - 1;
				end
				if (((7135 - 2877) > (1710 - (48 + 725))) and (v224 == (1 - 0))) then
					if ((v97 and ((v32 and v98) or not v98)) or ((13062 - 8193) < (527 + 379))) then
						v29 = v116.HandleTopTrinket(v112, v32, 106 - 66, nil);
						if (v29 or ((343 + 882) > (1233 + 2995))) then
							return v29;
						end
						v29 = v116.HandleBottomTrinket(v112, v32, 893 - (152 + 701), nil);
						if (((4639 - (430 + 881)) > (858 + 1380)) and v29) then
							return v29;
						end
					end
					if (((4734 - (557 + 338)) > (416 + 989)) and v35) then
						local v236 = 0 - 0;
						while true do
							if ((v236 == (0 - 0)) or ((3435 - 2142) <= (1092 - 585))) then
								if ((v95 and ((v32 and v96) or not v96) and (v107 < (819 - (499 + 302)))) or ((3762 - (39 + 827)) < (2221 - 1416))) then
									if (((5172 - 2856) == (9198 - 6882)) and v109.BloodFury:IsCastable()) then
										if (v24(v109.BloodFury, nil) or ((3945 - 1375) == (132 + 1401))) then
											return "blood_fury main 4";
										end
									end
									if (v109.Berserking:IsCastable() or ((2584 - 1701) == (234 + 1226))) then
										if (v24(v109.Berserking, nil) or ((7308 - 2689) <= (1103 - (103 + 1)))) then
											return "berserking main 6";
										end
									end
									if (v109.LightsJudgment:IsCastable() or ((3964 - (475 + 79)) > (8897 - 4781))) then
										if (v24(v109.LightsJudgment, not v15:IsInRange(128 - 88)) or ((117 + 786) >= (2693 + 366))) then
											return "lights_judgment main 8";
										end
									end
									if (v109.Fireblood:IsCastable() or ((5479 - (1395 + 108)) < (8313 - 5456))) then
										if (((6134 - (7 + 1197)) > (1006 + 1301)) and v24(v109.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (v109.AncestralCall:IsCastable() or ((1412 + 2634) < (1610 - (27 + 292)))) then
										if (v24(v109.AncestralCall, nil) or ((12427 - 8186) == (4520 - 975))) then
											return "ancestral_call main 12";
										end
									end
									if (v109.BagofTricks:IsCastable() or ((16976 - 12928) > (8345 - 4113))) then
										if (v24(v109.BagofTricks, not v15:IsInRange(76 - 36)) or ((1889 - (43 + 96)) >= (14166 - 10693))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if (((7157 - 3991) == (2628 + 538)) and v38 and v109.ThunderFocusTea:IsReady() and not v109.EssenceFont:IsAvailable() and (v109.RisingSunKick:CooldownRemains() < v13:GCD())) then
									if (((498 + 1265) < (7360 - 3636)) and v24(v109.ThunderFocusTea, nil)) then
										return "ThunderFocusTea main 16";
									end
								end
								v236 = 1 + 0;
							end
							if (((106 - 49) <= (858 + 1865)) and (v236 == (1 + 0))) then
								if (((v114 >= (1754 - (1414 + 337))) and v31) or ((4010 - (1642 + 298)) == (1154 - 711))) then
									local v240 = 0 - 0;
									while true do
										if ((v240 == (0 - 0)) or ((891 + 1814) == (1084 + 309))) then
											v29 = v122();
											if (v29 or ((5573 - (357 + 615)) < (43 + 18))) then
												return v29;
											end
											break;
										end
									end
								end
								if ((v114 < (6 - 3)) or ((1191 + 199) >= (10166 - 5422))) then
									local v241 = 0 + 0;
									while true do
										if ((v241 == (0 + 0)) or ((1259 + 744) > (5135 - (384 + 917)))) then
											v29 = v123();
											if (v29 or ((853 - (128 + 569)) > (5456 - (1407 + 136)))) then
												return v29;
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
			end
		end
	end
	local function v133()
		v118();
		v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(2157 - (687 + 1200), v132, v133);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

