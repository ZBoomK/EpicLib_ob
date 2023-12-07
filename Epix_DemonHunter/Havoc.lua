local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4000 - (622 + 713)) <= (16804 - 12871)) and not v5) then
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
	local v88 = (v87[41 - 28] and v18(v87[1752 - (404 + 1335)])) or v18(406 - (183 + 223));
	local v89 = (v87[16 - 2] and v18(v87[10 + 4])) or v18(0 + 0);
	local v90, v91;
	local v92, v93;
	local v94 = {{v83.FelEruption},{v83.ChaosNova}};
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = ((v83.AFireInside:IsAvailable()) and (454 - (108 + 341))) or (1 + 0);
	local v102 = v13:GCD() + (0.25 - 0);
	local v103 = 1493 - (711 + 782);
	local v104 = false;
	local v105 = 21299 - 10188;
	local v106 = 11580 - (270 + 199);
	local v107 = {(171240 - (580 + 1239)),(161997 + 7428),(73591 + 95341),(105257 + 64169),(171219 - (1010 + 780)),(807139 - 637711),(171266 - (1045 + 791))};
	v9:RegisterForEvent(function()
		local v121 = 0 - 0;
		while true do
			if (((4997 - 1724) == (3778 - (351 + 154))) and (v121 == (1574 - (1281 + 293)))) then
				v95 = false;
				v96 = false;
				v121 = 267 - (28 + 238);
			end
			if (((8544 - 4720) > (1968 - (1381 + 178))) and (v121 == (3 + 0))) then
				v106 = 8960 + 2151;
				break;
			end
			if (((891 + 1196) == (7194 - 5107)) and (v121 == (2 + 0))) then
				v99 = false;
				v105 = 11581 - (381 + 89);
				v121 = 3 + 0;
			end
			if ((v121 == (1 + 0)) or ((5830 - 2426) > (5659 - (1074 + 82)))) then
				v97 = false;
				v98 = false;
				v121 = 3 - 1;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v87 = v13:GetEquipment();
		v88 = (v87[1797 - (214 + 1570)] and v18(v87[1468 - (990 + 465)])) or v18(0 + 0);
		v89 = (v87[7 + 7] and v18(v87[14 + 0])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v9:RegisterForEvent(function()
		v101 = ((v83.AFireInside:IsAvailable()) and (1731 - (1668 + 58))) or (627 - (512 + 114));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v108(v122)
		return v122:DebuffRemains(v83.BurningWoundDebuff) or v122:DebuffRemains(v83.BurningWoundLegDebuff);
	end
	local function v109(v123)
		return v83.BurningWound:IsAvailable() and (v123:DebuffRemains(v83.BurningWoundDebuff) < (10 - 6)) and (v83.BurningWoundDebuff:AuraActiveCount() < v28(v92, 5 - 2));
	end
	local function v110()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (1 + 0)) or ((657 + 2849) <= (1138 + 171))) then
				v30 = v25.HandleBottomTrinket(v86, v33, 134 - 94, nil);
				if (((4949 - (109 + 1885)) == (4424 - (1269 + 200))) and v30) then
					return v30;
				end
				break;
			end
			if ((v124 == (0 - 0)) or ((3718 - (98 + 717)) == (2321 - (802 + 24)))) then
				v30 = v25.HandleTopTrinket(v86, v33, 68 - 28, nil);
				if (((5741 - 1195) >= (336 + 1939)) and v30) then
					return v30;
				end
				v124 = 1 + 0;
			end
		end
	end
	local function v111()
		local v125 = 0 + 0;
		while true do
			if (((177 + 642) >= (61 - 39)) and (v125 == (0 - 0))) then
				if (((1131 + 2031) == (1288 + 1874)) and v83.Blur:IsCastable() and v63 and (v13:HealthPercentage() <= v65)) then
					if (v23(v83.Blur) or ((1955 + 414) > (3221 + 1208))) then
						return "blur defensive";
					end
				end
				if (((1912 + 2183) >= (4616 - (797 + 636))) and v83.Netherwalk:IsCastable() and v64 and (v13:HealthPercentage() <= v66)) then
					if (v23(v83.Netherwalk) or ((18018 - 14307) < (2627 - (1427 + 192)))) then
						return "netherwalk defensive";
					end
				end
				v125 = 1 + 0;
			end
			if ((v125 == (2 - 1)) or ((943 + 106) <= (411 + 495))) then
				if (((4839 - (192 + 134)) > (4002 - (316 + 960))) and v84.Healthstone:IsReady() and v78 and (v13:HealthPercentage() <= v80)) then
					if (v23(v85.Healthstone) or ((825 + 656) >= (2052 + 606))) then
						return "healthstone defensive";
					end
				end
				if ((v77 and (v13:HealthPercentage() <= v79)) or ((2977 + 243) == (5214 - 3850))) then
					if ((v81 == "Refreshing Healing Potion") or ((1605 - (83 + 468)) > (5198 - (1202 + 604)))) then
						if (v84.RefreshingHealingPotion:IsReady() or ((3155 - 2479) >= (2732 - 1090))) then
							if (((11451 - 7315) > (2722 - (45 + 280))) and v23(v85.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v81 == "Dreamwalker's Healing Potion") or ((4184 + 150) == (3709 + 536))) then
						if (v84.DreamwalkersHealingPotion:IsReady() or ((1562 + 2714) <= (1678 + 1353))) then
							if (v23(v85.RefreshingHealingPotion) or ((842 + 3940) <= (2219 - 1020))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v112()
		if ((v83.ImmolationAura:IsCastable() and v47) or ((6775 - (340 + 1571)) < (751 + 1151))) then
			if (((6611 - (1733 + 39)) >= (10167 - 6467)) and v23(v83.ImmolationAura, not v14:IsInRange(1042 - (125 + 909)))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v48 and not v13:IsMoving() and (v92 > (1949 - (1096 + 852))) and v83.SigilOfFlame:IsCastable()) or ((483 + 592) > (2738 - 820))) then
			if (((385 + 11) <= (4316 - (409 + 103))) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(244 - (46 + 190))) or ((4264 - (51 + 44)) == (617 + 1570))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((2723 - (1114 + 203)) == (2132 - (228 + 498))) and (v82 == "cursor")) then
				if (((332 + 1199) < (2360 + 1911)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(703 - (174 + 489)))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((1654 - 1019) == (2540 - (830 + 1075))) and not v14:IsInMeleeRange(529 - (303 + 221)) and v83.Felblade:IsCastable()) then
			if (((4642 - (231 + 1038)) <= (2964 + 592)) and v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade))) then
				return "felblade precombat 9";
			end
		end
		if ((not v14:IsInMeleeRange(1167 - (171 + 991)) and v83.FelRush:IsCastable() and (not v83.Felblade:IsAvailable() or (v83.Felblade:CooldownDown() and not v13:PrevGCDP(4 - 3, v83.Felblade))) and v34 and v45) or ((8836 - 5545) < (8185 - 4905))) then
			if (((3511 + 875) >= (3060 - 2187)) and v23(v83.FelRush, not v14:IsInRange(43 - 28))) then
				return "fel_rush precombat 10";
			end
		end
		if (((1484 - 563) <= (3406 - 2304)) and v14:IsInMeleeRange(1253 - (111 + 1137)) and v40 and (v83.DemonsBite:IsCastable() or v83.DemonBlades:IsAvailable())) then
			if (((4864 - (91 + 67)) >= (2866 - 1903)) and v23(v83.DemonsBite, not v14:IsInMeleeRange(2 + 3))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v113()
		if (v13:BuffDown(v83.FelBarrage) or ((1483 - (423 + 100)) <= (7 + 869))) then
			if ((v83.DeathSweep:IsReady() and v39) or ((5719 - 3653) == (486 + 446))) then
				if (((5596 - (326 + 445)) < (21134 - 16291)) and v23(v83.DeathSweep, not v14:IsInRange(17 - 9))) then
					return "death_sweep meta_end 2";
				end
			end
			if ((v83.Annihilation:IsReady() and v35) or ((9049 - 5172) >= (5248 - (530 + 181)))) then
				if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((5196 - (614 + 267)) < (1758 - (19 + 13)))) then
					return "annihilation meta_end 4";
				end
			end
		end
	end
	local function v114()
		local v126 = 0 - 0;
		local v127;
		while true do
			if ((v126 == (4 - 2)) or ((10509 - 6830) < (163 + 462))) then
				if ((v55 and not v13:IsMoving() and ((v33 and v58) or not v58) and v83.ElysianDecree:IsCastable() and (v14:DebuffDown(v83.EssenceBreakDebuff)) and (v92 > v62)) or ((8133 - 3508) < (1310 - 678))) then
					if ((v61 == "player") or ((1895 - (1293 + 519)) > (3631 - 1851))) then
						if (((1425 - 879) <= (2059 - 982)) and v23(v85.ElysianDecreePlayer, not v14:IsInRange(34 - 26))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif ((v61 == "cursor") or ((2346 - 1350) > (2278 + 2023))) then
						if (((831 + 3239) > (1596 - 909)) and v23(v85.ElysianDecreeCursor, not v14:IsInRange(7 + 23))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if ((v74 < v106) or ((218 + 438) >= (2081 + 1249))) then
					if ((v75 and ((v33 and v76) or not v76)) or ((3588 - (709 + 387)) <= (2193 - (673 + 1185)))) then
						local v176 = 0 - 0;
						while true do
							if (((13878 - 9556) >= (4214 - 1652)) and ((0 + 0) == v176)) then
								v30 = v110();
								if (v30 or ((2718 + 919) >= (5090 - 1320))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v126 == (0 + 0)) or ((4743 - 2364) > (8986 - 4408))) then
				if ((((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and not v83.Demonic:IsAvailable()) or ((2363 - (446 + 1434)) > (2026 - (1040 + 243)))) then
					if (((7324 - 4870) > (2425 - (559 + 1288))) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(1939 - (609 + 1322)))) then
						return "metamorphosis cooldown 4";
					end
				end
				if (((1384 - (13 + 441)) < (16658 - 12200)) and ((v33 and v59) or not v59) and v83.Metamorphosis:IsCastable() and v56 and v83.Demonic:IsAvailable() and ((not v83.ChaoticTransformation:IsAvailable() and v83.EyeBeam:CooldownDown()) or ((v83.EyeBeam:CooldownRemains() > (52 - 32)) and (not v95 or v13:PrevGCDP(4 - 3, v83.DeathSweep) or v13:PrevGCDP(1 + 1, v83.DeathSweep))) or ((v106 < ((90 - 65) + (v26(v83.ShatteredDestiny:IsAvailable()) * (25 + 45)))) and v83.EyeBeam:CooldownDown() and v83.BladeDance:CooldownDown())) and v13:BuffDown(v83.InnerDemonBuff)) then
					if (((291 + 371) <= (2884 - 1912)) and v23(v85.MetamorphosisPlayer, not v14:IsInRange(5 + 3))) then
						return "metamorphosis cooldown 6";
					end
				end
				v126 = 1 - 0;
			end
			if (((2890 + 1480) == (2431 + 1939)) and ((1 + 0) == v126)) then
				v127 = v25.HandleDPSPotion(v13:BuffUp(v83.MetamorphosisBuff));
				if (v127 or ((3999 + 763) <= (843 + 18))) then
					return v127;
				end
				v126 = 435 - (153 + 280);
			end
		end
	end
	local function v115()
		if ((v83.EssenceBreak:IsCastable() and v41 and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (28 - 18)))) or ((1268 + 144) == (1684 + 2580))) then
			if (v23(v83.EssenceBreak, not v14:IsInRange(5 + 3)) or ((2875 + 293) < (1561 + 592))) then
				return "essence_break rotation prio";
			end
		end
		if ((v83.BladeDance:IsCastable() and v36 and v13:BuffUp(v83.EssenceBreakBuff)) or ((7576 - 2600) < (824 + 508))) then
			if (((5295 - (89 + 578)) == (3307 + 1321)) and v23(v83.BladeDance, not v14:IsInRange(16 - 8))) then
				return "blade_dance rotation prio";
			end
		end
		if ((v83.DeathSweep:IsCastable() and v39 and v13:BuffUp(v83.EssenceBreakBuff)) or ((1103 - (572 + 477)) == (54 + 341))) then
			if (((50 + 32) == (10 + 72)) and v23(v83.DeathSweep, not v14:IsInRange(94 - (84 + 2)))) then
				return "death_sweep rotation prio";
			end
		end
		if ((v83.Annihilation:IsCastable() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.Metamorphosis:CooldownRemains() <= (v13:GCD() * (4 - 1)))) or ((419 + 162) < (1124 - (497 + 345)))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((118 + 4491) < (422 + 2073))) then
				return "annihilation rotation 2";
			end
		end
		if (((2485 - (605 + 728)) == (822 + 330)) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and (v83.EyeBeam:CooldownRemains() < (0.3 - 0)) and (v83.EssenceBreak:CooldownRemains() < (v102 * (1 + 1))) and (v9.CombatTime() > (18 - 13)) and (v13:Fury() >= (28 + 2)) and v83.Inertia:IsAvailable()) then
			if (((5252 - 3356) <= (2584 + 838)) and v23(v83.VengefulRetreat, not v14:IsInRange(497 - (457 + 32)), nil, true)) then
				return "vengeful_retreat rotation 3";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 + 0)) and ((v83.EssenceBreak:CooldownRemains() > (1417 - (832 + 570))) or ((v83.EssenceBreak:CooldownRemains() < v102) and (not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > (15 + 0 + ((3 + 7) * v26(v83.CycleOfHatred:IsAvailable()))))))) and ((v9.CombatTime() < (106 - 76)) or ((v13:GCDRemains() - (1 + 0)) < (796 - (588 + 208)))) and (not v83.Initiative:IsAvailable() or (v13:BuffRemains(v83.InitiativeBuff) < v102) or (v9.CombatTime() > (10 - 6)))) or ((2790 - (884 + 916)) > (3391 - 1771))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(5 + 3), nil, true) or ((1530 - (232 + 421)) > (6584 - (1569 + 320)))) then
				return "vengeful_retreat rotation 4";
			end
		end
		if (((661 + 2030) >= (352 + 1499)) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (3 - 2)) and ((v83.EssenceBreak:CooldownRemains() > (620 - (316 + 289))) or ((v83.EssenceBreak:CooldownRemains() < (v102 * (5 - 3))) and (((v13:BuffRemains(v83.InitiativeBuff) < v102) and not v100 and (v83.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and (v13:Fury() > (2 + 28))) or not v83.Demonic:IsAvailable() or v13:BuffUp(v83.MetamorphosisBuff) or (v83.EyeBeam:CooldownRemains() > ((1468 - (666 + 787)) + ((435 - (360 + 65)) * v26(v83.CycleofHatred:IsAvailable()))))))) and (v13:BuffDown(v83.UnboundChaosBuff) or v13:BuffUp(v83.InertiaBuff))) then
			if (v23(v83.VengefulRetreat, not v14:IsInRange(8 + 0), nil, true) or ((3239 - (79 + 175)) >= (7656 - 2800))) then
				return "vengeful_retreat rotation 6";
			end
		end
		if (((3337 + 939) >= (3662 - 2467)) and v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and v83.Initiative:IsAvailable() and not v83.EssenceBreak:IsAvailable() and (v9.CombatTime() > (1 - 0)) and (v13:BuffDown(v83.InitiativeBuff) or (v13:PrevGCDP(900 - (503 + 396), v83.DeathSweep) and v83.Metamorphosis:CooldownUp() and v83.ChaoticTransformation:IsAvailable())) and v83.Initiative:IsAvailable()) then
			if (((3413 - (92 + 89)) <= (9098 - 4408)) and v23(v83.VengefulRetreat, not v14:IsInRange(5 + 3), nil, true)) then
				return "vengeful_retreat rotation 8";
			end
		end
		if ((v83.FelRush:IsCastable() and v34 and v45 and v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) < (v102 * (2 + 0))) and (v83.EyeBeam:CooldownRemains() <= v102) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) or ((3508 - 2612) >= (431 + 2715))) then
			if (((6979 - 3918) >= (2581 + 377)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 10";
			end
		end
		if (((1523 + 1664) >= (1961 - 1317)) and v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or ((v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge()) and (v83.EyeBeam:CooldownRemains() > (1 + 3)))) and v14:DebuffDown(v83.EssenceBreakDebuff) and v83.BladeDance:CooldownDown()) then
			if (((981 - 337) <= (1948 - (485 + 759))) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 11";
			end
		end
		if (((2216 - 1258) > (2136 - (442 + 747))) and v83.EssenceBreak:IsCastable() and v41 and ((((v13:BuffRemains(v83.MetamorphosisBuff) > (v102 * (1138 - (832 + 303)))) or (v83.EyeBeam:CooldownRemains() > (956 - (88 + 858)))) and (not v83.TacticalRetreat:IsAvailable() or v13:BuffUp(v83.TacticalRetreatBuff) or (v9.CombatTime() < (4 + 6))) and (v83.BladeDance:CooldownRemains() <= ((3.1 + 0) * v102))) or (v106 < (1 + 5)))) then
			if (((5281 - (766 + 23)) >= (13102 - 10448)) and v23(v83.EssenceBreak, not v14:IsInRange(10 - 2))) then
				return "essence_break rotation 13";
			end
		end
		if (((9068 - 5626) >= (5101 - 3598)) and v83.DeathSweep:IsCastable() and v39 and v95 and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() > (v102 * (1075 - (1036 + 37))))) and v13:BuffDown(v83.FelBarrage)) then
			if (v23(v83.DeathSweep, not v14:IsInRange(6 + 2)) or ((6173 - 3003) <= (1152 + 312))) then
				return "death_sweep rotation 14";
			end
		end
		if ((v83.TheHunt:IsCastable() and v34 and v57 and (v74 < v106) and ((v33 and v60) or not v60) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v9.CombatTime() < (1490 - (641 + 839))) or (v83.Metamorphosis:CooldownRemains() > (923 - (910 + 3)))) and ((v92 == (2 - 1)) or (v92 > (1687 - (1466 + 218))) or (v106 < (5 + 5))) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and (not v83.FuriousGaze:IsAvailable() or v13:BuffUp(v83.FuriousGazeBuff) or v13:HasTier(1179 - (556 + 592), 2 + 2))) or not v13:HasTier(838 - (329 + 479), 856 - (174 + 680))) and (v9.CombatTime() > (34 - 24))) or ((9942 - 5145) == (3133 + 1255))) then
			if (((1290 - (396 + 343)) <= (61 + 620)) and v23(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt))) then
				return "the_hunt main 12";
			end
		end
		if (((4754 - (29 + 1448)) > (1796 - (135 + 1254))) and v83.FelBarrage:IsCastable() and v43 and ((v92 > (3 - 2)) or ((v92 == (4 - 3)) and (v13:FuryDeficit() < (14 + 6)) and v13:BuffDown(v83.MetamorphosisBuff)))) then
			if (((6222 - (389 + 1138)) >= (1989 - (102 + 472))) and v23(v83.FelBarrage, not v14:IsInRange(8 + 0))) then
				return "fel_barrage rotation 16";
			end
		end
		if ((v83.GlaiveTempest:IsReady() and v46 and (v14:DebuffDown(v83.EssenceBreakDebuff) or (v92 > (1 + 0))) and v13:BuffDown(v83.FelBarrage)) or ((2995 + 217) <= (2489 - (320 + 1225)))) then
			if (v23(v83.GlaiveTempest, not v14:IsInRange(14 - 6)) or ((1895 + 1201) <= (3262 - (157 + 1307)))) then
				return "glaive_tempest rotation 18";
			end
		end
		if (((5396 - (821 + 1038)) == (8824 - 5287)) and v83.Annihilation:IsReady() and v35 and v13:BuffUp(v83.InnerDemonBuff) and (v83.EyeBeam:CooldownRemains() <= v13:GCD()) and v13:BuffDown(v83.FelBarrage)) then
			if (((420 + 3417) >= (2788 - 1218)) and v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation))) then
				return "annihilation rotation 20";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and v83.Momentum:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (2 + 1))) and (v13:BuffRemains(v83.MomentumBuff) < (12 - 7)) and v13:BuffDown(v83.MetamorphosisBuff)) or ((3976 - (834 + 192)) == (243 + 3569))) then
			if (((1213 + 3510) >= (50 + 2268)) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "fel_rush rotation 22";
			end
		end
		if ((v83.EyeBeam:IsCastable() and v42 and not v13:PrevGCDP(1 - 0, v83.VengefulRetreat) and ((v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.Metamorphosis:CooldownRemains() > ((334 - (300 + 4)) - (v26(v83.CycleOfHatred:IsAvailable()) * (5 + 10)))) or ((v83.Metamorphosis:CooldownRemains() < (v102 * (5 - 3))) and (not v83.EssenceBreak:IsAvailable() or (v83.EssenceBreak:CooldownRemains() < (v102 * (363.5 - (112 + 250))))))) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > v102) or not v83.RestlessHunter:IsAvailable()) and (v83.CycleOfHatred:IsAvailable() or not v83.Initiative:IsAvailable() or (v83.VengefulRetreat:CooldownRemains() > (2 + 3)) or not v50 or (v9.CombatTime() < (25 - 15))) and v13:BuffDown(v83.InnerDemonBuff)) or (v106 < (9 + 6)))) or ((1049 + 978) > (2133 + 719))) then
			if (v23(v83.EyeBeam, not v14:IsInRange(4 + 4)) or ((844 + 292) > (5731 - (1001 + 413)))) then
				return "eye_beam rotation 26";
			end
		end
		if (((10587 - 5839) == (5630 - (244 + 638))) and v83.BladeDance:IsCastable() and v36 and v95 and ((v83.EyeBeam:CooldownRemains() > (698 - (627 + 66))) or not v83.Demonic:IsAvailable() or v13:HasTier(92 - 61, 604 - (512 + 90)))) then
			if (((5642 - (1665 + 241)) <= (5457 - (373 + 344))) and v23(v83.BladeDance, not v14:IsInRange(4 + 4))) then
				return "blade_dance rotation 28";
			end
		end
		if ((v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff) and (v92 >= (2 + 2))) or ((8941 - 5551) <= (5178 - 2118))) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((2098 - (35 + 1064)) > (1960 + 733))) then
				if (((990 - 527) < (3 + 598)) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(1244 - (298 + 938)))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif ((v82 == "cursor") or ((3442 - (233 + 1026)) < (2353 - (636 + 1030)))) then
				if (((2326 + 2223) == (4444 + 105)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(12 + 28))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if (((316 + 4356) == (4893 - (55 + 166))) and v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v92 >= ((1 + 1) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and ((v83.ThrowGlaive:FullRechargeTime() < (v102 * (11 - 8))) or (v92 > (298 - (36 + 261)))) and not v13:HasTier(53 - 22, 1370 - (34 + 1334))) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1411 + 2257) < (307 + 88))) then
				return "throw_glaive rotation 32";
			end
		end
		if ((v83.ImmolationAura:IsCastable() and v47 and (v92 >= (1285 - (1035 + 248))) and (v13:Fury() < (91 - (20 + 1))) and v14:DebuffDown(v83.EssenceBreakDebuff)) or ((2171 + 1995) == (774 - (134 + 185)))) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(1141 - (549 + 584))) or ((5134 - (314 + 371)) == (9141 - 6478))) then
				return "immolation_aura rotation 34";
			end
		end
		if ((v83.Annihilation:IsCastable() and v35 and not v96 and ((v83.EssenceBreak:CooldownRemains() > (968 - (478 + 490))) or not v83.EssenceBreak:IsAvailable()) and v13:BuffDown(v83.FelBarrage)) or v13:HasTier(16 + 14, 1174 - (786 + 386)) or ((13853 - 9576) < (4368 - (1055 + 324)))) then
			if (v23(v83.Annihilation, not v14:IsSpellInRange(v83.Annihilation)) or ((2210 - (1093 + 247)) >= (3687 + 462))) then
				return "annihilation rotation 36";
			end
		end
		if (((233 + 1979) < (12637 - 9454)) and v83.Felblade:IsCastable() and v44 and not v13:PrevGCDP(3 - 2, v83.VengefulRetreat) and (((v13:FuryDeficit() >= (113 - 73)) and v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v83.AnyMeansNecessary:IsAvailable() and v14:DebuffDown(v83.EssenceBreakDebuff)))) then
			if (((11674 - 7028) > (1065 + 1927)) and v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade))) then
				return "felblade rotation 38";
			end
		end
		if (((5524 - 4090) < (10705 - 7599)) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and v83.AnyMeansNecessary:IsAvailable() and (v13:FuryDeficit() >= (23 + 7))) then
			if (((2010 - 1224) < (3711 - (364 + 324))) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (v23(v85.SigilOfFlamePlayer, not v14:IsInRange(21 - 13)) or ((5859 - 3417) < (25 + 49))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif (((18975 - 14440) == (7262 - 2727)) and (v82 == "cursor")) then
				if (v23(v85.SigilOfFlameCursor, not v14:IsInRange(121 - 81)) or ((4277 - (1249 + 19)) <= (1901 + 204))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if (((7123 - 5293) < (4755 - (686 + 400))) and v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v93 >= ((231 - (73 + 156)) - v26(v83.FuriousThrows:IsAvailable()))) and v14:DebuffDown(v83.EssenceBreakDebuff) and not v13:HasTier(1 + 30, 813 - (721 + 90))) then
			if (v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((17 + 1413) >= (11727 - 8115))) then
				return "throw_glaive rotation 40";
			end
		end
		if (((3153 - (224 + 246)) >= (3985 - 1525)) and v83.ImmolationAura:IsCastable() and v47 and (v13:BuffStack(v83.ImmolationAuraBuff) < v101) and v14:IsInRange(14 - 6) and (v13:BuffDown(v83.UnboundChaosBuff) or not v83.UnboundChaos:IsAvailable()) and ((v83.ImmolationAura:Recharge() < v83.EssenceBreak:CooldownRemains()) or (not v83.EssenceBreak:IsAvailable() and (v83.EyeBeam:CooldownRemains() > v83.ImmolationAura:Recharge())))) then
			if (v23(v83.ImmolationAura, not v14:IsInRange(2 + 6)) or ((43 + 1761) >= (2406 + 869))) then
				return "immolation_aura rotation 42";
			end
		end
		if ((v83.ThrowGlaive:IsReady() and v49 and not v13:PrevGCDP(1 - 0, v83.VengefulRetreat) and not v13:IsMoving() and v83.Soulscar:IsAvailable() and (v83.ThrowGlaive:FullRechargeTime() < v83.BladeDance:CooldownRemains()) and v13:HasTier(103 - 72, 515 - (203 + 310)) and v13:BuffDown(v83.FelBarrage) and not v97) or ((3410 - (1238 + 755)) > (254 + 3375))) then
			if (((6329 - (709 + 825)) > (740 - 338)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 44";
			end
		end
		if (((7010 - 2197) > (4429 - (196 + 668))) and v83.ChaosStrike:IsReady() and v37 and not v96 and not v97 and v13:BuffDown(v83.FelBarrage)) then
			if (((15445 - 11533) == (8103 - 4191)) and v23(v83.ChaosStrike, not v14:IsSpellInRange(v83.ChaosStrike))) then
				return "chaos_strike rotation 46";
			end
		end
		if (((3654 - (171 + 662)) <= (4917 - (4 + 89))) and v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and v48 and (v13:FuryDeficit() >= (105 - 75))) then
			if (((633 + 1105) <= (9640 - 7445)) and ((v82 == "player") or v83.ConcentratedSigils:IsAvailable())) then
				if (((17 + 24) <= (4504 - (35 + 1451))) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(1461 - (28 + 1425)))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((4138 - (941 + 1052)) <= (3936 + 168)) and (v82 == "cursor")) then
				if (((4203 - (822 + 692)) < (6916 - 2071)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(15 + 15))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if ((v83.Felblade:IsCastable() and v44 and (v13:FuryDeficit() >= (337 - (45 + 252))) and not v13:PrevGCDP(1 + 0, v83.VengefulRetreat)) or ((800 + 1522) > (6380 - 3758))) then
			if (v23(v83.Felblade, not v14:IsSpellInRange(v83.Felblade)) or ((4967 - (114 + 319)) == (2988 - 906))) then
				return "felblade rotation 50";
			end
		end
		if ((v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and v83.DemonBlades:IsAvailable() and v83.EyeBeam:CooldownDown() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.FelRush:Recharge() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable())) or ((2012 - 441) > (1191 + 676))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((3953 - 1299) >= (6277 - 3281))) then
				return "fel_rush rotation 52";
			end
		end
		if (((5941 - (556 + 1407)) > (3310 - (741 + 465))) and v83.DemonsBite:IsCastable() and v40 and v83.BurningWound:IsAvailable() and (v14:DebuffRemains(v83.BurningWoundDebuff) < (469 - (170 + 295)))) then
			if (((1579 + 1416) > (1416 + 125)) and v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite))) then
				return "demons_bite rotation 54";
			end
		end
		if (((7998 - 4749) > (791 + 162)) and v83.FelRush:IsCastable() and v34 and v45 and not v83.Momentum:IsAvailable() and not v83.DemonBlades:IsAvailable() and (v92 > (1 + 0)) and v13:BuffDown(v83.UnboundChaosBuff)) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1854 + 1419) > (5803 - (957 + 273)))) then
				return "fel_rush rotation 56";
			end
		end
		if ((v83.SigilOfFlame:IsCastable() and not v13:IsMoving() and (v13:FuryDeficit() >= (9 + 21)) and v14:IsInRange(13 + 17)) or ((12006 - 8855) < (3383 - 2099))) then
			if ((v82 == "player") or v83.ConcentratedSigils:IsAvailable() or ((5650 - 3800) == (7571 - 6042))) then
				if (((2601 - (389 + 1391)) < (1332 + 791)) and v23(v85.SigilOfFlamePlayer, not v14:IsInRange(1 + 7))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif (((2053 - 1151) < (3276 - (783 + 168))) and (v82 == "cursor")) then
				if (((2879 - 2021) <= (2914 + 48)) and v23(v85.SigilOfFlameCursor, not v14:IsInRange(341 - (309 + 2)))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if ((v83.DemonsBite:IsCastable() and v40) or ((12117 - 8171) < (2500 - (1090 + 122)))) then
			if (v23(v83.DemonsBite, not v14:IsSpellInRange(v83.DemonsBite)) or ((1052 + 2190) == (1904 - 1337))) then
				return "demons_bite rotation 57";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v83.Momentum:IsAvailable() and (v13:BuffRemains(v83.MomentumBuff) <= (14 + 6))) or ((1965 - (628 + 490)) >= (227 + 1036))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((5578 - 3325) == (8459 - 6608))) then
				return "fel_rush rotation 58";
			end
		end
		if ((v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(782 - (431 + 343)) and not v83.Momentum:IsAvailable()) or ((4214 - 2127) > (6861 - 4489))) then
			if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((3512 + 933) < (531 + 3618))) then
				return "fel_rush rotation 59";
			end
		end
		if ((v83.VengefulRetreat:IsCastable() and v34 and v50 and v83.Felblade:CooldownDown() and not v83.Initiative:IsAvailable() and not v14:IsInRange(1703 - (556 + 1139))) or ((1833 - (6 + 9)) == (16 + 69))) then
			if (((323 + 307) < (2296 - (28 + 141))) and v23(v83.VengefulRetreat, not v14:IsInRange(4 + 4), nil, true)) then
				return "vengeful_retreat rotation 60";
			end
		end
		if ((v83.ThrowGlaive:IsCastable() and v49 and not v13:PrevGCDP(1 - 0, v83.VengefulRetreat) and not v13:IsMoving() and (v83.DemonBlades:IsAvailable() or not v14:IsInRange(9 + 3)) and v14:DebuffDown(v83.EssenceBreakDebuff) and v14:IsSpellInRange(v83.ThrowGlaive) and not v13:HasTier(1348 - (486 + 831), 5 - 3)) or ((6822 - 4884) == (476 + 2038))) then
			if (((13454 - 9199) >= (1318 - (668 + 595))) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v116()
		local v128 = 0 + 0;
		while true do
			if (((605 + 2394) > (3152 - 1996)) and (v128 == (290 - (23 + 267)))) then
				v35 = EpicSettings.Settings['useAnnihilation'];
				v36 = EpicSettings.Settings['useBladeDance'];
				v37 = EpicSettings.Settings['useChaosStrike'];
				v128 = 1945 - (1129 + 815);
			end
			if (((2737 - (371 + 16)) > (2905 - (1326 + 424))) and ((5 - 2) == v128)) then
				v44 = EpicSettings.Settings['useFelblade'];
				v45 = EpicSettings.Settings['useFelRush'];
				v46 = EpicSettings.Settings['useGlaiveTempest'];
				v128 = 14 - 10;
			end
			if (((4147 - (88 + 30)) <= (5624 - (720 + 51))) and (v128 == (4 - 2))) then
				v41 = EpicSettings.Settings['useEssenceBreak'];
				v42 = EpicSettings.Settings['useEyeBeam'];
				v43 = EpicSettings.Settings['useFelBarrage'];
				v128 = 1779 - (421 + 1355);
			end
			if ((v128 == (1 - 0)) or ((254 + 262) > (4517 - (286 + 797)))) then
				v38 = EpicSettings.Settings['useConsumeMagic'];
				v39 = EpicSettings.Settings['useDeathSweep'];
				v40 = EpicSettings.Settings['useDemonsBite'];
				v128 = 7 - 5;
			end
			if (((6700 - 2654) >= (3472 - (397 + 42))) and (v128 == (2 + 4))) then
				v57 = EpicSettings.Settings['useTheHunt'];
				v58 = EpicSettings.Settings['elysianDecreeWithCD'];
				v59 = EpicSettings.Settings['metamorphosisWithCD'];
				v128 = 807 - (24 + 776);
			end
			if ((v128 == (5 - 1)) or ((3504 - (222 + 563)) <= (3187 - 1740))) then
				v47 = EpicSettings.Settings['useImmolationAura'];
				v48 = EpicSettings.Settings['useSigilOfFlame'];
				v49 = EpicSettings.Settings['useThrowGlaive'];
				v128 = 4 + 1;
			end
			if (((195 - (23 + 167)) == v128) or ((5932 - (690 + 1108)) < (1417 + 2509))) then
				v50 = EpicSettings.Settings['useVengefulRetreat'];
				v55 = EpicSettings.Settings['useElysianDecree'];
				v56 = EpicSettings.Settings['useMetamorphosis'];
				v128 = 5 + 1;
			end
			if ((v128 == (855 - (40 + 808))) or ((28 + 136) >= (10649 - 7864))) then
				v60 = EpicSettings.Settings['theHuntWithCD'];
				v61 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v62 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
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
		v65 = EpicSettings.Settings['blurHP'] or (0 + 0);
		v66 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v82 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v118()
		v74 = EpicSettings.Settings['fightRemainsCheck'] or (571 - (47 + 524));
		v67 = EpicSettings.Settings['dispelBuffs'];
		v71 = EpicSettings.Settings['InterruptWithStun'];
		v72 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v73 = EpicSettings.Settings['InterruptThreshold'];
		v75 = EpicSettings.Settings['useTrinkets'];
		v76 = EpicSettings.Settings['trinketsWithCD'];
		v78 = EpicSettings.Settings['useHealthstone'];
		v77 = EpicSettings.Settings['useHealingPotion'];
		v80 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v79 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
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
		if (v13:IsDeadOrGhost() or ((785 - 260) == (4809 - 2700))) then
			return;
		end
		v90 = v13:GetEnemiesInMeleeRange(1734 - (1165 + 561));
		v91 = v13:GetEnemiesInMeleeRange(1 + 19);
		if (((102 - 69) == (13 + 20)) and v32) then
			local v148 = 479 - (341 + 138);
			while true do
				if (((825 + 2229) <= (8285 - 4270)) and (v148 == (326 - (89 + 237)))) then
					v92 = ((#v90 > (0 - 0)) and #v90) or (1 - 0);
					v93 = #v91;
					break;
				end
			end
		else
			local v149 = 881 - (581 + 300);
			while true do
				if (((3091 - (855 + 365)) < (8032 - 4650)) and (v149 == (0 + 0))) then
					v92 = 1236 - (1030 + 205);
					v93 = 1 + 0;
					break;
				end
			end
		end
		v102 = v13:GCD() + 0.05 + 0;
		if (((1579 - (156 + 130)) <= (4921 - 2755)) and (v25.TargetIsValid() or v13:AffectingCombat())) then
			local v150 = 0 - 0;
			while true do
				if ((v150 == (0 - 0)) or ((680 + 1899) < (72 + 51))) then
					v105 = v9.BossFightRemains(nil, true);
					v106 = v105;
					v150 = 70 - (10 + 59);
				end
				if ((v150 == (1 + 0)) or ((4166 - 3320) >= (3531 - (671 + 492)))) then
					if ((v106 == (8845 + 2266)) or ((5227 - (369 + 846)) <= (889 + 2469))) then
						v106 = v9.FightRemains(Enemies8y, false);
					end
					break;
				end
			end
		end
		v30 = v111();
		if (((1275 + 219) <= (4950 - (1036 + 909))) and v30) then
			return v30;
		end
		if (v70 or ((2474 + 637) == (3582 - 1448))) then
			local v151 = 203 - (11 + 192);
			while true do
				if (((1191 + 1164) == (2530 - (135 + 40))) and (v151 == (0 - 0))) then
					v30 = v25.HandleIncorporeal(v83.Imprison, v85.ImprisonMouseover, 19 + 11, true);
					if (v30 or ((1295 - 707) <= (646 - 214))) then
						return v30;
					end
					break;
				end
			end
		end
		if (((4973 - (50 + 126)) >= (10845 - 6950)) and v25.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
			if (((792 + 2785) == (4990 - (1233 + 180))) and not v13:AffectingCombat()) then
				v30 = v112();
				if (((4763 - (522 + 447)) > (5114 - (107 + 1314))) and v30) then
					return v30;
				end
			end
			if ((v83.ConsumeMagic:IsAvailable() and v38 and v83.ConsumeMagic:IsReady() and v67 and not v13:IsCasting() and not v13:IsChanneling() and v25.UnitHasMagicBuff(v14)) or ((592 + 683) == (12493 - 8393))) then
				if (v23(v83.ConsumeMagic, not v14:IsSpellInRange(v83.ConsumeMagic)) or ((676 + 915) >= (7109 - 3529))) then
					return "greater_purge damage";
				end
			end
			if (((3889 - 2906) <= (3718 - (716 + 1194))) and v83.FelRush:IsReady() and v34 and v45 and not v14:IsInRange(1 + 7)) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((231 + 1919) <= (1700 - (74 + 429)))) then
					return "fel_rush rotation when OOR";
				end
			end
			if (((7270 - 3501) >= (582 + 591)) and v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v14:NPCID())) then
				if (((3399 - 1914) == (1051 + 434)) and v23(v83.ThrowGlaive, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fodder to the flames react per target";
				end
			end
			if ((v83.ThrowGlaive:IsReady() and v49 and v12.ValueIsInArray(v107, v15:NPCID())) or ((10219 - 6904) <= (6878 - 4096))) then
				if (v23(v85.ThrowGlaiveMouseover, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((1309 - (279 + 154)) >= (3742 - (454 + 324)))) then
					return "fodder to the flames react per mouseover";
				end
			end
			v95 = v83.FirstBlood:IsAvailable() or v83.TrailofRuin:IsAvailable() or (v83.ChaosTheory:IsAvailable() and v13:BuffDown(v83.ChaosTheoryBuff)) or (v92 > (1 + 0));
			v96 = v95 and (v13:Fury() < ((92 - (12 + 5)) - (v26(v83.DemonBlades:IsAvailable()) * (11 + 9)))) and (v83.BladeDance:CooldownRemains() < v102);
			v97 = v83.Demonic:IsAvailable() and not v83.BlindFury:IsAvailable() and (v83.EyeBeam:CooldownRemains() < (v102 * (4 - 2))) and (v13:FuryDeficit() > (12 + 18));
			v99 = (v83.Momentum:IsAvailable() and v13:BuffDown(v83.MomentumBuff)) or (v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff));
			local v152 = v29(v83.EyeBeam:BaseDuration(), v13:GCD());
			v100 = v83.Demonic:IsAvailable() and v83.EssenceBreak:IsAvailable() and Var3MinTrinket and (v106 > (v83.Metamorphosis:CooldownRemains() + (1123 - (277 + 816)) + (v26(v83.ShatteredDestiny:IsAvailable()) * (256 - 196)))) and (v83.Metamorphosis:CooldownRemains() < (1203 - (1058 + 125))) and (v83.Metamorphosis:CooldownRemains() > (v152 + (v102 * (v26(v83.InnerDemon:IsAvailable()) + 1 + 1))));
			if ((v83.ImmolationAura:IsCastable() and v47 and v83.Ragefire:IsAvailable() and (v92 >= (978 - (815 + 160))) and (v83.BladeDance:CooldownDown() or v14:DebuffDown(v83.EssenceBreakDebuff))) or ((9576 - 7344) > (5927 - 3430))) then
				if (v23(v83.ImmolationAura, not v14:IsInRange(2 + 6)) or ((6167 - 4057) <= (2230 - (41 + 1857)))) then
					return "immolation_aura main 2";
				end
			end
			if (((5579 - (1222 + 671)) > (8198 - 5026)) and v83.ImmolationAura:IsCastable() and v47 and v83.AFireInside:IsAvailable() and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and (v83.ImmolationAura:FullRechargeTime() < (v102 * (2 - 0))) and v14:DebuffDown(v83.EssenceBreakDebuff)) then
				if (v23(v83.ImmolationAura, not v14:IsInRange(1190 - (229 + 953))) or ((6248 - (1111 + 663)) < (2399 - (874 + 705)))) then
					return "immolation_aura main 3";
				end
			end
			if (((599 + 3680) >= (1967 + 915)) and v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and (((v83.ImmolationAura:Charges() == (3 - 1)) and v14:DebuffDown(v83.EssenceBreakDebuff)) or (v13:PrevGCDP(1 + 0, v83.EyeBeam) and v13:BuffUp(v83.InertiaBuff) and (v13:BuffRemains(v83.InertiaBuff) < (682 - (642 + 37)))))) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((463 + 1566) >= (564 + 2957))) then
					return "fel_rush main 4";
				end
			end
			if ((v83.TheHunt:IsCastable() and (v9.CombatTime() < (25 - 15)) and (not v83.Inertia:IsAvailable() or (v13:BuffUp(v83.MetamorphosisBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)))) or ((2491 - (233 + 221)) >= (10733 - 6091))) then
				if (((1514 + 206) < (5999 - (718 + 823))) and v23(v83.TheHunt, not v14:IsSpellInRange(v83.TheHunt))) then
					return "the_hunt main 6";
				end
			end
			if ((v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and ((v83.EyeBeam:CooldownRemains() < (v102 * (2 + 0))) or v13:BuffUp(v83.MetamorphosisBuff)) and (v83.EssenceBreak:CooldownRemains() < (v102 * (808 - (266 + 539)))) and v13:BuffDown(v83.UnboundChaosBuff) and v13:BuffDown(v83.InertiaBuff) and v14:DebuffDown(v83.EssenceBreakDebuff)) or ((1234 - 798) > (4246 - (636 + 589)))) then
				if (((1692 - 979) <= (1746 - 899)) and v23(v83.ImmolationAura, not v14:IsInRange(7 + 1))) then
					return "immolation_aura main 5";
				end
			end
			if (((783 + 1371) <= (5046 - (657 + 358))) and v83.ImmolationAura:IsCastable() and v47 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.UnboundChaosBuff) and ((v83.ImmolationAura:FullRechargeTime() < v83.EssenceBreak:CooldownRemains()) or not v83.EssenceBreak:IsAvailable()) and v14:DebuffDown(v83.EssenceBreakDebuff) and (v13:BuffDown(v83.MetamorphosisBuff) or (v13:BuffRemains(v83.MetamorphosisBuff) > (15 - 9))) and v83.BladeDance:CooldownDown() and ((v13:Fury() < (170 - 95)) or (v83.BladeDance:CooldownRemains() < (v102 * (1189 - (1151 + 36)))))) then
				if (((4457 + 158) == (1214 + 3401)) and v23(v83.ImmolationAura, not v14:IsInRange(23 - 15))) then
					return "immolation_aura main 6";
				end
			end
			if ((v83.FelRush:IsCastable() and v34 and v45 and ((v13:BuffRemains(v83.UnboundChaosBuff) < (v102 * (1834 - (1552 + 280)))) or (v14:TimeToDie() < (v102 * (836 - (64 + 770)))))) or ((2574 + 1216) == (1135 - 635))) then
				if (((16 + 73) < (1464 - (157 + 1086))) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fel_rush main 8";
				end
			end
			if (((4110 - 2056) >= (6223 - 4802)) and v83.FelRush:IsCastable() and v34 and v45 and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and v13:BuffUp(v83.UnboundChaosBuff) and ((v83.EyeBeam:CooldownRemains() + (3 - 0)) > v13:BuffRemains(v83.UnboundChaosBuff)) and (v83.BladeDance:CooldownDown() or v83.EssenceBreak:CooldownUp())) then
				if (((943 - 251) < (3877 - (599 + 220))) and v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive))) then
					return "fel_rush main 9";
				end
			end
			if ((v83.FelRush:IsCastable() and v34 and v45 and v13:BuffUp(v83.UnboundChaosBuff) and v83.Inertia:IsAvailable() and v13:BuffDown(v83.InertiaBuff) and (v13:BuffUp(v83.MetamorphosisBuff) or (v83.EssenceBreak:CooldownRemains() > (19 - 9)))) or ((5185 - (1813 + 118)) == (1210 + 445))) then
				if (v23(v83.FelRush, not v14:IsSpellInRange(v83.ThrowGlaive)) or ((2513 - (841 + 376)) == (6880 - 1970))) then
					return "fel_rush main 10";
				end
			end
			if (((783 + 2585) == (9192 - 5824)) and (v74 < v106) and v33) then
				local v175 = 859 - (464 + 395);
				while true do
					if (((6782 - 4139) < (1833 + 1982)) and ((837 - (467 + 370)) == v175)) then
						v30 = v114();
						if (((3952 - 2039) > (362 + 131)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
			if (((16300 - 11545) > (535 + 2893)) and v13:BuffUp(v83.MetamorphosisBuff) and (v13:BuffRemains(v83.MetamorphosisBuff) < v102) and (v92 < (6 - 3))) then
				v30 = v113();
				if (((1901 - (150 + 370)) <= (3651 - (74 + 1208))) and v30) then
					return v30;
				end
			end
			v30 = v115();
			if (v30 or ((11911 - 7068) == (19368 - 15284))) then
				return v30;
			end
			if (((3323 + 1346) > (753 - (14 + 376))) and (v83.DemonBlades:IsAvailable())) then
				if (v23(v83.Pool) or ((3255 - 1378) >= (2031 + 1107))) then
					return "pool demon_blades";
				end
			end
		end
	end
	local function v120()
		v83.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(507 + 70, v119, v120);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

