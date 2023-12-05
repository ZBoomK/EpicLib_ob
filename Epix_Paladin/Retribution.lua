local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4132 - (240 + 619)) == (790 + 2483)) and not v5) then
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
	local v94 = v20.Commons.Everyone;
	local v95 = v18.Paladin.Retribution;
	local v96 = v19.Paladin.Retribution;
	local v97 = {};
	local function v98()
		if (((6082 - 2258) > (28 + 381)) and v95.CleanseToxins:IsAvailable()) then
			v94.DispellableDebuffs = v12.MergeTable(v94.DispellableDiseaseDebuffs, v94.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v98();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v99 = v23.Paladin.Retribution;
	local v100;
	local v101;
	local v102 = 12855 - (1344 + 400);
	local v103 = 11516 - (255 + 150);
	local v104;
	local v105 = 0 + 0;
	local v106 = 0 + 0;
	local v107;
	v9:RegisterForEvent(function()
		local v123 = 0 - 0;
		while true do
			if (((6740 - 4653) == (3826 - (404 + 1335))) and (v123 == (406 - (183 + 223)))) then
				v102 = 13520 - 2409;
				v103 = 7363 + 3748;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v108()
		local v124 = v14:GCDRemains();
		local v125 = v27(v95.CrusaderStrike:CooldownRemains(), v95.BladeofJustice:CooldownRemains(), v95.Judgment:CooldownRemains(), (v95.HammerofWrath:IsUsable() and v95.HammerofWrath:CooldownRemains()) or (4 + 6), v95.WakeofAshes:CooldownRemains());
		if ((v124 > v125) or ((3741 - (10 + 327)) > (3136 + 1367))) then
			return v124;
		end
		return v125;
	end
	local function v109()
		return v14:BuffDown(v95.RetributionAura) and v14:BuffDown(v95.DevotionAura) and v14:BuffDown(v95.ConcentrationAura) and v14:BuffDown(v95.CrusaderAura);
	end
	local function v110()
		if ((v95.CleanseToxins:IsReady() and v33 and v94.DispellableFriendlyUnit(363 - (118 + 220))) or ((1169 + 2337) <= (1758 - (108 + 341)))) then
			if (((1328 + 1627) == (12493 - 9538)) and v24(v99.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v111()
		if ((v91 and (v14:HealthPercentage() <= v92)) or ((4396 - (711 + 782)) == (2865 - 1370))) then
			if (((5015 - (270 + 199)) >= (738 + 1537)) and v95.FlashofLight:IsReady()) then
				if (((2638 - (580 + 1239)) >= (65 - 43)) and v24(v95.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v112()
		local v126 = 0 + 0;
		while true do
			if (((114 + 3048) == (1378 + 1784)) and (v126 == (0 - 0))) then
				if (not v13 or not v13:Exists() or not v13:IsInRange(19 + 11) or ((3536 - (645 + 522)) > (6219 - (1010 + 780)))) then
					return;
				end
				if (((4093 + 2) >= (15163 - 11980)) and v13) then
					if ((v95.WordofGlory:IsReady() and v62 and (v13:HealthPercentage() <= v69)) or ((10874 - 7163) < (2844 - (1045 + 791)))) then
						if (v24(v99.WordofGloryFocus) or ((2654 - 1605) <= (1383 - 477))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((5018 - (351 + 154)) > (4300 - (1281 + 293))) and v95.LayonHands:IsCastable() and v61 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v68)) then
						if (v24(v99.LayonHandsFocus) or ((1747 - (28 + 238)) >= (5938 - 3280))) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v95.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v71)) or ((4779 - (1381 + 178)) == (1280 + 84))) then
						if (v24(v99.BlessingofSacrificeFocus) or ((850 + 204) > (1447 + 1945))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v95.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v70)) or ((2330 - 1654) >= (851 + 791))) then
						if (((4606 - (381 + 89)) > (2126 + 271)) and v24(v99.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (1 - 0)) or ((5490 - (1074 + 82)) == (9302 - 5057))) then
				v29 = v94.HandleBottomTrinket(v97, v32, 1824 - (214 + 1570), nil);
				if (v29 or ((5731 - (990 + 465)) <= (1250 + 1781))) then
					return v29;
				end
				break;
			end
			if ((v127 == (0 + 0)) or ((4651 + 131) <= (4718 - 3519))) then
				v29 = v94.HandleTopTrinket(v97, v32, 1766 - (1668 + 58), nil);
				if (v29 or ((5490 - (512 + 114)) < (4958 - 3056))) then
					return v29;
				end
				v127 = 1 - 0;
			end
		end
	end
	local function v114()
		local v128 = 0 - 0;
		while true do
			if (((2252 + 2587) >= (693 + 3007)) and (v128 == (1 + 0))) then
				if ((v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsReady() and v47 and (v105 >= (13 - 9))) or ((3069 - (109 + 1885)) > (3387 - (1269 + 200)))) then
					if (((758 - 362) <= (4619 - (98 + 717))) and v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				if ((v95.TemplarsVerdict:IsReady() and v47 and (v105 >= (830 - (802 + 24)))) or ((7189 - 3020) == (2761 - 574))) then
					if (((208 + 1198) == (1081 + 325)) and v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				v128 = 1 + 1;
			end
			if (((331 + 1200) < (11881 - 7610)) and (v128 == (6 - 4))) then
				if (((228 + 407) == (259 + 376)) and v95.BladeofJustice:IsCastable() and v34) then
					if (((2783 + 590) <= (2586 + 970)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				if ((v95.Judgment:IsCastable() and v42) or ((1537 + 1754) < (4713 - (797 + 636)))) then
					if (((21295 - 16909) >= (2492 - (1427 + 192))) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment precombat 6";
					end
				end
				v128 = 2 + 1;
			end
			if (((2138 - 1217) <= (991 + 111)) and (v128 == (0 + 0))) then
				if (((5032 - (192 + 134)) >= (2239 - (316 + 960))) and v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55)) then
					if (v24(v95.ShieldofVengeance) or ((535 + 425) <= (677 + 199))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v95.JusticarsVengeance:IsAvailable() and v95.JusticarsVengeance:IsReady() and v43 and (v105 >= (4 + 0))) or ((7898 - 5832) == (1483 - (83 + 468)))) then
					if (((6631 - (1202 + 604)) < (22608 - 17765)) and v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v128 = 1 - 0;
			end
			if ((v128 == (8 - 5)) or ((4202 - (45 + 280)) >= (4380 + 157))) then
				if ((v95.HammerofWrath:IsReady() and v41) or ((3770 + 545) < (631 + 1095))) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((2036 + 1643) < (110 + 515))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if ((v95.CrusaderStrike:IsCastable() and v36) or ((8564 - 3939) < (2543 - (340 + 1571)))) then
					if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((33 + 50) > (3552 - (1733 + 39)))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v129 = v94.HandleDPSPotion(v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14.BuffStack(v95.Crusade) == (27 - 17))) or (v103 < (1059 - (125 + 909))));
		if (((2494 - (1096 + 852)) <= (484 + 593)) and v129) then
			return v129;
		end
		if ((v95.LightsJudgment:IsCastable() and v84 and ((v85 and v32) or not v85)) or ((1421 - 425) > (4172 + 129))) then
			if (((4582 - (409 + 103)) > (923 - (46 + 190))) and v24(v95.LightsJudgment, not v16:IsInRange(135 - (51 + 44)))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v95.Fireblood:IsCastable() and v84 and ((v85 and v32) or not v85) and (v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) == (3 + 7))))) or ((1973 - (1114 + 203)) >= (4056 - (228 + 498)))) then
			if (v24(v95.Fireblood, not v16:IsInRange(3 + 7)) or ((1377 + 1115) <= (998 - (174 + 489)))) then
				return "fireblood cooldowns 6";
			end
		end
		if (((11259 - 6937) >= (4467 - (830 + 1075))) and v82 and ((v32 and v83) or not v83) and v16:IsInRange(532 - (303 + 221))) then
			v29 = v113();
			if (v29 or ((4906 - (231 + 1038)) >= (3142 + 628))) then
				return v29;
			end
		end
		if ((v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55) and (v103 > (1177 - (171 + 991))) and (not v95.ExecutionSentence:IsAvailable() or v16:DebuffDown(v95.ExecutionSentence))) or ((9804 - 7425) > (12292 - 7714))) then
			if (v24(v95.ShieldofVengeance) or ((1205 - 722) > (595 + 148))) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((8602 - 6148) > (1667 - 1089)) and v95.ExecutionSentence:IsCastable() and v40 and ((v14:BuffDown(v95.CrusadeBuff) and (v95.Crusade:CooldownRemains() > (24 - 9))) or (v14:BuffStack(v95.CrusadeBuff) == (30 - 20)) or (v95.AvengingWrath:CooldownRemains() < (1248.75 - (111 + 1137))) or (v95.AvengingWrath:CooldownRemains() > (173 - (91 + 67)))) and (((v105 >= (11 - 7)) and (v9.CombatTime() < (2 + 3))) or ((v105 >= (526 - (423 + 100))) and (v9.CombatTime() > (1 + 4))) or ((v105 >= (5 - 3)) and v95.DivineAuxiliary:IsAvailable())) and (((v103 > (5 + 3)) and not v95.ExecutionersWill:IsAvailable()) or (v103 > (783 - (326 + 445))))) then
			if (((4058 - 3128) < (9931 - 5473)) and v24(v95.ExecutionSentence, not v16:IsSpellInRange(v95.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((1544 - 882) <= (1683 - (530 + 181))) and v95.AvengingWrath:IsCastable() and v48 and ((v32 and v52) or not v52) and (((v105 >= (885 - (614 + 267))) and (v9.CombatTime() < (37 - (19 + 13)))) or ((v105 >= (4 - 1)) and (v9.CombatTime() > (11 - 6))) or ((v105 >= (5 - 3)) and v95.DivineAuxiliary:IsAvailable() and (v95.ExecutionSentence:CooldownUp() or v95.FinalReckoning:CooldownUp())))) then
			if (((1135 + 3235) == (7685 - 3315)) and v24(v95.AvengingWrath, not v16:IsInRange(20 - 10))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if ((v95.Crusade:IsCastable() and v49 and ((v32 and v53) or not v53) and (((v105 >= (1816 - (1293 + 519))) and (v9.CombatTime() < (10 - 5))) or ((v105 >= (7 - 4)) and (v9.CombatTime() >= (9 - 4))))) or ((20534 - 15772) <= (2028 - 1167))) then
			if (v24(v95.Crusade, not v16:IsInRange(6 + 4)) or ((289 + 1123) == (9907 - 5643))) then
				return "crusade cooldowns 14";
			end
		end
		if ((v95.FinalReckoning:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v105 >= (1 + 3)) and (v9.CombatTime() < (3 + 5))) or ((v105 >= (2 + 1)) and (v9.CombatTime() >= (1104 - (709 + 387)))) or ((v105 >= (1860 - (673 + 1185))) and v95.DivineAuxiliary:IsAvailable())) and ((v95.AvengingWrath:CooldownRemains() > (29 - 19)) or (v95.Crusade:CooldownDown() and (v14:BuffDown(v95.CrusadeBuff) or (v14:BuffStack(v95.CrusadeBuff) >= (32 - 22))))) and ((v104 > (0 - 0)) or (v105 == (4 + 1)) or ((v105 >= (2 + 0)) and v95.DivineAuxiliary:IsAvailable()))) or ((4276 - 1108) < (529 + 1624))) then
			if ((v93 == "player") or ((9921 - 4945) < (2614 - 1282))) then
				if (((6508 - (446 + 1434)) == (5911 - (1040 + 243))) and v24(v99.FinalReckoningPlayer, not v16:IsInRange(29 - 19))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if ((v93 == "cursor") or ((1901 - (559 + 1288)) == (2326 - (609 + 1322)))) then
				if (((536 - (13 + 441)) == (306 - 224)) and v24(v99.FinalReckoningCursor, not v16:IsInRange(52 - 32))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v116()
		v107 = ((v101 >= (14 - 11)) or ((v101 >= (1 + 1)) and not v95.DivineArbiter:IsAvailable()) or v14:BuffUp(v95.EmpyreanPowerBuff)) and v14:BuffDown(v95.EmpyreanLegacyBuff) and not (v14:BuffUp(v95.DivineArbiterBuff) and (v14:BuffStack(v95.DivineArbiterBuff) > (87 - 63)));
		if ((v95.DivineStorm:IsReady() and v38 and v107 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (2 + 1))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (5 + 5))))) or ((1724 - 1143) < (155 + 127))) then
			if (v24(v95.DivineStorm, not v16:IsInRange(18 - 8)) or ((3048 + 1561) < (1388 + 1107))) then
				return "divine_storm finishers 2";
			end
		end
		if (((828 + 324) == (968 + 184)) and v95.JusticarsVengeance:IsReady() and v43 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (3 + 0))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (443 - (153 + 280)))))) then
			if (((5474 - 3578) <= (3073 + 349)) and v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsCastable() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (2 + 1))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (6 + 4))))) or ((899 + 91) > (1174 + 446))) then
			if (v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict)) or ((1334 - 457) > (2902 + 1793))) then
				return "final verdict finishers 6";
			end
		end
		if (((3358 - (89 + 578)) >= (1323 + 528)) and v95.TemplarsVerdict:IsReady() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (5 - 2))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (1059 - (572 + 477)))))) then
			if (v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict)) or ((403 + 2582) >= (2915 + 1941))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v117()
		if (((511 + 3765) >= (1281 - (84 + 2))) and ((v105 >= (8 - 3)) or (v14:BuffUp(v95.EchoesofWrathBuff) and v14:HasTier(23 + 8, 846 - (497 + 345)) and v95.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v95.JudgmentDebuff) or (v105 == (1 + 3))) and v14:BuffUp(v95.DivineResonanceBuff) and not v14:HasTier(6 + 25, 1335 - (605 + 728))))) then
			v29 = v116();
			if (((2306 + 926) <= (10427 - 5737)) and v29) then
				return v29;
			end
		end
		if ((v95.WakeofAshes:IsCastable() and v46 and (v105 <= (1 + 1)) and (v95.AvengingWrath:CooldownDown() or v95.Crusade:CooldownDown()) and (not v95.ExecutionSentence:IsAvailable() or (v95.ExecutionSentence:CooldownRemains() > (14 - 10)) or (v103 < (8 + 0)))) or ((2482 - 1586) >= (2376 + 770))) then
			if (((3550 - (457 + 32)) >= (1256 + 1702)) and v24(v95.WakeofAshes, not v16:IsInRange(1412 - (832 + 570)))) then
				return "wake_of_ashes generators 2";
			end
		end
		if (((3003 + 184) >= (168 + 476)) and v95.BladeofJustice:IsCastable() and v34 and not v16:DebuffUp(v95.ExpurgationDebuff) and (v105 <= (10 - 7)) and v14:HasTier(15 + 16, 798 - (588 + 208))) then
			if (((1735 - 1091) <= (2504 - (884 + 916))) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
				return "blade_of_justice generators 4";
			end
		end
		if (((2005 - 1047) > (550 + 397)) and v95.DivineToll:IsCastable() and v39 and (v105 <= (655 - (232 + 421))) and ((v95.AvengingWrath:CooldownRemains() > (1904 - (1569 + 320))) or (v95.Crusade:CooldownRemains() > (4 + 11)) or (v103 < (2 + 6)))) then
			if (((15137 - 10645) >= (3259 - (316 + 289))) and v24(v95.DivineToll, not v16:IsInRange(78 - 48))) then
				return "divine_toll generators 6";
			end
		end
		if (((159 + 3283) >= (2956 - (666 + 787))) and v95.Judgment:IsReady() and v42 and v16:DebuffUp(v95.ExpurgationDebuff) and v14:BuffDown(v95.EchoesofWrathBuff) and v14:HasTier(456 - (360 + 65), 2 + 0)) then
			if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((3424 - (79 + 175)) <= (2307 - 843))) then
				return "judgment generators 7";
			end
		end
		if (((v105 >= (3 + 0)) and v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (30 - 20))) or ((9237 - 4440) == (5287 - (503 + 396)))) then
			v29 = v116();
			if (((732 - (92 + 89)) <= (1320 - 639)) and v29) then
				return v29;
			end
		end
		if (((1681 + 1596) > (241 + 166)) and v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (15 - 11)) and (v101 >= (1 + 1))) then
			if (((10705 - 6010) >= (1235 + 180)) and v24(v95.TemplarSlash, not v16:IsInRange(5 + 5))) then
				return "templar_slash generators 8";
			end
		end
		if ((v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (8 - 5)) or not v95.HolyBlade:IsAvailable()) and (((v101 >= (1 + 1)) and not v95.CrusadingStrikes:IsAvailable()) or (v101 >= (5 - 1)))) or ((4456 - (485 + 759)) <= (2184 - 1240))) then
			if (v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice)) or ((4285 - (442 + 747)) <= (2933 - (832 + 303)))) then
				return "blade_of_justice generators 10";
			end
		end
		if (((4483 - (88 + 858)) == (1079 + 2458)) and v95.HammerofWrath:IsReady() and v41 and ((v101 < (2 + 0)) or not v95.BlessedChampion:IsAvailable() or v14:HasTier(2 + 28, 793 - (766 + 23))) and ((v105 <= (14 - 11)) or (v16:HealthPercentage() > (27 - 7)) or not v95.VanguardsMomentum:IsAvailable())) then
			if (((10108 - 6271) >= (5328 - 3758)) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
				return "hammer_of_wrath generators 12";
			end
		end
		if ((v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (1077 - (1036 + 37)))) or ((2092 + 858) == (7423 - 3611))) then
			if (((3716 + 1007) >= (3798 - (641 + 839))) and v24(v95.TemplarSlash, not v16:IsSpellInRange(v95.TemplarSlash))) then
				return "templar_slash generators 14";
			end
		end
		if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (916 - (910 + 3))) or not v95.BoundlessJudgment:IsAvailable())) or ((5167 - 3140) > (4536 - (1466 + 218)))) then
			if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((523 + 613) > (5465 - (556 + 592)))) then
				return "judgment generators 16";
			end
		end
		if (((1689 + 3059) == (5556 - (329 + 479))) and v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (857 - (174 + 680))) or not v95.HolyBlade:IsAvailable())) then
			if (((12837 - 9101) <= (9824 - 5084)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
				return "blade_of_justice generators 18";
			end
		end
		if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (3 + 0)) or not v95.BoundlessJudgment:IsAvailable())) or ((4129 - (396 + 343)) <= (271 + 2789))) then
			if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((2476 - (29 + 1448)) > (4082 - (135 + 1254)))) then
				return "judgment generators 20";
			end
		end
		if (((1744 - 1281) < (2806 - 2205)) and ((v16:HealthPercentage() <= (14 + 6)) or v14:BuffUp(v95.AvengingWrathBuff) or v14:BuffUp(v95.CrusadeBuff) or v14:BuffUp(v95.EmpyreanPowerBuff))) then
			v29 = v116();
			if (v29 or ((3710 - (389 + 1138)) < (1261 - (102 + 472)))) then
				return v29;
			end
		end
		if (((4293 + 256) == (2523 + 2026)) and v95.Consecration:IsCastable() and v35 and v16:DebuffDown(v95.ConsecrationDebuff) and (v101 >= (2 + 0))) then
			if (((6217 - (320 + 1225)) == (8316 - 3644)) and v24(v95.Consecration, not v16:IsInRange(7 + 3))) then
				return "consecration generators 22";
			end
		end
		if ((v95.DivineHammer:IsCastable() and v37 and (v101 >= (1466 - (157 + 1307)))) or ((5527 - (821 + 1038)) < (985 - 590))) then
			if (v24(v95.DivineHammer, not v16:IsInRange(2 + 8)) or ((7399 - 3233) == (170 + 285))) then
				return "divine_hammer generators 24";
			end
		end
		if ((v95.CrusaderStrike:IsCastable() and v36 and (v95.CrusaderStrike:ChargesFractional() >= (2.75 - 1)) and ((v105 <= (1028 - (834 + 192))) or ((v105 <= (1 + 2)) and (v95.BladeofJustice:CooldownRemains() > (v106 * (1 + 1)))) or ((v105 == (1 + 3)) and (v95.BladeofJustice:CooldownRemains() > (v106 * (2 - 0))) and (v95.Judgment:CooldownRemains() > (v106 * (306 - (300 + 4))))))) or ((1189 + 3260) == (6971 - 4308))) then
			if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((4639 - (112 + 250)) < (1192 + 1797))) then
				return "crusader_strike generators 26";
			end
		end
		v29 = v116();
		if (v29 or ((2179 - 1309) >= (2377 + 1772))) then
			return v29;
		end
		if (((1144 + 1068) < (2381 + 802)) and v95.TemplarSlash:IsReady() and v44) then
			if (((2304 + 2342) > (2223 + 769)) and v24(v95.TemplarSlash, not v16:IsInRange(1424 - (1001 + 413)))) then
				return "templar_slash generators 28";
			end
		end
		if (((3197 - 1763) < (3988 - (244 + 638))) and v95.TemplarStrike:IsReady() and v45) then
			if (((1479 - (627 + 66)) < (9007 - 5984)) and v24(v95.TemplarStrike, not v16:IsInRange(612 - (512 + 90)))) then
				return "templar_strike generators 30";
			end
		end
		if ((v95.Judgment:IsReady() and v42 and ((v105 <= (1909 - (1665 + 241))) or not v95.BoundlessJudgment:IsAvailable())) or ((3159 - (373 + 344)) < (34 + 40))) then
			if (((1200 + 3335) == (11962 - 7427)) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
				return "judgment generators 32";
			end
		end
		if ((v95.HammerofWrath:IsReady() and v41 and ((v105 <= (4 - 1)) or (v16:HealthPercentage() > (1119 - (35 + 1064))) or not v95.VanguardsMomentum:IsAvailable())) or ((2190 + 819) <= (4503 - 2398))) then
			if (((8 + 1822) < (4905 - (298 + 938))) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
				return "hammer_of_wrath generators 34";
			end
		end
		if ((v95.CrusaderStrike:IsCastable() and v36) or ((2689 - (233 + 1026)) >= (5278 - (636 + 1030)))) then
			if (((1372 + 1311) >= (2403 + 57)) and v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike))) then
				return "crusader_strike generators 26";
			end
		end
		if ((v95.ArcaneTorrent:IsCastable() and ((v85 and v32) or not v85) and v84 and (v105 < (2 + 3)) and (v81 < v103)) or ((122 + 1682) >= (3496 - (55 + 166)))) then
			if (v24(v95.ArcaneTorrent, not v16:IsInRange(2 + 8)) or ((143 + 1274) > (13859 - 10230))) then
				return "arcane_torrent generators 28";
			end
		end
		if (((5092 - (36 + 261)) > (702 - 300)) and v95.Consecration:IsCastable() and v35) then
			if (((6181 - (34 + 1334)) > (1371 + 2194)) and v24(v95.Consecration, not v16:IsInRange(8 + 2))) then
				return "consecration generators 30";
			end
		end
		if (((5195 - (1035 + 248)) == (3933 - (20 + 1))) and v95.DivineHammer:IsCastable() and v37) then
			if (((1470 + 1351) <= (5143 - (134 + 185))) and v24(v95.DivineHammer, not v16:IsInRange(1143 - (549 + 584)))) then
				return "divine_hammer generators 32";
			end
		end
	end
	local function v118()
		v34 = EpicSettings.Settings['useBladeofJustice'];
		v35 = EpicSettings.Settings['useConsecration'];
		v36 = EpicSettings.Settings['useCrusaderStrike'];
		v37 = EpicSettings.Settings['useDivineHammer'];
		v38 = EpicSettings.Settings['useDivineStorm'];
		v39 = EpicSettings.Settings['useDivineToll'];
		v40 = EpicSettings.Settings['useExecutionSentence'];
		v41 = EpicSettings.Settings['useHammerofWrath'];
		v42 = EpicSettings.Settings['useJudgment'];
		v43 = EpicSettings.Settings['useJusticarsVengeance'];
		v44 = EpicSettings.Settings['useTemplarSlash'];
		v45 = EpicSettings.Settings['useTemplarStrike'];
		v46 = EpicSettings.Settings['useWakeofAshes'];
		v47 = EpicSettings.Settings['useVerdict'];
		v48 = EpicSettings.Settings['useAvengingWrath'];
		v49 = EpicSettings.Settings['useCrusade'];
		v50 = EpicSettings.Settings['useFinalReckoning'];
		v51 = EpicSettings.Settings['useShieldofVengeance'];
		v52 = EpicSettings.Settings['avengingWrathWithCD'];
		v53 = EpicSettings.Settings['crusadeWithCD'];
		v54 = EpicSettings.Settings['finalReckoningWithCD'];
		v55 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v119()
		local v152 = 685 - (314 + 371);
		while true do
			if (((5966 - 4228) <= (3163 - (478 + 490))) and ((2 + 1) == v152)) then
				v68 = EpicSettings.Settings['layonHandsFocusHP'] or (1172 - (786 + 386));
				v69 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 - 0);
				v70 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (1379 - (1055 + 324));
				v71 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (1340 - (1093 + 247));
				v152 = 4 + 0;
			end
			if (((5 + 36) <= (11981 - 8963)) and (v152 == (3 - 2))) then
				v60 = EpicSettings.Settings['useLayonHands'];
				v61 = EpicSettings.Settings['useLayonHandsFocus'];
				v62 = EpicSettings.Settings['useWordofGloryFocus'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v152 = 5 - 3;
			end
			if (((5390 - 3245) <= (1460 + 2644)) and ((15 - 11) == v152)) then
				v72 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v73 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v93 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((9268 - 6579) < (3654 + 1191)) and (v152 == (4 - 2))) then
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v65 = EpicSettings.Settings['divineProtectionHP'] or (688 - (364 + 324));
				v66 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v67 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v152 = 1 + 2;
			end
			if ((v152 == (0 - 0)) or ((3718 - 1396) > (7963 - 5341))) then
				v56 = EpicSettings.Settings['useRebuke'];
				v57 = EpicSettings.Settings['useHammerofJustice'];
				v58 = EpicSettings.Settings['useDivineProtection'];
				v59 = EpicSettings.Settings['useDivineShield'];
				v152 = 1269 - (1249 + 19);
			end
		end
	end
	local function v120()
		v81 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v78 = EpicSettings.Settings['InterruptWithStun'];
		v79 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v80 = EpicSettings.Settings['InterruptThreshold'];
		v75 = EpicSettings.Settings['DispelDebuffs'];
		v74 = EpicSettings.Settings['DispelBuffs'];
		v82 = EpicSettings.Settings['useTrinkets'];
		v84 = EpicSettings.Settings['useRacials'];
		v83 = EpicSettings.Settings['trinketsWithCD'];
		v85 = EpicSettings.Settings['racialsWithCD'];
		v87 = EpicSettings.Settings['useHealthstone'];
		v86 = EpicSettings.Settings['useHealingPotion'];
		v89 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v88 = EpicSettings.Settings['healingPotionHP'] or (1086 - (686 + 400));
		v90 = EpicSettings.Settings['HealingPotionName'] or "";
		v76 = EpicSettings.Settings['handleAfflicted'];
		v77 = EpicSettings.Settings['HandleIncorporeal'];
		v91 = EpicSettings.Settings['HealOOC'];
		v92 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
	end
	local function v121()
		v119();
		v118();
		v120();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v14:IsDeadOrGhost() or ((4763 - (73 + 156)) == (10 + 2072))) then
			return;
		end
		v100 = v14:GetEnemiesInMeleeRange(819 - (721 + 90));
		if (v31 or ((18 + 1553) > (6061 - 4194))) then
			v101 = #v100;
		else
			local v173 = 470 - (224 + 246);
			while true do
				if (((0 - 0) == v173) or ((4886 - 2232) >= (544 + 2452))) then
					v100 = {};
					v101 = 1 + 0;
					break;
				end
			end
		end
		if (((2922 + 1056) > (4182 - 2078)) and not v14:AffectingCombat() and v14:IsMounted()) then
			if (((9966 - 6971) > (2054 - (203 + 310))) and v95.CrusaderAura:IsCastable() and (v14:BuffDown(v95.CrusaderAura))) then
				if (((5242 - (1238 + 755)) > (67 + 886)) and v24(v95.CrusaderAura)) then
					return "crusader_aura";
				end
			end
		end
		if (v14:AffectingCombat() or v75 or ((4807 - (709 + 825)) > (8426 - 3853))) then
			local v174 = 0 - 0;
			local v175;
			while true do
				if ((v174 == (865 - (196 + 668))) or ((12440 - 9289) < (2659 - 1375))) then
					if (v29 or ((2683 - (171 + 662)) == (1622 - (4 + 89)))) then
						return v29;
					end
					break;
				end
				if (((2877 - 2056) < (774 + 1349)) and ((0 - 0) == v174)) then
					v175 = v75 and v95.CleanseToxins:IsReady() and v33;
					v29 = v94.FocusUnit(v175, v99, 8 + 12, nil, 1511 - (35 + 1451));
					v174 = 1454 - (28 + 1425);
				end
			end
		end
		local v171 = v94.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 2033 - (941 + 1052), 24 + 1);
		if (((2416 - (822 + 692)) < (3318 - 993)) and v171) then
			return v171;
		end
		if (((405 + 453) <= (3259 - (45 + 252))) and v95.BlessingofFreedom:IsReady() and v94.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
			if (v24(v99.BlessingofFreedomFocus) or ((3905 + 41) < (444 + 844))) then
				return "blessing_of_freedom combat";
			end
		end
		v104 = v108();
		if (not v14:AffectingCombat() or ((7889 - 4647) == (1000 - (114 + 319)))) then
			if ((v95.RetributionAura:IsCastable() and (v109())) or ((1216 - 369) >= (1617 - 354))) then
				if (v24(v95.RetributionAura) or ((1437 + 816) == (2757 - 906))) then
					return "retribution_aura";
				end
			end
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((4372 - 2285) > (4335 - (556 + 1407)))) then
			if (v14:AffectingCombat() or ((5651 - (741 + 465)) < (4614 - (170 + 295)))) then
				if (v95.Intercession:IsCastable() or ((958 + 860) == (79 + 6))) then
					if (((1551 - 921) < (1764 + 363)) and v24(v95.Intercession, not v16:IsInRange(20 + 10), true)) then
						return "intercession target";
					end
				end
			elseif (v95.Redemption:IsCastable() or ((1098 + 840) == (3744 - (957 + 273)))) then
				if (((1139 + 3116) >= (23 + 32)) and v24(v95.Redemption, not v16:IsInRange(114 - 84), true)) then
					return "redemption target";
				end
			end
		end
		if (((7902 - 4903) > (3530 - 2374)) and v95.Redemption:IsCastable() and v95.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
			if (((11636 - 9286) > (2935 - (389 + 1391))) and v24(v99.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((2528 + 1501) <= (506 + 4347)) and v14:AffectingCombat()) then
			if ((v95.Intercession:IsCastable() and (v14:HolyPower() >= (6 - 3)) and v95.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1467 - (783 + 168)) > (11525 - 8091))) then
				if (((3980 + 66) >= (3344 - (309 + 2))) and v24(v99.IntercessionMouseover)) then
					return "Intercession mouseover";
				end
			end
		end
		if (v94.TargetIsValid() or v14:AffectingCombat() or ((8349 - 5630) <= (2659 - (1090 + 122)))) then
			v102 = v9.BossFightRemains(nil, true);
			v103 = v102;
			if ((v103 == (3603 + 7508)) or ((13883 - 9749) < (2687 + 1239))) then
				v103 = v9.FightRemains(v100, false);
			end
			v106 = v14:GCD();
			v105 = v14:HolyPower();
		end
		if (v76 or ((1282 - (628 + 490)) >= (500 + 2285))) then
			if (v72 or ((1299 - 774) == (9638 - 7529))) then
				v171 = v94.HandleAfflicted(v95.CleanseToxins, v99.CleanseToxinsMouseover, 814 - (431 + 343));
				if (((66 - 33) == (95 - 62)) and v171) then
					return v171;
				end
			end
			if (((2413 + 641) <= (514 + 3501)) and v73 and (v105 > (1697 - (556 + 1139)))) then
				local v190 = 15 - (6 + 9);
				while true do
					if (((343 + 1528) < (1733 + 1649)) and (v190 == (169 - (28 + 141)))) then
						v171 = v94.HandleAfflicted(v95.WordofGlory, v99.WordofGloryMouseover, 16 + 24, true);
						if (((1595 - 302) <= (1535 + 631)) and v171) then
							return v171;
						end
						break;
					end
				end
			end
		end
		if (v77 or ((3896 - (486 + 831)) < (319 - 196))) then
			local v176 = 0 - 0;
			while true do
				if ((v176 == (0 + 0)) or ((2674 - 1828) >= (3631 - (668 + 595)))) then
					v171 = v94.HandleIncorporeal(v95.Repentance, v99.RepentanceMouseOver, 27 + 3, true);
					if (v171 or ((809 + 3203) <= (9157 - 5799))) then
						return v171;
					end
					v176 = 291 - (23 + 267);
				end
				if (((3438 - (1129 + 815)) <= (3392 - (371 + 16))) and (v176 == (1751 - (1326 + 424)))) then
					v171 = v94.HandleIncorporeal(v95.TurnEvil, v99.TurnEvilMouseOver, 56 - 26, true);
					if (v171 or ((11368 - 8257) == (2252 - (88 + 30)))) then
						return v171;
					end
					break;
				end
			end
		end
		v171 = v111();
		if (((3126 - (720 + 51)) == (5238 - 2883)) and v171) then
			return v171;
		end
		if (v13 or ((2364 - (421 + 1355)) <= (711 - 279))) then
			if (((2357 + 2440) >= (4978 - (286 + 797))) and v75) then
				local v191 = 0 - 0;
				while true do
					if (((5924 - 2347) == (4016 - (397 + 42))) and (v191 == (0 + 0))) then
						v171 = v110();
						if (((4594 - (24 + 776)) > (5689 - 1996)) and v171) then
							return v171;
						end
						break;
					end
				end
			end
		end
		v171 = v112();
		if (v171 or ((2060 - (222 + 563)) == (9033 - 4933))) then
			return v171;
		end
		if ((not v14:AffectingCombat() and v30 and v94.TargetIsValid()) or ((1146 + 445) >= (3770 - (23 + 167)))) then
			local v177 = 1798 - (690 + 1108);
			while true do
				if (((355 + 628) <= (1492 + 316)) and (v177 == (848 - (40 + 808)))) then
					v171 = v114();
					if (v171 or ((354 + 1796) <= (4577 - 3380))) then
						return v171;
					end
					break;
				end
			end
		end
		if (((3603 + 166) >= (621 + 552)) and v14:AffectingCombat() and v94.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
			local v178 = 0 + 0;
			while true do
				if (((2056 - (47 + 524)) == (964 + 521)) and (v178 == (0 - 0))) then
					if ((UseLayOnHands and (v14:HealthPercentage() <= v67) and v95.LayonHands:IsReady() and v14:DebuffDown(v95.ForbearanceDebuff)) or ((4956 - 1641) <= (6344 - 3562))) then
						if (v24(v95.LayonHands) or ((2602 - (1165 + 561)) >= (89 + 2875))) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v59 and (v14:HealthPercentage() <= v66) and v95.DivineShield:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) or ((6912 - 4680) > (953 + 1544))) then
						if (v24(v95.DivineShield) or ((2589 - (341 + 138)) <= (90 + 242))) then
							return "divine_shield defensive";
						end
					end
					v178 = 1 - 0;
				end
				if (((4012 - (89 + 237)) > (10204 - 7032)) and (v178 == (3 - 1))) then
					if ((v86 and (v14:HealthPercentage() <= v88)) or ((5355 - (581 + 300)) < (2040 - (855 + 365)))) then
						if (((10163 - 5884) >= (942 + 1940)) and (v90 == "Refreshing Healing Potion")) then
							if (v96.RefreshingHealingPotion:IsReady() or ((3264 - (1030 + 205)) >= (3306 + 215))) then
								if (v24(v99.RefreshingHealingPotion) or ((1895 + 142) >= (4928 - (156 + 130)))) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((3908 - 2188) < (7513 - 3055)) and (v90 == "Dreamwalker's Healing Potion")) then
							if (v96.DreamwalkersHealingPotion:IsReady() or ((892 - 456) > (797 + 2224))) then
								if (((416 + 297) <= (916 - (10 + 59))) and v24(v99.RefreshingHealingPotion)) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
					end
					if (((610 + 1544) <= (19851 - 15820)) and (v81 < v103)) then
						local v192 = 1163 - (671 + 492);
						while true do
							if (((3674 + 941) == (5830 - (369 + 846))) and (v192 == (0 + 0))) then
								v171 = v115();
								if (v171 or ((3235 + 555) == (2445 - (1036 + 909)))) then
									return v171;
								end
								break;
							end
						end
					end
					v178 = 3 + 0;
				end
				if (((148 - 59) < (424 - (11 + 192))) and (v178 == (2 + 1))) then
					v171 = v117();
					if (((2229 - (135 + 40)) >= (3442 - 2021)) and v171) then
						return v171;
					end
					v178 = 3 + 1;
				end
				if (((1524 - 832) < (4584 - 1526)) and (v178 == (177 - (50 + 126)))) then
					if ((v58 and v95.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v65)) or ((9060 - 5806) == (367 + 1288))) then
						if (v24(v95.DivineProtection) or ((2709 - (1233 + 180)) == (5879 - (522 + 447)))) then
							return "divine_protection defensive";
						end
					end
					if (((4789 - (107 + 1314)) == (1563 + 1805)) and v96.Healthstone:IsReady() and v87 and (v14:HealthPercentage() <= v89)) then
						if (((8053 - 5410) < (1621 + 2194)) and v24(v99.Healthstone)) then
							return "healthstone defensive";
						end
					end
					v178 = 3 - 1;
				end
				if (((7568 - 5655) > (2403 - (716 + 1194))) and ((1 + 3) == v178)) then
					if (((510 + 4245) > (3931 - (74 + 429))) and v24(v95.Pool)) then
						return "Wait/Pool Resources";
					end
					break;
				end
			end
		end
	end
	local function v122()
		v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v98();
	end
	v20.SetAPL(135 - 65, v121, OnInit);
end;
return v0["Epix_Paladin_Retribution.lua"]();

