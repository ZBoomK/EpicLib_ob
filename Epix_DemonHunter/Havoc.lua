local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2237 + 1255) > (461 + 3748))) then
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
	local v82, v83;
	local v84, v85;
	local v86 = {{v78.FelEruption},{v78.ChaosNova}};
	local v87 = false;
	local v88 = false;
	local v89 = 95 - (51 + 44);
	local v90 = 0 + 0;
	local v91 = v13:GCD() + (1317.25 - (1114 + 203));
	local v92 = 11837 - (228 + 498);
	local v93 = 2408 + 8703;
	local v94 = {(170084 - (174 + 489)),(171330 - (830 + 1075)),(170201 - (231 + 1038)),(170588 - (171 + 991)),(454950 - 285521),(135601 + 33827),(488772 - 319342)};
	v9:RegisterForEvent(function()
		local v108 = 0 - 0;
		while true do
			if (((11820 - 7996) > (1657 - (111 + 1137))) and (v108 == (158 - (91 + 67)))) then
				v87 = false;
				v92 = 33069 - 21958;
				v108 = 1 + 0;
			end
			if (((2610 - (423 + 100)) == (15 + 2072)) and (v108 == (2 - 1))) then
				v93 = 5792 + 5319;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v95()
		v27 = v22.HandleTopTrinket(v81, v30, 811 - (326 + 445), nil);
		if (v27 or ((14854 - 11450) > (10031 - 5528))) then
			return v27;
		end
		v27 = v22.HandleBottomTrinket(v81, v30, 93 - 53, nil);
		if (v27 or ((4217 - (530 + 181)) <= (2190 - (614 + 267)))) then
			return v27;
		end
	end
	local function v96()
		if (((2987 - (19 + 13)) == (4809 - 1854)) and v78.Blur:IsCastable() and v60 and (v13:HealthPercentage() <= v62)) then
			if (v20(v78.Blur) or ((6764 - 3861) == (4270 - 2775))) then
				return "blur defensive";
			end
		end
		if (((1181 + 3365) >= (4000 - 1725)) and v78.Netherwalk:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) then
			if (((1698 - 879) >= (1834 - (1293 + 519))) and v20(v78.Netherwalk)) then
				return "netherwalk defensive";
			end
		end
		if (((6450 - 3288) == (8255 - 5093)) and v79.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v75)) then
			if (v20(v80.Healthstone) or ((4529 - 2160) > (19098 - 14669))) then
				return "healthstone defensive";
			end
		end
		if (((9646 - 5551) >= (1686 + 1497)) and v72 and (v13:HealthPercentage() <= v74)) then
			if ((v76 == "Refreshing Healing Potion") or ((758 + 2953) < (2341 - 1333))) then
				if (v79.RefreshingHealingPotion:IsReady() or ((243 + 806) <= (301 + 605))) then
					if (((2821 + 1692) > (3822 - (709 + 387))) and v20(v80.RefreshingHealingPotion)) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v76 == "Dreamwalker's Healing Potion") or ((3339 - (673 + 1185)) >= (7708 - 5050))) then
				if (v79.DreamwalkersHealingPotion:IsReady() or ((10340 - 7120) == (2243 - 879))) then
					if (v20(v80.RefreshingHealingPotion) or ((754 + 300) > (2535 + 857))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v97()
		local v109 = 0 - 0;
		while true do
			if ((v109 == (1 + 1)) or ((1347 - 671) >= (3222 - 1580))) then
				if (((6016 - (446 + 1434)) > (3680 - (1040 + 243))) and not v14:IsInMeleeRange(14 - 9) and v78.FelRush:IsCastable() and (not v78.Felblade:IsAvailable() or (v78.Felblade:CooldownUp() and not v13:PrevGCDP(1848 - (559 + 1288), v78.Felblade))) and v31 and v42) then
					if (v20(v78.FelRush, not v14:IsInRange(1946 - (609 + 1322))) or ((4788 - (13 + 441)) == (15862 - 11617))) then
						return "fel_rush precombat 10";
					end
				end
				if ((v14:IsInMeleeRange(13 - 8) and v37 and (v78.DemonsBite:IsCastable() or v78.DemonBlades:IsAvailable())) or ((21296 - 17020) <= (113 + 2918))) then
					if (v20(v78.DemonsBite, not v14:IsInMeleeRange(18 - 13)) or ((1699 + 3083) <= (526 + 673))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if ((v109 == (2 - 1)) or ((2662 + 2202) < (3497 - 1595))) then
				if (((3200 + 1639) >= (2058 + 1642)) and not v14:IsInMeleeRange(4 + 1) and v78.Felblade:IsCastable() and v41) then
					if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((903 + 172) > (1877 + 41))) then
						return "felblade precombat 9";
					end
				end
				if (((829 - (153 + 280)) <= (10984 - 7180)) and not v14:IsInMeleeRange(5 + 0) and v78.ThrowGlaive:IsCastable() and v46 and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat)) then
					if (v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((2182 + 1987) == (1985 + 202))) then
						return "throw_glaive precombat 9";
					end
				end
				v109 = 2 + 0;
			end
			if (((2140 - 734) == (869 + 537)) and (v109 == (667 - (89 + 578)))) then
				if (((1094 + 437) < (8879 - 4608)) and v78.ImmolationAura:IsCastable() and v44) then
					if (((1684 - (572 + 477)) == (86 + 549)) and v20(v78.ImmolationAura, not v14:IsInRange(5 + 3))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((403 + 2970) <= (3642 - (84 + 2))) and v45 and not v13:IsMoving() and (v84 > (1 - 0)) and v78.SigilOfFlame:IsCastable()) then
					if ((v77 == "player") or v78.ConcentratedSigils:IsAvailable() or ((2371 + 920) < (4122 - (497 + 345)))) then
						if (((113 + 4273) >= (148 + 725)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1341 - (605 + 728)))) then
							return "sigil_of_flame precombat 9";
						end
					elseif (((658 + 263) <= (2449 - 1347)) and (v77 == "cursor")) then
						if (((216 + 4490) >= (3560 - 2597)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(37 + 3))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v109 = 2 - 1;
			end
		end
	end
	local function v98()
		if ((((v30 and v56) or not v56) and v78.Metamorphosis:IsCastable() and v53 and (((not v78.Demonic:IsAvailable() or (v13:BuffRemains(v78.MetamorphosisBuff) < v13:GCD())) and (v78.EyeBeam:CooldownRemains() > (0 + 0)) and (not v78.EssenceBreak:IsAvailable() or v14:DebuffUp(v78.EssenceBreakDebuff)) and v13:BuffDown(v78.FelBarrageBuff)) or not v78.ChaoticTransformation:IsAvailable() or (v93 < (519 - (457 + 32))))) or ((408 + 552) <= (2278 - (832 + 570)))) then
			if (v20(v80.MetamorphosisPlayer, not v14:IsInRange(8 + 0)) or ((539 + 1527) == (3297 - 2365))) then
				return "metamorphosis cooldown 2";
			end
		end
		local v110 = v22.HandleDPSPotion(v13:BuffUp(v78.MetamorphosisBuff));
		if (((2325 + 2500) < (5639 - (588 + 208))) and v110) then
			return v110;
		end
		if ((v69 < v93) or ((10449 - 6572) >= (6337 - (884 + 916)))) then
			if ((v70 and ((v30 and v71) or not v71)) or ((9033 - 4718) < (1001 + 725))) then
				v27 = v95();
				if (v27 or ((4332 - (232 + 421)) < (2514 - (1569 + 320)))) then
					return v27;
				end
			end
		end
		if ((((v30 and v57) or not v57) and v31 and v78.TheHunt:IsCastable() and v54 and v14:DebuffDown(v78.EssenceBreakDebuff) and (v9.CombatTime() > (2 + 3))) or ((879 + 3746) < (2129 - 1497))) then
			if (v20(v78.TheHunt, not v14:IsInRange(645 - (316 + 289))) or ((216 - 133) > (83 + 1697))) then
				return "the_hunt cooldown 4";
			end
		end
		if (((1999 - (666 + 787)) <= (1502 - (360 + 65))) and v52 and not v13:IsMoving() and ((v30 and v55) or not v55) and v78.ElysianDecree:IsCastable() and (v14:DebuffDown(v78.EssenceBreakDebuff)) and (v84 > v59)) then
			if ((v58 == "player") or ((931 + 65) > (4555 - (79 + 175)))) then
				if (((6417 - 2347) > (537 + 150)) and v20(v80.ElysianDecreePlayer, not v14:IsInRange(24 - 16))) then
					return "elysian_decree cooldown 6 (Player)";
				end
			elseif ((v58 == "cursor") or ((1263 - 607) >= (4229 - (503 + 396)))) then
				if (v20(v80.ElysianDecreeCursor, not v14:IsInRange(211 - (92 + 89))) or ((4833 - 2341) <= (172 + 163))) then
					return "elysian_decree cooldown 6 (Cursor)";
				end
			end
		end
	end
	local function v99()
		local v111 = 0 + 0;
		while true do
			if (((16925 - 12603) >= (351 + 2211)) and (v111 == (0 - 0))) then
				if ((v78.VengefulRetreat:IsCastable() and v47 and v31 and v13:PrevGCDP(1 + 0, v78.DeathSweep) and (v78.Felblade:CooldownRemains() == (0 + 0))) or ((11077 - 7440) >= (471 + 3299))) then
					if (v20(v78.VengefulRetreat, not v14:IsInRange(12 - 4), true, true) or ((3623 - (485 + 759)) > (10592 - 6014))) then
						return "vengeful_retreat opener 1";
					end
				end
				if ((v78.Metamorphosis:IsCastable() and v53 and ((v30 and v56) or not v56) and (v13:PrevGCDP(1190 - (442 + 747), v78.DeathSweep) or (not v78.ChaoticTransformation:IsAvailable() and (not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (1137 - (832 + 303))))) or not v78.Demonic:IsAvailable())) or ((1429 - (88 + 858)) > (227 + 516))) then
					if (((2031 + 423) > (24 + 554)) and v20(v80.MetamorphosisPlayer, not v14:IsInRange(797 - (766 + 23)))) then
						return "metamorphosis opener 2";
					end
				end
				if (((4591 - 3661) < (6096 - 1638)) and v78.Felblade:IsCastable() and v41 and v14:DebuffDown(v78.EssenceBreakDebuff)) then
					if (((1743 - 1081) <= (3298 - 2326)) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
						return "felblade opener 3";
					end
				end
				if (((5443 - (1036 + 37)) == (3099 + 1271)) and v78.ImmolationAura:IsCastable() and v44 and (v78.ImmolationAura:Charges() == (3 - 1)) and v13:BuffDown(v78.UnboundChaosBuff) and (v13:BuffDown(v78.InertiaBuff) or (v84 > (2 + 0)))) then
					if (v20(v78.ImmolationAura, not v14:IsInRange(1488 - (641 + 839))) or ((5675 - (910 + 3)) <= (2194 - 1333))) then
						return "immolation_aura opener 4";
					end
				end
				v111 = 1685 - (1466 + 218);
			end
			if ((v111 == (1 + 1)) or ((2560 - (556 + 592)) == (1517 + 2747))) then
				if ((v78.EssenceBreak:IsCastable() and v38) or ((3976 - (329 + 479)) < (3007 - (174 + 680)))) then
					if (v20(v78.EssenceBreak, not v14:IsInMeleeRange(17 - 12)) or ((10313 - 5337) < (952 + 380))) then
						return "essence_break opener 9";
					end
				end
				if (((5367 - (396 + 343)) == (410 + 4218)) and v78.DeathSweep:IsCastable() and v36) then
					if (v20(v78.DeathSweep, not v14:IsInMeleeRange(1482 - (29 + 1448))) or ((1443 - (135 + 1254)) == (1488 - 1093))) then
						return "death_sweep opener 10";
					end
				end
				if (((382 - 300) == (55 + 27)) and v78.Annihilation:IsCastable() and v32) then
					if (v20(v78.Annihilation, not v14:IsInMeleeRange(1532 - (389 + 1138))) or ((1155 - (102 + 472)) < (267 + 15))) then
						return "annihilation opener 11";
					end
				end
				if ((v78.DemonsBite:IsCastable() and v37) or ((2556 + 2053) < (2327 + 168))) then
					if (((2697 - (320 + 1225)) == (2050 - 898)) and v20(v78.DemonsBite, not v14:IsInMeleeRange(4 + 1))) then
						return "demons_bite opener 12";
					end
				end
				break;
			end
			if (((3360 - (157 + 1307)) <= (5281 - (821 + 1038))) and (v111 == (2 - 1))) then
				if ((v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (not v78.ChaoticTransformation:IsAvailable() or v78.Metamorphosis:CooldownUp())) or ((109 + 881) > (2877 - 1257))) then
					if (v20(v78.Annihilation, not v14:IsInMeleeRange(2 + 3)) or ((2173 - 1296) > (5721 - (834 + 192)))) then
						return "annihilation opener 5";
					end
				end
				if (((172 + 2519) >= (476 + 1375)) and v78.EyeBeam:IsCastable() and v39 and v14:DebuffDown(v78.EssenceBreakDebuff) and v13:BuffDown(v78.InnerDemonBuff) and (not v13:BuffUp(v78.MetamorphosisBuff) or (v78.BladeDance:CooldownRemains() > (0 + 0)))) then
					if (v20(v78.EyeBeam, not v14:IsInRange(12 - 4)) or ((3289 - (300 + 4)) >= (1297 + 3559))) then
						return "eye_beam opener 6";
					end
				end
				if (((11193 - 6917) >= (1557 - (112 + 250))) and v78.FelRush:IsReady() and v42 and v31 and v78.Inertia:IsAvailable() and (v13:BuffDown(v78.InertiaBuff) or (v84 > (1 + 1))) and v13:BuffUp(v78.UnboundChaosBuff)) then
					if (((8096 - 4864) <= (2687 + 2003)) and v20(v78.FelRush, not v14:IsInRange(8 + 7))) then
						return "fel_rush opener 7";
					end
				end
				if ((v78.TheHunt:IsCastable() and v54 and ((v30 and v57) or not v57) and v31) or ((671 + 225) >= (1560 + 1586))) then
					if (((2274 + 787) >= (4372 - (1001 + 413))) and v20(v78.TheHunt, not v14:IsInRange(89 - 49))) then
						return "the_hunt opener 8";
					end
				end
				v111 = 884 - (244 + 638);
			end
		end
	end
	local function v100()
		v88 = (v78.Felblade:CooldownRemains() < v91) or (v78.SigilOfFlame:CooldownRemains() < v91);
		v89 = (((694 - (627 + 66)) % ((5.6 - 3) * v13:AttackHaste())) * (614 - (512 + 90))) + (v13:BuffStack(v78.ImmolationAuraBuff) * (1912 - (1665 + 241))) + (v23(v13:BuffUp(v78.TacticalRetreatBuff)) * (727 - (373 + 344)));
		v90 = v91 * (15 + 17);
		if (((844 + 2343) >= (1698 - 1054)) and v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff)) then
			if (((1089 - 445) <= (1803 - (35 + 1064))) and v20(v78.Annihilation, not v14:IsInMeleeRange(4 + 1))) then
				return "annihilation fel_barrage 1";
			end
		end
		if (((2049 - 1091) > (4 + 943)) and v78.EyeBeam:IsCastable() and v39 and v13:BuffDown(v78.FelBarrageBuff)) then
			if (((5728 - (298 + 938)) >= (3913 - (233 + 1026))) and v20(v78.EyeBeam, not v14:IsInRange(1674 - (636 + 1030)))) then
				return "eye_beam fel_barrage 3";
			end
		end
		if (((1760 + 1682) >= (1469 + 34)) and v78.EssenceBreak:IsCastable() and v38 and v13:BuffDown(v78.FelBarrageBuff) and v13:BuffUp(v78.MetamorphosisBuff)) then
			if (v20(v78.EssenceBreak, not v14:IsInMeleeRange(2 + 3)) or ((215 + 2955) <= (1685 - (55 + 166)))) then
				return "essence_break fel_barrage 5";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36 and v13:BuffDown(v78.FelBarrageBuff)) or ((930 + 3867) == (442 + 3946))) then
			if (((2104 - 1553) <= (978 - (36 + 261))) and v20(v78.DeathSweep, not v14:IsInMeleeRange(8 - 3))) then
				return "death_sweep fel_barrage 7";
			end
		end
		if (((4645 - (34 + 1334)) > (157 + 250)) and v78.ImmolationAura:IsCastable() and v44 and v13:BuffDown(v78.UnboundChaosBuff) and ((v84 > (2 + 0)) or v13:BuffUp(v78.FelBarrageBuff))) then
			if (((5978 - (1035 + 248)) >= (1436 - (20 + 1))) and v20(v78.ImmolationAura, not v14:IsInRange(5 + 3))) then
				return "immolation_aura fel_barrage 9";
			end
		end
		if ((v78.GlaiveTempest:IsCastable() and v43 and v13:BuffDown(v78.FelBarrageBuff) and (v84 > (320 - (134 + 185)))) or ((4345 - (549 + 584)) <= (1629 - (314 + 371)))) then
			if (v20(v78.GlaiveTempest, not v14:IsInMeleeRange(17 - 12)) or ((4064 - (478 + 490)) <= (953 + 845))) then
				return "glaive_tempest fel_barrage 11";
			end
		end
		if (((4709 - (786 + 386)) == (11456 - 7919)) and v78.BladeDance:IsCastable() and v33 and v13:BuffDown(v78.FelBarrageBuff)) then
			if (((5216 - (1055 + 324)) >= (2910 - (1093 + 247))) and v20(v78.BladeDance, not v14:IsInMeleeRange(5 + 0))) then
				return "blade_dance fel_barrage 13";
			end
		end
		if ((v78.FelBarrage:IsCastable() and v40 and (v13:Fury() > (11 + 89))) or ((11712 - 8762) == (12936 - 9124))) then
			if (((13439 - 8716) >= (5824 - 3506)) and v20(v78.FelBarrage, not v14:IsInMeleeRange(2 + 3))) then
				return "fel_barrage fel_barrage 15";
			end
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff) and (v13:Fury() > (77 - 57)) and v13:BuffUp(v78.FelBarrageBuff)) or ((6986 - 4959) > (2151 + 701))) then
			if (v20(v78.FelRush, not v14:IsInRange(38 - 23)) or ((1824 - (364 + 324)) > (11834 - 7517))) then
				return "fel_rush fel_barrage 17";
			end
		end
		if (((11393 - 6645) == (1574 + 3174)) and v45 and v78.SigilOfFlame:IsCastable() and (v13:FuryDeficit() > (167 - 127)) and v13:BuffUp(v78.FelBarrageBuff)) then
			if (((5983 - 2247) <= (14395 - 9655)) and ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1276 - (1249 + 19))) or ((3060 + 330) <= (11911 - 8851))) then
					return "sigil_of_flame fel_barrage 18";
				end
			elseif ((v77 == "cursor") or ((2085 - (686 + 400)) > (2113 + 580))) then
				if (((692 - (73 + 156)) < (3 + 598)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(851 - (721 + 90)))) then
					return "sigil_of_flame fel_barrage 18";
				end
			end
		end
		if ((v78.Felblade:IsCastable() and v41 and v13:BuffUp(v78.FelBarrageBuff) and (v13:FuryDeficit() > (1 + 39))) or ((7087 - 4904) < (1157 - (224 + 246)))) then
			if (((7368 - 2819) == (8375 - 3826)) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
				return "felblade fel_barrage 19";
			end
		end
		if (((848 + 3824) == (112 + 4560)) and v78.DeathSweep:IsCastable() and v36 and (((v13:Fury() - v90) - (26 + 9)) > (0 - 0)) and ((v13:BuffRemains(v78.FelBarrageBuff) < (9 - 6)) or v88 or (v13:Fury() > (593 - (203 + 310))) or (v89 > (2011 - (1238 + 755))))) then
			if (v20(v78.DeathSweep, not v14:IsInMeleeRange(1 + 4)) or ((5202 - (709 + 825)) < (727 - 332))) then
				return "death_sweep fel_barrage 21";
			end
		end
		if ((v78.GlaiveTempest:IsCastable() and v43 and (((v13:Fury() - v90) - (43 - 13)) > (864 - (196 + 668))) and ((v13:BuffRemains(v78.FelBarrageBuff) < (11 - 8)) or v88 or (v13:Fury() > (165 - 85)) or (v89 > (851 - (171 + 662))))) or ((4259 - (4 + 89)) == (1594 - 1139))) then
			if (v20(v78.GlaiveTempest, not v14:IsInMeleeRange(2 + 3)) or ((19540 - 15091) == (1045 + 1618))) then
				return "glaive_tempest fel_barrage 23";
			end
		end
		if ((v78.BladeDance:IsCastable() and v33 and (((v13:Fury() - v90) - (1521 - (35 + 1451))) > (1453 - (28 + 1425))) and ((v13:BuffRemains(v78.FelBarrageBuff) < (1996 - (941 + 1052))) or v88 or (v13:Fury() > (77 + 3)) or (v89 > (1532 - (822 + 692))))) or ((6106 - 1829) < (1408 + 1581))) then
			if (v20(v78.BladeDance, not v14:IsInMeleeRange(302 - (45 + 252))) or ((861 + 9) >= (1428 + 2721))) then
				return "blade_dance fel_barrage 25";
			end
		end
		if (((5382 - 3170) < (3616 - (114 + 319))) and v78.ArcaneTorrent:IsCastable() and (v13:FuryDeficit() > (57 - 17)) and v13:BuffUp(v78.FelBarrageBuff)) then
			if (((5953 - 1307) > (1908 + 1084)) and v20(v78.ArcaneTorrent)) then
				return "arcane_torrent fel_barrage 27";
			end
		end
		if (((2135 - 701) < (6507 - 3401)) and v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff)) then
			if (((2749 - (556 + 1407)) < (4229 - (741 + 465))) and v20(v78.FelRush, not v14:IsInRange(480 - (170 + 295)))) then
				return "fel_rush fel_barrage 29";
			end
		end
		if ((v78.TheHunt:IsCastable() and v54 and ((v30 and v57) or not v57) and v31 and (v13:Fury() > (22 + 18))) or ((2244 + 198) < (182 - 108))) then
			if (((3760 + 775) == (2909 + 1626)) and v20(v78.TheHunt, not v14:IsInRange(23 + 17))) then
				return "the_hunt fel_barrage 31";
			end
		end
		if ((v78.DemonsBite:IsCastable() and v37) or ((4239 - (957 + 273)) <= (563 + 1542))) then
			if (((733 + 1097) < (13980 - 10311)) and v20(v78.DemonsBite, not v14:IsInMeleeRange(13 - 8))) then
				return "demons_bite fel_barrage 33";
			end
		end
	end
	local function v101()
		if ((v78.DeathSweep:IsCastable() and v36 and (v13:BuffRemains(v78.MetamorphosisBuff) < v91)) or ((4367 - 2937) >= (17885 - 14273))) then
			if (((4463 - (389 + 1391)) >= (1544 + 916)) and v20(v78.DeathSweep, not v14:IsInMeleeRange(1 + 4))) then
				return "death_sweep meta 1";
			end
		end
		if ((v78.Annihilation:IsCastable() and v32 and (v13:BuffRemains(v78.MetamorphosisBuff) < v91)) or ((4106 - 2302) >= (4226 - (783 + 168)))) then
			if (v20(v78.Annihilation, not v14:IsInMeleeRange(16 - 11)) or ((1394 + 23) > (3940 - (309 + 2)))) then
				return "annihilation meta 3";
			end
		end
		if (((14725 - 9930) > (1614 - (1090 + 122))) and v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable()) then
			if (((1561 + 3252) > (11972 - 8407)) and v20(v78.FelRush, not v14:IsInRange(11 + 4))) then
				return "fel_rush meta 5";
			end
		end
		if (((5030 - (628 + 490)) == (702 + 3210)) and v78.FelRush:IsReady() and v42 and v31 and v78.Momentum:IsAvailable() and (v13:BuffRemains(v78.MomentumBuff) < (v91 * (4 - 2)))) then
			if (((12891 - 10070) <= (5598 - (431 + 343))) and v20(v78.FelRush, not v14:IsInRange(30 - 15))) then
				return "fel_rush meta 7";
			end
		end
		if (((5027 - 3289) <= (1735 + 460)) and v78.Annihilation:IsCastable() and v32 and v13:BuffUp(v78.InnerDemonBuff) and (((v78.EyeBeam:CooldownRemains() < (v91 * (1 + 2))) and (v78.BladeDance:CooldownRemains() > (1695 - (556 + 1139)))) or (v78.Metamorphosis:CooldownRemains() < (v91 * (18 - (6 + 9)))))) then
			if (((8 + 33) <= (1547 + 1471)) and v20(v78.Annihilation, not v14:IsInMeleeRange(174 - (28 + 141)))) then
				return "annihilation meta 9";
			end
		end
		if (((831 + 1314) <= (5065 - 961)) and ((v78.EssenceBreak:IsCastable() and v38 and (v13:Fury() > (15 + 5)) and ((v78.Metamorphosis:CooldownRemains() > (1327 - (486 + 831))) or (v78.BladeDance:CooldownRemains() < (v91 * (5 - 3)))) and (v13:BuffDown(v78.UnboundChaosBuff) or v13:BuffUp(v78.InertiaBuff) or not v78.Inertia:IsAvailable())) or (v93 < (35 - 25)))) then
			if (((509 + 2180) < (15319 - 10474)) and v20(v78.EssenceBreak, not v14:IsInMeleeRange(1268 - (668 + 595)))) then
				return "essence_break meta 11";
			end
		end
		if ((v78.ImmolationAura:IsCastable() and v44 and v14:DebuffDown(v78.EssenceBreakDebuff) and (v78.BladeDance:CooldownRemains() > (v91 + 0.5 + 0)) and v13:BuffDown(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and ((v78.ImmolationAura:FullRechargeTime() + 1 + 2) < v78.EyeBeam:CooldownRemains()) and (v13:BuffRemains(v78.MetamorphosisBuff) > (13 - 8))) or ((2612 - (23 + 267)) > (4566 - (1129 + 815)))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(395 - (371 + 16))) or ((6284 - (1326 + 424)) == (3942 - 1860))) then
				return "immolation_aura meta 13";
			end
		end
		if ((v78.DeathSweep:IsCastable() and v36) or ((5740 - 4169) > (1985 - (88 + 30)))) then
			if (v20(v78.DeathSweep, not v14:IsInMeleeRange(776 - (720 + 51))) or ((5903 - 3249) >= (4772 - (421 + 1355)))) then
				return "death_sweep meta 15";
			end
		end
		if (((6562 - 2584) > (1034 + 1070)) and v78.EyeBeam:IsCastable() and v39 and v14:DebuffDown(v78.EssenceBreakDebuff) and v13:BuffDown(v78.InnerDemonBuff)) then
			if (((4078 - (286 + 797)) > (5633 - 4092)) and v20(v78.EyeBeam, not v14:IsInRange(12 - 4))) then
				return "eye_beam meta 17";
			end
		end
		if (((3688 - (397 + 42)) > (298 + 655)) and v78.GlaiveTempest:IsCastable() and v43 and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.BladeDance:CooldownRemains() > (v91 * (802 - (24 + 776)))) or (v13:Fury() > (92 - 32)))) then
			if (v20(v78.GlaiveTempest, not v14:IsInMeleeRange(790 - (222 + 563))) or ((7211 - 3938) > (3293 + 1280))) then
				return "glaive_tempest meta 19";
			end
		end
		if ((v45 and v78.SigilOfFlame:IsCastable() and (v84 > (192 - (23 + 167)))) or ((4949 - (690 + 1108)) < (464 + 820))) then
			if ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()) or ((1526 + 324) == (2377 - (40 + 808)))) then
				if (((136 + 685) < (8118 - 5995)) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(8 + 0))) then
					return "sigil_of_flame meta 21";
				end
			elseif (((478 + 424) < (1275 + 1050)) and (v77 == "cursor")) then
				if (((1429 - (47 + 524)) <= (1923 + 1039)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(109 - 69))) then
					return "sigil_of_flame meta 21";
				end
			end
		end
		if ((v78.Annihilation:IsCastable() and v32 and ((v78.BladeDance:CooldownRemains() > (v91 * (2 - 0))) or (v13:Fury() > (136 - 76)) or ((v13:BuffRemains(v78.MetamorphosisBuff) < (1731 - (1165 + 561))) and v78.Felblade:CooldownUp()))) or ((118 + 3828) < (3988 - 2700))) then
			if (v20(v78.Annihilation, not v14:IsInMeleeRange(2 + 3)) or ((3721 - (341 + 138)) == (154 + 413))) then
				return "annihilation meta 23";
			end
		end
		if ((v45 and v78.SigilOfFlame:IsCastable() and (v13:BuffRemains(v78.MetamorphosisBuff) > (10 - 5))) or ((1173 - (89 + 237)) >= (4062 - 2799))) then
			if ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()) or ((4743 - 2490) == (2732 - (581 + 300)))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1228 - (855 + 365))) or ((4957 - 2870) > (775 + 1597))) then
					return "sigil_of_flame meta 25";
				end
			elseif ((v77 == "cursor") or ((5680 - (1030 + 205)) < (3896 + 253))) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(38 + 2)) or ((2104 - (156 + 130)) == (193 - 108))) then
					return "sigil_of_flame meta 25";
				end
			end
		end
		if (((1061 - 431) < (4355 - 2228)) and v78.Felblade:IsCastable() and v41) then
			if (v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade)) or ((511 + 1427) == (1466 + 1048))) then
				return "felblade meta 27";
			end
		end
		if (((4324 - (10 + 59)) >= (16 + 39)) and v45 and v78.SigilOfFlame:IsCastable() and v14:DebuffDown(v78.EssenceBreakDebuff)) then
			if (((14769 - 11770) > (2319 - (671 + 492))) and ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
				if (((1871 + 479) > (2370 - (369 + 846))) and v20(v80.SigilOfFlamePlayer, not v14:IsInRange(3 + 5))) then
					return "sigil_of_flame meta 29";
				end
			elseif (((3439 + 590) <= (6798 - (1036 + 909))) and (v77 == "cursor")) then
				if (v20(v80.SigilOfFlameCursor, not v14:IsInRange(32 + 8)) or ((865 - 349) > (3637 - (11 + 192)))) then
					return "sigil_of_flame meta 29";
				end
			end
		end
		if (((2045 + 2001) >= (3208 - (135 + 40))) and v78.ImmolationAura:IsCastable() and v44 and v14:IsInRange(19 - 11) and (v78.ImmolationAura:Recharge() < v26(v78.EyeBeam:CooldownRemains(), v13:BuffRemains(v78.MetamorphosisBuff)))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(5 + 3)) or ((5989 - 3270) <= (2168 - 721))) then
				return "immolation_aura meta 31";
			end
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v78.Momentum:IsAvailable()) or ((4310 - (50 + 126)) < (10932 - 7006))) then
			if (v20(v78.FelRush, not v14:IsInRange(4 + 11)) or ((1577 - (1233 + 180)) >= (3754 - (522 + 447)))) then
				return "fel_rush meta 33";
			end
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v13:BuffDown(v78.UnboundChaosBuff) and (v78.FelRush:Recharge() < v78.EyeBeam:CooldownRemains()) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.EyeBeam:CooldownRemains() > (1429 - (107 + 1314))) or (v78.EyeBeam:ChargesFractional() > (1.01 + 0)))) or ((1599 - 1074) == (896 + 1213))) then
			if (((65 - 32) == (130 - 97)) and v20(v78.FelRush, not v14:IsInRange(1925 - (716 + 1194)))) then
				return "fel_rush meta 35";
			end
		end
		if (((53 + 3001) <= (431 + 3584)) and v78.DemonsBite:IsCastable() and v37) then
			if (((2374 - (74 + 429)) < (6523 - 3141)) and v20(v78.DemonsBite, not v14:IsInMeleeRange(3 + 2))) then
				return "demons_bite meta 37";
			end
		end
	end
	local function v102()
		v27 = v98();
		if (((2959 - 1666) <= (1533 + 633)) and v27) then
			return v27;
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff) and (v13:BuffRemains(v78.UnboundChaosBuff) < (v91 * (5 - 3)))) or ((6376 - 3797) < (556 - (279 + 154)))) then
			if (v20(v78.FelRush, not v14:IsInRange(793 - (454 + 324))) or ((666 + 180) >= (2385 - (12 + 5)))) then
				return "fel_rush rotation 1";
			end
		end
		if (v78.FelBarrage:IsAvailable() or ((2164 + 1848) <= (8556 - 5198))) then
			v87 = v78.FelBarrage:IsAvailable() and (v78.FelBarrage:CooldownRemains() < (v91 * (3 + 4))) and (((v84 >= (1095 - (277 + 816))) and ((v78.Metamorphosis:CooldownRemains() > (0 - 0)) or (v84 > (1185 - (1058 + 125))))) or v13:BuffUp(v78.FelBarrageBuff));
		end
		if (((281 + 1213) <= (3980 - (815 + 160))) and (v78.EyeBeam:CooldownUp() or v78.Metamorphosis:CooldownUp()) and (v9.CombatTime() < (64 - 49))) then
			local v145 = 0 - 0;
			while true do
				if ((v145 == (0 + 0)) or ((9093 - 5982) == (4032 - (41 + 1857)))) then
					v27 = v99();
					if (((4248 - (1222 + 671)) == (6086 - 3731)) and v27) then
						return v27;
					end
					break;
				end
			end
		end
		if (v87 or ((844 - 256) <= (1614 - (229 + 953)))) then
			v27 = v100();
			if (((6571 - (1111 + 663)) >= (5474 - (874 + 705))) and v27) then
				return v27;
			end
		end
		if (((501 + 3076) == (2441 + 1136)) and v78.ImmolationAura:IsCastable() and v44 and (v84 > (3 - 1)) and v78.Ragefire:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (not v78.FelBarrage:IsAvailable() or (v78.FelBarrage:CooldownRemains() > v78.ImmolationAura:Recharge())) and v14:DebuffDown(v78.EssenceBreakDebuff)) then
			if (((107 + 3687) > (4372 - (642 + 37))) and v20(v78.ImmolationAura, not v14:IsInRange(2 + 6))) then
				return "immolation_aura rotation 3";
			end
		end
		if ((v78.ImmolationAura:IsCastable() and v44 and (v84 > (1 + 1)) and v78.Ragefire:IsAvailable() and v14:DebuffDown(v78.EssenceBreakDebuff)) or ((3201 - 1926) == (4554 - (233 + 221)))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(18 - 10)) or ((1401 + 190) >= (5121 - (718 + 823)))) then
				return "immolation_aura rotation 5";
			end
		end
		if (((619 + 364) <= (2613 - (266 + 539))) and v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff) and (v84 > (5 - 3)) and (not v78.Inertia:IsAvailable() or ((v78.EyeBeam:CooldownRemains() + (1227 - (636 + 589))) > v13:BuffRemains(v78.UnboundChaosBuff)))) then
			if (v20(v78.FelRush, not v14:IsInRange(35 - 20)) or ((4434 - 2284) <= (949 + 248))) then
				return "fel_rush rotation 7";
			end
		end
		if (((1370 + 2399) >= (2188 - (657 + 358))) and v78.VengefulRetreat:IsCastable() and v47 and v31 and v78.Felblade:IsCastable() and v78.Initiative:IsAvailable() and (((v78.EyeBeam:CooldownRemains() > (39 - 24)) and (v13:GCDRemains() < (0.3 - 0))) or ((v13:GCDRemains() < (1187.1 - (1151 + 36))) and (v78.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and ((v78.Metamorphosis:CooldownRemains() > (10 + 0)) or (v78.BladeDance:CooldownRemains() < (v91 * (1 + 1)))))) and (v9.CombatTime() > (11 - 7))) then
			if (((3317 - (1552 + 280)) == (2319 - (64 + 770))) and v20(v78.VengefulRetreat, not v14:IsInRange(6 + 2), true, true)) then
				return "vengeful_retreat rotation 9";
			end
		end
		if (v87 or (not v78.DemonBlades:IsAvailable() and v78.FelBarrage:IsAvailable() and (v13:BuffUp(v78.FelBarrageBuff) or (v78.FelBarrage:CooldownRemains() > (0 - 0))) and v13:BuffDown(v78.MetamorphosisBuff)) or ((589 + 2726) <= (4025 - (157 + 1086)))) then
			local v146 = 0 - 0;
			while true do
				if ((v146 == (0 - 0)) or ((1343 - 467) >= (4045 - 1081))) then
					v27 = v100();
					if (v27 or ((3051 - (599 + 220)) > (4972 - 2475))) then
						return v27;
					end
					break;
				end
			end
		end
		if (v13:BuffUp(v78.MetamorphosisBuff) or ((4041 - (1813 + 118)) <= (243 + 89))) then
			v27 = v101();
			if (((4903 - (841 + 376)) > (4444 - 1272)) and v27) then
				return v27;
			end
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v13:BuffUp(v78.UnboundChaosBuff) and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and (v78.BladeDance:CooldownRemains() < (1 + 3)) and (v78.EyeBeam:CooldownRemains() > (13 - 8)) and ((v78.ImmolationAura:Charges() > (859 - (464 + 395))) or ((v78.ImmolationAura:Recharge() + (5 - 3)) < v78.EyeBeam:CooldownRemains()) or (v78.EyeBeam:CooldownRemains() > (v13:BuffRemains(v78.UnboundChaosBuff) - (1 + 1))))) or ((5311 - (467 + 370)) < (1694 - 874))) then
			if (((3142 + 1137) >= (9879 - 6997)) and v20(v78.FelRush, not v14:IsInRange(3 + 12))) then
				return "fel_rush rotation 11";
			end
		end
		if ((v78.FelRush:IsReady() and v42 and v31 and v78.Momentum:IsAvailable() and (v78.EyeBeam:CooldownRemains() < (v91 * (4 - 2)))) or ((2549 - (150 + 370)) >= (4803 - (74 + 1208)))) then
			if (v20(v78.FelRush, not v14:IsInRange(36 - 21)) or ((9660 - 7623) >= (3304 + 1338))) then
				return "fel_rush rotation 13";
			end
		end
		if (((2110 - (14 + 376)) < (7731 - 3273)) and v78.ImmolationAura:IsCastable() and v44 and v13:BuffDown(v78.UnboundChaosBuff) and (v78.ImmolationAura:FullRechargeTime() < (v91 * (2 + 0))) and (v93 > v78.ImmolationAura:FullRechargeTime())) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(8 + 0)) or ((416 + 20) > (8851 - 5830))) then
				return "immolation_aura rotation 15";
			end
		end
		if (((537 + 176) <= (925 - (23 + 55))) and v78.ImmolationAura:IsCastable() and v44 and (v84 > (4 - 2)) and v13:BuffDown(v78.UnboundChaosBuff)) then
			if (((1438 + 716) <= (3620 + 411)) and v20(v78.ImmolationAura, not v14:IsInRange(11 - 3))) then
				return "immolation_aura rotation 17";
			end
		end
		if (((1452 + 3163) == (5516 - (652 + 249))) and v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.UnboundChaosBuff) and (v78.EyeBeam:CooldownRemains() < (13 - 8))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(1876 - (708 + 1160))) or ((10287 - 6497) == (911 - 411))) then
				return "immolation_aura rotation 19";
			end
		end
		if (((116 - (10 + 17)) < (50 + 171)) and v78.ImmolationAura:IsCastable() and v44 and v78.Inertia:IsAvailable() and v13:BuffDown(v78.InertiaBuff) and v13:BuffDown(v78.UnboundChaosBuff) and ((v78.ImmolationAura:Recharge() + (1737 - (1400 + 332))) < v78.EyeBeam:CooldownRemains()) and (v78.BladeDance:CooldownRemains() > (0 - 0)) and (v78.BladeDance:CooldownRemains() < (1912 - (242 + 1666))) and (v78.ImmolationAura:ChargesFractional() > (1 + 0))) then
			if (((753 + 1301) >= (1212 + 209)) and v20(v78.ImmolationAura, not v14:IsInRange(948 - (850 + 90)))) then
				return "immolation_aura rotation 21";
			end
		end
		if (((1211 - 519) < (4448 - (360 + 1030))) and v78.ImmolationAura:IsCastable() and v44 and (v93 < (14 + 1)) and (v78.BladeDance:CooldownRemains() > (0 - 0))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(10 - 2)) or ((4915 - (909 + 752)) == (2878 - (109 + 1114)))) then
				return "immolation_aura rotation 23";
			end
		end
		if ((v78.EyeBeam:IsCastable() and v39 and not v78.EssenceBreak:IsAvailable() and (not v78.ChaoticTransformation:IsAvailable() or (v78.Metamorphosis:CooldownRemains() < ((9 - 4) + ((2 + 1) * v23(v78.ShatteredDestiny:IsAvailable())))) or (v78.Metamorphosis:CooldownRemains() > (257 - (6 + 236))))) or ((817 + 479) == (3953 + 957))) then
			if (((7942 - 4574) == (5882 - 2514)) and v20(v78.EyeBeam, not v14:IsInRange(1141 - (1076 + 57)))) then
				return "eye_beam rotation 25";
			end
		end
		if (((435 + 2208) < (4504 - (579 + 110))) and ((v78.EyeBeam:IsCastable() and v39 and v78.EssenceBreak:IsAvailable() and ((v78.EssenceBreak:CooldownRemains() < ((v91 * (1 + 1)) + ((5 + 0) * v23(v78.ShatteredDestiny:IsAvailable())))) or (v78.ShatteredDestiny:IsAvailable() and (v78.EssenceBreak:CooldownRemains() > (6 + 4)))) and ((v78.BladeDance:CooldownRemains() < (414 - (174 + 233))) or (v84 > (2 - 1))) and (not v78.Initiative:IsAvailable() or (v78.VengefulRetreat:CooldownRemains() > (17 - 7)) or (v84 > (1 + 0))) and (not v78.Inertia:IsAvailable() or v13:BuffUp(v78.UnboundChaosBuff) or ((v78.ImmolationAura:Charges() == (1174 - (663 + 511))) and (v78.ImmolationAura:Recharge() > (5 + 0))))) or (v93 < (3 + 7)))) then
			if (((5897 - 3984) > (299 + 194)) and v20(v78.EyeBeam, not v14:IsInRange(18 - 10))) then
				return "eye_beam rotation 27";
			end
		end
		if (((11510 - 6755) > (1636 + 1792)) and v78.BladeDance:IsCastable() and v33 and ((v78.EyeBeam:CooldownRemains() > v91) or v78.EyeBeam:CooldownUp())) then
			if (((2687 - 1306) <= (1689 + 680)) and v20(v78.BladeDance, not v14:IsInRange(1 + 4))) then
				return "blade_dance rotation 29";
			end
		end
		if ((v78.GlaiveTempest:IsCastable() and v43 and (v84 >= (724 - (478 + 244)))) or ((5360 - (440 + 77)) == (1857 + 2227))) then
			if (((17088 - 12419) > (1919 - (655 + 901))) and v20(v78.GlaiveTempest, not v14:IsInRange(2 + 6))) then
				return "glaive_tempest rotation 31";
			end
		end
		if ((v45 and (v84 > (3 + 0)) and v78.SigilOfFlame:IsCastable()) or ((1268 + 609) >= (12641 - 9503))) then
			if (((6187 - (695 + 750)) >= (12381 - 8755)) and ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(12 - 4)) or ((18258 - 13718) == (1267 - (285 + 66)))) then
					return "sigil_of_flame rotation 33";
				end
			elseif ((v77 == "cursor") or ((2694 - 1538) > (5655 - (682 + 628)))) then
				if (((361 + 1876) < (4548 - (176 + 123))) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(17 + 23))) then
					return "sigil_of_flame rotation 33";
				end
			end
		end
		if ((v78.ChaosStrike:IsCastable() and v34 and v14:DebuffUp(v78.EssenceBreakDebuff)) or ((1947 + 736) < (292 - (239 + 30)))) then
			if (((190 + 507) <= (794 + 32)) and v20(v78.ChaosStrike, not v14:IsInMeleeRange(8 - 3))) then
				return "chaos_strike rotation 35";
			end
		end
		if (((3447 - 2342) <= (1491 - (306 + 9))) and v78.Felblade:IsCastable() and v41) then
			if (((11791 - 8412) <= (663 + 3149)) and v20(v78.Felblade, not v14:IsInMeleeRange(4 + 1))) then
				return "felblade rotation 37";
			end
		end
		if ((v78.ThrowGlaive:IsCastable() and v46 and (v78.ThrowGlaive:FullRechargeTime() <= v78.BladeDance:CooldownRemains()) and (v78.Metamorphosis:CooldownRemains() > (3 + 2)) and v78.Soulscar:IsAvailable() and v13:HasTier(88 - 57, 1377 - (1140 + 235)) and not v13:PrevGCDP(1 + 0, v78.VengefulRetreat)) or ((723 + 65) >= (415 + 1201))) then
			if (((1906 - (33 + 19)) <= (1221 + 2158)) and v20(v78.ThrowGlaive, not v14:IsInMeleeRange(89 - 59))) then
				return "throw_glaive rotation 39";
			end
		end
		if (((2004 + 2545) == (8920 - 4371)) and v78.ThrowGlaive:IsCastable() and v46 and not v13:HasTier(30 + 1, 691 - (586 + 103)) and ((v84 > (1 + 0)) or v78.Soulscar:IsAvailable()) and not v13:PrevGCDP(2 - 1, v78.VengefulRetreat)) then
			if (v20(v78.ThrowGlaive, not v14:IsInMeleeRange(1518 - (1309 + 179))) or ((5454 - 2432) >= (1317 + 1707))) then
				return "throw_glaive rotation 41";
			end
		end
		if (((12944 - 8124) > (1661 + 537)) and v78.ChaosStrike:IsCastable() and v34 and ((v78.EyeBeam:CooldownRemains() > (v91 * (3 - 1))) or (v13:Fury() > (159 - 79)))) then
			if (v20(v78.ChaosStrike, not v14:IsInMeleeRange(614 - (295 + 314))) or ((2605 - 1544) >= (6853 - (1300 + 662)))) then
				return "chaos_strike rotation 43";
			end
		end
		if (((4283 - 2919) <= (6228 - (1178 + 577))) and v78.ImmolationAura:IsCastable() and v44 and not v78.Inertia:IsAvailable() and (v84 > (2 + 0))) then
			if (v20(v78.ImmolationAura, not v14:IsInRange(23 - 15)) or ((5000 - (851 + 554)) <= (3 + 0))) then
				return "immolation_aura rotation 45";
			end
		end
		if ((v45 and not v14:IsInRange(22 - 14) and v14:DebuffDown(v78.EssenceBreakDebuff) and (not v78.FelBarrage:IsAvailable() or (v78.FelBarrage:CooldownRemains() > (54 - 29))) and v78.SigilOfFlame:IsCastable()) or ((4974 - (115 + 187)) == (2950 + 902))) then
			if (((1476 + 83) == (6143 - 4584)) and ((v77 == "player") or (v78.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
				if (v20(v80.SigilOfFlamePlayer, not v14:IsInRange(1169 - (160 + 1001))) or ((1533 + 219) <= (544 + 244))) then
					return "sigil_of_flame rotation 47";
				end
			elseif ((v77 == "cursor") or ((7997 - 4090) == (535 - (237 + 121)))) then
				if (((4367 - (525 + 372)) > (1051 - 496)) and v20(v80.SigilOfFlameCursor, not v14:IsInRange(131 - 91))) then
					return "sigil_of_flame rotation 47";
				end
			end
		end
		if ((v78.DemonsBite:IsCastable() and v37) or ((1114 - (96 + 46)) == (1422 - (643 + 134)))) then
			if (((1149 + 2033) >= (5071 - 2956)) and v20(v78.DemonsBite, not v14:IsInMeleeRange(18 - 13))) then
				return "demons_bite rotation 49";
			end
		end
		if (((3734 + 159) < (8691 - 4262)) and v78.FelRush:IsReady() and v42 and v31 and v13:BuffDown(v78.UnboundChaosBuff) and (v78.FelRush:Recharge() < v78.EyeBeam:CooldownRemains()) and v14:DebuffDown(v78.EssenceBreakDebuff) and ((v78.EyeBeam:CooldownRemains() > (16 - 8)) or (v78.FelRush:ChargesFractional() > (720.01 - (316 + 403))))) then
			if (v20(v78.FelRush, not v14:IsInRange(10 + 5)) or ((7882 - 5015) < (689 + 1216))) then
				return "fel_rush rotation 51";
			end
		end
		if ((v78.ArcaneTorrent:IsCastable() and not v13:IsMoving() and v14:IsInRange(20 - 12) and v14:DebuffDown(v78.EssenceBreakDebuff) and (v13:Fury() < (71 + 29))) or ((579 + 1217) >= (14036 - 9985))) then
			if (((7732 - 6113) <= (7802 - 4046)) and v20(v78.ArcaneTorrent, not v14:IsInRange(1 + 7))) then
				return "arcane_torrent rotation 53";
			end
		end
	end
	local function v103()
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
		v59 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
	end
	local function v104()
		local v134 = 0 + 0;
		while true do
			if (((1776 - 1172) == (621 - (12 + 5))) and (v134 == (7 - 5))) then
				v60 = EpicSettings.Settings['useBlur'];
				v61 = EpicSettings.Settings['useNetherwalk'];
				v134 = 5 - 2;
			end
			if (((1 - 0) == v134) or ((11119 - 6635) == (183 + 717))) then
				v50 = EpicSettings.Settings['useFelEruption'];
				v51 = EpicSettings.Settings['useSigilOfMisery'];
				v134 = 1975 - (1656 + 317);
			end
			if ((v134 == (0 + 0)) or ((3574 + 885) <= (2959 - 1846))) then
				v48 = EpicSettings.Settings['useChaosNova'];
				v49 = EpicSettings.Settings['useDisrupt'];
				v134 = 4 - 3;
			end
			if (((3986 - (5 + 349)) > (16139 - 12741)) and (v134 == (1274 - (266 + 1005)))) then
				v62 = EpicSettings.Settings['blurHP'] or (0 + 0);
				v63 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
				v134 = 4 - 0;
			end
			if (((5778 - (561 + 1135)) <= (6407 - 1490)) and (v134 == (12 - 8))) then
				v77 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
		end
	end
	local function v105()
		v69 = EpicSettings.Settings['fightRemainsCheck'] or (1066 - (507 + 559));
		v64 = EpicSettings.Settings['dispelBuffs'];
		v66 = EpicSettings.Settings['InterruptWithStun'];
		v67 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v68 = EpicSettings.Settings['InterruptThreshold'];
		v70 = EpicSettings.Settings['useTrinkets'];
		v71 = EpicSettings.Settings['trinketsWithCD'];
		v73 = EpicSettings.Settings['useHealthstone'];
		v72 = EpicSettings.Settings['useHealingPotion'];
		v75 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v74 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v76 = EpicSettings.Settings['HealingPotionName'] or "";
		v65 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v106()
		local v144 = 388 - (212 + 176);
		while true do
			if (((5737 - (250 + 655)) >= (3779 - 2393)) and (v144 == (8 - 3))) then
				if (((214 - 77) == (2093 - (1869 + 87))) and v65) then
					local v157 = 0 - 0;
					while true do
						if ((v157 == (1901 - (484 + 1417))) or ((3365 - 1795) >= (7259 - 2927))) then
							v27 = v22.HandleIncorporeal(v78.Imprison, v80.ImprisonMouseover, 803 - (48 + 725), true);
							if (v27 or ((6638 - 2574) <= (4879 - 3060))) then
								return v27;
							end
							break;
						end
					end
				end
				if (v13:PrevGCDP(1 + 0, v78.VengefulRetreat) or v13:PrevGCDP(4 - 2, v78.VengefulRetreat) or (v13:PrevGCDP(1 + 2, v78.VengefulRetreat) and v13:IsMoving()) or ((1454 + 3532) < (2427 - (152 + 701)))) then
					if (((5737 - (430 + 881)) > (66 + 106)) and v78.Felblade:IsCastable() and v41) then
						if (((1481 - (557 + 338)) > (135 + 320)) and v20(v78.Felblade, not v14:IsSpellInRange(v78.Felblade))) then
							return "felblade rotation 1";
						end
					end
				elseif (((2327 - 1501) == (2892 - 2066)) and v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					if ((not v13:AffectingCombat() and v28) or ((10677 - 6658) > (9570 - 5129))) then
						v27 = v97();
						if (((2818 - (499 + 302)) < (5127 - (39 + 827))) and v27) then
							return v27;
						end
					end
					if (((13018 - 8302) > (178 - 98)) and v78.ConsumeMagic:IsAvailable() and v35 and v78.ConsumeMagic:IsReady() and v64 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) then
						if (v20(v78.ConsumeMagic, not v14:IsSpellInRange(v78.ConsumeMagic)) or ((13929 - 10422) == (5022 - 1750))) then
							return "greater_purge damage";
						end
					end
					if ((v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v94, v14:NPCID())) or ((75 + 801) >= (9000 - 5925))) then
						if (((697 + 3655) > (4040 - 1486)) and v20(v78.ThrowGlaive, not v14:IsSpellInRange(v78.ThrowGlaive))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v78.ThrowGlaive:IsReady() and v46 and v12.ValueIsInArray(v94, v15:NPCID())) or ((4510 - (103 + 1)) < (4597 - (475 + 79)))) then
						if (v20(v80.ThrowGlaiveMouseover, not v14:IsSpellInRange(v78.ThrowGlaive)) or ((4083 - 2194) >= (10825 - 7442))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v27 = v102();
					if (((245 + 1647) <= (2407 + 327)) and v27) then
						return v27;
					end
				end
				break;
			end
			if (((3426 - (1395 + 108)) < (6454 - 4236)) and (v144 == (1205 - (7 + 1197)))) then
				v28 = EpicSettings.Toggles['ooc'];
				v29 = EpicSettings.Toggles['aoe'];
				v30 = EpicSettings.Toggles['cds'];
				v144 = 1 + 1;
			end
			if (((759 + 1414) > (698 - (27 + 292))) and (v144 == (5 - 3))) then
				v31 = EpicSettings.Toggles['movement'];
				if (v13:IsDeadOrGhost() or ((3304 - 713) == (14296 - 10887))) then
					return v27;
				end
				v82 = v13:GetEnemiesInMeleeRange(15 - 7);
				v144 = 5 - 2;
			end
			if (((4653 - (43 + 96)) > (13558 - 10234)) and ((0 - 0) == v144)) then
				v104();
				v103();
				v105();
				v144 = 1 + 0;
			end
			if ((v144 == (2 + 2)) or ((410 - 202) >= (1851 + 2977))) then
				if (v22.TargetIsValid() or v13:AffectingCombat() or ((2966 - 1383) > (1123 + 2444))) then
					local v158 = 0 + 0;
					while true do
						if ((v158 == (1751 - (1414 + 337))) or ((3253 - (1642 + 298)) == (2069 - 1275))) then
							v92 = v9.BossFightRemains(nil, true);
							v93 = v92;
							v158 = 2 - 1;
						end
						if (((9419 - 6245) > (956 + 1946)) and (v158 == (1 + 0))) then
							if (((5092 - (357 + 615)) <= (2991 + 1269)) and (v93 == (27263 - 16152))) then
								v93 = v9.FightRemains(v82, false);
							end
							break;
						end
					end
				end
				v27 = v96();
				if (v27 or ((757 + 126) > (10239 - 5461))) then
					return v27;
				end
				v144 = 4 + 1;
			end
			if ((v144 == (1 + 2)) or ((2276 + 1344) >= (6192 - (384 + 917)))) then
				v83 = v13:GetEnemiesInMeleeRange(717 - (128 + 569));
				if (((5801 - (1407 + 136)) > (2824 - (687 + 1200))) and v29) then
					local v159 = 1710 - (556 + 1154);
					while true do
						if ((v159 == (0 - 0)) or ((4964 - (9 + 86)) < (1327 - (275 + 146)))) then
							v84 = ((#v82 > (0 + 0)) and #v82) or (65 - (29 + 35));
							v85 = #v83;
							break;
						end
					end
				else
					v84 = 4 - 3;
					v85 = 2 - 1;
				end
				v91 = v13:GCD() + (0.05 - 0);
				v144 = 3 + 1;
			end
		end
	end
	local function v107()
		v78.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1589 - (53 + 959), v106, v107);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

