local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((6448 - 2678) >= (4965 - (78 + 1250))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((3924 - (320 + 1225)) > (8149 - 3571))) then
			v6 = v0[v4];
			if (not v6 or ((296 + 187) > (2207 - (157 + 1307)))) then
				return v1(v4, ...);
			end
			v5 = 1860 - (821 + 1038);
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
	local v106;
	local v107;
	local v108;
	local v109;
	local v110 = 27721 - 16610;
	local v111 = 1216 + 9895;
	local v112;
	local v113 = v18.Monk.Mistweaver;
	local v114 = v20.Monk.Mistweaver;
	local v115 = v25.Monk.Mistweaver;
	local v116 = {};
	local v117;
	local v118;
	local v119 = {{v113.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v113.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v120 = v22.Commons.Everyone;
	local v121 = v22.Commons.Monk;
	local function v122()
		if (((2758 - (300 + 4)) > (155 + 423)) and v113.ImprovedDetox:IsAvailable()) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		local v139 = 0 - 0;
		local v140;
		while true do
			if (((1292 - (112 + 250)) < (1778 + 2680)) and (v139 == (0 - 0))) then
				v140 = UnitGetTotalHealAbsorbs(v17:ID());
				if (((380 + 282) <= (503 + 469)) and (v140 > (0 + 0))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v124()
		local v141 = 0 + 0;
		while true do
			if (((3247 + 1123) == (5784 - (1001 + 413))) and (v141 == (0 - 0))) then
				if ((v113.DampenHarm:IsCastable() and v13:BuffDown(v113.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((5644 - (244 + 638)) <= (1554 - (627 + 66)))) then
					if (v24(v113.DampenHarm, nil) or ((4207 - 2795) == (4866 - (512 + 90)))) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v113.FortifyingBrew:IsCastable() and v13:BuffDown(v113.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((5074 - (1665 + 241)) < (2870 - (373 + 344)))) then
					if (v24(v113.FortifyingBrew, nil) or ((2245 + 2731) < (353 + 979))) then
						return "fortifying_brew defensives 2";
					end
				end
				v141 = 2 - 1;
			end
			if (((7831 - 3203) == (5727 - (35 + 1064))) and (v141 == (1 + 0))) then
				if ((v113.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v113.ChiHarmonyBuff)) or ((115 - 61) == (2 + 393))) then
					if (((1318 - (298 + 938)) == (1341 - (233 + 1026))) and v24(v113.ExpelHarm, nil)) then
						return "expel_harm defensives 3";
					end
				end
				if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v84 and (v13:HealthPercentage() <= v85)) or ((2247 - (636 + 1030)) < (145 + 137))) then
					if (v24(v115.Healthstone) or ((4502 + 107) < (742 + 1753))) then
						return "healthstone defensive 4";
					end
				end
				v141 = 1 + 1;
			end
			if (((1373 - (55 + 166)) == (224 + 928)) and (v141 == (1 + 1))) then
				if (((7240 - 5344) <= (3719 - (36 + 261))) and v86 and (v13:HealthPercentage() <= v87)) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (1368 - (34 + 1334))) or ((381 + 609) > (1259 + 361))) then
							if ((v88 == "Refreshing Healing Potion") or ((2160 - (1035 + 248)) > (4716 - (20 + 1)))) then
								if (((1402 + 1289) >= (2170 - (134 + 185))) and v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) then
									if (v24(v115.RefreshingHealingPotion) or ((4118 - (549 + 584)) >= (5541 - (314 + 371)))) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if (((14679 - 10403) >= (2163 - (478 + 490))) and (v88 == "Dreamwalker's Healing Potion")) then
								if (((1713 + 1519) <= (5862 - (786 + 386))) and v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) then
									if (v24(v115.RefreshingHealingPotion) or ((2901 - 2005) >= (4525 - (1055 + 324)))) then
										return "dreamwalkers healing potion defensive 5";
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
	local function v125()
		if (((4401 - (1093 + 247)) >= (2629 + 329)) and v101) then
			local v156 = 0 + 0;
			while true do
				if (((12652 - 9465) >= (2185 - 1541)) and (v156 == (0 - 0))) then
					v29 = v120.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 75 - 45, true);
					if (((230 + 414) <= (2712 - 2008)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((3301 - 2343) > (715 + 232)) and v100) then
			local v157 = 0 - 0;
			while true do
				if (((5180 - (364 + 324)) >= (7275 - 4621)) and (v157 == (0 - 0))) then
					v29 = v120.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 10 + 20);
					if (((14402 - 10960) >= (2406 - 903)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (v102 or ((9627 - 6457) <= (2732 - (1249 + 19)))) then
			local v158 = 0 + 0;
			while true do
				if ((v158 == (3 - 2)) or ((5883 - (686 + 400)) == (3443 + 945))) then
					v29 = v120.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 269 - (73 + 156));
					if (((3 + 548) <= (1492 - (721 + 90))) and v29) then
						return v29;
					end
					break;
				end
				if (((37 + 3240) > (1321 - 914)) and (v158 == (470 - (224 + 246)))) then
					v29 = v120.HandleChromie(v113.Riptide, v115.RiptideMouseover, 64 - 24);
					if (((8644 - 3949) >= (257 + 1158)) and v29) then
						return v29;
					end
					v158 = 1 + 0;
				end
			end
		end
		if (v103 or ((2360 + 852) <= (1876 - 932))) then
			local v159 = 0 - 0;
			while true do
				if ((v159 == (514 - (203 + 310))) or ((5089 - (1238 + 755)) <= (126 + 1672))) then
					v29 = v120.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 1574 - (709 + 825));
					if (((6517 - 2980) == (5152 - 1615)) and v29) then
						return v29;
					end
					v159 = 866 - (196 + 668);
				end
				if (((15149 - 11312) >= (3252 - 1682)) and (v159 == (835 - (171 + 662)))) then
					v29 = v120.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 133 - (4 + 89));
					if (v29 or ((10339 - 7389) == (1389 + 2423))) then
						return v29;
					end
					v159 = 13 - 10;
				end
				if (((1853 + 2870) >= (3804 - (35 + 1451))) and (v159 == (1453 - (28 + 1425)))) then
					v29 = v120.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 2033 - (941 + 1052));
					if (v29 or ((1944 + 83) > (4366 - (822 + 692)))) then
						return v29;
					end
					v159 = 1 - 0;
				end
				if ((v159 == (2 + 1)) or ((1433 - (45 + 252)) > (4272 + 45))) then
					v29 = v120.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 14 + 26);
					if (((11555 - 6807) == (5181 - (114 + 319))) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((5363 - 1627) <= (6073 - 1333)) and v104) then
			local v160 = 0 + 0;
			while true do
				if ((v160 == (0 - 0)) or ((7102 - 3712) <= (5023 - (556 + 1407)))) then
					v29 = v120.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 1246 - (741 + 465));
					if (v29 or ((1464 - (170 + 295)) > (1419 + 1274))) then
						return v29;
					end
					v160 = 1 + 0;
				end
				if (((1139 - 676) < (499 + 102)) and (v160 == (1 + 0))) then
					v29 = v120.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 23 + 17);
					if (v29 or ((3413 - (957 + 273)) < (184 + 503))) then
						return v29;
					end
					v160 = 1 + 1;
				end
				if (((17333 - 12784) == (11987 - 7438)) and (v160 == (5 - 3))) then
					v29 = v120.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 198 - 158);
					if (((6452 - (389 + 1391)) == (2932 + 1740)) and v29) then
						return v29;
					end
					v160 = 1 + 2;
				end
				if ((v160 == (6 - 3)) or ((4619 - (783 + 168)) < (1325 - 930))) then
					v29 = v120.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 40 + 0);
					if (v29 or ((4477 - (309 + 2)) == (1397 - 942))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v105 or ((5661 - (1090 + 122)) == (864 + 1799))) then
			v29 = v120.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 134 - 94);
			if (v29 or ((2928 + 1349) < (4107 - (628 + 490)))) then
				return v29;
			end
			v29 = v120.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 8 + 32);
			if (v29 or ((2154 - 1284) >= (18960 - 14811))) then
				return v29;
			end
			v29 = v120.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 814 - (431 + 343));
			if (((4466 - 2254) < (9208 - 6025)) and v29) then
				return v29;
			end
			v29 = v120.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 32 + 8);
			if (((595 + 4051) > (4687 - (556 + 1139))) and v29) then
				return v29;
			end
		end
	end
	local function v126()
		if (((1449 - (6 + 9)) < (569 + 2537)) and v113.ChiBurst:IsCastable() and v50) then
			if (((403 + 383) < (3192 - (28 + 141))) and v24(v113.ChiBurst, not v15:IsInRange(16 + 24))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v46 and (v118 >= (2 - 0))) or ((1730 + 712) < (1391 - (486 + 831)))) then
			if (((11801 - 7266) == (15966 - 11431)) and v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(2 + 6))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v113.TigerPalm:IsCastable() and v48) or ((9514 - 6505) <= (3368 - (668 + 595)))) then
			if (((1647 + 183) < (740 + 2929)) and v24(v113.TigerPalm, not v15:IsInMeleeRange(13 - 8))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v127()
		local v142 = 290 - (23 + 267);
		while true do
			if ((v142 == (1947 - (1129 + 815))) or ((1817 - (371 + 16)) >= (5362 - (1326 + 424)))) then
				if (((5080 - 2397) >= (8989 - 6529)) and v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (118 - (88 + 30))) and v48 and (v118 >= (774 - (720 + 51)))) then
					if (v24(v113.TigerPalm, not v15:IsInMeleeRange(11 - 6)) or ((3580 - (421 + 1355)) >= (5402 - 2127))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v113.SpinningCraneKick:IsCastable() and v46) or ((697 + 720) > (4712 - (286 + 797)))) then
					if (((17528 - 12733) > (665 - 263)) and v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(447 - (397 + 42)))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((1504 + 3309) > (4365 - (24 + 776))) and (v142 == (1 - 0))) then
				if (((4697 - (222 + 563)) == (8618 - 4706)) and v113.JadefireStomp:IsReady() and v49) then
					if (((2032 + 789) <= (5014 - (23 + 167))) and v24(v113.JadefireStomp, nil)) then
						return "JadefireStomp aoe3";
					end
				end
				if (((3536 - (690 + 1108)) <= (792 + 1403)) and v113.ChiBurst:IsCastable() and v50) then
					if (((34 + 7) <= (3866 - (40 + 808))) and v24(v113.ChiBurst, not v15:IsInRange(7 + 33))) then
						return "chi_burst aoe 4";
					end
				end
				v142 = 7 - 5;
			end
			if (((2051 + 94) <= (2172 + 1932)) and ((2 + 0) == v142)) then
				if (((3260 - (47 + 524)) < (3145 + 1700)) and v113.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v113.MysticTouchDebuff) and v113.MysticTouch:IsAvailable()) then
					if (v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(21 - 13)) or ((3471 - 1149) > (5979 - 3357))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v13:BuffUp(v113.JadefireStomp) and v45 and (v118 >= (1729 - (1165 + 561)))) or ((135 + 4399) == (6448 - 4366))) then
					if (v24(v113.BlackoutKick, not v15:IsInMeleeRange(2 + 3)) or ((2050 - (341 + 138)) > (504 + 1363))) then
						return "blackout_kick aoe 6";
					end
				end
				v142 = 5 - 2;
			end
			if (((326 - (89 + 237)) == v142) or ((8537 - 5883) >= (6307 - 3311))) then
				if (((4859 - (581 + 300)) > (3324 - (855 + 365))) and v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (6 - 3)) and v44) then
					if (((978 + 2017) > (2776 - (1030 + 205))) and (v43 == "Player")) then
						if (((3051 + 198) > (887 + 66)) and v24(v115.SummonWhiteTigerStatuePlayer, not v15:IsInRange(326 - (156 + 130)))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v43 == "Cursor") or ((7436 - 4163) > (7707 - 3134))) then
						if (v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(81 - 41)) or ((831 + 2320) < (749 + 535))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) or ((1919 - (10 + 59)) == (433 + 1096))) then
						if (((4043 - 3222) < (3286 - (671 + 492))) and v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(32 + 8))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((2117 - (369 + 846)) < (616 + 1709)) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
						if (((733 + 125) <= (4907 - (1036 + 909))) and v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(32 + 8))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v43 == "Confirmation") or ((6624 - 2678) < (1491 - (11 + 192)))) then
						if (v24(v115.SummonWhiteTigerStatue, not v15:IsInRange(21 + 19)) or ((3417 - (135 + 40)) == (1373 - 806))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v113.TouchofDeath:IsCastable() and v51) or ((511 + 336) >= (2782 - 1519))) then
					if (v24(v113.TouchofDeath, not v15:IsInMeleeRange(7 - 2)) or ((2429 - (50 + 126)) == (5154 - 3303))) then
						return "touch_of_death aoe 2";
					end
				end
				v142 = 1 + 0;
			end
		end
	end
	local function v128()
		local v143 = 1413 - (1233 + 180);
		while true do
			if ((v143 == (971 - (522 + 447))) or ((3508 - (107 + 1314)) > (1101 + 1271))) then
				if ((v113.BlackoutKick:IsCastable() and (v13:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (8 - 5)) and (v113.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) or ((1888 + 2557) < (8238 - 4089))) then
					if (v24(v113.BlackoutKick, not v15:IsInMeleeRange(19 - 14)) or ((3728 - (716 + 1194)) == (2 + 83))) then
						return "blackout_kick st 5";
					end
				end
				if (((68 + 562) < (2630 - (74 + 429))) and v113.TigerPalm:IsCastable() and ((v13:BuffStack(v113.TeachingsoftheMonasteryBuff) < (5 - 2)) or (v13:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (1 + 1))) and v48) then
					if (v24(v113.TigerPalm, not v15:IsInMeleeRange(11 - 6)) or ((1372 + 566) == (7750 - 5236))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if (((10520 - 6265) >= (488 - (279 + 154))) and (v143 == (778 - (454 + 324)))) then
				if (((2360 + 639) > (1173 - (12 + 5))) and v113.TouchofDeath:IsCastable() and v51) then
					if (((1268 + 1082) > (2942 - 1787)) and v24(v113.TouchofDeath, not v15:IsInMeleeRange(2 + 3))) then
						return "touch_of_death st 1";
					end
				end
				if (((5122 - (277 + 816)) <= (20737 - 15884)) and v113.JadefireStomp:IsReady() and v49) then
					if (v24(v113.JadefireStomp, nil) or ((1699 - (1058 + 125)) > (644 + 2790))) then
						return "JadefireStomp st 2";
					end
				end
				v143 = 976 - (815 + 160);
			end
			if (((17359 - 13313) >= (7199 - 4166)) and (v143 == (1 + 0))) then
				if ((v113.RisingSunKick:IsReady() and v47) or ((7948 - 5229) <= (3345 - (41 + 1857)))) then
					if (v24(v113.RisingSunKick, not v15:IsInMeleeRange(1898 - (1222 + 671))) or ((10684 - 6550) < (5642 - 1716))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v113.ChiBurst:IsCastable() and v50) or ((1346 - (229 + 953)) >= (4559 - (1111 + 663)))) then
					if (v24(v113.ChiBurst, not v15:IsInRange(1619 - (874 + 705))) or ((74 + 451) == (1439 + 670))) then
						return "chi_burst st 4";
					end
				end
				v143 = 3 - 1;
			end
		end
	end
	local function v129()
		local v144 = 0 + 0;
		while true do
			if (((712 - (642 + 37)) == (8 + 25)) and (v144 == (1 + 1))) then
				if (((7667 - 4613) <= (4469 - (233 + 221))) and v60 and v113.SoothingMist:IsReady() and v17:BuffDown(v113.SoothingMist)) then
					if (((4326 - 2455) < (2977 + 405)) and (v17:HealthPercentage() <= v61)) then
						if (((2834 - (718 + 823)) <= (1363 + 803)) and v24(v115.SoothingMistFocus, not v17:IsSpellInRange(v113.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if ((v144 == (805 - (266 + 539))) or ((7301 - 4722) < (1348 - (636 + 589)))) then
				if ((v52 and v113.RenewingMist:IsReady() and v17:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (2.8 - 1))) or ((1744 - 898) >= (1877 + 491))) then
					if ((v17:HealthPercentage() <= v53) or ((1458 + 2554) <= (4373 - (657 + 358)))) then
						if (((3955 - 2461) <= (6846 - 3841)) and v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 1212 - (1151 + 36)) > (1 + 0))) or ((818 + 2293) == (6372 - 4238))) then
					if (((4187 - (1552 + 280)) == (3189 - (64 + 770))) and v24(v113.RisingSunKick, not v15:IsInMeleeRange(4 + 1))) then
						return "RisingSunKick healing st";
					end
				end
				v144 = 2 - 1;
			end
			if ((v144 == (1 + 0)) or ((1831 - (157 + 1086)) <= (864 - 432))) then
				if (((21009 - 16212) >= (5974 - 2079)) and v52 and v113.RenewingMist:IsReady() and v17:BuffDown(v113.RenewingMistBuff)) then
					if (((4882 - 1305) == (4396 - (599 + 220))) and (v17:HealthPercentage() <= v53)) then
						if (((7555 - 3761) > (5624 - (1813 + 118))) and v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v113.Vivify:IsReady() and v13:BuffUp(v113.VivaciousVivificationBuff)) or ((932 + 343) == (5317 - (841 + 376)))) then
					if ((v17:HealthPercentage() <= v57) or ((2229 - 638) >= (832 + 2748))) then
						if (((2683 - 1700) <= (2667 - (464 + 395))) and v24(v115.VivifyFocus, not v17:IsSpellInRange(v113.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v144 = 5 - 3;
			end
		end
	end
	local function v130()
		local v145 = 0 + 0;
		while true do
			if (((837 - (467 + 370)) == v145) or ((4443 - 2293) <= (879 + 318))) then
				if (((12920 - 9151) >= (184 + 989)) and v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 58 - 33) > (521 - (150 + 370)))) then
					if (((2767 - (74 + 1208)) == (3652 - 2167)) and v24(v113.RisingSunKick, not v15:IsInMeleeRange(23 - 18))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v120.AreUnitsBelowHealthPercentage(v64, v63) or ((2359 + 956) <= (3172 - (14 + 376)))) then
					local v243 = 0 - 0;
					while true do
						if ((v243 == (0 + 0)) or ((770 + 106) >= (2827 + 137))) then
							if ((v36 and (v13:BuffStack(v113.ManaTeaCharges) > v37) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((6539 - 4307) > (1879 + 618))) then
								if (v24(v113.ManaTea, nil) or ((2188 - (23 + 55)) <= (786 - 454))) then
									return "EssenceFont healing aoe";
								end
							end
							if (((2460 + 1226) > (2849 + 323)) and v38 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v13:GCD())) then
								if (v24(v113.ThunderFocusTea, nil) or ((6936 - 2462) < (258 + 562))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v243 = 902 - (652 + 249);
						end
						if (((11451 - 7172) >= (4750 - (708 + 1160))) and (v243 == (2 - 1))) then
							if ((v62 and v113.EssenceFont:IsReady() and (v13:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (14 - 6)))) or ((2056 - (10 + 17)) >= (791 + 2730))) then
								if (v24(v113.EssenceFont, nil) or ((3769 - (1400 + 332)) >= (8903 - 4261))) then
									return "EssenceFont healing aoe";
								end
							end
							if (((3628 - (242 + 1666)) < (1908 + 2550)) and v62 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v13:BuffDown(v113.EssenceFontBuff)) then
								if (v24(v113.EssenceFont, nil) or ((160 + 276) > (2575 + 446))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
					end
				end
				v145 = 941 - (850 + 90);
			end
			if (((1248 - 535) <= (2237 - (360 + 1030))) and (v145 == (1 + 0))) then
				if (((6079 - 3925) <= (5545 - 1514)) and v67 and v113.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68)) then
					if (((6276 - (909 + 752)) == (5838 - (109 + 1114))) and v24(v115.ZenPulseFocus, not v17:IsSpellInRange(v113.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v70 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71)) or ((6938 - 3148) == (195 + 305))) then
					if (((331 - (6 + 236)) < (140 + 81)) and v24(v113.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v131()
		if (((1654 + 400) >= (3350 - 1929)) and v58 and v113.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 43 - 18) < (1136 - (1076 + 57)))) then
			local v161 = 0 + 0;
			while true do
				if (((1381 - (579 + 110)) < (242 + 2816)) and (v161 == (0 + 0))) then
					v29 = v120.FocusUnitRefreshableBuff(v113.EnvelopingMist, 2 + 0, 447 - (174 + 233), nil, false, 69 - 44);
					if (v29 or ((5710 - 2456) == (736 + 919))) then
						return v29;
					end
					v161 = 1175 - (663 + 511);
				end
				if ((v161 == (1 + 0)) or ((282 + 1014) == (15137 - 10227))) then
					if (((2040 + 1328) == (7929 - 4561)) and v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
			end
		end
		if (((6398 - 3755) < (1821 + 1994)) and v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 48 - 23) > (2 + 0))) then
			if (((175 + 1738) > (1215 - (478 + 244))) and v24(v113.RisingSunKick, not v15:IsInMeleeRange(522 - (440 + 77)))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((2162 + 2593) > (12546 - 9118)) and v60 and v113.SoothingMist:IsReady() and v17:BuffUp(v113.ChiHarmonyBuff) and v17:BuffDown(v113.SoothingMist)) then
			if (((2937 - (655 + 901)) <= (440 + 1929)) and v24(v115.SoothingMistFocus, not v17:IsSpellInRange(v113.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v132()
		local v146 = 0 + 0;
		while true do
			if (((0 + 0) == v146) or ((19510 - 14667) == (5529 - (695 + 750)))) then
				if (((15943 - 11274) > (559 - 196)) and v45 and v113.BlackoutKick:IsReady() and (v13:BuffStack(v113.TeachingsoftheMonastery) >= (11 - 8))) then
					if (v24(v113.BlackoutKick, not v15:IsInMeleeRange(356 - (285 + 66))) or ((4374 - 2497) >= (4448 - (682 + 628)))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((765 + 3977) >= (3925 - (176 + 123))) and v58 and v113.EnvelopingMist:IsReady() and (v13:BuffStack(v113.InvokeChiJiBuff) == (2 + 1))) then
					if ((v17:HealthPercentage() <= v59) or ((3294 + 1246) == (1185 - (239 + 30)))) then
						if (v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist)) or ((315 + 841) > (4177 + 168))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v146 = 1 - 0;
			end
			if (((6979 - 4742) < (4564 - (306 + 9))) and (v146 == (6 - 4))) then
				if ((v62 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v13:BuffDown(v113.AncientTeachings)) or ((467 + 2216) < (15 + 8))) then
					if (((336 + 361) <= (2361 - 1535)) and v24(v113.EssenceFont, nil)) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if (((2480 - (1140 + 235)) <= (749 + 427)) and (v146 == (1 + 0))) then
				if (((868 + 2511) <= (3864 - (33 + 19))) and v47 and v113.RisingSunKick:IsReady()) then
					if (v24(v113.RisingSunKick, not v15:IsInMeleeRange(2 + 3)) or ((2361 - 1573) >= (712 + 904))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((3635 - 1781) <= (3169 + 210)) and v58 and v113.EnvelopingMist:IsReady() and (v13:BuffStack(v113.InvokeChiJiBuff) >= (691 - (586 + 103)))) then
					if (((415 + 4134) == (14004 - 9455)) and (v17:HealthPercentage() <= v59)) then
						if (v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist)) or ((4510 - (1309 + 179)) >= (5458 - 2434))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v146 = 1 + 1;
			end
		end
	end
	local function v133()
		local v147 = 0 - 0;
		while true do
			if (((3641 + 1179) > (4669 - 2471)) and ((0 - 0) == v147)) then
				if ((v79 and v113.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) or ((1670 - (295 + 314)) >= (12013 - 7122))) then
					if (((3326 - (1300 + 662)) <= (14045 - 9572)) and v24(v115.LifeCocoonFocus, not v17:IsSpellInRange(v113.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if ((v81 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82)) or ((5350 - (1178 + 577)) <= (2 + 1))) then
					if (v24(v113.Revival, nil) or ((13811 - 9139) == (5257 - (851 + 554)))) then
						return "Revival CD";
					end
				end
				v147 = 1 + 0;
			end
			if (((4323 - 2764) == (3385 - 1826)) and ((304 - (115 + 187)) == v147)) then
				if ((v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (20 + 5)) or ((1659 + 93) <= (3105 - 2317))) then
					local v244 = 1161 - (160 + 1001);
					while true do
						if ((v244 == (0 + 0)) or ((2696 + 1211) == (361 - 184))) then
							v29 = v131();
							if (((3828 - (237 + 121)) > (1452 - (525 + 372))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v76 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v78, v77)) or ((1842 - 870) == (2119 - 1474))) then
					local v245 = 142 - (96 + 46);
					while true do
						if (((3959 - (643 + 134)) >= (764 + 1351)) and (v245 == (2 - 1))) then
							if (((14453 - 10560) < (4248 + 181)) and v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 - 0)) and v13:BuffUp(v113.AncientTeachings) and (v13:BuffStack(v113.TeachingsoftheMonastery) == (5 - 2)) and (v113.SheilunsGift:TimeSinceLastCast() < ((723 - (316 + 403)) * v13:GCD()))) then
								if (v24(v113.InvokeChiJiTheRedCrane, nil) or ((1906 + 961) < (5237 - 3332))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
						if ((v245 == (0 + 0)) or ((4522 - 2726) >= (2871 + 1180))) then
							if (((522 + 1097) <= (13014 - 9258)) and v52 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (4 - 3))) then
								v29 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 12 - 6, 3 + 37, nil, false, 49 - 24);
								if (((30 + 574) == (1776 - 1172)) and v29) then
									return v29;
								end
								if (v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist)) or ((4501 - (12 + 5)) == (3495 - 2595))) then
									return "Renewing Mist ChiJi prep";
								end
							end
							if ((v70 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (42 - 22))) or ((9478 - 5019) <= (2760 - 1647))) then
								if (((738 + 2894) > (5371 - (1656 + 317))) and v24(v113.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v245 = 1 + 0;
						end
					end
				end
				v147 = 3 + 0;
			end
			if (((10853 - 6771) <= (24199 - 19282)) and (v147 == (357 - (5 + 349)))) then
				if (((22951 - 18119) >= (2657 - (266 + 1005))) and (v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (17 + 8))) then
					local v246 = 0 - 0;
					while true do
						if (((179 - 42) == (1833 - (561 + 1135))) and (v246 == (0 - 0))) then
							v29 = v132();
							if (v29 or ((5160 - 3590) >= (5398 - (507 + 559)))) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v147 == (2 - 1)) or ((12568 - 8504) <= (2207 - (212 + 176)))) then
				if ((v81 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82)) or ((5891 - (250 + 655)) < (4292 - 2718))) then
					if (((7733 - 3307) > (268 - 96)) and v24(v113.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((2542 - (1869 + 87)) > (1578 - 1123)) and v73 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v75, v74)) then
					if (((2727 - (484 + 1417)) == (1770 - 944)) and v52 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 - 0))) then
						local v251 = 773 - (48 + 725);
						while true do
							if ((v251 == (0 - 0)) or ((10782 - 6763) > (2581 + 1860))) then
								v29 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 15 - 9, 12 + 28, nil, false, 8 + 17);
								if (((2870 - (152 + 701)) < (5572 - (430 + 881))) and v29) then
									return v29;
								end
								v251 = 1 + 0;
							end
							if (((5611 - (557 + 338)) > (24 + 56)) and (v251 == (2 - 1))) then
								if (v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist)) or ((12280 - 8773) == (8692 - 5420))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
						end
					end
					if ((v36 and v113.ManaTea:IsCastable() and (v13:BuffStack(v113.ManaTeaCharges) >= (6 - 3)) and v13:BuffDown(v113.ManaTeaBuff)) or ((1677 - (499 + 302)) >= (3941 - (39 + 827)))) then
						if (((12013 - 7661) > (5703 - 3149)) and v24(v113.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if ((v70 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (79 - 59))) or ((6763 - 2357) < (347 + 3696))) then
						if (v24(v113.SheilunsGift, nil) or ((5528 - 3639) >= (542 + 2841))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if (((2993 - 1101) <= (2838 - (103 + 1))) and v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (555 - (475 + 79))) and v13:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((8 - 4) * v13:GCD()))) then
						if (((6153 - 4230) < (287 + 1931)) and v24(v113.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v147 = 2 + 0;
			end
		end
	end
	local function v134()
		local v148 = 1503 - (1395 + 108);
		while true do
			if (((6323 - 4150) > (1583 - (7 + 1197))) and (v148 == (1 + 0))) then
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v148 = 1 + 1;
			end
			if ((v148 == (325 - (27 + 292))) or ((7592 - 5001) == (4346 - 937))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v148 = 29 - 22;
			end
			if (((8901 - 4387) > (6330 - 3006)) and (v148 == (139 - (43 + 96)))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v148 = 4 - 3;
			end
			if ((v148 == (3 - 1)) or ((173 + 35) >= (1364 + 3464))) then
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v148 = 5 - 2;
			end
			if ((v148 == (3 + 4)) or ((2966 - 1383) > (1123 + 2444))) then
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if ((v148 == (1 + 4)) or ((3064 - (1414 + 337)) == (2734 - (1642 + 298)))) then
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v148 = 15 - 9;
			end
			if (((9131 - 5957) > (8611 - 5709)) and ((2 + 2) == v148)) then
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v148 = 4 + 1;
			end
			if (((5092 - (357 + 615)) <= (2991 + 1269)) and (v148 == (6 - 3))) then
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v148 = 4 + 0;
			end
		end
	end
	local function v135()
		local v149 = 0 - 0;
		while true do
			if ((v149 == (5 + 1)) or ((60 + 823) > (3004 + 1774))) then
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if ((v149 == (1305 - (384 + 917))) or ((4317 - (128 + 569)) >= (6434 - (1407 + 136)))) then
				v103 = EpicSettings.Settings['HandleCharredTreant'];
				v105 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v149 = 1892 - (687 + 1200);
			end
			if (((5968 - (556 + 1154)) > (3296 - 2359)) and (v149 == (97 - (9 + 86)))) then
				v107 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['RevivalBurstingGroup'];
				v109 = EpicSettings.Settings['RevivalBurstingStacks'];
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v149 = 424 - (275 + 146);
			end
			if ((v149 == (0 + 0)) or ((4933 - (29 + 35)) < (4015 - 3109))) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v149 = 2 - 1;
			end
			if (((21 - 16) == v149) or ((798 + 427) > (5240 - (53 + 959)))) then
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v81 = EpicSettings.Settings['UseRevival'];
				v83 = EpicSettings.Settings['RevivalHP'];
				v149 = 414 - (312 + 96);
			end
			if (((5775 - 2447) > (2523 - (147 + 138))) and ((902 - (813 + 86)) == v149)) then
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v94 = EpicSettings.Settings['useLegSweep'];
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleChromie'];
				v104 = EpicSettings.Settings['HandleCharredBrambles'];
				v149 = 4 + 0;
			end
			if (((7112 - 3273) > (1897 - (18 + 474))) and (v149 == (1 + 0))) then
				v86 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v85 = EpicSettings.Settings['healthstoneHP'];
				v106 = EpicSettings.Settings['useManaPotion'];
				v149 = 6 - 4;
			end
		end
	end
	local v136 = 1086 - (860 + 226);
	local function v137()
		local v150 = 303 - (121 + 182);
		while true do
			if ((v150 == (1 + 2)) or ((2533 - (988 + 252)) <= (58 + 449))) then
				v117 = v13:GetEnemiesInMeleeRange(3 + 5);
				if (v31 or ((4866 - (49 + 1921)) < (1695 - (223 + 667)))) then
					v118 = #v117;
				else
					v118 = 53 - (51 + 1);
				end
				if (((3985 - 1669) == (4959 - 2643)) and (v120.TargetIsValid() or v13:AffectingCombat())) then
					local v247 = 1125 - (146 + 979);
					while true do
						if ((v247 == (0 + 0)) or ((3175 - (311 + 294)) == (4274 - 2741))) then
							v112 = v13:GetEnemiesInRange(17 + 23);
							v110 = v10.BossFightRemains(nil, true);
							v247 = 1444 - (496 + 947);
						end
						if ((v247 == (1359 - (1233 + 125))) or ((359 + 524) == (1310 + 150))) then
							v111 = v110;
							if ((v111 == (2112 + 8999)) or ((6264 - (963 + 682)) <= (834 + 165))) then
								v111 = v10.FightRemains(v112, false);
							end
							break;
						end
					end
				end
				v150 = 1508 - (504 + 1000);
			end
			if (((1 + 0) == v150) or ((3106 + 304) > (389 + 3727))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v150 = 2 - 0;
			end
			if ((v150 == (0 + 0)) or ((526 + 377) >= (3241 - (156 + 26)))) then
				v134();
				v135();
				v30 = EpicSettings.Toggles['ooc'];
				v150 = 1 + 0;
			end
			if (((2 - 0) == v150) or ((4140 - (149 + 15)) < (3817 - (890 + 70)))) then
				v34 = EpicSettings.Toggles['healing'];
				v35 = EpicSettings.Toggles['dps'];
				if (((5047 - (39 + 78)) > (2789 - (14 + 468))) and v13:IsDeadOrGhost()) then
					return;
				end
				v150 = 6 - 3;
			end
			if (((13 - 8) == v150) or ((2088 + 1958) < (776 + 515))) then
				if (not v13:AffectingCombat() or ((901 + 3340) == (1602 + 1943))) then
					if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((1061 + 2987) > (8100 - 3868))) then
						local v252 = 0 + 0;
						local v253;
						while true do
							if ((v252 == (0 - 0)) or ((45 + 1705) >= (3524 - (12 + 39)))) then
								v253 = v120.DeadFriendlyUnitsCount();
								if (((2946 + 220) == (9799 - 6633)) and (v253 > (3 - 2))) then
									if (((523 + 1240) < (1961 + 1763)) and v24(v113.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (((144 - 87) <= (1814 + 909)) and v24(v115.ResuscitateMouseover, not v15:IsInRange(193 - 153))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v13:AffectingCombat() and v30) or ((3780 - (1596 + 114)) == (1156 - 713))) then
					v29 = v126();
					if (v29 or ((3418 - (164 + 549)) == (2831 - (1059 + 379)))) then
						return v29;
					end
				end
				if (v30 or v13:AffectingCombat() or ((5713 - 1112) < (32 + 29))) then
					local v248 = 0 + 0;
					while true do
						if ((v248 == (393 - (145 + 247))) or ((1141 + 249) >= (2193 + 2551))) then
							if (((v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) or ((5937 - 3934) > (736 + 3098))) then
								if ((v81 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) or ((135 + 21) > (6352 - 2439))) then
									if (((915 - (254 + 466)) == (755 - (544 + 16))) and v24(v113.Revival, nil)) then
										return "Revival Bursting";
									end
								end
							end
							if (((9867 - 6762) >= (2424 - (294 + 334))) and v34) then
								if (((4632 - (236 + 17)) >= (919 + 1212)) and v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (71 + 19)) and v66) then
									if (((14476 - 10632) >= (9672 - 7629)) and (v65 == "Player")) then
										if (v24(v115.SummonJadeSerpentStatuePlayer, not v15:IsInRange(21 + 19)) or ((2662 + 570) <= (3525 - (413 + 381)))) then
											return "jade serpent main player";
										end
									elseif (((207 + 4698) == (10431 - 5526)) and (v65 == "Cursor")) then
										if (v24(v115.SummonJadeSerpentStatueCursor, not v15:IsInRange(103 - 63)) or ((6106 - (582 + 1388)) >= (7515 - 3104))) then
											return "jade serpent main cursor";
										end
									elseif ((v65 == "Confirmation") or ((2118 + 840) == (4381 - (326 + 38)))) then
										if (((3632 - 2404) >= (1160 - 347)) and v24(v113.SummonJadeSerpentStatue, not v15:IsInRange(660 - (47 + 573)))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if ((v36 and (v13:BuffStack(v113.ManaTeaCharges) >= (7 + 11)) and v113.ManaTea:IsCastable()) or ((14673 - 11218) > (6573 - 2523))) then
									if (((1907 - (1269 + 395)) == (735 - (76 + 416))) and v24(v113.ManaTea, nil)) then
										return "Mana Tea main avoid overcap";
									end
								end
								if (((v111 > v99) and v32) or ((714 - (319 + 124)) > (3593 - 2021))) then
									v29 = v133();
									if (((3746 - (564 + 443)) < (9115 - 5822)) and v29) then
										return v29;
									end
								end
								if (v31 or ((4400 - (337 + 121)) < (3322 - 2188))) then
									local v257 = 0 - 0;
									while true do
										if ((v257 == (1911 - (1261 + 650))) or ((1140 + 1553) == (7924 - 2951))) then
											v29 = v130();
											if (((3963 - (772 + 1045)) == (303 + 1843)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								v29 = v129();
								if (v29 or ((2388 - (102 + 42)) == (5068 - (1524 + 320)))) then
									return v29;
								end
							end
							break;
						end
						if ((v248 == (1270 - (1049 + 221))) or ((5060 - (18 + 138)) <= (4689 - 2773))) then
							if (((1192 - (67 + 1035)) <= (1413 - (136 + 212))) and v106 and v114.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v107)) then
								if (((20405 - 15603) == (3847 + 955)) and v24(v115.ManaPotion, nil)) then
									return "Mana Potion main";
								end
							end
							if ((v13:DebuffStack(v113.Bursting) > (5 + 0)) or ((3884 - (240 + 1364)) <= (1593 - (1050 + 32)))) then
								if ((v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) or ((5984 - 4308) <= (274 + 189))) then
									if (((4924 - (331 + 724)) == (313 + 3556)) and v24(v113.DiffuseMagic, nil)) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							v248 = 645 - (269 + 375);
						end
					end
				end
				v150 = 731 - (267 + 458);
			end
			if (((361 + 797) <= (5024 - 2411)) and (v150 == (822 - (667 + 151)))) then
				v29 = v125();
				if (v29 or ((3861 - (1410 + 87)) <= (3896 - (1504 + 393)))) then
					return v29;
				end
				if (v13:AffectingCombat() or v30 or ((13304 - 8382) < (503 - 309))) then
					local v249 = 796 - (461 + 335);
					local v250;
					while true do
						if (((1 + 1) == v249) or ((3852 - (1730 + 31)) < (1698 - (728 + 939)))) then
							v29 = v120.FocusSpecifiedUnit(v120.FriendlyUnitWithHealAbsorb(141 - 101, nil, 50 - 25), 68 - 38);
							if (v29 or ((3498 - (138 + 930)) >= (4453 + 419))) then
								return v29;
							end
							break;
						end
						if (((0 + 0) == v249) or ((4089 + 681) < (7084 - 5349))) then
							v250 = v89 and v113.Detox:IsReady() and v33;
							v29 = v120.FocusUnit(v250, nil, 1806 - (459 + 1307), nil, 1895 - (474 + 1396));
							v249 = 1 - 0;
						end
						if ((v249 == (1 + 0)) or ((15 + 4424) <= (6731 - 4381))) then
							if (v29 or ((568 + 3911) < (14908 - 10442))) then
								return v29;
							end
							if (((11107 - 8560) > (1816 - (562 + 29))) and v33 and v89) then
								local v256 = 0 + 0;
								while true do
									if (((6090 - (374 + 1045)) > (2117 + 557)) and (v256 == (0 - 0))) then
										if (v17 or ((4334 - (448 + 190)) < (1075 + 2252))) then
											if ((v113.Detox:IsCastable() and v120.DispellableFriendlyUnit(12 + 13)) or ((2960 + 1582) == (11419 - 8449))) then
												local v259 = 0 - 0;
												while true do
													if (((1746 - (1307 + 187)) <= (7839 - 5862)) and (v259 == (0 - 0))) then
														if ((v136 == (0 - 0)) or ((2119 - (232 + 451)) == (3605 + 170))) then
															v136 = GetTime();
														end
														if (v120.Wait(442 + 58, v136) or ((2182 - (510 + 54)) < (1873 - 943))) then
															local v260 = 36 - (13 + 23);
															while true do
																if (((9205 - 4482) > (5966 - 1813)) and ((0 - 0) == v260)) then
																	if (v24(v115.DetoxFocus, not v17:IsSpellInRange(v113.Detox)) or ((4742 - (830 + 258)) >= (16417 - 11763))) then
																		return "detox dispel focus";
																	end
																	v136 = 0 + 0;
																	break;
																end
															end
														end
														break;
													end
												end
											end
										end
										if (((810 + 141) <= (2937 - (860 + 581))) and v16 and v16:Exists() and v16:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v16)) then
											if (v113.Detox:IsCastable() or ((6403 - 4667) == (454 + 117))) then
												if (v24(v115.DetoxMouseover, not v16:IsSpellInRange(v113.Detox)) or ((1137 - (237 + 4)) > (11207 - 6438))) then
													return "detox dispel mouseover";
												end
											end
										end
										break;
									end
								end
							end
							v249 = 4 - 2;
						end
					end
				end
				v150 = 9 - 4;
			end
			if ((v150 == (5 + 1)) or ((601 + 444) <= (3850 - 2830))) then
				if (((v30 or v13:AffectingCombat()) and v120.TargetIsValid() and v13:CanAttack(v15)) or ((498 + 662) <= (179 + 149))) then
					v29 = v124();
					if (((5234 - (85 + 1341)) > (4988 - 2064)) and v29) then
						return v29;
					end
					if (((10988 - 7097) < (5291 - (45 + 327))) and v97 and ((v32 and v98) or not v98)) then
						local v254 = 0 - 0;
						while true do
							if ((v254 == (503 - (444 + 58))) or ((971 + 1263) <= (259 + 1243))) then
								v29 = v120.HandleBottomTrinket(v116, v32, 20 + 20, nil);
								if (v29 or ((7279 - 4767) < (2164 - (64 + 1668)))) then
									return v29;
								end
								break;
							end
							if (((1973 - (1227 + 746)) == v254) or ((5680 - 3832) == (1605 - 740))) then
								v29 = v120.HandleTopTrinket(v116, v32, 534 - (415 + 79), nil);
								if (v29 or ((121 + 4561) <= (5032 - (142 + 349)))) then
									return v29;
								end
								v254 = 1 + 0;
							end
						end
					end
					if (v35 or ((4159 - 1133) >= (2011 + 2035))) then
						local v255 = 0 + 0;
						while true do
							if (((5468 - 3460) > (2502 - (1710 + 154))) and (v255 == (319 - (200 + 118)))) then
								if (((704 + 1071) <= (5652 - 2419)) and (v118 >= (4 - 1)) and v31) then
									v29 = v127();
									if (v29 or ((4037 + 506) == (1976 + 21))) then
										return v29;
									end
								end
								if ((v118 < (2 + 1)) or ((496 + 2606) < (1576 - 848))) then
									local v258 = 1250 - (363 + 887);
									while true do
										if (((602 - 257) == (1642 - 1297)) and (v258 == (0 + 0))) then
											v29 = v128();
											if (v29 or ((6614 - 3787) < (259 + 119))) then
												return v29;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v255 == (1664 - (674 + 990))) or ((997 + 2479) < (1063 + 1534))) then
								if (((4879 - 1800) < (5849 - (507 + 548))) and v95 and ((v32 and v96) or not v96) and (v111 < (855 - (289 + 548)))) then
									if (((6672 - (821 + 997)) > (4719 - (195 + 60))) and v113.BloodFury:IsCastable()) then
										if (v24(v113.BloodFury, nil) or ((1321 + 3591) == (5259 - (251 + 1250)))) then
											return "blood_fury main 4";
										end
									end
									if (((369 - 243) <= (2393 + 1089)) and v113.Berserking:IsCastable()) then
										if (v24(v113.Berserking, nil) or ((3406 - (809 + 223)) == (6382 - 2008))) then
											return "berserking main 6";
										end
									end
									if (((4729 - 3154) == (5207 - 3632)) and v113.LightsJudgment:IsCastable()) then
										if (v24(v113.LightsJudgment, not v15:IsInRange(30 + 10)) or ((1170 + 1064) == (2072 - (14 + 603)))) then
											return "lights_judgment main 8";
										end
									end
									if (v113.Fireblood:IsCastable() or ((1196 - (118 + 11)) > (288 + 1491))) then
										if (((1800 + 361) >= (2721 - 1787)) and v24(v113.Fireblood, nil)) then
											return "fireblood main 10";
										end
									end
									if (((2561 - (551 + 398)) == (1019 + 593)) and v113.AncestralCall:IsCastable()) then
										if (((1549 + 2803) >= (2303 + 530)) and v24(v113.AncestralCall, nil)) then
											return "ancestral_call main 12";
										end
									end
									if (v113.BagofTricks:IsCastable() or ((11982 - 8760) < (7080 - 4007))) then
										if (((242 + 502) <= (11679 - 8737)) and v24(v113.BagofTricks, not v15:IsInRange(12 + 28))) then
											return "bag_of_tricks main 14";
										end
									end
								end
								if ((v38 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v13:GCD())) or ((1922 - (40 + 49)) <= (5034 - 3712))) then
									if (v24(v113.ThunderFocusTea, nil) or ((3957 - (99 + 391)) <= (873 + 182))) then
										return "ThunderFocusTea main 16";
									end
								end
								v255 = 4 - 3;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v138()
		local v151 = 0 - 0;
		while true do
			if (((3450 + 91) == (9317 - 5776)) and (v151 == (1604 - (1032 + 572)))) then
				v122();
				v113.Bursting:RegisterAuraTracking();
				v151 = 418 - (203 + 214);
			end
			if ((v151 == (1818 - (568 + 1249))) or ((2783 + 774) >= (9614 - 5611))) then
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(1042 - 772, v137, v138);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

