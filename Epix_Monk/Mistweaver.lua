local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if ((v6 == (0 + 0)) or ((3175 - 2269) >= (6429 - 4200))) then
			v7 = v1[v5];
			if (((2076 - 788) > (3867 - 2616)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1249 - (111 + 1137);
		end
		if ((v6 == (159 - (91 + 67))) or ((13431 - 8918) < (837 + 2515))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Monk_Mistweaver.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Pet;
	local v16 = v13.Target;
	local v17 = v13.MouseOver;
	local v18 = v13.Focus;
	local v19 = v11.Spell;
	local v20 = v11.MultiSpell;
	local v21 = v11.Item;
	local v22 = v11.Utils;
	local v23 = EpicLib;
	local v24 = v23.Cast;
	local v25 = v23.Press;
	local v26 = v23.Macro;
	local v27 = v23.Commons.Everyone.num;
	local v28 = v23.Commons.Everyone.bool;
	local v29 = GetNumGroupMembers;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
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
	local v112;
	local v113 = 11634 - (423 + 100);
	local v114 = 78 + 11033;
	local v115;
	local v116 = v19.Monk.Mistweaver;
	local v117 = v21.Monk.Mistweaver;
	local v118 = v26.Monk.Mistweaver;
	local v119 = {};
	local v120;
	local v121;
	local v122 = v23.Commons.Everyone;
	local v123 = v23.Commons.Monk;
	local function v124()
		if (v116.ImprovedDetox:IsAvailable() or ((5717 - 3652) >= (1666 + 1530))) then
			v122.DispellableDebuffs = v22.MergeTable(v122.DispellableMagicDebuffs, v122.DispellablePoisonDebuffs, v122.DispellableDiseaseDebuffs);
		else
			v122.DispellableDebuffs = v122.DispellableMagicDebuffs;
		end
	end
	v11:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125()
		if ((v116.DampenHarm:IsCastable() and v14:BuffDown(v116.FortifyingBrew) and (v14:HealthPercentage() <= v44) and v43) or ((5147 - (326 + 445)) <= (6462 - 4981))) then
			if (v25(v116.DampenHarm, nil) or ((7556 - 4164) >= (11066 - 6325))) then
				return "dampen_harm defensives 1";
			end
		end
		if (((4036 - (530 + 181)) >= (3035 - (614 + 267))) and v116.FortifyingBrew:IsCastable() and v14:BuffDown(v116.DampenHarmBuff) and (v14:HealthPercentage() <= v42) and v41) then
			if (v25(v116.FortifyingBrew, nil) or ((1327 - (19 + 13)) >= (5261 - 2028))) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((10199 - 5822) > (4690 - 3048)) and v116.ExpelHarm:IsCastable() and (v14:HealthPercentage() <= v57) and v56 and v14:BuffUp(v116.ChiHarmonyBuff)) then
			if (((1227 + 3496) > (2384 - 1028)) and v25(v116.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if ((v117.Healthstone:IsReady() and v117.Healthstone:IsUsable() and v86 and (v14:HealthPercentage() <= v87)) or ((8577 - 4441) <= (5245 - (1293 + 519)))) then
			if (((8661 - 4416) <= (12091 - 7460)) and v25(v118.Healthstone)) then
				return "healthstone defensive 4";
			end
		end
		if (((8176 - 3900) >= (16877 - 12963)) and v88 and (v14:HealthPercentage() <= v89)) then
			local v193 = 0 - 0;
			while true do
				if (((105 + 93) <= (891 + 3474)) and (v193 == (2 - 1))) then
					if (((1106 + 3676) > (1554 + 3122)) and (v90 == "Potion of Withering Dreams")) then
						if (((3040 + 1824) > (3293 - (709 + 387))) and v117.PotionOfWitheringDreams:IsReady()) then
							if (v25(v118.RefreshingHealingPotion) or ((5558 - (673 + 1185)) == (7270 - 4763))) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
				if (((14366 - 9892) >= (450 - 176)) and (v193 == (0 + 0))) then
					if ((v90 == "Refreshing Healing Potion") or ((1416 + 478) <= (1897 - 491))) then
						if (((387 + 1185) >= (3052 - 1521)) and v117.RefreshingHealingPotion:IsReady() and v117.RefreshingHealingPotion:IsUsable()) then
							if (v25(v118.RefreshingHealingPotion) or ((9200 - 4513) < (6422 - (446 + 1434)))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((4574 - (1040 + 243)) > (4975 - 3308)) and (v90 == "Dreamwalker's Healing Potion")) then
						if ((v117.DreamwalkersHealingPotion:IsReady() and v117.DreamwalkersHealingPotion:IsUsable()) or ((2720 - (559 + 1288)) == (3965 - (609 + 1322)))) then
							if (v25(v118.RefreshingHealingPotion) or ((3270 - (13 + 441)) < (41 - 30))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					v193 = 2 - 1;
				end
			end
		end
	end
	local function v126()
		if (((18422 - 14723) < (176 + 4530)) and v104) then
			v30 = v122.HandleIncorporeal(v116.Paralysis, v118.ParalysisMouseover, 108 - 78, true);
			if (((940 + 1706) >= (384 + 492)) and v30) then
				return v30;
			end
		end
		if (((1822 - 1208) <= (1743 + 1441)) and v103) then
			local v194 = 0 - 0;
			while true do
				if (((2067 + 1059) == (1739 + 1387)) and (v194 == (0 + 0))) then
					v30 = v122.HandleAfflicted(v116.Detox, v118.DetoxMouseover, 26 + 4);
					if (v30 or ((2140 + 47) >= (5387 - (153 + 280)))) then
						return v30;
					end
					v194 = 2 - 1;
				end
				if ((v194 == (1 + 0)) or ((1531 + 2346) == (1871 + 1704))) then
					if (((642 + 65) > (458 + 174)) and v116.Detox:CooldownRemains()) then
						local v242 = 0 - 0;
						while true do
							if ((v242 == (0 + 0)) or ((1213 - (89 + 578)) >= (1918 + 766))) then
								v30 = v122.HandleAfflicted(v116.Vivify, v118.VivifyMouseover, 62 - 32);
								if (((2514 - (572 + 477)) <= (581 + 3720)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (((1023 + 681) > (171 + 1254)) and v105) then
			local v195 = 86 - (84 + 2);
			while true do
				if ((v195 == (1 - 0)) or ((495 + 192) == (5076 - (497 + 345)))) then
					v30 = v122.HandleChromie(v116.HealingSurge, v118.HealingSurgeMouseover, 2 + 38);
					if (v30 or ((563 + 2767) < (2762 - (605 + 728)))) then
						return v30;
					end
					break;
				end
				if (((819 + 328) >= (744 - 409)) and (v195 == (0 + 0))) then
					v30 = v122.HandleChromie(v116.Riptide, v118.RiptideMouseover, 147 - 107);
					if (((3097 + 338) > (5809 - 3712)) and v30) then
						return v30;
					end
					v195 = 1 + 0;
				end
			end
		end
		if (v106 or ((4259 - (457 + 32)) >= (1715 + 2326))) then
			local v196 = 1402 - (832 + 570);
			while true do
				if (((2 + 0) == v196) or ((989 + 2802) <= (5700 - 4089))) then
					v30 = v122.HandleCharredTreant(v116.Vivify, v118.VivifyMouseover, 20 + 20);
					if (v30 or ((5374 - (588 + 208)) <= (5411 - 3403))) then
						return v30;
					end
					v196 = 1803 - (884 + 916);
				end
				if (((2355 - 1230) <= (1204 + 872)) and (v196 == (654 - (232 + 421)))) then
					v30 = v122.HandleCharredTreant(v116.SoothingMist, v118.SoothingMistMouseover, 1929 - (1569 + 320));
					if (v30 or ((183 + 560) >= (836 + 3563))) then
						return v30;
					end
					v196 = 6 - 4;
				end
				if (((1760 - (316 + 289)) < (4379 - 2706)) and (v196 == (1 + 2))) then
					v30 = v122.HandleCharredTreant(v116.EnvelopingMist, v118.EnvelopingMistMouseover, 1493 - (666 + 787));
					if (v30 or ((2749 - (360 + 65)) <= (541 + 37))) then
						return v30;
					end
					break;
				end
				if (((4021 - (79 + 175)) == (5939 - 2172)) and (v196 == (0 + 0))) then
					v30 = v122.HandleCharredTreant(v116.RenewingMist, v118.RenewingMistMouseover, 122 - 82);
					if (((7874 - 3785) == (4988 - (503 + 396))) and v30) then
						return v30;
					end
					v196 = 182 - (92 + 89);
				end
			end
		end
		if (((8648 - 4190) >= (859 + 815)) and v107) then
			local v197 = 0 + 0;
			while true do
				if (((3806 - 2834) <= (194 + 1224)) and ((2 - 1) == v197)) then
					v30 = v122.HandleCharredBrambles(v116.SoothingMist, v118.SoothingMistMouseover, 35 + 5);
					if (v30 or ((2359 + 2579) < (14503 - 9741))) then
						return v30;
					end
					v197 = 1 + 1;
				end
				if ((v197 == (0 - 0)) or ((3748 - (485 + 759)) > (9866 - 5602))) then
					v30 = v122.HandleCharredBrambles(v116.RenewingMist, v118.RenewingMistMouseover, 1229 - (442 + 747));
					if (((3288 - (832 + 303)) == (3099 - (88 + 858))) and v30) then
						return v30;
					end
					v197 = 1 + 0;
				end
				if (((3 + 0) == v197) or ((21 + 486) >= (3380 - (766 + 23)))) then
					v30 = v122.HandleCharredBrambles(v116.EnvelopingMist, v118.EnvelopingMistMouseover, 197 - 157);
					if (((6128 - 1647) == (11805 - 7324)) and v30) then
						return v30;
					end
					break;
				end
				if ((v197 == (6 - 4)) or ((3401 - (1036 + 37)) < (492 + 201))) then
					v30 = v122.HandleCharredBrambles(v116.Vivify, v118.VivifyMouseover, 77 - 37);
					if (((3405 + 923) == (5808 - (641 + 839))) and v30) then
						return v30;
					end
					v197 = 916 - (910 + 3);
				end
			end
		end
		if (((4048 - 2460) >= (3016 - (1466 + 218))) and v108) then
			v30 = v122.HandleFyrakkNPC(v116.RenewingMist, v118.RenewingMistMouseover, 19 + 21);
			if (v30 or ((5322 - (556 + 592)) > (1511 + 2737))) then
				return v30;
			end
			v30 = v122.HandleFyrakkNPC(v116.SoothingMist, v118.SoothingMistMouseover, 848 - (329 + 479));
			if (v30 or ((5440 - (174 + 680)) <= (281 - 199))) then
				return v30;
			end
			v30 = v122.HandleFyrakkNPC(v116.Vivify, v118.VivifyMouseover, 82 - 42);
			if (((2759 + 1104) == (4602 - (396 + 343))) and v30) then
				return v30;
			end
			v30 = v122.HandleFyrakkNPC(v116.EnvelopingMist, v118.EnvelopingMistMouseover, 4 + 36);
			if (v30 or ((1759 - (29 + 1448)) <= (1431 - (135 + 1254)))) then
				return v30;
			end
		end
	end
	local function v127()
		if (((17362 - 12753) >= (3576 - 2810)) and v116.ChiBurst:IsCastable() and v52) then
			if (v25(v116.ChiBurst, not v16:IsInRange(27 + 13)) or ((2679 - (389 + 1138)) == (3062 - (102 + 472)))) then
				return "chi_burst precombat 4";
			end
		end
		if (((3230 + 192) > (1858 + 1492)) and v116.SpinningCraneKick:IsCastable() and v48 and (v121 >= (2 + 0))) then
			if (((2422 - (320 + 1225)) > (669 - 293)) and v25(v116.SpinningCraneKick, not v16:IsInMeleeRange(5 + 3))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v116.TigerPalm:IsCastable() and v50) or ((4582 - (157 + 1307)) <= (3710 - (821 + 1038)))) then
			if (v25(v116.TigerPalm, not v16:IsInMeleeRange(12 - 7)) or ((19 + 146) >= (6202 - 2710))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v128()
		local v140 = 0 + 0;
		while true do
			if (((9787 - 5838) < (5882 - (834 + 192))) and (v140 == (1 + 3))) then
				if ((v116.SpinningCraneKick:IsCastable() and v48) or ((1098 + 3178) < (65 + 2951))) then
					if (((7265 - 2575) > (4429 - (300 + 4))) and v25(v116.SpinningCraneKick, not v16:IsInMeleeRange(3 + 5))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if ((v140 == (5 - 3)) or ((412 - (112 + 250)) >= (358 + 538))) then
				if ((v116.SpinningCraneKick:IsCastable() and v48 and (v16:DebuffDown(v116.MysticTouchDebuff) or (v122.EnemiesWithDebuffCount(v116.MysticTouchDebuff) <= (v121 - (2 - 1)))) and v116.MysticTouch:IsAvailable()) or ((982 + 732) >= (1530 + 1428))) then
					if (v25(v116.SpinningCraneKick, not v16:IsInMeleeRange(6 + 2)) or ((740 + 751) < (479 + 165))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((2118 - (1001 + 413)) < (2200 - 1213)) and v116.BlackoutKick:IsCastable() and v116.AncientConcordance:IsAvailable() and v14:BuffUp(v116.JadefireStomp) and v47 and (v121 >= (885 - (244 + 638)))) then
					if (((4411 - (627 + 66)) > (5679 - 3773)) and v25(v116.BlackoutKick, not v16:IsInMeleeRange(607 - (512 + 90)))) then
						return "blackout_kick aoe 6";
					end
				end
				v140 = 1909 - (1665 + 241);
			end
			if ((v140 == (720 - (373 + 344))) or ((433 + 525) > (962 + 2673))) then
				if (((9234 - 5733) <= (7601 - 3109)) and v116.BlackoutKick:IsCastable() and v116.TeachingsoftheMonastery:IsAvailable() and (v14:BuffStack(v116.TeachingsoftheMonasteryBuff) >= (1101 - (35 + 1064))) and v47) then
					if (v25(v116.BlackoutKick, not v16:IsInMeleeRange(4 + 1)) or ((7364 - 3922) < (11 + 2537))) then
						return "blackout_kick aoe 8";
					end
				end
				if (((4111 - (298 + 938)) >= (2723 - (233 + 1026))) and v116.TigerPalm:IsCastable() and v116.TeachingsoftheMonastery:IsAvailable() and (v116.BlackoutKick:CooldownRemains() > (1666 - (636 + 1030))) and v50 and (v121 >= (2 + 1))) then
					if (v25(v116.TigerPalm, not v16:IsInMeleeRange(5 + 0)) or ((1426 + 3371) >= (331 + 4562))) then
						return "tiger_palm aoe 7";
					end
				end
				v140 = 225 - (55 + 166);
			end
			if ((v140 == (0 + 0)) or ((56 + 495) > (7897 - 5829))) then
				if (((2411 - (36 + 261)) > (1650 - 706)) and v116.SummonWhiteTigerStatue:IsReady() and (v121 >= (1371 - (34 + 1334))) and v46) then
					if ((v45 == "Player") or ((870 + 1392) >= (2406 + 690))) then
						if (v25(v118.SummonWhiteTigerStatuePlayer, not v16:IsInRange(1323 - (1035 + 248))) or ((2276 - (20 + 1)) >= (1843 + 1694))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v45 == "Cursor") or ((4156 - (134 + 185)) < (2439 - (549 + 584)))) then
						if (((3635 - (314 + 371)) == (10127 - 7177)) and v25(v118.SummonWhiteTigerStatueCursor, not v16:IsInRange(1008 - (478 + 490)))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((v45 == "Friendly under Cursor") and v17:Exists() and not v14:CanAttack(v17)) or ((2502 + 2221) < (4470 - (786 + 386)))) then
						if (((3679 - 2543) >= (1533 - (1055 + 324))) and v25(v118.SummonWhiteTigerStatueCursor, not v16:IsInRange(1380 - (1093 + 247)))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v45 == "Enemy under Cursor") and v17:Exists() and v14:CanAttack(v17)) or ((241 + 30) > (500 + 4248))) then
						if (((18818 - 14078) >= (10696 - 7544)) and v25(v118.SummonWhiteTigerStatueCursor, not v16:IsInRange(113 - 73))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif ((v45 == "Confirmation") or ((6478 - 3900) >= (1206 + 2184))) then
						if (((157 - 116) <= (5725 - 4064)) and v25(v118.SummonWhiteTigerStatue, not v16:IsInRange(31 + 9))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((1536 - 935) < (4248 - (364 + 324))) and v116.TouchofDeath:IsCastable() and v53) then
					if (((643 - 408) < (1648 - 961)) and v25(v116.TouchofDeath, not v16:IsInMeleeRange(2 + 3))) then
						return "touch_of_death aoe 2";
					end
				end
				v140 = 4 - 3;
			end
			if (((7284 - 2735) > (3501 - 2348)) and (v140 == (1269 - (1249 + 19)))) then
				if ((v116.JadefireStomp:IsReady() and v51) or ((4219 + 455) < (18185 - 13513))) then
					if (((4754 - (686 + 400)) < (3579 + 982)) and v25(v116.JadefireStomp, not v16:IsInMeleeRange(237 - (73 + 156)))) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v116.ChiBurst:IsCastable() and v52) or ((3 + 452) == (4416 - (721 + 90)))) then
					if (v25(v116.ChiBurst, not v16:IsInRange(1 + 39)) or ((8646 - 5983) == (3782 - (224 + 246)))) then
						return "chi_burst aoe 4";
					end
				end
				v140 = 2 - 0;
			end
		end
	end
	local function v129()
		if (((7874 - 3597) <= (812 + 3663)) and v116.TouchofDeath:IsCastable() and v53) then
			if (v25(v116.TouchofDeath, not v16:IsInMeleeRange(1 + 4)) or ((639 + 231) == (2363 - 1174))) then
				return "touch_of_death st 1";
			end
		end
		if (((5167 - 3614) <= (3646 - (203 + 310))) and v116.JadefireStomp:IsReady() and v51) then
			if (v25(v116.JadefireStomp, nil) or ((4230 - (1238 + 755)) >= (246 + 3265))) then
				return "JadefireStomp st 2";
			end
		end
		if ((v116.RisingSunKick:IsReady() and v49) or ((2858 - (709 + 825)) > (5565 - 2545))) then
			if (v25(v116.RisingSunKick, not v16:IsInMeleeRange(6 - 1)) or ((3856 - (196 + 668)) == (7426 - 5545))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((6433 - 3327) > (2359 - (171 + 662))) and v116.ChiBurst:IsCastable() and v52) then
			if (((3116 - (4 + 89)) < (13564 - 9694)) and v25(v116.ChiBurst, not v16:IsInRange(15 + 25))) then
				return "chi_burst st 4";
			end
		end
		if (((627 - 484) > (30 + 44)) and v116.BlackoutKick:IsCastable() and (v14:BuffStack(v116.TeachingsoftheMonasteryBuff) >= (1489 - (35 + 1451))) and (v116.RisingSunKick:CooldownRemains() > v14:GCD()) and v47) then
			if (((1471 - (28 + 1425)) < (4105 - (941 + 1052))) and v25(v116.BlackoutKick, not v16:IsInMeleeRange(5 + 0))) then
				return "blackout_kick st 5";
			end
		end
		if (((2611 - (822 + 692)) <= (2323 - 695)) and v116.TigerPalm:IsCastable() and ((v14:BuffStack(v116.TeachingsoftheMonasteryBuff) < (2 + 1)) or (v14:BuffRemains(v116.TeachingsoftheMonasteryBuff) < (299 - (45 + 252)))) and v116.TeachingsoftheMonastery:IsAvailable() and v50) then
			if (((4582 + 48) == (1594 + 3036)) and v25(v116.TigerPalm, not v16:IsInMeleeRange(12 - 7))) then
				return "tiger_palm st 6";
			end
		end
		if (((3973 - (114 + 319)) > (3851 - 1168)) and v116.BlackoutKick:IsCastable() and not v116.TeachingsoftheMonastery:IsAvailable() and v47) then
			if (((6142 - 1348) >= (2088 + 1187)) and v25(v116.BlackoutKick, not v16:IsInMeleeRange(7 - 2))) then
				return "blackout_kick st 7";
			end
		end
		if (((3109 - 1625) == (3447 - (556 + 1407))) and v116.TigerPalm:IsCastable() and v50) then
			if (((2638 - (741 + 465)) < (4020 - (170 + 295))) and v25(v116.TigerPalm, not v16:IsInMeleeRange(3 + 2))) then
				return "tiger_palm st 8";
			end
		end
	end
	local function v130()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (2 - 1)) or ((883 + 182) > (2295 + 1283))) then
				if ((v54 and v116.RenewingMist:IsReady() and v18:BuffDown(v116.RenewingMistBuff)) or ((2716 + 2079) < (2637 - (957 + 273)))) then
					if (((496 + 1357) < (1927 + 2886)) and (v18:HealthPercentage() <= v55)) then
						if (v25(v118.RenewingMistFocus, not v18:IsSpellInRange(v116.RenewingMist)) or ((10749 - 7928) < (6406 - 3975))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v58 and v116.Vivify:IsReady() and v14:BuffUp(v116.VivaciousVivificationBuff)) or ((8778 - 5904) < (10799 - 8618))) then
					if ((v18:HealthPercentage() <= v59) or ((4469 - (389 + 1391)) <= (216 + 127))) then
						if (v25(v118.VivifyFocus, not v18:IsSpellInRange(v116.Vivify)) or ((195 + 1674) == (4573 - 2564))) then
							return "Vivify instant healing st";
						end
					end
				end
				v141 = 953 - (783 + 168);
			end
			if ((v141 == (0 - 0)) or ((3488 + 58) < (2633 - (309 + 2)))) then
				if ((v54 and v116.RenewingMist:IsReady() and v18:BuffDown(v116.RenewingMistBuff) and (v116.RenewingMist:ChargesFractional() >= (2.8 - 1))) or ((3294 - (1090 + 122)) == (1548 + 3225))) then
					if (((10894 - 7650) > (723 + 332)) and (v18:HealthPercentage() <= v55)) then
						if (v25(v118.RenewingMistFocus, not v18:IsSpellInRange(v116.RenewingMist)) or ((4431 - (628 + 490)) <= (319 + 1459))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v49 and v116.RisingSunKick:IsReady() and (v122.FriendlyUnitsWithBuffCount(v116.RenewingMistBuff, false, false, 61 - 36) > (4 - 3))) or ((2195 - (431 + 343)) >= (4248 - 2144))) then
					if (((5241 - 3429) <= (2567 + 682)) and v25(v116.RisingSunKick, not v16:IsInMeleeRange(1 + 4))) then
						return "RisingSunKick healing st";
					end
				end
				v141 = 1696 - (556 + 1139);
			end
			if (((1638 - (6 + 9)) <= (359 + 1598)) and (v141 == (2 + 0))) then
				if (((4581 - (28 + 141)) == (1709 + 2703)) and v62 and v116.SoothingMist:IsReady() and v18:BuffDown(v116.SoothingMist)) then
					if (((2160 - 410) >= (597 + 245)) and (v18:HealthPercentage() <= v63)) then
						if (((5689 - (486 + 831)) > (4814 - 2964)) and v25(v118.SoothingMistFocus, not v18:IsSpellInRange(v116.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
		end
	end
	local function v131()
		if (((816 - 584) < (156 + 665)) and v49 and v116.RisingSunKick:IsReady() and (v122.FriendlyUnitsWithBuffCount(v116.RenewingMistBuff, false, false, 78 - 53) > (1264 - (668 + 595)))) then
			if (((467 + 51) < (182 + 720)) and v25(v116.RisingSunKick, not v16:IsInMeleeRange(13 - 8))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (((3284 - (23 + 267)) > (2802 - (1129 + 815))) and v122.AreUnitsBelowHealthPercentage(v66, v65, v116.EnvelopingMist)) then
			local v198 = 387 - (371 + 16);
			while true do
				if ((v198 == (1751 - (1326 + 424))) or ((7111 - 3356) <= (3343 - 2428))) then
					if (((4064 - (88 + 30)) > (4514 - (720 + 51))) and v64 and v116.EssenceFont:IsReady() and (v14:BuffUp(v116.ThunderFocusTea) or (v116.ThunderFocusTea:CooldownRemains() > (17 - 9)))) then
						if (v25(v116.EssenceFont, nil) or ((3111 - (421 + 1355)) >= (5453 - 2147))) then
							return "EssenceFont healing aoe";
						end
					end
					if (((2380 + 2464) > (3336 - (286 + 797))) and v64 and v116.EssenceFont:IsReady() and v116.AncientTeachings:IsAvailable() and v14:BuffDown(v116.EssenceFontBuff)) then
						if (((1652 - 1200) == (748 - 296)) and v25(v116.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
				if ((v198 == (439 - (397 + 42))) or ((1424 + 3133) < (2887 - (24 + 776)))) then
					if (((5967 - 2093) == (4659 - (222 + 563))) and v38 and (v14:BuffStack(v116.ManaTeaCharges) > v39) and v116.EssenceFont:IsReady() and v116.ManaTea:IsCastable() and not v122.AreUnitsBelowHealthPercentage(176 - 96, 3 + 0, v116.EnvelopingMist) and not v14:PrevGCD(191 - (23 + 167), v116.ManaTea) and not v14.PrevGCD(1800 - (690 + 1108), v116.ManaTea)) then
						if (v25(v116.ManaTea, nil) or ((700 + 1238) > (4071 + 864))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v40 and v116.ThunderFocusTea:IsReady() and (v116.EssenceFont:CooldownRemains() < v14:GCD())) or ((5103 - (40 + 808)) < (564 + 2859))) then
						if (((5559 - 4105) <= (2381 + 110)) and v25(v116.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v198 = 1 + 0;
				end
			end
		end
		if ((v69 and v116.ZenPulse:IsReady() and v122.AreUnitsBelowHealthPercentage(v71, v70, v116.EnvelopingMist)) or ((2280 + 1877) <= (3374 - (47 + 524)))) then
			if (((3150 + 1703) >= (8151 - 5169)) and v25(v118.ZenPulseFocus, not v18:IsSpellInRange(v116.ZenPulse))) then
				return "ZenPulse healing aoe";
			end
		end
		if (((6181 - 2047) > (7655 - 4298)) and v72 and v116.SheilunsGift:IsReady() and v116.SheilunsGift:IsCastable() and v122.AreUnitsBelowHealthPercentage(v74, v73, v116.EnvelopingMist)) then
			if (v25(v116.SheilunsGift, nil) or ((5143 - (1165 + 561)) < (76 + 2458))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v132()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (0 + 0)) or ((3201 - (341 + 138)) <= (45 + 119))) then
				if ((v60 and v116.EnvelopingMist:IsReady() and (v122.FriendlyUnitsWithBuffCount(v116.EnvelopingMist, false, false, 51 - 26) < (329 - (89 + 237)))) or ((7746 - 5338) < (4439 - 2330))) then
					v30 = v122.FocusUnitRefreshableBuff(v116.EnvelopingMist, 883 - (581 + 300), 1260 - (855 + 365), nil, false, 59 - 34, v116.EnvelopingMist);
					if (v30 or ((11 + 22) == (2690 - (1030 + 205)))) then
						return v30;
					end
					if (v25(v118.EnvelopingMistFocus, not v18:IsSpellInRange(v116.EnvelopingMist)) or ((416 + 27) >= (3736 + 279))) then
						return "Enveloping Mist YuLon";
					end
				end
				if (((3668 - (156 + 130)) > (377 - 211)) and v49 and v116.RisingSunKick:IsReady() and (v122.FriendlyUnitsWithBuffCount(v116.EnvelopingMist, false, false, 42 - 17) > (3 - 1))) then
					if (v25(v116.RisingSunKick, not v16:IsInMeleeRange(2 + 3)) or ((164 + 116) == (3128 - (10 + 59)))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v142 = 1 + 0;
			end
			if (((9263 - 7382) > (2456 - (671 + 492))) and (v142 == (1 + 0))) then
				if (((3572 - (369 + 846)) == (624 + 1733)) and v62 and v116.SoothingMist:IsReady() and v18:BuffUp(v116.ChiHarmonyBuff) and v18:BuffDown(v116.SoothingMist)) then
					if (((105 + 18) == (2068 - (1036 + 909))) and v25(v118.SoothingMistFocus, not v18:IsSpellInRange(v116.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v133()
		if ((v47 and v116.BlackoutKick:IsReady() and (v14:BuffStack(v116.TeachingsoftheMonastery) >= (3 + 0))) or ((1772 - 716) >= (3595 - (11 + 192)))) then
			if (v25(v116.BlackoutKick, not v16:IsInMeleeRange(3 + 2)) or ((1256 - (135 + 40)) < (2604 - 1529))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v60 and v116.EnvelopingMist:IsReady() and (v14:BuffStack(v116.InvokeChiJiBuff) == (2 + 1))) or ((2310 - 1261) >= (6643 - 2211))) then
			if ((v18:HealthPercentage() <= v61) or ((4944 - (50 + 126)) <= (2355 - 1509))) then
				if (v25(v118.EnvelopingMistFocus, not v18:IsSpellInRange(v116.EnvelopingMist)) or ((744 + 2614) <= (2833 - (1233 + 180)))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v49 and v116.RisingSunKick:IsReady()) or ((4708 - (522 + 447)) <= (4426 - (107 + 1314)))) then
			if (v25(v116.RisingSunKick, not v16:IsInMeleeRange(3 + 2)) or ((5054 - 3395) >= (907 + 1227))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v60 and v116.EnvelopingMist:IsReady() and (v14:BuffStack(v116.InvokeChiJiBuff) >= (3 - 1))) or ((12898 - 9638) < (4265 - (716 + 1194)))) then
			if ((v18:HealthPercentage() <= v61) or ((12 + 657) == (453 + 3770))) then
				if (v25(v118.EnvelopingMistFocus, not v18:IsSpellInRange(v116.EnvelopingMist)) or ((2195 - (74 + 429)) < (1133 - 545))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v64 and v116.EssenceFont:IsReady() and v116.AncientTeachings:IsAvailable() and v14:BuffDown(v116.AncientTeachings)) or ((2378 + 2419) < (8357 - 4706))) then
			if (v25(v116.EssenceFont, nil) or ((2956 + 1221) > (14952 - 10102))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v134()
		if ((v81 and v116.LifeCocoon:IsReady() and (v18:HealthPercentage() <= v82)) or ((989 - 589) > (1544 - (279 + 154)))) then
			if (((3829 - (454 + 324)) > (791 + 214)) and v25(v118.LifeCocoonFocus, not v18:IsSpellInRange(v116.LifeCocoon))) then
				return "Life Cocoon CD";
			end
		end
		if (((3710 - (12 + 5)) <= (2363 + 2019)) and v83 and v116.Revival:IsReady() and v116.Revival:IsAvailable() and v122.AreUnitsBelowHealthPercentage(v85, v84, v116.EnvelopingMist)) then
			if (v25(v116.Revival, nil) or ((8362 - 5080) > (1516 + 2584))) then
				return "Revival CD";
			end
		end
		if ((v83 and v116.Restoral:IsReady() and v116.Restoral:IsAvailable() and v122.AreUnitsBelowHealthPercentage(v85, v84, v116.EnvelopingMist)) or ((4673 - (277 + 816)) < (12152 - 9308))) then
			if (((1272 - (1058 + 125)) < (842 + 3648)) and v25(v116.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if ((v75 and v116.InvokeYulonTheJadeSerpent:IsAvailable() and v116.InvokeYulonTheJadeSerpent:IsReady() and (v122.AreUnitsBelowHealthPercentage(v77, v76, v116.EnvelopingMist) or v37)) or ((5958 - (815 + 160)) < (7757 - 5949))) then
			if (((9089 - 5260) > (900 + 2869)) and v116.InvokeYulonTheJadeSerpent:IsReady() and (v116.RenewingMist:ChargesFractional() < (2 - 1))) then
				if (((3383 - (41 + 1857)) <= (4797 - (1222 + 671))) and v25(v116.InvokeYulonTheJadeSerpent, nil)) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if (((11033 - 6764) == (6135 - 1866)) and (v116.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (1207 - (229 + 953)))) then
			v30 = v132();
			if (((2161 - (1111 + 663)) <= (4361 - (874 + 705))) and v30) then
				return v30;
			end
		end
		if ((v78 and v116.InvokeChiJiTheRedCrane:IsReady() and v116.InvokeChiJiTheRedCrane:IsAvailable() and (v122.AreUnitsBelowHealthPercentage(v80, v79, v116.EnvelopingMist) or v37)) or ((266 + 1633) <= (626 + 291))) then
			if ((v116.InvokeChiJiTheRedCrane:IsReady() and (v116.RenewingMist:ChargesFractional() < (1 - 0))) or ((122 + 4190) <= (1555 - (642 + 37)))) then
				if (((509 + 1723) <= (416 + 2180)) and v25(v116.InvokeChiJiTheRedCrane, nil)) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((5260 - 3165) < (4140 - (233 + 221))) and (v116.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (57 - 32))) then
			local v199 = 0 + 0;
			while true do
				if ((v199 == (1541 - (718 + 823))) or ((1004 + 591) >= (5279 - (266 + 539)))) then
					v30 = v133();
					if (v30 or ((13077 - 8458) < (4107 - (636 + 589)))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v135()
		local v143 = 0 - 0;
		while true do
			if (((10 - 5) == v143) or ((233 + 61) >= (1756 + 3075))) then
				v63 = EpicSettings.Settings['SoothingMistHP'];
				v64 = EpicSettings.Settings['UseEssenceFont'];
				v66 = EpicSettings.Settings['EssenceFontHP'];
				v65 = EpicSettings.Settings['EssenceFontGroup'];
				v68 = EpicSettings.Settings['UseJadeSerpent'];
				v143 = 1021 - (657 + 358);
			end
			if (((5372 - 3343) <= (7025 - 3941)) and ((1193 - (1151 + 36)) == v143)) then
				v67 = EpicSettings.Settings['JadeSerpentUsage'];
				v69 = EpicSettings.Settings['UseZenPulse'];
				v71 = EpicSettings.Settings['ZenPulseHP'];
				v70 = EpicSettings.Settings['ZenPulseGroup'];
				v72 = EpicSettings.Settings['UseSheilunsGift'];
				v143 = 7 + 0;
			end
			if ((v143 == (0 + 0)) or ((6083 - 4046) == (4252 - (1552 + 280)))) then
				v38 = EpicSettings.Settings['UseManaTea'];
				v39 = EpicSettings.Settings['ManaTeaStacks'];
				v40 = EpicSettings.Settings['UseThunderFocusTea'];
				v41 = EpicSettings.Settings['UseFortifyingBrew'];
				v42 = EpicSettings.Settings['FortifyingBrewHP'];
				v143 = 835 - (64 + 770);
			end
			if (((3027 + 1431) > (8862 - 4958)) and (v143 == (1 + 2))) then
				v53 = EpicSettings.Settings['UseTouchOfDeath'];
				v54 = EpicSettings.Settings['UseRenewingMist'];
				v55 = EpicSettings.Settings['RenewingMistHP'];
				v56 = EpicSettings.Settings['UseExpelHarm'];
				v57 = EpicSettings.Settings['ExpelHarmHP'];
				v143 = 1247 - (157 + 1086);
			end
			if (((872 - 436) >= (538 - 415)) and (v143 == (2 - 0))) then
				v48 = EpicSettings.Settings['UseSpinningCraneKick'];
				v49 = EpicSettings.Settings['UseRisingSunKick'];
				v50 = EpicSettings.Settings['UseTigerPalm'];
				v51 = EpicSettings.Settings['UseJadefireStomp'];
				v52 = EpicSettings.Settings['UseChiBurst'];
				v143 = 3 - 0;
			end
			if (((1319 - (599 + 220)) < (3615 - 1799)) and ((1938 - (1813 + 118)) == v143)) then
				v74 = EpicSettings.Settings['SheilunsGiftHP'];
				v73 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((2613 + 961) == (4791 - (841 + 376))) and (v143 == (1 - 0))) then
				v43 = EpicSettings.Settings['UseDampenHarm'];
				v44 = EpicSettings.Settings['DampenHarmHP'];
				v45 = EpicSettings.Settings['WhiteTigerUsage'];
				v46 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v47 = EpicSettings.Settings['UseBlackoutKick'];
				v143 = 1 + 1;
			end
			if (((603 - 382) < (1249 - (464 + 395))) and ((10 - 6) == v143)) then
				v58 = EpicSettings.Settings['UseVivify'];
				v59 = EpicSettings.Settings['VivifyHP'];
				v60 = EpicSettings.Settings['UseEnvelopingMist'];
				v61 = EpicSettings.Settings['EnvelopingMistHP'];
				v62 = EpicSettings.Settings['UseSoothingMist'];
				v143 = 3 + 2;
			end
		end
	end
	local function v136()
		v98 = EpicSettings.Settings['racialsWithCD'];
		v97 = EpicSettings.Settings['useRacials'];
		v100 = EpicSettings.Settings['trinketsWithCD'];
		v99 = EpicSettings.Settings['useTrinkets'];
		v101 = EpicSettings.Settings['fightRemainsCheck'];
		v102 = EpicSettings.Settings['useWeapon'];
		v91 = EpicSettings.Settings['dispelDebuffs'];
		v88 = EpicSettings.Settings['useHealingPotion'];
		v89 = EpicSettings.Settings['healingPotionHP'];
		v90 = EpicSettings.Settings['HealingPotionName'];
		v86 = EpicSettings.Settings['useHealthstone'];
		v87 = EpicSettings.Settings['healthstoneHP'];
		v109 = EpicSettings.Settings['useManaPotion'];
		v110 = EpicSettings.Settings['manaPotionSlider'];
		v111 = EpicSettings.Settings['RevivalBurstingGroup'];
		v112 = EpicSettings.Settings['RevivalBurstingStacks'];
		v94 = EpicSettings.Settings['InterruptThreshold'];
		v92 = EpicSettings.Settings['InterruptWithStun'];
		v93 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v95 = EpicSettings.Settings['useSpearHandStrike'];
		v96 = EpicSettings.Settings['useLegSweep'];
		v103 = EpicSettings.Settings['handleAfflicted'];
		v104 = EpicSettings.Settings['HandleIncorporeal'];
		v105 = EpicSettings.Settings['HandleChromie'];
		v107 = EpicSettings.Settings['HandleCharredBrambles'];
		v106 = EpicSettings.Settings['HandleCharredTreant'];
		v108 = EpicSettings.Settings['HandleFyrakkNPC'];
		v75 = EpicSettings.Settings['UseInvokeYulon'];
		v77 = EpicSettings.Settings['InvokeYulonHP'];
		v76 = EpicSettings.Settings['InvokeYulonGroup'];
		v78 = EpicSettings.Settings['UseInvokeChiJi'];
		v80 = EpicSettings.Settings['InvokeChiJiHP'];
		v79 = EpicSettings.Settings['InvokeChiJiGroup'];
		v81 = EpicSettings.Settings['UseLifeCocoon'];
		v82 = EpicSettings.Settings['LifeCocoonHP'];
		v83 = EpicSettings.Settings['UseRevival'];
		v85 = EpicSettings.Settings['RevivalHP'];
		v84 = EpicSettings.Settings['RevivalGroup'];
	end
	local v137 = 837 - (467 + 370);
	local function v138()
		v135();
		v136();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['healing'];
		v36 = EpicSettings.Toggles['dps'];
		v37 = EpicSettings.Toggles['ramp'];
		if (v14:IsDeadOrGhost() or ((4572 - 2359) <= (1044 + 377))) then
			return;
		end
		v120 = v14:GetEnemiesInMeleeRange(27 - 19);
		if (((478 + 2580) < (11307 - 6447)) and v32) then
			v121 = #v120;
		else
			v121 = 521 - (150 + 370);
		end
		if (v122.TargetIsValid() or v14:AffectingCombat() or ((2578 - (74 + 1208)) >= (10935 - 6489))) then
			v115 = v14:GetEnemiesInRange(189 - 149);
			v113 = v11.BossFightRemains(nil, true);
			v114 = v113;
			if ((v114 == (7907 + 3204)) or ((1783 - (14 + 376)) > (7785 - 3296))) then
				v114 = v11.FightRemains(v115, false);
			end
		end
		v30 = v126();
		if (v30 or ((2863 + 1561) < (24 + 3))) then
			return v30;
		end
		if (v14:AffectingCombat() or v31 or ((1905 + 92) > (11178 - 7363))) then
			local v200 = v91 and v116.Detox:IsReady() and v34;
			v30 = v122.FocusUnit(v200, nil, 31 + 9, nil, 103 - (23 + 55), v116.EnvelopingMist);
			if (((8211 - 4746) > (1277 + 636)) and v30) then
				return v30;
			end
			if (((659 + 74) < (2819 - 1000)) and v34 and v91) then
				if ((v18 and v18:Exists() and v18:IsAPlayer() and (v122.UnitHasDispellableDebuffByPlayer(v18) or v122.DispellableFriendlyUnit(8 + 17) or v122.UnitHasMagicDebuff(v18) or (v116.ImprovedDetox:IsAvailable() and (v122.UnitHasDiseaseDebuff(v18) or v122.UnitHasPoisonDebuff(v18))))) or ((5296 - (652 + 249)) == (12725 - 7970))) then
					if (v116.Detox:IsCastable() or ((5661 - (708 + 1160)) < (6430 - 4061))) then
						if ((v137 == (0 - 0)) or ((4111 - (10 + 17)) == (60 + 205))) then
							v137 = GetTime();
						end
						if (((6090 - (1400 + 332)) == (8358 - 4000)) and v122.Wait(2408 - (242 + 1666), v137)) then
							if (v25(v118.DetoxFocus, not v18:IsSpellInRange(v116.Detox)) or ((1343 + 1795) < (364 + 629))) then
								return "detox dispel focus";
							end
							v137 = 0 + 0;
						end
					end
				end
				if (((4270 - (850 + 90)) > (4067 - 1744)) and v17 and v17:Exists() and not v14:CanAttack(v17) and (v122.UnitHasDispellableDebuffByPlayer(v17) or v122.UnitHasMagicDebuff(v17) or (v116.ImprovedDetox:IsAvailable() and (v122.UnitHasDiseaseDebuff(v17) or v122.UnitHasPoisonDebuff(v17))))) then
					if (v116.Detox:IsCastable() or ((5016 - (360 + 1030)) == (3531 + 458))) then
						if (v25(v118.DetoxMouseover, not v17:IsSpellInRange(v116.Detox)) or ((2584 - 1668) == (3674 - 1003))) then
							return "detox dispel mouseover";
						end
					end
				end
			end
		end
		if (((1933 - (909 + 752)) == (1495 - (109 + 1114))) and not v14:AffectingCombat()) then
			if (((7778 - 3529) <= (1884 + 2955)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
				local v238 = 242 - (6 + 236);
				local v239;
				while true do
					if (((1750 + 1027) < (2576 + 624)) and (v238 == (0 - 0))) then
						v239 = v122.DeadFriendlyUnitsCount();
						if (((165 - 70) < (3090 - (1076 + 57))) and (v239 > (1 + 0))) then
							if (((1515 - (579 + 110)) < (136 + 1581)) and v25(v116.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (((1261 + 165) >= (587 + 518)) and v25(v118.ResuscitateMouseover, not v16:IsInRange(447 - (174 + 233)))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if (((7692 - 4938) <= (5930 - 2551)) and not v14:AffectingCombat() and v31) then
			v30 = v127();
			if (v30 or ((1747 + 2180) == (2587 - (663 + 511)))) then
				return v30;
			end
		end
		if (v31 or v14:AffectingCombat() or ((1030 + 124) <= (172 + 616))) then
			if ((v33 and v102 and (v117.Dreambinder:IsEquippedAndReady() or v117.Iridal:IsEquippedAndReady())) or ((5065 - 3422) > (2047 + 1332))) then
				if (v25(v118.UseWeapon, nil) or ((6598 - 3795) > (11011 - 6462))) then
					return "Using Weapon Macro";
				end
			end
			if ((v109 and v117.AeratedManaPotion:IsReady() and (v14:ManaPercentage() <= v110)) or ((105 + 115) >= (5881 - 2859))) then
				if (((2012 + 810) == (258 + 2564)) and v25(v118.ManaPotion, nil)) then
					return "Mana Potion main";
				end
			end
			if ((v14:DebuffStack(v116.Bursting) > (727 - (478 + 244))) or ((1578 - (440 + 77)) == (845 + 1012))) then
				if (((10101 - 7341) > (2920 - (655 + 901))) and v116.DiffuseMagic:IsReady() and v116.DiffuseMagic:IsAvailable()) then
					if (v25(v116.DiffuseMagic, nil) or ((910 + 3992) <= (2753 + 842))) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((v116.Bursting:MaxDebuffStack() > v112) and (v116.Bursting:AuraActiveCount() > v111)) or ((2601 + 1251) == (1180 - 887))) then
				if ((v83 and v116.Revival:IsReady() and v116.Revival:IsAvailable()) or ((3004 - (695 + 750)) == (15666 - 11078))) then
					if (v25(v116.Revival, nil) or ((6919 - 2435) == (3168 - 2380))) then
						return "Revival Bursting";
					end
				end
			end
			if (((4919 - (285 + 66)) >= (9107 - 5200)) and v34 and v91) then
				if (((2556 - (682 + 628)) < (560 + 2910)) and v116.TigersLust:IsReady() and v122.UnitHasDebuffFromList(v14, v122.DispellableRootDebuffs) and v14:CanAttack(v16)) then
					if (((4367 - (176 + 123)) >= (407 + 565)) and v25(v116.TigersLust, nil)) then
						return "Tigers Lust Roots";
					end
				end
			end
			if (((358 + 135) < (4162 - (239 + 30))) and v35) then
				local v240 = 0 + 0;
				while true do
					if ((v240 == (0 + 0)) or ((2606 - 1133) >= (10395 - 7063))) then
						if ((v116.SummonJadeSerpentStatue:IsReady() and v116.SummonJadeSerpentStatue:IsAvailable() and (v116.SummonJadeSerpentStatue:TimeSinceLastCast() > (405 - (306 + 9))) and v68) or ((14136 - 10085) <= (202 + 955))) then
							if (((371 + 233) < (1387 + 1494)) and (v67 == "Player")) then
								if (v25(v118.SummonJadeSerpentStatuePlayer, not v16:IsInRange(114 - 74)) or ((2275 - (1140 + 235)) == (2150 + 1227))) then
									return "jade serpent main player";
								end
							elseif (((4089 + 370) > (152 + 439)) and (v67 == "Cursor")) then
								if (((3450 - (33 + 19)) >= (865 + 1530)) and v25(v118.SummonJadeSerpentStatueCursor, not v16:IsInRange(119 - 79))) then
									return "jade serpent main cursor";
								end
							elseif ((v67 == "Confirmation") or ((962 + 1221) >= (5537 - 2713))) then
								if (((1816 + 120) == (2625 - (586 + 103))) and v25(v116.SummonJadeSerpentStatue, not v16:IsInRange(4 + 36))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if ((v54 and v116.RenewingMist:IsReady() and v16:BuffDown(v116.RenewingMistBuff) and not v14:CanAttack(v16)) or ((14875 - 10043) < (5801 - (1309 + 179)))) then
							if (((7379 - 3291) > (1687 + 2187)) and (v16:HealthPercentage() <= v55)) then
								if (((11633 - 7301) == (3273 + 1059)) and v25(v116.RenewingMist, not v16:IsSpellInRange(v116.RenewingMist))) then
									return "RenewingMist main";
								end
							end
						end
						v240 = 1 - 0;
					end
					if (((7968 - 3969) >= (3509 - (295 + 314))) and ((2 - 1) == v240)) then
						if ((v62 and v116.SoothingMist:IsReady() and v16:BuffDown(v116.SoothingMist) and not v14:CanAttack(v16)) or ((4487 - (1300 + 662)) > (12761 - 8697))) then
							if (((6126 - (1178 + 577)) == (2270 + 2101)) and (v16:HealthPercentage() <= v63)) then
								if (v25(v116.SoothingMist, not v16:IsSpellInRange(v116.SoothingMist)) or ((786 - 520) > (6391 - (851 + 554)))) then
									return "SoothingMist main";
								end
							end
						end
						if (((1761 + 230) >= (2565 - 1640)) and v38 and (v14:BuffStack(v116.ManaTeaCharges) >= (38 - 20)) and v116.ManaTea:IsCastable() and not v122.AreUnitsBelowHealthPercentage(382 - (115 + 187), 3 + 0, v116.EnvelopingMist) and not v14:PrevGCD(1 + 0, v116.ManaTea) and not v14.PrevGCD(7 - 5, v116.ManaTea)) then
							if (((1616 - (160 + 1001)) < (1797 + 256)) and v25(v116.ManaTea, nil)) then
								return "Mana Tea main avoid overcap";
							end
						end
						v240 = 2 + 0;
					end
					if ((v240 == (5 - 2)) or ((1184 - (237 + 121)) == (5748 - (525 + 372)))) then
						v30 = v130();
						if (((346 - 163) == (601 - 418)) and v30) then
							return v30;
						end
						break;
					end
					if (((1301 - (96 + 46)) <= (2565 - (643 + 134))) and (v240 == (1 + 1))) then
						if (((v114 > v101) and v33 and v14:AffectingCombat()) or ((8408 - 4901) > (16031 - 11713))) then
							local v243 = 0 + 0;
							while true do
								if ((v243 == (0 - 0)) or ((6285 - 3210) <= (3684 - (316 + 403)))) then
									v30 = v134();
									if (((908 + 457) <= (5528 - 3517)) and v30) then
										return v30;
									end
									break;
								end
							end
						end
						if (v32 or ((1004 + 1772) > (9003 - 5428))) then
							v30 = v131();
							if (v30 or ((1810 + 744) == (1549 + 3255))) then
								return v30;
							end
						end
						v240 = 10 - 7;
					end
				end
			end
		end
		if (((12307 - 9730) == (5353 - 2776)) and (v31 or v14:AffectingCombat()) and v122.TargetIsValid() and v14:CanAttack(v16) and not v16:IsDeadOrGhost()) then
			v30 = v125();
			if (v30 or ((1 + 5) >= (3718 - 1829))) then
				return v30;
			end
			if (((25 + 481) <= (5566 - 3674)) and v99 and ((v33 and v100) or not v100)) then
				v30 = v122.HandleTopTrinket(v119, v33, 57 - (12 + 5), nil);
				if (v30 or ((7798 - 5790) > (4732 - 2514))) then
					return v30;
				end
				v30 = v122.HandleBottomTrinket(v119, v33, 85 - 45, nil);
				if (((939 - 560) <= (842 + 3305)) and v30) then
					return v30;
				end
			end
			if (v36 or ((6487 - (1656 + 317)) <= (900 + 109))) then
				if ((v97 and ((v33 and v98) or not v98) and (v114 < (15 + 3))) or ((9295 - 5799) == (5866 - 4674))) then
					if (v116.BloodFury:IsCastable() or ((562 - (5 + 349)) == (14054 - 11095))) then
						if (((5548 - (266 + 1005)) >= (866 + 447)) and v25(v116.BloodFury, nil)) then
							return "blood_fury main 4";
						end
					end
					if (((8827 - 6240) < (4177 - 1003)) and v116.Berserking:IsCastable()) then
						if (v25(v116.Berserking, nil) or ((5816 - (561 + 1135)) <= (2863 - 665))) then
							return "berserking main 6";
						end
					end
					if (v116.LightsJudgment:IsCastable() or ((5246 - 3650) == (1924 - (507 + 559)))) then
						if (((8080 - 4860) == (9958 - 6738)) and v25(v116.LightsJudgment, not v16:IsInRange(428 - (212 + 176)))) then
							return "lights_judgment main 8";
						end
					end
					if (v116.Fireblood:IsCastable() or ((2307 - (250 + 655)) > (9871 - 6251))) then
						if (((4497 - 1923) == (4026 - 1452)) and v25(v116.Fireblood, nil)) then
							return "fireblood main 10";
						end
					end
					if (((3754 - (1869 + 87)) < (9562 - 6805)) and v116.AncestralCall:IsCastable()) then
						if (v25(v116.AncestralCall, nil) or ((2278 - (484 + 1417)) > (5581 - 2977))) then
							return "ancestral_call main 12";
						end
					end
					if (((951 - 383) < (1684 - (48 + 725))) and v116.BagofTricks:IsCastable()) then
						if (((5366 - 2081) < (11343 - 7115)) and v25(v116.BagofTricks, not v16:IsInRange(24 + 16))) then
							return "bag_of_tricks main 14";
						end
					end
				end
				if (((10465 - 6549) > (932 + 2396)) and v40 and v116.ThunderFocusTea:IsReady() and (not v116.EssenceFont:IsAvailable() or not v122.AreUnitsBelowHealthPercentage(v66, v65, v116.EnvelopingMist)) and (v116.RisingSunKick:CooldownRemains() < v14:GCD())) then
					if (((729 + 1771) < (4692 - (152 + 701))) and v25(v116.ThunderFocusTea, nil)) then
						return "ThunderFocusTea main 16";
					end
				end
				if (((1818 - (430 + 881)) == (195 + 312)) and (v121 >= (898 - (557 + 338))) and v32) then
					v30 = v128();
					if (((71 + 169) <= (8919 - 5754)) and v30) then
						return v30;
					end
				end
				if (((2920 - 2086) >= (2138 - 1333)) and (v121 < (6 - 3))) then
					local v241 = 801 - (499 + 302);
					while true do
						if ((v241 == (866 - (39 + 827))) or ((10522 - 6710) < (5172 - 2856))) then
							v30 = v129();
							if (v30 or ((10533 - 7881) <= (2352 - 819))) then
								return v30;
							end
							break;
						end
					end
				end
			end
		end
	end
	local function v139()
		v124();
		v116.Bursting:RegisterAuraTracking();
		v23.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v23.SetAPL(24 + 246, v138, v139);
end;
return v1["Epix_Monk_Mistweaver.lua"](...);

