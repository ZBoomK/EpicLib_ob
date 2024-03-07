local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2904 - 1702) > (1826 - (442 + 326))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Focus;
	local v14 = v11.Player;
	local v15 = v11.MouseOver;
	local v16 = v11.Target;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = math.min;
	local v28 = math.max;
	local v29;
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
	local v98 = v20.Commons.Everyone;
	local v99 = v18.Paladin.Retribution;
	local v100 = v19.Paladin.Retribution;
	local v101 = {};
	local function v102()
		if (((12793 - 9082) > (1739 + 1616)) and v99.CleanseToxins:IsAvailable()) then
			v98.DispellableDebuffs = v12.MergeTable(v98.DispellableDiseaseDebuffs, v98.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v102();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v103 = v23.Paladin.Retribution;
	local v104;
	local v105;
	local v106 = 11581 - (381 + 89);
	local v107 = 9854 + 1257;
	local v108;
	local v109 = 0 + 0;
	local v110 = 0 - 0;
	local v111;
	v9:RegisterForEvent(function()
		v106 = 12267 - (1074 + 82);
		v107 = 24349 - 13238;
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		local v128 = 1784 - (214 + 1570);
		local v129;
		local v130;
		while true do
			if ((v128 == (1455 - (990 + 465))) or ((374 + 532) >= (970 + 1259))) then
				v129 = v14:GCDRemains();
				v130 = v27(v99.CrusaderStrike:CooldownRemains(), v99.BladeofJustice:CooldownRemains(), v99.Judgment:CooldownRemains(), (v99.HammerofWrath:IsUsable() and v99.HammerofWrath:CooldownRemains()) or (10 + 0), v99.WakeofAshes:CooldownRemains());
				v128 = 3 - 2;
			end
			if (((3014 - (1668 + 58)) > (1877 - (512 + 114))) and (v128 == (2 - 1))) then
				if ((v129 > v130) or ((9329 - 4816) < (11663 - 8311))) then
					return v129;
				end
				return v130;
			end
		end
	end
	local function v113()
		return v14:BuffDown(v99.RetributionAura) and v14:BuffDown(v99.DevotionAura) and v14:BuffDown(v99.ConcentrationAura) and v14:BuffDown(v99.CrusaderAura);
	end
	local v114 = 0 + 0;
	local function v115()
		if ((v99.CleanseToxins:IsReady() and v98.DispellableFriendlyUnit(5 + 20)) or ((1796 + 269) >= (10779 - 7583))) then
			if ((v114 == (1994 - (109 + 1885))) or ((5845 - (1269 + 200)) <= (2838 - 1357))) then
				v114 = GetTime();
			end
			if (v98.Wait(1315 - (98 + 717), v114) or ((4218 - (802 + 24)) >= (8175 - 3434))) then
				if (((4199 - 874) >= (319 + 1835)) and v24(v103.CleanseToxinsFocus)) then
					return "cleanse_toxins dispel";
				end
				v114 = 0 + 0;
			end
		end
	end
	local function v116()
		if ((v95 and (v14:HealthPercentage() <= v96)) or ((213 + 1082) >= (698 + 2535))) then
			if (((12176 - 7799) > (5475 - 3833)) and v99.FlashofLight:IsReady()) then
				if (((1690 + 3033) > (552 + 804)) and v24(v99.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v117()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (0 + 0)) or ((1932 + 2204) <= (4866 - (797 + 636)))) then
				if (((20610 - 16365) <= (6250 - (1427 + 192))) and v15:Exists()) then
					if (((1482 + 2794) >= (9086 - 5172)) and v99.WordofGlory:IsReady() and v65 and (v15:HealthPercentage() <= v73)) then
						if (((178 + 20) <= (1979 + 2386)) and v24(v103.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((5108 - (192 + 134)) > (5952 - (316 + 960))) and (not v13 or not v13:Exists() or not v13:IsInRange(17 + 13))) then
					return;
				end
				v131 = 1 + 0;
			end
			if (((4496 + 368) > (8399 - 6202)) and (v131 == (552 - (83 + 468)))) then
				if (v13 or ((5506 - (1202 + 604)) == (11703 - 9196))) then
					local v194 = 0 - 0;
					while true do
						if (((12387 - 7913) >= (599 - (45 + 280))) and (v194 == (1 + 0))) then
							if ((v99.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) or ((1655 + 239) <= (514 + 892))) then
								if (((870 + 702) >= (270 + 1261)) and v24(v103.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v99.BlessingofProtection:IsCastable() and v66 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) or ((8678 - 3991) < (6453 - (340 + 1571)))) then
								if (((1299 + 1992) > (3439 - (1733 + 39))) and v24(v103.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v194 == (0 - 0)) or ((1907 - (125 + 909)) == (3982 - (1096 + 852)))) then
							if ((v99.WordofGlory:IsReady() and v64 and (v13:HealthPercentage() <= v72)) or ((1264 + 1552) < (15 - 4))) then
								if (((3588 + 111) < (5218 - (409 + 103))) and v24(v103.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if (((2882 - (46 + 190)) >= (971 - (51 + 44))) and v99.LayonHands:IsCastable() and v63 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v71)) then
								if (((174 + 440) <= (4501 - (1114 + 203))) and v24(v103.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v194 = 727 - (228 + 498);
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v132 = 0 + 0;
		while true do
			if (((1727 + 1399) == (3789 - (174 + 489))) and (v132 == (0 - 0))) then
				v29 = v98.HandleTopTrinket(v101, v32, 1945 - (830 + 1075), nil);
				if (v29 or ((2711 - (303 + 221)) >= (6223 - (231 + 1038)))) then
					return v29;
				end
				v132 = 1 + 0;
			end
			if ((v132 == (1163 - (171 + 991))) or ((15977 - 12100) == (9599 - 6024))) then
				v29 = v98.HandleBottomTrinket(v101, v32, 99 - 59, nil);
				if (((566 + 141) > (2215 - 1583)) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v119()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (2 - 0)) or ((1687 - 1141) >= (3932 - (111 + 1137)))) then
				if (((1623 - (91 + 67)) <= (12800 - 8499)) and v99.TemplarsVerdict:IsReady() and v49 and (v109 >= (1 + 3))) then
					if (((2227 - (423 + 100)) > (11 + 1414)) and v24(v99.TemplarsVerdict, not v16:IsSpellInRange(v99.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				if ((v99.BladeofJustice:IsCastable() and v36) or ((1902 - 1215) == (2207 + 2027))) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((4101 - (326 + 445)) < (6236 - 4807))) then
						return "blade_of_justice precombat 5";
					end
				end
				v133 = 6 - 3;
			end
			if (((2677 - 1530) >= (1046 - (530 + 181))) and ((882 - (614 + 267)) == v133)) then
				if (((3467 - (19 + 13)) > (3413 - 1316)) and v99.JusticarsVengeance:IsAvailable() and v99.JusticarsVengeance:IsReady() and v45 and (v109 >= (9 - 5))) then
					if (v24(v99.JusticarsVengeance, not v16:IsSpellInRange(v99.JusticarsVengeance)) or ((10769 - 6999) >= (1050 + 2991))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v99.FinalVerdict:IsAvailable() and v99.FinalVerdict:IsReady() and v49 and (v109 >= (6 - 2))) or ((7861 - 4070) <= (3423 - (1293 + 519)))) then
					if (v24(v99.FinalVerdict, not v16:IsSpellInRange(v99.FinalVerdict)) or ((9340 - 4762) <= (5242 - 3234))) then
						return "final verdict precombat 3";
					end
				end
				v133 = 3 - 1;
			end
			if (((4851 - 3726) <= (4890 - 2814)) and (v133 == (3 + 1))) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((152 + 591) >= (10220 - 5821))) then
					if (((267 + 888) < (556 + 1117)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v133 == (0 + 0)) or ((3420 - (709 + 387)) <= (2436 - (673 + 1185)))) then
				if (((10924 - 7157) == (12096 - 8329)) and v99.ArcaneTorrent:IsCastable() and v88 and ((v89 and v32) or not v89) and v99.FinalReckoning:IsAvailable()) then
					if (((6727 - 2638) == (2925 + 1164)) and v24(v99.ArcaneTorrent, not v16:IsInRange(6 + 2))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((6018 - 1560) >= (412 + 1262)) and v99.ShieldofVengeance:IsCastable() and v53 and ((v32 and v57) or not v57)) then
					if (((1937 - 965) <= (2783 - 1365)) and v24(v99.ShieldofVengeance, not v16:IsInRange(1888 - (446 + 1434)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v133 = 1284 - (1040 + 243);
			end
			if ((v133 == (8 - 5)) or ((6785 - (559 + 1288)) < (6693 - (609 + 1322)))) then
				if ((v99.Judgment:IsCastable() and v44) or ((2958 - (13 + 441)) > (15933 - 11669))) then
					if (((5639 - 3486) == (10722 - 8569)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment precombat 6";
					end
				end
				if ((v99.HammerofWrath:IsReady() and v43) or ((19 + 488) >= (9409 - 6818))) then
					if (((1592 + 2889) == (1964 + 2517)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v133 = 11 - 7;
			end
		end
	end
	local function v120()
		local v134 = v98.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.Crusade) == (6 + 4))) or (v107 < (45 - 20)));
		if (v134 or ((1540 + 788) < (386 + 307))) then
			return v134;
		end
		if (((3110 + 1218) == (3635 + 693)) and v99.LightsJudgment:IsCastable() and v88 and ((v89 and v32) or not v89)) then
			if (((1554 + 34) >= (1765 - (153 + 280))) and v24(v99.LightsJudgment, not v16:IsInRange(115 - 75))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v99.Fireblood:IsCastable() and v88 and ((v89 and v32) or not v89) and (v14:BuffUp(v99.AvengingWrathBuff) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) == (9 + 1))))) or ((1649 + 2525) > (2224 + 2024))) then
			if (v24(v99.Fireblood, not v16:IsInRange(10 + 0)) or ((3324 + 1262) <= (124 - 42))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((2388 + 1475) == (4530 - (89 + 578))) and v86 and ((v32 and v87) or not v87) and v16:IsInRange(6 + 2)) then
			v29 = v118();
			if (v29 or ((585 - 303) <= (1091 - (572 + 477)))) then
				return v29;
			end
		end
		if (((622 + 3987) >= (460 + 306)) and v99.ShieldofVengeance:IsCastable() and v53 and ((v32 and v57) or not v57) and (v107 > (2 + 13)) and (not v99.ExecutionSentence:IsAvailable() or v16:DebuffDown(v99.ExecutionSentence))) then
			if (v24(v99.ShieldofVengeance) or ((1238 - (84 + 2)) == (4100 - 1612))) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((2466 + 956) > (4192 - (497 + 345))) and v99.ExecutionSentence:IsCastable() and v42 and ((v14:BuffDown(v99.CrusadeBuff) and (v99.Crusade:CooldownRemains() > (1 + 14))) or (v14:BuffStack(v99.CrusadeBuff) == (2 + 8)) or (v99.AvengingWrath:CooldownRemains() < (1333.75 - (605 + 728))) or (v99.AvengingWrath:CooldownRemains() > (11 + 4))) and (((v109 >= (8 - 4)) and (v9.CombatTime() < (1 + 4))) or ((v109 >= (10 - 7)) and (v9.CombatTime() > (5 + 0))) or ((v109 >= (5 - 3)) and v99.DivineAuxiliary:IsAvailable())) and (((v107 > (7 + 1)) and not v99.ExecutionersWill:IsAvailable()) or (v107 > (501 - (457 + 32))))) then
			if (((373 + 504) > (1778 - (832 + 570))) and v24(v99.ExecutionSentence, not v16:IsSpellInRange(v99.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if ((v99.AvengingWrath:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v109 >= (4 + 0)) and (v9.CombatTime() < (2 + 3))) or ((v109 >= (10 - 7)) and (v9.CombatTime() > (3 + 2))) or ((v109 >= (798 - (588 + 208))) and v99.DivineAuxiliary:IsAvailable() and ((v99.ExecutionSentence:IsAvailable() and ((v99.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v99.ExecutionSentence:CooldownRemains() > (1815 - (884 + 916))) or not v99.ExecutionSentence:IsReady())) or (v99.FinalReckoning:IsAvailable() and ((v99.FinalReckoning:CooldownRemains() == (0 - 0)) or (v99.FinalReckoning:CooldownRemains() > (18 + 12)) or not v99.FinalReckoning:IsReady())))))) or ((3771 - (232 + 421)) <= (3740 - (1569 + 320)))) then
			if (v24(v99.AvengingWrath, not v16:IsInRange(3 + 7)) or ((32 + 133) >= (11767 - 8275))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if (((4554 - (316 + 289)) < (12711 - 7855)) and v99.Crusade:IsCastable() and v51 and ((v32 and v55) or not v55) and (v14:BuffRemains(v99.CrusadeBuff) < v14:GCD()) and (((v109 >= (1 + 4)) and (v9.CombatTime() < (1458 - (666 + 787)))) or ((v109 >= (428 - (360 + 65))) and (v9.CombatTime() > (5 + 0))))) then
			if (v24(v99.Crusade, not v16:IsInRange(264 - (79 + 175))) or ((6742 - 2466) < (2354 + 662))) then
				return "crusade cooldowns 14";
			end
		end
		if (((14376 - 9686) > (7944 - 3819)) and v99.FinalReckoning:IsCastable() and v52 and ((v32 and v56) or not v56) and (((v109 >= (903 - (503 + 396))) and (v9.CombatTime() < (189 - (92 + 89)))) or ((v109 >= (5 - 2)) and (v9.CombatTime() >= (5 + 3))) or ((v109 >= (2 + 0)) and v99.DivineAuxiliary:IsAvailable())) and ((v99.AvengingWrath:CooldownRemains() > (39 - 29)) or (v99.Crusade:CooldownDown() and (v14:BuffDown(v99.CrusadeBuff) or (v14:BuffStack(v99.CrusadeBuff) >= (2 + 8))))) and ((v108 > (0 - 0)) or (v109 == (5 + 0)) or ((v109 >= (1 + 1)) and v99.DivineAuxiliary:IsAvailable()))) then
			local v189 = 0 - 0;
			while true do
				if ((v189 == (0 + 0)) or ((76 - 26) >= (2140 - (485 + 759)))) then
					if ((v97 == "player") or ((3965 - 2251) >= (4147 - (442 + 747)))) then
						if (v24(v103.FinalReckoningPlayer, not v16:IsInRange(1145 - (832 + 303))) or ((2437 - (88 + 858)) < (197 + 447))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if (((583 + 121) < (41 + 946)) and (v97 == "cursor")) then
						if (((4507 - (766 + 23)) > (9409 - 7503)) and v24(v103.FinalReckoningCursor, not v16:IsInRange(27 - 7))) then
							return "final_reckoning cooldowns 18";
						end
					end
					break;
				end
			end
		end
	end
	local function v121()
		v111 = ((v105 >= (7 - 4)) or ((v105 >= (6 - 4)) and not v99.DivineArbiter:IsAvailable()) or v14:BuffUp(v99.EmpyreanPowerBuff)) and v14:BuffDown(v99.EmpyreanLegacyBuff) and not (v14:BuffUp(v99.DivineArbiterBuff) and (v14:BuffStack(v99.DivineArbiterBuff) > (1097 - (1036 + 37))));
		if ((v99.DivineStorm:IsReady() and v40 and v111 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (3 + 0))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (19 - 9))))) or ((754 + 204) > (5115 - (641 + 839)))) then
			if (((4414 - (910 + 3)) <= (11451 - 6959)) and v24(v99.DivineStorm, not v16:IsInRange(1694 - (1466 + 218)))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v99.JusticarsVengeance:IsReady() and v45 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (2 + 1))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (1158 - (556 + 592)))))) or ((1224 + 2218) < (3356 - (329 + 479)))) then
			if (((3729 - (174 + 680)) >= (5030 - 3566)) and v24(v99.JusticarsVengeance, not v16:IsSpellInRange(v99.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v99.FinalVerdict:IsAvailable() and v99.FinalVerdict:IsCastable() and v49 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (5 - 2))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (8 + 2))))) or ((5536 - (396 + 343)) >= (433 + 4460))) then
			if (v24(v99.FinalVerdict, not v16:IsSpellInRange(v99.FinalVerdict)) or ((2028 - (29 + 1448)) > (3457 - (135 + 1254)))) then
				return "final verdict finishers 6";
			end
		end
		if (((7963 - 5849) > (4407 - 3463)) and v99.TemplarsVerdict:IsReady() and v49 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (2 + 1))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (1537 - (389 + 1138)))))) then
			if (v24(v99.TemplarsVerdict, not v16:IsSpellInRange(v99.TemplarsVerdict)) or ((2836 - (102 + 472)) >= (2922 + 174))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v122()
		local v135 = 0 + 0;
		while true do
			if ((v135 == (3 + 0)) or ((3800 - (320 + 1225)) >= (6295 - 2758))) then
				if ((v99.HammerofWrath:IsReady() and v43 and ((v105 < (2 + 0)) or not v99.BlessedChampion:IsAvailable() or v14:HasTier(1494 - (157 + 1307), 1863 - (821 + 1038))) and ((v109 <= (7 - 4)) or (v16:HealthPercentage() > (3 + 17)) or not v99.VanguardsMomentum:IsAvailable())) or ((6815 - 2978) < (486 + 820))) then
					if (((7311 - 4361) == (3976 - (834 + 192))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if ((v99.TemplarSlash:IsReady() and v46 and ((v99.TemplarStrike:TimeSinceLastCast() + v110) < (1 + 3))) or ((1213 + 3510) < (71 + 3227))) then
					if (((1759 - 623) >= (458 - (300 + 4))) and v24(v99.TemplarSlash, not v16:IsSpellInRange(v99.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v99.Judgment:IsReady() and v44 and v16:DebuffDown(v99.JudgmentDebuff) and ((v109 <= (1 + 2)) or not v99.BoundlessJudgment:IsAvailable())) or ((709 - 438) > (5110 - (112 + 250)))) then
					if (((1890 + 2850) >= (7896 - 4744)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment generators 16";
					end
				end
				v135 = 3 + 1;
			end
			if ((v135 == (4 + 2)) or ((1929 + 649) >= (1681 + 1709))) then
				if (((31 + 10) <= (3075 - (1001 + 413))) and v29) then
					return v29;
				end
				if (((1340 - 739) < (4442 - (244 + 638))) and v99.TemplarSlash:IsReady() and v46) then
					if (((928 - (627 + 66)) < (2046 - 1359)) and v24(v99.TemplarSlash, not v16:IsInRange(612 - (512 + 90)))) then
						return "templar_slash generators 28";
					end
				end
				if (((6455 - (1665 + 241)) > (1870 - (373 + 344))) and v99.TemplarStrike:IsReady() and v47) then
					if (v24(v99.TemplarStrike, not v16:IsInRange(5 + 5)) or ((1237 + 3437) < (12323 - 7651))) then
						return "templar_strike generators 30";
					end
				end
				v135 = 11 - 4;
			end
			if (((4767 - (35 + 1064)) < (3319 + 1242)) and (v135 == (8 - 4))) then
				if ((v99.BladeofJustice:IsCastable() and v36 and ((v109 <= (1 + 2)) or not v99.HolyBlade:IsAvailable())) or ((1691 - (298 + 938)) == (4864 - (233 + 1026)))) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((4329 - (636 + 1030)) == (1694 + 1618))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((4178 + 99) <= (1330 + 3145)) and ((v16:HealthPercentage() <= (2 + 18)) or v14:BuffUp(v99.AvengingWrathBuff) or v14:BuffUp(v99.CrusadeBuff) or v14:BuffUp(v99.EmpyreanPowerBuff))) then
					v29 = v121();
					if (v29 or ((1091 - (55 + 166)) == (231 + 958))) then
						return v29;
					end
				end
				if (((157 + 1396) <= (11964 - 8831)) and v99.Consecration:IsCastable() and v37 and v16:DebuffDown(v99.ConsecrationDebuff) and (v105 >= (299 - (36 + 261)))) then
					if (v24(v99.Consecration, not v16:IsInRange(17 - 7)) or ((3605 - (34 + 1334)) >= (1350 + 2161))) then
						return "consecration generators 22";
					end
				end
				v135 = 4 + 1;
			end
			if ((v135 == (1291 - (1035 + 248))) or ((1345 - (20 + 1)) > (1574 + 1446))) then
				if ((v99.ArcaneTorrent:IsCastable() and ((v89 and v32) or not v89) and v88 and (v109 < (324 - (134 + 185))) and (v85 < v107)) or ((4125 - (549 + 584)) == (2566 - (314 + 371)))) then
					if (((10662 - 7556) > (2494 - (478 + 490))) and v24(v99.ArcaneTorrent, not v16:IsInRange(6 + 4))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((4195 - (786 + 386)) < (12534 - 8664)) and v99.Consecration:IsCastable() and v37) then
					if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and v24(v99.Consecration, not v16:IsInRange(9 + 1))) then
						return "consecration generators 30";
					end
				end
				if (((2 + 16) < (8385 - 6273)) and v99.DivineHammer:IsCastable() and v39) then
					if (((3722 - 2625) <= (4632 - 3004)) and v24(v99.DivineHammer, not v16:IsInRange(25 - 15))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((1648 + 2982) == (17836 - 13206)) and ((0 - 0) == v135)) then
				if (((2670 + 870) > (6861 - 4178)) and ((v109 >= (693 - (364 + 324))) or (v14:BuffUp(v99.EchoesofWrathBuff) and v14:HasTier(84 - 53, 9 - 5) and v99.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v99.JudgmentDebuff) or (v109 == (2 + 2))) and v14:BuffUp(v99.DivineResonanceBuff) and not v14:HasTier(129 - 98, 2 - 0)))) then
					local v195 = 0 - 0;
					while true do
						if (((6062 - (1249 + 19)) >= (2957 + 318)) and (v195 == (0 - 0))) then
							v29 = v121();
							if (((2570 - (686 + 400)) == (1165 + 319)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((1661 - (73 + 156)) < (17 + 3538)) and v99.BladeofJustice:IsCastable() and v36 and not v16:DebuffUp(v99.ExpurgationDebuff) and (v109 <= (814 - (721 + 90))) and v14:HasTier(1 + 30, 6 - 4)) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((1535 - (224 + 246)) > (5795 - 2217))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v99.WakeofAshes:IsCastable() and v48 and (v109 <= (3 - 1)) and ((v99.AvengingWrath:CooldownRemains() > (0 + 0)) or (v99.Crusade:CooldownRemains() > (0 + 0)) or not v99.Crusade:IsAvailable() or not v99.AvengingWrath:IsReady()) and (not v99.ExecutionSentence:IsAvailable() or (v99.ExecutionSentence:CooldownRemains() > (3 + 1)) or (v107 < (15 - 7)) or not v99.ExecutionSentence:IsReady())) or ((15956 - 11161) < (1920 - (203 + 310)))) then
					if (((3846 - (1238 + 755)) < (337 + 4476)) and v24(v99.WakeofAshes, not v16:IsInRange(1544 - (709 + 825)))) then
						return "wake_of_ashes generators 2";
					end
				end
				v135 = 1 - 0;
			end
			if (((2 - 0) == v135) or ((3685 - (196 + 668)) < (9598 - 7167))) then
				if (((v109 >= (5 - 2)) and v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (843 - (171 + 662)))) or ((2967 - (4 + 89)) < (7644 - 5463))) then
					v29 = v121();
					if (v29 or ((980 + 1709) <= (1506 - 1163))) then
						return v29;
					end
				end
				if ((v99.TemplarSlash:IsReady() and v46 and ((v99.TemplarStrike:TimeSinceLastCast() + v110) < (2 + 2)) and (v105 >= (1488 - (35 + 1451)))) or ((3322 - (28 + 1425)) == (4002 - (941 + 1052)))) then
					if (v24(v99.TemplarSlash, not v16:IsInRange(10 + 0)) or ((5060 - (822 + 692)) < (3314 - 992))) then
						return "templar_slash generators 8";
					end
				end
				if ((v99.BladeofJustice:IsCastable() and v36 and ((v109 <= (2 + 1)) or not v99.HolyBlade:IsAvailable()) and (((v105 >= (299 - (45 + 252))) and not v99.CrusadingStrikes:IsAvailable()) or (v105 >= (4 + 0)))) or ((717 + 1365) == (11616 - 6843))) then
					if (((3677 - (114 + 319)) > (1514 - 459)) and v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v135 = 3 - 0;
			end
			if ((v135 == (5 + 2)) or ((4935 - 1622) <= (3725 - 1947))) then
				if ((v99.Judgment:IsReady() and v44 and ((v109 <= (1966 - (556 + 1407))) or not v99.BoundlessJudgment:IsAvailable())) or ((2627 - (741 + 465)) >= (2569 - (170 + 295)))) then
					if (((955 + 857) <= (2985 + 264)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment generators 32";
					end
				end
				if (((3995 - 2372) <= (1623 + 334)) and v99.HammerofWrath:IsReady() and v43 and ((v109 <= (2 + 1)) or (v16:HealthPercentage() > (12 + 8)) or not v99.VanguardsMomentum:IsAvailable())) then
					if (((5642 - (957 + 273)) == (1181 + 3231)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((701 + 1049) >= (3208 - 2366)) and v99.CrusaderStrike:IsCastable() and v38) then
					if (((11521 - 7149) > (5650 - 3800)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v135 = 39 - 31;
			end
			if (((2012 - (389 + 1391)) < (516 + 305)) and (v135 == (1 + 4))) then
				if (((1179 - 661) < (1853 - (783 + 168))) and v99.DivineHammer:IsCastable() and v39 and (v105 >= (6 - 4))) then
					if (((2945 + 49) > (1169 - (309 + 2))) and v24(v99.DivineHammer, not v16:IsInRange(30 - 20))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v99.CrusaderStrike:IsCastable() and v38 and (v99.CrusaderStrike:ChargesFractional() >= (1213.75 - (1090 + 122))) and ((v109 <= (1 + 1)) or ((v109 <= (9 - 6)) and (v99.BladeofJustice:CooldownRemains() > (v110 * (2 + 0)))) or ((v109 == (1122 - (628 + 490))) and (v99.BladeofJustice:CooldownRemains() > (v110 * (1 + 1))) and (v99.Judgment:CooldownRemains() > (v110 * (4 - 2)))))) or ((17160 - 13405) <= (1689 - (431 + 343)))) then
					if (((7969 - 4023) > (10828 - 7085)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v29 = v121();
				v135 = 5 + 1;
			end
			if ((v135 == (1 + 0)) or ((3030 - (556 + 1139)) >= (3321 - (6 + 9)))) then
				if (((887 + 3957) > (1155 + 1098)) and v99.BladeofJustice:IsCastable() and v36 and not v16:DebuffUp(v99.ExpurgationDebuff) and (v109 <= (172 - (28 + 141))) and v14:HasTier(13 + 18, 2 - 0)) then
					if (((321 + 131) == (1769 - (486 + 831))) and v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				if ((v99.DivineToll:IsCastable() and v41 and (v109 <= (5 - 3)) and ((v99.AvengingWrath:CooldownRemains() > (52 - 37)) or (v99.Crusade:CooldownRemains() > (3 + 12)) or (v107 < (25 - 17)))) or ((5820 - (668 + 595)) < (1878 + 209))) then
					if (((782 + 3092) == (10564 - 6690)) and v24(v99.DivineToll, not v16:IsInRange(320 - (23 + 267)))) then
						return "divine_toll generators 6";
					end
				end
				if ((v99.Judgment:IsReady() and v44 and v16:DebuffUp(v99.ExpurgationDebuff) and v14:BuffDown(v99.EchoesofWrathBuff) and v14:HasTier(1975 - (1129 + 815), 389 - (371 + 16))) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((15548 - 11293) < (3541 - (88 + 30)))) then
						return "judgment generators 7";
					end
				end
				v135 = 773 - (720 + 51);
			end
		end
	end
	local function v123()
		v34 = EpicSettings.Settings['swapAuras'];
		v35 = EpicSettings.Settings['useWeapon'];
		v36 = EpicSettings.Settings['useBladeofJustice'];
		v37 = EpicSettings.Settings['useConsecration'];
		v38 = EpicSettings.Settings['useCrusaderStrike'];
		v39 = EpicSettings.Settings['useDivineHammer'];
		v40 = EpicSettings.Settings['useDivineStorm'];
		v41 = EpicSettings.Settings['useDivineToll'];
		v42 = EpicSettings.Settings['useExecutionSentence'];
		v43 = EpicSettings.Settings['useHammerofWrath'];
		v44 = EpicSettings.Settings['useJudgment'];
		v45 = EpicSettings.Settings['useJusticarsVengeance'];
		v46 = EpicSettings.Settings['useTemplarSlash'];
		v47 = EpicSettings.Settings['useTemplarStrike'];
		v48 = EpicSettings.Settings['useWakeofAshes'];
		v49 = EpicSettings.Settings['useVerdict'];
		v50 = EpicSettings.Settings['useAvengingWrath'];
		v51 = EpicSettings.Settings['useCrusade'];
		v52 = EpicSettings.Settings['useFinalReckoning'];
		v53 = EpicSettings.Settings['useShieldofVengeance'];
		v54 = EpicSettings.Settings['avengingWrathWithCD'];
		v55 = EpicSettings.Settings['crusadeWithCD'];
		v56 = EpicSettings.Settings['finalReckoningWithCD'];
		v57 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v124()
		v58 = EpicSettings.Settings['useRebuke'];
		v59 = EpicSettings.Settings['useHammerofJustice'];
		v60 = EpicSettings.Settings['useDivineProtection'];
		v61 = EpicSettings.Settings['useDivineShield'];
		v62 = EpicSettings.Settings['useLayonHands'];
		v63 = EpicSettings.Settings['useLayonHandsFocus'];
		v64 = EpicSettings.Settings['useWordofGloryFocus'];
		v65 = EpicSettings.Settings['useWordofGloryMouseover'];
		v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v68 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
		v69 = EpicSettings.Settings['divineShieldHP'] or (1776 - (421 + 1355));
		v70 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
		v71 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
		v72 = EpicSettings.Settings['wordofGloryFocusHP'] or (1083 - (286 + 797));
		v73 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
		v74 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
		v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (439 - (397 + 42));
		v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v97 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v125()
		v85 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v82 = EpicSettings.Settings['InterruptWithStun'];
		v83 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v84 = EpicSettings.Settings['InterruptThreshold'];
		v79 = EpicSettings.Settings['DispelDebuffs'];
		v78 = EpicSettings.Settings['DispelBuffs'];
		v86 = EpicSettings.Settings['useTrinkets'];
		v88 = EpicSettings.Settings['useRacials'];
		v87 = EpicSettings.Settings['trinketsWithCD'];
		v89 = EpicSettings.Settings['racialsWithCD'];
		v91 = EpicSettings.Settings['useHealthstone'];
		v90 = EpicSettings.Settings['useHealingPotion'];
		v93 = EpicSettings.Settings['healthstoneHP'] or (800 - (24 + 776));
		v92 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v94 = EpicSettings.Settings['HealingPotionName'] or "";
		v80 = EpicSettings.Settings['handleAfflicted'];
		v81 = EpicSettings.Settings['HandleIncorporeal'];
		v95 = EpicSettings.Settings['HealOOC'];
		v96 = EpicSettings.Settings['HealOOCHP'] or (785 - (222 + 563));
	end
	local function v126()
		local v186 = 0 - 0;
		while true do
			if (((1047 + 407) <= (2681 - (23 + 167))) and (v186 == (1800 - (690 + 1108)))) then
				v104 = v14:GetEnemiesInMeleeRange(3 + 5);
				if (v31 or ((3429 + 728) <= (3651 - (40 + 808)))) then
					v105 = #v104;
				else
					local v196 = 0 + 0;
					while true do
						if (((18557 - 13704) >= (2851 + 131)) and (v196 == (0 + 0))) then
							v104 = {};
							v105 = 1 + 0;
							break;
						end
					end
				end
				if (((4705 - (47 + 524)) > (2179 + 1178)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v34) or ((9340 - 5923) < (3788 - 1254))) then
						if (v24(v99.CrusaderAura) or ((6207 - 3485) <= (1890 - (1165 + 561)))) then
							return "crusader_aura";
						end
					end
				end
				v108 = v112();
				v186 = 1 + 2;
			end
			if ((v186 == (3 - 2)) or ((919 + 1489) < (2588 - (341 + 138)))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((9 + 24) == (3002 - 1547))) then
					return v29;
				end
				v186 = 328 - (89 + 237);
			end
			if ((v186 == (16 - 11)) or ((932 - 489) >= (4896 - (581 + 300)))) then
				if (((4602 - (855 + 365)) > (393 - 227)) and v81) then
					local v197 = 0 + 0;
					while true do
						if ((v197 == (1235 - (1030 + 205))) or ((263 + 17) == (2846 + 213))) then
							v29 = v98.HandleIncorporeal(v99.Repentance, v103.RepentanceMouseOver, 316 - (156 + 130), true);
							if (((4273 - 2392) > (2179 - 886)) and v29) then
								return v29;
							end
							v197 = 1 - 0;
						end
						if (((622 + 1735) == (1375 + 982)) and (v197 == (70 - (10 + 59)))) then
							v29 = v98.HandleIncorporeal(v99.TurnEvil, v103.TurnEvilMouseOver, 9 + 21, true);
							if (((605 - 482) == (1286 - (671 + 492))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v116();
				if (v29 or ((841 + 215) >= (4607 - (369 + 846)))) then
					return v29;
				end
				if ((v79 and v33) or ((287 + 794) < (918 + 157))) then
					local v198 = 1945 - (1036 + 909);
					while true do
						if ((v198 == (0 + 0)) or ((1760 - 711) >= (4635 - (11 + 192)))) then
							if (v13 or ((2410 + 2358) <= (1021 - (135 + 40)))) then
								local v204 = 0 - 0;
								while true do
									if ((v204 == (0 + 0)) or ((7397 - 4039) <= (2128 - 708))) then
										v29 = v115();
										if (v29 or ((3915 - (50 + 126)) <= (8367 - 5362))) then
											return v29;
										end
										break;
									end
								end
							end
							if ((v15 and v15:Exists() and v15:IsAPlayer() and (v98.UnitHasCurseDebuff(v15) or v98.UnitHasPoisonDebuff(v15))) or ((368 + 1291) >= (3547 - (1233 + 180)))) then
								if (v99.CleanseToxins:IsReady() or ((4229 - (522 + 447)) < (3776 - (107 + 1314)))) then
									if (v24(v103.CleanseToxinsMouseover) or ((311 + 358) == (12867 - 8644))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v186 = 3 + 3;
			end
			if ((v186 == (11 - 5)) or ((6694 - 5002) < (2498 - (716 + 1194)))) then
				v29 = v117();
				if (v29 or ((82 + 4715) < (392 + 3259))) then
					return v29;
				end
				if ((not v14:AffectingCombat() and v30 and v98.TargetIsValid()) or ((4680 - (74 + 429)) > (9356 - 4506))) then
					local v199 = 0 + 0;
					while true do
						if ((v199 == (0 - 0)) or ((283 + 117) > (3425 - 2314))) then
							v29 = v119();
							if (((7543 - 4492) > (1438 - (279 + 154))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((4471 - (454 + 324)) <= (3448 + 934)) and v14:AffectingCombat() and v98.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v200 = 17 - (12 + 5);
					while true do
						if ((v200 == (0 + 0)) or ((8362 - 5080) > (1516 + 2584))) then
							if ((v62 and (v14:HealthPercentage() <= v70) and v99.LayonHands:IsReady() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((4673 - (277 + 816)) < (12152 - 9308))) then
								if (((1272 - (1058 + 125)) < (842 + 3648)) and v24(v99.LayonHands)) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v61 and (v14:HealthPercentage() <= v69) and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((5958 - (815 + 160)) < (7757 - 5949))) then
								if (((9089 - 5260) > (900 + 2869)) and v24(v99.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v200 = 2 - 1;
						end
						if (((3383 - (41 + 1857)) <= (4797 - (1222 + 671))) and (v200 == (5 - 3))) then
							if (((6135 - 1866) == (5451 - (229 + 953))) and v90 and (v14:HealthPercentage() <= v92)) then
								if (((2161 - (1111 + 663)) <= (4361 - (874 + 705))) and (v94 == "Refreshing Healing Potion")) then
									if (v100.RefreshingHealingPotion:IsReady() or ((266 + 1633) <= (626 + 291))) then
										if (v24(v103.RefreshingHealingPotion) or ((8962 - 4650) <= (25 + 851))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if (((2911 - (642 + 37)) <= (592 + 2004)) and (v94 == "Dreamwalker's Healing Potion")) then
									if (((336 + 1759) < (9254 - 5568)) and v100.DreamwalkersHealingPotion:IsReady()) then
										if (v24(v103.RefreshingHealingPotion) or ((2049 - (233 + 221)) >= (10345 - 5871))) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
							end
							if ((v85 < v107) or ((4066 + 553) < (4423 - (718 + 823)))) then
								local v205 = 0 + 0;
								while true do
									if (((805 - (266 + 539)) == v205) or ((832 - 538) >= (6056 - (636 + 589)))) then
										v29 = v120();
										if (((4815 - 2786) <= (6360 - 3276)) and v29) then
											return v29;
										end
										v205 = 1 + 0;
									end
									if ((v205 == (1 + 0)) or ((3052 - (657 + 358)) == (6407 - 3987))) then
										if (((10156 - 5698) > (5091 - (1151 + 36))) and v32 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v35) then
											if (((422 + 14) >= (33 + 90)) and v24(v103.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							v200 = 8 - 5;
						end
						if (((2332 - (1552 + 280)) < (2650 - (64 + 770))) and ((1 + 0) == v200)) then
							if (((8112 - 4538) == (635 + 2939)) and v60 and v99.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v68)) then
								if (((1464 - (157 + 1086)) < (780 - 390)) and v24(v99.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if ((v100.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or ((9692 - 7479) <= (2179 - 758))) then
								if (((4173 - 1115) < (5679 - (599 + 220))) and v24(v103.Healthstone)) then
									return "healthstone defensive";
								end
							end
							v200 = 3 - 1;
						end
						if ((v200 == (1934 - (1813 + 118))) or ((948 + 348) >= (5663 - (841 + 376)))) then
							v29 = v122();
							if (v29 or ((1951 - 558) > (1043 + 3446))) then
								return v29;
							end
							v200 = 10 - 6;
						end
						if ((v200 == (863 - (464 + 395))) or ((11353 - 6929) < (13 + 14))) then
							if (v24(v99.Pool) or ((2834 - (467 + 370)) > (7883 - 4068))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if (((2544 + 921) > (6557 - 4644)) and (v186 == (0 + 0))) then
				v124();
				v123();
				v125();
				v30 = EpicSettings.Toggles['ooc'];
				v186 = 2 - 1;
			end
			if (((1253 - (150 + 370)) < (3101 - (74 + 1208))) and (v186 == (9 - 5))) then
				if (v14:AffectingCombat() or (v79 and v99.CleanseToxins:IsAvailable()) or ((20843 - 16448) == (3384 + 1371))) then
					local v201 = v79 and v99.CleanseToxins:IsReady() and v33;
					v29 = v98.FocusUnit(v201, nil, 410 - (14 + 376), nil, 43 - 18, v99.FlashofLight);
					if (v29 or ((2455 + 1338) < (2082 + 287))) then
						return v29;
					end
				end
				if (v33 or ((3895 + 189) == (776 - 511))) then
					v29 = v98.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 31 + 9, 103 - (23 + 55), v99.FlashofLight);
					if (((10328 - 5970) == (2909 + 1449)) and v29) then
						return v29;
					end
					if ((v99.BlessingofFreedom:IsReady() and v98.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((2818 + 320) < (1539 - 546))) then
						if (((1048 + 2282) > (3224 - (652 + 249))) and v24(v103.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (v98.TargetIsValid() or v14:AffectingCombat() or ((9703 - 6077) == (5857 - (708 + 1160)))) then
					v106 = v9.BossFightRemains(nil, true);
					v107 = v106;
					if ((v107 == (30160 - 19049)) or ((1669 - 753) == (2698 - (10 + 17)))) then
						v107 = v9.FightRemains(v104, false);
					end
					v110 = v14:GCD();
					v109 = v14:HolyPower();
				end
				if (((62 + 210) == (2004 - (1400 + 332))) and v80) then
					if (((8149 - 3900) <= (6747 - (242 + 1666))) and v76) then
						local v202 = 0 + 0;
						while true do
							if (((1018 + 1759) < (2728 + 472)) and ((940 - (850 + 90)) == v202)) then
								v29 = v98.HandleAfflicted(v99.CleanseToxins, v103.CleanseToxinsMouseover, 70 - 30);
								if (((1485 - (360 + 1030)) < (1732 + 225)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (((2330 - 1504) < (2362 - 645)) and v77 and (v109 > (1663 - (909 + 752)))) then
						local v203 = 1223 - (109 + 1114);
						while true do
							if (((2610 - 1184) >= (431 + 674)) and (v203 == (242 - (6 + 236)))) then
								v29 = v98.HandleAfflicted(v99.WordofGlory, v103.WordofGloryMouseover, 26 + 14, true);
								if (((2217 + 537) <= (7968 - 4589)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
				end
				v186 = 8 - 3;
			end
			if ((v186 == (1136 - (1076 + 57))) or ((646 + 3281) == (2102 - (579 + 110)))) then
				if (not v14:AffectingCombat() or ((92 + 1062) <= (697 + 91))) then
					if ((v99.RetributionAura:IsCastable() and (v113()) and v34) or ((872 + 771) > (3786 - (174 + 233)))) then
						if (v24(v99.RetributionAura) or ((7829 - 5026) > (7983 - 3434))) then
							return "retribution_aura";
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((98 + 122) >= (4196 - (663 + 511)))) then
					if (((2518 + 304) == (613 + 2209)) and v14:AffectingCombat()) then
						if (v99.Intercession:IsCastable() or ((3270 - 2209) == (1125 + 732))) then
							if (((6497 - 3737) > (3301 - 1937)) and v24(v99.Intercession, not v16:IsInRange(15 + 15), true)) then
								return "intercession target";
							end
						end
					elseif (v99.Redemption:IsCastable() or ((9540 - 4638) <= (2563 + 1032))) then
						if (v24(v99.Redemption, not v16:IsInRange(3 + 27), true) or ((4574 - (478 + 244)) == (810 - (440 + 77)))) then
							return "redemption target";
						end
					end
				end
				if ((v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((709 + 850) == (16792 - 12204))) then
					if (v24(v103.RedemptionMouseover) or ((6040 - (655 + 901)) == (147 + 641))) then
						return "redemption mouseover";
					end
				end
				if (((3498 + 1070) >= (2639 + 1268)) and v14:AffectingCombat()) then
					if (((5019 - 3773) < (4915 - (695 + 750))) and v99.Intercession:IsCastable() and (v14:HolyPower() >= (9 - 6)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (((6277 - 2209) >= (3909 - 2937)) and v24(v103.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				v186 = 355 - (285 + 66);
			end
		end
	end
	local function v127()
		local v187 = 0 - 0;
		while true do
			if (((1803 - (682 + 628)) < (628 + 3265)) and (v187 == (299 - (176 + 123)))) then
				v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v102();
				break;
			end
		end
	end
	v20.SetAPL(30 + 40, v126, v127);
end;
return v0["Epix_Paladin_Retribution.lua"]();

