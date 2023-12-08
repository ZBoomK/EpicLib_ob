local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5809 - (240 + 619)) <= (1099 + 3454))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Bind;
	local v21 = v19.Cast;
	local v22 = v19.CastSuggested;
	local v23 = v19.Press;
	local v24 = v19.Macro;
	local v25 = v19.Commons.Everyone;
	local v26 = v25.num;
	local v27 = v25.bool;
	local v28 = math.min;
	local v29 = math.max;
	local v30;
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
	local v83 = v17.DemonHunter.Havoc;
	local v84 = v18.DemonHunter.Havoc;
	local v85 = v24.DemonHunter.Havoc;
	local v86 = {};
	local v87 = v13:GetEquipment();
	local v88 = (v87[20 - 7] and v18(v87[1 + 12])) or v18(1744 - (1344 + 400));
	local v89 = (v87[419 - (255 + 150)] and v18(v87[12 + 2])) or v18(0 + 0);
	local v90, v91;
	local v92, v93;
	local v94 = {{v83.FelEruption},{v83.ChaosNova}};
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = ((v83.AFireInside:IsAvailable()) and (6 - 1)) or (1 + 0);
	local v102 = v13:GCD() + 0.25 + 0;
	local v103 = 337 - (10 + 327);
	local v104 = false;
	local v105 = 7738 + 3373;
	local v106 = 11449 - (118 + 220);
	local v107 = {(169870 - (108 + 341)),(716296 - 546871),(323847 - 154915),(54926 + 114500),(503676 - 334247),(6087 + 163341),(442376 - 272946)};
	v9:RegisterForEvent(function()
		local v121 = 0 + 0;
		while true do
			if (((3832 - (645 + 522)) <= (5723 - (1010 + 780))) and (v121 == (2 + 0))) then
				v99 = false;
				v105 = 52931 - 41820;
				v121 = 8 - 5;
			end
			if (((5109 - (1045 + 791)) == (8284 - 5011)) and (v121 == (1 - 0))) then
				v97 = false;
				v98 = false;
				v121 = 507 - (351 + 154);
			end
			if (((5398 - (1281 + 293)) > (675 - (28 + 238))) and (v121 == (6 - 3))) then
				v106 = 12670 - (1381 + 178);
				break;
			end
			if (((1958 + 129) == (1683 + 404)) and (v121 == (0 + 0))) then
				v95 = false;
				v96 = false;
				v121 = 3 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v122 = 0 + 0;
		while true do
			if ((v122 == (471 - (381 + 89))) or ((3019 + 385) > (3046 + 1457))) then
				v89 = (v87[23 - 9] and v18(v87[1170 - (1074 + 82)])) or v18(0 - 0);
				break;
			end
			if ((v122 == (1784 - (214 + 1570))) or ((4961 - (990 + 465)) <= (540 + 769))) then
				v87 = v13:GetEquipment();
				v88 = (v87[6 + 7] and v18(v87[13 + 0])) or v18(0 - 0);
				v122 = 1727 - (1668 + 58);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v101 = ((v83.AFireInside:IsAvailable()) and (631 - (512 + 114))) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v108(v123)
		return v123:DebuffRemains(v83.BurningWoundDebuff) or v123:DebuffRemains(v83.BurningWoundLegDebuff);
	end
	local function v109(v124)
		return v83.BurningWound:IsAvailable() and (v124:DebuffRemains(v83.BurningWoundDebuff) < (8 - 4)) and (v83.BurningWoundDebuff:AuraActiveCount() < v28(v92, 10 - 7));
	end
	local function v110()
		local v125 = 0 + 0;
		while true do
			if (((554 + 2401) == (2569 + 386)) and ((3 - 2) == v125)) then
				v30 = v25.HandleBottomTrinket(v86, v33, 2034 - (109 + 1885), nil);
				if (v30 or ((4372 - (1269 + 200)) == (2865 - 1370))) then
					return v30;
				end
				break;
			end
			if (((5361 - (98 + 717)) >= (3101 - (802 + 24))) and (v125 == (0 - 0))) then
				v30 = v25.HandleTopTrinket(v86, v33, 50 - 10, nil);
				if (((121 + 698) >= (17 + 5)) and v30) then
					return v30;
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v111()
		if (((683 + 2479) == (8796 - 5634)) and v83.Blur:IsCastable() and v63 and (v13:HealthPercentage() <= v65)) then
			if (v23(v83.Blur) or ((7899 - 5530) > (1585 + 2844))) then
				return "blur defensive";
			end
		end
		if (((1667 + 2428) >= (2626 + 557)) and v83.Netherwalk:IsCastable() and v64 and (v13:HealthPercentage() <= v66)) then
			if (v23(v83.Netherwalk) or ((2699 + 1012) < (471 + 537))) then
				return "netherwalk defensive";
			end
		end
		if ((v84.Healthstone:IsReady() and v78 and (v13:HealthPercentage() <= v80)) or ((2482 - (797 + 636)) <= (4398 - 3492))) then
			if (((6132 - (1427 + 192)) > (945 + 1781)) and v23(v85.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v77 and (v13:HealthPercentage() <= v79)) or ((3438 - 1957) >= (2390 + 268))) then
			if ((v81 == "Refreshing Healing Potion") or ((1460 + 1760) == (1690 - (192 + 134)))) then
				if (v84.RefreshingHealingPotion:IsReady() or ((2330 - (316 + 960)) > (1888 + 1504))) then
					if (v23(v85.RefreshingHealingPotion) or ((522 + 154) >= (1518 + 124))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if (((15811 - 11675) > (2948 - (83 + 468))) and (v81 == "Dreamwalker's Healing Potion")) then
				if (v84.DreamwalkersHealingPotion:IsReady() or ((6140 - (1202 + 604)) == (19816 - 15571))) then
					if (v23(v85.RefreshingHealingPotion) or ((7116 - 2840) <= (8391 - 5360))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v112()
		local v126 = 325 - (45 + 280);
		while true do
			if ((v126 == (2 + 0)) or ((4178 + 604) <= (438 + 761))) then
				if ((v14:IsInMeleeRange(3 + 2) and v40 and (v83.DemonsBite:IsCastable() or v83.DemonBlades:IsAvailable())) or ((856 + 4008) < (3521 - 1619))) then
					if (((6750 - (340 + 1571)) >= (1460 + 2240)) and v23(v83.DemonsBite, not v14:IsInMeleeRange(1777 - (1733 + 39)))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if ((v126 == (2 - 1)) or ((2109 - (125 + 909)) > (3866 - (1096 + 852)))) then
				if (((178 + 218) <= (5432 - 1628)) and not v14:IsInMeleeRange(5 + 0) and v83.Felblade:IsCastable()) then
					if (v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade)) or ((4681 - (409 + 103)) == (2423 - (46 + 190)))) then
						return "felblade precombat 9";
					end
				end
				if (((1501 - (51 + 44)) == (397 + 1009)) and not v14:IsInMeleeRange(1322 - (1114 + 203)) and v83.FelRush:IsCastable() and (not v83.Felblade:IsAvailable() or (v83.Felblade:CooldownDown() and not v13:PrevGCDP(727 - (228 + 498), v83.Felblade))) and v34 and v45) then
					if (((332 + 1199) < (2360 + 1911)) and v23(v83.FelRush, not v14:IsInRange(678 - (174 + 489)))) then
						return "fel_rush precombat 10";
					end
				end
				v126 = 5 - 3;
			end
			if (((2540 - (830 + 1075)) == (1159 - (303 + 221))) and (v126 == (1269 - (231 + 1038)))) then
				if (((2811 + 562) <= (4718 - (171 + 991))) and v83.ImmolationAura:IsCastable() and v47) then
					if (v23(v83.ImmolationAura, not v14:IsInRange(32 - 24)) or ((8836 - 5545) < (8185 - 4905))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((3511 + 875) >= (3060 - 2187)) and v48 and not v13:IsMoving() and (v92 > (2 - 1)) and v83.SigilOfFlame:IsCastable()) then
					if (((1484 - 563) <= (3406 - 2304)) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
						if (((5954 - (111 + 1137)) >= (1121 - (91 + 67))) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(23 - 15))) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v82 == "cursor") or ((240 + 720) <= (1399 - (423 + 100)))) then
						if (v23(v85.SigilOfFlameCursor, not v14:IsInRange(1 + 39)) or ((5719 - 3653) == (486 + 446))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v126 = 772 - (326 + 445);
			end
		end
	end
	local function v113()
		if (((21056 - 16231) < (10788 - 5945)) and v13:BuffDown(v83.FelBarrage)) then
			if ((v83.DeathSweep:IsReady() and v39) or ((9049 - 5172) >= (5248 - (530 + 181)))) then
				if (v23(v83.DeathSweep, not v14:IsInRange(889 - (614 + 267))) or ((4347 - (19 + 13)) < (2808 - 1082))) then
					return "death_sweep meta_end 2";
				end
			end
			if ((v83.Annihilation:IsReady() and v35) or ((8572 - 4893) < (1785 - 1160))) then
				if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((1202 + 3423) < (1111 - 479))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v114()
		if ((((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and not v83.Demonic:IsAvailable()) or ((171 - 88) > (3592 - (1293 + 519)))) then
			if (((1113 - 567) <= (2811 - 1734)) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(14 - 6))) then
				return "metamorphosis cooldown 4";
			end
		end
		if ((((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and v83.Demonic:IsAvailable() and ((not v83.ChaoticTransformation:IsAvailable() and v83.EyeBeam:CooldownDown()) or ((v83.EyeBeam:CooldownRemains() > (86 - 66)) and (not v95 or v13:PrevGCDP(2 - 1, v83.DeathSweep) or v13:PrevGCDP(2 + 0, v83.DeathSweep))) or ((v106 < (6 + 19 + (v26(v83.ShatteredDestiny:IsAvailable()) * (162 - 92)))) and v83.EyeBeam:CooldownDown() and v83.BladeDance:CooldownDown())) and v13:BuffDown(v83.InnerDemonBuff)) or ((231 + 765) > (1429 + 2872))) then
			if (((2544 + 1526) > (1783 - (709 + 387))) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(1866 - (673 + 1185)))) then
				return "metamorphosis cooldown 6";
			end
		end
		local v127 = v25.HandleDPSPotion(v13:BuffUp(v83.MetamorphosisBuff));
		if (v127 or ((1902 - 1246) >= (10693 - 7363))) then
			return v127;
		end
		if ((v55 and not v13:IsMoving() and ((v33 and v58) or not v58) and v83.ElysianDecree:IsCastable() and (v14:DebuffDown(v83.EssenceBreakDebuff)) and (v92 > v62)) or ((4099 - 1607) <= (240 + 95))) then
			if (((3230 + 1092) >= (3458 - 896)) and (v61 == "player")) then
				if (v23(v85.ElysianDecreePlayer, not v14:IsInRange(2 + 6)) or ((7251 - 3614) >= (7400 - 3630))) then
					return "elysian_decree cooldown 8 (Player)";
				end
			elseif ((v61 == "cursor") or ((4259 - (446 + 1434)) > (5861 - (1040 + 243)))) then
				if (v23(v85.ElysianDecreeCursor, not v14:IsInRange(89 - 59)) or ((2330 - (559 + 1288)) > (2674 - (609 + 1322)))) then
					return "elysian_decree cooldown 8 (Cursor)";
				end
			end
		end
		if (((2908 - (13 + 441)) > (2159 - 1581)) and (v74 < v106)) then
			if (((2436 - 1506) < (22202 - 17744)) and v75 and ((v33 and v76) or not v76)) then
				local v172 = 0 + 0;
				while true do
					if (((2404 - 1742) <= (346 + 626)) and ((0 + 0) == v172)) then
						v30 = v110();
						if (((12968 - 8598) == (2392 + 1978)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
	end
	local function v115()
		if ((v83.EssenceBreak:IsCastable() and v41 and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (18 - 8)))) or ((3149 + 1613) <= (479 + 382))) then
			if (v23(v83.EssenceBreak, not v14:IsInRange(6 + 2)) or ((1186 + 226) == (4172 + 92))) then
				return "essence_break rotation prio";
			end
		end
		if ((v83.BladeDance:IsCastable() and v36 and v14:DebuffUp(v83.EssenceBreakDebuff)) or ((3601 - (153 + 280)) < (6216 - 4063))) then
			if (v23(v83.BladeDance, not v14:IsInRange(8 + 0)) or ((1965 + 3011) < (698 + 634))) then
				return "blade_dance rotation prio";
			end
		end
		if (((4200 + 428) == (3354 + 1274)) and v83.DeathSweep:IsCastable() and v39 and v14:DebuffUp(v83.EssenceBreakDebuff)) then
			if (v23(v83.DeathSweep, not v14:IsInRange(11 - 3)) or ((34 + 20) == (1062 - (89 + 578)))) then
				return "death_sweep rotation prio";
			end
		end
		if (((59 + 23) == (170 - 88)) and v83.Annihilation:IsCastable() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.Metamorphosis:CooldownRemains() <= (v13:GCD() * (1052 - (572 + 477))))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((79 + 502) < (170 + 112))) then
				return "annihilation rotation 2";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and (v83.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v83.EssenceBreak:CooldownRemains() < (v102 * (88 - (84 + 2)))) and (v9.CombatTime() > (8 - 3)) and (v13:Fury() >= (22 + 8)) and v83.Inertia:IsAvailable()) or ((5451 - (497 + 345)) < (64 + 2431))) then
			if (((195 + 957) == (2485 - (605 + 728))) and v23(v83.VengefulRetreat, not v14:IsInRange(6 + 2), nil, true)) then
				return "vengeful_retreat rotation 3";
			end
		end
		if (((4215 - 2319) <= (157 + 3265)) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (3 - 2)) and ((v83.EssenceBreak:CooldownRemains() > (14 + 1)) or ((v83.EssenceBreak:CooldownRemains() < v102) and (not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > ((41 - 26) + ((8 + 2) * v26(v83.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (519 - (457 + 32))) or ((v13:GCDRemains() - (1 + 0)) < (1402 - (832 + 570)))) and (not v83.Initiative:IsAvailable() or (v13:BuffRemains(v83.InitiativeBuff) < v102) or (v9.CombatTime() > (4 + 0)))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(3 + 5), nil, true) or ((3503 - 2513) > (781 + 839))) then
				return "vengeful_retreat rotation 4";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (797 - (588 + 208))) and ((v83.EssenceBreak:CooldownRemains() > (40 - 25)) or ((v83.EssenceBreak:CooldownRemains() < (v102 * (1802 - (884 + 916)))) and (((v13:BuffRemains(v83.InitiativeBuff) < v102) and not v100 and (v83.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (62 - 32))) or not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (9 + 6 + ((663 - (232 + 421)) * v26(v83.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v83.UnboundChaosBuff) or v13:BuffUp(v83.InertiaBuff))) or ((2766 - (1569 + 320)) > (1152 + 3543))) then
			if (((512 + 2179) >= (6237 - 4386)) and v23(v83.VengefulRetreat, not v14:IsInRange(613 - (316 + 289)), nil, true)) then
				return "vengeful_retreat rotation 6";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and not v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (2 - 1)) and (v13:BuffDown(v83.InitiativeBuff) or (v13:PrevGCDP(1 + 0, v83.DeathSweep) and v83.Metamorphosis:CooldownUp() and v83.ChaoticTransformation:IsAvailable())) and v83.Initiative:IsAvailable()) or ((4438 - (666 + 787)) >= (5281 - (360 + 65)))) then
			if (((3997 + 279) >= (1449 - (79 + 175))) and v23(v83.VengefulRetreat, not v14:IsInRange(12 - 4), nil, true)) then
				return "vengeful_retreat rotation 8";
			end
		end
		if (((2523 + 709) <= (14376 - 9686)) and v83.FelRush:IsCastable() and v34 and v45 and v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) < (v102 * (3 - 1))) and (v83.EyeBeam:CooldownRemains() <= v102) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1795 - (503 + 396)) >= (3327 - (92 + 89)))) then
				return "fel_rush rotation 10";
			end
		end
		if (((5937 - 2876) >= (1517 + 1441)) and v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or ((v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge()) and (v83.EyeBeam:CooldownRemains() > (3 + 1)))) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) then
			if (((12480 - 9293) >= (89 + 555)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 11";
			end
		end
		if (((1467 - 823) <= (615 + 89)) and v83.EssenceBreak:IsCastable() and v41 and ((((v13:BuffRemains(v83.MetamorphosisBuff) > (v102 * (2 + 1))) or (v83.EyeBeam:CooldownRemains() > (30 - 20))) and (not v83.TacticalRetreat:IsAvailable() or v13:BuffUp(v83.TacticalRetreatBuff) or (v9.CombatTime() < (2 + 8))) and (v83.BladeDance:CooldownRemains() <= ((4.1 - 1) * v102))) or (v106 < (1250 - (485 + 759))))) then
			if (((2216 - 1258) > (2136 - (442 + 747))) and v23(v83.EssenceBreak, not v14:IsInRange(1143 - (832 + 303)))) then
				return "essence_break rotation 13";
			end
		end
		if (((5438 - (88 + 858)) >= (809 + 1845)) and v83.DeathSweep:IsCastable() and v39 and v95 and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() > (v102 * (2 + 0)))) and v13:BuffDown(v83.FelBarrage)) then
			if (((142 + 3300) >= (2292 - (766 + 23))) and v23(v83.DeathSweep, not v14:IsInRange(39 - 31))) then
				return "death_sweep rotation 14";
			end
		end
		if ((v83.TheHunt:IsCastable() and v34 and v57 and (v74 < v106) and ((v33 and v60) or not v60) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v9.CombatTime() < (13 - 3)) or (v83.Metamorphosis:CooldownRemains() > (26 - 16))) and ((v92 == (3 - 2)) or (v92 > (1076 - (1036 + 37))) or (v106 < (8 + 2))) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and (not v83.FuriousGaze:IsAvailable() or v13:BuffUp(v83.FuriousGazeBuff) or v13:HasTier(60 - 29, 4 + 0))) or not v13:HasTier(1510 - (641 + 839), 915 - (910 + 3))) and (v9.CombatTime() > (25 - 15))) or ((4854 - (1466 + 218)) <= (673 + 791))) then
			if (v23(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt)) or ((5945 - (556 + 592)) == (1561 + 2827))) then
				return "the_hunt main 12";
			end
		end
		if (((1359 - (329 + 479)) <= (1535 - (174 + 680))) and v83.FelBarrage:IsCastable() and v43 and ((v92 > (3 - 2)) or ((v92 == (1 - 0)) and (v13:FuryDeficit() < (15 + 5)) and v13:BuffDown(v83.MetamorphosisBuff)))) then
			if (((4016 - (396 + 343)) > (37 + 370)) and v23(v83.FelBarrage, not v14:IsInRange(1485 - (29 + 1448)))) then
				return "fel_barrage rotation 16";
			end
		end
		if (((6084 - (135 + 1254)) >= (5330 - 3915)) and v83.GlaiveTempest:IsReady() and v46 and (v14:DebuffDown(v83.EssenceBreakDebuff) or (v92 > (4 - 3))) and v13:BuffDown(v83.FelBarrage)) then
			if (v23(v83.GlaiveTempest, not v14:IsInRange(6 + 2)) or ((4739 - (389 + 1138)) <= (1518 - (102 + 472)))) then
				return "glaive_tempest rotation 18";
			end
		end
		if ((v83.Annihilation:IsReady() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v83.FelBarrage)) or ((2922 + 174) <= (998 + 800))) then
			if (((3298 + 239) == (5082 - (320 + 1225))) and v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation))) then
				return "annihilation rotation 20";
			end
		end
		if (((6829 - 2992) >= (961 + 609)) and v83.FelRush:IsReady() and v34 and v45 and v83.Momentum:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (1467 - (157 + 1307)))) and (v13:BuffRemains(v83.MomentumBuff) < (1864 - (821 + 1038))) and v13:BuffDown(v83.MetamorphosisBuff)) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((7360 - 4410) == (417 + 3395))) then
				return "fel_rush rotation 22";
			end
		end
		if (((8388 - 3665) >= (863 + 1455)) and v83.EyeBeam:IsCastable() and v42 and not v13:PrevGCDP(2 - 1, v83.VengefulRetreat) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.Metamorphosis:CooldownRemains() > ((1056 - (834 + 192)) - (v26(v83.CycleOfHatred:IsAvailable()) * (1 + 14)))) or ((v83.Metamorphosis:CooldownRemains() < (v102 * (1 + 1))) and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() < (v102 * (1.5 + 0)))))) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > v102) or not v83.RestlessHunter:IsAvailable()) and (v83.CycleOfHatred:IsAvailable() or not v83.Initiative:IsAvailable() or (v83.VengefulRetreat:CooldownRemains() > (7 - 2)) or not v50 or (v9.CombatTime() < (314 - (300 + 4)))) and v13:BuffDown(v83.InnerDemonBuff)) or (v106 < (5 + 10)))) then
			if (v23(v83.EyeBeam, not v14:IsInRange(20 - 12)) or ((2389 - (112 + 250)) > (1137 + 1715))) then
				return "eye_beam rotation 26";
			end
		end
		if ((v83.BladeDance:IsCastable() and v36 and v95 and ((v83.EyeBeam:CooldownRemains() > (12 - 7)) or not v83.Demonic:IsAvailable() or v13:HasTier(18 + 13, 2 + 0))) or ((850 + 286) > (2141 + 2176))) then
			if (((3528 + 1220) == (6162 - (1001 + 413))) and v23(v83.BladeDance, not v14:IsInRange(17 - 9))) then
				return "blade_dance rotation 28";
			end
		end
		if (((4618 - (244 + 638)) <= (5433 - (627 + 66))) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff) and (v92 >= (11 - 7))) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((3992 - (512 + 90)) <= (4966 - (1665 + 241)))) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(725 - (373 + 344))) or ((451 + 548) > (713 + 1980))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif (((1221 - 758) < (1016 - 415)) and (v82 == "cursor")) then
				if (v23(v85.SigilOfFlameCursor, not v14:IsInRange(1139 - (35 + 1064))) or ((1589 + 594) < (1469 - 782))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if (((19 + 4530) == (5785 - (298 + 938))) and v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(1260 - (233 + 1026), v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v92 >= ((1668 - (636 + 1030)) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.ThrowGlaive:FullRechargeTime() < (v102 * (2 + 1))) or (v92 > (1 + 0))) and not v13:HasTier(10 + 21, 1 + 1)) then
			if (((4893 - (55 + 166)) == (906 + 3766)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 32";
			end
		end
		if ((v83.ImmolationAura:IsCastable() and v47 and (v92 >= (1 + 1)) and (v13:Fury() < (267 - 197)) and v14:DebuffDown(v83.EssenceBreakDebuff)) or ((3965 - (36 + 261)) < (690 - 295))) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(1376 - (34 + 1334))) or ((1602 + 2564) == (354 + 101))) then
				return "immolation_aura rotation 34";
			end
		end
		if ((v83.Annihilation:IsCastable() and v35 and not v96 and ((v83.EssenceBreak:CooldownRemains() > (1283 - (1035 + 248))) or not v83.EssenceBreak:IsAvailable()) and v13:BuffDown(v83.FelBarrage)) or v13:HasTier(51 - (20 + 1), 2 + 0) or ((4768 - (134 + 185)) == (3796 - (549 + 584)))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((4962 - (314 + 371)) < (10260 - 7271))) then
				return "annihilation rotation 36";
			end
		end
		if ((v83.Felblade:IsCastable() and v44 and not v13:PrevGCDP(969 - (478 + 490), v83.VengefulRetreat) and (((v13:FuryDeficit() >= (22 + 18)) and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)))) or ((2042 - (786 + 386)) >= (13438 - 9289))) then
			if (((3591 - (1055 + 324)) < (4523 - (1093 + 247))) and v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade))) then
				return "felblade rotation 38";
			end
		end
		if (((4129 + 517) > (315 + 2677)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (119 - 89))) then
			if (((4866 - 3432) < (8838 - 5732)) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((1975 - 1189) < (1076 + 1947)) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(30 - 22))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif ((v82 == "cursor") or ((8416 - 5974) < (56 + 18))) then
				if (((11597 - 7062) == (5223 - (364 + 324))) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(109 - 69))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if ((v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(2 - 1, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v93 >= ((1 + 1) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and not v13:HasTier(129 - 98, 2 - 0)) or ((9138 - 6129) <= (3373 - (1249 + 19)))) then
			if (((1652 + 178) < (14281 - 10612)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 40";
			end
		end
		if ((v83.ImmolationAura:IsCastable() and v47 and (v13:BuffStack(v83.ImmolationAuraBuff) < v101) and v14:IsInRange(1094 - (686 + 400)) and (v13:BuffDown(v83.UnboundChaosBuff) or not v83.UnboundChaos:IsAvailable()) and ((v83.ImmolationAura:Recharge() < v83.EssenceBreak:CooldownRemains()) or (not v83.EssenceBreak:IsAvailable() and (v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge())))) or ((1122 + 308) >= (3841 - (73 + 156)))) then
			if (((13 + 2670) >= (3271 - (721 + 90))) and v23(v83.ImmolationAura, not v14:IsInRange(1 + 7))) then
				return "immolation_aura rotation 42";
			end
		end
		if ((v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(3 - 2, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v83.ThrowGlaive:FullRechargeTime() < v83.BladeDance:CooldownRemains()) and v13:HasTier(501 - (224 + 246), 2 - 0) and v13:BuffDown(v83.FelBarrage) and not v97) or ((3320 - 1516) >= (595 + 2680))) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((34 + 1383) > (2666 + 963))) then
				return "throw_glaive rotation 44";
			end
		end
		if (((9533 - 4738) > (1337 - 935)) and v83.ChaosStrike:IsReady() and v37 and not v96 and not v97 and v13:BuffDown(v83.FelBarrage)) then
			if (((5326 - (203 + 310)) > (5558 - (1238 + 755))) and v23(v83.ChaosStrike, not v14:IsSpellInRange(v83.ChaosStrike))) then
				return "chaos_strike rotation 46";
			end
		end
		if (((274 + 3638) == (5446 - (709 + 825))) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and (v13:FuryDeficit() >= (55 - 25))) then
			if (((4109 - 1288) <= (5688 - (196 + 668))) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((6861 - 5123) <= (4546 - 2351)) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(841 - (171 + 662)))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((134 - (4 + 89)) <= (10577 - 7559)) and (v82 == "cursor")) then
				if (((782 + 1363) <= (18025 - 13921)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(12 + 18))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if (((4175 - (35 + 1451)) < (6298 - (28 + 1425))) and v83.Felblade:IsCastable() and v44 and (v13:FuryDeficit() >= (2033 - (941 + 1052))) and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat)) then
			if (v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade)) or ((3836 - (822 + 692)) > (3742 - 1120))) then
				return "felblade rotation 50";
			end
		end
		if ((v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and v83.DemonBlades:IsAvailable() and v83.EyeBeam:CooldownDown() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.FelRush:Recharge() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable())) or ((2136 + 2398) == (2379 - (45 + 252)))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1555 + 16) > (643 + 1224))) then
				return "fel_rush rotation 52";
			end
		end
		if ((v83.DemonsBite:IsCastable() and v40 and v83.BurningWound:IsAvailable() and (v14:DebuffRemains(v83.BurningWoundDebuff) < (9 - 5))) or ((3087 - (114 + 319)) >= (4300 - 1304))) then
			if (((5096 - 1118) > (1342 + 762)) and v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite))) then
				return "demons_bite rotation 54";
			end
		end
		if (((4462 - 1467) > (3228 - 1687)) and v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and not v83.DemonBlades:IsAvailable() and (v92 > (1964 - (556 + 1407))) and v13:BuffDown(v83.UnboundChaosBuff)) then
			if (((4455 - (741 + 465)) > (1418 - (170 + 295))) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 56";
			end
		end
		if ((v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (16 + 14)) and v14:IsInRange(28 + 2)) or ((8058 - 4785) > (3791 + 782))) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((2021 + 1130) < (728 + 556))) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(1238 - (957 + 273))) or ((495 + 1355) == (613 + 916))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif (((3128 - 2307) < (5594 - 3471)) and (v82 == "cursor")) then
				if (((2754 - 1852) < (11512 - 9187)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(1810 - (389 + 1391)))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if (((539 + 319) <= (309 + 2653)) and v83.DemonsBite:IsCastable() and v40) then
			if (v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite)) or ((8983 - 5037) < (2239 - (783 + 168)))) then
				return "demons_bite rotation 57";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) <= (67 - 47))) or ((3189 + 53) == (878 - (309 + 2)))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((2600 - 1753) >= (2475 - (1090 + 122)))) then
				return "fel_rush rotation 58";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(3 + 5) and not v83.Momentum:IsAvailable()) or ((7566 - 5313) == (1267 + 584))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((3205 - (628 + 490)) > (426 + 1946))) then
				return "fel_rush rotation 59";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and not v83.Initiative:IsAvailable() and not v14:IsInRange(19 - 11)) or ((20313 - 15868) < (4923 - (431 + 343)))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(16 - 8), nil, true) or ((5259 - 3441) == (68 + 17))) then
				return "vengeful_retreat rotation 60";
			end
		end
		if (((81 + 549) < (3822 - (556 + 1139))) and v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(16 - (6 + 9), v83.VengefulRetreat) and not v13:IsMoving() and (v83.DemonBlades:IsAvailable() or not v14:IsInRange(3 + 9)) and v14:DebuffDown(v83.EssenceBreakDebuff) and v14:IsSpellInRange(v83.ThrowGlaive) and not v13:HasTier(16 + 15, 171 - (28 + 141))) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((751 + 1187) == (3102 - 588))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v116()
		local v128 = 0 + 0;
		while true do
			if (((5572 - (486 + 831)) >= (143 - 88)) and ((6 - 4) == v128)) then
				v41 = EpicSettings.Settings['useEssenceBreak'];
				v42 = EpicSettings.Settings['useEyeBeam'];
				v43 = EpicSettings.Settings['useFelBarrage'];
				v128 = 1 + 2;
			end
			if (((9482 - 6483) > (2419 - (668 + 595))) and (v128 == (6 + 0))) then
				v57 = EpicSettings.Settings['useTheHunt'];
				v58 = EpicSettings.Settings['elysianDecreeWithCD'];
				v59 = EpicSettings.Settings['metamorphosisWithCD'];
				v128 = 2 + 5;
			end
			if (((6408 - 4058) > (1445 - (23 + 267))) and (v128 == (1944 - (1129 + 815)))) then
				v35 = EpicSettings.Settings['useAnnihilation'];
				v36 = EpicSettings.Settings['useBladeDance'];
				v37 = EpicSettings.Settings['useChaosStrike'];
				v128 = 388 - (371 + 16);
			end
			if (((5779 - (1326 + 424)) <= (9190 - 4337)) and (v128 == (14 - 10))) then
				v47 = EpicSettings.Settings['useImmolationAura'];
				v48 = EpicSettings.Settings['useSigilOfFlame'];
				v49 = EpicSettings.Settings['useThrowGlaive'];
				v128 = 123 - (88 + 30);
			end
			if ((v128 == (774 - (720 + 51))) or ((1147 - 631) > (5210 - (421 + 1355)))) then
				v44 = EpicSettings.Settings['useFelblade'];
				v45 = EpicSettings.Settings['useFelRush'];
				v46 = EpicSettings.Settings['useGlaiveTempest'];
				v128 = 6 - 2;
			end
			if (((1988 + 2058) >= (4116 - (286 + 797))) and (v128 == (18 - 13))) then
				v50 = EpicSettings.Settings['useVengefulRetreat'];
				v55 = EpicSettings.Settings['useElysianDecree'];
				v56 = EpicSettings.Settings['useMetamorphosis'];
				v128 = 9 - 3;
			end
			if ((v128 == (440 - (397 + 42))) or ((850 + 1869) <= (2247 - (24 + 776)))) then
				v38 = EpicSettings.Settings['useConsumeMagic'];
				v39 = EpicSettings.Settings['useDeathSweep'];
				v40 = EpicSettings.Settings['useDemonsBite'];
				v128 = 2 - 0;
			end
			if ((v128 == (792 - (222 + 563))) or ((9108 - 4974) < (2827 + 1099))) then
				v60 = EpicSettings.Settings['theHuntWithCD'];
				v61 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v62 = EpicSettings.Settings['elysianDecreeSlider'] or (190 - (23 + 167));
				break;
			end
		end
	end
	local function v117()
		v51 = EpicSettings.Settings['useChaosNova'];
		v52 = EpicSettings.Settings['useDisrupt'];
		v53 = EpicSettings.Settings['useFelEruption'];
		v54 = EpicSettings.Settings['useSigilOfMisery'];
		v63 = EpicSettings.Settings['useBlur'];
		v64 = EpicSettings.Settings['useNetherwalk'];
		v65 = EpicSettings.Settings['blurHP'] or (1798 - (690 + 1108));
		v66 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v82 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v118()
		v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v67 = EpicSettings.Settings['dispelBuffs'];
		v71 = EpicSettings.Settings['InterruptWithStun'];
		v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v73 = EpicSettings.Settings['InterruptThreshold'];
		v75 = EpicSettings.Settings['useTrinkets'];
		v76 = EpicSettings.Settings['trinketsWithCD'];
		v78 = EpicSettings.Settings['useHealthstone'];
		v77 = EpicSettings.Settings['useHealingPotion'];
		v80 = EpicSettings.Settings['healthstoneHP'] or (848 - (40 + 808));
		v79 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v81 = EpicSettings.Settings['HealingPotionName'] or "";
		v70 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v119()
		v117();
		v116();
		v118();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['movement'];
		if (v13:IsDeadOrGhost() or ((626 - 462) >= (2662 + 123))) then
			return;
		end
		v90 = v13:GetEnemiesInMeleeRange(5 + 3);
		v91 = v13:GetEnemiesInMeleeRange(11 + 9);
		if (v32 or ((1096 - (47 + 524)) == (1369 + 740))) then
			v92 = ((#v90 > (0 - 0)) and #v90) or (1 - 0);
			v93 = #v91;
		else
			local v148 = 0 - 0;
			while true do
				if (((1759 - (1165 + 561)) == (1 + 32)) and (v148 == (0 - 0))) then
					v92 = 1 + 0;
					v93 = 480 - (341 + 138);
					break;
				end
			end
		end
		v102 = v13:GCD() + 0.05 + 0;
		if (((6302 - 3248) <= (4341 - (89 + 237))) and (v25.TargetIsValid() or v13:AffectingCombat())) then
			v105 = v9.BossFightRemains(nil, true);
			v106 = v105;
			if (((6018 - 4147) < (7119 - 3737)) and (v106 == (11992 - (581 + 300)))) then
				v106 = v9.FightRemains(Enemies8y, false);
			end
		end
		v30 = v111();
		if (((2513 - (855 + 365)) <= (5144 - 2978)) and v30) then
			return v30;
		end
		if (v70 or ((843 + 1736) < (1358 - (1030 + 205)))) then
			v30 = v25.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 29 + 1, true);
			if (v30 or ((788 + 58) >= (2654 - (156 + 130)))) then
				return v30;
			end
		end
		if ((v25.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((9115 - 5103) <= (5659 - 2301))) then
			if (((3059 - 1565) <= (792 + 2213)) and not v13:AffectingCombat()) then
				v30 = v112();
				if (v30 or ((1815 + 1296) == (2203 - (10 + 59)))) then
					return v30;
				end
			end
			if (((667 + 1688) == (11597 - 9242)) and v83.ConsumeMagic:IsAvailable() and v38 and v83.ConsumeMagic:IsReady() and v67 and not v13:IsCasting() and not v13:IsChanneling() and v25.UnitHasMagicBuff(v14)) then
				if (v23(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic)) or ((1751 - (671 + 492)) <= (344 + 88))) then
					return "greater_purge damage";
				end
			end
			if (((6012 - (369 + 846)) >= (1032 + 2863)) and v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(7 + 1)) then
				if (((5522 - (1036 + 909)) == (2844 + 733)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fel_rush rotation when OOR";
				end
			end
			if (((6369 - 2575) > (3896 - (11 + 192))) and v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v14:NPCID())) then
				if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((645 + 630) == (4275 - (135 + 40)))) then
					return "fodder to the flames react per target";
				end
			end
			if ((v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v15:NPCID())) or ((3854 - 2263) >= (2158 + 1422))) then
				if (((2165 - 1182) <= (2710 - 902)) and v23(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fodder to the flames react per mouseover";
				end
			end
			v95 = v83.FirstBlood:IsAvailable() or v83.TrailofRuin:IsAvailable() or (v83.ChaosTheory:IsAvailable() and v13:BuffDown(v83.ChaosTheoryBuff)) or (v92 > (177 - (50 + 126)));
			v96 = v95 and (v13:Fury() < ((208 - 133) - (v26(v83.DemonBlades:IsAvailable()) * (5 + 15)))) and (v83.BladeDance:CooldownRemains() < v102);
			v97 = v83.Demonic:IsAvailable() and not v83.BlindFury:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (1415 - (1233 + 180)))) and (v13:FuryDeficit() > (999 - (522 + 447)));
			v99 = (v83.Momentum:IsAvailable() and v13:BuffDown(v83.MomentumBuff)) or (v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff));
			local v149 = v29(v83.EyeBeam:BaseDuration(), v13:GCD());
			v100 = v83.Demonic:IsAvailable() and v83.EssenceBreak:IsAvailable() and Var3MinTrinket and (v106 > (v83.Metamorphosis:CooldownRemains() + (1451 - (107 + 1314)) + (v26(v83.ShatteredDestiny:IsAvailable()) * (28 + 32)))) and (v83.Metamorphosis:CooldownRemains() < (60 - 40)) and (v83.Metamorphosis:CooldownRemains() > (v149 + (v102 * (v26(v83.InnerDemon:IsAvailable()) + 1 + 1))));
			if ((v83.ImmolationAura:IsCastable() and v47 and v83.Ragefire:IsAvailable() and (v92 >= (5 - 2)) and (v83.BladeDance:CooldownDown() or v14:DebuffDown(v83.EssenceBreakDebuff))) or ((8506 - 6356) <= (3107 - (716 + 1194)))) then
				if (((65 + 3704) >= (126 + 1047)) and v23(v83.ImmolationAura, not v14:IsInRange(511 - (74 + 429)))) then
					return "immolation_aura main 2";
				end
			end
			if (((2864 - 1379) == (736 + 749)) and v83.ImmolationAura:IsCastable() and v47 and v83.AFireInside:IsAvailable() and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and (v83.ImmolationAura:FullRechargeTime() < (v102 * (4 - 2))) and v14:DebuffDown(v83.EssenceBreakDebuff)) then
				if (v23(v83.ImmolationAura, not v14:IsInRange(6 + 2)) or ((10219 - 6904) <= (6878 - 4096))) then
					return "immolation_aura main 3";
				end
			end
			if ((v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and (((v83.ImmolationAura:Charges() == (435 - (279 + 154))) and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v13:PrevGCDP(779 - (454 + 324), v83.EyeBeam) and v13:BuffUp(v83.InertiaBuff) and (v13:BuffRemains(v83.InertiaBuff) < (3 + 0))))) or ((893 - (12 + 5)) >= (1599 + 1365))) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((5686 - 3454) > (923 + 1574))) then
					return "fel_rush main 4";
				end
			end
			if ((v83.TheHunt:IsCastable() and (v9.CombatTime() < (1103 - (277 + 816))) and (not v83.Inertia:IsAvailable() or (v13:BuffUp(v83.MetamorphosisBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)))) or ((9016 - 6906) <= (1515 - (1058 + 125)))) then
				if (((692 + 2994) > (4147 - (815 + 160))) and v23(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt))) then
					return "the_hunt main 6";
				end
			end
			if ((v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and ((v83.EyeBeam:CooldownRemains() < (v102 * (8 - 6))) or v13:BuffUp(v83.MetamorphosisBuff)) and (v83.EssenceBreak:CooldownRemains() < (v102 * (7 - 4))) and v13:BuffDown(v83.UnboundChaosBuff) and v13:BuffDown(v83.InertiaBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)) or ((1068 + 3406) < (2396 - 1576))) then
				if (((6177 - (41 + 1857)) >= (4775 - (1222 + 671))) and v23(v83.ImmolationAura, not v14:IsInRange(20 - 12))) then
					return "immolation_aura main 5";
				end
			end
			if ((v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.ImmolationAura:FullRechargeTime() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable()) and v14:DebuffDown(v83.EssenceBreakDebuff) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > (7 - 1))) and v83.BladeDance:CooldownDown() and ((v13:Fury() < (1257 - (229 + 953))) or (v83.BladeDance:CooldownRemains() < (v102 * (1776 - (1111 + 663)))))) or ((3608 - (874 + 705)) >= (493 + 3028))) then
				if (v23(v83.ImmolationAura, not v14:IsInRange(6 + 2)) or ((4233 - 2196) >= (131 + 4511))) then
					return "immolation_aura main 6";
				end
			end
			if (((2399 - (642 + 37)) < (1017 + 3441)) and v83.FelRush:IsCastable() and v34 and v45 and ((v13:BuffRemains(v83.UnboundChaosBuff) < (v102 * (1 + 1))) or (v14:TimeToDie() < (v102 * (4 - 2))))) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((890 - (233 + 221)) > (6985 - 3964))) then
					return "fel_rush main 8";
				end
			end
			if (((628 + 85) <= (2388 - (718 + 823))) and v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and ((v83.EyeBeam:CooldownRemains() + 2 + 1) > v13:BuffRemains(v83.UnboundChaosBuff)) and (v83.BladeDance:CooldownDown() or v83.EssenceBreak:CooldownUp())) then
				if (((2959 - (266 + 539)) <= (11412 - 7381)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fel_rush main 9";
				end
			end
			if (((5840 - (636 + 589)) == (10954 - 6339)) and v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EssenceBreak:CooldownRemains() > (20 - 10)))) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((3004 + 786) == (182 + 318))) then
					return "fel_rush main 10";
				end
			end
			if (((1104 - (657 + 358)) < (584 - 363)) and (v74 < v106) and v33) then
				local v173 = 0 - 0;
				while true do
					if (((3241 - (1151 + 36)) >= (1373 + 48)) and (v173 == (0 + 0))) then
						v30 = v114();
						if (((2066 - 1374) < (4890 - (1552 + 280))) and v30) then
							return v30;
						end
						break;
					end
				end
			end
			if ((v13:BuffUp(v83.MetamorphosisBuff) and (v13:BuffRemains(v83.MetamorphosisBuff) < v102) and (v92 < (837 - (64 + 770)))) or ((2210 + 1044) == (3756 - 2101))) then
				local v174 = 0 + 0;
				while true do
					if ((v174 == (1243 - (157 + 1086))) or ((2593 - 1297) == (21504 - 16594))) then
						v30 = v113();
						if (((5166 - 1798) == (4596 - 1228)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
			v30 = v115();
			if (((3462 - (599 + 220)) < (7596 - 3781)) and v30) then
				return v30;
			end
			if (((3844 - (1813 + 118)) > (361 + 132)) and (v83.DemonBlades:IsAvailable())) then
				if (((5972 - (841 + 376)) > (4803 - 1375)) and v23(v83.Pool)) then
					return "pool demon_blades";
				end
			end
		end
	end
	local function v120()
		v83.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(135 + 442, v119, v120);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

