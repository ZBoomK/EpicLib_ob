local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 432 - (317 + 115);
	local v6;
	while true do
		if (((2026 - 1018) < (3025 + 686)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((1875 - (802 + 24)) <= (1562 - 656))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((667 + 3846) > (2095 + 631)) and (v5 == (1 + 0))) then
			return v6(...);
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
		if (v98.CleanseToxins:IsAvailable() or ((320 + 1161) >= (7394 - 4736))) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 37052 - 25941;
	local v106 = 3975 + 7136;
	local v107;
	local v108 = 0 + 0;
	local v109 = 0 + 0;
	local v110;
	v10:RegisterForEvent(function()
		local v126 = 0 + 0;
		while true do
			if ((v126 == (0 + 0)) or ((4653 - (797 + 636)) == (6622 - 5258))) then
				v105 = 12730 - (1427 + 192);
				v106 = 3850 + 7261;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v127 = 0 - 0;
		local v128;
		local v129;
		while true do
			if ((v127 == (1 + 0)) or ((478 + 576) > (3718 - (192 + 134)))) then
				if ((v128 > v129) or ((1952 - (316 + 960)) >= (914 + 728))) then
					return v128;
				end
				return v129;
			end
			if (((3192 + 944) > (2216 + 181)) and (v127 == (0 - 0))) then
				v128 = v15:GCDRemains();
				v129 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (561 - (83 + 468)), v98.WakeofAshes:CooldownRemains());
				v127 = 1807 - (1202 + 604);
			end
		end
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v113()
		if ((v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(116 - 91)) or ((7213 - 2879) == (11753 - 7508))) then
			if (v25(v102.CleanseToxinsFocus) or ((4601 - (45 + 280)) <= (2926 + 105))) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v114()
		if ((v94 and (v15:HealthPercentage() <= v95)) or ((4178 + 604) <= (438 + 761))) then
			if (v98.FlashofLight:IsReady() or ((2692 + 2172) < (335 + 1567))) then
				if (((8960 - 4121) >= (5611 - (340 + 1571))) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (1772 - (1733 + 39))) or ((2953 - 1878) > (2952 - (125 + 909)))) then
				if (((2344 - (1096 + 852)) <= (1707 + 2097)) and v16:Exists()) then
					if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((5953 - 1784) == (2122 + 65))) then
						if (((1918 - (409 + 103)) == (1642 - (46 + 190))) and v25(v102.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((1626 - (51 + 44)) < (1205 + 3066)) and (not v14 or not v14:Exists() or not v14:IsInRange(1347 - (1114 + 203)))) then
					return;
				end
				v130 = 727 - (228 + 498);
			end
			if (((138 + 497) == (351 + 284)) and (v130 == (664 - (174 + 489)))) then
				if (((8787 - 5414) <= (5461 - (830 + 1075))) and v14) then
					if ((v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) or ((3815 - (303 + 221)) < (4549 - (231 + 1038)))) then
						if (((3655 + 731) >= (2035 - (171 + 991))) and v25(v102.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((3795 - 2874) <= (2958 - 1856)) and v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) then
						if (((11743 - 7037) >= (771 + 192)) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((3365 - 2405) <= (2526 - 1650))) then
						if (v25(v102.BlessingofSacrificeFocus) or ((3329 - 1263) == (2880 - 1948))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((6073 - (111 + 1137)) < (5001 - (91 + 67))) and v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
						if (v25(v102.BlessingofProtectionFocus) or ((11538 - 7661) >= (1133 + 3404))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v116()
		v30 = v97.HandleTopTrinket(v100, v33, 563 - (423 + 100), nil);
		if (v30 or ((31 + 4284) < (4778 - 3052))) then
			return v30;
		end
		v30 = v97.HandleBottomTrinket(v100, v33, 21 + 19, nil);
		if (v30 or ((4450 - (326 + 445)) < (2727 - 2102))) then
			return v30;
		end
	end
	local function v117()
		local v131 = 0 - 0;
		while true do
			if ((v131 == (4 - 2)) or ((5336 - (530 + 181)) < (1513 - (614 + 267)))) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (36 - (19 + 13)))) or ((134 - 51) > (4148 - 2368))) then
					if (((1559 - 1013) <= (280 + 797)) and v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35) or ((1751 - 755) > (8919 - 4618))) then
					if (((5882 - (1293 + 519)) > (1401 - 714)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v131 = 7 - 4;
			end
			if ((v131 == (5 - 2)) or ((2828 - 2172) >= (7844 - 4514))) then
				if ((v98.Judgment:IsCastable() and v43) or ((1320 + 1172) <= (69 + 266))) then
					if (((10041 - 5719) >= (593 + 1969)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42) or ((1209 + 2428) >= (2356 + 1414))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((3475 - (709 + 387)) > (6436 - (673 + 1185)))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v131 = 11 - 7;
			end
			if ((v131 == (3 - 2)) or ((794 - 311) > (532 + 211))) then
				if (((1834 + 620) > (780 - 202)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (1 + 3))) then
					if (((1854 - 924) < (8750 - 4292)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((2542 - (446 + 1434)) <= (2255 - (1040 + 243))) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (11 - 7))) then
					if (((6217 - (559 + 1288)) == (6301 - (609 + 1322))) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v131 = 456 - (13 + 441);
			end
			if ((v131 == (14 - 10)) or ((12473 - 7711) <= (4288 - 3427))) then
				if ((v98.CrusaderStrike:IsCastable() and v37) or ((53 + 1359) == (15485 - 11221))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((1126 + 2042) < (944 + 1209))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v131 == (0 - 0)) or ((2723 + 2253) < (2449 - 1117))) then
				if (((3060 + 1568) == (2575 + 2053)) and v98.ArcaneTorrent:IsCastable() and v87 and ((v88 and v33) or not v88) and v98.FinalReckoning:IsAvailable()) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(6 + 2)) or ((46 + 8) == (387 + 8))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((515 - (153 + 280)) == (236 - 154)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) then
					if (v25(v98.ShieldofVengeance, not v17:IsInRange(8 + 0)) or ((230 + 351) < (148 + 134))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v118()
		local v132 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (8 + 2))) or (v106 < (38 - 13)));
		if (v132 or ((2849 + 1760) < (3162 - (89 + 578)))) then
			return v132;
		end
		if (((823 + 329) == (2394 - 1242)) and v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) then
			if (((2945 - (572 + 477)) <= (462 + 2960)) and v25(v98.LightsJudgment, not v17:IsInRange(25 + 15))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (2 + 8))))) or ((1076 - (84 + 2)) > (2669 - 1049))) then
			if (v25(v98.Fireblood, not v17:IsInRange(8 + 2)) or ((1719 - (497 + 345)) > (121 + 4574))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((455 + 2236) >= (3184 - (605 + 728))) and v85 and ((v33 and v86) or not v86) and v17:IsInRange(6 + 2)) then
			local v155 = 0 - 0;
			while true do
				if ((v155 == (0 + 0)) or ((11036 - 8051) >= (4378 + 478))) then
					v30 = v116();
					if (((11846 - 7570) >= (903 + 292)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((3721 - (457 + 32)) <= (1990 + 2700)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (1417 - (832 + 570))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) then
			if (v25(v98.ShieldofVengeance) or ((845 + 51) >= (821 + 2325))) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((10832 - 7771) >= (1425 + 1533)) and v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (811 - (588 + 208)))) or (v15:BuffStack(v98.CrusadeBuff) == (26 - 16)) or (v98.AvengingWrath:CooldownRemains() < (1800.75 - (884 + 916))) or (v98.AvengingWrath:CooldownRemains() > (31 - 16))) and (((v108 >= (3 + 1)) and (v10.CombatTime() < (658 - (232 + 421)))) or ((v108 >= (1892 - (1569 + 320))) and (v10.CombatTime() > (2 + 3))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (26 - 18)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (617 - (316 + 289))))) then
			if (((8342 - 5155) >= (30 + 614)) and v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((2097 - (666 + 787)) <= (1129 - (360 + 65))) and v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (4 + 0)) and (v10.CombatTime() < (259 - (79 + 175)))) or ((v108 >= (4 - 1)) and (v10.CombatTime() > (4 + 1))) or ((v108 >= (5 - 3)) and v98.DivineAuxiliary:IsAvailable() and ((v98.ExecutionSentence:IsAvailable() and ((v98.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v98.ExecutionSentence:CooldownRemains() > (914 - (503 + 396))) or not v98.ExecutionSentence:IsReady())) or (v98.FinalReckoning:IsAvailable() and ((v98.FinalReckoning:CooldownRemains() == (181 - (92 + 89))) or (v98.FinalReckoning:CooldownRemains() > (58 - 28)) or not v98.FinalReckoning:IsReady())))))) then
			if (((492 + 466) > (561 + 386)) and v25(v98.AvengingWrath, not v17:IsInRange(39 - 29))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if (((615 + 3877) >= (6050 - 3396)) and v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (v15:BuffRemains(v98.CrusadeBuff) < v15:GCD()) and (((v108 >= (5 + 0)) and (v10.CombatTime() < (3 + 2))) or ((v108 >= (8 - 5)) and (v10.CombatTime() > (1 + 4))))) then
			if (((5248 - 1806) >= (2747 - (485 + 759))) and v25(v98.Crusade, not v17:IsInRange(23 - 13))) then
				return "crusade cooldowns 14";
			end
		end
		if ((v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (1193 - (442 + 747))) and (v10.CombatTime() < (1143 - (832 + 303)))) or ((v108 >= (949 - (88 + 858))) and (v10.CombatTime() >= (3 + 5))) or ((v108 >= (2 + 0)) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (1 + 9)) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (799 - (766 + 23)))))) and ((v107 > (0 - 0)) or (v108 == (6 - 1)) or ((v108 >= (4 - 2)) and v98.DivineAuxiliary:IsAvailable()))) or ((10759 - 7589) <= (2537 - (1036 + 37)))) then
			if ((v96 == "player") or ((3401 + 1396) == (8544 - 4156))) then
				if (((434 + 117) <= (2161 - (641 + 839))) and v25(v102.FinalReckoningPlayer, not v17:IsInRange(923 - (910 + 3)))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if (((8353 - 5076) > (2091 - (1466 + 218))) and (v96 == "cursor")) then
				if (((2158 + 2537) >= (2563 - (556 + 592))) and v25(v102.FinalReckoningCursor, not v17:IsInRange(8 + 12))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v119()
		v110 = ((v104 >= (811 - (329 + 479))) or ((v104 >= (856 - (174 + 680))) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (82 - 58)));
		if ((v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (5 - 2))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (8 + 2))))) or ((3951 - (396 + 343)) <= (84 + 860))) then
			if (v25(v98.DivineStorm, not v17:IsInRange(1487 - (29 + 1448))) or ((4485 - (135 + 1254)) <= (6773 - 4975))) then
				return "divine_storm finishers 2";
			end
		end
		if (((16514 - 12977) == (2358 + 1179)) and v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1530 - (389 + 1138)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (584 - (102 + 472)))))) then
			if (((3621 + 216) >= (871 + 699)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1555 - (320 + 1225)))))) or ((5251 - 2301) == (2333 + 1479))) then
			if (((6187 - (157 + 1307)) >= (4177 - (821 + 1038))) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if ((v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (7 - 4))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (2 + 8))))) or ((3600 - 1573) > (1062 + 1790))) then
			if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((2815 - 1679) > (5343 - (834 + 192)))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v120()
		local v133 = 0 + 0;
		while true do
			if (((1219 + 3529) == (102 + 4646)) and (v133 == (7 - 2))) then
				if (((4040 - (300 + 4)) <= (1266 + 3474)) and v98.TemplarStrike:IsReady() and v46) then
					if (v25(v98.TemplarStrike, not v17:IsInRange(26 - 16)) or ((3752 - (112 + 250)) <= (1220 + 1840))) then
						return "templar_strike generators 30";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and ((v108 <= (7 - 4)) or not v98.BoundlessJudgment:IsAvailable())) or ((573 + 426) > (1393 + 1300))) then
					if (((347 + 116) < (298 + 303)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 32";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42 and ((v108 <= (3 + 0)) or (v17:HealthPercentage() > (1434 - (1001 + 413))) or not v98.VanguardsMomentum:IsAvailable())) or ((4867 - 2684) < (1569 - (244 + 638)))) then
					if (((5242 - (627 + 66)) == (13554 - 9005)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((5274 - (512 + 90)) == (6578 - (1665 + 241))) and v98.CrusaderStrike:IsCastable() and v37) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((4385 - (373 + 344)) < (179 + 216))) then
						return "crusader_strike generators 26";
					end
				end
				v133 = 2 + 4;
			end
			if ((v133 == (2 - 1)) or ((7049 - 2883) == (1554 - (35 + 1064)))) then
				if ((v98.DivineToll:IsCastable() and v40 and (v108 <= (2 + 0)) and ((v98.AvengingWrath:CooldownRemains() > (32 - 17)) or (v98.Crusade:CooldownRemains() > (1 + 14)) or (v106 < (1244 - (298 + 938))))) or ((5708 - (233 + 1026)) == (4329 - (636 + 1030)))) then
					if (v25(v98.DivineToll, not v17:IsInRange(16 + 14)) or ((4178 + 99) < (888 + 2101))) then
						return "divine_toll generators 6";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(3 + 28, 223 - (55 + 166))) or ((169 + 701) >= (418 + 3731))) then
					if (((8447 - 6235) < (3480 - (36 + 261))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 7";
					end
				end
				if (((8124 - 3478) > (4360 - (34 + 1334))) and (v108 >= (2 + 1)) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (8 + 2))) then
					v30 = v119();
					if (((2717 - (1035 + 248)) < (3127 - (20 + 1))) and v30) then
						return v30;
					end
				end
				if (((410 + 376) < (3342 - (134 + 185))) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (1137 - (549 + 584))) and (v104 >= (687 - (314 + 371)))) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(34 - 24)) or ((3410 - (478 + 490)) < (40 + 34))) then
						return "templar_slash generators 8";
					end
				end
				v133 = 1174 - (786 + 386);
			end
			if (((14688 - 10153) == (5914 - (1055 + 324))) and (v133 == (1342 - (1093 + 247)))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (3 + 0)) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (1 + 1)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (15 - 11)))) or ((10211 - 7202) <= (5989 - 3884))) then
					if (((4598 - 2768) < (1306 + 2363)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42 and ((v104 < (7 - 5)) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(103 - 73, 4 + 0)) and ((v108 <= (7 - 4)) or (v17:HealthPercentage() > (708 - (364 + 324))) or not v98.VanguardsMomentum:IsAvailable())) or ((3920 - 2490) >= (8667 - 5055))) then
					if (((890 + 1793) >= (10293 - 7833)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if ((v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (5 - 1))) or ((5478 - 3674) >= (4543 - (1249 + 19)))) then
					if (v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash)) or ((1280 + 137) > (14125 - 10496))) then
						return "templar_slash generators 14";
					end
				end
				if (((5881 - (686 + 400)) > (316 + 86)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (232 - (73 + 156))) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((23 + 4790) > (4376 - (721 + 90))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				v133 = 1 + 2;
			end
			if (((12701 - 8789) == (4382 - (224 + 246))) and ((0 - 0) == v133)) then
				if (((5193 - 2372) <= (876 + 3948)) and ((v108 >= (1 + 4)) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(23 + 8, 7 - 3) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (12 - 8))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(544 - (203 + 310), 1995 - (1238 + 755))))) then
					local v199 = 0 + 0;
					while true do
						if (((3272 - (709 + 825)) <= (4044 - 1849)) and (v199 == (0 - 0))) then
							v30 = v119();
							if (((905 - (196 + 668)) <= (11915 - 8897)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((4443 - 2298) <= (4937 - (171 + 662))) and v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (96 - (4 + 89))) and v15:HasTier(108 - 77, 1 + 1)) then
					if (((11810 - 9121) < (1900 + 2945)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1488 - (35 + 1451))) and ((v98.AvengingWrath:CooldownRemains() > (1453 - (28 + 1425))) or (v98.Crusade:CooldownRemains() > (1993 - (941 + 1052))) or not v98.Crusade:IsAvailable() or not v98.AvengingWrath:IsReady()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (4 + 0)) or (v106 < (1522 - (822 + 692))) or not v98.ExecutionSentence:IsReady())) or ((3314 - 992) > (1236 + 1386))) then
					if (v25(v98.WakeofAshes, not v17:IsInRange(307 - (45 + 252))) or ((4487 + 47) == (717 + 1365))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (7 - 4)) and v15:HasTier(464 - (114 + 319), 2 - 0)) or ((2012 - 441) > (1191 + 676))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((3953 - 1299) >= (6277 - 3281))) then
						return "blade_of_justice generators 4";
					end
				end
				v133 = 1964 - (556 + 1407);
			end
			if (((5184 - (741 + 465)) > (2569 - (170 + 295))) and (v133 == (3 + 1))) then
				if (((2751 + 244) > (3793 - 2252)) and v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v108 <= (2 + 0)) or ((v108 <= (2 + 1)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1232 - (957 + 273))))) or ((v108 == (2 + 2)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1 + 1))) and (v98.Judgment:CooldownRemains() > (v109 * (7 - 5)))))) then
					if (((8561 - 5312) > (2910 - 1957)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v119();
				if (v30 or ((16206 - 12933) > (6353 - (389 + 1391)))) then
					return v30;
				end
				if ((v98.TemplarSlash:IsReady() and v45) or ((1977 + 1174) < (134 + 1150))) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(22 - 12)) or ((2801 - (783 + 168)) == (5131 - 3602))) then
						return "templar_slash generators 28";
					end
				end
				v133 = 5 + 0;
			end
			if (((1132 - (309 + 2)) < (6519 - 4396)) and (v133 == (1215 - (1090 + 122)))) then
				if (((293 + 609) < (7808 - 5483)) and v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (3 + 0)) or not v98.HolyBlade:IsAvailable())) then
					if (((1976 - (628 + 490)) <= (532 + 2430)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if ((v17:HealthPercentage() <= (49 - 29)) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff) or ((18033 - 14087) < (2062 - (431 + 343)))) then
					local v200 = 0 - 0;
					while true do
						if ((v200 == (0 - 0)) or ((2562 + 680) == (73 + 494))) then
							v30 = v119();
							if (v30 or ((2542 - (556 + 1139)) >= (1278 - (6 + 9)))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (1 + 1))) or ((1155 + 1098) == (2020 - (28 + 141)))) then
					if (v25(v98.Consecration, not v17:IsInRange(4 + 6)) or ((2575 - 488) > (1680 + 692))) then
						return "consecration generators 22";
					end
				end
				if ((v98.DivineHammer:IsCastable() and v38 and (v104 >= (1319 - (486 + 831)))) or ((11566 - 7121) < (14606 - 10457))) then
					if (v25(v98.DivineHammer, not v17:IsInRange(2 + 8)) or ((5748 - 3930) == (1348 - (668 + 595)))) then
						return "divine_hammer generators 24";
					end
				end
				v133 = 4 + 0;
			end
			if (((128 + 502) < (5800 - 3673)) and (v133 == (296 - (23 + 267)))) then
				if ((v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (1949 - (1129 + 815))) and (v84 < v106)) or ((2325 - (371 + 16)) == (4264 - (1326 + 424)))) then
					if (((8058 - 3803) >= (200 - 145)) and v25(v98.ArcaneTorrent, not v17:IsInRange(128 - (88 + 30)))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((3770 - (720 + 51)) > (2571 - 1415)) and v98.Consecration:IsCastable() and v36) then
					if (((4126 - (421 + 1355)) > (1905 - 750)) and v25(v98.Consecration, not v17:IsInRange(5 + 5))) then
						return "consecration generators 30";
					end
				end
				if (((5112 - (286 + 797)) <= (17740 - 12887)) and v98.DivineHammer:IsCastable() and v38) then
					if (v25(v98.DivineHammer, not v17:IsInRange(16 - 6)) or ((955 - (397 + 42)) > (1073 + 2361))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v134 = 800 - (24 + 776);
		while true do
			if (((6232 - 2186) >= (3818 - (222 + 563))) and (v134 == (0 - 0))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useDivineHammer'];
				v134 = 1 + 0;
			end
			if ((v134 == (192 - (23 + 167))) or ((4517 - (690 + 1108)) <= (523 + 924))) then
				v43 = EpicSettings.Settings['useJudgment'];
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v134 = 3 + 0;
			end
			if (((851 - (40 + 808)) == v134) or ((681 + 3453) < (15012 - 11086))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v50 = EpicSettings.Settings['useCrusade'];
				v134 = 4 + 0;
			end
			if (((3 + 2) == v134) or ((90 + 74) >= (3356 - (47 + 524)))) then
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v134 == (1 + 0)) or ((1435 - 910) == (3153 - 1044))) then
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v134 = 4 - 2;
			end
			if (((1759 - (1165 + 561)) == (1 + 32)) and (v134 == (12 - 8))) then
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v134 = 2 + 3;
			end
		end
	end
	local function v122()
		v57 = EpicSettings.Settings['useRebuke'];
		v58 = EpicSettings.Settings['useHammerofJustice'];
		v59 = EpicSettings.Settings['useDivineProtection'];
		v60 = EpicSettings.Settings['useDivineShield'];
		v61 = EpicSettings.Settings['useLayonHands'];
		v62 = EpicSettings.Settings['useLayonHandsFocus'];
		v63 = EpicSettings.Settings['useWordofGloryFocus'];
		v64 = EpicSettings.Settings['useWordofGloryMouseover'];
		v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v67 = EpicSettings.Settings['divineProtectionHP'] or (479 - (341 + 138));
		v68 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
		v69 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
		v70 = EpicSettings.Settings['layonHandsFocusHP'] or (326 - (89 + 237));
		v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 - 0);
		v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
		v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (881 - (581 + 300));
		v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (1220 - (855 + 365));
		v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v123()
		local v147 = 0 - 0;
		while true do
			if (((998 + 2056) <= (5250 - (1030 + 205))) and (v147 == (5 + 0))) then
				v79 = EpicSettings.Settings['handleAfflicted'];
				v80 = EpicSettings.Settings['HandleIncorporeal'];
				v94 = EpicSettings.Settings['HealOOC'];
				v147 = 6 + 0;
			end
			if (((2157 - (156 + 130)) < (7684 - 4302)) and (v147 == (1 - 0))) then
				v83 = EpicSettings.Settings['InterruptThreshold'];
				v78 = EpicSettings.Settings['DispelDebuffs'];
				v77 = EpicSettings.Settings['DispelBuffs'];
				v147 = 3 - 1;
			end
			if (((341 + 952) <= (1264 + 902)) and (v147 == (73 - (10 + 59)))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v147 = 1168 - (671 + 492);
			end
			if ((v147 == (3 + 0)) or ((3794 - (369 + 846)) < (33 + 90))) then
				v88 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v147 = 4 + 0;
			end
			if ((v147 == (1947 - (1036 + 909))) or ((673 + 173) >= (3975 - 1607))) then
				v85 = EpicSettings.Settings['useTrinkets'];
				v87 = EpicSettings.Settings['useRacials'];
				v86 = EpicSettings.Settings['trinketsWithCD'];
				v147 = 206 - (11 + 192);
			end
			if (((4 + 2) == v147) or ((4187 - (135 + 40)) <= (8135 - 4777))) then
				v95 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
			if (((3291 - 1797) <= (4504 - 1499)) and (v147 == (176 - (50 + 126)))) then
				v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v81 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v147 = 1 + 0;
			end
		end
	end
	local function v124()
		v122();
		v121();
		v123();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((4524 - (1233 + 180)) == (3103 - (522 + 447)))) then
			return v30;
		end
		v103 = v15:GetEnemiesInMeleeRange(1429 - (107 + 1314));
		if (((1093 + 1262) == (7175 - 4820)) and v32) then
			v104 = #v103;
		else
			v103 = {};
			v104 = 1 + 0;
		end
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1167 - 579) <= (1709 - 1277))) then
			if (((6707 - (716 + 1194)) >= (67 + 3828)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
				if (((384 + 3193) == (4080 - (74 + 429))) and v25(v98.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (((7318 - 3524) > (1831 + 1862)) and (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()))) then
			local v156 = v78 and v98.CleanseToxins:IsReady() and v34;
			v30 = v97.FocusUnit(v156, v102, 45 - 25, nil, 18 + 7);
			if (v30 or ((3930 - 2655) == (10137 - 6037))) then
				return v30;
			end
		end
		if (v34 or ((2024 - (279 + 154)) >= (4358 - (454 + 324)))) then
			local v157 = 0 + 0;
			while true do
				if (((1000 - (12 + 5)) <= (975 + 833)) and (v157 == (0 - 0))) then
					v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 15 + 25, 1118 - (277 + 816));
					if (v30 or ((9187 - 7037) <= (2380 - (1058 + 125)))) then
						return v30;
					end
					v157 = 1 + 0;
				end
				if (((4744 - (815 + 160)) >= (5032 - 3859)) and (v157 == (2 - 1))) then
					if (((355 + 1130) == (4340 - 2855)) and v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (v25(v102.BlessingofFreedomFocus) or ((5213 - (41 + 1857)) <= (4675 - (1222 + 671)))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		v107 = v111();
		if (not v15:AffectingCombat() or ((2263 - 1387) >= (4260 - 1296))) then
			if ((v98.RetributionAura:IsCastable() and (v112())) or ((3414 - (229 + 953)) > (4271 - (1111 + 663)))) then
				if (v25(v98.RetributionAura) or ((3689 - (874 + 705)) <= (47 + 285))) then
					return "retribution_aura";
				end
			end
		end
		if (((2515 + 1171) > (6592 - 3420)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
			if (v15:AffectingCombat() or ((126 + 4348) < (1499 - (642 + 37)))) then
				if (((976 + 3303) >= (462 + 2420)) and v98.Intercession:IsCastable()) then
					if (v25(v98.Intercession, not v17:IsInRange(75 - 45), true) or ((2483 - (233 + 221)) >= (8141 - 4620))) then
						return "intercession target";
					end
				end
			elseif (v98.Redemption:IsCastable() or ((1793 + 244) >= (6183 - (718 + 823)))) then
				if (((1083 + 637) < (5263 - (266 + 539))) and v25(v98.Redemption, not v17:IsInRange(84 - 54), true)) then
					return "redemption target";
				end
			end
		end
		if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1661 - (636 + 589)) > (7171 - 4150))) then
			if (((1470 - 757) <= (672 + 175)) and v25(v102.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((783 + 1371) <= (5046 - (657 + 358))) and v15:AffectingCombat()) then
			if (((12219 - 7604) == (10514 - 5899)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (1190 - (1151 + 36))) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v102.IntercessionMouseover) or ((3660 + 130) == (132 + 368))) then
					return "Intercession mouseover";
				end
			end
		end
		if (((265 - 176) < (2053 - (1552 + 280))) and (v97.TargetIsValid() or v15:AffectingCombat())) then
			local v158 = 834 - (64 + 770);
			while true do
				if (((1395 + 659) >= (3225 - 1804)) and (v158 == (1 + 1))) then
					v108 = v15:HolyPower();
					break;
				end
				if (((1935 - (157 + 1086)) < (6120 - 3062)) and (v158 == (0 - 0))) then
					v105 = v10.BossFightRemains(nil, true);
					v106 = v105;
					v158 = 1 - 0;
				end
				if ((v158 == (1 - 0)) or ((4073 - (599 + 220)) == (3295 - 1640))) then
					if ((v106 == (13042 - (1813 + 118))) or ((948 + 348) == (6127 - (841 + 376)))) then
						v106 = v10.FightRemains(v103, false);
					end
					v109 = v15:GCD();
					v158 = 2 - 0;
				end
			end
		end
		if (((783 + 2585) == (9192 - 5824)) and v79) then
			local v159 = 859 - (464 + 395);
			while true do
				if (((6782 - 4139) < (1833 + 1982)) and (v159 == (837 - (467 + 370)))) then
					if (((3952 - 2039) > (362 + 131)) and v75) then
						local v201 = 0 - 0;
						while true do
							if (((742 + 4013) > (7975 - 4547)) and ((520 - (150 + 370)) == v201)) then
								v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 1322 - (74 + 1208));
								if (((3396 - 2015) <= (11235 - 8866)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v76 and (v108 > (2 + 0))) or ((5233 - (14 + 376)) == (7083 - 2999))) then
						v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 26 + 14, true);
						if (((4102 + 567) > (347 + 16)) and v30) then
							return v30;
						end
					end
					break;
				end
			end
		end
		if (v80 or ((5499 - 3622) >= (2361 + 777))) then
			local v160 = 78 - (23 + 55);
			while true do
				if (((11237 - 6495) >= (2420 + 1206)) and (v160 == (0 + 0))) then
					v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 46 - 16, true);
					if (v30 or ((1429 + 3111) == (1817 - (652 + 249)))) then
						return v30;
					end
					v160 = 2 - 1;
				end
				if ((v160 == (1869 - (708 + 1160))) or ((3137 - 1981) > (7921 - 3576))) then
					v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 57 - (10 + 17), true);
					if (((503 + 1734) < (5981 - (1400 + 332))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		v30 = v114();
		if (v30 or ((5146 - 2463) < (1931 - (242 + 1666)))) then
			return v30;
		end
		if (((299 + 398) <= (303 + 523)) and v78 and v34) then
			local v161 = 0 + 0;
			while true do
				if (((2045 - (850 + 90)) <= (2059 - 883)) and (v161 == (1390 - (360 + 1030)))) then
					if (((2991 + 388) <= (10759 - 6947)) and v14) then
						v30 = v113();
						if (v30 or ((1083 - 295) >= (3277 - (909 + 752)))) then
							return v30;
						end
					end
					if (((3077 - (109 + 1114)) <= (6185 - 2806)) and v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) then
						if (((1771 + 2778) == (4791 - (6 + 236))) and v98.CleanseToxins:IsReady()) then
							if (v25(v102.CleanseToxinsMouseover) or ((1904 + 1118) >= (2435 + 589))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v30 = v115();
		if (((11367 - 6547) > (3838 - 1640)) and v30) then
			return v30;
		end
		if ((not v15:AffectingCombat() and v31 and v97.TargetIsValid()) or ((2194 - (1076 + 57)) >= (805 + 4086))) then
			v30 = v117();
			if (((2053 - (579 + 110)) <= (354 + 4119)) and v30) then
				return v30;
			end
		end
		if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((3179 + 416) <= (2 + 1))) then
			if ((v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((5079 - (174 + 233)) == (10759 - 6907))) then
				if (((2735 - 1176) == (694 + 865)) and v25(v98.LayonHands)) then
					return "lay_on_hands_player defensive";
				end
			end
			if ((v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((2926 - (663 + 511)) <= (703 + 85))) then
				if (v25(v98.DivineShield) or ((849 + 3058) == (545 - 368))) then
					return "divine_shield defensive";
				end
			end
			if (((2102 + 1368) > (1306 - 751)) and v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) then
				if (v25(v98.DivineProtection) or ((2352 - 1380) == (308 + 337))) then
					return "divine_protection defensive";
				end
			end
			if (((6193 - 3011) >= (1508 + 607)) and v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
				if (((356 + 3537) < (5151 - (478 + 244))) and v25(v102.Healthstone)) then
					return "healthstone defensive";
				end
			end
			if ((v89 and (v15:HealthPercentage() <= v91)) or ((3384 - (440 + 77)) < (867 + 1038))) then
				local v198 = 0 - 0;
				while true do
					if ((v198 == (1556 - (655 + 901))) or ((334 + 1462) >= (3102 + 949))) then
						if (((1094 + 525) <= (15131 - 11375)) and (v93 == "Refreshing Healing Potion")) then
							if (((2049 - (695 + 750)) == (2062 - 1458)) and v99.RefreshingHealingPotion:IsReady()) then
								if (v25(v102.RefreshingHealingPotion) or ((6919 - 2435) == (3619 - 2719))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if ((v93 == "Dreamwalker's Healing Potion") or ((4810 - (285 + 66)) <= (2594 - 1481))) then
							if (((4942 - (682 + 628)) > (548 + 2850)) and v99.DreamwalkersHealingPotion:IsReady()) then
								if (((4381 - (176 + 123)) <= (2057 + 2860)) and v25(v102.RefreshingHealingPotion)) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
						break;
					end
				end
			end
			if (((3506 + 1326) >= (1655 - (239 + 30))) and (v84 < v106)) then
				v30 = v118();
				if (((38 + 99) == (132 + 5)) and v30) then
					return v30;
				end
			end
			v30 = v120();
			if (v30 or ((2778 - 1208) >= (13515 - 9183))) then
				return v30;
			end
			if (v25(v98.Pool) or ((4379 - (306 + 9)) <= (6347 - 4528))) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v125()
		local v152 = 0 + 0;
		while true do
			if ((v152 == (0 + 0)) or ((2400 + 2586) < (4500 - 2926))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v101();
				break;
			end
		end
	end
	v21.SetAPL(1445 - (1140 + 235), v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

