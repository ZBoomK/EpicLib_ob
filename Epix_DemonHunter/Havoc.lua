local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((3768 - 2847) <= (210 + 892)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((5311 - (316 + 289)) >= (2520 - 1557)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1454 - (666 + 787))) or ((1385 - (360 + 65)) <= (819 + 57))) then
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
	local v33 = false;
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
	local v82 = v18.DemonHunter.Havoc;
	local v83 = v19.DemonHunter.Havoc;
	local v84 = v22.DemonHunter.Havoc;
	local v85 = {};
	local v86, v87;
	local v88, v89;
	local v90 = {{v82.FelEruption},{v82.ChaosNova}};
	local v91 = false;
	local v92 = false;
	local v93 = 0 - 0;
	local v94 = 899 - (503 + 396);
	local v95 = v14:GCD() + (181.25 - (92 + 89));
	local v96 = 21554 - 10443;
	local v97 = 5699 + 5412;
	local v98 = {(663476 - 494055),(386310 - 216885),(80688 + 88244),(21146 + 148280),(170673 - (485 + 759)),(170617 - (442 + 747)),(170376 - (88 + 858))};
	v10:RegisterForEvent(function()
		local v112 = 0 + 0;
		while true do
			if ((v112 == (0 + 0)) or ((86 + 1980) == (1721 - (766 + 23)))) then
				v91 = false;
				v96 = 54852 - 43741;
				v112 = 1 - 0;
			end
			if (((12712 - 7887) < (16437 - 11594)) and (v112 == (1074 - (1036 + 37)))) then
				v97 = 7878 + 3233;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v99()
		local v113 = 0 - 0;
		while true do
			if ((v113 == (1 + 0)) or ((5357 - (641 + 839)) >= (5450 - (910 + 3)))) then
				v28 = v23.HandleBottomTrinket(v85, v31, 101 - 61, nil);
				if (v28 or ((5999 - (1466 + 218)) < (794 + 932))) then
					return v28;
				end
				break;
			end
			if ((v113 == (1148 - (556 + 592))) or ((1309 + 2370) < (1433 - (329 + 479)))) then
				v28 = v23.HandleTopTrinket(v85, v31, 894 - (174 + 680), nil);
				if (v28 or ((15892 - 11267) < (1309 - 677))) then
					return v28;
				end
				v113 = 1 + 0;
			end
		end
	end
	local function v100()
		local v114 = 739 - (396 + 343);
		while true do
			if ((v114 == (0 + 0)) or ((1560 - (29 + 1448)) > (3169 - (135 + 1254)))) then
				if (((2056 - 1510) <= (5028 - 3951)) and v82.Blur:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) then
					if (v21(v82.Blur) or ((664 + 332) > (5828 - (389 + 1138)))) then
						return "blur defensive";
					end
				end
				if (((4644 - (102 + 472)) > (649 + 38)) and v82.Netherwalk:IsCastable() and v63 and (v14:HealthPercentage() <= v65)) then
					if (v21(v82.Netherwalk) or ((364 + 292) >= (3105 + 225))) then
						return "netherwalk defensive";
					end
				end
				v114 = 1546 - (320 + 1225);
			end
			if ((v114 == (1 - 0)) or ((1525 + 967) <= (1799 - (157 + 1307)))) then
				if (((6181 - (821 + 1038)) >= (6391 - 3829)) and v83.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) then
					if (v21(v84.Healthstone) or ((398 + 3239) >= (6696 - 2926))) then
						return "healthstone defensive";
					end
				end
				if ((v74 and (v14:HealthPercentage() <= v76)) or ((886 + 1493) > (11346 - 6768))) then
					local v170 = 1026 - (834 + 192);
					while true do
						if ((v170 == (0 + 0)) or ((124 + 359) > (16 + 727))) then
							if (((3801 - 1347) > (882 - (300 + 4))) and (v78 == "Refreshing Healing Potion")) then
								if (((249 + 681) < (11669 - 7211)) and v83.RefreshingHealingPotion:IsReady()) then
									if (((1024 - (112 + 250)) <= (388 + 584)) and v21(v84.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((10947 - 6577) == (2504 + 1866)) and (v78 == "Dreamwalker's Healing Potion")) then
								if (v83.DreamwalkersHealingPotion:IsReady() or ((2463 + 2299) <= (644 + 217))) then
									if (v21(v84.RefreshingHealingPotion) or ((701 + 711) == (3168 + 1096))) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							v170 = 1415 - (1001 + 413);
						end
						if ((v170 == (2 - 1)) or ((4050 - (244 + 638)) < (2846 - (627 + 66)))) then
							if ((v78 == "Potion of Withering Dreams") or ((14826 - 9850) < (1934 - (512 + 90)))) then
								if (((6534 - (1665 + 241)) == (5345 - (373 + 344))) and v83.PotionOfWitheringDreams:IsReady()) then
									if (v21(v84.RefreshingHealingPotion) or ((25 + 29) == (105 + 290))) then
										return "potion of withering dreams defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v115 = 0 - 0;
		while true do
			if (((138 - 56) == (1181 - (35 + 1064))) and (v115 == (0 + 0))) then
				if ((v82.ImmolationAura:IsCastable() and v46) or ((1242 - 661) < (2 + 280))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(1244 - (298 + 938))) or ((5868 - (233 + 1026)) < (4161 - (636 + 1030)))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((589 + 563) == (1126 + 26)) and not v15:IsInMeleeRange(2 + 3) and v82.Felblade:IsCastable() and v43) then
					if (((129 + 1767) <= (3643 - (55 + 166))) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
						return "felblade precombat 9";
					end
				end
				v115 = 1 + 0;
			end
			if (((1 + 0) == v115) or ((3780 - 2790) > (1917 - (36 + 261)))) then
				if ((not v15:IsInMeleeRange(8 - 3) and v82.FelRush:IsCastable() and (not v82.Felblade:IsAvailable() or (v82.Felblade:CooldownUp() and not v14:PrevGCDP(1369 - (34 + 1334), v82.Felblade))) and v32 and ((not v33 and v80) or not v80) and v44) or ((338 + 539) > (3648 + 1047))) then
					if (((3974 - (1035 + 248)) >= (1872 - (20 + 1))) and v21(v82.FelRush, not v15:IsInRange(8 + 7))) then
						return "fel_rush precombat 10";
					end
				end
				if ((v15:IsInMeleeRange(324 - (134 + 185)) and v39 and (v82.DemonsBite:IsCastable() or v82.DemonBlades:IsAvailable())) or ((4118 - (549 + 584)) >= (5541 - (314 + 371)))) then
					if (((14679 - 10403) >= (2163 - (478 + 490))) and v21(v82.DemonsBite, not v15:IsInMeleeRange(3 + 2))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v102()
		local v116 = 1172 - (786 + 386);
		while true do
			if (((10468 - 7236) <= (6069 - (1055 + 324))) and ((1341 - (1093 + 247)) == v116)) then
				if ((v82.Annihilation:IsReady() and v14:BuffUp(v82.InnerDemonBuff) and (((v82.EyeBeam:CooldownRemains() < (v95 * (3 + 0))) and v82.BladeDance:CooldownUp()) or (v82.Metamorphosis:CooldownRemains() < (v95 * (1 + 2)))) and v34) or ((3557 - 2661) >= (10676 - 7530))) then
					if (((8710 - 5649) >= (7433 - 4475)) and v21(v82.Annihilation, not v15:IsInMeleeRange(2 + 3))) then
						return "annihilation meta 8";
					end
				end
				if (((12277 - 9090) >= (2219 - 1575)) and v82.EssenceBreak:IsCastable() and (((v14:Fury() > (16 + 4)) and ((v82.Metamorphosis:CooldownRemains() > (25 - 15)) or (v82.BladeDance:CooldownRemains() < (v95 * (690 - (364 + 324))))) and (v14:BuffDown(v82.UnboundChaosBuff) or v14:BuffUp(v82.InertiaBuff) or not v82.Inertia:IsAvailable())) or (v97 < (27 - 17))) and v40) then
					if (((1545 - 901) <= (234 + 470)) and v21(v82.EssenceBreak, not v15:IsInMeleeRange(20 - 15))) then
						return "essence_break meta 10";
					end
				end
				if (((1534 - 576) > (2876 - 1929)) and v82.ImmolationAura:IsCastable() and v15:DebuffDown(v82.EssenceBreakDebuff) and (v82.BladeDance:CooldownRemains() > (v95 + (1268.5 - (1249 + 19)))) and v14:BuffDown(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and ((v82.ImmolationAura:FullRechargeTime() + 3 + 0) < v82.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v82.MetamorphosisBuff) > (19 - 14)) and v46) then
					if (((5578 - (686 + 400)) >= (2083 + 571)) and v21(v82.ImmolationAura, not v15:IsInRange(237 - (73 + 156)))) then
						return "immolation_aura meta 12";
					end
				end
				v116 = 1 + 1;
			end
			if (((4253 - (721 + 90)) >= (17 + 1486)) and (v116 == (6 - 4))) then
				if ((v82.DeathSweep:IsReady() and v38) or ((3640 - (224 + 246)) <= (2371 - 907))) then
					if (v21(v82.DeathSweep, not v15:IsInMeleeRange(14 - 6)) or ((871 + 3926) == (105 + 4283))) then
						return "death_sweep meta 14";
					end
				end
				if (((405 + 146) <= (1353 - 672)) and v82.EyeBeam:IsReady() and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff) and v41) then
					if (((10905 - 7628) > (920 - (203 + 310))) and v21(v82.EyeBeam, not v15:IsInRange(2001 - (1238 + 755)))) then
						return "eye_beam meta 16";
					end
				end
				if (((329 + 4366) >= (2949 - (709 + 825))) and v82.GlaiveTempest:IsReady() and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.BladeDance:CooldownRemains() > (v95 * (3 - 1))) or (v14:Fury() > (87 - 27))) and v45) then
					if (v21(v82.GlaiveTempest, not v15:IsInMeleeRange(869 - (196 + 668)), false, true) or ((12681 - 9469) <= (1955 - 1011))) then
						return "glaive_tempest meta 18";
					end
				end
				v116 = 836 - (171 + 662);
			end
			if ((v116 == (96 - (4 + 89))) or ((10851 - 7755) <= (655 + 1143))) then
				if (((15535 - 11998) == (1388 + 2149)) and v82.SigilOfFlame:IsCastable() and (v88 > (1488 - (35 + 1451))) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) then
					if (((5290 - (28 + 1425)) >= (3563 - (941 + 1052))) and ((v79 == "player") or v82.ConcentratedSigils:IsAvailable())) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(8 + 0)) or ((4464 - (822 + 692)) == (5441 - 1629))) then
							return "sigil_of_flame meta 20";
						end
					elseif (((2225 + 2498) >= (2615 - (45 + 252))) and (v79 == "cursor")) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(40 + 0)) or ((698 + 1329) > (6940 - 4088))) then
							return "sigil_of_flame meta 20";
						end
					end
				end
				if ((v82.Annihilation:IsReady() and ((v82.BladeDance:CooldownRemains() > (v95 * (435 - (114 + 319)))) or (v14:Fury() > (86 - 26)) or ((v14:BuffRemains(v82.MetamorphosisBuff) < (6 - 1)) and v82.Felblade:CooldownUp())) and v34) or ((725 + 411) > (6430 - 2113))) then
					if (((9948 - 5200) == (6711 - (556 + 1407))) and v21(v82.Annihilation, not v15:IsInMeleeRange(1211 - (741 + 465)))) then
						return "annihilation meta 22";
					end
				end
				if (((4201 - (170 + 295)) <= (2498 + 2242)) and v82.SigilOfFlame:IsCastable() and (v14:BuffRemains(v82.MetamorphosisBuff) > (5 + 0)) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) then
					if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((8346 - 4956) <= (2537 + 523))) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(6 + 2)) or ((566 + 433) > (3923 - (957 + 273)))) then
							return "sigil_of_flame meta 24";
						end
					elseif (((124 + 339) < (241 + 360)) and (v79 == "cursor")) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(152 - 112)) or ((5752 - 3569) < (2098 - 1411))) then
							return "sigil_of_flame meta 24";
						end
					end
				end
				v116 = 19 - 15;
			end
			if (((6329 - (389 + 1391)) == (2855 + 1694)) and (v116 == (1 + 4))) then
				if (((10635 - 5963) == (5623 - (783 + 168))) and v82.FelRush:IsCastable() and v44 and (v82.Momentum:IsAvailable()) and v32 and ((not v33 and v80) or not v80)) then
					if (v21(v82.FelRush, not v15:IsInRange(50 - 35)) or ((3608 + 60) < (706 - (309 + 2)))) then
						return "fel_rush meta 32";
					end
				end
				if ((v82.FelRush:IsCastable() and v44 and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (24 - 16)) or (v82.FelRush:ChargesFractional() > (1213.01 - (1090 + 122)))) and v15:IsInRange(5 + 10) and v32 and ((not v33 and v80) or not v80)) or ((13991 - 9825) == (312 + 143))) then
					if (v21(v82.FelRush, not v15:IsInRange(1133 - (628 + 490))) or ((798 + 3651) == (6593 - 3930))) then
						return "fel_rush meta 34";
					end
				end
				if ((v82.DemonsBite:IsCastable() and v39) or ((19545 - 15268) < (3763 - (431 + 343)))) then
					if (v21(v82.DemonsBite, not v15:IsInMeleeRange(10 - 5)) or ((2516 - 1646) >= (3278 + 871))) then
						return "demons_bite meta 36";
					end
				end
				break;
			end
			if (((283 + 1929) < (4878 - (556 + 1139))) and (v116 == (19 - (6 + 9)))) then
				if (((851 + 3795) > (1533 + 1459)) and v82.Felblade:IsCastable() and v43) then
					if (((1603 - (28 + 141)) < (1204 + 1902)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
						return "felblade meta 26";
					end
				end
				if (((970 - 184) < (2142 + 881)) and v82.SigilOfFlame:IsCastable() and (v15:DebuffDown(v82.EssenceBreakDebuff)) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) then
					if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((3759 - (486 + 831)) < (192 - 118))) then
						if (((15966 - 11431) == (857 + 3678)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(25 - 17))) then
							return "sigil_of_flame meta 28";
						end
					elseif ((v79 == "cursor") or ((4272 - (668 + 595)) <= (1895 + 210))) then
						if (((369 + 1461) < (10005 - 6336)) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(330 - (23 + 267)))) then
							return "sigil_of_flame meta 28";
						end
					end
				end
				if ((v82.ImmolationAura:IsCastable() and v15:IsInRange(1952 - (1129 + 815)) and (v82.ImmolationAura:Recharge() < (v27(v82.EyeBeam:CooldownRemains(), v14:BuffRemains(v82.MetamorphosisBuff)))) and v46) or ((1817 - (371 + 16)) >= (5362 - (1326 + 424)))) then
					if (((5080 - 2397) >= (8989 - 6529)) and v21(v82.ImmolationAura, not v15:IsInRange(126 - (88 + 30)))) then
						return "immolation_aura meta 30";
					end
				end
				v116 = 776 - (720 + 51);
			end
			if ((v116 == (0 - 0)) or ((3580 - (421 + 1355)) >= (5402 - 2127))) then
				if ((v82.DeathSweep:IsReady() and (v14:BuffRemains(v82.MetamorphosisBuff) < v95) and v38) or ((697 + 720) > (4712 - (286 + 797)))) then
					if (((17528 - 12733) > (665 - 263)) and v21(v82.DeathSweep, not v15:IsInMeleeRange(447 - (397 + 42)))) then
						return "death_sweep meta 2";
					end
				end
				if (((1504 + 3309) > (4365 - (24 + 776))) and v82.Annihilation:IsReady() and (v14:BuffRemains(v82.MetamorphosisBuff) < v95) and v34) then
					if (((6026 - 2114) == (4697 - (222 + 563))) and v21(v82.Annihilation, not v15:IsInMeleeRange(11 - 6))) then
						return "annihilation meta 4";
					end
				end
				if (((2032 + 789) <= (5014 - (23 + 167))) and v82.FelRush:IsCastable() and v44 and ((v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable()) or (v82.Momentum:IsAvailable() and (v14:BuffRemains(v82.MomentumBuff) < (v95 * (1800 - (690 + 1108)))))) and v44 and v32 and ((not v33 and v80) or not v80)) then
					if (((628 + 1110) <= (1811 + 384)) and v21(v82.FelRush, not v15:IsInRange(863 - (40 + 808)))) then
						return "fel_rush meta 6";
					end
				end
				v116 = 1 + 0;
			end
		end
	end
	local function v103()
		local v117 = 0 - 0;
		local v118;
		while true do
			if (((40 + 1) <= (1597 + 1421)) and (v117 == (1 + 0))) then
				if (((2716 - (47 + 524)) <= (2664 + 1440)) and v118) then
					return v118;
				end
				if (((7350 - 4661) < (7244 - 2399)) and (v71 < v97)) then
					if ((v72 and ((v31 and v73) or not v73)) or ((5295 - 2973) > (4348 - (1165 + 561)))) then
						local v178 = 0 + 0;
						while true do
							if ((v178 == (0 - 0)) or ((1730 + 2804) == (2561 - (341 + 138)))) then
								v28 = v99();
								if (v28 or ((425 + 1146) > (3852 - 1985))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v117 = 328 - (89 + 237);
			end
			if ((v117 == (6 - 4)) or ((5587 - 2933) >= (3877 - (581 + 300)))) then
				if (((5198 - (855 + 365)) > (4997 - 2893)) and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and v82.TheHunt:IsCastable() and v56 and v15:DebuffDown(v82.EssenceBreakDebuff) and (v10.CombatTime() > (2 + 3))) then
					if (((4230 - (1030 + 205)) > (1447 + 94)) and v21(v82.TheHunt, not v15:IsInRange(38 + 2))) then
						return "the_hunt cooldown 4";
					end
				end
				if (((3535 - (156 + 130)) > (2165 - 1212)) and ((v31 and v57) or not v57) and v54 and ((not v33 and v81) or not v81) and not v14:IsMoving() and v82.ElysianDecree:IsCastable() and (v15:DebuffDown(v82.EssenceBreakDebuff)) and (v88 > v61)) then
					if ((v60 == "player") or ((5516 - 2243) > (9365 - 4792))) then
						if (v21(v84.ElysianDecreePlayer, not v15:IsInRange(3 + 5)) or ((1838 + 1313) < (1353 - (10 + 59)))) then
							return "elysian_decree cooldown 6 (Player)";
						end
					elseif ((v60 == "cursor") or ((524 + 1326) == (7529 - 6000))) then
						if (((1984 - (671 + 492)) < (1691 + 432)) and v21(v84.ElysianDecreeCursor, not v15:IsInRange(1245 - (369 + 846)))) then
							return "elysian_decree cooldown 6 (Cursor)";
						end
					end
				end
				break;
			end
			if (((239 + 663) < (1985 + 340)) and (v117 == (1945 - (1036 + 909)))) then
				if (((683 + 175) <= (4972 - 2010)) and ((v31 and v58) or not v58) and v82.Metamorphosis:IsCastable() and v55 and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (203 - (11 + 192)))) and (((not v82.Demonic:IsAvailable() or v14:PrevGCDP(1 + 0, v82.DeathSweep) or v14:PrevGCDP(177 - (135 + 40), v82.DeathSweep) or v14:PrevGCDP(6 - 3, v82.DeathSweep)) and v82.EyeBeam:CooldownDown() and (not v82.EssenceBreak:IsAvailable() or v15:DebuffUp(v82.EssenceBreakDebuff)) and v14:BuffDown(v82.FelBarrage)) or not v82.ChaoticTransformation:IsAvailable() or (v96 < (19 + 11)))) then
					if (v21(v84.MetamorphosisPlayer, not v15:IsInRange(17 - 9)) or ((5915 - 1969) < (1464 - (50 + 126)))) then
						return "metamorphosis cooldown 2";
					end
				end
				v118 = v23.HandleDPSPotion(v14:BuffUp(v82.MetamorphosisBuff));
				v117 = 2 - 1;
			end
		end
	end
	local function v104()
		if ((v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v14:PrevGCDP(1 + 0, v82.DeathSweep) and (v82.Felblade:CooldownRemains() == (1413 - (1233 + 180)))) or ((4211 - (522 + 447)) == (1988 - (107 + 1314)))) then
			if (v21(v82.VengefulRetreat, not v15:IsInRange(4 + 4), true, true) or ((2580 - 1733) >= (537 + 726))) then
				return "vengeful_retreat opener 1";
			end
		end
		if ((v82.Metamorphosis:IsCastable() and v55 and ((v31 and v58) or not v58) and (v14:PrevGCDP(1 - 0, v82.DeathSweep) or (not v82.ChaoticTransformation:IsAvailable() and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (7 - 5)))) or not v82.Demonic:IsAvailable())) or ((4163 - (716 + 1194)) == (32 + 1819))) then
			if (v21(v84.MetamorphosisPlayer, not v15:IsInRange(1 + 7)) or ((2590 - (74 + 429)) > (4575 - 2203))) then
				return "metamorphosis opener 2";
			end
		end
		if ((v82.Felblade:IsCastable() and v43 and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((2204 + 2241) < (9497 - 5348))) then
			if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((1287 + 531) == (261 - 176))) then
				return "felblade opener 3";
			end
		end
		if (((1557 - 927) < (2560 - (279 + 154))) and v82.ImmolationAura:IsCastable() and v46 and (v82.ImmolationAura:Charges() == (780 - (454 + 324))) and v14:BuffDown(v82.UnboundChaosBuff) and (v14:BuffDown(v82.InertiaBuff) or (v88 > (2 + 0)))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(25 - (12 + 5))) or ((1045 + 893) == (6405 - 3891))) then
				return "immolation_aura opener 4";
			end
		end
		if (((1573 + 2682) >= (1148 - (277 + 816))) and v82.Annihilation:IsCastable() and v34 and v14:BuffUp(v82.InnerDemonBuff) and (not v82.ChaoticTransformation:IsAvailable() or v82.Metamorphosis:CooldownUp())) then
			if (((12814 - 9815) > (2339 - (1058 + 125))) and v21(v82.Annihilation, not v15:IsInMeleeRange(1 + 4))) then
				return "annihilation opener 5";
			end
		end
		if (((3325 - (815 + 160)) > (4955 - 3800)) and v82.EyeBeam:IsCastable() and v41 and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff) and (not v14:BuffUp(v82.MetamorphosisBuff) or (v82.BladeDance:CooldownRemains() > (0 - 0)))) then
			if (((962 + 3067) <= (14186 - 9333)) and v21(v82.EyeBeam, not v15:IsInRange(1906 - (41 + 1857)))) then
				return "eye_beam opener 6";
			end
		end
		if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Inertia:IsAvailable() and (v14:BuffDown(v82.InertiaBuff) or (v88 > (1895 - (1222 + 671)))) and v14:BuffUp(v82.UnboundChaosBuff)) or ((1333 - 817) > (4935 - 1501))) then
			if (((5228 - (229 + 953)) >= (4807 - (1111 + 663))) and v21(v82.FelRush, not v15:IsInRange(1594 - (874 + 705)))) then
				return "fel_rush opener 7";
			end
		end
		if ((v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80)) or ((381 + 2338) <= (988 + 459))) then
			if (v21(v82.TheHunt, not v15:IsInRange(83 - 43)) or ((117 + 4017) < (4605 - (642 + 37)))) then
				return "the_hunt opener 8";
			end
		end
		if ((v82.EssenceBreak:IsCastable() and v40) or ((38 + 126) >= (446 + 2339))) then
			if (v21(v82.EssenceBreak, not v15:IsInMeleeRange(12 - 7)) or ((979 - (233 + 221)) == (4876 - 2767))) then
				return "essence_break opener 9";
			end
		end
		if (((30 + 3) == (1574 - (718 + 823))) and v82.DeathSweep:IsCastable() and v38) then
			if (((1922 + 1132) <= (4820 - (266 + 539))) and v21(v82.DeathSweep, not v15:IsInMeleeRange(13 - 8))) then
				return "death_sweep opener 10";
			end
		end
		if (((3096 - (636 + 589)) < (8027 - 4645)) and v82.Annihilation:IsCastable() and v34) then
			if (((2666 - 1373) <= (1717 + 449)) and v21(v82.Annihilation, not v15:IsInMeleeRange(2 + 3))) then
				return "annihilation opener 11";
			end
		end
		if ((v82.DemonsBite:IsCastable() and v39) or ((3594 - (657 + 358)) < (325 - 202))) then
			if (v21(v82.DemonsBite, not v15:IsInMeleeRange(11 - 6)) or ((2033 - (1151 + 36)) >= (2287 + 81))) then
				return "demons_bite opener 12";
			end
		end
	end
	local function v105()
		local v119 = 0 + 0;
		while true do
			if ((v119 == (14 - 9)) or ((5844 - (1552 + 280)) <= (4192 - (64 + 770)))) then
				if (((1015 + 479) <= (6821 - 3816)) and v82.DemonsBite:IsCastable() and v39) then
					if (v21(v82.DemonsBite, not v15:IsInMeleeRange(1 + 4)) or ((4354 - (157 + 1086)) == (4270 - 2136))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if (((10314 - 7959) == (3612 - 1257)) and (v119 == (2 - 0))) then
				if ((v82.GlaiveTempest:IsReady() and v14:BuffDown(v82.FelBarrage) and (v88 > (820 - (599 + 220))) and v45) or ((1170 - 582) <= (2363 - (1813 + 118)))) then
					if (((3507 + 1290) >= (5112 - (841 + 376))) and v21(v82.GlaiveTempest, not v15:IsInMeleeRange(6 - 1))) then
						return "glaive_tempest fel_barrage 12";
					end
				end
				if (((831 + 2746) == (9763 - 6186)) and v82.BladeDance:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v35) then
					if (((4653 - (464 + 395)) > (9477 - 5784)) and v21(v82.BladeDance, not v15:IsInMeleeRange(4 + 4))) then
						return "blade_dance fel_barrage 14";
					end
				end
				if ((v82.FelBarrage:IsReady() and (v14:Fury() > (937 - (467 + 370))) and v42) or ((2634 - 1359) == (3010 + 1090))) then
					if (v21(v82.FelBarrage, not v15:IsInMeleeRange(17 - 12)) or ((249 + 1342) >= (8329 - 4749))) then
						return "fel_barrage fel_barrage 16";
					end
				end
				if (((1503 - (150 + 370)) <= (3090 - (74 + 1208))) and v82.FelRush:IsCastable() and v44 and v14:BuffUp(v82.UnboundChaosBuff) and (v14:Fury() > (49 - 29)) and v14:BuffUp(v82.FelBarrage) and v32 and ((not v33 and v80) or not v80)) then
					if (v21(v82.FelRush, not v15:IsInRange(71 - 56)) or ((1530 + 620) <= (1587 - (14 + 376)))) then
						return "fel_rush fel_barrage 18";
					end
				end
				v119 = 4 - 1;
			end
			if (((2439 + 1330) >= (1031 + 142)) and (v119 == (3 + 0))) then
				if (((4351 - 2866) == (1118 + 367)) and v82.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (118 - (23 + 55))) and v14:BuffUp(v82.FelBarrage) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) then
					if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((7856 - 4541) <= (1857 + 925))) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(8 + 0)) or ((1358 - 482) >= (933 + 2031))) then
							return "sigil_of_flame fel_barrage 20";
						end
					elseif ((v79 == "cursor") or ((3133 - (652 + 249)) > (6682 - 4185))) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(1908 - (708 + 1160))) or ((5727 - 3617) <= (604 - 272))) then
							return "sigil_of_flame fel_barrage 20";
						end
					end
				end
				if (((3713 - (10 + 17)) > (713 + 2459)) and v82.Felblade:IsCastable() and v14:BuffUp(v82.FelBarrage) and (v14:FuryDeficit() > (1772 - (1400 + 332))) and v43) then
					if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((8581 - 4107) < (2728 - (242 + 1666)))) then
						return "felblade fel_barrage 22";
					end
				end
				if (((1832 + 2447) >= (1057 + 1825)) and v82.DeathSweep:IsReady() and (((v14:Fury() - v94) - (30 + 5)) > (940 - (850 + 90))) and ((v14:BuffRemains(v82.FelBarrage) < (4 - 1)) or v92 or (v14:Fury() > (1470 - (360 + 1030))) or (v93 > (16 + 2))) and v38) then
					if (v21(v82.DeathSweep, not v15:IsInMeleeRange(13 - 8)) or ((2790 - 761) >= (5182 - (909 + 752)))) then
						return "death_sweep fel_barrage 24";
					end
				end
				if ((v82.GlaiveTempest:IsReady() and (((v14:Fury() - v94) - (1253 - (109 + 1114))) > (0 - 0)) and ((v14:BuffRemains(v82.FelBarrage) < (2 + 1)) or v92 or (v14:Fury() > (322 - (6 + 236))) or (v93 > (12 + 6))) and v45) or ((1640 + 397) >= (10947 - 6305))) then
					if (((3004 - 1284) < (5591 - (1076 + 57))) and v21(v82.GlaiveTempest, not v15:IsInMeleeRange(1 + 4), false, true)) then
						return "glaive_tempest fel_barrage 26";
					end
				end
				v119 = 693 - (579 + 110);
			end
			if ((v119 == (1 + 3)) or ((386 + 50) > (1604 + 1417))) then
				if (((1120 - (174 + 233)) <= (2365 - 1518)) and v82.BladeDance:IsReady() and (((v14:Fury() - v94) - (61 - 26)) > (0 + 0)) and ((v14:BuffRemains(v82.FelBarrage) < (1177 - (663 + 511))) or v92 or (v14:Fury() > (72 + 8)) or (v93 > (4 + 14))) and v35) then
					if (((6640 - 4486) <= (2441 + 1590)) and v21(v82.BladeDance, not v15:IsInMeleeRange(18 - 10))) then
						return "blade_dance fel_barrage 28";
					end
				end
				if (((11172 - 6557) == (2203 + 2412)) and v82.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (77 - 37)) and v14:BuffUp(v82.FelBarrage)) then
					if (v21(v82.ArcaneTorrent) or ((2702 + 1088) == (46 + 454))) then
						return "arcane_torrent fel_barrage 30";
					end
				end
				if (((811 - (478 + 244)) < (738 - (440 + 77))) and v82.FelRush:IsCastable() and v44 and (v14:BuffUp(v82.UnboundChaosBuff)) and v32 and ((not v33 and v80) or not v80)) then
					if (((934 + 1120) >= (5200 - 3779)) and v21(v82.FelRush, not v15:IsInRange(1564 - (655 + 901)))) then
						return "fel_rush fel_barrage 32";
					end
				end
				if (((129 + 563) < (2342 + 716)) and v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and (v14:Fury() > (28 + 12))) then
					if (v21(v82.TheHunt, not v15:IsInRange(161 - 121)) or ((4699 - (695 + 750)) == (5651 - 3996))) then
						return "the_hunt fel_barrage 31";
					end
				end
				v119 = 7 - 2;
			end
			if ((v119 == (0 - 0)) or ((1647 - (285 + 66)) == (11445 - 6535))) then
				v92 = (v82.Felblade:CooldownRemains() < v95) or (v82.SigilOfFlame:CooldownRemains() < v95);
				v93 = (((1311 - (682 + 628)) / ((1.6 + 1) * v14:SpellHaste())) * (311 - (176 + 123))) + (v14:BuffStack(v82.ImmolationAura) * (3 + 3)) + (v24(v14:BuffUp(v82.TacticalRetreatBuff)) * (8 + 2));
				v94 = v95 * (301 - (239 + 30));
				if (((916 + 2452) == (3238 + 130)) and v82.Annihilation:IsReady() and (v14:BuffUp(v82.InnerDemonBuff)) and v34) then
					if (((4677 - 2034) < (11902 - 8087)) and v21(v82.Annihilation, not v15:IsInMeleeRange(320 - (306 + 9)))) then
						return "annihilation fel_barrage 2";
					end
				end
				v119 = 3 - 2;
			end
			if (((333 + 1580) > (303 + 190)) and (v119 == (1 + 0))) then
				if (((13597 - 8842) > (4803 - (1140 + 235))) and v82.EyeBeam:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v41) then
					if (((879 + 502) <= (2173 + 196)) and v21(v82.EyeBeam, not v15:IsInRange(3 + 5))) then
						return "eye_beam fel_barrage 4";
					end
				end
				if ((v82.EssenceBreak:IsCastable() and v14:BuffDown(v82.FelBarrage) and v14:BuffUp(v82.MetamorphosisBuff) and v40) or ((4895 - (33 + 19)) == (1475 + 2609))) then
					if (((13994 - 9325) > (160 + 203)) and v21(v82.EssenceBreak, not v15:IsInMeleeRange(9 - 4))) then
						return "essence_break fel_barrage 6";
					end
				end
				if ((v82.DeathSweep:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v38) or ((1761 + 116) >= (3827 - (586 + 103)))) then
					if (((432 + 4310) >= (11163 - 7537)) and v21(v82.DeathSweep, not v15:IsInMeleeRange(1493 - (1309 + 179)))) then
						return "death_sweep fel_barrage 8";
					end
				end
				if ((v82.ImmolationAura:IsCastable() and v14:BuffDown(v82.UnboundChaosBuff) and ((v88 > (2 - 0)) or v14:BuffUp(v82.FelBarrage)) and v46) or ((1977 + 2563) == (2459 - 1543))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(7 + 1)) or ((2455 - 1299) > (8657 - 4312))) then
						return "immolation_aura fel_barrage 10";
					end
				end
				v119 = 611 - (295 + 314);
			end
		end
	end
	local function v106()
		local v120 = 0 - 0;
		while true do
			if (((4199 - (1300 + 662)) < (13342 - 9093)) and (v120 == (1755 - (1178 + 577)))) then
				v91 = v82.FelBarrage:IsAvailable() and (((v82.FelBarrage:CooldownRemains() < (v95 * (4 + 3))) and (v82.Metamorphosis:CooldownDown() or (v88 > (5 - 3)))) or v14:BuffUp(v82.FelBarrage));
				v28 = v103();
				if (v28 or ((4088 - (851 + 554)) < (21 + 2))) then
					return v28;
				end
				v120 = 2 - 1;
			end
			if (((1513 - 816) <= (1128 - (115 + 187))) and ((7 + 1) == v120)) then
				if (((1047 + 58) <= (4634 - 3458)) and v82.ChaosStrike:IsCastable() and v36 and ((v82.EyeBeam:CooldownRemains() > (v95 * (1163 - (160 + 1001)))) or (v14:Fury() > (70 + 10)))) then
					if (((2332 + 1047) <= (7803 - 3991)) and v21(v82.ChaosStrike, not v15:IsInMeleeRange(363 - (237 + 121)))) then
						return "chaos_strike rotation 43";
					end
				end
				if ((v82.ImmolationAura:IsCastable() and v46 and not v82.Inertia:IsAvailable()) or ((1685 - (525 + 372)) >= (3063 - 1447))) then
					if (((6091 - 4237) <= (3521 - (96 + 46))) and v21(v82.ImmolationAura, not v15:IsInRange(785 - (643 + 134)))) then
						return "immolation_aura rotation 45";
					end
				end
				if (((1643 + 2906) == (10907 - 6358)) and v47 and ((not v33 and v81) or not v81) and v15:IsInRange(29 - 21) and v15:DebuffDown(v82.EssenceBreakDebuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > (24 + 1)) or (v88 == (1 - 0))) and v82.SigilOfFlame:IsCastable()) then
					if ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((6177 - 3155) >= (3743 - (316 + 403)))) then
						if (((3204 + 1616) > (6043 - 3845)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(3 + 5))) then
							return "sigil_of_flame rotation 47";
						end
					elseif ((v79 == "cursor") or ((2671 - 1610) >= (3466 + 1425))) then
						if (((440 + 924) <= (15498 - 11025)) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(191 - 151))) then
							return "sigil_of_flame rotation 47";
						end
					end
				end
				v120 = 18 - 9;
			end
			if ((v120 == (1 + 6)) or ((7077 - 3482) <= (1 + 2))) then
				if ((v82.Felblade:IsCastable() and v43) or ((13745 - 9073) == (3869 - (12 + 5)))) then
					if (((6054 - 4495) == (3325 - 1766)) and v21(v82.Felblade, not v15:IsInMeleeRange(10 - 5))) then
						return "felblade rotation 37";
					end
				end
				if ((v82.ThrowGlaive:IsCastable() and v48 and (v82.ThrowGlaive:FullRechargeTime() <= v82.BladeDance:CooldownRemains()) and (v82.Metamorphosis:CooldownRemains() > (12 - 7)) and v82.Soulscar:IsAvailable() and v14:HasTier(7 + 24, 1975 - (1656 + 317)) and not v14:PrevGCDP(1 + 0, v82.VengefulRetreat)) or ((1404 + 348) <= (2095 - 1307))) then
					if (v21(v82.ThrowGlaive, not v15:IsInMeleeRange(147 - 117)) or ((4261 - (5 + 349)) == (840 - 663))) then
						return "throw_glaive rotation 39";
					end
				end
				if (((4741 - (266 + 1005)) > (366 + 189)) and v82.ThrowGlaive:IsCastable() and v48 and not v14:HasTier(105 - 74, 2 - 0) and ((v88 > (1697 - (561 + 1135))) or v82.Soulscar:IsAvailable()) and not v14:PrevGCDP(1 - 0, v82.VengefulRetreat)) then
					if (v21(v82.ThrowGlaive, not v15:IsInMeleeRange(98 - 68)) or ((2038 - (507 + 559)) == (1618 - 973))) then
						return "throw_glaive rotation 41";
					end
				end
				v120 = 24 - 16;
			end
			if (((3570 - (212 + 176)) >= (3020 - (250 + 655))) and (v120 == (13 - 8))) then
				if (((6802 - 2909) < (6928 - 2499)) and v82.EyeBeam:IsCastable() and v41 and not v82.EssenceBreak:IsAvailable() and (not v82.ChaoticTransformation:IsAvailable() or (v82.Metamorphosis:CooldownRemains() < ((1961 - (1869 + 87)) + ((10 - 7) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.Metamorphosis:CooldownRemains() > (1916 - (484 + 1417))))) then
					if (v21(v82.EyeBeam, not v15:IsInRange(16 - 8)) or ((4804 - 1937) < (2678 - (48 + 725)))) then
						return "eye_beam rotation 25";
					end
				end
				if ((v82.EyeBeam:IsCastable() and v41 and ((v82.EssenceBreak:IsAvailable() and ((v82.EssenceBreak:CooldownRemains() < ((v95 * (2 - 0)) + ((13 - 8) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.ShatteredDestiny:IsAvailable() and (v82.EssenceBreak:CooldownRemains() > (6 + 4)))) and ((v82.BladeDance:CooldownRemains() < (18 - 11)) or (v88 > (1 + 0))) and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (3 + 7)) or (v88 > (854 - (152 + 701)))) and (not v82.Inertia:IsAvailable() or v14:BuffUp(v82.UnboundChaosBuff) or ((v82.ImmolationAura:Charges() == (1311 - (430 + 881))) and (v82.ImmolationAura:Recharge() > (2 + 3))))) or (v97 < (905 - (557 + 338))))) or ((531 + 1265) >= (11415 - 7364))) then
					if (((5669 - 4050) <= (9978 - 6222)) and v21(v82.EyeBeam, not v15:IsInRange(17 - 9))) then
						return "eye_beam rotation 27";
					end
				end
				if (((1405 - (499 + 302)) == (1470 - (39 + 827))) and v82.BladeDance:IsCastable() and v35 and ((v82.EyeBeam:CooldownRemains() > v95) or v82.EyeBeam:CooldownUp())) then
					if (v21(v82.BladeDance, not v15:IsInRange(21 - 13)) or ((10013 - 5529) == (3574 - 2674))) then
						return "blade_dance rotation 29";
					end
				end
				v120 = 8 - 2;
			end
			if (((1 + 1) == v120) or ((13050 - 8591) <= (179 + 934))) then
				if (((5746 - 2114) > (3502 - (103 + 1))) and v82.ImmolationAura:IsCastable() and v46 and (v88 > (556 - (475 + 79))) and v82.Ragefire:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > v82.ImmolationAura:Recharge())) and v15:DebuffDown(v82.EssenceBreakDebuff)) then
					if (((8824 - 4742) <= (15734 - 10817)) and v21(v82.ImmolationAura, not v15:IsInRange(2 + 6))) then
						return "immolation_aura rotation 3";
					end
				end
				if (((4253 + 579) >= (2889 - (1395 + 108))) and v82.ImmolationAura:IsCastable() and v46 and (v88 > (5 - 3)) and v82.Ragefire:IsAvailable() and v15:DebuffDown(v82.EssenceBreakDebuff)) then
					if (((1341 - (7 + 1197)) == (60 + 77)) and v21(v82.ImmolationAura, not v15:IsInRange(3 + 5))) then
						return "immolation_aura rotation 5";
					end
				end
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v88 > (321 - (27 + 292))) and (not v82.Inertia:IsAvailable() or ((v82.EyeBeam:CooldownRemains() + (5 - 3)) > v14:BuffRemains(v82.UnboundChaosBuff)))) or ((2002 - 432) >= (18167 - 13835))) then
					if (v21(v82.FelRush, not v15:IsInRange(29 - 14)) or ((7739 - 3675) <= (1958 - (43 + 96)))) then
						return "fel_rush rotation 7";
					end
				end
				v120 = 12 - 9;
			end
			if ((v120 == (6 - 3)) or ((4138 + 848) < (445 + 1129))) then
				if (((8747 - 4321) > (66 + 106)) and v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v82.Initiative:IsAvailable() and ((v82.EyeBeam:CooldownRemains() > (28 - 13)) or ((v82.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v82.Metamorphosis:CooldownRemains() > (4 + 6)) or (v82.BladeDance:CooldownRemains() < (v95 * (1 + 1)))))) and (v10.CombatTime() > (1755 - (1414 + 337)))) then
					if (((2526 - (1642 + 298)) > (1185 - 730)) and v21(v82.VengefulRetreat, not v15:IsInRange(22 - 14), true, true)) then
						return "vengeful_retreat rotation 9";
					end
				end
				if (((2450 - 1624) == (272 + 554)) and (v91 or (not v82.DemonBlades:IsAvailable() and v82.FelBarrage:IsAvailable() and (v14:BuffUp(v82.FelBarrage) or v82.FelBarrage:CooldownUp()) and v14:BuffDown(v82.MetamorphosisBuff)))) then
					local v171 = 0 + 0;
					while true do
						if ((v171 == (972 - (357 + 615))) or ((2822 + 1197) > (10896 - 6455))) then
							v28 = v105();
							if (((1729 + 288) < (9131 - 4870)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((3772 + 944) > (6 + 74)) and v14:BuffUp(v82.MetamorphosisBuff)) then
					local v172 = 0 + 0;
					while true do
						if ((v172 == (1301 - (384 + 917))) or ((4204 - (128 + 569)) == (4815 - (1407 + 136)))) then
							v28 = v102();
							if (v28 or ((2763 - (687 + 1200)) >= (4785 - (556 + 1154)))) then
								return v28;
							end
							break;
						end
					end
				end
				v120 = 14 - 10;
			end
			if (((4447 - (9 + 86)) > (2975 - (275 + 146))) and (v120 == (1 + 3))) then
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and (v82.BladeDance:CooldownRemains() < (68 - (29 + 35))) and (v82.EyeBeam:CooldownRemains() > (22 - 17)) and ((v82.ImmolationAura:Charges() > (0 - 0)) or ((v82.ImmolationAura:Recharge() + (8 - 6)) < v82.EyeBeam:CooldownRemains()) or (v82.EyeBeam:CooldownRemains() > (v14:BuffRemains(v82.UnboundChaosBuff) - (2 + 0))))) or ((5418 - (53 + 959)) < (4451 - (312 + 96)))) then
					if (v21(v82.FelRush, not v15:IsInRange(26 - 11)) or ((2174 - (147 + 138)) >= (4282 - (813 + 86)))) then
						return "fel_rush rotation 11";
					end
				end
				if (((1710 + 182) <= (5065 - 2331)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Momentum:IsAvailable() and (v82.EyeBeam:CooldownRemains() < (v95 * (494 - (18 + 474))))) then
					if (((649 + 1274) < (7239 - 5021)) and v21(v82.FelRush, not v15:IsInRange(1101 - (860 + 226)))) then
						return "fel_rush rotation 13";
					end
				end
				if (((2476 - (121 + 182)) > (47 + 332)) and v82.ImmolationAura:IsCastable() and v46 and ((v14:BuffDown(v82.UnboundChaosBuff) and (v82.ImmolationAura:FullRechargeTime() < (v95 * (1242 - (988 + 252))))) or ((v88 > (1 + 0)) and v14:BuffDown(v82.UnboundChaosBuff)) or (v82.Inertia:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (v82.EyeBeam:CooldownRemains() < (2 + 3))) or (v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and v14:BuffDown(v82.UnboundChaosBuff) and ((v82.ImmolationAura:Recharge() + (1975 - (49 + 1921))) < v82.EyeBeam:CooldownRemains()) and v82.BladeDance:CooldownDown() and (v82.BladeDance:CooldownRemains() < (894 - (223 + 667))) and (v82.ImmolationAura:ChargesFractional() > (53 - (51 + 1)))))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(13 - 5)) or ((5548 - 2957) == (4534 - (146 + 979)))) then
						return "immolation_aura rotation 15";
					end
				end
				v120 = 2 + 3;
			end
			if (((5119 - (311 + 294)) > (9269 - 5945)) and (v120 == (1 + 0))) then
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v14:BuffRemains(v82.UnboundChaosBuff) < (v95 * (1445 - (496 + 947))))) or ((1566 - (1233 + 125)) >= (1960 + 2868))) then
					if (v21(v82.FelRush, not v15:IsInRange(14 + 1)) or ((301 + 1282) > (5212 - (963 + 682)))) then
						return "fel_rush rotation 1";
					end
				end
				if (((v82.EyeBeam:CooldownUp() or v82.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (13 + 2))) or ((2817 - (504 + 1000)) == (535 + 259))) then
					local v173 = 0 + 0;
					while true do
						if (((300 + 2874) > (4278 - 1376)) and ((0 + 0) == v173)) then
							v28 = v104();
							if (((2397 + 1723) <= (4442 - (156 + 26))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v91 or ((509 + 374) > (7475 - 2697))) then
					v28 = v105();
					if (v28 or ((3784 - (149 + 15)) >= (5851 - (890 + 70)))) then
						return v28;
					end
				end
				v120 = 119 - (39 + 78);
			end
			if (((4740 - (14 + 468)) > (2060 - 1123)) and ((16 - 10) == v120)) then
				if ((v82.GlaiveTempest:IsCastable() and v45 and (v88 >= (2 + 0))) or ((2924 + 1945) < (193 + 713))) then
					if (v21(v82.GlaiveTempest, not v15:IsInRange(4 + 4)) or ((321 + 904) > (8092 - 3864))) then
						return "glaive_tempest rotation 31";
					end
				end
				if (((3290 + 38) > (7864 - 5626)) and v47 and ((not v33 and v81) or not v81) and (v88 > (1 + 2)) and v82.SigilOfFlame:IsCastable()) then
					if (((3890 - (12 + 39)) > (1308 + 97)) and ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(24 - 16)) or ((4604 - 3311) <= (151 + 356))) then
							return "sigil_of_flame rotation 33";
						end
					elseif ((v79 == "cursor") or ((1525 + 1371) < (2041 - 1236))) then
						if (((1543 + 773) == (11192 - 8876)) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(1750 - (1596 + 114)))) then
							return "sigil_of_flame rotation 33";
						end
					end
				end
				if ((v82.ChaosStrike:IsCastable() and v36 and v15:DebuffUp(v82.EssenceBreakDebuff)) or ((6709 - 4139) == (2246 - (164 + 549)))) then
					if (v21(v82.ChaosStrike, not v15:IsInMeleeRange(1443 - (1059 + 379))) or ((1095 - 212) == (757 + 703))) then
						return "chaos_strike rotation 35";
					end
				end
				v120 = 2 + 5;
			end
			if ((v120 == (401 - (145 + 247))) or ((3791 + 828) <= (462 + 537))) then
				if ((v82.DemonsBite:IsCastable() and v39) or ((10109 - 6699) > (790 + 3326))) then
					if (v21(v82.DemonsBite, not v15:IsInMeleeRange(5 + 0)) or ((1465 - 562) >= (3779 - (254 + 466)))) then
						return "demons_bite rotation 49";
					end
				end
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (568 - (544 + 16))) or (v82.FelRush:ChargesFractional() > (2.01 - 1)))) or ((4604 - (294 + 334)) < (3110 - (236 + 17)))) then
					if (((2126 + 2804) > (1796 + 511)) and v21(v82.FelRush, not v15:IsInRange(56 - 41))) then
						return "fel_rush rotation 51";
					end
				end
				if ((v82.ArcaneTorrent:IsCastable() and v15:IsInRange(37 - 29) and v15:DebuffDown(v82.EssenceBreakDebuff) and (v14:Fury() < (52 + 48))) or ((3333 + 713) < (2085 - (413 + 381)))) then
					if (v21(v82.ArcaneTorrent, not v15:IsInRange(1 + 7)) or ((9019 - 4778) == (9208 - 5663))) then
						return "arcane_torrent rotation 53";
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v121 = 1970 - (582 + 1388);
		while true do
			if ((v121 == (6 - 2)) or ((2898 + 1150) > (4596 - (326 + 38)))) then
				v46 = EpicSettings.Settings['useImmolationAura'];
				v47 = EpicSettings.Settings['useSigilOfFlame'];
				v48 = EpicSettings.Settings['useThrowGlaive'];
				v121 = 14 - 9;
			end
			if ((v121 == (9 - 2)) or ((2370 - (47 + 573)) >= (1225 + 2248))) then
				v59 = EpicSettings.Settings['theHuntWithCD'];
				v60 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v61 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if (((5138 - 1972) == (4830 - (1269 + 395))) and (v121 == (497 - (76 + 416)))) then
				v49 = EpicSettings.Settings['useVengefulRetreat'];
				v54 = EpicSettings.Settings['useElysianDecree'];
				v55 = EpicSettings.Settings['useMetamorphosis'];
				v121 = 449 - (319 + 124);
			end
			if (((4029 - 2266) < (4731 - (564 + 443))) and ((7 - 4) == v121)) then
				v43 = EpicSettings.Settings['useFelblade'];
				v44 = EpicSettings.Settings['useFelRush'];
				v45 = EpicSettings.Settings['useGlaiveTempest'];
				v121 = 462 - (337 + 121);
			end
			if (((166 - 109) <= (9070 - 6347)) and (v121 == (1912 - (1261 + 650)))) then
				v37 = EpicSettings.Settings['useConsumeMagic'];
				v38 = EpicSettings.Settings['useDeathSweep'];
				v39 = EpicSettings.Settings['useDemonsBite'];
				v121 = 1 + 1;
			end
			if ((v121 == (2 - 0)) or ((3887 - (772 + 1045)) == (63 + 380))) then
				v40 = EpicSettings.Settings['useEssenceBreak'];
				v41 = EpicSettings.Settings['useEyeBeam'];
				v42 = EpicSettings.Settings['useFelBarrage'];
				v121 = 147 - (102 + 42);
			end
			if ((v121 == (1850 - (1524 + 320))) or ((3975 - (1049 + 221)) == (1549 - (18 + 138)))) then
				v56 = EpicSettings.Settings['useTheHunt'];
				v57 = EpicSettings.Settings['elysianDecreeWithCD'];
				v58 = EpicSettings.Settings['metamorphosisWithCD'];
				v121 = 17 - 10;
			end
			if ((v121 == (1102 - (67 + 1035))) or ((4949 - (136 + 212)) < (259 - 198))) then
				v34 = EpicSettings.Settings['useAnnihilation'];
				v35 = EpicSettings.Settings['useBladeDance'];
				v36 = EpicSettings.Settings['useChaosStrike'];
				v121 = 1 + 0;
			end
		end
	end
	local function v108()
		local v122 = 0 + 0;
		while true do
			if ((v122 == (1605 - (240 + 1364))) or ((2472 - (1050 + 32)) >= (16938 - 12194))) then
				v53 = EpicSettings.Settings['useSigilOfMisery'];
				v62 = EpicSettings.Settings['useBlur'];
				v63 = EpicSettings.Settings['useNetherwalk'];
				v122 = 2 + 0;
			end
			if ((v122 == (1055 - (331 + 724))) or ((162 + 1841) > (4478 - (269 + 375)))) then
				v50 = EpicSettings.Settings['useChaosNova'];
				v51 = EpicSettings.Settings['useDisrupt'];
				v52 = EpicSettings.Settings['useFelEruption'];
				v122 = 726 - (267 + 458);
			end
			if ((v122 == (1 + 1)) or ((299 - 143) > (4731 - (667 + 151)))) then
				v64 = EpicSettings.Settings['blurHP'] or (1497 - (1410 + 87));
				v65 = EpicSettings.Settings['netherwalkHP'] or (1897 - (1504 + 393));
				v79 = EpicSettings.Settings['sigilSetting'] or "";
				v122 = 8 - 5;
			end
			if (((505 - 310) == (991 - (461 + 335))) and (v122 == (1 + 2))) then
				v81 = EpicSettings.Settings['RMBAOE'];
				v80 = EpicSettings.Settings['RMBMovement'];
				break;
			end
		end
	end
	local function v109()
		local v123 = 1761 - (1730 + 31);
		while true do
			if (((4772 - (728 + 939)) >= (6360 - 4564)) and ((5 - 2) == v123)) then
				v77 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v76 = EpicSettings.Settings['healingPotionHP'] or (1068 - (138 + 930));
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v123 = 4 + 0;
			end
			if (((3424 + 955) >= (1827 + 304)) and (v123 == (8 - 6))) then
				v73 = EpicSettings.Settings['trinketsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v123 = 1769 - (459 + 1307);
			end
			if (((5714 - (474 + 1396)) >= (3567 - 1524)) and (v123 == (0 + 0))) then
				v71 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v66 = EpicSettings.Settings['dispelBuffs'];
				v68 = EpicSettings.Settings['InterruptWithStun'];
				v123 = 2 - 1;
			end
			if ((v123 == (1 + 0)) or ((10789 - 7557) <= (11910 - 9179))) then
				v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v70 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['useTrinkets'];
				v123 = 593 - (562 + 29);
			end
			if (((4182 + 723) == (6324 - (374 + 1045))) and (v123 == (4 + 0))) then
				v67 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v110()
		local v124 = 0 - 0;
		while true do
			if ((v124 == (642 - (448 + 190))) or ((1336 + 2800) >= (1992 + 2419))) then
				if (v67 or ((1928 + 1030) == (15444 - 11427))) then
					local v174 = 0 - 0;
					while true do
						if (((2722 - (1307 + 187)) >= (3223 - 2410)) and (v174 == (0 - 0))) then
							v28 = v23.HandleIncorporeal(v82.Imprison, v84.ImprisonMouseover, 91 - 61, true);
							if (v28 or ((4138 - (232 + 451)) > (3868 + 182))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((215 + 28) == (807 - (510 + 54))) and (v14:PrevGCDP(1 - 0, v82.VengefulRetreat) or v14:PrevGCDP(38 - (13 + 23), v82.VengefulRetreat) or (v14:PrevGCDP(5 - 2, v82.VengefulRetreat) and v14:IsMoving()))) then
					if ((v82.Felblade:IsCastable() and v43) or ((389 - 118) > (2855 - 1283))) then
						if (((3827 - (830 + 258)) < (11616 - 8323)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
							return "felblade rotation 1";
						end
					end
				elseif ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((2467 + 1475) < (965 + 169))) then
					if ((not v14:AffectingCombat() and v29) or ((4134 - (860 + 581)) == (18343 - 13370))) then
						v28 = v101();
						if (((1704 + 442) == (2387 - (237 + 4))) and v28) then
							return v28;
						end
					end
					if ((v82.ConsumeMagic:IsAvailable() and v37 and v82.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) or ((5273 - 3029) == (8156 - 4932))) then
						if (v21(v82.ConsumeMagic, not v15:IsSpellInRange(v82.ConsumeMagic)) or ((9297 - 4393) <= (1569 + 347))) then
							return "greater_purge damage";
						end
					end
					if (((52 + 38) <= (4020 - 2955)) and v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v15:NPCID())) then
						if (((2061 + 2741) == (2613 + 2189)) and v21(v82.ThrowGlaive, not v15:IsSpellInRange(v82.ThrowGlaive))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v16:NPCID())) or ((3706 - (85 + 1341)) <= (871 - 360))) then
						if (v21(v84.ThrowGlaiveMouseover, not v15:IsSpellInRange(v82.ThrowGlaive)) or ((4733 - 3057) <= (835 - (45 + 327)))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v28 = v106();
					if (((7300 - 3431) == (4371 - (444 + 58))) and v28) then
						return v28;
					end
				end
				break;
			end
			if (((504 + 654) <= (450 + 2163)) and ((0 + 0) == v124)) then
				v108();
				v107();
				v109();
				v29 = EpicSettings.Toggles['ooc'];
				v124 = 2 - 1;
			end
			if (((1734 - (64 + 1668)) == v124) or ((4337 - (1227 + 746)) <= (6144 - 4145))) then
				if (v14:IsDeadOrGhost() or ((9134 - 4212) < (688 - (415 + 79)))) then
					return v28;
				end
				v86 = v14:GetEnemiesInMeleeRange(1 + 7);
				v87 = v14:GetEnemiesInMeleeRange(511 - (142 + 349));
				if (v30 or ((896 + 1195) < (42 - 11))) then
					local v175 = 0 + 0;
					while true do
						if (((0 + 0) == v175) or ((6617 - 4187) >= (6736 - (1710 + 154)))) then
							v88 = ((#v86 > (318 - (200 + 118))) and #v86) or (1 + 0);
							v89 = #v87;
							break;
						end
					end
				else
					local v176 = 0 - 0;
					while true do
						if ((v176 == (0 - 0)) or ((4239 + 531) < (1717 + 18))) then
							v88 = 1 + 0;
							v89 = 1 + 0;
							break;
						end
					end
				end
				v124 = 6 - 3;
			end
			if ((v124 == (1251 - (363 + 887))) or ((7750 - 3311) <= (11185 - 8835))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['movement'];
				if (IsMouseButtonDown("RightButton") or ((692 + 3787) < (10449 - 5983))) then
					v33 = true;
				else
					v33 = false;
				end
				v124 = 2 + 0;
			end
			if (((4211 - (674 + 990)) > (352 + 873)) and (v124 == (2 + 1))) then
				v95 = v14:GCD() + (0.05 - 0);
				if (((5726 - (507 + 548)) > (3511 - (289 + 548))) and (v23.TargetIsValid() or v14:AffectingCombat())) then
					local v177 = 1818 - (821 + 997);
					while true do
						if (((255 - (195 + 60)) == v177) or ((994 + 2702) < (4828 - (251 + 1250)))) then
							v96 = v10.BossFightRemains(nil, true);
							v97 = v96;
							v177 = 2 - 1;
						end
						if ((v177 == (1 + 0)) or ((5574 - (809 + 223)) == (4334 - 1364))) then
							if (((756 - 504) <= (6536 - 4559)) and (v97 == (8183 + 2928))) then
								v97 = v10.FightRemains(v86, false);
							end
							break;
						end
					end
				end
				v28 = v100();
				if (v28 or ((752 + 684) == (4392 - (14 + 603)))) then
					return v28;
				end
				v124 = 133 - (118 + 11);
			end
		end
	end
	local function v111()
		local v125 = 0 + 0;
		while true do
			if ((v125 == (0 + 0)) or ((4715 - 3097) < (1879 - (551 + 398)))) then
				v82.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(365 + 212, v110, v111);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

