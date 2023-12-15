local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (300 - (63 + 236))) or ((2239 - 1543) > (4480 - (1763 + 63)))) then
			return v6(...);
		end
		if (((1559 - (257 + 930)) <= (2549 - 1628)) and (v5 == (325 - (45 + 280)))) then
			v6 = v0[v4];
			if (((3571 + 128) < (4112 + 594)) and not v6) then
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
		if (((1465 + 1181) >= (155 + 721)) and v96.CleanseToxins:IsAvailable()) then
			v95.DispellableDebuffs = v13.MergeTable(v95.DispellableDiseaseDebuffs, v95.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v99();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v100 = v24.Paladin.Retribution;
	local v101;
	local v102;
	local v103 = 20574 - 9463;
	local v104 = 13022 - (340 + 1571);
	local v105;
	local v106 = 0 + 0;
	local v107 = 1772 - (1733 + 39);
	local v108;
	v10:RegisterForEvent(function()
		local v124 = 0 - 0;
		while true do
			if (((1648 - (125 + 909)) <= (5132 - (1096 + 852))) and (v124 == (0 + 0))) then
				v103 = 15867 - 4756;
				v104 = 10777 + 334;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v109()
		local v125 = 512 - (409 + 103);
		local v126;
		local v127;
		while true do
			if (((3362 - (46 + 190)) == (3221 - (51 + 44))) and (v125 == (1 + 0))) then
				if ((v126 > v127) or ((3504 - (1114 + 203)) >= (5680 - (228 + 498)))) then
					return v126;
				end
				return v127;
			end
			if ((v125 == (0 + 0)) or ((2142 + 1735) == (4238 - (174 + 489)))) then
				v126 = v15:GCDRemains();
				v127 = v28(v96.CrusaderStrike:CooldownRemains(), v96.BladeofJustice:CooldownRemains(), v96.Judgment:CooldownRemains(), (v96.HammerofWrath:IsUsable() and v96.HammerofWrath:CooldownRemains()) or (26 - 16), v96.WakeofAshes:CooldownRemains());
				v125 = 1906 - (830 + 1075);
			end
		end
	end
	local function v110()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v111()
		if (((1231 - (303 + 221)) > (1901 - (231 + 1038))) and v96.CleanseToxins:IsReady() and v34 and v95.DispellableFriendlyUnit(21 + 4)) then
			if (v25(v100.CleanseToxinsFocus) or ((1708 - (171 + 991)) >= (11061 - 8377))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v112()
		if (((3933 - 2468) <= (10732 - 6431)) and v92 and (v15:HealthPercentage() <= v93)) then
			if (((1364 + 340) > (4995 - 3570)) and v96.FlashofLight:IsReady()) then
				if (v25(v96.FlashofLight) or ((1981 - 1294) == (6824 - 2590))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v113()
		local v128 = 0 - 0;
		while true do
			if ((v128 == (1248 - (111 + 1137))) or ((3488 - (91 + 67)) < (4253 - 2824))) then
				if (((287 + 860) >= (858 - (423 + 100))) and (not v14 or not v14:Exists() or not v14:IsInRange(1 + 29))) then
					return;
				end
				if (((9510 - 6075) > (1094 + 1003)) and v14) then
					if ((v96.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v70)) or ((4541 - (326 + 445)) >= (17634 - 13593))) then
						if (v25(v100.WordofGloryFocus) or ((8445 - 4654) <= (3760 - 2149))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v96.LayonHands:IsCastable() and v62 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v69)) or ((5289 - (530 + 181)) <= (2889 - (614 + 267)))) then
						if (((1157 - (19 + 13)) <= (3378 - 1302)) and v25(v100.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v96.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v72)) or ((1730 - 987) >= (12566 - 8167))) then
						if (((300 + 855) < (2941 - 1268)) and v25(v100.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v96.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) or ((4819 - 2495) <= (2390 - (1293 + 519)))) then
						if (((7685 - 3918) == (9835 - 6068)) and v25(v100.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		v30 = v95.HandleTopTrinket(v98, v33, 76 - 36, nil);
		if (((17632 - 13543) == (9632 - 5543)) and v30) then
			return v30;
		end
		v30 = v95.HandleBottomTrinket(v98, v33, 22 + 18, nil);
		if (((910 + 3548) >= (3889 - 2215)) and v30) then
			return v30;
		end
	end
	local function v115()
		local v129 = 0 + 0;
		while true do
			if (((323 + 649) <= (887 + 531)) and (v129 == (1099 - (709 + 387)))) then
				if ((v96.HammerofWrath:IsReady() and v42) or ((6796 - (673 + 1185)) < (13810 - 9048))) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((8040 - 5536) > (7015 - 2751))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if (((1540 + 613) == (1609 + 544)) and v96.CrusaderStrike:IsCastable() and v37) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or ((684 - 177) >= (637 + 1954))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((8934 - 4453) == (8796 - 4315)) and (v129 == (1881 - (446 + 1434)))) then
				if ((v96.FinalVerdict:IsAvailable() and v96.FinalVerdict:IsReady() and v48 and (v106 >= (1287 - (1040 + 243)))) or ((6948 - 4620) < (2540 - (559 + 1288)))) then
					if (((6259 - (609 + 1322)) == (4782 - (13 + 441))) and v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				if (((5933 - 4345) >= (3488 - 2156)) and v96.TemplarsVerdict:IsReady() and v48 and (v106 >= (19 - 15))) then
					if (v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict)) or ((156 + 4018) > (15427 - 11179))) then
						return "templars verdict precombat 4";
					end
				end
				v129 = 1 + 1;
			end
			if ((v129 == (1 + 1)) or ((13609 - 9023) <= (45 + 37))) then
				if (((7104 - 3241) == (2554 + 1309)) and v96.BladeofJustice:IsCastable() and v35) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or ((157 + 125) <= (31 + 11))) then
						return "blade_of_justice precombat 5";
					end
				end
				if (((3870 + 739) >= (750 + 16)) and v96.Judgment:IsCastable() and v43) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((1585 - (153 + 280)) == (7184 - 4696))) then
						return "judgment precombat 6";
					end
				end
				v129 = 3 + 0;
			end
			if (((1352 + 2070) > (1754 + 1596)) and (v129 == (0 + 0))) then
				if (((636 + 241) > (572 - 196)) and v96.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) then
					if (v25(v96.ShieldofVengeance) or ((1928 + 1190) <= (2518 - (89 + 578)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v96.JusticarsVengeance:IsAvailable() and v96.JusticarsVengeance:IsReady() and v44 and (v106 >= (3 + 1))) or ((342 - 177) >= (4541 - (572 + 477)))) then
					if (((533 + 3416) < (2915 + 1941)) and v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v129 = 1 + 0;
			end
		end
	end
	local function v116()
		local v130 = 86 - (84 + 2);
		local v131;
		while true do
			if ((v130 == (0 - 0)) or ((3081 + 1195) < (3858 - (497 + 345)))) then
				v131 = v95.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15.BuffStack(v96.Crusade) == (1 + 9))) or (v104 < (5 + 20)));
				if (((6023 - (605 + 728)) > (2944 + 1181)) and v131) then
					return v131;
				end
				v130 = 1 - 0;
			end
			if ((v130 == (1 + 3)) or ((184 - 134) >= (808 + 88))) then
				if ((v96.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v106 >= (10 - 6)) and (v10.CombatTime() < (4 + 1))) or ((v106 >= (492 - (457 + 32))) and (v10.CombatTime() >= (3 + 2))))) or ((3116 - (832 + 570)) >= (2787 + 171))) then
					if (v25(v96.Crusade, not v17:IsInRange(3 + 7)) or ((5276 - 3785) < (311 + 333))) then
						return "crusade cooldowns 14";
					end
				end
				if (((1500 - (588 + 208)) < (2660 - 1673)) and v96.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v106 >= (1804 - (884 + 916))) and (v10.CombatTime() < (16 - 8))) or ((v106 >= (2 + 1)) and (v10.CombatTime() >= (661 - (232 + 421)))) or ((v106 >= (1891 - (1569 + 320))) and v96.DivineAuxiliary:IsAvailable())) and ((v96.AvengingWrath:CooldownRemains() > (3 + 7)) or (v96.Crusade:CooldownDown() and (v15:BuffDown(v96.CrusadeBuff) or (v15:BuffStack(v96.CrusadeBuff) >= (2 + 8))))) and ((v105 > (0 - 0)) or (v106 == (610 - (316 + 289))) or ((v106 >= (5 - 3)) and v96.DivineAuxiliary:IsAvailable()))) then
					local v191 = 0 + 0;
					while true do
						if (((5171 - (666 + 787)) > (2331 - (360 + 65))) and (v191 == (0 + 0))) then
							if ((v94 == "player") or ((1212 - (79 + 175)) > (5731 - 2096))) then
								if (((2732 + 769) <= (13768 - 9276)) and v25(v100.FinalReckoningPlayer, not v17:IsInRange(19 - 9))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v94 == "cursor") or ((4341 - (503 + 396)) < (2729 - (92 + 89)))) then
								if (((5576 - 2701) >= (751 + 713)) and v25(v100.FinalReckoningCursor, not v17:IsInRange(12 + 8))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v130 == (3 - 2)) or ((656 + 4141) >= (11156 - 6263))) then
				if ((v96.LightsJudgment:IsCastable() and v85 and ((v86 and v33) or not v86)) or ((481 + 70) > (988 + 1080))) then
					if (((6438 - 4324) > (118 + 826)) and v25(v96.LightsJudgment, not v17:IsInRange(61 - 21))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v96.Fireblood:IsCastable() and v85 and ((v86 and v33) or not v86) and (v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) == (1254 - (485 + 759)))))) or ((5233 - 2971) >= (4285 - (442 + 747)))) then
					if (v25(v96.Fireblood, not v17:IsInRange(1145 - (832 + 303))) or ((3201 - (88 + 858)) >= (1079 + 2458))) then
						return "fireblood cooldowns 6";
					end
				end
				v130 = 2 + 0;
			end
			if ((v130 == (1 + 1)) or ((4626 - (766 + 23)) < (6447 - 5141))) then
				if (((4034 - 1084) == (7772 - 4822)) and v83 and ((v33 and v84) or not v84) and v17:IsInRange(27 - 19)) then
					local v192 = 1073 - (1036 + 37);
					while true do
						if ((v192 == (0 + 0)) or ((9197 - 4474) < (2595 + 703))) then
							v30 = v114();
							if (((2616 - (641 + 839)) >= (1067 - (910 + 3))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v96.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v104 > (38 - 23)) and (not v96.ExecutionSentence:IsAvailable() or v17:DebuffDown(v96.ExecutionSentence))) or ((1955 - (1466 + 218)) > (2183 + 2565))) then
					if (((5888 - (556 + 592)) >= (1121 + 2031)) and v25(v96.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v130 = 811 - (329 + 479);
			end
			if ((v130 == (857 - (174 + 680))) or ((8858 - 6280) >= (7026 - 3636))) then
				if (((30 + 11) <= (2400 - (396 + 343))) and v96.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v96.CrusadeBuff) and (v96.Crusade:CooldownRemains() > (2 + 13))) or (v15:BuffStack(v96.CrusadeBuff) == (1487 - (29 + 1448))) or (v96.AvengingWrath:CooldownRemains() < (1389.75 - (135 + 1254))) or (v96.AvengingWrath:CooldownRemains() > (56 - 41))) and (((v106 >= (18 - 14)) and (v10.CombatTime() < (4 + 1))) or ((v106 >= (1530 - (389 + 1138))) and (v10.CombatTime() > (579 - (102 + 472)))) or ((v106 >= (2 + 0)) and v96.DivineAuxiliary:IsAvailable())) and (((v104 > (5 + 3)) and not v96.ExecutionersWill:IsAvailable()) or (v104 > (12 + 0)))) then
					if (((2146 - (320 + 1225)) < (6337 - 2777)) and v25(v96.ExecutionSentence, not v17:IsSpellInRange(v96.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((144 + 91) < (2151 - (157 + 1307))) and v96.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v106 >= (1863 - (821 + 1038))) and (v10.CombatTime() < (12 - 7))) or ((v106 >= (1 + 2)) and (v10.CombatTime() > (8 - 3))) or ((v106 >= (1 + 1)) and v96.DivineAuxiliary:IsAvailable() and (v96.ExecutionSentence:CooldownUp() or v96.FinalReckoning:CooldownUp())))) then
					if (((11274 - 6725) > (2179 - (834 + 192))) and v25(v96.AvengingWrath, not v17:IsInRange(1 + 9))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v130 = 2 + 2;
			end
		end
	end
	local function v117()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (2 - 0)) or ((4978 - (300 + 4)) < (1248 + 3424))) then
				if (((9601 - 5933) < (4923 - (112 + 250))) and v96.TemplarsVerdict:IsReady() and v48 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (2 + 1))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (25 - 15))))) then
					if (v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict)) or ((261 + 194) == (1865 + 1740))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v132 == (1 + 0)) or ((1321 + 1342) == (2461 + 851))) then
				if (((5691 - (1001 + 413)) <= (9979 - 5504)) and v96.JusticarsVengeance:IsReady() and v44 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (885 - (244 + 638)))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (703 - (627 + 66)))))) then
					if (v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance)) or ((2592 - 1722) == (1791 - (512 + 90)))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((3459 - (1665 + 241)) <= (3850 - (373 + 344))) and v96.FinalVerdict:IsAvailable() and v96.FinalVerdict:IsCastable() and v48 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (2 + 1))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (3 + 7))))) then
					if (v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict)) or ((5900 - 3663) >= (5941 - 2430))) then
						return "final verdict finishers 6";
					end
				end
				v132 = 1101 - (35 + 1064);
			end
			if ((v132 == (0 + 0)) or ((2832 - 1508) > (13 + 3007))) then
				v108 = ((v102 >= (1239 - (298 + 938))) or ((v102 >= (1261 - (233 + 1026))) and not v96.DivineArbiter:IsAvailable()) or v15:BuffUp(v96.EmpyreanPowerBuff)) and v15:BuffDown(v96.EmpyreanLegacyBuff) and not (v15:BuffUp(v96.DivineArbiterBuff) and (v15:BuffStack(v96.DivineArbiterBuff) > (1690 - (636 + 1030))));
				if ((v96.DivineStorm:IsReady() and v39 and v108 and (not v96.Crusade:IsAvailable() or (v96.Crusade:CooldownRemains() > (v107 * (2 + 1))) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (10 + 0))))) or ((889 + 2103) == (128 + 1753))) then
					if (((3327 - (55 + 166)) > (296 + 1230)) and v25(v96.DivineStorm, not v17:IsInRange(2 + 8))) then
						return "divine_storm finishers 2";
					end
				end
				v132 = 3 - 2;
			end
		end
	end
	local function v118()
		local v133 = 297 - (36 + 261);
		while true do
			if (((5286 - 2263) < (5238 - (34 + 1334))) and ((0 + 0) == v133)) then
				if (((112 + 31) > (1357 - (1035 + 248))) and ((v106 >= (26 - (20 + 1))) or (v15:BuffUp(v96.EchoesofWrathBuff) and v15:HasTier(17 + 14, 323 - (134 + 185)) and v96.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v96.JudgmentDebuff) or (v106 == (1137 - (549 + 584)))) and v15:BuffUp(v96.DivineResonanceBuff) and not v15:HasTier(716 - (314 + 371), 6 - 4)))) then
					local v193 = 968 - (478 + 490);
					while true do
						if (((10 + 8) < (3284 - (786 + 386))) and (v193 == (0 - 0))) then
							v30 = v117();
							if (((2476 - (1055 + 324)) <= (2968 - (1093 + 247))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (((4115 + 515) == (487 + 4143)) and v96.WakeofAshes:IsCastable() and v47 and (v106 <= (7 - 5)) and (v96.AvengingWrath:CooldownDown() or v96.Crusade:CooldownDown()) and (not v96.ExecutionSentence:IsAvailable() or (v96.ExecutionSentence:CooldownRemains() > (13 - 9)) or (v104 < (22 - 14)))) then
					if (((8895 - 5355) > (955 + 1728)) and v25(v96.WakeofAshes, not v17:IsInRange(38 - 28))) then
						return "wake_of_ashes generators 2";
					end
				end
				if (((16523 - 11729) >= (2470 + 805)) and v96.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v96.ExpurgationDebuff) and (v106 <= (7 - 4)) and v15:HasTier(719 - (364 + 324), 5 - 3)) then
					if (((3560 - 2076) == (492 + 992)) and v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				v133 = 4 - 3;
			end
			if (((2292 - 860) < (10796 - 7241)) and (v133 == (1270 - (1249 + 19)))) then
				if ((v96.TemplarSlash:IsReady() and v45 and ((v96.TemplarStrike:TimeSinceLastCast() + v107) < (4 + 0)) and (v102 >= (7 - 5))) or ((2151 - (686 + 400)) > (2808 + 770))) then
					if (v25(v96.TemplarSlash, not v17:IsInRange(239 - (73 + 156))) or ((23 + 4772) < (2218 - (721 + 90)))) then
						return "templar_slash generators 8";
					end
				end
				if (((21 + 1832) < (15627 - 10814)) and v96.BladeofJustice:IsCastable() and v35 and ((v106 <= (473 - (224 + 246))) or not v96.HolyBlade:IsAvailable()) and (((v102 >= (2 - 0)) and not v96.CrusadingStrikes:IsAvailable()) or (v102 >= (6 - 2)))) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or ((512 + 2309) < (58 + 2373))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v96.HammerofWrath:IsReady() and v42 and ((v102 < (2 + 0)) or not v96.BlessedChampion:IsAvailable() or v15:HasTier(59 - 29, 12 - 8)) and ((v106 <= (516 - (203 + 310))) or (v17:HealthPercentage() > (2013 - (1238 + 755))) or not v96.VanguardsMomentum:IsAvailable())) or ((201 + 2673) < (3715 - (709 + 825)))) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((4954 - 2265) <= (498 - 155))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v133 = 867 - (196 + 668);
			end
			if (((15 - 11) == v133) or ((3871 - 2002) == (2842 - (171 + 662)))) then
				if ((v96.Judgment:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= (96 - (4 + 89))) or not v96.BoundlessJudgment:IsAvailable())) or ((12428 - 8882) < (846 + 1476))) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((9144 - 7062) == (1872 + 2901))) then
						return "judgment generators 20";
					end
				end
				if (((4730 - (35 + 1451)) > (2508 - (28 + 1425))) and ((v17:HealthPercentage() <= (2013 - (941 + 1052))) or v15:BuffUp(v96.AvengingWrathBuff) or v15:BuffUp(v96.CrusadeBuff) or v15:BuffUp(v96.EmpyreanPowerBuff))) then
					local v194 = 0 + 0;
					while true do
						if ((v194 == (1514 - (822 + 692))) or ((4729 - 1416) <= (838 + 940))) then
							v30 = v117();
							if (v30 or ((1718 - (45 + 252)) >= (2082 + 22))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((624 + 1188) <= (7906 - 4657)) and v96.Consecration:IsCastable() and v36 and v17:DebuffDown(v96.ConsecrationDebuff) and (v102 >= (435 - (114 + 319)))) then
					if (((2329 - 706) <= (2507 - 550)) and v25(v96.Consecration, not v17:IsInRange(7 + 3))) then
						return "consecration generators 22";
					end
				end
				v133 = 7 - 2;
			end
			if (((9244 - 4832) == (6375 - (556 + 1407))) and (v133 == (1209 - (741 + 465)))) then
				if (((2215 - (170 + 295)) >= (444 + 398)) and v96.TemplarSlash:IsReady() and v45 and ((v96.TemplarStrike:TimeSinceLastCast() + v107) < (4 + 0))) then
					if (((10763 - 6391) > (1534 + 316)) and v25(v96.TemplarSlash, not v17:IsSpellInRange(v96.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if (((149 + 83) < (465 + 356)) and v96.Judgment:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= (1233 - (957 + 273))) or not v96.BoundlessJudgment:IsAvailable())) then
					if (((139 + 379) < (362 + 540)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment generators 16";
					end
				end
				if (((11408 - 8414) > (2260 - 1402)) and v96.BladeofJustice:IsCastable() and v35 and ((v106 <= (9 - 6)) or not v96.HolyBlade:IsAvailable())) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or ((18593 - 14838) <= (2695 - (389 + 1391)))) then
						return "blade_of_justice generators 18";
					end
				end
				v133 = 3 + 1;
			end
			if (((411 + 3535) > (8521 - 4778)) and (v133 == (952 - (783 + 168)))) then
				if ((v96.DivineToll:IsCastable() and v40 and (v106 <= (6 - 4)) and ((v96.AvengingWrath:CooldownRemains() > (15 + 0)) or (v96.Crusade:CooldownRemains() > (326 - (309 + 2))) or (v104 < (24 - 16)))) or ((2547 - (1090 + 122)) >= (1072 + 2234))) then
					if (((16268 - 11424) > (1542 + 711)) and v25(v96.DivineToll, not v17:IsInRange(1148 - (628 + 490)))) then
						return "divine_toll generators 6";
					end
				end
				if (((82 + 370) == (1118 - 666)) and v96.Judgment:IsReady() and v43 and v17:DebuffUp(v96.ExpurgationDebuff) and v15:BuffDown(v96.EchoesofWrathBuff) and v15:HasTier(141 - 110, 776 - (431 + 343))) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((9202 - 4645) < (6037 - 3950))) then
						return "judgment generators 7";
					end
				end
				if (((3061 + 813) == (496 + 3378)) and (v106 >= (1698 - (556 + 1139))) and v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < (25 - (6 + 9)))) then
					local v195 = 0 + 0;
					while true do
						if (((0 + 0) == v195) or ((2107 - (28 + 141)) > (1912 + 3023))) then
							v30 = v117();
							if (v30 or ((5252 - 997) < (2425 + 998))) then
								return v30;
							end
							break;
						end
					end
				end
				v133 = 1319 - (486 + 831);
			end
			if (((3783 - 2329) <= (8769 - 6278)) and ((2 + 4) == v133)) then
				if (v30 or ((13144 - 8987) <= (4066 - (668 + 595)))) then
					return v30;
				end
				if (((4367 + 486) >= (602 + 2380)) and v96.TemplarSlash:IsReady() and v45) then
					if (((11273 - 7139) > (3647 - (23 + 267))) and v25(v96.TemplarSlash, not v17:IsInRange(1954 - (1129 + 815)))) then
						return "templar_slash generators 28";
					end
				end
				if ((v96.TemplarStrike:IsReady() and v46) or ((3804 - (371 + 16)) < (4284 - (1326 + 424)))) then
					if (v25(v96.TemplarStrike, not v17:IsInRange(18 - 8)) or ((9946 - 7224) <= (282 - (88 + 30)))) then
						return "templar_strike generators 30";
					end
				end
				v133 = 778 - (720 + 51);
			end
			if ((v133 == (15 - 8)) or ((4184 - (421 + 1355)) < (3478 - 1369))) then
				if ((v96.Judgment:IsReady() and v43 and ((v106 <= (2 + 1)) or not v96.BoundlessJudgment:IsAvailable())) or ((1116 - (286 + 797)) == (5318 - 3863))) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((732 - 289) >= (4454 - (397 + 42)))) then
						return "judgment generators 32";
					end
				end
				if (((1057 + 2325) > (966 - (24 + 776))) and v96.HammerofWrath:IsReady() and v42 and ((v106 <= (4 - 1)) or (v17:HealthPercentage() > (805 - (222 + 563))) or not v96.VanguardsMomentum:IsAvailable())) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((616 - 336) == (2203 + 856))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((2071 - (23 + 167)) > (3091 - (690 + 1108))) and v96.CrusaderStrike:IsCastable() and v37) then
					if (((851 + 1506) == (1945 + 412)) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v133 = 856 - (40 + 808);
			end
			if (((21 + 102) == (470 - 347)) and (v133 == (5 + 0))) then
				if ((v96.DivineHammer:IsCastable() and v38 and (v102 >= (2 + 0))) or ((580 + 476) >= (3963 - (47 + 524)))) then
					if (v25(v96.DivineHammer, not v17:IsInRange(7 + 3)) or ((2954 - 1873) < (1607 - 532))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v96.CrusaderStrike:IsCastable() and v37 and (v96.CrusaderStrike:ChargesFractional() >= (2.75 - 1)) and ((v106 <= (1728 - (1165 + 561))) or ((v106 <= (1 + 2)) and (v96.BladeofJustice:CooldownRemains() > (v107 * (6 - 4)))) or ((v106 == (2 + 2)) and (v96.BladeofJustice:CooldownRemains() > (v107 * (481 - (341 + 138)))) and (v96.Judgment:CooldownRemains() > (v107 * (1 + 1)))))) or ((2164 - 1115) >= (4758 - (89 + 237)))) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or ((15338 - 10570) <= (1780 - 934))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v117();
				v133 = 887 - (581 + 300);
			end
			if ((v133 == (1228 - (855 + 365))) or ((7975 - 4617) <= (464 + 956))) then
				if ((v96.ArcaneTorrent:IsCastable() and ((v86 and v33) or not v86) and v85 and (v106 < (1240 - (1030 + 205))) and (v82 < v104)) or ((3511 + 228) <= (2796 + 209))) then
					if (v25(v96.ArcaneTorrent, not v17:IsInRange(296 - (156 + 130))) or ((3769 - 2110) >= (3596 - 1462))) then
						return "arcane_torrent generators 28";
					end
				end
				if ((v96.Consecration:IsCastable() and v36) or ((6676 - 3416) < (621 + 1734))) then
					if (v25(v96.Consecration, not v17:IsInRange(6 + 4)) or ((738 - (10 + 59)) == (1195 + 3028))) then
						return "consecration generators 30";
					end
				end
				if ((v96.DivineHammer:IsCastable() and v38) or ((8332 - 6640) < (1751 - (671 + 492)))) then
					if (v25(v96.DivineHammer, not v17:IsInRange(8 + 2)) or ((6012 - (369 + 846)) < (967 + 2684))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
		end
	end
	local function v119()
		v35 = EpicSettings.Settings['useBladeofJustice'];
		v36 = EpicSettings.Settings['useConsecration'];
		v37 = EpicSettings.Settings['useCrusaderStrike'];
		v38 = EpicSettings.Settings['useDivineHammer'];
		v39 = EpicSettings.Settings['useDivineStorm'];
		v40 = EpicSettings.Settings['useDivineToll'];
		v41 = EpicSettings.Settings['useExecutionSentence'];
		v42 = EpicSettings.Settings['useHammerofWrath'];
		v43 = EpicSettings.Settings['useJudgment'];
		v44 = EpicSettings.Settings['useJusticarsVengeance'];
		v45 = EpicSettings.Settings['useTemplarSlash'];
		v46 = EpicSettings.Settings['useTemplarStrike'];
		v47 = EpicSettings.Settings['useWakeofAshes'];
		v48 = EpicSettings.Settings['useVerdict'];
		v49 = EpicSettings.Settings['useAvengingWrath'];
		v50 = EpicSettings.Settings['useCrusade'];
		v51 = EpicSettings.Settings['useFinalReckoning'];
		v52 = EpicSettings.Settings['useShieldofVengeance'];
		v53 = EpicSettings.Settings['avengingWrathWithCD'];
		v54 = EpicSettings.Settings['crusadeWithCD'];
		v55 = EpicSettings.Settings['finalReckoningWithCD'];
		v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v120()
		local v156 = 0 + 0;
		while true do
			if (((1945 - (1036 + 909)) == v156) or ((3322 + 855) > (8142 - 3292))) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v60 = EpicSettings.Settings['useDivineShield'];
				v156 = 204 - (11 + 192);
			end
			if ((v156 == (1 + 0)) or ((575 - (135 + 40)) > (2691 - 1580))) then
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v156 = 2 + 0;
			end
			if (((6721 - 3670) > (1506 - 501)) and (v156 == (178 - (50 + 126)))) then
				v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v66 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
				v67 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v68 = EpicSettings.Settings['layonHandsHP'] or (1413 - (1233 + 180));
				v156 = 972 - (522 + 447);
			end
			if (((5114 - (107 + 1314)) <= (2034 + 2348)) and (v156 == (11 - 7))) then
				v73 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v74 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v94 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v156 == (2 + 1)) or ((6516 - 3234) > (16222 - 12122))) then
				v69 = EpicSettings.Settings['layonHandsFocusHP'] or (1910 - (716 + 1194));
				v70 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v71 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v72 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (503 - (74 + 429));
				v156 = 7 - 3;
			end
		end
	end
	local function v121()
		local v157 = 0 + 0;
		while true do
			if ((v157 == (0 - 0)) or ((2533 + 1047) < (8767 - 5923))) then
				v82 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v79 = EpicSettings.Settings['InterruptWithStun'];
				v80 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v157 = 434 - (279 + 154);
			end
			if (((867 - (454 + 324)) < (3533 + 957)) and (v157 == (19 - (12 + 5)))) then
				v83 = EpicSettings.Settings['useTrinkets'];
				v85 = EpicSettings.Settings['useRacials'];
				v84 = EpicSettings.Settings['trinketsWithCD'];
				v157 = 2 + 1;
			end
			if ((v157 == (7 - 4)) or ((1842 + 3141) < (2901 - (277 + 816)))) then
				v86 = EpicSettings.Settings['racialsWithCD'];
				v88 = EpicSettings.Settings['useHealthstone'];
				v87 = EpicSettings.Settings['useHealingPotion'];
				v157 = 17 - 13;
			end
			if (((5012 - (1058 + 125)) > (707 + 3062)) and (v157 == (981 - (815 + 160)))) then
				v93 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((3525 - 2040) <= (693 + 2211)) and (v157 == (2 - 1))) then
				v81 = EpicSettings.Settings['InterruptThreshold'];
				v76 = EpicSettings.Settings['DispelDebuffs'];
				v75 = EpicSettings.Settings['DispelBuffs'];
				v157 = 1900 - (41 + 1857);
			end
			if (((6162 - (1222 + 671)) == (11033 - 6764)) and (v157 == (5 - 1))) then
				v90 = EpicSettings.Settings['healthstoneHP'] or (1182 - (229 + 953));
				v89 = EpicSettings.Settings['healingPotionHP'] or (1774 - (1111 + 663));
				v91 = EpicSettings.Settings['HealingPotionName'] or "";
				v157 = 1584 - (874 + 705);
			end
			if (((55 + 332) <= (1899 + 883)) and (v157 == (10 - 5))) then
				v77 = EpicSettings.Settings['handleAfflicted'];
				v78 = EpicSettings.Settings['HandleIncorporeal'];
				v92 = EpicSettings.Settings['HealOOC'];
				v157 = 1 + 5;
			end
		end
	end
	local function v122()
		local v158 = 679 - (642 + 37);
		while true do
			if ((v158 == (0 + 0)) or ((304 + 1595) <= (2302 - 1385))) then
				v120();
				v119();
				v121();
				v158 = 455 - (233 + 221);
			end
			if ((v158 == (8 - 4)) or ((3796 + 516) <= (2417 - (718 + 823)))) then
				if (((1405 + 827) <= (3401 - (266 + 539))) and v34) then
					local v196 = 0 - 0;
					local v197;
					while true do
						if (((3320 - (636 + 589)) < (8749 - 5063)) and (v196 == (1 - 0))) then
							v197 = v95.LowestFriendlyUnit(32 + 8, "TANK", 10 + 15);
							if ((v96.BlessingofFreedom:IsReady() and v95.UnitHasDebuffFromList(v197, v19.Paladin.FreedomDebuffTankList) and v95.FocusSpecifiedUnit(v197, 1055 - (657 + 358))) or ((4223 - 2628) >= (10192 - 5718))) then
								if (v25(v100.BlessingofFreedomFocus) or ((5806 - (1151 + 36)) < (2784 + 98))) then
									return "blessing_of_freedom combat";
								end
							end
							v196 = 1 + 1;
						end
						if ((v196 == (5 - 3)) or ((2126 - (1552 + 280)) >= (5665 - (64 + 770)))) then
							if (((1378 + 651) <= (7000 - 3916)) and v96.BlessingofFreedom:IsReady() and v95.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (v25(v100.BlessingofFreedomFocus) or ((362 + 1675) == (3663 - (157 + 1086)))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((8923 - 4465) > (17098 - 13194)) and (v196 == (0 - 0))) then
							v30 = v95.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 54 - 14, 844 - (599 + 220));
							if (((867 - 431) >= (2054 - (1813 + 118))) and v30) then
								return v30;
							end
							v196 = 1 + 0;
						end
					end
				end
				v105 = v109();
				if (((1717 - (841 + 376)) < (2543 - 727)) and not v15:AffectingCombat()) then
					if (((831 + 2743) == (9755 - 6181)) and v96.RetributionAura:IsCastable() and (v110())) then
						if (((1080 - (464 + 395)) < (1000 - 610)) and v25(v96.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				v158 = 3 + 2;
			end
			if (((843 - (467 + 370)) == v158) or ((4572 - 2359) <= (1044 + 377))) then
				if (((10482 - 7424) < (759 + 4101)) and (v95.TargetIsValid() or v15:AffectingCombat())) then
					v103 = v10.BossFightRemains(nil, true);
					v104 = v103;
					if ((v104 == (25850 - 14739)) or ((1816 - (150 + 370)) >= (5728 - (74 + 1208)))) then
						v104 = v10.FightRemains(v101, false);
					end
					v107 = v15:GCD();
					v106 = v15:HolyPower();
				end
				if (v77 or ((3426 - 2033) > (21289 - 16800))) then
					local v198 = 0 + 0;
					while true do
						if ((v198 == (390 - (14 + 376))) or ((7672 - 3248) < (18 + 9))) then
							if (v73 or ((1755 + 242) > (3639 + 176))) then
								local v203 = 0 - 0;
								while true do
									if (((2607 + 858) > (1991 - (23 + 55))) and (v203 == (0 - 0))) then
										v30 = v95.HandleAfflicted(v96.CleanseToxins, v100.CleanseToxinsMouseover, 27 + 13);
										if (((659 + 74) < (2819 - 1000)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v74 and (v106 > (1 + 1))) or ((5296 - (652 + 249)) == (12725 - 7970))) then
								v30 = v95.HandleAfflicted(v96.WordofGlory, v100.WordofGloryMouseover, 1908 - (708 + 1160), true);
								if (v30 or ((10295 - 6502) < (4318 - 1949))) then
									return v30;
								end
							end
							break;
						end
					end
				end
				if (v78 or ((4111 - (10 + 17)) == (60 + 205))) then
					v30 = v95.HandleIncorporeal(v96.Repentance, v100.RepentanceMouseOver, 1762 - (1400 + 332), true);
					if (((8358 - 4000) == (6266 - (242 + 1666))) and v30) then
						return v30;
					end
					v30 = v95.HandleIncorporeal(v96.TurnEvil, v100.TurnEvilMouseOver, 13 + 17, true);
					if (v30 or ((1151 + 1987) < (847 + 146))) then
						return v30;
					end
				end
				v158 = 947 - (850 + 90);
			end
			if (((5832 - 2502) > (3713 - (360 + 1030))) and ((8 + 0) == v158)) then
				v30 = v113();
				if (v30 or ((10234 - 6608) == (5487 - 1498))) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v95.TargetIsValid()) or ((2577 - (909 + 752)) == (3894 - (109 + 1114)))) then
					v30 = v115();
					if (((497 - 225) == (106 + 166)) and v30) then
						return v30;
					end
				end
				v158 = 251 - (6 + 236);
			end
			if (((2678 + 1571) <= (3896 + 943)) and (v158 == (2 - 1))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v158 = 3 - 1;
			end
			if (((3910 - (1076 + 57)) < (527 + 2673)) and ((696 - (579 + 110)) == v158)) then
				v30 = v112();
				if (((8 + 87) < (1731 + 226)) and v30) then
					return v30;
				end
				if (((439 + 387) < (2124 - (174 + 233))) and v14) then
					if (((3983 - 2557) >= (1939 - 834)) and v76) then
						local v201 = 0 + 0;
						while true do
							if (((3928 - (663 + 511)) <= (3015 + 364)) and (v201 == (0 + 0))) then
								v30 = v111();
								if (v30 or ((12106 - 8179) == (856 + 557))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v158 = 18 - 10;
			end
			if ((v158 == (7 - 4)) or ((551 + 603) <= (1533 - 745))) then
				if (v32 or ((1171 + 472) > (309 + 3070))) then
					v102 = #v101;
				else
					local v199 = 722 - (478 + 244);
					while true do
						if ((v199 == (517 - (440 + 77))) or ((1275 + 1528) > (16649 - 12100))) then
							v101 = {};
							v102 = 1557 - (655 + 901);
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((41 + 179) >= (2314 + 708))) then
					if (((1906 + 916) == (11368 - 8546)) and v96.CrusaderAura:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
						if (v25(v96.CrusaderAura) or ((2506 - (695 + 750)) == (6341 - 4484))) then
							return "crusader_aura";
						end
					end
				end
				if (((4259 - 1499) > (5485 - 4121)) and (v15:AffectingCombat() or v76)) then
					local v200 = v76 and v96.CleanseToxins:IsReady() and v34;
					v30 = v95.FocusUnit(v200, v100, 371 - (285 + 66), nil, 58 - 33);
					if (v30 or ((6212 - (682 + 628)) <= (580 + 3015))) then
						return v30;
					end
				end
				v158 = 303 - (176 + 123);
			end
			if (((4 + 5) == v158) or ((2795 + 1057) == (562 - (239 + 30)))) then
				if ((v15:AffectingCombat() and v95.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((424 + 1135) == (4410 + 178))) then
					if ((v61 and (v15:HealthPercentage() <= v68) and v96.LayonHands:IsReady() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((7936 - 3452) == (2458 - 1670))) then
						if (((4883 - (306 + 9)) >= (13633 - 9726)) and v25(v96.LayonHands)) then
							return "lay_on_hands_player defensive";
						end
					end
					if (((217 + 1029) < (2130 + 1340)) and v60 and (v15:HealthPercentage() <= v67) and v96.DivineShield:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
						if (((1959 + 2109) >= (2779 - 1807)) and v25(v96.DivineShield)) then
							return "divine_shield defensive";
						end
					end
					if (((1868 - (1140 + 235)) < (2478 + 1415)) and v59 and v96.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v66)) then
						if (v25(v96.DivineProtection) or ((1351 + 122) >= (856 + 2476))) then
							return "divine_protection defensive";
						end
					end
					if ((v97.Healthstone:IsReady() and v88 and (v15:HealthPercentage() <= v90)) or ((4103 - (33 + 19)) <= (418 + 739))) then
						if (((1810 - 1206) < (1270 + 1611)) and v25(v100.Healthstone)) then
							return "healthstone defensive";
						end
					end
					if ((v87 and (v15:HealthPercentage() <= v89)) or ((1764 - 864) == (3167 + 210))) then
						if (((5148 - (586 + 103)) > (54 + 537)) and (v91 == "Refreshing Healing Potion")) then
							if (((10461 - 7063) >= (3883 - (1309 + 179))) and v97.RefreshingHealingPotion:IsReady()) then
								if (v25(v100.RefreshingHealingPotion) or ((3940 - 1757) >= (1230 + 1594))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((5199 - 3263) == (1463 + 473)) and (v91 == "Dreamwalker's Healing Potion")) then
							if (v97.DreamwalkersHealingPotion:IsReady() or ((10266 - 5434) < (8593 - 4280))) then
								if (((4697 - (295 + 314)) > (9514 - 5640)) and v25(v100.RefreshingHealingPotion)) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
					end
					if (((6294 - (1300 + 662)) == (13603 - 9271)) and (v82 < v104)) then
						local v202 = 1755 - (1178 + 577);
						while true do
							if (((2077 + 1922) >= (8573 - 5673)) and (v202 == (1405 - (851 + 554)))) then
								v30 = v116();
								if (v30 or ((2233 + 292) > (11270 - 7206))) then
									return v30;
								end
								break;
							end
						end
					end
					v30 = v118();
					if (((9492 - 5121) == (4673 - (115 + 187))) and v30) then
						return v30;
					end
					if (v25(v96.Pool) or ((204 + 62) > (4721 + 265))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if (((7845 - 5854) >= (2086 - (160 + 1001))) and (v158 == (2 + 0))) then
				v34 = EpicSettings.Toggles['dispel'];
				if (((314 + 141) < (4202 - 2149)) and v15:IsDeadOrGhost()) then
					return v30;
				end
				v101 = v15:GetEnemiesInMeleeRange(366 - (237 + 121));
				v158 = 900 - (525 + 372);
			end
			if ((v158 == (9 - 4)) or ((2713 - 1887) == (4993 - (96 + 46)))) then
				if (((960 - (643 + 134)) == (67 + 116)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (((2778 - 1619) <= (6638 - 4850)) and v15:AffectingCombat()) then
						if (v96.Intercession:IsCastable() or ((3364 + 143) > (8473 - 4155))) then
							if (v25(v96.Intercession, not v17:IsInRange(61 - 31), true) or ((3794 - (316 + 403)) <= (1971 + 994))) then
								return "intercession target";
							end
						end
					elseif (((3752 - 2387) <= (727 + 1284)) and v96.Redemption:IsCastable()) then
						if (v25(v96.Redemption, not v17:IsInRange(75 - 45), true) or ((1968 + 808) > (1153 + 2422))) then
							return "redemption target";
						end
					end
				end
				if ((v96.Redemption:IsCastable() and v96.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((8849 - 6295) == (22943 - 18139))) then
					if (((5353 - 2776) == (148 + 2429)) and v25(v100.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((11 - 5) >= (93 + 1796))) then
					if (((1488 - 982) <= (1909 - (12 + 5))) and v96.Intercession:IsCastable() and (v15:HolyPower() >= (11 - 8)) and v96.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v100.IntercessionMouseover) or ((4284 - 2276) > (4714 - 2496))) then
							return "Intercession mouseover";
						end
					end
				end
				v158 = 14 - 8;
			end
		end
	end
	local function v123()
		local v159 = 0 + 0;
		while true do
			if (((2352 - (1656 + 317)) <= (3696 + 451)) and (v159 == (0 + 0))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v99();
				break;
			end
		end
	end
	v21.SetAPL(186 - 116, v122, v123);
end;
return v0["Epix_Paladin_Retribution.lua"]();

