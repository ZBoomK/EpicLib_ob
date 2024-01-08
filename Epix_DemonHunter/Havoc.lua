local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (550 - (400 + 150))) or ((4998 - 3368) > (2366 + 1832))) then
			v6 = v0[v4];
			if (((2688 - (1607 + 27)) == (304 + 750)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1727 - (1668 + 58);
		end
		if ((v5 == (627 - (512 + 114))) or ((1762 - 1086) >= (3394 - 1752))) then
			return v6(...);
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
	local v21 = v20.Press;
	local v22 = v20.Macro;
	local v23 = v20.Commons.Everyone;
	local v24 = v23.num;
	local v25 = v23.bool;
	local v26 = math.min;
	local v27 = math.max;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v79 = v18.DemonHunter.Havoc;
	local v80 = v19.DemonHunter.Havoc;
	local v81 = v22.DemonHunter.Havoc;
	local v82 = {};
	local v83 = v14:GetEquipment();
	local v84 = (v83[45 - 32] and v19(v83[7 + 6])) or v19(0 + 0);
	local v85 = (v83[13 + 1] and v19(v83[47 - 33])) or v19(1994 - (109 + 1885));
	local v86, v87;
	local v88, v89;
	local v90 = {{v79.FelEruption},{v79.ChaosNova}};
	local v91 = false;
	local v92 = false;
	local v93 = false;
	local v94 = false;
	local v95 = false;
	local v96 = false;
	local v97 = ((v79.AFireInside:IsAvailable()) and (8 - 3)) or (1 - 0);
	local v98 = v14:GCD() + 0.25 + 0;
	local v99 = 0 + 0;
	local v100 = false;
	local v101 = 1826 + 9285;
	local v102 = 2397 + 8714;
	local v103 = {(564978 - 395557),(68967 + 100458),(122836 + 46096),(170859 - (797 + 636)),(171048 - (1427 + 192)),(393373 - 223945),(76783 + 92647)};
	v10:RegisterForEvent(function()
		v91 = false;
		v92 = false;
		v93 = false;
		v94 = false;
		v95 = false;
		v101 = 11437 - (192 + 134);
		v102 = 12387 - (316 + 960);
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v117 = 0 + 0;
		while true do
			if (((3192 + 944) > (2216 + 181)) and (v117 == (0 - 0))) then
				v83 = v14:GetEquipment();
				v84 = (v83[564 - (83 + 468)] and v19(v83[1819 - (1202 + 604)])) or v19(0 - 0);
				v117 = 1 - 0;
			end
			if ((v117 == (2 - 1)) or ((4659 - (45 + 280)) == (4098 + 147))) then
				v85 = (v83[13 + 1] and v19(v83[6 + 8])) or v19(0 + 0);
				break;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v97 = ((v79.AFireInside:IsAvailable()) and (1 + 4)) or (1 - 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v104(v118)
		return v118:DebuffRemains(v79.BurningWoundDebuff) or v118:DebuffRemains(v79.BurningWoundLegDebuff);
	end
	local function v105(v119)
		return v79.BurningWound:IsAvailable() and (v119:DebuffRemains(v79.BurningWoundDebuff) < (1915 - (340 + 1571))) and (v79.BurningWoundDebuff:AuraActiveCount() < v26(v88, 2 + 1));
	end
	local function v106()
		local v120 = 1772 - (1733 + 39);
		while true do
			if ((v120 == (2 - 1)) or ((5310 - (125 + 909)) <= (4979 - (1096 + 852)))) then
				v28 = v23.HandleBottomTrinket(v82, v31, 18 + 22, nil);
				if (v28 or ((6828 - 2046) <= (1163 + 36))) then
					return v28;
				end
				break;
			end
			if ((v120 == (512 - (409 + 103))) or ((5100 - (46 + 190)) < (1997 - (51 + 44)))) then
				v28 = v23.HandleTopTrinket(v82, v31, 12 + 28, nil);
				if (((6156 - (1114 + 203)) >= (4426 - (228 + 498))) and v28) then
					return v28;
				end
				v120 = 1 + 0;
			end
		end
	end
	local function v107()
		if ((v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) or ((594 + 481) > (2581 - (174 + 489)))) then
			if (((1031 - 635) <= (5709 - (830 + 1075))) and v21(v79.Blur)) then
				return "blur defensive";
			end
		end
		if ((v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((4693 - (303 + 221)) == (3456 - (231 + 1038)))) then
			if (((1172 + 234) == (2568 - (171 + 991))) and v21(v79.Netherwalk)) then
				return "netherwalk defensive";
			end
		end
		if (((6309 - 4778) < (11468 - 7197)) and v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) then
			if (((1584 - 949) == (509 + 126)) and v21(v81.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((11823 - 8450) <= (10258 - 6702)) and v73 and (v14:HealthPercentage() <= v75)) then
			local v138 = 0 - 0;
			while true do
				if ((v138 == (0 - 0)) or ((4539 - (111 + 1137)) < (3438 - (91 + 67)))) then
					if (((13053 - 8667) >= (218 + 655)) and (v77 == "Refreshing Healing Potion")) then
						if (((1444 - (423 + 100)) <= (8 + 1094)) and v80.RefreshingHealingPotion:IsReady()) then
							if (((13029 - 8323) >= (502 + 461)) and v21(v81.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v77 == "Dreamwalker's Healing Potion") or ((1731 - (326 + 445)) <= (3822 - 2946))) then
						if (v80.DreamwalkersHealingPotion:IsReady() or ((4602 - 2536) == (2175 - 1243))) then
							if (((5536 - (530 + 181)) < (5724 - (614 + 267))) and v21(v81.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v108()
		local v121 = 32 - (19 + 13);
		while true do
			if ((v121 == (1 - 0)) or ((9034 - 5157) >= (12960 - 8423))) then
				if ((not v15:IsInMeleeRange(2 + 3) and v79.Felblade:IsCastable() and v42) or ((7588 - 3273) < (3579 - 1853))) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((5491 - (1293 + 519)) < (1275 - 650))) then
						return "felblade precombat 9";
					end
				end
				if ((not v15:IsInMeleeRange(13 - 8) and v79.ThrowGlaive:IsCastable() and v47) or ((8844 - 4219) < (2725 - 2093))) then
					if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((195 - 112) > (943 + 837))) then
						return "throw_glaive precombat 9";
					end
				end
				v121 = 1 + 1;
			end
			if (((1268 - 722) <= (249 + 828)) and (v121 == (1 + 1))) then
				if ((not v15:IsInMeleeRange(4 + 1) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(1097 - (709 + 387), v79.Felblade))) and v32 and v43) or ((2854 - (673 + 1185)) > (12473 - 8172))) then
					if (((13069 - 8999) > (1129 - 442)) and v21(v79.FelRush, not v15:IsInRange(11 + 4))) then
						return "fel_rush precombat 10";
					end
				end
				if ((v15:IsInMeleeRange(4 + 1) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) or ((884 - 228) >= (818 + 2512))) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(9 - 4)) or ((4891 - 2399) <= (2215 - (446 + 1434)))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if (((5605 - (1040 + 243)) >= (7646 - 5084)) and (v121 == (1847 - (559 + 1288)))) then
				if ((v79.ImmolationAura:IsCastable() and v45) or ((5568 - (609 + 1322)) >= (4224 - (13 + 441)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(29 - 21)) or ((6231 - 3852) > (22800 - 18222))) then
						return "immolation_aura precombat 8";
					end
				end
				if ((v46 and not v14:IsMoving() and (v88 > (1 + 0)) and v79.SigilOfFlame:IsCastable()) or ((1754 - 1271) > (264 + 479))) then
					if (((1076 + 1378) > (1715 - 1137)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (((509 + 421) < (8198 - 3740)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(6 + 2))) then
							return "sigil_of_flame precombat 9";
						end
					elseif (((369 + 293) <= (699 + 273)) and (v78 == "cursor")) then
						if (((3670 + 700) == (4276 + 94)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(473 - (153 + 280)))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v121 = 2 - 1;
			end
		end
	end
	local function v109()
		if (v14:BuffDown(v79.FelBarrage) or ((4276 + 486) <= (340 + 521))) then
			local v139 = 0 + 0;
			while true do
				if ((v139 == (0 + 0)) or ((1024 + 388) == (6492 - 2228))) then
					if ((v79.DeathSweep:IsReady() and v37) or ((1959 + 1209) < (2820 - (89 + 578)))) then
						if (v21(v79.DeathSweep, not v15:IsInRange(6 + 2)) or ((10344 - 5368) < (2381 - (572 + 477)))) then
							return "death_sweep meta_end 2";
						end
					end
					if (((625 + 4003) == (2778 + 1850)) and v79.Annihilation:IsReady() and v33) then
						if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((7 + 47) == (481 - (84 + 2)))) then
							return "annihilation meta_end 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v110()
		local v122 = 0 - 0;
		local v123;
		while true do
			if (((60 + 22) == (924 - (497 + 345))) and (v122 == (1 + 1))) then
				if ((v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v88 > v60)) or ((99 + 482) < (1615 - (605 + 728)))) then
					if ((v59 == "player") or ((3289 + 1320) < (5547 - 3052))) then
						if (((53 + 1099) == (4259 - 3107)) and v21(v81.ElysianDecreePlayer, not v15:IsInRange(8 + 0))) then
							return "elysian_decree cooldown 8 (Player)";
						end
					elseif (((5252 - 3356) <= (2584 + 838)) and (v59 == "cursor")) then
						if (v21(v81.ElysianDecreeCursor, not v15:IsInRange(519 - (457 + 32))) or ((421 + 569) > (3022 - (832 + 570)))) then
							return "elysian_decree cooldown 8 (Cursor)";
						end
					end
				end
				if ((v70 < v102) or ((827 + 50) > (1225 + 3470))) then
					if (((9522 - 6831) >= (892 + 959)) and v71 and ((v31 and v72) or not v72)) then
						local v178 = 796 - (588 + 208);
						while true do
							if ((v178 == (0 - 0)) or ((4785 - (884 + 916)) >= (10166 - 5310))) then
								v28 = v106();
								if (((2480 + 1796) >= (1848 - (232 + 421))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((5121 - (1569 + 320)) <= (1151 + 3539)) and (v122 == (0 + 0))) then
				if ((((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and not v79.Demonic:IsAvailable()) or ((3019 - 2123) >= (3751 - (316 + 289)))) then
					if (((8012 - 4951) >= (137 + 2821)) and v21(v81.MetamorphosisPlayer, not v15:IsInRange(1461 - (666 + 787)))) then
						return "metamorphosis cooldown 4";
					end
				end
				if (((3612 - (360 + 65)) >= (602 + 42)) and ((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and v79.Demonic:IsAvailable() and ((not v79.ChaoticTransformation:IsAvailable() and v79.EyeBeam:CooldownDown()) or ((v79.EyeBeam:CooldownRemains() > (274 - (79 + 175))) and (not v91 or v14:PrevGCDP(1 - 0, v79.DeathSweep) or v14:PrevGCDP(2 + 0, v79.DeathSweep))) or ((v102 < ((76 - 51) + (v24(v79.ShatteredDestiny:IsAvailable()) * (134 - 64)))) and v79.EyeBeam:CooldownDown() and v79.BladeDance:CooldownDown())) and v14:BuffDown(v79.InnerDemonBuff)) then
					if (((1543 - (503 + 396)) <= (885 - (92 + 89))) and v21(v81.MetamorphosisPlayer, not v15:IsInRange(15 - 7))) then
						return "metamorphosis cooldown 6";
					end
				end
				v122 = 1 + 0;
			end
			if (((567 + 391) > (3708 - 2761)) and (v122 == (1 + 0))) then
				v123 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				if (((10242 - 5750) >= (2316 + 338)) and v123) then
					return v123;
				end
				v122 = 1 + 1;
			end
		end
	end
	local function v111()
		if (((10482 - 7040) >= (188 + 1315)) and v79.EssenceBreak:IsCastable() and v39 and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > (15 - 5)))) then
			if (v21(v79.EssenceBreak, not v15:IsInRange(1252 - (485 + 759))) or ((7335 - 4165) <= (2653 - (442 + 747)))) then
				return "essence_break rotation prio";
			end
		end
		if ((v79.BladeDance:IsCastable() and v34 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((5932 - (832 + 303)) == (5334 - (88 + 858)))) then
			if (((168 + 383) <= (564 + 117)) and v21(v79.BladeDance, not v15:IsInRange(1 + 7))) then
				return "blade_dance rotation prio";
			end
		end
		if (((4066 - (766 + 23)) > (2009 - 1602)) and v79.DeathSweep:IsCastable() and v37 and v15:DebuffUp(v79.EssenceBreakDebuff)) then
			if (((6420 - 1725) >= (3728 - 2313)) and v21(v79.DeathSweep, not v15:IsInRange(27 - 19))) then
				return "death_sweep rotation prio";
			end
		end
		if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.Metamorphosis:CooldownRemains() <= (v14:GCD() * (1076 - (1036 + 37))))) or ((2278 + 934) <= (1837 - 893))) then
			if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((2436 + 660) <= (3278 - (641 + 839)))) then
				return "annihilation rotation 2";
			end
		end
		if (((4450 - (910 + 3)) == (9016 - 5479)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v14:GCDRemains() == (1684 - (1466 + 218))) and (v79.EyeBeam:CooldownRemains() < (0.3 + 0)) and (v79.EssenceBreak:CooldownRemains() < (v98 * (1150 - (556 + 592)))) and (v10.CombatTime() > (2 + 3)) and (v14:Fury() >= (838 - (329 + 479))) and v79.Inertia:IsAvailable()) then
			if (((4691 - (174 + 680)) >= (5394 - 3824)) and v21(v79.VengefulRetreat, not v15:IsInRange(16 - 8))) then
				return "vengeful_retreat rotation 3";
			end
		end
		if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v14:GCDRemains() == (0 + 0)) and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (740 - (396 + 343))) and ((v79.EssenceBreak:CooldownRemains() > (2 + 13)) or ((v79.EssenceBreak:CooldownRemains() < v98) and (not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > ((1492 - (29 + 1448)) + ((1399 - (135 + 1254)) * v24(v79.CycleOfHatred:IsAvailable()))))))) and ((v10.CombatTime() < (113 - 83)) or ((v14:GCDRemains() - (4 - 3)) < (0 + 0))) and (not v79.Initiative:IsAvailable() or (v14:BuffRemains(v79.InitiativeBuff) < v98) or (v10.CombatTime() > (1531 - (389 + 1138))))) or ((3524 - (102 + 472)) == (3598 + 214))) then
			if (((2620 + 2103) >= (2162 + 156)) and v21(v79.VengefulRetreat, not v15:IsInRange(1553 - (320 + 1225)))) then
				return "vengeful_retreat rotation 4";
			end
		end
		if ((v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v14:GCDRemains() == (0 - 0)) and v79.Initiative:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and ((v79.EssenceBreak:CooldownRemains() > (1479 - (157 + 1307))) or ((v79.EssenceBreak:CooldownRemains() < (v98 * (1861 - (821 + 1038)))) and (((v14:BuffRemains(v79.InitiativeBuff) < v98) and not v96 and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > (74 - 44))) or not v79.Demonic:IsAvailable() or v14:BuffUp(v79.MetamorphosisBuff) or (v79.EyeBeam:CooldownRemains() > (2 + 13 + ((17 - 7) * v24(v79.CycleOfHatred:IsAvailable()))))))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff))) or ((755 + 1272) > (7068 - 4216))) then
			if (v21(v79.VengefulRetreat, not v15:IsInRange(1034 - (834 + 192))) or ((73 + 1063) > (1109 + 3208))) then
				return "vengeful_retreat rotation 6";
			end
		end
		if (((102 + 4646) == (7355 - 2607)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v14:GCDRemains() == (304 - (300 + 4))) and v79.Initiative:IsAvailable() and not v79.EssenceBreak:IsAvailable() and (v10.CombatTime() > (1 + 0)) and (v14:BuffDown(v79.InitiativeBuff) or (v14:PrevGCDP(2 - 1, v79.DeathSweep) and v79.Metamorphosis:CooldownUp() and v79.ChaoticTransformation:IsAvailable())) and v79.Initiative:IsAvailable()) then
			if (((4098 - (112 + 250)) <= (1890 + 2850)) and v21(v79.VengefulRetreat, not v15:IsInRange(19 - 11))) then
				return "vengeful_retreat rotation 8";
			end
		end
		if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v98 * (2 + 0))) and (v79.EyeBeam:CooldownRemains() <= v98) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) or ((1754 + 1636) <= (2289 + 771))) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((496 + 503) > (2001 + 692))) then
				return "fel_rush rotation 10";
			end
		end
		if (((1877 - (1001 + 413)) < (1340 - 739)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or ((v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge()) and (v79.EyeBeam:CooldownRemains() > (886 - (244 + 638))))) and v15:DebuffDown(v79.EssenceBreakDebuff) and v79.BladeDance:CooldownDown()) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((2876 - (627 + 66)) < (2046 - 1359))) then
				return "fel_rush rotation 11";
			end
		end
		if (((5151 - (512 + 90)) == (6455 - (1665 + 241))) and v79.EssenceBreak:IsCastable() and v39 and ((((v14:BuffRemains(v79.MetamorphosisBuff) > (v98 * (720 - (373 + 344)))) or (v79.EyeBeam:CooldownRemains() > (5 + 5))) and (not v79.TacticalRetreat:IsAvailable() or v14:BuffUp(v79.TacticalRetreatBuff) or (v10.CombatTime() < (3 + 7))) and (v79.BladeDance:CooldownRemains() <= ((7.1 - 4) * v98))) or (v102 < (9 - 3)))) then
			if (((5771 - (35 + 1064)) == (3400 + 1272)) and v21(v79.EssenceBreak, not v15:IsInRange(16 - 8))) then
				return "essence_break rotation 13";
			end
		end
		if ((v79.DeathSweep:IsCastable() and v37 and v91 and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() > (v98 * (1 + 1)))) and v14:BuffDown(v79.FelBarrage)) or ((4904 - (298 + 938)) < (1654 - (233 + 1026)))) then
			if (v21(v79.DeathSweep, not v15:IsInRange(1674 - (636 + 1030))) or ((2130 + 2036) == (445 + 10))) then
				return "death_sweep rotation 14";
			end
		end
		if ((v79.TheHunt:IsCastable() and v32 and v55 and (v70 < v102) and ((v31 and v58) or not v58) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v10.CombatTime() < (3 + 7)) or (v79.Metamorphosis:CooldownRemains() > (1 + 9))) and ((v88 == (222 - (55 + 166))) or (v88 > (1 + 2)) or (v102 < (2 + 8))) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FuriousGaze:IsAvailable() or v14:BuffUp(v79.FuriousGazeBuff) or v14:HasTier(118 - 87, 301 - (36 + 261)))) or not v14:HasTier(52 - 22, 1370 - (34 + 1334))) and (v10.CombatTime() > (4 + 6))) or ((3457 + 992) == (3946 - (1035 + 248)))) then
			if (v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt)) or ((4298 - (20 + 1)) < (1558 + 1431))) then
				return "the_hunt main 12";
			end
		end
		if ((v79.FelBarrage:IsCastable() and v41 and ((v88 > (320 - (134 + 185))) or ((v88 == (1134 - (549 + 584))) and (v14:FuryDeficit() < (705 - (314 + 371))) and v14:BuffDown(v79.MetamorphosisBuff)))) or ((2986 - 2116) >= (5117 - (478 + 490)))) then
			if (((1172 + 1040) < (4355 - (786 + 386))) and v21(v79.FelBarrage, not v15:IsInRange(25 - 17))) then
				return "fel_barrage rotation 16";
			end
		end
		if (((6025 - (1055 + 324)) > (4332 - (1093 + 247))) and v79.GlaiveTempest:IsReady() and v44 and (v15:DebuffDown(v79.EssenceBreakDebuff) or (v88 > (1 + 0))) and v14:BuffDown(v79.FelBarrage)) then
			if (((151 + 1283) < (12331 - 9225)) and v21(v79.GlaiveTempest, not v15:IsInRange(26 - 18))) then
				return "glaive_tempest rotation 18";
			end
		end
		if (((2236 - 1450) < (7596 - 4573)) and v79.Annihilation:IsReady() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (v79.EyeBeam:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v79.FelBarrage)) then
			if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((869 + 1573) < (285 - 211))) then
				return "annihilation rotation 20";
			end
		end
		if (((15631 - 11096) == (3420 + 1115)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (7 - 4))) and (v14:BuffRemains(v79.MomentumBuff) < (693 - (364 + 324))) and v14:BuffDown(v79.MetamorphosisBuff)) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((8248 - 5239) <= (5051 - 2946))) then
				return "fel_rush rotation 22";
			end
		end
		if (((607 + 1223) < (15352 - 11683)) and v79.EyeBeam:IsCastable() and v40 and not v14:PrevGCDP(1 - 0, v79.VengefulRetreat) and ((v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.Metamorphosis:CooldownRemains() > ((91 - 61) - (v24(v79.CycleOfHatred:IsAvailable()) * (1283 - (1249 + 19))))) or ((v79.Metamorphosis:CooldownRemains() < (v98 * (2 + 0))) and (not v79.EssenceBreak:IsAvailable() or (v79.EssenceBreak:CooldownRemains() < (v98 * (3.5 - 2)))))) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > v98) or not v79.RestlessHunter:IsAvailable()) and (v79.CycleOfHatred:IsAvailable() or not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (1091 - (686 + 400))) or not v48 or (v10.CombatTime() < (8 + 2))) and v14:BuffDown(v79.InnerDemonBuff)) or (v102 < (244 - (73 + 156))))) then
			if (v21(v79.EyeBeam, not v15:IsInRange(1 + 7)) or ((2241 - (721 + 90)) >= (41 + 3571))) then
				return "eye_beam rotation 26";
			end
		end
		if (((8711 - 6028) >= (2930 - (224 + 246))) and v79.BladeDance:IsCastable() and v34 and v91 and ((v79.EyeBeam:CooldownRemains() > (8 - 3)) or not v79.Demonic:IsAvailable() or v14:HasTier(56 - 25, 1 + 1))) then
			if (v21(v79.BladeDance, not v15:IsInRange(1 + 7)) or ((1325 + 479) >= (6511 - 3236))) then
				return "blade_dance rotation 28";
			end
		end
		if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff) and (v88 >= (12 - 8))) or ((1930 - (203 + 310)) > (5622 - (1238 + 755)))) then
			if (((335 + 4460) > (1936 - (709 + 825))) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
				if (((8868 - 4055) > (5192 - 1627)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(872 - (196 + 668)))) then
					return "sigil_of_flame rotation player 30";
				end
			elseif (((15445 - 11533) == (8103 - 4191)) and (v78 == "cursor")) then
				if (((3654 - (171 + 662)) <= (4917 - (4 + 89))) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(140 - 100))) then
					return "sigil_of_flame rotation cursor 30";
				end
			end
		end
		if (((633 + 1105) <= (9640 - 7445)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v88 >= ((1488 - (35 + 1451)) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.ThrowGlaive:FullRechargeTime() < (v98 * (1456 - (28 + 1425)))) or (v88 > (1994 - (941 + 1052)))) and not v14:HasTier(30 + 1, 1516 - (822 + 692))) then
			if (((58 - 17) <= (1422 + 1596)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
				return "throw_glaive rotation 32";
			end
		end
		if (((2442 - (45 + 252)) <= (4061 + 43)) and v79.ImmolationAura:IsCastable() and v45 and (v88 >= (1 + 1)) and (v14:Fury() < (170 - 100)) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
			if (((3122 - (114 + 319)) < (6955 - 2110)) and v21(v79.ImmolationAura, not v15:IsInRange(9 - 1))) then
				return "immolation_aura rotation 34";
			end
		end
		if ((v79.Annihilation:IsCastable() and v33 and not v92 and ((v79.EssenceBreak:CooldownRemains() > (0 + 0)) or not v79.EssenceBreak:IsAvailable()) and v14:BuffDown(v79.FelBarrage)) or v14:HasTier(44 - 14, 3 - 1) or ((4285 - (556 + 1407)) > (3828 - (741 + 465)))) then
			if (v21(v79.Annihilation, not v15:IsSpellInRange(v79.Annihilation)) or ((4999 - (170 + 295)) == (1097 + 985))) then
				return "annihilation rotation 36";
			end
		end
		if ((v79.Felblade:IsCastable() and v42 and (((v14:FuryDeficit() >= (37 + 3)) and v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v79.AnyMeansNecessary:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)))) or ((3867 - 2296) > (1548 + 319))) then
			if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1703 + 951) >= (1697 + 1299))) then
				return "felblade rotation 38";
			end
		end
		if (((5208 - (957 + 273)) > (563 + 1541)) and v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and v79.AnyMeansNecessary:IsAvailable() and (v14:FuryDeficit() >= (13 + 17))) then
			if (((11412 - 8417) > (4060 - 2519)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
				if (((9923 - 6674) > (4718 - 3765)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1788 - (389 + 1391)))) then
					return "sigil_of_flame rotation player 39";
				end
			elseif ((v78 == "cursor") or ((2054 + 1219) > (476 + 4097))) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(91 - 51)) or ((4102 - (783 + 168)) < (4309 - 3025))) then
					return "sigil_of_flame rotation cursor 39";
				end
			end
		end
		if ((v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v89 >= ((313 - (309 + 2)) - v24(v79.FuriousThrows:IsAvailable()))) and v15:DebuffDown(v79.EssenceBreakDebuff) and not v14:HasTier(95 - 64, 1214 - (1090 + 122))) or ((600 + 1250) == (5134 - 3605))) then
			if (((562 + 259) < (3241 - (628 + 490))) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
				return "throw_glaive rotation 40";
			end
		end
		if (((162 + 740) < (5756 - 3431)) and v79.ImmolationAura:IsCastable() and v45 and (v14:BuffStack(v79.ImmolationAuraBuff) < v97) and v15:IsInRange(36 - 28) and (v14:BuffDown(v79.UnboundChaosBuff) or not v79.UnboundChaos:IsAvailable()) and ((v79.ImmolationAura:Recharge() < v79.EssenceBreak:CooldownRemains()) or (not v79.EssenceBreak:IsAvailable() and (v79.EyeBeam:CooldownRemains() > v79.ImmolationAura:Recharge())))) then
			if (((1632 - (431 + 343)) <= (5981 - 3019)) and v21(v79.ImmolationAura, not v15:IsInRange(23 - 15))) then
				return "immolation_aura rotation 42";
			end
		end
		if ((v79.ThrowGlaive:IsReady() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and v79.Soulscar:IsAvailable() and (v79.ThrowGlaive:FullRechargeTime() < v79.BladeDance:CooldownRemains()) and v14:HasTier(4 + 27, 1697 - (556 + 1139)) and v14:BuffDown(v79.FelBarrage) and not v93) or ((3961 - (6 + 9)) < (236 + 1052))) then
			if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((1661 + 1581) == (736 - (28 + 141)))) then
				return "throw_glaive rotation 44";
			end
		end
		if ((v79.ChaosStrike:IsReady() and v35 and not v92 and not v93 and v14:BuffDown(v79.FelBarrage)) or ((329 + 518) >= (1558 - 295))) then
			if (v21(v79.ChaosStrike, not v15:IsSpellInRange(v79.ChaosStrike)) or ((1596 + 657) == (3168 - (486 + 831)))) then
				return "chaos_strike rotation 46";
			end
		end
		if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and v46 and (v14:FuryDeficit() >= (78 - 48))) or ((7347 - 5260) > (449 + 1923))) then
			if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((14054 - 9609) < (5412 - (668 + 595)))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(8 + 0)) or ((367 + 1451) == (231 - 146))) then
					return "sigil_of_flame rotation player 48";
				end
			elseif (((920 - (23 + 267)) < (4071 - (1129 + 815))) and (v78 == "cursor")) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(417 - (371 + 16))) or ((3688 - (1326 + 424)) == (4761 - 2247))) then
					return "sigil_of_flame rotation cursor 48";
				end
			end
		end
		if (((15548 - 11293) >= (173 - (88 + 30))) and v79.Felblade:IsCastable() and v42 and (v14:FuryDeficit() >= (811 - (720 + 51)))) then
			if (((6670 - 3671) > (2932 - (421 + 1355))) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
				return "felblade rotation 50";
			end
		end
		if (((3876 - 1526) > (568 + 587)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and v79.DemonBlades:IsAvailable() and v79.EyeBeam:CooldownDown() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.FelRush:Recharge() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable())) then
			if (((5112 - (286 + 797)) <= (17740 - 12887)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
				return "fel_rush rotation 52";
			end
		end
		if ((v79.DemonsBite:IsCastable() and v38 and v79.BurningWound:IsAvailable() and (v15:DebuffRemains(v79.BurningWoundDebuff) < (6 - 2))) or ((955 - (397 + 42)) > (1073 + 2361))) then
			if (((4846 - (24 + 776)) >= (4672 - 1639)) and v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite))) then
				return "demons_bite rotation 54";
			end
		end
		if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and not v79.DemonBlades:IsAvailable() and (v88 > (786 - (222 + 563))) and v14:BuffDown(v79.UnboundChaosBuff)) or ((5990 - 3271) <= (1042 + 405))) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((4324 - (23 + 167)) < (5724 - (690 + 1108)))) then
				return "fel_rush rotation 56";
			end
		end
		if ((v79.SigilOfFlame:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= (11 + 19)) and v15:IsInRange(25 + 5)) or ((1012 - (40 + 808)) >= (459 + 2326))) then
			if ((v78 == "player") or v79.ConcentratedSigils:IsAvailable() or ((2007 - 1482) == (2016 + 93))) then
				if (((18 + 15) == (19 + 14)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(579 - (47 + 524)))) then
					return "sigil_of_flame rotation player 58";
				end
			elseif (((1982 + 1072) <= (10975 - 6960)) and (v78 == "cursor")) then
				if (((2797 - 926) < (7712 - 4330)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1756 - (1165 + 561)))) then
					return "sigil_of_flame rotation cursor 58";
				end
			end
		end
		if (((39 + 1254) <= (6708 - 4542)) and v79.DemonsBite:IsCastable() and v38) then
			if (v21(v79.DemonsBite, not v15:IsSpellInRange(v79.DemonsBite)) or ((985 + 1594) < (602 - (341 + 138)))) then
				return "demons_bite rotation 57";
			end
		end
		if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) <= (6 + 14))) or ((1745 - 899) >= (2694 - (89 + 237)))) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((12906 - 8894) <= (7069 - 3711))) then
				return "fel_rush rotation 58";
			end
		end
		if (((2375 - (581 + 300)) <= (4225 - (855 + 365))) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and not v15:IsInRange(18 - 10) and not v79.Momentum:IsAvailable()) then
			if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((1016 + 2095) == (3369 - (1030 + 205)))) then
				return "fel_rush rotation 59";
			end
		end
		if (((2211 + 144) == (2191 + 164)) and v79.VengefulRetreat:IsCastable() and v32 and v48 and v79.Felblade:CooldownUp() and (v14:GCDRemains() == (286 - (156 + 130))) and not v79.Initiative:IsAvailable() and not v15:IsInRange(17 - 9)) then
			if (v21(v79.VengefulRetreat, not v15:IsInRange(13 - 5)) or ((1204 - 616) <= (114 + 318))) then
				return "vengeful_retreat rotation 60";
			end
		end
		if (((2798 + 1999) >= (3964 - (10 + 59))) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat) and not v14:IsMoving() and (v79.DemonBlades:IsAvailable() or not v15:IsInRange(59 - 47)) and v15:DebuffDown(v79.EssenceBreakDebuff) and v15:IsSpellInRange(v79.ThrowGlaive) and not v14:HasTier(1194 - (671 + 492), 2 + 0)) then
			if (((4792 - (369 + 846)) == (947 + 2630)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
				return "throw_glaive rotation 62";
			end
		end
	end
	local function v112()
		local v124 = 0 + 0;
		while true do
			if (((5739 - (1036 + 909)) > (2937 + 756)) and (v124 == (1 - 0))) then
				v36 = EpicSettings.Settings['useConsumeMagic'];
				v37 = EpicSettings.Settings['useDeathSweep'];
				v38 = EpicSettings.Settings['useDemonsBite'];
				v124 = 205 - (11 + 192);
			end
			if ((v124 == (2 + 0)) or ((1450 - (135 + 40)) == (9933 - 5833))) then
				v39 = EpicSettings.Settings['useEssenceBreak'];
				v40 = EpicSettings.Settings['useEyeBeam'];
				v41 = EpicSettings.Settings['useFelBarrage'];
				v124 = 2 + 1;
			end
			if ((v124 == (6 - 3)) or ((2384 - 793) >= (3756 - (50 + 126)))) then
				v42 = EpicSettings.Settings['useFelblade'];
				v43 = EpicSettings.Settings['useFelRush'];
				v44 = EpicSettings.Settings['useGlaiveTempest'];
				v124 = 11 - 7;
			end
			if (((218 + 765) <= (3221 - (1233 + 180))) and (v124 == (974 - (522 + 447)))) then
				v48 = EpicSettings.Settings['useVengefulRetreat'];
				v53 = EpicSettings.Settings['useElysianDecree'];
				v54 = EpicSettings.Settings['useMetamorphosis'];
				v124 = 1427 - (107 + 1314);
			end
			if (((2 + 2) == v124) or ((6551 - 4401) <= (509 + 688))) then
				v45 = EpicSettings.Settings['useImmolationAura'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v47 = EpicSettings.Settings['useThrowGlaive'];
				v124 = 9 - 4;
			end
			if (((14912 - 11143) >= (3083 - (716 + 1194))) and ((0 + 0) == v124)) then
				v33 = EpicSettings.Settings['useAnnihilation'];
				v34 = EpicSettings.Settings['useBladeDance'];
				v35 = EpicSettings.Settings['useChaosStrike'];
				v124 = 1 + 0;
			end
			if (((1988 - (74 + 429)) == (2864 - 1379)) and (v124 == (4 + 3))) then
				v58 = EpicSettings.Settings['theHuntWithCD'];
				v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if ((v124 == (5 + 1)) or ((10219 - 6904) <= (6878 - 4096))) then
				v55 = EpicSettings.Settings['useTheHunt'];
				v56 = EpicSettings.Settings['elysianDecreeWithCD'];
				v57 = EpicSettings.Settings['metamorphosisWithCD'];
				v124 = 440 - (279 + 154);
			end
		end
	end
	local function v113()
		v49 = EpicSettings.Settings['useChaosNova'];
		v50 = EpicSettings.Settings['useDisrupt'];
		v51 = EpicSettings.Settings['useFelEruption'];
		v52 = EpicSettings.Settings['useSigilOfMisery'];
		v61 = EpicSettings.Settings['useBlur'];
		v62 = EpicSettings.Settings['useNetherwalk'];
		v63 = EpicSettings.Settings['blurHP'] or (778 - (454 + 324));
		v64 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v78 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v114()
		local v131 = 17 - (12 + 5);
		while true do
			if ((v131 == (0 + 0)) or ((2231 - 1355) >= (1096 + 1868))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (1093 - (277 + 816));
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v131 = 4 - 3;
			end
			if ((v131 == (1185 - (1058 + 125))) or ((419 + 1813) > (3472 - (815 + 160)))) then
				v73 = EpicSettings.Settings['useHealingPotion'];
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v131 = 1 + 2;
			end
			if ((v131 == (2 - 1)) or ((4008 - (41 + 1857)) <= (2225 - (1222 + 671)))) then
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v131 = 5 - 3;
			end
			if (((5297 - 1611) > (4354 - (229 + 953))) and (v131 == (1777 - (1111 + 663)))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v115()
		v113();
		v112();
		v114();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['movement'];
		if (v14:IsDeadOrGhost() or ((6053 - (874 + 705)) < (115 + 705))) then
			return v28;
		end
		v86 = v14:GetEnemiesInMeleeRange(6 + 2);
		v87 = v14:GetEnemiesInMeleeRange(41 - 21);
		if (((121 + 4158) >= (3561 - (642 + 37))) and v30) then
			v88 = ((#v86 > (0 + 0)) and #v86) or (1 + 0);
			v89 = #v87;
		else
			local v140 = 0 - 0;
			while true do
				if ((v140 == (454 - (233 + 221))) or ((4691 - 2662) >= (3100 + 421))) then
					v88 = 1542 - (718 + 823);
					v89 = 1 + 0;
					break;
				end
			end
		end
		v98 = v14:GCD() + (805.05 - (266 + 539));
		if (v23.TargetIsValid() or v14:AffectingCombat() or ((5767 - 3730) >= (5867 - (636 + 589)))) then
			local v141 = 0 - 0;
			while true do
				if (((3547 - 1827) < (3533 + 925)) and (v141 == (1 + 0))) then
					if ((v102 == (12126 - (657 + 358))) or ((1154 - 718) > (6882 - 3861))) then
						v102 = v10.FightRemains(v86, false);
					end
					break;
				end
				if (((1900 - (1151 + 36)) <= (818 + 29)) and (v141 == (0 + 0))) then
					v101 = v10.BossFightRemains(nil, true);
					v102 = v101;
					v141 = 2 - 1;
				end
			end
		end
		v28 = v107();
		if (((3986 - (1552 + 280)) <= (4865 - (64 + 770))) and v28) then
			return v28;
		end
		if (((3134 + 1481) == (10476 - 5861)) and v66) then
			local v142 = 0 + 0;
			while true do
				if ((v142 == (1243 - (157 + 1086))) or ((7586 - 3796) == (2189 - 1689))) then
					v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 46 - 16, true);
					if (((120 - 31) < (1040 - (599 + 220))) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((4090 - 2036) >= (3352 - (1813 + 118))) and v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) then
			if (((1909 - (841 + 376)) < (4284 - 1226)) and v23.TargetIsValid() and v79.Felblade:IsCastable() and v42) then
				if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((756 + 2498) == (4517 - 2862))) then
					return "felblade rotation 1";
				end
			end
		elseif ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2155 - (464 + 395)) == (12601 - 7691))) then
			if (((1618 + 1750) == (4205 - (467 + 370))) and not v14:AffectingCombat() and v29) then
				local v175 = 0 - 0;
				while true do
					if (((1941 + 702) < (13077 - 9262)) and (v175 == (0 + 0))) then
						v28 = v108();
						if (((4450 - 2537) > (1013 - (150 + 370))) and v28) then
							return v28;
						end
						break;
					end
				end
			end
			if (((6037 - (74 + 1208)) > (8431 - 5003)) and v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) then
				if (((6549 - 5168) <= (1686 + 683)) and v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic))) then
					return "greater_purge damage";
				end
			end
			if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v15:NPCID())) or ((5233 - (14 + 376)) == (7083 - 2999))) then
				if (((3022 + 1647) > (319 + 44)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
					return "fodder to the flames react per target";
				end
			end
			if ((v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v103, v16:NPCID())) or ((1791 + 86) >= (9194 - 6056))) then
				if (((3568 + 1174) >= (3704 - (23 + 55))) and v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive))) then
					return "fodder to the flames react per mouseover";
				end
			end
			v91 = v79.FirstBlood:IsAvailable() or v79.TrailofRuin:IsAvailable() or (v79.ChaosTheory:IsAvailable() and v14:BuffDown(v79.ChaosTheoryBuff)) or (v88 > (2 - 1));
			v92 = v91 and (v14:Fury() < ((51 + 24) - (v24(v79.DemonBlades:IsAvailable()) * (18 + 2)))) and (v79.BladeDance:CooldownRemains() < v98);
			v93 = v79.Demonic:IsAvailable() and not v79.BlindFury:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v98 * (2 - 0))) and (v14:FuryDeficit() > (10 + 20));
			v95 = (v79.Momentum:IsAvailable() and v14:BuffDown(v79.MomentumBuff)) or (v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff));
			local v174 = v27(v79.EyeBeam:BaseDuration(), v14:GCD());
			v96 = v79.Demonic:IsAvailable() and v79.EssenceBreak:IsAvailable() and (v102 > (v79.Metamorphosis:CooldownRemains() + (931 - (652 + 249)) + (v24(v79.ShatteredDestiny:IsAvailable()) * (160 - 100)))) and (v79.Metamorphosis:CooldownRemains() < (1888 - (708 + 1160))) and (v79.Metamorphosis:CooldownRemains() > (v174 + (v98 * (v24(v79.InnerDemon:IsAvailable()) + (5 - 3)))));
			if ((v79.ImmolationAura:IsCastable() and v45 and v79.Ragefire:IsAvailable() and (v88 >= (5 - 2)) and (v79.BladeDance:CooldownDown() or v15:DebuffDown(v79.EssenceBreakDebuff))) or ((4567 - (10 + 17)) == (206 + 710))) then
				if (v21(v79.ImmolationAura, not v15:IsInRange(1740 - (1400 + 332))) or ((2217 - 1061) > (6253 - (242 + 1666)))) then
					return "immolation_aura main 2";
				end
			end
			if (((958 + 1279) < (1558 + 2691)) and v79.ImmolationAura:IsCastable() and v45 and v79.AFireInside:IsAvailable() and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v98 * (2 + 0))) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
				if (v21(v79.ImmolationAura, not v15:IsInRange(948 - (850 + 90))) or ((4698 - 2015) < (1413 - (360 + 1030)))) then
					return "immolation_aura main 3";
				end
			end
			if (((617 + 80) <= (2330 - 1504)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and (((v79.ImmolationAura:Charges() == (2 - 0)) and v15:DebuffDown(v79.EssenceBreakDebuff)) or (v14:PrevGCDP(1662 - (909 + 752), v79.EyeBeam) and v14:BuffUp(v79.InertiaBuff) and (v14:BuffRemains(v79.InertiaBuff) < (1226 - (109 + 1114)))))) then
				if (((2023 - 918) <= (458 + 718)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
					return "fel_rush main 4";
				end
			end
			if (((3621 - (6 + 236)) <= (2402 + 1410)) and v79.TheHunt:IsCastable() and v32 and v55 and (v70 < v102) and ((v31 and v58) or not v58) and (v10.CombatTime() < (9 + 1)) and (not v79.Inertia:IsAvailable() or (v14:BuffUp(v79.MetamorphosisBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)))) then
				if (v21(v79.TheHunt, not v15:IsSpellInRange(v79.TheHunt)) or ((1858 - 1070) >= (2822 - 1206))) then
					return "the_hunt main ?";
				end
			end
			if (((2987 - (1076 + 57)) <= (556 + 2823)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and ((v79.EyeBeam:CooldownRemains() < (v98 * (691 - (579 + 110)))) or v14:BuffUp(v79.MetamorphosisBuff)) and (v79.EssenceBreak:CooldownRemains() < (v98 * (1 + 2))) and v14:BuffDown(v79.UnboundChaosBuff) and v14:BuffDown(v79.InertiaBuff) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
				if (((4022 + 527) == (2415 + 2134)) and v21(v79.ImmolationAura, not v15:IsInRange(415 - (174 + 233)))) then
					return "immolation_aura main 5";
				end
			end
			if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:FullRechargeTime() < v79.EssenceBreak:CooldownRemains()) or not v79.EssenceBreak:IsAvailable()) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:BuffDown(v79.MetamorphosisBuff) or (v14:BuffRemains(v79.MetamorphosisBuff) > (16 - 10))) and v79.BladeDance:CooldownDown() and ((v14:Fury() < (131 - 56)) or (v79.BladeDance:CooldownRemains() < (v98 * (1 + 1))))) or ((4196 - (663 + 511)) >= (2698 + 326))) then
				if (((1047 + 3773) > (6776 - 4578)) and v21(v79.ImmolationAura, not v15:IsInRange(5 + 3))) then
					return "immolation_aura main 6";
				end
			end
			if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and ((v14:BuffRemains(v79.UnboundChaosBuff) < (v98 * (4 - 2))) or (v15:TimeToDie() < (v98 * (4 - 2))))) or ((507 + 554) >= (9519 - 4628))) then
				if (((973 + 391) <= (409 + 4064)) and v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive))) then
					return "fel_rush main 8";
				end
			end
			if ((v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffUp(v79.UnboundChaosBuff) and ((v79.EyeBeam:CooldownRemains() + (725 - (478 + 244))) > v14:BuffRemains(v79.UnboundChaosBuff)) and (v79.BladeDance:CooldownDown() or v79.EssenceBreak:CooldownUp())) or ((4112 - (440 + 77)) <= (2 + 1))) then
				if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((17099 - 12427) == (5408 - (655 + 901)))) then
					return "fel_rush main 9";
				end
			end
			if (((290 + 1269) == (1194 + 365)) and v79.FelRush:IsCastable() and v14:BuffUp(v79.UnboundChaosBuff) and v32 and v43 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v14:BuffUp(v79.MetamorphosisBuff) or (v79.EssenceBreak:CooldownRemains() > (7 + 3)))) then
				if (v21(v79.FelRush, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((7058 - 5306) <= (2233 - (695 + 750)))) then
					return "fel_rush main 10";
				end
			end
			if (((v70 < v102) and v31) or ((13341 - 9434) == (273 - 96))) then
				local v176 = 0 - 0;
				while true do
					if (((3821 - (285 + 66)) > (1293 - 738)) and ((1310 - (682 + 628)) == v176)) then
						v28 = v110();
						if (v28 or ((157 + 815) == (944 - (176 + 123)))) then
							return v28;
						end
						break;
					end
				end
			end
			if (((1331 + 1851) >= (1535 + 580)) and v14:BuffUp(v79.MetamorphosisBuff) and (v14:BuffRemains(v79.MetamorphosisBuff) < v98) and (v88 < (272 - (239 + 30)))) then
				local v177 = 0 + 0;
				while true do
					if (((3742 + 151) < (7838 - 3409)) and (v177 == (0 - 0))) then
						v28 = v109();
						if (v28 or ((3182 - (306 + 9)) < (6647 - 4742))) then
							return v28;
						end
						break;
					end
				end
			end
			v28 = v111();
			if (v28 or ((313 + 1483) >= (2486 + 1565))) then
				return v28;
			end
			if (((780 + 839) <= (10740 - 6984)) and (v79.DemonBlades:IsAvailable())) then
				if (((1979 - (1140 + 235)) == (385 + 219)) and v21(v79.Pool)) then
					return "pool demon_blades";
				end
			end
		end
	end
	local function v116()
		local v136 = 0 + 0;
		while true do
			if (((0 + 0) == v136) or ((4536 - (33 + 19)) == (325 + 575))) then
				v79.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(1729 - 1152, v115, v116);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

