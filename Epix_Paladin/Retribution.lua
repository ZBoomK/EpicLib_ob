local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((5904 - (157 + 1234)) < (5663 - 2311))) then
			return v6(...);
		end
		if ((v5 == (1555 - (991 + 564))) or ((1351 + 714) >= (4755 - (1381 + 178)))) then
			v6 = v0[v4];
			if (not v6 or ((4105 + 271) <= (1195 + 286))) then
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
	local v95 = v21.Commons.Everyone;
	local v96 = v19.Paladin.Retribution;
	local v97 = v20.Paladin.Retribution;
	local v98 = {};
	local function v99()
		if (v96.CleanseToxins:IsAvailable() or ((11693 - 8301) >= (2457 + 2284))) then
			v95.DispellableDebuffs = v13.MergeTable(v95.DispellableDiseaseDebuffs, v95.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v99();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v100 = v24.Paladin.Retribution;
	local v101;
	local v102;
	local v103 = 11581 - (381 + 89);
	local v104 = 9854 + 1257;
	local v105;
	local v106 = 0 + 0;
	local v107 = 0 - 0;
	local v108;
	v10:RegisterForEvent(function()
		local v124 = 1156 - (1074 + 82);
		while true do
			if (((7286 - 3961) >= (3938 - (214 + 1570))) and (v124 == (1455 - (990 + 465)))) then
				v103 = 4581 + 6530;
				v104 = 4835 + 6276;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v109()
		local v125 = 0 + 0;
		local v126;
		local v127;
		while true do
			if ((v125 == (3 - 2)) or ((3021 - (1668 + 58)) >= (3859 - (512 + 114)))) then
				if (((11411 - 7034) > (3394 - 1752)) and (v126 > v127)) then
					return v126;
				end
				return v127;
			end
			if (((16434 - 11711) > (631 + 725)) and (v125 == (0 + 0))) then
				v126 = v15:GCDRemains();
				v127 = v28(v96.CrusaderStrike:CooldownRemains(), v96.BladeofJustice:CooldownRemains(), v96.Judgment:CooldownRemains(), (v96.HammerofWrath:IsUsable() and v96.HammerofWrath:CooldownRemains()) or (9 + 1), v96.WakeofAshes:CooldownRemains());
				v125 = 3 - 2;
			end
		end
	end
	local function v110()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v111()
		if ((v96.CleanseToxins:IsReady() and v34 and v95.DispellableFriendlyUnit(2019 - (109 + 1885))) or ((5605 - (1269 + 200)) <= (6579 - 3146))) then
			if (((5060 - (98 + 717)) <= (5457 - (802 + 24))) and v25(v100.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v112()
		if (((7373 - 3097) >= (4942 - 1028)) and v92 and (v15:HealthPercentage() <= v93)) then
			if (((30 + 168) <= (3354 + 1011)) and v96.FlashofLight:IsReady()) then
				if (((786 + 3996) > (1009 + 3667)) and v25(v96.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v113()
		if (((13531 - 8667) > (7326 - 5129)) and (not v14 or not v14:Exists() or not v14:IsInRange(11 + 19))) then
			return;
		end
		if (v14 or ((1507 + 2193) == (2068 + 439))) then
			local v154 = 0 + 0;
			while true do
				if (((2089 + 2385) >= (1707 - (797 + 636))) and (v154 == (4 - 3))) then
					if ((v96.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v72)) or ((3513 - (1427 + 192)) <= (488 + 918))) then
						if (((3649 - 2077) >= (1377 + 154)) and v25(v100.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v96.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) or ((2125 + 2562) < (4868 - (192 + 134)))) then
						if (((4567 - (316 + 960)) > (928 + 739)) and v25(v100.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if ((v154 == (0 + 0)) or ((807 + 66) == (7775 - 5741))) then
					if ((v96.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v70)) or ((3367 - (83 + 468)) < (1817 - (1202 + 604)))) then
						if (((17267 - 13568) < (7831 - 3125)) and v25(v100.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((7326 - 4680) >= (1201 - (45 + 280))) and v96.LayonHands:IsCastable() and v62 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v69)) then
						if (((593 + 21) <= (2782 + 402)) and v25(v100.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					v154 = 1 + 0;
				end
			end
		end
	end
	local function v114()
		v30 = v95.HandleTopTrinket(v98, v33, 23 + 17, nil);
		if (((550 + 2576) == (5788 - 2662)) and v30) then
			return v30;
		end
		v30 = v95.HandleBottomTrinket(v98, v33, 1951 - (340 + 1571), nil);
		if (v30 or ((863 + 1324) >= (6726 - (1733 + 39)))) then
			return v30;
		end
	end
	local function v115()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (1037 - (125 + 909))) or ((5825 - (1096 + 852)) == (1604 + 1971))) then
				if (((1009 - 302) > (613 + 19)) and v96.HammerofWrath:IsReady() and v42) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((1058 - (409 + 103)) >= (2920 - (46 + 190)))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if (((1560 - (51 + 44)) <= (1214 + 3087)) and v96.CrusaderStrike:IsCastable() and v37) then
					if (((3021 - (1114 + 203)) > (2151 - (228 + 498))) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v128 == (1 + 0)) or ((380 + 307) == (4897 - (174 + 489)))) then
				if ((v96.FinalVerdict:IsAvailable() and v96.FinalVerdict:IsReady() and v48 and (v106 >= (10 - 6))) or ((5235 - (830 + 1075)) < (1953 - (303 + 221)))) then
					if (((2416 - (231 + 1038)) >= (280 + 55)) and v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				if (((4597 - (171 + 991)) > (8642 - 6545)) and v96.TemplarsVerdict:IsReady() and v48 and (v106 >= (10 - 6))) then
					if (v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict)) or ((9407 - 5637) >= (3235 + 806))) then
						return "templars verdict precombat 4";
					end
				end
				v128 = 6 - 4;
			end
			if (((0 - 0) == v128) or ((6110 - 2319) <= (4979 - 3368))) then
				if ((v96.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) or ((5826 - (111 + 1137)) <= (2166 - (91 + 67)))) then
					if (((3348 - 2223) <= (518 + 1558)) and v25(v96.ShieldofVengeance)) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v96.JusticarsVengeance:IsAvailable() and v96.JusticarsVengeance:IsReady() and v44 and (v106 >= (527 - (423 + 100)))) or ((6 + 737) >= (12179 - 7780))) then
					if (((603 + 552) < (2444 - (326 + 445))) and v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v128 = 4 - 3;
			end
			if (((4 - 2) == v128) or ((5424 - 3100) <= (1289 - (530 + 181)))) then
				if (((4648 - (614 + 267)) == (3799 - (19 + 13))) and v96.BladeofJustice:IsCastable() and v35) then
					if (((6654 - 2565) == (9528 - 5439)) and v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				if (((12734 - 8276) >= (435 + 1239)) and v96.Judgment:IsCastable() and v43) then
					if (((1708 - 736) <= (2940 - 1522)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment precombat 6";
					end
				end
				v128 = 1815 - (1293 + 519);
			end
		end
	end
	local function v116()
		local v129 = 0 - 0;
		local v130;
		while true do
			if (((2 - 1) == v129) or ((9442 - 4504) < (20534 - 15772))) then
				if ((v96.LightsJudgment:IsCastable() and v85 and ((v86 and v33) or not v86)) or ((5898 - 3394) > (2259 + 2005))) then
					if (((440 + 1713) == (5001 - 2848)) and v25(v96.LightsJudgment, not v17:IsInRange(10 + 30))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v96.Fireblood:IsCastable() and v85 and ((v86 and v33) or not v86) and (v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) == (4 + 6))))) or ((317 + 190) >= (3687 - (709 + 387)))) then
					if (((6339 - (673 + 1185)) == (12995 - 8514)) and v25(v96.Fireblood, not v17:IsInRange(32 - 22))) then
						return "fireblood cooldowns 6";
					end
				end
				v129 = 2 - 0;
			end
			if ((v129 == (2 + 0)) or ((1740 + 588) < (934 - 241))) then
				if (((1063 + 3265) == (8629 - 4301)) and v83 and ((v33 and v84) or not v84) and v17:IsInRange(15 - 7)) then
					local v198 = 1880 - (446 + 1434);
					while true do
						if (((2871 - (1040 + 243)) >= (3975 - 2643)) and (v198 == (1847 - (559 + 1288)))) then
							v30 = v114();
							if (v30 or ((6105 - (609 + 1322)) > (4702 - (13 + 441)))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v96.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v104 > (55 - 40)) and (not v96.ExecutionSentence:IsAvailable() or v17:DebuffDown(v96.ExecutionSentence))) or ((12012 - 7426) <= (408 - 326))) then
					if (((144 + 3719) == (14029 - 10166)) and v25(v96.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v129 = 2 + 1;
			end
			if ((v129 == (2 + 1)) or ((836 - 554) <= (23 + 19))) then
				if (((8476 - 3867) >= (507 + 259)) and v96.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v96.CrusadeBuff) and (v96.Crusade:CooldownRemains() > (9 + 6))) or (v15:BuffStack(v96.CrusadeBuff) == (8 + 2)) or (v96.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v96.AvengingWrath:CooldownRemains() > (15 + 0))) and (((v106 >= (437 - (153 + 280))) and (v10.CombatTime() < (14 - 9))) or ((v106 >= (3 + 0)) and (v10.CombatTime() > (2 + 3))) or ((v106 >= (2 + 0)) and v96.DivineAuxiliary:IsAvailable())) and (((v104 > (8 + 0)) and not v96.ExecutionersWill:IsAvailable()) or (v104 > (9 + 3)))) then
					if (v25(v96.ExecutionSentence, not v17:IsSpellInRange(v96.ExecutionSentence)) or ((1753 - 601) == (1538 + 950))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((4089 - (89 + 578)) > (2394 + 956)) and v96.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v106 >= (8 - 4)) and (v10.CombatTime() < (1054 - (572 + 477)))) or ((v106 >= (1 + 2)) and (v10.CombatTime() > (4 + 1))) or ((v106 >= (1 + 1)) and v96.DivineAuxiliary:IsAvailable() and (v96.ExecutionSentence:CooldownUp() or v96.FinalReckoning:CooldownUp())))) then
					if (((963 - (84 + 2)) > (619 - 243)) and v25(v96.AvengingWrath, not v17:IsInRange(8 + 2))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v129 = 846 - (497 + 345);
			end
			if (((0 + 0) == v129) or ((528 + 2590) <= (3184 - (605 + 728)))) then
				v130 = v95.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15.BuffStack(v96.Crusade) == (8 + 2))) or (v104 < (55 - 30)));
				if (v130 or ((8 + 157) >= (12910 - 9418))) then
					return v130;
				end
				v129 = 1 + 0;
			end
			if (((10940 - 6991) < (3667 + 1189)) and (v129 == (493 - (457 + 32)))) then
				if ((v96.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v106 >= (2 + 2)) and (v10.CombatTime() < (1407 - (832 + 570)))) or ((v106 >= (3 + 0)) and (v10.CombatTime() >= (2 + 3))))) or ((15131 - 10855) < (1453 + 1563))) then
					if (((5486 - (588 + 208)) > (11117 - 6992)) and v25(v96.Crusade, not v17:IsInRange(1810 - (884 + 916)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v96.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v106 >= (8 - 4)) and (v10.CombatTime() < (5 + 3))) or ((v106 >= (656 - (232 + 421))) and (v10.CombatTime() >= (1897 - (1569 + 320)))) or ((v106 >= (1 + 1)) and v96.DivineAuxiliary:IsAvailable())) and ((v96.AvengingWrath:CooldownRemains() > (2 + 8)) or (v96.Crusade:CooldownDown() and (v15:BuffDown(v96.CrusadeBuff) or (v15:BuffStack(v96.CrusadeBuff) >= (33 - 23))))) and ((v105 > (605 - (316 + 289))) or (v106 == (13 - 8)) or ((v106 >= (1 + 1)) and v96.DivineAuxiliary:IsAvailable()))) or ((1503 - (666 + 787)) >= (1321 - (360 + 65)))) then
					local v199 = 0 + 0;
					while true do
						if ((v199 == (254 - (79 + 175))) or ((2702 - 988) >= (2309 + 649))) then
							if ((v94 == "player") or ((4570 - 3079) < (1239 - 595))) then
								if (((1603 - (503 + 396)) < (1168 - (92 + 89))) and v25(v100.FinalReckoningPlayer, not v17:IsInRange(19 - 9))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if (((1907 + 1811) > (1129 + 777)) and (v94 == "cursor")) then
								if (v25(v100.FinalReckoningCursor, not v17:IsInRange(78 - 58)) or ((132 + 826) > (8288 - 4653))) then
									return "final_reckoning cooldowns 18";
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
	local function v117()
		v108 = ((v102 >= (3 + 0)) or ((v102 >= (1 + 1)) and not v96.DivineArbiter:IsAvailable()) or v15:BuffUp(v96.EmpyreanPowerBuff)) and v15:BuffDown(v96.EmpyreanLegacyBuff) and not (v15:BuffUp(v96.DivineArbiterBuff) and (v15:BuffStack(v96.DivineArbiterBuff) > (73 - 49)));
		if (((437 + 3064) <= (6849 - 2357)) and v96.DivineStorm:IsReady() and v39 and v108 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (1247 - (485 + 759)))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (23 - 13))))) then
			if (v25(v96.DivineStorm, not v17:IsInRange(1199 - (442 + 747))) or ((4577 - (832 + 303)) < (3494 - (88 + 858)))) then
				return "divine_storm finishers 2";
			end
		end
		if (((877 + 1998) >= (1212 + 252)) and v96.JusticarsVengeance:IsReady() and v44 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (1 + 2))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (799 - (766 + 23)))))) then
			if (v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance)) or ((23681 - 18884) >= (6691 - 1798))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v96.FinalVerdict:IsAvailable() and v96.FinalVerdict:IsCastable() and v48 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (7 - 4))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (33 - 23))))) or ((1624 - (1036 + 37)) > (1467 + 601))) then
			if (((4116 - 2002) > (743 + 201)) and v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if ((v96.TemplarsVerdict:IsReady() and v48 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (1483 - (641 + 839)))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (923 - (910 + 3)))))) or ((5766 - 3504) >= (4780 - (1466 + 218)))) then
			if (v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict)) or ((1037 + 1218) >= (4685 - (556 + 592)))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v118()
		if ((v106 >= (2 + 3)) or (v15:BuffUp(v96.EchoesofWrathBuff) and v15:HasTier(839 - (329 + 479), 858 - (174 + 680)) and v96.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v96.JudgmentDebuff) or (v106 == (13 - 9))) and v15:BuffUp(v96.DivineResonanceBuff) and not v15:HasTier(64 - 33, 2 + 0)) or ((4576 - (396 + 343)) < (116 + 1190))) then
			local v155 = 1477 - (29 + 1448);
			while true do
				if (((4339 - (135 + 1254)) == (11113 - 8163)) and (v155 == (0 - 0))) then
					v30 = v117();
					if (v30 or ((3148 + 1575) < (4825 - (389 + 1138)))) then
						return v30;
					end
					break;
				end
			end
		end
		if (((1710 - (102 + 472)) >= (146 + 8)) and v96.WakeofAshes:IsCastable() and v47 and (v106 <= (2 + 0)) and (v96.AvengingWrath:CooldownDown() or v96.Crusade:CooldownDown()) and (not v96.ExecutionSentence:IsAvailable() or (v96.ExecutionSentence:CooldownRemains() > (4 + 0)) or (v104 < (1553 - (320 + 1225))))) then
			if (v25(v96.WakeofAshes, not v17:IsInRange(17 - 7)) or ((166 + 105) > (6212 - (157 + 1307)))) then
				return "wake_of_ashes generators 2";
			end
		end
		if (((6599 - (821 + 1038)) >= (7863 - 4711)) and v96.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v96.ExpurgationDebuff) and (v106 <= (1 + 2)) and v15:HasTier(54 - 23, 1 + 1)) then
			if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or ((6389 - 3811) >= (4416 - (834 + 192)))) then
				return "blade_of_justice generators 4";
			end
		end
		if (((3 + 38) <= (427 + 1234)) and v96.DivineToll:IsCastable() and v40 and (v106 <= (1 + 1)) and ((v96.AvengingWrath:CooldownRemains() > (23 - 8)) or (v96.Crusade:CooldownRemains() > (319 - (300 + 4))) or (v104 < (3 + 5)))) then
			if (((1573 - 972) < (3922 - (112 + 250))) and v25(v96.DivineToll, not v17:IsInRange(12 + 18))) then
				return "divine_toll generators 6";
			end
		end
		if (((588 - 353) < (394 + 293)) and v96.Judgment:IsReady() and v43 and v17:DebuffUp(v96.ExpurgationDebuff) and v15:BuffDown(v96.EchoesofWrathBuff) and v15:HasTier(17 + 14, 2 + 0)) then
			if (((2256 + 2293) > (857 + 296)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment generators 7";
			end
		end
		if (((v106 >= (1417 - (1001 + 413))) and v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (22 - 12))) or ((5556 - (244 + 638)) < (5365 - (627 + 66)))) then
			v30 = v117();
			if (((10929 - 7261) < (5163 - (512 + 90))) and v30) then
				return v30;
			end
		end
		if ((v96.TemplarSlash:IsReady() and v45 and ((v96.TemplarStrike:TimeSinceLastCast() + v107) < (1910 - (1665 + 241))) and (v102 >= (719 - (373 + 344)))) or ((206 + 249) == (954 + 2651))) then
			if (v25(v96.TemplarSlash, not v17:IsInRange(26 - 16)) or ((4505 - 1842) == (4411 - (35 + 1064)))) then
				return "templar_slash generators 8";
			end
		end
		if (((3112 + 1165) <= (9574 - 5099)) and v96.BladeofJustice:IsCastable() and v35 and ((v106 <= (1 + 2)) or not v96.HolyBlade:IsAvailable()) and (((v102 >= (1238 - (298 + 938))) and not v96.CrusadingStrikes:IsAvailable()) or (v102 >= (1263 - (233 + 1026))))) then
			if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or ((2536 - (636 + 1030)) == (608 + 581))) then
				return "blade_of_justice generators 10";
			end
		end
		if (((1517 + 36) <= (931 + 2202)) and v96.HammerofWrath:IsReady() and v42 and ((v102 < (1 + 1)) or not v96.BlessedChampion:IsAvailable() or v15:HasTier(251 - (55 + 166), 1 + 3)) and ((v106 <= (1 + 2)) or (v17:HealthPercentage() > (76 - 56)) or not v96.VanguardsMomentum:IsAvailable())) then
			if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((2534 - (36 + 261)) >= (6139 - 2628))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if ((v96.TemplarSlash:IsReady() and v45 and ((v96.TemplarStrike:TimeSinceLastCast() + v107) < (1372 - (34 + 1334)))) or ((509 + 815) > (2347 + 673))) then
			if (v25(v96.TemplarSlash, not v17:IsSpellInRange(v96.TemplarSlash)) or ((4275 - (1035 + 248)) == (1902 - (20 + 1)))) then
				return "templar_slash generators 14";
			end
		end
		if (((1619 + 1487) > (1845 - (134 + 185))) and v96.Judgment:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= (1136 - (549 + 584))) or not v96.BoundlessJudgment:IsAvailable())) then
			if (((3708 - (314 + 371)) < (13285 - 9415)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment generators 16";
			end
		end
		if (((1111 - (478 + 490)) > (40 + 34)) and v96.BladeofJustice:IsCastable() and v35 and ((v106 <= (1175 - (786 + 386))) or not v96.HolyBlade:IsAvailable())) then
			if (((58 - 40) < (3491 - (1055 + 324))) and v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((2437 - (1093 + 247)) <= (1447 + 181)) and v96.Judgment:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= (1 + 2)) or not v96.BoundlessJudgment:IsAvailable())) then
			if (((18381 - 13751) == (15713 - 11083)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
				return "judgment generators 20";
			end
		end
		if (((10073 - 6533) > (6741 - 4058)) and ((v17:HealthPercentage() <= (8 + 12)) or v15:BuffUp(v96.AvengingWrathBuff) or v15:BuffUp(v96.CrusadeBuff) or v15:BuffUp(v96.EmpyreanPowerBuff))) then
			local v156 = 0 - 0;
			while true do
				if (((16523 - 11729) >= (2470 + 805)) and (v156 == (0 - 0))) then
					v30 = v117();
					if (((2172 - (364 + 324)) == (4068 - 2584)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((3436 - 2004) < (1179 + 2376)) and v96.Consecration:IsCastable() and v36 and v17:DebuffDown(v96.ConsecrationDebuff) and (v102 >= (8 - 6))) then
			if (v25(v96.Consecration, not v17:IsInRange(16 - 6)) or ((3234 - 2169) > (4846 - (1249 + 19)))) then
				return "consecration generators 22";
			end
		end
		if ((v96.DivineHammer:IsCastable() and v38 and (v102 >= (2 + 0))) or ((18664 - 13869) < (2493 - (686 + 400)))) then
			if (((1454 + 399) < (5042 - (73 + 156))) and v25(v96.DivineHammer, not v17:IsInRange(1 + 9))) then
				return "divine_hammer generators 24";
			end
		end
		if ((v96.CrusaderStrike:IsCastable() and v37 and (v96.CrusaderStrike:ChargesFractional() >= (812.75 - (721 + 90))) and ((v106 <= (1 + 1)) or ((v106 <= (9 - 6)) and (v96.BladeofJustice:CooldownRemains() > (v107 * (472 - (224 + 246))))) or ((v106 == (5 - 1)) and (v96.BladeofJustice:CooldownRemains() > (v107 * (3 - 1))) and (v96.Judgment:CooldownRemains() > (v107 * (1 + 1)))))) or ((68 + 2753) < (1786 + 645))) then
			if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or ((5713 - 2839) < (7257 - 5076))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v117();
		if (v30 or ((3202 - (203 + 310)) <= (2336 - (1238 + 755)))) then
			return v30;
		end
		if ((v96.TemplarSlash:IsReady() and v45) or ((131 + 1738) == (3543 - (709 + 825)))) then
			if (v25(v96.TemplarSlash, not v17:IsInRange(18 - 8)) or ((5164 - 1618) < (3186 - (196 + 668)))) then
				return "templar_slash generators 28";
			end
		end
		if ((v96.TemplarStrike:IsReady() and v46) or ((8220 - 6138) == (9886 - 5113))) then
			if (((4077 - (171 + 662)) > (1148 - (4 + 89))) and v25(v96.TemplarStrike, not v17:IsInRange(35 - 25))) then
				return "templar_strike generators 30";
			end
		end
		if ((v96.Judgment:IsReady() and v43 and ((v106 <= (2 + 1)) or not v96.BoundlessJudgment:IsAvailable())) or ((14551 - 11238) <= (698 + 1080))) then
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((2907 - (35 + 1451)) >= (3557 - (28 + 1425)))) then
				return "judgment generators 32";
			end
		end
		if (((3805 - (941 + 1052)) <= (3116 + 133)) and v96.HammerofWrath:IsReady() and v42 and ((v106 <= (1517 - (822 + 692))) or (v17:HealthPercentage() > (28 - 8)) or not v96.VanguardsMomentum:IsAvailable())) then
			if (((765 + 858) <= (2254 - (45 + 252))) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if (((4366 + 46) == (1519 + 2893)) and v96.CrusaderStrike:IsCastable() and v37) then
			if (((4259 - 2509) >= (1275 - (114 + 319))) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if (((6276 - 1904) > (2370 - 520)) and v96.ArcaneTorrent:IsCastable() and ((v86 and v33) or not v86) and v85 and (v106 < (4 + 1)) and (v82 < v104)) then
			if (((344 - 112) < (1720 - 899)) and v25(v96.ArcaneTorrent, not v17:IsInRange(1973 - (556 + 1407)))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((1724 - (741 + 465)) < (1367 - (170 + 295))) and v96.Consecration:IsCastable() and v36) then
			if (((1578 + 1416) > (789 + 69)) and v25(v96.Consecration, not v17:IsInRange(24 - 14))) then
				return "consecration generators 30";
			end
		end
		if ((v96.DivineHammer:IsCastable() and v38) or ((3113 + 642) <= (587 + 328))) then
			if (((2235 + 1711) > (4973 - (957 + 273))) and v25(v96.DivineHammer, not v17:IsInRange(3 + 7))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v119()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (19 - 14)) or ((3518 - 2183) >= (10097 - 6791))) then
				v50 = EpicSettings.Settings['useCrusade'];
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v131 = 29 - 23;
			end
			if (((6624 - (389 + 1391)) > (1414 + 839)) and (v131 == (0 + 0))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v131 = 2 - 1;
			end
			if (((1403 - (783 + 168)) == (1516 - 1064)) and (v131 == (4 + 0))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v131 = 316 - (309 + 2);
			end
			if ((v131 == (9 - 6)) or ((5769 - (1090 + 122)) < (677 + 1410))) then
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v131 = 13 - 9;
			end
			if (((2652 + 1222) == (4992 - (628 + 490))) and (v131 == (1 + 1))) then
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v43 = EpicSettings.Settings['useJudgment'];
				v131 = 7 - 4;
			end
			if ((v131 == (4 - 3)) or ((2712 - (431 + 343)) > (9966 - 5031))) then
				v38 = EpicSettings.Settings['useDivineHammer'];
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v131 = 5 - 3;
			end
			if ((v131 == (5 + 1)) or ((545 + 3710) < (5118 - (556 + 1139)))) then
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v131 = 22 - (6 + 9);
			end
			if (((267 + 1187) <= (1277 + 1214)) and (v131 == (176 - (28 + 141)))) then
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (2 - 0)) or ((2945 + 1212) <= (4120 - (486 + 831)))) then
				v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v66 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v67 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v68 = EpicSettings.Settings['layonHandsHP'] or (0 + 0);
				v132 = 9 - 6;
			end
			if (((6116 - (668 + 595)) >= (2684 + 298)) and (v132 == (0 + 0))) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v60 = EpicSettings.Settings['useDivineShield'];
				v132 = 2 - 1;
			end
			if (((4424 - (23 + 267)) > (5301 - (1129 + 815))) and ((391 - (371 + 16)) == v132)) then
				v73 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v74 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v94 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v132 == (1753 - (1326 + 424))) or ((6471 - 3054) < (9259 - 6725))) then
				v69 = EpicSettings.Settings['layonHandsFocusHP'] or (118 - (88 + 30));
				v70 = EpicSettings.Settings['wordofGloryFocusHP'] or (771 - (720 + 51));
				v71 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v72 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (1776 - (421 + 1355));
				v132 = 6 - 2;
			end
			if ((v132 == (1 + 0)) or ((3805 - (286 + 797)) <= (599 - 435))) then
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v132 = 2 - 0;
			end
		end
	end
	local function v121()
		v82 = EpicSettings.Settings['fightRemainsCheck'] or (439 - (397 + 42));
		v79 = EpicSettings.Settings['InterruptWithStun'];
		v80 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v81 = EpicSettings.Settings['InterruptThreshold'];
		v76 = EpicSettings.Settings['DispelDebuffs'];
		v75 = EpicSettings.Settings['DispelBuffs'];
		v83 = EpicSettings.Settings['useTrinkets'];
		v85 = EpicSettings.Settings['useRacials'];
		v84 = EpicSettings.Settings['trinketsWithCD'];
		v86 = EpicSettings.Settings['racialsWithCD'];
		v88 = EpicSettings.Settings['useHealthstone'];
		v87 = EpicSettings.Settings['useHealingPotion'];
		v90 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v89 = EpicSettings.Settings['healingPotionHP'] or (800 - (24 + 776));
		v91 = EpicSettings.Settings['HealingPotionName'] or "";
		v77 = EpicSettings.Settings['handleAfflicted'];
		v78 = EpicSettings.Settings['HandleIncorporeal'];
		v92 = EpicSettings.Settings['HealOOC'];
		v93 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v122()
		v120();
		v119();
		v121();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((3193 - (222 + 563)) < (4646 - 2537))) then
			return v30;
		end
		v101 = v15:GetEnemiesInMeleeRange(6 + 2);
		if (v32 or ((223 - (23 + 167)) == (3253 - (690 + 1108)))) then
			v102 = #v101;
		else
			local v157 = 0 + 0;
			while true do
				if (((0 + 0) == v157) or ((1291 - (40 + 808)) >= (662 + 3353))) then
					v101 = {};
					v102 = 3 - 2;
					break;
				end
			end
		end
		if (((3233 + 149) > (88 + 78)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v96.CrusaderAura:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) or ((154 + 126) == (3630 - (47 + 524)))) then
				if (((1221 + 660) > (3534 - 2241)) and v25(v96.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (((3523 - 1166) == (5375 - 3018)) and (v15:AffectingCombat() or v76)) then
			local v158 = 1726 - (1165 + 561);
			local v159;
			while true do
				if (((4 + 119) == (380 - 257)) and (v158 == (1 + 0))) then
					if (v30 or ((1535 - (341 + 138)) >= (916 + 2476))) then
						return v30;
					end
					break;
				end
				if ((v158 == (0 - 0)) or ((1407 - (89 + 237)) < (3458 - 2383))) then
					v159 = v76 and v96.CleanseToxins:IsReady() and v34;
					v30 = v95.FocusUnit(v159, v100, 42 - 22, nil, 906 - (581 + 300));
					v158 = 1221 - (855 + 365);
				end
			end
		end
		if (v34 or ((2491 - 1442) >= (1448 + 2984))) then
			local v160 = 1235 - (1030 + 205);
			while true do
				if ((v160 == (0 + 0)) or ((4436 + 332) <= (1132 - (156 + 130)))) then
					v30 = v95.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 90 - 50, 42 - 17);
					if (v30 or ((6877 - 3519) <= (375 + 1045))) then
						return v30;
					end
					v160 = 1 + 0;
				end
				if ((v160 == (70 - (10 + 59))) or ((1058 + 2681) <= (14798 - 11793))) then
					if ((v96.BlessingofFreedom:IsReady() and v95.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((2822 - (671 + 492)) >= (1699 + 435))) then
						if (v25(v100.BlessingofFreedomFocus) or ((4475 - (369 + 846)) < (624 + 1731))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		v105 = v109();
		if (not v15:AffectingCombat() or ((571 + 98) == (6168 - (1036 + 909)))) then
			if ((v96.RetributionAura:IsCastable() and (v110())) or ((1346 + 346) < (987 - 399))) then
				if (v25(v96.RetributionAura) or ((5000 - (11 + 192)) < (1846 + 1805))) then
					return "retribution_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((4352 - (135 + 40)) > (11750 - 6900))) then
			if (v15:AffectingCombat() or ((242 + 158) > (2447 - 1336))) then
				if (((4573 - 1522) > (1181 - (50 + 126))) and v96.Intercession:IsCastable()) then
					if (((10283 - 6590) <= (970 + 3412)) and v25(v96.Intercession, not v17:IsInRange(1443 - (1233 + 180)), true)) then
						return "intercession target";
					end
				end
			elseif (v96.Redemption:IsCastable() or ((4251 - (522 + 447)) > (5521 - (107 + 1314)))) then
				if (v25(v96.Redemption, not v17:IsInRange(14 + 16), true) or ((10908 - 7328) < (1208 + 1636))) then
					return "redemption target";
				end
			end
		end
		if (((176 - 87) < (17765 - 13275)) and v96.Redemption:IsCastable() and v96.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v100.RedemptionMouseover) or ((6893 - (716 + 1194)) < (31 + 1777))) then
				return "redemption mouseover";
			end
		end
		if (((411 + 3418) > (4272 - (74 + 429))) and v15:AffectingCombat()) then
			if (((2864 - 1379) <= (1440 + 1464)) and v96.Intercession:IsCastable() and (v15:HolyPower() >= (6 - 3)) and v96.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (((3021 + 1248) == (13160 - 8891)) and v25(v100.IntercessionMouseover)) then
					return "Intercession mouseover";
				end
			end
		end
		if (((956 - 569) <= (3215 - (279 + 154))) and (v95.TargetIsValid() or v15:AffectingCombat())) then
			v103 = v10.BossFightRemains(nil, true);
			v104 = v103;
			if ((v104 == (11889 - (454 + 324))) or ((1495 + 404) <= (934 - (12 + 5)))) then
				v104 = v10.FightRemains(v101, false);
			end
			v107 = v15:GCD();
			v106 = v15:HolyPower();
		end
		if (v77 or ((2325 + 1987) <= (2231 - 1355))) then
			local v161 = 0 + 0;
			while true do
				if (((3325 - (277 + 816)) <= (11092 - 8496)) and (v161 == (1183 - (1058 + 125)))) then
					if (((393 + 1702) < (4661 - (815 + 160))) and v73) then
						local v200 = 0 - 0;
						while true do
							if ((v200 == (0 - 0)) or ((381 + 1214) >= (13078 - 8604))) then
								v30 = v95.HandleAfflicted(v96.CleanseToxins, v100.CleanseToxinsMouseover, 1938 - (41 + 1857));
								if (v30 or ((6512 - (1222 + 671)) < (7448 - 4566))) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v74 and (v106 > (2 - 0))) or ((1476 - (229 + 953)) >= (6605 - (1111 + 663)))) then
						local v201 = 1579 - (874 + 705);
						while true do
							if (((285 + 1744) <= (2105 + 979)) and (v201 == (0 - 0))) then
								v30 = v95.HandleAfflicted(v96.WordofGlory, v100.WordofGloryMouseover, 2 + 38, true);
								if (v30 or ((2716 - (642 + 37)) == (552 + 1868))) then
									return v30;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (((714 + 3744) > (9801 - 5897)) and v78) then
			v30 = v95.HandleIncorporeal(v96.Repentance, v100.RepentanceMouseOver, 484 - (233 + 221), true);
			if (((1008 - 572) >= (109 + 14)) and v30) then
				return v30;
			end
			v30 = v95.HandleIncorporeal(v96.TurnEvil, v100.TurnEvilMouseOver, 1571 - (718 + 823), true);
			if (((315 + 185) < (2621 - (266 + 539))) and v30) then
				return v30;
			end
		end
		v30 = v112();
		if (((10118 - 6544) == (4799 - (636 + 589))) and v30) then
			return v30;
		end
		if (((524 - 303) < (804 - 414)) and v14) then
			if (v76 or ((1754 + 459) <= (517 + 904))) then
				local v197 = 1015 - (657 + 358);
				while true do
					if (((8096 - 5038) < (11072 - 6212)) and ((1187 - (1151 + 36)) == v197)) then
						v30 = v111();
						if (v30 or ((1252 + 44) >= (1169 + 3277))) then
							return v30;
						end
						break;
					end
				end
			end
		end
		v30 = v113();
		if (v30 or ((4160 - 2767) > (6321 - (1552 + 280)))) then
			return v30;
		end
		if ((not v15:AffectingCombat() and v31 and v95.TargetIsValid()) or ((5258 - (64 + 770)) < (19 + 8))) then
			local v162 = 0 - 0;
			while true do
				if ((v162 == (0 + 0)) or ((3240 - (157 + 1086)) > (7636 - 3821))) then
					v30 = v115();
					if (((15175 - 11710) > (2933 - 1020)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((999 - 266) < (2638 - (599 + 220))) and v15:AffectingCombat() and v95.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
			local v163 = 0 - 0;
			while true do
				if ((v163 == (1935 - (1813 + 118))) or ((3213 + 1182) == (5972 - (841 + 376)))) then
					if (v25(v96.Pool) or ((5314 - 1521) < (551 + 1818))) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if ((v163 == (5 - 3)) or ((4943 - (464 + 395)) == (680 - 415))) then
					if (((2093 + 2265) == (5195 - (467 + 370))) and v87 and (v15:HealthPercentage() <= v89)) then
						local v202 = 0 - 0;
						while true do
							if ((v202 == (0 + 0)) or ((10757 - 7619) < (155 + 838))) then
								if (((7747 - 4417) > (2843 - (150 + 370))) and (v91 == "Refreshing Healing Potion")) then
									if (v97.RefreshingHealingPotion:IsReady() or ((4908 - (74 + 1208)) == (9811 - 5822))) then
										if (v25(v100.RefreshingHealingPotion) or ((4344 - 3428) == (1901 + 770))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if (((662 - (14 + 376)) == (471 - 199)) and (v91 == "Dreamwalker's Healing Potion")) then
									if (((2750 + 1499) <= (4251 + 588)) and v97.DreamwalkersHealingPotion:IsReady()) then
										if (((2649 + 128) < (9376 - 6176)) and v25(v100.RefreshingHealingPotion)) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if (((72 + 23) < (2035 - (23 + 55))) and (v82 < v104)) then
						local v203 = 0 - 0;
						while true do
							if (((552 + 274) < (1542 + 175)) and (v203 == (0 - 0))) then
								v30 = v116();
								if (((449 + 977) >= (2006 - (652 + 249))) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					v163 = 7 - 4;
				end
				if (((4622 - (708 + 1160)) <= (9171 - 5792)) and (v163 == (5 - 2))) then
					v30 = v118();
					if (v30 or ((3954 - (10 + 17)) == (318 + 1095))) then
						return v30;
					end
					v163 = 1736 - (1400 + 332);
				end
				if ((v163 == (0 - 0)) or ((3062 - (242 + 1666)) <= (338 + 450))) then
					if ((v61 and (v15:HealthPercentage() <= v68) and v96.LayonHands:IsReady() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((603 + 1040) > (2880 + 499))) then
						if (v25(v96.LayonHands) or ((3743 - (850 + 90)) > (7966 - 3417))) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v60 and (v15:HealthPercentage() <= v67) and v96.DivineShield:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((1610 - (360 + 1030)) >= (2675 + 347))) then
						if (((7964 - 5142) == (3882 - 1060)) and v25(v96.DivineShield)) then
							return "divine_shield defensive";
						end
					end
					v163 = 1662 - (909 + 752);
				end
				if ((v163 == (1224 - (109 + 1114))) or ((1942 - 881) == (723 + 1134))) then
					if (((3002 - (6 + 236)) > (860 + 504)) and v59 and v96.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v66)) then
						if (v25(v96.DivineProtection) or ((3946 + 956) <= (8478 - 4883))) then
							return "divine_protection defensive";
						end
					end
					if ((v97.Healthstone:IsReady() and v88 and (v15:HealthPercentage() <= v90)) or ((6728 - 2876) == (1426 - (1076 + 57)))) then
						if (v25(v100.Healthstone) or ((257 + 1302) == (5277 - (579 + 110)))) then
							return "healthstone defensive";
						end
					end
					v163 = 1 + 1;
				end
			end
		end
	end
	local function v123()
		local v151 = 0 + 0;
		while true do
			if ((v151 == (0 + 0)) or ((4891 - (174 + 233)) == (2201 - 1413))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v99();
				break;
			end
		end
	end
	v21.SetAPL(122 - 52, v122, v123);
end;
return v0["Epix_Paladin_Retribution.lua"]();

