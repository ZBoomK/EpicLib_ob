local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1 + 21) <= (983 + 1272)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((675 + 411) >= (2572 - (645 + 522)))) then
				return v1(v4, ...);
			end
			v5 = 1791 - (1010 + 780);
		end
		if ((v5 == (1 + 0)) or ((11285 - 8916) == (1248 - 822))) then
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
	local v97;
	local v98;
	local v99 = v21.Commons.Everyone;
	local v100 = v19.Paladin.Retribution;
	local v101 = v20.Paladin.Retribution;
	local v102 = {};
	local function v103()
		if (v100.CleanseToxins:IsAvailable() or ((4912 - (1045 + 791)) > (8056 - 4873))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 16965 - 5854;
	local v108 = 11616 - (351 + 154);
	local v109;
	local v110 = 1574 - (1281 + 293);
	local v111 = 266 - (28 + 238);
	local v112;
	v10:RegisterForEvent(function()
		v107 = 24827 - 13716;
		v108 = 12670 - (1381 + 178);
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v129 = 0 + 0;
		local v130;
		local v131;
		while true do
			if (((970 + 232) > (452 + 606)) and ((3 - 2) == v129)) then
				if (((1923 + 1788) > (3825 - (381 + 89))) and (v130 > v131)) then
					return v130;
				end
				return v131;
			end
			if ((v129 == (0 + 0)) or ((613 + 293) >= (3817 - 1588))) then
				v130 = v15:GCDRemains();
				v131 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (1166 - (1074 + 82)), v100.WakeofAshes:CooldownRemains());
				v129 = 1 - 0;
			end
		end
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 1784 - (214 + 1570);
	local function v116()
		if (((2743 - (990 + 465)) > (516 + 735)) and v100.CleanseToxins:IsReady() and v99.DispellableFriendlyUnit(11 + 14)) then
			if ((v115 == (0 + 0)) or ((17760 - 13247) < (5078 - (1668 + 58)))) then
				v115 = GetTime();
			end
			if (v99.Wait(1126 - (512 + 114), v115) or ((5383 - 3318) >= (6606 - 3410))) then
				local v197 = 0 - 0;
				while true do
					if ((v197 == (0 + 0)) or ((820 + 3556) <= (1288 + 193))) then
						if (v25(v104.CleanseToxinsFocus) or ((11440 - 8048) >= (6735 - (109 + 1885)))) then
							return "cleanse_toxins dispel";
						end
						v115 = 1469 - (1269 + 200);
						break;
					end
				end
			end
		end
	end
	local function v117()
		if (((6373 - 3048) >= (2969 - (98 + 717))) and v96 and (v15:HealthPercentage() <= v97)) then
			if (v100.FlashofLight:IsReady() or ((2121 - (802 + 24)) >= (5575 - 2342))) then
				if (((5527 - 1150) > (243 + 1399)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v132 = 0 + 0;
		while true do
			if (((776 + 3947) > (293 + 1063)) and (v132 == (0 - 0))) then
				if (v16:Exists() or ((13792 - 9656) <= (1228 + 2205))) then
					if (((1728 + 2517) <= (3820 + 811)) and v100.WordofGlory:IsReady() and v66 and (v16:HealthPercentage() <= v74)) then
						if (((3110 + 1166) >= (1828 + 2086)) and v25(v104.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((1631 - (797 + 636)) <= (21193 - 16828)) and (not v14 or not v14:Exists() or not v14:IsInRange(1649 - (1427 + 192)))) then
					return;
				end
				v132 = 1 + 0;
			end
			if (((11102 - 6320) > (4204 + 472)) and (v132 == (1 + 0))) then
				if (((5190 - (192 + 134)) > (3473 - (316 + 960))) and v14) then
					if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((2060 + 1640) == (1935 + 572))) then
						if (((4136 + 338) >= (1047 - 773)) and v25(v104.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) or ((2445 - (83 + 468)) <= (3212 - (1202 + 604)))) then
						if (((7338 - 5766) >= (2547 - 1016)) and v25(v104.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((12976 - 8289) < (4867 - (45 + 280)))) then
						if (((3177 + 114) > (1457 + 210)) and v25(v104.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((319 + 554) == (1126 + 908))) then
						if (v25(v104.BlessingofProtectionFocus) or ((496 + 2320) < (20 - 9))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		v30 = v99.HandleTopTrinket(v102, v33, 1951 - (340 + 1571), nil);
		if (((1459 + 2240) < (6478 - (1733 + 39))) and v30) then
			return v30;
		end
		v30 = v99.HandleBottomTrinket(v102, v33, 109 - 69, nil);
		if (((3680 - (125 + 909)) >= (2824 - (1096 + 852))) and v30) then
			return v30;
		end
	end
	local function v120()
		if (((276 + 338) <= (4546 - 1362)) and v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) then
			if (((3033 + 93) == (3638 - (409 + 103))) and v25(v100.ArcaneTorrent, not v17:IsInRange(244 - (46 + 190)))) then
				return "arcane_torrent precombat 0";
			end
		end
		if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((2282 - (51 + 44)) >= (1398 + 3556))) then
			if (v25(v100.ShieldofVengeance, not v17:IsInRange(1325 - (1114 + 203))) or ((4603 - (228 + 498)) == (775 + 2800))) then
				return "shield_of_vengeance precombat 1";
			end
		end
		if (((391 + 316) > (1295 - (174 + 489))) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (10 - 6))) then
			if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((2451 - (830 + 1075)) >= (3208 - (303 + 221)))) then
				return "juscticars vengeance precombat 2";
			end
		end
		if (((2734 - (231 + 1038)) <= (3585 + 716)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (1166 - (171 + 991)))) then
			if (((7022 - 5318) > (3826 - 2401)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
				return "final verdict precombat 3";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (9 - 5))) or ((550 + 137) == (14841 - 10607))) then
			if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((9606 - 6276) < (2302 - 873))) then
				return "templars verdict precombat 4";
			end
		end
		if (((3545 - 2398) >= (1583 - (111 + 1137))) and v100.BladeofJustice:IsCastable() and v37) then
			if (((3593 - (91 + 67)) > (6241 - 4144)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice precombat 5";
			end
		end
		if ((v100.Judgment:IsCastable() and v45) or ((941 + 2829) >= (4564 - (423 + 100)))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((27 + 3764) <= (4460 - 2849))) then
				return "judgment precombat 6";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44) or ((2387 + 2191) <= (2779 - (326 + 445)))) then
			if (((4909 - 3784) <= (4624 - 2548)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
				return "hammer_of_wrath precombat 7";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39) or ((1733 - 990) >= (5110 - (530 + 181)))) then
			if (((2036 - (614 + 267)) < (1705 - (19 + 13))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike precombat 180";
			end
		end
	end
	local function v121()
		local v133 = 0 - 0;
		local v134;
		while true do
			if ((v133 == (4 - 2)) or ((6638 - 4314) <= (151 + 427))) then
				if (((6624 - 2857) == (7811 - 4044)) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(1820 - (1293 + 519))) then
					v30 = v119();
					if (((8342 - 4253) == (10675 - 6586)) and v30) then
						return v30;
					end
				end
				if (((8524 - 4066) >= (7218 - 5544)) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (35 - 20)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
					if (((515 + 457) <= (290 + 1128)) and v25(v100.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v133 = 6 - 3;
			end
			if ((v133 == (1 + 2)) or ((1641 + 3297) < (2976 + 1786))) then
				if ((v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (1111 - (709 + 387)))) or (v15:BuffStack(v100.CrusadeBuff) == (1868 - (673 + 1185))) or (v100.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v100.AvengingWrath:CooldownRemains() > (48 - 33))) and (((v110 >= (6 - 2)) and (v10.CombatTime() < (4 + 1))) or ((v110 >= (3 + 0)) and (v10.CombatTime() > (6 - 1))) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable())) and (((v108 > (15 - 7)) and not v100.ExecutionersWill:IsAvailable()) or (v108 > (23 - 11)))) or ((4384 - (446 + 1434)) > (5547 - (1040 + 243)))) then
					if (((6425 - 4272) == (4000 - (559 + 1288))) and v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (1935 - (609 + 1322))) and (v10.CombatTime() < (459 - (13 + 441)))) or ((v110 >= (10 - 7)) and (v10.CombatTime() > (13 - 8))) or ((v110 >= (9 - 7)) and v100.DivineAuxiliary:IsAvailable() and ((v100.ExecutionSentence:IsAvailable() and ((v100.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v100.ExecutionSentence:CooldownRemains() > (54 - 39)) or not v100.ExecutionSentence:IsReady())) or (v100.FinalReckoning:IsAvailable() and ((v100.FinalReckoning:CooldownRemains() == (0 + 0)) or (v100.FinalReckoning:CooldownRemains() > (14 + 16)) or not v100.FinalReckoning:IsReady())))))) or ((1504 - 997) >= (1418 + 1173))) then
					if (((8241 - 3760) == (2963 + 1518)) and v25(v100.AvengingWrath, not v17:IsInRange(6 + 4))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v133 = 3 + 1;
			end
			if ((v133 == (1 + 0)) or ((2278 + 50) < (1126 - (153 + 280)))) then
				if (((12497 - 8169) == (3886 + 442)) and v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) then
					if (((628 + 960) >= (698 + 634)) and v25(v100.LightsJudgment, not v17:IsInRange(37 + 3))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (8 + 2))))) or ((6355 - 2181) > (2626 + 1622))) then
					if (v25(v100.Fireblood, not v17:IsInRange(677 - (89 + 578))) or ((3277 + 1309) <= (170 - 88))) then
						return "fireblood cooldowns 6";
					end
				end
				v133 = 1051 - (572 + 477);
			end
			if (((521 + 3342) == (2319 + 1544)) and (v133 == (1 + 3))) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (v15:BuffRemains(v100.CrusadeBuff) < v15:GCD()) and (((v110 >= (91 - (84 + 2))) and (v10.CombatTime() < (8 - 3))) or ((v110 >= (3 + 0)) and (v10.CombatTime() > (847 - (497 + 345)))))) or ((8 + 274) <= (8 + 34))) then
					if (((5942 - (605 + 728)) >= (547 + 219)) and v25(v100.Crusade, not v17:IsInRange(22 - 12))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (1 + 3)) and (v10.CombatTime() < (29 - 21))) or ((v110 >= (3 + 0)) and (v10.CombatTime() >= (21 - 13))) or ((v110 >= (2 + 0)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (499 - (457 + 32))) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (5 + 5))))) and ((v109 > (1402 - (832 + 570))) or (v110 == (5 + 0)) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable()))) or ((4076 - 2924) == (1199 + 1289))) then
					if (((4218 - (588 + 208)) > (9029 - 5679)) and (v98 == "player")) then
						if (((2677 - (884 + 916)) > (786 - 410)) and v25(v104.FinalReckoningPlayer, not v17:IsInRange(6 + 4))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if ((v98 == "cursor") or ((3771 - (232 + 421)) <= (3740 - (1569 + 320)))) then
						if (v25(v104.FinalReckoningCursor, not v17:IsInRange(5 + 15)) or ((32 + 133) >= (11767 - 8275))) then
							return "final_reckoning cooldowns 18";
						end
					end
				end
				break;
			end
			if (((4554 - (316 + 289)) < (12711 - 7855)) and (v133 == (0 + 0))) then
				v134 = v99.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15.BuffStack(v100.Crusade) == (1463 - (666 + 787)))) or (v108 < (450 - (360 + 65))));
				if (v134 or ((3997 + 279) < (3270 - (79 + 175)))) then
					return v134;
				end
				v133 = 1 - 0;
			end
		end
	end
	local function v122()
		v112 = ((v106 >= (3 + 0)) or ((v106 >= (5 - 3)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (45 - 21)));
		if (((5589 - (503 + 396)) > (4306 - (92 + 89))) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (5 - 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (6 + 4))))) then
			if (v25(v100.DivineStorm, not v17:IsInRange(6 + 4)) or ((195 - 145) >= (123 + 773))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (6 - 3))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (9 + 1))))) or ((819 + 895) >= (9008 - 6050))) then
			if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((187 + 1304) < (981 - 337))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((1948 - (485 + 759)) < (2283 - 1296)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1192 - (442 + 747)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1145 - (832 + 303)))))) then
			if (((4664 - (88 + 858)) > (581 + 1325)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (3 + 0))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) or ((1747 - (766 + 23)) > (17945 - 14310))) then
			if (((4787 - 1286) <= (11834 - 7342)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v123()
		if ((v110 >= (16 - 11)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(1104 - (1036 + 37), 3 + 1) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (7 - 3))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(25 + 6, 1482 - (641 + 839))) or ((4355 - (910 + 3)) < (6495 - 3947))) then
			local v176 = 1684 - (1466 + 218);
			while true do
				if (((1322 + 1553) >= (2612 - (556 + 592))) and (v176 == (0 + 0))) then
					v30 = v122();
					if (v30 or ((5605 - (329 + 479)) >= (5747 - (174 + 680)))) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (10 - 7)) and v15:HasTier(64 - 33, 2 + 0)) or ((1290 - (396 + 343)) > (183 + 1885))) then
			if (((3591 - (29 + 1448)) > (2333 - (135 + 1254))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 1";
			end
		end
		if ((v100.WakeofAshes:IsCastable() and v49 and (v110 <= (7 - 5)) and ((v100.AvengingWrath:CooldownRemains() > (0 - 0)) or (v100.Crusade:CooldownRemains() > (0 + 0)) or not v100.Crusade:IsAvailable() or not v100.AvengingWrath:IsReady()) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (1531 - (389 + 1138))) or (v108 < (582 - (102 + 472))) or not v100.ExecutionSentence:IsReady())) or ((2135 + 127) >= (1717 + 1379))) then
			if (v25(v100.WakeofAshes, not v17:IsInRange(10 + 0)) or ((3800 - (320 + 1225)) >= (6295 - 2758))) then
				return "wake_of_ashes generators 2";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (2 + 1)) and v15:HasTier(1495 - (157 + 1307), 1861 - (821 + 1038))) or ((9573 - 5736) < (143 + 1163))) then
			if (((5239 - 2289) == (1098 + 1852)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 4";
			end
		end
		if ((v100.DivineToll:IsCastable() and v42 and (v110 <= (4 - 2)) and ((v100.AvengingWrath:CooldownRemains() > (1041 - (834 + 192))) or (v100.Crusade:CooldownRemains() > (1 + 14)) or (v108 < (3 + 5)))) or ((102 + 4621) < (5109 - 1811))) then
			if (((1440 - (300 + 4)) >= (42 + 112)) and v25(v100.DivineToll, not v17:IsInRange(78 - 48))) then
				return "divine_toll generators 6";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(393 - (112 + 250), 1 + 1)) or ((678 - 407) > (2721 + 2027))) then
			if (((2452 + 2288) >= (2358 + 794)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment generators 7";
			end
		end
		if (((v110 >= (2 + 1)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (8 + 2))) or ((3992 - (1001 + 413)) >= (7559 - 4169))) then
			local v177 = 882 - (244 + 638);
			while true do
				if (((734 - (627 + 66)) <= (4949 - 3288)) and ((602 - (512 + 90)) == v177)) then
					v30 = v122();
					if (((2507 - (1665 + 241)) < (4277 - (373 + 344))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((106 + 129) < (182 + 505)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (10 - 6)) and (v106 >= (2 - 0))) then
			if (((5648 - (35 + 1064)) > (839 + 314)) and v25(v100.TemplarSlash, not v17:IsInRange(21 - 11))) then
				return "templar_slash generators 8";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1 + 2)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (1238 - (298 + 938))) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (1263 - (233 + 1026))))) or ((6340 - (636 + 1030)) < (2389 + 2283))) then
			if (((3583 + 85) < (1355 + 3206)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice generators 10";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (1 + 1)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(251 - (55 + 166), 1 + 3)) and ((v110 <= (1 + 2)) or (v17:HealthPercentage() > (76 - 56)) or not v100.VanguardsMomentum:IsAvailable())) or ((752 - (36 + 261)) == (6304 - 2699))) then
			if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((4031 - (34 + 1334)) == (1274 + 2038))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if (((3324 + 953) <= (5758 - (1035 + 248))) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (25 - (20 + 1)))) then
			if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((454 + 416) == (1508 - (134 + 185)))) then
				return "templar_slash generators 14";
			end
		end
		if (((2686 - (549 + 584)) <= (3818 - (314 + 371))) and v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (10 - 7)) or not v100.BoundlessJudgment:IsAvailable())) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((3205 - (478 + 490)) >= (1860 + 1651))) then
				return "judgment generators 16";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1175 - (786 + 386))) or not v100.HolyBlade:IsAvailable())) or ((4288 - 2964) > (4399 - (1055 + 324)))) then
			if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((4332 - (1093 + 247)) == (1672 + 209))) then
				return "blade_of_justice generators 18";
			end
		end
		if (((327 + 2779) > (6058 - 4532)) and ((v17:HealthPercentage() <= (67 - 47)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
			local v178 = 0 - 0;
			while true do
				if (((7596 - 4573) < (1377 + 2493)) and ((0 - 0) == v178)) then
					v30 = v122();
					if (((492 - 349) > (56 + 18)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((45 - 27) < (2800 - (364 + 324))) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (5 - 3))) then
			if (((2632 - 1535) <= (540 + 1088)) and v25(v100.Consecration, not v17:IsInRange(41 - 31))) then
				return "consecration generators 22";
			end
		end
		if (((7415 - 2785) == (14061 - 9431)) and v100.DivineHammer:IsCastable() and v40 and (v106 >= (1270 - (1249 + 19)))) then
			if (((3196 + 344) > (10443 - 7760)) and v25(v100.DivineHammer, not v17:IsInRange(1096 - (686 + 400)))) then
				return "divine_hammer generators 24";
			end
		end
		if (((3762 + 1032) >= (3504 - (73 + 156))) and v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v110 <= (813 - (721 + 90))) or ((v110 <= (1 + 2)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (6 - 4)))) or ((v110 == (474 - (224 + 246))) and (v100.BladeofJustice:CooldownRemains() > (v111 * (2 - 0))) and (v100.Judgment:CooldownRemains() > (v111 * (3 - 1)))))) then
			if (((270 + 1214) == (36 + 1448)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		v30 = v122();
		if (((1052 + 380) < (7067 - 3512)) and v30) then
			return v30;
		end
		if ((v100.TemplarSlash:IsReady() and v47) or ((3544 - 2479) > (4091 - (203 + 310)))) then
			if (v25(v100.TemplarSlash, not v17:IsInRange(2003 - (1238 + 755))) or ((335 + 4460) < (2941 - (709 + 825)))) then
				return "templar_slash generators 28";
			end
		end
		if (((3413 - 1560) < (7010 - 2197)) and v100.TemplarStrike:IsReady() and v48) then
			if (v25(v100.TemplarStrike, not v17:IsInRange(874 - (196 + 668))) or ((11138 - 8317) < (5035 - 2604))) then
				return "templar_strike generators 30";
			end
		end
		if ((v100.Judgment:IsReady() and v45 and ((v110 <= (836 - (171 + 662))) or not v100.BoundlessJudgment:IsAvailable())) or ((2967 - (4 + 89)) < (7644 - 5463))) then
			if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((980 + 1709) <= (1506 - 1163))) then
				return "judgment generators 32";
			end
		end
		if ((v100.HammerofWrath:IsReady() and v44 and ((v110 <= (2 + 1)) or (v17:HealthPercentage() > (1506 - (35 + 1451))) or not v100.VanguardsMomentum:IsAvailable())) or ((3322 - (28 + 1425)) == (4002 - (941 + 1052)))) then
			if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((3401 + 145) < (3836 - (822 + 692)))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39) or ((2971 - 889) == (2249 + 2524))) then
			if (((3541 - (45 + 252)) > (1044 + 11)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (2 + 3)) and (v86 < v108)) or ((8062 - 4749) <= (2211 - (114 + 319)))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(14 - 4)) or ((1820 - 399) >= (1342 + 762))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((2698 - 886) <= (6807 - 3558)) and v100.Consecration:IsCastable() and v38) then
			if (((3586 - (556 + 1407)) <= (3163 - (741 + 465))) and v25(v100.Consecration, not v17:IsInRange(475 - (170 + 295)))) then
				return "consecration generators 30";
			end
		end
		if (((2325 + 2087) == (4053 + 359)) and v100.DivineHammer:IsCastable() and v40) then
			if (((4308 - 2558) >= (698 + 144)) and v25(v100.DivineHammer, not v17:IsInRange(7 + 3))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v124()
		v35 = EpicSettings.Settings['swapAuras'];
		v36 = EpicSettings.Settings['useWeapon'];
		v37 = EpicSettings.Settings['useBladeofJustice'];
		v38 = EpicSettings.Settings['useConsecration'];
		v39 = EpicSettings.Settings['useCrusaderStrike'];
		v40 = EpicSettings.Settings['useDivineHammer'];
		v41 = EpicSettings.Settings['useDivineStorm'];
		v42 = EpicSettings.Settings['useDivineToll'];
		v43 = EpicSettings.Settings['useExecutionSentence'];
		v44 = EpicSettings.Settings['useHammerofWrath'];
		v45 = EpicSettings.Settings['useJudgment'];
		v46 = EpicSettings.Settings['useJusticarsVengeance'];
		v47 = EpicSettings.Settings['useTemplarSlash'];
		v48 = EpicSettings.Settings['useTemplarStrike'];
		v49 = EpicSettings.Settings['useWakeofAshes'];
		v50 = EpicSettings.Settings['useVerdict'];
		v51 = EpicSettings.Settings['useAvengingWrath'];
		v52 = EpicSettings.Settings['useCrusade'];
		v53 = EpicSettings.Settings['useFinalReckoning'];
		v54 = EpicSettings.Settings['useShieldofVengeance'];
		v55 = EpicSettings.Settings['avengingWrathWithCD'];
		v56 = EpicSettings.Settings['crusadeWithCD'];
		v57 = EpicSettings.Settings['finalReckoningWithCD'];
		v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v125()
		v59 = EpicSettings.Settings['useRebuke'];
		v60 = EpicSettings.Settings['useHammerofJustice'];
		v61 = EpicSettings.Settings['useDivineProtection'];
		v62 = EpicSettings.Settings['useDivineShield'];
		v63 = EpicSettings.Settings['useLayonHands'];
		v64 = EpicSettings.Settings['useLayonHandsFocus'];
		v65 = EpicSettings.Settings['useWordofGloryFocus'];
		v66 = EpicSettings.Settings['useWordofGloryMouseover'];
		v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v69 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
		v70 = EpicSettings.Settings['divineShieldHP'] or (1230 - (957 + 273));
		v71 = EpicSettings.Settings['layonHandsHP'] or (0 + 0);
		v72 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
		v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 - 0);
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v126()
		local v171 = 1780 - (389 + 1391);
		while true do
			if (((2743 + 1629) > (193 + 1657)) and (v171 == (8 - 4))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (951 - (783 + 168));
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v171 = 5 + 0;
			end
			if (((543 - (309 + 2)) < (2521 - 1700)) and (v171 == (1218 - (1090 + 122)))) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
			if (((1739 - 1221) < (618 + 284)) and (v171 == (1121 - (628 + 490)))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v171 = 1 + 3;
			end
			if (((7412 - 4418) > (3920 - 3062)) and (v171 == (774 - (431 + 343)))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v171 = 2 - 1;
			end
			if ((v171 == (4 + 1)) or ((481 + 3274) <= (2610 - (556 + 1139)))) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v171 = 21 - (6 + 9);
			end
			if (((723 + 3223) > (1918 + 1825)) and (v171 == (170 - (28 + 141)))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v171 = 1 + 1;
			end
			if ((v171 == (2 - 0)) or ((946 + 389) >= (4623 - (486 + 831)))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v171 = 7 - 4;
			end
		end
	end
	local function v127()
		local v172 = 0 - 0;
		while true do
			if (((916 + 3928) > (7123 - 4870)) and (v172 == (1269 - (668 + 595)))) then
				v30 = v118();
				if (((407 + 45) == (92 + 360)) and v30) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v99.TargetIsValid()) or ((12427 - 7870) < (2377 - (23 + 267)))) then
					v30 = v120();
					if (((5818 - (1129 + 815)) == (4261 - (371 + 16))) and v30) then
						return v30;
					end
				end
				if ((v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
					if ((v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((15548 - 11293) < (3541 - (88 + 30)))) then
						if (((2225 - (720 + 51)) <= (5541 - 3050)) and v25(v100.LayonHands)) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((5933 - (421 + 1355)) <= (4624 - 1821))) then
						if (((2384 + 2469) >= (4065 - (286 + 797))) and v25(v100.DivineShield)) then
							return "divine_shield defensive";
						end
					end
					if (((15112 - 10978) > (5560 - 2203)) and v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) then
						if (v25(v100.DivineProtection) or ((3856 - (397 + 42)) < (792 + 1742))) then
							return "divine_protection defensive";
						end
					end
					if ((v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((3522 - (24 + 776)) <= (252 - 88))) then
						if (v25(v104.Healthstone) or ((3193 - (222 + 563)) < (4646 - 2537))) then
							return "healthstone defensive";
						end
					end
					if ((v91 and (v15:HealthPercentage() <= v93)) or ((24 + 9) == (1645 - (23 + 167)))) then
						if ((v95 == "Refreshing Healing Potion") or ((2241 - (690 + 1108)) >= (1449 + 2566))) then
							if (((2790 + 592) > (1014 - (40 + 808))) and v101.RefreshingHealingPotion:IsReady()) then
								if (v25(v104.RefreshingHealingPotion) or ((47 + 233) == (11697 - 8638))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((1798 + 83) > (685 + 608)) and (v95 == "Dreamwalker's Healing Potion")) then
							if (((1293 + 1064) == (2928 - (47 + 524))) and v101.DreamwalkersHealingPotion:IsReady()) then
								if (((80 + 43) == (336 - 213)) and v25(v104.RefreshingHealingPotion)) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
					end
					if ((v86 < v108) or ((1578 - 522) >= (7735 - 4343))) then
						v30 = v121();
						if (v30 or ((2807 - (1165 + 561)) < (32 + 1043))) then
							return v30;
						end
						if ((v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36) or ((3248 - 2199) >= (1692 + 2740))) then
							if (v25(v104.UseWeapon) or ((5247 - (341 + 138)) <= (229 + 617))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					v30 = v123();
					if (v30 or ((6929 - 3571) <= (1746 - (89 + 237)))) then
						return v30;
					end
					if (v25(v100.Pool) or ((12028 - 8289) <= (6326 - 3321))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v172 == (885 - (581 + 300))) or ((2879 - (855 + 365)) >= (5068 - 2934))) then
				if (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()) or ((1065 + 2195) < (3590 - (1030 + 205)))) then
					local v198 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v198, v104, 19 + 1, nil, 24 + 1);
					if (v30 or ((955 - (156 + 130)) == (9595 - 5372))) then
						return v30;
					end
				end
				if (v34 or ((2851 - 1159) < (1204 - 616))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 11 + 29, 15 + 10);
					if (v30 or ((4866 - (10 + 59)) < (1033 + 2618))) then
						return v30;
					end
					if ((v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((20570 - 16393) > (6013 - (671 + 492)))) then
						if (v25(v104.BlessingofFreedomFocus) or ((319 + 81) > (2326 - (369 + 846)))) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((808 + 2243) > (858 + 147)) and (v99.TargetIsValid() or v15:AffectingCombat())) then
					local v199 = 1945 - (1036 + 909);
					while true do
						if (((2937 + 756) <= (7356 - 2974)) and (v199 == (204 - (11 + 192)))) then
							if ((v108 == (5615 + 5496)) or ((3457 - (135 + 40)) > (9933 - 5833))) then
								v108 = v10.FightRemains(v105, false);
							end
							v111 = v15:GCD();
							v199 = 2 + 0;
						end
						if ((v199 == (4 - 2)) or ((5366 - 1786) < (3020 - (50 + 126)))) then
							v110 = v15:HolyPower();
							break;
						end
						if (((247 - 158) < (994 + 3496)) and (v199 == (1413 - (1233 + 180)))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v199 = 970 - (522 + 447);
						end
					end
				end
				if (v81 or ((6404 - (107 + 1314)) < (839 + 969))) then
					local v200 = 0 - 0;
					while true do
						if (((1627 + 2202) > (7484 - 3715)) and ((0 - 0) == v200)) then
							if (((3395 - (716 + 1194)) <= (50 + 2854)) and v77) then
								local v203 = 0 + 0;
								while true do
									if (((4772 - (74 + 429)) == (8234 - 3965)) and (v203 == (0 + 0))) then
										v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 91 - 51);
										if (((274 + 113) <= (8576 - 5794)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v78 and (v110 > (4 - 2))) or ((2332 - (279 + 154)) <= (1695 - (454 + 324)))) then
								local v204 = 0 + 0;
								while true do
									if ((v204 == (17 - (12 + 5))) or ((2325 + 1987) <= (2231 - 1355))) then
										v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 15 + 25, true);
										if (((3325 - (277 + 816)) <= (11092 - 8496)) and v30) then
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
				v172 = 1188 - (1058 + 125);
			end
			if (((393 + 1702) < (4661 - (815 + 160))) and (v172 == (8 - 6))) then
				v105 = v15:GetEnemiesInMeleeRange(18 - 10);
				if (v32 or ((381 + 1214) >= (13078 - 8604))) then
					v106 = #v105;
				else
					local v201 = 1898 - (41 + 1857);
					while true do
						if ((v201 == (1893 - (1222 + 671))) or ((11937 - 7318) < (4142 - 1260))) then
							v105 = {};
							v106 = 1183 - (229 + 953);
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((2068 - (1111 + 663)) >= (6410 - (874 + 705)))) then
					if (((285 + 1744) <= (2105 + 979)) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
						if (v25(v100.CrusaderAura) or ((4233 - 2196) == (69 + 2351))) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v172 = 682 - (642 + 37);
			end
			if (((1017 + 3441) > (625 + 3279)) and (v172 == (0 - 0))) then
				v125();
				v124();
				v126();
				v31 = EpicSettings.Toggles['ooc'];
				v172 = 455 - (233 + 221);
			end
			if (((1008 - 572) >= (109 + 14)) and ((1546 - (718 + 823)) == v172)) then
				if (((315 + 185) < (2621 - (266 + 539))) and v82) then
					local v202 = 0 - 0;
					while true do
						if (((4799 - (636 + 589)) == (8483 - 4909)) and (v202 == (0 - 0))) then
							v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 24 + 6, true);
							if (((81 + 140) < (1405 - (657 + 358))) and v30) then
								return v30;
							end
							v202 = 2 - 1;
						end
						if ((v202 == (2 - 1)) or ((3400 - (1151 + 36)) <= (1373 + 48))) then
							v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 8 + 22, true);
							if (((9132 - 6074) < (6692 - (1552 + 280))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v30 = v117();
				if (v30 or ((2130 - (64 + 770)) >= (3019 + 1427))) then
					return v30;
				end
				if ((v80 and v34) or ((3162 - 1769) > (798 + 3691))) then
					if (v14 or ((5667 - (157 + 1086)) < (53 - 26))) then
						v30 = v116();
						if (v30 or ((8746 - 6749) > (5851 - 2036))) then
							return v30;
						end
					end
					if (((4728 - 1263) > (2732 - (599 + 220))) and v16 and v16:Exists() and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16))) then
						if (((1459 - 726) < (3750 - (1813 + 118))) and v100.CleanseToxins:IsReady()) then
							if (v25(v104.CleanseToxinsMouseover) or ((3213 + 1182) == (5972 - (841 + 376)))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v172 = 7 - 1;
			end
			if (((1 + 2) == v172) or ((10352 - 6559) < (3228 - (464 + 395)))) then
				if (not v15:AffectingCombat() or ((10480 - 6396) == (128 + 137))) then
					if (((5195 - (467 + 370)) == (9005 - 4647)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
						if (v25(v100.RetributionAura) or ((2304 + 834) < (3403 - 2410))) then
							return "retribution_aura";
						end
					end
				end
				if (((520 + 2810) > (5404 - 3081)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (v15:AffectingCombat() or ((4146 - (150 + 370)) == (5271 - (74 + 1208)))) then
						if (v100.Intercession:IsCastable() or ((2252 - 1336) == (12667 - 9996))) then
							if (((194 + 78) == (662 - (14 + 376))) and v25(v100.Intercession, not v17:IsInRange(52 - 22), true)) then
								return "intercession target";
							end
						end
					elseif (((2750 + 1499) <= (4251 + 588)) and v100.Redemption:IsCastable()) then
						if (((2649 + 128) < (9376 - 6176)) and v25(v100.Redemption, not v17:IsInRange(23 + 7), true)) then
							return "redemption target";
						end
					end
				end
				if (((173 - (23 + 55)) < (4637 - 2680)) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((552 + 274) < (1542 + 175)) and v25(v104.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (((2210 - 784) >= (348 + 757)) and v15:AffectingCombat()) then
					if (((3655 - (652 + 249)) <= (9042 - 5663)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (1871 - (708 + 1160))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v104.IntercessionMouseover) or ((10659 - 6732) == (2576 - 1163))) then
							return "Intercession mouseover";
						end
					end
				end
				v172 = 31 - (10 + 17);
			end
			if ((v172 == (1 + 0)) or ((2886 - (1400 + 332)) <= (1511 - 723))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((3551 - (242 + 1666)) > (1446 + 1933))) then
					return v30;
				end
				v172 = 1 + 1;
			end
		end
	end
	local function v128()
		local v173 = 0 + 0;
		while true do
			if ((v173 == (940 - (850 + 90))) or ((4908 - 2105) > (5939 - (360 + 1030)))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v103();
				break;
			end
		end
	end
	v21.SetAPL(62 + 8, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

