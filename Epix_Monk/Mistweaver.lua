local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((749 + 439) <= (4281 - (832 + 303))) and (v5 == (946 - (88 + 858)))) then
			v6 = v0[v4];
			if (not v6 or ((1065 + 2428) <= (1736 + 361))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (790 - (766 + 23))) or ((18611 - 14841) == (4974 - 1337))) then
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
	local v110 = 29274 - 18163;
	local v111 = 37711 - 26600;
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
		if (v113.ImprovedDetox:IsAvailable() or ((1094 + 1285) > (5726 - (556 + 592)))) then
			v120.DispellableDebuffs = v21.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if ((v113.DampenHarm:IsCastable() and v13:BuffDown(v113.FortifyingBrew) and (v13:HealthPercentage() <= v42) and v41) or ((172 + 311) > (1551 - (329 + 479)))) then
			if (((3308 - (174 + 680)) > (1985 - 1407)) and v24(v113.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if (((1927 - 997) < (3183 + 1275)) and v113.FortifyingBrew:IsCastable() and v13:BuffDown(v113.DampenHarmBuff) and (v13:HealthPercentage() <= v40) and v39) then
			if (((1401 - (396 + 343)) <= (87 + 885)) and v24(v113.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((5847 - (29 + 1448)) == (5759 - (135 + 1254))) and v113.ExpelHarm:IsCastable() and (v13:HealthPercentage() <= v55) and v54 and v13:BuffUp(v113.ChiHarmonyBuff)) then
			if (v24(v113.ExpelHarm, nil) or ((17939 - 13177) <= (4020 - 3159))) then
				return "expel_harm defensives 3";
			end
		end
		if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v84 and (v13:HealthPercentage() <= v85)) or ((942 + 470) == (5791 - (389 + 1138)))) then
			if (v24(v115.Healthstone) or ((3742 - (102 + 472)) < (2032 + 121))) then
				return "healthstone defensive 4";
			end
		end
		if ((v86 and (v13:HealthPercentage() <= v87)) or ((2760 + 2216) < (1242 + 90))) then
			if (((6173 - (320 + 1225)) == (8238 - 3610)) and (v88 == "Refreshing Healing Potion")) then
				if ((v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) or ((34 + 20) == (1859 - (157 + 1307)))) then
					if (((1941 - (821 + 1038)) == (204 - 122)) and v24(v115.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if ((v88 == "Dreamwalker's Healing Potion") or ((64 + 517) < (500 - 218))) then
				if ((v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) or ((1715 + 2894) < (6184 - 3689))) then
					if (((2178 - (834 + 192)) == (74 + 1078)) and v24(v115.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v124()
		local v138 = 0 + 0;
		while true do
			if (((41 + 1855) <= (5300 - 1878)) and (v138 == (306 - (300 + 4)))) then
				if (v104 or ((265 + 725) > (4240 - 2620))) then
					local v238 = 362 - (112 + 250);
					while true do
						if ((v238 == (0 + 0)) or ((2196 - 1319) > (2690 + 2005))) then
							v29 = v120.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 21 + 19);
							if (((2013 + 678) >= (918 + 933)) and v29) then
								return v29;
							end
							v238 = 1 + 0;
						end
						if (((1415 - (1001 + 413)) == v238) or ((6656 - 3671) >= (5738 - (244 + 638)))) then
							v29 = v120.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 733 - (627 + 66));
							if (((12740 - 8464) >= (1797 - (512 + 90))) and v29) then
								return v29;
							end
							v238 = 1908 - (1665 + 241);
						end
						if (((3949 - (373 + 344)) <= (2116 + 2574)) and (v238 == (1 + 1))) then
							v29 = v120.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 105 - 65);
							if (v29 or ((1515 - 619) >= (4245 - (35 + 1064)))) then
								return v29;
							end
							v238 = 3 + 0;
						end
						if (((6549 - 3488) >= (12 + 2946)) and ((1239 - (298 + 938)) == v238)) then
							v29 = v120.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 1299 - (233 + 1026));
							if (((4853 - (636 + 1030)) >= (330 + 314)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((630 + 14) <= (210 + 494)) and v105) then
					local v239 = 0 + 0;
					while true do
						if (((1179 - (55 + 166)) > (184 + 763)) and (v239 == (1 + 2))) then
							v29 = v120.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 152 - 112);
							if (((4789 - (36 + 261)) >= (4641 - 1987)) and v29) then
								return v29;
							end
							break;
						end
						if (((4810 - (34 + 1334)) >= (578 + 925)) and ((1 + 0) == v239)) then
							v29 = v120.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 1323 - (1035 + 248));
							if (v29 or ((3191 - (20 + 1)) <= (763 + 701))) then
								return v29;
							end
							v239 = 321 - (134 + 185);
						end
						if (((1135 - (549 + 584)) == v239) or ((5482 - (314 + 371)) == (15063 - 10675))) then
							v29 = v120.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 1008 - (478 + 490));
							if (((292 + 259) <= (1853 - (786 + 386))) and v29) then
								return v29;
							end
							v239 = 9 - 6;
						end
						if (((4656 - (1055 + 324)) > (1747 - (1093 + 247))) and (v239 == (0 + 0))) then
							v29 = v120.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 5 + 35);
							if (((18639 - 13944) >= (4802 - 3387)) and v29) then
								return v29;
							end
							v239 = 2 - 1;
						end
					end
				end
				break;
			end
			if ((v138 == (2 - 1)) or ((1143 + 2069) <= (3636 - 2692))) then
				if (v102 or ((10671 - 7575) <= (1356 + 442))) then
					local v240 = 0 - 0;
					while true do
						if (((4225 - (364 + 324)) == (9696 - 6159)) and (v240 == (2 - 1))) then
							v29 = v120.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 14 + 26);
							if (((16055 - 12218) >= (2514 - 944)) and v29) then
								return v29;
							end
							break;
						end
						if ((v240 == (0 - 0)) or ((4218 - (1249 + 19)) == (3441 + 371))) then
							v29 = v120.HandleChromie(v113.Riptide, v115.RiptideMouseover, 155 - 115);
							if (((5809 - (686 + 400)) >= (1819 + 499)) and v29) then
								return v29;
							end
							v240 = 230 - (73 + 156);
						end
					end
				end
				if (v103 or ((10 + 2017) > (3663 - (721 + 90)))) then
					local v241 = 0 + 0;
					while true do
						if ((v241 == (0 - 0)) or ((1606 - (224 + 246)) > (6993 - 2676))) then
							v29 = v120.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 73 - 33);
							if (((862 + 3886) == (113 + 4635)) and v29) then
								return v29;
							end
							v241 = 1 + 0;
						end
						if (((7427 - 3691) <= (15773 - 11033)) and (v241 == (516 - (203 + 310)))) then
							v29 = v120.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 2033 - (1238 + 755));
							if (v29 or ((237 + 3153) <= (4594 - (709 + 825)))) then
								return v29;
							end
							break;
						end
						if ((v241 == (1 - 0)) or ((1454 - 455) > (3557 - (196 + 668)))) then
							v29 = v120.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 157 - 117);
							if (((958 - 495) < (1434 - (171 + 662))) and v29) then
								return v29;
							end
							v241 = 95 - (4 + 89);
						end
						if ((v241 == (6 - 4)) or ((795 + 1388) < (3017 - 2330))) then
							v29 = v120.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 16 + 24);
							if (((6035 - (35 + 1451)) == (6002 - (28 + 1425))) and v29) then
								return v29;
							end
							v241 = 1996 - (941 + 1052);
						end
					end
				end
				v138 = 2 + 0;
			end
			if (((6186 - (822 + 692)) == (6669 - 1997)) and (v138 == (0 + 0))) then
				if (v101 or ((3965 - (45 + 252)) < (391 + 4))) then
					v29 = v120.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 11 + 19, true);
					if (v29 or ((10138 - 5972) == (888 - (114 + 319)))) then
						return v29;
					end
				end
				if (v100 or ((6387 - 1938) == (3411 - 748))) then
					local v242 = 0 + 0;
					while true do
						if ((v242 == (0 - 0)) or ((8961 - 4684) < (4952 - (556 + 1407)))) then
							v29 = v120.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 1236 - (741 + 465));
							if (v29 or ((1335 - (170 + 295)) >= (2187 + 1962))) then
								return v29;
							end
							break;
						end
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v125()
		if (((5445 - 3233) < (2639 + 544)) and v113.ChiBurst:IsCastable() and v50) then
			if (((2980 + 1666) > (1695 + 1297)) and v24(v113.ChiBurst, not v15:IsInRange(1270 - (957 + 273)))) then
				return "chi_burst precombat 4";
			end
		end
		if (((384 + 1050) < (1244 + 1862)) and v113.SpinningCraneKick:IsCastable() and v46 and (v118 >= (7 - 5))) then
			if (((2071 - 1285) < (9233 - 6210)) and v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(39 - 31))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v113.TigerPalm:IsCastable() and v48) or ((4222 - (389 + 1391)) < (47 + 27))) then
			if (((473 + 4062) == (10324 - 5789)) and v24(v113.TigerPalm, not v15:IsInMeleeRange(956 - (783 + 168)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v126()
		local v139 = 0 - 0;
		while true do
			if (((0 + 0) == v139) or ((3320 - (309 + 2)) <= (6464 - 4359))) then
				if (((3042 - (1090 + 122)) < (1190 + 2479)) and v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (9 - 6)) and v44) then
					if ((v43 == "Player") or ((979 + 451) >= (4730 - (628 + 490)))) then
						if (((482 + 2201) >= (6090 - 3630)) and v24(v115.SummonWhiteTigerStatuePlayer, not v15:IsInRange(182 - 142))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif ((v43 == "Cursor") or ((2578 - (431 + 343)) >= (6614 - 3339))) then
						if (v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(115 - 75)) or ((1120 + 297) > (465 + 3164))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((6490 - (556 + 1139)) > (417 - (6 + 9))) and (v43 == "Friendly under Cursor") and v16:Exists() and not v13:CanAttack(v16)) then
						if (((882 + 3931) > (1827 + 1738)) and v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(209 - (28 + 141)))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((1516 + 2396) == (4828 - 916)) and (v43 == "Enemy under Cursor") and v16:Exists() and v13:CanAttack(v16)) then
						if (((1998 + 823) <= (6141 - (486 + 831))) and v24(v115.SummonWhiteTigerStatueCursor, not v15:IsInRange(104 - 64))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif (((6118 - 4380) <= (415 + 1780)) and (v43 == "Confirmation")) then
						if (((129 - 88) <= (4281 - (668 + 595))) and v24(v115.SummonWhiteTigerStatue, not v15:IsInRange(36 + 4))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if (((433 + 1712) <= (11191 - 7087)) and v113.TouchofDeath:IsCastable() and v51) then
					if (((2979 - (23 + 267)) < (6789 - (1129 + 815))) and v24(v113.TouchofDeath, not v15:IsInMeleeRange(392 - (371 + 16)))) then
						return "touch_of_death aoe 2";
					end
				end
				v139 = 1751 - (1326 + 424);
			end
			if ((v139 == (5 - 2)) or ((8485 - 6163) > (2740 - (88 + 30)))) then
				if ((v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (771 - (720 + 51))) and v48 and (v118 >= (6 - 3))) or ((6310 - (421 + 1355)) == (3434 - 1352))) then
					if (v24(v113.TigerPalm, not v15:IsInMeleeRange(3 + 2)) or ((2654 - (286 + 797)) > (6825 - 4958))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v113.SpinningCraneKick:IsCastable() and v46) or ((4395 - 1741) >= (3435 - (397 + 42)))) then
					if (((1243 + 2735) > (2904 - (24 + 776))) and v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(12 - 4))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
			if (((3780 - (222 + 563)) > (3395 - 1854)) and (v139 == (2 + 0))) then
				if (((3439 - (23 + 167)) > (2751 - (690 + 1108))) and v113.SpinningCraneKick:IsCastable() and v46 and v15:DebuffDown(v113.MysticTouchDebuff) and v113.MysticTouch:IsAvailable()) then
					if (v24(v113.SpinningCraneKick, not v15:IsInMeleeRange(3 + 5)) or ((2700 + 573) > (5421 - (40 + 808)))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if ((v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v13:BuffUp(v113.JadefireStomp) and v45 and (v118 >= (1 + 2))) or ((12049 - 8898) < (1228 + 56))) then
					if (v24(v113.BlackoutKick, not v15:IsInMeleeRange(3 + 2)) or ((1015 + 835) == (2100 - (47 + 524)))) then
						return "blackout_kick aoe 6";
					end
				end
				v139 = 2 + 1;
			end
			if (((2244 - 1423) < (3174 - 1051)) and (v139 == (2 - 1))) then
				if (((2628 - (1165 + 561)) < (70 + 2255)) and v113.JadefireStomp:IsReady() and v49) then
					if (((2657 - 1799) <= (1131 + 1831)) and v24(v113.JadefireStomp, nil)) then
						return "JadefireStomp aoe3";
					end
				end
				if ((v113.ChiBurst:IsCastable() and v50) or ((4425 - (341 + 138)) < (348 + 940))) then
					if (v24(v113.ChiBurst, not v15:IsInRange(82 - 42)) or ((3568 - (89 + 237)) == (1823 - 1256))) then
						return "chi_burst aoe 4";
					end
				end
				v139 = 3 - 1;
			end
		end
	end
	local function v127()
		local v140 = 881 - (581 + 300);
		while true do
			if ((v140 == (1221 - (855 + 365))) or ((2011 - 1164) >= (413 + 850))) then
				if ((v113.RisingSunKick:IsReady() and v47) or ((3488 - (1030 + 205)) == (1738 + 113))) then
					if (v24(v113.RisingSunKick, not v15:IsInMeleeRange(5 + 0)) or ((2373 - (156 + 130)) > (5389 - 3017))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v113.ChiBurst:IsCastable() and v50) or ((7491 - 3046) < (8497 - 4348))) then
					if (v24(v113.ChiBurst, not v15:IsInRange(11 + 29)) or ((1061 + 757) == (154 - (10 + 59)))) then
						return "chi_burst st 4";
					end
				end
				v140 = 1 + 1;
			end
			if (((3102 - 2472) < (3290 - (671 + 492))) and (v140 == (0 + 0))) then
				if ((v113.TouchofDeath:IsCastable() and v51) or ((3153 - (369 + 846)) == (666 + 1848))) then
					if (((3632 + 623) >= (2000 - (1036 + 909))) and v24(v113.TouchofDeath, not v15:IsInMeleeRange(4 + 1))) then
						return "touch_of_death st 1";
					end
				end
				if (((5034 - 2035) > (1359 - (11 + 192))) and v113.JadefireStomp:IsReady() and v49) then
					if (((1188 + 1162) > (1330 - (135 + 40))) and v24(v113.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v140 = 2 - 1;
			end
			if (((2429 + 1600) <= (10690 - 5837)) and (v140 == (2 - 0))) then
				if ((v113.BlackoutKick:IsCastable() and (v13:BuffStack(v113.TeachingsoftheMonasteryBuff) == (179 - (50 + 126))) and (v113.RisingSunKick:CooldownRemains() > v13:GCD()) and v45) or ((1436 - 920) > (761 + 2673))) then
					if (((5459 - (1233 + 180)) >= (4002 - (522 + 447))) and v24(v113.BlackoutKick, not v15:IsInMeleeRange(1426 - (107 + 1314)))) then
						return "blackout_kick st 5";
					end
				end
				if ((v113.TigerPalm:IsCastable() and ((v13:BuffStack(v113.TeachingsoftheMonasteryBuff) < (2 + 1)) or (v13:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (5 - 3))) and v48) or ((1155 + 1564) <= (2872 - 1425))) then
					if (v24(v113.TigerPalm, not v15:IsInMeleeRange(19 - 14)) or ((6044 - (716 + 1194)) < (68 + 3858))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
		end
	end
	local function v128()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (505 - (74 + 429))) or ((315 - 151) >= (1381 + 1404))) then
				if ((v60 and v113.SoothingMist:IsReady() and v17:BuffDown(v113.SoothingMist)) or ((1201 - 676) == (1493 + 616))) then
					if (((101 - 68) == (81 - 48)) and (v17:HealthPercentage() <= v61)) then
						if (((3487 - (279 + 154)) <= (4793 - (454 + 324))) and v24(v115.SoothingMistFocus, not v17:IsSpellInRange(v113.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((1473 + 398) < (3399 - (12 + 5))) and (v141 == (1 + 0))) then
				if (((3294 - 2001) <= (801 + 1365)) and v52 and v113.RenewingMist:IsReady() and v17:BuffDown(v113.RenewingMistBuff)) then
					if ((v17:HealthPercentage() <= v53) or ((3672 - (277 + 816)) < (525 - 402))) then
						if (v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist)) or ((2029 - (1058 + 125)) >= (444 + 1924))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v113.Vivify:IsReady() and v13:BuffUp(v113.VivaciousVivificationBuff)) or ((4987 - (815 + 160)) <= (14407 - 11049))) then
					if (((3546 - 2052) <= (717 + 2288)) and (v17:HealthPercentage() <= v57)) then
						if (v24(v115.VivifyFocus, not v17:IsSpellInRange(v113.Vivify)) or ((9093 - 5982) == (4032 - (41 + 1857)))) then
							return "Vivify instant healing st";
						end
					end
				end
				v141 = 1895 - (1222 + 671);
			end
			if (((6086 - 3731) == (3384 - 1029)) and (v141 == (1182 - (229 + 953)))) then
				if ((v52 and v113.RenewingMist:IsReady() and v17:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (1775.8 - (1111 + 663)))) or ((2167 - (874 + 705)) <= (61 + 371))) then
					if (((3273 + 1524) >= (8096 - 4201)) and (v17:HealthPercentage() <= v53)) then
						if (((101 + 3476) == (4256 - (642 + 37))) and v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((866 + 2928) > (591 + 3102)) and v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 62 - 37) > (455 - (233 + 221)))) then
					if (v24(v113.RisingSunKick, not v15:IsInMeleeRange(11 - 6)) or ((1123 + 152) == (5641 - (718 + 823)))) then
						return "RisingSunKick healing st";
					end
				end
				v141 = 1 + 0;
			end
		end
	end
	local function v129()
		local v142 = 805 - (266 + 539);
		while true do
			if ((v142 == (0 - 0)) or ((2816 - (636 + 589)) >= (8498 - 4918))) then
				if (((2026 - 1043) <= (1433 + 375)) and v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 10 + 15) > (1016 - (657 + 358)))) then
					if (v24(v113.RisingSunKick, not v15:IsInMeleeRange(13 - 8)) or ((4898 - 2748) <= (2384 - (1151 + 36)))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (((3640 + 129) >= (309 + 864)) and v120.AreUnitsBelowHealthPercentage(v64, v63)) then
					local v243 = 0 - 0;
					while true do
						if (((3317 - (1552 + 280)) == (2319 - (64 + 770))) and (v243 == (1 + 0))) then
							if ((v62 and v113.EssenceFont:IsReady() and (v13:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (18 - 10)))) or ((589 + 2726) <= (4025 - (157 + 1086)))) then
								if (v24(v113.EssenceFont, nil) or ((1753 - 877) >= (12981 - 10017))) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v62 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v13:BuffDown(v113.EssenceFontBuff)) or ((3423 - 1191) > (3408 - 911))) then
								if (v24(v113.EssenceFont, nil) or ((2929 - (599 + 220)) <= (660 - 328))) then
									return "EssenceFont healing aoe";
								end
							end
							break;
						end
						if (((5617 - (1813 + 118)) > (2319 + 853)) and (v243 == (1217 - (841 + 376)))) then
							if ((v36 and (v13:BuffStack(v113.ManaTeaCharges) > v37) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((6268 - 1794) < (191 + 629))) then
								if (((11679 - 7400) >= (3741 - (464 + 395))) and v24(v113.ManaTea, nil)) then
									return "EssenceFont healing aoe";
								end
							end
							if ((v38 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v13:GCD())) or ((5207 - 3178) >= (1691 + 1830))) then
								if (v24(v113.ThunderFocusTea, nil) or ((2874 - (467 + 370)) >= (9592 - 4950))) then
									return "ThunderFocusTea healing aoe";
								end
							end
							v243 = 1 + 0;
						end
					end
				end
				v142 = 3 - 2;
			end
			if (((269 + 1451) < (10371 - 5913)) and ((521 - (150 + 370)) == v142)) then
				if ((v67 and v113.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68)) or ((1718 - (74 + 1208)) > (7430 - 4409))) then
					if (((3381 - 2668) <= (603 + 244)) and v24(v115.ZenPulseFocus, not v17:IsSpellInRange(v113.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if (((2544 - (14 + 376)) <= (6991 - 2960)) and v70 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71)) then
					if (((2987 + 1628) == (4055 + 560)) and v24(v113.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (2 - 1)) or ((2852 + 938) == (578 - (23 + 55)))) then
				if (((210 - 121) < (148 + 73)) and v60 and v113.SoothingMist:IsReady() and v17:BuffUp(v113.ChiHarmonyBuff) and v17:BuffDown(v113.SoothingMist)) then
					if (((1845 + 209) >= (2203 - 782)) and v24(v115.SoothingMistFocus, not v17:IsSpellInRange(v113.SoothingMist))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
			if (((218 + 474) < (3959 - (652 + 249))) and (v143 == (0 - 0))) then
				if ((v58 and v113.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 1893 - (708 + 1160)) < (8 - 5))) or ((5932 - 2678) == (1682 - (10 + 17)))) then
					local v244 = 0 + 0;
					while true do
						if ((v244 == (1733 - (1400 + 332))) or ((2485 - 1189) == (6818 - (242 + 1666)))) then
							if (((1442 + 1926) == (1235 + 2133)) and v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
						if (((2253 + 390) < (4755 - (850 + 90))) and (v244 == (0 - 0))) then
							v29 = v120.FocusUnitRefreshableBuff(v113.EnvelopingMist, 1392 - (360 + 1030), 36 + 4, nil, false, 70 - 45);
							if (((2631 - 718) > (2154 - (909 + 752))) and v29) then
								return v29;
							end
							v244 = 1224 - (109 + 1114);
						end
					end
				end
				if (((8705 - 3950) > (1335 + 2093)) and v47 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 267 - (6 + 236)) > (2 + 0))) then
					if (((1112 + 269) <= (5586 - 3217)) and v24(v113.RisingSunKick, not v15:IsInMeleeRange(8 - 3))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v143 = 1134 - (1076 + 57);
			end
		end
	end
	local function v131()
		local v144 = 0 + 0;
		while true do
			if (((689 - (579 + 110)) == v144) or ((383 + 4460) == (3611 + 473))) then
				if (((2478 + 2191) > (770 - (174 + 233))) and v45 and v113.BlackoutKick:IsReady() and (v13:BuffStack(v113.TeachingsoftheMonastery) >= (8 - 5))) then
					if (v24(v113.BlackoutKick, not v15:IsInMeleeRange(8 - 3)) or ((835 + 1042) >= (4312 - (663 + 511)))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((4231 + 511) >= (788 + 2838)) and v58 and v113.EnvelopingMist:IsReady() and (v13:BuffStack(v113.InvokeChiJiBuff) == (9 - 6))) then
					if ((v17:HealthPercentage() <= v59) or ((2750 + 1790) == (2156 - 1240))) then
						if (v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist)) or ((2798 - 1642) > (2074 + 2271))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v144 = 1 - 0;
			end
			if (((1595 + 642) < (389 + 3860)) and (v144 == (723 - (478 + 244)))) then
				if ((v47 and v113.RisingSunKick:IsReady()) or ((3200 - (440 + 77)) < (11 + 12))) then
					if (((2551 - 1854) <= (2382 - (655 + 901))) and v24(v113.RisingSunKick, not v15:IsInMeleeRange(1 + 4))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if (((846 + 259) <= (795 + 381)) and v58 and v113.EnvelopingMist:IsReady() and (v13:BuffStack(v113.InvokeChiJiBuff) >= (7 - 5))) then
					if (((4824 - (695 + 750)) <= (13016 - 9204)) and (v17:HealthPercentage() <= v59)) then
						if (v24(v115.EnvelopingMistFocus, not v17:IsSpellInRange(v113.EnvelopingMist)) or ((1215 - 427) >= (6499 - 4883))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v144 = 353 - (285 + 66);
			end
			if (((4321 - 2467) <= (4689 - (682 + 628))) and (v144 == (1 + 1))) then
				if (((4848 - (176 + 123)) == (1903 + 2646)) and v62 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v13:BuffDown(v113.AncientTeachings)) then
					if (v24(v113.EssenceFont, nil) or ((2193 + 829) >= (3293 - (239 + 30)))) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v145 = 0 + 0;
		while true do
			if (((4633 + 187) > (3890 - 1692)) and (v145 == (2 - 1))) then
				if ((v81 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82)) or ((1376 - (306 + 9)) >= (17067 - 12176))) then
					if (((238 + 1126) <= (2745 + 1728)) and v24(v113.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if ((v73 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v75, v74)) or ((1731 + 1864) <= (8 - 5))) then
					if ((v52 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1376 - (1140 + 235)))) or ((2974 + 1698) == (3533 + 319))) then
						local v245 = 0 + 0;
						while true do
							if (((1611 - (33 + 19)) == (563 + 996)) and (v245 == (2 - 1))) then
								if (v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist)) or ((772 + 980) <= (1545 - 757))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if ((v245 == (0 + 0)) or ((4596 - (586 + 103)) == (17 + 160))) then
								v29 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 18 - 12, 1528 - (1309 + 179), nil, false, 45 - 20);
								if (((1511 + 1959) > (1490 - 935)) and v29) then
									return v29;
								end
								v245 = 1 + 0;
							end
						end
					end
					if ((v36 and v113.ManaTea:IsCastable() and (v13:BuffStack(v113.ManaTeaCharges) >= (5 - 2)) and v13:BuffDown(v113.ManaTeaBuff)) or ((1936 - 964) == (1254 - (295 + 314)))) then
						if (((7815 - 4633) >= (4077 - (1300 + 662))) and v24(v113.ManaTea, nil)) then
							return "ManaTea YuLon prep";
						end
					end
					if (((12224 - 8331) < (6184 - (1178 + 577))) and v70 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (11 + 9))) then
						if (v24(v113.SheilunsGift, nil) or ((8475 - 5608) < (3310 - (851 + 554)))) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if ((v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v13:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((10 - 6) * v13:GCD()))) or ((3900 - 2104) >= (4353 - (115 + 187)))) then
						if (((1240 + 379) <= (3556 + 200)) and v24(v113.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v145 = 7 - 5;
			end
			if (((1765 - (160 + 1001)) == (529 + 75)) and (v145 == (0 + 0))) then
				if ((v79 and v113.LifeCocoon:IsReady() and (v17:HealthPercentage() <= v80)) or ((9178 - 4694) == (1258 - (237 + 121)))) then
					if (v24(v115.LifeCocoonFocus, not v17:IsSpellInRange(v113.LifeCocoon)) or ((5356 - (525 + 372)) <= (2109 - 996))) then
						return "Life Cocoon CD";
					end
				end
				if (((11933 - 8301) > (3540 - (96 + 46))) and v81 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82)) then
					if (((4859 - (643 + 134)) <= (1776 + 3141)) and v24(v113.Revival, nil)) then
						return "Revival CD";
					end
				end
				v145 = 2 - 1;
			end
			if (((17939 - 13107) >= (1330 + 56)) and (v145 == (3 - 1))) then
				if (((279 - 142) == (856 - (316 + 403))) and (v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (17 + 8))) then
					v29 = v130();
					if (v29 or ((4316 - 2746) >= (1566 + 2766))) then
						return v29;
					end
				end
				if ((v76 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v78, v77)) or ((10234 - 6170) <= (1290 + 529))) then
					if ((v52 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1 + 0))) or ((17276 - 12290) < (7517 - 5943))) then
						local v246 = 0 - 0;
						while true do
							if (((254 + 4172) > (338 - 166)) and ((0 + 0) == v246)) then
								v29 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 17 - 11, 57 - (12 + 5), nil, false, 97 - 72);
								if (((1249 - 663) > (967 - 512)) and v29) then
									return v29;
								end
								v246 = 2 - 1;
							end
							if (((168 + 658) == (2799 - (1656 + 317))) and ((1 + 0) == v246)) then
								if (v24(v115.RenewingMistFocus, not v17:IsSpellInRange(v113.RenewingMist)) or ((3221 + 798) > (11808 - 7367))) then
									return "Renewing Mist ChiJi prep";
								end
								break;
							end
						end
					end
					if (((9926 - 7909) < (4615 - (5 + 349))) and v70 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (94 - 74))) then
						if (((5987 - (266 + 1005)) > (53 + 27)) and v24(v113.SheilunsGift, nil)) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					if ((v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (3 - 2)) and v13:BuffUp(v113.AncientTeachings) and (v13:BuffStack(v113.TeachingsoftheMonastery) == (3 - 0)) and (v113.SheilunsGift:TimeSinceLastCast() < ((1700 - (561 + 1135)) * v13:GCD()))) or ((4570 - 1063) == (10755 - 7483))) then
						if (v24(v113.InvokeChiJiTheRedCrane, nil) or ((1942 - (507 + 559)) >= (7716 - 4641))) then
							return "Invoke Chi'ji GO";
						end
					end
				end
				v145 = 9 - 6;
			end
			if (((4740 - (212 + 176)) > (3459 - (250 + 655))) and (v145 == (8 - 5))) then
				if ((v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (43 - 18)) or ((6893 - 2487) < (5999 - (1869 + 87)))) then
					v29 = v131();
					if (v29 or ((6551 - 4662) >= (5284 - (484 + 1417)))) then
						return v29;
					end
				end
				break;
			end
		end
	end
	local function v133()
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
	local function v134()
		local v183 = 0 - 0;
		while true do
			if (((3170 - 1278) <= (3507 - (48 + 725))) and (v183 == (11 - 4))) then
				v83 = EpicSettings.Settings['RevivalHP'];
				v82 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((5158 - 3235) < (1290 + 928)) and ((15 - 9) == v183)) then
				v78 = EpicSettings.Settings['InvokeChiJiHP'];
				v77 = EpicSettings.Settings['InvokeChiJiGroup'];
				v79 = EpicSettings.Settings['UseLifeCocoon'];
				v80 = EpicSettings.Settings['LifeCocoonHP'];
				v81 = EpicSettings.Settings['UseRevival'];
				v183 = 2 + 5;
			end
			if (((634 + 1539) > (1232 - (152 + 701))) and ((1315 - (430 + 881)) == v183)) then
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleChromie'];
				v104 = EpicSettings.Settings['HandleCharredBrambles'];
				v103 = EpicSettings.Settings['HandleCharredTreant'];
				v183 = 2 + 3;
			end
			if ((v183 == (898 - (557 + 338))) or ((766 + 1825) == (9606 - 6197))) then
				v92 = EpicSettings.Settings['InterruptThreshold'];
				v90 = EpicSettings.Settings['InterruptWithStun'];
				v91 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v93 = EpicSettings.Settings['useSpearHandStrike'];
				v94 = EpicSettings.Settings['useLegSweep'];
				v183 = 13 - 9;
			end
			if (((11992 - 7478) > (7163 - 3839)) and (v183 == (803 - (499 + 302)))) then
				v85 = EpicSettings.Settings['healthstoneHP'];
				v106 = EpicSettings.Settings['useManaPotion'];
				v107 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['RevivalBurstingGroup'];
				v109 = EpicSettings.Settings['RevivalBurstingStacks'];
				v183 = 869 - (39 + 827);
			end
			if ((v183 == (0 - 0)) or ((464 - 256) >= (19176 - 14348))) then
				v96 = EpicSettings.Settings['racialsWithCD'];
				v95 = EpicSettings.Settings['useRacials'];
				v98 = EpicSettings.Settings['trinketsWithCD'];
				v97 = EpicSettings.Settings['useTrinkets'];
				v99 = EpicSettings.Settings['fightRemainsCheck'];
				v183 = 1 - 0;
			end
			if ((v183 == (1 + 0)) or ((4633 - 3050) > (571 + 2996))) then
				v89 = EpicSettings.Settings['dispelDebuffs'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v87 = EpicSettings.Settings['healingPotionHP'];
				v88 = EpicSettings.Settings['HealingPotionName'];
				v84 = EpicSettings.Settings['useHealthstone'];
				v183 = 2 - 0;
			end
			if ((v183 == (109 - (103 + 1))) or ((1867 - (475 + 79)) == (1716 - 922))) then
				v105 = EpicSettings.Settings['HandleFyrakkNPC'];
				v73 = EpicSettings.Settings['UseInvokeYulon'];
				v75 = EpicSettings.Settings['InvokeYulonHP'];
				v74 = EpicSettings.Settings['InvokeYulonGroup'];
				v76 = EpicSettings.Settings['UseInvokeChiJi'];
				v183 = 19 - 13;
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		v133();
		v134();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['healing'];
		v35 = EpicSettings.Toggles['dps'];
		if (((2794 + 380) > (4405 - (1395 + 108))) and v13:IsDeadOrGhost()) then
			return;
		end
		v117 = v13:GetEnemiesInMeleeRange(23 - 15);
		if (((5324 - (7 + 1197)) <= (1858 + 2402)) and v31) then
			v118 = #v117;
		else
			v118 = 1 + 0;
		end
		if (v120.TargetIsValid() or v13:AffectingCombat() or ((1202 - (27 + 292)) > (14001 - 9223))) then
			local v194 = 0 - 0;
			while true do
				if ((v194 == (4 - 3)) or ((7138 - 3518) >= (9314 - 4423))) then
					v111 = v110;
					if (((4397 - (43 + 96)) > (3822 - 2885)) and (v111 == (25120 - 14009))) then
						v111 = v10.FightRemains(v112, false);
					end
					break;
				end
				if ((v194 == (0 + 0)) or ((1375 + 3494) < (1790 - 884))) then
					v112 = v13:GetEnemiesInRange(16 + 24);
					v110 = v10.BossFightRemains(nil, true);
					v194 = 1 - 0;
				end
			end
		end
		v29 = v124();
		if (v29 or ((386 + 839) > (311 + 3917))) then
			return v29;
		end
		if (((5079 - (1414 + 337)) > (4178 - (1642 + 298))) and (v13:AffectingCombat() or v30)) then
			local v195 = 0 - 0;
			local v196;
			while true do
				if (((11043 - 7204) > (4169 - 2764)) and (v195 == (0 + 0))) then
					v196 = v89 and v113.Detox:IsReady() and v33;
					v29 = v120.FocusUnit(v196, nil, nil, nil);
					v195 = 1 + 0;
				end
				if ((v195 == (973 - (357 + 615))) or ((908 + 385) <= (1243 - 736))) then
					if (v29 or ((2482 + 414) < (1725 - 920))) then
						return v29;
					end
					if (((1853 + 463) == (158 + 2158)) and v33 and v89) then
						local v247 = 0 + 0;
						while true do
							if ((v247 == (1301 - (384 + 917))) or ((3267 - (128 + 569)) == (3076 - (1407 + 136)))) then
								if (v17 or ((2770 - (687 + 1200)) == (3170 - (556 + 1154)))) then
									if ((v113.Detox:IsCastable() and v120.DispellableFriendlyUnit(87 - 62)) or ((4714 - (9 + 86)) <= (1420 - (275 + 146)))) then
										local v252 = 0 + 0;
										while true do
											if ((v252 == (64 - (29 + 35))) or ((15112 - 11702) > (12294 - 8178))) then
												if ((v135 == (0 - 0)) or ((589 + 314) >= (4071 - (53 + 959)))) then
													v135 = GetTime();
												end
												if (v120.Wait(908 - (312 + 96), v135) or ((6900 - 2924) < (3142 - (147 + 138)))) then
													local v253 = 899 - (813 + 86);
													while true do
														if (((4456 + 474) > (4274 - 1967)) and (v253 == (492 - (18 + 474)))) then
															if (v24(v115.DetoxFocus, not v17:IsSpellInRange(v113.Detox)) or ((1365 + 2681) < (4213 - 2922))) then
																return "detox dispel focus";
															end
															v135 = 1086 - (860 + 226);
															break;
														end
													end
												end
												break;
											end
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v16)) or ((4544 - (121 + 182)) == (437 + 3108))) then
									if (v113.Detox:IsCastable() or ((5288 - (988 + 252)) > (479 + 3753))) then
										if (v24(v115.DetoxMouseover, not v16:IsSpellInRange(v113.Detox)) or ((549 + 1201) >= (5443 - (49 + 1921)))) then
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
		if (((4056 - (223 + 667)) == (3218 - (51 + 1))) and not v13:AffectingCombat()) then
			if (((3034 - 1271) < (7974 - 4250)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
				local v237 = v120.DeadFriendlyUnitsCount();
				if (((1182 - (146 + 979)) <= (769 + 1954)) and (v237 > (606 - (311 + 294)))) then
					if (v24(v113.Reawaken, nil) or ((5772 - 3702) == (188 + 255))) then
						return "reawaken";
					end
				elseif (v24(v115.ResuscitateMouseover, not v15:IsInRange(1483 - (496 + 947))) or ((4063 - (1233 + 125)) == (566 + 827))) then
					return "resuscitate";
				end
			end
		end
		if ((not v13:AffectingCombat() and v30) or ((4128 + 473) < (12 + 49))) then
			local v197 = 1645 - (963 + 682);
			while true do
				if ((v197 == (0 + 0)) or ((2894 - (504 + 1000)) >= (3195 + 1549))) then
					v29 = v125();
					if (v29 or ((1825 + 178) > (362 + 3472))) then
						return v29;
					end
					break;
				end
			end
		end
		if (v30 or v13:AffectingCombat() or ((229 - 73) > (3344 + 569))) then
			local v198 = 0 + 0;
			while true do
				if (((377 - (156 + 26)) == (113 + 82)) and (v198 == (1 - 0))) then
					if (((3269 - (149 + 15)) >= (2756 - (890 + 70))) and (v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) then
						if (((4496 - (39 + 78)) >= (2613 - (14 + 468))) and v81 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) then
							if (((8452 - 4608) >= (5710 - 3667)) and v24(v113.Revival, nil)) then
								return "Revival Bursting";
							end
						end
					end
					if (v34 or ((1668 + 1564) <= (1640 + 1091))) then
						if (((1043 + 3862) == (2216 + 2689)) and v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (24 + 66)) and v66) then
							if ((v65 == "Player") or ((7916 - 3780) >= (4360 + 51))) then
								if (v24(v115.SummonJadeSerpentStatuePlayer, not v15:IsInRange(140 - 100)) or ((75 + 2883) == (4068 - (12 + 39)))) then
									return "jade serpent main player";
								end
							elseif (((1143 + 85) >= (2516 - 1703)) and (v65 == "Cursor")) then
								if (v24(v115.SummonJadeSerpentStatueCursor, not v15:IsInRange(142 - 102)) or ((1025 + 2430) > (2132 + 1918))) then
									return "jade serpent main cursor";
								end
							elseif (((616 - 373) == (162 + 81)) and (v65 == "Confirmation")) then
								if (v24(v113.SummonJadeSerpentStatue, not v15:IsInRange(193 - 153)) or ((1981 - (1596 + 114)) > (4103 - 2531))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if (((3452 - (164 + 549)) < (4731 - (1059 + 379))) and v36 and (v13:BuffStack(v113.ManaTeaCharges) >= (21 - 3)) and v113.ManaTea:IsCastable()) then
							if (v24(v113.ManaTea, nil) or ((2043 + 1899) < (192 + 942))) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((v111 > v99) and v32) or ((3085 - (145 + 247)) == (4081 + 892))) then
							local v249 = 0 + 0;
							while true do
								if (((6361 - 4215) == (412 + 1734)) and (v249 == (0 + 0))) then
									v29 = v132();
									if (v29 or ((3643 - 1399) == (3944 - (254 + 466)))) then
										return v29;
									end
									break;
								end
							end
						end
						if (v31 or ((5464 - (544 + 16)) <= (6089 - 4173))) then
							v29 = v129();
							if (((718 - (294 + 334)) <= (1318 - (236 + 17))) and v29) then
								return v29;
							end
						end
						v29 = v128();
						if (((2071 + 2731) == (3738 + 1064)) and v29) then
							return v29;
						end
					end
					break;
				end
				if ((v198 == (0 - 0)) or ((10794 - 8514) <= (264 + 247))) then
					if ((v106 and v114.AeratedManaPotion:IsReady() and (v13:ManaPercentage() <= v107)) or ((1381 + 295) <= (1257 - (413 + 381)))) then
						if (((163 + 3706) == (8228 - 4359)) and v24(v115.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					if (((3007 - 1849) <= (4583 - (582 + 1388))) and (v13:DebuffStack(v113.Bursting) > (8 - 3))) then
						if ((v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) or ((1693 + 671) <= (2363 - (326 + 38)))) then
							if (v24(v113.DiffuseMagic, nil) or ((14560 - 9638) < (276 - 82))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					v198 = 621 - (47 + 573);
				end
			end
		end
		if (((v30 or v13:AffectingCombat()) and v120.TargetIsValid() and v13:CanAttack(v15)) or ((738 + 1353) < (131 - 100))) then
			local v199 = 0 - 0;
			while true do
				if ((v199 == (1664 - (1269 + 395))) or ((2922 - (76 + 416)) >= (5315 - (319 + 124)))) then
					v29 = v123();
					if (v29 or ((10903 - 6133) < (2742 - (564 + 443)))) then
						return v29;
					end
					v199 = 2 - 1;
				end
				if ((v199 == (459 - (337 + 121))) or ((13006 - 8567) <= (7828 - 5478))) then
					if ((v97 and ((v32 and v98) or not v98)) or ((6390 - (1261 + 650)) < (1890 + 2576))) then
						local v248 = 0 - 0;
						while true do
							if (((4364 - (772 + 1045)) > (173 + 1052)) and (v248 == (144 - (102 + 42)))) then
								v29 = v120.HandleTopTrinket(v116, v32, 1884 - (1524 + 320), nil);
								if (((5941 - (1049 + 221)) > (2830 - (18 + 138))) and v29) then
									return v29;
								end
								v248 = 2 - 1;
							end
							if ((v248 == (1103 - (67 + 1035))) or ((4044 - (136 + 212)) < (14137 - 10810))) then
								v29 = v120.HandleBottomTrinket(v116, v32, 33 + 7, nil);
								if (v29 or ((4188 + 354) == (4574 - (240 + 1364)))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((1334 - (1050 + 32)) <= (7058 - 5081)) and v35) then
						if ((v95 and ((v32 and v96) or not v96) and (v111 < (11 + 7))) or ((2491 - (331 + 724)) == (305 + 3470))) then
							if (v113.BloodFury:IsCastable() or ((2262 - (269 + 375)) < (1655 - (267 + 458)))) then
								if (((1469 + 3254) > (7986 - 3833)) and v24(v113.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (v113.Berserking:IsCastable() or ((4472 - (667 + 151)) >= (6151 - (1410 + 87)))) then
								if (((2848 - (1504 + 393)) <= (4043 - 2547)) and v24(v113.Berserking, nil)) then
									return "berserking main 6";
								end
							end
							if (v113.LightsJudgment:IsCastable() or ((4503 - 2767) == (1367 - (461 + 335)))) then
								if (v24(v113.LightsJudgment, not v15:IsInRange(6 + 34)) or ((2657 - (1730 + 31)) > (6436 - (728 + 939)))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((3701 - 2656) <= (2068 - 1048))) then
								if (v24(v113.Fireblood, nil) or ((2657 - 1497) <= (1396 - (138 + 930)))) then
									return "fireblood main 10";
								end
							end
							if (((3480 + 328) > (2286 + 638)) and v113.AncestralCall:IsCastable()) then
								if (((3335 + 556) < (20085 - 15166)) and v24(v113.AncestralCall, nil)) then
									return "ancestral_call main 12";
								end
							end
							if (v113.BagofTricks:IsCastable() or ((4000 - (459 + 1307)) <= (3372 - (474 + 1396)))) then
								if (v24(v113.BagofTricks, not v15:IsInRange(69 - 29)) or ((2355 + 157) < (2 + 430))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if ((v38 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v13:GCD())) or ((5293 - 3445) == (110 + 755))) then
							if (v24(v113.ThunderFocusTea, nil) or ((15629 - 10947) <= (19803 - 15262))) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((v118 >= (594 - (562 + 29))) and v31) or ((2580 + 446) >= (5465 - (374 + 1045)))) then
							local v250 = 0 + 0;
							while true do
								if (((6235 - 4227) > (1276 - (448 + 190))) and (v250 == (0 + 0))) then
									v29 = v126();
									if (((802 + 973) <= (2107 + 1126)) and v29) then
										return v29;
									end
									break;
								end
							end
						end
						if ((v118 < (11 - 8)) or ((14116 - 9573) == (3491 - (1307 + 187)))) then
							local v251 = 0 - 0;
							while true do
								if ((v251 == (0 - 0)) or ((9511 - 6409) < (1411 - (232 + 451)))) then
									v29 = v127();
									if (((330 + 15) == (305 + 40)) and v29) then
										return v29;
									end
									break;
								end
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
		v113.Bursting:RegisterAuraTracking();
		v22.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(834 - (510 + 54), v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

