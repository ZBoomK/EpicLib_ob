local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1633 + 736) == (514 + 1855)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Fury.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.TargetTarget;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
	local v31;
	local v32;
	local v33;
	local v34;
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
	local v90 = v19.Commons.Everyone;
	local v91 = v17.Warrior.Fury;
	local v92 = v18.Warrior.Fury;
	local v93 = v22.Warrior.Fury;
	local v94 = {};
	local v95 = 6139 + 4972;
	local v96 = 11774 - (174 + 489);
	v9:RegisterForEvent(function()
		local v113 = 0 - 0;
		while true do
			if (((6000 - (830 + 1075)) >= (3707 - (303 + 221))) and (v113 == (1269 - (231 + 1038)))) then
				v95 = 9259 + 1852;
				v96 = 12273 - (171 + 991);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v97, v98;
	local v99;
	local function v100()
		local v114 = 0 - 0;
		local v115;
		while true do
			if ((v114 == (0 - 0)) or ((9260 - 5549) < (807 + 201))) then
				v115 = UnitGetTotalAbsorbs(v14:ID());
				if ((v115 > (0 - 0)) or ((3025 - 1976) <= (1460 - 554))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v101()
		if (((13950 - 9437) > (3974 - (111 + 1137))) and v91.BitterImmunity:IsReady() and v62 and (v13:HealthPercentage() <= v71)) then
			if (v23(v91.BitterImmunity) or ((1639 - (91 + 67)) >= (7910 - 5252))) then
				return "bitter_immunity defensive";
			end
		end
		if ((v91.EnragedRegeneration:IsCastable() and v63 and (v13:HealthPercentage() <= v72)) or ((804 + 2416) == (1887 - (423 + 100)))) then
			if (v23(v91.EnragedRegeneration) or ((8 + 1046) > (9391 - 5999))) then
				return "enraged_regeneration defensive";
			end
		end
		if ((v91.IgnorePain:IsCastable() and v64 and (v13:HealthPercentage() <= v73)) or ((353 + 323) >= (2413 - (326 + 445)))) then
			if (((18049 - 13913) > (5340 - 2943)) and v23(v91.IgnorePain, nil, nil, true)) then
				return "ignore_pain defensive";
			end
		end
		if ((v91.RallyingCry:IsCastable() and v65 and v13:BuffDown(v91.AspectsFavorBuff) and v13:BuffDown(v91.RallyingCry) and (((v13:HealthPercentage() <= v74) and v90.IsSoloMode()) or v90.AreUnitsBelowHealthPercentage(v74, v75))) or ((10116 - 5782) == (4956 - (530 + 181)))) then
			if (v23(v91.RallyingCry) or ((5157 - (614 + 267)) <= (3063 - (19 + 13)))) then
				return "rallying_cry defensive";
			end
		end
		if ((v91.Intervene:IsCastable() and v66 and (v16:HealthPercentage() <= v76) and (v16:UnitName() ~= v13:UnitName())) or ((7782 - 3000) <= (2793 - 1594))) then
			if (v23(v93.InterveneFocus) or ((13894 - 9030) < (494 + 1408))) then
				return "intervene defensive";
			end
		end
		if (((8509 - 3670) >= (7673 - 3973)) and v91.DefensiveStance:IsCastable() and v67 and (v13:HealthPercentage() <= v77) and v13:BuffDown(v91.DefensiveStance, true)) then
			if (v23(v91.DefensiveStance) or ((2887 - (1293 + 519)) > (3913 - 1995))) then
				return "defensive_stance defensive";
			end
		end
		if (((1033 - 637) <= (7273 - 3469)) and v91.BerserkerStance:IsCastable() and v67 and (v13:HealthPercentage() > v80) and v13:BuffDown(v91.BerserkerStance, true)) then
			if (v23(v91.BerserkerStance) or ((17977 - 13808) == (5151 - 2964))) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if (((745 + 661) == (287 + 1119)) and v92.Healthstone:IsReady() and v68 and (v13:HealthPercentage() <= v78)) then
			if (((3557 - 2026) < (987 + 3284)) and v23(v93.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((211 + 424) == (397 + 238)) and v69 and (v13:HealthPercentage() <= v79)) then
			local v138 = 1096 - (709 + 387);
			while true do
				if (((5231 - (673 + 1185)) <= (10312 - 6756)) and (v138 == (0 - 0))) then
					if ((v85 == "Refreshing Healing Potion") or ((5414 - 2123) < (2347 + 933))) then
						if (((3278 + 1108) >= (1177 - 304)) and v92.RefreshingHealingPotion:IsReady()) then
							if (((227 + 694) <= (2196 - 1094)) and v23(v93.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((9237 - 4531) >= (2843 - (446 + 1434))) and (v85 == "Dreamwalker's Healing Potion")) then
						if (v92.DreamwalkersHealingPotion:IsReady() or ((2243 - (1040 + 243)) <= (2614 - 1738))) then
							if (v23(v93.RefreshingHealingPotion) or ((3913 - (559 + 1288)) == (2863 - (609 + 1322)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v102()
		local v116 = 454 - (13 + 441);
		while true do
			if (((18030 - 13205) < (12685 - 7842)) and (v116 == (0 - 0))) then
				v26 = v90.HandleTopTrinket(v94, v29, 2 + 38, nil);
				if (v26 or ((14080 - 10203) >= (1612 + 2925))) then
					return v26;
				end
				v116 = 1 + 0;
			end
			if ((v116 == (2 - 1)) or ((2362 + 1953) < (3173 - 1447))) then
				v26 = v90.HandleBottomTrinket(v94, v29, 27 + 13, nil);
				if (v26 or ((2047 + 1632) < (450 + 175))) then
					return v26;
				end
				break;
			end
		end
	end
	local function v103()
		local v117 = 0 + 0;
		while true do
			if ((v117 == (0 + 0)) or ((5058 - (153 + 280)) < (1824 - 1192))) then
				if ((v30 and ((v51 and v29) or not v51) and (v89 < v96) and v91.Avatar:IsCastable() and not v91.TitansTorment:IsAvailable()) or ((75 + 8) > (703 + 1077))) then
					if (((286 + 260) <= (978 + 99)) and v23(v91.Avatar, not v99)) then
						return "avatar precombat 6";
					end
				end
				if ((v43 and ((v54 and v29) or not v54) and (v89 < v96) and v91.Recklessness:IsCastable() and not v91.RecklessAbandon:IsAvailable()) or ((722 + 274) > (6548 - 2247))) then
					if (((2516 + 1554) > (1354 - (89 + 578))) and v23(v91.Recklessness, not v99)) then
						return "recklessness precombat 8";
					end
				end
				v117 = 1 + 0;
			end
			if ((v117 == (1 - 0)) or ((1705 - (572 + 477)) >= (450 + 2880))) then
				if ((v91.Bloodthirst:IsCastable() and v33 and v99) or ((1496 + 996) <= (40 + 295))) then
					if (((4408 - (84 + 2)) >= (4221 - 1659)) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst precombat 10";
					end
				end
				if ((v34 and v91.Charge:IsReady() and not v99) or ((2621 + 1016) >= (4612 - (497 + 345)))) then
					if (v23(v91.Charge, not v14:IsSpellInRange(v91.Charge)) or ((61 + 2318) > (774 + 3804))) then
						return "charge precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v104()
		if (not v13:AffectingCombat() or ((1816 - (605 + 728)) > (531 + 212))) then
			local v139 = 0 - 0;
			while true do
				if (((113 + 2341) > (2136 - 1558)) and ((0 + 0) == v139)) then
					if (((2576 - 1646) < (3367 + 1091)) and v91.BerserkerStance:IsCastable() and v13:BuffDown(v91.BerserkerStance, true)) then
						if (((1151 - (457 + 32)) <= (413 + 559)) and v23(v91.BerserkerStance)) then
							return "berserker_stance";
						end
					end
					if (((5772 - (832 + 570)) == (4117 + 253)) and v91.BattleShout:IsCastable() and v31 and (v13:BuffDown(v91.BattleShoutBuff, true) or v90.GroupBuffMissing(v91.BattleShoutBuff))) then
						if (v23(v91.BattleShout) or ((1242 + 3520) <= (3046 - 2185))) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if ((v90.TargetIsValid() and v27) or ((681 + 731) == (5060 - (588 + 208)))) then
			if (not v13:AffectingCombat() or ((8538 - 5370) < (3953 - (884 + 916)))) then
				local v176 = 0 - 0;
				while true do
					if ((v176 == (0 + 0)) or ((5629 - (232 + 421)) < (3221 - (1569 + 320)))) then
						v26 = v103();
						if (((1136 + 3492) == (880 + 3748)) and v26) then
							return v26;
						end
						break;
					end
				end
			end
		end
	end
	local function v105()
		local v118 = 0 - 0;
		local v119;
		while true do
			if (((606 - (316 + 289)) == v118) or ((140 - 86) == (19 + 376))) then
				if (((1535 - (666 + 787)) == (507 - (360 + 65))) and v91.Bloodbath:IsCastable() and v32 and v13:HasTier(29 + 1, 258 - (79 + 175)) and (v119 >= (149 - 54))) then
					if (v23(v91.Bloodbath, not v99) or ((454 + 127) < (864 - 582))) then
						return "bloodbath single_target 10";
					end
				end
				if ((v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(57 - 27, 903 - (503 + 396)) and (v119 >= (276 - (92 + 89)))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff) and (v14:DebuffDown(v91.GushingWoundDebuff) or v13:BuffUp(v91.ChampionsMightBuff))))) or ((8940 - 4331) < (1280 + 1215))) then
					if (((682 + 470) == (4511 - 3359)) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst single_target 12";
					end
				end
				if (((260 + 1636) <= (7802 - 4380)) and v91.Bloodbath:IsCastable() and v32 and v13:HasTier(28 + 3, 1 + 1)) then
					if (v23(v91.Bloodbath, not v99) or ((3015 - 2025) > (203 + 1417))) then
						return "bloodbath single_target 14";
					end
				end
				if ((v46 and ((v56 and v29) or not v56) and (v89 < v96) and v91.ThunderousRoar:IsCastable() and v13:BuffUp(v91.EnrageBuff)) or ((1336 - 459) > (5939 - (485 + 759)))) then
					if (((6226 - 3535) >= (3040 - (442 + 747))) and v23(v91.ThunderousRoar, not v14:IsInMeleeRange(1143 - (832 + 303)))) then
						return "thunderous_roar single_target 16";
					end
				end
				if ((v91.Onslaught:IsReady() and v39 and (v13:BuffUp(v91.EnrageBuff) or v91.Tenderize:IsAvailable())) or ((3931 - (88 + 858)) >= (1481 + 3375))) then
					if (((3539 + 737) >= (50 + 1145)) and v23(v91.Onslaught, not v99)) then
						return "onslaught single_target 18";
					end
				end
				v118 = 791 - (766 + 23);
			end
			if (((15955 - 12723) <= (6414 - 1724)) and (v118 == (4 - 2))) then
				if ((v91.CrushingBlow:IsCastable() and v35 and v91.WrathandFury:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((3040 - 2144) >= (4219 - (1036 + 37)))) then
					if (((2171 + 890) >= (5760 - 2802)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow single_target 20";
					end
				end
				if (((2507 + 680) >= (2124 - (641 + 839))) and v91.Execute:IsReady() and v36 and ((v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.AshenJuggernautBuff)) or ((v13:BuffRemains(v91.SuddenDeathBuff) <= v13:GCD()) and (((v14:HealthPercentage() > (948 - (910 + 3))) and v91.Massacre:IsAvailable()) or (v14:HealthPercentage() > (50 - 30)))))) then
					if (((2328 - (1466 + 218)) <= (324 + 380)) and v23(v91.Execute, not v99)) then
						return "execute single_target 22";
					end
				end
				if (((2106 - (556 + 592)) > (337 + 610)) and v91.Rampage:IsReady() and v41 and v91.RecklessAbandon:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (893 - (329 + 479))))) then
					if (((5346 - (174 + 680)) >= (9119 - 6465)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 24";
					end
				end
				if (((7133 - 3691) >= (1074 + 429)) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) then
					if (v23(v91.Execute, not v99) or ((3909 - (396 + 343)) <= (130 + 1334))) then
						return "execute single_target 26";
					end
				end
				if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable()) or ((6274 - (29 + 1448)) == (5777 - (135 + 1254)))) then
					if (((2075 - 1524) <= (3179 - 2498)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 28";
					end
				end
				v118 = 2 + 1;
			end
			if (((4804 - (389 + 1138)) > (981 - (102 + 472))) and ((5 + 0) == v118)) then
				if (((2604 + 2091) >= (1320 + 95)) and v91.Rampage:IsReady() and v41) then
					if (v23(v91.Rampage, not v99) or ((4757 - (320 + 1225)) <= (1680 - 736))) then
						return "rampage single_target 47";
					end
				end
				if ((v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) or ((1895 + 1201) <= (3262 - (157 + 1307)))) then
					if (((5396 - (821 + 1038)) == (8824 - 5287)) and v23(v91.Slam, not v99)) then
						return "slam single_target 48";
					end
				end
				if (((420 + 3417) >= (2788 - 1218)) and v91.Bloodbath:IsCastable() and v32) then
					if (v23(v91.Bloodbath, not v99) or ((1098 + 1852) == (9448 - 5636))) then
						return "bloodbath single_target 50";
					end
				end
				if (((5749 - (834 + 192)) >= (148 + 2170)) and v91.RagingBlow:IsCastable() and v40) then
					if (v23(v91.RagingBlow, not v99) or ((521 + 1506) > (62 + 2790))) then
						return "raging_blow single_target 52";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v35 and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((1759 - 623) > (4621 - (300 + 4)))) then
					if (((1269 + 3479) == (12429 - 7681)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow single_target 54";
					end
				end
				v118 = 368 - (112 + 250);
			end
			if (((1490 + 2246) <= (11874 - 7134)) and (v118 == (3 + 1))) then
				if ((v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (1 + 0)) and v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((2536 + 854) <= (1518 + 1542))) then
					if (v23(v91.CrushingBlow, not v99) or ((743 + 256) > (4107 - (1001 + 413)))) then
						return "crushing_blow single_target 38";
					end
				end
				if (((1032 - 569) < (1483 - (244 + 638))) and v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) then
					if (v23(v91.Bloodbath, not v99) or ((2876 - (627 + 66)) < (2046 - 1359))) then
						return "bloodbath single_target 40";
					end
				end
				if (((5151 - (512 + 90)) == (6455 - (1665 + 241))) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) then
					if (((5389 - (373 + 344)) == (2108 + 2564)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow single_target 42";
					end
				end
				if ((v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable() and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((971 + 2697) < (1041 - 646))) then
					if (v23(v91.Bloodthirst, not v99) or ((7049 - 2883) == (1554 - (35 + 1064)))) then
						return "bloodthirst single_target 44";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 + 0))) or ((9518 - 5069) == (11 + 2652))) then
					if (v23(v91.RagingBlow, not v99) or ((5513 - (298 + 938)) < (4248 - (233 + 1026)))) then
						return "raging_blow single_target 46";
					end
				end
				v118 = 1671 - (636 + 1030);
			end
			if ((v118 == (4 + 2)) or ((850 + 20) >= (1233 + 2916))) then
				if (((150 + 2062) < (3404 - (55 + 166))) and v91.Bloodthirst:IsCastable() and v33) then
					if (((901 + 3745) > (301 + 2691)) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst single_target 56";
					end
				end
				if (((5476 - 4042) < (3403 - (36 + 261))) and v28 and v91.Whirlwind:IsCastable() and v47) then
					if (((1374 - 588) < (4391 - (34 + 1334))) and v23(v91.Whirlwind, not v14:IsInMeleeRange(4 + 4))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if (((0 + 0) == v118) or ((3725 - (1035 + 248)) < (95 - (20 + 1)))) then
				if (((2363 + 2172) == (4854 - (134 + 185))) and v91.Whirlwind:IsCastable() and v47 and (v98 > (1134 - (549 + 584))) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) then
					if (v23(v91.Whirlwind, not v14:IsInMeleeRange(693 - (314 + 371))) or ((10329 - 7320) <= (3073 - (478 + 490)))) then
						return "whirlwind single_target 2";
					end
				end
				if (((970 + 860) < (4841 - (786 + 386))) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) then
					if (v23(v91.Execute, not v99) or ((4631 - 3201) >= (4991 - (1055 + 324)))) then
						return "execute single_target 4";
					end
				end
				if (((4023 - (1093 + 247)) >= (2187 + 273)) and v38 and ((v52 and v29) or not v52) and v91.OdynsFury:IsCastable() and (v89 < v96) and v13:BuffUp(v91.EnrageBuff) and ((v91.DancingBlades:IsAvailable() and (v13:BuffRemains(v91.DancingBladesBuff) < (1 + 4))) or not v91.DancingBlades:IsAvailable())) then
					if (v23(v91.OdynsFury, not v14:IsInMeleeRange(31 - 23)) or ((6122 - 4318) >= (9319 - 6044))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((v91.Rampage:IsReady() and v41 and v91.AngerManagement:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or (v13:RagePercentage() > (213 - 128)))) or ((505 + 912) > (13980 - 10351))) then
					if (((16527 - 11732) > (304 + 98)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 8";
					end
				end
				v119 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (51 - 31)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (698 - (364 + 324))) + (v13:BuffStack(v91.BloodcrazeBuff) * (40 - 25));
				v118 = 2 - 1;
			end
			if (((1596 + 3217) > (14917 - 11352)) and (v118 == (4 - 1))) then
				if (((11881 - 7969) == (5180 - (1249 + 19))) and v91.Execute:IsReady() and v36) then
					if (((2547 + 274) <= (18777 - 13953)) and v23(v91.Execute, not v99)) then
						return "execute single_target 29";
					end
				end
				if (((2824 - (686 + 400)) <= (1723 + 472)) and v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) then
					if (((270 - (73 + 156)) <= (15 + 3003)) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath single_target 30";
					end
				end
				if (((2956 - (721 + 90)) <= (47 + 4057)) and v91.Rampage:IsReady() and v41 and (v14:HealthPercentage() < (113 - 78)) and v91.Massacre:IsAvailable()) then
					if (((3159 - (224 + 246)) < (7848 - 3003)) and v23(v91.Rampage, not v99)) then
						return "rampage single_target 32";
					end
				end
				if ((v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff))) and v13:BuffDown(v91.FuriousBloodthirstBuff)) or ((4275 - 1953) > (476 + 2146))) then
					if (v23(v91.Bloodthirst, not v99) or ((108 + 4426) == (1530 + 552))) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 - 0)) and v91.WrathandFury:IsAvailable()) or ((5227 - 3656) > (2380 - (203 + 310)))) then
					if (v23(v91.RagingBlow, not v99) or ((4647 - (1238 + 755)) >= (210 + 2786))) then
						return "raging_blow single_target 36";
					end
				end
				v118 = 1538 - (709 + 825);
			end
		end
	end
	local function v106()
		local v120 = 0 - 0;
		local v121;
		while true do
			if (((5794 - 1816) > (2968 - (196 + 668))) and (v120 == (7 - 5))) then
				if (((6203 - 3208) > (2374 - (171 + 662))) and v91.Bloodthirst:IsCastable() and v33 and ((v13:HasTier(123 - (4 + 89), 13 - 9) and (v121 >= (35 + 60))) or (not v91.RecklessAbandon:IsAvailable() and v13:BuffUp(v91.FuriousBloodthirstBuff) and v13:BuffUp(v91.EnrageBuff)))) then
					if (((14270 - 11021) > (374 + 579)) and v23(v91.Bloodthirst, not v99)) then
						return "bloodthirst multi_target 16";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v91.WrathandFury:IsAvailable() and v35 and v13:BuffUp(v91.EnrageBuff)) or ((4759 - (35 + 1451)) > (6026 - (28 + 1425)))) then
					if (v23(v91.CrushingBlow, not v99) or ((5144 - (941 + 1052)) < (1232 + 52))) then
						return "crushing_blow multi_target 14";
					end
				end
				if ((v91.Execute:IsReady() and v36 and v13:BuffUp(v91.EnrageBuff)) or ((3364 - (822 + 692)) == (2182 - 653))) then
					if (((387 + 434) < (2420 - (45 + 252))) and v23(v91.Execute, not v99)) then
						return "execute multi_target 16";
					end
				end
				if (((893 + 9) < (801 + 1524)) and v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) then
					if (((2088 - 1230) <= (3395 - (114 + 319))) and v23(v91.OdynsFury, not v14:IsInMeleeRange(11 - 3))) then
						return "odyns_fury multi_target 18";
					end
				end
				v120 = 3 - 0;
			end
			if ((v120 == (0 + 0)) or ((5878 - 1932) < (2698 - 1410))) then
				if ((v91.Recklessness:IsCastable() and ((v54 and v29) or not v54) and v43 and (v89 < v96) and ((v98 > (1964 - (556 + 1407))) or (v96 < (1218 - (741 + 465))))) or ((3707 - (170 + 295)) == (299 + 268))) then
					if (v23(v91.Recklessness, not v99) or ((778 + 69) >= (3109 - 1846))) then
						return "recklessness multi_target 2";
					end
				end
				if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (1 + 0)) and v91.TitanicRage:IsAvailable() and (v13:BuffDown(v91.MeatCleaverBuff) or v13:BuffUp(v91.AvatarBuff) or v13:BuffUp(v91.RecklessnessBuff))) or ((1445 + 808) == (1049 + 802))) then
					if (v23(v91.OdynsFury, not v14:IsInMeleeRange(1238 - (957 + 273))) or ((559 + 1528) > (950 + 1422))) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((v91.Whirlwind:IsCastable() and v47 and (v98 > (3 - 2)) and v91.ImprovedWhilwind:IsAvailable() and v13:BuffDown(v91.MeatCleaverBuff)) or ((11713 - 7268) < (12672 - 8523))) then
					if (v23(v91.Whirlwind, not v14:IsInMeleeRange(39 - 31)) or ((3598 - (389 + 1391)) == (54 + 31))) then
						return "whirlwind multi_target 6";
					end
				end
				if (((66 + 564) < (4842 - 2715)) and v91.Execute:IsReady() and v36 and v13:BuffUp(v91.AshenJuggernautBuff) and (v13:BuffRemains(v91.AshenJuggernautBuff) < v13:GCD())) then
					if (v23(v91.Execute, not v99) or ((2889 - (783 + 168)) == (8437 - 5923))) then
						return "execute multi_target 8";
					end
				end
				v120 = 1 + 0;
			end
			if (((4566 - (309 + 2)) >= (168 - 113)) and (v120 == (1218 - (1090 + 122)))) then
				if (((973 + 2026) > (3882 - 2726)) and v91.Slam:IsReady() and v44 and (v91.Annihilator:IsAvailable())) then
					if (((1609 + 741) > (2273 - (628 + 490))) and v23(v91.Slam, not v99)) then
						return "slam multi_target 44";
					end
				end
				if (((723 + 3306) <= (12015 - 7162)) and v91.Bloodbath:IsCastable() and v32) then
					if (v23(v91.Bloodbath, not v99) or ((2358 - 1842) > (4208 - (431 + 343)))) then
						return "bloodbath multi_target 46";
					end
				end
				if (((8171 - 4125) >= (8774 - 5741)) and v91.RagingBlow:IsCastable() and v40) then
					if (v23(v91.RagingBlow, not v99) or ((2149 + 570) <= (186 + 1261))) then
						return "raging_blow multi_target 48";
					end
				end
				if ((v91.CrushingBlow:IsCastable() and v35) or ((5829 - (556 + 1139)) < (3941 - (6 + 9)))) then
					if (v23(v91.CrushingBlow, not v99) or ((31 + 133) >= (1427 + 1358))) then
						return "crushing_blow multi_target 50";
					end
				end
				v120 = 176 - (28 + 141);
			end
			if ((v120 == (3 + 4)) or ((648 - 123) == (1494 + 615))) then
				if (((1350 - (486 + 831)) == (85 - 52)) and v91.Whirlwind:IsCastable() and v47) then
					if (((10751 - 7697) <= (759 + 3256)) and v23(v91.Whirlwind, not v14:IsInMeleeRange(25 - 17))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if (((3134 - (668 + 595)) < (3044 + 338)) and (v120 == (1 + 2))) then
				if (((3526 - 2233) <= (2456 - (23 + 267))) and v91.Rampage:IsReady() and v41 and (v13:BuffUp(v91.RecklessnessBuff) or (v13:BuffRemains(v91.EnrageBuff) < v13:GCD()) or ((v13:Rage() > (2054 - (1129 + 815))) and v91.OverwhelmingRage:IsAvailable()) or ((v13:Rage() > (467 - (371 + 16))) and not v91.OverwhelmingRage:IsAvailable()))) then
					if (v23(v91.Rampage, not v99) or ((4329 - (1326 + 424)) < (232 - 109))) then
						return "rampage multi_target 20";
					end
				end
				if ((v91.Execute:IsReady() and v36) or ((3091 - 2245) >= (2486 - (88 + 30)))) then
					if (v23(v91.Execute, not v99) or ((4783 - (720 + 51)) <= (7469 - 4111))) then
						return "execute multi_target 22";
					end
				end
				if (((3270 - (421 + 1355)) <= (4957 - 1952)) and v91.Bloodbath:IsCastable() and v32 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable() and not v91.WrathandFury:IsAvailable()) then
					if (v23(v91.Bloodbath, not v99) or ((1529 + 1582) == (3217 - (286 + 797)))) then
						return "bloodbath multi_target 24";
					end
				end
				if (((8608 - 6253) == (3900 - 1545)) and v91.Bloodthirst:IsCastable() and v33 and (not v13:BuffUp(v91.EnrageBuff) or (v91.Annihilator:IsAvailable() and v13:BuffDown(v91.RecklessnessBuff)))) then
					if (v23(v91.Bloodthirst, not v99) or ((1027 - (397 + 42)) <= (135 + 297))) then
						return "bloodthirst multi_target 26";
					end
				end
				v120 = 804 - (24 + 776);
			end
			if (((7389 - 2592) >= (4680 - (222 + 563))) and (v120 == (11 - 6))) then
				if (((2576 + 1001) == (3767 - (23 + 167))) and v91.CrushingBlow:IsCastable() and v35 and v13:BuffUp(v91.EnrageBuff) and v91.RecklessAbandon:IsAvailable()) then
					if (((5592 - (690 + 1108)) > (1333 + 2360)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow multi_target 36";
					end
				end
				if ((v91.Bloodthirst:IsCastable() and v33 and not v91.WrathandFury:IsAvailable()) or ((1052 + 223) == (4948 - (40 + 808)))) then
					if (v23(v91.Bloodthirst, not v99) or ((262 + 1329) >= (13689 - 10109))) then
						return "bloodthirst multi_target 38";
					end
				end
				if (((940 + 43) <= (957 + 851)) and v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (1 + 0))) then
					if (v23(v91.RagingBlow, not v99) or ((2721 - (47 + 524)) <= (777 + 420))) then
						return "raging_blow multi_target 40";
					end
				end
				if (((10302 - 6533) >= (1753 - 580)) and v91.Rampage:IsReady() and v41) then
					if (((3386 - 1901) == (3211 - (1165 + 561))) and v23(v91.Rampage, not v99)) then
						return "rampage multi_target 42";
					end
				end
				v120 = 1 + 5;
			end
			if ((v120 == (3 - 2)) or ((1265 + 2050) <= (3261 - (341 + 138)))) then
				if ((v91.ThunderousRoar:IsCastable() and ((v56 and v29) or not v56) and v46 and (v89 < v96) and v13:BuffUp(v91.EnrageBuff)) or ((237 + 639) >= (6116 - 3152))) then
					if (v23(v91.ThunderousRoar, not v14:IsInMeleeRange(334 - (89 + 237))) or ((7180 - 4948) > (5256 - 2759))) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((v91.OdynsFury:IsCastable() and ((v52 and v29) or not v52) and v38 and (v89 < v96) and (v98 > (882 - (581 + 300))) and v13:BuffUp(v91.EnrageBuff)) or ((3330 - (855 + 365)) <= (788 - 456))) then
					if (((1204 + 2482) > (4407 - (1030 + 205))) and v23(v91.OdynsFury, not v14:IsInMeleeRange(8 + 0))) then
						return "odyns_fury multi_target 12";
					end
				end
				v121 = v13:CritChancePct() + (v24(v13:BuffUp(v91.RecklessnessBuff)) * (19 + 1)) + (v13:BuffStack(v91.MercilessAssaultBuff) * (296 - (156 + 130))) + (v13:BuffStack(v91.BloodcrazeBuff) * (34 - 19));
				if ((v91.Bloodbath:IsCastable() and v32 and v13:HasTier(50 - 20, 7 - 3) and (v121 >= (26 + 69))) or ((2609 + 1865) < (889 - (10 + 59)))) then
					if (((1211 + 3068) >= (14193 - 11311)) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath multi_target 14";
					end
				end
				v120 = 1165 - (671 + 492);
			end
			if ((v120 == (4 + 0)) or ((3244 - (369 + 846)) >= (933 + 2588))) then
				if ((v91.Onslaught:IsReady() and v39 and ((not v91.Annihilator:IsAvailable() and v13:BuffUp(v91.EnrageBuff)) or v91.Tenderize:IsAvailable())) or ((1739 + 298) >= (6587 - (1036 + 909)))) then
					if (((1368 + 352) < (7484 - 3026)) and v23(v91.Onslaught, not v99)) then
						return "onslaught multi_target 28";
					end
				end
				if ((v91.RagingBlow:IsCastable() and v40 and (v91.RagingBlow:Charges() > (204 - (11 + 192))) and v91.WrathandFury:IsAvailable()) or ((221 + 215) > (3196 - (135 + 40)))) then
					if (((1727 - 1014) <= (511 + 336)) and v23(v91.RagingBlow, not v99)) then
						return "raging_blow multi_target 30";
					end
				end
				if (((4745 - 2591) <= (6042 - 2011)) and v91.CrushingBlow:IsCastable() and v35 and (v91.CrushingBlow:Charges() > (177 - (50 + 126))) and v91.WrathandFury:IsAvailable()) then
					if (((12850 - 8235) == (1022 + 3593)) and v23(v91.CrushingBlow, not v99)) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((v91.Bloodbath:IsCastable() and v32 and (not v13:BuffUp(v91.EnrageBuff) or not v91.WrathandFury:IsAvailable())) or ((5203 - (1233 + 180)) == (1469 - (522 + 447)))) then
					if (((1510 - (107 + 1314)) < (103 + 118)) and v23(v91.Bloodbath, not v99)) then
						return "bloodbath multi_target 34";
					end
				end
				v120 = 15 - 10;
			end
		end
	end
	local function v107()
		local v122 = 0 + 0;
		while true do
			if (((4078 - 2024) >= (5622 - 4201)) and (v122 == (1911 - (716 + 1194)))) then
				if (((12 + 680) < (328 + 2730)) and v84) then
					v26 = v90.HandleIncorporeal(v91.StormBolt, v93.StormBoltMouseover, 523 - (74 + 429), true);
					if (v26 or ((6276 - 3022) == (821 + 834))) then
						return v26;
					end
					v26 = v90.HandleIncorporeal(v91.IntimidatingShout, v93.IntimidatingShoutMouseover, 18 - 10, true);
					if (v26 or ((917 + 379) == (15137 - 10227))) then
						return v26;
					end
				end
				if (((8327 - 4959) == (3801 - (279 + 154))) and v90.TargetIsValid()) then
					if (((3421 - (454 + 324)) < (3002 + 813)) and v34 and v91.Charge:IsCastable()) then
						if (((1930 - (12 + 5)) > (266 + 227)) and v23(v91.Charge, not v14:IsSpellInRange(v91.Charge))) then
							return "charge main 2";
						end
					end
					local v177 = v90.HandleDPSPotion(v14:BuffUp(v91.RecklessnessBuff));
					if (((12115 - 7360) > (1267 + 2161)) and v177) then
						return v177;
					end
					if (((2474 - (277 + 816)) <= (10122 - 7753)) and (v89 < v96)) then
						if ((v50 and ((v29 and v58) or not v58)) or ((6026 - (1058 + 125)) == (766 + 3318))) then
							local v178 = 975 - (815 + 160);
							while true do
								if (((20032 - 15363) > (861 - 498)) and (v178 == (0 + 0))) then
									v26 = v102();
									if (v26 or ((5486 - 3609) >= (5036 - (41 + 1857)))) then
										return v26;
									end
									break;
								end
							end
						end
						if (((6635 - (1222 + 671)) >= (9371 - 5745)) and v29 and v92.FyralathTheDreamrender:IsEquippedAndReady()) then
							if (v23(v93.UseWeapon) or ((6525 - 1985) == (2098 - (229 + 953)))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if (((v89 < v96) and v49 and ((v57 and v29) or not v57)) or ((2930 - (1111 + 663)) > (5924 - (874 + 705)))) then
						if (((314 + 1923) < (2899 + 1350)) and v91.BloodFury:IsCastable()) then
							if (v23(v91.BloodFury, not v99) or ((5576 - 2893) < (1 + 22))) then
								return "blood_fury main 12";
							end
						end
						if (((1376 - (642 + 37)) <= (189 + 637)) and v91.Berserking:IsCastable() and v13:BuffUp(v91.RecklessnessBuff)) then
							if (((177 + 928) <= (2952 - 1776)) and v23(v91.Berserking, not v99)) then
								return "berserking main 14";
							end
						end
						if (((3833 - (233 + 221)) <= (8814 - 5002)) and v91.LightsJudgment:IsCastable() and v13:BuffDown(v91.RecklessnessBuff)) then
							if (v23(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment)) or ((694 + 94) >= (3157 - (718 + 823)))) then
								return "lights_judgment main 16";
							end
						end
						if (((1167 + 687) <= (4184 - (266 + 539))) and v91.Fireblood:IsCastable()) then
							if (((12878 - 8329) == (5774 - (636 + 589))) and v23(v91.Fireblood, not v99)) then
								return "fireblood main 18";
							end
						end
						if (v91.AncestralCall:IsCastable() or ((7173 - 4151) >= (6237 - 3213))) then
							if (((3820 + 1000) > (799 + 1399)) and v23(v91.AncestralCall, not v99)) then
								return "ancestral_call main 20";
							end
						end
						if ((v91.BagofTricks:IsCastable() and v13:BuffDown(v91.RecklessnessBuff) and v13:BuffUp(v91.EnrageBuff)) or ((2076 - (657 + 358)) >= (12950 - 8059))) then
							if (((3107 - 1743) <= (5660 - (1151 + 36))) and v23(v91.BagofTricks, not v14:IsSpellInRange(v91.BagofTricks))) then
								return "bag_of_tricks main 22";
							end
						end
					end
					if ((v89 < v96) or ((3472 + 123) <= (1 + 2))) then
						if ((v91.Avatar:IsCastable() and v30 and ((v51 and v29) or not v51) and v91.TitansTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and (v89 < v96) and v13:BuffDown(v91.AvatarBuff) and (not v91.OdynsFury:IsAvailable() or (v91.OdynsFury:CooldownRemains() > (0 - 0)))) or (v91.BerserkersTorment:IsAvailable() and v13:BuffUp(v91.EnrageBuff) and v13:BuffDown(v91.AvatarBuff)) or (not v91.TitansTorment:IsAvailable() and not v91.BerserkersTorment:IsAvailable() and (v13:BuffUp(v91.RecklessnessBuff) or (v96 < (1852 - (1552 + 280))))) or ((5506 - (64 + 770)) == (2616 + 1236))) then
							if (((3538 - 1979) == (277 + 1282)) and v23(v91.Avatar, not v99)) then
								return "avatar main 24";
							end
						end
						if ((v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v91.ChampionsSpear:CooldownRemains() < (1244 - (157 + 1086))) or (v91.Avatar:CooldownRemains() > (80 - 40)) or not v91.Avatar:IsAvailable() or (v96 < (52 - 40)))) or ((2686 - 934) <= (1075 - 287))) then
							if (v23(v91.Recklessness, not v99) or ((4726 - (599 + 220)) == (352 - 175))) then
								return "recklessness main 26";
							end
						end
						if (((5401 - (1813 + 118)) > (406 + 149)) and v91.Recklessness:IsCastable() and v43 and ((v54 and v29) or not v54) and (not v91.Annihilator:IsAvailable() or (v96 < (1229 - (841 + 376))))) then
							if (v23(v91.Recklessness, not v99) or ((1361 - 389) == (150 + 495))) then
								return "recklessness main 27";
							end
						end
						if (((8685 - 5503) >= (2974 - (464 + 395))) and v91.Ravager:IsCastable() and (v82 == "player") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (7 - 4)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (5 + 5)))) then
							if (((4730 - (467 + 370)) < (9152 - 4723)) and v23(v93.RavagerPlayer, not v99)) then
								return "ravager main 28";
							end
						end
						if ((v91.Ravager:IsCastable() and (v82 == "cursor") and v42 and ((v53 and v29) or not v53) and ((v91.Avatar:CooldownRemains() < (3 + 0)) or v13:BuffUp(v91.RecklessnessBuff) or (v96 < (34 - 24)))) or ((448 + 2419) < (4432 - 2527))) then
							if (v23(v93.RavagerCursor, not v99) or ((2316 - (150 + 370)) >= (5333 - (74 + 1208)))) then
								return "ravager main 28";
							end
						end
						if (((3981 - 2362) <= (17813 - 14057)) and v91.ChampionsSpear:IsCastable() and (v83 == "player") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (15 + 5)) or (v98 > (391 - (14 + 376))) or not v13:HasTier(53 - 22, 2 + 0))) then
							if (((531 + 73) == (577 + 27)) and v23(v93.ChampionsSpearPlayer, not v99)) then
								return "spear_of_bastion main 30";
							end
						end
						if ((v91.ChampionsSpear:IsCastable() and (v83 == "cursor") and v45 and ((v55 and v29) or not v55) and v13:BuffUp(v91.EnrageBuff) and ((v13:BuffUp(v91.FuriousBloodthirstBuff) and v91.TitansTorment:IsAvailable()) or not v91.TitansTorment:IsAvailable() or (v96 < (58 - 38)) or (v98 > (1 + 0)) or not v13:HasTier(109 - (23 + 55), 4 - 2))) or ((2993 + 1491) == (809 + 91))) then
							if (v23(v93.ChampionsSpearCursor, not v14:IsInRange(46 - 16)) or ((1403 + 3056) <= (2014 - (652 + 249)))) then
								return "spear_of_bastion main 31";
							end
						end
					end
					if (((9719 - 6087) > (5266 - (708 + 1160))) and v37 and v91.HeroicThrow:IsCastable() and not v14:IsInRange(67 - 42) and v13:CanAttack(v14)) then
						if (((7441 - 3359) <= (4944 - (10 + 17))) and v23(v91.HeroicThrow, not v14:IsSpellInRange(v91.HeroicThrow))) then
							return "heroic_throw main";
						end
					end
					if (((1086 + 3746) >= (3118 - (1400 + 332))) and v91.WreckingThrow:IsCastable() and v48 and v100() and v13:CanAttack(v14)) then
						if (((262 - 125) == (2045 - (242 + 1666))) and v23(v91.WreckingThrow, not v14:IsSpellInRange(v91.WreckingThrow))) then
							return "wrecking_throw main";
						end
					end
					if ((v28 and (v98 >= (1 + 1))) or ((576 + 994) >= (3692 + 640))) then
						v26 = v106();
						if (v26 or ((5004 - (850 + 90)) <= (3185 - 1366))) then
							return v26;
						end
					end
					v26 = v105();
					if (v26 or ((6376 - (360 + 1030)) < (1393 + 181))) then
						return v26;
					end
				end
				break;
			end
			if (((12492 - 8066) > (236 - 64)) and ((1661 - (909 + 752)) == v122)) then
				v26 = v101();
				if (((1809 - (109 + 1114)) > (833 - 378)) and v26) then
					return v26;
				end
				v122 = 1 + 0;
			end
		end
	end
	local function v108()
		local v123 = 242 - (6 + 236);
		while true do
			if (((521 + 305) == (665 + 161)) and (v123 == (6 - 3))) then
				v41 = EpicSettings.Settings['useRampage'];
				v44 = EpicSettings.Settings['useSlam'];
				v47 = EpicSettings.Settings['useWhirlwind'];
				v123 = 6 - 2;
			end
			if ((v123 == (1133 - (1076 + 57))) or ((661 + 3358) > (5130 - (579 + 110)))) then
				v31 = EpicSettings.Settings['useBattleShout'];
				v32 = EpicSettings.Settings['useBloodbath'];
				v33 = EpicSettings.Settings['useBloodthirst'];
				v123 = 1 + 0;
			end
			if (((1784 + 233) < (2262 + 1999)) and (v123 == (413 - (174 + 233)))) then
				v46 = EpicSettings.Settings['useThunderousRoar'];
				v51 = EpicSettings.Settings['avatarWithCD'];
				v52 = EpicSettings.Settings['odynFuryWithCD'];
				v123 = 19 - 12;
			end
			if (((8277 - 3561) > (36 + 44)) and (v123 == (1175 - (663 + 511)))) then
				v34 = EpicSettings.Settings['useCharge'];
				v35 = EpicSettings.Settings['useCrushingBlow'];
				v36 = EpicSettings.Settings['useExecute'];
				v123 = 2 + 0;
			end
			if ((v123 == (1 + 1)) or ((10811 - 7304) == (1982 + 1290))) then
				v37 = EpicSettings.Settings['useHeroicThrow'];
				v39 = EpicSettings.Settings['useOnslaught'];
				v40 = EpicSettings.Settings['useRagingBlow'];
				v123 = 6 - 3;
			end
			if (((19 - 11) == v123) or ((419 + 457) >= (5985 - 2910))) then
				v56 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((3102 + 1250) > (234 + 2320)) and (v123 == (726 - (478 + 244)))) then
				v48 = EpicSettings.Settings['useWreckingThrow'];
				v30 = EpicSettings.Settings['useAvatar'];
				v38 = EpicSettings.Settings['useOdynsFury'];
				v123 = 522 - (440 + 77);
			end
			if (((4 + 3) == v123) or ((16125 - 11719) < (5599 - (655 + 901)))) then
				v53 = EpicSettings.Settings['ravagerWithCD'];
				v54 = EpicSettings.Settings['recklessnessWithCD'];
				v55 = EpicSettings.Settings['championsSpearWithCD'];
				v123 = 2 + 6;
			end
			if ((v123 == (4 + 1)) or ((1276 + 613) >= (13628 - 10245))) then
				v42 = EpicSettings.Settings['useRavager'];
				v43 = EpicSettings.Settings['useRecklessness'];
				v45 = EpicSettings.Settings['useChampionsSpear'];
				v123 = 1451 - (695 + 750);
			end
		end
	end
	local function v109()
		local v124 = 0 - 0;
		while true do
			if (((2919 - 1027) <= (10995 - 8261)) and (v124 == (352 - (285 + 66)))) then
				v63 = EpicSettings.Settings['useEnragedRegeneration'];
				v64 = EpicSettings.Settings['useIgnorePain'];
				v65 = EpicSettings.Settings['useRallyingCry'];
				v66 = EpicSettings.Settings['useIntervene'];
				v124 = 4 - 2;
			end
			if (((3233 - (682 + 628)) < (358 + 1860)) and (v124 == (304 - (176 + 123)))) then
				v83 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((909 + 1264) > (275 + 104)) and (v124 == (273 - (239 + 30)))) then
				v77 = EpicSettings.Settings['defensiveStanceHP'] or (0 + 0);
				v80 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v81 = EpicSettings.Settings['victoryRushHP'] or (0 - 0);
				v82 = EpicSettings.Settings['ravagerSetting'] or "player";
				v124 = 15 - 10;
			end
			if ((v124 == (315 - (306 + 9))) or ((9041 - 6450) == (593 + 2816))) then
				v59 = EpicSettings.Settings['usePummel'];
				v60 = EpicSettings.Settings['useStormBolt'];
				v61 = EpicSettings.Settings['useIntimidatingShout'];
				v62 = EpicSettings.Settings['useBitterImmunity'];
				v124 = 1 + 0;
			end
			if (((2173 + 2341) > (9505 - 6181)) and (v124 == (1378 - (1140 + 235)))) then
				v73 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v74 = EpicSettings.Settings['rallyingCryHP'] or (0 + 0);
				v75 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v76 = EpicSettings.Settings['interveneHP'] or (52 - (33 + 19));
				v124 = 2 + 2;
			end
			if ((v124 == (5 - 3)) or ((92 + 116) >= (9467 - 4639))) then
				v67 = EpicSettings.Settings['useDefensiveStance'];
				v70 = EpicSettings.Settings['useVictoryRush'];
				v71 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v72 = EpicSettings.Settings['enragedRegenerationHP'] or (689 - (586 + 103));
				v124 = 1 + 2;
			end
		end
	end
	local function v110()
		v89 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v86 = EpicSettings.Settings['InterruptWithStun'];
		v87 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v88 = EpicSettings.Settings['InterruptThreshold'];
		v50 = EpicSettings.Settings['useTrinkets'];
		v49 = EpicSettings.Settings['useRacials'];
		v58 = EpicSettings.Settings['trinketsWithCD'];
		v57 = EpicSettings.Settings['racialsWithCD'];
		v68 = EpicSettings.Settings['useHealthstone'];
		v69 = EpicSettings.Settings['useHealingPotion'];
		v78 = EpicSettings.Settings['healthstoneHP'] or (1488 - (1309 + 179));
		v79 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v85 = EpicSettings.Settings['HealingPotionName'] or "";
		v84 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v111()
		v109();
		v108();
		v110();
		v27 = EpicSettings.Toggles['ooc'];
		v28 = EpicSettings.Toggles['aoe'];
		v29 = EpicSettings.Toggles['cds'];
		if (v13:IsDeadOrGhost() or ((689 + 894) > (9579 - 6012))) then
			return v26;
		end
		if (v28 or ((992 + 321) == (1686 - 892))) then
			local v140 = 0 - 0;
			while true do
				if (((3783 - (295 + 314)) > (7127 - 4225)) and (v140 == (1962 - (1300 + 662)))) then
					v97 = v13:GetEnemiesInMeleeRange(24 - 16);
					v98 = #v97;
					break;
				end
			end
		else
			v98 = 1756 - (1178 + 577);
		end
		v99 = v14:IsInMeleeRange(3 + 2);
		if (((12179 - 8059) <= (5665 - (851 + 554))) and (v90.TargetIsValid() or v13:AffectingCombat())) then
			v95 = v9.BossFightRemains(nil, true);
			v96 = v95;
			if ((v96 == (9826 + 1285)) or ((2448 - 1565) > (10376 - 5598))) then
				v96 = v9.FightRemains(v97, false);
			end
		end
		if (not v13:IsChanneling() or ((3922 - (115 + 187)) >= (3746 + 1145))) then
			if (((4031 + 227) > (3692 - 2755)) and v13:AffectingCombat()) then
				v26 = v107();
				if (v26 or ((6030 - (160 + 1001)) < (793 + 113))) then
					return v26;
				end
			else
				v26 = v104();
				if (v26 or ((846 + 379) > (8655 - 4427))) then
					return v26;
				end
			end
		end
	end
	local function v112()
		v19.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(430 - (237 + 121), v111, v112);
end;
return v0["Epix_Warrior_Fury.lua"]();

