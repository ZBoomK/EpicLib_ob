local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((5341 - (709 + 387)) <= (6489 - (673 + 1185))) and not v5) then
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
	local v109 = 32223 - 21112;
	local v110 = 35679 - 24568;
	local v111;
	local v112 = v17.Monk.Mistweaver;
	local v113 = v19.Monk.Mistweaver;
	local v114 = v24.Monk.Mistweaver;
	local v115 = {};
	local v116;
	local v117;
	local v118 = {{v112.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v112.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v119 = v21.Commons.Everyone;
	local v120 = v21.Commons.Monk;
	local function v121()
		if (((5559 - (1040 + 243)) >= (11681 - 7767)) and v112.ImprovedDetox:IsAvailable()) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellablePoisonDebuffs, v119.DispellableDiseaseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122()
		if (((2045 - (559 + 1288)) <= (6296 - (609 + 1322))) and v112.DampenHarm:IsCastable() and v12:BuffDown(v112.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) then
			if (((5236 - (13 + 441)) > (17473 - 12797)) and v23(v112.DampenHarm, nil)) then
				return "dampen_harm defensives 1";
			end
		end
		if (((12740 - 7876) > (10942 - 8745)) and v112.FortifyingBrew:IsCastable() and v12:BuffDown(v112.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) then
			if (v23(v112.FortifyingBrew, nil) or ((138 + 3562) == (9104 - 6597))) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((1590 + 2884) >= (121 + 153)) and v112.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v112.ChiHarmonyBuff)) then
			if (v23(v112.ExpelHarm, nil) or ((5620 - 3726) <= (770 + 636))) then
				return "expel_harm defensives 3";
			end
		end
		if (((2890 - 1318) >= (1013 + 518)) and v113.Healthstone:IsReady() and v113.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) then
			if (v23(v114.Healthstone) or ((2607 + 2080) < (3264 + 1278))) then
				return "healthstone defensive 4";
			end
		end
		if (((2764 + 527) > (1631 + 36)) and v85 and (v12:HealthPercentage() <= v86)) then
			local v155 = 433 - (153 + 280);
			while true do
				if ((v155 == (0 - 0)) or ((784 + 89) == (804 + 1230))) then
					if ((v87 == "Refreshing Healing Potion") or ((1474 + 1342) < (10 + 1))) then
						if (((2681 + 1018) < (7165 - 2459)) and v113.RefreshingHealingPotion:IsReady() and v113.RefreshingHealingPotion:IsUsable()) then
							if (((1636 + 1010) >= (1543 - (89 + 578))) and v23(v114.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((439 + 175) <= (6619 - 3435)) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((4175 - (572 + 477)) == (422 + 2704)) and v113.DreamwalkersHealingPotion:IsReady() and v113.DreamwalkersHealingPotion:IsUsable()) then
							if (v23(v114.RefreshingHealingPotion) or ((1313 + 874) >= (592 + 4362))) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		local v137 = 86 - (84 + 2);
		while true do
			if ((v137 == (2 - 0)) or ((2794 + 1083) == (4417 - (497 + 345)))) then
				if (((19 + 688) > (107 + 525)) and v103) then
					local v235 = 1333 - (605 + 728);
					while true do
						if ((v235 == (2 + 0)) or ((1213 - 667) >= (124 + 2560))) then
							v28 = v119.HandleCharredBrambles(v112.Vivify, v114.VivifyMouseover, 147 - 107);
							if (((1321 + 144) <= (11916 - 7615)) and v28) then
								return v28;
							end
							v235 = 3 + 0;
						end
						if (((2193 - (457 + 32)) > (605 + 820)) and ((1403 - (832 + 570)) == v235)) then
							v28 = v119.HandleCharredBrambles(v112.SoothingMist, v114.SoothingMistMouseover, 38 + 2);
							if (v28 or ((180 + 507) == (14983 - 10749))) then
								return v28;
							end
							v235 = 1 + 1;
						end
						if ((v235 == (796 - (588 + 208))) or ((8975 - 5645) < (3229 - (884 + 916)))) then
							v28 = v119.HandleCharredBrambles(v112.RenewingMist, v114.RenewingMistMouseover, 83 - 43);
							if (((666 + 481) >= (988 - (232 + 421))) and v28) then
								return v28;
							end
							v235 = 1890 - (1569 + 320);
						end
						if (((843 + 2592) > (399 + 1698)) and (v235 == (9 - 6))) then
							v28 = v119.HandleCharredBrambles(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 645 - (316 + 289));
							if (v28 or ((9868 - 6098) >= (187 + 3854))) then
								return v28;
							end
							break;
						end
					end
				end
				if (v104 or ((5244 - (666 + 787)) <= (2036 - (360 + 65)))) then
					local v236 = 0 + 0;
					while true do
						if ((v236 == (255 - (79 + 175))) or ((7218 - 2640) <= (1567 + 441))) then
							v28 = v119.HandleFyrakkNPC(v112.SoothingMist, v114.SoothingMistMouseover, 122 - 82);
							if (((2166 - 1041) <= (2975 - (503 + 396))) and v28) then
								return v28;
							end
							v236 = 183 - (92 + 89);
						end
						if ((v236 == (3 - 1)) or ((382 + 361) >= (2604 + 1795))) then
							v28 = v119.HandleFyrakkNPC(v112.Vivify, v114.VivifyMouseover, 156 - 116);
							if (((158 + 997) < (3814 - 2141)) and v28) then
								return v28;
							end
							v236 = 3 + 0;
						end
						if (((0 + 0) == v236) or ((7078 - 4754) <= (73 + 505))) then
							v28 = v119.HandleFyrakkNPC(v112.RenewingMist, v114.RenewingMistMouseover, 61 - 21);
							if (((5011 - (485 + 759)) == (8716 - 4949)) and v28) then
								return v28;
							end
							v236 = 1190 - (442 + 747);
						end
						if (((5224 - (832 + 303)) == (5035 - (88 + 858))) and (v236 == (1 + 2))) then
							v28 = v119.HandleFyrakkNPC(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 34 + 6);
							if (((184 + 4274) >= (2463 - (766 + 23))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
			if (((4798 - 3826) <= (1938 - 520)) and (v137 == (2 - 1))) then
				if (v101 or ((16759 - 11821) < (5835 - (1036 + 37)))) then
					v28 = v119.HandleChromie(v112.Riptide, v114.RiptideMouseover, 29 + 11);
					if (v28 or ((4875 - 2371) > (3355 + 909))) then
						return v28;
					end
					v28 = v119.HandleChromie(v112.HealingSurge, v114.HealingSurgeMouseover, 1520 - (641 + 839));
					if (((3066 - (910 + 3)) == (5488 - 3335)) and v28) then
						return v28;
					end
				end
				if (v102 or ((2191 - (1466 + 218)) >= (1191 + 1400))) then
					local v237 = 1148 - (556 + 592);
					while true do
						if (((1594 + 2887) == (5289 - (329 + 479))) and (v237 == (857 - (174 + 680)))) then
							v28 = v119.HandleCharredTreant(v112.EnvelopingMist, v114.EnvelopingMistMouseover, 137 - 97);
							if (v28 or ((4825 - 2497) < (495 + 198))) then
								return v28;
							end
							break;
						end
						if (((5067 - (396 + 343)) == (383 + 3945)) and (v237 == (1479 - (29 + 1448)))) then
							v28 = v119.HandleCharredTreant(v112.Vivify, v114.VivifyMouseover, 1429 - (135 + 1254));
							if (((5982 - 4394) >= (6219 - 4887)) and v28) then
								return v28;
							end
							v237 = 2 + 1;
						end
						if ((v237 == (1528 - (389 + 1138))) or ((4748 - (102 + 472)) > (4009 + 239))) then
							v28 = v119.HandleCharredTreant(v112.SoothingMist, v114.SoothingMistMouseover, 23 + 17);
							if (v28 or ((4277 + 309) <= (1627 - (320 + 1225)))) then
								return v28;
							end
							v237 = 2 - 0;
						end
						if (((2364 + 1499) == (5327 - (157 + 1307))) and (v237 == (1859 - (821 + 1038)))) then
							v28 = v119.HandleCharredTreant(v112.RenewingMist, v114.RenewingMistMouseover, 99 - 59);
							if (v28 or ((31 + 251) <= (74 - 32))) then
								return v28;
							end
							v237 = 1 + 0;
						end
					end
				end
				v137 = 4 - 2;
			end
			if (((5635 - (834 + 192)) >= (49 + 717)) and (v137 == (0 + 0))) then
				if (v100 or ((25 + 1127) == (3854 - 1366))) then
					v28 = v119.HandleIncorporeal(v112.Paralysis, v114.ParalysisMouseover, 334 - (300 + 4), true);
					if (((914 + 2508) > (8769 - 5419)) and v28) then
						return v28;
					end
				end
				if (((1239 - (112 + 250)) > (150 + 226)) and v99) then
					local v238 = 0 - 0;
					while true do
						if ((v238 == (0 + 0)) or ((1613 + 1505) <= (1385 + 466))) then
							v28 = v119.HandleAfflicted(v112.Detox, v114.DetoxMouseover, 15 + 15);
							if (v28 or ((123 + 42) >= (4906 - (1001 + 413)))) then
								return v28;
							end
							break;
						end
					end
				end
				v137 = 2 - 1;
			end
		end
	end
	local function v124()
		if (((4831 - (244 + 638)) < (5549 - (627 + 66))) and v112.ChiBurst:IsCastable() and v49) then
			if (v23(v112.ChiBurst, not v14:IsInRange(119 - 79)) or ((4878 - (512 + 90)) < (4922 - (1665 + 241)))) then
				return "chi_burst precombat 4";
			end
		end
		if (((5407 - (373 + 344)) > (1861 + 2264)) and v112.SpinningCraneKick:IsCastable() and v45 and (v117 >= (1 + 1))) then
			if (v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(20 - 12)) or ((84 - 34) >= (1995 - (35 + 1064)))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v112.TigerPalm:IsCastable() and v47) or ((1248 + 466) >= (6328 - 3370))) then
			if (v23(v112.TigerPalm, not v14:IsInMeleeRange(1 + 4)) or ((2727 - (298 + 938)) < (1903 - (233 + 1026)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v125()
		local v138 = 1666 - (636 + 1030);
		while true do
			if (((360 + 344) < (965 + 22)) and (v138 == (1 + 1))) then
				if (((252 + 3466) > (2127 - (55 + 166))) and v112.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v112.MysticTouchDebuff) and v112.MysticTouch:IsAvailable()) then
					if (v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(2 + 6)) or ((97 + 861) > (13882 - 10247))) then
						return "spinning_crane_kick aoe 5";
					end
				end
				if (((3798 - (36 + 261)) <= (7855 - 3363)) and v112.BlackoutKick:IsCastable() and v112.AncientConcordance:IsAvailable() and v12:BuffUp(v112.JadefireStomp) and v44 and (v117 >= (1371 - (34 + 1334)))) then
					if (v23(v112.BlackoutKick, not v14:IsInMeleeRange(2 + 3)) or ((2675 + 767) < (3831 - (1035 + 248)))) then
						return "blackout_kick aoe 6";
					end
				end
				v138 = 24 - (20 + 1);
			end
			if (((1498 + 1377) >= (1783 - (134 + 185))) and (v138 == (1134 - (549 + 584)))) then
				if ((v112.JadefireStomp:IsReady() and v48) or ((5482 - (314 + 371)) >= (16797 - 11904))) then
					if (v23(v112.JadefireStomp, nil) or ((1519 - (478 + 490)) > (1096 + 972))) then
						return "JadefireStomp aoe3";
					end
				end
				if (((3286 - (786 + 386)) > (3057 - 2113)) and v112.ChiBurst:IsCastable() and v49) then
					if (v23(v112.ChiBurst, not v14:IsInRange(1419 - (1055 + 324))) or ((3602 - (1093 + 247)) >= (2752 + 344))) then
						return "chi_burst aoe 4";
					end
				end
				v138 = 1 + 1;
			end
			if ((v138 == (0 - 0)) or ((7652 - 5397) >= (10064 - 6527))) then
				if ((v112.SummonWhiteTigerStatue:IsReady() and (v117 >= (7 - 4)) and v43) or ((1365 + 2472) < (5031 - 3725))) then
					if (((10168 - 7218) == (2225 + 725)) and (v42 == "Player")) then
						if (v23(v114.SummonWhiteTigerStatuePlayer, not v14:IsInRange(102 - 62)) or ((5411 - (364 + 324)) < (9040 - 5742))) then
							return "summon_white_tiger_statue aoe player 1";
						end
					elseif (((2725 - 1589) >= (52 + 102)) and (v42 == "Cursor")) then
						if (v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(167 - 127)) or ((433 - 162) > (14420 - 9672))) then
							return "summon_white_tiger_statue aoe cursor 1";
						end
					elseif (((6008 - (1249 + 19)) >= (2846 + 306)) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
						if (v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(155 - 115)) or ((3664 - (686 + 400)) >= (2660 + 730))) then
							return "summon_white_tiger_statue aoe cursor friendly 1";
						end
					elseif (((270 - (73 + 156)) <= (8 + 1653)) and (v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
						if (((1412 - (721 + 90)) < (41 + 3519)) and v23(v114.SummonWhiteTigerStatueCursor, not v14:IsInRange(129 - 89))) then
							return "summon_white_tiger_statue aoe cursor enemy 1";
						end
					elseif (((705 - (224 + 246)) < (1112 - 425)) and (v42 == "Confirmation")) then
						if (((8375 - 3826) > (210 + 943)) and v23(v114.SummonWhiteTigerStatue, not v14:IsInRange(1 + 39))) then
							return "summon_white_tiger_statue aoe confirmation 1";
						end
					end
				end
				if ((v112.TouchofDeath:IsCastable() and v50) or ((3433 + 1241) < (9288 - 4616))) then
					if (((12206 - 8538) < (5074 - (203 + 310))) and v23(v112.TouchofDeath, not v14:IsInMeleeRange(1998 - (1238 + 755)))) then
						return "touch_of_death aoe 2";
					end
				end
				v138 = 1 + 0;
			end
			if ((v138 == (1537 - (709 + 825))) or ((838 - 383) == (5250 - 1645))) then
				if ((v112.TigerPalm:IsCastable() and v112.TeachingsoftheMonastery:IsAvailable() and (v112.BlackoutKick:CooldownRemains() > (864 - (196 + 668))) and v47 and (v117 >= (11 - 8))) or ((5515 - 2852) == (4145 - (171 + 662)))) then
					if (((4370 - (4 + 89)) <= (15684 - 11209)) and v23(v112.TigerPalm, not v14:IsInMeleeRange(2 + 3))) then
						return "tiger_palm aoe 7";
					end
				end
				if ((v112.SpinningCraneKick:IsCastable() and v45) or ((3821 - 2951) == (467 + 722))) then
					if (((3039 - (35 + 1451)) <= (4586 - (28 + 1425))) and v23(v112.SpinningCraneKick, not v14:IsInMeleeRange(2001 - (941 + 1052)))) then
						return "spinning_crane_kick aoe 8";
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (1515 - (822 + 692))) or ((3193 - 956) >= (1654 + 1857))) then
				if ((v112.RisingSunKick:IsReady() and v46) or ((1621 - (45 + 252)) > (2989 + 31))) then
					if (v23(v112.RisingSunKick, not v14:IsInMeleeRange(2 + 3)) or ((7281 - 4289) == (2314 - (114 + 319)))) then
						return "rising_sun_kick st 3";
					end
				end
				if (((4458 - 1352) > (1955 - 429)) and v112.ChiBurst:IsCastable() and v49) then
					if (((1928 + 1095) < (5765 - 1895)) and v23(v112.ChiBurst, not v14:IsInRange(83 - 43))) then
						return "chi_burst st 4";
					end
				end
				v139 = 1965 - (556 + 1407);
			end
			if (((1349 - (741 + 465)) > (539 - (170 + 295))) and (v139 == (2 + 0))) then
				if (((17 + 1) < (5199 - 3087)) and v112.BlackoutKick:IsCastable() and (v12:BuffStack(v112.TeachingsoftheMonasteryBuff) >= (3 + 0)) and (v112.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
					if (((704 + 393) <= (922 + 706)) and v23(v112.BlackoutKick, not v14:IsInMeleeRange(1235 - (957 + 273)))) then
						return "blackout_kick st 5";
					end
				end
				if (((1239 + 3391) == (1854 + 2776)) and v112.TigerPalm:IsCastable() and ((v12:BuffStack(v112.TeachingsoftheMonasteryBuff) < (11 - 8)) or (v12:BuffRemains(v112.TeachingsoftheMonasteryBuff) < (5 - 3))) and v47) then
					if (((10812 - 7272) > (13285 - 10602)) and v23(v112.TigerPalm, not v14:IsInMeleeRange(1785 - (389 + 1391)))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if (((3008 + 1786) >= (341 + 2934)) and (v139 == (0 - 0))) then
				if (((2435 - (783 + 168)) == (4980 - 3496)) and v112.TouchofDeath:IsCastable() and v50) then
					if (((1409 + 23) < (3866 - (309 + 2))) and v23(v112.TouchofDeath, not v14:IsInMeleeRange(15 - 10))) then
						return "touch_of_death st 1";
					end
				end
				if ((v112.JadefireStomp:IsReady() and v48) or ((2277 - (1090 + 122)) > (1161 + 2417))) then
					if (v23(v112.JadefireStomp, nil) or ((16103 - 11308) < (963 + 444))) then
						return "JadefireStomp st 2";
					end
				end
				v139 = 1119 - (628 + 490);
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if (((4587 - 2734) < (21995 - 17182)) and (v140 == (776 - (431 + 343)))) then
				if ((v59 and v112.SoothingMist:IsReady() and v16:BuffDown(v112.SoothingMist)) or ((5697 - 2876) < (7032 - 4601))) then
					if ((v16:HealthPercentage() <= v60) or ((2271 + 603) < (279 + 1902))) then
						if (v23(v114.SoothingMistFocus, not v16:IsSpellInRange(v112.SoothingMist)) or ((4384 - (556 + 1139)) <= (358 - (6 + 9)))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if ((v140 == (0 + 0)) or ((958 + 911) == (2178 - (28 + 141)))) then
				if ((v51 and v112.RenewingMist:IsReady() and v16:BuffDown(v112.RenewingMistBuff) and (v112.RenewingMist:ChargesFractional() >= (1.8 + 0))) or ((4376 - 830) < (1645 + 677))) then
					if ((v16:HealthPercentage() <= v52) or ((3399 - (486 + 831)) == (12420 - 7647))) then
						if (((11420 - 8176) > (200 + 855)) and v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.RenewingMistBuff, false, false, 78 - 53) > (1264 - (668 + 595)))) or ((2982 + 331) <= (359 + 1419))) then
					if (v23(v112.RisingSunKick, not v14:IsInMeleeRange(13 - 8)) or ((1711 - (23 + 267)) >= (4048 - (1129 + 815)))) then
						return "RisingSunKick healing st";
					end
				end
				v140 = 388 - (371 + 16);
			end
			if (((3562 - (1326 + 424)) <= (6153 - 2904)) and (v140 == (3 - 2))) then
				if (((1741 - (88 + 30)) <= (2728 - (720 + 51))) and v51 and v112.RenewingMist:IsReady() and v16:BuffDown(v112.RenewingMistBuff)) then
					if (((9814 - 5402) == (6188 - (421 + 1355))) and (v16:HealthPercentage() <= v52)) then
						if (((2887 - 1137) >= (414 + 428)) and v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((5455 - (286 + 797)) > (6762 - 4912)) and v55 and v112.Vivify:IsReady() and v12:BuffUp(v112.VivaciousVivificationBuff)) then
					if (((383 - 151) < (1260 - (397 + 42))) and (v16:HealthPercentage() <= v56)) then
						if (((162 + 356) < (1702 - (24 + 776))) and v23(v114.VivifyFocus, not v16:IsSpellInRange(v112.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v140 = 2 - 0;
			end
		end
	end
	local function v128()
		local v141 = 785 - (222 + 563);
		while true do
			if (((6596 - 3602) > (618 + 240)) and (v141 == (191 - (23 + 167)))) then
				if ((v66 and v112.ZenPulse:IsReady() and v119.AreUnitsBelowHealthPercentage(v68, v67)) or ((5553 - (690 + 1108)) <= (331 + 584))) then
					if (((3255 + 691) > (4591 - (40 + 808))) and v23(v114.ZenPulseFocus, not v16:IsSpellInRange(v112.ZenPulse))) then
						return "ZenPulse healing aoe";
					end
				end
				if ((v69 and v112.SheilunsGift:IsReady() and v112.SheilunsGift:IsCastable() and v119.AreUnitsBelowHealthPercentage(v71, v70)) or ((220 + 1115) >= (12642 - 9336))) then
					if (((4630 + 214) > (1192 + 1061)) and v23(v112.SheilunsGift, nil)) then
						return "SheilunsGift healing aoe";
					end
				end
				break;
			end
			if (((248 + 204) == (1023 - (47 + 524))) and ((0 + 0) == v141)) then
				if ((v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.RenewingMistBuff, false, false, 68 - 43) > (1 - 0))) or ((10392 - 5835) < (3813 - (1165 + 561)))) then
					if (((116 + 3758) == (11998 - 8124)) and v23(v112.RisingSunKick, not v14:IsInMeleeRange(2 + 3))) then
						return "RisingSunKick healing aoe";
					end
				end
				if (v119.AreUnitsBelowHealthPercentage(v63, v62) or ((2417 - (341 + 138)) > (1333 + 3602))) then
					if ((v35 and (v12:BuffStack(v112.ManaTeaCharges) > v36) and v112.EssenceFont:IsReady() and v112.ManaTea:IsCastable()) or ((8781 - 4526) < (3749 - (89 + 237)))) then
						if (((4677 - 3223) <= (5244 - 2753)) and v23(v112.ManaTea, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v37 and v112.ThunderFocusTea:IsReady() and (v112.EssenceFont:CooldownRemains() < v12:GCD())) or ((5038 - (581 + 300)) <= (4023 - (855 + 365)))) then
						if (((11526 - 6673) >= (974 + 2008)) and v23(v112.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					if (((5369 - (1030 + 205)) > (3152 + 205)) and v61 and v112.EssenceFont:IsReady() and (v12:BuffUp(v112.ThunderFocusTea) or (v112.ThunderFocusTea:CooldownRemains() > (8 + 0)))) then
						if (v23(v112.EssenceFont, nil) or ((3703 - (156 + 130)) < (5757 - 3223))) then
							return "EssenceFont healing aoe";
						end
					end
					if ((v61 and v112.EssenceFont:IsReady() and v112.AncientTeachings:IsAvailable() and v12:BuffDown(v112.EssenceFontBuff)) or ((4586 - 1864) <= (335 - 171))) then
						if (v23(v112.EssenceFont, nil) or ((635 + 1773) < (1230 + 879))) then
							return "EssenceFont healing aoe";
						end
					end
				end
				v141 = 70 - (10 + 59);
			end
		end
	end
	local function v129()
		if ((v57 and v112.EnvelopingMist:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.EnvelopingMist, false, false, 8 + 17) < (14 - 11))) or ((1196 - (671 + 492)) == (1159 + 296))) then
			local v156 = 1215 - (369 + 846);
			while true do
				if ((v156 == (1 + 0)) or ((379 + 64) >= (5960 - (1036 + 909)))) then
					if (((2689 + 693) > (278 - 112)) and v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
				if ((v156 == (203 - (11 + 192))) or ((142 + 138) == (3234 - (135 + 40)))) then
					v28 = v119.FocusUnitRefreshableBuff(v112.EnvelopingMist, 4 - 2, 25 + 15, nil, false, 54 - 29);
					if (((2819 - 938) > (1469 - (50 + 126))) and v28) then
						return v28;
					end
					v156 = 2 - 1;
				end
			end
		end
		if (((522 + 1835) == (3770 - (1233 + 180))) and v46 and v112.RisingSunKick:IsReady() and (v119.FriendlyUnitsWithBuffCount(v112.EnvelopingMist, false, false, 994 - (522 + 447)) > (1423 - (107 + 1314)))) then
			if (((58 + 65) == (374 - 251)) and v23(v112.RisingSunKick, not v14:IsInMeleeRange(3 + 2))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if ((v59 and v112.SoothingMist:IsReady() and v16:BuffUp(v112.ChiHarmonyBuff) and v16:BuffDown(v112.SoothingMist)) or ((2096 - 1040) >= (13420 - 10028))) then
			if (v23(v114.SoothingMistFocus, not v16:IsSpellInRange(v112.SoothingMist)) or ((2991 - (716 + 1194)) < (19 + 1056))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v130()
		if ((v44 and v112.BlackoutKick:IsReady() and (v12:BuffStack(v112.TeachingsoftheMonastery) >= (1 + 2))) or ((1552 - (74 + 429)) >= (8549 - 4117))) then
			if (v23(v112.BlackoutKick, not v14:IsInMeleeRange(3 + 2)) or ((10914 - 6146) <= (599 + 247))) then
				return "Blackout Kick ChiJi";
			end
		end
		if ((v57 and v112.EnvelopingMist:IsReady() and (v12:BuffStack(v112.InvokeChiJiBuff) == (8 - 5))) or ((8302 - 4944) <= (1853 - (279 + 154)))) then
			if ((v16:HealthPercentage() <= v58) or ((4517 - (454 + 324)) <= (2365 + 640))) then
				if (v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist)) or ((1676 - (12 + 5)) >= (1151 + 983))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if ((v46 and v112.RisingSunKick:IsReady()) or ((8306 - 5046) < (871 + 1484))) then
			if (v23(v112.RisingSunKick, not v14:IsInMeleeRange(1098 - (277 + 816))) or ((2858 - 2189) == (5406 - (1058 + 125)))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v57 and v112.EnvelopingMist:IsReady() and (v12:BuffStack(v112.InvokeChiJiBuff) >= (1 + 1))) or ((2667 - (815 + 160)) < (2522 - 1934))) then
			if ((v16:HealthPercentage() <= v58) or ((11387 - 6590) < (871 + 2780))) then
				if (v23(v114.EnvelopingMistFocus, not v16:IsSpellInRange(v112.EnvelopingMist)) or ((12209 - 8032) > (6748 - (41 + 1857)))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if ((v61 and v112.EssenceFont:IsReady() and v112.AncientTeachings:IsAvailable() and v12:BuffDown(v112.AncientTeachings)) or ((2293 - (1222 + 671)) > (2871 - 1760))) then
			if (((4385 - 1334) > (2187 - (229 + 953))) and v23(v112.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v131()
		local v142 = 1774 - (1111 + 663);
		while true do
			if (((5272 - (874 + 705)) <= (614 + 3768)) and (v142 == (2 + 0))) then
				if ((v112.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (51 - 26)) or ((93 + 3189) > (4779 - (642 + 37)))) then
					v28 = v129();
					if (v28 or ((817 + 2763) < (455 + 2389))) then
						return v28;
					end
				end
				if (((222 - 133) < (4944 - (233 + 221))) and v75 and v112.InvokeChiJiTheRedCrane:IsReady() and v112.InvokeChiJiTheRedCrane:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v77, v76)) then
					if ((v51 and v112.RenewingMist:IsReady() and (v112.RenewingMist:ChargesFractional() >= (2 - 1))) or ((4386 + 597) < (3349 - (718 + 823)))) then
						local v243 = 0 + 0;
						while true do
							if (((4634 - (266 + 539)) > (10670 - 6901)) and (v243 == (1225 - (636 + 589)))) then
								v28 = v119.FocusUnitRefreshableBuff(v112.RenewingMistBuff, 14 - 8, 82 - 42, nil, false, 20 + 5);
								if (((540 + 945) <= (3919 - (657 + 358))) and v28) then
									return v28;
								end
								v243 = 2 - 1;
							end
							if (((9725 - 5456) == (5456 - (1151 + 36))) and (v243 == (1 + 0))) then
								if (((102 + 285) <= (8308 - 5526)) and v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist))) then
									return "Renewing Mist ChiJi prep";
								end
								break;
							end
						end
					end
					if ((v69 and v112.SheilunsGift:IsReady() and (v112.SheilunsGift:TimeSinceLastCast() > (1852 - (1552 + 280)))) or ((2733 - (64 + 770)) <= (623 + 294))) then
						if (v23(v112.SheilunsGift, nil) or ((9788 - 5476) <= (156 + 720))) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					if (((3475 - (157 + 1086)) <= (5195 - 2599)) and v112.InvokeChiJiTheRedCrane:IsReady() and (v112.RenewingMist:ChargesFractional() < (4 - 3)) and v12:BuffUp(v112.AncientTeachings) and (v12:BuffStack(v112.TeachingsoftheMonastery) == (3 - 0)) and (v112.SheilunsGift:TimeSinceLastCast() < ((5 - 1) * v12:GCD()))) then
						if (((2914 - (599 + 220)) < (7339 - 3653)) and v23(v112.InvokeChiJiTheRedCrane, nil)) then
							return "Invoke Chi'ji GO";
						end
					end
				end
				v142 = 1934 - (1813 + 118);
			end
			if ((v142 == (0 + 0)) or ((2812 - (841 + 376)) >= (6268 - 1794))) then
				if ((v78 and v112.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) or ((1074 + 3545) < (7866 - 4984))) then
					if (v23(v114.LifeCocoonFocus, not v16:IsSpellInRange(v112.LifeCocoon)) or ((1153 - (464 + 395)) >= (12398 - 7567))) then
						return "Life Cocoon CD";
					end
				end
				if (((975 + 1054) <= (3921 - (467 + 370))) and v80 and v112.Revival:IsReady() and v112.Revival:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81)) then
					if (v23(v112.Revival, nil) or ((4209 - 2172) == (1777 + 643))) then
						return "Revival CD";
					end
				end
				v142 = 3 - 2;
			end
			if (((696 + 3762) > (9082 - 5178)) and (v142 == (521 - (150 + 370)))) then
				if (((1718 - (74 + 1208)) >= (302 - 179)) and v80 and v112.Restoral:IsReady() and v112.Restoral:IsAvailable() and v119.AreUnitsBelowHealthPercentage(v82, v81)) then
					if (((2371 - 1871) < (1293 + 523)) and v23(v112.Restoral, nil)) then
						return "Restoral CD";
					end
				end
				if (((3964 - (14 + 376)) == (6198 - 2624)) and v72 and v112.InvokeYulonTheJadeSerpent:IsAvailable() and v112.InvokeYulonTheJadeSerpent:IsReady() and v119.AreUnitsBelowHealthPercentage(v74, v73)) then
					local v239 = 0 + 0;
					while true do
						if (((195 + 26) < (372 + 18)) and ((0 - 0) == v239)) then
							if ((v51 and v112.RenewingMist:IsReady() and (v112.RenewingMist:ChargesFractional() >= (1 + 0))) or ((2291 - (23 + 55)) <= (3367 - 1946))) then
								v28 = v119.FocusUnitRefreshableBuff(v112.RenewingMistBuff, 5 + 1, 36 + 4, nil, false, 38 - 13);
								if (((962 + 2096) < (5761 - (652 + 249))) and v28) then
									return v28;
								end
								if (v23(v114.RenewingMistFocus, not v16:IsSpellInRange(v112.RenewingMist)) or ((3468 - 2172) >= (6314 - (708 + 1160)))) then
									return "Renewing Mist YuLon prep";
								end
							end
							if ((v35 and v112.ManaTea:IsCastable() and (v12:BuffStack(v112.ManaTeaCharges) >= (8 - 5)) and v12:BuffDown(v112.ManaTeaBuff)) or ((2539 - 1146) > (4516 - (10 + 17)))) then
								if (v23(v112.ManaTea, nil) or ((994 + 3430) < (1759 - (1400 + 332)))) then
									return "ManaTea YuLon prep";
								end
							end
							v239 = 1 - 0;
						end
						if ((v239 == (1909 - (242 + 1666))) or ((855 + 1142) > (1399 + 2416))) then
							if (((2954 + 511) > (2853 - (850 + 90))) and v69 and v112.SheilunsGift:IsReady() and (v112.SheilunsGift:TimeSinceLastCast() > (35 - 15))) then
								if (((2123 - (360 + 1030)) < (1610 + 209)) and v23(v112.SheilunsGift, nil)) then
									return "Sheilun's Gift YuLon prep";
								end
							end
							if ((v112.InvokeYulonTheJadeSerpent:IsReady() and (v112.RenewingMist:ChargesFractional() < (2 - 1)) and v12:BuffUp(v112.ManaTeaBuff) and (v112.SheilunsGift:TimeSinceLastCast() < ((5 - 1) * v12:GCD()))) or ((6056 - (909 + 752)) == (5978 - (109 + 1114)))) then
								if (v23(v112.InvokeYulonTheJadeSerpent, nil) or ((6944 - 3151) < (923 + 1446))) then
									return "Invoke Yu'lon GO";
								end
							end
							break;
						end
					end
				end
				v142 = 244 - (6 + 236);
			end
			if ((v142 == (2 + 1)) or ((3288 + 796) == (624 - 359))) then
				if (((7611 - 3253) == (5491 - (1076 + 57))) and (v112.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (5 + 20))) then
					local v240 = 689 - (579 + 110);
					while true do
						if ((v240 == (0 + 0)) or ((2775 + 363) < (528 + 465))) then
							v28 = v130();
							if (((3737 - (174 + 233)) > (6488 - 4165)) and v28) then
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
		local v143 = 0 - 0;
		while true do
			if ((v143 == (4 + 3)) or ((4800 - (663 + 511)) == (3559 + 430))) then
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v143 = 2 + 6;
			end
			if ((v143 == (24 - 16)) or ((555 + 361) == (6288 - 3617))) then
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v143 = 21 - 12;
			end
			if (((130 + 142) == (529 - 257)) and (v143 == (1 + 0))) then
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v143 = 1 + 1;
			end
			if (((4971 - (478 + 244)) <= (5356 - (440 + 77))) and (v143 == (3 + 3))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v143 = 25 - 18;
			end
			if (((4333 - (655 + 901)) < (594 + 2606)) and ((7 + 2) == v143)) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((65 + 30) < (7883 - 5926)) and (v143 == (1448 - (695 + 750)))) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v143 = 13 - 9;
			end
			if (((1274 - 448) < (6905 - 5188)) and ((353 - (285 + 66)) == v143)) then
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v143 = 6 - 3;
			end
			if (((2736 - (682 + 628)) >= (179 + 926)) and (v143 == (304 - (176 + 123)))) then
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v143 = 3 + 3;
			end
			if (((1998 + 756) <= (3648 - (239 + 30))) and ((0 + 0) == v143)) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v143 = 1 + 0;
			end
			if ((v143 == (6 - 2)) or ((12251 - 8324) == (1728 - (306 + 9)))) then
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v143 = 17 - 12;
			end
		end
	end
	local function v133()
		local v144 = 0 + 0;
		while true do
			if ((v144 == (2 + 0)) or ((556 + 598) <= (2253 - 1465))) then
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v105 = EpicSettings.Settings['useManaPotion'];
				v144 = 1378 - (1140 + 235);
			end
			if ((v144 == (0 + 0)) or ((1507 + 136) > (868 + 2511))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v144 = 53 - (33 + 19);
			end
			if ((v144 == (3 + 4)) or ((8401 - 5598) > (2004 + 2545))) then
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v144 = 15 - 7;
			end
			if ((v144 == (9 + 0)) or ((909 - (586 + 103)) >= (276 + 2746))) then
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((8687 - 5865) == (4310 - (1309 + 179))) and (v144 == (6 - 2))) then
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v144 = 3 + 2;
			end
			if ((v144 == (2 - 1)) or ((802 + 259) == (3945 - 2088))) then
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v144 = 3 - 1;
			end
			if (((3369 - (295 + 314)) > (3349 - 1985)) and ((1970 - (1300 + 662)) == v144)) then
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v82 = EpicSettings.Settings['RevivalHP'];
				v144 = 28 - 19;
			end
			if ((v144 == (1760 - (1178 + 577))) or ((2546 + 2356) <= (10627 - 7032))) then
				v99 = EpicSettings.Settings['handleAfflicted'];
				v100 = EpicSettings.Settings['HandleIncorporeal'];
				v101 = EpicSettings.Settings['HandleChromie'];
				v103 = EpicSettings.Settings['HandleCharredBrambles'];
				v144 = 1411 - (851 + 554);
			end
			if ((v144 == (3 + 0)) or ((10682 - 6830) == (636 - 343))) then
				v106 = EpicSettings.Settings['manaPotionSlider'];
				v107 = EpicSettings.Settings['RevivalBurstingGroup'];
				v108 = EpicSettings.Settings['RevivalBurstingStacks'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v144 = 306 - (115 + 187);
			end
			if ((v144 == (5 + 1)) or ((1476 + 83) == (18079 - 13491))) then
				v102 = EpicSettings.Settings['HandleCharredTreant'];
				v104 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v144 = 1168 - (160 + 1001);
			end
		end
	end
	local v134 = 0 + 0;
	local function v135()
		v132();
		v133();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		if (v12:IsDeadOrGhost() or ((3094 + 1390) == (1612 - 824))) then
			return;
		end
		v116 = v12:GetEnemiesInMeleeRange(366 - (237 + 121));
		if (((5465 - (525 + 372)) >= (7407 - 3500)) and v30) then
			v117 = #v116;
		else
			v117 = 3 - 2;
		end
		if (((1388 - (96 + 46)) < (4247 - (643 + 134))) and (v119.TargetIsValid() or v12:AffectingCombat())) then
			v111 = v12:GetEnemiesInRange(15 + 25);
			v109 = v9.BossFightRemains(nil, true);
			v110 = v109;
			if (((9754 - 5686) >= (3608 - 2636)) and (v110 == (10656 + 455))) then
				v110 = v9.FightRemains(v111, false);
			end
		end
		v28 = v123();
		if (((967 - 474) < (7957 - 4064)) and v28) then
			return v28;
		end
		if (v12:AffectingCombat() or v29 or ((2192 - (316 + 403)) >= (2215 + 1117))) then
			local v157 = v88 and v112.Detox:IsReady() and v32;
			v28 = v119.FocusUnit(v157, nil, nil, nil);
			if (v28 or ((11137 - 7086) <= (419 + 738))) then
				return v28;
			end
			if (((1520 - 916) < (2042 + 839)) and v32 and v88) then
				local v232 = 0 + 0;
				while true do
					if ((v232 == (0 - 0)) or ((4298 - 3398) == (7015 - 3638))) then
						if (((256 + 4203) > (1163 - 572)) and v16) then
							if (((166 + 3232) >= (7046 - 4651)) and v112.Detox:IsCastable() and v119.DispellableFriendlyUnit(42 - (12 + 5))) then
								if ((v134 == (0 - 0)) or ((4657 - 2474) >= (6002 - 3178))) then
									v134 = GetTime();
								end
								if (((4800 - 2864) == (393 + 1543)) and v119.Wait(2473 - (1656 + 317), v134)) then
									if (v23(v114.DetoxFocus, not v16:IsSpellInRange(v112.Detox)) or ((4306 + 526) < (3457 + 856))) then
										return "detox dispel focus";
									end
									v134 = 0 - 0;
								end
							end
						end
						if (((20119 - 16031) > (4228 - (5 + 349))) and v15 and v15:Exists() and v15:IsAPlayer() and v119.UnitHasDispellableDebuffByPlayer(v15)) then
							if (((20576 - 16244) == (5603 - (266 + 1005))) and v112.Detox:IsCastable()) then
								if (((2636 + 1363) >= (9895 - 6995)) and v23(v114.DetoxMouseover, not v15:IsSpellInRange(v112.Detox))) then
									return "detox dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
		end
		if (not v12:AffectingCombat() or ((3324 - 799) > (5760 - (561 + 1135)))) then
			if (((5695 - 1324) == (14367 - 9996)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
				local v233 = v119.DeadFriendlyUnitsCount();
				if ((v233 > (1067 - (507 + 559))) or ((667 - 401) > (15420 - 10434))) then
					if (((2379 - (212 + 176)) >= (1830 - (250 + 655))) and v23(v112.Reawaken, nil)) then
						return "reawaken";
					end
				elseif (((1240 - 785) < (3587 - 1534)) and v23(v114.ResuscitateMouseover, not v14:IsInRange(62 - 22))) then
					return "resuscitate";
				end
			end
		end
		if ((not v12:AffectingCombat() and v29) or ((2782 - (1869 + 87)) == (16825 - 11974))) then
			v28 = v124();
			if (((2084 - (484 + 1417)) == (391 - 208)) and v28) then
				return v28;
			end
		end
		if (((1941 - 782) <= (2561 - (48 + 725))) and (v29 or v12:AffectingCombat())) then
			if ((v105 and v113.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v106)) or ((5728 - 2221) > (11584 - 7266))) then
				if (v23(v114.ManaPotion, nil) or ((1788 + 1287) <= (7923 - 4958))) then
					return "Mana Potion main";
				end
			end
			if (((383 + 982) <= (587 + 1424)) and (v12:DebuffStack(v112.Bursting) > (858 - (152 + 701)))) then
				if ((v112.DiffuseMagic:IsReady() and v112.DiffuseMagic:IsAvailable()) or ((4087 - (430 + 881)) > (1370 + 2205))) then
					if (v23(v112.DiffuseMagic, nil) or ((3449 - (557 + 338)) == (1420 + 3384))) then
						return "Diffues Magic Bursting Player";
					end
				end
			end
			if (((7261 - 4684) == (9024 - 6447)) and (v112.Bursting:MaxDebuffStack() > v108) and (v112.Bursting:AuraActiveCount() > v107)) then
				if ((v80 and v112.Revival:IsReady() and v112.Revival:IsAvailable()) or ((15 - 9) >= (4070 - 2181))) then
					if (((1307 - (499 + 302)) <= (2758 - (39 + 827))) and v23(v112.Revival, nil)) then
						return "Revival Bursting";
					end
				end
			end
			if (v33 or ((5542 - 3534) > (4953 - 2735))) then
				if (((1505 - 1126) <= (6366 - 2219)) and v112.SummonJadeSerpentStatue:IsReady() and v112.SummonJadeSerpentStatue:IsAvailable() and (v112.SummonJadeSerpentStatue:TimeSinceLastCast() > (8 + 82)) and v65) then
					if ((v64 == "Player") or ((13211 - 8697) <= (162 + 847))) then
						if (v23(v114.SummonJadeSerpentStatuePlayer, not v14:IsInRange(63 - 23)) or ((3600 - (103 + 1)) == (1746 - (475 + 79)))) then
							return "jade serpent main player";
						end
					elseif ((v64 == "Cursor") or ((449 - 241) == (9468 - 6509))) then
						if (((553 + 3724) >= (1156 + 157)) and v23(v114.SummonJadeSerpentStatueCursor, not v14:IsInRange(1543 - (1395 + 108)))) then
							return "jade serpent main cursor";
						end
					elseif (((7527 - 4940) < (4378 - (7 + 1197))) and (v64 == "Confirmation")) then
						if (v23(v112.SummonJadeSerpentStatue, not v14:IsInRange(18 + 22)) or ((1438 + 2682) <= (2517 - (27 + 292)))) then
							return "jade serpent main confirmation";
						end
					end
				end
				if ((v35 and (v12:BuffStack(v112.ManaTeaCharges) >= (52 - 34)) and v112.ManaTea:IsCastable()) or ((2035 - 439) == (3598 - 2740))) then
					if (((6350 - 3130) == (6132 - 2912)) and v23(v112.ManaTea, nil)) then
						return "Mana Tea main avoid overcap";
					end
				end
				if (((v110 > v98) and v31) or ((1541 - (43 + 96)) > (14766 - 11146))) then
					local v241 = 0 - 0;
					while true do
						if (((2136 + 438) == (727 + 1847)) and (v241 == (0 - 0))) then
							v28 = v131();
							if (((690 + 1108) < (5166 - 2409)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v30 or ((119 + 258) > (191 + 2413))) then
					local v242 = 1751 - (1414 + 337);
					while true do
						if (((2508 - (1642 + 298)) < (2374 - 1463)) and (v242 == (0 - 0))) then
							v28 = v128();
							if (((9748 - 6463) < (1392 + 2836)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v28 = v127();
				if (((3047 + 869) > (4300 - (357 + 615))) and v28) then
					return v28;
				end
			end
		end
		if (((1755 + 745) < (9419 - 5580)) and (v29 or v12:AffectingCombat()) and v119.TargetIsValid() and v12:CanAttack(v14)) then
			v28 = v122();
			if (((435 + 72) == (1086 - 579)) and v28) then
				return v28;
			end
			if (((192 + 48) <= (216 + 2949)) and v96 and ((v31 and v97) or not v97)) then
				v28 = v119.HandleTopTrinket(v115, v31, 26 + 14, nil);
				if (((2135 - (384 + 917)) >= (1502 - (128 + 569))) and v28) then
					return v28;
				end
				v28 = v119.HandleBottomTrinket(v115, v31, 1583 - (1407 + 136), nil);
				if (v28 or ((5699 - (687 + 1200)) < (4026 - (556 + 1154)))) then
					return v28;
				end
			end
			if (v34 or ((9329 - 6677) <= (1628 - (9 + 86)))) then
				local v234 = 421 - (275 + 146);
				while true do
					if ((v234 == (1 + 0)) or ((3662 - (29 + 35)) < (6470 - 5010))) then
						if (((v117 >= (8 - 5)) and v30) or ((18170 - 14054) < (777 + 415))) then
							v28 = v125();
							if (v28 or ((4389 - (53 + 959)) <= (1311 - (312 + 96)))) then
								return v28;
							end
						end
						if (((6900 - 2924) >= (724 - (147 + 138))) and (v117 < (902 - (813 + 86)))) then
							v28 = v126();
							if (((3391 + 361) == (6951 - 3199)) and v28) then
								return v28;
							end
						end
						break;
					end
					if (((4538 - (18 + 474)) > (910 + 1785)) and ((0 - 0) == v234)) then
						if ((v94 and ((v31 and v95) or not v95) and (v110 < (1104 - (860 + 226)))) or ((3848 - (121 + 182)) == (394 + 2803))) then
							if (((3634 - (988 + 252)) > (43 + 330)) and v112.BloodFury:IsCastable()) then
								if (((1302 + 2853) <= (6202 - (49 + 1921))) and v23(v112.BloodFury, nil)) then
									return "blood_fury main 4";
								end
							end
							if (v112.Berserking:IsCastable() or ((4471 - (223 + 667)) == (3525 - (51 + 1)))) then
								if (((8597 - 3602) > (7169 - 3821)) and v23(v112.Berserking, nil)) then
									return "berserking main 6";
								end
							end
							if (v112.LightsJudgment:IsCastable() or ((1879 - (146 + 979)) > (1052 + 2672))) then
								if (((822 - (311 + 294)) >= (158 - 101)) and v23(v112.LightsJudgment, not v14:IsInRange(17 + 23))) then
									return "lights_judgment main 8";
								end
							end
							if (v112.Fireblood:IsCastable() or ((3513 - (496 + 947)) >= (5395 - (1233 + 125)))) then
								if (((1098 + 1607) == (2427 + 278)) and v23(v112.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							if (((12 + 49) == (1706 - (963 + 682))) and v112.AncestralCall:IsCastable()) then
								if (v23(v112.AncestralCall, nil) or ((584 + 115) >= (2800 - (504 + 1000)))) then
									return "ancestral_call main 12";
								end
							end
							if (v112.BagofTricks:IsCastable() or ((1201 + 582) >= (3293 + 323))) then
								if (v23(v112.BagofTricks, not v14:IsInRange(4 + 36)) or ((5770 - 1857) > (3868 + 659))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if (((2545 + 1831) > (999 - (156 + 26))) and v37 and v112.ThunderFocusTea:IsReady() and not v112.EssenceFont:IsAvailable() and (v112.RisingSunKick:CooldownRemains() < v12:GCD())) then
							if (((2801 + 2060) > (1289 - 465)) and v23(v112.ThunderFocusTea, nil)) then
								return "ThunderFocusTea main 16";
							end
						end
						v234 = 165 - (149 + 15);
					end
				end
			end
		end
	end
	local function v136()
		local v151 = 960 - (890 + 70);
		while true do
			if ((v151 == (117 - (39 + 78))) or ((1865 - (14 + 468)) >= (4686 - 2555))) then
				v121();
				v112.Bursting:RegisterAuraTracking();
				v151 = 2 - 1;
			end
			if ((v151 == (1 + 0)) or ((1127 + 749) >= (540 + 2001))) then
				v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(122 + 148, v135, v136);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

