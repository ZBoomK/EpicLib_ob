local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((142 + 1775) > (61 + 1227)) and (v5 == (1597 - (978 + 619)))) then
			v6 = v0[v4];
			if (((1848 - (243 + 1111)) <= (3062 + 290)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 159 - (91 + 67);
		end
		if ((v5 == (2 - 1)) or ((914 + 2746) <= (2588 - (423 + 100)))) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Fury.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.TargetTarget;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
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
	local v90;
	local v91;
	local v92 = v20.Commons.Everyone;
	local v93 = v18.Warrior.Fury;
	local v94 = v19.Warrior.Fury;
	local v95 = v23.Warrior.Fury;
	local v96 = {};
	local v97 = 78 + 11033;
	local v98 = 30764 - 19653;
	v10:RegisterForEvent(function()
		v97 = 5792 + 5319;
		v98 = 11882 - (326 + 445);
	end, "PLAYER_REGEN_ENABLED");
	local v99, v100;
	local v101;
	local function v102()
		local v115 = 0 - 0;
		local v116;
		while true do
			if ((v115 == (0 - 0)) or ((9593 - 5483) > (5087 - (530 + 181)))) then
				v116 = UnitGetTotalAbsorbs(v15:ID());
				if ((v116 > (881 - (614 + 267))) or ((1662 - (19 + 13)) > (6832 - 2634))) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		if (((2456 - 1402) == (3010 - 1956)) and v93.BitterImmunity:IsReady() and v64 and (v14:HealthPercentage() <= v73)) then
			if (v24(v93.BitterImmunity) or ((176 + 500) >= (2887 - 1245))) then
				return "bitter_immunity defensive";
			end
		end
		if (((8577 - 4441) > (4209 - (1293 + 519))) and v93.EnragedRegeneration:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
			if (v24(v93.EnragedRegeneration) or ((8842 - 4508) == (11083 - 6838))) then
				return "enraged_regeneration defensive";
			end
		end
		if ((v93.IgnorePain:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or ((8176 - 3900) <= (13069 - 10038))) then
			if (v24(v93.IgnorePain, nil, nil, true) or ((11264 - 6482) <= (636 + 563))) then
				return "ignore_pain defensive";
			end
		end
		if ((v93.RallyingCry:IsCastable() and v67 and v14:BuffDown(v93.AspectsFavorBuff) and v14:BuffDown(v93.RallyingCry) and (((v14:HealthPercentage() <= v76) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v76, v77, v93.Intervene))) or ((993 + 3871) < (4418 - 2516))) then
			if (((1119 + 3720) >= (1230 + 2470)) and v24(v93.RallyingCry)) then
				return "rallying_cry defensive";
			end
		end
		if ((v93.Intervene:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:Name() ~= v14:Name())) or ((672 + 403) > (3014 - (709 + 387)))) then
			if (((2254 - (673 + 1185)) <= (11031 - 7227)) and v24(v95.InterveneFocus)) then
				return "intervene defensive";
			end
		end
		if ((v93.DefensiveStance:IsCastable() and v69 and (v14:HealthPercentage() <= v79) and v14:BuffDown(v93.DefensiveStance, true)) or ((13387 - 9218) == (3597 - 1410))) then
			if (((1006 + 400) == (1051 + 355)) and v24(v93.DefensiveStance)) then
				return "defensive_stance defensive";
			end
		end
		if (((2066 - 535) < (1049 + 3222)) and v93.BerserkerStance:IsCastable() and v69 and (v14:HealthPercentage() > v82) and v14:BuffDown(v93.BerserkerStance, true)) then
			if (((1266 - 631) == (1246 - 611)) and v24(v93.BerserkerStance)) then
				return "berserker_stance after defensive stance defensive";
			end
		end
		if (((5253 - (446 + 1434)) <= (4839 - (1040 + 243))) and v94.Healthstone:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
			if (v24(v95.Healthstone) or ((9822 - 6531) < (5127 - (559 + 1288)))) then
				return "healthstone defensive 3";
			end
		end
		if (((6317 - (609 + 1322)) >= (1327 - (13 + 441))) and v71 and (v14:HealthPercentage() <= v81)) then
			local v137 = 0 - 0;
			while true do
				if (((2412 - 1491) <= (5488 - 4386)) and (v137 == (0 + 0))) then
					if (((17091 - 12385) >= (343 + 620)) and (v87 == "Refreshing Healing Potion")) then
						if (v94.RefreshingHealingPotion:IsReady() or ((421 + 539) <= (2599 - 1723))) then
							if (v24(v95.RefreshingHealingPotion) or ((1131 + 935) == (1713 - 781))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((3190 + 1635) < (2694 + 2149)) and (v87 == "Dreamwalker's Healing Potion")) then
						if (v94.DreamwalkersHealingPotion:IsReady() or ((2786 + 1091) >= (3810 + 727))) then
							if (v24(v95.RefreshingHealingPotion) or ((4222 + 93) < (2159 - (153 + 280)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v104()
		local v117 = 0 - 0;
		while true do
			if ((v117 == (1 + 0)) or ((1453 + 2226) < (328 + 297))) then
				v27 = v92.HandleBottomTrinket(v96, v30, 37 + 3, nil);
				if (v27 or ((3352 + 1273) < (961 - 329))) then
					return v27;
				end
				break;
			end
			if ((v117 == (0 + 0)) or ((750 - (89 + 578)) > (1272 + 508))) then
				v27 = v92.HandleTopTrinket(v96, v30, 83 - 43, nil);
				if (((1595 - (572 + 477)) <= (146 + 931)) and v27) then
					return v27;
				end
				v117 = 1 + 0;
			end
		end
	end
	local function v105()
		local v118 = 0 + 0;
		while true do
			if ((v118 == (86 - (84 + 2))) or ((1641 - 645) > (3099 + 1202))) then
				if (((4912 - (497 + 345)) > (18 + 669)) and v32 and ((v53 and v30) or not v53) and (v91 < v98) and v93.Avatar:IsCastable() and not v93.TitansTorment:IsAvailable()) then
					if (v24(v93.Avatar, not v101) or ((111 + 545) >= (4663 - (605 + 728)))) then
						return "avatar precombat 6";
					end
				end
				if ((v45 and ((v56 and v30) or not v56) and (v91 < v98) and v93.Recklessness:IsCastable() and not v93.RecklessAbandon:IsAvailable()) or ((1778 + 714) <= (744 - 409))) then
					if (((199 + 4123) >= (9472 - 6910)) and v24(v93.Recklessness, not v101)) then
						return "recklessness precombat 8";
					end
				end
				v118 = 1 + 0;
			end
			if ((v118 == (2 - 1)) or ((2747 + 890) >= (4259 - (457 + 32)))) then
				if ((v93.Bloodthirst:IsCastable() and v35 and v101) or ((1010 + 1369) > (5980 - (832 + 570)))) then
					if (v24(v93.Bloodthirst, not v101) or ((456 + 27) > (194 + 549))) then
						return "bloodthirst precombat 10";
					end
				end
				if (((8684 - 6230) > (279 + 299)) and v36 and v93.Charge:IsReady() and not v101) then
					if (((1726 - (588 + 208)) < (12015 - 7557)) and v24(v93.Charge, not v15:IsSpellInRange(v93.Charge))) then
						return "charge precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v106()
		if (((2462 - (884 + 916)) <= (2034 - 1062)) and not v14:AffectingCombat()) then
			local v138 = 0 + 0;
			while true do
				if (((5023 - (232 + 421)) == (6259 - (1569 + 320))) and (v138 == (0 + 0))) then
					if ((v93.BerserkerStance:IsCastable() and v14:BuffDown(v93.BerserkerStance, true)) or ((905 + 3857) <= (2901 - 2040))) then
						if (v24(v93.BerserkerStance) or ((2017 - (316 + 289)) == (11161 - 6897))) then
							return "berserker_stance";
						end
					end
					if ((v93.BattleShout:IsCastable() and v33 and (v14:BuffDown(v93.BattleShoutBuff, true) or v92.GroupBuffMissing(v93.BattleShoutBuff))) or ((147 + 3021) < (3606 - (666 + 787)))) then
						if (v24(v93.BattleShout) or ((5401 - (360 + 65)) < (1245 + 87))) then
							return "battle_shout precombat";
						end
					end
					break;
				end
			end
		end
		if (((4882 - (79 + 175)) == (7297 - 2669)) and v92.TargetIsValid() and v28) then
			if (not v14:AffectingCombat() or ((43 + 11) == (1210 - 815))) then
				v27 = v105();
				if (((157 - 75) == (981 - (503 + 396))) and v27) then
					return v27;
				end
			end
		end
	end
	local function v107()
		local v119 = 181 - (92 + 89);
		local v120;
		while true do
			if ((v119 == (1 - 0)) or ((298 + 283) < (167 + 115))) then
				if ((v93.Bloodthirst:IsCastable() and v35 and ((v14:HasTier(117 - 87, 1 + 3) and (v120 >= (216 - 121))) or (not v93.RecklessAbandon:IsAvailable() and v14:BuffUp(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.EnrageBuff) and (v15:DebuffDown(v93.GushingWoundDebuff) or v14:BuffUp(v93.ChampionsMightBuff))))) or ((4022 + 587) < (1192 + 1303))) then
					if (((3508 - 2356) == (144 + 1008)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 12";
					end
				end
				if (((2891 - 995) <= (4666 - (485 + 759))) and v93.Bloodbath:IsCastable() and v34 and v14:HasTier(71 - 40, 1191 - (442 + 747))) then
					if (v24(v93.Bloodbath, not v101) or ((2125 - (832 + 303)) > (2566 - (88 + 858)))) then
						return "bloodbath single_target 14";
					end
				end
				if ((v48 and ((v58 and v30) or not v58) and (v91 < v98) and v93.ThunderousRoar:IsCastable() and v14:BuffUp(v93.EnrageBuff)) or ((268 + 609) > (3886 + 809))) then
					if (((111 + 2580) >= (2640 - (766 + 23))) and v24(v93.ThunderousRoar, not v15:IsInMeleeRange(39 - 31))) then
						return "thunderous_roar single_target 16";
					end
				end
				if ((v93.Onslaught:IsReady() and v41 and (v14:BuffUp(v93.EnrageBuff) or v93.Tenderize:IsAvailable())) or ((4081 - 1096) >= (12793 - 7937))) then
					if (((14512 - 10236) >= (2268 - (1036 + 37))) and v24(v93.Onslaught, not v101)) then
						return "onslaught single_target 18";
					end
				end
				if (((2292 + 940) <= (9133 - 4443)) and v93.CrushingBlow:IsCastable() and v37 and v93.WrathandFury:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (v24(v93.CrushingBlow, not v101) or ((705 + 191) >= (4626 - (641 + 839)))) then
						return "crushing_blow single_target 20";
					end
				end
				if (((3974 - (910 + 3)) >= (7540 - 4582)) and v93.Execute:IsReady() and v38 and ((v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.AshenJuggernautBuff)) or ((v14:BuffRemains(v93.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > (1719 - (1466 + 218))) and v93.Massacre:IsAvailable()) or (v15:HealthPercentage() > (10 + 10)))))) then
					if (((4335 - (556 + 592)) >= (230 + 414)) and v24(v93.Execute, not v101)) then
						return "execute single_target 22";
					end
				end
				v119 = 810 - (329 + 479);
			end
			if (((1498 - (174 + 680)) <= (2418 - 1714)) and (v119 == (5 - 2))) then
				if (((684 + 274) > (1686 - (396 + 343))) and v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff))) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (((398 + 4094) >= (4131 - (29 + 1448))) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 34";
					end
				end
				if (((4831 - (135 + 1254)) >= (5662 - 4159)) and v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (4 - 3)) and v93.WrathandFury:IsAvailable()) then
					if (v24(v93.RagingBlow, not v101) or ((2113 + 1057) <= (2991 - (389 + 1138)))) then
						return "raging_blow single_target 36";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (575 - (102 + 472))) and v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((4527 + 270) == (2434 + 1954))) then
					if (((514 + 37) <= (2226 - (320 + 1225))) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 38";
					end
				end
				if (((5833 - 2556) > (250 + 157)) and v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) then
					if (((6159 - (157 + 1307)) >= (3274 - (821 + 1038))) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 40";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((8013 - 4801) <= (104 + 840))) then
					if (v24(v93.CrushingBlow, not v101) or ((5498 - 2402) <= (669 + 1129))) then
						return "crushing_blow single_target 42";
					end
				end
				if (((8766 - 5229) == (4563 - (834 + 192))) and v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (((244 + 3593) >= (403 + 1167)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 44";
					end
				end
				v119 = 1 + 3;
			end
			if (((2 - 0) == v119) or ((3254 - (300 + 4)) == (1019 + 2793))) then
				if (((12363 - 7640) >= (2680 - (112 + 250))) and v93.Rampage:IsReady() and v43 and v93.RecklessAbandon:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (34 + 51)))) then
					if (v24(v93.Rampage, not v101) or ((5077 - 3050) > (1634 + 1218))) then
						return "rampage single_target 24";
					end
				end
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or ((588 + 548) > (3229 + 1088))) then
					if (((2355 + 2393) == (3528 + 1220)) and v24(v93.Execute, not v101)) then
						return "execute single_target 26";
					end
				end
				if (((5150 - (1001 + 413)) <= (10570 - 5830)) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable()) then
					if (v24(v93.Rampage, not v101) or ((4272 - (244 + 638)) <= (3753 - (627 + 66)))) then
						return "rampage single_target 28";
					end
				end
				if ((v93.Execute:IsReady() and v38) or ((2976 - 1977) > (3295 - (512 + 90)))) then
					if (((2369 - (1665 + 241)) < (1318 - (373 + 344))) and v24(v93.Execute, not v101)) then
						return "execute single_target 29";
					end
				end
				if ((v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) or ((985 + 1198) < (182 + 505))) then
					if (((11998 - 7449) == (7697 - 3148)) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 30";
					end
				end
				if (((5771 - (35 + 1064)) == (3400 + 1272)) and v93.Rampage:IsReady() and v43 and (v15:HealthPercentage() < (74 - 39)) and v93.Massacre:IsAvailable()) then
					if (v24(v93.Rampage, not v101) or ((15 + 3653) < (1631 - (298 + 938)))) then
						return "rampage single_target 32";
					end
				end
				v119 = 1262 - (233 + 1026);
			end
			if ((v119 == (1666 - (636 + 1030))) or ((2130 + 2036) == (445 + 10))) then
				if ((v93.Whirlwind:IsCastable() and v49 and (v100 > (1 + 0)) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or ((301 + 4148) == (2884 - (55 + 166)))) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(2 + 6)) or ((431 + 3846) < (11414 - 8425))) then
						return "whirlwind single_target 2";
					end
				end
				if ((v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or ((1167 - (36 + 261)) >= (7255 - 3106))) then
					if (((3580 - (34 + 1334)) < (1224 + 1959)) and v24(v93.Execute, not v101)) then
						return "execute single_target 4";
					end
				end
				if (((3610 + 1036) > (4275 - (1035 + 248))) and v40 and ((v54 and v30) or not v54) and v93.OdynsFury:IsCastable() and (v91 < v98) and v14:BuffUp(v93.EnrageBuff) and ((v93.DancingBlades:IsAvailable() and (v14:BuffRemains(v93.DancingBladesBuff) < (26 - (20 + 1)))) or not v93.DancingBlades:IsAvailable())) then
					if (((748 + 686) < (3425 - (134 + 185))) and v24(v93.OdynsFury, not v15:IsInMeleeRange(1141 - (549 + 584)))) then
						return "odyns_fury single_target 6";
					end
				end
				if (((1471 - (314 + 371)) < (10377 - 7354)) and v93.Rampage:IsReady() and v43 and v93.AngerManagement:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > (1053 - (478 + 490))))) then
					if (v24(v93.Rampage, not v101) or ((1294 + 1148) < (1246 - (786 + 386)))) then
						return "rampage single_target 8";
					end
				end
				v120 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (64 - 44)) + (v14:BuffStack(v93.MercilessAssaultBuff) * (1389 - (1055 + 324))) + (v14:BuffStack(v93.BloodcrazeBuff) * (1355 - (1093 + 247)));
				if (((4030 + 505) == (477 + 4058)) and v93.Bloodbath:IsCastable() and v34 and v14:HasTier(119 - 89, 13 - 9) and (v120 >= (270 - 175))) then
					if (v24(v93.Bloodbath, not v101) or ((7561 - 4552) <= (749 + 1356))) then
						return "bloodbath single_target 10";
					end
				end
				v119 = 3 - 2;
			end
			if (((6307 - 4477) < (2767 + 902)) and (v119 == (12 - 7))) then
				if ((v93.Bloodthirst:IsCastable() and v35) or ((2118 - (364 + 324)) >= (9901 - 6289))) then
					if (((6437 - 3754) >= (816 + 1644)) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 56";
					end
				end
				if ((v29 and v93.Whirlwind:IsCastable() and v49) or ((7548 - 5744) >= (5245 - 1970))) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(24 - 16)) or ((2685 - (1249 + 19)) > (3276 + 353))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if (((18664 - 13869) > (1488 - (686 + 400))) and (v119 == (4 + 0))) then
				if (((5042 - (73 + 156)) > (17 + 3548)) and v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (812 - (721 + 90)))) then
					if (((44 + 3868) == (12701 - 8789)) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow single_target 46";
					end
				end
				if (((3291 - (224 + 246)) <= (7814 - 2990)) and v93.Rampage:IsReady() and v43) then
					if (((3199 - 1461) <= (399 + 1796)) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 47";
					end
				end
				if (((1 + 40) <= (2217 + 801)) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
					if (((4264 - 2119) <= (13657 - 9553)) and v24(v93.Slam, not v101)) then
						return "slam single_target 48";
					end
				end
				if (((3202 - (203 + 310)) < (6838 - (1238 + 755))) and v93.Bloodbath:IsCastable() and v34) then
					if (v24(v93.Bloodbath, not v101) or ((163 + 2159) > (4156 - (709 + 825)))) then
						return "bloodbath single_target 50";
					end
				end
				if ((v93.RagingBlow:IsCastable() and v42) or ((8354 - 3820) == (3032 - 950))) then
					if (v24(v93.RagingBlow, not v101) or ((2435 - (196 + 668)) > (7371 - 5504))) then
						return "raging_blow single_target 52";
					end
				end
				if ((v93.CrushingBlow:IsCastable() and v37 and v14:BuffDown(v93.FuriousBloodthirstBuff)) or ((5497 - 2843) >= (3829 - (171 + 662)))) then
					if (((4071 - (4 + 89)) > (7374 - 5270)) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 54";
					end
				end
				v119 = 2 + 3;
			end
		end
	end
	local function v108()
		if (((13154 - 10159) > (605 + 936)) and v93.Recklessness:IsCastable() and ((v56 and v30) or not v56) and v45 and (v91 < v98) and ((v100 > (1487 - (35 + 1451))) or (v98 < (1465 - (28 + 1425))))) then
			if (((5242 - (941 + 1052)) > (914 + 39)) and v24(v93.Recklessness, not v101)) then
				return "recklessness multi_target 2";
			end
		end
		if ((v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and (v100 > (1515 - (822 + 692))) and v93.TitanicRage:IsAvailable() and (v14:BuffDown(v93.MeatCleaverBuff) or v14:BuffUp(v93.AvatarBuff) or v14:BuffUp(v93.RecklessnessBuff))) or ((4671 - 1398) > (2154 + 2419))) then
			if (v24(v93.OdynsFury, not v15:IsInMeleeRange(305 - (45 + 252))) or ((3118 + 33) < (442 + 842))) then
				return "odyns_fury multi_target 4";
			end
		end
		if ((v93.Whirlwind:IsCastable() and v49 and (v100 > (2 - 1)) and v93.ImprovedWhilwind:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or ((2283 - (114 + 319)) == (2194 - 665))) then
			if (((1051 - 230) < (1354 + 769)) and v24(v93.Whirlwind, not v15:IsInMeleeRange(11 - 3))) then
				return "whirlwind multi_target 6";
			end
		end
		if (((1889 - 987) < (4288 - (556 + 1407))) and v93.Execute:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) then
			if (((2064 - (741 + 465)) <= (3427 - (170 + 295))) and v24(v93.Execute, not v101)) then
				return "execute multi_target 8";
			end
		end
		if ((v93.ThunderousRoar:IsCastable() and ((v58 and v30) or not v58) and v48 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or ((2080 + 1866) < (1184 + 104))) then
			if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(19 - 11)) or ((2688 + 554) == (364 + 203))) then
				return "thunderous_roar multi_target 10";
			end
		end
		if ((v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and (v100 > (1 + 0)) and v14:BuffUp(v93.EnrageBuff)) or ((2077 - (957 + 273)) >= (338 + 925))) then
			if (v24(v93.OdynsFury, not v15:IsInMeleeRange(4 + 4)) or ((8584 - 6331) == (4877 - 3026))) then
				return "odyns_fury multi_target 12";
			end
		end
		local v121 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * (61 - 41)) + (v14:BuffStack(v93.MercilessAssaultBuff) * (49 - 39)) + (v14:BuffStack(v93.BloodcrazeBuff) * (1795 - (389 + 1391)));
		if ((v93.Bloodbath:IsCastable() and v34 and v14:HasTier(19 + 11, 1 + 3) and (v121 >= (216 - 121))) or ((3038 - (783 + 168)) > (7960 - 5588))) then
			if (v24(v93.Bloodbath, not v101) or ((4373 + 72) < (4460 - (309 + 2)))) then
				return "bloodbath multi_target 14";
			end
		end
		if ((v93.Bloodthirst:IsCastable() and v35 and ((v14:HasTier(92 - 62, 1216 - (1090 + 122)) and (v121 >= (31 + 64))) or (not v93.RecklessAbandon:IsAvailable() and v14:BuffUp(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.EnrageBuff)))) or ((6105 - 4287) == (59 + 26))) then
			if (((1748 - (628 + 490)) < (382 + 1745)) and v24(v93.Bloodthirst, not v101)) then
				return "bloodthirst multi_target 16";
			end
		end
		if ((v93.CrushingBlow:IsCastable() and v93.WrathandFury:IsAvailable() and v37 and v14:BuffUp(v93.EnrageBuff)) or ((4798 - 2860) == (11488 - 8974))) then
			if (((5029 - (431 + 343)) >= (111 - 56)) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow multi_target 14";
			end
		end
		if (((8675 - 5676) > (914 + 242)) and v93.Execute:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) then
			if (((301 + 2049) > (2850 - (556 + 1139))) and v24(v93.Execute, not v101)) then
				return "execute multi_target 16";
			end
		end
		if (((4044 - (6 + 9)) <= (889 + 3964)) and v93.OdynsFury:IsCastable() and ((v54 and v30) or not v54) and v40 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) then
			if (v24(v93.OdynsFury, not v15:IsInMeleeRange(5 + 3)) or ((685 - (28 + 141)) > (1331 + 2103))) then
				return "odyns_fury multi_target 18";
			end
		end
		if (((4994 - 948) >= (2149 + 884)) and v93.Rampage:IsReady() and v43 and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or ((v14:Rage() > (1427 - (486 + 831))) and v93.OverwhelmingRage:IsAvailable()) or ((v14:Rage() > (208 - 128)) and not v93.OverwhelmingRage:IsAvailable()))) then
			if (v24(v93.Rampage, not v101) or ((9572 - 6853) <= (274 + 1173))) then
				return "rampage multi_target 20";
			end
		end
		if ((v93.Execute:IsReady() and v38) or ((13071 - 8937) < (5189 - (668 + 595)))) then
			if (v24(v93.Execute, not v101) or ((148 + 16) >= (562 + 2223))) then
				return "execute multi_target 22";
			end
		end
		if ((v93.Bloodbath:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable() and not v93.WrathandFury:IsAvailable()) or ((1431 - 906) == (2399 - (23 + 267)))) then
			if (((1977 - (1129 + 815)) == (420 - (371 + 16))) and v24(v93.Bloodbath, not v101)) then
				return "bloodbath multi_target 24";
			end
		end
		if (((4804 - (1326 + 424)) <= (7604 - 3589)) and v93.Bloodthirst:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93.Annihilator:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff)))) then
			if (((6837 - 4966) < (3500 - (88 + 30))) and v24(v93.Bloodthirst, not v101)) then
				return "bloodthirst multi_target 26";
			end
		end
		if (((2064 - (720 + 51)) <= (4818 - 2652)) and v93.Onslaught:IsReady() and v41 and ((not v93.Annihilator:IsAvailable() and v14:BuffUp(v93.EnrageBuff)) or v93.Tenderize:IsAvailable())) then
			if (v24(v93.Onslaught, not v101) or ((4355 - (421 + 1355)) < (202 - 79))) then
				return "onslaught multi_target 28";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0)) and v93.WrathandFury:IsAvailable()) or ((1929 - (286 + 797)) >= (8656 - 6288))) then
			if (v24(v93.RagingBlow, not v101) or ((6644 - 2632) <= (3797 - (397 + 42)))) then
				return "raging_blow multi_target 30";
			end
		end
		if (((467 + 1027) <= (3805 - (24 + 776))) and v93.CrushingBlow:IsCastable() and v37 and (v93.CrushingBlow:Charges() > (1 - 0)) and v93.WrathandFury:IsAvailable()) then
			if (v24(v93.CrushingBlow, not v101) or ((3896 - (222 + 563)) == (4701 - 2567))) then
				return "crushing_blow multi_target 32";
			end
		end
		if (((1696 + 659) == (2545 - (23 + 167))) and v93.Bloodbath:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93.WrathandFury:IsAvailable())) then
			if (v24(v93.Bloodbath, not v101) or ((2386 - (690 + 1108)) <= (156 + 276))) then
				return "bloodbath multi_target 34";
			end
		end
		if (((3957 + 840) >= (4743 - (40 + 808))) and v93.CrushingBlow:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93.RecklessAbandon:IsAvailable()) then
			if (((589 + 2988) == (13678 - 10101)) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow multi_target 36";
			end
		end
		if (((3627 + 167) > (1954 + 1739)) and v93.Bloodthirst:IsCastable() and v35 and not v93.WrathandFury:IsAvailable()) then
			if (v24(v93.Bloodthirst, not v101) or ((700 + 575) == (4671 - (47 + 524)))) then
				return "bloodthirst multi_target 38";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42 and (v93.RagingBlow:Charges() > (1 + 0))) or ((4349 - 2758) >= (5353 - 1773))) then
			if (((2241 - 1258) <= (3534 - (1165 + 561))) and v24(v93.RagingBlow, not v101)) then
				return "raging_blow multi_target 40";
			end
		end
		if ((v93.Rampage:IsReady() and v43) or ((64 + 2086) <= (3707 - 2510))) then
			if (((1439 + 2330) >= (1652 - (341 + 138))) and v24(v93.Rampage, not v101)) then
				return "rampage multi_target 42";
			end
		end
		if (((401 + 1084) == (3064 - 1579)) and v93.Slam:IsReady() and v46 and (v93.Annihilator:IsAvailable())) then
			if (v24(v93.Slam, not v101) or ((3641 - (89 + 237)) <= (8949 - 6167))) then
				return "slam multi_target 44";
			end
		end
		if ((v93.Bloodbath:IsCastable() and v34) or ((1844 - 968) >= (3845 - (581 + 300)))) then
			if (v24(v93.Bloodbath, not v101) or ((3452 - (855 + 365)) > (5930 - 3433))) then
				return "bloodbath multi_target 46";
			end
		end
		if ((v93.RagingBlow:IsCastable() and v42) or ((689 + 1421) <= (1567 - (1030 + 205)))) then
			if (((3461 + 225) > (2951 + 221)) and v24(v93.RagingBlow, not v101)) then
				return "raging_blow multi_target 48";
			end
		end
		if ((v93.CrushingBlow:IsCastable() and v37) or ((4760 - (156 + 130)) < (1863 - 1043))) then
			if (((7211 - 2932) >= (5902 - 3020)) and v24(v93.CrushingBlow, not v101)) then
				return "crushing_blow multi_target 50";
			end
		end
		if ((v93.Whirlwind:IsCastable() and v49) or ((535 + 1494) >= (2054 + 1467))) then
			if (v24(v93.Whirlwind, not v15:IsInMeleeRange(77 - (10 + 59))) or ((577 + 1460) >= (22860 - 18218))) then
				return "whirlwind multi_target 52";
			end
		end
	end
	local function v109()
		local v122 = 1163 - (671 + 492);
		while true do
			if (((1370 + 350) < (5673 - (369 + 846))) and (v122 == (1 + 0))) then
				if (v86 or ((373 + 63) > (4966 - (1036 + 909)))) then
					local v178 = 0 + 0;
					while true do
						if (((1196 - 483) <= (1050 - (11 + 192))) and (v178 == (0 + 0))) then
							v27 = v92.HandleIncorporeal(v93.StormBolt, v95.StormBoltMouseover, 195 - (135 + 40), true);
							if (((5218 - 3064) <= (2430 + 1601)) and v27) then
								return v27;
							end
							v178 = 2 - 1;
						end
						if (((6918 - 2303) == (4791 - (50 + 126))) and (v178 == (2 - 1))) then
							v27 = v92.HandleIncorporeal(v93.IntimidatingShout, v95.IntimidatingShoutMouseover, 2 + 6, true);
							if (v27 or ((5203 - (1233 + 180)) == (1469 - (522 + 447)))) then
								return v27;
							end
							break;
						end
					end
				end
				if (((1510 - (107 + 1314)) < (103 + 118)) and v92.TargetIsValid()) then
					local v179 = 0 - 0;
					local v180;
					while true do
						if (((873 + 1181) >= (2821 - 1400)) and (v179 == (11 - 8))) then
							v27 = v107();
							if (((2602 - (716 + 1194)) < (53 + 3005)) and v27) then
								return v27;
							end
							break;
						end
						if ((v179 == (1 + 1)) or ((3757 - (74 + 429)) == (3192 - 1537))) then
							if ((v39 and v93.HeroicThrow:IsCastable() and not v15:IsInRange(13 + 12) and v14:CanAttack(v15)) or ((2966 - 1670) == (3474 + 1436))) then
								if (((10383 - 7015) == (8327 - 4959)) and v24(v93.HeroicThrow, not v15:IsSpellInRange(v93.HeroicThrow))) then
									return "heroic_throw main";
								end
							end
							if (((3076 - (279 + 154)) < (4593 - (454 + 324))) and v93.WreckingThrow:IsCastable() and v50 and v102() and v14:CanAttack(v15)) then
								if (((1506 + 407) > (510 - (12 + 5))) and v24(v93.WreckingThrow, not v15:IsSpellInRange(v93.WreckingThrow))) then
									return "wrecking_throw main";
								end
							end
							if (((2564 + 2191) > (8734 - 5306)) and v29 and (v100 >= (1 + 1))) then
								local v184 = 1093 - (277 + 816);
								while true do
									if (((5901 - 4520) <= (3552 - (1058 + 125))) and (v184 == (0 + 0))) then
										v27 = v108();
										if (v27 or ((5818 - (815 + 160)) == (17522 - 13438))) then
											return v27;
										end
										break;
									end
								end
							end
							v179 = 7 - 4;
						end
						if (((1114 + 3555) > (1061 - 698)) and (v179 == (1899 - (41 + 1857)))) then
							if ((v91 < v98) or ((3770 - (1222 + 671)) >= (8110 - 4972))) then
								local v185 = 0 - 0;
								while true do
									if (((5924 - (229 + 953)) >= (5400 - (1111 + 663))) and (v185 == (1579 - (874 + 705)))) then
										if ((v52 and ((v30 and v60) or not v60)) or ((636 + 3904) == (625 + 291))) then
											local v187 = 0 - 0;
											while true do
												if ((v187 == (0 + 0)) or ((1835 - (642 + 37)) > (991 + 3354))) then
													v27 = v104();
													if (((358 + 1879) < (10667 - 6418)) and v27) then
														return v27;
													end
													break;
												end
											end
										end
										if ((v30 and v94.FyralathTheDreamrender:IsEquippedAndReady() and v31) or ((3137 - (233 + 221)) < (53 - 30))) then
											if (((614 + 83) <= (2367 - (718 + 823))) and v24(v95.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((696 + 409) <= (1981 - (266 + 539))) and (v91 < v98) and v51 and ((v59 and v30) or not v59)) then
								if (((9566 - 6187) <= (5037 - (636 + 589))) and v93.BloodFury:IsCastable()) then
									if (v24(v93.BloodFury, not v101) or ((1870 - 1082) >= (3332 - 1716))) then
										return "blood_fury main 12";
									end
								end
								if (((1470 + 384) <= (1228 + 2151)) and v93.Berserking:IsCastable() and v14:BuffUp(v93.RecklessnessBuff)) then
									if (((5564 - (657 + 358)) == (12044 - 7495)) and v24(v93.Berserking, not v101)) then
										return "berserking main 14";
									end
								end
								if ((v93.LightsJudgment:IsCastable() and v14:BuffDown(v93.RecklessnessBuff)) or ((6884 - 3862) >= (4211 - (1151 + 36)))) then
									if (((4655 + 165) > (578 + 1620)) and v24(v93.LightsJudgment, not v15:IsSpellInRange(v93.LightsJudgment))) then
										return "lights_judgment main 16";
									end
								end
								if (v93.Fireblood:IsCastable() or ((3168 - 2107) >= (6723 - (1552 + 280)))) then
									if (((2198 - (64 + 770)) <= (3037 + 1436)) and v24(v93.Fireblood, not v101)) then
										return "fireblood main 18";
									end
								end
								if (v93.AncestralCall:IsCastable() or ((8160 - 4565) <= (1 + 2))) then
									if (v24(v93.AncestralCall, not v101) or ((5915 - (157 + 1086)) == (7709 - 3857))) then
										return "ancestral_call main 20";
									end
								end
								if (((6827 - 5268) == (2390 - 831)) and v93.BagofTricks:IsCastable() and v14:BuffDown(v93.RecklessnessBuff) and v14:BuffUp(v93.EnrageBuff)) then
									if (v24(v93.BagofTricks, not v15:IsSpellInRange(v93.BagofTricks)) or ((2390 - 638) <= (1607 - (599 + 220)))) then
										return "bag_of_tricks main 22";
									end
								end
							end
							if ((v91 < v98) or ((7780 - 3873) == (2108 - (1813 + 118)))) then
								local v186 = 0 + 0;
								while true do
									if (((4687 - (841 + 376)) > (777 - 222)) and (v186 == (1 + 1))) then
										if ((v93.Ravager:IsCastable() and (v84 == "cursor") and v44 and ((v55 and v30) or not v55) and ((v93.Avatar:CooldownRemains() < (8 - 5)) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (869 - (464 + 395))))) or ((2494 - 1522) == (310 + 335))) then
											if (((4019 - (467 + 370)) >= (4370 - 2255)) and v24(v95.RavagerCursor, not v101)) then
												return "ravager main 28";
											end
										end
										if (((2858 + 1035) < (15182 - 10753)) and v93.ChampionsSpear:IsCastable() and (v85 == "player") and v47 and ((v57 and v30) or not v57) and v14:BuffUp(v93.EnrageBuff) and ((v14:BuffUp(v93.FuriousBloodthirstBuff) and v93.TitansTorment:IsAvailable()) or not v93.TitansTorment:IsAvailable() or (v98 < (4 + 16)) or (v100 > (2 - 1)) or not v14:HasTier(551 - (150 + 370), 1284 - (74 + 1208)))) then
											if (v24(v95.ChampionsSpearPlayer, not v101) or ((7051 - 4184) < (9034 - 7129))) then
												return "spear_of_bastion main 30";
											end
										end
										v186 = 3 + 0;
									end
									if (((391 - (14 + 376)) == v186) or ((3115 - 1319) >= (2622 + 1429))) then
										if (((1423 + 196) <= (3583 + 173)) and v93.Recklessness:IsCastable() and v45 and ((v56 and v30) or not v56) and (not v93.Annihilator:IsAvailable() or (v98 < (35 - 23)))) then
											if (((455 + 149) == (682 - (23 + 55))) and v24(v93.Recklessness, not v101)) then
												return "recklessness main 27";
											end
										end
										if ((v93.Ravager:IsCastable() and (v84 == "player") and v44 and ((v55 and v30) or not v55) and ((v93.Avatar:CooldownRemains() < (6 - 3)) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < (7 + 3)))) or ((4027 + 457) == (1395 - 495))) then
											if (v24(v95.RavagerPlayer, not v101) or ((1403 + 3056) <= (2014 - (652 + 249)))) then
												return "ravager main 28";
											end
										end
										v186 = 5 - 3;
									end
									if (((5500 - (708 + 1160)) > (9223 - 5825)) and (v186 == (0 - 0))) then
										if (((4109 - (10 + 17)) <= (1105 + 3812)) and v93.Avatar:IsReady() and v32 and ((v53 and v30) or not v53) and ((v93.TitansTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and (v91 < v98) and v14:BuffDown(v93.AvatarBuff) and (not v93.OdynsFury:IsAvailable() or (v93.OdynsFury:CooldownRemains() > (1732 - (1400 + 332))))) or (v93.BerserkersTorment:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff)) or (not v93.TitansTorment:IsAvailable() and not v93.BerserkersTorment:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v98 < (38 - 18)))))) then
											if (((6740 - (242 + 1666)) >= (594 + 792)) and v24(v93.Avatar, not v101)) then
												return "avatar main 24";
											end
										end
										if (((51 + 86) == (117 + 20)) and v93.Recklessness:IsCastable() and v45 and ((v56 and v30) or not v56) and (not v93.Annihilator:IsAvailable() or (v93.ChampionsSpear:CooldownRemains() < (941 - (850 + 90))) or (v93.Avatar:CooldownRemains() > (70 - 30)) or not v93.Avatar:IsAvailable() or (v98 < (1402 - (360 + 1030))))) then
											if (v24(v93.Recklessness, not v101) or ((1390 + 180) >= (12226 - 7894))) then
												return "recklessness main 26";
											end
										end
										v186 = 1 - 0;
									end
									if ((v186 == (1664 - (909 + 752))) or ((5287 - (109 + 1114)) <= (3329 - 1510))) then
										if ((v93.ChampionsSpear:IsCastable() and (v85 == "cursor") and v47 and ((v57 and v30) or not v57) and v14:BuffUp(v93.EnrageBuff) and ((v14:BuffUp(v93.FuriousBloodthirstBuff) and v93.TitansTorment:IsAvailable()) or not v93.TitansTorment:IsAvailable() or (v98 < (8 + 12)) or (v100 > (243 - (6 + 236))) or not v14:HasTier(20 + 11, 2 + 0))) or ((11758 - 6772) < (2748 - 1174))) then
											if (((5559 - (1076 + 57)) > (29 + 143)) and v24(v95.ChampionsSpearCursor, not v15:IsInRange(719 - (579 + 110)))) then
												return "spear_of_bastion main 31";
											end
										end
										break;
									end
								end
							end
							v179 = 1 + 1;
						end
						if (((519 + 67) > (242 + 213)) and (v179 == (407 - (174 + 233)))) then
							if (((2307 - 1481) == (1449 - 623)) and v36 and v93.Charge:IsCastable()) then
								if (v24(v93.Charge, not v15:IsSpellInRange(v93.Charge)) or ((1788 + 2231) > (5615 - (663 + 511)))) then
									return "charge main 2";
								end
							end
							v180 = v92.HandleDPSPotion(v15:BuffUp(v93.RecklessnessBuff));
							if (((1800 + 217) < (926 + 3335)) and v180) then
								return v180;
							end
							v179 = 2 - 1;
						end
					end
				end
				break;
			end
			if (((2856 + 1860) > (188 - 108)) and ((0 - 0) == v122)) then
				v27 = v103();
				if (v27 or ((1674 + 1833) == (6368 - 3096))) then
					return v27;
				end
				v122 = 1 + 0;
			end
		end
	end
	local function v110()
		local v123 = 0 + 0;
		while true do
			if (((726 - (478 + 244)) == v123) or ((1393 - (440 + 77)) >= (1399 + 1676))) then
				v44 = EpicSettings.Settings['useRavager'];
				v45 = EpicSettings.Settings['useRecklessness'];
				v47 = EpicSettings.Settings['useChampionsSpear'];
				v48 = EpicSettings.Settings['useThunderousRoar'];
				v123 = 18 - 13;
			end
			if (((5908 - (655 + 901)) > (474 + 2080)) and (v123 == (0 + 0))) then
				v31 = EpicSettings.Settings['useWeapon'];
				v33 = EpicSettings.Settings['useBattleShout'];
				v34 = EpicSettings.Settings['useBloodbath'];
				v35 = EpicSettings.Settings['useBloodthirst'];
				v123 = 1 + 0;
			end
			if ((v123 == (7 - 5)) or ((5851 - (695 + 750)) < (13805 - 9762))) then
				v41 = EpicSettings.Settings['useOnslaught'];
				v42 = EpicSettings.Settings['useRagingBlow'];
				v43 = EpicSettings.Settings['useRampage'];
				v46 = EpicSettings.Settings['useSlam'];
				v123 = 3 - 0;
			end
			if (((20 - 15) == v123) or ((2240 - (285 + 66)) >= (7885 - 4502))) then
				v53 = EpicSettings.Settings['avatarWithCD'];
				v54 = EpicSettings.Settings['odynFuryWithCD'];
				v55 = EpicSettings.Settings['ravagerWithCD'];
				v56 = EpicSettings.Settings['recklessnessWithCD'];
				v123 = 1316 - (682 + 628);
			end
			if (((305 + 1587) <= (3033 - (176 + 123))) and ((3 + 3) == v123)) then
				v57 = EpicSettings.Settings['championsSpearWithCD'];
				v58 = EpicSettings.Settings['thunderousRoarWithCD'];
				break;
			end
			if (((1395 + 528) < (2487 - (239 + 30))) and (v123 == (1 + 0))) then
				v36 = EpicSettings.Settings['useCharge'];
				v37 = EpicSettings.Settings['useCrushingBlow'];
				v38 = EpicSettings.Settings['useExecute'];
				v39 = EpicSettings.Settings['useHeroicThrow'];
				v123 = 2 + 0;
			end
			if (((3845 - 1672) > (1182 - 803)) and ((318 - (306 + 9)) == v123)) then
				v49 = EpicSettings.Settings['useWhirlwind'];
				v50 = EpicSettings.Settings['useWreckingThrow'];
				v32 = EpicSettings.Settings['useAvatar'];
				v40 = EpicSettings.Settings['useOdynsFury'];
				v123 = 13 - 9;
			end
		end
	end
	local function v111()
		local v124 = 0 + 0;
		while true do
			if ((v124 == (3 + 1)) or ((1248 + 1343) == (9748 - 6339))) then
				v79 = EpicSettings.Settings['defensiveStanceHP'] or (1375 - (1140 + 235));
				v82 = EpicSettings.Settings['unstanceHP'] or (0 + 0);
				v83 = EpicSettings.Settings['victoryRushHP'] or (0 + 0);
				v84 = EpicSettings.Settings['ravagerSetting'] or "player";
				v124 = 2 + 3;
			end
			if (((4566 - (33 + 19)) > (1201 + 2123)) and (v124 == (8 - 5))) then
				v75 = EpicSettings.Settings['ignorePainHP'] or (0 + 0);
				v76 = EpicSettings.Settings['rallyingCryHP'] or (0 - 0);
				v77 = EpicSettings.Settings['rallyingCryGroup'] or (0 + 0);
				v78 = EpicSettings.Settings['interveneHP'] or (689 - (586 + 103));
				v124 = 1 + 3;
			end
			if ((v124 == (5 - 3)) or ((1696 - (1309 + 179)) >= (8715 - 3887))) then
				v69 = EpicSettings.Settings['useDefensiveStance'];
				v72 = EpicSettings.Settings['useVictoryRush'];
				v73 = EpicSettings.Settings['bitterImmunityHP'] or (0 + 0);
				v74 = EpicSettings.Settings['enragedRegenerationHP'] or (0 - 0);
				v124 = 3 + 0;
			end
			if ((v124 == (1 - 0)) or ((3154 - 1571) > (4176 - (295 + 314)))) then
				v65 = EpicSettings.Settings['useEnragedRegeneration'];
				v66 = EpicSettings.Settings['useIgnorePain'];
				v67 = EpicSettings.Settings['useRallyingCry'];
				v68 = EpicSettings.Settings['useIntervene'];
				v124 = 4 - 2;
			end
			if ((v124 == (1967 - (1300 + 662))) or ((4122 - 2809) == (2549 - (1178 + 577)))) then
				v85 = EpicSettings.Settings['spearSetting'] or "player";
				break;
			end
			if (((1649 + 1525) > (8578 - 5676)) and (v124 == (1405 - (851 + 554)))) then
				v61 = EpicSettings.Settings['usePummel'];
				v62 = EpicSettings.Settings['useStormBolt'];
				v63 = EpicSettings.Settings['useIntimidatingShout'];
				v64 = EpicSettings.Settings['useBitterImmunity'];
				v124 = 1 + 0;
			end
		end
	end
	local function v112()
		v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v88 = EpicSettings.Settings['InterruptWithStun'];
		v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v90 = EpicSettings.Settings['InterruptThreshold'];
		v52 = EpicSettings.Settings['useTrinkets'];
		v51 = EpicSettings.Settings['useRacials'];
		v60 = EpicSettings.Settings['trinketsWithCD'];
		v59 = EpicSettings.Settings['racialsWithCD'];
		v70 = EpicSettings.Settings['useHealthstone'];
		v71 = EpicSettings.Settings['useHealingPotion'];
		v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v81 = EpicSettings.Settings['healingPotionHP'] or (302 - (115 + 187));
		v87 = EpicSettings.Settings['HealingPotionName'] or "";
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v113()
		local v135 = 0 + 0;
		while true do
			if (((3901 + 219) <= (16787 - 12527)) and (v135 == (1161 - (160 + 1001)))) then
				v111();
				v110();
				v112();
				v135 = 1 + 0;
			end
			if ((v135 == (2 + 0)) or ((1807 - 924) > (5136 - (237 + 121)))) then
				if (v14:IsDeadOrGhost() or ((4517 - (525 + 372)) >= (9272 - 4381))) then
					return v27;
				end
				if (((13990 - 9732) > (1079 - (96 + 46))) and v29) then
					local v181 = 777 - (643 + 134);
					while true do
						if ((v181 == (0 + 0)) or ((11674 - 6805) < (3363 - 2457))) then
							v99 = v14:GetEnemiesInMeleeRange(8 + 0);
							v100 = #v99;
							break;
						end
					end
				else
					v100 = 1 - 0;
				end
				v101 = v15:IsInMeleeRange(10 - 5);
				v135 = 722 - (316 + 403);
			end
			if ((v135 == (1 + 0)) or ((3367 - 2142) > (1528 + 2700))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v135 = 4 - 2;
			end
			if (((2359 + 969) > (722 + 1516)) and (v135 == (10 - 7))) then
				if (((18334 - 14495) > (2918 - 1513)) and (v92.TargetIsValid() or v14:AffectingCombat())) then
					v97 = v10.BossFightRemains(nil, true);
					v98 = v97;
					if ((v98 == (637 + 10474)) or ((2544 - 1251) <= (25 + 482))) then
						v98 = v10.FightRemains(v99, false);
					end
				end
				if (not v14:IsChanneling() or ((8520 - 5624) < (822 - (12 + 5)))) then
					if (((8995 - 6679) == (4940 - 2624)) and v14:AffectingCombat()) then
						local v182 = 0 - 0;
						while true do
							if ((v182 == (0 - 0)) or ((522 + 2048) == (3506 - (1656 + 317)))) then
								v27 = v109();
								if (v27 or ((787 + 96) == (1170 + 290))) then
									return v27;
								end
								break;
							end
						end
					else
						local v183 = 0 - 0;
						while true do
							if ((v183 == (0 - 0)) or ((4973 - (5 + 349)) <= (4745 - 3746))) then
								v27 = v106();
								if (v27 or ((4681 - (266 + 1005)) > (2713 + 1403))) then
									return v27;
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
	local function v114()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(245 - 173, v113, v114);
end;
return v0["Epix_Warrior_Fury.lua"]();

