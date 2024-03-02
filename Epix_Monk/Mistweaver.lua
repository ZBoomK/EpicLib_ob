local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((20 + 1684) < (4451 - 2938))) then
			v6 = v0[v4];
			if (((488 + 199) == (1337 - 650)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1481 - (641 + 839))) or ((1569 - (910 + 3)) >= (8489 - 5159))) then
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
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111 = 12795 - (1466 + 218);
	local v112 = 5107 + 6004;
	local v113;
	local v114 = v18.Monk.Mistweaver;
	local v115 = v20.Monk.Mistweaver;
	local v116 = v25.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = {{v114.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v114.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v121 = v22.Commons.Everyone;
	local v122 = v22.Commons.Monk;
	local function v123()
		if (v114.ImprovedDetox:IsAvailable() or ((221 + 2271) <= (1812 - (29 + 1448)))) then
			v121.DispellableDebuffs = v21.MergeTable(v121.DispellableMagicDebuffs, v121.DispellablePoisonDebuffs, v121.DispellableDiseaseDebuffs);
		else
			v121.DispellableDebuffs = v121.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v123();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v124()
		local v139 = 1389 - (135 + 1254);
		while true do
			if (((16281 - 11959) >= (11962 - 9400)) and (v139 == (2 + 0))) then
				if ((v86 and (v13:HealthPercentage() <= v87)) or ((5164 - (389 + 1138)) >= (4344 - (102 + 472)))) then
					local v233 = 0 + 0;
					while true do
						if ((v233 == (0 + 0)) or ((2219 + 160) > (6123 - (320 + 1225)))) then
							if ((v88 == "Refreshing Healing Potion") or ((859 - 376) > (455 + 288))) then
								if (((3918 - (157 + 1307)) > (2437 - (821 + 1038))) and v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) then
									if (((2320 - 1390) < (488 + 3970)) and v24(v116.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 5";
									end
								end
							end
							if (((1175 - 513) <= (362 + 610)) and (v88 == "Dreamwalker's Healing Potion")) then
								if (((10831 - 6461) == (5396 - (834 + 192))) and v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) then
									if (v24(v116.RefreshingHealingPotion) or ((303 + 4459) <= (221 + 640))) then
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
			if ((v139 == (0 + 0)) or ((2186 - 774) == (4568 - (300 + 4)))) then
				if ((v114.DampenHarm:IsCastable() and v13:BuffDown(v114.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((847 + 2321) < (5635 - 3482))) then
					if (v24(v114.DampenHarm, nil) or ((5338 - (112 + 250)) < (531 + 801))) then
						return "dampen_harm defensives 1";
					end
				end
				if (((11593 - 6965) == (2652 + 1976)) and v114.FortifyingBrew:IsCastable() and v13:BuffDown(v114.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) then
					if (v24(v114.FortifyingBrew, nil) or ((28 + 26) == (296 + 99))) then
						return "fortifying_brew defensives 2";
					end
				end
				v139 = 1 + 0;
			end
			if (((61 + 21) == (1496 - (1001 + 413))) and (v139 == (2 - 1))) then
				if ((v114.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v114.ChiHarmonyBuff)) or ((1463 - (244 + 638)) < (975 - (627 + 66)))) then
					if (v24(v114.ExpelHarm, nil) or ((13732 - 9123) < (3097 - (512 + 90)))) then
						return "expel_harm defensives 3";
					end
				end
				if (((3058 - (1665 + 241)) == (1869 - (373 + 344))) and v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v13:HealthPercentage() <= v85)) then
					if (((856 + 1040) <= (906 + 2516)) and v24(v116.Healthstone)) then
						return "healthstone defensive 4";
					end
				end
				v139 = 5 - 3;
			end
		end
	end
	local function v125()
		local v140 = 0 - 0;
		while true do
			if ((v140 == (1099 - (35 + 1064))) or ((721 + 269) > (3466 - 1846))) then
				if (v102 or ((4 + 873) > (5931 - (298 + 938)))) then
					local v234 = 1259 - (233 + 1026);
					while true do
						if (((4357 - (636 + 1030)) >= (947 + 904)) and (v234 == (0 + 0))) then
							v29 = v121.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 9 + 21, true);
							if (v29 or ((202 + 2783) >= (5077 - (55 + 166)))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((829 + 3447) >= (121 + 1074)) and v101) then
					v29 = v121.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 114 - 84);
					if (((3529 - (36 + 261)) <= (8202 - 3512)) and v29) then
						return v29;
					end
				end
				v140 = 1369 - (34 + 1334);
			end
			if ((v140 == (1 + 1)) or ((697 + 199) >= (4429 - (1035 + 248)))) then
				if (((3082 - (20 + 1)) >= (1542 + 1416)) and v105) then
					local v235 = 319 - (134 + 185);
					while true do
						if (((4320 - (549 + 584)) >= (1329 - (314 + 371))) and (v235 == (6 - 4))) then
							v29 = v121.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 1008 - (478 + 490));
							if (((342 + 302) <= (1876 - (786 + 386))) and v29) then
								return v29;
							end
							v235 = 9 - 6;
						end
						if (((2337 - (1055 + 324)) > (2287 - (1093 + 247))) and (v235 == (1 + 0))) then
							v29 = v121.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 5 + 35);
							if (((17834 - 13342) >= (9007 - 6353)) and v29) then
								return v29;
							end
							v235 = 5 - 3;
						end
						if (((8649 - 5207) >= (535 + 968)) and (v235 == (11 - 8))) then
							v29 = v121.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 137 - 97);
							if (v29 or ((2391 + 779) <= (3743 - 2279))) then
								return v29;
							end
							break;
						end
						if ((v235 == (688 - (364 + 324))) or ((13150 - 8353) == (10529 - 6141))) then
							v29 = v121.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 14 + 26);
							if (((2305 - 1754) <= (1090 - 409)) and v29) then
								return v29;
							end
							v235 = 2 - 1;
						end
					end
				end
				if (((4545 - (1249 + 19)) > (368 + 39)) and v106) then
					local v236 = 0 - 0;
					while true do
						if (((5781 - (686 + 400)) >= (1111 + 304)) and (v236 == (231 - (73 + 156)))) then
							v29 = v121.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 1 + 39);
							if (v29 or ((4023 - (721 + 90)) <= (11 + 933))) then
								return v29;
							end
							v236 = 9 - 6;
						end
						if ((v236 == (470 - (224 + 246))) or ((5015 - 1919) <= (3310 - 1512))) then
							v29 = v121.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 8 + 32);
							if (((85 + 3452) == (2598 + 939)) and v29) then
								return v29;
							end
							v236 = 1 - 0;
						end
						if (((12768 - 8931) >= (2083 - (203 + 310))) and ((1996 - (1238 + 755)) == v236)) then
							v29 = v121.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 3 + 37);
							if (v29 or ((4484 - (709 + 825)) == (7024 - 3212))) then
								return v29;
							end
							break;
						end
						if (((6879 - 2156) >= (3182 - (196 + 668))) and (v236 == (3 - 2))) then
							v29 = v121.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 82 - 42);
							if (v29 or ((2860 - (171 + 662)) > (2945 - (4 + 89)))) then
								return v29;
							end
							v236 = 6 - 4;
						end
					end
				end
				break;
			end
			if ((v140 == (1 + 0)) or ((4989 - 3853) > (1693 + 2624))) then
				if (((6234 - (35 + 1451)) == (6201 - (28 + 1425))) and v103) then
					local v237 = 1993 - (941 + 1052);
					while true do
						if (((3583 + 153) <= (6254 - (822 + 692))) and ((1 - 0) == v237)) then
							v29 = v121.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 19 + 21);
							if (v29 or ((3687 - (45 + 252)) <= (3028 + 32))) then
								return v29;
							end
							break;
						end
						if ((v237 == (0 + 0)) or ((2430 - 1431) > (3126 - (114 + 319)))) then
							v29 = v121.HandleChromie(v114.Riptide, v116.RiptideMouseover, 57 - 17);
							if (((592 - 129) < (384 + 217)) and v29) then
								return v29;
							end
							v237 = 1 - 0;
						end
					end
				end
				if (v104 or ((4573 - 2390) < (2650 - (556 + 1407)))) then
					local v238 = 1206 - (741 + 465);
					while true do
						if (((5014 - (170 + 295)) == (2397 + 2152)) and ((0 + 0) == v238)) then
							v29 = v121.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 98 - 58);
							if (((3873 + 799) == (2997 + 1675)) and v29) then
								return v29;
							end
							v238 = 1 + 0;
						end
						if ((v238 == (1232 - (957 + 273))) or ((982 + 2686) < (159 + 236))) then
							v29 = v121.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 152 - 112);
							if (v29 or ((10978 - 6812) == (1389 - 934))) then
								return v29;
							end
							v238 = 14 - 11;
						end
						if (((1781 - (389 + 1391)) == v238) or ((2792 + 1657) == (278 + 2385))) then
							v29 = v121.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 91 - 51);
							if (v29 or ((5228 - (783 + 168)) < (10031 - 7042))) then
								return v29;
							end
							v238 = 2 + 0;
						end
						if (((314 - (309 + 2)) == v238) or ((2671 - 1801) >= (5361 - (1090 + 122)))) then
							v29 = v121.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 13 + 27);
							if (((7428 - 5216) < (2179 + 1004)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v140 = 1120 - (628 + 490);
			end
		end
	end
	local function v126()
		if (((834 + 3812) > (7407 - 4415)) and v114.ChiBurst:IsCastable() and v50) then
			if (((6553 - 5119) < (3880 - (431 + 343))) and v24(v114.ChiBurst, not v15:IsInRange(80 - 40))) then
				return "chi_burst precombat 4";
			end
		end
		if (((2273 - 1487) < (2389 + 634)) and v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (1 + 1))) then
			if (v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(1703 - (556 + 1139))) or ((2457 - (6 + 9)) < (14 + 60))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if (((2324 + 2211) == (4704 - (28 + 141))) and v114.TigerPalm:IsCastable() and v48) then
			if (v24(v114.TigerPalm, not v15:IsInMeleeRange(2 + 3)) or ((3713 - 704) <= (1491 + 614))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v127()
		if (((3147 - (486 + 831)) < (9547 - 5878)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (10 - 7)) and v44) then
			if ((v43 == "Player") or ((271 + 1159) >= (11420 - 7808))) then
				if (((3946 - (668 + 595)) >= (2214 + 246)) and v24(v116.SummonWhiteTigerStatuePlayer, not v15:IsInRange(9 + 31))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v43 == "Cursor") or ((4919 - 3115) >= (3565 - (23 + 267)))) then
				if (v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(1984 - (1129 + 815))) or ((1804 - (371 + 16)) > (5379 - (1326 + 424)))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((9081 - 4286) > (1468 - 1066)) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
				if (((4931 - (88 + 30)) > (4336 - (720 + 51))) and v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(88 - 48))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((5688 - (421 + 1355)) == (6453 - 2541)) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
				if (((1386 + 1435) <= (5907 - (286 + 797))) and v24(v116.SummonWhiteTigerStatueCursor, not v15:IsInRange(146 - 106))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((2878 - 1140) <= (2634 - (397 + 42))) and (v43 == "Confirmation")) then
				if (((13 + 28) <= (3818 - (24 + 776))) and v24(v116.SummonWhiteTigerStatue, not v15:IsInRange(61 - 21))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((2930 - (222 + 563)) <= (9042 - 4938)) and v114.TouchofDeath:IsCastable() and v51) then
			if (((1937 + 752) < (5035 - (23 + 167))) and v24(v114.TouchofDeath, not v15:IsInMeleeRange(1803 - (690 + 1108)))) then
				return "touch_of_death aoe 2";
			end
		end
		if ((v114.JadefireStomp:IsReady() and v49) or ((838 + 1484) > (2163 + 459))) then
			if (v24(v114.JadefireStomp, nil) or ((5382 - (40 + 808)) == (343 + 1739))) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v114.ChiBurst:IsCastable() and v50) or ((6007 - 4436) > (1785 + 82))) then
			if (v24(v114.ChiBurst, not v15:IsInRange(22 + 18)) or ((1456 + 1198) >= (3567 - (47 + 524)))) then
				return "chi_burst aoe 4";
			end
		end
		if (((2582 + 1396) > (5751 - 3647)) and v114.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v114.MysticTouchDebuff) and v114.MysticTouch:IsAvailable()) then
			if (((4478 - 1483) > (3514 - 1973)) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(1734 - (1165 + 561)))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((97 + 3152) > (2951 - 1998)) and v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v13:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (2 + 1))) then
			if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(484 - (341 + 138))) or ((884 + 2389) > (9437 - 4864))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (326 - (89 + 237))) and v48 and (v119 >= (9 - 6))) or ((6633 - 3482) < (2165 - (581 + 300)))) then
			if (v24(v114.TigerPalm, not v15:IsInMeleeRange(1225 - (855 + 365))) or ((4394 - 2544) == (500 + 1029))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((2056 - (1030 + 205)) < (1994 + 129)) and v114.SpinningCraneKick:IsCastable() and v46) then
			if (((840 + 62) < (2611 - (156 + 130))) and v24(v114.SpinningCraneKick, not v15:IsInMeleeRange(17 - 9))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v128()
		local v141 = 0 - 0;
		while true do
			if (((1757 - 899) <= (781 + 2181)) and (v141 == (2 + 0))) then
				if ((v114.BlackoutKick:IsCastable() and (v13:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (72 - (10 + 59))) and (v114.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) or ((1117 + 2829) < (6343 - 5055))) then
					if (v24(v114.BlackoutKick, not v15:IsInMeleeRange(1168 - (671 + 492))) or ((2581 + 661) == (1782 - (369 + 846)))) then
						return "blackout_kick st 5";
					end
				end
				if ((v114.TigerPalm:IsCastable() and ((v13:BuffStack(v114.TeachingsoftheMonasteryBuff) < (1 + 2)) or (v13:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (2 + 0))) and v48) or ((2792 - (1036 + 909)) >= (1005 + 258))) then
					if (v24(v114.TigerPalm, not v15:IsInMeleeRange(8 - 3)) or ((2456 - (11 + 192)) == (936 + 915))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if ((v141 == (176 - (135 + 40))) or ((5056 - 2969) > (1430 + 942))) then
				if ((v114.RisingSunKick:IsReady() and v47) or ((9792 - 5347) < (6219 - 2070))) then
					if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(181 - (50 + 126))) or ((5062 - 3244) == (19 + 66))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((2043 - (1233 + 180)) < (3096 - (522 + 447))) and v114.ChiBurst:IsCastable() and v50) then
					if (v24(v114.ChiBurst, not v15:IsInRange(1461 - (107 + 1314))) or ((900 + 1038) == (7660 - 5146))) then
						return "chi_burst st 4";
					end
				end
				v141 = 1 + 1;
			end
			if (((8449 - 4194) >= (217 - 162)) and (v141 == (1910 - (716 + 1194)))) then
				if (((52 + 2947) > (124 + 1032)) and v114.TouchofDeath:IsCastable() and v51) then
					if (((2853 - (74 + 429)) > (2228 - 1073)) and v24(v114.TouchofDeath, not v15:IsInMeleeRange(3 + 2))) then
						return "touch_of_death st 1";
					end
				end
				if (((9222 - 5193) <= (3434 + 1419)) and v114.JadefireStomp:IsReady() and v49) then
					if (v24(v114.JadefireStomp, nil) or ((1590 - 1074) > (8490 - 5056))) then
						return "JadefireStomp st 2";
					end
				end
				v141 = 434 - (279 + 154);
			end
		end
	end
	local function v129()
		local v142 = 778 - (454 + 324);
		while true do
			if (((3184 + 862) >= (3050 - (12 + 5))) and (v142 == (2 + 0))) then
				if ((v60 and v114.SoothingMist:IsReady() and v17:BuffDown(v114.SoothingMist)) or ((6927 - 4208) <= (535 + 912))) then
					if ((v17:HealthPercentage() <= v61) or ((5227 - (277 + 816)) < (16775 - 12849))) then
						if (v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist)) or ((1347 - (1058 + 125)) >= (523 + 2262))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((976 - (815 + 160)) == v142) or ((2252 - 1727) == (5006 - 2897))) then
				if (((8 + 25) == (96 - 63)) and v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff)) then
					if (((4952 - (41 + 1857)) <= (5908 - (1222 + 671))) and (v17:HealthPercentage() <= v53)) then
						if (((4835 - 2964) < (4860 - 1478)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((2475 - (229 + 953)) <= (3940 - (1111 + 663))) and v56 and v114.Vivify:IsReady() and v13:BuffUp(v114.VivaciousVivificationBuff)) then
					if ((v17:HealthPercentage() <= v57) or ((4158 - (874 + 705)) < (18 + 105))) then
						if (v24(v116.VivifyFocus, not v17:IsSpellInRange(v114.Vivify)) or ((578 + 268) >= (4922 - 2554))) then
							return "Vivify instant healing st";
						end
					end
				end
				v142 = 1 + 1;
			end
			if ((v142 == (679 - (642 + 37))) or ((915 + 3097) <= (538 + 2820))) then
				if (((3750 - 2256) <= (3459 - (233 + 221))) and v52 and v114.RenewingMist:IsReady() and v17:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (2.8 - 1))) then
					if ((v17:HealthPercentage() <= v53) or ((2739 + 372) == (3675 - (718 + 823)))) then
						if (((1482 + 873) == (3160 - (266 + 539))) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v47 and v114.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 70 - 45) > (1226 - (636 + 589)))) or ((1395 - 807) <= (890 - 458))) then
					if (((3802 + 995) >= (1416 + 2479)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(1020 - (657 + 358)))) then
						return "RisingSunKick healing st";
					end
				end
				v142 = 2 - 1;
			end
		end
	end
	local function v130()
		local v143 = 0 - 0;
		while true do
			if (((4764 - (1151 + 36)) == (3455 + 122)) and (v143 == (0 + 0))) then
				if (((11330 - 7536) > (5525 - (1552 + 280))) and v47 and v114.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 859 - (64 + 770)) > (1 + 0))) then
					if (v24(v114.RisingSunKick, not v15:IsInMeleeRange(11 - 6)) or ((227 + 1048) == (5343 - (157 + 1086)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v121.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist) or ((3184 - 1593) >= (15679 - 12099))) then
					local v239 = 0 - 0;
					while true do
						if (((1340 - 357) <= (2627 - (599 + 220))) and (v239 == (1 - 0))) then
							if ((v62 and v114.EssenceFont:IsReady() and (v13:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (1939 - (1813 + 118))))) or ((1572 + 578) <= (2414 - (841 + 376)))) then
								if (((5280 - 1511) >= (273 + 900)) and v24(v114.EssenceFont, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if (((4053 - 2568) == (2344 - (464 + 395))) and v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.EssenceFontBuff)) then
								if (v24(v114.EssenceFont, nil) or ((8507 - 5192) <= (1337 + 1445))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if ((v239 == (837 - (467 + 370))) or ((1809 - 933) >= (2176 + 788))) then
							if ((v36 and (v13:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable()) or ((7651 - 5419) > (390 + 2107))) then
								if (v24(v114.ManaTea, nil) or ((4909 - 2799) <= (852 - (150 + 370)))) then
									return "EssenceFont healing aoe";
								end
							end
							if (((4968 - (74 + 1208)) > (7801 - 4629)) and v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v13:GCD())) then
								if (v24(v114.ThunderFocusTea, nil) or ((21218 - 16744) < (584 + 236))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v239 = 391 - (14 + 376);
						end
					end
				end
				v143 = 1 - 0;
			end
			if (((2769 + 1510) >= (2532 + 350)) and (v143 == (1 + 0))) then
				if ((v67 and v114.ZenPulse:IsReady() and v121.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) or ((5945 - 3916) >= (2649 + 872))) then
					if (v24(v116.ZenPulseFocus, not v17:IsSpellInRange(v114.ZenPulse)) or ((2115 - (23 + 55)) >= (11000 - 6358))) then
						return "ZenPulse healing aoe";
					end
				end
				if (((1148 + 572) < (4004 + 454)) and v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v121.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) then
					if (v24(v114.SheilunsGift, nil) or ((675 - 239) > (951 + 2070))) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v144 = 901 - (652 + 249);
		while true do
			if (((1908 - 1195) <= (2715 - (708 + 1160))) and (v144 == (0 - 0))) then
				if (((3926 - 1772) <= (4058 - (10 + 17))) and v58 and v114.EnvelopingMist:IsReady() and (v121.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 6 + 19) < (1735 - (1400 + 332)))) then
					v29 = v121.FocusUnitRefreshableBuff(v114.EnvelopingMist, 3 - 1, 1948 - (242 + 1666), nil, false, 11 + 14, v114.EnvelopingMist);
					if (((1692 + 2923) == (3934 + 681)) and v29) then
						return v29;
					end
					if (v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist)) or ((4730 - (850 + 90)) == (875 - 375))) then
						return "Enveloping Mist YuLon";
					end
				end
				if (((1479 - (360 + 1030)) < (196 + 25)) and v47 and v114.RisingSunKick:IsReady() and (v121.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 70 - 45) > (2 - 0))) then
					if (((3715 - (909 + 752)) >= (2644 - (109 + 1114))) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(9 - 4))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v144 = 1 + 0;
			end
			if (((934 - (6 + 236)) < (1927 + 1131)) and (v144 == (1 + 0))) then
				if ((v60 and v114.SoothingMist:IsReady() and v17:BuffUp(v114.ChiHarmonyBuff) and v17:BuffDown(v114.SoothingMist)) or ((7673 - 4419) == (2890 - 1235))) then
					if (v24(v116.SoothingMistFocus, not v17:IsSpellInRange(v114.SoothingMist)) or ((2429 - (1076 + 57)) == (808 + 4102))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v132()
		if (((4057 - (579 + 110)) == (266 + 3102)) and v45 and v114.BlackoutKick:IsReady() and (v13:BuffStack(v114.TeachingsoftheMonastery) >= (3 + 0))) then
			if (((1403 + 1240) < (4222 - (174 + 233))) and v24(v114.BlackoutKick, not v15:IsInMeleeRange(13 - 8))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((3357 - 1444) > (220 + 273)) and v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) == (1177 - (663 + 511)))) then
			if (((4243 + 512) > (745 + 2683)) and (v17:HealthPercentage() <= v59)) then
				if (((4257 - 2876) <= (1435 + 934)) and v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v47 and v114.RisingSunKick:IsReady()) or ((11401 - 6558) == (9886 - 5802))) then
			if (((2228 + 2441) > (706 - 343)) and v24(v114.RisingSunKick, not v15:IsInMeleeRange(4 + 1))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v58 and v114.EnvelopingMist:IsReady() and (v13:BuffStack(v114.InvokeChiJiBuff) >= (1 + 1))) or ((2599 - (478 + 244)) >= (3655 - (440 + 77)))) then
			if (((2157 + 2585) >= (13271 - 9645)) and (v17:HealthPercentage() <= v59)) then
				if (v24(v116.EnvelopingMistFocus, not v17:IsSpellInRange(v114.EnvelopingMist)) or ((6096 - (655 + 901)) == (170 + 746))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v13:BuffDown(v114.AncientTeachings)) or ((885 + 271) > (2934 + 1411))) then
			if (((9011 - 6774) < (5694 - (695 + 750))) and v24(v114.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v133()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (1 - 0)) or ((10790 - 8107) < (374 - (285 + 66)))) then
				if (((1624 - 927) <= (2136 - (682 + 628))) and v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
					if (((179 + 926) <= (1475 - (176 + 123))) and v24(v114.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((1414 + 1965) <= (2766 + 1046)) and v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and v121.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist)) then
					local v240 = 269 - (239 + 30);
					while true do
						if ((v240 == (1 + 0)) or ((758 + 30) >= (2859 - 1243))) then
							if (((5784 - 3930) <= (3694 - (306 + 9))) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (69 - 49))) then
								if (((792 + 3757) == (2792 + 1757)) and v24(v114.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if ((v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v114.ManaTeaBuff) and (v114.SheilunsGift:TimeSinceLastCast() < ((11 - 7) * v13:GCD()))) or ((4397 - (1140 + 235)) >= (1925 + 1099))) then
								if (((4421 + 399) > (565 + 1633)) and v24(v114.InvokeYulonTheJadeSerpent, nil)) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
						if ((v240 == (52 - (33 + 19))) or ((384 + 677) >= (14659 - 9768))) then
							if (((601 + 763) <= (8771 - 4298)) and v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1 + 0))) then
								local v250 = 689 - (586 + 103);
								while true do
									if ((v250 == (0 + 0)) or ((11067 - 7472) <= (1491 - (1309 + 179)))) then
										v29 = v121.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 10 - 4, 18 + 22, nil, false, 67 - 42, v114.EnvelopingMist);
										if (v29 or ((3529 + 1143) == (8183 - 4331))) then
											return v29;
										end
										v250 = 1 - 0;
									end
									if (((2168 - (295 + 314)) == (3828 - 2269)) and (v250 == (1963 - (1300 + 662)))) then
										if (v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist)) or ((5501 - 3749) <= (2543 - (1178 + 577)))) then
											return "Renewing Mist YuLon prep";
										end
										break;
									end
								end
							end
							if ((v36 and v114.ManaTea:IsCastable() and (v13:BuffStack(v114.ManaTeaCharges) >= (2 + 1)) and v13:BuffDown(v114.ManaTeaBuff)) or ((11549 - 7642) == (1582 - (851 + 554)))) then
								if (((3069 + 401) > (1539 - 984)) and v24(v114.ManaTea, nil)) then
									return "ManaTea YuLon prep";
								end
							end
							v240 = 1 - 0;
						end
					end
				end
				v145 = 304 - (115 + 187);
			end
			if ((v145 == (2 + 0)) or ((921 + 51) == (2541 - 1896))) then
				if (((4343 - (160 + 1001)) >= (1851 + 264)) and (v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (18 + 7))) then
					v29 = v131();
					if (((7969 - 4076) < (4787 - (237 + 121))) and v29) then
						return v29;
					end
				end
				if ((v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist)) or ((3764 - (525 + 372)) < (3611 - 1706))) then
					local v241 = 0 - 0;
					while true do
						if (((142 - (96 + 46)) == v241) or ((2573 - (643 + 134)) >= (1463 + 2588))) then
							if (((3881 - 2262) <= (13944 - 10188)) and v52 and v114.RenewingMist:IsReady() and (v114.RenewingMist:ChargesFractional() >= (1 + 0))) then
								local v251 = 0 - 0;
								while true do
									if (((1234 - 630) == (1323 - (316 + 403))) and ((0 + 0) == v251)) then
										v29 = v121.FocusUnitRefreshableBuff(v114.RenewingMistBuff, 16 - 10, 15 + 25, nil, false, 62 - 37, v114.EnvelopingMist);
										if (v29 or ((3178 + 1306) == (291 + 609))) then
											return v29;
										end
										v251 = 3 - 2;
									end
									if (((4 - 3) == v251) or ((9262 - 4803) <= (64 + 1049))) then
										if (((7149 - 3517) > (166 + 3232)) and v24(v116.RenewingMistFocus, not v17:IsSpellInRange(v114.RenewingMist))) then
											return "Renewing Mist ChiJi prep";
										end
										break;
									end
								end
							end
							if (((12009 - 7927) <= (4934 - (12 + 5))) and v70 and v114.SheilunsGift:IsReady() and (v114.SheilunsGift:TimeSinceLastCast() > (77 - 57))) then
								if (((10309 - 5477) >= (2946 - 1560)) and v24(v114.SheilunsGift, nil)) then
									return "Sheilun's Gift ChiJi prep";
								end
							end
							v241 = 2 - 1;
						end
						if (((28 + 109) == (2110 - (1656 + 317))) and (v241 == (1 + 0))) then
							if ((v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v114.AncientTeachings) and (v13:BuffStack(v114.TeachingsoftheMonastery) == (7 - 4)) and (v114.SheilunsGift:TimeSinceLastCast() < ((19 - 15) * v13:GCD()))) or ((1924 - (5 + 349)) >= (20576 - 16244))) then
								if (v24(v114.InvokeChiJiTheRedCrane, nil) or ((5335 - (266 + 1005)) <= (1199 + 620))) then
									return "Invoke Chi'ji GO";
								end
							end
							break;
						end
					end
				end
				v145 = 10 - 7;
			end
			if ((v145 == (0 - 0)) or ((6682 - (561 + 1135)) < (2050 - 476))) then
				if (((14548 - 10122) > (1238 - (507 + 559))) and v79 and v114.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) then
					if (((1470 - 884) > (1407 - 952)) and v24(v116.LifeCocoonFocus, not v17:IsSpellInRange(v114.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if (((1214 - (212 + 176)) == (1731 - (250 + 655))) and v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v121.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
					if (v24(v114.Revival, nil) or ((10959 - 6940) > (7759 - 3318))) then
						return "Revival CD";
					end
				end
				v145 = 1 - 0;
			end
			if (((3973 - (1869 + 87)) < (14778 - 10517)) and ((1904 - (484 + 1417)) == v145)) then
				if (((10108 - 5392) > (134 - 54)) and (v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (798 - (48 + 725)))) then
					local v242 = 0 - 0;
					while true do
						if ((v242 == (0 - 0)) or ((2039 + 1468) == (8743 - 5471))) then
							v29 = v132();
							if (v29 or ((246 + 630) >= (897 + 2178))) then
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
	local function v134()
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
	local function v135()
		v96 = EpicSettings.Settings['racialsWithCD'];
		v95 = EpicSettings.Settings['useRacials'];
		v98 = EpicSettings.Settings['trinketsWithCD'];
		v97 = EpicSettings.Settings['useTrinkets'];
		v99 = EpicSettings.Settings['fightRemainsCheck'];
		v100 = EpicSettings.Settings['useWeapon'];
		v89 = EpicSettings.Settings['dispelDebuffs'];
		v86 = EpicSettings.Settings['useHealingPotion'];
		v87 = EpicSettings.Settings['healingPotionHP'];
		v88 = EpicSettings.Settings['HealingPotionName'];
		v84 = EpicSettings.Settings['useHealthstone'];
		v85 = EpicSettings.Settings['healthstoneHP'];
		v107 = EpicSettings.Settings['useManaPotion'];
		v108 = EpicSettings.Settings['manaPotionSlider'];
		v109 = EpicSettings.Settings['RevivalBurstingGroup'];
		v110 = EpicSettings.Settings['RevivalBurstingStacks'];
		v92 = EpicSettings.Settings['InterruptThreshold'];
		v90 = EpicSettings.Settings['InterruptWithStun'];
		v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v93 = EpicSettings.Settings['useSpearHandStrike'];
		v94 = EpicSettings.Settings['useLegSweep'];
		v101 = EpicSettings.Settings['handleAfflicted'];
		v102 = EpicSettings.Settings['HandleIncorporeal'];
		v103 = EpicSettings.Settings['HandleChromie'];
		v105 = EpicSettings.Settings['HandleCharredBrambles'];
		v104 = EpicSettings.Settings['HandleCharredTreant'];
		v106 = EpicSettings.Settings['HandleFyrakkNPC'];
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
	local v136 = 853 - (152 + 701);
	local function v137()
		local v221 = 1311 - (430 + 881);
		while true do
			if (((1667 + 2685) > (3449 - (557 + 338))) and (v221 == (2 + 4))) then
				if (((v30 or v13:AffectingCombat()) and v121.TargetIsValid() and v13:CanAttack(v15)) or ((12416 - 8010) < (14157 - 10114))) then
					v29 = v124();
					if (v29 or ((5018 - 3129) >= (7290 - 3907))) then
						return v29;
					end
					if (((2693 - (499 + 302)) <= (3600 - (39 + 827))) and v97 and ((v32 and v98) or not v98)) then
						local v245 = 0 - 0;
						while true do
							if (((4294 - 2371) < (8809 - 6591)) and (v245 == (0 - 0))) then
								v29 = v121.HandleTopTrinket(v117, v32, 4 + 36, nil);
								if (((6360 - 4187) > (61 + 318)) and v29) then
									return v29;
								end
								v245 = 1 - 0;
							end
							if ((v245 == (105 - (103 + 1))) or ((3145 - (475 + 79)) == (7369 - 3960))) then
								v29 = v121.HandleBottomTrinket(v117, v32, 128 - 88, nil);
								if (((584 + 3930) > (2926 + 398)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (v35 or ((1711 - (1395 + 108)) >= (14049 - 9221))) then
						local v246 = 1204 - (7 + 1197);
						while true do
							if ((v246 == (1 + 0)) or ((553 + 1030) > (3886 - (27 + 292)))) then
								if (((v119 >= (8 - 5)) and v31) or ((1673 - 360) == (3329 - 2535))) then
									local v252 = 0 - 0;
									while true do
										if (((6044 - 2870) > (3041 - (43 + 96))) and (v252 == (0 - 0))) then
											v29 = v127();
											if (((9314 - 5194) <= (3535 + 725)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								if ((v119 < (1 + 2)) or ((1745 - 862) > (1832 + 2946))) then
									local v253 = 0 - 0;
									while true do
										if ((v253 == (0 + 0)) or ((266 + 3354) >= (6642 - (1414 + 337)))) then
											v29 = v128();
											if (((6198 - (1642 + 298)) > (2442 - 1505)) and v29) then
												return v29;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v246 == (0 - 0)) or ((14448 - 9579) < (299 + 607))) then
								if ((v95 and ((v32 and v96) or not v96) and (v112 < (15 + 3))) or ((2197 - (357 + 615)) > (2968 + 1260))) then
									local v254 = 0 - 0;
									while true do
										if (((2852 + 476) > (4795 - 2557)) and (v254 == (2 + 0))) then
											if (((261 + 3578) > (884 + 521)) and v114.AncestralCall:IsCastable()) then
												if (v24(v114.AncestralCall, nil) or ((2594 - (384 + 917)) <= (1204 - (128 + 569)))) then
													return "ancestral_call main 12";
												end
											end
											if (v114.BagofTricks:IsCastable() or ((4439 - (1407 + 136)) < (2692 - (687 + 1200)))) then
												if (((4026 - (556 + 1154)) == (8147 - 5831)) and v24(v114.BagofTricks, not v15:IsInRange(135 - (9 + 86)))) then
													return "bag_of_tricks main 14";
												end
											end
											break;
										end
										if ((v254 == (422 - (275 + 146))) or ((418 + 2152) == (1597 - (29 + 35)))) then
											if (v114.LightsJudgment:IsCastable() or ((3913 - 3030) == (4360 - 2900))) then
												if (v24(v114.LightsJudgment, not v15:IsInRange(176 - 136)) or ((3009 + 1610) <= (2011 - (53 + 959)))) then
													return "lights_judgment main 8";
												end
											end
											if (v114.Fireblood:IsCastable() or ((3818 - (312 + 96)) > (7143 - 3027))) then
												if (v24(v114.Fireblood, nil) or ((1188 - (147 + 138)) >= (3958 - (813 + 86)))) then
													return "fireblood main 10";
												end
											end
											v254 = 2 + 0;
										end
										if ((v254 == (0 - 0)) or ((4468 - (18 + 474)) < (964 + 1893))) then
											if (((16090 - 11160) > (3393 - (860 + 226))) and v114.BloodFury:IsCastable()) then
												if (v24(v114.BloodFury, nil) or ((4349 - (121 + 182)) < (159 + 1132))) then
													return "blood_fury main 4";
												end
											end
											if (v114.Berserking:IsCastable() or ((5481 - (988 + 252)) == (401 + 3144))) then
												if (v24(v114.Berserking, nil) or ((1268 + 2780) > (6202 - (49 + 1921)))) then
													return "berserking main 6";
												end
											end
											v254 = 891 - (223 + 667);
										end
									end
								end
								if ((v38 and v114.ThunderFocusTea:IsReady() and not v114.EssenceFont:IsAvailable() and (v114.RisingSunKick:CooldownRemains() < v13:GCD())) or ((1802 - (51 + 1)) >= (5977 - 2504))) then
									if (((6779 - 3613) == (4291 - (146 + 979))) and v24(v114.ThunderFocusTea, nil)) then
										return "ThunderFocusTea main 16";
									end
								end
								v246 = 1 + 0;
							end
						end
					end
				end
				break;
			end
			if (((2368 - (311 + 294)) < (10385 - 6661)) and ((2 + 1) == v221)) then
				v118 = v13:GetEnemiesInMeleeRange(1451 - (496 + 947));
				if (((1415 - (1233 + 125)) <= (1105 + 1618)) and v31) then
					v119 = #v118;
				else
					v119 = 1 + 0;
				end
				if (v121.TargetIsValid() or v13:AffectingCombat() or ((394 + 1676) == (2088 - (963 + 682)))) then
					v113 = v13:GetEnemiesInRange(34 + 6);
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					if ((v112 == (12615 - (504 + 1000))) or ((1822 + 883) == (1269 + 124))) then
						v112 = v10.FightRemains(v113, false);
					end
				end
				v221 = 1 + 3;
			end
			if ((v221 == (2 - 0)) or ((3931 + 670) < (36 + 25))) then
				v34 = EpicSettings.Toggles['healing'];
				v35 = EpicSettings.Toggles['dps'];
				if (v13:IsDeadOrGhost() or ((1572 - (156 + 26)) >= (2733 + 2011))) then
					return;
				end
				v221 = 3 - 0;
			end
			if ((v221 == (165 - (149 + 15))) or ((2963 - (890 + 70)) > (3951 - (39 + 78)))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				v221 = 484 - (14 + 468);
			end
			if (((10 - 5) == v221) or ((436 - 280) > (2019 + 1894))) then
				if (((118 + 77) == (42 + 153)) and not v13:AffectingCombat()) then
					if (((1403 + 1702) >= (471 + 1325)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
						local v247 = 0 - 0;
						local v248;
						while true do
							if (((4328 + 51) >= (7488 - 5357)) and (v247 == (0 + 0))) then
								v248 = v121.DeadFriendlyUnitsCount();
								if (((3895 - (12 + 39)) >= (1901 + 142)) and (v248 > (2 - 1))) then
									if (v24(v114.Reawaken, nil) or ((11510 - 8278) <= (810 + 1921))) then
										return "reawaken";
									end
								elseif (((2582 + 2323) == (12437 - 7532)) and v24(v116.ResuscitateMouseover, not v15:IsInRange(27 + 13))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v13:AffectingCombat() and v30) or ((19988 - 15852) >= (6121 - (1596 + 114)))) then
					v29 = v126();
					if (v29 or ((7722 - 4764) == (4730 - (164 + 549)))) then
						return v29;
					end
				end
				if (((2666 - (1059 + 379)) >= (1008 - 195)) and (v30 or v13:AffectingCombat())) then
					local v243 = 0 + 0;
					while true do
						if ((v243 == (0 + 0)) or ((3847 - (145 + 247)) > (3324 + 726))) then
							if (((113 + 130) == (719 - 476)) and v32 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) then
								if (v24(v116.UseWeapon, nil) or ((52 + 219) > (1355 + 217))) then
									return "Using Weapon Macro";
								end
							end
							if (((4446 - 1707) < (4013 - (254 + 466))) and v107 and v115.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v108)) then
								if (v24(v116.ManaPotion, nil) or ((4502 - (544 + 16)) < (3603 - 2469))) then
									return "Mana Potion main";
								end
							end
							v243 = 629 - (294 + 334);
						end
						if ((v243 == (255 - (236 + 17))) or ((1161 + 1532) == (3872 + 1101))) then
							if (((8081 - 5935) == (10160 - 8014)) and v34) then
								if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (47 + 43)) and v66) or ((1849 + 395) == (4018 - (413 + 381)))) then
									if ((v65 == "Player") or ((207 + 4697) <= (4074 - 2158))) then
										if (((233 - 143) <= (3035 - (582 + 1388))) and v24(v116.SummonJadeSerpentStatuePlayer, not v15:IsInRange(68 - 28))) then
											return "jade serpent main player";
										end
									elseif (((3438 + 1364) == (5166 - (326 + 38))) and (v65 == "Cursor")) then
										if (v24(v116.SummonJadeSerpentStatueCursor, not v15:IsInRange(118 - 78)) or ((3254 - 974) <= (1131 - (47 + 573)))) then
											return "jade serpent main cursor";
										end
									elseif ((v65 == "Confirmation") or ((591 + 1085) <= (1966 - 1503))) then
										if (((6278 - 2409) == (5533 - (1269 + 395))) and v24(v114.SummonJadeSerpentStatue, not v15:IsInRange(532 - (76 + 416)))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if (((1601 - (319 + 124)) <= (5972 - 3359)) and v52 and v114.RenewingMist:IsReady() and v15:BuffDown(v114.RenewingMistBuff) and not v13:CanAttack(v15)) then
									if ((v15:HealthPercentage() <= v53) or ((3371 - (564 + 443)) <= (5533 - 3534))) then
										if (v24(v114.RenewingMist, not v15:IsSpellInRange(v114.RenewingMist)) or ((5380 - (337 + 121)) < (567 - 373))) then
											return "RenewingMist main";
										end
									end
								end
								if ((v60 and v114.SoothingMist:IsReady() and v15:BuffDown(v114.SoothingMist) and not v13:CanAttack(v15)) or ((6965 - 4874) < (1942 - (1261 + 650)))) then
									if ((v15:HealthPercentage() <= v61) or ((1029 + 1401) >= (7764 - 2892))) then
										if (v24(v114.SoothingMist, not v15:IsSpellInRange(v114.SoothingMist)) or ((6587 - (772 + 1045)) < (245 + 1490))) then
											return "SoothingMist main";
										end
									end
								end
								if ((v36 and (v13:BuffStack(v114.ManaTeaCharges) >= (162 - (102 + 42))) and v114.ManaTea:IsCastable()) or ((6283 - (1524 + 320)) <= (3620 - (1049 + 221)))) then
									if (v24(v114.ManaTea, nil) or ((4635 - (18 + 138)) < (10931 - 6465))) then
										return "Mana Tea main avoid overcap";
									end
								end
								if (((3649 - (67 + 1035)) > (1573 - (136 + 212))) and (v112 > v99) and v32) then
									local v255 = 0 - 0;
									while true do
										if (((3743 + 928) > (2466 + 208)) and (v255 == (1604 - (240 + 1364)))) then
											v29 = v133();
											if (v29 or ((4778 - (1050 + 32)) < (11879 - 8552))) then
												return v29;
											end
											break;
										end
									end
								end
								if (v31 or ((2687 + 1855) == (4025 - (331 + 724)))) then
									v29 = v130();
									if (((21 + 231) <= (2621 - (269 + 375))) and v29) then
										return v29;
									end
								end
								v29 = v129();
								if (v29 or ((2161 - (267 + 458)) == (1174 + 2601))) then
									return v29;
								end
							end
							break;
						end
						if ((v243 == (1 - 0)) or ((2436 - (667 + 151)) < (2427 - (1410 + 87)))) then
							if (((6620 - (1504 + 393)) > (11225 - 7072)) and (v13:DebuffStack(v114.Bursting) > (12 - 7))) then
								if ((v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) or ((4450 - (461 + 335)) >= (595 + 4059))) then
									if (((2712 - (1730 + 31)) <= (3163 - (728 + 939))) and v24(v114.DiffuseMagic, nil)) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							if (((v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) or ((6148 - 4412) == (1158 - 587))) then
								if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) or ((2052 - 1156) > (5837 - (138 + 930)))) then
									if (v24(v114.Revival, nil) or ((955 + 90) <= (798 + 222))) then
										return "Revival Bursting";
									end
								end
							end
							v243 = 2 + 0;
						end
					end
				end
				v221 = 24 - 18;
			end
			if ((v221 == (1766 - (459 + 1307))) or ((3030 - (474 + 1396)) <= (572 - 244))) then
				v134();
				v135();
				v30 = EpicSettings.Toggles['ooc'];
				v221 = 1 + 0;
			end
			if (((13 + 3795) > (8375 - 5451)) and (v221 == (1 + 3))) then
				v29 = v125();
				if (((12989 - 9098) < (21452 - 16533)) and v29) then
					return v29;
				end
				if (v13:AffectingCombat() or v30 or ((2825 - (562 + 29)) <= (1281 + 221))) then
					local v244 = v89 and v114.Detox:IsReady() and v33;
					v29 = v121.FocusUnit(v244, nil, 1459 - (374 + 1045), nil, 20 + 5, v114.EnvelopingMist);
					if (v29 or ((7799 - 5287) < (1070 - (448 + 190)))) then
						return v29;
					end
					if ((v33 and v89) or ((597 + 1251) == (391 + 474))) then
						local v249 = 0 + 0;
						while true do
							if ((v249 == (0 - 0)) or ((14548 - 9866) <= (6035 - (1307 + 187)))) then
								if (v17 or ((11999 - 8973) >= (9473 - 5427))) then
									if (((6156 - 4148) > (1321 - (232 + 451))) and v114.Detox:IsCastable() and v121.DispellableFriendlyUnit(24 + 1)) then
										local v256 = 0 + 0;
										while true do
											if (((2339 - (510 + 54)) <= (6513 - 3280)) and (v256 == (36 - (13 + 23)))) then
												if ((v136 == (0 - 0)) or ((6527 - 1984) == (3628 - 1631))) then
													v136 = GetTime();
												end
												if (v121.Wait(1588 - (830 + 258), v136) or ((10942 - 7840) < (456 + 272))) then
													local v257 = 0 + 0;
													while true do
														if (((1786 - (860 + 581)) == (1272 - 927)) and (v257 == (0 + 0))) then
															if (v24(v116.DetoxFocus, not v17:IsSpellInRange(v114.Detox)) or ((3068 - (237 + 4)) < (888 - 510))) then
																return "detox dispel focus";
															end
															v136 = 0 - 0;
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v121.UnitHasDispellableDebuffByPlayer(v16)) or ((6590 - 3114) < (2126 + 471))) then
									if (((1769 + 1310) < (18099 - 13305)) and v114.Detox:IsCastable()) then
										if (((2083 + 2771) > (2429 + 2035)) and v24(v116.DetoxMouseover, not v16:IsSpellInRange(v114.Detox))) then
											return "detox dispel mouseover";
										end
									end
								end
								break;
							end
						end
					end
				end
				v221 = 1431 - (85 + 1341);
			end
		end
	end
	local function v138()
		local v222 = 0 - 0;
		while true do
			if ((v222 == (0 - 0)) or ((5284 - (45 + 327)) == (7091 - 3333))) then
				v123();
				v114.Bursting:RegisterAuraTracking();
				v222 = 503 - (444 + 58);
			end
			if (((55 + 71) <= (600 + 2882)) and (v222 == (1 + 0))) then
				v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(782 - 512, v137, v138);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

