local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((1953 - 699) >= (260 + 1465))) then
			v6 = v0[v4];
			if (not v6 or ((885 - 476) >= (1701 + 2123))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((2134 - (20 + 27)) == (2374 - (50 + 237))) and (v5 == (1 + 0))) then
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
		if (v98.CleanseToxins:IsAvailable() or ((5525 - 2121) > (2023 + 2480))) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 46975 - 35864;
	local v106 = 12604 - (711 + 782);
	local v107;
	local v108 = 0 - 0;
	local v109 = 469 - (270 + 199);
	local v110;
	v10:RegisterForEvent(function()
		v105 = 3603 + 7508;
		v106 = 12930 - (580 + 1239);
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v126 = v15:GCDRemains();
		local v127 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (29 - 19), v98.WakeofAshes:CooldownRemains());
		if ((v126 > v127) or ((3353 + 153) <= (48 + 1261))) then
			return v126;
		end
		return v127;
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v113()
		if (((1288 + 1667) == (7715 - 4760)) and v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(16 + 9)) then
			if (v25(v102.CleanseToxinsFocus) or ((4070 - (645 + 522)) == (3285 - (1010 + 780)))) then
				return "cleanse_toxins dispel";
			end
		end
	end
	local function v114()
		if (((4544 + 2) >= (10837 - 8562)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (((2400 - 1581) >= (1858 - (1045 + 791))) and v98.FlashofLight:IsReady()) then
				if (((8003 - 4841) == (4827 - 1665)) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v128 = 505 - (351 + 154);
		while true do
			if (((1575 - (1281 + 293)) == v128) or ((2635 - (28 + 238)) > (9896 - 5467))) then
				if (((5654 - (1381 + 178)) >= (2986 + 197)) and v14) then
					local v193 = 0 + 0;
					while true do
						if ((v193 == (1 + 0)) or ((12793 - 9082) < (523 + 485))) then
							if ((v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((1519 - (381 + 89)) <= (804 + 102))) then
								if (((3053 + 1460) > (4669 - 1943)) and v25(v102.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) or ((2637 - (1074 + 82)) >= (5824 - 3166))) then
								if (v25(v102.BlessingofProtectionFocus) or ((5004 - (214 + 1570)) == (2819 - (990 + 465)))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v193 == (0 + 0)) or ((459 + 595) > (3299 + 93))) then
							if ((v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) or ((2660 - 1984) >= (3368 - (1668 + 58)))) then
								if (((4762 - (512 + 114)) > (6249 - 3852)) and v25(v102.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) or ((8959 - 4625) == (14771 - 10526))) then
								if (v25(v102.LayonHandsFocus) or ((1990 + 2286) <= (568 + 2463))) then
									return "lay_on_hands defensive focus";
								end
							end
							v193 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v128 == (0 - 0)) or ((6776 - (109 + 1885)) <= (2668 - (1269 + 200)))) then
				if (v16:Exists() or ((9322 - 4458) < (2717 - (98 + 717)))) then
					if (((5665 - (802 + 24)) >= (6380 - 2680)) and v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) then
						if (v25(v102.WordofGloryMouseover) or ((1357 - 282) > (284 + 1634))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((305 + 91) <= (625 + 3179)) and (not v14 or not v14:Exists() or not v14:IsInRange(7 + 23))) then
					return;
				end
				v128 = 2 - 1;
			end
		end
	end
	local function v116()
		v30 = v97.HandleTopTrinket(v100, v33, 133 - 93, nil);
		if (v30 or ((1492 + 2677) == (891 + 1296))) then
			return v30;
		end
		v30 = v97.HandleBottomTrinket(v100, v33, 33 + 7, nil);
		if (((1023 + 383) == (657 + 749)) and v30) then
			return v30;
		end
	end
	local function v117()
		if (((2964 - (797 + 636)) < (20737 - 16466)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) then
			if (((2254 - (1427 + 192)) == (221 + 414)) and v25(v98.ShieldofVengeance)) then
				return "shield_of_vengeance precombat 1";
			end
		end
		if (((7830 - 4457) <= (3197 + 359)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (2 + 2))) then
			if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((3617 - (192 + 134)) < (4556 - (316 + 960)))) then
				return "juscticars vengeance precombat 2";
			end
		end
		if (((2441 + 1945) >= (674 + 199)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (4 + 0))) then
			if (((3520 - 2599) <= (1653 - (83 + 468))) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
				return "final verdict precombat 3";
			end
		end
		if (((6512 - (1202 + 604)) >= (4495 - 3532)) and v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (6 - 2))) then
			if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((2657 - 1697) <= (1201 - (45 + 280)))) then
				return "templars verdict precombat 4";
			end
		end
		if ((v98.BladeofJustice:IsCastable() and v35) or ((1995 + 71) == (815 + 117))) then
			if (((1762 + 3063) < (2680 + 2163)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
				return "blade_of_justice precombat 5";
			end
		end
		if ((v98.Judgment:IsCastable() and v43) or ((682 + 3195) >= (8401 - 3864))) then
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((6226 - (340 + 1571)) < (681 + 1045))) then
				return "judgment precombat 6";
			end
		end
		if ((v98.HammerofWrath:IsReady() and v42) or ((5451 - (1733 + 39)) < (1717 - 1092))) then
			if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((5659 - (125 + 909)) < (2580 - (1096 + 852)))) then
				return "hammer_of_wrath precombat 7";
			end
		end
		if ((v98.CrusaderStrike:IsCastable() and v37) or ((38 + 45) > (2542 - 762))) then
			if (((530 + 16) <= (1589 - (409 + 103))) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
				return "crusader_strike precombat 180";
			end
		end
	end
	local function v118()
		local v129 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (246 - (46 + 190)))) or (v106 < (120 - (51 + 44))));
		if (v129 or ((281 + 715) > (5618 - (1114 + 203)))) then
			return v129;
		end
		if (((4796 - (228 + 498)) > (149 + 538)) and v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) then
			if (v25(v98.LightsJudgment, not v17:IsInRange(23 + 17)) or ((1319 - (174 + 489)) >= (8675 - 5345))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (1915 - (830 + 1075)))))) or ((3016 - (303 + 221)) <= (1604 - (231 + 1038)))) then
			if (((3602 + 720) >= (3724 - (171 + 991))) and v25(v98.Fireblood, not v17:IsInRange(41 - 31))) then
				return "fireblood cooldowns 6";
			end
		end
		if ((v85 and ((v33 and v86) or not v86) and v17:IsInRange(21 - 13)) or ((9075 - 5438) >= (3018 + 752))) then
			local v185 = 0 - 0;
			while true do
				if ((v185 == (0 - 0)) or ((3834 - 1455) > (14151 - 9573))) then
					v30 = v116();
					if (v30 or ((1731 - (111 + 1137)) > (901 - (91 + 67)))) then
						return v30;
					end
					break;
				end
			end
		end
		if (((7303 - 4849) > (145 + 433)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (538 - (423 + 100))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) then
			if (((7 + 923) < (12343 - 7885)) and v25(v98.ShieldofVengeance)) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((346 + 316) <= (1743 - (326 + 445))) and v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (65 - 50))) or (v15:BuffStack(v98.CrusadeBuff) == (22 - 12)) or (v98.AvengingWrath:CooldownRemains() < (0.75 - 0)) or (v98.AvengingWrath:CooldownRemains() > (726 - (530 + 181)))) and (((v108 >= (885 - (614 + 267))) and (v10.CombatTime() < (37 - (19 + 13)))) or ((v108 >= (4 - 1)) and (v10.CombatTime() > (11 - 6))) or ((v108 >= (5 - 3)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (3 + 5)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (20 - 8)))) then
			if (((9062 - 4692) == (6182 - (1293 + 519))) and v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if ((v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (7 - 3)) and (v10.CombatTime() < (13 - 8))) or ((v108 >= (5 - 2)) and (v10.CombatTime() > (21 - 16))) or ((v108 >= (4 - 2)) and v98.DivineAuxiliary:IsAvailable() and (v98.ExecutionSentence:CooldownUp() or v98.FinalReckoning:CooldownUp())))) or ((2523 + 2239) <= (176 + 685))) then
			if (v25(v98.AvengingWrath, not v17:IsInRange(23 - 13)) or ((327 + 1085) == (1417 + 2847))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if ((v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v108 >= (3 + 1)) and (v10.CombatTime() < (1101 - (709 + 387)))) or ((v108 >= (1861 - (673 + 1185))) and (v10.CombatTime() >= (14 - 9))))) or ((10172 - 7004) < (3542 - 1389))) then
			if (v25(v98.Crusade, not v17:IsInRange(8 + 2)) or ((3719 + 1257) < (1797 - 465))) then
				return "crusade cooldowns 14";
			end
		end
		if (((1137 + 3491) == (9227 - 4599)) and v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (7 - 3)) and (v10.CombatTime() < (1888 - (446 + 1434)))) or ((v108 >= (1286 - (1040 + 243))) and (v10.CombatTime() >= (23 - 15))) or ((v108 >= (1849 - (559 + 1288))) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (1941 - (609 + 1322))) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (464 - (13 + 441)))))) and ((v107 > (0 - 0)) or (v108 == (13 - 8)) or ((v108 >= (9 - 7)) and v98.DivineAuxiliary:IsAvailable()))) then
			if ((v96 == "player") or ((3 + 51) == (1434 - 1039))) then
				if (((30 + 52) == (36 + 46)) and v25(v102.FinalReckoningPlayer, not v17:IsInRange(29 - 19))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if ((v96 == "cursor") or ((318 + 263) < (518 - 236))) then
				if (v25(v102.FinalReckoningCursor, not v17:IsInRange(14 + 6)) or ((2564 + 2045) < (1793 + 702))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v119()
		v110 = ((v104 >= (3 + 0)) or ((v104 >= (2 + 0)) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (457 - (153 + 280))));
		if (((3326 - 2174) == (1035 + 117)) and v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (2 + 1))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (6 + 4))))) then
			if (((1721 + 175) <= (2480 + 942)) and v25(v98.DivineStorm, not v17:IsInRange(15 - 5))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (2 + 1))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (677 - (89 + 578)))))) or ((708 + 282) > (3367 - 1747))) then
			if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((1926 - (572 + 477)) > (634 + 4061))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((1615 + 1076) >= (221 + 1630)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (89 - (84 + 2)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (16 - 6))))) then
			if (v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict)) or ((2151 + 834) >= (5698 - (497 + 345)))) then
				return "final verdict finishers 6";
			end
		end
		if (((110 + 4166) >= (203 + 992)) and v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1336 - (605 + 728)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (8 + 2))))) then
			if (((7185 - 3953) <= (215 + 4475)) and v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v120()
		local v130 = 0 - 0;
		while true do
			if ((v130 == (2 + 0)) or ((2482 - 1586) >= (2376 + 770))) then
				if (((3550 - (457 + 32)) >= (1256 + 1702)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (1406 - (832 + 570))) and (v104 >= (2 + 0))) then
					if (((832 + 2355) >= (2278 - 1634)) and v25(v98.TemplarSlash, not v17:IsInRange(5 + 5))) then
						return "templar_slash generators 8";
					end
				end
				if (((1440 - (588 + 208)) <= (1897 - 1193)) and v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (1803 - (884 + 916))) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (3 - 1)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (3 + 1)))) then
					if (((1611 - (232 + 421)) > (2836 - (1569 + 320))) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				if (((1103 + 3389) >= (505 + 2149)) and v98.HammerofWrath:IsReady() and v42 and ((v104 < (6 - 4)) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(635 - (316 + 289), 10 - 6)) and ((v108 <= (1 + 2)) or (v17:HealthPercentage() > (1473 - (666 + 787))) or not v98.VanguardsMomentum:IsAvailable())) then
					if (((3867 - (360 + 65)) >= (1405 + 98)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v130 = 257 - (79 + 175);
			end
			if ((v130 == (4 - 1)) or ((2474 + 696) <= (4487 - 3023))) then
				if ((v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (7 - 3))) or ((5696 - (503 + 396)) == (4569 - (92 + 89)))) then
					if (((1068 - 517) <= (350 + 331)) and v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if (((1940 + 1337) > (1593 - 1186)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (1 + 2)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((10705 - 6010) >= (1235 + 180)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (2 + 1)) or not v98.HolyBlade:IsAvailable())) or ((9782 - 6570) <= (118 + 826))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((4721 - 1625) <= (3042 - (485 + 759)))) then
						return "blade_of_justice generators 18";
					end
				end
				v130 = 8 - 4;
			end
			if (((4726 - (442 + 747)) == (4672 - (832 + 303))) and (v130 == (951 - (88 + 858)))) then
				if (((1170 + 2667) >= (1300 + 270)) and v98.DivineHammer:IsCastable() and v38 and (v104 >= (1 + 1))) then
					if (v25(v98.DivineHammer, not v17:IsInRange(799 - (766 + 23))) or ((14563 - 11613) == (5212 - 1400))) then
						return "divine_hammer generators 24";
					end
				end
				if (((12443 - 7720) >= (7867 - 5549)) and v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1074.75 - (1036 + 37))) and ((v108 <= (2 + 0)) or ((v108 <= (5 - 2)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (2 + 0)))) or ((v108 == (1484 - (641 + 839))) and (v98.BladeofJustice:CooldownRemains() > (v109 * (915 - (910 + 3)))) and (v98.Judgment:CooldownRemains() > (v109 * (4 - 2)))))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((3711 - (1466 + 218)) > (1311 + 1541))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v119();
				v130 = 1154 - (556 + 592);
			end
			if (((2 + 2) == v130) or ((1944 - (329 + 479)) > (5171 - (174 + 680)))) then
				if (((16314 - 11566) == (9841 - 5093)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (3 + 0)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((4475 - (396 + 343)) <= (420 + 4320)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 20";
					end
				end
				if ((v17:HealthPercentage() <= (1497 - (29 + 1448))) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff) or ((4779 - (135 + 1254)) <= (11527 - 8467))) then
					local v194 = 0 - 0;
					while true do
						if ((v194 == (0 + 0)) or ((2526 - (389 + 1138)) > (3267 - (102 + 472)))) then
							v30 = v119();
							if (((437 + 26) < (334 + 267)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (2 + 0))) or ((3728 - (320 + 1225)) < (1222 - 535))) then
					if (((2784 + 1765) == (6013 - (157 + 1307))) and v25(v98.Consecration, not v17:IsInRange(1869 - (821 + 1038)))) then
						return "consecration generators 22";
					end
				end
				v130 = 12 - 7;
			end
			if (((511 + 4161) == (8298 - 3626)) and (v130 == (1 + 0))) then
				if ((v98.DivineToll:IsCastable() and v40 and (v108 <= (4 - 2)) and ((v98.AvengingWrath:CooldownRemains() > (1041 - (834 + 192))) or (v98.Crusade:CooldownRemains() > (1 + 14)) or (v106 < (3 + 5)))) or ((79 + 3589) < (611 - 216))) then
					if (v25(v98.DivineToll, not v17:IsInRange(334 - (300 + 4))) or ((1113 + 3053) == (1191 - 736))) then
						return "divine_toll generators 6";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(393 - (112 + 250), 1 + 1)) or ((11145 - 6696) == (1526 + 1137))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((2212 + 2065) < (2236 + 753))) then
						return "judgment generators 7";
					end
				end
				if (((v108 >= (2 + 1)) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (8 + 2))) or ((2284 - (1001 + 413)) >= (9251 - 5102))) then
					local v195 = 882 - (244 + 638);
					while true do
						if (((2905 - (627 + 66)) < (9483 - 6300)) and (v195 == (602 - (512 + 90)))) then
							v30 = v119();
							if (((6552 - (1665 + 241)) > (3709 - (373 + 344))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v130 = 1 + 1;
			end
			if (((380 + 1054) < (8192 - 5086)) and (v130 == (11 - 4))) then
				if (((1885 - (35 + 1064)) < (2200 + 823)) and v98.Judgment:IsReady() and v43 and ((v108 <= (6 - 3)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((10 + 2432) < (1310 - (298 + 938)))) then
						return "judgment generators 32";
					end
				end
				if (((5794 - (233 + 1026)) == (6201 - (636 + 1030))) and v98.HammerofWrath:IsReady() and v42 and ((v108 <= (2 + 1)) or (v17:HealthPercentage() > (20 + 0)) or not v98.VanguardsMomentum:IsAvailable())) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((894 + 2115) <= (143 + 1962))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((2051 - (55 + 166)) < (712 + 2957)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((144 + 1286) >= (13794 - 10182))) then
						return "crusader_strike generators 26";
					end
				end
				v130 = 305 - (36 + 261);
			end
			if (((4691 - 2008) >= (3828 - (34 + 1334))) and (v130 == (4 + 4))) then
				if ((v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (4 + 1)) and (v84 < v106)) or ((3087 - (1035 + 248)) >= (3296 - (20 + 1)))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(6 + 4)) or ((1736 - (134 + 185)) > (4762 - (549 + 584)))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((5480 - (314 + 371)) > (1379 - 977)) and v98.Consecration:IsCastable() and v36) then
					if (((5781 - (478 + 490)) > (1889 + 1676)) and v25(v98.Consecration, not v17:IsInRange(1182 - (786 + 386)))) then
						return "consecration generators 30";
					end
				end
				if (((12670 - 8758) == (5291 - (1055 + 324))) and v98.DivineHammer:IsCastable() and v38) then
					if (((4161 - (1093 + 247)) <= (4287 + 537)) and v25(v98.DivineHammer, not v17:IsInRange(2 + 8))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((6900 - 5162) <= (7449 - 5254)) and (v130 == (16 - 10))) then
				if (((102 - 61) <= (1074 + 1944)) and v30) then
					return v30;
				end
				if (((8263 - 6118) <= (14145 - 10041)) and v98.TemplarSlash:IsReady() and v45) then
					if (((2028 + 661) < (12390 - 7545)) and v25(v98.TemplarSlash, not v17:IsInRange(698 - (364 + 324)))) then
						return "templar_slash generators 28";
					end
				end
				if ((v98.TemplarStrike:IsReady() and v46) or ((6365 - 4043) > (6291 - 3669))) then
					if (v25(v98.TemplarStrike, not v17:IsInRange(4 + 6)) or ((18971 - 14437) == (3333 - 1251))) then
						return "templar_strike generators 30";
					end
				end
				v130 = 21 - 14;
			end
			if (((1268 - (1249 + 19)) == v130) or ((1419 + 152) > (7267 - 5400))) then
				if ((v108 >= (1091 - (686 + 400))) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(25 + 6, 233 - (73 + 156)) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (1 + 3))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(842 - (721 + 90), 1 + 1)) or ((8617 - 5963) >= (3466 - (224 + 246)))) then
					v30 = v119();
					if (((6443 - 2465) > (3873 - 1769)) and v30) then
						return v30;
					end
				end
				if (((544 + 2451) > (37 + 1504)) and v98.WakeofAshes:IsCastable() and v47 and (v108 <= (2 + 0)) and (v98.AvengingWrath:CooldownDown() or v98.Crusade:CooldownDown()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (7 - 3)) or (v106 < (26 - 18)))) then
					if (((3762 - (203 + 310)) > (2946 - (1238 + 755))) and v25(v98.WakeofAshes, not v17:IsInRange(1 + 9))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (1537 - (709 + 825))) and v15:HasTier(56 - 25, 2 - 0)) or ((4137 - (196 + 668)) > (18055 - 13482))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((6526 - 3375) < (2117 - (171 + 662)))) then
						return "blade_of_justice generators 4";
					end
				end
				v130 = 94 - (4 + 89);
			end
		end
	end
	local function v121()
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
		v67 = EpicSettings.Settings['divineProtectionHP'] or (0 - 0);
		v68 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
		v69 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
		v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
		v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (1486 - (35 + 1451));
		v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (1453 - (28 + 1425));
		v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (1993 - (941 + 1052));
		v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
		v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
		v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
	end
	local function v123()
		v84 = EpicSettings.Settings['fightRemainsCheck'] or (1514 - (822 + 692));
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
		v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v91 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v93 = EpicSettings.Settings['HealingPotionName'] or "";
		v79 = EpicSettings.Settings['handleAfflicted'];
		v80 = EpicSettings.Settings['HandleIncorporeal'];
		v94 = EpicSettings.Settings['HealOOC'];
		v95 = EpicSettings.Settings['HealOOCHP'] or (297 - (45 + 252));
	end
	local function v124()
		v122();
		v121();
		v123();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v34 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((1831 + 19) == (527 + 1002))) then
			return v30;
		end
		v103 = v15:GetEnemiesInMeleeRange(19 - 11);
		if (((1254 - (114 + 319)) < (3047 - 924)) and v32) then
			v104 = #v103;
		else
			local v186 = 0 - 0;
			while true do
				if (((576 + 326) < (3463 - 1138)) and (v186 == (0 - 0))) then
					v103 = {};
					v104 = 1964 - (556 + 1407);
					break;
				end
			end
		end
		if (((2064 - (741 + 465)) <= (3427 - (170 + 295))) and not v15:AffectingCombat() and v15:IsMounted()) then
			if ((v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) or ((2080 + 1866) < (1184 + 104))) then
				if (v25(v98.CrusaderAura) or ((7981 - 4739) == (471 + 96))) then
					return "crusader_aura";
				end
			end
		end
		if (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()) or ((544 + 303) >= (716 + 547))) then
			local v187 = v78 and v98.CleanseToxins:IsReady() and v34;
			v30 = v97.FocusUnit(v187, v102, 1250 - (957 + 273), nil, 7 + 18);
			if (v30 or ((902 + 1351) == (7053 - 5202))) then
				return v30;
			end
		end
		if (v34 or ((5499 - 3412) > (7244 - 4872))) then
			local v188 = 0 - 0;
			while true do
				if ((v188 == (1781 - (389 + 1391))) or ((2789 + 1656) < (432 + 3717))) then
					if ((v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((4138 - 2320) == (1036 - (783 + 168)))) then
						if (((2114 - 1484) < (2093 + 34)) and v25(v102.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if ((v188 == (311 - (309 + 2))) or ((5951 - 4013) == (3726 - (1090 + 122)))) then
					v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 13 + 27, 83 - 58);
					if (((2912 + 1343) >= (1173 - (628 + 490))) and v30) then
						return v30;
					end
					v188 = 1 + 0;
				end
			end
		end
		v107 = v111();
		if (((7424 - 4425) > (5282 - 4126)) and not v15:AffectingCombat()) then
			if (((3124 - (431 + 343)) > (2332 - 1177)) and v98.RetributionAura:IsCastable() and (v112())) then
				if (((11655 - 7626) <= (3834 + 1019)) and v25(v98.RetributionAura)) then
					return "retribution_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((66 + 450) > (5129 - (556 + 1139)))) then
			if (((4061 - (6 + 9)) >= (556 + 2477)) and v15:AffectingCombat()) then
				if (v98.Intercession:IsCastable() or ((1393 + 1326) <= (1616 - (28 + 141)))) then
					if (v25(v98.Intercession, not v17:IsInRange(12 + 18), true) or ((5102 - 968) < (2781 + 1145))) then
						return "intercession target";
					end
				end
			elseif (v98.Redemption:IsCastable() or ((1481 - (486 + 831)) >= (7247 - 4462))) then
				if (v25(v98.Redemption, not v17:IsInRange(105 - 75), true) or ((100 + 425) == (6668 - 4559))) then
					return "redemption target";
				end
			end
		end
		if (((1296 - (668 + 595)) == (30 + 3)) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (((616 + 2438) <= (10949 - 6934)) and v25(v102.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((2161 - (23 + 267)) < (5326 - (1129 + 815))) and v15:AffectingCombat()) then
			if (((1680 - (371 + 16)) <= (3916 - (1326 + 424))) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (5 - 2)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v102.IntercessionMouseover) or ((9424 - 6845) < (241 - (88 + 30)))) then
					return "Intercession mouseover";
				end
			end
		end
		if (v97.TargetIsValid() or v15:AffectingCombat() or ((1617 - (720 + 51)) >= (5267 - 2899))) then
			v105 = v10.BossFightRemains(nil, true);
			v106 = v105;
			if ((v106 == (12887 - (421 + 1355))) or ((6618 - 2606) <= (1650 + 1708))) then
				v106 = v10.FightRemains(v103, false);
			end
			v109 = v15:GCD();
			v108 = v15:HolyPower();
		end
		if (((2577 - (286 + 797)) <= (10985 - 7980)) and v79) then
			if (v75 or ((5152 - 2041) == (2573 - (397 + 42)))) then
				v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 13 + 27);
				if (((3155 - (24 + 776)) == (3628 - 1273)) and v30) then
					return v30;
				end
			end
			if ((v76 and (v108 > (787 - (222 + 563)))) or ((1295 - 707) <= (312 + 120))) then
				local v190 = 190 - (23 + 167);
				while true do
					if (((6595 - (690 + 1108)) >= (1406 + 2489)) and (v190 == (0 + 0))) then
						v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 888 - (40 + 808), true);
						if (((589 + 2988) == (13678 - 10101)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (((3627 + 167) > (1954 + 1739)) and v80) then
			v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 17 + 13, true);
			if (v30 or ((1846 - (47 + 524)) == (2661 + 1439))) then
				return v30;
			end
			v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 82 - 52, true);
			if (v30 or ((2378 - 787) >= (8164 - 4584))) then
				return v30;
			end
		end
		v30 = v114();
		if (((2709 - (1165 + 561)) <= (54 + 1754)) and v30) then
			return v30;
		end
		if ((v78 and v34) or ((6658 - 4508) <= (457 + 740))) then
			if (((4248 - (341 + 138)) >= (317 + 856)) and v14) then
				local v191 = 0 - 0;
				while true do
					if (((1811 - (89 + 237)) == (4777 - 3292)) and (v191 == (0 - 0))) then
						v30 = v113();
						if (v30 or ((4196 - (581 + 300)) <= (4002 - (855 + 365)))) then
							return v30;
						end
						break;
					end
				end
			end
			if ((v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) or ((2080 - 1204) >= (968 + 1996))) then
				if (v98.CleanseToxins:IsReady() or ((3467 - (1030 + 205)) > (2345 + 152))) then
					if (v25(v102.CleanseToxinsMouseover) or ((1963 + 147) <= (618 - (156 + 130)))) then
						return "cleanse_toxins dispel mouseover";
					end
				end
			end
		end
		v30 = v115();
		if (((8375 - 4689) > (5345 - 2173)) and v30) then
			return v30;
		end
		if ((not v15:AffectingCombat() and v31 and v97.TargetIsValid()) or ((9162 - 4688) < (217 + 603))) then
			local v189 = 0 + 0;
			while true do
				if (((4348 - (10 + 59)) >= (816 + 2066)) and (v189 == (0 - 0))) then
					v30 = v117();
					if (v30 or ((3192 - (671 + 492)) >= (2803 + 718))) then
						return v30;
					end
					break;
				end
			end
		end
		if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((3252 - (369 + 846)) >= (1229 + 3413))) then
			if (((1468 + 252) < (6403 - (1036 + 909))) and v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) then
				if (v25(v98.LayonHands) or ((347 + 89) > (5071 - 2050))) then
					return "lay_on_hands_player defensive";
				end
			end
			if (((916 - (11 + 192)) <= (429 + 418)) and v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
				if (((2329 - (135 + 40)) <= (9766 - 5735)) and v25(v98.DivineShield)) then
					return "divine_shield defensive";
				end
			end
			if (((2782 + 1833) == (10166 - 5551)) and v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) then
				if (v25(v98.DivineProtection) or ((5681 - 1891) == (676 - (50 + 126)))) then
					return "divine_protection defensive";
				end
			end
			if (((247 - 158) < (49 + 172)) and v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
				if (((3467 - (1233 + 180)) >= (2390 - (522 + 447))) and v25(v102.Healthstone)) then
					return "healthstone defensive";
				end
			end
			if (((2113 - (107 + 1314)) < (1420 + 1638)) and v89 and (v15:HealthPercentage() <= v91)) then
				local v192 = 0 - 0;
				while true do
					if ((v192 == (0 + 0)) or ((6461 - 3207) == (6548 - 4893))) then
						if ((v93 == "Refreshing Healing Potion") or ((3206 - (716 + 1194)) == (84 + 4826))) then
							if (((361 + 3007) == (3871 - (74 + 429))) and v99.RefreshingHealingPotion:IsReady()) then
								if (((5098 - 2455) < (1891 + 1924)) and v25(v102.RefreshingHealingPotion)) then
									return "refreshing healing potion defensive";
								end
							end
						end
						if (((4378 - 2465) > (349 + 144)) and (v93 == "Dreamwalker's Healing Potion")) then
							if (((14659 - 9904) > (8475 - 5047)) and v99.DreamwalkersHealingPotion:IsReady()) then
								if (((1814 - (279 + 154)) <= (3147 - (454 + 324))) and v25(v102.RefreshingHealingPotion)) then
									return "dreamwalkers healing potion defensive";
								end
							end
						end
						break;
					end
				end
			end
			if ((v84 < v106) or ((3811 + 1032) == (4101 - (12 + 5)))) then
				v30 = v118();
				if (((2518 + 2151) > (924 - 561)) and v30) then
					return v30;
				end
			end
			v30 = v120();
			if (v30 or ((694 + 1183) >= (4231 - (277 + 816)))) then
				return v30;
			end
			if (((20262 - 15520) >= (4809 - (1058 + 125))) and v25(v98.Pool)) then
				return "Wait/Pool Resources";
			end
		end
	end
	local function v125()
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v101();
	end
	v21.SetAPL(14 + 56, v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

