local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1911 - (340 + 1571);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((3736 - (1733 + 39)) < (3682 - 2342))) then
			return v6(...);
		end
		if (((3533 - (125 + 909)) == (4447 - (1096 + 852))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((3219 - 964) < (22 + 0))) then
				return v1(v4, ...);
			end
			v5 = 513 - (409 + 103);
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
	local v112 = 11347 - (46 + 190);
	local v113 = 11206 - (51 + 44);
	local v114;
	local v115 = v18.Monk.Mistweaver;
	local v116 = v20.Monk.Mistweaver;
	local v117 = v25.Monk.Mistweaver;
	local v118 = {};
	local v119;
	local v120;
	local v121 = v22.Commons.Everyone;
	local v122 = v22.Commons.Monk;
	local function v123()
		if (v115.ImprovedDetox:IsAvailable() or ((307 + 779) >= (2722 - (1114 + 203)))) then
			v121.DispellableDebuffs = v21.MergeTable(v121.DispellableMagicDebuffs, v121.DispellablePoisonDebuffs, v121.DispellableDiseaseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		if ((v115.DampenHarm:IsCastable() and v13:BuffDown(v115.FortifyingBrew) and (v13:HealthPercentage() <= v43) and v42) or ((3095 - (228 + 498)) == (93 + 333))) then
			if (v24(v115.DampenHarm, nil) or ((1700 + 1376) > (3846 - (174 + 489)))) then
				return "dampen_harm defensives 1";
			end
		end
		if (((3131 - 1929) > (2963 - (830 + 1075))) and v115.FortifyingBrew:IsCastable() and v13:BuffDown(v115.DampenHarmBuff) and (v13:HealthPercentage() <= v41) and v40) then
			if (((4235 - (303 + 221)) > (4624 - (231 + 1038))) and v24(v115.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v115.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v56) and v55 and v13:BuffUp(v115.ChiHarmonyBuff)) or ((755 + 151) >= (3391 - (171 + 991)))) then
			if (((5308 - 4020) > (3359 - 2108)) and v24(v115.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if ((v116.Healthstone:IsReady() and v116.Healthstone:IsUsable() and v85 and (v13:HealthPercentage() <= v86)) or ((11261 - 6748) < (2683 + 669))) then
			if (v24(v117.Healthstone) or ((7238 - 5173) >= (9219 - 6023))) then
				return "healthstone defensive 4";
			end
		end
		if ((v87 and (v13:HealthPercentage() <= v88)) or ((7053 - 2677) <= (4578 - 3097))) then
			local v228 = 1248 - (111 + 1137);
			while true do
				if ((v228 == (159 - (91 + 67))) or ((10095 - 6703) >= (1183 + 3558))) then
					if (((3848 - (423 + 100)) >= (16 + 2138)) and (v89 == "Potion of Withering Dreams")) then
						if (v116.PotionOfWitheringDreams:IsReady() or ((3585 - 2290) >= (1686 + 1547))) then
							if (((5148 - (326 + 445)) > (7165 - 5523)) and v24(v117.RefreshingHealingPotion)) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
				if (((10521 - 5798) > (3164 - 1808)) and (v228 == (711 - (530 + 181)))) then
					if ((v89 == "Refreshing Healing Potion") or ((5017 - (614 + 267)) <= (3465 - (19 + 13)))) then
						if (((6908 - 2663) <= (10791 - 6160)) and v116.RefreshingHealingPotion:IsReady() and v116.RefreshingHealingPotion:IsUsable()) then
							if (((12214 - 7938) >= (1017 + 2897)) and v24(v117.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((347 - 149) <= (9052 - 4687)) and (v89 == "Dreamwalker's Healing Potion")) then
						if (((6594 - (1293 + 519)) > (9540 - 4864)) and v116.DreamwalkersHealingPotion:IsReady() and v116.DreamwalkersHealingPotion:IsUsable()) then
							if (((12699 - 7835) > (4201 - 2004)) and v24(v117.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					v228 = 4 - 3;
				end
			end
		end
	end
	local function v125()
		if (v103 or ((8716 - 5016) == (1328 + 1179))) then
			local v229 = 0 + 0;
			while true do
				if (((10395 - 5921) >= (64 + 210)) and (v229 == (0 + 0))) then
					v29 = v121.HandleIncorporeal(v115.Paralysis, v117.ParalysisMouseover, 19 + 11, true);
					if (v29 or ((2990 - (709 + 387)) <= (3264 - (673 + 1185)))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((4558 - 2986) >= (4916 - 3385)) and v102) then
			local v230 = 0 - 0;
			while true do
				if ((v230 == (1 + 0)) or ((3503 + 1184) < (6131 - 1589))) then
					if (((809 + 2482) > (3323 - 1656)) and v115.Detox:CooldownRemains()) then
						local v245 = 0 - 0;
						while true do
							if (((1880 - (446 + 1434)) == v245) or ((2156 - (1040 + 243)) == (6070 - 4036))) then
								v29 = v121.HandleAfflicted(v115.Vivify, v117.VivifyMouseover, 1877 - (559 + 1288));
								if (v29 or ((4747 - (609 + 1322)) < (465 - (13 + 441)))) then
									return v29;
								end
								break;
							end
						end
					end
					break;
				end
				if (((13822 - 10123) < (12326 - 7620)) and (v230 == (0 - 0))) then
					v29 = v121.HandleAfflicted(v115.Detox, v117.DetoxMouseover, 2 + 28);
					if (((9609 - 6963) >= (312 + 564)) and v29) then
						return v29;
					end
					v230 = 1 + 0;
				end
			end
		end
		if (((1822 - 1208) <= (1743 + 1441)) and v104) then
			v29 = v121.HandleChromie(v115.Riptide, v117.RiptideMouseover, 73 - 33);
			if (((2067 + 1059) == (1739 + 1387)) and v29) then
				return v29;
			end
			v29 = v121.HandleChromie(v115.HealingSurge, v117.HealingSurgeMouseover, 29 + 11);
			if (v29 or ((1837 + 350) >= (4847 + 107))) then
				return v29;
			end
		end
		if (v105 or ((4310 - (153 + 280)) == (10323 - 6748))) then
			v29 = v121.HandleCharredTreant(v115.RenewingMist, v117.RenewingMistMouseover, 36 + 4);
			if (((280 + 427) > (331 + 301)) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.SoothingMist, v117.SoothingMistMouseover, 37 + 3);
			if (v29 or ((396 + 150) >= (4086 - 1402))) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.Vivify, v117.VivifyMouseover, 25 + 15);
			if (((2132 - (89 + 578)) <= (3073 + 1228)) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredTreant(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 83 - 43);
			if (((2753 - (572 + 477)) > (193 + 1232)) and v29) then
				return v29;
			end
		end
		if (v106 or ((413 + 274) == (506 + 3728))) then
			v29 = v121.HandleCharredBrambles(v115.RenewingMist, v117.RenewingMistMouseover, 126 - (84 + 2));
			if (v29 or ((5488 - 2158) < (1030 + 399))) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.SoothingMist, v117.SoothingMistMouseover, 882 - (497 + 345));
			if (((30 + 1117) >= (57 + 278)) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.Vivify, v117.VivifyMouseover, 1373 - (605 + 728));
			if (((2451 + 984) > (4661 - 2564)) and v29) then
				return v29;
			end
			v29 = v121.HandleCharredBrambles(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 2 + 38);
			if (v29 or ((13938 - 10168) >= (3643 + 398))) then
				return v29;
			end
		end
		if (v107 or ((10503 - 6712) <= (1217 + 394))) then
			local v231 = 489 - (457 + 32);
			while true do
				if ((v231 == (1 + 0)) or ((5980 - (832 + 570)) <= (1892 + 116))) then
					v29 = v121.HandleFyrakkNPC(v115.SoothingMist, v117.SoothingMistMouseover, 11 + 29);
					if (((3981 - 2856) <= (1001 + 1075)) and v29) then
						return v29;
					end
					v231 = 798 - (588 + 208);
				end
				if ((v231 == (8 - 5)) or ((2543 - (884 + 916)) >= (9209 - 4810))) then
					v29 = v121.HandleFyrakkNPC(v115.EnvelopingMist, v117.EnvelopingMistMouseover, 24 + 16);
					if (((1808 - (232 + 421)) < (3562 - (1569 + 320))) and v29) then
						return v29;
					end
					break;
				end
				if (((0 + 0) == v231) or ((442 + 1882) <= (1947 - 1369))) then
					v29 = v121.HandleFyrakkNPC(v115.RenewingMist, v117.RenewingMistMouseover, 645 - (316 + 289));
					if (((9860 - 6093) == (174 + 3593)) and v29) then
						return v29;
					end
					v231 = 1454 - (666 + 787);
				end
				if (((4514 - (360 + 65)) == (3822 + 267)) and (v231 == (256 - (79 + 175)))) then
					v29 = v121.HandleFyrakkNPC(v115.Vivify, v117.VivifyMouseover, 63 - 23);
					if (((3479 + 979) >= (5131 - 3457)) and v29) then
						return v29;
					end
					v231 = 5 - 2;
				end
			end
		end
	end
	local function v126()
		if (((1871 - (503 + 396)) <= (1599 - (92 + 89))) and v115.ChiBurst:IsCastable() and v51) then
			if (v24(v115.ChiBurst, not v15:IsInRange(77 - 37)) or ((2533 + 2405) < (2819 + 1943))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v115.SpinningCraneKick:IsCastable() and v47 and (v120 >= (7 - 5))) or ((343 + 2161) > (9721 - 5457))) then
			if (((1879 + 274) == (1029 + 1124)) and v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(24 - 16))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v115.TigerPalm:IsCastable() and v49) or ((64 + 443) >= (3950 - 1359))) then
			if (((5725 - (485 + 759)) == (10368 - 5887)) and v24(v115.TigerPalm, not v15:IsInMeleeRange(1194 - (442 + 747)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v127()
		if ((v115.SummonWhiteTigerStatue:IsReady() and (v120 >= (1138 - (832 + 303))) and v45) or ((3274 - (88 + 858)) < (212 + 481))) then
			if (((3582 + 746) == (179 + 4149)) and (v44 == "Player")) then
				if (((2377 - (766 + 23)) >= (6575 - 5243)) and v24(v117.SummonWhiteTigerStatuePlayer, not v15:IsInRange(54 - 14))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v44 == "Cursor") or ((10996 - 6822) > (14417 - 10169))) then
				if (v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(1113 - (1036 + 37))) or ((3252 + 1334) <= (159 - 77))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((3039 + 824) == (5343 - (641 + 839))) and (v44 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
				if (v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(953 - (910 + 3))) or ((718 - 436) <= (1726 - (1466 + 218)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((2119 + 2490) >= (1914 - (556 + 592))) and (v44 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
				if (v24(v117.SummonWhiteTigerStatueCursor, not v15:IsInRange(15 + 25)) or ((1960 - (329 + 479)) == (3342 - (174 + 680)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((11758 - 8336) > (6943 - 3593)) and (v44 == "Confirmation")) then
				if (((627 + 250) > (1115 - (396 + 343))) and v24(v117.SummonWhiteTigerStatue, not v15:IsInRange(4 + 36))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if ((v115.TouchofDeath:IsCastable() and v52) or ((4595 - (29 + 1448)) <= (3240 - (135 + 1254)))) then
			if (v24(v115.TouchofDeath, not v15:IsInMeleeRange(18 - 13)) or ((770 - 605) >= (2328 + 1164))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((5476 - (389 + 1138)) < (5430 - (102 + 472))) and v115.JadefireStomp:IsReady() and v50) then
			if (v24(v115.JadefireStomp, not v15:IsInMeleeRange(8 + 0)) or ((2372 + 1904) < (2813 + 203))) then
				return "JadefireStomp aoe3";
			end
		end
		if (((6235 - (320 + 1225)) > (7343 - 3218)) and v115.ChiBurst:IsCastable() and v51) then
			if (v24(v115.ChiBurst, not v15:IsInRange(25 + 15)) or ((1514 - (157 + 1307)) >= (2755 - (821 + 1038)))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v115.SpinningCraneKick:IsCastable() and v47 and (v15:DebuffDown(v115.MysticTouchDebuff) or (v121.EnemiesWithDebuffCount(v115.MysticTouchDebuff) <= (v120 - (2 - 1)))) and v115.MysticTouch:IsAvailable()) or ((188 + 1526) >= (5253 - 2295))) then
			if (v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5)) or ((3695 - 2204) < (1670 - (834 + 192)))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((45 + 659) < (254 + 733)) and v115.BlackoutKick:IsCastable() and v115.AncientConcordance:IsAvailable() and v13:BuffUp(v115.JadefireStomp) and v46 and (v120 >= (1 + 2))) then
			if (((5759 - 2041) > (2210 - (300 + 4))) and v24(v115.BlackoutKick, not v15:IsInMeleeRange(2 + 3))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v115.BlackoutKick:IsCastable() and v115.TeachingsoftheMonastery:IsAvailable() and (v13:BuffStack(v115.TeachingsoftheMonasteryBuff) >= (5 - 3)) and v46) or ((1320 - (112 + 250)) > (1450 + 2185))) then
			if (((8770 - 5269) <= (2574 + 1918)) and v24(v115.BlackoutKick, not v15:IsInMeleeRange(3 + 2))) then
				return "blackout_kick aoe 8";
			end
		end
		if ((v115.TigerPalm:IsCastable() and v115.TeachingsoftheMonastery:IsAvailable() and (v115.BlackoutKick:CooldownRemains() > (0 + 0)) and v49 and (v120 >= (2 + 1))) or ((2557 + 885) < (3962 - (1001 + 413)))) then
			if (((6411 - 3536) >= (2346 - (244 + 638))) and v24(v115.TigerPalm, not v15:IsInMeleeRange(698 - (627 + 66)))) then
				return "tiger_palm aoe 7";
			end
		end
		if ((v115.SpinningCraneKick:IsCastable() and v47) or ((14293 - 9496) >= (5495 - (512 + 90)))) then
			if (v24(v115.SpinningCraneKick, not v15:IsInMeleeRange(1914 - (1665 + 241))) or ((1268 - (373 + 344)) > (933 + 1135))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v128()
		if (((560 + 1554) > (2489 - 1545)) and v115.TouchofDeath:IsCastable() and v52) then
			if (v24(v115.TouchofDeath, not v15:IsInMeleeRange(8 - 3)) or ((3361 - (35 + 1064)) >= (2253 + 843))) then
				return "touch_of_death st 1";
			end
		end
		if ((v115.JadefireStomp:IsReady() and v50) or ((4824 - 2569) >= (15 + 3522))) then
			if (v24(v115.JadefireStomp, nil) or ((5073 - (298 + 938)) < (2565 - (233 + 1026)))) then
				return "JadefireStomp st 2";
			end
		end
		if (((4616 - (636 + 1030)) == (1509 + 1441)) and v115.RisingSunKick:IsReady() and v48) then
			if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(5 + 0)) or ((1404 + 3319) < (223 + 3075))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((1357 - (55 + 166)) >= (30 + 124)) and v115.ChiBurst:IsCastable() and v51) then
			if (v24(v115.ChiBurst, not v15:IsInRange(5 + 35)) or ((1034 - 763) > (5045 - (36 + 261)))) then
				return "chi_burst st 4";
			end
		end
		if (((8289 - 3549) >= (4520 - (34 + 1334))) and v115.BlackoutKick:IsCastable() and (v13:BuffStack(v115.TeachingsoftheMonasteryBuff) >= (2 + 1)) and (v115.RisingSunKick:CooldownRemains() > v13:GCD()) and v46) then
			if (v24(v115.BlackoutKick, not v15:IsInMeleeRange(4 + 1)) or ((3861 - (1035 + 248)) >= (3411 - (20 + 1)))) then
				return "blackout_kick st 5";
			end
		end
		if (((22 + 19) <= (1980 - (134 + 185))) and v115.TigerPalm:IsCastable() and ((v13:BuffStack(v115.TeachingsoftheMonasteryBuff) < (1136 - (549 + 584))) or (v13:BuffRemains(v115.TeachingsoftheMonasteryBuff) < (687 - (314 + 371)))) and v115.TeachingsoftheMonastery:IsAvailable() and v49) then
			if (((2063 - 1462) < (4528 - (478 + 490))) and v24(v115.TigerPalm, not v15:IsInMeleeRange(3 + 2))) then
				return "tiger_palm st 6";
			end
		end
		if (((1407 - (786 + 386)) < (2225 - 1538)) and v115.BlackoutKick:IsCastable() and not v115.TeachingsoftheMonastery:IsAvailable() and v46) then
			if (((5928 - (1055 + 324)) > (2493 - (1093 + 247))) and v24(v115.BlackoutKick, not v15:IsInMeleeRange(5 + 0))) then
				return "blackout_kick st 7";
			end
		end
		if ((v115.TigerPalm:IsCastable() and v49) or ((492 + 4182) < (18548 - 13876))) then
			if (((12448 - 8780) < (12978 - 8417)) and v24(v115.TigerPalm, not v15:IsInMeleeRange(12 - 7))) then
				return "tiger_palm st 8";
			end
		end
	end
	local function v129()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (3 - 2)) or ((1568 - 1113) == (2719 + 886))) then
				if ((v53 and v115.RenewingMist:IsReady() and v17:BuffDown(v115.RenewingMistBuff)) or ((6810 - 4147) == (4000 - (364 + 324)))) then
					if (((11724 - 7447) <= (10738 - 6263)) and (v17:HealthPercentage() <= v54)) then
						if (v24(v117.RenewingMistFocus, not v17:IsSpellInRange(v115.RenewingMist)) or ((289 + 581) == (4975 - 3786))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((2487 - 934) <= (9515 - 6382)) and v57 and v115.Vivify:IsReady() and v13:BuffUp(v115.VivaciousVivificationBuff)) then
					if ((v17:HealthPercentage() <= v58) or ((3505 - (1249 + 19)) >= (3170 + 341))) then
						if (v24(v117.VivifyFocus, not v17:IsSpellInRange(v115.Vivify)) or ((5153 - 3829) > (4106 - (686 + 400)))) then
							return "Vivify instant healing st";
						end
					end
				end
				v139 = 2 + 0;
			end
			if ((v139 == (229 - (73 + 156))) or ((15 + 2977) == (2692 - (721 + 90)))) then
				if (((35 + 3071) > (4954 - 3428)) and v53 and v115.RenewingMist:IsReady() and v17:BuffDown(v115.RenewingMistBuff) and (v115.RenewingMist:ChargesFractional() >= (471.8 - (224 + 246)))) then
					if (((4896 - 1873) < (7125 - 3255)) and (v17:HealthPercentage() <= v54)) then
						if (((26 + 117) > (2 + 72)) and v24(v117.RenewingMistFocus, not v17:IsSpellInRange(v115.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((14 + 4) < (4198 - 2086)) and v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.RenewingMistBuff, false, false, 83 - 58) > (514 - (203 + 310)))) then
					if (((3090 - (1238 + 755)) <= (114 + 1514)) and v24(v115.RisingSunKick, not v15:IsInMeleeRange(1539 - (709 + 825)))) then
						return "RisingSunKick healing st";
					end
				end
				v139 = 1 - 0;
			end
			if (((6744 - 2114) == (5494 - (196 + 668))) and (v139 == (7 - 5))) then
				if (((7332 - 3792) > (3516 - (171 + 662))) and v61 and v115.SoothingMist:IsReady() and v17:BuffDown(v115.SoothingMist)) then
					if (((4887 - (4 + 89)) >= (11478 - 8203)) and (v17:HealthPercentage() <= v62)) then
						if (((541 + 943) == (6518 - 5034)) and v24(v117.SoothingMistFocus, not v17:IsSpellInRange(v115.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v140 = 0 + 0;
		while true do
			if (((2918 - (35 + 1451)) < (5008 - (28 + 1425))) and (v140 == (1994 - (941 + 1052)))) then
				if ((v68 and v115.ZenPulse:IsReady() and v121.AreUnitsBelowHealthPercentage(v70, v69, v115.EnvelopingMist)) or ((1022 + 43) > (5092 - (822 + 692)))) then
					if (v24(v117.ZenPulseFocus, not v17:IsSpellInRange(v115.ZenPulse)) or ((6845 - 2050) < (663 + 744))) then
						return "ZenPulse healing aoe";
					end
				end
				if (((2150 - (45 + 252)) < (4763 + 50)) and v71 and v115.SheilunsGift:IsReady() and v115.SheilunsGift:IsCastable() and v121.AreUnitsBelowHealthPercentage(v73, v72, v115.EnvelopingMist)) then
					if (v24(v115.SheilunsGift, nil) or ((971 + 1850) < (5916 - 3485))) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((433 - (114 + 319)) == v140) or ((4126 - 1252) < (2794 - 613))) then
				if ((v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.RenewingMistBuff, false, false, 16 + 9) > (1 - 0))) or ((5633 - 2944) <= (2306 - (556 + 1407)))) then
					if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(1211 - (741 + 465))) or ((2334 - (170 + 295)) == (1059 + 950))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v121.AreUnitsBelowHealthPercentage(v65, v64, v115.EnvelopingMist) or ((3258 + 288) < (5716 - 3394))) then
					if ((v37 and (v13:BuffStack(v115.ManaTeaCharges) > v38) and v115.EssenceFont:IsReady() and v115.ManaTea:IsCastable() and not v121.AreUnitsBelowHealthPercentage(67 + 13, 2 + 1, v115.EnvelopingMist)) or ((1179 + 903) == (6003 - (957 + 273)))) then
						if (((868 + 2376) > (423 + 632)) and v24(v115.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v39 and v115.ThunderFocusTea:IsReady() and (v115.EssenceFont:CooldownRemains() < v13:GCD())) or ((12623 - 9310) <= (4685 - 2907))) then
						if (v24(v115.ThunderFocusTea, nil) or ((4340 - 2919) >= (10418 - 8314))) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if (((3592 - (389 + 1391)) <= (2039 + 1210)) and v63 and v115.EssenceFont:IsReady() and (v13:BuffUp(v115.ThunderFocusTea) or (v115.ThunderFocusTea:CooldownRemains() > (1 + 7)))) then
						if (((3694 - 2071) <= (2908 - (783 + 168))) and v24(v115.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((14807 - 10395) == (4340 + 72)) and v63 and v115.EssenceFont:IsReady() and v115.AncientTeachings:IsAvailable() and v13:BuffDown(v115.EssenceFontBuff)) then
						if (((2061 - (309 + 2)) >= (2585 - 1743)) and v24(v115.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v140 = 1213 - (1090 + 122);
			end
		end
	end
	local function v131()
		if (((1418 + 2954) > (6213 - 4363)) and v59 and v115.EnvelopingMist:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.EnvelopingMist, false, false, 18 + 7) < (1121 - (628 + 490)))) then
			local v232 = 0 + 0;
			while true do
				if (((573 - 341) < (3751 - 2930)) and (v232 == (774 - (431 + 343)))) then
					v29 = v121.FocusUnitRefreshableBuff(v115.EnvelopingMist, 3 - 1, 115 - 75, nil, false, 20 + 5, v115.EnvelopingMist);
					if (((67 + 451) < (2597 - (556 + 1139))) and v29) then
						return v29;
					end
					v232 = 16 - (6 + 9);
				end
				if (((549 + 2445) > (440 + 418)) and (v232 == (170 - (28 + 141)))) then
					if (v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist)) or ((1455 + 2300) <= (1129 - 214))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
			end
		end
		if (((2795 + 1151) > (5060 - (486 + 831))) and v48 and v115.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v115.EnvelopingMist, false, false, 64 - 39) > (6 - 4))) then
			if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(1 + 4)) or ((4221 - 2886) >= (4569 - (668 + 595)))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((4359 + 485) > (455 + 1798)) and v61 and v115.SoothingMist:IsReady() and v17:BuffUp(v115.ChiHarmonyBuff) and v17:BuffDown(v115.SoothingMist)) then
			if (((1232 - 780) == (742 - (23 + 267))) and v24(v117.SoothingMistFocus, not v17:IsSpellInRange(v115.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v132()
		local v141 = 1944 - (1129 + 815);
		while true do
			if ((v141 == (388 - (371 + 16))) or ((6307 - (1326 + 424)) < (3952 - 1865))) then
				if (((14156 - 10282) == (3992 - (88 + 30))) and v48 and v115.RisingSunKick:IsReady()) then
					if (v24(v115.RisingSunKick, not v15:IsInMeleeRange(776 - (720 + 51))) or ((4310 - 2372) > (6711 - (421 + 1355)))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if ((v59 and v115.EnvelopingMist:IsReady() and (v13:BuffStack(v115.InvokeChiJiBuff) >= (2 - 0))) or ((2091 + 2164) < (4506 - (286 + 797)))) then
					if (((5315 - 3861) <= (4125 - 1634)) and (v17:HealthPercentage() <= v60)) then
						if (v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist)) or ((4596 - (397 + 42)) <= (876 + 1927))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v141 = 802 - (24 + 776);
			end
			if (((7476 - 2623) >= (3767 - (222 + 563))) and (v141 == (3 - 1))) then
				if (((2977 + 1157) > (3547 - (23 + 167))) and v63 and v115.EssenceFont:IsReady() and v115.AncientTeachings:IsAvailable() and v13:BuffDown(v115.AncientTeachings)) then
					if (v24(v115.EssenceFont, nil) or ((5215 - (690 + 1108)) < (915 + 1619))) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if ((v141 == (0 + 0)) or ((3570 - (40 + 808)) <= (28 + 136))) then
				if ((v46 and v115.BlackoutKick:IsReady() and (v13:BuffStack(v115.TeachingsoftheMonastery) >= (11 - 8))) or ((2302 + 106) < (1116 + 993))) then
					if (v24(v115.BlackoutKick, not v15:IsInMeleeRange(3 + 2)) or ((604 - (47 + 524)) == (945 + 510))) then
						return "Blackout Kick ChiJi";
					end
				end
				if ((v59 and v115.EnvelopingMist:IsReady() and (v13:BuffStack(v115.InvokeChiJiBuff) == (8 - 5))) or ((662 - 219) >= (9156 - 5141))) then
					if (((5108 - (1165 + 561)) > (5 + 161)) and (v17:HealthPercentage() <= v60)) then
						if (v24(v117.EnvelopingMistFocus, not v17:IsSpellInRange(v115.EnvelopingMist)) or ((867 - 587) == (1168 + 1891))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v141 = 480 - (341 + 138);
			end
		end
	end
	local function v133()
		if (((508 + 1373) > (2668 - 1375)) and v80 and v115.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v81)) then
			if (((2683 - (89 + 237)) == (7582 - 5225)) and v24(v117.LifeCocoonFocus, not v17:IsSpellInRange(v115.LifeCocoon))) then
				return "Life Cocoon CD";
			end
		end
		if (((258 - 135) == (1004 - (581 + 300))) and v82 and v115.Revival:IsReady() and v115.Revival:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v84, v83, v115.EnvelopingMist)) then
			if (v24(v115.Revival, nil) or ((2276 - (855 + 365)) >= (8056 - 4664))) then
				return "Revival CD";
			end
		end
		if ((v82 and v115.Restoral:IsReady() and v115.Restoral:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v84, v83, v115.EnvelopingMist)) or ((353 + 728) < (2310 - (1030 + 205)))) then
			if (v24(v115.Restoral, nil) or ((985 + 64) >= (4123 + 309))) then
				return "Restoral CD";
			end
		end
		if ((v74 and v115.InvokeYulonTheJadeSerpent:IsAvailable() and v115.InvokeYulonTheJadeSerpent:IsReady() and (v121.AreUnitsBelowHealthPercentage(v76, v75, v115.EnvelopingMist) or v36)) or ((5054 - (156 + 130)) <= (1922 - 1076))) then
			local v233 = 0 - 0;
			while true do
				if ((v233 == (0 - 0)) or ((885 + 2473) <= (829 + 591))) then
					if ((v37 and v115.ManaTea:IsCastable() and not v13:BuffUp(v115.ManaTeaBuff)) or ((3808 - (10 + 59)) <= (850 + 2155))) then
						if (v24(v115.ManaTea, nil) or ((8170 - 6511) >= (3297 - (671 + 492)))) then
							return "Mana Tea CD";
						end
					end
					if ((v115.InvokeYulonTheJadeSerpent:IsReady() and (v115.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v115.ManaTeaBuff) and (v115.SheilunsGift:TimeSinceLastCast() < ((1219 - (369 + 846)) * v13:GCD()))) or ((864 + 2396) < (2010 + 345))) then
						if (v24(v115.InvokeYulonTheJadeSerpent, nil) or ((2614 - (1036 + 909)) == (3358 + 865))) then
							return "Invoke Yu'lon GO";
						end
					end
					break;
				end
			end
		end
		if ((v115.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (41 - 16)) or ((1895 - (11 + 192)) < (298 + 290))) then
			v29 = v131();
			if (v29 or ((4972 - (135 + 40)) < (8845 - 5194))) then
				return v29;
			end
		end
		if ((v77 and v115.InvokeChiJiTheRedCrane:IsReady() and v115.InvokeChiJiTheRedCrane:IsAvailable() and (v121.AreUnitsBelowHealthPercentage(v79, v78, v115.EnvelopingMist) or v36)) or ((2518 + 1659) > (10684 - 5834))) then
			if ((v115.InvokeChiJiTheRedCrane:IsReady() and (v115.RenewingMist:ChargesFractional() < (1 - 0)) and v13:BuffUp(v115.AncientTeachings) and (v13:BuffStack(v115.TeachingsoftheMonastery) == (179 - (50 + 126))) and (v115.SheilunsGift:TimeSinceLastCast() < ((11 - 7) * v13:GCD()))) or ((89 + 311) > (2524 - (1233 + 180)))) then
				if (((4020 - (522 + 447)) > (2426 - (107 + 1314))) and v24(v115.InvokeChiJiTheRedCrane, nil)) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((1714 + 1979) <= (13352 - 8970)) and (v115.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (11 + 14))) then
			local v234 = 0 - 0;
			while true do
				if ((v234 == (0 - 0)) or ((5192 - (716 + 1194)) > (71 + 4029))) then
					v29 = v132();
					if (v29 or ((384 + 3196) < (3347 - (74 + 429)))) then
						return v29;
					end
					break;
				end
			end
		end
	end
	local function v134()
		v37 = EpicSettings.Settings['UseManaTea'];
		v38 = EpicSettings.Settings['ManaTeaStacks'];
		v39 = EpicSettings.Settings['UseThunderFocusTea'];
		v40 = EpicSettings.Settings['UseFortifyingBrew'];
		v41 = EpicSettings.Settings['FortifyingBrewHP'];
		v42 = EpicSettings.Settings['UseDampenHarm'];
		v43 = EpicSettings.Settings['DampenHarmHP'];
		v44 = EpicSettings.Settings['WhiteTigerUsage'];
		v45 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
		v46 = EpicSettings.Settings['UseBlackoutKick'];
		v47 = EpicSettings.Settings['UseSpinningCraneKick'];
		v48 = EpicSettings.Settings['UseRisingSunKick'];
		v49 = EpicSettings.Settings['UseTigerPalm'];
		v50 = EpicSettings.Settings['UseJadefireStomp'];
		v51 = EpicSettings.Settings['UseChiBurst'];
		v52 = EpicSettings.Settings['UseTouchOfDeath'];
		v53 = EpicSettings.Settings['UseRenewingMist'];
		v54 = EpicSettings.Settings['RenewingMistHP'];
		v55 = EpicSettings.Settings['UseExpelHarm'];
		v56 = EpicSettings.Settings['ExpelHarmHP'];
		v57 = EpicSettings.Settings['UseVivify'];
		v58 = EpicSettings.Settings['VivifyHP'];
		v59 = EpicSettings.Settings['UseEnvelopingMist'];
		v60 = EpicSettings.Settings['EnvelopingMistHP'];
		v61 = EpicSettings.Settings['UseSoothingMist'];
		v62 = EpicSettings.Settings['SoothingMistHP'];
		v63 = EpicSettings.Settings['UseEssenceFont'];
		v65 = EpicSettings.Settings['EssenceFontHP'];
		v64 = EpicSettings.Settings['EssenceFontGroup'];
		v67 = EpicSettings.Settings['UseJadeSerpent'];
		v66 = EpicSettings.Settings['JadeSerpentUsage'];
		v68 = EpicSettings.Settings['UseZenPulse'];
		v70 = EpicSettings.Settings['ZenPulseHP'];
		v69 = EpicSettings.Settings['ZenPulseGroup'];
		v71 = EpicSettings.Settings['UseSheilunsGift'];
		v73 = EpicSettings.Settings['SheilunsGiftHP'];
		v72 = EpicSettings.Settings['SheilunsGiftGroup'];
	end
	local function v135()
		v97 = EpicSettings.Settings['racialsWithCD'];
		v96 = EpicSettings.Settings['useRacials'];
		v99 = EpicSettings.Settings['trinketsWithCD'];
		v98 = EpicSettings.Settings['useTrinkets'];
		v100 = EpicSettings.Settings['fightRemainsCheck'];
		v101 = EpicSettings.Settings['useWeapon'];
		v90 = EpicSettings.Settings['dispelDebuffs'];
		v87 = EpicSettings.Settings['useHealingPotion'];
		v88 = EpicSettings.Settings['healingPotionHP'];
		v89 = EpicSettings.Settings['HealingPotionName'];
		v85 = EpicSettings.Settings['useHealthstone'];
		v86 = EpicSettings.Settings['healthstoneHP'];
		v108 = EpicSettings.Settings['useManaPotion'];
		v109 = EpicSettings.Settings['manaPotionSlider'];
		v110 = EpicSettings.Settings['RevivalBurstingGroup'];
		v111 = EpicSettings.Settings['RevivalBurstingStacks'];
		v93 = EpicSettings.Settings['InterruptThreshold'];
		v91 = EpicSettings.Settings['InterruptWithStun'];
		v92 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v94 = EpicSettings.Settings['useSpearHandStrike'];
		v95 = EpicSettings.Settings['useLegSweep'];
		v102 = EpicSettings.Settings['handleAfflicted'];
		v103 = EpicSettings.Settings['HandleIncorporeal'];
		v104 = EpicSettings.Settings['HandleChromie'];
		v106 = EpicSettings.Settings['HandleCharredBrambles'];
		v105 = EpicSettings.Settings['HandleCharredTreant'];
		v107 = EpicSettings.Settings['HandleFyrakkNPC'];
		v74 = EpicSettings.Settings['UseInvokeYulon'];
		v76 = EpicSettings.Settings['InvokeYulonHP'];
		v75 = EpicSettings.Settings['InvokeYulonGroup'];
		v77 = EpicSettings.Settings['UseInvokeChiJi'];
		v79 = EpicSettings.Settings['InvokeChiJiHP'];
		v78 = EpicSettings.Settings['InvokeChiJiGroup'];
		v80 = EpicSettings.Settings['UseLifeCocoon'];
		v81 = EpicSettings.Settings['LifeCocoonHP'];
		v82 = EpicSettings.Settings['UseRevival'];
		v84 = EpicSettings.Settings['RevivalHP'];
		v83 = EpicSettings.Settings['RevivalGroup'];
	end
	local v136 = 0 - 0;
	local function v137()
		v134();
		v135();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		v36 = EpicSettings.Toggles['ramp'];
		if (((45 + 44) < (10278 - 5788)) and v13:IsDeadOrGhost()) then
			return;
		end
		v119 = v13:GetEnemiesInMeleeRange(6 + 2);
		if (v31 or ((15361 - 10378) < (4470 - 2662))) then
			v120 = #v119;
		else
			v120 = 434 - (279 + 154);
		end
		if (((4607 - (454 + 324)) > (2966 + 803)) and (v121.TargetIsValid() or v13:AffectingCombat())) then
			local v235 = 17 - (12 + 5);
			while true do
				if (((801 + 684) <= (7399 - 4495)) and (v235 == (0 + 0))) then
					v114 = v13:GetEnemiesInRange(1133 - (277 + 816));
					v112 = v10.BossFightRemains(nil, true);
					v235 = 4 - 3;
				end
				if (((5452 - (1058 + 125)) == (801 + 3468)) and ((976 - (815 + 160)) == v235)) then
					v113 = v112;
					if (((1660 - 1273) <= (6603 - 3821)) and (v113 == (2651 + 8460))) then
						v113 = v10.FightRemains(v114, false);
					end
					break;
				end
			end
		end
		v29 = v125();
		if (v29 or ((5551 - 3652) <= (2815 - (41 + 1857)))) then
			return v29;
		end
		if (v13:AffectingCombat() or v30 or ((6205 - (1222 + 671)) <= (2263 - 1387))) then
			local v236 = 0 - 0;
			local v237;
			while true do
				if (((3414 - (229 + 953)) <= (4370 - (1111 + 663))) and (v236 == (1579 - (874 + 705)))) then
					v237 = v90 and v115.Detox:IsReady() and v33;
					v29 = v121.FocusUnit(v237, nil, 6 + 34, nil, 18 + 7, v115.EnvelopingMist);
					v236 = 1 - 0;
				end
				if (((59 + 2036) < (4365 - (642 + 37))) and (v236 == (1 + 0))) then
					if (v29 or ((256 + 1339) >= (11232 - 6758))) then
						return v29;
					end
					if ((v33 and v90) or ((5073 - (233 + 221)) < (6664 - 3782))) then
						local v246 = 0 + 0;
						while true do
							if ((v246 == (1541 - (718 + 823))) or ((186 + 108) >= (5636 - (266 + 539)))) then
								if (((5744 - 3715) <= (4309 - (636 + 589))) and v17 and v17:Exists() and v17:IsAPlayer() and (v121.UnitHasDispellableDebuffByPlayer(v17) or v121.DispellableFriendlyUnit(59 - 34) or v121.UnitHasMagicDebuff(v17) or (v115.ImprovedDetox:IsAvailable() and (v121.UnitHasDiseaseDebuff(v17) or v121.UnitHasPoisonDebuff(v17))))) then
									if (v115.Detox:IsCastable() or ((4201 - 2164) == (1918 + 502))) then
										local v247 = 0 + 0;
										while true do
											if (((5473 - (657 + 358)) > (10336 - 6432)) and (v247 == (0 - 0))) then
												if (((1623 - (1151 + 36)) >= (119 + 4)) and (v136 == (0 + 0))) then
													v136 = GetTime();
												end
												if (((1493 - 993) < (3648 - (1552 + 280))) and v121.Wait(1334 - (64 + 770), v136)) then
													if (((2427 + 1147) == (8112 - 4538)) and v24(v117.DetoxFocus, not v17:IsSpellInRange(v115.Detox))) then
														return "detox dispel focus";
													end
													v136 = 0 + 0;
												end
												break;
											end
										end
									end
								end
								if (((1464 - (157 + 1086)) < (780 - 390)) and v16 and v16:Exists() and not v13:CanAttack(v16) and (v121.UnitHasDispellableDebuffByPlayer(v16) or v121.UnitHasMagicDebuff(v16) or (v115.ImprovedDetox:IsAvailable() and (v121.UnitHasDiseaseDebuff(v16) or v121.UnitHasPoisonDebuff(v16))))) then
									if (v115.Detox:IsCastable() or ((9692 - 7479) <= (2179 - 758))) then
										if (((4173 - 1115) < (5679 - (599 + 220))) and v24(v117.DetoxMouseover, not v16:IsSpellInRange(v115.Detox))) then
											return "detox dispel mouseover";
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
		if (not v13:AffectingCombat() or ((2580 - 1284) >= (6377 - (1813 + 118)))) then
			if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1019 + 374) > (5706 - (841 + 376)))) then
				local v238 = 0 - 0;
				local v239;
				while true do
					if ((v238 == (0 + 0)) or ((12075 - 7651) < (886 - (464 + 395)))) then
						v239 = v121.DeadFriendlyUnitsCount();
						if ((v239 > (2 - 1)) or ((960 + 1037) > (4652 - (467 + 370)))) then
							if (((7160 - 3695) > (1405 + 508)) and v24(v115.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (((2512 - 1779) < (284 + 1535)) and v24(v117.ResuscitateMouseover, not v15:IsInRange(93 - 53))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if ((not v13:AffectingCombat() and v30) or ((4915 - (150 + 370)) == (6037 - (74 + 1208)))) then
			v29 = v126();
			if (v29 or ((9329 - 5536) < (11235 - 8866))) then
				return v29;
			end
		end
		if (v30 or v13:AffectingCombat() or ((2906 + 1178) == (655 - (14 + 376)))) then
			if (((7558 - 3200) == (2820 + 1538)) and v32 and v101 and (v116.Dreambinder:IsEquippedAndReady() or v116.Iridal:IsEquippedAndReady())) then
				if (v24(v117.UseWeapon, nil) or ((2757 + 381) < (948 + 45))) then
					return "Using Weapon Macro";
				end
			end
			if (((9757 - 6427) > (1748 + 575)) and v108 and v116.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v109)) then
				if (v24(v117.ManaPotion, nil) or ((3704 - (23 + 55)) == (9453 - 5464))) then
					return "Mana Potion main";
				end
			end
			if ((v13:DebuffStack(v115.Bursting) > (4 + 1)) or ((823 + 93) == (4141 - 1470))) then
				if (((86 + 186) == (1173 - (652 + 249))) and v115.DiffuseMagic:IsReady() and v115.DiffuseMagic:IsAvailable()) then
					if (((11370 - 7121) <= (6707 - (708 + 1160))) and v24(v115.DiffuseMagic, nil)) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((7537 - 4760) < (5834 - 2634)) and (v115.Bursting:MaxDebuffStack() > v111) and (v115.Bursting:AuraActiveCount() > v110)) then
				if (((122 - (10 + 17)) < (440 + 1517)) and v82 and v115.Revival:IsReady() and v115.Revival:IsAvailable()) then
					if (((2558 - (1400 + 332)) < (3292 - 1575)) and v24(v115.Revival, nil)) then
						return "Revival Bursting";
					end
				end
			end
			if (((3334 - (242 + 1666)) >= (473 + 632)) and v33 and v90) then
				if (((1010 + 1744) <= (2880 + 499)) and v115.TigersLust:IsReady() and v121.UnitHasDebuffFromList(v13, v121.DispellableRootDebuffs) and v13:CanAttack(v15)) then
					if (v24(v115.TigersLust, nil) or ((4867 - (850 + 90)) == (2474 - 1061))) then
						return "Tigers Lust Roots";
					end
				end
			end
			if (v34 or ((2544 - (360 + 1030)) <= (698 + 90))) then
				if ((v115.SummonJadeSerpentStatue:IsReady() and v115.SummonJadeSerpentStatue:IsAvailable() and (v115.SummonJadeSerpentStatue:TimeSinceLastCast() > (254 - 164)) and v67) or ((2259 - 616) > (5040 - (909 + 752)))) then
					if ((v66 == "Player") or ((4026 - (109 + 1114)) > (8328 - 3779))) then
						if (v24(v117.SummonJadeSerpentStatuePlayer, not v15:IsInRange(16 + 24)) or ((462 - (6 + 236)) >= (1904 + 1118))) then
							return "jade serpent main player";
						end
					elseif (((2272 + 550) == (6654 - 3832)) and (v66 == "Cursor")) then
						if (v24(v117.SummonJadeSerpentStatueCursor, not v15:IsInRange(69 - 29)) or ((2194 - (1076 + 57)) == (306 + 1551))) then
							return "jade serpent main cursor";
						end
					elseif (((3449 - (579 + 110)) > (108 + 1256)) and (v66 == "Confirmation")) then
						if (v24(v115.SummonJadeSerpentStatue, not v15:IsInRange(36 + 4)) or ((2602 + 2300) <= (4002 - (174 + 233)))) then
							return "jade serpent main confirmation";
						end
					end
				end
				if ((v53 and v115.RenewingMist:IsReady() and v15:BuffDown(v115.RenewingMistBuff) and not v13:CanAttack(v15)) or ((10759 - 6907) == (513 - 220))) then
					if ((v15:HealthPercentage() <= v54) or ((694 + 865) == (5762 - (663 + 511)))) then
						if (v24(v115.RenewingMist, not v15:IsSpellInRange(v115.RenewingMist)) or ((4001 + 483) == (172 + 616))) then
							return "RenewingMist main";
						end
					end
				end
				if (((14083 - 9515) >= (2366 + 1541)) and v61 and v115.SoothingMist:IsReady() and v15:BuffDown(v115.SoothingMist) and not v13:CanAttack(v15)) then
					if (((2933 - 1687) < (8400 - 4930)) and (v15:HealthPercentage() <= v62)) then
						if (((1942 + 2126) >= (1891 - 919)) and v24(v115.SoothingMist, not v15:IsSpellInRange(v115.SoothingMist))) then
							return "SoothingMist main";
						end
					end
				end
				if (((352 + 141) < (356 + 3537)) and v37 and (v13:BuffStack(v115.ManaTeaCharges) >= (740 - (478 + 244))) and v115.ManaTea:IsCastable() and not v121.AreUnitsBelowHealthPercentage(602 - (440 + 77), 2 + 1, v115.EnvelopingMist)) then
					if (v24(v115.ManaTea, nil) or ((5390 - 3917) >= (4888 - (655 + 901)))) then
						return "Mana Tea main avoid overcap";
					end
				end
				if (((v113 > v100) and v32 and v13:AffectingCombat()) or ((752 + 3299) <= (886 + 271))) then
					local v241 = 0 + 0;
					while true do
						if (((2433 - 1829) < (4326 - (695 + 750))) and (v241 == (0 - 0))) then
							v29 = v133();
							if (v29 or ((1388 - 488) == (13581 - 10204))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((4810 - (285 + 66)) > (1377 - 786)) and v31) then
					local v242 = 1310 - (682 + 628);
					while true do
						if (((548 + 2850) >= (2694 - (176 + 123))) and ((0 + 0) == v242)) then
							v29 = v130();
							if (v29 or ((1584 + 599) >= (3093 - (239 + 30)))) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v129();
				if (((527 + 1409) == (1861 + 75)) and v29) then
					return v29;
				end
			end
		end
		if (((v30 or v13:AffectingCombat()) and v121.TargetIsValid() and v13:CanAttack(v15) and not v15:IsDeadOrGhost()) or ((8551 - 3719) < (13455 - 9142))) then
			v29 = v124();
			if (((4403 - (306 + 9)) > (13518 - 9644)) and v29) then
				return v29;
			end
			if (((754 + 3578) == (2658 + 1674)) and v98 and ((v32 and v99) or not v99)) then
				local v240 = 0 + 0;
				while true do
					if (((11435 - 7436) >= (4275 - (1140 + 235))) and ((0 + 0) == v240)) then
						v29 = v121.HandleTopTrinket(v118, v32, 37 + 3, nil);
						if (v29 or ((649 + 1876) > (4116 - (33 + 19)))) then
							return v29;
						end
						v240 = 1 + 0;
					end
					if (((13100 - 8729) == (1926 + 2445)) and (v240 == (1 - 0))) then
						v29 = v121.HandleBottomTrinket(v118, v32, 38 + 2, nil);
						if (v29 or ((955 - (586 + 103)) > (454 + 4532))) then
							return v29;
						end
						break;
					end
				end
			end
			if (((6129 - 4138) >= (2413 - (1309 + 179))) and v35) then
				if (((821 - 366) < (894 + 1159)) and v96 and ((v32 and v97) or not v97) and (v113 < (48 - 30))) then
					if (v115.BloodFury:IsCastable() or ((624 + 202) == (10306 - 5455))) then
						if (((364 - 181) == (792 - (295 + 314))) and v24(v115.BloodFury, nil)) then
							return "blood_fury main 4";
						end
					end
					if (((2846 - 1687) <= (3750 - (1300 + 662))) and v115.Berserking:IsCastable()) then
						if (v24(v115.Berserking, nil) or ((11012 - 7505) > (6073 - (1178 + 577)))) then
							return "berserking main 6";
						end
					end
					if (v115.LightsJudgment:IsCastable() or ((1597 + 1478) <= (8765 - 5800))) then
						if (((2770 - (851 + 554)) <= (1779 + 232)) and v24(v115.LightsJudgment, not v15:IsInRange(110 - 70))) then
							return "lights_judgment main 8";
						end
					end
					if (v115.Fireblood:IsCastable() or ((6028 - 3252) > (3877 - (115 + 187)))) then
						if (v24(v115.Fireblood, nil) or ((1956 + 598) == (4548 + 256))) then
							return "fireblood main 10";
						end
					end
					if (((10155 - 7578) == (3738 - (160 + 1001))) and v115.AncestralCall:IsCastable()) then
						if (v24(v115.AncestralCall, nil) or ((6 + 0) >= (1304 + 585))) then
							return "ancestral_call main 12";
						end
					end
					if (((1035 - 529) <= (2250 - (237 + 121))) and v115.BagofTricks:IsCastable()) then
						if (v24(v115.BagofTricks, not v15:IsInRange(937 - (525 + 372))) or ((3806 - 1798) > (7287 - 5069))) then
							return "bag_of_tricks main 14";
						end
					end
				end
				if (((521 - (96 + 46)) <= (4924 - (643 + 134))) and v39 and v115.ThunderFocusTea:IsReady() and (not v115.EssenceFont:IsAvailable() or not v121.AreUnitsBelowHealthPercentage(v65, v64, v115.EnvelopingMist)) and (v115.RisingSunKick:CooldownRemains() < v13:GCD())) then
					if (v24(v115.ThunderFocusTea, nil) or ((1630 + 2884) <= (2419 - 1410))) then
						return "ThunderFocusTea main 16";
					end
				end
				if (((v120 >= (11 - 8)) and v31) or ((3353 + 143) == (2339 - 1147))) then
					local v243 = 0 - 0;
					while true do
						if ((v243 == (719 - (316 + 403))) or ((139 + 69) == (8135 - 5176))) then
							v29 = v127();
							if (((1546 + 2731) >= (3306 - 1993)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((1834 + 753) < (1023 + 2151)) and (v120 < (10 - 7))) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (0 - 0)) or ((236 + 3884) <= (4326 - 2128))) then
							v29 = v128();
							if (v29 or ((78 + 1518) == (2524 - 1666))) then
								return v29;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v138()
		v123();
		v115.Bursting:RegisterAuraTracking();
		v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(287 - (12 + 5), v137, v138);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

