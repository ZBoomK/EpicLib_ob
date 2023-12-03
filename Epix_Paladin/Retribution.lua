local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((6899 - 4045) < (5928 - 1833)) and not v5) then
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
		if (v95.CleanseToxins:IsAvailable() or ((1708 - 650) >= (757 + 445))) then
			v94.DispellableDebuffs = v12.MergeTable(v94.DispellableDiseaseDebuffs, v94.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v98();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v99 = v23.Paladin.Retribution;
	local v100;
	local v101;
	local v102 = 21201 - 10090;
	local v103 = 33030 - 21919;
	local v104;
	local v105 = 0 + 0;
	local v106 = 0 + 0;
	local v107;
	v9:RegisterForEvent(function()
		v102 = 4841 + 6270;
		v103 = 29010 - 17899;
	end, "PLAYER_REGEN_ENABLED");
	local function v108()
		local v123 = v14:GCDRemains();
		local v124 = v27(v95.CrusaderStrike:CooldownRemains(), v95.BladeofJustice:CooldownRemains(), v95.Judgment:CooldownRemains(), (v95.HammerofWrath:IsUsable() and v95.HammerofWrath:CooldownRemains()) or (7 + 3), v95.WakeofAshes:CooldownRemains());
		if (((4878 - (645 + 522)) > (5145 - (1010 + 780))) and (v123 > v124)) then
			return v123;
		end
		return v124;
	end
	local function v109()
		return v14:BuffDown(v95.RetributionAura) and v14:BuffDown(v95.DevotionAura) and v14:BuffDown(v95.ConcentrationAura) and v14:BuffDown(v95.CrusaderAura);
	end
	local function v110()
		if ((v95.CleanseToxins:IsReady() and v33 and v94.DispellableFriendlyUnit(25 + 0)) or ((4316 - 3410) >= (6531 - 4302))) then
			if (((3124 - (1045 + 791)) > (3166 - 1915)) and v24(v99.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v111()
		if ((v91 and (v14:HealthPercentage() <= v92)) or ((6890 - 2377) < (3857 - (351 + 154)))) then
			if (v95.FlashofLight:IsReady() or ((3639 - (1281 + 293)) >= (3462 - (28 + 238)))) then
				if (v24(v95.FlashofLight) or ((9777 - 5401) <= (3040 - (1381 + 178)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v112()
		if (not v13 or not v13:Exists() or not v13:IsInRange(29 + 1) or ((2736 + 656) >= (2023 + 2718))) then
			return;
		end
		if (((11462 - 8137) >= (1116 + 1038)) and v13) then
			local v164 = 470 - (381 + 89);
			while true do
				if ((v164 == (1 + 0)) or ((876 + 419) >= (5537 - 2304))) then
					if (((5533 - (1074 + 82)) > (3597 - 1955)) and v95.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v71)) then
						if (((6507 - (214 + 1570)) > (2811 - (990 + 465))) and v24(v99.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v95.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v70)) or ((1706 + 2430) <= (1494 + 1939))) then
						if (((4129 + 116) <= (18225 - 13594)) and v24(v99.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if (((6002 - (1668 + 58)) >= (4540 - (512 + 114))) and (v164 == (0 - 0))) then
					if (((409 - 211) <= (15188 - 10823)) and v95.WordofGlory:IsReady() and v62 and (v13:HealthPercentage() <= v69)) then
						if (((2225 + 2557) > (876 + 3800)) and v24(v99.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((4229 + 635) > (7410 - 5213)) and v95.LayonHands:IsCastable() and v61 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v68)) then
						if (v24(v99.LayonHandsFocus) or ((5694 - (109 + 1885)) == (3976 - (1269 + 200)))) then
							return "lay_on_hands defensive focus";
						end
					end
					v164 = 1 - 0;
				end
			end
		end
	end
	local function v113()
		local v125 = 815 - (98 + 717);
		while true do
			if (((5300 - (802 + 24)) >= (472 - 198)) and (v125 == (1 - 0))) then
				v29 = v94.HandleBottomTrinket(v97, v32, 6 + 34, nil);
				if (v29 or ((1456 + 438) <= (231 + 1175))) then
					return v29;
				end
				break;
			end
			if (((340 + 1232) >= (4259 - 2728)) and (v125 == (0 - 0))) then
				v29 = v94.HandleTopTrinket(v97, v32, 15 + 25, nil);
				if (v29 or ((1908 + 2779) < (3747 + 795))) then
					return v29;
				end
				v125 = 1 + 0;
			end
		end
	end
	local function v114()
		local v126 = 0 + 0;
		while true do
			if (((4724 - (797 + 636)) > (8093 - 6426)) and (v126 == (1622 - (1427 + 192)))) then
				if ((v95.HammerofWrath:IsReady() and v41) or ((303 + 570) == (4722 - 2688))) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((2532 + 284) < (5 + 6))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if (((4025 - (192 + 134)) < (5982 - (316 + 960))) and v95.CrusaderStrike:IsCastable() and v36) then
					if (((1473 + 1173) >= (677 + 199)) and v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((568 + 46) <= (12172 - 8988)) and (v126 == (553 - (83 + 468)))) then
				if (((4932 - (1202 + 604)) == (14592 - 11466)) and v95.BladeofJustice:IsCastable() and v34) then
					if (v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice)) or ((3639 - 1452) >= (13716 - 8762))) then
						return "blade_of_justice precombat 5";
					end
				end
				if ((v95.Judgment:IsCastable() and v42) or ((4202 - (45 + 280)) == (3451 + 124))) then
					if (((618 + 89) > (231 + 401)) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment precombat 6";
					end
				end
				v126 = 2 + 1;
			end
			if ((v126 == (1 + 0)) or ((1010 - 464) >= (4595 - (340 + 1571)))) then
				if (((578 + 887) <= (6073 - (1733 + 39))) and v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsReady() and v47 and (v105 >= (10 - 6))) then
					if (((2738 - (125 + 909)) > (3373 - (1096 + 852))) and v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				if ((v95.TemplarsVerdict:IsReady() and v47 and (v105 >= (2 + 2))) or ((981 - 294) == (4107 + 127))) then
					if (v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict)) or ((3842 - (409 + 103)) < (1665 - (46 + 190)))) then
						return "templars verdict precombat 4";
					end
				end
				v126 = 97 - (51 + 44);
			end
			if (((324 + 823) >= (1652 - (1114 + 203))) and (v126 == (726 - (228 + 498)))) then
				if (((745 + 2690) > (1159 + 938)) and v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55)) then
					if (v24(v95.ShieldofVengeance) or ((4433 - (174 + 489)) >= (10527 - 6486))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v95.JusticarsVengeance:IsAvailable() and v95.JusticarsVengeance:IsReady() and v43 and (v105 >= (1909 - (830 + 1075)))) or ((4315 - (303 + 221)) <= (2880 - (231 + 1038)))) then
					if (v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance)) or ((3815 + 763) <= (3170 - (171 + 991)))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v126 = 4 - 3;
			end
		end
	end
	local function v115()
		local v127 = 0 - 0;
		local v128;
		while true do
			if (((2807 - 1682) <= (1662 + 414)) and (v127 == (6 - 4))) then
				if ((v82 and ((v32 and v83) or not v83) and v16:IsInRange(22 - 14)) or ((1197 - 454) >= (13598 - 9199))) then
					v29 = v113();
					if (((2403 - (111 + 1137)) < (1831 - (91 + 67))) and v29) then
						return v29;
					end
				end
				if ((v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55) and (v103 > (44 - 29)) and (not v95.ExecutionSentence:IsAvailable() or v16:DebuffDown(v95.ExecutionSentence))) or ((580 + 1744) <= (1101 - (423 + 100)))) then
					if (((27 + 3740) == (10430 - 6663)) and v24(v95.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v127 = 2 + 1;
			end
			if (((4860 - (326 + 445)) == (17844 - 13755)) and ((2 - 1) == v127)) then
				if (((10405 - 5947) >= (2385 - (530 + 181))) and v95.LightsJudgment:IsCastable() and v84 and ((v85 and v32) or not v85)) then
					if (((1853 - (614 + 267)) <= (1450 - (19 + 13))) and v24(v95.LightsJudgment, not v16:IsInRange(65 - 25))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v95.Fireblood:IsCastable() and v84 and ((v85 and v32) or not v85) and (v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) == (23 - 13))))) or ((14105 - 9167) < (1237 + 3525))) then
					if (v24(v95.Fireblood, not v16:IsInRange(17 - 7)) or ((5192 - 2688) > (6076 - (1293 + 519)))) then
						return "fireblood cooldowns 6";
					end
				end
				v127 = 3 - 1;
			end
			if (((5621 - 3468) == (4116 - 1963)) and (v127 == (17 - 13))) then
				if ((v95.Crusade:IsCastable() and v49 and ((v32 and v53) or not v53) and (((v105 >= (9 - 5)) and (v9.CombatTime() < (3 + 2))) or ((v105 >= (1 + 2)) and (v9.CombatTime() >= (11 - 6))))) or ((118 + 389) >= (861 + 1730))) then
					if (((2801 + 1680) == (5577 - (709 + 387))) and v24(v95.Crusade, not v16:IsInRange(1868 - (673 + 1185)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v95.FinalReckoning:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v105 >= (11 - 7)) and (v9.CombatTime() < (25 - 17))) or ((v105 >= (4 - 1)) and (v9.CombatTime() >= (6 + 2))) or ((v105 >= (2 + 0)) and v95.DivineAuxiliary:IsAvailable())) and ((v95.AvengingWrath:CooldownRemains() > (13 - 3)) or (v95.Crusade:CooldownDown() and (v14:BuffDown(v95.CrusadeBuff) or (v14:BuffStack(v95.CrusadeBuff) >= (3 + 7))))) and ((v104 > (0 - 0)) or (v105 == (9 - 4)) or ((v105 >= (1882 - (446 + 1434))) and v95.DivineAuxiliary:IsAvailable()))) or ((3611 - (1040 + 243)) < (2068 - 1375))) then
					local v194 = 1847 - (559 + 1288);
					while true do
						if (((6259 - (609 + 1322)) == (4782 - (13 + 441))) and (v194 == (0 - 0))) then
							if (((4159 - 2571) >= (6633 - 5301)) and (v93 == "player")) then
								if (v24(v99.FinalReckoningPlayer, not v16:IsInRange(1 + 9)) or ((15159 - 10985) > (1509 + 2739))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((v93 == "cursor") or ((2010 + 2576) <= (243 - 161))) then
								if (((2114 + 1749) == (7104 - 3241)) and v24(v99.FinalReckoningCursor, not v16:IsInRange(14 + 6))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v127 == (0 + 0)) or ((203 + 79) <= (36 + 6))) then
				v128 = v94.HandleDPSPotion(v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14.BuffStack(v95.Crusade) == (10 + 0))) or (v103 < (458 - (153 + 280))));
				if (((13308 - 8699) >= (688 + 78)) and v128) then
					return v128;
				end
				v127 = 1 + 0;
			end
			if ((v127 == (2 + 1)) or ((1046 + 106) == (1803 + 685))) then
				if (((5209 - 1787) > (2071 + 1279)) and v95.ExecutionSentence:IsCastable() and v40 and ((v14:BuffDown(v95.CrusadeBuff) and (v95.Crusade:CooldownRemains() > (682 - (89 + 578)))) or (v14:BuffStack(v95.CrusadeBuff) == (8 + 2)) or (v95.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v95.AvengingWrath:CooldownRemains() > (1064 - (572 + 477)))) and (((v105 >= (1 + 3)) and (v9.CombatTime() < (4 + 1))) or ((v105 >= (1 + 2)) and (v9.CombatTime() > (91 - (84 + 2)))) or ((v105 >= (2 - 0)) and v95.DivineAuxiliary:IsAvailable())) and (((v103 > (6 + 2)) and not v95.ExecutionersWill:IsAvailable()) or (v103 > (854 - (497 + 345))))) then
					if (((23 + 854) > (64 + 312)) and v24(v95.ExecutionSentence, not v16:IsSpellInRange(v95.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v95.AvengingWrath:IsCastable() and v48 and ((v32 and v52) or not v52) and (((v105 >= (1337 - (605 + 728))) and (v9.CombatTime() < (4 + 1))) or ((v105 >= (6 - 3)) and (v9.CombatTime() > (1 + 4))) or ((v105 >= (7 - 5)) and v95.DivineAuxiliary:IsAvailable() and (v95.ExecutionSentence:CooldownUp() or v95.FinalReckoning:CooldownUp())))) or ((2811 + 307) <= (5128 - 3277))) then
					if (v24(v95.AvengingWrath, not v16:IsInRange(8 + 2)) or ((654 - (457 + 32)) >= (1482 + 2010))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v127 = 1406 - (832 + 570);
			end
		end
	end
	local function v116()
		local v129 = 0 + 0;
		while true do
			if (((1030 + 2919) < (17184 - 12328)) and (v129 == (1 + 1))) then
				if ((v95.TemplarsVerdict:IsReady() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (799 - (588 + 208)))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (26 - 16))))) or ((6076 - (884 + 916)) < (6314 - 3298))) then
					if (((2720 + 1970) > (4778 - (232 + 421))) and v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if (((1890 - (1569 + 320)) == v129) or ((13 + 37) >= (171 + 725))) then
				if ((v95.JusticarsVengeance:IsReady() and v43 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (9 - 6))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (615 - (316 + 289)))))) or ((4486 - 2772) >= (137 + 2821))) then
					if (v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance)) or ((2944 - (666 + 787)) < (1069 - (360 + 65)))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((658 + 46) < (1241 - (79 + 175))) and v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsCastable() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (4 - 1))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (8 + 2))))) then
					if (((11396 - 7678) > (3670 - 1764)) and v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v129 = 901 - (503 + 396);
			end
			if ((v129 == (181 - (92 + 89))) or ((1858 - 900) > (1865 + 1770))) then
				v107 = ((v101 >= (2 + 1)) or ((v101 >= (7 - 5)) and not v95.DivineArbiter:IsAvailable()) or v14:BuffUp(v95.EmpyreanPowerBuff)) and v14:BuffDown(v95.EmpyreanLegacyBuff) and not (v14:BuffUp(v95.DivineArbiterBuff) and (v14:BuffStack(v95.DivineArbiterBuff) > (4 + 20)));
				if (((7982 - 4481) <= (3920 + 572)) and v95.DivineStorm:IsReady() and v38 and v107 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (2 + 1))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (30 - 20))))) then
					if (v24(v95.DivineStorm, not v16:IsInRange(2 + 8)) or ((5248 - 1806) < (3792 - (485 + 759)))) then
						return "divine_storm finishers 2";
					end
				end
				v129 = 2 - 1;
			end
		end
	end
	local function v117()
		local v130 = 1189 - (442 + 747);
		while true do
			if (((4010 - (832 + 303)) >= (2410 - (88 + 858))) and (v130 == (1 + 1))) then
				if ((v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (4 + 0)) and (v101 >= (1 + 1))) or ((5586 - (766 + 23)) >= (24155 - 19262))) then
					if (v24(v95.TemplarSlash, not v16:IsInRange(13 - 3)) or ((1451 - 900) > (7018 - 4950))) then
						return "templar_slash generators 8";
					end
				end
				if (((3187 - (1036 + 37)) > (670 + 274)) and v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (5 - 2)) or not v95.HolyBlade:IsAvailable()) and (((v101 >= (2 + 0)) and not v95.CrusadingStrikes:IsAvailable()) or (v101 >= (1484 - (641 + 839))))) then
					if (v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice)) or ((3175 - (910 + 3)) >= (7892 - 4796))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v95.HammerofWrath:IsReady() and v41 and ((v101 < (1686 - (1466 + 218))) or not v95.BlessedChampion:IsAvailable() or v14:HasTier(14 + 16, 1152 - (556 + 592))) and ((v105 <= (2 + 1)) or (v16:HealthPercentage() > (828 - (329 + 479))) or not v95.VanguardsMomentum:IsAvailable())) or ((3109 - (174 + 680)) >= (12153 - 8616))) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((7953 - 4116) < (933 + 373))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v130 = 742 - (396 + 343);
			end
			if (((262 + 2688) == (4427 - (29 + 1448))) and (v130 == (1389 - (135 + 1254)))) then
				if ((v105 >= (18 - 13)) or (v14:BuffUp(v95.EchoesofWrathBuff) and v14:HasTier(144 - 113, 3 + 1) and v95.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v95.JudgmentDebuff) or (v105 == (1531 - (389 + 1138)))) and v14:BuffUp(v95.DivineResonanceBuff) and not v14:HasTier(605 - (102 + 472), 2 + 0)) or ((2620 + 2103) < (3076 + 222))) then
					v29 = v116();
					if (((2681 - (320 + 1225)) >= (273 - 119)) and v29) then
						return v29;
					end
				end
				if ((v95.WakeofAshes:IsCastable() and v46 and (v105 <= (2 + 0)) and (v95.AvengingWrath:CooldownDown() or v95.Crusade:CooldownDown()) and (not v95.ExecutionSentence:IsAvailable() or (v95.ExecutionSentence:CooldownRemains() > (1468 - (157 + 1307))) or (v103 < (1867 - (821 + 1038))))) or ((676 - 405) > (520 + 4228))) then
					if (((8419 - 3679) >= (1173 + 1979)) and v24(v95.WakeofAshes, not v16:IsInRange(24 - 14))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v95.BladeofJustice:IsCastable() and v34 and not v16:DebuffUp(v95.ExpurgationDebuff) and (v105 <= (1029 - (834 + 192))) and v14:HasTier(2 + 29, 1 + 1)) or ((56 + 2522) >= (5251 - 1861))) then
					if (((345 - (300 + 4)) <= (444 + 1217)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				v130 = 2 - 1;
			end
			if (((963 - (112 + 250)) < (1420 + 2140)) and (v130 == (14 - 8))) then
				if (((135 + 100) < (356 + 331)) and v29) then
					return v29;
				end
				if (((3403 + 1146) > (572 + 581)) and v95.TemplarSlash:IsReady() and v44) then
					if (v24(v95.TemplarSlash, not v16:IsInRange(8 + 2)) or ((6088 - (1001 + 413)) < (10418 - 5746))) then
						return "templar_slash generators 28";
					end
				end
				if (((4550 - (244 + 638)) < (5254 - (627 + 66))) and v95.TemplarStrike:IsReady() and v45) then
					if (v24(v95.TemplarStrike, not v16:IsInRange(29 - 19)) or ((1057 - (512 + 90)) == (5511 - (1665 + 241)))) then
						return "templar_strike generators 30";
					end
				end
				v130 = 724 - (373 + 344);
			end
			if ((v130 == (4 + 3)) or ((705 + 1958) == (8736 - 5424))) then
				if (((7237 - 2960) <= (5574 - (35 + 1064))) and v95.Judgment:IsReady() and v42 and ((v105 <= (3 + 0)) or not v95.BoundlessJudgment:IsAvailable())) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((1861 - 991) == (5 + 1184))) then
						return "judgment generators 32";
					end
				end
				if (((2789 - (298 + 938)) <= (4392 - (233 + 1026))) and v95.HammerofWrath:IsReady() and v41 and ((v105 <= (1669 - (636 + 1030))) or (v16:HealthPercentage() > (11 + 9)) or not v95.VanguardsMomentum:IsAvailable())) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((2186 + 51) >= (1043 + 2468))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v95.CrusaderStrike:IsCastable() and v36) or ((90 + 1234) > (3241 - (55 + 166)))) then
					if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((580 + 2412) == (190 + 1691))) then
						return "crusader_strike generators 26";
					end
				end
				v130 = 30 - 22;
			end
			if (((3403 - (36 + 261)) > (2668 - 1142)) and (v130 == (1376 - (34 + 1334)))) then
				if (((1163 + 1860) < (3007 + 863)) and v95.ArcaneTorrent:IsCastable() and ((v85 and v32) or not v85) and v84 and (v105 < (1288 - (1035 + 248))) and (v81 < v103)) then
					if (((164 - (20 + 1)) > (39 + 35)) and v24(v95.ArcaneTorrent, not v16:IsInRange(329 - (134 + 185)))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((1151 - (549 + 584)) < (2797 - (314 + 371))) and v95.Consecration:IsCastable() and v35) then
					if (((3765 - 2668) <= (2596 - (478 + 490))) and v24(v95.Consecration, not v16:IsInRange(6 + 4))) then
						return "consecration generators 30";
					end
				end
				if (((5802 - (786 + 386)) == (14996 - 10366)) and v95.DivineHammer:IsCastable() and v37) then
					if (((4919 - (1055 + 324)) > (4023 - (1093 + 247))) and v24(v95.DivineHammer, not v16:IsInRange(9 + 1))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((505 + 4289) >= (13002 - 9727)) and (v130 == (16 - 11))) then
				if (((4222 - 2738) == (3728 - 2244)) and v95.DivineHammer:IsCastable() and v37 and (v101 >= (1 + 1))) then
					if (((5516 - 4084) < (12253 - 8698)) and v24(v95.DivineHammer, not v16:IsInRange(8 + 2))) then
						return "divine_hammer generators 24";
					end
				end
				if ((v95.CrusaderStrike:IsCastable() and v36 and (v95.CrusaderStrike:ChargesFractional() >= (2.75 - 1)) and ((v105 <= (690 - (364 + 324))) or ((v105 <= (7 - 4)) and (v95.BladeofJustice:CooldownRemains() > (v106 * (4 - 2)))) or ((v105 == (2 + 2)) and (v95.BladeofJustice:CooldownRemains() > (v106 * (8 - 6))) and (v95.Judgment:CooldownRemains() > (v106 * (2 - 0)))))) or ((3234 - 2169) > (4846 - (1249 + 19)))) then
					if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((4329 + 466) < (5476 - 4069))) then
						return "crusader_strike generators 26";
					end
				end
				v29 = v116();
				v130 = 1092 - (686 + 400);
			end
			if (((1454 + 399) < (5042 - (73 + 156))) and (v130 == (1 + 0))) then
				if ((v95.DivineToll:IsCastable() and v39 and (v105 <= (813 - (721 + 90))) and ((v95.AvengingWrath:CooldownRemains() > (1 + 14)) or (v95.Crusade:CooldownRemains() > (48 - 33)) or (v103 < (478 - (224 + 246))))) or ((4569 - 1748) < (4475 - 2044))) then
					if (v24(v95.DivineToll, not v16:IsInRange(6 + 24)) or ((69 + 2805) < (1602 + 579))) then
						return "divine_toll generators 6";
					end
				end
				if ((v95.Judgment:IsReady() and v42 and v16:DebuffUp(v95.ExpurgationDebuff) and v14:BuffDown(v95.EchoesofWrathBuff) and v14:HasTier(61 - 30, 6 - 4)) or ((3202 - (203 + 310)) <= (2336 - (1238 + 755)))) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((131 + 1738) == (3543 - (709 + 825)))) then
						return "judgment generators 7";
					end
				end
				if (((v105 >= (4 - 1)) and v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (14 - 4))) or ((4410 - (196 + 668)) < (9167 - 6845))) then
					v29 = v116();
					if (v29 or ((4312 - 2230) == (5606 - (171 + 662)))) then
						return v29;
					end
				end
				v130 = 95 - (4 + 89);
			end
			if (((11370 - 8126) > (385 + 670)) and (v130 == (17 - 13))) then
				if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (2 + 1)) or not v95.BoundlessJudgment:IsAvailable())) or ((4799 - (35 + 1451)) <= (3231 - (28 + 1425)))) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((3414 - (941 + 1052)) >= (2018 + 86))) then
						return "judgment generators 20";
					end
				end
				if (((3326 - (822 + 692)) <= (4637 - 1388)) and ((v16:HealthPercentage() <= (10 + 10)) or v14:BuffUp(v95.AvengingWrathBuff) or v14:BuffUp(v95.CrusadeBuff) or v14:BuffUp(v95.EmpyreanPowerBuff))) then
					local v195 = 297 - (45 + 252);
					while true do
						if (((1606 + 17) <= (674 + 1283)) and ((0 - 0) == v195)) then
							v29 = v116();
							if (((4845 - (114 + 319)) == (6334 - 1922)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if (((2242 - 492) >= (537 + 305)) and v95.Consecration:IsCastable() and v35 and v16:DebuffDown(v95.ConsecrationDebuff) and (v101 >= (2 - 0))) then
					if (((9160 - 4788) > (3813 - (556 + 1407))) and v24(v95.Consecration, not v16:IsInRange(1216 - (741 + 465)))) then
						return "consecration generators 22";
					end
				end
				v130 = 470 - (170 + 295);
			end
			if (((123 + 109) < (755 + 66)) and (v130 == (7 - 4))) then
				if (((430 + 88) < (579 + 323)) and v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (3 + 1))) then
					if (((4224 - (957 + 273)) > (230 + 628)) and v24(v95.TemplarSlash, not v16:IsSpellInRange(v95.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (2 + 1)) or not v95.BoundlessJudgment:IsAvailable())) or ((14308 - 10553) <= (2411 - 1496))) then
					if (((12052 - 8106) > (18534 - 14791)) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment generators 16";
					end
				end
				if ((v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (1783 - (389 + 1391))) or not v95.HolyBlade:IsAvailable())) or ((838 + 497) >= (345 + 2961))) then
					if (((11027 - 6183) > (3204 - (783 + 168))) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				v130 = 13 - 9;
			end
		end
	end
	local function v118()
		local v131 = 0 + 0;
		while true do
			if (((763 - (309 + 2)) == (1387 - 935)) and ((1219 - (1090 + 122)) == v131)) then
				v55 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v131 == (2 + 3)) or ((15304 - 10747) < (1429 + 658))) then
				v49 = EpicSettings.Settings['useCrusade'];
				v50 = EpicSettings.Settings['useFinalReckoning'];
				v51 = EpicSettings.Settings['useShieldofVengeance'];
				v131 = 1124 - (628 + 490);
			end
			if (((695 + 3179) == (9591 - 5717)) and (v131 == (0 - 0))) then
				v34 = EpicSettings.Settings['useBladeofJustice'];
				v35 = EpicSettings.Settings['useConsecration'];
				v36 = EpicSettings.Settings['useCrusaderStrike'];
				v131 = 775 - (431 + 343);
			end
			if ((v131 == (7 - 3)) or ((5606 - 3668) > (3899 + 1036))) then
				v46 = EpicSettings.Settings['useWakeofAshes'];
				v47 = EpicSettings.Settings['useVerdict'];
				v48 = EpicSettings.Settings['useAvengingWrath'];
				v131 = 1 + 4;
			end
			if ((v131 == (1697 - (556 + 1139))) or ((4270 - (6 + 9)) < (627 + 2796))) then
				v40 = EpicSettings.Settings['useExecutionSentence'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v42 = EpicSettings.Settings['useJudgment'];
				v131 = 2 + 1;
			end
			if (((1623 - (28 + 141)) <= (965 + 1526)) and (v131 == (3 - 0))) then
				v43 = EpicSettings.Settings['useJusticarsVengeance'];
				v44 = EpicSettings.Settings['useTemplarSlash'];
				v45 = EpicSettings.Settings['useTemplarStrike'];
				v131 = 3 + 1;
			end
			if ((v131 == (1323 - (486 + 831))) or ((10817 - 6660) <= (9868 - 7065))) then
				v52 = EpicSettings.Settings['avengingWrathWithCD'];
				v53 = EpicSettings.Settings['crusadeWithCD'];
				v54 = EpicSettings.Settings['finalReckoningWithCD'];
				v131 = 2 + 5;
			end
			if (((15344 - 10491) >= (4245 - (668 + 595))) and (v131 == (1 + 0))) then
				v37 = EpicSettings.Settings['useDivineHammer'];
				v38 = EpicSettings.Settings['useDivineStorm'];
				v39 = EpicSettings.Settings['useDivineToll'];
				v131 = 1 + 1;
			end
		end
	end
	local function v119()
		v56 = EpicSettings.Settings['useRebuke'];
		v57 = EpicSettings.Settings['useHammerofJustice'];
		v58 = EpicSettings.Settings['useDivineProtection'];
		v59 = EpicSettings.Settings['useDivineShield'];
		v60 = EpicSettings.Settings['useLayonHands'];
		v61 = EpicSettings.Settings['useLayonHandsFocus'];
		v62 = EpicSettings.Settings['useWordofGloryFocus'];
		v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v65 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
		v66 = EpicSettings.Settings['divineShieldHP'] or (290 - (23 + 267));
		v67 = EpicSettings.Settings['layonHandsHP'] or (1944 - (1129 + 815));
		v68 = EpicSettings.Settings['layonHandsFocusHP'] or (387 - (371 + 16));
		v69 = EpicSettings.Settings['wordofGloryFocusHP'] or (1750 - (1326 + 424));
		v70 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
		v71 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
		v72 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v73 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v93 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v120()
		v81 = EpicSettings.Settings['fightRemainsCheck'] or (118 - (88 + 30));
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
		v89 = EpicSettings.Settings['healthstoneHP'] or (771 - (720 + 51));
		v88 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v90 = EpicSettings.Settings['HealingPotionName'] or "";
		v76 = EpicSettings.Settings['handleAfflicted'];
		v77 = EpicSettings.Settings['HandleIncorporeal'];
		v91 = EpicSettings.Settings['HealOOC'];
		v92 = EpicSettings.Settings['HealOOCHP'] or (1776 - (421 + 1355));
	end
	local function v121()
		v119();
		v118();
		v120();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((6819 - 2685) > (1650 + 1707)) and v14:IsDeadOrGhost()) then
			return;
		end
		v100 = v14:GetEnemiesInMeleeRange(1093 - (286 + 797));
		if (v31 or ((12491 - 9074) < (4197 - 1663))) then
			v101 = #v100;
		else
			local v165 = 439 - (397 + 42);
			while true do
				if (((0 + 0) == v165) or ((3522 - (24 + 776)) <= (252 - 88))) then
					v100 = {};
					v101 = 786 - (222 + 563);
					break;
				end
			end
		end
		if ((not v14:AffectingCombat() and v14:IsMounted()) or ((5305 - 2897) < (1519 + 590))) then
			if ((v95.CrusaderAura:IsCastable() and (v14:BuffDown(v95.CrusaderAura))) or ((223 - (23 + 167)) == (3253 - (690 + 1108)))) then
				if (v24(v95.CrusaderAura) or ((160 + 283) >= (3312 + 703))) then
					return "crusader_aura";
				end
			end
		end
		if (((4230 - (40 + 808)) > (28 + 138)) and (v14:AffectingCombat() or v75)) then
			local v166 = 0 - 0;
			local v167;
			while true do
				if ((v166 == (0 + 0)) or ((149 + 131) == (1678 + 1381))) then
					v167 = v75 and v95.CleanseToxins:IsReady() and v33;
					v29 = v94.FocusUnit(v167, v99, 591 - (47 + 524), nil, 17 + 8);
					v166 = 2 - 1;
				end
				if (((2812 - 931) > (2948 - 1655)) and (v166 == (1727 - (1165 + 561)))) then
					if (((71 + 2286) == (7299 - 4942)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		local v161 = v94.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 16 + 24, 504 - (341 + 138));
		if (((34 + 89) == (253 - 130)) and v161) then
			return v161;
		end
		if ((v95.BlessingofFreedom:IsReady() and v94.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((1382 - (89 + 237)) >= (10911 - 7519))) then
			if (v24(v99.BlessingofFreedomFocus) or ((2275 - 1194) < (1956 - (581 + 300)))) then
				return "blessing_of_freedom combat";
			end
		end
		v104 = v108();
		if (not v14:AffectingCombat() or ((2269 - (855 + 365)) >= (10526 - 6094))) then
			if ((v95.RetributionAura:IsCastable() and (v109())) or ((1557 + 3211) <= (2081 - (1030 + 205)))) then
				if (v24(v95.RetributionAura) or ((3153 + 205) <= (1321 + 99))) then
					return "retribution_aura";
				end
			end
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((4025 - (156 + 130)) <= (6827 - 3822))) then
			if (v14:AffectingCombat() or ((2795 - 1136) >= (4370 - 2236))) then
				if (v95.Intercession:IsCastable() or ((860 + 2400) < (1374 + 981))) then
					if (v24(v95.Intercession, not v16:IsInRange(99 - (10 + 59)), true) or ((190 + 479) == (20797 - 16574))) then
						return "intercession target";
					end
				end
			elseif (v95.Redemption:IsCastable() or ((2855 - (671 + 492)) < (469 + 119))) then
				if (v24(v95.Redemption, not v16:IsInRange(1245 - (369 + 846)), true) or ((1270 + 3527) < (3116 + 535))) then
					return "redemption target";
				end
			end
		end
		if ((v95.Redemption:IsCastable() and v95.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((6122 - (1036 + 909)) > (3857 + 993))) then
			if (v24(v99.RedemptionMouseover) or ((671 - 271) > (1314 - (11 + 192)))) then
				return "redemption mouseover";
			end
		end
		if (((1542 + 1509) > (1180 - (135 + 40))) and v14:AffectingCombat()) then
			if (((8947 - 5254) <= (2642 + 1740)) and v95.Intercession:IsCastable() and (v14:HolyPower() >= (6 - 3)) and v95.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
				if (v24(v99.IntercessionMouseover) or ((4919 - 1637) > (4276 - (50 + 126)))) then
					return "Intercession mouseover";
				end
			end
		end
		if (v94.TargetIsValid() or v14:AffectingCombat() or ((9968 - 6388) < (630 + 2214))) then
			local v168 = 1413 - (1233 + 180);
			while true do
				if (((1058 - (522 + 447)) < (5911 - (107 + 1314))) and (v168 == (1 + 0))) then
					if ((v103 == (33856 - 22745)) or ((2117 + 2866) < (3590 - 1782))) then
						v103 = v9.FightRemains(v100, false);
					end
					v106 = v14:GCD();
					v168 = 7 - 5;
				end
				if (((5739 - (716 + 1194)) > (65 + 3704)) and (v168 == (1 + 1))) then
					v105 = v14:HolyPower();
					break;
				end
				if (((1988 - (74 + 429)) <= (5601 - 2697)) and (v168 == (0 + 0))) then
					v102 = v9.BossFightRemains(nil, true);
					v103 = v102;
					v168 = 2 - 1;
				end
			end
		end
		if (((3021 + 1248) == (13160 - 8891)) and v76) then
			if (((956 - 569) <= (3215 - (279 + 154))) and v72) then
				v161 = v94.HandleAfflicted(v95.CleanseToxins, v99.CleanseToxinsMouseover, 818 - (454 + 324));
				if (v161 or ((1495 + 404) <= (934 - (12 + 5)))) then
					return v161;
				end
			end
			if ((v73 and (v105 > (2 + 0))) or ((10986 - 6674) <= (324 + 552))) then
				local v192 = 1093 - (277 + 816);
				while true do
					if (((9537 - 7305) <= (3779 - (1058 + 125))) and (v192 == (0 + 0))) then
						v161 = v94.HandleAfflicted(v95.WordofGlory, v99.WordofGloryMouseover, 1015 - (815 + 160), true);
						if (((8988 - 6893) < (8749 - 5063)) and v161) then
							return v161;
						end
						break;
					end
				end
			end
		end
		if (v77 or ((381 + 1214) >= (13078 - 8604))) then
			v161 = v94.HandleIncorporeal(v95.Repentance, v99.RepentanceMouseOver, 1928 - (41 + 1857), true);
			if (v161 or ((6512 - (1222 + 671)) < (7448 - 4566))) then
				return v161;
			end
			v161 = v94.HandleIncorporeal(v95.TurnEvil, v99.TurnEvilMouseOver, 43 - 13, true);
			if (v161 or ((1476 - (229 + 953)) >= (6605 - (1111 + 663)))) then
				return v161;
			end
		end
		v161 = v111();
		if (((3608 - (874 + 705)) <= (432 + 2652)) and v161) then
			return v161;
		end
		if (v13 or ((1390 + 647) == (5030 - 2610))) then
			if (((126 + 4332) > (4583 - (642 + 37))) and v75) then
				local v193 = 0 + 0;
				while true do
					if (((70 + 366) >= (308 - 185)) and ((454 - (233 + 221)) == v193)) then
						v161 = v110();
						if (((1156 - 656) < (1599 + 217)) and v161) then
							return v161;
						end
						break;
					end
				end
			end
		end
		v161 = v112();
		if (((5115 - (718 + 823)) == (2249 + 1325)) and v161) then
			return v161;
		end
		if (((1026 - (266 + 539)) < (1104 - 714)) and not v14:AffectingCombat() and v30 and v94.TargetIsValid()) then
			local v169 = 1225 - (636 + 589);
			while true do
				if ((v169 == (0 - 0)) or ((4563 - 2350) <= (1127 + 294))) then
					v161 = v114();
					if (((1111 + 1947) < (5875 - (657 + 358))) and v161) then
						return v161;
					end
					break;
				end
			end
		end
		if ((v14:AffectingCombat() and v94.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((3431 - 2135) >= (10129 - 5683))) then
			if ((UseLayOnHands and (v14:HealthPercentage() <= v67) and v95.LayonHands:IsReady() and v14:DebuffDown(v95.ForbearanceDebuff)) or ((2580 - (1151 + 36)) > (4335 + 154))) then
				if (v24(v95.LayonHands) or ((1164 + 3260) < (80 - 53))) then
					return "lay_on_hands_player defensive";
				end
			end
			if ((v59 and (v14:HealthPercentage() <= v66) and v95.DivineShield:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) or ((3829 - (1552 + 280)) > (4649 - (64 + 770)))) then
				if (((2353 + 1112) > (4342 - 2429)) and v24(v95.DivineShield)) then
					return "divine_shield defensive";
				end
			end
			if (((131 + 602) < (3062 - (157 + 1086))) and v58 and v95.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v65)) then
				if (v24(v95.DivineProtection) or ((8797 - 4402) == (20825 - 16070))) then
					return "divine_protection defensive";
				end
			end
			if ((v96.Healthstone:IsReady() and v87 and (v14:HealthPercentage() <= v89)) or ((5817 - 2024) < (3232 - 863))) then
				if (v24(v99.Healthstone) or ((4903 - (599 + 220)) == (527 - 262))) then
					return "healthstone defensive";
				end
			end
			if (((6289 - (1813 + 118)) == (3186 + 1172)) and v86 and (v14:HealthPercentage() <= v88)) then
				if ((v90 == "Refreshing Healing Potion") or ((4355 - (841 + 376)) < (1390 - 397))) then
					if (((774 + 2556) > (6340 - 4017)) and v96.RefreshingHealingPotion:IsReady()) then
						if (v24(v99.RefreshingHealingPotion) or ((4485 - (464 + 395)) == (10237 - 6248))) then
							return "refreshing healing potion defensive";
						end
					end
				end
				if ((v90 == "Dreamwalker's Healing Potion") or ((440 + 476) == (3508 - (467 + 370)))) then
					if (((561 - 289) == (200 + 72)) and v96.DreamwalkersHealingPotion:IsReady()) then
						if (((14565 - 10316) <= (755 + 4084)) and v24(v99.RefreshingHealingPotion)) then
							return "dreamwalkers healing potion defensive";
						end
					end
				end
			end
			if (((6460 - 3683) < (3720 - (150 + 370))) and (v81 < v103)) then
				v161 = v115();
				if (((1377 - (74 + 1208)) < (4812 - 2855)) and v161) then
					return v161;
				end
			end
			v161 = v117();
			if (((3917 - 3091) < (1222 + 495)) and v161) then
				return v161;
			end
			if (((1816 - (14 + 376)) >= (1916 - 811)) and v24(v95.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v122()
		local v162 = 0 + 0;
		while true do
			if (((2420 + 334) <= (3223 + 156)) and (v162 == (0 - 0))) then
				v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v98();
				break;
			end
		end
	end
	v20.SetAPL(53 + 17, v121, OnInit);
end;
return v0["Epix_Paladin_Retribution.lua"]();

