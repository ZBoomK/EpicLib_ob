local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((7635 - 5271) > (5245 - (404 + 1335)))) then
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
	local v83 = (v82[419 - (183 + 223)] and v18(v82[15 - 2])) or v18(0 + 0);
	local v84 = (v82[6 + 8] and v18(v82[351 - (10 + 327)])) or v18(0 + 0);
	local v85, v86;
	local v87, v88;
	local v89 = {{v78.FelEruption},{v78.ChaosNova}};
	local v90 = false;
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = ((v78.AFireInside:IsAvailable()) and (21 - 16)) or (1494 - (711 + 782));
	local v97 = v13:GCD() + (0.25 - 0);
	local v98 = 469 - (270 + 199);
	local v99 = false;
	local v100 = 3603 + 7508;
	local v101 = 12930 - (580 + 1239);
	local v102 = {(161993 + 7428),(73806 + 95619),(104951 + 63981),(171216 - (1010 + 780)),(807144 - 637715),(171264 - (1045 + 791)),(258710 - 89280)};
	v9:RegisterForEvent(function()
		local v116 = 505 - (351 + 154);
		while true do
			if ((v116 == (1576 - (1281 + 293))) or ((3169 - (28 + 238)) > (11069 - 6115))) then
				v94 = false;
				v100 = 12670 - (1381 + 178);
				v116 = 3 + 0;
			end
			if (((2487 + 597) > (18 + 22)) and (v116 == (3 - 2))) then
				v92 = false;
				v93 = false;
				v116 = 2 + 0;
			end
			if (((3882 - (381 + 89)) > (727 + 92)) and (v116 == (3 + 0))) then
				v101 = 19032 - 7921;
				break;
			end
			if (((4318 - (1074 + 82)) <= (7540 - 4099)) and (v116 == (1784 - (214 + 1570)))) then
				v90 = false;
				v91 = false;
				v116 = 1456 - (990 + 465);
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v82 = v13:GetEquipment();
		v83 = (v82[6 + 7] and v18(v82[6 + 7])) or v18(0 + 0);
		v84 = (v82[55 - 41] and v18(v82[1740 - (1668 + 58)])) or v18(626 - (512 + 114));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v96 = ((v78.AFireInside:IsAvailable()) and (13 - 8)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v103(v117)
		return v117:DebuffRemains(v78.BurningWoundDebuff) or v117:DebuffRemains(v78.BurningWoundLegDebuff);
	end
	local function v104(v118)
		return v78.BurningWound:IsAvailable() and (v118:DebuffRemains(v78.BurningWoundDebuff) < (13 - 9)) and (v78.BurningWoundDebuff:AuraActiveCount() < v25(v87, 2 + 1));
	end
	local function v105()
		v27 = v22.HandleTopTrinket(v81, v30, 8 + 32, nil);
		if (((4092 + 614) > (14938 - 10509)) and v27) then
			return v27;
		end
		v27 = v22.HandleBottomTrinket(v81, v30, 2034 - (109 + 1885), nil);
		if (((4323 - (1269 + 200)) < (7848 - 3753)) and v27) then
			return v27;
		end
	end
	local function v106()
		local v119 = 815 - (98 + 717);
		while true do
			if ((v119 == (827 - (802 + 24))) or ((1824 - 766) >= (1517 - 315))) then
				if (((549 + 3162) > (2578 + 777)) and v79.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v75)) then
					if (v20(v80.Healthstone) or ((149 + 757) >= (481 + 1748))) then
						return "healthstone defensive";
					end
				end
				if (((3583 - 2295) > (4171 - 2920)) and v72 and (v13:HealthPercentage() <= v74)) then
					local v166 = 0 + 0;
					while true do
						if ((v166 == (0 + 0)) or ((3723 + 790) < (2438 + 914))) then
							if ((v76 == "Refreshing Healing Potion") or ((965 + 1100) >= (4629 - (797 + 636)))) then
								if (v79.RefreshingHealingPotion:IsReady() or ((21247 - 16871) <= (3100 - (1427 + 192)))) then
									if (v20(v80.RefreshingHealingPotion) or ((1176 + 2216) >= (11007 - 6266))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((2989 + 336) >= (977 + 1177)) and (v76 == "Dreamwalker's Healing Potion")) then
								if (v79.DreamwalkersHealingPotion:IsReady() or ((1621 - (192 + 134)) >= (4509 - (316 + 960)))) then
									if (((2436 + 1941) > (1268 + 374)) and v20(v80.RefreshingHealingPotion)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((4366 + 357) > (5183 - 3827)) and (v119 == (551 - (83 + 468)))) then
				if ((v78.Blur:IsCastable() and v60 and (v13:HealthPercentage() <= v62)) or ((5942 - (1202 + 604)) <= (16025 - 12592))) then
					if (((7064 - 2819) <= (12821 - 8190)) and v20(v78.Blur)) then
						return "blur defensive";
					end
				end
				if (((4601 - (45 + 280)) >= (3778 + 136)) and v78.Netherwalk:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) then
					if (((173 + 25) <= (1594 + 2771)) and v20(v78.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v119 = 1 + 0;
			end
		end
	end
	local function v107()
		if (((842 + 3940) > (8658 - 3982)) and v78.ImmolationAura:IsCastable() and v44) then
			if (((6775 - (340 + 1571)) > (867 + 1330)) and v20(v78.ImmolationAura, not v14:IsInRange(1780 - (1733 + 39)))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v45 and not v13:IsMoving() and (v87 > (2 - 1)) and v78.SigilOfFlame:IsCastable()) or ((4734 - (125 + 909)) == (4455 - (1096 + 852)))) then
			if (((2007 + 2467) >= (391 - 117)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(8 + 0)) or ((2406 - (409 + 103)) <= (1642 - (46 + 190)))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((1667 - (51 + 44)) >= (432 + 1099)) and (v77 == "cursor")) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(1357 - (1114 + 203))) or ((5413 - (228 + 498)) < (985 + 3557))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((1819 + 1472) > (2330 - (174 + 489))) and not v14:IsInMeleeRange(12 - 7) and v78.Felblade:IsCastable() and v41) then
			if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((2778 - (830 + 1075)) == (2558 - (303 + 221)))) then
				return "felblade precombat 9";
			end
		end
		if ((not v14:IsInMeleeRange(1274 - (231 + 1038)) and v78.ThrowGlaive:IsCastable() and v46) or ((2347 + 469) < (1173 - (171 + 991)))) then
			if (((15244 - 11545) < (12636 - 7930)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive precombat 9";
			end
		end
		if (((6602 - 3956) >= (702 + 174)) and not v14:IsInMeleeRange(17 - 12) and v78.FelRush:IsCastable() and (not v78.Felblade:IsAvailable() or (v78.Felblade:CooldownDown() and not v13:PrevGCDP(2 - 1, v78.Felblade))) and v31 and v42) then
			if (((989 - 375) <= (9842 - 6658)) and v20(v78.FelRush, not v14:IsInRange(1263 - (111 + 1137)))) then
				return "fel_rush precombat 10";
			end
		end
		if (((3284 - (91 + 67)) == (9303 - 6177)) and v14:IsInMeleeRange(2 + 3) and v37 and (v78.DemonsBite:IsCastable() or v78.DemonBlades:IsAvailable())) then
			if (v20(v78.DemonsBite, not v14:IsInMeleeRange(528 - (423 + 100))) or ((16 + 2171) >= (13716 - 8762))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v108()
		if (v13:BuffDown(v78.FelBarrage) or ((2021 + 1856) == (4346 - (326 + 445)))) then
			if (((3085 - 2378) > (1407 - 775)) and v78.DeathSweep:IsReady() and v36) then
				if (v20(v78.DeathSweep, not v14:IsInRange(18 - 10)) or ((1257 - (530 + 181)) >= (3565 - (614 + 267)))) then
					return "death_sweep meta_end 2";
				end
			end
			if (((1497 - (19 + 13)) <= (7000 - 2699)) and v78.Annihilation:IsReady() and v32) then
				if (((3970 - 2266) > (4070 - 2645)) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v109()
		local v120 = 0 + 0;
		local v121;
		while true do
			if ((v120 == (3 - 1)) or ((1424 - 737) == (6046 - (1293 + 519)))) then
				if ((v52 and not v13:IsMoving() and ((v30 and v55) or not v55) and v78.ElysianDecree:IsCastable() and (v14:DebuffDown(v78.EssenceBreakDebuff)) and (v87 > v59)) or ((6794 - 3464) < (3730 - 2301))) then
					if (((2193 - 1046) >= (1444 - 1109)) and (v58 == "player")) then
						if (((8091 - 4656) > (1111 + 986)) and v20(v80.ElysianDecreePlayer, not v14:IsInRange(2 + 6))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif ((v58 == "cursor") or ((8759 - 4989) >= (934 + 3107))) then
						if (v20(v80.ElysianDecreeCursor, not v14:IsInRange(10 + 20)) or ((2370 + 1421) <= (2707 - (709 + 387)))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if ((v69 < v101) or ((6436 - (673 + 1185)) <= (5823 - 3815))) then
					if (((3612 - 2487) <= (3415 - 1339)) and v70 and ((v30 and v71) or not v71)) then
						v27 = v105();
						if (v27 or ((532 + 211) >= (3287 + 1112))) then
							return v27;
						end
					end
				end
				break;
			end
			if (((1558 - 403) < (411 + 1262)) and (v120 == (0 - 0))) then
				if ((((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and not v78.Demonic:IsAvailable()) or ((4561 - 2237) <= (2458 - (446 + 1434)))) then
					if (((5050 - (1040 + 243)) == (11243 - 7476)) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(1855 - (559 + 1288)))) then
						return "metamorphosis cooldown 4";
					end
				end
				if (((6020 - (609 + 1322)) == (4543 - (13 + 441))) and ((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and v78.Demonic:IsAvailable() and ((not v78.ChaoticTransformation:IsAvailable() and v78.EyeBeam:CooldownDown()) or ((v78.EyeBeam:CooldownRemains() > (74 - 54)) and (not v90 or v13:PrevGCDP(2 - 1, v78.DeathSweep) or v13:PrevGCDP(9 - 7, v78.DeathSweep))) or ((v101 < (1 + 24 + (v23(v78.ShatteredDestiny:IsAvailable()) * (254 - 184)))) and v78.EyeBeam:CooldownDown() and v78.BladeDance:CooldownDown())) and v13:BuffDown(v78.InnerDemonBuff)) then
					if (((1584 + 2874) >= (734 + 940)) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(23 - 15))) then
						return "metamorphosis cooldown 6";
					end
				end
				v120 = 1 + 0;
			end
			if (((1787 - 815) <= (938 + 480)) and ((1 + 0) == v120)) then
				v121 = v22.HandleDPSPotion(v13:BuffUp(v78.MetamorphosisBuff));
				if (v121 or ((3548 + 1390) < (3999 + 763))) then
					return v121;
				end
				v120 = 2 + 0;
			end
		end
	end
	local function v110()
		if ((v78.EssenceBreak:IsCastable() and v38 and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > (443 - (153 + 280))))) or ((7230 - 4726) > (3829 + 435))) then
			if (((851 + 1302) == (1127 + 1026)) and v20(v78.EssenceBreak, not v14:IsInRange(8 + 0))) then
				return "essence_break rotation prio";
			end
		end
		if ((v78.BladeDance:IsCastable() and v33 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((368 + 139) >= (3944 - 1353))) then
			if (((2770 + 1711) == (5148 - (89 + 578))) and v20(v78.BladeDance, not v14:IsInRange(6 + 2))) then
				return "blade_dance rotation prio";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((4839 - 2511) < (1742 - (572 + 477)))) then
			if (((584 + 3744) == (2598 + 1730)) and v20(v78.DeathSweep, not v14:IsInRange(1 + 7))) then
				return "death_sweep rotation prio";
			end
		end
		if (((1674 - (84 + 2)) >= (2194 - 862)) and v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.Metamorphosis:CooldownRemains() <= (v13:GCD() * (3 + 0)))) then
			if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((5016 - (497 + 345)) > (109 + 4139))) then
				return "annihilation rotation 2";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and (v78.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1335 - (605 + 728)))) and (v9.CombatTime() > (4 + 1)) and (v13:Fury() >= (66 - 36)) and v78.Inertia:IsAvailable()) or ((211 + 4375) <= (303 - 221))) then
			if (((3483 + 380) == (10702 - 6839)) and v20(v78.VengefulRetreat, not v14:IsInRange(7 + 1), nil, true)) then
				return "vengeful_retreat rotation 3";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (490 - (457 + 32))) and ((v78.EssenceBreak:CooldownRemains() > (7 + 8)) or ((v78.EssenceBreak:CooldownRemains() < v97) and (not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((1417 - (832 + 570)) + ((10 + 0) * v23(v78.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (8 + 22)) or ((v13:GCDRemains() - (3 - 2)) < (0 + 0))) and (not v78.Initiative:IsAvailable() or (v13:BuffRemains(v78.InitiativeBuff) < v97) or (v9.CombatTime() > (800 - (588 + 208))))) or ((759 - 477) <= (1842 - (884 + 916)))) then
			if (((9648 - 5039) >= (445 + 321)) and v20(v78.VengefulRetreat, not v14:IsInRange(661 - (232 + 421)), nil, true)) then
				return "vengeful_retreat rotation 4";
			end
		end
		if ((v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1890 - (1569 + 320))) and ((v78.EssenceBreak:CooldownRemains() > (4 + 11)) or ((v78.EssenceBreak:CooldownRemains() < (v97 * (1 + 1))) and (((v13:BuffRemains(v78.InitiativeBuff) < v97) and not v95 and (v78.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (101 - 71))) or not v78.Demonic:IsAvailable() or v13:BuffUp(v78.MetamorphosisBuff) or (v78.EyeBeam:CooldownRemains() > ((620 - (316 + 289)) + ((26 - 16) * v23(v78.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v78.UnboundChaosBuff) or v13:BuffUp(v78.InertiaBuff))) or ((54 + 1098) == (3941 - (666 + 787)))) then
			if (((3847 - (360 + 65)) > (3131 + 219)) and v20(v78.VengefulRetreat, not v14:IsInRange(262 - (79 + 175)), nil, true)) then
				return "vengeful_retreat rotation 6";
			end
		end
		if (((1382 - 505) > (294 + 82)) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and v78.Initiative:IsAvailable() and not v78.EssenceBreak:IsAvailable() and (v9.CombatTime() > (2 - 1)) and (v13:BuffDown(v78.InitiativeBuff) or (v13:PrevGCDP(1 - 0, v78.DeathSweep) and v78.Metamorphosis:CooldownUp() and v78.ChaoticTransformation:IsAvailable())) and v78.Initiative:IsAvailable()) then
			if (v20(v78.VengefulRetreat, not v14:IsInRange(907 - (503 + 396)), nil, true) or ((3299 - (92 + 89)) <= (3590 - 1739))) then
				return "vengeful_retreat rotation 8";
			end
		end
		if ((v78.FelRush:IsCastable() and v31 and v42 and v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) < (v97 * (2 + 0))) and (v78.EyeBeam:CooldownRemains() <= v97) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) or ((98 + 67) >= (13674 - 10182))) then
			if (((541 + 3408) < (11072 - 6216)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "fel_rush rotation 10";
			end
		end
		if ((v78.FelRush:IsCastable() and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or ((v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge()) and (v78.EyeBeam:CooldownRemains() > (4 + 0)))) and v14:DebuffDown(v78.EssenceBreakDebuff) and v78.BladeDance:CooldownDown()) or ((2043 + 2233) < (9185 - 6169))) then
			if (((586 + 4104) > (6290 - 2165)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "fel_rush rotation 11";
			end
		end
		if ((v78.EssenceBreak:IsCastable() and v38 and ((((v13:BuffRemains(v78.MetamorphosisBuff) > (v97 * (1247 - (485 + 759)))) or (v78.EyeBeam:CooldownRemains() > (23 - 13))) and (not v78.TacticalRetreat:IsAvailable() or v13:BuffUp(v78.TacticalRetreatBuff) or (v9.CombatTime() < (1199 - (442 + 747)))) and (v78.BladeDance:CooldownRemains() <= ((1138.1 - (832 + 303)) * v97))) or (v101 < (952 - (88 + 858))))) or ((16 + 34) >= (742 + 154))) then
			if (v20(v78.EssenceBreak, not v14:IsInRange(1 + 7)) or ((2503 - (766 + 23)) >= (14602 - 11644))) then
				return "essence_break rotation 13";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36 and v90 and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() > (v97 * (2 - 0)))) and v13:BuffDown(v78.FelBarrage)) or ((3928 - 2437) < (2185 - 1541))) then
			if (((1777 - (1036 + 37)) < (700 + 287)) and v20(v78.DeathSweep, not v14:IsInRange(15 - 7))) then
				return "death_sweep rotation 14";
			end
		end
		if (((2925 + 793) > (3386 - (641 + 839))) and v78.TheHunt:IsCastable() and v31 and v54 and (v69 < v101) and ((v30 and v57) or not v57) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v9.CombatTime() < (923 - (910 + 3))) or (v78.Metamorphosis:CooldownRemains() > (25 - 15))) and ((v87 == (1685 - (1466 + 218))) or (v87 > (2 + 1)) or (v101 < (1158 - (556 + 592)))) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and (not v78.FuriousGaze:IsAvailable() or v13:BuffUp(v78.FuriousGazeBuff) or v13:HasTier(12 + 19, 812 - (329 + 479)))) or not v13:HasTier(884 - (174 + 680), 6 - 4)) and (v9.CombatTime() > (20 - 10))) then
			if (v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt)) or ((684 + 274) > (4374 - (396 + 343)))) then
				return "the_hunt main 12";
			end
		end
		if (((310 + 3191) <= (5969 - (29 + 1448))) and v78.FelBarrage:IsCastable() and v40 and ((v87 > (1390 - (135 + 1254))) or ((v87 == (3 - 2)) and (v13:FuryDeficit() < (93 - 73)) and v13:BuffDown(v78.MetamorphosisBuff)))) then
			if (v20(v78.FelBarrage, not v14:IsInRange(6 + 2)) or ((4969 - (389 + 1138)) < (3122 - (102 + 472)))) then
				return "fel_barrage rotation 16";
			end
		end
		if (((2714 + 161) >= (812 + 652)) and v78.GlaiveTempest:IsReady() and v43 and (v14:DebuffDown(v78.EssenceBreakDebuff) or (v87 > (1 + 0))) and v13:BuffDown(v78.FelBarrage)) then
			if (v20(v78.GlaiveTempest, not v14:IsInRange(1553 - (320 + 1225))) or ((8538 - 3741) >= (2994 + 1899))) then
				return "glaive_tempest rotation 18";
			end
		end
		if ((v78.Annihilation:IsReady() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (v78.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v78.FelBarrage)) or ((2015 - (157 + 1307)) > (3927 - (821 + 1038)))) then
			if (((5274 - 3160) > (104 + 840)) and v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation))) then
				return "annihilation rotation 20";
			end
		end
		if ((v78.FelRush:IsReady() and v31 and v42 and v78.Momentum:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (4 - 1))) and (v13:BuffRemains(v78.MomentumBuff) < (2 + 3)) and v13:BuffDown(v78.MetamorphosisBuff)) or ((5606 - 3344) >= (4122 - (834 + 192)))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((144 + 2111) >= (908 + 2629))) then
				return "fel_rush rotation 22";
			end
		end
		if ((v78.EyeBeam:IsCastable() and v39 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and ((v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.Metamorphosis:CooldownRemains() > ((46 - 16) - (v23(v78.CycleOfHatred:IsAvailable()) * (319 - (300 + 4))))) or ((v78.Metamorphosis:CooldownRemains() < (v97 * (1 + 1))) and (not v78.EssenceBreak:IsAvailable() or (v78.EssenceBreak:CooldownRemains() < (v97 * (2.5 - 1)))))) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > v97) or not v78.RestlessHunter:IsAvailable()) and (v78.CycleOfHatred:IsAvailable() or not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (367 - (112 + 250))) or not v47 or (v9.CombatTime() < (4 + 6))) and v13:BuffDown(v78.InnerDemonBuff)) or (v101 < (37 - 22)))) or ((2199 + 1638) < (676 + 630))) then
			if (((2207 + 743) == (1463 + 1487)) and v20(v78.EyeBeam, not v14:IsInRange(6 + 2))) then
				return "eye_beam rotation 26";
			end
		end
		if ((v78.BladeDance:IsCastable() and v33 and v90 and ((v78.EyeBeam:CooldownRemains() > (1419 - (1001 + 413))) or not v78.Demonic:IsAvailable() or v13:HasTier(69 - 38, 884 - (244 + 638)))) or ((5416 - (627 + 66)) < (9826 - 6528))) then
			if (((1738 - (512 + 90)) >= (2060 - (1665 + 241))) and v20(v78.BladeDance, not v14:IsInRange(725 - (373 + 344)))) then
				return "blade_dance rotation 28";
			end
		end
		if ((v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff) and (v87 >= (2 + 2))) or ((72 + 199) > (12523 - 7775))) then
			if (((8021 - 3281) >= (4251 - (35 + 1064))) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(6 + 2)) or ((5515 - 2937) >= (14 + 3376))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif (((1277 - (298 + 938)) <= (2920 - (233 + 1026))) and (v77 == "cursor")) then
				if (((2267 - (636 + 1030)) < (1821 + 1739)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(40 + 0))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if (((70 + 165) < (47 + 640)) and v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(222 - (55 + 166), v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v87 >= ((1 + 1) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.ThrowGlaive:FullRechargeTime() < (v97 * (1 + 2))) or (v87 > (3 - 2))) and not v13:HasTier(328 - (36 + 261), 3 - 1)) then
			if (((5917 - (34 + 1334)) > (444 + 709)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 32";
			end
		end
		if ((v78.ImmolationAura:IsCastable() and v44 and (v87 >= (2 + 0)) and (v13:Fury() < (1353 - (1035 + 248))) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((4695 - (20 + 1)) < (2435 + 2237))) then
			if (((3987 - (134 + 185)) < (5694 - (549 + 584))) and v20(v78.ImmolationAura, not v14:IsInRange(693 - (314 + 371)))) then
				return "immolation_aura rotation 34";
			end
		end
		if ((v78.Annihilation:IsCastable() and v32 and not v91 and ((v78.EssenceBreak:CooldownRemains() > (0 - 0)) or not v78.EssenceBreak:IsAvailable()) and v13:BuffDown(v78.FelBarrage)) or v13:HasTier(998 - (478 + 490), 2 + 0) or ((1627 - (786 + 386)) == (11676 - 8071))) then
			if (v20(v78.Annihilation, not v14:IsSpellInRange(v78.Annihilation)) or ((4042 - (1055 + 324)) == (4652 - (1093 + 247)))) then
				return "annihilation rotation 36";
			end
		end
		if (((3801 + 476) <= (471 + 4004)) and v78.Felblade:IsCastable() and v41 and not v13:PrevGCDP(3 - 2, v78.VengefulRetreat) and (((v13:FuryDeficit() >= (135 - 95)) and v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v78.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)))) then
			if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((2475 - 1605) == (2987 - 1798))) then
				return "felblade rotation 38";
			end
		end
		if (((553 + 1000) <= (12069 - 8936)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and v78.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (103 - 73))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((1687 + 550) >= (8978 - 5467))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(696 - (364 + 324))) or ((3629 - 2305) > (7246 - 4226))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif ((v77 == "cursor") or ((992 + 2000) == (7870 - 5989))) then
				if (((4974 - 1868) > (4634 - 3108)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(1308 - (1249 + 19)))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if (((2729 + 294) < (15064 - 11194)) and v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(1087 - (686 + 400), v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v88 >= ((2 + 0) - v23(v78.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v78.EssenceBreakDebuff) and not v13:HasTier(260 - (73 + 156), 1 + 1)) then
			if (((954 - (721 + 90)) > (1 + 73)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 40";
			end
		end
		if (((58 - 40) < (2582 - (224 + 246))) and v78.ImmolationAura:IsCastable() and v44 and (v13:BuffStack(v78.ImmolationAuraBuff) < v96) and v14:IsInRange(12 - 4) and (v13:BuffDown(v78.UnboundChaosBuff) or not v78.UnboundChaos:IsAvailable()) and ((v78.ImmolationAura:Recharge() < v78.EssenceBreak:CooldownRemains()) or (not v78.EssenceBreak:IsAvailable() and (v78.EyeBeam:CooldownRemains() > v78.ImmolationAura:Recharge())))) then
			if (((2019 - 922) <= (296 + 1332)) and v20(v78.ImmolationAura, not v14:IsInRange(1 + 7))) then
				return "immolation_aura rotation 42";
			end
		end
		if (((3401 + 1229) == (9205 - 4575)) and v78.ThrowGlaive:IsReady() and v46 and not v13:PrevGCDP(3 - 2, v78.VengefulRetreat) and not v13:IsMoving() and v78.Soulscar:IsAvailable() and (v78.ThrowGlaive:FullRechargeTime() < v78.BladeDance:CooldownRemains()) and v13:HasTier(544 - (203 + 310), 1995 - (1238 + 755)) and v13:BuffDown(v78.FelBarrage) and not v92) then
			if (((248 + 3292) > (4217 - (709 + 825))) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 44";
			end
		end
		if (((8834 - 4040) >= (4770 - 1495)) and v78.ChaosStrike:IsReady() and v34 and not v91 and not v92 and v13:BuffDown(v78.FelBarrage)) then
			if (((2348 - (196 + 668)) == (5859 - 4375)) and v20(v78.ChaosStrike, not v14:IsSpellInRange(v78.ChaosStrike))) then
				return "chaos_strike rotation 46";
			end
		end
		if (((2966 - 1534) < (4388 - (171 + 662))) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and v45 and (v13:FuryDeficit() >= (123 - (4 + 89)))) then
			if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((3732 - 2667) > (1303 + 2275))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(35 - 27)) or ((1881 + 2914) < (2893 - (35 + 1451)))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((3306 - (28 + 1425)) < (6806 - (941 + 1052))) and (v77 == "cursor")) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(29 + 1)) or ((4335 - (822 + 692)) < (3470 - 1039))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if ((v78.Felblade:IsCastable() and v41 and (v13:FuryDeficit() >= (19 + 21)) and not v13:PrevGCDP(298 - (45 + 252), v78.VengefulRetreat)) or ((2844 + 30) < (751 + 1430))) then
			if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((6544 - 3855) <= (776 - (114 + 319)))) then
				return "felblade rotation 50";
			end
		end
		if ((v78.FelRush:IsCastable() and v31 and v42 and not v78.Momentum:IsAvailable() and v78.DemonBlades:IsAvailable() and v78.EyeBeam:CooldownDown() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.FelRush:Recharge() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable())) or ((2682 - 813) == (2573 - 564))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2261 + 1285) < (3458 - 1136))) then
				return "fel_rush rotation 52";
			end
		end
		if ((v78.DemonsBite:IsCastable() and v37 and v78.BurningWound:IsAvailable() and (v14:DebuffRemains(v78.BurningWoundDebuff) < (8 - 4))) or ((4045 - (556 + 1407)) == (5979 - (741 + 465)))) then
			if (((3709 - (170 + 295)) > (556 + 499)) and v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite))) then
				return "demons_bite rotation 54";
			end
		end
		if ((v78.FelRush:IsCastable() and v31 and v42 and not v78.Momentum:IsAvailable() and not v78.DemonBlades:IsAvailable() and (v87 > (1 + 0)) and v13:BuffDown(v78.UnboundChaosBuff)) or ((8156 - 4843) <= (1474 + 304))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((912 + 509) >= (1192 + 912))) then
				return "fel_rush rotation 56";
			end
		end
		if (((3042 - (957 + 273)) <= (869 + 2380)) and v78.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (13 + 17)) and v14:IsInRange(114 - 84)) then
			if (((4276 - 2653) <= (5977 - 4020)) and ((v77 == "player") or v78.ConcentratedSigils:IsAvailable())) then
				if (((21846 - 17434) == (6192 - (389 + 1391))) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(6 + 2))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif (((183 + 1567) >= (1916 - 1074)) and (v77 == "cursor")) then
				if (((5323 - (783 + 168)) > (6208 - 4358)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(30 + 0))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if (((543 - (309 + 2)) < (2521 - 1700)) and v78.DemonsBite:IsCastable() and v37) then
			if (((1730 - (1090 + 122)) < (293 + 609)) and v20(v78.DemonsBite, not v14:IsSpellInRange(v78.DemonsBite))) then
				return "demons_bite rotation 57";
			end
		end
		if (((10055 - 7061) > (588 + 270)) and v78.FelRush:IsReady() and v31 and v42 and not v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) <= (1138 - (628 + 490)))) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((674 + 3081) <= (2265 - 1350))) then
				return "fel_rush rotation 58";
			end
		end
		if (((18033 - 14087) > (4517 - (431 + 343))) and v78.FelRush:IsReady() and v31 and v42 and not v14:IsInRange(16 - 8) and not v78.Momentum:IsAvailable()) then
			if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((3862 - 2527) >= (2612 + 694))) then
				return "fel_rush rotation 59";
			end
		end
		if (((620 + 4224) > (3948 - (556 + 1139))) and v78.VengefulRetreat:IsCastable() and v31 and v47 and v78.Felblade:CooldownDown() and not v78.Initiative:IsAvailable() and not v14:IsInRange(23 - (6 + 9))) then
			if (((83 + 369) == (232 + 220)) and v20(v78.VengefulRetreat, not v14:IsInRange(177 - (28 + 141)), nil, true)) then
				return "vengeful_retreat rotation 60";
			end
		end
		if ((v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat) and not v13:IsMoving() and (v78.DemonBlades:IsAvailable() or not v14:IsInRange(14 - 2)) and v14:DebuffDown(v78.EssenceBreakDebuff) and v14:IsSpellInRange(v78.ThrowGlaive) and not v13:HasTier(22 + 9, 1319 - (486 + 831))) or ((11858 - 7301) < (7347 - 5260))) then
			if (((733 + 3141) == (12249 - 8375)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v111()
		local v122 = 1263 - (668 + 595);
		while true do
			if ((v122 == (2 + 0)) or ((391 + 1547) > (13458 - 8523))) then
				v40 = EpicSettings.Settings['useFelBarrage'];
				v41 = EpicSettings.Settings['useFelblade'];
				v42 = EpicSettings.Settings['useFelRush'];
				v43 = EpicSettings.Settings['useGlaiveTempest'];
				v122 = 293 - (23 + 267);
			end
			if ((v122 == (1947 - (1129 + 815))) or ((4642 - (371 + 16)) < (5173 - (1326 + 424)))) then
				v44 = EpicSettings.Settings['useImmolationAura'];
				v45 = EpicSettings.Settings['useSigilOfFlame'];
				v46 = EpicSettings.Settings['useThrowGlaive'];
				v47 = EpicSettings.Settings['useVengefulRetreat'];
				v122 = 7 - 3;
			end
			if (((5313 - 3859) <= (2609 - (88 + 30))) and ((776 - (720 + 51)) == v122)) then
				v56 = EpicSettings.Settings['metamorphosisWithCD'];
				v57 = EpicSettings.Settings['theHuntWithCD'];
				v58 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if ((v122 == (1780 - (421 + 1355))) or ((6857 - 2700) <= (1377 + 1426))) then
				v52 = EpicSettings.Settings['useElysianDecree'];
				v53 = EpicSettings.Settings['useMetamorphosis'];
				v54 = EpicSettings.Settings['useTheHunt'];
				v55 = EpicSettings.Settings['elysianDecreeWithCD'];
				v122 = 1088 - (286 + 797);
			end
			if (((17740 - 12887) >= (4938 - 1956)) and ((440 - (397 + 42)) == v122)) then
				v36 = EpicSettings.Settings['useDeathSweep'];
				v37 = EpicSettings.Settings['useDemonsBite'];
				v38 = EpicSettings.Settings['useEssenceBreak'];
				v39 = EpicSettings.Settings['useEyeBeam'];
				v122 = 1 + 1;
			end
			if (((4934 - (24 + 776)) > (5171 - 1814)) and ((785 - (222 + 563)) == v122)) then
				v32 = EpicSettings.Settings['useAnnihilation'];
				v33 = EpicSettings.Settings['useBladeDance'];
				v34 = EpicSettings.Settings['useChaosStrike'];
				v35 = EpicSettings.Settings['useConsumeMagic'];
				v122 = 1 - 0;
			end
		end
	end
	local function v112()
		v48 = EpicSettings.Settings['useChaosNova'];
		v49 = EpicSettings.Settings['useDisrupt'];
		v50 = EpicSettings.Settings['useFelEruption'];
		v51 = EpicSettings.Settings['useSigilOfMisery'];
		v60 = EpicSettings.Settings['useBlur'];
		v61 = EpicSettings.Settings['useNetherwalk'];
		v62 = EpicSettings.Settings['blurHP'] or (0 + 0);
		v63 = EpicSettings.Settings['netherwalkHP'] or (190 - (23 + 167));
		v77 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v113()
		local v129 = 1798 - (690 + 1108);
		while true do
			if ((v129 == (2 + 2)) or ((2819 + 598) < (3382 - (40 + 808)))) then
				v65 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v129 == (1 + 1)) or ((10408 - 7686) <= (157 + 7))) then
				v71 = EpicSettings.Settings['trinketsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v72 = EpicSettings.Settings['useHealingPotion'];
				v129 = 2 + 1;
			end
			if ((v129 == (0 + 0)) or ((2979 - (47 + 524)) < (1369 + 740))) then
				v69 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v64 = EpicSettings.Settings['dispelBuffs'];
				v66 = EpicSettings.Settings['InterruptWithStun'];
				v129 = 1 - 0;
			end
			if ((v129 == (2 - 1)) or ((1759 - (1165 + 561)) == (44 + 1411))) then
				v67 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v68 = EpicSettings.Settings['InterruptThreshold'];
				v70 = EpicSettings.Settings['useTrinkets'];
				v129 = 6 - 4;
			end
			if ((v129 == (2 + 1)) or ((922 - (341 + 138)) >= (1084 + 2931))) then
				v75 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v74 = EpicSettings.Settings['healingPotionHP'] or (326 - (89 + 237));
				v76 = EpicSettings.Settings['HealingPotionName'] or "";
				v129 = 12 - 8;
			end
		end
	end
	local function v114()
		local v130 = 0 - 0;
		while true do
			if (((4263 - (581 + 300)) > (1386 - (855 + 365))) and (v130 == (0 - 0))) then
				v112();
				v111();
				v113();
				v130 = 1 + 0;
			end
			if ((v130 == (1237 - (1030 + 205))) or ((263 + 17) == (2846 + 213))) then
				v31 = EpicSettings.Toggles['movement'];
				if (((2167 - (156 + 130)) > (2937 - 1644)) and v13:IsDeadOrGhost()) then
					return v27;
				end
				v85 = v13:GetEnemiesInMeleeRange(13 - 5);
				v130 = 5 - 2;
			end
			if (((622 + 1735) == (1375 + 982)) and (v130 == (72 - (10 + 59)))) then
				v86 = v13:GetEnemiesInMeleeRange(6 + 14);
				if (((605 - 482) == (1286 - (671 + 492))) and v29) then
					local v167 = 0 + 0;
					while true do
						if ((v167 == (1215 - (369 + 846))) or ((280 + 776) >= (2895 + 497))) then
							v87 = ((#v85 > (1945 - (1036 + 909))) and #v85) or (1 + 0);
							v88 = #v86;
							break;
						end
					end
				else
					v87 = 1 - 0;
					v88 = 204 - (11 + 192);
				end
				v97 = v13:GCD() + 0.05 + 0;
				v130 = 179 - (135 + 40);
			end
			if ((v130 == (2 - 1)) or ((652 + 429) < (2368 - 1293))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v130 = 2 - 0;
			end
			if ((v130 == (180 - (50 + 126))) or ((2920 - 1871) >= (981 + 3451))) then
				if (v22.TargetIsValid() or v13:AffectingCombat() or ((6181 - (1233 + 180)) <= (1815 - (522 + 447)))) then
					v100 = v9.BossFightRemains(nil, true);
					v101 = v100;
					if ((v101 == (12532 - (107 + 1314))) or ((1559 + 1799) <= (4326 - 2906))) then
						v101 = v9.FightRemains(v85, false);
					end
				end
				v27 = v106();
				if (v27 or ((1589 + 2150) <= (5967 - 2962))) then
					return v27;
				end
				v130 = 19 - 14;
			end
			if ((v130 == (1915 - (716 + 1194))) or ((29 + 1630) >= (229 + 1905))) then
				if (v65 or ((3763 - (74 + 429)) < (4543 - 2188))) then
					v27 = v22.HandleIncorporeal(v78.Imprison, v80.ImprisonMouseover, 15 + 15, true);
					if (v27 or ((1531 - 862) == (2988 + 1235))) then
						return v27;
					end
				end
				if ((v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((5216 - 3524) < (1453 - 865))) then
					local v168 = 433 - (279 + 154);
					local v169;
					while true do
						if (((782 - (454 + 324)) == v168) or ((3775 + 1022) < (3668 - (12 + 5)))) then
							if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.ImmolationAura:FullRechargeTime() < v78.EssenceBreak:CooldownRemains()) or not v78.EssenceBreak:IsAvailable()) and v14:DebuffDown(v78.EssenceBreakDebuff) and (v13:BuffDown(v78.MetamorphosisBuff) or (v13:BuffRemains(v78.MetamorphosisBuff) > (4 + 2))) and v78.BladeDance:CooldownDown() and ((v13:Fury() < (190 - 115)) or (v78.BladeDance:CooldownRemains() < (v97 * (1 + 1))))) or ((5270 - (277 + 816)) > (20724 - 15874))) then
								if (v20(v78.ImmolationAura, not v14:IsInRange(1191 - (1058 + 125))) or ((75 + 325) > (2086 - (815 + 160)))) then
									return "immolation_aura main 6";
								end
							end
							if (((13090 - 10039) > (2385 - 1380)) and v78.FelRush:IsCastable() and v31 and v42 and ((v13:BuffRemains(v78.UnboundChaosBuff) < (v97 * (1 + 1))) or (v14:TimeToDie() < (v97 * (5 - 3))))) then
								if (((5591 - (41 + 1857)) <= (6275 - (1222 + 671))) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fel_rush main 8";
								end
							end
							if ((v78.FelRush:IsCastable() and v31 and v42 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffUp(v78.UnboundChaosBuff) and ((v78.EyeBeam:CooldownRemains() + (7 - 4)) > v13:BuffRemains(v78.UnboundChaosBuff)) and (v78.BladeDance:CooldownDown() or v78.EssenceBreak:CooldownUp())) or ((4717 - 1435) > (5282 - (229 + 953)))) then
								if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((5354 - (1111 + 663)) < (4423 - (874 + 705)))) then
									return "fel_rush main 9";
								end
							end
							if (((13 + 76) < (3064 + 1426)) and v78.FelRush:IsCastable() and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and (v13:BuffUp(v78.MetamorphosisBuff) or (v78.EssenceBreak:CooldownRemains() > (20 - 10)))) then
								if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((141 + 4842) < (2487 - (642 + 37)))) then
									return "fel_rush main 10";
								end
							end
							v168 = 2 + 3;
						end
						if (((613 + 3216) > (9462 - 5693)) and (v168 == (455 - (233 + 221)))) then
							if (((3433 - 1948) <= (2557 + 347)) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v15:NPCID())) then
								if (((5810 - (718 + 823)) == (2687 + 1582)) and v20(v80.ThrowGlaiveMouseover, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v90 = v78.FirstBlood:IsAvailable() or v78.TrailofRuin:IsAvailable() or (v78.ChaosTheory:IsAvailable() and v13:BuffDown(v78.ChaosTheoryBuff)) or (v87 > (806 - (266 + 539)));
							v91 = v90 and (v13:Fury() < ((212 - 137) - (v23(v78.DemonBlades:IsAvailable()) * (1245 - (636 + 589))))) and (v78.BladeDance:CooldownRemains() < v97);
							v92 = v78.Demonic:IsAvailable() and not v78.BlindFury:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v97 * (4 - 2))) and (v13:FuryDeficit() > (61 - 31));
							v168 = 2 + 0;
						end
						if (((141 + 246) <= (3797 - (657 + 358))) and ((7 - 4) == v168)) then
							if ((v78.ImmolationAura:IsCastable() and v44 and v78.AFireInside:IsAvailable() and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (v78.ImmolationAura:FullRechargeTime() < (v97 * (4 - 2))) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((3086 - (1151 + 36)) <= (886 + 31))) then
								if (v20(v78.ImmolationAura, not v14:IsInRange(3 + 5)) or ((12877 - 8565) <= (2708 - (1552 + 280)))) then
									return "immolation_aura main 3";
								end
							end
							if (((3066 - (64 + 770)) <= (1763 + 833)) and v78.FelRush:IsCastable() and v31 and v42 and v13:BuffUp(v78.UnboundChaosBuff) and (((v78.ImmolationAura:Charges() == (4 - 2)) and v14:DebuffDown(v78.EssenceBreakDebuff)) or (v13:PrevGCDP(1 + 0, v78.EyeBeam) and v13:BuffUp(v78.InertiaBuff) and (v13:BuffRemains(v78.InertiaBuff) < (1246 - (157 + 1086)))))) then
								if (((4193 - 2098) < (16143 - 12457)) and v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive))) then
									return "fel_rush main 4";
								end
							end
							if ((v78.TheHunt:IsCastable() and (v9.CombatTime() < (15 - 5)) and (not v78.Inertia:IsAvailable() or (v13:BuffUp(v78.MetamorphosisBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)))) or ((2176 - 581) >= (5293 - (599 + 220)))) then
								if (v20(v78.TheHunt, not v14:IsSpellInRange(v78.TheHunt)) or ((9197 - 4578) < (4813 - (1813 + 118)))) then
									return "the_hunt main 6";
								end
							end
							if ((v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and ((v78.EyeBeam:CooldownRemains() < (v97 * (2 + 0))) or v13:BuffUp(v78.MetamorphosisBuff)) and (v78.EssenceBreak:CooldownRemains() < (v97 * (1220 - (841 + 376)))) and v13:BuffDown(v78.UnboundChaosBuff) and v13:BuffDown(v78.InertiaBuff) and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((411 - 117) >= (1123 + 3708))) then
								if (((5538 - 3509) <= (3943 - (464 + 395))) and v20(v78.ImmolationAura, not v14:IsInRange(20 - 12))) then
									return "immolation_aura main 5";
								end
							end
							v168 = 2 + 2;
						end
						if ((v168 == (839 - (467 + 370))) or ((4209 - 2172) == (1777 + 643))) then
							v94 = (v78.Momentum:IsAvailable() and v13:BuffDown(v78.MomentumBuff)) or (v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff));
							v169 = v26(v78.EyeBeam:BaseDuration(), v13:GCD());
							v95 = v78.Demonic:IsAvailable() and v78.EssenceBreak:IsAvailable() and (v101 > (v78.Metamorphosis:CooldownRemains() + (102 - 72) + (v23(v78.ShatteredDestiny:IsAvailable()) * (10 + 50)))) and (v78.Metamorphosis:CooldownRemains() < (46 - 26)) and (v78.Metamorphosis:CooldownRemains() > (v169 + (v97 * (v23(v78.InnerDemon:IsAvailable()) + (522 - (150 + 370))))));
							if (((5740 - (74 + 1208)) > (9601 - 5697)) and v78.ImmolationAura:IsCastable() and v44 and v78.Ragefire:IsAvailable() and (v87 >= (14 - 11)) and (v78.BladeDance:CooldownDown() or v14:DebuffDown(v78.EssenceBreakDebuff))) then
								if (((311 + 125) >= (513 - (14 + 376))) and v20(v78.ImmolationAura, not v14:IsInRange(13 - 5))) then
									return "immolation_aura main 2";
								end
							end
							v168 = 2 + 1;
						end
						if (((440 + 60) < (1732 + 84)) and (v168 == (14 - 9))) then
							if (((2689 + 885) == (3652 - (23 + 55))) and (v69 < v101) and v30) then
								v27 = v109();
								if (((523 - 302) < (261 + 129)) and v27) then
									return v27;
								end
							end
							if ((v13:BuffUp(v78.MetamorphosisBuff) and (v13:BuffRemains(v78.MetamorphosisBuff) < v97) and (v87 < (3 + 0))) or ((3430 - 1217) <= (447 + 974))) then
								v27 = v108();
								if (((3959 - (652 + 249)) < (13006 - 8146)) and v27) then
									return v27;
								end
							end
							v27 = v110();
							if (v27 or ((3164 - (708 + 1160)) >= (12068 - 7622))) then
								return v27;
							end
							v168 = 10 - 4;
						end
						if ((v168 == (33 - (10 + 17))) or ((313 + 1080) > (6221 - (1400 + 332)))) then
							if ((v78.DemonBlades:IsAvailable()) or ((8485 - 4061) < (1935 - (242 + 1666)))) then
								if (v20(v78.Pool) or ((855 + 1142) > (1399 + 2416))) then
									return "pool demon_blades";
								end
							end
							break;
						end
						if (((2954 + 511) > (2853 - (850 + 90))) and (v168 == (0 - 0))) then
							if (((2123 - (360 + 1030)) < (1610 + 209)) and not v13:AffectingCombat()) then
								v27 = v107();
								if (v27 or ((12404 - 8009) == (6541 - 1786))) then
									return v27;
								end
							end
							if ((v78.ConsumeMagic:IsAvailable() and v35 and v78.ConsumeMagic:IsReady() and v64 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) or ((5454 - (909 + 752)) < (3592 - (109 + 1114)))) then
								if (v20(v78.ConsumeMagic, not v14:IsSpellInRange(v78.ConsumeMagic)) or ((7476 - 3392) == (104 + 161))) then
									return "greater_purge damage";
								end
							end
							if (((4600 - (6 + 236)) == (2746 + 1612)) and v78.FelRush:IsReady() and v31 and v42 and not v14:IsInRange(7 + 1)) then
								if (v20(v78.FelRush, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((7400 - 4262) < (1734 - 741))) then
									return "fel_rush rotation when OOR";
								end
							end
							if (((4463 - (1076 + 57)) > (383 + 1940)) and v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v102, v14:NPCID())) then
								if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((4315 - (579 + 110)) == (315 + 3674))) then
									return "fodder to the flames react per target";
								end
							end
							v168 = 1 + 0;
						end
					end
				end
				break;
			end
		end
	end
	local function v115()
		v78.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(307 + 270, v114, v115);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

