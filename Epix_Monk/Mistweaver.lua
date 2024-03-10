local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1161 - 667) <= (15309 - 11957)) and not v5) then
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
	local v110 = 20916 - 9805;
	local v111 = 13042 - (609 + 1322);
	local v112;
	local v113 = v17.Monk.Mistweaver;
	local v114 = v19.Monk.Mistweaver;
	local v115 = v24.Monk.Mistweaver;
	local v116 = {};
	local v117;
	local v118;
	local v119 = {{v113.LegSweep,"Cast Leg Sweep (Stun)",function()
		return true;
	end},{v113.Paralysis,"Cast Paralysis (Stun)",function()
		return true;
	end}};
	local v120 = v21.Commons.Everyone;
	local v121 = v21.Commons.Monk;
	local function v122()
		if (v113.ImprovedDetox:IsAvailable() or ((10861 - 7201) <= (1130 + 935))) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if ((v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) or ((7559 - 3449) > (2894 + 1482))) then
			if (v23(v113.DampenHarm, nil) or ((907 + 723) > (3017 + 1181))) then
				return "dampen_harm defensives 1";
			end
		end
		if (((885 + 169) == (1032 + 22)) and v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) then
			if (v23(v113.FortifyingBrew, nil) or ((1109 - (153 + 280)) >= (4741 - 3099))) then
				return "fortifying_brew defensives 2";
			end
		end
		if (((3714 + 422) > (947 + 1450)) and v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) then
			if (v23(v113.ExpelHarm, nil) or ((2269 + 2065) == (3853 + 392))) then
				return "expel_harm defensives 3";
			end
		end
		if ((v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) or ((3099 + 1177) <= (4614 - 1583))) then
			if (v23(v115.Healthstone) or ((2956 + 1826) <= (1866 - (89 + 578)))) then
				return "healthstone defensive 4";
			end
		end
		if ((v85 and (v12:HealthPercentage() <= v86)) or ((3475 + 1389) < (3953 - 2051))) then
			local v148 = 1049 - (572 + 477);
			while true do
				if (((653 + 4186) >= (2221 + 1479)) and (v148 == (0 + 0))) then
					if ((v87 == "Refreshing Healing Potion") or ((1161 - (84 + 2)) > (3160 - 1242))) then
						if (((286 + 110) <= (4646 - (497 + 345))) and v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) then
							if (v23(v115.RefreshingHealingPotion) or ((107 + 4062) == (370 + 1817))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((2739 - (605 + 728)) == (1004 + 402)) and (v87 == "Dreamwalker's Healing Potion")) then
						if (((3403 - 1872) < (196 + 4075)) and v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) then
							if (((2347 - 1712) == (573 + 62)) and v23(v115.RefreshingHealingPotion)) then
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
		if (((9344 - 5971) <= (2685 + 871)) and v101) then
			v28 = v120.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 519 - (457 + 32), true);
			if (v28 or ((1397 + 1894) < (4682 - (832 + 570)))) then
				return v28;
			end
		end
		if (((4132 + 254) >= (228 + 645)) and v100) then
			local v149 = 0 - 0;
			while true do
				if (((444 + 477) <= (1898 - (588 + 208))) and (v149 == (0 - 0))) then
					v28 = v120.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 1830 - (884 + 916));
					if (((9852 - 5146) >= (559 + 404)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (v102 or ((1613 - (232 + 421)) <= (2765 - (1569 + 320)))) then
			local v150 = 0 + 0;
			while true do
				if ((v150 == (1 + 0)) or ((6961 - 4895) == (1537 - (316 + 289)))) then
					v28 = v120.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 104 - 64);
					if (((223 + 4602) < (6296 - (666 + 787))) and v28) then
						return v28;
					end
					break;
				end
				if ((v150 == (425 - (360 + 65))) or ((3624 + 253) >= (4791 - (79 + 175)))) then
					v28 = v120.HandleChromie(v113.Riptide, v115.RiptideMouseover, 63 - 23);
					if (v28 or ((3368 + 947) < (5290 - 3564))) then
						return v28;
					end
					v150 = 1 - 0;
				end
			end
		end
		if (v103 or ((4578 - (503 + 396)) < (806 - (92 + 89)))) then
			v28 = v120.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 77 - 37);
			if (v28 or ((2372 + 2253) < (375 + 257))) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 156 - 116);
			if (v28 or ((12 + 71) > (4058 - 2278))) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 35 + 5);
			if (((261 + 285) <= (3280 - 2203)) and v28) then
				return v28;
			end
			v28 = v120.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 5 + 35);
			if (v28 or ((1518 - 522) > (5545 - (485 + 759)))) then
				return v28;
			end
		end
		if (((9417 - 5347) > (1876 - (442 + 747))) and v104) then
			v28 = v120.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 1175 - (832 + 303));
			if (v28 or ((1602 - (88 + 858)) >= (1015 + 2315))) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 34 + 6);
			if (v28 or ((103 + 2389) <= (1124 - (766 + 23)))) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 197 - 157);
			if (((5910 - 1588) >= (6749 - 4187)) and v28) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 135 - 95);
			if (v28 or ((4710 - (1036 + 37)) >= (2673 + 1097))) then
				return v28;
			end
		end
		if (v105 or ((4632 - 2253) > (3602 + 976))) then
			v28 = v120.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 1520 - (641 + 839));
			if (v28 or ((1396 - (910 + 3)) > (1893 - 1150))) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 1724 - (1466 + 218));
			if (((1128 + 1326) > (1726 - (556 + 592))) and v28) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 15 + 25);
			if (((1738 - (329 + 479)) < (5312 - (174 + 680))) and v28) then
				return v28;
			end
			v28 = v120.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 137 - 97);
			if (((1371 - 709) <= (694 + 278)) and v28) then
				return v28;
			end
		end
	end
	local function v125()
		if (((5109 - (396 + 343)) == (387 + 3983)) and v113.ChiBurst:IsCastable() and v49) then
			if (v23(v113.ChiBurst, not v14:IsInRange(1517 - (29 + 1448))) or ((6151 - (135 + 1254)) <= (3243 - 2382))) then
				return "chi_burst precombat 4";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (9 - 7))) or ((942 + 470) == (5791 - (389 + 1138)))) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(582 - (102 + 472))) or ((2990 + 178) < (1194 + 959))) then
				return "spinning_crane_kick precombat 6";
			end
		end
		if ((v113.TigerPalm:IsCastable() and v47) or ((4640 + 336) < (2877 - (320 + 1225)))) then
			if (((8238 - 3610) == (2832 + 1796)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(1469 - (157 + 1307)))) then
				return "tiger_palm precombat 8";
			end
		end
	end
	local function v126()
		if ((v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (1862 - (821 + 1038))) and v43) or ((134 - 80) == (44 + 351))) then
			if (((145 - 63) == (31 + 51)) and (v42 == "Player")) then
				if (v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(99 - 59)) or ((1607 - (834 + 192)) < (18 + 264))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v42 == "Cursor") or ((1184 + 3425) < (54 + 2441))) then
				if (((1783 - 631) == (1456 - (300 + 4))) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(11 + 29))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((4963 - 3067) <= (3784 - (112 + 250))) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(16 + 24)) or ((2480 - 1490) > (929 + 691))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) or ((454 + 423) > (3512 + 1183))) then
				if (((1335 + 1356) >= (1376 + 475)) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(1454 - (1001 + 413)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif ((v42 == "Confirmation") or ((6656 - 3671) >= (5738 - (244 + 638)))) then
				if (((4969 - (627 + 66)) >= (3560 - 2365)) and v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(642 - (512 + 90)))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((5138 - (1665 + 241)) <= (5407 - (373 + 344))) and v113.TouchofDeath:IsCastable() and v50) then
			if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(3 + 2)) or ((238 + 658) >= (8298 - 5152))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((5179 - 2118) >= (4057 - (35 + 1064))) and v113.JadefireStomp:IsReady() and v48) then
			if (((2319 + 868) >= (1377 - 733)) and v23(v113.JadefireStomp, nil)) then
				return "JadefireStomp aoe3";
			end
		end
		if (((3 + 641) <= (1940 - (298 + 938))) and v113.ChiBurst:IsCastable() and v49) then
			if (((2217 - (233 + 1026)) > (2613 - (636 + 1030))) and v23(v113.ChiBurst, not v14:IsInRange(21 + 19))) then
				return "chi_burst aoe 4";
			end
		end
		if (((4388 + 104) >= (789 + 1865)) and v113.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v113.MysticTouchDebuff) and v113.MysticTouch:IsAvailable()) then
			if (((233 + 3209) >= (1724 - (55 + 166))) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(2 + 6))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if ((v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (1 + 2))) or ((12106 - 8936) <= (1761 - (36 + 261)))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(8 - 3)) or ((6165 - (34 + 1334)) == (1687 + 2701))) then
				return "blackout_kick aoe 6";
			end
		end
		if (((429 + 122) <= (1964 - (1035 + 248))) and v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (21 - (20 + 1))) and v47 and (v118 >= (2 + 1))) then
			if (((3596 - (134 + 185)) > (1540 - (549 + 584))) and v23(v113.TigerPalm, not v14:IsInMeleeRange(690 - (314 + 371)))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((16117 - 11422) >= (2383 - (478 + 490))) and v113.SpinningCraneKick:IsCastable() and v45) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(5 + 3)) or ((4384 - (786 + 386)) <= (3057 - 2113))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		local v138 = 1379 - (1055 + 324);
		while true do
			if ((v138 == (1341 - (1093 + 247))) or ((2752 + 344) <= (190 + 1608))) then
				if (((14042 - 10505) == (12003 - 8466)) and v113.RisingSunKick:IsReady() and v46) then
					if (((10918 - 7081) >= (3945 - 2375)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(2 + 3))) then
						return "rising_sun_kick st 3";
					end
				end
				if ((v113.ChiBurst:IsCastable() and v49) or ((11364 - 8414) == (13139 - 9327))) then
					if (((3562 + 1161) >= (5927 - 3609)) and v23(v113.ChiBurst, not v14:IsInRange(728 - (364 + 324)))) then
						return "chi_burst st 4";
					end
				end
				v138 = 5 - 3;
			end
			if ((v138 == (4 - 2)) or ((672 + 1355) > (11933 - 9081))) then
				if ((v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (4 - 1)) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) or ((3450 - 2314) > (5585 - (1249 + 19)))) then
					if (((4286 + 462) == (18481 - 13733)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(1091 - (686 + 400)))) then
						return "blackout_kick st 5";
					end
				end
				if (((2932 + 804) <= (4969 - (73 + 156))) and v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (1 + 2)) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (813 - (721 + 90)))) and v47) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(1 + 4)) or ((11006 - 7616) <= (3530 - (224 + 246)))) then
						return "tiger_palm st 6";
					end
				end
				break;
			end
			if ((v138 == (0 - 0)) or ((1838 - 839) > (489 + 2204))) then
				if (((12 + 451) < (442 + 159)) and v113.TouchofDeath:IsCastable() and v50) then
					if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(9 - 4)) or ((7264 - 5081) < (1200 - (203 + 310)))) then
						return "touch_of_death st 1";
					end
				end
				if (((6542 - (1238 + 755)) == (318 + 4231)) and v113.JadefireStomp:IsReady() and v48) then
					if (((6206 - (709 + 825)) == (8608 - 3936)) and v23(v113.JadefireStomp, nil)) then
						return "JadefireStomp st 2";
					end
				end
				v138 = 1 - 0;
			end
		end
	end
	local function v128()
		if ((v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (865.8 - (196 + 668)))) or ((14482 - 10814) < (818 - 423))) then
			if ((v16:HealthPercentage() <= v52) or ((4999 - (171 + 662)) == (548 - (4 + 89)))) then
				if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((15593 - 11144) == (970 + 1693))) then
					return "RenewingMist healing st";
				end
			end
		end
		if ((v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 109 - 84) > (1 + 0))) or ((5763 - (35 + 1451)) < (4442 - (28 + 1425)))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1998 - (941 + 1052))) or ((835 + 35) >= (5663 - (822 + 692)))) then
				return "RisingSunKick healing st";
			end
		end
		if (((3157 - 945) < (1500 + 1683)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) then
			if (((4943 - (45 + 252)) > (2961 + 31)) and (v16:HealthPercentage() <= v52)) then
				if (((494 + 940) < (7559 - 4453)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
					return "RenewingMist healing st";
				end
			end
		end
		if (((1219 - (114 + 319)) < (4339 - 1316)) and v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) then
			if ((v16:HealthPercentage() <= v56) or ((3128 - 686) < (48 + 26))) then
				if (((6756 - 2221) == (9501 - 4966)) and v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify))) then
					return "Vivify instant healing st";
				end
			end
		end
		if ((v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) or ((4972 - (556 + 1407)) <= (3311 - (741 + 465)))) then
			if (((2295 - (170 + 295)) < (1934 + 1735)) and (v16:HealthPercentage() <= v60)) then
				if (v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist)) or ((1314 + 116) >= (8892 - 5280))) then
					return "SoothingMist healing st";
				end
			end
		end
	end
	local function v129()
		if (((2225 + 458) >= (1578 + 882)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 15 + 10) > (1231 - (957 + 273)))) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(2 + 3)) or ((723 + 1081) >= (12479 - 9204))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (v120.AreUnitsBelowHealthPercentage(v63, v62, v113.EnvelopingMist) or ((3733 - 2316) > (11084 - 7455))) then
			if (((23743 - 18948) > (2182 - (389 + 1391))) and v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) then
				if (((3020 + 1793) > (372 + 3193)) and v23(v113.ManaTea, nil)) then
					return "EssenceFont healing aoe";
				end
			end
			if (((8905 - 4993) == (4863 - (783 + 168))) and v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) then
				if (((9467 - 6646) <= (4746 + 78)) and v23(v113.ThunderFocusTea, nil)) then
					return "ThunderFocusTea healing aoe";
				end
			end
			if (((2049 - (309 + 2)) <= (6740 - 4545)) and v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (1220 - (1090 + 122))))) then
				if (((14 + 27) <= (10135 - 7117)) and v23(v113.EssenceFont, nil)) then
					return "EssenceFont healing aoe";
				end
			end
			if (((1468 + 677) <= (5222 - (628 + 490))) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) then
				if (((483 + 2206) < (11995 - 7150)) and v23(v113.EssenceFont, nil)) then
					return "EssenceFont healing aoe";
				end
			end
		end
		if ((v66 and v113.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v68, v67, v113.EnvelopingMist)) or ((10611 - 8289) > (3396 - (431 + 343)))) then
			if (v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse)) or ((9156 - 4622) == (6022 - 3940))) then
				return "ZenPulse healing aoe";
			end
		end
		if ((v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v71, v70, v113.EnvelopingMist)) or ((1242 + 329) > (239 + 1628))) then
			if (v23(v113.SheilunsGift, nil) or ((4349 - (556 + 1139)) >= (3011 - (6 + 9)))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v130()
		local v139 = 0 + 0;
		while true do
			if (((2038 + 1940) > (2273 - (28 + 141))) and (v139 == (0 + 0))) then
				if (((3696 - 701) > (1092 + 449)) and v57 and v113.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 1342 - (486 + 831)) < (7 - 4))) then
					local v232 = 0 - 0;
					while true do
						if (((614 + 2635) > (3013 - 2060)) and (v232 == (1263 - (668 + 595)))) then
							v28 = v120.FocusUnitRefreshableBuff(v113.EnvelopingMist, 2 + 0, 9 + 31, nil, false, 68 - 43, v113.EnvelopingMist);
							if (v28 or ((3563 - (23 + 267)) > (6517 - (1129 + 815)))) then
								return v28;
							end
							v232 = 388 - (371 + 16);
						end
						if ((v232 == (1751 - (1326 + 424))) or ((5967 - 2816) < (4692 - 3408))) then
							if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((1968 - (88 + 30)) == (2300 - (720 + 51)))) then
								return "Enveloping Mist YuLon";
							end
							break;
						end
					end
				end
				if (((1826 - 1005) < (3899 - (421 + 1355))) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 41 - 16) > (1 + 1))) then
					if (((1985 - (286 + 797)) < (8499 - 6174)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(7 - 2))) then
						return "Rising Sun Kick YuLon";
					end
				end
				v139 = 440 - (397 + 42);
			end
			if (((268 + 590) <= (3762 - (24 + 776))) and (v139 == (1 - 0))) then
				if ((v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) or ((4731 - (222 + 563)) < (2837 - 1549))) then
					if (v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist)) or ((2335 + 907) == (757 - (23 + 167)))) then
						return "Soothing Mist YuLon";
					end
				end
				break;
			end
		end
	end
	local function v131()
		local v140 = 1798 - (690 + 1108);
		while true do
			if (((1 + 0) == v140) or ((699 + 148) >= (2111 - (40 + 808)))) then
				if ((v46 and v113.RisingSunKick:IsReady()) or ((371 + 1882) == (7078 - 5227))) then
					if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(5 + 0)) or ((1105 + 982) > (1301 + 1071))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if ((v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (573 - (47 + 524)))) or ((2885 + 1560) < (11341 - 7192))) then
					if ((v16:HealthPercentage() <= v58) or ((2718 - 900) == (193 - 108))) then
						if (((2356 - (1165 + 561)) < (64 + 2063)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v140 = 6 - 4;
			end
			if ((v140 == (1 + 1)) or ((2417 - (341 + 138)) == (679 + 1835))) then
				if (((8781 - 4526) >= (381 - (89 + 237))) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) then
					if (((9647 - 6648) > (2433 - 1277)) and v23(v113.EssenceFont, nil)) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if (((3231 - (581 + 300)) > (2375 - (855 + 365))) and (v140 == (0 - 0))) then
				if (((1316 + 2713) <= (6088 - (1030 + 205))) and v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (3 + 0))) then
					if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(5 + 0)) or ((802 - (156 + 130)) > (7802 - 4368))) then
						return "Blackout Kick ChiJi";
					end
				end
				if (((6818 - 2772) >= (6211 - 3178)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (1 + 2))) then
					if ((v16:HealthPercentage() <= v58) or ((1586 + 1133) <= (1516 - (10 + 59)))) then
						if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((1170 + 2964) < (19334 - 15408))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v140 = 1164 - (671 + 492);
			end
		end
	end
	local function v132()
		local v141 = 0 + 0;
		while true do
			if ((v141 == (1218 - (369 + 846))) or ((44 + 120) >= (2377 + 408))) then
				if ((v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1970 - (1036 + 909))) or ((418 + 107) == (3540 - 1431))) then
					v28 = v131();
					if (((236 - (11 + 192)) == (17 + 16)) and v28) then
						return v28;
					end
				end
				break;
			end
			if (((3229 - (135 + 40)) <= (9727 - 5712)) and ((2 + 0) == v141)) then
				if (((4121 - 2250) < (5069 - 1687)) and (v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (201 - (50 + 126)))) then
					v28 = v130();
					if (((3600 - 2307) <= (480 + 1686)) and v28) then
						return v28;
					end
				end
				if ((v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v77, v76, v113.EnvelopingMist)) or ((3992 - (1233 + 180)) < (1092 - (522 + 447)))) then
					if ((v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (1422 - (107 + 1314)))) or ((393 + 453) >= (7215 - 4847))) then
						v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 3 + 3, 79 - 39, nil, false, 98 - 73, v113.EnvelopingMist);
						if (v28 or ((5922 - (716 + 1194)) <= (58 + 3300))) then
							return v28;
						end
						if (((161 + 1333) <= (3508 - (74 + 429))) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
							return "Renewing Mist ChiJi prep";
						end
					end
					if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (38 - 18))) or ((1542 + 1569) == (4884 - 2750))) then
						if (((1667 + 688) == (7260 - 4905)) and v23(v113.SheilunsGift, nil)) then
							return "Sheilun's Gift ChiJi prep";
						end
					end
					if ((v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (2 - 1)) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (436 - (279 + 154))) and (v113.SheilunsGift:TimeSinceLastCast() < ((782 - (454 + 324)) * v12:GCD()))) or ((463 + 125) <= (449 - (12 + 5)))) then
						if (((2587 + 2210) >= (9924 - 6029)) and v23(v113.InvokeChiJiTheRedCrane, nil)) then
							return "Invoke Chi'ji GO";
						end
					end
				end
				v141 = 2 + 1;
			end
			if (((4670 - (277 + 816)) == (15284 - 11707)) and (v141 == (1184 - (1058 + 125)))) then
				if (((712 + 3082) > (4668 - (815 + 160))) and v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) then
					if (v23(v113.Restoral, nil) or ((5470 - 4195) == (9732 - 5632))) then
						return "Restoral CD";
					end
				end
				if ((v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v74, v73, v113.EnvelopingMist)) or ((380 + 1211) >= (10464 - 6884))) then
					if (((2881 - (41 + 1857)) <= (3701 - (1222 + 671))) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (2 - 1))) then
						local v236 = 0 - 0;
						while true do
							if ((v236 == (1183 - (229 + 953))) or ((3924 - (1111 + 663)) <= (2776 - (874 + 705)))) then
								if (((528 + 3241) >= (801 + 372)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
									return "Renewing Mist YuLon prep";
								end
								break;
							end
							if (((3086 - 1601) == (42 + 1443)) and (v236 == (679 - (642 + 37)))) then
								v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 2 + 4, 7 + 33, nil, false, 62 - 37, v113.EnvelopingMist);
								if (v28 or ((3769 - (233 + 221)) <= (6432 - 3650))) then
									return v28;
								end
								v236 = 1 + 0;
							end
						end
					end
					if ((v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (1544 - (718 + 823))) and v12:BuffDown(v113.ManaTeaBuff)) or ((552 + 324) >= (3769 - (266 + 539)))) then
						if (v23(v113.ManaTea, nil) or ((6319 - 4087) > (3722 - (636 + 589)))) then
							return "ManaTea YuLon prep";
						end
					end
					if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (47 - 27))) or ((4351 - 2241) <= (264 + 68))) then
						if (((1340 + 2346) > (4187 - (657 + 358))) and v23(v113.SheilunsGift, nil)) then
							return "Sheilun's Gift YuLon prep";
						end
					end
					if ((v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (2 - 1)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((8 - 4) * v12:GCD()))) or ((5661 - (1151 + 36)) < (792 + 28))) then
						if (((1125 + 3154) >= (8606 - 5724)) and v23(v113.InvokeYulonTheJadeSerpent, nil)) then
							return "Invoke Yu'lon GO";
						end
					end
				end
				v141 = 1834 - (1552 + 280);
			end
			if ((v141 == (834 - (64 + 770))) or ((1378 + 651) >= (7992 - 4471))) then
				if ((v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) or ((362 + 1675) >= (5885 - (157 + 1086)))) then
					if (((3442 - 1722) < (19524 - 15066)) and v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon))) then
						return "Life Cocoon CD";
					end
				end
				if ((v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81, v113.EnvelopingMist)) or ((668 - 232) > (4123 - 1102))) then
					if (((1532 - (599 + 220)) <= (1686 - 839)) and v23(v113.Revival, nil)) then
						return "Revival CD";
					end
				end
				v141 = 1932 - (1813 + 118);
			end
		end
	end
	local function v133()
		local v142 = 0 + 0;
		while true do
			if (((3371 - (841 + 376)) <= (5648 - 1617)) and (v142 == (2 + 3))) then
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v142 = 16 - 10;
			end
			if (((5474 - (464 + 395)) == (11843 - 7228)) and (v142 == (2 + 1))) then
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v142 = 841 - (467 + 370);
			end
			if ((v142 == (0 - 0)) or ((2783 + 1007) == (1714 - 1214))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v142 = 1 + 0;
			end
			if (((206 - 117) < (741 - (150 + 370))) and (v142 == (1283 - (74 + 1208)))) then
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v142 = 4 - 2;
			end
			if (((9741 - 7687) >= (1012 + 409)) and (v142 == (392 - (14 + 376)))) then
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v142 = 4 - 1;
			end
			if (((448 + 244) < (2687 + 371)) and (v142 == (6 + 0))) then
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if ((v142 == (11 - 7)) or ((2448 + 806) == (1733 - (23 + 55)))) then
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v142 = 11 - 6;
			end
		end
	end
	local function v134()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (2 + 0)) or ((2009 - 713) == (1545 + 3365))) then
				v106 = EpicSettings.Settings['useManaPotion'];
				v107 = EpicSettings.Settings['manaPotionSlider'];
				v108 = EpicSettings.Settings['RevivalBurstingGroup'];
				v109 = EpicSettings.Settings['RevivalBurstingStacks'];
				v91 = EpicSettings.Settings['InterruptThreshold'];
				v89 = EpicSettings.Settings['InterruptWithStun'];
				v143 = 904 - (652 + 249);
			end
			if (((9013 - 5645) == (5236 - (708 + 1160))) and (v143 == (2 - 1))) then
				v88 = EpicSettings.Settings['dispelDebuffs'];
				v85 = EpicSettings.Settings['useHealingPotion'];
				v86 = EpicSettings.Settings['healingPotionHP'];
				v87 = EpicSettings.Settings['HealingPotionName'];
				v83 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['healthstoneHP'];
				v143 = 3 - 1;
			end
			if (((2670 - (10 + 17)) < (857 + 2958)) and (v143 == (1736 - (1400 + 332)))) then
				v104 = EpicSettings.Settings['HandleCharredBrambles'];
				v103 = EpicSettings.Settings['HandleCharredTreant'];
				v105 = EpicSettings.Settings['HandleFyrakkNPC'];
				v72 = EpicSettings.Settings['UseInvokeYulon'];
				v74 = EpicSettings.Settings['InvokeYulonHP'];
				v73 = EpicSettings.Settings['InvokeYulonGroup'];
				v143 = 9 - 4;
			end
			if (((3821 - (242 + 1666)) > (211 + 282)) and (v143 == (0 + 0))) then
				v95 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useRacials'];
				v97 = EpicSettings.Settings['trinketsWithCD'];
				v96 = EpicSettings.Settings['useTrinkets'];
				v98 = EpicSettings.Settings['fightRemainsCheck'];
				v99 = EpicSettings.Settings['useWeapon'];
				v143 = 1 + 0;
			end
			if (((5695 - (850 + 90)) > (6003 - 2575)) and (v143 == (1396 - (360 + 1030)))) then
				v82 = EpicSettings.Settings['RevivalHP'];
				v81 = EpicSettings.Settings['RevivalGroup'];
				break;
			end
			if (((1223 + 158) <= (6686 - 4317)) and (v143 == (6 - 1))) then
				v75 = EpicSettings.Settings['UseInvokeChiJi'];
				v77 = EpicSettings.Settings['InvokeChiJiHP'];
				v76 = EpicSettings.Settings['InvokeChiJiGroup'];
				v78 = EpicSettings.Settings['UseLifeCocoon'];
				v79 = EpicSettings.Settings['LifeCocoonHP'];
				v80 = EpicSettings.Settings['UseRevival'];
				v143 = 1667 - (909 + 752);
			end
			if ((v143 == (1226 - (109 + 1114))) or ((8866 - 4023) == (1590 + 2494))) then
				v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v92 = EpicSettings.Settings['useSpearHandStrike'];
				v93 = EpicSettings.Settings['useLegSweep'];
				v100 = EpicSettings.Settings['handleAfflicted'];
				v101 = EpicSettings.Settings['HandleIncorporeal'];
				v102 = EpicSettings.Settings['HandleChromie'];
				v143 = 246 - (6 + 236);
			end
		end
	end
	local v135 = 0 + 0;
	local function v136()
		local v144 = 0 + 0;
		while true do
			if (((11010 - 6341) > (633 - 270)) and (v144 == (1137 - (1076 + 57)))) then
				if ((not v12:AffectingCombat() and v29) or ((309 + 1568) >= (3827 - (579 + 110)))) then
					v28 = v125();
					if (((375 + 4367) >= (3206 + 420)) and v28) then
						return v28;
					end
				end
				if (v29 or v12:AffectingCombat() or ((2410 + 2130) == (1323 - (174 + 233)))) then
					if ((v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) or ((3228 - 2072) > (7626 - 3281))) then
						if (((995 + 1242) < (5423 - (663 + 511))) and v23(v115.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if ((v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) or ((2394 + 289) < (5 + 18))) then
						if (((2148 - 1451) <= (501 + 325)) and v23(v115.ManaPotion, nil)) then
							return "Mana Potion main";
						end
					end
					if (((2601 - 1496) <= (2846 - 1670)) and (v12:DebuffStack(v113.Bursting) > (3 + 2))) then
						if (((6576 - 3197) <= (2717 + 1095)) and v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) then
							if (v23(v113.DiffuseMagic, nil) or ((73 + 715) >= (2338 - (478 + 244)))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					if (((2371 - (440 + 77)) <= (1537 + 1842)) and (v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) then
						if (((16649 - 12100) == (6105 - (655 + 901))) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) then
							if (v23(v113.Revival, nil) or ((561 + 2461) >= (2316 + 708))) then
								return "Revival Bursting";
							end
						end
					end
					if (((3255 + 1565) > (8854 - 6656)) and v33) then
						local v237 = 1445 - (695 + 750);
						while true do
							if (((3 - 2) == v237) or ((1637 - 576) >= (19670 - 14779))) then
								if (((1715 - (285 + 66)) <= (10426 - 5953)) and v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) then
									if ((v14:HealthPercentage() <= v60) or ((4905 - (682 + 628)) <= (1 + 2))) then
										if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((4971 - (176 + 123)) == (1612 + 2240))) then
											return "SoothingMist main";
										end
									end
								end
								if (((1131 + 428) == (1828 - (239 + 30))) and v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (5 + 13)) and v113.ManaTea:IsCastable()) then
									if (v23(v113.ManaTea, nil) or ((1684 + 68) <= (1394 - 606))) then
										return "Mana Tea main avoid overcap";
									end
								end
								v237 = 5 - 3;
							end
							if ((v237 == (318 - (306 + 9))) or ((13633 - 9726) == (31 + 146))) then
								v28 = v128();
								if (((2130 + 1340) > (268 + 287)) and v28) then
									return v28;
								end
								break;
							end
							if ((v237 == (0 - 0)) or ((2347 - (1140 + 235)) == (411 + 234))) then
								if (((2918 + 264) >= (543 + 1572)) and v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (142 - (33 + 19))) and v65) then
									if (((1406 + 2487) < (13274 - 8845)) and (v64 == "Player")) then
										if (v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(18 + 22)) or ((5622 - 2755) < (1787 + 118))) then
											return "jade serpent main player";
										end
									elseif ((v64 == "Cursor") or ((2485 - (586 + 103)) >= (369 + 3682))) then
										if (((4984 - 3365) <= (5244 - (1309 + 179))) and v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(72 - 32))) then
											return "jade serpent main cursor";
										end
									elseif (((263 + 341) == (1622 - 1018)) and (v64 == "Confirmation")) then
										if (v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(31 + 9)) or ((9526 - 5042) == (1793 - 893))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if ((v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) or ((5068 - (295 + 314)) <= (2733 - 1620))) then
									if (((5594 - (1300 + 662)) > (10670 - 7272)) and (v14:HealthPercentage() <= v52)) then
										if (((5837 - (1178 + 577)) <= (2554 + 2363)) and v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist))) then
											return "RenewingMist main";
										end
									end
								end
								v237 = 2 - 1;
							end
							if (((6237 - (851 + 554)) >= (1226 + 160)) and ((5 - 3) == v237)) then
								if (((297 - 160) == (439 - (115 + 187))) and (v111 > v98) and v31) then
									local v241 = 0 + 0;
									while true do
										if ((v241 == (0 + 0)) or ((6186 - 4616) >= (5493 - (160 + 1001)))) then
											v28 = v132();
											if (v28 or ((3556 + 508) <= (1256 + 563))) then
												return v28;
											end
											break;
										end
									end
								end
								if (v30 or ((10206 - 5220) < (1932 - (237 + 121)))) then
									v28 = v129();
									if (((5323 - (525 + 372)) > (325 - 153)) and v28) then
										return v28;
									end
								end
								v237 = 9 - 6;
							end
						end
					end
				end
				if (((728 - (96 + 46)) > (1232 - (643 + 134))) and (v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14)) then
					local v233 = 0 + 0;
					while true do
						if (((1980 - 1154) == (3066 - 2240)) and (v233 == (1 + 0))) then
							if ((v96 and ((v31 and v97) or not v97)) or ((7886 - 3867) > (9077 - 4636))) then
								v28 = v120.HandleTopTrinket(v116, v31, 759 - (316 + 403), nil);
								if (((1341 + 676) < (11715 - 7454)) and v28) then
									return v28;
								end
								v28 = v120.HandleBottomTrinket(v116, v31, 15 + 25, nil);
								if (((11876 - 7160) > (57 + 23)) and v28) then
									return v28;
								end
							end
							if (v34 or ((1131 + 2376) == (11337 - 8065))) then
								local v239 = 0 - 0;
								while true do
									if ((v239 == (1 - 0)) or ((51 + 825) >= (6053 - 2978))) then
										if (((213 + 4139) > (7514 - 4960)) and (v118 >= (20 - (12 + 5))) and v30) then
											local v242 = 0 - 0;
											while true do
												if ((v242 == (0 - 0)) or ((9365 - 4959) < (10026 - 5983))) then
													v28 = v126();
													if (v28 or ((384 + 1505) >= (5356 - (1656 + 317)))) then
														return v28;
													end
													break;
												end
											end
										end
										if (((1686 + 206) <= (2191 + 543)) and (v118 < (7 - 4))) then
											local v243 = 0 - 0;
											while true do
												if (((2277 - (5 + 349)) < (10535 - 8317)) and (v243 == (1271 - (266 + 1005)))) then
													v28 = v127();
													if (((1432 + 741) > (1293 - 914)) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v239 == (0 - 0)) or ((4287 - (561 + 1135)) == (4441 - 1032))) then
										if (((14837 - 10323) > (4390 - (507 + 559))) and v94 and ((v31 and v95) or not v95) and (v111 < (45 - 27))) then
											if (v113.BloodFury:IsCastable() or ((643 - 435) >= (5216 - (212 + 176)))) then
												if (v23(v113.BloodFury, nil) or ((2488 - (250 + 655)) > (9726 - 6159))) then
													return "blood_fury main 4";
												end
											end
											if (v113.Berserking:IsCastable() or ((2294 - 981) == (1241 - 447))) then
												if (((5130 - (1869 + 87)) > (10065 - 7163)) and v23(v113.Berserking, nil)) then
													return "berserking main 6";
												end
											end
											if (((6021 - (484 + 1417)) <= (9130 - 4870)) and v113.LightsJudgment:IsCastable()) then
												if (v23(v113.LightsJudgment, not v14:IsInRange(67 - 27)) or ((1656 - (48 + 725)) > (7804 - 3026))) then
													return "lights_judgment main 8";
												end
											end
											if (v113.Fireblood:IsCastable() or ((9712 - 6092) >= (2843 + 2048))) then
												if (((11379 - 7121) > (263 + 674)) and v23(v113.Fireblood, nil)) then
													return "fireblood main 10";
												end
											end
											if (v113.AncestralCall:IsCastable() or ((1419 + 3450) < (1759 - (152 + 701)))) then
												if (v23(v113.AncestralCall, nil) or ((2536 - (430 + 881)) > (1620 + 2608))) then
													return "ancestral_call main 12";
												end
											end
											if (((4223 - (557 + 338)) > (662 + 1576)) and v113.BagofTricks:IsCastable()) then
												if (((10818 - 6979) > (4919 - 3514)) and v23(v113.BagofTricks, not v14:IsInRange(106 - 66))) then
													return "bag_of_tricks main 14";
												end
											end
										end
										if ((v37 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) or ((2786 - 1493) <= (1308 - (499 + 302)))) then
											if (v23(v113.ThunderFocusTea, nil) or ((3762 - (39 + 827)) < (2221 - 1416))) then
												return "ThunderFocusTea main 16";
											end
										end
										v239 = 2 - 1;
									end
								end
							end
							break;
						end
						if (((9198 - 6882) == (3555 - 1239)) and (v233 == (0 + 0))) then
							v28 = v123();
							if (v28 or ((7522 - 4952) == (246 + 1287))) then
								return v28;
							end
							v233 = 1 - 0;
						end
					end
				end
				break;
			end
			if (((104 - (103 + 1)) == v144) or ((1437 - (475 + 79)) == (3156 - 1696))) then
				v133();
				v134();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v144 = 3 - 2;
			end
			if (((1 + 1) == v144) or ((4066 + 553) <= (2502 - (1395 + 108)))) then
				if (v12:IsDeadOrGhost() or ((9923 - 6513) > (5320 - (7 + 1197)))) then
					return;
				end
				v117 = v12:GetEnemiesInMeleeRange(4 + 4);
				if (v30 or ((316 + 587) >= (3378 - (27 + 292)))) then
					v118 = #v117;
				else
					v118 = 2 - 1;
				end
				if (v120.TargetIsValid() or v12:AffectingCombat() or ((5070 - 1094) < (11981 - 9124))) then
					v112 = v12:GetEnemiesInRange(78 - 38);
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					if (((9389 - 4459) > (2446 - (43 + 96))) and (v111 == (45323 - 34212))) then
						v111 = v9.FightRemains(v112, false);
					end
				end
				v144 = 6 - 3;
			end
			if (((1 + 0) == v144) or ((1143 + 2903) < (2551 - 1260))) then
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				v144 = 1 + 1;
			end
			if (((5 - 2) == v144) or ((1336 + 2905) == (260 + 3285))) then
				v28 = v124();
				if (v28 or ((5799 - (1414 + 337)) > (6172 - (1642 + 298)))) then
					return v28;
				end
				if (v12:AffectingCombat() or v29 or ((4562 - 2812) >= (9990 - 6517))) then
					local v234 = 0 - 0;
					local v235;
					while true do
						if (((1042 + 2124) == (2464 + 702)) and (v234 == (972 - (357 + 615)))) then
							v235 = v88 and v113.Detox:IsReady() and v32;
							v28 = v120.FocusUnit(v235, nil, 29 + 11, nil, 61 - 36, v113.EnvelopingMist);
							v234 = 1 + 0;
						end
						if (((3777 - 2014) < (2979 + 745)) and (v234 == (1 + 0))) then
							if (((36 + 21) <= (4024 - (384 + 917))) and v28) then
								return v28;
							end
							if ((v32 and v88) or ((2767 - (128 + 569)) == (1986 - (1407 + 136)))) then
								local v240 = 1887 - (687 + 1200);
								while true do
									if ((v240 == (1710 - (556 + 1154))) or ((9516 - 6811) == (1488 - (9 + 86)))) then
										if (v16 or ((5022 - (275 + 146)) < (10 + 51))) then
											if ((v113.Detox:IsCastable() and v120.UnitHasDispellableDebuffByPlayer(v16)) or ((1454 - (29 + 35)) >= (21025 - 16281))) then
												if ((v135 == (0 - 0)) or ((8842 - 6839) > (2498 + 1336))) then
													v135 = GetTime();
												end
												if (v120.Wait(1512 - (53 + 959), v135) or ((564 - (312 + 96)) > (6791 - 2878))) then
													if (((480 - (147 + 138)) == (1094 - (813 + 86))) and v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox))) then
														return "detox dispel focus";
													end
													v135 = 0 + 0;
												end
											end
										end
										if (((5752 - 2647) >= (2288 - (18 + 474))) and v15 and v15:Exists() and v15:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v15)) then
											if (((1478 + 2901) >= (6955 - 4824)) and v113.Detox:IsCastable()) then
												if (((4930 - (860 + 226)) >= (2346 - (121 + 182))) and v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox))) then
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
				if (not v12:AffectingCombat() or ((398 + 2834) <= (3971 - (988 + 252)))) then
					if (((555 + 4350) == (1537 + 3368)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v238 = v120.DeadFriendlyUnitsCount();
						if ((v238 > (1971 - (49 + 1921))) or ((5026 - (223 + 667)) >= (4463 - (51 + 1)))) then
							if (v23(v113.Reawaken, nil) or ((5091 - 2133) == (8601 - 4584))) then
								return "reawaken";
							end
						elseif (((2353 - (146 + 979)) >= (230 + 583)) and v23(v115.ResuscitateMouseover, not v14:IsInRange(645 - (311 + 294)))) then
							return "resuscitate";
						end
					end
				end
				v144 = 11 - 7;
			end
		end
	end
	local function v137()
		v122();
		v113.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(115 + 155, v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

