local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((4277 - (326 + 445)) <= (5712 - 4403))) then
			v6 = v0[v4];
			if (((6582 - 3627) == (6897 - 3942)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 712 - (530 + 181);
		end
		if ((v5 == (882 - (614 + 267))) or ((2935 - (19 + 13)) == (2432 - 937))) then
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
	local v94 = 1812 - (1293 + 519);
	local v95 = v14:GCD() + (0.25 - 0);
	local v96 = 29010 - 17899;
	local v97 = 21247 - 10136;
	local v98 = {(399111 - 229690),(34566 + 134859),(39037 + 129895),(105877 + 63549),(171287 - (673 + 1185)),(544065 - 374637),(121186 + 48244)};
	v10:RegisterForEvent(function()
		v91 = false;
		v96 = 8303 + 2808;
		v97 = 15001 - 3890;
	end, "PLAYER_REGEN_ENABLED");
	local function v99()
		v28 = v23.HandleTopTrinket(v85, v31, 10 + 30, nil);
		if (((9064 - 4518) >= (4465 - 2190)) and v28) then
			return v28;
		end
		v28 = v23.HandleBottomTrinket(v85, v31, 1920 - (446 + 1434), nil);
		if (((2102 - (1040 + 243)) >= (65 - 43)) and v28) then
			return v28;
		end
	end
	local function v100()
		local v112 = 1847 - (559 + 1288);
		while true do
			if (((5093 - (609 + 1322)) == (3616 - (13 + 441))) and (v112 == (0 - 0))) then
				if ((v82.Blur:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((6205 - 3836) > (22058 - 17629))) then
					if (((153 + 3942) >= (11559 - 8376)) and v21(v82.Blur)) then
						return "blur defensive";
					end
				end
				if ((v82.Netherwalk:IsCastable() and v63 and (v14:HealthPercentage() <= v65)) or ((1319 + 2392) < (442 + 566))) then
					if (v21(v82.Netherwalk) or ((3112 - 2063) <= (496 + 410))) then
						return "netherwalk defensive";
					end
				end
				v112 = 1 - 0;
			end
			if (((2984 + 1529) > (1517 + 1209)) and (v112 == (1 + 0))) then
				if ((v83.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or ((1244 + 237) >= (2601 + 57))) then
					if (v21(v84.Healthstone) or ((3653 - (153 + 280)) == (3938 - 2574))) then
						return "healthstone defensive";
					end
				end
				if ((v74 and (v14:HealthPercentage() <= v76)) or ((947 + 107) > (1340 + 2052))) then
					if ((v78 == "Refreshing Healing Potion") or ((354 + 322) >= (1491 + 151))) then
						if (((2997 + 1139) > (3649 - 1252)) and v83.RefreshingHealingPotion:IsReady()) then
							if (v21(v84.RefreshingHealingPotion) or ((2679 + 1655) == (4912 - (89 + 578)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v78 == "Dreamwalker's Healing Potion") or ((3055 + 1221) <= (6301 - 3270))) then
						if (v83.DreamwalkersHealingPotion:IsReady() or ((5831 - (572 + 477)) <= (162 + 1037))) then
							if (v21(v84.RefreshingHealingPotion) or ((2920 + 1944) < (228 + 1674))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v101()
		if (((4925 - (84 + 2)) >= (6097 - 2397)) and v82.ImmolationAura:IsCastable() and v46) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(6 + 2)) or ((1917 - (497 + 345)) > (50 + 1868))) then
				return "immolation_aura precombat 8";
			end
		end
		if (((67 + 329) <= (5137 - (605 + 728))) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving() and (v88 > (1 + 0)) and v82.SigilOfFlame:IsCastable()) then
			if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((9268 - 5099) == (101 + 2086))) then
				if (((5198 - 3792) == (1268 + 138)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(21 - 13))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((1156 + 375) < (4760 - (457 + 32))) and (v79 == "cursor")) then
				if (((270 + 365) == (2037 - (832 + 570))) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(38 + 2))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((880 + 2493) <= (12583 - 9027)) and not v15:IsInMeleeRange(3 + 2) and v82.Felblade:IsCastable() and v43) then
			if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((4087 - (588 + 208)) < (8840 - 5560))) then
				return "felblade precombat 9";
			end
		end
		if (((6186 - (884 + 916)) >= (1827 - 954)) and not v15:IsInMeleeRange(3 + 2) and v82.ThrowGlaive:IsCastable() and v48 and not v14:PrevGCDP(654 - (232 + 421), v82.VengefulRetreat)) then
			if (((2810 - (1569 + 320)) <= (271 + 831)) and v21(v82.ThrowGlaive, not v15:IsSpellInRange(v82.ThrowGlaive))) then
				return "throw_glaive precombat 9";
			end
		end
		if (((895 + 3811) >= (3244 - 2281)) and not v15:IsInMeleeRange(610 - (316 + 289)) and v82.FelRush:IsCastable() and (not v82.Felblade:IsAvailable() or (v82.Felblade:CooldownUp() and not v14:PrevGCDP(2 - 1, v82.Felblade))) and v32 and ((not v33 and v80) or not v80) and v44) then
			if (v21(v82.FelRush, not v15:IsInRange(1 + 14)) or ((2413 - (666 + 787)) <= (1301 - (360 + 65)))) then
				return "fel_rush precombat 10";
			end
		end
		if ((v15:IsInMeleeRange(5 + 0) and v39 and (v82.DemonsBite:IsCastable() or v82.DemonBlades:IsAvailable())) or ((2320 - (79 + 175)) == (1469 - 537))) then
			if (((3766 + 1059) < (14844 - 10001)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(9 - 4))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v102()
		local v113 = 899 - (503 + 396);
		local v114;
		while true do
			if ((v113 == (183 - (92 + 89))) or ((7521 - 3644) >= (2327 + 2210))) then
				if ((((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and v82.TheHunt:IsCastable() and v56 and v15:DebuffDown(v82.EssenceBreakDebuff) and (v10.CombatTime() > (3 + 2))) or ((16898 - 12583) < (237 + 1489))) then
					if (v21(v82.TheHunt, not v15:IsInRange(91 - 51)) or ((3210 + 469) < (299 + 326))) then
						return "the_hunt cooldown 4";
					end
				end
				if ((v54 and ((not v33 and v81) or not v81) and not v14:IsMoving() and ((v31 and v57) or not v57) and v82.ElysianDecree:IsCastable() and (v15:DebuffDown(v82.EssenceBreakDebuff)) and (v88 > v61)) or ((14086 - 9461) < (79 + 553))) then
					if ((v60 == "player") or ((126 - 43) > (3024 - (485 + 759)))) then
						if (((1263 - 717) <= (2266 - (442 + 747))) and v21(v84.ElysianDecreePlayer, not v15:IsInRange(1143 - (832 + 303)))) then
							return "elysian_decree cooldown 6 (Player)";
						end
					elseif ((v60 == "cursor") or ((1942 - (88 + 858)) > (1311 + 2990))) then
						if (((3369 + 701) > (29 + 658)) and v21(v84.ElysianDecreeCursor, not v15:IsInRange(819 - (766 + 23)))) then
							return "elysian_decree cooldown 6 (Cursor)";
						end
					end
				end
				break;
			end
			if ((v113 == (0 - 0)) or ((896 - 240) >= (8773 - 5443))) then
				if ((((v31 and v58) or not v58) and v82.Metamorphosis:IsCastable() and v55 and (((not v82.Demonic:IsAvailable() or (v14:BuffRemains(v82.MetamorphosisBuff) < v14:GCD())) and (v82.EyeBeam:CooldownRemains() > (0 - 0)) and (not v82.EssenceBreak:IsAvailable() or v15:DebuffUp(v82.EssenceBreakDebuff)) and v14:BuffDown(v82.FelBarrageBuff)) or not v82.ChaoticTransformation:IsAvailable() or (v97 < (1103 - (1036 + 37))))) or ((1767 + 725) <= (652 - 317))) then
					if (((3400 + 922) >= (4042 - (641 + 839))) and v21(v84.MetamorphosisPlayer, not v15:IsInRange(921 - (910 + 3)))) then
						return "metamorphosis cooldown 2";
					end
				end
				v114 = v23.HandleDPSPotion(v14:BuffUp(v82.MetamorphosisBuff));
				v113 = 2 - 1;
			end
			if ((v113 == (1685 - (1466 + 218))) or ((1672 + 1965) >= (4918 - (556 + 592)))) then
				if (v114 or ((846 + 1533) > (5386 - (329 + 479)))) then
					return v114;
				end
				if ((v71 < v97) or ((1337 - (174 + 680)) > (2552 - 1809))) then
					if (((5086 - 2632) > (413 + 165)) and v72 and ((v31 and v73) or not v73)) then
						v28 = v99();
						if (((1669 - (396 + 343)) < (395 + 4063)) and v28) then
							return v28;
						end
					end
				end
				v113 = 1479 - (29 + 1448);
			end
		end
	end
	local function v103()
		if (((2051 - (135 + 1254)) <= (3661 - 2689)) and v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v14:PrevGCDP(4 - 3, v82.DeathSweep) and (v82.Felblade:CooldownRemains() == (0 + 0))) then
			if (((5897 - (389 + 1138)) == (4944 - (102 + 472))) and v21(v82.VengefulRetreat, not v15:IsInRange(8 + 0), true, true)) then
				return "vengeful_retreat opener 1";
			end
		end
		if ((v82.Metamorphosis:IsCastable() and v55 and ((v31 and v58) or not v58) and (v14:PrevGCDP(1 + 0, v82.DeathSweep) or (not v82.ChaoticTransformation:IsAvailable() and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (2 + 0)))) or not v82.Demonic:IsAvailable())) or ((6307 - (320 + 1225)) <= (1532 - 671))) then
			if (v21(v84.MetamorphosisPlayer, not v15:IsInRange(5 + 3)) or ((2876 - (157 + 1307)) == (6123 - (821 + 1038)))) then
				return "metamorphosis opener 2";
			end
		end
		if ((v82.Felblade:IsCastable() and v43 and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((7904 - 4736) < (236 + 1917))) then
			if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((8838 - 3862) < (496 + 836))) then
				return "felblade opener 3";
			end
		end
		if (((11470 - 6842) == (5654 - (834 + 192))) and v82.ImmolationAura:IsCastable() and v46 and (v82.ImmolationAura:Charges() == (1 + 1)) and v14:BuffDown(v82.UnboundChaosBuff) and (v14:BuffDown(v82.InertiaBuff) or (v88 > (1 + 1)))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(1 + 7)) or ((83 - 29) == (699 - (300 + 4)))) then
				return "immolation_aura opener 4";
			end
		end
		if (((22 + 60) == (214 - 132)) and v82.Annihilation:IsCastable() and v34 and v14:BuffUp(v82.InnerDemonBuff) and (not v82.ChaoticTransformation:IsAvailable() or v82.Metamorphosis:CooldownUp())) then
			if (v21(v82.Annihilation, not v15:IsInMeleeRange(367 - (112 + 250))) or ((232 + 349) < (706 - 424))) then
				return "annihilation opener 5";
			end
		end
		if ((v82.EyeBeam:IsCastable() and v41 and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff) and (not v14:BuffUp(v82.MetamorphosisBuff) or (v82.BladeDance:CooldownRemains() > (0 + 0)))) or ((2384 + 2225) < (1866 + 629))) then
			if (((572 + 580) == (856 + 296)) and v21(v82.EyeBeam, not v15:IsInRange(1422 - (1001 + 413)))) then
				return "eye_beam opener 6";
			end
		end
		if (((4227 - 2331) <= (4304 - (244 + 638))) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Inertia:IsAvailable() and (v14:BuffDown(v82.InertiaBuff) or (v88 > (695 - (627 + 66)))) and v14:BuffUp(v82.UnboundChaosBuff)) then
			if (v21(v82.FelRush, not v15:IsInRange(44 - 29)) or ((1592 - (512 + 90)) > (3526 - (1665 + 241)))) then
				return "fel_rush opener 7";
			end
		end
		if ((v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80)) or ((1594 - (373 + 344)) > (2118 + 2577))) then
			if (((713 + 1978) >= (4882 - 3031)) and v21(v82.TheHunt, not v15:IsInRange(67 - 27))) then
				return "the_hunt opener 8";
			end
		end
		if ((v82.EssenceBreak:IsCastable() and v40) or ((4084 - (35 + 1064)) >= (3534 + 1322))) then
			if (((9148 - 4872) >= (5 + 1190)) and v21(v82.EssenceBreak, not v15:IsInMeleeRange(1241 - (298 + 938)))) then
				return "essence_break opener 9";
			end
		end
		if (((4491 - (233 + 1026)) <= (6356 - (636 + 1030))) and v82.DeathSweep:IsCastable() and v38) then
			if (v21(v82.DeathSweep, not v15:IsInMeleeRange(3 + 2)) or ((876 + 20) >= (935 + 2211))) then
				return "death_sweep opener 10";
			end
		end
		if (((207 + 2854) >= (3179 - (55 + 166))) and v82.Annihilation:IsCastable() and v34) then
			if (((618 + 2569) >= (65 + 579)) and v21(v82.Annihilation, not v15:IsInMeleeRange(18 - 13))) then
				return "annihilation opener 11";
			end
		end
		if (((941 - (36 + 261)) <= (1231 - 527)) and v82.DemonsBite:IsCastable() and v39) then
			if (((2326 - (34 + 1334)) > (365 + 582)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(4 + 1))) then
				return "demons_bite opener 12";
			end
		end
	end
	local function v104()
		local v115 = 1283 - (1035 + 248);
		while true do
			if (((4513 - (20 + 1)) >= (1383 + 1271)) and (v115 == (323 - (134 + 185)))) then
				if (((4575 - (549 + 584)) >= (2188 - (314 + 371))) and v47 and ((not v33 and v81) or not v81) and v82.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (137 - 97)) and v14:BuffUp(v82.FelBarrageBuff)) then
					if ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((4138 - (478 + 490)) <= (776 + 688))) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(1180 - (786 + 386))) or ((15537 - 10740) == (5767 - (1055 + 324)))) then
							return "sigil_of_flame fel_barrage 18";
						end
					elseif (((1891 - (1093 + 247)) <= (606 + 75)) and (v79 == "cursor")) then
						if (((345 + 2932) > (1615 - 1208)) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(135 - 95))) then
							return "sigil_of_flame fel_barrage 18";
						end
					end
				end
				if (((13359 - 8664) >= (3555 - 2140)) and v82.Felblade:IsCastable() and v43 and v14:BuffUp(v82.FelBarrageBuff) and (v14:FuryDeficit() > (15 + 25))) then
					if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((12373 - 9161) <= (3253 - 2309))) then
						return "felblade fel_barrage 19";
					end
				end
				if ((v82.DeathSweep:IsCastable() and v38 and (((v14:Fury() - v94) - (27 + 8)) > (0 - 0)) and ((v14:BuffRemains(v82.FelBarrageBuff) < (691 - (364 + 324))) or v92 or (v14:Fury() > (219 - 139)) or (v93 > (43 - 25)))) or ((1027 + 2069) <= (7523 - 5725))) then
					if (((5663 - 2126) == (10742 - 7205)) and v21(v82.DeathSweep, not v15:IsInMeleeRange(1273 - (1249 + 19)))) then
						return "death_sweep fel_barrage 21";
					end
				end
				v115 = 5 + 0;
			end
			if (((14935 - 11098) >= (2656 - (686 + 400))) and (v115 == (1 + 0))) then
				if ((v82.Annihilation:IsCastable() and v34 and v14:BuffUp(v82.InnerDemonBuff)) or ((3179 - (73 + 156)) == (19 + 3793))) then
					if (((5534 - (721 + 90)) >= (27 + 2291)) and v21(v82.Annihilation, not v15:IsInMeleeRange(16 - 11))) then
						return "annihilation fel_barrage 1";
					end
				end
				if ((v82.EyeBeam:IsCastable() and v41 and v14:BuffDown(v82.FelBarrageBuff)) or ((2497 - (224 + 246)) > (4619 - 1767))) then
					if (v21(v82.EyeBeam, not v15:IsInRange(14 - 6)) or ((207 + 929) > (103 + 4214))) then
						return "eye_beam fel_barrage 3";
					end
				end
				if (((3488 + 1260) == (9439 - 4691)) and v82.EssenceBreak:IsCastable() and v40 and v14:BuffDown(v82.FelBarrageBuff) and v14:BuffUp(v82.MetamorphosisBuff)) then
					if (((12432 - 8696) <= (5253 - (203 + 310))) and v21(v82.EssenceBreak, not v15:IsInMeleeRange(1998 - (1238 + 755)))) then
						return "essence_break fel_barrage 5";
					end
				end
				v115 = 1 + 1;
			end
			if ((v115 == (1537 - (709 + 825))) or ((6246 - 2856) <= (4457 - 1397))) then
				if ((v82.BladeDance:IsCastable() and v35 and v14:BuffDown(v82.FelBarrageBuff)) or ((1863 - (196 + 668)) > (10632 - 7939))) then
					if (((958 - 495) < (1434 - (171 + 662))) and v21(v82.BladeDance, not v15:IsInMeleeRange(98 - (4 + 89)))) then
						return "blade_dance fel_barrage 13";
					end
				end
				if ((v82.FelBarrage:IsCastable() and v42 and (v14:Fury() > (350 - 250))) or ((795 + 1388) < (3017 - 2330))) then
					if (((1784 + 2765) == (6035 - (35 + 1451))) and v21(v82.FelBarrage, not v15:IsInMeleeRange(1458 - (28 + 1425)))) then
						return "fel_barrage fel_barrage 15";
					end
				end
				if (((6665 - (941 + 1052)) == (4480 + 192)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v14:Fury() > (1534 - (822 + 692))) and v14:BuffUp(v82.FelBarrageBuff)) then
					if (v21(v82.FelRush, not v15:IsInRange(20 - 5)) or ((1728 + 1940) < (692 - (45 + 252)))) then
						return "fel_rush fel_barrage 17";
					end
				end
				v115 = 4 + 0;
			end
			if ((v115 == (2 + 3)) or ((10138 - 5972) == (888 - (114 + 319)))) then
				if ((v82.GlaiveTempest:IsCastable() and v45 and (((v14:Fury() - v94) - (43 - 13)) > (0 - 0)) and ((v14:BuffRemains(v82.FelBarrageBuff) < (2 + 1)) or v92 or (v14:Fury() > (119 - 39)) or (v93 > (37 - 19)))) or ((6412 - (556 + 1407)) == (3869 - (741 + 465)))) then
					if (v21(v82.GlaiveTempest, not v15:IsInMeleeRange(470 - (170 + 295))) or ((2254 + 2023) < (2746 + 243))) then
						return "glaive_tempest fel_barrage 23";
					end
				end
				if ((v82.BladeDance:IsCastable() and v35 and (((v14:Fury() - v94) - (86 - 51)) > (0 + 0)) and ((v14:BuffRemains(v82.FelBarrageBuff) < (2 + 1)) or v92 or (v14:Fury() > (46 + 34)) or (v93 > (1248 - (957 + 273))))) or ((233 + 637) >= (1661 + 2488))) then
					if (((8428 - 6216) < (8387 - 5204)) and v21(v82.BladeDance, not v15:IsInMeleeRange(15 - 10))) then
						return "blade_dance fel_barrage 25";
					end
				end
				if (((23005 - 18359) > (4772 - (389 + 1391))) and v82.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (26 + 14)) and v14:BuffUp(v82.FelBarrageBuff)) then
					if (((150 + 1284) < (7070 - 3964)) and v21(v82.ArcaneTorrent)) then
						return "arcane_torrent fel_barrage 27";
					end
				end
				v115 = 957 - (783 + 168);
			end
			if (((2637 - 1851) < (2974 + 49)) and (v115 == (313 - (309 + 2)))) then
				if ((v82.DeathSweep:IsCastable() and v38 and v14:BuffDown(v82.FelBarrageBuff)) or ((7498 - 5056) < (1286 - (1090 + 122)))) then
					if (((1471 + 3064) == (15230 - 10695)) and v21(v82.DeathSweep, not v15:IsInMeleeRange(4 + 1))) then
						return "death_sweep fel_barrage 7";
					end
				end
				if ((v82.ImmolationAura:IsCastable() and v46 and v14:BuffDown(v82.UnboundChaosBuff) and ((v88 > (1120 - (628 + 490))) or v14:BuffUp(v82.FelBarrageBuff))) or ((540 + 2469) <= (5211 - 3106))) then
					if (((8363 - 6533) < (4443 - (431 + 343))) and v21(v82.ImmolationAura, not v15:IsInRange(16 - 8))) then
						return "immolation_aura fel_barrage 9";
					end
				end
				if ((v82.GlaiveTempest:IsCastable() and v45 and v14:BuffDown(v82.FelBarrageBuff) and (v88 > (2 - 1))) or ((1130 + 300) >= (462 + 3150))) then
					if (((4378 - (556 + 1139)) >= (2475 - (6 + 9))) and v21(v82.GlaiveTempest, not v15:IsInMeleeRange(1 + 4))) then
						return "glaive_tempest fel_barrage 11";
					end
				end
				v115 = 2 + 1;
			end
			if ((v115 == (175 - (28 + 141))) or ((699 + 1105) >= (4042 - 767))) then
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff)) or ((1004 + 413) > (4946 - (486 + 831)))) then
					if (((12477 - 7682) > (1415 - 1013)) and v21(v82.FelRush, not v15:IsInRange(3 + 12))) then
						return "fel_rush fel_barrage 29";
					end
				end
				if (((15218 - 10405) > (4828 - (668 + 595))) and v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and (v14:Fury() > (36 + 4))) then
					if (((789 + 3123) == (10668 - 6756)) and v21(v82.TheHunt, not v15:IsInRange(330 - (23 + 267)))) then
						return "the_hunt fel_barrage 31";
					end
				end
				if (((4765 - (1129 + 815)) <= (5211 - (371 + 16))) and v82.DemonsBite:IsCastable() and v39) then
					if (((3488 - (1326 + 424)) <= (4156 - 1961)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(18 - 13))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if (((159 - (88 + 30)) <= (3789 - (720 + 51))) and (v115 == (0 - 0))) then
				v92 = (v82.Felblade:CooldownRemains() < v95) or (v82.SigilOfFlame:CooldownRemains() < v95);
				v93 = (((1777 - (421 + 1355)) % ((2.6 - 0) * v14:SpellHaste())) * (6 + 6)) + (v14:BuffStack(v82.ImmolationAuraBuff) * (1089 - (286 + 797))) + (v24(v14:BuffUp(v82.TacticalRetreatBuff)) * (36 - 26));
				v94 = v95 * (52 - 20);
				v115 = 440 - (397 + 42);
			end
		end
	end
	local function v105()
		local v116 = 0 + 0;
		while true do
			if (((2945 - (24 + 776)) <= (6322 - 2218)) and (v116 == (785 - (222 + 563)))) then
				if (((5924 - 3235) < (3489 + 1356)) and v82.DeathSweep:IsCastable() and v38 and (v14:BuffRemains(v82.MetamorphosisBuff) < v95)) then
					if (v21(v82.DeathSweep, not v15:IsInMeleeRange(195 - (23 + 167))) or ((4120 - (690 + 1108)) > (946 + 1676))) then
						return "death_sweep meta 1";
					end
				end
				if ((v82.Annihilation:IsCastable() and v34 and (v14:BuffRemains(v82.MetamorphosisBuff) < v95)) or ((3740 + 794) == (2930 - (40 + 808)))) then
					if (v21(v82.Annihilation, not v15:IsInMeleeRange(1 + 4)) or ((6007 - 4436) > (1785 + 82))) then
						return "annihilation meta 3";
					end
				end
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable()) or ((1405 + 1249) >= (1643 + 1353))) then
					if (((4549 - (47 + 524)) > (1366 + 738)) and v21(v82.FelRush, not v15:IsInRange(41 - 26))) then
						return "fel_rush meta 5";
					end
				end
				if (((4478 - 1483) > (3514 - 1973)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Momentum:IsAvailable() and (v14:BuffRemains(v82.MomentumBuff) < (v95 * (1728 - (1165 + 561))))) then
					if (((97 + 3152) > (2951 - 1998)) and v21(v82.FelRush, not v15:IsInRange(6 + 9))) then
						return "fel_rush meta 7";
					end
				end
				v116 = 480 - (341 + 138);
			end
			if (((1 + 0) == v116) or ((6754 - 3481) > (4899 - (89 + 237)))) then
				if ((v82.Annihilation:IsCastable() and v34 and v14:BuffUp(v82.InnerDemonBuff) and (((v82.EyeBeam:CooldownRemains() < (v95 * (9 - 6))) and (v82.BladeDance:CooldownRemains() > (0 - 0))) or (v82.Metamorphosis:CooldownRemains() < (v95 * (884 - (581 + 300)))))) or ((4371 - (855 + 365)) < (3049 - 1765))) then
					if (v21(v82.Annihilation, not v15:IsInMeleeRange(2 + 3)) or ((3085 - (1030 + 205)) == (1436 + 93))) then
						return "annihilation meta 9";
					end
				end
				if (((764 + 57) < (2409 - (156 + 130))) and ((v82.EssenceBreak:IsCastable() and v40 and (v14:Fury() > (45 - 25)) and ((v82.Metamorphosis:CooldownRemains() > (16 - 6)) or (v82.BladeDance:CooldownRemains() < (v95 * (3 - 1)))) and (v14:BuffDown(v82.UnboundChaosBuff) or v14:BuffUp(v82.InertiaBuff) or not v82.Inertia:IsAvailable())) or (v97 < (3 + 7)))) then
					if (((526 + 376) < (2394 - (10 + 59))) and v21(v82.EssenceBreak, not v15:IsInMeleeRange(2 + 3))) then
						return "essence_break meta 11";
					end
				end
				if (((4225 - 3367) <= (4125 - (671 + 492))) and v82.ImmolationAura:IsCastable() and v46 and v15:DebuffDown(v82.EssenceBreakDebuff) and (v82.BladeDance:CooldownRemains() > (v95 + 0.5 + 0)) and v14:BuffDown(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and ((v82.ImmolationAura:FullRechargeTime() + (1218 - (369 + 846))) < v82.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v82.MetamorphosisBuff) > (2 + 3))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(7 + 1)) or ((5891 - (1036 + 909)) < (1025 + 263))) then
						return "immolation_aura meta 13";
					end
				end
				if ((v82.DeathSweep:IsCastable() and v38) or ((5442 - 2200) == (770 - (11 + 192)))) then
					if (v21(v82.DeathSweep, not v15:IsInMeleeRange(3 + 2)) or ((1022 - (135 + 40)) >= (3059 - 1796))) then
						return "death_sweep meta 15";
					end
				end
				v116 = 2 + 0;
			end
			if ((v116 == (8 - 4)) or ((3377 - 1124) == (2027 - (50 + 126)))) then
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Momentum:IsAvailable()) or ((5811 - 3724) > (526 + 1846))) then
					if (v21(v82.FelRush, not v15:IsInRange(1428 - (1233 + 180))) or ((5414 - (522 + 447)) < (5570 - (107 + 1314)))) then
						return "fel_rush meta 33";
					end
				end
				if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (4 + 4)) or (v82.FelRush:ChargesFractional() > (2.01 - 1)))) or ((773 + 1045) == (168 - 83))) then
					if (((2492 - 1862) < (4037 - (716 + 1194))) and v21(v82.FelRush, not v15:IsInRange(1 + 14))) then
						return "fel_rush meta 35";
					end
				end
				if ((v82.DemonsBite:IsCastable() and v39) or ((208 + 1730) == (3017 - (74 + 429)))) then
					if (((8208 - 3953) >= (28 + 27)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(11 - 6))) then
						return "demons_bite meta 37";
					end
				end
				break;
			end
			if (((2122 + 877) > (3563 - 2407)) and (v116 == (7 - 4))) then
				if (((2783 - (279 + 154)) > (1933 - (454 + 324))) and v47 and ((not v33 and v81) or not v81) and v82.SigilOfFlame:IsCastable() and (v14:BuffRemains(v82.MetamorphosisBuff) > (4 + 1))) then
					if (((4046 - (12 + 5)) <= (2617 + 2236)) and ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(20 - 12)) or ((191 + 325) > (4527 - (277 + 816)))) then
							return "sigil_of_flame meta 25";
						end
					elseif (((17288 - 13242) >= (4216 - (1058 + 125))) and (v79 == "cursor")) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(8 + 32)) or ((3694 - (815 + 160)) <= (6208 - 4761))) then
							return "sigil_of_flame meta 25";
						end
					end
				end
				if ((v82.Felblade:IsCastable() and v43) or ((9813 - 5679) < (937 + 2989))) then
					if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((479 - 315) >= (4683 - (41 + 1857)))) then
						return "felblade meta 27";
					end
				end
				if ((v47 and ((not v33 and v81) or not v81) and v82.SigilOfFlame:IsCastable() and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((2418 - (1222 + 671)) == (5450 - 3341))) then
					if (((46 - 13) == (1215 - (229 + 953))) and ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((4828 - (1111 + 663)) <= (5594 - (874 + 705))) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(2 + 6))) then
							return "sigil_of_flame meta 29";
						end
					elseif (((1277 + 594) < (7029 - 3647)) and (v79 == "cursor")) then
						if (((37 + 1256) <= (2845 - (642 + 37))) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(10 + 30))) then
							return "sigil_of_flame meta 29";
						end
					end
				end
				if ((v82.ImmolationAura:IsCastable() and v46 and v15:IsInRange(2 + 6) and (v82.ImmolationAura:Recharge() < v27(v82.EyeBeam:CooldownRemains(), v14:BuffRemains(v82.MetamorphosisBuff)))) or ((6474 - 3895) < (577 - (233 + 221)))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(18 - 10)) or ((745 + 101) >= (3909 - (718 + 823)))) then
						return "immolation_aura meta 31";
					end
				end
				v116 = 3 + 1;
			end
			if ((v116 == (807 - (266 + 539))) or ((11358 - 7346) <= (4583 - (636 + 589)))) then
				if (((3545 - 2051) <= (6197 - 3192)) and v82.EyeBeam:IsCastable() and v41 and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff)) then
					if (v21(v82.EyeBeam, not v15:IsInRange(7 + 1)) or ((1131 + 1980) == (3149 - (657 + 358)))) then
						return "eye_beam meta 17";
					end
				end
				if (((6235 - 3880) == (5365 - 3010)) and v82.GlaiveTempest:IsCastable() and v45 and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.BladeDance:CooldownRemains() > (v95 * (1189 - (1151 + 36)))) or (v14:Fury() > (58 + 2)))) then
					if (v21(v82.GlaiveTempest, not v15:IsInMeleeRange(2 + 3)) or ((1755 - 1167) <= (2264 - (1552 + 280)))) then
						return "glaive_tempest meta 19";
					end
				end
				if (((5631 - (64 + 770)) >= (2645 + 1250)) and v47 and ((not v33 and v81) or not v81) and v82.SigilOfFlame:IsCastable() and (v88 > (4 - 2))) then
					if (((636 + 2941) == (4820 - (157 + 1086))) and ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((7593 - 3799) > (16174 - 12481)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(11 - 3))) then
							return "sigil_of_flame meta 21";
						end
					elseif ((v79 == "cursor") or ((1739 - 464) == (4919 - (599 + 220)))) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(79 - 39)) or ((3522 - (1813 + 118)) >= (2617 + 963))) then
							return "sigil_of_flame meta 21";
						end
					end
				end
				if (((2200 - (841 + 376)) <= (2533 - 725)) and v82.Annihilation:IsCastable() and v34 and ((v82.BladeDance:CooldownRemains() > (v95 * (1 + 1))) or (v14:Fury() > (163 - 103)) or ((v14:BuffRemains(v82.MetamorphosisBuff) < (864 - (464 + 395))) and v82.Felblade:CooldownUp()))) then
					if (v21(v82.Annihilation, not v15:IsInMeleeRange(12 - 7)) or ((1033 + 1117) <= (2034 - (467 + 370)))) then
						return "annihilation meta 23";
					end
				end
				v116 = 5 - 2;
			end
		end
	end
	local function v106()
		v28 = v102();
		if (((2767 + 1002) >= (4021 - 2848)) and v28) then
			return v28;
		end
		if (((232 + 1253) == (3454 - 1969)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v14:BuffRemains(v82.UnboundChaosBuff) < (v95 * (522 - (150 + 370))))) then
			if (v21(v82.FelRush, not v15:IsInRange(1297 - (74 + 1208))) or ((8153 - 4838) <= (13193 - 10411))) then
				return "fel_rush rotation 1";
			end
		end
		if (v82.FelBarrage:IsAvailable() or ((624 + 252) >= (3354 - (14 + 376)))) then
			v91 = v82.FelBarrage:IsAvailable() and (v82.FelBarrage:CooldownRemains() < (v95 * (11 - 4))) and (((v88 >= (2 + 0)) and ((v82.Metamorphosis:CooldownRemains() > (0 + 0)) or (v88 > (2 + 0)))) or v14:BuffUp(v82.FelBarrageBuff));
		end
		if (((v82.EyeBeam:CooldownUp() or v82.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (43 - 28))) or ((1680 + 552) > (2575 - (23 + 55)))) then
			local v151 = 0 - 0;
			while true do
				if ((v151 == (0 + 0)) or ((1895 + 215) <= (514 - 182))) then
					v28 = v103();
					if (((1160 + 2526) > (4073 - (652 + 249))) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (v91 or ((11972 - 7498) < (2688 - (708 + 1160)))) then
			local v152 = 0 - 0;
			while true do
				if (((7801 - 3522) >= (2909 - (10 + 17))) and (v152 == (0 + 0))) then
					v28 = v104();
					if (v28 or ((3761 - (1400 + 332)) >= (6753 - 3232))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and (v88 > (1910 - (242 + 1666))) and v82.Ragefire:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > v82.ImmolationAura:Recharge())) and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((872 + 1165) >= (1702 + 2940))) then
			if (((1466 + 254) < (5398 - (850 + 90))) and v21(v82.ImmolationAura, not v15:IsInRange(13 - 5))) then
				return "immolation_aura rotation 3";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and (v88 > (1392 - (360 + 1030))) and v82.Ragefire:IsAvailable() and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((386 + 50) > (8526 - 5505))) then
			if (((980 - 267) <= (2508 - (909 + 752))) and v21(v82.ImmolationAura, not v15:IsInRange(1231 - (109 + 1114)))) then
				return "immolation_aura rotation 5";
			end
		end
		if (((3943 - 1789) <= (1570 + 2461)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v88 > (244 - (6 + 236))) and (not v82.Inertia:IsAvailable() or ((v82.EyeBeam:CooldownRemains() + 2 + 0) > v14:BuffRemains(v82.UnboundChaosBuff)))) then
			if (((3715 + 900) == (10884 - 6269)) and v21(v82.FelRush, not v15:IsInRange(26 - 11))) then
				return "fel_rush rotation 7";
			end
		end
		if ((v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v82.Felblade:IsCastable() and v82.Initiative:IsAvailable() and (((v82.EyeBeam:CooldownRemains() > (1148 - (1076 + 57))) and (v14:GCDRemains() < (0.3 + 0))) or ((v14:GCDRemains() < (689.1 - (579 + 110))) and (v82.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v82.Metamorphosis:CooldownRemains() > (1 + 9)) or (v82.BladeDance:CooldownRemains() < (v95 * (2 + 0)))))) and (v10.CombatTime() > (3 + 1))) or ((4197 - (174 + 233)) == (1396 - 896))) then
			if (((155 - 66) < (99 + 122)) and v21(v82.VengefulRetreat, not v15:IsInRange(1182 - (663 + 511)), true, true)) then
				return "vengeful_retreat rotation 9";
			end
		end
		if (((1833 + 221) >= (309 + 1112)) and (v91 or (not v82.DemonBlades:IsAvailable() and v82.FelBarrage:IsAvailable() and (v14:BuffUp(v82.FelBarrageBuff) or (v82.FelBarrage:CooldownRemains() > (0 - 0))) and v14:BuffDown(v82.MetamorphosisBuff)))) then
			v28 = v104();
			if (((420 + 272) < (7199 - 4141)) and v28) then
				return v28;
			end
		end
		if (v14:BuffUp(v82.MetamorphosisBuff) or ((7876 - 4622) == (790 + 865))) then
			local v153 = 0 - 0;
			while true do
				if ((v153 == (0 + 0)) or ((119 + 1177) == (5632 - (478 + 244)))) then
					v28 = v105();
					if (((3885 - (440 + 77)) == (1532 + 1836)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((9673 - 7030) < (5371 - (655 + 901))) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and (v82.BladeDance:CooldownRemains() < (1 + 3)) and (v82.EyeBeam:CooldownRemains() > (4 + 1)) and ((v82.ImmolationAura:Charges() > (0 + 0)) or ((v82.ImmolationAura:Recharge() + (7 - 5)) < v82.EyeBeam:CooldownRemains()) or (v82.EyeBeam:CooldownRemains() > (v14:BuffRemains(v82.UnboundChaosBuff) - (1447 - (695 + 750)))))) then
			if (((6531 - 4618) > (760 - 267)) and v21(v82.FelRush, not v15:IsInRange(60 - 45))) then
				return "fel_rush rotation 11";
			end
		end
		if (((5106 - (285 + 66)) > (7990 - 4562)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Momentum:IsAvailable() and (v82.EyeBeam:CooldownRemains() < (v95 * (1312 - (682 + 628))))) then
			if (((223 + 1158) <= (2668 - (176 + 123))) and v21(v82.FelRush, not v15:IsInRange(7 + 8))) then
				return "fel_rush rotation 13";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and v14:BuffDown(v82.UnboundChaosBuff) and (v82.ImmolationAura:FullRechargeTime() < (v95 * (2 + 0))) and (v97 > v82.ImmolationAura:FullRechargeTime())) or ((5112 - (239 + 30)) == (1111 + 2973))) then
			if (((4488 + 181) > (641 - 278)) and v21(v82.ImmolationAura, not v15:IsInRange(24 - 16))) then
				return "immolation_aura rotation 15";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and (v88 > (317 - (306 + 9))) and v14:BuffDown(v82.UnboundChaosBuff)) or ((6549 - 4672) >= (546 + 2592))) then
			if (((2910 + 1832) >= (1746 + 1880)) and v21(v82.ImmolationAura, not v15:IsInRange(22 - 14))) then
				return "immolation_aura rotation 17";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and v82.Inertia:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (v82.EyeBeam:CooldownRemains() < (1380 - (1140 + 235)))) or ((2890 + 1650) == (840 + 76))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(3 + 5)) or ((1208 - (33 + 19)) > (1569 + 2776))) then
				return "immolation_aura rotation 19";
			end
		end
		if (((6704 - 4467) < (1872 + 2377)) and v82.ImmolationAura:IsCastable() and v46 and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and v14:BuffDown(v82.UnboundChaosBuff) and ((v82.ImmolationAura:Recharge() + (9 - 4)) < v82.EyeBeam:CooldownRemains()) and (v82.BladeDance:CooldownRemains() > (0 + 0)) and (v82.BladeDance:CooldownRemains() < (693 - (586 + 103))) and (v82.ImmolationAura:ChargesFractional() > (1 + 0))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(24 - 16)) or ((4171 - (1309 + 179)) < (41 - 18))) then
				return "immolation_aura rotation 21";
			end
		end
		if (((304 + 393) <= (2218 - 1392)) and v82.ImmolationAura:IsCastable() and v46 and (v97 < (12 + 3)) and (v82.BladeDance:CooldownRemains() > (0 - 0))) then
			if (((2201 - 1096) <= (1785 - (295 + 314))) and v21(v82.ImmolationAura, not v15:IsInRange(19 - 11))) then
				return "immolation_aura rotation 23";
			end
		end
		if (((5341 - (1300 + 662)) <= (11970 - 8158)) and v82.EyeBeam:IsCastable() and v41 and not v82.EssenceBreak:IsAvailable() and (not v82.ChaoticTransformation:IsAvailable() or (v82.Metamorphosis:CooldownRemains() < ((1760 - (1178 + 577)) + ((2 + 1) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.Metamorphosis:CooldownRemains() > (44 - 29)))) then
			if (v21(v82.EyeBeam, not v15:IsInRange(1413 - (851 + 554))) or ((697 + 91) >= (4481 - 2865))) then
				return "eye_beam rotation 25";
			end
		end
		if (((4026 - 2172) <= (3681 - (115 + 187))) and ((v82.EyeBeam:IsCastable() and v41 and v82.EssenceBreak:IsAvailable() and ((v82.EssenceBreak:CooldownRemains() < ((v95 * (2 + 0)) + ((5 + 0) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.ShatteredDestiny:IsAvailable() and (v82.EssenceBreak:CooldownRemains() > (39 - 29)))) and ((v82.BladeDance:CooldownRemains() < (1168 - (160 + 1001))) or (v88 > (1 + 0))) and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (7 + 3)) or (v88 > (1 - 0))) and (not v82.Inertia:IsAvailable() or v14:BuffUp(v82.UnboundChaosBuff) or ((v82.ImmolationAura:Charges() == (358 - (237 + 121))) and (v82.ImmolationAura:Recharge() > (902 - (525 + 372)))))) or (v97 < (18 - 8)))) then
			if (((14946 - 10397) == (4691 - (96 + 46))) and v21(v82.EyeBeam, not v15:IsInRange(785 - (643 + 134)))) then
				return "eye_beam rotation 27";
			end
		end
		if ((v82.BladeDance:IsCastable() and v35 and ((v82.EyeBeam:CooldownRemains() > v95) or v82.EyeBeam:CooldownUp())) or ((1091 + 1931) >= (7250 - 4226))) then
			if (((17895 - 13075) > (2108 + 90)) and v21(v82.BladeDance, not v15:IsInRange(9 - 4))) then
				return "blade_dance rotation 29";
			end
		end
		if ((v82.GlaiveTempest:IsCastable() and v45 and (v88 >= (3 - 1))) or ((1780 - (316 + 403)) >= (3252 + 1639))) then
			if (((3750 - 2386) <= (1617 + 2856)) and v21(v82.GlaiveTempest, not v15:IsInRange(20 - 12))) then
				return "glaive_tempest rotation 31";
			end
		end
		if ((v47 and ((not v33 and v81) or not v81) and (v88 > (3 + 0)) and v82.SigilOfFlame:IsCastable()) or ((1159 + 2436) <= (10 - 7))) then
			if ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((22312 - 17640) == (8002 - 4150))) then
				if (((90 + 1469) == (3068 - 1509)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(1 + 7))) then
					return "sigil_of_flame rotation 33";
				end
			elseif ((v79 == "cursor") or ((5154 - 3402) <= (805 - (12 + 5)))) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(155 - 115)) or ((8335 - 4428) == (375 - 198))) then
					return "sigil_of_flame rotation 33";
				end
			end
		end
		if (((8605 - 5135) > (113 + 442)) and v82.ChaosStrike:IsCastable() and v36 and v15:DebuffUp(v82.EssenceBreakDebuff)) then
			if (v21(v82.ChaosStrike, not v15:IsInMeleeRange(1978 - (1656 + 317))) or ((867 + 105) == (517 + 128))) then
				return "chaos_strike rotation 35";
			end
		end
		if (((8460 - 5278) >= (10409 - 8294)) and v82.Felblade:IsCastable() and v43) then
			if (((4247 - (5 + 349)) < (21037 - 16608)) and v21(v82.Felblade, not v15:IsInMeleeRange(1276 - (266 + 1005)))) then
				return "felblade rotation 37";
			end
		end
		if ((v82.ThrowGlaive:IsCastable() and v48 and (v82.ThrowGlaive:FullRechargeTime() <= v82.BladeDance:CooldownRemains()) and (v82.Metamorphosis:CooldownRemains() > (4 + 1)) and v82.Soulscar:IsAvailable() and v14:HasTier(105 - 74, 2 - 0) and not v14:PrevGCDP(1697 - (561 + 1135), v82.VengefulRetreat)) or ((3736 - 869) < (6261 - 4356))) then
			if (v21(v82.ThrowGlaive, not v15:IsInMeleeRange(1096 - (507 + 559))) or ((4506 - 2710) >= (12528 - 8477))) then
				return "throw_glaive rotation 39";
			end
		end
		if (((2007 - (212 + 176)) <= (4661 - (250 + 655))) and v82.ThrowGlaive:IsCastable() and v48 and not v14:HasTier(84 - 53, 2 - 0) and ((v88 > (1 - 0)) or v82.Soulscar:IsAvailable()) and not v14:PrevGCDP(1957 - (1869 + 87), v82.VengefulRetreat)) then
			if (((2094 - 1490) == (2505 - (484 + 1417))) and v21(v82.ThrowGlaive, not v15:IsInMeleeRange(64 - 34))) then
				return "throw_glaive rotation 41";
			end
		end
		if ((v82.ChaosStrike:IsCastable() and v36 and ((v82.EyeBeam:CooldownRemains() > (v95 * (2 - 0))) or (v14:Fury() > (853 - (48 + 725))))) or ((7324 - 2840) == (2414 - 1514))) then
			if (v21(v82.ChaosStrike, not v15:IsInMeleeRange(3 + 2)) or ((11916 - 7457) <= (312 + 801))) then
				return "chaos_strike rotation 43";
			end
		end
		if (((1059 + 2573) > (4251 - (152 + 701))) and v82.ImmolationAura:IsCastable() and v46 and not v82.Inertia:IsAvailable() and (v88 > (1313 - (430 + 881)))) then
			if (((1564 + 2518) <= (5812 - (557 + 338))) and v21(v82.ImmolationAura, not v15:IsInRange(3 + 5))) then
				return "immolation_aura rotation 45";
			end
		end
		if (((13616 - 8784) >= (4853 - 3467)) and v47 and ((not v33 and v81) or not v81) and not v15:IsInRange(21 - 13) and v15:DebuffDown(v82.EssenceBreakDebuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > (53 - 28))) and v82.SigilOfFlame:IsCastable()) then
			if (((938 - (499 + 302)) == (1003 - (39 + 827))) and ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(21 - 13)) or ((3506 - 1936) >= (17205 - 12873))) then
					return "sigil_of_flame rotation 47";
				end
			elseif ((v79 == "cursor") or ((6239 - 2175) <= (156 + 1663))) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(117 - 77)) or ((798 + 4188) < (2490 - 916))) then
					return "sigil_of_flame rotation 47";
				end
			end
		end
		if (((4530 - (103 + 1)) > (726 - (475 + 79))) and v82.DemonsBite:IsCastable() and v39) then
			if (((1266 - 680) > (1456 - 1001)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(1 + 4))) then
				return "demons_bite rotation 49";
			end
		end
		if (((727 + 99) == (2329 - (1395 + 108))) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (23 - 15)) or (v82.FelRush:ChargesFractional() > (1205.01 - (7 + 1197))))) then
			if (v21(v82.FelRush, not v15:IsInRange(7 + 8)) or ((1403 + 2616) > (4760 - (27 + 292)))) then
				return "fel_rush rotation 51";
			end
		end
		if (((5910 - 3893) < (5433 - 1172)) and v82.ArcaneTorrent:IsCastable() and not v14:IsMoving() and v15:IsInRange(33 - 25) and v15:DebuffDown(v82.EssenceBreakDebuff) and (v14:Fury() < (197 - 97))) then
			if (((8981 - 4265) > (219 - (43 + 96))) and v21(v82.ArcaneTorrent, not v15:IsInRange(32 - 24))) then
				return "arcane_torrent rotation 53";
			end
		end
	end
	local function v107()
		v34 = EpicSettings.Settings['useAnnihilation'];
		v35 = EpicSettings.Settings['useBladeDance'];
		v36 = EpicSettings.Settings['useChaosStrike'];
		v37 = EpicSettings.Settings['useConsumeMagic'];
		v38 = EpicSettings.Settings['useDeathSweep'];
		v39 = EpicSettings.Settings['useDemonsBite'];
		v40 = EpicSettings.Settings['useEssenceBreak'];
		v41 = EpicSettings.Settings['useEyeBeam'];
		v42 = EpicSettings.Settings['useFelBarrage'];
		v43 = EpicSettings.Settings['useFelblade'];
		v44 = EpicSettings.Settings['useFelRush'];
		v45 = EpicSettings.Settings['useGlaiveTempest'];
		v46 = EpicSettings.Settings['useImmolationAura'];
		v47 = EpicSettings.Settings['useSigilOfFlame'];
		v48 = EpicSettings.Settings['useThrowGlaive'];
		v49 = EpicSettings.Settings['useVengefulRetreat'];
		v54 = EpicSettings.Settings['useElysianDecree'];
		v55 = EpicSettings.Settings['useMetamorphosis'];
		v56 = EpicSettings.Settings['useTheHunt'];
		v57 = EpicSettings.Settings['elysianDecreeWithCD'];
		v58 = EpicSettings.Settings['metamorphosisWithCD'];
		v59 = EpicSettings.Settings['theHuntWithCD'];
		v60 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v61 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
	end
	local function v108()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (1 + 2)) or ((6931 - 3424) == (1255 + 2017))) then
				v81 = EpicSettings.Settings['RMBAOE'];
				v80 = EpicSettings.Settings['RMBMovement'];
				break;
			end
			if ((v139 == (0 - 0)) or ((276 + 600) >= (226 + 2849))) then
				v50 = EpicSettings.Settings['useChaosNova'];
				v51 = EpicSettings.Settings['useDisrupt'];
				v52 = EpicSettings.Settings['useFelEruption'];
				v139 = 1752 - (1414 + 337);
			end
			if (((6292 - (1642 + 298)) > (6657 - 4103)) and (v139 == (5 - 3))) then
				v64 = EpicSettings.Settings['blurHP'] or (0 - 0);
				v65 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
				v79 = EpicSettings.Settings['sigilSetting'] or "";
				v139 = 3 + 0;
			end
			if ((v139 == (973 - (357 + 615))) or ((3093 + 1313) < (9919 - 5876))) then
				v53 = EpicSettings.Settings['useSigilOfMisery'];
				v62 = EpicSettings.Settings['useBlur'];
				v63 = EpicSettings.Settings['useNetherwalk'];
				v139 = 2 + 0;
			end
		end
	end
	local function v109()
		v71 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v66 = EpicSettings.Settings['dispelBuffs'];
		v68 = EpicSettings.Settings['InterruptWithStun'];
		v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v70 = EpicSettings.Settings['InterruptThreshold'];
		v72 = EpicSettings.Settings['useTrinkets'];
		v73 = EpicSettings.Settings['trinketsWithCD'];
		v75 = EpicSettings.Settings['useHealthstone'];
		v74 = EpicSettings.Settings['useHealingPotion'];
		v77 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v76 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v78 = EpicSettings.Settings['HealingPotionName'] or "";
		v67 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v110()
		local v149 = 0 + 0;
		while true do
			if ((v149 == (1306 - (384 + 917))) or ((2586 - (128 + 569)) >= (4926 - (1407 + 136)))) then
				if (((3779 - (687 + 1200)) <= (4444 - (556 + 1154))) and v28) then
					return v28;
				end
				if (((6765 - 4842) < (2313 - (9 + 86))) and v67) then
					local v166 = 421 - (275 + 146);
					while true do
						if (((354 + 1819) > (443 - (29 + 35))) and ((0 - 0) == v166)) then
							v28 = v23.HandleIncorporeal(v82.Imprison, v84.ImprisonMouseover, 89 - 59, true);
							if (v28 or ((11437 - 8846) == (2221 + 1188))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((5526 - (53 + 959)) > (3732 - (312 + 96))) and (v14:PrevGCDP(1 - 0, v82.VengefulRetreat) or v14:PrevGCDP(287 - (147 + 138), v82.VengefulRetreat) or (v14:PrevGCDP(902 - (813 + 86), v82.VengefulRetreat) and v14:IsMoving()))) then
					if ((v82.Felblade:IsCastable() and v43) or ((188 + 20) >= (8944 - 4116))) then
						if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((2075 - (18 + 474)) > (1204 + 2363))) then
							return "felblade rotation 1";
						end
					end
				elseif ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((4285 - 2972) == (1880 - (860 + 226)))) then
					if (((3477 - (121 + 182)) > (358 + 2544)) and not v14:AffectingCombat() and v29) then
						v28 = v101();
						if (((5360 - (988 + 252)) <= (482 + 3778)) and v28) then
							return v28;
						end
					end
					if ((v82.ConsumeMagic:IsAvailable() and v37 and v82.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) or ((277 + 606) > (6748 - (49 + 1921)))) then
						if (v21(v82.ConsumeMagic, not v15:IsSpellInRange(v82.ConsumeMagic)) or ((4510 - (223 + 667)) >= (4943 - (51 + 1)))) then
							return "greater_purge damage";
						end
					end
					if (((7328 - 3070) > (2006 - 1069)) and v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v15:NPCID())) then
						if (v21(v82.ThrowGlaive, not v15:IsSpellInRange(v82.ThrowGlaive)) or ((5994 - (146 + 979)) < (256 + 650))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v16:NPCID())) or ((1830 - (311 + 294)) > (11790 - 7562))) then
						if (((1410 + 1918) > (3681 - (496 + 947))) and v21(v84.ThrowGlaiveMouseover, not v15:IsSpellInRange(v82.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v28 = v106();
					if (((5197 - (1233 + 125)) > (571 + 834)) and v28) then
						return v28;
					end
				end
				break;
			end
			if (((0 + 0) == v149) or ((246 + 1047) <= (2152 - (963 + 682)))) then
				v108();
				v107();
				v109();
				v149 = 1 + 0;
			end
			if ((v149 == (1508 - (504 + 1000))) or ((1951 + 945) < (734 + 71))) then
				v95 = v14:GCD() + 0.05 + 0;
				if (((3414 - 1098) == (1979 + 337)) and (v23.TargetIsValid() or v14:AffectingCombat())) then
					local v167 = 0 + 0;
					while true do
						if ((v167 == (183 - (156 + 26))) or ((1481 + 1089) == (2397 - 864))) then
							if ((v97 == (11275 - (149 + 15))) or ((1843 - (890 + 70)) == (1577 - (39 + 78)))) then
								v97 = v10.FightRemains(v86, false);
							end
							break;
						end
						if ((v167 == (482 - (14 + 468))) or ((10156 - 5537) <= (2792 - 1793))) then
							v96 = v10.BossFightRemains(nil, true);
							v97 = v96;
							v167 = 1 + 0;
						end
					end
				end
				v28 = v100();
				v149 = 4 + 1;
			end
			if ((v149 == (1 + 2)) or ((1541 + 1869) > (1079 + 3037))) then
				v86 = v14:GetEnemiesInMeleeRange(14 - 6);
				v87 = v14:GetEnemiesInMeleeRange(20 + 0);
				if (v30 or ((3172 - 2269) >= (78 + 2981))) then
					v88 = ((#v86 > (51 - (12 + 39))) and #v86) or (1 + 0);
					v89 = #v87;
				else
					v88 = 2 - 1;
					v89 = 3 - 2;
				end
				v149 = 2 + 2;
			end
			if ((v149 == (2 + 0)) or ((10082 - 6106) < (1903 + 954))) then
				v32 = EpicSettings.Toggles['movement'];
				if (((23825 - 18895) > (4017 - (1596 + 114))) and IsMouseButtonDown("RightButton")) then
					v33 = true;
				else
					v33 = false;
				end
				if (v14:IsDeadOrGhost() or ((10563 - 6517) < (2004 - (164 + 549)))) then
					return v28;
				end
				v149 = 1441 - (1059 + 379);
			end
			if ((v149 == (1 - 0)) or ((2198 + 2043) == (598 + 2947))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v149 = 394 - (145 + 247);
			end
		end
	end
	local function v111()
		v82.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(474 + 103, v110, v111);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

