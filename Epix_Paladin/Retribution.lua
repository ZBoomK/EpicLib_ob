local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1 + 0) == v5) or ((16 + 316) >= (5600 - (978 + 619)))) then
			return v6(...);
		end
		if ((v5 == (1354 - (243 + 1111))) or ((3007 + 284) <= (3438 - (91 + 67)))) then
			v6 = v0[v4];
			if (((13053 - 8667) >= (218 + 655)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 524 - (423 + 100);
		end
	end
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
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
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97 = v21.Commons.Everyone;
	local v98 = v19.Paladin.Retribution;
	local v99 = v20.Paladin.Retribution;
	local v100 = {};
	local function v101()
		if (((7 + 914) <= (3050 - 1948)) and v98.CleanseToxins:IsAvailable()) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 5792 + 5319;
	local v106 = 11882 - (326 + 445);
	local v107;
	local v108 = 0 - 0;
	local v109 = 0 - 0;
	local v110;
	v10:RegisterForEvent(function()
		local v127 = 0 - 0;
		while true do
			if (((5417 - (530 + 181)) >= (1844 - (614 + 267))) and (v127 == (32 - (19 + 13)))) then
				v105 = 18084 - 6973;
				v106 = 25892 - 14781;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v128 = 0 - 0;
		local v129;
		local v130;
		while true do
			if ((v128 == (1 + 0)) or ((1688 - 728) <= (1816 - 940))) then
				if ((v129 > v130) or ((3878 - (1293 + 519)) == (1900 - 968))) then
					return v129;
				end
				return v130;
			end
			if (((12597 - 7772) < (9261 - 4418)) and ((0 - 0) == v128)) then
				v129 = v15:GCDRemains();
				v130 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (23 - 13), v98.WakeofAshes:CooldownRemains());
				v128 = 1 + 0;
			end
		end
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local v113 = 0 + 0;
	local function v114()
		if ((v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(57 - 32)) or ((896 + 2981) >= (1508 + 3029))) then
			if ((v113 == (0 + 0)) or ((5411 - (709 + 387)) < (3584 - (673 + 1185)))) then
				v113 = GetTime();
			end
			if (v97.Wait(1450 - 950, v113) or ((11813 - 8134) < (1028 - 403))) then
				local v202 = 0 + 0;
				while true do
					if ((v202 == (0 + 0)) or ((6244 - 1619) < (156 + 476))) then
						if (v25(v102.CleanseToxinsFocus) or ((165 - 82) > (3494 - 1714))) then
							return "cleanse_toxins dispel";
						end
						v113 = 1880 - (446 + 1434);
						break;
					end
				end
			end
		end
	end
	local function v115()
		if (((1829 - (1040 + 243)) <= (3214 - 2137)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (v98.FlashofLight:IsReady() or ((2843 - (559 + 1288)) > (6232 - (609 + 1322)))) then
				if (((4524 - (13 + 441)) > (2567 - 1880)) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v116()
		if (v16:Exists() or ((1718 - 1062) >= (16584 - 13254))) then
			if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((93 + 2399) <= (1216 - 881))) then
				if (((1536 + 2786) >= (1123 + 1439)) and v25(v102.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(89 - 59) or ((1991 + 1646) >= (6933 - 3163))) then
			return;
		end
		if (v14 or ((1573 + 806) > (2547 + 2031))) then
			local v159 = 0 + 0;
			while true do
				if ((v159 == (1 + 0)) or ((473 + 10) > (1176 - (153 + 280)))) then
					if (((7085 - 4631) > (519 + 59)) and v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) then
						if (((368 + 562) < (2333 + 2125)) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((601 + 61) <= (705 + 267)) and v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
						if (((6654 - 2284) == (2701 + 1669)) and v25(v102.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if ((v159 == (667 - (89 + 578))) or ((3402 + 1360) <= (1789 - 928))) then
					if ((v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) or ((2461 - (572 + 477)) == (576 + 3688))) then
						if (v25(v102.WordofGloryFocus) or ((1902 + 1266) < (257 + 1896))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) or ((5062 - (84 + 2)) < (2194 - 862))) then
						if (((3335 + 1293) == (5470 - (497 + 345))) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					v159 = 1 + 0;
				end
			end
		end
	end
	local function v117()
		local v131 = 0 + 0;
		while true do
			if (((1333 - (605 + 728)) == v131) or ((39 + 15) == (878 - 483))) then
				v30 = v97.HandleTopTrinket(v100, v33, 2 + 38, nil);
				if (((303 - 221) == (74 + 8)) and v30) then
					return v30;
				end
				v131 = 2 - 1;
			end
			if ((v131 == (1 + 0)) or ((1070 - (457 + 32)) < (120 + 162))) then
				v30 = v97.HandleBottomTrinket(v100, v33, 1442 - (832 + 570), nil);
				if (v30 or ((4343 + 266) < (651 + 1844))) then
					return v30;
				end
				break;
			end
		end
	end
	local function v118()
		local v132 = 0 - 0;
		while true do
			if (((555 + 597) == (1948 - (588 + 208))) and (v132 == (0 - 0))) then
				if (((3696 - (884 + 916)) <= (7163 - 3741)) and v98.ArcaneTorrent:IsCastable() and v87 and ((v88 and v33) or not v88) and v98.FinalReckoning:IsAvailable()) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(5 + 3)) or ((1643 - (232 + 421)) > (3509 - (1569 + 320)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) or ((216 + 661) > (892 + 3803))) then
					if (((9068 - 6377) >= (2456 - (316 + 289))) and v25(v98.ShieldofVengeance, not v17:IsInRange(20 - 12))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (1457 - (666 + 787))) or ((3410 - (360 + 65)) >= (4539 + 317))) then
				if (((4530 - (79 + 175)) >= (1884 - 689)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((2523 + 709) <= (14376 - 9686)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v132 == (5 - 2)) or ((1795 - (503 + 396)) >= (3327 - (92 + 89)))) then
				if (((5937 - 2876) >= (1517 + 1441)) and v98.Judgment:IsCastable() and v43) then
					if (((1887 + 1300) >= (2521 - 1877)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if (((89 + 555) <= (1604 - 900)) and v98.HammerofWrath:IsReady() and v42) then
					if (((836 + 122) > (453 + 494)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v132 = 12 - 8;
			end
			if (((561 + 3931) >= (4046 - 1392)) and (v132 == (1246 - (485 + 759)))) then
				if (((7964 - 4522) >= (2692 - (442 + 747))) and v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (1139 - (832 + 303)))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((4116 - (88 + 858)) <= (447 + 1017))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35) or ((3970 + 827) == (181 + 4207))) then
					if (((1340 - (766 + 23)) <= (3361 - 2680)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v132 = 3 - 0;
			end
			if (((8633 - 5356) > (1381 - 974)) and (v132 == (1074 - (1036 + 37)))) then
				if (((3329 + 1366) >= (2755 - 1340)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (4 + 0))) then
					if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((4692 - (641 + 839)) <= (1857 - (910 + 3)))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (9 - 5))) or ((4780 - (1466 + 218)) <= (827 + 971))) then
					if (((4685 - (556 + 592)) == (1258 + 2279)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v132 = 810 - (329 + 479);
			end
		end
	end
	local function v119()
		local v133 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (864 - (174 + 680)))) or (v106 < (85 - 60)));
		if (((7953 - 4116) >= (1121 + 449)) and v133) then
			return v133;
		end
		if ((v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) or ((3689 - (396 + 343)) == (338 + 3474))) then
			if (((6200 - (29 + 1448)) >= (3707 - (135 + 1254))) and v25(v98.LightsJudgment, not v17:IsInRange(150 - 110))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (46 - 36))))) or ((1351 + 676) > (4379 - (389 + 1138)))) then
			if (v25(v98.Fireblood, not v17:IsInRange(584 - (102 + 472))) or ((1073 + 63) > (2394 + 1923))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((4428 + 320) == (6293 - (320 + 1225))) and v85 and ((v33 and v86) or not v86) and v17:IsInRange(14 - 6)) then
			local v160 = 0 + 0;
			while true do
				if (((5200 - (157 + 1307)) <= (6599 - (821 + 1038))) and (v160 == (0 - 0))) then
					v30 = v117();
					if (v30 or ((371 + 3019) <= (5435 - 2375))) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (6 + 9)) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) or ((2475 - 1476) > (3719 - (834 + 192)))) then
			if (((30 + 433) < (155 + 446)) and v25(v98.ShieldofVengeance)) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if ((v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (1 + 14))) or (v15:BuffStack(v98.CrusadeBuff) == (15 - 5)) or (v98.AvengingWrath:CooldownRemains() < (304.75 - (300 + 4))) or (v98.AvengingWrath:CooldownRemains() > (5 + 10))) and (((v108 >= (10 - 6)) and (v10.CombatTime() < (367 - (112 + 250)))) or ((v108 >= (2 + 1)) and (v10.CombatTime() > (12 - 7))) or ((v108 >= (2 + 0)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (5 + 3)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (9 + 3)))) or ((1083 + 1100) < (511 + 176))) then
			if (((5963 - (1001 + 413)) == (10143 - 5594)) and v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((5554 - (244 + 638)) == (5365 - (627 + 66))) and v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (11 - 7)) and (v10.CombatTime() < (607 - (512 + 90)))) or ((v108 >= (1909 - (1665 + 241))) and (v10.CombatTime() > (722 - (373 + 344)))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable() and ((v98.ExecutionSentence:IsAvailable() and ((v98.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v98.ExecutionSentence:CooldownRemains() > (39 - 24)) or not v98.ExecutionSentence:IsReady())) or (v98.FinalReckoning:IsAvailable() and ((v98.FinalReckoning:CooldownRemains() == (0 - 0)) or (v98.FinalReckoning:CooldownRemains() > (1129 - (35 + 1064))) or not v98.FinalReckoning:IsReady())))))) then
			if (v25(v98.AvengingWrath, not v17:IsInRange(8 + 2)) or ((7847 - 4179) < (2 + 393))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if ((v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (v15:BuffRemains(v98.CrusadeBuff) < v15:GCD()) and (((v108 >= (1241 - (298 + 938))) and (v10.CombatTime() < (1264 - (233 + 1026)))) or ((v108 >= (1669 - (636 + 1030))) and (v10.CombatTime() > (3 + 2))))) or ((4070 + 96) == (136 + 319))) then
			if (v25(v98.Crusade, not v17:IsInRange(1 + 9)) or ((4670 - (55 + 166)) == (517 + 2146))) then
				return "crusade cooldowns 14";
			end
		end
		if ((v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (1 + 3)) and (v10.CombatTime() < (30 - 22))) or ((v108 >= (300 - (36 + 261))) and (v10.CombatTime() >= (13 - 5))) or ((v108 >= (1370 - (34 + 1334))) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (4 + 6)) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (8 + 2))))) and ((v107 > (1283 - (1035 + 248))) or (v108 == (26 - (20 + 1))) or ((v108 >= (2 + 0)) and v98.DivineAuxiliary:IsAvailable()))) or ((4596 - (134 + 185)) < (4122 - (549 + 584)))) then
			if ((v96 == "player") or ((1555 - (314 + 371)) >= (14243 - 10094))) then
				if (((3180 - (478 + 490)) < (1687 + 1496)) and v25(v102.FinalReckoningPlayer, not v17:IsInRange(1182 - (786 + 386)))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if (((15048 - 10402) > (4371 - (1055 + 324))) and (v96 == "cursor")) then
				if (((2774 - (1093 + 247)) < (2761 + 345)) and v25(v102.FinalReckoningCursor, not v17:IsInRange(3 + 17))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v120()
		local v134 = 0 - 0;
		while true do
			if (((2667 - 1881) < (8601 - 5578)) and (v134 == (0 - 0))) then
				v110 = ((v104 >= (2 + 1)) or ((v104 >= (7 - 5)) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (82 - 58)));
				if ((v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (25 - 15))))) or ((3130 - (364 + 324)) < (202 - 128))) then
					if (((10882 - 6347) == (1504 + 3031)) and v25(v98.DivineStorm, not v17:IsInRange(41 - 31))) then
						return "divine_storm finishers 2";
					end
				end
				v134 = 1 - 0;
			end
			if ((v134 == (2 - 1)) or ((4277 - (1249 + 19)) <= (1901 + 204))) then
				if (((7123 - 5293) < (4755 - (686 + 400))) and v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (239 - (73 + 156)))))) then
					if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((7 + 1423) >= (4423 - (721 + 90)))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((31 + 2652) >= (7987 - 5527)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (473 - (224 + 246)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (16 - 6))))) then
					if (v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict)) or ((3320 - 1516) >= (595 + 2680))) then
						return "final verdict finishers 6";
					end
				end
				v134 = 1 + 1;
			end
			if ((v134 == (2 + 0)) or ((2816 - 1399) > (12076 - 8447))) then
				if (((5308 - (203 + 310)) > (2395 - (1238 + 755))) and v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1 + 2))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1544 - (709 + 825)))))) then
					if (((8868 - 4055) > (5192 - 1627)) and v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v135 = 864 - (196 + 668);
		while true do
			if (((15445 - 11533) == (8103 - 4191)) and (v135 == (835 - (171 + 662)))) then
				if (((2914 - (4 + 89)) <= (16907 - 12083)) and (v108 >= (2 + 1)) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (43 - 33))) then
					local v204 = 0 + 0;
					while true do
						if (((3224 - (35 + 1451)) <= (3648 - (28 + 1425))) and (v204 == (1993 - (941 + 1052)))) then
							v30 = v120();
							if (((40 + 1) <= (4532 - (822 + 692))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((3061 - 916) <= (1934 + 2170)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (301 - (45 + 252))) and (v104 >= (2 + 0))) then
					if (((926 + 1763) < (11791 - 6946)) and v25(v98.TemplarSlash, not v17:IsInRange(443 - (114 + 319)))) then
						return "templar_slash generators 8";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (3 - 0)) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (2 - 0)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (3 + 1)))) or ((3458 - 1136) > (5493 - 2871))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((6497 - (556 + 1407)) == (3288 - (741 + 465)))) then
						return "blade_of_justice generators 10";
					end
				end
				v135 = 468 - (170 + 295);
			end
			if ((v135 == (1 + 0)) or ((1444 + 127) > (4596 - 2729))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (3 + 0)) and v15:HasTier(20 + 11, 2 + 0)) or ((3884 - (957 + 273)) >= (802 + 2194))) then
					if (((1593 + 2385) > (8017 - 5913)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				if (((7892 - 4897) > (4706 - 3165)) and v98.DivineToll:IsCastable() and v40 and (v108 <= (9 - 7)) and ((v98.AvengingWrath:CooldownRemains() > (1795 - (389 + 1391))) or (v98.Crusade:CooldownRemains() > (10 + 5)) or (v106 < (1 + 7)))) then
					if (((7396 - 4147) > (1904 - (783 + 168))) and v25(v98.DivineToll, not v17:IsInRange(100 - 70))) then
						return "divine_toll generators 6";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(31 + 0, 313 - (309 + 2))) or ((10051 - 6778) > (5785 - (1090 + 122)))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1022 + 2129) < (4312 - 3028))) then
						return "judgment generators 7";
					end
				end
				v135 = 2 + 0;
			end
			if ((v135 == (1122 - (628 + 490))) or ((332 + 1518) == (3785 - 2256))) then
				if (((3751 - 2930) < (2897 - (431 + 343))) and v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (5 - 2)) or not v98.HolyBlade:IsAvailable())) then
					if (((2609 - 1707) < (1837 + 488)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((110 + 748) <= (4657 - (556 + 1139))) and ((v17:HealthPercentage() <= (35 - (6 + 9))) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff))) then
					local v205 = 0 + 0;
					while true do
						if ((v205 == (0 + 0)) or ((4115 - (28 + 141)) < (499 + 789))) then
							v30 = v120();
							if (v30 or ((4001 - 759) == (402 + 165))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (1319 - (486 + 831)))) or ((2204 - 1357) >= (4446 - 3183))) then
					if (v25(v98.Consecration, not v17:IsInRange(2 + 8)) or ((7123 - 4870) == (3114 - (668 + 595)))) then
						return "consecration generators 22";
					end
				end
				v135 = 5 + 0;
			end
			if ((v135 == (2 + 3)) or ((5691 - 3604) > (2662 - (23 + 267)))) then
				if ((v98.DivineHammer:IsCastable() and v38 and (v104 >= (1946 - (1129 + 815)))) or ((4832 - (371 + 16)) < (5899 - (1326 + 424)))) then
					if (v25(v98.DivineHammer, not v17:IsInRange(18 - 8)) or ((6643 - 4825) == (203 - (88 + 30)))) then
						return "divine_hammer generators 24";
					end
				end
				if (((1401 - (720 + 51)) < (4731 - 2604)) and v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1777.75 - (421 + 1355))) and ((v108 <= (2 - 0)) or ((v108 <= (2 + 1)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1085 - (286 + 797))))) or ((v108 == (14 - 10)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (2 - 0))) and (v98.Judgment:CooldownRemains() > (v109 * (441 - (397 + 42))))))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((606 + 1332) == (3314 - (24 + 776)))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v120();
				v135 = 8 - 2;
			end
			if (((5040 - (222 + 563)) >= (121 - 66)) and (v135 == (6 + 2))) then
				if (((3189 - (23 + 167)) > (2954 - (690 + 1108))) and v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (2 + 3)) and (v84 < v106)) then
					if (((1939 + 411) > (2003 - (40 + 808))) and v25(v98.ArcaneTorrent, not v17:IsInRange(2 + 8))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((15406 - 11377) <= (4639 + 214)) and v98.Consecration:IsCastable() and v36) then
					if (v25(v98.Consecration, not v17:IsInRange(6 + 4)) or ((283 + 233) > (4005 - (47 + 524)))) then
						return "consecration generators 30";
					end
				end
				if (((2626 + 1420) >= (8290 - 5257)) and v98.DivineHammer:IsCastable() and v38) then
					if (v25(v98.DivineHammer, not v17:IsInRange(14 - 4)) or ((6200 - 3481) <= (3173 - (1165 + 561)))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v135 == (1 + 2)) or ((12803 - 8669) < (1498 + 2428))) then
				if ((v98.HammerofWrath:IsReady() and v42 and ((v104 < (481 - (341 + 138))) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(9 + 21, 7 - 3)) and ((v108 <= (329 - (89 + 237))) or (v17:HealthPercentage() > (64 - 44)) or not v98.VanguardsMomentum:IsAvailable())) or ((344 - 180) >= (3666 - (581 + 300)))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((1745 - (855 + 365)) == (5009 - 2900))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((11 + 22) == (1268 - (1030 + 205))) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (4 + 0))) then
					if (((2842 + 212) <= (4301 - (156 + 130))) and v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if (((4251 - 2380) < (5699 - 2317)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (5 - 2)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((341 + 952) <= (1264 + 902)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				v135 = 73 - (10 + 59);
			end
			if ((v135 == (2 + 5)) or ((12700 - 10121) < (1286 - (671 + 492)))) then
				if ((v98.Judgment:IsReady() and v43 and ((v108 <= (3 + 0)) or not v98.BoundlessJudgment:IsAvailable())) or ((2061 - (369 + 846)) >= (627 + 1741))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((3424 + 588) <= (5303 - (1036 + 909)))) then
						return "judgment generators 32";
					end
				end
				if (((1188 + 306) <= (5045 - 2040)) and v98.HammerofWrath:IsReady() and v42 and ((v108 <= (206 - (11 + 192))) or (v17:HealthPercentage() > (11 + 9)) or not v98.VanguardsMomentum:IsAvailable())) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((3286 - (135 + 40)) == (5170 - 3036))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((1420 + 935) == (5187 - 2832)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((881 - 293) <= (608 - (50 + 126)))) then
						return "crusader_strike generators 26";
					end
				end
				v135 = 22 - 14;
			end
			if (((1062 + 3735) >= (5308 - (1233 + 180))) and (v135 == (975 - (522 + 447)))) then
				if (((4998 - (107 + 1314)) == (1660 + 1917)) and v30) then
					return v30;
				end
				if (((11560 - 7766) > (1569 + 2124)) and v98.TemplarSlash:IsReady() and v45) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(19 - 9)) or ((5044 - 3769) == (6010 - (716 + 1194)))) then
						return "templar_slash generators 28";
					end
				end
				if ((v98.TemplarStrike:IsReady() and v46) or ((28 + 1563) >= (384 + 3196))) then
					if (((1486 - (74 + 429)) <= (3487 - 1679)) and v25(v98.TemplarStrike, not v17:IsInRange(5 + 5))) then
						return "templar_strike generators 30";
					end
				end
				v135 = 15 - 8;
			end
			if (((0 + 0) == v135) or ((6628 - 4478) <= (2959 - 1762))) then
				if (((4202 - (279 + 154)) >= (1951 - (454 + 324))) and ((v108 >= (4 + 1)) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(48 - (12 + 5), 3 + 1) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (10 - 6))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(12 + 19, 1095 - (277 + 816))))) then
					local v206 = 0 - 0;
					while true do
						if (((2668 - (1058 + 125)) == (279 + 1206)) and ((975 - (815 + 160)) == v206)) then
							v30 = v120();
							if (v30 or ((14223 - 10908) <= (6603 - 3821))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (1 + 2)) and v15:HasTier(90 - 59, 1900 - (41 + 1857))) or ((2769 - (1222 + 671)) >= (7660 - 4696))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((3207 - 975) > (3679 - (229 + 953)))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1776 - (1111 + 663))) and ((v98.AvengingWrath:CooldownRemains() > (1579 - (874 + 705))) or (v98.Crusade:CooldownRemains() > (0 + 0)) or not v98.Crusade:IsAvailable() or not v98.AvengingWrath:IsReady()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (3 + 1)) or (v106 < (16 - 8)) or not v98.ExecutionSentence:IsReady())) or ((60 + 2050) <= (1011 - (642 + 37)))) then
					if (((841 + 2845) > (508 + 2664)) and v25(v98.WakeofAshes, not v17:IsInRange(25 - 15))) then
						return "wake_of_ashes generators 2";
					end
				end
				v135 = 455 - (233 + 221);
			end
		end
	end
	local function v122()
		local v136 = 0 - 0;
		while true do
			if (((0 + 0) == v136) or ((6015 - (718 + 823)) < (516 + 304))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useDivineHammer'];
				v136 = 806 - (266 + 539);
			end
			if (((12114 - 7835) >= (4107 - (636 + 589))) and (v136 == (4 - 2))) then
				v43 = EpicSettings.Settings['useJudgment'];
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v136 = 5 - 2;
			end
			if ((v136 == (4 + 0)) or ((738 + 1291) >= (4536 - (657 + 358)))) then
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v136 = 13 - 8;
			end
			if ((v136 == (6 - 3)) or ((3224 - (1151 + 36)) >= (4483 + 159))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v50 = EpicSettings.Settings['useCrusade'];
				v136 = 2 + 2;
			end
			if (((5136 - 3416) < (6290 - (1552 + 280))) and (v136 == (835 - (64 + 770)))) then
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v136 = 2 + 0;
			end
			if ((v136 == (11 - 6)) or ((78 + 358) > (4264 - (157 + 1086)))) then
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
		end
	end
	local function v123()
		local v137 = 0 - 0;
		while true do
			if (((3122 - 2409) <= (1299 - 452)) and (v137 == (5 - 1))) then
				v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (819 - (599 + 220));
				v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v137 = 1936 - (1813 + 118);
			end
			if (((1575 + 579) <= (5248 - (841 + 376))) and ((0 - 0) == v137)) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v60 = EpicSettings.Settings['useDivineShield'];
				v137 = 1 + 0;
			end
			if (((12596 - 7981) == (5474 - (464 + 395))) and ((12 - 7) == v137)) then
				v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v137 == (2 + 1)) or ((4627 - (467 + 370)) == (1033 - 533))) then
				v69 = EpicSettings.Settings['layonHandsHP'] or (0 + 0);
				v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
				v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v137 = 524 - (150 + 370);
			end
			if (((1371 - (74 + 1208)) < (543 - 322)) and (v137 == (4 - 3))) then
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v137 = 2 + 0;
			end
			if (((2444 - (14 + 376)) >= (2464 - 1043)) and (v137 == (2 + 0))) then
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
				v68 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v137 = 8 - 5;
			end
		end
	end
	local function v124()
		v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v81 = EpicSettings.Settings['InterruptWithStun'];
		v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v83 = EpicSettings.Settings['InterruptThreshold'];
		v78 = EpicSettings.Settings['DispelDebuffs'];
		v77 = EpicSettings.Settings['DispelBuffs'];
		v85 = EpicSettings.Settings['useTrinkets'];
		v87 = EpicSettings.Settings['useRacials'];
		v86 = EpicSettings.Settings['trinketsWithCD'];
		v88 = EpicSettings.Settings['racialsWithCD'];
		v90 = EpicSettings.Settings['useHealthstone'];
		v89 = EpicSettings.Settings['useHealingPotion'];
		v92 = EpicSettings.Settings['healthstoneHP'] or (78 - (23 + 55));
		v91 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v93 = EpicSettings.Settings['HealingPotionName'] or "";
		v79 = EpicSettings.Settings['handleAfflicted'];
		v80 = EpicSettings.Settings['HandleIncorporeal'];
		v94 = EpicSettings.Settings['HealOOC'];
		v95 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v125()
		v123();
		v122();
		v124();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (((622 + 70) < (4740 - 1682)) and v15:IsDeadOrGhost()) then
			return v30;
		end
		v103 = v15:GetEnemiesInMeleeRange(3 + 5);
		if (v32 or ((4155 - (652 + 249)) == (4429 - 2774))) then
			v104 = #v103;
		else
			local v161 = 1868 - (708 + 1160);
			while true do
				if ((v161 == (0 - 0)) or ((2362 - 1066) == (4937 - (10 + 17)))) then
					v103 = {};
					v104 = 1 + 0;
					break;
				end
			end
		end
		if (((5100 - (1400 + 332)) == (6459 - 3091)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if (((4551 - (242 + 1666)) < (1633 + 2182)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
				if (((702 + 1211) > (421 + 72)) and v25(v98.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		v107 = v111();
		if (((5695 - (850 + 90)) > (6003 - 2575)) and not v15:AffectingCombat()) then
			if (((2771 - (360 + 1030)) <= (2097 + 272)) and v98.RetributionAura:IsCastable() and (v112())) then
				if (v25(v98.RetributionAura) or ((13668 - 8825) == (5618 - 1534))) then
					return "retribution_aura";
				end
			end
		end
		if (((6330 - (909 + 752)) > (1586 - (109 + 1114))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (v15:AffectingCombat() or ((3435 - 1558) >= (1222 + 1916))) then
				if (((4984 - (6 + 236)) >= (2285 + 1341)) and v98.Intercession:IsCastable()) then
					if (v25(v98.Intercession, not v17:IsInRange(25 + 5), true) or ((10707 - 6167) == (1599 - 683))) then
						return "intercession target";
					end
				end
			elseif (v98.Redemption:IsCastable() or ((2289 - (1076 + 57)) > (715 + 3630))) then
				if (((2926 - (579 + 110)) < (336 + 3913)) and v25(v98.Redemption, not v17:IsInRange(27 + 3), true)) then
					return "redemption target";
				end
			end
		end
		if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1424 + 1259) < (430 - (174 + 233)))) then
			if (((1946 - 1249) <= (1449 - 623)) and v25(v102.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((492 + 613) <= (2350 - (663 + 511))) and v15:AffectingCombat()) then
			if (((3015 + 364) <= (828 + 2984)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (9 - 6)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v102.IntercessionMouseover) or ((478 + 310) >= (3804 - 2188))) then
					return "Intercession mouseover";
				end
			end
		end
		if (((4487 - 2633) <= (1613 + 1766)) and (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()))) then
			local v162 = 0 - 0;
			local v163;
			while true do
				if (((3242 + 1307) == (416 + 4133)) and (v162 == (722 - (478 + 244)))) then
					v163 = v78 and v98.CleanseToxins:IsReady() and v34;
					v30 = v97.FocusUnit(v163, v102, 537 - (440 + 77), nil, 12 + 13);
					v162 = 3 - 2;
				end
				if ((v162 == (1557 - (655 + 901))) or ((561 + 2461) >= (2316 + 708))) then
					if (((3255 + 1565) > (8854 - 6656)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (v34 or ((2506 - (695 + 750)) >= (16701 - 11810))) then
			v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 61 - 21, 100 - 75);
			if (((1715 - (285 + 66)) <= (10426 - 5953)) and v30) then
				return v30;
			end
			if ((v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((4905 - (682 + 628)) <= (1 + 2))) then
				if (v25(v102.BlessingofFreedomFocus) or ((4971 - (176 + 123)) == (1612 + 2240))) then
					return "blessing_of_freedom combat";
				end
			end
		end
		if (((1131 + 428) == (1828 - (239 + 30))) and (v97.TargetIsValid() or v15:AffectingCombat())) then
			local v164 = 0 + 0;
			while true do
				if ((v164 == (2 + 0)) or ((3100 - 1348) <= (2458 - 1670))) then
					v108 = v15:HolyPower();
					break;
				end
				if ((v164 == (316 - (306 + 9))) or ((13633 - 9726) == (31 + 146))) then
					if (((2130 + 1340) > (268 + 287)) and (v106 == (31773 - 20662))) then
						v106 = v10.FightRemains(v103, false);
					end
					v109 = v15:GCD();
					v164 = 1377 - (1140 + 235);
				end
				if ((v164 == (0 + 0)) or ((892 + 80) == (166 + 479))) then
					v105 = v10.BossFightRemains(nil, true);
					v106 = v105;
					v164 = 53 - (33 + 19);
				end
			end
		end
		if (((1149 + 2033) >= (6339 - 4224)) and v79) then
			if (((1715 + 2178) < (8685 - 4256)) and v75) then
				v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 38 + 2);
				if (v30 or ((3556 - (586 + 103)) < (174 + 1731))) then
					return v30;
				end
			end
			if ((v76 and (v108 > (5 - 3))) or ((3284 - (1309 + 179)) >= (7312 - 3261))) then
				local v203 = 0 + 0;
				while true do
					if (((4347 - 2728) <= (2838 + 918)) and (v203 == (0 - 0))) then
						v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 79 - 39, true);
						if (((1213 - (295 + 314)) == (1483 - 879)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (v80 or ((6446 - (1300 + 662)) == (2826 - 1926))) then
			v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 1785 - (1178 + 577), true);
			if (v30 or ((2316 + 2143) <= (3289 - 2176))) then
				return v30;
			end
			v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 1435 - (851 + 554), true);
			if (((3212 + 420) > (9423 - 6025)) and v30) then
				return v30;
			end
		end
		v30 = v115();
		if (((8865 - 4783) <= (5219 - (115 + 187))) and v30) then
			return v30;
		end
		if (((3701 + 1131) >= (1313 + 73)) and v78 and v34) then
			local v165 = 0 - 0;
			while true do
				if (((1298 - (160 + 1001)) == (120 + 17)) and (v165 == (0 + 0))) then
					if (v14 or ((3213 - 1643) >= (4690 - (237 + 121)))) then
						local v207 = 897 - (525 + 372);
						while true do
							if (((0 - 0) == v207) or ((13352 - 9288) <= (1961 - (96 + 46)))) then
								v30 = v114();
								if (v30 or ((5763 - (643 + 134)) < (569 + 1005))) then
									return v30;
								end
								break;
							end
						end
					end
					if (((10612 - 6186) > (638 - 466)) and v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) then
						if (((562 + 24) > (892 - 437)) and v98.CleanseToxins:IsReady()) then
							if (((1688 - 862) == (1545 - (316 + 403))) and v25(v102.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v30 = v116();
		if (v30 or ((2672 + 1347) > (12209 - 7768))) then
			return v30;
		end
		if (((729 + 1288) < (10730 - 6469)) and not v15:AffectingCombat() and v31 and v97.TargetIsValid()) then
			local v166 = 0 + 0;
			while true do
				if (((1520 + 3196) > (277 - 197)) and ((0 - 0) == v166)) then
					v30 = v118();
					if (v30 or ((7285 - 3778) == (188 + 3084))) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((1724 - 848) >= (151 + 2924))) then
			local v167 = 0 - 0;
			while true do
				if (((4369 - (12 + 5)) > (9919 - 7365)) and (v167 == (1 - 0))) then
					if ((v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) or ((9365 - 4959) < (10026 - 5983))) then
						if (v25(v98.DivineProtection) or ((384 + 1505) >= (5356 - (1656 + 317)))) then
							return "divine_protection defensive";
						end
					end
					if (((1686 + 206) <= (2191 + 543)) and v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
						if (((5113 - 3190) < (10915 - 8697)) and v25(v102.Healthstone)) then
							return "healthstone defensive";
						end
					end
					v167 = 356 - (5 + 349);
				end
				if (((10321 - 8148) > (1650 - (266 + 1005))) and (v167 == (2 + 0))) then
					if ((v89 and (v15:HealthPercentage() <= v91)) or ((8840 - 6249) == (4487 - 1078))) then
						local v208 = 1696 - (561 + 1135);
						while true do
							if (((5882 - 1368) > (10926 - 7602)) and (v208 == (1066 - (507 + 559)))) then
								if ((v93 == "Refreshing Healing Potion") or ((521 - 313) >= (14931 - 10103))) then
									if (v99.RefreshingHealingPotion:IsReady() or ((1971 - (212 + 176)) > (4472 - (250 + 655)))) then
										if (v25(v102.RefreshingHealingPotion) or ((3580 - 2267) == (1386 - 592))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if (((4965 - 1791) > (4858 - (1869 + 87))) and (v93 == "Dreamwalker's Healing Potion")) then
									if (((14289 - 10169) <= (6161 - (484 + 1417))) and v99.DreamwalkersHealingPotion:IsReady()) then
										if (v25(v102.RefreshingHealingPotion) or ((1892 - 1009) > (8007 - 3229))) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if ((v84 < v106) or ((4393 - (48 + 725)) >= (7989 - 3098))) then
						local v209 = 0 - 0;
						while true do
							if (((2475 + 1783) > (2503 - 1566)) and ((0 + 0) == v209)) then
								v30 = v119();
								if (v30 or ((1419 + 3450) < (1759 - (152 + 701)))) then
									return v30;
								end
								break;
							end
						end
					end
					v167 = 1314 - (430 + 881);
				end
				if ((v167 == (0 + 0)) or ((2120 - (557 + 338)) > (1250 + 2978))) then
					if (((9378 - 6050) > (7836 - 5598)) and v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) then
						if (((10199 - 6360) > (3027 - 1622)) and v25(v98.LayonHands)) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((2094 - (499 + 302)) <= (1373 - (39 + 827)))) then
						if (v25(v98.DivineShield) or ((7994 - 5098) < (1797 - 992))) then
							return "divine_shield defensive";
						end
					end
					v167 = 3 - 2;
				end
				if (((3555 - 1239) == (199 + 2117)) and (v167 == (8 - 5))) then
					v30 = v121();
					if (v30 or ((412 + 2158) == (2425 - 892))) then
						return v30;
					end
					v167 = 108 - (103 + 1);
				end
				if ((v167 == (558 - (475 + 79))) or ((1908 - 1025) == (4672 - 3212))) then
					if (v25(v98.Pool) or ((597 + 4022) <= (880 + 119))) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v156 = 1503 - (1395 + 108);
		while true do
			if ((v156 == (0 - 0)) or ((4614 - (7 + 1197)) > (1795 + 2321))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v101();
				break;
			end
		end
	end
	v21.SetAPL(25 + 45, v125, v126);
end;
return v0["Epix_Paladin_Retribution.lua"]();

