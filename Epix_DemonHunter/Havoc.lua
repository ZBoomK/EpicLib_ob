local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3011 - (409 + 103)) == (2735 - (46 + 190))) and (v5 == (95 - (51 + 44)))) then
			v6 = v0[v4];
			if (not v6 or ((637 + 1618) < (1339 - (1114 + 203)))) then
				return v1(v4, ...);
			end
			v5 = 727 - (228 + 498);
		end
		if ((v5 == (1 + 0)) or ((600 + 486) >= (2068 - (174 + 489)))) then
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
	local v83, v84;
	local v85, v86;
	local v87 = {{v79.FelEruption},{v79.ChaosNova}};
	local v88 = false;
	local v89 = false;
	local v90 = 0 + 0;
	local v91 = 1162 - (171 + 991);
	local v92 = v14:GCD() + (0.25 - 0);
	local v93 = 29835 - 18724;
	local v94 = 27726 - 16615;
	local v95 = {(593881 - 424460),(273107 - 103682),(170180 - (111 + 1137)),(504254 - 334828),(169952 - (423 + 100)),(469121 - 299693),(170201 - (326 + 445))};
	v10:RegisterForEvent(function()
		v88 = false;
		v93 = 48488 - 37377;
		v94 = 24753 - 13642;
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		local v109 = 0 - 0;
		while true do
			if (((712 - (530 + 181)) == v109) or ((3250 - (614 + 267)) == (458 - (19 + 13)))) then
				v28 = v23.HandleBottomTrinket(v82, v31, 65 - 25, nil);
				if (v28 or ((7167 - 4091) > (9092 - 5909))) then
					return v28;
				end
				break;
			end
			if (((313 + 889) > (1860 - 802)) and (v109 == (0 - 0))) then
				v28 = v23.HandleTopTrinket(v82, v31, 1852 - (1293 + 519), nil);
				if (((7571 - 3860) > (8759 - 5404)) and v28) then
					return v28;
				end
				v109 = 1 - 0;
			end
		end
	end
	local function v97()
		local v110 = 0 - 0;
		while true do
			if ((v110 == (2 - 1)) or ((480 + 426) >= (455 + 1774))) then
				if (((2992 - 1704) > (290 + 961)) and v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) then
					if (v21(v81.Healthstone) or ((1500 + 3013) < (2095 + 1257))) then
						return "healthstone defensive";
					end
				end
				if ((v73 and (v14:HealthPercentage() <= v75)) or ((3161 - (709 + 387)) >= (5054 - (673 + 1185)))) then
					local v161 = 0 - 0;
					while true do
						if ((v161 == (0 - 0)) or ((7199 - 2823) <= (1060 + 421))) then
							if ((v77 == "Refreshing Healing Potion") or ((2535 + 857) >= (6400 - 1659))) then
								if (((817 + 2508) >= (4294 - 2140)) and v80.RefreshingHealingPotion:IsReady()) then
									if (v21(v81.RefreshingHealingPotion) or ((2541 - 1246) >= (5113 - (446 + 1434)))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((5660 - (1040 + 243)) > (4900 - 3258)) and (v77 == "Dreamwalker's Healing Potion")) then
								if (((6570 - (559 + 1288)) > (3287 - (609 + 1322))) and v80.DreamwalkersHealingPotion:IsReady()) then
									if (v21(v81.RefreshingHealingPotion) or ((4590 - (13 + 441)) <= (12828 - 9395))) then
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
			if (((11119 - 6874) <= (23064 - 18433)) and (v110 == (0 + 0))) then
				if (((15529 - 11253) >= (1391 + 2523)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
					if (((87 + 111) <= (12953 - 8588)) and v21(v79.Blur)) then
						return "blur defensive";
					end
				end
				if (((2617 + 2165) > (8599 - 3923)) and v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) then
					if (((3216 + 1648) > (1222 + 975)) and v21(v79.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v110 = 1 + 0;
			end
		end
	end
	local function v98()
		local v111 = 0 + 0;
		while true do
			if ((v111 == (2 + 0)) or ((4133 - (153 + 280)) == (7238 - 4731))) then
				if (((4017 + 457) >= (109 + 165)) and not v15:IsInMeleeRange(3 + 2) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(1 + 0, v79.Felblade))) and v32 and v43) then
					if (v21(v79.FelRush, not v15:IsInRange(11 + 4)) or ((2883 - 989) <= (869 + 537))) then
						return "fel_rush precombat 10";
					end
				end
				if (((2239 - (89 + 578)) >= (1094 + 437)) and v15:IsInMeleeRange(10 - 5) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(1054 - (572 + 477))) or ((633 + 4054) < (2726 + 1816))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if (((393 + 2898) > (1753 - (84 + 2))) and (v111 == (1 - 0))) then
				if ((not v15:IsInMeleeRange(4 + 1) and v79.Felblade:IsCastable() and v42) or ((1715 - (497 + 345)) == (53 + 1981))) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((477 + 2339) < (1344 - (605 + 728)))) then
						return "felblade precombat 9";
					end
				end
				if (((2640 + 1059) < (10462 - 5756)) and not v15:IsInMeleeRange(1 + 4) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(3 - 2, v79.VengefulRetreat)) then
					if (((2386 + 260) >= (2426 - 1550)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
						return "throw_glaive precombat 9";
					end
				end
				v111 = 2 + 0;
			end
			if (((1103 - (457 + 32)) <= (1351 + 1833)) and (v111 == (1402 - (832 + 570)))) then
				if (((2945 + 181) == (816 + 2310)) and v79.ImmolationAura:IsCastable() and v45) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(28 - 20)) or ((1054 + 1133) >= (5750 - (588 + 208)))) then
						return "immolation_aura precombat 8";
					end
				end
				if ((v46 and not v14:IsMoving() and (v85 > (2 - 1)) and v79.SigilOfFlame:IsCastable()) or ((5677 - (884 + 916)) == (7484 - 3909))) then
					if (((410 + 297) > (1285 - (232 + 421))) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1897 - (1569 + 320))) or ((134 + 412) >= (510 + 2174))) then
							return "sigil_of_flame precombat 9";
						end
					elseif (((4936 - 3471) <= (4906 - (316 + 289))) and (v78 == "cursor")) then
						if (((4460 - 2756) > (66 + 1359)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1493 - (666 + 787)))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v111 = 426 - (360 + 65);
			end
		end
	end
	local function v99()
		local v112 = 0 + 0;
		local v113;
		while true do
			if ((v112 == (256 - (79 + 175))) or ((1082 - 395) == (3304 + 930))) then
				if ((((v31 and v58) or not v58) and v32 and v79.TheHunt:IsCastable() and v55 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v10.CombatTime() > (15 - 10))) or ((6413 - 3083) < (2328 - (503 + 396)))) then
					if (((1328 - (92 + 89)) >= (649 - 314)) and v21(v79.TheHunt, not v15:IsInRange(21 + 19))) then
						return "the_hunt cooldown 4";
					end
				end
				if (((2033 + 1402) > (8211 - 6114)) and v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v85 > v60)) then
					if ((v59 == "player") or ((516 + 3254) >= (9213 - 5172))) then
						if (v21(v81.ElysianDecreePlayer, not v15:IsInRange(7 + 1)) or ((1811 + 1980) <= (4906 - 3295))) then
							return "elysian_decree cooldown 6 (Player)";
						end
					elseif ((v59 == "cursor") or ((572 + 4006) <= (3062 - 1054))) then
						if (((2369 - (485 + 759)) <= (4803 - 2727)) and v21(v81.ElysianDecreeCursor, not v15:IsInRange(1219 - (442 + 747)))) then
							return "elysian_decree cooldown 6 (Cursor)";
						end
					end
				end
				break;
			end
			if (((1136 - (832 + 303)) == v112) or ((1689 - (88 + 858)) >= (1341 + 3058))) then
				if (((956 + 199) < (69 + 1604)) and v113) then
					return v113;
				end
				if ((v70 < v94) or ((3113 - (766 + 23)) <= (2853 - 2275))) then
					if (((5151 - 1384) == (9924 - 6157)) and v71 and ((v31 and v72) or not v72)) then
						v28 = v96();
						if (((13878 - 9789) == (5162 - (1036 + 37))) and v28) then
							return v28;
						end
					end
				end
				v112 = 2 + 0;
			end
			if (((8681 - 4223) >= (1317 + 357)) and ((1480 - (641 + 839)) == v112)) then
				if (((1885 - (910 + 3)) <= (3614 - 2196)) and ((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and (((not v79.Demonic:IsAvailable() or (v14:BuffRemains(v79.MetamorphosisBuff) < v14:GCD())) and (v79.EyeBeam:CooldownRemains() > (1684 - (1466 + 218))) and (not v79.EssenceBreak:IsAvailable() or v15:DebuffUp(v79.EssenceBreakDebuff)) and v14:BuffDown(v79.FelBarrageBuff)) or not v79.ChaoticTransformation:IsAvailable() or (v94 < (14 + 16)))) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(1156 - (556 + 592))) or ((1756 + 3182) < (5570 - (329 + 479)))) then
						return "metamorphosis cooldown 2";
					end
				end
				v113 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				v112 = 855 - (174 + 680);
			end
		end
	end
	local function v100()
		local v114 = 0 - 0;
		while true do
			if ((v114 == (1 - 0)) or ((1788 + 716) > (5003 - (396 + 343)))) then
				if (((191 + 1962) == (3630 - (29 + 1448))) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (not v79.ChaoticTransformation:IsAvailable() or v79.Metamorphosis:CooldownUp())) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(1394 - (135 + 1254))) or ((1909 - 1402) >= (12097 - 9506))) then
						return "annihilation opener 5";
					end
				end
				if (((2987 + 1494) == (6008 - (389 + 1138))) and v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff) and (not v14:BuffUp(v79.MetamorphosisBuff) or (v79.BladeDance:CooldownRemains() > (574 - (102 + 472))))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(8 + 0)) or ((1291 + 1037) < (647 + 46))) then
						return "eye_beam opener 6";
					end
				end
				if (((5873 - (320 + 1225)) == (7704 - 3376)) and v79.FelRush:IsReady() and v43 and v32 and v79.Inertia:IsAvailable() and (v14:BuffDown(v79.InertiaBuff) or (v85 > (2 + 0))) and v14:BuffUp(v79.UnboundChaosBuff)) then
					if (((3052 - (157 + 1307)) >= (3191 - (821 + 1038))) and v21(v79.FelRush, not v15:IsInRange(37 - 22))) then
						return "fel_rush opener 7";
					end
				end
				if ((v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32) or ((457 + 3717) > (7545 - 3297))) then
					if (v21(v79.TheHunt, not v15:IsInRange(15 + 25)) or ((11366 - 6780) <= (1108 - (834 + 192)))) then
						return "the_hunt opener 8";
					end
				end
				v114 = 1 + 1;
			end
			if (((992 + 2871) == (83 + 3780)) and ((0 - 0) == v114)) then
				if ((v79.VengefulRetreat:IsCastable() and v48 and v32 and v14:PrevGCDP(305 - (300 + 4), v79.DeathSweep) and (v79.Felblade:CooldownRemains() == (0 + 0))) or ((738 - 456) <= (404 - (112 + 250)))) then
					if (((1838 + 2771) >= (1918 - 1152)) and v21(v79.VengefulRetreat, not v15:IsInRange(5 + 3), true, true)) then
						return "vengeful_retreat opener 1";
					end
				end
				if ((v79.Metamorphosis:IsCastable() and v54 and ((v31 and v57) or not v57) and (v14:PrevGCDP(1 + 0, v79.DeathSweep) or (not v79.ChaoticTransformation:IsAvailable() and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (2 + 0)))) or not v79.Demonic:IsAvailable())) or ((572 + 580) == (1849 + 639))) then
					if (((4836 - (1001 + 413)) > (7470 - 4120)) and v21(v81.MetamorphosisPlayer, not v15:IsInRange(890 - (244 + 638)))) then
						return "metamorphosis opener 2";
					end
				end
				if (((1570 - (627 + 66)) > (1120 - 744)) and v79.Felblade:IsCastable() and v42 and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((3720 - (512 + 90)) <= (3757 - (1665 + 241)))) then
						return "felblade opener 3";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v79.ImmolationAura:Charges() == (719 - (373 + 344))) and v14:BuffDown(v79.UnboundChaosBuff) and (v14:BuffDown(v79.InertiaBuff) or (v85 > (1 + 1)))) or ((44 + 121) >= (9210 - 5718))) then
					if (((6682 - 2733) < (5955 - (35 + 1064))) and v21(v79.ImmolationAura, not v15:IsInRange(6 + 2))) then
						return "immolation_aura opener 4";
					end
				end
				v114 = 2 - 1;
			end
			if ((v114 == (1 + 1)) or ((5512 - (298 + 938)) < (4275 - (233 + 1026)))) then
				if (((6356 - (636 + 1030)) > (2109 + 2016)) and v79.EssenceBreak:IsCastable() and v39) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(5 + 0)) or ((15 + 35) >= (61 + 835))) then
						return "essence_break opener 9";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37) or ((1935 - (55 + 166)) >= (574 + 2384))) then
					if (v21(v79.DeathSweep, not v15:IsInMeleeRange(1 + 4)) or ((5694 - 4203) < (941 - (36 + 261)))) then
						return "death_sweep opener 10";
					end
				end
				if (((1231 - 527) < (2355 - (34 + 1334))) and v79.Annihilation:IsCastable() and v33) then
					if (((1430 + 2288) > (1481 + 425)) and v21(v79.Annihilation, not v15:IsInMeleeRange(1288 - (1035 + 248)))) then
						return "annihilation opener 11";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38) or ((979 - (20 + 1)) > (1894 + 1741))) then
					if (((3820 - (134 + 185)) <= (5625 - (549 + 584))) and v21(v79.DemonsBite, not v15:IsInMeleeRange(690 - (314 + 371)))) then
						return "demons_bite opener 12";
					end
				end
				break;
			end
		end
	end
	local function v101()
		v89 = (v79.Felblade:CooldownRemains() < v92) or (v79.SigilOfFlame:CooldownRemains() < v92);
		v90 = (((3 - 2) % ((970.6 - (478 + 490)) * v14:AttackHaste())) * (7 + 5)) + (v14:BuffStack(v79.ImmolationAuraBuff) * (1178 - (786 + 386))) + (v24(v14:BuffUp(v79.TacticalRetreatBuff)) * (32 - 22));
		v91 = v92 * (1411 - (1055 + 324));
		if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff)) or ((4782 - (1093 + 247)) < (2265 + 283))) then
			if (((303 + 2572) >= (5812 - 4348)) and v21(v79.Annihilation, not v15:IsInMeleeRange(16 - 11))) then
				return "annihilation fel_barrage 1";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and v14:BuffDown(v79.FelBarrageBuff)) or ((13649 - 8852) >= (12295 - 7402))) then
			if (v21(v79.EyeBeam, not v15:IsInRange(3 + 5)) or ((2122 - 1571) > (7127 - 5059))) then
				return "eye_beam fel_barrage 3";
			end
		end
		if (((1595 + 519) > (2413 - 1469)) and v79.EssenceBreak:IsCastable() and v39 and v14:BuffDown(v79.FelBarrageBuff) and v14:BuffUp(v79.MetamorphosisBuff)) then
			if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(693 - (364 + 324))) or ((6200 - 3938) >= (7428 - 4332))) then
				return "essence_break fel_barrage 5";
			end
		end
		if ((v79.DeathSweep:IsCastable() and v37 and v14:BuffDown(v79.FelBarrageBuff)) or ((748 + 1507) >= (14799 - 11262))) then
			if (v21(v79.DeathSweep, not v15:IsInMeleeRange(8 - 3)) or ((11653 - 7816) < (2574 - (1249 + 19)))) then
				return "death_sweep fel_barrage 7";
			end
		end
		if (((2663 + 287) == (11482 - 8532)) and v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and ((v85 > (1088 - (686 + 400))) or v14:BuffUp(v79.FelBarrageBuff))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(7 + 1)) or ((4952 - (73 + 156)) < (16 + 3282))) then
				return "immolation_aura fel_barrage 9";
			end
		end
		if (((1947 - (721 + 90)) >= (2 + 152)) and v79.GlaiveTempest:IsCastable() and v44 and v14:BuffDown(v79.FelBarrageBuff) and (v85 > (3 - 2))) then
			if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(475 - (224 + 246))) or ((438 - 167) > (8741 - 3993))) then
				return "glaive_tempest fel_barrage 11";
			end
		end
		if (((860 + 3880) >= (76 + 3076)) and v79.BladeDance:IsCastable() and v34 and v14:BuffDown(v79.FelBarrageBuff)) then
			if (v21(v79.BladeDance, not v15:IsInMeleeRange(4 + 1)) or ((5125 - 2547) >= (11281 - 7891))) then
				return "blade_dance fel_barrage 13";
			end
		end
		if (((554 - (203 + 310)) <= (3654 - (1238 + 755))) and v79.FelBarrage:IsCastable() and v41 and (v14:Fury() > (7 + 93))) then
			if (((2135 - (709 + 825)) < (6560 - 3000)) and v21(v79.FelBarrage, not v15:IsInMeleeRange(6 - 1))) then
				return "fel_barrage fel_barrage 15";
			end
		end
		if (((1099 - (196 + 668)) < (2712 - 2025)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:Fury() > (41 - 21)) and v14:BuffUp(v79.FelBarrageBuff)) then
			if (((5382 - (171 + 662)) > (1246 - (4 + 89))) and v21(v79.FelRush, not v15:IsInRange(52 - 37))) then
				return "fel_rush fel_barrage 17";
			end
		end
		if ((v46 and v79.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (15 + 25)) and v14:BuffUp(v79.FelBarrageBuff)) or ((20529 - 15855) < (1833 + 2839))) then
			if (((5154 - (35 + 1451)) < (6014 - (28 + 1425))) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(2001 - (941 + 1052))) or ((437 + 18) == (5119 - (822 + 692)))) then
					return "sigil_of_flame fel_barrage 18";
				end
			elseif ((v78 == "cursor") or ((3801 - 1138) == (1561 + 1751))) then
				if (((4574 - (45 + 252)) <= (4428 + 47)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(14 + 26))) then
					return "sigil_of_flame fel_barrage 18";
				end
			end
		end
		if ((v79.Felblade:IsCastable() and v42 and v14:BuffUp(v79.FelBarrageBuff) and (v14:FuryDeficit() > (97 - 57))) or ((1303 - (114 + 319)) == (1706 - 517))) then
			if (((1989 - 436) <= (1998 + 1135)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
				return "felblade fel_barrage 19";
			end
		end
		if ((v79.DeathSweep:IsCastable() and v37 and (((v14:Fury() - v91) - (52 - 17)) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (1966 - (556 + 1407))) or v89 or (v14:Fury() > (1286 - (741 + 465))) or (v90 > (483 - (170 + 295))))) or ((1179 + 1058) >= (3225 + 286))) then
			if (v21(v79.DeathSweep, not v15:IsInMeleeRange(12 - 7)) or ((1098 + 226) > (1937 + 1083))) then
				return "death_sweep fel_barrage 21";
			end
		end
		if ((v79.GlaiveTempest:IsCastable() and v44 and (((v14:Fury() - v91) - (17 + 13)) > (1230 - (957 + 273))) and ((v14:BuffRemains(v79.FelBarrageBuff) < (1 + 2)) or v89 or (v14:Fury() > (33 + 47)) or (v90 > (68 - 50)))) or ((7884 - 4892) == (5745 - 3864))) then
			if (((15379 - 12273) > (3306 - (389 + 1391))) and v21(v79.GlaiveTempest, not v15:IsInMeleeRange(4 + 1))) then
				return "glaive_tempest fel_barrage 23";
			end
		end
		if (((315 + 2708) < (8810 - 4940)) and v79.BladeDance:IsCastable() and v34 and (((v14:Fury() - v91) - (986 - (783 + 168))) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (3 + 0)) or v89 or (v14:Fury() > (391 - (309 + 2))) or (v90 > (55 - 37)))) then
			if (((1355 - (1090 + 122)) > (24 + 50)) and v21(v79.BladeDance, not v15:IsInMeleeRange(16 - 11))) then
				return "blade_dance fel_barrage 25";
			end
		end
		if (((13 + 5) < (3230 - (628 + 490))) and v79.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (8 + 32)) and v14:BuffUp(v79.FelBarrageBuff)) then
			if (((2715 - 1618) <= (7439 - 5811)) and v21(v79.ArcaneTorrent)) then
				return "arcane_torrent fel_barrage 27";
			end
		end
		if (((5404 - (431 + 343)) == (9350 - 4720)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff)) then
			if (((10241 - 6701) > (2120 + 563)) and v21(v79.FelRush, not v15:IsInRange(2 + 13))) then
				return "fel_rush fel_barrage 29";
			end
		end
		if (((6489 - (556 + 1139)) >= (3290 - (6 + 9))) and v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32 and (v14:Fury() > (8 + 32))) then
			if (((761 + 723) == (1653 - (28 + 141))) and v21(v79.TheHunt, not v15:IsInRange(16 + 24))) then
				return "the_hunt fel_barrage 31";
			end
		end
		if (((1767 - 335) < (2518 + 1037)) and v79.DemonsBite:IsCastable() and v38) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(1322 - (486 + 831))) or ((2771 - 1706) > (12596 - 9018))) then
				return "demons_bite fel_barrage 33";
			end
		end
	end
	local function v102()
		if ((v79.DeathSweep:IsCastable() and v37 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) or ((907 + 3888) < (4448 - 3041))) then
			if (((3116 - (668 + 595)) < (4331 + 482)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(2 + 3))) then
				return "death_sweep meta 1";
			end
		end
		if ((v79.Annihilation:IsCastable() and v33 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) or ((7693 - 4872) < (2721 - (23 + 267)))) then
			if (v21(v79.Annihilation, not v15:IsInMeleeRange(1949 - (1129 + 815))) or ((3261 - (371 + 16)) < (3931 - (1326 + 424)))) then
				return "annihilation meta 3";
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable()) or ((5092 - 2403) <= (1253 - 910))) then
			if (v21(v79.FelRush, not v15:IsInRange(133 - (88 + 30))) or ((2640 - (720 + 51)) == (4468 - 2459))) then
				return "fel_rush meta 5";
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v92 * (1778 - (421 + 1355))))) or ((5849 - 2303) < (1141 + 1181))) then
			if (v21(v79.FelRush, not v15:IsInRange(1098 - (286 + 797))) or ((7610 - 5528) == (7905 - 3132))) then
				return "fel_rush meta 7";
			end
		end
		if (((3683 - (397 + 42)) > (330 + 725)) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (((v79.EyeBeam:CooldownRemains() < (v92 * (803 - (24 + 776)))) and (v79.BladeDance:CooldownRemains() > (0 - 0))) or (v79.Metamorphosis:CooldownRemains() < (v92 * (788 - (222 + 563)))))) then
			if (v21(v79.Annihilation, not v15:IsInMeleeRange(11 - 6)) or ((2386 + 927) <= (1968 - (23 + 167)))) then
				return "annihilation meta 9";
			end
		end
		if ((v79.EssenceBreak:IsCastable() and v39 and (v14:Fury() > (1818 - (690 + 1108))) and ((v79.Metamorphosis:CooldownRemains() > (4 + 6)) or (v79.BladeDance:CooldownRemains() < (v92 * (2 + 0)))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff) or not v79.Inertia:IsAvailable())) or (v94 < (858 - (40 + 808))) or ((234 + 1187) >= (8045 - 5941))) then
			if (((1732 + 80) <= (1719 + 1530)) and v21(v79.EssenceBreak, not v15:IsInMeleeRange(3 + 2))) then
				return "essence_break meta 11";
			end
		end
		if (((2194 - (47 + 524)) <= (1271 + 686)) and v79.ImmolationAura:IsCastable() and v45 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v79.BladeDance:CooldownRemains() > (v92 + (0.5 - 0))) and v14:BuffDown(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and ((v79.ImmolationAura:FullRechargeTime() + (4 - 1)) < v79.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v79.MetamorphosisBuff) > (11 - 6))) then
			if (((6138 - (1165 + 561)) == (132 + 4280)) and v21(v79.ImmolationAura, not v15:IsInRange(24 - 16))) then
				return "immolation_aura meta 13";
			end
		end
		if (((668 + 1082) >= (1321 - (341 + 138))) and v79.DeathSweep:IsCastable() and v37) then
			if (((1181 + 3191) > (3817 - 1967)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(331 - (89 + 237)))) then
				return "death_sweep meta 15";
			end
		end
		if (((746 - 514) < (1728 - 907)) and v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff)) then
			if (((1399 - (581 + 300)) < (2122 - (855 + 365))) and v21(v79.EyeBeam, not v15:IsInRange(18 - 10))) then
				return "eye_beam meta 17";
			end
		end
		if (((978 + 2016) > (2093 - (1030 + 205))) and v79.GlaiveTempest:IsCastable() and v44 and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.BladeDance:CooldownRemains() > (v92 * (2 + 0))) or (v14:Fury() > (56 + 4)))) then
			if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(291 - (156 + 130))) or ((8532 - 4777) <= (1542 - 627))) then
				return "glaive_tempest meta 19";
			end
		end
		if (((8081 - 4135) > (987 + 2756)) and v46 and v79.SigilOfFlame:IsCastable() and (v85 > (2 + 0))) then
			if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((1404 - (10 + 59)) >= (936 + 2370))) then
				if (((23855 - 19011) > (3416 - (671 + 492))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(7 + 1))) then
					return "sigil_of_flame meta 21";
				end
			elseif (((1667 - (369 + 846)) == (120 + 332)) and (v78 == "cursor")) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(35 + 5)) or ((6502 - (1036 + 909)) < (1660 + 427))) then
					return "sigil_of_flame meta 21";
				end
			end
		end
		if (((6503 - 2629) == (4077 - (11 + 192))) and v79.Annihilation:IsCastable() and v33 and ((v79.BladeDance:CooldownRemains() > (v92 * (2 + 0))) or (v14:Fury() > (235 - (135 + 40))) or ((v14:BuffRemains(v79.MetamorphosisBuff) < (11 - 6)) and v79.Felblade:CooldownUp()))) then
			if (v21(v79.Annihilation, not v15:IsInMeleeRange(4 + 1)) or ((4269 - 2331) > (7398 - 2463))) then
				return "annihilation meta 23";
			end
		end
		if ((v46 and v79.SigilOfFlame:IsCastable() and (v14:BuffRemains(v79.MetamorphosisBuff) > (181 - (50 + 126)))) or ((11848 - 7593) < (758 + 2665))) then
			if (((2867 - (1233 + 180)) <= (3460 - (522 + 447))) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1429 - (107 + 1314))) or ((1930 + 2227) <= (8540 - 5737))) then
					return "sigil_of_flame meta 25";
				end
			elseif (((2062 + 2791) >= (5921 - 2939)) and (v78 == "cursor")) then
				if (((16356 - 12222) > (5267 - (716 + 1194))) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1 + 39))) then
					return "sigil_of_flame meta 25";
				end
			end
		end
		if ((v79.Felblade:IsCastable() and v42) or ((367 + 3050) < (3037 - (74 + 429)))) then
			if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((5250 - 2528) <= (82 + 82))) then
				return "felblade meta 27";
			end
		end
		if ((v46 and v79.SigilOfFlame:IsCastable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((5512 - 3104) < (1493 + 616))) then
			if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((101 - 68) == (3597 - 2142))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(441 - (279 + 154))) or ((1221 - (454 + 324)) >= (3159 + 856))) then
					return "sigil_of_flame meta 29";
				end
			elseif (((3399 - (12 + 5)) > (90 + 76)) and (v78 == "cursor")) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(101 - 61)) or ((104 + 176) == (4152 - (277 + 816)))) then
					return "sigil_of_flame meta 29";
				end
			end
		end
		if (((8037 - 6156) > (2476 - (1058 + 125))) and v79.ImmolationAura:IsCastable() and v45 and v15:IsInRange(2 + 6) and (v79.ImmolationAura:Recharge() < (v79.EyeBeam:CooldownRemains() < v14:BuffRemains(v79.MetamorphosisBuff)))) then
			if (((3332 - (815 + 160)) == (10112 - 7755)) and v21(v79.ImmolationAura, not v15:IsInRange(18 - 10))) then
				return "immolation_aura meta 31";
			end
		end
		if (((30 + 93) == (359 - 236)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable()) then
			if (v21(v79.FelRush, not v15:IsInRange(1913 - (41 + 1857))) or ((2949 - (1222 + 671)) >= (8766 - 5374))) then
				return "fel_rush meta 33";
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (11 - 3)) or (v79.EyeBeam:ChargesFractional() > (1183.01 - (229 + 953))))) or ((2855 - (1111 + 663)) < (2654 - (874 + 705)))) then
			if (v21(v79.FelRush, not v15:IsInRange(3 + 12)) or ((716 + 333) >= (9211 - 4779))) then
				return "fel_rush meta 35";
			end
		end
		if ((v79.DemonsBite:IsCastable() and v38) or ((135 + 4633) <= (1525 - (642 + 37)))) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(2 + 3)) or ((538 + 2820) <= (3565 - 2145))) then
				return "demons_bite meta 37";
			end
		end
	end
	local function v103()
		local v115 = 454 - (233 + 221);
		while true do
			if ((v115 == (8 - 4)) or ((3291 + 448) <= (4546 - (718 + 823)))) then
				if ((v79.ChaosStrike:IsCastable() and v35 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((1044 + 615) >= (2939 - (266 + 539)))) then
					if (v21(v79.ChaosStrike, not v15:IsInMeleeRange(13 - 8)) or ((4485 - (636 + 589)) < (5590 - 3235))) then
						return "chaos_strike rotation 35";
					end
				end
				if ((v79.Felblade:IsCastable() and v42) or ((1379 - 710) == (3347 + 876))) then
					if (v21(v79.Felblade, not v15:IsInMeleeRange(2 + 3)) or ((2707 - (657 + 358)) < (1556 - 968))) then
						return "felblade rotation 37";
					end
				end
				if ((v79.ThrowGlaive:IsCastable() and v47 and (v79.ThrowGlaive:FullRechargeTime() <= v79.BladeDance:CooldownRemains()) and (v79.Metamorphosis:CooldownRemains() > (11 - 6)) and v79.Soulscar:IsAvailable() and v14:HasTier(1218 - (1151 + 36), 2 + 0) and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) or ((14325 - 9528) < (5483 - (1552 + 280)))) then
					if (v21(v79.ThrowGlaive, not v15:IsInMeleeRange(864 - (64 + 770))) or ((2836 + 1341) > (11009 - 6159))) then
						return "throw_glaive rotation 39";
					end
				end
				if ((v79.ThrowGlaive:IsCastable() and v47 and not v14:HasTier(6 + 25, 1245 - (157 + 1086)) and ((v85 > (1 - 0)) or v79.Soulscar:IsAvailable()) and not v14:PrevGCDP(4 - 3, v79.VengefulRetreat)) or ((613 - 213) > (1516 - 405))) then
					if (((3870 - (599 + 220)) > (2001 - 996)) and v21(v79.ThrowGlaive, not v15:IsInMeleeRange(1961 - (1813 + 118)))) then
						return "throw_glaive rotation 41";
					end
				end
				if (((2700 + 993) <= (5599 - (841 + 376))) and v79.ChaosStrike:IsCastable() and v35 and ((v79.EyeBeam:CooldownRemains() > (v92 * (2 - 0))) or (v14:Fury() > (19 + 61)))) then
					if (v21(v79.ChaosStrike, not v15:IsInMeleeRange(13 - 8)) or ((4141 - (464 + 395)) > (10522 - 6422))) then
						return "chaos_strike rotation 43";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and not v79.Inertia:IsAvailable() and (v85 > (1 + 1))) or ((4417 - (467 + 370)) < (5877 - 3033))) then
					if (((66 + 23) < (15391 - 10901)) and v21(v79.ImmolationAura, not v15:IsInRange(2 + 6))) then
						return "immolation_aura rotation 45";
					end
				end
				v115 = 11 - 6;
			end
			if ((v115 == (522 - (150 + 370))) or ((6265 - (74 + 1208)) < (4446 - 2638))) then
				if (((18159 - 14330) > (2682 + 1087)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v79.BladeDance:CooldownRemains() < (394 - (14 + 376))) and (v79.EyeBeam:CooldownRemains() > (8 - 3)) and ((v79.ImmolationAura:Charges() > (0 + 0)) or ((v79.ImmolationAura:Recharge() + 2 + 0) < v79.EyeBeam:CooldownRemains()) or (v79.EyeBeam:CooldownRemains() > (v14:BuffRemains(v79.UnboundChaosBuff) - (2 + 0))))) then
					if (((4351 - 2866) <= (2185 + 719)) and v21(v79.FelRush, not v15:IsInRange(93 - (23 + 55)))) then
						return "fel_rush rotation 11";
					end
				end
				if (((10116 - 5847) == (2849 + 1420)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v92 * (2 + 0)))) then
					if (((599 - 212) <= (876 + 1906)) and v21(v79.FelRush, not v15:IsInRange(916 - (652 + 249)))) then
						return "fel_rush rotation 13";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v92 * (5 - 3))) and (v94 > v79.ImmolationAura:FullRechargeTime())) or ((3767 - (708 + 1160)) <= (2489 - 1572))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(14 - 6)) or ((4339 - (10 + 17)) <= (197 + 679))) then
						return "immolation_aura rotation 15";
					end
				end
				if (((3964 - (1400 + 332)) <= (4979 - 2383)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (1910 - (242 + 1666))) and v14:BuffDown(v79.UnboundChaosBuff)) then
					if (((897 + 1198) < (1351 + 2335)) and v21(v79.ImmolationAura, not v15:IsInRange(7 + 1))) then
						return "immolation_aura rotation 17";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.EyeBeam:CooldownRemains() < (945 - (850 + 90)))) or ((2793 - 1198) >= (5864 - (360 + 1030)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(8 + 0)) or ((13036 - 8417) < (3964 - 1082))) then
						return "immolation_aura rotation 19";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:Recharge() + (1666 - (909 + 752))) < v79.EyeBeam:CooldownRemains()) and (v79.BladeDance:CooldownRemains() > (1223 - (109 + 1114))) and (v79.BladeDance:CooldownRemains() < (6 - 2)) and (v79.ImmolationAura:ChargesFractional() > (1 + 0))) or ((536 - (6 + 236)) >= (3044 + 1787))) then
					if (((1634 + 395) <= (7272 - 4188)) and v21(v79.ImmolationAura, not v15:IsInRange(13 - 5))) then
						return "immolation_aura rotation 21";
					end
				end
				v115 = 1136 - (1076 + 57);
			end
			if ((v115 == (1 + 2)) or ((2726 - (579 + 110)) == (192 + 2228))) then
				if (((3942 + 516) > (2072 + 1832)) and v79.ImmolationAura:IsCastable() and v45 and (v94 < (422 - (174 + 233))) and (v79.BladeDance:CooldownRemains() > (0 - 0))) then
					if (((765 - 329) >= (55 + 68)) and v21(v79.ImmolationAura, not v15:IsInRange(1182 - (663 + 511)))) then
						return "immolation_aura rotation 23";
					end
				end
				if (((447 + 53) < (395 + 1421)) and v79.EyeBeam:IsCastable() and v40 and not v79.EssenceBreak:IsAvailable() and (not v79.ChaoticTransformation:IsAvailable() or (v79.Metamorphosis:CooldownRemains() < ((15 - 10) + ((2 + 1) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.Metamorphosis:CooldownRemains() > (35 - 20)))) then
					if (((8651 - 5077) == (1706 + 1868)) and v21(v79.EyeBeam, not v15:IsInRange(15 - 7))) then
						return "eye_beam rotation 25";
					end
				end
				if (((158 + 63) < (36 + 354)) and ((v79.EyeBeam:IsCastable() and v40 and v79.EssenceBreak:IsAvailable() and ((v79.EssenceBreak:CooldownRemains() < ((v92 * (724 - (478 + 244))) + ((522 - (440 + 77)) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.ShatteredDestiny:IsAvailable() and (v79.EssenceBreak:CooldownRemains() > (5 + 5)))) and ((v79.BladeDance:CooldownRemains() < (25 - 18)) or (v85 > (1557 - (655 + 901)))) and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (2 + 8)) or (v85 > (1 + 0))) and (not v79.Inertia:IsAvailable() or v14:BuffUp(v79.UnboundChaosBuff) or ((v79.ImmolationAura:Charges() == (0 + 0)) and (v79.ImmolationAura:Recharge() > (20 - 15))))) or (v94 < (1455 - (695 + 750))))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(27 - 19)) or ((3414 - 1201) <= (5714 - 4293))) then
						return "eye_beam rotation 27";
					end
				end
				if (((3409 - (285 + 66)) < (11329 - 6469)) and v79.BladeDance:IsCastable() and v34 and ((v79.EyeBeam:CooldownRemains() > v92) or v79.EyeBeam:CooldownUp())) then
					if (v21(v79.BladeDance, not v15:IsInRange(1315 - (682 + 628))) or ((209 + 1087) >= (4745 - (176 + 123)))) then
						return "blade_dance rotation 29";
					end
				end
				if ((v79.GlaiveTempest:IsCastable() and v44 and (v85 >= (1 + 1))) or ((1011 + 382) > (4758 - (239 + 30)))) then
					if (v21(v79.GlaiveTempest, not v15:IsInRange(3 + 5)) or ((4253 + 171) < (47 - 20))) then
						return "glaive_tempest rotation 31";
					end
				end
				if ((v46 and (v85 > (8 - 5)) and v79.SigilOfFlame:IsCastable()) or ((2312 - (306 + 9)) > (13312 - 9497))) then
					if (((603 + 2862) > (1174 + 739)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((353 + 380) < (5201 - 3382)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1383 - (1140 + 235)))) then
							return "sigil_of_flame rotation 33";
						end
					elseif ((v78 == "cursor") or ((2797 + 1598) == (4361 + 394))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(11 + 29)) or ((3845 - (33 + 19)) < (856 + 1513))) then
							return "sigil_of_flame rotation 33";
						end
					end
				end
				v115 = 11 - 7;
			end
			if ((v115 == (0 + 0)) or ((8008 - 3924) == (249 + 16))) then
				v28 = v99();
				if (((5047 - (586 + 103)) == (397 + 3961)) and v28) then
					return v28;
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffRemains(v79.UnboundChaosBuff) < (v92 * (5 - 3)))) or ((4626 - (1309 + 179)) < (1792 - 799))) then
					if (((1450 + 1880) > (6238 - 3915)) and v21(v79.FelRush, not v15:IsInRange(12 + 3))) then
						return "fel_rush rotation 1";
					end
				end
				if (v79.FelBarrage:IsAvailable() or ((7703 - 4077) == (7948 - 3959))) then
					v88 = v79.FelBarrage:IsAvailable() and (v79.FelBarrage:CooldownRemains() < (v92 * (616 - (295 + 314)))) and (((v85 >= (4 - 2)) and ((v79.Metamorphosis:CooldownRemains() > (1962 - (1300 + 662))) or (v85 > (6 - 4)))) or v14:BuffUp(v79.FelBarrageBuff));
				end
				if (((v79.EyeBeam:CooldownUp() or v79.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (1770 - (1178 + 577)))) or ((476 + 440) == (7895 - 5224))) then
					v28 = v100();
					if (((1677 - (851 + 554)) == (241 + 31)) and v28) then
						return v28;
					end
				end
				if (((11783 - 7534) <= (10509 - 5670)) and v88) then
					local v162 = 302 - (115 + 187);
					while true do
						if (((2127 + 650) < (3030 + 170)) and (v162 == (0 - 0))) then
							v28 = v101();
							if (((1256 - (160 + 1001)) < (1713 + 244)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v115 = 1 + 0;
			end
			if (((1690 - 864) < (2075 - (237 + 121))) and (v115 == (902 - (525 + 372)))) then
				if (((2702 - 1276) >= (3630 - 2525)) and v46 and not v15:IsInRange(150 - (96 + 46)) and v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > (802 - (643 + 134)))) and v79.SigilOfFlame:IsCastable()) then
					if (((995 + 1759) <= (8101 - 4722)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(29 - 21)) or ((3767 + 160) == (2772 - 1359))) then
							return "sigil_of_flame rotation 47";
						end
					elseif ((v78 == "cursor") or ((2358 - 1204) <= (1507 - (316 + 403)))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(27 + 13)) or ((4517 - 2874) > (1222 + 2157))) then
							return "sigil_of_flame rotation 47";
						end
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38) or ((7058 - 4255) > (3224 + 1325))) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(2 + 3)) or ((762 - 542) >= (14432 - 11410))) then
						return "demons_bite rotation 49";
					end
				end
				if (((5862 - 3040) == (162 + 2660)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (15 - 7)) or (v79.FelRush:ChargesFractional() > (1.01 + 0)))) then
					if (v21(v79.FelRush, not v15:IsInRange(44 - 29)) or ((1078 - (12 + 5)) == (7212 - 5355))) then
						return "fel_rush rotation 51";
					end
				end
				if (((5888 - 3128) > (2899 - 1535)) and v79.ArcaneTorrent:IsCastable() and not v14:IsMoving() and v15:IsInRange(19 - 11) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:Fury() < (21 + 79))) then
					if (v21(v79.ArcaneTorrent, not v15:IsInRange(1981 - (1656 + 317))) or ((4369 + 533) <= (2881 + 714))) then
						return "arcane_torrent rotation 53";
					end
				end
				break;
			end
			if ((v115 == (2 - 1)) or ((18957 - 15105) == (647 - (5 + 349)))) then
				if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (9 - 7)) and v79.Ragefire:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > v79.ImmolationAura:Recharge())) and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((2830 - (266 + 1005)) == (3024 + 1564))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(27 - 19)) or ((5902 - 1418) == (2484 - (561 + 1135)))) then
						return "immolation_aura rotation 3";
					end
				end
				if (((5952 - 1384) >= (12842 - 8935)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (1068 - (507 + 559))) and v79.Ragefire:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if (((3126 - 1880) < (10731 - 7261)) and v21(v79.ImmolationAura, not v15:IsInRange(396 - (212 + 176)))) then
						return "immolation_aura rotation 5";
					end
				end
				if (((4973 - (250 + 655)) >= (2650 - 1678)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v85 > (2 - 0)) and (not v79.Inertia:IsAvailable() or ((v79.EyeBeam:CooldownRemains() + (2 - 0)) > v14:BuffRemains(v79.UnboundChaosBuff)))) then
					if (((2449 - (1869 + 87)) < (13502 - 9609)) and v21(v79.FelRush, not v15:IsInRange(1916 - (484 + 1417)))) then
						return "fel_rush rotation 7";
					end
				end
				if ((v79.VengefulRetreat:IsCastable() and v48 and v32 and v79.Felblade:IsCastable() and v79.Initiative:IsAvailable() and (((v79.EyeBeam:CooldownRemains() > (32 - 17)) and (v14:GCDRemains() < (0.3 - 0))) or ((v14:GCDRemains() < (773.1 - (48 + 725))) and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v79.Metamorphosis:CooldownRemains() > (16 - 6)) or (v79.BladeDance:CooldownRemains() < (v92 * (5 - 3)))))) and (v10.CombatTime() > (3 + 1))) or ((3936 - 2463) >= (933 + 2399))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(3 + 5), true, true) or ((4904 - (152 + 701)) <= (2468 - (430 + 881)))) then
						return "vengeful_retreat rotation 9";
					end
				end
				if (((232 + 372) < (3776 - (557 + 338))) and (v88 or (not v79.DemonBlades:IsAvailable() and v79.FelBarrage:IsAvailable() and (v14:BuffUp(v79.FelBarrageBuff) or (v79.FelBarrage:CooldownRemains() > (0 + 0))) and v14:BuffDown(v79.MetamorphosisBuff)))) then
					v28 = v101();
					if (v28 or ((2536 - 1636) == (11825 - 8448))) then
						return v28;
					end
				end
				if (((11846 - 7387) > (1273 - 682)) and v14:BuffUp(v79.MetamorphosisBuff)) then
					v28 = v102();
					if (((4199 - (499 + 302)) >= (3261 - (39 + 827))) and v28) then
						return v28;
					end
				end
				v115 = 5 - 3;
			end
		end
	end
	local function v104()
		v33 = EpicSettings.Settings['useAnnihilation'];
		v34 = EpicSettings.Settings['useBladeDance'];
		v35 = EpicSettings.Settings['useChaosStrike'];
		v36 = EpicSettings.Settings['useConsumeMagic'];
		v37 = EpicSettings.Settings['useDeathSweep'];
		v38 = EpicSettings.Settings['useDemonsBite'];
		v39 = EpicSettings.Settings['useEssenceBreak'];
		v40 = EpicSettings.Settings['useEyeBeam'];
		v41 = EpicSettings.Settings['useFelBarrage'];
		v42 = EpicSettings.Settings['useFelblade'];
		v43 = EpicSettings.Settings['useFelRush'];
		v44 = EpicSettings.Settings['useGlaiveTempest'];
		v45 = EpicSettings.Settings['useImmolationAura'];
		v46 = EpicSettings.Settings['useSigilOfFlame'];
		v47 = EpicSettings.Settings['useThrowGlaive'];
		v48 = EpicSettings.Settings['useVengefulRetreat'];
		v53 = EpicSettings.Settings['useElysianDecree'];
		v54 = EpicSettings.Settings['useMetamorphosis'];
		v55 = EpicSettings.Settings['useTheHunt'];
		v56 = EpicSettings.Settings['elysianDecreeWithCD'];
		v57 = EpicSettings.Settings['metamorphosisWithCD'];
		v58 = EpicSettings.Settings['theHuntWithCD'];
		v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
	end
	local function v105()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (0 - 0)) or ((187 + 1996) >= (8265 - 5441))) then
				v49 = EpicSettings.Settings['useChaosNova'];
				v50 = EpicSettings.Settings['useDisrupt'];
				v138 = 1 + 0;
			end
			if (((3063 - 1127) == (2040 - (103 + 1))) and (v138 == (556 - (475 + 79)))) then
				v61 = EpicSettings.Settings['useBlur'];
				v62 = EpicSettings.Settings['useNetherwalk'];
				v138 = 6 - 3;
			end
			if ((v138 == (9 - 6)) or ((625 + 4207) < (3796 + 517))) then
				v63 = EpicSettings.Settings['blurHP'] or (1503 - (1395 + 108));
				v64 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
				v138 = 1208 - (7 + 1197);
			end
			if (((1783 + 2305) > (1352 + 2522)) and (v138 == (323 - (27 + 292)))) then
				v78 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
			if (((12693 - 8361) == (5524 - 1192)) and (v138 == (4 - 3))) then
				v51 = EpicSettings.Settings['useFelEruption'];
				v52 = EpicSettings.Settings['useSigilOfMisery'];
				v138 = 3 - 1;
			end
		end
	end
	local function v106()
		local v139 = 0 - 0;
		while true do
			if (((4138 - (43 + 96)) >= (11829 - 8929)) and (v139 == (1 - 0))) then
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v139 = 2 + 0;
			end
			if ((v139 == (1 + 2)) or ((4990 - 2465) > (1558 + 2506))) then
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v139 = 1 + 3;
			end
			if (((6122 - (1414 + 337)) == (6311 - (1642 + 298))) and (v139 == (0 - 0))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v139 = 2 - 1;
			end
			if ((v139 == (2 + 2)) or ((207 + 59) > (5958 - (357 + 615)))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((1398 + 593) >= (2269 - 1344)) and (v139 == (2 + 0))) then
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v139 = 6 - 3;
			end
		end
	end
	local function v107()
		local v140 = 0 + 0;
		while true do
			if (((31 + 424) < (1291 + 762)) and (v140 == (1303 - (384 + 917)))) then
				v83 = v14:GetEnemiesInMeleeRange(705 - (128 + 569));
				v84 = v14:GetEnemiesInMeleeRange(1563 - (1407 + 136));
				if (v30 or ((2713 - (687 + 1200)) == (6561 - (556 + 1154)))) then
					v85 = ((#v83 > (0 - 0)) and #v83) or (96 - (9 + 86));
					v86 = #v84;
				else
					v85 = 422 - (275 + 146);
					v86 = 1 + 0;
				end
				v92 = v14:GCD() + (64.05 - (29 + 35));
				v140 = 13 - 10;
			end
			if (((546 - 363) == (807 - 624)) and (v140 == (0 + 0))) then
				v105();
				v104();
				v106();
				v29 = EpicSettings.Toggles['ooc'];
				v140 = 1013 - (53 + 959);
			end
			if (((1567 - (312 + 96)) <= (3102 - 1314)) and (v140 == (286 - (147 + 138)))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['movement'];
				if (v14:IsDeadOrGhost() or ((4406 - (813 + 86)) > (3903 + 415))) then
					return v28;
				end
				v140 = 3 - 1;
			end
			if (((495 - (18 + 474)) == v140) or ((1038 + 2037) <= (9677 - 6712))) then
				if (((2451 - (860 + 226)) <= (2314 - (121 + 182))) and (v23.TargetIsValid() or v14:AffectingCombat())) then
					v93 = v10.BossFightRemains(nil, true);
					v94 = v93;
					if ((v94 == (1368 + 9743)) or ((4016 - (988 + 252)) > (404 + 3171))) then
						v94 = v10.FightRemains(v83, false);
					end
				end
				v28 = v97();
				if (v28 or ((800 + 1754) == (6774 - (49 + 1921)))) then
					return v28;
				end
				if (((3467 - (223 + 667)) == (2629 - (51 + 1))) and v66) then
					v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 51 - 21, true);
					if (v28 or ((12 - 6) >= (3014 - (146 + 979)))) then
						return v28;
					end
				end
				v140 = 2 + 2;
			end
			if (((1111 - (311 + 294)) <= (5276 - 3384)) and (v140 == (2 + 2))) then
				if (v14:PrevGCDP(1444 - (496 + 947), v79.VengefulRetreat) or v14:PrevGCDP(1360 - (1233 + 125), v79.VengefulRetreat) or (v14:PrevGCDP(2 + 1, v79.VengefulRetreat) and v14:IsMoving()) or ((1802 + 206) > (422 + 1796))) then
					if (((2024 - (963 + 682)) <= (3461 + 686)) and v79.Felblade:IsCastable() and v42) then
						if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((6018 - (504 + 1000)) <= (680 + 329))) then
							return "felblade rotation 1";
						end
					end
				elseif ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((3184 + 312) == (113 + 1079))) then
					if ((not v14:AffectingCombat() and v29) or ((306 - 98) == (2529 + 430))) then
						local v163 = 0 + 0;
						while true do
							if (((4459 - (156 + 26)) >= (757 + 556)) and (v163 == (0 - 0))) then
								v28 = v98();
								if (((2751 - (149 + 15)) < (4134 - (890 + 70))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if ((v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) or ((4237 - (39 + 78)) <= (2680 - (14 + 468)))) then
						if (v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic)) or ((3509 - 1913) == (2398 - 1540))) then
							return "greater_purge damage";
						end
					end
					if (((1662 + 1558) == (1934 + 1286)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v15:NPCID())) then
						if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((298 + 1104) > (1635 + 1985))) then
							return "fodder to the flames react per target";
						end
					end
					if (((675 + 1899) == (4926 - 2352)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v16:NPCID())) then
						if (((1778 + 20) < (9687 - 6930)) and v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v28 = v103();
					if (v28 or ((10 + 367) > (2655 - (12 + 39)))) then
						return v28;
					end
				end
				break;
			end
		end
	end
	local function v108()
		v79.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(537 + 40, v107, v108);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

