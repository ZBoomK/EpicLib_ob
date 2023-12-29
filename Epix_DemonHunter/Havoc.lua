local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1573 - 1005) > (33 + 395)) and not v5) then
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
	local v20 = v19.Press;
	local v21 = v19.Macro;
	local v22 = v19.Commons.Everyone;
	local v23 = v22.num;
	local v24 = v22.bool;
	local v25 = math.min;
	local v26 = math.max;
	local v27;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
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
	local v78 = v17.DemonHunter.Havoc;
	local v79 = v18.DemonHunter.Havoc;
	local v80 = v21.DemonHunter.Havoc;
	local v81 = {};
	local v82 = v13:GetEquipment();
	local v83 = (v82[20 - 7] and v18(v82[952 - (714 + 225)])) or v18(0 - 0);
	local v84 = (v82[19 - 5] and v18(v82[2 + 12])) or v18(0 - 0);
	local v85, v86;
	local v87, v88;
	local v89 = {{v78.FelEruption},{v78.ChaosNova}};
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = ((v78.AFireInside:IsAvailable()) and (16 - 11)) or (733 - (16 + 716));
	local v97 = v13:GCD() + (0.25 - 0);
	local v98 = 97 - (11 + 86);
	local v99 = false;
	local v100 = 27101 - 15990;
	local v101 = 11396 - (175 + 110);
	local v102 = {(835626 - 666205),(473170 - 303745),(169993 - (810 + 251)),(51998 + 117428),(169962 - (43 + 490)),(655382 - 485954),(40886 + 128544)};
	v9:RegisterForEvent(function()
		local v116 = 0 - 0;
		while true do
			if (((89 + 1245) <= (6357 - (1344 + 400))) and (v116 == (408 - (255 + 150)))) then
				v101 = 8752 + 2359;
				break;
			end
			if ((v116 == (1 + 0)) or ((7968 - 6103) >= (6553 - 4524))) then
				v92 = false;
				v93 = false;
				v116 = 1741 - (404 + 1335);
			end
			if (((5356 - (183 + 223)) >= (1966 - 350)) and (v116 == (0 + 0))) then
				v90 = false;
				v91 = false;
				v116 = 1 + 0;
			end
			if (((2062 - (10 + 327)) == (1202 + 523)) and (v116 == (340 - (118 + 220)))) then
				v94 = false;
				v100 = 3703 + 7408;
				v116 = 452 - (108 + 341);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v117 = 0 + 0;
		while true do
			if (((6168 - 4709) <= (3975 - (711 + 782))) and ((0 - 0) == v117)) then
				v82 = v13:GetEquipment();
				v83 = (v82[482 - (270 + 199)] and v18(v82[5 + 8])) or v18(1819 - (580 + 1239));
				v117 = 2 - 1;
			end
			if ((v117 == (1 + 0)) or ((97 + 2599) >= (1975 + 2557))) then
				v84 = (v82[36 - 22] and v18(v82[9 + 5])) or v18(1167 - (645 + 522));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v96 = ((v78.AFireInside:IsAvailable()) and (1795 - (1010 + 780))) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v103(v118)
		return v118:DebuffRemains(v78.BurningWoundDebuff) or v118:DebuffRemains(v78.BurningWoundLegDebuff);
	end
	local function v104(v119)
		return v78.BurningWound:IsAvailable() and (v119:DebuffRemains(v78.BurningWoundDebuff) < (19 - 15)) and (v78.BurningWoundDebuff:AuraActiveCount() < v25(v87, 8 - 5));
	end
	local function v105()
		v27 = v22.HandleTopTrinket(v81, v30, 1876 - (1045 + 791), nil);
		if (((2652 - 1604) >= (78 - 26)) and v27) then
			return v27;
		end
		v27 = v22.HandleBottomTrinket(v81, v30, 545 - (351 + 154), nil);
		if (((4532 - (1281 + 293)) < (4769 - (28 + 238))) and v27) then
			return v27;
		end
	end
	local function v106()
		if ((v78.Blur:IsCastable() and v60 and (v13:HealthPercentage() <= v62)) or ((6110 - 3375) == (2868 - (1381 + 178)))) then
			if (v20(v78.Blur) or ((3874 + 256) <= (2383 + 572))) then
				return "blur defensive";
			end
		end
		if ((v78.Netherwalk:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) or ((838 + 1126) <= (4619 - 3279))) then
			if (((1295 + 1204) == (2969 - (381 + 89))) and v20(v78.Netherwalk)) then
				return "netherwalk defensive";
			end
		end
		if ((v79.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v75)) or ((2000 + 255) < (15 + 7))) then
			if (v20(v80.Healthstone) or ((1859 - 773) >= (2561 - (1074 + 82)))) then
				return "healthstone defensive";
			end
		end
		if ((v72 and (v13:HealthPercentage() <= v74)) or ((5191 - 2822) == (2210 - (214 + 1570)))) then
			if ((v76 == "Refreshing Healing Potion") or ((4531 - (990 + 465)) > (1313 + 1870))) then
				if (((524 + 678) > (1029 + 29)) and v79.RefreshingHealingPotion:IsReady()) then
					if (((14604 - 10893) > (5081 - (1668 + 58))) and v20(v80.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v76 == "Dreamwalker's Healing Potion") or ((1532 - (512 + 114)) >= (5811 - 3582))) then
				if (((2662 - 1374) > (4352 - 3101)) and v79.DreamwalkersHealingPotion:IsReady()) then
					if (v20(v80.RefreshingHealingPotion) or ((2100 + 2413) < (628 + 2724))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v107()
		if ((v78.ImmolationAura:IsCastable() and v44) or ((1796 + 269) >= (10779 - 7583))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(2002 - (109 + 1885))) or ((5845 - (1269 + 200)) <= (2838 - 1357))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v45 and not v13:IsMoving() and (v87 > (816 - (98 + 717))) and v78.SigilOfFlame:IsCastable()) or ((4218 - (802 + 24)) >= (8175 - 3434))) then
			if (((4199 - 874) >= (319 + 1835)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(7 + 1)) or ((213 + 1082) >= (698 + 2535))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((12176 - 7799) > (5475 - 3833)) and (v77 == "cursor")) then
				if (((1690 + 3033) > (552 + 804)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(33 + 7))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if ((not v14:IsInMeleeRange(4 + 1) and v78.Felblade:IsCastable() and v41) or ((1932 + 2204) <= (4866 - (797 + 636)))) then
			if (((20610 - 16365) <= (6250 - (1427 + 192))) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
				return "felblade precombat 9";
			end
		end
		if (((1482 + 2794) >= (9086 - 5172)) and not v14:IsInMeleeRange(5 + 0) and v78.ThrowGlaive:IsCastable() and v46) then
			if (((90 + 108) <= (4691 - (192 + 134))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive precombat 9";
			end
		end
		if (((6058 - (316 + 960)) > (2603 + 2073)) and not v14:IsInMeleeRange(4 + 1) and v78.FelRush:IsCastable() and (not v78.Felblade:IsAvailable() or (v78.Felblade:CooldownUp() and not v13:PrevGCDP(1 + 0, v78.Felblade))) and v31 and v42) then
			if (((18595 - 13731) > (2748 - (83 + 468))) and v20(v78.FelRush, not v14:IsInRange(1821 - (1202 + 604)))) then
				return "fel_rush precombat 10";
			end
		end
		if ((v14:IsInMeleeRange(23 - 18) and v37 and (v78.DemonsBite:IsCastable() or v78.DemonBlades:IsAvailable())) or ((6157 - 2457) == (6941 - 4434))) then
			if (((4799 - (45 + 280)) >= (265 + 9)) and v20(v78.DemonsBite, not v14:IsInMeleeRange(5 + 0))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v108()
		if (v13:BuffDown(v78.FelBarrage) or ((692 + 1202) <= (779 + 627))) then
			local v151 = 0 + 0;
			while true do
				if (((2910 - 1338) >= (3442 - (340 + 1571))) and (v151 == (0 + 0))) then
					if ((v78.DeathSweep:IsReady() and v36) or ((6459 - (1733 + 39)) < (12480 - 7938))) then
						if (((4325 - (125 + 909)) > (3615 - (1096 + 852))) and v20(v78.DeathSweep, not v14:IsInRange(4 + 4))) then
							return "death_sweep meta_end 2";
						end
					end
					if ((v78.Annihilation:IsReady() and v32) or ((1245 - 372) == (1973 + 61))) then
						if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((3328 - (409 + 103)) < (247 - (46 + 190)))) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v109()
		if (((3794 - (51 + 44)) < (1328 + 3378)) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and not v78.Demonic:IsAvailable()) then
			if (((3963 - (1114 + 203)) >= (1602 - (228 + 498))) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(2 + 6))) then
				return "metamorphosis cooldown 4";
			end
		end
		if (((340 + 274) <= (3847 - (174 + 489))) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and v78.Demonic:IsAvailable() and ((not v78.ChaoticTransformation:IsAvailable() and v78.EyeBeam:CooldownDown()) or ((v78.EyeBeam:CooldownRemains() > (52 - 32)) and (not v90 or v13:PrevGCDP(1906 - (830 + 1075), v78.DeathSweep) or v13:PrevGCDP(526 - (303 + 221), v78.DeathSweep))) or ((v101 < ((1294 - (231 + 1038)) + (v23(v78.ShatteredDestiny:IsAvailable()) * (59 + 11)))) and v78.EyeBeam:CooldownDown() and v78.BladeDance:CooldownDown())) and v13:BuffDown(v78.InnerDemonBuff)) then
			if (((4288 - (171 + 991)) == (12882 - 9756)) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(21 - 13))) then
				return "metamorphosis cooldown 6";
			end
		end
		local v120 = v22.HandleDPSPotion(v13:BuffUp(v78.MetamorphosisBuff));
		if (v120 or ((5457 - 3270) >= (3965 + 989))) then
			return v120;
		end
		if ((v52 and not v13:IsMoving() and ((v30 and v55) or not v55) and v78.ElysianDecree:IsCastable() and (v14:DebuffDown(v78.EssenceBreakDebuff)) and (v87 > v59)) or ((13590 - 9713) == (10313 - 6738))) then
			if (((1138 - 431) > (1953 - 1321)) and (v58 == "player")) then
				if (v20(v80.ElysianDecreePlayer, not v14:IsInRange(1256 - (111 + 1137))) or ((704 - (91 + 67)) >= (7988 - 5304))) then
					return "elysian_decree cooldown 8 (Player)";
				end
			elseif (((366 + 1099) <= (4824 - (423 + 100))) and (v58 == "cursor")) then
				if (((12 + 1692) > (3945 - 2520)) and v20(v80.ElysianDecreeCursor, not v14:IsInRange(16 + 14))) then
					return "elysian_decree cooldown 8 (Cursor)";
				end
			end
		end
		if ((v69 < v101) or ((1458 - (326 + 445)) == (18476 - 14242))) then
			if ((v70 and ((v30 and v71) or not v71)) or ((7418 - 4088) < (3335 - 1906))) then
				local v165 = 711 - (530 + 181);
				while true do
					if (((2028 - (614 + 267)) >= (367 - (19 + 13))) and (v165 == (0 - 0))) then
						v27 = v105();
						if (((8004 - 4569) > (5990 - 3893)) and v27) then
							return v27;
						end
						break;
					end
				end
			end
		end
	end
	local function v110()
		if ((v78.EssenceBreak:IsCastable() and v38 and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (3 + 7)))) or ((6630 - 2860) >= (8380 - 4339))) then
			if (v20(v78.EssenceBreak, not v14:IsInRange(1820 - (1293 + 519))) or ((7734 - 3943) <= (4206 - 2595))) then
				return "essence_break rotation prio";
			end
		end
		if ((v78.BladeDance:IsCastable() and v33 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((8754 - 4176) <= (8658 - 6650))) then
			if (((2650 - 1525) <= (1100 + 976)) and v20(v78.BladeDance, not v14:IsInRange(2 + 6))) then
				return "blade_dance rotation prio";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((1725 - 982) >= (1017 + 3382))) then
			if (((384 + 771) < (1046 + 627)) and v20(v78.DeathSweep, not v14:IsInRange(1104 - (709 + 387)))) then
				return "death_sweep rotation prio";
			end
		end
		if ((v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.Metamorphosis:CooldownRemains() <= (v13:GCD() * (1861 - (673 + 1185))))) or ((6739 - 4415) <= (1855 - 1277))) then
			if (((6197 - 2430) == (2695 + 1072)) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
				return "annihilation rotation 2";
			end
		end
		if (((3056 + 1033) == (5520 - 1431)) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownUp() and (v78.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (3 - 1))) and (v9.CombatTime() > (9 - 4)) and (v13:Fury() >= (1910 - (446 + 1434))) and v78.Inertia:IsAvailable()) then
			if (((5741 - (1040 + 243)) >= (4996 - 3322)) and v20(v78.VengefulRetreat, not v14:IsInRange(1855 - (559 + 1288)), nil, true)) then
				return "vengeful_retreat rotation 3";
			end
		end
		if (((2903 - (609 + 1322)) <= (1872 - (13 + 441))) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownUp() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (3 - 2)) and ((v78.EssenceBreak:CooldownRemains() > (39 - 24)) or ((v78.EssenceBreak:CooldownRemains() < v97) and (not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((74 - 59) + ((1 + 9) * v23(v78.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (108 - 78)) or ((v13:GCDRemains() - (1 + 0)) < (0 + 0))) and (not v78.Initiative:IsAvailable() or (v13:BuffRemains(v78.InitiativeBuff) < v97) or (v9.CombatTime() > (11 - 7)))) then
			if (v20(v78.VengefulRetreat, not v14:IsInRange(5 + 3), nil, true) or ((9081 - 4143) < (3149 + 1613))) then
				return "vengeful_retreat rotation 4";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownUp() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and ((v78.EssenceBreak:CooldownRemains() > (11 + 4)) or ((v78.EssenceBreak:CooldownRemains() < (v97 * (2 + 0))) and (((v13:BuffRemains(v78.InitiativeBuff) < v97) and not v95 and (v78.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (30 + 0))) or not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((448 - (153 + 280)) + ((28 - 18) * v23(v78.CycleOfHatred:IsAvailable()))))))) and (v13:BuffDown(v78.UnboundChaosBuff) or v13:BuffUp(v78.InertiaBuff))) or ((2249 + 255) > (1684 + 2580))) then
			if (((1127 + 1026) == (1954 + 199)) and v20(v78.VengefulRetreat, not v14:IsInRange(6 + 2), nil, true)) then
				return "vengeful_retreat rotation 6";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownUp() and v78.Initiative:IsAvailable() and not v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 - 0)) and (v13:BuffDown(v78.InitiativeBuff) or (v13:PrevGCDP(1 + 0, v78.DeathSweep) and v78.Metamorphosis:CooldownUp() and v78.ChaoticTransformation:IsAvailable())) and v78.Initiative:IsAvailable()) or ((1174 - (89 + 578)) >= (1851 + 740))) then
			if (((9315 - 4834) == (5530 - (572 + 477))) and v20(v78.VengefulRetreat, not v14:IsInRange(2 + 6), nil, true)) then
				return "vengeful_retreat rotation 8";
			end
		end
		if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) < (v97 * (2 + 0))) and (v78.EyeBeam:CooldownRemains() <= v97) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) or ((278 + 2050) < (779 - (84 + 2)))) then
			if (((7132 - 2804) == (3118 + 1210)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "fel_rush rotation 10";
			end
		end
		if (((2430 - (497 + 345)) >= (35 + 1297)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or ((v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge()) and (v78.EyeBeam:CooldownRemains() > (1 + 3)))) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((5507 - (605 + 728)) > (3031 + 1217))) then
				return "fel_rush rotation 11";
			end
		end
		if ((v78.EssenceBreak:IsCastable() and v38 and ((((v13:BuffRemains(v78.MetamorphosisBuff) > (v97 * (6 - 3))) or (v78.EyeBeam:CooldownRemains() > (1 + 9))) and (not v78.TacticalRetreat:IsAvailable() or v13:BuffUp(v78.TacticalRetreatBuff) or (v9.CombatTime() < (36 - 26))) and (v78.BladeDance:CooldownRemains() <= ((3.1 + 0) * v97))) or (v101 < (16 - 10)))) or ((3463 + 1123) <= (571 - (457 + 32)))) then
			if (((1639 + 2224) == (5265 - (832 + 570))) and v20(v78.EssenceBreak, not v14:IsInRange(8 + 0))) then
				return "essence_break rotation 13";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36 and v90 and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() > (v97 * (1 + 1)))) and v13:BuffDown(v78.FelBarrage)) or ((997 - 715) <= (21 + 21))) then
			if (((5405 - (588 + 208)) >= (2064 - 1298)) and v20(v78.DeathSweep, not v14:IsInRange(1808 - (884 + 916)))) then
				return "death_sweep rotation 14";
			end
		end
		if ((v78.TheHunt:IsCastable() and v31 and v54 and (v69 < v101) and ((v30 and v57) or not v57) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v9.CombatTime() < (20 - 10)) or (v78.Metamorphosis:CooldownRemains() > (6 + 4))) and ((v87 == (654 - (232 + 421))) or (v87 > (1892 - (1569 + 320))) or (v101 < (3 + 7))) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and (not v78.FuriousGaze:IsAvailable() or v13:BuffUp(v78.FuriousGazeBuff) or v13:HasTier(6 + 25, 13 - 9))) or not v13:HasTier(635 - (316 + 289), 5 - 3)) and (v9.CombatTime() > (1 + 9))) or ((2605 - (666 + 787)) == (2913 - (360 + 65)))) then
			if (((3199 + 223) > (3604 - (79 + 175))) and v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt))) then
				return "the_hunt main 12";
			end
		end
		if (((1382 - 505) > (294 + 82)) and v78.FelBarrage:IsCastable() and v40 and ((v87 > (2 - 1)) or ((v87 == (1 - 0)) and (v13:FuryDeficit() < (919 - (503 + 396))) and v13:BuffDown(v78.MetamorphosisBuff)))) then
			if (v20(v78.FelBarrage, not v14:IsInRange(189 - (92 + 89))) or ((6048 - 2930) <= (950 + 901))) then
				return "fel_barrage rotation 16";
			end
		end
		if ((v78.GlaiveTempest:IsReady() and v43 and (v14:DebuffDown(v78.EssenceBreakDebuff) or (v87 > (1 + 0))) and v13:BuffDown(v78.FelBarrage)) or ((646 - 481) >= (478 + 3014))) then
			if (((9003 - 5054) < (4237 + 619)) and v20(v78.GlaiveTempest, not v14:IsInRange(4 + 4))) then
				return "glaive_tempest rotation 18";
			end
		end
		if ((v78.Annihilation:IsReady() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v78.FelBarrage)) or ((13023 - 8747) < (377 + 2639))) then
			if (((7152 - 2462) > (5369 - (485 + 759))) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
				return "annihilation rotation 20";
			end
		end
		if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Momentum:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (6 - 3))) and (v13:BuffRemains(v78.MomentumBuff) < (1194 - (442 + 747))) and v13:BuffDown(v78.MetamorphosisBuff)) or ((1185 - (832 + 303)) >= (1842 - (88 + 858)))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((523 + 1191) >= (2449 + 509))) then
				return "fel_rush rotation 22";
			end
		end
		if ((v78.EyeBeam:IsCastable() and v39 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.Metamorphosis:CooldownRemains() > ((819 - (766 + 23)) - (v23(v78.CycleOfHatred:IsAvailable()) * (74 - 59)))) or ((v78.Metamorphosis:CooldownRemains() < (v97 * (2 - 0))) and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() < (v97 * (2.5 - 1)))))) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > v97) or not v78.RestlessHunter:IsAvailable()) and (v78.CycleOfHatred:IsAvailable() or not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (16 - 11)) or not v47 or (v9.CombatTime() < (1083 - (1036 + 37)))) and v13:BuffDown(v78.InnerDemonBuff)) or (v101 < (11 + 4)))) or ((2903 - 1412) < (507 + 137))) then
			if (((2184 - (641 + 839)) < (1900 - (910 + 3))) and v20(v78.EyeBeam, not v14:IsInRange(20 - 12))) then
				return "eye_beam rotation 26";
			end
		end
		if (((5402 - (1466 + 218)) > (876 + 1030)) and v78.BladeDance:IsCastable() and v33 and v90 and ((v78.EyeBeam:CooldownRemains() > (1153 - (556 + 592))) or not v78.Demonic:IsAvailable() or v13:HasTier(12 + 19, 810 - (329 + 479)))) then
			if (v20(v78.BladeDance, not v14:IsInRange(862 - (174 + 680))) or ((3291 - 2333) > (7534 - 3899))) then
				return "blade_dance rotation 28";
			end
		end
		if (((2500 + 1001) <= (5231 - (396 + 343))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff) and (v87 >= (1 + 3))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((4919 - (29 + 1448)) < (3937 - (135 + 1254)))) then
				if (((10830 - 7955) >= (6835 - 5371)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(6 + 2))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif ((v77 == "cursor") or ((6324 - (389 + 1138)) >= (5467 - (102 + 472)))) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(38 + 2)) or ((306 + 245) > (1929 + 139))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if (((3659 - (320 + 1225)) > (1680 - 736)) and v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v87 >= ((1466 - (157 + 1307)) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.ThrowGlaive:FullRechargeTime() < (v97 * (1862 - (821 + 1038)))) or (v87 > (2 - 1))) and not v13:HasTier(4 + 27, 3 - 1)) then
			if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((842 + 1420) >= (7673 - 4577))) then
				return "throw_glaive rotation 32";
			end
		end
		if ((v78.ImmolationAura:IsCastable() and v44 and (v87 >= (1028 - (834 + 192))) and (v13:Fury() < (5 + 65)) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((579 + 1676) >= (76 + 3461))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(12 - 4)) or ((4141 - (300 + 4)) < (349 + 957))) then
				return "immolation_aura rotation 34";
			end
		end
		if (((7722 - 4772) == (3312 - (112 + 250))) and ((v78.Annihilation:IsCastable() and v32 and not v91 and ((v78.EssenceBreak:CooldownRemains() > (0 + 0)) or not v78.EssenceBreak:IsAvailable()) and v13:BuffDown(v78.FelBarrage)) or v13:HasTier(75 - 45, 2 + 0))) then
			if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((2443 + 2280) < (2467 + 831))) then
				return "annihilation rotation 36";
			end
		end
		if (((564 + 572) >= (115 + 39)) and v78.Felblade:IsCastable() and v41 and (((v13:FuryDeficit() >= (1454 - (1001 + 413))) and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)))) then
			if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((604 - 333) > (5630 - (244 + 638)))) then
				return "felblade rotation 38";
			end
		end
		if (((5433 - (627 + 66)) >= (9391 - 6239)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (632 - (512 + 90)))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((4484 - (1665 + 241)) >= (4107 - (373 + 344)))) then
				if (((19 + 22) <= (440 + 1221)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(20 - 12))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif (((1016 - 415) < (4659 - (35 + 1064))) and (v77 == "cursor")) then
				if (((171 + 64) < (1469 - 782)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(1 + 39))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if (((5785 - (298 + 938)) > (2412 - (233 + 1026))) and v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(1667 - (636 + 1030), v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v88 >= ((2 + 0) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and not v13:HasTier(31 + 0, 1 + 1)) then
			if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((316 + 4358) < (4893 - (55 + 166)))) then
				return "throw_glaive rotation 40";
			end
		end
		if (((711 + 2957) < (459 + 4102)) and v78.ImmolationAura:IsCastable() and v44 and (v13:BuffStack(v78.ImmolationAuraBuff) < v96) and v14:IsInRange(30 - 22) and (v13:BuffDown(v78.UnboundChaosBuff) or not v78.UnboundChaos:IsAvailable()) and ((v78.ImmolationAura:Recharge() < v78.EssenceBreak:CooldownRemains()) or (not v78.EssenceBreak:IsAvailable() and (v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge())))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(305 - (36 + 261))) or ((795 - 340) == (4973 - (34 + 1334)))) then
				return "immolation_aura rotation 42";
			end
		end
		if ((v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v78.ThrowGlaive:FullRechargeTime() < v78.BladeDance:CooldownRemains()) and v13:HasTier(25 + 6, 1285 - (1035 + 248)) and v13:BuffDown(v78.FelBarrage) and not v92) or ((2684 - (20 + 1)) == (1726 + 1586))) then
			if (((4596 - (134 + 185)) <= (5608 - (549 + 584))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 44";
			end
		end
		if ((v78.ChaosStrike:IsReady() and v34 and not v91 and not v92 and v13:BuffDown(v78.FelBarrage)) or ((1555 - (314 + 371)) == (4081 - 2892))) then
			if (((2521 - (478 + 490)) <= (1660 + 1473)) and v20(v78.ChaosStrike, not v14:IsSpellInRange(v78.ChaosStrike))) then
				return "chaos_strike rotation 46";
			end
		end
		if ((v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and (v13:FuryDeficit() >= (1202 - (786 + 386)))) or ((7245 - 5008) >= (4890 - (1055 + 324)))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((2664 - (1093 + 247)) > (2684 + 336))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1 + 7)) or ((11878 - 8886) == (6383 - 4502))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((8838 - 5732) > (3834 - 2308)) and (v77 == "cursor")) then
				if (((1076 + 1947) < (14908 - 11038)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(103 - 73))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if (((108 + 35) > (188 - 114)) and v78.Felblade:IsCastable() and v41 and (v13:FuryDeficit() >= (728 - (364 + 324)))) then
			if (((49 - 31) < (5067 - 2955)) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
				return "felblade rotation 50";
			end
		end
		if (((364 + 733) <= (6812 - 5184)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and v78.DemonBlades:IsAvailable() and v78.EyeBeam:CooldownDown() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.FelRush:Recharge() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable())) then
			if (((7415 - 2785) == (14061 - 9431)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "fel_rush rotation 52";
			end
		end
		if (((4808 - (1249 + 19)) > (2422 + 261)) and v78.DemonsBite:IsCastable() and v37 and v78.BurningWound:IsAvailable() and (v14:DebuffRemains(v78.BurningWoundDebuff) < (15 - 11))) then
			if (((5880 - (686 + 400)) >= (2570 + 705)) and v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite))) then
				return "demons_bite rotation 54";
			end
		end
		if (((1713 - (73 + 156)) == (8 + 1476)) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and not v78.DemonBlades:IsAvailable() and (v87 > (812 - (721 + 90))) and v13:BuffDown(v78.UnboundChaosBuff)) then
			if (((17 + 1415) < (11542 - 7987)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "fel_rush rotation 56";
			end
		end
		if ((v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (500 - (224 + 246))) and v14:IsInRange(48 - 18)) or ((1960 - 895) > (650 + 2928))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((115 + 4680) < (1034 + 373))) then
				if (((3683 - 1830) < (16016 - 11203)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(521 - (203 + 310)))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif ((v77 == "cursor") or ((4814 - (1238 + 755)) < (170 + 2261))) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(1564 - (709 + 825))) or ((5295 - 2421) < (3176 - 995))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if ((v78.DemonsBite:IsCastable() and v37) or ((3553 - (196 + 668)) <= (1354 - 1011))) then
			if (v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite)) or ((3871 - 2002) == (2842 - (171 + 662)))) then
				return "demons_bite rotation 57";
			end
		end
		if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) <= (113 - (4 + 89)))) or ((12428 - 8882) < (846 + 1476))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((9144 - 7062) == (1872 + 2901))) then
				return "fel_rush rotation 58";
			end
		end
		if (((4730 - (35 + 1451)) > (2508 - (28 + 1425))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and not v14:IsInRange(2001 - (941 + 1052)) and not v78.Momentum:IsAvailable()) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3177 + 136) <= (3292 - (822 + 692)))) then
				return "fel_rush rotation 59";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownUp() and not v78.Initiative:IsAvailable() and not v14:IsInRange(11 - 3)) or ((670 + 751) >= (2401 - (45 + 252)))) then
			if (((1793 + 19) <= (1119 + 2130)) and v20(v78.VengefulRetreat, not v14:IsInRange(19 - 11), nil, true)) then
				return "vengeful_retreat rotation 60";
			end
		end
		if (((2056 - (114 + 319)) <= (2809 - 852)) and v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 - 0, v78.VengefulRetreat) and not v13:IsMoving() and (v78.DemonBlades:IsAvailable() or not v14:IsInRange(8 + 4)) and v14:DebuffDown(v78.EssenceBreakDebuff) and v14:IsSpellInRange(v78.ThrowGlaive) and not v13:HasTier(45 - 14, 3 - 1)) then
			if (((6375 - (556 + 1407)) == (5618 - (741 + 465))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v111()
		v32 = EpicSettings.Settings['useAnnihilation'];
		v33 = EpicSettings.Settings['useBladeDance'];
		v34 = EpicSettings.Settings['useChaosStrike'];
		v35 = EpicSettings.Settings['useConsumeMagic'];
		v36 = EpicSettings.Settings['useDeathSweep'];
		v37 = EpicSettings.Settings['useDemonsBite'];
		v38 = EpicSettings.Settings['useEssenceBreak'];
		v39 = EpicSettings.Settings['useEyeBeam'];
		v40 = EpicSettings.Settings['useFelBarrage'];
		v41 = EpicSettings.Settings['useFelblade'];
		v42 = EpicSettings.Settings['useFelRush'];
		v43 = EpicSettings.Settings['useGlaiveTempest'];
		v44 = EpicSettings.Settings['useImmolationAura'];
		v45 = EpicSettings.Settings['useSigilOfFlame'];
		v46 = EpicSettings.Settings['useThrowGlaive'];
		v47 = EpicSettings.Settings['useVengefulRetreat'];
		v52 = EpicSettings.Settings['useElysianDecree'];
		v53 = EpicSettings.Settings['useMetamorphosis'];
		v54 = EpicSettings.Settings['useTheHunt'];
		v55 = EpicSettings.Settings['elysianDecreeWithCD'];
		v56 = EpicSettings.Settings['metamorphosisWithCD'];
		v57 = EpicSettings.Settings['theHuntWithCD'];
		v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v59 = EpicSettings.Settings['elysianDecreeSlider'] or (465 - (170 + 295));
	end
	local function v112()
		v48 = EpicSettings.Settings['useChaosNova'];
		v49 = EpicSettings.Settings['useDisrupt'];
		v50 = EpicSettings.Settings['useFelEruption'];
		v51 = EpicSettings.Settings['useSigilOfMisery'];
		v60 = EpicSettings.Settings['useBlur'];
		v61 = EpicSettings.Settings['useNetherwalk'];
		v62 = EpicSettings.Settings['blurHP'] or (0 + 0);
		v63 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v77 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v113()
		local v149 = 0 - 0;
		while true do
			if (((1451 + 299) >= (540 + 302)) and (v149 == (2 + 0))) then
				v71 = EpicSettings.Settings['trinketsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v72 = EpicSettings.Settings['useHealingPotion'];
				v149 = 1233 - (957 + 273);
			end
			if (((1170 + 3202) > (741 + 1109)) and (v149 == (11 - 8))) then
				v75 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v74 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v76 = EpicSettings.Settings['HealingPotionName'] or "";
				v149 = 19 - 15;
			end
			if (((2012 - (389 + 1391)) < (516 + 305)) and (v149 == (1 + 0))) then
				v67 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v68 = EpicSettings.Settings['InterruptThreshold'];
				v70 = EpicSettings.Settings['useTrinkets'];
				v149 = 4 - 2;
			end
			if (((1469 - (783 + 168)) < (3027 - 2125)) and (v149 == (4 + 0))) then
				v65 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((3305 - (309 + 2)) > (2634 - 1776)) and (v149 == (1212 - (1090 + 122)))) then
				v69 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v64 = EpicSettings.Settings['dispelBuffs'];
				v66 = EpicSettings.Settings['InterruptWithStun'];
				v149 = 3 - 2;
			end
		end
	end
	local function v114()
		local v150 = 0 + 0;
		while true do
			if ((v150 == (1118 - (628 + 490))) or ((674 + 3081) <= (2265 - 1350))) then
				v112();
				v111();
				v113();
				v150 = 4 - 3;
			end
			if (((4720 - (431 + 343)) > (7559 - 3816)) and (v150 == (2 - 1))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v150 = 2 + 0;
			end
			if ((v150 == (1 + 2)) or ((3030 - (556 + 1139)) >= (3321 - (6 + 9)))) then
				v86 = v13:GetEnemiesInMeleeRange(4 + 16);
				if (((2482 + 2362) > (2422 - (28 + 141))) and v29) then
					v87 = ((#v85 > (0 + 0)) and #v85) or (1 - 0);
					v88 = #v86;
				else
					v87 = 1 + 0;
					v88 = 1318 - (486 + 831);
				end
				v97 = v13:GCD() + (0.05 - 0);
				v150 = 13 - 9;
			end
			if (((86 + 366) == (1429 - 977)) and (v150 == (1268 - (668 + 595)))) then
				if (v65 or ((4101 + 456) < (421 + 1666))) then
					v27 = v22.HandleIncorporeal(v78.Imprison, v80.ImprisonMouseover, 81 - 51, true);
					if (((4164 - (23 + 267)) == (5818 - (1129 + 815))) and v27) then
						return v27;
					end
				end
				if ((v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((2325 - (371 + 16)) > (6685 - (1326 + 424)))) then
					if (not v13:AffectingCombat() or ((8058 - 3803) < (12508 - 9085))) then
						v27 = v107();
						if (((1572 - (88 + 30)) <= (3262 - (720 + 51))) and v27) then
							return v27;
						end
					end
					if ((v78.ConsumeMagic:IsAvailable() and v35 and v78.ConsumeMagic:IsReady() and v64 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) or ((9247 - 5090) <= (4579 - (421 + 1355)))) then
						if (((8006 - 3153) >= (1465 + 1517)) and v20(v78.ConsumeMagic, not v14:IsSpellInRange(v78.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if (((5217 - (286 + 797)) > (12271 - 8914)) and v78.Felblade:IsCastable() and v41 and v13:PrevGCDP(1 - 0, v78.VengefulRetreat)) then
						if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((3856 - (397 + 42)) < (792 + 1742))) then
							return "felblade rotation 1";
						end
					end
					if ((v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v14:NPCID())) or ((3522 - (24 + 776)) <= (252 - 88))) then
						if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3193 - (222 + 563)) < (4646 - 2537))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v15:NPCID())) or ((24 + 9) == (1645 - (23 + 167)))) then
						if (v20(v80.ThrowGlaiveMouseover, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2241 - (690 + 1108)) >= (1449 + 2566))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v90 = v78.FirstBlood:IsAvailable() or v78.TrailofRuin:IsAvailable() or (v78.ChaosTheory:IsAvailable() and v13:BuffDown(v78.ChaosTheoryBuff)) or (v87 > (1 + 0));
					v91 = v90 and (v13:Fury() < ((923 - (40 + 808)) - (v23(v78.DemonBlades:IsAvailable()) * (4 + 16)))) and (v78.BladeDance:CooldownRemains() < v97);
					v92 = v78.Demonic:IsAvailable() and not v78.BlindFury:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (7 - 5))) and (v13:FuryDeficit() > (29 + 1));
					v94 = (v78.Momentum:IsAvailable() and v13:BuffDown(v78.MomentumBuff)) or (v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff));
					local v166 = v26(v78.EyeBeam:BaseDuration(), v13:GCD());
					v95 = v78.Demonic:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v101 > (v78.Metamorphosis:CooldownRemains() + 16 + 14 + (v23(v78.ShatteredDestiny:IsAvailable()) * (33 + 27)))) and (v78.Metamorphosis:CooldownRemains() < (591 - (47 + 524))) and (v78.Metamorphosis:CooldownRemains() > (v166 + (v97 * (v23(v78.InnerDemon:IsAvailable()) + 2 + 0))));
					if (((9244 - 5862) > (247 - 81)) and v78.ImmolationAura:IsCastable() and v44 and v78.Ragefire:IsAvailable() and (v87 >= (6 - 3)) and (v78.BladeDance:CooldownDown() or v14:DebuffDown(v78.EssenceBreakDebuff))) then
						if (v20(v78.ImmolationAura, not v14:IsInRange(1734 - (1165 + 561))) or ((9 + 271) == (9473 - 6414))) then
							return "immolation_aura main 2";
						end
					end
					if (((718 + 1163) > (1772 - (341 + 138))) and v78.ImmolationAura:IsCastable() and v44 and v78.AFireInside:IsAvailable() and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (v78.ImmolationAura:FullRechargeTime() < (v97 * (1 + 1))) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
						if (((4863 - 2506) == (2683 - (89 + 237))) and v20(v78.ImmolationAura, not v14:IsInRange(25 - 17))) then
							return "immolation_aura main 3";
						end
					end
					if (((258 - 135) == (1004 - (581 + 300))) and v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and (((v78.ImmolationAura:Charges() == (1222 - (855 + 365))) and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v13:PrevGCDP(2 - 1, v78.EyeBeam) and v13:BuffUp(v78.InertiaBuff) and (v13:BuffRemains(v78.InertiaBuff) < (1 + 2))))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2291 - (1030 + 205)) >= (3185 + 207))) then
							return "fel_rush main 4";
						end
					end
					if ((v78.TheHunt:IsCastable() and (v9.CombatTime() < (10 + 0)) and (not v78.Inertia:IsAvailable() or (v13:BuffUp(v78.MetamorphosisBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)))) or ((1367 - (156 + 130)) < (2442 - 1367))) then
						if (v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt)) or ((1767 - 718) >= (9076 - 4644))) then
							return "the_hunt main 6";
						end
					end
					if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and ((v78.EyeBeam:CooldownRemains() < (v97 * (1 + 1))) or v13:BuffUp(v78.MetamorphosisBuff)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (2 + 1))) and v13:BuffDown(v78.UnboundChaosBuff) and v13:BuffDown(v78.InertiaBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((4837 - (10 + 59)) <= (240 + 606))) then
						if (v20(v78.ImmolationAura, not v14:IsInRange(39 - 31)) or ((4521 - (671 + 492)) <= (1131 + 289))) then
							return "immolation_aura main 5";
						end
					end
					if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.ImmolationAura:FullRechargeTime() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable()) and v14:DebuffDown(v78.EssenceBreakDebuff) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > (1221 - (369 + 846)))) and v78.BladeDance:CooldownDown() and ((v13:Fury() < (20 + 55)) or (v78.BladeDance:CooldownRemains() < (v97 * (2 + 0))))) or ((5684 - (1036 + 909)) <= (2390 + 615))) then
						if (v20(v78.ImmolationAura, not v14:IsInRange(13 - 5)) or ((1862 - (11 + 192)) >= (1079 + 1055))) then
							return "immolation_aura main 6";
						end
					end
					if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and ((v13:BuffRemains(v78.UnboundChaosBuff) < (v97 * (177 - (135 + 40)))) or (v14:TimeToDie() < (v97 * (4 - 2))))) or ((1966 + 1294) < (5187 - 2832))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((1002 - 333) == (4399 - (50 + 126)))) then
							return "fel_rush main 8";
						end
					end
					if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and ((v78.EyeBeam:CooldownRemains() + (8 - 5)) > v13:BuffRemains(v78.UnboundChaosBuff)) and (v78.BladeDance:CooldownDown() or v78.EssenceBreak:CooldownUp())) or ((375 + 1317) < (2001 - (1233 + 180)))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((5766 - (522 + 447)) < (5072 - (107 + 1314)))) then
							return "fel_rush main 9";
						end
					end
					if ((v78.FelRush:IsCastable() and v13:BuffUp(v78.UnboundChaosBuff) and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EssenceBreak:CooldownRemains() > (5 + 5)))) or ((12727 - 8550) > (2060 + 2790))) then
						if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((794 - 394) > (4395 - 3284))) then
							return "fel_rush main 10";
						end
					end
					if (((4961 - (716 + 1194)) > (18 + 987)) and (v69 < v101) and v30) then
						v27 = v109();
						if (((396 + 3297) <= (4885 - (74 + 429))) and v27) then
							return v27;
						end
					end
					if ((v13:BuffUp(v78.MetamorphosisBuff) and (v13:BuffRemains(v78.MetamorphosisBuff) < v97) and (v87 < (5 - 2))) or ((1627 + 1655) > (9385 - 5285))) then
						v27 = v108();
						if (v27 or ((2533 + 1047) < (8767 - 5923))) then
							return v27;
						end
					end
					v27 = v110();
					if (((219 - 130) < (4923 - (279 + 154))) and v27) then
						return v27;
					end
					if ((v78.DemonBlades:IsAvailable()) or ((5761 - (454 + 324)) < (1423 + 385))) then
						if (((3846 - (12 + 5)) > (2033 + 1736)) and v20(v78.Pool)) then
							return "pool demon_blades";
						end
					end
				end
				break;
			end
			if (((3783 - 2298) <= (1074 + 1830)) and (v150 == (1097 - (277 + 816)))) then
				if (((18241 - 13972) == (5452 - (1058 + 125))) and (v22.TargetIsValid() or v13:AffectingCombat())) then
					local v167 = 0 + 0;
					while true do
						if (((1362 - (815 + 160)) <= (11936 - 9154)) and (v167 == (0 - 0))) then
							v100 = v9.BossFightRemains(nil, true);
							v101 = v100;
							v167 = 1 + 0;
						end
						if ((v167 == (2 - 1)) or ((3797 - (41 + 1857)) <= (2810 - (1222 + 671)))) then
							if ((v101 == (28717 - 17606)) or ((6197 - 1885) <= (2058 - (229 + 953)))) then
								v101 = v9.FightRemains(v85, false);
							end
							break;
						end
					end
				end
				v27 = v106();
				if (((4006 - (1111 + 663)) <= (4175 - (874 + 705))) and v27) then
					return v27;
				end
				v150 = 1 + 4;
			end
			if (((1430 + 665) < (7661 - 3975)) and ((1 + 1) == v150)) then
				v31 = EpicSettings.Toggles['movement'];
				if (v13:IsDeadOrGhost() or ((2274 - (642 + 37)) >= (1021 + 3453))) then
					return v27;
				end
				v85 = v13:GetEnemiesInMeleeRange(2 + 6);
				v150 = 7 - 4;
			end
		end
	end
	local function v115()
		v78.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1031 - (233 + 221), v114, v115);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

