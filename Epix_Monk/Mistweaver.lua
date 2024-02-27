local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((15 + 1034) < (479 + 1438)) and not v5) then
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
	local v110 = 11634 - (423 + 100);
	local v111 = 78 + 11033;
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
		if (((2868 - (19 + 13)) > (803 - 309)) and v113.ImprovedDetox:IsAvailable()) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if ((v113.DampenHarm:IsCastable() and v12:BuffDown(v113.FortifyingBrew) and (v12:HealthPercentage() <= v41) and v40) or ((6351 - 3625) == (11052 - 7183))) then
			if (v23(v113.DampenHarm, nil) or ((1137 + 3239) <= (2604 - 1123))) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v113.FortifyingBrew:IsCastable() and v12:BuffDown(v113.DampenHarmBuff) and (v12:HealthPercentage() <= v39) and v38) or ((7033 - 3641) >= (6553 - (1293 + 519)))) then
			if (((6784 - 3459) >= (5623 - 3469)) and v23(v113.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v113.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v54) and v53 and v12:BuffUp(v113.ChiHarmonyBuff)) or ((2476 - 1181) >= (13941 - 10708))) then
			if (((10311 - 5934) > (870 + 772)) and v23(v113.ExpelHarm, nil)) then
				return "expel_harm defensives 3";
			end
		end
		if (((964 + 3759) > (3150 - 1794)) and v114.Healthstone:IsReady() and v114.Healthstone:IsUsable() and v83 and (v12:HealthPercentage() <= v84)) then
			if (v23(v115.Healthstone) or ((956 + 3180) <= (1141 + 2292))) then
				return "healthstone defensive 4";
			end
		end
		if (((2653 + 1592) <= (5727 - (709 + 387))) and v85 and (v12:HealthPercentage() <= v86)) then
			if (((6134 - (673 + 1185)) >= (11350 - 7436)) and (v87 == "Refreshing Healing Potion")) then
				if (((635 - 437) <= (7181 - 2816)) and v114.RefreshingHealingPotion:IsReady() and v114.RefreshingHealingPotion:IsUsable()) then
					if (((3421 + 1361) > (3494 + 1182)) and v23(v115.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive 5";
					end
				end
			end
			if (((6566 - 1702) > (540 + 1657)) and (v87 == "Dreamwalker's Healing Potion")) then
				if ((v114.DreamwalkersHealingPotion:IsReady() and v114.DreamwalkersHealingPotion:IsUsable()) or ((7377 - 3677) == (4921 - 2414))) then
					if (((6354 - (446 + 1434)) >= (1557 - (1040 + 243))) and v23(v115.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive 5";
					end
				end
			end
		end
	end
	local function v124()
		if (v101 or ((5652 - 3758) <= (3253 - (559 + 1288)))) then
			local v183 = 1931 - (609 + 1322);
			while true do
				if (((2026 - (13 + 441)) >= (5720 - 4189)) and (v183 == (0 - 0))) then
					v28 = v120.HandleIncorporeal(v113.Paralysis, v115.ParalysisMouseover, 149 - 119, true);
					if (v28 or ((175 + 4512) < (16495 - 11953))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((1169 + 2122) > (731 + 936)) and v100) then
			local v184 = 0 - 0;
			while true do
				if ((v184 == (0 + 0)) or ((1605 - 732) == (1345 + 689))) then
					v28 = v120.HandleAfflicted(v113.Detox, v115.DetoxMouseover, 17 + 13);
					if (v28 or ((2024 + 792) < (10 + 1))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((3620 + 79) < (5139 - (153 + 280))) and v102) then
			v28 = v120.HandleChromie(v113.Riptide, v115.RiptideMouseover, 115 - 75);
			if (((2376 + 270) >= (346 + 530)) and v28) then
				return v28;
			end
			v28 = v120.HandleChromie(v113.HealingSurge, v115.HealingSurgeMouseover, 21 + 19);
			if (((558 + 56) <= (2308 + 876)) and v28) then
				return v28;
			end
		end
		if (((4759 - 1633) == (1933 + 1193)) and v103) then
			local v185 = 667 - (89 + 578);
			while true do
				if ((v185 == (1 + 0)) or ((4546 - 2359) >= (6003 - (572 + 477)))) then
					v28 = v120.HandleCharredTreant(v113.SoothingMist, v115.SoothingMistMouseover, 6 + 34);
					if (v28 or ((2327 + 1550) == (427 + 3148))) then
						return v28;
					end
					v185 = 88 - (84 + 2);
				end
				if (((1164 - 457) > (456 + 176)) and (v185 == (845 - (497 + 345)))) then
					v28 = v120.HandleCharredTreant(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 2 + 38);
					if (v28 or ((93 + 453) >= (4017 - (605 + 728)))) then
						return v28;
					end
					break;
				end
				if (((1046 + 419) <= (9562 - 5261)) and (v185 == (0 + 0))) then
					v28 = v120.HandleCharredTreant(v113.RenewingMist, v115.RenewingMistMouseover, 147 - 107);
					if (((1537 + 167) > (3947 - 2522)) and v28) then
						return v28;
					end
					v185 = 1 + 0;
				end
				if ((v185 == (491 - (457 + 32))) or ((292 + 395) == (5636 - (832 + 570)))) then
					v28 = v120.HandleCharredTreant(v113.Vivify, v115.VivifyMouseover, 38 + 2);
					if (v28 or ((869 + 2461) < (5056 - 3627))) then
						return v28;
					end
					v185 = 2 + 1;
				end
			end
		end
		if (((1943 - (588 + 208)) >= (902 - 567)) and v104) then
			v28 = v120.HandleCharredBrambles(v113.RenewingMist, v115.RenewingMistMouseover, 1840 - (884 + 916));
			if (((7191 - 3756) > (1216 + 881)) and v28) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.SoothingMist, v115.SoothingMistMouseover, 693 - (232 + 421));
			if (v28 or ((5659 - (1569 + 320)) >= (992 + 3049))) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.Vivify, v115.VivifyMouseover, 8 + 32);
			if (v28 or ((12774 - 8983) <= (2216 - (316 + 289)))) then
				return v28;
			end
			v28 = v120.HandleCharredBrambles(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 104 - 64);
			if (v28 or ((212 + 4366) <= (3461 - (666 + 787)))) then
				return v28;
			end
		end
		if (((1550 - (360 + 65)) <= (1941 + 135)) and v105) then
			local v186 = 254 - (79 + 175);
			while true do
				if ((v186 == (2 - 0)) or ((580 + 163) >= (13483 - 9084))) then
					v28 = v120.HandleFyrakkNPC(v113.Vivify, v115.VivifyMouseover, 77 - 37);
					if (((2054 - (503 + 396)) < (1854 - (92 + 89))) and v28) then
						return v28;
					end
					v186 = 5 - 2;
				end
				if ((v186 == (0 + 0)) or ((1376 + 948) <= (2263 - 1685))) then
					v28 = v120.HandleFyrakkNPC(v113.RenewingMist, v115.RenewingMistMouseover, 6 + 34);
					if (((8589 - 4822) == (3287 + 480)) and v28) then
						return v28;
					end
					v186 = 1 + 0;
				end
				if (((12453 - 8364) == (511 + 3578)) and (v186 == (1 - 0))) then
					v28 = v120.HandleFyrakkNPC(v113.SoothingMist, v115.SoothingMistMouseover, 1284 - (485 + 759));
					if (((10315 - 5857) >= (2863 - (442 + 747))) and v28) then
						return v28;
					end
					v186 = 1137 - (832 + 303);
				end
				if (((1918 - (88 + 858)) <= (433 + 985)) and (v186 == (3 + 0))) then
					v28 = v120.HandleFyrakkNPC(v113.EnvelopingMist, v115.EnvelopingMistMouseover, 2 + 38);
					if (v28 or ((5727 - (766 + 23)) < (23508 - 18746))) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (2 - 1)) or ((8498 - 5994) > (5337 - (1036 + 37)))) then
				if (((1527 + 626) == (4192 - 2039)) and v113.TigerPalm:IsCastable() and v47) then
					if (v23(v113.TigerPalm, not v14:IsInMeleeRange(4 + 1)) or ((1987 - (641 + 839)) >= (3504 - (910 + 3)))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if (((11423 - 6942) == (6165 - (1466 + 218))) and ((0 + 0) == v138)) then
				if ((v113.ChiBurst:IsCastable() and v49) or ((3476 - (556 + 592)) < (247 + 446))) then
					if (((5136 - (329 + 479)) == (5182 - (174 + 680))) and v23(v113.ChiBurst, not v14:IsInRange(137 - 97))) then
						return "chi_burst precombat 4";
					end
				end
				if (((3291 - 1703) >= (952 + 380)) and v113.SpinningCraneKick:IsCastable() and v45 and (v118 >= (741 - (396 + 343)))) then
					if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(1 + 7)) or ((5651 - (29 + 1448)) > (5637 - (135 + 1254)))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v138 = 3 - 2;
			end
		end
	end
	local function v126()
		if ((v113.SummonWhiteTigerStatue:IsReady() and (v118 >= (13 - 10)) and v43) or ((3057 + 1529) <= (1609 - (389 + 1138)))) then
			if (((4437 - (102 + 472)) == (3646 + 217)) and (v42 == "Player")) then
				if (v23(v115.SummonWhiteTigerStatuePlayer, not v14:IsInRange(23 + 17)) or ((263 + 19) <= (1587 - (320 + 1225)))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif (((8204 - 3595) >= (469 + 297)) and (v42 == "Cursor")) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(1504 - (157 + 1307))) or ((3011 - (821 + 1038)) == (6207 - 3719))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((375 + 3047) > (5950 - 2600)) and (v42 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) then
				if (((327 + 550) > (931 - 555)) and v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(1066 - (834 + 192)))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((v42 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) or ((199 + 2919) <= (476 + 1375))) then
				if (v23(v115.SummonWhiteTigerStatueCursor, not v14:IsInRange(1 + 39)) or ((255 - 90) >= (3796 - (300 + 4)))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((1055 + 2894) < (12711 - 7855)) and (v42 == "Confirmation")) then
				if (v23(v115.SummonWhiteTigerStatue, not v14:IsInRange(402 - (112 + 250))) or ((1705 + 2571) < (7555 - 4539))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((2687 + 2003) > (2134 + 1991)) and v113.TouchofDeath:IsCastable() and v50) then
			if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(4 + 1)) or ((25 + 25) >= (666 + 230))) then
				return "touch_of_death aoe 2";
			end
		end
		if ((v113.JadefireStomp:IsReady() and v48) or ((3128 - (1001 + 413)) >= (6596 - 3638))) then
			if (v23(v113.JadefireStomp, nil) or ((2373 - (244 + 638)) < (1337 - (627 + 66)))) then
				return "JadefireStomp aoe3";
			end
		end
		if (((2097 - 1393) < (1589 - (512 + 90))) and v113.ChiBurst:IsCastable() and v49) then
			if (((5624 - (1665 + 241)) > (2623 - (373 + 344))) and v23(v113.ChiBurst, not v14:IsInRange(19 + 21))) then
				return "chi_burst aoe 4";
			end
		end
		if ((v113.SpinningCraneKick:IsCastable() and v45 and v14:DebuffDown(v113.MysticTouchDebuff) and v113.MysticTouch:IsAvailable()) or ((254 + 704) > (9588 - 5953))) then
			if (((5924 - 2423) <= (5591 - (35 + 1064))) and v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(6 + 2))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if ((v113.BlackoutKick:IsCastable() and v113.AncientConcordance:IsAvailable() and v12:BuffUp(v113.JadefireStomp) and v44 and (v118 >= (6 - 3))) or ((14 + 3428) < (3784 - (298 + 938)))) then
			if (((4134 - (233 + 1026)) >= (3130 - (636 + 1030))) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(3 + 2))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v113.TigerPalm:IsCastable() and v113.TeachingsoftheMonastery:IsAvailable() and (v113.BlackoutKick:CooldownRemains() > (0 + 0)) and v47 and (v118 >= (1 + 2))) or ((325 + 4472) >= (5114 - (55 + 166)))) then
			if (v23(v113.TigerPalm, not v14:IsInMeleeRange(1 + 4)) or ((56 + 495) > (7897 - 5829))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((2411 - (36 + 261)) > (1650 - 706)) and v113.SpinningCraneKick:IsCastable() and v45) then
			if (v23(v113.SpinningCraneKick, not v14:IsInMeleeRange(1376 - (34 + 1334))) or ((870 + 1392) >= (2406 + 690))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		if ((v113.TouchofDeath:IsCastable() and v50) or ((3538 - (1035 + 248)) >= (3558 - (20 + 1)))) then
			if (v23(v113.TouchofDeath, not v14:IsInMeleeRange(3 + 2)) or ((4156 - (134 + 185)) < (2439 - (549 + 584)))) then
				return "touch_of_death st 1";
			end
		end
		if (((3635 - (314 + 371)) == (10127 - 7177)) and v113.JadefireStomp:IsReady() and v48) then
			if (v23(v113.JadefireStomp, nil) or ((5691 - (478 + 490)) < (1748 + 1550))) then
				return "JadefireStomp st 2";
			end
		end
		if (((2308 - (786 + 386)) >= (498 - 344)) and v113.RisingSunKick:IsReady() and v46) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(1384 - (1055 + 324))) or ((1611 - (1093 + 247)) > (4220 + 528))) then
				return "rising_sun_kick st 3";
			end
		end
		if (((499 + 4241) >= (12513 - 9361)) and v113.ChiBurst:IsCastable() and v49) then
			if (v23(v113.ChiBurst, not v14:IsInRange(135 - 95)) or ((7335 - 4757) >= (8518 - 5128))) then
				return "chi_burst st 4";
			end
		end
		if (((15 + 26) <= (6398 - 4737)) and v113.BlackoutKick:IsCastable() and (v12:BuffStack(v113.TeachingsoftheMonasteryBuff) >= (10 - 7)) and (v113.RisingSunKick:CooldownRemains() > v12:GCD()) and v44) then
			if (((454 + 147) < (9104 - 5544)) and v23(v113.BlackoutKick, not v14:IsInMeleeRange(693 - (364 + 324)))) then
				return "blackout_kick st 5";
			end
		end
		if (((643 - 408) < (1648 - 961)) and v113.TigerPalm:IsCastable() and ((v12:BuffStack(v113.TeachingsoftheMonasteryBuff) < (1 + 2)) or (v12:BuffRemains(v113.TeachingsoftheMonasteryBuff) < (8 - 6))) and v47) then
			if (((7284 - 2735) > (3501 - 2348)) and v23(v113.TigerPalm, not v14:IsInMeleeRange(1273 - (1249 + 19)))) then
				return "tiger_palm st 6";
			end
		end
	end
	local function v128()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (3 - 2)) or ((5760 - (686 + 400)) < (3666 + 1006))) then
				if (((3897 - (73 + 156)) < (22 + 4539)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff)) then
					if ((v16:HealthPercentage() <= v52) or ((1266 - (721 + 90)) == (41 + 3564))) then
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((8646 - 5983) == (3782 - (224 + 246)))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((6928 - 2651) <= (8239 - 3764)) and v55 and v113.Vivify:IsReady() and v12:BuffUp(v113.VivaciousVivificationBuff)) then
					if ((v16:HealthPercentage() <= v56) or ((158 + 712) == (29 + 1160))) then
						if (((1141 + 412) <= (6228 - 3095)) and v23(v115.VivifyFocus, not v16:IsSpellInRange(v113.Vivify))) then
							return "Vivify instant healing st";
						end
					end
				end
				v139 = 6 - 4;
			end
			if (((515 - (203 + 310)) == v139) or ((4230 - (1238 + 755)) >= (246 + 3265))) then
				if ((v59 and v113.SoothingMist:IsReady() and v16:BuffDown(v113.SoothingMist)) or ((2858 - (709 + 825)) > (5565 - 2545))) then
					if ((v16:HealthPercentage() <= v60) or ((4357 - 1365) == (2745 - (196 + 668)))) then
						if (((12263 - 9157) > (3160 - 1634)) and v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
			if (((3856 - (171 + 662)) < (3963 - (4 + 89))) and (v139 == (0 - 0))) then
				if (((53 + 90) > (324 - 250)) and v51 and v113.RenewingMist:IsReady() and v16:BuffDown(v113.RenewingMistBuff) and (v113.RenewingMist:ChargesFractional() >= (1.8 + 0))) then
					if (((1504 - (35 + 1451)) < (3565 - (28 + 1425))) and (v16:HealthPercentage() <= v52)) then
						if (((3090 - (941 + 1052)) <= (1562 + 66)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((6144 - (822 + 692)) == (6610 - 1980)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 12 + 13) > (298 - (45 + 252)))) then
					if (((3503 + 37) > (924 + 1759)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(12 - 7))) then
						return "RisingSunKick healing st";
					end
				end
				v139 = 434 - (114 + 319);
			end
		end
	end
	local function v129()
		if (((6883 - 2089) >= (4196 - 921)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.RenewingMistBuff, false, false, 16 + 9) > (1 - 0))) then
			if (((3109 - 1625) == (3447 - (556 + 1407))) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(1211 - (741 + 465)))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (((1897 - (170 + 295)) < (1874 + 1681)) and v120.AreUnitsBelowHealthPercentage(v63, v62)) then
			if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) > v36) and v113.EssenceFont:IsReady() and v113.ManaTea:IsCastable()) or ((979 + 86) > (8809 - 5231))) then
				if (v23(v113.ManaTea, nil) or ((3975 + 820) < (903 + 504))) then
					return "EssenceFont healing aoe";
				end
			end
			if (((1050 + 803) < (6043 - (957 + 273))) and v37 and v113.ThunderFocusTea:IsReady() and (v113.EssenceFont:CooldownRemains() < v12:GCD())) then
				if (v23(v113.ThunderFocusTea, nil) or ((755 + 2066) < (974 + 1457))) then
					return "ThunderFocusTea healing aoe";
				end
			end
			if ((v61 and v113.EssenceFont:IsReady() and (v12:BuffUp(v113.ThunderFocusTea) or (v113.ThunderFocusTea:CooldownRemains() > (30 - 22)))) or ((7573 - 4699) < (6661 - 4480))) then
				if (v23(v113.EssenceFont, nil) or ((13315 - 10626) <= (2123 - (389 + 1391)))) then
					return "EssenceFont healing aoe";
				end
			end
			if ((v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.EssenceFontBuff)) or ((1173 + 696) == (210 + 1799))) then
				if (v23(v113.EssenceFont, nil) or ((8072 - 4526) < (3273 - (783 + 168)))) then
					return "EssenceFont healing aoe";
				end
			end
		end
		if ((v66 and v113.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v68, v67)) or ((6987 - 4905) == (4695 + 78))) then
			if (((3555 - (309 + 2)) > (3239 - 2184)) and v23(v115.ZenPulseFocus, not v16:IsSpellInRange(v113.ZenPulse))) then
				return "ZenPulse healing aoe";
			end
		end
		if ((v69 and v113.SheilunsGift:IsReady() and v113.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v71, v70)) or ((4525 - (1090 + 122)) <= (577 + 1201))) then
			if (v23(v113.SheilunsGift, nil) or ((4772 - 3351) >= (1440 + 664))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v130()
		if (((2930 - (628 + 490)) <= (583 + 2666)) and v57 and v113.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 61 - 36) < (13 - 10))) then
			local v187 = 774 - (431 + 343);
			while true do
				if (((3277 - 1654) <= (5661 - 3704)) and (v187 == (0 + 0))) then
					v28 = v120.FocusUnitRefreshableBuff(v113.EnvelopingMist, 1 + 1, 1735 - (556 + 1139), nil, false, 40 - (6 + 9));
					if (((808 + 3604) == (2261 + 2151)) and v28) then
						return v28;
					end
					v187 = 170 - (28 + 141);
				end
				if (((678 + 1072) >= (1038 - 196)) and (v187 == (1 + 0))) then
					if (((5689 - (486 + 831)) > (4814 - 2964)) and v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
			end
		end
		if (((816 - 584) < (156 + 665)) and v46 and v113.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v113.EnvelopingMist, false, false, 78 - 53) > (1265 - (668 + 595)))) then
			if (((467 + 51) < (182 + 720)) and v23(v113.RisingSunKick, not v14:IsInMeleeRange(13 - 8))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((3284 - (23 + 267)) > (2802 - (1129 + 815))) and v59 and v113.SoothingMist:IsReady() and v16:BuffUp(v113.ChiHarmonyBuff) and v16:BuffDown(v113.SoothingMist)) then
			if (v23(v115.SoothingMistFocus, not v16:IsSpellInRange(v113.SoothingMist)) or ((4142 - (371 + 16)) <= (2665 - (1326 + 424)))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v131()
		if (((7473 - 3527) > (13677 - 9934)) and v44 and v113.BlackoutKick:IsReady() and (v12:BuffStack(v113.TeachingsoftheMonastery) >= (121 - (88 + 30)))) then
			if (v23(v113.BlackoutKick, not v14:IsInMeleeRange(776 - (720 + 51))) or ((2969 - 1634) >= (5082 - (421 + 1355)))) then
				return "Blackout Kick ChiJi";
			end
		end
		if (((7990 - 3146) > (1107 + 1146)) and v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) == (1086 - (286 + 797)))) then
			if (((1652 - 1200) == (748 - 296)) and (v16:HealthPercentage() <= v58)) then
				if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((4996 - (397 + 42)) < (652 + 1435))) then
					return "Enveloping Mist 3 Stacks ChiJi";
				end
			end
		end
		if (((4674 - (24 + 776)) == (5967 - 2093)) and v46 and v113.RisingSunKick:IsReady()) then
			if (v23(v113.RisingSunKick, not v14:IsInMeleeRange(790 - (222 + 563))) or ((4269 - 2331) > (3554 + 1381))) then
				return "Rising Sun Kick ChiJi";
			end
		end
		if ((v57 and v113.EnvelopingMist:IsReady() and (v12:BuffStack(v113.InvokeChiJiBuff) >= (192 - (23 + 167)))) or ((6053 - (690 + 1108)) < (1235 + 2188))) then
			if (((1200 + 254) <= (3339 - (40 + 808))) and (v16:HealthPercentage() <= v58)) then
				if (v23(v115.EnvelopingMistFocus, not v16:IsSpellInRange(v113.EnvelopingMist)) or ((685 + 3472) <= (10718 - 7915))) then
					return "Enveloping Mist 2 Stacks ChiJi";
				end
			end
		end
		if (((4639 + 214) >= (1578 + 1404)) and v61 and v113.EssenceFont:IsReady() and v113.AncientTeachings:IsAvailable() and v12:BuffDown(v113.AncientTeachings)) then
			if (((2267 + 1867) > (3928 - (47 + 524))) and v23(v113.EssenceFont, nil)) then
				return "Essence Font ChiJi";
			end
		end
	end
	local function v132()
		if ((v78 and v113.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v79)) or ((2218 + 1199) < (6926 - 4392))) then
			if (v23(v115.LifeCocoonFocus, not v16:IsSpellInRange(v113.LifeCocoon)) or ((4069 - 1347) <= (373 - 209))) then
				return "Life Cocoon CD";
			end
		end
		if ((v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81)) or ((4134 - (1165 + 561)) < (63 + 2046))) then
			if (v23(v113.Revival, nil) or ((102 - 69) == (556 + 899))) then
				return "Revival CD";
			end
		end
		if ((v80 and v113.Restoral:IsReady() and v113.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v82, v81)) or ((922 - (341 + 138)) >= (1084 + 2931))) then
			if (((6979 - 3597) > (492 - (89 + 237))) and v23(v113.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if ((v72 and v113.InvokeYulonTheJadeSerpent:IsAvailable() and v113.InvokeYulonTheJadeSerpent:IsReady() and v120.AreUnitsBelowHealthPercentage(v74, v73)) or ((900 - 620) == (6439 - 3380))) then
			if (((2762 - (581 + 300)) > (2513 - (855 + 365))) and v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (2 - 1))) then
				local v233 = 0 + 0;
				while true do
					if (((3592 - (1030 + 205)) == (2213 + 144)) and (v233 == (0 + 0))) then
						v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 292 - (156 + 130), 90 - 50, nil, false, 42 - 17);
						if (((251 - 128) == (33 + 90)) and v28) then
							return v28;
						end
						v233 = 1 + 0;
					end
					if ((v233 == (70 - (10 + 59))) or ((299 + 757) >= (16704 - 13312))) then
						if (v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist)) or ((2244 - (671 + 492)) < (856 + 219))) then
							return "Renewing Mist YuLon prep";
						end
						break;
					end
				end
			end
			if ((v35 and v113.ManaTea:IsCastable() and (v12:BuffStack(v113.ManaTeaCharges) >= (1218 - (369 + 846))) and v12:BuffDown(v113.ManaTeaBuff)) or ((278 + 771) >= (3783 + 649))) then
				if (v23(v113.ManaTea, nil) or ((6713 - (1036 + 909)) <= (673 + 173))) then
					return "ManaTea YuLon prep";
				end
			end
			if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (33 - 13))) or ((3561 - (11 + 192)) <= (718 + 702))) then
				if (v23(v113.SheilunsGift, nil) or ((3914 - (135 + 40)) <= (7280 - 4275))) then
					return "Sheilun's Gift YuLon prep";
				end
			end
			if ((v113.InvokeYulonTheJadeSerpent:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.ManaTeaBuff) and (v113.SheilunsGift:TimeSinceLastCast() < ((8 - 4) * v12:GCD()))) or ((2486 - 827) >= (2310 - (50 + 126)))) then
				if (v23(v113.InvokeYulonTheJadeSerpent, nil) or ((9077 - 5817) < (522 + 1833))) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if ((v113.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (1438 - (1233 + 180))) or ((1638 - (522 + 447)) == (5644 - (107 + 1314)))) then
			local v188 = 0 + 0;
			while true do
				if ((v188 == (0 - 0)) or ((719 + 973) < (1167 - 579))) then
					v28 = v130();
					if (v28 or ((18979 - 14182) < (5561 - (716 + 1194)))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v75 and v113.InvokeChiJiTheRedCrane:IsReady() and v113.InvokeChiJiTheRedCrane:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v77, v76)) or ((72 + 4105) > (520 + 4330))) then
			if ((v51 and v113.RenewingMist:IsReady() and (v113.RenewingMist:ChargesFractional() >= (504 - (74 + 429)))) or ((771 - 371) > (551 + 560))) then
				v28 = v120.FocusUnitRefreshableBuff(v113.RenewingMistBuff, 13 - 7, 29 + 11, nil, false, 76 - 51);
				if (((7543 - 4492) > (1438 - (279 + 154))) and v28) then
					return v28;
				end
				if (((4471 - (454 + 324)) <= (3448 + 934)) and v23(v115.RenewingMistFocus, not v16:IsSpellInRange(v113.RenewingMist))) then
					return "Renewing Mist ChiJi prep";
				end
			end
			if ((v69 and v113.SheilunsGift:IsReady() and (v113.SheilunsGift:TimeSinceLastCast() > (37 - (12 + 5)))) or ((1770 + 1512) > (10446 - 6346))) then
				if (v23(v113.SheilunsGift, nil) or ((1323 + 2257) < (3937 - (277 + 816)))) then
					return "Sheilun's Gift ChiJi prep";
				end
			end
			if (((380 - 291) < (5673 - (1058 + 125))) and v113.InvokeChiJiTheRedCrane:IsReady() and (v113.RenewingMist:ChargesFractional() < (1 + 0)) and v12:BuffUp(v113.AncientTeachings) and (v12:BuffStack(v113.TeachingsoftheMonastery) == (978 - (815 + 160))) and (v113.SheilunsGift:TimeSinceLastCast() < ((17 - 13) * v12:GCD()))) then
				if (v23(v113.InvokeChiJiTheRedCrane, nil) or ((11828 - 6845) < (432 + 1376))) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if (((11192 - 7363) > (5667 - (41 + 1857))) and (v113.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (1918 - (1222 + 671)))) then
			local v189 = 0 - 0;
			while true do
				if (((2134 - 649) <= (4086 - (229 + 953))) and (v189 == (1774 - (1111 + 663)))) then
					v28 = v131();
					if (((5848 - (874 + 705)) == (598 + 3671)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v133()
		local v140 = 0 + 0;
		while true do
			if (((803 - 416) <= (79 + 2703)) and (v140 == (685 - (642 + 37)))) then
				v64 = EpicSettings.Settings['JadeSerpentUsage'];
				v66 = EpicSettings.Settings['UseZenPulse'];
				v68 = EpicSettings.Settings['ZenPulseHP'];
				v67 = EpicSettings.Settings['ZenPulseGroup'];
				v69 = EpicSettings.Settings['UseSheilunsGift'];
				v140 = 2 + 5;
			end
			if ((v140 == (1 + 3)) or ((4767 - 2868) <= (1371 - (233 + 221)))) then
				v55 = EpicSettings.Settings['UseVivify'];
				v56 = EpicSettings.Settings['VivifyHP'];
				v57 = EpicSettings.Settings['UseEnvelopingMist'];
				v58 = EpicSettings.Settings['EnvelopingMistHP'];
				v59 = EpicSettings.Settings['UseSoothingMist'];
				v140 = 11 - 6;
			end
			if ((v140 == (7 + 0)) or ((5853 - (718 + 823)) <= (552 + 324))) then
				v71 = EpicSettings.Settings['SheilunsGiftHP'];
				v70 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((3037 - (266 + 539)) <= (7349 - 4753)) and (v140 == (1225 - (636 + 589)))) then
				v35 = EpicSettings.Settings['UseManaTea'];
				v36 = EpicSettings.Settings['ManaTeaStacks'];
				v37 = EpicSettings.Settings['UseThunderFocusTea'];
				v38 = EpicSettings.Settings['UseFortifyingBrew'];
				v39 = EpicSettings.Settings['FortifyingBrewHP'];
				v140 = 2 - 1;
			end
			if (((4320 - 2225) < (2922 + 764)) and (v140 == (2 + 3))) then
				v60 = EpicSettings.Settings['SoothingMistHP'];
				v61 = EpicSettings.Settings['UseEssenceFont'];
				v63 = EpicSettings.Settings['EssenceFontHP'];
				v62 = EpicSettings.Settings['EssenceFontGroup'];
				v65 = EpicSettings.Settings['UseJadeSerpent'];
				v140 = 1021 - (657 + 358);
			end
			if ((v140 == (7 - 4)) or ((3633 - 2038) >= (5661 - (1151 + 36)))) then
				v50 = EpicSettings.Settings['UseTouchOfDeath'];
				v51 = EpicSettings.Settings['UseRenewingMist'];
				v52 = EpicSettings.Settings['RenewingMistHP'];
				v53 = EpicSettings.Settings['UseExpelHarm'];
				v54 = EpicSettings.Settings['ExpelHarmHP'];
				v140 = 4 + 0;
			end
			if ((v140 == (1 + 0)) or ((13794 - 9175) < (4714 - (1552 + 280)))) then
				v40 = EpicSettings.Settings['UseDampenHarm'];
				v41 = EpicSettings.Settings['DampenHarmHP'];
				v42 = EpicSettings.Settings['WhiteTigerUsage'];
				v43 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v44 = EpicSettings.Settings['UseBlackoutKick'];
				v140 = 836 - (64 + 770);
			end
			if ((v140 == (2 + 0)) or ((667 - 373) >= (858 + 3973))) then
				v45 = EpicSettings.Settings['UseSpinningCraneKick'];
				v46 = EpicSettings.Settings['UseRisingSunKick'];
				v47 = EpicSettings.Settings['UseTigerPalm'];
				v48 = EpicSettings.Settings['UseJadefireStomp'];
				v49 = EpicSettings.Settings['UseChiBurst'];
				v140 = 1246 - (157 + 1086);
			end
		end
	end
	local function v134()
		v95 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useRacials'];
		v97 = EpicSettings.Settings['trinketsWithCD'];
		v96 = EpicSettings.Settings['useTrinkets'];
		v98 = EpicSettings.Settings['fightRemainsCheck'];
		v99 = EpicSettings.Settings['useWeapon'];
		v88 = EpicSettings.Settings['dispelDebuffs'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v86 = EpicSettings.Settings['healingPotionHP'];
		v87 = EpicSettings.Settings['HealingPotionName'];
		v83 = EpicSettings.Settings['useHealthstone'];
		v84 = EpicSettings.Settings['healthstoneHP'];
		v106 = EpicSettings.Settings['useManaPotion'];
		v107 = EpicSettings.Settings['manaPotionSlider'];
		v108 = EpicSettings.Settings['RevivalBurstingGroup'];
		v109 = EpicSettings.Settings['RevivalBurstingStacks'];
		v91 = EpicSettings.Settings['InterruptThreshold'];
		v89 = EpicSettings.Settings['InterruptWithStun'];
		v90 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v92 = EpicSettings.Settings['useSpearHandStrike'];
		v93 = EpicSettings.Settings['useLegSweep'];
		v100 = EpicSettings.Settings['handleAfflicted'];
		v101 = EpicSettings.Settings['HandleIncorporeal'];
		v102 = EpicSettings.Settings['HandleChromie'];
		v104 = EpicSettings.Settings['HandleCharredBrambles'];
		v103 = EpicSettings.Settings['HandleCharredTreant'];
		v105 = EpicSettings.Settings['HandleFyrakkNPC'];
		v72 = EpicSettings.Settings['UseInvokeYulon'];
		v74 = EpicSettings.Settings['InvokeYulonHP'];
		v73 = EpicSettings.Settings['InvokeYulonGroup'];
		v75 = EpicSettings.Settings['UseInvokeChiJi'];
		v77 = EpicSettings.Settings['InvokeChiJiHP'];
		v76 = EpicSettings.Settings['InvokeChiJiGroup'];
		v78 = EpicSettings.Settings['UseLifeCocoon'];
		v79 = EpicSettings.Settings['LifeCocoonHP'];
		v80 = EpicSettings.Settings['UseRevival'];
		v82 = EpicSettings.Settings['RevivalHP'];
		v81 = EpicSettings.Settings['RevivalGroup'];
	end
	local v135 = 0 - 0;
	local function v136()
		local v179 = 0 - 0;
		while true do
			if (((3111 - 1082) <= (4209 - 1125)) and (v179 == (822 - (599 + 220)))) then
				v117 = v12:GetEnemiesInMeleeRange(15 - 7);
				if (v30 or ((3968 - (1813 + 118)) == (1769 + 651))) then
					v118 = #v117;
				else
					v118 = 1218 - (841 + 376);
				end
				if (((6246 - 1788) > (907 + 2997)) and (v120.TargetIsValid() or v12:AffectingCombat())) then
					v112 = v12:GetEnemiesInRange(109 - 69);
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					if (((1295 - (464 + 395)) >= (315 - 192)) and (v111 == (5336 + 5775))) then
						v111 = v9.FightRemains(v112, false);
					end
				end
				v179 = 841 - (467 + 370);
			end
			if (((1033 - 533) < (1334 + 482)) and ((3 - 2) == v179)) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['dispel'];
				v179 = 1 + 1;
			end
			if (((8314 - 4740) == (4094 - (150 + 370))) and (v179 == (1282 - (74 + 1208)))) then
				v133();
				v134();
				v29 = EpicSettings.Toggles['ooc'];
				v179 = 2 - 1;
			end
			if (((1048 - 827) < (278 + 112)) and ((392 - (14 + 376)) == v179)) then
				v33 = EpicSettings.Toggles['healing'];
				v34 = EpicSettings.Toggles['dps'];
				if (v12:IsDeadOrGhost() or ((3837 - 1624) <= (920 + 501))) then
					return;
				end
				v179 = 3 + 0;
			end
			if (((2917 + 141) < (14240 - 9380)) and ((4 + 1) == v179)) then
				if (not v12:AffectingCombat() or ((1374 - (23 + 55)) >= (10536 - 6090))) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((930 + 463) > (4032 + 457))) then
						local v238 = 0 - 0;
						local v239;
						while true do
							if ((v238 == (0 + 0)) or ((5325 - (652 + 249)) < (72 - 45))) then
								v239 = v120.DeadFriendlyUnitsCount();
								if ((v239 > (1869 - (708 + 1160))) or ((5420 - 3423) > (6955 - 3140))) then
									if (((3492 - (10 + 17)) > (430 + 1483)) and v23(v113.Reawaken, nil)) then
										return "reawaken";
									end
								elseif (((2465 - (1400 + 332)) < (3488 - 1669)) and v23(v115.ResuscitateMouseover, not v14:IsInRange(1948 - (242 + 1666)))) then
									return "resuscitate";
								end
								break;
							end
						end
					end
				end
				if ((not v12:AffectingCombat() and v29) or ((1881 + 2514) == (1743 + 3012))) then
					local v234 = 0 + 0;
					while true do
						if (((940 - (850 + 90)) == v234) or ((6642 - 2849) < (3759 - (360 + 1030)))) then
							v28 = v125();
							if (v28 or ((3615 + 469) == (747 - 482))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((5995 - 1637) == (6019 - (909 + 752))) and (v29 or v12:AffectingCombat())) then
					local v235 = 1223 - (109 + 1114);
					while true do
						if ((v235 == (3 - 1)) or ((1222 + 1916) < (1235 - (6 + 236)))) then
							if (((2099 + 1231) > (1870 + 453)) and v33) then
								if ((v113.SummonJadeSerpentStatue:IsReady() and v113.SummonJadeSerpentStatue:IsAvailable() and (v113.SummonJadeSerpentStatue:TimeSinceLastCast() > (212 - 122)) and v65) or ((6333 - 2707) == (5122 - (1076 + 57)))) then
									if ((v64 == "Player") or ((151 + 765) == (3360 - (579 + 110)))) then
										if (((22 + 250) == (241 + 31)) and v23(v115.SummonJadeSerpentStatuePlayer, not v14:IsInRange(22 + 18))) then
											return "jade serpent main player";
										end
									elseif (((4656 - (174 + 233)) <= (13516 - 8677)) and (v64 == "Cursor")) then
										if (((4873 - 2096) < (1423 + 1777)) and v23(v115.SummonJadeSerpentStatueCursor, not v14:IsInRange(1214 - (663 + 511)))) then
											return "jade serpent main cursor";
										end
									elseif (((85 + 10) < (425 + 1532)) and (v64 == "Confirmation")) then
										if (((2546 - 1720) < (1040 + 677)) and v23(v113.SummonJadeSerpentStatue, not v14:IsInRange(94 - 54))) then
											return "jade serpent main confirmation";
										end
									end
								end
								if (((3451 - 2025) >= (528 + 577)) and v51 and v113.RenewingMist:IsReady() and v14:BuffDown(v113.RenewingMistBuff) and not v12:CanAttack(v14)) then
									if (((5359 - 2605) <= (2409 + 970)) and (v14:HealthPercentage() <= v52)) then
										if (v23(v113.RenewingMist, not v14:IsSpellInRange(v113.RenewingMist)) or ((359 + 3568) == (2135 - (478 + 244)))) then
											return "RenewingMist main";
										end
									end
								end
								if ((v59 and v113.SoothingMist:IsReady() and v14:BuffDown(v113.SoothingMist) and not v12:CanAttack(v14)) or ((1671 - (440 + 77)) <= (359 + 429))) then
									if ((v14:HealthPercentage() <= v60) or ((6013 - 4370) > (4935 - (655 + 901)))) then
										if (v23(v113.SoothingMist, not v14:IsSpellInRange(v113.SoothingMist)) or ((520 + 2283) > (3483 + 1066))) then
											return "SoothingMist main";
										end
									end
								end
								if ((v35 and (v12:BuffStack(v113.ManaTeaCharges) >= (13 + 5)) and v113.ManaTea:IsCastable()) or ((886 - 666) >= (4467 - (695 + 750)))) then
									if (((9636 - 6814) == (4354 - 1532)) and v23(v113.ManaTea, nil)) then
										return "Mana Tea main avoid overcap";
									end
								end
								if (((v111 > v98) and v31) or ((4267 - 3206) == (2208 - (285 + 66)))) then
									local v242 = 0 - 0;
									while true do
										if (((4070 - (682 + 628)) > (220 + 1144)) and (v242 == (299 - (176 + 123)))) then
											v28 = v132();
											if (v28 or ((2051 + 2851) <= (2608 + 987))) then
												return v28;
											end
											break;
										end
									end
								end
								if (v30 or ((4121 - (239 + 30)) == (80 + 213))) then
									local v243 = 0 + 0;
									while true do
										if ((v243 == (0 - 0)) or ((4863 - 3304) == (4903 - (306 + 9)))) then
											v28 = v129();
											if (v28 or ((15647 - 11163) == (138 + 650))) then
												return v28;
											end
											break;
										end
									end
								end
								v28 = v128();
								if (((2803 + 1765) >= (1881 + 2026)) and v28) then
									return v28;
								end
							end
							break;
						end
						if (((3562 - 2316) < (4845 - (1140 + 235))) and (v235 == (1 + 0))) then
							if (((3731 + 337) >= (250 + 722)) and (v12:DebuffStack(v113.Bursting) > (57 - (33 + 19)))) then
								if (((179 + 314) < (11668 - 7775)) and v113.DiffuseMagic:IsReady() and v113.DiffuseMagic:IsAvailable()) then
									if (v23(v113.DiffuseMagic, nil) or ((649 + 824) >= (6533 - 3201))) then
										return "Diffues Magic Bursting Player";
									end
								end
							end
							if (((v113.Bursting:MaxDebuffStack() > v109) and (v113.Bursting:AuraActiveCount() > v108)) or ((3799 + 252) <= (1846 - (586 + 103)))) then
								if (((55 + 549) < (8869 - 5988)) and v80 and v113.Revival:IsReady() and v113.Revival:IsAvailable()) then
									if (v23(v113.Revival, nil) or ((2388 - (1309 + 179)) == (6095 - 2718))) then
										return "Revival Bursting";
									end
								end
							end
							v235 = 1 + 1;
						end
						if (((11974 - 7515) > (447 + 144)) and (v235 == (0 - 0))) then
							if (((6770 - 3372) >= (3004 - (295 + 314))) and v31 and v99 and (v114.Dreambinder:IsEquippedAndReady() or v114.Iridal:IsEquippedAndReady())) then
								if (v23(v115.UseWeapon, nil) or ((5361 - 3178) >= (4786 - (1300 + 662)))) then
									return "Using Weapon Macro";
								end
							end
							if (((6079 - 4143) == (3691 - (1178 + 577))) and v106 and v114.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v107)) then
								if (v23(v115.ManaPotion, nil) or ((2510 + 2322) < (12749 - 8436))) then
									return "Mana Potion main";
								end
							end
							v235 = 1406 - (851 + 554);
						end
					end
				end
				v179 = 6 + 0;
			end
			if (((11337 - 7249) > (8413 - 4539)) and (v179 == (306 - (115 + 187)))) then
				v28 = v124();
				if (((3318 + 1014) == (4102 + 230)) and v28) then
					return v28;
				end
				if (((15758 - 11759) >= (4061 - (160 + 1001))) and (v12:AffectingCombat() or v29)) then
					local v236 = 0 + 0;
					local v237;
					while true do
						if ((v236 == (2 + 0)) or ((5169 - 2644) > (4422 - (237 + 121)))) then
							v28 = v120.FocusSpecifiedUnit(v120.FriendlyUnitWithHealAbsorb(937 - (525 + 372), nil, 47 - 22), 98 - 68);
							if (((4513 - (96 + 46)) == (5148 - (643 + 134))) and v28) then
								return v28;
							end
							break;
						end
						if ((v236 == (1 + 0)) or ((637 - 371) > (18511 - 13525))) then
							if (((1910 + 81) >= (1815 - 890)) and v28) then
								return v28;
							end
							if (((930 - 475) < (2772 - (316 + 403))) and v32 and v88) then
								if (v16 or ((550 + 276) == (13337 - 8486))) then
									if (((67 + 116) == (460 - 277)) and v113.Detox:IsCastable() and v120.DispellableFriendlyUnit(18 + 7)) then
										if (((374 + 785) <= (6195 - 4407)) and (v135 == (0 - 0))) then
											v135 = GetTime();
										end
										if (v120.Wait(1038 - 538, v135) or ((201 + 3306) > (8500 - 4182))) then
											local v244 = 0 + 0;
											while true do
												if ((v244 == (0 - 0)) or ((3092 - (12 + 5)) <= (11516 - 8551))) then
													if (((2912 - 1547) <= (4274 - 2263)) and v23(v115.DetoxFocus, not v16:IsSpellInRange(v113.Detox))) then
														return "detox dispel focus";
													end
													v135 = 0 - 0;
													break;
												end
											end
										end
									end
								end
								if ((v15 and v15:Exists() and v15:IsAPlayer() and v120.UnitHasDispellableDebuffByPlayer(v15)) or ((564 + 2212) > (5548 - (1656 + 317)))) then
									if (v113.Detox:IsCastable() or ((2276 + 278) == (3850 + 954))) then
										if (((6851 - 4274) == (12682 - 10105)) and v23(v115.DetoxMouseover, not v15:IsSpellInRange(v113.Detox))) then
											return "detox dispel mouseover";
										end
									end
								end
							end
							v236 = 356 - (5 + 349);
						end
						if ((v236 == (0 - 0)) or ((1277 - (266 + 1005)) >= (1245 + 644))) then
							v237 = v88 and v113.Detox:IsReady() and v32;
							v28 = v120.FocusUnit(v237, nil, 136 - 96, nil, 32 - 7);
							v236 = 1697 - (561 + 1135);
						end
					end
				end
				v179 = 6 - 1;
			end
			if (((1663 - 1157) <= (2958 - (507 + 559))) and (v179 == (14 - 8))) then
				if (((v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14)) or ((6209 - 4201) > (2606 - (212 + 176)))) then
					v28 = v123();
					if (((1284 - (250 + 655)) <= (11308 - 7161)) and v28) then
						return v28;
					end
					if ((v96 and ((v31 and v97) or not v97)) or ((7887 - 3373) <= (1578 - 569))) then
						v28 = v120.HandleTopTrinket(v116, v31, 1996 - (1869 + 87), nil);
						if (v28 or ((12125 - 8629) == (3093 - (484 + 1417)))) then
							return v28;
						end
						v28 = v120.HandleBottomTrinket(v116, v31, 85 - 45, nil);
						if (v28 or ((348 - 140) == (3732 - (48 + 725)))) then
							return v28;
						end
					end
					if (((6986 - 2709) >= (3522 - 2209)) and v34) then
						if (((1504 + 1083) < (8482 - 5308)) and v94 and ((v31 and v95) or not v95) and (v111 < (6 + 12))) then
							if (v113.BloodFury:IsCastable() or ((1201 + 2919) <= (3051 - (152 + 701)))) then
								if (v23(v113.BloodFury, nil) or ((2907 - (430 + 881)) == (329 + 529))) then
									return "blood_fury main 4";
								end
							end
							if (((4115 - (557 + 338)) == (952 + 2268)) and v113.Berserking:IsCastable()) then
								if (v23(v113.Berserking, nil) or ((3950 - 2548) > (12676 - 9056))) then
									return "berserking main 6";
								end
							end
							if (((6838 - 4264) == (5547 - 2973)) and v113.LightsJudgment:IsCastable()) then
								if (((2599 - (499 + 302)) < (3623 - (39 + 827))) and v23(v113.LightsJudgment, not v14:IsInRange(110 - 70))) then
									return "lights_judgment main 8";
								end
							end
							if (v113.Fireblood:IsCastable() or ((841 - 464) > (10342 - 7738))) then
								if (((871 - 303) < (78 + 833)) and v23(v113.Fireblood, nil)) then
									return "fireblood main 10";
								end
							end
							if (((9614 - 6329) < (677 + 3551)) and v113.AncestralCall:IsCastable()) then
								if (((6196 - 2280) > (3432 - (103 + 1))) and v23(v113.AncestralCall, nil)) then
									return "ancestral_call main 12";
								end
							end
							if (((3054 - (475 + 79)) < (8298 - 4459)) and v113.BagofTricks:IsCastable()) then
								if (((1622 - 1115) == (66 + 441)) and v23(v113.BagofTricks, not v14:IsInRange(36 + 4))) then
									return "bag_of_tricks main 14";
								end
							end
						end
						if (((1743 - (1395 + 108)) <= (9210 - 6045)) and v37 and v113.ThunderFocusTea:IsReady() and not v113.EssenceFont:IsAvailable() and (v113.RisingSunKick:CooldownRemains() < v12:GCD())) then
							if (((2038 - (7 + 1197)) >= (351 + 454)) and v23(v113.ThunderFocusTea, nil)) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((v118 >= (2 + 1)) and v30) or ((4131 - (27 + 292)) < (6786 - 4470))) then
							local v240 = 0 - 0;
							while true do
								if ((v240 == (0 - 0)) or ((5229 - 2577) <= (2919 - 1386))) then
									v28 = v126();
									if (v28 or ((3737 - (43 + 96)) < (5955 - 4495))) then
										return v28;
									end
									break;
								end
							end
						end
						if ((v118 < (6 - 3)) or ((3416 + 700) < (337 + 855))) then
							local v241 = 0 - 0;
							while true do
								if ((v241 == (0 + 0)) or ((6328 - 2951) <= (285 + 618))) then
									v28 = v127();
									if (((292 + 3684) >= (2190 - (1414 + 337))) and v28) then
										return v28;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v137()
		v122();
		v113.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(2210 - (1642 + 298), v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

