local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((46 + 4660) > (11341 - 6912)) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if (((4245 - (157 + 1234)) < (6919 - 2824)) and (v5 == (1555 - (991 + 564)))) then
			v6 = v0[v4];
			if (not v6 or ((692 + 366) >= (2761 - (1381 + 178)))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v30, v30, v31 = UnitClass("focus");
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v97;
	local v98;
	local v99;
	local v100;
	local v101 = v21.Commons.Everyone;
	local v102 = v19.Paladin.Retribution;
	local v103 = v20.Paladin.Retribution;
	local v104 = {};
	local function v105()
		if (((2993 + 718) > (1432 + 1923)) and v102.CleanseToxins:IsAvailable()) then
			v101.DispellableDebuffs = v13.MergeTable(v101.DispellableDiseaseDebuffs, v101.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v105();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v106 = v24.Paladin.Retribution;
	local v107;
	local v108;
	local v109 = 38304 - 27193;
	local v110 = 5757 + 5354;
	local v111;
	local v112 = 470 - (381 + 89);
	local v113 = 0 + 0;
	local v114;
	v10:RegisterForEvent(function()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (0 - 0)) or ((2062 - (1074 + 82)) >= (4884 - 2655))) then
				v109 = 12895 - (214 + 1570);
				v110 = 12566 - (990 + 465);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115()
		local v132 = v15:GCDRemains();
		local v133 = v28(v102.CrusaderStrike:CooldownRemains(), v102.BladeofJustice:CooldownRemains(), v102.Judgment:CooldownRemains(), (v102.HammerofWrath:IsUsable() and v102.HammerofWrath:CooldownRemains()) or (5 + 5), v102.WakeofAshes:CooldownRemains());
		if (((561 + 727) > (1217 + 34)) and (v132 > v133)) then
			return v132;
		end
		return v133;
	end
	local function v116()
		return v15:BuffDown(v102.RetributionAura) and v15:BuffDown(v102.DevotionAura) and v15:BuffDown(v102.ConcentrationAura) and v15:BuffDown(v102.CrusaderAura);
	end
	local v117 = 0 - 0;
	local function v118()
		if ((v102.CleanseToxins:IsReady() and (v101.UnitHasDispellableDebuffByPlayer(v14) or v101.DispellableFriendlyUnit(1746 - (1668 + 58)) or v101.UnitHasCurseDebuff(v14) or v101.UnitHasPoisonDebuff(v14))) or ((5139 - (512 + 114)) < (8738 - 5386))) then
			if ((v117 == (0 - 0)) or ((7185 - 5120) >= (1487 + 1709))) then
				v117 = GetTime();
			end
			if (v101.Wait(94 + 406, v117) or ((3805 + 571) <= (4995 - 3514))) then
				local v200 = 1994 - (109 + 1885);
				while true do
					if ((v200 == (1469 - (1269 + 200))) or ((6501 - 3109) >= (5556 - (98 + 717)))) then
						if (((4151 - (802 + 24)) >= (3714 - 1560)) and v25(v106.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v117 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((192 + 1103) >= (2484 + 749))) then
			if (((719 + 3658) > (355 + 1287)) and v102.FlashofLight:IsReady()) then
				if (((13139 - 8416) > (4521 - 3165)) and v25(v102.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		if (v16:Exists() or ((1480 + 2656) <= (1398 + 2035))) then
			if (((3502 + 743) <= (3368 + 1263)) and v102.WordofGlory:IsReady() and v68 and (v16:HealthPercentage() <= v76)) then
				if (((1997 + 2279) >= (5347 - (797 + 636))) and v25(v106.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (((961 - 763) <= (5984 - (1427 + 192))) and (not v14 or not v14:Exists() or not v14:IsInRange(11 + 19))) then
			return;
		end
		if (((11102 - 6320) > (4204 + 472)) and v14) then
			local v168 = 0 + 0;
			while true do
				if (((5190 - (192 + 134)) > (3473 - (316 + 960))) and (v168 == (1 + 0))) then
					if ((v102.BlessingofSacrifice:IsCastable() and v70 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) or ((2856 + 844) == (2318 + 189))) then
						if (((17104 - 12630) >= (825 - (83 + 468))) and v25(v106.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v102.BlessingofProtection:IsCastable() and v69 and v14:DebuffDown(v102.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) or ((3700 - (1202 + 604)) <= (6563 - 5157))) then
						if (((2615 - 1043) >= (4238 - 2707)) and v25(v106.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if ((v168 == (325 - (45 + 280))) or ((4524 + 163) < (3969 + 573))) then
					if (((1202 + 2089) > (923 + 744)) and v102.WordofGlory:IsReady() and v67 and (v14:HealthPercentage() <= v75)) then
						if (v25(v106.WordofGloryFocus) or ((154 + 719) == (3765 - 1731))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v102.LayonHands:IsCastable() and v66 and v14:DebuffDown(v102.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) or ((4727 - (340 + 1571)) < (5 + 6))) then
						if (((5471 - (1733 + 39)) < (12931 - 8225)) and v25(v106.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					v168 = 1035 - (125 + 909);
				end
			end
		end
	end
	local function v121()
		local v134 = 1948 - (1096 + 852);
		while true do
			if (((1187 + 1459) >= (1250 - 374)) and (v134 == (1 + 0))) then
				v32 = v101.HandleBottomTrinket(v104, v35, 552 - (409 + 103), nil);
				if (((850 - (46 + 190)) <= (3279 - (51 + 44))) and v32) then
					return v32;
				end
				break;
			end
			if (((882 + 2244) == (4443 - (1114 + 203))) and (v134 == (726 - (228 + 498)))) then
				v32 = v101.HandleTopTrinket(v104, v35, 9 + 31, nil);
				if (v32 or ((1209 + 978) >= (5617 - (174 + 489)))) then
					return v32;
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v122()
		local v135 = 1905 - (830 + 1075);
		while true do
			if (((526 - (303 + 221)) == v135) or ((5146 - (231 + 1038)) == (2980 + 595))) then
				if (((1869 - (171 + 991)) > (2604 - 1972)) and v102.TemplarsVerdict:IsReady() and v52 and (v112 >= (10 - 6))) then
					if (v25(v102.TemplarsVerdict, not v17:IsSpellInRange(v102.TemplarsVerdict)) or ((1362 - 816) >= (2149 + 535))) then
						return "templars verdict precombat 4";
					end
				end
				if (((5135 - 3670) <= (12407 - 8106)) and v102.BladeofJustice:IsCastable() and v39) then
					if (((2746 - 1042) > (4405 - 2980)) and v25(v102.BladeofJustice, not v17:IsSpellInRange(v102.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v135 = 1251 - (111 + 1137);
			end
			if (((158 - (91 + 67)) == v135) or ((2044 - 1357) == (1057 + 3177))) then
				if ((v102.ArcaneTorrent:IsCastable() and v91 and ((v92 and v35) or not v92) and v102.FinalReckoning:IsAvailable()) or ((3853 - (423 + 100)) < (11 + 1418))) then
					if (((3175 - 2028) >= (175 + 160)) and v25(v102.ArcaneTorrent, not v17:IsInRange(779 - (326 + 445)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((14990 - 11555) > (4671 - 2574)) and v102.ShieldofVengeance:IsCastable() and v56 and ((v35 and v60) or not v60)) then
					if (v25(v102.ShieldofVengeance, not v17:IsInRange(18 - 10)) or ((4481 - (530 + 181)) >= (4922 - (614 + 267)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v135 = 33 - (19 + 13);
			end
			if ((v135 == (6 - 2)) or ((8834 - 5043) <= (4601 - 2990))) then
				if ((v102.CrusaderStrike:IsCastable() and v41) or ((1189 + 3389) <= (3531 - 1523))) then
					if (((2333 - 1208) <= (3888 - (1293 + 519))) and v25(v102.CrusaderStrike, not v17:IsSpellInRange(v102.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v135 == (1 - 0)) or ((1939 - 1196) >= (8411 - 4012))) then
				if (((4980 - 3825) < (3940 - 2267)) and v102.JusticarsVengeance:IsAvailable() and v102.JusticarsVengeance:IsReady() and v48 and (v112 >= (3 + 1))) then
					if (v25(v102.JusticarsVengeance, not v17:IsSpellInRange(v102.JusticarsVengeance)) or ((475 + 1849) <= (1342 - 764))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((871 + 2896) == (1252 + 2515)) and v102.FinalVerdict:IsAvailable() and v102.FinalVerdict:IsReady() and v52 and (v112 >= (3 + 1))) then
					if (((5185 - (709 + 387)) == (5947 - (673 + 1185))) and v25(v102.FinalVerdict, not v17:IsSpellInRange(v102.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v135 = 5 - 3;
			end
			if (((14315 - 9857) >= (2753 - 1079)) and (v135 == (3 + 0))) then
				if (((727 + 245) <= (1914 - 496)) and v102.Judgment:IsCastable() and v47) then
					if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((1213 + 3725) < (9494 - 4732))) then
						return "judgment precombat 6";
					end
				end
				if ((v102.HammerofWrath:IsReady() and v46) or ((4915 - 2411) > (6144 - (446 + 1434)))) then
					if (((3436 - (1040 + 243)) == (6425 - 4272)) and v25(v102.HammerofWrath, not v17:IsSpellInRange(v102.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v135 = 1851 - (559 + 1288);
			end
		end
	end
	local function v123()
		local v136 = 1931 - (609 + 1322);
		local v137;
		while true do
			if ((v136 == (456 - (13 + 441))) or ((1894 - 1387) >= (6786 - 4195))) then
				if (((22317 - 17836) == (167 + 4314)) and v89 and ((v35 and v90) or not v90) and v17:IsInRange(29 - 21)) then
					v32 = v121();
					if (v32 or ((827 + 1501) < (304 + 389))) then
						return v32;
					end
				end
				if (((12843 - 8515) == (2369 + 1959)) and v102.ShieldofVengeance:IsCastable() and v56 and ((v35 and v60) or not v60) and (v110 > (27 - 12)) and (not v102.ExecutionSentence:IsAvailable() or v17:DebuffDown(v102.ExecutionSentence))) then
					if (((1050 + 538) >= (741 + 591)) and v25(v102.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v136 = 3 + 0;
			end
			if ((v136 == (3 + 0)) or ((4084 + 90) > (4681 - (153 + 280)))) then
				if ((v102.ExecutionSentence:IsCastable() and v45 and ((v15:BuffDown(v102.CrusadeBuff) and (v102.Crusade:CooldownRemains() > (43 - 28))) or (v15:BuffStack(v102.CrusadeBuff) == (9 + 1)) or not v102.Crusade:IsAvailable() or (v102.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v102.AvengingWrath:CooldownRemains() > (8 + 7))) and (((v112 >= (4 + 0)) and (v10.CombatTime() < (4 + 1))) or ((v112 >= (4 - 1)) and (v10.CombatTime() > (4 + 1))) or ((v112 >= (669 - (89 + 578))) and v102.DivineAuxiliary:IsAvailable())) and (((v17:TimeToDie() > (6 + 2)) and not v102.ExecutionersWill:IsAvailable()) or (v17:TimeToDie() > (24 - 12)))) or ((5635 - (572 + 477)) <= (12 + 70))) then
					if (((2319 + 1544) == (462 + 3401)) and v25(v102.ExecutionSentence, not v17:IsSpellInRange(v102.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v102.AvengingWrath:IsCastable() and v53 and ((v35 and v57) or not v57) and (((v112 >= (90 - (84 + 2))) and (v10.CombatTime() < (8 - 3))) or ((v112 >= (3 + 0)) and ((v10.CombatTime() > (847 - (497 + 345))) or not v102.VanguardofJustice:IsAvailable())) or ((v112 >= (1 + 1)) and v102.DivineAuxiliary:IsAvailable() and (v102.ExecutionSentence:CooldownUp() or v102.FinalReckoning:CooldownUp()))) and ((v108 == (1 + 0)) or (v17:TimeToDie() > (1343 - (605 + 728))))) or ((202 + 80) <= (92 - 50))) then
					if (((212 + 4397) >= (2831 - 2065)) and v25(v102.AvengingWrath, not v17:IsInRange(10 + 0))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v136 = 10 - 6;
			end
			if ((v136 == (0 + 0)) or ((1641 - (457 + 32)) == (1056 + 1432))) then
				v137 = v101.HandleDPSPotion(v35 and (v15:BuffUp(v102.AvengingWrathBuff) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.Crusade) == (1412 - (832 + 570))))));
				if (((3224 + 198) > (874 + 2476)) and v137) then
					return v137;
				end
				v136 = 3 - 2;
			end
			if (((423 + 454) > (1172 - (588 + 208))) and ((10 - 6) == v136)) then
				if ((v102.Crusade:IsCastable() and v54 and ((v35 and v58) or not v58) and (((v112 >= (1805 - (884 + 916))) and (v10.CombatTime() < (10 - 5))) or ((v112 >= (2 + 1)) and (v10.CombatTime() > (658 - (232 + 421)))))) or ((5007 - (1569 + 320)) <= (455 + 1396))) then
					if (v25(v102.Crusade, not v17:IsInRange(2 + 8)) or ((556 - 391) >= (4097 - (316 + 289)))) then
						return "crusade cooldowns 14";
					end
				end
				if (((10336 - 6387) < (225 + 4631)) and v102.FinalReckoning:IsCastable() and v55 and ((v35 and v59) or not v59) and (((v112 >= (1457 - (666 + 787))) and (v10.CombatTime() < (433 - (360 + 65)))) or ((v112 >= (3 + 0)) and ((v10.CombatTime() >= (262 - (79 + 175))) or not v102.VanguardofJustice:IsAvailable())) or ((v112 >= (2 - 0)) and v102.DivineAuxiliary:IsAvailable())) and ((v102.AvengingWrath:CooldownRemains() > (8 + 2)) or (v102.Crusade:CooldownDown() and (v15:BuffDown(v102.CrusadeBuff) or (v15:BuffStack(v102.CrusadeBuff) >= (30 - 20)))))) then
					local v201 = 0 - 0;
					while true do
						if ((v201 == (899 - (503 + 396))) or ((4457 - (92 + 89)) < (5850 - 2834))) then
							if (((2406 + 2284) > (2442 + 1683)) and (v100 == "player")) then
								if (v25(v106.FinalReckoningPlayer, not v17:IsInRange(39 - 29)) or ((7 + 43) >= (2042 - 1146))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v100 == "cursor") or ((1496 + 218) >= (1413 + 1545))) then
								if (v25(v106.FinalReckoningCursor, not v17:IsInRange(60 - 40)) or ((187 + 1304) < (981 - 337))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((1948 - (485 + 759)) < (2283 - 1296)) and (v136 == (1190 - (442 + 747)))) then
				if (((4853 - (832 + 303)) > (2852 - (88 + 858))) and v102.LightsJudgment:IsCastable() and v91 and ((v92 and v35) or not v92)) then
					if (v25(v102.LightsJudgment, not v17:IsInRange(13 + 27)) or ((793 + 165) > (150 + 3485))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((4290 - (766 + 23)) <= (22175 - 17683)) and v102.Fireblood:IsCastable() and v91 and ((v92 and v35) or not v92) and (v15:BuffUp(v102.AvengingWrathBuff) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) == (13 - 3))))) then
					if (v25(v102.Fireblood, not v17:IsInRange(26 - 16)) or ((11682 - 8240) < (3621 - (1036 + 37)))) then
						return "fireblood cooldowns 6";
					end
				end
				v136 = 2 + 0;
			end
		end
	end
	local function v124()
		v114 = ((v108 >= (5 - 2)) or ((v108 >= (2 + 0)) and not v102.DivineArbiter:IsAvailable()) or v15:BuffUp(v102.EmpyreanPowerBuff)) and v15:BuffDown(v102.EmpyreanLegacyBuff) and not (v15:BuffUp(v102.DivineArbiterBuff) and (v15:BuffStack(v102.DivineArbiterBuff) > (1504 - (641 + 839))));
		if (((3788 - (910 + 3)) >= (3731 - 2267)) and v102.DivineStorm:IsReady() and v43 and v114 and (not v102.Crusade:IsAvailable() or (v102.Crusade:CooldownRemains() > (v113 * (1687 - (1466 + 218)))) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) < (5 + 5))))) then
			if (v25(v102.DivineStorm, not v17:IsInRange(1158 - (556 + 592))) or ((1706 + 3091) >= (5701 - (329 + 479)))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v102.JusticarsVengeance:IsReady() and v48 and (not v102.Crusade:IsAvailable() or (v102.Crusade:CooldownRemains() > (v113 * (857 - (174 + 680)))) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) < (34 - 24))))) or ((1141 - 590) > (1477 + 591))) then
			if (((2853 - (396 + 343)) > (84 + 860)) and v25(v102.JusticarsVengeance, not v17:IsSpellInRange(v102.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v102.FinalVerdict:IsAvailable() and v102.FinalVerdict:IsCastable() and v52 and (not v102.Crusade:IsAvailable() or (v102.Crusade:CooldownRemains() > (v113 * (1480 - (29 + 1448)))) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) < (1399 - (135 + 1254)))))) or ((8521 - 6259) >= (14455 - 11359))) then
			if (v25(v102.FinalVerdict, not v17:IsSpellInRange(v102.FinalVerdict)) or ((1503 + 752) >= (5064 - (389 + 1138)))) then
				return "final verdict finishers 6";
			end
		end
		if ((v102.TemplarsVerdict:IsReady() and v52 and (not v102.Crusade:IsAvailable() or (v102.Crusade:CooldownRemains() > (v113 * (577 - (102 + 472)))) or (v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) < (10 + 0))))) or ((2128 + 1709) < (1218 + 88))) then
			if (((4495 - (320 + 1225)) == (5251 - 2301)) and v25(v102.TemplarsVerdict, not v17:IsSpellInRange(v102.TemplarsVerdict))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v125()
		if ((v112 >= (4 + 1)) or (v15:BuffUp(v102.EchoesofWrathBuff) and v15:HasTier(1495 - (157 + 1307), 1863 - (821 + 1038)) and v102.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v102.JudgmentDebuff) or (v112 == (9 - 5))) and v15:BuffUp(v102.DivineResonanceBuff) and not v15:HasTier(4 + 27, 3 - 1)) or ((1758 + 2965) < (8174 - 4876))) then
			v32 = v124();
			if (((2162 - (834 + 192)) >= (10 + 144)) and v32) then
				return v32;
			end
		end
		if ((v102.WakeofAshes:IsCastable() and v51 and (v112 <= (1 + 1)) and ((v102.AvengingWrath:CooldownRemains() > (1 + 5)) or (v102.Crusade:CooldownRemains() > (8 - 2))) and (not v102.ExecutionSentence:IsAvailable() or (v102.ExecutionSentence:CooldownRemains() > (308 - (300 + 4))) or (v110 < (3 + 5)))) or ((709 - 438) > (5110 - (112 + 250)))) then
			if (((1890 + 2850) >= (7896 - 4744)) and v25(v102.WakeofAshes, not v17:IsInRange(6 + 4))) then
				return "wake_of_ashes generators 2";
			end
		end
		if ((v102.BladeofJustice:IsCastable() and v39 and not v17:DebuffUp(v102.ExpurgationDebuff) and (v112 <= (2 + 1)) and v15:HasTier(24 + 7, 1 + 1)) or ((1916 + 662) >= (4804 - (1001 + 413)))) then
			if (((91 - 50) <= (2543 - (244 + 638))) and v25(v102.BladeofJustice, not v17:IsSpellInRange(v102.BladeofJustice))) then
				return "blade_of_justice generators 4";
			end
		end
		if (((1294 - (627 + 66)) < (10607 - 7047)) and v102.DivineToll:IsCastable() and v44 and (v112 <= (604 - (512 + 90))) and ((v102.AvengingWrath:CooldownRemains() > (1921 - (1665 + 241))) or (v102.Crusade:CooldownRemains() > (732 - (373 + 344))) or (v110 < (4 + 4)))) then
			if (((63 + 172) < (1812 - 1125)) and v25(v102.DivineToll, not v17:IsInRange(50 - 20))) then
				return "divine_toll generators 6";
			end
		end
		if (((5648 - (35 + 1064)) > (839 + 314)) and v102.Judgment:IsReady() and v47 and v17:DebuffUp(v102.ExpurgationDebuff) and v15:BuffDown(v102.EchoesofWrathBuff) and v15:HasTier(66 - 35, 1 + 1)) then
			if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((5910 - (298 + 938)) < (5931 - (233 + 1026)))) then
				return "judgment generators 7";
			end
		end
		if (((5334 - (636 + 1030)) < (2332 + 2229)) and (v112 >= (3 + 0)) and v15:BuffUp(v102.CrusadeBuff) and (v15:BuffStack(v102.CrusadeBuff) < (3 + 7))) then
			local v169 = 0 + 0;
			while true do
				if ((v169 == (221 - (55 + 166))) or ((89 + 366) == (363 + 3242))) then
					v32 = v124();
					if (v32 or ((10169 - 7506) == (3609 - (36 + 261)))) then
						return v32;
					end
					break;
				end
			end
		end
		if (((7479 - 3202) <= (5843 - (34 + 1334))) and v102.TemplarSlash:IsReady() and v49 and ((v102.TemplarStrike:TimeSinceLastCast() + v113) < (2 + 2)) and (v108 >= (2 + 0))) then
			if (v25(v102.TemplarSlash, not v17:IsSpellInRange(v102.TemplarSlash)) or ((2153 - (1035 + 248)) == (1210 - (20 + 1)))) then
				return "templar_slash generators 8";
			end
		end
		if (((810 + 743) <= (3452 - (134 + 185))) and v102.BladeofJustice:IsCastable() and v39 and ((v112 <= (1136 - (549 + 584))) or not v102.HolyBlade:IsAvailable()) and (((v108 >= (687 - (314 + 371))) and not v102.CrusadingStrikes:IsAvailable()) or (v108 >= (13 - 9)))) then
			if (v25(v102.BladeofJustice, not v17:IsSpellInRange(v102.BladeofJustice)) or ((3205 - (478 + 490)) >= (1860 + 1651))) then
				return "blade_of_justice generators 10";
			end
		end
		if ((v102.HammerofWrath:IsReady() and v46 and ((v108 < (1174 - (786 + 386))) or not v102.BlessedChampion:IsAvailable() or v15:HasTier(97 - 67, 1383 - (1055 + 324))) and ((v112 <= (1343 - (1093 + 247))) or (v17:HealthPercentage() > (18 + 2)) or not v102.VanguardsMomentum:IsAvailable())) or ((140 + 1184) > (11989 - 8969))) then
			if (v25(v102.HammerofWrath, not v17:IsSpellInRange(v102.HammerofWrath)) or ((10153 - 7161) == (5352 - 3471))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if (((7805 - 4699) > (543 + 983)) and v102.TemplarSlash:IsReady() and v49 and ((v102.TemplarStrike:TimeSinceLastCast() + v113) < (15 - 11))) then
			if (((10419 - 7396) < (2919 + 951)) and v25(v102.TemplarSlash, not v17:IsSpellInRange(v102.TemplarSlash))) then
				return "templar_slash generators 14";
			end
		end
		if (((365 - 222) > (762 - (364 + 324))) and v102.Judgment:IsReady() and v47 and v17:DebuffDown(v102.JudgmentDebuff) and ((v112 <= (7 - 4)) or not v102.BoundlessJudgment:IsAvailable())) then
			if (((43 - 25) < (700 + 1412)) and v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment))) then
				return "judgment generators 16";
			end
		end
		if (((4590 - 3493) <= (2607 - 979)) and v102.BladeofJustice:IsCastable() and v39 and ((v112 <= (8 - 5)) or not v102.HolyBlade:IsAvailable())) then
			if (((5898 - (1249 + 19)) == (4180 + 450)) and v25(v102.BladeofJustice, not v17:IsSpellInRange(v102.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((13779 - 10239) > (3769 - (686 + 400))) and ((v17:HealthPercentage() <= (16 + 4)) or v15:BuffUp(v102.AvengingWrathBuff) or v15:BuffUp(v102.CrusadeBuff) or v15:BuffUp(v102.EmpyreanPowerBuff))) then
			v32 = v124();
			if (((5023 - (73 + 156)) >= (16 + 3259)) and v32) then
				return v32;
			end
		end
		if (((2295 - (721 + 90)) == (17 + 1467)) and v102.Consecration:IsCastable() and v40 and v17:DebuffDown(v102.ConsecrationDebuff) and (v108 >= (6 - 4))) then
			if (((1902 - (224 + 246)) < (5759 - 2204)) and v25(v102.Consecration, not v17:IsInRange(18 - 8))) then
				return "consecration generators 22";
			end
		end
		if ((v102.DivineHammer:IsCastable() and v42 and (v108 >= (1 + 1))) or ((26 + 1039) > (2628 + 950))) then
			if (v25(v102.DivineHammer, not v17:IsInRange(19 - 9)) or ((15956 - 11161) < (1920 - (203 + 310)))) then
				return "divine_hammer generators 24";
			end
		end
		if (((3846 - (1238 + 755)) < (337 + 4476)) and v102.CrusaderStrike:IsCastable() and v41 and (v102.CrusaderStrike:ChargesFractional() >= (1535.75 - (709 + 825))) and ((v112 <= (3 - 1)) or ((v112 <= (3 - 0)) and (v102.BladeofJustice:CooldownRemains() > (v113 * (866 - (196 + 668))))) or ((v112 == (15 - 11)) and (v102.BladeofJustice:CooldownRemains() > (v113 * (3 - 1))) and (v102.Judgment:CooldownRemains() > (v113 * (835 - (171 + 662))))))) then
			if (v25(v102.CrusaderStrike, not v17:IsSpellInRange(v102.CrusaderStrike)) or ((2914 - (4 + 89)) < (8520 - 6089))) then
				return "crusader_strike generators 26";
			end
		end
		v32 = v124();
		if (v32 or ((1047 + 1827) < (9579 - 7398))) then
			return v32;
		end
		if ((v102.TemplarSlash:IsReady() and v49) or ((1055 + 1634) <= (1829 - (35 + 1451)))) then
			if (v25(v102.TemplarSlash, not v17:IsSpellInRange(v102.TemplarSlash)) or ((3322 - (28 + 1425)) == (4002 - (941 + 1052)))) then
				return "templar_slash generators 28";
			end
		end
		if ((v102.TemplarStrike:IsReady() and v50) or ((3401 + 145) < (3836 - (822 + 692)))) then
			if (v25(v102.TemplarStrike, not v17:IsSpellInRange(v102.TemplarStrike)) or ((2971 - 889) == (2249 + 2524))) then
				return "templar_strike generators 30";
			end
		end
		if (((3541 - (45 + 252)) > (1044 + 11)) and v102.Judgment:IsReady() and v47 and ((v112 <= (2 + 1)) or not v102.BoundlessJudgment:IsAvailable())) then
			if (v25(v102.Judgment, not v17:IsSpellInRange(v102.Judgment)) or ((8062 - 4749) <= (2211 - (114 + 319)))) then
				return "judgment generators 32";
			end
		end
		if ((v102.HammerofWrath:IsReady() and v46 and ((v112 <= (3 - 0)) or (v17:HealthPercentage() > (25 - 5)) or not v102.VanguardsMomentum:IsAvailable())) or ((906 + 515) >= (3134 - 1030))) then
			if (((3796 - 1984) <= (5212 - (556 + 1407))) and v25(v102.HammerofWrath, not v17:IsSpellInRange(v102.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if (((2829 - (741 + 465)) <= (2422 - (170 + 295))) and v102.CrusaderStrike:IsCastable() and v41) then
			if (((2325 + 2087) == (4053 + 359)) and v25(v102.CrusaderStrike, not v17:IsSpellInRange(v102.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if (((4308 - 2558) >= (698 + 144)) and v102.ArcaneTorrent:IsCastable() and ((v92 and v35) or not v92) and v91 and (v112 < (4 + 1)) and (v88 < v110)) then
			if (((2476 + 1896) > (3080 - (957 + 273))) and v25(v102.ArcaneTorrent, not v17:IsInRange(3 + 7))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((93 + 139) < (3128 - 2307)) and v102.Consecration:IsCastable() and v40) then
			if (((1365 - 847) < (2754 - 1852)) and v25(v102.Consecration, not v17:IsInRange(49 - 39))) then
				return "consecration generators 30";
			end
		end
		if (((4774 - (389 + 1391)) > (539 + 319)) and v102.DivineHammer:IsCastable() and v42) then
			if (v25(v102.DivineHammer, not v17:IsInRange(2 + 8)) or ((8548 - 4793) <= (1866 - (783 + 168)))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v126()
		v37 = EpicSettings.Settings['swapAuras'];
		v38 = EpicSettings.Settings['useWeapon'];
		v39 = EpicSettings.Settings['useBladeofJustice'];
		v40 = EpicSettings.Settings['useConsecration'];
		v41 = EpicSettings.Settings['useCrusaderStrike'];
		v42 = EpicSettings.Settings['useDivineHammer'];
		v43 = EpicSettings.Settings['useDivineStorm'];
		v44 = EpicSettings.Settings['useDivineToll'];
		v45 = EpicSettings.Settings['useExecutionSentence'];
		v46 = EpicSettings.Settings['useHammerofWrath'];
		v47 = EpicSettings.Settings['useJudgment'];
		v48 = EpicSettings.Settings['useJusticarsVengeance'];
		v49 = EpicSettings.Settings['useTemplarSlash'];
		v50 = EpicSettings.Settings['useTemplarStrike'];
		v51 = EpicSettings.Settings['useWakeofAshes'];
		v52 = EpicSettings.Settings['useVerdict'];
		v53 = EpicSettings.Settings['useAvengingWrath'];
		v54 = EpicSettings.Settings['useCrusade'];
		v55 = EpicSettings.Settings['useFinalReckoning'];
		v56 = EpicSettings.Settings['useShieldofVengeance'];
		v57 = EpicSettings.Settings['avengingWrathWithCD'];
		v58 = EpicSettings.Settings['crusadeWithCD'];
		v59 = EpicSettings.Settings['finalReckoningWithCD'];
		v60 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v127()
		local v162 = 0 - 0;
		while true do
			if (((3882 + 64) > (4054 - (309 + 2))) and (v162 == (15 - 10))) then
				v100 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v162 == (1212 - (1090 + 122))) or ((433 + 902) >= (11102 - 7796))) then
				v61 = EpicSettings.Settings['useRebuke'];
				v62 = EpicSettings.Settings['useHammerofJustice'];
				v63 = EpicSettings.Settings['useDivineProtection'];
				v64 = EpicSettings.Settings['useDivineShield'];
				v162 = 1 + 0;
			end
			if (((5962 - (628 + 490)) > (404 + 1849)) and (v162 == (7 - 4))) then
				v73 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v74 = EpicSettings.Settings['layOnHandsFocusHP'] or (774 - (431 + 343));
				v75 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 - 0);
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v162 = 4 + 0;
			end
			if (((58 + 394) == (2147 - (556 + 1139))) and (v162 == (17 - (6 + 9)))) then
				v69 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v70 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v71 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
				v72 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v162 = 172 - (28 + 141);
			end
			if ((v162 == (2 + 2)) or ((5624 - 1067) < (1479 + 608))) then
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (1317 - (486 + 831));
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v162 = 17 - 12;
			end
			if (((733 + 3141) == (12249 - 8375)) and (v162 == (1264 - (668 + 595)))) then
				v65 = EpicSettings.Settings['useLayonHands'];
				v66 = EpicSettings.Settings['useLayOnHandsFocus'];
				v67 = EpicSettings.Settings['useWordofGloryFocus'];
				v68 = EpicSettings.Settings['useWordofGloryMouseover'];
				v162 = 2 + 0;
			end
		end
	end
	local function v128()
		local v163 = 0 + 0;
		while true do
			if ((v163 == (2 - 1)) or ((2228 - (23 + 267)) > (6879 - (1129 + 815)))) then
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v89 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v163 = 389 - (371 + 16);
			end
			if ((v163 == (1754 - (1326 + 424))) or ((8058 - 3803) < (12508 - 9085))) then
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				v98 = EpicSettings.Settings['HealOOC'];
				v99 = EpicSettings.Settings['HealOOCHP'] or (118 - (88 + 30));
				break;
			end
			if (((2225 - (720 + 51)) <= (5541 - 3050)) and ((1778 - (421 + 1355)) == v163)) then
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v163 = 4 - 1;
			end
			if (((0 + 0) == v163) or ((5240 - (286 + 797)) <= (10246 - 7443))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v163 = 440 - (397 + 42);
			end
			if (((1516 + 3337) >= (3782 - (24 + 776))) and (v163 == (4 - 1))) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (785 - (222 + 563));
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v83 = EpicSettings.Settings['handleAfflicted'];
				v163 = 3 + 1;
			end
		end
	end
	local function v129()
		local v164 = 190 - (23 + 167);
		while true do
			if (((5932 - (690 + 1108)) > (1212 + 2145)) and ((1 + 0) == v164)) then
				v33 = EpicSettings.Toggles['ooc'];
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v164 = 850 - (40 + 808);
			end
			if ((v164 == (1 + 2)) or ((13066 - 9649) < (2422 + 112))) then
				if (v34 or ((1440 + 1282) <= (90 + 74))) then
					v108 = #v107;
				else
					local v202 = 571 - (47 + 524);
					while true do
						if ((v202 == (0 + 0)) or ((6582 - 4174) < (3153 - 1044))) then
							v107 = {};
							v108 = 2 - 1;
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1759 - (1165 + 561)) == (44 + 1411))) then
					if ((v102.CrusaderAura:IsCastable() and (v15:BuffDown(v102.CrusaderAura)) and v37) or ((1371 - 928) >= (1532 + 2483))) then
						if (((3861 - (341 + 138)) > (45 + 121)) and v25(v102.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				v111 = v115();
				v164 = 7 - 3;
			end
			if ((v164 == (326 - (89 + 237))) or ((900 - 620) == (6439 - 3380))) then
				v127();
				v126();
				v128();
				v164 = 882 - (581 + 300);
			end
			if (((3101 - (855 + 365)) > (3070 - 1777)) and (v164 == (3 + 5))) then
				v32 = v120();
				if (((3592 - (1030 + 205)) == (2213 + 144)) and v32) then
					return v32;
				end
				if (((115 + 8) == (409 - (156 + 130))) and not v15:AffectingCombat() and v33 and v101.TargetIsValid()) then
					v32 = v122();
					if (v32 or ((2399 - 1343) >= (5716 - 2324))) then
						return v32;
					end
				end
				v164 = 17 - 8;
			end
			if (((2 + 3) == v164) or ((631 + 450) < (1144 - (10 + 59)))) then
				if (v15:AffectingCombat() or ((297 + 752) >= (21826 - 17394))) then
					if ((v102.Intercession:IsCastable() and (v15:HolyPower() >= (1166 - (671 + 492))) and v102.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((3796 + 972) <= (2061 - (369 + 846)))) then
						if (v25(v106.IntercessionMouseover) or ((889 + 2469) <= (1212 + 208))) then
							return "Intercession mouseover";
						end
					end
				end
				if (v15:AffectingCombat() or (v82 and v102.CleanseToxins:IsAvailable()) or ((5684 - (1036 + 909)) <= (2390 + 615))) then
					local v203 = v82 and v102.CleanseToxins:IsReady() and v36;
					v32 = v101.FocusUnit(v203, nil, 33 - 13, nil, 228 - (11 + 192), v102.FlashofLight);
					if (v32 or ((839 + 820) >= (2309 - (135 + 40)))) then
						return v32;
					end
				end
				if (v36 or ((7898 - 4638) < (1420 + 935))) then
					v32 = v101.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 88 - 48, 37 - 12, v102.FlashofLight, 178 - (50 + 126));
					if (v32 or ((1862 - 1193) == (935 + 3288))) then
						return v32;
					end
					if ((v102.BlessingofFreedom:IsReady() and v101.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((3105 - (1233 + 180)) < (1557 - (522 + 447)))) then
						if (v25(v106.BlessingofFreedomFocus) or ((6218 - (107 + 1314)) < (1695 + 1956))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				v164 = 18 - 12;
			end
			if ((v164 == (3 + 3)) or ((8294 - 4117) > (19189 - 14339))) then
				if (v101.TargetIsValid() or v15:AffectingCombat() or ((2310 - (716 + 1194)) > (19 + 1092))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					if (((327 + 2724) > (1508 - (74 + 429))) and (v110 == (21433 - 10322))) then
						v110 = v10.FightRemains(v107, false);
					end
					v113 = v15:GCD();
					v112 = v15:HolyPower();
				end
				if (((1831 + 1862) <= (10030 - 5648)) and v83) then
					if (v79 or ((2322 + 960) > (12640 - 8540))) then
						local v204 = 0 - 0;
						while true do
							if ((v204 == (433 - (279 + 154))) or ((4358 - (454 + 324)) < (2238 + 606))) then
								v32 = v101.HandleAfflicted(v102.CleanseToxins, v106.CleanseToxinsMouseover, 57 - (12 + 5));
								if (((48 + 41) < (11440 - 6950)) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					if ((v80 and (v112 > (1 + 1))) or ((6076 - (277 + 816)) < (7725 - 5917))) then
						v32 = v101.HandleAfflicted(v102.WordofGlory, v106.WordofGloryMouseover, 1223 - (1058 + 125), true);
						if (((718 + 3111) > (4744 - (815 + 160))) and v32) then
							return v32;
						end
					end
				end
				if (((6371 - 4886) <= (6893 - 3989)) and v84) then
					v32 = v101.HandleIncorporeal(v102.Repentance, v106.RepentanceMouseOver, 8 + 22, true);
					if (((12478 - 8209) == (6167 - (41 + 1857))) and v32) then
						return v32;
					end
					v32 = v101.HandleIncorporeal(v102.TurnEvil, v106.TurnEvilMouseOver, 1923 - (1222 + 671), true);
					if (((1000 - 613) <= (3998 - 1216)) and v32) then
						return v32;
					end
				end
				v164 = 1189 - (229 + 953);
			end
			if ((v164 == (1783 - (1111 + 663))) or ((3478 - (874 + 705)) <= (129 + 788))) then
				if ((v15:AffectingCombat() and v101.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((2942 + 1370) <= (1820 - 944))) then
					if (((63 + 2169) <= (3275 - (642 + 37))) and v65 and (v15:HealthPercentage() <= v73) and v102.LayonHands:IsReady() and v15:DebuffDown(v102.ForbearanceDebuff)) then
						if (((478 + 1617) < (590 + 3096)) and v25(v102.LayonHands)) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v64 and (v15:HealthPercentage() <= v72) and v102.DivineShield:IsCastable() and v15:DebuffDown(v102.ForbearanceDebuff)) or ((4004 - 2409) >= (4928 - (233 + 221)))) then
						if (v25(v102.DivineShield) or ((10680 - 6061) < (2537 + 345))) then
							return "divine_shield defensive";
						end
					end
					if ((v63 and v102.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v71)) or ((1835 - (718 + 823)) >= (3040 + 1791))) then
						if (((2834 - (266 + 539)) <= (8731 - 5647)) and v25(v102.DivineProtection)) then
							return "divine_protection defensive";
						end
					end
					if ((v103.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) or ((3262 - (636 + 589)) == (5744 - 3324))) then
						if (((9194 - 4736) > (3094 + 810)) and v25(v106.Healthstone)) then
							return "healthstone defensive";
						end
					end
					if (((159 + 277) >= (1138 - (657 + 358))) and v93 and (v15:HealthPercentage() <= v95)) then
						if (((1323 - 823) < (4137 - 2321)) and (v97 == "Refreshing Healing Potion")) then
							if (((4761 - (1151 + 36)) == (3452 + 122)) and v103.RefreshingHealingPotion:IsReady()) then
								if (((59 + 162) < (1164 - 774)) and v25(v106.RefreshingHealingPotion)) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if ((v97 == "Dreamwalker's Healing Potion") or ((4045 - (1552 + 280)) <= (2255 - (64 + 770)))) then
							if (((2077 + 981) < (11032 - 6172)) and v103.DreamwalkersHealingPotion:IsReady()) then
								if (v25(v106.RefreshingHealingPotion) or ((231 + 1065) >= (5689 - (157 + 1086)))) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
					end
					if ((v88 < v110) or ((2788 - 1395) > (19660 - 15171))) then
						v32 = v123();
						if (v32 or ((6786 - 2362) < (36 - 9))) then
							return v32;
						end
						if ((v35 and v103.FyralathTheDreamrender:IsEquippedAndReady() and v38 and (v102.MarkofFyralathDebuff:AuraActiveCount() > (819 - (599 + 220))) and v15:BuffDown(v102.AvengingWrathBuff) and v15:BuffDown(v102.CrusadeBuff)) or ((3976 - 1979) > (5746 - (1813 + 118)))) then
							if (((2533 + 932) > (3130 - (841 + 376))) and v25(v106.UseWeapon)) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					v32 = v125();
					if (((1026 - 293) < (423 + 1396)) and v32) then
						return v32;
					end
					if (v25(v102.Pool) or ((11996 - 7601) == (5614 - (464 + 395)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((5 - 3) == v164) or ((1822 + 1971) < (3206 - (467 + 370)))) then
				v36 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((8439 - 4355) == (195 + 70))) then
					return v32;
				end
				v107 = v15:GetEnemiesInMeleeRange(27 - 19);
				v164 = 1 + 2;
			end
			if (((10138 - 5780) == (4878 - (150 + 370))) and (v164 == (1289 - (74 + 1208)))) then
				v32 = v119();
				if (v32 or ((7718 - 4580) < (4709 - 3716))) then
					return v32;
				end
				if (((2370 + 960) > (2713 - (14 + 376))) and v82 and v36) then
					if (v14 or ((6289 - 2663) == (2582 + 1407))) then
						v32 = v118();
						if (v32 or ((805 + 111) == (2548 + 123))) then
							return v32;
						end
					end
					if (((796 - 524) == (205 + 67)) and v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v101.UnitHasCurseDebuff(v16) or v101.UnitHasPoisonDebuff(v16) or v101.UnitHasDispellableDebuffByPlayer(v16))) then
						if (((4327 - (23 + 55)) <= (11467 - 6628)) and v102.CleanseToxins:IsReady()) then
							if (((1854 + 923) < (2874 + 326)) and v25(v106.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v164 = 11 - 3;
			end
			if (((30 + 65) < (2858 - (652 + 249))) and (v164 == (10 - 6))) then
				if (((2694 - (708 + 1160)) < (4660 - 2943)) and not v15:AffectingCombat()) then
					if (((2599 - 1173) >= (1132 - (10 + 17))) and v102.RetributionAura:IsCastable() and (v116()) and v37) then
						if (((619 + 2135) <= (5111 - (1400 + 332))) and v25(v102.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((7531 - 3604) == (3321 - (242 + 1666)))) then
					if (v15:AffectingCombat() or ((494 + 660) <= (289 + 499))) then
						if (v102.Intercession:IsCastable() or ((1401 + 242) > (4319 - (850 + 90)))) then
							if (v25(v102.Intercession, not v17:IsInRange(52 - 22), true) or ((4193 - (360 + 1030)) > (4026 + 523))) then
								return "intercession target";
							end
						end
					elseif (v102.Redemption:IsCastable() or ((620 - 400) >= (4157 - 1135))) then
						if (((4483 - (909 + 752)) == (4045 - (109 + 1114))) and v25(v102.Redemption, not v17:IsInRange(54 - 24), true)) then
							return "redemption target";
						end
					end
				end
				if ((v102.Redemption:IsCastable() and v102.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((414 + 647) == (2099 - (6 + 236)))) then
					if (((1739 + 1021) > (1098 + 266)) and v25(v106.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				v164 = 11 - 6;
			end
		end
	end
	local function v130()
		local v165 = 0 - 0;
		while true do
			if ((v165 == (1133 - (1076 + 57))) or ((807 + 4095) <= (4284 - (579 + 110)))) then
				v102.MarkofFyralathDebuff:RegisterAuraTracking();
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v165 = 1 + 0;
			end
			if ((v165 == (1 + 0)) or ((2045 + 1807) == (700 - (174 + 233)))) then
				v105();
				break;
			end
		end
	end
	v21.SetAPL(195 - 125, v129, v130);
end;
return v0["Epix_Paladin_Retribution.lua"]();

