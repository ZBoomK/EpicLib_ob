local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 802 - (151 + 651);
	local v6;
	while true do
		if (((935 + 123) > (1307 - (802 + 24))) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if (((4237 - 882) >= (422 + 2430)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((173 + 876) <= (196 + 710))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
		if (((15049 - 10536) > (976 + 1750)) and v98.CleanseToxins:IsAvailable()) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 4523 + 6588;
	local v106 = 9166 + 1945;
	local v107;
	local v108 = 0 + 0;
	local v109 = 0 + 0;
	local v110;
	v10:RegisterForEvent(function()
		local v126 = 1433 - (797 + 636);
		while true do
			if ((v126 == (0 - 0)) or ((3100 - (1427 + 192)) >= (921 + 1737))) then
				v105 = 25797 - 14686;
				v106 = 9988 + 1123;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v127 = v15:GCDRemains();
		local v128 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (5 + 5), v98.WakeofAshes:CooldownRemains());
		if ((v127 > v128) or ((3546 - (192 + 134)) == (2640 - (316 + 960)))) then
			return v127;
		end
		return v128;
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v113()
		if ((v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(14 + 11)) or ((814 + 240) > (3136 + 256))) then
			if (v25(v102.CleanseToxinsFocus) or ((2584 - 1908) >= (2193 - (83 + 468)))) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v114()
		if (((5942 - (1202 + 604)) > (11189 - 8792)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (v98.FlashofLight:IsReady() or ((7213 - 2879) == (11753 - 7508))) then
				if (v25(v98.FlashofLight) or ((4601 - (45 + 280)) <= (2926 + 105))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		if (v16:Exists() or ((4178 + 604) <= (438 + 761))) then
			if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((2692 + 2172) < (335 + 1567))) then
				if (((8960 - 4121) >= (5611 - (340 + 1571))) and v25(v102.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(12 + 18) or ((2847 - (1733 + 39)) > (5270 - 3352))) then
			return;
		end
		if (((1430 - (125 + 909)) <= (5752 - (1096 + 852))) and v14) then
			local v151 = 0 + 0;
			while true do
				if ((v151 == (1 - 0)) or ((4044 + 125) == (2699 - (409 + 103)))) then
					if (((1642 - (46 + 190)) == (1501 - (51 + 44))) and v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) then
						if (((432 + 1099) < (5588 - (1114 + 203))) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((1361 - (228 + 498)) == (138 + 497)) and v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
						if (((1864 + 1509) <= (4219 - (174 + 489))) and v25(v102.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if ((v151 == (0 - 0)) or ((5196 - (830 + 1075)) < (3804 - (303 + 221)))) then
					if (((5655 - (231 + 1038)) >= (728 + 145)) and v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) then
						if (((2083 - (171 + 991)) <= (4541 - 3439)) and v25(v102.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((12636 - 7930) >= (2402 - 1439)) and v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) then
						if (v25(v102.LayonHandsFocus) or ((769 + 191) <= (3070 - 2194))) then
							return "lay_on_hands defensive focus";
						end
					end
					v151 = 2 - 1;
				end
			end
		end
	end
	local function v116()
		v30 = v97.HandleTopTrinket(v100, v33, 64 - 24, nil);
		if (v30 or ((6386 - 4320) == (2180 - (111 + 1137)))) then
			return v30;
		end
		v30 = v97.HandleBottomTrinket(v100, v33, 198 - (91 + 67), nil);
		if (((14360 - 9535) < (1209 + 3634)) and v30) then
			return v30;
		end
	end
	local function v117()
		if ((v98.ArcaneTorrent:IsCastable() and v87 and ((v88 and v33) or not v88) and v98.FinalReckoning:IsAvailable()) or ((4400 - (423 + 100)) >= (32 + 4505))) then
			if (v25(v98.ArcaneTorrent, not v17:IsInRange(21 - 13)) or ((2250 + 2065) < (2497 - (326 + 445)))) then
				return "arcane_torrent precombat 0";
			end
		end
		if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) or ((16054 - 12375) < (1392 - 767))) then
			if (v25(v98.ShieldofVengeance, not v17:IsInRange(18 - 10)) or ((5336 - (530 + 181)) < (1513 - (614 + 267)))) then
				return "shield_of_vengeance precombat 1";
			end
		end
		if ((v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (36 - (19 + 13)))) or ((134 - 51) > (4148 - 2368))) then
			if (((1559 - 1013) <= (280 + 797)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
				return "juscticars vengeance precombat 2";
			end
		end
		if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (6 - 2))) or ((2065 - 1069) > (6113 - (1293 + 519)))) then
			if (((8304 - 4234) > (1793 - 1106)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
				return "final verdict precombat 3";
			end
		end
		if ((v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (7 - 3))) or ((2828 - 2172) >= (7844 - 4514))) then
			if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((1320 + 1172) <= (69 + 266))) then
				return "templars verdict precombat 4";
			end
		end
		if (((10041 - 5719) >= (593 + 1969)) and v98.BladeofJustice:IsCastable() and v35) then
			if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((1209 + 2428) >= (2356 + 1414))) then
				return "blade_of_justice precombat 5";
			end
		end
		if ((v98.Judgment:IsCastable() and v43) or ((3475 - (709 + 387)) > (6436 - (673 + 1185)))) then
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1400 - 917) > (2385 - 1642))) then
				return "judgment precombat 6";
			end
		end
		if (((4037 - 1583) > (414 + 164)) and v98.HammerofWrath:IsReady() and v42) then
			if (((695 + 235) < (6018 - 1560)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
				return "hammer_of_wrath precombat 7";
			end
		end
		if (((163 + 499) <= (1937 - 965)) and v98.CrusaderStrike:IsCastable() and v37) then
			if (((8578 - 4208) == (6250 - (446 + 1434))) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
				return "crusader_strike precombat 180";
			end
		end
	end
	local function v118()
		local v129 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (1293 - (1040 + 243)))) or (v106 < (74 - 49)));
		if (v129 or ((6609 - (559 + 1288)) <= (2792 - (609 + 1322)))) then
			return v129;
		end
		if ((v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) or ((1866 - (13 + 441)) == (15933 - 11669))) then
			if (v25(v98.LightsJudgment, not v17:IsInRange(104 - 64)) or ((15778 - 12610) < (81 + 2072))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (36 - 26))))) or ((1768 + 3208) < (584 + 748))) then
			if (((13733 - 9105) == (2533 + 2095)) and v25(v98.Fireblood, not v17:IsInRange(18 - 8))) then
				return "fireblood cooldowns 6";
			end
		end
		if ((v85 and ((v33 and v86) or not v86) and v17:IsInRange(6 + 2)) or ((31 + 23) == (284 + 111))) then
			v30 = v116();
			if (((69 + 13) == (81 + 1)) and v30) then
				return v30;
			end
		end
		if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (448 - (153 + 280))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) or ((1677 - 1096) < (254 + 28))) then
			if (v25(v98.ShieldofVengeance) or ((1820 + 2789) < (1306 + 1189))) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((1046 + 106) == (835 + 317)) and v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (22 - 7))) or (v15:BuffStack(v98.CrusadeBuff) == (7 + 3)) or (v98.AvengingWrath:CooldownRemains() < (667.75 - (89 + 578))) or (v98.AvengingWrath:CooldownRemains() > (11 + 4))) and (((v108 >= (8 - 4)) and (v10.CombatTime() < (1054 - (572 + 477)))) or ((v108 >= (1 + 2)) and (v10.CombatTime() > (4 + 1))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (94 - (84 + 2))) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (19 - 7)))) then
			if (((1366 + 530) <= (4264 - (497 + 345))) and v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if ((v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (1 + 3)) and (v10.CombatTime() < (1 + 4))) or ((v108 >= (1336 - (605 + 728))) and (v10.CombatTime() > (4 + 1))) or ((v108 >= (3 - 1)) and v98.DivineAuxiliary:IsAvailable() and ((v98.ExecutionSentence:IsAvailable() and ((v98.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v98.ExecutionSentence:CooldownRemains() > (55 - 40)) or not v98.ExecutionSentence:IsReady())) or (v98.FinalReckoning:IsAvailable() and ((v98.FinalReckoning:CooldownRemains() == (0 + 0)) or (v98.FinalReckoning:CooldownRemains() > (83 - 53)) or not v98.FinalReckoning:IsReady())))))) or ((748 + 242) > (2109 - (457 + 32)))) then
			if (v25(v98.AvengingWrath, not v17:IsInRange(5 + 5)) or ((2279 - (832 + 570)) > (4424 + 271))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if (((702 + 1989) >= (6550 - 4699)) and v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (v15:BuffRemains(v98.CrusadeBuff) < v15:GCD()) and (((v108 >= (3 + 2)) and (v10.CombatTime() < (801 - (588 + 208)))) or ((v108 >= (8 - 5)) and (v10.CombatTime() > (1805 - (884 + 916)))))) then
			if (v25(v98.Crusade, not v17:IsInRange(20 - 10)) or ((1731 + 1254) >= (5509 - (232 + 421)))) then
				return "crusade cooldowns 14";
			end
		end
		if (((6165 - (1569 + 320)) >= (294 + 901)) and v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (1 + 3)) and (v10.CombatTime() < (26 - 18))) or ((v108 >= (608 - (316 + 289))) and (v10.CombatTime() >= (20 - 12))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (1463 - (666 + 787))) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (435 - (360 + 65)))))) and ((v107 > (0 + 0)) or (v108 == (259 - (79 + 175))) or ((v108 >= (2 - 0)) and v98.DivineAuxiliary:IsAvailable()))) then
			if (((2523 + 709) <= (14376 - 9686)) and (v96 == "player")) then
				if (v25(v102.FinalReckoningPlayer, not v17:IsInRange(19 - 9)) or ((1795 - (503 + 396)) >= (3327 - (92 + 89)))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if (((5937 - 2876) >= (1517 + 1441)) and (v96 == "cursor")) then
				if (((1887 + 1300) >= (2521 - 1877)) and v25(v102.FinalReckoningCursor, not v17:IsInRange(3 + 17))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v119()
		local v130 = 0 - 0;
		while true do
			if (((562 + 82) <= (337 + 367)) and (v130 == (0 - 0))) then
				v110 = ((v104 >= (1 + 2)) or ((v104 >= (2 - 0)) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (1268 - (485 + 759))));
				if (((2216 - 1258) > (2136 - (442 + 747))) and v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1138 - (832 + 303)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (956 - (88 + 858)))))) then
					if (((1370 + 3122) >= (2197 + 457)) and v25(v98.DivineStorm, not v17:IsInRange(1 + 9))) then
						return "divine_storm finishers 2";
					end
				end
				v130 = 790 - (766 + 23);
			end
			if (((16992 - 13550) >= (2054 - 551)) and (v130 == (2 - 1))) then
				if ((v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (10 - 7))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1083 - (1036 + 37)))))) or ((2248 + 922) <= (2850 - 1386))) then
					if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((3774 + 1023) == (5868 - (641 + 839)))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((1464 - (910 + 3)) <= (1736 - 1055)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1687 - (1466 + 218)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (5 + 5))))) then
					if (((4425 - (556 + 592)) > (145 + 262)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v130 = 810 - (329 + 479);
			end
			if (((5549 - (174 + 680)) >= (4862 - 3447)) and (v130 == (3 - 1))) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (749 - (396 + 343)))))) or ((285 + 2927) <= (2421 - (29 + 1448)))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((4485 - (135 + 1254)) <= (6773 - 4975))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v131 = 0 - 0;
		while true do
			if (((2358 + 1179) == (5064 - (389 + 1138))) and (v131 == (576 - (102 + 472)))) then
				if (((3621 + 216) >= (871 + 699)) and (v108 >= (3 + 0)) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1555 - (320 + 1225)))) then
					v30 = v119();
					if (v30 or ((5251 - 2301) == (2333 + 1479))) then
						return v30;
					end
				end
				if (((6187 - (157 + 1307)) >= (4177 - (821 + 1038))) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (9 - 5)) and (v104 >= (1 + 1))) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(17 - 7)) or ((755 + 1272) > (7068 - 4216))) then
						return "templar_slash generators 8";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (1029 - (834 + 192))) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (1 + 1)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (2 + 2)))) or ((25 + 1111) > (6687 - 2370))) then
					if (((5052 - (300 + 4)) == (1269 + 3479)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v131 = 7 - 4;
			end
			if (((4098 - (112 + 250)) <= (1890 + 2850)) and (v131 == (7 - 4))) then
				if ((v98.HammerofWrath:IsReady() and v42 and ((v104 < (2 + 0)) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(16 + 14, 3 + 1)) and ((v108 <= (2 + 1)) or (v17:HealthPercentage() > (15 + 5)) or not v98.VanguardsMomentum:IsAvailable())) or ((4804 - (1001 + 413)) <= (6823 - 3763))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((1881 - (244 + 638)) > (3386 - (627 + 66)))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((1379 - 916) < (1203 - (512 + 90))) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (1910 - (1665 + 241)))) then
					if (v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash)) or ((2900 - (373 + 344)) < (310 + 377))) then
						return "templar_slash generators 14";
					end
				end
				if (((1204 + 3345) == (11998 - 7449)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (4 - 1)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((5771 - (35 + 1064)) == (3400 + 1272)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				v131 = 8 - 4;
			end
			if ((v131 == (1 + 4)) or ((4904 - (298 + 938)) < (1654 - (233 + 1026)))) then
				if ((v98.DivineHammer:IsCastable() and v38 and (v104 >= (1668 - (636 + 1030)))) or ((2130 + 2036) == (445 + 10))) then
					if (v25(v98.DivineHammer, not v17:IsInRange(3 + 7)) or ((301 + 4148) == (2884 - (55 + 166)))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v108 <= (1 + 1)) or ((v108 <= (11 - 8)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (299 - (36 + 261))))) or ((v108 == (6 - 2)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1370 - (34 + 1334)))) and (v98.Judgment:CooldownRemains() > (v109 * (1 + 1)))))) or ((3324 + 953) < (4272 - (1035 + 248)))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((891 - (20 + 1)) >= (2162 + 1987))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v119();
				v131 = 325 - (134 + 185);
			end
			if (((3345 - (549 + 584)) < (3868 - (314 + 371))) and ((13 - 9) == v131)) then
				if (((5614 - (478 + 490)) > (1585 + 1407)) and v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (1175 - (786 + 386))) or not v98.HolyBlade:IsAvailable())) then
					if (((4644 - 3210) < (4485 - (1055 + 324))) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((2126 - (1093 + 247)) < (2687 + 336)) and ((v17:HealthPercentage() <= (3 + 17)) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff))) then
					v30 = v119();
					if (v30 or ((9695 - 7253) < (251 - 177))) then
						return v30;
					end
				end
				if (((12904 - 8369) == (11396 - 6861)) and v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (1 + 1))) then
					if (v25(v98.Consecration, not v17:IsInRange(38 - 28)) or ((10371 - 7362) <= (1588 + 517))) then
						return "consecration generators 22";
					end
				end
				v131 = 12 - 7;
			end
			if (((2518 - (364 + 324)) < (10057 - 6388)) and (v131 == (2 - 1))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (1 + 2)) and v15:HasTier(129 - 98, 2 - 0)) or ((4343 - 2913) >= (4880 - (1249 + 19)))) then
					if (((2422 + 261) >= (9575 - 7115)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				if ((v98.DivineToll:IsCastable() and v40 and (v108 <= (1088 - (686 + 400))) and ((v98.AvengingWrath:CooldownRemains() > (12 + 3)) or (v98.Crusade:CooldownRemains() > (244 - (73 + 156))) or (v106 < (1 + 7)))) or ((2615 - (721 + 90)) >= (37 + 3238))) then
					if (v25(v98.DivineToll, not v17:IsInRange(97 - 67)) or ((1887 - (224 + 246)) > (5878 - 2249))) then
						return "divine_toll generators 6";
					end
				end
				if (((8828 - 4033) > (73 + 329)) and v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(1 + 30, 2 + 0)) then
					if (((9568 - 4755) > (11863 - 8298)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 7";
					end
				end
				v131 = 515 - (203 + 310);
			end
			if (((5905 - (1238 + 755)) == (274 + 3638)) and (v131 == (1541 - (709 + 825)))) then
				if (((5198 - 2377) <= (7026 - 2202)) and v98.Judgment:IsReady() and v43 and ((v108 <= (867 - (196 + 668))) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((6861 - 5123) <= (4546 - 2351)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 32";
					end
				end
				if (((874 - (171 + 662)) <= (3111 - (4 + 89))) and v98.HammerofWrath:IsReady() and v42 and ((v108 <= (10 - 7)) or (v17:HealthPercentage() > (8 + 12)) or not v98.VanguardsMomentum:IsAvailable())) then
					if (((9421 - 7276) <= (1610 + 2494)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((4175 - (35 + 1451)) < (6298 - (28 + 1425))) and v98.CrusaderStrike:IsCastable() and v37) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((4315 - (941 + 1052)) > (2515 + 107))) then
						return "crusader_strike generators 26";
					end
				end
				v131 = 1522 - (822 + 692);
			end
			if ((v131 == (11 - 3)) or ((2136 + 2398) == (2379 - (45 + 252)))) then
				if ((v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (5 + 0)) and (v84 < v106)) or ((541 + 1030) > (4543 - 2676))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(443 - (114 + 319))) or ((3810 - 1156) >= (3838 - 842))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((2536 + 1442) > (3134 - 1030)) and v98.Consecration:IsCastable() and v36) then
					if (((6275 - 3280) > (3504 - (556 + 1407))) and v25(v98.Consecration, not v17:IsInRange(1216 - (741 + 465)))) then
						return "consecration generators 30";
					end
				end
				if (((3714 - (170 + 295)) > (503 + 450)) and v98.DivineHammer:IsCastable() and v38) then
					if (v25(v98.DivineHammer, not v17:IsInRange(10 + 0)) or ((8058 - 4785) > (3791 + 782))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v131 == (4 + 2)) or ((1785 + 1366) < (2514 - (957 + 273)))) then
				if (v30 or ((495 + 1355) == (613 + 916))) then
					return v30;
				end
				if (((3128 - 2307) < (5594 - 3471)) and v98.TemplarSlash:IsReady() and v45) then
					if (((2754 - 1852) < (11512 - 9187)) and v25(v98.TemplarSlash, not v17:IsInRange(1790 - (389 + 1391)))) then
						return "templar_slash generators 28";
					end
				end
				if (((539 + 319) <= (309 + 2653)) and v98.TemplarStrike:IsReady() and v46) then
					if (v25(v98.TemplarStrike, not v17:IsInRange(22 - 12)) or ((4897 - (783 + 168)) < (4322 - 3034))) then
						return "templar_strike generators 30";
					end
				end
				v131 = 7 + 0;
			end
			if (((311 - (309 + 2)) == v131) or ((9955 - 6713) == (1779 - (1090 + 122)))) then
				if ((v108 >= (2 + 3)) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(104 - 73, 3 + 1) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (1122 - (628 + 490)))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(6 + 25, 4 - 2)) or ((3870 - 3023) >= (2037 - (431 + 343)))) then
					v30 = v119();
					if (v30 or ((4550 - 2297) == (5354 - 3503))) then
						return v30;
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (3 + 0)) and v15:HasTier(4 + 27, 1697 - (556 + 1139))) or ((2102 - (6 + 9)) > (435 + 1937))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((2278 + 2167) < (4318 - (28 + 141)))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1 + 1)) and ((v98.AvengingWrath:CooldownRemains() > (0 - 0)) or (v98.Crusade:CooldownRemains() > (0 + 0)) or not v98.Crusade:IsAvailable() or not v98.AvengingWrath:IsReady()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (1321 - (486 + 831))) or (v106 < (20 - 12)) or not v98.ExecutionSentence:IsReady())) or ((6400 - 4582) == (17 + 68))) then
					if (((1992 - 1362) < (3390 - (668 + 595))) and v25(v98.WakeofAshes, not v17:IsInRange(9 + 1))) then
						return "wake_of_ashes generators 2";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v121()
		local v132 = 0 - 0;
		while true do
			if ((v132 == (296 - (23 + 267))) or ((3882 - (1129 + 815)) == (2901 - (371 + 16)))) then
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v132 = 1757 - (1326 + 424);
			end
			if (((8058 - 3803) >= (200 - 145)) and (v132 == (121 - (88 + 30)))) then
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v132 = 775 - (720 + 51);
			end
			if (((6670 - 3671) > (2932 - (421 + 1355))) and (v132 == (6 - 2))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v132 = 3 + 2;
			end
			if (((3433 - (286 + 797)) > (4222 - 3067)) and (v132 == (1 - 0))) then
				v38 = EpicSettings.Settings['useDivineHammer'];
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v132 = 441 - (397 + 42);
			end
			if (((1259 + 2770) <= (5653 - (24 + 776))) and (v132 == (7 - 2))) then
				v50 = EpicSettings.Settings['useCrusade'];
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v132 = 791 - (222 + 563);
			end
			if ((v132 == (3 - 1)) or ((372 + 144) > (3624 - (23 + 167)))) then
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v43 = EpicSettings.Settings['useJudgment'];
				v132 = 1801 - (690 + 1108);
			end
			if (((1460 + 2586) >= (2502 + 531)) and (v132 == (855 - (40 + 808)))) then
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v132 == (0 + 0)) or ((10397 - 7678) <= (1384 + 63))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v132 = 1 + 0;
			end
		end
	end
	local function v122()
		local v133 = 0 + 0;
		while true do
			if ((v133 == (575 - (47 + 524))) or ((2683 + 1451) < (10731 - 6805))) then
				v69 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
				v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (1726 - (1165 + 561));
				v133 = 1 + 4;
			end
			if ((v133 == (6 - 4)) or ((63 + 101) >= (3264 - (341 + 138)))) then
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v133 = 1 + 2;
			end
			if ((v133 == (0 - 0)) or ((851 - (89 + 237)) == (6784 - 4675))) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v133 = 1 - 0;
			end
			if (((914 - (581 + 300)) == (1253 - (855 + 365))) and (v133 == (11 - 6))) then
				v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 + 0);
				v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (1235 - (1030 + 205));
				v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v133 = 6 + 0;
			end
			if (((3340 - (156 + 130)) <= (9122 - 5107)) and ((4 - 1) == v133)) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v68 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v133 = 3 + 1;
			end
			if (((1940 - (10 + 59)) < (957 + 2425)) and ((4 - 3) == v133)) then
				v60 = EpicSettings.Settings['useDivineShield'];
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v133 = 1165 - (671 + 492);
			end
			if (((1030 + 263) <= (3381 - (369 + 846))) and (v133 == (2 + 4))) then
				v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
		end
	end
	local function v123()
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
		v92 = EpicSettings.Settings['healthstoneHP'] or (1945 - (1036 + 909));
		v91 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v93 = EpicSettings.Settings['HealingPotionName'] or "";
		v79 = EpicSettings.Settings['handleAfflicted'];
		v80 = EpicSettings.Settings['HandleIncorporeal'];
		v94 = EpicSettings.Settings['HealOOC'];
		v95 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v124()
		local v148 = 203 - (11 + 192);
		while true do
			if ((v148 == (3 + 2)) or ((2754 - (135 + 40)) < (297 - 174))) then
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((510 + 336) >= (5216 - 2848))) then
					if (v15:AffectingCombat() or ((6013 - 2001) <= (3534 - (50 + 126)))) then
						if (((4160 - 2666) <= (666 + 2339)) and v98.Intercession:IsCastable()) then
							if (v25(v98.Intercession, not v17:IsInRange(1443 - (1233 + 180)), true) or ((4080 - (522 + 447)) == (3555 - (107 + 1314)))) then
								return "intercession target";
							end
						end
					elseif (((1093 + 1262) == (7175 - 4820)) and v98.Redemption:IsCastable()) then
						if (v25(v98.Redemption, not v17:IsInRange(13 + 17), true) or ((1167 - 579) <= (1709 - 1277))) then
							return "redemption target";
						end
					end
				end
				if (((6707 - (716 + 1194)) >= (67 + 3828)) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((384 + 3193) == (4080 - (74 + 429))) and v25(v102.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((7318 - 3524) > (1831 + 1862)) and v15:AffectingCombat()) then
					if ((v98.Intercession:IsCastable() and (v15:HolyPower() >= (6 - 3)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((903 + 372) == (12640 - 8540))) then
						if (v25(v102.IntercessionMouseover) or ((3933 - 2342) >= (4013 - (279 + 154)))) then
							return "Intercession mouseover";
						end
					end
				end
				v148 = 784 - (454 + 324);
			end
			if (((774 + 209) <= (1825 - (12 + 5))) and (v148 == (4 + 2))) then
				if (v97.TargetIsValid() or v15:AffectingCombat() or ((5478 - 3328) <= (443 + 754))) then
					local v190 = 1093 - (277 + 816);
					while true do
						if (((16105 - 12336) >= (2356 - (1058 + 125))) and (v190 == (0 + 0))) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							v190 = 976 - (815 + 160);
						end
						if (((6371 - 4886) == (3525 - 2040)) and (v190 == (1 + 0))) then
							if ((v106 == (32479 - 21368)) or ((5213 - (41 + 1857)) <= (4675 - (1222 + 671)))) then
								v106 = v10.FightRemains(v103, false);
							end
							v109 = v15:GCD();
							v190 = 5 - 3;
						end
						if ((v190 == (2 - 0)) or ((2058 - (229 + 953)) >= (4738 - (1111 + 663)))) then
							v108 = v15:HolyPower();
							break;
						end
					end
				end
				if (v79 or ((3811 - (874 + 705)) > (350 + 2147))) then
					local v191 = 0 + 0;
					while true do
						if ((v191 == (0 - 0)) or ((60 + 2050) <= (1011 - (642 + 37)))) then
							if (((841 + 2845) > (508 + 2664)) and v75) then
								local v195 = 0 - 0;
								while true do
									if ((v195 == (454 - (233 + 221))) or ((10345 - 5871) < (722 + 98))) then
										v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 1581 - (718 + 823));
										if (((2693 + 1586) >= (3687 - (266 + 539))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v76 and (v108 > (5 - 3))) or ((3254 - (636 + 589)) >= (8357 - 4836))) then
								v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 82 - 42, true);
								if (v30 or ((1615 + 422) >= (1687 + 2955))) then
									return v30;
								end
							end
							break;
						end
					end
				end
				if (((2735 - (657 + 358)) < (11803 - 7345)) and v80) then
					v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 68 - 38, true);
					if (v30 or ((1623 - (1151 + 36)) > (2918 + 103))) then
						return v30;
					end
					v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 8 + 22, true);
					if (((2129 - 1416) <= (2679 - (1552 + 280))) and v30) then
						return v30;
					end
				end
				v148 = 841 - (64 + 770);
			end
			if (((1463 + 691) <= (9150 - 5119)) and (v148 == (2 + 5))) then
				v30 = v114();
				if (((5858 - (157 + 1086)) == (9237 - 4622)) and v30) then
					return v30;
				end
				if ((v78 and v34) or ((16599 - 12809) == (766 - 266))) then
					local v192 = 0 - 0;
					while true do
						if (((908 - (599 + 220)) < (439 - 218)) and (v192 == (1931 - (1813 + 118)))) then
							if (((1502 + 552) >= (2638 - (841 + 376))) and v14) then
								v30 = v113();
								if (((969 - 277) < (711 + 2347)) and v30) then
									return v30;
								end
							end
							if ((v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) or ((8881 - 5627) == (2514 - (464 + 395)))) then
								if (v98.CleanseToxins:IsReady() or ((3326 - 2030) == (2358 + 2552))) then
									if (((4205 - (467 + 370)) == (6959 - 3591)) and v25(v102.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v148 = 6 + 2;
			end
			if (((9060 - 6417) < (596 + 3219)) and ((0 - 0) == v148)) then
				v122();
				v121();
				v123();
				v148 = 521 - (150 + 370);
			end
			if (((3195 - (74 + 1208)) > (1212 - 719)) and ((14 - 11) == v148)) then
				if (((3384 + 1371) > (3818 - (14 + 376))) and v32) then
					v104 = #v103;
				else
					v103 = {};
					v104 = 1 - 0;
				end
				if (((894 + 487) <= (2082 + 287)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) or ((4619 + 224) == (11966 - 7882))) then
						if (((3513 + 1156) > (441 - (23 + 55))) and v25(v98.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()) or ((4447 - 2570) >= (2094 + 1044))) then
					local v193 = v78 and v98.CleanseToxins:IsReady() and v34;
					v30 = v97.FocusUnit(v193, v102, 18 + 2, nil, 38 - 13);
					if (((1492 + 3250) >= (4527 - (652 + 249))) and v30) then
						return v30;
					end
				end
				v148 = 10 - 6;
			end
			if ((v148 == (1869 - (708 + 1160))) or ((12323 - 7783) == (1669 - 753))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v148 = 29 - (10 + 17);
			end
			if ((v148 == (1 + 1)) or ((2888 - (1400 + 332)) > (8334 - 3989))) then
				v34 = EpicSettings.Toggles['dispel'];
				if (((4145 - (242 + 1666)) < (1819 + 2430)) and v15:IsDeadOrGhost()) then
					return v30;
				end
				v103 = v15:GetEnemiesInMeleeRange(3 + 5);
				v148 = 3 + 0;
			end
			if ((v148 == (944 - (850 + 90))) or ((4698 - 2015) < (1413 - (360 + 1030)))) then
				if (((617 + 80) <= (2330 - 1504)) and v34) then
					v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 55 - 15, 1686 - (909 + 752));
					if (((2328 - (109 + 1114)) <= (2152 - 976)) and v30) then
						return v30;
					end
					if (((1316 + 2063) <= (4054 - (6 + 236))) and v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (v25(v102.BlessingofFreedomFocus) or ((497 + 291) >= (1301 + 315))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v107 = v111();
				if (((4372 - 2518) <= (5901 - 2522)) and not v15:AffectingCombat()) then
					if (((5682 - (1076 + 57)) == (749 + 3800)) and v98.RetributionAura:IsCastable() and (v112())) then
						if (v25(v98.RetributionAura) or ((3711 - (579 + 110)) >= (239 + 2785))) then
							return "retribution_aura";
						end
					end
				end
				v148 = 5 + 0;
			end
			if (((2559 + 2261) > (2605 - (174 + 233))) and (v148 == (25 - 16))) then
				if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((1862 - 801) >= (2175 + 2716))) then
					if (((2538 - (663 + 511)) <= (3991 + 482)) and v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) then
						if (v25(v98.LayonHands) or ((781 + 2814) <= (9 - 6))) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((2830 + 1842) == (9068 - 5216))) then
						if (((3773 - 2214) == (744 + 815)) and v25(v98.DivineShield)) then
							return "divine_shield defensive";
						end
					end
					if ((v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) or ((3409 - 1657) <= (562 + 226))) then
						if (v25(v98.DivineProtection) or ((358 + 3549) == (899 - (478 + 244)))) then
							return "divine_protection defensive";
						end
					end
					if (((3987 - (440 + 77)) > (253 + 302)) and v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
						if (v25(v102.Healthstone) or ((3557 - 2585) == (2201 - (655 + 901)))) then
							return "healthstone defensive";
						end
					end
					if (((591 + 2591) >= (1620 + 495)) and v89 and (v15:HealthPercentage() <= v91)) then
						if (((2629 + 1264) < (17842 - 13413)) and (v93 == "Refreshing Healing Potion")) then
							if (v99.RefreshingHealingPotion:IsReady() or ((4312 - (695 + 750)) < (6504 - 4599))) then
								if (v25(v102.RefreshingHealingPotion) or ((2771 - 975) >= (16292 - 12241))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((1970 - (285 + 66)) <= (8755 - 4999)) and (v93 == "Dreamwalker's Healing Potion")) then
							if (((1914 - (682 + 628)) == (98 + 506)) and v99.DreamwalkersHealingPotion:IsReady()) then
								if (v25(v102.RefreshingHealingPotion) or ((4783 - (176 + 123)) == (377 + 523))) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
					end
					if ((v84 < v106) or ((3235 + 1224) <= (1382 - (239 + 30)))) then
						v30 = v118();
						if (((988 + 2644) > (3266 + 132)) and v30) then
							return v30;
						end
					end
					v30 = v120();
					if (((7224 - 3142) <= (15340 - 10423)) and v30) then
						return v30;
					end
					if (((5147 - (306 + 9)) >= (4836 - 3450)) and v25(v98.Pool)) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((24 + 113) == (85 + 52)) and ((4 + 4) == v148)) then
				v30 = v115();
				if (v30 or ((4489 - 2919) >= (5707 - (1140 + 235)))) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v97.TargetIsValid()) or ((2587 + 1477) <= (1669 + 150))) then
					local v194 = 0 + 0;
					while true do
						if ((v194 == (52 - (33 + 19))) or ((1801 + 3185) < (4717 - 3143))) then
							v30 = v117();
							if (((1950 + 2476) > (336 - 164)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v148 = 9 + 0;
			end
		end
	end
	local function v125()
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v101();
	end
	v21.SetAPL(759 - (586 + 103), v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

