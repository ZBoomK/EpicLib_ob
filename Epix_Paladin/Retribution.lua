local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((4056 - (228 + 498)) < (310 + 1119))) then
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
		if (((634 + 513) >= (998 - (174 + 489))) and v95.CleanseToxins:IsAvailable()) then
			v94.DispellableDebuffs = v12.MergeTable(v94.DispellableDiseaseDebuffs, v94.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v98();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v99 = v23.Paladin.Retribution;
	local v100;
	local v101;
	local v102 = 28947 - 17836;
	local v103 = 13016 - (830 + 1075);
	local v104;
	local v105 = 524 - (303 + 221);
	local v106 = 1269 - (231 + 1038);
	local v107;
	v9:RegisterForEvent(function()
		v102 = 9259 + 1852;
		v103 = 12273 - (171 + 991);
	end, "PLAYER_REGEN_ENABLED");
	local function v108()
		local v123 = 0 - 0;
		local v124;
		local v125;
		while true do
			if (((9223 - 5788) > (5232 - 3135)) and (v123 == (1 + 0))) then
				if ((v124 > v125) or ((13215 - 9445) >= (11657 - 7616))) then
					return v124;
				end
				return v125;
			end
			if ((v123 == (0 - 0)) or ((11718 - 7927) <= (2859 - (111 + 1137)))) then
				v124 = v14:GCDRemains();
				v125 = v27(v95.CrusaderStrike:CooldownRemains(), v95.BladeofJustice:CooldownRemains(), v95.Judgment:CooldownRemains(), (v95.HammerofWrath:IsUsable() and v95.HammerofWrath:CooldownRemains()) or (168 - (91 + 67)), v95.WakeofAshes:CooldownRemains());
				v123 = 2 - 1;
			end
		end
	end
	local function v109()
		return v14:BuffDown(v95.RetributionAura) and v14:BuffDown(v95.DevotionAura) and v14:BuffDown(v95.ConcentrationAura) and v14:BuffDown(v95.CrusaderAura);
	end
	local function v110()
		if ((v95.CleanseToxins:IsReady() and v33 and v94.DispellableFriendlyUnit(7 + 18)) or ((5101 - (423 + 100)) <= (15 + 1993))) then
			if (((3114 - 1989) <= (1083 + 993)) and v24(v99.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v111()
		if ((v91 and (v14:HealthPercentage() <= v92)) or ((1514 - (326 + 445)) >= (19197 - 14798))) then
			if (((2572 - 1417) < (3904 - 2231)) and v95.FlashofLight:IsReady()) then
				if (v24(v95.FlashofLight) or ((3035 - (530 + 181)) <= (1459 - (614 + 267)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v112()
		local v126 = 32 - (19 + 13);
		while true do
			if (((6131 - 2364) == (8778 - 5011)) and (v126 == (0 - 0))) then
				if (((1062 + 3027) == (7190 - 3101)) and (not v13 or not v13:Exists() or not v13:IsInRange(62 - 32))) then
					return;
				end
				if (((6270 - (1293 + 519)) >= (3415 - 1741)) and v13) then
					local v190 = 0 - 0;
					while true do
						if (((1858 - 886) <= (6114 - 4696)) and (v190 == (0 - 0))) then
							if ((v95.WordofGlory:IsReady() and v62 and (v13:HealthPercentage() <= v69)) or ((2616 + 2322) < (972 + 3790))) then
								if (v24(v99.WordofGloryFocus) or ((5817 - 3313) > (986 + 3278))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((716 + 1437) == (1346 + 807)) and v95.LayonHands:IsCastable() and v61 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v68)) then
								if (v24(v99.LayonHandsFocus) or ((1603 - (709 + 387)) >= (4449 - (673 + 1185)))) then
									return "lay_on_hands defensive focus";
								end
							end
							v190 = 2 - 1;
						end
						if (((14389 - 9908) == (7372 - 2891)) and ((1 + 0) == v190)) then
							if ((v95.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v71)) or ((1740 + 588) < (934 - 241))) then
								if (((1063 + 3265) == (8629 - 4301)) and v24(v99.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((3116 - 1528) >= (3212 - (446 + 1434))) and v95.BlessingofProtection:IsCastable() and v63 and v13:DebuffDown(v95.ForbearanceDebuff) and (v13:HealthPercentage() <= v70)) then
								if (v24(v99.BlessingofProtectionFocus) or ((5457 - (1040 + 243)) > (12678 - 8430))) then
									return "blessing_of_protection defensive focus";
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
	local function v113()
		local v127 = 1847 - (559 + 1288);
		while true do
			if ((v127 == (1931 - (609 + 1322))) or ((5040 - (13 + 441)) <= (306 - 224))) then
				v29 = v94.HandleTopTrinket(v97, v32, 104 - 64, nil);
				if (((19239 - 15376) == (144 + 3719)) and v29) then
					return v29;
				end
				v127 = 3 - 2;
			end
			if ((v127 == (1 + 0)) or ((124 + 158) <= (124 - 82))) then
				v29 = v94.HandleBottomTrinket(v97, v32, 22 + 18, nil);
				if (((8476 - 3867) >= (507 + 259)) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v114()
		local v128 = 0 + 0;
		while true do
			if ((v128 == (2 + 0)) or ((968 + 184) == (2435 + 53))) then
				if (((3855 - (153 + 280)) > (9673 - 6323)) and v95.BladeofJustice:IsCastable() and v34) then
					if (((788 + 89) > (149 + 227)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				if ((v95.Judgment:IsCastable() and v42) or ((1632 + 1486) <= (1680 + 171))) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((120 + 45) >= (5316 - 1824))) then
						return "judgment precombat 6";
					end
				end
				v128 = 2 + 1;
			end
			if (((4616 - (89 + 578)) < (3469 + 1387)) and (v128 == (0 - 0))) then
				if ((v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((5325 - (572 + 477)) < (407 + 2609))) then
					if (((2815 + 1875) > (493 + 3632)) and v24(v95.ShieldofVengeance)) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v95.JusticarsVengeance:IsAvailable() and v95.JusticarsVengeance:IsReady() and v43 and (v105 >= (90 - (84 + 2)))) or ((82 - 32) >= (646 + 250))) then
					if (v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance)) or ((2556 - (497 + 345)) >= (76 + 2882))) then
						return "juscticars vengeance precombat 2";
					end
				end
				v128 = 1 + 0;
			end
			if ((v128 == (1336 - (605 + 728))) or ((1064 + 427) < (1431 - 787))) then
				if (((33 + 671) < (3649 - 2662)) and v95.HammerofWrath:IsReady() and v41) then
					if (((3352 + 366) > (5280 - 3374)) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if ((v95.CrusaderStrike:IsCastable() and v36) or ((724 + 234) > (4124 - (457 + 32)))) then
					if (((1486 + 2015) <= (5894 - (832 + 570))) and v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((1 + 0) == v128) or ((898 + 2544) < (9016 - 6468))) then
				if (((1385 + 1490) >= (2260 - (588 + 208))) and v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsReady() and v47 and (v105 >= (10 - 6))) then
					if (v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict)) or ((6597 - (884 + 916)) >= (10243 - 5350))) then
						return "final verdict precombat 3";
					end
				end
				if ((v95.TemplarsVerdict:IsReady() and v47 and (v105 >= (3 + 1))) or ((1204 - (232 + 421)) > (3957 - (1569 + 320)))) then
					if (((519 + 1595) > (180 + 764)) and v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				v128 = 6 - 4;
			end
		end
	end
	local function v115()
		local v129 = 605 - (316 + 289);
		local v130;
		while true do
			if (((2 - 1) == v129) or ((105 + 2157) >= (4549 - (666 + 787)))) then
				if ((v95.LightsJudgment:IsCastable() and v84 and ((v85 and v32) or not v85)) or ((2680 - (360 + 65)) >= (3306 + 231))) then
					if (v24(v95.LightsJudgment, not v16:IsInRange(294 - (79 + 175))) or ((6049 - 2212) < (1020 + 286))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((9042 - 6092) == (5681 - 2731)) and v95.Fireblood:IsCastable() and v84 and ((v85 and v32) or not v85) and (v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) == (909 - (503 + 396)))))) then
					if (v24(v95.Fireblood, not v16:IsInRange(191 - (92 + 89))) or ((9161 - 4438) < (1692 + 1606))) then
						return "fireblood cooldowns 6";
					end
				end
				v129 = 2 + 0;
			end
			if (((4448 - 3312) >= (22 + 132)) and (v129 == (8 - 4))) then
				if ((v95.Crusade:IsCastable() and v49 and ((v32 and v53) or not v53) and (((v105 >= (4 + 0)) and (v9.CombatTime() < (3 + 2))) or ((v105 >= (8 - 5)) and (v9.CombatTime() >= (1 + 4))))) or ((412 - 141) > (5992 - (485 + 759)))) then
					if (((10967 - 6227) >= (4341 - (442 + 747))) and v24(v95.Crusade, not v16:IsInRange(1145 - (832 + 303)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v95.FinalReckoning:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v105 >= (950 - (88 + 858))) and (v9.CombatTime() < (3 + 5))) or ((v105 >= (3 + 0)) and (v9.CombatTime() >= (1 + 7))) or ((v105 >= (791 - (766 + 23))) and v95.DivineAuxiliary:IsAvailable())) and ((v95.AvengingWrath:CooldownRemains() > (49 - 39)) or (v95.Crusade:CooldownDown() and (v14:BuffDown(v95.CrusadeBuff) or (v14:BuffStack(v95.CrusadeBuff) >= (13 - 3))))) and ((v104 > (0 - 0)) or (v105 == (16 - 11)) or ((v105 >= (1075 - (1036 + 37))) and v95.DivineAuxiliary:IsAvailable()))) or ((1828 + 750) >= (6601 - 3211))) then
					local v191 = 0 + 0;
					while true do
						if (((1521 - (641 + 839)) <= (2574 - (910 + 3))) and (v191 == (0 - 0))) then
							if (((2285 - (1466 + 218)) < (1637 + 1923)) and (v93 == "player")) then
								if (((1383 - (556 + 592)) < (245 + 442)) and v24(v99.FinalReckoningPlayer, not v16:IsInRange(818 - (329 + 479)))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if (((5403 - (174 + 680)) > (3961 - 2808)) and (v93 == "cursor")) then
								if (v24(v99.FinalReckoningCursor, not v16:IsInRange(41 - 21)) or ((3338 + 1336) < (5411 - (396 + 343)))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((325 + 3343) < (6038 - (29 + 1448))) and (v129 == (1391 - (135 + 1254)))) then
				if ((v82 and ((v32 and v83) or not v83) and v16:IsInRange(30 - 22)) or ((2124 - 1669) == (2403 + 1202))) then
					local v192 = 1527 - (389 + 1138);
					while true do
						if ((v192 == (574 - (102 + 472))) or ((2514 + 149) == (1837 + 1475))) then
							v29 = v113();
							if (((3988 + 289) <= (6020 - (320 + 1225))) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v95.ShieldofVengeance:IsCastable() and v51 and ((v32 and v55) or not v55) and (v103 > (26 - 11)) and (not v95.ExecutionSentence:IsAvailable() or v16:DebuffDown(v95.ExecutionSentence))) or ((533 + 337) == (2653 - (157 + 1307)))) then
					if (((3412 - (821 + 1038)) <= (7816 - 4683)) and v24(v95.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v129 = 1 + 2;
			end
			if ((v129 == (0 - 0)) or ((833 + 1404) >= (8702 - 5191))) then
				v130 = v94.HandleDPSPotion(v14:BuffUp(v95.AvengingWrathBuff) or (v14:BuffUp(v95.CrusadeBuff) and (v14.BuffStack(v95.Crusade) == (1036 - (834 + 192)))) or (v103 < (2 + 23)));
				if (v130 or ((340 + 984) > (65 + 2955))) then
					return v130;
				end
				v129 = 1 - 0;
			end
			if (((307 - (300 + 4)) == v129) or ((800 + 2192) == (4923 - 3042))) then
				if (((3468 - (112 + 250)) > (609 + 917)) and v95.ExecutionSentence:IsCastable() and v40 and ((v14:BuffDown(v95.CrusadeBuff) and (v95.Crusade:CooldownRemains() > (37 - 22))) or (v14:BuffStack(v95.CrusadeBuff) == (6 + 4)) or (v95.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v95.AvengingWrath:CooldownRemains() > (12 + 3))) and (((v105 >= (2 + 2)) and (v9.CombatTime() < (4 + 1))) or ((v105 >= (1417 - (1001 + 413))) and (v9.CombatTime() > (11 - 6))) or ((v105 >= (884 - (244 + 638))) and v95.DivineAuxiliary:IsAvailable())) and (((v103 > (701 - (627 + 66))) and not v95.ExecutionersWill:IsAvailable()) or (v103 > (35 - 23)))) then
					if (((3625 - (512 + 90)) < (5776 - (1665 + 241))) and v24(v95.ExecutionSentence, not v16:IsSpellInRange(v95.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((860 - (373 + 344)) > (34 + 40)) and v95.AvengingWrath:IsCastable() and v48 and ((v32 and v52) or not v52) and (((v105 >= (2 + 2)) and (v9.CombatTime() < (13 - 8))) or ((v105 >= (4 - 1)) and (v9.CombatTime() > (1104 - (35 + 1064)))) or ((v105 >= (2 + 0)) and v95.DivineAuxiliary:IsAvailable() and (v95.ExecutionSentence:CooldownUp() or v95.FinalReckoning:CooldownUp())))) then
					if (((38 - 20) < (9 + 2103)) and v24(v95.AvengingWrath, not v16:IsInRange(1246 - (298 + 938)))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v129 = 1263 - (233 + 1026);
			end
		end
	end
	local function v116()
		local v131 = 1666 - (636 + 1030);
		while true do
			if (((561 + 536) <= (1591 + 37)) and (v131 == (1 + 0))) then
				if (((313 + 4317) == (4851 - (55 + 166))) and v95.JusticarsVengeance:IsReady() and v43 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (1 + 2))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (2 + 8))))) then
					if (((13519 - 9979) > (2980 - (36 + 261))) and v24(v95.JusticarsVengeance, not v16:IsSpellInRange(v95.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((8383 - 3589) >= (4643 - (34 + 1334))) and v95.FinalVerdict:IsAvailable() and v95.FinalVerdict:IsCastable() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (2 + 1))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (8 + 2))))) then
					if (((2767 - (1035 + 248)) == (1505 - (20 + 1))) and v24(v95.FinalVerdict, not v16:IsSpellInRange(v95.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v131 = 2 + 0;
			end
			if (((1751 - (134 + 185)) < (4688 - (549 + 584))) and (v131 == (685 - (314 + 371)))) then
				v107 = ((v101 >= (10 - 7)) or ((v101 >= (970 - (478 + 490))) and not v95.DivineArbiter:IsAvailable()) or v14:BuffUp(v95.EmpyreanPowerBuff)) and v14:BuffDown(v95.EmpyreanLegacyBuff) and not (v14:BuffUp(v95.DivineArbiterBuff) and (v14:BuffStack(v95.DivineArbiterBuff) > (13 + 11)));
				if ((v95.DivineStorm:IsReady() and v38 and v107 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (1175 - (786 + 386)))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (32 - 22))))) or ((2444 - (1055 + 324)) > (4918 - (1093 + 247)))) then
					if (v24(v95.DivineStorm, not v16:IsInRange(9 + 1)) or ((505 + 4290) < (5586 - 4179))) then
						return "divine_storm finishers 2";
					end
				end
				v131 = 3 - 2;
			end
			if (((5272 - 3419) < (12094 - 7281)) and (v131 == (1 + 1))) then
				if ((v95.TemplarsVerdict:IsReady() and v47 and (not v95.Crusade:IsAvailable() or (v95.Crusade:CooldownRemains() > (v106 * (11 - 8))) or (v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (34 - 24))))) or ((2128 + 693) < (6216 - 3785))) then
					if (v24(v95.TemplarsVerdict, not v16:IsSpellInRange(v95.TemplarsVerdict)) or ((3562 - (364 + 324)) < (5978 - 3797))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v132 = 0 - 0;
		while true do
			if (((1 + 1) == v132) or ((11251 - 8562) <= (549 - 206))) then
				if ((v95.HammerofWrath:IsReady() and v41 and ((v101 < (5 - 3)) or not v95.BlessedChampion:IsAvailable() or v14:HasTier(1298 - (1249 + 19), 4 + 0)) and ((v105 <= (11 - 8)) or (v16:HealthPercentage() > (1106 - (686 + 400))) or not v95.VanguardsMomentum:IsAvailable())) or ((1467 + 402) == (2238 - (73 + 156)))) then
					if (v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath)) or ((17 + 3529) < (3133 - (721 + 90)))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if ((v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (1 + 3))) or ((6759 - 4677) == (5243 - (224 + 246)))) then
					if (((5254 - 2010) > (1942 - 887)) and v24(v95.TemplarSlash, not v16:IsSpellInRange(v95.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (1 + 2)) or not v95.BoundlessJudgment:IsAvailable())) or ((79 + 3234) <= (1306 + 472))) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((2824 - 1403) >= (7001 - 4897))) then
						return "judgment generators 16";
					end
				end
				if (((2325 - (203 + 310)) <= (5242 - (1238 + 755))) and v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (1 + 2)) or not v95.HolyBlade:IsAvailable())) then
					if (((3157 - (709 + 825)) <= (3606 - 1649)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				v132 = 3 - 0;
			end
			if (((5276 - (196 + 668)) == (17419 - 13007)) and (v132 == (1 - 0))) then
				if (((2583 - (171 + 662)) >= (935 - (4 + 89))) and v95.Judgment:IsReady() and v42 and v16:DebuffUp(v95.ExpurgationDebuff) and v14:BuffDown(v95.EchoesofWrathBuff) and v14:HasTier(108 - 77, 1 + 1)) then
					if (((19202 - 14830) > (726 + 1124)) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment generators 7";
					end
				end
				if (((1718 - (35 + 1451)) < (2274 - (28 + 1425))) and (v105 >= (1996 - (941 + 1052))) and v14:BuffUp(v95.CrusadeBuff) and (v14:BuffStack(v95.CrusadeBuff) < (10 + 0))) then
					local v193 = 1514 - (822 + 692);
					while true do
						if (((739 - 221) < (425 + 477)) and (v193 == (297 - (45 + 252)))) then
							v29 = v116();
							if (((2963 + 31) > (296 + 562)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v95.TemplarSlash:IsReady() and v44 and ((v95.TemplarStrike:TimeSinceLastCast() + v106) < (9 - 5)) and (v101 >= (435 - (114 + 319)))) or ((5390 - 1635) <= (1172 - 257))) then
					if (((2516 + 1430) > (5576 - 1833)) and v24(v95.TemplarSlash, not v16:IsInRange(20 - 10))) then
						return "templar_slash generators 8";
					end
				end
				if ((v95.BladeofJustice:IsCastable() and v34 and ((v105 <= (1966 - (556 + 1407))) or not v95.HolyBlade:IsAvailable()) and (((v101 >= (1208 - (741 + 465))) and not v95.CrusadingStrikes:IsAvailable()) or (v101 >= (469 - (170 + 295))))) or ((704 + 631) >= (3037 + 269))) then
					if (((11926 - 7082) > (1868 + 385)) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v132 = 2 + 0;
			end
			if (((256 + 196) == (1682 - (957 + 273))) and (v132 == (0 + 0))) then
				if ((v105 >= (3 + 2)) or (v14:BuffUp(v95.EchoesofWrathBuff) and v14:HasTier(118 - 87, 10 - 6) and v95.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v95.JudgmentDebuff) or (v105 == (11 - 7))) and v14:BuffUp(v95.DivineResonanceBuff) and not v14:HasTier(153 - 122, 1782 - (389 + 1391))) or ((2860 + 1697) < (218 + 1869))) then
					local v194 = 0 - 0;
					while true do
						if (((4825 - (783 + 168)) == (13001 - 9127)) and (v194 == (0 + 0))) then
							v29 = v116();
							if (v29 or ((2249 - (309 + 2)) > (15154 - 10219))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v95.WakeofAshes:IsCastable() and v46 and (v105 <= (1214 - (1090 + 122))) and (v95.AvengingWrath:CooldownDown() or v95.Crusade:CooldownDown()) and (not v95.ExecutionSentence:IsAvailable() or (v95.ExecutionSentence:CooldownRemains() > (2 + 2)) or (v103 < (26 - 18)))) or ((2912 + 1343) < (4541 - (628 + 490)))) then
					if (((261 + 1193) <= (6167 - 3676)) and v24(v95.WakeofAshes, not v16:IsInRange(45 - 35))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v95.BladeofJustice:IsCastable() and v34 and not v16:DebuffUp(v95.ExpurgationDebuff) and (v105 <= (777 - (431 + 343))) and v14:HasTier(62 - 31, 5 - 3)) or ((3285 + 872) <= (359 + 2444))) then
					if (((6548 - (556 + 1139)) >= (2997 - (6 + 9))) and v24(v95.BladeofJustice, not v16:IsSpellInRange(v95.BladeofJustice))) then
						return "blade_of_justice generators 4";
					end
				end
				if (((757 + 3377) > (1720 + 1637)) and v95.DivineToll:IsCastable() and v39 and (v105 <= (171 - (28 + 141))) and ((v95.AvengingWrath:CooldownRemains() > (6 + 9)) or (v95.Crusade:CooldownRemains() > (18 - 3)) or (v103 < (6 + 2)))) then
					if (v24(v95.DivineToll, not v16:IsInRange(1347 - (486 + 831))) or ((8891 - 5474) < (8920 - 6386))) then
						return "divine_toll generators 6";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (15 - 10)) or ((3985 - (668 + 595)) <= (148 + 16))) then
				if ((v95.TemplarStrike:IsReady() and v45) or ((486 + 1922) < (5751 - 3642))) then
					if (v24(v95.TemplarStrike, not v16:IsInRange(300 - (23 + 267))) or ((1977 - (1129 + 815)) == (1842 - (371 + 16)))) then
						return "templar_strike generators 30";
					end
				end
				if ((v95.Judgment:IsReady() and v42 and ((v105 <= (1753 - (1326 + 424))) or not v95.BoundlessJudgment:IsAvailable())) or ((838 - 395) >= (14671 - 10656))) then
					if (((3500 - (88 + 30)) > (937 - (720 + 51))) and v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment))) then
						return "judgment generators 32";
					end
				end
				if ((v95.HammerofWrath:IsReady() and v41 and ((v105 <= (6 - 3)) or (v16:HealthPercentage() > (1796 - (421 + 1355))) or not v95.VanguardsMomentum:IsAvailable())) or ((461 - 181) == (1503 + 1556))) then
					if (((2964 - (286 + 797)) > (4726 - 3433)) and v24(v95.HammerofWrath, not v16:IsSpellInRange(v95.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((3903 - 1546) == (2796 - (397 + 42))) and v95.CrusaderStrike:IsCastable() and v36) then
					if (((39 + 84) == (923 - (24 + 776))) and v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v132 = 8 - 2;
			end
			if ((v132 == (788 - (222 + 563))) or ((2326 - 1270) >= (2443 + 949))) then
				if ((v95.Judgment:IsReady() and v42 and v16:DebuffDown(v95.JudgmentDebuff) and ((v105 <= (193 - (23 + 167))) or not v95.BoundlessJudgment:IsAvailable())) or ((2879 - (690 + 1108)) < (388 + 687))) then
					if (v24(v95.Judgment, not v16:IsSpellInRange(v95.Judgment)) or ((866 + 183) >= (5280 - (40 + 808)))) then
						return "judgment generators 20";
					end
				end
				if ((v16:HealthPercentage() <= (4 + 16)) or v14:BuffUp(v95.AvengingWrathBuff) or v14:BuffUp(v95.CrusadeBuff) or v14:BuffUp(v95.EmpyreanPowerBuff) or ((18232 - 13464) <= (809 + 37))) then
					local v195 = 0 + 0;
					while true do
						if ((v195 == (0 + 0)) or ((3929 - (47 + 524)) <= (922 + 498))) then
							v29 = v116();
							if (v29 or ((10220 - 6481) <= (4493 - 1488))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v95.Consecration:IsCastable() and v35 and v16:DebuffDown(v95.ConsecrationDebuff) and (v101 >= (4 - 2))) or ((3385 - (1165 + 561)) >= (64 + 2070))) then
					if (v24(v95.Consecration, not v16:IsInRange(30 - 20)) or ((1244 + 2016) < (2834 - (341 + 138)))) then
						return "consecration generators 22";
					end
				end
				if ((v95.DivineHammer:IsCastable() and v37 and (v101 >= (1 + 1))) or ((1380 - 711) == (4549 - (89 + 237)))) then
					if (v24(v95.DivineHammer, not v16:IsInRange(32 - 22)) or ((3561 - 1869) < (1469 - (581 + 300)))) then
						return "divine_hammer generators 24";
					end
				end
				v132 = 1224 - (855 + 365);
			end
			if (((9 - 5) == v132) or ((1567 + 3230) < (4886 - (1030 + 205)))) then
				if ((v95.CrusaderStrike:IsCastable() and v36 and (v95.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v105 <= (2 + 0)) or ((v105 <= (289 - (156 + 130))) and (v95.BladeofJustice:CooldownRemains() > (v106 * (4 - 2)))) or ((v105 == (6 - 2)) and (v95.BladeofJustice:CooldownRemains() > (v106 * (3 - 1))) and (v95.Judgment:CooldownRemains() > (v106 * (1 + 1)))))) or ((2436 + 1741) > (4919 - (10 + 59)))) then
					if (v24(v95.CrusaderStrike, not v16:IsSpellInRange(v95.CrusaderStrike)) or ((114 + 286) > (5471 - 4360))) then
						return "crusader_strike generators 26";
					end
				end
				v29 = v116();
				if (((4214 - (671 + 492)) > (801 + 204)) and v29) then
					return v29;
				end
				if (((4908 - (369 + 846)) <= (1161 + 3221)) and v95.TemplarSlash:IsReady() and v44) then
					if (v24(v95.TemplarSlash, not v16:IsInRange(9 + 1)) or ((5227 - (1036 + 909)) > (3260 + 840))) then
						return "templar_slash generators 28";
					end
				end
				v132 = 8 - 3;
			end
			if ((v132 == (209 - (11 + 192))) or ((1810 + 1770) < (3019 - (135 + 40)))) then
				if (((215 - 126) < (2707 + 1783)) and v95.ArcaneTorrent:IsCastable() and ((v85 and v32) or not v85) and v84 and (v105 < (10 - 5)) and (v81 < v103)) then
					if (v24(v95.ArcaneTorrent, not v16:IsInRange(14 - 4)) or ((5159 - (50 + 126)) < (5034 - 3226))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((848 + 2981) > (5182 - (1233 + 180))) and v95.Consecration:IsCastable() and v35) then
					if (((2454 - (522 + 447)) <= (4325 - (107 + 1314))) and v24(v95.Consecration, not v16:IsInRange(5 + 5))) then
						return "consecration generators 30";
					end
				end
				if (((13007 - 8738) == (1814 + 2455)) and v95.DivineHammer:IsCastable() and v37) then
					if (((768 - 381) <= (11007 - 8225)) and v24(v95.DivineHammer, not v16:IsInRange(1920 - (716 + 1194)))) then
						return "divine_hammer generators 32";
					end
				end
				break;
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
		local v155 = 0 + 0;
		while true do
			if ((v155 == (1 + 0)) or ((2402 - (74 + 429)) <= (1768 - 851))) then
				v59 = EpicSettings.Settings['useDivineShield'];
				v60 = EpicSettings.Settings['useLayonHands'];
				v61 = EpicSettings.Settings['useLayonHandsFocus'];
				v155 = 1 + 1;
			end
			if ((v155 == (13 - 7)) or ((3051 + 1261) <= (2700 - 1824))) then
				v93 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((5518 - 3286) <= (3029 - (279 + 154))) and (v155 == (778 - (454 + 324)))) then
				v56 = EpicSettings.Settings['useRebuke'];
				v57 = EpicSettings.Settings['useHammerofJustice'];
				v58 = EpicSettings.Settings['useDivineProtection'];
				v155 = 1 + 0;
			end
			if (((2112 - (12 + 5)) < (1988 + 1698)) and (v155 == (7 - 4))) then
				v65 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
				v66 = EpicSettings.Settings['divineShieldHP'] or (1093 - (277 + 816));
				v67 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v155 = 1187 - (1058 + 125);
			end
			if ((v155 == (1 + 3)) or ((2570 - (815 + 160)) >= (19196 - 14722))) then
				v68 = EpicSettings.Settings['layonHandsFocusHP'] or (0 - 0);
				v69 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v70 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v155 = 1903 - (41 + 1857);
			end
			if ((v155 == (1895 - (1222 + 671))) or ((11937 - 7318) < (4142 - 1260))) then
				v62 = EpicSettings.Settings['useWordofGloryFocus'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v155 = 1185 - (229 + 953);
			end
			if ((v155 == (1779 - (1111 + 663))) or ((1873 - (874 + 705)) >= (677 + 4154))) then
				v71 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v72 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v73 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v155 = 12 - 6;
			end
		end
	end
	local function v120()
		local v156 = 0 + 0;
		while true do
			if (((2708 - (642 + 37)) <= (704 + 2380)) and (v156 == (1 + 0))) then
				v80 = EpicSettings.Settings['InterruptThreshold'];
				v75 = EpicSettings.Settings['DispelDebuffs'];
				v74 = EpicSettings.Settings['DispelBuffs'];
				v156 = 4 - 2;
			end
			if ((v156 == (459 - (233 + 221))) or ((4710 - 2673) == (2131 + 289))) then
				v76 = EpicSettings.Settings['handleAfflicted'];
				v77 = EpicSettings.Settings['HandleIncorporeal'];
				v91 = EpicSettings.Settings['HealOOC'];
				v156 = 1547 - (718 + 823);
			end
			if (((2806 + 1652) > (4709 - (266 + 539))) and (v156 == (0 - 0))) then
				v81 = EpicSettings.Settings['fightRemainsCheck'] or (1225 - (636 + 589));
				v78 = EpicSettings.Settings['InterruptWithStun'];
				v79 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v156 = 2 - 1;
			end
			if (((898 - 462) >= (98 + 25)) and (v156 == (2 + 2))) then
				v89 = EpicSettings.Settings['healthstoneHP'] or (1015 - (657 + 358));
				v88 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v90 = EpicSettings.Settings['HealingPotionName'] or "";
				v156 = 11 - 6;
			end
			if (((1687 - (1151 + 36)) < (1754 + 62)) and (v156 == (1 + 1))) then
				v82 = EpicSettings.Settings['useTrinkets'];
				v84 = EpicSettings.Settings['useRacials'];
				v83 = EpicSettings.Settings['trinketsWithCD'];
				v156 = 8 - 5;
			end
			if (((5406 - (1552 + 280)) == (4408 - (64 + 770))) and (v156 == (3 + 0))) then
				v85 = EpicSettings.Settings['racialsWithCD'];
				v87 = EpicSettings.Settings['useHealthstone'];
				v86 = EpicSettings.Settings['useHealingPotion'];
				v156 = 8 - 4;
			end
			if (((40 + 181) < (1633 - (157 + 1086))) and (v156 == (11 - 5))) then
				v92 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
		end
	end
	local function v121()
		local v157 = 0 - 0;
		local v158;
		while true do
			if ((v157 == (5 - 1)) or ((3032 - (599 + 220)) <= (2829 - 1408))) then
				if (((4989 - (1813 + 118)) < (3553 + 1307)) and not v14:AffectingCombat()) then
					if ((v95.RetributionAura:IsCastable() and (v109())) or ((2513 - (841 + 376)) >= (6229 - 1783))) then
						if (v24(v95.RetributionAura) or ((324 + 1069) > (12252 - 7763))) then
							return "retribution_aura";
						end
					end
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) or ((5283 - (464 + 395)) < (69 - 42))) then
					if (v14:AffectingCombat() or ((960 + 1037) > (4652 - (467 + 370)))) then
						if (((7160 - 3695) > (1405 + 508)) and v95.Intercession:IsCastable()) then
							if (((2512 - 1779) < (284 + 1535)) and v24(v95.Intercession, not v16:IsInRange(69 - 39), true)) then
								return "intercession target";
							end
						end
					elseif (v95.Redemption:IsCastable() or ((4915 - (150 + 370)) == (6037 - (74 + 1208)))) then
						if (v24(v95.Redemption, not v16:IsInRange(73 - 43), true) or ((17988 - 14195) < (1686 + 683))) then
							return "redemption target";
						end
					end
				end
				if ((v95.Redemption:IsCastable() and v95.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((4474 - (14 + 376)) == (459 - 194))) then
					if (((2820 + 1538) == (3829 + 529)) and v24(v99.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((2993 + 145) < (2909 - 1916))) then
					if (((2506 + 824) > (2401 - (23 + 55))) and v95.Intercession:IsCastable() and (v14:HolyPower() >= (6 - 3)) and v95.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (v24(v99.IntercessionMouseover) or ((2420 + 1206) == (3583 + 406))) then
							return "Intercession mouseover";
						end
					end
				end
				v157 = 7 - 2;
			end
			if ((v157 == (3 + 4)) or ((1817 - (652 + 249)) == (7147 - 4476))) then
				if (((2140 - (708 + 1160)) == (738 - 466)) and not v14:AffectingCombat() and v30 and v94.TargetIsValid()) then
					local v196 = 0 - 0;
					while true do
						if (((4276 - (10 + 17)) <= (1087 + 3752)) and (v196 == (1732 - (1400 + 332)))) then
							v158 = v114();
							if (((5325 - 2548) < (5108 - (242 + 1666))) and v158) then
								return v158;
							end
							break;
						end
					end
				end
				if (((41 + 54) < (718 + 1239)) and v14:AffectingCombat() and v94.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					if (((704 + 122) < (2657 - (850 + 90))) and v60 and (v14:HealthPercentage() <= v67) and v95.LayonHands:IsReady() and v14:DebuffDown(v95.ForbearanceDebuff)) then
						if (((2496 - 1070) >= (2495 - (360 + 1030))) and v24(v95.LayonHands)) then
							return "lay_on_hands_player defensive";
						end
					end
					if (((2438 + 316) <= (9536 - 6157)) and v59 and (v14:HealthPercentage() <= v66) and v95.DivineShield:IsCastable() and v14:DebuffDown(v95.ForbearanceDebuff)) then
						if (v24(v95.DivineShield) or ((5402 - 1475) == (3074 - (909 + 752)))) then
							return "divine_shield defensive";
						end
					end
					if ((v58 and v95.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v65)) or ((2377 - (109 + 1114)) <= (1442 - 654))) then
						if (v24(v95.DivineProtection) or ((640 + 1003) > (3621 - (6 + 236)))) then
							return "divine_protection defensive";
						end
					end
					if ((v96.Healthstone:IsReady() and v87 and (v14:HealthPercentage() <= v89)) or ((1766 + 1037) > (3662 + 887))) then
						if (v24(v99.Healthstone) or ((518 - 298) >= (5278 - 2256))) then
							return "healthstone defensive";
						end
					end
					if (((3955 - (1076 + 57)) == (465 + 2357)) and v86 and (v14:HealthPercentage() <= v88)) then
						local v203 = 689 - (579 + 110);
						while true do
							if ((v203 == (0 + 0)) or ((939 + 122) == (986 + 871))) then
								if (((3167 - (174 + 233)) > (3809 - 2445)) and (v90 == "Refreshing Healing Potion")) then
									if (v96.RefreshingHealingPotion:IsReady() or ((8603 - 3701) <= (1599 + 1996))) then
										if (v24(v99.RefreshingHealingPotion) or ((5026 - (663 + 511)) == (262 + 31))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if ((v90 == "Dreamwalker's Healing Potion") or ((339 + 1220) == (14144 - 9556))) then
									if (v96.DreamwalkersHealingPotion:IsReady() or ((2716 + 1768) == (1855 - 1067))) then
										if (((11058 - 6490) >= (1865 + 2042)) and v24(v99.RefreshingHealingPotion)) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if (((2425 - 1179) < (2473 + 997)) and (v81 < v103)) then
						v158 = v115();
						if (((372 + 3696) >= (1694 - (478 + 244))) and v158) then
							return v158;
						end
					end
					v158 = v117();
					if (((1010 - (440 + 77)) < (1771 + 2122)) and v158) then
						return v158;
					end
					if (v24(v95.Pool) or ((5390 - 3917) >= (4888 - (655 + 901)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v157 == (2 + 4)) or ((3102 + 949) <= (782 + 375))) then
				if (((2433 - 1829) < (4326 - (695 + 750))) and v158) then
					return v158;
				end
				if (v13 or ((3073 - 2173) == (5211 - 1834))) then
					if (((17932 - 13473) > (942 - (285 + 66))) and v75) then
						local v204 = 0 - 0;
						while true do
							if (((4708 - (682 + 628)) >= (387 + 2008)) and (v204 == (299 - (176 + 123)))) then
								v158 = v110();
								if (v158 or ((914 + 1269) >= (2049 + 775))) then
									return v158;
								end
								break;
							end
						end
					end
				end
				v158 = v112();
				if (((2205 - (239 + 30)) == (527 + 1409)) and v158) then
					return v158;
				end
				v157 = 7 + 0;
			end
			if (((4 - 1) == v157) or ((15075 - 10243) < (4628 - (306 + 9)))) then
				v158 = v94.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 139 - 99, 5 + 20);
				if (((2509 + 1579) > (1865 + 2009)) and v158) then
					return v158;
				end
				if (((12387 - 8055) == (5707 - (1140 + 235))) and v95.BlessingofFreedom:IsReady() and v94.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
					if (((2545 + 1454) >= (2660 + 240)) and v24(v99.BlessingofFreedomFocus)) then
						return "blessing_of_freedom combat";
					end
				end
				v104 = v108();
				v157 = 2 + 2;
			end
			if ((v157 == (57 - (33 + 19))) or ((912 + 1613) > (12180 - 8116))) then
				if (((1926 + 2445) == (8571 - 4200)) and (v94.TargetIsValid() or v14:AffectingCombat())) then
					local v197 = 0 + 0;
					while true do
						if ((v197 == (689 - (586 + 103))) or ((25 + 241) > (15350 - 10364))) then
							v102 = v9.BossFightRemains(nil, true);
							v103 = v102;
							v197 = 1489 - (1309 + 179);
						end
						if (((3594 - 1603) >= (403 + 522)) and (v197 == (5 - 3))) then
							v105 = v14:HolyPower();
							break;
						end
						if (((344 + 111) < (4361 - 2308)) and (v197 == (1 - 0))) then
							if ((v103 == (11720 - (295 + 314))) or ((2028 - 1202) == (6813 - (1300 + 662)))) then
								v103 = v9.FightRemains(v100, false);
							end
							v106 = v14:GCD();
							v197 = 6 - 4;
						end
					end
				end
				if (((1938 - (1178 + 577)) == (96 + 87)) and v76) then
					local v198 = 0 - 0;
					while true do
						if (((2564 - (851 + 554)) <= (1582 + 206)) and (v198 == (0 - 0))) then
							if (v72 or ((7616 - 4109) > (4620 - (115 + 187)))) then
								local v205 = 0 + 0;
								while true do
									if ((v205 == (0 + 0)) or ((12117 - 9042) <= (4126 - (160 + 1001)))) then
										v158 = v94.HandleAfflicted(v95.CleanseToxins, v99.CleanseToxinsMouseover, 35 + 5);
										if (((942 + 423) <= (4116 - 2105)) and v158) then
											return v158;
										end
										break;
									end
								end
							end
							if ((v73 and (v105 > (360 - (237 + 121)))) or ((3673 - (525 + 372)) > (6777 - 3202))) then
								v158 = v94.HandleAfflicted(v95.WordofGlory, v99.WordofGloryMouseover, 131 - 91, true);
								if (v158 or ((2696 - (96 + 46)) == (5581 - (643 + 134)))) then
									return v158;
								end
							end
							break;
						end
					end
				end
				if (((931 + 1646) == (6179 - 3602)) and v77) then
					local v199 = 0 - 0;
					while true do
						if ((v199 == (1 + 0)) or ((11 - 5) >= (3860 - 1971))) then
							v158 = v94.HandleIncorporeal(v95.TurnEvil, v99.TurnEvilMouseOver, 749 - (316 + 403), true);
							if (((337 + 169) <= (5201 - 3309)) and v158) then
								return v158;
							end
							break;
						end
						if ((v199 == (0 + 0)) or ((5056 - 3048) > (1572 + 646))) then
							v158 = v94.HandleIncorporeal(v95.Repentance, v99.RepentanceMouseOver, 10 + 20, true);
							if (((1312 - 933) <= (19805 - 15658)) and v158) then
								return v158;
							end
							v199 = 1 - 0;
						end
					end
				end
				v158 = v111();
				v157 = 1 + 5;
			end
			if ((v157 == (3 - 1)) or ((221 + 4293) <= (2968 - 1959))) then
				v100 = v14:GetEnemiesInMeleeRange(25 - (12 + 5));
				if (v31 or ((13578 - 10082) == (2542 - 1350))) then
					v101 = #v100;
				else
					local v200 = 0 - 0;
					while true do
						if ((v200 == (0 - 0)) or ((43 + 165) == (4932 - (1656 + 317)))) then
							v100 = {};
							v101 = 1 + 0;
							break;
						end
					end
				end
				if (((3428 + 849) >= (3491 - 2178)) and not v14:AffectingCombat() and v14:IsMounted()) then
					if (((12732 - 10145) < (3528 - (5 + 349))) and v95.CrusaderAura:IsCastable() and (v14:BuffDown(v95.CrusaderAura))) then
						if (v24(v95.CrusaderAura) or ((19569 - 15449) <= (3469 - (266 + 1005)))) then
							return "crusader_aura";
						end
					end
				end
				if (v14:AffectingCombat() or v75 or ((1052 + 544) == (2927 - 2069))) then
					local v201 = 0 - 0;
					local v202;
					while true do
						if (((4916 - (561 + 1135)) == (4196 - 976)) and (v201 == (0 - 0))) then
							v202 = v75 and v95.CleanseToxins:IsReady() and v33;
							v158 = v94.FocusUnit(v202, v99, 1086 - (507 + 559), nil, 62 - 37);
							v201 = 3 - 2;
						end
						if ((v201 == (389 - (212 + 176))) or ((2307 - (250 + 655)) > (9871 - 6251))) then
							if (((4497 - 1923) == (4026 - 1452)) and v158) then
								return v158;
							end
							break;
						end
					end
				end
				v157 = 1959 - (1869 + 87);
			end
			if (((6236 - 4438) < (4658 - (484 + 1417))) and (v157 == (2 - 1))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((631 - 254) > (3377 - (48 + 725)))) then
					return v158;
				end
				v157 = 2 - 0;
			end
			if (((1523 - 955) < (530 + 381)) and (v157 == (0 - 0))) then
				v119();
				v118();
				v120();
				v30 = EpicSettings.Toggles['ooc'];
				v157 = 1 + 0;
			end
		end
	end
	local function v122()
		local v159 = 0 + 0;
		while true do
			if (((4138 - (152 + 701)) < (5539 - (430 + 881))) and (v159 == (0 + 0))) then
				v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v98();
				break;
			end
		end
	end
	v20.SetAPL(965 - (557 + 338), v121, v122);
end;
return v0["Epix_Paladin_Retribution.lua"]();

