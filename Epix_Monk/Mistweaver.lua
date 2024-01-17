local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((6905 - 4343) == (5995 - (884 + 916)))) then
			v6 = v0[v4];
			if (not v6 or ((7936 - 4145) <= (935 + 676))) then
				return v1(v4, ...);
			end
			v5 = 654 - (232 + 421);
		end
		if ((v5 == (1890 - (1569 + 320))) or ((1124 + 3454) <= (382 + 1626))) then
			return v6(...);
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
	local v105 = 37441 - 26330;
	local v106 = 11716 - (316 + 289);
	local v107;
	local v108 = v18.Monk.Mistweaver;
	local v109 = v20.Monk.Mistweaver;
	local v110 = v25.Monk.Mistweaver;
	local v111 = {};
	local v112;
	local v113;
	local v114 = {{v108.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v108.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v115 = v22.Commons.Everyone;
	local v116 = v22.Commons.Monk;
	local function v117()
		if (((3448 - 2323) <= (3997 - 1921)) and v108.ImprovedDetox:IsAvailable()) then
			v115.DispellableDebuffs = v21.MergeTable(v115.DispellableMagicDebuffs, v115.DispellablePoisonDebuffs, v115.DispellableDiseaseDebuffs);
		else
			v115.DispellableDebuffs = v115.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v117();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v118()
		local v132 = 899 - (503 + 396);
		while true do
			if (((182 - (92 + 89)) == v132) or ((1440 - 697) >= (2256 + 2143))) then
				if (((684 + 471) < (6551 - 4878)) and v108.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v108.ChiHarmonyBuff)) then
					if (v24(v108.ExpelHarm, nil) or ((318 + 2006) <= (1317 - 739))) then
						return "expel_harm defensives 3";
					end
				end
				if (((3287 + 480) == (1800 + 1967)) and v109.Healthstone:IsReady() and v84 and (v13:HealthPercentage() <= v85)) then
					if (((12453 - 8364) == (511 + 3578)) and v24(v110.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v132 = 2 - 0;
			end
			if (((5702 - (485 + 759)) >= (3873 - 2199)) and (v132 == (1189 - (442 + 747)))) then
				if (((2107 - (832 + 303)) <= (2364 - (88 + 858))) and v108.DampenHarm:IsCastable() and v13:BuffDown(v108.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) then
					if (v24(v108.DampenHarm, nil) or ((1506 + 3432) < (3942 + 820))) then
						return "dampen_harm defensives 1";
					end
				end
				if ((v108.FortifyingBrew:IsCastable() and v13:BuffDown(v108.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) or ((104 + 2400) > (5053 - (766 + 23)))) then
					if (((10628 - 8475) == (2943 - 790)) and v24(v108.FortifyingBrew, nil)) then
						return "fortifying_brew defensives 2";
					end
				end
				v132 = 2 - 1;
			end
			if ((v132 == (6 - 4)) or ((1580 - (1036 + 37)) >= (1837 + 754))) then
				if (((8726 - 4245) == (3525 + 956)) and v86 and (v13:HealthPercentage() <= v87)) then
					if ((v88 == "Refreshing Healing Potion") or ((3808 - (641 + 839)) < (1606 - (910 + 3)))) then
						if (((11033 - 6705) == (6012 - (1466 + 218))) and v109.RefreshingHealingPotion:IsReady()) then
							if (((730 + 858) >= (2480 - (556 + 592))) and v24(v110.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((1485 + 2689) > (5056 - (329 + 479)))) then
						if (v109.DreamwalkersHealingPotion:IsReady() or ((5440 - (174 + 680)) <= (281 - 199))) then
							if (((8006 - 4143) == (2759 + 1104)) and v24(v110.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		if (v101 or ((1021 - (396 + 343)) <= (4 + 38))) then
			local v184 = 1477 - (29 + 1448);
			while true do
				if (((5998 - (135 + 1254)) >= (2885 - 2119)) and (v184 == (0 - 0))) then
					v29 = v115.HandleIncorporeal(v108.Paralysis, v110.ParalysisMouseover, 20 + 10, true);
					if (v29 or ((2679 - (389 + 1138)) == (3062 - (102 + 472)))) then
						return v29;
					end
					break;
				end
			end
		end
		if (((3230 + 192) > (1858 + 1492)) and v100) then
			local v185 = 0 + 0;
			while true do
				if (((2422 - (320 + 1225)) > (669 - 293)) and (v185 == (0 + 0))) then
					v29 = v115.HandleAfflicted(v108.Detox, v110.DetoxMouseover, 1494 - (157 + 1307));
					if (v29 or ((4977 - (821 + 1038)) <= (4618 - 2767))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v102 or ((19 + 146) >= (6202 - 2710))) then
			local v186 = 0 + 0;
			while true do
				if (((9787 - 5838) < (5882 - (834 + 192))) and (v186 == (1 + 1))) then
					v29 = v115.HandleCharredTreant(v108.Vivify, v110.VivifyMouseover, 11 + 29);
					if (v29 or ((92 + 4184) < (4672 - 1656))) then
						return v29;
					end
					v186 = 307 - (300 + 4);
				end
				if (((1253 + 3437) > (10798 - 6673)) and (v186 == (362 - (112 + 250)))) then
					v29 = v115.HandleCharredTreant(v108.RenewingMist, v110.RenewingMistMouseover, 16 + 24);
					if (v29 or ((125 - 75) >= (514 + 382))) then
						return v29;
					end
					v186 = 1 + 0;
				end
				if ((v186 == (3 + 0)) or ((850 + 864) >= (2198 + 760))) then
					v29 = v115.HandleCharredTreant(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 1454 - (1001 + 413));
					if (v29 or ((3324 - 1833) < (1526 - (244 + 638)))) then
						return v29;
					end
					break;
				end
				if (((1397 - (627 + 66)) < (2940 - 1953)) and (v186 == (603 - (512 + 90)))) then
					v29 = v115.HandleCharredTreant(v108.SoothingMist, v110.SoothingMistMouseover, 1946 - (1665 + 241));
					if (((4435 - (373 + 344)) > (860 + 1046)) and v29) then
						return v29;
					end
					v186 = 1 + 1;
				end
			end
		end
		if (v103 or ((2526 - 1568) > (6150 - 2515))) then
			v29 = v115.HandleCharredBrambles(v108.RenewingMist, v110.RenewingMistMouseover, 1139 - (35 + 1064));
			if (((2548 + 953) <= (9610 - 5118)) and v29) then
				return v29;
			end
			v29 = v115.HandleCharredBrambles(v108.SoothingMist, v110.SoothingMistMouseover, 1 + 39);
			if (v29 or ((4678 - (298 + 938)) < (3807 - (233 + 1026)))) then
				return v29;
			end
			v29 = v115.HandleCharredBrambles(v108.Vivify, v110.VivifyMouseover, 1706 - (636 + 1030));
			if (((1470 + 1405) >= (1430 + 34)) and v29) then
				return v29;
			end
			v29 = v115.HandleCharredBrambles(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 12 + 28);
			if (v29 or ((325 + 4472) >= (5114 - (55 + 166)))) then
				return v29;
			end
		end
		if (v104 or ((107 + 444) > (208 + 1860))) then
			local v187 = 0 - 0;
			while true do
				if (((2411 - (36 + 261)) > (1650 - 706)) and (v187 == (1369 - (34 + 1334)))) then
					v29 = v115.HandleFyrakkNPC(v108.SoothingMist, v110.SoothingMistMouseover, 16 + 24);
					if (v29 or ((1758 + 504) >= (4379 - (1035 + 248)))) then
						return v29;
					end
					v187 = 23 - (20 + 1);
				end
				if ((v187 == (2 + 0)) or ((2574 - (134 + 185)) >= (4670 - (549 + 584)))) then
					v29 = v115.HandleFyrakkNPC(v108.Vivify, v110.VivifyMouseover, 725 - (314 + 371));
					if (v29 or ((13172 - 9335) < (2274 - (478 + 490)))) then
						return v29;
					end
					v187 = 2 + 1;
				end
				if (((4122 - (786 + 386)) == (9555 - 6605)) and (v187 == (1382 - (1055 + 324)))) then
					v29 = v115.HandleFyrakkNPC(v108.EnvelopingMist, v110.EnvelopingMistMouseover, 1380 - (1093 + 247));
					if (v29 or ((4198 + 525) < (347 + 2951))) then
						return v29;
					end
					break;
				end
				if (((4510 - 3374) >= (522 - 368)) and (v187 == (0 - 0))) then
					v29 = v115.HandleFyrakkNPC(v108.RenewingMist, v110.RenewingMistMouseover, 100 - 60);
					if (v29 or ((97 + 174) > (18291 - 13543))) then
						return v29;
					end
					v187 = 3 - 2;
				end
			end
		end
	end
	local function v120()
		local v133 = 0 + 0;
		while true do
			if (((12122 - 7382) >= (3840 - (364 + 324))) and (v133 == (0 - 0))) then
				if ((v108.ChiBurst:IsCastable() and v50) or ((6186 - 3608) >= (1124 + 2266))) then
					if (((171 - 130) <= (2659 - 998)) and v24(v108.ChiBurst, not v15:IsInRange(121 - 81))) then
						return "chi_burst precombat 4";
					end
				end
				if (((1869 - (1249 + 19)) < (3214 + 346)) and v108.SpinningCraneKick:IsCastable() and v46 and (v113 >= (7 - 5))) then
					if (((1321 - (686 + 400)) < (540 + 147)) and v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(237 - (73 + 156)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v133 = 1 + 0;
			end
			if (((5360 - (721 + 90)) > (13 + 1140)) and (v133 == (3 - 2))) then
				if ((v108.TigerPalm:IsCastable() and v48) or ((5144 - (224 + 246)) < (7568 - 2896))) then
					if (((6753 - 3085) < (828 + 3733)) and v24(v108.TigerPalm, not v15:IsInMeleeRange(1 + 4))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (5 - 2)) or ((1514 - 1059) == (4118 - (203 + 310)))) then
				if ((v108.TigerPalm:IsCastable() and v108.TeachingsoftheMonastery:IsAvailable() and (v108.BlackoutKick:CooldownRemains() > (1993 - (1238 + 755))) and v48 and (v113 >= (1 + 2))) or ((4197 - (709 + 825)) == (6102 - 2790))) then
					if (((6230 - 1953) <= (5339 - (196 + 668))) and v24(v108.TigerPalm, not v15:IsInMeleeRange(19 - 14))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v108.SpinningCraneKick:IsCastable() and v46) or ((1802 - 932) == (2022 - (171 + 662)))) then
					if (((1646 - (4 + 89)) <= (10980 - 7847)) and v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if ((v134 == (8 - 6)) or ((878 + 1359) >= (4997 - (35 + 1451)))) then
				if ((v108.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v108.MysticTouchDebuff) and v108.MysticTouch:IsAvailable()) or ((2777 - (28 + 1425)) > (5013 - (941 + 1052)))) then
					if (v24(v108.SpinningCraneKick, not v15:IsInMeleeRange(8 + 0)) or ((4506 - (822 + 692)) == (2685 - 804))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((1463 + 1643) > (1823 - (45 + 252))) and v108.BlackoutKick:IsCastable() and v108.AncientConcordance:IsAvailable() and v13:BuffUp(v108.JadefireStomp) and v45 and (v113 >= (3 + 0))) then
					if (((1041 + 1982) < (9418 - 5548)) and v24(v108.BlackoutKick, not v15:IsInMeleeRange(438 - (114 + 319)))) then
						return "blackout_kick aoe 6";
					end
				end
				v134 = 3 - 0;
			end
			if (((182 - 39) > (48 + 26)) and (v134 == (0 - 0))) then
				if (((37 - 19) < (4075 - (556 + 1407))) and v108.SummonWhiteTigerStatue:IsReady() and (v113 >= (1209 - (741 + 465))) and v44) then
					if (((1562 - (170 + 295)) <= (858 + 770)) and (v43 == "Player")) then
						if (((4253 + 377) == (11399 - 6769)) and v24(v110.SummonWhiteTigerStatuePlayer, not v15:IsInRange(34 + 6))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((2271 + 1269) > (1520 + 1163)) and (v43 == "Cursor")) then
						if (((6024 - (957 + 273)) >= (876 + 2399)) and v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(17 + 23))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((5654 - 4170) == (3910 - 2426)) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (((4373 - 2941) < (17603 - 14048)) and v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(1820 - (389 + 1391)))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) or ((669 + 396) > (373 + 3205))) then
						if (v24(v110.SummonWhiteTigerStatueCursor, not v15:IsInRange(91 - 51)) or ((5746 - (783 + 168)) < (4722 - 3315))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif (((1823 + 30) < (5124 - (309 + 2))) and (v43 == "Confirmation")) then
						if (v24(v110.SummonWhiteTigerStatue, not v15:IsInRange(122 - 82)) or ((4033 - (1090 + 122)) < (789 + 1642))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v108.TouchofDeath:IsCastable() and v51) or ((9652 - 6778) < (1493 + 688))) then
					if (v24(v108.TouchofDeath, not v15:IsInMeleeRange(1123 - (628 + 490))) or ((483 + 2206) <= (849 - 506))) then
						return "touch_of_death aoe 2";
					end
				end
				v134 = 4 - 3;
			end
			if ((v134 == (775 - (431 + 343))) or ((3774 - 1905) == (5811 - 3802))) then
				if ((v108.JadefireStomp:IsReady() and v49) or ((2802 + 744) < (297 + 2025))) then
					if (v24(v108.JadefireStomp, nil) or ((3777 - (556 + 1139)) == (4788 - (6 + 9)))) then
						return "JadefireStomp aoe3";
					end
				end
				if (((594 + 2650) > (541 + 514)) and v108.ChiBurst:IsCastable() and v50) then
					if (v24(v108.ChiBurst, not v15:IsInRange(209 - (28 + 141))) or ((1284 + 2029) <= (2194 - 416))) then
						return "chi_burst aoe 4";
					end
				end
				v134 = 2 + 0;
			end
		end
	end
	local function v122()
		local v135 = 1317 - (486 + 831);
		while true do
			if ((v135 == (5 - 3)) or ((5002 - 3581) >= (398 + 1706))) then
				if (((5729 - 3917) <= (4512 - (668 + 595))) and v108.BlackoutKick:IsCastable() and (v13:BuffStack(v108.TeachingsoftheMonasteryBuff) == (3 + 0)) and (v108.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) then
					if (((328 + 1295) <= (5336 - 3379)) and v24(v108.BlackoutKick, not v15:IsInMeleeRange(295 - (23 + 267)))) then
						return "blackout_kick st 5";
					end
				end
				if (((6356 - (1129 + 815)) == (4799 - (371 + 16))) and v108.TigerPalm:IsCastable() and ((v13:BuffStack(v108.TeachingsoftheMonasteryBuff) < (1753 - (1326 + 424))) or (v13:BuffRemains(v108.TeachingsoftheMonasteryBuff) < (3 - 1))) and v48) then
					if (((6394 - 4644) >= (960 - (88 + 30))) and v24(v108.TigerPalm, not v15:IsInMeleeRange(776 - (720 + 51)))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if (((9725 - 5353) > (3626 - (421 + 1355))) and (v135 == (0 - 0))) then
				if (((114 + 118) < (1904 - (286 + 797))) and v108.TouchofDeath:IsCastable() and v51) then
					if (((1893 - 1375) < (1493 - 591)) and v24(v108.TouchofDeath, not v15:IsInMeleeRange(444 - (397 + 42)))) then
						return "touch_of_death st 1";
					end
				end
				if (((936 + 2058) > (1658 - (24 + 776))) and v108.JadefireStomp:IsReady() and v49) then
					if (v24(v108.JadefireStomp, nil) or ((5784 - 2029) <= (1700 - (222 + 563)))) then
						return "JadefireStomp st 2";
					end
				end
				v135 = 1 - 0;
			end
			if (((2842 + 1104) > (3933 - (23 + 167))) and (v135 == (1799 - (690 + 1108)))) then
				if ((v108.RisingSunKick:IsReady() and v47) or ((482 + 853) >= (2727 + 579))) then
					if (((5692 - (40 + 808)) > (371 + 1882)) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(19 - 14))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((433 + 19) == (240 + 212)) and v108.ChiBurst:IsCastable() and v50) then
					if (v24(v108.ChiBurst, not v15:IsInRange(22 + 18)) or ((5128 - (47 + 524)) < (1355 + 732))) then
						return "chi_burst st 4";
					end
				end
				v135 = 5 - 3;
			end
		end
	end
	local function v123()
		local v136 = 0 - 0;
		while true do
			if (((8834 - 4960) == (5600 - (1165 + 561))) and (v136 == (1 + 0))) then
				if ((v52 and v108.RenewingMist:IsReady() and v17:BuffDown(v108.RenewingMistBuff)) or ((6002 - 4064) > (1883 + 3052))) then
					if ((v17:HealthPercentage() <= v53) or ((4734 - (341 + 138)) < (925 + 2498))) then
						if (((3000 - 1546) <= (2817 - (89 + 237))) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v108.Vivify:IsReady() and v13:BuffUp(v108.VivaciousVivificationBuff)) or ((13372 - 9215) <= (5901 - 3098))) then
					if (((5734 - (581 + 300)) >= (4202 - (855 + 365))) and (v17:HealthPercentage() <= v57)) then
						if (((9819 - 5685) > (1097 + 2260)) and v24(v110.VivifyFocus, not v17:IsSpellInRange(v108.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v136 = 1237 - (1030 + 205);
			end
			if ((v136 == (2 + 0)) or ((3179 + 238) < (2820 - (156 + 130)))) then
				if ((v60 and v108.SoothingMist:IsReady() and v17:BuffDown(v108.SoothingMist)) or ((6184 - 3462) <= (275 - 111))) then
					if ((v17:HealthPercentage() <= v61) or ((4931 - 2523) < (556 + 1553))) then
						if (v24(v110.SoothingMistFocus, not v17:IsSpellInRange(v108.SoothingMist)) or ((20 + 13) == (1524 - (10 + 59)))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((0 + 0) == v136) or ((2181 - 1738) >= (5178 - (671 + 492)))) then
				if (((2693 + 689) > (1381 - (369 + 846))) and v52 and v108.RenewingMist:IsReady() and v17:BuffDown(v108.RenewingMistBuff) and (v108.RenewingMist:ChargesFractional() >= (1.8 + 0))) then
					if ((v17:HealthPercentage() <= v53) or ((239 + 41) == (5004 - (1036 + 909)))) then
						if (((1496 + 385) > (2170 - 877)) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((2560 - (11 + 192)) == (1192 + 1165)) and v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 200 - (135 + 40)) > (2 - 1))) then
					if (((75 + 48) == (270 - 147)) and v24(v108.RisingSunKick, not v15:IsInMeleeRange(7 - 2))) then
						return "RisingSunKick healing st";
					end
				end
				v136 = 177 - (50 + 126);
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (0 + 0)) or ((2469 - (1233 + 180)) >= (4361 - (522 + 447)))) then
				if ((v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.RenewingMistBuff, false, false, 1446 - (107 + 1314)) > (1 + 0))) or ((3293 - 2212) < (457 + 618))) then
					if (v24(v108.RisingSunKick, not v15:IsInMeleeRange(9 - 4)) or ((4150 - 3101) >= (6342 - (716 + 1194)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v115.AreUnitsBelowHealthPercentage(v64, v63) or ((82 + 4686) <= (91 + 755))) then
					local v232 = 503 - (74 + 429);
					while true do
						if ((v232 == (1 - 0)) or ((1665 + 1693) <= (3250 - 1830))) then
							if ((v62 and v108.EssenceFont:IsReady() and (v13:BuffUp(v108.ThunderFocusTea) or (v108.ThunderFocusTea:CooldownRemains() > (6 + 2)))) or ((11526 - 7787) <= (7430 - 4425))) then
								if (v24(v108.EssenceFont, nil) or ((2092 - (279 + 154)) >= (2912 - (454 + 324)))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if ((v232 == (0 + 0)) or ((3277 - (12 + 5)) < (1270 + 1085))) then
							if ((v36 and (v13:BuffStack(v108.ManaTeaCharges) > v37) and v108.EssenceFont:IsReady() and v108.ManaTea:IsCastable()) or ((1704 - 1035) == (1561 + 2662))) then
								if (v24(v108.ManaTea, nil) or ((2785 - (277 + 816)) < (2512 - 1924))) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v38 and v108.ThunderFocusTea:IsReady() and (v108.EssenceFont:CooldownRemains() < v13:GCD())) or ((5980 - (1058 + 125)) < (685 + 2966))) then
								if (v24(v108.ThunderFocusTea, nil) or ((5152 - (815 + 160)) > (20809 - 15959))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v232 = 2 - 1;
						end
					end
				end
				v137 = 1 + 0;
			end
			if ((v137 == (2 - 1)) or ((2298 - (41 + 1857)) > (3004 - (1222 + 671)))) then
				if (((7885 - 4834) > (1444 - 439)) and v62 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v13:BuffDown(v108.EssenceFontBuff)) then
					if (((4875 - (229 + 953)) <= (6156 - (1111 + 663))) and v24(v108.EssenceFont, nil)) then
						return "EssenceFont healing aoe";
					end
				end
				if ((v67 and v108.ZenPulse:IsReady() and v115.AreUnitsBelowHealthPercentage(v69, v68)) or ((4861 - (874 + 705)) > (574 + 3526))) then
					if (v24(v110.ZenPulseFocus, not v17:IsSpellInRange(v108.ZenPulse)) or ((2443 + 1137) < (5911 - 3067))) then
						return "ZenPulse healing aoe";
					end
				end
				v137 = 1 + 1;
			end
			if (((768 - (642 + 37)) < (1024 + 3466)) and ((1 + 1) == v137)) then
				if ((v70 and v108.SheilunsGift:IsReady() and v108.SheilunsGift:IsCastable() and v115.AreUnitsBelowHealthPercentage(v72, v71)) or ((12510 - 7527) < (2262 - (233 + 221)))) then
					if (((8853 - 5024) > (3318 + 451)) and v24(v108.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v138 = 1541 - (718 + 823);
		while true do
			if (((935 + 550) <= (3709 - (266 + 539))) and (v138 == (0 - 0))) then
				if (((5494 - (636 + 589)) == (10133 - 5864)) and v58 and v108.EnvelopingMist:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 51 - 26) < (3 + 0))) then
					local v233 = 0 + 0;
					while true do
						if (((1402 - (657 + 358)) <= (7365 - 4583)) and (v233 == (0 - 0))) then
							v29 = v115.FocusUnitRefreshableBuff(v108.EnvelopingMist, 1189 - (1151 + 36), 39 + 1, nil, false, 7 + 18);
							if (v29 or ((5671 - 3772) <= (2749 - (1552 + 280)))) then
								return v29;
							end
							v233 = 835 - (64 + 770);
						end
						if (((1 + 0) == v233) or ((9788 - 5476) <= (156 + 720))) then
							if (((3475 - (157 + 1086)) <= (5195 - 2599)) and v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if (((9175 - 7080) < (5653 - 1967)) and v47 and v108.RisingSunKick:IsReady() and (v115.FriendlyUnitsWithBuffCount(v108.EnvelopingMist, false, false, 33 - 8) > (821 - (599 + 220)))) then
					if (v24(v108.RisingSunKick, not v15:IsInMeleeRange(9 - 4)) or ((3526 - (1813 + 118)) >= (3271 + 1203))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v138 = 1218 - (841 + 376);
			end
			if ((v138 == (1 - 0)) or ((1074 + 3545) < (7866 - 4984))) then
				if ((v60 and v108.SoothingMist:IsReady() and v17:BuffUp(v108.ChiHarmonyBuff) and v17:BuffDown(v108.SoothingMist)) or ((1153 - (464 + 395)) >= (12398 - 7567))) then
					if (((975 + 1054) <= (3921 - (467 + 370))) and v24(v110.SoothingMistFocus, not v17:IsSpellInRange(v108.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v126()
		if ((v45 and v108.BlackoutKick:IsReady() and (v13:BuffStack(v108.TeachingsoftheMonastery) >= (5 - 2))) or ((1496 + 541) == (8295 - 5875))) then
			if (((696 + 3762) > (9082 - 5178)) and v24(v108.BlackoutKick, not v15:IsInMeleeRange(525 - (150 + 370)))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((1718 - (74 + 1208)) >= (302 - 179)) and v58 and v108.EnvelopingMist:IsReady() and (v13:BuffStack(v108.InvokeChiJiBuff) == (14 - 11))) then
			if (((356 + 144) < (2206 - (14 + 376))) and (v17:HealthPercentage() <= v59)) then
				if (((6198 - 2624) == (2313 + 1261)) and v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((195 + 26) < (372 + 18)) and v47 and v108.RisingSunKick:IsReady()) then
			if (v24(v108.RisingSunKick, not v15:IsInMeleeRange(14 - 9)) or ((1665 + 548) <= (1499 - (23 + 55)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if (((7247 - 4189) < (3244 + 1616)) and v58 and v108.EnvelopingMist:IsReady() and (v13:BuffStack(v108.InvokeChiJiBuff) >= (2 + 0))) then
			if ((v17:HealthPercentage() <= v59) or ((2009 - 713) >= (1399 + 3047))) then
				if (v24(v110.EnvelopingMistFocus, not v17:IsSpellInRange(v108.EnvelopingMist)) or ((2294 - (652 + 249)) > (12013 - 7524))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v62 and v108.EssenceFont:IsReady() and v108.AncientTeachings:IsAvailable() and v13:BuffDown(v108.AncientTeachings)) or ((6292 - (708 + 1160)) < (73 - 46))) then
			if (v24(v108.EssenceFont, nil) or ((3640 - 1643) > (3842 - (10 + 17)))) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v127()
		local v139 = 0 + 0;
		while true do
			if (((5197 - (1400 + 332)) > (3669 - 1756)) and (v139 == (1910 - (242 + 1666)))) then
				if (((314 + 419) < (667 + 1152)) and (v108.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (22 + 3))) then
					local v234 = 940 - (850 + 90);
					while true do
						if ((v234 == (0 - 0)) or ((5785 - (360 + 1030)) == (4209 + 546))) then
							v29 = v125();
							if (v29 or ((10705 - 6912) < (3258 - 889))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v76 and v108.InvokeChiJiTheRedCrane:IsReady() and v108.InvokeChiJiTheRedCrane:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v78, v77)) or ((5745 - (909 + 752)) == (1488 - (109 + 1114)))) then
					local v235 = 0 - 0;
					while true do
						if (((1697 + 2661) == (4600 - (6 + 236))) and (v235 == (1 + 0))) then
							if ((v108.InvokeChiJiTheRedCrane:IsReady() and (v108.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v108.AncientTeachings) and (v13:BuffStack(v108.TeachingsoftheMonastery) == (6 - 3)) and (v108.SheilunsGift:TimeSinceLastCast() < ((6 - 2) * v13:GCD()))) or ((4271 - (1076 + 57)) < (164 + 829))) then
								if (((4019 - (579 + 110)) > (184 + 2139)) and v24(v108.InvokeChiJiTheRedCrane, nil)) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
						if ((v235 == (0 + 0)) or ((1925 + 1701) == (4396 - (174 + 233)))) then
							if ((v52 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (2 - 1))) or ((1607 - 691) == (1188 + 1483))) then
								local v241 = 1174 - (663 + 511);
								while true do
									if (((243 + 29) == (60 + 212)) and (v241 == (2 - 1))) then
										if (((2574 + 1675) <= (11392 - 6553)) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
									if (((6722 - 3945) < (1527 + 1673)) and (v241 == (0 - 0))) then
										v29 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 5 + 1, 4 + 36, nil, false, 747 - (478 + 244));
										if (((612 - (440 + 77)) < (890 + 1067)) and v29) then
											return v29;
										end
										v241 = 3 - 2;
									end
								end
							end
							if (((2382 - (655 + 901)) < (319 + 1398)) and v70 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (16 + 4))) then
								if (((963 + 463) >= (4451 - 3346)) and v24(v108.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v235 = 1446 - (695 + 750);
						end
					end
				end
				v139 = 9 - 6;
			end
			if (((4250 - 1496) <= (13589 - 10210)) and (v139 == (352 - (285 + 66)))) then
				if ((v81 and v108.Restoral:IsReady() and v108.Restoral:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v83, v82)) or ((9153 - 5226) == (2723 - (682 + 628)))) then
					if (v24(v108.Restoral, nil) or ((187 + 967) <= (1087 - (176 + 123)))) then
						return "Restoral CD";
					end
				end
				if ((v73 and v108.InvokeYulonTheJadeSerpent:IsAvailable() and v108.InvokeYulonTheJadeSerpent:IsReady() and v115.AreUnitsBelowHealthPercentage(v75, v74)) or ((688 + 955) > (2452 + 927))) then
					local v236 = 269 - (239 + 30);
					while true do
						if ((v236 == (1 + 0)) or ((2695 + 108) > (8050 - 3501))) then
							if ((v70 and v108.SheilunsGift:IsReady() and (v108.SheilunsGift:TimeSinceLastCast() > (62 - 42))) or ((535 - (306 + 9)) >= (10545 - 7523))) then
								if (((491 + 2331) == (1732 + 1090)) and v24(v108.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if ((v108.InvokeYulonTheJadeSerpent:IsReady() and (v108.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v108.ManaTeaBuff) and (v108.SheilunsGift:TimeSinceLastCast() < ((11 - 7) * v13:GCD()))) or ((2436 - (1140 + 235)) == (1182 + 675))) then
								if (((2531 + 229) > (351 + 1013)) and v24(v108.InvokeYulonTheJadeSerpent, nil)) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
						if ((v236 == (52 - (33 + 19))) or ((1770 + 3132) <= (10775 - 7180))) then
							if ((v52 and v108.RenewingMist:IsReady() and (v108.RenewingMist:ChargesFractional() >= (1 + 0))) or ((7553 - 3701) == (275 + 18))) then
								local v242 = 689 - (586 + 103);
								while true do
									if ((v242 == (0 + 0)) or ((4799 - 3240) == (6076 - (1309 + 179)))) then
										v29 = v115.FocusUnitRefreshableBuff(v108.RenewingMistBuff, 10 - 4, 18 + 22, nil, false, 67 - 42);
										if (v29 or ((3387 + 1097) == (1673 - 885))) then
											return v29;
										end
										v242 = 1 - 0;
									end
									if (((5177 - (295 + 314)) >= (9596 - 5689)) and (v242 == (1963 - (1300 + 662)))) then
										if (((3912 - 2666) < (5225 - (1178 + 577))) and v24(v110.RenewingMistFocus, not v17:IsSpellInRange(v108.RenewingMist))) then
											return "Renewing Mist YuLon prep";
										end
										break;
									end
								end
							end
							if (((2113 + 1955) >= (2873 - 1901)) and v36 and v108.ManaTea:IsCastable() and (v13:BuffStack(v108.ManaTeaCharges) >= (1408 - (851 + 554))) and v13:BuffDown(v108.ManaTeaBuff)) then
								if (((436 + 57) < (10796 - 6903)) and v24(v108.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v236 = 1 - 0;
						end
					end
				end
				v139 = 304 - (115 + 187);
			end
			if ((v139 == (3 + 0)) or ((1395 + 78) >= (13130 - 9798))) then
				if ((v108.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1186 - (160 + 1001))) or ((3544 + 507) <= (799 + 358))) then
					local v237 = 0 - 0;
					while true do
						if (((962 - (237 + 121)) < (3778 - (525 + 372))) and ((0 - 0) == v237)) then
							v29 = v126();
							if (v29 or ((2957 - 2057) == (3519 - (96 + 46)))) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if (((5236 - (643 + 134)) > (214 + 377)) and (v139 == (0 - 0))) then
				if (((12615 - 9217) >= (2297 + 98)) and v79 and v108.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) then
					if (v24(v110.LifeCocoonFocus, not v17:IsSpellInRange(v108.LifeCocoon)) or ((4283 - 2100) >= (5772 - 2948))) then
						return "Life Cocoon CD";
					end
				end
				if (((2655 - (316 + 403)) == (1287 + 649)) and v81 and v108.Revival:IsReady() and v108.Revival:IsAvailable() and v115.AreUnitsBelowHealthPercentage(v83, v82)) then
					if (v24(v108.Revival, nil) or ((13284 - 8452) < (1559 + 2754))) then
						return "Revival CD";
					end
				end
				v139 = 2 - 1;
			end
		end
	end
	local function v128()
		local v140 = 0 + 0;
		while true do
			if (((1318 + 2770) > (13423 - 9549)) and ((4 - 3) == v140)) then
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v140 = 3 - 1;
			end
			if (((248 + 4084) == (8527 - 4195)) and (v140 == (1 + 4))) then
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v140 = 17 - 11;
			end
			if (((4016 - (12 + 5)) >= (11263 - 8363)) and (v140 == (8 - 4))) then
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v140 = 10 - 5;
			end
			if ((v140 == (0 - 0)) or ((513 + 2012) > (6037 - (1656 + 317)))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v140 = 1 + 0;
			end
			if (((3503 + 868) == (11622 - 7251)) and (v140 == (29 - 23))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v140 = 361 - (5 + 349);
			end
			if ((v140 == (9 - 7)) or ((1537 - (266 + 1005)) > (3286 + 1700))) then
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v140 = 10 - 7;
			end
			if (((2621 - 630) >= (2621 - (561 + 1135))) and (v140 == (3 - 0))) then
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v140 = 12 - 8;
			end
			if (((1521 - (507 + 559)) < (5151 - 3098)) and (v140 == (21 - 14))) then
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
		end
	end
	local function v129()
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
		v103 = EpicSettings.Settings['HandleCharredBrambles'];
		v102 = EpicSettings.Settings['HandleCharredTreant'];
		v104 = EpicSettings.Settings['HandleFyrakkNPC'];
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
	local function v130()
		v128();
		v129();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		if (v13:IsDeadOrGhost() or ((1214 - (212 + 176)) == (5756 - (250 + 655)))) then
			return;
		end
		v112 = v13:GetEnemiesInMeleeRange(21 - 13);
		if (((319 - 136) == (285 - 102)) and v31) then
			v113 = #v112;
		else
			v113 = 1957 - (1869 + 87);
		end
		if (((4019 - 2860) <= (3689 - (484 + 1417))) and (v115.TargetIsValid() or v13:AffectingCombat())) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (0 - 0)) or ((4280 - (48 + 725)) > (7053 - 2735))) then
					v107 = v13:GetEnemiesInRange(107 - 67);
					v105 = v10.BossFightRemains(nil, true);
					v188 = 1 + 0;
				end
				if ((v188 == (2 - 1)) or ((861 + 2214) <= (865 + 2100))) then
					v106 = v105;
					if (((2218 - (152 + 701)) <= (3322 - (430 + 881))) and (v106 == (4256 + 6855))) then
						v106 = v10.FightRemains(v107, false);
					end
					break;
				end
			end
		end
		if (v13:AffectingCombat() or v30 or ((3671 - (557 + 338)) > (1057 + 2518))) then
			local v189 = 0 - 0;
			local v190;
			while true do
				if ((v189 == (0 - 0)) or ((6785 - 4231) == (10353 - 5549))) then
					v190 = v89 and v108.Detox:IsReady() and v33;
					v29 = v115.FocusUnit(v190, nil, nil, nil);
					v189 = 802 - (499 + 302);
				end
				if (((3443 - (39 + 827)) == (7113 - 4536)) and (v189 == (2 - 1))) then
					if (v29 or ((23 - 17) >= (2899 - 1010))) then
						return v29;
					end
					if (((44 + 462) <= (5537 - 3645)) and v33 and v89) then
						if (v17 or ((322 + 1686) > (3509 - 1291))) then
							if (((483 - (103 + 1)) <= (4701 - (475 + 79))) and v108.Detox:IsCastable() and v115.DispellableFriendlyUnit(54 - 29)) then
								if (v24(v110.DetoxFocus, not v17:IsSpellInRange(v108.Detox)) or ((14444 - 9930) <= (131 + 878))) then
									return "detox dispel focus";
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v115.UnitHasDispellableDebuffByPlayer(v16)) or ((3077 + 419) == (2695 - (1395 + 108)))) then
							if (v108.Detox:IsCastable() or ((605 - 397) == (4163 - (7 + 1197)))) then
								if (((1865 + 2412) >= (459 + 854)) and v24(v110.DetoxMouseover, not v16:IsSpellInRange(v108.Detox))) then
									return "detox dispel mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (((2906 - (27 + 292)) < (9300 - 6126)) and not v13:AffectingCombat()) then
			if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((5254 - 1134) <= (9217 - 7019))) then
				local v230 = 0 - 0;
				local v231;
				while true do
					if ((v230 == (0 - 0)) or ((1735 - (43 + 96)) == (3499 - 2641))) then
						v231 = v115.DeadFriendlyUnitsCount();
						if (((7280 - 4060) == (2672 + 548)) and (v231 > (1 + 0))) then
							if (v24(v108.Reawaken, nil) or ((2770 - 1368) > (1388 + 2232))) then
								return "reawaken";
							end
						elseif (((4823 - 2249) == (811 + 1763)) and v24(v110.ResuscitateMouseover, not v15:IsInRange(3 + 37))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if (((3549 - (1414 + 337)) < (4697 - (1642 + 298))) and not v13:AffectingCombat() and v30) then
			v29 = v120();
			if (v29 or ((982 - 605) > (7491 - 4887))) then
				return v29;
			end
		end
		if (((1685 - 1117) < (300 + 611)) and (v30 or v13:AffectingCombat())) then
			local v191 = 0 + 0;
			while true do
				if (((4257 - (357 + 615)) < (2968 + 1260)) and (v191 == (2 - 1))) then
					if (((3356 + 560) > (7131 - 3803)) and v34) then
						local v238 = 0 + 0;
						while true do
							if (((170 + 2330) < (2414 + 1425)) and (v238 == (1302 - (384 + 917)))) then
								if (((1204 - (128 + 569)) == (2050 - (1407 + 136))) and (v106 > v99) and v32) then
									v29 = v127();
									if (((2127 - (687 + 1200)) <= (4875 - (556 + 1154))) and v29) then
										return v29;
									end
								end
								if (((2934 - 2100) >= (900 - (9 + 86))) and v31) then
									local v243 = 421 - (275 + 146);
									while true do
										if ((v243 == (0 + 0)) or ((3876 - (29 + 35)) < (10264 - 7948))) then
											v29 = v124();
											if (v29 or ((7921 - 5269) <= (6767 - 5234))) then
												return v29;
											end
											break;
										end
									end
								end
								v238 = 2 + 0;
							end
							if ((v238 == (1014 - (53 + 959))) or ((4006 - (312 + 96)) < (2534 - 1074))) then
								v29 = v123();
								if (v29 or ((4401 - (147 + 138)) < (2091 - (813 + 86)))) then
									return v29;
								end
								break;
							end
							if ((v238 == (0 + 0)) or ((6256 - 2879) <= (1395 - (18 + 474)))) then
								if (((1342 + 2634) >= (1432 - 993)) and v108.SummonJadeSerpentStatue:IsReady() and v108.SummonJadeSerpentStatue:IsAvailable() and (v108.SummonJadeSerpentStatue:TimeSinceLastCast() > (1176 - (860 + 226))) and v66) then
									if (((4055 - (121 + 182)) == (462 + 3290)) and (v65 == "Player")) then
										if (((5286 - (988 + 252)) > (305 + 2390)) and v24(v110.SummonJadeSerpentStatuePlayer, not v15:IsInRange(13 + 27))) then
											return "jade serpent main player";
										end
									elseif ((v65 == "Cursor") or ((5515 - (49 + 1921)) == (4087 - (223 + 667)))) then
										if (((2446 - (51 + 1)) > (641 - 268)) and v24(v110.SummonJadeSerpentStatueCursor, not v15:IsInRange(85 - 45))) then
											return "jade serpent main cursor";
										end
									elseif (((5280 - (146 + 979)) <= (1195 + 3037)) and (v65 == "Confirmation")) then
										if (v24(v108.SummonJadeSerpentStatue, not v15:IsInRange(645 - (311 + 294))) or ((9986 - 6405) == (1472 + 2001))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if (((6438 - (496 + 947)) > (4706 - (1233 + 125))) and v36 and (v13:BuffStack(v108.ManaTeaCharges) >= (8 + 10)) and v108.ManaTea:IsCastable()) then
									if (v24(v108.ManaTea, nil) or ((677 + 77) > (708 + 3016))) then
										return "Mana Tea main avoid overcap";
									end
								end
								v238 = 1646 - (963 + 682);
							end
						end
					end
					break;
				end
				if (((182 + 35) >= (1561 - (504 + 1000))) and (v191 == (0 + 0))) then
					v29 = v119();
					if (v29 or ((1886 + 184) >= (381 + 3656))) then
						return v29;
					end
					v191 = 1 - 0;
				end
			end
		end
		if (((2312 + 393) == (1574 + 1131)) and (v30 or v13:AffectingCombat()) and v115.TargetIsValid() and v13:CanAttack(v15)) then
			local v192 = 182 - (156 + 26);
			while true do
				if (((36 + 25) == (95 - 34)) and (v192 == (165 - (149 + 15)))) then
					if ((v97 and ((v32 and v98) or not v98)) or ((1659 - (890 + 70)) >= (1413 - (39 + 78)))) then
						local v239 = 482 - (14 + 468);
						while true do
							if ((v239 == (2 - 1)) or ((4983 - 3200) >= (1866 + 1750))) then
								v29 = v115.HandleBottomTrinket(v111, v32, 25 + 15, nil);
								if (v29 or ((832 + 3081) > (2045 + 2482))) then
									return v29;
								end
								break;
							end
							if (((1147 + 3229) > (1563 - 746)) and ((0 + 0) == v239)) then
								v29 = v115.HandleTopTrinket(v111, v32, 140 - 100, nil);
								if (((123 + 4738) > (875 - (12 + 39))) and v29) then
									return v29;
								end
								v239 = 1 + 0;
							end
						end
					end
					if (v35 or ((4280 - 2897) >= (7589 - 5458))) then
						local v240 = 0 + 0;
						while true do
							if ((v240 == (0 + 0)) or ((4756 - 2880) >= (1693 + 848))) then
								if (((8611 - 6829) <= (5482 - (1596 + 114))) and v95 and ((v32 and v96) or not v96) and (v106 < (46 - 28))) then
									local v244 = 713 - (164 + 549);
									while true do
										if ((v244 == (1439 - (1059 + 379))) or ((5836 - 1136) < (422 + 391))) then
											if (((540 + 2659) < (4442 - (145 + 247))) and v108.LightsJudgment:IsCastable()) then
												if (v24(v108.LightsJudgment, not v15:IsInRange(33 + 7)) or ((2288 + 2663) < (13133 - 8703))) then
													return "lights_judgment main 8";
												end
											end
											if (((19 + 77) == (83 + 13)) and v108.Fireblood:IsCastable()) then
												if (v24(v108.Fireblood, nil) or ((4446 - 1707) > (4728 - (254 + 466)))) then
													return "fireblood main 10";
												end
											end
											v244 = 562 - (544 + 16);
										end
										if ((v244 == (0 - 0)) or ((651 - (294 + 334)) == (1387 - (236 + 17)))) then
											if (v108.BloodFury:IsCastable() or ((1161 + 1532) >= (3201 + 910))) then
												if (v24(v108.BloodFury, nil) or ((16254 - 11938) <= (10160 - 8014))) then
													return "blood_fury main 4";
												end
											end
											if (v108.Berserking:IsCastable() or ((1826 + 1720) <= (2314 + 495))) then
												if (((5698 - (413 + 381)) > (92 + 2074)) and v24(v108.Berserking, nil)) then
													return "berserking main 6";
												end
											end
											v244 = 1 - 0;
										end
										if (((282 - 173) >= (2060 - (582 + 1388))) and (v244 == (2 - 0))) then
											if (((3564 + 1414) > (3269 - (326 + 38))) and v108.AncestralCall:IsCastable()) then
												if (v24(v108.AncestralCall, nil) or ((8951 - 5925) <= (3254 - 974))) then
													return "ancestral_call main 12";
												end
											end
											if (v108.BagofTricks:IsCastable() or ((2273 - (47 + 573)) <= (391 + 717))) then
												if (((12354 - 9445) > (4233 - 1624)) and v24(v108.BagofTricks, not v15:IsInRange(1704 - (1269 + 395)))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
									end
								end
								if (((1249 - (76 + 416)) > (637 - (319 + 124))) and v38 and v108.ThunderFocusTea:IsReady() and not v108.EssenceFont:IsAvailable() and (v108.RisingSunKick:CooldownRemains() < v13:GCD())) then
									if (v24(v108.ThunderFocusTea, nil) or ((70 - 39) >= (2405 - (564 + 443)))) then
										return "ThunderFocusTea main 16";
									end
								end
								v240 = 2 - 1;
							end
							if (((3654 - (337 + 121)) <= (14275 - 9403)) and (v240 == (3 - 2))) then
								if (((5237 - (1261 + 650)) == (1408 + 1918)) and (v113 >= (3 - 0)) and v31) then
									local v245 = 1817 - (772 + 1045);
									while true do
										if (((203 + 1230) <= (4022 - (102 + 42))) and (v245 == (1844 - (1524 + 320)))) then
											v29 = v121();
											if (v29 or ((2853 - (1049 + 221)) == (1891 - (18 + 138)))) then
												return v29;
											end
											break;
										end
									end
								end
								if ((v113 < (7 - 4)) or ((4083 - (67 + 1035)) == (2698 - (136 + 212)))) then
									local v246 = 0 - 0;
									while true do
										if ((v246 == (0 + 0)) or ((4117 + 349) <= (2097 - (240 + 1364)))) then
											v29 = v122();
											if (v29 or ((3629 - (1050 + 32)) <= (7094 - 5107))) then
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
				if (((1752 + 1209) > (3795 - (331 + 724))) and (v192 == (0 + 0))) then
					v29 = v118();
					if (((4340 - (269 + 375)) >= (4337 - (267 + 458))) and v29) then
						return v29;
					end
					v192 = 1 + 0;
				end
			end
		end
	end
	local function v131()
		local v179 = 0 - 0;
		while true do
			if ((v179 == (818 - (667 + 151))) or ((4467 - (1410 + 87)) == (3775 - (1504 + 393)))) then
				v117();
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(729 - 459, v130, v131);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

