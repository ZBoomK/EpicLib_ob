local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((9032 - 5870) == (822 + 2340)) and not v5) then
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
	local v111 = 19540 - 8429;
	local v112 = 23042 - 11931;
	local v113;
	local v114 = v17.Monk.Mistweaver;
	local v115 = v19.Monk.Mistweaver;
	local v116 = v24.Monk.Mistweaver;
	local v117 = {};
	local v118;
	local v119;
	local v120 = v21.Commons.Everyone;
	local v121 = v21.Commons.Monk;
	local function v122()
		if (v114.ImprovedDetox:IsAvailable() or ((4181 - (1293 + 519)) > (9036 - 4607))) then
			v120.DispellableDebuffs = v20.MergeTable(v120.DispellableMagicDebuffs, v120.DispellablePoisonDebuffs, v120.DispellableDiseaseDebuffs);
		else
			v120.DispellableDebuffs = v120.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v122();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v123()
		if (((10691 - 6596) >= (6086 - 2903)) and v114.DampenHarm:IsCastable() and v12:BuffDown(v114.FortifyingBrew) and (v12:HealthPercentage() <= v42) and v41) then
			if (v23(v114.DampenHarm, nil) or ((16002 - 12291) < (2374 - 1366))) then
				return "dampen_harm defensives 1";
			end
		end
		if ((v114.FortifyingBrew:IsCastable() and v12:BuffDown(v114.DampenHarmBuff) and (v12:HealthPercentage() <= v40) and v39) or ((556 + 493) <= (185 + 721))) then
			if (((10485 - 5972) > (630 + 2096)) and v23(v114.FortifyingBrew, nil)) then
				return "fortifying_brew defensives 2";
			end
		end
		if ((v114.ExpelHarm:IsCastable() and (v12:HealthPercentage() <= v55) and v54 and v12:BuffUp(v114.ChiHarmonyBuff)) or ((492 + 989) >= (1662 + 996))) then
			if (v23(v114.ExpelHarm, nil) or ((4316 - (709 + 387)) == (3222 - (673 + 1185)))) then
				return "expel_harm defensives 3";
			end
		end
		if ((v115.Healthstone:IsReady() and v115.Healthstone:IsUsable() and v84 and (v12:HealthPercentage() <= v85)) or ((3056 - 2002) > (10891 - 7499))) then
			if (v23(v116.Healthstone) or ((1111 - 435) >= (1175 + 467))) then
				return "healthstone defensive 4";
			end
		end
		if (((3091 + 1045) > (3236 - 839)) and v86 and (v12:HealthPercentage() <= v87)) then
			local v191 = 0 + 0;
			while true do
				if ((v191 == (1 - 0)) or ((8507 - 4173) == (6125 - (446 + 1434)))) then
					if ((v88 == "Potion of Withering Dreams") or ((5559 - (1040 + 243)) <= (9046 - 6015))) then
						if (v115.PotionOfWitheringDreams:IsReady() or ((6629 - (559 + 1288)) <= (3130 - (609 + 1322)))) then
							if (v23(v116.RefreshingHealingPotion) or ((5318 - (13 + 441)) < (7107 - 5205))) then
								return "potion of withering dreams defensive";
							end
						end
					end
					break;
				end
				if (((12674 - 7835) >= (18427 - 14727)) and (v191 == (0 + 0))) then
					if ((v88 == "Refreshing Healing Potion") or ((3904 - 2829) > (682 + 1236))) then
						if (((174 + 222) <= (11288 - 7484)) and v115.RefreshingHealingPotion:IsReady() and v115.RefreshingHealingPotion:IsUsable()) then
							if (v23(v116.RefreshingHealingPotion) or ((2282 + 1887) == (4022 - 1835))) then
								return "refreshing healing potion defensive 5";
							end
						end
					end
					if (((930 + 476) == (782 + 624)) and (v88 == "Dreamwalker's Healing Potion")) then
						if (((1101 + 430) < (3587 + 684)) and v115.DreamwalkersHealingPotion:IsReady() and v115.DreamwalkersHealingPotion:IsUsable()) then
							if (((622 + 13) == (1068 - (153 + 280))) and v23(v116.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive 5";
							end
						end
					end
					v191 = 2 - 1;
				end
			end
		end
	end
	local function v124()
		local v138 = 0 + 0;
		while true do
			if (((1332 + 2041) <= (1861 + 1695)) and (v138 == (0 + 0))) then
				if (v102 or ((2385 + 906) < (4994 - 1714))) then
					v28 = v120.HandleIncorporeal(v114.Paralysis, v116.ParalysisMouseover, 19 + 11, true);
					if (((5053 - (89 + 578)) >= (624 + 249)) and v28) then
						return v28;
					end
				end
				if (((1914 - 993) <= (2151 - (572 + 477))) and v101) then
					v28 = v120.HandleAfflicted(v114.Detox, v116.DetoxMouseover, 5 + 25);
					if (((2825 + 1881) >= (115 + 848)) and v28) then
						return v28;
					end
					if (v114.Detox:CooldownRemains() or ((1046 - (84 + 2)) <= (1443 - 567))) then
						v28 = v120.HandleAfflicted(v114.Vivify, v116.VivifyMouseover, 22 + 8);
						if (v28 or ((2908 - (497 + 345)) == (24 + 908))) then
							return v28;
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((6158 - (605 + 728)) < (3456 + 1387)) and (v138 == (1 - 0))) then
				if (v103 or ((178 + 3699) >= (16774 - 12237))) then
					v28 = v120.HandleChromie(v114.Riptide, v116.RiptideMouseover, 37 + 3);
					if (v28 or ((11954 - 7639) < (1304 + 422))) then
						return v28;
					end
					v28 = v120.HandleChromie(v114.HealingSurge, v116.HealingSurgeMouseover, 529 - (457 + 32));
					if (v28 or ((1561 + 2118) < (2027 - (832 + 570)))) then
						return v28;
					end
				end
				if (v104 or ((4358 + 267) < (165 + 467))) then
					v28 = v120.HandleCharredTreant(v114.RenewingMist, v116.RenewingMistMouseover, 141 - 101);
					if (v28 or ((40 + 43) > (2576 - (588 + 208)))) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v114.SoothingMist, v116.SoothingMistMouseover, 107 - 67);
					if (((2346 - (884 + 916)) <= (2254 - 1177)) and v28) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v114.Vivify, v116.VivifyMouseover, 24 + 16);
					if (v28 or ((1649 - (232 + 421)) > (6190 - (1569 + 320)))) then
						return v28;
					end
					v28 = v120.HandleCharredTreant(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 10 + 30);
					if (((774 + 3296) > (2314 - 1627)) and v28) then
						return v28;
					end
				end
				v138 = 607 - (316 + 289);
			end
			if ((v138 == (5 - 3)) or ((31 + 625) >= (4783 - (666 + 787)))) then
				if (v105 or ((2917 - (360 + 65)) <= (314 + 21))) then
					v28 = v120.HandleCharredBrambles(v114.RenewingMist, v116.RenewingMistMouseover, 294 - (79 + 175));
					if (((6814 - 2492) >= (2000 + 562)) and v28) then
						return v28;
					end
					v28 = v120.HandleCharredBrambles(v114.SoothingMist, v116.SoothingMistMouseover, 122 - 82);
					if (v28 or ((7003 - 3366) >= (4669 - (503 + 396)))) then
						return v28;
					end
					v28 = v120.HandleCharredBrambles(v114.Vivify, v116.VivifyMouseover, 221 - (92 + 89));
					if (v28 or ((4614 - 2235) > (2348 + 2230))) then
						return v28;
					end
					v28 = v120.HandleCharredBrambles(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 24 + 16);
					if (v28 or ((1891 - 1408) > (102 + 641))) then
						return v28;
					end
				end
				if (((5594 - 3140) > (505 + 73)) and v106) then
					v28 = v120.HandleFyrakkNPC(v114.RenewingMist, v116.RenewingMistMouseover, 20 + 20);
					if (((2832 - 1902) < (557 + 3901)) and v28) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v114.SoothingMist, v116.SoothingMistMouseover, 61 - 21);
					if (((1906 - (485 + 759)) <= (2248 - 1276)) and v28) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v114.Vivify, v116.VivifyMouseover, 1229 - (442 + 747));
					if (((5505 - (832 + 303)) == (5316 - (88 + 858))) and v28) then
						return v28;
					end
					v28 = v120.HandleFyrakkNPC(v114.EnvelopingMist, v116.EnvelopingMistMouseover, 13 + 27);
					if (v28 or ((3942 + 820) <= (36 + 825))) then
						return v28;
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v139 = 789 - (766 + 23);
		while true do
			if ((v139 == (4 - 3)) or ((1930 - 518) == (11234 - 6970))) then
				if ((v114.TigerPalm:IsCastable() and v48) or ((10752 - 7584) < (3226 - (1036 + 37)))) then
					if (v23(v114.TigerPalm, not v14:IsInMeleeRange(4 + 1)) or ((9690 - 4714) < (1048 + 284))) then
						return "tiger_palm precombat 8";
					end
				end
				break;
			end
			if (((6108 - (641 + 839)) == (5541 - (910 + 3))) and (v139 == (0 - 0))) then
				if ((v114.ChiBurst:IsCastable() and v50) or ((1738 - (1466 + 218)) == (182 + 213))) then
					if (((1230 - (556 + 592)) == (30 + 52)) and v23(v114.ChiBurst, not v14:IsInRange(848 - (329 + 479)))) then
						return "chi_burst precombat 4";
					end
				end
				if ((v114.SpinningCraneKick:IsCastable() and v46 and (v119 >= (856 - (174 + 680)))) or ((1996 - 1415) < (584 - 302))) then
					if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(6 + 2)) or ((5348 - (396 + 343)) < (221 + 2274))) then
						return "spinning_crane_kick precombat 6";
					end
				end
				v139 = 1478 - (29 + 1448);
			end
		end
	end
	local function v126()
		if (((2541 - (135 + 1254)) == (4339 - 3187)) and v114.SummonWhiteTigerStatue:IsReady() and (v119 >= (13 - 10)) and v44) then
			if (((1264 + 632) <= (4949 - (389 + 1138))) and (v43 == "Player")) then
				if (v23(v116.SummonWhiteTigerStatuePlayer, not v14:IsInRange(614 - (102 + 472))) or ((935 + 55) > (899 + 721))) then
					return "summon_white_tiger_statue aoe player 1";
				end
			elseif ((v43 == "Cursor") or ((818 + 59) > (6240 - (320 + 1225)))) then
				if (((4790 - 2099) >= (1133 + 718)) and v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(1504 - (157 + 1307)))) then
					return "summon_white_tiger_statue aoe cursor 1";
				end
			elseif (((v43 == "Friendly under Cursor") and v15:Exists() and not v12:CanAttack(v15)) or ((4844 - (821 + 1038)) >= (12115 - 7259))) then
				if (((468 + 3808) >= (2122 - 927)) and v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(15 + 25))) then
					return "summon_white_tiger_statue aoe cursor friendly 1";
				end
			elseif (((8010 - 4778) <= (5716 - (834 + 192))) and (v43 == "Enemy under Cursor") and v15:Exists() and v12:CanAttack(v15)) then
				if (v23(v116.SummonWhiteTigerStatueCursor, not v14:IsInRange(3 + 37)) or ((230 + 666) >= (68 + 3078))) then
					return "summon_white_tiger_statue aoe cursor enemy 1";
				end
			elseif (((4741 - 1680) >= (3262 - (300 + 4))) and (v43 == "Confirmation")) then
				if (((852 + 2335) >= (1685 - 1041)) and v23(v116.SummonWhiteTigerStatue, not v14:IsInRange(402 - (112 + 250)))) then
					return "summon_white_tiger_statue aoe confirmation 1";
				end
			end
		end
		if (((257 + 387) <= (1763 - 1059)) and v114.TouchofDeath:IsCastable() and v51) then
			if (((549 + 409) > (490 + 457)) and v23(v114.TouchofDeath, not v14:IsInMeleeRange(4 + 1))) then
				return "touch_of_death aoe 2";
			end
		end
		if (((2228 + 2264) >= (1972 + 682)) and v114.JadefireStomp:IsReady() and v49) then
			if (((4856 - (1001 + 413)) >= (3351 - 1848)) and v23(v114.JadefireStomp, not v14:IsInMeleeRange(890 - (244 + 638)))) then
				return "JadefireStomp aoe3";
			end
		end
		if ((v114.ChiBurst:IsCastable() and v50) or ((3863 - (627 + 66)) <= (4361 - 2897))) then
			if (v23(v114.ChiBurst, not v14:IsInRange(642 - (512 + 90))) or ((6703 - (1665 + 241)) == (5105 - (373 + 344)))) then
				return "chi_burst aoe 4";
			end
		end
		if (((249 + 302) <= (181 + 500)) and v114.SpinningCraneKick:IsCastable() and v46 and (v14:DebuffDown(v114.MysticTouchDebuff) or (v120.EnemiesWithDebuffCount(v114.MysticTouchDebuff) <= (v119 - (2 - 1)))) and v114.MysticTouch:IsAvailable()) then
			if (((5545 - 2268) > (1506 - (35 + 1064))) and v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(6 + 2))) then
				return "spinning_crane_kick aoe 5";
			end
		end
		if (((10045 - 5350) >= (6 + 1409)) and v114.BlackoutKick:IsCastable() and v114.AncientConcordance:IsAvailable() and v12:BuffUp(v114.JadefireStomp) and v45 and (v119 >= (1239 - (298 + 938)))) then
			if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(1264 - (233 + 1026))) or ((4878 - (636 + 1030)) <= (483 + 461))) then
				return "blackout_kick aoe 6";
			end
		end
		if ((v114.BlackoutKick:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (2 + 0)) and v45) or ((920 + 2176) <= (122 + 1676))) then
			if (((3758 - (55 + 166)) == (686 + 2851)) and v23(v114.BlackoutKick, not v14:IsInMeleeRange(1 + 4))) then
				return "blackout_kick aoe 8";
			end
		end
		if (((14653 - 10816) >= (1867 - (36 + 261))) and v114.TigerPalm:IsCastable() and v114.TeachingsoftheMonastery:IsAvailable() and (v114.BlackoutKick:CooldownRemains() > (0 - 0)) and v48 and (v119 >= (1371 - (34 + 1334)))) then
			if (v23(v114.TigerPalm, not v14:IsInMeleeRange(2 + 3)) or ((2293 + 657) == (5095 - (1035 + 248)))) then
				return "tiger_palm aoe 7";
			end
		end
		if (((4744 - (20 + 1)) >= (1208 + 1110)) and v114.SpinningCraneKick:IsCastable() and v46) then
			if (v23(v114.SpinningCraneKick, not v14:IsInMeleeRange(327 - (134 + 185))) or ((3160 - (549 + 584)) > (3537 - (314 + 371)))) then
				return "spinning_crane_kick aoe 8";
			end
		end
	end
	local function v127()
		if ((v114.TouchofDeath:IsCastable() and v51) or ((3899 - 2763) > (5285 - (478 + 490)))) then
			if (((2516 + 2232) == (5920 - (786 + 386))) and v23(v114.TouchofDeath, not v14:IsInMeleeRange(16 - 11))) then
				return "touch_of_death st 1";
			end
		end
		if (((5115 - (1055 + 324)) <= (6080 - (1093 + 247))) and v114.JadefireStomp:IsReady() and v49) then
			if (v23(v114.JadefireStomp, nil) or ((3013 + 377) <= (322 + 2738))) then
				return "JadefireStomp st 2";
			end
		end
		if ((v114.RisingSunKick:IsReady() and v47) or ((3966 - 2967) > (9139 - 6446))) then
			if (((1317 - 854) < (1510 - 909)) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(2 + 3))) then
				return "rising_sun_kick st 3";
			end
		end
		if ((v114.ChiBurst:IsCastable() and v50) or ((8409 - 6226) < (2367 - 1680))) then
			if (((3431 + 1118) == (11633 - 7084)) and v23(v114.ChiBurst, not v14:IsInRange(728 - (364 + 324)))) then
				return "chi_burst st 4";
			end
		end
		if (((12807 - 8135) == (11210 - 6538)) and v114.BlackoutKick:IsCastable() and (v12:BuffStack(v114.TeachingsoftheMonasteryBuff) >= (1 + 2)) and (v114.RisingSunKick:CooldownRemains() > v12:GCD()) and v45) then
			if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(20 - 15)) or ((5874 - 2206) < (1199 - 804))) then
				return "blackout_kick st 5";
			end
		end
		if ((v114.TigerPalm:IsCastable() and ((v12:BuffStack(v114.TeachingsoftheMonasteryBuff) < (1271 - (1249 + 19))) or (v12:BuffRemains(v114.TeachingsoftheMonasteryBuff) < (2 + 0))) and v114.TeachingsoftheMonastery:IsAvailable() and v48) or ((16216 - 12050) == (1541 - (686 + 400)))) then
			if (v23(v114.TigerPalm, not v14:IsInMeleeRange(4 + 1)) or ((4678 - (73 + 156)) == (13 + 2650))) then
				return "tiger_palm st 6";
			end
		end
		if ((v114.BlackoutKick:IsCastable() and not v114.TeachingsoftheMonastery:IsAvailable() and v45) or ((5088 - (721 + 90)) < (34 + 2955))) then
			if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(16 - 11)) or ((1340 - (224 + 246)) >= (6720 - 2571))) then
				return "blackout_kick st 7";
			end
		end
		if (((4072 - 1860) < (578 + 2605)) and v114.TigerPalm:IsCastable() and v48) then
			if (((111 + 4535) > (2198 + 794)) and v23(v114.TigerPalm, not v14:IsInMeleeRange(9 - 4))) then
				return "tiger_palm st 8";
			end
		end
	end
	local function v128()
		local v140 = 0 - 0;
		while true do
			if (((1947 - (203 + 310)) < (5099 - (1238 + 755))) and (v140 == (1 + 0))) then
				if (((2320 - (709 + 825)) < (5569 - 2546)) and v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff)) then
					if ((v16:HealthPercentage() <= v53) or ((3556 - 1114) < (938 - (196 + 668)))) then
						if (((17905 - 13370) == (9393 - 4858)) and v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if ((v56 and v114.Vivify:IsReady() and v12:BuffUp(v114.VivaciousVivificationBuff)) or ((3842 - (171 + 662)) <= (2198 - (4 + 89)))) then
					if (((6414 - 4584) < (1336 + 2333)) and (v16:HealthPercentage() <= v57)) then
						if (v23(v116.VivifyFocus, not v16:IsSpellInRange(v114.Vivify)) or ((6280 - 4850) >= (1417 + 2195))) then
							return "Vivify instant healing st";
						end
					end
				end
				v140 = 1488 - (35 + 1451);
			end
			if (((4136 - (28 + 1425)) >= (4453 - (941 + 1052))) and (v140 == (0 + 0))) then
				if ((v52 and v114.RenewingMist:IsReady() and v16:BuffDown(v114.RenewingMistBuff) and (v114.RenewingMist:ChargesFractional() >= (1515.8 - (822 + 692)))) or ((2575 - 771) >= (1543 + 1732))) then
					if ((v16:HealthPercentage() <= v53) or ((1714 - (45 + 252)) > (3591 + 38))) then
						if (((1651 + 3144) > (977 - 575)) and v23(v116.RenewingMistFocus, not v16:IsSpellInRange(v114.RenewingMist))) then
							return "RenewingMist healing st";
						end
					end
				end
				if (((5246 - (114 + 319)) > (5118 - 1553)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 32 - 7) > (1 + 0))) then
					if (((5827 - 1915) == (8196 - 4284)) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(1968 - (556 + 1407)))) then
						return "RisingSunKick healing st";
					end
				end
				v140 = 1207 - (741 + 465);
			end
			if (((3286 - (170 + 295)) <= (2542 + 2282)) and (v140 == (2 + 0))) then
				if (((4278 - 2540) <= (1820 + 375)) and v60 and v114.SoothingMist:IsReady() and v16:BuffDown(v114.SoothingMist)) then
					if (((27 + 14) <= (1710 + 1308)) and (v16:HealthPercentage() <= v61)) then
						if (((3375 - (957 + 273)) <= (1098 + 3006)) and v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist))) then
							return "SoothingMist healing st";
						end
					end
				end
				break;
			end
		end
	end
	local function v129()
		if (((1077 + 1612) < (18461 - 13616)) and v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.RenewingMistBuff, false, false, 65 - 40) > (2 - 1))) then
			if (v23(v114.RisingSunKick, not v14:IsInMeleeRange(24 - 19)) or ((4102 - (389 + 1391)) > (1646 + 976))) then
				return "RisingSunKick healing aoe";
			end
		end
		if (v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist) or ((472 + 4062) == (4739 - 2657))) then
			local v192 = 951 - (783 + 168);
			while true do
				if ((v192 == (3 - 2)) or ((1546 + 25) > (2178 - (309 + 2)))) then
					if ((v62 and v114.EssenceFont:IsReady() and (v12:BuffUp(v114.ThunderFocusTea) or (v114.ThunderFocusTea:CooldownRemains() > (24 - 16)))) or ((3866 - (1090 + 122)) >= (972 + 2024))) then
						if (((13359 - 9381) > (1440 + 664)) and v23(v114.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					if (((4113 - (628 + 490)) > (277 + 1264)) and v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.EssenceFontBuff)) then
						if (((8043 - 4794) > (4355 - 3402)) and v23(v114.EssenceFont, nil)) then
							return "EssenceFont healing aoe";
						end
					end
					break;
				end
				if ((v192 == (774 - (431 + 343))) or ((6610 - 3337) > (13229 - 8656))) then
					if ((v36 and (v12:BuffStack(v114.ManaTeaCharges) > v37) and v114.EssenceFont:IsReady() and v114.ManaTea:IsCastable() and not v120.AreUnitsBelowHealthPercentage(64 + 16, 1 + 2, v114.EnvelopingMist)) or ((4846 - (556 + 1139)) < (1299 - (6 + 9)))) then
						if (v23(v114.ManaTea, nil) or ((339 + 1511) == (784 + 745))) then
							return "EssenceFont healing aoe";
						end
					end
					if (((990 - (28 + 141)) < (823 + 1300)) and v38 and v114.ThunderFocusTea:IsReady() and (v114.EssenceFont:CooldownRemains() < v12:GCD())) then
						if (((1112 - 210) < (1647 + 678)) and v23(v114.ThunderFocusTea, nil)) then
							return "ThunderFocusTea healing aoe";
						end
					end
					v192 = 1318 - (486 + 831);
				end
			end
		end
		if (((2232 - 1374) <= (10427 - 7465)) and v67 and v114.ZenPulse:IsReady() and v120.AreUnitsBelowHealthPercentage(v69, v68, v114.EnvelopingMist)) then
			if (v23(v116.ZenPulseFocus, not v16:IsSpellInRange(v114.ZenPulse)) or ((746 + 3200) < (4072 - 2784))) then
				return "ZenPulse healing aoe";
			end
		end
		if ((v70 and v114.SheilunsGift:IsReady() and v114.SheilunsGift:IsCastable() and v120.AreUnitsBelowHealthPercentage(v72, v71, v114.EnvelopingMist)) or ((4505 - (668 + 595)) == (511 + 56))) then
			if (v23(v114.SheilunsGift, nil) or ((171 + 676) >= (3444 - 2181))) then
				return "SheilunsGift healing aoe";
			end
		end
	end
	local function v130()
		if ((v58 and v114.EnvelopingMist:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 315 - (23 + 267)) < (1947 - (1129 + 815)))) or ((2640 - (371 + 16)) == (3601 - (1326 + 424)))) then
			local v193 = 0 - 0;
			while true do
				if ((v193 == (3 - 2)) or ((2205 - (88 + 30)) > (3143 - (720 + 51)))) then
					if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((9887 - 5442) < (5925 - (421 + 1355)))) then
						return "Enveloping Mist YuLon";
					end
					break;
				end
				if (((0 - 0) == v193) or ((894 + 924) == (1168 - (286 + 797)))) then
					v28 = v120.FocusUnitRefreshableBuff(v114.EnvelopingMist, 7 - 5, 66 - 26, nil, false, 464 - (397 + 42), v114.EnvelopingMist);
					if (((197 + 433) < (2927 - (24 + 776))) and v28) then
						return v28;
					end
					v193 = 1 - 0;
				end
			end
		end
		if ((v47 and v114.RisingSunKick:IsReady() and (v120.FriendlyUnitsWithBuffCount(v114.EnvelopingMist, false, false, 810 - (222 + 563)) > (3 - 1))) or ((1396 + 542) == (2704 - (23 + 167)))) then
			if (((6053 - (690 + 1108)) >= (20 + 35)) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(5 + 0))) then
				return "Rising Sun Kick YuLon";
			end
		end
		if (((3847 - (40 + 808)) > (191 + 965)) and v60 and v114.SoothingMist:IsReady() and v16:BuffUp(v114.ChiHarmonyBuff) and v16:BuffDown(v114.SoothingMist)) then
			if (((8986 - 6636) > (1104 + 51)) and v23(v116.SoothingMistFocus, not v16:IsSpellInRange(v114.SoothingMist))) then
				return "Soothing Mist YuLon";
			end
		end
	end
	local function v131()
		local v141 = 0 + 0;
		while true do
			if (((2210 + 1819) <= (5424 - (47 + 524))) and (v141 == (1 + 0))) then
				if ((v47 and v114.RisingSunKick:IsReady()) or ((1410 - 894) > (5134 - 1700))) then
					if (((9227 - 5181) >= (4759 - (1165 + 561))) and v23(v114.RisingSunKick, not v14:IsInMeleeRange(1 + 4))) then
						return "Rising Sun Kick ChiJi";
					end
				end
				if ((v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) >= (6 - 4))) or ((1038 + 1681) <= (1926 - (341 + 138)))) then
					if ((v16:HealthPercentage() <= v59) or ((1116 + 3018) < (8102 - 4176))) then
						if (v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist)) or ((490 - (89 + 237)) >= (8959 - 6174))) then
							return "Enveloping Mist 2 Stacks ChiJi";
						end
					end
				end
				v141 = 3 - 1;
			end
			if (((883 - (581 + 300)) == v141) or ((1745 - (855 + 365)) == (5009 - 2900))) then
				if (((11 + 22) == (1268 - (1030 + 205))) and v62 and v114.EssenceFont:IsReady() and v114.AncientTeachings:IsAvailable() and v12:BuffDown(v114.AncientTeachings)) then
					if (((2868 + 186) <= (3736 + 279)) and v23(v114.EssenceFont, nil)) then
						return "Essence Font ChiJi";
					end
				end
				break;
			end
			if (((2157 - (156 + 130)) < (7684 - 4302)) and (v141 == (0 - 0))) then
				if (((2648 - 1355) <= (571 + 1595)) and v45 and v114.BlackoutKick:IsReady() and (v12:BuffStack(v114.TeachingsoftheMonastery) >= (2 + 1))) then
					if (v23(v114.BlackoutKick, not v14:IsInMeleeRange(74 - (10 + 59))) or ((730 + 1849) < (605 - 482))) then
						return "Blackout Kick ChiJi";
					end
				end
				if ((v58 and v114.EnvelopingMist:IsReady() and (v12:BuffStack(v114.InvokeChiJiBuff) == (1166 - (671 + 492)))) or ((674 + 172) >= (3583 - (369 + 846)))) then
					if ((v16:HealthPercentage() <= v59) or ((1063 + 2949) <= (2866 + 492))) then
						if (((3439 - (1036 + 909)) <= (2390 + 615)) and v23(v116.EnvelopingMistFocus, not v16:IsSpellInRange(v114.EnvelopingMist))) then
							return "Enveloping Mist 3 Stacks ChiJi";
						end
					end
				end
				v141 = 1 - 0;
			end
		end
	end
	local function v132()
		if ((v79 and v114.LifeCocoon:IsReady() and (v16:HealthPercentage() <= v80)) or ((3314 - (11 + 192)) == (1079 + 1055))) then
			if (((2530 - (135 + 40)) == (5705 - 3350)) and v23(v116.LifeCocoonFocus, not v16:IsSpellInRange(v114.LifeCocoon))) then
				return "Life Cocoon CD";
			end
		end
		if ((v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) or ((355 + 233) <= (951 - 519))) then
			if (((7190 - 2393) >= (4071 - (50 + 126))) and v23(v114.Revival, nil)) then
				return "Revival CD";
			end
		end
		if (((9960 - 6383) == (792 + 2785)) and v81 and v114.Restoral:IsReady() and v114.Restoral:IsAvailable() and v120.AreUnitsBelowHealthPercentage(v83, v82, v114.EnvelopingMist)) then
			if (((5207 - (1233 + 180)) > (4662 - (522 + 447))) and v23(v114.Restoral, nil)) then
				return "Restoral CD";
			end
		end
		if ((v73 and v114.InvokeYulonTheJadeSerpent:IsAvailable() and v114.InvokeYulonTheJadeSerpent:IsReady() and (v120.AreUnitsBelowHealthPercentage(v75, v74, v114.EnvelopingMist) or v35)) or ((2696 - (107 + 1314)) == (1903 + 2197))) then
			if ((v114.InvokeYulonTheJadeSerpent:IsReady() and (v114.RenewingMist:ChargesFractional() < (2 - 1))) or ((676 + 915) >= (7109 - 3529))) then
				if (((3889 - 2906) <= (3718 - (716 + 1194))) and v23(v114.InvokeYulonTheJadeSerpent, nil)) then
					return "Invoke Yu'lon GO";
				end
			end
		end
		if ((v114.InvokeYulonTheJadeSerpent:TimeSinceLastCast() <= (1 + 24)) or ((231 + 1919) <= (1700 - (74 + 429)))) then
			v28 = v130();
			if (((7270 - 3501) >= (582 + 591)) and v28) then
				return v28;
			end
		end
		if (((3399 - 1914) == (1051 + 434)) and v76 and v114.InvokeChiJiTheRedCrane:IsReady() and v114.InvokeChiJiTheRedCrane:IsAvailable() and (v120.AreUnitsBelowHealthPercentage(v78, v77, v114.EnvelopingMist) or v35)) then
			if ((v114.InvokeChiJiTheRedCrane:IsReady() and (v114.RenewingMist:ChargesFractional() < (2 - 1))) or ((8196 - 4881) <= (3215 - (279 + 154)))) then
				if (v23(v114.InvokeChiJiTheRedCrane, nil) or ((1654 - (454 + 324)) >= (2332 + 632))) then
					return "Invoke Chi'ji GO";
				end
			end
		end
		if ((v114.InvokeChiJiTheRedCrane:TimeSinceLastCast() <= (42 - (12 + 5))) or ((1204 + 1028) > (6362 - 3865))) then
			local v194 = 0 + 0;
			while true do
				if ((v194 == (1093 - (277 + 816))) or ((9016 - 6906) <= (1515 - (1058 + 125)))) then
					v28 = v131();
					if (((692 + 2994) > (4147 - (815 + 160))) and v28) then
						return v28;
					end
					break;
				end
			end
		end
	end
	local function v133()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (4 - 2)) or ((1068 + 3406) < (2396 - 1576))) then
				v48 = EpicSettings.Settings['UseTigerPalm'];
				v49 = EpicSettings.Settings['UseJadefireStomp'];
				v50 = EpicSettings.Settings['UseChiBurst'];
				v51 = EpicSettings.Settings['UseTouchOfDeath'];
				v52 = EpicSettings.Settings['UseRenewingMist'];
				v53 = EpicSettings.Settings['RenewingMistHP'];
				v142 = 1901 - (41 + 1857);
			end
			if (((6172 - (1222 + 671)) >= (7448 - 4566)) and (v142 == (5 - 1))) then
				v60 = EpicSettings.Settings['UseSoothingMist'];
				v61 = EpicSettings.Settings['SoothingMistHP'];
				v62 = EpicSettings.Settings['UseEssenceFont'];
				v64 = EpicSettings.Settings['EssenceFontHP'];
				v63 = EpicSettings.Settings['EssenceFontGroup'];
				v66 = EpicSettings.Settings['UseJadeSerpent'];
				v142 = 1187 - (229 + 953);
			end
			if ((v142 == (1777 - (1111 + 663))) or ((3608 - (874 + 705)) >= (493 + 3028))) then
				v54 = EpicSettings.Settings['UseExpelHarm'];
				v55 = EpicSettings.Settings['ExpelHarmHP'];
				v56 = EpicSettings.Settings['UseVivify'];
				v57 = EpicSettings.Settings['VivifyHP'];
				v58 = EpicSettings.Settings['UseEnvelopingMist'];
				v59 = EpicSettings.Settings['EnvelopingMistHP'];
				v142 = 3 + 1;
			end
			if ((v142 == (12 - 6)) or ((58 + 1979) >= (5321 - (642 + 37)))) then
				v71 = EpicSettings.Settings['SheilunsGiftGroup'];
				break;
			end
			if (((393 + 1327) < (714 + 3744)) and (v142 == (12 - 7))) then
				v65 = EpicSettings.Settings['JadeSerpentUsage'];
				v67 = EpicSettings.Settings['UseZenPulse'];
				v69 = EpicSettings.Settings['ZenPulseHP'];
				v68 = EpicSettings.Settings['ZenPulseGroup'];
				v70 = EpicSettings.Settings['UseSheilunsGift'];
				v72 = EpicSettings.Settings['SheilunsGiftHP'];
				v142 = 460 - (233 + 221);
			end
			if ((v142 == (0 - 0)) or ((384 + 52) > (4562 - (718 + 823)))) then
				v36 = EpicSettings.Settings['UseManaTea'];
				v37 = EpicSettings.Settings['ManaTeaStacks'];
				v38 = EpicSettings.Settings['UseThunderFocusTea'];
				v39 = EpicSettings.Settings['UseFortifyingBrew'];
				v40 = EpicSettings.Settings['FortifyingBrewHP'];
				v41 = EpicSettings.Settings['UseDampenHarm'];
				v142 = 1 + 0;
			end
			if (((1518 - (266 + 539)) <= (2398 - 1551)) and (v142 == (1226 - (636 + 589)))) then
				v42 = EpicSettings.Settings['DampenHarmHP'];
				v43 = EpicSettings.Settings['WhiteTigerUsage'];
				v44 = EpicSettings.Settings['UseSummonWhiteTigerStatue'];
				v45 = EpicSettings.Settings['UseBlackoutKick'];
				v46 = EpicSettings.Settings['UseSpinningCraneKick'];
				v47 = EpicSettings.Settings['UseRisingSunKick'];
				v142 = 4 - 2;
			end
		end
	end
	local function v134()
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
	local v135 = 0 - 0;
	local function v136()
		v133();
		v134();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['dispel'];
		v33 = EpicSettings.Toggles['healing'];
		v34 = EpicSettings.Toggles['dps'];
		v35 = EpicSettings.Toggles['ramp'];
		if (((1707 + 447) <= (1465 + 2566)) and v12:IsDeadOrGhost()) then
			return;
		end
		v118 = v12:GetEnemiesInMeleeRange(1023 - (657 + 358));
		if (((12219 - 7604) == (10514 - 5899)) and v30) then
			v119 = #v118;
		else
			v119 = 1188 - (1151 + 36);
		end
		if (v120.TargetIsValid() or v12:AffectingCombat() or ((3660 + 130) == (132 + 368))) then
			v113 = v12:GetEnemiesInRange(119 - 79);
			v111 = v9.BossFightRemains(nil, true);
			v112 = v111;
			if (((1921 - (1552 + 280)) < (1055 - (64 + 770))) and (v112 == (7544 + 3567))) then
				v112 = v9.FightRemains(v113, false);
			end
		end
		v28 = v124();
		if (((4662 - 2608) >= (253 + 1168)) and v28) then
			return v28;
		end
		if (((1935 - (157 + 1086)) < (6120 - 3062)) and (v12:AffectingCombat() or v29)) then
			local v195 = v89 and v114.Detox:IsReady() and v32;
			v28 = v120.FocusUnit(v195, nil, 175 - 135, nil, 37 - 12, v114.EnvelopingMist);
			if (v28 or ((4441 - 1187) == (2474 - (599 + 220)))) then
				return v28;
			end
			if ((v32 and v89) or ((2580 - 1284) == (6841 - (1813 + 118)))) then
				local v236 = 0 + 0;
				while true do
					if (((4585 - (841 + 376)) == (4719 - 1351)) and (v236 == (0 + 0))) then
						if (((7214 - 4571) < (4674 - (464 + 395))) and v16 and v16:Exists() and v16:IsAPlayer() and (v120.UnitHasDispellableDebuffByPlayer(v16) or v120.DispellableFriendlyUnit(64 - 39) or v120.UnitHasMagicDebuff(v16) or (v114.ImprovedDetox:IsAvailable() and (v120.UnitHasDiseaseDebuff(v16) or v120.UnitHasPoisonDebuff(v16))))) then
							if (((919 + 994) > (1330 - (467 + 370))) and v114.Detox:IsCastable()) then
								local v244 = 0 - 0;
								while true do
									if (((3491 + 1264) > (11751 - 8323)) and (v244 == (0 + 0))) then
										if (((3212 - 1831) <= (2889 - (150 + 370))) and (v135 == (1282 - (74 + 1208)))) then
											v135 = GetTime();
										end
										if (v120.Wait(1229 - 729, v135) or ((22968 - 18125) == (2906 + 1178))) then
											local v245 = 390 - (14 + 376);
											while true do
												if (((8097 - 3428) > (235 + 128)) and (v245 == (0 + 0))) then
													if (v23(v116.DetoxFocus, not v16:IsSpellInRange(v114.Detox)) or ((1791 + 86) >= (9194 - 6056))) then
														return "detox dispel focus";
													end
													v135 = 0 + 0;
													break;
												end
											end
										end
										break;
									end
								end
							end
						end
						if (((4820 - (23 + 55)) >= (8593 - 4967)) and v15 and v15:Exists() and not v12:CanAttack(v15) and (v120.UnitHasDispellableDebuffByPlayer(v15) or v120.UnitHasMagicDebuff(v15) or (v114.ImprovedDetox:IsAvailable() and (v120.UnitHasDiseaseDebuff(v15) or v120.UnitHasPoisonDebuff(v15))))) then
							if (v114.Detox:IsCastable() or ((3030 + 1510) == (823 + 93))) then
								if (v23(v116.DetoxMouseover, not v15:IsSpellInRange(v114.Detox)) or ((1792 - 636) > (1367 + 2978))) then
									return "detox dispel mouseover";
								end
							end
						end
						break;
					end
				end
			end
		end
		if (((3138 - (652 + 249)) < (11370 - 7121)) and not v12:AffectingCombat()) then
			if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) or ((4551 - (708 + 1160)) < (62 - 39))) then
				local v237 = 0 - 0;
				local v238;
				while true do
					if (((724 - (10 + 17)) <= (186 + 640)) and (v237 == (1732 - (1400 + 332)))) then
						v238 = v120.DeadFriendlyUnitsCount();
						if (((2119 - 1014) <= (3084 - (242 + 1666))) and (v238 > (1 + 0))) then
							if (((1239 + 2140) <= (3249 + 563)) and v23(v114.Reawaken, nil)) then
								return "reawaken";
							end
						elseif (v23(v116.ResuscitateMouseover, not v14:IsInRange(980 - (850 + 90))) or ((1379 - 591) >= (3006 - (360 + 1030)))) then
							return "resuscitate";
						end
						break;
					end
				end
			end
		end
		if (((1641 + 213) <= (9536 - 6157)) and not v12:AffectingCombat() and v29) then
			local v196 = 0 - 0;
			while true do
				if (((6210 - (909 + 752)) == (5772 - (109 + 1114))) and (v196 == (0 - 0))) then
					v28 = v125();
					if (v28 or ((1177 + 1845) >= (3266 - (6 + 236)))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((3037 + 1783) > (1770 + 428)) and (v29 or v12:AffectingCombat())) then
			local v197 = 0 - 0;
			while true do
				if (((3 - 1) == v197) or ((2194 - (1076 + 57)) >= (805 + 4086))) then
					if (((2053 - (579 + 110)) <= (354 + 4119)) and v32 and v89) then
						if ((v114.TigersLust:IsReady() and v120.UnitHasDebuffFromList(v12, v120.DispellableRootDebuffs) and v12:CanAttack(v14)) or ((3179 + 416) <= (2 + 1))) then
							if (v23(v114.TigersLust, nil) or ((5079 - (174 + 233)) == (10759 - 6907))) then
								return "Tigers Lust Roots";
							end
						end
					end
					if (((2735 - 1176) == (694 + 865)) and v33) then
						if ((v114.SummonJadeSerpentStatue:IsReady() and v114.SummonJadeSerpentStatue:IsAvailable() and (v114.SummonJadeSerpentStatue:TimeSinceLastCast() > (1264 - (663 + 511))) and v66) or ((1563 + 189) <= (172 + 616))) then
							if ((v65 == "Player") or ((12044 - 8137) == (108 + 69))) then
								if (((8169 - 4699) > (1343 - 788)) and v23(v116.SummonJadeSerpentStatuePlayer, not v14:IsInRange(20 + 20))) then
									return "jade serpent main player";
								end
							elseif ((v65 == "Cursor") or ((1891 - 919) == (460 + 185))) then
								if (((291 + 2891) >= (2837 - (478 + 244))) and v23(v116.SummonJadeSerpentStatueCursor, not v14:IsInRange(557 - (440 + 77)))) then
									return "jade serpent main cursor";
								end
							elseif (((1771 + 2122) < (16210 - 11781)) and (v65 == "Confirmation")) then
								if (v23(v114.SummonJadeSerpentStatue, not v14:IsInRange(1596 - (655 + 901))) or ((532 + 2335) < (1459 + 446))) then
									return "jade serpent main confirmation";
								end
							end
						end
						if ((v52 and v114.RenewingMist:IsReady() and v14:BuffDown(v114.RenewingMistBuff) and not v12:CanAttack(v14)) or ((1213 + 583) >= (16319 - 12268))) then
							if (((3064 - (695 + 750)) <= (12825 - 9069)) and (v14:HealthPercentage() <= v53)) then
								if (((931 - 327) == (2428 - 1824)) and v23(v114.RenewingMist, not v14:IsSpellInRange(v114.RenewingMist))) then
									return "RenewingMist main";
								end
							end
						end
						if ((v60 and v114.SoothingMist:IsReady() and v14:BuffDown(v114.SoothingMist) and not v12:CanAttack(v14)) or ((4835 - (285 + 66)) == (2097 - 1197))) then
							if ((v14:HealthPercentage() <= v61) or ((5769 - (682 + 628)) <= (180 + 933))) then
								if (((3931 - (176 + 123)) > (1422 + 1976)) and v23(v114.SoothingMist, not v14:IsSpellInRange(v114.SoothingMist))) then
									return "SoothingMist main";
								end
							end
						end
						if (((2961 + 1121) <= (5186 - (239 + 30))) and v36 and (v12:BuffStack(v114.ManaTeaCharges) >= (5 + 13)) and v114.ManaTea:IsCastable() and not v120.AreUnitsBelowHealthPercentage(82 + 3, 4 - 1, v114.EnvelopingMist)) then
							if (((15075 - 10243) >= (1701 - (306 + 9))) and v23(v114.ManaTea, nil)) then
								return "Mana Tea main avoid overcap";
							end
						end
						if (((477 - 340) == (24 + 113)) and (v112 > v99) and v31 and v12:AffectingCombat()) then
							local v239 = 0 + 0;
							while true do
								if ((v239 == (0 + 0)) or ((4489 - 2919) >= (5707 - (1140 + 235)))) then
									v28 = v132();
									if (v28 or ((2587 + 1477) <= (1669 + 150))) then
										return v28;
									end
									break;
								end
							end
						end
						if (v30 or ((1280 + 3706) < (1626 - (33 + 19)))) then
							local v240 = 0 + 0;
							while true do
								if (((13265 - 8839) > (76 + 96)) and (v240 == (0 - 0))) then
									v28 = v129();
									if (((550 + 36) > (1144 - (586 + 103))) and v28) then
										return v28;
									end
									break;
								end
							end
						end
						v28 = v128();
						if (((76 + 750) == (2542 - 1716)) and v28) then
							return v28;
						end
					end
					break;
				end
				if ((v197 == (1489 - (1309 + 179))) or ((7255 - 3236) > (1933 + 2508))) then
					if (((5416 - 3399) < (3219 + 1042)) and (v12:DebuffStack(v114.Bursting) > (10 - 5))) then
						if (((9397 - 4681) > (689 - (295 + 314))) and v114.DiffuseMagic:IsReady() and v114.DiffuseMagic:IsAvailable()) then
							if (v23(v114.DiffuseMagic, nil) or ((8613 - 5106) == (5234 - (1300 + 662)))) then
								return "Diffues Magic Bursting Player";
							end
						end
					end
					if (((v114.Bursting:MaxDebuffStack() > v110) and (v114.Bursting:AuraActiveCount() > v109)) or ((2750 - 1874) >= (4830 - (1178 + 577)))) then
						if (((2261 + 2091) > (7550 - 4996)) and v81 and v114.Revival:IsReady() and v114.Revival:IsAvailable()) then
							if (v23(v114.Revival, nil) or ((5811 - (851 + 554)) < (3576 + 467))) then
								return "Revival Bursting";
							end
						end
					end
					v197 = 5 - 3;
				end
				if ((v197 == (0 - 0)) or ((2191 - (115 + 187)) >= (2591 + 792))) then
					if (((1792 + 100) <= (10773 - 8039)) and v31 and v100 and (v115.Dreambinder:IsEquippedAndReady() or v115.Iridal:IsEquippedAndReady())) then
						if (((3084 - (160 + 1001)) < (1941 + 277)) and v23(v116.UseWeapon, nil)) then
							return "Using Weapon Macro";
						end
					end
					if (((1500 + 673) > (775 - 396)) and v107 and v115.AeratedManaPotion:IsReady() and (v12:ManaPercentage() <= v108)) then
						if (v23(v116.ManaPotion, nil) or ((2949 - (237 + 121)) == (4306 - (525 + 372)))) then
							return "Mana Potion main";
						end
					end
					v197 = 1 - 0;
				end
			end
		end
		if (((14831 - 10317) > (3466 - (96 + 46))) and (v29 or v12:AffectingCombat()) and v120.TargetIsValid() and v12:CanAttack(v14) and not v14:IsDeadOrGhost()) then
			local v198 = 777 - (643 + 134);
			while true do
				if ((v198 == (1 + 0)) or ((498 - 290) >= (17924 - 13096))) then
					if ((v97 and ((v31 and v98) or not v98)) or ((1519 + 64) > (7000 - 3433))) then
						v28 = v120.HandleTopTrinket(v117, v31, 81 - 41, nil);
						if (v28 or ((2032 - (316 + 403)) == (528 + 266))) then
							return v28;
						end
						v28 = v120.HandleBottomTrinket(v117, v31, 109 - 69, nil);
						if (((1148 + 2026) > (7308 - 4406)) and v28) then
							return v28;
						end
					end
					if (((2920 + 1200) <= (1373 + 2887)) and v34) then
						if ((v95 and ((v31 and v96) or not v96) and (v112 < (62 - 44))) or ((4217 - 3334) > (9925 - 5147))) then
							local v241 = 0 + 0;
							while true do
								if ((v241 == (3 - 1)) or ((177 + 3443) >= (14389 - 9498))) then
									if (((4275 - (12 + 5)) > (3639 - 2702)) and v114.AncestralCall:IsCastable()) then
										if (v23(v114.AncestralCall, nil) or ((10388 - 5519) < (1925 - 1019))) then
											return "ancestral_call main 12";
										end
									end
									if (v114.BagofTricks:IsCastable() or ((3037 - 1812) > (859 + 3369))) then
										if (((5301 - (1656 + 317)) > (1995 + 243)) and v23(v114.BagofTricks, not v14:IsInRange(33 + 7))) then
											return "bag_of_tricks main 14";
										end
									end
									break;
								end
								if (((10207 - 6368) > (6914 - 5509)) and (v241 == (354 - (5 + 349)))) then
									if (v114.BloodFury:IsCastable() or ((6141 - 4848) <= (1778 - (266 + 1005)))) then
										if (v23(v114.BloodFury, nil) or ((1909 + 987) < (2746 - 1941))) then
											return "blood_fury main 4";
										end
									end
									if (((3048 - 732) == (4012 - (561 + 1135))) and v114.Berserking:IsCastable()) then
										if (v23(v114.Berserking, nil) or ((3349 - 779) == (5039 - 3506))) then
											return "berserking main 6";
										end
									end
									v241 = 1067 - (507 + 559);
								end
								if ((v241 == (2 - 1)) or ((2730 - 1847) == (1848 - (212 + 176)))) then
									if (v114.LightsJudgment:IsCastable() or ((5524 - (250 + 655)) <= (2724 - 1725))) then
										if (v23(v114.LightsJudgment, not v14:IsInRange(69 - 29)) or ((5335 - 1925) > (6072 - (1869 + 87)))) then
											return "lights_judgment main 8";
										end
									end
									if (v114.Fireblood:IsCastable() or ((3131 - 2228) >= (4960 - (484 + 1417)))) then
										if (v23(v114.Fireblood, nil) or ((8522 - 4546) < (4787 - 1930))) then
											return "fireblood main 10";
										end
									end
									v241 = 775 - (48 + 725);
								end
							end
						end
						if (((8053 - 3123) > (6189 - 3882)) and v38 and v114.ThunderFocusTea:IsReady() and (not v114.EssenceFont:IsAvailable() or not v120.AreUnitsBelowHealthPercentage(v64, v63, v114.EnvelopingMist)) and (v114.RisingSunKick:CooldownRemains() < v12:GCD())) then
							if (v23(v114.ThunderFocusTea, nil) or ((2352 + 1694) < (3449 - 2158))) then
								return "ThunderFocusTea main 16";
							end
						end
						if (((v119 >= (1 + 2)) and v30) or ((1236 + 3005) == (4398 - (152 + 701)))) then
							local v242 = 1311 - (430 + 881);
							while true do
								if (((0 + 0) == v242) or ((4943 - (557 + 338)) > (1251 + 2981))) then
									v28 = v126();
									if (v28 or ((4931 - 3181) >= (12161 - 8688))) then
										return v28;
									end
									break;
								end
							end
						end
						if (((8411 - 5245) == (6822 - 3656)) and (v119 < (804 - (499 + 302)))) then
							local v243 = 866 - (39 + 827);
							while true do
								if (((4866 - 3103) < (8316 - 4592)) and (v243 == (0 - 0))) then
									v28 = v127();
									if (((87 - 30) <= (234 + 2489)) and v28) then
										return v28;
									end
									break;
								end
							end
						end
					end
					break;
				end
				if ((v198 == (0 - 0)) or ((332 + 1738) == (700 - 257))) then
					v28 = v123();
					if (v28 or ((2809 - (103 + 1)) == (1947 - (475 + 79)))) then
						return v28;
					end
					v198 = 2 - 1;
				end
			end
		end
	end
	local function v137()
		v122();
		v114.Bursting:RegisterAuraTracking();
		v21.Print("Mistweaver Monk rotation by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(864 - 594, v136, v137);
end;
return v0["Epix_Monk_Mistweaver.lua"]();

