local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((367 - (20 + 27)) <= (339 - (50 + 237)))) then
			return v6(...);
		end
		if (((747 + 562) <= (5691 - 2185)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((12493 - 9538) == (4448 - (711 + 782))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Cast;
	local v23 = v20.CastSuggested;
	local v24 = v20.Press;
	local v25 = v20.Macro;
	local v26 = v20.Commons.Everyone;
	local v27 = v26.num;
	local v28 = v26.bool;
	local v29 = math.min;
	local v30 = math.max;
	local v31;
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
	local v84 = v18.DemonHunter.Havoc;
	local v85 = v19.DemonHunter.Havoc;
	local v86 = v25.DemonHunter.Havoc;
	local v87 = {};
	local v88 = v14:GetEquipment();
	local v89 = (v88[482 - (270 + 199)] and v19(v88[5 + 8])) or v19(1819 - (580 + 1239));
	local v90 = (v88[41 - 27] and v19(v88[14 + 0])) or v19(0 + 0);
	local v91, v92;
	local v93, v94;
	local v95 = {{v84.FelEruption},{v84.ChaosNova}};
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = false;
	local v102 = ((v84.AFireInside:IsAvailable()) and (1795 - (1010 + 780))) or (1 + 0);
	local v103 = v14:GCD() + (0.25 - 0);
	local v104 = 0 - 0;
	local v105 = false;
	local v106 = 12947 - (1045 + 791);
	local v107 = 28124 - 17013;
	local v108 = {(169926 - (351 + 154)),(169691 - (28 + 238)),(170491 - (1381 + 178)),(136615 + 32811),(584092 - 414663),(169898 - (381 + 89)),(114584 + 54846)};
	v10:RegisterForEvent(function()
		local v122 = 0 - 0;
		while true do
			if ((v122 == (1159 - (1074 + 82))) or ((6361 - 3458) == (3279 - (214 + 1570)))) then
				v107 = 12566 - (990 + 465);
				break;
			end
			if (((1875 + 2671) >= (990 + 1285)) and (v122 == (0 + 0))) then
				v96 = false;
				v97 = false;
				v122 = 3 - 2;
			end
			if (((2545 - (1668 + 58)) >= (648 - (512 + 114))) and (v122 == (5 - 3))) then
				v100 = false;
				v106 = 22970 - 11859;
				v122 = 10 - 7;
			end
			if (((1471 + 1691) == (592 + 2570)) and (v122 == (1 + 0))) then
				v98 = false;
				v99 = false;
				v122 = 6 - 4;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		v88 = v14:GetEquipment();
		v89 = (v88[2007 - (109 + 1885)] and v19(v88[1482 - (1269 + 200)])) or v19(0 - 0);
		v90 = (v88[829 - (98 + 717)] and v19(v88[840 - (802 + 24)])) or v19(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v102 = ((v84.AFireInside:IsAvailable()) and (6 - 1)) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v109(v123)
		return v123:DebuffRemains(v84.BurningWoundDebuff) or v123:DebuffRemains(v84.BurningWoundLegDebuff);
	end
	local function v110(v124)
		return v84.BurningWound:IsAvailable() and (v124:DebuffRemains(v84.BurningWoundDebuff) < (4 + 0)) and (v84.BurningWoundDebuff:AuraActiveCount() < v29(v93, 1 + 2));
	end
	local function v111()
		v31 = v26.HandleTopTrinket(v87, v34, 9 + 31, nil);
		if (v31 or ((6590 - 4221) > (14769 - 10340))) then
			return v31;
		end
		v31 = v26.HandleBottomTrinket(v87, v34, 15 + 25, nil);
		if (((1667 + 2428) >= (2626 + 557)) and v31) then
			return v31;
		end
	end
	local function v112()
		if ((v84.Blur:IsCastable() and v64 and (v14:HealthPercentage() <= v66)) or ((2699 + 1012) < (471 + 537))) then
			if (v24(v84.Blur) or ((2482 - (797 + 636)) <= (4398 - 3492))) then
				return "blur defensive";
			end
		end
		if (((6132 - (1427 + 192)) > (945 + 1781)) and v84.Netherwalk:IsCastable() and v65 and (v14:HealthPercentage() <= v67)) then
			if (v24(v84.Netherwalk) or ((3438 - 1957) >= (2390 + 268))) then
				return "netherwalk defensive";
			end
		end
		if ((v85.Healthstone:IsReady() and v79 and (v14:HealthPercentage() <= v81)) or ((1460 + 1760) == (1690 - (192 + 134)))) then
			if (v24(v86.Healthstone) or ((2330 - (316 + 960)) > (1888 + 1504))) then
				return "healthstone defensive";
			end
		end
		if ((v78 and (v14:HealthPercentage() <= v80)) or ((522 + 154) >= (1518 + 124))) then
			if (((15811 - 11675) > (2948 - (83 + 468))) and (v82 == "Refreshing Healing Potion")) then
				if (v85.RefreshingHealingPotion:IsReady() or ((6140 - (1202 + 604)) == (19816 - 15571))) then
					if (v24(v86.RefreshingHealingPotion) or ((7116 - 2840) <= (8391 - 5360))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v82 == "Dreamwalker's Healing Potion") or ((5107 - (45 + 280)) <= (1158 + 41))) then
				if (v85.DreamwalkersHealingPotion:IsReady() or ((4250 + 614) < (695 + 1207))) then
					if (((2678 + 2161) >= (651 + 3049)) and v24(v86.RefreshingHealingPotion)) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v113()
		if ((v84.ImmolationAura:IsCastable() and v48) or ((1990 - 915) > (3829 - (340 + 1571)))) then
			if (((157 + 239) <= (5576 - (1733 + 39))) and v24(v84.ImmolationAura, not v15:IsInRange(21 - 13))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v49 and not v14:IsMoving() and (v93 > (1035 - (125 + 909))) and v84.SigilOfFlame:IsCastable()) or ((6117 - (1096 + 852)) == (982 + 1205))) then
			if (((2007 - 601) == (1364 + 42)) and ((v83 == "player") or v84.ConcentratedSigils:IsAvailable())) then
				if (((2043 - (409 + 103)) < (4507 - (46 + 190))) and v24(v86.SigilOfFlamePlayer, not v15:IsInRange(103 - (51 + 44)))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((180 + 455) == (1952 - (1114 + 203))) and (v83 == "cursor")) then
				if (((4099 - (228 + 498)) <= (771 + 2785)) and v24(v86.SigilOfFlameCursor, not v15:IsInRange(23 + 17))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if ((not v15:IsInMeleeRange(668 - (174 + 489)) and v84.Felblade:IsCastable()) or ((8573 - 5282) < (5185 - (830 + 1075)))) then
			if (((4910 - (303 + 221)) >= (2142 - (231 + 1038))) and v24(v84.Felblade, not v15:IsSpellInRange(v84.Felblade))) then
				return "felblade precombat 9";
			end
		end
		if (((768 + 153) <= (2264 - (171 + 991))) and not v15:IsInMeleeRange(20 - 15) and v84.FelRush:IsCastable() and (not v84.Felblade:IsAvailable() or (v84.Felblade:CooldownDown() and not v14:PrevGCDP(2 - 1, v84.Felblade))) and v35 and v46) then
			if (((11743 - 7037) >= (771 + 192)) and v24(v84.FelRush, not v15:IsInRange(52 - 37))) then
				return "fel_rush precombat 10";
			end
		end
		if ((v15:IsInMeleeRange(14 - 9) and v41 and (v84.DemonsBite:IsCastable() or v84.DemonBlades:IsAvailable())) or ((1547 - 587) <= (2707 - 1831))) then
			if (v24(v84.DemonsBite, not v15:IsInMeleeRange(1253 - (111 + 1137))) or ((2224 - (91 + 67)) == (2773 - 1841))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v114()
		if (((1204 + 3621) < (5366 - (423 + 100))) and v14:BuffDown(v84.FelBarrage)) then
			if ((v84.DeathSweep:IsReady() and v40) or ((28 + 3849) >= (12562 - 8025))) then
				if (v24(v84.DeathSweep, not v15:IsInRange(5 + 3)) or ((5086 - (326 + 445)) < (7532 - 5806))) then
					return "death_sweep meta_end 2";
				end
			end
			if ((v84.Annihilation:IsReady() and v36) or ((8195 - 4516) < (1458 - 833))) then
				if (v24(v84.Annihilation, not v15:IsSpellInRange(v84.Annihilation)) or ((5336 - (530 + 181)) < (1513 - (614 + 267)))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v115()
		local v125 = 32 - (19 + 13);
		local v126;
		while true do
			if ((v125 == (1 - 0)) or ((192 - 109) > (5084 - 3304))) then
				v126 = v26.HandleDPSPotion(v14:BuffUp(v84.MetamorphosisBuff));
				if (((142 + 404) <= (1894 - 817)) and v126) then
					return v126;
				end
				v125 = 3 - 1;
			end
			if ((v125 == (1812 - (1293 + 519))) or ((2031 - 1035) > (11229 - 6928))) then
				if (((7783 - 3713) > (2962 - 2275)) and ((v34 and v60) or not v60) and v84.Metamorphosis:IsCastable() and v57 and not v84.Demonic:IsAvailable()) then
					if (v24(v86.MetamorphosisPlayer, not v15:IsInRange(18 - 10)) or ((348 + 308) >= (680 + 2650))) then
						return "metamorphosis cooldown 4";
					end
				end
				if ((((v34 and v60) or not v60) and v84.Metamorphosis:IsCastable() and v57 and v84.Demonic:IsAvailable() and ((not v84.ChaoticTransformation:IsAvailable() and v84.EyeBeam:CooldownDown()) or ((v84.EyeBeam:CooldownRemains() > (46 - 26)) and (not v96 or v14:PrevGCDP(1 + 0, v84.DeathSweep) or v14:PrevGCDP(1 + 1, v84.DeathSweep))) or ((v107 < (16 + 9 + (v27(v84.ShatteredDestiny:IsAvailable()) * (1166 - (709 + 387))))) and v84.EyeBeam:CooldownDown() and v84.BladeDance:CooldownDown())) and v14:BuffDown(v84.InnerDemonBuff)) or ((4350 - (673 + 1185)) <= (971 - 636))) then
					if (((13878 - 9556) >= (4214 - 1652)) and v24(v86.MetamorphosisPlayer, not v15:IsInRange(6 + 2))) then
						return "metamorphosis cooldown 6";
					end
				end
				v125 = 1 + 0;
			end
			if ((v125 == (2 - 0)) or ((894 + 2743) >= (7517 - 3747))) then
				if ((v56 and not v14:IsMoving() and ((v34 and v59) or not v59) and v84.ElysianDecree:IsCastable() and (v15:DebuffDown(v84.EssenceBreakDebuff)) and (v93 > v63)) or ((4669 - 2290) > (6458 - (446 + 1434)))) then
					if ((v62 == "player") or ((1766 - (1040 + 243)) > (2217 - 1474))) then
						if (((4301 - (559 + 1288)) > (2509 - (609 + 1322))) and v24(v86.ElysianDecreePlayer, not v15:IsInRange(462 - (13 + 441)))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif (((3475 - 2545) < (11676 - 7218)) and (v62 == "cursor")) then
						if (((3297 - 2635) <= (37 + 935)) and v24(v86.ElysianDecreeCursor, not v15:IsInRange(108 - 78))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if (((1553 + 2817) == (1915 + 2455)) and (v75 < v107)) then
					if ((v76 and ((v34 and v77) or not v77)) or ((14131 - 9369) <= (472 + 389))) then
						v31 = v111();
						if (v31 or ((2596 - 1184) == (2819 + 1445))) then
							return v31;
						end
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (6 + 1)) or ((2661 + 507) < (2107 + 46))) then
				if ((v84.FelRush:IsCastable() and v35 and v46 and not v84.Momentum:IsAvailable() and v84.DemonBlades:IsAvailable() and v84.EyeBeam:CooldownDown() and v14:BuffDown(v84.UnboundChaosBuff) and ((v84.FelRush:Recharge() < v84.EssenceBreak:CooldownRemains()) or not v84.EssenceBreak:IsAvailable())) or ((5409 - (153 + 280)) < (3845 - 2513))) then
					if (((4156 + 472) == (1828 + 2800)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
						return "fel_rush rotation 52";
					end
				end
				if ((v84.DemonsBite:IsCastable() and v41 and v84.BurningWound:IsAvailable() and (v15:DebuffRemains(v84.BurningWoundDebuff) < (3 + 1))) or ((50 + 4) == (287 + 108))) then
					if (((124 - 42) == (51 + 31)) and v24(v84.DemonsBite, not v15:IsSpellInRange(v84.DemonsBite))) then
						return "demons_bite rotation 54";
					end
				end
				if ((v84.FelRush:IsCastable() and v35 and v46 and not v84.Momentum:IsAvailable() and not v84.DemonBlades:IsAvailable() and (v93 > (668 - (89 + 578))) and v14:BuffDown(v84.UnboundChaosBuff)) or ((416 + 165) < (585 - 303))) then
					if (v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((5658 - (572 + 477)) < (337 + 2158))) then
						return "fel_rush rotation 56";
					end
				end
				if (((692 + 460) == (138 + 1014)) and v84.SigilOfFlame:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= (116 - (84 + 2))) and v15:IsInRange(49 - 19)) then
					if (((1366 + 530) <= (4264 - (497 + 345))) and ((v83 == "player") or v84.ConcentratedSigils:IsAvailable())) then
						if (v24(v86.SigilOfFlamePlayer, not v15:IsInRange(1 + 7)) or ((168 + 822) > (2953 - (605 + 728)))) then
							return "sigil_of_flame rotation player 58";
						end
					elseif ((v83 == "cursor") or ((626 + 251) > (10438 - 5743))) then
						if (((124 + 2567) >= (6843 - 4992)) and v24(v86.SigilOfFlameCursor, not v15:IsInRange(28 + 2))) then
							return "sigil_of_flame rotation cursor 58";
						end
					end
				end
				v127 = 21 - 13;
			end
			if (((3 + 0) == v127) or ((3474 - (457 + 32)) >= (2061 + 2795))) then
				if (((5678 - (832 + 570)) >= (1126 + 69)) and v84.Annihilation:IsReady() and v36 and v14:BuffUp(v84.InnerDemonBuff) and (v84.EyeBeam:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v84.FelBarrage)) then
					if (((843 + 2389) <= (16597 - 11907)) and v24(v84.Annihilation, not v15:IsSpellInRange(v84.Annihilation))) then
						return "annihilation rotation 20";
					end
				end
				if ((v84.FelRush:IsReady() and v35 and v46 and v84.Momentum:IsAvailable() and (v84.EyeBeam:CooldownRemains() < (v103 * (2 + 1))) and (v14:BuffRemains(v84.MomentumBuff) < (801 - (588 + 208))) and v14:BuffDown(v84.MetamorphosisBuff)) or ((2414 - 1518) >= (4946 - (884 + 916)))) then
					if (((6408 - 3347) >= (1716 + 1242)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
						return "fel_rush rotation 22";
					end
				end
				if (((3840 - (232 + 421)) >= (2533 - (1569 + 320))) and v84.EyeBeam:IsCastable() and v43 and not v14:PrevGCDP(1 + 0, v84.VengefulRetreat) and ((v15:DebuffDown(v84.EssenceBreakDebuff) and ((v84.Metamorphosis:CooldownRemains() > ((6 + 24) - (v27(v84.CycleOfHatred:IsAvailable()) * (50 - 35)))) or ((v84.Metamorphosis:CooldownRemains() < (v103 * (607 - (316 + 289)))) and (not v84.EssenceBreak:IsAvailable() or (v84.EssenceBreak:CooldownRemains() < (v103 * (2.5 - 1)))))) and (v14:BuffDown(v84.MetamorphosisBuff) or (v14:BuffRemains(v84.MetamorphosisBuff) > v103) or not v84.RestlessHunter:IsAvailable()) and (v84.CycleOfHatred:IsAvailable() or not v84.Initiative:IsAvailable() or (v84.VengefulRetreat:CooldownRemains() > (1 + 4)) or not v51 or (v10.CombatTime() < (1463 - (666 + 787)))) and v14:BuffDown(v84.InnerDemonBuff)) or (v107 < (440 - (360 + 65))))) then
					if (((602 + 42) <= (958 - (79 + 175))) and v24(v84.EyeBeam, not v15:IsInRange(12 - 4))) then
						return "eye_beam rotation 26";
					end
				end
				if (((748 + 210) > (2902 - 1955)) and v84.BladeDance:IsCastable() and v37 and v96 and ((v84.EyeBeam:CooldownRemains() > (9 - 4)) or not v84.Demonic:IsAvailable() or v14:HasTier(930 - (503 + 396), 183 - (92 + 89)))) then
					if (((8713 - 4221) >= (1362 + 1292)) and v24(v84.BladeDance, not v15:IsInRange(5 + 3))) then
						return "blade_dance rotation 28";
					end
				end
				v127 = 15 - 11;
			end
			if (((471 + 2971) >= (3426 - 1923)) and ((8 + 1) == v127)) then
				if ((v84.ThrowGlaive:IsCastable() and v50 and not v14:PrevGCDP(1 + 0, v84.VengefulRetreat) and not v14:IsMoving() and (v84.DemonBlades:IsAvailable() or not v15:IsInRange(36 - 24)) and v15:DebuffDown(v84.EssenceBreakDebuff) and v15:IsSpellInRange(v84.ThrowGlaive) and not v14:HasTier(4 + 27, 2 - 0)) or ((4414 - (485 + 759)) <= (3387 - 1923))) then
					if (v24(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((5986 - (442 + 747)) == (5523 - (832 + 303)))) then
						return "throw_glaive rotation 62";
					end
				end
				break;
			end
			if (((1497 - (88 + 858)) <= (208 + 473)) and (v127 == (5 + 0))) then
				if (((135 + 3142) > (1196 - (766 + 23))) and v84.Felblade:IsCastable() and v45 and not v14:PrevGCDP(4 - 3, v84.VengefulRetreat) and (((v14:FuryDeficit() >= (54 - 14)) and v84.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v84.EssenceBreakDebuff)) or (v84.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v84.EssenceBreakDebuff)))) then
					if (((12369 - 7674) >= (4802 - 3387)) and v24(v84.Felblade, not v15:IsSpellInRange(v84.Felblade))) then
						return "felblade rotation 38";
					end
				end
				if ((v84.SigilOfFlame:IsCastable() and not v14:IsMoving() and v49 and v84.AnyMeansNecessary:IsAvailable() and (v14:FuryDeficit() >= (1103 - (1036 + 37)))) or ((2278 + 934) <= (1837 - 893))) then
					if ((v83 == "player") or v84.ConcentratedSigils:IsAvailable() or ((2436 + 660) <= (3278 - (641 + 839)))) then
						if (((4450 - (910 + 3)) == (9016 - 5479)) and v24(v86.SigilOfFlamePlayer, not v15:IsInRange(1692 - (1466 + 218)))) then
							return "sigil_of_flame rotation player 39";
						end
					elseif (((1764 + 2073) >= (2718 - (556 + 592))) and (v83 == "cursor")) then
						if (v24(v86.SigilOfFlameCursor, not v15:IsInRange(15 + 25)) or ((3758 - (329 + 479)) == (4666 - (174 + 680)))) then
							return "sigil_of_flame rotation cursor 39";
						end
					end
				end
				if (((16228 - 11505) >= (4804 - 2486)) and v84.ThrowGlaive:IsReady() and v50 and not v14:PrevGCDP(1 + 0, v84.VengefulRetreat) and not v14:IsMoving() and v84.Soulscar:IsAvailable() and (v94 >= ((741 - (396 + 343)) - v27(v84.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v84.EssenceBreakDebuff) and not v14:HasTier(3 + 28, 1479 - (29 + 1448))) then
					if (v24(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((3416 - (135 + 1254)) > (10743 - 7891))) then
						return "throw_glaive rotation 40";
					end
				end
				if ((v84.ImmolationAura:IsCastable() and v48 and (v14:BuffStack(v84.ImmolationAuraBuff) < v102) and v15:IsInRange(37 - 29) and (v14:BuffDown(v84.UnboundChaosBuff) or not v84.UnboundChaos:IsAvailable()) and ((v84.ImmolationAura:Recharge() < v84.EssenceBreak:CooldownRemains()) or (not v84.EssenceBreak:IsAvailable() and (v84.EyeBeam:CooldownRemains() > v84.ImmolationAura:Recharge())))) or ((758 + 378) > (5844 - (389 + 1138)))) then
					if (((5322 - (102 + 472)) == (4481 + 267)) and v24(v84.ImmolationAura, not v15:IsInRange(5 + 3))) then
						return "immolation_aura rotation 42";
					end
				end
				v127 = 6 + 0;
			end
			if (((5281 - (320 + 1225)) <= (8438 - 3698)) and (v127 == (1 + 0))) then
				if ((v84.VengefulRetreat:IsCastable() and v35 and v51 and v84.Felblade:CooldownDown() and v84.Initiative:IsAvailable() and not v84.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1465 - (157 + 1307))) and (v14:BuffDown(v84.InitiativeBuff) or (v14:PrevGCDP(1860 - (821 + 1038), v84.DeathSweep) and v84.Metamorphosis:CooldownUp() and v84.ChaoticTransformation:IsAvailable())) and v84.Initiative:IsAvailable()) or ((8458 - 5068) <= (335 + 2725))) then
					if (v24(v84.VengefulRetreat, not v15:IsInRange(13 - 5), nil, true) or ((372 + 627) > (6674 - 3981))) then
						return "vengeful_retreat rotation 8";
					end
				end
				if (((1489 - (834 + 192)) < (39 + 562)) and v84.FelRush:IsCastable() and v35 and v46 and v84.Momentum:IsAvailable() and (v14:BuffRemains(v84.MomentumBuff) < (v103 * (1 + 1))) and (v84.EyeBeam:CooldownRemains() <= v103) and v15:DebuffDown(v84.EssenceBreakDebuff) and v84.BladeDance:CooldownDown()) then
					if (v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((47 + 2136) < (1063 - 376))) then
						return "fel_rush rotation 10";
					end
				end
				if (((4853 - (300 + 4)) == (1215 + 3334)) and v84.FelRush:IsCastable() and v35 and v46 and v84.Inertia:IsAvailable() and v14:BuffDown(v84.InertiaBuff) and v14:BuffUp(v84.UnboundChaosBuff) and (v14:BuffUp(v84.MetamorphosisBuff) or ((v84.EyeBeam:CooldownRemains() > v84.ImmolationAura:Recharge()) and (v84.EyeBeam:CooldownRemains() > (10 - 6)))) and v15:DebuffDown(v84.EssenceBreakDebuff) and v84.BladeDance:CooldownDown()) then
					if (((5034 - (112 + 250)) == (1863 + 2809)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
						return "fel_rush rotation 11";
					end
				end
				if ((v84.EssenceBreak:IsCastable() and v42 and ((((v14:BuffRemains(v84.MetamorphosisBuff) > (v103 * (7 - 4))) or (v84.EyeBeam:CooldownRemains() > (6 + 4))) and (not v84.TacticalRetreat:IsAvailable() or v14:BuffUp(v84.TacticalRetreatBuff) or (v10.CombatTime() < (6 + 4))) and (v84.BladeDance:CooldownRemains() <= ((3.1 + 0) * v103))) or (v107 < (3 + 3)))) or ((2725 + 943) < (1809 - (1001 + 413)))) then
					if (v24(v84.EssenceBreak, not v15:IsInRange(17 - 9)) or ((5048 - (244 + 638)) == (1148 - (627 + 66)))) then
						return "essence_break rotation 13";
					end
				end
				v127 = 5 - 3;
			end
			if ((v127 == (608 - (512 + 90))) or ((6355 - (1665 + 241)) == (3380 - (373 + 344)))) then
				if ((v84.ThrowGlaive:IsReady() and v50 and not v14:PrevGCDP(1 + 0, v84.VengefulRetreat) and not v14:IsMoving() and v84.Soulscar:IsAvailable() and (v84.ThrowGlaive:FullRechargeTime() < v84.BladeDance:CooldownRemains()) and v14:HasTier(9 + 22, 5 - 3) and v14:BuffDown(v84.FelBarrage) and not v98) or ((7237 - 2960) < (4088 - (35 + 1064)))) then
					if (v24(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((634 + 236) >= (8876 - 4727))) then
						return "throw_glaive rotation 44";
					end
				end
				if (((9 + 2203) < (4419 - (298 + 938))) and v84.ChaosStrike:IsReady() and v38 and not v97 and not v98 and v14:BuffDown(v84.FelBarrage)) then
					if (((5905 - (233 + 1026)) > (4658 - (636 + 1030))) and v24(v84.ChaosStrike, not v15:IsSpellInRange(v84.ChaosStrike))) then
						return "chaos_strike rotation 46";
					end
				end
				if (((734 + 700) < (3034 + 72)) and v84.SigilOfFlame:IsCastable() and not v14:IsMoving() and v49 and (v14:FuryDeficit() >= (9 + 21))) then
					if (((54 + 732) < (3244 - (55 + 166))) and ((v83 == "player") or v84.ConcentratedSigils:IsAvailable())) then
						if (v24(v86.SigilOfFlamePlayer, not v15:IsInRange(2 + 6)) or ((246 + 2196) < (282 - 208))) then
							return "sigil_of_flame rotation player 48";
						end
					elseif (((4832 - (36 + 261)) == (7930 - 3395)) and (v83 == "cursor")) then
						if (v24(v86.SigilOfFlameCursor, not v15:IsInRange(1398 - (34 + 1334))) or ((1157 + 1852) <= (1636 + 469))) then
							return "sigil_of_flame rotation cursor 48";
						end
					end
				end
				if (((3113 - (1035 + 248)) < (3690 - (20 + 1))) and v84.Felblade:IsCastable() and v45 and (v14:FuryDeficit() >= (21 + 19)) and not v14:PrevGCDP(320 - (134 + 185), v84.VengefulRetreat)) then
					if (v24(v84.Felblade, not v15:IsSpellInRange(v84.Felblade)) or ((2563 - (549 + 584)) >= (4297 - (314 + 371)))) then
						return "felblade rotation 50";
					end
				end
				v127 = 24 - 17;
			end
			if (((3651 - (478 + 490)) >= (1304 + 1156)) and (v127 == (1180 - (786 + 386)))) then
				if ((v84.DemonsBite:IsCastable() and v41) or ((5843 - 4039) >= (4654 - (1055 + 324)))) then
					if (v24(v84.DemonsBite, not v15:IsSpellInRange(v84.DemonsBite)) or ((2757 - (1093 + 247)) > (3225 + 404))) then
						return "demons_bite rotation 57";
					end
				end
				if (((505 + 4290) > (1596 - 1194)) and v84.FelRush:IsReady() and v35 and v46 and not v84.Momentum:IsAvailable() and (v14:BuffRemains(v84.MomentumBuff) <= (67 - 47))) then
					if (((13695 - 8882) > (8958 - 5393)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
						return "fel_rush rotation 58";
					end
				end
				if (((1392 + 2520) == (15070 - 11158)) and v84.FelRush:IsReady() and v35 and v46 and not v15:IsInRange(27 - 19) and not v84.Momentum:IsAvailable()) then
					if (((2128 + 693) <= (12336 - 7512)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
						return "fel_rush rotation 59";
					end
				end
				if (((2426 - (364 + 324)) <= (6017 - 3822)) and v84.VengefulRetreat:IsCastable() and v35 and v51 and v84.Felblade:CooldownDown() and not v84.Initiative:IsAvailable() and not v15:IsInRange(19 - 11)) then
					if (((14 + 27) <= (12628 - 9610)) and v24(v84.VengefulRetreat, not v15:IsInRange(12 - 4), nil, true)) then
						return "vengeful_retreat rotation 60";
					end
				end
				v127 = 27 - 18;
			end
			if (((3413 - (1249 + 19)) <= (3705 + 399)) and (v127 == (0 - 0))) then
				if (((3775 - (686 + 400)) < (3802 + 1043)) and v84.Annihilation:IsCastable() and v36 and v14:BuffUp(v84.InnerDemonBuff) and (v84.Metamorphosis:CooldownRemains() <= (v14:GCD() * (232 - (73 + 156))))) then
					if (v24(v84.Annihilation, not v15:IsSpellInRange(v84.Annihilation)) or ((11 + 2311) > (3433 - (721 + 90)))) then
						return "annihilation rotation 2";
					end
				end
				if ((v84.VengefulRetreat:IsCastable() and v35 and v51 and v84.Felblade:CooldownDown() and (v84.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v84.EssenceBreak:CooldownRemains() < (v103 * (6 - 4))) and (v10.CombatTime() > (475 - (224 + 246))) and (v14:Fury() >= (48 - 18)) and v84.Inertia:IsAvailable()) or ((8347 - 3813) == (378 + 1704))) then
					if (v24(v84.VengefulRetreat, not v15:IsInRange(1 + 7), nil, true) or ((1154 + 417) > (3711 - 1844))) then
						return "vengeful_retreat rotation 3";
					end
				end
				if ((v84.VengefulRetreat:IsCastable() and v35 and v51 and v84.Felblade:CooldownDown() and v84.Initiative:IsAvailable() and v84.EssenceBreak:IsAvailable() and (v10.CombatTime() > (3 - 2)) and ((v84.EssenceBreak:CooldownRemains() > (528 - (203 + 310))) or ((v84.EssenceBreak:CooldownRemains() < v103) and (not v84.Demonic:IsAvailable() or v14:BuffUp(v84.MetamorphosisBuff) or (v84.EyeBeam:CooldownRemains() > ((2008 - (1238 + 755)) + ((1 + 9) * v27(v84.CycleOfHatred:IsAvailable()))))))) and ((v10.CombatTime() < (1564 - (709 + 825))) or ((v14:GCDRemains() - (1 - 0)) < (0 - 0))) and (not v84.Initiative:IsAvailable() or (v14:BuffRemains(v84.InitiativeBuff) < v103) or (v10.CombatTime() > (868 - (196 + 668))))) or ((10478 - 7824) >= (6205 - 3209))) then
					if (((4811 - (171 + 662)) > (2197 - (4 + 89))) and v24(v84.VengefulRetreat, not v15:IsInRange(27 - 19), nil, true)) then
						return "vengeful_retreat rotation 4";
					end
				end
				if (((1091 + 1904) > (6768 - 5227)) and v84.VengefulRetreat:IsCastable() and v35 and v51 and v84.Felblade:CooldownDown() and v84.Initiative:IsAvailable() and v84.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and ((v84.EssenceBreak:CooldownRemains() > (1501 - (35 + 1451))) or ((v84.EssenceBreak:CooldownRemains() < (v103 * (1455 - (28 + 1425)))) and (((v14:BuffRemains(v84.InitiativeBuff) < v103) and not v101 and (v84.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > (2023 - (941 + 1052)))) or not v84.Demonic:IsAvailable() or v14:BuffUp(v84.MetamorphosisBuff) or (v84.EyeBeam:CooldownRemains() > (15 + 0 + ((1524 - (822 + 692)) * v27(v84.CycleofHatred:IsAvailable()))))))) and (v14:BuffDown(v84.UnboundChaosBuff) or v14:BuffUp(v84.InertiaBuff))) then
					if (((4637 - 1388) > (449 + 504)) and v24(v84.VengefulRetreat, not v15:IsInRange(305 - (45 + 252)), nil, true)) then
						return "vengeful_retreat rotation 6";
					end
				end
				v127 = 1 + 0;
			end
			if ((v127 == (2 + 2)) or ((7965 - 4692) > (5006 - (114 + 319)))) then
				if ((v84.SigilOfFlame:IsCastable() and not v14:IsMoving() and v49 and v84.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v84.EssenceBreakDebuff) and (v93 >= (5 - 1))) or ((4037 - 886) < (819 + 465))) then
					if ((v83 == "player") or v84.ConcentratedSigils:IsAvailable() or ((2756 - 906) == (3203 - 1674))) then
						if (((2784 - (556 + 1407)) < (3329 - (741 + 465))) and v24(v86.SigilOfFlamePlayer, not v15:IsInRange(473 - (170 + 295)))) then
							return "sigil_of_flame rotation player 30";
						end
					elseif (((476 + 426) < (2136 + 189)) and (v83 == "cursor")) then
						if (((2112 - 1254) <= (2456 + 506)) and v24(v86.SigilOfFlameCursor, not v15:IsInRange(26 + 14))) then
							return "sigil_of_flame rotation cursor 30";
						end
					end
				end
				if ((v84.ThrowGlaive:IsCastable() and v50 and not v14:PrevGCDP(1 + 0, v84.VengefulRetreat) and not v14:IsMoving() and v84.Soulscar:IsAvailable() and (v93 >= ((1232 - (957 + 273)) - v27(v84.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v84.EssenceBreakDebuff) and ((v84.ThrowGlaive:FullRechargeTime() < (v103 * (1 + 2))) or (v93 > (1 + 0))) and not v14:HasTier(118 - 87, 5 - 3)) or ((12052 - 8106) < (6377 - 5089))) then
					if (v24(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((5022 - (389 + 1391)) == (356 + 211))) then
						return "throw_glaive rotation 32";
					end
				end
				if ((v84.ImmolationAura:IsCastable() and v48 and (v93 >= (1 + 1)) and (v14:Fury() < (159 - 89)) and v15:DebuffDown(v84.EssenceBreakDebuff)) or ((1798 - (783 + 168)) >= (4238 - 2975))) then
					if (v24(v84.ImmolationAura, not v15:IsInRange(8 + 0)) or ((2564 - (309 + 2)) == (5684 - 3833))) then
						return "immolation_aura rotation 34";
					end
				end
				if ((v84.Annihilation:IsCastable() and v36 and not v97 and ((v84.EssenceBreak:CooldownRemains() > (1212 - (1090 + 122))) or not v84.EssenceBreak:IsAvailable()) and v14:BuffDown(v84.FelBarrage)) or v14:HasTier(10 + 20, 6 - 4) or ((1429 + 658) > (3490 - (628 + 490)))) then
					if (v24(v84.Annihilation, not v15:IsSpellInRange(v84.Annihilation)) or ((798 + 3647) < (10272 - 6123))) then
						return "annihilation rotation 36";
					end
				end
				v127 = 22 - 17;
			end
			if ((v127 == (776 - (431 + 343))) or ((3671 - 1853) == (245 - 160))) then
				if (((498 + 132) < (273 + 1854)) and v84.DeathSweep:IsCastable() and v40 and v96 and (not v84.EssenceBreak:IsAvailable() or (v84.EssenceBreak:CooldownRemains() > (v103 * (1697 - (556 + 1139))))) and v14:BuffDown(v84.FelBarrage)) then
					if (v24(v84.DeathSweep, not v15:IsInRange(23 - (6 + 9))) or ((355 + 1583) == (1288 + 1226))) then
						return "death_sweep rotation 14";
					end
				end
				if (((4424 - (28 + 141)) >= (22 + 33)) and v84.TheHunt:IsCastable() and v35 and v58 and (v75 < v107) and ((v34 and v61) or not v61) and v15:DebuffDown(v84.EssenceBreakDebuff) and ((v10.CombatTime() < (12 - 2)) or (v84.Metamorphosis:CooldownRemains() > (8 + 2))) and ((v93 == (1318 - (486 + 831))) or (v93 > (7 - 4)) or (v107 < (35 - 25))) and ((v15:DebuffDown(v84.EssenceBreakDebuff) and (not v84.FuriousGaze:IsAvailable() or v14:BuffUp(v84.FuriousGazeBuff) or v14:HasTier(6 + 25, 12 - 8))) or not v14:HasTier(1293 - (668 + 595), 2 + 0)) and (v10.CombatTime() > (3 + 7))) then
					if (((8178 - 5179) > (1446 - (23 + 267))) and v24(v84.TheHunt, not v15:IsSpellInRange(v84.TheHunt))) then
						return "the_hunt main 12";
					end
				end
				if (((4294 - (1129 + 815)) > (1542 - (371 + 16))) and v84.FelBarrage:IsCastable() and v44 and ((v93 > (1751 - (1326 + 424))) or ((v93 == (1 - 0)) and (v14:FuryDeficit() < (73 - 53)) and v14:BuffDown(v84.MetamorphosisBuff)))) then
					if (((4147 - (88 + 30)) <= (5624 - (720 + 51))) and v24(v84.FelBarrage, not v15:IsInRange(17 - 9))) then
						return "fel_barrage rotation 16";
					end
				end
				if ((v84.GlaiveTempest:IsReady() and v47 and (v15:DebuffDown(v84.EssenceBreakDebuff) or (v93 > (1777 - (421 + 1355)))) and v14:BuffDown(v84.FelBarrage)) or ((850 - 334) > (1687 + 1747))) then
					if (((5129 - (286 + 797)) >= (11087 - 8054)) and v24(v84.GlaiveTempest, not v15:IsInRange(12 - 4))) then
						return "glaive_tempest rotation 18";
					end
				end
				v127 = 442 - (397 + 42);
			end
		end
	end
	local function v117()
		v36 = EpicSettings.Settings['useAnnihilation'];
		v37 = EpicSettings.Settings['useBladeDance'];
		v38 = EpicSettings.Settings['useChaosStrike'];
		v39 = EpicSettings.Settings['useConsumeMagic'];
		v40 = EpicSettings.Settings['useDeathSweep'];
		v41 = EpicSettings.Settings['useDemonsBite'];
		v42 = EpicSettings.Settings['useEssenceBreak'];
		v43 = EpicSettings.Settings['useEyeBeam'];
		v44 = EpicSettings.Settings['useFelBarrage'];
		v45 = EpicSettings.Settings['useFelblade'];
		v46 = EpicSettings.Settings['useFelRush'];
		v47 = EpicSettings.Settings['useGlaiveTempest'];
		v48 = EpicSettings.Settings['useImmolationAura'];
		v49 = EpicSettings.Settings['useSigilOfFlame'];
		v50 = EpicSettings.Settings['useThrowGlaive'];
		v51 = EpicSettings.Settings['useVengefulRetreat'];
		v56 = EpicSettings.Settings['useElysianDecree'];
		v57 = EpicSettings.Settings['useMetamorphosis'];
		v58 = EpicSettings.Settings['useTheHunt'];
		v59 = EpicSettings.Settings['elysianDecreeWithCD'];
		v60 = EpicSettings.Settings['metamorphosisWithCD'];
		v61 = EpicSettings.Settings['theHuntWithCD'];
		v62 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v63 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
	end
	local function v118()
		v52 = EpicSettings.Settings['useChaosNova'];
		v53 = EpicSettings.Settings['useDisrupt'];
		v54 = EpicSettings.Settings['useFelEruption'];
		v55 = EpicSettings.Settings['useSigilOfMisery'];
		v64 = EpicSettings.Settings['useBlur'];
		v65 = EpicSettings.Settings['useNetherwalk'];
		v66 = EpicSettings.Settings['blurHP'] or (800 - (24 + 776));
		v67 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
		v83 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v119()
		local v156 = 785 - (222 + 563);
		while true do
			if ((v156 == (8 - 4)) or ((1958 + 761) <= (1637 - (23 + 167)))) then
				v71 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v156 == (1800 - (690 + 1108))) or ((1492 + 2642) < (3239 + 687))) then
				v77 = EpicSettings.Settings['trinketsWithCD'];
				v79 = EpicSettings.Settings['useHealthstone'];
				v78 = EpicSettings.Settings['useHealingPotion'];
				v156 = 851 - (40 + 808);
			end
			if ((v156 == (1 + 2)) or ((626 - 462) >= (2662 + 123))) then
				v81 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v82 = EpicSettings.Settings['HealingPotionName'] or "";
				v156 = 575 - (47 + 524);
			end
			if ((v156 == (0 + 0)) or ((1435 - 910) == (3153 - 1044))) then
				v75 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v68 = EpicSettings.Settings['dispelBuffs'];
				v72 = EpicSettings.Settings['InterruptWithStun'];
				v156 = 1727 - (1165 + 561);
			end
			if (((1 + 32) == (102 - 69)) and (v156 == (1 + 0))) then
				v73 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v74 = EpicSettings.Settings['InterruptThreshold'];
				v76 = EpicSettings.Settings['useTrinkets'];
				v156 = 481 - (341 + 138);
			end
		end
	end
	local function v120()
		v118();
		v117();
		v119();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['movement'];
		if (((825 + 2229) <= (8285 - 4270)) and v14:IsDeadOrGhost()) then
			return;
		end
		v91 = v14:GetEnemiesInMeleeRange(334 - (89 + 237));
		v92 = v14:GetEnemiesInMeleeRange(64 - 44);
		if (((3938 - 2067) < (4263 - (581 + 300))) and v33) then
			v93 = ((#v91 > (1220 - (855 + 365))) and #v91) or (2 - 1);
			v94 = #v92;
		else
			local v162 = 0 + 0;
			while true do
				if (((2528 - (1030 + 205)) <= (2034 + 132)) and (v162 == (0 + 0))) then
					v93 = 287 - (156 + 130);
					v94 = 2 - 1;
					break;
				end
			end
		end
		v103 = v14:GCD() + (0.05 - 0);
		if (v26.TargetIsValid() or v14:AffectingCombat() or ((5281 - 2702) < (33 + 90))) then
			v106 = v10.BossFightRemains(nil, true);
			v107 = v106;
			if ((v107 == (6480 + 4631)) or ((915 - (10 + 59)) >= (670 + 1698))) then
				v107 = v10.FightRemains(Enemies8y, false);
			end
		end
		v31 = v112();
		if (v31 or ((19758 - 15746) <= (4521 - (671 + 492)))) then
			return v31;
		end
		if (((1190 + 304) <= (4220 - (369 + 846))) and v71) then
			local v163 = 0 + 0;
			while true do
				if ((v163 == (0 + 0)) or ((5056 - (1036 + 909)) == (1697 + 437))) then
					v31 = v26.HandleIncorporeal(v84.Imprison, v86.ImprisonMouseover, 50 - 20, true);
					if (((2558 - (11 + 192)) == (1191 + 1164)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v26.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((763 - (135 + 40)) <= (1046 - 614))) then
			local v164 = 0 + 0;
			local v165;
			while true do
				if (((10567 - 5770) >= (5839 - 1944)) and ((177 - (50 + 126)) == v164)) then
					if (((9960 - 6383) == (792 + 2785)) and v84.ThrowGlaive:IsReady() and v50 and v13.ValueIsInArray(v108, v16:NPCID())) then
						if (((5207 - (1233 + 180)) > (4662 - (522 + 447))) and v24(v86.ThrowGlaiveMouseover, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v96 = v84.FirstBlood:IsAvailable() or v84.TrailofRuin:IsAvailable() or (v84.ChaosTheory:IsAvailable() and v14:BuffDown(v84.ChaosTheoryBuff)) or (v93 > (1422 - (107 + 1314)));
					v97 = v96 and (v14:Fury() < ((35 + 40) - (v27(v84.DemonBlades:IsAvailable()) * (60 - 40)))) and (v84.BladeDance:CooldownRemains() < v103);
					v98 = v84.Demonic:IsAvailable() and not v84.BlindFury:IsAvailable() and (v84.EyeBeam:CooldownRemains() < (v103 * (1 + 1))) and (v14:FuryDeficit() > (59 - 29));
					v164 = 7 - 5;
				end
				if ((v164 == (1915 - (716 + 1194))) or ((22 + 1253) == (440 + 3660))) then
					if (((v75 < v107) and v34) or ((2094 - (74 + 429)) >= (6906 - 3326))) then
						v31 = v115();
						if (((488 + 495) <= (4138 - 2330)) and v31) then
							return v31;
						end
					end
					if ((v14:BuffUp(v84.MetamorphosisBuff) and (v14:BuffRemains(v84.MetamorphosisBuff) < v103) and (v93 < (3 + 0))) or ((6628 - 4478) <= (2959 - 1762))) then
						v31 = v114();
						if (((4202 - (279 + 154)) >= (1951 - (454 + 324))) and v31) then
							return v31;
						end
					end
					v31 = v116();
					if (((1169 + 316) == (1502 - (12 + 5))) and v31) then
						return v31;
					end
					v164 = 4 + 2;
				end
				if ((v164 == (0 - 0)) or ((1225 + 2090) <= (3875 - (277 + 816)))) then
					if (not v14:AffectingCombat() or ((3743 - 2867) >= (4147 - (1058 + 125)))) then
						v31 = v113();
						if (v31 or ((419 + 1813) > (3472 - (815 + 160)))) then
							return v31;
						end
					end
					if ((v84.ConsumeMagic:IsAvailable() and v39 and v84.ConsumeMagic:IsReady() and v68 and not v14:IsCasting() and not v14:IsChanneling() and v26.UnitHasMagicBuff(v15)) or ((9053 - 6943) <= (787 - 455))) then
						if (((880 + 2806) > (9272 - 6100)) and v24(v84.ConsumeMagic, not v15:IsSpellInRange(v84.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if ((v84.FelRush:IsReady() and v35 and v46 and not v15:IsInRange(1906 - (41 + 1857))) or ((6367 - (1222 + 671)) < (2119 - 1299))) then
						if (((6150 - 1871) >= (4064 - (229 + 953))) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fel_rush rotation when OOR";
						end
					end
					if ((v84.ThrowGlaive:IsReady() and v50 and v13.ValueIsInArray(v108, v15:NPCID())) or ((3803 - (1111 + 663)) >= (5100 - (874 + 705)))) then
						if (v24(v84.ThrowGlaive, not v15:IsSpellInRange(v84.ThrowGlaive)) or ((286 + 1751) >= (3168 + 1474))) then
							return "fodder to the flames react per target";
						end
					end
					v164 = 1 - 0;
				end
				if (((49 + 1671) < (5137 - (642 + 37))) and (v164 == (1 + 2))) then
					if ((v84.ImmolationAura:IsCastable() and v48 and v84.AFireInside:IsAvailable() and v84.Inertia:IsAvailable() and v14:BuffDown(v84.UnboundChaosBuff) and (v84.ImmolationAura:FullRechargeTime() < (v103 * (1 + 1))) and v15:DebuffDown(v84.EssenceBreakDebuff)) or ((1094 - 658) > (3475 - (233 + 221)))) then
						if (((1648 - 935) <= (746 + 101)) and v24(v84.ImmolationAura, not v15:IsInRange(1549 - (718 + 823)))) then
							return "immolation_aura main 3";
						end
					end
					if (((1356 + 798) <= (4836 - (266 + 539))) and v84.FelRush:IsCastable() and v35 and v46 and v14:BuffUp(v84.UnboundChaosBuff) and (((v84.ImmolationAura:Charges() == (5 - 3)) and v15:DebuffDown(v84.EssenceBreakDebuff)) or (v14:PrevGCDP(1226 - (636 + 589), v84.EyeBeam) and v14:BuffUp(v84.InertiaBuff) and (v14:BuffRemains(v84.InertiaBuff) < (6 - 3))))) then
						if (((9518 - 4903) == (3658 + 957)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fel_rush main 4";
						end
					end
					if ((v84.TheHunt:IsCastable() and (v10.CombatTime() < (4 + 6)) and (not v84.Inertia:IsAvailable() or (v14:BuffUp(v84.MetamorphosisBuff) and v15:DebuffDown(v84.EssenceBreakDebuff)))) or ((4805 - (657 + 358)) == (1323 - 823))) then
						if (((202 - 113) < (1408 - (1151 + 36))) and v22(v84.TheHunt, not v15:IsSpellInRange(v84.TheHunt))) then
							return "the_hunt main 6";
						end
					end
					if (((1984 + 70) >= (374 + 1047)) and v84.ImmolationAura:IsCastable() and v48 and v84.Inertia:IsAvailable() and ((v84.EyeBeam:CooldownRemains() < (v103 * (5 - 3))) or v14:BuffUp(v84.MetamorphosisBuff)) and (v84.EssenceBreak:CooldownRemains() < (v103 * (1835 - (1552 + 280)))) and v14:BuffDown(v84.UnboundChaosBuff) and v14:BuffDown(v84.InertiaBuff) and v15:DebuffDown(v84.EssenceBreakDebuff)) then
						if (((1526 - (64 + 770)) < (2077 + 981)) and v24(v84.ImmolationAura, not v15:IsInRange(18 - 10))) then
							return "immolation_aura main 5";
						end
					end
					v164 = 1 + 3;
				end
				if ((v164 == (1247 - (157 + 1086))) or ((6512 - 3258) == (7248 - 5593))) then
					if ((v84.ImmolationAura:IsCastable() and v48 and v84.Inertia:IsAvailable() and v14:BuffDown(v84.UnboundChaosBuff) and ((v84.ImmolationAura:FullRechargeTime() < v84.EssenceBreak:CooldownRemains()) or not v84.EssenceBreak:IsAvailable()) and v15:DebuffDown(v84.EssenceBreakDebuff) and (v14:BuffDown(v84.MetamorphosisBuff) or (v14:BuffRemains(v84.MetamorphosisBuff) > (8 - 2))) and v84.BladeDance:CooldownDown() and ((v14:Fury() < (101 - 26)) or (v84.BladeDance:CooldownRemains() < (v103 * (821 - (599 + 220)))))) or ((2580 - 1284) == (6841 - (1813 + 118)))) then
						if (((2462 + 906) == (4585 - (841 + 376))) and v24(v84.ImmolationAura, not v15:IsInRange(10 - 2))) then
							return "immolation_aura main 6";
						end
					end
					if (((614 + 2029) < (10413 - 6598)) and v84.FelRush:IsCastable() and v35 and v46 and ((v14:BuffRemains(v84.UnboundChaosBuff) < (v103 * (861 - (464 + 395)))) or (v15:TimeToDie() < (v103 * (5 - 3))))) then
						if (((919 + 994) > (1330 - (467 + 370))) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fel_rush main 8";
						end
					end
					if (((9825 - 5070) > (2517 + 911)) and v84.FelRush:IsCastable() and v35 and v46 and v84.Inertia:IsAvailable() and v14:BuffDown(v84.InertiaBuff) and v14:BuffUp(v84.UnboundChaosBuff) and ((v84.EyeBeam:CooldownRemains() + (10 - 7)) > v14:BuffRemains(v84.UnboundChaosBuff)) and (v84.BladeDance:CooldownDown() or v84.EssenceBreak:CooldownUp())) then
						if (((216 + 1165) <= (5511 - 3142)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fel_rush main 9";
						end
					end
					if ((v84.FelRush:IsCastable() and v35 and v46 and v14:BuffUp(v84.UnboundChaosBuff) and v84.Inertia:IsAvailable() and v14:BuffDown(v84.InertiaBuff) and (v14:BuffUp(v84.MetamorphosisBuff) or (v84.EssenceBreak:CooldownRemains() > (530 - (150 + 370))))) or ((6125 - (74 + 1208)) == (10044 - 5960))) then
						if (((22143 - 17474) > (259 + 104)) and v24(v84.FelRush, not v15:IsSpellInRange(v84.ThrowGlaive))) then
							return "fel_rush main 10";
						end
					end
					v164 = 395 - (14 + 376);
				end
				if ((v164 == (10 - 4)) or ((1215 + 662) >= (2757 + 381))) then
					if (((4523 + 219) >= (10624 - 6998)) and (v84.DemonBlades:IsAvailable())) then
						if (v24(v84.Pool) or ((3416 + 1124) == (994 - (23 + 55)))) then
							return "pool demon_blades";
						end
					end
					break;
				end
				if ((v164 == (4 - 2)) or ((772 + 384) > (3902 + 443))) then
					v100 = (v84.Momentum:IsAvailable() and v14:BuffDown(v84.MomentumBuff)) or (v84.Inertia:IsAvailable() and v14:BuffDown(v84.InertiaBuff));
					v165 = v30(v84.EyeBeam:BaseDuration(), v14:GCD());
					v101 = v84.Demonic:IsAvailable() and v84.EssenceBreak:IsAvailable() and Var3MinTrinket and (v107 > (v84.Metamorphosis:CooldownRemains() + (46 - 16) + (v27(v84.ShatteredDestiny:IsAvailable()) * (19 + 41)))) and (v84.Metamorphosis:CooldownRemains() < (921 - (652 + 249))) and (v84.Metamorphosis:CooldownRemains() > (v165 + (v103 * (v27(v84.InnerDemon:IsAvailable()) + (5 - 3)))));
					if (((4105 - (708 + 1160)) < (11533 - 7284)) and v84.ImmolationAura:IsCastable() and v48 and v84.Ragefire:IsAvailable() and (v93 >= (5 - 2)) and (v84.BladeDance:CooldownDown() or v15:DebuffDown(v84.EssenceBreakDebuff))) then
						if (v24(v84.ImmolationAura, not v15:IsInRange(35 - (10 + 17))) or ((603 + 2080) < (1755 - (1400 + 332)))) then
							return "immolation_aura main 2";
						end
					end
					v164 = 5 - 2;
				end
			end
		end
	end
	local function v121()
		v84.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(2485 - (242 + 1666), v120, v121);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

