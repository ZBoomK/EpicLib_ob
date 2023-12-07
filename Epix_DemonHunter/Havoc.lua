local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1470 - (428 + 722)) <= (98 - 46))) then
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
	local v88 = (v87[38 - 25] and v18(v87[13 + 0])) or v18(0 + 0);
	local v89 = (v87[7 + 7] and v18(v87[36 - 22])) or v18(0 + 0);
	local v90, v91;
	local v92, v93;
	local v94 = {{v83.FelEruption},{v83.ChaosNova}};
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = ((v83.AFireInside:IsAvailable()) and (14 - 9)) or (1837 - (1045 + 791));
	local v102 = v13:GCD() + (0.25 - 0);
	local v103 = 0 - 0;
	local v104 = false;
	local v105 = 11616 - (351 + 154);
	local v106 = 12685 - (1281 + 293);
	local v107 = {(378566 - 209145),(158911 + 10514),(72060 + 96872),(87774 + 81652),(150248 + 19181),(290228 - 120800),(371301 - 201871)};
	v9:RegisterForEvent(function()
		v95 = false;
		v96 = false;
		v97 = false;
		v98 = false;
		v99 = false;
		v105 = 12895 - (214 + 1570);
		v106 = 12566 - (990 + 465);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v121 = 0 + 0;
		while true do
			if (((570 + 739) <= (3410 + 96)) and (v121 == (0 - 0))) then
				v87 = v13:GetEquipment();
				v88 = (v87[1739 - (1668 + 58)] and v18(v87[639 - (512 + 114)])) or v18(0 - 0);
				v121 = 1 - 0;
			end
			if (((10282 - 7327) == (1375 + 1580)) and (v121 == (1 + 0))) then
				v89 = (v87[13 + 1] and v18(v87[47 - 33])) or v18(1994 - (109 + 1885));
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v101 = ((v83.AFireInside:IsAvailable()) and (1474 - (1269 + 200))) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v108(v122)
		return v122:DebuffRemains(v83.BurningWoundDebuff) or v122:DebuffRemains(v83.BurningWoundLegDebuff);
	end
	local function v109(v123)
		return v83.BurningWound:IsAvailable() and (v123:DebuffRemains(v83.BurningWoundDebuff) < (819 - (98 + 717))) and (v83.BurningWoundDebuff:AuraActiveCount() < v28(v92, 829 - (802 + 24)));
	end
	local function v110()
		local v124 = 0 - 0;
		while true do
			if (((1 - 0) == v124) or ((429 + 2474) == (1149 + 346))) then
				v30 = v25.HandleBottomTrinket(v86, v33, 7 + 33, nil);
				if (((981 + 3565) >= (6328 - 4053)) and v30) then
					return v30;
				end
				break;
			end
			if (((2730 - 1911) >= (8 + 14)) and (v124 == (0 + 0))) then
				v30 = v25.HandleTopTrinket(v86, v33, 33 + 7, nil);
				if (((2300 + 862) == (1477 + 1685)) and v30) then
					return v30;
				end
				v124 = 1434 - (797 + 636);
			end
		end
	end
	local function v111()
		if ((v83.Blur:IsCastable() and v63 and (v13:HealthPercentage() <= v65)) or ((11502 - 9133) > (6048 - (1427 + 192)))) then
			if (((1419 + 2676) >= (7389 - 4206)) and v23(v83.Blur)) then
				return "blur defensive";
			end
		end
		if ((v83.Netherwalk:IsCastable() and v64 and (v13:HealthPercentage() <= v66)) or ((3336 + 375) < (457 + 551))) then
			if (v23(v83.Netherwalk) or ((1375 - (192 + 134)) <= (2182 - (316 + 960)))) then
				return "netherwalk defensive";
			end
		end
		if (((2512 + 2001) > (2104 + 622)) and v84.Healthstone:IsReady() and v78 and (v13:HealthPercentage() <= v80)) then
			if (v23(v85.Healthstone) or ((1369 + 112) >= (10161 - 7503))) then
				return "healthstone defensive";
			end
		end
		if ((v77 and (v13:HealthPercentage() <= v79)) or ((3771 - (83 + 468)) == (3170 - (1202 + 604)))) then
			local v133 = 0 - 0;
			while true do
				if ((v133 == (0 - 0)) or ((2918 - 1864) > (3717 - (45 + 280)))) then
					if ((v81 == "Refreshing Healing Potion") or ((653 + 23) >= (1435 + 207))) then
						if (((1511 + 2625) > (1327 + 1070)) and v84.RefreshingHealingPotion:IsReady()) then
							if (v23(v85.RefreshingHealingPotion) or ((763 + 3571) == (7860 - 3615))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v81 == "Dreamwalker's Healing Potion") or ((6187 - (340 + 1571)) <= (1196 + 1835))) then
						if (v84.DreamwalkersHealingPotion:IsReady() or ((6554 - (1733 + 39)) <= (3294 - 2095))) then
							if (v23(v85.RefreshingHealingPotion) or ((5898 - (125 + 909)) < (3850 - (1096 + 852)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v112()
		if (((2171 + 2668) >= (5283 - 1583)) and v83.ImmolationAura:IsCastable() and v47) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(8 + 0)) or ((1587 - (409 + 103)) > (2154 - (46 + 190)))) then
				return "immolation_aura precombat 8";
			end
		end
		if (((491 - (51 + 44)) <= (1073 + 2731)) and v48 and not v13:IsMoving() and (v92 > (1318 - (1114 + 203))) and v83.SigilOfFlame:IsCastable()) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((4895 - (228 + 498)) == (474 + 1713))) then
				if (((777 + 629) == (2069 - (174 + 489))) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(20 - 12))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((3436 - (830 + 1075)) < (4795 - (303 + 221))) and (v82 == "cursor")) then
				if (((1904 - (231 + 1038)) == (530 + 105)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(1202 - (171 + 991)))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((13900 - 10527) <= (9548 - 5992)) and not v14:IsInMeleeRange(12 - 7) and v83.Felblade:IsCastable()) then
			if (v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade)) or ((2634 + 657) < (11497 - 8217))) then
				return "felblade precombat 9";
			end
		end
		if (((12652 - 8266) >= (1407 - 534)) and not v14:IsInMeleeRange(15 - 10) and v83.FelRush:IsCastable() and (not v83.Felblade:IsAvailable() or (v83.Felblade:CooldownDown() and not v13:PrevGCDP(1249 - (111 + 1137), v83.Felblade))) and v34 and v45) then
			if (((1079 - (91 + 67)) <= (3279 - 2177)) and v23(v83.FelRush, not v14:IsInRange(4 + 11))) then
				return "fel_rush precombat 10";
			end
		end
		if (((5229 - (423 + 100)) >= (7 + 956)) and v14:IsInMeleeRange(13 - 8) and v40 and (v83.DemonsBite:IsCastable() or v83.DemonBlades:IsAvailable())) then
			if (v23(v83.DemonsBite, not v14:IsInMeleeRange(3 + 2)) or ((1731 - (326 + 445)) <= (3822 - 2946))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v113()
		if (v13:BuffDown(v83.FelBarrage) or ((4602 - 2536) == (2175 - 1243))) then
			local v134 = 711 - (530 + 181);
			while true do
				if (((5706 - (614 + 267)) < (4875 - (19 + 13))) and (v134 == (0 - 0))) then
					if ((v83.DeathSweep:IsReady() and v39) or ((9034 - 5157) >= (12960 - 8423))) then
						if (v23(v83.DeathSweep, not v14:IsInRange(3 + 5)) or ((7588 - 3273) < (3579 - 1853))) then
							return "death_sweep meta_end 2";
						end
					end
					if ((v83.Annihilation:IsReady() and v35) or ((5491 - (1293 + 519)) < (1275 - 650))) then
						if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((12075 - 7450) < (1208 - 576))) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v114()
		if ((((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and not v83.Demonic:IsAvailable()) or ((357 - 274) > (4193 - 2413))) then
			if (((290 + 256) <= (220 + 857)) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(18 - 10))) then
				return "metamorphosis cooldown 4";
			end
		end
		if ((((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and v83.Demonic:IsAvailable() and ((not v83.ChaoticTransformation:IsAvailable() and v83.EyeBeam:CooldownDown()) or ((v83.EyeBeam:CooldownRemains() > (5 + 15)) and (not v95 or v13:PrevGCDP(1 + 0, v83.DeathSweep) or v13:PrevGCDP(2 + 0, v83.DeathSweep))) or ((v106 < ((1121 - (709 + 387)) + (v26(v83.ShatteredDestiny:IsAvailable()) * (1928 - (673 + 1185))))) and v83.EyeBeam:CooldownDown() and v83.BladeDance:CooldownDown())) and v13:BuffDown(v83.InnerDemonBuff)) or ((2888 - 1892) > (13811 - 9510))) then
			if (((6696 - 2626) > (492 + 195)) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(6 + 2))) then
				return "metamorphosis cooldown 6";
			end
		end
		local v125 = v25.HandleDPSPotion(v13:BuffUp(v83.MetamorphosisBuff));
		if (v125 or ((884 - 228) >= (818 + 2512))) then
			return v125;
		end
		if ((v55 and not v13:IsMoving() and ((v33 and v58) or not v58) and v83.ElysianDecree:IsCastable() and (v14:DebuffDown(v83.EssenceBreakDebuff)) and (v92 > v62)) or ((4968 - 2476) <= (657 - 322))) then
			if (((6202 - (446 + 1434)) >= (3845 - (1040 + 243))) and (v61 == "player")) then
				if (v23(v85.ElysianDecreePlayer, not v14:IsInRange(23 - 15)) or ((5484 - (559 + 1288)) >= (5701 - (609 + 1322)))) then
					return "elysian_decree cooldown 8 (Player)";
				end
			elseif ((v61 == "cursor") or ((2833 - (13 + 441)) > (17107 - 12529))) then
				if (v23(v85.ElysianDecreeCursor, not v14:IsInRange(78 - 48)) or ((2405 - 1922) > (28 + 715))) then
					return "elysian_decree cooldown 8 (Cursor)";
				end
			end
		end
		if (((8912 - 6458) > (206 + 372)) and (v74 < v106)) then
			if (((408 + 522) < (13229 - 8771)) and v75 and ((v33 and v76) or not v76)) then
				v30 = v110();
				if (((363 + 299) <= (1787 - 815)) and v30) then
					return v30;
				end
			end
		end
	end
	local function v115()
		if (((2890 + 1480) == (2431 + 1939)) and v83.EssenceBreak:IsCastable() and v41 and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (8 + 2)))) then
			if (v23(v83.EssenceBreak, not v14:IsInRange(7 + 1)) or ((4660 + 102) <= (1294 - (153 + 280)))) then
				return "essence_break rotation prio";
			end
		end
		if ((v83.BladeDance:IsCastable() and v36 and v13:BuffUp(v83.EssenceBreakBuff)) or ((4076 - 2664) == (3829 + 435))) then
			if (v23(v83.BladeDance, not v14:IsInRange(4 + 4)) or ((1658 + 1510) < (1954 + 199))) then
				return "blade_dance rotation prio";
			end
		end
		if ((v83.DeathSweep:IsCastable() and v39 and v13:BuffUp(v83.EssenceBreakBuff)) or ((3606 + 1370) < (2027 - 695))) then
			if (((2861 + 1767) == (5295 - (89 + 578))) and v23(v83.DeathSweep, not v14:IsInRange(6 + 2))) then
				return "death_sweep rotation prio";
			end
		end
		if ((v83.Annihilation:IsCastable() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.Metamorphosis:CooldownRemains() <= (v13:GCD() * (5 - 2)))) or ((1103 - (572 + 477)) == (54 + 341))) then
			if (((50 + 32) == (10 + 72)) and v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation))) then
				return "annihilation rotation 2";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and (v83.EyeBeam:CooldownRemains() < (86.3 - (84 + 2))) and (v83.EssenceBreak:CooldownRemains() < (v102 * (2 - 0))) and (v9.CombatTime() > (4 + 1)) and (v13:Fury() >= (872 - (497 + 345))) and v83.Inertia:IsAvailable()) or ((15 + 566) < (48 + 234))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(1341 - (605 + 728)), nil, true) or ((3289 + 1320) < (5547 - 3052))) then
				return "vengeful_retreat rotation 3";
			end
		end
		if (((53 + 1099) == (4259 - 3107)) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and ((v83.EssenceBreak:CooldownRemains() > (41 - 26)) or ((v83.EssenceBreak:CooldownRemains() < v102) and (not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (12 + 3 + ((499 - (457 + 32)) * v26(v83.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (13 + 17)) or ((v13:GCDRemains() - (1403 - (832 + 570))) < (0 + 0))) and (not v83.Initiative:IsAvailable() or (v13:BuffRemains(v83.InitiativeBuff) < v102) or (v9.CombatTime() > (2 + 2)))) then
			if (((6709 - 4813) <= (1649 + 1773)) and v23(v83.VengefulRetreat, not v14:IsInRange(804 - (588 + 208)), nil, true)) then
				return "vengeful_retreat rotation 4";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (2 - 1)) and ((v83.EssenceBreak:CooldownRemains() > (1815 - (884 + 916))) or ((v83.EssenceBreak:CooldownRemains() < (v102 * (3 - 1))) and (((v13:BuffRemains(v83.InitiativeBuff) < v102) and not v100 and (v83.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (18 + 12))) or not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > ((668 - (232 + 421)) + ((1899 - (1569 + 320)) * v26(v83.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v83.UnboundChaosBuff) or v13:BuffUp(v83.InertiaBuff))) or ((243 + 747) > (308 + 1312))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(26 - 18), nil, true) or ((1482 - (316 + 289)) > (12290 - 7595))) then
				return "vengeful_retreat rotation 6";
			end
		end
		if (((125 + 2566) >= (3304 - (666 + 787))) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and not v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (426 - (360 + 65))) and (v13:BuffDown(v83.InitiativeBuff) or (v13:PrevGCDP(1 + 0, v83.DeathSweep) and v83.Metamorphosis:CooldownUp() and v83.ChaoticTransformation:IsAvailable())) and v83.Initiative:IsAvailable()) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(262 - (79 + 175)), nil, true) or ((4706 - 1721) >= (3790 + 1066))) then
				return "vengeful_retreat rotation 8";
			end
		end
		if (((13106 - 8830) >= (2301 - 1106)) and v83.FelRush:IsCastable() and v34 and v45 and v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) < (v102 * (901 - (503 + 396)))) and (v83.EyeBeam:CooldownRemains() <= v102) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) then
			if (((3413 - (92 + 89)) <= (9098 - 4408)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 10";
			end
		end
		if ((v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or ((v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge()) and (v83.EyeBeam:CooldownRemains() > (3 + 1)))) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) or ((531 + 365) >= (12320 - 9174))) then
			if (((419 + 2642) >= (6744 - 3786)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 11";
			end
		end
		if (((2781 + 406) >= (308 + 336)) and v83.EssenceBreak:IsCastable() and v41 and ((((v13:BuffRemains(v83.MetamorphosisBuff) > (v102 * (8 - 5))) or (v83.EyeBeam:CooldownRemains() > (2 + 8))) and (not v83.TacticalRetreat:IsAvailable() or v13:BuffUp(v83.TacticalRetreatBuff) or (v9.CombatTime() < (15 - 5))) and (v83.BladeDance:CooldownRemains() <= ((1247.1 - (485 + 759)) * v102))) or (v106 < (13 - 7)))) then
			if (((1833 - (442 + 747)) <= (1839 - (832 + 303))) and v23(v83.EssenceBreak, not v14:IsInRange(954 - (88 + 858)))) then
				return "essence_break rotation 13";
			end
		end
		if (((292 + 666) > (784 + 163)) and v83.DeathSweep:IsCastable() and v39 and v95 and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() > (v102 * (1 + 1)))) and v13:BuffDown(v83.FelBarrage)) then
			if (((5281 - (766 + 23)) >= (13102 - 10448)) and v23(v83.DeathSweep, not v14:IsInRange(10 - 2))) then
				return "death_sweep rotation 14";
			end
		end
		if (((9068 - 5626) >= (5101 - 3598)) and v83.TheHunt:IsCastable() and v34 and v57 and (v74 < v106) and ((v33 and v60) or not v60) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v9.CombatTime() < (1083 - (1036 + 37))) or (v83.Metamorphosis:CooldownRemains() > (8 + 2))) and ((v92 == (1 - 0)) or (v92 > (3 + 0)) or (v106 < (1490 - (641 + 839)))) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and (not v83.FuriousGaze:IsAvailable() or v13:BuffUp(v83.FuriousGazeBuff) or v13:HasTier(944 - (910 + 3), 9 - 5))) or not v13:HasTier(1714 - (1466 + 218), 1 + 1)) and (v9.CombatTime() > (1158 - (556 + 592)))) then
			if (v23(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt)) or ((1128 + 2042) <= (2272 - (329 + 479)))) then
				return "the_hunt main 12";
			end
		end
		if ((v83.FelBarrage:IsCastable() and v43 and ((v92 > (855 - (174 + 680))) or ((v92 == (3 - 2)) and (v13:FuryDeficit() < (41 - 21)) and v13:BuffDown(v83.MetamorphosisBuff)))) or ((3425 + 1372) == (5127 - (396 + 343)))) then
			if (((49 + 502) <= (2158 - (29 + 1448))) and v23(v83.FelBarrage, not v14:IsInRange(1397 - (135 + 1254)))) then
				return "fel_barrage rotation 16";
			end
		end
		if (((12344 - 9067) > (1900 - 1493)) and v83.GlaiveTempest:IsReady() and v46 and (v14:DebuffDown(v83.EssenceBreakDebuff) or (v92 > (1 + 0))) and v13:BuffDown(v83.FelBarrage)) then
			if (((6222 - (389 + 1138)) >= (1989 - (102 + 472))) and v23(v83.GlaiveTempest, not v14:IsInRange(8 + 0))) then
				return "glaive_tempest rotation 18";
			end
		end
		if ((v83.Annihilation:IsReady() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v83.FelBarrage)) or ((1782 + 1430) <= (881 + 63))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((4641 - (320 + 1225)) <= (3200 - 1402))) then
				return "annihilation rotation 20";
			end
		end
		if (((2165 + 1372) == (5001 - (157 + 1307))) and v83.FelRush:IsReady() and v34 and v45 and v83.Momentum:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (1862 - (821 + 1038)))) and (v13:BuffRemains(v83.MomentumBuff) < (12 - 7)) and v13:BuffDown(v83.MetamorphosisBuff)) then
			if (((420 + 3417) >= (2788 - 1218)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 22";
			end
		end
		if ((v83.EyeBeam:IsCastable() and v42 and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.Metamorphosis:CooldownRemains() > ((74 - 44) - (v26(v83.CycleOfHatred:IsAvailable()) * (1041 - (834 + 192))))) or ((v83.Metamorphosis:CooldownRemains() < (v102 * (1 + 1))) and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() < (v102 * (1.5 + 0)))))) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > v102) or not v83.RestlessHunter:IsAvailable()) and (v83.CycleOfHatred:IsAvailable() or not v83.Initiative:IsAvailable() or (v83.VengefulRetreat:CooldownRemains() > (1 + 4)) or not v50 or (v9.CombatTime() < (15 - 5))) and v13:BuffDown(v83.InnerDemonBuff)) or (v106 < (319 - (300 + 4))))) or ((788 + 2162) == (9978 - 6166))) then
			if (((5085 - (112 + 250)) >= (925 + 1393)) and v23(v83.EyeBeam, not v14:IsInRange(19 - 11))) then
				return "eye_beam rotation 26";
			end
		end
		if ((v83.BladeDance:IsCastable() and v36 and v95 and ((v83.EyeBeam:CooldownRemains() > (3 + 2)) or not v83.Demonic:IsAvailable() or v13:HasTier(17 + 14, 2 + 0))) or ((1006 + 1021) > (2119 + 733))) then
			if (v23(v83.BladeDance, not v14:IsInRange(1422 - (1001 + 413))) or ((2533 - 1397) > (5199 - (244 + 638)))) then
				return "blade_dance rotation 28";
			end
		end
		if (((5441 - (627 + 66)) == (14147 - 9399)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff) and (v92 >= (606 - (512 + 90)))) then
			if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(4 + 4)) or ((897 + 2493) <= (8071 - 5011))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif ((v82 == "cursor") or ((1690 - 691) > (3792 - (35 + 1064)))) then
				if (((337 + 126) < (1285 - 684)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(1 + 39))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if ((v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(1237 - (298 + 938), v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v92 >= ((1261 - (233 + 1026)) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.ThrowGlaive:FullRechargeTime() < (v102 * (1669 - (636 + 1030)))) or (v92 > (1 + 0))) and not v13:HasTier(31 + 0, 1 + 1)) or ((148 + 2035) < (908 - (55 + 166)))) then
			if (((882 + 3667) == (458 + 4091)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 32";
			end
		end
		if (((17842 - 13170) == (4969 - (36 + 261))) and v83.ImmolationAura:IsCastable() and v47 and (v92 >= (3 - 1)) and (v13:Fury() < (1438 - (34 + 1334))) and v14:DebuffDown(v83.EssenceBreakDebuff)) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(4 + 4)) or ((2850 + 818) < (1678 - (1035 + 248)))) then
				return "immolation_aura rotation 34";
			end
		end
		if ((v83.Annihilation:IsCastable() and v35 and not v96 and ((v83.EssenceBreak:CooldownRemains() > (21 - (20 + 1))) or not v83.EssenceBreak:IsAvailable()) and v13:BuffDown(v83.FelBarrage)) or v13:HasTier(16 + 14, 321 - (134 + 185)) or ((5299 - (549 + 584)) == (1140 - (314 + 371)))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((15273 - 10824) == (3631 - (478 + 490)))) then
				return "annihilation rotation 36";
			end
		end
		if ((v83.Felblade:IsCastable() and v44 and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat) and (((v13:FuryDeficit() >= (1212 - (786 + 386))) and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)))) or ((13853 - 9576) < (4368 - (1055 + 324)))) then
			if (v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade)) or ((2210 - (1093 + 247)) >= (3687 + 462))) then
				return "felblade rotation 38";
			end
		end
		if (((233 + 1979) < (12637 - 9454)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (101 - 71))) then
			if (((13220 - 8574) > (7518 - 4526)) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((511 + 923) < (11965 - 8859)) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(27 - 19))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif (((593 + 193) < (7730 - 4707)) and (v82 == "cursor")) then
				if (v23(v85.SigilOfFlameCursor, not v14:IsInRange(728 - (364 + 324))) or ((6694 - 4252) < (177 - 103))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if (((1504 + 3031) == (18975 - 14440)) and v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(1 - 0, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v93 >= ((5 - 3) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and not v13:HasTier(1299 - (1249 + 19), 2 + 0)) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((11712 - 8703) <= (3191 - (686 + 400)))) then
				return "throw_glaive rotation 40";
			end
		end
		if (((1436 + 394) < (3898 - (73 + 156))) and v83.ImmolationAura:IsCastable() and v47 and (v13:BuffStack(v83.ImmolationAuraBuff) < v101) and v14:IsInRange(1 + 7) and (v13:BuffDown(v83.UnboundChaosBuff) or not v83.UnboundChaos:IsAvailable()) and ((v83.ImmolationAura:Recharge() < v83.EssenceBreak:CooldownRemains()) or (not v83.EssenceBreak:IsAvailable() and (v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge())))) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(819 - (721 + 90))) or ((17 + 1413) >= (11727 - 8115))) then
				return "immolation_aura rotation 42";
			end
		end
		if (((3153 - (224 + 246)) >= (3985 - 1525)) and v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(1 - 0, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v83.ThrowGlaive:FullRechargeTime() < v83.BladeDance:CooldownRemains()) and v13:HasTier(6 + 25, 1 + 1) and v13:BuffDown(v83.FelBarrage) and not v97) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1325 + 479) >= (6511 - 3236))) then
				return "throw_glaive rotation 44";
			end
		end
		if ((v83.ChaosStrike:IsReady() and v37 and not v96 and not v97 and v13:BuffDown(v83.FelBarrage)) or ((4715 - 3298) > (4142 - (203 + 310)))) then
			if (((6788 - (1238 + 755)) > (29 + 373)) and v23(v83.ChaosStrike, not v14:IsSpellInRange(v83.ChaosStrike))) then
				return "chaos_strike rotation 46";
			end
		end
		if (((6347 - (709 + 825)) > (6569 - 3004)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and (v13:FuryDeficit() >= (43 - 13))) then
			if (((4776 - (196 + 668)) == (15445 - 11533)) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((5843 - 3022) <= (5657 - (171 + 662))) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(101 - (4 + 89)))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((6091 - 4353) <= (800 + 1395)) and (v82 == "cursor")) then
				if (((180 - 139) <= (1184 + 1834)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(1516 - (35 + 1451)))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if (((3598 - (28 + 1425)) <= (6097 - (941 + 1052))) and v83.Felblade:IsCastable() and v44 and (v13:FuryDeficit() >= (39 + 1)) and not v13:PrevGCDP(1515 - (822 + 692), v83.VengefulRetreat)) then
			if (((3838 - 1149) < (2283 + 2562)) and v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade))) then
				return "felblade rotation 50";
			end
		end
		if ((v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and v83.DemonBlades:IsAvailable() and v83.EyeBeam:CooldownDown() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.FelRush:Recharge() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable())) or ((2619 - (45 + 252)) > (2595 + 27))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1561 + 2973) == (5066 - 2984))) then
				return "fel_rush rotation 52";
			end
		end
		if ((v83.DemonsBite:IsCastable() and v40 and v83.BurningWound:IsAvailable() and (v14:DebuffRemains(v83.BurningWoundDebuff) < (437 - (114 + 319)))) or ((2255 - 684) > (2391 - 524))) then
			if (v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite)) or ((1692 + 962) >= (4463 - 1467))) then
				return "demons_bite rotation 54";
			end
		end
		if (((8334 - 4356) > (4067 - (556 + 1407))) and v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and not v83.DemonBlades:IsAvailable() and (v92 > (1207 - (741 + 465))) and v13:BuffDown(v83.UnboundChaosBuff)) then
			if (((3460 - (170 + 295)) > (812 + 729)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 56";
			end
		end
		if (((2985 + 264) > (2346 - 1393)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (25 + 5)) and v14:IsInRange(20 + 10)) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((1854 + 1419) > (5803 - (957 + 273)))) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(3 + 5)) or ((1262 + 1889) < (4892 - 3608))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif ((v82 == "cursor") or ((4875 - 3025) == (4670 - 3141))) then
				if (((4065 - 3244) < (3903 - (389 + 1391))) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(19 + 11))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if (((94 + 808) < (5293 - 2968)) and v83.DemonsBite:IsCastable() and v40) then
			if (((1809 - (783 + 168)) <= (9940 - 6978)) and v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite))) then
				return "demons_bite rotation 57";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) <= (20 + 0))) or ((4257 - (309 + 2)) < (3955 - 2667))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((4454 - (1090 + 122)) == (184 + 383))) then
				return "fel_rush rotation 58";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(26 - 18) and not v83.Momentum:IsAvailable()) or ((580 + 267) >= (2381 - (628 + 490)))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((404 + 1849) == (4582 - 2731))) then
				return "fel_rush rotation 59";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and not v83.Initiative:IsAvailable() and not v14:IsInRange(36 - 28)) or ((2861 - (431 + 343)) > (4790 - 2418))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(23 - 15), nil, true) or ((3512 + 933) < (531 + 3618))) then
				return "vengeful_retreat rotation 60";
			end
		end
		if ((v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(1696 - (556 + 1139), v83.VengefulRetreat) and not v13:IsMoving() and (v83.DemonBlades:IsAvailable() or not v14:IsInRange(27 - (6 + 9))) and v14:DebuffDown(v83.EssenceBreakDebuff) and v14:IsSpellInRange(v83.ThrowGlaive) and not v13:HasTier(6 + 25, 2 + 0)) or ((1987 - (28 + 141)) == (33 + 52))) then
			if (((777 - 147) < (1507 + 620)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v116()
		local v126 = 1317 - (486 + 831);
		while true do
			if ((v126 == (2 - 1)) or ((6822 - 4884) == (476 + 2038))) then
				v39 = EpicSettings.Settings['useDeathSweep'];
				v40 = EpicSettings.Settings['useDemonsBite'];
				v41 = EpicSettings.Settings['useEssenceBreak'];
				v42 = EpicSettings.Settings['useEyeBeam'];
				v126 = 6 - 4;
			end
			if (((5518 - (668 + 595)) >= (50 + 5)) and (v126 == (1 + 2))) then
				v47 = EpicSettings.Settings['useImmolationAura'];
				v48 = EpicSettings.Settings['useSigilOfFlame'];
				v49 = EpicSettings.Settings['useThrowGlaive'];
				v50 = EpicSettings.Settings['useVengefulRetreat'];
				v126 = 10 - 6;
			end
			if (((3289 - (23 + 267)) > (3100 - (1129 + 815))) and (v126 == (391 - (371 + 16)))) then
				v55 = EpicSettings.Settings['useElysianDecree'];
				v56 = EpicSettings.Settings['useMetamorphosis'];
				v57 = EpicSettings.Settings['useTheHunt'];
				v58 = EpicSettings.Settings['elysianDecreeWithCD'];
				v126 = 1755 - (1326 + 424);
			end
			if (((4450 - 2100) > (4220 - 3065)) and (v126 == (120 - (88 + 30)))) then
				v43 = EpicSettings.Settings['useFelBarrage'];
				v44 = EpicSettings.Settings['useFelblade'];
				v45 = EpicSettings.Settings['useFelRush'];
				v46 = EpicSettings.Settings['useGlaiveTempest'];
				v126 = 774 - (720 + 51);
			end
			if (((8962 - 4933) <= (6629 - (421 + 1355))) and (v126 == (8 - 3))) then
				v59 = EpicSettings.Settings['metamorphosisWithCD'];
				v60 = EpicSettings.Settings['theHuntWithCD'];
				v61 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v62 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				break;
			end
			if ((v126 == (1083 - (286 + 797))) or ((1886 - 1370) > (5687 - 2253))) then
				v35 = EpicSettings.Settings['useAnnihilation'];
				v36 = EpicSettings.Settings['useBladeDance'];
				v37 = EpicSettings.Settings['useChaosStrike'];
				v38 = EpicSettings.Settings['useConsumeMagic'];
				v126 = 440 - (397 + 42);
			end
		end
	end
	local function v117()
		local v127 = 0 + 0;
		while true do
			if (((4846 - (24 + 776)) >= (4672 - 1639)) and (v127 == (785 - (222 + 563)))) then
				v51 = EpicSettings.Settings['useChaosNova'];
				v52 = EpicSettings.Settings['useDisrupt'];
				v127 = 1 - 0;
			end
			if (((2 + 0) == v127) or ((2909 - (23 + 167)) <= (3245 - (690 + 1108)))) then
				v63 = EpicSettings.Settings['useBlur'];
				v64 = EpicSettings.Settings['useNetherwalk'];
				v127 = 2 + 1;
			end
			if ((v127 == (4 + 0)) or ((4982 - (40 + 808)) < (647 + 3279))) then
				v82 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
			if ((v127 == (3 - 2)) or ((157 + 7) >= (1474 + 1311))) then
				v53 = EpicSettings.Settings['useFelEruption'];
				v54 = EpicSettings.Settings['useSigilOfMisery'];
				v127 = 2 + 0;
			end
			if ((v127 == (574 - (47 + 524))) or ((341 + 184) == (5764 - 3655))) then
				v65 = EpicSettings.Settings['blurHP'] or (0 - 0);
				v66 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
				v127 = 1730 - (1165 + 561);
			end
		end
	end
	local function v118()
		local v128 = 0 + 0;
		while true do
			if (((102 - 69) == (13 + 20)) and (v128 == (480 - (341 + 138)))) then
				v73 = EpicSettings.Settings['InterruptThreshold'];
				v75 = EpicSettings.Settings['useTrinkets'];
				v76 = EpicSettings.Settings['trinketsWithCD'];
				v78 = EpicSettings.Settings['useHealthstone'];
				v128 = 1 + 1;
			end
			if (((6302 - 3248) <= (4341 - (89 + 237))) and (v128 == (6 - 4))) then
				v77 = EpicSettings.Settings['useHealingPotion'];
				v80 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v79 = EpicSettings.Settings['healingPotionHP'] or (881 - (581 + 300));
				v81 = EpicSettings.Settings['HealingPotionName'] or "";
				v128 = 1223 - (855 + 365);
			end
			if (((4443 - 2572) < (1105 + 2277)) and (v128 == (1238 - (1030 + 205)))) then
				v70 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1214 + 79) <= (2015 + 151)) and (v128 == (286 - (156 + 130)))) then
				v74 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v67 = EpicSettings.Settings['dispelBuffs'];
				v71 = EpicSettings.Settings['InterruptWithStun'];
				v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v128 = 1 - 0;
			end
		end
	end
	local function v119()
		v117();
		v116();
		v118();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['movement'];
		if (v13:IsDeadOrGhost() or ((5281 - 2702) < (33 + 90))) then
			return;
		end
		v90 = v13:GetEnemiesInMeleeRange(5 + 3);
		v91 = v13:GetEnemiesInMeleeRange(89 - (10 + 59));
		if (v32 or ((240 + 606) >= (11661 - 9293))) then
			v92 = ((#v90 > (1163 - (671 + 492))) and #v90) or (1 + 0);
			v93 = #v91;
		else
			v92 = 1216 - (369 + 846);
			v93 = 1 + 0;
		end
		v102 = v13:GCD() + 0.05 + 0;
		if (v25.TargetIsValid() or v13:AffectingCombat() or ((5957 - (1036 + 909)) <= (2670 + 688))) then
			v105 = v9.BossFightRemains(nil, true);
			v106 = v105;
			if (((2507 - 1013) <= (3208 - (11 + 192))) and (v106 == (5615 + 5496))) then
				v106 = v9.FightRemains(Enemies8y, false);
			end
		end
		v30 = v111();
		if (v30 or ((3286 - (135 + 40)) == (5170 - 3036))) then
			return v30;
		end
		if (((1420 + 935) == (5187 - 2832)) and v70) then
			local v135 = 0 - 0;
			while true do
				if ((v135 == (176 - (50 + 126))) or ((1637 - 1049) <= (96 + 336))) then
					v30 = v25.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 1443 - (1233 + 180), true);
					if (((5766 - (522 + 447)) >= (5316 - (107 + 1314))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((1660 + 1917) == (10899 - 7322)) and v25.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
			local v136 = 0 + 0;
			local v137;
			while true do
				if (((7533 - 3739) > (14611 - 10918)) and (v136 == (1916 - (716 + 1194)))) then
					if ((v83.DemonBlades:IsAvailable()) or ((22 + 1253) == (440 + 3660))) then
						if (v23(v83.Pool) or ((2094 - (74 + 429)) >= (6906 - 3326))) then
							return "pool demon_blades";
						end
					end
					break;
				end
				if (((488 + 495) <= (4138 - 2330)) and (v136 == (3 + 1))) then
					if ((v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.ImmolationAura:FullRechargeTime() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable()) and v14:DebuffDown(v83.EssenceBreakDebuff) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > (18 - 12))) and v83.BladeDance:CooldownDown() and ((v13:Fury() < (185 - 110)) or (v83.BladeDance:CooldownRemains() < (v102 * (435 - (279 + 154)))))) or ((2928 - (454 + 324)) <= (942 + 255))) then
						if (((3786 - (12 + 5)) >= (633 + 540)) and v23(v83.ImmolationAura, not v14:IsInRange(20 - 12))) then
							return "immolation_aura main 6";
						end
					end
					if (((549 + 936) == (2578 - (277 + 816))) and v83.FelRush:IsCastable() and v34 and v45 and ((v13:BuffRemains(v83.UnboundChaosBuff) < (v102 * (8 - 6))) or (v14:TimeToDie() < (v102 * (1185 - (1058 + 125)))))) then
						if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((622 + 2693) <= (3757 - (815 + 160)))) then
							return "fel_rush main 8";
						end
					end
					if ((v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and ((v83.EyeBeam:CooldownRemains() + (12 - 9)) > v13:BuffRemains(v83.UnboundChaosBuff)) and (v83.BladeDance:CooldownDown() or v83.EssenceBreak:CooldownUp())) or ((2079 - 1203) >= (708 + 2256))) then
						if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((6524 - 4292) > (4395 - (41 + 1857)))) then
							return "fel_rush main 9";
						end
					end
					if ((v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EssenceBreak:CooldownRemains() > (1903 - (1222 + 671))))) or ((5453 - 3343) <= (476 - 144))) then
						if (((4868 - (229 + 953)) > (4946 - (1111 + 663))) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
							return "fel_rush main 10";
						end
					end
					v136 = 1584 - (874 + 705);
				end
				if ((v136 == (1 + 1)) or ((3053 + 1421) < (1704 - 884))) then
					v99 = (v83.Momentum:IsAvailable() and v13:BuffDown(v83.MomentumBuff)) or (v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff));
					v137 = v29(v83.EyeBeam:BaseDuration(), v13:GCD());
					v100 = v83.Demonic:IsAvailable() and v83.EssenceBreak:IsAvailable() and Var3MinTrinket and (v106 > (v83.Metamorphosis:CooldownRemains() + 1 + 29 + (v26(v83.ShatteredDestiny:IsAvailable()) * (739 - (642 + 37))))) and (v83.Metamorphosis:CooldownRemains() < (5 + 15)) and (v83.Metamorphosis:CooldownRemains() > (v137 + (v102 * (v26(v83.InnerDemon:IsAvailable()) + 1 + 1))));
					if (((10743 - 6464) >= (3336 - (233 + 221))) and v83.ImmolationAura:IsCastable() and v47 and v83.Ragefire:IsAvailable() and (v92 >= (6 - 3)) and (v83.BladeDance:CooldownDown() or v14:DebuffDown(v83.EssenceBreakDebuff))) then
						if (v23(v83.ImmolationAura, not v14:IsInRange(8 + 0)) or ((3570 - (718 + 823)) >= (2216 + 1305))) then
							return "immolation_aura main 2";
						end
					end
					v136 = 808 - (266 + 539);
				end
				if ((v136 == (0 - 0)) or ((3262 - (636 + 589)) >= (11018 - 6376))) then
					if (((3547 - 1827) < (3533 + 925)) and not v13:AffectingCombat()) then
						local v175 = 0 + 0;
						while true do
							if ((v175 == (1015 - (657 + 358))) or ((1154 - 718) > (6882 - 3861))) then
								v30 = v112();
								if (((1900 - (1151 + 36)) <= (818 + 29)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if (((567 + 1587) <= (12038 - 8007)) and v83.ConsumeMagic:IsAvailable() and v38 and v83.ConsumeMagic:IsReady() and v67 and not v13:IsCasting() and not v13:IsChanneling() and v25.UnitHasMagicBuff(v14)) then
						if (((6447 - (1552 + 280)) == (5449 - (64 + 770))) and v23(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic))) then
							return "greater_purge damage";
						end
					end
					if ((v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(6 + 2)) or ((8603 - 4813) == (89 + 411))) then
						if (((1332 - (157 + 1086)) < (442 - 221)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
							return "fel_rush rotation when OOR";
						end
					end
					if (((8995 - 6941) >= (2179 - 758)) and v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v14:NPCID())) then
						if (((943 - 251) < (3877 - (599 + 220))) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
							return "fodder to the flames react per target";
						end
					end
					v136 = 1 - 0;
				end
				if (((1936 - (1813 + 118)) == v136) or ((2379 + 875) == (2872 - (841 + 376)))) then
					if (((v74 < v106) and v33) or ((1815 - 519) == (1141 + 3769))) then
						local v176 = 0 - 0;
						while true do
							if (((4227 - (464 + 395)) == (8643 - 5275)) and (v176 == (0 + 0))) then
								v30 = v114();
								if (((3480 - (467 + 370)) < (7883 - 4068)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if (((1405 + 508) > (1689 - 1196)) and v13:BuffUp(v83.MetamorphosisBuff) and (v13:BuffRemains(v83.MetamorphosisBuff) < v102) and (v92 < (1 + 2))) then
						v30 = v113();
						if (((11062 - 6307) > (3948 - (150 + 370))) and v30) then
							return v30;
						end
					end
					v30 = v115();
					if (((2663 - (74 + 1208)) <= (5826 - 3457)) and v30) then
						return v30;
					end
					v136 = 28 - 22;
				end
				if (((3 + 0) == v136) or ((5233 - (14 + 376)) == (7083 - 2999))) then
					if (((3022 + 1647) > (319 + 44)) and v83.ImmolationAura:IsCastable() and v47 and v83.AFireInside:IsAvailable() and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and (v83.ImmolationAura:FullRechargeTime() < (v102 * (2 + 0))) and v14:DebuffDown(v83.EssenceBreakDebuff)) then
						if (v23(v83.ImmolationAura, not v14:IsInRange(23 - 15)) or ((1413 + 464) >= (3216 - (23 + 55)))) then
							return "immolation_aura main 3";
						end
					end
					if (((11237 - 6495) >= (2420 + 1206)) and v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and (((v83.ImmolationAura:Charges() == (2 + 0)) and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v13:PrevGCDP(1 - 0, v83.EyeBeam) and v13:BuffUp(v83.InertiaBuff) and (v13:BuffRemains(v83.InertiaBuff) < (1 + 2))))) then
						if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((5441 - (652 + 249)) == (2451 - 1535))) then
							return "fel_rush main 4";
						end
					end
					if ((v83.TheHunt:IsCastable() and (v9.CombatTime() < (1878 - (708 + 1160))) and (not v83.Inertia:IsAvailable() or (v13:BuffUp(v83.MetamorphosisBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)))) or ((3137 - 1981) > (7921 - 3576))) then
						if (((2264 - (10 + 17)) < (955 + 3294)) and v21(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt))) then
							return "the_hunt main 6";
						end
					end
					if ((v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and ((v83.EyeBeam:CooldownRemains() < (v102 * (1734 - (1400 + 332)))) or v13:BuffUp(v83.MetamorphosisBuff)) and (v83.EssenceBreak:CooldownRemains() < (v102 * (5 - 2))) and v13:BuffDown(v83.UnboundChaosBuff) and v13:BuffDown(v83.InertiaBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)) or ((4591 - (242 + 1666)) < (10 + 13))) then
						if (((256 + 441) <= (704 + 122)) and v23(v83.ImmolationAura, not v14:IsInRange(948 - (850 + 90)))) then
							return "immolation_aura main 5";
						end
					end
					v136 = 6 - 2;
				end
				if (((2495 - (360 + 1030)) <= (1041 + 135)) and (v136 == (2 - 1))) then
					if (((4648 - 1269) <= (5473 - (909 + 752))) and v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v15:NPCID())) then
						if (v23(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((2011 - (109 + 1114)) >= (2958 - 1342))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v95 = v83.FirstBlood:IsAvailable() or v83.TrailofRuin:IsAvailable() or (v83.ChaosTheory:IsAvailable() and v13:BuffDown(v83.ChaosTheoryBuff)) or (v92 > (1 + 0));
					v96 = v95 and (v13:Fury() < ((317 - (6 + 236)) - (v26(v83.DemonBlades:IsAvailable()) * (13 + 7)))) and (v83.BladeDance:CooldownRemains() < v102);
					v97 = v83.Demonic:IsAvailable() and not v83.BlindFury:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (2 + 0))) and (v13:FuryDeficit() > (70 - 40));
					v136 = 3 - 1;
				end
			end
		end
	end
	local function v120()
		v83.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1710 - (1076 + 57), v119, v120);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

